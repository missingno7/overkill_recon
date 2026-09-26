; Modern optional-module source; historical source filename unknown.
; Original resource: ROLAND.ENC; no relocation table in ENC stream.
locals
; Music stream bytes (per channel): 00..7Fh note (key = note + transpose + 18h, lasts
; the current length); ROL_LENGTH + n (n = 1..32 rows) sets the length; 80h..91h
; commands (StreamCommandHandlers); 92h..DFh stop all. Operands: TRANSPOSE b, VOLUME b,
; PITCH_ENVELOPE w w, SLIDE w b, EFFECT_PERIOD b, BEND_RANGE b, JUMP w, PROGRAM b, VELOCITY b.
ROL_END_PATTERN equ 80h
ROL_REST equ 81h
ROL_TIE equ 82h
ROL_STOP_ALL equ 83h
ROL_TRANSPOSE equ 84h
ROL_CHANNEL_END equ 85h
ROL_STEP_UP equ 86h
ROL_STEP_DOWN equ 87h
ROL_VOLUME equ 88h
ROL_PITCH_ENVELOPE equ 89h
ROL_SLIDE equ 8Ah
ROL_CLEAR_SLIDE equ 8Bh
ROL_EFFECT_PERIOD equ 8Ch
ROL_BEND_RANGE equ 8Dh
ROL_JUMP equ 8Eh
ROL_STEP_OFF equ 8Fh
ROL_PROGRAM equ 90h
ROL_VELOCITY equ 91h
ROL_LENGTH equ 0DFh

; MPU-401 ports (UART mode after init).
MPU_DATA_PORT equ 0330h
MPU_STATUS_PORT equ 0331h
; Channel record (RolandChannel0..7, 1Fh bytes).
; Note sounding (stream value), negative = none; rows until the next stream event.
ROC_NOTE equ 0
ROC_ROWS_LEFT equ 1
; Pitch-bend MSB last sent; note velocity; MIDI channel (0-based).
ROC_BEND_MSB equ 5
ROC_VELOCITY equ 6
ROC_MIDI_CHANNEL equ 7
ROC_ORDER_PTR equ 0Ah
ROC_STREAM equ 0Ch
; Last CC7 volume sent; written, never read.
ROC_VOLUME equ 0Eh
ROC_ACTIVE equ 10h
; Rows per note/rest, transpose, signed per-row note change.
ROC_LENGTH equ 11h
ROC_TRANSPOSE equ 12h
ROC_NOTE_STEP equ 13h
; Pitch envelope (89h): signed bend step (+15h unused), delay and count in effect periods.
ROC_ENV_STEP equ 14h
ROC_ENV_DELAY equ 16h
ROC_ENV_COUNT equ 17h
; Slide (8Ah): base bend added to 3Fh at note on, step per tick, ticks, countdown.
ROC_BEND_BASE equ 18h
ROC_SLIDE_STEP equ 19h
ROC_SLIDE_TICKS equ 1Ah
ROC_SLIDE_LEFT equ 1Bh
; Effect period counter and reload (8Ch).
ROC_PERIOD_COUNT equ 1Ch
ROC_PERIOD_RELOAD equ 1Dh
; Cleared by 85h only; never read.
ROC_UNUSED_1E equ 1Eh

driver segment byte public 'CODE'
assume cs:driver,ds:nothing,ss:nothing,es:nothing
    call MusicTick
    retf
    call DetectMpu401
    retf
; Module header (the game addresses +8/+9 as MODULE_MUSIC_REQUEST/CURRENT).
; Written by the game (word write: tune in +8, 0 in +9); 1..0Ah start a tune, others
; stop. Taken on the next tick by HandleMusicRequest.
MusicRequest db 0
; Tune now playing, 0 = none.
MusicCurrent db 0
; Never touched by the module.
HeaderUnused0A db 0, 0
; Timer ticks per sequencer row (from the song header), and its countdown.
Tempo db 0
TempoCountdown db 0
; Never read: the MPU-401 ports are hard-coded (MPU_DATA_PORT/MPU_STATUS_PORT).
MpuPortUnused dw 0330h
HeaderUnused10 dw 0
ModuleIdent db 'Type : Roland', 0Dh, 0Ah, ' File : Overkill$Date : 03.11.92$'
    db 'Music by Sound Images (c) 1992'
; Pending tune latch (also set by stream commands 80h and 8Eh from MusicRequest).
PendingTune db 0
; Channel count of the current tune; written, never read.
ChannelCount dw 1
; Far entry +0, every timer interrupt (about 72.8 Hz): handles a music request, counts
; TempoCountdown down, updates the eight channels, reloads the countdown from Tempo.
MusicTick:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push ds
    push cs
    pop ds
    call HandleMusicRequest
    dec byte ptr ds:[TempoCountdown]
    mov di, offset RolandChannel0
    call UpdateChannel
    mov di, offset RolandChannel1
    call UpdateChannel
    mov di, offset RolandChannel2
    call UpdateChannel
    mov di, offset RolandChannel3
    call UpdateChannel
    mov di, offset RolandChannel4
    call UpdateChannel
    mov di, offset RolandChannel5
    call UpdateChannel
    mov di, offset RolandChannel6
    call UpdateChannel
    mov di, offset RolandChannel7
    call UpdateChannel
    cmp byte ptr ds:[TempoCountdown], 0
    jne TickExit
    mov al, byte ptr ds:[Tempo]
    mov byte ptr ds:[TempoCountdown], al
TickExit:
    pop ds
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
; DI = channel (skipped when inactive). On a row tick: ROC_ROWS_LEFT - 1; at 0 read the
; stream (no effects that tick), otherwise the note step. Every tick: slide, pitch envelope.
UpdateChannel:
    xor al, al
    cmp al, byte ptr ds:[di + ROC_ACTIVE]
    je UpdateChannelDone
    mov bx, word ptr ds:[di + ROC_STREAM]
    cmp al, byte ptr ds:[TempoCountdown]
    jne UpdateChannelEffects
    dec byte ptr ds:[di + ROC_ROWS_LEFT]
    je ReadStream
    call StepNote
UpdateChannelEffects:
    call SlideTick
    call PitchEnvTick
UpdateChannelDone:
    ret
; BX = ROC_STREAM. Consumes bytes until one takes time (note, rest, tie). A note turns
; the old one off, sends a pitch bend of 3Fh + ROC_BEND_BASE when changed, then note on.
ReadStream:
    mov al, byte ptr ds:[bx]
    inc bx
    or al, al
    js DispatchStreamByte
    push ax
    mov ah, byte ptr ds:[di + ROC_NOTE]
    or ah, ah
    js StartNewNote
    mov ah, 080h
    call SendNoteMessage
StartNewNote:
    pop ax
    mov byte ptr ds:[di + ROC_NOTE], al
    mov al, byte ptr ds:[di + ROC_SLIDE_TICKS]
    mov byte ptr ds:[di + ROC_SLIDE_LEFT], al
    mov al, byte ptr ds:[di + ROC_BEND_BASE]
    add al, 03Fh
    cmp al, byte ptr ds:[di + ROC_BEND_MSB]
    je SendNoteOn
    mov byte ptr ds:[di + ROC_BEND_MSB], al
    call SendPitchBend
SendNoteOn:
    mov ah, 090h
    call SendNoteMessage
; Tie (82h), and the tail of a note: store the stream pointer, reload the row count.
StreamCmd82:
    mov word ptr ds:[di + ROC_STREAM], bx
    mov al, byte ptr ds:[di + ROC_LENGTH]
    mov byte ptr ds:[di + ROC_ROWS_LEFT], al
    ret
StreamCmd81:
    mov ah, 080h
    call SendNoteMessage
    mov byte ptr ds:[di + ROC_NOTE], 0FFh
    jmp short StreamCmd82
; E0h..FFh length, 80h..91h command table, 92h..DFh stop all (signed compare).
DispatchStreamByte:
    cmp al, 0E0h
    jae SetEventLength
    cmp al, 091h
    jg StopAllChannels
    shl al, 1
    xor ah, ah
    mov si, offset StreamCommandHandlers
    add si, ax
    jmp word ptr ds:[si]
SetEventLength:
    sub al, 0DFh
    mov byte ptr ds:[di + ROC_LENGTH], al
    jmp short ReadStream
StreamCmd91:
    mov al, byte ptr ds:[bx]
    inc bx
    mov byte ptr ds:[di + ROC_VELOCITY], al
    jmp short ReadStream
StepNote:
    mov al, byte ptr ds:[di + ROC_NOTE_STEP]
    or al, al
    je StepNoteDone
    push ax
    mov al, byte ptr ds:[di + ROC_NOTE]
    mov ah, 080h
    call SendNoteMessage
    pop ax
    add al, byte ptr ds:[di + ROC_NOTE]
    mov byte ptr ds:[di + ROC_NOTE], al
    mov ah, 090h
    call SendNoteMessage
StepNoteDone:
    ret
; All Notes Off (Bn 7B 00) on every channel record, all inactive, request/current cleared.
StopAllChannels:
    mov di, offset RolandChannel0
    mov cx, 8
StopAllChannelsLoop:
    mov byte ptr ds:[di + ROC_ACTIVE], ch
    mov al, byte ptr ds:[di + ROC_MIDI_CHANNEL]
    or al, 0B0h
    call MidiOut
    mov al, 07Bh
    call MidiOut
    xor al, al
    call MidiOut
    add di, 01Fh
    loop StopAllChannelsLoop
    mov word ptr ds:[MusicRequest], cx
    ret
; While ROC_SLIDE_TICKS and ROC_SLIDE_LEFT: bend MSB += ROC_SLIDE_STEP, send the bend.
SlideTick:
    xor al, al
    cmp al, byte ptr ds:[di + ROC_SLIDE_TICKS]
    je EffectDone
    cmp al, byte ptr ds:[di + ROC_SLIDE_LEFT]
    je EffectDone
    dec byte ptr ds:[di + ROC_SLIDE_LEFT]
    mov al, byte ptr ds:[di + ROC_SLIDE_STEP]
    add byte ptr ds:[di + ROC_BEND_MSB], al
    jmp near ptr SendPitchBend
; Every ROC_PERIOD_RELOAD ticks: after ROC_ENV_DELAY periods, bend MSB += ROC_ENV_STEP for
; ROC_ENV_COUNT periods.
PitchEnvTick:
    dec byte ptr ds:[di + ROC_PERIOD_COUNT]
    jne EffectDone
    mov al, byte ptr ds:[di + ROC_PERIOD_RELOAD]
    mov byte ptr ds:[di + ROC_PERIOD_COUNT], al
    xor al, al
    cmp al, byte ptr ds:[di + ROC_ENV_DELAY]
    je PitchEnvStep
    dec byte ptr ds:[di + ROC_ENV_DELAY]
    je PitchEnvStep
EffectDone:
    ret
PitchEnvStep:
    cmp al, byte ptr ds:[di + ROC_ENV_COUNT]
    je EffectDone
    dec byte ptr ds:[di + ROC_ENV_COUNT]
    mov al, byte ptr ds:[di + ROC_ENV_STEP]
    add byte ptr ds:[di + ROC_BEND_MSB], al
    jmp near ptr SendPitchBend
StreamCmd90:
    mov al, byte ptr ds:[di + ROC_MIDI_CHANNEL]
    or al, 0C0h
    call MidiOut
    mov al, byte ptr ds:[bx]
    inc bx
    call MidiOut
    mov al, byte ptr ds:[di + ROC_MIDI_CHANNEL]
    or al, 0B0h
    call MidiOut
    mov al, 7
    call MidiOut
    mov al, 064h
    mov byte ptr ds:[di + ROC_VOLUME], al
    call MidiOut
    jmp near ptr ReadStream
; Volume: sends CC 07 b without a status byte, relying on the running status Bn left by
; the program change (90h) just before it, the only place the data uses it.
StreamCmd88:
    mov al, 7
    call MidiOut
    mov al, ds:[bx]
    inc bx
    mov ds:[di + ROC_VOLUME], al
    call MidiOut
    jmp near ptr ReadStream
StreamCommandHandlers label word
    dw offset StreamCmd80, offset StreamCmd81, offset StreamCmd82, offset StopAllChannels
    dw offset StreamCmd84, offset StreamCmd85, offset StreamCmd86, offset StreamCmd87
    dw offset StreamCmd88, offset StreamCmd89, offset StreamCmd8A, offset StreamCmd8B
    dw offset StreamCmd8C, offset StreamCmd8D, offset StreamCmd8E, offset StreamCmd8F
    dw offset StreamCmd90, offset StreamCmd91
OrderLoop:
    mov bx, ds:[bx]
    mov cx, ds:[bx]
    inc bx
    inc bx
    mov ds:[di + ROC_ORDER_PTR], bx
    mov ds:[di + ROC_STREAM], cx
    mov bx, cx
    jmp near ptr ReadStream
StreamCmd80:
    mov al, ds:[MusicRequest]
    mov ds:[PendingTune], al
    mov bx, ds:[di + ROC_ORDER_PTR]
    mov cx, ds:[bx]
    inc bx
    inc bx
    jcxz OrderLoop
    mov ds:[di + ROC_ORDER_PTR], bx
    mov ds:[di + ROC_STREAM], cx
    mov bx, cx
    jmp near ptr ReadStream
StreamCmd84:
    mov al, ds:[bx]
    inc bx
    mov ds:[di + ROC_TRANSPOSE], al
    jmp near ptr ReadStream
StreamCmd85:
    mov ah, 80h
    call SendNoteMessage
    xor al, al
    mov ds:[di + ROC_ACTIVE], al
    mov ds:[di + ROC_UNUSED_1E], al
    ret
StreamCmd86:
    mov byte ptr ds:[di + ROC_NOTE_STEP], 1
    jmp near ptr ReadStream
StreamCmd87:
    mov byte ptr ds:[di + ROC_NOTE_STEP], 0FFh
    jmp near ptr ReadStream
StreamCmd8F:
    mov byte ptr ds:[di + ROC_NOTE_STEP], 0
    jmp near ptr ReadStream
StreamCmd89:
    mov ax, ds:[bx]
    mov ds:[di + ROC_ENV_STEP], ax
    inc bx
    inc bx
    mov ax, ds:[bx]
    mov ds:[di + ROC_ENV_DELAY], ax
    inc bx
    inc bx
    jmp near ptr ReadStream
StreamCmd8A:
    mov ax, ds:[bx]
    mov ds:[di + ROC_BEND_BASE], ax
    inc bx
    inc bx
    mov al, ds:[bx]
    mov ds:[di + ROC_SLIDE_TICKS], al
    inc bx
    jmp near ptr ReadStream
StreamCmd8B:
    xor al, al
    mov ds:[di + ROC_SLIDE_TICKS], al
    mov ds:[di + ROC_BEND_BASE], al
    jmp near ptr ReadStream
StreamCmd8C:
    mov al, ds:[bx]
    inc bx
    mov ds:[di + ROC_PERIOD_RELOAD], al
    jmp near ptr ReadStream
; Bend range b through RPN 0 (Bn 64 00, Bn 65 00, Bn 06 b); ignored by an MT-32.
StreamCmd8D:
    mov ah, ds:[di + ROC_MIDI_CHANNEL]
    mov al, ah
    add al, 0B0h
    call MidiOut
    mov al, 64h
    call MidiOut
    xor al, al
    call MidiOut
    mov al, ah
    mov al, ah
    add al, 0B0h
    call MidiOut
    mov al, 65h
    call MidiOut
    xor al, al
    call MidiOut
    mov al, ah
    add al, 0B0h
    call MidiOut
    mov al, 6
    call MidiOut
    mov al, ds:[bx]
    call MidiOut
    inc bx
    jmp near ptr ReadStream
StreamCmd8E:
    mov bx, ds:[bx]
    mov al, ds:[MusicRequest]
    mov ds:[PendingTune], al
    jmp near ptr ReadStream
; Latch MusicRequest into PendingTune when nothing is current; then stop all and, for
; tunes 1..0Ah, start it: Tempo, channel count and per channel its order list.
HandleMusicRequest:
    xor ah, ah
    cmp ah, byte ptr ds:[MusicCurrent]
    jne CheckPendingTune
    mov al, byte ptr ds:[MusicRequest]
    mov byte ptr ds:[PendingTune], al
CheckPendingTune:
    mov al, byte ptr ds:[PendingTune]
    or al, al
    je RequestDone
    mov byte ptr ds:[MusicRequest], ah
    mov byte ptr ds:[PendingTune], ah
    push ax
    call StopAllChannels
    pop ax
    cmp al, 0Bh
    jae RequestDone
    mov byte ptr ds:[MusicCurrent], al
    shl al, 1
    mov si, offset SongTable - 2
    add si, ax
    lodsw
    mov si, ax
    lodsb
    mov byte ptr ds:[Tempo], al
    lodsb
    mov cl, al
    xor ch, ch
    mov word ptr ds:[ChannelCount], cx
    mov dx, 01FFh
    mov byte ptr ds:[TempoCountdown], dh
    mov di, offset RolandChannel0
StartTuneChannel:
    lodsw
    mov bx, ax
    mov ax, word ptr ds:[bx]
    inc bx
    inc bx
    mov word ptr ds:[di + ROC_ORDER_PTR], bx
    mov word ptr ds:[di + ROC_STREAM], ax
    mov byte ptr ds:[di + ROC_TRANSPOSE], ch
    mov byte ptr ds:[di + ROC_NOTE_STEP], ch
    mov byte ptr ds:[di + ROC_ENV_COUNT], ch
    mov byte ptr ds:[di + ROC_SLIDE_TICKS], ch
    mov byte ptr ds:[di + ROC_BEND_BASE], ch
    mov byte ptr ds:[di + ROC_ROWS_LEFT], dh
    mov byte ptr ds:[di + ROC_ACTIVE], dh
    add di, 01Fh
    loop StartTuneChannel
RequestDone:
    ret
; Pitch bend En 00 (ROC_BEND_MSB & 7Fh).
SendPitchBend:
    mov al, byte ptr ds:[di + ROC_MIDI_CHANNEL]
    or al, 0E0h
    call MidiOut
    xor al, al
    call MidiOut
    mov al, byte ptr ds:[di + ROC_BEND_MSB]
    and al, 07Fh
    call MidiOut
    ret
; Far entry +4, called once by the game's LoadSoundModule: probe the MPU-401 (27 resets),
; enter UART mode and send the MT-32 setup (SysexTable). AL = 1 when found, else 0.
DetectMpu401:
    push ds
    push cs
    pop ds
    push cx
    push dx
    mov cx, 01Bh
ProbeLoop:
    call MpuResetProbe
    cmp al, 0FEh
    je MpuFound
    loop ProbeLoop
    pop dx
    pop cx
    pop ds
    xor al, al
    ret
MpuFound:
    mov al, 0FFh
    call MpuCommand
    call MpuShortDelay
    mov al, 03Fh
    call MpuCommand
    push si
    call MpuShortDelay
    mov si, offset SysexTable
SendSysexLoop:
    lodsw
    or ax, ax
    je SysexDone
    push si
    mov si, ax
    call SendSysex
    pop si
    jmp short SendSysexLoop
SysexDone:
    pop si
    pop dx
    pop cx
    pop ds
    mov al, 1
    ret
MpuShortDelay:
    push ax
    push cx
    push dx
    mov cx, 064h
    mov dx, MPU_DATA_PORT
MpuShortDelayLoop:
    in al, dx
    loop MpuShortDelayLoop
    pop dx
    pop cx
    pop ax
    ret
MpuResetProbe:
    push cx
    mov dx, MPU_STATUS_PORT
    mov cx, 0FFFFh
ProbeWaitReady:
    in al, dx
    test al, 040h
    loopne ProbeWaitReady
    mov al, 0FFh
    out dx, al
    mov cx, 0FFFFh
ProbeWaitData:
    in al, dx
    test al, 080h
    loopne ProbeWaitData
    dec dx
    in al, dx
    pop cx
    ret
; AL = MPU-401 command: wait, write it, wait for and read the acknowledge (no timeout).
MpuCommand:
    push ax
    push dx
    mov dx, MPU_STATUS_PORT
    mov ah, al
CommandWaitReady:
    in al, dx
    add al, al
    js CommandWaitReady
    mov al, ah
    out dx, al
CommandWaitAck:
    in al, dx
    or al, al
    js CommandWaitAck
    dec dx
    in al, dx
    pop dx
    pop ax
    ret
; AL = MIDI byte: wait for the MPU-401 to accept data (no timeout), write it.
MidiOut:
    push ax
    push dx
    mov dx, MPU_STATUS_PORT
    mov ah, al
MidiOutWait:
    in al, dx
    add al, al
    js MidiOutWait
    mov al, ah
    dec dx
    out dx, al
    pop dx
    pop ax
    ret
; AH = 80h or 90h: note off/on with key ROC_NOTE + ROC_TRANSPOSE + 18h, ROC_VELOCITY.
SendNoteMessage:
    mov al, byte ptr ds:[di + ROC_MIDI_CHANNEL]
    or al, ah
    call MidiOut
    mov al, byte ptr ds:[di + ROC_NOTE]
    add al, byte ptr ds:[di + ROC_TRANSPOSE]
    add al, 018h
    call MidiOut
    mov al, byte ptr ds:[di + ROC_VELOCITY]
    call MidiOut
    ret
; SI = sysex body: send F0 41 10 16 12 (Roland DT1 to the MT-32), then the body through F7.
SendSysex:
    push ax
    mov al, 0F0h
    call MidiOut
    mov al, 041h
    call MidiOut
    mov al, 010h
    call MidiOut
    mov al, 016h
    call MidiOut
    mov al, 012h
    call MidiOut
SendSysexByte:
    lodsb
    call MidiOut
    cmp al, 0F7h
    jne SendSysexByte
    pop ax
    ret
; ---- Player data ----------------------------------------------------------------
; Eight channel records (ROC_* fields); records 0 and 1 play MIDI channel 10
; (rhythm), records 2..7 MIDI channels 2..7.
RolandChannel0 db 00h,00h,00h,00h,00h,6Eh,00h,09h,0B0h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
RolandChannel1 db 00h,00h,00h,00h,00h,6Eh,00h,09h,0B1h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
RolandChannel2 db 00h,00h,00h,00h,00h,60h,00h,01h,0B2h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
RolandChannel3 db 00h,00h,00h,00h,00h,60h,00h,02h,0B3h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
RolandChannel4 db 00h,00h,00h,00h,00h,60h,00h,03h,0B4h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
RolandChannel5 db 00h,00h,00h,00h,00h,60h,00h,04h,0B5h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
RolandChannel6 db 00h,00h,00h,00h,00h,60h,00h,05h,0B6h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
RolandChannel7 db 00h,00h,00h,00h,00h,60h,00h,06h,0B7h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h
; Song headers by tune number (MUSIC_* in the game); the code indexes SongTable - 2.
SongTable dw offset Tune1, offset Tune2, offset Tune3, offset Tune4, offset Tune5
    dw offset Tune6, offset Tune7, offset Tune8, offset Tune9, offset Tune10
; Tune 1: 5 timer ticks per row, 8 channels, order list per channel.
Tune1 db 5, 8
    dw offset Tune1Order0, offset Tune1Order1, offset Tune1Order2, offset Tune1Order3
    dw offset Tune1Order4, offset Tune1Order5, offset Tune1Order6, offset Tune1Order7
Tune1Order0 label word
    dw offset Tune1Pattern_05FC
Tune1OrderLoop_0568 label word
    dw offset Tune1Pattern_05FC
    dw offset Tune1Pattern_05FC
    dw offset Tune1Pattern_05FC
    dw offset Tune1Pattern_05FC
    dw offset Tune1Pattern_0645
    dw offset Tune1Pattern_066A
    dw 0, offset Tune1OrderLoop_0568
Tune1Order1 label word
    dw offset Tune1Pattern_0693
Tune1OrderLoop_057A label word
    dw offset Tune1Pattern_0696
    dw offset Tune1Pattern_0696
    dw offset Tune1Pattern_0696
    dw offset Tune1Pattern_0696
    dw offset Tune1Pattern_06A6
    dw offset Tune1Pattern_06B7
    dw 0, offset Tune1OrderLoop_057A
Tune1Order3 label word
    dw offset Tune1Pattern_06C8
    dw offset Tune1Pattern_06CC
Tune1OrderLoop_058E label word
    dw offset Tune1Pattern_06CC
    dw offset Tune1Pattern_06CC
    dw offset Tune1Pattern_06FE
    dw offset Tune1Pattern_06C8
    dw offset Tune1Pattern_06CC
    dw offset Tune1Pattern_06FE
    dw offset Tune1Pattern_0760
    dw offset Tune1Pattern_0792
    dw 0, offset Tune1OrderLoop_058E
Tune1Order4 label word
    dw offset Tune1Pattern_07A2
Tune1OrderLoop_05A4 label word
    dw offset Tune1Pattern_07A2
    dw offset Tune1Pattern_07B0
    dw offset Tune1Pattern_07A6
    dw offset Tune1Pattern_07B0
    dw offset Tune1Pattern_07BA
    dw offset Tune1Pattern_07C3
    dw 0, offset Tune1OrderLoop_05A4
Tune1Order5 label word
    dw offset Tune1Pattern_07D5
Tune1OrderLoop_05B6 label word
    dw offset Tune1Pattern_07D5
    dw offset Tune1Pattern_07E3
    dw offset Tune1Pattern_07D5
    dw offset Tune1Pattern_07E3
    dw offset Tune1Pattern_07ED
    dw offset Tune1Pattern_07F6
    dw 0, offset Tune1OrderLoop_05B6
Tune1Order6 label word
    dw offset Tune1Pattern_0808
Tune1OrderLoop_05C8 label word
    dw offset Tune1Pattern_0808
    dw offset Tune1Pattern_0833
    dw offset Tune1Pattern_0808
    dw offset Tune1Pattern_0833
    dw offset RestPattern4
    dw offset Tune1Pattern_086C
    dw 0, offset Tune1OrderLoop_05C8
Tune1Order2 label word
    dw offset RestPattern8
Tune1OrderLoop_05DA label word
    dw offset Tune1Pattern_087E
    dw offset Tune1Pattern_08CF
    dw offset Tune1Pattern_08EE
    dw offset Tune1Pattern_08CF
    dw offset Tune1Pattern_095B
    dw offset Tune1Pattern_0970
    dw 0, offset Tune1OrderLoop_05DA
Tune1Order7 label word
    dw offset RestPattern8
Tune1OrderLoop_05EC label word
    dw offset Tune1Pattern_0984
    dw offset Tune1Pattern_09D5
    dw offset Tune1Pattern_09E3
    dw offset Tune1Pattern_09D5
    dw offset Tune1Pattern_0A53
    dw offset Tune1Pattern_0A5C
    dw 0, offset Tune1OrderLoop_05EC
Tune1Pattern_05FC label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch
    db 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2
    db 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6
    db 0Eh, 0Ch, ROL_LENGTH + 4, 0Eh, ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ROL_END_PATTERN
Tune1Pattern_0645 label byte
    db ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6
    db 0Eh, 0Ch, ROL_LENGTH + 4, 0Eh, ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ROL_END_PATTERN
Tune1Pattern_066A label byte
    db ROL_LENGTH + 2, 0Ch, ROL_REST, 0Ch, ROL_LENGTH + 6, 0Eh, ROL_LENGTH + 2, 0Ch, ROL_REST, 0Ch, ROL_LENGTH + 6, 0Eh
    db ROL_LENGTH + 2, 0Ch, ROL_REST, 0Ch, ROL_LENGTH + 6, 0Eh, ROL_LENGTH + 2, 0Ch, ROL_REST, 0Ch, ROL_LENGTH + 6, 0Eh
    db ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, ROL_LENGTH + 22, ROL_REST
    db ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, ROL_END_PATTERN
Tune1Pattern_0693 label byte
    db ROL_LENGTH + 6, ROL_VELOCITY, 6Ch
Tune1Pattern_0696 label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, ROL_REST, ROL_REST
Tune1Pattern_06A6 label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, ROL_REST, ROL_REST, ROL_END_PATTERN
Tune1Pattern_06B7 label byte
    db ROL_LENGTH + 6, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, ROL_LENGTH + 24, ROL_REST, ROL_LENGTH + 6
    db 12h, 12h, 12h, 12h, ROL_END_PATTERN
Tune1Pattern_06C8 label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 78h
Tune1Pattern_06CC label byte
    db ROL_LENGTH + 2, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, ROL_END_PATTERN
Tune1Pattern_06FE label byte
    db ROL_LENGTH + 2, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 07h, 07h, 07h, 07h, 0Eh, 13h, 07h, 07h, 07h, 07h, 0Eh
    db 13h, 06h, 06h, 06h, 06h, 0Eh, 12h, 06h, 06h, 06h, 06h, 0Eh
    db 12h, ROL_END_PATTERN
Tune1Pattern_0760 label byte
    db ROL_LENGTH + 2, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Dh, 0Dh, 0Dh, 0Dh, 14h, 19h, 0Eh, 0Eh, 0Eh, 0Eh, 15h
    db 1Ah, 10h, 10h, 10h, 10h, 17h, 1Ch, 12h, 12h, 12h, 12h, 1Eh
    db ROL_TIE, ROL_END_PATTERN
Tune1Pattern_0792 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_LENGTH + 2, 17h, 15h, 12h, 10h, 12h, 10h, ROL_LENGTH + 4, 0Eh
    db 0Bh, ROL_LENGTH + 28, ROL_REST, ROL_END_PATTERN
Tune1Pattern_07A2 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 60h
Tune1Pattern_07A6 label byte
    db ROL_LENGTH + 24, 26h, 28h, 2Ah, ROL_TIE, 26h, 28h, 2Ah, ROL_TIE, ROL_END_PATTERN
Tune1Pattern_07B0 label byte
    db ROL_LENGTH + 24, 25h, ROL_TIE, 26h, ROL_TIE, 25h, ROL_TIE, 2Bh, 2Ah, ROL_END_PATTERN
Tune1Pattern_07BA label byte
    db ROL_LENGTH + 24, 25h, 26h, ROL_LENGTH + 12, 28h, 2Ah, 2Dh, 2Fh, ROL_END_PATTERN
Tune1Pattern_07C3 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_PROGRAM, 2Ch, ROL_LENGTH + 2, 2Fh, 2Dh, 2Ah, 28h, 2Ah, 28h
    db ROL_LENGTH + 4, 26h, 23h, ROL_LENGTH + 28, ROL_REST, ROL_END_PATTERN
Tune1Pattern_07D5 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 60h, ROL_LENGTH + 24, 21h, 23h, 23h, ROL_TIE, 21h, 23h, 23h
    db ROL_TIE, ROL_END_PATTERN
Tune1Pattern_07E3 label byte
    db ROL_LENGTH + 24, 23h, ROL_TIE, 23h, ROL_TIE, 23h, ROL_TIE, 26h, 26h, ROL_END_PATTERN
Tune1Pattern_07ED label byte
    db ROL_LENGTH + 24, 23h, 23h, ROL_LENGTH + 12, 25h, 26h, 28h, 2Ah, ROL_END_PATTERN
Tune1Pattern_07F6 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_PROGRAM, 2Bh, ROL_REST, ROL_LENGTH + 2, 2Fh, 2Dh, 2Ah, 28h, 2Ah, 28h
    db ROL_LENGTH + 4, 26h, 23h, ROL_LENGTH + 28, ROL_REST, ROL_END_PATTERN
Tune1Pattern_0808 label byte
    db ROL_PROGRAM, 2Bh, ROL_LENGTH + 30, ROL_REST, ROL_LENGTH + 20, ROL_REST, ROL_REST, ROL_VELOCITY, 60h, ROL_LENGTH + 2, 23h, 28h
    db 2Ah, 2Dh, 2Ah, 2Dh, 2Fh, 2Dh, 2Fh, 32h, 2Fh, 32h, 34h, ROL_LENGTH + 30
    db ROL_REST, ROL_LENGTH + 20, ROL_REST, ROL_REST, ROL_LENGTH + 2, 23h, 28h, 2Ah, 2Dh, 2Ah, 2Dh, 2Fh
    db 2Dh, 2Fh, 32h, 2Fh, 32h, 34h, ROL_END_PATTERN
Tune1Pattern_0833 label byte
    db ROL_LENGTH + 2, 40h, 3Eh, 3Bh, 3Eh, 3Bh, 39h, 3Bh, 39h, 36h, 39h, 36h
    db 2Fh, 34h, 32h, 2Fh, 32h, 2Fh, 2Dh, 2Fh, 2Dh, 2Ah, 2Dh, 2Ah
    db 28h, ROL_LENGTH + 24, 26h, ROL_TIE, ROL_LENGTH + 2, 40h, 3Eh, 3Bh, 3Eh, 3Bh, 39h, 3Bh
    db 39h, 36h, 39h, 36h, 2Fh, 34h, 32h, 2Fh, 32h, 2Fh, 2Dh, 2Fh
    db 2Dh, 2Ah, 2Dh, 2Ah, 28h, ROL_LENGTH + 24, 2Bh, 2Ah, ROL_END_PATTERN
Tune1Pattern_086C label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_PROGRAM, 2Ch, ROL_LENGTH + 2, 3Bh, 39h, 36h, 34h, 36h, 34h
    db ROL_LENGTH + 4, 32h, 2Fh, ROL_LENGTH + 28, ROL_REST, ROL_END_PATTERN
Tune1Pattern_087E label byte
    db ROL_PROGRAM, 2Ch, ROL_BEND_RANGE, 03h, ROL_EFFECT_PERIOD, 01h, ROL_VELOCITY, 78h, ROL_LENGTH + 2, 39h, 36h, 32h
    db 34h, 2Fh, 32h, ROL_LENGTH + 8, 36h, ROL_LENGTH + 2, 2Fh, 32h, 36h, 34h, ROL_LENGTH + 20, 39h
    db ROL_LENGTH + 2, 36h, 34h, 32h, 36h, 32h, 2Fh, 34h, 2Fh, 2Ah, 2Fh, 2Ah
    db 28h, ROL_LENGTH + 24, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 152Dh
    db 32h, ROL_LENGTH + 2, 39h, 36h, 32h, 34h, 36h, 34h, ROL_LENGTH + 8, 32h, ROL_LENGTH + 2, 2Fh
    db 32h, 36h, 39h, ROL_LENGTH + 20, 34h, ROL_LENGTH + 2, 36h, 34h, 32h, 36h, 32h, 2Fh
    db 34h, 2Fh, 2Ah, 2Fh, 2Ah, 28h, ROL_LENGTH + 24, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 152Dh
    db 32h, ROL_END_PATTERN
Tune1Pattern_08CF label byte
    db ROL_PROGRAM, 56h, ROL_LENGTH + 9, 21h, 23h, ROL_LENGTH + 6, 25h, ROL_LENGTH + 9, 21h, 23h, ROL_LENGTH + 6, 25h
    db ROL_LENGTH + 9, 23h, 25h, ROL_LENGTH + 30, 26h, ROL_LENGTH + 9, 25h, 26h, ROL_LENGTH + 6, 28h, ROL_LENGTH + 9, 25h
    db 26h, ROL_LENGTH + 6, 28h, ROL_LENGTH + 24, 2Bh, 2Ah, ROL_END_PATTERN
Tune1Pattern_08EE label byte
    db ROL_PROGRAM, 2Ch, ROL_BEND_RANGE, 03h, ROL_LENGTH + 2, 39h, 36h, 2Fh, 32h, 34h, 36h, ROL_LENGTH + 12
    db 39h, ROL_LENGTH + 2, 3Bh, 39h, 36h, ROL_LENGTH + 18, 34h, ROL_LENGTH + 2, 39h, 36h, 34h, 36h
    db 34h, 32h, 34h, 32h, 2Fh, 32h, 2Fh, 2Dh, ROL_LENGTH + 24, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 152Dh
    db 32h, ROL_LENGTH + 2, 34h, 31h, 2Fh, 32h, 31h, 2Dh, 34h, 31h, 2Fh, 32h
    db 31h, 2Dh, 36h, 32h, 2Fh, 34h, 32h, 31h, 39h, 36h, 32h, 34h
    db 32h, 2Fh, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 2Fh, 34h, 32h, 2Fh, 34h, 32h, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 2Fh, 34h, 32h, 2Fh, 34h, 32h, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 3Bh, 39h, 32h, 2Fh, 39h, 32h, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 3Bh, 39h, 32h, 2Fh, 39h, 32h, ROL_END_PATTERN
Tune1Pattern_095B label byte
    db ROL_PROGRAM, 56h, ROL_LENGTH + 9, 21h, 23h, ROL_LENGTH + 6, 25h, ROL_LENGTH + 9, 23h, 25h, ROL_LENGTH + 6, 26h
    db 25h, 28h, 26h, 2Ah, 28h, 2Dh, 2Ah, 2Fh, ROL_END_PATTERN
Tune1Pattern_0970 label byte
    db ROL_LENGTH + 25, ROL_REST, ROL_REST, ROL_PROGRAM, 2Ch, ROL_VELOCITY, 6Ch, ROL_LENGTH + 2, 2Fh, 2Dh, 2Ah, 28h
    db 2Ah, 28h, ROL_LENGTH + 4, 26h, 23h, ROL_LENGTH + 26, ROL_REST, ROL_END_PATTERN
Tune1Pattern_0984 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 4Ch, ROL_LENGTH + 2, ROL_REST, ROL_BEND_RANGE, 03h, ROL_LENGTH + 2, 39h, 36h, 32h
    db 34h, 2Fh, 32h, ROL_LENGTH + 8, 36h, ROL_LENGTH + 2, 2Fh, 32h, 36h, 34h, ROL_LENGTH + 20, 39h
    db ROL_LENGTH + 2, 36h, 34h, 32h, 36h, 32h, 2Fh, 34h, 2Fh, 2Ah, 2Fh, 2Ah
    db 28h, ROL_LENGTH + 24, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 152Dh
    db 32h, ROL_LENGTH + 2, 39h, 36h, 32h, 34h, 36h, 34h, ROL_LENGTH + 8, 32h, ROL_LENGTH + 2, 2Fh
    db 32h, 36h, 39h, ROL_LENGTH + 20, 34h, ROL_LENGTH + 2, 36h, 34h, 32h, 36h, 32h, 2Fh
    db 34h, 2Fh, 2Ah, 2Fh, 2Ah, 28h, ROL_LENGTH + 22, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 152Dh
    db 32h, ROL_END_PATTERN
Tune1Pattern_09D5 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 60h, ROL_LENGTH + 24, 21h, ROL_TIE, 1Fh, ROL_TIE, 21h, ROL_TIE, 21h
    db 21h, ROL_END_PATTERN
Tune1Pattern_09E3 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 4Ch, ROL_LENGTH + 2, ROL_REST, ROL_BEND_RANGE, 03h, ROL_LENGTH + 2, 39h, 36h, 2Fh
    db 32h, 34h, 36h, ROL_LENGTH + 12, 39h, ROL_LENGTH + 2, 3Bh, 39h, 36h, ROL_LENGTH + 18, 34h, ROL_LENGTH + 2
    db 39h, 36h, 34h, 36h, 34h, 32h, 34h, 32h, 2Fh, 32h, 2Fh, 2Dh
    db ROL_LENGTH + 24, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 152Dh
    db 32h, ROL_LENGTH + 2, 34h, 31h, 2Fh, 32h, 31h, 2Dh, 34h, 31h, 2Fh, 32h
    db 31h, 2Dh, 36h, 32h, 2Fh, 34h, 32h, 31h, 39h, 36h, 32h, 34h
    db 32h, 2Fh, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 2Fh, 34h, 32h, 2Fh, 34h, 32h, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 2Fh, 34h, 32h, 2Fh, 34h, 32h, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 3Bh, 39h, 32h, 2Fh, 39h, 32h, ROL_PITCH_ENVELOPE
    dw 0008h
    dw 0800h
    db 3Bh, 39h, 32h, 2Fh, 39h, ROL_END_PATTERN
Tune1Pattern_0A53 label byte
    db ROL_LENGTH + 24, 21h, 21h, ROL_LENGTH + 12, 21h, 21h, 25h, 23h, ROL_END_PATTERN
Tune1Pattern_0A5C label byte
    db ROL_LENGTH + 25, ROL_REST, ROL_REST, ROL_PROGRAM, 2Ch, ROL_VELOCITY, 4Ch, ROL_LENGTH + 2, 3Bh, 39h, 36h, 34h
    db 36h, 34h, ROL_LENGTH + 4, 32h, 2Fh, ROL_LENGTH + 26, ROL_REST, ROL_END_PATTERN
; Tune 2: 6 timer ticks per row, 8 channels, order list per channel.
Tune2 db 6, 8
    dw offset Tune2Order0, offset Tune2Order1, offset Tune2Order2, offset Tune2Order3
    dw offset Tune2Order4, offset Tune2Order5, offset Tune2Order6, offset Tune2Order7
Tune2Order0 label word
    dw offset Tune2Pattern_0AF0
    dw offset Tune2Pattern_0BB3
    dw offset Tune2Pattern_0C74
    dw offset Tune2Pattern_0C74
    dw offset Tune2Pattern_0C74
    dw offset Tune2Pattern_0C74
    dw 0, offset Tune2Order0
Tune2Order1 label word
    dw offset Tune2Pattern_0CA6
    dw offset Tune2Pattern_0CA6
    dw offset Tune2Pattern_0CA6
    dw offset Tune2Pattern_0CA6
    dw offset Tune2Pattern_0D0A
    dw offset Tune2Pattern_0D0A
    dw offset Tune2Pattern_0D0A
    dw offset Tune2Pattern_0D0A
    dw 0, offset Tune2Order1
Tune2Order2 label word
    dw offset Tune2Pattern_0D3C
    dw offset Tune2Pattern_0DEC
    dw offset Tune2Pattern_0E9B
    dw offset Tune2Pattern_0E9B
    dw offset Tune2Pattern_0E9B
    dw offset Tune2Pattern_0E9B
    dw 0, offset Tune2Order2
Tune2Order3 label word
    dw offset Tune2Pattern_0ECD
    dw offset Tune2Pattern_0EEE
    dw offset Tune2Pattern_0F13
    dw offset Tune2Pattern_0F13
    dw 0, offset Tune2Order3
Tune2Order4 label word
    dw offset Tune2Pattern_0F1D
    dw offset Tune2Pattern_0F3E
    dw offset Tune2Pattern_0F63
    dw offset Tune2Pattern_0F63
    dw 0, offset Tune2Order4
Tune2Order5 label word
    dw offset Tune2Pattern_0F6D
    dw offset Tune2Pattern_0F8E
    dw offset Tune2Pattern_0FB3
    dw offset Tune2Pattern_0FB3
    dw 0, offset Tune2Order5
Tune2Order6 label word
    dw offset Tune2Pattern_0FBD
    dw offset Tune2Pattern_0FDE
    dw offset Tune2Pattern_1003
    dw offset Tune2Pattern_1003
    dw 0, offset Tune2Order6
Tune2Order7 label word
    dw offset Tune2Pattern_100D
    dw offset Tune2Pattern_1099
    dw offset Tune2Pattern_1136
    dw 0, offset Tune2Order7
Tune2Pattern_0AF0 label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 2, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, 0Eh, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_LENGTH + 8, ROL_REST, ROL_LENGTH + 2, 0Ch, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh
    db ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh
    db ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh
    db ROL_REST, ROL_REST, 0Ch, 0Ch, ROL_REST, ROL_REST, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, ROL_END_PATTERN
Tune2Pattern_0BB3 label byte
    db ROL_LENGTH + 2, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, 0Eh
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST
    db 0Eh, 0Ch, 0Ch, ROL_LENGTH + 8, ROL_REST, ROL_LENGTH + 2, 0Ch, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh
    db 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, 0Eh
    db 0Eh, ROL_REST, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, ROL_REST, 0Eh, 0Eh, ROL_REST, ROL_REST
    db 0Eh, ROL_REST, 0Eh, ROL_REST, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ROL_END_PATTERN
Tune2Pattern_0C74 label byte
    db ROL_LENGTH + 2, 0Ch, 0Eh, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Eh, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, 0Eh, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Eh, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, 0Eh, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Eh, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, 0Eh, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Eh, 0Ch, 0Eh, 0Eh
    db 0Eh, ROL_END_PATTERN
Tune2Pattern_0CA6 label byte
    db ROL_VELOCITY, 6Ch, ROL_LENGTH + 2, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, 12h, 12h, 16h, 12h, 16h, 12h, 12h, 12h, 16h
    db 12h, 16h, 12h, ROL_END_PATTERN
Tune2Pattern_0D0A label byte
    db ROL_LENGTH + 2, 12h, 12h, ROL_REST, 12h, 16h, 12h, 12h, 12h, ROL_REST, 12h, 16h
    db 12h, 12h, 12h, ROL_REST, 12h, 16h, 12h, 12h, 12h, ROL_REST, 12h, 16h
    db 12h, 12h, 12h, ROL_REST, 12h, 16h, 12h, 12h, 12h, ROL_REST, 12h, 16h
    db 12h, 12h, 12h, ROL_REST, 12h, 16h, 12h, 12h, 12h, ROL_REST, 12h, 16h
    db 12h, ROL_END_PATTERN
Tune2Pattern_0D3C label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 78h, ROL_LENGTH + 2, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh
    db 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh
    db 0Eh, 09h, 0Eh, 13h, 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h
    db 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h
    db 13h, 0Eh, 13h, 18h, 1Ah, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh
    db 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh
    db 0Eh, 09h, 0Eh, 13h, 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h
    db 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h
    db 13h, 0Eh, 13h, 18h, 1Ah, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh
    db 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh
    db 0Eh, 0Bh, 0Eh, 12h, 13h, ROL_LENGTH + 3, 15h, ROL_REST, ROL_LENGTH + 2, 09h, ROL_REST, ROL_LENGTH + 6
    db 15h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 2, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh
    db 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh
    db 0Bh, 0Eh, 12h, 13h, 15h, ROL_TIE, ROL_REST, 09h, ROL_REST, ROL_LENGTH + 6, 15h, ROL_LENGTH + 22
    db ROL_REST, ROL_LENGTH + 2, 09h, 0Bh, 0Ch, 0Dh, 0Eh, ROL_END_PATTERN
Tune2Pattern_0DEC label byte
    db ROL_LENGTH + 2, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h
    db 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h
    db 13h, ROL_LENGTH + 3, 15h, ROL_REST, ROL_LENGTH + 2, 09h, ROL_REST, ROL_LENGTH + 6, 15h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 2
    db 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h
    db 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h
    db ROL_LENGTH + 6, 15h, ROL_LENGTH + 4, 12h, ROL_LENGTH + 6, 13h, ROL_LENGTH + 2, 15h, ROL_LENGTH + 6, 17h, ROL_LENGTH + 4, 1Ah
    db ROL_LENGTH + 6, 1Ch, ROL_LENGTH + 2, 1Eh, ROL_LENGTH + 12, 1Fh, ROL_END_PATTERN
Tune2Pattern_0E9B label byte
    db ROL_LENGTH + 2, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h
    db 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h
    db 13h, 09h, 15h, 09h, 15h, 09h, 15h, 09h, 15h, 09h, 15h, 09h
    db 15h, 04h, 10h, 04h, 10h, 04h, 10h, 04h, 10h, 04h, 10h, 04h
    db 10h, ROL_END_PATTERN
Tune2Pattern_0ECD label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 30h, ROL_LENGTH + 24, 2Dh, ROL_TIE, 2Fh, ROL_TIE, 2Dh, ROL_TIE, 2Fh
    db ROL_TIE, 2Dh, ROL_TIE, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 6, ROL_REST, 2Bh, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 2Dh
    db ROL_TIE, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 6, ROL_REST, 2Bh, ROL_LENGTH + 32, ROL_REST, ROL_END_PATTERN
Tune2Pattern_0EEE label byte
    db ROL_LENGTH + 24, 2Dh, ROL_TIE, 2Fh, ROL_TIE, 2Dh, ROL_TIE, 2Fh, ROL_TIE, 2Dh, ROL_TIE, ROL_LENGTH + 4
    db 2Bh, ROL_LENGTH + 6, ROL_REST, 2Bh, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 2Dh, ROL_TIE, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 6
    db ROL_REST, 2Bh, ROL_LENGTH + 8, ROL_REST, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 6, ROL_REST, ROL_LENGTH + 8, 2Bh, ROL_LENGTH + 6, ROL_REST
    db ROL_END_PATTERN
Tune2Pattern_0F13 label byte
    db ROL_LENGTH + 24, 2Ah, ROL_TIE, 28h, 26h, 2Ah, ROL_TIE, 28h, 26h, ROL_END_PATTERN
Tune2Pattern_0F1D label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 30h, ROL_LENGTH + 24, 2Ah, ROL_TIE, 2Bh, ROL_TIE, 2Ah, ROL_TIE, 2Bh
    db ROL_TIE, 2Ah, ROL_TIE, ROL_LENGTH + 4, 28h, ROL_LENGTH + 6, ROL_REST, 28h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 2Ah
    db ROL_TIE, ROL_LENGTH + 4, 28h, ROL_LENGTH + 6, ROL_REST, 28h, ROL_LENGTH + 32, ROL_REST, ROL_END_PATTERN
Tune2Pattern_0F3E label byte
    db ROL_LENGTH + 24, 2Ah, ROL_TIE, 2Bh, ROL_TIE, 2Ah, ROL_TIE, 2Bh, ROL_TIE, 2Ah, ROL_TIE, ROL_LENGTH + 4
    db 28h, ROL_LENGTH + 6, ROL_REST, 28h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 2Ah, ROL_TIE, ROL_LENGTH + 4, 28h, ROL_LENGTH + 6
    db ROL_REST, 28h, ROL_LENGTH + 8, ROL_REST, ROL_LENGTH + 4, 28h, ROL_LENGTH + 6, ROL_REST, ROL_LENGTH + 8, 28h, ROL_LENGTH + 6, ROL_REST
    db ROL_END_PATTERN
Tune2Pattern_0F63 label byte
    db ROL_LENGTH + 24, 26h, ROL_TIE, 24h, 23h, 26h, ROL_TIE, 24h, 23h, ROL_END_PATTERN
Tune2Pattern_0F6D label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 30h, ROL_LENGTH + 24, 28h, ROL_TIE, 28h, ROL_TIE, 28h, ROL_TIE, 28h
    db ROL_TIE, 26h, ROL_TIE, ROL_LENGTH + 4, 24h, ROL_LENGTH + 6, ROL_REST, 24h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 26h
    db ROL_TIE, ROL_LENGTH + 4, 24h, ROL_LENGTH + 6, ROL_REST, 24h, ROL_LENGTH + 32, ROL_REST, ROL_END_PATTERN
Tune2Pattern_0F8E label byte
    db ROL_LENGTH + 24, 28h, ROL_TIE, 28h, ROL_TIE, 28h, ROL_TIE, 28h, ROL_TIE, 26h, ROL_TIE, ROL_LENGTH + 4
    db 24h, ROL_LENGTH + 6, ROL_REST, 24h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 26h, ROL_TIE, ROL_LENGTH + 4, 24h, ROL_LENGTH + 6
    db ROL_REST, 24h, ROL_LENGTH + 8, ROL_REST, ROL_LENGTH + 4, 24h, ROL_LENGTH + 6, ROL_REST, ROL_LENGTH + 8, 24h, ROL_LENGTH + 6, ROL_REST
    db ROL_END_PATTERN
Tune2Pattern_0FB3 label byte
    db ROL_LENGTH + 24, 23h, ROL_TIE, 21h, 1Fh, 23h, ROL_TIE, 21h, 1Fh, ROL_END_PATTERN
Tune2Pattern_0FBD label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 30h, ROL_LENGTH + 24, 26h, ROL_TIE, 24h, ROL_TIE, 26h, ROL_TIE, 24h
    db ROL_TIE, 23h, ROL_TIE, ROL_LENGTH + 4, 21h, ROL_LENGTH + 6, ROL_REST, 21h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 23h
    db ROL_TIE, ROL_LENGTH + 4, 21h, ROL_LENGTH + 6, ROL_REST, 21h, ROL_LENGTH + 32, ROL_REST, ROL_END_PATTERN
Tune2Pattern_0FDE label byte
    db ROL_LENGTH + 24, 26h, ROL_TIE, 24h, ROL_TIE, 26h, ROL_TIE, 24h, ROL_TIE, 23h, ROL_TIE, ROL_LENGTH + 4
    db 21h, ROL_LENGTH + 6, ROL_REST, 21h, ROL_LENGTH + 32, ROL_REST, ROL_LENGTH + 24, 23h, ROL_TIE, ROL_LENGTH + 4, 21h, ROL_LENGTH + 6
    db ROL_REST, 21h, ROL_LENGTH + 8, ROL_REST, ROL_LENGTH + 4, 21h, ROL_LENGTH + 6, ROL_REST, ROL_LENGTH + 8, 21h, ROL_LENGTH + 6, ROL_REST
    db ROL_END_PATTERN
Tune2Pattern_1003 label byte
    db ROL_LENGTH + 24, 1Fh, ROL_TIE, 1Dh, 1Ch, 1Fh, ROL_TIE, 1Dh, 1Ch, ROL_END_PATTERN
Tune2Pattern_100D label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 68h, ROL_LENGTH + 10, 2Dh, ROL_LENGTH + 2, 2Ah, ROL_LENGTH + 4, 28h, ROL_LENGTH + 6, 2Ah
    db ROL_LENGTH + 18, 26h, ROL_LENGTH + 2, 28h, ROL_LENGTH + 6, 2Ah, ROL_LENGTH + 10, 2Fh, ROL_LENGTH + 28, 2Dh, ROL_LENGTH + 2, 2Fh
    db 2Dh, 2Bh, 2Ah, 2Bh, ROL_LENGTH + 16, 2Dh, ROL_LENGTH + 2, 28h, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 18, 26h
    db ROL_LENGTH + 2, 28h, ROL_LENGTH + 6, 2Ah, ROL_LENGTH + 10, 2Fh, ROL_LENGTH + 26, 2Dh, ROL_LENGTH + 2, 2Fh, 30h, 32h
    db 34h, 36h, 39h, 2Ah, 2Dh, 2Fh, 32h, ROL_REST, ROL_LENGTH + 12, 34h, ROL_LENGTH + 2, 36h
    db 39h, 36h, 34h, 36h, 34h, 32h, 34h, 32h, 2Fh, 32h, 2Fh, 32h
    db ROL_LENGTH + 6, 32h, ROL_LENGTH + 4, 34h, 32h, ROL_TIE, ROL_VELOCITY, 40h, 34h, 32h, ROL_TIE, ROL_VELOCITY
    db 20h, 34h, 32h, ROL_TIE, ROL_VELOCITY, 10h, 34h, ROL_VELOCITY, 68h, ROL_LENGTH + 2, ROL_REST, 2Ah
    db 2Dh, 2Fh, 32h, ROL_REST, ROL_LENGTH + 12, 32h, ROL_LENGTH + 2, 32h, 36h, 34h, 32h, ROL_LENGTH + 4
    db 34h, ROL_LENGTH + 9, 34h, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 2, 34h, 39h, 36h, 32h, 39h, 36h
    db 32h, 39h, 36h, 32h, 39h, 36h, 32h, 39h, 36h, 34h, 39h, 36h
    db 34h, 39h, 36h, 34h, 36h, 39h, 34h, ROL_END_PATTERN
Tune2Pattern_1099 label byte
    db ROL_LENGTH + 12, 2Dh, ROL_LENGTH + 4, 32h, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 32h, ROL_LENGTH + 8, 2Dh, ROL_LENGTH + 2, 32h
    db 34h, 2Dh, 32h, 34h, 2Dh, 32h, 34h, 2Dh, ROL_LENGTH + 6, 32h, ROL_LENGTH + 4, 34h
    db ROL_LENGTH + 6, 36h, ROL_LENGTH + 2, 37h, ROL_LENGTH + 4, 36h, ROL_LENGTH + 24, 34h, ROL_LENGTH + 2, 36h, ROL_LENGTH + 4, 37h
    db ROL_LENGTH + 2, 39h, ROL_LENGTH + 4, 37h, ROL_LENGTH + 6, 36h, 34h, ROL_LENGTH + 14, 36h, ROL_LENGTH + 2, 39h, 37h
    db 36h, 34h, 36h, 34h, ROL_LENGTH + 6, 32h, ROL_LENGTH + 4, 34h, ROL_LENGTH + 6, 30h, ROL_LENGTH + 2, 32h
    db ROL_LENGTH + 6, 2Fh, ROL_LENGTH + 4, 30h, ROL_LENGTH + 6, 2Dh, ROL_LENGTH + 2, 2Fh, ROL_LENGTH + 6, 2Bh, ROL_LENGTH + 4, 2Dh
    db ROL_LENGTH + 2, 2Ah, 2Dh, 32h, 2Dh, 34h, 2Dh, 32h, 2Dh, 34h, 2Dh, 32h
    db 2Dh, 34h, 2Dh, 32h, 2Dh, 34h, 2Dh, 32h, 2Dh, 34h, 2Dh, 32h
    db 2Dh, 34h, 37h, 36h, 32h, 36h, 32h, 36h, 37h, 36h, 32h, 36h
    db 32h, 36h, 37h, 39h, 36h, 37h, 32h, 36h, 3Bh, 39h, 37h, 36h
    db 36h, 34h, 32h, 2Fh, 2Dh, ROL_LENGTH + 4, 34h, ROL_LENGTH + 12, 32h, ROL_LENGTH + 2, 34h, 36h
    db 37h, 36h, ROL_LENGTH + 4, 34h, ROL_LENGTH + 14, 32h, ROL_LENGTH + 6, 28h, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 6, 2Bh
    db ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 6, 2Fh, ROL_LENGTH + 4, 32h, ROL_LENGTH + 6, 34h, ROL_LENGTH + 2, 36h, ROL_LENGTH + 12, 37h
    db ROL_END_PATTERN
Tune2Pattern_1136 label byte
    db ROL_LENGTH + 32, ROL_REST, ROL_REST, ROL_REST, ROL_LENGTH + 2, ROL_PROGRAM, 2Bh, ROL_VELOCITY, 10h, 3Bh, 39h, 3Bh
    db 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh
    db 3Ch, 3Bh, 39h, ROL_VELOCITY, 20h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh
    db 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ROL_VELOCITY
    db 30h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh
    db 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ROL_VELOCITY, 40h, 3Bh, 39h, 3Bh
    db 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh
    db 3Ch, 3Bh, 39h, ROL_VELOCITY, 50h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh
    db 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ROL_VELOCITY
    db 60h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh
    db 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ROL_VELOCITY, 70h, 3Bh, 39h, 3Bh
    db 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 39h, 3Bh, 39h
    db 3Ch, 3Bh, 39h, ROL_VELOCITY, 7Eh, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Ch
    db 3Bh, 39h, 3Ch, 3Bh, 39h, 3Ch, 3Bh, 39h, 3Ch, 3Bh, 3Eh, ROL_END_PATTERN
; Tune 3: 5 timer ticks per row, 8 channels, order list per channel.
Tune3 db 5, 8
    dw offset Tune3Order0, offset Tune3Order1, offset Tune3Order2, offset Tune3Order3
    dw offset Tune3Order4, offset Tune3Order5, offset Tune3Order6, offset Tune3Order7
Tune3Order0 label word
    dw offset Tune3Pattern_12B8
Tune3OrderLoop_11F2 label word
    dw offset Tune3Pattern_12B8
    dw offset Tune3Pattern_12B8
    dw offset Tune3Pattern_12FD
    dw offset Tune3Pattern_12B8
    dw offset Tune3Pattern_12B8
    dw offset Tune3Pattern_12B8
    dw offset Tune3Pattern_12FD
    dw offset Tune3Pattern_1342
    dw offset Tune3Pattern_12B8
    dw offset Tune3Pattern_12B8
    dw offset Tune3Pattern_12FD
    dw offset Tune3Pattern_12FD
    dw 0, offset Tune3OrderLoop_11F2
Tune3Order1 label word
    dw offset Tune3Pattern_1385
Tune3Order2 label word
    dw offset Tune3Pattern_1393
Tune3OrderLoop_1212 label word
    dw offset Tune3Pattern_1393
    dw offset Tune3Pattern_1393
    dw offset Tune3Pattern_13F9
    dw offset Tune3Pattern_1393
    dw offset Tune3Pattern_1393
    dw offset Tune3Pattern_1393
    dw offset Tune3Pattern_13F9
    dw offset Tune3Pattern_1457
    dw offset Tune3Pattern_14B9
    dw offset Tune3Pattern_14B9
    dw offset Tune3Pattern_151B
    dw offset Tune3Pattern_13F9
    dw 0, offset Tune3OrderLoop_1212
Tune3Order3 label word
    dw offset Tune3Pattern_157D
Tune3OrderLoop_1230 label word
    dw offset Tune3Pattern_157D
    dw offset Tune3Pattern_157D
    dw offset Tune3Pattern_1590
    dw offset Tune3Pattern_157D
    dw offset Tune3Pattern_157D
    dw offset Tune3Pattern_157D
    dw offset Tune3Pattern_1590
    dw offset Tune3Pattern_15CB
    dw offset Tune3Pattern_15F0
    dw offset Tune3Pattern_15F0
    dw offset Tune3Pattern_1612
    dw offset Tune3Pattern_1590
    dw 0, offset Tune3OrderLoop_1230
Tune3Order4 label word
    dw offset Tune3Pattern_1653
Tune3OrderLoop_124E label word
    dw offset Tune3Pattern_1653
    dw offset Tune3Pattern_1653
    dw offset Tune3Pattern_1666
    dw offset Tune3Pattern_1653
    dw offset Tune3Pattern_1653
    dw offset Tune3Pattern_1653
    dw offset Tune3Pattern_1666
    dw offset Tune3Pattern_16A1
    dw offset Tune3Pattern_16C6
    dw offset Tune3Pattern_16C6
    dw offset Tune3Pattern_16E8
    dw offset Tune3Pattern_1666
    dw 0, offset Tune3OrderLoop_124E
Tune3Order5 label word
    dw offset Tune3Pattern_1729
Tune3OrderLoop_126C label word
    dw offset Tune3Pattern_1729
    dw offset Tune3Pattern_1729
    dw offset Tune3Pattern_173C
    dw offset Tune3Pattern_1729
    dw offset Tune3Pattern_1729
    dw offset Tune3Pattern_1729
    dw offset Tune3Pattern_173C
    dw offset Tune3Pattern_1777
    dw offset Tune3Pattern_179C
    dw offset Tune3Pattern_179C
    dw offset Tune3Pattern_17BE
    dw offset Tune3Pattern_173C
    dw 0, offset Tune3OrderLoop_126C
Tune3Order6 label word
    dw offset RestPattern8
Tune3OrderLoop_128A label word
    dw offset Tune3Pattern_17FF
    dw offset Tune3Pattern_18B3
    dw offset RestPattern8
    dw offset Tune3Pattern_17FF
    dw offset Tune3Pattern_18B3
    dw offset Tune3Pattern_18DE
    dw offset Tune3Pattern_1907
    dw offset Tune3Pattern_19C0
    dw offset Tune3Pattern_18B3
    dw 0, offset Tune3OrderLoop_128A
Tune3Order7 label word
    dw offset RestPattern8
Tune3OrderLoop_12A2 label word
    dw offset Tune3Pattern_19F6
    dw offset Tune3Pattern_1AAC
    dw offset RestPattern8
    dw offset Tune3Pattern_19F6
    dw offset Tune3Pattern_1AAC
    dw offset Tune3Pattern_1AD5
    dw offset Tune3Pattern_1B41
    dw offset Tune3Pattern_1B10
    dw offset Tune3Pattern_1AAC
    dw 0, offset Tune3OrderLoop_12A2
Tune3Pattern_12B8 label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch
    db 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2
    db 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch
    db 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2
    db 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch
    db 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, 0Eh, ROL_REST, 0Eh, ROL_END_PATTERN
Tune3Pattern_12FD label byte
    db ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6
    db 0Eh, 0Ch, 0Eh, ROL_LENGTH + 2, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, ROL_LENGTH + 6, 0Ch
    db 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2
    db 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch
    db 0Eh, ROL_LENGTH + 2, 0Eh, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh, ROL_END_PATTERN
Tune3Pattern_1342 label byte
    db ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6
    db 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6
    db 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, 0Eh, 0Eh, 0Eh, ROL_END_PATTERN
Tune3Pattern_1385 label byte
    db ROL_VELOCITY, 6Ch, ROL_LENGTH + 6
Tune3Pattern_1388 label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, ROL_JUMP
    dw offset Tune3Pattern_1388
Tune3Pattern_1393 label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 78h, ROL_LENGTH + 2, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h, 0Eh
    db 15h, 0Eh, 13h, 15h, 0Ch, ROL_END_PATTERN
Tune3Pattern_13F9 label byte
    db ROL_LENGTH + 2, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST
    db 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST
    db 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST
    db 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST
    db 11h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 15h, ROL_REST, 15h, 15h, ROL_REST, 15h, 15h, ROL_REST, 15h, 15h, ROL_REST
    db 15h, 15h, ROL_REST, 15h, 15h, ROL_REST, 15h, ROL_LENGTH + 12, 15h, ROL_END_PATTERN
Tune3Pattern_1457 label byte
    db ROL_LENGTH + 2, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, ROL_END_PATTERN
Tune3Pattern_14B9 label byte
    db ROL_LENGTH + 2, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE, 0Eh, 0Eh, ROL_TIE
    db 0Eh, 10h, ROL_TIE, 10h, 10h, ROL_TIE, 10h, 10h, ROL_TIE, 10h, 10h, ROL_TIE
    db 10h, 10h, ROL_TIE, 10h, 10h, ROL_TIE, 10h, 10h, ROL_TIE, 10h, 10h, ROL_TIE
    db 10h, 13h, ROL_TIE, 13h, 13h, ROL_TIE, 13h, 13h, ROL_TIE, 13h, 13h, ROL_TIE
    db 13h, 13h, ROL_TIE, 13h, 13h, ROL_TIE, 13h, 13h, ROL_TIE, 13h, 13h, ROL_TIE
    db 13h, ROL_END_PATTERN
Tune3Pattern_151B label byte
    db ROL_TRANSPOSE, 0FBh, ROL_LENGTH + 2, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h
    db 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h
    db 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h
    db 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h, 11h, ROL_REST, 11h
    db 11h, ROL_REST, 11h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h
    db 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h
    db 13h, ROL_REST, 13h, 15h, ROL_REST, 15h, 15h, ROL_REST, 15h, 15h, ROL_REST, 15h
    db 15h, ROL_REST, 15h, 15h, ROL_REST, 15h, 15h, ROL_REST, 15h, ROL_LENGTH + 12, 15h, ROL_TRANSPOSE
    db 00h, ROL_END_PATTERN
Tune3Pattern_157D label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 4Ah, ROL_LENGTH + 24, 32h, ROL_TIE, 35h, ROL_LENGTH + 12, 37h, 39h, ROL_LENGTH + 24
    db 32h, ROL_TIE, 35h, ROL_LENGTH + 12, 37h, 39h, ROL_END_PATTERN
Tune3Pattern_1590 label byte
    db ROL_LENGTH + 12, 30h, ROL_LENGTH + 2, 30h, ROL_REST, 30h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 30h, ROL_LENGTH + 2, 30h
    db ROL_REST, 30h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 30h, ROL_LENGTH + 2, 30h, ROL_REST, 30h, ROL_REST, ROL_REST
    db ROL_LENGTH + 14, 30h, ROL_LENGTH + 2, 30h, ROL_REST, 30h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 32h, ROL_LENGTH + 2, 32h
    db ROL_REST, 32h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 32h, ROL_LENGTH + 2, 32h, ROL_REST, 32h, ROL_REST, ROL_REST
    db ROL_LENGTH + 14, 34h, ROL_LENGTH + 2, 34h, ROL_REST, 34h, ROL_REST, ROL_REST, ROL_LENGTH + 26, 34h, ROL_END_PATTERN
Tune3Pattern_15CB label byte
    db ROL_LENGTH + 32, 2Dh, ROL_LENGTH + 2, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_LENGTH + 32
    db 2Dh, ROL_LENGTH + 2, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_LENGTH + 32, 2Dh
    db ROL_LENGTH + 2, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_LENGTH + 24, 2Dh, ROL_TIE
    db ROL_END_PATTERN
Tune3Pattern_15F0 label byte
    db ROL_LENGTH + 31, 32h, ROL_LENGTH + 2, ROL_REST, 34h, ROL_REST, ROL_REST, 34h, ROL_LENGTH + 4, ROL_REST, ROL_LENGTH + 3, 34h
    db ROL_LENGTH + 24, 35h, 37h, ROL_LENGTH + 31, 34h, ROL_LENGTH + 2, ROL_REST, 34h, ROL_REST, ROL_REST, 34h, ROL_LENGTH + 4
    db ROL_REST, ROL_LENGTH + 3, 34h, ROL_LENGTH + 24, 37h, ROL_LENGTH + 23, ROL_TIE, ROL_LENGTH + 1, ROL_REST, ROL_END_PATTERN
Tune3Pattern_1612 label byte
    db ROL_TRANSPOSE, 07h, ROL_LENGTH + 12, 24h, ROL_LENGTH + 2, 24h, ROL_REST, 24h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 24h
    db ROL_LENGTH + 2, 24h, ROL_REST, 24h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 24h, ROL_LENGTH + 2, 24h, ROL_REST, 24h
    db ROL_REST, ROL_REST, ROL_LENGTH + 14, 24h, ROL_LENGTH + 2, 24h, ROL_REST, 24h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 26h
    db ROL_LENGTH + 2, 26h, ROL_REST, 26h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 26h, ROL_LENGTH + 2, 26h, ROL_REST, 26h
    db ROL_REST, ROL_REST, ROL_LENGTH + 14, 28h, ROL_LENGTH + 2, 28h, ROL_REST, 28h, ROL_REST, ROL_REST, ROL_LENGTH + 25, 28h
    db ROL_LENGTH + 1, ROL_REST, ROL_TRANSPOSE, 00h, ROL_END_PATTERN
Tune3Pattern_1653 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 4Ah, ROL_LENGTH + 24, 2Dh, ROL_TIE, 30h, ROL_LENGTH + 12, 32h, 34h, ROL_LENGTH + 24
    db 2Dh, ROL_TIE, 30h, ROL_LENGTH + 12, 32h, 34h, ROL_END_PATTERN
Tune3Pattern_1666 label byte
    db ROL_LENGTH + 12, 29h, ROL_LENGTH + 2, 29h, ROL_REST, 29h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 29h, ROL_LENGTH + 2, 29h
    db ROL_REST, 29h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 29h, ROL_LENGTH + 2, 29h, ROL_REST, 29h, ROL_REST, ROL_REST
    db ROL_LENGTH + 14, 29h, ROL_LENGTH + 2, 29h, ROL_REST, 29h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 2Bh, ROL_LENGTH + 2, 2Bh
    db ROL_REST, 2Bh, ROL_REST, ROL_REST, ROL_LENGTH + 14, 2Bh, ROL_LENGTH + 2, 2Bh, ROL_REST, 2Bh, ROL_REST, ROL_REST
    db ROL_LENGTH + 14, 2Dh, ROL_LENGTH + 2, 2Dh, ROL_REST, 2Dh, ROL_REST, ROL_REST, ROL_LENGTH + 26, 2Dh, ROL_END_PATTERN
Tune3Pattern_16A1 label byte
    db ROL_LENGTH + 32, 32h, ROL_LENGTH + 2, ROL_REST, 32h, ROL_REST, ROL_REST, 32h, ROL_REST, ROL_REST, 32h, ROL_LENGTH + 32
    db 32h, ROL_LENGTH + 2, ROL_REST, 32h, ROL_REST, ROL_REST, 32h, ROL_REST, ROL_REST, 32h, ROL_LENGTH + 32, 32h
    db ROL_LENGTH + 2, ROL_REST, 32h, ROL_REST, ROL_REST, 32h, ROL_REST, ROL_REST, 32h, ROL_LENGTH + 24, 32h, ROL_TIE
    db ROL_END_PATTERN
Tune3Pattern_16C6 label byte
    db ROL_LENGTH + 31, 2Dh, ROL_LENGTH + 2, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_LENGTH + 4, ROL_REST, ROL_LENGTH + 3, 2Dh
    db ROL_LENGTH + 24, 30h, 32h, ROL_LENGTH + 31, 2Dh, ROL_LENGTH + 2, ROL_REST, 2Dh, ROL_REST, ROL_REST, 2Dh, ROL_LENGTH + 4
    db ROL_REST, ROL_LENGTH + 3, 2Dh, ROL_LENGTH + 24, 32h, ROL_LENGTH + 23, ROL_TIE, ROL_LENGTH + 1, ROL_REST, ROL_END_PATTERN
Tune3Pattern_16E8 label byte
    db ROL_TRANSPOSE, 07h, ROL_LENGTH + 12, 1Dh, ROL_LENGTH + 2, 1Dh, ROL_REST, 1Dh, ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Dh
    db ROL_LENGTH + 2, 1Dh, ROL_REST, 1Dh, ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Dh, ROL_LENGTH + 2, 1Dh, ROL_REST, 1Dh
    db ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Dh, ROL_LENGTH + 2, 1Dh, ROL_REST, 1Dh, ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Fh
    db ROL_LENGTH + 2, 1Fh, ROL_REST, 1Fh, ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Fh, ROL_LENGTH + 2, 1Fh, ROL_REST, 1Fh
    db ROL_REST, ROL_REST, ROL_LENGTH + 14, 21h, ROL_LENGTH + 2, 21h, ROL_REST, 21h, ROL_REST, ROL_REST, ROL_LENGTH + 25, 21h
    db ROL_LENGTH + 1, ROL_REST, ROL_TRANSPOSE, 00h, ROL_END_PATTERN
Tune3Pattern_1729 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 4Ah, ROL_LENGTH + 24, 26h, ROL_TIE, 29h, ROL_LENGTH + 12, 2Bh, 2Dh, ROL_LENGTH + 24
    db 26h, ROL_TIE, 29h, ROL_LENGTH + 12, 2Bh, 2Dh, ROL_END_PATTERN
Tune3Pattern_173C label byte
    db ROL_LENGTH + 12, 24h, ROL_LENGTH + 2, 24h, ROL_REST, 24h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 24h, ROL_LENGTH + 2, 24h
    db ROL_REST, 24h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 24h, ROL_LENGTH + 2, 24h, ROL_REST, 24h, ROL_REST, ROL_REST
    db ROL_LENGTH + 14, 24h, ROL_LENGTH + 2, 24h, ROL_REST, 24h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 26h, ROL_LENGTH + 2, 26h
    db ROL_REST, 26h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 26h, ROL_LENGTH + 2, 26h, ROL_REST, 26h, ROL_REST, ROL_REST
    db ROL_LENGTH + 14, 28h, ROL_LENGTH + 2, 28h, ROL_REST, 28h, ROL_REST, ROL_REST, ROL_LENGTH + 26, 28h, ROL_END_PATTERN
Tune3Pattern_1777 label byte
    db ROL_LENGTH + 32, 21h, ROL_LENGTH + 2, ROL_REST, 21h, ROL_REST, ROL_REST, 21h, ROL_REST, ROL_REST, 21h, ROL_LENGTH + 32
    db 21h, ROL_LENGTH + 2, ROL_REST, 21h, ROL_REST, ROL_REST, 21h, ROL_REST, ROL_REST, 21h, ROL_LENGTH + 32, 21h
    db ROL_LENGTH + 2, ROL_REST, 21h, ROL_REST, ROL_REST, 21h, ROL_REST, ROL_REST, 21h, ROL_LENGTH + 24, 21h, ROL_TIE
    db ROL_END_PATTERN
Tune3Pattern_179C label byte
    db ROL_LENGTH + 31, 26h, ROL_LENGTH + 2, ROL_REST, 28h, ROL_REST, ROL_REST, 28h, ROL_LENGTH + 4, ROL_REST, ROL_LENGTH + 3, 28h
    db ROL_LENGTH + 24, 29h, 2Bh, ROL_LENGTH + 31, 28h, ROL_LENGTH + 2, ROL_REST, 28h, ROL_REST, ROL_REST, 28h, ROL_LENGTH + 4
    db ROL_REST, ROL_LENGTH + 3, 28h, ROL_LENGTH + 24, 2Bh, ROL_LENGTH + 23, ROL_TIE, ROL_LENGTH + 1, ROL_REST, ROL_END_PATTERN
Tune3Pattern_17BE label byte
    db ROL_TRANSPOSE, 07h, ROL_LENGTH + 12, 18h, ROL_LENGTH + 2, 18h, ROL_REST, 18h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 18h
    db ROL_LENGTH + 2, 18h, ROL_REST, 18h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 18h, ROL_LENGTH + 2, 18h, ROL_REST, 18h
    db ROL_REST, ROL_REST, ROL_LENGTH + 14, 18h, ROL_LENGTH + 2, 18h, ROL_REST, 18h, ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Ah
    db ROL_LENGTH + 2, 1Ah, ROL_REST, 1Ah, ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Ah, ROL_LENGTH + 2, 1Ah, ROL_REST, 1Ah
    db ROL_REST, ROL_REST, ROL_LENGTH + 14, 1Ch, ROL_LENGTH + 2, 1Ch, ROL_REST, 1Ch, ROL_REST, ROL_REST, ROL_LENGTH + 25, 1Ch
    db ROL_LENGTH + 1, ROL_REST, ROL_TRANSPOSE, 00h, ROL_END_PATTERN
Tune3Pattern_17FF label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 7Fh, ROL_BEND_RANGE, 02h, ROL_EFFECT_PERIOD, 01h, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 6, 3Ch, ROL_LENGTH + 3, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 6, 3Ch, ROL_PITCH_ENVELOPE
    dw 0FFFCh
    dw 1004h
    db ROL_TIE, ROL_LENGTH + 24, 39h, ROL_LENGTH + 2, 37h, 39h, 37h, 35h, 34h, ROL_LENGTH + 14, 32h, ROL_LENGTH + 9
    db 37h, 3Eh, 3Ch, 37h, ROL_LENGTH + 6, ROL_PITCH_ENVELOPE
    dw 0FFF9h
    dw 090Ch
    db 3Eh, 39h, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1030h
    db ROL_LENGTH + 24, 37h, ROL_TIE, ROL_LENGTH + 4, 32h, ROL_LENGTH + 2, 37h, 39h, ROL_TIE, 32h, 37h, 39h
    db 32h, 37h, 39h, 32h, 35h, ROL_TIE, 37h, 39h, ROL_TIE, 32h, 37h, 39h
    db 32h, 37h, 39h, 32h, 37h, ROL_TIE, 39h, 3Ch, ROL_TIE, 37h, 39h, 3Ch
    db 37h, 39h, ROL_LENGTH + 4, 3Ch, ROL_BEND_RANGE, 05h, ROL_PITCH_ENVELOPE
    dw 0002h
    dw 2024h
    db ROL_LENGTH + 24, 39h, ROL_LENGTH + 2, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h
    db 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h
    db 3Eh, 39h, 32h, 3Ch, 35h, 32h, 3Ch, 35h, 32h, 3Ch, 35h, 32h
    db 3Ch, 35h, 32h, 3Eh, 37h, 32h, 3Eh, 37h, 32h, 40h, 39h, 34h
    db ROL_LENGTH + 6, 40h, ROL_END_PATTERN
Tune3Pattern_18B3 label byte
    db ROL_LENGTH + 4, 29h, ROL_LENGTH + 2, 2Bh, ROL_LENGTH + 4, 2Ch, ROL_LENGTH + 2, 2Eh, 2Ch, 2Eh, 30h, ROL_LENGTH + 22
    db 33h, ROL_LENGTH + 2, ROL_REST, 30h, 2Eh, 2Ch, ROL_LENGTH + 24, 2Eh, 2Bh, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 2
    db 2Dh, ROL_LENGTH + 4, 2Eh, ROL_LENGTH + 2, 30h, 2Eh, 30h, 32h, ROL_LENGTH + 22, 35h, ROL_LENGTH + 2, ROL_REST
    db 32h, 30h, 2Dh, ROL_LENGTH + 24, 31h, 34h, ROL_END_PATTERN
Tune3Pattern_18DE label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 2Ch, ROL_LENGTH + 32, 26h, ROL_LENGTH + 2, ROL_REST, 26h, ROL_REST, ROL_REST, 26h
    db ROL_REST, ROL_REST, 26h, ROL_LENGTH + 32, 26h, ROL_LENGTH + 2, ROL_REST, 26h, ROL_REST, ROL_REST, 26h, ROL_REST
    db ROL_REST, 26h, ROL_LENGTH + 32, 26h, ROL_LENGTH + 2, ROL_REST, 26h, ROL_REST, ROL_REST, 26h, ROL_REST, ROL_REST
    db 26h, ROL_LENGTH + 24, 26h, ROL_TIE, ROL_END_PATTERN
Tune3Pattern_1907 label byte
    db ROL_PROGRAM, 2Ch, ROL_TRANSPOSE, 00h, ROL_BEND_RANGE, 02h, ROL_VELOCITY, 78h, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 6, 3Ch, ROL_LENGTH + 3, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 30, 3Ch, ROL_LENGTH + 2, 3Ch, 3Ah, ROL_LENGTH + 1, 39h, 37h, ROL_LENGTH + 24, 35h, ROL_LENGTH + 2, 32h
    db 32h, 34h, 34h, ROL_REST, 37h, 37h, ROL_REST, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0003h
    dw 1507h
    db ROL_LENGTH + 9, 37h, ROL_PITCH_ENVELOPE
    dw 0003h
    dw 1507h
    db ROL_LENGTH + 9, 37h, 34h, 37h, ROL_LENGTH + 6, ROL_REST, ROL_LENGTH + 3, 34h, ROL_LENGTH + 1, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db ROL_LENGTH + 12, 39h, ROL_VELOCITY, 60h, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db 39h, ROL_VELOCITY, 40h, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db 39h, ROL_VELOCITY, 20h, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db ROL_LENGTH + 14, 39h, ROL_PROGRAM, 2Bh, ROL_VELOCITY, 6Eh, ROL_LENGTH + 2, 26h, 2Dh, ROL_LENGTH + 6, 32h, 32h
    db 32h, ROL_LENGTH + 2, 32h, ROL_LENGTH + 2, 28h, 2Dh, ROL_LENGTH + 6, 34h, 34h, 34h, ROL_LENGTH + 2, 34h
    db 29h, 2Dh, 35h, 29h, 2Dh, 35h, 35h, 3Ch, ROL_TIE, 29h, 30h, ROL_TIE
    db 2Bh, 32h, 37h, 2Bh, 32h, 37h, 37h, 3Eh, ROL_TIE, 2Bh, 32h, ROL_TIE
    db 2Dh, 34h, 39h, 2Dh, 34h, 39h, 34h, 39h, 34h, 2Dh, 34h, 2Dh
    db 34h, 32h, 2Fh, 2Dh, 2Bh, 28h, 40h, 3Eh, 3Bh, 39h, 37h, 34h
    db ROL_LENGTH + 24, 37h, ROL_PROGRAM, 2Ch, ROL_LENGTH + 12, 3Eh, ROL_LENGTH + 11, 43h, ROL_LENGTH + 1, ROL_REST, ROL_END_PATTERN
Tune3Pattern_19C0 label byte
    db ROL_PROGRAM, 2Ch, ROL_TRANSPOSE, 07h, ROL_VELOCITY, 78h, ROL_LENGTH + 4, 29h, ROL_LENGTH + 2, 2Bh, ROL_LENGTH + 4, 2Ch
    db ROL_LENGTH + 2, 2Eh, 2Ch, 2Eh, 30h, ROL_LENGTH + 22, 33h, ROL_LENGTH + 2, ROL_REST, 30h, 2Eh, 2Ch
    db ROL_LENGTH + 24, 2Eh, 2Bh, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 2Eh, ROL_LENGTH + 2, 30h, 2Eh
    db 30h, 32h, ROL_LENGTH + 22, 35h, ROL_LENGTH + 2, ROL_REST, 32h, 30h, 2Dh, ROL_LENGTH + 24, 31h, ROL_LENGTH + 23
    db 34h, ROL_LENGTH + 1, ROL_REST, ROL_TRANSPOSE, 00h, ROL_END_PATTERN
Tune3Pattern_19F6 label byte
    db ROL_LENGTH + 2, ROL_REST, ROL_PROGRAM, 2Ch, ROL_VELOCITY, 4Ch, ROL_BEND_RANGE, 02h, ROL_EFFECT_PERIOD, 01h, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 6, 3Ch, ROL_LENGTH + 3, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 6, 3Ch, ROL_PITCH_ENVELOPE
    dw 0FFFCh
    dw 1004h
    db ROL_TIE, ROL_LENGTH + 24, 39h, ROL_LENGTH + 2, 37h, 39h, 37h, 35h, 34h, ROL_LENGTH + 14, 32h, ROL_LENGTH + 9
    db 37h, 3Eh, 3Ch, 37h, ROL_LENGTH + 6, ROL_PITCH_ENVELOPE
    dw 0FFF9h
    dw 090Ch
    db 3Eh, 39h, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1030h
    db ROL_LENGTH + 24, 37h, ROL_TIE, ROL_LENGTH + 4, 32h, ROL_LENGTH + 2, 37h, 39h, ROL_TIE, 32h, 37h, 39h
    db 32h, 37h, 39h, 32h, 35h, ROL_TIE, 37h, 39h, ROL_TIE, 32h, 37h, 39h
    db 32h, 37h, 39h, 32h, 37h, ROL_TIE, 39h, 3Ch, ROL_TIE, 37h, 39h, 3Ch
    db 37h, 39h, ROL_LENGTH + 4, 3Ch, ROL_BEND_RANGE, 05h, ROL_PITCH_ENVELOPE
    dw 0002h
    dw 2024h
    db ROL_LENGTH + 24, 39h, ROL_LENGTH + 2, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h
    db 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h
    db 3Eh, 39h, 32h, 3Ch, 35h, 32h, 3Ch, 35h, 32h, 3Ch, 35h, 32h
    db 3Ch, 35h, 32h, 3Eh, 37h, 32h, 3Eh, 37h, 32h, 40h, 39h, 34h
    db ROL_LENGTH + 4, 40h, ROL_END_PATTERN
Tune3Pattern_1AAC label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_VELOCITY, 6Ch, ROL_LENGTH + 4, 29h, ROL_LENGTH + 2, 2Bh, 2Ch, ROL_TIE, 2Eh
    db 2Ch, 2Eh, 30h, ROL_LENGTH + 22, 33h, ROL_LENGTH + 2, ROL_REST, 30h, 2Eh, 2Ch, ROL_LENGTH + 24, 2Eh
    db 2Bh, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 2, 2Fh, ROL_LENGTH + 4, 30h, ROL_LENGTH + 2, 32h, 30h, 32h, 34h
    db ROL_LENGTH + 18, 37h, ROL_LENGTH + 12, 39h, ROL_END_PATTERN
Tune3Pattern_1AD5 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_PROGRAM, 2Bh, ROL_VELOCITY, 40h, ROL_LENGTH + 2, 23h, 28h
    db 2Ah, 2Dh, 2Ah, 2Dh, 2Fh, 2Dh, 2Fh, 32h, 2Fh, 32h, 2Fh, 34h
    db 36h, 39h, 36h, 39h, 3Bh, 39h, 3Bh, 3Eh, 3Bh, 3Eh, 23h, 28h
    db 2Ah, 2Dh, 2Ah, 2Dh, 2Fh, 2Dh, 2Fh, 32h, 2Fh, 32h, 2Fh, 34h
    db 36h, 39h, 36h, 39h, 3Bh, 39h, 3Bh, 3Eh, 3Bh, 3Eh, ROL_END_PATTERN
Tune3Pattern_1B10 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_PROGRAM, 2Ch, ROL_TRANSPOSE, 07h, ROL_VELOCITY, 6Ch, ROL_LENGTH + 4, 29h, ROL_LENGTH + 2
    db 2Bh, 2Ch, ROL_TIE, 2Eh, 2Ch, 2Eh, 30h, ROL_LENGTH + 22, 33h, ROL_LENGTH + 2, ROL_REST, 30h
    db 2Eh, 2Ch, ROL_LENGTH + 24, 2Eh, 2Bh, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 2, 2Fh, ROL_LENGTH + 4, 30h, ROL_LENGTH + 2
    db 32h, 30h, 32h, 34h, ROL_LENGTH + 18, 37h, ROL_LENGTH + 11, 39h, ROL_LENGTH + 1, ROL_REST, ROL_TRANSPOSE, 00h
    db ROL_END_PATTERN
Tune3Pattern_1B41 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 4Ch, ROL_BEND_RANGE, 02h, ROL_LENGTH + 2, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 6, 3Ch, ROL_LENGTH + 3, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db 3Ch, ROL_TIE, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0004h
    dw 1004h
    db ROL_LENGTH + 30, 3Ch, ROL_LENGTH + 2, 3Ch, 3Ah, ROL_LENGTH + 1, 39h, 37h, ROL_LENGTH + 24, 35h, ROL_LENGTH + 2, 32h
    db 32h, 34h, 34h, ROL_REST, 37h, 37h, ROL_REST, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0003h
    dw 1507h
    db ROL_LENGTH + 9, 37h, ROL_PITCH_ENVELOPE
    dw 0003h
    dw 1507h
    db ROL_LENGTH + 9, 37h, 34h, 37h, ROL_LENGTH + 6, ROL_REST, ROL_LENGTH + 3, 34h, ROL_LENGTH + 1, ROL_REST, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db ROL_LENGTH + 12, 39h, ROL_VELOCITY, 30h, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db 39h, ROL_VELOCITY, 20h, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db 39h, ROL_VELOCITY, 10h, ROL_PITCH_ENVELOPE
    dw 0FFFDh
    dw 1505h
    db ROL_LENGTH + 14, 39h, ROL_PROGRAM, 2Bh, ROL_VELOCITY, 46h, ROL_LENGTH + 2, 26h, 2Dh, ROL_LENGTH + 6, 32h, 32h
    db 32h, ROL_LENGTH + 2, 32h, ROL_LENGTH + 2, 28h, 2Dh, ROL_LENGTH + 6, 34h, 34h, 34h, ROL_LENGTH + 2, 34h
    db 29h, 2Dh, 35h, 29h, 2Dh, 35h, 35h, 3Ch, ROL_TIE, 29h, 30h, ROL_TIE
    db 2Bh, 32h, 37h, 2Bh, 32h, 37h, 37h, 3Eh, ROL_TIE, 2Bh, 32h, ROL_TIE
    db 2Dh, 34h, 39h, 2Dh, 34h, 39h, 34h, 39h, 34h, 2Dh, 34h, 2Dh
    db 34h, 32h, 2Fh, 2Dh, 2Bh, 28h, 40h, 3Eh, 3Bh, 39h, 37h, 34h
    db ROL_LENGTH + 24, 37h, ROL_PROGRAM, 2Ch, ROL_LENGTH + 12, 3Eh, ROL_LENGTH + 9, 43h, ROL_LENGTH + 1, ROL_REST, ROL_END_PATTERN
; Tune 4: 5 timer ticks per row, 8 channels, order list per channel.
Tune4 db 5, 8
    dw offset Tune4Order0, offset Tune4Order1, offset Tune4Order2, offset Tune4Order3
    dw offset Tune4Order4, offset Tune4Order5, offset Tune4Order6, offset Tune4Order7
Tune4Order0 label word
    dw offset Tune4Pattern_1D3D
Tune4OrderLoop_1C0E label word
    dw offset Tune4Pattern_1D62
    dw 0, offset Tune4OrderLoop_1C0E
Tune4Order1 label word
    dw offset Tune4Pattern_1DA5
Tune4Order2 label word
    dw offset Tune4Pattern_1DBB
Tune4OrderLoop_1C18 label word
    dw offset Tune4Pattern_1DBF
    dw offset Tune4Pattern_1DF1
    dw 0, offset Tune4OrderLoop_1C18
Tune4Order3 label word
    dw offset Tune4Pattern_1C44
Tune4OrderLoop_1C22 label word
    dw offset Tune4Pattern_1C67
    dw 0, offset Tune4OrderLoop_1C22
Tune4Order4 label word
    dw offset Tune4Pattern_1C97
Tune4OrderLoop_1C2A label word
    dw offset Tune4Pattern_1CBA
    dw 0, offset Tune4OrderLoop_1C2A
Tune4Order5 label word
    dw offset Tune4Pattern_1CEA
Tune4OrderLoop_1C32 label word
    dw offset Tune4Pattern_1D0D
    dw 0, offset Tune4OrderLoop_1C32
Tune4Order6 label word
    dw offset Tune4Pattern_1E21
    dw 0, offset Tune4Order6
Tune4Order7 label word
    dw offset Tune4Pattern_1EBB
    dw 0, offset Tune4Order7
Tune4Pattern_1C44 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 28h, ROL_REST, 2Bh, ROL_REST, 28h, ROL_REST, ROL_VELOCITY
    db 7Fh, ROL_LENGTH + 3, 2Bh, ROL_REST, 2Dh, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 28h, ROL_REST, 2Bh
    db ROL_REST, 28h, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 2Bh, ROL_REST, 2Dh, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1C67 label byte
    db ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 28h, ROL_REST, 2Bh, ROL_REST, 28h, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3
    db 2Bh, ROL_REST, 2Dh, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 28h, ROL_REST, 2Bh, ROL_REST, 28h
    db ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 2Bh, ROL_REST, 2Dh, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 24, 2Fh
    db ROL_TIE, 2Dh, ROL_LENGTH + 12, 28h, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 2Dh, ROL_REST, 2Fh, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1C97 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 23h, ROL_REST, 28h, ROL_REST, 23h, ROL_REST, ROL_VELOCITY
    db 7Fh, ROL_LENGTH + 3, 28h, ROL_REST, 28h, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 23h, ROL_REST, 28h
    db ROL_REST, 23h, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 28h, ROL_REST, 28h, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1CBA label byte
    db ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 23h, ROL_REST, 28h, ROL_REST, 23h, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3
    db 28h, ROL_REST, 28h, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 23h, ROL_REST, 28h, ROL_REST, 23h
    db ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 28h, ROL_REST, 28h, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 24, 2Dh
    db ROL_TIE, 28h, ROL_LENGTH + 12, 24h, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 28h, ROL_REST, 2Bh, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1CEA label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 21h, ROL_REST, 24h, ROL_REST, 21h, ROL_REST, ROL_VELOCITY
    db 7Fh, ROL_LENGTH + 3, 24h, ROL_REST, 26h, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 21h, ROL_REST, 24h
    db ROL_REST, 21h, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 24h, ROL_REST, 26h, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1D0D label byte
    db ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 21h, ROL_REST, 24h, ROL_REST, 21h, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3
    db 24h, ROL_REST, 26h, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 6, 21h, ROL_REST, 24h, ROL_REST, 21h
    db ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 24h, ROL_REST, 26h, ROL_REST, ROL_VELOCITY, 6Eh, ROL_LENGTH + 24, 28h
    db ROL_TIE, 26h, ROL_LENGTH + 12, 2Bh, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 26h, ROL_REST, 28h, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1D3D label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch
    db 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2
    db 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ROL_END_PATTERN
Tune4Pattern_1D62 label byte
    db ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6
    db 0Eh, 0Ch, 0Eh, 0Ch, ROL_LENGTH + 2, 0Eh, ROL_REST, 0Eh, ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6
    db 0Eh, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, ROL_LENGTH + 6, 0Eh, 0Ch, 0Eh, ROL_LENGTH + 2
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ROL_END_PATTERN
Tune4Pattern_1DA5 label byte
    db ROL_VELOCITY, 6Ch, ROL_LENGTH + 6
Tune4Pattern_1DA8 label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, ROL_REST, ROL_JUMP
    dw offset Tune4Pattern_1DA8
Tune4Pattern_1DBB label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 68h
Tune4Pattern_1DBF label byte
    db ROL_LENGTH + 2, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 18h, 18h
    db 18h, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 1Ah, ROL_REST
    db 1Ah, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 18h, 18h
    db 18h, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 1Ah, ROL_REST
    db 1Ah, ROL_END_PATTERN
Tune4Pattern_1DF1 label byte
    db 1Ch, 1Ch, 1Ch, 1Ch, 1Ch, 1Ch, 1Ah, 1Ch, 1Ch, 1Ch, 1Ch, 1Ch
    db 1Ah, 1Ch, 1Ch, 1Ch, 1Ch, 1Ch, 1Ah, 1Ch, 1Ch, 1Ch, 1Ch, 1Ch
    db 1Ah, 1Ah, 1Ah, 1Ah, 1Ah, 1Ah, 18h, 1Ah, 1Ah, 1Ah, 1Ah, 1Ah
    db 18h, 18h, 18h, 18h, 18h, 18h, ROL_LENGTH + 3, 13h, ROL_REST, 1Ch, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1E21 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_PROGRAM, 2Ch, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 40h, ROL_REST
    db ROL_VELOCITY, 3Ch, 40h, ROL_REST, ROL_VELOCITY, 1Fh, 40h, ROL_REST, ROL_VELOCITY, 0Ah, 40h, ROL_LENGTH + 27
    db ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 43h, ROL_REST, ROL_VELOCITY, 3Ch, 43h, ROL_REST, ROL_VELOCITY, 1Fh
    db 43h, ROL_REST, ROL_VELOCITY, 0Ah, 43h, ROL_LENGTH + 27, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 40h, ROL_REST
    db ROL_VELOCITY, 3Ch, 40h, ROL_REST, ROL_VELOCITY, 32h, 40h, ROL_REST, ROL_VELOCITY, 28h, 40h, ROL_REST
    db 40h, ROL_REST, ROL_VELOCITY, 1Eh, 40h, ROL_REST, ROL_VELOCITY, 14h, 40h, ROL_REST, ROL_VELOCITY, 0Ah
    db 40h, ROL_REST, ROL_VELOCITY, 7Fh, 3Eh, ROL_REST, ROL_VELOCITY, 3Ch, 3Eh, ROL_REST, ROL_VELOCITY, 32h
    db 3Eh, ROL_REST, ROL_VELOCITY, 28h, 3Eh, ROL_REST, 3Eh, ROL_REST, ROL_VELOCITY, 1Eh, 3Eh, ROL_REST
    db ROL_VELOCITY, 14h, 3Eh, ROL_REST, ROL_VELOCITY, 0Ah, 3Eh, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 2, 3Bh
    db 39h, 3Ch, 3Bh, 3Ch, 3Eh, ROL_LENGTH + 18, 40h, ROL_TIE, ROL_VELOCITY, 6Eh, ROL_LENGTH + 2, 3Bh
    db 39h, 3Ch, 3Bh, 3Ch, 3Eh, ROL_LENGTH + 18, 40h, ROL_TIE, ROL_LENGTH + 2, 2Fh, 34h, 37h
    db 39h, ROL_LENGTH + 4, 3Bh, ROL_LENGTH + 18, 3Eh, ROL_TIE, ROL_LENGTH + 2, 2Fh, 34h, 37h, 39h, ROL_LENGTH + 4
    db 3Bh, ROL_LENGTH + 18, 3Eh, ROL_TIE, ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_END_PATTERN
Tune4Pattern_1EBB label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_LENGTH + 1, ROL_REST, ROL_PROGRAM, 2Ch, ROL_VOLUME, 4Eh, ROL_LENGTH + 3
    db 40h, ROL_REST, ROL_VELOCITY, 3Ch, 40h, ROL_REST, ROL_VELOCITY, 1Fh, 40h, ROL_REST, ROL_VELOCITY, 0Ah
    db 40h, ROL_LENGTH + 27, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3, 43h, ROL_REST, ROL_VELOCITY, 3Ch, 43h, ROL_REST
    db ROL_VELOCITY, 1Fh, 43h, ROL_REST, ROL_VELOCITY, 0Ah, 43h, ROL_LENGTH + 27, ROL_REST, ROL_VELOCITY, 7Fh, ROL_LENGTH + 3
    db 40h, ROL_REST, ROL_VELOCITY, 3Ch, 40h, ROL_REST, ROL_VELOCITY, 32h, 40h, ROL_REST, ROL_VELOCITY, 28h
    db 40h, ROL_REST, 40h, ROL_REST, ROL_VELOCITY, 1Eh, 40h, ROL_REST, ROL_VELOCITY, 14h, 40h, ROL_REST
    db ROL_VELOCITY, 0Ah, 40h, ROL_REST, ROL_VELOCITY, 7Fh, 3Eh, ROL_REST, ROL_VELOCITY, 3Ch, 3Eh, ROL_REST
    db ROL_VELOCITY, 32h, 3Eh, ROL_REST, ROL_VELOCITY, 28h, 3Eh, ROL_REST, 3Eh, ROL_REST, ROL_VELOCITY, 1Eh
    db 3Eh, ROL_REST, ROL_VELOCITY, 14h, 3Eh, ROL_REST, ROL_VELOCITY, 0Ah, 3Eh, ROL_REST, ROL_LENGTH + 23, ROL_REST
    db ROL_VELOCITY, 7Fh, ROL_LENGTH + 2, 3Bh, 39h, 3Ch, 3Bh, 3Ch, 3Eh, ROL_LENGTH + 18, 40h, ROL_TIE
    db ROL_LENGTH + 2, 3Bh, 39h, 3Ch, 3Bh, 3Ch, 3Eh, ROL_LENGTH + 18, 40h, ROL_TIE, ROL_LENGTH + 2, 2Fh
    db 34h, 37h, 39h, ROL_LENGTH + 4, 3Bh, ROL_LENGTH + 18, 3Eh, ROL_TIE, ROL_LENGTH + 2, 2Fh, 34h, 37h
    db 39h, 3Bh, ROL_REST, ROL_LENGTH + 3, 32h, ROL_REST, 2Fh, ROL_REST, ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_REST
    db ROL_REST, ROL_END_PATTERN
; Tune 5: 5 timer ticks per row, 7 channels, order list per channel.
Tune5 db 5, 7
    dw offset Tune5Order0, offset Tune5Order1, offset Tune5Order2, offset Tune5Order3
    dw offset Tune5Order4, offset Tune5Order5, offset Tune5Order6
Tune5Order2 label word
    dw offset Tune5Pattern_1F77
Tune5Order0 label word
    dw offset Tune5Pattern_1FB5
Tune5Order3 label word
    dw offset Tune5Pattern_1FCD
Tune5Order4 label word
    dw offset Tune5Pattern_1FE7
Tune5Order5 label word
    dw offset Tune5Pattern_2011
Tune5Order6 label word
    dw offset Tune5Pattern_206A
Tune5Order1 label word
    dw offset Tune5Pattern_2001
Tune5Pattern_1F77 label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 63h, ROL_LENGTH + 2, 09h, 0Eh, 13h, 0Eh, 13h, 15h
Tune5Pattern_1F82 label byte
    db 0Eh, 13h, 15h, 18h, 15h, 1Ah, 1Fh, 18h, 13h, 15h, 13h, 0Eh
    db 11h, 16h, 18h, 1Bh, 18h, 1Dh, 22h, 1Bh, 16h, 18h, 16h, 11h
    db 0Eh, 13h, 15h, 18h, 15h, 1Ah, 1Fh, 18h, 13h, 15h, 13h, 0Eh
    db 13h, 18h, 1Ah, 1Dh, 1Ah, 1Fh, 24h, 1Dh, 18h, 1Ah, 18h, 13h
    db ROL_JUMP
    dw offset Tune5Pattern_1F82
Tune5Pattern_1FB5 label byte
    db ROL_LENGTH + 2, ROL_VELOCITY, 78h, 0Eh, 0Eh, 0Ch, 0Eh, 0Eh, 0Ch, 0Eh, 0Ch, 0Ch
    db 0Eh, 0Ch, 0Ch, 0Eh, 0Eh, 0Ch, 0Eh, 0Eh, 0Ch, ROL_JUMP
    dw offset Tune5Pattern_1FB5
Tune5Pattern_1FCD label byte
    db ROL_LENGTH + 12, ROL_REST, ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ch, ROL_LENGTH + 6
Tune5Pattern_1FD4 label byte
    db 2Dh, 2Bh, 2Eh, 2Dh, 30h, 2Eh, 2Dh, 2Bh, 2Dh, 2Bh, 2Eh, 2Dh
    db 32h, 30h, 2Eh, 2Bh, ROL_JUMP
    dw offset Tune5Pattern_1FD4
Tune5Pattern_1FE7 label byte
    db ROL_LENGTH + 12, ROL_REST, ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ch, ROL_LENGTH + 6
Tune5Pattern_1FEE label byte
    db 21h, 1Fh, 22h, 21h, 24h, 22h, 21h, 1Fh, 21h, 1Fh, 22h, 21h
    db 26h, 24h, 22h, 1Fh, ROL_JUMP
    dw offset Tune5Pattern_1FEE
Tune5Pattern_2001 label byte
    db ROL_VELOCITY, 64h, ROL_LENGTH + 6, ROL_REST, ROL_REST
Tune5Pattern_2006 label byte
    db 12h, 12h, ROL_LENGTH + 4, 12h, ROL_LENGTH + 2, 16h, ROL_LENGTH + 6, 12h, ROL_JUMP
    dw offset Tune5Pattern_2006
Tune5Pattern_2011 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 68h, ROL_LENGTH + 2, 21h, 26h, 2Bh, 26h, 2Bh, 2Dh
Tune5Pattern_201C label byte
    db ROL_LENGTH + 32, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_LENGTH + 18, 39h, ROL_LENGTH + 2, 37h, 32h
    db 39h, ROL_LENGTH + 24, 3Ch, ROL_LENGTH + 18, 39h, ROL_LENGTH + 2, 37h, 32h, 37h, ROL_LENGTH + 4, 39h, ROL_LENGTH + 20
    db 37h, ROL_LENGTH + 18, 39h, ROL_LENGTH + 2, 37h, 32h, 39h, ROL_LENGTH + 24, 3Ch, ROL_LENGTH + 18, 39h, ROL_LENGTH + 2
    db 37h, 32h, 37h, ROL_LENGTH + 4, 39h, ROL_LENGTH + 20, 37h, ROL_LENGTH + 18, 40h, ROL_LENGTH + 2, 3Eh, 3Ch
    db 39h, ROL_LENGTH + 24, 35h, ROL_LENGTH + 18, 40h, ROL_LENGTH + 2, 3Eh, 3Ch, 39h, ROL_LENGTH + 24, 37h, ROL_LENGTH + 18
    db 40h, ROL_LENGTH + 2, 3Eh, 3Ch, 39h, ROL_LENGTH + 24, 35h, ROL_LENGTH + 18, 40h, ROL_LENGTH + 2, 3Eh, 3Ch
    db 39h, ROL_LENGTH + 24, 37h, ROL_JUMP
    dw offset Tune5Pattern_201C
Tune5Pattern_206A label byte
    db ROL_LENGTH + 2, ROL_REST, ROL_PROGRAM, 2Ch, ROL_VELOCITY, 55h, 21h, 26h, 2Bh, 26h, 2Bh, 2Dh
    db ROL_JUMP
    dw offset Tune5Pattern_201C
; Tune 6: 5 timer ticks per row, 8 channels, order list per channel.
Tune6 db 5, 8
    dw offset Tune6Order0, offset Tune6Order1, offset Tune6Order2, offset Tune6Order3
    dw offset Tune6Order4, offset Tune6Order5, offset Tune6Order6, offset Tune6Order7
Tune6Order0 label word
    dw offset Tune6Pattern_209B
Tune6Order1 label word
    dw offset Tune6Pattern_20D1
Tune6Order2 label word
    dw offset Tune6Pattern_20DF
Tune6Order3 label word
    dw offset Tune6Pattern_211D
Tune6Order4 label word
    dw offset Tune6Pattern_212D
Tune6Order5 label word
    dw offset Tune6Pattern_213D
Tune6Order6 label word
    dw offset Tune6Pattern_214D
Tune6Order7 label word
    dw offset Tune6Pattern_2255
Tune6Pattern_209B label byte
    db ROL_VELOCITY, 7Fh, ROL_LENGTH + 4, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, ROL_REST, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, ROL_REST, 0Ch, 0Ch, ROL_REST, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Ch, 0Ch
    db 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, ROL_REST, 0Eh, ROL_REST, ROL_REST, 0Ch, 0Ch, ROL_REST
    db 0Eh, ROL_REST, ROL_REST, ROL_JUMP
    dw offset Tune6Pattern_209B
Tune6Pattern_20D1 label byte
    db ROL_LENGTH + 3, ROL_VELOCITY, 6Ch
Tune6Pattern_20D4 label byte
    db 12h, ROL_REST, 12h, ROL_REST, 12h, ROL_REST, 12h, ROL_REST, ROL_JUMP
    dw offset Tune6Pattern_20D4
Tune6Pattern_20DF label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 66h, ROL_LENGTH + 2, 06h, 0Ah, 0Dh, 06h, 0Ah, 0Dh, 06h
    db 0Ah, 0Dh, 06h, 0Ah, 0Dh, 06h, 0Ah, 0Dh, 06h, 0Ah, 0Dh, 06h
    db 0Ah, 0Dh, 06h, 0Ah, 0Dh, 08h, 0Dh, 0Fh, 08h, 0Dh, 0Fh, 08h
    db 0Dh, 0Fh, 08h, 0Dh, 0Fh, 08h, 0Dh, 0Fh, 08h, 0Dh, 0Fh, 08h
    db 0Dh, 0Fh, 08h, 0Dh, 0Fh
Tune6Pattern_2114 label byte
    db 0Ah, 0Fh, 11h, 0Ah, 0Fh, 11h, ROL_JUMP
    dw offset Tune6Pattern_2114
Tune6Pattern_211D label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah, ROL_LENGTH + 24, 27h, ROL_TIE, 29h, ROL_TIE
Tune6Pattern_2126 label byte
    db 2Bh, ROL_TIE, ROL_TIE, ROL_TIE, ROL_JUMP
    dw offset Tune6Pattern_2126
Tune6Pattern_212D label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah, ROL_LENGTH + 24, 1Eh, ROL_TIE, 20h, ROL_TIE
Tune6Pattern_2136 label byte
    db 22h, ROL_TIE, ROL_TIE, ROL_TIE, ROL_JUMP
    dw offset Tune6Pattern_2136
Tune6Pattern_213D label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah, ROL_LENGTH + 24, 23h, ROL_TIE, 25h, ROL_TIE
Tune6Pattern_2146 label byte
    db 27h, ROL_TIE, ROL_TIE, ROL_TIE, ROL_JUMP
    dw offset Tune6Pattern_2146
Tune6Pattern_214D label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 63h, ROL_TRANSPOSE, 00h, ROL_LENGTH + 2, 33h, ROL_REST, 33h, 31h, ROL_REST
    db ROL_LENGTH + 12, 33h, ROL_LENGTH + 2, ROL_REST, 33h, ROL_REST, 33h, 31h, ROL_REST, ROL_LENGTH + 12, 33h, ROL_LENGTH + 2
    db ROL_REST, 35h, ROL_REST, 35h, 33h, ROL_REST, ROL_LENGTH + 12, 35h, ROL_LENGTH + 2, ROL_REST, 35h, ROL_REST
    db 35h, 33h, ROL_REST, ROL_LENGTH + 12, 35h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST
    db ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2
    db 3Ah, 37h, 35h, 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2
    db ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h
    db 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST
    db 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ROL_VELOCITY, 5Ah
    db 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h
    db 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ROL_REST, 37h
    db 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6
    db 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ROL_VELOCITY, 46h, 37h, ROL_REST, 37h, 35h
    db ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h
    db ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h
    db ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h
    db 35h, 33h, ROL_VELOCITY, 32h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2
    db ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h
    db 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST
    db 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ROL_VELOCITY, 1Eh
Tune6Pattern_223D label byte
    db 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h
    db 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ROL_JUMP
    dw offset Tune6Pattern_223D
Tune6Pattern_2255 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 3Bh, ROL_TRANSPOSE, 00h, ROL_LENGTH + 2, ROL_REST, 33h, ROL_REST, 33h, 31h
    db ROL_REST, ROL_LENGTH + 12, 33h, ROL_LENGTH + 2, ROL_REST, 33h, ROL_REST, 33h, 31h, ROL_REST, ROL_LENGTH + 12, 33h
    db ROL_LENGTH + 2, ROL_REST, 35h, ROL_REST, 35h, 33h, ROL_REST, ROL_LENGTH + 12, 35h, ROL_LENGTH + 2, ROL_REST, 35h
    db ROL_REST, 35h, 33h, ROL_REST, ROL_LENGTH + 12, 35h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h
    db ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h
    db ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h
    db ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h
    db 35h, 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h
    db ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ROL_VELOCITY
    db 28h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST
    db 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ROL_REST
    db 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST
    db ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ROL_VELOCITY, 1Eh, 37h, ROL_REST, 37h
    db 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6
    db 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12
    db 37h, ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah
    db 37h, 35h, 33h, ROL_VELOCITY, 14h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h
    db ROL_LENGTH + 2, ROL_REST, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h
    db 35h, 33h, 37h, ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 12, 37h, ROL_LENGTH + 2, ROL_REST, 37h
    db ROL_REST, 37h, 35h, ROL_REST, ROL_LENGTH + 6, 37h, ROL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ROL_VELOCITY
    db 0Ah, ROL_JUMP
    dw offset Tune6Pattern_223D
; Tune 7: 5 timer ticks per row, 8 channels, order list per channel.
Tune7 db 5, 8
    dw offset Tune7Order0, offset Tune7Order1, offset Tune7Order2, offset Tune7Order3
    dw offset Tune7Order4, offset Tune7Order5, offset Tune7Order6, offset Tune7Order7
Tune7Order0 label word
    dw offset Tune7Pattern_23FF
Tune7Order1 label word
    dw offset Tune7Pattern_242C
Tune7Order2 label word
    dw offset Tune7Pattern_2442
Tune7OrderLoop_2361 label word
    dw offset Tune7Pattern_2447
    dw offset Tune7Pattern_2447
    dw offset Tune7Pattern_24A8
    dw offset Tune7Pattern_2447
    dw offset Tune7Pattern_2447
    dw offset Tune7Pattern_24A8
    dw offset Tune10Pattern_34D2
    dw offset Tune7Pattern_24A8
    dw offset Tune10Pattern_34D5
    dw offset Tune7Pattern_24A8
    dw offset Tune10Pattern_34CF
    dw 0, offset Tune7OrderLoop_2361
Tune7Order3 label word
    dw offset Tune7Pattern_2509
Tune7OrderLoop_237D label word
    dw offset Tune7Pattern_250D
    dw offset Tune7Pattern_250D
    dw offset Tune7Pattern_2538
    dw offset Tune7Pattern_250D
    dw offset Tune7Pattern_250D
    dw offset Tune7Pattern_2538
    dw offset Tune10Pattern_34D2
    dw offset Tune7Pattern_2538
    dw offset Tune10Pattern_34D5
    dw offset Tune7Pattern_2538
    dw offset Tune10Pattern_34CF
    dw 0, offset Tune7OrderLoop_237D
Tune7Order4 label word
    dw offset Tune7Pattern_2542
Tune7OrderLoop_2399 label word
    dw offset Tune7Pattern_2546
    dw offset Tune7Pattern_2546
    dw offset Tune7Pattern_2571
    dw offset Tune7Pattern_2546
    dw offset Tune7Pattern_2546
    dw offset Tune7Pattern_2571
    dw offset Tune10Pattern_34D2
    dw offset Tune7Pattern_2571
    dw offset Tune10Pattern_34D5
    dw offset Tune7Pattern_2571
    dw offset Tune10Pattern_34CF
    dw 0, offset Tune7OrderLoop_2399
Tune7Order5 label word
    dw offset Tune7Pattern_257B
Tune7OrderLoop_23B5 label word
    dw offset Tune7Pattern_257F
    dw offset Tune7Pattern_257F
    dw offset Tune7Pattern_25AA
    dw offset Tune7Pattern_257F
    dw offset Tune7Pattern_257F
    dw offset Tune7Pattern_25AA
    dw offset Tune10Pattern_34D2
    dw offset Tune7Pattern_25AA
    dw offset Tune10Pattern_34D5
    dw offset Tune7Pattern_25AA
    dw offset Tune10Pattern_34CF
    dw 0, offset Tune7OrderLoop_23B5
Tune7Order6 label word
    dw offset RestPattern8
Tune7OrderLoop_23D1 label word
    dw offset Tune7Pattern_25B7
    dw offset Tune7Pattern_2641
    dw offset Tune7Pattern_2686
    dw offset Tune7Pattern_2641
    dw offset Tune10Pattern_34D2
    dw offset Tune7Pattern_2641
    dw offset Tune10Pattern_34D5
    dw offset Tune7Pattern_2641
    dw offset Tune10Pattern_34CF
    dw 0, offset Tune7OrderLoop_23D1
Tune7Order7 label word
    dw offset RestPattern8
Tune7OrderLoop_23E9 label word
    dw offset Tune7Pattern_26EC
    dw offset Tune7Pattern_2778
    dw offset Tune7Pattern_27BF
    dw offset Tune7Pattern_2778
    dw offset Tune10Pattern_34D2
    dw offset Tune7Pattern_2778
    dw offset Tune10Pattern_34D5
    dw offset Tune7Pattern_2778
    dw offset Tune10Pattern_34CF
    dw 0, offset Tune7OrderLoop_23E9
Tune7Pattern_23FF label byte
    db ROL_VELOCITY, 7Ch
Tune7Pattern_2401 label byte
    db ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, 0Eh, ROL_REST, ROL_REST, ROL_LENGTH + 6, 0Ch
    db 0Eh, ROL_LENGTH + 4, 0Ch, ROL_LENGTH + 2, 0Ch, 0Eh, ROL_REST, ROL_REST, ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 4
    db 0Ch, ROL_LENGTH + 2, 0Ch, 0Eh, ROL_REST, ROL_REST, ROL_LENGTH + 6, 0Ch, 0Eh, ROL_LENGTH + 2, 0Eh, 0Eh
    db 0Eh, 0Eh, 0Eh, 0Eh, ROL_JUMP
    dw offset Tune7Pattern_2401
Tune7Pattern_242C label byte
    db ROL_VELOCITY, 7Fh, ROL_LENGTH + 6
Tune7Pattern_242F label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, ROL_REST, ROL_JUMP
    dw offset Tune7Pattern_242F
Tune7Pattern_2442 label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 78h, ROL_LENGTH + 2
Tune7Pattern_2447 label byte
    db 12h, 12h, 12h, 12h, ROL_REST, 12h, 12h, 12h, 12h, 15h, ROL_REST, 15h
    db 12h, 12h, 12h, 12h, ROL_REST, 12h, 12h, 12h, 12h, 15h, ROL_REST, 15h
    db 10h, 10h, 10h, 10h, ROL_REST, 10h, 10h, 10h, 10h, 10h, ROL_REST, 10h
    db 0Eh, 0Eh, 0Eh, 0Eh, ROL_REST, 0Eh, 10h, 10h, 10h, 10h, ROL_REST, 10h
    db 12h, 12h, 12h, 12h, ROL_REST, 12h, 12h, 12h, 12h, 15h, ROL_REST, 15h
    db 12h, 12h, 12h, 12h, ROL_REST, 12h, 12h, 12h, 12h, 15h, ROL_REST, 15h
    db 10h, 10h, 10h, 10h, ROL_REST, 10h, 10h, 10h, 10h, 10h, ROL_REST, 10h
    db 0Eh, 0Eh, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ROL_REST, 0Eh
    db ROL_END_PATTERN
Tune7Pattern_24A8 label byte
    db 0Dh, 0Dh, 0Dh, 0Dh, ROL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ROL_REST, 10h
    db 0Dh, 0Dh, 0Dh, 0Dh, ROL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ROL_REST, 10h
    db 08h, 08h, 08h, 08h, ROL_REST, 08h, 08h, 08h, 08h, 0Bh, ROL_REST, 0Bh
    db 08h, 08h, 08h, 08h, ROL_REST, 08h, 08h, 08h, 08h, 08h, ROL_REST, 08h
    db 0Dh, 0Dh, 0Dh, 0Dh, ROL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ROL_REST, 10h
    db 0Dh, 0Dh, 0Dh, 0Dh, ROL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ROL_REST, 10h
    db 09h, 09h, 09h, 09h, ROL_REST, 09h, 09h, 09h, 09h, 09h, ROL_REST, 09h
    db 0Bh, 0Bh, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, ROL_REST, 0Bh
    db ROL_END_PATTERN
Tune7Pattern_2509 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 4Ch
Tune7Pattern_250D label byte
    db ROL_LENGTH + 15, 2Ah, ROL_LENGTH + 3, ROL_REST, 28h, ROL_REST, ROL_LENGTH + 15, 2Ah, ROL_LENGTH + 3, ROL_REST, 28h, ROL_REST
    db ROL_LENGTH + 24, 28h, ROL_LENGTH + 9, 26h, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 9, 28h, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 15, 2Ah
    db ROL_LENGTH + 3, ROL_REST, 28h, ROL_REST, ROL_LENGTH + 15, 2Ah, ROL_LENGTH + 3, ROL_REST, 28h, ROL_REST, ROL_LENGTH + 24, 28h
    db ROL_LENGTH + 9, 26h, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 12, 26h, ROL_END_PATTERN
Tune7Pattern_2538 label byte
    db ROL_LENGTH + 24, 25h, ROL_TIE, 20h, ROL_REST, 25h, ROL_TIE, ROL_TIE, 23h, ROL_END_PATTERN
Tune7Pattern_2542 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 4Ch
Tune7Pattern_2546 label byte
    db ROL_LENGTH + 15, 2Dh, ROL_LENGTH + 3, ROL_REST, 2Dh, ROL_REST, ROL_LENGTH + 15, 2Dh, ROL_LENGTH + 3, ROL_REST, 2Dh, ROL_REST
    db ROL_LENGTH + 24, 2Ch, ROL_LENGTH + 9, 2Bh, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 9, 2Ch, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 15, 2Dh
    db ROL_LENGTH + 3, ROL_REST, 2Dh, ROL_REST, ROL_LENGTH + 15, 2Dh, ROL_LENGTH + 3, ROL_REST, 2Dh, ROL_REST, ROL_LENGTH + 24, 2Ch
    db ROL_LENGTH + 9, 2Bh, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 12, 2Ah, ROL_END_PATTERN
Tune7Pattern_2571 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, 23h, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_END_PATTERN
Tune7Pattern_257B label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 4Ch
Tune7Pattern_257F label byte
    db ROL_LENGTH + 15, 31h, ROL_LENGTH + 3, ROL_REST, 31h, ROL_REST, ROL_LENGTH + 15, 31h, ROL_LENGTH + 3, ROL_REST, 31h, ROL_REST
    db ROL_LENGTH + 24, 2Fh, ROL_LENGTH + 9, 2Fh, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 9, 2Fh, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 15, 31h
    db ROL_LENGTH + 3, ROL_REST, 31h, ROL_REST, ROL_LENGTH + 15, 31h, ROL_LENGTH + 3, ROL_REST, 31h, ROL_REST, ROL_LENGTH + 24, 2Fh
    db ROL_LENGTH + 9, 2Fh, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 12, 2Dh, ROL_END_PATTERN
Tune7Pattern_25AA label byte
    db ROL_LENGTH + 24, 28h, ROL_TIE, ROL_REST, ROL_LENGTH + 12, 1Eh, 20h, ROL_LENGTH + 24, 28h, ROL_TIE, 21h, 27h
    db ROL_END_PATTERN
Tune7Pattern_25B7 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 78h, ROL_BEND_RANGE, 03h, ROL_EFFECT_PERIOD, 01h, ROL_PITCH_ENVELOPE
    dw 0001h
    dw 4004h
    db ROL_LENGTH + 24, 36h, ROL_TIE, ROL_LENGTH + 2, 39h, 38h, 36h, 39h, 38h, 36h, 38h, 36h
    db 34h, 38h, 36h, 34h, ROL_LENGTH + 24, 31h, ROL_LENGTH + 6, 38h, ROL_LENGTH + 4, 31h, ROL_LENGTH + 6, 38h
    db ROL_LENGTH + 2, 31h, ROL_LENGTH + 4, 38h, ROL_LENGTH + 22, 39h, ROL_LENGTH + 2, ROL_REST, 2Ah, 2Ch, 2Dh, 31h
    db 2Dh, 2Ch, 2Ah, 2Ch, 2Ah, 2Ch, 2Dh, 2Ch, 28h, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 10
    db ROL_REST, ROL_LENGTH + 2, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh
    db 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh
    db 2Fh, 31h, ROL_LENGTH + 16, 38h, ROL_LENGTH + 2, 36h, ROL_LENGTH + 4, 39h, ROL_LENGTH + 24, 3Bh, ROL_LENGTH + 2, ROL_REST
    db 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh
    db 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh
    db 42h, 45h, 44h, 42h, 40h, 42h, 40h, 3Dh, 40h, 3Dh, 3Bh, 39h
    db ROL_LENGTH + 18, 36h, ROL_LENGTH + 6, ROL_REST, ROL_END_PATTERN
Tune7Pattern_2641 label byte
    db ROL_PROGRAM, 56h, ROL_LENGTH + 2, 34h, 36h, 31h, 34h, 36h, 38h, 34h, 36h, 31h
    db 34h, 36h, 38h, 34h, 36h, 31h, 34h, 36h, 38h, 34h, 36h, 31h
    db 34h, 36h, 38h, ROL_LENGTH + 16, 38h, ROL_LENGTH + 8, 39h, ROL_LENGTH + 21, 38h, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 2
    db 34h, 36h, 31h, 34h, 36h, 38h, 34h, 36h, 31h, 34h, 36h, 38h
    db 34h, 36h, 31h, 34h, 36h, 38h, 34h, 36h, 31h, 34h, 36h, 38h
    db ROL_LENGTH + 16, 39h, ROL_LENGTH + 2, 38h, 39h, ROL_TIE, ROL_LENGTH + 26, 3Bh, ROL_END_PATTERN
Tune7Pattern_2686 label byte
    db ROL_PROGRAM, 2Ch, ROL_LENGTH + 9, 38h, ROL_LENGTH + 32, 31h, ROL_LENGTH + 5, ROL_REST, ROL_LENGTH + 2, 36h, ROL_LENGTH + 6, 39h
    db ROL_LENGTH + 3, 31h, ROL_LENGTH + 13, 34h, ROL_LENGTH + 2, 2Ch, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 6, 2Ah, 2Dh, ROL_LENGTH + 8
    db 2Ah, ROL_LENGTH + 6, 2Ch, ROL_LENGTH + 10, 2Dh, ROL_LENGTH + 2, 2Fh, ROL_LENGTH + 4, 31h, ROL_LENGTH + 26, 2Fh, ROL_LENGTH + 2
    db 34h, ROL_LENGTH + 14, 36h, ROL_LENGTH + 2, 38h, ROL_LENGTH + 4, 39h, ROL_LENGTH + 26, 36h, ROL_LENGTH + 6, 39h, 3Dh
    db ROL_LENGTH + 16, 45h, ROL_LENGTH + 2, 42h, ROL_LENGTH + 4, 45h, ROL_LENGTH + 6, 42h, ROL_LENGTH + 8, 3Dh, ROL_LENGTH + 4, 42h
    db ROL_LENGTH + 2, 3Dh, ROL_LENGTH + 16, 39h, ROL_LENGTH + 2, 38h, 39h, 38h, ROL_LENGTH + 18, 36h, ROL_LENGTH + 2, 34h
    db ROL_LENGTH + 4, 38h, ROL_LENGTH + 2, 39h, ROL_LENGTH + 4, 38h, ROL_LENGTH + 6, 34h, 36h, 31h, ROL_LENGTH + 20, 34h
    db ROL_LENGTH + 4, 2Ch, ROL_LENGTH + 6, 34h, ROL_LENGTH + 2, 2Ch, ROL_LENGTH + 6, 34h, ROL_LENGTH + 2, 2Ch, 34h, ROL_LENGTH + 6
    db 2Dh, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 6, ROL_REST, ROL_END_PATTERN
Tune7Pattern_26EC label byte
    db ROL_LENGTH + 2, ROL_REST, ROL_PROGRAM, 2Ch, ROL_VELOCITY, 50h, ROL_BEND_RANGE, 03h, ROL_EFFECT_PERIOD, 01h, ROL_PITCH_ENVELOPE
    dw 0001h
    dw 4004h
    db ROL_LENGTH + 24, 36h, ROL_TIE, ROL_LENGTH + 2, 39h, 38h, 36h, 39h, 38h, 36h, 38h, 36h
    db 34h, 38h, 36h, 34h, ROL_LENGTH + 24, 31h, ROL_LENGTH + 6, 38h, ROL_LENGTH + 4, 31h, ROL_LENGTH + 6, 38h
    db ROL_LENGTH + 2, 31h, ROL_LENGTH + 4, 38h, ROL_LENGTH + 22, 39h, ROL_LENGTH + 2, ROL_REST, 2Ah, 2Ch, 2Dh, 31h
    db 2Dh, 2Ch, 2Ah, 2Ch, 2Ah, 2Ch, 2Dh, 2Ch, 28h, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 10
    db ROL_REST, ROL_LENGTH + 2, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh
    db 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh
    db 2Fh, 31h, ROL_LENGTH + 16, 38h, ROL_LENGTH + 2, 36h, ROL_LENGTH + 4, 39h, ROL_LENGTH + 24, 3Bh, ROL_LENGTH + 2, ROL_REST
    db 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh
    db 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh
    db 42h, 45h, 44h, 42h, 40h, 42h, 40h, 3Dh, 40h, 3Dh, 3Bh, 39h
    db ROL_LENGTH + 18, 36h, ROL_LENGTH + 4, ROL_REST, ROL_END_PATTERN
Tune7Pattern_2778 label byte
    db ROL_LENGTH + 1, ROL_REST, ROL_PROGRAM, 56h, ROL_LENGTH + 2, 34h, 36h, 31h, 34h, 36h, 38h, 34h
    db 36h, 31h, 34h, 36h, 38h, 34h, 36h, 31h, 34h, 36h, 38h, 34h
    db 36h, 31h, 34h, 36h, 38h, ROL_LENGTH + 16, 38h, ROL_LENGTH + 8, 39h, ROL_LENGTH + 21, 38h, ROL_LENGTH + 3
    db ROL_REST, ROL_LENGTH + 2, 34h, 36h, 31h, 34h, 36h, 38h, 34h, 36h, 31h, 34h
    db 36h, 38h, 34h, 36h, 31h, 34h, 36h, 38h, 34h, 36h, 31h, 34h
    db 36h, 38h, ROL_LENGTH + 16, 39h, ROL_LENGTH + 2, 38h, 39h, ROL_TIE, ROL_LENGTH + 25, 3Bh, ROL_END_PATTERN
Tune7Pattern_27BF label byte
    db ROL_LENGTH + 2, ROL_REST, ROL_PROGRAM, 2Ch, ROL_LENGTH + 9, 38h, ROL_LENGTH + 32, 31h, ROL_LENGTH + 5, ROL_REST, ROL_LENGTH + 2, 36h
    db ROL_LENGTH + 6, 39h, ROL_LENGTH + 3, 31h, ROL_LENGTH + 13, 34h, ROL_LENGTH + 2, 2Ch, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 6, 2Ah
    db 2Dh, ROL_LENGTH + 8, 2Ah, ROL_LENGTH + 6, 2Ch, ROL_LENGTH + 10, 2Dh, ROL_LENGTH + 2, 2Fh, ROL_LENGTH + 4, 31h, ROL_LENGTH + 26
    db 2Fh, ROL_LENGTH + 2, 34h, ROL_LENGTH + 14, 36h, ROL_LENGTH + 2, 38h, ROL_LENGTH + 4, 39h, ROL_LENGTH + 26, 36h, ROL_LENGTH + 6
    db 39h, 3Dh, ROL_LENGTH + 16, 45h, ROL_LENGTH + 2, 42h, ROL_LENGTH + 4, 45h, ROL_LENGTH + 6, 42h, ROL_LENGTH + 8, 3Dh
    db ROL_LENGTH + 4, 42h, ROL_LENGTH + 2, 3Dh, ROL_LENGTH + 16, 39h, ROL_LENGTH + 2, 38h, 39h, 38h, ROL_LENGTH + 18, 36h
    db ROL_LENGTH + 2, 34h, ROL_LENGTH + 4, 38h, ROL_LENGTH + 2, 39h, ROL_LENGTH + 4, 38h, ROL_LENGTH + 6, 34h, 36h, 31h
    db ROL_LENGTH + 20, 34h, ROL_LENGTH + 4, 2Ch, ROL_LENGTH + 6, 34h, ROL_LENGTH + 2, 2Ch, ROL_LENGTH + 6, 34h, ROL_LENGTH + 2, 2Ch
    db 34h, ROL_LENGTH + 6, 2Dh, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 4, ROL_REST, ROL_END_PATTERN
; Tune 8: 4 timer ticks per row, 7 channels, order list per channel.
Tune8 db 4, 7
    dw offset Tune8Order0, offset Tune8Order1, offset Tune8Order2, offset Tune8Order3
    dw offset Tune8Order4, offset Tune8Order5, offset Tune8Order6
Tune8Order0 label word
    dw offset Tune8Pattern_2887
Tune8Order1 label word
    dw offset Tune8Pattern_2896
Tune8Order2 label word
    dw offset Tune8Pattern_28A0
    dw offset Tune8Pattern_28A0
Tune8OrderLoop_283F label word
    dw offset Tune8Pattern_28A0
    dw offset Tune8Pattern_28A0
    dw offset Tune8Pattern_2906
    dw offset Tune8Pattern_28A0
    dw 0, offset Tune8OrderLoop_283F
Tune8Order3 label word
    dw offset Tune8Pattern_2967
    dw offset Tune8Pattern_2967
Tune8OrderLoop_284F label word
    dw offset Tune8Pattern_2973
    dw offset Tune8Pattern_2973
    dw offset Tune8Pattern_2986
    dw offset Tune8Pattern_2973
    dw 0, offset Tune8OrderLoop_284F
Tune8Order4 label word
    dw offset Tune8Pattern_2999
    dw offset Tune8Pattern_2999
Tune8OrderLoop_285F label word
    dw offset Tune8Pattern_29A5
    dw offset Tune8Pattern_29A5
    dw offset Tune8Pattern_29BA
    dw offset Tune8Pattern_29A5
    dw 0, offset Tune8OrderLoop_285F
Tune8Order5 label word
    dw offset Tune8Pattern_29CD
    dw offset Tune8Pattern_29CD
Tune8OrderLoop_286F label word
    dw offset Tune8Pattern_29D9
    dw offset Tune8Pattern_29D9
    dw offset Tune8Pattern_29E7
    dw 0, offset Tune8OrderLoop_286F
Tune8Order6 label word
    dw offset Tune8Pattern_2A05
    dw offset Tune8Pattern_2A05
Tune8OrderLoop_287D label word
    dw offset Tune8Pattern_2A11
    dw offset Tune8Pattern_2A11
    dw offset Tune8Pattern_2A26
    dw 0, offset Tune8OrderLoop_287D
Tune8Pattern_2887 label byte
    db ROL_VELOCITY, 7Ch
Tune8Pattern_2889 label byte
    db ROL_LENGTH + 2, 0Ch, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_LENGTH + 10, ROL_REST, ROL_JUMP
    dw offset Tune8Pattern_2889
Tune8Pattern_2896 label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 6
Tune8Pattern_2899 label byte
    db 12h, 12h, 12h, 12h, ROL_JUMP
    dw offset Tune8Pattern_2899
Tune8Pattern_28A0 label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 78h, ROL_LENGTH + 2, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh
    db ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh
    db ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh
    db ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 0Eh
    db ROL_REST, 0Eh, ROL_REST, 0Eh, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h
    db ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h
    db ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h
    db ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h, ROL_REST, 11h
    db ROL_REST, 11h, ROL_REST, 11h, ROL_REST, ROL_END_PATTERN
Tune8Pattern_2906 label byte
    db 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST
    db 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST
    db 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST
    db 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST, 0Ch, ROL_REST
    db 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST
    db 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST
    db 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST
    db 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST, 0Fh, ROL_REST
    db ROL_END_PATTERN
Tune8Pattern_2967 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 6Ah, ROL_LENGTH + 32, 15h, ROL_TIE, ROL_TIE, 18h, ROL_TIE, ROL_TIE, ROL_END_PATTERN
Tune8Pattern_2973 label byte
    db ROL_LENGTH + 24, 15h, ROL_LENGTH + 12, 17h, 18h, 15h, ROL_TIE, 17h, 18h, ROL_LENGTH + 24, 15h, ROL_LENGTH + 12
    db 17h, 18h, 15h, ROL_TIE, 17h, 18h, ROL_END_PATTERN
Tune8Pattern_2986 label byte
    db ROL_LENGTH + 24, 13h, ROL_LENGTH + 12, 17h, 18h, 13h, ROL_TIE, 17h, 18h, ROL_LENGTH + 24, 13h, ROL_LENGTH + 12
    db 17h, 18h, 13h, ROL_TIE, 17h, 18h, ROL_END_PATTERN
Tune8Pattern_2999 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 6Ah, ROL_LENGTH + 32, 1Ah, ROL_TIE, ROL_TIE, 1Dh, ROL_TIE, ROL_TIE, ROL_END_PATTERN
Tune8Pattern_29A5 label byte
    db ROL_VELOCITY, 46h, ROL_LENGTH + 24, 21h, ROL_LENGTH + 12, 23h, 24h, 21h, ROL_TIE, 23h, 24h, ROL_LENGTH + 24
    db 21h, ROL_LENGTH + 12, 23h, 24h, 21h, ROL_TIE, 23h, 24h, ROL_END_PATTERN
Tune8Pattern_29BA label byte
    db ROL_LENGTH + 24, 1Fh, ROL_LENGTH + 12, 23h, 24h, 1Fh, ROL_TIE, 23h, 24h, ROL_LENGTH + 24, 1Fh, ROL_LENGTH + 12
    db 23h, 24h, 1Fh, ROL_TIE, 23h, 24h, ROL_END_PATTERN
Tune8Pattern_29CD label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 42h, ROL_LENGTH + 32, 21h, ROL_TIE, ROL_TIE, 24h, ROL_TIE, ROL_TIE, ROL_END_PATTERN
Tune8Pattern_29D9 label byte
    db ROL_PROGRAM, 56h, ROL_VELOCITY, 5Ah, ROL_LENGTH + 24, 3Ch, ROL_TIE, ROL_TIE, ROL_TIE, 3Ch, ROL_TIE, 39h
    db ROL_TIE, ROL_END_PATTERN
Tune8Pattern_29E7 label byte
    db ROL_LENGTH + 24, 37h, ROL_TIE, ROL_TIE, ROL_TIE, 3Ah, ROL_TIE, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST
    db ROL_REST, ROL_REST, ROL_LENGTH + 13, ROL_REST, ROL_LENGTH + 1, 40h, ROL_REST, 40h, ROL_LENGTH + 9, ROL_REST, ROL_LENGTH + 1, 40h
    db ROL_REST, 40h, ROL_LENGTH + 22, ROL_REST, ROL_REST, ROL_END_PATTERN
Tune8Pattern_2A05 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 42h, ROL_LENGTH + 32, 26h, ROL_TIE, ROL_TIE, 29h, ROL_TIE, ROL_TIE, ROL_END_PATTERN
Tune8Pattern_2A11 label byte
    db ROL_PROGRAM, 56h, ROL_VELOCITY, 5Ah, ROL_LENGTH + 18, 3Ah, 39h, ROL_TIE, ROL_TIE, ROL_TIE, ROL_LENGTH + 6, ROL_REST
    db ROL_LENGTH + 18, 3Ah, 39h, ROL_LENGTH + 12, 37h, ROL_LENGTH + 24, 35h, ROL_TIE, ROL_END_PATTERN
Tune8Pattern_2A26 label byte
    db ROL_LENGTH + 24, 34h, ROL_TIE, ROL_TIE, ROL_TIE, 33h, ROL_TIE, 3Ch, 3Fh, 3Eh, ROL_TIE, ROL_TIE
    db ROL_TIE, ROL_REST, ROL_LENGTH + 13, ROL_REST, ROL_LENGTH + 1, 45h, ROL_REST, 45h, ROL_LENGTH + 9, ROL_REST, ROL_LENGTH + 1, 45h
    db ROL_REST, 45h, ROL_LENGTH + 22, ROL_REST, ROL_REST, ROL_END_PATTERN
; Tune 9: 5 timer ticks per row, 8 channels, order list per channel.
Tune9 db 5, 8
    dw offset Tune9Order0, offset Tune9Order1, offset Tune9Order2, offset Tune9Order3
    dw offset Tune9Order4, offset Tune9Order5, offset Tune9Order6, offset Tune9Order7
Tune9Order0 label word
    dw offset Tune9Pattern_2AE0
    dw offset Tune9Pattern_2AE3
    dw offset Tune9Pattern_2B44
    dw offset Tune9Pattern_2C06
    dw offset Tune9Pattern_2B44
    dw 0, offset Tune9Order0
Tune9Order1 label word
    dw offset Tune9Pattern_2C68
    dw offset Tune9Pattern_2C6B
    dw offset Tune9Pattern_2C8C
    dw offset Tune9Pattern_2C8C
    dw offset Tune9Pattern_2C6B
    dw offset Tune9Pattern_2C8C
    dw offset Tune9Pattern_2C8C
    dw 0, offset Tune9Order1
Tune9Order2 label word
    dw offset Tune9Pattern_2CAD
    dw offset Tune9Pattern_2CB1
    dw offset Tune9Pattern_2D0B
    dw offset Tune9Pattern_2D0B
    dw offset Tune9Pattern_2D6D
    dw offset Tune9Pattern_2D6D
    dw offset Tune9Pattern_2D0B
    dw offset Tune9Pattern_2D0B
    dw 0, offset Tune9Order2
Tune9Order3 label word
    dw offset Tune9Pattern_2D9E
    dw offset Tune9Pattern_2DA2
    dw offset Tune9Pattern_2DAC
    dw offset Tune9Pattern_2DAC
    dw offset Tune9Pattern_2DB6
    dw offset Tune9Pattern_2DAC
    dw offset Tune9Pattern_2DAC
    dw 0, offset Tune9Order3
Tune9Order4 label word
    dw offset Tune9Pattern_2DC0
    dw offset Tune9Pattern_2DC4
    dw offset Tune9Pattern_2DCE
    dw offset Tune9Pattern_2DCE
    dw offset Tune9Pattern_2DD8
    dw offset Tune9Pattern_2DCE
    dw offset Tune9Pattern_2DCE
    dw 0, offset Tune9Order4
Tune9Order5 label word
    dw offset Tune9Pattern_2DE2
    dw offset Tune9Pattern_2DE6
    dw offset Tune9Pattern_2DF0
    dw offset Tune9Pattern_2DF0
    dw offset Tune9Pattern_2DFA
    dw offset Tune9Pattern_2DF0
    dw offset Tune9Pattern_2DF0
    dw 0, offset Tune9Order5
Tune9Order6 label word
    dw offset RestPattern8
    dw offset Tune9Pattern_2E04
    dw offset Tune9Pattern_2E21
    dw offset Tune9Pattern_2E8D
    dw offset Tune9Pattern_2E8D
    dw offset Tune9Pattern_2EAF
    dw 0, offset Tune9Order6
Tune9Order7 label word
    dw offset RestPattern8
    dw offset Tune9Pattern_2F27
    dw offset Tune9Pattern_2F46
    dw offset Tune9Pattern_2E8D
    dw offset Tune9Pattern_2E8D
    dw offset Tune9Pattern_2EAF
    dw 0, offset Tune9Order7
Tune9Pattern_2AE0 label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 2
Tune9Pattern_2AE3 label byte
    db 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST
    db 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, 0Eh, 0Eh
    db 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST
    db 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST
    db 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, 0Eh
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ROL_END_PATTERN
Tune9Pattern_2B44 label byte
    db ROL_LENGTH + 2, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Eh, 0Eh, 0Ch, 0Eh, 0Eh
    db ROL_REST, ROL_END_PATTERN
Tune9Pattern_2C06 label byte
    db ROL_LENGTH + 2, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, ROL_END_PATTERN
Tune9Pattern_2C68 label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 6
Tune9Pattern_2C6B label byte
    db 19h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 19h, 12h, 12h, 12h
    db 12h, 12h, 12h, 12h, 19h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 19h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, ROL_END_PATTERN
Tune9Pattern_2C8C label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, ROL_END_PATTERN
Tune9Pattern_2CAD label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 78h
Tune9Pattern_2CB1 label byte
    db ROL_LENGTH + 2, 09h, ROL_TIE, 09h, 09h, 09h, 09h, 09h, ROL_TIE, 09h, 09h, 09h
    db 09h, 09h, ROL_TIE, 09h, 09h, 09h, 09h, ROL_LENGTH + 4, 09h, 09h, 09h, 09h
    db ROL_LENGTH + 2, 09h, 09h, 09h, 09h, 09h, ROL_TIE, 09h, 09h, 09h, 09h, 09h
    db ROL_TIE, 09h, 09h, 09h, 09h, ROL_LENGTH + 4, 09h, 09h, 09h, 09h, ROL_LENGTH + 2, 09h
    db 09h, 09h, 09h, 09h, ROL_TIE, 09h, 09h, 09h, 09h, 09h, ROL_TIE, 09h
    db 09h, 09h, 09h, ROL_LENGTH + 4, 09h, 09h, 09h, 09h, ROL_LENGTH + 2, 09h, 09h, 09h
    db 09h, 09h, ROL_TIE, 09h, 09h, 09h, 09h, 09h, ROL_TIE, 09h, 09h, 09h
    db 09h, ROL_LENGTH + 4, 09h, 09h, 09h, ROL_END_PATTERN
Tune9Pattern_2D0B label byte
    db ROL_LENGTH + 2, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h
    db 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h
    db 0Eh, 09h, 0Dh, 09h, 0Eh, 09h, 10h, 09h, 0Dh, 09h, 0Eh, 09h
    db 10h, 09h, 0Dh, 09h, 0Eh, 09h, 10h, 09h, 0Dh, 09h, 0Eh, 09h
    db 10h, ROL_END_PATTERN
Tune9Pattern_2D6D label byte
    db 09h, ROL_TIE, 09h, 09h, 09h, 09h, 09h, ROL_TIE, 09h, 09h, 09h, 09h
    db 09h, ROL_TIE, 09h, 09h, 09h, 09h, 09h, ROL_TIE, 09h, 09h, 09h, 09h
    db 07h, ROL_TIE, 07h, 07h, 07h, 07h, 07h, ROL_TIE, 07h, 07h, 07h, 07h
    db 09h, ROL_TIE, 09h, 09h, 09h, 09h, 09h, ROL_TIE, 09h, 09h, 09h, 09h
    db ROL_END_PATTERN
Tune9Pattern_2D9E label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah
Tune9Pattern_2DA2 label byte
    db ROL_LENGTH + 24, 26h, ROL_TIE, 24h, ROL_TIE, 25h, ROL_TIE, 26h, 25h, ROL_END_PATTERN
Tune9Pattern_2DAC label byte
    db ROL_LENGTH + 24, 26h, ROL_TIE, 26h, ROL_TIE, 26h, ROL_TIE, 26h, 25h, ROL_END_PATTERN
Tune9Pattern_2DB6 label byte
    db ROL_LENGTH + 24, 26h, 26h, 26h, 28h, 26h, 26h, 26h, 28h, ROL_END_PATTERN
Tune9Pattern_2DC0 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah
Tune9Pattern_2DC4 label byte
    db ROL_LENGTH + 24, 23h, ROL_TIE, 1Fh, ROL_TIE, 21h, ROL_TIE, 21h, 21h, ROL_END_PATTERN
Tune9Pattern_2DCE label byte
    db ROL_LENGTH + 24, 23h, ROL_TIE, 23h, ROL_TIE, 21h, ROL_TIE, 21h, 21h, ROL_END_PATTERN
Tune9Pattern_2DD8 label byte
    db ROL_LENGTH + 24, 21h, 23h, 23h, 25h, 21h, 23h, 23h, 25h, ROL_END_PATTERN
Tune9Pattern_2DE2 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah
Tune9Pattern_2DE6 label byte
    db ROL_LENGTH + 24, 1Fh, ROL_TIE, 1Ch, ROL_TIE, 1Ch, ROL_TIE, 1Eh, 1Ch, ROL_END_PATTERN
Tune9Pattern_2DF0 label byte
    db ROL_LENGTH + 24, 1Fh, ROL_TIE, 1Fh, ROL_TIE, 1Eh, ROL_TIE, 1Ch, 1Ch, ROL_END_PATTERN
Tune9Pattern_2DFA label byte
    db ROL_LENGTH + 24, 1Eh, 1Eh, 1Fh, 21h, 1Eh, 1Eh, 1Fh, 21h, ROL_END_PATTERN
Tune9Pattern_2E04 label byte
    db ROL_PROGRAM, 56h, ROL_VELOCITY, 50h, ROL_LENGTH + 10, 26h, ROL_LENGTH + 8, 2Ah, ROL_LENGTH + 30, 21h, ROL_LENGTH + 10, 24h
    db ROL_LENGTH + 8, 28h, ROL_LENGTH + 30, 21h, ROL_LENGTH + 10, 32h, ROL_LENGTH + 8, 36h, ROL_LENGTH + 30, 2Dh, ROL_LENGTH + 10, 26h
    db ROL_LENGTH + 8, 28h, ROL_LENGTH + 30, 25h, ROL_END_PATTERN
Tune9Pattern_2E21 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 69h, ROL_LENGTH + 24, 32h, ROL_LENGTH + 2, 39h, 37h, 36h, 37h, 36h
    db 34h, 36h, 34h, 32h, 34h, 32h, 31h, ROL_LENGTH + 24, 2Dh, ROL_LENGTH + 12, 31h, 32h
    db ROL_LENGTH + 28, 36h, ROL_LENGTH + 2, 34h, ROL_LENGTH + 4, 36h, ROL_LENGTH + 12, 39h, ROL_LENGTH + 2, 37h, 31h, 32h
    db 31h, 2Dh, 31h, 32h, 31h, 2Dh, 31h, 32h, 31h, 2Dh, ROL_LENGTH + 21, 28h
    db ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 18, 34h, ROL_LENGTH + 4, 32h, ROL_LENGTH + 21, 2Dh, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 2, 2Fh
    db 31h, 34h, ROL_LENGTH + 17, 32h, ROL_LENGTH + 1, ROL_REST, ROL_LENGTH + 2, 2Fh, 2Dh, 2Fh, ROL_LENGTH + 17, 2Ah
    db ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 2, 25h, 26h, 28h, 2Ah, 2Bh, 2Ah, ROL_LENGTH + 10, 2Dh, ROL_LENGTH + 2
    db 31h, 32h, 34h, 32h, ROL_LENGTH + 18, 36h, ROL_LENGTH + 2, 32h, 34h, 2Dh, 32h, 34h
    db 2Dh, 32h, 34h, 2Dh, 32h, 34h, 2Dh, ROL_LENGTH + 21, 31h, ROL_LENGTH + 3, ROL_REST, ROL_END_PATTERN
Tune9Pattern_2E8D label byte
    db ROL_LENGTH + 2, 32h, 39h, 32h, 2Dh, 32h, 39h, 32h, 2Dh, 32h, 39h, 32h
    db 2Dh, ROL_LENGTH + 22, 36h, ROL_LENGTH + 2, ROL_REST, 32h, 39h, 32h, 2Dh, 32h, 39h, 32h
    db 2Dh, 32h, 39h, 32h, 36h, ROL_LENGTH + 22, 39h, ROL_LENGTH + 2, ROL_REST, ROL_END_PATTERN
Tune9Pattern_2EAF label byte
    db ROL_LENGTH + 18, 34h, ROL_LENGTH + 4, 32h, ROL_LENGTH + 6, 31h, 2Fh, 31h, ROL_LENGTH + 8, 32h, ROL_LENGTH + 6, 36h
    db ROL_LENGTH + 4, 34h, ROL_LENGTH + 6, 32h, 31h, ROL_LENGTH + 24, 2Dh, ROL_LENGTH + 2, 32h, 31h, 2Fh, ROL_LENGTH + 18
    db 2Dh, ROL_LENGTH + 2, 2Bh, 2Ah, 28h, ROL_LENGTH + 12, 26h, ROL_LENGTH + 2, 28h, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 2
    db 2Bh, ROL_LENGTH + 6, 2Dh, 2Fh, ROL_LENGTH + 4, 31h, 32h, 34h, ROL_LENGTH + 22, 31h, ROL_LENGTH + 2, 37h
    db 3Bh, 37h, 32h, 37h, 3Bh, 37h, ROL_LENGTH + 9, 32h, ROL_LENGTH + 1, ROL_REST, ROL_LENGTH + 2, 37h
    db 3Bh, 37h, 32h, 37h, 3Bh, 37h, ROL_LENGTH + 9, 32h, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 2, 3Bh
    db 39h, 37h, 36h, 34h, 32h, 37h, 36h, 34h, 32h, 34h, 32h, 31h
    db 2Fh, 31h, 2Fh, 2Dh, 2Fh, 2Bh, 2Ah, 28h, 2Bh, 2Ah, 28h, ROL_LENGTH + 16
    db 26h, ROL_LENGTH + 2, 36h, 32h, 2Dh, 32h, ROL_LENGTH + 16, 36h, ROL_LENGTH + 2, 32h, 2Dh, ROL_LENGTH + 4
    db 32h, ROL_LENGTH + 10, 34h, ROL_LENGTH + 8, 32h, ROL_LENGTH + 6, 31h, ROL_LENGTH + 22, 2Dh, ROL_LENGTH + 2, ROL_REST, ROL_END_PATTERN
Tune9Pattern_2F27 label byte
    db ROL_PROGRAM, 56h, ROL_VELOCITY, 3Ch, ROL_LENGTH + 2, ROL_REST, ROL_LENGTH + 10, 26h, ROL_LENGTH + 8, 2Ah, ROL_LENGTH + 30, 21h
    db ROL_LENGTH + 10, 24h, ROL_LENGTH + 8, 28h, ROL_LENGTH + 30, 21h, ROL_LENGTH + 10, 32h, ROL_LENGTH + 8, 36h, ROL_LENGTH + 30, 2Dh
    db ROL_LENGTH + 10, 26h, ROL_LENGTH + 8, 28h, ROL_LENGTH + 28, 25h, ROL_END_PATTERN
Tune9Pattern_2F46 label byte
    db ROL_VELOCITY, 6Eh, ROL_LENGTH + 24, 32h, ROL_LENGTH + 2, 39h, 37h, 36h, 37h, 36h, 34h, 36h
    db 34h, 32h, 34h, 32h, 31h, ROL_LENGTH + 24, 2Dh, ROL_LENGTH + 12, 31h, 32h, ROL_LENGTH + 28, 36h
    db ROL_LENGTH + 2, 34h, ROL_LENGTH + 4, 36h, ROL_LENGTH + 12, 39h, ROL_LENGTH + 2, 37h, 31h, 32h, 31h, 2Dh
    db 31h, 32h, 31h, 2Dh, 31h, 32h, 31h, 2Dh, ROL_LENGTH + 21, 28h, ROL_LENGTH + 3, ROL_REST
    db ROL_LENGTH + 18, 34h, ROL_LENGTH + 4, 32h, ROL_LENGTH + 21, 2Dh, ROL_LENGTH + 3, ROL_REST, ROL_LENGTH + 2, 2Fh, 31h, 34h
    db ROL_LENGTH + 17, 32h, ROL_LENGTH + 1, ROL_REST, ROL_LENGTH + 2, 2Fh, 2Dh, 2Fh, ROL_LENGTH + 17, 2Ah, ROL_LENGTH + 3, ROL_REST
    db ROL_LENGTH + 2, 25h, 26h, 28h, 2Ah, 2Bh, 2Ah, ROL_LENGTH + 10, 2Dh, ROL_LENGTH + 2, 31h, 32h
    db 34h, 32h, ROL_LENGTH + 18, 36h, ROL_LENGTH + 2, 32h, 34h, 2Dh, 32h, 34h, 2Dh, 32h
    db 34h, 2Dh, 32h, 34h, 2Dh, ROL_LENGTH + 21, 31h, ROL_LENGTH + 3, ROL_REST, ROL_END_PATTERN
; Tune 10: 4 timer ticks per row, 8 channels, order list per channel.
Tune10 db 4, 8
    dw offset Tune10Order0, offset Tune10Order1, offset Tune10Order2, offset Tune10Order3
    dw offset Tune10Order4, offset Tune10Order5, offset Tune10Order6, offset Tune10Order7
Tune10Order0 label word
    dw offset Tune10Pattern_3080
    dw offset Tune10Pattern_3080
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw offset Tune10Pattern_30A7
    dw 0, offset Tune10Order0
Tune10Order1 label word
    dw offset Tune10Pattern_30D9
    dw offset Tune10Pattern_30D9
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw offset Tune10Pattern_30E5
    dw 0, offset Tune10Order1
Tune10Order2 label word
    dw offset Tune10Pattern_30F7
    dw offset Tune10Pattern_30FB
    dw offset Tune10Pattern_3101
    dw offset Tune10Pattern_3101
    dw offset Tune10Pattern_3163
    dw offset Tune10Pattern_3101
    dw offset Tune10Pattern_3101
    dw offset Tune10Pattern_3163
    dw 0, offset Tune10Order2
Tune10Order3 label word
    dw offset Tune10Pattern_3225
    dw offset Tune10Pattern_3229
    dw offset Tune10Pattern_322F
    dw offset Tune10Pattern_322F
    dw offset Tune10Pattern_3239
    dw offset Tune10Pattern_322F
    dw offset Tune10Pattern_322F
    dw offset Tune10Pattern_3239
    dw 0, offset Tune10Order3
Tune10Order4 label word
    dw offset Tune10Pattern_324B
    dw offset Tune10Pattern_324F
    dw offset Tune10Pattern_3255
    dw offset Tune10Pattern_3255
    dw offset Tune10Pattern_325F
    dw offset Tune10Pattern_3255
    dw offset Tune10Pattern_3255
    dw offset Tune10Pattern_325F
    dw 0, offset Tune10Order4
Tune10Order5 label word
    dw offset Tune10Pattern_3271
    dw offset Tune10Pattern_3275
    dw offset Tune10Pattern_327B
    dw offset Tune10Pattern_327B
    dw offset Tune10Pattern_3285
    dw offset Tune10Pattern_327B
    dw offset Tune10Pattern_327B
    dw offset Tune10Pattern_3285
    dw 0, offset Tune10Order5
Tune10Order6 label word
    dw offset Tune10Pattern_3297
    dw offset Tune10Pattern_32A5
    dw offset Tune10Pattern_330E
    dw offset Tune10Pattern_3359
    dw offset Tune10Pattern_330E
    dw 0, offset Tune10Order6
Tune10Order7 label word
    dw offset RestPattern4
    dw offset Tune10Pattern_33B2
    dw offset Tune10Pattern_33BD
    dw offset Tune10Pattern_3428
    dw offset Tune10Pattern_3475
    dw offset Tune10Pattern_3428
    dw 0, offset Tune10Order7
Tune10Pattern_3080 label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 12, 0Ch, ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ROL_REST, ROL_LENGTH + 12
    db 0Ch, ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, ROL_REST, ROL_REST, ROL_LENGTH + 6, 0Ch, 0Ch, 0Ch
    db 0Ch, ROL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, ROL_END_PATTERN
Tune10Pattern_30A7 label byte
    db ROL_LENGTH + 2, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST
    db ROL_REST, 0Ch, ROL_REST, 0Ch, 0Eh, ROL_REST, ROL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, ROL_END_PATTERN
Tune10Pattern_30D9 label byte
    db ROL_VELOCITY, 78h, ROL_LENGTH + 12, 19h, ROL_REST, 19h, ROL_REST, 19h, ROL_REST, ROL_REST, ROL_REST, ROL_END_PATTERN
Tune10Pattern_30E5 label byte
    db ROL_LENGTH + 6, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, 12h, 12h, ROL_END_PATTERN
Tune10Pattern_30F7 label byte
    db ROL_PROGRAM, 1Ch, ROL_VELOCITY, 6Eh
Tune10Pattern_30FB label byte
    db ROL_LENGTH + 24, 13h, 10h, 0Bh, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3101 label byte
    db ROL_LENGTH + 2, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST
    db 0Eh, 10h, ROL_REST, 10h, 10h, ROL_REST, 10h, 10h, ROL_REST, 10h, 10h, ROL_REST
    db 10h, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, ROL_END_PATTERN
Tune10Pattern_3163 label byte
    db ROL_LENGTH + 2, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 10h, ROL_REST, 10h, 10h, ROL_REST, 10h, 10h, ROL_REST, 10h, 10h, ROL_REST
    db 10h, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST, 0Bh, 0Bh, ROL_REST
    db 0Bh, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST, 13h, 13h, ROL_REST
    db 13h, 10h, ROL_REST, 10h, 10h, ROL_REST, 10h, 10h, ROL_REST, 10h, 10h, ROL_REST
    db 10h, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST
    db 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST, 0Eh, 0Eh, ROL_REST
    db 0Eh, ROL_END_PATTERN
Tune10Pattern_3225 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah
Tune10Pattern_3229 label byte
    db ROL_LENGTH + 24, 2Bh, 28h, 2Ah, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_322F label byte
    db ROL_LENGTH + 24, 1Eh, ROL_TIE, ROL_TIE, ROL_TIE, 21h, 23h, 1Eh, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3239 label byte
    db ROL_LENGTH + 24, 2Bh, ROL_TIE, 2Ah, ROL_TIE, 2Bh, ROL_TIE, 2Ah, ROL_TIE, 2Bh, 2Bh, 2Ah
    db ROL_TIE, 2Bh, 2Bh, 2Ah, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_324B label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah
Tune10Pattern_324F label byte
    db ROL_LENGTH + 24, 26h, 25h, 26h, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3255 label byte
    db ROL_LENGTH + 24, 1Ah, ROL_TIE, ROL_TIE, ROL_TIE, 1Eh, 20h, 1Ah, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_325F label byte
    db ROL_LENGTH + 24, 26h, ROL_TIE, 26h, ROL_TIE, 26h, ROL_TIE, 26h, ROL_TIE, 26h, 28h, 26h
    db ROL_TIE, 26h, 28h, 26h, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3271 label byte
    db ROL_PROGRAM, 58h, ROL_VELOCITY, 5Ah
Tune10Pattern_3275 label byte
    db ROL_LENGTH + 24, 23h, 21h, 23h, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_327B label byte
    db ROL_LENGTH + 24, 17h, ROL_TIE, ROL_TIE, ROL_TIE, 1Ah, 1Ch, 17h, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3285 label byte
    db ROL_LENGTH + 24, 23h, ROL_TIE, 23h, ROL_TIE, 23h, ROL_TIE, 23h, ROL_TIE, 23h, 23h, 23h
    db ROL_TIE, 23h, 23h, 21h, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3297 label byte
    db ROL_PROGRAM, 2Ch, ROL_VELOCITY, 7Fh, ROL_LENGTH + 24, 3Eh, 3Dh, 3Bh, ROL_TIE, 32h, 31h, 2Fh
    db ROL_TIE, ROL_END_PATTERN
Tune10Pattern_32A5 label byte
    db ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 28h, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 2, 2Ah
    db ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 14, 2Fh, ROL_LENGTH + 10, 32h, ROL_LENGTH + 8, 31h, ROL_LENGTH + 6, 2Fh, ROL_LENGTH + 2, 31h
    db 2Fh, 2Dh, 31h, ROL_TIE, 2Dh, 31h, 2Fh, ROL_LENGTH + 8, 2Dh, ROL_LENGTH + 24, 2Ah, ROL_LENGTH + 10
    db 2Ah, ROL_LENGTH + 8, 28h, ROL_LENGTH + 6, 26h, ROL_LENGTH + 10, 28h, ROL_LENGTH + 18, 26h, ROL_TIE, ROL_LENGTH + 2, ROL_REST
    db ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 28h, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 2, 2Dh, 2Bh, 2Ah
    db 28h, 26h, 25h, ROL_LENGTH + 6, 23h, ROL_LENGTH + 2, 25h, 23h, 21h, ROL_LENGTH + 24, 1Eh, ROL_LENGTH + 9
    db 25h, 26h, ROL_LENGTH + 6, 23h, ROL_LENGTH + 2, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, ROL_LENGTH + 24, 2Ah, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_330E label byte
    db ROL_LENGTH + 30, 2Dh, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 6, 2Ah, 2Bh, ROL_LENGTH + 20, 2Ah, ROL_LENGTH + 4, 28h, ROL_LENGTH + 26
    db 26h, ROL_LENGTH + 24, 2Dh, ROL_LENGTH + 2, 32h, 31h, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 2Dh
    db ROL_LENGTH + 6, 2Bh, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 23, 2Ah, ROL_TIE, ROL_LENGTH + 2, 2Bh, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 18
    db 2Fh, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 2Fh, ROL_LENGTH + 18, 32h, ROL_LENGTH + 2, 31h, ROL_LENGTH + 6, 32h, ROL_LENGTH + 4
    db 31h, ROL_LENGTH + 19, 2Fh, ROL_TIE, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 2, 2Bh, ROL_LENGTH + 6, 2Dh, ROL_LENGTH + 4, 2Fh
    db ROL_LENGTH + 6, 31h, ROL_LENGTH + 2, ROL_REST, ROL_LENGTH + 6, 32h, ROL_LENGTH + 4, 34h, ROL_LENGTH + 6, 36h, 37h, ROL_LENGTH + 25
    db 36h, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3359 label byte
    db ROL_LENGTH + 2, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h
    db 28h, ROL_LENGTH + 22, 2Ah, ROL_LENGTH + 2, ROL_REST, 25h, 26h, 25h, 26h, 25h, 26h, 25h
    db 26h, 25h, 26h, 25h, 26h, ROL_LENGTH + 24, 23h, ROL_LENGTH + 10, 28h, ROL_LENGTH + 8, 2Bh, ROL_LENGTH + 6
    db 2Ah, ROL_LENGTH + 10, 28h, ROL_LENGTH + 8, 26h, ROL_LENGTH + 6, 25h, ROL_LENGTH + 24, 23h, ROL_TIE, ROL_LENGTH + 10, 28h
    db ROL_LENGTH + 8, 2Dh, ROL_LENGTH + 10, 28h, ROL_LENGTH + 8, 2Dh, ROL_LENGTH + 6, 28h, 2Bh, ROL_LENGTH + 10, 2Ah, ROL_LENGTH + 8
    db 28h, ROL_LENGTH + 6, 2Bh, ROL_LENGTH + 24, 2Ah, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 6, 2Bh, ROL_LENGTH + 12, 2Ah, ROL_LENGTH + 2
    db 2Bh, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 6, 28h, ROL_LENGTH + 12, 26h, ROL_LENGTH + 2, 26h, 28h, 26h, 25h
    db ROL_LENGTH + 18, 23h, ROL_LENGTH + 24, 2Ah, ROL_END_PATTERN
Tune10Pattern_33B2 label byte
    db ROL_PROGRAM, 56h, ROL_VELOCITY, 6Eh, 26h, 28h, 2Ah, ROL_TIE, ROL_VELOCITY, 5Ah, ROL_END_PATTERN
Tune10Pattern_33BD label byte
    db ROL_LENGTH + 2, ROL_REST, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 28h, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 4, 2Dh
    db ROL_LENGTH + 2, 2Ah, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 14, 2Fh, ROL_LENGTH + 10, 32h, ROL_LENGTH + 8, 31h, ROL_LENGTH + 6, 2Fh
    db ROL_LENGTH + 2, 31h, 2Fh, 2Dh, 31h, ROL_TIE, 2Dh, 31h, 2Fh, ROL_LENGTH + 8, 2Dh, ROL_LENGTH + 24
    db 2Ah, ROL_LENGTH + 10, 2Ah, ROL_LENGTH + 8, 28h, ROL_LENGTH + 6, 26h, ROL_LENGTH + 10, 28h, ROL_LENGTH + 18, 26h, ROL_TIE
    db ROL_LENGTH + 2, ROL_REST, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 28h, ROL_LENGTH + 14, 2Ah, ROL_LENGTH + 2, 2Dh
    db 2Bh, 2Ah, 28h, 26h, 25h, ROL_LENGTH + 6, 23h, ROL_LENGTH + 2, 25h, 23h, 21h, ROL_LENGTH + 24
    db 1Eh, ROL_LENGTH + 9, 25h, 26h, ROL_LENGTH + 6, 23h, ROL_LENGTH + 2, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, 28h, 26h, ROL_LENGTH + 23, 2Ah, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3428 label byte
    db ROL_LENGTH + 2, ROL_REST, ROL_LENGTH + 30, 2Dh, ROL_LENGTH + 4, 2Bh, ROL_LENGTH + 6, 2Ah, 2Bh, ROL_LENGTH + 20, 2Ah, ROL_LENGTH + 4
    db 28h, ROL_LENGTH + 26, 26h, ROL_LENGTH + 24, 2Dh, ROL_LENGTH + 2, 32h, 31h, 2Fh, 31h, 2Fh, 2Dh
    db 2Fh, 2Dh, ROL_LENGTH + 6, 2Bh, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 23, 2Ah, ROL_TIE, ROL_LENGTH + 2, 2Bh, ROL_LENGTH + 4
    db 2Dh, ROL_LENGTH + 18, 2Fh, ROL_LENGTH + 2, 2Dh, ROL_LENGTH + 4, 2Fh, ROL_LENGTH + 18, 32h, ROL_LENGTH + 2, 31h, ROL_LENGTH + 6
    db 32h, ROL_LENGTH + 4, 31h, ROL_LENGTH + 19, 2Fh, ROL_TIE, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 2, 2Bh, ROL_LENGTH + 6, 2Dh
    db ROL_LENGTH + 4, 2Fh, ROL_LENGTH + 6, 31h, ROL_LENGTH + 2, ROL_REST, ROL_LENGTH + 6, 32h, ROL_LENGTH + 4, 34h, ROL_LENGTH + 6, 36h
    db 37h, ROL_LENGTH + 24, 36h, ROL_TIE, ROL_END_PATTERN
Tune10Pattern_3475 label byte
    db ROL_LENGTH + 2, ROL_REST, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, ROL_LENGTH + 22, 2Ah, ROL_LENGTH + 2, ROL_REST, 25h, 26h, 25h, 26h, 25h, 26h
    db 25h, 26h, 25h, 26h, 25h, 26h, ROL_LENGTH + 24, 23h, ROL_LENGTH + 10, 28h, ROL_LENGTH + 8, 2Bh
    db ROL_LENGTH + 6, 2Ah, ROL_LENGTH + 10, 28h, ROL_LENGTH + 8, 26h, ROL_LENGTH + 6, 25h, ROL_LENGTH + 24, 23h, ROL_TIE, ROL_LENGTH + 10
    db 28h, ROL_LENGTH + 8, 2Dh, ROL_LENGTH + 10, 28h, ROL_LENGTH + 8, 2Dh, ROL_LENGTH + 6, 28h, 2Bh, ROL_LENGTH + 10, 2Ah
    db ROL_LENGTH + 8, 28h, ROL_LENGTH + 6, 2Bh, ROL_LENGTH + 24, 2Ah, ROL_LENGTH + 4, 2Dh, ROL_LENGTH + 6, 2Bh, ROL_LENGTH + 12, 2Ah
    db ROL_LENGTH + 2, 2Bh, ROL_LENGTH + 4, 2Ah, ROL_LENGTH + 6, 28h, ROL_LENGTH + 12, 26h, ROL_LENGTH + 2, 26h, 28h, 26h
    db 25h, ROL_LENGTH + 18, 23h, ROL_LENGTH + 22, 2Ah, ROL_END_PATTERN
Tune10Pattern_34CF label byte
    db ROL_TRANSPOSE, 00h, ROL_END_PATTERN
Tune10Pattern_34D2 label byte
    db ROL_TRANSPOSE, 02h, ROL_END_PATTERN
Tune10Pattern_34D5 label byte
    db ROL_TRANSPOSE, 03h, ROL_END_PATTERN
RestPattern4 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_END_PATTERN
; Unreferenced: a self-looping order list of RestPattern8.
UnusedRestOrderList label word
    dw offset RestPattern8
    dw 0, offset UnusedRestOrderList
RestPattern8 label byte
    db ROL_LENGTH + 24, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_REST, ROL_END_PATTERN
; MT-32 setup sent at init: each block is the body of a Roland DT1 sysex message
; (the code prefixes F0 41 10 16 12): address, data, checksum, F7. Reset, five patch
; entries (patches 28, 43, 44, 86, 88 -> memory timbres 0..4), then the five timbres.
SysexTable dw offset SysexResetAll, offset SysexPatch88, offset SysexPatch86, offset SysexPatch44, offset SysexPatch43, offset SysexPatch28
    dw offset SysexTimbre0, offset SysexTimbre1, offset SysexTimbre2, offset SysexTimbre3, offset SysexTimbre4, 0
SysexResetAll db 7Fh,00h,00h,01h,00h,0F7h
SysexPatch88 db 05h,05h,40h,02h,04h,18h,32h,0Ch,00h,01h,59h,0F7h
SysexPatch86 db 05h,05h,30h,02h,03h,18h,32h,0Ch,00h,01h,6Ah,0F7h
SysexPatch44 db 05h,02h,60h,02h,02h,18h,32h,0Ch,00h,01h,3Eh,0F7h
SysexPatch43 db 05h,02h,58h,02h,01h,18h,32h,0Ch,00h,01h,47h,0F7h
SysexPatch28 db 05h,01h,60h,02h,00h,18h,32h,0Ch,00h,01h,41h,0F7h
SysexTimbre4 db 08h,08h,00h,64h,69h,73h,74h,67h,75h,69h,74h,61h,72h,00h,00h,03h
    db 00h,24h,32h,10h,01h,00h,2Bh,4Fh,0Eh,07h,01h,00h,00h,00h,00h,00h
    db 32h,32h,32h,32h,32h,3Eh,09h,2Ch,63h,1Ch,03h,00h,07h,19h,00h,00h
    db 00h,00h,2Ch,2Eh,48h,00h,25h,0Bh,25h,00h,47h,46h,6Eh,03h,2Eh,0Ch
    db 00h,00h,04h,20h,54h,34h,3Ah,4Ah,64h,3Dh,00h,30h,32h,10h,01h,00h
    db 26h,36h,0Eh,00h,00h,00h,0Dh,10h,1Ch,00h,5Eh,4Bh,3Ch,32h,32h,39h
    db 00h,00h,5Eh,1Bh,03h,00h,07h,2Dh,00h,00h,00h,3Ch,38h,58h,64h,00h
    db 3Ah,24h,3Dh,02h,4Ah,46h,6Eh,07h,1Bh,0Ch,00h,00h,04h,1Fh,4Eh,46h
    db 3Ah,4Ah,64h,40h,00h,2Dh,32h,10h,01h,00h,00h,43h,0Eh,00h,00h,00h
    db 00h,00h,00h,00h,32h,32h,32h,32h,32h,00h,00h,00h,64h,15h,03h,00h
    db 07h,48h,00h,00h,00h,04h,64h,64h,5Eh,00h,55h,2Ah,53h,40h,39h,32h
    db 00h,00h,00h,00h,00h,00h,04h,20h,63h,5Ch,3Ah,4Ah,64h,44h,24h,27h
    db 0F7h
SysexTimbre3 db 08h,06h,00h,57h,61h,72h,6Dh,20h,50h,61h,64h,20h,20h,00h,07h,0Fh
    db 00h,24h,2Dh,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h
    db 32h,32h,32h,32h,32h,40h,1Ah,31h,64h,10h,06h,00h,07h,64h,00h,00h
    db 00h,00h,24h,00h,00h,64h,35h,27h,27h,27h,5Ah,55h,5Bh,0Ch,1Bh,0Ch
    db 00h,00h,10h,42h,64h,00h,51h,60h,62h,00h,00h,24h,37h,0Bh,01h,01h
    db 00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,32h,32h,32h,32h,32h,3Eh
    db 1Dh,23h,64h,10h,06h,00h,07h,64h,00h,00h,00h,00h,24h,00h,00h,64h
    db 35h,27h,27h,27h,5Ah,54h,5Bh,0Ch,1Bh,0Ch,00h,00h,10h,42h,64h,00h
    db 51h,60h,62h,00h,00h,24h,28h,0Bh,01h,01h,00h,00h,07h,00h,00h,00h
    db 00h,00h,00h,00h,32h,32h,32h,32h,32h,40h,1Ah,31h,64h,10h,06h,00h
    db 07h,64h,00h,00h,00h,00h,24h,00h,00h,64h,35h,27h,27h,27h,5Ah,55h
    db 5Bh,0Ch,1Bh,0Ch,00h,00h,10h,42h,64h,00h,51h,60h,62h,00h,00h,24h
    db 3Ch,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,32h,32h
    db 32h,32h,32h,3Eh,1Dh,23h,64h,10h,06h,00h,07h,64h,00h,00h,00h,00h
    db 24h,00h,00h,64h,35h,27h,27h,27h,5Ah,54h,5Bh,0Ch,1Bh,0Ch,00h,00h
    db 10h,42h,64h,00h,51h,61h,62h,00h,00h,3Bh,0F7h
SysexTimbre2 db 08h,04h,00h,50h,6Fh,6Ch,79h,20h,53h,79h,6Eh,74h,68h,07h,00h,07h
    db 00h,24h,36h,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h
    db 32h,32h,32h,32h,32h,42h,04h,64h,64h,10h,06h,00h,07h,64h,00h,00h
    db 00h,00h,24h,00h,00h,1Eh,64h,27h,27h,27h,55h,4Ah,5Bh,0Ch,1Bh,0Ch
    db 02h,00h,00h,64h,00h,00h,02h,64h,00h,00h,00h,24h,2Eh,0Bh,01h,01h
    db 00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,32h,32h,32h,32h,32h,40h
    db 06h,64h,64h,10h,06h,00h,07h,64h,00h,00h,00h,00h,24h,00h,00h,1Eh
    db 64h,27h,27h,27h,55h,4Ah,5Bh,0Ch,1Bh,0Ch,02h,00h,00h,64h,00h,00h
    db 02h,64h,00h,00h,00h,24h,32h,0Bh,01h,01h,00h,00h,07h,00h,00h,00h
    db 00h,00h,00h,00h,32h,32h,32h,32h,32h,44h,00h,64h,64h,10h,06h,00h
    db 07h,64h,64h,00h,00h,00h,24h,00h,00h,1Eh,64h,27h,27h,27h,5Bh,4Ah
    db 5Bh,0Ch,1Bh,0Ch,02h,00h,00h,64h,00h,00h,02h,64h,00h,00h,00h,24h
    db 32h,0Bh,00h,00h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,32h,32h
    db 32h,32h,32h,00h,00h,00h,00h,00h,0Bh,00h,07h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,32h,5Bh,0Ch,1Bh,0Ch,00h,5Bh
    db 0F7h
SysexTimbre1 db 08h,02h,00h,72h,65h,73h,6Fh,6Eh,61h,6Eh,63h,65h,20h,07h,00h,03h
    db 01h,24h,32h,10h,01h,00h,00h,3Fh,07h,00h,00h,00h,00h,00h,00h,00h
    db 32h,32h,32h,32h,32h,3Dh,14h,36h,64h,1Eh,07h,6Bh,07h,64h,1Eh,00h
    db 00h,40h,5Eh,4Ah,5Ah,00h,31h,40h,44h,29h,5Fh,56h,5Bh,0Ch,1Bh,0Ch
    db 02h,04h,18h,18h,14h,32h,53h,3Fh,5Eh,61h,30h,24h,32h,10h,01h,00h
    db 00h,45h,07h,00h,00h,00h,00h,00h,00h,00h,32h,32h,32h,32h,32h,42h
    db 17h,36h,64h,1Ch,07h,6Bh,07h,64h,1Eh,00h,00h,40h,48h,5Eh,5Eh,00h
    db 31h,64h,51h,2Dh,5Fh,56h,5Bh,0Ch,1Bh,0Ch,02h,04h,14h,1Ch,22h,2Eh
    db 56h,3Bh,64h,58h,24h,3Ah,0F7h
SysexTimbre0 db 08h,00h,00h,46h,4Dh,20h,42h,61h,73h,73h,20h,20h,20h,07h,00h,03h
    db 00h,24h,32h,0Fh,01h,01h,00h,00h,07h,02h,00h,00h,00h,00h,00h,00h
    db 32h,32h,32h,32h,32h,40h,00h,23h,35h,1Ah,08h,00h,07h,3Dh,64h,00h
    db 03h,00h,21h,4Dh,64h,0Ch,59h,4Bh,33h,00h,62h,4Eh,5Bh,0Ch,1Bh,0Ch
    db 00h,00h,00h,0Bh,00h,4Fh,0Bh,5Ch,64h,64h,00h,24h,32h,0Fh,01h,01h
    db 00h,24h,07h,00h,00h,00h,00h,00h,00h,00h,32h,32h,32h,32h,32h,3Eh
    db 00h,31h,35h,0Ah,08h,00h,07h,4Ah,64h,00h,03h,00h,00h,20h,64h,0Ch
    db 64h,4Bh,23h,00h,64h,4Eh,5Bh,0Ch,1Bh,0Ch,00h,00h,00h,0Bh,00h,4Fh
    db 0Bh,5Ch,64h,64h,62h,0F7h
driver ends
end
