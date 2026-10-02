locals
extrn FarCallMainNearViaAX:far
CGAME segment byte public 'CODE'
assume cs:CGAME
public DOS_CALL_REGISTERS
; AX = MAIN service, SI/DI = inherited BP/ES. Return DX:AX = resulting ES:BP.
DOS_CALL_REGISTERS:
    push bp
    mov bp, si
    mov es, di
    call far ptr FarCallMainNearViaAX
    mov ax, bp
    mov dx, es
    pop bp
    ret
CGAME ends
end
