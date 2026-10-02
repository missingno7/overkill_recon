#ifndef PAGES_H
#define PAGES_H
#include "dos.h"
void show_page_list(word list, DosRegisters *registers);
void show_high_score_table(DosRegisters *registers);
void show_pages(word list);
void show_scores(void);
#endif
