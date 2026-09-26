; The game's fixed-size records (38h bytes), modern names. The primary record sits
; directly before pool A. Fields are words; roles are named from code use only, and
; several fields change meaning with REC_TYPE.
RECORD_SIZE equ 038h
; Records in PoolA and PoolB, and entries in PoolAPointers (pool A plus the primary).
POOL_A_COUNT equ 023h
POOL_B_COUNT equ 022h
POOL_A_POINTER_COUNT equ 024h
; Bytes of background save buffer per record (PoolASaveBuffers, PoolBSaveBuffers).
POOL_A_SAVE_BYTES equ 0280h
POOL_B_SAVE_BYTES equ 040h

; 0 = free slot.
REC_STATUS equ 00h
; Signed playfield pixels, Y growing downward, top-left of the sprite. The playfield is
; 13 cells x 16 px = D0h wide (record X 0..PLAYFIELD_MAX_X). Scrolling records get
; ScrollDeltaY added each frame; the player ship does not.
REC_Y equ 02h
REC_X equ 04h
; 0..7 clockwise from up (0 up, 2 right, 4 down, 6 left), see DirectionFromQuadrant.
REC_DIRECTION equ 06h
DIR_UP equ 0
DIR_UP_RIGHT equ 1
DIR_RIGHT equ 2
DIR_DOWN_RIGHT equ 3
DIR_DOWN equ 4
DIR_DOWN_LEFT equ 5
DIR_LEFT equ 6
DIR_UP_LEFT equ 7
; Sprite-table index for drawing. On the primary record it is the ship form (0..2,
; 3 or more = destroyed), which also indexes the pod and exhaust offset tables.
REC_SPRITE equ 08h
; Drawn in the first pass when 0, in the second when 1.
REC_DRAW_PASS equ 0Ah
; WorkspaceSegment offset of the record as drawn (-1 = not drawn), and of its lower
; half for size 2 (see RecordWorkspaceOffset).
REC_WORK_OFS equ 0Ch
; Per-record background save buffer.
REC_SAVE_BUFFER equ 0Eh
REC_WORK_OFS_LOWER equ 10h
; X & 7: selects the shifted blit variant.
REC_PIXEL_PHASE equ 12h
; 0 = 8x8, 1 = 16 rows, 2 = two 16-row halves.
REC_SIZE_CLASS equ 14h
; Update handler index (KindHandlers):
REC_KIND equ 16h
; Moves with the scroll only; skipped by the collision pass.
KIND_SCENERY equ 0
; A pod (UpdatePod); becomes KIND_TYPED when removed.
KIND_POD equ 1
; Runs its REC_TYPE handler; not destroyed by the smart bomb (e.g. enemy shots).
KIND_TYPED equ 2
; The player record (no kind handler).
KIND_PLAYER equ 3
; Runs its REC_TYPE handler; an enemy the smart bomb destroys.
KIND_ENEMY equ 4
KIND_PICKUP equ 5
; One record created with the player: the engine exhaust (2X2.BIC sprites 9..0Dh are
; twin flames of growing length), pinned under the ship, no collision (UpdateExhaust).
KIND_EXHAUST equ 6
; Detailed type, 0..94h; 1 marks a record being destroyed (old type kept in +1A).
REC_TYPE equ 18h
REC_PREV_TYPE equ 1Ah
; Type-dependent.
REC_FIELD_1C equ 1Ch
; Pool B: 1 = player shot (tested against pool A), 0 = enemy shot or child (tested
; against the player).
REC_SIDE_FLAG equ 1Eh
; Set at spawn, decremented per collision; zero destroys the record.
REC_HIT_POINTS equ 20h
; Destruction animation frame; completes at 9.
REC_ANIM_COUNTER equ 22h
; Nonzero selects the alternate (flash) blit table; set to 5 on a hit.
REC_FLASH_TIMER equ 24h
; Kind 5 only: effect index applied when the primary touches it.
REC_ITEM_INDEX equ 26h
; Index into the byte-flag table at DS:2078, or FFFF.
REC_SLOT_INDEX equ 28h
; Step deltas toward the primary and the Bresenham-style error term.
REC_DELTA_Y equ 2Ah
REC_DELTA_X equ 2Ch
REC_STEP_ERROR equ 2Eh
; Pool B: record pointer chosen as target.
REC_TARGET equ 30h
REC_SAVED_X equ 32h
REC_SAVED_Y equ 34h
; Type-dependent.
REC_FIELD_36 equ 36h
; Roles of REC_FIELD_1C by type.
; Shots (types 02h, 03h, 04h, 0Bh, 0Ch, 0Fh): frames left, counted down by 02h/03h/0Fh
; (expire at 0) and 0Ch (turns up at 0); FFFFh = until out of bounds.
REC_SHOT_TIMER equ REC_FIELD_1C
; Homing missile (type 0Ah): 0 = riding with the player, 1 = locked on REC_TARGET.
REC_MISSILE_LOCKED equ REC_FIELD_1C
; Formation followers 16h/17h, 1Dh/1Eh, 7Fh, 81h: frames to wait before moving off.
REC_ENTRY_DELAY equ REC_FIELD_1C
; Type 23h column faller: index 0..3 into FallerVariants.
REC_FALLER_VARIANT equ REC_FIELD_1C
; Type 20h: FFFFh = hopping between slots, else Type20Cases index 0..2.
REC_DIVE_PHASE equ REC_FIELD_1C
; Roles of REC_FIELD_36 by type.
; Waypoint followers (type 12h and the types that start it) and sweep loopers
; 16h/17h/18h: pointer to the next (Y, X) waypoint.
REC_PATH equ REC_FIELD_36
; Type 53h: base sprite the animation offsets are added to.
REC_SPRITE_BASE equ REC_FIELD_36
; Types 81h/93h: blocked climbs; 100 or more destroys the record.
REC_BLOCKED_CLIMBS equ REC_FIELD_36


; GroupTable entries (2 bytes): live members, and the item kind dropped when the
; last member dies; REC_SLOT_INDEX links a record to its entry.
GROUP_LIVE equ 0
GROUP_DROP_KIND equ 1
