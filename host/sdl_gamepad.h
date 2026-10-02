#ifndef OVERKILL_HOST_SDL_GAMEPAD_H
#define OVERKILL_HOST_SDL_GAMEPAD_H

#include <stdint.h>

/* Axis values are mapped into the original game-port count range. Button bits
   use the DOS active-low port-A layout. Returns zero when no mapped gamepad is
   connected, with zero axis counts and all buttons released in the outputs. */
int actual_sdl_gamepad_poll(uint16_t *x_count, uint16_t *y_count,
                            uint8_t *button_bits);

/* Close the selected controller and release SDL_INIT_GAMEPAD when this module
   initialized it. Polling also registers this cleanup for process exit. */
void actual_sdl_gamepad_close(void);

#endif
