#ifndef OVERKILL_LEVEL_SPECIAL_PATHS_H
#define OVERKILL_LEVEL_SPECIAL_PATHS_H

#include <stdint.h>
#include "content_json.h"

enum LevelPathControl {
    LEVEL_PATH_POINT = 0,
    LEVEL_PATH_LINK = 1,
    LEVEL_PATH_INVALID = 2
};

/* Fixed reader topology: lead-in -> sweep loop, or self-restarting routes.
   `next` is compiled content; cursors remain in the original record/DS/CS words. */
typedef struct LevelSpecialPoint {
    uint16_t y, x, next;
    uint8_t control;
} LevelSpecialPoint;

typedef struct LevelSpecialPreset {
    const char *name;
    uint16_t legacy_start, count;
    uint8_t ending, target;
    const LevelSpecialPoint *points;
} LevelSpecialPreset;

typedef struct LevelSpecialPaths {
    uint16_t point_count, starts[4];
    LevelSpecialPoint *points;
} LevelSpecialPaths;

void overkill_level_special_paths_bind_current(const LevelSpecialPaths *paths);
const LevelSpecialPaths *overkill_level_special_paths_current(void);
uint16_t overkill_special_path_start(uint16_t legacy_start);
const LevelSpecialPoint *overkill_special_path_point(uint16_t ordinal);

int overkill_level_special_paths_parse(const JsonDocument *document,
                                       const JsonDocument *original,
                                       LevelSpecialPaths **result,
                                       char *error, size_t error_size);
void overkill_level_special_paths_free(LevelSpecialPaths *paths);

#endif
