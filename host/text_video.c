#include "text_video.h"

#include "memory.h"
#include "../third_party/font8x8/font8x8_cp437.h"

#define TEXT_COLUMNS 80u
#define TEXT_ROWS 25u
#define CELL_WIDTH 8u
#define CELL_HEIGHT 8u
#define TEXT_WIDTH (TEXT_COLUMNS * CELL_WIDTH)
#define TEXT_HEIGHT (TEXT_ROWS * CELL_HEIGHT)

int overkill_text_decode_indices(uint16_t segment, uint8_t *pixels,
                                 size_t pitch, int blink_visible)
{
    const uint8_t *page;
    unsigned cell_y;

    if (pixels == NULL || pitch < TEXT_WIDTH || pitch > SIZE_MAX / TEXT_HEIGHT)
        return 0;

    page = (const uint8_t *)overkill_segment_address(segment, 0);
    for (cell_y = 0; cell_y < TEXT_ROWS; ++cell_y) {
        unsigned cell_x;

        for (cell_x = 0; cell_x < TEXT_COLUMNS; ++cell_x) {
            size_t cell = (size_t)(cell_y * TEXT_COLUMNS + cell_x) * 2u;
            uint8_t character = page[cell];
            uint8_t attribute = page[cell + 1u];
            uint8_t foreground = attribute & 0x0Fu;
            uint8_t background = (attribute >> 4) & 0x07u;
            const uint8_t *glyph = overkill_cp437_font[character];
            unsigned glyph_y;

            if ((attribute & 0x80u) != 0 && blink_visible == 0)
                foreground = background;

            for (glyph_y = 0; glyph_y < CELL_HEIGHT; ++glyph_y) {
                uint8_t *row = pixels + (size_t)(cell_y * CELL_HEIGHT + glyph_y) * pitch +
                               (size_t)cell_x * CELL_WIDTH;
                uint8_t bits = glyph[glyph_y];
                unsigned glyph_x;

                for (glyph_x = 0; glyph_x < CELL_WIDTH; ++glyph_x)
                    row[glyph_x] = (bits & (0x80u >> glyph_x)) != 0 ?
                                   foreground : background;
            }
        }
    }

    return 1;
}
