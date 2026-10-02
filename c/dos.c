/* Register boundary shared by session and page presentation.
   SEGMENT: CGAME
*/
#include "dos.h"

#ifdef OVERKILL_HOST
#include "platform_services.h"

dword dos_call_registers(main_routine target, word bp, word es)
{
    HostRegisters registers = {0};
    registers.bp = bp;
    registers.es = es;
    overkill_platform_call(target, &registers);
    return ((dword)registers.es << 16) | registers.bp;
}

word dos_read_es(void)
{
    return overkill_platform_last_es();
}
#else

dword dos_call_registers(main_routine target, word bp, word es);
#pragma aux dos_call_registers "DOS_CALL_REGISTERS" parm [ax] [si] [di] value [dx ax] modify exact [ax bx cx dx si di es]
#endif

void dos_service(main_routine target, DosRegisters *registers)
{
    dword result = dos_call_registers(target, registers->bp, registers->es);
    registers->bp = (word)result;
    registers->es = (word)(result >> 16);
}
