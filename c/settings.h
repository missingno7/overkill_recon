#ifndef SETTINGS_H
#define SETTINGS_H
#include "game.h"
void save_settings_to_hiscore_block(word video);
word load_settings_from_hiscore_block(void);
word xor_code_hiscore_block(void);
void save_hiscore_file(void);
dword load_hiscore_file(word es);
#pragma aux load_hiscore_file parm [si] value [dx ax] modify exact [ax dx]
void apply_launcher_sound_override(word module);
void apply_launcher_video_override(word adapter);
#endif
