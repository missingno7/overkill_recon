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
public ResLibSetup
; Observed frame153A: private CS state and DOS/file/path operations, with
; caller segment pointers. Distinct address frame, historical OBJ count unknown.
; Far. AX option bits: 8000h ResOptions = AL; 4000h copy the DS:SI archive name list
; (0FFh-terminated) to ResArchiveList; 2000h use the program's own EXE as the archive;
; 1000h ResBufferPtr = ES:DI. The game calls it with 4000h and ResourceArchiveList.
ResLibSetup:
    test ax, 08000h
    je loc_153AE
    push ax
    and ax, 0FFh
    mov word ptr cs:[ResOptions], ax
    pop ax
loc_153AE:
    test ax, 04000h
    je loc_153C5
    push ax
    push di
    push es
    push cs
    pop es
    mov di, offset ResArchiveList
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
    call UseOwnExeAsArchive
    pop ax
loc_153D0:
    test ax, 01000h
    je loc_153DF
    mov word ptr cs:[ResBufferPtr + 2], es
    mov word ptr cs:[ResBufferPtr], di
loc_153DF:
    retf
; Further resource-library routines (far entries ending in RETF). The game only calls
; 153A:0000 (ResLibSetup) and OpenResourceFile; no caller of these was found.
; Far. Open the resource named at DS:DX and read all of it to ES:DI. No caller found.
ResLoadWholeFile:
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
    call ReadHuge
    pop dx
    pop cx
    pop bx
    pushf
    push ax
    push cs
    call CloseHandleIfOpen
    pop ax
    popf
loc_153FC:
    retf
; Far. Load and run an MZ program stored in the archive (DS:DX = "NAME args"),
; hooking INT 21h to catch its exit; AX = ExecStatus:ExecExitCode. No caller found.
ExecResourceProgram:
    push ds
    push cs
    pop es
    mov si, dx
    mov di, offset ExecProgramName
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
    mov word ptr cs:[ExecTailPtr], si
    mov word ptr cs:[ExecTailPtr + 2], ds
    push cs
    pop ds
    mov word ptr ds:[ExecChildSeg], 0
    mov byte ptr ds:[ExecStatus], 1
    mov dx, offset ExecProgramName
    push cs
    call OpenResourceFile
    jae loc_1543C
    jmp near ptr ExecCleanup
loc_1543C:
    mov cx, 1Bh
    xor dx, dx
    mov di, offset ExecMzHeader
    push cs
    pop es
    push cs
    call ReadHuge
    mov byte ptr ds:[ExecStatus], 2
    jae loc_15454
    jmp near ptr ExecCleanup
loc_15454:
    mov di, offset ExecMzHeader
    cmp word ptr ds:[ExecMzHeader], 5A4Dh
    mov byte ptr ds:[ExecStatus], 4
    je loc_15467
    jmp near ptr ExecCleanup
loc_15467:
    mov bx, word ptr ds:[ExecMzHeader + 8]
    xor cx, cx
    add bx, bx
    adc cx, 0
    add bx, bx
    adc cx, 0
    add bx, bx
    adc cx, 0
    add bx, bx
    adc cx, 0
    mov word ptr ds:[ExecHeaderBytes], bx
    mov word ptr ds:[ExecHeaderBytes + 2], cx
    mov ax, word ptr ds:[ExecMzHeader + 4]
    dec ax
    add ax, ax
    mov dh, 0
    mov dl, ah
    mov ah, al
    mov al, dh
    add ax, word ptr ds:[ExecMzHeader + 2]
    adc dx, 0
    sub ax, bx
    sbb dx, cx
    mov word ptr ds:[ExecImageBytes], ax
    mov word ptr ds:[ExecImageBytes + 2], dx
    shr dx, 1
    rcr ax, 1
    shr dx, 1
    rcr ax, 1
    shr dx, 1
    rcr ax, 1
    shr dx, 1
    rcr ax, 1
    add ax, 11h
    add word ptr ds:[ExecMzHeader + 0Ah], ax
    mov word ptr ds:[ExecChildSeg], 0
    mov bx, 0FFFFh
    mov ah, 48h
    int 21h
    mov ah, 48h
    int 21h
    mov byte ptr ds:[ExecStatus], 3
    jae loc_154DB
    jmp near ptr ExecCleanup
loc_154DB:
    mov ds:[ExecChildSeg], ax
    mov ah, 2Fh
    int 21h
    mov word ptr ds:[ExecSavedDta], bx
    mov word ptr ds:[ExecSavedDta + 2], es
    mov ah, 51h
    int 21h
    mov ds:[ExecParentPsp], bx
    mov es, ds:[ExecChildSeg]
    mov ds, ds:[ExecParentPsp]
    xor si, si
    mov di, si
    mov cx, 100h
    cld
    rep movsb
    push cs
    pop ds
    mov es, ds:[ExecChildSeg]
    mov di, 81h
    lds si, dword ptr ds:[ExecTailPtr]
loc_15511:
    movsb
    cmp byte ptr ds:[si - 1h], 0
    jne loc_15511
    dec si
    mov byte ptr es:[di - 1h], 0Dh
    mov byte ptr es:[di], 0
    push cs
    pop ds
    sub si, word ptr ds:[ExecTailPtr]
    mov ax, si
    mov es:[80h], al
    mov cx, word ptr ds:[ExecHeaderBytes]
    mov dx, word ptr ds:[ExecHeaderBytes + 2]
    sub cx, 1Bh
    sbb dx, 0
    mov bx, ds:[ResHandle]
    xchg cx, dx
    mov ax, 4201h
    int 21h
    mov byte ptr ds:[ExecStatus], 2
    jae loc_15551
    jmp near ptr ExecCleanup
loc_15551:
    mov cx, word ptr ds:[ExecImageBytes]
    mov dx, word ptr ds:[ExecImageBytes + 2]
    mov ax, ds:[ExecChildSeg]
    add ax, 10h
    mov es, ax
    xor di, di
    mov bx, ds:[ResHandle]
    push cs
    call ReadHuge
    mov byte ptr ds:[ExecStatus], 2
    jae loc_15575
    jmp near ptr ExecCleanup
loc_15575:
    mov si, offset ResEntryBuf
    mov cx, ds:[si + 5]
    mov dx, ds:[si + 7]
    add cx, word ptr ds:[ResArchiveBase]
    adc dx, word ptr ds:[ResArchiveBase + 2]
    add cx, word ptr ds:[ExecMzHeader + 18h]
    adc dx, 0
    xchg cx, dx
    mov bx, ds:[ResHandle]
    mov ax, 4200h
    int 21h
    mov byte ptr ds:[ExecStatus], 2
    jae loc_155A2
    jmp near ptr ExecCleanup
loc_155A2:
    cmp word ptr ds:[ExecMzHeader + 6], 0
    je loc_155F3
    mov cx, 4
    mov di, offset ExecRelocEntry
    push cs
    pop es
    mov bx, ds:[ResHandle]
    push cs
    call ReadHuge
    mov byte ptr ds:[ExecStatus], 2
    jae loc_155C3
    jmp near ptr ExecCleanup
loc_155C3:
    mov ax, word ptr ds:[ExecRelocEntry]
    mov bx, word ptr ds:[ExecRelocEntry + 2]
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
    mov cx, ds:[ExecChildSeg]
    add cx, 10h
    add ax, cx
    mov es, ax
    add es:[si], cx
    dec word ptr ds:[ExecMzHeader + 6]
    jmp short loc_155A2
loc_155F3:
    mov bx, ds:[ResHandle]
    push cs
    call CloseHandleIfOpen
    mov word ptr ds:[ResHandle], 0
    mov ax, word ptr ds:[ExecMzHeader + 16h]
    add ax, ds:[ExecChildSeg]
    add ax, 10h
    mov word ptr ds:[ExecEntry + 2], ax
    mov ax, word ptr ds:[ExecMzHeader + 14h]
    mov word ptr ds:[ExecEntry], ax
    mov ax, word ptr ds:[ExecMzHeader + 0Eh]
    add ax, ds:[ExecChildSeg]
    add ax, 10h
    mov word ptr ds:[ExecMzHeader + 0Eh], ax
    mov ax, 3521h
    int 21h
    mov word ptr ds:[OldInt21], bx
    mov word ptr ds:[OldInt21 + 2], es
    mov dx, 31Ah
    mov ax, 2521h
    int 21h
    mov ds, ds:[ExecChildSeg]
    mov dx, 80h
    mov ah, 1Ah
    int 21h
    push cs
    pop ds
    cli
    mov ds:[ExecSavedSp], sp
    mov ds:[ExecSavedSs], ss
    mov ss, word ptr ds:[ExecMzHeader + 0Eh]
    mov sp, word ptr ds:[ExecMzHeader + 10h]
    sti
    mov ax, ds:[ExecChildSeg]
    mov es, ax
    mov ds, ax
    xor ax, ax
    mov bx, ax
    mov cx, ax
    mov dx, ax
    mov si, ax
    mov di, ax
    mov bp, ax
    jmp dword ptr cs:[ExecEntry]
ExecChildTerminated:
    push cs
    pop ds
    mov ds:[ExecExitCode], al
    cli
    mov sp, ds:[ExecSavedSp]
    mov ss, ds:[ExecSavedSs]
    sti
    mov ax, 2521h
    lds dx, dword ptr ds:[OldInt21]
    int 21h
    push cs
    pop ds
    lds dx, dword ptr ds:[ExecSavedDta]
    mov ah, 1Ah
    int 21h
    push cs
    pop ds
    mov byte ptr ds:[ExecStatus], 0
ExecCleanup:
    cmp word ptr ds:[ExecChildSeg], 0
    je loc_156AD
    mov es, ds:[ExecChildSeg]
    mov ah, 49h
    int 21h
    mov word ptr ds:[ExecChildSeg], 0
loc_156AD:
    mov bx, ds:[ResHandle]
    push cs
    call CloseHandleIfOpen
    mov ax, word ptr ds:[ExecExitCode]
    pop ds
    retf
; INT 21h hook while a child runs: counts nested EXECs; the top-level exit (AH=4Ch)
; returns to ExecChildTerminated. Everything else chains to OldInt21.
ExecInt21Hook:
    cmp ah, 4Ch
    jne loc_156CE
    cmp word ptr cs:[ExecNestDepth], 0
    je ExecChildTerminated
    dec word ptr cs:[ExecNestDepth]
    jmp short loc_156D8
loc_156CE:
    cmp ah, 4Bh
    jne loc_156D8
    inc word ptr cs:[ExecNestDepth]
loc_156D8:
    jmp dword ptr cs:[OldInt21]
; ExecResourceProgram state (it runs an MZ program stored in the archive).
OldInt21 dd 0
; Nested EXEC (AH=4Bh) calls made by the child.
ExecNestDepth dw 0
; Returned together in AX: the child exit code and a status (0 ok, 1 open failed,
; 2 read or seek failed, 3 no memory, 4 not MZ).
ExecExitCode db 0
ExecStatus db 0
ExecProgramName db 64 dup (0)
; Rest of the command string (copied to the child PSP tail).
ExecTailPtr dd 0
ExecChildSeg dw 0
ExecParentPsp dw 0
ExecSavedDta dd 0
ExecHeaderBytes dd 0
ExecImageBytes dd 0
; One relocation record (offset, segment).
ExecRelocEntry dd 0
ExecEntry dd 0
ExecSavedSp dw 0
ExecSavedSs dw 0
; The 1Bh-byte MZ header of the program being loaded.
ExecMzHeader db 01Bh dup (0)
; Read CX (low):DX (high) bytes from handle BX to ES:DI in chunks, stepping the
; segment on wrap. AX = 0, CF clear, or AX = error, CF set.
ReadHuge:
    mov cs:[ReadHugeHandle], bx
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
; Handle saved by ReadHuge (never read).
ReadHugeHandle dw 0
; Write CX (low):DX (high) bytes from ES:SI to handle BX in chunks. The error path
; pops in the wrong order (stack imbalance); no caller found.
WriteHuge:
    mov cs:[WriteHugeHandle], bx
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
; Handle saved by WriteHuge (never read).
WriteHugeHandle dw 0
; Copy CX:DX bytes from handle BX to handle AX through a buffer (CopyChunkBytes at a
; time; ResBufferPtr when ResOptions bit 4). No caller found; CopyChunkBytes is never set.
CopyFileData:
    mov cs:[CopySourceHandle], bx
    mov cs:[CopyDestHandle], ax
    test word ptr cs:[ResOptions], 4
    je loc_1581A
    mov es, word ptr cs:[ResBufferPtr + 2]
    mov di, word ptr cs:[ResBufferPtr]
loc_1581A:
    mov word ptr cs:[ResBufferPtr], di
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
    cmp cx, cs:[CopyChunkBytes]
    jb loc_1583E
loc_15839:
    mov cx, cs:[CopyChunkBytes]
loc_1583E:
    mov dx, di
    mov ah, 3Fh
    push cx
    int 21h
    jb loc_1586B
    mov bx, cs:[CopyDestHandle]
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
; CopyFileData chunk size and handles.
CopyChunkBytes dw 0
CopySourceHandle dw 0
CopyDestHandle dw 0

OpenResourceFile:
    push si
    push di
    mov word ptr cs:[ResNamePtr], dx
    mov word ptr cs:[ResNamePtr + 2], ds
    push ds
    push es
    push cs
    pop ds
    test word ptr ds:[ResOptions], 1
    je loc_15892
    jmp near ptr loc_15A21
loc_15892:
    mov word ptr ds:[ResHandle], 0
    mov ax, word ptr ds:[ResCurArchive]
    mov word ptr ds:[ResSearchStart], ax
    mov word ptr ds:[ResHandle], 0
loc_158A4:
    mov dx, word ptr ds:[ResCurArchive]
    mov ax, 03D02h
    int 021h
    jae loc_158B2
    jmp near ptr loc_159E0
loc_158B2:
    mov word ptr ds:[ResHandle], ax
    mov word ptr ds:[ResArchiveBase], 0
    mov word ptr ds:[ResArchiveBase + 2], 0
    mov dx, offset ResEntryCount
    mov cx, 0Ch
    mov bx, word ptr ds:[ResHandle]
    mov ah, DOS_READ_FILE
    int 021h
    jae loc_158D4
    jmp near ptr loc_159E0
loc_158D4:
    cmp word ptr ds:[ResEntryCount], 05A4Dh
    jne loc_15919
    mov ax, word ptr ds:[ResSignature]
    dec ax
    add ax, ax
    mov dh, 0
    mov dl, ah
    mov ah, al
    mov al, dh
    add ax, word ptr ds:[ResKey]
    adc dx, 0
    mov word ptr ds:[ResArchiveBase], ax
    mov word ptr ds:[ResArchiveBase + 2], dx
    mov cx, ax
    xchg cx, dx
    mov ax, 04200h
    int 021h
    jae loc_15906
    jmp near ptr loc_159E0
loc_15906:
    mov dx, offset ResEntryCount
    mov cx, 0Ch
    mov bx, word ptr ds:[ResHandle]
    mov ah, DOS_READ_FILE
    int 021h
    jae loc_15919
    jmp near ptr loc_159E0
loc_15919:
    mov si, offset ResSignature
    mov di, offset ShadowSignature
    mov cx, 6
loc_15922:
    lodsb
    cmp al, byte ptr ds:[di]
    je loc_1592A
    jmp near ptr loc_159E0
loc_1592A:
    inc di
    loop loc_15922
    mov cx, word ptr ds:[ResEntryCount]
    or cx, cx
    jne loc_15938
    jmp near ptr loc_159E0
loc_15938:
    cmp cx, 0320h
    jb loc_15941
    jmp near ptr loc_159E0
loc_15941:
    mov dx, offset ResEntryBuf
    mov cx, word ptr ds:[ResEntrySize]
    mov bx, word ptr ds:[ResHandle]
    mov ah, DOS_READ_FILE
    int 021h
    jae loc_15955
    jmp near ptr loc_159E0
loc_15955:
    mov di, offset ResEntryBuf
    mov cx, word ptr ds:[ResEntrySize]
    mov ax, word ptr ds:[ResKey]
loc_1595F:
    xor byte ptr ds:[di], al
    inc di
    add al, ah
    loop loc_1595F
    mov word ptr ds:[ResKey], ax
    mov si, offset ResEntryBuf
    add si, 0Dh
    les di, dword ptr ds:[ResNamePtr]
    mov ah, 3
    push cs
    call StripDirectories
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
    mov si, offset ResEntryBuf
    mov dx, word ptr ds:[si + 5]
    mov cx, word ptr ds:[si + 7]
    add dx, word ptr ds:[ResArchiveBase]
    adc cx, word ptr ds:[ResArchiveBase + 2]
    mov ax, 04200h
    mov bx, word ptr ds:[ResHandle]
    int 021h
    jb loc_159E0
    mov si, offset ResEntryBuf
    mov cx, word ptr ds:[si + 9]
    mov dx, word ptr ds:[si + 0Bh]
loc_159CC:
    mov ax, word ptr ds:[ResHandle]
    mov bx, ax
    clc
    pop es
    pop ds
    pop di
    pop si
    retf
loc_159D7:
    dec word ptr ds:[ResEntryCount]
    je loc_159E0
    jmp near ptr loc_15941
loc_159E0:
    mov bx, word ptr ds:[ResHandle]
    or bx, bx
    je loc_159EE
    mov ah, DOS_CLOSE_FILE
    int 021h
    jb loc_15A0C
loc_159EE:
    mov si, word ptr ds:[ResCurArchive]
loc_159F2:
    lodsb
    or al, al
    jne loc_159F2
    cmp byte ptr ds:[si], 0FFh
    jne loc_159FF
    mov si, offset ResArchiveList
loc_159FF:
    mov word ptr ds:[ResCurArchive], si
    cmp si, word ptr ds:[ResSearchStart]
    je loc_15A0C
    jmp near ptr loc_158A4
loc_15A0C:
    mov bx, word ptr ds:[ResHandle]
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
    mov word ptr ds:[ResHandle], 0
    les di, dword ptr ds:[ResNamePtr]
    mov ah, 2
    push cs
    call StripDirectories
    mov dx, di
    push ds
    push es
    pop ds
    mov ax, 03D02h
    int 021h
    pop ds
    jb loc_15A0C
    mov word ptr ds:[ResHandle], ax
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
    mov bx, word ptr ds:[ResHandle]
    mov ax, 04200h
    int 021h
    pop dx
    pop cx
    jb loc_15A0C
    jmp near ptr loc_159CC
CloseHandleIfOpen:
    or bx, bx
    je loc_15A6C
    mov ah, 3Eh
    int 21h
loc_15A6C:
    retf

; Copy the program's own path (from its environment) to ResArchiveList.
UseOwnExeAsArchive:
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
    mov di, offset ResArchiveList
loc_15A95:
    movsb
    cmp byte ptr ds:[si - 1], 0
    jne loc_15A95
    mov al, 0FFh
    stosb
    pop ds
    retf

; With ResOptions bit 2: skip DS:SI (AH bit 1) or ES:DI (AH bit 2) past the last "\".
StripDirectories:
    test word ptr cs:[ResOptions], 2
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
; Library options (ResLibSetup AX bit 8000h): bit 1 open loose files instead of
; searching archives, bit 2 strip directories, bit 4 CopyFileData uses ResBufferPtr.
ResOptions dw 0
ResBufferPtr dd 0
; Archive being searched (in ResArchiveList) and where the search began.
ResCurArchive dw offset ResArchiveList
ResSearchStart dw 0
ResHandle dw 0
; Caller's DS:DX name pointer.
ResNamePtr dd 0
; 12-byte header read from an archive: first probed as an MZ header, then as the
; SHADOW header {entry count, XOR key (low value, high step), signature, entry size}.
ResEntryCount dw 0
ResKey dw 0
ResSignature db 6 dup (0)
ResEntrySize dw 0
ShadowSignature db 'SHADOW'
; One decrypted directory entry: 5 unread bytes, data offset, length, name.
ResEntryBuf db 04Eh dup (0)
; File offset of the SHADOW header (0 when the file is not an MZ executable).
ResArchiveBase dd 0
; ASCIIZ archive names ending with 0FFh (set by ResLibSetup); no bounds check.
ResArchiveList db 072h dup (0FFh)
SEG153A ends
end