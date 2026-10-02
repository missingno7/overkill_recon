; C-owned level/resource coordinators. Each legacy entry hands its live BP/ES pair
; to C in caller-owned stack words so platform services can update the same values.
locals
extrn LOAD_LEVEL_MAP:near
extrn LOAD_GRAPHICS_RECORD_IMAGES:near
extrn LOAD_GRAPHICS_FILE:near
extrn LOAD_COMMON_GRAPHICS:near
extrn LOAD_LEVEL_GRAPHICS:near
extrn LOAD_AND_SHOW_PAGE:near
extrn DecodeGraphicsImages:near
extrn BlitPackedToScreen:near
extrn MainDataSegment:word
extrn WorkspaceSegment:word
extrn LoadDestOffset:word
extrn LoadDestSegment:word

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public LoadLevelMap, LoadGraphicsRecordImages, LoadGraphicsFile
public LoadCommonGraphics, LoadLevelGraphics, LoadAndShowPage
public LevelsDecodeGraphics, LevelsBlitPage

LoadLevelMap:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call LOAD_LEVEL_MAP
    pop di
    pop si
    pop bp
    pop es
    ret

; The only selector still entered from outside this C-owned region. The plain and
; masked selectors have no surviving ASM callers; C coordinators call them directly.
LoadGraphicsRecordImages:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call LOAD_GRAPHICS_RECORD_IMAGES
    pop di
    pop si
    pop bp
    pop es
    ret

LoadGraphicsFile:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call LOAD_GRAPHICS_FILE
    pop di
    pop si
    pop bp
    pop es
    ret

LoadCommonGraphics:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call LOAD_COMMON_GRAPHICS
    pop di
    pop si
    pop bp
    pop es
    ret

LoadLevelGraphics:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call LOAD_LEVEL_GRAPHICS
    pop di
    pop si
    pop bp
    pop es
    ret

LoadAndShowPage:
    push es
    push bp
    push si
    push di
    mov si, sp
    add si, 4
    call LOAD_AND_SHOW_PAGE
    pop di
    pop si
    pop bp
    pop es
    ret

; SI = DosRegisters*, DI = DecodeFileFlags. The original loader enters the
; adapter decoder with BP=flags, DS=workspace, ES=destination, SI=0 and DI=offset.
; The decoder restores MainDataSegment in DS; this thunk restores the caller's DS
; and reports its actual BP/ES outputs in the shared pair.
LevelsDecodeGraphics:
    push bp
    push ds
    push si
    mov bp, di
    mov di, word ptr cs:[LoadDestOffset]
    xor si, si
    mov ds, word ptr cs:[WorkspaceSegment]
    mov es, word ptr cs:[LoadDestSegment]
    call DecodeGraphicsImages
    mov cx, bp
    mov dx, es
    pop si
    pop ds
    mov word ptr [si], cx
    mov word ptr [si + 2], dx
    pop bp
    ret

; SI = DosRegisters*. The page image is decoded at WorkspaceSegment:8000h and the
; original routine draws it with DS=workspace, SI=8000h, DI=0, and inherited BP/ES.
LevelsBlitPage:
    push bp
    push ds
    push si
    mov bp, word ptr [si]
    mov es, word ptr [si + 2]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov si, 08000h
    xor di, di
    call BlitPackedToScreen
    mov cx, bp
    mov dx, es
    pop si
    pop ds
    mov word ptr [si], cx
    mov word ptr [si + 2], dx
    pop bp
    ret
MAIN ends
end
