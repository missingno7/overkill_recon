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
; UNKNOWN: not yet classified as code or data
    db 02h,00h,00h,00h,00h,00h,088h,03h,00h,00h

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