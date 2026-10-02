/* High-score ranking, entry shifts and the ten-byte name editor. Reusable text
   ordering is C; packed fonts, panel drawing, BIOS/DOS and key input remain ASM.
   SEGMENT: CGAME
   OWNS: InsertHighScore EditName BeepAndEdit HiscoreNameBackspace HiscoreNamePadBlanks UpdateHighScoreTable
*/
#include "hiscore.h"
#include "input_normalize.h"
#include "dos.h"
#include "pages.h"
#include "text.h"
#include "settings.h"
#include "options.h"

#ifndef OVERKILL_HOST
extern void HiscoreEntryHardware(void);
extern void HiscoreReadNameKey(void);
extern void BiosBeep(void);
extern void ResetPageAndClearScreen(void);
extern void ReadKeyThroughDos(void);
extern word __far MainDataSegment;
word hiscore_read_key(main_routine target);
#pragma aux hiscore_read_key "FarCallMainNearViaAX" far parm [ax] value [ax] modify exact [ax bx cx dx si di es]
#else
#include "platform_services.h"
#endif

void hiscore_show_entry_prompt(DosRegisters *registers)
{
    word entry_bp = registers->bp;

    show_high_score_table(registers);
    /* The page routine returns its live renderer segment in the register record;
       the platform leaf uses it for the panel, BIOS cursor and DOS blank line. */
    dos_service(HiscoreEntryHardware, registers);
    HiscoreRankPrefix[1] = HiscoreEntryRow;
    registers->bp = GAME_OFFSET(HiscoreRankPrefix);
    text_print_message(registers);
    registers->bp = GAME_OFFSET(ScoreBcd);
    text_print_bcd32(registers);
    /* The original prompt saves BP across the whole presentation. */
    registers->bp = entry_bp;
}

word hiscore_read_name_key(DosRegisters *registers)
{
    word entry_bp = registers->bp;
    word key;

    registers->bp = GAME_OFFSET(HiscoreNamePrefix);
    text_print_message(registers);
    registers->bp = GAME_OFFSET(HiscoreNameBuffer);
    text_print_message(registers);
#ifdef OVERKILL_HOST
    {
        HostRegisters service = {0};
        overkill_platform_call(ReadKeyThroughDos, &service);
        key = (byte)service.ax;
    }
#else
    key = (byte)hiscore_read_key(HiscoreReadNameKey);
#endif
    /* The ASM wrapper saved BP around both strings and the DOS key read. */
    registers->bp = entry_bp;
    return key;
}

void edit_hiscore_name(DosRegisters *registers)
{
    word key;
    word name_start = GAME_OFFSET(HiscoreNameBuffer);
    for (;;) {
        key = (byte)hiscore_read_name_key(registers);
        if (key == 8) {
            if (HiscoreNameCursor == name_start) menu_call_platform(BiosBeep);
            else {
                HiscoreNameCursor--;
                *GAME_PTR(byte, HiscoreNameCursor) = ' ';
            }
        } else if (key == 13) break;
        else if (HiscoreNameCursor == name_start + 10) menu_call_platform(BiosBeep);
        else if (key >= 0x20 && key <= 0x7A) {
            *GAME_PTR(byte, HiscoreNameCursor) = (byte)key;
            HiscoreNameCursor++;
        }
    }
    while (HiscoreNameCursor != name_start + 10) {
        *GAME_PTR(byte, HiscoreNameCursor) = ' ';
        HiscoreNameCursor++;
    }
}

void insert_high_score(byte *score)
{
    byte *entry = HiscoreBlock;
    byte *source;
    DosRegisters registers;
    word rank, i;
    HiscoreEntryRow = 4;
    for (rank = 0; rank < 8; rank++) {
        /* The oracle's SUB/SBB chain compares four bytes as an unsigned value;
           equal scores do not precede an existing entry. */
        if (*(dword *)(entry + 12) < *(dword *)score) break;
        HiscoreEntryRow += 2;
        entry += 16;
    }
    if (rank == 8) return;
    HiscoreQualified = 1;
    source = HiscoreBlock + 127;
    for (;;) {
        source[16] = source[0];
        if (source == entry) break;
        source--;
    }
    /* InsertHighScore enters the page and panel path with BP = the compared
       score and ES = the game's data segment. Keep those inherited values in
       the same BP/ES metadata used by page and text services. */
    registers.bp = GAME_OFFSET(score);
    registers.es = (word)MainDataSegment;
    hiscore_show_entry_prompt(&registers);
    HiscoreNamePrefix[1] = HiscoreEntryRow;
    HiscoreNameCursor = GAME_OFFSET(HiscoreNameBuffer);
    for (i = 0; i < 10; i++) HiscoreNameBuffer[i] = ' ';
    HiscoreNameBuffer[10] = 0;
    edit_hiscore_name(&registers);
    for (i = 0; i < 10; i++) entry[i] = HiscoreNameBuffer[i];
    /* As in the oracle, the comparator accepts SS:BP but stores global ScoreBcd,
       leaving the two bytes between name and score untouched. */
    for (i = 0; i < 4; i++) entry[12 + i] = ScoreBcd[i];
    clear_key_down_table();
}

/* The next session phase establishes its own record/render registers. */
void update_high_score_table(void)
{
    HiscoreQualified = 0;
    menu_call_platform(ResetPageAndClearScreen);
    insert_high_score(ScoreBcd);
    if (HiscoreQualified != 0) save_hiscore_file();
}
