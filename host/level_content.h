#ifndef OVERKILL_LEVEL_CONTENT_H
#define OVERKILL_LEVEL_CONTENT_H
#include <stddef.h>
#include <stdint.h>

/* Transitional loose content: current supported owned data plus an explicit
   original behavior profile. No additional slot in the historical DS tables. */
int overkill_level_content_load(const char *directory, const char *original_directory,
                               char *error, size_t error_size);
void overkill_level_content_unload(void);
const char *overkill_level_content_id(void);
uint16_t overkill_level_content_behavior_profile(void);
int overkill_level_content_copy_map(void);
#endif
