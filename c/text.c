/* Message, packed-BCD, decimal formatting and common text-control policy over the
   original DOS state. Font, raster and adapter-specific newline work remain ASM.
   SEGMENT: CGAME
   OWNS: PrintMessageBP PrintBcd32 PrintBcdByte PrintBcdDigit
   OWNS: FormatDecimalToBuffer PrintDecimalDX EmitDecimalDigit EmitDecimalDigitChar OutputChar
   OWNS: UppercaseAsciiAL PrintTextChar PrintGraphicsCharCases
*/
#include "text.h"

extern void RawPrintTextChar(void);
extern word __far MainDataSegment;
extern volatile word __far VideoAdapter;

word text_read_stack_byte(word address)
{
    /* The original operands are SS:BP-relative and wrap at 16 bits. DS = SS. */
    return *(volatile byte *)(word)address;
}

word text_apply_common_control(byte character, DosRegisters *registers)
{
    word graphics = *(volatile word *)&TextInGraphics;
    word adapter = VideoAdapter;
    word bp = registers->bp;
    byte row, column, value;
    word row_bytes;

    /* Common controls cover declared adapters; leave out-of-domain dispatch to
       the retained, unchecked ASM backend table. */
    if (graphics != 0 && adapter > VIDEO_TANDY) return 0;

    if (character == TEXT_SET_COLOR) {
        value = text_read_stack_byte((word)(bp + 1));
        if (graphics != 0 && adapter == VIDEO_CGA) {
            /* The CGA leaf masks the payload before indexing its fill table. */
            value = (byte)(value & 3);
            value = *(volatile byte *)(word)((word)CgaColorFill + value);
        }
        *(volatile byte *)&TextColor = value;
        registers->bp = (word)(bp + 1);
    } else if (character == TEXT_MOVE_TO) {
        row = text_read_stack_byte((word)(bp + 1));
        column = text_read_stack_byte((word)(bp + 2));
        if (graphics == 0) {
            *(volatile word *)&TextRowOffset =
                (word)((word)row * 0x50 + (word)((word)column << 1));
        } else {
            if (adapter == VIDEO_CGA) {
                row_bytes = 4 * CGA_SCREEN_ROW_BYTES;
                *(volatile byte *)&TextColumn = (byte)(column << 1);
            } else if (adapter == VIDEO_EGA) {
                row_bytes = 8 * EGA_SCREEN_ROW_BYTES;
                *(volatile byte *)&TextColumn = column;
            } else {
                row_bytes = 2 * TANDY_SCREEN_ROW_BYTES;
                *(volatile byte *)&TextColumn = (byte)(column << 2);
            }
            *(volatile word *)&TextRowOffset = (word)((word)row * row_bytes);
        }
        registers->bp = (word)(bp + 2);
    } else {
        return 0;
    }

    /* PrintTextChar sets ES before dispatching either control token. */
    registers->es = MainDataSegment;
    return 1;
}

/* C -> MAIN service. SI is the MAIN target, DI is BP, DX is ES, CX is the
   character, and BX points to local DI-output metadata. DX:AX returns ES:BP. */
dword text_main_char_call(main_routine target, word bp, word es, word character,
                          word *rendered_di);
#pragma aux text_main_char_call "TEXT_MAIN_CHAR_CALL" \
    parm [si] [di] [dx] [cx] [bx] value [dx ax] \
    modify exact [ax bx cx dx si di es]

void text_emit_character(byte character, DosRegisters *registers, word *rendered_di)
{
    word renderer_di = rendered_di != 0 ? *rendered_di : 0;

    if (text_apply_common_control(character, registers) == 0) {
        dword result = text_main_char_call(RawPrintTextChar, registers->bp,
                                           registers->es, character, &renderer_di);
        registers->bp = (word)result;
        registers->es = (word)(result >> 16);
    }
    if (rendered_di != 0) *rendered_di = renderer_di;
}

void text_print_message(DosRegisters *registers)
{
    word cursor = registers->bp;
    byte character;

    for (;;) {
        character = *(volatile byte *)(word)cursor;
        if (character == 0) break;

        /* Shared control tokens update BP here; glyph/newline behavior comes from
           the selected ASM backend. Continue after the returned token/payload. */
        registers->bp = cursor;
        text_emit_character(character, registers, 0);
        cursor = (word)(registers->bp + 1);
    }
    registers->bp = cursor;
}

/* MAIN's PrintTextChar entry uses a stack record {AX, DI, ES, BP}. The C policy
   returns updated BP/ES/DI in that record for the remaining ASM caller. */
void text_print_char_from_main(TextCharacterRegisters *state);
#pragma aux text_print_char_from_main parm [si] modify exact [ax]

void text_print_char_from_main(TextCharacterRegisters *state)
{
    DosRegisters renderer;
    renderer.bp = state->bp;
    renderer.es = state->es;
    text_emit_character((byte)state->ax, &renderer, &state->di);
    state->bp = renderer.bp;
    state->es = renderer.es;
}

void text_print_bcd_digit(word value, DosRegisters *registers)
{
    text_emit_character((byte)((value & 0x0F) + 0x30), registers, 0);
}

void text_print_bcd_byte(word value, DosRegisters *registers)
{
    text_print_bcd_digit((word)(value >> 4), registers);
    text_print_bcd_digit(value, registers);
}

void text_print_bcd32(DosRegisters *registers)
{
    word at = registers->bp;
    text_print_bcd_byte(*(volatile byte *)(word)(at + 3), registers);
    text_print_bcd_byte(*(volatile byte *)(word)(at + 2), registers);
    text_print_bcd_byte(*(volatile byte *)(word)(at + 1), registers);
    text_print_bcd_byte(*(volatile byte *)at, registers);
}

/* DX, DI, ES, BP also matches the register-record layout placed on MAIN's stack.
   It carries only inputs and results across the existing register ABI. */
void text_output_decimal_byte(byte character, word buffered,
                              TextFormatRegisters *state,
                              DosRegisters *renderer)
{
    if (buffered != 0) {
        *(byte *)(word)state->di = character;
        state->di = (word)(state->di + 1);
    } else {
        renderer->bp = state->bp;
        renderer->es = state->es;
        text_emit_character(character, renderer, &state->di);
        state->bp = renderer->bp;
        state->es = renderer->es;
    }
}

void text_emit_decimal_place(word *remaining, word power, word buffered,
                             word *significant, TextFormatRegisters *state,
                             DosRegisters *renderer)
{
    byte digit = 0;
    byte character;

    while (*remaining >= power) {
        *remaining = (word)(*remaining - power);
        digit++;
    }

    if (digit == 0 && buffered == 0 && *significant == 0) {
        character = 0x20;
    } else {
        character = (byte)(digit + 0x30);
        (*significant)++;
    }
    text_output_decimal_byte(character, buffered, state, renderer);
}

void text_print_decimal_dx(TextFormatRegisters *state)
{
    word remaining = state->dx;
    word significant = 0;
    word buffered = (DecimalToBuffer == 1);
    DosRegisters renderer;
    byte units;

    renderer.bp = state->bp;
    renderer.es = state->es;

    text_emit_decimal_place(&remaining, 10000, buffered, &significant, state, &renderer);
    text_emit_decimal_place(&remaining, 1000, buffered, &significant, state, &renderer);
    text_emit_decimal_place(&remaining, 100, buffered, &significant, state, &renderer);
    text_emit_decimal_place(&remaining, 10, buffered, &significant, state, &renderer);

    /* The original units place emits the remainder directly and leaves it in DX. */
    units = (byte)remaining;
    text_output_decimal_byte((byte)(units + 0x30), buffered, state, &renderer);
    state->dx = remaining;
    state->bp = renderer.bp;
    state->es = renderer.es;
}

void text_format_decimal_to_buffer(TextFormatRegisters *state)
{
    DecimalToBuffer = 1;
    text_print_decimal_dx(state);
    DecimalToBuffer = 0;
}

word text_uppercase_ascii(word value);
#pragma aux text_uppercase_ascii parm [si] value [ax] modify exact [ax]

word text_uppercase_ascii(word value)
{
    byte character = (byte)value;
    if (character >= 0x61 && character <= 0x7A)
        character = (byte)(character & 0xDF);
    return (word)character;
}

/* C -> MAIN adapters for old near entries. */
dword text_print_message_from_main(word bp, word es);
#pragma aux text_print_message_from_main parm [si] [di] value [dx ax] \
    modify exact [ax bx cx dx si di es]

dword text_print_message_from_main(word bp, word es)
{
    DosRegisters registers;
    registers.bp = bp;
    registers.es = es;
    text_print_message(&registers);
    return ((dword)registers.es << 16) | registers.bp;
}

dword text_print_bcd32_from_main(word bp, word es);
#pragma aux text_print_bcd32_from_main parm [si] [di] value [dx ax] \
    modify exact [ax bx cx dx si di es]

dword text_print_bcd32_from_main(word bp, word es)
{
    DosRegisters registers;
    registers.bp = bp;
    registers.es = es;
    text_print_bcd32(&registers);
    return ((dword)registers.es << 16) | registers.bp;
}

void text_print_decimal_dx_from_main(TextFormatRegisters *registers);
#pragma aux text_print_decimal_dx_from_main parm [si] modify exact [ax]

void text_print_decimal_dx_from_main(TextFormatRegisters *registers)
{
    text_print_decimal_dx(registers);
}

void text_format_decimal_to_buffer_from_main(TextFormatRegisters *registers);
#pragma aux text_format_decimal_to_buffer_from_main parm [si] modify exact [ax]

void text_format_decimal_to_buffer_from_main(TextFormatRegisters *registers)
{
    text_format_decimal_to_buffer(registers);
}
