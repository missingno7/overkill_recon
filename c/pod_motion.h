/* Shared pod placement, terrain damage, ship balance and demo motion (CGAME). */
#ifndef POD_MOTION_H
#define POD_MOTION_H
#include "game.h"

void init_pod_record(Record *pod);
void place_record_from_offset_pair(Record *pod, word *table, Record *anchor);
void place_side_pods(Record *anchor);
void dec_record_x_unless_zero(Record *r);
void inc_record_x_below_max(Record *r);
void dec_record_x_twice(Record *r);
void inc_record_x_twice(Record *r);
void adjust_record_x_from_counts(Record *ship);
word pod_take_hit(Record *pod);
word pod_terrain_hit(Record *pod);
void store_record_saved_position(Record *r);
void demo_step_next_ship_form(void);
void demo_launch_pod(Record *pod);
void demo_launch_trailing_pod(Record *pod);

#endif
