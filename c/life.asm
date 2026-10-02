; Remaining intro/demo ASM enters the same C setup used by the session.
locals
extrn RESET_RECORDS_FOR_LIFE:near
extrn MainDataSegment:word
extrn FarCallMainNearViaBP:far
extrn PrimaryRecord:byte
MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public ResetRecordsForLife
ResetRecordsForLife:
    call RESET_RECORDS_FOR_LIFE
    mov bp, offset PrimaryRecord
    mov es, word ptr cs:[MainDataSegment]
    ret
MAIN ends
CGAME segment byte public 'CODE'
assume cs:CGAME
public LIFE_REQUEST_MUSIC
; AX = tune, SI = inherited ES; return AX = the sound service's resulting ES.
LIFE_REQUEST_MUSIC:
    push bp
    mov es, si
    mov bp, offset RequestModuleMusic
    call far ptr FarCallMainNearViaBP
    mov ax, es
    pop bp
    ret
CGAME ends
end
