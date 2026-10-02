/* Packed-file and ENC decoder control over the original buffers and counters.
   SEGMENT: CGAME
   OWNS: LoadPackedFile DecodeByteEscapeRle DecodeWordEscapeRle DecodeDwordEscapeRle
   OWNS: DecodePackBitsStream DecodeColumnPackBits DecodeEncStream DecodeEncFile
   OWNS: StoreEncByte PushBackEncByte

   These replace the existing decoder bodies, not their file services. They consume the
   original CS buffers through MAIN refill helpers, write the original output destination
   through far segment:offset pointers, and update the existing CS counters and ENC ring.
   There are no length checks, output limits, or persistent C data. The local read state
   mirrors the original BX and AH values because ReadBufferedByte stores BX in
   PackedSavedBx and preserves AH unless DOS refill changes it. */

#include "game.h"
#include "archive.h"
#include "resource_codecs.h"

#define CODEC_FAR_PTR(type, segment, offset) \
    ((volatile type __far *)((((dword)(word)(segment)) << 16) | (word)(offset)))

extern volatile word __far PackedDestSegment;
extern volatile word __far PackedDestOffset;
extern volatile word __far PackedOutputBytes;
extern volatile word __far PackedOpenFailed;
extern word __far MainDataSegment;
extern volatile word __far PackedFileHandle;
extern volatile word __far PackedNamePtr;
extern volatile word __far PackedColumnHeader0;
extern volatile word __far PackedColumnWidth;
extern volatile word __far PackedColumnHeader2;
extern volatile byte __far EncRingBuffer[];
extern volatile word __far EncDestOffset;
extern volatile word __far EncDestSegment;
extern volatile word __far EncOutputBytes;
extern volatile word __far EncOutputBytesHigh;
extern volatile byte __far EncPushback;
extern volatile byte __far EncPushedByte;

extern void __near PackedReadByteService(void);
extern void __near PackedReadWordService(void);
extern void __near EncReadByteService(void);
extern void __near PackedCloseService(void);
extern void __near PackedCloseAfterFailureService(void);
extern void __near EncInitialReadService(void);
extern void __near EncCloseService(void);

dword codec_call_packed_byte(main_routine target, word bx_state,
                             word output_offset, word ax_high);
#pragma aux codec_call_packed_byte "FarCallMainNearViaAX" far parm [ax] [bx] [di] [cx] value [dx ax] modify exact [ax dx es]

dword codec_call_packed_word(main_routine target, word bx_state,
                             word output_offset, word ax_high);
#pragma aux codec_call_packed_word "FarCallMainNearViaAX" far parm [ax] [bx] [di] [cx] value [dx ax] modify exact [ax dx es]

dword codec_call_packed_close(main_routine target);
#pragma aux codec_call_packed_close "FarCallMainNearViaAX" far parm [ax] value [dx ax] modify exact [ax bx dx]

word codec_call_packed_close_after_failure(main_routine target, word error_ax);
#pragma aux codec_call_packed_close_after_failure "FarCallMainNearViaAX" far parm [ax] [cx] value [ax] modify exact [ax bx]

dword codec_call_enc_initial_read(main_routine target);
#pragma aux codec_call_enc_initial_read "FarCallMainNearViaAX" far parm [ax] value [dx ax] modify exact [ax bx cx dx]

dword codec_call_enc_close(main_routine target);
#pragma aux codec_call_enc_close "FarCallMainNearViaAX" far parm [ax] value [dx ax] modify exact [ax bx dx]

word codec_call_enc_byte(main_routine target, word *input_position, word output_segment);
#pragma aux codec_call_enc_byte "FarCallMainNearViaAX" far parm [ax] [di] [cx] value [ax] modify exact [ax si es]

typedef struct PackedReadState {
    word bx;
    word ax_high;
    word failed;
    word error_ax;
} PackedReadState;

typedef struct EncOutputCursor {
    word offset;
    word segment;
} EncOutputCursor;

void store_enc_byte(EncOutputCursor *cursor, word value);
void push_back_enc_byte(word value);

/* The tiny reader leaves receive physical BX and DI as the old decoder would. On a
   normal return, AH is also fed back into the next read; a DOS refill can replace it. */
word codec_packed_byte(PackedReadState *state, word output_offset);
#pragma aux codec_packed_byte parm [si] [di] value [ax] modify exact [ax]

word codec_packed_byte(PackedReadState *state, word output_offset)
{
    dword result = codec_call_packed_byte(PackedReadByteService, state->bx,
                                          output_offset, state->ax_high);
    word value = (word)result;
    if ((word)(result >> 16) != 0) {
        state->failed = 1;
        state->error_ax = value;
    } else {
        state->ax_high = value >> 8;
    }
    return value;
}

word codec_packed_word(PackedReadState *state, word output_offset);
#pragma aux codec_packed_word parm [si] [di] value [ax] modify exact [ax]

word codec_packed_word(PackedReadState *state, word output_offset)
{
    dword result = codec_call_packed_word(PackedReadWordService, state->bx,
                                          output_offset, state->ax_high);
    word value = (word)result;
    if ((word)(result >> 16) != 0) {
        state->failed = 1;
        state->error_ax = value;
    } else {
        state->ax_high = value >> 8;
    }
    return value;
}

#define PACKED_RETURN(input, result, cursor) \
    do { \
        (result)->failed = (input)->failed; \
        (result)->error_ax = (input)->error_ax; \
        (result)->output_offset = (cursor); \
        return (cursor); \
    } while (0)

void codec_store_packed_byte(word segment, word offset, word value)
{
    *CODEC_FAR_PTR(byte, segment, offset) = (byte)value;
}

void codec_store_packed_word(word segment, word offset, word value)
{
    *CODEC_FAR_PTR(word, segment, offset) = value;
}

void store_enc_byte(EncOutputCursor *cursor, word value)
{
    *CODEC_FAR_PTR(byte, cursor->segment, cursor->offset) = (byte)value;
    cursor->offset++;
    if (cursor->offset == 0) cursor->segment = (word)(cursor->segment + 0x1000);
    EncOutputBytes = (word)(EncOutputBytes + 1);
    if (EncOutputBytes == 0) EncOutputBytesHigh++;
}

void push_back_enc_byte(word value)
{
    EncPushback = 1;
    EncPushedByte = (byte)value;
}

void packed_load_file(PackedLoadResult *result, word entry_bx)
{
    dword opened;
    dword header;
    dword closed;
    PackedReadState input;
    PackedDecodeResult decoded_result;
    word mode, entry_ax, error_ax, output, open_bx;

    (void)entry_bx; /* The open result, not the entry state, seeds the reader's BX. */

    result->failed = 0;
    result->ax = 0;
    result->output_offset = 0;
    result->started_decoder = 0;
    result->bx = 0;

    PackedOpenFailed = 1;
    opened = archive_open_by_name(PackedNamePtr);
    if ((word)(opened >> 16) != 0) {
        result->failed = 1;
        result->ax = (word)opened;
        result->bx = MainDataSegment;
        return;
    }

    PackedOpenFailed = 0;
    PackedFileHandle = (word)opened;
    open_bx = (word)opened;
    input.bx = open_bx;
    input.ax_high = (word)(opened >> 8);
    input.failed = 0;
    input.error_ax = 0;
    header = codec_call_packed_byte(PackedReadByteService, input.bx,
                                    PackedDestOffset, input.ax_high);
    if ((word)(header >> 16) != 0) {
        error_ax = (word)header;
        result->failed = 1;
        result->ax = codec_call_packed_close_after_failure(
            PackedCloseAfterFailureService, error_ax);
        result->bx = MainDataSegment;
        return;
    }

    mode = (byte)header;
    entry_ax = (word)header;
    if (mode == 0) packed_decode_byte_rle(&decoded_result, input.bx, entry_ax);
    else if (mode == 1) packed_decode_word_rle(&decoded_result, input.bx, entry_ax);
    else if (mode == 2) packed_decode_dword_rle(&decoded_result, input.bx, entry_ax);
    else if (mode == 3) packed_decode_packbits(&decoded_result, input.bx, entry_ax);
    else if (mode == 4) packed_decode_column_packbits(&decoded_result, input.bx, entry_ax);
    else {
        result->failed = 1;
        result->ax = codec_call_packed_close_after_failure(
            PackedCloseAfterFailureService, 0xFFFF);
        result->bx = MainDataSegment;
        return;
    }

    result->started_decoder = 1;
    output = decoded_result.output_offset;
    result->output_offset = output;
    if (decoded_result.failed) {
        error_ax = decoded_result.error_ax;
        result->ax = codec_call_packed_close_after_failure(
            PackedCloseAfterFailureService, error_ax);
        result->failed = 1;
        result->bx = MainDataSegment;
        return;
    }

    closed = codec_call_packed_close(PackedCloseService);
    if ((word)(closed >> 16) != 0) {
        result->ax = codec_call_packed_close_after_failure(
            PackedCloseAfterFailureService, (word)closed);
        result->failed = 1;
        result->bx = MainDataSegment;
        return;
    }
    result->ax = (word)closed;
    result->bx = PackedFileHandle;
}

void enc_decode_file(EncFileResult *result)
{
    dword initial_read = codec_call_enc_initial_read(EncInitialReadService);
    dword cursor;
    dword closed;
    word ring_write;

    result->failed = 0;
    result->ax = (word)initial_read;
    result->si = 0;
    result->di = 0;
    result->flags = (word)(initial_read >> 16);
    result->bp = 0;
    if (result->flags & 1) {
        result->failed = 1;
        return;
    }

    cursor = enc_decode_stream(&ring_write);
    result->si = (word)(cursor >> 16);
    result->di = (word)cursor;
    result->bp = ring_write;
    closed = codec_call_enc_close(EncCloseService);
    result->ax = (word)closed;
    /* DecodeEncFile ignores the close error but forces only CF clear. */
    result->flags = (word)(closed >> 16) & 0xFFFE;
}

word packed_decode_byte_rle(PackedDecodeResult *result, word entry_bx, word entry_ax);

word packed_decode_byte_rle(PackedDecodeResult *result, word entry_bx, word entry_ax)
{
    PackedReadState input;
    word segment = PackedDestSegment;
    word output = PackedDestOffset;
    word escape, token, count, value;

    input.bx = entry_bx;
    input.ax_high = entry_ax >> 8;
    input.failed = 0;
    input.error_ax = 0;
    escape = (byte)codec_packed_byte(&input, output);
    if (input.failed) PACKED_RETURN(&input, result, output);
    input.bx = (word)((input.bx & 0xFF00) | escape);

    for (;;) {
        token = (byte)codec_packed_byte(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        if (token != escape) {
            codec_store_packed_byte(segment, output, token);
            output++;
            PackedOutputBytes++;
            continue;
        }
        count = (byte)codec_packed_byte(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        if (count == 0) PACKED_RETURN(&input, result, output);
        value = (byte)codec_packed_byte(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        PackedOutputBytes = (word)(PackedOutputBytes + count);
        do {
            codec_store_packed_byte(segment, output, value);
            output++;
            count--;
        } while (count != 0);
    }
}

word packed_decode_word_rle(PackedDecodeResult *result, word entry_bx, word entry_ax);

word packed_decode_word_rle(PackedDecodeResult *result, word entry_bx, word entry_ax)
{
    PackedReadState input;
    word segment = PackedDestSegment;
    word output = PackedDestOffset;
    word escape, token, count, value;

    input.bx = entry_bx;
    input.ax_high = entry_ax >> 8;
    input.failed = 0;
    input.error_ax = 0;
    escape = codec_packed_word(&input, output);
    if (input.failed) PACKED_RETURN(&input, result, output);
    input.bx = escape;

    for (;;) {
        token = codec_packed_word(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        if (token != escape) {
            codec_store_packed_word(segment, output, token);
            output = (word)(output + 2);
            PackedOutputBytes = (word)(PackedOutputBytes + 2);
            continue;
        }
        count = codec_packed_word(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        if (count == 0) PACKED_RETURN(&input, result, output);
        value = codec_packed_word(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        PackedOutputBytes = (word)(PackedOutputBytes + count);
        PackedOutputBytes = (word)(PackedOutputBytes + count);
        do {
            codec_store_packed_word(segment, output, value);
            output = (word)(output + 2);
            count--;
        } while (count != 0);
    }
}

word packed_decode_dword_rle(PackedDecodeResult *result, word entry_bx, word entry_ax);

word packed_decode_dword_rle(PackedDecodeResult *result, word entry_bx, word entry_ax)
{
    PackedReadState input;
    word segment = PackedDestSegment;
    word output = PackedDestOffset;
    word escape, token, count, low, high;

    input.bx = entry_bx;
    input.ax_high = entry_ax >> 8;
    input.failed = 0;
    input.error_ax = 0;
    escape = codec_packed_word(&input, output);
    if (input.failed) PACKED_RETURN(&input, result, output);
    input.bx = escape;

    for (;;) {
        token = codec_packed_word(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        if (token != escape) {
            codec_store_packed_word(segment, output, token);
            output = (word)(output + 2);
            low = codec_packed_word(&input, output);
            if (input.failed) PACKED_RETURN(&input, result, output);
            codec_store_packed_word(segment, output, low);
            output = (word)(output + 2);
            PackedOutputBytes = (word)(PackedOutputBytes + 4);
            continue;
        }
        count = codec_packed_word(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        if (count == 0) PACKED_RETURN(&input, result, output);
        low = codec_packed_word(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        high = codec_packed_word(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        do {
            codec_store_packed_word(segment, output, low);
            output = (word)(output + 2);
            codec_store_packed_word(segment, output, high);
            output = (word)(output + 2);
            PackedOutputBytes = (word)(PackedOutputBytes + 4);
            count--;
        } while (count != 0);
    }
}

word packed_decode_packbits(PackedDecodeResult *result, word entry_bx, word entry_ax);

word packed_decode_packbits(PackedDecodeResult *result, word entry_bx, word entry_ax)
{
    PackedReadState input;
    word segment = PackedDestSegment;
    word output = PackedDestOffset;
    word raw, control, control_ah, count, value;

    input.bx = entry_bx;
    input.ax_high = entry_ax >> 8;
    input.failed = 0;
    input.error_ax = 0;

    for (;;) {
        raw = codec_packed_byte(&input, output);
        if (input.failed) PACKED_RETURN(&input, result, output);
        control = (byte)raw;
        control_ah = input.ax_high;
        if (control == 0x80) PACKED_RETURN(&input, result, output);
        if (control < 0x80) {
            count = (word)(control + 1);
            do {
                value = (byte)codec_packed_byte(&input, output);
                if (input.failed) PACKED_RETURN(&input, result, output);
                /* PUSH AX/POP AX leaves the control word live across this read. */
                input.ax_high = control_ah;
                codec_store_packed_byte(segment, output, value);
                output++;
                PackedOutputBytes++;
                count--;
            } while (count != 0);
        } else {
            count = (word)(257 - control);
            /* NEG AL / XCHG AH,AL / XCHG BL,AH before reading the value. */
            value = (byte)input.bx;
            input.bx = (word)((input.bx & 0xFF00) | (byte)(0 - control));
            input.ax_high = value; /* AH receives the previous BL. */
            raw = codec_packed_byte(&input, output);
            if (input.failed) PACKED_RETURN(&input, result, output);
            /* The second XCHG makes the reader's AH the new BL. */
            input.bx = (word)((input.bx & 0xFF00) | (raw >> 8));
            value = (byte)raw;
            do {
                codec_store_packed_byte(segment, output, value);
                output++;
                PackedOutputBytes++;
                count--;
            } while (count != 0);
            /* DEC AH exits the original signed loop with AH = FFh. */
            input.ax_high = 0x00FF;
        }
    }
}

word packed_decode_column_packbits(PackedDecodeResult *result, word entry_bx, word entry_ax);

word packed_decode_column_packbits(PackedDecodeResult *result, word entry_bx, word entry_ax)
{
    PackedReadState input;
    word segment = PackedDestSegment;
    word output = PackedDestOffset;
    word columns, column_start, raw, control, control_ah, count, value;

    input.bx = entry_bx;
    input.ax_high = entry_ax >> 8;
    input.failed = 0;
    input.error_ax = 0;
    PackedColumnHeader0 = codec_packed_word(&input, output);
    if (input.failed) PACKED_RETURN(&input, result, output);
    PackedColumnWidth = codec_packed_word(&input, output);
    if (input.failed) PACKED_RETURN(&input, result, output);
    PackedColumnHeader2 = codec_packed_word(&input, output);
    if (input.failed) PACKED_RETURN(&input, result, output);
    columns = PackedColumnWidth;

    do {
        column_start = output;
        for (;;) {
            raw = codec_packed_byte(&input, output);
            if (input.failed) PACKED_RETURN(&input, result, output);
            control = (byte)raw;
            control_ah = input.ax_high;
            if (control == 0x80) break;
            if (control < 0x80) {
                count = (word)(control + 1);
                do {
                    value = (byte)codec_packed_byte(&input, output);
                    if (input.failed) PACKED_RETURN(&input, result, output);
                    input.ax_high = control_ah;
                    codec_store_packed_byte(segment, output, value);
                    output = (word)(output + PackedColumnWidth);
                    PackedOutputBytes++;
                    count--;
                } while (count != 0);
            } else {
                count = (word)(257 - control);
                value = (byte)input.bx;
                input.bx = (word)((input.bx & 0xFF00) | (byte)(0 - control));
                input.ax_high = value;
                raw = codec_packed_byte(&input, output);
                if (input.failed) PACKED_RETURN(&input, result, output);
                input.bx = (word)((input.bx & 0xFF00) | (raw >> 8));
                value = (byte)raw;
                do {
                    codec_store_packed_byte(segment, output, value);
                    output = (word)(output + PackedColumnWidth);
                    PackedOutputBytes++;
                    count--;
                } while (count != 0);
                input.ax_high = 0x00FF;
            }
        }
        /* Assembly restores the saved column start and increments DI once. */
        output = (word)(column_start + 1);
        columns--;
    } while (columns != 0);
    PACKED_RETURN(&input, result, output);
}

word codec_enc_byte(word *input_position, word output_segment)
{
    return (byte)codec_call_enc_byte(EncReadByteService, input_position, output_segment);
}

dword enc_decode_stream(word *ring_write_result)
{
    word input_position = 0;
    EncOutputCursor output;
    word ring_write, flag_bits = 0;
    word i, value, first, second, source, count;

    output.offset = EncDestOffset;
    output.segment = EncDestSegment;
    EncOutputBytes = 0;
    EncOutputBytesHigh = 0;
    EncPushback = 0;
    for (i = 0; i < 0x0FEE; i = (word)(i + 2))
        ((volatile word __far *)EncRingBuffer)[i >> 1] = 0;
    ring_write = 0x0FEE;

    for (;;) {
        flag_bits >>= 1;
        if ((flag_bits & 0x0100) == 0) {
            value = codec_enc_byte(&input_position, output.segment);
            flag_bits = (word)(0xFF00 | (byte)value);
        }

        if (flag_bits & 1) {
            value = codec_enc_byte(&input_position, output.segment);
            store_enc_byte(&output, value);
            EncRingBuffer[ring_write] = (byte)value;
            ring_write = (word)((ring_write + 1) & 0x0FFF);
            continue;
        }

        first = codec_enc_byte(&input_position, output.segment);
        second = codec_enc_byte(&input_position, output.segment);
        source = (word)(first | ((second & 0x00F0) << 4));
        if (source == 0 && (second & 0x000F) == 0) {
            value = codec_enc_byte(&input_position, output.segment);
            if (value == 0) break;
            push_back_enc_byte(value);
            source = 0;
        }

        count = (word)((second & 0x000F) + 3);
        do {
            value = EncRingBuffer[source];
            store_enc_byte(&output, value);
            EncRingBuffer[ring_write] = (byte)value;
            ring_write = (word)((ring_write + 1) & 0x0FFF);
            source = (word)((source + 1) & 0x0FFF);
            count--;
        } while (count != 0);
    }

    /* Return the real BP ring cursor separately from the SI:DI stream cursors. */
    *ring_write_result = ring_write;
    return ((dword)input_position << 16) | output.offset;
}
