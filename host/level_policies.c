#include <stddef.h>
#include "game.h"
#include "level_policies.h"
#include "memory.h"
#include "LEVEL_POLICIES_GEN.H"

static const LevelCheckpointRestart *bound_restart[6];
static const uint8_t *bound_music[6];
static const LevelCheckpointRestart *current_restart;
static const uint8_t *current_music;

void overkill_level_policy_bind_current(const LevelCheckpointRestart *restart,
                                       const uint8_t *music)
{
    current_restart = restart;
    current_music = music;
}

void overkill_level_policy_bind(uint16_t index, const LevelCheckpointRestart *restart,
                               const uint8_t *music)
{
    if (index >= 6) return;
    bound_restart[index] = restart;
    bound_music[index] = music;
}

const LevelCheckpointRestart *overkill_level_checkpoint_restart(uint16_t index)
{
    if (current_restart) return current_restart;
    /* The canonical DS pointer index is shifted as a word; bit 15 aliases. */
    index &= 0x7fff;
    if (index >= 6) return NULL;
    return bound_restart[index] ? bound_restart[index] : level_restart_policies[index];
}

uint8_t overkill_level_music(uint16_t index)
{
    if (current_music) return *current_music;
    const uint8_t *music = index < 6 ?
        (bound_music[index] ? bound_music[index] : level_music_policies[index]) : NULL;
    return music ? *music : LevelMusicTable[(byte)index];
}

void overkill_restore_checkpoint_tiles(const LevelCheckpointRestart *restart)
{
    word off = MapScrollPos;
    word count = (word)(restart->lookback_rows * MAP_ROW_BYTES);
    while (count--) {
        word i;
        off--;
        for (i = 0; i < restart->rule_count; i++) {
            if (*(byte *)overkill_level_map_address(off) == restart->rules[i].tile) {
                *(byte *)overkill_level_map_address(off) = restart->rules[i].replacement;
                break;
            }
        }
    }
}
