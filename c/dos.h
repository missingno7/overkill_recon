#ifndef DOS_H
#define DOS_H
#include "game.h"

/* ABI registers only: inherited BP and ES can be consumed or changed by DOS
   presentation services. This carries them across C calls without shadow state. */
typedef struct DosRegisters { word bp, es; } DosRegisters;
void dos_service(main_routine target, DosRegisters *registers);
word dos_read_es(void);
#pragma aux dos_read_es = "mov ax, es" value [ax] modify exact [ax]
#endif
