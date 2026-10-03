#include "video_services.h"

#include "game.h"
#include "memory.h"
#include "render.h"
#include "render_services.h"
#include "resource_services.h"
#include "sdl_video.h"

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define HOST_EGA_PAGE1_SEGMENT 0xA200u
#define HOST_EGA_PAGE0_SEGMENT 0xA000u
#define VIDEO_ALLOCATION_COUNT 12u

#define HOST_MAIN_WORD(name) \
    (*(volatile word *)overkill_segment_address(HOST_SEGMENT_##name, \
                                                 HOST_OFFSET_##name))

static word video_allocation_segments[VIDEO_ALLOCATION_COUNT];
static word presented_segment = 0xB800u;

static uint8_t segment_byte(word segment, word offset)
{
    return *(uint8_t *)overkill_segment_address(segment, offset);
}

static void set_segment_byte(word segment, word offset, uint8_t value)
{
    *(uint8_t *)overkill_segment_address(segment, offset) = value;
}

static word segment_word(word segment, word offset)
{
    word low = segment_byte(segment, offset);
    word high = segment_byte(segment, (word)(offset + 1u));
    return (word)(low | (word)(high << 8));
}

static word symbol_word(word segment, word offset)
{
    return segment_word(segment, offset);
}

static void copy_segment(word source_segment, word source_offset,
                         word destination_segment, word destination_offset,
                         uint32_t bytes)
{
    uint32_t i;
    for (i = 0; i != bytes; ++i) {
        set_segment_byte(destination_segment, (word)(destination_offset + i),
                         segment_byte(source_segment, (word)(source_offset + i)));
    }
}

static void clear_segment(word segment, word offset, uint32_t bytes)
{
    uint32_t i;
    for (i = 0; i != bytes; ++i)
        set_segment_byte(segment, (word)(offset + i), 0);
}

static void copy_ega_plane(word source_segment, word source_offset,
                           word destination_segment, word destination_offset,
                           word plane, word bytes)
{
    word i;
    for (i = 0; i != bytes; ++i) {
        *overkill_ega_plane_address(destination_segment, plane,
                                    (word)(destination_offset + i)) =
            segment_byte(source_segment, (word)(source_offset + i));
    }
}

static void clear_ega_page(word page_segment, word start, word bytes)
{
    word plane;
    for (plane = 0; plane != 4; ++plane) {
        word i;
        for (i = 0; i != bytes; ++i)
            *overkill_ega_plane_address(page_segment, plane, (word)(start + i)) = 0;
    }
}

static word next_cga_screen_row(word offset)
{
    offset = (word)(offset + CGA_BANK_BYTES);
    if ((offset & (2u * CGA_BANK_BYTES)) != 0)
        offset = (word)(offset + CGA_SCREEN_ROW_BYTES - 2u * CGA_BANK_BYTES);
    return offset;
}

static word next_tandy_screen_row(word offset)
{
    offset = (word)(offset + TANDY_BANK_BYTES);
    if ((offset & (4u * TANDY_BANK_BYTES)) != 0)
        offset = (word)(offset + TANDY_SCREEN_ROW_BYTES - 4u * TANDY_BANK_BYTES);
    return offset;
}

static word low_product_paragraphs(word factor, word bytes)
{
    uint16_t product = (uint16_t)((uint32_t)factor * (uint32_t)bytes);
    return (word)((product >> 4) + 1u);
}

static word add_weighted_word(word sum, word factor, word value)
{
    uint16_t product = (uint16_t)((uint32_t)factor * (uint32_t)value);
    return (word)(sum + product);
}

static word panel_bank_paragraphs(void)
{
    static const word first_weights[8] = { 1, 16, 8, 7, 6, 4, 4, 18 };
    static const word second_weights[11] = { 2, 2, 2, 2, 2, 2, 2, 1, 1, 6, 1 };
    word sum = 0;
    unsigned i;
    for (i = 0; i != 8; ++i)
        sum = add_weighted_word(sum, first_weights[i], PanelImageBytes[i]);
    for (i = 0; i != 11; ++i)
        sum = add_weighted_word(sum, second_weights[i], PanelImageBytes2[i]);
    return (word)((sum >> 4) + 1u);
}

static word blue_bits_bank_paragraphs(void)
{
    word sum = 0;
    unsigned i;
    for (i = 0; i != 9; ++i)
        sum = (word)(sum + BlueBitsImageBytes[i]);
    sum = add_weighted_word(sum, 3, BlueBitsImageBytes[9]);
    sum = add_weighted_word(sum, 3, BlueBitsImageBytes[10]);
    sum = add_weighted_word(sum, 3, BlueBitsImageBytes[11]);
    sum = (word)(sum + BlueBitsImageBytes[12]);
    return (word)((sum >> 4) + 1u);
}

static void release_video_allocations(void)
{
    unsigned i;
    for (i = VIDEO_ALLOCATION_COUNT; i != 0; --i) {
        word segment = video_allocation_segments[i - 1];
        if (segment != 0) {
            overkill_dos_release_paragraphs(segment);
            video_allocation_segments[i - 1] = 0;
        }
    }
    WorkspaceSegment = 0;
    Sprites1x1Segment = 0;
    Sprites2x2Segment = 0;
    Sprites2x2CSegment = 0;
    LevelSpritesSegment = 0;
    ManExplSegment = 0;
    TheEndSegment = 0;
    PanelSegment = 0;
    PlaqueSegment = 0;
    BlueBitsSegment = 0;
    LevelBlocksSegment = 0;
    ShipSegment = 0;
}

void overkill_video_services_shutdown(void)
{
    release_video_allocations();
}

static void allocate_video_buffers(void)
{
    static const word segment_slots[VIDEO_ALLOCATION_COUNT] = {
        HOST_SEGMENT_WORKSPACESEGMENT,
        HOST_SEGMENT_SPRITES1X1SEGMENT,
        HOST_SEGMENT_SPRITES2X2SEGMENT,
        HOST_SEGMENT_SPRITES2X2CSEGMENT,
        HOST_SEGMENT_LEVELSPRITESSEGMENT,
        HOST_SEGMENT_MANEXPLSEGMENT,
        HOST_SEGMENT_THEENDSEGMENT,
        HOST_SEGMENT_PANELSEGMENT,
        HOST_SEGMENT_PLAQUESEGMENT,
        HOST_SEGMENT_BLUEBITSSEGMENT,
        HOST_SEGMENT_LEVELBLOCKSSEGMENT,
        HOST_SEGMENT_SHIPSEGMENT
    };
    static const word segment_slot_offsets[VIDEO_ALLOCATION_COUNT] = {
        HOST_OFFSET_WORKSPACESEGMENT,
        HOST_OFFSET_SPRITES1X1SEGMENT,
        HOST_OFFSET_SPRITES2X2SEGMENT,
        HOST_OFFSET_SPRITES2X2CSEGMENT,
        HOST_OFFSET_LEVELSPRITESSEGMENT,
        HOST_OFFSET_MANEXPLSEGMENT,
        HOST_OFFSET_THEENDSEGMENT,
        HOST_OFFSET_PANELSEGMENT,
        HOST_OFFSET_PLAQUESEGMENT,
        HOST_OFFSET_BLUEBITSSEGMENT,
        HOST_OFFSET_LEVELBLOCKSSEGMENT,
        HOST_OFFSET_SHIPSEGMENT
    };
    word geometry_offset;
    word *active_geometry;
    word *descriptor = &Sprite8Bytes;
    word requests[VIDEO_ALLOCATION_COUNT];
    volatile word *allocated_total = (volatile word *)overkill_segment_address(
        HOST_SEGMENT_ALLOCATEDPARAGRAPHS, HOST_OFFSET_ALLOCATEDPARAGRAPHS);
    volatile word *slots[VIDEO_ALLOCATION_COUNT];
    unsigned i;

    release_video_allocations();
    *allocated_total = 0;

    geometry_offset = AdapterGeometry[VideoAdapter];
    active_geometry = GAME_PTR(word, geometry_offset);
    for (i = 0; i != 39; ++i)
        descriptor[i] = active_geometry[i];
    PlayfieldRowBytes = active_geometry[39];
    HOST_MAIN_WORD(WIDEROWBYTES) = active_geometry[40];
    ScreenSegment = active_geometry[41];

    ScrollStartOffset = (word)(PlayfieldRowBytes * 16u);
    ScrollBandBytes = ScrollStartOffset;
    HOST_MAIN_WORD(SCROLLMIRRORDISTANCE) = (word)(ScrollBandBytes * 13u);
    ScrollWrapOffset = (word)(HOST_MAIN_WORD(SCROLLMIRRORDISTANCE) + ScrollBandBytes);

    requests[0] = 0x1000u;
    requests[1] = low_product_paragraphs(0x0075u, Sprite8Bytes);
    requests[2] = low_product_paragraphs(0x00FFu, Sprite16Bytes);
    requests[3] = low_product_paragraphs(0x0082u, Sprite16Bytes);
    requests[4] = low_product_paragraphs(0x000Du, Sprite32Bytes);
    requests[5] = low_product_paragraphs(0x001Cu, Sprite32Bytes);
    requests[6] = (word)((TheEndBytes >> 4) + 1u);
    requests[7] = panel_bank_paragraphs();
    requests[8] = (word)((PlaqueBytes >> 4) + 1u);
    requests[9] = blue_bits_bank_paragraphs();
    requests[10] = low_product_paragraphs(0x0100u, BlockBytes);
    requests[11] = low_product_paragraphs(0x002Cu, BlockBytes);

    for (i = 0; i != VIDEO_ALLOCATION_COUNT; ++i)
        slots[i] = (volatile word *)overkill_segment_address(segment_slots[i],
                                                              segment_slot_offsets[i]);

    for (i = 0; i != VIDEO_ALLOCATION_COUNT; ++i) {
        *allocated_total = (word)(*allocated_total + requests[i]);
        video_allocation_segments[i] = overkill_dos_allocate_paragraphs(requests[i]);
        if (video_allocation_segments[i] == 0) {
            release_video_allocations();
            for (i = 0; i != VIDEO_ALLOCATION_COUNT; ++i) *slots[i] = 0;
            abort();
        }
        *slots[i] = video_allocation_segments[i];
    }

    presented_segment = ScreenSegment;
}

static void clear_workspace(void)
{
    uint32_t bytes = ClearWorkspaceHalfOnly != 0 ? 0x8000u : 0x10000u;
    clear_segment(WorkspaceSegment, 0, bytes);
}

static void build_row_tables(void)
{
    word offset;
    word screen_offset = 0;
    word *block_offsets = (word *)overkill_segment_address(
        HOST_SEGMENT_BLOCKOFFSETS, HOST_OFFSET_BLOCKOFFSETS);
    unsigned i;

    for (i = 0; i != 16; ++i) RecordRowOffsets[i] = 0xFFFFu;
    offset = (word)(0u - (word)(16u * PlayfieldRowBytes));
    for (i = 16; i != 224; ++i) {
        RecordRowOffsets[i] = offset;
        offset = (word)(offset + PlayfieldRowBytes);
    }
    for (i = 224; i != 256; ++i) RecordRowOffsets[i] = 0xFFFFu;

    offset = 0;
    for (i = 0; i != 200; ++i) {
        PlayfieldRowOffsets[i] = offset;
        offset = (word)(offset + PlayfieldRowBytes);
    }
    offset = 0;
    for (i = 0; i != 200; ++i) {
        WideRowOffsets[i] = offset;
        offset = (word)(offset + HOST_MAIN_WORD(WIDEROWBYTES));
    }

    for (i = 0; i != 200; ++i) {
        ScreenRowOffsets[i] = screen_offset;
        if (VideoAdapter == VIDEO_CGA)
            screen_offset = next_cga_screen_row(screen_offset);
        else if (VideoAdapter == VIDEO_EGA)
            screen_offset = (word)(screen_offset + EGA_SCREEN_ROW_BYTES);
        else
            screen_offset = next_tandy_screen_row(screen_offset);
    }

    offset = 0;
    for (i = 0; i != 256; ++i) {
        block_offsets[i] = offset;
        offset = (word)(offset + BlockBytes);
    }
    offset = 0;
    for (i = 0; i != 256; ++i) {
        Sprite8Offsets[i] = offset;
        offset = (word)(offset + Sprite8Bytes);
    }
    offset = 0;
    for (i = 0; i != 256; ++i) {
        Sprite16Offsets[i] = offset;
        offset = (word)(offset + Sprite16Bytes);
    }
    offset = 0;
    for (i = 0; i != 256; ++i) {
        Sprite32Offsets[i] = offset;
        offset = (word)(offset + Sprite32Bytes);
    }

    clear_workspace();
}

static void clear_screen_104x200(void)
{
    word y;
    word row = 0;
    if (VideoAdapter == VIDEO_EGA) {
        word start_page = ScreenSegment;
        for (y = 0; y != 200; ++y) {
            word plane;
            for (plane = 0; plane != 4; ++plane) {
                word x;
                for (x = 0; x != 26; ++x)
                    *overkill_ega_plane_address(start_page, plane,
                                                (word)(row + x)) = 0;
            }
            row = (word)(row + EGA_SCREEN_ROW_BYTES);
        }
        render_call_main(HOST_TOKEN_FLIPEGADRAWPAGE);
        start_page = ScreenSegment;
        row = 0;
        for (y = 0; y != 200; ++y) {
            word plane;
            for (plane = 0; plane != 4; ++plane) {
                word x;
                for (x = 0; x != 26; ++x)
                    *overkill_ega_plane_address(start_page, plane,
                                                (word)(row + x)) = 0;
            }
            row = (word)(row + EGA_SCREEN_ROW_BYTES);
        }
        render_call_main(HOST_TOKEN_FLIPEGADRAWPAGE);
    } else {
        word row_bytes = VideoAdapter == VIDEO_CGA ? 52u : 104u;
        for (y = 0; y != 200; ++y) {
            clear_segment(ScreenSegment, row, row_bytes);
            row = VideoAdapter == VIDEO_CGA ? next_cga_screen_row(row) :
                                               next_tandy_screen_row(row);
        }
    }
}

static void reset_ega_pages(void)
{
    if (VideoAdapter != VIDEO_EGA) return;
    EgaPageToggle = 0;
    ScreenSegment = HOST_EGA_PAGE0_SEGMENT;
    presented_segment = HOST_EGA_PAGE0_SEGMENT;
}

static void clear_screen_all(void)
{
    if (VideoAdapter == VIDEO_CGA) {
        clear_segment(ScreenSegment, 0, 0x4000u);
    } else if (VideoAdapter == VIDEO_EGA) {
        /* The original clears 8000 words through A000:0, crossing the page gap
           and clearing page 1 through scan line 195, byte 8. */
        clear_ega_page(HOST_EGA_PAGE0_SEGMENT, 0,
                       (word)(2u * 200u * EGA_SCREEN_ROW_BYTES));
    } else {
        clear_segment(ScreenSegment, 0, 0x8000u);
    }
}

static void copy_workspace_to_screen(void)
{
    word source_row = ScrollWindowOffset;
    word destination_row;
    word row;

    if (VideoAdapter == VIDEO_CGA) {
        destination_row = (word)(2u * CGA_SCREEN_ROW_BYTES);
        for (row = 0; row != 192; ++row) {
            copy_segment(WorkspaceSegment, source_row, ScreenSegment,
                         destination_row, 52u);
            source_row = (word)(source_row + PlayfieldRowBytes);
            destination_row = next_cga_screen_row(destination_row);
        }
    } else if (VideoAdapter == VIDEO_EGA) {
        destination_row = (word)(4u * EGA_SCREEN_ROW_BYTES);
        for (row = 0; row != 192; ++row) {
            word plane;
            for (plane = 0; plane != 4; ++plane) {
                copy_ega_plane(WorkspaceSegment,
                               (word)(source_row + plane * 26u),
                               ScreenSegment, destination_row, plane, 26u);
            }
            source_row = (word)(source_row + PlayfieldRowBytes);
            destination_row = (word)(destination_row + EGA_SCREEN_ROW_BYTES);
        }
    } else {
        destination_row = TANDY_SCREEN_ROW_BYTES;
        for (row = 0; row != 192; ++row) {
            copy_segment(WorkspaceSegment, source_row, ScreenSegment,
                         destination_row, 104u);
            source_row = (word)(source_row + PlayfieldRowBytes);
            destination_row = next_tandy_screen_row(destination_row);
        }
    }
}

static void copy_full_workspace_to_screen(void)
{
    word source_row = 0;
    word destination_row = 0;
    word row;

    if (VideoAdapter == VIDEO_EGA) {
        for (row = 0; row != 200; ++row) {
            word plane;
            for (plane = 0; plane != 4; ++plane) {
                copy_ega_plane(WorkspaceSegment,
                               (word)(source_row + plane * 40u),
                               ScreenSegment, destination_row, plane, 40u);
            }
            source_row = (word)(source_row + HOST_MAIN_WORD(WIDEROWBYTES));
            destination_row = (word)(destination_row + EGA_SCREEN_ROW_BYTES);
        }
    } else {
        word row_bytes = VideoAdapter == VIDEO_CGA ? 80u : 160u;
        for (row = 0; row != 200; ++row) {
            copy_segment(WorkspaceSegment, source_row, ScreenSegment,
                         destination_row, row_bytes);
            source_row = (word)(source_row + HOST_MAIN_WORD(WIDEROWBYTES));
            destination_row = VideoAdapter == VIDEO_CGA ?
                next_cga_screen_row(destination_row) :
                next_tandy_screen_row(destination_row);
        }
    }
}

static void copy_ega_page0_to_page1(void)
{
    word plane;
    for (plane = 0; plane != 4; ++plane) {
        word i;
        uint8_t *source = overkill_ega_plane_address(HOST_EGA_PAGE0_SEGMENT,
                                                      plane, 0);
        uint8_t *destination = overkill_ega_plane_address(HOST_EGA_PAGE0_SEGMENT,
                                                           plane, EGA_PAGE_BYTES);
        for (i = 0; i != 200u * EGA_SCREEN_ROW_BYTES; ++i)
            destination[i] = source[i];
    }
}

int overkill_video_service(word token, HostRegisters *registers)
{
    if (token == HOST_TOKEN_MEASURERETRACEPOLARITY) {
        /* The virtual CRT has a short active-high retrace interval. The oracle's
           measured polarity is therefore normal, independent of host refresh. */
        *(byte *)overkill_segment_address(HOST_SEGMENT_RETRACEBITINVERTED,
                                          HOST_OFFSET_RETRACEBITINVERTED) = 0;
    } else if (token == HOST_SERVICE_STARTUPSETSELECTEDVIDEOMODE) {
        if (!overkill_sdl_video_open()) abort();
        /* INT 10h mode sets clear video memory unless bit 7 requests preservation.
           Boss-key return uses the same ordinary mode set as startup. */
        if (VideoAdapter == VIDEO_EGA) {
            word plane;
            for (plane = 0; plane != 4; ++plane)
                memset(overkill_ega_plane_address(0xA000, plane, 0), 0, 0x10000);
            presented_segment = 0xA000;
        } else {
            clear_segment(0xB800, 0, VideoAdapter == VIDEO_CGA ? 0x4000u : 0x8000u);
            presented_segment = 0xB800;
        }
    } else if (token == HOST_TOKEN_ALLOCATEBUFFERS) {
        allocate_video_buffers();
        if (registers != NULL) registers->es = MainDataSegment;
    } else if (token == HOST_TOKEN_BUILDROWTABLES) {
        build_row_tables();
        if (registers != NULL) registers->es = WorkspaceSegment;
    } else if (token == HOST_TOKEN_CLEARWORKSPACE) {
        clear_workspace();
        if (registers != NULL) registers->es = WorkspaceSegment;
    } else if (token == HOST_TOKEN_CLEARSCREEN104X200) {
        clear_screen_104x200();
        if (registers != NULL) registers->es = VideoAdapter == VIDEO_EGA ?
            (word)(ScreenSegment ^ 0x0200u) : ScreenSegment;
    } else if (token == HOST_TOKEN_COPYWORKSPACETOSCREEN) {
        copy_workspace_to_screen();
        if (registers != NULL) registers->es = ScreenSegment;
    } else if (token == HOST_TOKEN_COPYFULLWORKSPACETOSCREEN) {
        copy_full_workspace_to_screen();
        if (registers != NULL) registers->es = ScreenSegment;
    } else if (token == HOST_TOKEN_COPYEGAPAGE0TOPAGE1) {
        if (VideoAdapter == VIDEO_EGA) {
            copy_ega_page0_to_page1();
            if (registers != NULL) registers->es = ScreenSegment;
        }
    } else if (token == HOST_TOKEN_RESETPAGEANDCLEARSCREEN) {
        reset_ega_pages();
        clear_screen_all();
        if (registers != NULL) registers->es = ScreenSegment;
    } else if (token == HOST_TOKEN_RESETEGAPAGES) {
        reset_ega_pages();
    } else if (token == HOST_TOKEN_SHOWEGADRAWPAGE) {
        if (VideoAdapter == VIDEO_EGA)
            presented_segment = EgaPageToggle == 0 ? HOST_EGA_PAGE0_SEGMENT :
                                                     HOST_EGA_PAGE1_SEGMENT;
    } else if (token == HOST_TOKEN_FLIPEGADRAWPAGE) {
        render_call_main(HOST_TOKEN_FLIPEGADRAWPAGE);
    } else {
        return 0;
    }
    return 1;
}

word overkill_video_presented_segment(void)
{
    return VideoAdapter == VIDEO_EGA ? presented_segment : ScreenSegment;
}

void host_draw_map_row_into_scroll_band(word map_row_offset)
{
    word destination = (word)(ScrollWindowOffset - ScrollBandBytes);
    word block_segment = MapScrollPos >= MAP_END_ROWS_POS ? ShipSegment :
                                                            LevelBlocksSegment;
    word mirror_bytes;
    word cell;
    word row;

    for (cell = 0; cell != MAP_ROW_BYTES; ++cell) {
        uint8_t tile = *(uint8_t *)overkill_level_map_address(
            (word)(map_row_offset + cell));
        word block_index = (word)(uint8_t)(tile - 1u);
        word block_offset = symbol_word(HOST_SEGMENT_BLOCKOFFSETS,
            (word)(HOST_OFFSET_BLOCKOFFSETS + block_index * 2u));

        if (VideoAdapter == VIDEO_CGA) {
            for (row = 0; row != 16; ++row) {
                word x;
                for (x = 0; x != 4; ++x) {
                    word source = (word)(block_offset + row * 4u + x);
                    word target = (word)(destination + row * CGA_WORKSPACE_ROW_BYTES +
                                         cell * 4u + x);
                    set_segment_byte(WorkspaceSegment, target,
                                     segment_byte(block_segment, source));
                }
            }
        } else if (VideoAdapter == VIDEO_EGA) {
            for (row = 0; row != 16; ++row) {
                word plane;
                for (plane = 0; plane != 4; ++plane) {
                    word x;
                    for (x = 0; x != 2; ++x) {
                        word source = (word)(block_offset + row * 8u +
                                             plane * 2u + x);
                        word target = (word)(destination + row * EGA_WORKSPACE_ROW_BYTES +
                                             plane * EGA_PLANE_ROW_BYTES +
                                             cell * 2u + x);
                        set_segment_byte(WorkspaceSegment, target,
                                         segment_byte(block_segment, source));
                    }
                }
            }
        } else {
            for (row = 0; row != 16; ++row) {
                word x;
                for (x = 0; x != 8; ++x) {
                    word source = (word)(block_offset + row * 8u + x);
                    word target = (word)(destination + row * TANDY_WORKSPACE_ROW_BYTES +
                                         cell * 8u + x);
                    set_segment_byte(WorkspaceSegment, target,
                                     segment_byte(block_segment, source));
                }
            }
        }
    }

    mirror_bytes = (word)(ScrollBandBytes & 0xFFFEu);
    for (cell = 0; cell != mirror_bytes; ++cell) {
        word source = (word)(destination + cell);
        word target = (word)(source + HOST_MAIN_WORD(SCROLLMIRRORDISTANCE));
        set_segment_byte(WorkspaceSegment, target,
                         segment_byte(WorkspaceSegment, source));
    }
}

void host_set_dac_color6(const byte rgb[3])
{
    if (VideoAdapter != VIDEO_EGA) return;
    overkill_sdl_video_palette(6u,
        (uint8_t)((rgb[0] << 2) | (rgb[0] >> 4)),
        (uint8_t)((rgb[1] << 2) | (rgb[1] >> 4)),
        (uint8_t)((rgb[2] << 2) | (rgb[2] >> 4)));
}
