; ASM -> C entry stubs of the per-frame region (c/frame.c) for the DOS hybrid. Each stub
; keeps an oracle label and its register contract (see the oracle routine's comment) and
; calls the C function that owns it (c/game.h convention: SI, DI in; AX out; all else
; preserved). Only labels the remaining ASM still reaches need a stub.
locals
extrn UPDATE_ALL_RECORDS:near
extrn TICK_FRAME_TIMERS:near
extrn TICK_REFUEL:near
extrn UPDATE_REFUEL_TIMERS_AND_SCORE:near
extrn STEP_HATCH_RAMP_FRAME:near
extrn SCROLL_FORWARD_AND_CHECK_LEVEL_END:near
extrn SCROLL_MAP_TO_LEVEL_START:near
extrn RESTART_AT_CHECKPOINT:near
extrn SMART_BOMB_ALL:near
extrn TYPE50_STEER_HOME:near
extrn SEG_BOSS_PART:near
extrn TYPE80_MARCH_MEMBER:near
extrn ScrollRecordThenFinish:near
extrn FinishRecordUpdate:near
extrn RequestModuleMusic:near
extrn FarCallMainNearViaAX:far
extrn FarCallMainNearViaBP:far
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public UpdateAllRecords
; The record pass. Leaves BP as the oracle does (the last pool B pointer, or what that
; record's handler left); keeps every other register but AX (the oracle clobbers them).
UpdateAllRecords:
    call UPDATE_ALL_RECORDS
    mov bp, ax
    ret

public TickFrameTimers, TickRefuel, UpdateRefuelTimersAndScore, SmartBombAll
; No register inputs; clobber AX (the oracle clobbers more; TickRefuel and SmartBombAll keep
; BP).
TickFrameTimers:
    call TICK_FRAME_TIMERS
    ret
TickRefuel:
    call TICK_REFUEL
    ret
; BP = ScoreBcd as DrawScore leaves it (the oracle's exit BP).
UpdateRefuelTimersAndScore:
    call UPDATE_REFUEL_TIMERS_AND_SCORE
    mov bp, ax
    ret
SmartBombAll:
    call SMART_BOMB_ALL
    ret

public StepHatchRampFrame
; BP = hatch record, CX = sprite base; clobbers AX (the oracle: AX, BX).
StepHatchRampFrame:
    push si
    push di
    mov si, bp
    mov di, cx
    call STEP_HATCH_RAMP_FRAME
    pop di
    pop si
    ret

public ScrollForwardAndCheckLevelEnd, ScrollMapToLevelStart, RestartAtCheckpoint
; BP = spawn origin of the map rows entering (the player); clobber AX.
ScrollForwardAndCheckLevelEnd:
    push si
    mov si, bp
    call SCROLL_FORWARD_AND_CHECK_LEVEL_END
    pop si
    ret
ScrollMapToLevelStart:
    push si
    mov si, bp
    call SCROLL_MAP_TO_LEVEL_START
    pop si
    ret
RestartAtCheckpoint:
    push si
    mov si, bp
    call RESTART_AT_CHECKPOINT
    pop si
    ret

public SetMapTile28, SetMapTile1
; Routine words of the MapResetList tables (CS data that stays ASM): C compares an entry
; against these offsets (c/frame.c reset_map_before_view); never executed.
SetMapTile28:
    ret
SetMapTile1:
    ret

; Record handlers (RunTypeHandler's table), BP = record; they keep BP like the oracle.
public Type50SteerHomeThenBecomePod
; Bare ret: no FinishRecordUpdate.
Type50SteerHomeThenBecomePod:
    push si
    mov si, bp
    call TYPE50_STEER_HOME
    pop si
    ret

public Type76SegBossPart0, Type77SegBossPart1, Type78SegBossCore, Type79SegBossPart3
; DI = part 0..3 for the C body, then the shared tail.
Type76SegBossPart0:
    push di
    mov di, 0
    jmp short FrameSegBossPart
Type77SegBossPart1:
    push di
    mov di, 1
    jmp short FrameSegBossPart
Type78SegBossCore:
    push di
    mov di, 2
    jmp short FrameSegBossPart
Type79SegBossPart3:
    push di
    mov di, 3
FrameSegBossPart:
    push si
    mov si, bp
    call SEG_BOSS_PART
    pop si
    pop di
    jmp ScrollRecordThenFinish

public Type80MarchFormationMember
; The oracle's far body in C, then the shared tail.
Type80MarchFormationMember:
    push si
    mov si, bp
    call TYPE80_MARCH_MEMBER
    pop si
    jmp FinishRecordUpdate

MAIN ends

; C (CGAME) -> MAIN thunks next to the C code (see c/frame.c).
CGAME segment byte public 'CODE'
assume cs:CGAME
public FRAME_CALL_BP, FRAME_REQUEST_MUSIC
; AX = MAIN routine, SI = its BP input: returns AX = the BP it leaves; the caller's BP kept.
FRAME_CALL_BP:
    push bp
    mov bp, si
    call far ptr FarCallMainNearViaAX
    mov ax, bp
    pop bp
    ret
; AL = tune: RequestModuleMusic takes AX, so the trampoline target goes in BP.
FRAME_REQUEST_MUSIC:
    push bp
    mov bp, offset RequestModuleMusic
    call far ptr FarCallMainNearViaBP
    pop bp
    ret
CGAME ends
end
