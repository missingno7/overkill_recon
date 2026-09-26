; Everything in segment frame SEG153A; modern file boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
SEG153A segment para public 'CODE'
assume cs:SEG153A,ds:nothing,ss:nothing,es:nothing
public OpenResourceFile
public loc_153A0
; Observed frame153A: private CS state and DOS/file/path operations, with
; caller segment pointers. Distinct address frame, historical OBJ count unknown.
loc_153A0:
    test ax, 08000h
    je loc_153AE
    push ax
    and ax, 0FFh
    mov word ptr cs:[073Ah], ax
    pop ax
loc_153AE:
    test ax, 04000h
    je loc_153C5
    push ax
    push di
    push es
    push cs
    pop es
    mov di, 07AEh
loc_153BB:
    movsb
    cmp byte ptr ds:[si - 1], 0FFh
    jne loc_153BB
    pop es
    pop di
    pop ax
loc_153C5:
    test ax, 02000h
    je loc_153D0
    push ax
    push cs
    call loc_15A6D
    pop ax
loc_153D0:
    test ax, 01000h
    je loc_153DF
    mov word ptr cs:[073Eh], es
    mov word ptr cs:[073Ch], di
loc_153DF:
    retf
; UNKNOWN: not yet classified as code or data
    db 057h,06h,0Eh,0E8h,091h,04h,07h,05Fh,072h,012h,053h,051h,052h,0Eh,0E8h,06Fh
    db 03h,05Ah,059h,05Bh,09Ch,050h,0Eh,0E8h,06Ah,06h,058h,09Dh,0CBh,01Eh,0Eh,07h
    db 08Bh,0F2h,0BFh,045h,03h,0FCh,0A4h,080h,07Ch,0FFh,00h,074h,06h,080h,07Ch,0FFh
    db 020h,075h,0F3h,026h,0C6h,045h,0FFh,00h,04Eh,02Eh,089h,036h,085h,03h,02Eh,08Ch
    db 01Eh,087h,03h,0Eh,01Fh,0C7h,06h,089h,03h,00h,00h,0C6h,06h,044h,03h,01h
    db 0BAh,045h,03h,0Eh,0E8h,040h,04h,073h,03h,0E9h,05Ch,02h,0B9h,01Bh,00h,033h
    db 0D2h,0BFh,0A5h,03h,0Eh,07h,0Eh,0E8h,016h,03h,0C6h,06h,044h,03h,02h,073h
    db 03h,0E9h,044h,02h,0BFh,0A5h,03h,081h,03Eh,0A5h,03h,04Dh,05Ah,0C6h,06h,044h
    db 03h,04h,074h,03h,0E9h,031h,02h,08Bh,01Eh,0ADh,03h,033h,0C9h,03h,0DBh,083h
    db 0D1h,00h,03h,0DBh,083h,0D1h,00h,03h,0DBh,083h,0D1h,00h,03h,0DBh,083h,0D1h
    db 00h,089h,01Eh,091h,03h,089h,0Eh,093h,03h,0A1h,0A9h,03h,048h,03h,0C0h,0B6h
    db 00h,08Ah,0D4h,08Ah,0E0h,08Ah,0C6h,03h,06h,0A7h,03h,083h,0D2h,00h,02Bh,0C3h
    db 01Bh,0D1h,0A3h,095h,03h,089h,016h,097h,03h,0D1h,0EAh,0D1h,0D8h,0D1h,0EAh,0D1h
    db 0D8h,0D1h,0EAh,0D1h,0D8h,0D1h,0EAh,0D1h,0D8h,05h,011h,00h,01h,06h,0AFh,03h
    db 0C7h,06h,089h,03h,00h,00h,0BBh,0FFh,0FFh,0B4h,048h,0CDh,021h,0B4h,048h,0CDh
    db 021h,0C6h,06h,044h,03h,03h,073h,03h,0E9h,0BDh,01h,0A3h,089h,03h,0B4h,02Fh
    db 0CDh,021h,089h,01Eh,08Dh,03h,08Ch,06h,08Fh,03h,0B4h,051h,0CDh,021h,089h,01Eh
    db 08Bh,03h,08Eh,06h,089h,03h,08Eh,01Eh,08Bh,03h,033h,0F6h,08Bh,0FEh,0B9h,00h
    db 01h,0FCh,0F3h,0A4h,0Eh,01Fh,08Eh,06h,089h,03h,0BFh,081h,00h,0C5h,036h,085h
    db 03h,0A4h,080h,07Ch,0FFh,00h,075h,0F9h,04Eh,026h,0C6h,045h,0FFh,0Dh,026h,0C6h
    db 05h,00h,0Eh,01Fh,02Bh,036h,085h,03h,08Bh,0C6h,026h,0A2h,080h,00h,08Bh,0Eh
    db 091h,03h,08Bh,016h,093h,03h,083h,0E9h,01Bh,083h,0DAh,00h,08Bh,01Eh,044h,07h
    db 087h,0CAh,0B8h,01h,042h,0CDh,021h,0C6h,06h,044h,03h,02h,073h,03h,0E9h,047h
    db 01h,08Bh,0Eh,095h,03h,08Bh,016h,097h,03h,0A1h,089h,03h,05h,010h,00h,08Eh
    db 0C0h,033h,0FFh,08Bh,01Eh,044h,07h,0Eh,0E8h,0F5h,01h,0C6h,06h,044h,03h,02h
    db 073h,03h,0E9h,023h,01h,0BEh,05Ch,07h,08Bh,04Ch,05h,08Bh,054h,07h,03h,0Eh
    db 0AAh,07h,013h,016h,0ACh,07h,03h,0Eh,0BDh,03h,083h,0D2h,00h,087h,0CAh,08Bh
    db 01Eh,044h,07h,0B8h,00h,042h,0CDh,021h,0C6h,06h,044h,03h,02h,073h,03h,0E9h
    db 0F6h,00h,083h,03Eh,0ABh,03h,00h,074h,04Ah,0B9h,04h,00h,0BFh,099h,03h,0Eh
    db 07h,08Bh,01Eh,044h,07h,0Eh,0E8h,0A7h,01h,0C6h,06h,044h,03h,02h,073h,03h
    db 0E9h,0D5h,00h,0A1h,099h,03h,08Bh,01Eh,09Bh,03h,08Bh,0F0h,083h,0E6h,0Fh,0D1h
    db 0EBh,0D1h,0D8h,0D1h,0EBh,0D1h,0D8h,0D1h,0EBh,0D1h,0D8h,0D1h,0EBh,0D1h,0D8h,08Bh
    db 0Eh,089h,03h,083h,0C1h,010h,03h,0C1h,08Eh,0C0h,026h,01h,0Ch,0FFh,0Eh,0ABh
    db 03h,0EBh,0AFh,08Bh,01Eh,044h,07h,0Eh,0E8h,069h,04h,0C7h,06h,044h,07h,00h
    db 00h,0A1h,0BBh,03h,03h,06h,089h,03h,05h,010h,00h,0A3h,09Fh,03h,0A1h,0B9h
    db 03h,0A3h,09Dh,03h,0A1h,0B3h,03h,03h,06h,089h,03h,05h,010h,00h,0A3h,0B3h
    db 03h,0B8h,021h,035h,0CDh,021h,089h,01Eh,03Dh,03h,08Ch,06h,03Fh,03h,0BAh,01Ah
    db 03h,0B8h,021h,025h,0CDh,021h,08Eh,01Eh,089h,03h,0BAh,080h,00h,0B4h,01Ah,0CDh
    db 021h,0Eh,01Fh,0FAh,089h,026h,0A1h,03h,08Ch,016h,0A3h,03h,08Eh,016h,0B3h,03h
    db 08Bh,026h,0B5h,03h,0FBh,0A1h,089h,03h,08Eh,0C0h,08Eh,0D8h,033h,0C0h,08Bh,0D8h
    db 08Bh,0C8h,08Bh,0D0h,08Bh,0F0h,08Bh,0F8h,08Bh,0E8h,02Eh,0FFh,02Eh,09Dh,03h,0Eh
    db 01Fh,0A2h,043h,03h,0FAh,08Bh,026h,0A1h,03h,08Eh,016h,0A3h,03h,0FBh,0B8h,021h
    db 025h,0C5h,016h,03Dh,03h,0CDh,021h,0Eh,01Fh,0C5h,016h,08Dh,03h,0B4h,01Ah,0CDh
    db 021h,0Eh,01Fh,0C6h,06h,044h,03h,00h,083h,03Eh,089h,03h,00h,074h,0Eh,08Eh
    db 06h,089h,03h,0B4h,049h,0CDh,021h,0C7h,06h,089h,03h,00h,00h,08Bh,01Eh,044h
    db 07h,0Eh,0E8h,0AFh,03h,0A1h,043h,03h,01Fh,0CBh,080h,0FCh,04Ch,075h,0Fh,02Eh
    db 083h,03Eh,041h,03h,00h,074h,0A8h,02Eh,0FFh,0Eh,041h,03h,0EBh,0Ah,080h,0FCh
    db 04Bh,075h,05h,02Eh,0FFh,06h,041h,03h,02Eh,0FFh,02Eh,03Dh,03h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 02Eh,089h,01Eh,0Ch,04h,08Bh,0C1h,0Bh,0C2h,074h,038h,01Eh,06h,01Fh,053h,051h
    db 052h,057h,0Bh,0D2h,075h,05h,083h,0F9h,0FFh,072h,03h,0B9h,0FFh,0FFh,08Bh,0D7h
    db 0B4h,03Fh,051h,0CDh,021h,05Dh,072h,01Eh,05Fh,05Ah,059h,05Bh,02Bh,0CDh,083h,0DAh
    db 00h,03h,0FDh,073h,07h,08Ch,0D8h,05h,00h,010h,08Eh,0D8h,08Bh,0C1h,0Bh,0C2h
    db 075h,0CCh,01Fh,033h,0C0h,0CBh,05Fh,05Ah,059h,05Bh,01Fh,0CBh,00h,00h,02Eh,089h
    db 01Eh,05Ch,04h,08Bh,0C1h,0Bh,0C2h,074h,03Ah,08Bh,0FEh,01Eh,06h,01Fh,053h,051h
    db 052h,057h,0Bh,0D2h,075h,05h,083h,0F9h,0FFh,072h,03h,0B9h,0FFh,0FFh,08Bh,0D7h
    db 0B4h,040h,051h,0CDh,021h,072h,01Fh,05Dh,05Fh,05Ah,059h,05Bh,02Bh,0CDh,083h,0DAh
    db 00h,03h,0FDh,073h,07h,08Ch,0D8h,05h,00h,010h,08Eh,0D8h,08Bh,0C1h,0Bh,0C2h
    db 075h,0CCh,01Fh,033h,0C0h,0CBh,05Fh,05Ah,059h,05Bh,01Fh,0CBh,00h,00h,02Eh,089h
    db 01Eh,0D3h,04h,02Eh,0A3h,0D5h,04h,02Eh,0F7h,06h,03Ah,07h,04h,00h,074h,0Ah
    db 02Eh,08Eh,06h,03Eh,07h,02Eh,08Bh,03Eh,03Ch,07h,02Eh,089h,03Eh,03Ch,07h,08Bh
    db 0C1h,0Bh,0C2h,074h,043h,033h,0FFh,01Eh,06h,01Fh,053h,051h,052h,057h,0Bh,0D2h
    db 075h,07h,02Eh,03Bh,0Eh,0D1h,04h,072h,05h,02Eh,08Bh,0Eh,0D1h,04h,08Bh,0D7h
    db 0B4h,03Fh,051h,0CDh,021h,072h,024h,02Eh,08Bh,01Eh,0D5h,04h,0B8h,00h,040h,0CDh
    db 021h,05Dh,072h,017h,03Bh,0C5h,075h,013h,05Fh,05Ah,059h,05Bh,02Bh,0CDh,083h,0DAh
    db 00h,08Bh,0C1h,0Bh,0C2h,075h,0C3h,01Fh,033h,0C0h,0CBh,05Fh,05Ah,059h,05Bh,01Fh
    db 0CBh,00h,00h,00h,00h,00h,00h

OpenResourceFile:
    push si
    push di
    mov word ptr cs:[0746h], dx
    mov word ptr cs:[0748h], ds
    push ds
    push es
    push cs
    pop ds
    test word ptr ds:[073Ah], 1
    je loc_15892
    jmp near ptr loc_15A21
loc_15892:
    mov word ptr ds:[0744h], 0
    mov ax, word ptr ds:[0740h]
    mov word ptr ds:[0742h], ax
    mov word ptr ds:[0744h], 0
loc_158A4:
    mov dx, word ptr ds:[0740h]
    mov ax, 03D02h
    int 021h
    jae loc_158B2
    jmp near ptr loc_159E0
loc_158B2:
    mov word ptr ds:[0744h], ax
    mov word ptr ds:[07AAh], 0
    mov word ptr ds:[07ACh], 0
    mov dx, 074Ah
    mov cx, 0Ch
    mov bx, word ptr ds:[0744h]
    mov ah, DOS_READ_FILE
    int 021h
    jae loc_158D4
    jmp near ptr loc_159E0
loc_158D4:
    cmp word ptr ds:[074Ah], 05A4Dh
    jne loc_15919
    mov ax, word ptr ds:[074Eh]
    dec ax
    add ax, ax
    mov dh, 0
    mov dl, ah
    mov ah, al
    mov al, dh
    add ax, word ptr ds:[074Ch]
    adc dx, 0
    mov word ptr ds:[07AAh], ax
    mov word ptr ds:[07ACh], dx
    mov cx, ax
    xchg cx, dx
    mov ax, 04200h
    int 021h
    jae loc_15906
    jmp near ptr loc_159E0
loc_15906:
    mov dx, 074Ah
    mov cx, 0Ch
    mov bx, word ptr ds:[0744h]
    mov ah, DOS_READ_FILE
    int 021h
    jae loc_15919
    jmp near ptr loc_159E0
loc_15919:
    mov si, 074Eh
    mov di, 0756h
    mov cx, 6
loc_15922:
    lodsb
    cmp al, byte ptr ds:[di]
    je loc_1592A
    jmp near ptr loc_159E0
loc_1592A:
    inc di
    loop loc_15922
    mov cx, word ptr ds:[074Ah]
    or cx, cx
    jne loc_15938
    jmp near ptr loc_159E0
loc_15938:
    cmp cx, 0320h
    jb loc_15941
    jmp near ptr loc_159E0
loc_15941:
    mov dx, 075Ch
    mov cx, word ptr ds:[0754h]
    mov bx, word ptr ds:[0744h]
    mov ah, DOS_READ_FILE
    int 021h
    jae loc_15955
    jmp near ptr loc_159E0
loc_15955:
    mov di, 075Ch
    mov cx, word ptr ds:[0754h]
    mov ax, word ptr ds:[074Ch]
loc_1595F:
    xor byte ptr ds:[di], al
    inc di
    add al, ah
    loop loc_1595F
    mov word ptr ds:[074Ch], ax
    mov si, 075Ch
    add si, 0Dh
    les di, dword ptr ds:[0746h]
    mov ah, 3
    push cs
    call loc_15AA1
loc_15979:
    cmp byte ptr es:[di], 020h
    jne loc_15982
    inc di
    jmp short loc_15979
loc_15982:
    cmp byte ptr ds:[si], 020h
    jne loc_1598A
    inc si
    jmp short loc_15982
loc_1598A:
    mov al, byte ptr es:[di]
    inc di
    mov ah, byte ptr ds:[si]
    inc si
    cmp al, 061h
    jb loc_1599B
    cmp al, 07Ah
    ja loc_1599B
    and al, 05Fh
loc_1599B:
    cmp al, ah
    jne loc_159D7
    or al, al
    jne loc_15979
    or ah, ah
    jne loc_159D7
    mov si, 075Ch
    mov dx, word ptr ds:[si + 5]
    mov cx, word ptr ds:[si + 7]
    add dx, word ptr ds:[07AAh]
    adc cx, word ptr ds:[07ACh]
    mov ax, 04200h
    mov bx, word ptr ds:[0744h]
    int 021h
    jb loc_159E0
    mov si, 075Ch
    mov cx, word ptr ds:[si + 9]
    mov dx, word ptr ds:[si + 0Bh]
loc_159CC:
    mov ax, word ptr ds:[0744h]
    mov bx, ax
    clc
    pop es
    pop ds
    pop di
    pop si
    retf
loc_159D7:
    dec word ptr ds:[074Ah]
    je loc_159E0
    jmp near ptr loc_15941
loc_159E0:
    mov bx, word ptr ds:[0744h]
    or bx, bx
    je loc_159EE
    mov ah, DOS_CLOSE_FILE
    int 021h
    jb loc_15A0C
loc_159EE:
    mov si, word ptr ds:[0740h]
loc_159F2:
    lodsb
    or al, al
    jne loc_159F2
    cmp byte ptr ds:[si], 0FFh
    jne loc_159FF
    mov si, 07AEh
loc_159FF:
    mov word ptr ds:[0740h], si
    cmp si, word ptr ds:[0742h]
    je loc_15A0C
    jmp near ptr loc_158A4
loc_15A0C:
    mov bx, word ptr ds:[0744h]
    or bx, bx
    je loc_15A18
    mov ah, DOS_CLOSE_FILE
    int 021h
loc_15A18:
    mov ax, 2
    stc
    pop es
    pop ds
    pop di
    pop si
    retf
loc_15A21:
    mov word ptr ds:[0744h], 0
    les di, dword ptr ds:[0746h]
    mov ah, 2
    push cs
    call loc_15AA1
    mov dx, di
    push ds
    push es
    pop ds
    mov ax, 03D02h
    int 021h
    pop ds
    jb loc_15A0C
    mov word ptr ds:[0744h], ax
    xor cx, cx
    mov dx, cx
    mov bx, ax
    mov ax, 04202h
    int 021h
    jb loc_15A0C
    push ax
    push dx
    xor cx, cx
    mov dx, cx
    mov bx, word ptr ds:[0744h]
    mov ax, 04200h
    int 021h
    pop dx
    pop cx
    jb loc_15A0C
    jmp near ptr loc_159CC
; UNKNOWN: not yet classified as code or data
    db 0Bh,0DBh,074h,04h,0B4h,03Eh,0CDh,021h,0CBh

loc_15A6D:
    mov ah, DOS_GET_PSP
    int 021h
    mov es, bx
    mov es, word ptr es:[02Ch]
    xor si, si
loc_15A7A:
    mov al, byte ptr es:[si]
    inc si
    or al, al
    jne loc_15A7A
    mov al, byte ptr es:[si]
    or al, al
    jne loc_15A7A
    add si, 3
    push ds
    push cs
    push es
    pop ds
    pop es
    cld
    mov di, 07AEh
loc_15A95:
    movsb
    cmp byte ptr ds:[si - 1], 0
    jne loc_15A95
    mov al, 0FFh
    stosb
    pop ds
    retf

loc_15AA1:
    test word ptr cs:[073Ah], 2
    je loc_15AD9
    test ah, 1
    je loc_15AC0
    mov bp, si
loc_15AB1:
    lodsb
    or al, al
    je loc_15ABE
    cmp al, 05Ch
    jne loc_15AB1
    mov bp, si
    jmp short loc_15AB1
loc_15ABE:
    mov si, bp
loc_15AC0:
    test ah, 2
    je loc_15AD9
    mov bp, di
loc_15AC7:
    mov al, byte ptr es:[di]
    inc di
    or al, al
    je loc_15AD7
    cmp al, 05Ch
    jne loc_15AC7
    mov bp, di
    jmp short loc_15AC7
loc_15AD7:
    mov di, bp
loc_15AD9:
    retf
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,0AEh,07h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,053h,048h,041h,044h
    db 04Fh,057h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
SEG153A ends
end