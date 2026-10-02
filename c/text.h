#ifndef TEXT_H
#define TEXT_H
#include "dos.h"

/* Native C APIs carry inherited and returned DOS registers explicitly. */
typedef struct TextFormatRegisters {
    word dx;
    word di;
    word es;
    word bp;
} TextFormatRegisters;

/* Stack layout used by the MAIN PrintTextChar adapter. DI is explicit metadata;
   C never reads its transient hardware register after a renderer call. */
typedef struct TextCharacterRegisters {
    word ax;
    word di;
    word es;
    word bp;
} TextCharacterRegisters;

void text_print_message(DosRegisters *registers);
void text_emit_character(byte character, DosRegisters *registers, word *rendered_di);
void text_print_bcd32(DosRegisters *registers);
void text_print_decimal_dx(TextFormatRegisters *registers);
void text_format_decimal_to_buffer(TextFormatRegisters *registers);
word text_uppercase_ascii(word value);

#endif
