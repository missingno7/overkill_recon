; Pixel-only leaves for title-logo staging and reveal. Traversal, SFX policy, key
; tests and retrace pacing live in title_reveal.c.
include HARDWARE.INC
include SYSTEM.INC
locals
extrn BlitPackedStride160:near
extrn BlitPackedToScreen:near
extrn BlueBitsImageOffsets:word
extrn BlueBitsSegment:word
extrn DrawOffsetFromScreenRow:near
extrn DrawOffsetFromWideRow:near
extrn MainDataSegment:word
extrn RevealCellOffset:word
extrn RevealCol:byte
extrn RevealRow:byte
extrn ScreenSegment:word
extrn VideoAdapter:word
extrn WorkspaceSegment:word

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public TitleDrawLogoPiece, TitleMergeRevealCell, TitleFlashRevealCell, TitleShowRevealCell

; SI = packed row/column, DI = image index. Blit one title piece to the wide
; staging page, always establishing the workspace ES that the old adapter supplied.
TitleDrawLogoPiece:
    push di
    mov ax, si
    call DrawOffsetFromWideRow
    add di, WIDE_PAGE_BYTES
    pop bx
    shl bx, 1
    add bx, offset BlueBitsImageOffsets
    mov si, word ptr cs:[bx]
    mov es, word ptr cs:[WorkspaceSegment]
    mov ds, word ptr cs:[BlueBitsSegment]
    call BlitPackedStride160
    mov ds, word ptr cs:[MainDataSegment]
    ret

; AX = changed boolean. Compare and merge the staged cell into the wide workspace.
; The adapter-selected code below preserves the original cell geometry and EGA ports.
TitleMergeRevealCell:
    mov ax, word ptr ds:[RevealCol]
    call DrawOffsetFromWideRow
    mov word ptr ds:[RevealCellOffset], di
    mov si, di
    add si, WIDE_PAGE_BYTES
    xor dl, dl
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + TitleMergeCellCases]
    even
TitleMergeCellCases label word
    dw offset TitleMergeCellCga, offset TitleMergeCellEga, offset TitleMergeCellTandy

TitleMergeCellCga:
    mov cx, 8
@@cgaRow:
    mov ax, word ptr es:[si]
    cmp ax, word ptr es:[di]
    je @@cgaNext
    mov dl, 1
    mov word ptr es:[di], ax
@@cgaNext:
    add di, CGA_WIDE_ROW_BYTES
    add si, CGA_WIDE_ROW_BYTES
    loop @@cgaRow
    jmp short TitleMergeCellDone

TitleMergeCellTandy:
    mov cx, 8
@@tandyRow:
    mov ax, word ptr es:[si]
    cmp ax, word ptr es:[di]
    je @@tandySecond
    mov dl, 1
    mov word ptr es:[di], ax
@@tandySecond:
    mov ax, word ptr es:[si + 2]
    cmp ax, word ptr es:[di + 2]
    je @@tandyNext
    mov dl, 1
    mov word ptr es:[di + 2], ax
@@tandyNext:
    add di, TANDY_WIDE_ROW_BYTES
    add si, TANDY_WIDE_ROW_BYTES
    loop @@tandyRow
    jmp short TitleMergeCellDone

TitleMergeCellEga:
    mov cx, 020h
@@egaRow:
    mov al, byte ptr es:[si]
    cmp al, byte ptr es:[di]
    je @@egaNext
    mov dl, 1
    mov byte ptr es:[di], al
@@egaNext:
    add di, EGA_WIDE_PLANE_ROW_BYTES
    add si, EGA_WIDE_PLANE_ROW_BYTES
    loop @@egaRow

TitleMergeCellDone:
    xor ax, ax
    mov al, dl
    ret

; Flash the 12th blue-bit image at the current packed screen row/column.
TitleFlashRevealCell:
    mov ax, word ptr ds:[RevealCol]
    call DrawOffsetFromScreenRow
    push di
    mov si, 012h
    shl si, 1
    add si, offset BlueBitsImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[BlueBitsSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    pop di
    ret

; Copy the already-merged cell from the wide workspace to the adapter's screen page.
TitleShowRevealCell:
    mov ax, word ptr ds:[RevealCol]
    call DrawOffsetFromScreenRow
    mov si, word ptr ds:[RevealCellOffset]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + TitleShowCellCases]
    even
TitleShowCellCases label word
    dw offset TitleShowCellCga, offset TitleShowCellEga, offset TitleShowCellTandy

TitleShowCellCga:
    mov cx, 8
@@cgaCopy:
    mov ax, word ptr ds:[si]
    mov word ptr es:[di], ax
    add si, CGA_WIDE_ROW_BYTES
    add di, CGA_BANK_BYTES
    test di, 2 * CGA_BANK_BYTES
    je @@cgaCopyNext
    add di, CGA_SCREEN_ROW_BYTES - 2 * CGA_BANK_BYTES
@@cgaCopyNext:
    loop @@cgaCopy
    jmp short TitleShowCellDone

TitleShowCellTandy:
    mov cx, 8
@@tandyCopy:
    mov ax, word ptr ds:[si]
    mov word ptr es:[di], ax
    mov ax, word ptr ds:[si + 2]
    mov word ptr es:[di + 2], ax
    add si, TANDY_WIDE_ROW_BYTES
    add di, TANDY_BANK_BYTES
    test di, 4 * TANDY_BANK_BYTES
    je @@tandyCopyNext
    add di, TANDY_SCREEN_ROW_BYTES - 4 * TANDY_BANK_BYTES
@@tandyCopyNext:
    loop @@tandyCopy
    jmp short TitleShowCellDone

TitleShowCellEga:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov cx, 8
@@egaCopy:
    mov al, 1
    out dx, al
    mov al, byte ptr ds:[si]
    mov byte ptr es:[di], al
    mov al, 2
    out dx, al
    mov al, byte ptr ds:[si + EGA_WIDE_PLANE_ROW_BYTES]
    mov byte ptr es:[di], al
    mov al, 4
    out dx, al
    mov al, byte ptr ds:[si + 2 * EGA_WIDE_PLANE_ROW_BYTES]
    mov byte ptr es:[di], al
    mov al, 8
    out dx, al
    mov al, byte ptr ds:[si + 3 * EGA_WIDE_PLANE_ROW_BYTES]
    mov byte ptr es:[di], al
    add di, EGA_SCREEN_ROW_BYTES
    add si, EGA_WIDE_ROW_BYTES
    loop @@egaCopy

TitleShowCellDone:
    mov ds, word ptr cs:[MainDataSegment]
    ret
MAIN ends

CGAME segment byte public 'CODE'
assume cs:CGAME
; The C routines above use this common far trampoline contract to keep the pixel
; leaves in MAIN while the orchestration remains in the single CGAME island.
CGAME ends
end
