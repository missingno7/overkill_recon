/* File-cache lookup/lifetime and resource-load control over the existing DOS state.
   Archive search and packed/ENC decoding are C-owned; raw DOS/EMS calls and
   segment copying remain at their platform leaves.

   SEGMENT: CGAME
   OWNS: AdvanceABColonPrefix CopyFromFileCache CacheLoadedFile ReleaseEmsCache LoadResourceFile
*/
#include "cache.h"
#include "archive.h"
#include "resource_codecs.h"

extern volatile word __far VideoAdapter;
extern word __far MainDataSegment;
extern volatile word __far EncFileHandle;
extern volatile word __far EncDestSegment;
extern volatile word __far EncDestOffset;
extern volatile word __far EncOutputBytes;
extern volatile word __far PackedNamePtr;
extern volatile word __far PackedDestSegment;
extern volatile word __far PackedDestOffset;
extern volatile word __far PackedOutputBytes;
extern volatile word __far PackedReadCursor;
extern byte __far PackedReadBuffer[];

extern void ProbeFloppyReady(void);
extern void MapEmsPages(void);
extern void ShutdownWithError(void);
/* Main-frame near routines run through a thunk that protects the C frame pointer. */
void cache_call_main(main_routine target);
#pragma aux cache_call_main "CACHE_CALL_MAIN" far parm [ax] modify exact [ax bx cx dx si di es]

word cache_probe(main_routine target);
#pragma aux cache_probe "CACHE_PROBE" far parm [ax] value [ax] modify exact [ax bx cx dx si di es]

void cache_map_ems(main_routine target, word pages, word handle);
#pragma aux cache_map_ems "CACHE_MAP_EMS" far parm [ax] [bx] [dx] modify exact [ax bx cx dx si di es]

word cache_get_drive(void);
#pragma aux cache_get_drive "CACHE_GET_DRIVE" far value [ax] modify exact [ax]

void cache_close_file(word handle);
#pragma aux cache_close_file "CACHE_CLOSE_FILE" far parm [bx] modify exact [ax]

dword cache_allocate_dos(word paragraphs);
#pragma aux cache_allocate_dos "CACHE_ALLOCATE_DOS" far parm [bx] value [dx ax] modify exact [ax bx dx]

dword cache_allocate_ems(word pages);
#pragma aux cache_allocate_ems "CACHE_ALLOCATE_EMS" far parm [bx] value [dx ax] modify exact [ax bx cx dx]

void cache_free_ems(word handle);
#pragma aux cache_free_ems "CACHE_FREE_EMS" far parm [dx] modify exact [ax dx]

#define CACHE_AT(segment, offset) \
    (*(byte __far *)((__segment)(segment) :> (void __near *)(offset)))

typedef struct CacheEntry {
    word name;
    word segment;
    word bytes;
    word ems_handle;
    word ems_pages;
} CacheEntry;

/* FileNamePtr is a DS offset. Only A: and B: are candidates; presence means
   exactly 1. The increment deliberately changes the original case, then repeats
   the test so an unavailable A: can advance through B: to C:. */
void advance_ab_colon_prefix(void)
{
    word name = FileNamePtr;
    byte letter;

    for (;;) {
        if (CACHE_AT(MainDataSegment, (word)(name + 1)) != ':') return;
        letter = CACHE_AT(MainDataSegment, name);
        if (letter >= 'a' && letter <= 'z') letter &= 0xDF;
        if (letter == 'A') {
            if (DriveAPresent == 1) return;
        } else if (letter == 'B') {
            if (DriveBPresent == 1) return;
        } else {
            return;
        }
        CACHE_AT(MainDataSegment, name)++;
    }
}

/* Copy with 16-bit offsets and fixed segments, matching REP MOVSB even if either
   endpoint wraps at FFFFh. The source/destination buffers remain DOS-owned. */
void cache_copy_segment(word source_segment, word source_offset,
                                 word destination_segment, word destination_offset,
                                 word bytes)
{
    byte value;
    while (bytes != 0) {
        value = CACHE_AT(source_segment, source_offset);
        CACHE_AT(destination_segment, destination_offset) = value;
        source_offset++;
        destination_offset++;
        bytes--;
    }
}

/* The original entry returns AL=0 on hit and filename_pointer_low|1 on miss.
   Its callers use only ZF, but retaining that AL value keeps the old boundary legible. */
word copy_from_file_cache(void)
{
    CacheEntry *entry = (CacheEntry *)FileCache;
    word requested = FileNamePtr;
    word source_segment;
    word source_bytes;
    word result;

    while (entry->name != 0xFFFF) {
        if (entry->name == requested) {
            source_segment = entry->segment;
            source_bytes = entry->bytes;
            if (source_segment == 0xFFFF) {
                cache_map_ems((main_routine)MapEmsPages,
                                       entry->ems_pages, entry->ems_handle);
                source_segment = EmsPageFrame;
            }
            cache_copy_segment(source_segment, 0,
                                        FileBufferSegment, FileBufferOffset,
                                        source_bytes);
            result = source_segment == EmsPageFrame && entry->segment == 0xFFFF
                   ? 0
                   : (word)(requested & 0xFF00);
            return result;
        }
        entry++;
    }
    return (word)((requested & 0xFF00) | ((byte)requested | 1));
}

/* Cache bytes after decoding, except on Tandy and for resident asset pointers.
   Return the ES value the assembly routine leaves so the entry adapter can preserve it. */
word cache_loaded_file(word es)
{
    word name = FileNamePtr;
    word bytes = FileByteCount;
    word pages = 1;
    word remaining = bytes;
    word destination_segment;
    word cursor;
    word n;
    word resident;
    dword allocation;
    CacheEntry *entry;

    if (VideoAdapter == VIDEO_TANDY) return es;
    resident = (word)ResidentFiles;
    for (;;) {
        word resident_name = *(word *)resident;
        resident = (word)(resident + 2);
        if (resident_name == name) return es;
        if (resident_name == 0xFFFF) break;
    }

    if (EmsAvailable != 0) {
        while (remaining > 0x4000) {
            remaining = (word)(remaining - 0x4000);
            pages++;
        }
        allocation = cache_allocate_ems(pages);
        if ((word)(allocation >> 16) == 0) {
            word handle = (word)allocation;
            cursor = FileCacheEnd;
            entry = (CacheEntry *)cursor;
            entry->name = name;
            entry->segment = 0xFFFF;
            entry->bytes = bytes;
            entry->ems_handle = handle;
            entry->ems_pages = pages;
            FileCacheEnd = (word)(cursor + FILE_CACHE_ENTRY_BYTES);
            cache_map_ems((main_routine)MapEmsPages, pages, handle);
            cache_copy_segment(FileBufferSegment, FileBufferOffset,
                                        EmsPageFrame, 0, bytes);
            return EmsPageFrame;
        }
    }

    /* The original rounds down to paragraphs and then always adds one. Its
       conventional entries also repeat FileByteCount into both unused EMS words. */
    allocation = cache_allocate_dos((word)((bytes >> 4) + 1));
    if ((word)(allocation >> 16) != 0) return es;
    destination_segment = (word)allocation;
    cursor = FileCacheEnd;
    entry = (CacheEntry *)cursor;
    entry->name = name;
    entry->segment = destination_segment;
    entry->bytes = bytes;
    entry->ems_handle = bytes;
    entry->ems_pages = bytes;
    FileCacheEnd = (word)(cursor + FILE_CACHE_ENTRY_BYTES);
    cache_copy_segment(FileBufferSegment, FileBufferOffset,
                                destination_segment, 0, bytes);
    n = destination_segment;
    return n;
}

void release_ems_cache(void)
{
    CacheEntry *entry;
    if (EmsAvailable == 0) return;
    entry = (CacheEntry *)FileCache;
    while (entry->name != 0xFFFF) {
        if (entry->segment == 0xFFFF)
            cache_free_ems(entry->ems_handle);
        entry++;
    }
}

void load_resource_file(DosRegisters *registers)
{
    dword opened;
    word handle;
    word ready;
    PackedLoadResult packed_result;
    EncFileResult enc_result;

    FileStatus = FILE_STATUS_OK;
    if (((byte)copy_from_file_cache()) == 0) {
        registers->es = FileBufferSegment;
        return;
    }

    LoadWordBB82 = 0;
retry_open:
    advance_ab_colon_prefix();
    ready = cache_probe((main_routine)ProbeFloppyReady);
    if (ready == 0) goto open_failed;

    opened = archive_open_by_name(FileNamePtr);
    FileHandle = (word)opened;
    if ((word)(opened >> 16) != 0) goto open_failed;
    handle = (word)opened;

    if (LoadIsEnc != 0) {
        EncFileHandle = handle;
        EncDestSegment = FileBufferSegment;
        EncDestOffset = FileBufferOffset;
        /* The legacy loader ignores DecodeEncFile AX/CF and consumes its low-word
           output counter even when the first DOS read leaves that counter stale. */
        enc_decode_file(&enc_result);
        /* The original leaves the decoder's real ring-write cursor in BP; a failed
           initial read bypasses the stream and therefore leaves caller BP intact. */
        if (enc_result.failed == 0)
            registers->bp = enc_result.bp;
        FileByteCount = EncOutputBytes;
    } else {
        cache_close_file(handle);
        PackedNamePtr = FileNamePtr;
        PackedDestSegment = FileBufferSegment;
        PackedDestOffset = FileBufferOffset;
        /* The former MAIN entry reset these CS words before entering C. */
        PackedOutputBytes = 0;
        PackedReadCursor = (word)(dword)PackedReadBuffer + 0x0200;
        packed_load_file(&packed_result, handle);
        /* LoadResourceFile likewise ignores LoadPackedFile AX/CF/BX. Its cache
           policy uses the output counter and the decoder-entry ES convention. */
        /* The old adapter reports destination ES only after a decoder was entered.
           Open/header failures retain the caller's ES; decode failures still report
           the destination and leave their partial output count available to cache. */
        if (packed_result.started_decoder != 0)
            registers->es = PackedDestSegment;
        FileByteCount = PackedOutputBytes;
    }
    registers->es = cache_loaded_file(registers->es);
    return;

open_failed:
    if (KeyDownTable[SCAN_ESC] == KEY_STATE_DOWN) {
        cache_call_main((main_routine)ShutdownWithError);
        return;
    }
    if ((byte)cache_get_drive() < 2) goto retry_open;
    cache_call_main((main_routine)ShutdownWithError);
}
