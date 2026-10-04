#include <stddef.h>
#include "map_recipes.h"
#include "memory.h"
#include "pools.h"
#include "combat.h"
#include "MAP_RECIPES_GEN.H"

Record *spawn_map_enemy_keep_cell(Record *here);
Record *find_free_record_pool_a(void);
void init_map_large_enemy_fields(Record *r, word reset_slot);
void start_map_cell_group(word off);
Record *join_map_group(Record *r);

static void offset_map_spawn(Record *r, const MapSpawnRecipe *recipe)
{
    if (recipe->fields & MAP_RECIPE_OFFSET_X) r->x += recipe->offset_x;
    if (recipe->fields & MAP_RECIPE_OFFSET_Y) r->y += recipe->offset_y;
}

static const MapSpawnParameters *live_spawn_parameters(void)
{
    /* Original comparisons outside the six identities mean offset 8 and no RNG.
       Invalid live identities can arise from historical DS aliases. */
    static const MapSpawnParameters fallback = {8, 0, 0, 0};
    word level = LevelIndex;
    return level < 6 ? &map_spawn_parameters[level] : &fallback;
}

int overkill_spawn_map_recipe(Record *here, word off, word level_cell, word *continuation)
{
    word level = level_cell >> 8;
    byte cell = (byte)level_cell;
    const MapRecipeLevel *definition;
    const MapSpawnRecipe *recipe;
    Record *r;
    word i, write_index, group_phase;

    if (level >= 6) return 0;
    definition = &map_recipe_levels[level];
    if ((definition->coverage[cell >> 3] & (1u << (cell & 7))) == 0) return 0;
    *continuation = off;
    for (i = 0; i < definition->count; i++) {
        recipe = &definition->recipes[i];
        if (recipe->tile != cell) continue;
        /* Runner side gates precede all mutations and allocation. In particular,
           an aliased map clear must not change the side which admitted the cell. */
        if (recipe->spawn_region == MAP_REGION_AT_OR_LEFT && MapCellX > PLAYFIELD_CENTER_X) return 1;
        if (recipe->spawn_region == MAP_REGION_RIGHT && MapCellX <= PLAYFIELD_CENTER_X) return 1;
        /* Original grouped ranges prepare a slot even for nonmember enemies,
           clear-only cells and holes. Drop lookup/allocation precedes map writes. */
        if (recipe->map_group != MAP_GROUP_NONE) start_map_cell_group(off);
        group_phase = recipe->map_group;
        if (recipe->fields & MAP_RECIPE_LIVE_JITTER_GROUP) {
            const MapSpawnParameters *parameters = live_spawn_parameters();
            /* Preparation may have changed the live level through an alias.
               Consume before clearing/allocation, including when the pool is full. */
            if (parameters->jitter_group_enabled &&
                (next_random_word() & parameters->jitter_group_mask) == parameters->jitter_group_equals)
                group_phase = MAP_GROUP_JOIN_BEFORE_FIELDS;
        }
        /* Map mutations precede record allocation even when the pool is full. Resolve
           each segment access anew and wrap the offset, like the original writes. */
        for (write_index = 0; write_index < recipe->map_write_count; write_index++) {
            const MapCellWrite *write = &recipe->map_writes[write_index];
            *(byte *)overkill_segment_address(LevelMapSegment,
                (word)(off + write->displacement)) = write->tile;
        }
        if (recipe->spawn == MAP_SPAWN_NONE) return 1;
        if (recipe->spawn == MAP_SPAWN_ENEMY || recipe->spawn == MAP_SPAWN_PICKUP) {
            r = spawn_map_enemy_keep_cell(here);
        } else {
            r = find_free_record_pool_a();
            if (r != NO_RECORD) init_map_large_enemy_fields(r, !(recipe->fields & MAP_RECIPE_PRESERVE_SLOT));
        }
        if (r != NO_RECORD) {
            if (recipe->spawn == MAP_SPAWN_PICKUP) {
                word sprite;
                DropKind = recipe->pickup_kind;
                sprite = init_pickup_record(r);
                if (recipe->fields & MAP_RECIPE_PICKUP_CURSOR) *continuation = sprite;
                return 1;
            }
            if (group_phase == MAP_GROUP_JOIN_BEFORE_FIELDS) join_map_group(r);
            if (recipe->fields & MAP_RECIPE_OFFSET_FIRST) offset_map_spawn(r, recipe);
            if (recipe->fields & MAP_RECIPE_SAVE_X) r->saved_x = r->x;
            if (recipe->fields & MAP_RECIPE_DIRECTION_FIRST) r->direction = recipe->direction;
            r->type = recipe->enemy_type;
            if (recipe->fields & MAP_RECIPE_SPRITE) r->sprite = recipe->sprite;
            if ((recipe->fields & MAP_RECIPE_DIRECTION) &&
                    !(recipe->fields & MAP_RECIPE_DIRECTION_FIRST)) r->direction = recipe->direction;
            if (recipe->fields & MAP_RECIPE_LIVE_CRAWLER_SPRITE) {
                word offset = live_spawn_parameters()->upward_crawler_sprite_offset;
                if (offset) r->sprite = recipe->sprite + offset;
            }
            /* Evaluate the live record after its default fields, not the map X
               cached before writes/allocation. Equality selects the left side. */
            if ((recipe->fields & MAP_RECIPE_FACE_CENTER) && r->x <= PLAYFIELD_CENTER_X) {
                if (recipe->fields & MAP_RECIPE_LEFT_SPRITE) r->sprite = recipe->left_sprite;
                r->direction = recipe->left_direction;
            }
            /* Ordinary late offsets retain the initializer's saved coordinates.
               Runner early offsets/copies already occurred above. Word wrap is intentional. */
            if (!(recipe->fields & MAP_RECIPE_OFFSET_FIRST)) offset_map_spawn(r, recipe);
            if (recipe->fields & MAP_RECIPE_OUTWARD) {
                r->x -= recipe->outward_distance;
                if (r->x >= PLAYFIELD_CENTER_X) {
                    r->direction = recipe->outward_direction;
                    r->x += (word)(recipe->outward_distance * 2);
                }
            }
            if (group_phase == MAP_GROUP_JOIN_AFTER_FIELDS) join_map_group(r);
        }
        return 1;
    }
    /* An explicitly removed recipe disables the covered cell. Unconverted
       cells return above and retain their existing handler during migration. */
    return 1;
}
