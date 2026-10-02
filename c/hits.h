/* Player-shot hits and bursts (c/hits.c), with shared damage in c/combat.c.
   All use the CGAME calling convention in c/game.h. */
#ifndef HITS_H
#define HITS_H
#include "game.h"
#include "combat.h"

void player_shots_hit_record(Record *r);
void spawn_eight_way_burst(Record *r);

#endif
