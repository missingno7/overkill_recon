#ifndef OVERKILL_LEVEL_INVADERS_H
#define OVERKILL_LEVEL_INVADERS_H
#include <stdint.h>

typedef struct MarchDelayTier {
    uint16_t minimum_members;
    uint8_t frames;
} MarchDelayTier;

typedef struct LevelInvaders {
    const uint16_t *slot_overrides;
    uint16_t march_enabled;
    const MarchDelayTier *step_delays;
    uint16_t step_delay_count;
    const MarchDelayTier *fire_delays;
    uint16_t fire_delay_count;
} LevelInvaders;

void overkill_level_invaders(uint16_t level_index, LevelInvaders *invaders);
uint16_t overkill_invader_slot_word(const uint16_t *overrides, uint16_t cursor);
uint8_t overkill_march_delay(const MarchDelayTier *tiers, uint16_t count, uint16_t members);
#endif
