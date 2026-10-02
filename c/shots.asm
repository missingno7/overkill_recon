; ASM -> C entry stubs for shots and shared terrain logic in the DOS hybrid. Each stub
; keeps an oracle label and its register contract (see the oracle routine's comment) and
; calls the C function that owns it (c/game.h convention: SI, DI in; AX out; all else
; preserved). Only labels the remaining ASM still reaches need a stub.
locals
extrn LevelMapSegment:word
extrn FarCallMainNearViaAX:far
extrn MAP_ATTRIBUTE:near
extrn COMPUTE_RECORD_GRID_OFFSET:near
extrn DAMAGE_PLAYER_ON_TERRAIN_CONTACT:near
extrn LOSE_PLAYER_ENERGY_TANK:near
extrn CLIMB_WALKER_STEP:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public ReadIndexedByteAttribute, ComputeRecordGridOffset
; BX = cell, kept: AX = its attribute, ZF when 0 (the oracle's `or al, al`), ES =
; LevelMapSegment like the oracle (which also leaves SI pointing into the table).
ReadIndexedByteAttribute:
    push si
    mov si, bx
    call MAP_ATTRIBUTE
    pop si
    mov es, word ptr cs:[LevelMapSegment]
    or al, al
    ret
; BP = record: BX = its grid offset (FFFFh for a negative GridYSum); clobbers AX (the
; oracle: AX, CX, DX).
ComputeRecordGridOffset:
    push si
    mov si, bp
    call COMPUTE_RECORD_GRID_OFFSET
    pop si
    mov bx, ax
    ret

public DamagePlayerOnTerrainContact, LosePlayerEnergyTank
; BP = PrimaryRecord; clobbers AX (the oracle: everything but BP).
DamagePlayerOnTerrainContact:
    push si
    mov si, bp
    call DAMAGE_PLAYER_ON_TERRAIN_CONTACT
    pop si
    ret
LosePlayerEnergyTank:
    call LOSE_PLAYER_ENERGY_TANK
    ret

public ClimbWalkerStep
; BP = walker: ZF = TerrainBlocked 1 (the oracle's `cmp TerrainBlocked, 1`, same flags).
ClimbWalkerStep:
    push si
    mov si, bp
    call CLIMB_WALKER_STEP
    pop si
    cmp ax, 1
    ret

MAIN ends

; C (CGAME) -> MAIN routine at AX with BP = SI (RemoveRecord; the ASM handlers c/enemies.c
; dispatches, and its other BP-input callees); the other
; registers as the routine leaves them. A near thunk next to the C code, see call_main_bp
; in c/shots.c.
CGAME segment byte public 'CODE'
assume cs:CGAME
public CALL_MAIN_BP
CALL_MAIN_BP:
    push bp
    mov bp, si
    call far ptr FarCallMainNearViaAX
    pop bp
    ret
CGAME ends
end
