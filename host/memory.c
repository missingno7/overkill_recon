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
