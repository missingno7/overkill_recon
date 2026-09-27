; ASM -> C entry stubs of the pods region (c/pods.c) for the DOS hybrid. Each stub keeps an
; oracle label and its register contract (see the oracle routine's comment) and calls the C
; function that owns it (c/game.h convention: SI, DI in; AX out; all else preserved). Only
; labels the remaining ASM still reaches need a stub; the upgrade lists in DATA.ASM hold
; the addresses of the condition and apply routines, so those keep a MAIN label each.
locals
extrn FarCallMainNearViaAX:far
extrn UPDATE_POD:near
extrn REMOVE_RECORD:near
extrn POD_TERRAIN_HIT:near
extrn PLACE_SIDE_PODS:near
extrn ADJUST_RECORD_X_FROM_COUNTS:near
extrn DEC_RECORD_X_TWICE:near
extrn INC_RECORD_X_TWICE:near
extrn APPLY_SELECTED_UPGRADE:near
extrn PICKUP_UPGRADE_SELECTOR:near
extrn RESET_POOL_A_AND_UPGRADES:near
extrn ADD_SCORE_BCD:near
extrn DESTROY_RECORD:near
extrn SINGLE_SHOT_AVAILABLE:near
extrn HEAVY_SHOT_AVAILABLE:near
extrn FORK_SHOT_AVAILABLE:near
extrn TWIN_RISING3_AVAILABLE:near
extrn TWIN_RISING16_AVAILABLE:near
extrn BEAM_AVAILABLE:near
extrn SIDE_SHOTS_AVAILABLE:near
extrn UPGRADE_NEVER_AVAILABLE:near
extrn MISSILES_AVAILABLE:near
extrn FRONT_POD_AVAILABLE:near
extrn SIDE_PODS_AVAILABLE:near
extrn TRAILING_PODS_AVAILABLE:near
extrn SHIP_FORM1_AVAILABLE:near
extrn SHIP_FORM2_AVAILABLE:near
extrn APPLY_SINGLE_SHOT:near
extrn APPLY_HEAVY_SHOT:near
extrn APPLY_FORK_SHOT:near
extrn APPLY_TWIN_RISING3:near
extrn APPLY_TWIN_RISING16:near
extrn APPLY_BEAM:near
extrn APPLY_SIDE_SHOTS:near
extrn APPLY_MISSILES:near
extrn APPLY_FRONT_POD:near
extrn APPLY_SIDE_PODS:near
extrn APPLY_TRAILING_PODS:near
extrn APPLY_SHIP_FORM1:near
extrn APPLY_SHIP_FORM2:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public UpdatePod, RemoveRecord
public PlaceSidePods, AdjustRecordXFromCounts, DecRecordXTwice, IncRecordXTwice
; BP = record (the pod, the record to free, the pickup, the record touching the ship, the
; side pods' anchor, the ship), kept; clobbers AX (the oracle clobbers more, its callers
; keep only BP).
UpdatePod:
    push si
    mov si, bp
    call UPDATE_POD
    pop si
    ret
RemoveRecord:
    push si
    mov si, bp
    call REMOVE_RECORD
    pop si
    ret
PlaceSidePods:
    push si
    mov si, bp
    call PLACE_SIDE_PODS
    pop si
    ret
AdjustRecordXFromCounts:
    push si
    mov si, bp
    call ADJUST_RECORD_X_FROM_COUNTS
    pop si
    ret
DecRecordXTwice:
    push si
    mov si, bp
    call DEC_RECORD_X_TWICE
    pop si
    ret
IncRecordXTwice:
    push si
    mov si, bp
    call INC_RECORD_X_TWICE
    pop si
    ret

public PodTerrainHit
; BP = record, kept: CF = hit (the oracle's result); clobbers AX. No ASM caller left;
; tests/shots.py enters it.
PodTerrainHit:
    push si
    mov si, bp
    call POD_TERRAIN_HIT
    pop si
    shr ax, 1
    ret

public ApplySelectedUpgrade, PickupUpgradeSelector, ResetPoolAAndUpgrades
; No inputs; clobber AX (ApplySelectedUpgrade keeps BX and BP like the oracle).
ApplySelectedUpgrade:
    call APPLY_SELECTED_UPGRADE
    ret
PickupUpgradeSelector:
    call PICKUP_UPGRADE_SELECTOR
    ret
ResetPoolAAndUpgrades:
    call RESET_POOL_A_AND_UPGRADES
    ret

public AddScoreBcd, DestroyRecordAtBX
; BX = points / record, kept. No ASM caller left; tests/quirks.py and tests/hits.py enter
; them. AddScoreBcd keeps every register like the oracle.
AddScoreBcd:
    push ax
    push si
    mov si, bx
    call ADD_SCORE_BCD
    pop si
    pop ax
    ret
DestroyRecordAtBX:
    push si
    mov si, bx
    call DESTROY_RECORD
    pop si
    ret

; Upgrade list conditions (reached through the lists only): NZ = can be offered; clobber AX.
public SingleShotAvailable, HeavyShotAvailable, ForkShotAvailable, TwinRising3Available
public TwinRising16Available, BeamAvailable, SideShotsAvailable, UpgradeNeverAvailable
public MissilesAvailable, FrontPodAvailable, SidePodsAvailable, TrailingPodsAvailable
public ShipForm1Available, ShipForm2Available
SingleShotAvailable:
    call SINGLE_SHOT_AVAILABLE
    or ax, ax
    ret
HeavyShotAvailable:
    call HEAVY_SHOT_AVAILABLE
    or ax, ax
    ret
ForkShotAvailable:
    call FORK_SHOT_AVAILABLE
    or ax, ax
    ret
TwinRising3Available:
    call TWIN_RISING3_AVAILABLE
    or ax, ax
    ret
TwinRising16Available:
    call TWIN_RISING16_AVAILABLE
    or ax, ax
    ret
BeamAvailable:
    call BEAM_AVAILABLE
    or ax, ax
    ret
SideShotsAvailable:
    call SIDE_SHOTS_AVAILABLE
    or ax, ax
    ret
UpgradeNeverAvailable:
    call UPGRADE_NEVER_AVAILABLE
    or ax, ax
    ret
MissilesAvailable:
    call MISSILES_AVAILABLE
    or ax, ax
    ret
FrontPodAvailable:
    call FRONT_POD_AVAILABLE
    or ax, ax
    ret
SidePodsAvailable:
    call SIDE_PODS_AVAILABLE
    or ax, ax
    ret
TrailingPodsAvailable:
    call TRAILING_PODS_AVAILABLE
    or ax, ax
    ret
ShipForm1Available:
    call SHIP_FORM1_AVAILABLE
    or ax, ax
    ret
ShipForm2Available:
    call SHIP_FORM2_AVAILABLE
    or ax, ax
    ret

; Upgrade list apply routines (reached through the lists only); clobber AX.
public ApplySingleShot, ApplyHeavyShot, ApplyForkShot, ApplyTwinRising3, ApplyTwinRising16
public ApplyBeam, ApplySideShots, ApplyMissiles, ApplyFrontPod, ApplySidePods
public ApplyTrailingPods, ApplyShipForm1, ApplyShipForm2
ApplySingleShot:
    call APPLY_SINGLE_SHOT
    ret
ApplyHeavyShot:
    call APPLY_HEAVY_SHOT
    ret
ApplyForkShot:
    call APPLY_FORK_SHOT
    ret
ApplyTwinRising3:
    call APPLY_TWIN_RISING3
    ret
ApplyTwinRising16:
    call APPLY_TWIN_RISING16
    ret
ApplyBeam:
    call APPLY_BEAM
    ret
ApplySideShots:
    call APPLY_SIDE_SHOTS
    ret
ApplyMissiles:
    call APPLY_MISSILES
    ret
ApplyFrontPod:
    call APPLY_FRONT_POD
    ret
ApplySidePods:
    call APPLY_SIDE_PODS
    ret
ApplyTrailingPods:
    call APPLY_TRAILING_PODS
    ret
ApplyShipForm1:
    call APPLY_SHIP_FORM1
    ret
ApplyShipForm2:
    call APPLY_SHIP_FORM2
    ret

MAIN ends

; C (CGAME) -> an upgrade list condition routine at AX (MAIN): AX = 1 when it returns NZ.
; The conditions touch only AX and the flags. A near thunk next to the C code, see
; pods_call_condition in c/pods.c.
CGAME segment byte public 'CODE'
assume cs:CGAME
public PODS_CALL_CONDITION
PODS_CALL_CONDITION:
    call far ptr FarCallMainNearViaAX
    mov ax, 0
    jz @@unavailable
    inc ax
@@unavailable:
    ret
CGAME ends
end
