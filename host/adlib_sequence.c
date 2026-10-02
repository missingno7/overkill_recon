/* Native C implementation of the optional ADLIB module's nine-channel sequencer.
   Every mutable sequencer field stays in the loaded module image. This file owns
   only the host binding to that image and calls the platform OPL write service. */
#include "adlib_sequence.h"

#include "ADLIB_GEN.H"
#include "sound_services.h"

#include <stdlib.h>

#define ADLIB_VOICE_BYTES 0x20u
#define ADLIB_INSTRUMENT_BYTES 0x10u
#define ADLIB_VOICE_COUNT 9u

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

static uint16_t voice_address(unsigned index)
{
    return (uint16_t)(ADLIB_ADLIBVOICE0 + index * ADLIB_VOICE_BYTES);
}

static uint8_t voice_read8(uint16_t voice, uint16_t field)
{
    return module_read8((uint16_t)(voice + field));
}

static void voice_write8(uint16_t voice, uint16_t field, uint8_t value)
{
    module_write8((uint16_t)(voice + field), value);
}

static uint16_t voice_read16(uint16_t voice, uint16_t field)
{
    return module_read16((uint16_t)(voice + field));
}

static void voice_write16(uint16_t voice, uint16_t field, uint16_t value)
{
    module_write16((uint16_t)(voice + field), value);
}

/* AX carries register in AL and data in AH in the original driver. */
static void write_opl_word(uint16_t ax)
{
    sound_services_opl2_write((uint8_t)ax, (uint8_t)(ax >> 8));
}

static void write_opl(uint8_t reg, uint8_t value)
{
    sound_services_opl2_write(reg, value);
}

static uint8_t attenuation(uint8_t level)
{
    return module_read8((uint16_t)(ADLIB_LEVELTOATTENUATION + (level & 0x7Fu)));
}

static void stop_all_music(void)
{
    unsigned index;
    for (index = 0; index < ADLIB_VOICE_COUNT; ++index) {
        uint16_t voice = voice_address(index);
        write_opl_word(voice_read16(voice, ADLIB_ADV_KEY_OFF));
        voice_write8(voice, ADLIB_ADV_ACTIVE, 0);
    }
    /* The original word store clears both mailboxes. */
    module_write16(ADLIB_MUSICREQUEST, 0);
}

static void write_reset_table(void)
{
    uint16_t cursor = ADLIB_OPLRESETTABLE;
    uint16_t pair;
    do {
        pair = module_read16(cursor);
        cursor = (uint16_t)(cursor + 2u);
        if (pair != 0) write_opl_word(pair);
    } while (pair != 0);
}

static void sound_note(uint16_t voice)
{
    uint8_t note = (uint8_t)(voice_read8(voice, ADLIB_ADV_NOTE) +
                             voice_read8(voice, ADLIB_ADV_TRANSPOSE));
    /* AL is shifted as a byte before NoteFnum is indexed, so the word-table
       lookup wraps at 80h even though NoteBlock uses the full note byte. */
    uint8_t fnum_index = (uint8_t)(note << 1);
    uint16_t fnum_address = (uint16_t)(ADLIB_NOTEFNUM + fnum_index);
    uint16_t fnum = (uint16_t)(module_read16(fnum_address) +
                               voice_read16(voice, ADLIB_ADV_DETUNE));
    uint8_t block = module_read8((uint16_t)(ADLIB_NOTEBLOCK + note));
    uint8_t channel = voice_read8(voice, ADLIB_ADV_CHANNEL);
    uint16_t key_off;

    voice_write16(voice, ADLIB_ADV_FNUM, fnum);
    fnum = (uint16_t)(fnum | ((uint16_t)block << 8));
    write_opl((uint8_t)(channel | 0xA0u), (uint8_t)fnum);

    key_off = (uint16_t)((fnum & 0xFF00u) | (uint8_t)(channel | 0xB0u));
    voice_write16(voice, ADLIB_ADV_KEY_OFF, key_off);
    write_opl((uint8_t)key_off, (uint8_t)((key_off >> 8) | 0x20u));

    voice_write8(voice, ADLIB_ADV_SLIDE_LEFT,
                 voice_read8(voice, ADLIB_ADV_SLIDE_LENGTH));
}

static void load_instrument(uint16_t voice, uint8_t number)
{
    uint16_t instrument = (uint16_t)(ADLIB_INSTRUMENT0 +
                                     (uint16_t)number * ADLIB_INSTRUMENT_BYTES);
    uint8_t modulator = voice_read8(voice, ADLIB_ADV_OP_MOD);
    uint8_t carrier = voice_read8(voice, ADLIB_ADV_OP_CAR);
    uint8_t channel = voice_read8(voice, ADLIB_ADV_CHANNEL);
    uint8_t ksl;
    uint8_t level;

    voice_write8(voice, ADLIB_ADV_INSTRUMENT, number);
    voice_write16(voice, ADLIB_ADV_INSTRUMENT_PTR, instrument);

    write_opl((uint8_t)(modulator + 0x60u), module_read8((uint16_t)(instrument + ADLIB_ADI_MOD_ATTACK_DECAY)));
    write_opl((uint8_t)(carrier + 0x60u), module_read8((uint16_t)(instrument + ADLIB_ADI_CAR_ATTACK_DECAY)));
    write_opl((uint8_t)(modulator + 0x80u), module_read8((uint16_t)(instrument + ADLIB_ADI_MOD_SUSTAIN_RELEASE)));
    write_opl((uint8_t)(carrier + 0x80u), module_read8((uint16_t)(instrument + ADLIB_ADI_CAR_SUSTAIN_RELEASE)));
    write_opl((uint8_t)(modulator + 0xE0u), module_read8((uint16_t)(instrument + ADLIB_ADI_MOD_WAVEFORM)));
    write_opl((uint8_t)(carrier + 0xE0u), module_read8((uint16_t)(instrument + ADLIB_ADI_CAR_WAVEFORM)));
    write_opl((uint8_t)(channel + 0xC0u), module_read8((uint16_t)(instrument + ADLIB_ADI_FEEDBACK)));
    write_opl((uint8_t)(modulator + 0x20u), module_read8((uint16_t)(instrument + ADLIB_ADI_MOD_CHARACTER)));
    write_opl((uint8_t)(carrier + 0x20u), module_read8((uint16_t)(instrument + ADLIB_ADI_CAR_CHARACTER)));

    level = module_read8((uint16_t)(instrument + ADLIB_ADI_MOD_VOLUME));
    ksl = (uint8_t)((module_read8((uint16_t)(instrument + ADLIB_ADI_KSL)) << 2) & 0xC0u);
    write_opl((uint8_t)(modulator + 0x40u), (uint8_t)(attenuation(level) | ksl));

    level = module_read8((uint16_t)(instrument + ADLIB_ADI_CAR_VOLUME));
    voice_write8(voice, ADLIB_ADV_CARRIER_VOLUME, level);
    ksl = module_read8((uint16_t)(instrument + ADLIB_ADI_KSL));
    ksl = (uint8_t)(((ksl >> 2) | (ksl << 6)) & 0xC0u);
    write_opl((uint8_t)(carrier + 0x40u), (uint8_t)(attenuation(level) | ksl));

    voice_write8(voice, ADLIB_ADV_TRANSPOSE,
                 module_read8((uint16_t)(instrument + ADLIB_ADI_TRANSPOSE)));
}

static void set_carrier_volume(uint16_t voice, uint8_t level)
{
    uint16_t instrument = voice_read16(voice, ADLIB_ADV_INSTRUMENT_PTR);
    uint8_t ksl = module_read8((uint16_t)(instrument + ADLIB_ADI_KSL));
    uint8_t value = (uint8_t)((ksl << 2) & 0xC0u);
    uint8_t reg = (uint8_t)(voice_read8(voice, ADLIB_ADV_OP_CAR) + 0x40u);

    voice_write8(voice, ADLIB_ADV_CARRIER_VOLUME, level);
    write_opl(reg, (uint8_t)(attenuation(level) | value));
}

static void early_release(uint16_t voice, uint16_t stream)
{
    uint16_t instrument;
    uint8_t release;
    if (module_read8(stream) == ADLIB_ADL_TIE) return;
    instrument = voice_read16(voice, ADLIB_ADV_INSTRUMENT_PTR);
    release = module_read8((uint16_t)(instrument + ADLIB_ADI_RELEASE_STEPS));
    if (release == 0 || release != voice_read8(voice, ADLIB_ADV_STEPS_LEFT)) return;

    write_opl_word(voice_read16(voice, ADLIB_ADV_KEY_OFF));
    voice_write8(voice, ADLIB_ADV_NOTE_STEP, 0);
}

static void write_fnum_and_block(uint16_t voice, uint16_t fnum, uint8_t block)
{
    uint8_t channel = voice_read8(voice, ADLIB_ADV_CHANNEL);
    uint8_t high;
    uint16_t key_off;

    fnum = (uint16_t)((fnum & 0xFCFFu) | ((fnum >> 8) & 0x0003u) << 8);
    voice_write16(voice, ADLIB_ADV_FNUM, fnum);
    write_opl((uint8_t)(channel + 0xA0u), (uint8_t)fnum);
    high = (uint8_t)(((fnum >> 8) & 0x03u) | (block & 0x1Cu));
    key_off = (uint16_t)(((uint16_t)high << 8) |
                         (uint8_t)(channel + 0xB0u));
    voice_write16(voice, ADLIB_ADV_KEY_OFF, key_off);
    write_opl((uint8_t)key_off, (uint8_t)((key_off >> 8) | 0x20u));
}

static void apply_slide(uint16_t voice)
{
    uint8_t remaining;
    uint8_t block;
    uint16_t fnum;

    if (voice_read8(voice, ADLIB_ADV_SLIDE_LENGTH) == 0) return;
    remaining = voice_read8(voice, ADLIB_ADV_SLIDE_LEFT);
    if (remaining == 0) return;
    remaining = (uint8_t)(remaining - 1u);
    voice_write8(voice, ADLIB_ADV_SLIDE_LEFT, remaining);
    if (remaining == 0) return;

    block = (uint8_t)(voice_read8(voice, ADLIB_ADV_KEY_OFF + 1u) & 0x1Cu);
    fnum = (uint16_t)(voice_read16(voice, ADLIB_ADV_FNUM) +
                      voice_read16(voice, ADLIB_ADV_SLIDE_DELTA));
    fnum = (uint16_t)((fnum & 0xFCFFu) | ((fnum >> 8) & 3u) << 8);
    if ((int16_t)fnum > 0x03EC) {
        fnum >>= 1;
        block = (uint8_t)(block + 4u);
    } else if ((int16_t)fnum <= 0x01F6) {
        fnum = (uint16_t)(fnum << 1);
        block = (uint8_t)(block - 4u);
    }
    write_fnum_and_block(voice, fnum, block);
}

static void apply_bend(uint16_t voice)
{
    uint8_t delay = voice_read8(voice, ADLIB_ADV_BEND_DELAY);
    uint8_t remaining;
    uint8_t block;
    uint16_t fnum;

    if (delay != 0) {
        delay = (uint8_t)(delay - 1u);
        voice_write8(voice, ADLIB_ADV_BEND_DELAY, delay);
        if (delay != 0) return;
    }

    remaining = voice_read8(voice, ADLIB_ADV_BEND_COUNT);
    if (remaining == 0) return;
    voice_write8(voice, ADLIB_ADV_BEND_COUNT, (uint8_t)(remaining - 1u));

    block = (uint8_t)(voice_read8(voice, ADLIB_ADV_KEY_OFF + 1u) & 0x1Cu);
    fnum = (uint16_t)(voice_read16(voice, ADLIB_ADV_FNUM) +
                      voice_read16(voice, ADLIB_ADV_BEND_DELTA));
    fnum = (uint16_t)((fnum & 0xFCFFu) | ((fnum >> 8) & 3u) << 8);
    if ((int16_t)fnum > 0x03EC) {
        fnum >>= 1;
        block = (uint8_t)(block + 4u);
    } else if ((int16_t)fnum <= 0x01F6) {
        fnum = (uint16_t)(fnum << 1);
        block = (uint8_t)(block - 4u);
    }
    write_fnum_and_block(voice, fnum, block);
}

static void apply_note_step(uint16_t voice)
{
    uint8_t step = voice_read8(voice, ADLIB_ADV_NOTE_STEP);
    if (step == 0) return;
    voice_write8(voice, ADLIB_ADV_NOTE,
                 (uint8_t)(voice_read8(voice, ADLIB_ADV_NOTE) + step));
    sound_note(voice);
}

static void order_next(uint16_t voice, uint16_t *cursor);

/* Process stream bytes until a note, rest or tie consumes time, or a command
   returns from the original routine. All offsets wrap as 16-bit segment offsets. */
static void read_stream(uint16_t voice, uint16_t cursor)
{
    for (;;) {
        uint8_t value = module_read8(cursor);
        cursor = (uint16_t)(cursor + 1u);

        if ((value & 0x80u) == 0) {
            voice_write8(voice, ADLIB_ADV_NOTE, value);
            write_opl_word(voice_read16(voice, ADLIB_ADV_KEY_OFF));
            sound_note(voice);
            voice_write16(voice, ADLIB_ADV_STREAM, cursor);
            voice_write8(voice, ADLIB_ADV_STEPS_LEFT,
                         voice_read8(voice, ADLIB_ADV_LENGTH));
            return;
        }

        if (value >= 0xE0u) {
            voice_write8(voice, ADLIB_ADV_LENGTH, (uint8_t)(value - 0xDFu));
            continue;
        }

        if (value >= ADLIB_ADL_INSTRUMENT) {
            uint8_t number = (uint8_t)(value - ADLIB_ADL_INSTRUMENT);
            if (number != voice_read8(voice, ADLIB_ADV_INSTRUMENT))
                load_instrument(voice, number);
            continue;
        }

        if (value > ADLIB_ADL_STEP_OFF) {
            stop_all_music();
            return;
        }

        switch (value) {
        case ADLIB_ADL_END_PATTERN:
            if (module_read8(ADLIB_MUSICREQUEST) != 0) {
                module_write8(ADLIB_PENDINGTUNE, module_read8(ADLIB_MUSICREQUEST));
                return;
            }
            order_next(voice, &cursor);
            continue;

        case ADLIB_ADL_REST:
            write_opl_word(voice_read16(voice, ADLIB_ADV_KEY_OFF));
            /* FALLTHROUGH */
        case ADLIB_ADL_TIE:
            voice_write16(voice, ADLIB_ADV_STREAM, cursor);
            voice_write8(voice, ADLIB_ADV_STEPS_LEFT,
                         voice_read8(voice, ADLIB_ADV_LENGTH));
            return;

        case ADLIB_ADL_STOP_ALL:
            stop_all_music();
            return;

        case ADLIB_ADL_TRANSPOSE:
            voice_write8(voice, ADLIB_ADV_TRANSPOSE, module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;

        case ADLIB_ADL_VOICE_END:
            write_opl_word(voice_read16(voice, ADLIB_ADV_KEY_OFF));
            voice_write8(voice, ADLIB_ADV_ACTIVE, 0);
            return;

        case ADLIB_ADL_STEP_UP:
            voice_write8(voice, ADLIB_ADV_NOTE_STEP, 1);
            continue;

        case ADLIB_ADL_STEP_DOWN:
            voice_write8(voice, ADLIB_ADV_NOTE_STEP, 0xFFu);
            continue;

        case ADLIB_ADL_CARRIER_VOLUME:
            set_carrier_volume(voice, module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;

        case ADLIB_ADL_JUMP:
            cursor = module_read16(cursor);
            module_write8(ADLIB_PENDINGTUNE, module_read8(ADLIB_MUSICREQUEST));
            continue;

        case ADLIB_ADL_BEND: {
            uint16_t delta = module_read16(cursor);
            cursor = (uint16_t)(cursor + 2u);
            voice_write16(voice, ADLIB_ADV_BEND_DELTA, delta);
            voice_write16(voice, ADLIB_ADV_BEND_DELAY, module_read16(cursor));
            cursor = (uint16_t)(cursor + 2u);
            continue;
        }

        case ADLIB_ADL_DETUNE_SLIDE: {
            uint16_t detune = module_read16(cursor);
            cursor = (uint16_t)(cursor + 2u);
            voice_write16(voice, ADLIB_ADV_DETUNE, detune);
            voice_write16(voice, ADLIB_ADV_SLIDE_DELTA, module_read16(cursor));
            cursor = (uint16_t)(cursor + 2u);
            /* The length byte intentionally overwrites the high byte of delta. */
            voice_write8(voice, ADLIB_ADV_SLIDE_LENGTH, module_read8(cursor));
            cursor = (uint16_t)(cursor + 1u);
            continue;
        }

        case ADLIB_ADL_CLEAR_DETUNE:
            voice_write8(voice, ADLIB_ADV_SLIDE_LENGTH, 0);
            voice_write16(voice, ADLIB_ADV_DETUNE, 0);
            continue;

        case ADLIB_ADL_STEP_OFF:
            voice_write8(voice, ADLIB_ADV_NOTE_STEP, 0);
            continue;

        default:
            /* The table has no commands outside 80h..8Dh. */
            return;
        }
    }
}

static void order_next(uint16_t voice, uint16_t *cursor)
{
    uint16_t order = voice_read16(voice, ADLIB_ADV_ORDER_PTR);
    uint16_t stream = module_read16(order);
    order = (uint16_t)(order + 2u);
    if (stream == 0) {
        order = module_read16(order);
        stream = module_read16(order);
        order = (uint16_t)(order + 2u);
    }
    voice_write16(voice, ADLIB_ADV_ORDER_PTR, order);
    voice_write16(voice, ADLIB_ADV_STREAM, stream);
    *cursor = stream;
}

static void update_voice(uint16_t voice)
{
    uint16_t cursor;
    uint8_t steps_left;

    if (module_read8(ADLIB_PENDINGTUNE) != 0 ||
        voice_read8(voice, ADLIB_ADV_ACTIVE) == 0)
        return;

    cursor = voice_read16(voice, ADLIB_ADV_STREAM);
    if (module_read8(ADLIB_TEMPOCOUNTDOWN) == 0) {
        steps_left = (uint8_t)(voice_read8(voice, ADLIB_ADV_STEPS_LEFT) - 1u);
        voice_write8(voice, ADLIB_ADV_STEPS_LEFT, steps_left);
        if (steps_left == 0) {
            read_stream(voice, cursor);
            return;
        }
        apply_note_step(voice);
        early_release(voice, cursor);
    }
    apply_slide(voice);
    apply_bend(voice);
}

static void handle_music_request(void)
{
    uint8_t tune;
    unsigned index;
    uint16_t table_entry;
    uint16_t tune_header;
    uint16_t voice_count;

    if (module_read8(ADLIB_MUSICCURRENT) == 0)
        module_write8(ADLIB_PENDINGTUNE, module_read8(ADLIB_MUSICREQUEST));
    tune = module_read8(ADLIB_PENDINGTUNE);
    if (tune == 0) return;

    module_write8(ADLIB_MUSICREQUEST, 0);
    module_write8(ADLIB_PENDINGTUNE, 0);
    if (tune > 10u) {
        stop_all_music();
        return;
    }

    write_reset_table();
    for (index = 0; index < ADLIB_VOICE_COUNT; ++index) {
        uint16_t voice = voice_address(index);
        write_opl_word(voice_read16(voice, ADLIB_ADV_KEY_OFF));
        voice_write8(voice, ADLIB_ADV_ACTIVE, 0);
    }

    module_write8(ADLIB_MUSICCURRENT, tune);
    table_entry = (uint16_t)(ADLIB_TUNETABLE + (uint16_t)tune * 2u);
    tune_header = module_read16(table_entry);
    module_write8(ADLIB_TEMPO, module_read8(tune_header));
    voice_count = module_read8((uint16_t)(tune_header + 1u));
    module_write16(ADLIB_VOICECOUNT, voice_count);
    module_write8(ADLIB_TEMPOCOUNTDOWN, 1);
    tune_header = (uint16_t)(tune_header + 2u);

    for (index = 0; index < voice_count; ++index) {
        uint16_t voice = voice_address(index);
        uint16_t order = module_read16(tune_header);
        uint16_t stream;
        tune_header = (uint16_t)(tune_header + 2u);
        stream = module_read16(order);
        voice_write16(voice, ADLIB_ADV_ORDER_PTR, (uint16_t)(order + 2u));
        voice_write16(voice, ADLIB_ADV_STREAM, stream);
        voice_write8(voice, ADLIB_ADV_NOTE_STEP, 0);
        voice_write8(voice, ADLIB_ADV_BEND_COUNT, 0);
        voice_write8(voice, ADLIB_ADV_SLIDE_LENGTH, 0);
        voice_write16(voice, ADLIB_ADV_DETUNE, 0);
        voice_write8(voice, ADLIB_ADV_STEPS_LEFT, 1);
        voice_write8(voice, ADLIB_ADV_ACTIVE, 1);
        voice_write8(voice, ADLIB_ADV_INSTRUMENT, 0xFFu);
    }

    write_opl(0xBDu, 0);
    write_opl(0x08u, 0);
}

int adlib_sequence_bind(uint8_t *segment, size_t bytes)
{
    if (segment == NULL || bytes < ADLIB_MODULE_BYTES) return 0;
    module_image = segment;
    module_image_bytes = bytes;
    return 1;
}

void adlib_sequence_unbind(void)
{
    module_image = NULL;
    module_image_bytes = 0;
}

void adlib_sequence_request(uint8_t tune)
{
    if (module_image == NULL) return;
    module_write16(ADLIB_MUSICREQUEST, tune);
}

void adlib_sequence_tick(void)
{
    unsigned index;

    if (module_image == NULL) return;
    if (module_read8(ADLIB_TICKBUSY) != 0) return;

    module_write8(ADLIB_TICKBUSY, (uint8_t)(module_read8(ADLIB_TICKBUSY) + 1u));
    handle_music_request();
    module_write8(ADLIB_TEMPOCOUNTDOWN,
                  (uint8_t)(module_read8(ADLIB_TEMPOCOUNTDOWN) - 1u));
    for (index = 0; index < ADLIB_VOICE_COUNT; ++index)
        update_voice(voice_address(index));
    if (module_read8(ADLIB_TEMPOCOUNTDOWN) == 0)
        module_write8(ADLIB_TEMPOCOUNTDOWN, module_read8(ADLIB_TEMPO));
    module_write8(ADLIB_TICKBUSY, 0);
}
