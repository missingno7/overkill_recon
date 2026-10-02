; C owns sound/capture/clear ordering; MAIN retains the adapter-specific page clear.
locals
extrn SCREEN_TRANSITION_WITH_SFX:near
extrn SCREEN_TRANSITION_AND_CLEAR:near
extrn ResetPageAndClearScreen:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public CollapseScreenWithSfx, CollapseScreenAndClear

; C receives the caller's live BP/ES pair in the two saved stack words and writes the
; final ResetPageAndClearScreen pair back.
CollapseScreenWithSfx:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SCREEN_TRANSITION_WITH_SFX
    mov bp, word ptr ss:[si]
    mov es, word ptr ss:[si + 2]
    pop di
    pop si
    add sp, 4
    ret

CollapseScreenAndClear:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SCREEN_TRANSITION_AND_CLEAR
    mov bp, word ptr ss:[si]
    mov es, word ptr ss:[si + 2]
    pop di
    pop si
    add sp, 4
    ret

MAIN ends
end
