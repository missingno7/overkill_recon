#ifndef OVERKILL_HOST_ROLAND_SEQUENCE_H
#define OVERKILL_HOST_ROLAND_SEQUENCE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Bind the loaded ROLAND module image. Mutable request, tune, and channel state
   remains in that image; the caller retains ownership of the segment storage. */
int roland_sequence_bind(uint8_t *module_segment, size_t bytes);
void roland_sequence_unbind(void);

/* Replace MPU-401 probing with native MIDI sink readiness and send the module's
   MT-32 setup SysEx blocks through the MIDI byte service. */
int roland_sequence_initialize(void);

/* Equivalent to the game's word write at module offset +8. */
void roland_sequence_request(uint8_t tune);

/* One original MusicTick entry at the DOS timer's module-tick boundary. */
void roland_sequence_tick(void);

#ifdef __cplusplus
}
#endif

#endif
