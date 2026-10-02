/* Native C implementation of the optional ROLAND module's eight-channel
   sequencer. Its live channel records, request bytes, orders, and streams stay
   in the loaded 64 KiB module segment; MIDI is emitted through the host service. */
#include "roland_sequence.h"

#include "ROLAND_GEN.H"
#include "sound_services.h"

#include <stdlib.h>

#define ROLAND_CHANNEL_BYTES 0x1Fu
#define ROLAND_CHANNEL_COUNT 8u

static uint8_t *module_image;
static size_t module_image_bytes;

static uint8_t module_read8(uint16_t offset)
{
    if (module_image == NULL || (size_t)offset >= module_image_bytes) abort();
    return module_image[offset];
}

static void module_write8(uint16_t offset, uint8_t value)
{
    if (module_image == NULL || (size_t)offset >= module_image_bytes) abort();
    module_image[offset] = value;
}

static uint16_t module_read16(uint16_t offset)
{
    uint8_t low = module_read8(offset);
    uint8_t high = module_read8((uint16_t)(offset + 1u));
    return (uint16_t)(low | ((uint16_t)high << 8));
}

static void module_write16(uint16_t offset, uint16_t value)
{
    module_write8(offset, (uint8_t)value);
    module_write8((uint16_t)(offset + 1u), (uint8_t)(value >> 8));
}

static uint16_t channel_address(unsigned index)
{
    return (uint16_t)(ROLAND_ROLANDCHANNEL0 + index * ROLAND_CHANNEL_BYTES);
}

static uint8_t channel_read8(uint16_t channel, uint16_t field)
{
    return module_read8((uint16_t)(channel + field));
}

static void channel_write8(uint16_t channel, uint16_t field, uint8_t value)
{
    module_write8((uint16_t)(channel + field), value);
}

static uint16_t channel_read16(uint16_t channel, uint16_t field)
{
    return module_read16((uint16_t)(channel + field));
}

static void channel_write16(uint16_t channel, uint16_t field, uint16_t value)
{
    module_write16((uint16_t)(channel + field), value);
}

static void midi_byte(uint8_t value)
{
    (void)sound_services_midi_byte(value);
}

static void send_pitch_bend(uint16_t channel)
{
    uint8_t midi_channel = channel_read8(channel, ROLAND_ROC_MIDI_CHANNEL);
    midi_byte((uint8_t)(midi_channel | 0xE0u));
    midi_byte(0);
    midi_byte((uint8_t)(channel_read8(channel, ROLAND_ROC_BEND_MSB) & 0x7Fu));
}

static void send_note_message(uint16_t channel, uint8_t status)
{
    uint8_t midi_channel = channel_read8(channel, ROLAND_ROC_MIDI_CHANNEL);
    uint8_t note = (uint8_t)(channel_read8(channel, ROLAND_ROC_NOTE) +
                              channel_read8(channel, ROLAND_ROC_TRANSPOSE) + 0x18u);
    midi_byte((uint8_t)(midi_channel | status));
    midi_byte(note);
    midi_byte(channel_read8(channel, ROLAND_ROC_VELOCITY));
}

static void stop_all_channels(void)
{
    unsigned index;
    for (index = 0; index < ROLAND_CHANNEL_COUNT; ++index) {
        uint16_t channel = channel_address(index);
        uint8_t status;
        channel_write8(channel, ROLAND_ROC_ACTIVE, 0);
        status = (uint8_t)(channel_read8(channel, ROLAND_ROC_MIDI_CHANNEL) | 0xB0u);
        midi_byte(status);
        midi_byte(0x7Bu);
        midi_byte(0);
    }
    /* The original word store clears both the request and current-tune bytes. */
    module_write16(ROLAND_MUSICREQUEST, 0);
}

static void send_note_on(uint16_t channel, uint8_t note)
{
    uint8_t bend;
    uint8_t old_note = channel_read8(channel, ROLAND_ROC_NOTE);

    if ((old_note & 0x80u) == 0) send_note_message(channel, 0x80u);

    channel_write8(channel, ROLAND_ROC_NOTE, note);
    channel_write8(channel, ROLAND_ROC_SLIDE_LEFT,
                   channel_read8(channel, ROLAND_ROC_SLIDE_TICKS));
    bend = (uint8_t)(channel_read8(channel, ROLAND_ROC_BEND_BASE) + 0x3Fu);
    if (bend != channel_read8(channel, ROLAND_ROC_BEND_MSB)) {
        channel_write8(channel, ROLAND_ROC_BEND_MSB, bend);
        send_pitch_bend(channel);
    }
    send_note_message(channel, 0x90u);
}

static void step_note(uint16_t channel)
{
    uint8_t step = channel_read8(channel, ROLAND_ROC_NOTE_STEP);
    if (step != 0) {
        send_note_message(channel, 0x80u);
        channel_write8(channel, ROLAND_ROC_NOTE,
                       (uint8_t)(channel_read8(channel, ROLAND_ROC_NOTE) + step));
        send_note_message(channel, 0x90u);
    }
}

static void slide_tick(uint16_t channel)
{
    uint8_t left;
    if (channel_read8(channel, ROLAND_ROC_SLIDE_TICKS) == 0 ||
        channel_read8(channel, ROLAND_ROC_SLIDE_LEFT) == 0)
        return;

    left = (uint8_t)(channel_read8(channel, ROLAND_ROC_SLIDE_LEFT) - 1u);
    channel_write8(channel, ROLAND_ROC_SLIDE_LEFT, left);
    channel_write8(channel, ROLAND_ROC_BEND_MSB,
                   (uint8_t)(channel_read8(channel, ROLAND_ROC_BEND_MSB) +
                             channel_read8(channel, ROLAND_ROC_SLIDE_STEP)));
    send_pitch_bend(channel);
}

static void pitch_envelope_tick(uint16_t channel)
{
    uint8_t period = (uint8_t)(channel_read8(channel, ROLAND_ROC_PERIOD_COUNT) - 1u);
    uint8_t delay;
    uint8_t count;

    channel_write8(channel, ROLAND_ROC_PERIOD_COUNT, period);
    if (period != 0) return;

    channel_write8(channel, ROLAND_ROC_PERIOD_COUNT,
                   channel_read8(channel, ROLAND_ROC_PERIOD_RELOAD));
    delay = channel_read8(channel, ROLAND_ROC_ENV_DELAY);
    if (delay != 0) {
        delay = (uint8_t)(delay - 1u);
        channel_write8(channel, ROLAND_ROC_ENV_DELAY, delay);
        if (delay != 0) return;
    }

    count = channel_read8(channel, ROLAND_ROC_ENV_COUNT);
    if (count == 0) return;
    channel_write8(channel, ROLAND_ROC_ENV_COUNT, (uint8_t)(count - 1u));
    channel_write8(channel, ROLAND_ROC_BEND_MSB,
                   (uint8_t)(channel_read8(channel, ROLAND_ROC_BEND_MSB) +
                             channel_read8(channel, ROLAND_ROC_ENV_STEP)));
    send_pitch_bend(channel);
}

static uint16_t next_order_pattern(uint16_t channel, uint16_t order_cursor)
{
    uint16_t loop_order = module_read16(order_cursor);
    uint16_t stream = module_read16(loop_order);
    loop_order = (uint16_t)(loop_order + 2u);
    channel_write16(channel, ROLAND_ROC_ORDER_PTR, loop_order);
    channel_write16(channel, ROLAND_ROC_STREAM, stream);
    return stream;
}

/* Continue through zero-time commands. Notes, rests, and ties save the cursor and
   consume the current event length just as the original stream reader does. */
static void read_stream(uint16_t channel, uint16_t cursor)
{
    for (;;) {
        uint8_t value = module_read8(cursor);
        cursor = (uint16_t)(cursor + 1u);

        if ((value & 0x80u) == 0) {
            send_note_on(channel, value);
            channel_write16(channel, ROLAND_ROC_STREAM, cursor);
            channel_write8(channel, ROLAND_ROC_ROWS_LEFT,
                           channel_read8(channel, ROLAND_ROC_LENGTH));
            return;
        }

        if (value >= 0xE0u) {
            channel_write8(channel, ROLAND_ROC_LENGTH,
                           (uint8_t)(value - ROLAND_ROL_LENGTH));
            continue;
        }

        if (value > ROLAND_ROL_VELOCITY) {
            stop_all_channels();
            return;
        }

        switch (value) {
        case ROLAND_ROL_END_PATTERN: {
            uint16_t order_cursor;
            uint16_t stream;
            module_write8(ROLAND_PENDINGTUNE, module_read8(ROLAND_MUSICREQUEST));
            order_cursor = channel_read16(channel, ROLAND_ROC_ORDER_PTR);
            stream = module_read16(order_cursor);
            order_cursor = (uint16_t)(order_cursor + 2u);
            if (stream == 0) {
                stream = next_order_pattern(channel, order_cursor);
            } else {
                channel_write16(channel, ROLAND_ROC_ORDER_PTR, order_cursor);
                channel_write16(channel, ROLAND_ROC_STREAM, stream);
            }
            cursor = stream;
            continue;
        }

        case ROLAND_ROL_REST:
            send_note_message(channel, 0x80u);
            channel_write8(channel, ROLAND_ROC_NOTE, 0xFFu);
            /* FALLTHROUGH */
        case ROLAND_ROL_TIE:
            channel_write16(channel, ROLAND_ROC_STREAM, cursor);
            channel_write8(channel, ROLAND_ROC_ROWS_LEFT,
                           channel_read8(channel, ROLAND_ROC_LENGTH));
            return;

        case ROLAND_ROL_STOP_ALL:
            stop_all_channels();
            return;

        case ROLAND_ROL_TRANSPOSE:
            channel_write8(channel, ROLAND_ROC_TRANSPOSE, module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;

        case ROLAND_ROL_CHANNEL_END:
            send_note_message(channel, 0x80u);
            channel_write8(channel, ROLAND_ROC_ACTIVE, 0);
            channel_write8(channel, ROLAND_ROC_UNUSED_1E, 0);
            return;

        case ROLAND_ROL_STEP_UP:
            channel_write8(channel, ROLAND_ROC_NOTE_STEP, 1);
            continue;

        case ROLAND_ROL_STEP_DOWN:
            channel_write8(channel, ROLAND_ROC_NOTE_STEP, 0xFFu);
            continue;

        case ROLAND_ROL_VOLUME: {
            uint8_t volume = module_read8(cursor);
            midi_byte(7);
            midi_byte(volume);
            cursor = (uint16_t)(cursor + 1u);
            channel_write8(channel, ROLAND_ROC_VOLUME, volume);
            continue;
        }

        case ROLAND_ROL_PITCH_ENVELOPE:
            channel_write16(channel, ROLAND_ROC_ENV_STEP, module_read16(cursor));
            cursor = (uint16_t)(cursor + 2u);
            channel_write16(channel, ROLAND_ROC_ENV_DELAY, module_read16(cursor));
            cursor = (uint16_t)(cursor + 2u);
            continue;

        case ROLAND_ROL_SLIDE: {
            uint16_t base_and_step = module_read16(cursor);
            channel_write16(channel, ROLAND_ROC_BEND_BASE, base_and_step);
            cursor = (uint16_t)(cursor + 2u);
            channel_write8(channel, ROLAND_ROC_SLIDE_TICKS, module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;
        }

        case ROLAND_ROL_CLEAR_SLIDE:
            channel_write8(channel, ROLAND_ROC_SLIDE_TICKS, 0);
            channel_write8(channel, ROLAND_ROC_BEND_BASE, 0);
            continue;

        case ROLAND_ROL_EFFECT_PERIOD:
            channel_write8(channel, ROLAND_ROC_PERIOD_RELOAD, module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;

        case ROLAND_ROL_BEND_RANGE: {
            uint8_t status = (uint8_t)(channel_read8(channel, ROLAND_ROC_MIDI_CHANNEL) |
                                       0xB0u);
            midi_byte(status);
            midi_byte(0x64u);
            midi_byte(0);
            midi_byte(status);
            midi_byte(0x65u);
            midi_byte(0);
            midi_byte(status);
            midi_byte(6);
            midi_byte(module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;
        }

        case ROLAND_ROL_JUMP:
            cursor = module_read16(cursor);
            module_write8(ROLAND_PENDINGTUNE, module_read8(ROLAND_MUSICREQUEST));
            continue;

        case ROLAND_ROL_STEP_OFF:
            channel_write8(channel, ROLAND_ROC_NOTE_STEP, 0);
            continue;

        case ROLAND_ROL_PROGRAM: {
            uint8_t midi_channel = channel_read8(channel, ROLAND_ROC_MIDI_CHANNEL);
            uint8_t status = (uint8_t)(midi_channel | 0xB0u);
            midi_byte((uint8_t)(midi_channel | 0xC0u));
            midi_byte(module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            midi_byte(status);
            midi_byte(7);
            midi_byte(0x64u);
            channel_write8(channel, ROLAND_ROC_VOLUME, 0x64u);
            continue;
        }

        case ROLAND_ROL_VELOCITY:
            channel_write8(channel, ROLAND_ROC_VELOCITY, module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;

        default:
            /* All 80h..91h entries are handled above. */
            return;
        }
    }
}

static void update_channel(uint16_t channel)
{
    uint16_t cursor;
    uint8_t rows_left;

    if (channel_read8(channel, ROLAND_ROC_ACTIVE) == 0) return;
    cursor = channel_read16(channel, ROLAND_ROC_STREAM);
    if (module_read8(ROLAND_TEMPOCOUNTDOWN) == 0) {
        rows_left = (uint8_t)(channel_read8(channel, ROLAND_ROC_ROWS_LEFT) - 1u);
        channel_write8(channel, ROLAND_ROC_ROWS_LEFT, rows_left);
        if (rows_left == 0) {
            read_stream(channel, cursor);
            return;
        }
        step_note(channel);
    }
    slide_tick(channel);
    pitch_envelope_tick(channel);
}

static void handle_music_request(void)
{
    uint8_t tune;
    unsigned index;
    uint16_t table_entry;
    uint16_t tune_header;
    uint16_t channel_count;

    if (module_read8(ROLAND_MUSICCURRENT) == 0)
        module_write8(ROLAND_PENDINGTUNE, module_read8(ROLAND_MUSICREQUEST));
    tune = module_read8(ROLAND_PENDINGTUNE);
    if (tune == 0) return;

    module_write8(ROLAND_MUSICREQUEST, 0);
    module_write8(ROLAND_PENDINGTUNE, 0);
    stop_all_channels();
    if (tune >= 0x0Bu) return;

    module_write8(ROLAND_MUSICCURRENT, tune);
    table_entry = (uint16_t)(ROLAND_SONGTABLE - 2u + (uint16_t)tune * 2u);
    tune_header = module_read16(table_entry);
    module_write8(ROLAND_TEMPO, module_read8(tune_header));
    channel_count = module_read8((uint16_t)(tune_header + 1u));
    module_write16(ROLAND_CHANNELCOUNT, channel_count);
    module_write8(ROLAND_TEMPOCOUNTDOWN, 1);
    tune_header = (uint16_t)(tune_header + 2u);

    for (index = 0; index < channel_count; ++index) {
        uint16_t channel = channel_address(index);
        uint16_t order = module_read16(tune_header);
        uint16_t stream;
        tune_header = (uint16_t)(tune_header + 2u);
        stream = module_read16(order);
        channel_write16(channel, ROLAND_ROC_ORDER_PTR, (uint16_t)(order + 2u));
        channel_write16(channel, ROLAND_ROC_STREAM, stream);
        channel_write8(channel, ROLAND_ROC_TRANSPOSE, 0);
        channel_write8(channel, ROLAND_ROC_NOTE_STEP, 0);
        channel_write8(channel, ROLAND_ROC_ENV_COUNT, 0);
        channel_write8(channel, ROLAND_ROC_SLIDE_TICKS, 0);
        channel_write8(channel, ROLAND_ROC_BEND_BASE, 0);
        channel_write8(channel, ROLAND_ROC_ROWS_LEFT, 1);
        channel_write8(channel, ROLAND_ROC_ACTIVE, 1);
    }
}

static int send_sysex(uint16_t body)
{
    static const uint8_t prefix[] = {0xF0u, 0x41u, 0x10u, 0x16u, 0x12u};
    unsigned index;
    uint8_t value;

    for (index = 0; index < sizeof(prefix); ++index)
        if (!sound_services_midi_byte(prefix[index])) return 0;
    do {
        value = module_read8(body);
        body = (uint16_t)(body + 1u);
        if (!sound_services_midi_byte(value)) return 0;
    } while (value != 0xF7u);
    return 1;
}

int roland_sequence_bind(uint8_t *segment, size_t bytes)
{
    if (segment == NULL || bytes < ROLAND_MODULE_BYTES) return 0;
    module_image = segment;
    module_image_bytes = bytes;
    return 1;
}

void roland_sequence_unbind(void)
{
    module_image = NULL;
    module_image_bytes = 0;
}

int roland_sequence_initialize(void)
{
    uint16_t cursor;
    uint16_t body;

    if (module_image == NULL || !sound_services_midi_ready()) return 0;
    cursor = ROLAND_SYSEXTABLE;
    for (;;) {
        body = module_read16(cursor);
        cursor = (uint16_t)(cursor + 2u);
        if (body == 0) return 1;
        if (!send_sysex(body)) return 0;
    }
}

void roland_sequence_request(uint8_t tune)
{
    if (module_image == NULL) return;
    module_write16(ROLAND_MUSICREQUEST, tune);
}

void roland_sequence_tick(void)
{
    unsigned index;

    if (module_image == NULL) return;
    handle_music_request();
    module_write8(ROLAND_TEMPOCOUNTDOWN,
                  (uint8_t)(module_read8(ROLAND_TEMPOCOUNTDOWN) - 1u));
    for (index = 0; index < ROLAND_CHANNEL_COUNT; ++index)
        update_channel(channel_address(index));
    if (module_read8(ROLAND_TEMPOCOUNTDOWN) == 0)
        module_write8(ROLAND_TEMPOCOUNTDOWN, module_read8(ROLAND_TEMPO));
}
