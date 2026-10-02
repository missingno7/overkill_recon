/* Payment-text file and navigation control over the oracle's existing ENC workspace.
   Text-page drawing, retrace polling, BIOS mode/cursor changes, the Hercules probe,
   archive file access, and fatal shutdown remain named platform/service entries.
   SEGMENT: CGAME
   OWNS: ShowPaymentText PaymentTextRedraw PaymentTextPollKeys PaymentTextScrollUp
   OWNS: PaymentTextLineDown PaymentTextScrollDown PaymentTextWaitEscRelease
*/
#include "payment.h"
#include "archive.h"
#include "resource_codecs.h"
#ifdef OVERKILL_HOST
#include "platform_services.h"
#include "presentation_services.h"
#endif

#ifndef OVERKILL_HOST
extern volatile word __far TextScreenSegment;
extern volatile word __far TextTopLine;
extern volatile word __far TextLineCount;
extern volatile word __far EncFileHandle;
extern volatile word __far EncDestOffset;
extern volatile word __far EncDestSegment;
extern word __far WorkspaceSegment;
#endif

#ifndef OVERKILL_HOST
extern void PaymentSetTextModeAndHideCursor(void);
extern void DrawPaymentTextPage(void);
extern void WaitTextVerticalRetrace(void);
extern void ProbeMonoHercules(void);
extern void ShutdownWithError(void);
extern void CACHE_GET_DRIVE(void);
#endif

word payment_current_drive(void);
#ifdef OVERKILL_HOST
word payment_current_drive(void)
{
    HostRegisters registers = { 0 };
    overkill_platform_call(HOST_SERVICE_CACHE_GET_DRIVE, &registers);
    return registers.ax;
}
#else
#pragma aux payment_current_drive "CACHE_GET_DRIVE" far value [ax] modify exact [ax]
#endif

void payment_call_main(main_routine target);
#ifdef OVERKILL_HOST
void payment_call_main(main_routine target)
{
    HostRegisters registers = { 0 };
    overkill_platform_call(target, &registers);
}
#else
#pragma aux payment_call_main "CACHE_CALL_MAIN" far parm [ax] \
    modify exact [ax bx cx dx si di es]
#endif

word payment_call_probe(main_routine target);
#ifdef OVERKILL_HOST
word payment_call_probe(main_routine target)
{
    HostRegisters registers = { 0 };
    overkill_platform_call(target, &registers);
    return registers.ax;
}
#else
#pragma aux payment_call_probe "FarCallMainNearViaAX" far parm [ax] value [ax] \
    modify exact [ax bx cx dx si di es]
#endif

typedef struct PaymentScrollRegisters {
    word ax;
    word cx;
} PaymentScrollRegisters;

#ifdef OVERKILL_HOST
#define PAYMENT_ADDRESS(type, segment, offset) \
    ((volatile type *)overkill_segment_address((word)(segment), (word)(offset)))
#else
#define PAYMENT_ADDRESS(type, segment, offset) \
    ((volatile type __far *)((__segment)(segment) :> \
                            ((type __based(void) *)(offset))))
#endif

void payment_scroll_up(void *opaque)
{
    PaymentScrollRegisters *registers = (PaymentScrollRegisters *)opaque;

    registers->cx = 0;
    if (TextTopLine == 0) return;
    TextTopLine--;
    registers->cx = 1;
}

void payment_scroll_down(void *opaque)
{
    PaymentScrollRegisters *registers = (PaymentScrollRegisters *)opaque;
    word candidate = (word)(TextTopLine + 1);

    candidate = (word)(candidate + 0x18);
    registers->ax = candidate;
    registers->cx = 0;
    if (candidate >= TextLineCount) return;
    TextTopLine++;
    registers->cx = 1;
}

void payment_wait_for_escape_release(void)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;
    while (keys[SCAN_ESC] == KEY_STATE_DOWN) {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
    }
}

void payment_scan_line_count(void)
{
    word cursor = 0;

    TextTopLine = 0;
    TextLineCount = 1;
    for (;;) {
        byte value = *PAYMENT_ADDRESS(byte, WorkspaceSegment, cursor);
        cursor++;
        if (value == 0x1A) return;
        if (value == 0x0D) TextLineCount++;
    }
}

void payment_draw_page(DosRegisters *registers)
{
    dos_service((main_routine)DrawPaymentTextPage, registers);
}

void payment_wait_retrace(DosRegisters *registers)
{
    dos_service((main_routine)WaitTextVerticalRetrace, registers);
}

void payment_show_text(DosRegisters *registers)
{
    EncFileResult decoded;
    dword opened;
    word drive, repeats;
    word probe;
    PaymentScrollRegisters scroll;
    volatile byte *keys = (volatile byte *)KeyDownTable;

    dos_service((main_routine)PaymentSetTextModeAndHideCursor, registers);
    TextScreenSegment = 0xB800;
    probe = payment_call_probe((main_routine)ProbeMonoHercules);
    if ((byte)probe != 0) TextScreenSegment = 0xB000;

    FileNamePtr = GAME_OFFSET(PaymentFileName);
    for (;;) {
        opened = archive_open_by_name(FileNamePtr);
        if ((word)(opened >> 16) == 0) break;
        drive = (byte)payment_current_drive();
        if (drive < 2) continue;
        payment_call_main((main_routine)ShutdownWithError);
        return;                 /* Only reached when a bounded test stubs shutdown. */
    }

    EncFileHandle = (word)opened;
    EncDestSegment = WorkspaceSegment;
    EncDestOffset = 0;
    enc_decode_file(&decoded);
    if (decoded.failed != 0) {
        payment_wait_for_escape_release();
        return;
    }

    payment_scan_line_count();
redraw:
    payment_draw_page(registers);
poll_keys:
#ifdef OVERKILL_HOST
    overkill_platform_idle();
#endif
    if (keys[SCAN_ESC] == KEY_STATE_DOWN) {
        payment_wait_for_escape_release();
        return;
    }
    if (keys[SCAN_HOME] == KEY_STATE_DOWN) {
        repeats = 0xFFFF;
        do { payment_scroll_up(&scroll); } while (--repeats != 0);
        goto redraw;
    }
    if (keys[SCAN_END] == KEY_STATE_DOWN) {
        repeats = 0xFFFF;
        do { payment_scroll_down(&scroll); } while (--repeats != 0);
        goto redraw;
    }
    if (keys[SCAN_UP] == KEY_STATE_DOWN) {
        payment_scroll_up(&scroll);
        if (scroll.cx != 0) goto redraw;
        goto poll_keys;
    }
    if (keys[SCAN_DOWN] == KEY_STATE_DOWN) {
        payment_scroll_down(&scroll);
        if (scroll.cx != 0) goto redraw;
        goto poll_keys;
    }
    if (keys[SCAN_PGUP] == KEY_STATE_DOWN) {
        for (repeats = 0; repeats < 8; repeats++) payment_wait_retrace(registers);
        for (repeats = 0; repeats < 0x17; repeats++)
            payment_scroll_up(&scroll);
        goto redraw;
    }
    if (keys[SCAN_PGDN] == KEY_STATE_DOWN) {
        for (repeats = 0; repeats < 8; repeats++) payment_wait_retrace(registers);
        for (repeats = 0; repeats < 0x17; repeats++)
            payment_scroll_down(&scroll);
        goto redraw;
    }
    goto poll_keys;
}
