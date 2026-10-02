/* Startup and pause policy over the original state. */
#ifndef PLATFORM_POLICY_H
#define PLATFORM_POLICY_H

#include "dos.h"

void platform_policy_enable_file_flags(byte probe_result);
void platform_policy_load_sound_module(void);
void platform_policy_show_boss_key_screen(DosRegisters *registers);
/* Packed as final read-window SI in the high word and DOS free result in AX. */
dword platform_policy_checksum_file(word file_name, word caller_si);
#ifndef OVERKILL_HOST
#pragma aux platform_policy_checksum_file parm [si] [di] value [dx ax] \
    modify exact [ax dx]
#endif

#endif
