_TEXT segment byte public 'CODE'
assume cs:_TEXT
extrn _upper_ascii:near,_dec_x:near
public _shim_upper,_shim_dec_x
_shim_upper proc near
    push bx
    push cx
    push dx
    push si
    push di
    push es
    push ds
    push ax
    call _upper_ascii
    pop bx
    mov ah,bh
    pop ds
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret
_shim_upper endp
_shim_dec_x proc near
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    push ds
    push ss
    push bp
    call _dec_x
    pop ax
    pop ax
    pop ds
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
_shim_dec_x endp
_TEXT ends
end
