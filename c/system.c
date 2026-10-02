/* Reusable DOS input and prompt coordination over the original state.
   Presentation, BIOS video mode changes, and joystick polling remain platform services.
   SEGMENT: CGAME
   OWNS: CheckBossKey RedrawStatusPanel PromptLoadErrorWaitFire WaitAllKeysReleased
   OWNS: WaitInputReleased WaitInputPressed WaitInputClick
*/
#include "system.h"
#include "player.h"
#include "display.h"
#include "render.h"
#include "text.h"

extern void ShowBossKeyScreen(void);
extern void DrawStatusPanel(void);

void system_redraw_status_panel(DosRegisters *registers)
{
    dword rendered;

    dos_service(DrawStatusPanel, registers);
    if (DemoActive == 1) return;
    display_draw_hud(registers);
    /* The legacy gauge/slot leaves preserve BP and return their pixel cursor in DI/SI;
       only the high-word ES value belongs in this live DOS register pair. */
    rendered = render_draw_fuel_gauge();
    registers->es = (word)(rendered >> 16);
    rendered = render_draw_upgrade_slots();
    registers->es = (word)(rendered >> 16);
    display_apply_level_palette(registers);
}

void system_check_boss_key(DosRegisters *registers)
{
    if (((volatile byte *)KeyDownTable)[SCAN_F9] == KEY_STATE_DOWN)
        system_redraw_after_boss_key(registers);
}

void system_redraw_after_boss_key(DosRegisters *registers)
{
    dos_service(ShowBossKeyScreen, registers);
    system_redraw_status_panel(registers);
}

void system_prompt_load_error_wait_fire(DosRegisters *registers)
{
    volatile byte *input = (volatile byte *)&InputBits;
    word message = FileStatus == FILE_STATUS_OPEN_FAILED
        ? (word)SwapDisksMessage : (word)ReadErrorMessage;

    registers->bp = message;
    text_print_message(registers);
    do {
        poll_input_bits();
    } while (*input != IN_BUTTON_PRIMARY);
    do {
        poll_input_bits();
    } while (*input == IN_BUTTON_PRIMARY);
    registers->bp = (word)BlankMessage;
    text_print_message(registers);
}

void system_wait_all_keys_released(void)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;
    word i;
    byte any;

    do {
        any = 0;
        for (i = 0; i < KEY_DOWN_COUNT; i++) any |= keys[i];
    } while (any != 0);
}

void system_wait_input_released(void)
{
    volatile byte *input = (volatile byte *)&InputBits;
    do {
        poll_input_bits();
    } while (*input != 0);
}

void system_wait_input_pressed(void)
{
    volatile byte *input = (volatile byte *)&InputBits;
    do {
        poll_input_bits();
    } while (*input == 0);
}

void system_wait_input_click(void)
{
    system_wait_input_pressed();
    system_wait_input_released();
}
