; Sound vocabulary: optional sound modules and the PC-speaker effect player.
; DS offsets require the game state segment.

; DS byte from PSP:83h or hiscore.dat. LoadSoundModule compares it after lowercasing;
; FFh tries tandy, roland, then adlib. Other values load no module.
SOUND_SELECT_ANY equ 0FFh
SOUND_SELECT_ADLIB equ 061h
SOUND_SELECT_ROLAND equ 072h
SOUND_SELECT_TANDY equ 074h
SOUND_MODULE_NAME_ADLIB equ 0BD34h
SOUND_MODULE_NAME_TANDY equ 0BD3Eh
SOUND_MODULE_NAME_ROLAND equ 0BD48h

; Word option saved in hiscore.dat, 0..3; indexes SOUND_OPTION_FLAGS words whose
; high byte becomes SfxEnabled and low byte ModuleSoundEnabled.
SOUND_OPTION_FLAGS equ 022C1h

; Effect table: SFX_EFFECT_COUNT entries of two stream pointers (voice A, voice B).
; Entry 0 is unused because request 0 means none; requests >= 20h stop everything.
SFX_EFFECT_TABLE equ 0BFCAh
SFX_EFFECT_COUNT equ 020h
; Word PIT divisors a semitone apart, starting near 65.4 Hz; indexed by note, unchecked.
SFX_NOTE_DIVISORS equ 0BF01h
; Stream bytes: 00..7F play that note; E0..FF set the duration to byte-DFh ticks;
; 80..85 are commands dispatched through SFX_COMMAND_TABLE (index = byte*2 mod 256):
; 80 end (stop all), 81 rest, 82 step down, 83 step up, 84 slide (word delta, byte
; ticks), 85 hold.
SFX_COMMAND_TABLE equ 0BEF0h
SFX_STREAM_COMMAND equ 080h
SFX_STREAM_DURATION equ 0E0h
SFX_DURATION_BIAS equ 0DFh
; Two 16-byte voice records; offsets +00, +01, +0A and +0F are never used.
SFX_VOICE_A equ 0BFAAh
SFX_VOICE_B equ 0BFBAh
SFX_VOICE_STREAM equ 02h
SFX_VOICE_NOTE equ 04h
SFX_VOICE_DURATION equ 05h
SFX_VOICE_DIVISOR equ 06h
SFX_VOICE_COUNTDOWN equ 08h
; Nonzero while a note sounds (written as 2; only zero/nonzero is tested).
SFX_VOICE_SOUNDING equ 09h
; Signed semitone step applied every tick, and a divisor slide with its tick count.
SFX_VOICE_NOTE_STEP equ 0Bh
SFX_VOICE_SLIDE_DELTA equ 0Ch
SFX_VOICE_SLIDE_TICKS equ 0Eh
