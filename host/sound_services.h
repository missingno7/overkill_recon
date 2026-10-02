#ifndef OVERKILL_HOST_SOUND_SERVICES_H
#define OVERKILL_HOST_SOUND_SERVICES_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* SDL3 PCM output for the DOS sound hardware contracts. The sequencers and the game
   report chip writes; this layer timestamps them and renders their audio. */
int sound_services_start(void);
/* Deterministic headless mode uses the same event queue and chip backends but
   advances and renders only as the guest clock moves. */
int sound_services_start_offline(uint32_t sample_rate);
void sound_services_advance_ns(uint64_t guest_time_ns);
typedef void (*SoundOfflinePcmSink)(void *userdata, const float *stereo,
                                    size_t frames);
void sound_services_bind_offline_pcm_sink(SoundOfflinePcmSink sink, void *userdata);
void sound_services_shutdown(void);

void sound_services_speaker_off(void);
void sound_services_speaker_program(uint16_t pit_divisor);
void sound_services_opl2_write(uint8_t reg, uint8_t value);
void sound_services_tandy_psg_write(uint8_t value);
uint32_t sound_services_dropped_events(void);
void sound_services_music_request(uint8_t tune);
void sound_services_wait_ticks(uint16_t ticks);

typedef int (*SoundMidiByteSink)(void *userdata, uint8_t value);
void sound_services_midi_bind_sink(SoundMidiByteSink sink, void *userdata);
int sound_services_midi_start(void);
void sound_services_midi_shutdown(void);
int sound_services_midi_ready(void);
int sound_services_midi_byte(uint8_t value);

#ifdef __cplusplus
}
#endif

#endif
