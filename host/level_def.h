#ifndef OVERKILL_LEVEL_DEF_H
#define OVERKILL_LEVEL_DEF_H
#include <stdint.h>

/* Native bindings of a level definition. These are DS pointer-table slots,
   not cached values or host pointers. */
typedef struct LevelDef {
    uint16_t map;
    uint16_t sprites;
    uint16_t blocks;
    uint16_t plaque;
    uint16_t attribute_patches;
    uint16_t checkpoints;
} LevelDef;

typedef struct LevelCheckpoint {
    uint16_t map_position;
    uint16_t script_clock;
} LevelCheckpoint;

enum TileAttribute {
    TILE_OPEN = 0,
    TILE_WALL = 1,
    TILE_SHOT_PERMEABLE_WALL = 2
};

void overkill_level_def(uint16_t level_index, LevelDef *definition);
uint16_t overkill_level_resource_name(uint16_t binding);
void overkill_initialize_tile_attributes(uint16_t patch_binding);
void overkill_select_checkpoint(uint16_t binding, LevelCheckpoint *selection);

#endif
