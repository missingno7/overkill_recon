; Modern startup/platform vocabulary, not historical module ownership or original names.
; CS-relative words apply only to code in the main 0000 frame. DS offsets require
; the game state segment.

; SS:SP after entry. The word at DS:A278 is separate data just above the stack.
INITIAL_STACK_TOP equ 0A278h
PSP_COMMAND_TAIL equ 080h
; InstallTimerVector08/RestoreTimerVector08 state: DS flag and the CS-resident
; far pointer (offset, segment) to the BIOS INT 08h handler, also chained by Interrupt08Handler.
SAVED_INT08 equ 0738h

; PSP:81h payload byte: nibble masks decide whether PSP:82h/83h override hiscore.dat.
LAUNCHER_OVERRIDE_SOUND equ 00Fh
LAUNCHER_OVERRIDE_VIDEO equ 0F0h
LAUNCHER_OVERRIDE_BOTH equ 0FFh

; CS word, PSP:82h clamped to 0..2 (values above 2 become 1). Indexes the BIOS
; mode table 04h/0Dh/09h and many CS jump tables; no later write is range-proven.
VIDEO_CGA equ 00h
VIDEO_EGA equ 01h
VIDEO_TANDY equ 02h
VIDEO_BIOS_MODE_TABLE equ 099C4h

; Load status. Save errors leave it unchanged.
FILE_STATUS_OK equ 00h
FILE_STATUS_OPEN_FAILED equ 01h
FILE_STATUS_READ_FAILED equ 02h

; hiscore.dat: ACh-byte block plus an additive checksum word, loaded at 144A:0000,
; copied to HISCORE_BLOCK. Its last 27 bytes from SAVED_SETTINGS are the settings
; that SaveSettingsToHiscoreBlock saves and LoadSettingsFromHiscoreBlock loads.
HISCORE_FILE_NAME equ 021C6h
; Paragraph offset, within the sound-module slot, of the buffer after the module area
; (segment 144A): hiscore.dat and the level map (ATTRIBUTE_SOURCE_SEGMENT) load there.
SLOT_BUFFER_PARAGRAPH equ 0428h
HISCORE_BLOCK equ 021D8h
HISCORE_BLOCK_BYTES equ 0ACh
SAVED_SETTINGS equ 02268h


; INT 21h function numbers (AH) used by the game and its sound modules.
DOS_CHAR_INPUT_NO_ECHO equ 007h
DOS_PRINT_STRING equ 009h
DOS_GET_DRIVE equ 019h
DOS_SET_VECTOR equ 025h
DOS_GET_VERSION equ 030h
DOS_GET_VECTOR equ 035h
DOS_CREATE_FILE equ 03Ch
DOS_OPEN_FILE equ 03Dh
DOS_CLOSE_FILE equ 03Eh
DOS_READ_FILE equ 03Fh
DOS_WRITE_FILE equ 040h
DOS_ALLOCATE_MEMORY equ 048h
DOS_FREE_MEMORY equ 049h
DOS_RESIZE_MEMORY equ 04Ah
DOS_GET_PSP equ 051h
DOS_ALLOC_STRATEGY equ 058h

; LoadPackedFile state, CS-resident in the main frame (DS=CS inside the loader).
PACKED_READ_BUFFER equ 0410h
PACKED_READ_BUFFER_BYTES equ 0200h
PACKED_READ_BUFFER_END equ 0610h

; $-terminated messages for ShowFatalErrorAndExit / ShowOutOfMemoryAndExit.
MSG_DEALLOC_ERROR equ 0FF6h
MSG_NOT_ENOUGH_MEMORY equ 01011h
