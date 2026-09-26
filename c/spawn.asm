; ASM -> C entry stubs of the spawn region (c/spawn.c) for the DOS hybrid. Each stub keeps an
; oracle label and its register contract (see the oracle routine's comment) and calls the
; C function that owns it (c/game.h convention: SI, DI in; AX out; all else preserved).
; Only labels the remaining ASM still reaches need a stub; calls between C functions do not
; pass through here.
locals
extrn FIND_FREE_RECORD_POOL_A:near
extrn SPAWN_ENEMY_HERE:near
extrn SPAWN_ENEMY_HERE_QUIET:near
extrn SPAWN_MAP_ENEMY:near
extrn LEVEL_MAP_CELL:near
extrn DRAW_INCOMING_MAP_ROW:near
extrn TYPE13_FORMATION_LEADER:near
extrn TYPE21_LEADER_PATH:near
extrn DEMO_STEP_SPAWN_PATH_ENEMY51:near
extrn DEMO_STEP_LAUNCH_FRONT_POD:near
extrn DrawMapRowBlocks:near
extrn FinishRecordUpdate:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public FindFreeRecordPoolA
; BX = a free pool A record (the new PoolACursor) or FFFFh; preserves CX (the oracle
; leaves its loop count there; no caller reads it).
FindFreeRecordPoolA:
    push ax
    call FIND_FREE_RECORD_POOL_A
    mov bx, ax
    pop ax
    ret

public SpawnEnemyHere, SpawnEnemyHereQuiet
; BP = spawn origin: BX = the new type 14h enemy or FFFFh; clobbers AX (the oracle: AX, CX).
SpawnEnemyHere:
    push si
    mov si, bp
    call SPAWN_ENEMY_HERE
    jmp short SpawnEnemyHereDone
SpawnEnemyHereQuiet:
    push si
    mov si, bp
    call SPAWN_ENEMY_HERE_QUIET
SpawnEnemyHereDone:
    mov bx, ax
    pop si
    ret

public SpawnMapEnemy
; SI = map cell (ES = LevelMapSegment, which the C side reads itself), BP = spawn origin,
; MapCellX: BX = record and NZ, or BX = FFFFh and ZF; clobbers AX (the oracle: AX, CX).
SpawnMapEnemy:
    push di
    push si
    mov di, si
    mov si, bp
    call SPAWN_MAP_ENEMY
    pop si
    pop di
    mov bx, ax
    cmp ax, -1
    ret

public Level0MapCell, Level1MapCell, Level2MapCell, Level3MapCell, Level4MapCell, Level5MapCell
; The LevelMapCellHandlers entries (their reader, SpawnFromMapRow, is C and dispatches
; itself): AL = cell byte at SI (ES = LevelMapSegment), BP = spawn origin, MapCellX. SI
; comes back as the handler leaves it (a level 0 fuel pickup changes it); clobbers AX
; (the oracle: AX, BX, CX, and ES on some paths).
Level0MapCell:
    mov ah, 0
    jmp short LevelMapCell
Level1MapCell:
    mov ah, 1
    jmp short LevelMapCell
Level2MapCell:
    mov ah, 2
    jmp short LevelMapCell
Level3MapCell:
    mov ah, 3
    jmp short LevelMapCell
Level4MapCell:
    mov ah, 4
    jmp short LevelMapCell
Level5MapCell:
    mov ah, 5
LevelMapCell:
    push di
    mov di, si
    mov si, bp
    call LEVEL_MAP_CELL
    mov si, ax
    pop di
    ret

public DrawIncomingMapRow
; DI = workspace band, BP = spawn origin for map enemies (the player): spawns and runs the
; level script in C, then draws the returned row (BX) with the platform tail.
DrawIncomingMapRow:
    push si
    mov si, bp
    call DRAW_INCOMING_MAP_ROW
    pop si
    mov bx, ax
    jmp DrawMapRowBlocks

public Type13FormationLeader
; Record handler (BP = leader): the far body in C, then the shared tail.
Type13FormationLeader:
    push si
    mov si, bp
    call TYPE13_FORMATION_LEADER
    pop si
    jmp FinishRecordUpdate

public Type21LeaderPathBody
; Far body of Type21LeaderPath (BP = leader), entered with call far.
Type21LeaderPathBody:
    push si
    mov si, bp
    call TYPE21_LEADER_PATH
    pop si
    retf

public DemoStepSpawnPathEnemy51, DemoStepLaunchFrontPod
; DemoStepActions entries. The path enemy spawns at BP; the front pod step leaves BP = the
; pod, as the oracle does.
DemoStepSpawnPathEnemy51:
    push si
    mov si, bp
    call DEMO_STEP_SPAWN_PATH_ENEMY51
    pop si
    ret
DemoStepLaunchFrontPod:
    call DEMO_STEP_LAUNCH_FRONT_POD
    mov bp, ax
    ret

MAIN ends
end
