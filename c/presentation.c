/* Intro/demo, level-choice and level-intro control over the original DOS state.
   Resource I/O, packed-pixel services and hardware waits retain their ASM boundary;
   reusable record/star drawing and message traversal use their native C regions.
   SEGMENT: CGAME
   OWNS: RunIntroPagesAndDemo RunChooseScreen DrawChooseScreen ShowLevelIntro DrawPlaqueImage
*/
#include "presentation.h"
#include "frame.h"
#include "life.h"
#include "options.h"
#include "player.h"
#include "pods.h"
#include "levels.h"
#include "system.h"
#include "render.h"
#include "text.h"
#ifdef OVERKILL_HOST
#include "platform_services.h"
#endif

extern word update_all_records(void);
extern void tick_frame_timers(void);
extern void reset_pool_a_and_upgrades(void);
extern void run_demo_script_frame(Record *bp);
void move_stars(void);

#ifndef OVERKILL_HOST
extern void ClearTimerTick(void);
extern void ClearWorkspace(void);
extern void CopyWorkspaceToScreen(void);
extern void CgaSelectBrightPalette1(void);
extern void DrawStatusPanel(void);
extern void FlipEgaDrawPage(void);
extern void PresentationDrawBonusPanel(void);
extern void PresentationDrawWorkspaceBackground(void);
extern void PresentationDrawImage(void);
extern void ResetEgaPages(void);
extern void ResetPageAndClearScreen(void);
extern void ShowEgaDrawPage(void);
extern void WaitTimerTick(void);
extern void WaitVerticalRetrace(void);
#endif

/* Loader state and render configuration live in the existing MAIN address frame. */
#ifndef OVERKILL_HOST
extern word __far LoadDestOffset;
extern word __far LoadDestSegment;
extern word __far LoadImageSlot;
extern word __far LoadNamePtr;
extern word __far ScreenImageOffset;
extern word __far ChooseImageOffsets[];
extern word __far WorkspaceSegment;
extern word __far PlaqueSegment;
extern byte __far CgaColorMap[];
extern volatile word __far VideoAdapter;
#endif

/* Carries SI into a MAIN service while keeping the same explicit BP/ES handoff as
   dos_service. The service leaves its resulting BP/ES in DX:AX. */
dword presentation_call_si_registers(main_routine target, word value, word bp, word es);
#ifdef OVERKILL_HOST
dword presentation_call_si_registers(main_routine target, word value, word bp, word es)
{
    HostRegisters registers = { 0 };
    registers.si = value;
    registers.bp = bp;
    registers.es = es;
    overkill_platform_call(target, &registers);
    return ((dword)registers.es << 16) | registers.bp;
}
#else
#pragma aux presentation_call_si_registers "PRESENTATION_CALL_SI_REGISTERS" \
    parm [ax] [cx] [si] [di] value [dx ax] \
    modify exact [ax bx cx dx si di es]
#endif

void presentation_service_si(main_routine target, word value, DosRegisters *registers)
{
    dword result = presentation_call_si_registers(target, value,
                                                   registers->bp, registers->es);
    registers->bp = (word)result;
    registers->es = (word)(result >> 16);
}

/* The pixel leaf receives CX = row/column, SI = packed-image offset and DI =
   source segment. BP and ES pass through the same explicit DOS register pair as
   the other MAIN services; BP remains a real renderer result, not scratch C state. */
dword presentation_call_image_registers(main_routine target, word position,
                                         word image, word source, word bp, word es);
#ifdef OVERKILL_HOST
dword presentation_call_image_registers(main_routine target, word position,
                                         word image, word source, word bp, word es)
{
    HostRegisters registers = { 0 };
    registers.cx = position;
    registers.si = image;
    registers.di = source;
    registers.bp = bp;
    registers.es = es;
    overkill_platform_call(target, &registers);
    return ((dword)registers.es << 16) | registers.bp;
}
#else
#pragma aux presentation_call_image_registers "PRESENTATION_CALL_IMAGE_REGISTERS" \
    parm [ax] [cx] [si] [di] [bx] [dx] value [dx ax] \
    modify exact [ax bx cx dx si di es]
#endif

void presentation_draw_image(DosRegisters *registers, word position,
                             word image, word source)
{
    dword result = presentation_call_image_registers(PresentationDrawImage,
                    position, image, source, registers->bp, registers->es);
    registers->bp = (word)result;
    registers->es = (word)(result >> 16);
}

/* Keep the chooser's model decisions here. Each call still enters the original
   adapter-specific packed-image blitter, and carries its BP/ES result forward. */
void draw_choose_screen(DosRegisters *registers)
{
    word slot = ChooseSlot;
    word difficulty = DifficultySetting;
    dos_service(PresentationDrawWorkspaceBackground, registers);
    presentation_draw_image(registers, ChooseSlotPositions[slot],
                            ChooseImageOffsets[slot], WorkspaceSegment);
    presentation_draw_image(registers, DifficultyPositions[difficulty],
                            ChooseImageOffsets[6 + difficulty], WorkspaceSegment);
}

/* Original DrawPlaqueImage coordinates: screen row 47h, 8-pixel column 3,
   first packed image in PlaqueSegment. */
void draw_plaque_image(DosRegisters *registers)
{
    presentation_draw_image(registers, 0x4703, 0, PlaqueSegment);
}

void run_intro_pages_and_demo(void)
{
    DosRegisters registers;
    word item, frame, i;
    volatile byte *keys = (volatile byte *)&KeyLastMakeCode;

    /* The entry has no BP/ES input. Later services that produce BP/ES are carried in
       this pair, especially RestoreRecordBackgrounds -> RunDemoScriptFrame. */
    registers.bp = 0;
    registers.es = 0;
    dos_service(ResetEgaPages, &registers);
    dos_service(ResetPageAndClearScreen, &registers);
    KeyLastMakeCode = 0;

    for (item = 0; item < 4; item++) {
        presentation_service_si(PresentationDrawBonusPanel, item, &registers);
        registers.bp = *GAME_PTR(word,
                         (word)(GAME_OFFSET(BonusIntroItems) + item * 4 + 2));
        text_print_message(&registers);
        for (frame = 0; frame < 100; frame++) {
            dos_service(WaitVerticalRetrace, &registers);
            poll_input_bits();
            if ((InputBits & IN_BUTTON_PRIMARY) != 0 || *keys != 0) goto exit_demo;
        }
    }

    DemoActive = 1;
    dos_service(ResetEgaPages, &registers);
    dos_service(ResetPageAndClearScreen, &registers);
    dos_service(CgaSelectBrightPalette1, &registers);
    dos_service(ClearWorkspace, &registers);
    reset_pool_a_and_upgrades();
    reset_records_for_life();
    ShotsLiveMain = 0;
    ShotsLiveType9 = 0;
    ShotsLiveSide = 0;
    ShotsLiveFrontPod = 0;
    MissilesLive = 0;
    MapScrollPos = MAP_START_POS;
    init_position_history();
    for (i = 0; i < BYTE_ATTRIBUTE_COUNT; i++) ByteAttributeTable[i] = 0;
    dos_service(DrawStatusPanel, &registers);
    registers.bp = GAME_OFFSET(PRIMARY);
    store_apply_history_and_placement(PRIMARY);
    registers.bp = update_all_records();
    DemoStep = 0;
    DemoStepTimer = 0x64;
    KeyLastMakeCode = 0;

    for (;;) {
        dos_service(ClearTimerTick, &registers);
        dos_service(FlipEgaDrawPage, &registers);
        registers.bp = render_draw_records_to_workspace();
        registers.es = WorkspaceSegment;
        dos_service(CopyWorkspaceToScreen, &registers);
        registers.bp = render_restore_record_backgrounds();
        registers.es = WorkspaceSegment;
        run_demo_script_frame(GAME_PTR(Record, registers.bp));
        registers.bp = update_all_records();
        tick_frame_timers();
        system_check_boss_key(&registers);
        dos_service(ShowEgaDrawPage, &registers);
        dos_service(WaitTimerTick, &registers);
        if (DemoStep == 0x13) break;
        poll_input_bits();
        if ((InputBits & IN_BUTTON_PRIMARY) != 0 || *keys != 0) break;
    }

exit_demo:
    DemoActive = 0;
    dos_service(ResetPageAndClearScreen, &registers);
    dos_service(ClearWorkspace, &registers);
}

void run_choose_screen(DosRegisters *registers)
{
    word selected;

    do {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
        poll_input_bits();
    } while ((InputBits & IN_BUTTON_PRIMARY) != 0);

    dos_service(ResetEgaPages, registers);

    LoadIsEnc = 1;
    LoadNamePtr = GAME_OFFSET(File_LEVSCR_ENC);
    LoadDestSegment = WorkspaceSegment;
    LoadDestOffset = 0x8000;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_TOKEN_SCREENIMAGEOFFSET;
#else
    LoadImageSlot = (word)&ScreenImageOffset;
#endif
    CgaColorMap[7] = 0;
    load_graphics_record_images(registers);
    CgaColorMap[7] = 1;

    LoadNamePtr = GAME_OFFSET(File_CHOOSE_ENC);
    LoadDestSegment = WorkspaceSegment;
    LoadDestOffset = 0x4000;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_TOKEN_CHOOSEIMAGEOFFSETS;
#else
    LoadImageSlot = (word)ChooseImageOffsets;
#endif
    ClearWorkspaceHalfOnly = 1;
    load_graphics_record_images(registers);
    ClearWorkspaceHalfOnly = 0;
    LoadIsEnc = 0;
    LoadDestOffset = 0;

    for (;;) {
        dos_service(ClearTimerTick, registers);
        dos_service(FlipEgaDrawPage, registers);
        draw_choose_screen(registers);
        dos_service(ShowEgaDrawPage, registers);
        dos_service(WaitVerticalRetrace, registers);
        read_choose_screen_input();
        if ((InputBits & IN_BUTTON_PRIMARY) != 0) break;
        dos_service(WaitTimerTick, registers);
    }

    selected = (word)(ChooseSlot + 1);
    if (selected == 6) selected = 0;
    LevelIndex = (word)(selected - 1);
}

void show_level_intro(DosRegisters *registers)
{
    for (;;) {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
        poll_input_bits();
        if ((InputBits & IN_BUTTON_PRIMARY) == 0) break;
    }
    dos_service(CopyWorkspaceToScreen, registers);
    LevelIntroFrames = 0;

    for (;;) {
        dos_service(ClearTimerTick, registers);
        dos_service(FlipEgaDrawPage, registers);
        render_draw_stars();
        registers->es = WorkspaceSegment;
        if (VideoAdapter == VIDEO_EGA)
            dos_service(CopyWorkspaceToScreen, registers);
        draw_plaque_image(registers);
        render_erase_stars();
        registers->es = WorkspaceSegment;
        move_stars();
        system_check_boss_key(registers);
        frame_update_refuel_timers_and_score(registers);
        dos_service(ShowEgaDrawPage, registers);
        dos_service(WaitTimerTick, registers);
        dos_service(WaitVerticalRetrace, registers);
        LevelIntroFrames++;
        if (LevelIntroFrames > 0xC8) break;
        poll_input_bits();
        if ((InputBits & IN_BUTTON_PRIMARY) != 0) break;
    }

    do {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
        poll_input_bits();
    } while ((InputBits & IN_BUTTON_PRIMARY) != 0);
}
