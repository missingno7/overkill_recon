#ifndef OVERKILL_LEVEL_WAYPOINTS_H
#define OVERKILL_LEVEL_WAYPOINTS_H

#include <stdint.h>
#include "content_json.h"

typedef struct LevelWaypoint {
    uint16_t y, x;
    uint8_t terminal;
} LevelWaypoint;

typedef struct LevelWaypointPreset {
    const char *name;
    uint16_t legacy_start, count;
    const LevelWaypoint *points;
} LevelWaypointPreset;

typedef struct LevelWaypoints {
    uint16_t point_count;
    uint16_t starts[10];
    LevelWaypoint *points;
} LevelWaypoints;

void overkill_level_waypoints_bind_current(const LevelWaypoints *waypoints);
const LevelWaypoints *overkill_level_waypoints_current(void);
uint16_t overkill_waypoint_start(uint16_t legacy_start);
const LevelWaypoint *overkill_waypoint_current_point(uint16_t ordinal);

int overkill_level_waypoints_parse(const JsonDocument *document,
                                   const JsonDocument *original,
                                   LevelWaypoints **result,
                                   char *error, size_t error_size);
void overkill_level_waypoints_free(LevelWaypoints *waypoints);

#endif
