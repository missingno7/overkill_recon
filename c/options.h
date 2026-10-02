#ifndef OPTIONS_H
#define OPTIONS_H
#include "game.h"
void run_options_menu(void);
void read_choose_screen_input(void);
void menu_call_platform(main_routine target);
void menu_call_si(main_routine target, word value);
#ifndef OVERKILL_HOST
#pragma aux menu_call_si "FarCallMainNearViaAX" far parm [ax] [si] modify exact [ax bx cx dx si di es]
#endif
#endif
