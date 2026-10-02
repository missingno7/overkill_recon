/* C view of the game state for the DOS hybrid (Watcom C16, small model, DS = SS = the
   game's state segment). Constants, the record layout and every state-segment label come
   from GAME_GEN.H, generated from the oracle's include files and src/DATA.ASM.

   Calling convention for all C code: names upper-cased to match TASM's publics (no
   prefix; keep C names distinct from ASM labels, e.g. snake_case), arguments in SI then
   DI, result in AX, every other register preserved. each region's bridge c/<region>.asm adapts the oracle's
   register contracts (BP = record, results in flags) to it. C owns no static data and
   uses no `static` (TLINK 2.0 rejects local symbols); tools/hybrid.py checks both. */
#ifndef GAME_H
#define GAME_H

#ifdef OVERKILL_HOST
#define __near
#define __far
#else
#pragma aux default "^" parm [si] [di] value [ax] modify exact [ax]
#endif
#pragma pack(1)
#include "GAME_GEN.H"
#pragma pack()

#ifdef OVERKILL_HOST
#include "HOST_GEN.H"
#endif

/* Stored DS links remain 16-bit offsets on both platforms. Convert only at the
   point of access; host pointers are never stored in original records or tables. */
#ifdef OVERKILL_HOST
word overkill_ds_offset(const void *pointer);
#define GAME_PTR(type, offset) ((type *)overkill_ds_address((word)(offset)))
#define GAME_OFFSET(pointer) overkill_ds_offset(pointer)
/* A demo can address a pod through the unchecked FFFFh slot. Its nonzero field
   offsets wrap into low DS rather than extending a native record past the window. */
#define GAME_RECORD_FIELD(record, field) \
    (*GAME_PTR(word, GAME_OFFSET(record) + offsetof(Record, field)))
#else
#define GAME_PTR(type, offset) ((type *)(word)(offset))
#define GAME_OFFSET(pointer) ((word)(pointer))
#define GAME_RECORD_FIELD(record, field) ((record)->field)
#endif
#define NO_RECORD GAME_PTR(Record, 0xFFFF)
#define GAME_INDEX(type, pointer, index) \
    (*GAME_PTR(type, GAME_OFFSET(pointer) + (word)((index) * sizeof(type))))

/* Calls from C (segment CGAME) into ASM that stays in MAIN go through the oracle's own
   trampoline FarCallMainNearViaAX (AX = near target; every other register and the flags
   pass through). Declare one pragma per register contract, e.g.
     word call_main_bx(main_routine target);
     #pragma aux call_main_bx "FarCallMainNearViaAX" far parm [ax] value [bx] modify exact [ax bx]
   and for routines taking BP (Watcom cannot pass BP):
     void call_main_bp(main_routine target, Record *r);
     #pragma aux call_main_bp = "push bp" "mov bp, si" "call far ptr FarCallMainNearViaAX" \
         "pop bp" parm [ax] [si] modify exact [ax bx cx dx di es]
   then call_main_bx(NextRandomWord). The callee must not take input in AX. */
#ifdef OVERKILL_HOST
typedef word main_routine;
#else
typedef void (__near *main_routine)(void);
extern void __far FarCallMainNearViaAX(void);
#endif

/* Typed views of the record storage (declared as bytes in DATA.ASM). */
#define PRIMARY ((Record *)PrimaryRecord)
#define POOL_A ((Record *)PoolA)
#define POOL_B ((Record *)PoolB)

#endif
