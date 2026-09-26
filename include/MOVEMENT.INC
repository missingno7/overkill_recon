; Modern shared movement/history vocabulary, not historical module ownership.
; SHIP_Y_MIN/MAX are equality sentinels, NOT saturating bounds.
; Initial byte offsets of the lagging cursors inside HistoryPairs: 48 minus the lag, in pairs.
HISTORY_LAG47_START equ 004h
HISTORY_LAG15_START equ 084h
HISTORY_LAG31_START equ 044h
HISTORY_PAIR_BYTES equ 04h
HISTORY_PAIR_COUNT equ 030h
; Player ship movement bounds.
SHIP_X_MAX equ 0B0h
SHIP_Y_MAX equ 0C0h
SHIP_Y_MIN equ 020h

; ByteAttributeTable size and the attribute patch stream terminator.
BYTE_ATTRIBUTE_COUNT equ 0100h
ATTRIBUTE_PATCH_END equ 0FFh
