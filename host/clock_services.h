#ifndef OVERKILL_HOST_CLOCK_SERVICES_H
#define OVERKILL_HOST_CLOCK_SERVICES_H
#include <stdint.h>

/* Hooks implement the two timer clients, in the original IRQ order. */
void overkill_clock_bind(void (*module_tick)(void), void (*sfx_tick)(void));
void overkill_clock_reset(uint64_t now_ns);
void overkill_clock_advance(uint64_t now_ns);
uint64_t overkill_clock_now_ns(void);
void overkill_clock_tick(void);
void overkill_clock_clear_frame_tick(void);
int overkill_clock_frame_ready(void);
#endif
