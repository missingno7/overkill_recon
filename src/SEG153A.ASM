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
; Further resource-library routines (far entries ending in RETF). The game only calls
; 153A:0000 (loc_153A0) and OpenResourceFile; no caller of these was found.
loc_153E0:
    push di
    push es
    push cs
    call OpenResourceFile
    pop es
    pop di
    jb loc_153FC
    push bx
    push cx
    push dx
    push cs
    call loc_15760
    pop dx
    pop cx
    pop bx
    pushf
    push ax
    push cs
    call loc_15A64
    pop ax
    popf
loc_153FC:
    retf
loc_153FD:
    push ds
    push cs
    pop es
    mov si, dx
    mov di, 345h
    cld
loc_15406:
    movsb
    cmp byte ptr ds:[si - 1h], 0
    je loc_15413
    cmp byte ptr ds:[si - 1h], 20h
    jne loc_15406
loc_15413:
    mov byte ptr es:[di - 1h], 0
    dec si
    mov cs:[385h], si
    mov cs:[387h], ds
    push cs
    pop ds
    mov word ptr ds:[389h], 0
    mov byte ptr ds:[344h], 1
    mov dx, 345h
    push cs
    call OpenResourceFile
    jae loc_1543C
    jmp near ptr loc_15698
loc_1543C:
    mov cx, 1Bh
    xor dx, dx
    mov di, 3A5h
    push cs
    pop es
    push cs
    call loc_15760
    mov byte ptr ds:[344h], 2
    jae loc_15454
    jmp near ptr loc_15698
loc_15454:
    mov di, 3A5h
    cmp word ptr ds:[3A5h], 5A4Dh
    mov byte ptr ds:[344h], 4
    je loc_15467
    jmp near ptr loc_15698
loc_15467:
    mov bx, ds:[3ADh]
    xor cx, cx
    add bx, bx
    adc cx, 0
    add bx, bx
    adc cx, 0
    add bx, bx
    adc cx, 0
    add bx, bx
    adc cx, 0
    mov ds:[391h], bx
    mov ds:[393h], cx
    mov ax, ds:[3A9h]
    dec ax
    add ax, ax
    mov dh, 0
    mov dl, ah
    mov ah, al
    mov al, dh
    add ax, ds:[3A7h]
    adc dx, 0
    sub ax, bx
    sbb dx, cx
    mov ds:[395h], ax
    mov ds:[397h], dx
    shr dx, 1
    rcr ax, 1
    shr dx, 1
    rcr ax, 1
    shr dx, 1
    rcr ax, 1
    shr dx, 1
    rcr ax, 1
    add ax, 11h
    add ds:[3AFh], ax
    mov word ptr ds:[389h], 0
    mov bx, 0FFFFh
    mov ah, 48h
    int 21h
    mov ah, 48h
    int 21h
    mov byte ptr ds:[344h], 3
    jae loc_154DB
    jmp near ptr loc_15698
loc_154DB:
    mov ds:[389h], ax
    mov ah, 2Fh
    int 21h
    mov ds:[38Dh], bx
    mov ds:[38Fh], es
    mov ah, 51h
    int 21h
    mov ds:[38Bh], bx
    mov es, ds:[389h]
    mov ds, ds:[38Bh]
    xor si, si
    mov di, si
    mov cx, 100h
    cld
    rep movsb
    push cs
    pop ds
    mov es, ds:[389h]
    mov di, 81h
    lds si, ds:[385h]
loc_15511:
    movsb
    cmp byte ptr ds:[si - 1h], 0
    jne loc_15511
    dec si
    mov byte ptr es:[di - 1h], 0Dh
    mov byte ptr es:[di], 0
    push cs
    pop ds
    sub si, ds:[385h]
    mov ax, si
    mov es:[80h], al
    mov cx, ds:[391h]
    mov dx, ds:[393h]
    sub cx, 1Bh
    sbb dx, 0
    mov bx, ds:[744h]
    xchg cx, dx
    mov ax, 4201h
    int 21h
    mov byte ptr ds:[344h], 2
    jae loc_15551
    jmp near ptr loc_15698
loc_15551:
    mov cx, ds:[395h]
    mov dx, ds:[397h]
    mov ax, ds:[389h]
    add ax, 10h
    mov es, ax
    xor di, di
    mov bx, ds:[744h]
    push cs
    call loc_15760
    mov byte ptr ds:[344h], 2
    jae loc_15575
    jmp near ptr loc_15698
loc_15575:
    mov si, 75Ch
    mov cx, ds:[si + 5]
    mov dx, ds:[si + 7]
    add cx, ds:[7AAh]
    adc dx, ds:[7ACh]
    add cx, ds:[3BDh]
    adc dx, 0
    xchg cx, dx
    mov bx, ds:[744h]
    mov ax, 4200h
    int 21h
    mov byte ptr ds:[344h], 2
    jae loc_155A2
    jmp near ptr loc_15698
loc_155A2:
    cmp word ptr ds:[3ABh], 0
    je loc_155F3
    mov cx, 4
    mov di, 399h
    push cs
    pop es
    mov bx, ds:[744h]
    push cs
    call loc_15760
    mov byte ptr ds:[344h], 2
    jae loc_155C3
    jmp near ptr loc_15698
loc_155C3:
    mov ax, ds:[399h]
    mov bx, ds:[39Bh]
    mov si, ax
    and si, 0Fh
    shr bx, 1
    rcr ax, 1
    shr bx, 1
    rcr ax, 1
    shr bx, 1
    rcr ax, 1
    shr bx, 1
    rcr ax, 1
    mov cx, ds:[389h]
    add cx, 10h
    add ax, cx
    mov es, ax
    add es:[si], cx
    dec word ptr ds:[3ABh]
    jmp short loc_155A2
loc_155F3:
    mov bx, ds:[744h]
    push cs
    call loc_15A64
    mov word ptr ds:[744h], 0
    mov ax, ds:[3BBh]
    add ax, ds:[389h]
    add ax, 10h
    mov ds:[39Fh], ax
    mov ax, ds:[3B9h]
    mov ds:[39Dh], ax
    mov ax, ds:[3B3h]
    add ax, ds:[389h]
    add ax, 10h
    mov ds:[3B3h], ax
    mov ax, 3521h
    int 21h
    mov ds:[33Dh], bx
    mov ds:[33Fh], es
    mov dx, 31Ah
    mov ax, 2521h
    int 21h
    mov ds, ds:[389h]
    mov dx, 80h
    mov ah, 1Ah
    int 21h
    push cs
    pop ds
    cli
    mov ds:[3A1h], sp
    mov ds:[3A3h], ss
    mov ss, ds:[3B3h]
    mov sp, ds:[3B5h]
    sti
    mov ax, ds:[389h]
    mov es, ax
    mov ds, ax
    xor ax, ax
    mov bx, ax
    mov cx, ax
    mov dx, ax
    mov si, ax
    mov di, ax
    mov bp, ax
    jmp dword ptr cs:[39Dh]
loc_1566F:
    push cs
    pop ds
    mov ds:[343h], al
    cli
    mov sp, ds:[3A1h]
    mov ss, ds:[3A3h]
    sti
    mov ax, 2521h
    lds dx, ds:[33Dh]
    int 21h
    push cs
    pop ds
    lds dx, ds:[38Dh]
    mov ah, 1Ah
    int 21h
    push cs
    pop ds
    mov byte ptr ds:[344h], 0
loc_15698:
    cmp word ptr ds:[389h], 0
    je loc_156AD
    mov es, ds:[389h]
    mov ah, 49h
    int 21h
    mov word ptr ds:[389h], 0
loc_156AD:
    mov bx, ds:[744h]
    push cs
    call loc_15A64
    mov ax, ds:[343h]
    pop ds
    retf
loc_156BA:
    cmp ah, 4Ch
    jne loc_156CE
    cmp word ptr cs:[341h], 0
    je loc_1566F
    dec word ptr cs:[341h]
    jmp short loc_156D8
loc_156CE:
    cmp ah, 4Bh
    jne loc_156D8
    inc word ptr cs:[341h]
loc_156D8:
    jmp dword ptr cs:[33Dh]
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h
loc_15760:
    mov cs:[40Ch], bx
    mov ax, cx
    or ax, dx
    je loc_157A3
    push ds
    push es
    pop ds
loc_1576E:
    push bx
    push cx
    push dx
    push di
    or dx, dx
    jne loc_1577B
    cmp cx, -1
    jb loc_1577E
loc_1577B:
    mov cx, 0FFFFh
loc_1577E:
    mov dx, di
    mov ah, 3Fh
    push cx
    int 21h
    pop bp
    jb loc_157A6
    pop di
    pop dx
    pop cx
    pop bx
    sub cx, bp
    sbb dx, 0
    add di, bp
    jae loc_1579C
    mov ax, ds
    add ax, 1000h
    mov ds, ax
loc_1579C:
    mov ax, cx
    or ax, dx
    jne loc_1576E
    pop ds
loc_157A3:
    xor ax, ax
    retf
loc_157A6:
    pop di
    pop dx
    pop cx
    pop bx
    pop ds
    retf
loc_157AC:
    add ds:[bx + si], al
    mov cs:[45Ch], bx
    mov ax, cx
    or ax, dx
    je loc_157F3
    mov di, si
    push ds
    push es
    pop ds
loc_157BE:
    push bx
    push cx
    push dx
    push di
    or dx, dx
    jne loc_157CB
    cmp cx, -1
    jb loc_157CE
loc_157CB:
    mov cx, 0FFFFh
loc_157CE:
    mov dx, di
    mov ah, 40h
    push cx
    int 21h
    jb loc_157F6
    pop bp
    pop di
    pop dx
    pop cx
    pop bx
    sub cx, bp
    sbb dx, 0
    add di, bp
    jae loc_157EC
    mov ax, ds
    add ax, 1000h
    mov ds, ax
loc_157EC:
    mov ax, cx
    or ax, dx
    jne loc_157BE
    pop ds
loc_157F3:
    xor ax, ax
    retf
loc_157F6:
    pop di
    pop dx
    pop cx
    pop bx
    pop ds
    retf
loc_157FC:
    add ds:[bx + si], al
    mov cs:[4D3h], bx
    mov cs:[4D5h], ax
    test word ptr cs:[73Ah], 4
    je loc_1581A
    mov es, cs:[73Eh]
    mov di, cs:[73Ch]
loc_1581A:
    mov cs:[73Ch], di
    mov ax, cx
    or ax, dx
    je loc_15868
    xor di, di
    push ds
    push es
    pop ds
loc_1582A:
    push bx
    push cx
    push dx
    push di
    or dx, dx
    jne loc_15839
    cmp cx, cs:[4D1h]
    jb loc_1583E
loc_15839:
    mov cx, cs:[4D1h]
loc_1583E:
    mov dx, di
    mov ah, 3Fh
    push cx
    int 21h
    jb loc_1586B
    mov bx, cs:[4D5h]
    mov ax, 4000h
    int 21h
    pop bp
    jb loc_1586B
    cmp ax, bp
    jne loc_1586B
    pop di
    pop dx
    pop cx
    pop bx
    sub cx, bp
    sbb dx, 0
    mov ax, cx
    or ax, dx
    jne loc_1582A
    pop ds
loc_15868:
    xor ax, ax
    retf
loc_1586B:
    pop di
    pop dx
    pop cx
    pop bx
    pop ds
    retf
loc_15871:
    add ds:[bx + si], al
    add ds:[bx + si], al
    add ds:[bx + si], al

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
loc_15A64:
    or bx, bx
    je loc_15A6C
    mov ah, 3Eh
    int 21h
loc_15A6C:
    retf

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