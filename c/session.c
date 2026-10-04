/* Continuous new-game/life/frame/game-over control over the original DOS state.
   The live BP/ES service pair travels explicitly through DosRegisters metadata.
   SEGMENT: CGAME
   OWNS: StartNewGame CompleteLevel AdvanceLevel StartLife GameFrame ResumeGameFrame
   OWNS: QuitPrompt GameOver ForceGameOver LoseLife
*/
#include "session.h"
#include "hiscore.h"
#include "dos.h"
#include "options.h"
#include "title.h"
#include "player.h"
#include "pods.h"
#include "life.h"
#include "presentation.h"
#include "levels.h"
#include "system.h"
#include "display.h"
#include "render.h"
#include "frame.h"
#include "screen_animation.h"
#include "screen_transition.h"

#ifndef OVERKILL_HOST
void reset_pool_a_and_upgrades(void);
word update_all_records(void);
void tick_refuel(void);
void scroll_map_to_level_start(Record *here);
void pause_game(void);
extern word __far MainDataSegment;
extern void CgaSelectBrightPalette1(void);
extern void ResetEgaPages(void);
extern void ResetPageAndClearScreen(void);
extern void ClearScreen104x200(void);
extern void ClearTimerTick(void);
extern void FlipEgaDrawPage(void);
extern void DrawFuelEmptyPanel(void);
extern void CopyWorkspaceToScreen(void);
extern void ShowEgaDrawPage(void);
extern void WaitTimerTick(void);
extern void FlushBiosKeyboardBuffer(void);
extern void SessionDrawQuitPrompt(void);
extern void WaitVerticalRetrace(void);
extern void MenuRequestMusic(void);
#else
#include "platform_services.h"
#include "level_content.h"
void reset_pool_a_and_upgrades(void);
word update_all_records(void);
void tick_refuel(void);
void scroll_map_to_level_start(Record *here);
void pause_game(void);
#endif

void run_game_session(word phase, word bp)
{
    DosRegisters registers;
    word frame, i;
    volatile byte *keys = (volatile byte *)KeyDownTable;
    registers.bp = bp;
    /* Session entry has no ES input; each segment-using service establishes its own. */
    registers.es = 0;
    for (;;) {
        switch (phase) {
        case SESSION_NEW_GAME:
            menu_call_si(MenuRequestMusic, MUSIC_TITLE);
            dos_service(CgaSelectBrightPalette1, &registers);
            dos_service(ResetEgaPages, &registers);
            run_options_menu();
            LevelIndex = 0;
            LivesLeft = INITIAL_LIVES;
            NewGameClearedWord = 0;
            GameOverRequest = 0;
            for (i = 0; i < 4; i++) ScoreBcd[i] = 0;
#ifdef OVERKILL_HOST
            if (!overkill_level_content_id())
#endif
            run_choose_screen(&registers);
            screen_animation_stretch_hud_panel(&registers);
            reset_pool_a_and_upgrades();
            EnergyTanks = 3;
            EnergyPoints = 0x18;
            display_draw_hud(&registers);
            phase = SESSION_ADVANCE_LEVEL;
            break;
        case SESSION_COMPLETE_LEVEL:
            if (LevelIndex == 0
#ifdef OVERKILL_HOST
                && !overkill_level_content_id()
#endif
            ) {
                show_win_screen_and_wait_primary();
                dos_service(ResetPageAndClearScreen, &registers);
                system_redraw_status_panel(&registers);
            }
            phase = SESSION_ADVANCE_LEVEL;
            break;
        case SESSION_ADVANCE_LEVEL:
#ifdef OVERKILL_HOST
            if (overkill_level_content_id()) {
                /* Single-content test launch repeats this content. Episodes will
                   own progression after the remaining selections are extracted. */
                LevelIndex = overkill_level_content_behavior_profile();
            } else
#endif
            {
                LevelIndex++;
                if (LevelIndex >= LEVEL_COUNT) LevelIndex = 0;
            }
            if (SfxEnabled != 0) SfxRequest = 4;
            dos_service(ResetEgaPages, &registers);
            dos_service(ClearScreen104x200, &registers);
            display_draw_hud(&registers);
            load_level_map(&registers);
            load_level_graphics(&registers);
            scroll_map_to_level_start(GAME_PTR(Record, registers.bp));
            phase = SESSION_START_LIFE;
            break;
        case SESSION_START_LIFE:
            if (LivesLeft == 0xFFFF) { phase = SESSION_GAME_OVER; break; }
            reset_records_for_life();
            registers.bp = GAME_OFFSET(PRIMARY);
            registers.es = MainDataSegment;
            tick_refuel();
            init_position_history();
            registers.bp = GAME_OFFSET(PRIMARY);
            registers.es = MainDataSegment;
            display_draw_hud(&registers);
            registers.bp = GAME_OFFSET(PRIMARY);
            store_apply_history_and_placement(PRIMARY);
            registers.es = MainDataSegment;
            registers.bp = update_all_records();
            RandomWordCursor = GAME_OFFSET(CreditRandomWords);
            display_apply_level_palette(&registers);
            reset_invader_formation();
            SegBossActive = 0;
            registers.es = request_life_start_music(registers.es);
            if (MapScrollPos == MAP_START_POS) show_level_intro(&registers);
            phase = SESSION_FRAME;
            break;
        case SESSION_FRAME:
            dos_service(ClearTimerTick, &registers);
            dos_service(FlipEgaDrawPage, &registers);
            registers.bp = render_draw_records_to_workspace();
            registers.es = WorkspaceSegment;
            if (Fuel == 0) dos_service(DrawFuelEmptyPanel, &registers);
            dos_service(CopyWorkspaceToScreen, &registers);
            registers.bp = render_restore_record_backgrounds();
            registers.es = WorkspaceSegment;
            registers.bp = update_player_frame(registers.bp);
            /* Requests use exact word equality and take effect before the record
               pass or timers, in this priority order. */
            if (NextLevelRequest == 1) { phase = SESSION_COMPLETE_LEVEL; break; }
            if (GameOverRequest == 1) { phase = SESSION_FORCE_GAME_OVER; break; }
            if (LifeLostRequest == 1) { phase = SESSION_LOSE_LIFE; break; }
            registers.bp = update_all_records();
            system_check_boss_key(&registers);
            frame_update_refuel_timers_and_score(&registers);
            if (LevelSkipEnabled != 0 && keys[SCAN_F4] == KEY_STATE_DOWN) {
                phase = SESSION_COMPLETE_LEVEL;
                break;
            }
            if (keys[SCAN_F10] == KEY_STATE_DOWN) pause_game();
            phase = keys[SCAN_ESC] == KEY_STATE_DOWN ? SESSION_QUIT_PROMPT : SESSION_RESUME_FRAME;
            break;
        case SESSION_RESUME_FRAME:
            dos_service(ShowEgaDrawPage, &registers);
            dos_service(WaitTimerTick, &registers);
            phase = SESSION_FRAME;
            break;
        case SESSION_QUIT_PROMPT:
            if (SfxEnabled != 0) SfxRequest = 0x1C;
            while (keys[SCAN_ESC] == KEY_STATE_DOWN) {
#ifdef OVERKILL_HOST
                overkill_platform_idle();
#endif
            }
            dos_service(FlushBiosKeyboardBuffer, &registers);
            dos_service(FlipEgaDrawPage, &registers);
            dos_service(SessionDrawQuitPrompt, &registers);
            dos_service(FlipEgaDrawPage, &registers);
            for (;;) {
                QuitAnswer = 'N';
                if (keys[SCAN_N] == KEY_STATE_DOWN) break;
                QuitAnswer = 'Y';
                if (keys[SCAN_Y] == KEY_STATE_DOWN) break;
#ifdef OVERKILL_HOST
                overkill_platform_idle();
#endif
            }
            if (SfxEnabled != 0) SfxRequest = 0x1C;
            QuitAnswer &= 0xDF;
            if (QuitAnswer != 'Y') { phase = SESSION_RESUME_FRAME; break; }
            if (SfxEnabled != 0) while (((volatile byte *)&SfxActive)[0] != 0) {
#ifdef OVERKILL_HOST
                overkill_platform_idle();
#endif
            }
            if (SfxEnabled != 0) SfxRequest = 1;
            phase = SESSION_GAME_OVER;
            break;
        case SESSION_GAME_OVER:
            dos_service(ResetEgaPages, &registers);
            screen_transition_with_sfx(&registers);
            screen_animation_stretch_end(&registers);
            for (frame = 0; frame < 150; frame++) dos_service(WaitVerticalRetrace, &registers);
            update_high_score_table();
            phase = SESSION_NEW_GAME;
            break;
        case SESSION_FORCE_GAME_OVER:
            LivesLeft = 0;
            phase = SESSION_LOSE_LIFE;
            break;
        case SESSION_LOSE_LIFE:
            reset_pool_a_and_upgrades();
            LivesLeft--;
            if (KeepLivesFlag != 0) LivesLeft++;
            if (SfxEnabled != 0) while (((volatile byte *)&SfxActive)[0] != 0) {
#ifdef OVERKILL_HOST
                overkill_platform_idle();
#endif
            }
            if (SfxEnabled != 0) SfxRequest = 2;
            phase = SESSION_START_LIFE;
            break;
        }
    }
}
