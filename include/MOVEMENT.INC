; Modern shared movement/history vocabulary, not historical module ownership.
; DS state offsets require the game data segment; REC_X/Y require the reviewed
; coordinate-bearing record context. Field +8 is an unchecked index only at PlaceRecordFromOffsetPair.
; RECORD_Y_MIN/MAX are equality sentinels, NOT saturating bounds.
; PLACEMENT_X_SIGNED_MAX is distinct from the unsigned movement X limit.
; CLAMP_X_* are exact-1 sentinels; PlaceFourRecordsFromOffsetTables clears them, its PlaceRecordFromOffsetPair tail only sets.
; X_ADJUST_PATH_TAKEN records an attempted path, even at an unchanged X bound.
; Input bits (InputBits, IN_*) moved to INPUT.INC.
OFFSET_PAIR_INDEX_08 equ 08h
OFFSET_TABLE_A368 equ 0A368h
OFFSET_TABLE_A374 equ 0A374h
OFFSET_TABLE_A380 equ 0A380h
OFFSET_TABLE_A38C equ 0A38Ch
OFFSET_X_GROUP_A equ 0A39Ah
OFFSET_X_GROUP_B equ 0A39Ch
OFFSET_X_WORK equ 0A398h
HISTORY_BEGIN equ 0A27Ah
HISTORY_CURSOR_47 equ 0A340h
HISTORY_END equ 0A33Ah
HISTORY_INITIAL_CURSOR_47 equ 0A27Eh
HISTORY_INITIAL_READ_15 equ 0A2FEh
HISTORY_INITIAL_READ_31 equ 0A2BEh
HISTORY_PAIR_BYTES equ 04h
HISTORY_PAIR_COUNT equ 030h
HISTORY_READ_CURSOR_15 equ 0A33Ch
HISTORY_READ_CURSOR_31 equ 0A33Eh
HISTORY_WRITE_CURSOR equ 0A33Ah
CLAMP_X_LOW_SEEN equ 0A39Eh
CLAMP_X_HIGH_SEEN equ 0A39Fh
COUNT_GATE_2324 equ 02324h
MINUS_SLOT_A968 equ 0A968h
MINUS_SLOT_A96C equ 0A96Ch
MOVE_MODE_A47C equ 0A47Ch
PLUS_SLOT_A966 equ 0A966h
PLUS_SLOT_A96A equ 0A96Ah
X_ADJUST_PATH_TAKEN equ 0A360h
HISTORY_RECORD_SLOT_15 equ 0A962h
HISTORY_RECORD_SLOT_31 equ 0A964h
RECORD_X_MAX equ 0B0h
RECORD_Y_MAX equ 0C0h
RECORD_Y_MIN equ 020h
PLACEMENT_X_SIGNED_MAX equ 0C0h

; Shared grid-attribute state: fill/patch at InitializeByteAttributes, reset at CFDB, readers 4BA5/ReadIndexedByteAttribute.
; Modern names; no historical include or resource identity is claimed.
BYTE_ATTRIBUTE_TABLE equ 0C3AAh
BYTE_ATTRIBUTE_COUNT equ 0100h
ATTRIBUTE_SOURCE_SEGMENT equ 09592h
ATTRIBUTE_PATCH_POINTERS equ 0C4AAh
ATTRIBUTE_PATCH_END equ 0FFh
; ComputeRecordGridOffset stores its wrapped Y sum here.
GRID_Y_SUM equ 0215Ah
