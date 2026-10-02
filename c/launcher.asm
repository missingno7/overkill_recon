; Retain the DOS entry operations through the mask-table builder.
; PSP data and post-file override decisions are passed to the native launcher policy.
locals
extrn LAUNCHER_AFTER_PROLOGUE:near
extrn InstallCriticalErrorVector:far
extrn MainDataSegment:word
extrn EntryEsPsp:word
extrn EntryDsPsp:word
extrn StackTop:word
extrn ImageEnd:byte
extrn MsgDeallocError:byte
extrn BuildByteToNibbleMaskTable:near
extrn ShowFatalErrorAndExit:near
include SYSTEM.INC
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public ProgramEntry
ProgramEntry:
    mov word ptr cs:[EntryEsPsp], es
    mov word ptr cs:[EntryDsPsp], ds
    cld
    cli
    mov ds, word ptr cs:[MainDataSegment]
    mov ss, word ptr cs:[MainDataSegment]
    mov sp, offset StackTop
    sti
; From here DOS calls fail with CF set instead of prompting; INT 24h is never restored
; (DOS restores it from the PSP at exit).
    call far ptr InstallCriticalErrorVector
    mov es, word ptr cs:[EntryEsPsp]
    mov ax, es
    mov bx, seg ImageEnd
    sub bx, ax
    mov ah, DOS_RESIZE_MEMORY
    int 021h
    mov dx, offset MsgDeallocError
    jae @@memoryResized
    jmp near ptr ShowFatalErrorAndExit
@@memoryResized:
    call BuildByteToNibbleMaskTable
    mov ds, word ptr cs:[MainDataSegment]
    mov es, word ptr cs:[MainDataSegment]

    ; The stack is the original DATA segment. Build the same BP/ES metadata pair
    ; consumed by StartupAfterOverrides, while keeping the PSP segment explicit.
    push es
    push bp
    push si
    push di
    sub sp, 4
    mov bp, sp
    mov ax, word ptr ss:[bp + 8]
    mov word ptr ss:[bp], ax
    mov ax, word ptr ss:[bp + 10]
    mov word ptr ss:[bp + 2], ax
    mov di, bp
    mov si, word ptr cs:[EntryDsPsp]
    call LAUNCHER_AFTER_PROLOGUE
    add sp, 4
    pop di
    pop si
    pop bp
    pop es
    ; The original startup body falls through to StartNewGame if its C driver returns.
    jmp near ptr StartNewGame
MAIN ends
end
