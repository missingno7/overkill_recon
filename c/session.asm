; Startup's one remaining session entry; the C driver never returns or recurses.
locals
extrn RUN_GAME_SESSION:near
extrn DrawOffsetFromScreenRow:near
extrn BlitPackedToScreen:near
extrn MainDataSegment:word
extrn PanelSegment:word
extrn PanelImageOffsets:word
include GAME.INC
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public StartNewGame, SessionDrawQuitPrompt
StartNewGame:
    push si
    push di
    xor si, si
    mov di, bp
    call RUN_GAME_SESSION
    pop di
    pop si
    ret

; Quit-prompt presentation; control and the answer mailbox belong to C.
SessionDrawQuitPrompt:
    mov ax, 05C04h
    call DrawOffsetFromScreenRow
    mov si, PANEL_QUIT_PROMPT * 2
    mov si, word ptr cs:[si + PanelImageOffsets]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
MAIN ends
end
