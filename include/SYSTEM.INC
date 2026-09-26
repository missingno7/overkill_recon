; Startup, DOS and platform constants (modern names).

; Size of StackArea below StackTop.
STACK_BYTES equ 0200h
PSP_COMMAND_TAIL equ 080h

; PSP:81h payload byte: nibble masks decide whether PSP:82h/83h override hiscore.dat.
LAUNCHER_OVERRIDE_SOUND equ 00Fh
LAUNCHER_OVERRIDE_VIDEO equ 0F0h
LAUNCHER_OVERRIDE_BOTH equ 0FFh

; VideoAdapter values.
VIDEO_CGA equ 00h
VIDEO_EGA equ 01h
VIDEO_TANDY equ 02h

; Load status. Save errors leave it unchanged.
FILE_STATUS_OK equ 00h
FILE_STATUS_OPEN_FAILED equ 01h
FILE_STATUS_READ_FAILED equ 02h

; Paragraph offset, within the sound-module slot, of the buffer after the module area
; (segment 144A): hiscore.dat and the level map (AttributeSourceSegment) load there.
SLOT_BUFFER_PARAGRAPH equ 0428h
; Size of HiscoreBlock (the checksum word follows it in hiscore.dat).
HISCORE_BLOCK_BYTES equ 0ACh

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

; Size of LoadPackedFile's read buffer (PackedReadBuffer).
PACKED_READ_BUFFER_BYTES equ 0200h

; FileCache entries: file name pointer, buffer segment (FFFF = held in EMS), byte
; count, and for EMS the handle and page count (16 KiB pages).
FILE_CACHE_ENTRIES equ 58
FILE_CACHE_ENTRY_BYTES equ 0Ah
CACHE_NAME equ 0
CACHE_SEGMENT equ 2
CACHE_BYTES equ 4
CACHE_EMS_HANDLE equ 6
CACHE_EMS_PAGES equ 8
; Text control codes in printed messages: set colour (next byte), move to row and
; column (next two bytes).
TEXT_SET_COLOR equ 10h
TEXT_MOVE_TO equ 11h
