#include "resource_services.h"

#include "memory.h"

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define RESOURCE_DRIVE_COUNT 26u
#define RESOURCE_ROOT_BYTES 1024u
#define RESOURCE_PATH_BYTES 4096u
#define RESOURCE_FILE_HANDLES 256u
#define RESOURCE_FIRST_HANDLE 5u
#define RESOURCE_MAX_BLOCKS 4096u
#define RESOURCE_MAX_EMS_HANDLES 256u
#define EMS_PAGE_BYTES 0x4000u
#define DOS_PHYSICAL_LIMIT 0x100000u
#define DOS_CONVENTIONAL_LIMIT 0xA0000u

typedef struct ResourceDrive {
    char root[RESOURCE_ROOT_BYTES];
    int mounted;
} ResourceDrive;

typedef struct ParagraphBlock {
    uint16_t segment;
    uint16_t paragraphs;
} ParagraphBlock;

typedef struct ParagraphAllocation {
    uint16_t segment;
    uint16_t paragraphs;
    int used;
} ParagraphAllocation;

typedef struct EmsAllocation {
    unsigned char *bytes;
    uint16_t pages;
} EmsAllocation;

static ResourceDrive resource_drives[RESOURCE_DRIVE_COUNT];
static uint8_t current_drive = 2;
static FILE *resource_files[RESOURCE_FILE_HANDLES];

static ParagraphBlock free_blocks[RESOURCE_MAX_BLOCKS];
static ParagraphAllocation allocations[RESOURCE_MAX_BLOCKS];
static size_t free_block_count;
static uint16_t allocation_strategy;

static EmsAllocation ems_allocations[RESOURCE_MAX_EMS_HANDLES];
static uint16_t mapped_ems_handle;
static uint16_t mapped_ems_pages;
static uint16_t mapped_frame_segment;

static int resource_drive_index(char letter)
{
    if (letter >= 'a' && letter <= 'z') letter = (char)(letter - 'a' + 'A');
    if (letter < 'A' || letter > 'Z') return -1;
    return (unsigned char)(letter - 'A');
}

static int resource_is_directory(const char *path)
{
    struct stat info;
    return stat(path, &info) == 0 && S_ISDIR(info.st_mode);
}

int overkill_resource_mount_drive(char drive_letter, const char *root)
{
    int drive = resource_drive_index(drive_letter);
    size_t length;

    if (drive < 0) return 0;
    if (root == NULL) {
        resource_drives[drive].root[0] = '\0';
        resource_drives[drive].mounted = 0;
        return 1;
    }

    length = strlen(root);
    if (length == 0 || length >= RESOURCE_ROOT_BYTES || !resource_is_directory(root))
        return 0;
    memcpy(resource_drives[drive].root, root, length + 1);
    while (length > 1 && (resource_drives[drive].root[length - 1] == '/' ||
                          resource_drives[drive].root[length - 1] == '\\'))
        resource_drives[drive].root[--length] = '\0';
    resource_drives[drive].mounted = 1;
    return 1;
}

int overkill_resource_drive_is_mounted(char drive_letter)
{
    int drive = resource_drive_index(drive_letter);
    if (drive < 0 || !resource_drives[drive].mounted) return 0;
    return resource_is_directory(resource_drives[drive].root);
}

int overkill_resource_set_current_drive(char drive_letter)
{
    int drive = resource_drive_index(drive_letter);
    if (drive < 0) return 0;
    current_drive = (uint8_t)drive;
    return 1;
}

uint8_t overkill_resource_current_drive(void)
{
    return current_drive;
}

static int resource_guest_string(uint16_t segment, uint16_t offset,
                                 char *destination, size_t capacity)
{
    size_t i;
    if (destination == NULL || capacity == 0) return 0;
    for (i = 0; i + 1 < capacity; i++) {
        char value = *(const char *)overkill_segment_address(segment,
                                                            (uint16_t)(offset + i));
        destination[i] = value;
        if (value == '\0') return 1;
    }
    destination[capacity - 1] = '\0';
    return 0;
}

static int resource_resolve_path(const char *path, char *destination,
                                 size_t capacity, int require_mount)
{
    const char *relative = path;
    const char *root = NULL;
    size_t root_length = 0;
    size_t relative_length;
    int drive = -1;
    size_t i;

    if (path == NULL || destination == NULL || capacity == 0) return 0;
    if (((path[0] >= 'A' && path[0] <= 'Z') ||
         (path[0] >= 'a' && path[0] <= 'z')) && path[1] == ':') {
        drive = resource_drive_index(path[0]);
        relative = path + 2;
    } else {
        drive = current_drive;
    }

    if (drive >= 0 && resource_drives[drive].mounted) {
        root = resource_drives[drive].root;
        root_length = strlen(root);
    } else if (drive >= 0 && require_mount) {
        return 0;
    }

    while (*relative == '\\' || *relative == '/') relative++;
    relative_length = strlen(relative);
    if (root == NULL) {
        if (relative_length + 1 > capacity) return 0;
        memcpy(destination, relative, relative_length + 1);
    } else {
        size_t separator = root_length != 0 && relative_length != 0 ? 1 : 0;
        if (root_length + separator + relative_length + 1 > capacity) return 0;
        memcpy(destination, root, root_length);
        if (separator) destination[root_length] = '/';
        memcpy(destination + root_length + separator, relative,
               relative_length + 1);
    }

    for (i = 0; destination[i] != '\0'; i++)
        if (destination[i] == '\\') destination[i] = '/';
    return 1;
}

int overkill_resource_probe_guest_path(uint16_t segment, uint16_t offset)
{
    char path[RESOURCE_PATH_BYTES];
    char resolved[RESOURCE_PATH_BYTES];
    int drive = current_drive;

    if (!resource_guest_string(segment, offset, path, sizeof(path))) return 0;
    if (((path[0] >= 'A' && path[0] <= 'Z') ||
         (path[0] >= 'a' && path[0] <= 'z')) && path[1] == ':')
        drive = resource_drive_index(path[0]);
    if (drive >= 0 && drive < 2)
        return resource_drives[drive].mounted &&
               resource_is_directory(resource_drives[drive].root);
    if (!resource_resolve_path(path, resolved, sizeof(resolved), 0)) return 0;
    if (drive >= 0 && resource_drives[drive].mounted)
        return resource_is_directory(resource_drives[drive].root);
    return 1;
}

static uint16_t resource_dos_error(void)
{
    switch (errno) {
    case ENOENT: return 2;
    case ENOTDIR: return 3;
    case EMFILE: return 4;
    case EACCES:
    case EROFS: return 5;
    default: return 5;
    }
}

static uint32_t resource_open_resolved_path(const char *path, int create)
{
    FILE *file;
    unsigned handle;

    file = fopen(path, create ? "wb" : "rb");
    if (file == NULL) return 0x00010000u | resource_dos_error();
    for (handle = RESOURCE_FIRST_HANDLE; handle < RESOURCE_FILE_HANDLES; handle++) {
        if (resource_files[handle] == NULL) {
            resource_files[handle] = file;
            return handle;
        }
    }
    (void)fclose(file);
    return 0x00010004u;
}

uint32_t overkill_resource_open_path(const char *path, int create)
{
    char resolved[RESOURCE_PATH_BYTES];
    if (!resource_resolve_path(path, resolved, sizeof(resolved), 1))
        return 0x00010002u;
    return resource_open_resolved_path(resolved, create);
}

uint32_t overkill_resource_open_host_path(const char *path, int create)
{
    if (path == NULL || path[0] == '\0' || strlen(path) >= RESOURCE_PATH_BYTES)
        return 0x00010003u;
    return resource_open_resolved_path(path, create);
}

uint32_t overkill_resource_open_guest_path(uint16_t segment, uint16_t offset,
                                           int create)
{
    char path[RESOURCE_PATH_BYTES];
    if (!resource_guest_string(segment, offset, path, sizeof(path)))
        return 0x00010003u;
    return overkill_resource_open_path(path, create);
}

static FILE *resource_file(uint16_t handle)
{
    if (handle < RESOURCE_FIRST_HANDLE || handle >= RESOURCE_FILE_HANDLES)
        return NULL;
    return resource_files[handle];
}

static void *resource_guest_address(uint16_t segment, uint16_t offset,
                                    uint16_t byte_index)
{
    return overkill_segment_address(segment, (uint16_t)(offset + byte_index));
}

uint32_t overkill_resource_read_buffer(uint16_t handle, uint16_t count,
                                       void *buffer)
{
    FILE *file = resource_file(handle);
    size_t bytes;
    if (file == NULL || (buffer == NULL && count != 0)) return 0x00010006u;
    bytes = fread(buffer, 1, count, file);
    if (bytes < count && ferror(file)) return 0x00010005u;
    return (uint32_t)(uint16_t)bytes;
}

uint32_t overkill_resource_write_buffer(uint16_t handle, uint16_t count,
                                        const void *buffer)
{
    FILE *file = resource_file(handle);
    size_t bytes;
    if (file == NULL || (buffer == NULL && count != 0)) return 0x00010006u;
    bytes = fwrite(buffer, 1, count, file);
    if (bytes < count) return 0x00010005u;
    return (uint32_t)(uint16_t)bytes;
}

uint32_t overkill_resource_read(uint16_t handle, uint16_t count,
                                uint16_t segment, uint16_t offset)
{
    FILE *file = resource_file(handle);
    uint16_t i;
    int value;
    if (file == NULL) return 0x00010006u;
    for (i = 0; i < count; i++) {
        value = fgetc(file);
        if (value == EOF) {
            if (ferror(file)) return 0x00010005u;
            break;
        }
        *(unsigned char *)resource_guest_address(segment, offset, i) =
            (unsigned char)value;
    }
    return i;
}

uint32_t overkill_resource_write(uint16_t handle, uint16_t count,
                                 uint16_t segment, uint16_t offset)
{
    FILE *file = resource_file(handle);
    uint16_t i;
    int result;
    if (file == NULL) return 0x00010006u;
    for (i = 0; i < count; i++) {
        result = fputc(*(const unsigned char *)resource_guest_address(segment,
                                                                      offset, i),
                       file);
        if (result == EOF) return 0x00010005u;
    }
    return count;
}

uint32_t overkill_resource_seek(uint16_t handle, uint16_t offset_low,
                                uint16_t offset_high, uint16_t origin,
                                uint16_t *carry_out)
{
    FILE *file = resource_file(handle);
    int mode;
    int32_t distance = (int32_t)(((uint32_t)offset_high << 16) | offset_low);
    long position;

    if (carry_out != NULL) *carry_out = 1;
    if (file == NULL) return 0;
    if (origin == 0) mode = SEEK_SET;
    else if (origin == 1) mode = SEEK_CUR;
    else if (origin == 2) mode = SEEK_END;
    else return 0;
    if (fseek(file, (long)distance, mode) != 0) return 0;
    position = ftell(file);
    if (position < 0 || (uint64_t)position > UINT32_MAX) return 0;
    if (carry_out != NULL) *carry_out = 0;
    return (uint32_t)position;
}

uint32_t overkill_resource_close_result(uint16_t handle)
{
    FILE *file = resource_file(handle);
    int result;
    if (file == NULL) return 0x00010006u;
    resource_files[handle] = NULL;
    result = fclose(file);
    return result == 0 ? 0 : (0x00010000u | resource_dos_error());
}

uint16_t overkill_resource_close(uint16_t handle)
{
    return (uint16_t)overkill_resource_close_result(handle);
}

int overkill_resource_services_bind_arena(uint16_t first_segment,
                                          uint16_t paragraph_count)
{
    uint32_t first = (uint32_t)first_segment << 4;
    uint32_t end = first + ((uint32_t)paragraph_count << 4);

    if (paragraph_count == 0 || first == 0 || end > DOS_CONVENTIONAL_LIMIT ||
        end > DOS_PHYSICAL_LIMIT ||
        (uint32_t)first_segment + paragraph_count > 0x10000u)
        return 0;
    memset(free_blocks, 0, sizeof(free_blocks));
    memset(allocations, 0, sizeof(allocations));
    free_blocks[0].segment = first_segment;
    free_blocks[0].paragraphs = paragraph_count;
    free_block_count = 1;
    return 1;
}

uint16_t overkill_dos_allocate_paragraphs(uint16_t paragraph_count)
{
    size_t i, allocation_slot, selected = RESOURCE_MAX_BLOCKS;
    uint16_t smallest = UINT16_MAX;
    uint16_t segment;

    if (paragraph_count == 0 || free_block_count == 0) return 0;
    for (allocation_slot = 0; allocation_slot < RESOURCE_MAX_BLOCKS; allocation_slot++)
        if (!allocations[allocation_slot].used) break;
    if (allocation_slot == RESOURCE_MAX_BLOCKS) return 0;

    for (i = 0; i < free_block_count; i++) {
        if (free_blocks[i].paragraphs < paragraph_count) continue;
        if (allocation_strategy == 0) {
            selected = i;
            break;
        }
        if (allocation_strategy == 1) {
            if (free_blocks[i].paragraphs < smallest) {
                selected = i;
                smallest = free_blocks[i].paragraphs;
            }
        } else {
            selected = i;
        }
    }
    if (selected != RESOURCE_MAX_BLOCKS) {
        i = selected;
        segment = free_blocks[i].segment;
        allocations[allocation_slot].segment = segment;
        allocations[allocation_slot].paragraphs = paragraph_count;
        allocations[allocation_slot].used = 1;
        free_blocks[i].segment = (uint16_t)(free_blocks[i].segment + paragraph_count);
        free_blocks[i].paragraphs =
            (uint16_t)(free_blocks[i].paragraphs - paragraph_count);
        if (free_blocks[i].paragraphs == 0) {
            memmove(&free_blocks[i], &free_blocks[i + 1],
                    (free_block_count - i - 1) * sizeof(free_blocks[0]));
            free_block_count--;
        }
        return segment;
    }
    return 0;
}

void overkill_dos_release_paragraphs(uint16_t segment)
{
    size_t i, insertion;
    ParagraphBlock returned;

    for (i = 0; i < RESOURCE_MAX_BLOCKS; i++) {
        if (allocations[i].used && allocations[i].segment == segment) break;
    }
    if (i == RESOURCE_MAX_BLOCKS || free_block_count >= RESOURCE_MAX_BLOCKS) return;
    returned.segment = allocations[i].segment;
    returned.paragraphs = allocations[i].paragraphs;
    allocations[i].used = 0;

    insertion = 0;
    while (insertion < free_block_count &&
           free_blocks[insertion].segment < returned.segment)
        insertion++;
    memmove(&free_blocks[insertion + 1], &free_blocks[insertion],
            (free_block_count - insertion) * sizeof(free_blocks[0]));
    free_blocks[insertion] = returned;
    free_block_count++;

    if (insertion > 0 &&
        (uint32_t)free_blocks[insertion - 1].segment +
            free_blocks[insertion - 1].paragraphs == free_blocks[insertion].segment) {
        free_blocks[insertion - 1].paragraphs =
            (uint16_t)(free_blocks[insertion - 1].paragraphs +
                       free_blocks[insertion].paragraphs);
        memmove(&free_blocks[insertion], &free_blocks[insertion + 1],
                (free_block_count - insertion - 1) * sizeof(free_blocks[0]));
        free_block_count--;
        insertion--;
    }
    if (insertion + 1 < free_block_count &&
        (uint32_t)free_blocks[insertion].segment +
            free_blocks[insertion].paragraphs == free_blocks[insertion + 1].segment) {
        free_blocks[insertion].paragraphs =
            (uint16_t)(free_blocks[insertion].paragraphs +
                       free_blocks[insertion + 1].paragraphs);
        memmove(&free_blocks[insertion + 1], &free_blocks[insertion + 2],
                (free_block_count - insertion - 2) * sizeof(free_blocks[0]));
        free_block_count--;
    }
}

uint16_t overkill_dos_get_allocation_strategy(void)
{
    return allocation_strategy;
}

int overkill_dos_set_allocation_strategy(uint16_t strategy)
{
    if (strategy > 2) return 0;
    allocation_strategy = strategy;
    return 1;
}

static EmsAllocation *resource_ems_entry(uint16_t handle)
{
    if (handle == 0 || handle >= RESOURCE_MAX_EMS_HANDLES) return NULL;
    if (ems_allocations[handle].bytes == NULL) return NULL;
    return &ems_allocations[handle];
}

uint32_t overkill_ems_allocate_pages(uint16_t page_count)
{
    unsigned handle;
    unsigned char *storage;
    if (page_count == 0 || page_count > 4) return 0x00800000u;
    for (handle = 1; handle < RESOURCE_MAX_EMS_HANDLES; handle++)
        if (ems_allocations[handle].bytes == NULL) break;
    if (handle == RESOURCE_MAX_EMS_HANDLES) return 0x00800000u;
    storage = (unsigned char *)calloc(page_count, EMS_PAGE_BYTES);
    if (storage == NULL) return 0x00800000u;
    ems_allocations[handle].bytes = storage;
    ems_allocations[handle].pages = page_count;
    return handle;
}

static void resource_copy_frame_to_ems(void)
{
    EmsAllocation *allocation = resource_ems_entry(mapped_ems_handle);
    uint16_t page, byte_index, pages;
    if (allocation == NULL) return;
    pages = mapped_ems_pages < allocation->pages
          ? mapped_ems_pages : allocation->pages;
    for (page = 0; page < pages; page++) {
        for (byte_index = 0; byte_index < EMS_PAGE_BYTES; byte_index++) {
            allocation->bytes[(size_t)page * EMS_PAGE_BYTES + byte_index] =
                *(unsigned char *)overkill_segment_address(
                    mapped_frame_segment,
                    (uint16_t)((uint32_t)page * EMS_PAGE_BYTES + byte_index));
        }
    }
}

static void resource_copy_ems_to_frame(EmsAllocation *allocation,
                                       uint16_t frame_segment,
                                       uint16_t page_count)
{
    uint16_t page, byte_index;
    uint16_t pages = page_count < allocation->pages ? page_count : allocation->pages;
    for (page = 0; page < pages; page++) {
        for (byte_index = 0; byte_index < EMS_PAGE_BYTES; byte_index++) {
            *(unsigned char *)overkill_segment_address(
                frame_segment,
                (uint16_t)((uint32_t)page * EMS_PAGE_BYTES + byte_index)) =
                allocation->bytes[(size_t)page * EMS_PAGE_BYTES + byte_index];
        }
    }
}

int overkill_ems_map_pages(uint16_t page_frame_segment, uint16_t page_count,
                           uint16_t handle)
{
    EmsAllocation *allocation = resource_ems_entry(handle);
    if (allocation == NULL || page_count == 0) return 0;
    resource_copy_frame_to_ems();
    resource_copy_ems_to_frame(allocation, page_frame_segment, page_count);
    mapped_ems_handle = handle;
    mapped_ems_pages = page_count;
    mapped_frame_segment = page_frame_segment;
    return 1;
}

void overkill_ems_free_pages(uint16_t handle)
{
    EmsAllocation *allocation = resource_ems_entry(handle);
    if (allocation == NULL) return;
    if (mapped_ems_handle == handle) {
        resource_copy_frame_to_ems();
        mapped_ems_handle = 0;
        mapped_ems_pages = 0;
        mapped_frame_segment = 0;
    }
    free(allocation->bytes);
    allocation->bytes = NULL;
    allocation->pages = 0;
}
