/* Saved settings and high-score file control; DOS file services remain ASM.
   SEGMENT: CGAME
   OWNS: ApplyLauncherVideoOverride
   OWNS: SaveSettingsToHiscoreBlock LoadSettingsFromHiscoreBlock XorCodeHiscoreBlock
   OWNS: SaveHiscoreFile LoadHiscoreFile ApplyLauncherSoundOverride
*/
#include "settings.h"

#ifdef OVERKILL_HOST
#include "platform_services.h"
#include "memory.h"
#include <stdint.h>
#else
extern volatile word __far VideoAdapter;
extern word __far MainDataSegment;
extern byte __far SoundModuleSlot[];
extern byte __far SlotBuffer[];
extern void LoadFileToBuffer(void);
extern void SaveBufferToFile(void);
#endif

/* Carry ES through the file boundary, including failures before the checksum.
   The thunk saves C's frame pointer; DOS's enclosing-call error unwind stays ASM. */
#ifdef OVERKILL_HOST
static word settings_file_service(main_routine target, word es)
{
    HostRegisters registers = {0};
    registers.ax = target;
    registers.es = es;
    overkill_platform_call(target, &registers);
    return registers.es;
}
#else
word settings_file_service(main_routine target, word es);
#pragma aux settings_file_service "SETTINGS_FILE_SERVICE" parm [ax] [si] value [ax] modify exact [ax bx cx dx si di es]
#endif

#ifdef OVERKILL_HOST
static word host_segment_of(const void *address)
{
    uintptr_t memory_base = (uintptr_t)overkill_segment_address(0, 0);
    return (word)(((uintptr_t)address - memory_base) >> 4);
}
#endif

void save_settings_to_hiscore_block(word video)
{
    byte *p = SavedSettings;
    word n;
    *(word *)p = SoundOption; p += 2;
    for (n = 0; n < JOY_THRESHOLD_WORDS; n++, p += 2)
        *(word *)p = (&JoyXLowThreshold)[n];
    *(word *)p = InputDeviceMode; p += 2;
    for (n = 0; n < KEY_BIT_SCANCODE_COUNT; n++) *p++ = KeyBitScancodesA[n];
    *(word *)p = video; p += 2;
    *p++ = SoundModuleSelect;
    *(word *)p = ChooseSlot; p += 2;
    *(word *)p = DifficultySetting;
}

/* The flag-table index is unchecked, with 16-bit shift/address wrap. Only the
   secondary binding is mirrored into key table B; all its other slots survive. */
word load_settings_from_hiscore_block(void)
{
    byte *p = SavedSettings;
    word n, flags, video;
    SoundOption = *(word *)p; p += 2;
    flags = *GAME_PTR(word, (word)(GAME_OFFSET(SoundOptionFlags) +
                                  (word)(SoundOption << 1)));
    SfxEnabled = (byte)(flags >> 8);
    ModuleSoundEnabled = (byte)flags;
    for (n = 0; n < JOY_THRESHOLD_WORDS; n++, p += 2)
        (&JoyXLowThreshold)[n] = *(word *)p;
    InputDeviceMode = *(word *)p; p += 2;
    for (n = 0; n < KEY_BIT_SCANCODE_COUNT; n++) KeyBitScancodesA[n] = *p++;
    KeyBitScancodesB[KEY_SLOT_SECONDARY] = KeyBitScancodesA[KEY_SLOT_SECONDARY];
    video = *(word *)p; p += 2;
    SoundModuleSelect = *p++;
    ChooseSlot = *(word *)p; p += 2;
    DifficultySetting = *(word *)p;
    return video;
}

/* The checksum is over the resulting bytes, so encoding and decoding generally
   return different sums. Calling twice restores every byte, including the slack. */
word xor_code_hiscore_block(void)
{
    word n, sum = 0;
    byte value;
    for (n = 0; n < HISCORE_BLOCK_BYTES; n++) {
        value = HiscoreBlock[n] ^ 0xAA ^ (byte)(HISCORE_BLOCK_BYTES - n);
        HiscoreBlock[n] = value;
        sum += value;
    }
    return sum;
}

void save_hiscore_file(void)
{
    save_settings_to_hiscore_block(VideoAdapter);
    HiscoreChecksum = xor_code_hiscore_block();
    FileBufferSegment = MainDataSegment;
    FileBufferOffset = GAME_OFFSET(HiscoreBlock);
    FileByteCount = HISCORE_BLOCK_BYTES + 2;
    FileNamePtr = GAME_OFFSET(HiscoreFileName);
    settings_file_service(SaveBufferToFile, MainDataSegment);
    /* Decode even after a failed create/write/close, keeping the encoded-file
       checksum in the following word like the original. */
    xor_code_hiscore_block();
}

/* Result DX:AX carries the original ES and AL success byte to the startup bridge.
   Do not reject short reads: the original checks all 172 buffer bytes regardless
   of FileByteCount and leaves defaults intact when the checksum does not match. */
dword load_hiscore_file(word es)
{
    word n, sum = 0;
#ifdef OVERKILL_HOST
    word buffer_segment = (word)(host_segment_of(SoundModuleSlot) + SLOT_BUFFER_PARAGRAPH);
#else
    word buffer_segment = (word)((dword)SoundModuleSlot >> 16) + SLOT_BUFFER_PARAGRAPH;
#endif
    FileBufferSegment = buffer_segment;
    FileBufferOffset = 0;
    FileNamePtr = GAME_OFFSET(HiscoreFileName);
    es = settings_file_service(LoadFileToBuffer, es);
    if (FileStatus != FILE_STATUS_OK) return (dword)es << 16;
    es = buffer_segment;
    for (n = 0; n < HISCORE_BLOCK_BYTES; n++) sum += SlotBuffer[n];
    if (sum != *(word __far *)(SlotBuffer + HISCORE_BLOCK_BYTES)) return (dword)es << 16;
    for (n = 0; n < HISCORE_BLOCK_BYTES; n++) HiscoreBlock[n] = SlotBuffer[n];
    xor_code_hiscore_block();
    VideoAdapter = load_settings_from_hiscore_block();
    return ((dword)MainDataSegment << 16) | 1;
}

void apply_launcher_sound_override(word module)
{
    SoundModuleSelect = (byte)module;
}

void apply_launcher_video_override(word adapter)
{
    VideoAdapter = adapter;
}
