#ifndef PATROL_H
#define PATROL_H
#include "game.h"

void wall_patrol(Record *r, word base);
void type32_descend_then_bounce(Record *r);
void type33_terrain_bouncer(Record *r);
void type3c_descend_then_bounce(Record *r);
void type3d_animated_bouncer(Record *r);
void type4b_descend_then_bounce(Record *r);
void type4e_animated_descender(Record *r);
void climbing_walker(Record *r, word type);
void type5b_scroll_then_rise(Record *r);
void type5c_rise_fast4(Record *r);
void type84_lurk_until_aligned(Record *r);

#endif
