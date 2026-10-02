#ifndef OVERKILL_HOST_MEMORY_H
#define OVERKILL_HOST_MEMORY_H
#include <stddef.h>
#include <stdint.h>

/* The platform supplies one aligned DS window; generated labels are views into it. */
int overkill_bind_state(void *state, size_t bytes);
void *overkill_ds_address(uint16_t offset);
uint16_t overkill_ds_offset(const void *pointer);

/* The platform supplies the guest's complete 20-bit physical memory arena. */
int overkill_bind_real_memory(void *memory, size_t bytes);
void *overkill_segment_address(uint16_t segment, uint16_t offset);

/* The level loader owns the map bytes; game code accesses the borrowed window. */
int overkill_bind_level_map(void *map, size_t bytes);
void *overkill_level_map_address(uint16_t offset);
#endif
