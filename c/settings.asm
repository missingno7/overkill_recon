; Startup and shutdown keep their original near entries. File encoding/settings
; helpers are called directly from C, with no far ASM entry stubs.
locals
extrn APPLY_LAUNCHER_VIDEO_OVERRIDE:near
extrn SAVE_HISCORE_FILE:near
extrn LOAD_HISCORE_FILE:near
extrn APPLY_LAUNCHER_SOUND_OVERRIDE:near
extrn FarCallMainNearViaAX:far
extrn MainDataSegment:word
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public SaveHiscoreFile, LoadHiscoreFile, ApplyLauncherSoundOverride
SaveHiscoreFile:
    call SAVE_HISCORE_FILE
    mov es, word ptr cs:[MainDataSegment]
    ret
LoadHiscoreFile:
    push si
    mov si, es
    call LOAD_HISCORE_FILE
    mov es, dx
    pop si
    ret
ApplyLauncherSoundOverride:
    pushf
    push ax
    push si
    mov si, ax
    call APPLY_LAUNCHER_SOUND_OVERRIDE
    pop si
    pop ax
    popf
    ret
public ApplyLauncherVideoOverride
ApplyLauncherVideoOverride:
    pushf
    push si
    push ax
    mov si, bx
    call APPLY_LAUNCHER_VIDEO_OVERRIDE
    pop ax
    pop si
    popf
    ret
MAIN ends
CGAME segment byte public 'CODE'
assume cs:CGAME
public SETTINGS_FILE_SERVICE
; AX = MAIN file routine; SI = inherited ES, returned in AX. BP stays C's frame.
SETTINGS_FILE_SERVICE:
    push bp
    mov es, si
    call far ptr FarCallMainNearViaAX
    mov ax, es
    pop bp
    ret
CGAME ends
end
