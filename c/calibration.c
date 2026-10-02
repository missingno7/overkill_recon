/* Joystick calibration decisions over the original sample and threshold words.
   Game-port timing remains a DOS service; Esc unwinds through ordinary C returns.
   SEGMENT: CGAME
   OWNS: CalibrateJoystickWithAbort CalibrateJoystickThresholds
   OWNS: AbortJoystickCalibration PollJoystickPrimaryOrAbort WaitJoystickPrimaryRelease
*/
#include "calibration.h"
#include "input_normalize.h"
#include "options.h"
#include "pages.h"

#ifdef OVERKILL_HOST
#include "platform_services.h"
#else
extern void ReadGamePortAAxisCounts(void);
extern void WaitVerticalRetrace(void);
extern void DrawPanelAtPosition(void);
void menu_draw_panel(main_routine target, word position, word image);
#pragma aux menu_draw_panel "FarCallMainNearViaAX" far parm [ax] [dx] [si] modify exact [ax bx cx dx si di es]
#endif

#ifdef OVERKILL_HOST
static dword calibration_read_axes(main_routine target)
{
    HostRegisters call = {0};
    call.ax = target;
    overkill_platform_call(target, &call);
    return ((dword)call.cx << 16) | call.bx;
}

static void calibration_draw_panel(DosRegisters *registers, word position,
                                   word image)
{
    HostRegisters call = {0};
    call.ax = DrawPanelAtPosition;
    call.dx = position;
    call.si = image;
    call.bp = registers->bp;
    call.es = registers->es;
    overkill_platform_call(DrawPanelAtPosition, &call);
    registers->es = call.es;
}
#else
dword calibration_read_axes(main_routine target);
#pragma aux calibration_read_axes "FarCallMainNearViaAX" far parm [ax] value [cx bx] modify exact [ax bx cx dx si]

void calibration_draw_panel(DosRegisters *registers, word position, word image);
#pragma aux calibration_draw_panel parm [si] [di] modify exact [ax es]

void calibration_draw_panel(DosRegisters *registers, word position, word image)
{
    menu_draw_panel(DrawPanelAtPosition, position, image);
    registers->es = dos_read_es();
}
#endif

word poll_joystick_primary_or_abort(void)
{
    if (((volatile byte *)KeyDownTable)[SCAN_ESC] == KEY_STATE_DOWN) return 1;
#ifdef OVERKILL_HOST
    overkill_platform_idle();
#endif
    poll_joystick_input_bits();
    InputBits &= IN_BUTTON_PRIMARY;
    return 0;
}

void wait_joystick_primary_release(void)
{
    word n;
    do {
#ifdef OVERKILL_HOST
        overkill_platform_idle();
#endif
        poll_joystick_input_bits();
        InputBits &= IN_BUTTON_PRIMARY;
    } while (InputBits == IN_BUTTON_PRIMARY);
    for (n = 0; n < 25; n++) menu_call_platform(WaitVerticalRetrace);
}

word calibrate_joystick_thresholds(DosRegisters *registers)
{
    dword axes;
    JoyButtonSelect = JOY_BUTTONS_PORT_A;
    JoyCalUnusedByte = 0;
    show_page_list(GAME_OFFSET(CalibPageList), registers);
    wait_joystick_primary_release();
    for (;;) {
        if (poll_joystick_primary_or_abort()) return 1;
        if (InputBits == IN_BUTTON_PRIMARY) break;
    }
    axes = calibration_read_axes(ReadGamePortAAxisCounts);
    JoyCalLowX = (word)axes;
    JoyCalLowY = (word)(axes >> 16);
    wait_joystick_primary_release();
    calibration_draw_panel(registers, 0x5501, 0x4E);
    for (;;) {
        if (poll_joystick_primary_or_abort()) return 1;
        if (InputBits == IN_BUTTON_PRIMARY) break;
    }
    axes = calibration_read_axes(ReadGamePortAAxisCounts);
    JoyCalHighX = (word)axes;
    JoyCalHighY = (word)(axes >> 16);
    wait_joystick_primary_release();
    calibration_draw_panel(registers, 0x7D01, 0x4F);
    for (;;) {
        if (poll_joystick_primary_or_abort()) return 1;
        if (InputBits == IN_BUTTON_PRIMARY) break;
    }
    axes = calibration_read_axes(ReadGamePortAAxisCounts);
    JoyCalCenterX = (word)axes;
    JoyCalCenterY = (word)(axes >> 16);
    JoyXHighThreshold = JoyCalCenterX + ((word)(JoyCalHighX - JoyCalCenterX) >> 1);
    JoyXLowThreshold = JoyCalLowX + ((word)(JoyCalCenterX - JoyCalLowX) >> 1);
    JoyYHighThreshold = JoyCalCenterY + ((word)(JoyCalHighY - JoyCalCenterY) >> 1);
    JoyYLowThreshold = JoyCalLowY + ((word)(JoyCalCenterY - JoyCalLowY) >> 1);
    return 0;
}

void calibrate_joystick_with_abort(DosRegisters *registers)
{
    InputDeviceMode = INPUT_MODE_JOYSTICK;
    JoyCalibratingFlag = 1;
    /* Only press polls observe Esc. Release waits deliberately do not. */
    InputDeviceMode = calibrate_joystick_thresholds(registers)
                      ? INPUT_MODE_KEYS_A : INPUT_MODE_JOYSTICK;
    JoyCalUnusedByte = 0;
}
