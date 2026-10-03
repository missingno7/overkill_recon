#include "level_def.h"
#include "game.h"

void overkill_level_def(uint16_t level_index, LevelDef *definition)
{
    /* Each original table has its own stride. Keep all word indices, including
       unreachable adjacent-table reads and aliases caused by 16-bit wrapping. */
    word pair_index = (word)(level_index << 1);
    word bank_index = (word)(level_index << 2);
    definition->map = (word)(GAME_OFFSET(LevelMapFiles) + pair_index);
    definition->sprites = (word)(GAME_OFFSET(LevelBankFiles) + bank_index);
    definition->blocks = (word)(definition->sprites + 2);
    definition->plaque = (word)(GAME_OFFSET(PlaqueFiles) + pair_index);
}

uint16_t overkill_level_resource_name(uint16_t binding)
{
    /* Read at the coordinator's original use point: a decoder or retry service
       can change a later table entry. The definition owns no game state. */
    return *GAME_PTR(word, binding);
}
