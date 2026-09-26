; ASM -> C entry stubs of the shot-hit region (c/hits.c) for the DOS hybrid. Each stub keeps
; an oracle label and its register contract (see the oracle routine's comment) and calls
; the C function that owns it (c/game.h convention: SI, DI in; AX out; all else preserved).
; Only labels the remaining ASM still reaches need a stub.
locals
extrn PLAYER_SHOTS_HIT_RECORD:near
extrn SMART_BOMB_RECORD:near
extrn DESTROY_RECORD:near
extrn RELEASE_ENCOUNTER_MEMBER:near
extrn CLAMP_RECORD_X:near
extrn INIT_PICKUP_RECORD:near
extrn TYPE36_FALL_THEN_BURST:near
extrn TYPE22_DESCEND_THEN_BURST:near
extrn ScrollRecordThenFinish:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public PlayerShotsHitRecord, SmartBombRecord, DestroyRecord, ReleaseEncounterMember
; BP = record; clobbers AX (the oracle clobbers more; its callers keep only BP).
PlayerShotsHitRecord:
    push si
    mov si, bp
    call PLAYER_SHOTS_HIT_RECORD
    pop si
    ret
SmartBombRecord:
    push si
    mov si, bp
    call SMART_BOMB_RECORD
    pop si
    ret
DestroyRecord:
    push si
    mov si, bp
    call DESTROY_RECORD
    pop si
    ret
ReleaseEncounterMember:
    push si
    mov si, bp
    call RELEASE_ENCOUNTER_MEMBER
    pop si
    ret

public ClampRecordX
; BP = record; preserves every register, like the oracle.
ClampRecordX:
    push ax
    push si
    mov si, bp
    call CLAMP_RECORD_X
    pop si
    pop ax
    ret

public InitPickupRecord
; BX = record; returns SI = its sprite (DropKind + 46h), as the oracle leaves it: through
; SpawnCellFuelPickup, SpawnFromMapRow continues its map cell scan from that offset.
InitPickupRecord:
    push ax
    mov si, bx
    call INIT_PICKUP_RECORD
    mov si, ax
    pop ax
    ret

public Type36FallThenBurst, Type22DescendThenBurst
; Record handlers (BP = record); both always end in the shared scroll/finish tail.
Type36FallThenBurst:
    push si
    mov si, bp
    call TYPE36_FALL_THEN_BURST
    pop si
    jmp ScrollRecordThenFinish
Type22DescendThenBurst:
    push si
    mov si, bp
    call TYPE22_DESCEND_THEN_BURST
    pop si
    jmp ScrollRecordThenFinish

MAIN ends
end
