#ifndef OVERKILL_SDL_INPUT_H
#define OVERKILL_SDL_INPUT_H

#include <SDL3/SDL.h>

/* Apply one SDL event to the DOS-compatible keyboard state. Returns nonzero
   for SDL quit or the DOS Alt+X exit chord. This module does not initialize
   SDL or create a window. */
int overkill_sdl_apply_event(const SDL_Event *event);

/* Drain queued SDL events in order; stop as soon as an exit request is seen. */
int overkill_sdl_pump_input(void);
void overkill_sdl_character_mode(int enabled);
int overkill_sdl_read_character(void);
void overkill_sdl_flush_characters(void);

#endif
