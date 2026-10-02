#ifndef CACHE_H
#define CACHE_H
#include "dos.h"

/* C-owned cache/resource control over the oracle's existing DOS state. */
void load_resource_file(DosRegisters *registers);
void release_ems_cache(void);
word copy_from_file_cache(void);
word cache_loaded_file(word es);

#endif
