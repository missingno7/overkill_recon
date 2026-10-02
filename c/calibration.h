#ifndef CALIBRATION_H
#define CALIBRATION_H
#include "dos.h"
word poll_joystick_primary_or_abort(void);
void wait_joystick_primary_release(void);
word calibrate_joystick_thresholds(DosRegisters *registers);
void calibrate_joystick_with_abort(DosRegisters *registers);
#endif
