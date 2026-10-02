/* Shared level-map grid probes and terrain movement. */
#ifndef TERRAIN_H
#define TERRAIN_H
#include "game.h"

word map_attribute(word cell);
word grid_offset_at(word x, word y);
word compute_record_grid_offset(Record *r);
word probe_ship_terrain_collision(Record *ship);
word probe_overlaps_walker(Record *r);
word terrain_step_down(Record *r, word cell);
word terrain_step_up(Record *r, word cell);
word terrain_step_right(Record *r, word cell);
word terrain_step_left(Record *r, word cell);
void terrain_step_in_direction(Record *r);
word climb_walker_step(Record *w);
word try_terrain_step(Record *r);

#ifdef OVERKILL_HOST
void *overkill_level_map_address(word cell);
#endif

#endif
