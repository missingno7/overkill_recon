/* Startup ordering over the original CS/DS state and named DOS platform services.
   The PSP/stack/vector prologue remains in ProgramEntry's ASM body.
   SEGMENT: CGAME
   OWNS: StartupAfterOverrides
*/
#include "startup.h"
#include "levels.h"
#include "title.h"
#include "session.h"
#include "frame.h"
#include "display.h"
#include "screen_transition.h"
#include "screen_animation.h"

#ifndef OVERKILL_HOST
extern void EnableFileFlagsIfVgaDac(void);
extern void VerifyStartupChecksums(void);
extern void StartupInstallTimerVector08(void);
extern void InstallKeyboardVector09(void);
extern void SetupResourceArchive(void);
extern void MeasureRetracePolarity(void);
extern void StartupSetBestFitAllocStrategy(void);
extern void DetectFloppyDrives(void);
extern void DetectEms(void);
extern void LoadSoundModule(void);
extern void AllocateBuffers(void);
extern void BuildRowTables(void);
extern void WaitVerticalRetrace(void);
extern void StartupSetSelectedVideoMode(void);
extern void ResetPageAndClearScreen(void);

extern word __far WorkspaceSegment;
extern word __far LoadNamePtr;
extern word __far LoadDestSegment;
extern word __far LoadImageSlot;
extern word __far PlaqueImageOffset;
#endif

void startup_after_overrides(DosRegisters *registers)
{
    word frame;

    dos_service(EnableFileFlagsIfVgaDac, registers);
    dos_service(VerifyStartupChecksums, registers);
    dos_service(StartupInstallTimerVector08, registers);
    dos_service(InstallKeyboardVector09, registers);
    dos_service(SetupResourceArchive, registers);
    dos_service(MeasureRetracePolarity, registers);
    dos_service(StartupSetBestFitAllocStrategy, registers);
    dos_service(DetectFloppyDrives, registers);
    dos_service(DetectEms, registers);
    dos_service(LoadSoundModule, registers);
    dos_service(AllocateBuffers, registers);
    dos_service(BuildRowTables, registers);
    init_stars();
    display_set_hiscore_rank_color();
    load_common_graphics(registers);

    /* WINDOW.BIC is captured from the launcher's screen before mode selection.
       Its image offsets and destination remain the original loader mailboxes. */
    LoadNamePtr = GAME_OFFSET(File_WINDOW_BIC);
    LoadDestSegment = WorkspaceSegment + WIDE_PAGE_BYTES / 16 + 1;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_TOKEN_PLAQUEIMAGEOFFSET;
#else
    LoadImageSlot = (word)&PlaqueImageOffset;
#endif
    load_graphics_record_images(registers);
    screen_transition_and_clear(registers);
    screen_animation_stretch_window(registers);
    for (frame = 0; frame < 250; frame++)
        dos_service(WaitVerticalRetrace, registers);

    dos_service(StartupSetSelectedVideoMode, registers);
    TextInGraphics = 1;
    dos_service(ResetPageAndClearScreen, registers);
    /* The title owner is native C now. Its BP/ES entry values are dead by the
       first choose-screen render: that path resets pages and the graphics loader
       establishes its own decode and destination registers before drawing. */
    run_attract_sequence();
    /* SESSION_NEW_GAME does not consume stale BP before its loaders establish
       render metadata; the session reads the actual ES left by title/platform. */
    run_game_session(SESSION_NEW_GAME, registers->bp);
}
