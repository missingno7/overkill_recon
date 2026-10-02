#ifndef PAYMENT_TEXT_H
#define PAYMENT_TEXT_H

#include "dos.h"

void payment_show_text(DosRegisters *registers);
void payment_scroll_up(void *registers);
void payment_scroll_down(void *registers);

#endif
