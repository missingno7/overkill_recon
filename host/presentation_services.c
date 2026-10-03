/* Native implementations of the DOS title, text, and packed-image services.
   Persistent game fields remain in the generated DS/CS views; the only static state
   here is the host presenter mode needed to display a DOS text page. */
#include "presentation_services.h"

#include "memory.h"
#include "render_services.h"
#include "sdl_video.h"
#include "../third_party/font8x8/font8x8_cp437.h"

#include <stdlib.h>
#include <string.h>

static int text_page_active;
static int text_cursor_visible = 1;
static word text_cursor_row;
static word text_cursor_column;
static word cga_palette_select;
static word cga_intensity;
static word cga_colour_burst;

static void set_text_palette(void);

static byte segment_read_byte(word segment, word offset)
{
    return *(volatile byte *)overkill_segment_address(segment, offset);
}

static void segment_write_byte(word segment, word offset, byte value)
{
    *(volatile byte *)overkill_segment_address(segment, offset) = value;
}

static word segment_read_word(word segment, word offset)
{
    byte lo = segment_read_byte(segment, offset);
    byte hi = segment_read_byte(segment, (word)(offset + 1));
    return (word)(lo | ((word)hi << 8));
}

static void segment_write_word(word segment, word offset, word value)
{
    segment_write_byte(segment, offset, (byte)value);
    segment_write_byte(segment, (word)(offset + 1), (byte)(value >> 8));
}

static void segment_copy(word source_segment, word source_offset,
                         word destination_segment, word destination_offset,
                         word count)
{
    word i;
    for (i = 0; i != count; ++i)
        segment_write_byte(destination_segment, (word)(destination_offset + i),
                           segment_read_byte(source_segment, (word)(source_offset + i)));
}

static word row_column_offset(word row_column, word adapter, word wide)
{
    word row = (word)(row_column >> 8);
    word column = (byte)row_column;
    word *table = wide ? WideRowOffsets : ScreenRowOffsets;
    word base = table[row];
    word scale = adapter == VIDEO_CGA ? 2 : adapter == VIDEO_EGA ? 1 : 4;
    return (word)(base + (word)(column * scale));
}

static word cs_word(word offset)
{
    return segment_read_word(HOST_LOAD_SEGMENT, offset);
}

static word panel_image_offset(word image_index)
{
    return cs_word((word)(HOST_TOKEN_PANELIMAGEOFFSETS + image_index * 2));
}

static word blue_bits_image_offset(word image_index)
{
    return cs_word((word)(HOST_TOKEN_BLUEBITSIMAGEOFFSETS + image_index * 2));
}

static void blit_screen_image(word source_segment, word source_offset,
                              word screen_offset)
{
    RenderPanelRequest request;
    request.image_offset = source_offset;
    request.screen_offset = screen_offset;
    request.source_segment = source_segment;
    request.state_segment = MainDataSegment;
    (void)render_platform_blit_panel(&request);
}

/* BlitPackedStride160 writes a full-width 160-byte logical row to the wide
   workspace page, retaining the adapter's packed image layout. */
static void blit_wide_image(word source_segment, word source_offset,
                            word destination_offset)
{
    word rows = segment_read_word(source_segment, source_offset);
    word width = segment_read_word(source_segment, (word)(source_offset + 2));
    word source = (word)(source_offset + 4);
    word row;
    word adapter = VideoAdapter;

    if (adapter == VIDEO_EGA) {
        for (row = 0; row != rows; ++row) {
            word plane;
            for (plane = 0; plane != 4; ++plane) {
                word byte_index;
                for (byte_index = 0; byte_index != width; ++byte_index)
                    segment_write_byte(WorkspaceSegment,
                        (word)(destination_offset + plane * EGA_WIDE_PLANE_ROW_BYTES + byte_index),
                        segment_read_byte(source_segment, (word)(source + byte_index)));
                source = (word)(source + width);
            }
            destination_offset = (word)(destination_offset + EGA_WIDE_ROW_BYTES);
        }
    } else {
        word row_bytes = (word)(width * (adapter == VIDEO_CGA ? 2 : 4));
        word row_stride = adapter == VIDEO_CGA ? CGA_WIDE_ROW_BYTES : TANDY_WIDE_ROW_BYTES;
        for (row = 0; row != rows; ++row) {
            segment_copy(source_segment, source, WorkspaceSegment,
                         destination_offset, row_bytes);
            source = (word)(source + row_bytes);
            destination_offset = (word)(destination_offset + row_stride);
        }
    }
}

static void draw_fuel_empty_panel(HostRegisters *registers)
{
    word source = panel_image_offset(PANEL_FUEL_EMPTY);
    word rows = segment_read_word(PanelSegment, source);
    word width = segment_read_word(PanelSegment, (word)(source + 2));
    word planes = VideoAdapter == VIDEO_EGA ? 4 : 1;
    word row_bytes = VideoAdapter == VIDEO_CGA ? (word)(width * 2) :
                     VideoAdapter == VIDEO_TANDY ? (word)(width * 4) : width;
    word plane_stride = VideoAdapter == VIDEO_EGA ? EGA_PLANE_ROW_BYTES : 0;
    word row_stride = PlayfieldRowBytes;
    word column_bytes = VideoAdapter == VIDEO_CGA ? 8 :
                        VideoAdapter == VIDEO_TANDY ? 16 : 4;
    word destination = (word)(PlayfieldRowOffsets[0x58] + column_bytes + ScrollWindowOffset);
    uint32_t row, count = rows ? rows : 0x10000u;
    source = (word)(source + 4);
    for (row = 0; row < count; ++row) {
        word plane;
        for (plane = 0; plane < planes; ++plane) {
            segment_copy(PanelSegment, source, WorkspaceSegment,
                         (word)(destination + plane * plane_stride), row_bytes);
            source = (word)(source + row_bytes);
        }
        destination = (word)(destination + row_stride);
    }
    registers->bp = row_bytes;
    registers->es = WorkspaceSegment;
}

void presentation_draw_panel(word row_column, word image_index)
{
    word offset = row_column_offset(row_column, VideoAdapter, 0);
    blit_screen_image(PanelSegment, panel_image_offset(image_index), offset);
}

void presentation_draw_panel_row(word image_index, word copies,
                                 word screen_offset, word *result_screen_offset)
{
    word copy;
    word image = panel_image_offset(image_index);
    word step = VideoAdapter == VIDEO_CGA ? 2 :
                VideoAdapter == VIDEO_EGA ? 1 : 4;

    for (copy = 0; copy != copies; ++copy) {
        blit_screen_image(PanelSegment, image, screen_offset);
        screen_offset = (word)(screen_offset + 2 * step);
    }
    *result_screen_offset = screen_offset;
}

static void copy_full_workspace_to_screen(void)
{
    word row;
    word source = 0;
    word destination = 0;
    word adapter = VideoAdapter;
    word screen_segment = ScreenSegment;

    for (row = 0; row != 200; ++row) {
        if (adapter == VIDEO_EGA) {
            word plane;
            for (plane = 0; plane != 4; ++plane) {
                word column;
                for (column = 0; column != EGA_SCREEN_ROW_BYTES; ++column)
                    *overkill_ega_plane_address(screen_segment, plane,
                        (word)(destination + column)) =
                        segment_read_byte(WorkspaceSegment,
                            (word)(source + plane * EGA_WIDE_PLANE_ROW_BYTES + column));
            }
            source = (word)(source + EGA_WIDE_ROW_BYTES);
            destination = (word)(destination + EGA_SCREEN_ROW_BYTES);
        } else {
            word bytes = adapter == VIDEO_CGA ? CGA_SCREEN_ROW_BYTES :
                                                 TANDY_SCREEN_ROW_BYTES;
            segment_copy(WorkspaceSegment, source, screen_segment, destination, bytes);
            source = (word)(source + (adapter == VIDEO_CGA ? CGA_WIDE_ROW_BYTES :
                                                             TANDY_WIDE_ROW_BYTES));
            if (adapter == VIDEO_CGA) {
                destination = (word)(destination + CGA_BANK_BYTES);
                if ((destination & (2 * CGA_BANK_BYTES)) != 0)
                    destination = (word)(destination + CGA_SCREEN_ROW_BYTES -
                                         2 * CGA_BANK_BYTES);
            } else {
                destination = (word)(destination + TANDY_BANK_BYTES);
                if ((destination & (4 * TANDY_BANK_BYTES)) != 0)
                    destination = (word)(destination + TANDY_SCREEN_ROW_BYTES -
                                         4 * TANDY_BANK_BYTES);
            }
        }
    }
}

static void copy_ega_page0_to_page1(void)
{
    word plane;
    word offset;
    for (plane = 0; plane != 4; ++plane)
        for (offset = 0; offset != EGA_PAGE_BYTES; ++offset)
            *overkill_ega_plane_address(0xA200, plane, offset) =
                *overkill_ega_plane_address(0xA000, plane, offset);
}

void presentation_title_draw_logo_piece(word row_column, word image_index)
{
    word destination = (word)(WIDE_PAGE_BYTES +
                              row_column_offset(row_column, VideoAdapter, 1));
    blit_wide_image(BlueBitsSegment, blue_bits_image_offset(image_index), destination);
}

void presentation_title_draw_backdrop(void)
{
    word row;
    blit_wide_image(BlueBitsSegment, blue_bits_image_offset(0x0F), 0);
    for (row = 0x12; row != 0; --row) {
        word row_pixels = (word)(row * 10);
        word position = (word)(row_pixels << 8);
        blit_wide_image(BlueBitsSegment, blue_bits_image_offset(0x10),
                        row_column_offset(position, VideoAdapter, 1));
    }
    blit_wide_image(BlueBitsSegment, blue_bits_image_offset(0x11),
                    row_column_offset(0xBE00, VideoAdapter, 1));
    segment_copy(WorkspaceSegment, 0, WorkspaceSegment, WIDE_PAGE_BYTES,
                 WIDE_PAGE_BYTES);
}

word presentation_title_merge_reveal_cell(void)
{
    word adapter = VideoAdapter;
    word destination = row_column_offset((word)(((word)RevealRow << 8) | RevealCol),
                                         adapter, 1);
    word source = (word)(destination + WIDE_PAGE_BYTES);
    word changed = 0;
    word row;

    RevealCellOffset = destination;
    if (adapter == VIDEO_EGA) {
        for (row = 0; row != 4 * 8; ++row) {
            byte value = segment_read_byte(WorkspaceSegment,
                                           (word)(source + row * EGA_WIDE_PLANE_ROW_BYTES));
            word at = (word)(destination + row * EGA_WIDE_PLANE_ROW_BYTES);
            if (segment_read_byte(WorkspaceSegment, at) != value) {
                changed = 1;
                segment_write_byte(WorkspaceSegment, at, value);
            }
        }
    } else {
        word bytes = adapter == VIDEO_CGA ? 2 : 4;
        word stride = adapter == VIDEO_CGA ? CGA_WIDE_ROW_BYTES : TANDY_WIDE_ROW_BYTES;
        for (row = 0; row != 8; ++row) {
            word column;
            for (column = 0; column != bytes; ++column) {
                byte value = segment_read_byte(WorkspaceSegment,
                                               (word)(source + row * stride + column));
                word at = (word)(destination + row * stride + column);
                if (segment_read_byte(WorkspaceSegment, at) != value) {
                    changed = 1;
                    segment_write_byte(WorkspaceSegment, at, value);
                }
            }
        }
    }
    return changed;
}

static word cga_next_screen_row(word offset)
{
    offset = (word)(offset + CGA_BANK_BYTES);
    if ((offset & (2 * CGA_BANK_BYTES)) != 0)
        offset = (word)(offset + CGA_SCREEN_ROW_BYTES - 2 * CGA_BANK_BYTES);
    return offset;
}

static word tandy_next_screen_row(word offset)
{
    offset = (word)(offset + TANDY_BANK_BYTES);
    if ((offset & (4 * TANDY_BANK_BYTES)) != 0)
        offset = (word)(offset + TANDY_SCREEN_ROW_BYTES - 4 * TANDY_BANK_BYTES);
    return offset;
}

void presentation_title_flash_reveal_cell(void)
{
    word position = (word)(((word)RevealRow << 8) | RevealCol);
    blit_screen_image(BlueBitsSegment, blue_bits_image_offset(0x12),
                      row_column_offset(position, VideoAdapter, 0));
}

void presentation_title_show_reveal_cell(void)
{
    word adapter = VideoAdapter;
    word source = RevealCellOffset;
    word destination = row_column_offset((word)(((word)RevealRow << 8) | RevealCol),
                                         adapter, 0);
    word row;
    if (adapter == VIDEO_EGA) {
        for (row = 0; row != 8; ++row) {
            word plane;
            for (plane = 0; plane != 4; ++plane)
                *overkill_ega_plane_address(ScreenSegment, plane,
                    (word)(destination + row * EGA_SCREEN_ROW_BYTES)) =
                    segment_read_byte(WorkspaceSegment,
                        (word)(source + row * EGA_WIDE_ROW_BYTES +
                               plane * EGA_WIDE_PLANE_ROW_BYTES));
            destination = (word)(destination + EGA_SCREEN_ROW_BYTES);
        }
    } else {
        word bytes = adapter == VIDEO_CGA ? 2 : 4;
        word stride = adapter == VIDEO_CGA ? CGA_WIDE_ROW_BYTES : TANDY_WIDE_ROW_BYTES;
        for (row = 0; row != 8; ++row) {
            segment_copy(WorkspaceSegment, source, ScreenSegment, destination, bytes);
            source = (word)(source + stride);
            destination = adapter == VIDEO_CGA ? cga_next_screen_row(destination) :
                                                 tandy_next_screen_row(destination);
        }
    }
}

void presentation_capture_screen_row(word screen_segment, word workspace_segment,
                                     word source_offset, word workspace_offset,
                                     word adapter)
{
    if (adapter == VIDEO_EGA) {
        word plane;
        word column;
        for (plane = 0; plane != 4; ++plane)
            for (column = 0; column != EGA_SCREEN_ROW_BYTES; ++column)
                segment_write_byte(workspace_segment,
                    (word)(workspace_offset + plane * EGA_SCREEN_ROW_BYTES + column),
                    *overkill_ega_plane_address(screen_segment, plane,
                                                (word)(source_offset + column)));
    } else {
        word bytes = adapter == VIDEO_CGA ? CGA_SCREEN_ROW_BYTES :
                                             TANDY_SCREEN_ROW_BYTES;
        segment_copy(screen_segment, source_offset, workspace_segment,
                     workspace_offset, bytes);
    }
}

void presentation_finish_screen_capture(word adapter)
{
    /* The DOS routine restores the EGA read-map register to plane zero. Native
       plane access selects a bank per byte and has no persistent read-map latch. */
    (void)adapter;
}

static word stretch_destination_next(word offset, word adapter)
{
    if (adapter == VIDEO_CGA) return cga_next_screen_row(offset);
    if (adapter == VIDEO_EGA) return (word)(offset + EGA_SCREEN_ROW_BYTES);
    return tandy_next_screen_row(offset);
}

static void stretch_clear_row(word segment, word offset, word adapter, word bytes)
{
    word column;
    if (adapter == VIDEO_EGA) {
        word plane;
        for (plane = 0; plane != 4; ++plane)
            for (column = 0; column != bytes; ++column)
                *overkill_ega_plane_address(segment, plane,
                                            (word)(offset + column)) = 0;
    } else {
        for (column = 0; column != bytes; ++column)
            segment_write_byte(segment, (word)(offset + column), 0);
    }
}

static void stretch_copy_row(word source_segment, word source_offset,
                             word destination_segment, word destination_offset,
                             word adapter, word row_bytes)
{
    word plane;
    word column;
    if (adapter == VIDEO_EGA) {
        for (plane = 0; plane != 4; ++plane)
            for (column = 0; column != row_bytes; ++column)
                *overkill_ega_plane_address(destination_segment, plane,
                                             (word)(destination_offset + column)) =
                    segment_read_byte(source_segment,
                        (word)(source_offset + plane * row_bytes + column));
    } else {
        word bytes = (word)(row_bytes * (adapter == VIDEO_CGA ? 2 : 4));
        segment_copy(source_segment, source_offset, destination_segment,
                     destination_offset, bytes);
    }
}

void presentation_draw_stretch_frame(word drawer, word source_segment,
                                     word screen_segment, word bp,
                                     word state_segment,
                                     word *result_bp, word *result_es)
{
    word adapter = VideoAdapter;
    word expected = adapter == VIDEO_CGA ? HOST_TOKEN_DRAWSTRETCHEDIMAGECGA :
                    adapter == VIDEO_EGA ? HOST_TOKEN_DRAWSTRETCHEDIMAGEEGA :
                                           HOST_TOKEN_DRAWSTRETCHEDIMAGETANDY;
    word rows = StretchImageRows;
    word shown = StretchShownRows;
    word row_bytes = StretchRowBytes;
    word source_row_bytes = adapter == VIDEO_EGA ? (word)(row_bytes * 4) :
                            (word)(row_bytes * (adapter == VIDEO_CGA ? 2 : 4));
    word destination_bytes = adapter == VIDEO_EGA ? row_bytes : source_row_bytes;
    word source = StretchSource;
    word destination = StretchDest;
    word error = 0;
    word input_row;
    word margin = shown <= rows ? (word)((rows - shown) >> 1) : 0;

    if (drawer != expected || adapter > VIDEO_TANDY) abort();
    segment_write_word(HOST_LOAD_SEGMENT, HOST_OFFSET_STRETCHROWERROR, 0);
    if (StretchFlagA != 0 && rows != 0)
        source = (word)(source + (word)((rows - 1) * source_row_bytes));

    /* The adapter routines leave floor((source-visible)/2) rows above the
       expansion: all but the nearest row are skipped, then that row is cleared. */
    if (margin != 0) {
        word skip = (word)(margin - 1);
        while (skip != 0) {
            destination = stretch_destination_next(destination, adapter);
            skip--;
        }
        stretch_clear_row(screen_segment, destination, adapter, destination_bytes);
        destination = stretch_destination_next(destination, adapter);
    }

    for (input_row = 0; input_row != rows; ++input_row) {
        word emit = shown == rows;
        if (!emit) {
            error = (word)(error + shown);
            /* The original unsigned compare treats error as a signed-looking
               accumulator: add shown, then emit/subtract while rows > error. */
            if (rows > error) {
                error = (word)(error - rows);
                emit = 1;
            }
        }
        segment_write_word(HOST_LOAD_SEGMENT, HOST_OFFSET_STRETCHROWERROR, error);
        if (emit) {
            if (adapter == VIDEO_EGA && StretchFlagB == 1) {
                word plane, column;
                for (plane = 0; plane != 3; ++plane)
                    for (column = 0; column != row_bytes; ++column)
                        *overkill_ega_plane_address(screen_segment, plane,
                                                   (word)(destination + column)) =
                            segment_read_byte(source_segment,
                                (word)(source + plane * row_bytes + column));
                for (column = 0; column != row_bytes; ++column)
                    *overkill_ega_plane_address(screen_segment, 3,
                                               (word)(destination + column)) = 0;
            } else {
                stretch_copy_row(source_segment, source, screen_segment,
                                 destination, adapter, row_bytes);
            }
            destination = stretch_destination_next(destination, adapter);
        }
        if (StretchFlagA != 0)
            source = (word)(source - source_row_bytes);
        else
            source = (word)(source + source_row_bytes);
    }
    stretch_clear_row(screen_segment, destination, adapter, destination_bytes);
    *result_bp = bp;
    *result_es = screen_segment;
    (void)state_segment;
}

static byte font_row(word character, word row)
{
    return GAME_PTR(byte, GAME_OFFSET(Font8x8) + (word)(character * 8 + row))[0];
}

static word font_draw_offset(word adapter)
{
    (void)adapter;
    return (word)(TextRowOffset + TextColumn);
}

static void print_text_character(word character, word *es, word *di)
{
    word adapter = VideoAdapter;
    word x = font_draw_offset(adapter);
    word row;
    byte color = TextColor;

    if (TextInGraphics == 0) {
        word video_segment = TextVideoSegment;
        *di = TextRowOffset;
        segment_write_word(video_segment, TextRowOffset,
                           (word)((character & 0xFF) | ((word)color << 8)));
        TextRowOffset = (word)(TextRowOffset + 2);
        *es = video_segment;
        return;
    }

    if (character == 0x0E && adapter != VIDEO_TANDY) {
        TextColumn = 0;
        TextRowOffset = (word)(TextRowOffset +
            (adapter == VIDEO_CGA ? 4 * CGA_SCREEN_ROW_BYTES :
                                    8 * EGA_SCREEN_ROW_BYTES));
        /* PrintTextChar set ES to MainDataSegment before this control branch. */
        *es = MainDataSegment;
        return;
    }

    *es = ScreenSegment;
    if (adapter == VIDEO_CGA) {
        for (row = 0; row != 8; ++row) {
            byte bits = font_row(character, row);
            byte high = GAME_PTR(byte, GAME_OFFSET(CgaNibbleToPixels) + (bits >> 4))[0];
            byte low = GAME_PTR(byte, GAME_OFFSET(CgaNibbleToPixels) + (bits & 0x0F))[0];
            segment_write_byte(ScreenSegment, x, (byte)(high & color));
            segment_write_byte(ScreenSegment, (word)(x + 1), (byte)(low & color));
            x = cga_next_screen_row(x);
        }
        TextColumn = (byte)(TextColumn + 2);
        if (TextColumn >= CGA_SCREEN_ROW_BYTES) {
            TextColumn = 0;
            TextRowOffset = (word)(TextRowOffset + 4 * CGA_SCREEN_ROW_BYTES);
        }
    } else if (adapter == VIDEO_EGA) {
        for (row = 0; row != 8; ++row) {
            byte bits = font_row(character, row);
            word plane;
            word destination = (word)(TextRowOffset + TextColumn + row * EGA_SCREEN_ROW_BYTES);
            for (plane = 0; plane != 4; ++plane)
                *overkill_ega_plane_address(ScreenSegment, plane, destination) =
                    (color & (1u << plane)) != 0 ? bits : 0;
        }
        *di = (word)(TextRowOffset + TextColumn);
        TextColumn = (byte)(TextColumn + 1);
        if (TextColumn >= EGA_SCREEN_ROW_BYTES) {
            TextColumn = 0;
            TextRowOffset = (word)(TextRowOffset + 8 * EGA_SCREEN_ROW_BYTES);
        }
        return;
    } else {
        byte repeated = (byte)((color << 4) | color);
        for (row = 0; row != 8; ++row) {
            byte bits = font_row(character, row);
            word pixel;
            for (pixel = 0; pixel != 8; ++pixel) {
                word destination = (word)(x + pixel / 2);
                byte value = (bits & (0x80u >> pixel)) != 0 ? color : 0;
                byte old = segment_read_byte(ScreenSegment, destination);
                if ((pixel & 1) == 0)
                    old = (byte)((old & 0x0F) | ((value & 0x0F) << 4));
                else
                    old = (byte)((old & 0xF0) | (value & 0x0F));
                segment_write_byte(ScreenSegment, destination, old);
            }
            x = tandy_next_screen_row(x);
        }
        (void)repeated;
        *di = (word)(TextRowOffset + TextColumn);
        TextColumn = (byte)(TextColumn + 4);
        if (TextColumn >= TANDY_SCREEN_ROW_BYTES) {
            TextColumn = 0;
            TextRowOffset = (word)(TextRowOffset + 2 * TANDY_SCREEN_ROW_BYTES);
        }
    }
    *di = x;
}

dword presentation_raw_print_text_char(word bp, word es, word character,
                                       word di, word *result_di)
{
    print_text_character((byte)character, &es, &di);
    if (result_di != NULL) *result_di = di;
    return ((dword)es << 16) | bp;
}

static void cga_apply_palette(word selection, word intensity, word burst)
{
    static const uint8_t palette0[2][3][3] = {
        { { 0, 170, 0 }, { 170, 0, 0 }, { 170, 85, 0 } },
        { { 0, 255, 0 }, { 255, 0, 0 }, { 255, 255, 85 } }
    };
    static const uint8_t palette1[2][3][3] = {
        { { 0, 170, 170 }, { 170, 0, 170 }, { 170, 170, 170 } },
        { { 0, 255, 255 }, { 255, 0, 255 }, { 255, 255, 255 } }
    };
    const uint8_t (*chosen)[3] = selection ? palette1[intensity != 0] :
                                              palette0[intensity != 0];
    unsigned i;
    overkill_sdl_video_palette(0, 0, 0, 0);
    for (i = 0; i != 3; ++i)
        overkill_sdl_video_palette(i + 1, chosen[i][0], chosen[i][1], chosen[i][2]);
    cga_palette_select = selection;
    cga_intensity = intensity;
    cga_colour_burst = burst;
}

static void set_text_palette(void)
{
    unsigned i;
    for (i = 0; i != 16; ++i) {
        uint8_t intensity = (i & 8) != 0 ? 85 : 0;
        uint8_t red = (uint8_t)(((i & 4) != 0 ? 170 : 0) + intensity);
        uint8_t green = (uint8_t)(((i & 2) != 0 ? 170 : 0) + intensity);
        uint8_t blue = (uint8_t)(((i & 1) != 0 ? 170 : 0) + intensity);
        if (i == 6) green = 85;
        overkill_sdl_video_palette(i, red, green, blue);
    }
}

static void set_dac_color6(word offset)
{
    byte red, green, blue;
    if (VideoAdapter != VIDEO_EGA) return;
    red = segment_read_byte(MainDataSegment, offset);
    green = segment_read_byte(MainDataSegment, (word)(offset + 1));
    blue = segment_read_byte(MainDataSegment, (word)(offset + 2));
    overkill_sdl_video_palette(6,
        (uint8_t)((red << 2) | (red >> 4)),
        (uint8_t)((green << 2) | (green >> 4)),
        (uint8_t)((blue << 2) | (blue >> 4)));
}

static void draw_payment_text_page(void)
{
    word source = 0;
    word row;
    word column;
    word destination;
    word rows_left = 24;
    word screen = TextScreenSegment;
    for (row = 0; row != TextTopLine; ++row) {
        for (;;) {
            byte value = segment_read_byte(WorkspaceSegment, source);
            source = (word)(source + 1);
            if (value == 0x0D) break;
        }
        if (segment_read_byte(WorkspaceSegment, source) == 0x0A)
            source = (word)(source + 1);
    }

    for (column = 0; column != 0xA0; ++column)
        segment_write_byte(screen, column,
            *GAME_PTR(byte, (word)(GAME_OFFSET(PaymentHelpRow) + column)));

    column = 0;
    destination = 0x00A0;
    while (rows_left != 0) {
        byte value = segment_read_byte(WorkspaceSegment, source);
        source = (word)(source + 1);
        if (value == 0x1A) break;
        if (value == 0x09) {
            byte attribute = 0x1B;
            if ((column & 7) == 0) {
                if (column == 0x50) continue;
                for (row = 0; row != 8; ++row) {
                    segment_write_word(screen, destination,
                                       (word)(0x20 | ((word)attribute << 8)));
                    destination = (word)(destination + 2);
                }
                column = (word)(column + 8);
            } else {
                do {
                    segment_write_word(screen, destination,
                                       (word)(0x20 | ((word)attribute << 8)));
                    destination = (word)(destination + 2);
                    column++;
                } while ((column & 7) != 0 && column != 0x50);
            }
            continue;
        }
        if (value == 0x0D) {
            if (segment_read_byte(WorkspaceSegment, source) == 0x0A)
                source = (word)(source + 1);
            if (column == 0x50) {
                column = 0;
                destination = (word)(destination + 0x00A0);
                rows_left--;
                continue;
            }
            while (column != 0x50) {
                segment_write_word(screen, destination,
                                   (word)(0x20 | (0x1Bu << 8)));
                destination = (word)(destination + 2);
                column++;
            }
            column = 0;
            destination = (word)(destination + 0x00A0);
            rows_left--;
            continue;
        }
        segment_write_word(screen, destination,
                           (word)(value | (0x1Bu << 8)));
        destination = (word)(destination + 2);
        column++;
        if (column == 0x50) {
            column = 0;
            destination = (word)(destination + 0x00A0);
            rows_left--;
        }
    }
    text_page_active = 1;
    overkill_platform_idle();
    overkill_platform_idle();
    overkill_platform_idle();
    overkill_platform_idle();
}

int presentation_text_mode_active(void)
{
    return text_page_active;
}

word presentation_text_segment(void)
{
    return TextScreenSegment;
}

void presentation_text_mode_leave(void)
{
    text_page_active = 0;
}

void presentation_text_set_cursor(word row, word column)
{
    text_cursor_row = row;
    text_cursor_column = column;
}

void presentation_text_get_cursor(word *row, word *column)
{
    if (row != NULL) *row = text_cursor_row;
    if (column != NULL) *column = text_cursor_column;
}

int presentation_text_cursor_visible(void)
{
    return text_cursor_visible;
}

void presentation_set_text_mode3(word hide_cursor)
{
    word row, column;
    TextScreenSegment = 0xB800;
    set_text_palette();
    for (row = 0; row != 25; ++row)
        for (column = 0; column != 80; ++column)
            segment_write_word(TextScreenSegment,
                (word)(row * 0x00A0 + column * 2), 0x0720);
    presentation_text_set_cursor(0, 0);
    text_cursor_visible = hide_cursor == 0;
    text_page_active = 1;
}

static void text_scroll_one_row(void)
{
    word row, column;
    for (row = 0; row != 24; ++row)
        for (column = 0; column != 80; ++column)
            segment_write_word(TextScreenSegment,
                (word)(row * 0x00A0 + column * 2),
                segment_read_word(TextScreenSegment,
                    (word)((row + 1) * 0x00A0 + column * 2)));
    for (column = 0; column != 80; ++column)
        segment_write_word(TextScreenSegment,
            (word)(24 * 0x00A0 + column * 2), 0x0720);
    text_cursor_row = 24;
}

static void text_advance_row(void)
{
    text_cursor_row++;
    if (text_cursor_row >= 25) text_scroll_one_row();
}

void presentation_print_dos_string_at_bp(word bp)
{
    word cursor = bp;
    for (;;) {
        byte character = *GAME_PTR(volatile byte, cursor);
        cursor = (word)(cursor + 1);
        if (character == '$') break;
        if (character == '\r') {
            text_cursor_column = 0;
        } else if (character == '\n') {
            text_advance_row();
        } else if (character == '\b') {
            if (text_cursor_column != 0) text_cursor_column--;
        } else if (character == '\t') {
            word spaces = (word)(8 - (text_cursor_column & 7));
            while (spaces-- != 0) {
                segment_write_word(TextScreenSegment,
                    (word)(text_cursor_row * 0x00A0 + text_cursor_column * 2),
                    0x0720);
                text_cursor_column++;
                if (text_cursor_column == 80) {
                    text_cursor_column = 0;
                    text_advance_row();
                }
            }
        } else {
            if (text_page_active) {
                segment_write_word(TextScreenSegment,
                    (word)(text_cursor_row * 0x00A0 + text_cursor_column * 2),
                    (word)(character | 0x0700));
            } else {
                /* DOS output uses the current BIOS mode. In particular the
                   high-score leaf emits ten spaces on a 40-column graphics
                   page; it never selects mode 3 or writes text attributes. */
                word gy, gx;
                for (gy = 0; gy != 8; ++gy) {
                    word y = (word)(text_cursor_row * 8 + gy);
                    for (gx = 0; gx != 8; ++gx) {
                        word x = (word)(text_cursor_column * 8 + gx);
                        byte color = (overkill_cp437_font[character][gy] >> gx) & 1 ? 7 : 0;
                        word offset;
                        if (VideoAdapter == VIDEO_EGA) {
                            word plane;
                            byte mask = (byte)(0x80u >> (x & 7));
                            offset = (word)(y * 40 + x / 8);
                            for (plane = 0; plane != 4; ++plane) {
                                byte *pixel = overkill_ega_plane_address(0xA000, plane, offset);
                                *pixel = (byte)((*pixel & ~mask) |
                                    ((color & (1u << plane)) ? mask : 0));
                            }
                        } else {
                            word shift;
                            byte mask, old;
                            if (VideoAdapter == VIDEO_TANDY) {
                                offset = (word)((y & 3) * 0x2000 + (y >> 2) * 160 + x / 2);
                                shift = (word)(4 - (x & 1) * 4);
                                mask = (byte)(0x0Fu << shift);
                            } else {
                                offset = (word)((y & 1) * 0x2000 + (y >> 1) * 80 + x / 4);
                                shift = (word)(6 - (x & 3) * 2);
                                mask = (byte)(3u << shift);
                                color &= 3;
                            }
                            old = segment_read_byte(0xB800, offset);
                            segment_write_byte(0xB800, offset,
                                (byte)((old & ~mask) | (color << shift)));
                        }
                    }
                }
            }
            text_cursor_column++;
            if (text_cursor_column == (text_page_active ? 80 : 40)) {
                text_cursor_column = 0;
                text_advance_row();
            }
        }
    }
}

void presentation_present_exit_order(void)
{
    word cell;
    for (cell = 0; cell != 0x07D0; ++cell)
        segment_write_word(TextScreenSegment, (word)(cell * 2),
            *GAME_PTR(word, (word)(GAME_OFFSET(ExitOrderScreen) + cell * 2)));
    presentation_text_set_cursor(0x16, 0);
    text_page_active = 1;
}

void presentation_draw_hiscore_entry(void)
{
    presentation_draw_panel(0xA800, 0x0056);
    presentation_text_set_cursor(HiscoreEntryRow, 0);
}

void presentation_draw_quit_prompt(void)
{
    presentation_draw_panel(0x5C04, PANEL_QUIT_PROMPT);
}

static void presentation_draw_status_panel(void)
{
    HostRegisters registers = { 0 };
    word image = panel_image_offset(PANEL_HUD_FRAME);
    word destination = row_column_offset(0x001B, VideoAdapter, 0);
    word rows = segment_read_word(PanelSegment, image);
    word width = segment_read_word(PanelSegment, (word)(image + 2));
    word drawer = cs_word((word)(HOST_TOKEN_ADAPTERDRAWHANDLERS + VideoAdapter * 2));
    word bp = 0, es = ScreenSegment;
    StretchImageRows = rows;
    StretchRowBytes = width;
    StretchSource = (word)(image + 4);
    StretchDest = destination;
    StretchFlagA = 0;
    StretchFlagB = 0;
    StretchShownRows = 0x00C6;
    overkill_platform_call(HOST_TOKEN_RESETEGAPAGES, &registers);
    presentation_draw_stretch_frame(drawer, PanelSegment, ScreenSegment,
                                    bp, MainDataSegment, &bp, &es);
    if (VideoAdapter == VIDEO_EGA) copy_ega_page0_to_page1();
}

int presentation_dispatch(word token, HostRegisters *registers)
{
    if (token == HOST_TOKEN_DRAWFUELEMPTYPANEL) {
        draw_fuel_empty_panel(registers);
        return 1;
    }
    switch (token) {
    case HOST_TOKEN_DRAWTITLEBACKDROP:
        presentation_title_draw_backdrop();
        return 1;
    case HOST_TOKEN_COPYFULLWORKSPACETOSCREEN:
        copy_full_workspace_to_screen();
        text_page_active = 0;
        return 1;
    case HOST_TOKEN_COPYEGAPAGE0TOPAGE1:
        if (VideoAdapter == VIDEO_EGA) copy_ega_page0_to_page1();
        return 1;
    case HOST_TOKEN_DRAWSTATUSPANEL:
        presentation_draw_status_panel();
        return 1;
    case HOST_TOKEN_CGASELECTBRIGHTPALETTE0:
        if (VideoAdapter == VIDEO_CGA) cga_apply_palette(0, 1, 1);
        return 1;
    case HOST_TOKEN_CGASELECTBRIGHTPALETTE1:
        if (VideoAdapter == VIDEO_CGA) cga_apply_palette(1, 1, 1);
        return 1;
    case HOST_TOKEN_CGASELECTBRIGHTPALETTENOBURST:
        if (VideoAdapter == VIDEO_CGA) cga_apply_palette(1, 1, 0);
        return 1;
    case HOST_TOKEN_SETDACCOLOR6:
        set_dac_color6(registers->si);
        return 1;
    case HOST_SERVICE_DISPLAYCALLDACCOLOR6:
        set_dac_color6(registers->di);
        return 1;
    case HOST_SERVICE_DISPLAYCGAPALETTEDISPATCH:
        switch (LevelIndex) {
        case 0: cga_apply_palette(0, 1, 0); break;
        case 1: cga_apply_palette(1, 1, 1); break;
        case 2: cga_apply_palette(0, 1, 1); break;
        case 3: cga_apply_palette(1, 1, 1); break;
        case 4: cga_apply_palette(0, 1, 0); break;
        case 5: cga_apply_palette(0, 1, 1); break;
        default: abort();
        }
        return 1;
    case HOST_SERVICE_DISPLAYDRAWLIVESROW:
        if (registers->cx != 0) registers->di = row_column_offset(0x501F,
                                                        VideoAdapter, 0);
        presentation_draw_panel_row(registers->ax, registers->bx,
                                    registers->di, &registers->di);
        return 1;
    case HOST_SERVICE_DRAWPANELATPOSITION:
        presentation_draw_panel(registers->dx, registers->si);
        return 1;
    case HOST_SERVICE_PRESENTATIONDRAWBONUSPANEL: {
        word entry = (word)(GAME_OFFSET(BonusIntroItems) + registers->si * 4);
        word row_column = (word)(*GAME_PTR(byte, entry) << 8);
        word image = *GAME_PTR(byte, (word)(entry + 1));
        presentation_draw_panel(row_column, image);
        return 1;
    }
    case HOST_SERVICE_PRESENTATIONDRAWWORKSPACEBACKGROUND:
        blit_screen_image(WorkspaceSegment, 0x8000, 0);
        return 1;
    case HOST_SERVICE_PRESENTATIONDRAWIMAGE:
        blit_screen_image(registers->di, registers->si,
                          row_column_offset(registers->cx, VideoAdapter, 0));
        return 1;
    case HOST_SERVICE_RAWPRINTTEXTCHAR: {
        dword result = presentation_raw_print_text_char(registers->bp,
            registers->es, registers->cx, registers->di, &registers->di);
        registers->bp = (word)result;
        registers->es = (word)(result >> 16);
        return 1;
    }
    case HOST_TOKEN_DRAWPAYMENTTEXTPAGE:
        draw_payment_text_page();
        return 1;
    case HOST_SERVICE_PAYMENTSETTEXTMODEANDHIDECURSOR:
        presentation_set_text_mode3(1);
        return 1;
    case HOST_TOKEN_PROBEMONOHERCULES:
        registers->ax = 0;
        return 1;
    default:
        return 0;
    }
}
