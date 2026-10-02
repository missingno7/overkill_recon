/* Reusable input policy over the original DOS state.
   Game-port timing and BIOS keyboard-buffer access stay as MAIN ASM leaves.
   SEGMENT: CGAME
   OWNS: PollInputBits PollJoystickInputBits ClearKeyDownTable
*/
#include "input_normalize.h"

#ifndef OVERKILL_HOST
extern void ReadGamePortAAxisCounts(void);
extern void ReadGamePortAButtonBits(void);
extern void FlushBiosKeyboardBuffer(void);
#endif

word input_read_x_count(main_routine target);
#pragma aux input_read_x_count "FarCallMainNearViaAX" far parm [ax] value [bx] modify exact [ax bx cx dx si]
word input_read_y_count(main_routine target);
#pragma aux input_read_y_count "FarCallMainNearViaAX" far parm [ax] value [cx] modify exact [ax bx cx dx si]
word input_read_button_bits(main_routine target);
#pragma aux input_read_button_bits "FarCallMainNearViaAX" far parm [ax] value [ax] modify exact [ax dx]
void input_flush_bios_buffer(main_routine target);
#pragma aux input_flush_bios_buffer "FarCallMainNearViaAX" far parm [ax] modify exact [ax bx cx dx si di es]

/* The keyboard IRQ writes KeyDownTable. Read every binding live, including
   repeated bindings; configured keys use bit 0, fixed keys use any nonzero byte. */
void poll_input_bits(void)
{
    byte *table;
    volatile byte *keys = (volatile byte *)KeyDownTable;
    word i;

    if (InputDeviceMode == INPUT_MODE_JOYSTICK) {
        poll_joystick_input_bits();
        return;
    }
    table = InputDeviceMode == INPUT_MODE_KEYS_B ? KeyBitScancodesB : KeyBitScancodesA;
    for (i = 0; i < KEY_BIT_SCANCODE_COUNT; i++)
        InputBits = (byte)((InputBits << 1) | (keys[table[i]] & 1));
    if (keys[SCAN_TAB] != KEY_STATE_UP) InputBits |= IN_BUTTON_SECONDARY;
    if (keys[SCAN_SPACE] != KEY_STATE_UP) InputBits |= IN_BUTTON_PRIMARY;
    if (keys[SCAN_UP] != KEY_STATE_UP) InputBits |= IN_YMINUS;
    if (keys[SCAN_DOWN] != KEY_STATE_UP) InputBits |= IN_YPLUS;
    if (keys[SCAN_LEFT] != KEY_STATE_UP) InputBits |= IN_XMINUS;
    if (keys[SCAN_RIGHT] != KEY_STATE_UP) InputBits |= IN_XPLUS;
}

/* Counts are unsigned words. The independent tests preserve the original behavior
   when corrupt/reversed thresholds make both directions true. */
void poll_joystick_input_bits(void)
{
    volatile byte *input = (volatile byte *)&InputBits;
    volatile word *button_select = (volatile word *)&JoyButtonSelect;
    volatile word *x_low = (volatile word *)&JoyXLowThreshold;
    volatile word *x_high = (volatile word *)&JoyXHighThreshold;
    volatile word *y_low = (volatile word *)&JoyYLowThreshold;
    volatile word *y_high = (volatile word *)&JoyYHighThreshold;
    word x, y, button1_mask, button2_mask, selected;
    byte port;

    *input = 0;
    *button_select = JOY_BUTTONS_PORT_A;

    x = input_read_x_count(ReadGamePortAAxisCounts);
    if (x < *x_low) *input |= IN_XMINUS;
    if (x > *x_high) *input |= IN_XPLUS;

    y = input_read_y_count(ReadGamePortAAxisCounts);
    if (y < *y_low) *input |= IN_YMINUS;
    if (y > *y_high) *input |= IN_YPLUS;

    port = (byte)input_read_button_bits(ReadGamePortAButtonBits);
    selected = *button_select;
    if (selected == JOY_BUTTONS_PORT_A) {
        button2_mask = GAME_PORT_A_BUTTON2;
        button1_mask = GAME_PORT_A_BUTTON1;
    } else {
        button2_mask = GAME_PORT_B_BUTTON2;
        button1_mask = GAME_PORT_B_BUTTON1;
    }
    if ((port & button2_mask) == 0) *input |= IN_BUTTON_SECONDARY;
    if ((port & button1_mask) == 0) *input |= IN_BUTTON_PRIMARY;
}

/* The BIOS buffer is outside the game state; only its DOS-facing flush remains ASM. */
void clear_key_down_table(void)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;
    word i;
    for (i = 0; i < KEY_DOWN_COUNT; i++) keys[i] = 0;
    input_flush_bios_buffer(FlushBiosKeyboardBuffer);
}
