; OpenResourceFile keeps its original SEG153A far entry and register contract.
; DOS file operations remain small assembly leaves called by the C search routine.
locals
extrn OPEN_RESOURCE_FILE:near

SEG153A segment para public 'CODE'
assume cs:SEG153A, ds:nothing, ss:nothing, es:nothing
public OpenResourceFile

OpenResourceFile:
    push si
    push di
    push ds
    push es
    sub sp, 8
    mov si, sp
    mov di, ss
    mov cx, ds
    call OPEN_RESOURCE_FILE
    pop ax                         ; status
    pop bx                         ; handle
    pop cx                         ; length low word
    pop dx                         ; length high word
    pop es
    pop ds
    pop di
    pop si
    or ax, ax
    jnz @@openFailed
    mov ax, bx
    clc
    retf
@@openFailed:
    mov ax, 2
    stc
    retf
SEG153A ends

CGAME segment byte public 'CODE'
assume cs:CGAME, ds:nothing, ss:nothing, es:nothing
public ARCHIVE_DOS_OPEN, ARCHIVE_DOS_READ, ARCHIVE_DOS_SEEK, ARCHIVE_DOS_CLOSE

; CX = pathname segment, SI = offset. Return DX=CF, AX=handle or DOS error.
ARCHIVE_DOS_OPEN:
    push ds
    mov ax, cx
    mov ds, ax
    mov dx, si
    mov ax, 03D02h
    int 021h
    pushf
    pop dx
    and dx, 1
    pop ds
    retf

; BX = handle, CX = byte count, SI:DI = destination segment:offset.
; Return DX=CF, AX=bytes read. Short reads remain successful DOS reads.
ARCHIVE_DOS_READ:
    push ds
    mov ax, si
    mov ds, ax
    mov dx, di
    mov ah, 03Fh
    int 021h
    pushf
    pop si
    and si, 1
    mov dx, si
    pop ds
    retf

; BX = handle, CX = offset low, DI = offset high, SI = origin; a fifth word
; argument at SS:[BP+6] points to a stack word that receives CF. Return DX:AX = position.
ARCHIVE_DOS_SEEK:
    push bp
    mov bp, sp
    mov dx, cx
    mov cx, di
    mov ax, si
    mov ah, 042h
    int 021h
    pushf
    pop bx
    and bx, 1
    mov di, word ptr ss:[bp + 6]
    mov word ptr ss:[di], bx
    pop bp
    retf

; BX = handle. Return AX=CF. Close errors are observed only in the search loop.
ARCHIVE_DOS_CLOSE:
    mov ah, 03Eh
    int 021h
    pushf
    pop ax
    and ax, 1
    retf
CGAME ends
end
