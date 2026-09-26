; The game's fixed-size records (38h bytes), modern names. The primary record sits
; directly before pool A. Fields are words; roles are named from code use only, and
; several fields change meaning with REC_TYPE.
RECORD_SIZE equ 038h
PRIMARY_RECORD equ 0237Ch
; Pool A: 35 records after the primary. FindFreeRecordPoolA starts at its cursor.
POOL_A equ 023B4h
POOL_A_COUNT equ 023h
POOL_A_CURSOR equ 095D8h
POOL_A_END equ 02B5Ch
; Round-robin cursor over pool A used by the target search at B15A.
TARGET_SEARCH_CURSOR equ 0A43Ah
; Pool B: 34 records ending at POOL_B_END; only ever drawn as 8x8 sprites.
POOL_B equ 02B5Ch
POOL_B_COUNT equ 022h
POOL_B_END equ 032CCh
POOL_B_CURSOR equ 095DAh
; Static pointer tables: pool A's 35 records then the primary (36 words), and pool B.
; Loops index them with BX = 2*CX for CX = count..1, hence the "- 2" displacements.
POOL_A_POINTERS equ 032CCh
POOL_A_POINTER_COUNT equ 024h
POOL_B_POINTERS equ 08D14h

; 0 = free slot.
REC_STATUS equ 00h
REC_Y equ 02h
REC_X equ 04h
; Set from quadrant bits through the table at DS:A348; used as an index.
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
; Update handler index (table at CS:AA36); the primary record uses 3.
REC_KIND equ 16h
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
