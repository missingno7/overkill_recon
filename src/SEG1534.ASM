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
; INT 24h handler: fail the DOS call instead of asking Abort/Retry/Ignore. Drop DOS's
; frame and the saved registers, keep the caller's return, set its CF and resume at
; CriticalErrorResume.
CriticalErrorHandler:
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
    mov word ptr cs:[ErrorFlagsOrTarget], offset CriticalErrorResume
    push word ptr cs:[ErrorFlagsOrTarget]
    iret

; Far entry. Set AL=24h and DX=0006h; near-call SetInterruptVectorToCS then RETF. Requests DOS INT21h/AH25h
; vector24h -> current CS:0006. DS restored by helper; AX/DX and DOS-visible effects are not hidden. Remaining
; register/flag guarantees are conditional on DOS service behavior. Normal far return; not a complete contract
; for the nonlocal handler at0006.
InstallCriticalErrorVector:
    mov al, 024h
    mov dx, offset CriticalErrorHandler
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
; Continuation (1534:004E) the INT 24h handler IRETs to, running outside the error
; handler: make a harmless DOS call (get current drive) so DOS leaves its critical
; state, then return to the interrupted INT 21h caller with its flags (CF set).
CriticalErrorResume:
    pushf
    push ax
    mov ah, 019h
    int 021h
    pop ax
    popf
    jmp dword ptr cs:[ErrorReturnOffset]

SEG1534 ends
end