#include "level_def.h"
#include "game.h"
#include "level_timeline.h"

static const LevelTerrain *current_terrain;

void overkill_level_terrain_bind_current(const LevelTerrain *terrain)
{
    current_terrain = terrain;
}

const LevelTerrain *overkill_level_terrain_current(void)
{
    return current_terrain;
}

void overkill_level_def(uint16_t level_index, LevelDef *definition)
{
    /* Each original table has its own stride. Keep all word indices, including
       unreachable adjacent-table reads and aliases caused by 16-bit wrapping. */
    word pair_index = (word)(level_index << 1);
    word bank_index = (word)(level_index << 2);
    definition->map = (word)(GAME_OFFSET(LevelMapFiles) + pair_index);
    definition->sprites = (word)(GAME_OFFSET(LevelBankFiles) + bank_index);
    definition->blocks = (word)(definition->sprites + 2);
    definition->plaque = (word)(GAME_OFFSET(PlaqueFiles) + pair_index);
    definition->attribute_patches = (word)(GAME_OFFSET(AttributePatchPointers) + pair_index);
    definition->checkpoints = (word)(GAME_OFFSET(LevelCheckpointPtrs) + pair_index);
    definition->timeline_cursor = (word)(GAME_OFFSET(LevelScriptCursorPtrs) + pair_index);
}

uint16_t overkill_level_resource_name(uint16_t binding)
{
    /* Read at the coordinator's original use point: a decoder or retry service
       can change a later table entry. The definition owns no game state. */
    return *GAME_PTR(word, binding);
}

void overkill_initialize_tile_attributes(uint16_t patch_binding)
{
    word i, cursor;
    byte tile, attribute;

    if (current_terrain) {
        for (i = 0; i < BYTE_ATTRIBUTE_COUNT; i++)
            ByteAttributeTable[i] = current_terrain->attributes[i];
        return;
    }
    for (i = 0; i < BYTE_ATTRIBUTE_COUNT; i++) ByteAttributeTable[i] = TILE_WALL;
    /* Reset before reading the binding, and read each pair before its write.
       Live DS streams may alias the output or wrap past FFFFh. Do not snapshot
       or deduplicate them. The terminator is a tile byte with no value byte. */
    cursor = *GAME_PTR(word, patch_binding);
    for (;;) {
        tile = *GAME_PTR(byte, cursor);
        cursor = (word)(cursor + 1);
        if (tile == ATTRIBUTE_PATCH_END) break;
        attribute = *GAME_PTR(byte, cursor);
        cursor = (word)(cursor + 1);
        ByteAttributeTable[tile] = attribute;
    }
}

void overkill_select_checkpoint(uint16_t binding, LevelCheckpoint *selection)
{
    word cursor, n, threshold;

    if (overkill_level_timeline_select_checkpoint(selection)) return;
    cursor = *GAME_PTR(word, binding);
    for (n = 0; n < 4; n++) {
        selection->map_position = *GAME_PTR(word, cursor);
        cursor = (word)(cursor + 2);
        selection->script_clock = *GAME_PTR(word, cursor);
        cursor = (word)(cursor + 2);
        /* ReadCheckpoint writes every candidate cursor before its threshold
           read. Live tables may alias this state or MapScrollPos. */
        CheckpointScriptCursor = *GAME_PTR(word, cursor);
        cursor = (word)(cursor + 2);
        /* The fourth entry has no threshold word. The original reads into the
           neighboring table anyway; its result is ignored. Retain that read. */
        threshold = *(volatile word *)GAME_PTR(word, cursor);
        cursor = (word)(cursor + 2);
        if (n == 3 || MapScrollPos < threshold) break;
    }
}
