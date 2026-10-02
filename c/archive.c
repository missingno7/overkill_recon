/* SHADOW archive search over the oracle's SEG153A state.

   SEGMENT: CGAME
   OWNS: OpenResourceFile

   The far entry stays in SEG153A. This body owns no persistent C data: archive
   cursor, rolling key, header, entry buffer, and handle remain the original fields.
   DOS open/read/seek/close are narrow assembly services so the search logic can be
   exercised without booting the game. */
#include "archive.h"

extern word __far ResOptions;
extern word __far ResCurArchive;
extern word __far ResSearchStart;
extern word __far ResHandle;
extern dword __far ResNamePtr;
extern word __far ResEntryCount;
extern word __far ResKey;
extern byte __far ResSignature[];
extern word __far ResEntrySize;
extern byte __far ShadowSignature[];
extern byte __far ResEntryBuf[];
extern dword __far ResArchiveBase;
extern byte __far ResArchiveList[];
extern word __far MainDataSegment;

#define ARCHIVE_ADDRESS(type, segment, offset) \
    ((type __far *)((__segment)(segment) :> ((type __based(void) *)(offset))))
#define ARCHIVE_LABEL_SEGMENT(label) \
    ((word)((dword)(byte __far *)&(label) >> 16))
#define ARCHIVE_LABEL_OFFSET(label) \
    ((word)(dword)(byte __far *)&(label))
#define ARCHIVE_LIST_AT(offset) \
    (((__segment)ARCHIVE_LABEL_SEGMENT(ResArchiveList)) :> \
     ((byte __based(void) *)(offset)))
#define ARCHIVE_ENTRY_AT(offset) \
    (((__segment)ARCHIVE_LABEL_SEGMENT(ResEntryBuf)) :> \
     ((byte __based(void) *)(offset)))

/* DOS returns carry separately from AX. Seek also returns DX:AX and stores CF in
   the caller's stack word so both the full position and failure state survive. */
dword archive_dos_open(word path_segment, word path_offset);
#pragma aux archive_dos_open "ARCHIVE_DOS_OPEN" far parm [cx] [si] \
    value [dx ax] modify exact [ax bx cx dx si di es]

dword archive_dos_read(word handle, word byte_count,
                                word buffer_segment, word buffer_offset);
#pragma aux archive_dos_read "ARCHIVE_DOS_READ" far parm [bx] [cx] [si] [di] \
    value [dx ax] modify exact [ax bx cx dx si es]

dword archive_dos_seek(word handle, word offset_low, word offset_high,
                                word origin, word *carry_out);
#pragma aux archive_dos_seek "ARCHIVE_DOS_SEEK" far \
    parm [bx] [cx] [di] [si] value [dx ax] \
    modify exact [ax bx cx dx si di]

word archive_dos_close(word handle);
#pragma aux archive_dos_close "ARCHIVE_DOS_CLOSE" far parm [bx] \
    value [ax] modify exact [ax bx]

word archive_path_offset(word segment, word offset)
{
    byte __far *name = ARCHIVE_ADDRESS(byte, segment, offset);
    word last = offset;

    if ((ResOptions & 2) == 0) return offset;
    while (*name != 0) {
        if (*name == '\\') last = (word)(offset + 1);
        name++;
        offset++;
    }
    return last;
}

word archive_name_matches(word name_segment, word name_offset,
                                   word entry_offset)
{
    byte __far *name = ARCHIVE_ADDRESS(byte, name_segment, name_offset);
    byte __far *entry;
    byte requested;
    byte archived;

    entry_offset = (word)(entry_offset + 13);
    if (ResOptions & 2) {
        word cursor = entry_offset;
        word last = entry_offset;
        byte __far *scan = ARCHIVE_ENTRY_AT(cursor);
        while (*scan != 0) {
            if (*scan == '\\') last = (word)(cursor + 1);
            scan++;
            cursor++;
        }
        entry_offset = last;
    }
    entry = ARCHIVE_ENTRY_AT(entry_offset);

    for (;;) {
        while (*name == ' ') { name++; name_offset++; }
        while (*entry == ' ') { entry++; entry_offset++; }

        requested = *name++;
        name_offset++;
        archived = *entry++;
        entry_offset++;
        if (requested >= 'a' && requested <= 'z') requested &= 0x5F;
        if (requested != archived) return 0;
        if (requested == 0) return archived == 0;
    }
}

void archive_set_result(word result_segment, word result_offset,
                                 word status, word handle,
                                 word length_low, word length_high)
{
    ArchiveResult __far *result = ARCHIVE_ADDRESS(ArchiveResult,
                                                   result_segment, result_offset);
    result->status = status;
    result->handle = handle;
    result->length_low = length_low;
    result->length_high = length_high;
}

void open_resource_file(word name_offset, word name_segment,
                                 word result_offset, word result_segment)
#pragma aux open_resource_file parm [dx] [cx] [si] [di] \
    modify exact [ax bx cx dx si di es]
{
    dword io;
    dword position;
    dword entry_offset;
    dword entry_length;
    word archive_segment = ARCHIVE_LABEL_SEGMENT(ResArchiveList);
    word path_offset;
    word search_start;
    word cursor;
    word i;
    word low_key;
    word key_step;
    word read_failed;

    ResNamePtr = ((dword)name_segment << 16) | name_offset;
    ResHandle = 0;
    if (ResOptions & 1) goto open_loose_file;

    search_start = ResCurArchive;
    ResSearchStart = search_start;
    for (;;) {
        io = archive_dos_open(archive_segment, ResCurArchive);
        if ((word)(io >> 16) != 0) goto try_next_archive;
        ResHandle = (word)io;
        ResArchiveBase = 0;

        /* The original accepts successful short DOS reads; only CF rejects them. */
        io = archive_dos_read(ResHandle, 12,
                                       ARCHIVE_LABEL_SEGMENT(ResEntryCount),
                                       ARCHIVE_LABEL_OFFSET(ResEntryCount));
        if ((word)(io >> 16) != 0) goto try_next_archive;

        if (ResEntryCount == 0x5A4D) {
            /* This is the original 16-bit MZ page-count arithmetic, including its
               wrap before conversion to the 24-bit byte offset. */
            word pages = (word)(ResSignature[0] | ((word)ResSignature[1] << 8));
            word last_page_bytes = ResKey;
            word page_word = (word)((word)(pages - 1) * 2);
            ResArchiveBase = ((dword)page_word << 8) + last_page_bytes;
            position = archive_dos_seek(ResHandle,
                                                 (word)ResArchiveBase,
                                                 (word)(ResArchiveBase >> 16),
                                                 0, &read_failed);
            if (read_failed != 0) goto try_next_archive;
            io = archive_dos_read(ResHandle, 12,
                                           ARCHIVE_LABEL_SEGMENT(ResEntryCount),
                                           ARCHIVE_LABEL_OFFSET(ResEntryCount));
            if ((word)(io >> 16) != 0) goto try_next_archive;
        }

        for (i = 0; i != 6; i++)
            if (ResSignature[i] != ShadowSignature[i]) goto try_next_archive;
        if (ResEntryCount == 0 || ResEntryCount >= 0x0320)
            goto try_next_archive;

        path_offset = archive_path_offset(name_segment, name_offset);
        for (;;) {
            io = archive_dos_read(ResHandle, ResEntrySize,
                                           ARCHIVE_LABEL_SEGMENT(ResEntryBuf),
                                           (word)ResEntryBuf);
            if ((word)(io >> 16) != 0) goto try_next_archive;

            low_key = (byte)ResKey;
            key_step = (byte)(ResKey >> 8);
            i = 0;
            do {
                byte __far *entry_byte = ARCHIVE_ENTRY_AT((word)((word)ResEntryBuf + i));
                *entry_byte ^= (byte)low_key;
                low_key = (byte)(low_key + key_step);
                i++;
            } while (i != ResEntrySize);
            ResKey = (ResKey & 0xFF00) | low_key;

            if (archive_name_matches(name_segment, path_offset,
                                              (word)ResEntryBuf)) {
                byte __far *entry = ResEntryBuf;
                entry_offset = (dword)entry[5]
                             | ((dword)entry[6] << 8)
                             | ((dword)entry[7] << 16)
                             | ((dword)entry[8] << 24);
                entry_length = (dword)entry[9]
                             | ((dword)entry[10] << 8)
                             | ((dword)entry[11] << 16)
                             | ((dword)entry[12] << 24);
                entry_offset += ResArchiveBase;
                position = archive_dos_seek(ResHandle,
                                                     (word)entry_offset,
                                                     (word)(entry_offset >> 16),
                                                     0, &read_failed);
                if (read_failed != 0) goto try_next_archive;
                archive_set_result(result_segment, result_offset, 0,
                                            ResHandle, (word)entry_length,
                                            (word)(entry_length >> 16));
                return;
            }

            ResEntryCount = (word)(ResEntryCount - 1);
            if (ResEntryCount == 0) goto try_next_archive;
        }

try_next_archive:
        if (ResHandle != 0 && archive_dos_close(ResHandle) != 0)
            goto not_found;

        cursor = ResCurArchive;
        while (*ARCHIVE_LIST_AT(cursor) != 0) cursor++;
        cursor++;
        if (*ARCHIVE_LIST_AT(cursor) == 0xFF) cursor = (word)ResArchiveList;
        ResCurArchive = cursor;
        if (cursor == search_start) goto not_found;
    }

open_loose_file:
    path_offset = archive_path_offset(name_segment, name_offset);
    io = archive_dos_open(name_segment, path_offset);
    if ((word)(io >> 16) != 0) goto not_found;
    ResHandle = (word)io;

    position = archive_dos_seek(ResHandle, 0, 0, 2, &read_failed);
    if (read_failed != 0) goto not_found;
    if (archive_dos_seek(ResHandle, 0, 0, 0, &read_failed),
        read_failed != 0) goto not_found;
    archive_set_result(result_segment, result_offset, 0,
                                ResHandle, (word)position,
                                (word)(position >> 16));
    return;

not_found:
    if (ResHandle != 0) (void)archive_dos_close(ResHandle);
    archive_set_result(result_segment, result_offset, 1,
                                ResHandle, 0, 0);
}

dword archive_open_by_name(word name_offset)
{
    ArchiveResult result;

    open_resource_file(name_offset, MainDataSegment,
                       (word)&result, MainDataSegment);
    return ((dword)result.status << 16) |
           (result.status != 0 ? 2 : result.handle);
}
