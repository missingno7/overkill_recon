; C owns image headers, descriptor setup and frame progression. The request adapters
; keep source-segment capture and adapter pixel/port transfers explicit.
include HARDWARE.INC
include SYSTEM.INC
locals
extrn SCREEN_ANIMATION_CAPTURE_COLLAPSE:near
extrn SCREEN_ANIMATION_STRETCH_RAW:near
extrn SCREEN_ANIMATION_STRETCH_WINDOW:near
extrn SCREEN_ANIMATION_STRETCH_END:near
extrn SCREEN_ANIMATION_STRETCH_HUD_PANEL:near
extrn FarCallMainNearViaAX:far
extrn MainDataSegment:word
extrn WorkspaceSegment:word

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public CaptureAndCollapseScreen, StretchInImage, StretchInWindowImage
public StretchInTheEndImage, StretchInHudPanel

; Native C keeps DS on the state segment while it runs. Preserve the old entry's
; returned DS = WorkspaceSegment for its remaining ASM caller.
CaptureAndCollapseScreen:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SCREEN_ANIMATION_CAPTURE_COLLAPSE
    mov bp, word ptr ss:[si]
    mov es, word ptr ss:[si + 2]
    mov ax, word ptr cs:[WorkspaceSegment]
    mov ds, ax
    pop di
    pop si
    add sp, 4
    ret

StretchInWindowImage:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SCREEN_ANIMATION_STRETCH_WINDOW
    mov bp, word ptr ss:[si]
    mov es, word ptr ss:[si + 2]
    pop di
    pop si
    add sp, 4
    ret

StretchInTheEndImage:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SCREEN_ANIMATION_STRETCH_END
    mov bp, word ptr ss:[si]
    mov es, word ptr ss:[si + 2]
    pop di
    pop si
    add sp, 4
    ret

StretchInHudPanel:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call SCREEN_ANIMATION_STRETCH_HUD_PANEL
    mov bp, word ptr ss:[si]
    mov es, word ptr ss:[si + 2]
    pop di
    pop si
    add sp, 4
    ret

; Raw internal contract: DS:SI = image, DI = destination. Save that far source before
; forcing DS to game state so the C body can access the original state and CS fields.
StretchInImage:
    push bp
    mov bp, sp
    sub sp, 10
    mov word ptr ss:[bp - 10], ds
    mov word ptr ss:[bp - 8], si
    mov word ptr ss:[bp - 6], di
    mov ax, word ptr ss:[bp]
    mov word ptr ss:[bp - 4], ax
    mov word ptr ss:[bp - 2], es
    mov ax, word ptr cs:[MainDataSegment]
    mov ds, ax
    lea si, word ptr ss:[bp - 10]
    call SCREEN_ANIMATION_STRETCH_RAW
    mov dx, word ptr ss:[bp - 4]
    mov cx, word ptr ss:[bp - 2]
    mov ax, word ptr cs:[MainDataSegment]
    mov ds, ax
    mov sp, bp
    pop bp
    mov bp, dx
    mov es, cx
    ret
MAIN ends

; Capture one logical row. C advances the original banked source cursor and packed
; workspace cursor; these routines perform only the actual memory/port transfers.
CGAME segment byte public 'CODE'
assume cs:CGAME
public SCREEN_ANIMATION_PLATFORM_CAPTURE_ROW
public SCREEN_ANIMATION_PLATFORM_FINISH_CAPTURE
public SCREEN_ANIMATION_PLATFORM_DRAW

SCREEN_ANIMATION_PLATFORM_CAPTURE_ROW:
    push bp
    mov bp, si
    mov ax, word ptr ss:[bp + 0]
    mov ds, ax
    mov ax, word ptr ss:[bp + 2]
    mov es, ax
    mov si, word ptr ss:[bp + 4]
    mov di, word ptr ss:[bp + 6]
    cmp word ptr ss:[bp + 8], VIDEO_CGA
    je @@captureCga
    cmp word ptr ss:[bp + 8], VIDEO_EGA
    je @@captureEga
    mov cx, TANDY_SCREEN_ROW_BYTES / 2
    rep movsw
    jmp short @@captureDone
@@captureCga:
    mov cx, CGA_SCREEN_ROW_BYTES
    rep movsb
    jmp short @@captureDone
@@captureEga:
    mov dx, 03CEh
    mov ax, 4
    out dx, ax
    mov cx, EGA_SCREEN_ROW_BYTES
    rep movsb
    sub si, EGA_SCREEN_ROW_BYTES
    inc ah
    out dx, ax
    mov cx, EGA_SCREEN_ROW_BYTES
    rep movsb
    sub si, EGA_SCREEN_ROW_BYTES
    inc ah
    out dx, ax
    mov cx, EGA_SCREEN_ROW_BYTES
    rep movsb
    sub si, EGA_SCREEN_ROW_BYTES
    inc ah
    out dx, ax
    mov cx, EGA_SCREEN_ROW_BYTES
    rep movsb
@@captureDone:
    mov ax, word ptr ss:[bp + 10]
    mov ds, ax
    pop bp
    retf

SCREEN_ANIMATION_PLATFORM_FINISH_CAPTURE:
    cmp si, VIDEO_EGA
    jne @@captureFinishDone
    mov dx, 03CEh
    mov ax, 4
    out dx, ax
@@captureFinishDone:
    retf

; Draw one selected pixel frame. BP/ES from the original adapter entry are returned in
; the stack request while DS is repaired to state before C resumes.
SCREEN_ANIMATION_PLATFORM_DRAW:
    push bp
    mov bp, si
    push bp
    mov ax, word ptr ss:[bp + 2]
    mov ds, ax
    mov ax, word ptr ss:[bp + 4]
    mov es, ax
    mov ax, word ptr ss:[bp + 0]
    mov cx, word ptr ss:[bp + 6]
    mov bp, cx
    call far ptr FarCallMainNearViaAX
    mov ax, bp
    mov dx, es
    pop bp
    mov word ptr ss:[bp + 10], ax
    mov word ptr ss:[bp + 12], dx
    mov ax, word ptr ss:[bp + 8]
    mov ds, ax
    pop bp
    retf
CGAME ends
end
