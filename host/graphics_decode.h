#ifndef OVERKILL_HOST_GRAPHICS_DECODE_H
#define OVERKILL_HOST_GRAPHICS_DECODE_H

#include "platform_services.h"

/* Native implementation of the original adapter-specific image decoder. */
int overkill_graphics_service(word token, HostRegisters *registers);

#endif
