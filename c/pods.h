/* Pods, upgrades, pickups and player hit tests (c/pods.c): the functions other C regions
   may call directly (all in segment CGAME; c/game.h convention). */
#ifndef PODS_H
#define PODS_H
#include "game.h"

void add_score_bcd(word points);
void remove_record(Record *r);
word remove_record_si(Record *r, word si);
Record *alloc_record_evicting(void);
void check_record_hits_player(Record *r);
word small_record_hits_player(Record *r);
void collect_pickup(Record *pickup);
void place_side_pods(Record *anchor);
word refresh_upgrade_display(void);
void demo_step_next_ship_form(void);
void demo_step_launch_inner_side_pods(void);
void demo_step_launch_outer_side_pods(void);
void demo_step_launch_trailing_pod_near(void);
void demo_step_launch_trailing_pod_far(void);

#endif
