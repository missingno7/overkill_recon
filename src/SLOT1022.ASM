; Everything in segment frame SLOT1022; modern file boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
SLOT1022 segment para public 'CODE'
assume cs:SLOT1022,ds:nothing,ss:nothing,es:nothing
public SoundModuleInitEntry
public SoundModuleSlot
public SoundModuleTickEntry
SoundModuleSlot:
SoundModuleTickEntry:
    call loc_10232
    retf

SoundModuleInitEntry:
    call loc_10232
    retf
; Header fields at +8 as in a loaded module: MODULE_MUSIC_REQUEST (with the current
; music in its high byte), two unused words here, the OPL2 base port 388h at +0Eh, and a
; final word; the stub keeps these defaults.
    dw 2, 0, 0, 388h, 0

loc_10232:
    ret
; Space the loaded ADLIB.ENC or ROLAND.ENC image overwrites (both end below
; SlotBuffer). Zero in the image.
    db SLOT_BUFFER_PARAGRAPH * 16 - ($ - SoundModuleSlot) dup (0)
; Load buffer at paragraph SLOT_BUFFER_PARAGRAPH of the slot: receives hiscore.dat
; (LoadHiscoreFile) and the level map (the segment in LevelMapSegment).
SlotBuffer db 0EA0h dup (0)
SLOT1022 ends
end