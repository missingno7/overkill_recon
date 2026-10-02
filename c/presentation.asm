; New presentation adapters for the C orchestration. The renderers and
; resource decoder themselves remain in the frozen oracle.
locals
extrn FarCallMainNearViaAX:far
extrn DrawOffsetFromScreenRow:near
extrn BlitPackedToScreen:near
extrn MainDataSegment:word
extrn PanelSegment:word
extrn PanelImageOffsets:word
extrn BonusIntroItems:byte
extrn WorkspaceSegment:word

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public PresentationDrawWorkspaceBackground, PresentationDrawBonusPanel, PresentationDrawImage
PresentationDrawWorkspaceBackground:
    mov ds, word ptr cs:[WorkspaceSegment]
    mov si, 08000h
    xor di, di
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret

; SI = BonusIntroItems index (0..3). Render its panel image; C then prints the
; corresponding caption through the existing BP-input text service.
PresentationDrawBonusPanel:
    push bx
    mov bx, si
    shl bx, 1
    shl bx, 1
    xor ax, ax
    mov ah, byte ptr ds:[bx + BonusIntroItems]
    push bx
    call DrawOffsetFromScreenRow
    pop bx
    xor ax, ax
    mov al, byte ptr ds:[bx + BonusIntroItems + 1]
    shl ax, 1
    mov si, ax
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    push bx
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    pop bx
    pop bx
    ret

; CX = row/column, SI = packed-image offset, DI = source segment.
; BP and ES are inherited/returned through the C register-pair adapter. Pixel
; bytes remain in the adapter-specific BlitPackedToScreen implementation.
PresentationDrawImage:
    push di
    mov ax, cx
    call DrawOffsetFromScreenRow
    pop dx
    mov ds, dx
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
MAIN ends

CGAME segment byte public 'CODE'
assume cs:CGAME
public PRESENTATION_CALL_SI_REGISTERS
; AX = MAIN service, CX = service SI, SI/DI = inherited BP/ES.
; Return DX:AX = resulting ES:BP, while restoring the C caller's BP.
PRESENTATION_CALL_SI_REGISTERS:
    push bp
    mov bp, si
    mov si, cx
    mov es, di
    call far ptr FarCallMainNearViaAX
    mov ax, bp
    mov dx, es
    pop bp
    ret

public PRESENTATION_CALL_IMAGE_REGISTERS
; AX = MAIN service, CX/SI/DI = position/image/source, BX/DX = inherited BP/ES.
; Return DX:AX = resulting ES:BP, while restoring the C caller's BP.
PRESENTATION_CALL_IMAGE_REGISTERS:
    push bp
    mov bp, bx
    mov es, dx
    call far ptr FarCallMainNearViaAX
    mov ax, bp
    mov dx, es
    pop bp
    ret
CGAME ends
end
