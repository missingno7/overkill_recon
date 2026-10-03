#include "level_departure.h"
#include "game.h"
#include "DEPARTURES_GEN.H"

void overkill_level_departure(uint16_t level_index, LevelDeparture *departure)
{
    /* Default components preserve live table reads, including physical aliases.
       Authored components have independent immutable storage. No runtime table
       is patched when selecting a level or restarting a life. */
    departure->terrain_rows = GAME_PTR(byte, GAME_OFFSET(LevelEndMapRows));
    departure->animated_parts = GAME_PTR(word, GAME_OFFSET(Type53SpawnTable));
    departure->approach = GAME_PTR(word, GAME_OFFSET(AutopilotWaypointA));
    departure->dock = GAME_PTR(word, GAME_OFFSET(AutopilotWaypointB));
    if (level_index < sizeof(departure_overrides) / sizeof(departure_overrides[0])) {
        const LevelDeparture *overrides = &departure_overrides[level_index];
        if (overrides->terrain_rows) departure->terrain_rows = overrides->terrain_rows;
        if (overrides->animated_parts) departure->animated_parts = overrides->animated_parts;
        if (overrides->approach) departure->approach = overrides->approach;
        if (overrides->dock) departure->dock = overrides->dock;
    }
}
