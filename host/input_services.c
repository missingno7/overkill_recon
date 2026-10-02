#include "game.h"
#include "input_services.h"
#include "sdl_gamepad.h"
#include "sdl_input.h"

static word x_sample, y_sample;
static byte button_sample = 0xFF;
static byte sample_injected;
static unsigned flush_count;

/* When no SDL gamepad is connected, choose a count inside the game's saved
   unsigned dead zone so a detached device leaves movement bits released. */
static word released_axis_count(word center, word low, word high)
{
    if (center >= low && center <= high) return center;
    if (low <= high) return (word)(low + ((word)(high - low) >> 1));
    /* A reversed threshold pair has no value that can satisfy both tests; keep
       the calibrated center and preserve the game code's independent tests. */
    return center;
}

void overkill_input_read_sample(uint16_t *x, uint16_t *y, uint8_t *buttons)
{
    int connected;

    if (!sample_injected) {
        connected = actual_sdl_gamepad_poll(&x_sample, &y_sample, &button_sample);
        if (!connected) {
            x_sample = released_axis_count(JoyCalCenterX,
                                           JoyXLowThreshold, JoyXHighThreshold);
            y_sample = released_axis_count(JoyCalCenterY,
                                           JoyYLowThreshold, JoyYHighThreshold);
            button_sample = 0xFF;
        }
    }

    if (x != NULL) *x = x_sample;
    if (y != NULL) *y = y_sample;
    if (buttons != NULL) *buttons = button_sample;
}

void overkill_set_input_sample(uint16_t x, uint16_t y, uint8_t buttons)
{
    x_sample = x;
    y_sample = y;
    button_sample = buttons;
    sample_injected = 1;
}

void overkill_clear_input_sample(void)
{
    x_sample = 0;
    y_sample = 0;
    button_sample = 0xFF;
    sample_injected = 0;
}

word input_read_x_count(main_routine target)
{
    (void)target;
    overkill_input_read_sample(&x_sample, &y_sample, &button_sample);
    return x_sample;
}
word input_read_y_count(main_routine target)
{
    (void)target;
    overkill_input_read_sample(&x_sample, &y_sample, &button_sample);
    return y_sample;
}
word input_read_button_bits(main_routine target)
{
    (void)target;
    overkill_input_read_sample(&x_sample, &y_sample, &button_sample);
    return button_sample;
}
void input_flush_bios_buffer(main_routine target)
{
    (void)target;
    ++flush_count;
    overkill_sdl_flush_characters();
}
unsigned overkill_input_flush_count(void)
{
    return flush_count;
}
