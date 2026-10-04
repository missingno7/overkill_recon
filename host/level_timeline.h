#ifndef OVERKILL_LEVEL_TIMELINE_H
#define OVERKILL_LEVEL_TIMELINE_H
#include <stdint.h>
#include "level_def.h"

typedef struct LevelFormationMember {
    int16_t dx, dy;
} LevelFormationMember;

typedef struct LevelFormation {
    uint16_t size, layer, behavior, count;
    LevelFormationMember *members;
} LevelFormation;

typedef struct LevelTimelineEvent {
    uint16_t clock, x, y;
    uint8_t marker, drop;
    const LevelFormation *formation;
} LevelTimelineEvent;

typedef struct LevelFormationSpawnParameters {
    uint16_t tile_member_hit_points, other_member_hit_points;
} LevelFormationSpawnParameters;

typedef struct LevelTimelineCheckpoint {
    uint16_t map_position, script_clock, resume_event;
} LevelTimelineCheckpoint;

typedef struct LevelTimeline {
    uint16_t behavior_profile, event_count, formation_count, checkpoint_count;
    LevelTimelineEvent *events;
    LevelFormation *formations;
    LevelTimelineCheckpoint *checkpoints;
    LevelFormationSpawnParameters parameters;
    uint8_t live_parameters;
} LevelTimeline;

/* Immutable content is borrowed. Execution cursors remain in the existing DS. */
void overkill_level_timeline_bind_current(const LevelTimeline *timeline);
const LevelTimeline *overkill_level_timeline_current(void);
uint16_t overkill_level_timeline_cursor(const LevelTimeline *timeline);
void overkill_level_timeline_reset(void);
int overkill_level_timeline_select_checkpoint(LevelCheckpoint *selection);
int overkill_level_timeline_restore_checkpoint(void);
uint16_t overkill_formation_tile_hit_points(uint16_t legacy_index);
uint16_t overkill_formation_other_hit_points(uint16_t legacy_index);
uint16_t overkill_timeline_director_cursor(uint16_t legacy_cursor);
#endif
