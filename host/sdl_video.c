#include "sdl_video.h"
#include "render_services.h"
#include "memory.h"
#include "text_video.h"
#include <SDL3/SDL.h>

static SDL_Window *window;
static SDL_Renderer *renderer;
static SDL_Texture *texture;
static unsigned texture_width;
static uint8_t indexed[640 * 200];
static uint8_t rgba[640 * 200 * 4];
static uint8_t palette[16][3];
static unsigned cursor_row, cursor_column;
static int cursor_visible;

int overkill_video_decode_indices(uint16_t adapter, uint16_t segment,
                                  uint8_t *pixels, size_t pitch)
{
    unsigned x, y;
    if (!pixels || pitch < 320) return 0;
    if (adapter == VIDEO_EGA) {
        overkill_ega_copy_indexed_page(segment, pixels, pitch);
        return 1;
    }
    if (adapter != VIDEO_TANDY && adapter != VIDEO_CGA) return 0;
    for (y = 0; y < 200; ++y) {
        uint16_t row = adapter == VIDEO_TANDY
            ? (uint16_t)((y & 3) * 0x2000 + (y >> 2) * 160)
            : (uint16_t)((y & 1) * 0x2000 + (y >> 1) * 80);
        for (x = 0; x < 320; ++x) {
            unsigned shift = adapter == VIDEO_TANDY ? 4 - (x & 1) * 4 : 6 - (x & 3) * 2;
            unsigned divisor = adapter == VIDEO_TANDY ? 2 : 4;
            uint8_t value = *(uint8_t *)overkill_segment_address(segment, (uint16_t)(row + x / divisor));
            pixels[y * pitch + x] = (uint8_t)((value >> shift) & (adapter == VIDEO_TANDY ? 15 : 3));
        }
    }
    return 1;
}

void overkill_sdl_video_palette(unsigned index, uint8_t red, uint8_t green, uint8_t blue)
{
    if (index >= 16) return;
    palette[index][0] = red;
    palette[index][1] = green;
    palette[index][2] = blue;
}

int overkill_sdl_video_open(void)
{
    unsigned i;
    if (window) return 1;
    if (!SDL_CreateWindowAndRenderer("Overkill", 960, 720, SDL_WINDOW_RESIZABLE,
                                    &window, &renderer)) return 0;
    texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA32,
                                SDL_TEXTUREACCESS_STREAMING, 320, 200);
    texture_width = 320;
    if (!texture || !SDL_SetTextureScaleMode(texture, SDL_SCALEMODE_NEAREST) ||
        !SDL_SetRenderLogicalPresentation(renderer, 320, 240, SDL_LOGICAL_PRESENTATION_LETTERBOX)) {
        overkill_sdl_video_close();
        return 0;
    }
    /* IBM RGBI reset palette. Palette services update it before presenting. */
    for (i = 0; i < 16; ++i) {
        uint8_t intensity = (i & 8) ? 85 : 0;
        uint8_t red = (uint8_t)(((i & 4) ? 170 : 0) + intensity);
        uint8_t green = (uint8_t)(((i & 2) ? 170 : 0) + intensity);
        uint8_t blue = (uint8_t)(((i & 1) ? 170 : 0) + intensity);
        if (i == 6) green = 85;
        overkill_sdl_video_palette(i, red, green, blue);
    }
    return 1;
}

void overkill_sdl_video_close(void)
{
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    texture = NULL;
    texture_width = 0;
    renderer = NULL;
    window = NULL;
}

int overkill_sdl_video_save_bmp(const char *path)
{
    SDL_Surface *surface;
    int result;
    if (!texture_width || !path) return 0;
    surface = SDL_CreateSurfaceFrom((int)texture_width, 200, SDL_PIXELFORMAT_RGBA32,
                                    rgba, (int)texture_width * 4);
    if (!surface) return 0;
    result = SDL_SaveBMP(surface, path);
    SDL_DestroySurface(surface);
    return result;
}

static int present_indices(unsigned width)
{
    unsigned i;
    const SDL_FRect display = {0, 0, 320, 240};
    if (!renderer) return 0;
    if (texture_width != width) {
        SDL_DestroyTexture(texture);
        texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA32,
                                    SDL_TEXTUREACCESS_STREAMING, width, 200);
        texture_width = width;
        if (!texture || !SDL_SetTextureScaleMode(texture, SDL_SCALEMODE_NEAREST)) return 0;
    }
    for (i = 0; i < width * 200; ++i) {
        unsigned index = indexed[i];
        rgba[i * 4] = palette[index][0];
        rgba[i * 4 + 1] = palette[index][1];
        rgba[i * 4 + 2] = palette[index][2];
        rgba[i * 4 + 3] = 255;
    }
    return SDL_UpdateTexture(texture, NULL, rgba, (int)width * 4) &&
           SDL_RenderClear(renderer) && SDL_RenderTexture(renderer, texture, NULL, &display) &&
           SDL_RenderPresent(renderer);
}

int overkill_sdl_video_present(uint16_t adapter, uint16_t segment)
{
    if (!overkill_video_decode_indices(adapter, segment, indexed, 320)) return 0;
    return present_indices(320);
}

int overkill_sdl_video_present_text(uint16_t segment, int blink_visible)
{
    unsigned x, y;
    if (!overkill_text_decode_indices(segment, indexed, 640, blink_visible)) return 0;
    if (cursor_visible && blink_visible && cursor_row < 25 && cursor_column < 80) {
        uint8_t attribute = *(uint8_t *)overkill_segment_address(segment,
            (uint16_t)((cursor_row * 80 + cursor_column) * 2 + 1));
        for (y = 6; y < 8; ++y)
            for (x = 0; x < 8; ++x)
                indexed[(cursor_row * 8 + y) * 640 + cursor_column * 8 + x] =
                    attribute & 15;
    }
    return present_indices(640);
}

void overkill_sdl_video_text_cursor(unsigned row, unsigned column, int visible)
{
    cursor_row = row;
    cursor_column = column;
    cursor_visible = visible != 0;
}
