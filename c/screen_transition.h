#ifndef SCREEN_TRANSITION_H
#define SCREEN_TRANSITION_H

#include "dos.h"

void screen_transition_with_sfx(DosRegisters *registers);
void screen_transition_and_clear(DosRegisters *registers);

#endif
