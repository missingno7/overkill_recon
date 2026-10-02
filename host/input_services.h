#ifndef OVERKILL_HOST_INPUT_SERVICES_H
#define OVERKILL_HOST_INPUT_SERVICES_H
#include <stdint.h>

/* Raw samples are a platform input, not a second copy of game state. */
void overkill_set_input_sample(uint16_t x, uint16_t y, uint8_t buttons);
void overkill_clear_input_sample(void);
/* Shared by the gameplay wrappers and the native DOS-service dispatcher used
   by calibration. Button bits retain the active-low game-port-A layout. */
void overkill_input_read_sample(uint16_t *x, uint16_t *y, uint8_t *buttons);
unsigned overkill_input_flush_count(void);
#endif
