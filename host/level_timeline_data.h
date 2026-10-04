#ifndef OVERKILL_LEVEL_TIMELINE_DATA_H
#define OVERKILL_LEVEL_TIMELINE_DATA_H
#include "level_timeline.h"
#include "content_json.h"

typedef struct LevelPresetName {
    const char *name;
    uint16_t value;
} LevelPresetName;

/* Strict semantic JSON conversion. The returned content owns its allocations. */
int overkill_level_timeline_parse(const JsonDocument *document, const JsonDocument *original,
                                  uint16_t profile, LevelTimeline **result,
                                  char *error, size_t error_size);
void overkill_level_timeline_free(LevelTimeline *timeline);
#endif
