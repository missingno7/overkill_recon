/* Research only: native 16-bit DOS C; no register/CPU-state model. */
typedef unsigned char u8;
typedef unsigned short u16;
typedef signed short s16;
typedef char check_u16_is_two[(sizeof(u16)==2) ? 1 : -1];
typedef struct { u16 status, y, x, field06, offset_index08; u8 other[46]; } Record;
typedef struct { u16 y, x; } Pair;
typedef struct { u16 write, read15, read31, other47; } HistoryCursors;
typedef char check_record_size[(sizeof(Record)==56) ? 1 : -1];
/* The two functions are explicit hardware primitives, provided by IO.ASM.
   They are not part of a matching delta and are included in platform costs. */
u8 io_read(u16 port);
void io_write(u16 port, u8 value);

/* Explicit results that the original string/copy ABI leaves in registers.
   Result buffers are private adapter storage, disjoint from game/source data. */
typedef struct { u16 source_offset, destination_offset, remaining, row_width; } TransferEnd;
