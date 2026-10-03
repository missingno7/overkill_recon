#ifndef OVERKILL_MAP_RECIPES_H
#define OVERKILL_MAP_RECIPES_H
#include "game.h"

enum MapSpawnInitializer {
    MAP_SPAWN_ENEMY = 0,
    MAP_SPAWN_LARGE_ENEMY = 1
};

enum MapRecipeFields {
    MAP_RECIPE_SPRITE = 1,
    MAP_RECIPE_DIRECTION = 2
};

typedef struct MapCellWrite {
    word displacement;
    byte tile;
} MapCellWrite;

typedef struct MapSpawnRecipe {
    byte tile;
    byte spawn;
    word enemy_type;
    byte fields;
    word sprite;
    word direction;
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
