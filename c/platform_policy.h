/* Startup and pause policy over the original state. */
#ifndef PLATFORM_POLICY_H
#define PLATFORM_POLICY_H

#include "dos.h"

void platform_policy_enable_file_flags(byte probe_result);
void platform_policy_load_sound_module(void);
void platform_policy_show_boss_key_screen(DosRegisters *registers);
word platform_policy_checksum_file(word file_name, word caller_si);

#endif
