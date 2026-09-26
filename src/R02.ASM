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
extrn FileNamePtr:far
extrn FileStatus:far
extrn InputBits:far
extrn InputDeviceMode:far
extrn KeyLastMakeCode:far
extrn LevelIndex:far
extrn LoadSettingsFromHiscoreBlock:far
extrn ModuleSoundEnabled:far
extrn ModuleSoundRequest:far
extrn SaveSettingsToHiscoreBlock:far
extrn SfxActive:far
extrn SfxEnabled:far
extrn SfxRequest:far
extrn SoundModuleSlot:far
extrn SoundOption:far
extrn StateData:far
extrn WaitAllKeysReleased:far
extrn XorCodeHiscoreBlock:far
extrn loc_0F953:far
extrn loc_0F99D:far
extrn loc_0F9F9:far
extrn loc_10170:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public BlitPackedStride104
public BlitPackedStride160
public BlitPackedToScreen
public ClearKeyDownTable
public ClearScreen104x200
public ComputeRecordGridOffset
public CopyWorkspaceToScreen
public CountXReturn
public DrawOffsetFromRow9BC8
public DrawOffsetFromRow9D58
public DrawOffsetFromRow9EE8
public DrawPanelGraphic
public FlushBiosKeyboardBuffer
public InstallKeyboardVector09
public LoadHiscoreFile
public PromptLoadErrorWaitFire
public ReadIndexedByteAttribute
public ShutdownGame
public UpdateHighScoreTable
public WaitVerticalRetrace
public loc_044AA
public loc_044D7
public loc_04A65
public loc_04C76
public loc_04CED
public loc_04D64
public loc_04D95
public loc_04DBF
public loc_04F57
public loc_04FC3
public loc_04FF9
public loc_05059
public loc_0511F
public loc_05145
public loc_05160
public loc_0518C
public loc_0519A
public loc_0526A
public loc_054C0
public loc_05559
public loc_057E6
public loc_05800
public loc_05A36
public loc_05A7E
public loc_05A92
public loc_05AC8
public loc_05BAC
public loc_05BEE
public loc_05C04
public loc_05C22
public loc_05C35
public loc_05C9A
public loc_05CB7
public loc_05D0B
public loc_05DB2
public loc_05E42
public loc_05EDB
public loc_05F0D
public loc_05F43
extrn BlitPackedStride104Ega:near
extrn BlitPackedStride160Ega:near
extrn BlitPackedToScreenEga:near
extrn CalibrateJoystickWithAbort:near
extrn ClearScreen104x200Ega:near
extrn ClearTandy104x200:near
extrn CopyPackedRowsStride104:near
extrn CopyPackedRowsStride160:near
extrn CopyPackedRowsToTandyBanks:near
extrn CopyWorkspace104x192ToTandy:near
extrn CopyWorkspaceToScreenEga:near
extrn DrawOffsetFromRow9BC8Ega:near
extrn DrawOffsetFromRow9D58Ega:near
extrn DrawOffsetFromRow9EE8Ega:near
extrn FindFreeRecordPoolA:near
extrn LoadFileToBuffer:near
extrn MainDataSegment:near
extrn PanelSegment:near
extrn PollInputBits:near
extrn RestoreTimerVector08:near
extrn SaveBufferToFile:near
extrn ScreenSegment:near
extrn TandyOffsetFromRow9BC8:near
extrn TandyOffsetFromRow9D58:near
extrn TandyOffsetFromRow9EE8:near
extrn VideoAdapter:near
extrn WaitVerticalRetracePulse:near
extrn WorkspaceSegment:near
extrn loc_0075F:near
extrn loc_00B3E:near
extrn loc_02580:near
extrn loc_025B2:near
extrn loc_025FE:near
extrn loc_027D9:near
extrn loc_02B84:near
extrn loc_02E2D:near
extrn loc_030D2:near
extrn loc_03153:near
extrn loc_033AF:near
extrn loc_036A2:near
extrn loc_03824:near
extrn loc_0A781:near
extrn loc_0AF22:near
extrn loc_0AF63:near
extrn loc_0C640:near
extrn loc_0CB1C:near
extrn loc_0CB3E:near
extrn loc_0CBE8:near
; Modern grid-probe names; roles are local, broader map ownership unresolved.
; UNKNOWN: not yet classified as code or data
    db 0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h
    db 034h,04Dh,075h,0B7h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h
    db 04h,0F7h,0D0h,0B2h,0FFh,0F6h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h
    db 0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h
    db 08h,083h,0C7h,034h,04Dh,075h,0A3h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh
    db 0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h
    db 05h,026h,020h,055h,02h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h,0C7h,034h,04Dh,075h
    db 0CCh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h,055h,02h,0ADh,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h
    db 0C7h,034h,04Dh,075h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h,055h,02h,0ADh
    db 032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h,0C7h,034h
    db 04Dh,075h,098h,02Eh,08Eh,01Eh,096h,095h,0C3h

BlitPackedToScreenCga:
    lodsw
    mov cx, ax
    lodsw
    mov es, word ptr cs:[ScreenSegment]
    shl ax, 1
    mov bp, ax
loc_041A6:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 04000h
    je loc_041BB
    add di, 0C050h
loc_041BB:
    pop cx
    loop loc_041A6
    ret

BlitPackedStride104Cga:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    mov bp, ax
loc_041CC:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 034h
    pop cx
    loop loc_041CC
    ret

BlitPackedStride160Cga:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    mov bp, ax
loc_041E7:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 050h
    pop cx
    loop loc_041E7
    ret
loc_041F5:
    mov bx, word ptr ss:[bp + 2]
    cmp bx, 0E0h
    jb loc_04201
    jmp near ptr loc_025B2
loc_04201:
    shl bx, 1
    mov bx, word ptr ds:[bx - 06638h]
    cmp bx, -1
    jne loc_0420F
    jmp near ptr loc_025B2
loc_0420F:
    mov ax, word ptr ss:[bp + 4]
    mov cx, ax
    and cx, 3
    mov word ptr ss:[bp + 012h], cx
    shr ax, 1
    shr ax, 1
    add ax, bx
    cmp word ptr ss:[bp + 024h], 0
    jne loc_04227
    ret
loc_04227:
    dec word ptr ss:[bp + 024h]
    ret

DrawOffsetFromRow9EE8Cga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 06118h]
    xor ah, ah
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromRow9BC8Cga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 06438h]
    xor ah, ah
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromRow9D58Cga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx - 062A8h]
    xor ah, ah
    shl ax, 1
    add ax, bx
    mov di, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,0D1h,0E8h
    db 03h,0C3h,0C3h

loc_04277:
    cmp al, 010h
    jne loc_0427E
    jmp near ptr loc_0445E
loc_0427E:
    cmp al, 011h
    jne loc_04285
    jmp near ptr loc_04445
loc_04285:
    cmp al, 0Eh
    jne loc_0428C
    jmp near ptr loc_04439
loc_0428C:
    xor ah, ah
    shl ax, 1
    shl ax, 1
    shl ax, 1
    add ax, 01816h
    mov si, ax
    mov es, word ptr cs:[ScreenSegment]
    xor bx, bx
    mov bl, byte ptr ds:[0215Eh]
    add bx, word ptr ds:[02160h]
    mov di, bx
    mov bx, 021AEh
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_042DD
    add di, 0C050h
loc_042DD:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0430D
    add di, 0C050h
loc_0430D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0433D
    add di, 0C050h
loc_0433D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0436D
    add di, 0C050h
loc_0436D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0439D
    add di, 0C050h
loc_0439D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_043CD
    add di, 0C050h
loc_043CD:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_043FD
    add di, 0C050h
loc_043FD:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0442D
    add di, 0C050h
loc_0442D:
    add byte ptr ds:[0215Eh], 2
    cmp byte ptr ds:[0215Eh], 050h
    jb loc_04444
loc_04439:
    mov byte ptr ds:[0215Eh], 0
    add word ptr ds:[02160h], 0140h
loc_04444:
    ret
loc_04445:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 0140h
    xor ah, ah
    mul cx
    mov word ptr ds:[02160h], ax
    mov al, byte ptr ss:[bp + 2]
    add al, al
    mov byte ptr ds:[0215Eh], al
    add bp, 2
    ret
loc_0445E:
    inc bp
    mov al, byte ptr ss:[bp]
    and al, 3
    mov bx, 021BEh
    xlat
    mov byte ptr ds:[0215Ch], al
    ret

    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov ax, di
    mov cx, 02000h
    rep stosw
    ret

CopyWorkspaceToScreenCga:
    mov si, word ptr ds:[0234Ch]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 01Ah
    mov di, 0A0h
    mov bp, 0C0h
loc_04492:
    mov cx, bx
    rep movsw
    sub di, 034h
    add di, 02000h
    test di, 04000h
    je loc_044A7
    add di, 0C050h
loc_044A7:
    dec bp
    jne loc_04492
loc_044AA:
    mov ds, word ptr cs:[MainDataSegment]
CountXReturn:
    ret

ClearScreen104x200Cga:
    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov bp, 0C8h
loc_044BA:
    mov cx, 01Ah
    xor ax, ax
    rep stosw
    sub di, 034h
    add di, 02000h
    test di, 04000h
    je loc_044D2
    add di, 0C050h
loc_044D2:
    dec bp
    jne loc_044BA
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_044D7:
    mov ax, word ptr ds:[si]
    or ax, word ptr ds:[si + 2]
    jne loc_044DF
    ret
loc_044DF:
    mov bx, word ptr cs:[0BE0h]
    add word ptr cs:[0BE0h], 2
    lodsw
    cmp word ptr cs:[0BD8h], 0
    je loc_044F7
    mov word ptr cs:[bx], di
    stosw
loc_044F7:
    mov word ptr cs:[05B9Eh], ax
    lodsw
    cmp word ptr cs:[0BD8h], 0
    je loc_04505
    stosw
loc_04505:
    mov word ptr cs:[05B9Ch], ax
    inc ax
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_0450C:
    call loc_044D7
    je loc_044AA
    mov cx, word ptr cs:[05B9Eh]
loc_04516:
    push cx
    mov cx, word ptr cs:[05B9Ch]
loc_0451C:
    push cx
    call loc_04537
    pop cx
    loop loc_0451C
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    pop cx
    loop loc_04516
    jmp short loc_0450C

loc_04537:
    mov bx, word ptr cs:[05B9Ch]
    mov al, byte ptr ds:[si]
    mov ah, byte ptr ds:[bx + si]
    shl bx, 1
    mov dl, byte ptr ds:[bx + si]
    add bx, word ptr cs:[05B9Ch]
    mov dh, byte ptr ds:[bx + si]
    call loc_045F6
    mov byte ptr cs:[05B95h], cl
    mov byte ptr cs:[05B99h], ch
    call loc_045F6
    mov byte ptr cs:[05B94h], cl
    mov byte ptr cs:[05B98h], ch
    call loc_045F6
    mov byte ptr cs:[05B97h], cl
    mov byte ptr cs:[05B9Bh], ch
    call loc_045F6
    mov byte ptr cs:[05B96h], cl
    mov byte ptr cs:[05B9Ah], ch
    inc si
    cmp word ptr cs:[0BD6h], 0
    je loc_045A9
    mov al, byte ptr cs:[05B98h]
    call loc_045CB
    mov al, byte ptr cs:[05B99h]
    call loc_045CB
    mov al, byte ptr cs:[05B9Ah]
    call loc_045CB
    mov al, byte ptr cs:[05B9Bh]
    call loc_045CB
    mov ax, word ptr cs:[045E4h]
    stosw
loc_045A9:
    mov al, byte ptr cs:[05B94h]
    call loc_045CB
    mov al, byte ptr cs:[05B95h]
    call loc_045CB
    mov al, byte ptr cs:[05B96h]
    call loc_045CB
    mov al, byte ptr cs:[05B97h]
    call loc_045CB
    mov ax, word ptr cs:[045E4h]
    stosw
    ret

loc_045CB:
    call loc_045CE

loc_045CE:
    rol al, 1
    rol al, 1
    rol al, 1
    rcl word ptr cs:[045E4h],1
    rol al, 1
    rcl word ptr cs:[045E4h],1
    ret
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,00h,01h,01h,01h,02h,02h,02h,01h,02h,01h,01h
    db 01h,02h,02h,01h,03h

loc_045F6:
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
    je loc_04656
    mov bx, ax
    xor ch, ch
    mov al, cl
    and al, 0Fh
    cmp al, byte ptr cs:[0]
    jne loc_0463B
    or ch, 0Fh
    and cl, 0F0h
loc_0463B:
    mov al, cl
    and al, 0F0h
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    cmp al, byte ptr cs:[0]
    jne loc_04654
    or ch, 0F0h
    and cl, 0Fh
loc_04654:
    mov ax, bx
loc_04656:
    mov word ptr cs:[045E2h], ax
    mov al, cl
    and al, 0Fh
    mov bx, 045E6h
    db 02Eh ; decoded segment override
    xlat
    mov ah, al
    mov al, cl
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    and al, 0Fh
    db 02Eh ; decoded segment override
    xlat
    shl al, 1
    shl al, 1
    shl al, 1
    shl al, 1
    or al, ah
    mov cl, al
    mov ax, word ptr cs:[045E2h]
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,0FFh,0FFh,074h,03h,0E8h,010h,00h,08Bh,07Eh,010h,08Bh,076h,0Eh,081h,0C6h
    db 040h,01h,083h,0FFh,0FFh,075h,01h,0C3h,0B9h,010h,00h,0A5h,0A5h,0A5h,0A5h,0A4h
    db 083h,0C7h,02Bh,0E2h,0F6h,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0A5h,0A5h,0A4h,083h
    db 0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h
    db 0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0C3h,083h,0FFh,0FFh
    db 075h,01h,0C3h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h
    db 0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h
    db 031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0C3h,0E8h,0F3h,012h,089h
    db 046h,0Ch,03Dh,0FFh,0FFh,074h,0Fh,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h
    db 08Bh,07Eh,0Eh,0E8h,024h,00h,083h,046h,02h,010h,0E8h,0D5h,012h,089h,046h,010h
    db 083h,06Eh,02h,010h,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h
    db 010h,08Bh,0F0h,08Bh,07Eh,0Eh,081h,0C7h,040h,01h,02Eh,08Eh,06h,096h,095h,02Eh
    db 08Eh,01Eh,098h,095h,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,025h,012h,089h,046h,0Ch
    db 03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh
    db 07Eh,0Eh,02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0A5h,0A5h,0A4h,083h
    db 0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h
    db 0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,0E8h,09Dh,011h,089h,046h,0Ch,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h
    db 04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh,02Eh,08Eh,06h,096h,095h,02Eh
    db 08Eh,01Eh,098h,095h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h
    db 083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h
    db 0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,02Eh,08Eh,01Eh,096h
    db 095h,0C3h

loc_048E6:
    mov bx, dx
    mov cx, 0Dh
    mov ax, word ptr cs:[0959Ah]
    cmp word ptr ds:[02350h], 0E5Fh
    jb loc_048FB
    mov ax, word ptr cs:[0959Ch]
loc_048FB:
    mov ds, ax
loc_048FD:
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
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    sub di, 033Ch
    pop bx
    add bx, 1
    pop cx
    loop loc_048FD
    mov ds, word ptr cs:[MainDataSegment]
    ret

    mov word ptr cs:[05903h], 0
    mov di, word ptr cs:[058F9h]
    mov si, word ptr cs:[058FBh]
    mov cx, word ptr cs:[058FDh]
    mov bp, word ptr cs:[058FFh]
    shl bp, 1
    cmp word ptr cs:[05905h], 0
    je loc_049A7
    mov ax, bp
    dec cx
    mul cx
    inc cx
    add si, ax
loc_049A7:
    push cx
    mov cx, word ptr cs:[058FDh]
    sub cx, word ptr cs:[05901h]
    or cx, cx
    js loc_049E3
    shr cx, 1
    jcxz loc_049E3
    dec cx
    jcxz loc_049CD
loc_049BD:
    add di, 02000h
    test di, 04000h
    je loc_049CB
    add di, 0C050h
loc_049CB:
    loop loc_049BD
loc_049CD:
    xor al, al
    mov cx, bp
    rep stosb
    sub di, bp
    add di, 02000h
    test di, 04000h
    je loc_049E3
    add di, 0C050h
loc_049E3:
    pop cx
loc_049E4:
    mov ax, word ptr cs:[05901h]
    cmp ax, word ptr cs:[058FDh]
    je loc_04A16
    add word ptr cs:[05903h], ax
    mov ax, word ptr cs:[058FDh]
    cmp ax, word ptr cs:[05903h]
    ja loc_04A11
    cmp word ptr cs:[05905h], 0
    je loc_04A0B
    sub si, bp
    jmp short loc_04A0D
loc_04A0B:
    add si, bp
loc_04A0D:
    loop loc_049E4
    jmp short loc_04A3A
loc_04A11:
    sub word ptr cs:[05903h], ax
loc_04A16:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 04000h
    je loc_04A2B
    add di, 0C050h
loc_04A2B:
    cmp word ptr cs:[05905h], 0
    je loc_04A37
    sub si, bp
    sub si, bp
loc_04A37:
    pop cx
    loop loc_049E4
loc_04A3A:
    xor al, al
    mov cx, bp
    rep stosb
    ret

loc_04A41:
    mov ds, word ptr cs:[WorkspaceSegment]
loc_04A46:
    mov cx, 028h
    rep movsw
    sub di, 050h
    add di, 02000h
    test di, 04000h
    je loc_04A5C
    add di, 0C050h
loc_04A5C:
    dec bp
    jne loc_04A46
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_04A65:
    push di
loc_04A66:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    mov bx, word ptr ds:[bx - 03A17h]
    mov si, word ptr ds:[bx]
    lodsw
    mov word ptr ds:[020A4h], ax
    cmp ax, 0FFFFh
    jne loc_04A7E
    jmp near ptr loc_04C74
loc_04A7E:
    cmp ax, word ptr ds:[0A978h]
    je loc_04A87
    jmp near ptr loc_04C74
loc_04A87:
    mov byte ptr ds:[020A2h], 1
    lodsw
    cmp ax, 0FFFFh
    jne loc_04A98
    mov byte ptr ds:[020A2h], 0
    lodsw
loc_04A98:
    mov cx, ax
    lodsw
    mov word ptr ds:[0206Ch], ax
    lodsw
    mov word ptr ds:[0206Eh], ax
    push bx
    mov bx, word ptr ds:[020A4h]
    and bx, 03Fh
    mov bl, byte ptr ds:[bx - 037E6h]
    xor bh, bh
    mov ax, bx
    pop bx
    mov word ptr ds:[02070h], ax
    mov word ptr ds:[bx], si
    mov si, cx
    lodsw
    mov word ptr ds:[02072h], ax
    lodsw
    mov word ptr ds:[02074h], ax
    lodsw
    mov word ptr ds:[02076h], ax
    lodsw
    mov cx, ax
    call far ptr loc_0F953
loc_04ACE:
    push cx
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_04ADA
    jmp near ptr loc_04C70
loc_04ADA:
    mov ax, 0FFFFh
    cmp word ptr ds:[0209Ah], -1
    je loc_04AF5
    push bx
    mov bx, word ptr ds:[0209Ah]
    inc byte ptr ds:[bx + REC_STATUS]
    mov al, byte ptr ds:[02070h]
    mov byte ptr ds:[bx + 1], al
    pop bx
    mov ax, word ptr ds:[02098h]
loc_04AF5:
    mov word ptr ds:[bx + REC_SLOT_INDEX], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov ax, word ptr ds:[02074h]
    mov word ptr ds:[bx + REC_DRAW_PASS], ax
    mov word ptr ds:[bx + REC_SPRITE], 0
    mov ax, word ptr ds:[si + 2]
    add ax, word ptr ds:[0206Eh]
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[si]
    add ax, word ptr ds:[0206Ch]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_SAVED_Y], 0
    mov word ptr ds:[bx + REC_DIRECTION], 4
    mov ax, word ptr ds:[02072h]
    mov word ptr ds:[bx + REC_SIZE_CLASS], ax
    mov word ptr ds:[bx + REC_KIND], 4
    mov ax, word ptr ds:[02076h]
    mov word ptr ds:[bx + REC_TYPE], ax
    cmp word ptr ds:[bx + REC_DRAW_PASS], 1
    jne loc_04B41
    jmp near ptr loc_04BE7
loc_04B41:
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je loc_04B4A
    jmp near ptr loc_04BE7
loc_04B4A:
    and word ptr ds:[bx + REC_Y], 0FFF0h
    and word ptr ds:[bx + REC_X], 0FFF0h
    mov ax, word ptr ds:[bx + REC_X]
    mov word ptr ds:[020A0h], ax
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    mov word ptr ds:[0209Ch], ax
    push si
    push bx
    mov es, word ptr cs:[09592h]
    mov ax, word ptr ds:[bx + REC_Y]
    mov bx, word ptr ds:[02350h]
    add bx, 0Dh
    or ax, ax
    je loc_04B92
    js loc_04B86
loc_04B7A:
    or ax, ax
    je loc_04B92
    sub bx, 0Dh
    sub ax, 010h
    jmp short loc_04B7A
loc_04B86:
    or ax, ax
    je loc_04B92
    add bx, 0Dh
    add ax, 010h
    jmp short loc_04B86
loc_04B92:
    mov word ptr ds:[0209Eh], bx
loc_04B96:
    mov si, word ptr ds:[0209Eh]
    mov ax, word ptr ds:[0209Ch]
    add si, ax
    mov al, byte ptr es:[si]
; Same byte-attribute table as ReadIndexedByteAttribute; this consumer needs zero/nonzero.
    mov bx, BYTE_ATTRIBUTE_TABLE
    xlat
    or al, al
    je loc_04BD7
    cmp word ptr ds:[020A0h], 060h
    jb loc_04BC4
    dec word ptr ds:[0209Ch]
    cmp word ptr ds:[0209Ch], -1
    jne loc_04B96
    mov word ptr ds:[0209Ch], 0Ch
    jmp short loc_04B96
loc_04BC4:
    inc word ptr ds:[0209Ch]
    cmp word ptr ds:[0209Ch], 0Dh
    jb loc_04BD5
    mov word ptr ds:[0209Ch], 0
loc_04BD5:
    jmp short loc_04B96
loc_04BD7:
    mov ax, word ptr ds:[0209Ch]
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    pop bx
    mov word ptr ds:[bx + REC_X], ax
    pop si
loc_04BE7:
    mov word ptr ds:[bx + REC_HIT_POINTS], 1
    mov ax, word ptr ds:[LevelIndex]
    inc ax
    mov word ptr ds:[bx + REC_HIT_POINTS], ax
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je loc_04BFE
    mov word ptr ds:[bx + REC_HIT_POINTS], 0Ch
loc_04BFE:
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    cmp word ptr ds:[bx + REC_TYPE], 021h
    jne loc_04C0E
    call far ptr loc_0F9F9
loc_04C0E:
    mov ax, 0A484h
    cmp word ptr ds:[bx + 018h], 013h
    jne loc_04C1C
    call far ptr loc_0F9F9
loc_04C1C:
    mov ax, 0A4E8h
    cmp word ptr ds:[bx + 018h], 015h
    jne loc_04C2A
    call far ptr loc_0F9F9
loc_04C2A:
    mov ax, 0A7A2h
    cmp word ptr ds:[bx + 018h], 01Ch
    jne loc_04C38
    call far ptr loc_0F9F9
loc_04C38:
    mov ax, 0A82Eh
    cmp word ptr ds:[bx + 018h], 01Fh
    jne loc_04C46
    call far ptr loc_0F9F9
loc_04C46:
    mov ax, 0A638h
    cmp word ptr ds:[bx + 018h], 07Dh
    jne loc_04C54
    call far ptr loc_0F9F9
loc_04C54:
    mov ax, 0A6F4h
    cmp word ptr ds:[bx + 018h], 07Eh
    jne loc_04C62
    call far ptr loc_0F9F9
loc_04C62:
    add si, 4
    pop cx
    loop loc_04C6A
    jmp short loc_04C6D
loc_04C6A:
    jmp near ptr loc_04ACE
loc_04C6D:
    jmp near ptr loc_04A66
loc_04C70:
    pop cx
    jmp near ptr loc_04A66
loc_04C74:
    pop di
    ret

loc_04C76:
    mov si, 0C6C1h
    mov cx, 028h
loc_04C7C:
    lodsw
    lodsw
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 04C8Ah]
    dw loc_04C90, loc_04CA6, loc_04CBE    ; per VideoAdapter: CGA, EGA, Tandy

loc_04C90:
    mov bx, ax
    shr ax, 1
    shr ax, 1
    mov word ptr ds:[si - 2], ax
    and bx, 3
    add bx, 0C803h
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[si], bx
    jmp short loc_04CE7

loc_04CA6:
    mov bx, ax
    shr ax, 1
    shr ax, 1
    shr ax, 1
    mov word ptr ds:[si - 2], ax
    and bx, 7
    add bx, 0C807h
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[si], bx
    jmp short loc_04CE7

loc_04CBE:
    mov bx, ax
    shr ax, 1
    mov word ptr ds:[si - 2], ax
    and bx, 1
    add bx, 0C80Fh
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[si], bx
    cmp word ptr ds:[0C818h], 0
    je loc_04CE7
    dec word ptr ds:[0C818h]
    jne loc_04CE7
    and byte ptr ds:[0C80Fh], 7
    and byte ptr ds:[0C810h], 070h
loc_04CE7:
    add si, 2
    loop loc_04C7C
    ret

loc_04CED:
    mov es, word ptr cs:[WorkspaceSegment]
    mov si, 0C6C1h
    mov di, 0C7B1h
    mov bp, 04D4Dh
    mov cx, 014h
    call loc_04D15
    mov bp, 04D51h
    mov cx, 0Ah
    call loc_04D15
    mov cx, 0Ah
    call loc_04D15
    mov word ptr ds:[di], 0FFFFh
    ret

loc_04D15:
    lodsw
    mov bx, ax
    shl bx, 1
    add bx, 09A08h
    mov bx, word ptr ds:[bx]
    add bx, word ptr ds:[0234Ch]
    lodsw
    add bx, ax
    lodsw
    cmp byte ptr es:[bx], 0
    jne loc_04D61
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_04D59
    cmp byte ptr es:[bx + 01Ah], 0
    jne loc_04D61
    cmp byte ptr es:[bx + 034h], 0
    jne loc_04D61
    cmp byte ptr es:[bx + 04Eh], 0
    jne loc_04D61
    jmp bp
; UNKNOWN: not yet classified as code or data
    db 026h,088h,047h,04Eh,026h,088h,047h,034h,026h,088h,047h,01Ah
loc_04D59:
    mov byte ptr es:[bx], al
    mov word ptr ds:[di], bx
    add di, 2
loc_04D61:
    loop loc_04D15
    ret

loc_04D64:
    mov es, word ptr cs:[WorkspaceSegment]
    mov si, 0C7B1h
    mov cx, 028h
loc_04D6F:
    lodsw
    cmp ax, 0FFFFh
    je loc_04D94
    mov di, ax
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_04D8E
    mov byte ptr es:[di + 04Eh], 0
    mov byte ptr es:[di + 034h], 0
    mov byte ptr es:[di + 01Ah], 0
loc_04D8E:
    mov byte ptr es:[di], 0
    loop loc_04D6F
loc_04D94:
    ret
loc_04D95:
    add word ptr ds:[020A6h], 2
    cmp word ptr ds:[020A6h], 020C7h
    jb loc_04DA8
    mov word ptr ds:[020A6h], 020A8h
loc_04DA8:
    mov bx, word ptr ds:[020A6h]
    mov bx, word ptr ds:[bx]
    ret

loc_04DAF:
    lodsw
    mov di, ax
    lodsw
    mov dx, ax
    lodsw
    mov word ptr ds:[020C8h], ax
    lodsw
    cmp word ptr ds:[02350h], ax
    ret

loc_04DBF:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    add bx, 0C601h
    mov si, word ptr ds:[bx]
    mov cx, 3
loc_04DCE:
    call loc_04DAF
    jb loc_04DD8
    loop loc_04DCE
    call loc_04DAF
loc_04DD8:
    mov si, dx
    push si
    push di
    push word ptr ds:[0A978h]
    call loc_00B3E
    pop word ptr ds:[0A978h]
    pop di
    mov word ptr ds:[02350h], di
    push di
    call loc_04E26
    mov word ptr ds:[02350h], 0E93h
    pop di
    pop si
    call loc_04E0D
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    add bx, 020CAh
    mov bx, word ptr ds:[bx]
    mov ax, word ptr ds:[020C8h]
    mov word ptr ds:[bx], ax
    ret

loc_04E0D:
    push di
    push si
    call loc_0A781
    pop si
    pop di
    cmp word ptr ds:[02350h], di
    ja loc_04E0D
    cmp word ptr ds:[0234Eh], 0
    jne loc_04E0D
    mov word ptr ds:[0A978h], si
    ret

loc_04E26:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
    mov es, word ptr cs:[09592h]
    mov si, word ptr ds:[02350h]
    mov cx, 09Ch
loc_04E3B:
    dec si
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    mov bx, word ptr ds:[bx + 020D6h]
loc_04E46:
    cmp word ptr cs:[bx], -1
    je loc_04E69
    mov al, byte ptr es:[si]
    xor ah, ah
    cmp ax, word ptr cs:[bx]
    jne loc_04E5A
    jmp word ptr cs:[bx + 2]
loc_04E5A:
    add bx, 4
    jmp short loc_04E46
; UNKNOWN: not yet classified as code or data
    db 026h,0C6h,04h,028h,0EBh,04h,026h,0C6h,04h,01h
loc_04E69:
    loop loc_04E3B
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

; Show "SWAP DISKS" or "READ ERROR" (by FileStatus), wait for a primary button press
; and release, then blank the message.
PromptLoadErrorWaitFire:
    mov bp, 020E2h
    cmp word ptr ds:[FileStatus], FILE_STATUS_OPEN_FAILED
    je loc_04E82
    mov bp, 02100h
loc_04E82:
    call loc_0518C
loc_04E85:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_04E85
loc_04E8F:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_04E8F
    mov bp, 0211Eh
    jmp near ptr loc_0518C

; Save the current INT 09h vector in KBD_SAVED_INT09 and install
; Interrupt09KeyboardHandler. The old handler is never chained to.
InstallKeyboardVector09:
    push ds
    push es
    mov ah, DOS_GET_VECTOR
    mov al, 9
    int 021h
    mov di, KBD_SAVED_INT09
    mov word ptr ds:[di], es
    mov word ptr ds:[di + 2], bx
    pop es
    push ds
    push cs
    pop ds
    mov dx, 04ED2h
    mov ah, DOS_SET_VECTOR
    mov al, 9
    int 021h
    pop ds
    pop ds
    ret

; Put back the INT 09h vector saved by InstallKeyboardVector09.
RestoreKeyboardVector09:
    push ds
    mov di, KBD_SAVED_INT09
    mov dx, word ptr ds:[di + 2]
    mov ax, word ptr ds:[di]
    mov ds, ax
    mov ah, DOS_SET_VECTOR
    mov al, 9
    int 021h
    pop ds
    ret
; IRQ1: acknowledge the scancode through PPI port B, record make codes in
; KeyLastMakeCode and keep KEY_DOWN_TABLE current (E0/E1 prefixes clear entries
; 60h/61h). Alt+X leaves through ShutdownGame without IRET, abandoning the interrupt frame.
Interrupt09KeyboardHandler:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
    mov ds, word ptr cs:[MainDataSegment]
    in al, KBD_DATA_PORT
    mov bl, al
    in al, PPI_PORT_B
    mov ah, al
    or al, PPI_KBD_ACK
    out PPI_PORT_B, al
    xchg ah, al
    out PPI_PORT_B, al
    mov al, bl
    xor ah, ah
    mov bx, KEY_DOWN_TABLE
    test al, SCAN_RELEASE_BIT
    jne @@break_code
    mov byte ptr ds:[KeyLastMakeCode], al
    add bx, ax
    mov byte ptr ds:[bx], KEY_STATE_DOWN
    cmp bx, KEY_DOWN_TABLE + SCAN_X
    jne @@acknowledge_irq
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ALT], KEY_STATE_DOWN
    jne @@acknowledge_irq
    mov al, PIC_EOI_IRQ1
    out PIC1_COMMAND_PORT, al
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    jmp near ptr ShutdownGame
    jmp short @@acknowledge_irq     ; unreachable after the Alt+X exit jump
@@break_code:
    and al, SCAN_CODE_MASK
    add bx, ax
    mov byte ptr ds:[bx], KEY_STATE_UP
@@acknowledge_irq:
    mov al, PIC_EOI_IRQ1
    out PIC1_COMMAND_PORT, al
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    iret
; UNKNOWN: not yet classified as code or data
    db 02Eh,083h,03Eh,0BCh,095h,00h,074h,01h,0C3h,0E8h,080h,00h,0B8h,040h,00h,08Eh
    db 0C0h,026h,0A0h,065h,00h,0Ch,04h,0BAh,0D8h,03h,0EEh,026h,0A2h,065h,00h,0C3h

loc_04F57:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_04F60
    ret
loc_04F60:
    call loc_04F8C
    mov ah, 0Bh
    mov bh, 1
    mov bl, 0
    int 010h
    mov ax, 040h
    mov es, ax
    mov al, byte ptr es:[065h]
    and al, 0FBh
    mov dx, 03D8h
    out dx, al
    mov byte ptr es:[065h], al
    mov al, byte ptr es:[066h]
    and al, 0DFh
    or al, 0
    inc dx
    out dx, al
    mov byte ptr es:[066h], al

loc_04F8C:
    mov ax, 040h
    mov es, ax
    mov al, byte ptr es:[066h]
    or al, 010h
    mov byte ptr es:[066h], al
    mov dx, 03D9h
    out dx, al
    ret
; UNKNOWN: not yet classified as code or data
    db 02Eh,083h,03Eh,0BCh,095h,00h,074h,01h,0C3h,0E8h,03h,00h,0E8h,0B4h,0FFh,0B8h
    db 040h,00h,08Eh,0C0h,026h,0A0h,066h,00h,024h,0EFh,026h,0A2h,066h,00h,0BAh,0D9h
    db 03h,0EEh,0C3h

loc_04FC3:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_04FCC
    ret
loc_04FCC:
    call loc_04F8C
    mov ah, 0Bh
    mov bh, 1
    mov bl, 1
    int 010h
    mov ax, 040h
    mov es, ax
    mov al, byte ptr es:[065h]
    and al, 0FBh
    mov dx, 03D8h
    out dx, al
    mov byte ptr es:[065h], al
    mov al, byte ptr es:[066h]
    and al, 0DFh
    or al, 020h
    inc dx
    out dx, al
    mov byte ptr es:[066h], al
    ret

loc_04FF9:
    mov si, word ptr ss:[bp + 8]
    cmp si, 3
    jae loc_05059
    shl si, 1
    shl si, 1
    add si, 0214Eh
    push word ptr ss:[bp + REC_Y]
    push word ptr ss:[bp + REC_X]
    lodsw
    add word ptr ss:[bp + REC_Y], ax
    lodsw
    add word ptr ss:[bp + REC_X], ax
; Convert temporarily adjusted record coordinates to the13-byte-row grid.
; The next ADD overwrites the grid helper flags; later attribute ZF is live.
    call ComputeRecordGridOffset
    add bx, 0Dh
    mov ax, word ptr ds:[GRID_Y_SUM]
    and ax, 0Fh
    cmp ax, 0Ah
    mov cx, 1
    jbe loc_0502E
    mov cx, 2
loc_0502E:
    push cx
    push bx
    call ReadIndexedByteAttribute
    jne loc_05051
    test word ptr ss:[bp + REC_X], 0Fh
    je loc_05042
    inc bx
    call ReadIndexedByteAttribute
    jne loc_05051
loc_05042:
    pop bx
    sub bx, 0Dh
    pop cx
    loop loc_0502E
    pop word ptr ss:[bp + REC_X]
    pop word ptr ss:[bp + REC_Y]
    clc
    ret
loc_05051:
    pop bx
    pop cx
    pop word ptr ss:[bp + REC_X]
    pop word ptr ss:[bp + REC_Y]
loc_05059:
    stc
    ret

; Near leaf. ES=word CS:9592. Read byte ES:BX as unsigned index; read byte DS:[C3AA+index]. Return AX=zero-
; extended attribute, SI=C3AA+index, ES=selected segment. Final OR AL,AL sets ZF/SF/PF from attribute and clears
; CF/OF (AF unspecified). Preserve BX,CX,DX,BP,DI,DS,SS and IF/DF. No memory writes except ordinary call stack.
; Requires valid segment/lookup storage; no tile or entity identity asserted.
; Lookup chain: source byte -> attribute byte; callers consume zero/nonzero.
ReadIndexedByteAttribute:
    mov si, BYTE_ATTRIBUTE_TABLE
    mov es, word ptr cs:[ATTRIBUTE_SOURCE_SEGMENT]
    mov al, byte ptr es:[bx]
    xor ah, ah
    add si, ax
    mov al, byte ptr ds:[si]
    or al, al
    ret
GridOffsetNegativeY:
    mov bx, 0FFFFh
    ret

; Near entry5073 plus shared return tail506F. AX=wrapped16-bit(DS:234E + SS:[BP+REC_Y]); store it to DS:215A. If
; its sign bit is set, return BX=FFFF via506F, preserving CX/DX and leaving AX=sum. Otherwise row=AX>>4
; unsigned; DX=row, CX=4*row, AX=SS:[BP+REC_X]>>4 unsigned; BX=DS:2350-13*row+AX modulo65536. Preserve
; SI,DI,BP,DS,ES,SS and IF/DF. Flags on negative path come from Y ADD; normal path from final BX ADD.
; Caller4FF9 needs no returned flags;4FF9 immediately overwrites them at501A. Memory writes only215A, apart
; from stack. Ordinary record and state are disjoint; no silent saturation or signed division.
ComputeRecordGridOffset:
    mov ax, word ptr ds:[0234Eh]
    add ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[GRID_Y_SUM], ax
    js GridOffsetNegativeY
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    mov dx, ax
    shl ax, 1
    shl ax, 1
    mov cx, ax
    shl ax, 1
    add ax, cx
    add ax, dx
    mov bx, word ptr ds:[02350h]
    sub bx, ax
    mov ax, word ptr ss:[bp + REC_X]
    and ax, 0FFF0h
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    add bx, ax
    ret

; Mark every key as released, then fall through into FlushBiosKeyboardBuffer.
ClearKeyDownTable:
    mov es, word ptr cs:[MainDataSegment]
    mov di, KEY_DOWN_TABLE
    xor al, al
    mov cx, KEY_DOWN_COUNT
    rep stosb

; Empty the BIOS keyboard buffer by setting its tail to its head (low bytes only,
; which suffices for the standard buffer at 0040:001E..003D).
FlushBiosKeyboardBuffer:
    cli
    xor ax, ax
    mov es, ax
    mov al, byte ptr es:[BIOS_KBD_BUFFER_HEAD]
    mov byte ptr es:[BIOS_KBD_BUFFER_TAIL], al
    sti
    ret

; Wait for one video frame. Used as the game's delay unit: 250 frames at startup,
; 200 after a fatal error, 25 between calibration samples.
WaitVerticalRetrace:
    jmp near ptr WaitVerticalRetracePulse
; UNKNOWN: not yet classified as code or data
    db 01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,08Dh,0B0h,080h,03Eh,0BEh,098h,00h,075h,0F6h
    db 01Fh,0C3h,01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,07Bh,0B0h,080h,03Eh,0BEh,098h,00h
    db 074h,0F6h,01Fh,0C3h,0E8h,0EBh,0FFh,0EBh,0D7h,0B4h,00h,02Eh,083h,03Eh,0BCh,095h
    db 02h,074h,011h,0BAh,0DAh,03h,0ECh,0BAh,0C0h,03h,0B0h,011h,0EEh,08Ah,0C4h,0EEh
    db 0B0h,020h,0EEh,0C3h,0B4h,00h,0BAh,0DAh,03h,0B0h,02h,0EEh,0BAh,0DEh,03h,08Ah
    db 0C4h,0EEh,0C3h

loc_0511F:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_05128
    ret
loc_05128:
    inc word ptr cs:[0515Eh]
    and word ptr cs:[0515Eh], 1
    mov word ptr cs:[ScreenSegment], 0A000h
    jne loc_0513D
    ret
loc_0513D:
    mov word ptr cs:[ScreenSegment], 0A200h
    ret

loc_05145:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_0514E
    ret
loc_0514E:
    mov word ptr cs:[0515Eh], 0
    mov word ptr cs:[ScreenSegment], 0A000h
    jmp short loc_05160
; UNKNOWN: not yet classified as code or data
    db 00h,00h

loc_05160:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_05169
    ret
loc_05169:
    xor bx, bx
    cmp word ptr cs:[0515Eh], 0
    je loc_05176
    mov bx, 02000h
loc_05176:
    mov dx, CRT_STATUS_PORT
    in al, dx
    test al, 8
loc_0517C:
    in al, dx
    test al, 8
    jne loc_0517C
    cli
    sub dl, 6
    mov ah, bh
    mov al, 0Ch
    out dx, ax
    sti
    ret

loc_0518C:
    mov al, byte ptr ss:[bp]
    or al, al
    jne loc_05194
    ret
loc_05194:
    call loc_0519A
    inc bp
    jmp short loc_0518C

loc_0519A:
    mov es, word ptr cs:[MainDataSegment]
    cmp word ptr ds:[021A2h], 0
    je loc_051B8
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 051B2h]
    dw loc_04277, loc_025FE, loc_03153    ; per VideoAdapter: CGA, EGA, Tandy
loc_051B8:
    cmp al, 010h
    je loc_051F3
    cmp al, 011h
    je loc_051D6
    mov es, word ptr cs:[09594h]
    mov di, word ptr ds:[02160h]
    mov ah, byte ptr ds:[0215Ch]
    mov word ptr es:[di], ax
    add word ptr ds:[02160h], 2
    ret
loc_051D6:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 050h
    xor ah, ah
    mul cx
    mov bx, ax
    mov al, byte ptr ss:[bp + 2]
    xor ah, ah
    shl ax, 1
    add bx, ax
    mov word ptr ds:[02160h], bx
    add bp, 2
    ret
loc_051F3:
    inc bp
    mov al, byte ptr ss:[bp]
    mov byte ptr ds:[0215Ch], al
    ret
; UNKNOWN: not yet classified as code or data
    db 032h,0C0h,08Ah,0F8h,0B4h,010h,0B0h,01h,0CDh,010h,0C3h,0C7h,06h,0C2h,021h,01h
    db 00h,0E8h,07h,00h,0C7h,06h,0C2h,021h,00h,00h,0C3h,032h,0DBh,0B9h,0F0h,0D8h
    db 0E8h,015h,00h,0B9h,018h,0FCh,0E8h,0Fh,00h,0B9h,09Ch,0FFh,0E8h,09h,00h,0B1h
    db 0F6h,0E8h,04h,00h,08Ah,0C2h,0EBh,01Dh,032h,0C0h,03h,0D1h,0FEh,0C0h,072h,0FAh
    db 02Bh,0D1h,0FEh,0C8h,075h,0Fh,083h,03Eh,0C2h,021h,01h,074h,06h,0Ah,0DBh,0B0h
    db 020h,074h,06h,032h,0C0h,0FEh,0C3h,04h,030h,052h,051h,053h,083h,03Eh,0C2h,021h
    db 01h,074h,07h,0E8h,039h,0FFh,05Bh,059h,05Ah,0C3h,088h,05h,047h,0EBh,0F7h

loc_0526A:
    mov es, word ptr cs:[WorkspaceSegment]
    xor di, di
    mov ax, di
    mov cx, 08000h
    cmp word ptr ds:[021C4h], 0
    je loc_05280
    mov cx, 04000h
loc_05280:
    rep stosw
    ret

; Insert SCORE_BCD into the high-score table (532D) and save hiscore.dat if it qualified.
UpdateHighScoreTable:
    mov word ptr ds:[02288h], 0
    call loc_05BEE
    mov bp, SCORE_BCD
    call loc_0532D
    cmp word ptr ds:[02288h], 0
    jne SaveHiscoreFile
    ret

; Store the current settings into the high-score block, encode it, append the checksum
; and write hiscore.dat, then decode the block again for continued use.
SaveHiscoreFile:
    mov bx, word ptr cs:[VideoAdapter]
    call far ptr SaveSettingsToHiscoreBlock
    call far ptr XorCodeHiscoreBlock
    mov word ptr ds:[si], ax
    mov word ptr ds:[FileBufferSegment], seg StateData
    mov word ptr ds:[FileBufferOffset], HISCORE_BLOCK
    mov word ptr ds:[FileByteCount], 0AEh
    mov word ptr ds:[FileNamePtr], HISCORE_FILE_NAME
    call SaveBufferToFile
    mov si, HISCORE_BLOCK
    call far ptr XorCodeHiscoreBlock
    ret

; Load hiscore.dat: verify the checksum word over the encoded block, copy the block to
; HISCORE_BLOCK, decode it and apply the saved settings. Returns AL=1 on success,
; AL=0 if the file is missing or damaged. The byte count read is not checked.
LoadHiscoreFile:
    mov ax, seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
    mov word ptr ds:[FileNamePtr], HISCORE_FILE_NAME
    call LoadFileToBuffer
    cmp word ptr ds:[FileStatus], FILE_STATUS_OK
    jne loc_0532A
    mov ax, seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH
    mov es, ax
    xor si, si
    mov cx, HISCORE_BLOCK_BYTES
    xor ax, ax
loc_052F7:
    add al, byte ptr es:[si]
    adc ah, 0
    inc si
    loop loc_052F7
    cmp ax, word ptr es:[si]
    jne loc_0532A
    push ds
    push es
    pop ds
    xor si, si
    mov es, word ptr cs:[MainDataSegment]
    mov di, HISCORE_BLOCK
    mov cx, HISCORE_BLOCK_BYTES
    rep movsb
    pop ds
    call far ptr XorCodeHiscoreBlock
    call far ptr LoadSettingsFromHiscoreBlock
    mov word ptr cs:[VideoAdapter], bx
    mov al, 1
    ret
loc_0532A:
    xor al, al
    ret

loc_0532D:
    mov byte ptr ds:[02286h], 4
    mov bx, HISCORE_BLOCK
    mov cx, 8
loc_05338:
    mov al, byte ptr ds:[bx + 0Ch]
    sub al, byte ptr ss:[bp]
    mov al, byte ptr ds:[bx + 0Dh]
    sbb al, byte ptr ss:[bp + 1]
    mov al, byte ptr ds:[bx + 0Eh]
    sbb al, byte ptr ss:[bp + 2]
    mov al, byte ptr ds:[bx + 0Fh]
    sbb al, byte ptr ss:[bp + 3]
    jb loc_0535D
    add byte ptr ds:[02286h], 2
    add bx, 010h
    loop loc_05338
    ret
loc_0535D:
    mov word ptr ds:[02288h], 1
    mov es, word ptr cs:[MainDataSegment]
    std
    mov si, 02257h
    mov di, 02267h
loc_0536F:
    movsb
    cmp si, bx
    jne loc_0536F
    movsb
    cld
    mov di, bx
    push di
    call loc_05450
    mov ah, 0A8h
    mov al, 0
    mov si, 056h
    call DrawPanelGraphic
    mov dl, 0
    mov dh, byte ptr ds:[02286h]
    mov ah, 2
    mov bh, 0
    int 010h
    mov dx, 0228Ah
    mov ah, DOS_PRINT_STRING
    int 021h
    mov al, byte ptr ds:[02286h]
    mov byte ptr ds:[02296h], al
    mov bp, 02295h
    call loc_0518C
    mov bp, SCORE_BCD
    call loc_05EE4
    mov al, byte ptr ds:[02286h]
    mov byte ptr ds:[022AAh], al
    mov word ptr ds:[022B0h], 0229Bh
    mov es, word ptr cs:[MainDataSegment]
    mov di, 0229Bh
    mov al, 020h
    mov cx, 0Ah
    rep stosb
    mov al, 0
    stosb
loc_053C9:
    mov bp, 022A9h
    call loc_0518C
    mov bp, 0229Bh
    call loc_0518C
    call loc_05497
    cmp al, 8
    je loc_05408
    cmp al, 0Dh
    je loc_0541E
    cmp word ptr ds:[022B0h], 022A5h
    je loc_053FC
    cmp al, 020h
    jb loc_053C9
    cmp al, 07Ah
    ja loc_053C9
    mov di, word ptr ds:[022B0h]
    mov byte ptr ds:[di], al
    inc word ptr ds:[022B0h]
    jmp short loc_053C9
loc_053FC:
    call loc_05401
    jmp short loc_053C9

loc_05401:
    mov al, 7
    mov ah, 0Eh
    int 010h
    ret
loc_05408:
    cmp word ptr ds:[022B0h], 0229Bh
    je loc_053FC
    dec word ptr ds:[022B0h]
    mov di, word ptr ds:[022B0h]
    mov al, 020h
    mov byte ptr ds:[di], al
    jmp short loc_053C9
loc_0541E:
    cmp word ptr ds:[022B0h], 022A5h
    je loc_05433
    mov di, word ptr ds:[022B0h]
    mov byte ptr ds:[di], 020h
    inc word ptr ds:[022B0h]
    jmp short loc_0541E
loc_05433:
    pop di
    mov es, word ptr cs:[MainDataSegment]
    mov si, 0229Bh
    mov cx, 0Ah
    rep movsb
    inc di
    inc di
    mov ax, word ptr ds:[SCORE_BCD]
    stosw
    mov ax, word ptr ds:[SCORE_BCD + 2]
    stosw
    call ClearKeyDownTable
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_05450:
    mov ax, 0BECAh
    call far ptr loc_10170
    mov byte ptr cs:[0544Fh], 0
    mov cx, 8
loc_05461:
    push cx
    mov al, byte ptr cs:[0544Fh]
    shl al, 1
    add al, 4
    mov byte ptr ds:[021D3h], al
    mov bp, 021D2h
    call loc_0518C
    mov al, byte ptr cs:[0544Fh]
    xor ah, ah
    mov cx, 010h
    mul cx
    mov bp, HISCORE_BLOCK
    add bp, ax
    push bp
    call loc_0518C
    pop bp
    lea bp, ss:[bp + 0Ch]
    call loc_05EE4
    pop cx
    inc byte ptr cs:[0544Fh]
    loop loc_05461
    ret

loc_05497:
    mov ds, word ptr cs:[MainDataSegment]
    call RestoreKeyboardVector09
    mov word ptr ds:[022B2h], 0
    mov ah, DOS_CHAR_INPUT_NO_ECHO
    int 021h
    cmp al, 0
    je loc_054AF
    jmp short loc_054B7
loc_054AF:
    int 021h
    mov word ptr ds:[022B2h], 1
loc_054B7:
    mov byte ptr ds:[022B4h], al
    push ax
    call InstallKeyboardVector09
    pop ax
    ret

loc_054C0:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_054CE
    mov byte ptr ds:[02299h], 0Ah
    ret
loc_054CE:
    mov byte ptr ds:[02299h], 3
    ret

loc_054D4:
    mov ah, 041h
    mov al, 9
    mov si, 040h
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    call DrawPanelGraphicNextIfEqual
    mov ah, 057h
    mov al, 9
    mov si, 042h
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    call DrawPanelGraphicNextIfEqual
    mov ah, 040h
    mov al, 013h
    mov si, 044h
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ah
    mov al, 9
    mov si, 046h
    cmp word ptr ds:[SoundOption], 0
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ah
    mov al, 010h
    mov si, 048h
    cmp word ptr ds:[SoundOption], 1
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ah
    mov al, 014h
    mov si, 04Ah
    cmp word ptr ds:[SoundOption], 2
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ch
    mov al, 019h
    mov si, 04Ch
    cmp word ptr ds:[SoundOption], 3

; Flag-driven entry: with ZF set, draw graphic SI+1 (the highlighted variant) instead.
DrawPanelGraphicNextIfEqual:
    jne DrawPanelGraphic
    inc si

; Draw PANEL.ENC graphic SI at row AH, 8-pixel column AL.
DrawPanelGraphic:
    push si
    call DrawOffsetFromRow9EE8
    pop si
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_05559:
    mov word ptr ds:[022B7h], 0
loc_0555F:
    cmp word ptr ds:[022B7h], 0
    jne loc_05576
    call far ptr WaitAllKeysReleased
    mov ax, 0BEB8h
    call far ptr loc_10170
    call loc_054D4
loc_05576:
    cmp word ptr ds:[022B7h], 0
    je loc_05582
    call loc_05450
    jmp short loc_05585
loc_05582:
    call loc_054D4
loc_05585:
    mov word ptr ds:[022BFh], 0
loc_0558B:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_K], KEY_STATE_DOWN
    jne loc_05595
    jmp near ptr loc_0563D
loc_05595:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_J], KEY_STATE_DOWN
    jne loc_0559F
    jmp near ptr loc_05669
loc_0559F:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_A], KEY_STATE_DOWN
    jne loc_055A9
    jmp near ptr loc_056B2
loc_055A9:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_R], KEY_STATE_DOWN
    jne loc_055B3
    jmp near ptr loc_05732
loc_055B3:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_M], KEY_STATE_DOWN
    jne loc_055BD
    jmp near ptr loc_056E1
loc_055BD:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_O], KEY_STATE_DOWN
    je loc_05621
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_I], KEY_STATE_DOWN
    je loc_0562C
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    jne loc_055D5
    jmp near ptr ShutdownGame
loc_055D5:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F9], KEY_STATE_DOWN
    je loc_05637
    mov word ptr ds:[022B9h], 0
    mov word ptr ds:[022BBh], 0
    mov word ptr ds:[022BDh], 0
loc_055EE:
    call WaitVerticalRetrace
    inc word ptr ds:[022BFh]
    cmp word ptr ds:[022BFh], 02EEh
    jb loc_05613
    cmp word ptr ds:[022B7h], 0
    je loc_0560A
    call loc_0CBE8
    jmp near ptr loc_05559
loc_0560A:
    mov word ptr ds:[022B7h], 1
    jmp near ptr loc_0555F
loc_05613:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_05620
    jmp near ptr loc_0558B
loc_05620:
    ret
loc_05621:
    mov ax, 0BEA0h
    call far ptr loc_10170
    jmp near ptr loc_05559
loc_0562C:
    mov ax, 0BE92h
    call far ptr loc_10170
    jmp near ptr loc_05559
loc_05637:
    call loc_0075F
    jmp near ptr loc_05559
loc_0563D:
    cmp word ptr ds:[022B9h], 1
    je loc_055EE
    mov word ptr ds:[022B9h], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05656
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05656:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    cmp word ptr ds:[022B7h], 0
    jne loc_05666
    jmp near ptr loc_05576
loc_05666:
    jmp near ptr loc_05559
loc_05669:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05675
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05675:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_J], KEY_STATE_DOWN
    je loc_05675
    call loc_0CB3E
    call CalibrateJoystickWithAbort
    mov al, byte ptr ds:[ModuleSoundRequest]
    call loc_0CB1C
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    jne loc_056A5
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0569B
    mov byte ptr ds:[SfxRequest], 01Ch
loc_0569B:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    je loc_0569B
    jmp near ptr loc_05559
loc_056A5:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_056A5
    jmp near ptr loc_05559
loc_056B2:
    cmp word ptr ds:[022BBh], 1
    jne loc_056BC
    jmp near ptr loc_055EE
loc_056BC:
    mov word ptr ds:[022BBh], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_056CE
    mov byte ptr ds:[SfxRequest], 01Ch
loc_056CE:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    cmp word ptr ds:[022B7h], 0
    jne loc_056DE
    jmp near ptr loc_05576
loc_056DE:
    jmp near ptr loc_05559
loc_056E1:
    cmp word ptr ds:[022BDh], 1
    jne loc_056EB
    jmp near ptr loc_055EE
loc_056EB:
    mov word ptr ds:[022BDh], 1
    inc word ptr ds:[SoundOption]
    and word ptr ds:[SoundOption], 3
    mov bx, word ptr ds:[SoundOption]
    shl bx, 1
    mov bx, word ptr ds:[bx + SOUND_OPTION_FLAGS]
    mov byte ptr ds:[SfxEnabled], bh
    mov byte ptr ds:[ModuleSoundEnabled], bl
    cmp bl, 0
    jne loc_05714
    call loc_0CB3E
loc_05714:
    mov al, 2
    call loc_0CB1C
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05725
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05725:
    cmp word ptr ds:[022B7h], 0
    jne loc_0572F
    jmp near ptr loc_05576
loc_0572F:
    jmp near ptr loc_05559
loc_05732:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0573E
    mov byte ptr ds:[SfxRequest], 01Ch
loc_0573E:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_R], KEY_STATE_DOWN
    je loc_0573E
    mov ax, 0BEC4h
    call far ptr loc_10170
    mov byte ptr ds:[022CAh], 03Fh
    mov si, 050h
    mov di, KEY_BIT_SCANCODES_A + KEY_SLOT_YMINUS
    call PromptAndCaptureKeyBinding
    mov si, 051h
    mov di, KEY_BIT_SCANCODES_A + KEY_SLOT_YPLUS
    call PromptAndCaptureKeyBinding
    mov si, 052h
    mov di, KEY_BIT_SCANCODES_A + KEY_SLOT_XMINUS
    call PromptAndCaptureKeyBinding
    mov si, 053h
    mov di, KEY_BIT_SCANCODES_A + KEY_SLOT_XPLUS
    call PromptAndCaptureKeyBinding
    mov si, 054h
    mov di, KEY_BIT_SCANCODES_A + KEY_SLOT_PRIMARY
    call PromptAndCaptureKeyBinding
    mov si, 055h
    mov di, KEY_BIT_SCANCODES_A + KEY_SLOT_SECONDARY
    call PromptAndCaptureKeyBinding
    mov al, byte ptr ds:[KEY_BIT_SCANCODES_A + KEY_SLOT_SECONDARY]
    mov byte ptr ds:[KEY_BIT_SCANCODES_B + KEY_SLOT_SECONDARY], al
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    jmp near ptr loc_05559

; Show prompt graphic SI, wait for a key other than Esc/F9/F10, store its scancode at DI
; and wait for its release.
PromptAndCaptureKeyBinding:
    push di
    mov byte ptr ds:[KeyLastMakeCode], 0
    mov ah, byte ptr ds:[022CAh]
    add byte ptr ds:[022CAh], 017h
    mov al, 1
    call DrawPanelGraphic
loc_057AB:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_057AB
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_F9
    je loc_057AB
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_F10
    je loc_057AB
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_ESC
    je loc_057AB
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_057D3
    mov byte ptr ds:[SfxRequest], 01Ch
loc_057D3:
    mov bl, byte ptr ds:[KeyLastMakeCode]
    xor bh, bh
    pop di
    mov byte ptr ds:[di], bl
    add bx, KEY_DOWN_TABLE
loc_057E0:
    cmp byte ptr ds:[bx], 0
    jne loc_057E0
    ret

loc_057E6:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_057F4
loc_057ED:
    cmp byte ptr ds:[SfxActive], 0
    jne loc_057ED
loc_057F4:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05800
    mov byte ptr ds:[SfxRequest], 5

loc_05800:
    call loc_0580B
    mov ds, word ptr cs:[MainDataSegment]
    jmp near ptr loc_05BEE

loc_0580B:
    xor si, si
    mov ds, word ptr cs:[ScreenSegment]
    mov es, word ptr cs:[WorkspaceSegment]
    xor di, di
    mov ax, 0C8h
    stosw
    mov ax, 028h
    stosw
    mov dx, 03CEh
    mov cx, 0C8h
loc_05827:
    push cx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05834h]
    dw loc_0583A, loc_05852, loc_0587E    ; per VideoAdapter: CGA, EGA, Tandy

loc_0583A:
    mov cx, 050h
    rep movsb
    sub si, 050h
    add si, 02000h
    test si, 04000h
    je loc_05850
    add si, 0C050h
loc_05850:
    jmp short loc_05895

loc_05852:
    mov ax, 4
    out dx, ax
    mov cx, 028h
    rep movsb
    sub si, 028h
    inc ah
    out dx, ax
    mov cx, 028h
    rep movsb
    sub si, 028h
    inc ah
    out dx, ax
    mov cx, 028h
    rep movsb
    sub si, 028h
    inc ah
    out dx, ax
    mov cx, 028h
    rep movsb
    jmp short loc_05895

loc_0587E:
    mov cx, 050h
    rep movsw
    sub si, 0A0h
    add si, 02000h
    test si, 08000h
    je loc_05895
    add si, 080A0h
loc_05895:
    pop cx
    loop loc_05827
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_058A4
    mov ax, 4
    out dx, ax
loc_058A4:
    mov ds, word ptr cs:[WorkspaceSegment]
    xor di, di
    xor si, si
    mov cx, 1
    lodsw
    mov word ptr cs:[058FDh], ax
    lodsw
    mov word ptr cs:[058FFh], ax
    mov word ptr cs:[058FBh], si
    mov word ptr cs:[058F9h], di
    mov word ptr cs:[05905h], 0
    mov word ptr cs:[05907h], 0
    mov es, word ptr cs:[ScreenSegment]
    mov cx, word ptr cs:[058FDh]
    sub cx, 2
loc_058DF:
    push cx
    mov word ptr cs:[05901h], cx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + 0595Ah]
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop loc_058DF
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,036h,0C6h,06h,0C3h,098h,00h,0ADh,02Eh,0A3h,0FDh,058h,0ADh,02Eh,0A3h
    db 0FFh,058h,02Eh,089h,036h,0FBh,058h,02Eh,089h,03Eh,0F9h,058h,02Eh,0C7h,06h,05h
    db 059h,00h,00h,02Eh,0C7h,06h,07h,059h,00h,00h,02Eh,0C7h,06h,09h,059h,00h
    db 00h,02Eh,08Eh,06h,0A4h,095h,051h,0E8h,01Dh,00h,075h,0Eh,0E8h,018h,00h,075h
    db 09h,059h,0E2h,0F2h,02Eh,08Eh,01Eh,096h,095h,0C3h,059h,02Eh,08Eh,01Eh,096h,095h
    db 0C3h,07Ah,049h,02Dh,02Dh,05Bh,037h,02Eh,08Bh,0Eh,0FDh,058h,083h,0E9h,02h,051h
    db 02Eh,089h,0Eh,01h,059h,02Eh,08Bh,01Eh,0BCh,095h,0D1h,0E3h,02Eh,0FFh,097h,05Ah
    db 059h,01Eh,02Eh,08Eh,01Eh,096h,095h,080h,03Eh,0C3h,098h,00h,075h,060h,0E8h,0D8h
    db 0A7h,080h,03Eh,0BEh,098h,010h,074h,056h,01Fh,0E8h,034h,0F7h,0E8h,031h,0F7h,059h
    db 049h,0E2h,0CCh,02Eh,083h,036h,05h,059h,01h,02Eh,083h,036h,07h,059h,01h,02Eh
    db 08Bh,0Eh,0FDh,058h,083h,0E9h,02h,02Eh,083h,06h,01h,059h,02h,051h,02Eh,083h
    db 06h,01h,059h,02h,02Eh,08Bh,01Eh,0BCh,095h,0D1h,0E3h,02Eh,0FFh,097h,05Ah,059h
    db 01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,090h,0A7h,080h,03Eh,0BEh,098h,010h,074h,0Eh
    db 01Fh,0E8h,0ECh,0F6h,0E8h,0E9h,0F6h,059h,049h,0E2h,0D2h,033h,0C0h,0C3h,01Fh,059h
    db 033h,0C0h,040h,0C3h,02Eh,08Bh,01Eh,0BCh,095h,0D1h,0E3h,02Eh,0FFh,0A7h,0FAh,059h
    db 090h,064h,042h,0E9h,025h,042h,031h

; Per-adapter screen offset for row AH and 8-pixel column AL (row table 9EE8 on Tandy).
DrawOffsetFromRow9EE8:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A0Ch]
    dw DrawOffsetFromRow9EE8Cga, DrawOffsetFromRow9EE8Ega, TandyOffsetFromRow9EE8    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter screen offset for row AH and 8-pixel column AL (row table 9BC8 on Tandy).
DrawOffsetFromRow9BC8:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A1Eh]
    dw DrawOffsetFromRow9BC8Cga, DrawOffsetFromRow9BC8Ega, TandyOffsetFromRow9BC8    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter screen offset for row AH and 8-pixel column AL (row table 9D58 on Tandy).
DrawOffsetFromRow9D58:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A30h]
    dw DrawOffsetFromRow9D58Cga, DrawOffsetFromRow9D58Ega, TandyOffsetFromRow9D58    ; per VideoAdapter: CGA, EGA, Tandy
loc_05A36:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A42h]
    dw loc_041F5, loc_02580, loc_030D2    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter copy of a packed image into the 104-byte-wide workspace.
BlitPackedStride104:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A54h]
    dw BlitPackedStride104Cga, BlitPackedStride104Ega, CopyPackedRowsStride104    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter copy of a packed image into a 160-byte-wide buffer.
BlitPackedStride160:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A66h]
    dw BlitPackedStride160Cga, BlitPackedStride160Ega, CopyPackedRowsStride160    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter draw of the packed image at DS:SI to the screen at DI.
BlitPackedToScreen:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A78h]
    dw BlitPackedToScreenCga, BlitPackedToScreenEga, CopyPackedRowsToTandyBanks    ; per VideoAdapter: CGA, EGA, Tandy
loc_05A7E:
    mov dx, bx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05A8Ch]
    dw loc_048E6, loc_02B84, loc_036A2    ; per VideoAdapter: CGA, EGA, Tandy

loc_05A92:
    mov es, word ptr cs:[WorkspaceSegment]
    mov di, word ptr ss:[bp + REC_SCREEN_OFS]
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05AB6h]
    dw 04711h, 046AAh, 04684h    ; VideoAdapter handlers: CGA, EGA, Tandy
; UNKNOWN: not yet classified as code or data
    db 0E5h,029h,0C6h,029h,091h,029h,042h,035h,0D8h,034h
    db 0ADh,034h

loc_05AC8:
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05AE2h]
; UNKNOWN: not yet classified as code or data
    db 090h,096h,048h,0Eh,048h,040h,047h,0F9h,02Ah,0B9h,02Ah,04Fh,02Ah,057h,036h,0CCh
    db 035h,06Ch,035h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
loc_05BAC:
    mov word ptr cs:[05BAAh], bp
    mov word ptr cs:[05BA8h], 0FFFFh
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05BC4h]
    dw loc_0450C, loc_027D9, loc_033AF    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter clear of the 104-byte-wide play area.
ClearScreen104x200:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05BD6h]
    dw ClearScreen104x200Cga, ClearScreen104x200Ega, ClearTandy104x200    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter copy of the workspace to the screen.
CopyWorkspaceToScreen:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05BE8h]
    dw CopyWorkspaceToScreenCga, CopyWorkspaceToScreenEga, CopyWorkspace104x192ToTandy    ; per VideoAdapter: CGA, EGA, Tandy

loc_05BEE:
    call loc_05145
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05BFEh]
; UNKNOWN: not yet classified as code or data
    db 090h,06Ch,044h,037h,027h,045h,033h

loc_05C04:
    xor di, di
    xor si, si
    mov bp, 0C8h
    mov es, word ptr cs:[ScreenSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 05C1Ch]
    dw loc_04A41, loc_02E2D, loc_03824    ; per VideoAdapter: CGA, EGA, Tandy

loc_05C22:
    call loc_05BEE
    xor di, di
    xor si, si
    mov ax, word ptr cs:[WorkspaceSegment]
    add ax, 07D0h
    inc ax
    mov ds, ax
    jmp short loc_05C46

loc_05C35:
    call loc_05BEE
    mov ah, 04Eh
    xor al, al
    call DrawOffsetFromRow9EE8
    xor si, si
    mov ds, word ptr cs:[095B2h]

loc_05C46:
    lodsw
    mov word ptr cs:[058FDh], ax
    lodsw
    mov word ptr cs:[058FFh], ax
    mov word ptr cs:[058FBh], si
    mov word ptr cs:[058F9h], di
    mov word ptr cs:[05905h], 0
    mov word ptr cs:[05907h], 0
    mov word ptr cs:[05901h], 6
    mov es, word ptr cs:[ScreenSegment]
loc_05C74:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + 0595Ah]
    call WaitVerticalRetrace
    add word ptr cs:[05901h], 2
    mov ax, word ptr cs:[05901h]
    cmp ax, word ptr cs:[058FDh]
    jne loc_05C74
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_05C9A:
    call loc_05BEE
    mov ax, 01Bh
    call DrawOffsetFromRow9EE8
    mov si, 025h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call loc_05C46

loc_05CB7:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_05CC0
    ret
loc_05CC0:
    push ds
    mov ax, 0105h
    mov dx, 03CEh
    out dx, ax
    xor si, si
    mov di, 02000h
    mov es, word ptr cs:[ScreenSegment]
    push es
    pop ds
    mov cx, 01F40h
    rep movsb
    mov ax, 5
    mov dx, 03CEh
    out dx, ax
    pop ds
    ret
; UNKNOWN: not yet classified as code or data
    db 052h,086h,0F2h,0E8h,01h,00h,05Ah,052h,0D0h,0EAh,0D0h,0EAh,0D0h,0EAh,0D0h,0EAh
    db 0E8h,01h,00h,05Ah,080h,0E2h,0Fh,080h,0FAh,0Ah,072h,03h,080h,0C2h,07h,080h
    db 0C2h,030h,08Ah,0C2h,0B4h,0Eh,0CDh,010h,0C3h
loc_05D0B:
    mov ds, word ptr cs:[MainDataSegment]
    inc byte ptr ds:[022CFh]
; Common exit: silence the speaker, save hiscore.dat, stop sound, restore the keyboard
; vector, return to text mode and exit to DOS. If DS:22CF is nonzero an error message
; naming FileNamePtr is printed first.
ShutdownGame:
    mov ds, word ptr cs:[MainDataSegment]
    sti
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    push word ptr ds:[FileNamePtr]
    call SaveHiscoreFile
    pop word ptr ds:[FileNamePtr]
    call loc_05145
    call loc_0CB3E
    call RestoreKeyboardVector09
    call RestoreTimerVector08
    mov ax, 3
    int 010h
    cmp byte ptr ds:[022CFh], 0
    je loc_05D7E
    mov dx, 022D0h
    mov ah, DOS_PRINT_STRING
    int 021h
    mov si, word ptr ds:[FileNamePtr]
loc_05D4E:
    lodsb
    or al, al
    jne loc_05D4E
    mov byte ptr ds:[si - 1], 024h
    mov dx, word ptr ds:[FileNamePtr]
    mov si, dx
    cmp byte ptr ds:[si + 1], 03Ah
    jne loc_05D66
    add dx, 2
loc_05D66:
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, 022EDh
    mov ah, DOS_PRINT_STRING
    int 021h
    call loc_0C640
    call far ptr loc_0F99D
    mov ax, 04C00h
    int 021h
loc_05D7E:
    mov dl, 0
    mov dh, 016h
    mov ah, 2
    mov bh, 0
    int 010h
    mov ax, 0B800h
    mov es, ax
    xor di, di
    mov si, 0A988h
    mov cx, 07D0h
    rep movsw
    cli
    xor ax, ax
    mov es, ax
    mov al, byte ptr es:[041Ah]
    mov byte ptr es:[041Ch], al
    sti
    call loc_0C640
    call far ptr loc_0F99D
    mov ax, 04C00h
    int 021h

loc_05DB2:
    mov word ptr ds:[0A954h], 0
    mov word ptr ds:[0230Ah], 0
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ds:[02304h]
    jb loc_05DCB
    ja loc_05DD3
    jmp short loc_05DD9
loc_05DCB:
    mov word ptr ds:[0A954h], 1
    jmp short loc_05DD9
loc_05DD3:
    mov word ptr ds:[0A954h], 2
loc_05DD9:
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ds:[02306h]
    jl loc_05DE6
    jg loc_05DED
    jmp short loc_05DF2
loc_05DE6:
    or word ptr ds:[0A954h], 4
    jmp short loc_05DF2
loc_05DED:
    or word ptr ds:[0A954h], 8
loc_05DF2:
    mov bx, 0A348h
    mov ax, word ptr ds:[0A954h]
    xlat
    cmp al, 0FFh
    je loc_05E14
    mov word ptr ss:[bp + REC_DIRECTION], ax
    mov bx, word ptr ds:[02308h]
    shl bx, 1
    jmp word ptr cs:[bx + 05E0Ch]
; UNKNOWN: not yet classified as code or data
    db 090h,0A2h,0AFh,063h,0AFh,060h,0AFh,0E4h,0AEh
loc_05E14:
    mov word ptr ds:[0230Ah], 1
    ret
; UNKNOWN: not yet classified as code or data
    db 0BAh,04h,00h,083h,07Fh,014h,01h,074h,03h,0BAh,0Ch,00h,08Bh,046h,04h,08Bh
    db 04Fh,04h,03h,0CAh,02Bh,0C1h,089h,046h,02Ch,08Bh,046h,02h,08Bh,04Fh,02h,03h
    db 0CAh,02Bh,0C1h,089h,046h,02Ah,0C3h
loc_05E42:
    mov word ptr ds:[0230Ch], 0
    mov word ptr ds:[0230Eh], 0
    mov word ptr ds:[02310h], 0
    mov ax, word ptr ss:[bp + REC_DELTA_X]
    or ax, ax
    jns loc_05E61
    neg ax
    inc word ptr ds:[0230Ch]
loc_05E61:
    mov bx, word ptr ss:[bp + REC_DELTA_Y]
    or bx, bx
    jns loc_05E6E
    neg bx
    inc word ptr ds:[0230Eh]
loc_05E6E:
    cmp ax, bx
    je loc_05E93
    ja loc_05E81
    add word ptr ss:[bp + REC_STEP_ERROR], ax
    cmp word ptr ss:[bp + REC_STEP_ERROR], bx
    jbe loc_05E96
    sub word ptr ss:[bp + REC_STEP_ERROR], bx
    jmp short loc_05E93
loc_05E81:
    add word ptr ss:[bp + REC_STEP_ERROR], bx
    cmp word ptr ss:[bp + REC_STEP_ERROR], ax
    jbe loc_05E8E
    sub word ptr ss:[bp + REC_STEP_ERROR], ax
    jmp short loc_05E93
loc_05E8E:
    call loc_05EB5
    jmp short loc_05E99
loc_05E93:
    call loc_05EB5
loc_05E96:
    call loc_05EC8
loc_05E99:
    mov bx, 0A348h
    mov ax, word ptr ds:[02310h]
    xlat
    cmp al, 0FFh
    jne loc_05EA5
    ret
loc_05EA5:
    mov word ptr ss:[bp + REC_DIRECTION], ax
    cmp word ptr ds:[02312h], 3
    jne loc_05EB2
    jmp near ptr loc_0AF22
loc_05EB2:
    jmp near ptr loc_0AF63
loc_05EB5:
    cmp word ptr ds:[0230Ch], 1
    je loc_05EC2
    or word ptr ds:[02310h], 2
    ret
loc_05EC2:
    or word ptr ds:[02310h], 1
    ret
loc_05EC8:
    cmp word ptr ds:[0230Eh], 1
    je loc_05ED5
    or word ptr ds:[02310h], 8
    ret
loc_05ED5:
    or word ptr ds:[02310h], 4
    ret

loc_05EDB:
    mov bp, 02318h
    call loc_0518C
    mov bp, SCORE_BCD

loc_05EE4:
    mov al, byte ptr ss:[bp + 3]
    call loc_05EF9
    mov al, byte ptr ss:[bp + 2]
    call loc_05EF9
    mov al, byte ptr ss:[bp + 1]
    call loc_05EF9
    mov al, byte ptr ss:[bp]

loc_05EF9:
    push ax
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    call loc_05F06
    pop ax

loc_05F06:
    and al, 0Fh
    add al, 030h
    jmp near ptr loc_0519A

loc_05F0D:
    push bp
    push ax
    push dx
    mov bp, SCORE_BCD
    mov al, byte ptr ss:[bp]
    add al, bl
    daa
    mov byte ptr ss:[bp], al
    inc bp
    mov al, byte ptr ss:[bp]
    mov dh, al
    adc al, bh
    daa
    mov byte ptr ss:[bp], al
    mov dl, al
    inc bp
    mov al, byte ptr ss:[bp]
    adc al, 0
    daa
    mov byte ptr ss:[bp], al
    inc bp
    mov al, byte ptr ss:[bp]
    adc al, 0
    daa
    mov byte ptr ss:[bp], al
    inc bp
    pop dx
    pop ax
    pop bp
    ret

loc_05F43:
    mov al, 4
    cmp word ptr ds:[02350h], 09Ch
    je loc_05F5E
    mov al, 5
    cmp word ptr ds:[02350h], 0EA0h
    je loc_05F5E
    mov bx, 0231Eh
    mov al, byte ptr ds:[LevelIndex]
    xlat
loc_05F5E:
    jmp near ptr loc_0CB1C

MAIN ends
end