#ifndef PLAYER_H
#define PLAYER_H
#include "game.h"
#include "input_normalize.h"

void init_position_history(void);
void store_apply_history_and_placement(Record *r);
word update_player_frame(word bp);
void pickup_fuel(void);
void place_at_player_offset(Record *r, word *table);
void update_exhaust(Record *r);

#endif
