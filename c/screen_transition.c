/* Game-over sound/capture/clear ordering over the original DOS state.
   Native screen animation carries BP/ES explicitly; only the clear remains ASM.

   SEGMENT: CGAME
   OWNS: CollapseScreenWithSfx CollapseScreenAndClear
*/
#include "screen_transition.h"
#include "screen_animation.h"
#ifdef OVERKILL_HOST
#include "platform_services.h"
#endif

#ifndef OVERKILL_HOST
extern void ResetPageAndClearScreen(void);
#endif

void screen_transition_with_sfx(DosRegisters *registers)
{
    volatile byte *enabled = (volatile byte *)&SfxEnabled;
    volatile byte *active = (volatile byte *)&SfxActive;

    /* These are two distinct reads in the original. Sound can change between the
       optional active-effect wait and the request decision. */
    if (*enabled != 0) {
        while (*active != 0) {
#ifdef OVERKILL_HOST
            overkill_platform_idle();
#endif
        }
    }
    if (*enabled != 0) SfxRequest = 5;

    screen_animation_capture_collapse(registers);
    dos_service(ResetPageAndClearScreen, registers);
}

void screen_transition_and_clear(DosRegisters *registers)
{
    screen_animation_capture_collapse(registers);
    dos_service(ResetPageAndClearScreen, registers);
}
