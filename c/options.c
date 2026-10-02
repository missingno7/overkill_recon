/* Menu selection, latches, key capture and level-choice input in the DOS state.
   Panel rendering, sound, retrace and game-port timing retain their ASM boundary.
   SEGMENT: CGAME
   OWNS: RunOptionsMenu DrawOptionsSelections PromptAndCaptureKeyBinding ReadChooseScreenInput
*/
#include "options.h"
#include "pages.h"
#include "player.h"
#include "title.h"
#include "calibration.h"
#include "system.h"

extern void DrawPanelAtPosition(void);
extern void MenuRequestMusic(void);
extern void MenuCallService(void);
extern void WaitVerticalRetrace(void);
extern void ShowBossKeyScreen(void);
extern void StopModuleMusic(void);
extern void ShutdownGame(void);

/* Presentation and calibration may use BP internally; the adapter keeps it. */
void menu_call_service(main_routine adapter, main_routine target);
#pragma aux menu_call_service "FarCallMainNearViaAX" far parm [ax] [dx] modify exact [ax bx cx dx si di es]
void menu_draw_panel(main_routine target, word position, word image);
#pragma aux menu_draw_panel "FarCallMainNearViaAX" far parm [ax] [dx] [si] modify exact [ax bx cx dx si di es]

void menu_call_platform(main_routine target)
{
    menu_call_service(MenuCallService, target);
}

void draw_options_selections(void)
{
    menu_draw_panel(DrawPanelAtPosition, 0x4109, 0x40 + (InputDeviceMode == INPUT_MODE_KEYS_A));
    menu_draw_panel(DrawPanelAtPosition, 0x5709, 0x42 + (InputDeviceMode == INPUT_MODE_JOYSTICK));
    menu_draw_panel(DrawPanelAtPosition, 0x4013, 0x44 + (InputDeviceMode == INPUT_MODE_KEYS_B));
    menu_draw_panel(DrawPanelAtPosition, 0x7A09, 0x46 + (SoundOption == 0));
    menu_draw_panel(DrawPanelAtPosition, 0x7A10, 0x48 + (SoundOption == 1));
    menu_draw_panel(DrawPanelAtPosition, 0x7A14, 0x4A + (SoundOption == 2));
    menu_draw_panel(DrawPanelAtPosition, 0x7C19, 0x4C + (SoundOption == 3));
}

/* The IRQ can replace the make-code mailbox between comparisons or before the
   final store. Read each use live, and wait for any nonzero key state to clear. */
void prompt_and_capture_key_binding(word image, byte *binding)
{
    volatile byte *make = (volatile byte *)&KeyLastMakeCode;
    volatile byte *keys = (volatile byte *)KeyDownTable;
    byte row = RedefPromptRow;
    byte scan;

    KeyLastMakeCode = 0;
    RedefPromptRow += 0x17;
    menu_draw_panel(DrawPanelAtPosition, ((word)row << 8) | 1, image);
    for (;;) {
        if (*make == 0) continue;
        if (*make == SCAN_F9) continue;
        if (*make == SCAN_F10) continue;
        if (*make == SCAN_ESC) continue;
        break;
    }
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    scan = *make;
    *binding = scan;
    while (keys[scan] != 0) {}
}

void run_options_menu(void)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;
    DosRegisters calibration_registers;
    word sound;

restart_menu:
    MenuShowingHiscores = 0;
redraw_menu:
    if (MenuShowingHiscores == 0) {
        system_wait_all_keys_released();
        show_pages((word)OkMenuPageList);
        draw_options_selections();
    }
redraw_page:
    if (MenuShowingHiscores != 0) show_scores();
    else draw_options_selections();
    MenuIdleFrames = 0;
poll_menu_keys:
    if (keys[SCAN_K] == KEY_STATE_DOWN) goto select_keys_a;
    if (keys[SCAN_J] == KEY_STATE_DOWN) goto select_joystick;
    if (keys[SCAN_A] == KEY_STATE_DOWN) goto select_keys_b;
    if (keys[SCAN_R] == KEY_STATE_DOWN) goto redefine_keys;
    if (keys[SCAN_M] == KEY_STATE_DOWN) goto cycle_sound;
    if (keys[SCAN_O] == KEY_STATE_DOWN) {
        show_pages((word)OPageList);
        goto restart_menu;
    }
    if (keys[SCAN_I] == KEY_STATE_DOWN) {
        show_pages((word)IPageList);
        goto restart_menu;
    }
    if (keys[SCAN_ESC] == KEY_STATE_DOWN) {
        menu_call_platform(ShutdownGame);
        return; /* DOS termination does not return. */
    }
    if (keys[SCAN_F9] == KEY_STATE_DOWN) {
        menu_call_platform(ShowBossKeyScreen);
        goto restart_menu;
    }
    MenuKeyLatchK = 0;
    MenuKeyLatchA = 0;
    MenuKeyLatchM = 0;
idle_frame:
    menu_call_platform(WaitVerticalRetrace);
    MenuIdleFrames++;
    if (MenuIdleFrames >= 0x2EE) {
        if (MenuShowingHiscores == 0) {
            MenuShowingHiscores = 1;
            goto redraw_menu;
        }
        run_attract_sequence();
        goto restart_menu;
    }
    poll_input_bits();
    if (InputBits == IN_BUTTON_PRIMARY) return;
    goto poll_menu_keys;

select_keys_a:
    if (MenuKeyLatchK == 1) goto idle_frame;
    MenuKeyLatchK = 1;
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    InputDeviceMode = INPUT_MODE_KEYS_A;
    if (MenuShowingHiscores != 0) goto restart_menu;
    goto redraw_page;
select_keys_b:
    if (MenuKeyLatchA == 1) goto idle_frame;
    MenuKeyLatchA = 1;
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    InputDeviceMode = INPUT_MODE_KEYS_B;
    if (MenuShowingHiscores != 0) goto restart_menu;
    goto redraw_page;
cycle_sound:
    if (MenuKeyLatchM == 1) goto idle_frame;
    MenuKeyLatchM = 1;
    SoundOption = (SoundOption + 1) & 3;
    sound = ((word *)SoundOptionFlags)[SoundOption];
    SfxEnabled = (byte)(sound >> 8);
    ModuleSoundEnabled = (byte)sound;
    if (ModuleSoundEnabled == 0) menu_call_platform(StopModuleMusic);
    menu_call_si(MenuRequestMusic, MUSIC_TITLE);
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    if (MenuShowingHiscores != 0) goto restart_menu;
    goto redraw_page;
select_joystick:
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    while (keys[SCAN_J] == KEY_STATE_DOWN) {}
    menu_call_platform(StopModuleMusic);
    /* The menu's frame pointer is incidental. Page loading does not read this
       input BP: its graphics decoder sets BP to the file flags before decode and
       returns the BP used by the page blitter. Keep the DOS register pair stable
       without exposing this C frame layout as an API. */
    calibration_registers.bp = 0;
    calibration_registers.es = 0;
    calibrate_joystick_with_abort(&calibration_registers);
    menu_call_si(MenuRequestMusic, ModuleSoundRequest);
    if (keys[SCAN_ESC] == KEY_STATE_DOWN) {
        if (SfxEnabled != 0) SfxRequest = 0x1C;
        while (keys[SCAN_ESC] == KEY_STATE_DOWN) {}
    } else {
        do { poll_input_bits(); } while (InputBits == IN_BUTTON_PRIMARY);
    }
    goto restart_menu;
redefine_keys:
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    while (keys[SCAN_R] == KEY_STATE_DOWN) {}
    show_pages((word)RedefPageList);
    RedefPromptRow = 0x3F;
    prompt_and_capture_key_binding(0x50, KeyBitScancodesA + KEY_SLOT_YMINUS);
    prompt_and_capture_key_binding(0x51, KeyBitScancodesA + KEY_SLOT_YPLUS);
    prompt_and_capture_key_binding(0x52, KeyBitScancodesA + KEY_SLOT_XMINUS);
    prompt_and_capture_key_binding(0x53, KeyBitScancodesA + KEY_SLOT_XPLUS);
    prompt_and_capture_key_binding(0x54, KeyBitScancodesA + KEY_SLOT_PRIMARY);
    prompt_and_capture_key_binding(0x55, KeyBitScancodesA + KEY_SLOT_SECONDARY);
    KeyBitScancodesB[KEY_SLOT_SECONDARY] = KeyBitScancodesA[KEY_SLOT_SECONDARY];
    InputDeviceMode = INPUT_MODE_KEYS_A;
    goto restart_menu;
}

/* Direction priority is X+, X-, Y-, Y+, then primary. A blocked direction
   continues polling, even when primary is also held. Only ChooseSlot's low byte
   is read and written; a stale high byte survives. */
void read_choose_screen_input(void)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;
    byte slot;

    while (keys[SCAN_D] == KEY_STATE_DOWN) {}
    do { poll_input_bits(); } while (InputBits != 0);
    for (;;) {
        if (keys[SCAN_D] == KEY_STATE_DOWN) {
            DifficultySetting++;
            if (DifficultySetting >= 3) DifficultySetting = 0;
            return;
        }
        poll_input_bits();
        slot = ((byte *)&ChooseSlot)[0];
        if ((InputBits & IN_XPLUS) != 0) {
            if (slot >= 3) continue;
            slot += 3;
        } else if ((InputBits & IN_XMINUS) != 0) {
            if (slot <= 2) continue;
            slot -= 3;
        } else if ((InputBits & IN_YMINUS) != 0) {
            if (slot == 0) continue;
            slot--;
        } else if ((InputBits & IN_YPLUS) != 0) {
            if (slot == 5) continue;
            slot++;
        } else {
            if ((InputBits & IN_BUTTON_PRIMARY) != 0) return;
            continue;
        }
        ((byte *)&ChooseSlot)[0] = slot;
        return;
    }
}
