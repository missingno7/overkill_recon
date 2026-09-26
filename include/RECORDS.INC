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
REC_Y equ 02h
REC_X equ 04h
; 0..7 clockwise from up (0 up, 2 right, 4 down, 6 left), see DirectionFromQuadrant.
REC_DIRECTION equ 06h
; Sprite-table index for drawing. On the primary record it also serves as a state and
; offset-pair index (OFFSET_PAIR_INDEX_08).
REC_SPRITE equ 08h
; Drawn in the first pass when 0, in the second when 1.
REC_DRAW_PASS equ 0Ah
; Screen address of the record (-1 = not visible), and of its lower half for size 2.
REC_SCREEN_OFS equ 0Ch
; Per-record background save buffer.
REC_SAVE_BUFFER equ 0Eh
REC_SCREEN_OFS_LOWER equ 10h
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
KIND_COMPANION equ 6
; Detailed type, 0..94h; 1 marks a record being destroyed (old type kept in +1A).
REC_TYPE equ 18h
REC_PREV_TYPE equ 1Ah
; Type-dependent.
REC_FIELD_1C equ 1Ch
; Pool B: 1 or 0 depending on the spawn site; tested against pool-A records.
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
