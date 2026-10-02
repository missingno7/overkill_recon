#ifndef OVERKILL_HOST_TEXT_VIDEO_H
#define OVERKILL_HOST_TEXT_VIDEO_H

#include <stddef.h>
#include <stdint.h>

/* Decode an 80x25 character/attribute page to 640x200 palette indices.
 * Returns 1 on success and 0 for an invalid destination or pitch.
 */
int overkill_text_decode_indices(uint16_t segment, uint8_t *pixels,
                                 size_t pitch, int blink_visible);

#endif
