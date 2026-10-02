/* Shared damage, destruction, enemy bursts, rewards and player collision policy (CGAME). */
#ifndef COMBAT_H
#define COMBAT_H
#include "game.h"

word init_pickup_record(Record *pickup);
void spawn_item_drop(void);
void clamp_record_x(Record *r);
void explode_record(Record *r);
void release_encounter_member(Record *r);
void destroy_record(Record *r);
void flash_hit_record(Record *r);
void damage_one(Record *r);
void damage_two(Record *r);
void destroy_unless_seg_boss(Record *r);
void smart_bomb_record(Record *r);
void set_sway_sprite(Record *r);
void spawn_eight_way_burst(Record *r);
void descend_burst_tail(Record *r);
void type36_fall_then_burst(Record *r);
void type22_descend_then_burst(Record *r);
word pods_add_bcd_byte(word a, word b, word carry);
void add_score_bcd(word points);
word record_near_player_hit_point(Record *r);
word small_record_hits_player(Record *r);
word large_record_hits_player(Record *r);

#endif
