/* Pause/resume control and typed cheat sequences; DOS drawing and beep stay ASM.
   SEGMENT: CGAME
   OWNS: PauseGame CheckCheatCodes CheckCheatWhatOilShortage CheckCheatLifeInTheFastLane
   OWNS: CheckCheatBonusCheatOn CheckCheatMyNameIsSmith CheckCheatSchnellfeuer
   OWNS: CheckCheatRemindMe CheckCheatEveryDayIDie MatchCheatKey
*/
#include "game.h"
#include "player.h"
#ifdef OVERKILL_HOST
#include "platform_services.h"
#include <stdlib.h>
#endif

#ifndef OVERKILL_HOST
extern void FlipEgaDrawPage(void);
extern void BiosBeep(void);
extern void DrawPanelAtPosition(void);
#endif
void pause_call_platform(main_routine target);
#ifdef OVERKILL_HOST
void pause_call_platform(main_routine target)
{
    HostRegisters registers = { 0 };
    overkill_platform_call(target, &registers);
}
#else
#pragma aux pause_call_platform "FarCallMainNearViaAX" far parm [ax] modify exact [ax bx cx dx si di es]
#endif
void pause_draw_panel(main_routine target, word position, word image);
#ifdef OVERKILL_HOST
void pause_draw_panel(main_routine target, word position, word image)
{
    HostRegisters registers = { 0 };
    registers.dx = position;
    registers.si = image;
    overkill_platform_call(target, &registers);
}
#else
#pragma aux pause_draw_panel "FarCallMainNearViaAX" far parm [ax] [dx] [si] modify exact [ax bx cx dx si di es]
#endif

/* A mismatch consumes the key and resets the cursor without retrying it.
   Completion leaves the cursor on the terminator, rather than restarting it. */
word match_cheat_key(word *entry)
{
    byte *cursor = GAME_PTR(byte, *entry);

    if (((volatile byte *)&KeyLastMakeCode)[0] != *cursor) {
        *entry = (word)(GAME_OFFSET(entry) + 2);
        return 0;
    }
    (*entry)++;
    if (cursor[1] != 0) return 0;
    pause_call_platform(BiosBeep);
    return 1;
}

void set_all_cheat_flags(byte value)
{
    WhatOilShortageFlag = value;
    KeepLivesFlag = value;
    BonusKeysEnabled = value;
    LevelSkipEnabled = value;
    RapidFireEnabled = value;
    AllCheatsFlag = value;
}

/* Each matcher reads the IRQ-owned make code afresh; order matters when several
   cursors finish on the same key, particularly the all-on/all-off sequences. */
void check_cheat_codes(void)
{
    if (((volatile byte *)&KeyLastMakeCode)[0] == 0) return;
    if (match_cheat_key(&CheatRemindMe)) set_all_cheat_flags(1);
    if (match_cheat_key(&CheatEveryDayIDie)) set_all_cheat_flags(0);
    if (match_cheat_key(&CheatWhatOilShortage)) WhatOilShortageFlag = 1;
    if (match_cheat_key(&CheatLifeInTheFastLane)) KeepLivesFlag = 1;
    if (match_cheat_key(&CheatBonusCheatOn)) BonusKeysEnabled = 1;
    if (match_cheat_key(&CheatMyNameIsSmith)) LevelSkipEnabled = 1;
    if (match_cheat_key(&CheatGibStMirSchnellfeuer)) RapidFireEnabled = 1;
    KeyLastMakeCode = 0;
}

void pause_game(void)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;

    if (SfxEnabled != 0) SfxRequest = 0x1C;
    while (keys[SCAN_F10] == KEY_STATE_DOWN) {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
    }
    pause_call_platform(FlipEgaDrawPage);
    pause_draw_panel(DrawPanelAtPosition, 0x4804, PANEL_PAUSE_UPPER);
    pause_draw_panel(DrawPanelAtPosition, 0x7004, PANEL_PAUSE_LOWER);
    pause_call_platform(FlipEgaDrawPage);
    KeyLastMakeCode = 0;
    for (;;) {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
        check_cheat_codes();
        poll_input_bits();
        if (InputBits == IN_BUTTON_PRIMARY || keys[SCAN_F10] == KEY_STATE_DOWN) break;
    }
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    while (keys[SCAN_F10] == KEY_STATE_DOWN) {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
    }
}
