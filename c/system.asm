; Keep the legacy system-control entries as adapters to CGAME.
locals
extrn KeyDownTable:byte
extrn SYSTEM_REDRAW_AFTER_BOSS_KEY:near
extrn SYSTEM_REDRAW_STATUS_PANEL:near
extrn SYSTEM_PROMPT_LOAD_ERROR_WAIT_FIRE:near
extrn SYSTEM_WAIT_ALL_KEYS_RELEASED:near
extrn SYSTEM_WAIT_INPUT_RELEASED:near
extrn SYSTEM_WAIT_INPUT_PRESSED:near
extrn SYSTEM_WAIT_INPUT_CLICK:near
include INPUT.INC
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public CheckBossKey, RedrawStatusPanel, PromptLoadErrorWaitFire
CheckBossKey:
    cmp byte ptr ds:[KeyDownTable + SCAN_F9], KEY_STATE_DOWN
    jne @@bossKeyDone
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SYSTEM_REDRAW_AFTER_BOSS_KEY
    pop di
    pop si
    pop bp
    pop es
@@bossKeyDone:
    ret

RedrawStatusPanel:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SYSTEM_REDRAW_STATUS_PANEL
    pop di
    pop si
    pop bp
    pop es
    ret

PromptLoadErrorWaitFire:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SYSTEM_PROMPT_LOAD_ERROR_WAIT_FIRE
    pop di
    pop si
    pop bp
    pop es
    ret

; The C data model requires DS=SS. These wait leaves restore the caller's DS.
public WaitInputReleased, WaitInputPressed, WaitInputClick
WaitInputReleased:
    push ds
    mov ax, ss
    mov ds, ax
    call SYSTEM_WAIT_INPUT_RELEASED
    pop ds
    ret
WaitInputPressed:
    push ds
    mov ax, ss
    mov ds, ax
    call SYSTEM_WAIT_INPUT_PRESSED
    pop ds
    ret
WaitInputClick:
    push ds
    mov ax, ss
    mov ds, ax
    call SYSTEM_WAIT_INPUT_CLICK
    pop ds
    ret

; Original callers use a far call. Keep the full 64-byte scan visible at the C entry.
public WaitAllKeysReleased
WaitAllKeysReleased:
    push ds
    push ax
    mov ax, ss
    mov ds, ax
    call SYSTEM_WAIT_ALL_KEYS_RELEASED
    pop ax
    pop ds
    retf

MAIN ends
end
