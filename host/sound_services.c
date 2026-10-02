/* Native sound devices for the shared DOS sound policy. Chip writes enter a
   guest-clock-stamped queue; the SDL callback or deterministic offline renderer
   applies them at sample boundaries without calling SDL from the timer path. */
#include "sound_services.h"
#include "adlib_sequence.h"
#include "opl_backend.h"
#include "roland_sequence.h"

#include <SDL3/SDL.h>
#include <math.h>
#include <stdatomic.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#if defined(_WIN32)
#include <windows.h>
#include <mmsystem.h>
#endif

#include "game.h"
#include "clock_services.h"
#include "platform_services.h"

#define SOUND_RATE 48000
#define SOUND_CHANNELS 2
#define SOUND_EVENT_CAPACITY 65536u
#define SOUND_EVENT_MASK (SOUND_EVENT_CAPACITY - 1u)
#define SOUND_CALLBACK_FRAMES 512
#define NS_PER_SECOND 1000000000ull
#define PIT_CLOCK_HZ 1193182.0
#define TANDY_PSG_CLOCK_HZ 223721.0
#define MIDI_SYSEX_CAPACITY 4096u

#if defined(_WIN32)
#define MIDI_SYSEX_SLOTS 4u
#endif

enum SoundEventKind {
    SOUND_EVENT_SPEAKER_ON,
    SOUND_EVENT_SPEAKER_OFF,
    SOUND_EVENT_OPL2_WRITE,
    SOUND_EVENT_TANDY_WRITE
};

typedef struct SoundEvent {
    uint64_t frame;
    uint8_t kind;
    uint8_t address;
    uint8_t value;
} SoundEvent;

static SoundEvent event_queue[SOUND_EVENT_CAPACITY];
static _Atomic uint32_t event_write;
static _Atomic uint32_t event_read;
static _Atomic uint64_t rendered_frames;
static _Atomic uint32_t dropped_events;

static SDL_AudioStream *audio_stream;
static uint8_t audio_subsystem_owned;
static uint8_t offline_mode;
static uint8_t opl_backend_ready;
static uint32_t sound_sample_rate = SOUND_RATE;
static uint64_t sound_timeline_origin_ns;
static uint16_t speaker_divisor;
static double speaker_phase;
static uint16_t psg_tone_period[3];
static uint8_t psg_volume[4];
static uint8_t psg_latched_register;
static uint8_t psg_noise_control;
static uint16_t psg_noise_lfsr;
static double psg_phase[4];

static float psg_volume_gain[16];
static float callback_buffer[SOUND_CALLBACK_FRAMES * SOUND_CHANNELS];
static int16_t opl_callback_buffer[SOUND_CALLBACK_FRAMES * SOUND_CHANNELS];

static SoundMidiByteSink midi_custom_sink;
static void *midi_custom_userdata;
static SoundOfflinePcmSink offline_pcm_sink;
static void *offline_pcm_userdata;
static uint8_t midi_ready;
static uint8_t midi_custom_active;
static uint8_t midi_status;
static uint8_t midi_running_status;
static uint8_t midi_data[2];
static uint8_t midi_data_count;
static uint8_t midi_data_needed;
static uint8_t midi_in_sysex;
static uint8_t midi_sysex[MIDI_SYSEX_CAPACITY];
static size_t midi_sysex_length;

static void sound_reset_devices(void);
static void sound_prepare_tables(void);

#if defined(_WIN32)
typedef struct MidiSysExSlot {
    MIDIHDR header;
    uint8_t bytes[MIDI_SYSEX_CAPACITY];
    volatile LONG busy;
    uint8_t prepared;
} MidiSysExSlot;

static HMIDIOUT midi_output;
static MidiSysExSlot midi_sysex_slots[MIDI_SYSEX_SLOTS];

static void CALLBACK midi_output_callback(HMIDIOUT output, UINT message,
                                           DWORD_PTR instance,
                                           DWORD_PTR parameter1,
                                           DWORD_PTR parameter2)
{
    MIDIHDR *header;
    MidiSysExSlot *slot;
    (void)output;
    (void)instance;
    (void)parameter2;
    if (message != MOM_DONE || parameter1 == 0) return;
    header = (MIDIHDR *)parameter1;
    slot = (MidiSysExSlot *)((uint8_t *)header - offsetof(MidiSysExSlot, header));
    InterlockedExchange(&slot->busy, 0);
}

static int midi_send_short(uint8_t status, uint8_t first, uint8_t second)
{
    DWORD packed;
    if (midi_output == NULL) return 0;
    packed = (DWORD)status | ((DWORD)first << 8) | ((DWORD)second << 16);
    return midiOutShortMsg(midi_output, packed) == MMSYSERR_NOERROR;
}

static int midi_send_sysex(const uint8_t *bytes, size_t length)
{
    unsigned i;
    MidiSysExSlot *slot = NULL;
    MMRESULT result;

    if (midi_output == NULL || length == 0 || length > MIDI_SYSEX_CAPACITY) return 0;
    for (i = 0; i != MIDI_SYSEX_SLOTS; ++i) {
        MidiSysExSlot *candidate = &midi_sysex_slots[i];
        if (InterlockedCompareExchange(&candidate->busy, 1, 0) != 0) continue;
        if (candidate->prepared) {
            result = midiOutUnprepareHeader(midi_output, &candidate->header,
                                             sizeof(candidate->header));
            if (result != MMSYSERR_NOERROR) {
                InterlockedExchange(&candidate->busy, 0);
                continue;
            }
            candidate->prepared = 0;
        }
        slot = candidate;
        break;
    }
    if (slot == NULL) return 0;

    memset(&slot->header, 0, sizeof(slot->header));
    memcpy(slot->bytes, bytes, length);
    slot->header.lpData = (LPSTR)slot->bytes;
    slot->header.dwBufferLength = (DWORD)length;
    result = midiOutPrepareHeader(midi_output, &slot->header, sizeof(slot->header));
    if (result != MMSYSERR_NOERROR) {
        InterlockedExchange(&slot->busy, 0);
        return 0;
    }
    slot->prepared = 1;
    result = midiOutLongMsg(midi_output, &slot->header, sizeof(slot->header));
    if (result != MMSYSERR_NOERROR) {
        (void)midiOutUnprepareHeader(midi_output, &slot->header, sizeof(slot->header));
        slot->prepared = 0;
        InterlockedExchange(&slot->busy, 0);
        return 0;
    }
    return 1;
}
#endif

static void midi_parser_reset(void)
{
    midi_status = 0;
    midi_running_status = 0;
    midi_data_count = 0;
    midi_data_needed = 0;
    midi_in_sysex = 0;
    midi_sysex_length = 0;
}

static uint64_t sound_frame_for_time(uint64_t time_ns)
{
    uint64_t elapsed;
    uint64_t whole_seconds;
    uint64_t partial_ns;
    uint64_t rate = sound_sample_rate;
    if (time_ns <= sound_timeline_origin_ns) return 0;
    elapsed = time_ns - sound_timeline_origin_ns;
    whole_seconds = elapsed / NS_PER_SECOND;
    partial_ns = elapsed % NS_PER_SECOND;
    if (whole_seconds > UINT64_MAX / rate) return UINT64_MAX;
    return whole_seconds * rate + (partial_ns * rate) / NS_PER_SECOND;
}

static int sound_prepare_backend(uint32_t sample_rate)
{
    if (sample_rate == 0) return 0;
    sound_sample_rate = sample_rate;
    sound_prepare_tables();
    opl_backend_ready = (uint8_t)(opl_backend_init(sample_rate) != 0);
    if (!opl_backend_ready) return 0;
    sound_reset_devices();
    atomic_store_explicit(&event_read, 0, memory_order_relaxed);
    atomic_store_explicit(&event_write, 0, memory_order_relaxed);
    atomic_store_explicit(&rendered_frames, 0, memory_order_relaxed);
    atomic_store_explicit(&dropped_events, 0, memory_order_relaxed);
    sound_timeline_origin_ns = overkill_clock_now_ns();
    return 1;
}

static void sound_reset_devices(void)
{
    unsigned i;
    speaker_divisor = 0;
    speaker_phase = 0.0;
    if (opl_backend_ready) opl_backend_reset();
    for (i = 0; i != 3; ++i) {
        psg_tone_period[i] = 0;
        psg_phase[i] = 0.0;
    }
    for (i = 0; i != 4; ++i) {
        psg_volume[i] = 15;
        psg_phase[i] = 0.0;
    }
    psg_latched_register = 0;
    psg_noise_control = 0;
    psg_noise_lfsr = 0x4000;
}

static void sound_prepare_tables(void)
{
    unsigned i;
    for (i = 0; i != 16; ++i) {
        psg_volume_gain[i] = (i == 15) ? 0.0f : powf(10.0f, -((float)i * 2.0f) / 20.0f);
    }
}

static void sound_push_event(uint8_t kind, uint8_t address, uint8_t value)
{
    uint32_t write_index = atomic_load_explicit(&event_write, memory_order_relaxed);
    uint32_t read_index = atomic_load_explicit(&event_read, memory_order_acquire);
    SoundEvent *event;

    if ((uint32_t)(write_index - read_index) >= SOUND_EVENT_CAPACITY) {
        atomic_fetch_add_explicit(&dropped_events, 1, memory_order_relaxed);
        return;
    }
    event = &event_queue[write_index & SOUND_EVENT_MASK];
    event->frame = sound_frame_for_time(overkill_clock_now_ns());
    event->kind = kind;
    event->address = address;
    event->value = value;
    atomic_store_explicit(&event_write, write_index + 1, memory_order_release);
}

static void opl_write(uint8_t reg, uint8_t value)
{
    if (opl_backend_ready) opl_backend_write(reg, value);
}

static void tandy_write(uint8_t value)
{
    unsigned reg;
    if (value & 0x80) {
        reg = (unsigned)((value >> 4) & 7);
        psg_latched_register = (uint8_t)reg;
        if ((reg & 1) != 0) {
            psg_volume[reg >> 1] = (uint8_t)(value & 0x0F);
        } else if (reg == 6) {
            psg_noise_control = (uint8_t)(value & 7);
            psg_noise_lfsr = 0x4000;
            psg_phase[3] = 0.0;
        } else {
            unsigned tone = reg >> 1;
            psg_tone_period[tone] = (uint16_t)((psg_tone_period[tone] & 0x03F0) |
                                                (value & 0x0F));
        }
        return;
    }

    reg = psg_latched_register;
    if ((reg & 1) != 0) {
        psg_volume[reg >> 1] = (uint8_t)(value & 0x0F);
    } else if (reg != 6) {
        unsigned tone = reg >> 1;
        psg_tone_period[tone] = (uint16_t)((psg_tone_period[tone] & 0x000F) |
                                            ((uint16_t)(value & 0x3F) << 4));
    }
}

static float tandy_sample(void)
{
    float mixed = 0.0f;
    unsigned channel;
    for (channel = 0; channel != 3; ++channel) {
        uint16_t period = psg_tone_period[channel];
        double frequency;
        if (period == 0) period = 0x400;
        frequency = TANDY_PSG_CLOCK_HZ / (32.0 * (double)period);
        psg_phase[channel] += frequency / (double)sound_sample_rate;
        psg_phase[channel] -= floor(psg_phase[channel]);
        mixed += (psg_phase[channel] < 0.5 ? 1.0f : -1.0f) *
                 psg_volume_gain[psg_volume[channel]];
    }
    {
        unsigned rate = (unsigned)(psg_noise_control & 3);
        double noise_hz;
        if (rate == 3) {
            uint16_t period = psg_tone_period[2];
            if (period == 0) period = 0x400;
            noise_hz = TANDY_PSG_CLOCK_HZ / (32.0 * (double)period);
        } else {
            noise_hz = TANDY_PSG_CLOCK_HZ / (512.0 * (double)(1u << rate));
        }
        psg_phase[3] += noise_hz / (double)sound_sample_rate;
        while (psg_phase[3] >= 1.0) {
            uint16_t feedback;
            psg_phase[3] -= 1.0;
            if (psg_noise_control & 4)
                feedback = (uint16_t)((psg_noise_lfsr ^ (psg_noise_lfsr >> 1)) & 1);
            else
                feedback = (uint16_t)(psg_noise_lfsr & 1);
            psg_noise_lfsr = (uint16_t)((psg_noise_lfsr >> 1) | (feedback << 14));
        }
        mixed += ((psg_noise_lfsr & 1) != 0 ? 1.0f : -1.0f) *
                 psg_volume_gain[psg_volume[3]];
    }
    return mixed * 0.035f;
}

static float speaker_sample(void)
{
    double frequency;
    if (speaker_divisor == 0) return 0.0f;
    frequency = PIT_CLOCK_HZ / (double)speaker_divisor;
    speaker_phase += frequency / (double)sound_sample_rate;
    speaker_phase -= floor(speaker_phase);
    return (speaker_phase < 0.5 ? 1.0f : -1.0f) * 0.10f;
}

static void apply_event(const SoundEvent *event)
{
    switch (event->kind) {
    case SOUND_EVENT_SPEAKER_ON:
        speaker_divisor = (uint16_t)(event->address | ((uint16_t)event->value << 8));
        speaker_phase = 0.0;
        break;
    case SOUND_EVENT_SPEAKER_OFF:
        speaker_divisor = 0;
        break;
    case SOUND_EVENT_OPL2_WRITE:
        opl_write(event->address, event->value);
        break;
    case SOUND_EVENT_TANDY_WRITE:
        tandy_write(event->value);
        break;
    default:
        break;
    }
}

static void sound_render(float *output, unsigned frames)
{
    uint32_t read_index = atomic_load_explicit(&event_read, memory_order_relaxed);
    uint32_t available = atomic_load_explicit(&event_write, memory_order_acquire);
    uint64_t first_frame = atomic_load_explicit(&rendered_frames, memory_order_relaxed);
    unsigned frame_offset = 0;

    while (frame_offset < frames) {
        uint64_t absolute_frame = first_frame + frame_offset;
        uint64_t stop_frame = first_frame + frames;
        unsigned run_frames;
        unsigned i;

        while (read_index != available &&
               event_queue[read_index & SOUND_EVENT_MASK].frame <= absolute_frame) {
            apply_event(&event_queue[read_index & SOUND_EVENT_MASK]);
            ++read_index;
        }
        if (read_index != available) {
            uint64_t event_frame = event_queue[read_index & SOUND_EVENT_MASK].frame;
            if (event_frame < stop_frame) stop_frame = event_frame;
        }
        run_frames = (unsigned)(stop_frame - absolute_frame);
        if (run_frames == 0) continue;

        if (opl_backend_ready)
            opl_backend_render(opl_callback_buffer + frame_offset * SOUND_CHANNELS,
                               run_frames);
        else
            for (i = 0; i != run_frames * SOUND_CHANNELS; ++i)
                opl_callback_buffer[frame_offset * SOUND_CHANNELS + i] = 0;

        for (i = 0; i != run_frames; ++i) {
            unsigned output_frame = frame_offset + i;
            float auxiliary = tandy_sample() + speaker_sample();
            float left = (float)opl_callback_buffer[output_frame * SOUND_CHANNELS] /
                         32768.0f * 0.65f + auxiliary;
            float right = (float)opl_callback_buffer[output_frame * SOUND_CHANNELS + 1] /
                          32768.0f * 0.65f + auxiliary;
            if (left > 1.0f) left = 1.0f;
            if (left < -1.0f) left = -1.0f;
            if (right > 1.0f) right = 1.0f;
            if (right < -1.0f) right = -1.0f;
            output[output_frame * SOUND_CHANNELS] = left;
            output[output_frame * SOUND_CHANNELS + 1] = right;
        }
        frame_offset += run_frames;
    }

    atomic_store_explicit(&event_read, read_index, memory_order_release);
    atomic_store_explicit(&rendered_frames, first_frame + frames, memory_order_release);
}

static void SDLCALL sound_audio_callback(void *userdata, SDL_AudioStream *stream,
                                          int additional_amount, int total_amount)
{
    int remaining = additional_amount;
    (void)userdata;
    (void)total_amount;
    while (remaining >= (int)(sizeof(float) * SOUND_CHANNELS)) {
        int maximum = SOUND_CALLBACK_FRAMES * (int)(sizeof(float) * SOUND_CHANNELS);
        int bytes = remaining < maximum ? remaining : maximum;
        unsigned frames = (unsigned)(bytes / (int)(sizeof(float) * SOUND_CHANNELS));
        int produced = (int)(frames * sizeof(float) * SOUND_CHANNELS);
        sound_render(callback_buffer, frames);
        if (!SDL_PutAudioStreamData(stream, callback_buffer, produced)) break;
        remaining -= produced;
    }
}

int sound_services_start(void)
{
    SDL_AudioSpec spec;
    if (audio_stream != NULL) return 1;
    if (offline_mode) return 0;
    if ((SDL_WasInit(SDL_INIT_AUDIO) & SDL_INIT_AUDIO) == 0) {
        if (!SDL_InitSubSystem(SDL_INIT_AUDIO)) return 0;
        audio_subsystem_owned = 1;
    }
    if (!sound_prepare_backend(SOUND_RATE)) {
        if (audio_subsystem_owned) SDL_QuitSubSystem(SDL_INIT_AUDIO);
        audio_subsystem_owned = 0;
        return 0;
    }
    spec.freq = SOUND_RATE;
    spec.format = SDL_AUDIO_F32;
    spec.channels = SOUND_CHANNELS;
    audio_stream = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK,
                                              &spec, sound_audio_callback, NULL);
    if (audio_stream == NULL) {
        if (audio_subsystem_owned) SDL_QuitSubSystem(SDL_INIT_AUDIO);
        audio_subsystem_owned = 0;
        return 0;
    }
    if (!SDL_ResumeAudioStreamDevice(audio_stream)) {
        SDL_DestroyAudioStream(audio_stream);
        audio_stream = NULL;
        if (audio_subsystem_owned) SDL_QuitSubSystem(SDL_INIT_AUDIO);
        audio_subsystem_owned = 0;
        return 0;
    }
    return 1;
}

int sound_services_start_offline(uint32_t sample_rate)
{
    if (audio_stream != NULL || offline_mode) return 0;
    if (!sound_prepare_backend(sample_rate)) return 0;
    offline_mode = 1;
    return 1;
}

void sound_services_bind_offline_pcm_sink(SoundOfflinePcmSink sink, void *userdata)
{
    offline_pcm_sink = sink;
    offline_pcm_userdata = userdata;
}

void sound_services_advance_ns(uint64_t guest_time_ns)
{
    uint64_t target_frame;
    if (!offline_mode) return;
    target_frame = sound_frame_for_time(guest_time_ns);
    for (;;) {
        uint64_t current = atomic_load_explicit(&rendered_frames, memory_order_relaxed);
        uint64_t remaining;
        unsigned frames;
        if (current >= target_frame) break;
        remaining = target_frame - current;
        frames = remaining > SOUND_CALLBACK_FRAMES ? SOUND_CALLBACK_FRAMES :
                 (unsigned)remaining;
        sound_render(callback_buffer, frames);
        if (offline_pcm_sink != NULL)
            offline_pcm_sink(offline_pcm_userdata, callback_buffer, frames);
    }
}

void sound_services_shutdown(void)
{
    sound_services_midi_shutdown();
    if (audio_stream != NULL) {
        SDL_PauseAudioStreamDevice(audio_stream);
        SDL_DestroyAudioStream(audio_stream);
        audio_stream = NULL;
    }
    if (audio_subsystem_owned) SDL_QuitSubSystem(SDL_INIT_AUDIO);
    audio_subsystem_owned = 0;
    offline_mode = 0;
    sound_reset_devices();
    atomic_store_explicit(&event_read, 0, memory_order_relaxed);
    atomic_store_explicit(&event_write, 0, memory_order_relaxed);
    atomic_store_explicit(&rendered_frames, 0, memory_order_relaxed);
    atomic_store_explicit(&dropped_events, 0, memory_order_relaxed);
}

void sound_services_speaker_off(void)
{
    sound_push_event(SOUND_EVENT_SPEAKER_OFF, 0, 0);
}

void sound_services_speaker_program(uint16_t pit_divisor)
{
    sound_push_event(SOUND_EVENT_SPEAKER_ON, (uint8_t)pit_divisor,
                     (uint8_t)(pit_divisor >> 8));
}

void sound_services_opl2_write(uint8_t reg, uint8_t value)
{
    sound_push_event(SOUND_EVENT_OPL2_WRITE, reg, value);
}

void sound_services_tandy_psg_write(uint8_t value)
{
    sound_push_event(SOUND_EVENT_TANDY_WRITE, 0, value);
}

uint32_t sound_services_dropped_events(void)
{
    return atomic_load_explicit(&dropped_events, memory_order_relaxed);
}

void sound_services_music_request(uint8_t tune)
{
    /* Only the loaded module adapter owns the active request bytes. */
    if (SoundModuleNamePtr == GAME_OFFSET(SoundModuleNameAdlib))
        adlib_sequence_request(tune);
    else if (SoundModuleNamePtr == GAME_OFFSET(SoundModuleNameRoland))
        roland_sequence_request(tune);
}

void sound_services_wait_ticks(uint16_t ticks)
{
    volatile byte *phase_value = (volatile byte *)&TimerTickPhase;
    volatile byte *loaded_value = (volatile byte *)&SoundModuleLoaded;
    while (ticks != 0) {
        byte phase;
        if (*loaded_value == 0) return;
        phase = *phase_value;
        while (*loaded_value != 0 && *phase_value == phase)
            overkill_platform_idle();
        --ticks;
    }
}

void sound_services_midi_bind_sink(SoundMidiByteSink sink, void *userdata)
{
    if (midi_ready) sound_services_midi_shutdown();
    midi_custom_sink = sink;
    midi_custom_userdata = userdata;
}

int sound_services_midi_start(void)
{
    if (midi_ready) return 1;
    midi_parser_reset();
    if (midi_custom_sink != NULL) {
        midi_custom_active = 1;
        midi_ready = 1;
        return 1;
    }
#if defined(_WIN32)
    memset(midi_sysex_slots, 0, sizeof(midi_sysex_slots));
    if (midiOutOpen(&midi_output, MIDI_MAPPER,
                    (DWORD_PTR)midi_output_callback, 0, CALLBACK_FUNCTION) !=
        MMSYSERR_NOERROR) {
        midi_output = NULL;
        return 0;
    }
    midi_custom_active = 0;
    midi_ready = 1;
    return 1;
#else
    return 0;
#endif
}

void sound_services_midi_shutdown(void)
{
#if defined(_WIN32)
    unsigned i;
    if (midi_output != NULL) {
        (void)midiOutReset(midi_output);
        for (i = 0; i != MIDI_SYSEX_SLOTS; ++i) {
            MidiSysExSlot *slot = &midi_sysex_slots[i];
            unsigned attempts = 0;
            while (InterlockedCompareExchange(&slot->busy, 0, 0) != 0 &&
                   attempts++ != 1000)
                Sleep(1);
            if (slot->prepared &&
                InterlockedCompareExchange(&slot->busy, 0, 0) == 0) {
                (void)midiOutUnprepareHeader(midi_output, &slot->header,
                                             sizeof(slot->header));
                slot->prepared = 0;
            }
        }
        (void)midiOutClose(midi_output);
        midi_output = NULL;
    }
#endif
    midi_custom_active = 0;
    midi_ready = 0;
    midi_parser_reset();
}

int sound_services_midi_ready(void)
{
    return midi_ready != 0;
}

int sound_services_midi_byte(uint8_t value)
{
    if (!midi_ready) return 0;
    if (midi_custom_active)
        return midi_custom_sink != NULL &&
               midi_custom_sink(midi_custom_userdata, value) != 0;

#if defined(_WIN32)
    if (value >= 0xF8u) return midi_send_short(value, 0, 0);
    if (midi_in_sysex) {
        if (value >= 0x80u && value != 0xF7u) {
            midi_in_sysex = 0;
            midi_sysex_length = 0;
        } else {
            if (midi_sysex_length == sizeof(midi_sysex)) {
                midi_in_sysex = 0;
                midi_sysex_length = 0;
                return 0;
            }
            midi_sysex[midi_sysex_length++] = value;
            if (value == 0xF7u) {
                int result = midi_send_sysex(midi_sysex, midi_sysex_length);
                midi_in_sysex = 0;
                midi_sysex_length = 0;
                return result;
            }
            return 1;
        }
    }

    if ((value & 0x80u) != 0) {
        midi_data_count = 0;
        if (value == 0xF0u) {
            midi_running_status = 0;
            midi_status = 0;
            midi_in_sysex = 1;
            midi_sysex_length = 0;
            midi_sysex[midi_sysex_length++] = value;
            return 1;
        }
        if (value < 0xF0u) {
            midi_running_status = value;
            midi_status = value;
            midi_data_needed = ((value & 0xE0u) == 0xC0u) ? 1u : 2u;
            return 1;
        }
        midi_running_status = 0;
        midi_status = value;
        if (value == 0xF1u || value == 0xF3u) midi_data_needed = 1;
        else if (value == 0xF2u) midi_data_needed = 2;
        else {
            midi_data_needed = 0;
            midi_status = 0;
            if (value == 0xF6u || value == 0xF7u)
                return midi_send_short(value, 0, 0);
        }
        return 1;
    }

    if (midi_status == 0) {
        if (midi_running_status == 0) return 0;
        midi_status = midi_running_status;
        midi_data_needed = ((midi_status & 0xE0u) == 0xC0u) ? 1u : 2u;
        midi_data_count = 0;
    }
    if (midi_data_needed == 0) return 0;
    midi_data[midi_data_count++] = value;
    if (midi_data_count != midi_data_needed) return 1;
    {
        uint8_t status = midi_status;
        uint8_t first = midi_data[0];
        uint8_t second = midi_data_needed == 2 ? midi_data[1] : 0;
        int result = midi_send_short(status, first, second);
        midi_data_count = 0;
        if (status >= 0xF0u) {
            midi_status = 0;
            midi_data_needed = 0;
        } else {
            midi_status = midi_running_status;
        }
        return result;
    }
#else
    (void)value;
    return 0;
#endif
}
