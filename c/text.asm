; Register adapters for the C text routines. Font and video paths remain in MAIN.
locals
extrn FarCallMainNearViaAX:far
extrn TEXT_PRINT_CHAR_FROM_MAIN:near
extrn PrintGraphicsCharCga:near
extrn PrintGraphicsCharEga:near
extrn PrintGraphicsCharTandy:near
extrn MainDataSegment:word
extrn VideoAdapter:word
extrn TextVideoSegment:word
extrn TextInGraphics:word
extrn TextRowOffset:word
extrn TextColor:byte
extrn TEXT_PRINT_MESSAGE_FROM_MAIN:near
extrn TEXT_PRINT_BCD32_FROM_MAIN:near
extrn TEXT_PRINT_DECIMAL_DX_FROM_MAIN:near
extrn TEXT_FORMAT_DECIMAL_TO_BUFFER_FROM_MAIN:near
extrn TEXT_UPPERCASE_ASCII:near

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public PrintMessageBP, PrintBcd32, PrintDecimalDX, FormatDecimalToBuffer
public UppercaseAsciiAL, PrintTextChar, RawPrintTextChar, PrintGraphicsCharCases

; New table boundary: the source table shared a range with the old text parser.
PrintGraphicsCharCases label word
    dw offset PrintGraphicsCharCga, offset PrintGraphicsCharEga, offset PrintGraphicsCharTandy

; Legacy MAIN entry: pass {AX, DI, ES, BP} to C and return the renderer metadata.
PrintTextChar:
    push bp
    push es
    push di
    push ax
    mov si, sp
    call TEXT_PRINT_CHAR_FROM_MAIN
    mov bp, word ptr ss:[si + 6]
    mov es, word ptr ss:[si + 4]
    mov di, word ptr ss:[si + 2]
    add sp, 8
    ret

; C passes the byte in CL. This entry bypasses C policy and reaches only the
; original mode-specific glyph/raster and newline handlers.
RawPrintTextChar:
    mov al, cl
    jmp near ptr TextGlyphBackend

TextGlyphBackend:
    mov es, word ptr cs:[MainDataSegment]
    cmp word ptr ds:[TextInGraphics], 0
    jne @@graphics
    mov es, word ptr cs:[TextVideoSegment]
    mov di, word ptr ds:[TextRowOffset]
    mov ah, byte ptr ds:[TextColor]
    mov word ptr es:[di], ax
    add word ptr ds:[TextRowOffset], 2
    ret
@@graphics:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + PrintGraphicsCharCases]

; The original message and BCD entries expose the renderer's BP/ES results.
PrintMessageBP:
    mov si, bp
    mov di, es
    call TEXT_PRINT_MESSAGE_FROM_MAIN
    mov bp, ax
    mov es, dx
    ret

PrintBcd32:
    mov si, bp
    mov di, es
    call TEXT_PRINT_BCD32_FROM_MAIN
    mov bp, ax
    mov es, dx
    ret

; The stack record is {DX, DI, ES, BP}; C updates it in place with actual outputs.
PrintDecimalDX:
    push bp
    push es
    push di
    push dx
    mov si, sp
    call TEXT_PRINT_DECIMAL_DX_FROM_MAIN
    pop dx
    pop di
    pop es
    pop bp
    ret

FormatDecimalToBuffer:
    push bp
    push es
    push di
    push dx
    mov si, sp
    call TEXT_FORMAT_DECIMAL_TO_BUFFER_FROM_MAIN
    pop dx
    pop di
    pop es
    pop bp
    ret

; Retain the old small-register ABI and reproduce its defined flags around C mapping.
UppercaseAsciiAL:
    push bx
    push si
    push ax
    mov si, ax
    and si, 00FFh
    call TEXT_UPPERCASE_ASCII
    mov bl, al
    pop ax
    pop si
    cmp al, 061h
    jb @@done
    cmp al, 07Ah
    ja @@done
    mov al, bl
    test al, al
@@done:
    pop bx
    ret
MAIN ends

CGAME segment byte public 'CODE'
assume cs:CGAME
public TEXT_MAIN_CHAR_CALL
; SI = MAIN target, DI = input BP, DX = input ES, CX = character, BX = DS pointer
; to a word receiving renderer DI. DX:AX returns ES:BP. Preserve the C frame pointer.
TEXT_MAIN_CHAR_CALL:
    push bp
    push bx
    mov bp, di
    mov es, dx
    mov ax, si
    call far ptr FarCallMainNearViaAX
    mov cx, di
    pop bx
    mov word ptr ds:[bx], cx
    mov ax, bp
    mov dx, es
    pop bp
    ret
CGAME ends
end
