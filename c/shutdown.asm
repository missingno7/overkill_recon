; Shutdown order moves to CGAME. Keep the actual interrupt/error ABI prologue,
; speaker port sequence, BIOS/DOS and low-memory operations in these fixed services.
locals
extrn SHUTDOWN_GAME:near
extrn MainDataSegment:word
extrn RestoreAllocStrategy:far
extrn ExitOrderScreen:word
extrn FileNotFoundMsgHead:word
extrn FileNotFoundMsgTail:word
include HARDWARE.INC
include SYSTEM.INC
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public ShutdownGame
ShutdownGame:
    mov ds, word ptr cs:[MainDataSegment]
    sti
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SHUTDOWN_GAME
    pop di
    pop si
    pop bp
    pop es
    ret

public ShutdownSetTextMode3
ShutdownSetTextMode3:
    mov ax, 3
    int 010h
    ret

; BP is a DS offset of a '$'-terminated string; INT 21h/AH=09h stays here.
public ShutdownPrintDosStringAtBP
ShutdownPrintDosStringAtBP:
    mov dx, bp
    mov ah, DOS_PRINT_STRING
    int 021h
    ret

; This is only the normal-exit presentation path. VRAM and BIOS queue writes are
; deliberately not expressed as ordinary C memory operations.
public ShutdownPresentExitOrderAndFlushKeys
ShutdownPresentExitOrderAndFlushKeys:
    mov dl, 0
    mov dh, 016h
    mov ah, 2
    mov bh, 0
    int 010h
    mov ax, 0B800h
    mov es, ax
    xor di, di
    mov si, offset ExitOrderScreen
    mov cx, 07D0h
    rep movsw
    cli
    xor ax, ax
    mov es, ax
    mov al, byte ptr es:[041Ah]
    mov byte ptr es:[041Ch], al
    sti
    ret

public ShutdownRestoreAllocStrategy
ShutdownRestoreAllocStrategy:
    call far ptr RestoreAllocStrategy
    ret

; Production DOS INT 21h/4C00h never returns. A bounded test may stub this entry
; to return so the test harness can observe the preceding shutdown sequence.
public ShutdownExitToDos
ShutdownExitToDos:
    mov ax, 04C00h
    int 021h
    ret

MAIN ends
end
