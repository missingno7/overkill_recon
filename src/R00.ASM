; Modern physical chunk, NOT an inferred original object boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn FileBufferOffset:far
extrn FileBufferSegment:far
extrn FileByteCount:far
extrn FileHandle:far
extrn FileNamePtr:far
extrn FileStatus:far
extrn InputBits:far
extrn InputDeviceMode:far
extrn JoyButtonSelect:far
extrn JoyCalAbortSp:far
extrn JoyCalCenterX:far
extrn JoyCalCenterY:far
extrn JoyCalHighX:far
extrn JoyCalHighY:far
extrn JoyCalLowX:far
extrn JoyCalLowY:far
extrn JoyXHighThreshold:far
extrn JoyXLowThreshold:far
extrn JoyYHighThreshold:far
extrn JoyYLowThreshold:far
extrn KeyLastMakeCode:far
extrn LevelIndex:far
extrn ModuleSoundRequest:far
extrn OpenResourceFile:far
extrn SoundModuleLoaded:far
extrn SoundModuleTickEntry:far
extrn StateData:far
extrn TimerVectorInstalled:far
extrn loc_10170:far
MAIN segment para public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public AllocateBuffers
public BuildByteToNibbleMaskTable
public CalibrateJoystickWithAbort
public ClearByteCS066B
public InstallTimerVector08
public LoadFileToBuffer
public LoadPackedFile
public PackedDestOffset
public PackedDestSegment
public PackedNamePtr
public PackedOutputBytes
public PollInputBits
public RestoreTimerVector08
public SaveBufferToFile
public ShowFatalErrorAndExit
public WaitByteCS066B
public loc_0073C
public loc_00747
public loc_0075F
public loc_007EF
public loc_00B3E
public loc_00CB8
public loc_00D42
public loc_00E9C
public loc_00F0B
extrn ClearKeyDownTable:near
extrn DrawOffsetFromRow9EE8:near
extrn DrawPanelGraphic:near
extrn MainDataSegment:near
extrn PanelSegment:near
extrn PromptLoadErrorWaitFire:near
extrn ScreenSegment:near
extrn SfxTimerTick:near
extrn ShutdownGame:near
extrn VideoAdapter:near
extrn WaitVerticalRetrace:near
extrn WorkspaceSegment:near
extrn loc_05145:near
extrn loc_0526A:near
extrn loc_05BAC:near
extrn loc_05CB7:near
extrn loc_06176:near
extrn loc_077DF:near
extrn loc_0859E:near
extrn loc_0C57C:near
extrn loc_0C679:near
extrn loc_0CB1C:near
extrn loc_0CB3E:near
; UNKNOWN: not yet classified as code or data
    db 05h
; Esc during calibration jumps here from PollJoystickPrimaryOrAbort. Reloading the SP
; saved by CalibrateJoystickWithAbort makes the RET return straight to that routine's
; caller, discarding every nested frame, and input falls back to key table A.
AbortJoystickCalibration:
    mov sp, word ptr ds:[JoyCalAbortSp]
    mov byte ptr ds:[098BFh], 0
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    ret

; Switch input to the joystick and calibrate it; Esc aborts via AbortJoystickCalibration.
; The roles of word DS:0014 and byte DS:98BF are unknown.
CalibrateJoystickWithAbort:
    mov word ptr ds:[JoyCalAbortSp], sp
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    mov word ptr ds:[014h], 1
    call CalibrateJoystickThresholds
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    mov byte ptr ds:[098BFh], 0
    ret

; Take three stick samples, each after the primary button is released and pressed again,
; and derive the four thresholds as unsigned midpoints: LOW/CENTER and CENTER/HIGH.
; Sample names follow that arithmetic only. 0F7F:0980 and DrawPanelGraphic (probably the prompts)
; are unreviewed.
CalibrateJoystickThresholds:
    mov word ptr ds:[JoyButtonSelect], JOY_BUTTONS_PORT_A
    mov byte ptr ds:[098BFh], 0
    mov ax, 0BEBEh
    call far ptr loc_10170
    call WaitJoystickPrimaryRelease
@@wait_low_press:
    call PollJoystickPrimaryOrAbort
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@wait_low_press
    call ReadGamePortAAxisCounts
    mov word ptr ds:[JoyCalLowX], bx
    mov word ptr ds:[JoyCalLowY], cx
    call WaitJoystickPrimaryRelease
    mov ah, 055h
    mov al, 1
    mov si, 04Eh
    call DrawPanelGraphic
@@wait_high_press:
    call PollJoystickPrimaryOrAbort
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@wait_high_press
    call ReadGamePortAAxisCounts
    mov word ptr ds:[JoyCalHighX], bx
    mov word ptr ds:[JoyCalHighY], cx
    call WaitJoystickPrimaryRelease
    mov ah, 07Dh
    mov al, 1
    mov si, 04Fh
    call DrawPanelGraphic
@@wait_center_press:
    call PollJoystickPrimaryOrAbort
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@wait_center_press
    call ReadGamePortAAxisCounts
    mov word ptr ds:[JoyCalCenterX], bx
    mov word ptr ds:[JoyCalCenterY], cx
    mov bx, word ptr ds:[JoyCalHighX]
    sub bx, word ptr ds:[JoyCalCenterX]
    shr bx, 1
    add bx, word ptr ds:[JoyCalCenterX]
    mov word ptr ds:[JoyXHighThreshold], bx
    mov bx, word ptr ds:[JoyCalCenterX]
    sub bx, word ptr ds:[JoyCalLowX]
    shr bx, 1
    add bx, word ptr ds:[JoyCalLowX]
    mov word ptr ds:[JoyXLowThreshold], bx
    mov bx, word ptr ds:[JoyCalHighY]
    sub bx, word ptr ds:[JoyCalCenterY]
    shr bx, 1
    add bx, word ptr ds:[JoyCalCenterY]
    mov word ptr ds:[JoyYHighThreshold], bx
    mov bx, word ptr ds:[JoyCalCenterY]
    sub bx, word ptr ds:[JoyCalLowY]
    shr bx, 1
    add bx, word ptr ds:[JoyCalLowY]
    mov word ptr ds:[JoyYLowThreshold], bx
    ret

; Fire the game-port one-shots and count, with interrupts off, how many reads each
; joystick-A axis bit stays set: BX = X, CX = Y. Gives up after 15536 reads.
; Always returns with interrupts enabled.
ReadGamePortAAxisCounts:
    xor bx, bx
    mov cx, bx
    mov si, 0C350h
    mov dx, GAME_PORT
    cli
    out dx, al
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
@@count_axis_bits:
    in al, dx
    and ax, GAME_PORT_A_AXES
    je @@done
    rcr ax, 1
    adc bx, 0
    add cx, ax
    inc si
    jne @@count_axis_bits
@@done:
    sti
    ret

; One calibration poll: abort if Esc is held, otherwise read the stick and keep only
; the primary button bit in InputBits. All registers, including DS, are preserved.
PollJoystickPrimaryOrAbort:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    jne @@poll
    jmp near ptr AbortJoystickCalibration
@@poll:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
    call PollJoystickInputBits
    and byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Wait until the joystick primary button is released, then pause for 25 calls of WaitVerticalRetrace.
WaitJoystickPrimaryRelease:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
@@wait_release:
    call PollJoystickInputBits
    and byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@wait_release
    mov cx, 019h
@@delay:
    push cx
    call WaitVerticalRetrace
    pop cx
    loop @@delay
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Rebuild InputBits from the selected device. Keyboard: the eight scancodes of key
; table A (or B in mode 2) give bits 7..0, then Tab, Space and the arrow keys are ORed
; in. Joystick mode tail-jumps to PollJoystickInputBits, which leaves DS changed.
PollInputBits:
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    je PollJoystickInputBits
    mov cx, KEY_BIT_SCANCODE_COUNT
    xor bx, bx
    mov si, KEY_BIT_SCANCODES_A
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    jne @@have_table
    mov si, KEY_BIT_SCANCODES_B
@@have_table:
    mov di, KEY_DOWN_TABLE
@@collect_table_key:
    mov bl, byte ptr ds:[si]
    mov al, byte ptr ds:[bx + di]
    shr al, 1
    rcl byte ptr ds:[InputBits],1
    inc si
    loop @@collect_table_key
    cmp byte ptr ds:[di + SCAN_TAB], KEY_STATE_UP
    je @@check_space
    or byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
@@check_space:
    cmp byte ptr ds:[di + SCAN_SPACE], KEY_STATE_UP
    je @@check_up
    or byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
@@check_up:
    cmp byte ptr ds:[di + SCAN_UP], KEY_STATE_UP
    je @@check_down
    or byte ptr ds:[InputBits], IN_YMINUS
@@check_down:
    cmp byte ptr ds:[di + SCAN_DOWN], KEY_STATE_UP
    je @@check_left
    or byte ptr ds:[InputBits], IN_YPLUS
@@check_left:
    cmp byte ptr ds:[di + SCAN_LEFT], KEY_STATE_UP
    je @@check_right
    or byte ptr ds:[InputBits], IN_XMINUS
@@check_right:
    cmp byte ptr ds:[di + SCAN_RIGHT], KEY_STATE_UP
    je @@done
    or byte ptr ds:[InputBits], IN_XPLUS
@@done:
    ret

; Rebuild InputBits from game port A against the calibration thresholds. Loads DS with
; the state segment and does not restore it. Buttons read 0 while pressed. The port-B
; button masks are unreachable: JoyButtonSelect is set to port A just before the test.
PollJoystickInputBits:
    mov ax, seg StateData
    mov ds, ax
    mov byte ptr ds:[InputBits], 0
    mov word ptr ds:[JoyButtonSelect], JOY_BUTTONS_PORT_A
    call ReadGamePortAAxisCounts
    mov si, bx
    cmp si, word ptr ds:[JoyXLowThreshold]
    jae @@check_x_high
    or byte ptr ds:[InputBits], IN_XMINUS
@@check_x_high:
    cmp si, word ptr ds:[JoyXHighThreshold]
    jbe @@read_y
    or byte ptr ds:[InputBits], IN_XPLUS
@@read_y:
    call ReadGamePortAAxisCounts
    mov si, cx
    cmp si, word ptr ds:[JoyYLowThreshold]
    jae @@check_y_high
    or byte ptr ds:[InputBits], IN_YMINUS
@@check_y_high:
    cmp si, word ptr ds:[JoyYHighThreshold]
    jbe @@read_buttons
    or byte ptr ds:[InputBits], IN_YPLUS
@@read_buttons:
    mov dx, GAME_PORT
    in al, dx
    cmp word ptr ds:[JoyButtonSelect], JOY_BUTTONS_PORT_A
    mov cl, GAME_PORT_A_BUTTON2
    mov ch, GAME_PORT_A_BUTTON1
    je @@test_button2
    mov cl, GAME_PORT_B_BUTTON2
    mov ch, GAME_PORT_B_BUTTON1
@@test_button2:
    test al, cl
    jne @@test_button1
    or byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
@@test_button1:
    test al, ch
    jne @@done
    or byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
@@done:
    ret
; LoadPackedFile state (CS-resident; the loader runs with DS=CS).
PackedDestSegment dw 0 ; PackedDestSegment
PackedDestOffset dw 0 ; PackedDestOffset
PackedNamePtr dw 0 ; PackedNamePtr
PackedFileHandle dw 0 ; PackedFileHandle
PackedUnwindSp dw 0 ; PackedUnwindSp
PackedOutputBytes dw 0 ; PackedOutputBytes
PackedOpenFailed dw 0 ; PackedOpenFailed


; Open the packed file PackedNamePtr (through the resource container) and decode it
; to PackedDestSegment:PackedDestOffset; PackedOutputBytes counts the output. The
; first byte selects the format: 0 byte escape-RLE, 1 word escape-RLE, 2 dword
; escape-RLE, 3 PackBits (80h ends), 4 PackBits by columns. Success returns CF=0; any
; failure reloads the entry SP (PackedUnwindSp) and returns CF=1 straight to the
; caller. Short reads are not detected: the stream terminator stops decoding.
LoadPackedFile:
    mov ax, cs
    mov ds, ax
    mov word ptr ds:[PackedOutputBytes], 0
    mov word ptr ds:[PackedUnwindSp], sp
    mov word ptr ds:[PackedReadCursor], PACKED_READ_BUFFER_END
    push ds
    mov dx, word ptr ds:[PackedNamePtr]
    mov ax, seg StateData
    mov ds, ax
    mov al, 0
    mov ah, 03Dh
    call far ptr OpenResourceFile
    pop ds
    mov word ptr cs:[PackedOpenFailed], 1
    jb UnwindPackedLoad
    mov word ptr cs:[PackedOpenFailed], 0
    mov word ptr ds:[PackedFileHandle], ax
    call ReadBufferedByte
    or al, al
    je DecodeByteEscapeRle
    dec al
    je DecodeWordEscapeRle
    dec al
    jne @@try_mode3
    jmp near ptr DecodeDwordEscapeRle
@@try_mode3:
    dec al
    jne @@try_mode4
    jmp near ptr DecodePackBitsStream
@@try_mode4:
    dec al
    jne @@bad_mode
    jmp near ptr DecodeColumnPackBits
@@bad_mode:
    mov ax, 0FFFFh
    jmp short FailPackedLoad
FinishPackedLoad:
    call ClosePackedFile
    mov ds, word ptr cs:[MainDataSegment]
    clc
    ret
FailPackedLoad:
    push ax
    call ClosePackedFile
    pop ax
UnwindPackedLoad:
    mov bx, seg StateData
    mov ds, bx
    mov sp, word ptr cs:[PackedUnwindSp]
    stc
    ret
DecodeByteEscapeRle:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedByte
    mov bl, al
@@next:
    call ReadBufferedByte
    cmp al, bl
    je @@escape
    stosb
    inc word ptr ds:[PackedOutputBytes]
    jmp short @@next
@@escape:
    call ReadBufferedByte
    mov cl, al
    xor ch, ch
    jcxz FinishPackedLoad
    call ReadBufferedByte
    add word ptr ds:[PackedOutputBytes], cx
    rep stosb
    jmp short @@next
DecodeWordEscapeRle:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedWordLE
    mov bx, ax
@@next:
    call ReadBufferedWordLE
    cmp ax, bx
    je @@escape
    stosw
    add word ptr ds:[PackedOutputBytes], 2
    jmp short @@next
@@escape:
    call ReadBufferedWordLE
    mov cx, ax
    jcxz FinishPackedLoad
    call ReadBufferedWordLE
    add word ptr ds:[PackedOutputBytes], cx
    add word ptr ds:[PackedOutputBytes], cx
    rep stosw
    jmp short @@next
DecodeDwordEscapeRle:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedWordLE
    mov bx, ax
@@next:
    call ReadBufferedWordLE
    cmp ax, bx
    je @@escape
    stosw
    call ReadBufferedWordLE
    stosw
    add word ptr ds:[PackedOutputBytes], 4
    jmp short @@next
@@escape:
    call ReadBufferedWordLE
    mov cx, ax
    jcxz @@finish
    jmp short @@run
@@finish:
    jmp near ptr FinishPackedLoad
@@run:
    call ReadBufferedWordLE
    push ax
    call ReadBufferedWordLE
    mov dx, ax
    pop ax
@@store_run:
    stosw
    xchg ax, dx
    stosw
    add word ptr ds:[PackedOutputBytes], 4
    xchg ax, dx
    loop @@store_run
    jmp short @@next
DecodePackBitsStream:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
@@next_control:
    call ReadBufferedByte
    cmp al, 080h
    jne @@not_end
    jmp near ptr FinishPackedLoad
@@not_end:
    jb @@copy_literal
    neg al
    xchg ah, al
    xchg bl, ah
    call ReadBufferedByte
    xchg bl, ah
@@store_run:
    stosb
    inc word ptr ds:[PackedOutputBytes]
    dec ah
    jns @@store_run
    jmp short @@next_control
@@copy_literal:
    push ax
    call ReadBufferedByte
    stosb
    inc word ptr ds:[PackedOutputBytes]
    pop ax
    dec al
    jns @@copy_literal
    jmp short @@next_control
; UNKNOWN: not yet classified as code or data
    db 090h
; DecodeColumnPackBits header: only the width word is ever read.
PackedColumnHeader0 dw 0 ; PackedColumnHeader0
PackedColumnWidth dw 0 ; PackedColumnWidth
PackedColumnHeader2 dw 0 ; PackedColumnHeader2

DecodeColumnPackBits:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedWordLE
    mov word ptr cs:[PackedColumnHeader0], ax
    call ReadBufferedWordLE
    mov word ptr ds:[PackedColumnWidth], ax
    call ReadBufferedWordLE
    mov word ptr ds:[PackedColumnHeader2], ax
    mov cx, word ptr cs:[PackedColumnWidth]
@@next_column:
    push cx
    push di
@@next_control:
    call ReadBufferedByte
    cmp al, 080h
    je @@column_done
    jb @@copy_literal
    neg al
    xchg ah, al
    xchg bl, ah
    call ReadBufferedByte
    xchg bl, ah
@@store_run:
    mov byte ptr es:[di], al
    add di, word ptr cs:[PackedColumnWidth]
    inc word ptr ds:[PackedOutputBytes]
    dec ah
    jns @@store_run
    jmp short @@next_control
@@copy_literal:
    push ax
    call ReadBufferedByte
    mov byte ptr es:[di], al
    add di, word ptr cs:[PackedColumnWidth]
    inc word ptr ds:[PackedOutputBytes]
    pop ax
    dec al
    jns @@copy_literal
    jmp short @@next_control
@@column_done:
    pop di
    inc di
    pop cx
    loop @@next_column
    jmp near ptr FinishPackedLoad
; UNKNOWN: not yet classified as code or data
    db 090h
; ReadBufferedByte state: a 512-byte read buffer, its cursor, the caller's BX and
; the low-byte scratch of ReadBufferedWordLE.
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
PackedReadCursor dw 0 ; PackedReadCursor
PackedSavedBx dw 0 ; PackedSavedBx
PackedWordLow db 0 ; PackedWordLow

; Call ReadBufferedByte twice; first byte saved in DS:0614, second becomes AH and saved
; first becomes AL. Shares scratch and inherits nonlocal error unwind from callee.
ReadBufferedWordLE:
    call ReadBufferedByte
    mov byte ptr ds:[PackedWordLow], al
    call ReadBufferedByte
    mov ah, al
    mov al, byte ptr ds:[PackedWordLow]
    ret
; Save BX at DS:0612; cursor DS:0610. If cursor >=0610h, reset to0410h and request512 bytes
; via DOS AH=3F, handle DS:0240. Return byte in AL, advance cursor, restore BX. DOS failure
; branches to02B2 which restores SP from CS:0242. Short reads are not checked here.
ReadBufferedByte:
    mov word ptr ds:[PackedSavedBx], bx
    mov bx, word ptr ds:[PackedReadCursor]
    cmp bx, PACKED_READ_BUFFER_END
    jb @@take_byte
    mov word ptr ds:[PackedReadCursor], PACKED_READ_BUFFER
    push cx
    mov ah, DOS_READ_FILE
    mov bx, word ptr ds:[PackedFileHandle]
    mov cx, PACKED_READ_BUFFER_BYTES
    mov dx, PACKED_READ_BUFFER
    int 021h
    pop cx
    jae @@refilled
    jmp near ptr FailPackedLoad
@@refilled:
    mov bx, word ptr ds:[PackedReadCursor]
@@take_byte:
    mov al, byte ptr ds:[bx]
    inc word ptr ds:[PackedReadCursor]
    mov bx, word ptr ds:[PackedSavedBx]
    ret

ClosePackedFile:
    mov bx, word ptr cs:[PackedFileHandle]
    mov ah, DOS_CLOSE_FILE
    int 021h
    jae @@closed
    jmp near ptr FailPackedLoad
@@closed:
    ret
; UNKNOWN: not yet classified as code or data
    db 00h
; Increment byte CS:066B modulo 256; INC preserves incoming CF. Near return.
IncrementByteCS066B:
    inc byte ptr cs:[066Bh]
    ret
; ClearByteCS066B
; Write zero to CS:066B. Registers and flags unchanged; near return.
ClearByteCS066B:
    mov byte ptr cs:[066Bh], 0
    ret
; Poll CS:066B until nonzero. Requires asynchronous mutation to terminate from zero; near
; return leaves CMP flags.
WaitByteCS066B:
    cmp byte ptr cs:[066Bh], 0
    je WaitByteCS066B
    ret
; Once only: save the BIOS INT 08h vector in SAVED_INT08, speed the system timer up to
; TIMER_DIVISOR (about 72.8 Hz) and install Interrupt08Handler.
InstallTimerVector08:
    cmp word ptr ds:[TimerVectorInstalled], 1
    jne @@install
    ret
@@install:
    cli
    push es
    mov ax, DOS_GET_VECTOR*256 + 08h
    int 021h
    mov di, SAVED_INT08
    mov word ptr cs:[di], bx
    mov word ptr cs:[di + 2], es
    pop es
    mov al, PIT_CH0_SQUARE_WAVE
    out PIT_COMMAND_PORT, al
    xor al, al
    out PIT_CHANNEL0_PORT, al
    mov al, high TIMER_DIVISOR
    out PIT_CHANNEL0_PORT, al
    push ds
    push cs
    pop ds
    mov dx, 06E5h
    mov ax, DOS_SET_VECTOR*256 + 08h
    int 021h
    pop ds
    sti
    mov word ptr ds:[TimerVectorInstalled], 1
    ret

; Undo InstallTimerVector08: restore the saved INT 08h vector, the standard timer
; rate (divisor 0 = 65536) and silence the speaker.
RestoreTimerVector08:
    cmp word ptr ds:[TimerVectorInstalled], 0
    jne @@restore
    ret
@@restore:
    cli
    push ds
    lds dx, dword ptr cs:[SAVED_INT08]
    mov ax, DOS_SET_VECTOR*256 + 08h
    int 021h
    pop ds
    mov al, PIT_CH0_SQUARE_WAVE
    out PIT_COMMAND_PORT, al
    xor al, al
    out PIT_CHANNEL0_PORT, al
    out PIT_CHANNEL0_PORT, al
    sti
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h
; Interrupt08Handler
; Entry installed by InstallTimerVector08. Calls counter/music helpers and can chain a
; previous vector; inspect full CFG and unresolved far calls before changing it.
    push ax
    push ds
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    mov ds, word ptr cs:[MainDataSegment]
    cmp byte ptr ds:[SoundModuleLoaded], 1
    jne loc_00704
    call far ptr SoundModuleTickEntry
    mov ds, word ptr cs:[MainDataSegment]
loc_00704:
    call SfxTimerTick
    mov ds, word ptr cs:[MainDataSegment]
    test byte ptr ds:[054h], 1
    jne loc_00716
    call IncrementByteCS066B
loc_00716:
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    inc byte ptr ds:[054h]
    and byte ptr ds:[054h], 3
    je loc_0072F
    pop ds
    mov al, 020h
    out 020h, al
    pop ax
    iret
loc_0072F:
    pop ds
    pop ax
    sti
    jmp dword ptr cs:[SAVED_INT08]
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h

loc_0073C:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F9], KEY_STATE_DOWN
    je loc_00744
    ret
loc_00744:
    call loc_0075F

loc_00747:
    call loc_007EF
    cmp word ptr ds:[0BDACh], 1
    jne loc_00752
    ret
loc_00752:
    call loc_06176
    call loc_077DF
    call loc_0859E
    call loc_0C57C
    ret

loc_0075F:
    call loc_0CB3E
    mov ax, 3
    int 010h
    mov ds, word ptr cs:[MainDataSegment]
    mov ax, 0B800h
    mov es, ax
    xor di, di
    mov si, 056h
    call loc_00854
    mov di, 1
    mov al, 0Ch
    call loc_0084C
    mov al, 0Eh
    mov cx, 01E0h
    call loc_0084F
    mov cx, 0Fh
loc_0078C:
    push cx
    mov al, 0Eh
    mov cx, 1
    call loc_0084F
    mov al, 7
    mov cx, 04Fh
    call loc_0084F
    pop cx
    loop loc_0078C
    mov al, 01Eh
    call loc_0084C
    mov al, 01Eh
    call loc_0084C
    mov di, 0731h
    mov al, 071h
    mov cx, 0Dh
    call loc_0084F
    mov dl, 047h
    mov dh, 017h
    mov ah, 2
    mov bh, 0
    int 010h
    mov ds, word ptr cs:[MainDataSegment]
loc_007C4:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F9], KEY_STATE_DOWN
    je loc_007C4
    mov byte ptr ds:[KeyLastMakeCode], 0
loc_007D0:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_007D0
loc_007D7:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F9], KEY_STATE_DOWN
    je loc_007D7
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, VIDEO_BIOS_MODE_TABLE
    xlat
    int 010h
    mov al, byte ptr ds:[ModuleSoundRequest]
    call loc_0CB1C
    ret

loc_007EF:
    call loc_05145
    mov ax, 01Bh
    call DrawOffsetFromRow9EE8
    mov si, 025h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    lodsw
    mov word ptr cs:[058FDh], ax
    lodsw
    mov word ptr cs:[058FFh], ax
    mov word ptr cs:[058FBh], si
    mov word ptr cs:[058F9h], di
    mov word ptr cs:[05905h], 0
    mov word ptr cs:[05907h], 0
    mov word ptr cs:[05901h], 0C6h
    mov es, word ptr cs:[ScreenSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + 0595Ah]
    mov ds, word ptr cs:[MainDataSegment]
    call loc_05CB7
    ret

loc_0084C:
    mov cx, 050h

loc_0084F:
    stosb
    inc di
    loop loc_0084F
    ret

loc_00854:
    mov cx, 07D0h
    rep movsw
    ret
; Text mode, print MSG_NOT_ENOUGH_MEMORY, pause 200 frames and leave through ShutdownGame.
ShowOutOfMemoryAndExit:
    mov ax, 3
    int 010h
    mov dx, MSG_NOT_ENOUGH_MEMORY
    mov ah, DOS_PRINT_STRING
    int 021h
    mov cx, 0C8h
@@delay:
    call WaitVerticalRetrace
    loop @@delay
    jmp near ptr ShutdownGame
; Jump target, DX = $-terminated message: switch to text mode, print it, pause
; 200 ticks of WaitVerticalRetrace and leave through ShutdownGame.
ShowFatalErrorAndExit:
    push dx
    mov ax, 3
    int 010h
    pop dx
    mov ah, DOS_PRINT_STRING
    int 021h
    mov cx, 0C8h
@@delay:
    call WaitVerticalRetrace
    loop @@delay
    jmp near ptr ShutdownGame
; Running total of paragraphs requested by AllocateBuffers.
AllocatedParagraphs dw 00000h

; Copy the current adapter's geometry table to DS:1024, set ScreenSegment from it and
; allocate the game's buffers through DOS; any failure ends in ShowOutOfMemoryAndExit.
AllocateBuffers:
    mov word ptr cs:[AllocatedParagraphs], 0
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[MainDataSegment]
    mov si, word ptr cs:[VideoAdapter]
    shl si, 1
    add si, 0116Eh
    mov si, word ptr ds:[si]
    mov di, 01024h
    mov cx, 027h
    rep movsw
    lodsw
    mov word ptr cs:[0959Eh], ax
    lodsw
    mov word ptr cs:[095A0h], ax
    lodsw
    mov word ptr cs:[ScreenSegment], ax
    mov cx, 010h
    mov ax, word ptr cs:[0959Eh]
    mul cx
    mov word ptr cs:[095A2h], ax
    mov word ptr cs:[095BEh], ax
    mov bx, ax
    mov cx, 0Dh
    mul cx
    mov word ptr cs:[095C2h], ax
    add ax, bx
    mov word ptr cs:[095C0h], ax
    mov bx, 01000h
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_008F1
    jmp near ptr ShowOutOfMemoryAndExit
loc_008F1:
    mov word ptr cs:[WorkspaceSegment], ax
    mov ax, 075h
    mul word ptr ds:[01024h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00915
    jmp near ptr ShowOutOfMemoryAndExit
loc_00915:
    mov word ptr cs:[095A8h], ax
    mov ax, 0FFh
    mul word ptr ds:[01026h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00939
    jmp near ptr ShowOutOfMemoryAndExit
loc_00939:
    mov word ptr cs:[095AAh], ax
    mov ax, 082h
    mul word ptr ds:[01026h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_0095D
    jmp near ptr ShowOutOfMemoryAndExit
loc_0095D:
    mov word ptr cs:[095ACh], ax
    mov ax, 0Dh
    mul word ptr ds:[01028h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00981
    jmp near ptr ShowOutOfMemoryAndExit
loc_00981:
    mov word ptr cs:[095AEh], ax
    mov ax, 01Ch
    mul word ptr ds:[01028h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_009A5
    jmp near ptr ShowOutOfMemoryAndExit
loc_009A5:
    mov word ptr cs:[095A6h], ax
    mov ax, word ptr ds:[0102Ch]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_009C5
    jmp near ptr ShowOutOfMemoryAndExit
loc_009C5:
    mov word ptr cs:[095B2h], ax
    mov bx, word ptr ds:[0102Eh]
    mov ax, 010h
    mul word ptr ds:[01030h]
    add bx, ax
    mov ax, 8
    mul word ptr ds:[01032h]
    add bx, ax
    mov ax, 7
    mul word ptr ds:[01034h]
    add bx, ax
    mov ax, 6
    mul word ptr ds:[01036h]
    add bx, ax
    mov ax, 4
    mul word ptr ds:[01038h]
    add bx, ax
    mov ax, 4
    mul word ptr ds:[0103Ah]
    add bx, ax
    mov ax, 012h
    mul word ptr ds:[0103Ch]
    add bx, ax
    mov ax, word ptr ds:[01058h]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[0105Ah]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[0105Ch]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[0105Eh]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[01060h]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[01062h]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[01064h]
    shl ax, 1
    add bx, ax
    add bx, word ptr ds:[01066h]
    add bx, word ptr ds:[01068h]
    mov ax, word ptr ds:[0106Ah]
    shl ax, 1
    add bx, ax
    shl ax, 1
    add bx, ax
    add bx, word ptr ds:[0106Ch]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00A6B
    jmp near ptr ShowOutOfMemoryAndExit
loc_00A6B:
    mov word ptr cs:[PanelSegment], ax
    mov bx, word ptr ds:[0106Eh]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00A8A
    jmp near ptr ShowOutOfMemoryAndExit
loc_00A8A:
    mov word ptr cs:[095B6h], ax
    mov bx, word ptr ds:[0103Eh]
    add bx, word ptr ds:[01040h]
    add bx, word ptr ds:[01042h]
    add bx, word ptr ds:[01044h]
    add bx, word ptr ds:[01046h]
    add bx, word ptr ds:[01048h]
    add bx, word ptr ds:[0104Ah]
    add bx, word ptr ds:[0104Ch]
    add bx, word ptr ds:[0104Eh]
    add bx, word ptr ds:[01050h]
    add bx, word ptr ds:[01050h]
    add bx, word ptr ds:[01050h]
    add bx, word ptr ds:[01052h]
    add bx, word ptr ds:[01052h]
    add bx, word ptr ds:[01052h]
    add bx, word ptr ds:[01054h]
    add bx, word ptr ds:[01054h]
    add bx, word ptr ds:[01054h]
    add bx, word ptr ds:[01056h]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00AF1
    jmp near ptr ShowOutOfMemoryAndExit
loc_00AF1:
    mov word ptr cs:[095B8h], ax
    mov ax, 0100h
    mul word ptr ds:[01070h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00B15
    jmp near ptr ShowOutOfMemoryAndExit
loc_00B15:
    mov word ptr cs:[0959Ah], ax
    mov ax, 02Ch
    mul word ptr ds:[01070h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00B39
    jmp near ptr ShowOutOfMemoryAndExit
loc_00B39:
    mov word ptr cs:[0959Ch], ax
    ret

loc_00B3E:
    mov word ptr ds:[0C5F5h], 0C85Ch
    mov word ptr ds:[0C5F7h], 0C8D6h
    mov word ptr ds:[0C5F9h], 0CA02h
    mov word ptr ds:[0C5FBh], 0CC36h
    mov word ptr ds:[0C5FDh], 0CC80h
    mov word ptr ds:[0C5FFh], 0CCAAh
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    add bx, 014C0h
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[FileNamePtr], bx
    mov ax, word ptr cs:[09592h]
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
loc_00B7F:
    call loc_0C679
    cmp word ptr ds:[FileStatus], FILE_STATUS_OK
    je InitializeByteAttributes
    call PromptLoadErrorWaitFire
    jmp short loc_00B7F
; Initialize shared byte attributes to 1, then apply a selected sparse patch stream.
; ES uses MainDataSegment for fill; DS addresses the patch stream and table writes.
; Forward traversal requires DF=0; do not infer the selector range from this loop.
InitializeByteAttributes:
    mov es, word ptr cs:[MainDataSegment]
    mov di, BYTE_ATTRIBUTE_TABLE
    push di
    mov cx, BYTE_ATTRIBUTE_COUNT
    mov al, 1
    rep stosb
    pop di
    mov si, word ptr ds:[LevelIndex]
    shl si, 1
    add si, ATTRIBUTE_PATCH_POINTERS
    mov si, word ptr ds:[si]
; Each patch is index,value; FF terminates before a value is read.
; Consequently entry FF is not patched by this format.
ReadAttributePatchIndex:
    lodsb
    cmp al, ATTRIBUTE_PATCH_END
    je AttributePatchesDone
    xor ah, ah
    mov bx, ax
    lodsb
    mov byte ptr ds:[bx + di], al
    jmp short ReadAttributePatchIndex
AttributePatchesDone:
    mov es, word ptr cs:[ATTRIBUTE_SOURCE_SEGMENT]
    xor di, di
    mov cx, 01Ah
    mov al, 1
    rep stosb
    mov di, 0E5Fh
    mov si, 0D1BCh
    mov cx, 041h
    rep movsb
    jmp near ptr ClearKeyDownTable
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h

loc_00CB8:
    mov word ptr cs:[0BD6h], 0
    mov word ptr cs:[0BD8h], 1
    jmp short loc_00CF6

loc_00CC8:
    mov word ptr cs:[0BD6h], 0
    mov word ptr cs:[0BD8h], 0
    jmp short loc_00CF6

loc_00CD8:
    mov word ptr cs:[0BD6h], 1
    mov word ptr cs:[0BD8h], 0
    jmp short loc_00CF6
; UNKNOWN: not yet classified as code or data
    db 02Eh,0C7h,06h,0D6h,0Bh,01h,00h,02Eh,0C7h,06h,0D8h,0Bh,01h,00h
loc_00CF6:
    call loc_0526A
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
    mov ax, word ptr cs:[0BDEh]
    mov word ptr ds:[FileNamePtr], ax
    push ax
loc_00D0E:
    call loc_0C679
    cmp word ptr ds:[FileStatus], FILE_STATUS_OK
    je loc_00D1D
    call PromptLoadErrorWaitFire
    jmp short loc_00D0E
loc_00D1D:
    pop bp
    dec bp
    dec bp
    mov bp, word ptr ss:[bp]
    cmp byte ptr cs:[0C5B0h], 1
    je loc_00D2E
    mov bp, 0FFFFh
loc_00D2E:
    mov ds, word ptr cs:[WorkspaceSegment]
    mov es, word ptr cs:[0BDCh]
    mov di, word ptr cs:[0BDAh]
    xor si, si
    jmp near ptr loc_05BAC

loc_00D42:
    mov word ptr cs:[0BDEh], 01298h
    mov ax, word ptr cs:[095A8h]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012A4h
    mov ax, word ptr cs:[095AAh]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012B0h
    mov ax, word ptr cs:[095ACh]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012BDh
    mov ax, word ptr cs:[095A6h]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012DAh
    mov ax, word ptr cs:[095B2h]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0BE4h
    call loc_00CB8
    mov word ptr cs:[0BDEh], 012E8h
    mov ax, word ptr cs:[PanelSegment]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0BE4h
    mov byte ptr ds:[0BB84h], 1
    call loc_00CB8
    mov byte ptr ds:[0BB84h], 0
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    jne loc_00DE3
    mov es, word ptr cs:[PanelSegment]
    xor di, di
    mov ax, 0Fh
    mul word ptr ds:[01030h]
    mov cx, ax
    mov si, 01C16h
    rep movsb
loc_00DE3:
    mov word ptr cs:[0BDEh], 01303h
    mov ax, word ptr cs:[095B8h]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0C92h
    call loc_00CB8
    mov word ptr cs:[0BDEh], 012F6h
    mov ax, word ptr cs:[0959Ch]
    mov word ptr cs:[0BDCh], ax
    call loc_00CC8
    ret

; Read the whole file named by FileNamePtr into FileBufferSegment:FileBufferOffset.
; Callers must test FileStatus: DOS errors return early through UnwindFileError, and a
; failed read leaves the handle open.
LoadFileToBuffer:
    mov word ptr ds:[FileStatus], FILE_STATUS_OK
    call OpenFileForRead
    call ReadFileToBuffer
    jmp short CloseFileAndReturn

; Create the file named by FileNamePtr and write FileByteCount bytes from the buffer.
; Errors return early through UnwindFileError without setting FileStatus; a short write
; is not detected.
SaveBufferToFile:
    call CreateFileForWrite
    call WriteBufferToFile
CloseFileAndReturn:
    call CloseFileHandle
    ret

; DOS create; on error return from the enclosing load/save call (UnwindFileError).
CreateFileForWrite:
    mov dx, word ptr ds:[FileNamePtr]
    xor cx, cx
    mov al, 2
    mov ah, DOS_CREATE_FILE
    int 021h
    jb UnwindFileError
    mov word ptr ds:[FileHandle], ax
    ret

; DOS open for reading; on error set FileStatus and return from the enclosing load call.
OpenFileForRead:
    mov dx, word ptr ds:[FileNamePtr]
    xor al, al
    mov ah, DOS_OPEN_FILE
    int 021h
    jb @@open_failed
    mov word ptr ds:[FileHandle], ax
    ret
@@open_failed:
    mov word ptr ds:[FileStatus], FILE_STATUS_OPEN_FAILED
    jmp short UnwindFileError

; DOS write of FileByteCount bytes; on error return from the enclosing save call.
WriteBufferToFile:
    mov ax, word ptr ds:[FileBufferSegment]
    mov bx, word ptr ds:[FileHandle]
    mov cx, word ptr ds:[FileByteCount]
    mov dx, word ptr ds:[FileBufferOffset]
    push ds
    mov ds, ax
    mov ah, DOS_WRITE_FILE
    int 021h
    pop ds
    jb UnwindFileError
    ret
UnwindFileError:
    pop ax
    ret

; DOS read of up to FFFFh bytes, storing the count read; on error set FileStatus and
; return from the enclosing load call.
ReadFileToBuffer:
    mov ax, word ptr ds:[FileBufferSegment]
    mov bx, word ptr ds:[FileHandle]
    mov cx, 0FFFFh
    mov dx, word ptr ds:[FileBufferOffset]
    push ds
    mov ds, ax
    mov ah, DOS_READ_FILE
    int 021h
    pop ds
    jb @@read_failed
    mov word ptr ds:[FileByteCount], ax
    ret
@@read_failed:
    mov word ptr ds:[FileStatus], FILE_STATUS_READ_FAILED
    jmp short UnwindFileError

; DOS close of FileHandle.
CloseFileHandle:
    mov bx, word ptr ds:[FileHandle]
    mov ah, DOS_CLOSE_FILE
    int 021h
    jb UnwindFileError
    ret

loc_00E9C:
    mov ax, word ptr cs:[0959Ah]
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
    mov si, word ptr ds:[LevelIndex]
    shl si, 1
    shl si, 1
    add si, 014E8h
    lodsw
    mov word ptr ds:[014E6h], ax
    lodsw
    mov word ptr ds:[FileNamePtr], ax
    mov word ptr cs:[0BDEh], ax
    mov ax, word ptr cs:[0959Ah]
    mov word ptr cs:[0BDCh], ax
    call loc_00CC8
    mov ax, word ptr ds:[014E6h]
    mov word ptr cs:[0BDEh], ax
    mov ax, word ptr cs:[095AEh]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    mov ax, word ptr ds:[bx + 01508h]
    mov word ptr cs:[0BDEh], ax
    mov ax, word ptr cs:[095B6h]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0BE2h
    mov byte ptr ds:[0BB84h], 1
    call loc_00CB8
    mov byte ptr ds:[0BB84h], 0
    jmp near ptr ClearKeyDownTable

loc_00F0B:
    mov ds, word ptr cs:[MainDataSegment]
    mov es, word ptr cs:[MainDataSegment]
    mov di, 099C8h
    mov cx, 010h
    mov ax, 0FFFFh
    rep stosw
    mov ax, word ptr cs:[0959Eh]
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    neg ax
    mov cx, 0D0h
loc_00F31:
    stosw
    add ax, word ptr cs:[0959Eh]
    loop loc_00F31
    mov ax, 0FFFFh
    mov cx, 020h
    rep stosw
    mov di, 09BC8h
    xor ax, ax
    mov cx, 0C8h
loc_00F49:
    stosw
    add ax, word ptr cs:[0959Eh]
    loop loc_00F49
    mov di, 09D58h
    xor ax, ax
    mov cx, 0C8h
loc_00F59:
    stosw
    add ax, word ptr cs:[095A0h]
    loop loc_00F59
    mov di, 09EE8h
    mov cx, 0C8h
    xor ax, ax
loc_00F69:
    stosw
    xchg ax, di
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 0F77h]
; UNKNOWN: not yet classified as code or data
    db 07Dh,0Fh,08Dh,0Fh,092h,0Fh

    add di, 02000h
    test di, 04000h
    je loc_00F8B
    add di, 0C050h
loc_00F8B:
    jmp short loc_00FA0

    add di, 028h
    jmp short loc_00FA0

    add di, 02000h
    test di, 08000h
    je loc_00FA0
    add di, 080A0h
loc_00FA0:
    xchg ax, di
    loop loc_00F69
    push cs
    pop es
    mov di, 08D92h
    mov cx, 0100h
    xor ax, ax
loc_00FAD:
    stosw
    add ax, word ptr ds:[01070h]
    loop loc_00FAD
    mov di, 08F92h
    mov cx, 0100h
    xor ax, ax
loc_00FBC:
    stosw
    add ax, word ptr ds:[01024h]
    loop loc_00FBC
    mov di, 09192h
    mov cx, 0100h
    xor ax, ax
loc_00FCB:
    stosw
    add ax, word ptr ds:[01026h]
    loop loc_00FCB
    mov di, 09392h
    mov cx, 0100h
    xor ax, ax
loc_00FDA:
    stosw
    add ax, word ptr ds:[01028h]
    loop loc_00FDA
    jmp near ptr loc_0526A

; For every byte value, write four bytes at DS:1514+4*value expanding bits 7..0 into
; nibble masks (F or 0), i.e. one mask byte per two Tandy 4-bit pixels.
BuildByteToNibbleMaskTable:
    mov es, word ptr cs:[MainDataSegment]
    mov di, 01517h
    xor dh, dh
loc_00FEE:
    mov dl, dh
    xor al, al
    rcr dl, 1
    jae loc_00FF8
    mov al, 0Fh
loc_00FF8:
    rcr dl, 1
    jae loc_00FFE
    add al, 0F0h
loc_00FFE:
    mov byte ptr ds:[di], al
    dec di
    xor al, al
    rcr dl, 1
    jae loc_01009
    mov al, 0Fh
loc_01009:
    rcr dl, 1
    jae loc_0100F
    add al, 0F0h
loc_0100F:
    mov byte ptr ds:[di], al
    dec di
    xor al, al
    rcr dl, 1
    jae loc_0101A
    mov al, 0Fh
loc_0101A:
    rcr dl, 1
    jae loc_01020
    add al, 0F0h
loc_01020:
    mov byte ptr ds:[di], al
    dec di
    xor al, al
    rcr dl, 1
    jae loc_0102B
    mov al, 0Fh
loc_0102B:
    rcr dl, 1
    jae loc_01031
    add al, 0F0h
loc_01031:
    mov byte ptr ds:[di], al
    dec di
    add di, 8
    inc dh
    jne loc_00FEE
    ret
; UNKNOWN: not yet classified as code or data
    db 026h,08Bh,05h,023h,04h,0Bh,044h,04h,026h,089h,05h,026h,08Bh,045h,02h,023h
    db 044h,02h,0Bh,044h,06h,026h,089h,045h,02h,083h,0C7h,01Ah,026h,08Bh,05h,023h
    db 04h,0Bh,044h,08h,026h,089h,05h,026h,08Bh,045h,02h,023h,044h,02h,0Bh,044h
    db 0Ah,026h,089h,045h,02h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h,0Ch
    db 026h,089h,05h,026h,08Bh,045h,02h,023h,044h,02h,0Bh,044h,0Eh,026h,089h,045h
    db 02h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h,010h,026h,089h,05h,026h
    db 08Bh,045h,02h,023h,044h,02h,0Bh,044h,012h,026h,089h,045h,02h,083h,0C7h,01Ah
    db 083h,0C6h,014h,0E2h,08Bh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,0F7h,0D0h,026h
    db 09h,05h,026h,09h,045h,01Ah,026h,09h,045h,034h,026h,09h,045h,04Eh,08Bh,044h
    db 02h,0F7h,0D0h,026h,09h,045h,02h,026h,09h,045h,01Ch,026h,09h,045h,036h,026h
    db 09h,045h,050h,083h,0C7h,068h,083h,0C6h,014h,0E2h,0D0h,02Eh,08Eh,01Eh,096h,095h
    db 0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h
    db 045h,01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h
    db 05Dh,036h,026h,020h,055h,038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h
    db 055h,052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh
    db 044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,08Bh,044h,0Ch
    db 08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h
    db 09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,08Bh,044h,010h,08Bh,05Ch
    db 012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h
    db 04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h
    db 02h,0EBh,03h,0E9h,03Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch
    db 02h,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h
    db 026h,020h,055h,04h,026h,021h,045h,01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh
    db 026h,021h,045h,034h,026h,021h,05Dh,036h,026h,020h,055h,038h,026h,021h,045h,04Eh
    db 026h,021h,05Dh,050h,026h,020h,055h,052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh
    db 044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h
    db 09h,05Dh,01Ch,026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,08Bh
    db 044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,04Eh,026h
    db 09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h,0EBh
    db 03h,0E9h,08h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h
    db 0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h,045h
    db 01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h,05Dh
    db 036h,026h,020h,055h,038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h,055h
    db 052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h
    db 055h,04h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch
    db 026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h
    db 05Dh,036h,026h,08h,055h,038h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,04Eh
    db 026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h
    db 0EBh,03h,0E9h,0D5h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h
    db 0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,021h
    db 05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h,045h,01Ah,026h,021h,05Dh
    db 01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h,05Dh,036h,026h,020h,055h
    db 038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h,055h,052h,08Bh,044h,04h
    db 08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h
    db 026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch
    db 026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h
    db 08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h
    db 0C6h,014h,0E2h,02h,0EBh,03h,0E9h,0A2h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h
    db 0FFh,08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
    db 0D2h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D7h,0D0h
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,021h
    db 05Dh,03h,026h,020h,055h,01Ah,026h,021h,045h,01Bh,026h,021h,05Dh,01Dh,026h,020h
    db 055h,034h,026h,021h,045h,035h,026h,021h,05Dh,037h,026h,020h,055h,04Eh,026h,021h
    db 045h,04Fh,026h,021h,05Dh,051h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E7h
    db 0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h
    db 09h,045h,01h,026h,09h,05Dh,03h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h
    db 0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h
    db 0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h
    db 01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h
    db 0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,034h,026h,09h,045h,035h,026h,09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch
    db 012h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h
    db 083h,0C6h,014h,0E2h,02h,0EBh,03h,0E9h,0D5h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 0B2h,0FFh,08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h
    db 026h,021h,045h,01h,026h,021h,05Dh,03h,026h,020h,055h,01Ah,026h,021h,045h,01Bh
    db 026h,021h,05Dh,01Dh,026h,020h,055h,034h,026h,021h,045h,035h,026h,021h,05Dh,037h
    db 026h,020h,055h,04Eh,026h,021h,045h,04Fh,026h,021h,05Dh,051h,08Bh,044h,04h,08Bh
    db 05Ch,06h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h
    db 0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h
    db 09h,05Dh,03h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch
    db 0Eh,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,034h,026h,09h,045h,035h,026h
    db 09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h,083h,0C6h
    db 014h,0E2h,02h,0EBh,03h,0E9h,08h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh
    db 08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
    db 026h,020h,015h,026h,021h,045h,01h,026h,021h,05Dh,03h,026h,020h,055h,01Ah,026h
    db 021h,045h,01Bh,026h,021h,05Dh,01Dh,026h,020h,055h,034h,026h,021h,045h,035h,026h
    db 021h,05Dh,037h,026h,020h,055h,04Eh,026h,021h,045h,04Fh,026h,021h,05Dh,051h,08Bh
    db 044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,08Bh,044h,08h,08Bh
    db 05Ch,0Ah,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h
    db 055h,01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch,0Eh
    db 032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,034h
    db 026h,09h,045h,035h,026h,09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h
    db 0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h
    db 045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h,0EBh,03h
    db 0E9h,03Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh
    db 0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,026h,09h,045h,01Ah,026h
    db 09h,05Dh,01Ch,026h,08h,055h,01Eh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h
    db 08h,055h,038h,026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h
    db 0C7h,068h,083h,0C6h,014h,0E2h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh
    db 05Ch,02h,0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h
    db 05h,026h,09h,05Dh,02h,026h,08h,055h,04h,026h,09h,045h,01Ah,026h,09h,05Dh
    db 01Ch,026h,08h,055h,01Eh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h
    db 038h,026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h
    db 083h,0C6h,014h,0E2h,0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h
    db 0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h
    db 04h,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,026h,09h,045h
    db 034h,026h,09h,05Dh,036h,026h,08h,055h,038h,026h,09h,045h,04Eh,026h,09h,05Dh
    db 050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,09Eh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h
    db 08h,055h,04h,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,026h
    db 09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,026h,09h,045h,04Eh,026h
    db 09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,094h,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,08Bh,05Ch,02h,0F6h,0D2h,0F7h,0D0h
    db 0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h
    db 0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
    db 026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h,01Ah,026h
    db 09h,045h,01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h,035h,026h
    db 09h,05Dh,037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h
    db 0C7h,068h,083h,0C6h,014h,0E2h,09Eh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh
    db 04h,08Bh,05Ch,02h,0F6h,0D2h,0F7h,0D0h,0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h
    db 015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h,01Ah,026h,09h,045h
    db 01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h,035h,026h,09h,05Dh
    db 037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h
    db 083h,0C6h,014h,0E2h,0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,08Bh
    db 05Ch,02h,0F6h,0D2h,0F7h,0D0h,0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h
    db 01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h
    db 035h,026h,09h,05Dh,037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh
    db 051h,083h,0C7h,068h,083h,0C6h,014h,0E2h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,026h
    db 08Bh,05h,023h,04h,0Bh,044h,02h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h
    db 023h,04h,0Bh,044h,04h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h
    db 0Bh,044h,06h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h
    db 08h,026h,089h,05h,083h,0C7h,01Ah,083h,0C6h,0Ah,0E2h,0C3h,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,08Bh,04h,0F7h,0D0h,026h,09h,05h,026h,09h,045h,01Ah,026h,09h,045h
    db 034h,026h,09h,045h,04Eh,083h,0C6h,0Ah,083h,0C7h,068h,0E2h,0E5h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h
    db 026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h
    db 026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h,055h,036h,0ADh,032h
    db 0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,04Eh,026h,08h,055h,050h,083h
    db 0C7h,068h,0E2h,08Fh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h
    db 055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h,026h,020h
    db 055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h
    db 0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h
    db 09h,045h,01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h,055h,036h,0ADh,032h
    db 0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
    db 04Eh,026h,08h,055h,050h,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h,06Bh,0FFh,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h
    db 026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h
    db 026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
    db 01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h
    db 055h,036h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,04Eh,026h,08h,055h,050h,083h
    db 0C7h,068h,0E2h,02h,0EBh,03h,0E9h,04Ch,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh
    db 0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h
    db 05h,026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h
    db 034h,026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh
    db 032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,01Ah,026h,08h
    db 055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
    db 034h,026h,08h,055h,036h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 026h,09h,045h,04Eh,026h,08h,055h,050h,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h
    db 02Dh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,0ADh,0F9h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
    db 026h,020h,015h,026h,021h,045h,01h,026h,020h,055h,01Ah,026h,021h,045h,01Bh,026h
    db 020h,055h,034h,026h,021h,045h,035h,026h,020h,055h,04Eh,026h,021h,045h,04Fh,0ADh
    db 032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h
    db 026h,08h,055h,01Ah,026h,09h,045h,01Bh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h
    db 034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h
    db 045h,04Fh,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h,04Ch,0FFh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,0B2h,0FFh,0ADh,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D4h,0D0h
    db 0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,020h,055h,01Ah,026h,021h
    db 045h,01Bh,026h,020h,055h,034h,026h,021h,045h,035h,026h,020h,055h,04Eh,026h,021h
    db 045h,04Fh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,0ADh
    db 032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h
    db 055h,034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h
    db 0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h
    db 0E2h,02h,0EBh,03h,0E9h,06Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,0ADh
    db 0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,020h
    db 055h,01Ah,026h,021h,045h,01Bh,026h,020h,055h,034h,026h,021h,045h,035h,026h,020h
    db 055h,04Eh,026h,021h,045h,04Fh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,01Ah,026h,09h,045h,01Bh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h
    db 026h,08h,055h,034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,0E2h,08Fh,02Eh,08Eh
    db 01Eh,096h,095h,0C3h,08Bh,04h,0B2h,0FFh,0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h,055h
    db 01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h,055h
    db 050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0CBh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh
    db 04h,0B2h,0FFh,0F7h
MAIN ends
end