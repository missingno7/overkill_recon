; Remaining ASM presentation/calibration entries. SS = DS; the stack record
; carries the renderer's BP/ES across C without exposing C's own frame pointer.
locals
extrn SHOW_PAGE_LIST:near
extrn SHOW_HIGH_SCORE_TABLE:near
FAR0F7F segment para public 'CODE'
assume cs:FAR0F7F, ds:nothing, ss:nothing, es:nothing
public ShowPageList
ShowPageList:
    push es
    push bp
    push si
    push di
    mov si, ax
    mov di, sp
    add di, 4
    call SHOW_PAGE_LIST
    pop di
    pop si
    pop bp
    pop es
    retf
FAR0F7F ends
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public ShowHighScoreTable
ShowHighScoreTable:
    push es
    push bp
    push si
    mov si, sp
    add si, 2
    call SHOW_HIGH_SCORE_TABLE
    pop si
    pop bp
    pop es
    ret
MAIN ends
end
