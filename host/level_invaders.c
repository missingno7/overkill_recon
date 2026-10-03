#include "level_invaders.h"
#include "game.h"
#include "INVADERS_GEN.H"

void overkill_level_invaders(uint16_t level_index, LevelInvaders *invaders)
{
    /* Extra word identities keep the original disabled march and shared slots.
       Direct calls of the fire helper still use the original delay tiers. */
    if (level_index < sizeof(level_invaders) / sizeof(level_invaders[0])) {
        *invaders = level_invaders[level_index];
    } else {
        const LevelInvaders fallback = {0, 0,
            original_step_delays, sizeof(original_step_delays) / sizeof(original_step_delays[0]),
            original_fire_delays, sizeof(original_fire_delays) / sizeof(original_fire_delays[0])};
        *invaders = fallback;
    }
}

static uint8_t slot_byte(const uint16_t *overrides, uint32_t cursor)
{
    uint16_t relative = (uint16_t)(cursor - GAME_OFFSET(InvaderFormation));
    if (overrides && cursor < 0x10000 && relative < 24 * 4)
        return (uint8_t)(overrides[relative >> 1] >> ((relative & 1) * 8));
    if (cursor < 0x10000) return *GAME_PTR(byte, cursor);
    /* A word beginning at FFFFh straddles DS into the next physical byte;
       only the next LODSW's offset wraps. A borrowed DS window need not be
       adjacent to that arena byte, so resolve the latter through the arena. */
    return *(byte *)overkill_segment_address((uint16_t)((HOST_DATA_LINEAR + 0x10000) >> 4), 0);
}

uint16_t overkill_invader_slot_word(const uint16_t *overrides, uint16_t cursor)
{
    /* Read at use time, including odd cursors, offset wrapping and the seam into
       neighboring live DS bytes. Never snapshot both coordinates before writes. */
    if (!overrides && cursor != 0xFFFF) return *GAME_PTR(word, cursor);
    return slot_byte(overrides, cursor) | (uint16_t)(slot_byte(overrides, (uint32_t)cursor + 1) << 8);
}

uint8_t overkill_march_delay(const MarchDelayTier *tiers, uint16_t count, uint16_t members)
{
    uint16_t index;
    for (index = 0; index < count; index++)
        if (members >= tiers[index].minimum_members) return tiers[index].frames;
    return 0; /* Validated tiers always have a final zero-member entry. */
}
