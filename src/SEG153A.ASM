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
    je @@checkCopyList
    push ax
    and ax, 0FFh
    mov word ptr cs:[ResOptions], ax
    pop ax
@@checkCopyList:
    test ax, 04000h
    je @@checkOwnExe
    push ax
    push di
    push es
    push cs
    pop es
    mov di, offset ResArchiveList
@@copyListByte:
    movsb
    cmp byte ptr ds:[si - 1], 0FFh
    jne @@copyListByte
    pop es
    pop di
    pop ax
@@checkOwnExe:
    test ax, 02000h
    je @@checkBufferPtr
    push ax
    push cs
    call UseOwnExeAsArchive
    pop ax
@@checkBufferPtr:
    test ax, 01000h
    je @@done
    mov word ptr cs:[ResBufferPtr + 2], es
    mov word ptr cs:[ResBufferPtr], di
@@done:
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
    jb @@done
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
@@done:
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
@@copyNameChar:
    movsb
    cmp byte ptr ds:[si - 1h], 0
    je @@nameEnd
    cmp byte ptr ds:[si - 1h], 20h
    jne @@copyNameChar
@@nameEnd:
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
    jae @@readHeader
    jmp near ptr ExecCleanup
@@readHeader:
    mov cx, 1Bh
    xor dx, dx
    mov di, offset ExecMzHeader
    push cs
    pop es
    push cs
    call ReadHuge
    mov byte ptr ds:[ExecStatus], 2
    jae @@checkMzSignature
    jmp near ptr ExecCleanup
@@checkMzSignature:
    mov di, offset ExecMzHeader
    cmp word ptr ds:[ExecMzHeader], 5A4Dh
    mov byte ptr ds:[ExecStatus], 4
    je @@computeSizes
    jmp near ptr ExecCleanup
@@computeSizes:
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
    jae @@allocated
    jmp near ptr ExecCleanup
@@allocated:
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
@@copyTailChar:
    movsb
    cmp byte ptr ds:[si - 1h], 0
    jne @@copyTailChar
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
    jae @@readImage
    jmp near ptr ExecCleanup
@@readImage:
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
    jae @@seekRelocations
    jmp near ptr ExecCleanup
@@seekRelocations:
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
    jae @@nextRelocation
    jmp near ptr ExecCleanup
@@nextRelocation:
    cmp word ptr ds:[ExecMzHeader + 6], 0
    je @@startChild
    mov cx, 4
    mov di, offset ExecRelocEntry
    push cs
    pop es
    mov bx, ds:[ResHandle]
    push cs
    call ReadHuge
    mov byte ptr ds:[ExecStatus], 2
    jae @@applyRelocation
    jmp near ptr ExecCleanup
@@applyRelocation:
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
    jmp short @@nextRelocation
@@startChild:
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
    mov dx, offset ExecInt21Hook
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
    je @@closeArchive
    mov es, ds:[ExecChildSeg]
    mov ah, 49h
    int 21h
    mov word ptr ds:[ExecChildSeg], 0
@@closeArchive:
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
    jne @@checkExec
    cmp word ptr cs:[ExecNestDepth], 0
    je ExecChildTerminated
    dec word ptr cs:[ExecNestDepth]
    jmp short @@chainOldInt21
@@checkExec:
    cmp ah, 4Bh
    jne @@chainOldInt21
    inc word ptr cs:[ExecNestDepth]
@@chainOldInt21:
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
; segment on wrap. AX = 0, CF clear, or AX = error, CF set. The count drops by the
; requested chunk, not the bytes DOS returned, so a short read at end of file goes
; unnoticed.
ReadHuge:
    mov cs:[ReadHugeHandle], bx
    mov ax, cx
    or ax, dx
    je @@success
    push ds
    push es
    pop ds
@@readChunk:
    push bx
    push cx
    push dx
    push di
    or dx, dx
    jne @@clampChunk
    cmp cx, -1
    jb @@issueRead
@@clampChunk:
    mov cx, 0FFFFh
@@issueRead:
    mov dx, di
    mov ah, 3Fh
    push cx
    int 21h
    pop bp
    jb @@readFailed
    pop di
    pop dx
    pop cx
    pop bx
    sub cx, bp
    sbb dx, 0
    add di, bp
    jae @@checkRemaining
    mov ax, ds
    add ax, 1000h
    mov ds, ax
@@checkRemaining:
    mov ax, cx
    or ax, dx
    jne @@readChunk
    pop ds
@@success:
    xor ax, ax
    retf
@@readFailed:
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
    je @@success
    mov di, si
    push ds
    push es
    pop ds
@@writeChunk:
    push bx
    push cx
    push dx
    push di
    or dx, dx
    jne @@clampChunk
    cmp cx, -1
    jb @@issueWrite
@@clampChunk:
    mov cx, 0FFFFh
@@issueWrite:
    mov dx, di
    mov ah, 40h
    push cx
    int 21h
    jb @@writeFailed
    pop bp
    pop di
    pop dx
    pop cx
    pop bx
    sub cx, bp
    sbb dx, 0
    add di, bp
    jae @@checkRemaining
    mov ax, ds
    add ax, 1000h
    mov ds, ax
@@checkRemaining:
    mov ax, cx
    or ax, dx
    jne @@writeChunk
    pop ds
@@success:
    xor ax, ax
    retf
@@writeFailed:
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
    je @@setBuffer
    mov es, word ptr cs:[ResBufferPtr + 2]
    mov di, word ptr cs:[ResBufferPtr]
@@setBuffer:
    mov word ptr cs:[ResBufferPtr], di
    mov ax, cx
    or ax, dx
    je @@success
    xor di, di
    push ds
    push es
    pop ds
@@copyChunk:
    push bx
    push cx
    push dx
    push di
    or dx, dx
    jne @@clampChunk
    cmp cx, cs:[CopyChunkBytes]
    jb @@issueRead
@@clampChunk:
    mov cx, cs:[CopyChunkBytes]
@@issueRead:
    mov dx, di
    mov ah, 3Fh
    push cx
    int 21h
    jb @@copyFailed
    mov bx, cs:[CopyDestHandle]
    mov ax, 4000h
    int 21h
    pop bp
    jb @@copyFailed
    cmp ax, bp
    jne @@copyFailed
    pop di
    pop dx
    pop cx
    pop bx
    sub cx, bp
    sbb dx, 0
    mov ax, cx
    or ax, dx
    jne @@copyChunk
    pop ds
@@success:
    xor ax, ax
    retf
@@copyFailed:
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

; Far. DS:DX = ASCIIZ name (AX ignored). Searches ResArchiveList from ResCurArchive,
; wrapping; the name is case-folded and spaces are skipped. Hit: CF = 0, AX = BX = handle
; positioned at the data, CX:DX = length (low:high). Miss: AX = 2, CF = 1. Archives are
; opened read/write (3D02h).
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
    je @@searchArchives
    jmp near ptr @@openLooseFile
@@searchArchives:
    mov word ptr ds:[ResHandle], 0
    mov ax, word ptr ds:[ResCurArchive]
    mov word ptr ds:[ResSearchStart], ax
    mov word ptr ds:[ResHandle], 0
@@openArchive:
    mov dx, word ptr ds:[ResCurArchive]
    mov ax, 03D02h
    int 021h
    jae @@readHeader
    jmp near ptr @@tryNextArchive
@@readHeader:
    mov word ptr ds:[ResHandle], ax
    mov word ptr ds:[ResArchiveBase], 0
    mov word ptr ds:[ResArchiveBase + 2], 0
    mov dx, offset ResEntryCount
    mov cx, 0Ch
    mov bx, word ptr ds:[ResHandle]
    mov ah, DOS_READ_FILE
    int 021h
    jae @@checkMzStub
    jmp near ptr @@tryNextArchive
@@checkMzStub:
    cmp word ptr ds:[ResEntryCount], 05A4Dh
    jne @@checkSignature
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
    jae @@readShadowHeader
    jmp near ptr @@tryNextArchive
@@readShadowHeader:
    mov dx, offset ResEntryCount
    mov cx, 0Ch
    mov bx, word ptr ds:[ResHandle]
    mov ah, DOS_READ_FILE
    int 021h
    jae @@checkSignature
    jmp near ptr @@tryNextArchive
@@checkSignature:
    mov si, offset ResSignature
    mov di, offset ShadowSignature
    mov cx, 6
@@compareSignature:
    lodsb
    cmp al, byte ptr ds:[di]
    je @@nextSignatureByte
    jmp near ptr @@tryNextArchive
@@nextSignatureByte:
    inc di
    loop @@compareSignature
    mov cx, word ptr ds:[ResEntryCount]
    or cx, cx
    jne @@checkEntryCount
    jmp near ptr @@tryNextArchive
@@checkEntryCount:
    cmp cx, 0320h
    jb @@readEntry
    jmp near ptr @@tryNextArchive
@@readEntry:
    mov dx, offset ResEntryBuf
    mov cx, word ptr ds:[ResEntrySize]
    mov bx, word ptr ds:[ResHandle]
    mov ah, DOS_READ_FILE
    int 021h
    jae @@decryptEntry
    jmp near ptr @@tryNextArchive
@@decryptEntry:
    mov di, offset ResEntryBuf
    mov cx, word ptr ds:[ResEntrySize]
    mov ax, word ptr ds:[ResKey]
@@decryptByte:
    xor byte ptr ds:[di], al
    inc di
    add al, ah
    loop @@decryptByte
    mov word ptr ds:[ResKey], ax
    mov si, offset ResEntryBuf
    add si, 0Dh
    les di, dword ptr ds:[ResNamePtr]
    mov ah, 3
    push cs
    call StripDirectories
@@skipNameSpaces:
    cmp byte ptr es:[di], 020h
    jne @@skipEntrySpaces
    inc di
    jmp short @@skipNameSpaces
@@skipEntrySpaces:
    cmp byte ptr ds:[si], 020h
    jne @@compareNameChar
    inc si
    jmp short @@skipEntrySpaces
@@compareNameChar:
    mov al, byte ptr es:[di]
    inc di
    mov ah, byte ptr ds:[si]
    inc si
    cmp al, 061h
    jb @@compareUpper
    cmp al, 07Ah
    ja @@compareUpper
    and al, 05Fh
@@compareUpper:
    cmp al, ah
    jne @@nextEntry
    or al, al
    jne @@skipNameSpaces
    or ah, ah
    jne @@nextEntry
    mov si, offset ResEntryBuf
    mov dx, word ptr ds:[si + 5]
    mov cx, word ptr ds:[si + 7]
    add dx, word ptr ds:[ResArchiveBase]
    adc cx, word ptr ds:[ResArchiveBase + 2]
    mov ax, 04200h
    mov bx, word ptr ds:[ResHandle]
    int 021h
    jb @@tryNextArchive
    mov si, offset ResEntryBuf
    mov cx, word ptr ds:[si + 9]
    mov dx, word ptr ds:[si + 0Bh]
@@returnHandle:
    mov ax, word ptr ds:[ResHandle]
    mov bx, ax
    clc
    pop es
    pop ds
    pop di
    pop si
    retf
@@nextEntry:
    dec word ptr ds:[ResEntryCount]
    je @@tryNextArchive
    jmp near ptr @@readEntry
@@tryNextArchive:
    mov bx, word ptr ds:[ResHandle]
    or bx, bx
    je @@advanceArchive
    mov ah, DOS_CLOSE_FILE
    int 021h
    jb @@notFound
@@advanceArchive:
    mov si, word ptr ds:[ResCurArchive]
@@skipArchiveName:
    lodsb
    or al, al
    jne @@skipArchiveName
    cmp byte ptr ds:[si], 0FFh
    jne @@setCurArchive
    mov si, offset ResArchiveList
@@setCurArchive:
    mov word ptr ds:[ResCurArchive], si
    cmp si, word ptr ds:[ResSearchStart]
    je @@notFound
    jmp near ptr @@openArchive
@@notFound:
    mov bx, word ptr ds:[ResHandle]
    or bx, bx
    je @@returnError
    mov ah, DOS_CLOSE_FILE
    int 021h
@@returnError:
    mov ax, 2
    stc
    pop es
    pop ds
    pop di
    pop si
    retf
@@openLooseFile:
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
    jb @@notFound
    mov word ptr ds:[ResHandle], ax
    xor cx, cx
    mov dx, cx
    mov bx, ax
    mov ax, 04202h
    int 021h
    jb @@notFound
    push ax
    push dx
    xor cx, cx
    mov dx, cx
    mov bx, word ptr ds:[ResHandle]
    mov ax, 04200h
    int 021h
    pop dx
    pop cx
    jb @@notFound
    jmp near ptr @@returnHandle
CloseHandleIfOpen:
    or bx, bx
    je @@done
    mov ah, 3Eh
    int 21h
@@done:
    retf

; Copy the program's own path (from its environment) to ResArchiveList.
UseOwnExeAsArchive:
    mov ah, DOS_GET_PSP
    int 021h
    mov es, bx
    mov es, word ptr es:[02Ch]
    xor si, si
@@skipEnvironment:
    mov al, byte ptr es:[si]
    inc si
    or al, al
    jne @@skipEnvironment
    mov al, byte ptr es:[si]
    or al, al
    jne @@skipEnvironment
    add si, 3
    push ds
    push cs
    push es
    pop ds
    pop es
    cld
    mov di, offset ResArchiveList
@@copyPathChar:
    movsb
    cmp byte ptr ds:[si - 1], 0
    jne @@copyPathChar
    mov al, 0FFh
    stosb
    pop ds
    retf

; With ResOptions bit 2: skip DS:SI (AH bit 1) or ES:DI (AH bit 2) past the last "\".
StripDirectories:
    test word ptr cs:[ResOptions], 2
    je @@done
    test ah, 1
    je @@checkDestName
    mov bp, si
@@scanSourceName:
    lodsb
    or al, al
    je @@setSourceStart
    cmp al, 05Ch
    jne @@scanSourceName
    mov bp, si
    jmp short @@scanSourceName
@@setSourceStart:
    mov si, bp
@@checkDestName:
    test ah, 2
    je @@done
    mov bp, di
@@scanDestName:
    mov al, byte ptr es:[di]
    inc di
    or al, al
    je @@setDestStart
    cmp al, 05Ch
    jne @@scanDestName
    mov bp, di
    jmp short @@scanDestName
@@setDestStart:
    mov di, bp
@@done:
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
; Container: optional MZ stub (directory at (pages - 1) * 512 + last-page bytes), then
; {count < 800, key, 'SHADOW', 26}; entries XOR'd by one running key (value += step per
; byte, across entries): +5 dd offset from the header, +9 dd length, +13 ASCIIZ upper-case
; name. The game ignores the length; its streams end themselves.
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