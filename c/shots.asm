; ASM -> C entry stubs of the shots/terrain region (c/shots.c) for the DOS hybrid. Each stub
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
extrn TERRAIN_STEP_IN_DIRECTION:near
extrn CLIMB_WALKER_STEP:near
extrn TYPE02_TIMED_STRAIGHT_SHOT:near
extrn TYPE04_STRAIGHT_SHOT:near
extrn TYPE05_SIDE_SHOT_UP_LEFT:near
extrn TYPE06_SIDE_SHOT_UP_RIGHT:near
extrn TYPE07_RISING_SHOT3:near
extrn TYPE08_RISING_SHOT16:near
extrn TYPE09_BEAM_LINK:near
extrn TYPE0A_HOMING_MISSILE:near
extrn TYPE0B_AIMED_ENEMY_SHOT:near
extrn TYPE0C_TIMED_TURN_UP_SHOT:near
extrn TYPE0F_TIMED_SHOT2:near
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

public TerrainStepInDirection, ClimbWalkerStep
; BP = record (TryTerrainStep's scrolled box); clobbers AX.
TerrainStepInDirection:
    push si
    mov si, bp
    call TERRAIN_STEP_IN_DIRECTION
    pop si
    ret
; BP = walker: ZF = TerrainBlocked 1 (the oracle's `cmp TerrainBlocked, 1`, same flags).
ClimbWalkerStep:
    push si
    mov si, bp
    call CLIMB_WALKER_STEP
    pop si
    cmp ax, 1
    ret

; Record handlers (RunTypeHandler's table), BP = record; they keep BP like the oracle.
public Type02TimedStraightShot, Type04StraightShot, Type05SideShotUpLeft, Type06SideShotUpRight
public Type07RisingShot3, Type08RisingShot16, Type09BeamLink, Type0AHomingMissile
public Type0BAimedEnemyShot, Type0CTimedTurnUpShot, Type0FTimedShot2
Type02TimedStraightShot:
    push si
    mov si, bp
    call TYPE02_TIMED_STRAIGHT_SHOT
    pop si
    ret
Type04StraightShot:
    push si
    mov si, bp
    call TYPE04_STRAIGHT_SHOT
    pop si
    ret
Type05SideShotUpLeft:
    push si
    mov si, bp
    call TYPE05_SIDE_SHOT_UP_LEFT
    pop si
    ret
Type06SideShotUpRight:
    push si
    mov si, bp
    call TYPE06_SIDE_SHOT_UP_RIGHT
    pop si
    ret
Type07RisingShot3:
    push si
    mov si, bp
    call TYPE07_RISING_SHOT3
    pop si
    ret
Type08RisingShot16:
    push si
    mov si, bp
    call TYPE08_RISING_SHOT16
    pop si
    ret
Type09BeamLink:
    push si
    mov si, bp
    call TYPE09_BEAM_LINK
    pop si
    ret
Type0AHomingMissile:
    push si
    mov si, bp
    call TYPE0A_HOMING_MISSILE
    pop si
    ret
Type0BAimedEnemyShot:
    push si
    mov si, bp
    call TYPE0B_AIMED_ENEMY_SHOT
    pop si
    ret
Type0CTimedTurnUpShot:
    push si
    mov si, bp
    call TYPE0C_TIMED_TURN_UP_SHOT
    pop si
    ret
Type0FTimedShot2:
    push si
    mov si, bp
    call TYPE0F_TIMED_SHOT2
    pop si
    ret

MAIN ends

; C (CGAME) -> MAIN routine at AX with BP = SI (RemoveRecord, TryTerrainStep); the other
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
