; Modern input vocabulary, not historical module ownership or original names.
; DS offsets require the game state segment (CS:9596, relocated 15BC). PollJoystickInputBits and
; the IRQ handler at Interrupt09KeyboardHandler load it locally; other readers inherit caller DS.

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

; Word DS:0010 selects the PollInputBits source. Nonzero values other than 1/2 use table A.
INPUT_MODE_KEYS_A equ 00h
INPUT_MODE_JOYSTICK equ 01h
INPUT_MODE_KEYS_B equ 02h
; Eight scancodes each, collected by RCL into InputBits bits 7..0 in order,
; so slot n feeds bit 7-n. Table A initially holds Z,Space,Q,A,O,P for bits
; 5..0; the redefinition path 5752..578B rewrites its six slots through PromptAndCaptureKeyBinding,
; copies slot 2 to table B and selects mode KEYS_A. SaveSettingsToHiscoreBlock/CalibrateJoystickThresholds save/load A.
; Table B's other initial bytes (77h..7Ch) are not IBM set-1 keys; source unknown.
KEY_BIT_SCANCODES_A equ 0213Eh
KEY_BIT_SCANCODES_B equ 02146h
KEY_BIT_SCANCODE_COUNT equ 08h
KEY_SLOT_SECONDARY equ 02h
KEY_SLOT_PRIMARY equ 03h
KEY_SLOT_YMINUS equ 04h
KEY_SLOT_YPLUS equ 05h
KEY_SLOT_XMINUS equ 06h
KEY_SLOT_XPLUS equ 07h

; InstallKeyboardVector09 saves the previous INT 09h vector here (segment word, then offset); RestoreKeyboardVector09 restores it.
KBD_SAVED_INT09 equ 0213Ah
; Interrupt09KeyboardHandler stores each make code and sets/clears one byte per scancode.
KEY_DOWN_TABLE equ 098C4h
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
SCAN_RELEASE_BIT equ 080h
SCAN_CODE_MASK equ 07Fh

; Word DS:0012; PollJoystickInputBits writes 1 before testing it, so port-B buttons are unreached there.
JOY_BUTTONS_PORT_A equ 01h
; Calibration CalibrateJoystickThresholds stores three samples; thresholds are unsigned midpoints of
; LOW/CENTER and CENTER/HIGH. Sample roles follow that arithmetic only.
JOY_THRESHOLD_WORDS equ 04h
