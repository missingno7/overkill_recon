#ifndef OVERKILL_LEVEL_DEF_H
#define OVERKILL_LEVEL_DEF_H
#include <stdint.h>

/* Native binding of the resource slice of a level definition. These are DS
   filename-table slots, not cached filename values or host pointers. */
typedef struct LevelDef {
    uint16_t map;
    uint16_t sprites;
    uint16_t blocks;
    uint16_t plaque;
} LevelDef;

void overkill_level_def(uint16_t level_index, LevelDef *definition);
uint16_t overkill_level_resource_name(uint16_t binding);

#endif
