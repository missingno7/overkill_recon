/* Native DOS semantic body, without register/CPU state or matching recipes.
   Each read follows earlier stores: aliased views must not be snapshotted.
   DS addresses records/cursors/selections. Source and write buffer may use other
   segments. DF=0, as established by startup, is the pair traversal contract. */
typedef unsigned int u16;
typedef unsigned char u8;
typedef char require_word[sizeof(u16)==2 ? 1 : -1];
typedef struct { u16 status, y, x; u8 remaining[50]; } Record;
typedef struct { u16 y, x; } Position;
typedef struct { u16 write, delayed15, delayed31, other47; } Cursors;
typedef struct { u16 delayed15, delayed31; } Selections;
/* Semantic transfer progress, also sufficient for the historical ABI outputs.
   read_end/record_offset are valid only when a delayed position was applied. */
typedef struct {
    u16 last_x, write_end, record_offset, read_end, applied;
} TransferProgress;

void store_apply(volatile Position far *dst,
                 const volatile Record far *src,
                 const volatile Cursors near *cursors,
                 const volatile Selections near *selections,
                 TransferProgress far *progress)
{
    u16 value, record_offset;
    const volatile Position near *sample;
    volatile Record near *record;

    value = (u16)(src->y + 8);
    dst->y = value;
    value = (u16)(src->x + 8);
    dst->x = value;
    progress->last_x = value;
    progress->write_end = (u16)dst + 4;
    progress->applied = 0;

    if (selections->delayed15 != 0xffff) {
        record_offset = selections->delayed15;
        record = (volatile Record near *)record_offset;
        sample = (const volatile Position near *)cursors->delayed15;
        value = sample->y;
        record->y = value;
        value = sample->x;
        record->x = value;
        progress->last_x = value;
        progress->record_offset = record_offset;
        progress->read_end = (u16)sample + 4;
        progress->applied = 1;
    }
    if (selections->delayed31 != 0xffff) {
        record_offset = selections->delayed31;
        record = (volatile Record near *)record_offset;
        sample = (const volatile Position near *)cursors->delayed31;
        value = sample->y;
        record->y = value;
        value = sample->x;
        record->x = value;
        progress->last_x = value;
        progress->record_offset = record_offset;
        progress->read_end = (u16)sample + 4;
        progress->applied = 1;
    }
}
