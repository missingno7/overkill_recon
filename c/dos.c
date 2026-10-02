/* Register boundary shared by session and page presentation.
   SEGMENT: CGAME
*/
#include "dos.h"

dword dos_call_registers(main_routine target, word bp, word es);
#pragma aux dos_call_registers "DOS_CALL_REGISTERS" parm [ax] [si] [di] value [dx ax] modify exact [ax bx cx dx si di es]

void dos_service(main_routine target, DosRegisters *registers)
{
    dword result = dos_call_registers(target, registers->bp, registers->es);
    registers->bp = (word)result;
    registers->es = (word)(result >> 16);
}
