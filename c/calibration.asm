; Remaining menu adapter retains the observable calibration-entry SP mailbox.
locals
extrn CALIBRATE_JOYSTICK_WITH_ABORT:near
extrn JoyCalAbortSp:word
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public CalibrateJoystickWithAbort
CalibrateJoystickWithAbort:
    mov word ptr ds:[JoyCalAbortSp], sp
    push es
    push bp
    push si
    mov si, sp
    add si, 2
    call CALIBRATE_JOYSTICK_WITH_ABORT
    pop si
    pop bp
    pop es
    ret
MAIN ends
end
