/* Complete semantics; native 16-bit Turbo C. volatile preserves store ordering. */
typedef unsigned char u8;
typedef unsigned int u16;
typedef char require_16_bit_unsigned_int[sizeof(u16)==2 ? 1 : -1];
typedef struct {
    u16 write, delayed15, delayed31, other47;
} HistoryCursors;

void advance_history(volatile HistoryCursors far *c, u8 input, u16 adjustment)
{
    if (!(input & 15) && !adjustment) return;
    c->write += 4;
    if (c->write == 0xa33a) c->write = 0xa27a;
    c->delayed15 += 4;
    if (c->delayed15 == 0xa33a) c->delayed15 = 0xa27a;
    c->delayed31 += 4;
    if (c->delayed31 == 0xa33a) c->delayed31 = 0xa27a;
    c->other47 += 4;
    if (c->other47 == 0xa33a) c->other47 = 0xa27a;
}
