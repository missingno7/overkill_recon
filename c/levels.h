#ifndef LEVELS_H
#define LEVELS_H
#include "dos.h"

/* C coordinators over the original DOS state and platform services. */
void load_level_map(DosRegisters *registers);
void initialize_level_byte_attributes(void);
void load_graphics_file(DosRegisters *registers);
void load_graphics_record_images(DosRegisters *registers);
void load_graphics_plain(DosRegisters *registers);
void load_graphics_masked(DosRegisters *registers);
void load_common_graphics(DosRegisters *registers);
void load_level_graphics(DosRegisters *registers);
void load_and_show_page(DosRegisters *registers);

#endif
