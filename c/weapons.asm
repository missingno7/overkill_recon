; ASM -> C entry stubs of the weapons region (c/weapons.c) for the DOS hybrid, and the
; demo caption thunk C calls back into. Each stub keeps an oracle label and its register
; contract (see the oracle routine's comment) and calls the C function that owns it
; (c/game.h convention: SI, DI in; AX out; all else preserved).
locals
extrn HANDLE_FIRE_BUTTON:near
extrn UPDATE_BEAM:near
extrn FIND_MISSILE_TARGET:near
extrn RUN_DEMO_SCRIPT_FRAME:near
extrn DrawOffsetFromScreenRow:near
extrn BlitPackedToScreen:near
extrn PanelImageOffsets:word
extrn PanelSegment:word
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing

public HandleFireButton, UpdateBeam, RunDemoScriptFrame
; BP = ship record. The oracle clobbers AX..DI and ES (and RunDemoScriptFrame also BP);
; no caller reads them. These keep everything.
HandleFireButton:
    push si
    mov si, bp
    call HANDLE_FIRE_BUTTON
    pop si
    ret
UpdateBeam:
    push si
    mov si, bp
    call UPDATE_BEAM
    pop si
    ret
RunDemoScriptFrame:
    push si
    mov si, bp
    call RUN_DEMO_SCRIPT_FRAME
    pop si
    ret

public FindMissileTarget
; BX = target record or FFFFh. The oracle also leaves its loop count in CX (no caller
; reads it); this keeps CX.
FindMissileTarget:
    push ax
    call FIND_MISSILE_TARGET
    mov bx, ax
    pop ax
    ret

public DrawDemoCaption
; Platform thunk for RunDemoScriptFrame (reached from C through FarCallMainNearViaAX):
; draws PanelSegment image SI as the demo caption at screen row 18h, column 1Fh, exactly
; as the oracle does. BP comes back as BlitPackedToScreen leaves it (the image's row
; bytes), which the oracle passes on to UpdateBeam.
DrawDemoCaption:
    mov al, 01Fh
    mov ah, 018h
    call DrawOffsetFromScreenRow
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    push ds
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop ds
    ret

MAIN ends
end
