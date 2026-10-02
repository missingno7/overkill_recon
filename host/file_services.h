#ifndef OVERKILL_HOST_FILE_SERVICES_H
#define OVERKILL_HOST_FILE_SERVICES_H

#include "platform_services.h"

/* Handle the original plain DOS file mailbox entries. Return 1 for a handled
   token and 0 when the central dispatcher should try another service group. */
int overkill_file_service(word token, HostRegisters *registers);

/* Route only HISCORE.DAT mailbox requests to this native save directory.
   Passing NULL or an empty path restores the original DOS-drive routing. */
int overkill_file_services_set_save_root(const char *root);

#endif
