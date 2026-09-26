; Modern physical chunk, NOT an inferred original object boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public BlitPackedStride104Ega
public BlitPackedStride160Ega
public BlitPackedToScreenEga
public ClearScreen104x200Ega
public ClearTandy104x200
public CopyPackedRowsStride104
public CopyPackedRowsStride160
public CopyPackedRowsToTandyBanks
public CopyWorkspace104x192ToTandy
public CopyWorkspaceToScreenEga
public DrawOffsetFromRow9BC8Ega
public DrawOffsetFromRow9D58Ega
public DrawOffsetFromRow9EE8Ega
public TandyOffsetFromRow9BC8
public TandyOffsetFromRow9D58
public TandyOffsetFromRow9EE8
public loc_02580
public loc_025B2
public loc_025FE
public loc_027D9
public loc_02B84
public loc_02E2D
public loc_030D2
public loc_03153
public loc_033AF
public loc_036A2
public loc_03824
extrn MainDataSegment:near
extrn ScreenSegment:near
extrn VideoAdapter:near
extrn WorkspaceSegment:near
extrn loc_044AA:near
extrn loc_044D7:near
extrn loc_0511F:near
extrn loc_05A36:near
; Modern record/state symbols.
; UNKNOWN: not yet classified as code or data
    db 0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h
    db 09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h,055h,01Ch,026h,09h
    db 045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h,055h,050h,083h,0C7h
    db 068h,083h,0C6h,0Ah,0E2h,0C5h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,0B2h,0FFh
    db 0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h
    db 01Ah,026h,08h,055h,01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h
    db 04Eh,026h,08h,055h,050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0BFh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,08Bh,04h,0B2h,0FFh,0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h
    db 055h,01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h
    db 055h,050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0B9h,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h
    db 01h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h,045h
    db 035h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah,0E2h
    db 0BFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h,0D0h
    db 0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h
    db 045h,01h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h
    db 045h,035h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah
    db 0E2h,0C5h,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h
    db 0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h,08h,055h
    db 01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h,045h,035h,026h,08h,055h
    db 04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0CBh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,026h,08Ah,05h,022h,04h,0Ah,044h,01h,026h,088h,05h,083h,0C7h
    db 01Ah,026h,08Ah,05h,022h,04h,0Ah,044h,02h,026h,088h,05h,083h,0C7h,01Ah,026h
    db 08Ah,05h,022h,04h,0Ah,044h,03h,026h,088h,05h,083h,0C7h,01Ah,026h,08Ah,05h
    db 022h,04h,0Ah,044h,04h,026h,088h,05h,083h,0C7h,01Ah,083h,0C6h,05h,0E2h,0C3h
    db 02Eh,08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,026h,021h
    db 05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,0ACh,032h,0E4h
    db 0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,026h,09h
    db 045h,01Ah,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h
    db 0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h,0E2h,0B9h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh
    db 026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,0ACh
    db 032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh,032h,0E4h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h,0E2h,0A4h,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h
    db 0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,026h,021h,05h,026h,021h,045h,01Ah,026h,021h
    db 045h,034h,026h,021h,045h,04Eh,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh,032h,0E4h,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h
    db 0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h
    db 04Eh,083h,0C7h,068h,0E2h,08Fh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h
    db 0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h
    db 0D8h,0D0h,0DCh,026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h
    db 045h,04Eh,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh
    db 032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h
    db 0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h
    db 0E2h,02h,0EBh,03h,0E9h,075h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Ah,024h,0B0h
    db 0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h
    db 026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,08Ah
    db 064h,01h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h
    db 026h,09h,05h,08Ah,064h,02h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h
    db 0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah,064h,03h,032h,0C0h,0D0h,0E4h,0D0h
    db 0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah,064h,04h
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h
    db 045h,04Eh,083h,0C7h,068h,083h,0C6h,05h,0E2h,083h,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 08Ah,024h,0B0h,0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h,026h,021h
    db 05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,08Ah,064h,01h
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,05h,08Ah,064h,02h
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah,064h
    db 03h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah
    db 064h,04h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,04Eh
    db 083h,0C7h,068h,083h,0C6h,05h,0E2h,098h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Ah,024h
    db 0B0h,0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,026h,021h,05h,026h,021h,045h,01Ah,026h,021h
    db 045h,034h,026h,021h,045h,04Eh,08Ah,064h,01h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h
    db 09h,05h,08Ah,064h,02h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah
    db 064h,03h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah,064h,04h,032h
    db 0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,04Eh,083h,0C7h,068h,083h,0C6h,05h,0E2h
    db 0ADh,02Eh,08Eh,01Eh,096h,095h,0C3h

BlitPackedToScreenEga:
    lodsw
    mov cx, ax
    lodsw
    mov bp, ax
    mov es, word ptr cs:[ScreenSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
loc_024E9:
    push cx
    mov al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    pop cx
    loop loc_024E9
    mov al, 0Fh
    out dx, al
    ret

BlitPackedStride104Ega:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    mov bp, ax
loc_02523:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    pop cx
    loop loc_02523
    ret

BlitPackedStride160Ega:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    mov bp, ax
loc_02557:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    pop cx
    loop loc_02557
    ret
loc_02580:
    mov bx, word ptr ss:[bp + 2]
    cmp bx, 0E0h
    jae loc_025B2
    shl bx, 1
    mov bx, word ptr ds:[bx - 06638h]
    cmp bx, -1
    je loc_025B2
    mov ax, word ptr ss:[bp + 4]
    mov cx, ax
    and cx, 7
    mov word ptr ss:[bp + 012h], cx
    shr ax, 1
    shr ax, 1
    shr ax, 1
    add ax, bx
    cmp word ptr ss:[bp + 024h], 0
    jne loc_025AE
    ret
loc_025AE:
    dec word ptr ss:[bp + 024h]
    ret
loc_025B2:
    mov ax, 0FFFFh
    ret

DrawOffsetFromRow9EE8Ega:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 06118h]
    xor ah, ah
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromRow9BC8Ega:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 06438h]
    xor ah, ah
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromRow9D58Ega:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 062A8h]
    xor ah, ah
    add ax, bx
    mov di, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,0D1h,0E8h
    db 0D1h,0E8h,03h,0C3h,0C3h

loc_025FE:
    cmp al, 010h
    jne loc_02605
    jmp near ptr loc_0272F
loc_02605:
    cmp al, 011h
    jne loc_0260C
    jmp near ptr loc_02718
loc_0260C:
    cmp al, 0Eh
    jne loc_02613
    jmp near ptr loc_0270C
loc_02613:
    xor ah, ah
    shl ax, 1
    shl ax, 1
    shl ax, 1
    add ax, 01816h
    mov si, ax
    mov es, word ptr cs:[ScreenSegment]
    xor ax, ax
    mov al, byte ptr ds:[0215Eh]
    add ax, word ptr ds:[02160h]
    mov di, ax
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    xor al, al
    mov byte ptr es:[di], al
    mov byte ptr es:[di + 028h], al
    mov byte ptr es:[di + 050h], al
    mov byte ptr es:[di + 078h], al
    mov byte ptr es:[di + 0A0h], al
    mov byte ptr es:[di + 0C8h], al
    mov byte ptr es:[di + 0F0h], al
    mov byte ptr es:[di + 0118h], al
    mov al, byte ptr ds:[0215Ch]
    out dx, al
    mov word ptr ds:[01914h], 4
    mov bl, byte ptr ds:[0215Ch]
    mov bh, 1
    mov cx, 4
loc_02672:
    mov al, bh
    out dx, al
    shl bh, 1
    push dx
    mov dx, 03CEh
    mov ax, word ptr ds:[01914h]
    out dx, ax
    inc byte ptr ds:[01915h]
    pop dx
    shr bl, 1
    jae loc_026B8
    lodsb
    or byte ptr es:[di], al
    lodsb
    or byte ptr es:[di + 028h], al
    lodsb
    or byte ptr es:[di + 050h], al
    lodsb
    or byte ptr es:[di + 078h], al
    lodsb
    or byte ptr es:[di + 0A0h], al
    lodsb
    or byte ptr es:[di + 0C8h], al
    lodsb
    or byte ptr es:[di + 0F0h], al
    lodsb
    or byte ptr es:[di + 0118h], al
    sub si, 8
    jmp short loc_026F6
loc_026B8:
    lodsb
    not al
    and byte ptr es:[di], al
    lodsb
    not al
    and byte ptr es:[di + 028h], al
    lodsb
    not al
    and byte ptr es:[di + 050h], al
    lodsb
    not al
    and byte ptr es:[di + 078h], al
    lodsb
    not al
    and byte ptr es:[di + 0A0h], al
    lodsb
    not al
    and byte ptr es:[di + 0C8h], al
    lodsb
    not al
    and byte ptr es:[di + 0F0h], al
    lodsb
    not al
    and byte ptr es:[di + 0118h], al
    sub si, 8
loc_026F6:
    loop loc_026FA
    jmp short loc_026FD
loc_026FA:
    jmp near ptr loc_02672
loc_026FD:
    mov al, 0Fh
    out dx, al
    add byte ptr ds:[0215Eh], 1
    cmp byte ptr ds:[0215Eh], 028h
    jb loc_02717
loc_0270C:
    mov byte ptr ds:[0215Eh], 0
    add word ptr ds:[02160h], 0140h
loc_02717:
    ret
loc_02718:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 0140h
    xor ah, ah
    mul cx
    mov word ptr ds:[02160h], ax
    mov al, byte ptr ss:[bp + 2]
    mov byte ptr ds:[0215Eh], al
    add bp, 2
    ret
loc_0272F:
    inc bp
    mov al, byte ptr ss:[bp]
    mov byte ptr ds:[0215Ch], al
    ret

    mov es, word ptr cs:[ScreenSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    xor di, di
    mov ax, di
    mov cx, 01F40h
    rep stosw
    ret

CopyWorkspaceToScreenEga:
    mov si, word ptr ds:[0234Ch]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 0Dh
    mov di, 0A0h
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov bp, 0C0h
loc_0276E:
    mov al, 1
    out dx, al
    mov cx, bx
    rep movsw
    sub di, 01Ah
    shl al, 1
    out dx, al
    mov cx, bx
    rep movsw
    sub di, 01Ah
    shl al, 1
    out dx, al
    mov cx, bx
    rep movsw
    sub di, 01Ah
    shl al, 1
    out dx, al
    mov cx, bx
    rep movsw
    add di, 0Eh
    dec bp
    jne loc_0276E
    mov al, 0Fh
    out dx, al
    mov ds, word ptr cs:[MainDataSegment]
    ret

ClearScreen104x200Ega:
    call loc_027B7
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_027B6
    call loc_0511F
    call loc_027B7
    call loc_0511F
loc_027B6:
    ret

loc_027B7:
    mov es, word ptr cs:[ScreenSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    xor di, di
    mov bp, 0C8h
loc_027CB:
    mov cx, 0Dh
    xor ax, ax
    rep stosw
    add di, 0Eh
    dec bp
    jne loc_027CB
    ret

loc_027D9:
    inc word ptr cs:[05BA8h]
    call loc_044D7
    jne loc_027E6
    jmp near ptr loc_044AA
loc_027E6:
    mov cx, word ptr cs:[05B9Eh]
loc_027EB:
    push cx
    cmp word ptr cs:[0BD6h], 0
    je loc_02802
    push si
    mov cx, word ptr cs:[05B9Ch]
loc_027FA:
    push cx
    call loc_02932
    pop cx
    loop loc_027FA
    pop si
loc_02802:
    mov word ptr cs:[05BA6h], di
    mov di, 05AF4h
    mov bp, 4
loc_0280D:
    mov cx, word ptr cs:[05B9Ch]
loc_02812:
    lodsb
    mov byte ptr cs:[di], al
    inc di
    loop loc_02812
    sub di, word ptr cs:[05B9Ch]
    add di, 028h
    dec bp
    jne loc_0280D
    mov di, 05AF4h
    mov cx, word ptr cs:[05B9Ch]
loc_0282C:
    push cx
    mov al, byte ptr cs:[di]
    mov ah, byte ptr cs:[di + 028h]
    mov dl, byte ptr cs:[di + 050h]
    mov dh, byte ptr cs:[di + 078h]
    mov cx, 8
loc_0283F:
    rol dh, 1
    rcl bl, 1
    rol dl, 1
    rcl bl, 1
    rol ah, 1
    rcl bl, 1
    rol al, 1
    rcl bl, 1
    and bl, 0Fh
    cmp word ptr cs:[0BD6h], 0
    je loc_02863
    cmp bl, byte ptr cs:[0]
    jne loc_02863
    xor bl, bl
loc_02863:
    cmp byte ptr cs:[0C5B0h], 1
    jne loc_0289A
    mov bp, word ptr cs:[05BAAh]
    cmp bp, -1
    je loc_0289A
    add bp, word ptr cs:[05BA8h]
    cmp byte ptr ss:[bp], 1
    je loc_0288A
    cmp byte ptr ss:[bp], 2
    je loc_02888
    jmp short loc_0289A
loc_02888:
    jmp short loc_0289A
loc_0288A:
    cmp bl, 6
    je loc_02898
    cmp bl, 0Ch
    jne loc_0289A
    mov bl, 6
    jmp short loc_0289A
loc_02898:
    mov bl, 0Ch
loc_0289A:
    shr bl, 1
    rcl byte ptr cs:[05BA2h],1
    shr bl, 1
    rcl byte ptr cs:[05BA3h],1
    shr bl, 1
    rcl byte ptr cs:[05BA4h],1
    shr bl, 1
    rcl byte ptr cs:[05BA5h],1
    loop loc_0283F
    mov al, byte ptr cs:[05BA2h]
    mov byte ptr cs:[di], al
    mov al, byte ptr cs:[05BA3h]
    mov byte ptr cs:[di + 028h], al
    mov al, byte ptr cs:[05BA4h]
    mov byte ptr cs:[di + 050h], al
    mov al, byte ptr cs:[05BA5h]
    mov byte ptr cs:[di + 078h], al
    inc di
    pop cx
    loop loc_028DD
    jmp short loc_028E0
loc_028DD:
    jmp near ptr loc_0282C
loc_028E0:
    mov di, 05AF4h
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, 05B1Ch
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, 05B44h
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, 05B6Ch
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, word ptr cs:[05BA6h]
    pop cx
    loop loc_02916
    jmp short loc_02919
loc_02916:
    jmp near ptr loc_027EB
loc_02919:
    jmp near ptr loc_027D9

loc_0291C:
    push cx
    mov al, byte ptr cs:[di]
    inc di
    push di
    mov di, word ptr cs:[05BA6h]
    stosb
    mov word ptr cs:[05BA6h], di
    pop di
    pop cx
    loop loc_0291C
    ret

loc_02932:
    mov byte ptr cs:[05BA0h], 0
    mov bx, word ptr cs:[05B9Ch]
    mov al, byte ptr ds:[si]
    mov ah, byte ptr ds:[bx + si]
    shl bx, 1
    mov dl, byte ptr ds:[bx + si]
    add bx, word ptr cs:[05B9Ch]
    mov dh, byte ptr ds:[bx + si]
    mov cx, 8
loc_0294F:
    push cx
    rcl dh, 1
    rcl byte ptr cs:[05BA1h],1
    rcl dl, 1
    rcl byte ptr cs:[05BA1h],1
    rcl ah, 1
    rcl byte ptr cs:[05BA1h],1
    rcl al, 1
    rcl byte ptr cs:[05BA1h],1
    and byte ptr cs:[05BA1h], 0Fh
    mov cl, byte ptr cs:[0]
    cmp byte ptr cs:[05BA1h], cl
    jne loc_02981
    stc
    jmp short loc_02982
loc_02981:
    clc
loc_02982:
    rcl byte ptr cs:[05BA0h],1
    pop cx
    loop loc_0294F
    mov al, byte ptr cs:[05BA0h]
    stosb
    inc si
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,0FFh,0FFh,074h,03h,0E8h,010h,00h,08Bh,07Eh,010h,08Bh,076h,0Eh,081h,0C6h
    db 040h,01h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,015h,00h,0B9h,010h,00h,0A5h,0A5h
    db 0A4h,03h,0FBh,0A5h,0A5h,0A4h,03h,0FBh,0A5h,0A5h,0A4h,03h,0FBh,0A5h,0A5h,0A4h
    db 03h,0FBh,0E2h,0EAh,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,017h,00h,0B9h,010h
    db 00h,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h
    db 0FBh,0E2h,0EEh,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,018h,00h,0A5h,03h,0FBh
    db 0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h
    db 03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h
    db 0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh
    db 0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h
    db 03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h
    db 0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0C3h,0E8h,0E4h
    db 02Fh,089h,046h,0Ch,03Dh,0FFh,0FFh,074h,0Fh,03h,06h,04Ch,023h,089h,046h,0Ch
    db 08Bh,0F0h,08Bh,07Eh,0Eh,0E8h,024h,00h,083h,046h,02h,010h,0E8h,0C6h,02Fh,089h
    db 046h,010h,083h,06Eh,02h,010h,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h
    db 089h,046h,010h,08Bh,0F0h,08Bh,07Eh,0Eh,081h,0C7h,040h,01h,02Eh,08Eh,06h,096h
    db 095h,02Eh,08Eh,01Eh,098h,095h,0BBh,015h,00h,0B9h,010h,00h,0A4h,0A5h,0A5h,03h
    db 0F3h,0A4h,0A5h,0A5h,03h,0F3h,0A4h,0A5h,0A5h,03h,0F3h,0A4h,0A5h,0A5h,03h,0F3h
    db 0E2h,0EAh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,07Ah,02Fh,089h,046h,0Ch,03Dh,0FFh
    db 0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh
    db 02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0BBh,017h,00h,0B9h,010h,00h
    db 0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h
    db 0E2h,0EEh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,03Ah,02Fh,089h,046h,0Ch,03Dh,0FFh
    db 0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh
    db 02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0BBh,018h,00h,0A5h,03h,0F3h
    db 0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h
    db 03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h
    db 0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h
    db 0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h
    db 03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h
    db 0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h

loc_02B84:
    mov bx, dx
    mov cx, 0Dh
    mov ax, word ptr cs:[0959Ah]
    cmp word ptr ds:[02350h], 0E5Fh
    jb loc_02B99
    mov ax, word ptr cs:[0959Ch]
loc_02B99:
    mov ds, ax
loc_02B9B:
    push cx
    push bx
    mov es, word ptr cs:[09592h]
    mov bl, byte ptr es:[bx]
    dec bl
    xor bh, bh
    shl bx, 1
    add bx, 08D92h
    mov si, word ptr cs:[bx]
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    sub di, 067Eh
    pop bx
    add bx, 1
    pop cx
    loop loc_02D24
    jmp short loc_02D27
loc_02D24:
    jmp near ptr loc_02B9B
loc_02D27:
    mov ds, word ptr cs:[MainDataSegment]
    ret

    mov word ptr cs:[05903h], 0
    mov di, word ptr cs:[058F9h]
    mov si, word ptr cs:[058FBh]
    mov cx, word ptr cs:[058FDh]
    mov bp, word ptr cs:[058FFh]
    cmp word ptr cs:[05905h], 0
    je loc_02D5C
    mov ax, bp
    shl ax, 1
    shl ax, 1
    dec cx
    mul cx
    inc cx
    add si, ax
loc_02D5C:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    push cx
    mov cx, word ptr cs:[058FDh]
    sub cx, word ptr cs:[05901h]
    or cx, cx
    js loc_02D8C
    shr cx, 1
    jcxz loc_02D8C
    dec cx
    jcxz loc_02D81
    mov al, 0Fh
    out dx, al
loc_02D7C:
    add di, 028h
    loop loc_02D7C
loc_02D81:
    xor al, al
    mov cx, bp
    rep stosb
    sub di, bp
    add di, 028h
loc_02D8C:
    pop cx
loc_02D8D:
    mov ax, word ptr cs:[05901h]
    cmp ax, word ptr cs:[058FDh]
    je loc_02DCB
    add word ptr cs:[05903h], ax
    mov ax, word ptr cs:[058FDh]
    cmp ax, word ptr cs:[05903h]
    ja loc_02DC6
    cmp word ptr cs:[05905h], 0
    je loc_02DBA
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    jmp short loc_02DC2
loc_02DBA:
    add si, bp
    add si, bp
    add si, bp
    add si, bp
loc_02DC2:
    loop loc_02D8D
    jmp short loc_02E23
loc_02DC6:
    sub word ptr cs:[05903h], ax
loc_02DCB:
    push cx
    mov al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    cmp word ptr cs:[05907h], 1
    je loc_02DF8
    rep movsb
    jmp short loc_02DFE
loc_02DF8:
    xor al, al
    rep stosb
    add si, bp
loc_02DFE:
    sub di, bp
    add di, 028h
    cmp word ptr cs:[05905h], 0
    je loc_02E1B
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
loc_02E1B:
    pop cx
    loop loc_02E20
    jmp short loc_02E23
loc_02E20:
    jmp near ptr loc_02D8D
loc_02E23:
    mov al, 0Fh
    out dx, al
    xor al, al
    mov cx, bp
    rep stosb
    ret

loc_02E2D:
    mov ds, word ptr cs:[WorkspaceSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
loc_02E39:
    mov al, 1
    out dx, al
    mov cx, 014h
    rep movsw
    sub di, 028h
    mov al, 2
    out dx, al
    mov cx, 014h
    rep movsw
    sub di, 028h
    mov al, 4
    out dx, al
    mov cx, 014h
    rep movsw
    sub di, 028h
    mov al, 8
    out dx, al
    mov cx, 014h
    rep movsw
    dec bp
    jne loc_02E39
    mov al, 0Fh
    out dx, al
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02E6E:
    mov bx, 058h
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    loop loc_02E6E
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02ECB:
    mov bx, 058h
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    add di, bx
    loop loc_02ECB
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02F40:
    mov bx, 060h
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    add di, bx
    loop loc_02F40
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02F81:
    mov bx, 060h
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    loop loc_02F81
    mov ds, word ptr cs:[MainDataSegment]
    ret
    mov bx, 064h
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Copy a packed image (DS:SI header: row count, width in 8-pixel units) to Tandy video
; memory at ES=CS:95A4, ES:DI. Tandy rows interleave across four 2000h banks: each row
; adds 2000h, and after the fourth bank adding 80A0h wraps to the first bank one 160-byte
; line further. No clipping; DF=0.
CopyPackedRowsToTandyBanks:
    lodsw
    mov cx, ax
    lodsw
    mov es, word ptr cs:[ScreenSegment]
    shl ax, 1
    shl ax, 1
    mov bp, ax
loc_0307E:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 08000h
    je loc_03093
    add di, 080A0h
loc_03093:
    pop cx
    loop loc_0307E
    ret

; Copy a packed image (DS:SI: row count, width units) into the 104-byte-wide workspace
; at ES=CS:9598, DI advancing 104 bytes per row. DF=0; no clipping.
CopyPackedRowsStride104:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    shl ax, 1
    mov bp, ax
loc_030A6:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 068h
    pop cx
    loop loc_030A6
    ret

; As CopyPackedRowsStride104, but into a 160-byte-wide buffer.
CopyPackedRowsStride160:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    shl ax, 1
    mov bp, ax
loc_030C3:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 0A0h
    pop cx
    loop loc_030C3
    ret
loc_030D2:
    mov bx, word ptr ss:[bp + REC_Y]
    cmp bx, 0E0h
    jb loc_030DE
    jmp near ptr loc_025B2
loc_030DE:
    shl bx, 1
    mov bx, word ptr ds:[bx - 06638h]
    cmp bx, -1
    jne loc_030EC
    jmp near ptr loc_025B2
loc_030EC:
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ss:[bp + 012h], 0
    shr ax, 1
    add ax, bx
    cmp word ptr ss:[bp + 024h], 0
    jne loc_030FF
    ret
loc_030FF:
    dec word ptr ss:[bp + 024h]
    ret

; AX = DI = row offset table DS:9EE8[AH] + 4*AL (AL in 8-pixel units); BX = the table
; entry. No bounds check; the initializer fills 200 rows.
TandyOffsetFromRow9EE8:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 06118h]
    xor ah, ah
    shl ax, 1
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

; As TandyOffsetFromRow9EE8 with the row table at DS:9BC8.
TandyOffsetFromRow9BC8:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 06438h]
    xor ah, ah
    shl ax, 1
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

; As TandyOffsetFromRow9EE8 with the row table at DS:9D58.
TandyOffsetFromRow9D58:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 062A8h]
    xor ah, ah
    shl ax, 1
    shl ax, 1
    add ax, bx
    mov di, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,03h,0C3h
    db 0C3h

loc_03153:
    cmp al, 010h
    jne loc_0315A
    jmp near ptr loc_0333D
loc_0315A:
    cmp al, 011h
    jne loc_03161
    jmp near ptr loc_03322
loc_03161:
    xor ah, ah
    shl ax, 1
    shl ax, 1
    shl ax, 1
    mov si, ax
    add si, 01816h
    mov es, word ptr cs:[ScreenSegment]
    xor dx, dx
    mov dl, byte ptr ds:[0215Eh]
    add dx, word ptr ds:[02160h]
    mov di, dx
    mov dl, byte ptr ds:[0215Ch]
    shl dl, 1
    shl dl, 1
    shl dl, 1
    shl dl, 1
    or dl, byte ptr ds:[0215Ch]
    mov dh, dl
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_031C1
    add di, 080A0h
loc_031C1:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_031F0
    add di, 080A0h
loc_031F0:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0321F
    add di, 080A0h
loc_0321F:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0324E
    add di, 080A0h
loc_0324E:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0327D
    add di, 080A0h
loc_0327D:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_032AC
    add di, 080A0h
loc_032AC:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_032DB
    add di, 080A0h
loc_032DB:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0330A
    add di, 080A0h
loc_0330A:
    add byte ptr ds:[0215Eh], 4
    cmp byte ptr ds:[0215Eh], 0A0h
    jb loc_03321
    mov byte ptr ds:[0215Eh], 0
    add word ptr ds:[02160h], 0140h
loc_03321:
    ret
loc_03322:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 0140h
    xor ah, ah
    mul cx
    mov word ptr ds:[02160h], ax
    mov al, byte ptr ss:[bp + 2]
    shl al, 1
    shl al, 1
    mov byte ptr ds:[0215Eh], al
    add bp, 2
    ret
loc_0333D:
    inc bp
    mov al, byte ptr ss:[bp]
    mov byte ptr ds:[0215Ch], al
    ret

; Zero the whole 32 KiB Tandy video buffer (ES=CS:95A4, left in ES). DF=0.
ClearTandy32K:
    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov ax, di
    mov cx, 04000h
    rep stosw
    ret

; Copy 192 rows of the 104-byte workspace (source offset from DS:234C, segment CS:9598)
; into the left 104 bytes of Tandy rows 4..195. Leaves DS = state segment, whatever
; DS was on entry.
CopyWorkspace104x192ToTandy:
    mov si, word ptr ds:[0234Ch]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 034h
    mov di, 0A0h
    mov bp, 0C0h
loc_0336B:
    mov cx, bx
    rep movsw
    sub di, 068h
    add di, 02000h
    test di, 08000h
    je loc_03380
    add di, 080A0h
loc_03380:
    dec bp
    jne loc_0336B
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Clear the left 104 bytes of all 200 Tandy rows; the rest of each row is untouched.
ClearTandy104x200:
    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov bp, 0C8h
loc_03393:
    mov cx, 034h
    xor ax, ax
    rep stosw
    sub di, 068h
    add di, 02000h
    test di, 08000h
    je loc_033AB
    add di, 080A0h
loc_033AB:
    dec bp
    jne loc_03393
    ret

loc_033AF:
    call loc_044D7
    jne loc_033B7
    jmp near ptr loc_044AA
loc_033B7:
    mov cx, word ptr cs:[05B9Eh]
loc_033BC:
    push cx
    mov cx, word ptr cs:[05B9Ch]
loc_033C2:
    push cx
    call loc_033DD
    pop cx
    loop loc_033C2
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    pop cx
    loop loc_033BC
    jmp short loc_033AF

loc_033DD:
    mov bx, word ptr cs:[05B9Ch]
    mov al, byte ptr ds:[si]
    mov ah, byte ptr ds:[bx + si]
    shl bx, 1
    mov dl, byte ptr ds:[bx + si]
    add bx, word ptr cs:[05B9Ch]
    mov dh, byte ptr ds:[bx + si]
    call loc_0344B
    mov byte ptr cs:[05B95h], cl
    mov byte ptr cs:[05B99h], ch
    call loc_0344B
    mov byte ptr cs:[05B94h], cl
    mov byte ptr cs:[05B98h], ch
    call loc_0344B
    mov byte ptr cs:[05B97h], cl
    mov byte ptr cs:[05B9Bh], ch
    call loc_0344B
    mov byte ptr cs:[05B96h], cl
    mov byte ptr cs:[05B9Ah], ch
    inc si
    cmp word ptr cs:[0BD6h], 0
    je loc_03433
    mov ax, word ptr cs:[05B9Ah]
    stosw
loc_03433:
    mov ax, word ptr cs:[05B96h]
    stosw
    cmp word ptr cs:[0BD6h], 0
    je loc_03445
    mov ax, word ptr cs:[05B98h]
    stosw
loc_03445:
    mov ax, word ptr cs:[05B94h]
    stosw
    ret

loc_0344B:
    ror dh, 1
    rcl cl, 1
    ror dl, 1
    rcl cl, 1
    ror ah, 1
    rcl cl, 1
    ror al, 1
    rcl cl, 1
    ror dh, 1
    rcl cl, 1
    ror dl, 1
    rcl cl, 1
    ror ah, 1
    rcl cl, 1
    ror al, 1
    rcl cl, 1
    ror cl, 1
    ror cl, 1
    ror cl, 1
    ror cl, 1
    cmp word ptr cs:[0BD6h], 0
    jne loc_0347C
    ret
loc_0347C:
    mov bx, ax
    xor ch, ch
    mov al, cl
    and al, 0Fh
    cmp al, byte ptr cs:[0]
    jne loc_03491
    or ch, 0Fh
    and cl, 0F0h
loc_03491:
    mov al, cl
    and al, 0F0h
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    cmp al, byte ptr cs:[0]
    jne loc_034AA
    or ch, 0F0h
    and cl, 0Fh
loc_034AA:
    mov ax, bx
    ret
    cmp di, -1
    je loc_034B5
    call loc_034C5
loc_034B5:
    mov di, word ptr ss:[bp + REC_SCREEN_OFS_LOWER]
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    add si, 0140h
    cmp di, -1
    jne loc_034C5
    ret
loc_034C5:
    mov bx, 058h
    mov cx, 010h
loc_034CB:
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    add di, bx
    loop loc_034CB
    ret
    cmp di, -1
    jne loc_034DE
    ret
loc_034DE:
    mov bx, 060h
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    ret
    cmp di, -1
    jne loc_03548
    ret
loc_03548:
    mov bx, 064h
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    ret
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    cmp ax, 0FFFFh
    je loc_03586
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    call loc_035AA
loc_03586:
    add word ptr ss:[bp + REC_Y], 010h
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS_LOWER], ax
    sub word ptr ss:[bp + REC_Y], 010h
    cmp ax, 0FFFFh
    jne loc_0359A
    ret
loc_0359A:
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS_LOWER], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    add di, 0140h
loc_035AA:
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 058h
    mov cx, 010h
loc_035BA:
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    add si, bx
    loop loc_035BA
    mov ds, word ptr cs:[MainDataSegment]
    ret
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    cmp ax, 0FFFFh
    jne loc_035D8
    ret
loc_035D8:
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 060h
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    mov ds, word ptr cs:[MainDataSegment]
    ret
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    cmp ax, 0FFFFh
    jne loc_03663
    ret
loc_03663:
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 064h
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_036A2:
    mov bx, dx
    mov cx, 0Dh
    mov ax, word ptr cs:[0959Ah]
    cmp word ptr ds:[02350h], 0E5Fh
    jb loc_036B7
    mov ax, word ptr cs:[0959Ch]
loc_036B7:
    mov ds, ax
loc_036B9:
    push cx
    push bx
    mov es, word ptr cs:[09592h]
    mov bl, byte ptr es:[bx]
    dec bl
    xor bh, bh
    shl bx, 1
    add bx, 08D92h
    mov si, word ptr cs:[bx]
    mov es, word ptr cs:[WorkspaceSegment]
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    sub di, 0678h
    pop bx
    add bx, 1
    pop cx
    loop loc_03752
    jmp short loc_03755
loc_03752:
    jmp near ptr loc_036B9
loc_03755:
    mov ds, word ptr cs:[MainDataSegment]
    ret

    mov word ptr cs:[05903h], 0
    mov di, word ptr cs:[058F9h]
    mov si, word ptr cs:[058FBh]
    mov cx, word ptr cs:[058FDh]
    mov bp, word ptr cs:[058FFh]
    shl bp, 1
    shl bp, 1
    cmp word ptr cs:[05905h], 0
    je loc_0378A
    mov ax, bp
    dec cx
    mul cx
    inc cx
    add si, ax
loc_0378A:
    push cx
    mov cx, word ptr cs:[058FDh]
    sub cx, word ptr cs:[05901h]
    or cx, cx
    js loc_037C6
    shr cx, 1
    jcxz loc_037C6
    dec cx
    jcxz loc_037B0
loc_037A0:
    add di, 02000h
    test di, 08000h
    je loc_037AE
    add di, 080A0h
loc_037AE:
    loop loc_037A0
loc_037B0:
    xor al, al
    mov cx, bp
    rep stosb
    sub di, bp
    add di, 02000h
    test di, 08000h
    je loc_037C6
    add di, 080A0h
loc_037C6:
    pop cx
loc_037C7:
    mov ax, word ptr cs:[05901h]
    cmp ax, word ptr cs:[058FDh]
    je loc_037F9
    add word ptr cs:[05903h], ax
    mov ax, word ptr cs:[058FDh]
    cmp ax, word ptr cs:[05903h]
    ja loc_037F4
    cmp word ptr cs:[05905h], 0
    je loc_037EE
    sub si, bp
    jmp short loc_037F0
loc_037EE:
    add si, bp
loc_037F0:
    loop loc_037C7
    jmp short loc_0381D
loc_037F4:
    sub word ptr cs:[05903h], ax
loc_037F9:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 08000h
    je loc_0380E
    add di, 080A0h
loc_0380E:
    cmp word ptr cs:[05905h], 0
    je loc_0381A
    sub si, bp
    sub si, bp
loc_0381A:
    pop cx
    loop loc_037C7
loc_0381D:
    xor al, al
    mov cx, bp
    rep stosb
    ret

loc_03824:
    mov ds, word ptr cs:[WorkspaceSegment]
loc_03829:
    mov cx, 050h
    rep movsw
    sub di, 0A0h
    add di, 02000h
    test di, 08000h
    je loc_03840
    add di, 080A0h
loc_03840:
    dec bp
    jne loc_03829
    mov ds, word ptr cs:[MainDataSegment]
    ret
; UNKNOWN: not yet classified as code or data
    db 0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h
    db 083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h
    db 023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,083h,0C7h,02Ch,0E2h,0D3h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh
    db 0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h
    db 05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h
    db 083h,0C7h,02h,083h,0C7h,02Ch,0E2h,0CBh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,026h
    db 023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h,083h,0C6h
    db 02h,0ABh,083h,0C7h,030h,0E2h,0E7h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0F7h,0D0h
    db 026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h,05h,083h
    db 0C6h,02h,083h,0C7h,02h,083h,0C7h,030h,0E2h,0E3h,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,083h,0C7h,032h,0E2h,0F1h,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h
    db 02h,083h,0C7h,032h,0E2h,0EFh,02Eh,08Eh,01Eh,096h,095h,0C3h,00h,08Bh,01Ch,08Bh
    db 044h,04h,08Bh,04Ch,08h,08Bh,054h,0Ch,02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh
    db 0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h
    db 0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,021h,01Dh,026h,021h,045h
    db 02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h,025h,039h,026h,020h,045h
    db 08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh,054h,0Eh,02Eh,0C6h,06h
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh
    db 026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h
    db 026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h,0E9h,04Dh,0FFh
    db 02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,08Bh,04Ch,08h,08Bh,054h
    db 0Ch,02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h
    db 01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh
    db 0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h
    db 021h,01Dh,026h,021h,045h,02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h
    db 025h,039h,026h,020h,045h,08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh
    db 054h,0Eh,02Eh,0C6h,06h,025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
    db 025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh,026h
    db 09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h,026h
    db 08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h,0E9h,0F7h,0FEh,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,08Bh,04Ch,08h,08Bh,054h,0Ch
    db 02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
    db 025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh
    db 0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h
    db 0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,021h,01Dh,026h,021h,045h
    db 02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h,025h,039h,026h,020h,045h
    db 08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh,054h,0Eh,02Eh,0C6h,06h
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
    db 025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
    db 039h,026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h
    db 02Eh,0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h
    db 03h,0E9h,0A1h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h
    db 04h,0F7h,0D0h,08Bh,04Ch,08h,0F7h,0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh
    db 026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h
    db 026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,075h,09Dh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h,08Bh,04Ch,08h,0F7h
    db 0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h,025h,039h,00h,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
    db 039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h
    db 0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h
    db 0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh
    db 0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h
    db 0E9h,070h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h
    db 0F7h,0D0h,08Bh,04Ch,08h,0F7h,0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h,025h
    db 039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
    db 039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h
    db 0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h
    db 0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh
    db 0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h
    db 0E9h,046h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh
    db 0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h,045h,02h,026h,020h,055h
    db 04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh
    db 026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,075h
    db 0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh,0F9h,0D0h
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h,045h
    db 02h,026h,020h,055h,04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h
    db 083h,0C6h,08h,083h,0C7h,034h,04Dh,074h,03h,0E9h,07Bh,0FFh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h
    db 045h,02h,026h,020h,055h,04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h
    db 02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,074h,03h,0E9h,051h
    db 0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h
    db 0B2h,0FFh,0F6h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h
    db 08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,075h,0CBh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h,0B2h,0FFh,0F6h,0D2h,0D0h
    db 0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
MAIN ends
end