#ifndef DISPLAY_H
#define DISPLAY_H
#include "dos.h"

void display_set_hiscore_rank_color(void);
void display_apply_cga_level_palette(DosRegisters *registers);
void display_apply_level_palette(DosRegisters *registers);
void display_draw_score(DosRegisters *registers);
void display_draw_level_number(DosRegisters *registers);
void display_draw_lives_icons(DosRegisters *registers);
void display_draw_hud(DosRegisters *registers);

#endif
