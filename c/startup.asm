; Preserve ProgramEntry's near entry; replace only StartupAfterOverrides' body.
locals
extrn STARTUP_AFTER_OVERRIDES:near
extrn InstallTimerVector08:near
extrn SetBestFitAllocStrategy:far
extrn VideoAdapter:word
extrn VideoBiosModeTable:byte
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public StartupAfterOverrides
StartupAfterOverrides:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call STARTUP_AFTER_OVERRIDES
    pop di
    pop si
    pop bp
    pop es
    ; ProgramEntry jumps here with no return address. The C path normally enters
    ; the non-returning session; retain a safe fall-through if it ever returns.
    jmp near ptr StartNewGame

; The old startup sequence explicitly saved DS around INT 08h installation.
public StartupInstallTimerVector08
StartupInstallTimerVector08:
    push ds
    call InstallTimerVector08
    pop ds
    ret

; The allocator's original public entry is far; give C's near-service adapter a
; thin named entry without changing its DOS allocation behavior.
public StartupSetBestFitAllocStrategy
StartupSetBestFitAllocStrategy:
    call far ptr SetBestFitAllocStrategy
    ret

; BIOS mode selection is hardware-facing. Keep XLAT's DS table lookup and INT 10h
; at this narrow boundary; VideoAdapter itself remains the existing CS word.
public StartupSetSelectedVideoMode
StartupSetSelectedVideoMode:
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, offset VideoBiosModeTable
    xlat
    int 010h
    ret

MAIN ends
end
