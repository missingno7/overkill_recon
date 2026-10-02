#ifndef OVERKILL_HOST_RENDER_SERVICES_H
#define OVERKILL_HOST_RENDER_SERVICES_H

#include "../c/render.h"
#include <stddef.h>
#include <stdint.h>

#define OVERKILL_EGA_WIDTH 320u
#define OVERKILL_EGA_HEIGHT 200u

#ifdef __cplusplus
extern "C" {
#endif

void render_platform_copy_rows(RenderCopyRequest *request);
word render_platform_draw_sprite(RenderSpriteRequest *request);
dword render_platform_blit_panel(RenderPanelRequest *request);
word render_platform_star_is_clear(RenderStarRequest *request);
void render_platform_plot_star(RenderStarRequest *request);
void render_platform_erase_star(RenderStarRequest *request);
dword render_platform_draw_fuel_bars(RenderFuelRequest *request);

/* EGA video RAM is four planar hardware banks, outside the flat DOS RAM arena. */
uint8_t *overkill_ega_plane_address(word page_segment, word plane, word offset);
void overkill_ega_copy_indexed_page(word page_segment, uint8_t *pixels, size_t pitch);

#ifdef __cplusplus
}
#endif

#endif
