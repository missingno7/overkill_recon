#ifndef OVERKILL_HOST_INPUT_SERVICES_H
#define OVERKILL_HOST_INPUT_SERVICES_H
#include <stdint.h>

/* Raw samples are a platform input, not a second copy of game state. */
void overkill_set_input_sample(uint16_t x, uint16_t y, uint8_t buttons);
unsigned overkill_input_flush_count(void);
#endif
