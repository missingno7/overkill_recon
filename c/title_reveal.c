/* Title-logo construction control. Tuple and rectangle data remain in the game's
   DS segment. The MAIN assembly leaves do only image-cell and pixel operations.
   SEGMENT: CGAME
   OWNS: StageTitleLogoPieces RevealTitleLogoCells NextRect NextRow RevealCellLoop
   OWNS: RevealCellMergeCases MergeRevealCellCga MergeRevealCellEga MergeRevealCellTandy
   OWNS: RevealCellMerged RevealCellShowCases ShowRevealCellCga ShowRevealCellEga ShowRevealCellTandy
   OWNS: RevealCellShown RevealNextColumn
*/
#include "title_reveal.h"
#include "title.h"
#include "options.h"

extern void TitleDrawLogoPiece(void);
extern void TitleMergeRevealCell(void);
extern void TitleFlashRevealCell(void);
extern void TitleShowRevealCell(void);
extern void WaitVerticalRetrace(void);

void title_call_main_piece(main_routine target, word row_column, word image_id);
#pragma aux title_call_main_piece = "push bp" "call far ptr FarCallMainNearViaAX" "pop bp" \
    parm [ax] [si] [di] modify exact [ax bx cx dx si di es]

word title_call_main_result(main_routine target);
#pragma aux title_call_main_result = "push bp" "call far ptr FarCallMainNearViaAX" "pop bp" \
    parm [ax] value [ax] modify exact [ax bx cx dx si di es]

/* Each call consumes exactly five three-byte tuples. Advance the DS cursor before
   entering the pixel leaf, matching the oracle's observable cursor on return. */
void stage_title_logo_pieces(void)
{
    word piece;
    byte *cursor;
    byte row;
    byte column;
    byte image_id;

    cursor = (byte *)TitleLogoPiecePtr;
    for (piece = 0; piece < 5; piece++) {
        row = *cursor++;
        column = *cursor++;
        image_id = *cursor++;
        TitleLogoPiecePtr = (word)cursor;
        title_call_main_piece(TitleDrawLogoPiece,
                              (word)(((word)row << 8) | column), image_id);
    }
}

word title_reveal_sound_enabled(void)
{
    return ((volatile byte *)&SfxEnabled)[0];
}

/* The original reads SfxEnabled twice for all but the second rectangle. Keep the
   two interrupt-visible reads separate: an IRQ may change the byte between them. */
void title_request_reveal_sound(word rectangles_left)
{
    byte first;
    byte second;

    if (rectangles_left == 4) {
        if (title_reveal_sound_enabled() != 0) SfxRequest = 0x0A;
        return;
    }
    first = title_reveal_sound_enabled();
    if (first == 0) return;
    second = title_reveal_sound_enabled();
    if (second != 0) SfxRequest = 0x0E;
}

void title_reveal_changed_cell(word rectangles_left)
{
    title_request_reveal_sound(rectangles_left);
    title_call_main_result(TitleFlashRevealCell);
    if (rectangles_left != 5 && ((volatile byte *)&KeyLastMakeCode)[0] == 0)
        menu_call_platform(WaitVerticalRetrace);
    title_call_main_result(TitleShowRevealCell);
}

/* Rectangle, row and column traversal is game control. Merge, flash and screen
   copying remain small MAIN pixel leaves so the adapter-specific byte/port paths
   stay unchanged and visible. */
void reveal_title_logo_cells(void)
{
    word rectangles_left;
    word rows;
    word columns;
    word row_index;
    word column_index;
    byte initial_column;
    byte *cursor;

    cursor = (byte *)TitleRevealRects;
    RevealRectPtr = (word)cursor;
    for (rectangles_left = 5; rectangles_left != 0; rectangles_left--) {
        RevealRectsLeft = rectangles_left;
        RevealRow = *cursor++;
        RevealCol = *cursor++;
        rows = *cursor++;
        columns = *cursor++;
        RevealColumns = columns;
        RevealRectPtr = (word)cursor;
        initial_column = RevealCol;

        for (row_index = rows; row_index != 0; row_index--) {
            RevealCol = initial_column;
            for (column_index = columns; column_index != 0; column_index--) {
                if (title_call_main_result(TitleMergeRevealCell) != 0)
                    title_reveal_changed_cell(rectangles_left);
                RevealCol++;
            }
            RevealCol = initial_column;
            RevealRow = (byte)(RevealRow + 8);
        }

        if (rectangles_left != 5)
            delay_frames_until_key_or_primary(10);
    }
    delay_frames_until_key_or_primary(0x50);
}
