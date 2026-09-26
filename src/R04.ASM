; Modern physical chunk, NOT an inferred original object boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn GameOverRequest:far
extrn ImageEnd:far
extrn InputBits:far
extrn InstallCriticalErrorVector:far
extrn KeepLivesFlag:far
extrn KeyLastMakeCode:far
extrn LevelIndex:far
extrn LevelSkipEnabled:far
extrn LifeLostRequest:far
extrn LivesLeft:far
extrn NextLevelRequest:far
extrn QuitAnswer:far
extrn SfxActive:far
extrn SfxEnabled:far
extrn SfxRequest:far
extrn SoundModuleSelect:far
extrn SoundModuleSlot:far
extrn StateData:far
extrn loc_0F87C:far
extrn loc_0F980:far
extrn loc_0FA6A:far
extrn loc_0FC42:far
extrn loc_0FC63:far
extrn loc_10170:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public FarCallMainNearViaAX
public FarCallMainNearViaBP
public InitPositionHistory
public MainDataSegment
public PanelSegment
public PlaceFourRecordsFromOffsetTables
public ScreenSegment
public StoreApplyHistoryAndConditionalPlacement
public VideoAdapter
public WorkspaceSegment
public loc_081C9
public loc_081CC
public loc_08209
public loc_08331
public loc_0837A
public loc_08517
public loc_0859E
public loc_09DB9
public loc_09E19
public loc_09E69
public loc_09EE4
public loc_09F5F
extrn AllocateBuffers:near
extrn ApplyPositionHistoryToRecords:near
extrn BlitPackedStride104:near
extrn BlitPackedToScreen:near
extrn BuildByteToNibbleMaskTable:near
extrn ClearByteCS066B:near
extrn ClearScreen104x200:near
extrn CopyWorkspaceToScreen:near
extrn CountXReturn:near
extrn DecRecordXTwice:near
extrn DecRecordXUnlessZero:near
extrn DecRecordYByMode:near
extrn DrawOffsetFromRow9BC8:near
extrn DrawOffsetFromRow9EE8:near
extrn FindFreeRecordPoolA:near
extrn FlushBiosKeyboardBuffer:near
extrn IncRecordXBelowMax:near
extrn IncRecordXTwice:near
extrn IncRecordYTwice:near
extrn InstallKeyboardVector09:near
extrn InstallTimerVector08:near
extrn LoadHiscoreFile:near
extrn LoadSoundModule:near
extrn MeasureRetracePolarity:near
extrn PollInputBits:near
extrn RunChooseScreen:near
extrn RunTimedSequenceUntilPrimary:near
extrn ShowFatalErrorAndExit:near
extrn UpdateHighScoreTable:near
extrn UpdatePlacementXOffsetsAtRecordEdges:near
extrn WaitByteCS066B:near
extrn WaitVerticalRetrace:near
extrn loc_0073C:near
extrn loc_00747:near
extrn loc_00B3E:near
extrn loc_00CB8:near
extrn loc_00D42:near
extrn loc_00E9C:near
extrn loc_00F0B:near
extrn loc_04C76:near
extrn loc_04DBF:near
extrn loc_04FC3:near
extrn loc_04FF9:near
extrn loc_0511F:near
extrn loc_05145:near
extrn loc_05160:near
extrn loc_054C0:near
extrn loc_05559:near
extrn loc_057E6:near
extrn loc_05800:near
extrn loc_05BEE:near
extrn loc_05C22:near
extrn loc_05C35:near
extrn loc_05C9A:near
extrn loc_05F43:near
extrn loc_060A2:near
extrn loc_060AC:near
extrn loc_0613E:near
extrn loc_0615A:near
extrn loc_06176:near
extrn loc_061DC:near
extrn loc_074FE:near
extrn loc_077C5:near
extrn loc_077DF:near
extrn loc_07E58:near
extrn loc_0A067:near
extrn loc_0A212:near
extrn loc_0A66F:near
extrn loc_0A846:near
extrn loc_0A90C:near
extrn loc_0A940:near
extrn loc_0AC19:near
extrn loc_0B5A9:near
extrn loc_0BC4B:near
extrn loc_0BFC7:near
extrn loc_0C3A6:near
extrn loc_0C4DB:near
extrn loc_0C57C:near
extrn loc_0C5B1:near
extrn loc_0C5D6:near
extrn loc_0C83C:near
extrn loc_0C8AD:near
extrn loc_0CB1C:near
extrn loc_0CBE8:near
extrn loc_0CF22:near
; Offset-placement use of field+8 does not define its role in other record types.
; Modern position-history symbols.
; Modern record/state symbols.
; UNKNOWN: not yet classified as code or data
    db 0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,06Fh,00h,0C7h,047h,08h,036h,01h
    db 0C7h,047h,06h,03h,00h,083h,06Fh,04h,010h,083h,07Fh,04h,060h,073h,01h,0C3h
    db 0C7h,047h,06h,05h,00h,083h,047h,04h,020h,0C3h,0E8h,071h,01h,075h,01h,0C3h
    db 0C7h,047h,06h,00h,00h,0C7h,047h,018h,02Dh,00h,0C3h,0E8h,060h,01h,075h,01h
    db 0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,047h,00h,0C3h,0E8h,07Ah,01h,075h
    db 01h,0C3h,0C7h,047h,06h,07h,00h,0C7h,047h,018h,059h,00h,0C7h,047h,08h,0E3h
    db 00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,06h,01h,00h,0C3h,0E8h,058h
    db 01h,075h,01h,0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,05Fh,00h,083h,07Fh
    db 04h,060h,076h,01h,0C3h,0C7h,047h,06h,02h,00h,0C3h,0E8h,03Bh,01h,075h,01h
    db 0C3h,0C7h,047h,06h,00h,00h,0C7h,047h,018h,05Bh,00h,0C7h,047h,08h,074h,00h
    db 0C3h,0E8h,0FAh,00h,075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,05Dh
    db 00h,0C7h,047h,08h,077h,00h,0C3h,0E8h,0Fh,01h,075h,01h,0C3h,0C7h,047h,06h
    db 06h,00h,0C7h,047h,018h,087h,00h,0C7h,047h,08h,0E0h,00h,083h,07Fh,04h,060h
    db 076h,01h,0C3h,0C7h,047h,06h,02h,00h,0C7h,047h,08h,0DDh,00h,0C3h,0E8h,0E8h
    db 00h,075h,01h,0C3h,0C7h,047h,018h,055h,00h,0C7h,047h,08h,077h,00h,0C3h,0E8h
    db 0D7h,00h,075h,01h,0C3h,0C7h,047h,018h,034h,00h,0C3h,0E8h,0A0h,00h,075h,01h
    db 0C3h,0C7h,047h,018h,037h,00h,0C3h,0E8h,094h,00h,075h,01h,0C3h,0C7h,047h,018h
    db 083h,00h,0C3h,0E8h,0B3h,00h,075h,01h,0C3h,0C7h,047h,018h,04Fh,00h,0C3h,0E8h
    db 07Ch,00h,075h,01h,0C3h,0C7h,047h,018h,019h,00h,0C3h,0E8h,070h,00h,075h,01h
    db 0C3h,0C7h,047h,018h,035h,00h,0C3h,0E8h,08Fh,00h,075h,01h,0C3h,0C7h,047h,018h
    db 069h,00h,0C3h,083h,03Eh,056h,023h,05h,075h,010h,0E8h,048h,0CCh,083h,0E3h,0Fh
    db 083h,0FBh,0Fh,075h,05h,0E8h,046h,00h,0EBh,03h,0E8h,06Ch,00h,075h,01h,0C3h
    db 0C7h,047h,018h,068h,00h,0C3h,0E8h,035h,00h,075h,01h,0C3h,0C7h,047h,018h,089h
    db 00h,0C3h,0E8h,054h,00h,075h,01h,0C3h,0C7h,047h,018h,058h,00h,0C7h,047h,08h
    db 099h,00h,0C7h,047h,06h,02h,00h,0C3h,0E8h,03Eh,00h,075h,01h,0C3h,0C7h,047h
    db 018h,057h,00h,0C7h,047h,08h,09Bh,00h,0C7h,047h,06h,06h,00h,0C3h,0E8h,028h
    db 00h,083h,0FBh,0FFh,075h,01h,0C3h,0B8h,0FFh,0FFh,083h,03Eh,09Ah,020h,0FFh,074h
    db 011h,053h,08Bh,01Eh,09Ah,020h,0FEh,07h,0A0h,070h,020h,088h,047h,01h,05Bh,0A1h
    db 098h,020h,089h,047h,028h,0Dh,01h,00h,0C3h
loc_081C9:
    call loc_07E58
loc_081CC:
    call loc_081E9
    cmp bx, -1
    jne loc_081D5
    ret
loc_081D5:
    mov ax, word ptr ds:[0A40Ah]
    mov word ptr ds:[bx + 4], ax
    mov word ptr ds:[bx + 2], 010h
    mov word ptr ds:[bx + 0Ah], 0
    or ax, 1
    ret
loc_081E9:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_081F2
    ret
loc_081F2:
    jmp short loc_08209
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_081FD
    ret
loc_081FD:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_08209
    mov byte ptr ds:[SfxRequest], 0Bh
loc_08209:
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_DRAW_PASS], 1
    mov ax, word ptr ss:[bp + 2]
    mov word ptr ds:[bx + REC_Y], ax
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    mov ax, word ptr ss:[bp + 4]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_DIRECTION], 4
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], 4
    mov word ptr ds:[bx + REC_TYPE], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 4
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,03Eh,02Ch,023h,01Fh,074h,03h,0E9h,0F3h,039h,0E8h,0E2h,03Fh,083h,0FBh,0FFh
    db 075h,03h,0E9h,0E8h,039h,0C7h,047h,08h,01Eh,00h,0E9h,0E0h,039h,083h,03Eh,02Ch
    db 023h,01Fh,074h,03h,0E9h,0D6h,039h,0E8h,0C5h,03Fh,083h,0FBh,0FFh,075h,03h,0E9h
    db 0CBh,039h,0C7h,047h,08h,01Ah,00h,0E9h,0C3h,039h,0B8h,088h,00h,083h,03Eh,056h
    db 023h,04h,075h,012h,0B8h,06Ch,01h,0EBh,0Dh,0B8h,08Bh,00h,083h,03Eh,056h,023h
    db 04h,075h,03h,0B8h,06Fh,01h,089h,046h,08h,08Bh,01Eh,030h,023h,0D1h,0EBh,0D1h
    db 0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0E3h,08Bh,09Fh,0EAh,095h,01h,05Eh,08h
    db 083h,03Eh,02Ch,023h,01Fh,074h,03h,0E9h,083h,039h,0D1h,0E3h,02Eh,0FFh,0A7h,0CAh
    db 082h,090h,0DEh,082h,045h,0BCh,0D0h,082h,083h,046h,02h,04h,0E8h,060h,03Fh,083h
    db 06Eh,02h,04h,0E9h,067h,039h,083h,06Eh,02h,04h,0E8h,052h,03Fh,083h,046h,02h
    db 04h,0E9h,059h,039h,083h,03Eh,026h,023h,03h,074h,03h,0E9h,04Fh,039h,08Bh,046h
    db 032h,089h,046h,04h,0FFh,04Eh,08h,0E9h,043h,039h,081h,07Eh,08h,098h,00h,074h
    db 0E3h,081h,07Eh,08h,092h,00h,074h,0DCh,0E8h,0C5h,02Ch,075h,0Ah,081h,07Eh,04h
    db 0C0h,00h,073h,03h,0E9h,026h,039h,0FFh,046h,08h,080h,03Eh,0C0h,098h,00h,074h
    db 05h,0C6h,06h,0FFh,0BEh,01Eh,0E9h,014h,039h
loc_08331:
    mov si, word ptr ds:[095F2h]
    add si, 010h
    cmp word ptr ss:[bp + 2], si
    jg loc_0835B
    sub si, 020h
    cmp word ptr ss:[bp + 2], si
    jl loc_0835B
    mov si, word ptr ds:[095F4h]
    add si, 010h
    cmp word ptr ss:[bp + 4], si
    jg loc_0835B
    sub si, 020h
    cmp word ptr ss:[bp + 4], si
    jl loc_0835B
    stc
    ret
loc_0835B:
    clc
    ret
; UNKNOWN: not yet classified as code or data
    db 0A1h,038h,023h,0D1h,0E8h,0BBh,027h,00h,083h,03Eh,056h,023h,05h,075h,03h,0BBh
    db 024h,00h,03h,0C3h,089h,046h,08h,0FFh,046h,02h,0E9h,0CBh,038h

loc_0837A:
    cmp word ptr ds:[095FAh], -1
    jne loc_08382
    ret
loc_08382:
    mov bp, word ptr ds:[095FAh]
    shl bp, 1
    add bp, 095FCh
    mov bp, word ptr ss:[bp]
    mov si, word ptr ss:[bp + 6]
    mov word ptr ds:[095F8h], 0
loc_08398:
    mov bx, word ptr ss:[bp + 8]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov ax, word ptr ds:[bx + si + 2]
    cmp ax, 0FFFFh
    je loc_083D0
    push bp
    call ax
    pop bp
    jne loc_083CA
    inc word ptr ss:[bp + 8]
    inc word ptr ds:[095F8h]
    cmp word ptr ds:[095F8h], 0Ah
    jb loc_08398
    mov word ptr ss:[bp + 8], 0
    mov word ptr ss:[bp], 024h
    ret
loc_083CA:
    mov ax, word ptr ds:[bx + si]
    mov word ptr ss:[bp], ax
    ret
loc_083D0:
    mov word ptr ss:[bp + 8], 0
    jmp short loc_08398
; UNKNOWN: not yet classified as code or data
    db 033h,0C0h,0C3h,033h,0C0h,040h,0C3h,083h,03Eh,058h,0A9h,00h,0C3h,083h,03Eh,058h
    db 0A9h,01h,0C3h,083h,03Eh,058h,0A9h,02h,0C3h,083h,03Eh,058h,0A9h,03h,0C3h,083h
    db 03Eh,058h,0A9h,04h,0C3h,083h,03Eh,058h,0A9h,05h,0C3h,0C7h,06h,058h,0A9h,00h
    db 00h,0EBh,026h,0C7h,06h,058h,0A9h,01h,00h,0EBh,01Eh,0C7h,06h,058h,0A9h,02h
    db 00h,0EBh,016h,0C7h,06h,058h,0A9h,03h,00h,0EBh,0Eh,0C7h,06h,058h,0A9h,04h
    db 00h,0EBh,06h,0C7h,06h,058h,0A9h,05h,00h,0C7h,06h,0FAh,095h,0FFh,0FFh,0C3h
    db 083h,03Eh,05Eh,0A9h,01h,0C3h,0C7h,06h,05Eh,0A9h,01h,00h,0EBh,0EBh,083h,03Eh
    db 060h,0A9h,00h,074h,08Eh,0EBh,089h,0C7h,06h,060h,0A9h,04h,00h,0EBh,0DAh,083h
    db 03Eh,06Eh,0A9h,0FFh,075h,03h,0E9h,07Ah,0FFh,0E9h,074h,0FFh,0E8h,02Bh,019h,0EBh
    db 0C8h,083h,03Eh,066h,0A9h,0FFh,075h,03h,0E9h,068h,0FFh,083h,03Eh,068h,0A9h,0FFh
    db 075h,03h,0E9h,05Eh,0FFh,083h,03Eh,084h,023h,00h,075h,03h,0E9h,051h,0FFh,083h
    db 03Eh,06Ah,0A9h,0FFh,075h,03h,0E9h,04Ah,0FFh,083h,03Eh,06Ch,0A9h,0FFh,075h,03h
    db 0E9h,040h,0FFh,0E9h,03Ah,0FFh,0E8h,0BFh,01Ah,0EBh,08Eh,083h,03Eh,084h,023h,02h
    db 074h,03h,0E9h,02Bh,0FFh,083h,03Eh,062h,0A9h,0FFh,075h,03h,0E9h,024h,0FFh,083h
    db 03Eh,064h,0A9h,0FFh,075h,03h,0E9h,01Ah,0FFh,0E9h,014h,0FFh,0E8h,054h,01Ah,0E9h
    db 067h,0FFh,083h,03Eh,084h,023h,00h,075h,03h,0E9h,07h,0FFh,0E9h,01h,0FFh,0C6h
    db 06h,0FEh,0BEh,00h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,06h
    db 0C7h,06h,084h,023h,01h,00h,0E9h,040h,0FFh,083h,03Eh,084h,023h,02h,074h,03h
    db 0E9h,0E0h,0FEh,0E9h,0DAh,0FEh,0C6h,06h,0FEh,0BEh,00h,080h,03Eh,0C0h,098h,00h
    db 074h,05h,0C6h,06h,0FFh,0BEh,06h,0C7h,06h,084h,023h,02h,00h,0E9h,019h,0FFh

loc_08517:
    mov word ptr ds:[095FAh], 0FFFFh
    mov bp, 09682h
    mov ah, 087h
    call loc_0852B
    call loc_0852B
    call loc_0852B

loc_0852B:
    mov al, 01Ch
    push ax
    call DrawOffsetFromRow9EE8
    mov word ptr ss:[bp], 024h
    mov word ptr ss:[bp + 2], di
    mov word ptr ss:[bp + 8], 0
    add bp, 0Ah
    pop ax
    add ah, 010h
    ret

loc_08546:
    cmp word ptr ds:[095FAh], -1
    jne loc_0854E
    ret
loc_0854E:
    push bx
    push bp
    mov bp, word ptr ds:[095FAh]
    shl bp, 1
    add bp, 095FCh
    mov bp, word ptr ss:[bp]
    mov si, word ptr ss:[bp + 6]
    mov bx, word ptr ss:[bp + 8]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    push word ptr ds:[095FAh]
    call word ptr ds:[bx + si + 4]
    mov ax, word ptr ds:[095FAh]
    mov word ptr ds:[095F6h], ax
    pop word ptr ds:[095FAh]
    call loc_0837A
    mov ax, word ptr ds:[095F6h]
    mov word ptr ds:[095FAh], ax
    call loc_0859E
    cmp word ptr ds:[095FAh], -1
    jne loc_0859B
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0859B
    mov byte ptr ds:[SfxRequest], 9
loc_0859B:
    pop bp
    pop bx
    ret

loc_0859E:
    push bp
    call loc_085B5
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_085B3
    call loc_0511F
    call loc_085B5
    call loc_0511F
loc_085B3:
    pop bp
    ret

loc_085B5:
    mov bp, 09682h
    xor di, di
    call loc_085D5
    mov bp, 0968Ch
    mov di, 1
    call loc_085D5
    mov bp, 09696h
    mov di, 2
    call loc_085D5
    mov bp, 096A0h
    mov di, 3

loc_085D5:
    cmp word ptr ds:[095FAh], -1
    je loc_085ED
    mov si, word ptr ds:[095FAh]
    shl si, 1
    add si, 095FCh
    cmp bp, word ptr ds:[si]
    mov ax, 1
    je loc_085EF
loc_085ED:
    xor ax, ax
loc_085EF:
    cmp word ptr ds:[0BDACh], 1
    jne loc_08602
    cmp di, word ptr ds:[095FAh]
    jne loc_08602
    push word ptr ds:[0BE16h]
    jmp short loc_08605
loc_08602:
    push word ptr ss:[bp + REC_STATUS]
loc_08605:
    push ax
    mov si, word ptr ss:[bp + REC_X]
    add si, ax
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov di, word ptr ss:[bp + REC_Y]
    push di
    mov cx, 5
loc_0861B:
    call loc_0613E
    loop loc_0861B
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop di
    call loc_0615A
    pop si
    add si, 017h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    push di
    call BlitPackedToScreen
    pop di
    call loc_0613E
    pop si
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,03Eh,032h,023h,00h,075h,0Eh,0FFh,046h,06h,083h,07Eh,06h,018h,072h,05h
    db 0C7h,046h,06h,00h,00h,0BBh,0AAh,096h,08Bh,046h,06h,0D7h,03h,0C1h,089h,046h
    db 08h,0C3h,0B9h,01Ch,00h,083h,03Eh,056h,023h,01h,074h,0Ah,083h,03Eh,056h,023h
    db 04h,074h,03h,0B9h,01Ch,00h,0E8h,0C7h,0FFh,083h,03Eh,07Eh,0A4h,00h,074h,03h
    db 0E9h,0AEh,035h,083h,07Eh,06h,07h,074h,03h,0E9h,0A5h,035h,0FFh,046h,06h,0E8h
    db 04Eh,0FBh,083h,0FBh,0FFh,075h,03h,0E9h,097h,035h,0C7h,047h,020h,04h,00h,083h
    db 047h,02h,08h,083h,047h,04h,08h,083h,03Eh,056h,023h,01h,074h,018h,083h,03Eh
    db 056h,023h,04h,074h,011h,083h,03Eh,056h,023h,02h,074h,017h,083h,03Eh,056h,023h
    db 05h,074h,020h,0E9h,06Bh,035h,0C7h,047h,018h,029h,00h,0C7h,047h,08h,0A1h,00h
    db 0E9h,05Eh,035h,0C7h,047h,018h,02Bh,00h,0C7h,047h,08h,0A5h,00h,0E8h,0EEh,0EDh
    db 0E9h,04Eh,035h,0C7h,047h,018h,07Ah,00h,0C7h,047h,08h,020h,00h,0E8h,0DEh,0EDh
    db 0E9h,03Eh,035h,0B8h,05Ch,01h,0EBh,03h,0B8h,020h,00h,03h,06h,026h,023h,0EBh
    db 07h,0B8h,0A5h,00h,03h,06h,03Ch,023h,089h,046h,08h,0EBh,023h,081h,07Eh,08h
    db 0A4h,00h,074h,01Ch,083h,03Eh,028h,023h,07h,074h,03h,0E9h,013h,035h,0FFh,046h
    db 08h,081h,07Eh,08h,0A4h,00h,074h,03h,0E9h,06h,035h,08Bh,0DDh,0E8h,09Eh,0EDh
    db 0C7h,06h,012h,023h,02h,00h,0E8h,0F5h,0D6h,0C7h,06h,012h,023h,03h,00h,081h
    db 07Eh,04h,0C0h,00h,07Fh,09h,083h,07Eh,04h,00h,07Ch,03h,0E9h,0E2h,034h,0E8h
    db 061h,038h,0E9h,0DCh,034h,08Bh,01Eh,02Eh,023h,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,08Bh
    db 0CBh,0D1h,0E3h,08Bh,09Fh,0C2h,096h,081h,0C3h,0BFh,00h,089h,05Eh,08h,083h,07Eh
    db 04h,060h,077h,04h,083h,046h,08h,03h,083h,0F9h,03h,074h,03h,0E9h,0B1h,034h
    db 0E8h,0A0h,03Ah,083h,0FBh,0FFh,075h,03h,0E9h,0A6h,034h,0C7h,047h,08h,044h,00h
    db 0E9h,09Eh,034h,0A1h,036h,023h,05h,02Bh,01h,0EBh,06h,0A1h,03Ch,023h,05h,093h
    db 00h,089h,046h,08h,083h,07Eh,02h,060h,077h,015h,083h,03Eh,030h,023h,07Fh,074h
    db 03h,0E9h,07Dh,034h,0C7h,046h,06h,04h,00h,0E8h,067h,03Ah,0E9h,072h,034h,083h
    db 046h,02h,04h,0E9h,06Bh,034h,0A1h,078h,0A2h,01h,046h,034h,0E8h,0B2h,0C5h,083h
    db 0E3h,03h,081h,0C3h,0ADh,00h,089h,05Eh,08h,081h,07Eh,02h,080h,00h,07Dh,03h
    db 0E9h,04Eh,034h,075h,03h,0E8h,06h,00h,0E8h,02Ah,02Fh,0E9h,049h,034h,080h,03Eh
    db 0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Bh,0A1h,080h,023h,05h,08h,00h
    db 025h,0FEh,0FFh,089h,046h,032h,0C7h,046h,034h,030h,075h,0C3h,0C7h,046h,08h,043h
    db 00h,0C7h,06h,08h,023h,02h,00h,0E8h,0FBh,02Eh,09Ch,0A1h,078h,0A2h,01h,046h
    db 034h,09Dh,075h,03h,0E9h,0Ah,034h,083h,07Eh,032h,00h,074h,08h,0C7h,046h,032h
    db 00h,00h,0E9h,0FCh,033h,0C7h,046h,032h,0C0h,00h,0E9h,0F4h,033h,083h,03Eh,056h
    db 023h,05h,075h,018h,0A1h,080h,023h,02Bh,046h,04h,079h,02h,0F7h,0D8h,03Dh,0Ch
    db 00h,072h,09h,083h,07Eh,08h,046h,075h,03h,0E9h,0D5h,033h,08Bh,01Eh,03Ch,023h
    db 0D1h,0E3h,08Bh,09Fh,0D2h,096h,083h,0C3h,044h,089h,05Eh,08h,083h,03Eh,056h,023h
    db 05h,075h,07h,083h,03Eh,026h,023h,03h,0EBh,05h,083h,03Eh,02Ah,023h,0Fh,074h
    db 03h,0E9h,0ADh,033h,0E8h,09Ch,039h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h
    db 0FFh,0BEh,0Eh,0E9h,09Bh,033h,0C7h,046h,08h,02Eh,00h,083h,046h,02h,03h,0E9h
    db 08Fh,033h,0C7h,046h,08h,024h,00h,081h,07Eh,02h,090h,00h,074h,03h,0E9h,080h
    db 033h,0C7h,046h,018h,033h,00h,0C7h,046h,06h,07h,00h,0E8h,06h,027h,075h,0Dh
    db 0E8h,01h,027h,075h,08h,0E8h,0FCh,026h,075h,03h,0E9h,064h,033h,083h,076h,06h
    db 02h,0E9h,05Dh,033h,08Bh,01Eh,056h,023h,0D1h,0E3h,08Bh,09Fh,0DAh,096h,089h,05Eh
    db 08h,083h,07Eh,04h,060h,073h,043h,0FFh,04Eh,08h,083h,03Eh,056h,023h,06h,074h
    db 07h,083h,03Eh,056h,023h,00h,075h,09h,083h,07Eh,02h,050h,073h,03h,0E9h,030h
    db 033h,083h,03Eh,02Eh,023h,032h,073h,03h,0E9h,026h,033h,080h,03Eh,0C0h,098h,00h
    db 074h,05h,0C6h,06h,0FFh,0BEh,013h,0C7h,046h,06h,02h,00h,083h,03Eh,024h,023h
    db 01h,074h,045h,0C7h,046h,06h,03h,00h,0EBh,03Eh,083h,03Eh,056h,023h,06h,074h
    db 07h,083h,03Eh,056h,023h,00h,075h,09h,083h,07Eh,02h,050h,073h,03h,0E9h,0F0h
    db 032h,083h,03Eh,02Eh,023h,032h,073h,03h,0E9h,0E6h,032h,080h,03Eh,0C0h,098h,00h
    db 074h,05h,0C6h,06h,0FFh,0BEh,013h,0C7h,046h,06h,06h,00h,083h,03Eh,024h,023h
    db 01h,074h,05h,0C7h,046h,06h,05h,00h,0E8h,0B8h,038h,0E9h,0C3h,032h,0A1h,03Ch
    db 023h,05h,0B5h,00h,089h,046h,08h,0C7h,06h,0EAh,096h,01h,00h,083h,07Eh,04h
    db 060h,074h,018h,0C7h,06h,0EAh,096h,03h,00h,083h,07Eh,04h,050h,074h,0Ch,083h
    db 07Eh,04h,070h,074h,06h,0C7h,06h,0EAh,096h,05h,00h,0A1h,0EAh,096h,083h,07Eh
    db 06h,04h,074h,019h,0F7h,0D8h,01h,046h,02h,083h,07Eh,02h,08h,076h,03h,0E9h
    db 07Fh,032h,0C7h,046h,06h,04h,00h,0E8h,069h,038h,0E9h,074h,032h,01h,046h,02h
    db 081h,07Eh,02h,090h,00h,073h,03h,0E9h,067h,032h,0E8h,056h,038h,0C7h,046h,06h
    db 00h,00h,0E9h,05Ch,032h,0A1h,03Ch,023h,05h,010h,00h,089h,046h,08h,083h,03Eh
    db 02Eh,023h,03Fh,075h,03h,0E8h,0E5h,030h,0E9h,04h,031h,0B8h,03h,00h,083h,07Eh
    db 04h,00h,074h,0Dh,0B8h,05h,00h,081h,07Eh,04h,0C0h,00h,074h,03h,08Bh,046h
    db 06h,089h,046h,06h,0C7h,046h,08h,06Eh,00h,0E8h,043h,025h,0E9h,022h,032h,0C7h
    db 046h,08h,06Eh,00h,081h,07Eh,02h,080h,00h,07Ch,023h,075h,0Ch,080h,03Eh,0C0h
    db 098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Bh,0C7h,046h,06h,02h,00h,0E8h,01Bh
    db 025h,081h,07Eh,04h,0C0h,00h,077h,03h,0E9h,0F6h,031h,0E8h,075h,035h,0E9h,0F0h
    db 031h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,081h,0C3h,0D2h,096h,08Bh,01Fh,081h,0C3h,0CCh
    db 00h,089h,05Eh,08h,081h,07Eh,02h,080h,00h,07Dh,03h,0E9h,0D3h,031h,0BBh,07Ch
    db 023h,0E8h,0A3h,0D3h,0E8h,0C7h,0D3h,0E9h,0C7h,031h,0E8h,014h,0C3h,083h,0E3h,03h
    db 0B9h,0A9h,00h,083h,03Eh,056h,023h,06h,074h,07h,083h,03Eh,056h,023h,00h,075h
    db 03h,0B9h,052h,01h,03h,0D9h,089h,05Eh,08h,083h,046h,02h,02h,0E9h,0A1h,031h
    db 0C7h,046h,08h,0C5h,00h,081h,07Eh,02h,0B0h,00h,074h,03h,0E9h,092h,031h,080h
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Dh,0FFh,046h,018h,0C7h,046h
    db 06h,07h,00h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,081h,0C3h,0D2h,096h,08Bh,01Fh,081h
    db 0C3h,0C5h,00h,089h,05Eh,08h,0E9h,0F2h,0FDh,0C7h,046h,08h,0Eh,00h,081h,07Eh
    db 02h,0A0h,00h,07Dh,03h,0E9h,059h,031h,0C7h,046h,018h,03Fh,00h,08Bh,0DDh,0E8h
    db 0ECh,0E9h,0E9h,04Bh,0FCh,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,083h
    db 0C3h,024h,089h,05Eh,08h,083h,03Eh,056h,023h,04h,074h,03Ch,08Bh,01Eh,03Ch,023h
    db 0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h,0A1h,00h,089h,05Eh,08h,083h,03Eh,056h
    db 023h,05h,074h,024h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h
    db 00h,01h,089h,05Eh,08h,0EBh,011h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h
    db 096h,081h,0C3h,0CFh,00h,089h,05Eh,08h,0E8h,046h,0C2h,083h,0E3h,01h,0D1h,0E3h
    db 081h,0C3h,0ECh,096h,08Bh,037h,0A1h,02Eh,023h,025h,01h,00h,0D1h,0E0h,048h,01h
    db 02h,081h,07Eh,02h,080h,00h,07Dh,03h,0E9h,0D6h,030h,083h,03Eh,02Ch,023h,01Fh
    db 075h,03h,0E8h,0BEh,036h,083h,046h,02h,02h,0E9h,0C5h,030h,0A1h,02Ah,023h,0D1h
    db 0E8h,0D1h,0E8h,0D1h,0E8h,0BBh,03h,01h,083h,03Eh,056h,023h,04h,075h,03h,0BBh
    db 078h,01h,03h,0C3h,089h,046h,08h,0E8h,0F7h,0C1h,083h,0E3h,01h,0D1h,0E3h,081h
    db 0C3h,0ECh,096h,08Bh,037h,0A1h,02Eh,023h,025h,01h,00h,0D1h,0E0h,048h,0D1h,0E0h
    db 0D1h,0E0h,01h,02h,083h,07Eh,02h,018h,07Eh,03h,0E9h,084h,030h,083h,046h,02h
    db 08h,0E9h,07Dh,030h,0C7h,046h,036h,0F0h,096h,0E9h,0F8h,026h,0C7h,046h,036h,0Ch
    db 097h,0E9h,0F0h,026h,0C7h,046h,036h,024h,097h,0E9h,0E8h,026h,0C7h,046h,036h,03Ch
    db 097h,0E9h,0E0h,026h,0C7h,046h,036h,05Ch,097h,0E9h,0D8h,026h,0C7h,046h,036h,064h
    db 097h,0E9h,0D0h,026h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h
    db 0CFh,00h,089h,05Eh,08h,0FFh,046h,02h,083h,03Eh,02Eh,023h,01Fh,077h,06h,0FFh
    db 04Eh,04h,0E9h,02Ch,030h,0FFh,046h,04h,0E9h,026h,030h,0A1h,03Ch,023h,05h,09Dh
    db 00h,0E9h,084h,026h,0A1h,038h,023h,05h,04Bh,00h,0E9h,084h,0FBh,0A1h,038h,023h
    db 05h,051h,00h,0E9h,072h,026h,0B8h,01Dh,00h,089h,046h,08h,083h,046h,02h,02h
    db 083h,03Eh,02Ah,023h,0Fh,074h,03h,0E9h,0F7h,02Fh,0B9h,08h,00h,051h,0E8h,021h
    db 0E8h,059h,083h,0FBh,0FFh,075h,03h,0E9h,0E7h,02Fh,0C7h,047h,018h,04h,00h,049h
    db 089h,04Fh,06h,041h,0E2h,0E7h,0E9h,0D8h,02Fh,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh
    db 09Fh,0D2h,096h,081h,0C3h,0CFh,00h,089h,05Eh,08h,083h,07Eh,02h,040h,074h,03h
    db 0E9h,0BEh,02Fh,0C7h,046h,018h,033h,00h,0C7h,046h,06h,01h,00h,0E9h,03Bh,0FCh
    db 083h,07Eh,06h,00h,074h,014h,0C7h,046h,08h,074h,00h,081h,07Eh,02h,0B0h,00h
    db 074h,03h,0E9h,09Ch,02Fh,0C7h,046h,06h,00h,00h,0A1h,028h,023h,0D1h,0E8h,0D1h
    db 0E8h,05h,073h,00h,089h,046h,08h,083h,06Eh,02h,04h,0E9h,089h,02Fh,0C7h,046h
    db 08h,06Eh,00h,083h,07Eh,06h,04h,075h,0Fh,081h,07Eh,02h,080h,00h,074h,03h
    db 0E9h,06Eh,02Fh,0C7h,046h,06h,00h,00h,083h,06Eh,02h,04h,083h,07Eh,02h,060h
    db 074h,03h,0E9h,062h,02Fh,0C7h,046h,06h,02h,00h,0C7h,046h,018h,039h,00h,0E9h
    db 02Dh,0FDh,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h,0CFh,00h
    db 089h,05Eh,08h,0E9h,0B1h,0FBh,0A1h,028h,023h,03h,0C5h,03h,06h,040h,023h,025h
    db 07h,00h,05h,080h,00h,089h,046h,08h,083h,046h,02h,04h,0E9h,022h,02Fh,0E9h
    db 01Fh,02Fh,08Bh,01Eh,028h,023h,083h,0E3h,0FEh,08Bh,09Fh,0D2h,096h,03h,05Eh,036h
    db 089h,05Eh,08h,0E9h,0Bh,02Fh,0F8h,0C3h,09Ah,0C2h,01h,07Fh,0Fh,0E8h,032h,0E7h
    db 0E9h,0FEh,02Eh,09Ah,05Eh,02h,07Fh,0Fh,0E9h,0F6h,02Eh
    call far ptr loc_0FA6A
    jmp near ptr loc_0BC4B
    call far ptr loc_0FC42
    jmp near ptr loc_0BC4B
    call far ptr loc_0FC63
    cmp word ptr ss:[bp + REC_FIELD_36], 064h
    jae loc_08D6D
    jmp near ptr loc_0BC4B
loc_08D6D:
    call loc_0BFC7
    jmp near ptr loc_0BC4B
; UNKNOWN: not yet classified as code or data
    db 09Ah,09Ah,06h,07Fh,0Fh,0E9h,0D0h,02Eh,09Ah,0B5h,06h,07Fh,0Fh,0E9h,0C8h,02Eh
    db 09Ah,0ACh,08h,07Fh,0Fh,0E9h,0C0h,02Eh

; Far entry in main code frame. CALL AX invokes a near target in the same CS, then RETF returns to the outer far
; caller. Requires AX to name valid main-frame near code that returns with a balanced stack. No register,
; segment or flag marshalling: all callee effects pass through. During near callee entry SP is two bytes below
; bridge-entry SP; normal outer return advances entry SP by4. Stack-depth and asynchronous safety depend on
; callees/environment. This is original ASM control-flow glue, not a reconstructed C adapter.
FarCallMainNearViaAX:
    call ax
    retf

; Far entry in main code frame. CALL BP invokes a near target in the same CS, then RETF returns to the outer far
; caller. Requires BP to name valid main-frame near code that returns with a balanced stack. No register,
; segment or flag marshalling: all callee effects pass through. During near callee entry SP is two bytes below
; bridge-entry SP; normal outer return advances entry SP by4. Stack-depth and asynchronous safety depend on
; callees/environment. This is original ASM control-flow glue, not a reconstructed C adapter.
FarCallMainNearViaBP:
    call bp
    retf
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
    db 00h
    dw seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH ; ATTRIBUTE_SOURCE_SEGMENT (CS:9592)
    dw 0B800h                        ; CS:9594, B800h (role unreviewed)
; CS word holding the state segment (seg StateData); entry loads DS/SS from it.
MainDataSegment dw seg StateData ; MainDataSegment (CS:9596)
; CS-resident segment and state words from CS:9598, zero until initialization.
; 64 KiB general work buffer (the 104-byte-wide play workspace, screen images).
WorkspaceSegment dw 00000h
    db 00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h
; Buffers set up by AllocateBuffers (CS words in the main frame).
; Current screen segment: from the adapter's geometry table; EGA flips it between
; A000h and A200h.
ScreenSegment dw 00000h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h
; Holds PANEL.ENC, the menu/HUD graphics drawn by DrawPanelGraphic.
PanelSegment dw 00000h
    db 00h,00h,00h,00h,00h,00h
VideoAdapter dw 00000h
    db 00h,00h,00h
    db 00h,00h,00h
; Entry ProgramEntry saves the DOS entry ES/DS (both the PSP at EXE start).
EntryEsPsp dw 00000h
EntryDsPsp dw 00000h
LauncherOverrideMask db 00h

; EXE entry point. Set DS/SS to the state segment, install the critical-error vector and
; shrink the memory block. The launcher passes three bytes at PSP:81h: an override mask,
; the video adapter (0 CGA, 1 EGA, 2 Tandy; values above 2 become 1) and the sound module
; letter. Settings saved in hiscore.dat win unless the mask is exactly F0h (video), 0Fh
; (sound) or FFh (both). Then initialize, set the BIOS video mode and run the game loops;
; never returns (exits through ShutdownGame).
ProgramEntry:
    mov word ptr cs:[EntryEsPsp], es
    mov word ptr cs:[EntryDsPsp], ds
    cld
    cli
    mov ds, word ptr cs:[MainDataSegment]
    mov ss, word ptr cs:[MainDataSegment]
    mov sp, INITIAL_STACK_TOP
    sti
; InstallCriticalErrorVector: far code frame1534, entry003C. The handler
; owns CS-private scratch; this crossing alone does not prove an OBJ boundary.
    call far ptr InstallCriticalErrorVector
    mov es, word ptr cs:[EntryEsPsp]
    mov ax, es
    mov bx, seg ImageEnd
    sub bx, ax
    mov ah, DOS_RESIZE_MEMORY
    int 021h
    mov dx, MSG_DEALLOC_ERROR
    jae loc_09600
    jmp near ptr ShowFatalErrorAndExit
loc_09600:
    call BuildByteToNibbleMaskTable
    mov ds, word ptr cs:[EntryDsPsp]
    mov si, PSP_COMMAND_TAIL
    mov es, word ptr cs:[MainDataSegment]
    lodsb
    lodsb
    mov byte ptr cs:[LauncherOverrideMask], al
    lodsb
    xor ah, ah
    cmp ax, 2
    jbe loc_09620
    mov al, 1
loc_09620:
    mov word ptr cs:[VideoAdapter], ax
    push ax
    lodsb
    mov ds, word ptr cs:[MainDataSegment]
    mov byte ptr ds:[SoundModuleSelect], al
    push ax
    call LoadHiscoreFile
    pop ax
    pop bx
    cmp byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_VIDEO
    je loc_0964C
    cmp byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_SOUND
    je loc_0964C
    cmp byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_BOTH
    jne loc_0966E
loc_0964C:
    test byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_VIDEO
    je loc_09657
    call loc_09664
loc_09657:
    test byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_SOUND
    je loc_09662
    call loc_0966A
loc_09662:
    jmp short loc_0966E

loc_09664:
    mov word ptr cs:[VideoAdapter], bx
    ret

loc_0966A:
    mov byte ptr ds:[SoundModuleSelect], al
    ret
loc_0966E:
    call loc_0C5B1
    call loc_0C8AD
    push ds
    call InstallTimerVector08
    pop ds
    call InstallKeyboardVector09
    call loc_0CF22
    call MeasureRetracePolarity
    call far ptr loc_0F980
    call loc_0C83C
    call loc_0C5D6
    call LoadSoundModule
    call AllocateBuffers
    call loc_00F0B
    call loc_04C76
    call loc_054C0
    call loc_00D42
    mov word ptr cs:[0BDEh], 01314h
    mov ax, word ptr cs:[WorkspaceSegment]
    add ax, 07D0h
    inc ax
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0BE2h
    call loc_00CB8
    call loc_05800
    call loc_05C22
    mov cx, 0FAh
loc_096C5:
    call WaitVerticalRetrace
    loop loc_096C5
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, VIDEO_BIOS_MODE_TABLE
    xlat
    int 010h
    mov word ptr ds:[021A2h], 1
    call loc_05BEE
    call loc_0CBE8
; Options menu and choose screen, then reset level, lives and score and start the
; first level. GameOver returns here.
StartNewGame:
    mov al, 2
    call loc_0CB1C
    call loc_04FC3
    call loc_05145
    call loc_05559
    mov word ptr ds:[LevelIndex], 0
    mov word ptr ds:[LivesLeft], INITIAL_LIVES
    mov word ptr ds:[0235Ah], 0
    mov word ptr ds:[GameOverRequest], 0
    mov byte ptr ds:[SCORE_BCD], 0
    mov byte ptr ds:[SCORE_BCD + 1], 0
    mov byte ptr ds:[SCORE_BCD + 2], 0
    mov byte ptr ds:[SCORE_BCD + 3], 0
    call RunChooseScreen
    call loc_05C9A
    call loc_0C4DB
    mov word ptr ds:[0A95Ah], 3
    mov word ptr ds:[0A95Ch], 018h
    call loc_06176
    jmp short AdvanceLevel
; Entered on NextLevelRequest, or F4 when LevelSkipEnabled. An interlude screen is
; shown when the completed LevelIndex is 0.
CompleteLevel:
    cmp word ptr ds:[LevelIndex], 0
    jne AdvanceLevel
    call ShowInterludeAndWaitPrimary
    call loc_05BEE
    call loc_00747
; Step LevelIndex modulo LEVEL_COUNT, request effect 4, then load and draw the level.
AdvanceLevel:
    inc word ptr ds:[LevelIndex]
    cmp word ptr ds:[LevelIndex], LEVEL_COUNT
    jb @@index_in_range
    mov word ptr ds:[LevelIndex], 0
@@index_in_range:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@start_level
    mov byte ptr ds:[SfxRequest], 4
@@start_level:
    call loc_05145
    call ClearScreen104x200
    call loc_06176
    call loc_00B3E
    call loc_00E9C
    call loc_060AC
; Start a life (GameOver once LivesLeft reaches -1): reset the level objects and the primary
; record, place it and redraw.
StartLife:
    cmp word ptr ds:[LivesLeft], -1
    jne @@setup_life
    jmp near ptr GameOver
@@setup_life:
    call loc_0C3A6
    call loc_077C5
    call InitPositionHistory
    call loc_06176
    mov bp, PRIMARY_RECORD
    call StoreApplyHistoryAndConditionalPlacement
    call loc_0A940
    mov word ptr ds:[020A6h], 020A8h
    call loc_0C57C
    call loc_0B5A9
    mov word ptr ds:[0A8C2h], 0
    call loc_05F43
    cmp word ptr ds:[02350h], 09Ch
    jne GameFrame
    call RunTimedSequenceUntilPrimary
; One game frame, paced by the timer (WaitByteCS066B): update and draw, act on the
; requests raised this frame, then F4 (level skip), F10 (pause) and Esc (quit prompt).
GameFrame:
    call ClearByteCS066B
    call loc_0511F
    call loc_0A846
    cmp word ptr ds:[0A97Ah], 0
    jne @@marker_done
    call loc_0981F
@@marker_done:
    call CopyWorkspaceToScreen
    call loc_0A90C
    call loc_09B2E
    cmp word ptr ds:[NextLevelRequest], 1
    jne @@check_game_over
    jmp near ptr CompleteLevel
@@check_game_over:
    cmp word ptr ds:[GameOverRequest], 1
    jne @@check_life_lost
    jmp near ptr ForceGameOver
@@check_life_lost:
    cmp word ptr ds:[LifeLostRequest], 1
    jne @@frame_tail
    jmp near ptr LoseLife
@@frame_tail:
    call loc_0A940
    call loc_0073C
    call loc_060A2
    cmp byte ptr ds:[LevelSkipEnabled], 0
    je @@check_pause
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F4], KEY_STATE_DOWN
    jne @@check_pause
    jmp near ptr CompleteLevel
@@check_pause:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F10], KEY_STATE_DOWN
    jne @@check_quit
    call PauseGame
@@check_quit:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    je QuitPrompt
ResumeGameFrame:
    call loc_05160
    call WaitByteCS066B
    jmp short GameFrame

loc_0981F:
    mov al, 4
    mov ah, 058h
    call DrawOffsetFromRow9BC8
    add di, word ptr ds:[0234Ch]
    mov si, 029h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedStride104
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Show a message through 0F7F:0980 (AX=BED0h), wait 75 frames, then wait for the
; primary button (not for its release).
ShowInterludeAndWaitPrimary:
    call loc_05BEE
    mov ax, 0BED0h
    call far ptr loc_10170
    mov cx, 04Bh
@@delay:
    call WaitVerticalRetrace
    loop @@delay
@@wait_primary:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@wait_primary
    ret
; Esc: ask for Y/N. Y ends the game; anything else resumes the frame loop.
QuitPrompt:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@wait_esc_release
    mov byte ptr ds:[SfxRequest], 01Ch
@@wait_esc_release:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    je @@wait_esc_release
    call FlushBiosKeyboardBuffer
    call loc_0511F
    mov al, 4
    mov ah, 05Ch
    call DrawOffsetFromRow9EE8
    mov si, 028h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    call loc_0511F
@@poll_yes_no:
    mov byte ptr ds:[QuitAnswer], 'N'
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_N], KEY_STATE_DOWN
    je @@answered
    mov byte ptr ds:[QuitAnswer], 'Y'
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_Y], KEY_STATE_DOWN
    jne @@poll_yes_no
@@answered:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@check_yes
    mov byte ptr ds:[SfxRequest], 01Ch
@@check_yes:
    and byte ptr ds:[QuitAnswer], 0DFh
    cmp byte ptr ds:[QuitAnswer], 'Y'
    je @@confirmed
    jmp near ptr ResumeGameFrame
@@confirmed:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@quit_sfx
@@wait_sfx_idle:
    cmp byte ptr ds:[SfxActive], 0
    jne @@wait_sfx_idle
@@quit_sfx:
    cmp byte ptr ds:[SfxEnabled], 0
    je GameOver
    mov byte ptr ds:[SfxRequest], 1
; Pause 150 frames, update the high-score table and start again.
GameOver:
    call loc_05145
    call loc_057E6
    call loc_05C35
    mov cx, 096h
@@delay:
    call WaitVerticalRetrace
    loop @@delay
    call UpdateHighScoreTable
    jmp near ptr StartNewGame
; GameOverRequest: zero LivesLeft so that LoseLife ends the game.
ForceGameOver:
    mov word ptr ds:[LivesLeft], 0
; LifeLostRequest: take a life (unless KeepLivesFlag), play effect 2 and restart.
LoseLife:
    call loc_0C4DB
    dec word ptr ds:[LivesLeft]
    cmp byte ptr ds:[KeepLivesFlag], 0
    je @@life_sfx
    inc word ptr ds:[LivesLeft]
@@life_sfx:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@request_life_sfx
@@wait_sfx_idle:
    cmp byte ptr ds:[SfxActive], 0
    jne @@wait_sfx_idle
@@request_life_sfx:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@restart_life
    mov byte ptr ds:[SfxRequest], 2
@@restart_life:
    jmp near ptr StartLife

; F10: show the pause graphics until the primary button or F10.
PauseGame:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@wait_f10_release
    mov byte ptr ds:[SfxRequest], 01Ch
@@wait_f10_release:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F10], KEY_STATE_DOWN
    je @@wait_f10_release
    call loc_0511F
    mov al, 4
    mov ah, 048h
    call DrawOffsetFromRow9EE8
    mov si, 027h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov al, 4
    mov ah, 070h
    call DrawOffsetFromRow9EE8
    mov si, 026h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    call loc_0511F
    mov byte ptr ds:[KeyLastMakeCode], 0
@@wait_resume:
    call far ptr loc_0F87C
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@resume
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F10], KEY_STATE_DOWN
    jne @@wait_resume
@@resume:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@wait_f10_release_again
    mov byte ptr ds:[SfxRequest], 01Ch
@@wait_f10_release_again:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_F10], KEY_STATE_DOWN
    je @@wait_f10_release_again
    ret

; Near leaf. Set ES=CS:9596, BP=237Ch. With DF=0 fill48 four-byte pairs at ES:A27A with (SS:[237E]+8,
; SS:[2380]+9), modulo65536. Then DS:A33A/A33C/A33E/A340 become A27A/A2FE/A2BE/A27E. CX=0,DI=A33A,AX=last X+9;
; BX,DX,SI,DS,SS preserved. Flags from final ADD. Requires valid buffers and source not overwritten by
; destination for uniform-fill interpretation; loads repeat each iteration. Unlike later writes, initial X bias
; is9, not8.
InitPositionHistory:
    mov es, word ptr cs:[MainDataSegment]
    mov di, HISTORY_BEGIN
    mov cx, HISTORY_PAIR_COUNT
    mov bp, PRIMARY_RECORD
loc_099CD:
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 8
    stosw
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 9
    stosw
    loop loc_099CD
    mov word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_BEGIN
    mov word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_INITIAL_READ_15
    mov word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_INITIAL_READ_31
    mov word ptr ds:[HISTORY_CURSOR_47], HISTORY_INITIAL_CURSOR_47
    ret

loc_099F6:
    and word ptr ds:[PRIMARY_RECORD + REC_X], 0FFFEh
    mov byte ptr ds:[InputBits], 0
    mov bx, word ptr ds:[0A47Ch]
    shl bx, 1
    jmp word ptr cs:[bx - 065F4h]
; UNKNOWN: not yet classified as code or data
    db 090h,0AFh,044h,078h,09Ah,03Eh,09Ah,016h,09Ah,0AFh,044h,0C6h,06h,0BEh,098h,08h
    db 0E8h,09Bh,03h,0E8h,0C9h,03h,083h,03Eh,07Ah,0A9h,058h,074h,01h,0C3h,083h,03Eh
    db 05Ah,0A9h,03h,074h,01h,0C3h,083h,03Eh,05Ch,0A9h,018h,074h,01h,0C3h,0FFh,06h
    db 07Ch,0A4h,0C3h,083h,03Eh,084h,023h,00h,075h,018h,083h,03Eh,09Ch,0A3h,08h,074h
    db 04h,0FFh,06h,09Ch,0A3h,083h,03Eh,09Ah,0A3h,0F8h,074h,01Ch,0FFh,0Eh,09Ah,0A3h
    db 0EBh,016h,083h,03Eh,09Ch,0A3h,0Fh,074h,04h,0FFh,06h,09Ch,0A3h,083h,03Eh,09Ah
    db 0A3h,0F1h,074h,04h,0FFh,0Eh,09Ah,0A3h,0BEh,05Ch,0A3h,0EBh,03h,0BEh,058h,0A3h
    db 0E8h,053h,00h,080h,03Eh,0BEh,098h,00h,074h,01h,0C3h,0FFh,06h,07Ch,0A4h,083h
    db 03Eh,07Ch,0A4h,02h,074h,03h,0E9h,062h,0FFh,0C7h,06h,09Ah,0A3h,00h,00h,0C7h
    db 06h,09Ch,0A3h,00h,00h,0E8h,081h,0DAh,0C7h,07h,01h,00h,0C7h,047h,016h,04h
    db 00h,0C7h,047h,018h,052h,00h,0C7h,047h,014h,02h,00h,0C7h,047h,028h,0FFh,0FFh
    db 0C7h,047h,08h,0Fh,00h,0C7h,047h,02h,020h,00h,0C7h,047h,04h,058h,00h,089h
    db 01Eh,088h,097h,0E9h,025h,0FFh,0ADh,039h,06h,07Eh,023h,074h,0Ch,0C6h,06h,0BEh
    db 098h,04h,072h,05h,0C6h,06h,0BEh,098h,08h,0ADh,039h,06h,080h,023h,074h,013h
    db 09Ch,080h,0Eh,0BEh,098h,01h,09Dh,072h,0Ah,080h,026h,0BEh,098h,0FEh,080h,0Eh
    db 0BEh,098h,02h,0C3h
loc_09AFF:
    cmp word ptr ds:[02326h], 3
    je loc_09B07
    ret
loc_09B07:
    inc word ptr ss:[bp + 8]
    cmp word ptr ss:[bp + 8], 0Fh
    je loc_09B11
    ret
loc_09B11:
    mov word ptr ss:[bp], 0
    call loc_04DBF
    mov word ptr ds:[LifeLostRequest], 1
    cmp word ptr ds:[0A97Ah], 0
    je loc_09B27
    ret
loc_09B27:
    mov word ptr ds:[GameOverRequest], 1
    ret

loc_09B2E:
    mov word ptr ds:[LifeLostRequest], 0
    mov word ptr ds:[NextLevelRequest], 0
    call PollInputBits
    cmp word ptr ds:[MOVE_MODE_A47C], 0
    je loc_09B47
    call loc_099F6
loc_09B47:
    cmp word ptr ds:[MOVE_MODE_A47C], 4
    jne loc_09B55
    mov word ptr ds:[NextLevelRequest], 1
    ret
loc_09B55:
    mov word ptr ds:[0A278h], 0
    mov bp, PRIMARY_RECORD
    call loc_0A212
    cmp word ptr ds:[0A95Ah], -1
    je loc_09AFF
    cmp word ptr ds:[0A97Ah], 0
    je loc_09AFF
    test byte ptr ds:[InputBits], IN_YMINUS
    je loc_09B79
    call DecRecordYByMode
loc_09B79:
    test byte ptr ds:[InputBits], IN_YPLUS
    je loc_09B83
    call IncRecordYTwice
loc_09B83:
    test byte ptr ds:[InputBits], IN_XPLUS
    je loc_09B8D
    call IncRecordXTwice
loc_09B8D:
    test byte ptr ds:[InputBits], IN_XMINUS
    je loc_09B97
    call DecRecordXTwice
loc_09B97:
    cmp word ptr ds:[02350h], 0B6h
    jbe loc_09BA9
    test byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
    je loc_09BA9
    call loc_08546
loc_09BA9:
    call loc_0A66F
    call loc_0A067
    cmp byte ptr ds:[0978Eh], 0
    je loc_09BC0
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_3], KEY_STATE_DOWN
    jne loc_09BC0
    call loc_09D4D
loc_09BC0:
    cmp word ptr ds:[MOVE_MODE_A47C], 1
    ja loc_09BCA
    call UpdatePlacementXOffsetsAtRecordEdges
loc_09BCA:
    cmp word ptr ds:[MOVE_MODE_A47C], 0
    jne loc_09BDF
    call loc_09CB6
    cmp word ptr ds:[02350h], 0B6h
    jbe loc_09BDF
    call AdjustRecordXFromCounts
loc_09BDF:
    call AdvancePositionHistoryIfRequested

; Near entry9BE2 and fallthrough from9BDF. StorePositionHistory, then ApplyPositionHistoryToRecords, then
; PlaceFourRecordsFromOffsetTables iff word DS:BDAC!=0 OR unsigned word DS:2350>B6h. Normal RET9BFA; no cursor
; advance at this entry. Requires reviewed callee memory/segment/DF preconditions, including valid source record
; and selected table/index pairs. Preserve BP,CX,DX,DS,SS; ES becomes CS:9596 and DI follows the history store.
; AX,BX,SI and flags are path-dependent as documented in callees; not declared dead. Skipping placement
; preserves old clamp feedback and A398. No external hardware effects; shared state makes reentrancy unproved.
StoreApplyHistoryAndConditionalPlacement:
    call StorePositionHistory
    call ApplyPositionHistoryToRecords
; Placement runs if BDAC != 0 OR unsigned [2350] > B6h. Otherwise the
; previous clamp feedback survives; history writes do not clear it.
    cmp word ptr ds:[0BDACh], 0
    jne loc_09BF7
    cmp word ptr ds:[02350h], 0B6h
    jbe loc_09BFA
loc_09BF7:
    call PlaceFourRecordsFromOffsetTables
loc_09BFA:
    ret

loc_09BFB:
    inc ah
    ret

loc_09BFE:
    inc al
    ret

; Near entry; DS holds input/state, SS:BP the record. Clear DS:A360. If bit2 of DS:98BE absent and byte A39E==1,
; apply IncRecordXTwice and set A360=1. Then if bit1 absent and A39F==1, apply DecRecordXTwice and set A360=1.
; AH counts words A966/A96A notFFFF; AL counts A968/A96C notFFFF. If counts equal, return via shared44AF RET.
; Otherwise, if count difference magnitude2 or DS:2324!=1, set A360=1 and tail to one-step X increment for
; AH>AL, decrement otherwise. FlagA360 records taking an adjustment path even if bound prevents movement. Return
; AX=(AHcount<<8)|ALcount,BX=2*(ALcount+3*AHcount); CX,DX,SI,DI,BP and segments preserved. Flags are path-
; dependent; caller9BDF ignores them before overwrite in9CF1. Assumes normal entry and no asynchronous register
; corruption.
AdjustRecordXFromCounts:
    mov word ptr ds:[X_ADJUST_PATH_TAKEN], 0
    test byte ptr ds:[InputBits], IN_XMINUS
    jne loc_09C1E
    cmp byte ptr ds:[CLAMP_X_LOW_SEEN], 1
    jne loc_09C1E
    call IncRecordXTwice
    mov word ptr ds:[X_ADJUST_PATH_TAKEN], 1
loc_09C1E:
    test byte ptr ds:[InputBits], IN_XPLUS
    jne loc_09C35
    cmp byte ptr ds:[CLAMP_X_HIGH_SEEN], 1
    jne loc_09C35
    call DecRecordXTwice
    mov word ptr ds:[X_ADJUST_PATH_TAKEN], 1
loc_09C35:
    xor ax, ax
    cmp word ptr ds:[PLUS_SLOT_A966], -1
    je loc_09C41
    call loc_09BFB
loc_09C41:
    cmp word ptr ds:[MINUS_SLOT_A968], -1
    je loc_09C4B
    call loc_09BFE
loc_09C4B:
    cmp word ptr ds:[PLUS_SLOT_A96A], -1
    je loc_09C55
    call loc_09BFB
loc_09C55:
    cmp word ptr ds:[MINUS_SLOT_A96C], -1
    je loc_09C5F
    call loc_09BFE
loc_09C5F:
    mov bl, al
    xor bh, bh
    add bl, ah
    add bl, ah
    add bl, ah
    shl bx, 1
    jmp word ptr cs:[bx + CountXTable]
; Nine exhaustive targets for index AL_count + 3*AH_count, each count0..2.
CountXTable:
    dw CountXReturn ; CS-relative code pointer; counts AH=0, AL=0
    dw CountXDecIfGate ; CS-relative code pointer; counts AH=0, AL=1
    dw CountXDec ; CS-relative code pointer; counts AH=0, AL=2
    dw CountXIncIfGate ; CS-relative code pointer; counts AH=1, AL=0
    dw CountXReturn ; CS-relative code pointer; counts AH=1, AL=1
    dw CountXDecIfGate ; CS-relative code pointer; counts AH=1, AL=2
    dw CountXInc ; CS-relative code pointer; counts AH=2, AL=0
    dw CountXIncIfGate ; CS-relative code pointer; counts AH=2, AL=1
    dw CountXReturn ; CS-relative code pointer; counts AH=2, AL=2
CountXIncIfGate:
    cmp word ptr ds:[COUNT_GATE_2324], 1
    jne loc_09C8A
    ret
loc_09C8A:
    mov word ptr ds:[X_ADJUST_PATH_TAKEN], 1
    jmp near ptr IncRecordXBelowMax
CountXInc:
    mov word ptr ds:[X_ADJUST_PATH_TAKEN], 1
    jmp near ptr IncRecordXBelowMax
CountXDecIfGate:
    cmp word ptr ds:[COUNT_GATE_2324], 1
    jne loc_09CA4
    ret
loc_09CA4:
    mov word ptr ds:[X_ADJUST_PATH_TAKEN], 1
    jmp near ptr DecRecordXUnlessZero
CountXDec:
    mov word ptr ds:[X_ADJUST_PATH_TAKEN], 1
    jmp near ptr DecRecordXUnlessZero

loc_09CB6:
    call loc_04FF9
    jb loc_09CBC
    ret
loc_09CBC:
    push bp
    cmp word ptr ds:[0BEDCh], 0
    je loc_09CD1
    cmp word ptr ds:[0BEDCh], 1
    je loc_09CCE
    call loc_09E19
loc_09CCE:
    call loc_09E19
loc_09CD1:
    call loc_09E19
    call loc_09E19
    pop bp
    ret

; Near leaf. ES=CS:9596, DI=DS:A33A; with DF=0 store SS:[BP+2]+8 then SS:[BP+4]+8 to ES:DI/DI+2, modulo65536. DI
; advances4; AX holds X+8, flags from final ADD. BX,CX,DX,SI,BP,DS,SS preserved. Does not move the ring cursor.
; Assumes valid nonoverlapping record/history for pair semantics; the second source load occurs after the first
; store. DF is preserved, not cleared.
StorePositionHistory:
    mov es, word ptr cs:[MainDataSegment]
    mov di, word ptr ds:[HISTORY_WRITE_CURSOR]
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 8
    stosw
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 8
    stosw
    ret

; Near leaf. If low nibble of DS:98BE is zero and word DS:A360 is zero, return without writes. Otherwise advance
; each of four word cursors DS:A33A/A33C/A33E/A340 by4 modulo65536, replacing exactly A33Ah with A27Ah. Ring
; interpretation requires each cursor aligned within A27A..A336. No validation or >= wrap; invalid cursors
; remain mechanically advanced. All general/segment registers preserved. Flags changed by final TEST/CMP;
; caller9BDF falls through9BE2, whose9CD9 ADD kills them before use. Trigger means requested input/adjustment,
; not proof that a coordinate changed.
; Movement input or a prior adjustment path triggers advancement, not a
; comparison of old/new coordinates. A360 can survive a skipped AdjustRecordXFromCounts call.
AdvancePositionHistoryIfRequested:
    test byte ptr ds:[InputBits], INPUT_MOVEMENT_MASK
    jne loc_09D00
    cmp word ptr ds:[X_ADJUST_PATH_TAKEN], 0
    jne loc_09D00
    ret
loc_09D00:
    add word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_END
    jne loc_09D13
    mov word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_BEGIN
loc_09D13:
    add word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_END
    jne loc_09D26
    mov word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_BEGIN
loc_09D26:
    add word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_END
    jne loc_09D39
    mov word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_BEGIN
loc_09D39:
    add word ptr ds:[HISTORY_CURSOR_47], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HISTORY_CURSOR_47], HISTORY_END
    jne loc_09D4C
    mov word ptr ds:[HISTORY_CURSOR_47], HISTORY_BEGIN
loc_09D4C:
    ret

loc_09D4D:
    cmp byte ptr ds:[0978Eh], 0
    je loc_09D5B
loc_09D54:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_3], KEY_STATE_DOWN
    je loc_09D54
loc_09D5B:
    inc word ptr ds:[095FAh]
    and word ptr ds:[095FAh], 3
    jmp near ptr loc_0AC19
; UNKNOWN: not yet classified as code or data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Ch,083h,03Eh,05Ah,0A9h
    db 03h,074h,0Ah,0FFh,06h,05Ah,0A9h,055h,0E8h,040h,01h,05Dh,0C3h,083h,03Eh,05Ch
    db 0A9h,018h,074h,0F3h,0FFh,06h,05Ch,0A9h,0EBh,0F3h,083h,03Eh,06Eh,0A9h,0FFh,074h
    db 01h,0C3h,0E8h,062h,0D7h,089h,01Eh,06Eh,0A9h,0C7h,07h,01h,00h,0C7h,047h,014h
    db 01h,00h,0C7h,047h,016h,01h,00h,0C7h,047h,08h,0Fh,00h,0C7h,047h,020h,014h
    db 00h,0C3h

loc_09DB9:
    cmp word ptr ds:[0A97Ah], 058h
    jne loc_09DC1
    ret
loc_09DC1:
    cmp word ptr ds:[0A97Ch], 1
    jne loc_09DC9
    ret
loc_09DC9:
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
    jae loc_09DE9
    mov word ptr ds:[0A97Ch], 1
    cmp word ptr ds:[0BDACh], 1
    je loc_09DE9
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09DE9
    mov byte ptr ds:[SfxRequest], 0Dh
loc_09DE9:
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,03Eh,05Ch,0A9h,018h,075h,021h,083h,03Eh,05Ah,0A9h,03h,075h,01h,0C3h,080h
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Ch,0FFh,06h,05Ah,0A9h,0C7h
    db 06h,05Ch,0A9h,00h,00h,0E9h,0B0h,00h,0FFh,06h,05Ch,0A9h,0E9h,0A9h,00h

loc_09E19:
    cmp word ptr ds:[0A47Ch], 1
    jne loc_09E21
    ret
loc_09E21:
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
    jb loc_09E29
    ret
loc_09E29:
    cmp word ptr ds:[0A95Ah], -1
    jne loc_09E31
    ret
loc_09E31:
    mov word ptr ds:[PRIMARY_RECORD + REC_FLASH_TIMER], 8
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09E43
    mov byte ptr ds:[SfxRequest], 0Fh
loc_09E43:
    cmp word ptr ds:[0BEDCh], 0
    je loc_09E5D
    cmp word ptr ds:[0BEDCh], 1
    je loc_09E57
    dec word ptr ds:[0A95Ch]
    je loc_09E63
loc_09E57:
    dec word ptr ds:[0A95Ch]
    je loc_09E63
loc_09E5D:
    dec word ptr ds:[0A95Ch]
    jne loc_09EC2
loc_09E63:
    mov word ptr ds:[0A95Ch], 018h
loc_09E69:
    cmp word ptr ds:[0A47Ch], 1
    jne loc_09E71
    ret
loc_09E71:
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
    jb loc_09E79
    ret
loc_09E79:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09E85
    mov byte ptr ds:[SfxRequest], 3
loc_09E85:
    cmp word ptr ds:[0BEDCh], 0
    jne loc_09E98
    inc byte ptr ds:[0A362h]
    and byte ptr ds:[0A362h], 1
    je loc_09E98
    ret
loc_09E98:
    dec word ptr ds:[0A95Ah]
    cmp word ptr ds:[0A95Ah], -1
    jne loc_09EC2
    mov word ptr ds:[0A95Ch], 0
    cmp byte ptr ds:[09791h], 1
    je loc_09ED7
    mov word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09EC2
    mov byte ptr ds:[SfxRequest], 019h
loc_09EC2:
    call loc_061DC
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_09ED6
    call loc_0511F
    call loc_061DC
    call loc_0511F
loc_09ED6:
    ret
loc_09ED7:
    mov word ptr ds:[0A95Ah], 3
    mov word ptr ds:[0A95Ch], 018h
    ret

loc_09EE4:
    cmp word ptr ds:[0A97Ah], 0
    jne loc_09EEC
    ret
loc_09EEC:
    dec word ptr ds:[0A97Ah]
    je loc_09EF5
    jmp near ptr loc_077DF
loc_09EF5:
    cmp byte ptr ds:[0978Ch], 1
    je loc_09F11
    mov word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09F0E
    mov byte ptr ds:[SfxRequest], 019h
loc_09F0E:
    jmp near ptr loc_077DF
loc_09F11:
    mov word ptr ds:[0A97Ah], 058h
    jmp near ptr loc_077DF
; UNKNOWN: not yet classified as code or data
    db 055h,0E8h,02h,00h,05Dh,0C3h,083h,03Eh,062h,0A9h,0FFh,075h,09h,0E8h,0D4h,0D5h
    db 089h,01Eh,062h,0A9h,0EBh,011h,083h,03Eh,064h,0A9h,0FFh,075h,09h,0E8h,0C4h,0D5h
    db 089h,01Eh,064h,0A9h,0EBh,01h,0C3h
loc_09F41:
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 014h], 1
    mov word ptr ds:[bx + 016h], 1
    mov word ptr ds:[bx + 8], 014h
    mov word ptr ds:[bx + 020h], 050h
    mov word ptr ds:[bx + 0Ah], 1
    ret
loc_09F5F:
    mov word ptr ds:[0A364h], 2
    mov bx, 0A966h
    call loc_09F82
    mov bx, 0A968h
    call loc_09F82
    je loc_09F81
    mov bx, 0A96Ah
    call loc_09F82
    je loc_09F81
    mov bx, 0A96Ch
    call loc_09F82
loc_09F81:
    ret
loc_09F82:
    cmp word ptr ds:[bx], -1
    je loc_09F88
    ret
loc_09F88:
    mov word ptr ds:[0A366h], bx
    push bp
    mov bp, PRIMARY_RECORD
    call loc_074FE
    call loc_09F41
    mov word ptr ds:[bx + 8], 018h
    mov word ptr ds:[bx + 0Ah], 1
    mov di, word ptr ds:[0A366h]
    mov word ptr ds:[di], bx
    call PlaceFourRecordsFromOffsetTables
    pop bp
    dec word ptr ds:[0A364h]
    ret

; Closed near-entry cluster ending through shared9FEA leaf tail. Clear bytes DS:A39E/A39F. Set A398=A39A, apply
; PlaceRecordFromOffsetPair to slots A96C then A968 using tables A38C/A374. Set A398=A39C, apply to A96A then
; fall through for A966 using A380/A368. FFFF slots skipped. Clamp bytes aggregate whether any present record hit
; signed X clamp; they do not count records or report actual source movement. Preserve CX,DX,DI,BP and segments;
; AX,BX,SI scratch with path-dependent returns. No internal index bound; requires each selected table/index and
; record valid. Shared global A398 means non-reentrant without external protection.
PlaceFourRecordsFromOffsetTables:
    mov byte ptr ds:[CLAMP_X_LOW_SEEN], 0
    mov byte ptr ds:[CLAMP_X_HIGH_SEEN], 0
    mov ax, word ptr ds:[OFFSET_X_GROUP_A]
    mov word ptr ds:[OFFSET_X_WORK], ax
    mov si, OFFSET_TABLE_A38C
    mov bx, word ptr ds:[MINUS_SLOT_A96C]
    call PlaceRecordFromOffsetPair
    mov si, OFFSET_TABLE_A374
    mov bx, word ptr ds:[MINUS_SLOT_A968]
    call PlaceRecordFromOffsetPair
    mov ax, word ptr ds:[OFFSET_X_GROUP_B]
    mov word ptr ds:[OFFSET_X_WORK], ax
    mov si, OFFSET_TABLE_A380
    mov bx, word ptr ds:[PLUS_SLOT_A96A]
    call PlaceRecordFromOffsetPair
    mov si, OFFSET_TABLE_A368
    mov bx, word ptr ds:[PLUS_SLOT_A966]

; Near callable leaf and fallthrough tail of9FAF. BX=FFFF returns unchanged registers, flags CMP(BX,FFFF).
; Otherwise with DF=0 select pair at DS:(SI+4*SS:[BP+8]) modulo65536. Store Y=pair.word0+SS:[BP+2] modulo65536
; to DS:[BX+2], then raw X=pair.word1+SS:[BP+4]+2*DS:A398 modulo65536 to DS:[BX+4]. Clamp signed raw X to0..192;
; set byte A39E on lower clamp, A39F on upper, never clear them. AX retains raw unclamped X; SI advances past
; pair; BX,CX,DX,DI,BP,segments preserved. Final flags compare post-lower-clamp X with192, before optional upper
; store. Requires valid index/pointers and nonaliasing for pair formula; actual sequential loads/stores remain
; authoritative.
PlaceRecordFromOffsetPair:
    cmp bx, -1
    jne loc_09FF0
    ret
; Full word index, no bound check. Primary field 2384 can be assigned 3
; (9EB0/9EFC); D183 increments then D19C jumps to9FAF. Three pairs per
; adjacent group do NOT prove a 0..2 caller bound.
loc_09FF0:
    mov ax, word ptr ss:[bp + OFFSET_PAIR_INDEX_08]
    shl ax, 1
    shl ax, 1
    add si, ax
    lodsw
    add ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[bx + REC_Y], ax
MAIN ends
end ProgramEntry