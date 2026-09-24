; Minimal DOS process entry only: compiler data segment and DOS exit.
; No historical register contract, addresses, gameplay or continuation adapter.
.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT,ds:DGROUP,ss:DGROUP
extrn _main:near
public _start
_start:
    mov ax,DGROUP
    mov ds,ax
    mov es,ax
    cld
    call _main
    mov ah,4Ch
    int 21h
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
STACK segment para stack 'STACK'
    db 2048 dup (?)
STACK ends
DGROUP group _DATA,_BSS,STACK
end _start
