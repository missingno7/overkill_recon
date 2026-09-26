; Everything in segment frame SEG1534; modern file boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
SEG1534 segment para public 'CODE'
assume cs:SEG1534,ds:nothing,ss:nothing,es:nothing
public InstallCriticalErrorVector
; Frame1534 private saved return words; not evidence of an original OBJ.
; Critical-error handler scratch: six bytes the INT 24h handler pops into and reuses.
ErrorReturnOffset dw 0              ; saved by the handler
ErrorReturnSegment dw 0
ErrorFlagsOrTarget dw 0             ; flags, later the IRET target offset
    add sp, 6
    pop ax
    mov ax, di
    pop bx
    pop cx
    pop dx
    pop si
    pop di
    pop bp
    pop ds
    pop es
    pop word ptr cs:[ErrorReturnOffset]
    pop word ptr cs:[ErrorReturnSegment]
    pop word ptr cs:[ErrorFlagsOrTarget]
    or word ptr cs:[ErrorFlagsOrTarget], 1
    push word ptr cs:[ErrorFlagsOrTarget]
    push cs
    mov word ptr cs:[ErrorFlagsOrTarget], 04Eh
    push word ptr cs:[ErrorFlagsOrTarget]
    iret

; Far entry. Set AL=24h and DX=0006h; near-call SetInterruptVectorToCS then RETF. Requests DOS INT21h/AH25h
; vector24h -> current CS:0006. DS restored by helper; AX/DX and DOS-visible effects are not hidden. Remaining
; register/flag guarantees are conditional on DOS service behavior. Normal far return; not a complete contract
; for the nonlocal handler at0006.
InstallCriticalErrorVector:
    mov al, 024h
    mov dx, 6
    call SetInterruptVectorToCS
    retf

; Near leaf. Save DS; set DS=CS, AH=25h, invoke INT21h with caller AL(vector) and DX(handler offset); restore DS
; and RET. No algorithm beyond DOS vector installation request. Register/flag effects of DOS are passed through
; except restored DS. Valid DOS service and stack required; IF/DF not modified by surrounding instructions.
SetInterruptVectorToCS:
    push ds
    push cs
    pop ds
    mov ah, DOS_SET_VECTOR
    int 021h
    pop ds
    ret
; Handler1534:0006 constructs an IRET to this1534:004E continuation.
; These UNKNOWN bytes must not be treated as inter-frame padding; the
; nonlocal DOS stack contract and eventual far handoff still need review.
; UNKNOWN: not yet classified as code or data
    db 09Ch,050h,0B4h,019h,0CDh,021h,058h,09Dh,02Eh,0FFh,02Eh,00h,00h,00h,00h,00h
    db 00h,00h

SEG1534 ends
end