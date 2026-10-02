#include "game.h"
#include "input_services.h"

static word x_sample, y_sample;
static byte button_sample = 0xFF;
static unsigned flush_count;

void overkill_set_input_sample(uint16_t x, uint16_t y, uint8_t buttons)
{
    x_sample = x;
    y_sample = y;
    button_sample = buttons;
}

/* These names identify the DOS services in the shared C policy. No machine code
   or Watcom register convention is used by the native build. */
void ReadGamePortAAxisCounts(void) {}
void ReadGamePortAButtonBits(void) {}
void FlushBiosKeyboardBuffer(void) {}

word input_read_x_count(main_routine target)
{
    (void)target;
    return x_sample;
}
word input_read_y_count(main_routine target)
{
    (void)target;
    return y_sample;
}
word input_read_button_bits(main_routine target)
{
    (void)target;
    return button_sample;
}
void input_flush_bios_buffer(main_routine target)
{
    (void)target;
    ++flush_count;
}
unsigned overkill_input_flush_count(void)
{
    return flush_count;
}
