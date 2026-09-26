; ASM -> C entry stubs of the movement region (c/movement.c) for the DOS hybrid. Each stub keeps an oracle label and its register
; contract (see the oracle routine's comment) and calls the C function that owns it
; (c/game.h convention: SI, DI in; AX out; all else preserved). Only labels the remaining
; ASM still reaches need a stub; calls between C functions do not pass through here.
locals
extrn MOVE_IN_DIRECTION:near
extrn STEER_TOWARD_TARGET:near
extrn STEER_TO_SAVED:near
extrn SET_DELTA_TOWARD:near
extrn AIM_AT_PLAYER:near
extrn STEP_ALONG_DELTA:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

; c/movement.c ----------------------------------------------------------------------

public MoveInDirection2, MoveInDirection3, MoveInDirection4, MoveInDirection8
; BP = record: moves N px along REC_DIRECTION; preserves AX like the oracle (which clobbers
; only BX; this keeps BX too).
MoveInDirection2:
    push di
    mov di, 2
    jmp short MoveInDirectionN
MoveInDirection3:
    push di
    mov di, 3
    jmp short MoveInDirectionN
MoveInDirection4:
    push di
    mov di, 4
    jmp short MoveInDirectionN
MoveInDirection8:
    push di
    mov di, 8
MoveInDirectionN:
    push ax
    push si
    mov si, bp
    call MOVE_IN_DIRECTION
    pop si
    pop ax
    pop di
    ret

public SteerTowardTarget, StepAlongDelta, SteerToSaved
; BP = record; clobbers AX (the oracle: AX, BX).
SteerTowardTarget:
    push si
    mov si, bp
    call STEER_TOWARD_TARGET
    pop si
    ret
StepAlongDelta:
    push si
    mov si, bp
    call STEP_ALONG_DELTA
    pop si
    ret
; BP = record; NZ = SteerArrived (the oracle's `cmp SteerArrived, 0`, same flags).
SteerToSaved:
    push si
    mov si, bp
    call STEER_TO_SAVED
    pop si
    cmp ax, 0
    ret

public SetDeltaToward, AimAtPlayer
; BP = self, BX = target; clobbers AX (the oracle: AX, CX, DX).
SetDeltaToward:
    push si
    push di
    mov si, bp
    mov di, bx
    call SET_DELTA_TOWARD
    pop di
    pop si
    ret
; BX = record, kept; clobbers AX (the oracle: AX, CX).
AimAtPlayer:
    push si
    mov si, bx
    call AIM_AT_PLAYER
    pop si
    ret

MAIN ends
end
