#include <stddef.h>
#include "map_recipes.h"
#include "memory.h"
#include "MAP_RECIPES_GEN.H"

Record *spawn_map_enemy_keep_cell(Record *here);
Record *find_free_record_pool_a(void);
void init_map_large_enemy(Record *r);

int overkill_spawn_map_recipe(Record *here, word off, word level_cell, word *continuation)
{
    word level = level_cell >> 8;
    byte cell = (byte)level_cell;
    const MapRecipeLevel *definition;
    const MapSpawnRecipe *recipe;
    Record *r;
    word i, write_index;

    if (level >= 6) return 0;
    definition = &map_recipe_levels[level];
    if ((definition->coverage[cell >> 3] & (1u << (cell & 7))) == 0) return 0;
    *continuation = off;
    for (i = 0; i < definition->count; i++) {
        recipe = &definition->recipes[i];
        if (recipe->tile != cell) continue;
        /* Map mutations precede allocation even when the pool is full. Resolve
           each segment access anew and wrap the offset, like the original writes. */
        for (write_index = 0; write_index < recipe->map_write_count; write_index++) {
            const MapCellWrite *write = &recipe->map_writes[write_index];
            *(byte *)overkill_segment_address(LevelMapSegment,
                (word)(off + write->displacement)) = write->tile;
        }
        if (recipe->spawn == MAP_SPAWN_ENEMY) {
            r = spawn_map_enemy_keep_cell(here);
        } else {
            r = find_free_record_pool_a();
            if (r != NO_RECORD) init_map_large_enemy(r);
        }
        if (r != NO_RECORD) {
            r->type = recipe->enemy_type;
            if (recipe->fields & MAP_RECIPE_SPRITE) r->sprite = recipe->sprite;
            if (recipe->fields & MAP_RECIPE_DIRECTION) r->direction = recipe->direction;
        }
        return 1;
    }
    /* An explicitly removed recipe disables the covered cell. Unconverted
       cells return above and retain their existing handler during migration. */
    return 1;
}
