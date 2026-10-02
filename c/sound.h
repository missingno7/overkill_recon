/* C sound-stream control; hardware and module calls remain DOS services. */
#ifndef SOUND_H
#define SOUND_H

#include "game.h"

void sound_sfx_tick(void);
void sound_sfx_start_request(void);
void sound_sfx_voice_tick(byte *voice);
void sound_sfx_stream_next_byte(byte *voice, word cursor);
void sound_sfx_store_and_wait(byte *voice, word cursor);
void sound_sfx_stop_all(void);
void sound_sfx_command_rest(byte *voice, word cursor);
void sound_sfx_command_step_down(byte *voice, word cursor);
void sound_sfx_command_step_up(byte *voice, word cursor);
void sound_sfx_command_slide(byte *voice, word cursor);

void sound_request_module_music(word input_ax);
word sound_stop_module_music(word input_ax);

#endif
