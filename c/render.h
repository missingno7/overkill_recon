/* Descriptor ABI for render.c.  All descriptors live in the C stack frame;
   they are requests to pixel-only MAIN services, not shadow game state. */
#ifndef RENDER_H
#define RENDER_H

#include "game.h"

typedef struct RenderCopyRequest {
    word workspace_segment;
    word state_segment;
    word workspace_offset;
    word save_offset;
    word bytes_per_plane;
    word workspace_row_bytes;
    word rows;
    word planes;
    word to_workspace;
} RenderCopyRequest;

typedef struct RenderSpriteRequest {
    word blitter;
    word source_segment;
    word source_offset;
    word workspace_segment;
    word workspace_offset;
    word rows;
} RenderSpriteRequest;

typedef struct RenderPanelRequest {
    word image_offset;
    word screen_offset;
    word source_segment;
    word state_segment;
} RenderPanelRequest;

typedef struct RenderStarRequest {
    word workspace_segment;
    word workspace_offset;
    word adapter;
    word mask;
    word planes;
} RenderStarRequest;

typedef struct RenderFuelRequest {
    word screen_segment;
    word screen_offset;
    word adapter;
    word full_bars;
    word empty_bars;
} RenderFuelRequest;

typedef struct RenderUpgradeSlot {
    word icon;
    word screen;
    word image;
    word list;
    word index;
} RenderUpgradeSlot;

/* These are existing CS storage/tables in the all-public hybrid link. */
extern word __far MainDataSegment;
extern word __far WorkspaceSegment;
extern volatile word __far VideoAdapter;
extern word __far PanelSegment;
extern volatile word __far ScreenSegment;
extern word __far Sprites1x1Segment;
extern word __far Sprites2x2Segment;
extern word __far Sprites2x2CSegment;
extern word __far ManExplSegment;
extern word __far LevelSpritesSegment;
extern volatile word __far Sprite32HalfSource;
extern volatile word __far Sprite32HalfSegment;

extern word __far Sprite8Offsets[];
extern word __far Sprite16Offsets[];
extern word __far Sprite32Offsets[];
extern word __far Sprite8Blitters[];
extern word __far Sprite16Blitters[];
extern word __far FlashSprite16Blitters[];
extern word __far Sprite32Blitters[];
extern word __far FlashSprite32Blitters[];
extern word __far PanelImageOffsets[];
extern void FlipEgaDrawPage(void);

/* Pixel-only helpers.  The copy helper preserves DS=state and sets ES to the same
   segment the old save/restore leaf left.  The sprite helper returns the BP value of
   the selected pixel entry in AX.  The panel helper returns ES:SI in DX:AX. */
void __far render_platform_copy_rows(RenderCopyRequest *request);
#pragma aux render_platform_copy_rows parm [si] modify exact [ax bx cx dx si di es]

word __far render_platform_draw_sprite(RenderSpriteRequest *request);
#pragma aux render_platform_draw_sprite parm [si] value [ax] modify exact [ax bx cx dx si di es]

dword __far render_platform_blit_panel(RenderPanelRequest *request);
#pragma aux render_platform_blit_panel parm [si] value [dx ax] modify exact [ax bx cx dx si di es]

word __far render_platform_star_is_clear(RenderStarRequest *request);
#pragma aux render_platform_star_is_clear parm [si] value [ax] modify exact [ax bx cx dx si di es]

void __far render_platform_plot_star(RenderStarRequest *request);
#pragma aux render_platform_plot_star parm [si] modify exact [ax bx cx dx si di es]

void __far render_platform_erase_star(RenderStarRequest *request);
#pragma aux render_platform_erase_star parm [si] modify exact [ax bx cx dx si di es]

dword __far render_platform_draw_fuel_bars(RenderFuelRequest *request);
#pragma aux render_platform_draw_fuel_bars parm [si] value [dx ax] modify exact [ax bx cx dx si di es]

void render_call_main(main_routine target);
#pragma aux render_call_main "FarCallMainNearViaAX" far parm [ax] modify exact [ax]

word render_record_workspace_offset(volatile Record *record);
void render_save_record_background(volatile Record *record);
void render_restore_record_background(volatile Record *record);
word render_draw_record_sprite(volatile Record *record);
word render_draw_records_to_workspace(void);
word render_restore_record_backgrounds(void);
void render_draw_stars(void);
void render_erase_stars(void);
dword render_draw_upgrade_slots(void);
#pragma aux render_draw_upgrade_slots value [dx ax] modify exact [ax dx]
dword render_draw_energy_gauge(void);
#pragma aux render_draw_energy_gauge value [dx ax] modify exact [ax dx]
dword render_draw_fuel_gauge_page(void);
#pragma aux render_draw_fuel_gauge_page value [dx ax] modify exact [ax dx]
dword render_draw_fuel_gauge(void);
#pragma aux render_draw_fuel_gauge value [dx ax] modify exact [ax dx]

#endif
