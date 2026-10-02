; ASM -> C entry stubs of the per-frame region (c/frame.c) for the DOS hybrid. Each stub
; keeps an oracle label and its register contract (see the oracle routine's comment) and
; calls the C function that owns it (c/game.h convention: SI, DI in; AX out; all else
; preserved). Only labels the remaining ASM still reaches need a stub.
locals
extrn INIT_STARS:near
extrn MOVE_STARS:near
extrn UPDATE_ALL_RECORDS:near
extrn TICK_FRAME_TIMERS:near
extrn TICK_REFUEL:near
extrn FRAME_UPDATE_REFUEL_TIMERS_AND_SCORE:near
extrn SCROLL_FORWARD_AND_CHECK_LEVEL_END:near
extrn SCROLL_MAP_TO_LEVEL_START:near
extrn RESTART_AT_CHECKPOINT:near
extrn SMART_BOMB_ALL:near
extrn FarCallMainNearViaAX:far
extrn FarCallMainNearViaBP:far
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public InitStars, MoveStars
InitStars:
    call INIT_STARS
    ret
MoveStars:
    call MOVE_STARS
    retf

public UpdateAllRecords
; The record pass. Leaves BP as the oracle does (the last pool B pointer, or what that
; record's handler left); keeps every other register but AX (the oracle clobbers them).
UpdateAllRecords:
    call UPDATE_ALL_RECORDS
    mov bp, ax
    ret

public TickFrameTimers, TickRefuel, UpdateRefuelTimersAndScore, SmartBombAll
; TickFrameTimers, TickRefuel and SmartBombAll take no register inputs; TickRefuel and
; SmartBombAll keep BP. The score entry below instead uses the saved BP/ES pair.
TickFrameTimers:
    call TICK_FRAME_TIMERS
    ret
TickRefuel:
    call TICK_REFUEL
    ret
; BP/ES in the saved words are a writable DosRegisters pair. The native coordinator
; carries the gauge's real ES into score text and returns the resulting BP/ES pair.
UpdateRefuelTimersAndScore:
    push es
    push bp
    push si
    mov si, sp
    add si, 2
    call FRAME_UPDATE_REFUEL_TIMERS_AND_SCORE
    pop si
    pop bp
    pop es
    ret
SmartBombAll:
    call SMART_BOMB_ALL
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
