; Register adapters for the C display routines.
locals
extrn DISPLAY_SET_HISCORE_RANK_COLOR:near
extrn DISPLAY_APPLY_CGA_LEVEL_PALETTE:near
extrn DISPLAY_APPLY_LEVEL_PALETTE:near
extrn DISPLAY_DRAW_SCORE:near
extrn DISPLAY_DRAW_LEVEL_NUMBER:near
extrn DISPLAY_DRAW_LIVES_ICONS:near
extrn DISPLAY_DRAW_HUD:near
extrn DrawOffsetFromScreenRow:near
extrn DrawPanelImageRow:near
extrn PanelImageOffsets:word
extrn SetDacColor6:near
extrn CgaSelectBrightPaletteNoBurst:near
extrn CgaSelectBrightPalette0:near
extrn CgaSelectBrightPalette1:near
extrn LevelIndex:word

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public ApplyLevelPalette, ApplyCgaLevelPalette, SetHiscoreRankColor
public DrawScore, DrawLevelNumber, DrawLivesIcons, DrawHud
public DisplayCgaPaletteDispatch, DisplayCallDacColor6
public DisplayDrawLivesRow

; Each C entry receives a pointer to the caller's BP/ES words on its stack.
SetHiscoreRankColor:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call DISPLAY_SET_HISCORE_RANK_COLOR
    pop di
    pop si
    pop bp
    pop es
    ret

ApplyCgaLevelPalette:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call DISPLAY_APPLY_CGA_LEVEL_PALETTE
    pop di
    pop si
    pop bp
    pop es
    ret

ApplyLevelPalette:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call DISPLAY_APPLY_LEVEL_PALETTE
    pop di
    pop si
    pop bp
    pop es
    ret

DrawScore:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call DISPLAY_DRAW_SCORE
    pop di
    pop si
    pop bp
    pop es
    ret

DrawLevelNumber:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call DISPLAY_DRAW_LEVEL_NUMBER
    pop di
    pop si
    pop bp
    pop es
    ret

DrawLivesIcons:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call DISPLAY_DRAW_LIVES_ICONS
    pop di
    pop si
    pop bp
    pop es
    ret

DrawHud:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call DISPLAY_DRAW_HUD
    pop di
    pop si
    pop bp
    pop es
    ret

; SI = DosRegisters*, DI = DAC RGB triple offset. This near MAIN adapter is entered
; through FarCallMainNearViaAX so CGAME can call SetDacColor6 without near-calling MAIN.
DisplayCallDacColor6:
    push bp
    push si
    mov bp, si
    mov es, word ptr ss:[bp + 2]
    mov bp, word ptr ss:[bp]
    mov si, di
    call SetDacColor6
    mov cx, bp
    mov dx, es
    pop si
    mov word ptr [si], cx
    mov word ptr [si + 2], dx
    pop bp
    ret

; SI -> six words: image, copies, running screen offset, BP, ES, compute-position.
; The first row computes the fixed HUD origin. The second starts at the first row's
; actual post-copy DI, matching the shared ASM row loop's two-column advancement.
DisplayDrawLivesRow:
    push bp
    push si
    mov bp, si
    cmp word ptr ss:[bp + 10], 0
    je @@positionReady
    mov al, 01Fh
    mov ah, 050h
    call DrawOffsetFromScreenRow
    mov word ptr ss:[bp + 4], di
@@positionReady:
    mov bx, word ptr ss:[bp]
    shl bx, 1
    mov si, word ptr cs:[bx + PanelImageOffsets]
    mov cx, word ptr ss:[bp + 2]
    mov di, word ptr ss:[bp + 4]
    mov ax, word ptr ss:[bp + 6]
    mov dx, word ptr ss:[bp + 8]
    mov es, dx
    mov bp, ax
    call DrawPanelImageRow
    pop si
    mov word ptr ss:[si + 4], di
    mov word ptr ss:[si + 6], bp
    mov word ptr ss:[si + 8], es
    pop bp
    ret

; Keep the oracle's raw 16-bit CS-table dispatch for invalid CGA level indexes. The C
; path handles entries 0..5 (including the original shift wrap) directly by service name.
DisplayCgaPaletteDispatch:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    jmp word ptr cs:[bx + DisplayCgaPaletteCases]
DisplayCgaPaletteCases label word
    dw offset CgaSelectBrightPaletteNoBurst, offset CgaSelectBrightPalette1
    dw offset CgaSelectBrightPalette0, offset CgaSelectBrightPalette1
    dw offset CgaSelectBrightPaletteNoBurst, offset CgaSelectBrightPalette0

MAIN ends
end
