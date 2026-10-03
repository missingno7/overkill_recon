#ifndef OVERKILL_LEVEL_ENCOUNTER_H
#define OVERKILL_LEVEL_ENCOUNTER_H
#include <stdint.h>

enum EncounterKind {
    ENCOUNTER_SEGMENTED_BOSS, ENCOUNTER_INVADER_FORMATION,
    ENCOUNTER_LEADER_PATH, ENCOUNTER_FALLERS_THEN_BURSTER
};
enum FallerMotion { FALLER_ANIMATED, FALLER_ALTERNATE_ANIMATED, FALLER_AIMED_DRIFT };

typedef struct LevelEncounter {
    uint16_t kind, director_destructible;
    uint16_t burster_fallers_until_tick, burster_at_tick, burster_hit_points;
    uint16_t burster_sprite, burster_x;
    uint16_t invader_fallers_until_tick, invaders_at_tick;
    uint16_t faller_hp_override, faller_hit_points, faller_variant_tick, faller_motion;
} LevelEncounter;

void overkill_level_encounter(uint16_t level_index, LevelEncounter *encounter);
#endif
