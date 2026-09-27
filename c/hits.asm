; ASM -> C entry stubs of the shot-hit region (c/hits.c) for the DOS hybrid. Each stub keeps
; an oracle label and its register contract (see the oracle routine's comment) and calls
; the C function that owns it (c/game.h convention: SI, DI in; AX out; all else preserved).
; Only labels the remaining ASM still reaches need a stub.
locals
extrn SMART_BOMB_RECORD:near
extrn DESTROY_RECORD:near
extrn RELEASE_ENCOUNTER_MEMBER:near
extrn INIT_PICKUP_RECORD:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public SmartBombRecord, DestroyRecord, ReleaseEncounterMember
; BP = record; clobbers AX (the oracle clobbers more; its callers keep only BP).
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

MAIN ends
end
