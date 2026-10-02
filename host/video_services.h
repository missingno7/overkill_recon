#ifndef OVERKILL_HOST_VIDEO_SERVICES_H
#define OVERKILL_HOST_VIDEO_SERVICES_H

#include "platform_services.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Native handlers for the original DOS video routines and geometry setup. */
int overkill_video_service(word token, HostRegisters *registers);

/* The runtime presents this segment after cooperative idle points. On EGA it is
   the page selected by ShowEgaDrawPage, which may differ from the current draw page. */
word overkill_video_presented_segment(void);

/* Native leaves replacing the pixel-only parts of DrawMapRowIntoScrollBand and
   SetDacColor6; map-row spawning and non-EGA palette behavior stay in c/frame.c. */
void host_draw_map_row_into_scroll_band(word map_row_offset);
void host_set_dac_color6(const byte rgb[3]);

/* Release the video-owned DOS blocks when the native game instance is torn down. */
void overkill_video_services_shutdown(void);

#ifdef __cplusplus
}
#endif

#endif
