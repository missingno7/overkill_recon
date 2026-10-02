#include "opl_backend.h"

#include "../third_party/nuked_opl3/opl3.h"

#include <limits.h>
#include <string.h>

enum { OPL_NATIVE_RATE = 49716, OPL_RESAMPLER_FRAC_BITS = 10 };

static opl3_chip opl_chip;
static uint32_t opl_sample_rate;
static int opl_initialized;

static int opl_rate_supported(uint32_t sample_rate)
{
    uint64_t ratio;

    /* The upstream core stores this left-shifted ratio in a signed 32-bit field. */
    if (sample_rate == 0 || sample_rate > (UINT32_MAX >> OPL_RESAMPLER_FRAC_BITS))
        return 0;
    ratio = ((uint64_t)sample_rate << OPL_RESAMPLER_FRAC_BITS) / OPL_NATIVE_RATE;
    return ratio != 0 && ratio <= INT32_MAX;
}

static void opl_reset_chip(void)
{
    OPL3_Reset(&opl_chip, opl_sample_rate);

    /* The DOS caller uses the 9-channel OPL2 register bank. Keep the YMF262 core
       in OPL2-compatible mode and retain its native channel pipeline timing. */
    OPL3_WriteReg(&opl_chip, 0x105, 0);
}

int opl_backend_init(uint32_t sample_rate)
{
    if (!opl_rate_supported(sample_rate)) {
        opl_sample_rate = 0;
        opl_initialized = 0;
        return 0;
    }

    opl_sample_rate = sample_rate;
    opl_reset_chip();
    opl_initialized = 1;
    return 1;
}

void opl_backend_reset(void)
{
    if (!opl_initialized)
        return;
    opl_reset_chip();
}

void opl_backend_write(uint8_t reg, uint8_t value)
{
    if (!opl_initialized)
        return;
    OPL3_WriteRegBuffered(&opl_chip, reg, value);
}

void opl_backend_render(int16_t *stereo_interleaved, size_t frames)
{
    if (stereo_interleaved == NULL || frames == 0)
        return;

    if (!opl_initialized) {
        memset(stereo_interleaved, 0, frames * 2 * sizeof(*stereo_interleaved));
        return;
    }

    while (frames != 0) {
        uint32_t block_frames = frames > UINT32_MAX ? UINT32_MAX : (uint32_t)frames;
        OPL3_GenerateStream(&opl_chip, stereo_interleaved, block_frames);
        stereo_interleaved += (size_t)block_frames * 2;
        frames -= block_frames;
    }
}
