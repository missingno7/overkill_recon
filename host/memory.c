#include "memory.h"
#include "game.h"
#include <stdlib.h>

#define DOS_MEMORY_BYTES 0x100000u
#define DOS_PHYSICAL_MASK 0xFFFFFu
#define DOS_SEGMENT_SHIFT 4u

static unsigned char *state_window;
static unsigned char *level_map_window;
static unsigned char *real_memory;

int overkill_bind_state(void *state, size_t bytes)
{
    const uint16_t endian = 1;
    if (state == NULL || bytes < 0x10000 ||
        (uintptr_t)state % _Alignof(uint16_t) != 0 ||
        *(const unsigned char *)&endian != 1)
        return 0;
    state_window = state;
    return 1;
}

void *overkill_ds_address(uint16_t offset)
{
    if (state_window == NULL) abort();
    return state_window + offset;
}

uint16_t overkill_ds_offset(const void *pointer)
{
    uintptr_t base = (uintptr_t)state_window;
    uintptr_t address = (uintptr_t)pointer;
    if (state_window == NULL || address < base || address - base > 0x10000)
        abort();
    /* One-past DS is permitted for end markers and wraps like a DOS offset. */
    return (uint16_t)(address - base);
}

int overkill_bind_real_memory(void *memory, size_t bytes)
{
    if (memory == NULL || bytes < DOS_MEMORY_BYTES) return 0;
    real_memory = memory;
    return 1;
}

void *overkill_segment_address(uint16_t segment, uint16_t offset)
{
    uint32_t physical = (((uint32_t)segment << DOS_SEGMENT_SHIFT) + offset) &
                        DOS_PHYSICAL_MASK;
    uint32_t state_offset = (physical - (uint32_t)HOST_DATA_LINEAR) &
                            DOS_PHYSICAL_MASK;

    /* DOS segment aliases share the borrowed DS window when one is installed. */
    if (state_offset < 0x10000u) {
        if (state_window == NULL) abort();
        return state_window + state_offset;
    }

    if (real_memory == NULL) abort();
    return real_memory + physical;
}

int overkill_bind_level_map(void *map, size_t bytes)
{
    if (map == NULL || bytes < 0x10000) return 0;
    level_map_window = map;
    return 1;
}

void *overkill_level_map_address(uint16_t offset)
{
    if (level_map_window == NULL) abort();
    return level_map_window + offset;
}
