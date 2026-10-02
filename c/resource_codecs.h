/* Decoder results carry the original DOS entry's consumed outputs explicitly. */
#ifndef RESOURCE_CODECS_H
#define RESOURCE_CODECS_H

typedef struct PackedLoadResult {
    word failed;
    word ax;
    word output_offset;
    word started_decoder;
    word bx;
} PackedLoadResult;

typedef struct PackedDecodeResult {
    word failed;
    word error_ax;
    word output_offset;
} PackedDecodeResult;

typedef struct EncFileResult {
    word failed;
    word ax;
    word si;
    word di;
    word flags;
    word bp;
} EncFileResult;

word packed_decode_byte_rle(PackedDecodeResult *result, word entry_bx, word entry_ax);
#ifndef OVERKILL_HOST
#pragma aux packed_decode_byte_rle parm [si] [bx] [cx] value [ax] modify exact [ax]
#endif
word packed_decode_word_rle(PackedDecodeResult *result, word entry_bx, word entry_ax);
#ifndef OVERKILL_HOST
#pragma aux packed_decode_word_rle parm [si] [bx] [cx] value [ax] modify exact [ax]
#endif
word packed_decode_dword_rle(PackedDecodeResult *result, word entry_bx, word entry_ax);
#ifndef OVERKILL_HOST
#pragma aux packed_decode_dword_rle parm [si] [bx] [cx] value [ax] modify exact [ax]
#endif
word packed_decode_packbits(PackedDecodeResult *result, word entry_bx, word entry_ax);
#ifndef OVERKILL_HOST
#pragma aux packed_decode_packbits parm [si] [bx] [cx] value [ax] modify exact [ax]
#endif
word packed_decode_column_packbits(PackedDecodeResult *result, word entry_bx, word entry_ax);
#ifndef OVERKILL_HOST
#pragma aux packed_decode_column_packbits parm [si] [bx] [cx] value [ax] modify exact [ax]
#endif
void packed_load_file(PackedLoadResult *result, word entry_bx);
#ifndef OVERKILL_HOST
#pragma aux packed_load_file parm [si] [bx] modify exact [ax bx cx dx di es]
#endif
void enc_decode_file(EncFileResult *result);
dword enc_decode_stream(word *ring_write_result);
#ifndef OVERKILL_HOST
#pragma aux enc_decode_stream parm [si] value [dx ax] modify exact [ax dx]
#endif

#endif
