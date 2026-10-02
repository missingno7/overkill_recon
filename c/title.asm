; Title control's remaining ASM entries and the renderer's implicit ES input.
locals
extrn RUN_ATTRACT_SEQUENCE:near
extrn PLAY_TITLE_ANIMATION:near
extrn DELAY_FRAMES_UNTIL_KEY_OR_PRIMARY:near
extrn SHOW_WIN_SCREEN_AND_WAIT_PRIMARY:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public RunAttractSequence, PlayTitleAnimation, DelayFramesUntilKeyOrPrimary
public ShowWinScreenAndWaitPrimary
RunAttractSequence:
    call RUN_ATTRACT_SEQUENCE
    ret
PlayTitleAnimation:
    call PLAY_TITLE_ANIMATION
    ret
DelayFramesUntilKeyOrPrimary:
    push si
    mov si, cx
    call DELAY_FRAMES_UNTIL_KEY_OR_PRIMARY
    mov cx, ax
    pop si
    ret
ShowWinScreenAndWaitPrimary:
    call SHOW_WIN_SCREEN_AND_WAIT_PRIMARY
    ret

MAIN ends
end
