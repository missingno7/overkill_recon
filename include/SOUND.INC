; Sound vocabulary: optional sound modules and the PC-speaker effect player.

; SoundModuleSelect values (compared after lowercasing): FFh tries tandy, roland,
; then adlib; other values load no module.
SOUND_SELECT_ANY equ 0FFh
SOUND_SELECT_ADLIB equ 061h
SOUND_SELECT_ROLAND equ 072h
SOUND_SELECT_TANDY equ 074h

; Effects in SfxEffectTable; requests at or above this stop everything.
SFX_EFFECT_COUNT equ 020h
; Stream bytes: 00..7F play that note; E0..FF set the duration to byte-DFh ticks;
; 80..85 are commands dispatched through SfxCommandTable (index = byte*2 mod 256):
; 80 end (stop all), 81 rest, 82 step down, 83 step up, 84 slide (word delta, byte
; ticks), 85 hold.
SFX_STREAM_COMMAND equ 080h
SFX_END equ 080h
SFX_REST equ 081h
SFX_STEP_DOWN equ 082h
SFX_STEP_UP equ 083h
SFX_SLIDE equ 084h
SFX_HOLD equ 085h
SFX_STREAM_DURATION equ 0E0h
SFX_DURATION_BIAS equ 0DFh
; Fields of the two 16-byte voices SfxVoiceA/SfxVoiceB (+00, +01, +0A, +0F unused).
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

; Fields in a loaded sound module (segment of SoundModuleSlot): the requested and
; the current music number, and a byte written only by an unreferenced routine.
MODULE_MUSIC_REQUEST equ 08h
MODULE_MUSIC_CURRENT equ 09h
MODULE_BYTE_0A equ 0Ah
