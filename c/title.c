/* Title/attract control and the win-screen wait. Rendering and page loading retain
   their DOS interfaces; input and frame-count decisions use the original state.
   SEGMENT: CGAME
   OWNS: RunAttractSequence PlayTitleAnimation DelayFramesUntilKeyOrPrimary ShowWinScreenAndWaitPrimary
*/
#include "title.h"
#include "player.h"
#include "options.h"
#include "pages.h"
#include "presentation.h"
#include "title_reveal.h"
#ifdef OVERKILL_HOST
#include "platform_services.h"
#endif

#ifndef OVERKILL_HOST
extern void ResetPageAndClearScreen(void);
extern void CgaSelectBrightPalette0(void);
extern void CgaSelectBrightPalette1(void);
extern void DrawTitleBackdrop(void);
extern void CopyFullWorkspaceToScreen(void);
extern void WaitVerticalRetrace(void);
extern word __far BlueBitsSegment;
extern word __far BlueBitsImageOffsets[];
#endif

/* LOOP executes once even for CX = 0. A primary press sets the make-code mailbox
   but still waits that frame; the next iteration sees it, unless the count ended. */
word delay_frames_until_key_or_primary(word frames)
{
    do {
        if ((byte)KeyLastMakeCode != 0) return frames;
        poll_input_bits();
        if (InputBits & IN_BUTTON_PRIMARY) KeyLastMakeCode = SCAN_SPACE;
        menu_call_platform(WaitVerticalRetrace);
        frames--;
    } while (frames != 0);
    return frames;
}

void play_title_animation(void)
{
    word round;
    KeyLastMakeCode = 0;
    menu_call_platform(ResetPageAndClearScreen);
    menu_call_platform(CgaSelectBrightPalette0);
    menu_call_platform(DrawTitleBackdrop);
    menu_call_platform(CopyFullWorkspaceToScreen);
    if ((byte)KeyLastMakeCode != 0) return;
    delay_frames_until_key_or_primary(30);
    TitleLogoPiecePtr = GAME_OFFSET(TitleLogoPieces);
    for (round = 0; round < 3; round++) {
        stage_title_logo_pieces();
        reveal_title_logo_cells();
        if (round < 2 && (byte)KeyLastMakeCode != 0) return;
    }
    delay_frames_until_key_or_primary(50);
}

void run_attract_sequence(void)
{
    word frame;
    play_title_animation();
    menu_call_platform(ResetPageAndClearScreen);
    menu_call_platform(CgaSelectBrightPalette1);
    if ((byte)KeyLastMakeCode == 0)
        run_intro_pages_and_demo();
    for (frame = 0; frame < 30; frame++) menu_call_platform(WaitVerticalRetrace);
}

void show_win_screen_and_wait_primary(void)
{
    word frame;
    menu_call_platform(ResetPageAndClearScreen);
    show_pages(GAME_OFFSET(WinScreenPageList));
    for (frame = 0; frame < 75; frame++) menu_call_platform(WaitVerticalRetrace);
    do {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
        poll_input_bits();
    } while ((InputBits & IN_BUTTON_PRIMARY) == 0);
}
