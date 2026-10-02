; Joystick normalization and key clearing keep their original near service names.
locals
extrn POLL_JOYSTICK_INPUT_BITS:near
extrn CLEAR_KEY_DOWN_TABLE:near
extrn StateData:byte
include HARDWARE.INC
include INPUT.INC
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public PollJoystickInputBits, ReadGamePortAButtonBits, ClearKeyDownTable
; The original entry replaces DS with the game state segment. Establish that before
; entering C so the volatile state pointers address the real shared words.
PollJoystickInputBits:
    push ax
    mov ax, seg StateData
    mov ds, ax
    pop ax
    call POLL_JOYSTICK_INPUT_BITS
    ret

; Raw game-port A sample: button bits are active-low. AX's low byte is the port value.
ReadGamePortAButtonBits:
    mov dx, GAME_PORT
    in al, dx
    ret

; Preserve the original caller's DS while C clears the shared key table. The original
; leaves ES=0 and returns with interrupts enabled after its BIOS-buffer flush.
ClearKeyDownTable:
    push ds
    push ax
    mov ax, seg StateData
    mov ds, ax
    pop ax
    call CLEAR_KEY_DOWN_TABLE
    pop ds
    push ax
    xor ax, ax
    mov es, ax
    pop ax
    ret

MAIN ends
end
