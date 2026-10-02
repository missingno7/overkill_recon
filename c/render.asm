; MAIN entries and CGAME pixel-only adapters for the render C region.
include HARDWARE.INC
include SYSTEM.INC
include RECORDS.INC
locals
extrn FarCallMainNearViaAX:far
extrn BlitPackedToScreen:near
extrn FlipEgaDrawPage:near
extrn MainDataSegment:word
extrn WorkspaceSegment:word
extrn ScreenSegment:word

extrn RENDER_RECORD_WORKSPACE_OFFSET:near
extrn RENDER_SAVE_RECORD_BACKGROUND:near
extrn RENDER_RESTORE_RECORD_BACKGROUND:near
extrn RENDER_DRAW_RECORD_SPRITE:near
extrn RENDER_DRAW_RECORDS_TO_WORKSPACE:near
extrn RENDER_RESTORE_RECORD_BACKGROUNDS:near
extrn RENDER_DRAW_STARS:near
extrn RENDER_ERASE_STARS:near
extrn RENDER_DRAW_UPGRADE_SLOTS:near
extrn RENDER_DRAW_ENERGY_GAUGE:near
extrn RENDER_DRAW_FUEL_GAUGE:near

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public RecordWorkspaceOffset, SaveRecordBackground, RestoreRecordBackground
public DrawRecordSprite, DrawRecordsToWorkspace, RestoreRecordBackgrounds
public DrawStars, EraseStars, DrawUpgradeSlots, DrawEnergyGauge, DrawFuelGauge

; BP is the record. The C owner returns AX and keeps the visible-only field writes.
RecordWorkspaceOffset:
    push si
    mov si, bp
    call RENDER_RECORD_WORKSPACE_OFFSET
    pop si
    ret

; Copy services leave DS at the game's state segment. A clipped save leaves ES untouched;
; visible saves set ES to MainDataSegment. Restore always leaves ES at WorkspaceSegment.
SaveRecordBackground:
    push si
    mov si, bp
    call RENDER_SAVE_RECORD_BACKGROUND
    cmp word ptr ss:[bp + REC_WORK_OFS], 0FFFFh
    jne @@savedVisible
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@saveDone
    cmp word ptr ss:[bp + REC_WORK_OFS_LOWER], 0FFFFh
    je @@saveDone
@@savedVisible:
    mov ax, word ptr cs:[MainDataSegment]
    mov es, ax
@@saveDone:
    pop si
    ret
RestoreRecordBackground:
    push si
    mov si, bp
    call RENDER_RESTORE_RECORD_BACKGROUND
    pop si
    mov ax, word ptr cs:[WorkspaceSegment]
    mov es, ax
    ret

; AX from C is the BP value the selected original sprite leaf would leave.
DrawRecordSprite:
    push si
    push bp
    mov si, bp
    call RENDER_DRAW_RECORD_SPRITE
    mov bx, ax
    pop bp
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    je @@checkLowerDrawn
    cmp word ptr ss:[bp + REC_WORK_OFS], 0FFFFh
    je @@spriteResult
    jmp short @@spriteVisible
@@checkLowerDrawn:
    cmp word ptr ss:[bp + REC_WORK_OFS], 0FFFFh
    jne @@spriteVisible
    cmp word ptr ss:[bp + REC_WORK_OFS_LOWER], 0FFFFh
    je @@spriteResult
@@spriteVisible:
    mov ax, word ptr cs:[WorkspaceSegment]
    mov es, ax
@@spriteResult:
    mov bp, bx
    pop si
    ret

; These entries preserve the historical DOS-service BP/ES pair.
DrawRecordsToWorkspace:
    call RENDER_DRAW_RECORDS_TO_WORKSPACE
    mov bp, ax
    mov ax, word ptr cs:[WorkspaceSegment]
    mov es, ax
    ret
RestoreRecordBackgrounds:
    call RENDER_RESTORE_RECORD_BACKGROUNDS
    mov bp, ax
    mov ax, word ptr cs:[WorkspaceSegment]
    mov es, ax
    ret

; The original star painter sets ES to the workspace. No caller consumes its internal
; PlotStar helper BP value; both C routines preserve the incoming BP.
DrawStars:
    call RENDER_DRAW_STARS
    mov ax, word ptr cs:[WorkspaceSegment]
    mov es, ax
    ret
EraseStars:
    call RENDER_ERASE_STARS
    mov ax, word ptr cs:[WorkspaceSegment]
    mov es, ax
    ret

; Panel-result C functions return DX:AX = ES:SI. These public leaves preserve BP.
DrawUpgradeSlots:
    push bp
    call RENDER_DRAW_UPGRADE_SLOTS
    mov si, ax
    mov es, dx
    pop bp
    ret
DrawEnergyGauge:
    push bp
    call RENDER_DRAW_ENERGY_GAUGE
    mov si, ax
    mov es, dx
    pop bp
    ret
DrawFuelGauge:
    push bp
    call RENDER_DRAW_FUEL_GAUGE
    mov di, ax
    mov es, dx
    pop bp
    ret
MAIN ends

; C's request records are stack locals (DS = SS = the original game state segment).
; These helpers contain pixel/memory-transfer operations only; game state decisions and
; all Record, star-list, FuelGaugeOffset, SfxRequest and EnergyCells writes are in C.
CGAME segment byte public 'CODE'
assume cs:CGAME
public RENDER_PLATFORM_COPY_ROWS, RENDER_PLATFORM_DRAW_SPRITE
public RENDER_PLATFORM_BLIT_PANEL, RENDER_PLATFORM_STAR_IS_CLEAR
public RENDER_PLATFORM_PLOT_STAR, RENDER_PLATFORM_ERASE_STAR
public RENDER_PLATFORM_DRAW_FUEL_BARS

; RenderCopyRequest word offsets: workspace seg, state seg, workspace offset, save
; offset, width, workspace row bytes, rows, planes, to_workspace.
RENDER_PLATFORM_COPY_ROWS:
    push bp
    mov bp, si
    cmp word ptr ss:[bp + 16], 0
    jne @@copyToWorkspace
    mov ax, word ptr ss:[bp + 0]
    mov ds, ax
    mov ax, word ptr ss:[bp + 2]
    mov es, ax
    mov si, word ptr ss:[bp + 4]
    mov di, word ptr ss:[bp + 6]
    jmp short @@copySegmentsReady
@@copyToWorkspace:
    mov ax, word ptr ss:[bp + 2]
    mov ds, ax
    mov ax, word ptr ss:[bp + 0]
    mov es, ax
    mov si, word ptr ss:[bp + 6]
    mov di, word ptr ss:[bp + 4]
@@copySegmentsReady:
    mov ax, word ptr ss:[bp + 12]
    push ax
@@copyNextRow:
    mov ax, word ptr ss:[bp + 14]
    push ax
@@copyNextPlane:
    mov cx, word ptr ss:[bp + 8]
@@copyWords:
    cmp cx, 2
    jb @@copyOddByte
    movsw
    sub cx, 2
    jmp short @@copyWords
@@copyOddByte:
    or cx, cx
    jz @@copyPlaneDone
    movsb
@@copyPlaneDone:
    pop ax
    dec ax
    cmp word ptr ss:[bp + 14], 1
    je @@copyCheckMorePlanes
    mov dx, ax
    mov ax, EGA_PLANE_ROW_BYTES
    sub ax, word ptr ss:[bp + 8]
    cmp word ptr ss:[bp + 16], 0
    jne @@copyPlaneToWorkspace
    add si, ax
    mov ax, dx
    jmp short @@copyCheckMorePlanes
@@copyPlaneToWorkspace:
    add di, ax
    mov ax, dx
@@copyCheckMorePlanes:
    or ax, ax
    jz @@copyRowDone
    push ax
    jmp short @@copyNextPlane
@@copyRowDone:
    cmp word ptr ss:[bp + 14], 1
    jne @@copyAdvanceRow
    mov ax, word ptr ss:[bp + 10]
    sub ax, word ptr ss:[bp + 8]
    cmp word ptr ss:[bp + 16], 0
    jne @@copyRowToWorkspace
    add si, ax
    jmp short @@copyAdvanceRow
@@copyRowToWorkspace:
    add di, ax
@@copyAdvanceRow:
    pop ax
    dec ax
    jz @@copyDone
    push ax
    jmp near ptr @@copyNextRow
@@copyDone:
    mov ax, word ptr ss:[bp + 2]
    mov ds, ax
    pop bp
    retf

; RenderSpriteRequest: selected near blitter, source segment/offset, workspace segment/
; offset, row count. The original trampoline preserves the adapter's near entry point.
RENDER_PLATFORM_DRAW_SPRITE:
    push bp
    mov bp, si
    mov bx, word ptr ss:[bp + 0]
    mov dx, word ptr ss:[bp + 2]
    mov si, word ptr ss:[bp + 4]
    mov ds, dx
    mov ax, word ptr ss:[bp + 6]
    mov es, ax
    mov di, word ptr ss:[bp + 8]
    mov bp, word ptr ss:[bp + 10]
    mov cx, bp
    mov ax, bx
    call far ptr FarCallMainNearViaAX
    mov ax, bp
    pop bp
    retf

; RenderPanelRequest: packed source offset, screen byte offset, source segment and state
; segment. Return the SI/ES pair left by the real packed panel blitter.
RENDER_PLATFORM_BLIT_PANEL:
    push bp
    mov bp, si
    mov si, word ptr ss:[bp + 0]
    mov di, word ptr ss:[bp + 2]
    mov ax, word ptr ss:[bp + 4]
    mov ds, ax
    mov ax, offset BlitPackedToScreen
    ; The packed pixel routine deliberately clobbers BP. Keep the descriptor base
    ; separately so the adapter can restore DS without depending on that leaf's BP.
    push bp
    call far ptr FarCallMainNearViaAX
    pop bp
    mov ax, si
    mov dx, es
    push ax
    mov ax, word ptr ss:[bp + 6]
    mov ds, ax
    pop ax
    pop bp
    retf

; RenderStarRequest: workspace segment/offset, adapter, mask byte, plane count.
RENDER_PLATFORM_STAR_IS_CLEAR:
    push bp
    mov bp, si
    mov ax, word ptr ss:[bp + 0]
    mov es, ax
    mov di, word ptr ss:[bp + 2]
    cmp byte ptr es:[di], 0
    jne @@starBlocked
    cmp word ptr ss:[bp + 4], VIDEO_EGA
    jne @@starClear
    cmp byte ptr es:[di + EGA_PLANE_ROW_BYTES], 0
    jne @@starBlocked
    cmp byte ptr es:[di + 2 * EGA_PLANE_ROW_BYTES], 0
    jne @@starBlocked
    cmp byte ptr es:[di + 3 * EGA_PLANE_ROW_BYTES], 0
    jne @@starBlocked
@@starClear:
    mov ax, 1
    jmp short @@starClearReturn
@@starBlocked:
    xor ax, ax
@@starClearReturn:
    pop bp
    retf

RENDER_PLATFORM_PLOT_STAR:
    push bp
    mov bp, si
    mov ax, word ptr ss:[bp + 0]
    mov es, ax
    mov di, word ptr ss:[bp + 2]
    mov al, byte ptr ss:[bp + 6]
    cmp word ptr ss:[bp + 8], 4
    jne @@plotThree
    mov byte ptr es:[di + 3 * EGA_PLANE_ROW_BYTES], al
@@plotThree:
    cmp word ptr ss:[bp + 8], 1
    je @@plotBase
    mov byte ptr es:[di + 2 * EGA_PLANE_ROW_BYTES], al
    mov byte ptr es:[di + EGA_PLANE_ROW_BYTES], al
@@plotBase:
    mov byte ptr es:[di], al
    pop bp
    retf

RENDER_PLATFORM_ERASE_STAR:
    push bp
    mov bp, si
    mov ax, word ptr ss:[bp + 0]
    mov es, ax
    mov di, word ptr ss:[bp + 2]
    cmp word ptr ss:[bp + 4], VIDEO_EGA
    jne @@eraseBase
    mov byte ptr es:[di + 3 * EGA_PLANE_ROW_BYTES], 0
    mov byte ptr es:[di + 2 * EGA_PLANE_ROW_BYTES], 0
    mov byte ptr es:[di + EGA_PLANE_ROW_BYTES], 0
@@eraseBase:
    mov byte ptr es:[di], 0
    pop bp
    retf

; Pixel-only fuel raster leaf. The two counts and starting DI come from C's request;
; adapter-specific bank addressing and EGA sequencer traffic remain here unchanged.
RENDER_PLATFORM_DRAW_FUEL_BARS:
    push bp
    mov bp, si
    mov di, word ptr ss:[bp + 2]
    mov cx, word ptr ss:[bp + 6]
    or cx, cx
    jnz @@fuelFull
    jmp near ptr @@fuelEmptyStart
@@fuelFull:
    push cx
    mov es, word ptr ss:[bp + 0]
    cmp word ptr ss:[bp + 4], VIDEO_CGA
    je @@fuelCgaFull
    cmp word ptr ss:[bp + 4], VIDEO_EGA
    je @@fuelEgaFull
    mov word ptr es:[di], 0FFCEh
    mov word ptr es:[di + 2], 0C4EEh
    test di, 3 * TANDY_BANK_BYTES
    jne @@fuelTandyFullRow2
    add di, 4 * TANDY_BANK_BYTES - TANDY_SCREEN_ROW_BYTES
@@fuelTandyFullRow2:
    sub di, TANDY_BANK_BYTES
    test di, 3 * TANDY_BANK_BYTES
    jne @@fuelTandyFullRow3
    add di, 4 * TANDY_BANK_BYTES - TANDY_SCREEN_ROW_BYTES
@@fuelTandyFullRow3:
    sub di, TANDY_BANK_BYTES
    jmp short @@fuelNextFull
@@fuelEgaFull:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 1
    out dx, al
    mov byte ptr es:[di], 030h
    mov al, 2
    out dx, al
    mov byte ptr es:[di], 07Ch
    mov al, 4
    out dx, al
    mov byte ptr es:[di], 0FFh
    mov al, 8
    out dx, al
    mov byte ptr es:[di], 0FEh
    sub di, 2 * EGA_SCREEN_ROW_BYTES
    jmp short @@fuelNextFull
@@fuelCgaFull:
    mov word ptr es:[di], 0A02Fh
    mov ax, CGA_BANK_BYTES
    test di, ax
    je @@fuelCgaFullRow2
    mov ax, CGA_SCREEN_ROW_BYTES - CGA_BANK_BYTES
@@fuelCgaFullRow2:
    sub di, ax
    mov ax, CGA_BANK_BYTES
    test di, ax
    je @@fuelCgaFullRow3
    mov ax, CGA_SCREEN_ROW_BYTES - CGA_BANK_BYTES
@@fuelCgaFullRow3:
    sub di, ax
@@fuelNextFull:
    pop cx
    dec cx
    jz @@fuelEmptyStart
    jmp near ptr @@fuelFull
@@fuelEmptyStart:
    mov cx, word ptr ss:[bp + 8]
    or cx, cx
    jnz @@fuelEmpty
    jmp near ptr @@fuelBarsDone
@@fuelEmpty:
    push cx
    mov es, word ptr ss:[bp + 0]
    cmp word ptr ss:[bp + 4], VIDEO_CGA
    je @@fuelCgaEmpty
    cmp word ptr ss:[bp + 4], VIDEO_EGA
    je @@fuelEgaEmpty
    mov word ptr es:[di], 0
    mov word ptr es:[di + 2], 0
    test di, 3 * TANDY_BANK_BYTES
    jne @@fuelTandyEmptyRow2
    add di, 4 * TANDY_BANK_BYTES - TANDY_SCREEN_ROW_BYTES
@@fuelTandyEmptyRow2:
    sub di, TANDY_BANK_BYTES
    test di, 3 * TANDY_BANK_BYTES
    jne @@fuelTandyEmptyRow3
    add di, 4 * TANDY_BANK_BYTES - TANDY_SCREEN_ROW_BYTES
@@fuelTandyEmptyRow3:
    sub di, TANDY_BANK_BYTES
    jmp short @@fuelNextEmpty
@@fuelEgaEmpty:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    mov byte ptr es:[di], 0
    sub di, EGA_SCREEN_ROW_BYTES
    sub di, EGA_SCREEN_ROW_BYTES
    jmp short @@fuelNextEmpty
@@fuelCgaEmpty:
    mov word ptr es:[di], 0
    mov ax, CGA_BANK_BYTES
    test di, ax
    je @@fuelCgaEmptyRow2
    mov ax, CGA_SCREEN_ROW_BYTES - CGA_BANK_BYTES
@@fuelCgaEmptyRow2:
    sub di, ax
    mov ax, CGA_BANK_BYTES
    test di, ax
    je @@fuelCgaEmptyRow3
    mov ax, CGA_SCREEN_ROW_BYTES - CGA_BANK_BYTES
@@fuelCgaEmptyRow3:
    sub di, ax
@@fuelNextEmpty:
    pop cx
    dec cx
    jz @@fuelBarsDone
    jmp near ptr @@fuelEmpty
@@fuelBarsDone:
    cmp word ptr ss:[bp + 4], VIDEO_EGA
    jne @@fuelReturn
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
@@fuelReturn:
    mov ax, di
    pop bp
    mov dx, es
    retf
CGAME ends
end
