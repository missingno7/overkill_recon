; Modern optional-module source; historical source filename unknown.
; Original resource: ROLAND.ENC; no relocation table in ENC stream.
locals
driver segment byte public 'CODE'
assume cs:driver,ds:nothing,ss:nothing,es:nothing
    call loc_00063
    retf
    call loc_00374
    retf
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,030h,03h,00h,00h,054h,079h,070h,065h,020h,03Ah
    db 020h,052h,06Fh,06Ch,061h,06Eh,064h,0Dh,0Ah,020h,046h,069h,06Ch,065h,020h,03Ah
    db 020h,04Fh,076h,065h,072h,06Bh,069h,06Ch,06Ch,024h,044h,061h,074h,065h,020h,03Ah
    db 020h,030h,033h,02Eh,031h,031h,02Eh,039h,032h,024h,04Dh,075h,073h,069h,063h,020h
    db 062h,079h,020h,053h,06Fh,075h,06Eh,064h,020h,049h,06Dh,061h,067h,065h,073h,020h
    db 028h,063h,029h,020h,031h,039h,039h,032h,00h,01h,00h
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
    call loc_002EC
    dec byte ptr ds:[0Dh]
    mov di, 0448h
    call loc_000B8
    mov di, 0467h
    call loc_000B8
    mov di, 0486h
    call loc_000B8
    mov di, 04A5h
    call loc_000B8
    mov di, 04C4h
    call loc_000B8
    mov di, 04E3h
    call loc_000B8
    mov di, 0502h
    call loc_000B8
    mov di, 0521h
    call loc_000B8
    cmp byte ptr ds:[0Dh], 0
    jne loc_000B0
    mov al, byte ptr ds:[0Ch]
    mov byte ptr ds:[0Dh], al
loc_000B0:
    pop ds
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
loc_000B8:
    xor al, al
    cmp al, byte ptr ds:[di + 010h]
    je loc_000D6
    mov bx, word ptr ds:[di + 0Ch]
    cmp al, byte ptr ds:[0Dh]
    jne loc_000D0
    dec byte ptr ds:[di + 1]
    je loc_000D7
    call loc_0013E
loc_000D0:
    call loc_0017D
    call loc_00195
loc_000D6:
    ret
loc_000D7:
    mov al, byte ptr ds:[bx]
    inc bx
    or al, al
    js loc_0011C
    push ax
    mov ah, byte ptr ds:[di]
    or ah, ah
    js loc_000EA
    mov ah, 080h
    call loc_0040B
loc_000EA:
    pop ax
    mov byte ptr ds:[di], al
    mov al, byte ptr ds:[di + 01Ah]
    mov byte ptr ds:[di + 01Bh], al
    mov al, byte ptr ds:[di + 018h]
    add al, 03Fh
    cmp al, byte ptr ds:[di + 5]
    je loc_00103
    mov byte ptr ds:[di + 5], al
    call loc_0035E
loc_00103:
    mov ah, 090h
    call loc_0040B
loc_00108:
    mov word ptr ds:[di + 0Ch], bx
    mov al, byte ptr ds:[di + 011h]
    mov byte ptr ds:[di + 1], al
    ret
    mov ah, 080h
    call loc_0040B
    mov byte ptr ds:[di], 0FFh
    jmp short loc_00108
loc_0011C:
    cmp al, 0E0h
    jae loc_0012F
    cmp al, 091h
    jg loc_00158
    shl al, 1
    xor ah, ah
    mov si, 01F5h
    add si, ax
    jmp word ptr ds:[si]
loc_0012F:
    sub al, 0DFh
    mov byte ptr ds:[di + 011h], al
    jmp short loc_000D7
    mov al, byte ptr ds:[bx]
    inc bx
    mov byte ptr ds:[di + 6], al
    jmp short loc_000D7
loc_0013E:
    mov al, byte ptr ds:[di + 013h]
    or al, al
    je loc_00157
    push ax
    mov al, byte ptr ds:[di]
    mov ah, 080h
    call loc_0040B
    pop ax
    add al, byte ptr ds:[di]
    mov byte ptr ds:[di], al
    mov ah, 090h
    call loc_0040B
loc_00157:
    ret
loc_00158:
    mov di, 0448h
    mov cx, 8
loc_0015E:
    mov byte ptr ds:[di + 010h], ch
    mov al, byte ptr ds:[di + 7]
    or al, 0B0h
    call loc_003F8
    mov al, 07Bh
    call loc_003F8
    xor al, al
    call loc_003F8
    add di, 01Fh
    loop loc_0015E
    mov word ptr ds:[8], cx
    ret
loc_0017D:
    xor al, al
    cmp al, byte ptr ds:[di + 01Ah]
    je loc_001AC
    cmp al, byte ptr ds:[di + 01Bh]
    je loc_001AC
    dec byte ptr ds:[di + 01Bh]
    mov al, byte ptr ds:[di + 019h]
    add byte ptr ds:[di + 5], al
    jmp near ptr loc_0035E
loc_00195:
    dec byte ptr ds:[di + 01Ch]
    jne loc_001AC
    mov al, byte ptr ds:[di + 01Dh]
    mov byte ptr ds:[di + 01Ch], al
    xor al, al
    cmp al, byte ptr ds:[di + 016h]
    je loc_001AD
    dec byte ptr ds:[di + 016h]
    je loc_001AD
loc_001AC:
    ret
loc_001AD:
    cmp al, byte ptr ds:[di + 017h]
    je loc_001AC
    dec byte ptr ds:[di + 017h]
    mov al, byte ptr ds:[di + 014h]
    add byte ptr ds:[di + 5], al
    jmp near ptr loc_0035E
    mov al, byte ptr ds:[di + 7]
    or al, 0C0h
    call loc_003F8
    mov al, byte ptr ds:[bx]
    inc bx
    call loc_003F8
    mov al, byte ptr ds:[di + 7]
    or al, 0B0h
    call loc_003F8
    mov al, 7
    call loc_003F8
    mov al, 064h
    mov byte ptr ds:[di + 0Eh], al
    call loc_003F8
    jmp near ptr loc_000D7
; UNKNOWN: not yet classified as code or data
    db 0B0h,07h,0E8h,0Fh,02h,08Ah,07h,043h,088h,045h,0Eh,0E8h,06h,02h,0E9h,0E2h
    db 0FEh,02Ah,02h,012h,01h,08h,01h,058h,01h,044h,02h,04Dh,02h,05Bh,02h,062h
    db 02h,0E4h,01h,070h,02h,081h,02h,091h,02h,09Ch,02h,0A5h,02h,0E1h,02h,069h
    db 02h,0BEh,01h,036h,01h,08Bh,01Fh,08Bh,0Fh,043h,043h,089h,05Dh,0Ah,089h,04Dh
    db 0Ch,08Bh,0D9h,0E9h,0ADh,0FEh,0A0h,08h,00h,0A2h,060h,00h,08Bh,05Dh,0Ah,08Bh
    db 0Fh,043h,043h,0E3h,0E0h,089h,05Dh,0Ah,089h,04Dh,0Ch,08Bh,0D9h,0E9h,093h,0FEh
    db 08Ah,07h,043h,088h,045h,012h,0E9h,08Ah,0FEh,0B4h,080h,0E8h,0B9h,01h,032h,0C0h
    db 088h,045h,010h,088h,045h,01Eh,0C3h,0C6h,045h,013h,01h,0E9h,075h,0FEh,0C6h,045h
    db 013h,0FFh,0E9h,06Eh,0FEh,0C6h,045h,013h,00h,0E9h,067h,0FEh,08Bh,07h,089h,045h
    db 014h,043h,043h,08Bh,07h,089h,045h,016h,043h,043h,0E9h,056h,0FEh,08Bh,07h,089h
    db 045h,018h,043h,043h,08Ah,07h,088h,045h,01Ah,043h,0E9h,046h,0FEh,032h,0C0h,088h
    db 045h,01Ah,088h,045h,018h,0E9h,03Bh,0FEh,08Ah,07h,043h,088h,045h,01Dh,0E9h,032h
    db 0FEh,08Ah,065h,07h,08Ah,0C4h,04h,0B0h,0E8h,049h,01h,0B0h,064h,0E8h,044h,01h
    db 032h,0C0h,0E8h,03Fh,01h,08Ah,0C4h,08Ah,0C4h,04h,0B0h,0E8h,036h,01h,0B0h,065h
    db 0E8h,031h,01h,032h,0C0h,0E8h,02Ch,01h,08Ah,0C4h,04h,0B0h,0E8h,025h,01h,0B0h
    db 06h,0E8h,020h,01h,08Ah,07h,0E8h,01Bh,01h,043h,0E9h,0F6h,0FDh,08Bh,01Fh,0A0h
    db 08h,00h,0A2h,060h,00h,0E9h,0EBh,0FDh
loc_002EC:
    xor ah, ah
    cmp ah, byte ptr ds:[9]
    jne loc_002FA
    mov al, byte ptr ds:[8]
    mov byte ptr ds:[060h], al
loc_002FA:
    mov al, byte ptr ds:[060h]
    or al, al
    je loc_0035D
    mov byte ptr ds:[8], ah
    mov byte ptr ds:[060h], ah
    push ax
    call loc_00158
    pop ax
    cmp al, 0Bh
    jae loc_0035D
    mov byte ptr ds:[9], al
    shl al, 1
    mov si, 053Eh
    add si, ax
    lodsw
    mov si, ax
    lodsb
    mov byte ptr ds:[0Ch], al
    lodsb
    mov cl, al
    xor ch, ch
    mov word ptr ds:[061h], cx
    mov dx, 01FFh
    mov byte ptr ds:[0Dh], dh
    mov di, 0448h
loc_00336:
    lodsw
    mov bx, ax
    mov ax, word ptr ds:[bx]
    inc bx
    inc bx
    mov word ptr ds:[di + 0Ah], bx
    mov word ptr ds:[di + 0Ch], ax
    mov byte ptr ds:[di + 012h], ch
    mov byte ptr ds:[di + 013h], ch
    mov byte ptr ds:[di + 017h], ch
    mov byte ptr ds:[di + 01Ah], ch
    mov byte ptr ds:[di + 018h], ch
    mov byte ptr ds:[di + 1], dh
    mov byte ptr ds:[di + 010h], dh
    add di, 01Fh
    loop loc_00336
loc_0035D:
    ret
loc_0035E:
    mov al, byte ptr ds:[di + 7]
    or al, 0E0h
    call loc_003F8
    xor al, al
    call loc_003F8
    mov al, byte ptr ds:[di + 5]
    and al, 07Fh
    call loc_003F8
    ret
loc_00374:
    push ds
    push cs
    pop ds
    push cx
    push dx
    mov cx, 01Bh
loc_0037C:
    call loc_003C4
    cmp al, 0FEh
    je loc_0038B
    loop loc_0037C
    pop dx
    pop cx
    pop ds
    xor al, al
    ret
loc_0038B:
    mov al, 0FFh
    call loc_003DF
    call loc_003B4
    mov al, 03Fh
    call loc_003DF
    push si
    call loc_003B4
    mov si, 034EEh
loc_0039F:
    lodsw
    or ax, ax
    je loc_003AD
    push si
    mov si, ax
    call loc_00424
    pop si
    jmp short loc_0039F
loc_003AD:
    pop si
    pop dx
    pop cx
    pop ds
    mov al, 1
    ret
loc_003B4:
    push ax
    push cx
    push dx
    mov cx, 064h
    mov dx, 0330h
loc_003BD:
    in al, dx
    loop loc_003BD
    pop dx
    pop cx
    pop ax
    ret
loc_003C4:
    push cx
    mov dx, 0331h
    mov cx, 0FFFFh
loc_003CB:
    in al, dx
    test al, 040h
    loopne loc_003CB
    mov al, 0FFh
    out dx, al
    mov cx, 0FFFFh
loc_003D6:
    in al, dx
    test al, 080h
    loopne loc_003D6
    dec dx
    in al, dx
    pop cx
    ret
loc_003DF:
    push ax
    push dx
    mov dx, 0331h
    mov ah, al
loc_003E6:
    in al, dx
    add al, al
    js loc_003E6
    mov al, ah
    out dx, al
loc_003EE:
    in al, dx
    or al, al
    js loc_003EE
    dec dx
    in al, dx
    pop dx
    pop ax
    ret
loc_003F8:
    push ax
    push dx
    mov dx, 0331h
    mov ah, al
loc_003FF:
    in al, dx
    add al, al
    js loc_003FF
    mov al, ah
    dec dx
    out dx, al
    pop dx
    pop ax
    ret
loc_0040B:
    mov al, byte ptr ds:[di + 7]
    or al, ah
    call loc_003F8
    mov al, byte ptr ds:[di]
    add al, byte ptr ds:[di + 012h]
    add al, 018h
    call loc_003F8
    mov al, byte ptr ds:[di + 6]
    call loc_003F8
    ret
loc_00424:
    push ax
    mov al, 0F0h
    call loc_003F8
    mov al, 041h
    call loc_003F8
    mov al, 010h
    call loc_003F8
    mov al, 016h
    call loc_003F8
    mov al, 012h
    call loc_003F8
loc_0043E:
    lodsb
    call loc_003F8
    cmp al, 0F7h
    jne loc_0043E
    pop ax
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,06Eh,00h,09h,0B0h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h
    db 00h,00h,00h,00h,06Eh,00h,09h,0B1h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h
    db 00h,00h,00h,060h,00h,01h,0B2h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h
    db 00h,00h,060h,00h,02h,0B3h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h
    db 00h,060h,00h,03h,0B4h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h,00h
    db 060h,00h,04h,0B5h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h,00h,060h
    db 00h,05h,0B6h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h,00h,060h,00h
    db 06h,0B7h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,01h,01h,00h,054h,05h,070h,0Ah,0DEh,011h,0FAh,01Bh
    db 059h,01Fh,079h,020h,049h,023h,027h,028h,044h,02Ah,0B0h,02Fh,05h,08h,066h,05h
    db 078h,05h,0D8h,05h,08Ah,05h,0A2h,05h,0B4h,05h,0C6h,05h,0EAh,05h,0FCh,05h
    db 0FCh,05h,0FCh,05h,0FCh,05h,0FCh,05h,045h,06h,06Ah,06h,00h,00h,068h,05h
    db 093h,06h,096h,06h,096h,06h,096h,06h,096h,06h,0A6h,06h,0B7h,06h,00h,00h
    db 07Ah,05h,0C8h,06h,0CCh,06h,0CCh,06h,0CCh,06h,0FEh,06h,0C8h,06h,0CCh,06h
    db 0FEh,06h,060h,07h,092h,07h,00h,00h,08Eh,05h,0A2h,07h,0A2h,07h,0B0h,07h
    db 0A6h,07h,0B0h,07h,0BAh,07h,0C3h,07h,00h,00h,0A4h,05h,0D5h,07h,0D5h,07h
    db 0E3h,07h,0D5h,07h,0E3h,07h,0EDh,07h,0F6h,07h,00h,00h,0B6h,05h,08h,08h
    db 08h,08h,033h,08h,08h,08h,033h,08h,0D8h,034h,06Ch,08h,00h,00h,0C8h,05h
    db 0E4h,034h,07Eh,08h,0CFh,08h,0EEh,08h,0CFh,08h,05Bh,09h,070h,09h,00h,00h
    db 0DAh,05h,0E4h,034h,084h,09h,0D5h,09h,0E3h,09h,0D5h,09h,053h,0Ah,05Ch,0Ah
    db 00h,00h,0ECh,05h,091h,078h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch
    db 0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch
    db 0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h
    db 0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h
    db 0Eh,0Ch,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0Ch,0Eh
    db 0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh
    db 0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,080h,0E1h,0Ch,081h,0Ch,0E5h,0Eh,0E1h,0Ch,081h,0Ch,0E5h,0Eh,0E1h,0Ch
    db 081h,0Ch,0E5h,0Eh,0E1h,0Ch,081h,0Ch,0E5h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,081h
    db 0Eh,0Eh,081h,0Eh,0F5h,081h,0E1h,0Ch,0E5h,0Eh,080h,0E5h,091h,06Ch,012h,012h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,012h,012h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,080h,0E5h
    db 012h,012h,012h,012h,012h,012h,012h,012h,0F7h,081h,0E5h,012h,012h,012h,012h,080h
    db 090h,01Ch,091h,078h,0E1h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h
    db 017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh
    db 0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh
    db 0Bh,0Bh,0Bh,012h,017h,080h,0E1h,09h,09h,09h,09h,010h,015h,09h,09h,09h
    db 09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h
    db 09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h
    db 015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h
    db 09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,07h
    db 07h,07h,07h,0Eh,013h,07h,07h,07h,07h,0Eh,013h,06h,06h,06h,06h,0Eh
    db 012h,06h,06h,06h,06h,0Eh,012h,080h,0E1h,09h,09h,09h,09h,010h,015h,09h
    db 09h,09h,09h,010h,015h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h
    db 017h,0Dh,0Dh,0Dh,0Dh,014h,019h,0Eh,0Eh,0Eh,0Eh,015h,01Ah,010h,010h,010h
    db 010h,017h,01Ch,012h,012h,012h,012h,01Eh,082h,080h,0F7h,081h,081h,0E1h,017h,015h
    db 012h,010h,012h,010h,0E3h,0Eh,0Bh,0FBh,081h,080h,090h,058h,091h,060h,0F7h,026h
    db 028h,02Ah,082h,026h,028h,02Ah,082h,080h,0F7h,025h,082h,026h,082h,025h,082h,02Bh
    db 02Ah,080h,0F7h,025h,026h,0EBh,028h,02Ah,02Dh,02Fh,080h,0F7h,081h,081h,090h,02Ch
    db 0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0FBh,081h,080h,090h,058h,091h
    db 060h,0F7h,021h,023h,023h,082h,021h,023h,023h,082h,080h,0F7h,023h,082h,023h,082h
    db 023h,082h,026h,026h,080h,0F7h,023h,023h,0EBh,025h,026h,028h,02Ah,080h,0F7h,081h
    db 090h,02Bh,081h,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0FBh,081h,080h
    db 090h,02Bh,0FDh,081h,0F3h,081h,081h,091h,060h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh
    db 02Fh,02Dh,02Fh,032h,02Fh,032h,034h,0FDh,081h,0F3h,081h,081h,0E1h,023h,028h,02Ah
    db 02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,034h,080h,0E1h,040h,03Eh,03Bh,03Eh
    db 03Bh,039h,03Bh,039h,036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh
    db 02Ah,02Dh,02Ah,028h,0F7h,026h,082h,0E1h,040h,03Eh,03Bh,03Eh,03Bh,039h,03Bh,039h
    db 036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh,02Ah,02Dh,02Ah,028h
    db 0F7h,02Bh,02Ah,080h,0F7h,081h,081h,090h,02Ch,0E1h,03Bh,039h,036h,034h,036h,034h
    db 0E3h,032h,02Fh,0FBh,081h,080h,090h,02Ch,08Dh,03h,08Ch,01h,091h,078h,0E1h,039h
    db 036h,032h,034h,02Fh,032h,0E7h,036h,0E1h,02Fh,032h,036h,034h,0F3h,039h,0E1h,036h
    db 034h,032h,036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F7h,089h,0FDh,0FFh,02Dh
    db 015h,032h,0E1h,039h,036h,032h,034h,036h,034h,0E7h,032h,0E1h,02Fh,032h,036h,039h
    db 0F3h,034h,0E1h,036h,034h,032h,036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F7h
    db 089h,0FDh,0FFh,02Dh,015h,032h,080h,090h,056h,0E8h,021h,023h,0E5h,025h,0E8h,021h
    db 023h,0E5h,025h,0E8h,023h,025h,0FDh,026h,0E8h,025h,026h,0E5h,028h,0E8h,025h,026h
    db 0E5h,028h,0F7h,02Bh,02Ah,080h,090h,02Ch,08Dh,03h,0E1h,039h,036h,02Fh,032h,034h
    db 036h,0EBh,039h,0E1h,03Bh,039h,036h,0F1h,034h,0E1h,039h,036h,034h,036h,034h,032h
    db 034h,032h,02Fh,032h,02Fh,02Dh,0F7h,089h,0FDh,0FFh,02Dh,015h,032h,0E1h,034h,031h
    db 02Fh,032h,031h,02Dh,034h,031h,02Fh,032h,031h,02Dh,036h,032h,02Fh,034h,032h,031h
    db 039h,036h,032h,034h,032h,02Fh,089h,08h,00h,00h,08h,02Fh,034h,032h,02Fh,034h
    db 032h,089h,08h,00h,00h,08h,02Fh,034h,032h,02Fh,034h,032h,089h,08h,00h,00h
    db 08h,03Bh,039h,032h,02Fh,039h,032h,089h,08h,00h,00h,08h,03Bh,039h,032h,02Fh
    db 039h,032h,080h,090h,056h,0E8h,021h,023h,0E5h,025h,0E8h,023h,025h,0E5h,026h,025h
    db 028h,026h,02Ah,028h,02Dh,02Ah,02Fh,080h,0F8h,081h,081h,090h,02Ch,091h,06Ch,0E1h
    db 02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0F9h,081h,080h,090h,02Ch,091h,04Ch
    db 0E1h,081h,08Dh,03h,0E1h,039h,036h,032h,034h,02Fh,032h,0E7h,036h,0E1h,02Fh,032h
    db 036h,034h,0F3h,039h,0E1h,036h,034h,032h,036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah
    db 028h,0F7h,089h,0FDh,0FFh,02Dh,015h,032h,0E1h,039h,036h,032h,034h,036h,034h,0E7h
    db 032h,0E1h,02Fh,032h,036h,039h,0F3h,034h,0E1h,036h,034h,032h,036h,032h,02Fh,034h
    db 02Fh,02Ah,02Fh,02Ah,028h,0F5h,089h,0FDh,0FFh,02Dh,015h,032h,080h,090h,058h,091h
    db 060h,0F7h,021h,082h,01Fh,082h,021h,082h,021h,021h,080h,090h,02Ch,091h,04Ch,0E1h
    db 081h,08Dh,03h,0E1h,039h,036h,02Fh,032h,034h,036h,0EBh,039h,0E1h,03Bh,039h,036h
    db 0F1h,034h,0E1h,039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,02Fh,02Dh,0F7h
    db 089h,0FDh,0FFh,02Dh,015h,032h,0E1h,034h,031h,02Fh,032h,031h,02Dh,034h,031h,02Fh
    db 032h,031h,02Dh,036h,032h,02Fh,034h,032h,031h,039h,036h,032h,034h,032h,02Fh,089h
    db 08h,00h,00h,08h,02Fh,034h,032h,02Fh,034h,032h,089h,08h,00h,00h,08h,02Fh
    db 034h,032h,02Fh,034h,032h,089h,08h,00h,00h,08h,03Bh,039h,032h,02Fh,039h,032h
    db 089h,08h,00h,00h,08h,03Bh,039h,032h,02Fh,039h,080h,0F7h,021h,021h,0EBh,021h
    db 021h,025h,023h,080h,0F8h,081h,081h,090h,02Ch,091h,04Ch,0E1h,03Bh,039h,036h,034h
    db 036h,034h,0E3h,032h,02Fh,0F9h,081h,080h,06h,08h,082h,0Ah,092h,0Ah,0A6h,0Ah
    db 0B6h,0Ah,0C2h,0Ah,0CEh,0Ah,0DAh,0Ah,0E6h,0Ah,0F0h,0Ah,0B3h,0Bh,074h,0Ch
    db 074h,0Ch,074h,0Ch,074h,0Ch,00h,00h,082h,0Ah,0A6h,0Ch,0A6h,0Ch,0A6h,0Ch
    db 0A6h,0Ch,0Ah,0Dh,0Ah,0Dh,0Ah,0Dh,0Ah,0Dh,00h,00h,092h,0Ah,03Ch,0Dh
    db 0ECh,0Dh,09Bh,0Eh,09Bh,0Eh,09Bh,0Eh,09Bh,0Eh,00h,00h,0A6h,0Ah,0CDh,0Eh
    db 0EEh,0Eh,013h,0Fh,013h,0Fh,00h,00h,0B6h,0Ah,01Dh,0Fh,03Eh,0Fh,063h,0Fh
    db 063h,0Fh,00h,00h,0C2h,0Ah,06Dh,0Fh,08Eh,0Fh,0B3h,0Fh,0B3h,0Fh,00h,00h
    db 0CEh,0Ah,0BDh,0Fh,0DEh,0Fh,03h,010h,03h,010h,00h,00h,0DAh,0Ah,0Dh,010h
    db 099h,010h,036h,011h,00h,00h,0E6h,0Ah,091h,078h,0E1h,0Ch,0Ch,081h,0Eh,081h
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
    db 0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch
    db 0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
    db 0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch
    db 0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh,081h
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
    db 0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch
    db 0Ch,0E7h,081h,0E1h,0Ch,0Eh,0Eh,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
    db 0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,081h,0Ch,0Ch
    db 081h,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0Ch,0Ch,081h,0Eh
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch
    db 081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
    db 0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch
    db 081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
    db 0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch
    db 081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
    db 0Ch,0Ch,0E7h,081h,0E1h,0Ch,0Eh,0Eh,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh,081h
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
    db 0Eh,081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h,081h,0Eh,0Eh,081h,081h,0Eh
    db 081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0Ch,0Eh,0Ch
    db 0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch
    db 0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h
    db 081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,0Eh,0Eh,080h,091h,06Ch
    db 0E1h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h
    db 012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h
    db 012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h
    db 012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h
    db 012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h
    db 012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h
    db 012h,080h,0E1h,012h,012h,081h,012h,016h,012h,012h,012h,081h,012h,016h,012h,012h
    db 012h,081h,012h,016h,012h,012h,012h,081h,012h,016h,012h,012h,012h,081h,012h,016h
    db 012h,012h,012h,081h,012h,016h,012h,012h,012h,081h,012h,016h,012h,012h,012h,081h
    db 012h,016h,012h,080h,090h,01Ch,091h,078h,0E1h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
    db 015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
    db 015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh
    db 0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h
    db 013h,0E2h,015h,081h,0E1h,09h,081h,0E5h,015h,0FFh,081h,0E1h,0Eh,0Eh,0Bh,0Eh
    db 012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh
    db 0Bh,0Eh,012h,013h,015h,082h,081h,09h,081h,0E5h,015h,0F5h,081h,0E1h,09h,0Bh
    db 0Ch,0Dh,0Eh,080h,0E1h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h
    db 013h,0Eh,013h,018h,01Ah,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h
    db 013h,0Eh,013h,018h,01Ah,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h
    db 013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E2h,015h,081h
    db 0E1h,09h,081h,0E5h,015h,0FFh,081h,0E1h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh
    db 0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h
    db 0E5h,015h,0E3h,012h,0E5h,013h,0E1h,015h,0E5h,017h,0E3h,01Ah,0E5h,01Ch,0E1h,01Eh
    db 0EBh,01Fh,080h,0E1h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h
    db 07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,09h,015h,09h,015h
    db 09h,015h,09h,015h,09h,015h,09h,015h,04h,010h,04h,010h,04h,010h,04h,010h
    db 04h,010h,04h,010h,080h,090h,058h,091h,030h,0F7h,02Dh,082h,02Fh,082h,02Dh,082h
    db 02Fh,082h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,0F7h,02Dh,082h,0E3h,02Bh
    db 0E5h,081h,02Bh,0FFh,081h,080h,0F7h,02Dh,082h,02Fh,082h,02Dh,082h,02Fh,082h,02Dh
    db 082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,0F7h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh
    db 0E7h,081h,0E3h,02Bh,0E5h,081h,0E7h,02Bh,0E5h,081h,080h,0F7h,02Ah,082h,028h,026h
    db 02Ah,082h,028h,026h,080h,090h,058h,091h,030h,0F7h,02Ah,082h,02Bh,082h,02Ah,082h
    db 02Bh,082h,02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h,02Ah,082h,0E3h,028h
    db 0E5h,081h,028h,0FFh,081h,080h,0F7h,02Ah,082h,02Bh,082h,02Ah,082h,02Bh,082h,02Ah
    db 082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h,02Ah,082h,0E3h,028h,0E5h,081h,028h
    db 0E7h,081h,0E3h,028h,0E5h,081h,0E7h,028h,0E5h,081h,080h,0F7h,026h,082h,024h,023h
    db 026h,082h,024h,023h,080h,090h,058h,091h,030h,0F7h,028h,082h,028h,082h,028h,082h
    db 028h,082h,026h,082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h,024h
    db 0E5h,081h,024h,0FFh,081h,080h,0F7h,028h,082h,028h,082h,028h,082h,028h,082h,026h
    db 082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h,024h,0E5h,081h,024h
    db 0E7h,081h,0E3h,024h,0E5h,081h,0E7h,024h,0E5h,081h,080h,0F7h,023h,082h,021h,01Fh
    db 023h,082h,021h,01Fh,080h,090h,058h,091h,030h,0F7h,026h,082h,024h,082h,026h,082h
    db 024h,082h,023h,082h,0E3h,021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h
    db 0E5h,081h,021h,0FFh,081h,080h,0F7h,026h,082h,024h,082h,026h,082h,024h,082h,023h
    db 082h,0E3h,021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h,0E5h,081h,021h
    db 0E7h,081h,0E3h,021h,0E5h,081h,0E7h,021h,0E5h,081h,080h,0F7h,01Fh,082h,01Dh,01Ch
    db 01Fh,082h,01Dh,01Ch,080h,090h,02Ch,091h,068h,0E9h,02Dh,0E1h,02Ah,0E3h,028h,0E5h
    db 02Ah,0F1h,026h,0E1h,028h,0E5h,02Ah,0E9h,02Fh,0FBh,02Dh,0E1h,02Fh,02Dh,02Bh,02Ah
    db 02Bh,0EFh,02Dh,0E1h,028h,0E3h,02Ah,0F1h,026h,0E1h,028h,0E5h,02Ah,0E9h,02Fh,0F9h
    db 02Dh,0E1h,02Fh,030h,032h,034h,036h,039h,02Ah,02Dh,02Fh,032h,081h,0EBh,034h,0E1h
    db 036h,039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,02Fh,032h,0E5h,032h,0E3h
    db 034h,032h,082h,091h,040h,034h,032h,082h,091h,020h,034h,032h,082h,091h,010h,034h
    db 091h,068h,0E1h,081h,02Ah,02Dh,02Fh,032h,081h,0EBh,032h,0E1h,032h,036h,034h,032h
    db 0E3h,034h,0E8h,034h,0E2h,081h,0E1h,034h,039h,036h,032h,039h,036h,032h,039h,036h
    db 032h,039h,036h,032h,039h,036h,034h,039h,036h,034h,039h,036h,034h,036h,039h,034h
    db 080h,0EBh,02Dh,0E3h,032h,0E1h,02Dh,0E3h,032h,0E7h,02Dh,0E1h,032h,034h,02Dh,032h
    db 034h,02Dh,032h,034h,02Dh,0E5h,032h,0E3h,034h,0E5h,036h,0E1h,037h,0E3h,036h,0F7h
    db 034h,0E1h,036h,0E3h,037h,0E1h,039h,0E3h,037h,0E5h,036h,034h,0EDh,036h,0E1h,039h
    db 037h,036h,034h,036h,034h,0E5h,032h,0E3h,034h,0E5h,030h,0E1h,032h,0E5h,02Fh,0E3h
    db 030h,0E5h,02Dh,0E1h,02Fh,0E5h,02Bh,0E3h,02Dh,0E1h,02Ah,02Dh,032h,02Dh,034h,02Dh
    db 032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh
    db 032h,02Dh,034h,037h,036h,032h,036h,032h,036h,037h,036h,032h,036h,032h,036h,037h
    db 039h,036h,037h,032h,036h,03Bh,039h,037h,036h,036h,034h,032h,02Fh,02Dh,0E3h,034h
    db 0EBh,032h,0E1h,034h,036h,037h,036h,0E3h,034h,0EDh,032h,0E5h,028h,0E3h,02Ah,0E5h
    db 02Bh,0E1h,02Dh,0E5h,02Fh,0E3h,032h,0E5h,034h,0E1h,036h,0EBh,037h,080h,0FFh,081h
    db 081h,081h,0E1h,090h,02Bh,091h,010h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,020h,03Bh,039h,03Bh,03Ch,03Bh
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,030h,03Bh
    db 039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh
    db 039h,091h,040h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh
    db 039h,03Bh,03Ch,03Bh,039h,091h,050h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,060h,03Bh,039h,03Bh,03Ch,03Bh
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,070h,03Bh
    db 039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,039h,03Bh,039h,03Ch,03Bh
    db 039h,091h,07Eh,03Bh,039h,03Bh,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch
    db 03Bh,039h,03Ch,03Bh,03Eh,080h,05h,08h,0F0h,011h,0Eh,012h,010h,012h,02Eh,012h
    db 04Ch,012h,06Ah,012h,088h,012h,0A0h,012h,0B8h,012h,0B8h,012h,0B8h,012h,0FDh,012h
    db 0B8h,012h,0B8h,012h,0B8h,012h,0FDh,012h,042h,013h,0B8h,012h,0B8h,012h,0FDh,012h
    db 0FDh,012h,00h,00h,0F2h,011h,085h,013h,093h,013h,093h,013h,093h,013h,0F9h,013h
    db 093h,013h,093h,013h,093h,013h,0F9h,013h,057h,014h,0B9h,014h,0B9h,014h,01Bh,015h
    db 0F9h,013h,00h,00h,012h,012h,07Dh,015h,07Dh,015h,07Dh,015h,090h,015h,07Dh,015h
    db 07Dh,015h,07Dh,015h,090h,015h,0CBh,015h,0F0h,015h,0F0h,015h,012h,016h,090h,015h
    db 00h,00h,030h,012h,053h,016h,053h,016h,053h,016h,066h,016h,053h,016h,053h,016h
    db 053h,016h,066h,016h,0A1h,016h,0C6h,016h,0C6h,016h,0E8h,016h,066h,016h,00h,00h
    db 04Eh,012h,029h,017h,029h,017h,029h,017h,03Ch,017h,029h,017h,029h,017h,029h,017h
    db 03Ch,017h,077h,017h,09Ch,017h,09Ch,017h,0BEh,017h,03Ch,017h,00h,00h,06Ch,012h
    db 0E4h,034h,0FFh,017h,0B3h,018h,0E4h,034h,0FFh,017h,0B3h,018h,0DEh,018h,07h,019h
    db 0C0h,019h,0B3h,018h,00h,00h,08Ah,012h,0E4h,034h,0F6h,019h,0ACh,01Ah,0E4h,034h
    db 0F6h,019h,0ACh,01Ah,0D5h,01Ah,041h,01Bh,010h,01Bh,0ACh,01Ah,00h,00h,0A2h,012h
    db 091h,078h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0Eh,081h,0Eh,080h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh
    db 0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh
    db 0E1h,0Eh,081h,0Eh,0Eh,081h,0Eh,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
    db 0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
    db 0Ch,0Eh,0E1h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0Eh,0Eh,0Eh,080h,091h,06Ch,0E5h
    db 012h,012h,012h,012h,012h,012h,012h,012h,08Eh,088h,013h,090h,01Ch,091h,078h,0E1h
    db 0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h
    db 015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h
    db 0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch
    db 0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h
    db 015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h
    db 0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch
    db 080h,0E1h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h
    db 011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
    db 081h,011h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h
    db 013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,015h,081h,015h,015h,081h,015h
    db 015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,0EBh,015h,080h,0E1h
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
    db 080h,0E1h,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
    db 082h,0Eh,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h,082h
    db 010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,013h,082h,013h,013h,082h,013h
    db 013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h
    db 082h,013h,080h,084h,0FBh,0E1h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
    db 081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h
    db 011h,081h,011h,011h,081h,011h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,015h,081h
    db 015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h
    db 0EBh,015h,084h,00h,080h,090h,058h,091h,04Ah,0F7h,032h,082h,035h,0EBh,037h,039h
    db 0F7h,032h,082h,035h,0EBh,037h,039h,080h,0EBh,030h,0E1h,030h,081h,030h,081h,081h
    db 0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,030h,0E1h,030h,081h,030h,081h,081h
    db 0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,032h,0E1h,032h,081h,032h,081h,081h
    db 0EDh,032h,0E1h,032h,081h,032h,081h,081h,0EDh,034h,0E1h,034h,081h,034h,081h,081h
    db 0F9h,034h,080h,0FFh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0FFh,02Dh
    db 0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0FFh,02Dh,0E1h,081h,02Dh,081h,081h
    db 02Dh,081h,081h,02Dh,0F7h,02Dh,082h,080h,0FEh,032h,0E1h,081h,034h,081h,081h,034h
    db 0E3h,081h,0E2h,034h,0F7h,035h,037h,0FEh,034h,0E1h,081h,034h,081h,081h,034h,0E3h
    db 081h,0E2h,034h,0F7h,037h,0F6h,082h,0E0h,081h,080h,084h,07h,0EBh,024h,0E1h,024h
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,026h,0E1h,026h
    db 081h,026h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,028h,0E1h,028h
    db 081h,028h,081h,081h,0F8h,028h,0E0h,081h,084h,00h,080h,090h,058h,091h,04Ah,0F7h
    db 02Dh,082h,030h,0EBh,032h,034h,0F7h,02Dh,082h,030h,0EBh,032h,034h,080h,0EBh,029h
    db 0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,029h
    db 0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,02Bh
    db 0E1h,02Bh,081h,02Bh,081h,081h,0EDh,02Bh,0E1h,02Bh,081h,02Bh,081h,081h,0EDh,02Dh
    db 0E1h,02Dh,081h,02Dh,081h,081h,0F9h,02Dh,080h,0FFh,032h,0E1h,081h,032h,081h,081h
    db 032h,081h,081h,032h,0FFh,032h,0E1h,081h,032h,081h,081h,032h,081h,081h,032h,0FFh
    db 032h,0E1h,081h,032h,081h,081h,032h,081h,081h,032h,0F7h,032h,082h,080h,0FEh,02Dh
    db 0E1h,081h,02Dh,081h,081h,02Dh,0E3h,081h,0E2h,02Dh,0F7h,030h,032h,0FEh,02Dh,0E1h
    db 081h,02Dh,081h,081h,02Dh,0E3h,081h,0E2h,02Dh,0F7h,032h,0F6h,082h,0E0h,081h,080h
    db 084h,07h,0EBh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh
    db 081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh
    db 081h,081h,0EDh,01Fh,0E1h,01Fh,081h,01Fh,081h,081h,0EDh,01Fh,0E1h,01Fh,081h,01Fh
    db 081h,081h,0EDh,021h,0E1h,021h,081h,021h,081h,081h,0F8h,021h,0E0h,081h,084h,00h
    db 080h,090h,058h,091h,04Ah,0F7h,026h,082h,029h,0EBh,02Bh,02Dh,0F7h,026h,082h,029h
    db 0EBh,02Bh,02Dh,080h,0EBh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
    db 081h,024h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,026h,0E1h,026h
    db 081h,026h,081h,081h,0EDh,028h,0E1h,028h,081h,028h,081h,081h,0F9h,028h,080h,0FFh
    db 021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h,0FFh,021h,0E1h,081h,021h,081h
    db 081h,021h,081h,081h,021h,0FFh,021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h
    db 0F7h,021h,082h,080h,0FEh,026h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h
    db 0F7h,029h,02Bh,0FEh,028h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h,0F7h
    db 02Bh,0F6h,082h,0E0h,081h,080h,084h,07h,0EBh,018h,0E1h,018h,081h,018h,081h,081h
    db 0EDh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,018h,0E1h,018h,081h,018h,081h,081h
    db 0EDh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,01Ah,0E1h,01Ah,081h,01Ah,081h,081h
    db 0EDh,01Ah,0E1h,01Ah,081h,01Ah,081h,081h,0EDh,01Ch,0E1h,01Ch,081h,01Ch,081h,081h
    db 0F8h,01Ch,0E0h,081h,084h,00h,080h,090h,02Ch,091h,07Fh,08Dh,02h,08Ch,01h,089h
    db 04h,00h,04h,010h,0E5h,03Ch,0E2h,081h,089h,04h,00h,04h,010h,03Ch,082h,081h
    db 089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,03Ch,082h,081h
    db 089h,04h,00h,04h,010h,0E5h,03Ch,089h,0FCh,0FFh,04h,010h,082h,0F7h,039h,0E1h
    db 037h,039h,037h,035h,034h,0EDh,032h,0E8h,037h,03Eh,03Ch,037h,0E5h,089h,0F9h,0FFh
    db 0Ch,09h,03Eh,039h,089h,04h,00h,030h,010h,0F7h,037h,082h,0E3h,032h,0E1h,037h
    db 039h,082h,032h,037h,039h,032h,037h,039h,032h,035h,082h,037h,039h,082h,032h,037h
    db 039h,032h,037h,039h,032h,037h,082h,039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h
    db 03Ch,08Dh,05h,089h,02h,00h,024h,020h,0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h
    db 032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h
    db 03Eh,039h,032h,03Ch,035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Eh
    db 037h,032h,03Eh,037h,032h,040h,039h,034h,0E5h,040h,080h,0E3h,029h,0E1h,02Bh,0E3h
    db 02Ch,0E1h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh
    db 0E3h,02Bh,0E1h,02Dh,0E3h,02Eh,0E1h,030h,02Eh,030h,032h,0F5h,035h,0E1h,081h,032h
    db 030h,02Dh,0F7h,031h,034h,080h,090h,058h,091h,02Ch,0FFh,026h,0E1h,081h,026h,081h
    db 081h,026h,081h,081h,026h,0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h,081h,026h
    db 0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h,081h,026h,0F7h,026h,082h,080h,090h
    db 02Ch,084h,00h,08Dh,02h,091h,078h,089h,04h,00h,04h,010h,0E5h,03Ch,0E2h,081h
    db 089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,0FDh,03Ch,0E1h
    db 03Ch,03Ah,0E0h,039h,037h,0F7h,035h,0E1h,032h,032h,034h,034h,081h,037h,037h,081h
    db 081h,089h,03h,00h,07h,015h,0E8h,037h,089h,03h,00h,07h,015h,0E8h,037h,034h
    db 037h,0E5h,081h,0E2h,034h,0E0h,081h,089h,0FDh,0FFh,05h,015h,0EBh,039h,091h,060h
    db 089h,0FDh,0FFh,05h,015h,039h,091h,040h,089h,0FDh,0FFh,05h,015h,039h,091h,020h
    db 089h,0FDh,0FFh,05h,015h,0EDh,039h,090h,02Bh,091h,06Eh,0E1h,026h,02Dh,0E5h,032h
    db 032h,032h,0E1h,032h,0E1h,028h,02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h
    db 029h,02Dh,035h,035h,03Ch,082h,029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h
    db 03Eh,082h,02Bh,032h,082h,02Dh,034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h
    db 02Dh,034h,032h,02Fh,02Dh,02Bh,028h,040h,03Eh,03Bh,039h,037h,034h,0F7h,037h,090h
    db 02Ch,0EBh,03Eh,0EAh,043h,0E0h,081h,080h,090h,02Ch,084h,07h,091h,078h,0E3h,029h
    db 0E1h,02Bh,0E3h,02Ch,0E1h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch
    db 0F7h,02Eh,02Bh,0E3h,02Bh,0E1h,02Dh,0E3h,02Eh,0E1h,030h,02Eh,030h,032h,0F5h,035h
    db 0E1h,081h,032h,030h,02Dh,0F7h,031h,0F6h,034h,0E0h,081h,084h,00h,080h,0E1h,081h
    db 090h,02Ch,091h,04Ch,08Dh,02h,08Ch,01h,089h,04h,00h,04h,010h,0E5h,03Ch,0E2h
    db 081h,089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,03Ch,082h
    db 081h,089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,0E5h,03Ch
    db 089h,0FCh,0FFh,04h,010h,082h,0F7h,039h,0E1h,037h,039h,037h,035h,034h,0EDh,032h
    db 0E8h,037h,03Eh,03Ch,037h,0E5h,089h,0F9h,0FFh,0Ch,09h,03Eh,039h,089h,04h,00h
    db 030h,010h,0F7h,037h,082h,0E3h,032h,0E1h,037h,039h,082h,032h,037h,039h,032h,037h
    db 039h,032h,035h,082h,037h,039h,082h,032h,037h,039h,032h,037h,039h,032h,037h,082h
    db 039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h,03Ch,08Dh,05h,089h,02h,00h,024h
    db 020h,0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h
    db 03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Ch,035h,032h,03Ch
    db 035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Eh,037h,032h,03Eh,037h,032h,040h,039h
    db 034h,0E3h,040h,080h,0F7h,081h,081h,091h,06Ch,0E3h,029h,0E1h,02Bh,02Ch,082h,02Eh
    db 02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Dh,0E1h
    db 02Fh,0E3h,030h,0E1h,032h,030h,032h,034h,0F1h,037h,0EBh,039h,080h,0F7h,081h,081h
    db 081h,081h,090h,02Bh,091h,040h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh,02Fh,02Dh,02Fh
    db 032h,02Fh,032h,02Fh,034h,036h,039h,036h,039h,03Bh,039h,03Bh,03Eh,03Bh,03Eh,023h
    db 028h,02Ah,02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,02Fh,034h,036h,039h,036h
    db 039h,03Bh,039h,03Bh,03Eh,03Bh,03Eh,080h,0F7h,081h,081h,090h,02Ch,084h,07h,091h
    db 06Ch,0E3h,029h,0E1h,02Bh,02Ch,082h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h
    db 02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Dh,0E1h,02Fh,0E3h,030h,0E1h,032h,030h,032h,034h
    db 0F1h,037h,0EAh,039h,0E0h,081h,084h,00h,080h,090h,02Ch,091h,04Ch,08Dh,02h,0E1h
    db 081h,089h,04h,00h,04h,010h,0E5h,03Ch,0E2h,081h,089h,04h,00h,04h,010h,03Ch
    db 082h,081h,089h,04h,00h,04h,010h,0FDh,03Ch,0E1h,03Ch,03Ah,0E0h,039h,037h,0F7h
    db 035h,0E1h,032h,032h,034h,034h,081h,037h,037h,081h,081h,089h,03h,00h,07h,015h
    db 0E8h,037h,089h,03h,00h,07h,015h,0E8h,037h,034h,037h,0E5h,081h,0E2h,034h,0E0h
    db 081h,089h,0FDh,0FFh,05h,015h,0EBh,039h,091h,030h,089h,0FDh,0FFh,05h,015h,039h
    db 091h,020h,089h,0FDh,0FFh,05h,015h,039h,091h,010h,089h,0FDh,0FFh,05h,015h,0EDh
    db 039h,090h,02Bh,091h,046h,0E1h,026h,02Dh,0E5h,032h,032h,032h,0E1h,032h,0E1h,028h
    db 02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h,029h,02Dh,035h,035h,03Ch,082h
    db 029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h,03Eh,082h,02Bh,032h,082h,02Dh
    db 034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h,02Dh,034h,032h,02Fh,02Dh,02Bh
    db 028h,040h,03Eh,03Bh,039h,037h,034h,0F7h,037h,090h,02Ch,0EBh,03Eh,0E8h,043h,0E0h
    db 081h,080h,05h,08h,0Ch,01Ch,014h,01Ch,016h,01Ch,020h,01Ch,028h,01Ch,030h,01Ch
    db 038h,01Ch,03Eh,01Ch,03Dh,01Dh,062h,01Dh,00h,00h,0Eh,01Ch,0A5h,01Dh,0BBh,01Dh
    db 0BFh,01Dh,0F1h,01Dh,00h,00h,018h,01Ch,044h,01Ch,067h,01Ch,00h,00h,022h,01Ch
    db 097h,01Ch,0BAh,01Ch,00h,00h,02Ah,01Ch,0EAh,01Ch,0Dh,01Dh,00h,00h,032h,01Ch
    db 021h,01Eh,00h,00h,038h,01Ch,0BBh,01Eh,00h,00h,03Eh,01Ch,090h,058h,091h,06Eh
    db 0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,091h,06Eh
    db 0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,080h,091h
    db 06Eh,0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,091h
    db 06Eh,0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,091h
    db 06Eh,0F7h,02Fh,082h,02Dh,0EBh,028h,091h,07Fh,0E2h,02Dh,081h,02Fh,081h,080h,090h
    db 058h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h,028h
    db 081h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h,028h
    db 081h,080h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h
    db 028h,081h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h
    db 028h,081h,091h,06Eh,0F7h,02Dh,082h,028h,0EBh,024h,091h,07Fh,0E2h,028h,081h,02Bh
    db 081h,080h,090h,058h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh,0E2h
    db 024h,081h,026h,081h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh,0E2h
    db 024h,081h,026h,081h,080h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh
    db 0E2h,024h,081h,026h,081h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh
    db 0E2h,024h,081h,026h,081h,091h,06Eh,0F7h,028h,082h,026h,0EBh,02Bh,091h,07Fh,0E2h
    db 026h,081h,028h,081h,080h,091h,078h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
    db 0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
    db 0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0Ch,0E1h,0Eh,081h,0Eh,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,091h,06Ch,0E5h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h
    db 08Eh,0A8h,01Dh,090h,01Ch,091h,068h,0E1h,015h,015h,015h,015h,015h,015h,018h,018h
    db 018h,018h,018h,018h,015h,015h,015h,015h,015h,015h,018h,018h,018h,01Ah,081h,01Ah
    db 015h,015h,015h,015h,015h,015h,018h,018h,018h,018h,018h,018h,015h,015h,015h,015h
    db 015h,015h,018h,018h,018h,01Ah,081h,01Ah,080h,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah
    db 01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch,01Ch
    db 01Ch,01Ah,01Ah,01Ah,01Ah,01Ah,01Ah,018h,01Ah,01Ah,01Ah,01Ah,01Ah,018h,018h,018h
    db 018h,018h,018h,0E2h,013h,081h,01Ch,081h,080h,0F7h,081h,081h,081h,081h,090h,02Ch
    db 091h,07Fh,0E2h,040h,081h,091h,03Ch,040h,081h,091h,01Fh,040h,081h,091h,0Ah,040h
    db 0FAh,081h,091h,07Fh,0E2h,043h,081h,091h,03Ch,043h,081h,091h,01Fh,043h,081h,091h
    db 0Ah,043h,0FAh,081h,091h,07Fh,0E2h,040h,081h,091h,03Ch,040h,081h,091h,032h,040h
    db 081h,091h,028h,040h,081h,040h,081h,091h,01Eh,040h,081h,091h,014h,040h,081h,091h
    db 0Ah,040h,081h,091h,07Fh,03Eh,081h,091h,03Ch,03Eh,081h,091h,032h,03Eh,081h,091h
    db 028h,03Eh,081h,03Eh,081h,091h,01Eh,03Eh,081h,091h,014h,03Eh,081h,091h,0Ah,03Eh
    db 081h,091h,07Fh,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,091h,06Eh,0E1h
    db 03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh
    db 0F1h,03Eh,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0F7h,081h,081h
    db 081h,081h,080h,0F7h,081h,081h,081h,081h,0E0h,081h,090h,02Ch,088h,04Eh,0E2h,040h
    db 081h,091h,03Ch,040h,081h,091h,01Fh,040h,081h,091h,0Ah,040h,0FAh,081h,091h,07Fh
    db 0E2h,043h,081h,091h,03Ch,043h,081h,091h,01Fh,043h,081h,091h,0Ah,043h,0FAh,081h
    db 091h,07Fh,0E2h,040h,081h,091h,03Ch,040h,081h,091h,032h,040h,081h,091h,028h,040h
    db 081h,040h,081h,091h,01Eh,040h,081h,091h,014h,040h,081h,091h,0Ah,040h,081h,091h
    db 07Fh,03Eh,081h,091h,03Ch,03Eh,081h,091h,032h,03Eh,081h,091h,028h,03Eh,081h,03Eh
    db 081h,091h,01Eh,03Eh,081h,091h,014h,03Eh,081h,091h,0Ah,03Eh,081h,0F6h,081h,091h
    db 07Fh,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,03Bh,039h,03Ch,03Bh
    db 03Ch,03Eh,0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0E1h
    db 02Fh,034h,037h,039h,03Bh,081h,0E2h,032h,081h,02Fh,081h,0F7h,081h,081h,081h,081h
    db 080h,05h,07h,06Bh,01Fh,075h,01Fh,069h,01Fh,06Dh,01Fh,06Fh,01Fh,071h,01Fh,073h
    db 01Fh,077h,01Fh,0B5h,01Fh,0CDh,01Fh,0E7h,01Fh,011h,020h,06Ah,020h,01h,020h,090h
    db 01Ch,091h,063h,0E1h,09h,0Eh,013h,0Eh,013h,015h,0Eh,013h,015h,018h,015h,01Ah
    db 01Fh,018h,013h,015h,013h,0Eh,011h,016h,018h,01Bh,018h,01Dh,022h,01Bh,016h,018h
    db 016h,011h,0Eh,013h,015h,018h,015h,01Ah,01Fh,018h,013h,015h,013h,0Eh,013h,018h
    db 01Ah,01Dh,01Ah,01Fh,024h,01Dh,018h,01Ah,018h,013h,08Eh,082h,01Fh,0E1h,091h,078h
    db 0Eh,0Eh,0Ch,0Eh,0Eh,0Ch,0Eh,0Ch,0Ch,0Eh,0Ch,0Ch,0Eh,0Eh,0Ch,0Eh
    db 0Eh,0Ch,08Eh,0B5h,01Fh,0EBh,081h,090h,058h,091h,05Ch,0E5h,02Dh,02Bh,02Eh,02Dh
    db 030h,02Eh,02Dh,02Bh,02Dh,02Bh,02Eh,02Dh,032h,030h,02Eh,02Bh,08Eh,0D4h,01Fh,0EBh
    db 081h,090h,058h,091h,05Ch,0E5h,021h,01Fh,022h,021h,024h,022h,021h,01Fh,021h,01Fh
    db 022h,021h,026h,024h,022h,01Fh,08Eh,0EEh,01Fh,091h,064h,0E5h,081h,081h,012h,012h
    db 0E3h,012h,0E1h,016h,0E5h,012h,08Eh,06h,020h,090h,02Ch,091h,068h,0E1h,021h,026h
    db 02Bh,026h,02Bh,02Dh,0FFh,081h,081h,081h,081h,081h,081h,0F1h,039h,0E1h,037h,032h
    db 039h,0F7h,03Ch,0F1h,039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h,039h,0E1h
    db 037h,032h,039h,0F7h,03Ch,0F1h,039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h
    db 040h,0E1h,03Eh,03Ch,039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,0F1h
    db 040h,0E1h,03Eh,03Ch,039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,08Eh
    db 01Ch,020h,0E1h,081h,090h,02Ch,091h,055h,021h,026h,02Bh,026h,02Bh,02Dh,08Eh,01Ch
    db 020h,05h,08h,08Bh,020h,08Dh,020h,08Fh,020h,091h,020h,093h,020h,095h,020h,097h
    db 020h,099h,020h,09Bh,020h,0D1h,020h,0DFh,020h,01Dh,021h,02Dh,021h,03Dh,021h,04Dh
    db 021h,055h,022h,091h,07Fh,0E3h,0Ch,0Ch,081h,0Eh,081h,081h,0Ch,0Ch,081h,0Eh
    db 081h,081h,0Ch,081h,081h,0Eh,081h,081h,0Ch,0Ch,081h,0Eh,081h,081h,0Ch,0Ch
    db 081h,0Eh,081h,081h,0Ch,0Ch,0Ch,0Eh,081h,081h,0Ch,081h,081h,0Eh,081h,081h
    db 0Ch,0Ch,081h,0Eh,081h,081h,08Eh,09Bh,020h,0E2h,091h,06Ch,012h,081h,012h,081h
    db 012h,081h,012h,081h,08Eh,0D4h,020h,090h,01Ch,091h,066h,0E1h,06h,0Ah,0Dh,06h
    db 0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah
    db 0Dh,06h,0Ah,0Dh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh
    db 08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,0Ah,0Fh,011h,0Ah
    db 0Fh,011h,08Eh,014h,021h,090h,058h,091h,05Ah,0F7h,027h,082h,029h,082h,02Bh,082h
    db 082h,082h,08Eh,026h,021h,090h,058h,091h,05Ah,0F7h,01Eh,082h,020h,082h,022h,082h
    db 082h,082h,08Eh,036h,021h,090h,058h,091h,05Ah,0F7h,023h,082h,025h,082h,027h,082h
    db 082h,082h,08Eh,046h,021h,090h,02Ch,091h,063h,084h,00h,0E1h,033h,081h,033h,031h
    db 081h,0EBh,033h,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h,035h,081h
    db 035h,033h,081h,0EBh,035h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h
    db 037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h
    db 0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h
    db 037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh
    db 037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h
    db 05Ah,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h
    db 037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h
    db 081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,046h,037h,081h,037h
    db 035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h
    db 035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,032h,037h,081h,037h,035h,081h,0EBh,037h
    db 0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h
    db 037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah
    db 037h,035h,033h,091h,01Eh,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h
    db 037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,08Eh,03Dh,022h,090h,02Ch,091h
    db 03Bh,084h,00h,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h,033h,081h
    db 033h,031h,081h,0EBh,033h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h
    db 035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h,037h,081h,037h,035h,081h,0EBh,037h
    db 0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h
    db 037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah
    db 037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h
    db 081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,028h,037h,081h,037h,035h,081h,0EBh
    db 037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h
    db 081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h
    db 03Ah,037h,035h,033h,091h,01Eh,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h
    db 081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h
    db 0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h
    db 091h,014h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h
    db 037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,0Ah,08Eh,03Dh
    db 022h,05h,08h,05Bh,023h,05Dh,023h,05Fh,023h,07Bh,023h,097h,023h,0B3h,023h,0CFh
    db 023h,0E7h,023h,0FFh,023h,02Ch,024h,042h,024h,047h,024h,047h,024h,0A8h,024h,047h
    db 024h,047h,024h,0A8h,024h,0D2h,034h,0A8h,024h,0D5h,034h,0A8h,024h,0CFh,034h,00h
    db 00h,061h,023h,09h,025h,0Dh,025h,0Dh,025h,038h,025h,0Dh,025h,0Dh,025h,038h
    db 025h,0D2h,034h,038h,025h,0D5h,034h,038h,025h,0CFh,034h,00h,00h,07Dh,023h,042h
    db 025h,046h,025h,046h,025h,071h,025h,046h,025h,046h,025h,071h,025h,0D2h,034h,071h
    db 025h,0D5h,034h,071h,025h,0CFh,034h,00h,00h,099h,023h,07Bh,025h,07Fh,025h,07Fh
    db 025h,0AAh,025h,07Fh,025h,07Fh,025h,0AAh,025h,0D2h,034h,0AAh,025h,0D5h,034h,0AAh
    db 025h,0CFh,034h,00h,00h,0B5h,023h,0E4h,034h,0B7h,025h,041h,026h,086h,026h,041h
    db 026h,0D2h,034h,041h,026h,0D5h,034h,041h,026h,0CFh,034h,00h,00h,0D1h,023h,0E4h
    db 034h,0ECh,026h,078h,027h,0BFh,027h,078h,027h,0D2h,034h,078h,027h,0D5h,034h,078h
    db 027h,0CFh,034h,00h,00h,0E9h,023h,091h,07Ch,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch
    db 0Eh,081h,081h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0Eh,081h,081h,0E5h,0Ch,0Eh
    db 0E3h,0Ch,0E1h,0Ch,0Eh,081h,081h,0E5h,0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,08Eh,01h,024h,091h,07Fh,0E5h,012h,012h,012h,012h,012h,012h,012h,012h,012h
    db 012h,012h,012h,012h,012h,012h,081h,08Eh,02Fh,024h,090h,01Ch,091h,078h,0E1h,012h
    db 012h,012h,012h,081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h
    db 012h,012h,012h,012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h
    db 010h,081h,010h,0Eh,0Eh,0Eh,0Eh,081h,0Eh,010h,010h,010h,010h,081h,010h,012h
    db 012h,012h,012h,081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h
    db 012h,012h,012h,012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h
    db 010h,081h,010h,0Eh,0Eh,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,081h,0Eh,080h
    db 0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh
    db 081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,08h,08h,08h,08h,081h,08h,08h,08h
    db 08h,0Bh,081h,0Bh,08h,08h,08h,08h,081h,08h,08h,08h,08h,08h,081h,08h
    db 0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh
    db 081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,09h,09h,09h,09h,081h,09h,09h,09h
    db 09h,09h,081h,09h,0Bh,0Bh,0Bh,0Bh,081h,0Bh,0Bh,0Bh,0Bh,0Bh,081h,0Bh
    db 080h,090h,058h,091h,04Ch,0EEh,02Ah,0E2h,081h,028h,081h,0EEh,02Ah,0E2h,081h,028h
    db 081h,0F7h,028h,0E8h,026h,0E2h,081h,0E8h,028h,0E2h,081h,0EEh,02Ah,0E2h,081h,028h
    db 081h,0EEh,02Ah,0E2h,081h,028h,081h,0F7h,028h,0E8h,026h,0E2h,081h,0EBh,026h,080h
    db 0F7h,025h,082h,020h,081h,025h,082h,082h,023h,080h,090h,058h,091h,04Ch,0EEh,02Dh
    db 0E2h,081h,02Dh,081h,0EEh,02Dh,0E2h,081h,02Dh,081h,0F7h,02Ch,0E8h,02Bh,0E2h,081h
    db 0E8h,02Ch,0E2h,081h,0EEh,02Dh,0E2h,081h,02Dh,081h,0EEh,02Dh,0E2h,081h,02Dh,081h
    db 0F7h,02Ch,0E8h,02Bh,0E2h,081h,0EBh,02Ah,080h,0F7h,081h,081h,023h,081h,081h,081h
    db 081h,081h,080h,090h,058h,091h,04Ch,0EEh,031h,0E2h,081h,031h,081h,0EEh,031h,0E2h
    db 081h,031h,081h,0F7h,02Fh,0E8h,02Fh,0E2h,081h,0E8h,02Fh,0E2h,081h,0EEh,031h,0E2h
    db 081h,031h,081h,0EEh,031h,0E2h,081h,031h,081h,0F7h,02Fh,0E8h,02Fh,0E2h,081h,0EBh
    db 02Dh,080h,0F7h,028h,082h,081h,0EBh,01Eh,020h,0F7h,028h,082h,021h,027h,080h,090h
    db 02Ch,091h,078h,08Dh,03h,08Ch,01h,089h,01h,00h,04h,040h,0F7h,036h,082h,0E1h
    db 039h,038h,036h,039h,038h,036h,038h,036h,034h,038h,036h,034h,0F7h,031h,0E5h,038h
    db 0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h,039h,0E1h,081h,02Ah,02Ch,02Dh,031h
    db 02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h,0EDh,02Ah,0E9h,081h,0E1h,02Fh,031h
    db 02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h
    db 02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h,036h,0E3h,039h,0F7h,03Bh,0E1h,081h
    db 03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h
    db 03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h,045h,044h,042h,040h,042h,040h,03Dh
    db 040h,03Dh,03Bh,039h,0F1h,036h,0E5h,081h,080h,090h,056h,0E1h,034h,036h,031h,034h
    db 036h,038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,034h,036h
    db 031h,034h,036h,038h,0EFh,038h,0E7h,039h,0F4h,038h,0E2h,081h,0E1h,034h,036h,031h
    db 034h,036h,038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,034h
    db 036h,031h,034h,036h,038h,0EFh,039h,0E1h,038h,039h,082h,0F9h,03Bh,080h,090h,02Ch
    db 0E8h,038h,0FFh,031h,0E4h,081h,0E1h,036h,0E5h,039h,0E2h,031h,0ECh,034h,0E1h,02Ch
    db 0E3h,02Dh,0E5h,02Ah,02Dh,0E7h,02Ah,0E5h,02Ch,0E9h,02Dh,0E1h,02Fh,0E3h,031h,0F9h
    db 02Fh,0E1h,034h,0EDh,036h,0E1h,038h,0E3h,039h,0F9h,036h,0E5h,039h,03Dh,0EFh,045h
    db 0E1h,042h,0E3h,045h,0E5h,042h,0E7h,03Dh,0E3h,042h,0E1h,03Dh,0EFh,039h,0E1h,038h
    db 039h,038h,0F1h,036h,0E1h,034h,0E3h,038h,0E1h,039h,0E3h,038h,0E5h,034h,036h,031h
    db 0F3h,034h,0E3h,02Ch,0E5h,034h,0E1h,02Ch,0E5h,034h,0E1h,02Ch,034h,0E5h,02Dh,0EDh
    db 02Ah,0E5h,081h,080h,0E1h,081h,090h,02Ch,091h,050h,08Dh,03h,08Ch,01h,089h,01h
    db 00h,04h,040h,0F7h,036h,082h,0E1h,039h,038h,036h,039h,038h,036h,038h,036h,034h
    db 038h,036h,034h,0F7h,031h,0E5h,038h,0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h
    db 039h,0E1h,081h,02Ah,02Ch,02Dh,031h,02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h
    db 0EDh,02Ah,0E9h,081h,0E1h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh
    db 031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h
    db 036h,0E3h,039h,0F7h,03Bh,0E1h,081h,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh
    db 039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h
    db 045h,044h,042h,040h,042h,040h,03Dh,040h,03Dh,03Bh,039h,0F1h,036h,0E3h,081h,080h
    db 0E0h,081h,090h,056h,0E1h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h
    db 038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,0EFh,038h,0E7h
    db 039h,0F4h,038h,0E2h,081h,0E1h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h
    db 036h,038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,0EFh,039h
    db 0E1h,038h,039h,082h,0F8h,03Bh,080h,0E1h,081h,090h,02Ch,0E8h,038h,0FFh,031h,0E4h
    db 081h,0E1h,036h,0E5h,039h,0E2h,031h,0ECh,034h,0E1h,02Ch,0E3h,02Dh,0E5h,02Ah,02Dh
    db 0E7h,02Ah,0E5h,02Ch,0E9h,02Dh,0E1h,02Fh,0E3h,031h,0F9h,02Fh,0E1h,034h,0EDh,036h
    db 0E1h,038h,0E3h,039h,0F9h,036h,0E5h,039h,03Dh,0EFh,045h,0E1h,042h,0E3h,045h,0E5h
    db 042h,0E7h,03Dh,0E3h,042h,0E1h,03Dh,0EFh,039h,0E1h,038h,039h,038h,0F1h,036h,0E1h
    db 034h,0E3h,038h,0E1h,039h,0E3h,038h,0E5h,034h,036h,031h,0F3h,034h,0E3h,02Ch,0E5h
    db 034h,0E1h,02Ch,0E5h,034h,0E1h,02Ch,034h,0E5h,02Dh,0EDh,02Ah,0E3h,081h,080h,04h
    db 07h,037h,028h,039h,028h,03Bh,028h,04Bh,028h,05Bh,028h,06Bh,028h,079h,028h,087h
    db 028h,096h,028h,0A0h,028h,0A0h,028h,0A0h,028h,0A0h,028h,06h,029h,0A0h,028h,00h
    db 00h,03Fh,028h,067h,029h,067h,029h,073h,029h,073h,029h,086h,029h,073h,029h,00h
    db 00h,04Fh,028h,099h,029h,099h,029h,0A5h,029h,0A5h,029h,0BAh,029h,0A5h,029h,00h
    db 00h,05Fh,028h,0CDh,029h,0CDh,029h,0D9h,029h,0D9h,029h,0E7h,029h,00h,00h,06Fh
    db 028h,05h,02Ah,05h,02Ah,011h,02Ah,011h,02Ah,026h,02Ah,00h,00h,07Dh,028h,091h
    db 07Ch,0E1h,0Ch,0Ch,081h,0Ch,081h,0Ch,0Eh,0E9h,081h,08Eh,089h,028h,091h,078h
    db 0E5h,012h,012h,012h,012h,08Eh,099h,028h,090h,01Ch,091h,078h,0E1h,0Eh,081h,0Eh
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,011h,081h,011h
    db 081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h
    db 081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h
    db 081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,080h,0Ch,081h
    db 0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h
    db 0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h
    db 0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Fh,081h
    db 0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h
    db 0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h
    db 0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,080h,090h
    db 02Ch,091h,06Ah,0FFh,015h,082h,082h,018h,082h,082h,080h,0F7h,015h,0EBh,017h,018h
    db 015h,082h,017h,018h,0F7h,015h,0EBh,017h,018h,015h,082h,017h,018h,080h,0F7h,013h
    db 0EBh,017h,018h,013h,082h,017h,018h,0F7h,013h,0EBh,017h,018h,013h,082h,017h,018h
    db 080h,090h,02Ch,091h,06Ah,0FFh,01Ah,082h,082h,01Dh,082h,082h,080h,091h,046h,0F7h
    db 021h,0EBh,023h,024h,021h,082h,023h,024h,0F7h,021h,0EBh,023h,024h,021h,082h,023h
    db 024h,080h,0F7h,01Fh,0EBh,023h,024h,01Fh,082h,023h,024h,0F7h,01Fh,0EBh,023h,024h
    db 01Fh,082h,023h,024h,080h,090h,02Ch,091h,042h,0FFh,021h,082h,082h,024h,082h,082h
    db 080h,090h,056h,091h,05Ah,0F7h,03Ch,082h,082h,082h,03Ch,082h,039h,082h,080h,0F7h
    db 037h,082h,082h,082h,03Ah,082h,081h,081h,081h,081h,081h,081h,081h,0ECh,081h,0E0h
    db 040h,081h,040h,0E8h,081h,0E0h,040h,081h,040h,0F5h,081h,081h,080h,090h,02Ch,091h
    db 042h,0FFh,026h,082h,082h,029h,082h,082h,080h,090h,056h,091h,05Ah,0F1h,03Ah,039h
    db 082h,082h,082h,0E5h,081h,0F1h,03Ah,039h,0EBh,037h,0F7h,035h,082h,080h,0F7h,034h
    db 082h,082h,082h,033h,082h,03Ch,03Fh,03Eh,082h,082h,082h,081h,0ECh,081h,0E0h,045h
    db 081h,045h,0E8h,081h,0E0h,045h,081h,045h,0F5h,081h,081h,080h,05h,08h,056h,02Ah
    db 064h,02Ah,076h,02Ah,08Ah,02Ah,09Ch,02Ah,0AEh,02Ah,0C0h,02Ah,0D0h,02Ah,0E0h,02Ah
    db 0E3h,02Ah,044h,02Bh,06h,02Ch,044h,02Bh,00h,00h,056h,02Ah,068h,02Ch,06Bh,02Ch
    db 08Ch,02Ch,08Ch,02Ch,06Bh,02Ch,08Ch,02Ch,08Ch,02Ch,00h,00h,064h,02Ah,0ADh,02Ch
    db 0B1h,02Ch,0Bh,02Dh,0Bh,02Dh,06Dh,02Dh,06Dh,02Dh,0Bh,02Dh,0Bh,02Dh,00h,00h
    db 076h,02Ah,09Eh,02Dh,0A2h,02Dh,0ACh,02Dh,0ACh,02Dh,0B6h,02Dh,0ACh,02Dh,0ACh,02Dh
    db 00h,00h,08Ah,02Ah,0C0h,02Dh,0C4h,02Dh,0CEh,02Dh,0CEh,02Dh,0D8h,02Dh,0CEh,02Dh
    db 0CEh,02Dh,00h,00h,09Ch,02Ah,0E2h,02Dh,0E6h,02Dh,0F0h,02Dh,0F0h,02Dh,0FAh,02Dh
    db 0F0h,02Dh,0F0h,02Dh,00h,00h,0AEh,02Ah,0E4h,034h,04h,02Eh,021h,02Eh,08Dh,02Eh
    db 08Dh,02Eh,0AFh,02Eh,00h,00h,0C0h,02Ah,0E4h,034h,027h,02Fh,046h,02Fh,08Dh,02Eh
    db 08Dh,02Eh,0AFh,02Eh,00h,00h,0D0h,02Ah,091h,078h,0E1h,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
    db 0Eh,0Eh,0Eh,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Eh,0Eh,0Eh,0Eh,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Eh
    db 0Eh,0Eh,0Eh,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0Ch,081h,0Ch
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Eh,0Eh,0Ch,0Eh,0Eh,081h,080h,0E1h,0Ch
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Eh,0Eh,0Eh,0Eh,0Ch
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
    db 0Eh,081h,081h,0Ch,081h,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h
    db 091h,078h,0E5h,019h,012h,012h,012h,012h,012h,012h,012h,019h,012h,012h,012h,012h
    db 012h,012h,012h,019h,012h,012h,012h,012h,012h,012h,012h,019h,012h,012h,012h,012h
    db 012h,012h,012h,080h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h
    db 012h,012h,012h,012h,080h,090h,01Ch,091h,078h,0E1h,09h,082h,09h,09h,09h,09h
    db 09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h
    db 09h,0E1h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h
    db 09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h,09h,09h,09h,09h,082h,09h,09h
    db 09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h,09h
    db 09h,09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h
    db 09h,09h,080h,0E1h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h
    db 09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h
    db 09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h
    db 09h,013h,09h,013h,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh
    db 09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Dh,09h,0Eh
    db 09h,010h,09h,0Dh,09h,0Eh,09h,010h,09h,0Dh,09h,0Eh,09h,010h,09h,0Dh
    db 09h,0Eh,09h,010h,080h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h
    db 09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,07h,082h,07h
    db 07h,07h,07h,07h,082h,07h,07h,07h,07h,09h,082h,09h,09h,09h,09h,09h
    db 082h,09h,09h,09h,09h,080h,090h,058h,091h,05Ah,0F7h,026h,082h,024h,082h,025h
    db 082h,026h,025h,080h,0F7h,026h,082h,026h,082h,026h,082h,026h,025h,080h,0F7h,026h
    db 026h,026h,028h,026h,026h,026h,028h,080h,090h,058h,091h,05Ah,0F7h,023h,082h,01Fh
    db 082h,021h,082h,021h,021h,080h,0F7h,023h,082h,023h,082h,021h,082h,021h,021h,080h
    db 0F7h,021h,023h,023h,025h,021h,023h,023h,025h,080h,090h,058h,091h,05Ah,0F7h,01Fh
    db 082h,01Ch,082h,01Ch,082h,01Eh,01Ch,080h,0F7h,01Fh,082h,01Fh,082h,01Eh,082h,01Ch
    db 01Ch,080h,0F7h,01Eh,01Eh,01Fh,021h,01Eh,01Eh,01Fh,021h,080h,090h,056h,091h,050h
    db 0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh,021h,0E9h,032h,0E7h,036h
    db 0FDh,02Dh,0E9h,026h,0E7h,028h,0FDh,025h,080h,090h,02Ch,091h,069h,0F7h,032h,0E1h
    db 039h,037h,036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h,02Dh,0EBh,031h
    db 032h,0FBh,036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h,031h,02Dh,031h
    db 032h,031h,02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h,0E3h,032h,0F4h
    db 02Dh,0E2h,081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh,02Dh,02Fh,0F0h
    db 02Ah,0E2h,081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h,031h,032h,034h
    db 032h,0F1h,036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh
    db 0F4h,031h,0E2h,081h,080h,0E1h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h
    db 032h,02Dh,0F5h,036h,0E1h,081h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h
    db 032h,036h,0F5h,039h,0E1h,081h,080h,0F1h,034h,0E3h,032h,0E5h,031h,02Fh,031h,0E7h
    db 032h,0E5h,036h,0E3h,034h,0E5h,032h,031h,0F7h,02Dh,0E1h,032h,031h,02Fh,0F1h,02Dh
    db 0E1h,02Bh,02Ah,028h,0EBh,026h,0E1h,028h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,02Fh,0E3h
    db 031h,032h,034h,0F5h,031h,0E1h,037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E0h
    db 081h,0E1h,037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E2h,081h,0E1h,03Bh,039h
    db 037h,036h,034h,032h,037h,036h,034h,032h,034h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh
    db 02Bh,02Ah,028h,02Bh,02Ah,028h,0EFh,026h,0E1h,036h,032h,02Dh,032h,0EFh,036h,0E1h
    db 032h,02Dh,0E3h,032h,0E9h,034h,0E7h,032h,0E5h,031h,0F5h,02Dh,0E1h,081h,080h,090h
    db 056h,091h,03Ch,0E1h,081h,0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh
    db 021h,0E9h,032h,0E7h,036h,0FDh,02Dh,0E9h,026h,0E7h,028h,0FBh,025h,080h,091h,06Eh
    db 0F7h,032h,0E1h,039h,037h,036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h
    db 02Dh,0EBh,031h,032h,0FBh,036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h
    db 031h,02Dh,031h,032h,031h,02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h
    db 0E3h,032h,0F4h,02Dh,0E2h,081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh
    db 02Dh,02Fh,0F0h,02Ah,0E2h,081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h
    db 031h,032h,034h,032h,0F1h,036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh
    db 032h,034h,02Dh,0F4h,031h,0E2h,081h,080h,04h,08h,0C2h,02Fh,0EAh,02Fh,012h,030h
    db 026h,030h,03Ah,030h,04Eh,030h,062h,030h,070h,030h,080h,030h,080h,030h,0A7h,030h
    db 0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h
    db 0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,00h,00h
    db 0C2h,02Fh,0D9h,030h,0D9h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h
    db 0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h
    db 0E5h,030h,0E5h,030h,0E5h,030h,00h,00h,0EAh,02Fh,0F7h,030h,0FBh,030h,01h,031h
    db 01h,031h,063h,031h,01h,031h,01h,031h,063h,031h,00h,00h,012h,030h,025h,032h
    db 029h,032h,02Fh,032h,02Fh,032h,039h,032h,02Fh,032h,02Fh,032h,039h,032h,00h,00h
    db 026h,030h,04Bh,032h,04Fh,032h,055h,032h,055h,032h,05Fh,032h,055h,032h,055h,032h
    db 05Fh,032h,00h,00h,03Ah,030h,071h,032h,075h,032h,07Bh,032h,07Bh,032h,085h,032h
    db 07Bh,032h,07Bh,032h,085h,032h,00h,00h,04Eh,030h,097h,032h,0A5h,032h,0Eh,033h
    db 059h,033h,0Eh,033h,00h,00h,062h,030h,0D8h,034h,0B2h,033h,0BDh,033h,028h,034h
    db 075h,034h,028h,034h,00h,00h,070h,030h,091h,078h,0EBh,0Ch,0E1h,0Eh,0Eh,0Eh
    db 0Eh,0Eh,081h,0EBh,0Ch,0E1h,0Eh,0Eh,0Eh,0Eh,081h,081h,0E5h,0Ch,0Ch,0Ch
    db 0Ch,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h
    db 0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh
    db 081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h
    db 0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 080h,091h,078h,0EBh,019h,081h,019h,081h,019h,081h,081h,081h,080h,0E5h,012h,012h
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,080h,090h
    db 01Ch,091h,06Eh,0F7h,013h,010h,0Bh,082h,080h,0E1h,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh
    db 081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Eh,081h,0Eh,0Eh,081h,0Eh
    db 0Eh,081h,0Eh,0Eh,081h,0Eh,010h,081h,010h,010h,081h,010h,010h,081h,010h,010h
    db 081h,010h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,080h,0E1h,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h
    db 013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h
    db 013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,010h,081h,010h,010h,081h,010h,010h,081h
    db 010h,010h,081h,010h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,013h,081h,013h,013h
    db 081h,013h,013h,081h,013h,013h,081h,013h,010h,081h,010h,010h,081h,010h,010h,081h
    db 010h,010h,081h,010h,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh
    db 0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,080h,090h,058h,091h
    db 05Ah,0F7h,02Bh,028h,02Ah,082h,080h,0F7h,01Eh,082h,082h,082h,021h,023h,01Eh,082h
    db 080h,0F7h,02Bh,082h,02Ah,082h,02Bh,082h,02Ah,082h,02Bh,02Bh,02Ah,082h,02Bh,02Bh
    db 02Ah,082h,080h,090h,058h,091h,05Ah,0F7h,026h,025h,026h,082h,080h,0F7h,01Ah,082h
    db 082h,082h,01Eh,020h,01Ah,082h,080h,0F7h,026h,082h,026h,082h,026h,082h,026h,082h
    db 026h,028h,026h,082h,026h,028h,026h,082h,080h,090h,058h,091h,05Ah,0F7h,023h,021h
    db 023h,082h,080h,0F7h,017h,082h,082h,082h,01Ah,01Ch,017h,082h,080h,0F7h,023h,082h
    db 023h,082h,023h,082h,023h,082h,023h,023h,023h,082h,023h,023h,021h,082h,080h,090h
    db 02Ch,091h,07Fh,0F7h,03Eh,03Dh,03Bh,082h,032h,031h,02Fh,082h,080h,0E3h,02Ah,0E1h
    db 02Dh,0E3h,028h,0EDh,02Ah,0E3h,02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h,032h,0E7h
    db 031h,0E5h,02Fh,0E1h,031h,02Fh,02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh,0F7h,02Ah
    db 0E9h,02Ah,0E7h,028h,0E5h,026h,0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h,02Ah,0E1h
    db 02Dh,0E3h,028h,0EDh,02Ah,0E1h,02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h,0E1h,025h
    db 023h,021h,0F7h,01Eh,0E8h,025h,026h,0E5h,023h,0E1h,028h,026h,028h,026h,028h,026h
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h
    db 028h,026h,0F7h,02Ah,082h,080h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah,02Bh,0F3h,02Ah,0E3h
    db 028h,0F9h,026h,0F7h,02Dh,0E1h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Dh,0E5h,02Bh
    db 0E1h,02Dh,0F6h,02Ah,082h,0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h,02Dh,0E3h,02Fh,0F1h
    db 032h,0E1h,031h,0E5h,032h,0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh
    db 0E3h,02Fh,0E5h,031h,0E1h,081h,0E5h,032h,0E3h,034h,0E5h,036h,037h,0F8h,036h,082h
    db 080h,0E1h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,0F5h,02Ah
    db 0E1h,081h,025h,026h,025h,026h,025h,026h,025h,026h,025h,026h,025h,026h,0F7h,023h
    db 0E9h,028h,0E7h,02Bh,0E5h,02Ah,0E9h,028h,0E7h,026h,0E5h,025h,0F7h,023h,082h,0E9h
    db 028h,0E7h,02Dh,0E9h,028h,0E7h,02Dh,0E5h,028h,02Bh,0E9h,02Ah,0E7h,028h,0E5h,02Bh
    db 0F7h,02Ah,0E3h,02Dh,0E5h,02Bh,0EBh,02Ah,0E1h,02Bh,0E3h,02Ah,0E5h,028h,0EBh,026h
    db 0E1h,026h,028h,026h,025h,0F1h,023h,0F7h,02Ah,080h,090h,056h,091h,06Eh,026h,028h
    db 02Ah,082h,091h,05Ah,080h,0E1h,081h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E3h
    db 02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h,032h,0E7h,031h,0E5h,02Fh,0E1h,031h,02Fh
    db 02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh,0F7h,02Ah,0E9h,02Ah,0E7h,028h,0E5h,026h
    db 0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E1h
    db 02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h,0E1h,025h,023h,021h,0F7h,01Eh,0E8h,025h
    db 026h,0E5h,023h,0E1h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,0F6h,02Ah,082h,080h
    db 0E1h,081h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah,02Bh,0F3h,02Ah,0E3h,028h,0F9h,026h,0F7h
    db 02Dh,0E1h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Dh,0E5h,02Bh,0E1h,02Dh,0F6h,02Ah
    db 082h,0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h,02Dh,0E3h,02Fh,0F1h,032h,0E1h,031h,0E5h
    db 032h,0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,0E3h,02Fh,0E5h,031h
    db 0E1h,081h,0E5h,032h,0E3h,034h,0E5h,036h,037h,0F7h,036h,082h,080h,0E1h,081h,026h
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,0F5h,02Ah,0E1h,081h,025h
    db 026h,025h,026h,025h,026h,025h,026h,025h,026h,025h,026h,0F7h,023h,0E9h,028h,0E7h
    db 02Bh,0E5h,02Ah,0E9h,028h,0E7h,026h,0E5h,025h,0F7h,023h,082h,0E9h,028h,0E7h,02Dh
    db 0E9h,028h,0E7h,02Dh,0E5h,028h,02Bh,0E9h,02Ah,0E7h,028h,0E5h,02Bh,0F7h,02Ah,0E3h
    db 02Dh,0E5h,02Bh,0EBh,02Ah,0E1h,02Bh,0E3h,02Ah,0E5h,028h,0EBh,026h,0E1h,026h,028h
    db 026h,025h,0F1h,023h,0F5h,02Ah,080h,084h,00h,080h,084h,02h,080h,084h,03h,080h
    db 0F7h,081h,081h,081h,081h,080h,0E4h,034h,00h,00h,0DEh,034h,0F7h,081h,081h,081h
    db 081h,081h,081h,081h,081h,080h,06h,035h,0Ch,035h,018h,035h,024h,035h,030h,035h
    db 03Ch,035h,07Ch,038h,0F5h,037h,04h,037h,09h,036h,048h,035h,00h,00h,07Fh,00h
    db 00h,01h,00h,0F7h,05h,05h,040h,02h,04h,018h,032h,0Ch,00h,01h,059h,0F7h
    db 05h,05h,030h,02h,03h,018h,032h,0Ch,00h,01h,06Ah,0F7h,05h,02h,060h,02h
    db 02h,018h,032h,0Ch,00h,01h,03Eh,0F7h,05h,02h,058h,02h,01h,018h,032h,0Ch
    db 00h,01h,047h,0F7h,05h,01h,060h,02h,00h,018h,032h,0Ch,00h,01h,041h,0F7h
    db 08h,08h,00h,064h,069h,073h,074h,067h,075h,069h,074h,061h,072h,00h,00h,03h
    db 00h,024h,032h,010h,01h,00h,02Bh,04Fh,0Eh,07h,01h,00h,00h,00h,00h,00h
    db 032h,032h,032h,032h,032h,03Eh,09h,02Ch,063h,01Ch,03h,00h,07h,019h,00h,00h
    db 00h,00h,02Ch,02Eh,048h,00h,025h,0Bh,025h,00h,047h,046h,06Eh,03h,02Eh,0Ch
    db 00h,00h,04h,020h,054h,034h,03Ah,04Ah,064h,03Dh,00h,030h,032h,010h,01h,00h
    db 026h,036h,0Eh,00h,00h,00h,0Dh,010h,01Ch,00h,05Eh,04Bh,03Ch,032h,032h,039h
    db 00h,00h,05Eh,01Bh,03h,00h,07h,02Dh,00h,00h,00h,03Ch,038h,058h,064h,00h
    db 03Ah,024h,03Dh,02h,04Ah,046h,06Eh,07h,01Bh,0Ch,00h,00h,04h,01Fh,04Eh,046h
    db 03Ah,04Ah,064h,040h,00h,02Dh,032h,010h,01h,00h,00h,043h,0Eh,00h,00h,00h
    db 00h,00h,00h,00h,032h,032h,032h,032h,032h,00h,00h,00h,064h,015h,03h,00h
    db 07h,048h,00h,00h,00h,04h,064h,064h,05Eh,00h,055h,02Ah,053h,040h,039h,032h
    db 00h,00h,00h,00h,00h,00h,04h,020h,063h,05Ch,03Ah,04Ah,064h,044h,024h,027h
    db 0F7h,08h,06h,00h,057h,061h,072h,06Dh,020h,050h,061h,064h,020h,020h,00h,07h
    db 0Fh,00h,024h,02Dh,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h
    db 00h,032h,032h,032h,032h,032h,040h,01Ah,031h,064h,010h,06h,00h,07h,064h,00h
    db 00h,00h,00h,024h,00h,00h,064h,035h,027h,027h,027h,05Ah,055h,05Bh,0Ch,01Bh
    db 0Ch,00h,00h,010h,042h,064h,00h,051h,060h,062h,00h,00h,024h,037h,0Bh,01h
    db 01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h
    db 03Eh,01Dh,023h,064h,010h,06h,00h,07h,064h,00h,00h,00h,00h,024h,00h,00h
    db 064h,035h,027h,027h,027h,05Ah,054h,05Bh,0Ch,01Bh,0Ch,00h,00h,010h,042h,064h
    db 00h,051h,060h,062h,00h,00h,024h,028h,0Bh,01h,01h,00h,00h,07h,00h,00h
    db 00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,040h,01Ah,031h,064h,010h,06h
    db 00h,07h,064h,00h,00h,00h,00h,024h,00h,00h,064h,035h,027h,027h,027h,05Ah
    db 055h,05Bh,0Ch,01Bh,0Ch,00h,00h,010h,042h,064h,00h,051h,060h,062h,00h,00h
    db 024h,03Ch,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h
    db 032h,032h,032h,032h,03Eh,01Dh,023h,064h,010h,06h,00h,07h,064h,00h,00h,00h
    db 00h,024h,00h,00h,064h,035h,027h,027h,027h,05Ah,054h,05Bh,0Ch,01Bh,0Ch,00h
    db 00h,010h,042h,064h,00h,051h,061h,062h,00h,00h,03Bh,0F7h,08h,04h,00h,050h
    db 06Fh,06Ch,079h,020h,053h,079h,06Eh,074h,068h,07h,00h,07h,00h,024h,036h,0Bh
    db 01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h
    db 032h,042h,04h,064h,064h,010h,06h,00h,07h,064h,00h,00h,00h,00h,024h,00h
    db 00h,01Eh,064h,027h,027h,027h,055h,04Ah,05Bh,0Ch,01Bh,0Ch,02h,00h,00h,064h
    db 00h,00h,02h,064h,00h,00h,00h,024h,02Eh,0Bh,01h,01h,00h,00h,07h,00h
    db 00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,040h,06h,064h,064h,010h
    db 06h,00h,07h,064h,00h,00h,00h,00h,024h,00h,00h,01Eh,064h,027h,027h,027h
    db 055h,04Ah,05Bh,0Ch,01Bh,0Ch,02h,00h,00h,064h,00h,00h,02h,064h,00h,00h
    db 00h,024h,032h,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h
    db 032h,032h,032h,032h,032h,044h,00h,064h,064h,010h,06h,00h,07h,064h,064h,00h
    db 00h,00h,024h,00h,00h,01Eh,064h,027h,027h,027h,05Bh,04Ah,05Bh,0Ch,01Bh,0Ch
    db 02h,00h,00h,064h,00h,00h,02h,064h,00h,00h,00h,024h,032h,0Bh,00h,00h
    db 00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,00h
    db 00h,00h,00h,00h,0Bh,00h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,032h,05Bh,0Ch,01Bh,0Ch,00h,05Bh,0F7h,08h,02h,00h
    db 072h,065h,073h,06Fh,06Eh,061h,06Eh,063h,065h,020h,07h,00h,03h,01h,024h,032h
    db 010h,01h,00h,00h,03Fh,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h
    db 032h,032h,03Dh,014h,036h,064h,01Eh,07h,06Bh,07h,064h,01Eh,00h,00h,040h,05Eh
    db 04Ah,05Ah,00h,031h,040h,044h,029h,05Fh,056h,05Bh,0Ch,01Bh,0Ch,02h,04h,018h
    db 018h,014h,032h,053h,03Fh,05Eh,061h,030h,024h,032h,010h,01h,00h,00h,045h,07h
    db 00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,042h,017h,036h,064h
    db 01Ch,07h,06Bh,07h,064h,01Eh,00h,00h,040h,048h,05Eh,05Eh,00h,031h,064h,051h
    db 02Dh,05Fh,056h,05Bh,0Ch,01Bh,0Ch,02h,04h,014h,01Ch,022h,02Eh,056h,03Bh,064h
    db 058h,024h,03Ah,0F7h,08h,00h,00h,046h,04Dh,020h,042h,061h,073h,073h,020h,020h
    db 020h,07h,00h,03h,00h,024h,032h,0Fh,01h,01h,00h,00h,07h,02h,00h,00h
    db 00h,00h,00h,00h,032h,032h,032h,032h,032h,040h,00h,023h,035h,01Ah,08h,00h
    db 07h,03Dh,064h,00h,03h,00h,021h,04Dh,064h,0Ch,059h,04Bh,033h,00h,062h,04Eh
    db 05Bh,0Ch,01Bh,0Ch,00h,00h,00h,0Bh,00h,04Fh,0Bh,05Ch,064h,064h,00h,024h
    db 032h,0Fh,01h,01h,00h,024h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h
    db 032h,032h,032h,03Eh,00h,031h,035h,0Ah,08h,00h,07h,04Ah,064h,00h,03h,00h
    db 00h,020h,064h,0Ch,064h,04Bh,023h,00h,064h,04Eh,05Bh,0Ch,01Bh,0Ch,00h,00h
    db 00h,0Bh,00h,04Fh,0Bh,05Ch,064h,064h,062h,0F7h
driver ends
end
