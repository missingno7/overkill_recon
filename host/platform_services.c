#include "platform_services.h"

#include "archive.h"
#include "hiscore.h"
#include "platform_policy.h"
#include "shutdown.h"

#include "clock_services.h"
#include "file_services.h"
#include "input_services.h"
#include "memory.h"
#include "presentation_services.h"
#include "resource_services.h"
#include "sdl_input.h"
#include "sound.h"
#include "sound_services.h"
#include "video_services.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/* The graphics decoder owns the resource-specific leaves, while the video and
   presentation services own their respective DOS-shaped drawing entries. */
int overkill_graphics_service(word token, HostRegisters *registers);

/* These sample readers are the host side of the original game-port entry points. */
word input_read_x_count(main_routine target);
word input_read_y_count(main_routine target);
word input_read_button_bits(main_routine target);
void input_flush_bios_buffer(main_routine target);

uint64_t overkill_clock_now_ns(void);
uint16_t overkill_dos_get_allocation_strategy(void);
int overkill_dos_set_allocation_strategy(uint16_t strategy);
int overkill_resource_drive_is_mounted(char letter);

static word last_service_es;
static void (*idle_callback)(void);
static void (*exit_callback)(int);
static void (*trace_callback)(word, const HostRegisters *);
static uint64_t next_retrace_ns;

#define HOST_RETRACE_PERIOD_NS 16666667ull

static void wait_for_vertical_retrace(void)
{
    uint64_t now = overkill_clock_now_ns();

    if (next_retrace_ns == 0) {
        next_retrace_ns = now + HOST_RETRACE_PERIOD_NS;
    } else if (next_retrace_ns <= now) {
        uint64_t missed = (now - next_retrace_ns) / HOST_RETRACE_PERIOD_NS + 1;
        next_retrace_ns += missed * HOST_RETRACE_PERIOD_NS;
    }

    while (overkill_clock_now_ns() < next_retrace_ns)
        overkill_platform_idle();
}

static void request_process_exit(int status)
{
    if (exit_callback != NULL) {
        exit_callback(status);
        return;
    }
    exit(status);
}

static void install_timer_service(void)
{
    /* The runtime owns the PIT schedule. This canonical flag retains the
       original service lifecycle state for any game code that inspects it. */
    TimerVectorInstalled = 1;
}

static void restore_timer_service(void)
{
    TimerVectorInstalled = 0;
    sound_services_speaker_off();
}

static void set_best_fit_strategy(void)
{
    SavedAllocStrategy = overkill_dos_get_allocation_strategy();
    (void)overkill_dos_set_allocation_strategy(1);
}

static void restore_allocation_strategy(void)
{
    (void)overkill_dos_set_allocation_strategy(SavedAllocStrategy);
}

static void detect_floppy_drives(void)
{
    /* As in the INT 11h routine, detection only raises these startup latches. */
    if (overkill_resource_drive_is_mounted('A')) DriveAPresent = 1;
    if (overkill_resource_drive_is_mounted('B')) DriveBPresent = 1;
}

static void detect_virtual_ems(void)
{
    /* EMS handles use four 16 KiB pages mapped through this conventional-memory
       window. It is the native counterpart of the original EMS page frame. */
    EmsPageFrame = 0xE000;
    EmsTotalPages = 4;
    EmsFreePages = 4;
    EmsAvailable = 1;
}

static void checksum_file(HostRegisters *registers, word filename)
{
    dword result = platform_policy_checksum_file(filename, registers->si);
    registers->ax = (word)result;
    registers->si = (word)((result >> 16) - 2);
}

static void verify_startup_checksums(HostRegisters *registers)
{
    IntegritySkip = 0;
    checksum_file(registers, GAME_OFFSET(IntegrityFileExe));
    checksum_file(registers, GAME_OFFSET(IntegrityFileData));
}

static void read_key_through_dos(HostRegisters *registers)
{
    int key;

    LastKeyExtended = 0;
    overkill_sdl_character_mode(1);
    do {
        overkill_platform_idle();
        key = overkill_sdl_read_character();
    } while (key < 0);

    if (key == 0) {
        do {
            overkill_platform_idle();
            key = overkill_sdl_read_character();
        } while (key < 0);
        LastKeyExtended = 1;
    }
    overkill_sdl_character_mode(0);
    /* INT 21h/AH=08h returns the character in AL and leaves AH as 08h. */
    registers->ax = (word)(0x0800 | (byte)key);
    QuitAnswer = (byte)key;
}

static void flush_bios_keyboard_buffer(void)
{
    input_flush_bios_buffer(FlushBiosKeyboardBuffer);
    overkill_sdl_flush_characters();
}

static void bios_teletype_bell(void)
{
    (void)fputc('\a', stdout);
    (void)fflush(stdout);
}

static void sync_bios_cursor_from_text_page(void)
{
    volatile byte *bios_data =
        (volatile byte *)overkill_segment_address(0, 0x0400);
    word row, column;

    presentation_text_get_cursor(&row, &column);
    bios_data[0x50] = (byte)column;
    bios_data[0x51] = (byte)row;
}

static void enter_text_mode3(word hide_cursor)
{
    presentation_set_text_mode3(hide_cursor);
    sync_bios_cursor_from_text_page();
}

static void fill_text_attributes(byte *page, word offset, byte attribute,
                                 word cells)
{
    while (cells != 0) {
        page[offset] = attribute;
        offset = (word)(offset + 2);
        --cells;
    }
}

static void draw_boss_key_screen(void)
{
    const byte *source = (const byte *)overkill_segment_address(
        MainDataSegment, HOST_OFFSET_BOSSKEYSCREEN);
    byte *page = (byte *)overkill_segment_address(0xB800, 0);
    word offset = 1;
    word row;

    for (row = 0; row != 0x07D0; ++row) {
        page[row * 2] = source[row * 2];
        page[row * 2 + 1] = source[row * 2 + 1];
    }

    /* These loops preserve the BIOS attribute writes after the page copy. */
    fill_text_attributes(page, 1, 0x0C, 0x50);
    fill_text_attributes(page, 1, 0x0E, 0x01E0);
    offset = (word)(offset + 2 * 0x01E0);
    for (row = 0; row != 0x0F; ++row) {
        fill_text_attributes(page, offset, 0x0E, 1);
        offset = (word)(offset + 2);
        fill_text_attributes(page, offset, 0x07, 0x4F);
        offset = (word)(offset + 2 * 0x4F);
    }
    fill_text_attributes(page, offset, 0x1E, 0x50);
    offset = (word)(offset + 2 * 0x50);
    fill_text_attributes(page, offset, 0x1E, 0x50);
    fill_text_attributes(page, 0x0731, 0x71, 0x0D);
    presentation_text_set_cursor(0x17, 0x47);
    sync_bios_cursor_from_text_page();
}

static void checksum_abort(void)
{
    volatile byte *bios_data =
        (volatile byte *)overkill_segment_address(0, 0x0400);
    int key;

    enter_text_mode3(0);
    presentation_print_dos_string_at_bp(GAME_OFFSET(CorruptMsgHead));
    presentation_print_dos_string_at_bp(FileNamePtr);
    presentation_print_dos_string_at_bp(GAME_OFFSET(CorruptMsgTail));
    presentation_text_set_cursor(24, 0);
    presentation_print_dos_string_at_bp(GAME_OFFSET(CorruptMsgPressKey));
    sync_bios_cursor_from_text_page();

    /* The original drains INT 16h's queue before blocking on AH=08h. */
    bios_data[0x1C] = bios_data[0x1A];
    overkill_sdl_flush_characters();
    overkill_sdl_character_mode(1);
    do {
        overkill_platform_idle();
        key = overkill_sdl_read_character();
    } while (key < 0);
    overkill_sdl_character_mode(0);
    request_process_exit(1);
}

static int dispatch_service(word token, HostRegisters *registers)
{
    if (token == HOST_TOKEN_BUILDBYTETONIBBLEMASKTABLE) {
        unsigned value, pair;
        for (value = 0; value < 256; ++value)
            for (pair = 0; pair < 4; ++pair) {
                unsigned shift = 6 - pair * 2;
                ByteToNibbleMasks[value * 4 + pair] =
                    (byte)(((value >> (shift + 1) & 1) ? 0xF0 : 0) |
                           ((value >> shift & 1) ? 0x0F : 0));
            }
        registers->es = MainDataSegment;
        return 1;
    }
    DosRegisters dos_registers;

    if (token == HOST_TOKEN_RESETPAGEANDCLEARSCREEN ||
        token == HOST_TOKEN_RESETEGAPAGES ||
        token == HOST_TOKEN_CLEARSCREEN104X200 ||
        token == HOST_TOKEN_COPYWORKSPACETOSCREEN ||
        token == HOST_TOKEN_COPYFULLWORKSPACETOSCREEN ||
        token == HOST_TOKEN_COPYEGAPAGE0TOPAGE1 ||
        token == HOST_SERVICE_STARTUPSETSELECTEDVIDEOMODE)
        presentation_text_mode_leave();
    if (overkill_video_service(token, registers)) return 1;
    if (presentation_dispatch(token, registers)) return 1;
    if (overkill_graphics_service(token, registers)) return 1;
    if (overkill_file_service(token, registers)) return 1;

    switch (token) {
    case HOST_TOKEN_CLEARTIMERTICK:
        overkill_clock_clear_frame_tick();
        return 1;
    case HOST_TOKEN_WAITTIMERTICK:
        while (!overkill_clock_frame_ready()) overkill_platform_idle();
        return 1;
    case HOST_TOKEN_WAITVERTICALRETRACE:
    case HOST_TOKEN_WAITVERTICALRETRACEPULSE:
    case HOST_TOKEN_WAITTEXTVERTICALRETRACE:
        wait_for_vertical_retrace();
        return 1;
    case HOST_TOKEN_INSTALLTIMERVECTOR08:
    case HOST_SERVICE_STARTUPINSTALLTIMERVECTOR08:
        install_timer_service();
        return 1;
    case HOST_TOKEN_RESTORETIMERVECTOR08:
        restore_timer_service();
        return 1;
    case HOST_TOKEN_INSTALLKEYBOARDVECTOR09:
    case HOST_TOKEN_RESTOREKEYBOARDVECTOR09:
        /* SDL writes the same set-1 make-code state directly. There is no
           process interrupt vector to install or restore on the host. */
        return 1;
    case HOST_SERVICE_STARTUPSETBESTFITALLOCSTRATEGY:
    case HOST_TOKEN_SETBESTFITALLOCSTRATEGY:
        set_best_fit_strategy();
        return 1;
    case HOST_TOKEN_RESTOREALLOCSTRATEGY:
    case HOST_SERVICE_SHUTDOWNRESTOREALLOCSTRATEGY:
        restore_allocation_strategy();
        return 1;
    case HOST_TOKEN_SETUPRESOURCEARCHIVE:
        archive_setup_resource_library();
        return 1;
    case HOST_TOKEN_DETECTFLOPPYDRIVES:
        detect_floppy_drives();
        return 1;
    case HOST_TOKEN_DETECTEMS:
        detect_virtual_ems();
        return 1;
    case HOST_TOKEN_ENABLEFILEFLAGSIFVGADAC:
        /* Only the EGA path consumes this VGA-DAC-dependent file flag. The
           native indexed presenter supplies that capability for EGA. */
        {
            byte probe_result = (byte)(VideoAdapter == VIDEO_EGA);
            platform_policy_enable_file_flags(probe_result);
            registers->ax = (word)((registers->ax & 0xFF00) | probe_result);
        }
        return 1;
    case HOST_TOKEN_VERIFYSTARTUPCHECKSUMS:
        verify_startup_checksums(registers);
        return 1;
    case HOST_TOKEN_CHECKSUMFILEORABORT:
        checksum_file(registers, registers->dx);
        return 1;
    case HOST_TOKEN_LOADSOUNDMODULE:
        platform_policy_load_sound_module();
        if (SoundModuleLoaded == 1 && ModuleSoundEnabled != 0)
            registers->es = HOST_SEGMENT_SOUNDMODULESLOT;
        return 1;
    case HOST_TOKEN_SHOWBOSSKEYSCREEN:
        dos_registers.bp = registers->bp;
        dos_registers.es = registers->es;
        platform_policy_show_boss_key_screen(&dos_registers);
        registers->bp = dos_registers.bp;
        registers->es = dos_registers.es;
        return 1;
    case HOST_SERVICE_POLICYSETTEXTMODE:
        enter_text_mode3(0);
        return 1;
    case HOST_SERVICE_POLICYDRAWBOSSKEYSCREEN:
        draw_boss_key_screen();
        registers->es = 0xB800;
        return 1;
    case HOST_SERVICE_POLICYRESTOREVIDEOMODE:
        presentation_text_mode_leave();
        if (!overkill_video_service(HOST_SERVICE_STARTUPSETSELECTEDVIDEOMODE,
                                    registers))
            return 0;
        return 1;
    case HOST_TOKEN_SHUTDOWNGAME:
        sound_services_speaker_off();
        dos_registers.bp = registers->bp;
        dos_registers.es = registers->es;
        shutdown_game(&dos_registers);
        registers->bp = dos_registers.bp;
        registers->es = dos_registers.es;
        return 1;
    case HOST_TOKEN_SHUTDOWNWITHERROR:
        ++ExitWithError;
        sound_services_speaker_off();
        dos_registers.bp = registers->bp;
        dos_registers.es = registers->es;
        shutdown_game(&dos_registers);
        registers->bp = dos_registers.bp;
        registers->es = dos_registers.es;
        return 1;
    case HOST_TOKEN_READKEYTHROUGHDOS:
    case HOST_SERVICE_HISCOREREADNAMEKEY:
        read_key_through_dos(registers);
        return 1;
    case HOST_TOKEN_FLUSHBIOSKEYBOARDBUFFER:
        flush_bios_keyboard_buffer();
        return 1;
    case HOST_TOKEN_READGAMEPORTAAXISCOUNTS:
        registers->bx = input_read_x_count(token);
        registers->cx = input_read_y_count(token);
        return 1;
    case HOST_SERVICE_READGAMEPORTABUTTONBITS:
        registers->ax = input_read_button_bits(token);
        return 1;
    case HOST_SERVICE_CACHE_GET_DRIVE:
        registers->ax = overkill_resource_current_drive();
        return 1;
    case HOST_TOKEN_PROBEFLOPPYREADY:
        registers->ax = overkill_resource_probe_guest_path(MainDataSegment,
                                                           FileNamePtr) ? 0 : 1;
        return 1;
    case HOST_TOKEN_BIOSBEEP:
        bios_teletype_bell();
        return 1;
    case HOST_TOKEN_STOPMODULEMUSIC:
        registers->ax = sound_stop_module_music(registers->ax);
        return 1;
    case HOST_TOKEN_REQUESTMODULEMUSIC:
        sound_request_module_music(registers->ax);
        return 1;
    case HOST_SERVICE_MENUREQUESTMUSIC:
        sound_request_module_music(registers->si);
        return 1;
    case HOST_SERVICE_MENUCALLSERVICE:
        return dispatch_service(registers->dx, registers);
    case HOST_SERVICE_HISCOREENTRYHARDWARE:
        presentation_draw_hiscore_entry();
        presentation_print_dos_string_at_bp(HOST_OFFSET_HISCOREBLANKLINE);
        sync_bios_cursor_from_text_page();
        return 1;
    case HOST_SERVICE_SESSIONDRAWQUITPROMPT:
        presentation_draw_quit_prompt();
        return 1;
    case HOST_SERVICE_SHUTDOWNSETTEXTMODE3:
        enter_text_mode3(0);
        return 1;
    case HOST_SERVICE_SHUTDOWNPRINTDOSSTRINGATBP:
        presentation_print_dos_string_at_bp(registers->bp);
        sync_bios_cursor_from_text_page();
        return 1;
    case HOST_SERVICE_SHUTDOWNPRESENTEXITORDERANDFLUSHKEYS:
        presentation_present_exit_order();
        sync_bios_cursor_from_text_page();
        {
            volatile byte *bios_data =
                (volatile byte *)overkill_segment_address(0, 0x0400);
            /* INT 16h queue flush: advance the BIOS tail to the current head. */
            bios_data[0x1C] = bios_data[0x1A];
        }
        overkill_sdl_flush_characters();
        return 1;
    case HOST_SERVICE_SHUTDOWNEXITTODOS:
        request_process_exit(0);
        return 1;
    case HOST_SERVICE_POLICYCHECKSUMABORT:
        checksum_abort();
        return 1;
    default:
        return 0;
    }
}

void overkill_platform_bind_idle(void (*idle)(void))
{
    idle_callback = idle;
}

void overkill_platform_bind_exit(void (*terminate)(int))
{
    exit_callback = terminate;
}

void overkill_platform_bind_trace(void (*trace)(word, const HostRegisters *))
{
    trace_callback = trace;
}

void overkill_platform_idle(void)
{
    if (idle_callback == NULL) {
        fputs("Overkill platform idle hook is not bound\n", stderr);
        abort();
    }
    idle_callback();
}

void overkill_platform_call(word token, HostRegisters *registers)
{
    if (registers == NULL) abort();
    if (!dispatch_service(token, registers)) {
        (void)fprintf(stderr, "Unhandled Overkill platform service token 0x%04X\n",
                      token);
        abort();
    }
    last_service_es = registers->es;
    if (trace_callback != NULL) trace_callback(token, registers);
}

word overkill_platform_last_es(void)
{
    return last_service_es;
}
