; ASM -> C entry stubs for enemies and shared pool/terrain helpers. Each stub
; keeps an oracle label and its register contract (see the oracle routine's comment) and
; calls the C function that owns it (c/game.h convention: SI, DI in; AX out; all else
; preserved). Only labels the remaining ASM still reaches need a stub.
locals
extrn RUN_TYPE_HANDLER:near
extrn UPDATE_PICKUP:near
extrn SCROLL_RECORD_THEN_FINISH:near
extrn FINISH_RECORD_UPDATE:near
extrn HORIZONTAL_TERRAIN_PATROL:near
extrn NEXT_RANDOM_WORD:near
extrn SPAWN_AIMED_SHOT:near
extrn SPAWN_THROTTLED_CHILD:near
extrn SPAWN_SHOT_DOWN:near
extrn TRY_TERRAIN_STEP:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public RunTypeHandler, UpdatePickup
; KindHandlers entries (BP = record). No caller reads a register after a handler.
RunTypeHandler:
    push si
    mov si, bp
    call RUN_TYPE_HANDLER
    pop si
    ret
UpdatePickup:
    push si
    mov si, bp
    call UPDATE_PICKUP
    pop si
    ret

public ScrollRecordThenFinish, FinishRecordUpdate, HorizontalTerrainPatrol
; The shared tails of the handlers that stay ASM (entered by jmp, BP = record).
ScrollRecordThenFinish:
    push si
    mov si, bp
    call SCROLL_RECORD_THEN_FINISH
    pop si
    ret
FinishRecordUpdate:
    push si
    mov si, bp
    call FINISH_RECORD_UPDATE
    pop si
    ret
HorizontalTerrainPatrol:
    push si
    mov si, bp
    call HORIZONTAL_TERRAIN_PATROL
    pop si
    ret

public NextRandomWord, SpawnAimedShot
; BX = the next random word; everything else kept, like the oracle.
NextRandomWord:
    push ax
    call NEXT_RANDOM_WORD
    mov bx, ax
    pop ax
    ret
; BP = firer: BX = the aimed shot or FFFFh; clobbers AX (the oracle: AX, CX, DX).
SpawnAimedShot:
    push si
    mov si, bp
    call SPAWN_AIMED_SHOT
    mov bx, ax
    pop si
    ret

public SpawnThrottledChild, SpawnShotDown
; BP = parent, BX = the caller's BX: BX = child, FFFFh (pool B full) or, throttled, the
; incoming BX unchanged (callers write through it); clobbers AX (the oracle: AX, CX).
SpawnThrottledChild:
    push si
    push di
    mov si, bp
    mov di, bx
    call SPAWN_THROTTLED_CHILD
    jmp short SpawnChildDone
SpawnShotDown:
    push si
    push di
    mov si, bp
    mov di, bx
    call SPAWN_SHOT_DOWN
SpawnChildDone:
    mov bx, ax
    pop di
    pop si
    ret

public TryTerrainStep
; BP = record: NZ = blocked (the oracle's `cmp TerrainBlocked, 0`, same flags); clobbers
; AX (the oracle: AX, BX, DX).
TryTerrainStep:
    push si
    mov si, bp
    call TRY_TERRAIN_STEP
    pop si
    cmp ax, 0
    ret

MAIN ends
end
