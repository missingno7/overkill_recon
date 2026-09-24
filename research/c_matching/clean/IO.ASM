_TEXT segment word public 'CODE'
assume cs:_TEXT
public _io_read,_io_write
_io_read proc near
    push bp
    mov bp,sp
    mov dx,[bp+4]
    in al,dx
    pop bp
    ret
_io_read endp
_io_write proc near
    push bp
    mov bp,sp
    mov dx,[bp+4]
    mov al,[bp+6]
    out dx,al
    pop bp
    ret
_io_write endp
_TEXT ends
end
