#include "level_encounter.h"
#include "ENCOUNTERS_GEN.H"

void overkill_level_encounter(uint16_t level_index, LevelEncounter *encounter)
{
    if (level_index < sizeof(level_encounters) / sizeof(level_encounters[0])) {
        *encounter = level_encounters[level_index];
    } else {
        /* Original unchecked word identities outside the six authored slots
           choose the ordinary director/faller rules, with word-wrapped HP.
           This is a migration boundary, not an episode-position calculation. */
        const LevelEncounter fallback = {ENCOUNTER_FALLERS_THEN_BURSTER, 0,
            200, 240, (uint16_t)((level_index + 1) * 10), 113, 96, 50, 90, 0, 0, 0, FALLER_ANIMATED};
        *encounter = fallback;
    }
}
