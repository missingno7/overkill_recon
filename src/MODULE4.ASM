; Link module 4 (evidence: the far code from ShowPageList starts on a paragraph after
; zero padding that MODULE3 cannot produce itself, so a new paragraph-aligned module
; likely begins here). Far page viewer.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn FarCallMainNearViaAX:far
extrn KeyDownTable:byte
extrn LoadAndShowPage:far
extrn PageIndex:word
extrn PageListPtr:word
extrn WaitVerticalRetrace:far
FAR0F7F segment para public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
public ShowPageList
ShowPageList:
    mov word ptr ds:[PageListPtr], ax
    mov word ptr ds:[PageIndex], 0
@@showPage:
    mov ax, offset LoadAndShowPage
    call far ptr FarCallMainNearViaAX
    mov si, word ptr ds:[PageListPtr]
    cmp word ptr ds:[si - 2], 0
    je @@done
@@pollKeys:
    cmp byte ptr ds:[KeyDownTable + SCAN_LEFT], KEY_STATE_DOWN
    je @@previousPage
    cmp byte ptr ds:[KeyDownTable + SCAN_UP], KEY_STATE_DOWN
    je @@previousPage
    cmp byte ptr ds:[KeyDownTable + SCAN_PGUP], KEY_STATE_DOWN
    je @@previousPage
    cmp byte ptr ds:[KeyDownTable + SCAN_BACKSPACE], KEY_STATE_DOWN
    je @@previousPage
    cmp byte ptr ds:[KeyDownTable + SCAN_RIGHT], KEY_STATE_DOWN
    je @@nextPage
    cmp byte ptr ds:[KeyDownTable + SCAN_DOWN], KEY_STATE_DOWN
    je @@nextPage
    cmp byte ptr ds:[KeyDownTable + SCAN_PGDN], KEY_STATE_DOWN
    je @@nextPage
    cmp byte ptr ds:[KeyDownTable + SCAN_SPACE], KEY_STATE_DOWN
    je @@nextPage
    cmp byte ptr ds:[KeyDownTable + SCAN_ENTER], KEY_STATE_DOWN
    je @@nextPage
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne @@pollKeys
@@waitEscRelease:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je @@waitEscRelease
@@done:
    retf
@@previousPage:
    cmp word ptr ds:[PageIndex], 0
    je @@pollKeys
    mov cx, 5
@@delayPrevious:
    mov ax, offset WaitVerticalRetrace
    call far ptr FarCallMainNearViaAX
    loop @@delayPrevious
    dec word ptr ds:[PageIndex]
    jmp short @@showPage
@@nextPage:
    mov si, word ptr ds:[PageListPtr]
    mov bx, word ptr ds:[PageIndex]
    inc bx
    shl bx, 1
    cmp word ptr ds:[bx + si], -1
    je @@pollKeys
    mov cx, 5
@@delayNext:
    mov ax, offset WaitVerticalRetrace
    call far ptr FarCallMainNearViaAX
    loop @@delayNext
    inc word ptr ds:[PageIndex]
    jmp near ptr @@showPage
FAR0F7F ends
end
