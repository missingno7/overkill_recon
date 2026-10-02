; Pause's remaining ASM entry and the register adapter to the existing panel renderer.
locals
extrn PAUSE_GAME:near
extrn DrawPanelGraphic:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public PauseGame
; No caller consumes scratch registers or flags; DS and the stack are preserved.
PauseGame:
    call PAUSE_GAME
    ret

public DrawPanelAtPosition
; DX = packed row/column, SI = PANEL image. Keep C's frame pointer across the blitter,
; which uses BP for the image width. DrawPanelGraphic restores DS to the game state.
DrawPanelAtPosition:
    push bp
    mov ax, dx
    call DrawPanelGraphic
    pop bp
    ret

MAIN ends
end
