; Menu's two remaining ASM entries and argument adapters to existing DOS services.
locals
extrn RUN_OPTIONS_MENU:near
extrn READ_CHOOSE_SCREEN_INPUT:near
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public RunOptionsMenu, ReadChooseScreenInput
RunOptionsMenu:
    call RUN_OPTIONS_MENU
    ret
ReadChooseScreenInput:
    call READ_CHOOSE_SCREEN_INPUT
    ret

public MenuWaitKeysReleased, MenuRequestMusic, MenuCallService
; DX = near service. Preserve C's frame pointer, including the joystick's nonlocal
; abort: its saved SP still returns here before the outer far trampoline returns.
MenuCallService:
    push bp
    call dx
    pop bp
    ret
MenuWaitKeysReleased:
    call far ptr WaitAllKeysReleased
    ret
; SI = music number; RequestModuleMusic consumes AL and restores game DS.
MenuRequestMusic:
    mov ax, si
    jmp near ptr RequestModuleMusic

MAIN ends
end
