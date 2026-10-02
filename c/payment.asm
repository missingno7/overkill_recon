; Payment-text entry and state-scroll ABI bridges. Pixel/text rendering and ports stay in
; the retained MAIN leaves; the old uncalled midflow labels have no remaining ASM callers.
locals
extrn PAYMENT_SHOW_TEXT:near
extrn PAYMENT_SCROLL_UP:near
extrn PAYMENT_SCROLL_DOWN:near
include HARDWARE.INC
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public ShowPaymentText, PaymentTextScrollUp, PaymentTextScrollDown
ShowPaymentText:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call PAYMENT_SHOW_TEXT
    mov bp, word ptr ss:[si]
    mov es, word ptr ss:[si + 2]
    pop di
    pop si
    add sp, 4
    ret

; The legacy scroll leaves expose only the live AX/CX pair to no surviving ASM caller;
; retaining their entries keeps the independently callable state transitions testable.
PaymentTextScrollUp:
    push si
    push cx
    push ax
    mov si, sp
    call PAYMENT_SCROLL_UP
    mov ax, word ptr ss:[si]
    mov cx, word ptr ss:[si + 2]
    add sp, 4
    pop si
    ret

PaymentTextScrollDown:
    push si
    push cx
    push ax
    mov si, sp
    call PAYMENT_SCROLL_DOWN
    mov ax, word ptr ss:[si]
    mov cx, word ptr ss:[si + 2]
    add sp, 4
    pop si
    ret

MAIN ends

; Keep the adjacent BIOS calls together so C cannot disturb AL between mode set and
; cursor-shape selection (the original cursor call inherits AL from INT 10h/AH=0).
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public PaymentSetTextModeAndHideCursor
PaymentSetTextModeAndHideCursor:
    mov ax, 3
    int 010h
    mov cx, 2000h
    mov ah, 1
    int 010h
    ret
MAIN ends
end
