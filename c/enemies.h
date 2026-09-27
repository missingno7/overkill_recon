/* Enemy behaviour (c/enemies.c): the functions other C regions call directly (all in
   segment CGAME; c/game.h convention). */
#ifndef ENEMIES_H
#define ENEMIES_H
#include "game.h"

#define NO_RECORD ((Record *)0xFFFF)

word next_random_word(void);
Record *find_free_record_pool_b(void);
Record *spawn_aimed_shot(Record *r);
word spawn_throttled_child(Record *r, word bx);
word try_terrain_step(Record *r);
void scroll_record_then_finish(Record *r);
void finish_record_update(Record *r);

#endif
