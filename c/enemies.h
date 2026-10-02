/* Enemy behaviour (c/enemies.c): the functions other C regions call directly (all in
   segment CGAME; c/game.h convention). */
#ifndef ENEMIES_H
#define ENEMIES_H
#include "game.h"
#include "terrain.h"
#include "pools.h"

Record *spawn_aimed_shot(Record *r);
word spawn_throttled_child(Record *r, word bx);
word spawn_shot_down(Record *r, word bx);
void horizontal_terrain_patrol(Record *r);
void set_plunge_target_below_player(Record *r);
void scroll_record_then_finish(Record *r);
void finish_record_update(Record *r);
void run_type_handler(Record *r);
void update_pickup(Record *r);

#endif
