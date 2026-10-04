#ifndef OVERKILL_LEVEL_LEADERS_H
#define OVERKILL_LEVEL_LEADERS_H

#include <stdint.h>
#include "content_json.h"

typedef struct LevelLeaderStep {
    uint16_t y, x, follower_y, follower_x;
    uint8_t spawn_follower, terminal;
} LevelLeaderStep;

typedef struct LevelLeaderSlot {
    uint16_t y, x;
} LevelLeaderSlot;

typedef struct LevelLeaderPreset {
    const char *name;
    uint16_t legacy_start, legacy_end, count;
    const LevelLeaderStep *steps;
} LevelLeaderPreset;

typedef struct LevelLeaderPaths {
    uint16_t step_count, starts[6], ends[6], slot_count;
    LevelLeaderStep *steps;
    LevelLeaderSlot *slots;
} LevelLeaderPaths;

/* A NULL provider preserves live DS pointers. Owned content uses ordinals in
   the same two shared game-state cursor words; this object owns no play state. */
void overkill_level_leaders_bind_current(const LevelLeaderPaths *leaders);
const LevelLeaderPaths *overkill_level_leaders_current(void);
uint16_t overkill_leader_start(uint16_t legacy_start);
uint16_t overkill_leader_end(uint16_t legacy_end);
const LevelLeaderStep *overkill_leader_current_step(uint16_t ordinal);
/* Authored slots form a cycle for both five-child spawning and later hopping.
   Canonical callers retain the original distinct unchecked/wrapping rules. */
const LevelLeaderSlot *overkill_leader_slot(uint16_t ordinal);
uint16_t overkill_leader_slot_start(void);
uint16_t overkill_leader_slot_next(uint16_t cursor);
uint16_t overkill_leader_slot_limit(void);

int overkill_level_leaders_parse(const JsonDocument *document,
                                 const JsonDocument *original,
                                 LevelLeaderPaths **result,
                                 char *error, size_t error_size);
void overkill_level_leaders_free(LevelLeaderPaths *leaders);

#endif
