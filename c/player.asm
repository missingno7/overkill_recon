; Player region's remaining ASM entry contracts. C calls these functions directly.
locals
extrn POLL_INPUT_BITS:near
extrn INIT_POSITION_HISTORY:near
extrn UPDATE_PLAYER_FRAME:near
extrn STORE_APPLY_HISTORY_AND_PLACEMENT:near
extrn PICKUP_FUEL:near
extrn MainDataSegment:word
extrn PrimaryRecord:byte
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public PollInputBits
; DS is the state segment; joystick polling retains the original hardware path.
PollInputBits:
    call POLL_INPUT_BITS
    ret

public InitPositionHistory
; No inputs; BP and ES become the primary record and state segment.
InitPositionHistory:
    call INIT_POSITION_HISTORY
    mov bp, offset PrimaryRecord
    mov es, word ptr cs:[MainDataSegment]
    ret

public UpdatePlayerFrame
; Preserve the incoming BP on the early level-done exit; otherwise return the ship.
UpdatePlayerFrame:
    push si
    mov si, bp
    call UPDATE_PLAYER_FRAME
    mov bp, ax
    pop si
    ret

public StoreApplyHistoryAndConditionalPlacement
; BP = record, kept. History storage establishes ES as in the oracle.
StoreApplyHistoryAndConditionalPlacement:
    push si
    mov si, bp
    call STORE_APPLY_HISTORY_AND_PLACEMENT
    mov es, word ptr cs:[MainDataSegment]
    pop si
    ret

public PickupFuel
PickupFuel:
    call PICKUP_FUEL
    ret

MAIN ends
end
