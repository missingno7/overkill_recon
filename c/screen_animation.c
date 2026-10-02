/* Capture/header setup, stretch descriptor state and retrace progression are portable
   policy over the original workspace and CS descriptor words. The row capture and
   adapter drawers retain only their pixel transfers and EGA port sequences in ASM.

   SEGMENT: CGAME
   OWNS: CaptureAndCollapseScreen CaptureRow CaptureScreenRowCases CaptureScreenRowCga CaptureScreenRowEga CaptureScreenRowTandy CaptureRowDone
   OWNS: StretchInWindowImage StretchInTheEndImage StretchInImage StretchInHudPanel */
#include "screen_animation.h"

extern volatile word __far VideoAdapter;
extern word __far MainDataSegment;
extern word __far WorkspaceSegment;
extern volatile word __far ScreenSegment;
extern word __far TheEndSegment;
extern word __far PanelSegment;
extern word __far AdapterDrawHandlers[];
extern word __far PanelImageOffsets[];

extern volatile word __far StretchDest;
extern volatile word __far StretchSource;
extern volatile word __far StretchImageRows;
extern volatile word __far StretchRowBytes;
extern volatile word __far StretchShownRows;
extern volatile word __far StretchFlagA;
extern volatile word __far StretchFlagB;

extern void ResetPageAndClearScreen(void);
extern void CopyEgaPage0ToPage1(void);
extern void WaitVerticalRetrace(void);

typedef struct ScreenCaptureRowRequest {
    word screen_segment;
    word workspace_segment;
    word source_offset;
    word workspace_offset;
    word adapter;
    word state_segment;
} ScreenCaptureRowRequest;

typedef struct ScreenAnimationDrawRequest {
    word drawer;
    word source_segment;
    word screen_segment;
    word bp;
    word state_segment;
    word result_bp;
    word result_es;
} ScreenAnimationDrawRequest;

void __far screen_animation_platform_capture_row(ScreenCaptureRowRequest *request);
#pragma aux screen_animation_platform_capture_row parm [si] \
    modify exact [ax bx cx dx si di es]

void __far screen_animation_platform_finish_capture(word adapter);
#pragma aux screen_animation_platform_finish_capture parm [si] \
    modify exact [ax bx cx dx si di es]

void __far screen_animation_platform_draw(ScreenAnimationDrawRequest *request);
#pragma aux screen_animation_platform_draw parm [si] \
    modify exact [ax bx cx dx si di es]

word screen_animation_screen_offset(word row, word column_8px)
{
    word row_offset = ScreenRowOffsets[row];
    word adapter = VideoAdapter;

    if (adapter == VIDEO_CGA)
        return (word)(row_offset + (word)(column_8px << 1));
    if (adapter == VIDEO_EGA)
        return (word)(row_offset + column_8px);
    return (word)(row_offset + (word)(column_8px << 2));
}

void screen_animation_draw_frame(word adapter, word source_segment,
                                 DosRegisters *registers)
{
    ScreenAnimationDrawRequest request;

    request.drawer = AdapterDrawHandlers[adapter];
    request.source_segment = source_segment;
    request.screen_segment = ScreenSegment;
    request.bp = registers->bp;
    request.state_segment = MainDataSegment;
    request.result_bp = registers->bp;
    request.result_es = registers->es;
    screen_animation_platform_draw(&request);
    registers->bp = request.result_bp;
    registers->es = request.result_es;
}

/* Image dimensions and payload stay in the caller's segment. Only the original CS
   descriptor words persist between frames; StretchRowError remains pixel-backend scratch. */
void screen_animation_stretch_raw(ScreenAnimationImage *image)
{
    volatile word __far *header =
        (volatile word __far *)((__segment)(image->source_segment) :>
                                ((word __based(void) *)(image->source_offset)));
    DosRegisters registers;
    word rows = header[0];
    word row_bytes = header[1];

    StretchImageRows = rows;
    StretchRowBytes = row_bytes;
    StretchSource = (word)(image->source_offset + 4);
    StretchDest = image->destination_offset;
    StretchFlagA = 0;
    StretchFlagB = 0;
    StretchShownRows = 6;

    registers.bp = image->bp;
    registers.es = ScreenSegment;
    do {
        screen_animation_draw_frame(VideoAdapter, image->source_segment, &registers);
        dos_service(WaitVerticalRetrace, &registers);
        StretchShownRows = (word)(StretchShownRows + 2);
    } while (StretchShownRows != rows);

    image->bp = registers.bp;
    image->es = registers.es;
}

void screen_animation_capture_collapse(DosRegisters *registers)
{
    ScreenCaptureRowRequest request;
    volatile word __far *header;
    word adapter = VideoAdapter;
    word source = 0;
    word destination = 4;
    word row;
    word row_width = adapter == VIDEO_CGA ? CGA_SCREEN_ROW_BYTES :
                     adapter == VIDEO_EGA ? 4 * EGA_SCREEN_ROW_BYTES :
                                             TANDY_SCREEN_ROW_BYTES;

    request.screen_segment = ScreenSegment;
    request.workspace_segment = WorkspaceSegment;
    request.adapter = adapter;
    request.state_segment = MainDataSegment;
    header = (volatile word __far *)((__segment)(request.workspace_segment) :>
                                     ((word __based(void) *)0));
    header[0] = 0x00C8;
    header[1] = 0x0028;

    for (row = 0; row < 0x00C8; row++) {
        request.source_offset = source;
        request.workspace_offset = destination;
        screen_animation_platform_capture_row(&request);
        destination = (word)(destination + row_width);

        if (adapter == VIDEO_CGA) {
            source = (word)(source + CGA_BANK_BYTES);
            if ((source & (2 * CGA_BANK_BYTES)) != 0)
                source = (word)(source + 0xC000 + CGA_SCREEN_ROW_BYTES);
        } else if (adapter == VIDEO_EGA) {
            source = (word)(source + EGA_SCREEN_ROW_BYTES);
        } else {
            source = (word)(source + TANDY_BANK_BYTES);
            if ((source & (4 * TANDY_BANK_BYTES)) != 0)
                source = (word)(source + 0x8000 + TANDY_SCREEN_ROW_BYTES);
        }
    }

    screen_animation_platform_finish_capture(adapter);

    StretchImageRows = header[0];
    StretchRowBytes = header[1];
    StretchSource = 4;
    StretchDest = 0;
    StretchFlagA = 0;
    StretchFlagB = 0;

    registers->es = ScreenSegment;
    row = (word)(StretchImageRows - 2);
    do {
        StretchShownRows = row;
        screen_animation_draw_frame(adapter, request.workspace_segment, registers);
        dos_service(WaitVerticalRetrace, registers);
        /* The source uses DEC CX followed by LOOP, so each collapse frame consumes
           two rows from the next ShownRows value. */
        row = (word)(row - 1);
        row = (word)(row - 1);
    } while (row != 0);
}

void screen_animation_stretch_window(DosRegisters *registers)
{
    ScreenAnimationImage image;

    dos_service(ResetPageAndClearScreen, registers);
    image.source_segment = (word)(WorkspaceSegment + WIDE_PAGE_BYTES / 16 + 1);
    image.source_offset = 0;
    image.destination_offset = 0;
    image.bp = registers->bp;
    image.es = registers->es;
    screen_animation_stretch_raw(&image);
    registers->bp = image.bp;
    registers->es = image.es;
}

void screen_animation_stretch_end(DosRegisters *registers)
{
    ScreenAnimationImage image;

    dos_service(ResetPageAndClearScreen, registers);
    image.source_segment = TheEndSegment;
    image.source_offset = 0;
    image.destination_offset = screen_animation_screen_offset(0x004E, 0);
    image.bp = registers->bp;
    image.es = registers->es;
    screen_animation_stretch_raw(&image);
    registers->bp = image.bp;
    registers->es = image.es;
}

void screen_animation_stretch_hud_panel(DosRegisters *registers)
{
    ScreenAnimationImage image;

    dos_service(ResetPageAndClearScreen, registers);
    image.source_segment = PanelSegment;
    image.source_offset = PanelImageOffsets[PANEL_HUD_FRAME];
    /* MOV AX,01Bh supplies AH=row 0, AL=column 1Bh to the original helper. */
    image.destination_offset = screen_animation_screen_offset(0, 0x001B);
    image.bp = registers->bp;
    image.es = registers->es;
    screen_animation_stretch_raw(&image);
    registers->bp = image.bp;
    registers->es = image.es;
    dos_service(CopyEgaPage0ToPage1, registers);
}
