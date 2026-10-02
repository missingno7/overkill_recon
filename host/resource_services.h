#ifndef OVERKILL_HOST_RESOURCE_SERVICES_H
#define OVERKILL_HOST_RESOURCE_SERVICES_H

#include <stdint.h>

/* Map a DOS drive letter to a host directory. Passing NULL unmounts that drive.
   Roots are copied; callers may release their input string after this returns. */
int overkill_resource_mount_drive(char drive_letter, const char *root);
int overkill_resource_drive_is_mounted(char drive_letter);
int overkill_resource_set_current_drive(char drive_letter);
uint8_t overkill_resource_current_drive(void);
int overkill_resource_probe_guest_path(uint16_t segment, uint16_t offset);

/* DOS file operations. Results use DX:AX: high word is CF, low word is the
   DOS handle, transfer count, or error code. Seek returns DX:AX position and
   writes CF to carry_out. A create open truncates or creates for writing. */
uint32_t overkill_resource_open_guest_path(uint16_t segment, uint16_t offset,
                                           int create);
uint32_t overkill_resource_open_path(const char *path, int create);
/* Open an exact host path, bypassing DOS drive mounts (for opt-in user data). */
uint32_t overkill_resource_open_host_path(const char *path, int create);
uint32_t overkill_resource_read(uint16_t handle, uint16_t count,
                                uint16_t segment, uint16_t offset);
uint32_t overkill_resource_write(uint16_t handle, uint16_t count,
                                 uint16_t segment, uint16_t offset);
uint32_t overkill_resource_read_buffer(uint16_t handle, uint16_t count,
                                       void *buffer);
uint32_t overkill_resource_write_buffer(uint16_t handle, uint16_t count,
                                        const void *buffer);
uint32_t overkill_resource_seek(uint16_t handle, uint16_t offset_low,
                                uint16_t offset_high, uint16_t origin,
                                uint16_t *carry_out);
/* Full close result preserves DX:AX (CF, DOS error/zero); close returns DOS AX. */
uint32_t overkill_resource_close_result(uint16_t handle);
uint16_t overkill_resource_close(uint16_t handle);

/* DOS paragraph allocations share one explicitly bound conventional-memory
   pool. Returned segments address the canonical emulated 1 MiB memory arena. */
int overkill_resource_services_bind_arena(uint16_t first_segment,
                                          uint16_t paragraph_count);
uint16_t overkill_dos_allocate_paragraphs(uint16_t paragraph_count);
void overkill_dos_release_paragraphs(uint16_t segment);
uint16_t overkill_dos_get_allocation_strategy(void);
int overkill_dos_set_allocation_strategy(uint16_t strategy);

/* EMS pages are stored by handle and copied through the guest's mapped page
   frame. The game-visible page-frame segment remains its original state word. */
uint32_t overkill_ems_allocate_pages(uint16_t page_count);
int overkill_ems_map_pages(uint16_t page_frame_segment, uint16_t page_count,
                           uint16_t handle);
void overkill_ems_free_pages(uint16_t handle);

#endif
