/* DOS control APIs with explicit renderer register metadata. */
#ifndef SYSTEM_CONTROL_H
#define SYSTEM_CONTROL_H

#include "dos.h"

void system_check_boss_key(DosRegisters *registers);
void system_redraw_after_boss_key(DosRegisters *registers);
void system_redraw_status_panel(DosRegisters *registers);
void system_prompt_load_error_wait_fire(DosRegisters *registers);
void system_wait_all_keys_released(void);
void system_wait_input_released(void);
void system_wait_input_pressed(void);
void system_wait_input_click(void);

#endif
