/* Level, shared-graphics and page-load coordination over the oracle state.
   File/cache services and adapter decoders remain MAIN ASM interfaces.

   SEGMENT: CGAME
   OWNS: LoadLevelMap InitializeByteAttributes ReadAttributePatchIndex AttributePatchesDone
   OWNS: LoadGraphicsRecordImages LoadGraphicsPlain LoadGraphicsMasked
   OWNS: LoadGraphicsFile LoadCommonGraphics LoadLevelGraphics LoadAndShowPage
*/
#include "levels.h"
#include "cache.h"
#include "input_normalize.h"
#include "system.h"
#ifdef OVERKILL_HOST
#include "memory.h"
#include "platform_services.h"
#include "level_def.h"
#include "level_content.h"
#include "level_departure.h"
#endif

#ifndef OVERKILL_HOST
extern void ClearWorkspace(void);
extern void BlitPackedToScreen(void);

/* MAIN-resident words used to configure the retained graphics loader. */
extern word __far LevelMapSegment;
extern word __far WorkspaceSegment;
extern word __far LevelBlocksSegment;
extern word __far LevelSpritesSegment;
extern word __far Sprites1x1Segment;
extern word __far Sprites2x2Segment;
extern word __far Sprites2x2CSegment;
extern word __far ManExplSegment;
extern word __far TheEndSegment;
extern word __far PanelSegment;
extern word __far PlaqueSegment;
extern word __far BlueBitsSegment;
extern word __far ShipSegment;
extern volatile word __far VideoAdapter;
extern word __far LoadNamePtr;
extern word __far LoadDestOffset;
extern word __far LoadDestSegment;
extern word __far LoadImageSlot;
extern word __far LoadMakeMask;
extern word __far LoadRecordImages;
extern byte __far PerFileFlagsEnabled;
extern word __far ScreenImageOffset;
extern word __far PanelImageOffsets[];
extern word __far BlueBitsImageOffsets[];
extern word __far PlaqueImageOffset;
#endif

#ifdef OVERKILL_HOST
#define LEVELS_MAP_AT(off) \
    ((byte *)overkill_segment_address(LevelMapSegment, (word)(off)))
#define LEVELS_PANEL_AT(off) \
    ((byte *)overkill_segment_address(PanelSegment, (word)(off)))
#else
#define LEVELS_MAP_AT(off) \
    (((__segment)LevelMapSegment) :> ((byte __based(void) *)(off)))
#define LEVELS_PANEL_AT(off) \
    (((__segment)PanelSegment) :> ((byte __based(void) *)(off)))
#endif

/* These narrow assembly adapters set the decoder/blitter's register-only inputs,
   call the retained MAIN implementation, update BP/ES in DosRegisters, and return
   with DS restored to the game data segment. */
#ifndef OVERKILL_HOST
extern void LevelsDecodeGraphics(void);
extern void LevelsBlitPage(void);
void levels_decode_graphics(main_routine adapter, DosRegisters *registers, word flags);
#pragma aux levels_decode_graphics "FarCallMainNearViaAX" far parm [ax] [si] [di] \
    modify exact [ax bx cx dx si di es]
void levels_blit_page(main_routine adapter, DosRegisters *registers);
#pragma aux levels_blit_page "FarCallMainNearViaAX" far parm [ax] [si] \
    modify exact [ax bx cx dx si di es]
#else
void levels_decode_graphics(main_routine adapter, DosRegisters *registers,
                            word flags)
{
    HostRegisters state = { 0 };
    state.bp = flags;
    state.si = 0;
    state.di = LoadDestOffset;
    state.es = LoadDestSegment;
    overkill_platform_call(adapter, &state);
    registers->bp = state.bp;
    registers->es = state.es;
}

void levels_blit_page(main_routine adapter, DosRegisters *registers)
{
    HostRegisters state = { 0 };
    state.bp = registers->bp;
    state.es = registers->es;
    state.si = 0x8000;
    state.di = 0;
    overkill_platform_call(adapter, &state);
    registers->bp = state.bp;
    registers->es = state.es;
}
#endif

void initialize_level_byte_attributes(void)
{
    word i;
#ifdef OVERKILL_HOST
    LevelDef definition;
    LevelDeparture departure;

    overkill_level_def(LevelIndex, &definition);
    overkill_initialize_tile_attributes(definition.attribute_patches);
#else
    word patch_cursor;
    byte index, value;

    for (i = 0; i < BYTE_ATTRIBUTE_COUNT; i++) ByteAttributeTable[i] = 1;

    /* LevelIndex is an unchecked word index. Both the shift and address addition
       wrap at 16 bits, matching the original DS table access. */
    patch_cursor = *GAME_PTR(word, (word)(GAME_OFFSET(AttributePatchPointers) +
                                          (word)((word)LevelIndex << 1)));
    for (;;) {
        index = *GAME_PTR(byte, patch_cursor);
        patch_cursor = (word)(patch_cursor + 1);
        if (index == ATTRIBUTE_PATCH_END) break;
        value = *GAME_PTR(byte, patch_cursor);
        patch_cursor = (word)(patch_cursor + 1);
        ByteAttributeTable[index] = value;
    }
#endif

    for (i = 0; i < 2 * MAP_ROW_BYTES; i++) *LEVELS_MAP_AT(i) = 1;
#ifdef OVERKILL_HOST
    overkill_level_departure(LevelIndex, &departure);
    for (i = 0; i < 5 * MAP_ROW_BYTES; i++)
        *LEVELS_MAP_AT((word)(MAP_END_ROWS_POS + i)) = departure.terrain_rows[i];
#else
    for (i = 0; i < 5 * MAP_ROW_BYTES; i++)
        *LEVELS_MAP_AT((word)(MAP_END_ROWS_POS + i)) = LevelEndMapRows[i];
#endif
}

void load_level_map(DosRegisters *registers)
{
#ifdef OVERKILL_HOST
    LevelDef definition;
#else
    word map_file_offset;
#endif

    /* Every load restarts all six script streams, including streams for the other
       levels; this also runs during checkpoint restart. */
    LevelScriptCursors[0] = GAME_OFFSET(LevelScript0);
    LevelScriptCursors[1] = GAME_OFFSET(LevelScript1);
    LevelScriptCursors[2] = GAME_OFFSET(LevelScript2);
    LevelScriptCursors[3] = GAME_OFFSET(LevelScript3);
    LevelScriptCursors[4] = GAME_OFFSET(LevelScript4);
    LevelScriptCursors[5] = GAME_OFFSET(LevelScript5);

#ifdef OVERKILL_HOST
    overkill_level_def(LevelIndex, &definition);
    FileNamePtr = overkill_level_resource_name(definition.map);
#else
    map_file_offset = (word)(GAME_OFFSET(LevelMapFiles) +
                             (word)((word)LevelIndex << 1));
    FileNamePtr = *GAME_PTR(word, map_file_offset);
#endif
    FileBufferSegment = LevelMapSegment;
    FileBufferOffset = 0;
#ifdef OVERKILL_HOST
    if (overkill_level_content_copy_map()) {
        FileStatus = FILE_STATUS_OK;
    } else
#endif
    for (;;) {
        load_resource_file(registers);
        if (FileStatus == FILE_STATUS_OK) break;
        system_prompt_load_error_wait_fire(registers);
    }

    initialize_level_byte_attributes();
    /* The native clear API returns no register mailbox; the old service leaves ES=0. */
    clear_key_down_table();
    registers->es = 0;
}

void load_graphics_file(DosRegisters *registers)
{
    word name, flags, flag_word;

    dos_service(ClearWorkspace, registers);
    FileBufferSegment = WorkspaceSegment;
    FileBufferOffset = 0;
    name = LoadNamePtr;
    FileNamePtr = name;
    for (;;) {
        load_resource_file(registers);
        if (FileStatus == FILE_STATUS_OK) break;
        system_prompt_load_error_wait_fire(registers);
    }

    /* The per-file flag word immediately precedes the name. Only the exact value
       1 enables it; ordinary files pass FFFFh to the adapter decoder. */
    flags = 0xFFFF;
    if (PerFileFlagsEnabled == 1) {
        flag_word = (word)(name - 2);
        flags = *GAME_PTR(word, flag_word);
    }
#ifdef OVERKILL_HOST
    levels_decode_graphics(HOST_TOKEN_DECODEGRAPHICSIMAGES, registers, flags);
#else
    levels_decode_graphics((main_routine)LevelsDecodeGraphics, registers, flags);
#endif
}

/* The three public entry selectors only choose these two MAIN words before they
   enter the shared retry/decode path. ASM callers retain the recorded-image bridge. */
void load_graphics_record_images(DosRegisters *registers)
{
    LoadMakeMask = 0;
    LoadRecordImages = 1;
    load_graphics_file(registers);
}

void load_graphics_plain(DosRegisters *registers)
{
    LoadMakeMask = 0;
    LoadRecordImages = 0;
    load_graphics_file(registers);
}

void load_graphics_masked(DosRegisters *registers)
{
    LoadMakeMask = 1;
    LoadRecordImages = 0;
    load_graphics_file(registers);
}

void load_common_graphics(DosRegisters *registers)
{
    word i, patch_bytes;

    LoadNamePtr = GAME_OFFSET(File_1X1_BIC);
    LoadDestSegment = Sprites1x1Segment;
    load_graphics_masked(registers);

    LoadNamePtr = GAME_OFFSET(File_2X2_BIC);
    LoadDestSegment = Sprites2x2Segment;
    load_graphics_masked(registers);

    LoadNamePtr = GAME_OFFSET(File_2X2C_BIC);
    LoadDestSegment = Sprites2x2CSegment;
    load_graphics_masked(registers);

    LoadNamePtr = GAME_OFFSET(File_MANEXPL_BIC);
    LoadDestSegment = ManExplSegment;
    load_graphics_masked(registers);

    LoadNamePtr = GAME_OFFSET(File_THEND_BIC);
    LoadDestSegment = TheEndSegment;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_OFFSET_PANELIMAGEOFFSETS;
#else
    LoadImageSlot = (word)PanelImageOffsets;
#endif
    load_graphics_record_images(registers);

    LoadNamePtr = GAME_OFFSET(File_PANEL_ENC);
    LoadDestSegment = PanelSegment;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_OFFSET_PANELIMAGEOFFSETS;
#else
    LoadImageSlot = (word)PanelImageOffsets;
#endif
    LoadIsEnc = 1;
    load_graphics_record_images(registers);
    LoadIsEnc = 0;

    if (VideoAdapter == VIDEO_CGA) {
        patch_bytes = (word)(15 * PanelImageBytes[1]);
        for (i = 0; i < patch_bytes; i++) *LEVELS_PANEL_AT(i) = CgaPanelPatch[i];
    }

    LoadNamePtr = GAME_OFFSET(File_BLUEBITS_BIC);
    LoadDestSegment = BlueBitsSegment;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_OFFSET_BLUEBITSIMAGEOFFSETS;
#else
    LoadImageSlot = (word)BlueBitsImageOffsets;
#endif
    load_graphics_record_images(registers);

    LoadNamePtr = GAME_OFFSET(File_SHIP_BIC);
    LoadDestSegment = ShipSegment;
    load_graphics_plain(registers);
}

void load_level_graphics(DosRegisters *registers)
{
#ifdef OVERKILL_HOST
    LevelDef definition;
#else
    word bank_offset, plaque_offset;
#endif

    FileBufferSegment = LevelBlocksSegment;
    FileBufferOffset = 0;
#ifdef OVERKILL_HOST
    overkill_level_def(LevelIndex, &definition);
    PendingSpriteFile = overkill_level_resource_name(definition.sprites);
    FileNamePtr = overkill_level_resource_name(definition.blocks);
#else
    bank_offset = (word)(GAME_OFFSET(LevelBankFiles) +
                         (word)((word)LevelIndex << 2));
    PendingSpriteFile = *GAME_PTR(word, bank_offset);
    FileNamePtr = *GAME_PTR(word, (word)(bank_offset + 2));
#endif
    LoadNamePtr = FileNamePtr;
    LoadDestSegment = LevelBlocksSegment;
    load_graphics_plain(registers);

    LoadNamePtr = PendingSpriteFile;
    LoadDestSegment = LevelSpritesSegment;
    load_graphics_masked(registers);

#ifdef OVERKILL_HOST
    /* LevelIndex is read again here in the oracle, after both decodes. */
    overkill_level_def(LevelIndex, &definition);
    LoadNamePtr = overkill_level_resource_name(definition.plaque);
#else
    plaque_offset = (word)(GAME_OFFSET(PlaqueFiles) +
                           (word)((word)LevelIndex << 1));
    LoadNamePtr = *GAME_PTR(word, plaque_offset);
#endif
    LoadDestSegment = PlaqueSegment;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_OFFSET_PLAQUEIMAGEOFFSET;
#else
    LoadImageSlot = (word)&PlaqueImageOffset;
#endif
    LoadIsEnc = 1;
    load_graphics_record_images(registers);
    LoadIsEnc = 0;
    /* Preserve ClearKeyDownTable's physical ES=0 result in the live caller pair. */
    clear_key_down_table();
    registers->es = 0;
}

void load_and_show_page(DosRegisters *registers)
{
    word page_file_offset;

    page_file_offset = (word)(PageListPtr + (word)((word)PageIndex << 1));
    LoadNamePtr = *GAME_PTR(word, page_file_offset);
    LoadDestSegment = WorkspaceSegment;
    LoadDestOffset = 0x8000;
#ifdef OVERKILL_HOST
    LoadImageSlot = HOST_OFFSET_SCREENIMAGEOFFSET;
#else
    LoadImageSlot = (word)&ScreenImageOffset;
#endif
    LoadIsEnc = 1;
    load_graphics_record_images(registers);
    LoadIsEnc = 0;
    LoadDestOffset = 0;
#ifdef OVERKILL_HOST
    levels_blit_page(HOST_TOKEN_BLITPACKEDTOSCREEN, registers);
#else
    levels_blit_page((main_routine)LevelsBlitPage, registers);
#endif
}
