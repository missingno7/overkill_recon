#ifndef PRESENTATION_H
#define PRESENTATION_H
#include "dos.h"

void run_intro_pages_and_demo(void);
void run_choose_screen(DosRegisters *registers);
void draw_choose_screen(DosRegisters *registers);
void show_level_intro(DosRegisters *registers);
void draw_plaque_image(DosRegisters *registers);

#endif
