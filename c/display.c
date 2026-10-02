/* Reusable level-palette and HUD decisions over the original DOS state.
   Panel blits, gauge pixels, page flips and DAC/BIOS access remain ASM.

   SEGMENT: CGAME
   OWNS: ApplyLevelPalette ApplyCgaLevelPalette LevelCgaPaletteCases SetHiscoreRankColor
   OWNS: DrawScore DrawLevelNumber DrawLivesIcons DrawHud */
#include "display.h"
#include "render.h"
#include "text.h"

extern volatile word __far VideoAdapter;
extern void DrawPanelImageRow(void);
extern void FlipEgaDrawPage(void);
extern void CgaSelectBrightPaletteNoBurst(void);
extern void CgaSelectBrightPalette0(void);
extern void CgaSelectBrightPalette1(void);
extern void DisplayCgaPaletteDispatch(void);
extern void DisplayCallDacColor6(void);
extern void DisplayDrawLivesRow(void);

typedef struct DisplayLivesRow {
    word image_index;
    word copies;
    word screen_offset;
    word bp;
    word es;
    word calculate_position;
} DisplayLivesRow;

void display_call_dac_color6(main_routine target, DosRegisters *registers, word color_offset);
#pragma aux display_call_dac_color6 "FarCallMainNearViaAX" far parm [ax] [si] [di] \
    modify exact [ax bx cx dx si di es]

void display_call_lives_row(main_routine target, DisplayLivesRow *row);
#pragma aux display_call_lives_row "FarCallMainNearViaAX" far parm [ax] [si] \
    modify exact [ax bx cx dx si di es]

void display_service(DosRegisters *registers, main_routine target)
{
    dos_service(target, registers);
}

void display_set_hiscore_rank_color(void)
{
    HiscoreRankPrefix[4] = VideoAdapter == VIDEO_CGA ? 3 : 0x0A;
}

void display_apply_cga_level_palette(DosRegisters *registers)
{
    word selector_offset = (word)(LevelIndex << 1);
    main_routine selector;

    /* The original BX shift wraps at 16 bits before it indexes the CS table. */
    if (selector_offset > 10) {
        display_service(registers, DisplayCgaPaletteDispatch);
        return;
    }

    switch ((word)(selector_offset >> 1)) {
    case 0: selector = CgaSelectBrightPaletteNoBurst; break;
    case 1: selector = CgaSelectBrightPalette1; break;
    case 2: selector = CgaSelectBrightPalette0; break;
    case 3: selector = CgaSelectBrightPalette1; break;
    case 4: selector = CgaSelectBrightPaletteNoBurst; break;
    default: selector = CgaSelectBrightPalette0; break;
    }
    display_service(registers, selector);
}

void display_apply_level_palette(DosRegisters *registers)
{
    word color_offset;

    if (VideoAdapter == VIDEO_CGA) {
        display_apply_cga_level_palette(registers);
        return;
    }

    color_offset = LevelIndex == 1
        ? (word)DacColor6Level1 : (word)DacColor6Default;
    display_call_dac_color6(DisplayCallDacColor6, registers, color_offset);
}

void display_draw_score(DosRegisters *registers)
{
    registers->bp = (word)ScoreMessagePrefix;
    text_print_message(registers);
    /* DrawScore sets BP to ScoreBcd after printing the prefix and falls through. */
    registers->bp = (word)ScoreBcd;
    text_print_bcd32(registers);
}

void display_draw_level_number(DosRegisters *registers)
{
    byte character;

    registers->bp = (word)LevelNumberPrefix;
    text_print_message(registers);
    /* XLAT consumes AL only; high LevelIndex bits do not extend the table index. */
    character = LevelDigitChars[(byte)LevelIndex];
    text_emit_character(character, registers, 0);
}

void display_draw_lives_icons(DosRegisters *registers)
{
    DisplayLivesRow row;

    row.image_index = PANEL_SHIP_ICON;
    row.copies = LivesLeft;
    row.screen_offset = 0;
    row.bp = registers->bp;
    row.es = registers->es;
    row.calculate_position = 1;
    display_call_lives_row(DisplayDrawLivesRow, &row);
    registers->bp = row.bp;
    registers->es = row.es;

    row.image_index = PANEL_NO_SHIP_ICON;
    row.copies = (word)((word)3 - LivesLeft);
    row.calculate_position = 0;
    display_call_lives_row(DisplayDrawLivesRow, &row);
    registers->bp = row.bp;
    registers->es = row.es;
}

void display_draw_hud(DosRegisters *registers)
{
    display_draw_score(registers);
    if (VideoAdapter == VIDEO_EGA) {
        display_service(registers, FlipEgaDrawPage);
        display_draw_score(registers);
        display_service(registers, FlipEgaDrawPage);
    }

    display_draw_lives_icons(registers);
    if (VideoAdapter == VIDEO_EGA) {
        display_service(registers, FlipEgaDrawPage);
        display_draw_lives_icons(registers);
        display_service(registers, FlipEgaDrawPage);
    }

    {
        dword result = render_draw_energy_gauge();
        registers->es = (word)(result >> 16);
    }
    if (VideoAdapter == VIDEO_EGA) {
        display_service(registers, FlipEgaDrawPage);
        {
            dword result = render_draw_energy_gauge();
            registers->es = (word)(result >> 16);
        }
        display_service(registers, FlipEgaDrawPage);
    }

    display_draw_level_number(registers);
    if (VideoAdapter == VIDEO_EGA) {
        display_service(registers, FlipEgaDrawPage);
        display_draw_level_number(registers);
        display_service(registers, FlipEgaDrawPage);
    }
}
