; Modern physical chunk, NOT an inferred original object boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public loc_0ECC9
public loc_0F797
extrn loc_05DB2:near
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h

loc_0ECC9:
    push ds
    push cs
    pop ds
    mov bx, word ptr cs:[0D666h]
    mov cx, 0400h
    mov ax, 03F00h
    mov dx, 0D8B8h
    int 021h
    jb loc_0ECEC
    call loc_0ECF2
    mov ax, 03E00h
    mov bx, word ptr cs:[0D666h]
    int 021h
    clc
loc_0ECEC:
    pop ds
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h

loc_0ECF2:
    push es
    mov word ptr cs:[0EDE5h], 0
    mov word ptr cs:[0EDE7h], 0
    les di, dword ptr cs:[0ECEEh]
    mov byte ptr cs:[0EE04h], 0
    mov si, 0
    mov bp, 0
    mov cx, 07F7h
loc_0ED15:
    mov word ptr cs:[bp - 02348h], 0
    inc bp
    inc bp
    loop loc_0ED15
    mov bp, 0FEEh
    mov dx, 0
loc_0ED26:
    shr dx, 1
    test dx, 0100h
    jne loc_0ED35
    call loc_0ED97
    mov dl, al
    mov dh, 0FFh
loc_0ED35:
    test dx, 1
    je loc_0ED4D
    call loc_0ED97
    call loc_0EDE9
    mov byte ptr cs:[bp - 02348h], al
    inc bp
    and bp, 0FFFh
    jmp short loc_0ED26
loc_0ED4D:
    call loc_0ED97
    mov ah, al
    call loc_0ED97
    xchg al, ah
    cmp ax, 0
    jne loc_0ED68
    call loc_0ED97
    cmp al, 0
    je loc_0ED95
    call loc_0EDDA
    mov al, 0
loc_0ED68:
    mov cl, ah
    shr ah, 1
    shr ah, 1
    shr ah, 1
    shr ah, 1
    and cl, 0Fh
    mov bx, ax
    add cl, 3
loc_0ED7A:
    mov al, byte ptr cs:[bx - 02348h]
    call loc_0EDE9
    mov byte ptr cs:[bp - 02348h], al
    inc bx
    and bx, 0FFFh
    inc bp
    and bp, 0FFFh
    loop loc_0ED7A
    jmp short loc_0ED26
loc_0ED95:
    pop es
    ret

loc_0ED97:
    test byte ptr cs:[0EE04h], 0FFh
    jne loc_0EDCF
    add si, 0D8B8h
    lodsb
    sub si, 0D8B8h
    and si, 03FFh
    jne loc_0EDCE
    pushf
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    mov dx, 0D8B8h
    mov ax, 03F00h
    mov bx, word ptr cs:[0D666h]
    mov cx, 0400h
    int 021h
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    popf
loc_0EDCE:
    ret
loc_0EDCF:
    mov al, byte ptr cs:[0EE05h]
    mov byte ptr cs:[0EE04h], 0
    ret

loc_0EDDA:
    mov byte ptr cs:[0EE04h], 1
    mov byte ptr cs:[0EE05h], al
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h

loc_0EDE9:
    stosb
    or di, di
    jne loc_0EDF7
    push ax
    mov ax, es
    add ax, 01000h
    mov es, ax
    pop ax
loc_0EDF7:
    inc word ptr cs:[0EDE5h]
    jne loc_0EE03
    inc word ptr cs:[0EDE7h]
loc_0EE03:
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h,0E1h,00h,065h,04Eh,0E2h,00h,065h,04Eh,0E3h,00h,065h,04Eh,0E4h,00h
    db 065h,04Eh,0E5h,00h,065h,04Eh,0E6h,00h,065h,04Eh,0E7h,00h,065h,04Eh,0E8h,00h
    db 065h,04Eh,0E9h,00h,065h,04Eh,0EAh,00h,065h,04Eh,0EBh,00h,065h,04Eh,0ECh,00h
    db 065h,04Eh,0EDh,00h,065h,04Eh,0EEh,00h,065h,04Eh,0EFh,00h,065h,04Eh,0F0h,00h
    db 065h,04Eh,0F1h,00h,065h,04Eh,0F2h,00h,065h,04Eh,0F3h,00h,065h,04Eh,0F4h,00h
    db 065h,04Eh,0F5h,00h,065h,04Eh,0F6h,00h,065h,04Eh,0F7h,00h,065h,04Eh,0F8h,00h
    db 065h,04Eh,0F9h,00h,065h,04Eh,0FFh,0FFh,04h,00h,065h,04Eh,07h,00h,065h,04Eh
    db 0C9h,00h,05Fh,04Eh,0FFh,0FFh,0C4h,00h,065h,04Eh,05Ah,00h,065h,04Eh,0FFh,0FFh
    db 0CEh,00h,065h,04Eh,0CFh,00h,065h,04Eh,0D0h,00h,065h,04Eh,0D1h,00h,065h,04Eh
    db 0D2h,00h,065h,04Eh,0D3h,00h,065h,04Eh,0D4h,00h,065h,04Eh,0D5h,00h,065h,04Eh
    db 0D6h,00h,065h,04Eh,0D7h,00h,065h,04Eh,0D8h,00h,065h,04Eh,0D9h,00h,065h,04Eh
    db 0DAh,00h,065h,04Eh,0DBh,00h,065h,04Eh,0DCh,00h,065h,04Eh,0DDh,00h,065h,04Eh
    db 0DEh,00h,065h,04Eh,0DFh,00h,065h,04Eh,0E0h,00h,065h,04Eh,0E1h,00h,065h,04Eh
    db 0E2h,00h,065h,04Eh,0E3h,00h,065h,04Eh,0E4h,00h,065h,04Eh,0E5h,00h,065h,04Eh
    db 0E6h,00h,065h,04Eh,0E7h,00h,065h,04Eh,0E8h,00h,065h,04Eh,0E9h,00h,065h,04Eh
    db 0FFh,0FFh,0C9h,00h,05Fh,04Eh,0CEh,00h,065h,04Eh,0CFh,00h,065h,04Eh,0D0h,00h
    db 065h,04Eh,0D1h,00h,065h,04Eh,0D2h,00h,065h,04Eh,0D3h,00h,065h,04Eh,0D4h,00h
    db 065h,04Eh,0D5h,00h,065h,04Eh,0D6h,00h,065h,04Eh,0D7h,00h,065h,04Eh,0D8h,00h
    db 065h,04Eh,0D9h,00h,065h,04Eh,0DAh,00h,065h,04Eh,0DBh,00h,065h,04Eh,0DCh,00h
    db 065h,04Eh,0DDh,00h,065h,04Eh,0DEh,00h,065h,04Eh,0DFh,00h,065h,04Eh,0E0h,00h
    db 065h,04Eh,0FFh,0FFh,0D7h,00h,065h,04Eh,0D8h,00h,065h,04Eh,0D9h,00h,065h,04Eh
    db 0DAh,00h,065h,04Eh,0DBh,00h,065h,04Eh,0DCh,00h,065h,04Eh,0DDh,00h,065h,04Eh
    db 0DEh,00h,065h,04Eh,0DFh,00h,065h,04Eh,0E0h,00h,065h,04Eh,0E1h,00h,065h,04Eh
    db 0E2h,00h,065h,04Eh,0E3h,00h,065h,04Eh,0E4h,00h,065h,04Eh,0E5h,00h,065h,04Eh
    db 0E6h,00h,065h,04Eh,0E7h,00h,065h,04Eh,0E8h,00h,065h,04Eh,0E9h,00h,065h,04Eh
    db 0EAh,00h,065h,04Eh,0EBh,00h,065h,04Eh,0ECh,00h,065h,04Eh,0EDh,00h,065h,04Eh
    db 0EEh,00h,065h,04Eh,0EFh,00h,065h,04Eh,0FFh,0FFh
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[0D1FEh], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[0D200h], ax
    mov bx, word ptr ss:[bp + REC_TYPE]
    shl bx, 1
    jmp word ptr cs:[bx - 0103Ch]
; UNKNOWN: not yet classified as code or data
    db 045h,0BCh,03Ch,0BEh,0D8h,0AEh,0D8h,0AEh,0BFh,0AEh,07Dh,0AEh,02Ch,0AEh,0DFh,0ADh
    db 0D9h,0ADh,0EFh,0ADh,0B0h,0B1h,04Dh,0B2h,09h,0AEh,045h,0BCh,045h,0BCh,0F2h,0ADh
    db 0BCh,0B2h,0C3h,0B2h,0CDh,0B2h,04Fh,08Dh,0F0h,0B9h,04Fh,08Dh,030h,0B9h,030h,0B9h
    db 08Ch,0B9h,0F0h,0BAh,0D4h,0BAh,0C7h,0BAh,04Fh,08Dh,06Dh,0B8h,09h,0B9h,04Fh,08Dh
    db 03Eh,0B7h,056h,0B5h,0DFh,0B3h,090h,0B6h,048h,082h,065h,082h,02h,083h,05Dh,083h
    db 076h,086h,021h,087h,076h,086h,015h,087h,0Eh,0B7h,0AFh,087h,0DAh,087h,020h,088h
    db 051h,088h,0AAh,088h,0B6h,088h,0CFh,088h,0E8h,088h,0DFh,0B3h,0CCh,0B3h,082h,089h
    db 0FFh,089h,023h,08Ah,055h,08Ah,07Eh,08Ah,0A4h,08Ah,0C7h,08Ah,0DDh,08Ah,0F6h,08Ah
    db 03Bh,08Bh,0C8h,08Bh,0F8h,08Bh,0D0h,08Bh,0D8h,08Bh,0E0h,08Bh,028h,08Ch,031h,08Ch
    db 03Ch,08Dh,03Ah,08Ch,0E8h,08Bh,06Dh,08Ch,094h,08Ch,0C2h,08Ch,0F6h,08Ch,0Ah,08Dh
    db 081h,0D2h,0F0h,08Bh,023h,08Dh,026h,08Dh,085h,0F1h,0D7h,0F1h,094h,0F1h,01h,0F2h
    db 01h,0F2h,025h,0F2h,068h,0F2h,0C0h,0F2h,0CFh,0F2h,0DBh,0F2h,0EBh,0F2h,04Dh,0F3h
    db 044h,087h,094h,0F3h,0BBh,0F3h,0B3h,0F4h,0FEh,0F4h,092h,0F4h,010h,0F5h,01Dh,0F5h
    db 0F9h,08Ah,080h,08Bh,075h,0F1h,02Ah,0F5h,054h,0F5h,03Fh,0F5h,01Bh,0F3h,0A3h,0F5h
    db 0BFh,0F5h,0A7h,087h,0DCh,0F5h,0F7h,0F5h,019h,0F6h,029h,0F7h,058h,0F7h,05Dh,0F7h
    db 062h,0F7h,076h,0F7h,0Ch,087h,047h,08Dh,07h,087h,04Fh,08Dh,04Fh,08Dh,073h,08Dh
    db 07Bh,08Dh,057h,08Dh,045h,0BCh,0E9h,089h,069h,0F6h,039h,0F6h,0EEh,0F0h,0ACh,0F1h
    db 03Ch,0F1h,0A6h,0B2h,01Fh,08Ch,088h,0BBh,080h,0BBh,040h,0BBh,048h,0BBh,069h,087h
    db 082h,082h,091h,082h,0F0h,0F6h,05Fh,08Dh,045h,0BCh,08Bh,01Eh,02Eh,023h,0D1h,0EBh
    db 0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0E3h,0BEh,02h,0D2h,083h,07Eh,06h,06h,074h
    db 03h,0BEh,0Ah,0D2h,08Bh,0C3h,08Bh,018h,089h,05Eh,08h,03Dh,04h,00h,074h,03h
    db 0E9h,02Eh,0CBh,083h,03Eh,02Eh,023h,026h,074h,03h,0E9h,024h,0CBh,0E8h,0D0h,090h
    db 083h,0FBh,0FFh,075h,03h,0E9h,019h,0CBh,0E8h,0B3h,083h,0C7h,047h,08h,0CBh,00h
    db 0C7h,047h,018h,060h,00h,0E9h,09h,0CBh,081h,07Eh,02h,080h,00h,073h,03h,0E9h
    db 0FFh,0CAh,08Bh,01Eh,02Eh,023h,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0E3h
    db 0BEh,012h,0D2h,083h,07Eh,06h,06h,074h,03h,0BEh,01Ah,0D2h,08Bh,0C3h,08Bh,018h
    db 089h,05Eh,08h,03Dh,04h,00h,074h,03h,0E9h,0D6h,0CAh,0E8h,0C5h,0D0h,0E9h,0D0h
    db 0CAh,083h,07Eh,02h,050h,074h,03h,0E9h,0C7h,0CAh,0C7h,046h,018h,056h,00h,0EBh
    db 0Fh,081h,07Eh,02h,0B0h,00h,074h,03h,0E9h,0B6h,0CAh,0C7h,046h,018h,056h,00h
    db 0E8h,041h,0BEh,075h,0Dh,0E8h,03Ch,0BEh,075h,08h,0E8h,037h,0BEh,075h,03h,0E9h
    db 09Fh,0CAh,0E8h,01Eh,0CEh,0E9h,099h,0CAh,08Bh,01Eh,02Eh,023h,0D1h,0EBh,0D1h,0EBh
    db 0D1h,0EBh,08Bh,0CBh,0D1h,0E3h,081h,0C3h,0C2h,096h,08Bh,01Fh,081h,0C3h,0DDh,00h
    db 089h,05Eh,08h,083h,07Eh,04h,060h,073h,03h,0E9h,0BCh,095h,083h,046h,08h,03h
    db 0E9h,0B5h,095h,083h,07Eh,06h,04h,074h,014h,0C7h,046h,08h,073h,00h,081h,07Eh
    db 02h,0B0h,00h,074h,03h,0E9h,059h,0CAh,0C7h,046h,06h,04h,00h,0A1h,028h,023h
    db 05h,077h,00h,089h,046h,08h,083h,046h,02h,04h,0E9h,04Ah,0CAh,081h,07Eh,02h
    db 080h,00h,073h,03h,0E9h,03Ah,0CAh,075h,03h,0E8h,011h,00h,0E8h,0C5h,0BDh,0E8h
    db 0C2h,0BDh,075h,03h,0E9h,02Ah,0CAh,0E9h,0A9h,0CDh,0E9h,0E2h,0C8h,0FFh,046h,08h
    db 0C3h,0C7h,046h,08h,048h,01h,083h,03Eh,056h,023h,00h,074h,018h,083h,03Eh,056h
    db 023h,06h,074h,011h,0C7h,046h,08h,074h,01h,083h,03Eh,056h,023h,04h,074h,05h
    db 0C7h,046h,08h,0E3h,00h,081h,07Eh,02h,080h,00h,07Fh,03h,0E9h,0F2h,0C9h,0A1h
    db 026h,023h,01h,046h,08h,081h,07Eh,02h,0C0h,00h,07Fh,03h,0E9h,0E2h,0C9h,0C7h
    db 046h,018h,05Ah,00h,0C7h,046h,08h,048h,01h,083h,03Eh,056h,023h,00h,074h,018h
    db 083h,03Eh,056h,023h,06h,074h,011h,0C7h,046h,08h,074h,01h,083h,03Eh,056h,023h
    db 04h,074h,05h,0C7h,046h,08h,0E3h,00h,0A1h,026h,023h,01h,046h,08h,0E8h,043h
    db 0BDh,075h,01Ah,0E8h,03Eh,0BDh,075h,015h,0E8h,039h,0BDh,075h,010h,083h,07Eh,04h
    db 00h,07Eh,0Ah,081h,07Eh,04h,0C0h,00h,07Dh,03h,0E9h,094h,0C9h,083h,076h,06h
    db 06h,0E8h,020h,0BDh,074h,03h,0E9h,0Ah,0CDh,0E9h,085h,0C9h,081h,07Eh,02h,0B0h
    db 00h,07Fh,03h,0E9h,07Bh,0C9h,0C7h,046h,018h,05Ch,00h,0C7h,046h,08h,073h,00h
    db 083h,06Eh,02h,04h,0E9h,06Ah,0C9h,0A1h,036h,023h,05h,077h,00h,089h,046h,08h
    db 083h,046h,02h,08h,0E9h,05Ah,0C9h,0E8h,0EAh,0BCh,0E8h,0E7h,0BCh,0E8h,0E4h,0BCh
    db 0E8h,0E1h,0BCh,075h,03h,0E9h,049h,0C9h,083h,07Eh,06h,04h,074h,09h,083h,07Eh
    db 06h,05h,074h,0Bh,0E9h,0BCh,0CCh,0C7h,046h,06h,05h,00h,0E9h,032h,0C9h,0C7h
    db 046h,06h,06h,00h,0E9h,02Ah,0C9h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h
    db 096h,081h,0C3h,028h,01h,089h,05Eh,08h,0E8h,0A9h,0BCh,0E8h,0A6h,0BCh,075h,03h
    db 0E9h,0Eh,0C9h,083h,07Eh,06h,04h,074h,08h,0C7h,046h,06h,04h,00h,0E9h,00h
    db 0C9h,0C7h,046h,06h,02h,00h,0E9h,0F8h,0C8h,0A1h,026h,023h,05h,0F6h,00h,089h
    db 046h,08h,08Bh,046h,02h,03h,046h,04h,03Dh,060h,00h,073h,03h,0E9h,0E1h,0C8h
    db 0E8h,071h,0BCh,0E8h,06Eh,0BCh,0E8h,06Bh,0BCh,0E8h,068h,0BCh,075h,03h,0E9h,0D0h
    db 0C8h,083h,07Eh,06h,06h,074h,09h,083h,07Eh,06h,02h,074h,0Bh,0E9h,043h,0CCh
    db 0C7h,046h,06h,03h,00h,0E9h,0B9h,0C8h,0C7h,046h,06h,05h,00h,0E9h,0B1h,0C8h
    db 08Bh,046h,034h,0A3h,06h,023h,08Bh,046h,032h,0A3h,04h,023h,0C7h,06h,08h,023h
    db 03h,00h,0E8h,09h,06Ah,083h,03Eh,0Ah,023h,00h,075h,03h,0E9h,092h,0C8h,0C7h
    db 046h,018h,062h,00h,0E9h,08Ah,0C8h,083h,03Eh,0CEh,0A8h,018h,073h,03h,0E9h,080h
    db 0C8h,0A1h,0CAh,0A8h,01h,046h,02h,081h,07Eh,02h,0D0h,00h,076h,019h,0C7h,046h
    db 08h,0E7h,00h,0C7h,046h,018h,061h,00h,083h,066h,02h,0F8h,083h,066h,04h,0F8h
    db 0C7h,046h,034h,020h,00h,0EBh,0A9h,0B8h,01h,00h,083h,03Eh,07Eh,0A4h,010h,077h
    db 021h,0B8h,02h,00h,083h,03Eh,07Eh,0A4h,08h,077h,017h,0B8h,04h,00h,083h,03Eh
    db 07Eh,0A4h,04h,077h,0Dh,0B8h,08h,00h,083h,03Eh,07Eh,0A4h,01h,077h,03h,0B8h
    db 010h,00h,0F7h,0D8h,021h,046h,04h,0F7h,0D8h,0BBh,0C0h,00h,0B9h,01h,00h,083h
    db 03Eh,0C6h,0A8h,00h,074h,07h,0F7h,0D8h,033h,0DBh,0B9h,00h,00h,01h,046h,04h
    db 039h,05Eh,04h,075h,0Dh,089h,0Eh,0C8h,0A8h,0C7h,06h,0CCh,0A8h,02h,00h,0E8h
    db 030h,080h,0A1h,080h,023h,039h,046h,04h,075h,0Fh,0E8h,044h,059h,083h,0E3h,01Fh
    db 075h,07h,0C7h,046h,018h,065h,00h,0EBh,056h,0A1h,040h,023h,025h,07Fh,00h,03Bh
    db 06h,030h,023h,074h,03h,0E9h,0D9h,0C7h,083h,03Eh,026h,023h,00h,074h,03h,0E9h
    db 0CFh,0C7h,0FFh,06h,040h,023h,0C7h,046h,06h,04h,00h,0E8h,0B5h,0CDh,083h,0FBh
    db 0FFh,075h,03h,0E9h,0BBh,0C7h,0C7h,047h,08h,063h,00h,0E9h,0B3h,0C7h,083h,046h
    db 02h,04h,083h,03Eh,026h,023h,03h,074h,03h,0E9h,0A5h,0C7h,081h,07Eh,08h,0EBh
    db 00h,075h,03h,0E9h,09Bh,0C7h,0FFh,046h,08h,0E8h,0C6h,07Fh,0E9h,092h,0C7h,083h
    db 07Eh,02h,050h,073h,03h,0E9h,089h,0C7h,081h,07Eh,08h,0E7h,00h,074h,02Bh,081h
    db 07Eh,08h,0E8h,00h,074h,024h,081h,07Eh,08h,0E9h,00h,074h,0Eh,081h,07Eh,08h
    db 0EAh,00h,074h,016h,083h,046h,02h,04h,0E9h,066h,0C7h,083h,046h,04h,02h,083h
    db 07Eh,04h,060h,074h,03h,0E9h,059h,0C7h,0EBh,0Ah,083h,03Eh,026h,023h,03h,074h
    db 03h,0E9h,04Dh,0C7h,0FFh,046h,08h,0E9h,047h,0C7h,0B8h,02h,00h,083h,03Eh,056h
    db 023h,04h,074h,02h,04h,02h,01h,046h,02h,0E9h,035h,0C7h,0C7h,046h,036h,022h
    db 0D2h,0C7h,046h,020h,014h,00h,0E9h,0ABh,0BDh,0C7h,046h,036h,072h,0D2h,0C7h,046h
    db 020h,014h,00h,0E9h,09Eh,0BDh,0C7h,06h,0C2h,0D2h,050h,00h,0A1h,02Ah,023h,0D1h
    db 0E8h,0D1h,0E8h,05h,01Fh,01h,089h,046h,08h,0EBh,01Bh,0C7h,06h,0C2h,0D2h,070h
    db 00h,0A1h,02Ah,023h,0D1h,0E8h,0D1h,0E8h,05h,024h,01h,089h,046h,08h,0EBh,06h
    db 0C7h,06h,0C2h,0D2h,060h,00h,083h,07Eh,02h,040h,073h,03h,0E9h,0E2h,0C6h,0A1h
    db 0C2h,0D2h,039h,046h,04h,074h,0Ch,077h,06h,083h,046h,04h,02h,0EBh,04h,083h
    db 06Eh,04h,02h,0FFh,046h,02h,083h,07Eh,018h,06Ch,074h,03h,0E9h,0C2h,0C6h,083h
    db 07Eh,04h,060h,074h,0Dh,083h,03Eh,02Ah,023h,0Fh,075h,03h,0E8h,0A4h,0CCh,0E9h
    db 0AFh,0C6h,083h,03Eh,026h,023h,03h,075h,03h,0E8h,097h,0CCh,0E9h,0A2h,0C6h,083h
    db 07Eh,02h,050h,073h,03h,0E9h,099h,0C6h,0A1h,07Eh,023h,02Bh,046h,02h,03Dh,020h
    db 00h,073h,03h,0E9h,08Bh,0C6h,0C7h,046h,018h,070h,00h,0A1h,02Ah,023h,0D1h,0E8h
    db 0D1h,0E8h,05h,033h,01h,089h,046h,08h,0E8h,094h,0B9h,083h,03Eh,028h,023h,07h
    db 075h,03h,0E8h,05Eh,0CCh,0E9h,069h,0C6h,0A1h,028h,023h,0D1h,0E8h,05h,01Ch,00h
    db 089h,046h,08h,0FFh,046h,02h,083h,03Eh,024h,023h,01h,075h,03h,0E8h,082h,07Eh
    db 0E9h,04Eh,0C6h,081h,07Eh,02h,080h,00h,073h,03h,0E9h,044h,0C6h,0C7h,046h,06h
    db 02h,00h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h,04Ch,01h
    db 089h,05Eh,08h,0EBh,020h,081h,07Eh,02h,090h,00h,073h,03h,0E9h,022h,0C6h,0C7h
    db 046h,06h,06h,00h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h
    db 04Fh,01h,089h,05Eh,08h,083h,07Eh,06h,02h,075h,07h,081h,07Eh,04h,0C0h,00h
    db 074h,01Dh,083h,07Eh,06h,06h,075h,06h,083h,07Eh,04h,00h,074h,011h,0E8h,083h
    db 0B9h,0E8h,080h,0B9h,0E8h,07Dh,0B9h,0E8h,07Ah,0B9h,075h,03h,0E9h,0E2h,0C5h,0E8h
    db 061h,0C9h,0E9h,0DCh,0C5h,08Bh,05Eh,06h,0D1h,0EBh,0D1h,0E3h,02Eh,0FFh,0A7h,076h
    db 0F6h,090h,07Eh,0F6h,0BCh,0F6h,0AFh,0F6h,0E3h,0F6h,0A1h,07Eh,023h,03Bh,046h,02h
    db 076h,03h,0E9h,0BCh,0C5h,0A1h,080h,023h,05h,08h,00h,083h,03Eh,084h,023h,00h
    db 074h,03h,05h,08h,00h,08Bh,05Eh,04h,025h,0F0h,0FFh,083h,0E3h,0F0h,03Bh,0C3h
    db 074h,03h,0E9h,09Ch,0C5h,0C7h,046h,018h,085h,00h,0C3h,0A1h,07Eh,023h,03Bh,046h
    db 02h,073h,03h,0E9h,08Bh,0C5h,0EBh,0CDh,0A1h,080h,023h,03Bh,046h,04h,073h,03h
    db 0E9h,07Eh,0C5h,08Bh,05Eh,02h,083h,0C3h,014h,083h,0E3h,0FCh,0A1h,07Eh,023h,025h
    db 0FCh,0FFh,03Bh,0C3h,074h,03h,0E9h,068h,0C5h,0C7h,046h,018h,085h,00h,0C3h,0A1h
    db 080h,023h,03Bh,046h,04h,076h,03h,0E9h,057h,0C5h,0EBh,0D7h,08Bh,05Eh,02h,083h
    db 0C3h,014h,083h,0E3h,0FCh,0A1h,07Eh,023h,025h,0FCh,0FFh,03Bh,0C3h,074h,03h,0E9h
    db 03Fh,0C5h,083h,06Eh,02h,04h,0E8h,0Eh,00h,083h,046h,02h,08h,0E8h,07h,00h
    db 083h,06Eh,02h,04h,0E9h,02Ah,0C5h,0E8h,019h,0CBh,083h,0FBh,0FFh,074h,05h,0C7h
    db 047h,08h,044h,00h,0C3h,083h,046h,02h,02h,083h,03Eh,026h,023h,03h,074h,03h
    db 0E9h,0Eh,0C5h,0FFh,076h,06h,0C7h,046h,06h,05h,00h,0E8h,0DBh,0CAh,0C7h,046h
    db 06h,03h,00h,0E8h,0D3h,0CAh,0C7h,046h,06h,04h,00h,0E8h,0CBh,0CAh,08Fh,046h
    db 06h,0E9h,0EDh,0C4h,0BEh,0C4h,0D2h,0EBh,01Ch,0BEh,0C8h,0D2h,0EBh,017h,0C7h,046h
    db 06h,04h,00h,083h,03Eh,030h,023h,0Fh,077h,03h,0E8h,05h,07Dh,0BEh,0CCh,0D2h
    db 0EBh,03h,0BEh,0D0h,0D2h,0ADh,03h,06h,0B8h,0A8h,089h,046h,02h,083h,07Eh,02h
    db 00h,07Dh,05h,0C7h,046h,02h,00h,00h,0ADh,03h,06h,0B6h,0A8h,089h,046h,04h
    db 0E9h,0AEh,0C4h

loc_0F797:
    mov bp, word ptr ds:[0A8BAh]
    push word ptr ds:[0A8B6h]
    pop word ptr ss:[bp + REC_X]
    push word ptr ds:[0A8B8h]
    pop word ptr ss:[bp + REC_Y]
loc_0F7A9:
    mov si, word ptr ds:[0A8C4h]
    lodsw
    cmp ax, 0FFFFh
    jne loc_0F7BB
    mov word ptr ds:[0A8C4h], 0D2D4h
    jmp short loc_0F7A9
loc_0F7BB:
    add ax, 020h
    mov word ptr ds:[02306h], ax
    lodsw
    mov word ptr ds:[02304h], ax
    mov word ptr ds:[02308h], 2
    call loc_05DB2
    push word ptr ss:[bp + REC_X]
    pop word ptr ds:[0A8B6h]
    push word ptr ss:[bp + REC_Y]
    pop word ptr ds:[0A8B8h]
    cmp word ptr ds:[0230Ah], 0
    jne loc_0F7E4
    ret
loc_0F7E4:
    mov word ptr ds:[0A8C4h], si
    jmp short loc_0F797
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h

MAIN ends
end