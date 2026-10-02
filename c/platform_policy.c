/* C policy for reusable DOS startup and pause control.
   DOS builds retain the narrow file, DAC, BIOS, VRAM and module-init ASM leaves.
   The host builds the same policy over its resource and sound services.

   SEGMENT: CGAME
   OWNS: EnableFileFlagsIfVgaDac LoadSoundModule ShowBossKeyScreen ChecksumFileOrAbort

   All game state remains in the oracle's DS frame. CS checksum/VGA words are referenced
   through their actual far symbols; the only temporary values below live on the C stack. */
#include "platform_policy.h"
#include "levels.h"
#include "sound.h"

#ifndef OVERKILL_HOST
extern volatile word __far IntegritySkip;
extern volatile word __far IntegritySum;
extern volatile word __far IntegrityBytesRead;
extern volatile word __far IntegrityRunningSum;
extern volatile word __far IntegrityBufferSegment;
extern byte IntegrityFileExe[];
extern byte __far SoundModuleSlot[];
#endif

#ifndef OVERKILL_HOST
extern void PolicySetTextMode(void);
extern void PolicyDrawBossKeyScreen(void);
extern void PolicyRestoreVideoMode(void);
extern void PolicyChecksumAbort(void);
void platform_policy_checksum_allocate_open(word file_name);
#pragma aux platform_policy_checksum_allocate_open "PolicyChecksumAllocateAndOpen" far parm [si] modify exact []
word platform_policy_checksum_read_chunk(void);
#pragma aux platform_policy_checksum_read_chunk "PolicyChecksumReadChunk" far value [ax] modify exact [ax]
void platform_policy_checksum_close(void);
#pragma aux platform_policy_checksum_close "PolicyChecksumClose" far modify exact []
void platform_policy_checksum_copy_codewords(word source_offset);
#pragma aux platform_policy_checksum_copy_codewords "PolicyChecksumCopyCodewords" far parm [si] modify exact []
word platform_policy_checksum_free(word checksum);
#pragma aux platform_policy_checksum_free "PolicyChecksumFree" far parm [si] value [ax] modify exact [ax]
void platform_policy_checksum_abort(void);
#pragma aux platform_policy_checksum_abort "PolicyChecksumAbort" far modify exact []
word platform_policy_load_sound_file(word file_name);
#pragma aux platform_policy_load_sound_file "PolicyLoadSoundModuleFile" far parm [si] value [ax] modify exact [ax]
word platform_policy_initialize_sound_module(void);
#pragma aux platform_policy_initialize_sound_module "PolicyInitializeSoundModule" far value [ax] modify exact [ax]
word platform_policy_sound_module_segment(void);
#pragma aux platform_policy_sound_module_segment "PolicySoundModuleSegment" far value [ax] modify exact [ax]
#else
#include "archive.h"
#include "resource_codecs.h"
#include "platform_services.h"
#include "resource_services.h"
#include "memory.h"
#include "adlib_sequence.h"
#include "roland_sequence.h"
#include "sound_services.h"
#include <stdlib.h>
#include <string.h>
void platform_policy_checksum_allocate_open(word file_name);
word platform_policy_checksum_read_chunk(void);
void platform_policy_checksum_close(void);
void platform_policy_checksum_copy_codewords(word source_offset);
word platform_policy_checksum_free(word checksum);
void platform_policy_checksum_abort(void);
word platform_policy_load_sound_file(word file_name);
word platform_policy_initialize_sound_module(void);
word platform_policy_sound_module_segment(void);
#endif

#ifdef OVERKILL_HOST
void platform_policy_checksum_allocate_open(word file_name)
{
    dword opened;
    FileNamePtr = file_name;
    IntegrityBufferSegment = overkill_dos_allocate_paragraphs(0x0180);
    opened = overkill_resource_open_guest_path(MainDataSegment, file_name, 0);
    FileHandle = (word)opened;
    IntegrityRunningSum = 0x1234;
}

word platform_policy_checksum_read_chunk(void)
{
    byte *buffer = (byte *)overkill_segment_address(IntegrityBufferSegment, 0);
    dword read_result;

    /* The DOS reader carries 66 bytes from the previous chunk before overwriting
       the rest of the window, preserving the trailer across its final short read. */
    memmove(buffer, buffer + 0x1400, 0x42);
    read_result = overkill_resource_read(FileHandle, 0x1400,
                                          IntegrityBufferSegment, 0x42);
    IntegrityBytesRead = (word)read_result;
    return (word)read_result;
}

void platform_policy_checksum_close(void)
{
    (void)overkill_resource_close(FileHandle);
}

void platform_policy_checksum_copy_codewords(word source_offset)
{
    word destinations[4];
    word group, index;

    destinations[0] = GAME_OFFSET(Codeword);
    destinations[1] = GAME_OFFSET(NonAsciiCodeword);
    destinations[2] = GAME_OFFSET(OldNonAsciiCodeword);
    destinations[3] = GAME_OFFSET(Password);
    for (group = 0; group < 4; ++group) {
        for (index = 0; index < 16; ++index) {
            word input_offset = (word)(source_offset + group * 16 + index);
            byte *source = (byte *)overkill_segment_address(IntegrityBufferSegment,
                                                             input_offset);
            byte value = (byte)(*source ^ 0xAA);
            *source = value;
            *GAME_PTR(byte, (word)(destinations[group] + index)) = value;
        }
    }
}

word platform_policy_checksum_free(word checksum)
{
    (void)checksum;
    overkill_dos_release_paragraphs(IntegrityBufferSegment);
    return 0;
}

void platform_policy_checksum_abort(void)
{
    DosRegisters registers = {0};
    dos_service(PolicyChecksumAbort, &registers);
    abort();
}

word platform_policy_load_sound_file(word file_name)
{
    dword opened;
    EncFileResult result;

    FileNamePtr = file_name;
    SoundModuleNamePtr = file_name;
    opened = archive_open_by_name(file_name);
    if ((word)(opened >> 16) != 0)
        opened = overkill_resource_open_guest_path(MainDataSegment, file_name, 0);
    if ((word)(opened >> 16) != 0) return 0;

    EncFileHandle = (word)opened;
    EncDestSegment = HOST_SEGMENT_SOUNDMODULESLOT;
    EncDestOffset = 0;
    enc_decode_file(&result);
    return (word)(result.failed == 0);
}

word platform_policy_initialize_sound_module(void)
{
    adlib_sequence_unbind();
    roland_sequence_unbind();
    sound_services_midi_shutdown();

    if (SoundModuleNamePtr == GAME_OFFSET(SoundModuleNameAdlib))
        return (word)(adlib_sequence_bind(SoundModuleSlot, EncOutputBytes) != 0);

    if (SoundModuleNamePtr == GAME_OFFSET(SoundModuleNameRoland)) {
        if (!sound_services_midi_start()) return 0;
        if (!roland_sequence_bind(SoundModuleSlot, EncOutputBytes)) {
            sound_services_midi_shutdown();
            return 0;
        }
        if (!roland_sequence_initialize()) {
            roland_sequence_unbind();
            sound_services_midi_shutdown();
            return 0;
        }
        return 1;
    }

    /* The supplied archive has no Tandy music module to decode or validate. */
    return 0;
}

word platform_policy_sound_module_segment(void)
{
    return HOST_SEGMENT_SOUNDMODULESLOT;
}
#endif

void platform_policy_enable_file_flags(byte probe_result)
{
    /* The original only ever sets this latch; a failed probe does not clear it. */
    if (probe_result == 1) PerFileFlagsEnabled = 1;
}

word platform_policy_try_sound_module(word file_name)
{
    if ((byte)platform_policy_load_sound_file(file_name) == 0) return 0;
    return (word)((byte)platform_policy_initialize_sound_module() != 0);
}

void platform_policy_load_sound_module(void)
{
    byte selection = SoundModuleSelect;
    byte loaded = 0;

    if (selection != SOUND_SELECT_ANY) {
        if (selection >= 'A' && selection <= 'Z') selection = (byte)(selection + 0x20);
        if (selection == SOUND_SELECT_TANDY)
            loaded = platform_policy_try_sound_module(GAME_OFFSET(SoundModuleNameTandy));
        else if (selection == SOUND_SELECT_ROLAND)
            loaded = platform_policy_try_sound_module(GAME_OFFSET(SoundModuleNameRoland));
        else if (selection == SOUND_SELECT_ADLIB)
            loaded = platform_policy_try_sound_module(GAME_OFFSET(SoundModuleNameAdlib));
    } else {
        loaded = platform_policy_try_sound_module(GAME_OFFSET(SoundModuleNameTandy));
        if (loaded == 0)
            loaded = platform_policy_try_sound_module(GAME_OFFSET(SoundModuleNameRoland));
        if (loaded == 0)
            loaded = platform_policy_try_sound_module(GAME_OFFSET(SoundModuleNameAdlib));
    }

    if (loaded == 0) {
        SoundModuleLoaded = 0;
        return;
    }

    SoundModuleLoaded = 1;
    sound_request_module_music(MUSIC_TITLE);
}

void platform_policy_show_boss_key_screen(DosRegisters *registers)
{
    volatile byte *keys = (volatile byte *)KeyDownTable;
    volatile byte *last_make = (volatile byte *)&KeyLastMakeCode;

    sound_stop_module_music(0);
    dos_service(PolicySetTextMode, registers);
    dos_service(PolicyDrawBossKeyScreen, registers);

#ifdef OVERKILL_HOST
    while (keys[SCAN_F9] == KEY_STATE_DOWN) overkill_platform_idle();
#else
    while (keys[SCAN_F9] == KEY_STATE_DOWN) { }
#endif
    *last_make = 0;
#ifdef OVERKILL_HOST
    while (*last_make == 0) overkill_platform_idle();
    while (keys[SCAN_F9] == KEY_STATE_DOWN) overkill_platform_idle();
#else
    while (*last_make == 0) { }
    while (keys[SCAN_F9] == KEY_STATE_DOWN) { }
#endif

    dos_service(PolicyRestoreVideoMode, registers);
    sound_request_module_music(ModuleSoundRequest);
    if (ModuleSoundEnabled != 0)
        registers->es = platform_policy_sound_module_segment();
}

dword platform_policy_checksum_file(word file_name, word caller_si)
{
#ifdef OVERKILL_HOST
    byte *buffer;
#else
    byte __far *buffer;
#endif
    word running = 0x1234;
    word count;
    word i;
    word checksum_cursor = caller_si;
    word trailer;
    word checksum;
    word free_result;

    platform_policy_checksum_allocate_open(file_name);
    /* The buffer segment is established by DOS allocation, so form the far pointer now. */
#ifdef OVERKILL_HOST
    buffer = (byte *)overkill_segment_address(IntegrityBufferSegment, 0);
#else
    buffer = (byte __far *)
        ((__segment)IntegrityBufferSegment :> (void __near *)0);
#endif
    for (;;) {
        count = platform_policy_checksum_read_chunk();
        /* SI is reset to 42h for each nonempty DOS read. The zero-byte EOF
           read branches before that reset, preserving this last window cursor. */
        if (count != 0) checksum_cursor = (word)(0x42 + count);
        for (i = 0; i < count; ++i) {
            word value = buffer[0x42 + i];
            word updated = (word)(running + value);
            byte low = (byte)updated;
            byte high = (byte)((updated >> 8) + low);
            running = (word)(((word)high << 8) | low);
        }
        if (count == 0) break;
        IntegrityRunningSum = running;
    }

    platform_policy_checksum_close();
    /* A short final chunk leaves SI at its end in the carried read window. */
#ifdef OVERKILL_HOST
    trailer = *(word *)(buffer + checksum_cursor - 2);
#else
    trailer = *(word __far *)(buffer + checksum_cursor - 2);
#endif
    checksum = running;
    for (i = 0; i != 2; ++i) {
        byte low = (byte)checksum;
        byte high = (byte)(checksum >> 8);
        byte trailer_byte = buffer[checksum_cursor - 1 - i];
        high = (byte)(high - low);
        checksum = (word)(((word)high << 8) | low);
        checksum = (word)(checksum - trailer_byte);
    }
    IntegritySum = checksum;

    if (IntegritySkip != 1 && FileNamePtr == GAME_OFFSET(IntegrityFileExe))
        platform_policy_checksum_copy_codewords((word)(checksum_cursor - 0x42));

    free_result = platform_policy_checksum_free(checksum);
    if (checksum != trailer && IntegritySkip != 1) platform_policy_checksum_abort();
    return ((dword)checksum_cursor << 16) | free_result;
}
