/* C view of the game state for the DOS hybrid (Watcom C16, small model, DS = SS = the
   game's state segment). Constants, the record layout and every state-segment label come
   from GAME_GEN.H, generated from the oracle's include files and src/DATA.ASM.

   Calling convention for all C code: names upper-cased to match TASM's publics (no
   prefix; keep C names distinct from ASM labels, e.g. snake_case), arguments in SI then
   DI, result in AX, every other register preserved. c/BRIDGE.ASM adapts the oracle's
   register contracts (BP = record, results in flags) to it. C owns no static data and
   uses no `static` (TLINK 2.0 rejects local symbols); tools/hybrid.py checks both. */
#ifndef GAME_H
#define GAME_H

#pragma aux default "^" parm [si] [di] value [ax] modify exact [ax]
#pragma pack(1)
#include "GAME_GEN.H"
#pragma pack()

/* Typed views of the record storage (declared as bytes in DATA.ASM). */
#define PRIMARY ((Record *)PrimaryRecord)
#define POOL_A ((Record *)PoolA)
#define POOL_B ((Record *)PoolB)

#endif
