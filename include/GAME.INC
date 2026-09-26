; Game session state, modern names from code behaviour. DS offsets in the state segment.

; Number of levels (LevelIndex wraps modulo this).
LEVEL_COUNT equ 06h
; LivesLeft at the start of a game.
INITIAL_LIVES equ 03h
; 8-digit packed BCD score, least significant byte first; compared with the
; high-score entries (+0Ch..+0Fh) when the game ends.
; Waypoint Y that ends a leader script (never reached).
LEADER_END_Y equ 7530h
; Upgrade selector slot fields (UpgradeSlot0..3).
UPGRADE_SLOT_ICON equ 0
UPGRADE_SLOT_SCREEN equ 2
UPGRADE_SLOT_IMAGE equ 4
UPGRADE_SLOT_LIST equ 6
UPGRADE_SLOT_INDEX equ 8
UPGRADE_SLOT_BYTES equ 0Ah
