; Game session state, modern names from code behaviour. DS offsets in the state segment.

; Number of levels (LevelIndex wraps modulo this).
LEVEL_COUNT equ 06h
; LivesLeft at the start of a game.
INITIAL_LIVES equ 03h
; 8-digit packed BCD score, least significant byte first; compared with the
; high-score entries (+0Ch..+0Fh) when the game ends.
SCORE_BCD equ 02314h
