#ifndef SCREEN_ANIMATION_H
#define SCREEN_ANIMATION_H

#include "dos.h"

/* The original image header is read from its caller-owned far segment. This request
   lives on the C stack and carries the DOS BP/ES values through the pixel service. */
typedef struct ScreenAnimationImage {
    word source_segment;
    word source_offset;
    word destination_offset;
    word bp;
    word es;
} ScreenAnimationImage;

void screen_animation_capture_collapse(DosRegisters *registers);
void screen_animation_stretch_raw(ScreenAnimationImage *image);
void screen_animation_stretch_window(DosRegisters *registers);
void screen_animation_stretch_end(DosRegisters *registers);
void screen_animation_stretch_hud_panel(DosRegisters *registers);

#endif
