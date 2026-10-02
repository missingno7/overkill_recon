; Hardware and keyboard leaves used by the native high-score coordinator.
locals
extrn DrawPanelGraphic:near
extrn ReadKeyThroughDos:near
extrn HiscoreEntryRow:byte
extrn HiscoreBlankLine:byte
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public HiscoreEntryHardware, HiscoreReadNameKey
; Panel graphics, cursor positioning and the DOS blank line are platform effects.
; C carries the live BP/ES pair through this leaf in DosRegisters.
HiscoreEntryHardware:
    mov ax, 0A800h
    mov si, 056h
    call DrawPanelGraphic
    mov dl, 0
    mov dh, byte ptr ds:[HiscoreEntryRow]
    mov ah, 2
    mov bh, 0
    int 010h
    mov dx, offset HiscoreBlankLine
    mov ah, 9
    int 021h
    ret

; String walking and BP restoration are C; this leaf only supplies DOS input.
HiscoreReadNameKey:
    call ReadKeyThroughDos
    ret
MAIN ends
end
