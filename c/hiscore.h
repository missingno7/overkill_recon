#ifndef HISCORE_H
#define HISCORE_H
#include "game.h"
#include "dos.h"
void insert_high_score(byte *score);
void update_high_score_table(void);
void hiscore_show_entry_prompt(DosRegisters *registers);
word hiscore_read_name_key(DosRegisters *registers);
#endif
