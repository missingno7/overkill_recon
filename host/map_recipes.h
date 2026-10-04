#ifndef OVERKILL_MAP_RECIPES_H
#define OVERKILL_MAP_RECIPES_H
#include "game.h"

enum MapSpawnInitializer {
    MAP_SPAWN_ENEMY = 0,
    MAP_SPAWN_LARGE_ENEMY = 1,
    MAP_SPAWN_NONE = 2
};

enum MapGroupPhase {
    MAP_GROUP_NONE = 0,
    MAP_GROUP_ALLOCATE_ONLY = 1,
    MAP_GROUP_JOIN_BEFORE_FIELDS = 2,
    MAP_GROUP_JOIN_AFTER_FIELDS = 3
};

enum MapRecipeFields {
    MAP_RECIPE_SPRITE = 1,
    MAP_RECIPE_DIRECTION = 2,
    MAP_RECIPE_FACE_CENTER = 4,
    MAP_RECIPE_LEFT_SPRITE = 8,
    MAP_RECIPE_OFFSET_X = 16,
    MAP_RECIPE_OFFSET_Y = 32,
    MAP_RECIPE_DIRECTION_FIRST = 64,
    MAP_RECIPE_OFFSET_FIRST = 128,
    MAP_RECIPE_SAVE_X = 256,
    MAP_RECIPE_PRESERVE_SLOT = 512,
    MAP_RECIPE_OUTWARD = 1024
};

enum MapSpawnRegion { MAP_REGION_ANY = 0, MAP_REGION_AT_OR_LEFT = 1, MAP_REGION_RIGHT = 2 };

typedef struct MapCellWrite {
    word displacement;
    byte tile;
} MapCellWrite;

typedef struct MapSpawnRecipe {
    byte tile;
    byte spawn;
    byte map_group;
    word enemy_type;
    word fields;
    word sprite;
    word direction;
    word left_sprite;
    word left_direction;
    word offset_x;
    word offset_y;
    byte spawn_region;
    word outward_distance;
    word outward_direction;
    word map_write_count;
    const MapCellWrite *map_writes;
} MapSpawnRecipe;

typedef struct MapRecipeLevel {
    const MapSpawnRecipe *recipes;
    word count;
    byte coverage[32];
} MapRecipeLevel;

/* Returns whether this cell belongs to the converted slice. The continuation
   offset remains explicit because later fuel recipes must retain its legacy result. */
int overkill_spawn_map_recipe(Record *here, word off, word level_cell, word *continuation);
#endif
