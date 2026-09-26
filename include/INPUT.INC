; Input constants: InputBits flags, input modes, key tables, scancodes (modern names).

; InputBits (DATA.ASM) is rebuilt by PollInputBits (keyboard) or PollJoystickInputBits (joystick).
; Movement bits match keyboard table A (P,O,A,Q) and the fixed arrow keys.
IN_XPLUS equ 01h
IN_XMINUS equ 02h
IN_YPLUS equ 04h
IN_YMINUS equ 08h
INPUT_MOVEMENT_MASK equ 00Fh
; Space/joystick button 1 and Tab/joystick button 2; gameplay roles unclaimed.
IN_BUTTON_PRIMARY equ 010h
IN_BUTTON_SECONDARY equ 020h

; InputDeviceMode values.
INPUT_MODE_KEYS_A equ 00h
INPUT_MODE_JOYSTICK equ 01h
INPUT_MODE_KEYS_B equ 02h
; KeyBitScancodesA/B: entries per table, and the slot feeding each InputBits bit.
KEY_BIT_SCANCODE_COUNT equ 08h
KEY_SLOT_SECONDARY equ 02h
KEY_SLOT_PRIMARY equ 03h
KEY_SLOT_YMINUS equ 04h
KEY_SLOT_YPLUS equ 05h
KEY_SLOT_XMINUS equ 06h
KEY_SLOT_XPLUS equ 07h

; KeyDownTable entries and their values.
KEY_DOWN_COUNT equ 080h
KEY_STATE_UP equ 00h
KEY_STATE_DOWN equ 01h

; IBM PC scancode set 1, named by US key position. Game meanings unclaimed.
SCAN_ESC equ 01h
SCAN_3 equ 04h
SCAN_BACKSPACE equ 0Eh
SCAN_TAB equ 0Fh
SCAN_R equ 013h
SCAN_Y equ 015h
SCAN_I equ 017h
SCAN_O equ 018h
SCAN_ENTER equ 01Ch
SCAN_A equ 01Eh
SCAN_D equ 020h
SCAN_J equ 024h
SCAN_K equ 025h
SCAN_X equ 02Dh
SCAN_N equ 031h
SCAN_M equ 032h
SCAN_ALT equ 038h
SCAN_SPACE equ 039h
SCAN_F4 equ 03Eh
SCAN_F9 equ 043h
SCAN_F10 equ 044h
SCAN_UP equ 048h
SCAN_PGUP equ 049h
SCAN_LEFT equ 04Bh
SCAN_RIGHT equ 04Dh
SCAN_DOWN equ 050h
SCAN_PGDN equ 051h
SCAN_B equ 30h
SCAN_C equ 2Eh
SCAN_E equ 12h
SCAN_F equ 21h
SCAN_G equ 22h
SCAN_H equ 23h
SCAN_L equ 26h
SCAN_P equ 19h
SCAN_Q equ 10h
SCAN_S equ 1Fh
SCAN_T equ 14h
SCAN_U equ 16h
SCAN_V equ 2Fh
SCAN_W equ 11h
SCAN_Z equ 2Ch
SCAN_RELEASE_BIT equ 080h
SCAN_CODE_MASK equ 07Fh

; JoyButtonSelect value, and the number of calibration threshold words.
JOY_BUTTONS_PORT_A equ 01h
JOY_THRESHOLD_WORDS equ 04h
