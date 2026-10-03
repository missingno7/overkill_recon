/* Service substitutions for bounded tests of the production coordinator.
   The Python fixture supplies the same effects at the oracle ASM boundaries. */
#include "levels.h"
#include "platform_services.h"
#include <stdlib.h>

static void (*service)(word, HostRegisters *);

void level_probe_bind(void (*callback)(word, HostRegisters *))
{
    service = callback;
}

static void forward(word event, DosRegisters *registers)
{
    HostRegisters state = { 0 };
    state.bp = registers->bp;
    state.es = registers->es;
    service(event, &state);
    registers->bp = state.bp;
    registers->es = state.es;
}

void load_resource_file(DosRegisters *registers) { forward(1, registers); }
void system_prompt_load_error_wait_fire(DosRegisters *registers)
{
    forward(2, registers);
}
void clear_key_down_table(void)
{
    HostRegisters state = { 0 };
    service(4, &state);
}
void dos_service(main_routine token, DosRegisters *registers)
{
    if (token != HOST_TOKEN_CLEARWORKSPACE) abort();
    forward(5, registers);
}
void overkill_platform_call(word token, HostRegisters *registers)
{
    if (token == HOST_TOKEN_DECODEGRAPHICSIMAGES) service(3, registers);
    else if (token == HOST_TOKEN_BLITPACKEDTOSCREEN) service(6, registers);
    else abort();
}
