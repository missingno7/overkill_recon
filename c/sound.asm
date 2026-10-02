; Candidate bridge/platform boundary for sound.c.  This is not part of the hybrid yet.
include SOUND.INC
include HARDWARE.INC
locals
extrn SOUND_SFX_TICK:near
extrn SOUND_SFX_STOP_ALL:near
extrn SOUND_SFX_STORE_AND_WAIT:near
extrn SOUND_SFX_COMMAND_REST:near
extrn SOUND_SFX_COMMAND_STEP_DOWN:near
extrn SOUND_SFX_COMMAND_STEP_UP:near
extrn SOUND_SFX_COMMAND_SLIDE:near
extrn SOUND_REQUEST_MODULE_MUSIC:near
extrn SOUND_STOP_MODULE_MUSIC:near
extrn SoundModuleLoaded:byte
extrn ModuleSoundEnabled:byte
extrn SoundModuleSlot:far
extrn FarCallMainNearViaAX:far
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public SfxStreamStoreAndWait, SfxTimerTick, SfxStopAll, SfxCmdRest, SfxCmdStepDown, SfxCmdStepUp, SfxCmdSlide
public RequestModuleMusic, StopModuleMusic
public SfxSpeakerPortOff, SfxSpeakerPortProgram

; INT 08h has already saved every general register and calls the loaded module first.
; The outer timer handler restores DS after this entry; this bridge leaves hardware
; scheduling and the module tick order untouched.
SfxTimerTick:
    call SOUND_SFX_TICK
    ret

; These command-table targets keep their original nonlocal RET shape.  The C stream
; parser dispatches commands internally; DATA.ASM still contains the original table.
SfxStopAll:
    call SOUND_SFX_STOP_ALL
    ret
SfxStreamStoreAndWait:
    push si
    mov si, di
    push di
    mov di, bx
    call SOUND_SFX_STORE_AND_WAIT
    pop di
    pop si
    ret
SfxCmdRest:
    push si
    mov si, di
    push di
    mov di, bx
    call SOUND_SFX_COMMAND_REST
    pop di
    pop si
    ret
SfxCmdStepDown:
    push si
    mov si, di
    push di
    mov di, bx
    call SOUND_SFX_COMMAND_STEP_DOWN
    pop di
    pop si
    ret
SfxCmdStepUp:
    push si
    mov si, di
    push di
    mov di, bx
    call SOUND_SFX_COMMAND_STEP_UP
    pop di
    pop si
    ret
SfxCmdSlide:
    push si
    mov si, di
    push di
    mov di, bx
    call SOUND_SFX_COMMAND_SLIDE
    pop di
    pop si
    ret

; AL=tune. Preserve the old near API: when disabled, AX/BX/ES are unchanged. When
; enabled, BX and ES identify SoundModuleSlot and AX becomes the zero-extended tune.
; Save the original current tune because C clears it as part of the request word write;
; the final CMP recreates the old caller-visible flags exactly.
RequestModuleMusic:
    push bp
    mov bp, ax
    cmp byte ptr ds:[ModuleSoundEnabled], 0
    jne @@enabled
    ; Even with module music disabled, the game latch records this requested tune.
    ; Save the disabled-path flags and ABI outputs around the C state update.
    pushf
    push si
    mov si, bp
    call SOUND_REQUEST_MODULE_MUSIC
    pop si
    mov ax, bp
    popf
    pop bp
    ret
@@enabled:
    push dx
    mov bx, seg SoundModuleSlot
    mov es, bx
    mov dh, byte ptr es:[MODULE_MUSIC_CURRENT]
    mov dl, al
    push si
    mov si, ax
    call SOUND_REQUEST_MODULE_MUSIC
    pop si
    mov ax, bp
    xor ah, ah
    cmp dl, dh
    pop dx
    pop bp
    ret

; The old stop entry returns immediately when no module is loaded. Otherwise it leaves
; CX=0 and ES at the module frame after five one-tick waits. AX's high byte is inherited;
; sound_stop_module_music returns the last wait's low byte.
StopModuleMusic:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    je @@stop_done
    push si
    mov ax, seg SoundModuleSlot
    mov es, ax
    mov si, ax
    call SOUND_STOP_MODULE_MUSIC
    pop si
    mov cx, 0
@@stop_done:
    ret

; The speaker writes are deliberately narrow platform calls.  The timer handler has
; already called AdLib's module tick, so these remain ordered after its channel-2 work.
SfxSpeakerPortOff:
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    ret
SfxSpeakerPortProgram:
    mov al, PIT_CH2_SQUARE_WAVE
    out PIT_COMMAND_PORT, al
    mov al, bl
    out PIT_CHANNEL2_PORT, al
    mov al, bh
    out PIT_CHANNEL2_PORT, al
    in al, PPI_PORT_B
    or al, PPI_SPEAKER_BITS
    out PPI_PORT_B, al
    ret
MAIN ends
end
