/* C owner for reusable record-render state/orchestration and HUD choices.
   Pixel memory transfers, sprite raster routines, star plots, EGA flips, and packed
   panel drawing remain narrow ASM services in render.h/render.asm.  C addresses the
   game's original DS and CS storage directly; it owns no data segment. */

/* SEGMENT: CGAME
   OWNS: DrawRecordsToWorkspace RestoreRecordBackgrounds
   OWNS: RecordWorkspaceOffset RecordWorkspaceOffsetCases RecordWorkspaceOffsetCga RecordWorkspaceOffsetEga RecordWorkspaceOffsetTandy RecordWorkspaceOffscreen
   OWNS: SaveRecordBackground SaveRecordBackgroundCases SaveBackground8Cga SaveBackground16Cga SaveBackground32Cga SaveCgaBackgroundHalf
   OWNS: SaveBackground8Ega SaveBackground16Ega SaveBackground32Ega SaveEgaBackgroundHalf
   OWNS: SaveBackground8Tandy SaveBackground16Tandy SaveBackground32Tandy SaveTandyBackgroundHalf
   OWNS: RestoreRecordBackground RestoreRecordBackgroundCases
   OWNS: RestoreBackground8Cga RestoreBackground16Cga RestoreBackground32Cga RestoreCgaBackgroundHalf
   OWNS: RestoreBackground8Ega RestoreBackground16Ega RestoreBackground32Ega RestoreEgaBackgroundHalf
   OWNS: RestoreBackground8Tandy RestoreBackground16Tandy RestoreBackground32Tandy RestoreTandyBackgroundHalf
   OWNS: DrawRecordSprite DrawRecordSpriteCases DrawSprite8Record DrawSprite16Record DrawSprite32Record DrawSprite32Half
   OWNS: DrawStars DrawStarGroup PlotStarFourPlanes PlotStarThreePlanes PlotStar DrawStarNext EraseStars
   OWNS: DrawUpgradeSlots DrawUpgradeSlotsOnPage DrawUpgradeSlot
   OWNS: DecrementFirstEnergyCell DrawEnergyGauge DrawFuelGauge DrawFuelGaugeOnPage */
#include "render.h"

#define RENDER_OFFSCREEN 0xFFFF
#define RENDER_16_CS_FIRST 0x00FA
#define RENDER_32_LEVEL_FIRST 0x001C

#ifdef OVERKILL_HOST
/* Host pointers address a flat arena, while the oracle wraps each DS field access
   through a 16-bit offset. Keep Record's volatile access and that wrap explicitly. */
#define RENDER_RECORD_FIELD(record, field) \
    (*GAME_PTR(volatile word, \
               (word)(GAME_OFFSET((Record *)(record)) + offsetof(Record, field))))
#else
#define RENDER_RECORD_FIELD(record, field) ((record)->field)
#endif

/* Array references in the oracle form a 16-bit effective address even when their
   selector is unchecked. Apply that offset arithmetic before resolving host DS. */
#define RENDER_STATE_WORD_AT(array, index) \
    (*GAME_PTR(word, (word)(GAME_OFFSET(array) + \
                            (word)((word)(index) * (word)sizeof(word)))))

#ifdef OVERKILL_HOST
#define RENDER_FLIP_EGA_DRAW_PAGE() \
    render_call_main(HOST_TOKEN_FLIPEGADRAWPAGE)
#else
#define RENDER_FLIP_EGA_DRAW_PAGE() \
    render_call_main((main_routine)FlipEgaDrawPage)
#endif

/* The oracle indexes its dispatch tables without bounds checks. This C path assumes
   the game's selector domain: VideoAdapter 0..2 and REC_SIZE_CLASS 0..2. */

word render_record_workspace_offset(volatile Record *record)
{
    word y = RENDER_RECORD_FIELD(record, y);
    word x;
    word row;
    word byte_x;
    word adapter = VideoAdapter;

    if (y >= 0x00E0) return RENDER_OFFSCREEN;
    row = RENDER_STATE_WORD_AT(RecordRowOffsets, y);
    if (row == RENDER_OFFSCREEN) return RENDER_OFFSCREEN;

    x = RENDER_RECORD_FIELD(record, x);
    if (adapter == VIDEO_CGA) {
        RENDER_RECORD_FIELD(record, pixel_phase) = (word)(x & 3);
        byte_x = (word)(x >> 2);
    } else if (adapter == VIDEO_EGA) {
        RENDER_RECORD_FIELD(record, pixel_phase) = (word)(x & 7);
        byte_x = (word)(x >> 3);
    } else {
        /* Tandy's single unshifted blitter phase is stored as zero on every visible
           offset calculation, even when the record used to carry another phase. */
        RENDER_RECORD_FIELD(record, pixel_phase) = 0;
        byte_x = (word)(x >> 1);
    }

    if (RENDER_RECORD_FIELD(record, flash_timer) != 0)
        RENDER_RECORD_FIELD(record, flash_timer) =
            (word)(RENDER_RECORD_FIELD(record, flash_timer) - 1);
    return (word)(row + byte_x);
}

void render_fill_copy_shape(RenderCopyRequest *request, word size_class,
                            word adapter, word workspace_offset, word save_offset,
                            word to_workspace)
{
    request->workspace_segment = WorkspaceSegment;
    request->state_segment = MainDataSegment;
    request->workspace_offset = workspace_offset;
    request->save_offset = save_offset;
    request->to_workspace = to_workspace;
    request->rows = size_class == 0 ? 8 : 16;
    request->planes = 1;

    if (adapter == VIDEO_CGA) {
        request->workspace_row_bytes = CGA_WORKSPACE_ROW_BYTES;
        if (size_class == 0) request->bytes_per_plane = 3;
        else if (size_class == 1) request->bytes_per_plane = 5;
        else request->bytes_per_plane = 9;
    } else if (adapter == VIDEO_EGA) {
        request->workspace_row_bytes = EGA_WORKSPACE_ROW_BYTES;
        request->planes = 4;
        if (size_class == 0) request->bytes_per_plane = 2;
        else if (size_class == 1) request->bytes_per_plane = 3;
        else request->bytes_per_plane = 5;
    } else {
        request->workspace_row_bytes = TANDY_WORKSPACE_ROW_BYTES;
        if (size_class == 0) request->bytes_per_plane = 4;
        else if (size_class == 1) request->bytes_per_plane = 8;
        else request->bytes_per_plane = 16;
    }
}

void render_copy_record_half(volatile Record *record, word workspace_offset,
                             word save_offset, word to_workspace)
{
    RenderCopyRequest request;
    render_fill_copy_shape(&request, RENDER_RECORD_FIELD(record, size_class), VideoAdapter,
                           workspace_offset, save_offset, to_workspace);
    render_platform_copy_rows(&request);
}

void render_save_record_background(volatile Record *record)
{
    word raw = render_record_workspace_offset(record);
    RENDER_RECORD_FIELD(record, work_ofs) = raw;
    if (raw == RENDER_OFFSCREEN) {
        if (RENDER_RECORD_FIELD(record, size_class) != 2) return;
    } else {
        word adjusted = (word)(raw + ScrollWindowOffset);
        RENDER_RECORD_FIELD(record, work_ofs) = adjusted;
        render_copy_record_half(record, adjusted,
                                RENDER_RECORD_FIELD(record, save_buffer), 0);
    }

    if (RENDER_RECORD_FIELD(record, size_class) == 2) {
        word original_y = RENDER_RECORD_FIELD(record, y);
        word lower;

        /* Both stores are intentional: RecordWorkspaceOffset reads the temporary Y
           from the same record and the oracle exposes the phase/timer effect per half. */
        RENDER_RECORD_FIELD(record, y) = (word)(original_y + 0x10);
        lower = render_record_workspace_offset(record);
        RENDER_RECORD_FIELD(record, work_ofs_lower) = lower;
        RENDER_RECORD_FIELD(record, y) = original_y;
        if (lower != RENDER_OFFSCREEN) {
            word adjusted_lower = (word)(lower + ScrollWindowOffset);
            RENDER_RECORD_FIELD(record, work_ofs_lower) = adjusted_lower;
            render_copy_record_half(record, adjusted_lower,
                                    (word)(RENDER_RECORD_FIELD(record, save_buffer) +
                                           SAVE_HALF_BYTES), 0);
        }
    }
}

void render_restore_record_background(volatile Record *record)
{
    if (RENDER_RECORD_FIELD(record, work_ofs) != RENDER_OFFSCREEN)
        render_copy_record_half(record, RENDER_RECORD_FIELD(record, work_ofs),
                                RENDER_RECORD_FIELD(record, save_buffer), 1);
    if (RENDER_RECORD_FIELD(record, size_class) == 2 &&
        RENDER_RECORD_FIELD(record, work_ofs_lower) != RENDER_OFFSCREEN)
        render_copy_record_half(record, RENDER_RECORD_FIELD(record, work_ofs_lower),
                                (word)(RENDER_RECORD_FIELD(record, save_buffer) +
                                       SAVE_HALF_BYTES), 1);
}

word render_draw_record_half(volatile Record *record, word source_segment,
                             word source_offset, word workspace_offset,
                             word size_class, word flash)
{
    RenderSpriteRequest request;
    word index = (word)(VideoAdapter * 8 + RENDER_RECORD_FIELD(record, pixel_phase));
    if (size_class == 0)
        request.blitter = Sprite8Blitters[index];
    else if (size_class == 1)
        request.blitter = flash != 0 ? FlashSprite16Blitters[index] :
                                       Sprite16Blitters[index];
    else
        request.blitter = flash != 0 ? FlashSprite32Blitters[index] :
                                       Sprite32Blitters[index];
    request.source_segment = source_segment;
    request.source_offset = source_offset;
    request.workspace_segment = WorkspaceSegment;
    request.workspace_offset = workspace_offset;
    request.rows = RENDER_RECORD_FIELD(record, size_class) == 0 ? 8 : 16;
    return render_platform_draw_sprite(&request);
}

word render_draw_record_sprite(volatile Record *record)
{
    word sprite = RENDER_RECORD_FIELD(record, sprite);
    word offset;
    word segment;
    word final_bp = GAME_OFFSET((Record *)record);

    if (RENDER_RECORD_FIELD(record, size_class) == 0) {
        if (RENDER_RECORD_FIELD(record, work_ofs) == RENDER_OFFSCREEN) return final_bp;
        offset = Sprite8Offsets[sprite];
        return render_draw_record_half(record, Sprites1x1Segment, offset,
                                       RENDER_RECORD_FIELD(record, work_ofs), 0, 0);
    }

    if (RENDER_RECORD_FIELD(record, size_class) == 1) {
        if (RENDER_RECORD_FIELD(record, work_ofs) == RENDER_OFFSCREEN) return final_bp;
        if (sprite >= RENDER_16_CS_FIRST) {
            sprite = (word)(sprite - RENDER_16_CS_FIRST);
            segment = Sprites2x2CSegment;
        } else {
            segment = Sprites2x2Segment;
        }
        offset = Sprite16Offsets[sprite];
        return render_draw_record_half(record, segment, offset,
                                       RENDER_RECORD_FIELD(record, work_ofs),
                                       1, RENDER_RECORD_FIELD(record, flash_timer) != 0);
    }

    /* Every 32x32 call updates these CS words before either visibility check.  The
       lower half reloads them after the upper call, matching the original code. */
    if (sprite >= RENDER_32_LEVEL_FIRST) {
        sprite = (word)(sprite - RENDER_32_LEVEL_FIRST);
        segment = LevelSpritesSegment;
    } else {
        segment = ManExplSegment;
    }
    offset = Sprite32Offsets[sprite];
    Sprite32HalfSource = offset;
    Sprite32HalfSegment = segment;

    if (RENDER_RECORD_FIELD(record, work_ofs) != RENDER_OFFSCREEN) {
        /* The upper-half call is wrapped in push/pop BP in the oracle. */
        render_draw_record_half(record, segment, offset,
                                RENDER_RECORD_FIELD(record, work_ofs),
                                2, RENDER_RECORD_FIELD(record, flash_timer) != 0);
        final_bp = GAME_OFFSET((Record *)record);
    }
    if (RENDER_RECORD_FIELD(record, work_ofs_lower) != RENDER_OFFSCREEN) {
        word lower_source = Sprite32HalfSource;
        word lower_segment = Sprite32HalfSegment;
        lower_source = (word)(lower_source + (Sprite32Bytes >> 1));
        final_bp = render_draw_record_half(record, lower_segment, lower_source,
                                           RENDER_RECORD_FIELD(record, work_ofs_lower),
                                           2, RENDER_RECORD_FIELD(record, flash_timer) != 0);
    }
    return final_bp;
}

word render_record_pointer_a(word index)
{
    return RENDER_STATE_WORD_AT(PoolAPointers, index);
}

word render_record_pointer_b(word index)
{
    return RENDER_STATE_WORD_AT(PoolBPointers, index);
}

word render_draw_records_to_workspace(void)
{
    sword i;
    word pass;
    volatile Record *record;

    for (i = POOL_A_POINTER_COUNT - 1; i >= 0; --i) {
        record = GAME_PTR(volatile Record, render_record_pointer_a((word)i));
        if (RENDER_RECORD_FIELD(record, status) != 0) render_save_record_background(record);
    }
    for (i = POOL_B_COUNT - 1; i >= 0; --i) {
        record = GAME_PTR(volatile Record, render_record_pointer_b((word)i));
        if (RENDER_RECORD_FIELD(record, status) != 0) render_save_record_background(record);
    }

    render_draw_stars();

    for (i = POOL_B_COUNT - 1; i >= 0; --i) {
        record = GAME_PTR(volatile Record, render_record_pointer_b((word)i));
        if (RENDER_RECORD_FIELD(record, status) != 0) render_draw_record_sprite(record);
    }

    for (pass = 0; pass != 2; ++pass) {
        sword first = pass == 0 ? (sword)(POOL_A_COUNT - 1) :
                                 (sword)(POOL_A_POINTER_COUNT - 1);
        for (i = first; i >= 0; --i) {
            record = GAME_PTR(volatile Record, render_record_pointer_a((word)i));
            if (RENDER_RECORD_FIELD(record, status) == 0) continue;
            if (DemoActive != 1 && MapScrollPos <= MAP_INTRO_END_POS &&
                RENDER_RECORD_FIELD(record, kind) == KIND_POD) continue;
            if (RENDER_RECORD_FIELD(record, draw_pass) != pass) continue;
            render_draw_record_sprite(record);
        }
    }

    if (LevelEndPhase == LEVEL_END_OFF)
        return render_record_pointer_a(0);
    if (AutoMoveExtraRecord == RENDER_OFFSCREEN)
        return RENDER_OFFSCREEN;
    return render_draw_record_sprite(GAME_PTR(volatile Record, AutoMoveExtraRecord));
}

word render_restore_record_backgrounds(void)
{
    sword i;
    volatile Record *record;

    for (i = POOL_B_COUNT - 1; i >= 0; --i) {
        record = GAME_PTR(volatile Record, render_record_pointer_b((word)i));
        if (RENDER_RECORD_FIELD(record, status) != 0) render_restore_record_background(record);
    }
    for (i = POOL_A_POINTER_COUNT - 1; i >= 0; --i) {
        record = GAME_PTR(volatile Record, render_record_pointer_a((word)i));
        if (RENDER_RECORD_FIELD(record, status) != 0) render_restore_record_background(record);
    }
    render_erase_stars();
    return render_record_pointer_a(0);
}

word render_screen_offset(byte row, byte column)
{
    word result = RENDER_STATE_WORD_AT(ScreenRowOffsets, row);
    word step = VideoAdapter == VIDEO_CGA ? 2 :
                (VideoAdapter == VIDEO_TANDY ? 4 : 1);
    return (word)(result + (word)column * step);
}

void render_draw_stars(void)
{
    word i;
    word count = 0;
    word adapter = VideoAdapter;
    RenderStarRequest request;

    request.workspace_segment = WorkspaceSegment;
    request.adapter = adapter;
    for (i = 0; i != 40; ++i) {
        word row_index = (word)(Stars[(word)(i * 3)] + 0x20);
        word row = RENDER_STATE_WORD_AT(RecordRowOffsets, row_index);
        word offset = (word)(row + ScrollWindowOffset + Stars[(word)(i * 3 + 1)]);

        request.workspace_offset = offset;
        request.mask = Stars[(word)(i * 3 + 2)];
        /* The original adapter branch falls through to the one-byte PlotStar label
           on CGA and Tandy even in the first 20-star group. Only EGA reaches the
           four-/three-plane plotting labels selected by the group sequence. */
        request.planes = adapter == VIDEO_EGA ? (i < 20 ? 4 : 3) : 1;
        if (render_platform_star_is_clear(&request) == 0) continue;
        render_platform_plot_star(&request);
        RENDER_STATE_WORD_AT(StarDrawnOffsets, count) = offset;
        ++count;
    }
    /* The terminator is written just after the last plotted star; older tail words
       remain stale exactly as in DrawStars. */
    RENDER_STATE_WORD_AT(StarDrawnOffsets, count) = RENDER_OFFSCREEN;
}

void render_erase_stars(void)
{
    word i;
    RenderStarRequest request;

    request.workspace_segment = WorkspaceSegment;
    request.adapter = VideoAdapter;
    for (i = 0; i != 40; ++i) {
        request.workspace_offset = RENDER_STATE_WORD_AT(StarDrawnOffsets, i);
        if (request.workspace_offset == RENDER_OFFSCREEN) break;
        render_platform_erase_star(&request);
    }
}

dword render_blit_panel_at(word image, word screen_offset);
#ifndef OVERKILL_HOST
#pragma aux render_blit_panel_at parm [si] [di] value [dx ax] modify exact [ax dx]
#endif

dword render_draw_upgrade_slot(volatile RenderUpgradeSlot *slot, word slot_number);
#ifndef OVERKILL_HOST
#pragma aux render_draw_upgrade_slot parm [si] [di] value [dx ax] modify exact [ax dx]
#endif

dword render_blit_panel_at(word image, word screen_offset)
{
    RenderPanelRequest request;
    request.image_offset = PanelImageOffsets[image];
    request.screen_offset = screen_offset;
    request.source_segment = PanelSegment;
    request.state_segment = MainDataSegment;
    return render_platform_blit_panel(&request);
}

dword render_draw_upgrade_slot(volatile RenderUpgradeSlot *slot, word slot_number)
{
    word selected = SelectedUpgradeSlot;
    word highlighted = 0;
    word icon;
    word unit = VideoAdapter == VIDEO_CGA ? 2 :
                (VideoAdapter == VIDEO_TANDY ? 4 : 1);
    word address = GAME_OFFSET((RenderUpgradeSlot *)slot);
    dword result;

    if (selected != RENDER_OFFSCREEN)
        highlighted = (word)(RENDER_STATE_WORD_AT(UpgradeSlotPtrs, selected) == address);

    if (DemoActive == 1 && slot_number == selected)
        icon = DemoUpgradeStatus;
    else
        icon = slot->icon;

    result = render_blit_panel_at((word)(slot->image + highlighted),
                                  (word)(slot->screen + 5 * unit));
    result = render_blit_panel_at((word)(PANEL_UPGRADE_FRAME + highlighted),
                                  (word)(slot->screen - unit));
    result = render_blit_panel_at(icon, slot->screen);
    return result;
}

dword render_draw_upgrade_slots(void)
{
    volatile RenderUpgradeSlot *slots =
        GAME_PTR(volatile RenderUpgradeSlot, GAME_OFFSET(UpgradeSlot0));
    word i;
    dword result = 0;

    for (i = 0; i != 4; ++i)
        result = render_draw_upgrade_slot(&slots[i], i);

    if (VideoAdapter == VIDEO_EGA) {
        RENDER_FLIP_EGA_DRAW_PAGE();
        for (i = 0; i != 4; ++i)
            result = render_draw_upgrade_slot(&slots[i], i);
        RENDER_FLIP_EGA_DRAW_PAGE();
    }
    return result;
}

void render_decrement_first_energy_cell(void)
{
    word i;
    for (i = 0; i != 6; ++i) {
        if (RENDER_STATE_WORD_AT(EnergyCells, i) != 0) {
            --RENDER_STATE_WORD_AT(EnergyCells, i);
            return;
        }
    }
}

dword render_draw_energy_gauge(void)
{
    word i;
    word remaining;
    word energy_tanks = EnergyTanks;
    word tank_image;
    dword result = 0;

    for (i = 0; i != 6; ++i) RENDER_STATE_WORD_AT(EnergyCells, i) = 4;
    remaining = EnergyPoints;
    if ((sword)remaining > 0) {
        while (remaining != 0) {
            render_decrement_first_energy_cell();
            --remaining;
        }
    }

    for (i = 0; i != 6; ++i)
        result = render_blit_panel_at((word)(PANEL_ENERGY_CELL +
                                              RENDER_STATE_WORD_AT(EnergyCells, i)),
                                      render_screen_offset(0x40, (byte)(0x1F + i)));

    if (energy_tanks == HudTankCompare) return result;

    tank_image = energy_tanks == RENDER_OFFSCREEN ? 0 : energy_tanks;
    result = render_blit_panel_at((word)(PANEL_TANK_GAUGE + tank_image),
                                  render_screen_offset(0x0C, 0x1F));
    result = render_blit_panel_at(PANEL_SHIP_ICON,
                                  render_screen_offset(0x18, 0x21));
    return result;
}

dword render_draw_fuel_gauge_page(void)
{
    RenderFuelRequest request;
    word fuel;

    request.screen_segment = ScreenSegment;
    request.screen_offset = render_screen_offset(0x5F, 0x1D);
    request.adapter = VideoAdapter;

    /* Fuel is read after FuelGaugeOffset is committed, as in the original page leaf. */
    FuelGaugeOffset = request.screen_offset;
    fuel = Fuel;
    request.full_bars = (word)(fuel >> 1);
    request.empty_bars = (word)(0x2C - request.full_bars);

    /* The original writes the same DS offset on each EGA page, before any pixels. */
    {
        dword final_es_di = render_platform_draw_fuel_bars(&request);
        if (fuel < 0x10 && RefuelActive != 1 && SfxEnabled != 0)
            SfxRequest = 0x0A;
        return final_es_di;
    }
}

dword render_draw_fuel_gauge(void)
{
    dword final_es_di = render_draw_fuel_gauge_page();
    if (VideoAdapter != VIDEO_EGA) return final_es_di;
    RENDER_FLIP_EGA_DRAW_PAGE();
    final_es_di = render_draw_fuel_gauge_page();
    RENDER_FLIP_EGA_DRAW_PAGE();
    return final_es_di;
}
