; Bridges and hardware/DOS leaves for platform_policy.c.
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
locals
extrn PLATFORM_POLICY_ENABLE_FILE_FLAGS:near
extrn PLATFORM_POLICY_LOAD_SOUND_MODULE:near
extrn PLATFORM_POLICY_SHOW_BOSS_KEY_SCREEN:near
extrn PLATFORM_POLICY_CHECKSUM_FILE:near
extrn ProbeVgaDac:near
extrn LoadSoundModuleFile:near
extrn SoundModuleInitEntry:far
extrn SoundModuleSlot:far
extrn MainDataSegment:word
extrn VideoAdapter:word
extrn VideoBiosModeTable:byte
extrn BossKeyScreen:word
extrn IntegrityBufferSegment:word
extrn IntegritySum:word
extrn IntegritySkip:word
extrn IntegrityFileExe:byte
extrn FileNamePtr:word
extrn FileHandle:word
extrn Codeword:byte
extrn NonAsciiCodeword:byte
extrn OldNonAsciiCodeword:byte
extrn Password:byte
extrn CorruptMsgHead:byte
extrn CorruptMsgTail:byte
extrn CorruptMsgPressKey:byte
extrn DrainBiosKeysInt16:near
extrn XorCopy16BytesAA:near
extrn CopyTextScreen:near
extrn FillTextAttributeRow:near
extrn FillTextAttributes:near
extrn IntegrityRunningSum:word
extrn IntegrityBytesRead:word
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public EnableFileFlagsIfVgaDac, LoadSoundModule, ShowBossKeyScreen, ChecksumFileOrAbort
public PolicySetTextMode, PolicyDrawBossKeyScreen, PolicyRestoreVideoMode
public PolicyChecksumAllocateAndOpen, PolicyChecksumReadChunk, PolicyChecksumClose
public PolicyChecksumCopyCodewords, PolicyChecksumFree, PolicyChecksumAbort
public PolicyLoadSoundModuleFile, PolicyInitializeSoundModule, PolicySoundModuleSegment

; ProbeVgaDac owns the port sequence and leaves its read result in AL. The C policy only
; sets the persistent decode flag when that exact result is 1; the final CMP recreates the
; probe's caller-visible flags and AX result.
EnableFileFlagsIfVgaDac:
    push si
    call ProbeVgaDac
    push ax
    mov si, ax
    call PLATFORM_POLICY_ENABLE_FILE_FLAGS
    pop ax
    pop si
    cmp al, 1
    ret

LoadSoundModule:
    call PLATFORM_POLICY_LOAD_SOUND_MODULE
    cmp byte ptr ds:[SoundModuleLoaded], 0
    je @@loadDone
    mov ax, seg SoundModuleSlot
    mov es, ax
    cmp byte ptr ds:[ModuleSoundEnabled], 0
    je @@loadDone
    mov bx, ax
@@loadDone:
    ret

; C passes the caller's live BP/ES pair as a stack-backed DosRegisters object.
ShowBossKeyScreen:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call PLATFORM_POLICY_SHOW_BOSS_KEY_SCREEN
    pop di
    pop si
    pop bp
    pop es
    ret

; Keep all literal text-mode drawing and BIOS calls in this leaf. Its ES result is B800h.
PolicySetTextMode:
    mov ax, 3
    int 010h
    ret

PolicyDrawBossKeyScreen:
    mov ds, word ptr cs:[MainDataSegment]
    mov ax, 0B800h
    mov es, ax
    xor di, di
    mov si, offset BossKeyScreen
    call CopyTextScreen
    mov di, 1
    mov al, 0Ch
    call FillTextAttributeRow
    mov al, 0Eh
    mov cx, 01E0h
    call FillTextAttributes
    mov cx, 0Fh
@@colorRow:
    push cx
    mov al, 0Eh
    mov cx, 1
    call FillTextAttributes
    mov al, 7
    mov cx, 04Fh
    call FillTextAttributes
    pop cx
    loop @@colorRow
    mov al, 01Eh
    call FillTextAttributeRow
    mov al, 01Eh
    call FillTextAttributeRow
    mov di, 0731h
    mov al, 071h
    mov cx, 0Dh
    call FillTextAttributes
    mov dl, 047h
    mov dh, 017h
    mov ah, 2
    mov bh, 0
    int 010h
    mov ds, word ptr cs:[MainDataSegment]
    ret

PolicyRestoreVideoMode:
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, offset VideoBiosModeTable
    xlat
    int 010h
    ret

; The original ignores DOS errors. Keep the exact allocation/open order and handle writes.
PolicyChecksumAllocateAndOpen:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    mov word ptr ds:[FileNamePtr], si
    mov bx, 0180h
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    mov word ptr cs:[IntegrityBufferSegment], ax
    xor al, al
    mov ah, DOS_OPEN_FILE
    int 021h
    mov word ptr ds:[FileHandle], ax
    mov word ptr cs:[IntegrityRunningSum], 01234h
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; Carry the final 66 bytes of each full chunk into offset zero before reading the next
; chunk. On the EOF read this is the trailer/codeword window used by the original.
PolicyChecksumReadChunk:
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    mov ax, word ptr cs:[MainDataSegment]
    mov ds, ax
    mov bx, word ptr ds:[FileHandle]
    mov ax, word ptr cs:[IntegrityBufferSegment]
    mov ds, ax
    mov cx, 042h
    xor di, di
    mov si, 01400h
    push ds
    pop es
    rep movsb
    mov cx, 01400h
    mov dx, 042h
    mov ah, DOS_READ_FILE
    int 021h
    push ax
    mov word ptr cs:[IntegrityBytesRead], ax
    mov ds, word ptr cs:[MainDataSegment]
    pop ax
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    retf

PolicyChecksumClose:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    mov bx, word ptr ds:[FileHandle]
    mov ah, DOS_CLOSE_FILE
    int 021h
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; Preserve the oracle's in-place XOR before copying each group into DS codeword state.
PolicyChecksumCopyCodewords:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds
    mov ds, word ptr cs:[IntegrityBufferSegment]
    mov ax, word ptr cs:[MainDataSegment]
    mov es, ax
    mov di, offset Codeword
    call XorCopy16BytesAA
    mov di, offset NonAsciiCodeword
    call XorCopy16BytesAA
    mov di, offset OldNonAsciiCodeword
    call XorCopy16BytesAA
    mov di, offset Password
    call XorCopy16BytesAA
    pop ds
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    retf

; AX is the running checksum at the original FREE_MEMORY interrupt boundary. DOS sees the
; allocated segment in both ES and DS; restore the C caller's state DS after the interrupt.
PolicyChecksumFree:
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    push ds
    mov ax, si
    mov es, word ptr cs:[IntegrityBufferSegment]
    mov ds, word ptr cs:[IntegrityBufferSegment]
    mov ah, DOS_FREE_MEMORY
    int 021h
    pop ds
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    retf

; This is intentionally non-returning, separate from ShowFatalErrorAndExit and
; ShutdownGame. Startup checksum failure prints the file name, waits, then exits 1.
PolicyChecksumAbort:
    mov ax, 3
    int 010h
    mov dx, offset CorruptMsgHead
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, word ptr ds:[FileNamePtr]
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, offset CorruptMsgTail
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dl, 0
    mov dh, 018h
    mov ah, 2
    mov bh, 0
    int 010h
    mov dx, offset CorruptMsgPressKey
    mov ah, DOS_PRINT_STRING
    int 021h
    call DrainBiosKeysInt16
    mov ah, DOS_CHAR_INPUT_NO_ECHO
    int 021h
    mov ax, 04C01h
    int 021h
@@abortedIfDosReturns:
    jmp short @@abortedIfDosReturns

; Narrow wrappers keep DOS file decoding and the module's far hardware probe in ASM.
PolicyLoadSoundModuleFile:
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    mov dx, si
    call LoadSoundModuleFile
    push ax
    mov ds, word ptr cs:[MainDataSegment]
    pop ax
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    retf

PolicyInitializeSoundModule:
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push es
    mov ax, seg SoundModuleSlot
    mov es, ax
    call far ptr SoundModuleInitEntry
    push ax
    mov ds, word ptr cs:[MainDataSegment]
    pop ax
    pop es
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    retf

PolicySoundModuleSegment:
    mov ax, seg SoundModuleSlot
    retf

; Input DX is the original near-call filename offset. Preserve incoming SI separately because
; the checksum and codeword windows are derived from the caller's SI after the read loop.
; AX is the free-service result; outputs and skip-path flags match the old return path.
ChecksumFileOrAbort:
    push di
    push si
    mov di, si
    mov si, dx
    call PLATFORM_POLICY_CHECKSUM_FILE
    pop si
    pop di
    dec si
    dec si
    push ax
    mov ax, word ptr cs:[IntegrityBufferSegment]
    mov es, ax
    mov bx, si
    mov dx, word ptr es:[bx]
    xor dh, dh
    xor cx, cx
    cmp word ptr cs:[IntegritySkip], 1
    je @@checksumNoCodewords
    cmp word ptr ds:[FileNamePtr], offset IntegrityFileExe
    jne @@checksumNoCodewords
    pushf
    pop ax
    test ax, 0400h
    jnz @@checksumBackward
    mov di, offset Password
    add di, 010h
    jmp short @@checksumCompare
@@checksumBackward:
    sub si, 080h
    mov di, offset Password
    sub di, 010h
    jmp short @@checksumCompare
@@checksumNoCodewords:
    mov si, bx
    mov di, 042h
@@checksumCompare:
    pop ax
    push ax
    mov ax, word ptr cs:[IntegritySum]
    cmp ax, word ptr es:[bx]
    pop ax
    pushf
    cmp word ptr cs:[IntegritySkip], 1
    je @@checksumSkipped
    popf
    jmp short @@checksumReturn
@@checksumSkipped:
    pop cx
    mov cx, 0
@@checksumReturn:
    mov bx, word ptr ds:[FileHandle]
    ret

MAIN ends
end
