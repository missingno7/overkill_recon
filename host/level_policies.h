#ifndef OVERKILL_LEVEL_POLICIES_H
#define OVERKILL_LEVEL_POLICIES_H
#include <stdint.h>

typedef struct LevelTileRestoration {
    uint8_t tile, replacement;
} LevelTileRestoration;

typedef struct LevelCheckpointRestart {
    uint16_t lookback_rows, rule_count;
    const LevelTileRestoration *rules;
} LevelCheckpointRestart;

const LevelCheckpointRestart *overkill_level_checkpoint_restart(uint16_t index);
uint8_t overkill_level_music(uint16_t index);
/* Borrowed immutable content. NULL restores the generated/default binding. */
void overkill_level_policy_bind(uint16_t index, const LevelCheckpointRestart *restart,
                               const uint8_t *music);
/* Owned policies follow current content, independent of the compatibility index. */
void overkill_level_policy_bind_current(const LevelCheckpointRestart *restart,
                                       const uint8_t *music);
void overkill_restore_checkpoint_tiles(const LevelCheckpointRestart *restart);
#endif
