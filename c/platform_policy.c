/* C policy for reusable DOS startup and pause control.
   DOS file, DAC, BIOS, VRAM and module-init operations remain narrow ASM leaves.

   SEGMENT: CGAME
   OWNS: EnableFileFlagsIfVgaDac LoadSoundModule ShowBossKeyScreen ChecksumFileOrAbort

   All game state remains in the oracle's DS frame. CS checksum/VGA words are referenced
   through their actual far symbols; the only temporary values below live on the C stack. */
#include "platform_policy.h"
#include "levels.h"
#include "sound.h"

extern volatile word __far IntegritySkip;
extern volatile word __far IntegritySum;
extern volatile word __far IntegrityBytesRead;
extern volatile word __far IntegrityRunningSum;
extern volatile word __far IntegrityBufferSegment;

extern byte IntegrityFileExe[];
extern byte __far SoundModuleSlot[];

void PolicySetTextMode(void);
void PolicyDrawBossKeyScreen(void);
void PolicyRestoreVideoMode(void);
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
            loaded = platform_policy_try_sound_module((word)SoundModuleNameTandy);
        else if (selection == SOUND_SELECT_ROLAND)
            loaded = platform_policy_try_sound_module((word)SoundModuleNameRoland);
        else if (selection == SOUND_SELECT_ADLIB)
            loaded = platform_policy_try_sound_module((word)SoundModuleNameAdlib);
    } else {
        loaded = platform_policy_try_sound_module((word)SoundModuleNameTandy);
        if (loaded == 0)
            loaded = platform_policy_try_sound_module((word)SoundModuleNameRoland);
        if (loaded == 0)
            loaded = platform_policy_try_sound_module((word)SoundModuleNameAdlib);
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

    while (keys[SCAN_F9] == KEY_STATE_DOWN) { }
    *last_make = 0;
    while (*last_make == 0) { }
    while (keys[SCAN_F9] == KEY_STATE_DOWN) { }

    dos_service(PolicyRestoreVideoMode, registers);
    sound_request_module_music(ModuleSoundRequest);
    if (ModuleSoundEnabled != 0)
        registers->es = platform_policy_sound_module_segment();
}

word platform_policy_checksum_file(word file_name, word caller_si)
{
    byte __far *buffer;
    word running = 0x1234;
    word count;
    word i;
    word trailer;
    word checksum;
    word free_result;

    platform_policy_checksum_allocate_open(file_name);
    /* The buffer segment is established by DOS allocation, so form the far pointer now. */
    buffer = (byte __far *)
        ((__segment)IntegrityBufferSegment :> (void __near *)0);
    for (;;) {
        count = platform_policy_checksum_read_chunk();
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
    /* The ASM routine leaves SI caller-derived through each read; its final two DEC
       instructions make caller_si - 2 the comparison word and codeword cursor. */
    trailer = *(word __far *)(buffer + caller_si - 2);
    checksum = running;
    for (i = 0; i != 2; ++i) {
        byte low = (byte)checksum;
        byte high = (byte)(checksum >> 8);
        byte trailer_byte = buffer[caller_si - 1 - i];
        high = (byte)(high - low);
        checksum = (word)(((word)high << 8) | low);
        checksum = (word)(checksum - trailer_byte);
    }
    IntegritySum = checksum;

    if (IntegritySkip != 1 && FileNamePtr == (word)IntegrityFileExe)
        platform_policy_checksum_copy_codewords((word)(caller_si - 0x42));

    free_result = platform_policy_checksum_free(checksum);
    if (checksum != trailer && IntegritySkip != 1) platform_policy_checksum_abort();
    return free_result;
}
