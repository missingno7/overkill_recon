#ifndef OVERKILL_HOST_MEMORY_H
#define OVERKILL_HOST_MEMORY_H
#include <stddef.h>
#include <stdint.h>

/* The platform supplies one aligned DS window; generated labels are views into it. */
int overkill_bind_state(void *state, size_t bytes);
void *overkill_ds_address(uint16_t offset);
#endif
