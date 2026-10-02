#include "memory.h"
#include <stdlib.h>

static unsigned char *state_window;

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
