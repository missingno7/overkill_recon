/* Binary launcher arguments and the pre-startup high-score override policy.
   The PSP is caller-owned DOS memory; only its three consumed bytes are read.
   SEGMENT: CGAME
   OWNS: ProgramEntry
*/
#include "launcher.h"
#include "settings.h"
#include "startup.h"

extern volatile word __far VideoAdapter;
extern byte __far LauncherOverrideMask;

#define LAUNCHER_PSP_AT(segment, offset) \
    ((volatile byte __far *)((__segment)(segment) :> ((byte __based(void) *)(offset))))

void launcher_after_prologue(word psp_segment, DosRegisters *registers)
{
    volatile byte __far *psp = LAUNCHER_PSP_AT(psp_segment, PSP_COMMAND_TAIL);
    byte mask, video, sound;
    dword load_result;

    /* The DOS command-tail length byte is intentionally ignored: the executable
       reads three binary launcher bytes even when the PSP reports a shorter tail. */
    mask = psp[1];
    video = psp[2];
    sound = psp[3];
    LauncherOverrideMask = mask;

    if (video > VIDEO_TANDY) video = 1;
    VideoAdapter = video;
    SoundModuleSelect = sound;

    load_result = load_hiscore_file(registers->es);
    registers->es = (word)(load_result >> 16);

    /* Only these exact launcher masks opt out of saved settings. Partial masks
       and all other values leave the high-score settings in force. */
    if (mask == LAUNCHER_OVERRIDE_VIDEO || mask == LAUNCHER_OVERRIDE_SOUND ||
        mask == LAUNCHER_OVERRIDE_BOTH) {
        if ((mask & LAUNCHER_OVERRIDE_VIDEO) != 0)
            apply_launcher_video_override(video);
        if ((mask & LAUNCHER_OVERRIDE_SOUND) != 0)
            apply_launcher_sound_override(sound);
    }

    startup_after_overrides(registers);
}
