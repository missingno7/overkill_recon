#include "TYPES.H"

u8 upper_ascii(u8 ch)
{
    if (ch >= 'a' && ch <= 'z') ch = (u8)(ch & 0xdf);
    return ch;
}

u8 lower_ascii(u8 ch)
{
    if (ch >= 'A' && ch <= 'Z') ch = (u8)(ch | 0x20);
    return ch;
}

void dec_y(Record far *r)
{
    if (r->y != 0x20) --r->y;
}

void inc_y(Record far *r)
{
    if (r->y != 0xc0) ++r->y;
}

void dec_x(Record far *r)
{
    if (r->x != 0) --r->x;
}

void inc_x(Record far *r)
{
    if (r->x < 0xb0) ++r->x;
}

void copy_position(Record far *dst, const Record far *src)
{
    dst->x = (u16)(src->x + 10);
    dst->y = (u16)(src->y + 10);
}

/* DF=0 case; forward ordered mutation and copying, including overlap. */
void xor_copy(u8 far *dst, u8 far *src, TransferEnd far *end)
{
    u16 i;
    for (i=0; i<16; ++i) {
        *src ^= 0xaa;
        *dst++ = *src++;
    }
    end->source_offset=(u16)src;
    end->destination_offset=(u16)dst;
    end->remaining=0;
    end->row_width=16;
}

/* Native near offsets preserve the original pool layout and cursor contents.
   cursor starts on a valid one of the35 records. remaining models CX output. */
u16 find_free(u16 near *cursor, u16 near *remaining)
{
    Record near *slot = (Record near *)*cursor;
    u16 left;
    for (left=35; left!=0; --left) {
        if (slot->status == 0) {
            *cursor = (u16)slot;
            *remaining = left;
            return (u16)slot;
        }
        ++slot;
        if (slot == (Record near *)0x2b5c) slot = (Record near *)0x23b4;
    }
    *remaining = 0;
    return 0xffff;
}

void advance_history(HistoryCursors far *c, u8 input, u16 adjustment)
{
    if (!(input & 15) && !adjustment) return;
    c->write += 4; if (c->write == 0xa33a) c->write = 0xa27a;
    c->read15 += 4; if (c->read15 == 0xa33a) c->read15 = 0xa27a;
    c->read31 += 4; if (c->read31 == 0xa33a) c->read31 = 0xa27a;
    c->other47 += 4; if (c->other47 == 0xa33a) c->other47 = 0xa27a;
}

u16 store_history(Pair far *dst, const Record far *src, u16 far *next_offset)
{
    dst->y = (u16)(src->y + 8);
    dst->x = (u16)(src->x + 8);
    *next_offset=(u16)(dst+1);
    return dst->x;
}

/* FFFF destination offset is the original absence sentinel. Word+8 is an index only
   in this use. Valid table entry and nonaliasing state are required. */
void place_pair(Record far *dst, const Record far *src,
                const Pair far *table, u16 extra_x, u8 far *clamps)
{
    u16 raw_x;
    const Pair far *pair;
    if ((u16)dst == 0xffff) return;
    pair = table + src->offset_index08;
    dst->y = (u16)(pair->y + src->y);
    raw_x = (u16)(pair->x + src->x + extra_x + extra_x);
    dst->x = raw_x;
    if ((s16)dst->x < 0) { dst->x=0; clamps[0]=1; }
    if ((s16)dst->x > 192) { dst->x=192; clamps[1]=1; }
}

/* Closed routine + shared-tail operation; no return-address tricks in C. */
void dec_x_twice(Record far *r)
{
    if (r->x != 0) --r->x;
    if (r->x != 0) --r->x;
}

/* Packed Tandy rows: DF=0, positive rows/width; valid nonoverlapping buffers.
   Header words give rows and four-byte width units. */
void tandy_copy(u8 far *display, const u16 far *header, u16 offset,
                TransferEnd far *end)
{
    u16 rows=header[0], width=(u16)(header[1]*4), x;
    const u8 far *src=(const u8 far *)(header+2);
    do {
        for (x=0; x<width; ++x) display[(u16)(offset+x)] = *src++;
        offset = (u16)(offset+0x2000);
        if (offset & 0x8000) offset = (u16)(offset+0x80a0);
    } while (--rows);
    end->source_offset=(u16)src;
    end->destination_offset=offset;
    end->remaining=rows;
    end->row_width=width;
}

u8 opl_status(u16 base_port)
{
    return io_read(base_port);
}

/* Compare scripted port-event behavior only, not wall-clock delay duration. */
void pit_delay(s16 threshold)
{
    u16 value=0x1fff;
    u8 low, high;
    io_write(0x43,0xb6);
    io_write(0x61,(u8)(io_read(0x61)|3));
    do {
        io_write(0x42,(u8)value); io_write(0x42,(u8)(value>>8));
        io_write(0x43,0x86); io_write(0x43,0xb6);
        low=io_read(0x42); high=io_read(0x42);
        value=(u16)(low | ((u16)high<<8));
    } while ((s16)value > threshold);
    io_write(0x61,(u8)(io_read(0x61)&0xfe));
}
