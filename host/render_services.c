/* Native pixel services for the same segmented memory image used by c/render.c.
   The routines intentionally update encoded DOS video/workspace bytes in place. */
#include "render_services.h"
#include "memory.h"

#include <stdint.h>
#include <stdlib.h>

/* memory.h declares the DS view; this is the segment:offset view of the host arena. */
extern void *overkill_segment_address(uint16_t segment, uint16_t offset);

#define HOST_EGA_PLANE_ROW_BYTES 0x1Au
#define HOST_CGA_SCREEN_ROW_BYTES 0x50u
#define HOST_CGA_BANK_BYTES 0x2000u
#define HOST_TANDY_SCREEN_ROW_BYTES 0xA0u
#define HOST_TANDY_BANK_BYTES 0x2000u
#define HOST_EGA_SCREEN_ROW_BYTES 0x28u
#define HOST_EGA_PAGE0_SEGMENT 0xA000u
#define HOST_EGA_PAGE_SEGMENT_DELTA 0x0200u
#define HOST_EGA_PAGE_BYTES 0x2000u
#define HOST_EGA_PLANE_STORAGE_BYTES 0x12000u

/* This storage models the EGA card's four 64 KiB aperture planes. It is device
   memory, separate from the guest's canonical DOS address-space bytes. */
static uint8_t ega_video_planes[4][HOST_EGA_PLANE_STORAGE_BYTES];

static uint8_t read_segment_byte(word segment, word offset)
{
    return *(uint8_t *)overkill_segment_address(segment, offset);
}

static void write_segment_byte(word segment, word offset, uint8_t value)
{
    *(uint8_t *)overkill_segment_address(segment, offset) = value;
}

static void copy_segment_bytes(word source_segment, word source_offset,
                               word destination_segment, word destination_offset,
                               word count)
{
    word i;
    for (i = 0; i != count; ++i)
        write_segment_byte(destination_segment, (word)(destination_offset + i),
                           read_segment_byte(source_segment, (word)(source_offset + i)));
}

static word read_segment_word(word segment, word offset)
{
    word low = read_segment_byte(segment, offset);
    word high = read_segment_byte(segment, (word)(offset + 1));
    return (word)(low | (word)(high << 8));
}

static void write_segment_word(word segment, word offset, word value)
{
    write_segment_byte(segment, offset, (uint8_t)value);
    write_segment_byte(segment, (word)(offset + 1), (uint8_t)(value >> 8));
}

static word ega_page_base(word page_segment)
{
    if (page_segment == HOST_EGA_PAGE0_SEGMENT) return 0;
    if (page_segment == HOST_EGA_PAGE0_SEGMENT + HOST_EGA_PAGE_SEGMENT_DELTA)
        return HOST_EGA_PAGE_BYTES;
    abort();
}

uint8_t *overkill_ega_plane_address(word page_segment, word plane, word offset)
{
    word page_base = ega_page_base(page_segment);
    if (plane >= 4) abort();
    return &ega_video_planes[plane][(size_t)page_base + offset];
}

static void write_ega_segment_byte(word segment, word plane, word offset,
                                   uint8_t value)
{
    if (segment == HOST_EGA_PAGE0_SEGMENT ||
        segment == HOST_EGA_PAGE0_SEGMENT + HOST_EGA_PAGE_SEGMENT_DELTA) {
        *overkill_ega_plane_address(segment, plane, offset) = value;
    } else {
        /* An out-of-aperture ES address is ordinary DOS RAM, even while EGA map
           masks are selected. Sequential plane writes consequently alias there. */
        write_segment_byte(segment, offset, value);
    }
}

void overkill_ega_copy_indexed_page(word page_segment, uint8_t *pixels, size_t pitch)
{
    word page_base = ega_page_base(page_segment);
    word y;

    if (pixels == NULL || pitch < OVERKILL_EGA_WIDTH) abort();
    for (y = 0; y != OVERKILL_EGA_HEIGHT; ++y) {
        word x;
        uint8_t *row = pixels + (size_t)y * pitch;
        for (x = 0; x != OVERKILL_EGA_WIDTH; ++x) {
            word offset = (word)(page_base + y * HOST_EGA_SCREEN_ROW_BYTES + x / 8);
            uint8_t mask = (uint8_t)(0x80u >> (x & 7));
            uint8_t color = 0;
            word plane;
            for (plane = 0; plane != 4; ++plane)
                color |= (uint8_t)(((ega_video_planes[plane][offset] & mask) != 0) << plane);
            row[x] = color;
        }
    }
}

void render_platform_copy_rows(RenderCopyRequest *request)
{
    word row;
    word state_offset = request->save_offset;
    word workspace_offset = request->workspace_offset;
    word workspace_to_state = request->to_workspace == 0;

    for (row = 0; row != request->rows; ++row) {
        word plane;
        for (plane = 0; plane != request->planes; ++plane) {
            word plane_offset = (word)(plane * HOST_EGA_PLANE_ROW_BYTES);
            word workspace_plane = (word)(workspace_offset + plane_offset);
            word state_plane = state_offset;
            if (workspace_to_state) {
                copy_segment_bytes(request->workspace_segment, workspace_plane,
                                   request->state_segment, state_plane,
                                   request->bytes_per_plane);
            } else {
                copy_segment_bytes(request->state_segment, state_plane,
                                   request->workspace_segment, workspace_plane,
                                   request->bytes_per_plane);
            }
            state_offset = (word)(state_offset + request->bytes_per_plane);
        }
        workspace_offset = (word)(workspace_offset + request->workspace_row_bytes);
    }
}

typedef struct HostBlitterInfo {
    word adapter;
    word width;
    word phase;
    word flash;
    word recognized;
} HostBlitterInfo;

#define BLITTER(label, mode, pixels, shift, is_flash) \
    if (token == HOST_TOKEN_##label) { \
        info->adapter = (mode); info->width = (pixels); \
        info->phase = (shift); info->flash = (is_flash); \
        info->recognized = 1; return; \
    }

static void describe_blitter(word token, HostBlitterInfo *info)
{
    info->adapter = 0;
    info->width = 0;
    info->phase = 0;
    info->flash = 0;
    info->recognized = 0;

    BLITTER(DRAWSPRITE8SHIFT0CGA, VIDEO_CGA, 8, 0, 0)
    BLITTER(DRAWSPRITE8SHIFT1CGA, VIDEO_CGA, 8, 1, 0)
    BLITTER(DRAWSPRITE8SHIFT2CGA, VIDEO_CGA, 8, 2, 0)
    BLITTER(DRAWSPRITE8SHIFT3CGA, VIDEO_CGA, 8, 3, 0)
    BLITTER(DRAWSPRITE16SHIFT0CGA, VIDEO_CGA, 16, 0, 0)
    BLITTER(DRAWSPRITE16SHIFT1CGA, VIDEO_CGA, 16, 1, 0)
    BLITTER(DRAWSPRITE16SHIFT2CGA, VIDEO_CGA, 16, 2, 0)
    BLITTER(DRAWSPRITE16SHIFT3CGA, VIDEO_CGA, 16, 3, 0)
    BLITTER(DRAWSPRITE32SHIFT0CGA, VIDEO_CGA, 32, 0, 0)
    BLITTER(DRAWSPRITE32SHIFT1CGA, VIDEO_CGA, 32, 1, 0)
    BLITTER(DRAWSPRITE32SHIFT2CGA, VIDEO_CGA, 32, 2, 0)
    BLITTER(DRAWSPRITE32SHIFT3CGA, VIDEO_CGA, 32, 3, 0)
    BLITTER(FLASHSPRITE16SHIFT0CGA, VIDEO_CGA, 16, 0, 1)
    BLITTER(FLASHSPRITE16SHIFT1CGA, VIDEO_CGA, 16, 1, 1)
    BLITTER(FLASHSPRITE16SHIFT2CGA, VIDEO_CGA, 16, 2, 1)
    BLITTER(FLASHSPRITE16SHIFT3CGA, VIDEO_CGA, 16, 3, 1)
    BLITTER(FLASHSPRITE32SHIFT0CGA, VIDEO_CGA, 32, 0, 1)
    BLITTER(FLASHSPRITE32SHIFT1CGA, VIDEO_CGA, 32, 1, 1)
    BLITTER(FLASHSPRITE32SHIFT2CGA, VIDEO_CGA, 32, 2, 1)
    BLITTER(FLASHSPRITE32SHIFT3CGA, VIDEO_CGA, 32, 3, 1)

    BLITTER(DRAWSPRITE8SHIFT0EGA, VIDEO_EGA, 8, 0, 0)
    BLITTER(DRAWSPRITE8SHIFT1EGA, VIDEO_EGA, 8, 1, 0)
    BLITTER(DRAWSPRITE8SHIFT2EGA, VIDEO_EGA, 8, 2, 0)
    BLITTER(DRAWSPRITE8SHIFT3EGA, VIDEO_EGA, 8, 3, 0)
    BLITTER(DRAWSPRITE8SHIFT4EGA, VIDEO_EGA, 8, 4, 0)
    BLITTER(DRAWSPRITE8SHIFT5EGA, VIDEO_EGA, 8, 5, 0)
    BLITTER(DRAWSPRITE8SHIFT6EGA, VIDEO_EGA, 8, 6, 0)
    BLITTER(DRAWSPRITE8SHIFT7EGA, VIDEO_EGA, 8, 7, 0)
    BLITTER(DRAWSPRITE16SHIFT0EGA, VIDEO_EGA, 16, 0, 0)
    BLITTER(DRAWSPRITE16SHIFT1EGA, VIDEO_EGA, 16, 1, 0)
    BLITTER(DRAWSPRITE16SHIFT2EGA, VIDEO_EGA, 16, 2, 0)
    BLITTER(DRAWSPRITE16SHIFT3EGA, VIDEO_EGA, 16, 3, 0)
    BLITTER(DRAWSPRITE16SHIFT4EGA, VIDEO_EGA, 16, 4, 0)
    BLITTER(DRAWSPRITE16SHIFT5EGA, VIDEO_EGA, 16, 5, 0)
    BLITTER(DRAWSPRITE16SHIFT6EGA, VIDEO_EGA, 16, 6, 0)
    BLITTER(DRAWSPRITE16SHIFT7EGA, VIDEO_EGA, 16, 7, 0)
    BLITTER(DRAWSPRITE32SHIFT0EGA, VIDEO_EGA, 32, 0, 0)
    BLITTER(DRAWSPRITE32SHIFT1EGA, VIDEO_EGA, 32, 1, 0)
    BLITTER(DRAWSPRITE32SHIFT2EGA, VIDEO_EGA, 32, 2, 0)
    BLITTER(DRAWSPRITE32SHIFT3EGA, VIDEO_EGA, 32, 3, 0)
    BLITTER(DRAWSPRITE32SHIFT4EGA, VIDEO_EGA, 32, 4, 0)
    BLITTER(DRAWSPRITE32SHIFT5EGA, VIDEO_EGA, 32, 5, 0)
    BLITTER(DRAWSPRITE32SHIFT6EGA, VIDEO_EGA, 32, 6, 0)
    BLITTER(DRAWSPRITE32SHIFT7EGA, VIDEO_EGA, 32, 7, 0)
    BLITTER(FLASHSPRITE16SHIFT0EGA, VIDEO_EGA, 16, 0, 1)
    BLITTER(FLASHSPRITE16SHIFT1EGA, VIDEO_EGA, 16, 1, 1)
    BLITTER(FLASHSPRITE16SHIFT2EGA, VIDEO_EGA, 16, 2, 1)
    BLITTER(FLASHSPRITE16SHIFT3EGA, VIDEO_EGA, 16, 3, 1)
    BLITTER(FLASHSPRITE16SHIFT4EGA, VIDEO_EGA, 16, 4, 1)
    BLITTER(FLASHSPRITE16SHIFT5EGA, VIDEO_EGA, 16, 5, 1)
    BLITTER(FLASHSPRITE16SHIFT6EGA, VIDEO_EGA, 16, 6, 1)
    BLITTER(FLASHSPRITE16SHIFT7EGA, VIDEO_EGA, 16, 7, 1)
    BLITTER(FLASHSPRITE32SHIFT0EGA, VIDEO_EGA, 32, 0, 1)
    BLITTER(FLASHSPRITE32SHIFT1EGA, VIDEO_EGA, 32, 1, 1)
    BLITTER(FLASHSPRITE32SHIFT2EGA, VIDEO_EGA, 32, 2, 1)
    BLITTER(FLASHSPRITE32SHIFT3EGA, VIDEO_EGA, 32, 3, 1)
    BLITTER(FLASHSPRITE32SHIFT4EGA, VIDEO_EGA, 32, 4, 1)
    BLITTER(FLASHSPRITE32SHIFT5EGA, VIDEO_EGA, 32, 5, 1)
    BLITTER(FLASHSPRITE32SHIFT6EGA, VIDEO_EGA, 32, 6, 1)
    BLITTER(FLASHSPRITE32SHIFT7EGA, VIDEO_EGA, 32, 7, 1)

    BLITTER(DRAWSPRITE8TANDY, VIDEO_TANDY, 8, 0, 0)
    BLITTER(DRAWSPRITE16TANDY, VIDEO_TANDY, 16, 0, 0)
    BLITTER(DRAWSPRITE32TANDY, VIDEO_TANDY, 32, 0, 0)
    BLITTER(FLASHSPRITE16TANDY, VIDEO_TANDY, 16, 0, 1)
    BLITTER(FLASHSPRITE32TANDY, VIDEO_TANDY, 32, 0, 1)
}

#undef BLITTER

static void draw_cga_sprite_row(word source_segment, word source_row,
                                word workspace_segment, word destination_row,
                                word width, word phase, word flash)
{
    word pixel;

    for (pixel = 0; pixel != width; ++pixel) {
        word chunk = (word)(pixel / 8);
        word within = (word)(pixel & 7);
        word source_byte_in_chunk = (word)(within / 4);
        word source_shift = (word)(6 - 2 * (within & 3));
        word mask_offset = (word)(source_row + chunk * 4 + source_byte_in_chunk);
        word color_offset = (word)(mask_offset + 2);
        uint8_t mask_byte = read_segment_byte(source_segment, mask_offset);
        uint8_t mask = (uint8_t)((mask_byte >> source_shift) & 3u);
        word destination_pixel = (word)(phase + pixel);
        word destination_offset = (word)(destination_row + destination_pixel / 4);
        word destination_shift = (word)(6 - 2 * (destination_pixel & 3));
        uint8_t field = (uint8_t)(3u << destination_shift);
        uint8_t destination = read_segment_byte(workspace_segment, destination_offset);

        if (flash) {
            uint8_t visible = (uint8_t)((~mask) & 3u);
            destination = (uint8_t)(destination |
                                    (uint8_t)(visible << destination_shift));
        } else {
            uint8_t color = read_segment_byte(source_segment, color_offset);
            uint8_t value = (uint8_t)((color >> source_shift) & 3u);
            uint8_t old_value = (uint8_t)((destination >> destination_shift) & 3u);
            value = (uint8_t)((old_value & mask) | value);
            destination = (uint8_t)((destination & (uint8_t)~field) |
                                    (uint8_t)(value << destination_shift));
        }
        write_segment_byte(workspace_segment, destination_offset, destination);
    }
}

static void draw_ega_sprite_row(word source_segment, word source_row,
                                word workspace_segment, word destination_row,
                                word width, word phase, word flash)
{
    word lane_bytes = (word)(width / 8);
    word pixel;

    for (pixel = 0; pixel != width; ++pixel) {
        word source_byte = (word)(pixel / 8);
        word source_bit = (word)(7 - (pixel & 7));
        uint8_t mask_byte = read_segment_byte(source_segment,
                                               (word)(source_row + source_byte));
        uint8_t transparent = (uint8_t)((mask_byte >> source_bit) & 1u);
        word destination_pixel = (word)(phase + pixel);
        word destination_offset = (word)(destination_row + destination_pixel / 8);
        uint8_t destination_bit = (uint8_t)(1u << (7 - (destination_pixel & 7)));
        word plane;

        for (plane = 0; plane != 4; ++plane) {
            word source_plane_offset = (word)(source_row + (plane + 1) * lane_bytes + source_byte);
            uint8_t color_byte = read_segment_byte(source_segment, source_plane_offset);
            uint8_t color = (uint8_t)((color_byte >> source_bit) & 1u);
            word plane_destination = (word)(destination_offset + plane * HOST_EGA_PLANE_ROW_BYTES);
            uint8_t destination = read_segment_byte(workspace_segment, plane_destination);
            uint8_t old_value = (uint8_t)((destination & destination_bit) != 0);
            uint8_t value = flash ? (uint8_t)(old_value | (transparent ^ 1u)) :
                                    (uint8_t)((old_value & transparent) | color);
            if (value)
                destination = (uint8_t)(destination | destination_bit);
            else
                destination = (uint8_t)(destination & (uint8_t)~destination_bit);
            write_segment_byte(workspace_segment, plane_destination, destination);
        }
    }
}

static void draw_tandy_sprite_row(word source_segment, word source_row,
                                  word workspace_segment, word destination_row,
                                  word width, word flash)
{
    word pixel;

    for (pixel = 0; pixel != width; ++pixel) {
        word chunk = (word)(pixel / 4);
        word within = (word)(pixel & 3);
        word source_byte = (word)(source_row + chunk * 4 + within / 2);
        word source_shift = (word)((within & 1) * 4);
        uint8_t mask_byte = read_segment_byte(source_segment, source_byte);
        uint8_t mask = (uint8_t)((mask_byte >> source_shift) & 0x0Fu);
        word destination_offset = (word)(destination_row + pixel / 2);
        word destination_shift = (word)((pixel & 1) * 4);
        uint8_t field = (uint8_t)(0x0Fu << destination_shift);
        uint8_t destination = read_segment_byte(workspace_segment, destination_offset);

        if (flash) {
            uint8_t visible = (uint8_t)((~mask) & 0x0Fu);
            destination = (uint8_t)(destination |
                                    (uint8_t)(visible << destination_shift));
        } else {
            uint8_t color_byte = read_segment_byte(source_segment,
                                                    (word)(source_byte + 2));
            uint8_t color = (uint8_t)((color_byte >> source_shift) & 0x0Fu);
            uint8_t old_value = (uint8_t)((destination >> destination_shift) & 0x0Fu);
            color = (uint8_t)((old_value & mask) | color);
            destination = (uint8_t)((destination & (uint8_t)~field) |
                                    (uint8_t)(color << destination_shift));
        }
        write_segment_byte(workspace_segment, destination_offset, destination);
    }
}

word render_platform_draw_sprite(RenderSpriteRequest *request)
{
    HostBlitterInfo info;
    word row;
    word source_row = request->source_offset;
    word destination_row = request->workspace_offset;
    word source_row_bytes;

    describe_blitter(request->blitter, &info);
    if (!info.recognized) return request->rows;

    if (info.adapter == VIDEO_CGA)
        source_row_bytes = (word)(info.width / 2);
    else if (info.adapter == VIDEO_EGA)
        source_row_bytes = (word)((info.width / 8) * 5);
    else
        source_row_bytes = info.width;

    for (row = 0; row != request->rows; ++row) {
        if (info.adapter == VIDEO_CGA)
            draw_cga_sprite_row(request->source_segment, source_row,
                                request->workspace_segment, destination_row,
                                info.width, info.phase, info.flash);
        else if (info.adapter == VIDEO_EGA)
            draw_ega_sprite_row(request->source_segment, source_row,
                                request->workspace_segment, destination_row,
                                info.width, info.phase, info.flash);
        else
            draw_tandy_sprite_row(request->source_segment, source_row,
                                  request->workspace_segment, destination_row,
                                  info.width, info.flash);
        source_row = (word)(source_row + source_row_bytes);
        destination_row = (word)(destination_row +
            (info.adapter == VIDEO_CGA ? CGA_WORKSPACE_ROW_BYTES :
                                          TANDY_WORKSPACE_ROW_BYTES));
    }
    return request->rows;
}

dword render_platform_blit_panel(RenderPanelRequest *request)
{
    word source = request->image_offset;
    word destination = request->screen_offset;
    word rows = read_segment_word(request->source_segment, source);
    word width_units;
    word row;

    source = (word)(source + 2);
    width_units = read_segment_word(request->source_segment, source);
    source = (word)(source + 2);

    if (VideoAdapter == VIDEO_EGA) {
        word plane_bytes = width_units;
        for (row = 0; row != rows; ++row) {
            word plane;
            for (plane = 0; plane != 4; ++plane) {
                word byte;
                for (byte = 0; byte != plane_bytes; ++byte) {
                    write_ega_segment_byte(ScreenSegment, plane,
                                           (word)(destination + byte),
                                           read_segment_byte(request->source_segment,
                                                             (word)(source + byte)));
                }
                source = (word)(source + plane_bytes);
            }
            destination = (word)(destination + HOST_EGA_SCREEN_ROW_BYTES);
        }
    } else {
        word row_bytes = (word)(width_units *
                               (VideoAdapter == VIDEO_CGA ? 2u : 4u));
        for (row = 0; row != rows; ++row) {
            copy_segment_bytes(request->source_segment, source,
                               ScreenSegment, destination, row_bytes);
            source = (word)(source + row_bytes);
            if (VideoAdapter == VIDEO_CGA) {
                destination = (word)(destination + HOST_CGA_BANK_BYTES);
                if ((destination & (2u * HOST_CGA_BANK_BYTES)) != 0)
                    destination = (word)(destination + HOST_CGA_SCREEN_ROW_BYTES -
                                         2u * HOST_CGA_BANK_BYTES);
            } else {
                destination = (word)(destination + HOST_TANDY_BANK_BYTES);
                if ((destination & (4u * HOST_TANDY_BANK_BYTES)) != 0)
                    destination = (word)(destination + HOST_TANDY_SCREEN_ROW_BYTES -
                                         4u * HOST_TANDY_BANK_BYTES);
            }
        }
    }

    return ((dword)ScreenSegment << 16) | source;
}

word render_platform_star_is_clear(RenderStarRequest *request)
{
    word plane;
    if (read_segment_byte(request->workspace_segment, request->workspace_offset) != 0)
        return 0;
    if (request->adapter != VIDEO_EGA) return 1;
    for (plane = 1; plane != 4; ++plane) {
        word offset = (word)(request->workspace_offset + plane * HOST_EGA_PLANE_ROW_BYTES);
        if (read_segment_byte(request->workspace_segment, offset) != 0) return 0;
    }
    return 1;
}

void render_platform_plot_star(RenderStarRequest *request)
{
    uint8_t mask = (uint8_t)request->mask;
    word planes = request->planes;
    if (planes == 4)
        write_segment_byte(request->workspace_segment,
                           (word)(request->workspace_offset + 3 * HOST_EGA_PLANE_ROW_BYTES),
                           mask);
    if (planes != 1) {
        write_segment_byte(request->workspace_segment,
                           (word)(request->workspace_offset + 2 * HOST_EGA_PLANE_ROW_BYTES),
                           mask);
        write_segment_byte(request->workspace_segment,
                           (word)(request->workspace_offset + HOST_EGA_PLANE_ROW_BYTES),
                           mask);
    }
    write_segment_byte(request->workspace_segment, request->workspace_offset, mask);
}

void render_platform_erase_star(RenderStarRequest *request)
{
    word plane;
    if (request->adapter == VIDEO_EGA) {
        for (plane = 1; plane != 4; ++plane)
            write_segment_byte(request->workspace_segment,
                               (word)(request->workspace_offset + plane * HOST_EGA_PLANE_ROW_BYTES),
                               0);
    }
    write_segment_byte(request->workspace_segment, request->workspace_offset, 0);
}

static word previous_cga_row(word offset)
{
    word step = (offset & HOST_CGA_BANK_BYTES) != 0 ?
                (word)(HOST_CGA_SCREEN_ROW_BYTES - HOST_CGA_BANK_BYTES) :
                (word)HOST_CGA_BANK_BYTES;
    return (word)(offset - step);
}

static word previous_tandy_row(word offset)
{
    if ((offset & (3u * HOST_TANDY_BANK_BYTES)) == 0)
        offset = (word)(offset + 4u * HOST_TANDY_BANK_BYTES -
                        HOST_TANDY_SCREEN_ROW_BYTES);
    return (word)(offset - HOST_TANDY_BANK_BYTES);
}

dword render_platform_draw_fuel_bars(RenderFuelRequest *request)
{
    word destination = request->screen_offset;
    word count;

    for (count = 0; count != request->full_bars; ++count) {
        if (request->adapter == VIDEO_CGA) {
            write_segment_word(request->screen_segment, destination, 0xA02Fu);
            destination = previous_cga_row(destination);
            destination = previous_cga_row(destination);
        } else if (request->adapter == VIDEO_EGA) {
            static const uint8_t full_plane_values[4] = { 0x30u, 0x7Cu, 0xFFu, 0xFEu };
            word plane;
            for (plane = 0; plane != 4; ++plane)
                write_ega_segment_byte(request->screen_segment, plane, destination,
                                       full_plane_values[plane]);
            destination = (word)(destination - 2u * HOST_EGA_SCREEN_ROW_BYTES);
        } else {
            write_segment_word(request->screen_segment, destination, 0xFFCEu);
            write_segment_word(request->screen_segment, (word)(destination + 2), 0xC4EEu);
            destination = previous_tandy_row(destination);
            destination = previous_tandy_row(destination);
        }
    }

    for (count = 0; count != request->empty_bars; ++count) {
        if (request->adapter == VIDEO_CGA) {
            write_segment_word(request->screen_segment, destination, 0);
            destination = previous_cga_row(destination);
            destination = previous_cga_row(destination);
        } else if (request->adapter == VIDEO_EGA) {
            word plane;
            for (plane = 0; plane != 4; ++plane)
                write_ega_segment_byte(request->screen_segment, plane, destination, 0);
            destination = (word)(destination - 2u * HOST_EGA_SCREEN_ROW_BYTES);
        } else {
            write_segment_word(request->screen_segment, destination, 0);
            write_segment_word(request->screen_segment, (word)(destination + 2), 0);
            destination = previous_tandy_row(destination);
            destination = previous_tandy_row(destination);
        }
    }

    return ((dword)request->screen_segment << 16) | destination;
}

void render_call_main(main_routine target)
{
    if (target != HOST_TOKEN_FLIPEGADRAWPAGE) abort();
    if (VideoAdapter != VIDEO_EGA) return;

    EgaPageToggle = (word)((EgaPageToggle + 1) & 1u);
    ScreenSegment = (word)(HOST_EGA_PAGE0_SEGMENT +
                           EgaPageToggle * HOST_EGA_PAGE_SEGMENT_DELTA);
}
