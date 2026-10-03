#ifndef OVERKILL_LEVEL_DEPARTURE_H
#define OVERKILL_LEVEL_DEPARTURE_H
#include <stdint.h>

/* Read-only level content references. Mutable records, phases and map stay in DS.
   Parts are four triples {Y, X, sprite}; waypoints are {Y, X}. */
typedef struct LevelDeparture {
    const uint8_t *terrain_rows;
    const uint16_t *animated_parts;
    const uint16_t *approach;
    const uint16_t *dock;
} LevelDeparture;

void overkill_level_departure(uint16_t level_index, LevelDeparture *departure);
#endif
