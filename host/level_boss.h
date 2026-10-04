#ifndef OVERKILL_LEVEL_BOSS_H
#define OVERKILL_LEVEL_BOSS_H
#include <stdint.h>

enum BossRole { BOSS_ANCHOR, BOSS_UPPER_RIGHT, BOSS_CORE, BOSS_LOWER_RIGHT };
typedef struct BossMember {
    uint16_t sprite, spawn_x, spawn_y;
} BossMember;
typedef struct LevelBoss {
    uint16_t hit_points;
    BossMember parts[4];
    const uint16_t *offsets; /* Four {dy, dx} pairs; canonical content remains live DS. */
} LevelBoss;

void overkill_level_boss(uint16_t level_index, LevelBoss *boss);
#endif
