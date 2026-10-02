; MAIN entry bridges and DOS-buffer services for resource_codecs.c.
locals
extrn PACKED_DECODE_BYTE_RLE:near
extrn PACKED_DECODE_WORD_RLE:near
extrn PACKED_DECODE_DWORD_RLE:near
extrn PACKED_DECODE_PACKBITS:near
extrn PACKED_DECODE_COLUMN_PACKBITS:near
extrn PACKED_LOAD_FILE:near
extrn ENC_DECODE_FILE:near
extrn ENC_DECODE_STREAM:near
extrn ReadEncByte:near
extrn FinishPackedLoad:near
extrn FailPackedLoad:near
extrn PackedDestSegment:word
extrn PackedDestOffset:word
extrn PackedReadCursor:word
extrn PackedReadBuffer:byte
extrn PackedSavedBx:word
extrn PackedWordLow:byte
extrn PackedFileHandle:word
extrn PackedUnwindSp:word
extrn PackedOutputBytes:word
extrn PackedOpenFailed:word
extrn EncDestSegment:word
extrn EncFileHandle:word
extrn EncReadBuffer:byte
extrn MainDataSegment:word
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing

; LoadPackedFile saves the entry stack before C builds any frames. Its C body returns a
; small result record on the stack so this bridge can preserve the original ES:DI choice
; on open/header failures and return the decoder cursor on all started-format paths.
public LoadPackedFile
LoadPackedFile:
    mov word ptr cs:[PackedOutputBytes], 0
    mov word ptr cs:[PackedUnwindSp], sp
    mov word ptr cs:[PackedReadCursor], offset PackedReadBuffer + 0200h
    push bp
    mov bp, sp
    push ds
    push es
    push di
    sub sp, 10
    mov si, sp
    mov ax, ss
    mov ds, ax
    call PACKED_LOAD_FILE
    mov ax, ss
    mov ds, ax
    mov cx, word ptr ss:[bp - 10]   ; started decoder
    mov dx, word ptr ss:[bp - 16]   ; carry result
    mov ax, word ptr ss:[bp - 14]   ; DOS result or close result
    mov si, word ptr ss:[bp - 12]   ; decoder's output cursor
    mov bx, word ptr ss:[bp - 8]    ; final BX
    add sp, 10
    pop di
    pop es
    add sp, 2                       ; LoadPackedFile returns with DS = StateData.
    pop bp
    mov ds, word ptr cs:[MainDataSegment]
    or cx, cx
    je @@keepDestination
    mov di, si
    mov es, word ptr cs:[PackedDestSegment]
@@keepDestination:
    or dx, dx
    jnz @@failed
    clc
    ret
@@failed:
    stc
    ret

; DecodeEncFile's C coordinator returns the stream cursors and final ring cursor in a
; stack result. On success the saved BP slot carries that actual decoder output; on an
; initial-read failure BP, SI, and DI all come back unchanged.
public DecodeEncFile
DecodeEncFile:
    push bp
    mov bp, sp
    push ds
    push es
    push si
    push di
    sub sp, 12
    mov si, sp
    mov ax, ss
    mov ds, ax
    call ENC_DECODE_FILE
    mov cx, word ptr ss:[bp - 20]   ; initial-read carry
    mov ax, word ptr ss:[bp - 18]   ; DOS close result or initial read error
    mov dx, word ptr ss:[bp - 16]   ; final input cursor
    mov bx, word ptr ss:[bp - 14]   ; final output cursor
    mov si, word ptr ss:[bp - 12]   ; original close/read flags
    mov di, word ptr ss:[bp - 10]   ; final ring-write BP
    or cx, cx
    jnz @@encFileFailedSetup
    mov word ptr ss:[bp - 8], bx    ; replace saved DI only on success
    mov word ptr ss:[bp], di        ; return the stream's real BP after this frame unwinds
    jmp short @@encFileCleanup
@@encFileFailedSetup:
    mov dx, word ptr ss:[bp - 6]    ; failed first read preserves the caller's SI
@@encFileCleanup:
    mov word ptr ss:[bp - 6], si    ; use saved SI slot to carry flags through cleanup
    add sp, 12
    pop di
    pop si
    pop es
    pop ds
    pop bp
    mov bx, word ptr cs:[EncFileHandle]
    or cx, cx
    jnz @@encFileReturn
    push si
    popf                            ; Preserve DOS close flags except the C-masked CF.
    mov si, dx
    ret
@@encFileReturn:
    push si
    popf                            ; Initial read failure returns its original flags.
    mov si, dx
    ret

public DecodeByteEscapeRle, DecodeWordEscapeRle, DecodeDwordEscapeRle
public DecodePackBitsStream, DecodeColumnPackBits
public DecodeEncStream
DecodeByteEscapeRle:
    push bp
    mov bp, sp
    push ds
    push si
    sub sp, 6                      ; PackedDecodeResult on the caller's DOS stack.
    mov si, sp
    mov cx, ax                     ; C reader state starts with the old caller's AH.
    mov ax, ss
    mov ds, ax
    call PACKED_DECODE_BYTE_RLE
    mov di, ax
    mov dx, word ptr ss:[bp - 10]
    mov ax, word ptr ss:[bp - 8]
    add sp, 6
    pop si
    pop ds
    pop bp                          ; No C frame remains before legacy failure unwind.
    mov es, word ptr cs:[PackedDestSegment]
    or dx, dx
    jnz @@packedFailed
    jmp near ptr FinishPackedLoad
@@packedFailed:
    jmp near ptr FailPackedLoad

DecodeWordEscapeRle:
    push bp
    mov bp, sp
    push ds
    push si
    sub sp, 6
    mov si, sp
    mov cx, ax
    mov ax, ss
    mov ds, ax
    call PACKED_DECODE_WORD_RLE
    mov di, ax
    mov dx, word ptr ss:[bp - 10]
    mov ax, word ptr ss:[bp - 8]
    add sp, 6
    pop si
    pop ds
    pop bp
    mov es, word ptr cs:[PackedDestSegment]
    or dx, dx
    jnz @@packedFailed
    jmp near ptr FinishPackedLoad
@@packedFailed:
    jmp near ptr FailPackedLoad

DecodeDwordEscapeRle:
    push bp
    mov bp, sp
    push ds
    push si
    sub sp, 6
    mov si, sp
    mov cx, ax
    mov ax, ss
    mov ds, ax
    call PACKED_DECODE_DWORD_RLE
    mov di, ax
    mov dx, word ptr ss:[bp - 10]
    mov ax, word ptr ss:[bp - 8]
    add sp, 6
    pop si
    pop ds
    pop bp
    mov es, word ptr cs:[PackedDestSegment]
    or dx, dx
    jnz @@packedFailed
    jmp near ptr FinishPackedLoad
@@packedFailed:
    jmp near ptr FailPackedLoad

DecodePackBitsStream:
    push bp
    mov bp, sp
    push ds
    push si
    sub sp, 6
    mov si, sp
    mov cx, ax
    mov ax, ss
    mov ds, ax
    call PACKED_DECODE_PACKBITS
    mov di, ax
    mov dx, word ptr ss:[bp - 10]
    mov ax, word ptr ss:[bp - 8]
    add sp, 6
    pop si
    pop ds
    pop bp
    mov es, word ptr cs:[PackedDestSegment]
    or dx, dx
    jnz @@packedFailed
    jmp near ptr FinishPackedLoad
@@packedFailed:
    jmp near ptr FailPackedLoad

DecodeColumnPackBits:
    push bp
    mov bp, sp
    push ds
    push si
    sub sp, 6
    mov si, sp
    mov cx, ax
    mov ax, ss
    mov ds, ax
    call PACKED_DECODE_COLUMN_PACKBITS
    mov di, ax
    mov dx, word ptr ss:[bp - 10]
    mov ax, word ptr ss:[bp - 8]
    add sp, 6
    pop si
    pop ds
    pop bp
    mov es, word ptr cs:[PackedDestSegment]
    or dx, dx
    jnz @@packedFailed
    jmp near ptr FinishPackedLoad
@@packedFailed:
    jmp near ptr FailPackedLoad

; C's packed reader returns DOS carry in DX and the original AX in AX. This leaf mirrors
; ReadBufferedByte's cursor/refill/saved-BX effects but reports failure instead of jumping
; through C frames to FailPackedLoad.
public PackedReadByteService
PackedReadByteService:
    push ds
    push cs
    pop ds
    mov es, word ptr cs:[PackedDestSegment]
    mov ah, cl
    mov word ptr ds:[PackedSavedBx], bx
    mov bx, word ptr ds:[PackedReadCursor]
    cmp bx, offset PackedReadBuffer + 0200h
    jb @@packedByte
    mov word ptr ds:[PackedReadCursor], offset PackedReadBuffer
    push cx
    mov ah, 03Fh
    mov bx, word ptr ds:[PackedFileHandle]
    mov cx, 0200h
    mov dx, offset PackedReadBuffer
    int 021h
    pop cx
    jb @@packedByteError
    mov bx, word ptr ds:[PackedReadCursor]
@@packedByte:
    mov al, byte ptr ds:[bx]
    inc word ptr ds:[PackedReadCursor]
    mov bx, word ptr ds:[PackedSavedBx]
    clc                             ; C consumes a read-status value, not stale caller CF.
    jmp short @@packedByteStatus
@@packedByteError:
    mov bx, word ptr ds:[PackedSavedBx]
@@packedByteStatus:
    pushf
    pop dx
    and dx, 1
    pop ds
    ret

public PackedReadWordService
PackedReadWordService:
    push ds
    push cs
    pop ds
    mov ax, word ptr cs:[PackedDestSegment]
    mov es, ax
    push cx
    call PackedReadByteService
    or dx, dx
    jnz @@packedWordStatus
    mov byte ptr ds:[PackedWordLow], al
    mov cl, ah
    call PackedReadByteService
    or dx, dx
    jnz @@packedWordStatus
    mov ah, al
    mov al, byte ptr ds:[PackedWordLow]
@@packedWordStatus:
    pop cx
    pop ds
    ret

public PackedCloseService
PackedCloseService:
    push ds
    push cs
    pop ds
    mov ax, 03E00h
    mov bx, word ptr ds:[PackedFileHandle]
    int 021h
    pushf
    pop dx
    and dx, 1
    pop ds
    ret

; Failed packed loads retry a failing close. Preserve the initial decode/open error unless
; a close itself failed; then the last close error is the AX value the old unwind returns.
public PackedCloseAfterFailureService
PackedCloseAfterFailureService:
    push si
    push ds
    push cs
    pop ds
    mov si, cx
@@retryFailedClose:
    mov ax, 03E00h
    mov bx, word ptr ds:[PackedFileHandle]
    int 021h
    jnc @@failedCloseDone
    mov si, ax
    jmp short @@retryFailedClose
@@failedCloseDone:
    mov ax, si
    pop ds
    pop si
    ret

; File-level services are deliberately small DOS leaves. The resource coordinator owns
; count/dispatch/error policy; these preserve the original DS:DX/handle contracts.
public EncInitialReadService
EncInitialReadService:
    push ds
    push cs
    pop ds
    mov bx, word ptr ds:[EncFileHandle]
    mov cx, 0400h
    mov ax, 03F00h
    mov dx, offset EncReadBuffer
    int 021h
    pushf
    pop dx
    pop ds
    ret

public EncCloseService
EncCloseService:
    push ds
    push cs
    pop ds
    mov ax, 03E00h
    mov bx, word ptr ds:[EncFileHandle]
    int 021h
    pushf
    pop dx
    pop ds
    ret

; ReadEncByte's SI is the decoder's input position. DI points to the C function's
; local word holding that register value; the helper restores DS before writing it.
; CX carries the current ES value so INT 21h refill sees the output segment in ES.
public EncReadByteService
EncReadByteService:
    push bx
    push ds
    mov si, word ptr ds:[di]
    mov es, cx
    push cs
    pop ds
    call ReadEncByte
    mov bx, si
    pop ds
    mov word ptr ds:[di], bx
    pop bx
    ret

DecodeEncStream:
    push bp
    mov bp, sp
    push ds
    push es
    sub sp, 2                       ; final ring cursor returned by the C stream
    mov si, sp
    mov ax, ss
    mov ds, ax
    mov es, word ptr cs:[EncDestSegment]
    call ENC_DECODE_STREAM
    mov cx, word ptr ss:[bp - 6]
    mov word ptr ss:[bp], cx        ; pop BP only after the C frame has returned
    add sp, 2
    push ax
    push dx
    mov al, 0
    cmp al, 0                    ; Same successful terminator flags as the oracle.
    pop dx
    pop ax
    pop es
    pop ds
    pop bp
    mov si, dx
    mov di, ax
    ret

MAIN ends
end
