/* Player-shot hits (c/hits.c), with shared damage and bursts in c/combat.c.
   All use the CGAME calling convention in c/game.h. */
#ifndef HITS_H
#define HITS_H
#include "game.h"
#include "combat.h"

void player_shots_hit_record(Record *r);

#endif
