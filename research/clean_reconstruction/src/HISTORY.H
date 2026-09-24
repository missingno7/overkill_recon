#ifndef HISTORY_H
#define HISTORY_H
/* Native DOS widths. The implementation also describes typed position objects;
   the oracle address/index correspondence lives exclusively in the tests. */
typedef unsigned char u8;
typedef unsigned int u16;
typedef char word_must_be_16_bits[sizeof(u16) == 2 ? 1 : -1];
#define HISTORY_COUNT 48
enum HistoryCursor { HISTORY_WRITE, HISTORY_DELAY_15, HISTORY_DELAY_31,
                     HISTORY_OTHER_47, HISTORY_CURSORS };
typedef struct { u16 y, x; } Position;
typedef struct {
    Position samples[HISTORY_COUNT];
    u16 cursor[HISTORY_CURSORS];
} History;
/* Preconditions: initialized indices; valid position objects; metadata and
   pointer-array storage disjoint from positions; no concurrent state mutation.
   Selected positions may coincide with each other, source, or a ring sample. */
void history_init(History *h, const volatile Position *source);
void history_advance(History *h, u8 input, u16 adjustment);
void history_store(History *h, const volatile Position *source);
void history_apply(History *h, volatile Position *const selected[2]);
void history_store_apply(History *h, const volatile Position *source,
                         volatile Position *const selected[2]);
void history_update(History *h, const volatile Position *source,
                    volatile Position *const selected[2], u8 input,
                    u16 adjustment);
#endif
