#include "graphics_decode.h"

#include "game.h"
#include "memory.h"
#include "presentation_services.h"
#include "video_services.h"

#include <stdint.h>

enum {
    ADAPTER_CGA = 0,
    ADAPTER_EGA = 1,
    ADAPTER_TANDY = 2,
    COLOR_REMAP_SWAP_6_12 = 1,
    COLOR_REMAP_NONE = 2,
    COLOR_PLANES = 4,
    PIXELS_PER_SOURCE_BYTE = 8
};

static byte segment_read_byte(word segment, word offset)
{
    return *(byte *)overkill_segment_address(segment, offset);
}

static word segment_read_word(word segment, word offset)
{
    byte low = segment_read_byte(segment, offset);
    byte high = segment_read_byte(segment, (word)(offset + 1));
    return (word)((word)low | ((word)high << 8));
}

static void segment_write_byte(word segment, word offset, byte value)
{
    *(byte *)overkill_segment_address(segment, offset) = value;
}

static void segment_write_word(word segment, word offset, word value)
{
    segment_write_byte(segment, offset, (byte)value);
    segment_write_byte(segment, (word)(offset + 1), (byte)(value >> 8));
}

#define CS_BYTE(name) \
    segment_read_byte(HOST_SEGMENT_##name, HOST_OFFSET_##name)
#define CS_WORD(name) \
    segment_read_word(HOST_SEGMENT_##name, HOST_OFFSET_##name)
#define CS_SET_BYTE(name, value) \
    segment_write_byte(HOST_SEGMENT_##name, HOST_OFFSET_##name, (byte)(value))
#define CS_SET_WORD(name, value) \
    segment_write_word(HOST_SEGMENT_##name, HOST_OFFSET_##name, (word)(value))

static uint32_t dos_loop_count(word count)
{
    /* Every relevant x86 LOOP body is entered once before LOOP decrements CX. */
    return count == 0 ? 0x10000u : count;
}

static word add_word(word left, word right)
{
    return (word)(left + right);
}

static void write_load_image_slot(word slot, word value)
{
    segment_write_word(HOST_SEGMENT_LOADIMAGESLOT, slot, value);
}

static byte source_byte(word source_segment, word offset)
{
    return segment_read_byte(source_segment, offset);
}

static void record_image_header(word source_segment, word destination_segment,
                                word *source_offset, word *destination_offset,
                                word *rows, word *row_bytes)
{
    word slot = CS_WORD(LOADIMAGESLOT);
    word header_rows = segment_read_word(source_segment, *source_offset);
    word header_row_bytes;
    int record = CS_WORD(LOADRECORDIMAGES) != 0;

    CS_SET_WORD(LOADIMAGESLOT, add_word(slot, 2));
    *source_offset = add_word(*source_offset, 2);
    if (record) {
        write_load_image_slot(slot, *destination_offset);
        segment_write_word(destination_segment, *destination_offset, header_rows);
        *destination_offset = add_word(*destination_offset, 2);
    }
    *rows = header_rows;
    CS_SET_WORD(DECODEROWS, header_rows);

    header_row_bytes = segment_read_word(source_segment, *source_offset);
    *source_offset = add_word(*source_offset, 2);
    if (record) {
        segment_write_word(destination_segment, *destination_offset,
                           header_row_bytes);
        *destination_offset = add_word(*destination_offset, 2);
    }
    *row_bytes = header_row_bytes;
    CS_SET_WORD(DECODEPLANEROWBYTES, header_row_bytes);
}

static int next_image_header(word source_segment, word destination_segment,
                             word *source_offset, word *destination_offset,
                             word *rows, word *row_bytes)
{
    word header_rows = segment_read_word(source_segment, *source_offset);
    word header_bytes = segment_read_word(
        source_segment, add_word(*source_offset, 2));

    if ((word)(header_rows | header_bytes) == 0) return 0;
    record_image_header(source_segment, destination_segment, source_offset,
                        destination_offset, rows, row_bytes);
    return 1;
}

static byte rotate_right(byte value)
{
    return (byte)((value >> 1) | ((value & 1u) << 7));
}

static void extract_pixel_pair(byte plane_bytes[COLOR_PLANES], word *group_state,
                               int make_mask, byte transparent_color,
                               int map_to_cga, byte *color_pair, byte *mask_pair)
{
    static const byte plane_order[COLOR_PLANES] = { 3, 2, 1, 0 };
    byte color = (byte)*group_state;
    byte mask = (byte)(*group_state >> 8);
    unsigned pixel, plane;

    for (pixel = 0; pixel < 2; pixel++) {
        for (plane = 0; plane < COLOR_PLANES; plane++) {
            byte *input = &plane_bytes[plane_order[plane]];
            byte carry = (byte)(*input & 1u);
            *input = rotate_right(*input);
            color = (byte)((color << 1) | carry);
        }
    }
    for (plane = 0; plane < 4; plane++)
        color = (byte)((color >> 1) | ((color & 1u) << 7));

    if (make_mask) {
        mask = 0;
        if ((color & 0x0Fu) == transparent_color) {
            mask = (byte)(mask | 0x0Fu);
            color = (byte)(color & 0xF0u);
        }
        if ((color >> 4) == transparent_color) {
            mask = (byte)(mask | 0xF0u);
            color = (byte)(color & 0x0Fu);
        }
    }

    if (map_to_cga) {
        byte low = segment_read_byte(HOST_SEGMENT_CGACOLORMAP,
                                     add_word(HOST_OFFSET_CGACOLORMAP,
                                              (word)(color & 0x0Fu)));
        byte high = segment_read_byte(HOST_SEGMENT_CGACOLORMAP,
                                      add_word(HOST_OFFSET_CGACOLORMAP,
                                               (word)(color >> 4)));
        color = (byte)(low | (byte)(high << 4));
        CS_SET_WORD(CGASAVEDAX,
                    (word)((word)plane_bytes[1] << 8) | plane_bytes[0]);
    }

    *group_state = (word)(((word)mask << 8) | color);
    *color_pair = color;
    *mask_pair = mask;
}

static word pack_cga_pair(word packed, byte pair)
{
    static const byte source_bits[4] = { 5, 4, 1, 0 };
    unsigned index;
    for (index = 0; index < 4; index++) {
        byte carry = (byte)((pair >> source_bits[index]) & 1u);
        packed = (word)((packed << 1) | carry);
    }
    return packed;
}

static byte pixel_byte(unsigned index)
{
    return segment_read_byte(HOST_SEGMENT_DECODEPIXELBYTES,
                             add_word(HOST_OFFSET_DECODEPIXELBYTES,
                                      (word)index));
}

static byte decoder_plane_bit(unsigned index)
{
    return segment_read_byte(HOST_SEGMENT_DECODEPLANEBITS,
                             add_word(HOST_OFFSET_DECODEPLANEBITS,
                                      (word)index));
}

static void decoder_array_set_byte(word base, unsigned index, byte value)
{
    segment_write_byte(HOST_SEGMENT_DECODEPLANEBITS,
                       add_word(base, (word)index), value);
}

static void set_pixel_byte(unsigned index, byte value)
{
    segment_write_byte(HOST_SEGMENT_DECODEPIXELBYTES,
                       add_word(HOST_OFFSET_DECODEPIXELBYTES, (word)index),
                       value);
}

static void decode_packed_group(word source_segment, word destination_segment,
                                word *source_offset, word *destination_offset,
                                word row_bytes, word group_count, int make_mask,
                                int adapter, byte transparent_color)
{
    word second = add_word(*source_offset, row_bytes);
    word double_row_bytes = (word)(row_bytes << 1);
    word third = add_word(*source_offset, double_row_bytes);
    word fourth = add_word(*source_offset,
                           add_word(double_row_bytes, row_bytes));
    byte plane_bytes[COLOR_PLANES];
    unsigned pair;

    plane_bytes[0] = source_byte(source_segment, *source_offset);
    plane_bytes[1] = source_byte(source_segment, second);
    plane_bytes[2] = source_byte(source_segment, third);
    plane_bytes[3] = source_byte(source_segment, fourth);

    {
        word group_state = group_count;
        for (pair = 0; pair < 4; pair++) {
            byte color, mask;
            extract_pixel_pair(plane_bytes, &group_state, make_mask,
                               transparent_color, adapter == ADAPTER_CGA,
                               &color, &mask);
            if (pair == 0) {
                set_pixel_byte(1, color);
                set_pixel_byte(5, mask);
            } else if (pair == 1) {
                set_pixel_byte(0, color);
                set_pixel_byte(4, mask);
            } else if (pair == 2) {
                set_pixel_byte(3, color);
                set_pixel_byte(7, mask);
            } else {
                set_pixel_byte(2, color);
                set_pixel_byte(6, mask);
            }
        }
    }

    *source_offset = add_word(*source_offset, 1);
    if (adapter == ADAPTER_CGA) {
        word packed;
        if (make_mask) {
            packed = CS_WORD(CGAPIXELWORD);
            packed = pack_cga_pair(packed, pixel_byte(4));
            packed = pack_cga_pair(packed, pixel_byte(5));
            packed = pack_cga_pair(packed, pixel_byte(6));
            packed = pack_cga_pair(packed, pixel_byte(7));
            CS_SET_WORD(CGAPIXELWORD, packed);
            segment_write_word(destination_segment, *destination_offset, packed);
            *destination_offset = add_word(*destination_offset, 2);
        }
        packed = CS_WORD(CGAPIXELWORD);
        packed = pack_cga_pair(packed, pixel_byte(0));
        packed = pack_cga_pair(packed, pixel_byte(1));
        packed = pack_cga_pair(packed, pixel_byte(2));
        packed = pack_cga_pair(packed, pixel_byte(3));
        CS_SET_WORD(CGAPIXELWORD, packed);
        segment_write_word(destination_segment, *destination_offset, packed);
        *destination_offset = add_word(*destination_offset, 2);
    } else {
        if (make_mask) {
            segment_write_word(destination_segment, *destination_offset,
                               segment_read_word(HOST_SEGMENT_DECODEPIXELBYTES,
                                                 add_word(HOST_OFFSET_DECODEPIXELBYTES,
                                                          6)));
            *destination_offset = add_word(*destination_offset, 2);
        }
        segment_write_word(destination_segment, *destination_offset,
                           segment_read_word(HOST_SEGMENT_DECODEPIXELBYTES,
                                             add_word(HOST_OFFSET_DECODEPIXELBYTES,
                                                      2)));
        *destination_offset = add_word(*destination_offset, 2);
        if (make_mask) {
            segment_write_word(destination_segment, *destination_offset,
                               segment_read_word(HOST_SEGMENT_DECODEPIXELBYTES,
                                                 add_word(HOST_OFFSET_DECODEPIXELBYTES,
                                                          4)));
            *destination_offset = add_word(*destination_offset, 2);
        }
        segment_write_word(destination_segment, *destination_offset,
                           segment_read_word(HOST_SEGMENT_DECODEPIXELBYTES,
                                             HOST_OFFSET_DECODEPIXELBYTES));
        *destination_offset = add_word(*destination_offset, 2);
    }
}

static byte rotate_left(byte value)
{
    return (byte)((value << 1) | (value >> 7));
}

static void build_ega_mask_row(word source_segment, word destination_segment,
                               word *source_offset, word *destination_offset,
                               word row_bytes, byte transparent_color)
{
    uint32_t group, groups = dos_loop_count(row_bytes);
    for (group = 0; group < groups; group++) {
        word second = add_word(*source_offset, row_bytes);
        word double_row_bytes = (word)(row_bytes << 1);
        word third = add_word(*source_offset, double_row_bytes);
        word fourth = add_word(*source_offset,
                               add_word(double_row_bytes, row_bytes));
        byte planes[COLOR_PLANES];
        byte mask = 0;
        unsigned pixel;

        planes[0] = source_byte(source_segment, *source_offset);
        planes[1] = source_byte(source_segment, second);
        planes[2] = source_byte(source_segment, third);
        planes[3] = source_byte(source_segment, fourth);
        CS_SET_BYTE(EGAMASKBITS, 0);
        for (pixel = 0; pixel < PIXELS_PER_SOURCE_BYTE; pixel++) {
            unsigned source_bit = 7u - pixel;
            byte color = (byte)((((planes[3] >> source_bit) & 1u) << 3) |
                                (((planes[2] >> source_bit) & 1u) << 2) |
                                (((planes[1] >> source_bit) & 1u) << 1) |
                                ((planes[0] >> source_bit) & 1u));
            byte prior_color = CS_BYTE(EGAPIXELCOLOR);
            prior_color = (byte)(((prior_color << 4) | color) & 0x0Fu);
            CS_SET_BYTE(EGAPIXELCOLOR, prior_color);
            mask = (byte)((mask << 1) | (color == transparent_color));
            CS_SET_BYTE(EGAMASKBITS, mask);
        }
        segment_write_byte(destination_segment, *destination_offset, mask);
        *source_offset = add_word(*source_offset, 1);
        *destination_offset = add_word(*destination_offset, 1);
    }
}

static void copy_ega_planes_to_row_buffer(word source_segment,
                                          word *source_offset,
                                          word row_bytes)
{
    word buffer_offset = HOST_OFFSET_DECODEROWBUFFER;
    unsigned plane;

    for (plane = 0; plane < COLOR_PLANES; plane++) {
        uint32_t index, bytes = dos_loop_count(row_bytes);
        for (index = 0; index < bytes; index++) {
            byte value = source_byte(source_segment, *source_offset);
            segment_write_byte(HOST_SEGMENT_DECODEROWBUFFER, buffer_offset, value);
            *source_offset = add_word(*source_offset, 1);
            buffer_offset = add_word(buffer_offset, 1);
        }
        buffer_offset = add_word((word)(buffer_offset - row_bytes),
                                 DECODE_PLANE_BYTES);
    }
}

static void store_ega_plane_row(word destination_segment,
                                word *destination_offset,
                                word row_buffer_offset, word row_bytes)
{
    uint32_t index, count = dos_loop_count(row_bytes);
    for (index = 0; index < count; index++) {
        byte value = segment_read_byte(HOST_SEGMENT_DECODEROWBUFFER,
                                       row_buffer_offset);
        segment_write_byte(destination_segment, *destination_offset, value);
        row_buffer_offset = add_word(row_buffer_offset, 1);
        *destination_offset = add_word(*destination_offset, 1);
        CS_SET_WORD(DECODEDEST, *destination_offset);
    }
}

static byte remap_ega_color(byte color, word file_flags, word image_index,
                            word main_data_segment, word *bp)
{
    byte mode;
    word flag_offset;
    if (CS_BYTE(PERFILEFLAGSENABLED) != 1) return color;

    *bp = file_flags;
    if (file_flags == 0xFFFFu) return color;
    flag_offset = add_word(file_flags, image_index);
    *bp = flag_offset;
    mode = segment_read_byte(main_data_segment, flag_offset);
    if (mode == COLOR_REMAP_SWAP_6_12) {
        if (color == 6) return 12;
        if (color == 12) return 6;
    } else if (mode == COLOR_REMAP_NONE) {
        return color;
    }
    return color;
}

static void decode_ega_row(word source_segment, word destination_segment,
                           word *source_offset, word *destination_offset,
                           word row_bytes, int make_mask, byte transparent_color,
                           word file_flags, word image_index,
                           word main_data_segment, word *bp)
{
    uint32_t column, columns;
    word row_buffer_offset;
    if (make_mask) {
        word row_source = *source_offset;
        build_ega_mask_row(source_segment, destination_segment, source_offset,
                           destination_offset, row_bytes, transparent_color);
        /* BuildEgaTransparencyMask runs on SI, but the caller saves/restores it
           so plane splitting starts again at plane zero. */
        *source_offset = row_source;
    }

    CS_SET_WORD(DECODEDEST, *destination_offset);
    copy_ega_planes_to_row_buffer(source_segment, source_offset, row_bytes);
    *bp = 0;
    row_buffer_offset = HOST_OFFSET_DECODEROWBUFFER;
    columns = dos_loop_count(row_bytes);
    for (column = 0; column < columns; column++) {
        byte plane_bytes[COLOR_PLANES];
        byte plane_bits[COLOR_PLANES];
        unsigned pixel, plane;
        for (plane = 0; plane < COLOR_PLANES; plane++) {
            plane_bytes[plane] = segment_read_byte(
                HOST_SEGMENT_DECODEROWBUFFER,
                add_word(row_buffer_offset,
                         (word)(plane * DECODE_PLANE_BYTES)));
            plane_bits[plane] = decoder_plane_bit(plane);
        }
        for (pixel = 0; pixel < PIXELS_PER_SOURCE_BYTE; pixel++) {
            byte bl = 0;
            byte color;
            byte carry;
            carry = (byte)(plane_bytes[3] >> 7);
            plane_bytes[3] = rotate_left(plane_bytes[3]);
            bl = (byte)((bl << 1) | carry);
            carry = (byte)(plane_bytes[2] >> 7);
            plane_bytes[2] = rotate_left(plane_bytes[2]);
            bl = (byte)((bl << 1) | carry);
            carry = (byte)(plane_bytes[1] >> 7);
            plane_bytes[1] = rotate_left(plane_bytes[1]);
            bl = (byte)((bl << 1) | carry);
            carry = (byte)(plane_bytes[0] >> 7);
            plane_bytes[0] = rotate_left(plane_bytes[0]);
            bl = (byte)((bl << 1) | carry);
            color = (byte)(bl & 0x0Fu);
            if (make_mask && color == transparent_color) color = 0;
            color = remap_ega_color(color, file_flags, image_index,
                                    main_data_segment, bp);
            for (plane = 0; plane < COLOR_PLANES; plane++) {
                carry = (byte)(color & 1u);
                color = (byte)(color >> 1);
                plane_bits[plane] = (byte)((plane_bits[plane] << 1) | carry);
            }
        }
        for (plane = 0; plane < COLOR_PLANES; plane++) {
            decoder_array_set_byte(HOST_OFFSET_DECODEPLANEBITS, plane,
                                   plane_bits[plane]);
            segment_write_byte(HOST_SEGMENT_DECODEROWBUFFER,
                               add_word(row_buffer_offset,
                                        (word)(plane * DECODE_PLANE_BYTES)),
                               plane_bits[plane]);
        }
        row_buffer_offset = add_word(row_buffer_offset, 1);
    }

    row_buffer_offset = HOST_OFFSET_DECODEROWBUFFER;
    for (unsigned plane = 0; plane < COLOR_PLANES; plane++) {
        store_ega_plane_row(destination_segment, destination_offset,
                            add_word(row_buffer_offset,
                                     (word)(plane * DECODE_PLANE_BYTES)),
                            row_bytes);
    }
}

static void decode_images(word adapter, HostRegisters *registers,
                          int initialize_dispatch)
{
    word source_segment = CS_WORD(WORKSPACESEGMENT);
    word destination_segment = registers->es;
    word source_offset = registers->si;
    word destination_offset = registers->di;
    word rows = 0, row_bytes = 0;
    word file_flags = CS_WORD(DECODEFILEFLAGS);
    word image_index = CS_WORD(DECODEIMAGEINDEX);
    word main_data_segment = CS_WORD(MAINDATASEGMENT);
    byte transparent_color = CS_BYTE(TRANSPARENTCOLOR);
    int make_mask = CS_WORD(LOADMAKEMASK) != 0;
    int saw_image = 0;

    if (initialize_dispatch) {
        file_flags = registers->bp;
        image_index = 0xFFFFu;
        CS_SET_WORD(DECODEFILEFLAGS, file_flags);
        CS_SET_WORD(DECODEIMAGEINDEX, image_index);
    }
    if (adapter > ADAPTER_TANDY) return;

    for (;;) {
        uint32_t row, row_count;
        if (adapter == ADAPTER_EGA) {
            image_index = add_word(CS_WORD(DECODEIMAGEINDEX), 1);
            CS_SET_WORD(DECODEIMAGEINDEX, image_index);
        }
        if (!next_image_header(source_segment, destination_segment,
                               &source_offset, &destination_offset,
                               &rows, &row_bytes))
            break;
        saw_image = 1;
        row_count = dos_loop_count(rows);
        if (adapter == ADAPTER_EGA) {
            for (row = 0; row < row_count; row++) {
                registers->bp = 4;
                decode_ega_row(source_segment, destination_segment,
                               &source_offset, &destination_offset, row_bytes,
                               make_mask, transparent_color, file_flags,
                               image_index, main_data_segment, &registers->bp);
            }
        } else {
            uint32_t group, group_count = dos_loop_count(row_bytes);
            for (row = 0; row < row_count; row++) {
                word current_row_count = row_bytes;
                group_count = dos_loop_count(current_row_count);
                for (group = 0; group < group_count; group++) {
                    word groups_remaining = (word)(current_row_count - (word)group);
                    decode_packed_group(source_segment, destination_segment,
                                        &source_offset, &destination_offset,
                                        row_bytes, groups_remaining, make_mask,
                                        adapter, transparent_color);
                }
                source_offset = add_word(source_offset, row_bytes);
                source_offset = add_word(source_offset, row_bytes);
                source_offset = add_word(source_offset, row_bytes);
            }
        }
    }

    registers->si = source_offset;
    registers->di = destination_offset;
    registers->ax = 0;
    if (saw_image) registers->cx = 0;
}

int overkill_graphics_service(word token, HostRegisters *registers)
{
    if (registers == NULL) return 0;
    if (token == HOST_SERVICE_LEVELSBLITPAGE ||
        token == HOST_TOKEN_BLITPACKEDTOSCREEN) {
        return presentation_dispatch(
            HOST_SERVICE_PRESENTATIONDRAWWORKSPACEBACKGROUND, registers);
    }
    if (token == HOST_TOKEN_DECODEGRAPHICSIMAGES ||
        token == HOST_SERVICE_LEVELSDECODEGRAPHICS) {
        word adapter = CS_WORD(VIDEOADAPTER);
        decode_images(adapter, registers, 1);
        return 1;
    }
    if (token == HOST_TOKEN_DECODEGRAPHICSIMAGESCGA) {
        decode_images(ADAPTER_CGA, registers, 0);
        return 1;
    }
    if (token == HOST_TOKEN_DECODEGRAPHICSIMAGESEGA) {
        decode_images(ADAPTER_EGA, registers, 0);
        return 1;
    }
    if (token == HOST_TOKEN_DECODEGRAPHICSIMAGESTANDY) {
        decode_images(ADAPTER_TANDY, registers, 0);
        return 1;
    }
    return 0;
}
