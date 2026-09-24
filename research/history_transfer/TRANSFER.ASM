.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
extrn _store_apply:near
public _transfer_bridge,_transfer_bridge_end
; Caller9BE2 gate CALL FAR/NOP continues at9BE8, where CMP kills arith flags.
; Saved register slots adapt semantic progress; the C body owns all copies/tests.
_transfer_bridge proc far
    pushf
    push bp
    mov bp,sp
    push ax                     ; BP-2
    push bx                     ; BP-4
    push cx                     ; BP-6
    push dx                     ; BP-8
    push si                     ; BP-10
    push di                     ; BP-12
    push ds                     ; BP-14
    push es                     ; BP-16, replace with original output segment
    sub sp,10                   ; progress at BP-26: five words
    mov ax,ss:[bp+6]            ; main CS from far return address
    mov es,ax
    mov ax,es:[9596h]           ; original StorePositionHistory output ES
    mov ss:[bp-16],ax
    push ss
    lea ax,[bp-26]
    push ax                     ; progress far pointer
    mov ax,0A962h
    push ax                     ; selections near pointer
    mov ax,0A33Ah
    push ax                     ; cursors near pointer
    push ss
    push word ptr ss:[bp]       ; original SS:BP source record
    push word ptr ss:[bp-16]
    push word ptr ds:[0A33Ah]   ; captured destination ES:DI, before any store
    call _store_apply
    add sp,16
    mov ax,ss:[bp-26]
    mov ss:[bp-2],ax            ; last transferred X -> AX
    mov ax,ss:[bp-24]
    mov ss:[bp-12],ax           ; write end -> DI
    cmp word ptr ss:[bp-18],0
    je no_delayed_transfer
    mov ax,ss:[bp-22]
    mov ss:[bp-4],ax            ; last record offset -> BX
    mov ax,ss:[bp-20]
    mov ss:[bp-10],ax           ; last read end -> SI
no_delayed_transfer:
    add sp,10
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    popf
    retf
_transfer_bridge endp
_transfer_bridge_end:
_TEXT ends
end
