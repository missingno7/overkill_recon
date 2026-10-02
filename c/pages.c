/* Page navigation, page-load coordination and high-score row presentation over the
   original DOS state. Resource I/O and retrace retain their ASM APIs.
   SEGMENT: CGAME
   OWNS: ShowPageList ShowHighScoreTable
*/
#include "pages.h"
#include "levels.h"
#include "text.h"

extern void WaitVerticalRetrace(void);
extern volatile byte __far HiscoreRowIndex;

void show_page_list(word list, DosRegisters *registers)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;
    word n, next;
    PageListPtr = list;
    PageIndex = 0;
show_page:
    load_and_show_page(registers);
    if (*(word *)(word)(PageListPtr - 2) == 0) return;
    for (;;) {
        if (keys[SCAN_LEFT] == KEY_STATE_DOWN ||
            keys[SCAN_UP] == KEY_STATE_DOWN ||
            keys[SCAN_PGUP] == KEY_STATE_DOWN ||
            keys[SCAN_BACKSPACE] == KEY_STATE_DOWN) {
            if (PageIndex == 0) continue;
            for (n = 0; n < 5; n++) dos_service(WaitVerticalRetrace, registers);
            PageIndex--;
            goto show_page;
        }
        if (keys[SCAN_RIGHT] == KEY_STATE_DOWN ||
            keys[SCAN_DOWN] == KEY_STATE_DOWN ||
            keys[SCAN_PGDN] == KEY_STATE_DOWN ||
            keys[SCAN_SPACE] == KEY_STATE_DOWN ||
            keys[SCAN_ENTER] == KEY_STATE_DOWN) {
            /* The original word increment, shift and address addition wrap. */
            next = (word)((word)(PageIndex + 1) << 1);
            if (*(word *)(word)(PageListPtr + next) == 0xFFFF) continue;
            for (n = 0; n < 5; n++) dos_service(WaitVerticalRetrace, registers);
            PageIndex++;
            goto show_page;
        }
        if (keys[SCAN_ESC] == KEY_STATE_DOWN) {
            while (keys[SCAN_ESC] == KEY_STATE_DOWN) {}
            return;
        }
    }
}

void show_high_score_table(DosRegisters *registers)
{
    word n, row;
    show_page_list((word)HiscorePageList, registers);
    HiscoreRowIndex = 0;
    for (n = 0; n < 8; n++) {
        HiscoreRowPrefix[1] = (byte)((HiscoreRowIndex << 1) + 4);
        registers->bp = (word)HiscoreRowPrefix;
        text_print_message(registers);
        row = (word)HiscoreBlock + (word)HiscoreRowIndex * 16;
        registers->bp = row;
        text_print_message(registers);
        /* A text control code may advance BP. The score uses the saved row. */
        registers->bp = row + 12;
        text_print_bcd32(registers);
        HiscoreRowIndex++;
    }
}

/* Loading establishes its own BP before rendering, so C callers need no input
   BP or ES. The bridges carry BP/ES for ASM callers that consume the returned values. */
void show_pages(word list)
{
    DosRegisters registers;
    registers.bp = 0;
    registers.es = 0;
    show_page_list(list, &registers);
}

void show_scores(void)
{
    DosRegisters registers;
    registers.bp = 0;
    registers.es = 0;
    show_high_score_table(&registers);
}
