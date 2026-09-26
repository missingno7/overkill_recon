/* Player-shot hits, damage and destruction (c/hits.c): the functions other C regions may
   call directly (all in segment CGAME; c/game.h convention). */
#ifndef HITS_H
#define HITS_H
#include "game.h"

void player_shots_hit_record(Record *r);
void smart_bomb_record(Record *r);
void destroy_record(Record *r);
void release_encounter_member(Record *r);
void clamp_record_x(Record *r);
void spawn_item_drop(void);
word init_pickup_record(Record *pickup);
void spawn_eight_way_burst(Record *r);

#endif
