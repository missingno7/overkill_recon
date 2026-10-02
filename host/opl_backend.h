#ifndef OVERKILL_HOST_OPL_BACKEND_H
#define OVERKILL_HOST_OPL_BACKEND_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Returns nonzero after initializing the OPL2-compatible core at sample_rate. */
int opl_backend_init(uint32_t sample_rate);

/* Reset register, oscillator, envelope, and buffered-write state at the active rate. */
void opl_backend_reset(void);

/* Apply one OPL2 register write. Writes take effect through the core's hardware delay. */
void opl_backend_write(uint8_t reg, uint8_t value);

/* Render signed, interleaved stereo PCM using the core's OPL2-compatible output lanes. */
void opl_backend_render(int16_t *stereo_interleaved, size_t frames);

#ifdef __cplusplus
}
#endif

#endif
