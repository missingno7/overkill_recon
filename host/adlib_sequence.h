#ifndef OVERKILL_HOST_ADLIB_SEQUENCE_H
#define OVERKILL_HOST_ADLIB_SEQUENCE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Bind the loaded ADLIB module image. The image remains owned by the caller and
   contains the module's live voice records, request bytes, instruments and streams. */
int adlib_sequence_bind(uint8_t *module_segment, size_t bytes);
void adlib_sequence_unbind(void);

/* Equivalent to the game's word write at module offset +8: request=tune,
   current=0. */
void adlib_sequence_request(uint8_t tune);

/* One original MusicTick entry, at the DOS timer's module-tick boundary. */
void adlib_sequence_tick(void);

#ifdef __cplusplus
}
#endif

#endif
