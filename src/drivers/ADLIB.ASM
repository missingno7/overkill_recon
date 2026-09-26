; Modern optional-module source; historical source filename unknown.
; Original resource: ADLIB.ENC; no relocation table in ENC stream.
locals
; Music stream bytes (per voice): 00..7Fh note (index + transpose into NoteBlock/
; NoteFnum, lasts the current length); ADL_LENGTH + n (n = 1..32 steps) sets the
; length; ADL_INSTRUMENT + n selects Instrument n; 80h..8Dh commands (StreamCommandHandlers),
; 8Eh..9Fh stop all. Operands: TRANSPOSE b, CARRIER_VOLUME b, JUMP w, BEND w b b,
; DETUNE_SLIDE w w b.
ADL_END_PATTERN equ 80h
ADL_REST equ 81h
ADL_TIE equ 82h
ADL_STOP_ALL equ 83h
ADL_TRANSPOSE equ 84h
ADL_VOICE_END equ 85h
ADL_STEP_UP equ 86h
ADL_STEP_DOWN equ 87h
ADL_CARRIER_VOLUME equ 88h
ADL_JUMP equ 89h
ADL_BEND equ 8Ah
ADL_DETUNE_SLIDE equ 8Bh
ADL_CLEAR_DETUNE equ 8Ch
ADL_STEP_OFF equ 8Dh
ADL_INSTRUMENT equ 0A0h
ADL_LENGTH equ 0DFh

driver segment byte public 'CODE'
assume cs:driver,ds:nothing,ss:nothing,es:nothing
Opl2Table04B1 equ 04B1h

Opl2BasePortWord equ 0Eh ; modern name, word at module header +0Eh
    call loc_00063
    retf
    call loc_004E9
    retf
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,088h,03h,00h,00h,054h,079h,070h,065h,020h,03Ah
    db 020h,041h,064h,04Ch,069h,062h,0Dh,0Ah,020h,046h,069h,06Ch,065h,020h,03Ah,020h
    db 04Fh,076h,065h,072h,06Bh,069h,06Ch,06Ch,024h,044h,061h,074h,065h,020h,03Ah,020h
    db 030h,033h,02Eh,031h,031h,02Eh,039h,032h,024h,04Dh,075h,073h,069h,063h,020h,062h
    db 079h,020h,053h,06Fh,075h,06Eh,064h,020h,049h,06Dh,061h,067h,065h,073h,020h,028h
    db 063h,029h,020h,031h,039h,039h,032h,00h,01h,00h,00h
loc_00063:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push ds
    push cs
    pop ds
    mov si, 062h
    cmp byte ptr ds:[si], 0
    jne loc_000C5
    inc byte ptr ds:[si]
    call loc_00409
    dec byte ptr ds:[0Dh]
    mov di, 05A9h
    call loc_000CD
    mov di, 05C9h
    call loc_000CD
    mov di, 05E9h
    call loc_000CD
    mov di, 0609h
    call loc_000CD
    mov di, 0629h
    call loc_000CD
    mov di, 0649h
    call loc_000CD
    mov di, 0669h
    call loc_000CD
    mov di, 0689h
    call loc_000CD
    mov di, 06A9h
    call loc_000CD
    cmp byte ptr ds:[0Dh], 0
    jne loc_000C0
    mov al, byte ptr ds:[0Ch]
    mov byte ptr ds:[0Dh], al
loc_000C0:
    mov byte ptr ds:[062h], 0
loc_000C5:
    pop ds
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
loc_000CD:
    cmp byte ptr ds:[05Fh], 0
    jne loc_000F6
    mov al, byte ptr ds:[di + 010h]
    or al, al
    je loc_000F6
    mov bx, word ptr ds:[di + 0Ch]
    cmp byte ptr ds:[0Dh], 0
    jne loc_000F0
    dec byte ptr ds:[di + 1]
    je loc_000F7
    call StepIndex13AndWriteA0B0
    call loc_002AA
loc_000F0:
    call loc_002C9
    call loc_002F6
loc_000F6:
    ret
loc_000F7:
    mov al, byte ptr ds:[bx]
    inc bx
    or al, al
    js loc_0011B
    mov byte ptr ds:[di], al
    mov ax, word ptr ds:[di + 8]
    call WriteOpl2Register
    call WriteRecordA0B0Pair
loc_00109:
loc_00109:
    mov word ptr ds:[di + 0Ch], bx
    mov al, byte ptr ds:[di + 011h]
    mov byte ptr ds:[di + 1], al
    ret
StreamCmd81:
    mov ax, word ptr ds:[di + 8]
    call WriteOpl2Register
    jmp short loc_00109
loc_0011B:
    cmp al, 0E0h
    jae loc_00135
    cmp al, 0A0h
    jae loc_00181
    cmp al, 08Dh
    jle loc_0012A
    jmp near ptr loc_00291
loc_0012A:
    shl al, 1
    xor ah, ah
    mov si, offset StreamCommandHandlers
    add si, ax
    jmp word ptr ds:[si]
loc_00135:
    sub al, 0DFh
    mov byte ptr ds:[di + 011h], al
    jmp short loc_000F7
StreamCmd88:
    mov al, byte ptr ds:[bx]
    inc bx
    mov byte ptr ds:[di + 0Eh], al
    push bx
    push si
    mov si, word ptr ds:[di + 2]
    mov bl, al
    xor bh, bh
    and bl, 07Fh
    mov ah, byte ptr ds:[bx + 06C9h]
    mov al, byte ptr ds:[si + 0Ch]
    shl al, 1
    shl al, 1
    and al, 0C0h
    or ah, al
    mov al, byte ptr ds:[di + 6]
    add al, 040h
    call WriteOpl2Register
    pop si
    pop bx
    jmp short loc_000F7
; No reference found: a copy of the 8Bh handler's tail for the other operator.
UnusedOperatorLevel:
    mov al, ds:[si + 0Ch]
    shl al, 1
    shl al, 1
    and al, 0C0h
    or ah, al
    mov al, ds:[di + 5]
    add al, 40h
    call WriteOpl2Register
    pop si
    pop bx
    jmp near ptr loc_000F7
loc_00181:
    sub al, 0A0h
    cmp al, byte ptr ds:[di + 4]
    jne loc_0018B
    jmp near ptr loc_000F7
loc_0018B:
    push bx
    mov byte ptr ds:[di + 4], al
    xor ah, ah
    shl al, 1
    shl al, 1
    shl ax, 1
    shl ax, 1
    mov si, 0869h
    add si, ax
    mov word ptr ds:[di + 2], si
    mov dx, word ptr ds:[di + 5]
    mov ah, byte ptr ds:[si]
    mov al, dl
    add al, 060h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 1]
    mov al, dh
    add al, 060h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 2]
    mov al, dl
    add al, 080h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 3]
    mov al, dh
    add al, 080h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 6]
    mov al, dl
    add al, 0E0h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 7]
    mov al, dh
    add al, 0E0h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 9]
    mov al, byte ptr ds:[di + 7]
    add al, 0C0h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 4]
    mov al, dl
    add al, 020h
    call WriteOpl2Register
    mov ah, byte ptr ds:[si + 5]
    mov al, dh
    add al, 020h
    call WriteOpl2Register
    mov bl, byte ptr ds:[si + 0Ah]
    and bx, 07Fh
    mov ah, byte ptr ds:[bx + 06C9h]
    mov al, byte ptr ds:[si + 0Ch]
    shl al, 1
    shl al, 1
    and al, 0C0h
    or ah, al
    mov al, dl
    add al, 040h
    call WriteOpl2Register
    mov bl, byte ptr ds:[si + 0Bh]
    mov byte ptr ds:[di + 0Eh], bl
    and bx, 07Fh
    mov ah, byte ptr ds:[bx + 06C9h]
    mov al, byte ptr ds:[si + 0Ch]
    ror al, 1
    ror al, 1
    and al, 0C0h
    or ah, al
    mov al, dh
    add al, 040h
    call WriteOpl2Register
    mov al, byte ptr ds:[si + 8]
    mov byte ptr ds:[di + 012h], al
    pop bx
    jmp near ptr loc_000F7
loc_00243:
    ret
; Load AL=byte DS:[DI+13h]. If zero, branch backward to shared RET0243, leaving AH unchanged and no
; writes/ports. Otherwise add byte[DI] modulo256, store it at[DI], and fall through into WriteRecordA0B0Pair.
; Inherits its outputs and hardware effects; must not insert an independent RET at024F.
StepIndex13AndWriteA0B0:
    mov al, byte ptr ds:[di + 013h]
    or al, al
    je loc_00243
    add al, byte ptr ds:[di]
    mov byte ptr ds:[di], al
; DS=driver,DI=record,DF=0. i=(byte[DI]+byte[DI+12h]) mod256; w=(word DS:[07A9+((2*i) mod256)]+word[DI+1Ah])
; mod65536; h=high(w) OR byte DS:[0749+i]. Store w at+14h. Write (byte[DI+7] OR A0h,low(w)), then cache word
; (h<<8)|(byte[DI+7] OR B0h) at+8 and write its high byte OR20h to the B0-derived register. Copy+1Dh to+1Eh and
; return that byte in AL; AH=h OR20h. BX,SI,CX,DX,DI,BP and segments preserved, flags changed; inherits hardware
; effects. No index/channel/range validation.
WriteRecordA0B0Pair:
    push bx
    push si
    mov al, byte ptr ds:[di]
    add al, byte ptr ds:[di + 012h]
    xor ah, ah
    mov si, ax
    mov bl, byte ptr ds:[si + 0749h]
    shl al, 1
    mov si, 07A9h
    add si, ax
    lodsw
    add ax, word ptr ds:[di + 01Ah]
    mov word ptr ds:[di + 014h], ax
    or ah, bl
    push ax
    mov ah, al
    mov al, byte ptr ds:[di + 7]
    or al, 0A0h
    call WriteOpl2Register
    pop ax
    mov al, byte ptr ds:[di + 7]
    or al, 0B0h
    mov word ptr ds:[di + 8], ax
    or ah, 020h
    call WriteOpl2Register
    mov al, byte ptr ds:[di + 01Dh]
    mov byte ptr ds:[di + 01Eh], al
    pop si
    pop bx
    ret
loc_00291:
loc_00291:
    mov di, 05A9h
    mov cx, 9
loc_00297:
    mov ax, word ptr ds:[di + 8]
    call WriteOpl2Register
    mov byte ptr ds:[di + 010h], ch
    add di, 020h
    loop loc_00297
    mov word ptr ds:[8], cx
    ret
loc_002AA:
    cmp byte ptr ds:[bx], 082h
    je loc_002C8
    mov si, word ptr ds:[di + 2]
    mov al, byte ptr ds:[si + 0Eh]
    or al, al
    je loc_002C8
    cmp al, byte ptr ds:[di + 1]
    jne loc_002C8
    mov ax, word ptr ds:[di + 8]
    call WriteOpl2Register
    mov byte ptr ds:[di + 013h], 0
loc_002C8:
    ret
loc_002C9:
    xor al, al
    cmp al, byte ptr ds:[di + 01Dh]
    je loc_00302
    cmp al, byte ptr ds:[di + 01Eh]
    je loc_00302
    dec byte ptr ds:[di + 01Eh]
    je loc_00302
    push cx
    mov cx, word ptr ds:[di + 8]
    and ch, 01Ch
    mov ax, word ptr ds:[di + 014h]
    add ax, word ptr ds:[di + 01Ch]
    and ah, 3
    cmp ax, 03ECh
    jg loc_0032C
    cmp ax, 01F6h
    jle loc_00325
    jmp short loc_00331
loc_002F6:
    xor al, al
    cmp al, byte ptr ds:[di + 018h]
    je loc_00303
    dec byte ptr ds:[di + 018h]
    je loc_00303
loc_00302:
    ret
loc_00303:
    cmp al, byte ptr ds:[di + 019h]
    je loc_00302
    dec byte ptr ds:[di + 019h]
    push cx
    mov cx, word ptr ds:[di + 8]
    and ch, 01Ch
    mov ax, word ptr ds:[di + 014h]
    add ax, word ptr ds:[di + 016h]
    and ah, 3
    cmp ax, 03ECh
    jg loc_0032C
    cmp ax, 01F6h
    jg loc_00331
loc_00325:
    shl ax, 1
    sub ch, 4
    jmp short loc_00331
loc_0032C:
    shr ax, 1
    add ch, 4
loc_00331:
    and ah, 3
    mov word ptr ds:[di + 014h], ax
    push ax
    mov ah, al
    mov al, byte ptr ds:[di + 7]
    add al, 0A0h
    call WriteOpl2Register
    pop ax
    or ah, ch
    mov al, byte ptr ds:[di + 7]
    add al, 0B0h
    mov word ptr ds:[di + 8], ax
    or ah, 020h
    call WriteOpl2Register
    pop cx
    ret
; Stream command handlers for bytes 80h..8Dh (index = byte - 80h).
StreamCommandHandlers label word
    dw offset StreamCmd80, offset StreamCmd81, offset loc_00109, offset loc_00291
    dw offset StreamCmd84, offset StreamCmd85, offset StreamCmd86, offset StreamCmd87
    dw offset StreamCmd88, offset StreamCmd89, offset StreamCmd8A, offset StreamCmd8B
    dw offset StreamCmd8C, offset StreamCmd8D
loc_00371:
    mov bx, word ptr ds:[bx]
    mov cx, word ptr ds:[bx]
    inc bx
    inc bx
    mov word ptr ds:[di + 0Ah], bx
    mov word ptr ds:[di + 0Ch], cx
    mov bx, cx
    jmp near ptr loc_000F7
StreamCmd80:
    mov al, byte ptr ds:[8]
    or al, al
    je loc_0038D
    mov byte ptr ds:[05Fh], al
    ret
loc_0038D:
    mov bx, word ptr ds:[di + 0Ah]
    mov cx, word ptr ds:[bx]
    inc bx
    inc bx
    jcxz loc_00371
    mov word ptr ds:[di + 0Ah], bx
    mov word ptr ds:[di + 0Ch], cx
    mov bx, cx
    jmp near ptr loc_000F7
StreamCmd84:
    mov al, byte ptr ds:[bx]
    inc bx
    mov byte ptr ds:[di + 012h], al
    jmp near ptr loc_000F7
StreamCmd85:
    mov ax, ds:[di + 8]
    call WriteOpl2Register
    xor al, al
    mov ds:[di + 10h], al
    ret
StreamCmd86:
    mov byte ptr ds:[di + 13h], 1
    jmp near ptr loc_000F7
StreamCmd87:
    mov byte ptr ds:[di + 13h], 0FFh
    jmp near ptr loc_000F7
StreamCmd8D:
    mov byte ptr ds:[di + 13h], 0
    jmp near ptr loc_000F7
StreamCmd89:
    mov bx, word ptr ds:[bx]
    mov al, byte ptr ds:[8]
    mov byte ptr ds:[05Fh], al
    jmp near ptr loc_000F7
StreamCmd8A:
    mov ax, ds:[bx]
    mov ds:[di + 16h], ax
    inc bx
    inc bx
    mov ax, ds:[bx]
    mov ds:[di + 18h], ax
    inc bx
    inc bx
    jmp near ptr loc_000F7
StreamCmd8B:
    mov ax, ds:[bx]
    mov ds:[di + 1Ah], ax
    inc bx
    inc bx
    mov ax, ds:[bx]
    mov ds:[di + 1Ch], ax
    inc bx
    inc bx
    mov al, ds:[bx]
    mov ds:[di + 1Dh], al
    inc bx
    jmp near ptr loc_000F7
StreamCmd8C:
    xor ax, ax
    mov ds:[di + 1Dh], al
    mov ds:[di + 1Ah], ax
    jmp near ptr loc_000F7
loc_00409:
    xor ah, ah
    cmp ah, byte ptr ds:[9]
    jne loc_00417
    mov al, byte ptr ds:[8]
    mov byte ptr ds:[05Fh], al
loc_00417:
    mov al, byte ptr ds:[05Fh]
    cmp al, ah
    jne loc_00421
    jmp near ptr loc_004A3
loc_00421:
    mov byte ptr ds:[8], ah
    mov byte ptr ds:[05Fh], ah
    cmp al, 0Ah
    jbe loc_00430
    jmp near ptr loc_00291
loc_00430:
    push ax
    call WriteOpl2Table04B1
    mov di, 05A9h
    mov cx, 9
loc_0043A:
    mov ax, word ptr ds:[di + 8]
    call WriteOpl2Register
    mov byte ptr ds:[di + 010h], ch
    add di, 020h
    loop loc_0043A
    pop ax
    mov byte ptr ds:[9], al
    shl al, 1
    mov si, 0947h
    add si, ax
    lodsw
    mov si, ax
    lodsb
    mov byte ptr ds:[0Ch], al
    lodsb
    mov cl, al
    xor ch, ch
    mov word ptr ds:[060h], cx
    mov dx, 01FFh
    mov byte ptr ds:[0Dh], dh
    mov di, 05A9h
loc_0046D:
    lodsw
    mov bx, ax
    mov ax, word ptr ds:[bx]
    inc bx
    inc bx
    mov word ptr ds:[di + 0Ah], bx
    mov word ptr ds:[di + 0Ch], ax
    mov byte ptr ds:[di + 013h], ch
    mov byte ptr ds:[di + 019h], ch
    mov byte ptr ds:[di + 01Dh], ch
    mov byte ptr ds:[di + 01Ah], ch
    mov byte ptr ds:[di + 01Bh], ch
    mov byte ptr ds:[di + 1], dh
    mov byte ptr ds:[di + 010h], dh
    mov byte ptr ds:[di + 4], dl
    add di, 020h
    loop loc_0046D
    mov ax, 0BDh
    call WriteOpl2Register
    mov ax, 8
    call WriteOpl2Register
loc_004A3:
    ret
; DS must address driver; DF=0. Write first word at04B1 unconditionally using AL=index,AH=data; then read words
; and stop on zero before writing it. Original table has27 pairs plus zero terminator. Returns AX=0,SI=04E9;
; other general/segment registers preserved. Flags from OR AX,AX. Inherits PIT/port61 effects from
; WriteOpl2Register.
WriteOpl2Table04B1:
    mov si, Opl2Table04B1
    lodsw
loc_004A8:
    call WriteOpl2Register
    lodsw
    or ax, ax
    jne loc_004A8
    ret
; Reviewed register/data pairs, not reconstructed instructions.
; Exact original5Dh andB9h entries intentionally preserved; purpose not inferred.
    dw 07F40h ; OPL2 register 40h, value 7Fh
    dw 07F41h ; OPL2 register 41h, value 7Fh
    dw 07F42h ; OPL2 register 42h, value 7Fh
    dw 07F43h ; OPL2 register 43h, value 7Fh
    dw 07F44h ; OPL2 register 44h, value 7Fh
    dw 07F45h ; OPL2 register 45h, value 7Fh
    dw 07F48h ; OPL2 register 48h, value 7Fh
    dw 07F49h ; OPL2 register 49h, value 7Fh
    dw 07F4Ah ; OPL2 register 4Ah, value 7Fh
    dw 07F4Bh ; OPL2 register 4Bh, value 7Fh
    dw 07F4Ch ; OPL2 register 4Ch, value 7Fh
    dw 07F5Dh ; OPL2 register 5Dh, value 7Fh
    dw 07F50h ; OPL2 register 50h, value 7Fh
    dw 07F51h ; OPL2 register 51h, value 7Fh
    dw 07F52h ; OPL2 register 52h, value 7Fh
    dw 07F53h ; OPL2 register 53h, value 7Fh
    dw 07F54h ; OPL2 register 54h, value 7Fh
    dw 07F55h ; OPL2 register 55h, value 7Fh
    dw 000B0h ; OPL2 register B0h, value 00h
    dw 000B1h ; OPL2 register B1h, value 00h
    dw 000B2h ; OPL2 register B2h, value 00h
    dw 000B3h ; OPL2 register B3h, value 00h
    dw 000B4h ; OPL2 register B4h, value 00h
    dw 000B6h ; OPL2 register B6h, value 00h
    dw 000B7h ; OPL2 register B7h, value 00h
    dw 000B8h ; OPL2 register B8h, value 00h
    dw 000B9h ; OPL2 register B9h, value 00h
    dw 00000h ; zero terminator (checked after first pair)
loc_004E9:
    push bx
    push cx
    push dx
    push ds
    push cs
    pop ds
    mov dx, word ptr ds:[Opl2BasePortWord]
    mov ax, 1
    call WriteOpl2Register
    mov ax, 06004h
    call WriteOpl2Register
    mov cx, 01000h
loc_00502:
    loop loc_00502
    mov ax, 08004h
    call WriteOpl2Register
    mov cx, 01000h
loc_0050D:
    loop loc_0050D
    in al, dx
    push ax
    mov ax, 0FF02h
    call WriteOpl2Register
    mov ax, 02104h
    call WriteOpl2Register
    mov cx, 0FFFFh
loc_00520:
    loop loc_00520
    in al, dx
    push ax
    mov ax, 06004h
    call WriteOpl2Register
    mov ax, 08004h
    call WriteOpl2Register
    pop ax
    pop bx
    and al, 0E0h
    and bl, 0E0h
    jne loc_00550
    cmp al, 0C0h
    jne loc_00550
    mov ax, 02001h
    call WriteOpl2Register
    mov ax, 02104h
    call WriteOpl2Register
    mov al, 1
    pop ds
    pop dx
    pop cx
    pop bx
    ret
loc_00550:
    xor al, al
    pop ds
    pop dx
    pop cx
    pop bx
    ret
; AL register index, AH data, DS points to driver header. OUT base=DS:[000E],AL; call
; DelayViaPit2Counter(BX=1FFC); AL=AH; OUT base+1,AL; delay(BX=1FEC). Preserves BX/DX and other general/segment
; registers except AL, which returns equal to AH. FLAGS changed. Inherits PIT/port61 side effects and
; hardware-dependent termination.
WriteOpl2Register:
    push bx
    push dx
    mov dx, word ptr ds:[Opl2BasePortWord]
    out dx, al
    mov bx, 01FFCh
    call DelayViaPit2Counter
    mov al, ah
    inc dx
    out dx, al
    mov bx, 01FECh
    call DelayViaPit2Counter
    pop dx
    pop bx
    ret
; ReadOpl2Status: AL <- IN(DS:[000E]); preserves AH, DX and FLAGS.
    push dx
    mov dx, word ptr ds:[Opl2BasePortWord]
    in al, dx
    pop dx
    ret
; Preserve AX and all general/segment registers. BX is a signed comparison threshold; configure port43=B6, set
; port61 bits0/1, write1FFFh to port42 on the first iteration and the previous read counter word on each repeat,
; issue43=86 thenB6, read two bytes from42 and repeat while signed AX>BX. Finally read61 and clear bit0. Changes
; flags; does not restore PIT configuration or original port61 state. Termination depends on hardware responses;
; no exact-duration claim.
DelayViaPit2Counter:
    push ax
    mov al, 0B6h
    out 043h, al
    in al, 061h
    or al, 3
    out 061h, al
    mov ax, 01FFFh
loc_00587:
    out 042h, al
    mov al, ah
    out 042h, al
    mov al, 086h
    out 043h, al
    mov al, 0B6h
    out 043h, al
    in al, 042h
    mov ah, al
    in al, 042h
    xchg ah, al
    cmp ax, bx
    jg loc_00587
    in al, 061h
    and al, 0FEh
    out 061h, al
    pop ax
    ret
; ---- Player data -------------------------------------------------------------
; Nine voice records (ADV_* fields), one per OPL2 melodic channel, with their
; static channel/operator assignments; the rest is runtime state.
AdlibVoice0 db 00h,00h,00h,00h,00h,00h,03h,00h,0B0h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice1 db 00h,00h,00h,00h,00h,01h,04h,01h,0B1h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice2 db 00h,00h,00h,00h,00h,02h,05h,02h,0B2h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice3 db 00h,00h,00h,00h,00h,08h,0Bh,03h,0B3h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice4 db 00h,00h,00h,00h,00h,09h,0Ch,04h,0B4h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice5 db 00h,00h,00h,00h,00h,0Ah,0Dh,05h,0B5h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice6 db 00h,00h,00h,00h,00h,10h,13h,06h,0B6h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice7 db 00h,00h,00h,00h,00h,11h,14h,07h,0B7h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
AdlibVoice8 db 00h,00h,00h,00h,00h,12h,15h,08h,0B8h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; OPL total-level (attenuation) for volume 0..7Fh: 3Fh - volume / 2.
LevelToAttenuation db 3Fh,3Fh,3Eh,3Eh,3Dh,3Dh,3Ch,3Ch,3Bh,3Bh,3Ah,3Ah,39h,39h,38h,38h
    db 37h,37h,36h,36h,35h,35h,34h,34h,33h,33h,32h,32h,31h,31h,30h,30h
    db 2Fh,2Fh,2Eh,2Eh,2Dh,2Dh,2Ch,2Ch,2Bh,2Bh,2Ah,2Ah,29h,29h,28h,28h
    db 27h,27h,26h,26h,25h,25h,24h,24h,23h,23h,22h,22h,21h,21h,20h,20h
    db 1Fh,1Fh,1Eh,1Eh,1Dh,1Dh,1Ch,1Ch,1Bh,1Bh,1Ah,1Ah,19h,19h,18h,18h
    db 17h,17h,16h,16h,15h,15h,14h,14h,13h,13h,12h,12h,11h,11h,10h,10h
    db 0Fh,0Fh,0Eh,0Eh,0Dh,0Dh,0Ch,0Ch,0Bh,0Bh,0Ah,0Ah,09h,09h,08h,08h
    db 07h,07h,06h,06h,05h,05h,04h,04h,03h,03h,02h,02h,01h,01h,00h,00h
; Per note index 0..95: OPL block (octave) << 2, and the 10-bit F-number. Index =
; stream note + voice transpose; block 0 holds 19 notes, blocks 1..7 twelve each.
NoteBlock db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,08h
    db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Ch,0Ch,0Ch,0Ch,0Ch
    db 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,10h,10h,10h,10h,10h,10h,10h,10h,10h
    db 10h,10h,10h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,14h,18h
    db 18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,18h,1Ch,1Ch,1Ch,1Ch,1Ch
NoteFnum dw 0159h, 016Dh, 0183h, 019Ah, 01B2h, 01CCh, 01E7h, 0205h, 0223h, 0244h, 0267h, 028Bh
    dw 02B2h, 02DBh, 0306h, 0334h, 0365h, 0399h, 03CFh, 0205h, 0223h, 0244h, 0267h, 028Bh
    dw 02B2h, 02DBh, 0306h, 0334h, 0365h, 0399h, 03CFh, 0205h, 0223h, 0244h, 0267h, 028Bh
    dw 02B2h, 02DBh, 0306h, 0334h, 0365h, 0399h, 03CFh, 0205h, 0223h, 0244h, 0267h, 028Bh
    dw 02B2h, 02DBh, 0306h, 0334h, 0365h, 0399h, 03CFh, 0205h, 0223h, 0244h, 0267h, 028Bh
    dw 02B2h, 02DBh, 0306h, 0334h, 0365h, 0399h, 03CFh, 0205h, 0223h, 0244h, 0267h, 028Bh
    dw 02B2h, 02DBh, 0306h, 0334h, 0365h, 0399h, 03CFh, 0205h, 0223h, 0244h, 0267h, 028Bh
    dw 02B2h, 02DBh, 0306h, 0334h, 0365h, 0399h, 03CFh, 0205h, 0223h, 0244h, 0267h, 028Bh
; Instruments (16 bytes, ADI_* fields): operator registers 60h/80h/E0h/20h for
; modulator and carrier, C0h feedback/connection, volumes, transpose, KSL, early
; release. Used by stream bytes A0h + n.
Instrument0 db 0E8h,0E9h,07h,08h,00h,00h,01h,00h,0FDh,06h,7Fh,7Ch,00h,00h,00h,00h
Instrument1 db 0E5h,0F6h,06h,07h,00h,06h,02h,00h,0FCh,0Fh,7Fh,7Fh,00h,00h,00h,00h
Instrument2 db 0E4h,0F5h,06h,07h,00h,06h,02h,00h,02h,0Fh,7Fh,7Fh,00h,00h,00h,00h
Instrument3 db 0E9h,0B9h,06h,08h,0Fh,0Fh,02h,02h,30h,0Eh,7Ch,7Fh,00h,00h,00h,00h
Instrument4 db 0E9h,0E9h,05h,04h,01h,03h,01h,00h,00h,08h,6Eh,7Eh,00h,00h,00h,00h
Instrument5 db 93h,52h,0FEh,0FEh,20h,20h,03h,03h,0Ch,0Eh,4Eh,7Eh,00h,00h,00h,00h
Instrument6 db 93h,0E1h,88h,88h,64h,62h,00h,02h,0E8h,06h,7Fh,7Fh,00h,00h,00h,00h
Instrument7 db 0E7h,0F1h,11h,25h,0F1h,22h,00h,00h,0Ch,08h,7Ch,78h,00h,00h,00h,00h
Instrument8 db 77h,81h,13h,25h,0F1h,22h,00h,00h,0Ch,08h,7Ch,72h,00h,00h,00h,00h
Instrument9 db 0C3h,82h,88h,88h,21h,23h,02h,03h,0F4h,02h,7Fh,7Fh,00h,00h,00h,00h
Instrument10 db 0E1h,81h,01h,05h,0Fh,0Fh,02h,02h,24h,0Eh,7Bh,7Fh,00h,00h,00h,00h
Instrument11 db 0A2h,54h,0F8h,0F8h,60h,21h,03h,00h,0Ch,0Ah,68h,7Fh,00h,00h,00h,00h
Instrument12 db 0F5h,0F2h,0FEh,0FEh,20h,20h,03h,03h,18h,0Eh,4Eh,70h,00h,00h,00h,00h
Instrument13 db 82h,72h,11h,94h,62h,64h,02h,00h,0E8h,0Ch,64h,7Fh,00h,00h
; Tune headers by tune number (MUSIC_* in the game); entry 0 is never used and also
; supplies Instrument13's last two bytes (both zero).
TuneTable label word
    dw 0
    dw offset Tune1, offset Tune2, offset Tune3, offset Tune4, offset Tune5
    dw offset Tune6, offset Tune7, offset Tune8, offset Tune9, offset Tune10
; Tune 1: tempo 5 timer ticks per step, 9 voices, order list per voice.
Tune1 db 5, 9
    dw offset Tune1Order0, offset Tune1Order1, offset Tune1Order2, offset Tune1Order3
    dw offset Tune1Order4, offset Tune1Order5, offset Tune1Order6, offset Tune1Order7
    dw offset Tune1Order8
Tune1Order0 label word
    dw offset Tune1Pattern_0A19
Tune1OrderLoop_0973 label word
    dw offset Tune1Pattern_0A19
    dw offset Tune1Pattern_0A19
    dw offset Tune1Pattern_0A19
    dw offset Tune1Pattern_0A19
    dw offset Tune1Pattern_0A7C
    dw offset Tune1Pattern_0AAF
    dw 0, offset Tune1OrderLoop_0973
Tune1Order1 label word
    dw offset Tune1Pattern_0AE2
Tune1OrderLoop_0985 label word
    dw offset Tune1Pattern_0AE2
    dw offset Tune1Pattern_0AE2
    dw offset Tune1Pattern_0AE2
    dw offset Tune1Pattern_0AE2
    dw offset Tune1Pattern_0B12
    dw offset Tune1Pattern_0B2B
    dw 0, offset Tune1OrderLoop_0985
Tune1Order2 label word
    dw offset Tune1Pattern_0B43
Tune1OrderLoop_0997 label word
    dw offset Tune1Pattern_0B43
    dw offset Tune1Pattern_0B43
    dw offset Tune1Pattern_0B43
    dw offset Tune1Pattern_0B43
    dw offset Tune1Pattern_0B55
    dw offset Tune1Pattern_0B66
    dw 0, offset Tune1OrderLoop_0997
Tune1Order3 label word
    dw offset Tune1Pattern_0B77
    dw offset Tune1Pattern_0B78
Tune1OrderLoop_09AB label word
    dw offset Tune1Pattern_0B78
    dw offset Tune1Pattern_0B78
    dw offset Tune1Pattern_0BAA
    dw offset Tune1Pattern_0B77
    dw offset Tune1Pattern_0B78
    dw offset Tune1Pattern_0BAA
    dw offset Tune1Pattern_0C0C
    dw offset Tune1Pattern_0C3E
    dw 0, offset Tune1OrderLoop_09AB
Tune1Order4 label word
    dw offset Tune1Pattern_0C4E
Tune1OrderLoop_09C1 label word
    dw offset Tune1Pattern_0C4E
    dw offset Tune1Pattern_0C59
    dw offset Tune1Pattern_0C4E
    dw offset Tune1Pattern_0C59
    dw offset Tune1Pattern_0C63
    dw offset Tune1Pattern_0C6C
    dw 0, offset Tune1OrderLoop_09C1
Tune1Order5 label word
    dw offset Tune1Pattern_0C7D
Tune1OrderLoop_09D3 label word
    dw offset Tune1Pattern_0C7D
    dw offset Tune1Pattern_0C88
    dw offset Tune1Pattern_0C7D
    dw offset Tune1Pattern_0C88
    dw offset Tune1Pattern_0C92
    dw offset Tune1Pattern_0C9B
    dw 0, offset Tune1OrderLoop_09D3
Tune1Order6 label word
    dw offset Tune1Pattern_0CAC
Tune1OrderLoop_09E5 label word
    dw offset Tune1Pattern_0CAC
    dw offset Tune1Pattern_0CD4
    dw offset Tune1Pattern_0CAC
    dw offset Tune1Pattern_0CD4
    dw offset RestPattern4
    dw offset Tune1Pattern_0D0D
    dw 0, offset Tune1OrderLoop_09E5
Tune1Order7 label word
    dw offset RestPattern8
Tune1OrderLoop_09F7 label word
    dw offset Tune1Pattern_0D1E
    dw offset Tune1Pattern_0D69
    dw offset Tune1Pattern_0D87
    dw offset Tune1Pattern_0D69
    dw offset Tune1Pattern_0DF2
    dw offset Tune1Pattern_0E06
    dw 0, offset Tune1OrderLoop_09F7
Tune1Order8 label word
    dw offset RestPattern8
Tune1OrderLoop_0A09 label word
    dw offset Tune1Pattern_0E19
    dw offset Tune1Pattern_0E6A
    dw offset Tune1Pattern_0E75
    dw offset Tune1Pattern_0E6A
    dw offset Tune1Pattern_0EE4
    dw offset Tune1Pattern_0EED
    dw 0, offset Tune1OrderLoop_0A09
Tune1Pattern_0A19 label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 4, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, ADL_END_PATTERN
Tune1Pattern_0A7C label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 4, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, ADL_END_PATTERN
Tune1Pattern_0AAF label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 2, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 2, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 2, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6, 0Eh
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 2, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh
    db 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 22, ADL_REST, ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 6
    db ADL_INSTRUMENT + 1, 0Eh, ADL_END_PATTERN
Tune1Pattern_0AE2 label byte
    db ADL_LENGTH + 6, ADL_REST, ADL_INSTRUMENT + 2, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_LENGTH + 6
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, ADL_LENGTH + 4, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune1Pattern_0B12 label byte
    db ADL_LENGTH + 6, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_LENGTH + 4, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_END_PATTERN
Tune1Pattern_0B2B label byte
    db ADL_LENGTH + 6, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh
    db 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 24, ADL_REST, ADL_LENGTH + 6, 0Eh, ADL_END_PATTERN
Tune1Pattern_0B43 label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 6, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, 12h, ADL_REST, ADL_REST
Tune1Pattern_0B55 label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, ADL_REST, ADL_REST, ADL_END_PATTERN
Tune1Pattern_0B66 label byte
    db ADL_LENGTH + 6, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, ADL_LENGTH + 24, ADL_REST, ADL_LENGTH + 6
    db 12h, 12h, 12h, 12h, ADL_END_PATTERN
Tune1Pattern_0B77 label byte
    db ADL_INSTRUMENT + 4
Tune1Pattern_0B78 label byte
    db ADL_LENGTH + 2, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, ADL_END_PATTERN
Tune1Pattern_0BAA label byte
    db ADL_LENGTH + 2, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 07h, 07h, 07h, 07h, 0Eh, 13h, 07h, 07h, 07h, 07h, 0Eh
    db 13h, 06h, 06h, 06h, 06h, 0Eh, 12h, 06h, 06h, 06h, 06h, 0Eh
    db 12h, ADL_END_PATTERN
Tune1Pattern_0C0C label byte
    db ADL_LENGTH + 2, 09h, 09h, 09h, 09h, 10h, 15h, 09h, 09h, 09h, 09h, 10h
    db 15h, 0Bh, 0Bh, 0Bh, 0Bh, 12h, 17h, 0Bh, 0Bh, 0Bh, 0Bh, 12h
    db 17h, 0Dh, 0Dh, 0Dh, 0Dh, 14h, 19h, 0Eh, 0Eh, 0Eh, 0Eh, 15h
    db 1Ah, 10h, 10h, 10h, 10h, 17h, 1Ch, 12h, 12h, 12h, 12h, 1Eh
    db ADL_TIE, ADL_END_PATTERN
Tune1Pattern_0C3E label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_LENGTH + 2, 17h, 15h, 12h, 10h, 12h, 10h, ADL_LENGTH + 4, 0Eh
    db 0Bh, ADL_LENGTH + 28, ADL_REST, ADL_END_PATTERN
Tune1Pattern_0C4E label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 26h, 28h, 2Ah, ADL_TIE, 26h, 28h, 2Ah, ADL_TIE, ADL_END_PATTERN
Tune1Pattern_0C59 label byte
    db ADL_LENGTH + 24, 25h, ADL_TIE, 26h, ADL_TIE, 25h, ADL_TIE, 2Bh, 2Ah, ADL_END_PATTERN
Tune1Pattern_0C63 label byte
    db ADL_LENGTH + 24, 25h, 26h, ADL_LENGTH + 12, 28h, 2Ah, 2Dh, 2Fh, ADL_END_PATTERN
Tune1Pattern_0C6C label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_INSTRUMENT + 7, ADL_LENGTH + 2, 2Fh, 2Dh, 2Ah, 28h, 2Ah, 28h, ADL_LENGTH + 4
    db 26h, 23h, ADL_LENGTH + 28, ADL_REST, ADL_END_PATTERN
Tune1Pattern_0C7D label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 21h, 23h, 23h, ADL_TIE, 21h, 23h, 23h, ADL_TIE, ADL_END_PATTERN
Tune1Pattern_0C88 label byte
    db ADL_LENGTH + 24, 23h, ADL_TIE, 23h, ADL_TIE, 23h, ADL_TIE, 26h, 26h, ADL_END_PATTERN
Tune1Pattern_0C92 label byte
    db ADL_LENGTH + 24, 23h, 23h, ADL_LENGTH + 12, 25h, 26h, 28h, 2Ah, ADL_END_PATTERN
Tune1Pattern_0C9B label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_INSTRUMENT + 6, ADL_REST, ADL_LENGTH + 2, 2Fh, 2Dh, 2Ah, 28h, 2Ah, 28h, ADL_LENGTH + 4
    db 26h, 23h, ADL_LENGTH + 28, ADL_REST, ADL_END_PATTERN
Tune1Pattern_0CAC label byte
    db ADL_LENGTH + 30, ADL_REST, ADL_LENGTH + 20, ADL_REST, ADL_REST, ADL_INSTRUMENT + 6, ADL_LENGTH + 2, 23h, 28h, 2Ah, 2Dh, 2Ah
    db 2Dh, 2Fh, 2Dh, 2Fh, 32h, 2Fh, 32h, 34h, ADL_LENGTH + 30, ADL_REST, ADL_LENGTH + 20, ADL_REST
    db ADL_REST, ADL_LENGTH + 2, 23h, 28h, 2Ah, 2Dh, 2Ah, 2Dh, 2Fh, 2Dh, 2Fh, 32h
    db 2Fh, 32h, 34h, ADL_END_PATTERN
Tune1Pattern_0CD4 label byte
    db ADL_LENGTH + 2, 40h, 3Eh, 3Bh, 3Eh, 3Bh, 39h, 3Bh, 39h, 36h, 39h, 36h
    db 2Fh, 34h, 32h, 2Fh, 32h, 2Fh, 2Dh, 2Fh, 2Dh, 2Ah, 2Dh, 2Ah
    db 28h, ADL_LENGTH + 24, 26h, ADL_TIE, ADL_LENGTH + 2, 40h, 3Eh, 3Bh, 3Eh, 3Bh, 39h, 3Bh
    db 39h, 36h, 39h, 36h, 2Fh, 34h, 32h, 2Fh, 32h, 2Fh, 2Dh, 2Fh
    db 2Dh, 2Ah, 2Dh, 2Ah, 28h, ADL_LENGTH + 24, 2Bh, 2Ah, ADL_END_PATTERN
Tune1Pattern_0D0D label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_INSTRUMENT + 7, ADL_LENGTH + 2, 3Bh, 39h, 36h, 34h, 36h, 34h, ADL_LENGTH + 4
    db 32h, 2Fh, ADL_LENGTH + 28, ADL_REST, ADL_END_PATTERN
Tune1Pattern_0D1E label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 2, 39h, 36h, 32h, 34h, 2Fh, 32h, ADL_INSTRUMENT + 8, ADL_LENGTH + 8, 36h, ADL_LENGTH + 2
    db 2Fh, 32h, 36h, 34h, ADL_LENGTH + 20, 39h, ADL_LENGTH + 2, 36h, 34h, 32h, 36h, 32h
    db 2Fh, 34h, 2Fh, 2Ah, 2Fh, 2Ah, 28h, ADL_LENGTH + 24, ADL_BEND
    dw 0FFFCh
    db 2Dh, 1Fh, 32h, ADL_LENGTH + 2, 39h, 36h, 32h, 34h, 36h, 34h, ADL_LENGTH + 8, 32h
    db ADL_LENGTH + 2, 2Fh, 32h, 36h, 39h, ADL_LENGTH + 20, 34h, ADL_LENGTH + 2, 36h, 34h, 32h, 36h
    db 32h, 2Fh, 34h, 2Fh, 2Ah, 2Fh, 2Ah, 28h, ADL_LENGTH + 24, ADL_BEND
    dw 0FFFCh
    db 2Dh, 1Fh, 32h, ADL_END_PATTERN
Tune1Pattern_0D69 label byte
    db ADL_INSTRUMENT + 9, ADL_LENGTH + 9, 21h, 23h, ADL_LENGTH + 6, 25h, ADL_LENGTH + 9, 21h, 23h, ADL_LENGTH + 6, 25h, ADL_LENGTH + 9
    db 23h, 25h, ADL_LENGTH + 30, 26h, ADL_LENGTH + 9, 25h, 26h, ADL_LENGTH + 6, 28h, ADL_LENGTH + 9, 25h, 26h
    db ADL_LENGTH + 6, 28h, ADL_LENGTH + 24, 2Bh, 2Ah, ADL_END_PATTERN
Tune1Pattern_0D87 label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 2, 39h, 36h, 2Fh, 32h, 34h, 36h, ADL_INSTRUMENT + 8, ADL_LENGTH + 12, 39h, ADL_LENGTH + 2
    db 3Bh, 39h, 36h, ADL_LENGTH + 18, 34h, ADL_LENGTH + 2, 39h, 36h, 34h, 36h, 34h, 32h
    db 34h, 32h, 2Fh, 32h, 2Fh, 2Dh, ADL_LENGTH + 24, ADL_BEND
    dw 0FFFCh
    db 2Dh, 1Fh, 32h, ADL_LENGTH + 2, 34h, 31h, 2Fh, 32h, 31h, 2Dh, 34h, 31h
    db 2Fh, 32h, 31h, 2Dh, 36h, 32h, 2Fh, 34h, 32h, 31h, 39h, 36h
    db 32h, 34h, 32h, 2Fh, ADL_BEND
    dw 0018h
    db 00h, 05h, 2Fh, 34h, 32h, 2Fh, 34h, 32h, ADL_BEND
    dw 0018h
    db 00h, 05h, 2Fh, 34h, 32h, 2Fh, 34h, 32h, ADL_BEND
    dw 0018h
    db 00h, 05h, 3Bh, 39h, 32h, 2Fh, 39h, 32h, ADL_BEND
    dw 0018h
    db 00h, 05h, 3Bh, 39h, 32h, 2Fh, 39h, 32h, ADL_END_PATTERN
Tune1Pattern_0DF2 label byte
    db ADL_INSTRUMENT + 9, ADL_LENGTH + 9, 21h, 23h, ADL_LENGTH + 6, 25h, ADL_LENGTH + 9, 23h, 25h, ADL_LENGTH + 6, 26h, 25h
    db 28h, 26h, 2Ah, 28h, 2Dh, 2Ah, 2Fh, ADL_END_PATTERN
Tune1Pattern_0E06 label byte
    db ADL_LENGTH + 25, ADL_REST, ADL_REST, ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 2, 2Fh, 2Dh, 2Ah, 28h, 2Ah
    db 28h, ADL_LENGTH + 4, 26h, 23h, ADL_LENGTH + 26, ADL_REST, ADL_END_PATTERN
Tune1Pattern_0E19 label byte
    db ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 2, ADL_REST, ADL_LENGTH + 2, 39h, 36h, 32h, 34h, 2Fh, 32h
    db ADL_INSTRUMENT + 8, ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 8, 36h, ADL_LENGTH + 2, 2Fh, 32h, 36h, 34h, ADL_LENGTH + 20, 39h
    db ADL_LENGTH + 2, 36h, 34h, 32h, 36h, 32h, 2Fh, 34h, 2Fh, 2Ah, 2Fh, 2Ah
    db 28h, ADL_LENGTH + 24, ADL_BEND
    dw 0FFFCh
    db 2Dh, 1Fh, 32h, ADL_LENGTH + 2, 39h, 36h, 32h, 34h, 36h, 34h, ADL_LENGTH + 8, 32h
    db ADL_LENGTH + 2, 2Fh, 32h, 36h, 39h, ADL_LENGTH + 20, 34h, ADL_LENGTH + 2, 36h, 34h, 32h, 36h
    db 32h, 2Fh, 34h, 2Fh, 2Ah, 2Fh, 2Ah, 28h, ADL_LENGTH + 22, ADL_BEND
    dw 0FFFCh
    db 2Dh, 1Fh, 32h, ADL_END_PATTERN
Tune1Pattern_0E6A label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 21h, ADL_TIE, 1Fh, ADL_TIE, 21h, ADL_TIE, 21h, 21h, ADL_END_PATTERN
Tune1Pattern_0E75 label byte
    db ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 2, ADL_REST, 39h, 36h, 2Fh, 32h, 34h, 36h, ADL_INSTRUMENT + 8
    db ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 12, 39h, ADL_LENGTH + 2, 3Bh, 39h, 36h, ADL_LENGTH + 18, 34h, ADL_LENGTH + 2, 39h
    db 36h, 34h, 36h, 34h, 32h, 34h, 32h, 2Fh, 32h, 23h, 2Dh, ADL_LENGTH + 24
    db ADL_BEND
    dw 0FFFCh
    db 2Dh, 1Fh, 32h, ADL_LENGTH + 2, 34h, 31h, 2Fh, 32h, 31h, 2Dh, 34h, 31h
    db 2Fh, 32h, 31h, 2Dh, 36h, 32h, 2Fh, 34h, 32h, 31h, 39h, 36h
    db 32h, 34h, 32h, 2Fh, ADL_BEND
    dw 0018h
    db 00h, 05h, 2Fh, 34h, 32h, 2Fh, 34h, 32h, ADL_BEND
    dw 0018h
    db 00h, 05h, 2Fh, 34h, 32h, 2Fh, 34h, 32h, ADL_BEND
    dw 0018h
    db 00h, 05h, 3Bh, 34h, 32h, 2Fh, 34h, 32h, ADL_BEND
    dw 0018h
    db 00h, 05h, 3Bh, 34h, 32h, 2Fh, 34h, ADL_END_PATTERN
Tune1Pattern_0EE4 label byte
    db ADL_LENGTH + 24, 21h, 21h, ADL_LENGTH + 12, 21h, 21h, 25h, 23h, ADL_END_PATTERN
Tune1Pattern_0EED label byte
    db ADL_LENGTH + 25, ADL_REST, ADL_REST, ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 2, 3Bh, 39h, 36h, 34h, 36h
    db 34h, ADL_LENGTH + 4, 32h, 2Fh, ADL_LENGTH + 26, ADL_REST, ADL_END_PATTERN
; Tune 2: tempo 6 timer ticks per step, 9 voices, order list per voice.
Tune2 db 6, 9
    dw offset Tune2Order0, offset Tune2Order1, offset Tune2Order2, offset Tune2Order3
    dw offset Tune2Order4, offset Tune2Order5, offset Tune2Order6, offset Tune2Order7
    dw offset Tune2Order8
Tune2Order0 label word
    dw offset Tune2Pattern_0F92
    dw offset Tune2Pattern_108F
    dw offset Tune2Pattern_1186
    dw offset Tune2Pattern_1186
    dw offset Tune2Pattern_1186
    dw offset Tune2Pattern_1186
    dw 0, offset Tune2Order0
Tune2Order1 label word
    dw offset Tune2Pattern_11D8
    dw offset Tune2Pattern_129A
    dw offset Tune2Pattern_135B
    dw offset Tune2Pattern_135B
    dw offset Tune2Pattern_135B
    dw offset Tune2Pattern_135B
    dw 0, offset Tune2Order1
Tune2Order2 label word
    dw offset Tune2Pattern_138D
    dw offset Tune2Pattern_138D
    dw offset Tune2Pattern_138D
    dw offset Tune2Pattern_138D
    dw offset Tune2Pattern_1437
    dw offset Tune2Pattern_1437
    dw offset Tune2Pattern_1437
    dw offset Tune2Pattern_1437
    dw 0, offset Tune2Order2
Tune2Order3 label word
    dw offset Tune2Pattern_147A
    dw offset Tune2Pattern_1527
    dw offset Tune2Pattern_15D6
    dw offset Tune2Pattern_15D6
    dw offset Tune2Pattern_15D6
    dw offset Tune2Pattern_15D6
    dw 0, offset Tune2Order3
Tune2Order4 label word
    dw offset Tune2Pattern_1608
    dw offset Tune2Pattern_1626
    dw offset Tune2Pattern_164B
    dw offset Tune2Pattern_164B
    dw 0, offset Tune2Order4
Tune2Order5 label word
    dw offset Tune2Pattern_1655
    dw offset Tune2Pattern_1673
    dw offset Tune2Pattern_1698
    dw offset Tune2Pattern_1698
    dw 0, offset Tune2Order5
Tune2Order6 label word
    dw offset Tune2Pattern_16A2
    dw offset Tune2Pattern_16C0
    dw offset Tune2Pattern_16E5
    dw offset Tune2Pattern_16E5
    dw 0, offset Tune2Order6
Tune2Order7 label word
    dw offset Tune2Pattern_16EF
    dw offset Tune2Pattern_170D
    dw offset Tune2Pattern_1732
    dw offset Tune2Pattern_1732
    dw 0, offset Tune2Order7
Tune2Order8 label word
    dw offset Tune2Pattern_173C
    dw offset Tune2Pattern_17C6
    dw offset Tune2Pattern_1864
    dw 0, offset Tune2Order8
Tune2Pattern_0F92 label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch
    db 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh
    db ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch
    db 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh
    db ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch
    db 0Ch, ADL_REST, ADL_REST, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_END_PATTERN
Tune2Pattern_108F label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch
    db 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh
    db ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, ADL_INSTRUMENT + 0, 0Ch
    db 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, ADL_REST, 0Eh, 0Eh, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, 0Eh
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune2Pattern_1186 label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1
    db 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune2Pattern_11D8 label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 2, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db 0Eh, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 2, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, ADL_END_PATTERN
Tune2Pattern_129A label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, 0Eh
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, ADL_REST, ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 2, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh
    db 0Eh, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, 0Eh, 0Eh, ADL_REST, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_END_PATTERN
Tune2Pattern_135B label byte
    db ADL_LENGTH + 2, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh, 0Eh
    db 0Eh, ADL_END_PATTERN
Tune2Pattern_138D label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 3, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h
    db 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 3, 12h
    db 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_INSTRUMENT + 10
    db 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 3, 12h, 12h, ADL_INSTRUMENT + 10, 16h
    db ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h
    db ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 3, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10
    db 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3
    db 12h, ADL_INSTRUMENT + 3, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h
    db 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 3, 12h
    db 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_INSTRUMENT + 10
    db 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 3, 12h, 12h, ADL_INSTRUMENT + 10, 16h
    db ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h
    db ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 3, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10
    db 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3
    db 12h, ADL_END_PATTERN
Tune2Pattern_1437 label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 3, 12h, 12h, ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h
    db ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h
    db ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h
    db ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h
    db ADL_INSTRUMENT + 3, 12h, 12h, 12h, ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, 12h, 12h
    db ADL_REST, 12h, ADL_INSTRUMENT + 10, 16h, ADL_INSTRUMENT + 3, 12h, ADL_END_PATTERN
Tune2Pattern_147A label byte
    db ADL_INSTRUMENT + 4, ADL_LENGTH + 2, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh
    db 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh
    db 13h, 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h
    db 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h
    db 18h, 1Ah, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh
    db 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh
    db 13h, 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h
    db 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h
    db 18h, 1Ah, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh
    db 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh
    db 12h, 13h, ADL_LENGTH + 3, 15h, ADL_REST, ADL_LENGTH + 2, 09h, ADL_REST, ADL_LENGTH + 6, 15h, ADL_LENGTH + 32, ADL_REST
    db ADL_LENGTH + 2, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h
    db 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h
    db 13h, 15h, ADL_TIE, ADL_REST, 09h, ADL_REST, ADL_LENGTH + 6, 15h, ADL_LENGTH + 22, ADL_REST, ADL_LENGTH + 2, 09h
    db 0Bh, 0Ch, 0Dh, 0Eh, ADL_END_PATTERN
Tune2Pattern_1527 label byte
    db ADL_LENGTH + 2, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 0Eh, 0Eh, 09h, 0Eh, 13h, 15h, 0Eh, 0Eh, 09h, 0Eh, 13h
    db 15h, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 13h, 13h, 0Eh, 13h, 18h, 1Ah, 13h, 13h, 0Eh, 13h, 18h
    db 1Ah, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h
    db 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h
    db 13h, ADL_LENGTH + 3, 15h, ADL_REST, ADL_LENGTH + 2, 09h, ADL_REST, ADL_LENGTH + 6, 15h, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 2
    db 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h
    db 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h, 0Eh, 0Eh, 0Bh, 0Eh, 12h, 13h
    db ADL_LENGTH + 6, 15h, ADL_LENGTH + 4, 12h, ADL_LENGTH + 6, 13h, ADL_LENGTH + 2, 15h, ADL_LENGTH + 6, 17h, ADL_LENGTH + 4, 1Ah
    db ADL_LENGTH + 6, 1Ch, ADL_LENGTH + 2, 1Eh, ADL_LENGTH + 12, 1Fh, ADL_END_PATTERN
Tune2Pattern_15D6 label byte
    db ADL_LENGTH + 2, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h
    db 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h, 13h, 07h
    db 13h, 09h, 15h, 09h, 15h, 09h, 15h, 09h, 15h, 09h, 15h, 09h
    db 15h, 04h, 10h, 04h, 10h, 04h, 10h, 04h, 10h, 04h, 10h, 04h
    db 10h, ADL_END_PATTERN
Tune2Pattern_1608 label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 2Dh, ADL_TIE, 2Fh, ADL_TIE, 2Dh, ADL_TIE, 2Fh, ADL_TIE, 2Dh, ADL_TIE
    db ADL_LENGTH + 4, 2Bh, ADL_LENGTH + 6, ADL_REST, 2Bh, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 2Dh, ADL_TIE, ADL_LENGTH + 4, 2Bh
    db ADL_LENGTH + 6, ADL_REST, 2Bh, ADL_LENGTH + 32, ADL_REST, ADL_END_PATTERN
Tune2Pattern_1626 label byte
    db ADL_LENGTH + 24, 2Dh, ADL_TIE, 2Fh, ADL_TIE, 2Dh, ADL_TIE, 2Fh, ADL_TIE, 2Dh, ADL_TIE, ADL_LENGTH + 4
    db 2Bh, ADL_LENGTH + 6, ADL_REST, 2Bh, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 2Dh, ADL_TIE, ADL_LENGTH + 4, 2Bh, ADL_LENGTH + 6
    db ADL_REST, 2Bh, ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 4, 2Bh, ADL_LENGTH + 6, ADL_REST, ADL_LENGTH + 8, 2Bh, ADL_LENGTH + 6, ADL_REST
    db ADL_END_PATTERN
Tune2Pattern_164B label byte
    db ADL_LENGTH + 24, 2Ah, ADL_TIE, 28h, 26h, 2Ah, ADL_TIE, 28h, 26h, ADL_END_PATTERN
Tune2Pattern_1655 label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 2Ah, ADL_TIE, 2Bh, ADL_TIE, 2Ah, ADL_TIE, 2Bh, ADL_TIE, 2Ah, ADL_TIE
    db ADL_LENGTH + 4, 28h, ADL_LENGTH + 6, ADL_REST, 28h, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 2Ah, ADL_TIE, ADL_LENGTH + 4, 28h
    db ADL_LENGTH + 6, ADL_REST, 28h, ADL_LENGTH + 32, ADL_REST, ADL_END_PATTERN
Tune2Pattern_1673 label byte
    db ADL_LENGTH + 24, 2Ah, ADL_TIE, 2Bh, ADL_TIE, 2Ah, ADL_TIE, 2Bh, ADL_TIE, 2Ah, ADL_TIE, ADL_LENGTH + 4
    db 28h, ADL_LENGTH + 6, ADL_REST, 28h, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 2Ah, ADL_TIE, ADL_LENGTH + 4, 28h, ADL_LENGTH + 6
    db ADL_REST, 28h, ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 4, 28h, ADL_LENGTH + 6, ADL_REST, ADL_LENGTH + 8, 28h, ADL_LENGTH + 6, ADL_REST
    db ADL_END_PATTERN
Tune2Pattern_1698 label byte
    db ADL_LENGTH + 24, 26h, ADL_TIE, 24h, 23h, 26h, ADL_TIE, 24h, 23h, ADL_END_PATTERN
Tune2Pattern_16A2 label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 28h, ADL_TIE, 28h, ADL_TIE, 28h, ADL_TIE, 28h, ADL_TIE, 26h, ADL_TIE
    db ADL_LENGTH + 4, 24h, ADL_LENGTH + 6, ADL_REST, 24h, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 26h, ADL_TIE, ADL_LENGTH + 4, 24h
    db ADL_LENGTH + 6, ADL_REST, 24h, ADL_LENGTH + 32, ADL_REST, ADL_END_PATTERN
Tune2Pattern_16C0 label byte
    db ADL_LENGTH + 24, 28h, ADL_TIE, 28h, ADL_TIE, 28h, ADL_TIE, 28h, ADL_TIE, 26h, ADL_TIE, ADL_LENGTH + 4
    db 24h, ADL_LENGTH + 6, ADL_REST, 24h, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 26h, ADL_TIE, ADL_LENGTH + 4, 24h, ADL_LENGTH + 6
    db ADL_REST, 24h, ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 4, 24h, ADL_LENGTH + 6, ADL_REST, ADL_LENGTH + 8, 24h, ADL_LENGTH + 6, ADL_REST
    db ADL_END_PATTERN
Tune2Pattern_16E5 label byte
    db ADL_LENGTH + 24, 23h, ADL_TIE, 21h, 1Fh, 23h, ADL_TIE, 21h, 1Fh, ADL_END_PATTERN
Tune2Pattern_16EF label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 26h, ADL_TIE, 24h, ADL_TIE, 26h, ADL_TIE, 24h, ADL_TIE, 23h, ADL_TIE
    db ADL_LENGTH + 4, 21h, ADL_LENGTH + 6, ADL_REST, 21h, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 23h, ADL_TIE, ADL_LENGTH + 4, 21h
    db ADL_LENGTH + 6, ADL_REST, 21h, ADL_LENGTH + 32, ADL_REST, ADL_END_PATTERN
Tune2Pattern_170D label byte
    db ADL_LENGTH + 24, 26h, ADL_TIE, 24h, ADL_TIE, 26h, ADL_TIE, 24h, ADL_TIE, 23h, ADL_TIE, ADL_LENGTH + 4
    db 21h, ADL_LENGTH + 6, ADL_REST, 21h, ADL_LENGTH + 32, ADL_REST, ADL_LENGTH + 24, 23h, ADL_TIE, ADL_LENGTH + 4, 21h, ADL_LENGTH + 6
    db ADL_REST, 21h, ADL_LENGTH + 8, ADL_REST, ADL_LENGTH + 4, 21h, ADL_LENGTH + 6, ADL_REST, ADL_LENGTH + 8, 21h, ADL_LENGTH + 6, ADL_REST
    db ADL_END_PATTERN
Tune2Pattern_1732 label byte
    db ADL_LENGTH + 24, 1Fh, ADL_TIE, 1Dh, 1Ch, 1Fh, ADL_TIE, 1Dh, 1Ch, ADL_END_PATTERN
Tune2Pattern_173C label byte
    db ADL_INSTRUMENT + 11, ADL_LENGTH + 10, 2Dh, ADL_LENGTH + 2, 2Ah, ADL_LENGTH + 4, 28h, ADL_LENGTH + 6, 2Ah, ADL_LENGTH + 18, 26h, ADL_LENGTH + 2
    db 28h, ADL_LENGTH + 6, 2Ah, ADL_LENGTH + 10, 2Fh, ADL_LENGTH + 28, 2Dh, ADL_LENGTH + 2, 2Fh, 2Dh, 2Bh, 2Ah
    db 2Bh, ADL_LENGTH + 16, 2Dh, ADL_LENGTH + 2, 28h, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 18, 26h, ADL_LENGTH + 2, 28h, ADL_LENGTH + 6
    db 2Ah, ADL_LENGTH + 10, 2Fh, ADL_LENGTH + 26, 2Dh, ADL_LENGTH + 2, 2Fh, 30h, 32h, 34h, 36h, 39h
    db ADL_INSTRUMENT + 7, 2Ah, 2Dh, 2Fh, 32h, ADL_REST, ADL_LENGTH + 12, 34h, ADL_LENGTH + 2, 36h, 39h, 36h
    db 34h, 36h, 34h, 32h, 34h, 32h, 2Fh, 32h, 2Fh, 32h, ADL_LENGTH + 6, 32h
    db ADL_LENGTH + 4, 34h, 32h, ADL_TIE, ADL_CARRIER_VOLUME, 64h, 34h, 32h, ADL_TIE, ADL_CARRIER_VOLUME, 50h, 34h
    db 32h, ADL_TIE, ADL_CARRIER_VOLUME, 40h, 34h, ADL_INSTRUMENT + 0, ADL_LENGTH + 2, ADL_REST, ADL_INSTRUMENT + 7, 2Ah, 2Dh, 2Fh
    db 32h, ADL_REST, ADL_LENGTH + 12, 32h, ADL_LENGTH + 2, 32h, 36h, 34h, 32h, ADL_LENGTH + 4, 34h, ADL_LENGTH + 9
    db 34h, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 2, 34h, 39h, 36h, 32h, 39h, 36h, 32h, 39h
    db 36h, 32h, 39h, 36h, 32h, 39h, 36h, 34h, 39h, 36h, 34h, 39h
    db 36h, 34h, 36h, 39h, 34h, ADL_END_PATTERN
Tune2Pattern_17C6 label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 12, 2Dh, ADL_LENGTH + 4, 32h, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 32h, ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 2
    db 32h, 34h, 2Dh, 32h, 34h, 2Dh, 32h, 34h, 2Dh, ADL_LENGTH + 6, 32h, ADL_LENGTH + 4
    db 34h, ADL_LENGTH + 6, 36h, ADL_LENGTH + 2, 37h, ADL_LENGTH + 4, 36h, ADL_LENGTH + 24, 34h, ADL_LENGTH + 2, 36h, ADL_LENGTH + 4
    db 37h, ADL_LENGTH + 2, 39h, ADL_LENGTH + 4, 37h, ADL_LENGTH + 6, 36h, 34h, ADL_LENGTH + 14, 36h, ADL_LENGTH + 2, 39h
    db 37h, 36h, 34h, 36h, 34h, ADL_LENGTH + 6, 32h, ADL_LENGTH + 4, 34h, ADL_LENGTH + 6, 30h, ADL_LENGTH + 2
    db 32h, ADL_LENGTH + 6, 2Fh, ADL_LENGTH + 4, 30h, ADL_LENGTH + 6, 2Dh, ADL_LENGTH + 2, 2Fh, ADL_LENGTH + 6, 2Bh, ADL_LENGTH + 4
    db 2Dh, ADL_LENGTH + 2, 2Ah, 2Dh, 32h, 2Dh, 34h, 2Dh, 32h, 2Dh, 34h, 2Dh
    db 32h, 2Dh, 34h, 2Dh, 32h, 2Dh, 34h, 2Dh, 32h, 2Dh, 34h, 2Dh
    db 32h, 2Dh, 34h, 37h, 36h, 32h, 36h, 32h, 36h, 37h, 36h, 32h
    db 36h, 32h, 36h, 37h, 39h, 36h, 37h, 32h, 36h, 3Bh, 39h, 37h
    db 36h, 36h, 34h, 32h, 2Fh, 2Dh, ADL_LENGTH + 4, 34h, ADL_LENGTH + 12, 32h, ADL_LENGTH + 2, 34h
    db 36h, 37h, 36h, ADL_LENGTH + 4, 34h, ADL_LENGTH + 14, 32h, ADL_LENGTH + 6, 28h, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 6
    db 2Bh, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 6, 2Fh, ADL_LENGTH + 4, 32h, ADL_LENGTH + 6, 34h, ADL_LENGTH + 2, 36h, ADL_LENGTH + 12
    db 37h, ADL_END_PATTERN
Tune2Pattern_1864 label byte
    db ADL_LENGTH + 32, ADL_REST, ADL_REST, ADL_REST, ADL_LENGTH + 2, ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 54h, 3Bh, 39h, 3Bh, 3Ch
    db 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch
    db 3Bh, 39h, ADL_CARRIER_VOLUME, 5Ah, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h
    db 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ADL_CARRIER_VOLUME, 60h
    db 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h
    db 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ADL_CARRIER_VOLUME, 66h, 3Bh, 39h, 3Bh, 3Ch
    db 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch
    db 3Bh, 39h, ADL_CARRIER_VOLUME, 6Ch, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h
    db 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ADL_CARRIER_VOLUME, 72h
    db 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h
    db 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, ADL_CARRIER_VOLUME, 79h, 3Bh, 39h, 3Bh, 3Ch
    db 3Bh, 39h, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 39h, 3Bh, 39h, 3Ch
    db 3Bh, 39h, ADL_CARRIER_VOLUME, 7Eh, 3Bh, 39h, 3Bh, 3Ch, 3Bh, 39h, 3Ch, 3Bh
    db 39h, 3Ch, 3Bh, 39h, 3Ch, 3Bh, 39h, 3Ch, 3Bh, 3Eh, ADL_END_PATTERN
; Tune 3: tempo 5 timer ticks per step, 9 voices, order list per voice.
Tune3 db 5, 9
    dw offset Tune3Order0, offset Tune3Order1, offset Tune3Order2, offset Tune3Order3
    dw offset Tune3Order4, offset Tune3Order5, offset Tune3Order6, offset Tune3Order7
    dw offset Tune3Order8
Tune3Order0 label word
    dw offset Tune3Pattern_1A07
Tune3OrderLoop_1921 label word
    dw offset Tune3Pattern_1A07
    dw offset Tune3Pattern_1A07
    dw offset Tune3Pattern_1A6A
    dw offset Tune3Pattern_1A07
    dw offset Tune3Pattern_1A07
    dw offset Tune3Pattern_1A07
    dw offset Tune3Pattern_1A6A
    dw offset Tune3Pattern_1ACB
    dw offset Tune3Pattern_1A07
    dw offset Tune3Pattern_1A07
    dw offset Tune3Pattern_1A6A
    dw offset Tune3Pattern_1A6A
    dw 0, offset Tune3OrderLoop_1921
Tune3Order1 label word
    dw offset Tune3Pattern_1B2E
Tune3OrderLoop_193F label word
    dw offset Tune3Pattern_1B2E
    dw offset Tune3Pattern_1B2E
    dw offset Tune3Pattern_1B54
    dw offset Tune3Pattern_1B2E
    dw offset Tune3Pattern_1B2E
    dw offset Tune3Pattern_1B2E
    dw offset Tune3Pattern_1B54
    dw offset Tune3Pattern_1B81
    dw offset Tune3Pattern_1B2E
    dw offset Tune3Pattern_1B2E
    dw offset Tune3Pattern_1B54
    dw offset Tune3Pattern_1B54
    dw 0, offset Tune3OrderLoop_193F
Tune3Order2 label word
    dw offset Tune3Pattern_1BA7
Tune3Order3 label word
    dw offset Tune3Pattern_1BB4
Tune3OrderLoop_195F label word
    dw offset Tune3Pattern_1BB4
    dw offset Tune3Pattern_1BB4
    dw offset Tune3Pattern_1C1B
    dw offset Tune3Pattern_1BB4
    dw offset Tune3Pattern_1BB4
    dw offset Tune3Pattern_1BB4
    dw offset Tune3Pattern_1C1B
    dw offset Tune3Pattern_1C79
    dw offset Tune3Pattern_1C7D
    dw offset Tune3Pattern_1CAE
    dw offset Tune3Pattern_1CAE
    dw offset Tune3Pattern_1D10
    dw offset Tune3Pattern_1C1B
    dw 0, offset Tune3OrderLoop_195F
Tune3Order4 label word
    dw offset Tune3Pattern_1D72
Tune3OrderLoop_197F label word
    dw offset Tune3Pattern_1D72
    dw offset Tune3Pattern_1D72
    dw offset Tune3Pattern_1D84
    dw offset Tune3Pattern_1D72
    dw offset Tune3Pattern_1D72
    dw offset Tune3Pattern_1D72
    dw offset Tune3Pattern_1D84
    dw offset Tune3Pattern_1DBF
    dw offset Tune3Pattern_1DE7
    dw offset Tune3Pattern_1DE7
    dw offset Tune3Pattern_1E08
    dw offset Tune3Pattern_1D84
    dw 0, offset Tune3OrderLoop_197F
Tune3Order5 label word
    dw offset Tune3Pattern_1E4A
Tune3OrderLoop_199D label word
    dw offset Tune3Pattern_1E4A
    dw offset Tune3Pattern_1E4A
    dw offset Tune3Pattern_1E5C
    dw offset Tune3Pattern_1E4A
    dw offset Tune3Pattern_1E4A
    dw offset Tune3Pattern_1E4A
    dw offset Tune3Pattern_1E5C
    dw offset Tune3Pattern_1E97
    dw offset Tune3Pattern_1EBF
    dw offset Tune3Pattern_1EBF
    dw offset Tune3Pattern_1EE0
    dw offset Tune3Pattern_1E5C
    dw 0, offset Tune3OrderLoop_199D
Tune3Order6 label word
    dw offset Tune3Pattern_1F22
Tune3OrderLoop_19BB label word
    dw offset Tune3Pattern_1F22
    dw offset Tune3Pattern_1F22
    dw offset Tune3Pattern_1F34
    dw offset Tune3Pattern_1F22
    dw offset Tune3Pattern_1F22
    dw offset Tune3Pattern_1F22
    dw offset Tune3Pattern_1F34
    dw offset Tune3Pattern_1F6F
    dw offset Tune3Pattern_1F97
    dw offset Tune3Pattern_1F97
    dw offset Tune3Pattern_1FB8
    dw offset Tune3Pattern_1F34
    dw 0, offset Tune3OrderLoop_19BB
Tune3Order7 label word
    dw offset Tune3Pattern_1FFA
Tune3OrderLoop_19D9 label word
    dw offset Tune3Pattern_200C
    dw offset Tune3Pattern_20BC
    dw offset Tune3Pattern_1FFA
    dw offset Tune3Pattern_200C
    dw offset Tune3Pattern_20BC
    dw offset Tune3Pattern_20E7
    dw offset Tune3Pattern_210F
    dw offset Tune3Pattern_21BC
    dw offset Tune3Pattern_20BC
    dw 0, offset Tune3OrderLoop_19D9
Tune3Order8 label word
    dw offset Tune3Pattern_229E
Tune3OrderLoop_19F1 label word
    dw offset Tune3Pattern_22A9
    dw offset Tune3Pattern_235F
    dw offset Tune3Pattern_229E
    dw offset Tune3Pattern_22A9
    dw offset Tune3Pattern_235F
    dw offset Tune3Pattern_2386
    dw offset Tune3Pattern_21EC
    dw offset Tune3Pattern_23BE
    dw offset Tune3Pattern_235F
    dw 0, offset Tune3OrderLoop_19F1
Tune3Pattern_1A07 label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, 0Eh
    db ADL_REST, 0Eh, ADL_END_PATTERN
Tune3Pattern_1A6A label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 2, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 2, 0Eh, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_END_PATTERN
Tune3Pattern_1ACB label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, ADL_LENGTH + 6
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, 0Eh
    db 0Eh, 0Eh, ADL_END_PATTERN
Tune3Pattern_1B2E label byte
    db ADL_LENGTH + 6, ADL_REST, ADL_INSTRUMENT + 2, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_LENGTH + 2, 0Eh, ADL_REST
    db 0Eh, ADL_END_PATTERN
Tune3Pattern_1B54 label byte
    db ADL_LENGTH + 6, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 2, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 6, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_LENGTH + 2, 0Eh, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune3Pattern_1B81 label byte
    db ADL_LENGTH + 6, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_INSTRUMENT + 2, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_LENGTH + 2, 0Eh, 0Eh
    db 0Eh, ADL_END_PATTERN
Tune3Pattern_1BA7 label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 6
Tune3Pattern_1BA9 label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, ADL_JUMP
    dw offset Tune3Pattern_1BA9
Tune3Pattern_1BB4 label byte
    db ADL_INSTRUMENT + 4, ADL_CARRIER_VOLUME, 78h, ADL_LENGTH + 2, ADL_TRANSPOSE, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, 0Eh, 15h, 0Eh, 13h, 15h, 18h
    db 0Eh, 15h, 0Eh, 13h, 15h, 0Ch, ADL_END_PATTERN
Tune3Pattern_1C1B label byte
    db ADL_LENGTH + 2, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST
    db 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST
    db 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST
    db 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST
    db 11h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 15h, ADL_REST, 15h, 15h, ADL_REST, 15h, 15h, ADL_REST, 15h, 15h, ADL_REST
    db 15h, 15h, ADL_REST, 15h, 15h, ADL_REST, 15h, ADL_LENGTH + 12, 15h, ADL_END_PATTERN
Tune3Pattern_1C79 label byte
    db ADL_INSTRUMENT + 4, ADL_LENGTH + 2, ADL_TRANSPOSE, 0Ch
Tune3Pattern_1C7D label byte
    db 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh
    db 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh
    db 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh
    db 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh
    db ADL_END_PATTERN
Tune3Pattern_1CAE label byte
    db ADL_LENGTH + 2, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE
    db 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE
    db 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE
    db 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE, 0Eh, 0Eh, ADL_TIE
    db 0Eh, 10h, ADL_TIE, 10h, 10h, ADL_TIE, 10h, 10h, ADL_TIE, 10h, 10h, ADL_TIE
    db 10h, 10h, ADL_TIE, 10h, 10h, ADL_TIE, 10h, 10h, ADL_TIE, 10h, 10h, ADL_TIE
    db 10h, 13h, ADL_TIE, 13h, 13h, ADL_TIE, 13h, 13h, ADL_TIE, 13h, 13h, ADL_TIE
    db 13h, 13h, ADL_TIE, 13h, 13h, ADL_TIE, 13h, 13h, ADL_TIE, 13h, 13h, ADL_TIE
    db 13h, ADL_END_PATTERN
Tune3Pattern_1D10 label byte
    db ADL_TRANSPOSE, 07h, ADL_LENGTH + 2, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h
    db 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h
    db 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h
    db 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h, 11h, ADL_REST, 11h
    db 11h, ADL_REST, 11h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h
    db 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h
    db 13h, ADL_REST, 13h, 15h, ADL_REST, 15h, 15h, ADL_REST, 15h, 15h, ADL_REST, 15h
    db 15h, ADL_REST, 15h, 15h, ADL_REST, 15h, 15h, ADL_REST, 15h, ADL_LENGTH + 12, 15h, ADL_TRANSPOSE
    db 0Ch, ADL_END_PATTERN
Tune3Pattern_1D72 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 24, 32h, ADL_TIE, 35h, ADL_LENGTH + 12, 37h, 39h, ADL_LENGTH + 24, 32h
    db ADL_TIE, 35h, ADL_LENGTH + 12, 37h, 39h, ADL_END_PATTERN
Tune3Pattern_1D84 label byte
    db ADL_LENGTH + 12, 30h, ADL_LENGTH + 2, 30h, ADL_REST, 30h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 30h, ADL_LENGTH + 2, 30h
    db ADL_REST, 30h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 30h, ADL_LENGTH + 2, 30h, ADL_REST, 30h, ADL_REST, ADL_REST
    db ADL_LENGTH + 14, 30h, ADL_LENGTH + 2, 30h, ADL_REST, 30h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 32h, ADL_LENGTH + 2, 32h
    db ADL_REST, 32h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 32h, ADL_LENGTH + 2, 32h, ADL_REST, 32h, ADL_REST, ADL_REST
    db ADL_LENGTH + 14, 34h, ADL_LENGTH + 2, 34h, ADL_REST, 34h, ADL_REST, ADL_REST, ADL_LENGTH + 26, 34h, ADL_END_PATTERN
Tune3Pattern_1DBF label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 32, 2Dh, ADL_LENGTH + 2, ADL_REST, 2Dh, ADL_REST, ADL_REST, 2Dh, ADL_REST
    db ADL_REST, 2Dh, ADL_LENGTH + 32, 2Dh, ADL_LENGTH + 2, ADL_REST, 2Dh, ADL_REST, ADL_REST, 2Dh, ADL_REST, ADL_REST
    db 2Dh, ADL_LENGTH + 32, 2Dh, ADL_LENGTH + 2, ADL_REST, 2Dh, ADL_REST, ADL_REST, 2Dh, ADL_REST, ADL_REST, 2Dh
    db ADL_LENGTH + 24, 2Dh, ADL_TIE, ADL_END_PATTERN
Tune3Pattern_1DE7 label byte
    db ADL_TRANSPOSE, 0E8h, ADL_LENGTH + 31, 32h, ADL_LENGTH + 2, ADL_REST, 34h, ADL_REST, ADL_REST, 34h, ADL_LENGTH + 4, ADL_REST
    db ADL_LENGTH + 3, 34h, ADL_LENGTH + 24, 35h, 37h, ADL_LENGTH + 31, 34h, ADL_LENGTH + 2, ADL_REST, 34h, ADL_REST, ADL_REST
    db 34h, ADL_LENGTH + 4, ADL_REST, ADL_LENGTH + 3, 34h, ADL_LENGTH + 24, 37h, ADL_TIE, ADL_END_PATTERN
Tune3Pattern_1E08 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_TRANSPOSE, 0EFh, ADL_LENGTH + 12, 24h, ADL_LENGTH + 2, 24h, ADL_REST, 24h, ADL_REST
    db ADL_REST, ADL_LENGTH + 14, 24h, ADL_LENGTH + 2, 24h, ADL_REST, 24h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 24h, ADL_LENGTH + 2
    db 24h, ADL_REST, 24h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 24h, ADL_LENGTH + 2, 24h, ADL_REST, 24h, ADL_REST
    db ADL_REST, ADL_LENGTH + 14, 26h, ADL_LENGTH + 2, 26h, ADL_REST, 26h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 26h, ADL_LENGTH + 2
    db 26h, ADL_REST, 26h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 28h, ADL_LENGTH + 2, 28h, ADL_REST, 28h, ADL_REST
    db ADL_REST, ADL_LENGTH + 26, 28h, ADL_TRANSPOSE, 0E8h, ADL_END_PATTERN
Tune3Pattern_1E4A label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 24, 2Dh, ADL_TIE, 30h, ADL_LENGTH + 12, 32h, 34h, ADL_LENGTH + 24, 2Dh
    db ADL_TIE, 30h, ADL_LENGTH + 12, 32h, 34h, ADL_END_PATTERN
Tune3Pattern_1E5C label byte
    db ADL_LENGTH + 12, 29h, ADL_LENGTH + 2, 29h, ADL_REST, 29h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 29h, ADL_LENGTH + 2, 29h
    db ADL_REST, 29h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 29h, ADL_LENGTH + 2, 29h, ADL_REST, 29h, ADL_REST, ADL_REST
    db ADL_LENGTH + 14, 29h, ADL_LENGTH + 2, 29h, ADL_REST, 29h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 2Bh, ADL_LENGTH + 2, 2Bh
    db ADL_REST, 2Bh, ADL_REST, ADL_REST, ADL_LENGTH + 14, 2Bh, ADL_LENGTH + 2, 2Bh, ADL_REST, 2Bh, ADL_REST, ADL_REST
    db ADL_LENGTH + 14, 2Dh, ADL_LENGTH + 2, 2Dh, ADL_REST, 2Dh, ADL_REST, ADL_REST, ADL_LENGTH + 26, 2Dh, ADL_END_PATTERN
Tune3Pattern_1E97 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 32, 32h, ADL_LENGTH + 2, ADL_REST, 32h, ADL_REST, ADL_REST, 32h, ADL_REST
    db ADL_REST, 32h, ADL_LENGTH + 32, 32h, ADL_LENGTH + 2, ADL_REST, 32h, ADL_REST, ADL_REST, 32h, ADL_REST, ADL_REST
    db 32h, ADL_LENGTH + 32, 32h, ADL_LENGTH + 2, ADL_REST, 32h, ADL_REST, ADL_REST, 32h, ADL_REST, ADL_REST, 32h
    db ADL_LENGTH + 24, 32h, ADL_TIE, ADL_END_PATTERN
Tune3Pattern_1EBF label byte
    db ADL_TRANSPOSE, 0E8h, ADL_LENGTH + 31, 2Dh, ADL_LENGTH + 2, ADL_REST, 2Dh, ADL_REST, ADL_REST, 2Dh, ADL_LENGTH + 4, ADL_REST
    db ADL_LENGTH + 3, 2Dh, ADL_LENGTH + 24, 30h, 32h, ADL_LENGTH + 31, 2Dh, ADL_LENGTH + 2, ADL_REST, 2Dh, ADL_REST, ADL_REST
    db 2Dh, ADL_LENGTH + 4, ADL_REST, ADL_LENGTH + 3, 2Dh, ADL_LENGTH + 24, 32h, ADL_TIE, ADL_END_PATTERN
Tune3Pattern_1EE0 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_TRANSPOSE, 0EFh, ADL_LENGTH + 12, 1Dh, ADL_LENGTH + 2, 1Dh, ADL_REST, 1Dh, ADL_REST
    db ADL_REST, ADL_LENGTH + 14, 1Dh, ADL_LENGTH + 2, 1Dh, ADL_REST, 1Dh, ADL_REST, ADL_REST, ADL_LENGTH + 14, 1Dh, ADL_LENGTH + 2
    db 1Dh, ADL_REST, 1Dh, ADL_REST, ADL_REST, ADL_LENGTH + 14, 1Dh, ADL_LENGTH + 2, 1Dh, ADL_REST, 1Dh, ADL_REST
    db ADL_REST, ADL_LENGTH + 14, 1Fh, ADL_LENGTH + 2, 1Fh, ADL_REST, 1Fh, ADL_REST, ADL_REST, ADL_LENGTH + 14, 1Fh, ADL_LENGTH + 2
    db 1Fh, ADL_REST, 1Fh, ADL_REST, ADL_REST, ADL_LENGTH + 14, 21h, ADL_LENGTH + 2, 21h, ADL_REST, 21h, ADL_REST
    db ADL_REST, ADL_LENGTH + 26, 21h, ADL_TRANSPOSE, 0E8h, ADL_END_PATTERN
Tune3Pattern_1F22 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 24, 26h, ADL_TIE, 29h, ADL_LENGTH + 12, 2Bh, 2Dh, ADL_LENGTH + 24, 26h
    db ADL_TIE, 29h, ADL_LENGTH + 12, 2Bh, 2Dh, ADL_END_PATTERN
Tune3Pattern_1F34 label byte
    db ADL_LENGTH + 12, 24h, ADL_LENGTH + 2, 24h, ADL_REST, 24h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 24h, ADL_LENGTH + 2, 24h
    db ADL_REST, 24h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 24h, ADL_LENGTH + 2, 24h, ADL_REST, 24h, ADL_REST, ADL_REST
    db ADL_LENGTH + 14, 24h, ADL_LENGTH + 2, 24h, ADL_REST, 24h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 26h, ADL_LENGTH + 2, 26h
    db ADL_REST, 26h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 26h, ADL_LENGTH + 2, 26h, ADL_REST, 26h, ADL_REST, ADL_REST
    db ADL_LENGTH + 14, 28h, ADL_LENGTH + 2, 28h, ADL_REST, 28h, ADL_REST, ADL_REST, ADL_LENGTH + 26, 28h, ADL_END_PATTERN
Tune3Pattern_1F6F label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 32, 21h, ADL_LENGTH + 2, ADL_REST, 21h, ADL_REST, ADL_REST, 21h, ADL_REST
    db ADL_REST, 21h, ADL_LENGTH + 32, 21h, ADL_LENGTH + 2, ADL_REST, 21h, ADL_REST, ADL_REST, 21h, ADL_REST, ADL_REST
    db 21h, ADL_LENGTH + 32, 21h, ADL_LENGTH + 2, ADL_REST, 21h, ADL_REST, ADL_REST, 21h, ADL_REST, ADL_REST, 21h
    db ADL_LENGTH + 24, 21h, ADL_TIE, ADL_END_PATTERN
Tune3Pattern_1F97 label byte
    db ADL_TRANSPOSE, 0E8h, ADL_LENGTH + 31, 26h, ADL_LENGTH + 2, ADL_REST, 28h, ADL_REST, ADL_REST, 28h, ADL_LENGTH + 4, ADL_REST
    db ADL_LENGTH + 3, 28h, ADL_LENGTH + 24, 29h, 2Bh, ADL_LENGTH + 31, 28h, ADL_LENGTH + 2, ADL_REST, 28h, ADL_REST, ADL_REST
    db 28h, ADL_LENGTH + 4, ADL_REST, ADL_LENGTH + 3, 28h, ADL_LENGTH + 24, 2Bh, ADL_TIE, ADL_END_PATTERN
Tune3Pattern_1FB8 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_TRANSPOSE, 0EFh, ADL_LENGTH + 12, 18h, ADL_LENGTH + 2, 18h, ADL_REST, 18h, ADL_REST
    db ADL_REST, ADL_LENGTH + 14, 18h, ADL_LENGTH + 2, 18h, ADL_REST, 18h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 18h, ADL_LENGTH + 2
    db 18h, ADL_REST, 18h, ADL_REST, ADL_REST, ADL_LENGTH + 14, 18h, ADL_LENGTH + 2, 18h, ADL_REST, 18h, ADL_REST
    db ADL_REST, ADL_LENGTH + 14, 1Ah, ADL_LENGTH + 2, 1Ah, ADL_REST, 1Ah, ADL_REST, ADL_REST, ADL_LENGTH + 14, 1Ah, ADL_LENGTH + 2
    db 1Ah, ADL_REST, 1Ah, ADL_REST, ADL_REST, ADL_LENGTH + 14, 1Ch, ADL_LENGTH + 2, 1Ch, ADL_REST, 1Ch, ADL_REST
    db ADL_REST, ADL_LENGTH + 26, 1Ch, ADL_TRANSPOSE, 0E8h, ADL_END_PATTERN
Tune3Pattern_1FFA label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 24, 39h, ADL_TIE, 3Ch, ADL_LENGTH + 12, 3Eh, 40h, ADL_LENGTH + 24, 39h
    db ADL_TIE, 3Ch, ADL_LENGTH + 12, 3Eh, 40h, ADL_END_PATTERN
Tune3Pattern_200C label byte
    db ADL_INSTRUMENT + 7, ADL_TRANSPOSE, 00h, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 6, 3Ch, ADL_LENGTH + 3, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 6, 3Ch, ADL_BEND
    dw 0FFFCh
    db 04h, 16h, ADL_TIE, ADL_LENGTH + 24, 39h, ADL_LENGTH + 2, 37h, 39h, 37h, 35h, 34h, ADL_INSTRUMENT + 8
    db ADL_TRANSPOSE, 00h, ADL_LENGTH + 14, 32h, ADL_LENGTH + 9, 37h, 3Eh, 3Ch, 37h, ADL_LENGTH + 6, ADL_BEND
    dw 0FFFBh
    db 0Ch, 11h, 3Eh, 39h, ADL_BEND
    dw 0003h
    db 30h, 15h, ADL_LENGTH + 24, 37h, ADL_TIE, ADL_LENGTH + 4, 32h, ADL_LENGTH + 2, 37h, 39h, ADL_TIE, 32h
    db 37h, 39h, 32h, 37h, 39h, 32h, 35h, ADL_TIE, 37h, 39h, ADL_TIE, 32h
    db 37h, 39h, 32h, 37h, 39h, 32h, 37h, ADL_TIE, 39h, 3Ch, ADL_TIE, 37h
    db 39h, 3Ch, 37h, 39h, ADL_LENGTH + 4, 3Ch, ADL_BEND
    dw 0006h
    db 24h, 20h, ADL_LENGTH + 24, 39h, ADL_LENGTH + 2, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh
    db 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh
    db 39h, 32h, 3Eh, 39h, 32h, 3Ch, 35h, 32h, 3Ch, 35h, 32h, 3Ch
    db 35h, 32h, 3Ch, 35h, 32h, 3Eh, 37h, 32h, 3Eh, 37h, 32h, 40h
    db 39h, 34h, ADL_LENGTH + 6, 40h, ADL_END_PATTERN
Tune3Pattern_20BC label byte
    db ADL_LENGTH + 4, 29h, ADL_LENGTH + 2, 2Bh, ADL_LENGTH + 4, 2Ch, ADL_LENGTH + 2, 2Eh, 2Ch, 2Eh, 30h, ADL_LENGTH + 22
    db 33h, ADL_LENGTH + 2, ADL_REST, 30h, 2Eh, 2Ch, ADL_LENGTH + 24, 2Eh, 2Bh, ADL_LENGTH + 4, 2Bh, ADL_LENGTH + 2
    db 2Dh, ADL_LENGTH + 4, 2Eh, ADL_LENGTH + 2, 30h, 2Eh, 30h, 32h, ADL_LENGTH + 22, 35h, ADL_LENGTH + 2, ADL_REST
    db 32h, 30h, 2Dh, ADL_LENGTH + 24, 31h, 34h, ADL_END_PATTERN
Tune3Pattern_20E7 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 74h, ADL_LENGTH + 32, 26h, ADL_LENGTH + 2, ADL_REST, 26h, ADL_REST, ADL_REST, 26h, ADL_REST
    db ADL_REST, 26h, ADL_LENGTH + 32, 26h, ADL_LENGTH + 2, ADL_REST, 26h, ADL_REST, ADL_REST, 26h, ADL_REST, ADL_REST
    db 26h, ADL_LENGTH + 32, 26h, ADL_LENGTH + 2, ADL_REST, 26h, ADL_REST, ADL_REST, 26h, ADL_REST, ADL_REST, 26h
    db ADL_LENGTH + 24, 26h, ADL_TIE, ADL_END_PATTERN
Tune3Pattern_210F label byte
    db ADL_INSTRUMENT + 7, ADL_TRANSPOSE, 00h, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 6, 3Ch, ADL_LENGTH + 3, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 30, 3Ch, ADL_LENGTH + 2, 3Ch, 3Ah, ADL_LENGTH + 1, 39h, 37h, ADL_LENGTH + 24, 35h
    db ADL_LENGTH + 2, 32h, 32h, 34h, 34h, ADL_REST, 37h, 37h, ADL_REST, ADL_REST, ADL_BEND
    dw 0003h
    db 07h, 15h, ADL_LENGTH + 9, 37h, ADL_BEND
    dw 0003h
    db 07h, 15h, ADL_LENGTH + 9, 37h, 34h, 37h, ADL_LENGTH + 6, ADL_REST, ADL_LENGTH + 3, 34h, ADL_LENGTH + 1, ADL_REST
    db ADL_BEND
    dw 0FFFCh
    db 05h, 10h, ADL_LENGTH + 12, 39h, ADL_CARRIER_VOLUME, 64h, ADL_BEND
    dw 0FFFCh
    db 05h, 10h, 39h, ADL_CARRIER_VOLUME, 60h, ADL_BEND
    dw 0FFFCh
    db 05h, 10h, 39h, ADL_CARRIER_VOLUME, 50h, ADL_BEND
    dw 0FFFCh
    db 05h, 10h, ADL_LENGTH + 14, 39h, ADL_INSTRUMENT + 11, ADL_LENGTH + 2, 26h, 2Dh, ADL_LENGTH + 6, 32h, 32h, 32h
    db ADL_LENGTH + 2, 32h, ADL_LENGTH + 2, 28h, 2Dh, ADL_LENGTH + 6, 34h, 34h, 34h, ADL_LENGTH + 2, 34h, 29h
    db 2Dh, 35h, 29h, 2Dh, 35h, 35h, 3Ch, ADL_TIE, 29h, 30h, ADL_TIE, 2Bh
    db 32h, 37h, 2Bh, 32h, 37h, 37h, 3Eh, ADL_TIE, 2Bh, 32h, ADL_TIE, 2Dh
    db 34h, 39h, 2Dh, 34h, 39h, 34h, 39h, 34h, 2Dh, 34h, 2Dh, 34h
    db 32h, 2Fh, 2Dh, 2Bh, 28h, 40h, 3Eh, 3Bh, 39h, 37h, 34h, ADL_INSTRUMENT + 6
    db ADL_LENGTH + 24, 37h, ADL_LENGTH + 12, 3Eh, 43h, ADL_END_PATTERN
Tune3Pattern_21BC label byte
    db ADL_INSTRUMENT + 7, ADL_TRANSPOSE, 07h, ADL_LENGTH + 4, 29h, ADL_LENGTH + 2, 2Bh, ADL_LENGTH + 4, 2Ch, ADL_LENGTH + 2, 2Eh, 2Ch
    db 2Eh, 30h, ADL_LENGTH + 22, 33h, ADL_LENGTH + 2, ADL_REST, 30h, 2Eh, 2Ch, ADL_LENGTH + 24, 2Eh, 2Bh
    db ADL_LENGTH + 4, 2Bh, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 2Eh, ADL_LENGTH + 2, 30h, 2Eh, 30h, 32h, ADL_LENGTH + 22
    db 35h, ADL_LENGTH + 2, ADL_REST, 32h, 30h, 2Dh, ADL_LENGTH + 24, 31h, 34h, ADL_TRANSPOSE, 00h, ADL_END_PATTERN
Tune3Pattern_21EC label byte
    db ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 6Ch, ADL_TRANSPOSE, 00h, ADL_LENGTH + 2, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 6, 3Ch, ADL_LENGTH + 3, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 30, 3Ch, ADL_LENGTH + 2, 3Ch, 3Ah, ADL_LENGTH + 1, 39h, 37h, ADL_LENGTH + 24, 35h
    db ADL_LENGTH + 2, 32h, 32h, 34h, 34h, ADL_REST, 37h, 37h, ADL_REST, ADL_REST, ADL_BEND
    dw 0003h
    db 07h, 15h, ADL_LENGTH + 9, 37h, ADL_BEND
    dw 0003h
    db 07h, 15h, ADL_LENGTH + 9, 37h, 34h, 37h, ADL_LENGTH + 6, ADL_REST, ADL_LENGTH + 3, 34h, ADL_LENGTH + 1, ADL_REST
    db ADL_BEND
    dw 0FFFCh
    db 05h, 10h, ADL_LENGTH + 12, 39h, ADL_CARRIER_VOLUME, 5Ch, ADL_BEND
    dw 0FFFCh
    db 05h, 10h, 39h, ADL_CARRIER_VOLUME, 54h, ADL_BEND
    dw 0FFFCh
    db 05h, 10h, 39h, ADL_CARRIER_VOLUME, 4Ch, ADL_BEND
    dw 0FFFCh
    db 05h, 10h, ADL_LENGTH + 14, 39h, ADL_INSTRUMENT + 11, ADL_LENGTH + 2, 26h, 2Dh, ADL_LENGTH + 6, 32h, 32h, 32h
    db ADL_LENGTH + 2, 32h, ADL_LENGTH + 2, 28h, 2Dh, ADL_LENGTH + 6, 34h, 34h, 34h, ADL_LENGTH + 2, 34h, 29h
    db 2Dh, 35h, 29h, 2Dh, 35h, 35h, 3Ch, ADL_TIE, 29h, 30h, ADL_TIE, 2Bh
    db 32h, 37h, 2Bh, 32h, 37h, 37h, 3Eh, ADL_TIE, 2Bh, 32h, ADL_TIE, 2Dh
    db 34h, 39h, 2Dh, 34h, 39h, 34h, 39h, 34h, 2Dh, 34h, 2Dh, 34h
    db 32h, 2Fh, 2Dh, 2Bh, 28h, 40h, 3Eh, 3Bh, 39h, 37h, 34h, ADL_INSTRUMENT + 6
    db ADL_LENGTH + 24, 37h, ADL_LENGTH + 12, 3Eh, ADL_LENGTH + 10, 43h, ADL_END_PATTERN
Tune3Pattern_229E label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_END_PATTERN
Tune3Pattern_22A9 label byte
    db ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 6Ch, ADL_TRANSPOSE, 00h, ADL_LENGTH + 2, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 6, 3Ch, ADL_LENGTH + 3, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, 3Ch, ADL_TIE, ADL_REST, ADL_BEND
    dw 0004h
    db 04h, 16h, ADL_LENGTH + 6, 3Ch, ADL_BEND
    dw 0FFFCh
    db 04h, 16h, ADL_TIE, ADL_LENGTH + 24, 39h, ADL_LENGTH + 2, 37h, 39h, 37h, 35h, 34h, ADL_INSTRUMENT + 8
    db ADL_CARRIER_VOLUME, 6Ch, ADL_TRANSPOSE, 00h, ADL_LENGTH + 14, 32h, ADL_LENGTH + 9, 37h, 3Eh, 3Ch, 37h, ADL_LENGTH + 6
    db ADL_BEND
    dw 0FFFBh
    db 0Ch, 11h, 3Eh, 39h, ADL_BEND
    dw 0003h
    db 30h, 15h, ADL_LENGTH + 24, 37h, ADL_TIE, ADL_LENGTH + 4, 32h, ADL_LENGTH + 2, 37h, 39h, ADL_TIE, 32h
    db 37h, 39h, 32h, 37h, 39h, 32h, 35h, ADL_TIE, 37h, 39h, ADL_TIE, 32h
    db 37h, 39h, 32h, 37h, 39h, 32h, 37h, ADL_TIE, 39h, 3Ch, ADL_TIE, 37h
    db 39h, 3Ch, 37h, 39h, ADL_LENGTH + 4, 3Ch, ADL_BEND
    dw 0006h
    db 24h, 20h, ADL_LENGTH + 24, 39h, ADL_LENGTH + 2, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh
    db 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh, 39h, 32h, 3Eh
    db 39h, 32h, 3Eh, 39h, 32h, 3Ch, 35h, 32h, 3Ch, 35h, 32h, 3Ch
    db 35h, 32h, 3Ch, 35h, 32h, 3Eh, 37h, 32h, 3Eh, 37h, 32h, 40h
    db 39h, 34h, ADL_LENGTH + 4, 40h, ADL_END_PATTERN
Tune3Pattern_235F label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_LENGTH + 4, 29h, ADL_LENGTH + 2, 2Bh, 2Ch, ADL_TIE, 2Eh, 2Ch, 2Eh
    db 30h, ADL_LENGTH + 22, 33h, ADL_LENGTH + 2, ADL_REST, 30h, 2Eh, 2Ch, ADL_LENGTH + 24, 2Eh, 2Bh, ADL_LENGTH + 4
    db 2Dh, ADL_LENGTH + 2, 2Fh, ADL_LENGTH + 4, 30h, ADL_LENGTH + 2, 32h, 30h, 32h, 34h, ADL_LENGTH + 18, 37h
    db ADL_LENGTH + 12, 39h, ADL_END_PATTERN
Tune3Pattern_2386 label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_INSTRUMENT + 6, ADL_LENGTH + 2, 23h, 28h, 2Ah, 2Dh, 2Ah
    db 2Dh, 2Fh, 2Dh, 2Fh, 32h, 2Fh, 32h, 2Fh, 34h, 36h, 39h, 36h
    db 39h, 3Bh, 39h, 3Bh, 3Eh, 3Bh, 3Eh, 23h, 28h, 2Ah, 2Dh, 2Ah
    db 2Dh, 2Fh, 2Dh, 2Fh, 32h, 2Fh, 32h, 2Fh, 34h, 36h, 39h, 36h
    db 39h, 3Bh, 39h, 3Bh, 3Eh, 3Bh, 3Eh, ADL_END_PATTERN
Tune3Pattern_23BE label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_INSTRUMENT + 7, ADL_TRANSPOSE, 07h, ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 4, 29h, ADL_LENGTH + 2, 2Bh
    db 2Ch, ADL_TIE, 2Eh, 2Ch, 2Eh, 30h, ADL_LENGTH + 22, 33h, ADL_LENGTH + 2, ADL_REST, 30h, 2Eh
    db 2Ch, ADL_LENGTH + 24, 2Eh, 2Bh, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 2, 2Fh, ADL_LENGTH + 4, 30h, ADL_LENGTH + 2, 32h
    db 30h, 32h, 34h, ADL_LENGTH + 18, 37h, ADL_LENGTH + 12, 39h, ADL_TRANSPOSE, 00h, ADL_END_PATTERN
; Tune 4: tempo 5 timer ticks per step, 9 voices, order list per voice.
Tune4 db 5, 9
    dw offset Tune4Order0, offset Tune4Order1, offset Tune4Order2, offset Tune4Order3
    dw offset Tune4Order4, offset Tune4Order5, offset Tune4Order6, offset Tune4Order7
    dw offset Tune4Order8
Tune4Order0 label word
    dw offset Tune4Pattern_243C
Tune4OrderLoop_2402 label word
    dw offset Tune4Pattern_2454
    dw 0, offset Tune4OrderLoop_2402
Tune4Order1 label word
    dw offset Tune4Pattern_2472
Tune4OrderLoop_240A label word
    dw offset Tune4Pattern_248A
    dw 0, offset Tune4OrderLoop_240A
Tune4Order2 label word
    dw offset Tune4Pattern_24A8
Tune4OrderLoop_2412 label word
    dw offset Tune4Pattern_24C0
    dw 0, offset Tune4OrderLoop_2412
Tune4Order3 label word
    dw offset Tune4Pattern_24DE
Tune4OrderLoop_241A label word
    dw offset Tune4Pattern_250F
    dw 0, offset Tune4OrderLoop_241A
Tune4Order4 label word
    dw offset Tune4Pattern_2570
Tune4OrderLoop_2422 label word
    dw offset Tune4Pattern_2588
    dw 0, offset Tune4OrderLoop_2422
Tune4Order5 label word
    dw offset Tune4Pattern_25B7
    dw offset Tune4Pattern_25CA
Tune4Order6 label word
    dw offset Tune4Pattern_25DD
    dw offset Tune4Pattern_2612
Tune4Order7 label word
    dw offset Tune4Pattern_2675
    dw 0, offset Tune4Order7
Tune4Order8 label word
    dw offset Tune4Pattern_270C
    dw 0, offset Tune4Order8
Tune4Pattern_243C label byte
    db ADL_INSTRUMENT + 6, ADL_TRANSPOSE, 0F4h, ADL_CARRIER_VOLUME, 72h, ADL_LENGTH + 12, 28h, 2Bh, 28h, ADL_LENGTH + 3, 2Bh, ADL_REST
    db 2Dh, ADL_REST, ADL_LENGTH + 12, 28h, 2Bh, 28h, ADL_LENGTH + 3, 2Bh, ADL_REST, 2Dh, ADL_REST, ADL_END_PATTERN
Tune4Pattern_2454 label byte
    db ADL_LENGTH + 12, 28h, 2Bh, 28h, ADL_LENGTH + 3, 2Bh, ADL_REST, 2Dh, ADL_REST, ADL_LENGTH + 12, 28h, 2Bh
    db 28h, ADL_LENGTH + 3, 2Bh, ADL_REST, 2Dh, ADL_REST, ADL_LENGTH + 24, 2Fh, ADL_TIE, 2Dh, ADL_LENGTH + 12, 28h
    db ADL_LENGTH + 3, 2Dh, ADL_REST, 2Fh, ADL_REST, ADL_END_PATTERN
Tune4Pattern_2472 label byte
    db ADL_INSTRUMENT + 6, ADL_TRANSPOSE, 0F4h, ADL_CARRIER_VOLUME, 72h, ADL_LENGTH + 12, 23h, 28h, 23h, ADL_LENGTH + 3, 28h, ADL_REST
    db 28h, ADL_REST, ADL_LENGTH + 12, 23h, 28h, 23h, ADL_LENGTH + 3, 28h, ADL_REST, 28h, ADL_REST, ADL_END_PATTERN
Tune4Pattern_248A label byte
    db ADL_LENGTH + 12, 23h, 28h, 23h, ADL_LENGTH + 3, 28h, ADL_REST, 28h, ADL_REST, ADL_LENGTH + 12, 23h, 28h
    db 23h, ADL_LENGTH + 3, 28h, ADL_REST, 28h, ADL_REST, ADL_LENGTH + 24, 2Dh, ADL_TIE, 28h, ADL_LENGTH + 12, 24h
    db ADL_LENGTH + 3, 28h, ADL_REST, 2Bh, ADL_REST, ADL_END_PATTERN
Tune4Pattern_24A8 label byte
    db ADL_INSTRUMENT + 6, ADL_TRANSPOSE, 0F4h, ADL_CARRIER_VOLUME, 72h, ADL_LENGTH + 12, 21h, 24h, 21h, ADL_LENGTH + 3, 24h, ADL_REST
    db 26h, ADL_REST, ADL_LENGTH + 12, 21h, 24h, 21h, ADL_LENGTH + 3, 24h, ADL_REST, 26h, ADL_REST, ADL_END_PATTERN
Tune4Pattern_24C0 label byte
    db ADL_LENGTH + 12, 21h, 24h, 21h, ADL_LENGTH + 3, 24h, ADL_REST, 26h, ADL_REST, ADL_LENGTH + 12, 21h, 24h
    db 21h, ADL_LENGTH + 3, 24h, ADL_REST, 26h, ADL_REST, ADL_LENGTH + 24, 28h, ADL_TIE, 26h, ADL_LENGTH + 12, 2Bh
    db ADL_LENGTH + 3, 26h, ADL_REST, 28h, ADL_REST, ADL_END_PATTERN
Tune4Pattern_24DE label byte
    db ADL_LENGTH + 6, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_END_PATTERN
Tune4Pattern_250F label byte
    db ADL_LENGTH + 6, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh
    db ADL_LENGTH + 6, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, ADL_LENGTH + 4, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_LENGTH + 6, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_END_PATTERN
Tune4Pattern_2570 label byte
    db ADL_LENGTH + 6, ADL_REST, ADL_INSTRUMENT + 2, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune4Pattern_2588 label byte
    db ADL_LENGTH + 6, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_LENGTH + 2, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 6, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh
    db ADL_LENGTH + 6, 0Ch, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune4Pattern_25B7 label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 6, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, 12h, 12h, ADL_REST, ADL_END_PATTERN
Tune4Pattern_25CA label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, ADL_REST, ADL_JUMP
    dw offset Tune4Pattern_25CA
Tune4Pattern_25DD label byte
    db ADL_INSTRUMENT + 4, ADL_CARRIER_VOLUME, 78h, ADL_LENGTH + 2, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h
    db 18h, 18h, 18h, 18h, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h
    db 18h, 1Ah, ADL_REST, 1Ah, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h
    db 18h, 18h, 18h, 18h, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h
    db 18h, 1Ah, ADL_REST, 1Ah, ADL_END_PATTERN
Tune4Pattern_2612 label byte
    db ADL_LENGTH + 2, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 18h, 18h
    db 18h, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 1Ah, ADL_REST
    db 1Ah, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 18h, 18h
    db 18h, 15h, 15h, 15h, 15h, 15h, 15h, 18h, 18h, 18h, 1Ah, ADL_REST
    db 1Ah, 1Ch, 1Ch, 1Ch, 1Ch, 1Ch, 1Ch, 1Ah, 1Ch, 1Ch, 1Ch, 1Ch
    db 1Ch, 1Ah, 1Ch, 1Ch, 1Ch, 1Ch, 1Ch, 1Ah, 1Ch, 1Ch, 1Ch, 1Ch
    db 1Ch, 1Ah, 1Ah, 1Ah, 1Ah, 1Ah, 1Ah, 18h, 1Ah, 1Ah, 1Ah, 1Ah
    db 1Ah, 18h, 18h, 18h, 18h, 18h, 18h, ADL_LENGTH + 3, 13h, ADL_REST, 1Ch, ADL_REST
    db ADL_JUMP
    dw offset Tune4Pattern_2612
Tune4Pattern_2675 label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_INSTRUMENT + 7, ADL_TRANSPOSE, 00h, ADL_LENGTH + 3, 40h, ADL_REST, ADL_CARRIER_VOLUME
    db 70h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 68h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 60h, 40h, ADL_LENGTH + 27, ADL_REST
    db ADL_CARRIER_VOLUME, 7Fh, ADL_LENGTH + 3, 43h, ADL_REST, ADL_CARRIER_VOLUME, 70h, 43h, ADL_REST, ADL_CARRIER_VOLUME, 68h, 43h
    db ADL_REST, ADL_CARRIER_VOLUME, 60h, 43h, ADL_LENGTH + 27, ADL_REST, ADL_CARRIER_VOLUME, 7Fh, ADL_LENGTH + 3, 40h, ADL_REST, ADL_CARRIER_VOLUME
    db 70h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 68h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 60h, 40h, ADL_REST, 40h
    db ADL_REST, ADL_CARRIER_VOLUME, 58h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 50h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 48h, 40h
    db ADL_REST, ADL_CARRIER_VOLUME, 7Fh, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 70h, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 68h, 3Eh
    db ADL_REST, ADL_CARRIER_VOLUME, 60h, 3Eh, ADL_REST, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 58h, 3Eh, ADL_REST, ADL_CARRIER_VOLUME
    db 50h, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 48h, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 7Fh, ADL_LENGTH + 2, 3Bh, 39h
    db 3Ch, 3Bh, 3Ch, 3Eh, ADL_LENGTH + 18, 40h, ADL_TIE, ADL_LENGTH + 2, 3Bh, 39h, 3Ch, 3Bh
    db 3Ch, 3Eh, ADL_LENGTH + 18, 40h, ADL_TIE, ADL_LENGTH + 2, 2Fh, 34h, 37h, 39h, ADL_LENGTH + 4, 3Bh
    db ADL_LENGTH + 18, 3Eh, ADL_TIE, ADL_LENGTH + 2, 2Fh, 34h, 37h, 39h, ADL_LENGTH + 4, 3Bh, ADL_LENGTH + 18, 3Eh
    db ADL_TIE, ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_END_PATTERN
Tune4Pattern_270C label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_LENGTH + 1, ADL_REST, ADL_INSTRUMENT + 7, ADL_LENGTH + 3, 40h, ADL_REST, ADL_CARRIER_VOLUME
    db 70h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 68h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 60h, 40h, ADL_LENGTH + 27, ADL_REST
    db ADL_CARRIER_VOLUME, 7Fh, ADL_LENGTH + 3, 43h, ADL_REST, ADL_CARRIER_VOLUME, 70h, 43h, ADL_REST, ADL_CARRIER_VOLUME, 68h, 43h
    db ADL_REST, ADL_CARRIER_VOLUME, 60h, 43h, ADL_LENGTH + 27, ADL_REST, ADL_CARRIER_VOLUME, 7Fh, ADL_LENGTH + 3, 40h, ADL_REST, ADL_CARRIER_VOLUME
    db 70h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 68h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 60h, 40h, ADL_REST, 40h
    db ADL_REST, ADL_CARRIER_VOLUME, 58h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 50h, 40h, ADL_REST, ADL_CARRIER_VOLUME, 48h, 40h
    db ADL_REST, ADL_CARRIER_VOLUME, 7Fh, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 70h, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 68h, 3Eh
    db ADL_REST, ADL_CARRIER_VOLUME, 60h, 3Eh, ADL_REST, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 58h, 3Eh, ADL_REST, ADL_CARRIER_VOLUME
    db 50h, 3Eh, ADL_REST, ADL_CARRIER_VOLUME, 48h, 3Eh, ADL_REST, ADL_LENGTH + 23, ADL_REST, ADL_INSTRUMENT + 11, ADL_TRANSPOSE, 00h
    db ADL_LENGTH + 2, 3Bh, 39h, 3Ch, 3Bh, 3Ch, 3Eh, ADL_LENGTH + 18, 40h, ADL_TIE, ADL_LENGTH + 2, 3Bh
    db 39h, 3Ch, 3Bh, 3Ch, 3Eh, ADL_LENGTH + 18, 40h, ADL_TIE, ADL_LENGTH + 2, 2Fh, 34h, 37h
    db 39h, ADL_LENGTH + 4, 3Bh, ADL_LENGTH + 18, 3Eh, ADL_TIE, ADL_LENGTH + 2, 2Fh, 34h, 37h, 39h, 3Bh
    db ADL_REST, ADL_INSTRUMENT + 7, ADL_LENGTH + 3, 32h, ADL_REST, 2Fh, ADL_REST, ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST
    db ADL_END_PATTERN
; Tune 5: tempo 5 timer ticks per step, 7 voices, order list per voice.
Tune5 db 5, 7
    dw offset Tune5Order0, offset Tune5Order1, offset Tune5Order2, offset Tune5Order3
    dw offset Tune5Order4, offset Tune5Order5, offset Tune5Order6
Tune5Order0 label word
    dw offset Tune5Pattern_27C7
Tune5Order1 label word
    dw offset Tune5Pattern_2804
Tune5Order2 label word
    dw offset Tune5Pattern_2826
Tune5Order3 label word
    dw offset Tune5Pattern_283F
Tune5Order4 label word
    dw offset Tune5Pattern_2858
Tune5Order5 label word
    dw offset Tune5Pattern_2871
Tune5Order6 label word
    dw offset Tune5Pattern_28C7
Tune5Pattern_27C7 label byte
    db ADL_INSTRUMENT + 4, ADL_TRANSPOSE, 00h, ADL_LENGTH + 2, 09h, 0Eh, 13h, 0Eh, 13h, 15h
Tune5Pattern_27D1 label byte
    db 0Eh, 13h, 15h, 18h, 15h, 1Ah, 1Fh, 18h, 13h, 15h, 13h, 0Eh
    db 11h, 16h, 18h, 1Bh, 18h, 1Dh, 22h, 1Bh, 16h, 18h, 16h, 11h
    db 0Eh, 13h, 15h, 18h, 15h, 1Ah, 1Fh, 18h, 13h, 15h, 13h, 0Eh
    db 13h, 18h, 1Ah, 1Dh, 1Ah, 1Fh, 24h, 1Dh, 18h, 1Ah, 18h, 13h
    db ADL_JUMP
    dw offset Tune5Pattern_27D1
Tune5Pattern_2804 label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 1, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1
    db 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh
    db ADL_INSTRUMENT + 0, 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_JUMP
    dw offset Tune5Pattern_2804
Tune5Pattern_2826 label byte
    db ADL_LENGTH + 12, ADL_REST, ADL_LENGTH + 2, ADL_INSTRUMENT + 2, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST
Tune5Pattern_2830 label byte
    db 0Eh, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST
    db ADL_JUMP
    dw offset Tune5Pattern_2830
Tune5Pattern_283F label byte
    db ADL_LENGTH + 12, ADL_REST, ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 76h, ADL_LENGTH + 6
Tune5Pattern_2845 label byte
    db 2Dh, 2Bh, 2Eh, 2Dh, 30h, 2Eh, 2Dh, 2Bh, 2Dh, 2Bh, 2Eh, 2Dh
    db 32h, 30h, 2Eh, 2Bh, ADL_JUMP
    dw offset Tune5Pattern_2845
Tune5Pattern_2858 label byte
    db ADL_LENGTH + 12, ADL_REST, ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 72h, ADL_LENGTH + 6
Tune5Pattern_285E label byte
    db 21h, 1Fh, 22h, 21h, 24h, 22h, 21h, 1Fh, 21h, 1Fh, 22h, 21h
    db 26h, 24h, 22h, 1Fh, ADL_JUMP
    dw offset Tune5Pattern_285E
Tune5Pattern_2871 label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 2, 21h, 26h, 2Bh, 26h, 2Bh, 2Dh
Tune5Pattern_2879 label byte
    db ADL_LENGTH + 32, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_LENGTH + 18, 39h, ADL_LENGTH + 2, 37h, 32h
    db 39h, ADL_LENGTH + 24, 3Ch, ADL_LENGTH + 18, 39h, ADL_LENGTH + 2, 37h, 32h, 37h, ADL_LENGTH + 4, 39h, ADL_LENGTH + 20
    db 37h, ADL_LENGTH + 18, 39h, ADL_LENGTH + 2, 37h, 32h, 39h, ADL_LENGTH + 24, 3Ch, ADL_LENGTH + 18, 39h, ADL_LENGTH + 2
    db 37h, 32h, 37h, ADL_LENGTH + 4, 39h, ADL_LENGTH + 20, 37h, ADL_LENGTH + 18, 40h, ADL_LENGTH + 2, 3Eh, 3Ch
    db 39h, ADL_LENGTH + 24, 35h, ADL_LENGTH + 18, 40h, ADL_LENGTH + 2, 3Eh, 3Ch, 39h, ADL_LENGTH + 24, 37h, ADL_LENGTH + 18
    db 40h, ADL_LENGTH + 2, 3Eh, 3Ch, 39h, ADL_LENGTH + 24, 35h, ADL_LENGTH + 18, 40h, ADL_LENGTH + 2, 3Eh, 3Ch
    db 39h, ADL_LENGTH + 24, 37h, ADL_JUMP
    dw offset Tune5Pattern_2879
Tune5Pattern_28C7 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 68h, 21h, 26h, 2Bh, 26h, 2Bh, 2Dh, ADL_JUMP
    dw offset Tune5Pattern_2879
; Tune 6: tempo 5 timer ticks per step, 9 voices, order list per voice.
Tune6 db 5, 9
    dw offset Tune6Order0, offset Tune6Order1, offset Tune6Order2, offset Tune6Order3
    dw offset Tune6Order4, offset Tune6Order5, offset Tune6Order6, offset Tune6Order7
    dw offset Tune6Order8
Tune6Order0 label word
    dw offset Tune6Pattern_28FB
Tune6Order1 label word
    dw offset Tune6Pattern_293F
Tune6Order2 label word
    dw offset Tune6Pattern_2954
Tune6Order3 label word
    dw offset Tune6Pattern_2961
Tune6Order4 label word
    dw offset Tune6Pattern_299E
Tune6Order5 label word
    dw offset Tune6Pattern_29AB
Tune6Order6 label word
    dw offset Tune6Pattern_29B8
Tune6Order7 label word
    dw offset Tune6Pattern_29C5
Tune6Order8 label word
    dw offset Tune6Pattern_2AC8
Tune6Pattern_28FB label byte
    db ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, 0Ch, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, 0Ch
    db ADL_REST, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_JUMP
    dw offset Tune6Pattern_28FB
Tune6Pattern_293F label byte
    db ADL_LENGTH + 12, ADL_INSTRUMENT + 2, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_JUMP
    dw offset Tune6Pattern_293F
Tune6Pattern_2954 label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 3
Tune6Pattern_2956 label byte
    db 12h, ADL_REST, 12h, ADL_REST, 12h, ADL_REST, 12h, ADL_REST, ADL_JUMP
    dw offset Tune6Pattern_2956
Tune6Pattern_2961 label byte
    db ADL_INSTRUMENT + 4, ADL_TRANSPOSE, 0Ch, ADL_LENGTH + 2, 06h, 0Ah, 0Dh, 06h, 0Ah, 0Dh, 06h, 0Ah
    db 0Dh, 06h, 0Ah, 0Dh, 06h, 0Ah, 0Dh, 06h, 0Ah, 0Dh, 06h, 0Ah
    db 0Dh, 06h, 0Ah, 0Dh, 08h, 0Dh, 0Fh, 08h, 0Dh, 0Fh, 08h, 0Dh
    db 0Fh, 08h, 0Dh, 0Fh, 08h, 0Dh, 0Fh, 08h, 0Dh, 0Fh, 08h, 0Dh
    db 0Fh, 08h, 0Dh, 0Fh
Tune6Pattern_2995 label byte
    db 0Ah, 0Fh, 11h, 0Ah, 0Fh, 11h, ADL_JUMP
    dw offset Tune6Pattern_2995
Tune6Pattern_299E label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 27h, ADL_TIE, 29h, ADL_TIE
Tune6Pattern_29A4 label byte
    db 2Bh, ADL_TIE, ADL_TIE, ADL_TIE, ADL_JUMP
    dw offset Tune6Pattern_29A4
Tune6Pattern_29AB label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 1Eh, ADL_TIE, 20h, ADL_TIE
Tune6Pattern_29B1 label byte
    db 22h, ADL_TIE, ADL_TIE, ADL_TIE, ADL_JUMP
    dw offset Tune6Pattern_29B1
Tune6Pattern_29B8 label byte
    db ADL_INSTRUMENT + 5, ADL_LENGTH + 24, 23h, ADL_TIE, 25h, ADL_TIE
Tune6Pattern_29BE label byte
    db 27h, ADL_TIE, ADL_TIE, ADL_TIE, ADL_JUMP
    dw offset Tune6Pattern_29BE
Tune6Pattern_29C5 label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 2, 33h, ADL_REST, 33h, 31h, ADL_REST, ADL_LENGTH + 12, 33h, ADL_LENGTH + 2, ADL_REST, 33h
    db ADL_REST, 33h, 31h, ADL_REST, ADL_LENGTH + 12, 33h, ADL_LENGTH + 2, ADL_REST, 35h, ADL_REST, 35h, 33h
    db ADL_REST, ADL_LENGTH + 12, 35h, ADL_LENGTH + 2, ADL_REST, 35h, ADL_REST, 35h, 33h, ADL_REST, ADL_LENGTH + 12, 35h
    db ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h
    db ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h
    db ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h
    db ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ADL_REST, 37h, 35h
    db ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h
    db ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ADL_CARRIER_VOLUME, 6Eh, 37h, ADL_REST, 37h, 35h, ADL_REST
    db ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2
    db 3Ah, 37h, 35h, 33h, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2
    db ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h
    db 33h, ADL_CARRIER_VOLUME, 64h, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST
    db 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h
    db 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h
    db 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ADL_CARRIER_VOLUME, 5Ah, 37h
    db ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h
    db ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ADL_REST, 37h, 35h
    db ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h
    db ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ADL_CARRIER_VOLUME, 50h
Tune6Pattern_2AB0 label byte
    db 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h
    db 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ADL_JUMP
    dw offset Tune6Pattern_2AB0
Tune6Pattern_2AC8 label byte
    db ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 6Ch, ADL_LENGTH + 2, ADL_REST, 33h, ADL_REST, 33h, 31h, ADL_REST, ADL_LENGTH + 12, 33h
    db ADL_LENGTH + 2, ADL_REST, 33h, ADL_REST, 33h, 31h, ADL_REST, ADL_LENGTH + 12, 33h, ADL_LENGTH + 2, ADL_REST, 35h
    db ADL_REST, 35h, 33h, ADL_REST, ADL_LENGTH + 12, 35h, ADL_LENGTH + 2, ADL_REST, 35h, ADL_REST, 35h, 33h
    db ADL_REST, ADL_LENGTH + 12, 35h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h
    db ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h
    db 35h, 33h, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h
    db ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h
    db ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h
    db ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ADL_CARRIER_VOLUME, 5Ah, 37h, ADL_REST
    db 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST
    db ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h, ADL_REST, 37h, 35h, ADL_REST
    db ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2
    db 3Ah, 37h, 35h, 33h, ADL_CARRIER_VOLUME, 50h, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12
    db 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah
    db 37h, 35h, 33h, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST
    db 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h
    db ADL_CARRIER_VOLUME, 46h, 37h, ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h
    db ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, 37h
    db ADL_REST, 37h, 35h, ADL_REST, ADL_LENGTH + 12, 37h, ADL_LENGTH + 2, ADL_REST, 37h, ADL_REST, 37h, 35h
    db ADL_REST, ADL_LENGTH + 6, 37h, ADL_LENGTH + 2, 3Ah, 37h, 35h, 33h, ADL_CARRIER_VOLUME, 3Ch, ADL_JUMP
    dw offset Tune6Pattern_2AB0
; Tune 7: tempo 5 timer ticks per step, 9 voices, order list per voice.
Tune7 db 5, 9
    dw offset Tune7Order0, offset Tune7Order1, offset Tune7Order2, offset Tune7Order3
    dw offset Tune7Order4, offset Tune7Order5, offset Tune7Order6, offset Tune7Order7
    dw offset Tune7Order8
Tune7Order0 label word
    dw offset Tune7Pattern_2C7B
Tune7Order1 label word
    dw offset Tune7Pattern_2CB4
Tune7Order2 label word
    dw offset Tune7Pattern_2CCE
Tune7Order3 label word
    dw offset Tune7Pattern_2CE3
Tune7OrderLoop_2BD5 label word
    dw offset Tune7Pattern_2CE5
    dw offset Tune7Pattern_2CE5
    dw offset Tune7Pattern_2D46
    dw offset Tune7Pattern_2CE5
    dw offset Tune7Pattern_2CE5
    dw offset Tune7Pattern_2D46
    dw offset Tune7Pattern_30BD
    dw offset Tune7Pattern_2D46
    dw offset Tune7Pattern_30C0
    dw offset Tune7Pattern_2D46
    dw offset Tune7Pattern_30BA
    dw 0, offset Tune7OrderLoop_2BD5
Tune7Order4 label word
    dw offset Tune7Pattern_2DA7
Tune7OrderLoop_2BF1 label word
    dw offset Tune7Pattern_2DAA
    dw offset Tune7Pattern_2DAA
    dw offset Tune7Pattern_2DD5
    dw offset Tune7Pattern_2DAA
    dw offset Tune7Pattern_2DAA
    dw offset Tune7Pattern_2DD5
    dw offset Tune7Pattern_30C6
    dw offset Tune7Pattern_2DD5
    dw offset Tune7Pattern_30C9
    dw offset Tune7Pattern_2DD5
    dw offset Tune7Pattern_30C3
    dw 0, offset Tune7OrderLoop_2BF1
Tune7Order5 label word
    dw offset Tune7Pattern_2DDF
Tune7OrderLoop_2C0D label word
    dw offset Tune7Pattern_2DE2
    dw offset Tune7Pattern_2DE2
    dw offset Tune7Pattern_2E0D
    dw offset Tune7Pattern_2DE2
    dw offset Tune7Pattern_2DE2
    dw offset Tune7Pattern_2E0D
    dw offset Tune7Pattern_30C6
    dw offset Tune7Pattern_2E0D
    dw offset Tune7Pattern_30C9
    dw offset Tune7Pattern_2E0D
    dw offset Tune7Pattern_30C3
    dw 0, offset Tune7OrderLoop_2C0D
Tune7Order6 label word
    dw offset Tune7Pattern_2E17
Tune7OrderLoop_2C29 label word
    dw offset Tune7Pattern_2E1A
    dw offset Tune7Pattern_2E1A
    dw offset Tune7Pattern_2E45
    dw offset Tune7Pattern_2E1A
    dw offset Tune7Pattern_2E1A
    dw offset Tune7Pattern_2E45
    dw offset Tune7Pattern_30C6
    dw offset Tune7Pattern_2E45
    dw offset Tune7Pattern_30C9
    dw offset Tune7Pattern_2E45
    dw offset Tune7Pattern_30C3
    dw 0, offset Tune7OrderLoop_2C29
Tune7Order7 label word
    dw offset RestPattern4
    dw offset RestPattern4
Tune7OrderLoop_2C47 label word
    dw offset Tune7Pattern_2E52
    dw offset Tune7Pattern_30C3
    dw offset Tune7Pattern_2ED7
    dw offset Tune7Pattern_2F1B
    dw offset Tune7Pattern_30C3
    dw offset Tune7Pattern_2ED7
    dw offset Tune7Pattern_30C6
    dw offset Tune7Pattern_2ED7
    dw offset Tune7Pattern_30C9
    dw offset Tune7Pattern_2ED7
    dw 0, offset Tune7OrderLoop_2C47
Tune7Order8 label word
    dw offset RestPattern4
    dw offset RestPattern4
Tune7OrderLoop_2C63 label word
    dw offset Tune7Pattern_2F82
    dw offset Tune7Pattern_30C3
    dw offset Tune7Pattern_3009
    dw offset Tune7Pattern_3051
    dw offset Tune7Pattern_30C3
    dw offset Tune7Pattern_3009
    dw offset Tune7Pattern_30C6
    dw offset Tune7Pattern_3009
    dw offset Tune7Pattern_30C9
    dw offset Tune7Pattern_3009
    dw 0, offset Tune7OrderLoop_2C63
Tune7Pattern_2C7B label byte
    db ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, 0Eh
    db ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, 0Ch
    db ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 4, ADL_INSTRUMENT + 0, 0Ch
    db ADL_LENGTH + 2, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, ADL_LENGTH + 6, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 2
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_JUMP
    dw offset Tune7Pattern_2C7B
Tune7Pattern_2CB4 label byte
    db ADL_INSTRUMENT + 2, ADL_LENGTH + 6, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh
    db ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_JUMP
    dw offset Tune7Pattern_2CB4
Tune7Pattern_2CCE label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 6
Tune7Pattern_2CD0 label byte
    db 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, ADL_REST, ADL_JUMP
    dw offset Tune7Pattern_2CD0
Tune7Pattern_2CE3 label byte
    db ADL_INSTRUMENT + 4, ADL_LENGTH + 2
Tune7Pattern_2CE5 label byte
    db 12h, 12h, 12h, 12h, ADL_REST, 12h, 12h, 12h, 12h, 15h, ADL_REST, 15h
    db 12h, 12h, 12h, 12h, ADL_REST, 12h, 12h, 12h, 12h, 15h, ADL_REST, 15h
    db 10h, 10h, 10h, 10h, ADL_REST, 10h, 10h, 10h, 10h, 10h, ADL_REST, 10h
    db 0Eh, 0Eh, 0Eh, 0Eh, ADL_REST, 0Eh, 10h, 10h, 10h, 10h, ADL_REST, 10h
    db 12h, 12h, 12h, 12h, ADL_REST, 12h, 12h, 12h, 12h, 15h, ADL_REST, 15h
    db 12h, 12h, 12h, 12h, ADL_REST, 12h, 12h, 12h, 12h, 15h, ADL_REST, 15h
    db 10h, 10h, 10h, 10h, ADL_REST, 10h, 10h, 10h, 10h, 10h, ADL_REST, 10h
    db 0Eh, 0Eh, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_REST, 0Eh
    db ADL_END_PATTERN
Tune7Pattern_2D46 label byte
    db 0Dh, 0Dh, 0Dh, 0Dh, ADL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ADL_REST, 10h
    db 0Dh, 0Dh, 0Dh, 0Dh, ADL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ADL_REST, 10h
    db 08h, 08h, 08h, 08h, ADL_REST, 08h, 08h, 08h, 08h, 0Bh, ADL_REST, 0Bh
    db 08h, 08h, 08h, 08h, ADL_REST, 08h, 08h, 08h, 08h, 08h, ADL_REST, 08h
    db 0Dh, 0Dh, 0Dh, 0Dh, ADL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ADL_REST, 10h
    db 0Dh, 0Dh, 0Dh, 0Dh, ADL_REST, 0Dh, 0Dh, 0Dh, 0Dh, 10h, ADL_REST, 10h
    db 09h, 09h, 09h, 09h, ADL_REST, 09h, 09h, 09h, 09h, 09h, ADL_REST, 09h
    db 0Bh, 0Bh, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, ADL_REST, 0Bh
    db ADL_END_PATTERN
Tune7Pattern_2DA7 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 76h
Tune7Pattern_2DAA label byte
    db ADL_LENGTH + 15, 2Ah, ADL_LENGTH + 3, ADL_REST, 28h, ADL_REST, ADL_LENGTH + 15, 2Ah, ADL_LENGTH + 3, ADL_REST, 28h, ADL_REST
    db ADL_LENGTH + 24, 28h, ADL_LENGTH + 9, 26h, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 9, 28h, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 15, 2Ah
    db ADL_LENGTH + 3, ADL_REST, 28h, ADL_REST, ADL_LENGTH + 15, 2Ah, ADL_LENGTH + 3, ADL_REST, 28h, ADL_REST, ADL_LENGTH + 24, 28h
    db ADL_LENGTH + 9, 26h, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 12, 26h, ADL_END_PATTERN
Tune7Pattern_2DD5 label byte
    db ADL_LENGTH + 24, 25h, ADL_TIE, 20h, ADL_REST, 25h, ADL_TIE, ADL_TIE, 23h, ADL_END_PATTERN
Tune7Pattern_2DDF label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 76h
Tune7Pattern_2DE2 label byte
    db ADL_LENGTH + 15, 2Dh, ADL_LENGTH + 3, ADL_REST, 2Dh, ADL_REST, ADL_LENGTH + 15, 2Dh, ADL_LENGTH + 3, ADL_REST, 2Dh, ADL_REST
    db ADL_LENGTH + 24, 2Ch, ADL_LENGTH + 9, 2Bh, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 9, 2Ch, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 15, 2Dh
    db ADL_LENGTH + 3, ADL_REST, 2Dh, ADL_REST, ADL_LENGTH + 15, 2Dh, ADL_LENGTH + 3, ADL_REST, 2Dh, ADL_REST, ADL_LENGTH + 24, 2Ch
    db ADL_LENGTH + 9, 2Bh, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 12, 2Ah, ADL_END_PATTERN
Tune7Pattern_2E0D label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, 23h, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_END_PATTERN
Tune7Pattern_2E17 label byte
    db ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 76h
Tune7Pattern_2E1A label byte
    db ADL_LENGTH + 15, 31h, ADL_LENGTH + 3, ADL_REST, 31h, ADL_REST, ADL_LENGTH + 15, 31h, ADL_LENGTH + 3, ADL_REST, 31h, ADL_REST
    db ADL_LENGTH + 24, 2Fh, ADL_LENGTH + 9, 2Fh, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 9, 2Fh, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 15, 31h
    db ADL_LENGTH + 3, ADL_REST, 31h, ADL_REST, ADL_LENGTH + 15, 31h, ADL_LENGTH + 3, ADL_REST, 31h, ADL_REST, ADL_LENGTH + 24, 2Fh
    db ADL_LENGTH + 9, 2Fh, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 12, 2Dh, ADL_END_PATTERN
Tune7Pattern_2E45 label byte
    db ADL_LENGTH + 24, 28h, ADL_TIE, ADL_REST, ADL_LENGTH + 12, 1Eh, 20h, ADL_LENGTH + 24, 28h, ADL_TIE, 21h, 27h
    db ADL_END_PATTERN
Tune7Pattern_2E52 label byte
    db ADL_INSTRUMENT + 7, ADL_TRANSPOSE, 0Ch, ADL_BEND
    dw 0002h
    db 04h, 36h, ADL_LENGTH + 24, 36h, ADL_TIE, ADL_LENGTH + 2, 39h, 38h, 36h, 39h, 38h, 36h
    db 38h, 36h, 34h, 38h, 36h, 34h, ADL_LENGTH + 24, 31h, ADL_LENGTH + 6, 38h, ADL_LENGTH + 4, 31h
    db ADL_LENGTH + 6, 38h, ADL_LENGTH + 2, 31h, ADL_LENGTH + 4, 38h, ADL_LENGTH + 22, 39h, ADL_LENGTH + 2, ADL_REST, 2Ah, 2Ch
    db 2Dh, 31h, 2Dh, 2Ch, 2Ah, 2Ch, 2Ah, 2Ch, 2Dh, 2Ch, 28h, ADL_LENGTH + 14
    db 2Ah, ADL_LENGTH + 10, ADL_REST, ADL_LENGTH + 2, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h
    db 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h
    db 2Fh, 2Dh, 2Fh, 31h, ADL_LENGTH + 16, 38h, ADL_LENGTH + 2, 36h, ADL_LENGTH + 4, 39h, ADL_LENGTH + 24, 3Bh
    db ADL_LENGTH + 2, ADL_REST, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h
    db 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h
    db 3Bh, 3Dh, 42h, 45h, 44h, 42h, 40h, 42h, 40h, 3Dh, 40h, 3Dh
    db 3Bh, 39h, ADL_LENGTH + 18, 36h, ADL_LENGTH + 6, ADL_REST, ADL_END_PATTERN
Tune7Pattern_2ED7 label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 2, 4Ch, 4Eh, 49h, 4Ch, 4Eh, 50h, 4Ch, 4Eh, 49h, 4Ch
    db 4Eh, 50h, 4Ch, 4Eh, 49h, 4Ch, 4Eh, 50h, 4Ch, 4Eh, 49h, 4Ch
    db 4Eh, 50h, ADL_LENGTH + 16, 50h, ADL_LENGTH + 8, 51h, ADL_LENGTH + 21, 50h, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 2, 4Ch
    db 4Eh, 49h, 4Ch, 4Eh, 50h, 4Ch, 4Eh, 49h, 4Ch, 4Eh, 50h, 4Ch
    db 4Eh, 49h, 4Ch, 4Eh, 50h, 4Ch, 4Eh, 49h, 4Ch, 4Eh, 50h, ADL_LENGTH + 16
    db 51h, ADL_LENGTH + 2, 50h, 51h, ADL_TIE, ADL_LENGTH + 26, 53h, ADL_END_PATTERN
Tune7Pattern_2F1B label byte
    db ADL_INSTRUMENT + 7, ADL_TRANSPOSE, 0Ch, ADL_LENGTH + 9, 38h, ADL_LENGTH + 32, 31h, ADL_LENGTH + 5, ADL_REST, ADL_LENGTH + 2, 36h, ADL_LENGTH + 6
    db 39h, ADL_LENGTH + 3, 31h, ADL_LENGTH + 13, 34h, ADL_LENGTH + 2, 2Ch, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 6, 2Ah, 2Dh
    db ADL_LENGTH + 8, 2Ah, ADL_LENGTH + 6, 2Ch, ADL_LENGTH + 10, 2Dh, ADL_LENGTH + 2, 2Fh, ADL_LENGTH + 4, 31h, ADL_LENGTH + 26, 2Fh
    db ADL_LENGTH + 2, 34h, ADL_LENGTH + 14, 36h, ADL_LENGTH + 2, 38h, ADL_LENGTH + 4, 39h, ADL_LENGTH + 26, 36h, ADL_LENGTH + 6, 39h
    db 3Dh, ADL_LENGTH + 16, 45h, ADL_LENGTH + 2, 42h, ADL_LENGTH + 4, 45h, ADL_LENGTH + 6, 42h, ADL_LENGTH + 8, 3Dh, ADL_LENGTH + 4
    db 42h, ADL_LENGTH + 2, 3Dh, ADL_LENGTH + 16, 39h, ADL_LENGTH + 2, 38h, 39h, 38h, ADL_LENGTH + 18, 36h, ADL_LENGTH + 2
    db 34h, ADL_LENGTH + 4, 38h, ADL_LENGTH + 2, 39h, ADL_LENGTH + 4, 38h, ADL_LENGTH + 6, 34h, 36h, 31h, ADL_LENGTH + 20
    db 34h, ADL_LENGTH + 4, 2Ch, ADL_LENGTH + 6, 34h, ADL_LENGTH + 2, 2Ch, ADL_LENGTH + 6, 34h, ADL_LENGTH + 2, 2Ch, 34h
    db ADL_LENGTH + 6, 2Dh, ADL_LENGTH + 14, 2Ah, ADL_LENGTH + 6, ADL_REST, ADL_END_PATTERN
Tune7Pattern_2F82 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 68h, ADL_BEND
    dw 0002h
    db 04h, 36h, ADL_LENGTH + 24, 36h, ADL_TIE, ADL_LENGTH + 2, 39h, 38h, 36h, 39h, 38h, 36h
    db 38h, 36h, 34h, 38h, 36h, 34h, ADL_LENGTH + 24, 31h, ADL_LENGTH + 6, 38h, ADL_LENGTH + 4, 31h
    db ADL_LENGTH + 6, 38h, ADL_LENGTH + 2, 31h, ADL_LENGTH + 4, 38h, ADL_LENGTH + 22, 39h, ADL_LENGTH + 2, ADL_REST, 2Ah, 2Ch
    db 2Dh, 31h, 2Dh, 2Ch, 2Ah, 2Ch, 2Ah, 2Ch, 2Dh, 2Ch, 28h, ADL_LENGTH + 14
    db 2Ah, ADL_LENGTH + 10, ADL_REST, ADL_LENGTH + 2, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h
    db 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 31h, 2Fh, 31h
    db 2Fh, 2Dh, 2Fh, 31h, ADL_LENGTH + 16, 38h, ADL_LENGTH + 2, 36h, ADL_LENGTH + 4, 39h, ADL_LENGTH + 24, 3Bh
    db ADL_LENGTH + 2, ADL_REST, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h
    db 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h, 3Bh, 3Dh, 3Bh, 3Dh, 3Bh, 39h
    db 3Bh, 3Dh, 42h, 45h, 44h, 42h, 40h, 42h, 40h, 3Dh, 40h, 3Dh
    db 3Bh, 39h, ADL_LENGTH + 18, 36h, ADL_LENGTH + 4, ADL_REST, ADL_END_PATTERN
Tune7Pattern_3009 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_INSTRUMENT + 6, ADL_CARRIER_VOLUME, 70h, ADL_LENGTH + 2, 28h, 2Ah, 25h, 28h, 2Ah, 2Ch
    db 28h, 2Ah, 25h, 28h, 2Ah, 2Ch, 28h, 2Ah, 25h, 28h, 2Ah, 2Ch
    db 28h, 2Ah, 25h, 28h, 2Ah, 2Ch, ADL_LENGTH + 16, 2Ch, ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 21, 2Ch
    db ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 2, 28h, 2Ah, 25h, 28h, 2Ah, 2Ch, 28h, 2Ah, 25h
    db 28h, 2Ah, 2Ch, 28h, 2Ah, 25h, 28h, 2Ah, 2Ch, 28h, 2Ah, 25h
    db 28h, 2Ah, 2Ch, ADL_LENGTH + 16, 2Dh, ADL_LENGTH + 2, 2Ch, 2Dh, ADL_TIE, ADL_LENGTH + 24, 2Fh, ADL_END_PATTERN
Tune7Pattern_3051 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_INSTRUMENT + 7, ADL_CARRIER_VOLUME, 68h, ADL_LENGTH + 9, 38h, ADL_LENGTH + 32, 31h, ADL_LENGTH + 5, ADL_REST, ADL_LENGTH + 2
    db 36h, ADL_LENGTH + 6, 39h, ADL_LENGTH + 3, 31h, ADL_LENGTH + 13, 34h, ADL_LENGTH + 2, 2Ch, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 6
    db 2Ah, 2Dh, ADL_LENGTH + 8, 2Ah, ADL_LENGTH + 6, 2Ch, ADL_LENGTH + 10, 2Dh, ADL_LENGTH + 2, 2Fh, ADL_LENGTH + 4, 31h
    db ADL_LENGTH + 26, 2Fh, ADL_LENGTH + 2, 34h, ADL_LENGTH + 14, 36h, ADL_LENGTH + 2, 38h, ADL_LENGTH + 4, 39h, ADL_LENGTH + 26, 36h
    db ADL_LENGTH + 6, 39h, 3Dh, ADL_LENGTH + 16, 45h, ADL_LENGTH + 2, 42h, ADL_LENGTH + 4, 45h, ADL_LENGTH + 6, 42h, ADL_LENGTH + 8
    db 3Dh, ADL_LENGTH + 4, 42h, ADL_LENGTH + 2, 3Dh, ADL_LENGTH + 16, 39h, ADL_LENGTH + 2, 38h, 39h, 38h, ADL_LENGTH + 18
    db 36h, ADL_LENGTH + 2, 34h, ADL_LENGTH + 4, 38h, ADL_LENGTH + 2, 39h, ADL_LENGTH + 4, 38h, ADL_LENGTH + 6, 34h, 36h
    db 31h, ADL_LENGTH + 20, 34h, ADL_LENGTH + 4, 2Ch, ADL_LENGTH + 6, 34h, ADL_LENGTH + 2, 2Ch, ADL_LENGTH + 6, 34h, ADL_LENGTH + 2
    db 2Ch, 34h, ADL_LENGTH + 6, 2Dh, ADL_LENGTH + 14, 2Ah, ADL_LENGTH + 4, ADL_REST, ADL_END_PATTERN
Tune7Pattern_30BA label byte
    db ADL_TRANSPOSE, 00h, ADL_END_PATTERN
Tune7Pattern_30BD label byte
    db ADL_TRANSPOSE, 02h, ADL_END_PATTERN
Tune7Pattern_30C0 label byte
    db ADL_TRANSPOSE, 03h, ADL_END_PATTERN
Tune7Pattern_30C3 label byte
    db ADL_TRANSPOSE, 0E8h, ADL_END_PATTERN
Tune7Pattern_30C6 label byte
    db ADL_TRANSPOSE, 0EAh, ADL_END_PATTERN
Tune7Pattern_30C9 label byte
    db ADL_TRANSPOSE, 0EBh, ADL_END_PATTERN
; Unreferenced: three more transpose patterns of the same shape as those before.
    db ADL_TRANSPOSE, 0F4h, ADL_END_PATTERN
    db ADL_TRANSPOSE, 0F6h, ADL_END_PATTERN
    db ADL_TRANSPOSE, 0F7h, ADL_END_PATTERN
; Tune 8: tempo 4 timer ticks per step, 8 voices, order list per voice.
Tune8 db 4, 8
    dw offset Tune8Order0, offset Tune8Order1, offset Tune8Order2, offset Tune8Order3
    dw offset Tune8Order4, offset Tune8Order5, offset Tune8Order6, offset Tune8Order7
Tune8Order0 label word
    dw offset Tune8Pattern_3139
Tune8Order1 label word
    dw offset Tune8Pattern_3148
Tune8Order2 label word
    dw offset Tune8Pattern_3152
Tune8Order3 label word
    dw offset Tune8Pattern_315B
    dw offset Tune8Pattern_315B
Tune8OrderLoop_30F1 label word
    dw offset Tune8Pattern_315B
    dw offset Tune8Pattern_315B
    dw offset Tune8Pattern_31BE
    dw offset Tune8Pattern_315B
    dw 0, offset Tune8OrderLoop_30F1
Tune8Order4 label word
    dw offset Tune8Pattern_321F
    dw offset Tune8Pattern_321F
Tune8OrderLoop_3101 label word
    dw offset Tune8Pattern_3229
    dw offset Tune8Pattern_3229
    dw offset Tune8Pattern_323C
    dw offset Tune8Pattern_3229
    dw 0, offset Tune8OrderLoop_3101
Tune8Order5 label word
    dw offset Tune8Pattern_324F
    dw offset Tune8Pattern_324F
Tune8OrderLoop_3111 label word
    dw offset Tune8Pattern_3259
    dw offset Tune8Pattern_3259
    dw offset Tune8Pattern_326E
    dw offset Tune8Pattern_3259
    dw 0, offset Tune8OrderLoop_3111
Tune8Order6 label word
    dw offset Tune8Pattern_3281
    dw offset Tune8Pattern_3281
Tune8OrderLoop_3121 label word
    dw offset Tune8Pattern_328C
    dw offset Tune8Pattern_328C
    dw offset Tune8Pattern_3297
    dw 0, offset Tune8OrderLoop_3121
Tune8Order7 label word
    dw offset Tune8Pattern_32B5
    dw offset Tune8Pattern_32B5
Tune8OrderLoop_312F label word
    dw offset Tune8Pattern_32C0
    dw offset Tune8Pattern_32C0
    dw offset Tune8Pattern_32D2
    dw 0, offset Tune8OrderLoop_312F
Tune8Pattern_3139 label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_LENGTH + 10, ADL_REST
    db ADL_JUMP
    dw offset Tune8Pattern_3139
Tune8Pattern_3148 label byte
    db ADL_LENGTH + 12, ADL_REST, ADL_INSTRUMENT + 2
Tune8Pattern_314B label byte
    db 0Eh, ADL_REST, 0Eh, ADL_REST, ADL_JUMP
    dw offset Tune8Pattern_314B
Tune8Pattern_3152 label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 6
Tune8Pattern_3154 label byte
    db 12h, 12h, 12h, 12h, ADL_JUMP
    dw offset Tune8Pattern_3154
Tune8Pattern_315B label byte
    db ADL_INSTRUMENT + 4, ADL_LENGTH + 2, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST, 0Eh, ADL_REST
    db 0Eh, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST
    db 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST
    db 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST
    db 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST, 11h, ADL_REST
    db 11h, ADL_REST, ADL_END_PATTERN
Tune8Pattern_31BE label byte
    db 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST
    db 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST
    db 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST
    db 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST, 0Ch, ADL_REST
    db 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST
    db 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST
    db 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST
    db 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST, 0Fh, ADL_REST
    db ADL_END_PATTERN
Tune8Pattern_321F label byte
    db ADL_INSTRUMENT + 9, ADL_LENGTH + 32, 21h, ADL_TIE, ADL_TIE, 24h, ADL_TIE, ADL_TIE, ADL_INSTRUMENT + 12, ADL_END_PATTERN
Tune8Pattern_3229 label byte
    db ADL_LENGTH + 24, 15h, ADL_LENGTH + 12, 17h, 18h, 15h, ADL_TIE, 17h, 18h, ADL_LENGTH + 24, 15h, ADL_LENGTH + 12
    db 17h, 18h, 15h, ADL_TIE, 17h, 18h, ADL_END_PATTERN
Tune8Pattern_323C label byte
    db ADL_LENGTH + 24, 13h, ADL_LENGTH + 12, 17h, 18h, 13h, ADL_TIE, 17h, 18h, ADL_LENGTH + 24, 13h, ADL_LENGTH + 12
    db 17h, 18h, 13h, ADL_TIE, 17h, 18h, ADL_END_PATTERN
Tune8Pattern_324F label byte
    db ADL_INSTRUMENT + 9, ADL_LENGTH + 32, 26h, ADL_TIE, ADL_TIE, 29h, ADL_TIE, ADL_TIE, ADL_INSTRUMENT + 12, ADL_END_PATTERN
Tune8Pattern_3259 label byte
    db ADL_CARRIER_VOLUME, 70h, ADL_LENGTH + 24, 21h, ADL_LENGTH + 12, 23h, 24h, 21h, ADL_TIE, 23h, 24h, ADL_LENGTH + 24
    db 21h, ADL_LENGTH + 12, 23h, 24h, 21h, ADL_TIE, 23h, 24h, ADL_END_PATTERN
Tune8Pattern_326E label byte
    db ADL_LENGTH + 24, 1Fh, ADL_LENGTH + 12, 23h, 24h, 1Fh, ADL_TIE, 23h, 24h, ADL_LENGTH + 24, 1Fh, ADL_LENGTH + 12
    db 23h, 24h, 1Fh, ADL_TIE, 23h, 24h, ADL_END_PATTERN
Tune8Pattern_3281 label byte
    db ADL_INSTRUMENT + 12, ADL_CARRIER_VOLUME, 66h, ADL_LENGTH + 32, 21h, ADL_TIE, ADL_TIE, 24h, ADL_TIE, ADL_TIE, ADL_END_PATTERN
Tune8Pattern_328C label byte
    db ADL_INSTRUMENT + 13, ADL_LENGTH + 24, 3Ch, ADL_TIE, ADL_TIE, ADL_TIE, 3Ch, ADL_TIE, 39h, ADL_TIE, ADL_END_PATTERN
Tune8Pattern_3297 label byte
    db ADL_LENGTH + 24, 37h, ADL_TIE, ADL_TIE, ADL_TIE, 3Ah, ADL_TIE, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST
    db ADL_REST, ADL_REST, ADL_LENGTH + 13, ADL_REST, ADL_LENGTH + 1, 40h, ADL_REST, 40h, ADL_LENGTH + 9, ADL_REST, ADL_LENGTH + 1, 40h
    db ADL_REST, 40h, ADL_LENGTH + 22, ADL_REST, ADL_REST, ADL_END_PATTERN
Tune8Pattern_32B5 label byte
    db ADL_INSTRUMENT + 12, ADL_CARRIER_VOLUME, 66h, ADL_LENGTH + 32, 26h, ADL_TIE, ADL_TIE, 29h, ADL_TIE, ADL_TIE, ADL_END_PATTERN
Tune8Pattern_32C0 label byte
    db ADL_INSTRUMENT + 13, ADL_LENGTH + 18, 3Ah, 39h, ADL_TIE, ADL_TIE, ADL_TIE, ADL_LENGTH + 6, ADL_REST, ADL_LENGTH + 18, 3Ah, 39h
    db ADL_LENGTH + 12, 37h, ADL_LENGTH + 24, 35h, ADL_TIE, ADL_END_PATTERN
Tune8Pattern_32D2 label byte
    db ADL_LENGTH + 24, 34h, ADL_TIE, ADL_TIE, ADL_TIE, 33h, ADL_TIE, 3Ch, 3Fh, 3Eh, ADL_TIE, ADL_TIE
    db ADL_TIE, ADL_REST, ADL_LENGTH + 13, ADL_REST, ADL_LENGTH + 1, 45h, ADL_REST, 45h, ADL_LENGTH + 9, ADL_REST, ADL_LENGTH + 1, 45h
    db ADL_REST, 45h, ADL_LENGTH + 22, ADL_REST, ADL_REST, ADL_END_PATTERN
; Tune 9: tempo 5 timer ticks per step, 9 voices, order list per voice.
Tune9 db 5, 9
    dw offset Tune9Order0, offset Tune9Order1, offset Tune9Order2, offset Tune9Order3
    dw offset Tune9Order4, offset Tune9Order5, offset Tune9Order6, offset Tune9Order7
    dw offset Tune9Order8
Tune9Order0 label word
    dw offset Tune9Pattern_338C
    dw offset Tune9Pattern_338D
    dw offset Tune9Pattern_340A
    dw offset Tune9Pattern_350C
    dw offset Tune9Pattern_340A
    dw 0, offset Tune9Order0
Tune9Order1 label word
    dw offset Tune9Pattern_358C
    dw offset Tune9Pattern_358E
    dw offset Tune9Pattern_35EF
    dw offset Tune9Pattern_36B1
    dw offset Tune9Pattern_35EF
    dw 0, offset Tune9Order1
Tune9Order2 label word
    dw offset Tune9Pattern_3713
Tune9Order3 label word
    dw offset Tune9Pattern_371C
    dw offset Tune9Pattern_371F
    dw offset Tune9Pattern_3779
    dw offset Tune9Pattern_3779
    dw offset Tune9Pattern_37DB
    dw offset Tune9Pattern_37DB
    dw offset Tune9Pattern_3779
    dw offset Tune9Pattern_3779
    dw 0, offset Tune9Order3
Tune9Order4 label word
    dw offset Tune9Pattern_380C
    dw offset Tune9Pattern_380D
    dw offset Tune9Pattern_3817
    dw offset Tune9Pattern_3817
    dw offset Tune9Pattern_3821
    dw offset Tune9Pattern_3817
    dw offset Tune9Pattern_3817
    dw 0, offset Tune9Order4
Tune9Order5 label word
    dw offset Tune9Pattern_382B
    dw offset Tune9Pattern_382C
    dw offset Tune9Pattern_3836
    dw offset Tune9Pattern_3836
    dw offset Tune9Pattern_3840
    dw offset Tune9Pattern_3836
    dw offset Tune9Pattern_3836
    dw 0, offset Tune9Order5
Tune9Order6 label word
    dw offset Tune9Pattern_384A
    dw offset Tune9Pattern_384B
    dw offset Tune9Pattern_3855
    dw offset Tune9Pattern_3855
    dw offset Tune9Pattern_385F
    dw offset Tune9Pattern_3855
    dw offset Tune9Pattern_3855
    dw 0, offset Tune9Order6
Tune9Order7 label word
    dw offset RestPattern8
    dw offset Tune9Pattern_3869
    dw offset Tune9Pattern_3883
    dw offset Tune9Pattern_38EC
    dw offset Tune9Pattern_38EC
    dw offset Tune9Pattern_390E
    dw 0, offset Tune9Order7
Tune9Order8 label word
    dw offset RestPattern8
    dw offset Tune9Pattern_3986
    dw offset Tune9Pattern_39A4
    dw offset Tune9Pattern_38EC
    dw offset Tune9Pattern_38EC
    dw offset Tune9Pattern_390E
    dw 0, offset Tune9Order8
Tune9Pattern_338C label byte
    db ADL_LENGTH + 2
Tune9Pattern_338D label byte
    db ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch
    db ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST
    db ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch
    db ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST
    db ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, ADL_INSTRUMENT + 1
    db 0Eh, 0Eh, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST
    db ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch
    db ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch
    db ADL_INSTRUMENT + 1, 0Eh, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune9Pattern_340A label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, 0Eh, 0Eh, ADL_INSTRUMENT + 0
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, 0Eh, ADL_REST, ADL_END_PATTERN
Tune9Pattern_350C label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, ADL_INSTRUMENT + 1, 0Eh, 0Eh, ADL_REST
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune9Pattern_358C label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 2
Tune9Pattern_358E label byte
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, 0Eh
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db ADL_END_PATTERN
Tune9Pattern_35EF label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh
    db ADL_REST, ADL_END_PATTERN
Tune9Pattern_36B1 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh
    db 0Eh, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, ADL_END_PATTERN
Tune9Pattern_3713 label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 6
Tune9Pattern_3715 label byte
    db 12h, 12h, 12h, 12h, ADL_JUMP
    dw offset Tune9Pattern_3715
Tune9Pattern_371C label byte
    db ADL_INSTRUMENT + 4, ADL_TRANSPOSE, 0Ch
Tune9Pattern_371F label byte
    db ADL_LENGTH + 2, 09h, ADL_TIE, 09h, 09h, 09h, 09h, 09h, ADL_TIE, 09h, 09h, 09h
    db 09h, 09h, ADL_TIE, 09h, 09h, 09h, 09h, ADL_LENGTH + 4, 09h, 09h, 09h, 09h
    db ADL_LENGTH + 2, 09h, 09h, 09h, 09h, 09h, ADL_TIE, 09h, 09h, 09h, 09h, 09h
    db ADL_TIE, 09h, 09h, 09h, 09h, ADL_LENGTH + 4, 09h, 09h, 09h, 09h, ADL_LENGTH + 2, 09h
    db 09h, 09h, 09h, 09h, ADL_TIE, 09h, 09h, 09h, 09h, 09h, ADL_TIE, 09h
    db 09h, 09h, 09h, ADL_LENGTH + 4, 09h, 09h, 09h, 09h, ADL_LENGTH + 2, 09h, 09h, 09h
    db 09h, 09h, ADL_TIE, 09h, 09h, 09h, 09h, 09h, ADL_TIE, 09h, 09h, 09h
    db 09h, ADL_LENGTH + 4, 09h, 09h, 09h, ADL_END_PATTERN
Tune9Pattern_3779 label byte
    db ADL_LENGTH + 2, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h, 13h, 09h
    db 13h, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h
    db 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h, 0Eh, 09h
    db 0Eh, 09h, 0Dh, 09h, 0Eh, 09h, 10h, 09h, 0Dh, 09h, 0Eh, 09h
    db 10h, 09h, 0Dh, 09h, 0Eh, 09h, 10h, 09h, 0Dh, 09h, 0Eh, 09h
    db 10h, ADL_END_PATTERN
Tune9Pattern_37DB label byte
    db 09h, ADL_TIE, 09h, 09h, 09h, 09h, 09h, ADL_TIE, 09h, 09h, 09h, 09h
    db 09h, ADL_TIE, 09h, 09h, 09h, 09h, 09h, ADL_TIE, 09h, 09h, 09h, 09h
    db 07h, ADL_TIE, 07h, 07h, 07h, 07h, 07h, ADL_TIE, 07h, 07h, 07h, 07h
    db 09h, ADL_TIE, 09h, 09h, 09h, 09h, 09h, ADL_TIE, 09h, 09h, 09h, 09h
    db ADL_END_PATTERN
Tune9Pattern_380C label byte
    db ADL_INSTRUMENT + 5
Tune9Pattern_380D label byte
    db ADL_LENGTH + 24, 26h, ADL_TIE, 24h, ADL_TIE, 25h, ADL_TIE, 26h, 25h, ADL_END_PATTERN
Tune9Pattern_3817 label byte
    db ADL_LENGTH + 24, 26h, ADL_TIE, 26h, ADL_TIE, 26h, ADL_TIE, 26h, 25h, ADL_END_PATTERN
Tune9Pattern_3821 label byte
    db ADL_LENGTH + 24, 26h, 26h, 26h, 28h, 26h, 26h, 26h, 28h, ADL_END_PATTERN
Tune9Pattern_382B label byte
    db ADL_INSTRUMENT + 5
Tune9Pattern_382C label byte
    db ADL_LENGTH + 24, 23h, ADL_TIE, 1Fh, ADL_TIE, 21h, ADL_TIE, 21h, 21h, ADL_END_PATTERN
Tune9Pattern_3836 label byte
    db ADL_LENGTH + 24, 23h, ADL_TIE, 23h, ADL_TIE, 21h, ADL_TIE, 21h, 21h, ADL_END_PATTERN
Tune9Pattern_3840 label byte
    db ADL_LENGTH + 24, 21h, 23h, 23h, 25h, 21h, 23h, 23h, 25h, ADL_END_PATTERN
Tune9Pattern_384A label byte
    db ADL_INSTRUMENT + 5
Tune9Pattern_384B label byte
    db ADL_LENGTH + 24, 1Fh, ADL_TIE, 1Ch, ADL_TIE, 1Ch, ADL_TIE, 1Eh, 1Ch, ADL_END_PATTERN
Tune9Pattern_3855 label byte
    db ADL_LENGTH + 24, 1Fh, ADL_TIE, 1Fh, ADL_TIE, 1Eh, ADL_TIE, 1Ch, 1Ch, ADL_END_PATTERN
Tune9Pattern_385F label byte
    db ADL_LENGTH + 24, 1Eh, 1Eh, 1Fh, 21h, 1Eh, 1Eh, 1Fh, 21h, ADL_END_PATTERN
Tune9Pattern_3869 label byte
    db ADL_INSTRUMENT + 9, ADL_LENGTH + 10, 26h, ADL_LENGTH + 8, 2Ah, ADL_LENGTH + 30, 21h, ADL_LENGTH + 10, 24h, ADL_LENGTH + 8, 28h, ADL_LENGTH + 30
    db 21h, ADL_LENGTH + 10, 32h, ADL_LENGTH + 8, 36h, ADL_LENGTH + 30, 2Dh, ADL_LENGTH + 10, 26h, ADL_LENGTH + 8, 28h, ADL_LENGTH + 30
    db 25h, ADL_END_PATTERN
Tune9Pattern_3883 label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 24, 32h, ADL_LENGTH + 2, 39h, 37h, 36h, 37h, 36h, 34h, 36h, 34h
    db 32h, 34h, 32h, 31h, ADL_LENGTH + 24, 2Dh, ADL_LENGTH + 12, 31h, 32h, ADL_LENGTH + 28, 36h, ADL_LENGTH + 2
    db 34h, ADL_LENGTH + 4, 36h, ADL_LENGTH + 12, 39h, ADL_LENGTH + 2, 37h, 31h, 32h, 31h, 2Dh, 31h
    db 32h, 31h, 2Dh, 31h, 32h, 31h, 2Dh, ADL_LENGTH + 21, 28h, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 18
    db 34h, ADL_LENGTH + 4, 32h, ADL_LENGTH + 21, 2Dh, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 2, 2Fh, 31h, 34h, ADL_LENGTH + 17
    db 32h, ADL_LENGTH + 1, ADL_REST, ADL_LENGTH + 2, 2Fh, 2Dh, 2Fh, ADL_LENGTH + 17, 2Ah, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 2
    db 25h, 26h, 28h, 2Ah, 2Bh, 2Ah, ADL_LENGTH + 10, 2Dh, ADL_LENGTH + 2, 31h, 32h, 34h
    db 32h, ADL_LENGTH + 18, 36h, ADL_LENGTH + 2, 32h, 34h, 2Dh, 32h, 34h, 2Dh, 32h, 34h
    db 2Dh, 32h, 34h, 2Dh, ADL_LENGTH + 21, 31h, ADL_LENGTH + 3, ADL_REST, ADL_END_PATTERN
Tune9Pattern_38EC label byte
    db ADL_LENGTH + 2, 32h, 39h, 32h, 2Dh, 32h, 39h, 32h, 2Dh, 32h, 39h, 32h
    db 2Dh, ADL_LENGTH + 22, 36h, ADL_LENGTH + 2, ADL_REST, 32h, 39h, 32h, 2Dh, 32h, 39h, 32h
    db 2Dh, 32h, 39h, 32h, 36h, ADL_LENGTH + 22, 39h, ADL_LENGTH + 2, ADL_REST, ADL_END_PATTERN
Tune9Pattern_390E label byte
    db ADL_LENGTH + 18, 34h, ADL_LENGTH + 4, 32h, ADL_LENGTH + 6, 31h, 2Fh, 31h, ADL_LENGTH + 8, 32h, ADL_LENGTH + 6, 36h
    db ADL_LENGTH + 4, 34h, ADL_LENGTH + 6, 32h, 31h, ADL_LENGTH + 24, 2Dh, ADL_LENGTH + 2, 32h, 31h, 2Fh, ADL_LENGTH + 18
    db 2Dh, ADL_LENGTH + 2, 2Bh, 2Ah, 28h, ADL_LENGTH + 12, 26h, ADL_LENGTH + 2, 28h, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 2
    db 2Bh, ADL_LENGTH + 6, 2Dh, 2Fh, ADL_LENGTH + 4, 31h, 32h, 34h, ADL_LENGTH + 22, 31h, ADL_LENGTH + 2, 37h
    db 3Bh, 37h, 32h, 37h, 3Bh, 37h, ADL_LENGTH + 9, 32h, ADL_LENGTH + 1, ADL_REST, ADL_LENGTH + 2, 37h
    db 3Bh, 37h, 32h, 37h, 3Bh, 37h, ADL_LENGTH + 9, 32h, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 2, 3Bh
    db 39h, 37h, 36h, 34h, 32h, 37h, 36h, 34h, 32h, 34h, 32h, 31h
    db 2Fh, 31h, 2Fh, 2Dh, 2Fh, 2Bh, 2Ah, 28h, 2Bh, 2Ah, 28h, ADL_LENGTH + 16
    db 26h, ADL_LENGTH + 2, 36h, 32h, 2Dh, 32h, ADL_LENGTH + 16, 36h, ADL_LENGTH + 2, 32h, 2Dh, ADL_LENGTH + 4
    db 32h, ADL_LENGTH + 10, 34h, ADL_LENGTH + 8, 32h, ADL_LENGTH + 6, 31h, ADL_LENGTH + 22, 2Dh, ADL_LENGTH + 2, ADL_REST, ADL_END_PATTERN
Tune9Pattern_3986 label byte
    db ADL_INSTRUMENT + 9, ADL_CARRIER_VOLUME, 60h, ADL_LENGTH + 2, ADL_REST, ADL_LENGTH + 10, 26h, ADL_LENGTH + 8, 2Ah, ADL_LENGTH + 30, 21h, ADL_LENGTH + 10
    db 24h, ADL_LENGTH + 8, 28h, ADL_LENGTH + 30, 21h, ADL_LENGTH + 10, 32h, ADL_LENGTH + 8, 36h, ADL_LENGTH + 30, 2Dh, ADL_LENGTH + 10
    db 26h, ADL_LENGTH + 8, 28h, ADL_LENGTH + 28, 25h, ADL_END_PATTERN
Tune9Pattern_39A4 label byte
    db ADL_CARRIER_VOLUME, 78h, ADL_LENGTH + 24, 32h, ADL_LENGTH + 2, 39h, 37h, 36h, 37h, 36h, 34h, 36h
    db 34h, 32h, 34h, 32h, 31h, ADL_LENGTH + 24, 2Dh, ADL_LENGTH + 12, 31h, 32h, ADL_LENGTH + 28, 36h
    db ADL_LENGTH + 2, 34h, ADL_LENGTH + 4, 36h, ADL_LENGTH + 12, 39h, ADL_LENGTH + 2, 37h, 31h, 32h, 31h, 2Dh
    db 31h, 32h, 31h, 2Dh, 31h, 32h, 31h, 2Dh, ADL_LENGTH + 21, 28h, ADL_LENGTH + 3, ADL_REST
    db ADL_LENGTH + 18, 34h, ADL_LENGTH + 4, 32h, ADL_LENGTH + 21, 2Dh, ADL_LENGTH + 3, ADL_REST, ADL_LENGTH + 2, 2Fh, 31h, 34h
    db ADL_LENGTH + 17, 32h, ADL_LENGTH + 1, ADL_REST, ADL_LENGTH + 2, 2Fh, 2Dh, 2Fh, ADL_LENGTH + 17, 2Ah, ADL_LENGTH + 3, ADL_REST
    db ADL_LENGTH + 2, 25h, 26h, 28h, 2Ah, 2Bh, 2Ah, ADL_LENGTH + 10, 2Dh, ADL_LENGTH + 2, 31h, 32h
    db 34h, 32h, ADL_LENGTH + 18, 36h, ADL_LENGTH + 2, 32h, 34h, 2Dh, 32h, 34h, 2Dh, 32h
    db 34h, 2Dh, 32h, 34h, 2Dh, ADL_LENGTH + 21, 31h, ADL_LENGTH + 3, ADL_REST, ADL_END_PATTERN
; Tune 10: tempo 4 timer ticks per step, 9 voices, order list per voice.
Tune10 db 4, 9
    dw offset Tune10Order0, offset Tune10Order1, offset Tune10Order2, offset Tune10Order3
    dw offset Tune10Order4, offset Tune10Order5, offset Tune10Order6, offset Tune10Order7
    dw offset Tune10Order8
Tune10Order0 label word
    dw offset Tune10Pattern_3B08
    dw offset Tune10Pattern_3B08
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw offset Tune10Pattern_3B33
    dw 0, offset Tune10Order0
Tune10Order1 label word
    dw offset Tune10Pattern_3B73
    dw offset Tune10Pattern_3B73
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw offset Tune10Pattern_3B93
    dw 0, offset Tune10Order1
Tune10Order2 label word
    dw offset Tune10Pattern_3BC5
    dw offset Tune10Pattern_3BC5
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw offset Tune10Pattern_3BD0
    dw 0, offset Tune10Voice2Tail
Tune10Order3 label word
    dw offset Tune10Pattern_3BE2
    dw offset Tune10Pattern_3BE3
    dw offset Tune10Pattern_3BE9
    dw offset Tune10Pattern_3BE9
    dw offset Tune10Pattern_3C4B
    dw offset Tune10Pattern_3BE9
    dw offset Tune10Pattern_3BE9
    dw offset Tune10Pattern_3C4B
    dw 0, offset Tune10Order3
Tune10Order4 label word
    dw offset Tune10Pattern_3D0D
    dw offset Tune10Pattern_3D0E
    dw offset Tune10Pattern_3D14
    dw offset Tune10Pattern_3D14
    dw offset Tune10Pattern_3D1E
    dw offset Tune10Pattern_3D14
    dw offset Tune10Pattern_3D14
    dw offset Tune10Pattern_3D1E
    dw 0, offset Tune10Order4
Tune10Order5 label word
    dw offset Tune10Pattern_3D30
    dw offset Tune10Pattern_3D31
    dw offset Tune10Pattern_3D37
    dw offset Tune10Pattern_3D37
    dw offset Tune10Pattern_3D41
    dw offset Tune10Pattern_3D37
    dw offset Tune10Pattern_3D37
    dw offset Tune10Pattern_3D41
    dw 0, offset Tune10Order5
Tune10Order6 label word
    dw offset Tune10Pattern_3D53
    dw offset Tune10Pattern_3D54
    dw offset Tune10Pattern_3D5A
    dw offset Tune10Pattern_3D5A
    dw offset Tune10Pattern_3D64
    dw offset Tune10Pattern_3D5A
    dw offset Tune10Pattern_3D5A
    dw offset Tune10Pattern_3D64
    dw 0, offset Tune10Order6
Tune10Order7 label word
    dw offset Tune10Pattern_3D76
    dw offset Tune10Pattern_3D81
    dw offset Tune10Pattern_3DEA
    dw offset Tune10Pattern_3E35
    dw offset Tune10Pattern_3DEA
    dw 0, offset Tune10Order7
Tune10Order8 label word
    dw offset RestPattern4
    dw offset Tune10Pattern_3E8E
    dw offset Tune10Pattern_3E96
    dw offset Tune10Pattern_3F01
    dw offset Tune10Pattern_3F4E
    dw offset Tune10Pattern_3F01
    dw 0, offset Tune10Order8
Tune10Pattern_3B08 label byte
    db ADL_LENGTH + 12, ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_REST, ADL_LENGTH + 12
    db ADL_INSTRUMENT + 0, 0Ch, ADL_LENGTH + 2, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh, ADL_REST, ADL_REST, ADL_LENGTH + 6, ADL_INSTRUMENT + 0
    db 0Ch, 0Ch, 0Ch, 0Ch, ADL_LENGTH + 2, ADL_INSTRUMENT + 1, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune10Pattern_3B33 label byte
    db ADL_LENGTH + 2, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST
    db 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST
    db ADL_REST, ADL_INSTRUMENT + 0, 0Ch, ADL_REST, 0Ch, ADL_INSTRUMENT + 1, 0Eh, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune10Pattern_3B73 label byte
    db ADL_LENGTH + 12, ADL_REST, ADL_LENGTH + 2, ADL_INSTRUMENT + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_LENGTH + 14, ADL_REST, ADL_LENGTH + 2
    db 0Eh, 0Eh, 0Eh, 0Eh, ADL_LENGTH + 28, ADL_REST, ADL_LENGTH + 2, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, ADL_END_PATTERN
Tune10Pattern_3B93 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST
    db ADL_REST, ADL_REST, ADL_REST, ADL_REST, 0Eh, ADL_REST, ADL_REST, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh
    db 0Eh, ADL_END_PATTERN
Tune10Pattern_3BC5 label byte
    db ADL_INSTRUMENT + 3, ADL_LENGTH + 12, 19h, ADL_REST, 19h, ADL_REST, 19h, ADL_REST, ADL_REST, ADL_REST, ADL_END_PATTERN
Tune10Pattern_3BD0 label byte
    db ADL_LENGTH + 6, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h, 12h
    db 12h, 12h, 12h, 12h, 12h, ADL_END_PATTERN
Tune10Pattern_3BE2 label byte
    db ADL_INSTRUMENT + 4
Tune10Pattern_3BE3 label byte
    db ADL_LENGTH + 24, 13h, 10h, 0Bh, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3BE9 label byte
    db ADL_LENGTH + 2, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST
    db 0Eh, 10h, ADL_REST, 10h, 10h, ADL_REST, 10h, 10h, ADL_REST, 10h, 10h, ADL_REST
    db 10h, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, ADL_END_PATTERN
Tune10Pattern_3C4B label byte
    db ADL_LENGTH + 2, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 10h, ADL_REST, 10h, 10h, ADL_REST, 10h, 10h, ADL_REST, 10h, 10h, ADL_REST
    db 10h, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST, 0Bh, 0Bh, ADL_REST
    db 0Bh, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST, 13h, 13h, ADL_REST
    db 13h, 10h, ADL_REST, 10h, 10h, ADL_REST, 10h, 10h, ADL_REST, 10h, 10h, ADL_REST
    db 10h, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST
    db 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST, 0Eh, 0Eh, ADL_REST
    db 0Eh, ADL_END_PATTERN
Tune10Pattern_3D0D label byte
    db ADL_INSTRUMENT + 5
Tune10Pattern_3D0E label byte
    db ADL_LENGTH + 24, 2Bh, 28h, 2Ah, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D14 label byte
    db ADL_LENGTH + 24, 1Eh, ADL_TIE, ADL_TIE, ADL_TIE, 21h, 23h, 1Eh, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D1E label byte
    db ADL_LENGTH + 24, 2Bh, ADL_TIE, 2Ah, ADL_TIE, 2Bh, ADL_TIE, 2Ah, ADL_TIE, 2Bh, 2Bh, 2Ah
    db ADL_TIE, 2Bh, 2Bh, 2Ah, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D30 label byte
    db ADL_INSTRUMENT + 5
Tune10Pattern_3D31 label byte
    db ADL_LENGTH + 24, 26h, 25h, 26h, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D37 label byte
    db ADL_LENGTH + 24, 1Ah, ADL_TIE, ADL_TIE, ADL_TIE, 1Eh, 20h, 1Ah, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D41 label byte
    db ADL_LENGTH + 24, 26h, ADL_TIE, 26h, ADL_TIE, 26h, ADL_TIE, 26h, ADL_TIE, 26h, 28h, 26h
    db ADL_TIE, 26h, 28h, 26h, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D53 label byte
    db ADL_INSTRUMENT + 5
Tune10Pattern_3D54 label byte
    db ADL_LENGTH + 24, 23h, 21h, 23h, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D5A label byte
    db ADL_LENGTH + 24, 17h, ADL_TIE, ADL_TIE, ADL_TIE, 1Ah, 1Ch, 17h, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D64 label byte
    db ADL_LENGTH + 24, 23h, ADL_TIE, 23h, ADL_TIE, 23h, ADL_TIE, 23h, ADL_TIE, 23h, 23h, 23h
    db ADL_TIE, 23h, 23h, 21h, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D76 label byte
    db ADL_INSTRUMENT + 7, ADL_LENGTH + 24, 3Eh, 3Dh, 3Bh, ADL_TIE, 32h, 31h, 2Fh, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3D81 label byte
    db ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 28h, ADL_LENGTH + 14, 2Ah, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 2, 2Ah
    db ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 14, 2Fh, ADL_LENGTH + 10, 32h, ADL_LENGTH + 8, 31h, ADL_LENGTH + 6, 2Fh, ADL_LENGTH + 2, 31h
    db 2Fh, 2Dh, 31h, ADL_TIE, 2Dh, 31h, 2Fh, ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 24, 2Ah, ADL_LENGTH + 10
    db 2Ah, ADL_LENGTH + 8, 28h, ADL_LENGTH + 6, 26h, ADL_LENGTH + 10, 28h, ADL_LENGTH + 18, 26h, ADL_TIE, ADL_LENGTH + 2, ADL_REST
    db ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 28h, ADL_LENGTH + 14, 2Ah, ADL_LENGTH + 2, 2Dh, 2Bh, 2Ah
    db 28h, 26h, 25h, ADL_LENGTH + 6, 23h, ADL_LENGTH + 2, 25h, 23h, 21h, ADL_LENGTH + 24, 1Eh, ADL_LENGTH + 9
    db 25h, 26h, ADL_LENGTH + 6, 23h, ADL_LENGTH + 2, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, ADL_LENGTH + 24, 2Ah, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3DEA label byte
    db ADL_LENGTH + 30, 2Dh, ADL_LENGTH + 4, 2Bh, ADL_LENGTH + 6, 2Ah, 2Bh, ADL_LENGTH + 20, 2Ah, ADL_LENGTH + 4, 28h, ADL_LENGTH + 26
    db 26h, ADL_LENGTH + 24, 2Dh, ADL_LENGTH + 2, 32h, 31h, 2Fh, 31h, 2Fh, 2Dh, 2Fh, 2Dh
    db ADL_LENGTH + 6, 2Bh, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 23, 2Ah, ADL_TIE, ADL_LENGTH + 2, 2Bh, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 18
    db 2Fh, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 2Fh, ADL_LENGTH + 18, 32h, ADL_LENGTH + 2, 31h, ADL_LENGTH + 6, 32h, ADL_LENGTH + 4
    db 31h, ADL_LENGTH + 19, 2Fh, ADL_TIE, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 2, 2Bh, ADL_LENGTH + 6, 2Dh, ADL_LENGTH + 4, 2Fh
    db ADL_LENGTH + 6, 31h, ADL_LENGTH + 2, ADL_REST, ADL_LENGTH + 6, 32h, ADL_LENGTH + 4, 34h, ADL_LENGTH + 6, 36h, 37h, ADL_LENGTH + 25
    db 36h, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3E35 label byte
    db ADL_LENGTH + 2, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h
    db 28h, ADL_LENGTH + 22, 2Ah, ADL_LENGTH + 2, ADL_REST, 25h, 26h, 25h, 26h, 25h, 26h, 25h
    db 26h, 25h, 26h, 25h, 26h, ADL_LENGTH + 24, 23h, ADL_LENGTH + 10, 28h, ADL_LENGTH + 8, 2Bh, ADL_LENGTH + 6
    db 2Ah, ADL_LENGTH + 10, 28h, ADL_LENGTH + 8, 26h, ADL_LENGTH + 6, 25h, ADL_LENGTH + 24, 23h, ADL_TIE, ADL_LENGTH + 10, 28h
    db ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 10, 28h, ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 6, 28h, 2Bh, ADL_LENGTH + 10, 2Ah, ADL_LENGTH + 8
    db 28h, ADL_LENGTH + 6, 2Bh, ADL_LENGTH + 24, 2Ah, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 6, 2Bh, ADL_LENGTH + 12, 2Ah, ADL_LENGTH + 2
    db 2Bh, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 6, 28h, ADL_LENGTH + 12, 26h, ADL_LENGTH + 2, 26h, 28h, 26h, 25h
    db ADL_LENGTH + 18, 23h, ADL_LENGTH + 24, 2Ah, ADL_END_PATTERN
Tune10Pattern_3E8E label byte
    db ADL_INSTRUMENT + 9, ADL_CARRIER_VOLUME, 70h, 26h, 28h, 2Ah, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3E96 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 28h, ADL_LENGTH + 14, 2Ah, ADL_LENGTH + 4, 2Dh
    db ADL_LENGTH + 2, 2Ah, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 14, 2Fh, ADL_LENGTH + 10, 32h, ADL_LENGTH + 8, 31h, ADL_LENGTH + 6, 2Fh
    db ADL_LENGTH + 2, 31h, 2Fh, 2Dh, 31h, ADL_TIE, 2Dh, 31h, 2Fh, ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 24
    db 2Ah, ADL_LENGTH + 10, 2Ah, ADL_LENGTH + 8, 28h, ADL_LENGTH + 6, 26h, ADL_LENGTH + 10, 28h, ADL_LENGTH + 18, 26h, ADL_TIE
    db ADL_LENGTH + 2, ADL_REST, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 28h, ADL_LENGTH + 14, 2Ah, ADL_LENGTH + 2, 2Dh
    db 2Bh, 2Ah, 28h, 26h, 25h, ADL_LENGTH + 6, 23h, ADL_LENGTH + 2, 25h, 23h, 21h, ADL_LENGTH + 24
    db 1Eh, ADL_LENGTH + 9, 25h, 26h, ADL_LENGTH + 6, 23h, ADL_LENGTH + 2, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, 26h, 28h, 26h, 28h, 26h, ADL_LENGTH + 23, 2Ah, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3F01 label byte
    db ADL_LENGTH + 2, ADL_REST, ADL_LENGTH + 30, 2Dh, ADL_LENGTH + 4, 2Bh, ADL_LENGTH + 6, 2Ah, 2Bh, ADL_LENGTH + 20, 2Ah, ADL_LENGTH + 4
    db 28h, ADL_LENGTH + 26, 26h, ADL_LENGTH + 24, 2Dh, ADL_LENGTH + 2, 32h, 31h, 2Fh, 31h, 2Fh, 2Dh
    db 2Fh, 2Dh, ADL_LENGTH + 6, 2Bh, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 23, 2Ah, ADL_TIE, ADL_LENGTH + 2, 2Bh, ADL_LENGTH + 4
    db 2Dh, ADL_LENGTH + 18, 2Fh, ADL_LENGTH + 2, 2Dh, ADL_LENGTH + 4, 2Fh, ADL_LENGTH + 18, 32h, ADL_LENGTH + 2, 31h, ADL_LENGTH + 6
    db 32h, ADL_LENGTH + 4, 31h, ADL_LENGTH + 19, 2Fh, ADL_TIE, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 2, 2Bh, ADL_LENGTH + 6, 2Dh
    db ADL_LENGTH + 4, 2Fh, ADL_LENGTH + 6, 31h, ADL_LENGTH + 2, ADL_REST, ADL_LENGTH + 6, 32h, ADL_LENGTH + 4, 34h, ADL_LENGTH + 6, 36h
    db 37h, ADL_LENGTH + 24, 36h, ADL_TIE, ADL_END_PATTERN
Tune10Pattern_3F4E label byte
    db ADL_LENGTH + 2, ADL_REST, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h, 26h, 28h
    db 26h, 28h, ADL_LENGTH + 22, 2Ah, ADL_LENGTH + 2, ADL_REST, 25h, 26h, 25h, 26h, 25h, 26h
    db 25h, 26h, 25h, 26h, 25h, 26h, ADL_LENGTH + 24, 23h, ADL_LENGTH + 10, 28h, ADL_LENGTH + 8, 2Bh
    db ADL_LENGTH + 6, 2Ah, ADL_LENGTH + 10, 28h, ADL_LENGTH + 8, 26h, ADL_LENGTH + 6, 25h, ADL_LENGTH + 24, 23h, ADL_TIE, ADL_LENGTH + 10
    db 28h, ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 10, 28h, ADL_LENGTH + 8, 2Dh, ADL_LENGTH + 6, 28h, 2Bh, ADL_LENGTH + 10, 2Ah
    db ADL_LENGTH + 8, 28h, ADL_LENGTH + 6, 2Bh, ADL_LENGTH + 24, 2Ah, ADL_LENGTH + 4, 2Dh, ADL_LENGTH + 6, 2Bh, ADL_LENGTH + 12, 2Ah
    db ADL_LENGTH + 2, 2Bh, ADL_LENGTH + 4, 2Ah, ADL_LENGTH + 6, 28h, ADL_LENGTH + 12, 26h, ADL_LENGTH + 2, 26h, 28h, 26h
    db 25h, ADL_LENGTH + 18, 23h, ADL_LENGTH + 22, 2Ah, ADL_END_PATTERN
Tune10Voice2Tail label word
    dw offset RestPattern8
    dw 0, offset Tune10Voice2Tail
RestPattern8 label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_END_PATTERN
RestPattern4 label byte
    db ADL_LENGTH + 24, ADL_REST, ADL_REST, ADL_REST, ADL_REST, ADL_END_PATTERN
driver ends
end
