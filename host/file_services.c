#include "file_services.h"

#include "memory.h"
#include "resource_services.h"

#include "game.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#define FILE_SAVE_ROOT_BYTES 1024u
#define FILE_GUEST_PATH_BYTES 4096u

static char file_save_root[FILE_SAVE_ROOT_BYTES];

int overkill_file_services_set_save_root(const char *root)
{
    size_t length;
    if (root == NULL || root[0] == '\0') {
        file_save_root[0] = '\0';
        return 1;
    }
    length = strlen(root);
    if (length >= sizeof(file_save_root)) return 0;
    memcpy(file_save_root, root, length + 1);
    return 1;
}

static int resource_failed(uint32_t result)
{
    return (result >> 16) != 0;
}

static int guest_path_is_hiscore(void)
{
    const unsigned char *guest = (const unsigned char *)
        overkill_segment_address(MainDataSegment, FileNamePtr);
    const char *name = (const char *)guest;
    size_t length = 0;
    size_t basename = 0;
    static const char hiscore[] = "hiscore.dat";
    size_t i;

    while (length < FILE_GUEST_PATH_BYTES && guest[length] != '\0') {
        if (guest[length] == '/' || guest[length] == '\\') basename = length + 1;
        length++;
    }
    if (length == FILE_GUEST_PATH_BYTES || length - basename != sizeof(hiscore) - 1)
        return 0;
    for (i = 0; i < sizeof(hiscore) - 1; i++) {
        unsigned char value = (unsigned char)name[basename + i];
        if (value >= 'A' && value <= 'Z') value = (unsigned char)(value + ('a' - 'A'));
        if (value != (unsigned char)hiscore[i]) return 0;
    }
    return 1;
}

static uint32_t open_mailbox_path(int create)
{
    if (file_save_root[0] != '\0' && guest_path_is_hiscore()) {
        char path[FILE_SAVE_ROOT_BYTES + sizeof("/hiscore.dat")];
        size_t length = strlen(file_save_root);
        int has_separator = file_save_root[length - 1] == '/' ||
                            file_save_root[length - 1] == '\\';
        memcpy(path, file_save_root, length);
        if (has_separator) {
            memcpy(path + length, "hiscore.dat", sizeof("hiscore.dat"));
        } else {
            memcpy(path + length, "/hiscore.dat", sizeof("/hiscore.dat"));
        }
        return overkill_resource_open_host_path(path, create);
    }
    return overkill_resource_open_guest_path(MainDataSegment, FileNamePtr, create);
}

static void load_file_to_buffer(void)
{
    uint32_t result;
    word handle;

    FileStatus = FILE_STATUS_OK;
    result = open_mailbox_path(0);
    if (resource_failed(result)) {
        FileStatus = FILE_STATUS_OPEN_FAILED;
        return;
    }

    handle = (word)result;
    FileHandle = handle;
    result = overkill_resource_read(handle, 0xFFFF, FileBufferSegment,
                                    FileBufferOffset);
    if (resource_failed(result)) {
        /* The DOS error unwind returns before CloseFileHandle on a failed read. */
        FileStatus = FILE_STATUS_READ_FAILED;
        return;
    }

    FileByteCount = (word)result;
    /* A close failure exits through the same unwind but leaves FileStatus OK. */
    (void)overkill_resource_close_result(handle);
}

static void save_buffer_to_file(void)
{
    uint32_t result;
    word handle;

    result = open_mailbox_path(1);
    if (resource_failed(result)) return;

    handle = (word)result;
    FileHandle = handle;
    result = overkill_resource_write(handle, FileByteCount, FileBufferSegment,
                                     FileBufferOffset);
    if (resource_failed(result)) {
        /* Write errors use the DOS nonlocal return and leave the handle open. */
        return;
    }

    /* Create/write/close failures do not update FileStatus in the original. */
    (void)overkill_resource_close_result(handle);
}

int overkill_file_service(word token, HostRegisters *registers)
{
    if (registers == 0) return 0;
    if (token == HOST_TOKEN_LOADFILETOBUFFER) {
        load_file_to_buffer();
        return 1;
    }
    if (token == HOST_TOKEN_SAVEBUFFERTOFILE) {
        save_buffer_to_file();
        return 1;
    }
    return 0;
}
