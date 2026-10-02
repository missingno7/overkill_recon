/* Waypoint followers and formation entry (c/paths.c), all in CGAME. */
#ifndef PATHS_H
#define PATHS_H
#include "game.h"

void start_path_follower(Record *r, word path);
void update_path_follower(Record *r);
void enter_sweeper_slot(Record *r);
void enter_march_slot(Record *r);

#endif
