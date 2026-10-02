#ifndef OVERKILL_HOST_SDL_VIDEO_H
#define OVERKILL_HOST_SDL_VIDEO_H
#include <stddef.h>
#include <stdint.h>

int overkill_sdl_video_open(void);
void overkill_sdl_video_close(void);
void overkill_sdl_video_palette(unsigned index, uint8_t red, uint8_t green, uint8_t blue);
int overkill_sdl_video_present(uint16_t adapter, uint16_t segment);
int overkill_sdl_video_present_text(uint16_t segment, int blink_visible);
void overkill_sdl_video_text_cursor(unsigned row, unsigned column, int visible);
int overkill_sdl_video_save_bmp(const char *path);
/* Decoding is separate from SDL presentation so each bank/plane can be checked. */
int overkill_video_decode_indices(uint16_t adapter, uint16_t segment,
                                  uint8_t *pixels, size_t pitch);
#endif
