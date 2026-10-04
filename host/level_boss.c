#include "level_boss.h"
#include "game.h"
#include "BOSSES_GEN.H"

void overkill_level_boss(uint16_t level_index, LevelBoss *boss)
{
    *boss = level_index < sizeof(level_bosses) / sizeof(level_bosses[0])
        ? level_bosses[level_index] : original_boss_data;
    if (!boss->offsets) boss->offsets = GAME_PTR(word, GAME_OFFSET(BossPartOffsets));
}
