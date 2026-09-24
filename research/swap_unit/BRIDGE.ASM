.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
extrn _advance_history:near
public _launch,_main_segment,_bridge,_bridge_end
; Canonical PSP tail; fixed 512-byte prefix is retained by original DOS resize.
_launch:
    mov word ptr ds:[80h],0D03h
    mov word ptr ds:[82h],4102h
    mov byte ptr ds:[84h],0Dh
    db 0EAh
    dw 95C9h
_main_segment:
    dw 20h ; MZ relocation, main starts 20h paragraphs after this prefix
; Mechanical boundary adaptation only. Arithmetic flags are dead at caller.
_bridge proc far
    pushf
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push ds
    push es
    push word ptr ds:[0A360h]
    xor ax,ax
    mov al,byte ptr ds:[98BEh]
    push ax
    push ds
    mov ax,0A33Ah
    push ax
    call _advance_history
    add sp,8
    pop es
    pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    popf
    retf
_bridge endp
_bridge_end:
_TEXT ends
end
