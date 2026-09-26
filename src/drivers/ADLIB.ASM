; Modern optional-module source; historical source filename unknown.
; Original resource: ADLIB.ENC; no relocation table in ENC stream.
locals
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
    mov word ptr ds:[di + 0Ch], bx
    mov al, byte ptr ds:[di + 011h]
    mov byte ptr ds:[di + 1], al
    ret
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
    mov si, 0355h
    add si, ax
    jmp word ptr ds:[si]
loc_00135:
    sub al, 0DFh
    mov byte ptr ds:[di + 011h], al
    jmp short loc_000F7
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
; UNKNOWN: not yet classified as code or data
    db 08Ah,044h,0Ch,0D0h,0E0h,0D0h,0E0h,024h,0C0h,0Ah,0E0h,08Ah,045h,05h,04h,040h
    db 0E8h,0DBh,03h,05Eh,05Bh,0E9h,076h,0FFh
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
; UNKNOWN: not yet classified as code or data
    db 082h,03h,013h,01h,09h,01h,091h,02h,0A1h,03h,0AAh,03h,0B6h,03h,0BDh,03h
    db 03Ch,01h,0CBh,03h,0D6h,03h,0E7h,03h,0FEh,03h,0C4h,03h
loc_00371:
    mov bx, word ptr ds:[bx]
    mov cx, word ptr ds:[bx]
    inc bx
    inc bx
    mov word ptr ds:[di + 0Ah], bx
    mov word ptr ds:[di + 0Ch], cx
    mov bx, cx
    jmp near ptr loc_000F7
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
    mov al, byte ptr ds:[bx]
    inc bx
    mov byte ptr ds:[di + 012h], al
    jmp near ptr loc_000F7
; UNKNOWN: not yet classified as code or data
    db 08Bh,045h,08h,0E8h,0A7h,01h,032h,0C0h,088h,045h,010h,0C3h,0C6h,045h,013h,01h
    db 0E9h,03Ah,0FDh,0C6h,045h,013h,0FFh,0E9h,033h,0FDh,0C6h,045h,013h,00h,0E9h,02Ch
    db 0FDh
    mov bx, word ptr ds:[bx]
    mov al, byte ptr ds:[8]
    mov byte ptr ds:[05Fh], al
    jmp near ptr loc_000F7
; UNKNOWN: not yet classified as code or data
    db 08Bh,07h,089h,045h,016h,043h,043h,08Bh,07h,089h,045h,018h,043h,043h,0E9h,010h
    db 0FDh,08Bh,07h,089h,045h,01Ah,043h,043h,08Bh,07h,089h,045h,01Ch,043h,043h,08Ah
    db 07h,088h,045h,01Dh,043h,0E9h,0F9h,0FCh,033h,0C0h,088h,045h,01Dh,089h,045h,01Ah
    db 0E9h,0EEh,0FCh
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
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,03h,00h,0B0h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,01h,04h,01h,0B1h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,02h,05h,02h,0B2h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,08h,0Bh,03h,0B3h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,09h,0Ch,04h,0B4h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,0Ah,0Dh,05h,0B5h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,010h,013h,06h,0B6h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,011h,014h,07h,0B7h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,012h,015h,08h,0B8h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 03Fh,03Fh,03Eh,03Eh,03Dh,03Dh,03Ch,03Ch,03Bh,03Bh,03Ah,03Ah,039h,039h,038h,038h
    db 037h,037h,036h,036h,035h,035h,034h,034h,033h,033h,032h,032h,031h,031h,030h,030h
    db 02Fh,02Fh,02Eh,02Eh,02Dh,02Dh,02Ch,02Ch,02Bh,02Bh,02Ah,02Ah,029h,029h,028h,028h
    db 027h,027h,026h,026h,025h,025h,024h,024h,023h,023h,022h,022h,021h,021h,020h,020h
    db 01Fh,01Fh,01Eh,01Eh,01Dh,01Dh,01Ch,01Ch,01Bh,01Bh,01Ah,01Ah,019h,019h,018h,018h
    db 017h,017h,016h,016h,015h,015h,014h,014h,013h,013h,012h,012h,011h,011h,010h,010h
    db 0Fh,0Fh,0Eh,0Eh,0Dh,0Dh,0Ch,0Ch,0Bh,0Bh,0Ah,0Ah,09h,09h,08h,08h
    db 07h,07h,06h,06h,05h,05h,04h,04h,03h,03h,02h,02h,01h,01h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,08h
    db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Ch,0Ch,0Ch,0Ch,0Ch
    db 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,010h,010h,010h,010h,010h,010h,010h,010h,010h
    db 010h,010h,010h,014h,014h,014h,014h,014h,014h,014h,014h,014h,014h,014h,014h,018h
    db 018h,018h,018h,018h,018h,018h,018h,018h,018h,018h,018h,01Ch,01Ch,01Ch,01Ch,01Ch
    db 059h,01h,06Dh,01h,083h,01h,09Ah,01h,0B2h,01h,0CCh,01h,0E7h,01h,05h,02h
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
    db 0B2h,02h,0DBh,02h,06h,03h,034h,03h,065h,03h,099h,03h,0CFh,03h,05h,02h
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
    db 0B2h,02h,0DBh,02h,06h,03h,034h,03h,065h,03h,099h,03h,0CFh,03h,05h,02h
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
    db 0B2h,02h,0DBh,02h,06h,03h,034h,03h,065h,03h,099h,03h,0CFh,03h,05h,02h
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
    db 0E8h,0E9h,07h,08h,00h,00h,01h,00h,0FDh,06h,07Fh,07Ch,00h,00h,00h,00h
    db 0E5h,0F6h,06h,07h,00h,06h,02h,00h,0FCh,0Fh,07Fh,07Fh,00h,00h,00h,00h
    db 0E4h,0F5h,06h,07h,00h,06h,02h,00h,02h,0Fh,07Fh,07Fh,00h,00h,00h,00h
    db 0E9h,0B9h,06h,08h,0Fh,0Fh,02h,02h,030h,0Eh,07Ch,07Fh,00h,00h,00h,00h
    db 0E9h,0E9h,05h,04h,01h,03h,01h,00h,00h,08h,06Eh,07Eh,00h,00h,00h,00h
    db 093h,052h,0FEh,0FEh,020h,020h,03h,03h,0Ch,0Eh,04Eh,07Eh,00h,00h,00h,00h
    db 093h,0E1h,088h,088h,064h,062h,00h,02h,0E8h,06h,07Fh,07Fh,00h,00h,00h,00h
    db 0E7h,0F1h,011h,025h,0F1h,022h,00h,00h,0Ch,08h,07Ch,078h,00h,00h,00h,00h
    db 077h,081h,013h,025h,0F1h,022h,00h,00h,0Ch,08h,07Ch,072h,00h,00h,00h,00h
    db 0C3h,082h,088h,088h,021h,023h,02h,03h,0F4h,02h,07Fh,07Fh,00h,00h,00h,00h
    db 0E1h,081h,01h,05h,0Fh,0Fh,02h,02h,024h,0Eh,07Bh,07Fh,00h,00h,00h,00h
    db 0A2h,054h,0F8h,0F8h,060h,021h,03h,00h,0Ch,0Ah,068h,07Fh,00h,00h,00h,00h
    db 0F5h,0F2h,0FEh,0FEh,020h,020h,03h,03h,018h,0Eh,04Eh,070h,00h,00h,00h,00h
    db 082h,072h,011h,094h,062h,064h,02h,00h,0E8h,0Ch,064h,07Fh,00h,00h,00h,00h
    db 05Dh,09h,00h,0Fh,0Bh,019h,0ECh,023h,0A9h,027h,0D5h,028h,0B9h,02Bh,0D5h,030h
    db 0F0h,032h,0Eh,03Ah,05h,09h,071h,09h,083h,09h,095h,09h,0A7h,09h,0BFh,09h
    db 0D1h,09h,0E3h,09h,0F5h,09h,07h,0Ah,019h,0Ah,019h,0Ah,019h,0Ah,019h,0Ah
    db 019h,0Ah,07Ch,0Ah,0AFh,0Ah,00h,00h,073h,09h,0E2h,0Ah,0E2h,0Ah,0E2h,0Ah
    db 0E2h,0Ah,0E2h,0Ah,012h,0Bh,02Bh,0Bh,00h,00h,085h,09h,043h,0Bh,043h,0Bh
    db 043h,0Bh,043h,0Bh,043h,0Bh,055h,0Bh,066h,0Bh,00h,00h,097h,09h,077h,0Bh
    db 078h,0Bh,078h,0Bh,078h,0Bh,0AAh,0Bh,077h,0Bh,078h,0Bh,0AAh,0Bh,0Ch,0Ch
    db 03Eh,0Ch,00h,00h,0ABh,09h,04Eh,0Ch,04Eh,0Ch,059h,0Ch,04Eh,0Ch,059h,0Ch
    db 063h,0Ch,06Ch,0Ch,00h,00h,0C1h,09h,07Dh,0Ch,07Dh,0Ch,088h,0Ch,07Dh,0Ch
    db 088h,0Ch,092h,0Ch,09Bh,0Ch,00h,00h,0D3h,09h,0ACh,0Ch,0ACh,0Ch,0D4h,0Ch
    db 0ACh,0Ch,0D4h,0Ch,0B8h,03Fh,0Dh,0Dh,00h,00h,0E5h,09h,0AEh,03Fh,01Eh,0Dh
    db 069h,0Dh,087h,0Dh,069h,0Dh,0F2h,0Dh,06h,0Eh,00h,00h,0F7h,09h,0AEh,03Fh
    db 019h,0Eh,06Ah,0Eh,075h,0Eh,06Ah,0Eh,0E4h,0Eh,0EDh,0Eh,00h,00h,09h,0Ah
    db 0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h
    db 0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch
    db 0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h
    db 0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch
    db 0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,080h,0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh
    db 0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh
    db 0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0E3h,0Eh,0E1h,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A0h,0E1h,0Ch,081h,0Ch,0A1h,0E5h,0Eh,0A0h,0E1h
    db 0Ch,081h,0Ch,0A1h,0E5h,0Eh,0A0h,0E1h,0Ch,081h,0Ch,0A1h,0E5h,0Eh,0A0h,0E1h
    db 0Ch,081h,0Ch,0A1h,0E5h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh
    db 0F5h,081h,0E1h,0A0h,0Ch,0E5h,0A1h,0Eh,080h,0E5h,081h,0A2h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E3h,0Eh
    db 0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,081h,0Eh,081h,0Eh,081h,0Eh
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,080h,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh
    db 081h,0Eh,0Eh,081h,0Eh,0F7h,081h,0E5h,0Eh,080h,0A3h,0E5h,012h,012h,012h,012h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,012h,012h,012h,012h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,080h,0E5h,012h,012h
    db 012h,012h,012h,012h,012h,012h,0F7h,081h,0E5h,012h,012h,012h,012h,080h,0A4h,0E1h
    db 0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh
    db 012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh
    db 0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h
    db 080h,0E1h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h
    db 09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h
    db 09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h
    db 010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h
    db 09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,07h,07h,07h,07h,0Eh,013h
    db 07h,07h,07h,07h,0Eh,013h,06h,06h,06h,06h,0Eh,012h,06h,06h,06h,06h
    db 0Eh,012h,080h,0E1h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h
    db 0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Dh,0Dh,0Dh,0Dh
    db 014h,019h,0Eh,0Eh,0Eh,0Eh,015h,01Ah,010h,010h,010h,010h,017h,01Ch,012h,012h
    db 012h,012h,01Eh,082h,080h,0F7h,081h,081h,0E1h,017h,015h,012h,010h,012h,010h,0E3h
    db 0Eh,0Bh,0FBh,081h,080h,0A5h,0F7h,026h,028h,02Ah,082h,026h,028h,02Ah,082h,080h
    db 0F7h,025h,082h,026h,082h,025h,082h,02Bh,02Ah,080h,0F7h,025h,026h,0EBh,028h,02Ah
    db 02Dh,02Fh,080h,0F7h,081h,081h,0A7h,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h
    db 023h,0FBh,081h,080h,0A5h,0F7h,021h,023h,023h,082h,021h,023h,023h,082h,080h,0F7h
    db 023h,082h,023h,082h,023h,082h,026h,026h,080h,0F7h,023h,023h,0EBh,025h,026h,028h
    db 02Ah,080h,0F7h,081h,0A6h,081h,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h
    db 0FBh,081h,080h,0FDh,081h,0F3h,081h,081h,0A6h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh
    db 02Fh,02Dh,02Fh,032h,02Fh,032h,034h,0FDh,081h,0F3h,081h,081h,0E1h,023h,028h,02Ah
    db 02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,034h,080h,0E1h,040h,03Eh,03Bh,03Eh
    db 03Bh,039h,03Bh,039h,036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh
    db 02Ah,02Dh,02Ah,028h,0F7h,026h,082h,0E1h,040h,03Eh,03Bh,03Eh,03Bh,039h,03Bh,039h
    db 036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh,02Ah,02Dh,02Ah,028h
    db 0F7h,02Bh,02Ah,080h,0F7h,081h,081h,0A7h,0E1h,03Bh,039h,036h,034h,036h,034h,0E3h
    db 032h,02Fh,0FBh,081h,080h,0A7h,0E1h,039h,036h,032h,034h,02Fh,032h,0A8h,0E7h,036h
    db 0E1h,02Fh,032h,036h,034h,0F3h,039h,0E1h,036h,034h,032h,036h,032h,02Fh,034h,02Fh
    db 02Ah,02Fh,02Ah,028h,0F7h,08Ah,0FCh,0FFh,02Dh,01Fh,032h,0E1h,039h,036h,032h,034h
    db 036h,034h,0E7h,032h,0E1h,02Fh,032h,036h,039h,0F3h,034h,0E1h,036h,034h,032h,036h
    db 032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F7h,08Ah,0FCh,0FFh,02Dh,01Fh,032h,080h
    db 0A9h,0E8h,021h,023h,0E5h,025h,0E8h,021h,023h,0E5h,025h,0E8h,023h,025h,0FDh,026h
    db 0E8h,025h,026h,0E5h,028h,0E8h,025h,026h,0E5h,028h,0F7h,02Bh,02Ah,080h,0A7h,0E1h
    db 039h,036h,02Fh,032h,034h,036h,0A8h,0EBh,039h,0E1h,03Bh,039h,036h,0F1h,034h,0E1h
    db 039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,02Fh,02Dh,0F7h,08Ah,0FCh,0FFh
    db 02Dh,01Fh,032h,0E1h,034h,031h,02Fh,032h,031h,02Dh,034h,031h,02Fh,032h,031h,02Dh
    db 036h,032h,02Fh,034h,032h,031h,039h,036h,032h,034h,032h,02Fh,08Ah,018h,00h,00h
    db 05h,02Fh,034h,032h,02Fh,034h,032h,08Ah,018h,00h,00h,05h,02Fh,034h,032h,02Fh
    db 034h,032h,08Ah,018h,00h,00h,05h,03Bh,039h,032h,02Fh,039h,032h,08Ah,018h,00h
    db 00h,05h,03Bh,039h,032h,02Fh,039h,032h,080h,0A9h,0E8h,021h,023h,0E5h,025h,0E8h
    db 023h,025h,0E5h,026h,025h,028h,026h,02Ah,028h,02Dh,02Ah,02Fh,080h,0F8h,081h,081h
    db 0A7h,088h,06Ch,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0F9h,081h,080h
    db 0A7h,088h,06Ch,0E1h,081h,0E1h,039h,036h,032h,034h,02Fh,032h,0A8h,088h,06Ch,0E7h
    db 036h,0E1h,02Fh,032h,036h,034h,0F3h,039h,0E1h,036h,034h,032h,036h,032h,02Fh,034h
    db 02Fh,02Ah,02Fh,02Ah,028h,0F7h,08Ah,0FCh,0FFh,02Dh,01Fh,032h,0E1h,039h,036h,032h
    db 034h,036h,034h,0E7h,032h,0E1h,02Fh,032h,036h,039h,0F3h,034h,0E1h,036h,034h,032h
    db 036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F5h,08Ah,0FCh,0FFh,02Dh,01Fh,032h
    db 080h,0A5h,0F7h,021h,082h,01Fh,082h,021h,082h,021h,021h,080h,0A7h,088h,06Ch,0E1h
    db 081h,039h,036h,02Fh,032h,034h,036h,0A8h,088h,06Ch,0EBh,039h,0E1h,03Bh,039h,036h
    db 0F1h,034h,0E1h,039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,023h,02Dh,0F7h
    db 08Ah,0FCh,0FFh,02Dh,01Fh,032h,0E1h,034h,031h,02Fh,032h,031h,02Dh,034h,031h,02Fh
    db 032h,031h,02Dh,036h,032h,02Fh,034h,032h,031h,039h,036h,032h,034h,032h,02Fh,08Ah
    db 018h,00h,00h,05h,02Fh,034h,032h,02Fh,034h,032h,08Ah,018h,00h,00h,05h,02Fh
    db 034h,032h,02Fh,034h,032h,08Ah,018h,00h,00h,05h,03Bh,034h,032h,02Fh,034h,032h
    db 08Ah,018h,00h,00h,05h,03Bh,034h,032h,02Fh,034h,080h,0F7h,021h,021h,0EBh,021h
    db 021h,025h,023h,080h,0F8h,081h,081h,0A7h,088h,06Ch,0E1h,03Bh,039h,036h,034h,036h
    db 034h,0E3h,032h,02Fh,0F9h,081h,080h,06h,09h,014h,0Fh,024h,0Fh,034h,0Fh,048h
    db 0Fh,058h,0Fh,064h,0Fh,070h,0Fh,07Ch,0Fh,088h,0Fh,092h,0Fh,08Fh,010h,086h
    db 011h,086h,011h,086h,011h,086h,011h,00h,00h,014h,0Fh,0D8h,011h,09Ah,012h,05Bh
    db 013h,05Bh,013h,05Bh,013h,05Bh,013h,00h,00h,024h,0Fh,08Dh,013h,08Dh,013h,08Dh
    db 013h,08Dh,013h,037h,014h,037h,014h,037h,014h,037h,014h,00h,00h,034h,0Fh,07Ah
    db 014h,027h,015h,0D6h,015h,0D6h,015h,0D6h,015h,0D6h,015h,00h,00h,048h,0Fh,08h
    db 016h,026h,016h,04Bh,016h,04Bh,016h,00h,00h,058h,0Fh,055h,016h,073h,016h,098h
    db 016h,098h,016h,00h,00h,064h,0Fh,0A2h,016h,0C0h,016h,0E5h,016h,0E5h,016h,00h
    db 00h,070h,0Fh,0EFh,016h,0Dh,017h,032h,017h,032h,017h,00h,00h,07Ch,0Fh,03Ch
    db 017h,0C6h,017h,064h,018h,00h,00h,088h,0Fh,0E1h,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,0E7h,081h,0E1h
    db 0Ch,0A1h,0Eh,0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,081h,081h,0A1h,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,0E7h,081h,0E1h,0Ch,0A1h,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h
    db 0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h
    db 0A1h,0Eh,081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h,081h,0Eh,0Eh,081h,081h
    db 0Eh,081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0A0h,0Ch
    db 0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh
    db 0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h
    db 0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0Eh,0Eh,080h,0E1h
    db 0A2h,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
    db 081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h
    db 0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
    db 081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,0Eh
    db 0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
    db 081h,081h,0Eh,081h,0Eh,081h,081h,0E7h,081h,0E1h,081h,0Eh,0Eh,0Eh,0Eh,0Eh
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh
    db 081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
    db 081h,0Eh,081h,081h,081h,081h,081h,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 080h,0E1h,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
    db 081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh
    db 081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
    db 081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh
    db 0Eh,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
    db 081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,0E7h,081h,0E1h,081h,0Eh,0Eh,0Eh,0Eh
    db 0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h
    db 081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,080h,0E1h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
    db 081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h
    db 0Eh,0Eh,0Eh,080h,0E1h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h
    db 012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h
    db 012h,0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h
    db 012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h
    db 0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h
    db 012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h
    db 0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h
    db 012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh
    db 016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h,012h
    db 0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh
    db 016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,080h,0E1h,0A3h
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
    db 080h,0A4h,0E1h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h
    db 01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
    db 013h,018h,01Ah,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h
    db 01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
    db 013h,018h,01Ah,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh
    db 0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E2h,015h,081h,0E1h,09h
    db 081h,0E5h,015h,0FFh,081h,0E1h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh
    db 012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,015h,082h
    db 081h,09h,081h,0E5h,015h,0F5h,081h,0E1h,09h,0Bh,0Ch,0Dh,0Eh,080h,0E1h,0Eh
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh
    db 0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h
    db 013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E2h,015h,081h,0E1h,09h,081h,0E5h,015h,0FFh
    db 081h,0E1h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh
    db 0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E5h,015h,0E3h,012h,0E5h,013h
    db 0E1h,015h,0E5h,017h,0E3h,01Ah,0E5h,01Ch,0E1h,01Eh,0EBh,01Fh,080h,0E1h,07h,013h
    db 07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h
    db 07h,013h,07h,013h,07h,013h,09h,015h,09h,015h,09h,015h,09h,015h,09h,015h
    db 09h,015h,04h,010h,04h,010h,04h,010h,04h,010h,04h,010h,04h,010h,080h,0A5h
    db 0F7h,02Dh,082h,02Fh,082h,02Dh,082h,02Fh,082h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh
    db 0FFh,081h,0F7h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,080h,0F7h,02Dh,082h
    db 02Fh,082h,02Dh,082h,02Fh,082h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,0F7h
    db 02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0E7h,081h,0E3h,02Bh,0E5h,081h,0E7h,02Bh,0E5h
    db 081h,080h,0F7h,02Ah,082h,028h,026h,02Ah,082h,028h,026h,080h,0A5h,0F7h,02Ah,082h
    db 02Bh,082h,02Ah,082h,02Bh,082h,02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h
    db 02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,080h,0F7h,02Ah,082h,02Bh,082h,02Ah
    db 082h,02Bh,082h,02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h,02Ah,082h,0E3h
    db 028h,0E5h,081h,028h,0E7h,081h,0E3h,028h,0E5h,081h,0E7h,028h,0E5h,081h,080h,0F7h
    db 026h,082h,024h,023h,026h,082h,024h,023h,080h,0A5h,0F7h,028h,082h,028h,082h,028h
    db 082h,028h,082h,026h,082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h
    db 024h,0E5h,081h,024h,0FFh,081h,080h,0F7h,028h,082h,028h,082h,028h,082h,028h,082h
    db 026h,082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h,024h,0E5h,081h
    db 024h,0E7h,081h,0E3h,024h,0E5h,081h,0E7h,024h,0E5h,081h,080h,0F7h,023h,082h,021h
    db 01Fh,023h,082h,021h,01Fh,080h,0A5h,0F7h,026h,082h,024h,082h,026h,082h,024h,082h
    db 023h,082h,0E3h,021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h,0E5h,081h
    db 021h,0FFh,081h,080h,0F7h,026h,082h,024h,082h,026h,082h,024h,082h,023h,082h,0E3h
    db 021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h,0E5h,081h,021h,0E7h,081h
    db 0E3h,021h,0E5h,081h,0E7h,021h,0E5h,081h,080h,0F7h,01Fh,082h,01Dh,01Ch,01Fh,082h
    db 01Dh,01Ch,080h,0ABh,0E9h,02Dh,0E1h,02Ah,0E3h,028h,0E5h,02Ah,0F1h,026h,0E1h,028h
    db 0E5h,02Ah,0E9h,02Fh,0FBh,02Dh,0E1h,02Fh,02Dh,02Bh,02Ah,02Bh,0EFh,02Dh,0E1h,028h
    db 0E3h,02Ah,0F1h,026h,0E1h,028h,0E5h,02Ah,0E9h,02Fh,0F9h,02Dh,0E1h,02Fh,030h,032h
    db 034h,036h,039h,0A7h,02Ah,02Dh,02Fh,032h,081h,0EBh,034h,0E1h,036h,039h,036h,034h
    db 036h,034h,032h,034h,032h,02Fh,032h,02Fh,032h,0E5h,032h,0E3h,034h,032h,082h,088h
    db 064h,034h,032h,082h,088h,050h,034h,032h,082h,088h,040h,034h,0A0h,0E1h,081h,0A7h
    db 02Ah,02Dh,02Fh,032h,081h,0EBh,032h,0E1h,032h,036h,034h,032h,0E3h,034h,0E8h,034h
    db 0E2h,081h,0E1h,034h,039h,036h,032h,039h,036h,032h,039h,036h,032h,039h,036h,032h
    db 039h,036h,034h,039h,036h,034h,039h,036h,034h,036h,039h,034h,080h,0A7h,0EBh,02Dh
    db 0E3h,032h,0E1h,02Dh,0E3h,032h,0E7h,02Dh,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h
    db 034h,02Dh,0E5h,032h,0E3h,034h,0E5h,036h,0E1h,037h,0E3h,036h,0F7h,034h,0E1h,036h
    db 0E3h,037h,0E1h,039h,0E3h,037h,0E5h,036h,034h,0EDh,036h,0E1h,039h,037h,036h,034h
    db 036h,034h,0E5h,032h,0E3h,034h,0E5h,030h,0E1h,032h,0E5h,02Fh,0E3h,030h,0E5h,02Dh
    db 0E1h,02Fh,0E5h,02Bh,0E3h,02Dh,0E1h,02Ah,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h
    db 02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h
    db 037h,036h,032h,036h,032h,036h,037h,036h,032h,036h,032h,036h,037h,039h,036h,037h
    db 032h,036h,03Bh,039h,037h,036h,036h,034h,032h,02Fh,02Dh,0E3h,034h,0EBh,032h,0E1h
    db 034h,036h,037h,036h,0E3h,034h,0EDh,032h,0E5h,028h,0E3h,02Ah,0E5h,02Bh,0E1h,02Dh
    db 0E5h,02Fh,0E3h,032h,0E5h,034h,0E1h,036h,0EBh,037h,080h,0FFh,081h,081h,081h,0E1h
    db 0A6h,088h,054h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh
    db 039h,03Bh,03Ch,03Bh,039h,088h,05Ah,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,088h,060h,03Bh,039h,03Bh,03Ch,03Bh
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,088h,066h,03Bh
    db 039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh
    db 039h,088h,06Ch,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh
    db 039h,03Bh,03Ch,03Bh,039h,088h,072h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,088h,079h,03Bh,039h,03Bh,03Ch,03Bh
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,039h,03Bh,039h,03Ch,03Bh,039h,088h,07Eh,03Bh
    db 039h,03Bh,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh
    db 03Eh,080h,05h,09h,01Fh,019h,03Dh,019h,05Bh,019h,05Dh,019h,07Dh,019h,09Bh,019h
    db 0B9h,019h,0D7h,019h,0EFh,019h,07h,01Ah,07h,01Ah,07h,01Ah,06Ah,01Ah,07h,01Ah
    db 07h,01Ah,07h,01Ah,06Ah,01Ah,0CBh,01Ah,07h,01Ah,07h,01Ah,06Ah,01Ah,06Ah,01Ah
    db 00h,00h,021h,019h,02Eh,01Bh,02Eh,01Bh,02Eh,01Bh,054h,01Bh,02Eh,01Bh,02Eh,01Bh
    db 02Eh,01Bh,054h,01Bh,081h,01Bh,02Eh,01Bh,02Eh,01Bh,054h,01Bh,054h,01Bh,00h,00h
    db 03Fh,019h,0A7h,01Bh,0B4h,01Bh,0B4h,01Bh,0B4h,01Bh,01Bh,01Ch,0B4h,01Bh,0B4h,01Bh
    db 0B4h,01Bh,01Bh,01Ch,079h,01Ch,07Dh,01Ch,0AEh,01Ch,0AEh,01Ch,010h,01Dh,01Bh,01Ch
    db 00h,00h,05Fh,019h,072h,01Dh,072h,01Dh,072h,01Dh,084h,01Dh,072h,01Dh,072h,01Dh
    db 072h,01Dh,084h,01Dh,0BFh,01Dh,0E7h,01Dh,0E7h,01Dh,08h,01Eh,084h,01Dh,00h,00h
    db 07Fh,019h,04Ah,01Eh,04Ah,01Eh,04Ah,01Eh,05Ch,01Eh,04Ah,01Eh,04Ah,01Eh,04Ah,01Eh
    db 05Ch,01Eh,097h,01Eh,0BFh,01Eh,0BFh,01Eh,0E0h,01Eh,05Ch,01Eh,00h,00h,09Dh,019h
    db 022h,01Fh,022h,01Fh,022h,01Fh,034h,01Fh,022h,01Fh,022h,01Fh,022h,01Fh,034h,01Fh
    db 06Fh,01Fh,097h,01Fh,097h,01Fh,0B8h,01Fh,034h,01Fh,00h,00h,0BBh,019h,0FAh,01Fh
    db 0Ch,020h,0BCh,020h,0FAh,01Fh,0Ch,020h,0BCh,020h,0E7h,020h,0Fh,021h,0BCh,021h
    db 0BCh,020h,00h,00h,0D9h,019h,09Eh,022h,0A9h,022h,05Fh,023h,09Eh,022h,0A9h,022h
    db 05Fh,023h,086h,023h,0ECh,021h,0BEh,023h,05Fh,023h,00h,00h,0F1h,019h,0A0h,0E5h
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
    db 0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
    db 0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,0Eh
    db 080h,0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch
    db 0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h
    db 0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh,081h,0Eh,0Eh,081h
    db 0Eh,0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch
    db 0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h
    db 0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh,081h,0Eh,0Eh,0Eh
    db 0Eh,080h,0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
    db 0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
    db 0A1h,0Eh,0Eh,0Eh,080h,0E5h,081h,0A2h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0E1h,0Eh,081h,0Eh,080h,0E5h,081h,0Eh,081h,0Eh
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,081h,0Eh,0Eh,081h
    db 0Eh,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
    db 0E1h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,080h,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0A2h,0Eh,081h,0Eh,081h,0Eh
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E1h,0Eh,0Eh,0Eh,080h,0A3h,0E5h
    db 012h,012h,012h,012h,012h,012h,012h,012h,089h,0A9h,01Bh,0A4h,088h,078h,0E1h,084h
    db 0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh
    db 013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh
    db 015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h
    db 0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh
    db 013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh
    db 015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h
    db 0Ch,080h,0E1h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
    db 081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h
    db 011h,081h,011h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,015h,081h,015h,015h,081h
    db 015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,0EBh,015h,080h
    db 0A4h,0E1h,084h,0Ch,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
    db 0Eh,0Eh,082h,0Eh,080h,0E1h,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h
    db 082h,010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,013h,082h
    db 013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h
    db 013h,082h,013h,013h,082h,013h,080h,084h,07h,0E1h,011h,081h,011h,011h,081h,011h
    db 011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
    db 081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,013h,081h,013h,013h,081h,013h
    db 013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
    db 081h,013h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h
    db 015h,015h,081h,015h,0EBh,015h,084h,0Ch,080h,0A6h,088h,074h,0F7h,032h,082h,035h
    db 0EBh,037h,039h,0F7h,032h,082h,035h,0EBh,037h,039h,080h,0EBh,030h,0E1h,030h,081h
    db 030h,081h,081h,0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,030h,0E1h,030h,081h
    db 030h,081h,081h,0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,032h,0E1h,032h,081h
    db 032h,081h,081h,0EDh,032h,0E1h,032h,081h,032h,081h,081h,0EDh,034h,0E1h,034h,081h
    db 034h,081h,081h,0F9h,034h,080h,0A6h,088h,074h,0FFh,02Dh,0E1h,081h,02Dh,081h,081h
    db 02Dh,081h,081h,02Dh,0FFh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0FFh
    db 02Dh,0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0F7h,02Dh,082h,080h,084h,0E8h
    db 0FEh,032h,0E1h,081h,034h,081h,081h,034h,0E3h,081h,0E2h,034h,0F7h,035h,037h,0FEh
    db 034h,0E1h,081h,034h,081h,081h,034h,0E3h,081h,0E2h,034h,0F7h,037h,082h,080h,0A6h
    db 088h,074h,084h,0EFh,0EBh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
    db 081h,024h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,026h,0E1h,026h
    db 081h,026h,081h,081h,0EDh,028h,0E1h,028h,081h,028h,081h,081h,0F9h,028h,084h,0E8h
    db 080h,0A6h,088h,074h,0F7h,02Dh,082h,030h,0EBh,032h,034h,0F7h,02Dh,082h,030h,0EBh
    db 032h,034h,080h,0EBh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h
    db 029h,081h,081h,0EDh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h
    db 029h,081h,081h,0EDh,02Bh,0E1h,02Bh,081h,02Bh,081h,081h,0EDh,02Bh,0E1h,02Bh,081h
    db 02Bh,081h,081h,0EDh,02Dh,0E1h,02Dh,081h,02Dh,081h,081h,0F9h,02Dh,080h,0A6h,088h
    db 074h,0FFh,032h,0E1h,081h,032h,081h,081h,032h,081h,081h,032h,0FFh,032h,0E1h,081h
    db 032h,081h,081h,032h,081h,081h,032h,0FFh,032h,0E1h,081h,032h,081h,081h,032h,081h
    db 081h,032h,0F7h,032h,082h,080h,084h,0E8h,0FEh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh
    db 0E3h,081h,0E2h,02Dh,0F7h,030h,032h,0FEh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh,0E3h
    db 081h,0E2h,02Dh,0F7h,032h,082h,080h,0A6h,088h,074h,084h,0EFh,0EBh,01Dh,0E1h,01Dh
    db 081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh
    db 081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Fh,0E1h,01Fh
    db 081h,01Fh,081h,081h,0EDh,01Fh,0E1h,01Fh,081h,01Fh,081h,081h,0EDh,021h,0E1h,021h
    db 081h,021h,081h,081h,0F9h,021h,084h,0E8h,080h,0A6h,088h,074h,0F7h,026h,082h,029h
    db 0EBh,02Bh,02Dh,0F7h,026h,082h,029h,0EBh,02Bh,02Dh,080h,0EBh,024h,0E1h,024h,081h
    db 024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h
    db 024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,026h,0E1h,026h,081h
    db 026h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,028h,0E1h,028h,081h
    db 028h,081h,081h,0F9h,028h,080h,0A6h,088h,074h,0FFh,021h,0E1h,081h,021h,081h,081h
    db 021h,081h,081h,021h,0FFh,021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h,0FFh
    db 021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h,0F7h,021h,082h,080h,084h,0E8h
    db 0FEh,026h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h,0F7h,029h,02Bh,0FEh
    db 028h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h,0F7h,02Bh,082h,080h,0A6h
    db 088h,074h,084h,0EFh,0EBh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,018h,0E1h,018h
    db 081h,018h,081h,081h,0EDh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,018h,0E1h,018h
    db 081h,018h,081h,081h,0EDh,01Ah,0E1h,01Ah,081h,01Ah,081h,081h,0EDh,01Ah,0E1h,01Ah
    db 081h,01Ah,081h,081h,0EDh,01Ch,0E1h,01Ch,081h,01Ch,081h,081h,0F9h,01Ch,084h,0E8h
    db 080h,0A6h,088h,074h,0F7h,039h,082h,03Ch,0EBh,03Eh,040h,0F7h,039h,082h,03Ch,0EBh
    db 03Eh,040h,080h,0A7h,084h,00h,08Ah,04h,00h,04h,016h,0E5h,03Ch,0E2h,081h,08Ah
    db 04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah
    db 04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,0E5h,03Ch,08Ah,0FCh
    db 0FFh,04h,016h,082h,0F7h,039h,0E1h,037h,039h,037h,035h,034h,0A8h,084h,00h,0EDh
    db 032h,0E8h,037h,03Eh,03Ch,037h,0E5h,08Ah,0FBh,0FFh,0Ch,011h,03Eh,039h,08Ah,03h
    db 00h,030h,015h,0F7h,037h,082h,0E3h,032h,0E1h,037h,039h,082h,032h,037h,039h,032h
    db 037h,039h,032h,035h,082h,037h,039h,082h,032h,037h,039h,032h,037h,039h,032h,037h
    db 082h,039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h,03Ch,08Ah,06h,00h,024h,020h
    db 0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh
    db 039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Ch,035h,032h,03Ch,035h
    db 032h,03Ch,035h,032h,03Ch,035h,032h,03Eh,037h,032h,03Eh,037h,032h,040h,039h,034h
    db 0E5h,040h,080h,0E3h,029h,0E1h,02Bh,0E3h,02Ch,0E1h,02Eh,02Ch,02Eh,030h,0F5h,033h
    db 0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Bh,0E1h,02Dh,0E3h,02Eh,0E1h,030h
    db 02Eh,030h,032h,0F5h,035h,0E1h,081h,032h,030h,02Dh,0F7h,031h,034h,080h,0A6h,088h
    db 074h,0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h,081h,026h,0FFh,026h,0E1h,081h
    db 026h,081h,081h,026h,081h,081h,026h,0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h
    db 081h,026h,0F7h,026h,082h,080h,0A7h,084h,00h,08Ah,04h,00h,04h,016h,0E5h,03Ch
    db 0E2h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,0FDh
    db 03Ch,0E1h,03Ch,03Ah,0E0h,039h,037h,0F7h,035h,0E1h,032h,032h,034h,034h,081h,037h
    db 037h,081h,081h,08Ah,03h,00h,07h,015h,0E8h,037h,08Ah,03h,00h,07h,015h,0E8h
    db 037h,034h,037h,0E5h,081h,0E2h,034h,0E0h,081h,08Ah,0FCh,0FFh,05h,010h,0EBh,039h
    db 088h,064h,08Ah,0FCh,0FFh,05h,010h,039h,088h,060h,08Ah,0FCh,0FFh,05h,010h,039h
    db 088h,050h,08Ah,0FCh,0FFh,05h,010h,0EDh,039h,0ABh,0E1h,026h,02Dh,0E5h,032h,032h
    db 032h,0E1h,032h,0E1h,028h,02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h,029h
    db 02Dh,035h,035h,03Ch,082h,029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h,03Eh
    db 082h,02Bh,032h,082h,02Dh,034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h,02Dh
    db 034h,032h,02Fh,02Dh,02Bh,028h,040h,03Eh,03Bh,039h,037h,034h,0A6h,0F7h,037h,0EBh
    db 03Eh,043h,080h,0A7h,084h,07h,0E3h,029h,0E1h,02Bh,0E3h,02Ch,0E1h,02Eh,02Ch,02Eh
    db 030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Bh,0E1h,02Dh,0E3h
    db 02Eh,0E1h,030h,02Eh,030h,032h,0F5h,035h,0E1h,081h,032h,030h,02Dh,0F7h,031h,034h
    db 084h,00h,080h,0A7h,088h,06Ch,084h,00h,0E1h,081h,08Ah,04h,00h,04h,016h,0E5h
    db 03Ch,0E2h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h
    db 0FDh,03Ch,0E1h,03Ch,03Ah,0E0h,039h,037h,0F7h,035h,0E1h,032h,032h,034h,034h,081h
    db 037h,037h,081h,081h,08Ah,03h,00h,07h,015h,0E8h,037h,08Ah,03h,00h,07h,015h
    db 0E8h,037h,034h,037h,0E5h,081h,0E2h,034h,0E0h,081h,08Ah,0FCh,0FFh,05h,010h,0EBh
    db 039h,088h,05Ch,08Ah,0FCh,0FFh,05h,010h,039h,088h,054h,08Ah,0FCh,0FFh,05h,010h
    db 039h,088h,04Ch,08Ah,0FCh,0FFh,05h,010h,0EDh,039h,0ABh,0E1h,026h,02Dh,0E5h,032h
    db 032h,032h,0E1h,032h,0E1h,028h,02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h
    db 029h,02Dh,035h,035h,03Ch,082h,029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h
    db 03Eh,082h,02Bh,032h,082h,02Dh,034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h
    db 02Dh,034h,032h,02Fh,02Dh,02Bh,028h,040h,03Eh,03Bh,039h,037h,034h,0A6h,0F7h,037h
    db 0EBh,03Eh,0E9h,043h,080h,0A0h,0F7h,081h,081h,081h,081h,081h,081h,081h,081h,080h
    db 0A7h,088h,06Ch,084h,00h,0E1h,081h,08Ah,04h,00h,04h,016h,0E5h,03Ch,0E2h,081h
    db 08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h
    db 08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,0E5h,03Ch,08Ah
    db 0FCh,0FFh,04h,016h,082h,0F7h,039h,0E1h,037h,039h,037h,035h,034h,0A8h,088h,06Ch
    db 084h,00h,0EDh,032h,0E8h,037h,03Eh,03Ch,037h,0E5h,08Ah,0FBh,0FFh,0Ch,011h,03Eh
    db 039h,08Ah,03h,00h,030h,015h,0F7h,037h,082h,0E3h,032h,0E1h,037h,039h,082h,032h
    db 037h,039h,032h,037h,039h,032h,035h,082h,037h,039h,082h,032h,037h,039h,032h,037h
    db 039h,032h,037h,082h,039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h,03Ch,08Ah,06h
    db 00h,024h,020h,0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh
    db 039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Ch,035h
    db 032h,03Ch,035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Eh,037h,032h,03Eh,037h,032h
    db 040h,039h,034h,0E3h,040h,080h,0F7h,081h,081h,0E3h,029h,0E1h,02Bh,02Ch,082h,02Eh
    db 02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Dh,0E1h
    db 02Fh,0E3h,030h,0E1h,032h,030h,032h,034h,0F1h,037h,0EBh,039h,080h,0F7h,081h,081h
    db 081h,081h,0A6h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h
    db 02Fh,034h,036h,039h,036h,039h,03Bh,039h,03Bh,03Eh,03Bh,03Eh,023h,028h,02Ah,02Dh
    db 02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,02Fh,034h,036h,039h,036h,039h,03Bh,039h
    db 03Bh,03Eh,03Bh,03Eh,080h,0F7h,081h,081h,0A7h,084h,07h,088h,06Ch,0E3h,029h,0E1h
    db 02Bh,02Ch,082h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh
    db 02Bh,0E3h,02Dh,0E1h,02Fh,0E3h,030h,0E1h,032h,030h,032h,034h,0F1h,037h,0EBh,039h
    db 084h,00h,080h,05h,09h,00h,024h,08h,024h,010h,024h,018h,024h,020h,024h,028h
    db 024h,02Ch,024h,030h,024h,036h,024h,03Ch,024h,054h,024h,00h,00h,02h,024h,072h
    db 024h,08Ah,024h,00h,00h,0Ah,024h,0A8h,024h,0C0h,024h,00h,00h,012h,024h,0DEh
    db 024h,0Fh,025h,00h,00h,01Ah,024h,070h,025h,088h,025h,00h,00h,022h,024h,0B7h
    db 025h,0CAh,025h,0DDh,025h,012h,026h,075h,026h,00h,00h,030h,024h,0Ch,027h,00h
    db 00h,036h,024h,0A6h,084h,0F4h,088h,072h,0EBh,028h,02Bh,028h,0E2h,02Bh,081h,02Dh
    db 081h,0EBh,028h,02Bh,028h,0E2h,02Bh,081h,02Dh,081h,080h,0EBh,028h,02Bh,028h,0E2h
    db 02Bh,081h,02Dh,081h,0EBh,028h,02Bh,028h,0E2h,02Bh,081h,02Dh,081h,0F7h,02Fh,082h
    db 02Dh,0EBh,028h,0E2h,02Dh,081h,02Fh,081h,080h,0A6h,084h,0F4h,088h,072h,0EBh,023h
    db 028h,023h,0E2h,028h,081h,028h,081h,0EBh,023h,028h,023h,0E2h,028h,081h,028h,081h
    db 080h,0EBh,023h,028h,023h,0E2h,028h,081h,028h,081h,0EBh,023h,028h,023h,0E2h,028h
    db 081h,028h,081h,0F7h,02Dh,082h,028h,0EBh,024h,0E2h,028h,081h,02Bh,081h,080h,0A6h
    db 084h,0F4h,088h,072h,0EBh,021h,024h,021h,0E2h,024h,081h,026h,081h,0EBh,021h,024h
    db 021h,0E2h,024h,081h,026h,081h,080h,0EBh,021h,024h,021h,0E2h,024h,081h,026h,081h
    db 0EBh,021h,024h,021h,0E2h,024h,081h,026h,081h,0F7h,028h,082h,026h,0EBh,02Bh,0E2h
    db 026h,081h,028h,081h,080h,0E5h,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h
    db 0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch
    db 0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
    db 0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
    db 0Ch,0E1h,0A1h,0Eh,081h,0Eh,0E5h,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
    db 0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h
    db 0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,081h,0A2h,0Eh,081h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E1h
    db 0Eh,081h,0Eh,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E1h
    db 0Eh,0Eh,0Eh,0E5h,0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A3h,0E5h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h
    db 080h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h
    db 081h,089h,0CAh,025h,0A4h,088h,078h,0E1h,015h,015h,015h,015h,015h,015h,018h,018h
    db 018h,018h,018h,018h,015h,015h,015h,015h,015h,015h,018h,018h,018h,01Ah,081h,01Ah
    db 015h,015h,015h,015h,015h,015h,018h,018h,018h,018h,018h,018h,015h,015h,015h,015h
    db 015h,015h,018h,018h,018h,01Ah,081h,01Ah,080h,0E1h,015h,015h,015h,015h,015h,015h
    db 018h,018h,018h,018h,018h,018h,015h,015h,015h,015h,015h,015h,018h,018h,018h,01Ah
    db 081h,01Ah,015h,015h,015h,015h,015h,015h,018h,018h,018h,018h,018h,018h,015h,015h
    db 015h,015h,015h,015h,018h,018h,018h,01Ah,081h,01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch
    db 01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch
    db 01Ch,01Ch,01Ah,01Ah,01Ah,01Ah,01Ah,01Ah,018h,01Ah,01Ah,01Ah,01Ah,01Ah,018h,018h
    db 018h,018h,018h,018h,0E2h,013h,081h,01Ch,081h,089h,012h,026h,0F7h,081h,081h,081h
    db 081h,0A7h,084h,00h,0E2h,040h,081h,088h,070h,040h,081h,088h,068h,040h,081h,088h
    db 060h,040h,0FAh,081h,088h,07Fh,0E2h,043h,081h,088h,070h,043h,081h,088h,068h,043h
    db 081h,088h,060h,043h,0FAh,081h,088h,07Fh,0E2h,040h,081h,088h,070h,040h,081h,088h
    db 068h,040h,081h,088h,060h,040h,081h,040h,081h,088h,058h,040h,081h,088h,050h,040h
    db 081h,088h,048h,040h,081h,088h,07Fh,03Eh,081h,088h,070h,03Eh,081h,088h,068h,03Eh
    db 081h,088h,060h,03Eh,081h,03Eh,081h,088h,058h,03Eh,081h,088h,050h,03Eh,081h,088h
    db 048h,03Eh,081h,088h,07Fh,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h
    db 03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh
    db 0F1h,03Eh,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0F7h,081h,081h
    db 081h,081h,080h,0F7h,081h,081h,081h,081h,0E0h,081h,0A7h,0E2h,040h,081h,088h,070h
    db 040h,081h,088h,068h,040h,081h,088h,060h,040h,0FAh,081h,088h,07Fh,0E2h,043h,081h
    db 088h,070h,043h,081h,088h,068h,043h,081h,088h,060h,043h,0FAh,081h,088h,07Fh,0E2h
    db 040h,081h,088h,070h,040h,081h,088h,068h,040h,081h,088h,060h,040h,081h,040h,081h
    db 088h,058h,040h,081h,088h,050h,040h,081h,088h,048h,040h,081h,088h,07Fh,03Eh,081h
    db 088h,070h,03Eh,081h,088h,068h,03Eh,081h,088h,060h,03Eh,081h,03Eh,081h,088h,058h
    db 03Eh,081h,088h,050h,03Eh,081h,088h,048h,03Eh,081h,0F6h,081h,0ABh,084h,00h,0E1h
    db 03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh
    db 0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0E1h,02Fh,034h
    db 037h,039h,03Bh,081h,0A7h,0E2h,032h,081h,02Fh,081h,0F7h,081h,081h,081h,081h,080h
    db 05h,07h,0B9h,027h,0BBh,027h,0BDh,027h,0BFh,027h,0C1h,027h,0C3h,027h,0C5h,027h
    db 0C7h,027h,04h,028h,026h,028h,03Fh,028h,058h,028h,071h,028h,0C7h,028h,0A4h,084h
    db 00h,0E1h,09h,0Eh,013h,0Eh,013h,015h,0Eh,013h,015h,018h,015h,01Ah,01Fh,018h
    db 013h,015h,013h,0Eh,011h,016h,018h,01Bh,018h,01Dh,022h,01Bh,016h,018h,016h,011h
    db 0Eh,013h,015h,018h,015h,01Ah,01Fh,018h,013h,015h,013h,0Eh,013h,018h,01Ah,01Dh
    db 01Ah,01Fh,024h,01Dh,018h,01Ah,018h,013h,089h,0D1h,027h,0E1h,0A1h,0Eh,0Eh,0A0h
    db 0Ch,0A1h,0Eh,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0Ch,0A1h,0Eh,0A0h,0Ch,0Ch
    db 0A1h,0Eh,0Eh,0A0h,0Ch,0A1h,0Eh,0Eh,0A0h,0Ch,089h,04h,028h,0EBh,081h,0E1h
    db 0A2h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,081h,081h,0Eh,081h,081h,0Eh,0Eh,081h
    db 0Eh,0Eh,081h,089h,030h,028h,0EBh,081h,0A6h,088h,076h,0E5h,02Dh,02Bh,02Eh,02Dh
    db 030h,02Eh,02Dh,02Bh,02Dh,02Bh,02Eh,02Dh,032h,030h,02Eh,02Bh,089h,045h,028h,0EBh
    db 081h,0A6h,088h,072h,0E5h,021h,01Fh,022h,021h,024h,022h,021h,01Fh,021h,01Fh,022h
    db 021h,026h,024h,022h,01Fh,089h,05Eh,028h,0A7h,0E1h,021h,026h,02Bh,026h,02Bh,02Dh
    db 0FFh,081h,081h,081h,081h,081h,081h,0F1h,039h,0E1h,037h,032h,039h,0F7h,03Ch,0F1h
    db 039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h,039h,0E1h,037h,032h,039h,0F7h
    db 03Ch,0F1h,039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h,040h,0E1h,03Eh,03Ch
    db 039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,0F1h,040h,0E1h,03Eh,03Ch
    db 039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,089h,079h,028h,0E1h,081h
    db 0A7h,088h,068h,021h,026h,02Bh,026h,02Bh,02Dh,089h,079h,028h,05h,09h,0E9h,028h
    db 0EBh,028h,0EDh,028h,0EFh,028h,0F1h,028h,0F3h,028h,0F5h,028h,0F7h,028h,0F9h,028h
    db 0FBh,028h,03Fh,029h,054h,029h,061h,029h,09Eh,029h,0ABh,029h,0B8h,029h,0C5h,029h
    db 0C8h,02Ah,0E3h,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h
    db 0Eh,081h,081h,0A0h,0Ch,081h,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h
    db 0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,0Ch,0A1h
    db 0Eh,081h,081h,0A0h,0Ch,081h,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h
    db 0Eh,081h,081h,089h,0FBh,028h,0EBh,0A2h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,089h,03Fh,029h,0A3h,0E2h,012h,081h,012h
    db 081h,012h,081h,012h,081h,089h,056h,029h,0A4h,084h,0Ch,0E1h,06h,0Ah,0Dh,06h
    db 0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah
    db 0Dh,06h,0Ah,0Dh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh
    db 08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,0Ah,0Fh,011h,0Ah
    db 0Fh,011h,089h,095h,029h,0A5h,0F7h,027h,082h,029h,082h,02Bh,082h,082h,082h,089h
    db 0A4h,029h,0A5h,0F7h,01Eh,082h,020h,082h,022h,082h,082h,082h,089h,0B1h,029h,0A5h
    db 0F7h,023h,082h,025h,082h,027h,082h,082h,082h,089h,0BEh,029h,0A7h,0E1h,033h,081h
    db 033h,031h,081h,0EBh,033h,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h
    db 035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h
    db 0E1h,081h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h
    db 037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h
    db 081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h
    db 033h,088h,06Eh,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h
    db 081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h
    db 081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,064h,037h
    db 081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h
    db 03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h
    db 035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,05Ah,037h,081h,037h,035h,081h
    db 0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h
    db 037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h
    db 0E1h,03Ah,037h,035h,033h,088h,050h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h
    db 037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,089h,0B0h,02Ah,0A7h
    db 088h,06Ch,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h,033h,081h,033h
    db 031h,081h,0EBh,033h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h,035h
    db 081h,035h,033h,081h,0EBh,035h,0E1h,081h,037h,081h,037h,035h,081h,0EBh,037h,0E1h
    db 081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h
    db 035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h
    db 035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,05Ah,037h,081h,037h,035h,081h,0EBh,037h
    db 0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h
    db 037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah
    db 037h,035h,033h,088h,050h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h
    db 037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh
    db 037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h
    db 046h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h
    db 037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h
    db 081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,03Ch,089h,0B0h,02Ah
    db 05h,09h,0CDh,02Bh,0CFh,02Bh,0D1h,02Bh,0D3h,02Bh,0EFh,02Bh,0Bh,02Ch,027h,02Ch
    db 043h,02Ch,05Fh,02Ch,07Bh,02Ch,0B4h,02Ch,0CEh,02Ch,0E3h,02Ch,0E5h,02Ch,0E5h,02Ch
    db 046h,02Dh,0E5h,02Ch,0E5h,02Ch,046h,02Dh,0BDh,030h,046h,02Dh,0C0h,030h,046h,02Dh
    db 0BAh,030h,00h,00h,0D5h,02Bh,0A7h,02Dh,0AAh,02Dh,0AAh,02Dh,0D5h,02Dh,0AAh,02Dh
    db 0AAh,02Dh,0D5h,02Dh,0C6h,030h,0D5h,02Dh,0C9h,030h,0D5h,02Dh,0C3h,030h,00h,00h
    db 0F1h,02Bh,0DFh,02Dh,0E2h,02Dh,0E2h,02Dh,0Dh,02Eh,0E2h,02Dh,0E2h,02Dh,0Dh,02Eh
    db 0C6h,030h,0Dh,02Eh,0C9h,030h,0Dh,02Eh,0C3h,030h,00h,00h,0Dh,02Ch,017h,02Eh
    db 01Ah,02Eh,01Ah,02Eh,045h,02Eh,01Ah,02Eh,01Ah,02Eh,045h,02Eh,0C6h,030h,045h,02Eh
    db 0C9h,030h,045h,02Eh,0C3h,030h,00h,00h,029h,02Ch,0B8h,03Fh,0B8h,03Fh,052h,02Eh
    db 0C3h,030h,0D7h,02Eh,01Bh,02Fh,0C3h,030h,0D7h,02Eh,0C6h,030h,0D7h,02Eh,0C9h,030h
    db 0D7h,02Eh,00h,00h,047h,02Ch,0B8h,03Fh,0B8h,03Fh,082h,02Fh,0C3h,030h,09h,030h
    db 051h,030h,0C3h,030h,09h,030h,0C6h,030h,09h,030h,0C9h,030h,09h,030h,00h,00h
    db 063h,02Ch,0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,081h
    db 0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,081h,0A0h,0E5h
    db 0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,081h,0A0h,0E5h,0Ch,0A1h
    db 0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,089h,07Bh,02Ch,0A2h,0E5h,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,089h,0B4h,02Ch,0A3h,0E5h,012h,012h,012h,012h,012h,012h,012h,012h,012h
    db 012h,012h,012h,012h,012h,012h,081h,089h,0D0h,02Ch,0A4h,0E1h,012h,012h,012h,012h
    db 081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h,012h,012h,012h
    db 012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h,010h,081h,010h
    db 0Eh,0Eh,0Eh,0Eh,081h,0Eh,010h,010h,010h,010h,081h,010h,012h,012h,012h,012h
    db 081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h,012h,012h,012h
    db 012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h,010h,081h,010h
    db 0Eh,0Eh,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,081h,0Eh,080h,0Dh,0Dh,0Dh
    db 0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh
    db 0Dh,0Dh,010h,081h,010h,08h,08h,08h,08h,081h,08h,08h,08h,08h,0Bh,081h
    db 0Bh,08h,08h,08h,08h,081h,08h,08h,08h,08h,08h,081h,08h,0Dh,0Dh,0Dh
    db 0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh
    db 0Dh,0Dh,010h,081h,010h,09h,09h,09h,09h,081h,09h,09h,09h,09h,09h,081h
    db 09h,0Bh,0Bh,0Bh,0Bh,081h,0Bh,0Bh,0Bh,0Bh,0Bh,081h,0Bh,080h,0A6h,088h
    db 076h,0EEh,02Ah,0E2h,081h,028h,081h,0EEh,02Ah,0E2h,081h,028h,081h,0F7h,028h,0E8h
    db 026h,0E2h,081h,0E8h,028h,0E2h,081h,0EEh,02Ah,0E2h,081h,028h,081h,0EEh,02Ah,0E2h
    db 081h,028h,081h,0F7h,028h,0E8h,026h,0E2h,081h,0EBh,026h,080h,0F7h,025h,082h,020h
    db 081h,025h,082h,082h,023h,080h,0A6h,088h,076h,0EEh,02Dh,0E2h,081h,02Dh,081h,0EEh
    db 02Dh,0E2h,081h,02Dh,081h,0F7h,02Ch,0E8h,02Bh,0E2h,081h,0E8h,02Ch,0E2h,081h,0EEh
    db 02Dh,0E2h,081h,02Dh,081h,0EEh,02Dh,0E2h,081h,02Dh,081h,0F7h,02Ch,0E8h,02Bh,0E2h
    db 081h,0EBh,02Ah,080h,0F7h,081h,081h,023h,081h,081h,081h,081h,081h,080h,0A6h,088h
    db 076h,0EEh,031h,0E2h,081h,031h,081h,0EEh,031h,0E2h,081h,031h,081h,0F7h,02Fh,0E8h
    db 02Fh,0E2h,081h,0E8h,02Fh,0E2h,081h,0EEh,031h,0E2h,081h,031h,081h,0EEh,031h,0E2h
    db 081h,031h,081h,0F7h,02Fh,0E8h,02Fh,0E2h,081h,0EBh,02Dh,080h,0F7h,028h,082h,081h
    db 0EBh,01Eh,020h,0F7h,028h,082h,021h,027h,080h,0A7h,084h,0Ch,08Ah,02h,00h,04h
    db 036h,0F7h,036h,082h,0E1h,039h,038h,036h,039h,038h,036h,038h,036h,034h,038h,036h
    db 034h,0F7h,031h,0E5h,038h,0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h,039h,0E1h
    db 081h,02Ah,02Ch,02Dh,031h,02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h,0EDh,02Ah
    db 0E9h,081h,0E1h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh
    db 031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h,036h,0E3h
    db 039h,0F7h,03Bh,0E1h,081h,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh
    db 03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h,045h,044h
    db 042h,040h,042h,040h,03Dh,040h,03Dh,03Bh,039h,0F1h,036h,0E5h,081h,080h,0A7h,0E1h
    db 04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch
    db 04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,0EFh,050h,0E7h,051h,0F4h,050h,0E2h,081h
    db 0E1h,04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h
    db 04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,0EFh,051h,0E1h,050h,051h,082h,0F9h
    db 053h,080h,0A7h,084h,0Ch,0E8h,038h,0FFh,031h,0E4h,081h,0E1h,036h,0E5h,039h,0E2h
    db 031h,0ECh,034h,0E1h,02Ch,0E3h,02Dh,0E5h,02Ah,02Dh,0E7h,02Ah,0E5h,02Ch,0E9h,02Dh
    db 0E1h,02Fh,0E3h,031h,0F9h,02Fh,0E1h,034h,0EDh,036h,0E1h,038h,0E3h,039h,0F9h,036h
    db 0E5h,039h,03Dh,0EFh,045h,0E1h,042h,0E3h,045h,0E5h,042h,0E7h,03Dh,0E3h,042h,0E1h
    db 03Dh,0EFh,039h,0E1h,038h,039h,038h,0F1h,036h,0E1h,034h,0E3h,038h,0E1h,039h,0E3h
    db 038h,0E5h,034h,036h,031h,0F3h,034h,0E3h,02Ch,0E5h,034h,0E1h,02Ch,0E5h,034h,0E1h
    db 02Ch,034h,0E5h,02Dh,0EDh,02Ah,0E5h,081h,080h,0E1h,081h,0A7h,088h,068h,08Ah,02h
    db 00h,04h,036h,0F7h,036h,082h,0E1h,039h,038h,036h,039h,038h,036h,038h,036h,034h
    db 038h,036h,034h,0F7h,031h,0E5h,038h,0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h
    db 039h,0E1h,081h,02Ah,02Ch,02Dh,031h,02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h
    db 0EDh,02Ah,0E9h,081h,0E1h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh
    db 031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h
    db 036h,0E3h,039h,0F7h,03Bh,0E1h,081h,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh
    db 039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h
    db 045h,044h,042h,040h,042h,040h,03Dh,040h,03Dh,03Bh,039h,0F1h,036h,0E3h,081h,080h
    db 0E1h,081h,0A6h,088h,070h,0E1h,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h,028h
    db 02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,0EFh,02Ch
    db 0E7h,02Dh,0F4h,02Ch,0E2h,081h,0E1h,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h
    db 028h,02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,0EFh
    db 02Dh,0E1h,02Ch,02Dh,082h,0F7h,02Fh,080h,0E1h,081h,0A7h,088h,068h,0E8h,038h,0FFh
    db 031h,0E4h,081h,0E1h,036h,0E5h,039h,0E2h,031h,0ECh,034h,0E1h,02Ch,0E3h,02Dh,0E5h
    db 02Ah,02Dh,0E7h,02Ah,0E5h,02Ch,0E9h,02Dh,0E1h,02Fh,0E3h,031h,0F9h,02Fh,0E1h,034h
    db 0EDh,036h,0E1h,038h,0E3h,039h,0F9h,036h,0E5h,039h,03Dh,0EFh,045h,0E1h,042h,0E3h
    db 045h,0E5h,042h,0E7h,03Dh,0E3h,042h,0E1h,03Dh,0EFh,039h,0E1h,038h,039h,038h,0F1h
    db 036h,0E1h,034h,0E3h,038h,0E1h,039h,0E3h,038h,0E5h,034h,036h,031h,0F3h,034h,0E3h
    db 02Ch,0E5h,034h,0E1h,02Ch,0E5h,034h,0E1h,02Ch,034h,0E5h,02Dh,0EDh,02Ah,0E3h,081h
    db 080h,084h,00h,080h,084h,02h,080h,084h,03h,080h,084h,0E8h,080h,084h,0EAh,080h
    db 084h,0EBh,080h,084h,0F4h,080h,084h,0F6h,080h,084h,0F7h,080h,04h,08h,0E7h,030h
    db 0E9h,030h,0EBh,030h,0EDh,030h,0FDh,030h,0Dh,031h,01Dh,031h,02Bh,031h,039h,031h
    db 048h,031h,052h,031h,05Bh,031h,05Bh,031h,05Bh,031h,05Bh,031h,0BEh,031h,05Bh,031h
    db 00h,00h,0F1h,030h,01Fh,032h,01Fh,032h,029h,032h,029h,032h,03Ch,032h,029h,032h
    db 00h,00h,01h,031h,04Fh,032h,04Fh,032h,059h,032h,059h,032h,06Eh,032h,059h,032h
    db 00h,00h,011h,031h,081h,032h,081h,032h,08Ch,032h,08Ch,032h,097h,032h,00h,00h
    db 021h,031h,0B5h,032h,0B5h,032h,0C0h,032h,0C0h,032h,0D2h,032h,00h,00h,02Fh,031h
    db 0E1h,0A0h,0Ch,0Ch,081h,0Ch,081h,0Ch,0A1h,0Eh,0E9h,081h,089h,039h,031h,0EBh
    db 081h,0A2h,0Eh,081h,0Eh,081h,089h,04Bh,031h,0A3h,0E5h,012h,012h,012h,012h,089h
    db 054h,031h,0A4h,0E1h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
    db 0Eh,081h,0Eh,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h
    db 011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h
    db 011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h
    db 011h,081h,011h,081h,080h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch
    db 081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch
    db 081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch
    db 081h,0Ch,081h,0Ch,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh
    db 081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh
    db 081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh
    db 081h,0Fh,081h,0Fh,081h,080h,0A9h,0FFh,021h,082h,082h,024h,082h,082h,0ACh,080h
    db 0F7h,015h,0EBh,017h,018h,015h,082h,017h,018h,0F7h,015h,0EBh,017h,018h,015h,082h
    db 017h,018h,080h,0F7h,013h,0EBh,017h,018h,013h,082h,017h,018h,0F7h,013h,0EBh,017h
    db 018h,013h,082h,017h,018h,080h,0A9h,0FFh,026h,082h,082h,029h,082h,082h,0ACh,080h
    db 088h,070h,0F7h,021h,0EBh,023h,024h,021h,082h,023h,024h,0F7h,021h,0EBh,023h,024h
    db 021h,082h,023h,024h,080h,0F7h,01Fh,0EBh,023h,024h,01Fh,082h,023h,024h,0F7h,01Fh
    db 0EBh,023h,024h,01Fh,082h,023h,024h,080h,0ACh,088h,066h,0FFh,021h,082h,082h,024h
    db 082h,082h,080h,0ADh,0F7h,03Ch,082h,082h,082h,03Ch,082h,039h,082h,080h,0F7h,037h
    db 082h,082h,082h,03Ah,082h,081h,081h,081h,081h,081h,081h,081h,0ECh,081h,0E0h,040h
    db 081h,040h,0E8h,081h,0E0h,040h,081h,040h,0F5h,081h,081h,080h,0ACh,088h,066h,0FFh
    db 026h,082h,082h,029h,082h,082h,080h,0ADh,0F1h,03Ah,039h,082h,082h,082h,0E5h,081h
    db 0F1h,03Ah,039h,0EBh,037h,0F7h,035h,082h,080h,0F7h,034h,082h,082h,082h,033h,082h
    db 03Ch,03Fh,03Eh,082h,082h,082h,081h,0ECh,081h,0E0h,045h,081h,045h,0E8h,081h,0E0h
    db 045h,081h,045h,0F5h,081h,081h,080h,05h,09h,04h,033h,012h,033h,020h,033h,022h
    db 033h,036h,033h,048h,033h,05Ah,033h,06Ch,033h,07Ch,033h,08Ch,033h,08Dh,033h,0Ah
    db 034h,0Ch,035h,0Ah,034h,00h,00h,04h,033h,08Ch,035h,08Eh,035h,0EFh,035h,0B1h
    db 036h,0EFh,035h,00h,00h,012h,033h,013h,037h,01Ch,037h,01Fh,037h,079h,037h,079h
    db 037h,0DBh,037h,0DBh,037h,079h,037h,079h,037h,00h,00h,022h,033h,0Ch,038h,0Dh
    db 038h,017h,038h,017h,038h,021h,038h,017h,038h,017h,038h,00h,00h,036h,033h,02Bh
    db 038h,02Ch,038h,036h,038h,036h,038h,040h,038h,036h,038h,036h,038h,00h,00h,048h
    db 033h,04Ah,038h,04Bh,038h,055h,038h,055h,038h,05Fh,038h,055h,038h,055h,038h,00h
    db 00h,05Ah,033h,0AEh,03Fh,069h,038h,083h,038h,0ECh,038h,0ECh,038h,0Eh,039h,00h
    db 00h,06Ch,033h,0AEh,03Fh,086h,039h,0A4h,039h,0ECh,038h,0ECh,038h,0Eh,039h,00h
    db 00h,07Ch,033h,0E1h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 080h,0E1h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0Eh,0Eh,0A0h,0Ch,0A1h,0Eh
    db 0Eh,081h,080h,0E1h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,080h,0E1h,0A2h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,0Eh,0Eh,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,0Eh,0Eh,0Eh,0Eh,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,0Eh,0Eh,0Eh,0Eh,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,0Eh,0Eh,081h,0Eh,0Eh,081h,080h,0E1h,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,0Eh,0Eh,0Eh,0Eh,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,0Eh
    db 0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A3h,0E5h,012h,012h,012h,012h
    db 089h,015h,037h,0A4h,084h,0Ch,0E1h,09h,082h,09h,09h,09h,09h,09h,082h,09h
    db 09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h
    db 09h,09h,09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h
    db 09h,09h,09h,09h,0E1h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,09h
    db 082h,09h,09h,09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h,09h,09h,09h,09h
    db 082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h,080h
    db 0E1h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h
    db 013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h
    db 013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h
    db 013h,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h
    db 0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Dh,09h,0Eh,09h,010h,09h
    db 0Dh,09h,0Eh,09h,010h,09h,0Dh,09h,0Eh,09h,010h,09h,0Dh,09h,0Eh,09h
    db 010h,080h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,09h,082h
    db 09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,07h,082h,07h,07h,07h,07h
    db 07h,082h,07h,07h,07h,07h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h
    db 09h,09h,080h,0A5h,0F7h,026h,082h,024h,082h,025h,082h,026h,025h,080h,0F7h,026h
    db 082h,026h,082h,026h,082h,026h,025h,080h,0F7h,026h,026h,026h,028h,026h,026h,026h
    db 028h,080h,0A5h,0F7h,023h,082h,01Fh,082h,021h,082h,021h,021h,080h,0F7h,023h,082h
    db 023h,082h,021h,082h,021h,021h,080h,0F7h,021h,023h,023h,025h,021h,023h,023h,025h
    db 080h,0A5h,0F7h,01Fh,082h,01Ch,082h,01Ch,082h,01Eh,01Ch,080h,0F7h,01Fh,082h,01Fh
    db 082h,01Eh,082h,01Ch,01Ch,080h,0F7h,01Eh,01Eh,01Fh,021h,01Eh,01Eh,01Fh,021h,080h
    db 0A9h,0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh,021h,0E9h,032h,0E7h
    db 036h,0FDh,02Dh,0E9h,026h,0E7h,028h,0FDh,025h,080h,0A7h,0F7h,032h,0E1h,039h,037h
    db 036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h,02Dh,0EBh,031h,032h,0FBh
    db 036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h,031h,02Dh,031h,032h,031h
    db 02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h,0E3h,032h,0F4h,02Dh,0E2h
    db 081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh,02Dh,02Fh,0F0h,02Ah,0E2h
    db 081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h,031h,032h,034h,032h,0F1h
    db 036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,0F4h,031h
    db 0E2h,081h,080h,0E1h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h,032h,02Dh
    db 0F5h,036h,0E1h,081h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h,032h,036h
    db 0F5h,039h,0E1h,081h,080h,0F1h,034h,0E3h,032h,0E5h,031h,02Fh,031h,0E7h,032h,0E5h
    db 036h,0E3h,034h,0E5h,032h,031h,0F7h,02Dh,0E1h,032h,031h,02Fh,0F1h,02Dh,0E1h,02Bh
    db 02Ah,028h,0EBh,026h,0E1h,028h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,02Fh,0E3h,031h,032h
    db 034h,0F5h,031h,0E1h,037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E0h,081h,0E1h
    db 037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E2h,081h,0E1h,03Bh,039h,037h,036h
    db 034h,032h,037h,036h,034h,032h,034h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Bh,02Ah
    db 028h,02Bh,02Ah,028h,0EFh,026h,0E1h,036h,032h,02Dh,032h,0EFh,036h,0E1h,032h,02Dh
    db 0E3h,032h,0E9h,034h,0E7h,032h,0E5h,031h,0F5h,02Dh,0E1h,081h,080h,0A9h,088h,060h
    db 0E1h,081h,0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh,021h,0E9h,032h
    db 0E7h,036h,0FDh,02Dh,0E9h,026h,0E7h,028h,0FBh,025h,080h,088h,078h,0F7h,032h,0E1h
    db 039h,037h,036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h,02Dh,0EBh,031h
    db 032h,0FBh,036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h,031h,02Dh,031h
    db 032h,031h,02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h,0E3h,032h,0F4h
    db 02Dh,0E2h,081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh,02Dh,02Fh,0F0h
    db 02Ah,0E2h,081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h,031h,032h,034h
    db 032h,0F1h,036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh
    db 0F4h,031h,0E2h,081h,080h,04h,09h,022h,03Ah,04Ah,03Ah,072h,03Ah,09Ah,03Ah,0AEh
    db 03Ah,0C2h,03Ah,0D6h,03Ah,0EAh,03Ah,0F8h,03Ah,08h,03Bh,08h,03Bh,033h,03Bh,033h
    db 03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h
    db 03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,00h,00h,022h
    db 03Ah,073h,03Bh,073h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h
    db 03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h
    db 03Bh,093h,03Bh,093h,03Bh,00h,00h,04Ah,03Ah,0C5h,03Bh,0C5h,03Bh,0D0h,03Bh,0D0h
    db 03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h
    db 03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,00h,00h,0A8h
    db 03Fh,0E2h,03Bh,0E3h,03Bh,0E9h,03Bh,0E9h,03Bh,04Bh,03Ch,0E9h,03Bh,0E9h,03Bh,04Bh
    db 03Ch,00h,00h,09Ah,03Ah,0Dh,03Dh,0Eh,03Dh,014h,03Dh,014h,03Dh,01Eh,03Dh,014h
    db 03Dh,014h,03Dh,01Eh,03Dh,00h,00h,0AEh,03Ah,030h,03Dh,031h,03Dh,037h,03Dh,037h
    db 03Dh,041h,03Dh,037h,03Dh,037h,03Dh,041h,03Dh,00h,00h,0C2h,03Ah,053h,03Dh,054h
    db 03Dh,05Ah,03Dh,05Ah,03Dh,064h,03Dh,05Ah,03Dh,05Ah,03Dh,064h,03Dh,00h,00h,0D6h
    db 03Ah,076h,03Dh,081h,03Dh,0EAh,03Dh,035h,03Eh,0EAh,03Dh,00h,00h,0EAh,03Ah,0B8h
    db 03Fh,08Eh,03Eh,096h,03Eh,01h,03Fh,04Eh,03Fh,01h,03Fh,00h,00h,0F8h,03Ah,0EBh
    db 0A0h,0Ch,0E1h,0A1h,0Eh,0Eh,0Eh,0Eh,0Eh,081h,0EBh,0A0h,0Ch,0E1h,0A1h,0Eh
    db 0Eh,0Eh,0Eh,081h,081h,0E5h,0A0h,0Ch,0Ch,0Ch,0Ch,0E1h,0A1h,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0A0h,0Ch,081h,0Ch,0A1h
    db 0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h
    db 0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h
    db 0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h
    db 0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0EBh,081h,0E1h,0A2h,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0EDh,081h,0E1h,0Eh,0Eh,0Eh,0Eh,0FBh,081h,0E1h,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,081h,081h,081h,0Eh,081h
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
    db 081h,081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A3h,0EBh,019h,081h
    db 019h,081h,019h,081h,081h,081h,080h,0E5h,012h,012h,012h,012h,012h,012h,012h,012h
    db 012h,012h,012h,012h,012h,012h,012h,012h,080h,0A4h,0F7h,013h,010h,0Bh,082h,080h
    db 0E1h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh
    db 081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
    db 0Bh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,010h,081h,010h
    db 010h,081h,010h,010h,081h,010h,010h,081h,010h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh
    db 081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
    db 0Bh,080h,0E1h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,010h
    db 081h,010h,010h,081h,010h,010h,081h,010h,010h,081h,010h,0Bh,081h,0Bh,0Bh,081h
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,010h
    db 081h,010h,010h,081h,010h,010h,081h,010h,010h,081h,010h,0Eh,081h,0Eh,0Eh,081h
    db 0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh
    db 0Eh,081h,0Eh,080h,0A5h,0F7h,02Bh,028h,02Ah,082h,080h,0F7h,01Eh,082h,082h,082h
    db 021h,023h,01Eh,082h,080h,0F7h,02Bh,082h,02Ah,082h,02Bh,082h,02Ah,082h,02Bh,02Bh
    db 02Ah,082h,02Bh,02Bh,02Ah,082h,080h,0A5h,0F7h,026h,025h,026h,082h,080h,0F7h,01Ah
    db 082h,082h,082h,01Eh,020h,01Ah,082h,080h,0F7h,026h,082h,026h,082h,026h,082h,026h
    db 082h,026h,028h,026h,082h,026h,028h,026h,082h,080h,0A5h,0F7h,023h,021h,023h,082h
    db 080h,0F7h,017h,082h,082h,082h,01Ah,01Ch,017h,082h,080h,0F7h,023h,082h,023h,082h
    db 023h,082h,023h,082h,023h,023h,023h,082h,023h,023h,021h,082h,080h,0A7h,0F7h,03Eh
    db 03Dh,03Bh,082h,032h,031h,02Fh,082h,080h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah
    db 0E3h,02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h,032h,0E7h,031h,0E5h,02Fh,0E1h,031h
    db 02Fh,02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh,0F7h,02Ah,0E9h,02Ah,0E7h,028h,0E5h
    db 026h,0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah
    db 0E1h,02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h,0E1h,025h,023h,021h,0F7h,01Eh,0E8h
    db 025h,026h,0E5h,023h,0E1h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h
    db 026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,0F7h,02Ah,082h
    db 080h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah,02Bh,0F3h,02Ah,0E3h,028h,0F9h,026h,0F7h,02Dh
    db 0E1h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Dh,0E5h,02Bh,0E1h,02Dh,0F6h,02Ah,082h
    db 0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h,02Dh,0E3h,02Fh,0F1h,032h,0E1h,031h,0E5h,032h
    db 0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,0E3h,02Fh,0E5h,031h,0E1h
    db 081h,0E5h,032h,0E3h,034h,0E5h,036h,037h,0F8h,036h,082h,080h,0E1h,026h,028h,026h
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,0F5h,02Ah,0E1h,081h,025h,026h,025h
    db 026h,025h,026h,025h,026h,025h,026h,025h,026h,0F7h,023h,0E9h,028h,0E7h,02Bh,0E5h
    db 02Ah,0E9h,028h,0E7h,026h,0E5h,025h,0F7h,023h,082h,0E9h,028h,0E7h,02Dh,0E9h,028h
    db 0E7h,02Dh,0E5h,028h,02Bh,0E9h,02Ah,0E7h,028h,0E5h,02Bh,0F7h,02Ah,0E3h,02Dh,0E5h
    db 02Bh,0EBh,02Ah,0E1h,02Bh,0E3h,02Ah,0E5h,028h,0EBh,026h,0E1h,026h,028h,026h,025h
    db 0F1h,023h,0F7h,02Ah,080h,0A9h,088h,070h,026h,028h,02Ah,082h,080h,0E1h,081h,0E3h
    db 02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E3h,02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h
    db 032h,0E7h,031h,0E5h,02Fh,0E1h,031h,02Fh,02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh
    db 0F7h,02Ah,0E9h,02Ah,0E7h,028h,0E5h,026h,0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h
    db 02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E1h,02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h
    db 0E1h,025h,023h,021h,0F7h,01Eh,0E8h,025h,026h,0E5h,023h,0E1h,028h,026h,028h,026h
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h
    db 028h,026h,028h,026h,0F6h,02Ah,082h,080h,0E1h,081h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah
    db 02Bh,0F3h,02Ah,0E3h,028h,0F9h,026h,0F7h,02Dh,0E1h,032h,031h,02Fh,031h,02Fh,02Dh
    db 02Fh,02Dh,0E5h,02Bh,0E1h,02Dh,0F6h,02Ah,082h,0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h
    db 02Dh,0E3h,02Fh,0F1h,032h,0E1h,031h,0E5h,032h,0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah
    db 0E1h,02Bh,0E5h,02Dh,0E3h,02Fh,0E5h,031h,0E1h,081h,0E5h,032h,0E3h,034h,0E5h,036h
    db 037h,0F7h,036h,082h,080h,0E1h,081h,026h,028h,026h,028h,026h,028h,026h,028h,026h
    db 028h,026h,028h,0F5h,02Ah,0E1h,081h,025h,026h,025h,026h,025h,026h,025h,026h,025h
    db 026h,025h,026h,0F7h,023h,0E9h,028h,0E7h,02Bh,0E5h,02Ah,0E9h,028h,0E7h,026h,0E5h
    db 025h,0F7h,023h,082h,0E9h,028h,0E7h,02Dh,0E9h,028h,0E7h,02Dh,0E5h,028h,02Bh,0E9h
    db 02Ah,0E7h,028h,0E5h,02Bh,0F7h,02Ah,0E3h,02Dh,0E5h,02Bh,0EBh,02Ah,0E1h,02Bh,0E3h
    db 02Ah,0E5h,028h,0EBh,026h,0E1h,026h,028h,026h,025h,0F1h,023h,0F5h,02Ah,080h,0AEh
    db 03Fh,00h,00h,0A8h,03Fh,0F7h,081h,081h,081h,081h,081h,081h,081h,081h,080h,0F7h
    db 081h,081h,081h,081h,080h
driver ends
end
