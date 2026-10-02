#include "clock_services.h"
#include "game.h"

/* The PC's nominal PIT input clock; accumulation retains the fractional period
   instead of rounding each 4000h-divisor interrupt to milliseconds. */
#define PIT_HZ 1193182u
#define NS_PER_SECOND 1000000000ull

static void (*tick_module)(void);
static void (*tick_sfx)(void);
static uint64_t last_ns;
static uint64_t reported_ns;
static uint64_t remainder;

static volatile byte *frame_tick(void)
{
    return overkill_segment_address(HOST_LOAD_SEGMENT, HOST_TOKEN_TIMERTICKCOUNT);
}

void overkill_clock_bind(void (*module_tick)(void), void (*sfx_tick)(void))
{
    tick_module = module_tick;
    tick_sfx = sfx_tick;
}

void overkill_clock_reset(uint64_t now_ns)
{
    last_ns = now_ns;
    reported_ns = now_ns;
    remainder = 0;
}

uint64_t overkill_clock_now_ns(void)
{
    return reported_ns;
}

void overkill_clock_tick(void)
{
    if (SoundModuleLoaded == 1 && tick_module) tick_module();
    if (tick_sfx) tick_sfx();
    if ((TimerTickPhase & 1) == 0) ++*frame_tick();
    TimerTickPhase = (byte)((TimerTickPhase + 1) & 3);
}

void overkill_clock_advance(uint64_t now_ns)
{
    uint64_t elapsed;
    uint64_t chunk_start = last_ns;
    const uint64_t period = (uint64_t)TIMER_DIVISOR * NS_PER_SECOND;
    if (now_ns < last_ns) {
        overkill_clock_reset(now_ns);
        return;
    }
    elapsed = now_ns - last_ns;
    last_ns = now_ns;
    /* Bound each multiply even after a long debugger pause. Timers still run in
       order; the game frame latch does not create simulation catch-up frames. */
    while (elapsed) {
        uint64_t chunk = elapsed > NS_PER_SECOND ? NS_PER_SECOND : elapsed;
        uint64_t first_crossing = period - remainder;
        uint64_t crossing = first_crossing;
        remainder += chunk * PIT_HZ;
        elapsed -= chunk;
        while (remainder >= period) {
            remainder -= period;
            /* Audio sees each actual interrupt deadline even when several
               pending ticks are delivered at one cooperative idle point. */
            reported_ns = chunk_start + (crossing + PIT_HZ - 1) / PIT_HZ;
            overkill_clock_tick();
            crossing += period;
        }
        chunk_start += chunk;
    }
    reported_ns = now_ns;
}

void overkill_clock_clear_frame_tick(void)
{
    *frame_tick() = 0;
}

int overkill_clock_frame_ready(void)
{
    return *frame_tick() != 0;
}
