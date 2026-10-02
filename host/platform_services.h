#ifndef OVERKILL_HOST_PLATFORM_SERVICES_H
#define OVERKILL_HOST_PLATFORM_SERVICES_H

#include "game.h"

/* Ephemeral register arguments at a DOS service boundary. These are call
   metadata, never a second copy of the game's persistent state. */
typedef struct HostRegisters {
    word ax, bx, cx, dx, si, di, bp, es;
} HostRegisters;

void overkill_platform_call(word token, HostRegisters *registers);
word overkill_platform_last_es(void);
void overkill_platform_bind_idle(void (*idle)(void));
void overkill_platform_bind_exit(void (*terminate)(int));
void overkill_platform_bind_trace(void (*trace)(word, const HostRegisters *));

/* Cooperative equivalent of interrupts while the original code waits. */
void overkill_platform_idle(void);

#endif
