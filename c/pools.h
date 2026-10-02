/* Original DS-offset allocation cursors and random-word cycle (CGAME). */
#ifndef POOLS_H
#define POOLS_H
#include "game.h"

word next_random_word(void);
Record *find_free_record_pool_a(void);
Record *find_free_record_pool_b(void);

#endif
