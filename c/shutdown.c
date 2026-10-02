/* Non-returning shutdown order over the original state, with machine termination
   and DOS/BIOS operations kept behind named ASM services.
   SEGMENT: CGAME
   OWNS: ShutdownGame
*/
#include "shutdown.h"
#include "cache.h"
#include "settings.h"

extern void ResetEgaPages(void);
extern void StopModuleMusic(void);
extern void RestoreKeyboardVector09(void);
extern void RestoreTimerVector08(void);
extern void ShutdownSetTextMode3(void);
extern void ShutdownPrintDosStringAtBP(void);
extern void ShutdownPresentExitOrderAndFlushKeys(void);
extern void ShutdownRestoreAllocStrategy(void);
extern void ShutdownExitToDos(void);
extern word __far MainDataSegment;

void shutdown_print_dos_string(DosRegisters *registers, word offset)
{
    word saved_bp = registers->bp;
    registers->bp = offset;
    dos_service(ShutdownPrintDosStringAtBP, registers);
    registers->bp = saved_bp;
}

void shutdown_game(DosRegisters *registers)
{
    word saved_file_name = FileNamePtr;

    save_hiscore_file();
    registers->es = MainDataSegment;
    FileNamePtr = saved_file_name;
    dos_service(ResetEgaPages, registers);
    dos_service(StopModuleMusic, registers);
    dos_service(RestoreKeyboardVector09, registers);
    dos_service(RestoreTimerVector08, registers);
    dos_service(ShutdownSetTextMode3, registers);

    if (ExitWithError != 0) {
        volatile byte *name;
        word print_name = FileNamePtr;
        shutdown_print_dos_string(registers, (word)FileNotFoundMsgHead);
        name = (volatile byte *)print_name;
        while (*name != 0) name++;
        *name = 0x24;
        if (*((volatile byte *)(word)(print_name + 1)) == 0x3A)
            print_name += 2;
        shutdown_print_dos_string(registers, print_name);
        shutdown_print_dos_string(registers, (word)FileNotFoundMsgTail);
    } else {
        dos_service(ShutdownPresentExitOrderAndFlushKeys, registers);
    }

    release_ems_cache();
    dos_service(ShutdownRestoreAllocStrategy, registers);
    dos_service(ShutdownExitToDos, registers);
}
