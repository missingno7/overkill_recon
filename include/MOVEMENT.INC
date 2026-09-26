; Modern shared movement/history vocabulary, not historical module ownership.
; Field +8 is an unchecked index only at PlaceRecordFromOffsetPair.
; RECORD_Y_MIN/MAX are equality sentinels, NOT saturating bounds.
; PLACEMENT_X_SIGNED_MAX is distinct from the unsigned movement X limit.
; CLAMP_X_* are exact-1 sentinels; PlaceFourRecordsFromOffsetTables clears them, its PlaceRecordFromOffsetPair tail only sets.
; XAdjustPathTaken records an attempted path, even at an unchanged X bound.
OFFSET_PAIR_INDEX_08 equ 08h
; Initial byte offsets of the lagging cursors inside HistoryPairs: 48 minus the lag, in pairs.
HISTORY_LAG47_START equ 004h
HISTORY_LAG15_START equ 084h
HISTORY_LAG31_START equ 044h
HISTORY_PAIR_BYTES equ 04h
HISTORY_PAIR_COUNT equ 030h
RECORD_X_MAX equ 0B0h
RECORD_Y_MAX equ 0C0h
RECORD_Y_MIN equ 020h
PLACEMENT_X_SIGNED_MAX equ 0C0h

; ByteAttributeTable size and the attribute patch stream terminator.
BYTE_ATTRIBUTE_COUNT equ 0100h
ATTRIBUTE_PATCH_END equ 0FFh
