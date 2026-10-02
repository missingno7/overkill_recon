#ifndef ARCHIVE_H
#define ARCHIVE_H

#include "game.h"

/* The far SEG153A adapter writes status, handle, length-low, length-high here. */
typedef struct ArchiveResult {
    word status;
    word handle;
    word length_low;
    word length_high;
} ArchiveResult;

#ifndef OVERKILL_HOST
void open_resource_file(word name_offset, word name_segment,
                        word result_offset, word result_segment);
#endif

/* Native callers pass a name offset in the state DS. Return DX:AX as status:AX,
   with status 0 and the handle on success, or status 1 and the original error 2. */
dword archive_open_by_name(word name_offset);
#ifndef OVERKILL_HOST
#pragma aux archive_open_by_name parm [si] value [dx ax] \
    modify exact [ax bx cx dx si di es]
#else
void archive_setup_resource_library(void);
#endif

#endif
