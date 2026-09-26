; Modern physical chunk, NOT an inferred original object boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn FileBufferOffset:far
extrn FileBufferSegment:far
extrn FileByteCount:far
extrn FileHandle:far
extrn FileNamePtr:far
extrn FileStatus:far
extrn InputBits:far
extrn KeyLastMakeCode:far
extrn LevelIndex:far
extrn ModuleSoundEnabled:far
extrn ModuleSoundRequest:far
extrn OpenResourceFile:far
extrn SfxActive:far
extrn SfxEnabled:far
extrn SfxRequest:far
extrn SfxTickPhase:far
extrn SoundModuleInitEntry:far
extrn SoundModuleLoaded:far
extrn SoundModuleSelect:far
extrn SoundModuleSlot:far
extrn loc_10112:far
extrn loc_153A0:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public LoadSoundModule
public MeasureRetracePolarity
public RunChooseScreen
public RunTimedSequenceUntilPrimary
public SfxTimerTick
public WaitVerticalRetracePulse
public loc_0C054
public loc_0C237
public loc_0C3A6
public loc_0C4DB
public loc_0C57C
public loc_0C591
public loc_0C5B1
public loc_0C5D6
public loc_0C640
public loc_0C679
public loc_0C83C
public loc_0C8AD
public loc_0CB1C
public loc_0CB3E
public loc_0CBE8
public loc_0CF22
extrn BlitPackedStride160:near
extrn BlitPackedToScreen:near
extrn ClearByteCS066B:near
extrn CopyWorkspaceToScreen:near
extrn DrawOffsetFromRow9D58:near
extrn DrawOffsetFromRow9EE8:near
extrn FindFreeRecordPoolA:near
extrn FindFreeRecordPoolB:near
extrn InitPositionHistory:near
extrn LoadPackedFile:near
extrn MainDataSegment:near
extrn PackedDestOffset:near
extrn PackedDestSegment:near
extrn PackedNamePtr:near
extrn PackedOutputBytes:near
extrn PanelSegment:near
extrn PlaceFourRecordsFromOffsetTables:near
extrn PollInputBits:near
extrn ScreenSegment:near
extrn StoreApplyHistoryAndConditionalPlacement:near
extrn VideoAdapter:near
extrn WaitByteCS066B:near
extrn WaitVerticalRetrace:near
extrn WorkspaceSegment:near
extrn loc_0073C:near
extrn loc_007EF:near
extrn loc_00CB8:near
extrn loc_04CED:near
extrn loc_04D64:near
extrn loc_04F57:near
extrn loc_04FC3:near
extrn loc_0511F:near
extrn loc_05145:near
extrn loc_05160:near
extrn loc_0518C:near
extrn loc_0526A:near
extrn loc_05BEE:near
extrn loc_05C04:near
extrn loc_05D0B:near
extrn loc_05DB2:near
extrn loc_05F61:near
extrn loc_060A2:near
extrn loc_07420:near
extrn loc_08209:near
extrn loc_08517:near
extrn loc_0859E:near
extrn loc_09DB9:near
extrn loc_09F5F:near
extrn loc_0A067:near
extrn loc_0A212:near
extrn loc_0A846:near
extrn loc_0A90C:near
extrn loc_0A940:near
extrn loc_0BE97:near
extrn loc_0ECC9:near
loc_0C054:
    cmp word ptr ss:[bp + REC_TYPE], 076h
    jne loc_0C05D
    jmp near ptr loc_0C15B
loc_0C05D:
    cmp word ptr ss:[bp + REC_TYPE], 077h
    jne loc_0C066
    jmp near ptr loc_0C15B
loc_0C066:
    cmp word ptr ss:[bp + REC_TYPE], 078h
    jne loc_0C06F
    jmp near ptr loc_0C15B
loc_0C06F:
    cmp word ptr ss:[bp + REC_TYPE], 079h
    jne loc_0C078
    jmp near ptr loc_0C15B
loc_0C078:
    cmp word ptr ss:[bp + REC_TYPE], 061h
    jne loc_0C081
    jmp near ptr loc_0C14F
loc_0C081:
    cmp word ptr ss:[bp + REC_TYPE], 062h
    jne loc_0C08A
    jmp near ptr loc_0C14F
loc_0C08A:
    cmp word ptr ss:[bp + REC_TYPE], 065h
    jne loc_0C093
    jmp near ptr loc_0C14F
loc_0C093:
    cmp word ptr ss:[bp + REC_TYPE], 014h
    jne loc_0C09C
    jmp near ptr loc_0C14F
loc_0C09C:
    cmp word ptr ss:[bp + REC_TYPE], 016h
    jne loc_0C0A5
    jmp near ptr loc_0C14F
loc_0C0A5:
    cmp word ptr ss:[bp + REC_TYPE], 017h
    jne loc_0C0AE
    jmp near ptr loc_0C14F
loc_0C0AE:
    cmp word ptr ss:[bp + REC_TYPE], 018h
    jne loc_0C0B7
    jmp near ptr loc_0C14F
loc_0C0B7:
    cmp word ptr ss:[bp + REC_TYPE], 07Fh
    jne loc_0C0C0
    jmp near ptr loc_0C14F
loc_0C0C0:
    cmp word ptr ss:[bp + REC_TYPE], 080h
    jne loc_0C0CA
    jmp near ptr loc_0C14F
loc_0C0CA:
    cmp word ptr ss:[bp + REC_TYPE], 081h
    je loc_0C14F
    cmp word ptr ss:[bp + REC_TYPE], 093h
    je loc_0C154
    cmp word ptr ss:[bp + REC_TYPE], 01Dh
    je loc_0C14F
    cmp word ptr ss:[bp + REC_TYPE], 01Eh
    je loc_0C14F
    cmp word ptr ss:[bp + REC_TYPE], 020h
    je loc_0C14F
    cmp word ptr ss:[bp + REC_TYPE], 021h
    je loc_0C14F
    cmp word ptr ss:[bp + REC_TYPE], 022h
    je loc_0C14F
    cmp word ptr ss:[bp + REC_TYPE], 07Eh
    mov ax, 0A79Ch
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 07Dh
    mov ax, 0A6F0h
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 01Fh
    mov ax, 0A83Eh
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 01Ch
    mov ax, 0A82Ah
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 015h
    mov ax, 0A5C0h
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 013h
    mov ax, 0A4E4h
    je loc_0C12D
    ret
loc_0C12D:
    mov word ptr ds:[0A482h], ax
    mov word ptr ds:[0A842h], 0A844h
    push bx
    push bp
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[02376h], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[02378h], ax
    mov ax, 2
    mov word ptr ds:[0237Ah], ax
    call loc_07420
    pop bp
    pop bx
loc_0C14F:
    dec word ptr ds:[0A47Eh]
    ret
loc_0C154:
    mov byte ptr ds:[098A8h], 1
    jmp short loc_0C14F
loc_0C15B:
    mov bx, word ptr ds:[0A8BAh]
    cmp bx, bp
    je loc_0C166
    call loc_0C194
loc_0C166:
    mov bx, word ptr ds:[0A8BCh]
    cmp bx, bp
    je loc_0C171
    call loc_0C194
loc_0C171:
    mov bx, word ptr ds:[0A8BEh]
    cmp bx, bp
    je loc_0C17C
    call loc_0C194
loc_0C17C:
    mov bx, word ptr ds:[0A8C0h]
    cmp bx, bp
    je loc_0C187
    call loc_0C194
loc_0C187:
    mov word ptr ds:[0A47Eh], 0
    mov word ptr ds:[0A8C2h], 0
    ret

loc_0C194:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0C1A0
    mov byte ptr ds:[SfxRequest], 019h
loc_0C1A0:
    mov ax, word ptr ds:[bx + 018h]
    mov word ptr ds:[bx + 01Ah], ax
    mov word ptr ds:[bx + 018h], 1
    mov word ptr ds:[bx + 022h], 0
    mov word ptr ds:[bx + 8], 3
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,046h,02h,0Bh,0C0h,079h,00h,0C7h,06h,054h,0A9h,00h,00h,08Bh,046h,04h
    db 02Dh,04h,00h,03Bh,06h,080h,023h,07Ch,0Bh,02Dh,02h,00h,03Bh,06h,080h,023h
    db 07Fh,0Ah,0EBh,0Eh,0C7h,06h,054h,0A9h,01h,00h,0EBh,06h,0C7h,06h,054h,0A9h
    db 02h,00h,08Bh,046h,02h,02Dh,04h,00h,03Bh,06h,07Eh,023h,07Ch,0Bh,02Dh,02h
    db 00h,03Bh,06h,07Eh,023h,07Fh,09h,0EBh,0Ch,083h,0Eh,054h,0A9h,04h,0EBh,05h
    db 083h,0Eh,054h,0A9h,08h,0BBh,048h,0A3h,0A1h,054h,0A9h,0D7h,03Ch,0FFh,075h,01h
    db 0C3h,089h,046h,06h,0E9h,0BBh,0EDh,0E8h,053h,0B3h,083h,0FBh,0FFh,075h,01h,0C3h
    db 08Bh,046h,04h,05h,0Ch,00h,089h,047h,04h,08Bh,046h,02h,05h,0Ch,00h,0EBh
    db 040h
loc_0C237:
    cmp word ptr ds:[0BEDCh], 2
    je loc_0C25F
    cmp word ptr ds:[0BEDCh], 1
    je loc_0C253
    inc byte ptr ds:[0A956h]
    and byte ptr ds:[0A956h], 3
    je loc_0C25F
    xor al, al
    ret
loc_0C253:
    inc byte ptr ds:[0A956h]
    and byte ptr ds:[0A956h], 1
    jne loc_0C25F
    ret
loc_0C25F:
    call FindFreeRecordPoolB
    cmp bx, -1
    jne loc_0C268
    ret
loc_0C268:
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 4
    mov word ptr ds:[bx + REC_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 4
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ds:[bx + REC_DIRECTION], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 0
    mov word ptr ds:[bx + REC_SPRITE], 030h
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], 2
    mov word ptr ds:[bx + REC_TYPE], 4
    mov word ptr ds:[bx + REC_FIELD_1C], 0FFFFh
    cmp word ptr ds:[bx + REC_Y], 8
    jae loc_0C2AE
    ret
loc_0C2AE:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe loc_0C2B6
    ret
loc_0C2B6:
    mov ax, bx
    mov bx, word ptr ss:[bp + REC_TYPE]
    cmp bx, 092h
    jne loc_0C2C4
    jmp near ptr loc_0C348
loc_0C2C4:
    and bx, 0Fh
    shl bx, 1
    jmp word ptr cs:[bx - 03D32h]
; UNKNOWN: not yet classified as code or data
    db 0EEh,0C2h,0FDh,0C2h,0Ch,0C3h,01Bh,0C3h,02Ah,0C3h,039h,0C3h,048h,0C3h,057h,0C3h
    db 066h,0C3h,075h,0C3h,084h,0C3h,093h,0C3h,039h,0C3h,048h,0C3h,075h,0C3h,066h,0C3h
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Bh,08Bh,0D8h,0C3h,080h
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Ch,08Bh,0D8h,0C3h,080h,03Eh
    db 0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Eh,08Bh,0D8h,0C3h
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0C327
    mov byte ptr ds:[SfxRequest], 011h
loc_0C327:
    mov bx, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,012h,08Bh,0D8h,0C3h,080h
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,013h,08Bh,0D8h,0C3h
loc_0C348:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0C354
    mov byte ptr ds:[SfxRequest], 014h
loc_0C354:
    mov bx, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,015h,08Bh,0D8h,0C3h,080h
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Ah,08Bh,0D8h,0C3h,080h,03Eh
    db 0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Bh,08Bh,0D8h,0C3h,080h,03Eh,0C0h
    db 098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,08Bh,0D8h,0C3h,080h,03Eh,0C0h,098h
    db 00h,074h,05h,0C6h,06h,0FFh,0BEh,018h,08Bh,0D8h,0C3h,00h,00h,00h,00h

loc_0C3A6:
    mov es, word ptr cs:[MainDataSegment]
    mov di, 02078h
    mov cx, 010h
    xor ax, ax
    rep stosw
    mov word ptr cs:[0C3A2h], 08D58h
    mov cx, POOL_B_COUNT
loc_0C3BF:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + POOL_B_POINTERS - 2]
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov ax, word ptr cs:[0C3A2h]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[0C3A2h], 040h
    pop cx
    loop loc_0C3BF
    mov word ptr cs:[0C3A2h], 03314h
    mov cx, POOL_A_POINTER_COUNT
loc_0C3F1:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
    mov word ptr ss:[bp + REC_DRAW_PASS], 1
    cmp word ptr ss:[bp + REC_KIND], 1
    je loc_0C41E
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_FLASH_TIMER], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_0C41E:
    mov ax, word ptr cs:[0C3A2h]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[0C3A2h], 0280h
    pop cx
    loop loc_0C3F1
    mov bp, PRIMARY_RECORD
    mov word ptr ss:[bp + REC_STATUS], 1
    mov word ptr ss:[bp + REC_KIND], 3
    mov word ptr ss:[bp + REC_SIZE_CLASS], 2
    mov word ptr ss:[bp + REC_Y], 0C0h
    mov word ptr ss:[bp + REC_X], 058h
    mov word ptr ss:[bp + REC_DRAW_PASS], 1
    call FindFreeRecordPoolA
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], 6
    mov es, word ptr cs:[MainDataSegment]
    mov di, 0A3B4h
    mov ax, 0FFFFh
    mov cx, 01Ah
    rep stosw
    mov word ptr ds:[0A95Ah], 3
    mov word ptr ds:[0A95Ch], 018h
    mov word ptr ds:[0A970h], 0
    mov word ptr ds:[0A972h], 0
    mov word ptr ds:[0A974h], 0
    mov word ptr ds:[0A976h], 0
    mov word ptr ds:[0A97Ah], 0
    mov word ptr ds:[0A97Eh], 0
    mov word ptr ds:[OFFSET_X_GROUP_A], 0
    mov word ptr ds:[OFFSET_X_GROUP_B], 0
    mov word ptr ds:[09788h], 0FFFFh
    call loc_09DB9
    mov word ptr ds:[0A980h], 0
    mov word ptr ds:[020A6h], 020A8h
    mov word ptr ds:[0A47Eh], 0
    mov word ptr ds:[0A480h], 0
    mov word ptr ds:[0A47Ch], 0
    mov word ptr ds:[02340h], 0
    ret

loc_0C4DB:
    mov word ptr cs:[0C3A2h], 03314h
    mov cx, POOL_A_POINTER_COUNT
loc_0C4E5:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_FLASH_TIMER], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov word ptr ss:[bp + REC_DRAW_PASS], 1
    mov word ptr ss:[bp + REC_DIRECTION], 0
    mov ax, word ptr cs:[0C3A2h]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[0C3A2h], 0280h
    pop cx
    loop loc_0C4E5
    mov word ptr ds:[0A958h], 0
    mov word ptr ds:[0A95Eh], 0
    mov word ptr ds:[0A960h], 0
    mov word ptr ds:[0A962h], 0FFFFh
    mov word ptr ds:[0A964h], 0FFFFh
    mov word ptr ds:[0A966h], 0FFFFh
    mov word ptr ds:[0A968h], 0FFFFh
    mov word ptr ds:[0A96Ah], 0FFFFh
    mov word ptr ds:[0A96Ch], 0FFFFh
    mov word ptr ds:[0A96Eh], 0FFFFh
    mov word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 0
    call loc_08517
    jmp near ptr loc_0859E
loc_0C565:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    jmp word ptr cs:[bx - 03A90h]
; UNKNOWN: not yet classified as code or data
    db 037h,04Fh,0C3h,04Fh,057h,04Fh,0C3h,04Fh,037h,04Fh,057h,04Fh

loc_0C57C:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_0C565
    mov si, 0A985h
    cmp word ptr ds:[LevelIndex], 1
    je loc_0C591
    mov si, 0A982h

loc_0C591:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_0C59A
    ret
loc_0C59A:
    cli
    mov dx, 03C8h
    mov al, 6
    out dx, al
    inc dx
    lodsb
    out dx, al
    lodsb
    out dx, al
    lodsb
    out dx, al
    mov dx, 03C8h
    in al, dx
    sti
    cmp al, 7
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_0C5B1:
    call loc_0C5BD
    jne loc_0C5BC
    mov byte ptr cs:[0C5B0h], 1
loc_0C5BC:
    ret

loc_0C5BD:
    cli
    mov dx, 03C8h
    mov al, 0
    out dx, al
    inc dx
    mov al, 0
    out dx, al
    mov al, 0
    out dx, al
    mov al, 0
    out dx, al
    mov dx, 03C8h
    in al, dx
    sti
    cmp al, 1
    ret

loc_0C5D6:
    mov dx, 0B928h
    mov ax, 03D00h
    int 021h
    jb loc_0C63A
    mov bx, ax
    mov ax, 04400h
    int 021h
    jb loc_0C63A
    and dx, 080h
    je loc_0C63A
    mov ax, 04407h
    int 021h
    jb loc_0C63A
    or al, al
    je loc_0C63A
    mov ah, DOS_CLOSE_FILE
    int 021h
    jb loc_0C63A
    mov ah, 040h
    int 067h
    or ah, ah
    jne loc_0C63A
    mov ah, 046h
    int 067h
    or ah, ah
    jne loc_0C63A
    cmp al, 030h
    jb loc_0C63A
    mov ah, 041h
    int 067h
    or ah, ah
    jne loc_0C63A
    mov word ptr ds:[0B932h], bx
    mov ah, 042h
    int 067h
    or ah, ah
    jne loc_0C63A
    mov word ptr ds:[0B934h], dx
    mov word ptr ds:[0B936h], bx
    or bx, bx
    je loc_0C63A
    mov byte ptr ds:[0B931h], 1
    ret
loc_0C63A:
    mov byte ptr ds:[0B931h], 0
    ret

loc_0C640:
    cmp byte ptr ds:[0B931h], 0
    jne loc_0C648
    ret
loc_0C648:
    mov si, 0B93Ah
loc_0C64B:
    cmp word ptr ds:[si], -1
    jne loc_0C651
    ret
loc_0C651:
    push si
    cmp word ptr ds:[si + 2], -1
    jne loc_0C65F
    mov dx, word ptr ds:[si + 6]
    mov ah, 045h
    int 067h
loc_0C65F:
    pop si
    add si, 0Ah
    jmp short loc_0C64B

loc_0C665:
    mov cx, bx
    xor ax, ax
loc_0C669:
    push ax
    push cx
    push dx
    mov bx, ax
    mov ah, 044h
    int 067h
    pop dx
    pop cx
    pop ax
    inc ax
    loop loc_0C669
    ret

loc_0C679:
    mov word ptr ds:[FileStatus], FILE_STATUS_OK
    call loc_0C7B2
    jne loc_0C685
    ret
loc_0C685:
    mov word ptr ds:[0BB82h], 0
loc_0C68B:
    call AdvanceABColonPrefix
    call loc_0C85B
    jne loc_0C6A5
    mov dx, word ptr ds:[FileNamePtr]
    xor al, al
    mov ah, 03Dh
    call far ptr OpenResourceFile
    mov word ptr ds:[FileHandle], ax
    jae loc_0C6B7
loc_0C6A5:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    je loc_0C6B4
    mov ah, DOS_GET_DRIVE
    int 021h
    cmp al, 2
    jb loc_0C68B
loc_0C6B4:
    jmp near ptr loc_05D0B
loc_0C6B7:
    cmp byte ptr ds:[0BB84h], 0
    je loc_0C6DC
    mov ax, word ptr ds:[FileHandle]
    mov word ptr cs:[0D666h], ax
    mov ax, word ptr ds:[FileBufferSegment]
    mov word ptr cs:[0ECF0h], ax
    mov ax, word ptr ds:[FileBufferOffset]
    mov word ptr cs:[0ECEEh], ax
    call loc_0ECC9
    mov ax, word ptr cs:[0EDE5h]
    jmp short loc_0C700
loc_0C6DC:
    mov bx, word ptr ds:[FileHandle]
    mov ah, DOS_CLOSE_FILE
    int 021h
    mov ax, word ptr ds:[FileNamePtr]
    mov word ptr cs:[PackedNamePtr], ax
    mov ax, word ptr ds:[FileBufferSegment]
    mov word ptr cs:[PackedDestSegment], ax
    mov ax, word ptr ds:[FileBufferOffset]
    mov word ptr cs:[PackedDestOffset], ax
    call LoadPackedFile
    mov ax, word ptr cs:[PackedOutputBytes]
loc_0C700:
    mov word ptr ds:[FileByteCount], ax
    call loc_0C707
    ret

loc_0C707:
    cmp word ptr cs:[VideoAdapter], VIDEO_TANDY
    jne loc_0C710
    ret
loc_0C710:
    mov si, 014D0h
loc_0C713:
    lodsw
    cmp ax, word ptr ds:[FileNamePtr]
    jne loc_0C71B
    ret
loc_0C71B:
    cmp ax, 0FFFFh
    jne loc_0C713
    cmp byte ptr ds:[0B931h], 0
    je loc_0C769
    mov bx, 1
    mov ax, word ptr ds:[FileByteCount]
loc_0C72D:
    sub ax, 04000h
    jb loc_0C737
    je loc_0C737
    inc bx
    jmp short loc_0C72D
loc_0C737:
    mov ah, 043h
    push bx
    int 067h
    pop bx
    or ah, ah
    jne loc_0C769
    mov es, word ptr cs:[MainDataSegment]
    mov di, word ptr ds:[0B938h]
    mov ax, word ptr ds:[FileNamePtr]
    stosw
    mov ax, 0FFFFh
    stosw
    mov ax, word ptr ds:[FileByteCount]
    stosw
    mov ax, dx
    stosw
    mov ax, bx
    stosw
    mov word ptr ds:[0B938h], di
    call loc_0C665
    mov bx, word ptr ds:[0B932h]
    jmp short loc_0C799
loc_0C769:
    mov bx, word ptr ds:[FileByteCount]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_0C77D
    ret
loc_0C77D:
    mov es, word ptr cs:[MainDataSegment]
    mov bx, ax
    mov di, word ptr ds:[0B938h]
    mov ax, word ptr ds:[FileNamePtr]
    stosw
    mov ax, bx
    stosw
    mov ax, word ptr ds:[FileByteCount]
    stosw
    stosw
    stosw
    mov word ptr ds:[0B938h], di
loc_0C799:
    mov si, word ptr ds:[FileBufferOffset]
    mov ds, word ptr ds:[FileBufferSegment]
    mov es, bx
    xor di, di
    mov cx, word ptr ss:[021A8h]
    rep movsb
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_0C7B2:
    mov si, 0B93Ah
    mov ax, word ptr ds:[FileNamePtr]
loc_0C7B8:
    cmp word ptr ds:[si], -1
    je loc_0C7FB
    cmp word ptr ds:[si], ax
    je loc_0C7C6
    add si, 0Ah
    jmp short loc_0C7B8
loc_0C7C6:
    cmp word ptr ds:[si + 2], -1
    jne loc_0C7DE
    mov dx, word ptr ds:[si + 6]
    mov bx, word ptr ds:[si + 8]
    push si
    call loc_0C665
    pop si
    mov ds, word ptr ss:[0B932h]
    jmp short loc_0C7E1
loc_0C7DE:
    mov ds, word ptr ds:[si + 2]
loc_0C7E1:
    mov cx, word ptr ss:[si + 4]
    xor si, si
    mov es, word ptr ss:[021A4h]
    mov di, word ptr ss:[021A6h]
    rep movsb
    mov ds, word ptr cs:[MainDataSegment]
    xor al, al
    ret
loc_0C7FB:
    or al, 1
    ret
; AL in 61h..7Ah becomes AL & DFh; all other values unchanged. AH and other registers
; preserved. Flags reflect the final CMP or AND, not a stable boolean ABI. Near RET.
UppercaseAsciiAL:
    cmp al, 061h
    jae loc_0C803
    ret
loc_0C803:
    cmp al, 07Ah
    jbe loc_0C808
    ret
loc_0C808:
    and al, 0DFh
    ret
; Read pointer DS:21AA. If byte +1 is colon and ASCII-case-folded byte +0 is A or B, retain
; it only when DS:BB86 (A) or DS:BB87 (B) equals exactly1; otherwise increment original byte
; +0 and retry. Case of stored prefix is preserved. Other prefixes return unchanged. Flags
; and AL/SI are scratch.
AdvanceABColonPrefix:
    mov si, word ptr ds:[FileNamePtr]
    cmp byte ptr ds:[si + 1], 03Ah
    je loc_0C816
    ret
loc_0C816:
    mov al, byte ptr ds:[si]
    call UppercaseAsciiAL
    cmp al, 041h
    je loc_0C824
    cmp al, 042h
    je loc_0C830
    ret
loc_0C824:
    cmp byte ptr ds:[0BB86h], 1
    jne loc_0C82C
    ret
loc_0C82C:
    inc byte ptr ds:[si]
    jmp short AdvanceABColonPrefix
loc_0C830:
    cmp byte ptr ds:[0BB87h], 1
    jne loc_0C838
    ret
loc_0C838:
    inc byte ptr ds:[si]
    jmp short AdvanceABColonPrefix

loc_0C83C:
    int 011h
    test al, 1
    jne loc_0C843
    ret
loc_0C843:
    mov byte ptr ds:[0BB86h], 1
    and al, 0C0h
    mov cl, 6
    shr al, cl
    inc al
    cmp al, 1
    jne loc_0C855
    ret
loc_0C855:
    mov byte ptr ds:[0BB87h], 1
    ret

loc_0C85B:
    mov si, word ptr ds:[FileNamePtr]
    mov al, byte ptr ds:[si]
    cmp byte ptr ds:[si + 1], 03Ah
    je loc_0C86D
    mov ah, DOS_GET_DRIVE
    int 021h
    add al, 041h
loc_0C86D:
    call UppercaseAsciiAL
    sub al, 041h
    cmp al, 2
    jae loc_0C886
    mov dl, al
    mov dh, 0
    mov cx, 0101h
    mov ax, 0401h
    int 013h
    and ah, 080h
    ret
loc_0C886:
    xor al, al
    ret
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0BDh,016h,0BCh,0E8h,0F2h
    db 088h,0BDh,041h,0BCh,0E8h,0ECh,088h,0BDh,06Ch,0BCh,0E8h,0E6h,088h,0BDh,097h,0BCh
    db 0E8h,0E0h,088h,0C3h

loc_0C8AD:
    mov word ptr cs:[0C88Ah], 0
    mov dx, 0BB88h
    call loc_0C8BD
    mov dx, 0BB96h

loc_0C8BD:
    mov word ptr ds:[FileNamePtr], dx
    mov bx, 0180h
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    mov word ptr cs:[0C892h], ax
    xor al, al
    mov ah, DOS_OPEN_FILE
    int 021h
    mov word ptr ds:[FileHandle], ax
    mov word ptr cs:[0C890h], 01234h
loc_0C8DC:
    mov ds, word ptr cs:[MainDataSegment]
    mov bx, word ptr ds:[FileHandle]
    mov ds, word ptr cs:[0C892h]
    mov cx, 042h
    xor di, di
    push si
    mov si, 01400h
    push ds
    pop es
    rep movsb
    mov cx, 01400h
    mov dx, 042h
    mov ah, DOS_READ_FILE
    int 021h
    pop si
    mov word ptr cs:[0C88Eh], ax
    mov ax, word ptr cs:[0C890h]
    mov cx, word ptr cs:[0C88Eh]
    jcxz loc_0C925
    mov si, 042h
    mov dh, 0
loc_0C916:
    mov dl, byte ptr ds:[si]
    add ax, dx
    add ah, al
    inc si
    loop loc_0C916
    mov word ptr cs:[0C890h], ax
    jmp short loc_0C8DC
loc_0C925:
    push ax
    push si
    push ds
    mov ds, word ptr cs:[MainDataSegment]
    mov bx, word ptr ds:[FileHandle]
    mov ah, DOS_CLOSE_FILE
    int 021h
    pop ds
    pop si
    pop ax
    mov dh, 0
    dec si
    mov dl, byte ptr ds:[si]
    sub ah, al
    sub ax, dx
    dec si
    mov dl, byte ptr ds:[si]
    sub ah, al
    sub ax, dx
    mov word ptr cs:[0C88Ch], ax
    cmp ax, word ptr ds:[si]
    pushf
    cmp word ptr cs:[0C88Ah], 1
    je loc_0C980
    cmp word ptr ss:[021AAh], 0BB88h
    jne loc_0C980
    sub si, 040h
    mov es, word ptr cs:[MainDataSegment]
    mov di, 0BC30h
    call XorCopy16BytesAA
    mov di, 0BC5Bh
    call XorCopy16BytesAA
    mov di, 0BC86h
    call XorCopy16BytesAA
    mov di, 0BCB1h
    call XorCopy16BytesAA
loc_0C980:
    mov es, word ptr cs:[0C892h]
    mov ah, DOS_FREE_MEMORY
    int 021h
    popf
    mov ds, word ptr cs:[MainDataSegment]
    jne loc_0C992
    ret
loc_0C992:
    cmp word ptr cs:[0C88Ah], 1
    jne loc_0C99B
    ret
loc_0C99B:
    mov ax, 3
    int 010h
    mov dx, 0BBA0h
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, word ptr ds:[FileNamePtr]
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, 0BBB8h
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dl, 0
    mov dh, 018h
    mov ah, 2
    mov bh, 0
    int 010h
    mov dx, 0BBF1h
    mov ah, DOS_PRINT_STRING
    int 021h
    call loc_0C9DD
    mov ah, DOS_CHAR_INPUT_NO_ECHO
    int 021h
    mov ax, 04C01h
    int 021h
; Sixteen iterations XOR source DS:[SI] with AAh in place, then MOVSB to ES:[DI]. DF
; controls both pointer directions. CX becomes zero; AL unchanged. Source also changes, and
; aliasing is observable.
XorCopy16BytesAA:
    mov cx, 010h
loc_0C9D6:
    xor byte ptr ds:[si], 0AAh
    movsb
    loop loc_0C9D6
    ret

loc_0C9DD:
    mov ah, 1
    int 016h
    je loc_0C9E9
    xor ah, ah
    int 016h
    jmp short loc_0C9DD
loc_0C9E9:
    ret
; Wait through one complete vertical retrace pulse and return at its end; the
; frame-rate delay behind WaitVerticalRetrace.
WaitVerticalRetracePulse:
    call WaitRetraceStart
    call WaitRetraceEnd
    ret

; Retrace start/end, honouring the polarity measured by MeasureRetracePolarity.
WaitRetraceStart:
    mov dx, CRT_STATUS_PORT
    cmp byte ptr cs:[RetraceBitInverted], 1
    je PollUntilRetraceBitClear
PollUntilRetraceBitSet:
    in al, dx
    test al, CRT_STATUS_VRETRACE
    je PollUntilRetraceBitSet
    ret

WaitRetraceEnd:
    mov dx, CRT_STATUS_PORT
    cmp byte ptr cs:[RetraceBitInverted], 1
    je PollUntilRetraceBitSet
PollUntilRetraceBitClear:
    in al, dx
    test al, CRT_STATUS_VRETRACE
    jne PollUntilRetraceBitClear
    ret

; Time one display period against the retrace bit and set RetraceBitInverted when
; the bit stays set at least as long as it stays clear (so set does not mean retrace).
; Called once from ProgramEntry during initialization.
MeasureRetracePolarity:
    pushf
    cli
    mov dx, CRT_STATUS_PORT
@@sync_set:
    in al, dx
    test al, CRT_STATUS_VRETRACE
    je @@sync_set
@@sync_clear:
    in al, dx
    test al, CRT_STATUS_VRETRACE
    jne @@sync_clear
    mov si, 0
    mov cl, 0
@@count_clear:
    in al, dx
    inc cl
    jne @@clear_counted
    inc si
@@clear_counted:
    test al, CRT_STATUS_VRETRACE
    je @@count_clear
    mov di, 0
    mov bl, 0
@@count_set:
    in al, dx
    inc bl
    jne @@set_counted
    inc di
@@set_counted:
    test al, CRT_STATUS_VRETRACE
    jne @@count_set
    mov al, 1
    cmp di, si
    je @@compare_low
    jae @@store
    mov al, 0
    jmp short @@store
@@compare_low:
    mov al, 1
    cmp bl, cl
    jae @@store
    mov al, 0
@@store:
    mov byte ptr cs:[RetraceBitInverted], al
    popf
    ret
; CS byte: 1 when CRT_STATUS_VRETRACE reads inverted (set outside retrace),
; measured once by MeasureRetracePolarity.
RetraceBitInverted db 00h ; RetraceBitInverted
; AL in 41h..5Ah becomes AL | 20h; all other values unchanged. AH and other registers
; preserved. Flags reflect final CMP or OR. Near RET.
LowercaseAsciiAL:
    cmp al, 041h
    jae loc_0CA60
    ret
loc_0CA60:
    cmp al, 05Ah
    jbe loc_0CA65
    ret
loc_0CA65:
    or al, 020h
    ret
; UNKNOWN: not yet classified as code or data
    db 080h,03Eh,055h,00h,00h,074h,028h,0A1h,0C2h,0BCh,0BDh,0C5h,0BCh,03Dh,034h,0BDh
    db 074h,012h,0BDh,0ECh,0BCh,03Dh,03Eh,0BDh,074h,0Ah,0BDh,011h,0BDh,03Dh,048h,0BDh
    db 074h,02h,0EBh,0Bh,0E8h,0FDh,086h,0B9h,0AFh,00h,0E8h,034h,086h,0E2h,0FBh,0C3h

; Load and initialize the optional sound module named by SoundModuleSelect ('t', 'r',
; 'a'; FFh tries tandy, roland, then adlib) into SOUND_MODULE_SEGMENT. On success sets
; SoundModuleLoaded and falls through into CB1C with AL=2. CB95 (the resource loader)
; is unreviewed.
LoadSoundModule:
    mov al, byte ptr ds:[SoundModuleSelect]
    cmp al, SOUND_SELECT_ANY
    je @@try_tandy
    call LowercaseAsciiAL
    cmp al, SOUND_SELECT_ROLAND
    je @@try_roland
    cmp al, SOUND_SELECT_ADLIB
    je @@try_adlib
    cmp al, SOUND_SELECT_TANDY
    je @@try_tandy
    jmp short @@none_loaded
@@try_tandy:
    mov dx, SOUND_MODULE_NAME_TANDY
    call loc_0CB95
    je @@tandy_failed
    mov ax, seg SoundModuleSlot
    mov es, ax
    call far ptr SoundModuleInitEntry
    mov ds, word ptr cs:[MainDataSegment]
    or al, al
    jne @@loaded
@@tandy_failed:
    cmp byte ptr ds:[SoundModuleSelect], SOUND_SELECT_ANY
    jne @@none_loaded
@@try_roland:
    mov dx, SOUND_MODULE_NAME_ROLAND
    call loc_0CB95
    je @@roland_failed
    mov ax, seg SoundModuleSlot
    mov es, ax
    call far ptr SoundModuleInitEntry
    mov ds, word ptr cs:[MainDataSegment]
    or al, al
    jne @@loaded
@@roland_failed:
    cmp byte ptr ds:[SoundModuleSelect], SOUND_SELECT_ANY
    jne @@none_loaded
@@try_adlib:
    mov dx, SOUND_MODULE_NAME_ADLIB
    call loc_0CB95
    je @@none_loaded
    mov ax, seg SoundModuleSlot
    mov es, ax
    call far ptr SoundModuleInitEntry
    mov ds, word ptr cs:[MainDataSegment]
    or al, al
    jne @@loaded
@@none_loaded:
    mov byte ptr ds:[SoundModuleLoaded], 0
    ret
@@loaded:
    mov byte ptr ds:[SoundModuleLoaded], 1
    mov al, 2

loc_0CB1C:
    mov byte ptr ds:[ModuleSoundRequest], al
    cmp byte ptr ds:[ModuleSoundEnabled], 0
    je loc_0CB3D
    xor ah, ah
    mov bx, seg SoundModuleSlot
    mov es, bx
    cmp al, byte ptr es:[9]
    je loc_0CB3D
    mov word ptr es:[8], ax
    mov ds, word ptr cs:[MainDataSegment]
loc_0CB3D:
    ret

loc_0CB3E:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne loc_0CB46
    ret
loc_0CB46:
    mov ax, seg SoundModuleSlot
    mov es, ax
    mov word ptr es:[8], 0FFh
    mov cx, 5
loc_0CB55:
    push cx
    call loc_0CBD5
    pop cx
    loop loc_0CB55
    mov ds, word ptr cs:[MainDataSegment]
    ret
; UNKNOWN: not yet classified as code or data
    db 080h,03Eh,055h,00h,00h,075h,01h,0C3h,06h,053h,0BBh,022h,010h,08Eh,0C3h,026h
    db 0A2h,0Ah,00h,05Bh,07h,0C3h,080h,03Eh,055h,00h,00h,075h,01h,0C3h,06h,053h
    db 0BBh,022h,010h,08Eh,0C3h,026h,0C7h,06h,08h,00h,0FFh,00h,026h,0A2h,08h,00h
    db 05Bh,07h,0C3h

loc_0CB95:
    mov word ptr ds:[FileNamePtr], dx
    mov word ptr ds:[0BCC2h], dx
    xor al, al
    mov ah, 03Dh
    call far ptr OpenResourceFile
    jae loc_0CBB4
    mov dx, word ptr ds:[FileNamePtr]
    xor al, al
    mov ah, DOS_OPEN_FILE
    int 021h
    jb loc_0CBD2
loc_0CBB4:
    mov word ptr cs:[0D666h], ax
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[0ECF0h], seg SoundModuleSlot
    mov word ptr cs:[0ECEEh], 0
    call loc_0ECC9
    jb loc_0CBD2
    or al, 1
    ret
loc_0CBD2:
    xor al, al
    ret

loc_0CBD5:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne loc_0CBDD
    ret
loc_0CBDD:
    mov al, byte ptr ds:[054h]
loc_0CBE0:
    cmp al, byte ptr ds:[054h]
    je loc_0CBE0
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_0CBE8:
    call loc_0CC04
    call loc_05BEE
    call loc_04FC3
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CBFB
    call RunIntroPagesAndDemo
loc_0CBFB:
    mov cx, 01Eh
loc_0CBFE:
    call WaitVerticalRetrace
    loop loc_0CBFE
    ret

loc_0CC04:
    mov byte ptr ds:[KeyLastMakeCode], 0
    call loc_05BEE
    call loc_04F57
    call loc_0CE97
    call loc_05C04
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CC4E
    mov cx, 01Eh
    call DelayFramesUntilKeyOrPrimary
    mov word ptr ds:[0BD98h], 0BD54h
    call loc_0CE5F
    call loc_0CC4F
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CC4E
    call loc_0CE5F
    call loc_0CC4F
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CC4E
    call loc_0CE5F
    call loc_0CC4F
    mov cx, 032h
    call DelayFramesUntilKeyOrPrimary
loc_0CC4E:
    ret

loc_0CC4F:
    mov word ptr ds:[0BD9Ah], 0BD81h
    mov cx, 5
loc_0CC58:
    push cx
    mov word ptr ds:[0BDA0h], cx
    mov si, word ptr ds:[0BD9Ah]
    lodsb
    mov byte ptr ds:[0BD96h], al
    lodsb
    mov byte ptr ds:[0BD95h], al
    lodsb
    xor ah, ah
    mov cx, ax
    lodsb
    mov word ptr ds:[0BD9Ch], ax
    mov word ptr ds:[0BD9Ah], si
loc_0CC76:
    push cx
    push word ptr ds:[0BD95h]
    mov cx, word ptr ds:[0BD9Ch]
loc_0CC7F:
    push cx
    mov ax, word ptr ds:[0BD95h]
    call DrawOffsetFromRow9D58
    mov word ptr ds:[0BD9Eh], di
    mov si, di
    add si, 07D00h
    xor dl, dl
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx - 0335Ch]
; UNKNOWN: not yet classified as code or data
    db 090h,0AAh,0CCh,0F0h,0CCh,0C4h,0CCh

    mov cx, 8
loc_0CCAD:
    mov ax, word ptr es:[si]
    cmp ax, word ptr es:[di]
    je loc_0CCBA
    mov dl, 1
    mov word ptr es:[di], ax
loc_0CCBA:
    add di, 050h
    add si, 050h
    loop loc_0CCAD
    jmp short loc_0CD08

    mov cx, 8
loc_0CCC7:
    mov ax, word ptr es:[si]
    cmp ax, word ptr es:[di]
    je loc_0CCD4
    mov dl, 1
    mov word ptr es:[di], ax
loc_0CCD4:
    mov ax, word ptr es:[si + 2]
    cmp ax, word ptr es:[di + 2]
    je loc_0CCE4
    mov dl, 1
    mov word ptr es:[di + 2], ax
loc_0CCE4:
    add di, 0A0h
    add si, 0A0h
    loop loc_0CCC7
    jmp short loc_0CD08

    mov cx, 020h
loc_0CCF3:
    mov al, byte ptr es:[si]
    cmp al, byte ptr es:[di]
    je loc_0CD00
    mov dl, 1
    mov byte ptr es:[di], al
loc_0CD00:
    add di, 028h
    add si, 028h
    loop loc_0CCF3
loc_0CD08:
    or dl, dl
    jne loc_0CD0F
    jmp near ptr loc_0CE07
loc_0CD0F:
    cmp word ptr ds:[0BDA0h], 4
    je loc_0CD2B
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0CD37
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0CD29
    mov byte ptr ds:[SfxRequest], 0Eh
loc_0CD29:
    jmp short loc_0CD37
loc_0CD2B:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0CD37
    mov byte ptr ds:[SfxRequest], 0Ah
loc_0CD37:
    mov ax, word ptr ds:[0BD95h]
    call DrawOffsetFromRow9EE8
    push di
    mov si, 012h
    shl si, 1
    add si, 0C92h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[095B8h]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    cmp word ptr ds:[0BDA0h], 5
    je loc_0CD68
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CD68
    call WaitVerticalRetrace
loc_0CD68:
    pop di
    mov si, word ptr ds:[0BD9Eh]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx - 0327Ch]
; UNKNOWN: not yet classified as code or data
    db 090h,08Ah,0CDh,0CCh,0CDh,0A7h,0CDh

    mov cx, 8
loc_0CD8D:
    mov ax, word ptr ds:[si]
    mov word ptr es:[di], ax
    add si, 050h
    add di, 02000h
    test di, 04000h
    je loc_0CDA3
    add di, 0C050h
loc_0CDA3:
    loop loc_0CD8D
    jmp short loc_0CE02

    mov cx, 8
loc_0CDAA:
    mov ax, word ptr ds:[si]
    mov word ptr es:[di], ax
    mov ax, word ptr ds:[si + 2]
    mov word ptr es:[di + 2], ax
    add si, 0A0h
    add di, 02000h
    test di, 08000h
    je loc_0CDC8
    add di, 080A0h
loc_0CDC8:
    loop loc_0CDAA
    jmp short loc_0CE02

    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov cx, 8
loc_0CDD6:
    mov al, 1
    out dx, al
    mov al, byte ptr ds:[si]
    mov byte ptr es:[di], al
    mov al, 2
    out dx, al
    mov al, byte ptr ds:[si + 028h]
    mov byte ptr es:[di], al
    mov al, 4
    out dx, al
    mov al, byte ptr ds:[si + 050h]
    mov byte ptr es:[di], al
    mov al, 8
    out dx, al
    mov al, byte ptr ds:[si + 078h]
    mov byte ptr es:[di], al
    add di, 028h
    add si, 0A0h
    loop loc_0CDD6
loc_0CE02:
    mov ds, word ptr cs:[MainDataSegment]
loc_0CE07:
    inc byte ptr ds:[0BD95h]
    pop cx
    loop loc_0CE10
    jmp short loc_0CE13
loc_0CE10:
    jmp near ptr loc_0CC7F
loc_0CE13:
    pop word ptr ds:[0BD95h]
    add byte ptr ds:[0BD96h], 8
    pop cx
    loop loc_0CE21
    jmp short loc_0CE24
loc_0CE21:
    jmp near ptr loc_0CC76
loc_0CE24:
    cmp word ptr ds:[0BDA0h], 5
    je loc_0CE31
    mov cx, 0Ah
    call DelayFramesUntilKeyOrPrimary
loc_0CE31:
    pop cx
    loop loc_0CE36
    jmp short loc_0CE39
loc_0CE36:
    jmp near ptr loc_0CC58
loc_0CE39:
    mov cx, 050h
    call DelayFramesUntilKeyOrPrimary
    ret

; Wait up to CX frames. A make code or the primary button (recorded as a Space make
; code) ends it early and stays visible in KeyLastMakeCode for the caller.
DelayFramesUntilKeyOrPrimary:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_0CE48
    ret
loc_0CE48:
    push cx
    call PollInputBits
    pop cx
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_0CE59
    mov byte ptr ds:[KeyLastMakeCode], SCAN_SPACE
loc_0CE59:
    call WaitVerticalRetrace
    loop DelayFramesUntilKeyOrPrimary
    ret

loc_0CE5F:
    mov cx, 5
loc_0CE62:
    push cx
    mov si, word ptr ds:[0BD98h]
    lodsb
    mov ah, al
    lodsb
    push si
    call DrawOffsetFromRow9D58
    add di, 07D00h
    pop si
    lodsb
    mov word ptr ds:[0BD98h], si
    xor ah, ah
    mov si, ax
    shl si, 1
    add si, 0C92h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[095B8h]
    call BlitPackedStride160
    mov ds, word ptr cs:[MainDataSegment]
    pop cx
    loop loc_0CE62
    ret

loc_0CE97:
    mov es, word ptr cs:[WorkspaceSegment]
    xor ax, ax
    call DrawOffsetFromRow9D58
    mov si, 0Fh
    shl si, 1
    add si, 0C92h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[095B8h]
    call BlitPackedStride160
    mov ds, word ptr cs:[MainDataSegment]
    mov cx, 012h
loc_0CEBD:
    push cx
    mov ah, cl
    add ah, ah
    mov al, ah
    add ah, ah
    add ah, ah
    add ah, al
    xor al, al
    call DrawOffsetFromRow9D58
    mov si, 010h
    shl si, 1
    add si, 0C92h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[095B8h]
    call BlitPackedStride160
    mov ds, word ptr cs:[MainDataSegment]
    pop cx
    loop loc_0CEBD
    xor al, al
    mov ah, 0BEh
    call DrawOffsetFromRow9D58
    mov si, 011h
    shl si, 1
    add si, 0C92h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[095B8h]
    call BlitPackedStride160
    mov ds, word ptr cs:[MainDataSegment]
    mov es, word ptr cs:[WorkspaceSegment]
    push es
    pop ds
    xor si, si
    mov di, 07D00h
    mov cx, 07D00h
    rep movsb
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_0CF22:
    mov ax, 04000h
    mov si, 0BDA2h
    call far ptr loc_153A0
    ret

; Show four title pages (up to 100 frames each), then run a frame loop that looks like a
; self-playing demo until a key or the primary button. DS:BDAC's role is unproven.
RunIntroPagesAndDemo:
    call loc_05145
    call loc_05BEE
    mov byte ptr ds:[KeyLastMakeCode], 0
    mov cx, 4
    xor si, si
loc_0CF3E:
    push cx
    push si
    shl si, 1
    shl si, 1
    xor al, al
    mov ah, byte ptr ds:[si - 04252h]
    push word ptr ds:[si - 04250h]
    push si
    call DrawOffsetFromRow9EE8
    pop si
    mov al, byte ptr ds:[si - 04251h]
    xor ah, ah
    mov si, ax
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    pop bp
    call loc_0518C
    mov cx, 064h
loc_0CF78:
    call WaitVerticalRetrace
    push cx
    call PollInputBits
    pop cx
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_0CF97
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CF97
    loop loc_0CF78
    pop si
    inc si
    pop cx
    loop loc_0CF3E
    jmp short loc_0CF9C
loc_0CF97:
    pop si
    pop cx
    jmp near ptr loc_0D040
loc_0CF9C:
    mov word ptr ds:[0BDACh], 1
    call loc_05145
    call loc_05BEE
    call loc_04FC3
    call loc_0526A
    call loc_0C4DB
    call loc_0C3A6
    mov word ptr ds:[0A970h], 0
    mov word ptr ds:[0A972h], 0
    mov word ptr ds:[0A976h], 0
    mov word ptr ds:[0A974h], 0
    mov word ptr ds:[0A97Eh], 0
    mov word ptr ds:[02350h], 09Ch
    call InitPositionHistory
; Clear the shared byte-attribute table before calling the setup path at 007EF.
; Forward fill requires DF=0; this is state initialization, not static table contents.
    mov es, word ptr cs:[MainDataSegment]
    mov di, BYTE_ATTRIBUTE_TABLE
    mov cx, BYTE_ATTRIBUTE_COUNT
    xor al, al
    rep stosb
    call loc_007EF
    mov bp, PRIMARY_RECORD
    call StoreApplyHistoryAndConditionalPlacement
    call loc_0A940
    mov word ptr ds:[0BE06h], 0
    mov word ptr ds:[0BE08h], 064h
    mov byte ptr ds:[KeyLastMakeCode], 0
loc_0D007:
    call ClearByteCS066B
    call loc_0511F
    call loc_0A846
    call CopyWorkspaceToScreen
    call loc_0A90C
    call loc_0D04D
    call loc_0A940
    call loc_05F61
    call loc_0073C
    call loc_05160
    call WaitByteCS066B
    cmp word ptr ds:[0BE06h], 013h
    je loc_0D040
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_0D040
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_0D007
loc_0D040:
    mov word ptr ds:[0BDACh], 0
    call loc_05BEE
    call loc_0526A
    ret

loc_0D04D:
    mov word ptr ds:[0A278h], 0
    mov al, 01Fh
    mov ah, 018h
    call DrawOffsetFromRow9EE8
    mov bx, word ptr ds:[0BE06h]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov si, word ptr ds:[bx - 041E8h]
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    push ds
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop ds
    call loc_0A212
    cmp word ptr ds:[0BE06h], 8
    jb loc_0D0CA
    cmp word ptr ds:[0BE08h], 014h
    jb loc_0D0CA
    mov byte ptr ds:[InputBits], 0
    inc word ptr ds:[0BE0Ah]
    cmp word ptr ds:[0BE0Ah], 014h
    jb loc_0D0A4
    mov word ptr ds:[0BE0Ah], 0
loc_0D0A4:
    cmp word ptr ds:[0BE0Ah], 0Fh
    je loc_0D0B9
    cmp word ptr ds:[0BE0Ah], 011h
    je loc_0D0B9
    cmp word ptr ds:[0BE0Ah], 013h
    jne loc_0D0BE
loc_0D0B9:
    mov byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
loc_0D0BE:
    mov bp, PRIMARY_RECORD
    mov word ptr ds:[0A980h], 0
    call loc_0A067
loc_0D0CA:
    cmp word ptr ds:[0BE06h], 0
    jne loc_0D0D4
    jmp near ptr loc_0D160
loc_0D0D4:
    dec word ptr ds:[0BE08h]
    je loc_0D0DB
    ret
loc_0D0DB:
    mov word ptr ds:[0BE08h], 064h
    inc word ptr ds:[0BE06h]
    mov bx, word ptr ds:[0BE06h]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov ax, word ptr ds:[bx - 041E6h]
    cmp ax, 0FFFFh
    je loc_0D107
    mov word ptr ds:[095FAh], ax
    mov ax, word ptr ds:[bx - 041E4h]
    mov word ptr ds:[0BE16h], ax
    call loc_0859E
loc_0D107:
    mov bx, word ptr ds:[0BE06h]
    shl bx, 1
    jmp word ptr cs:[bx - 02EEEh]
; UNKNOWN: not yet classified as code or data
    db 0AFh,044h,09Fh,0D1h,029h,0D2h,083h,0D1h,04Ah,0D2h,083h,0D1h,0DCh,0D1h,0F8h,0D1h
    db 0AFh,044h,0AFh,044h,04Dh,0D1h,052h,0D1h,04Dh,0D1h,04Dh,0D1h,04Dh,0D1h,04Dh,0D1h
    db 03Ah,0D1h,059h,0D1h,0AFh,044h,0AFh,044h,0E8h,0B7h,0B0h,0C7h,047h,04h,0C0h,00h
    db 0C7h,047h,02h,0C8h,00h,0C7h,047h,018h,051h,00h,0C3h,0FFh,06h,058h,0A9h,0C3h
    db 0C7h,06h,05Eh,0A9h,01h,00h,0C3h,0C7h,06h,060h,0A9h,01h,00h,0C3h
loc_0D160:
    cmp word ptr ds:[PRIMARY_RECORD + REC_Y], 060h
    jne loc_0D16A
    jmp near ptr loc_0D0D4
loc_0D16A:
    dec word ptr ds:[PRIMARY_RECORD + REC_Y]
    mov bp, PRIMARY_RECORD
    call StoreApplyHistoryAndConditionalPlacement
    cmp word ptr ds:[PRIMARY_RECORD + REC_Y], 060h
    je loc_0D17C
    ret
loc_0D17C:
    mov word ptr ds:[0BE08h], 032h
    ret
    inc word ptr ds:[PRIMARY_RECORD + REC_SPRITE]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D193
    mov byte ptr ds:[SfxRequest], 6
loc_0D193:
    mov word ptr ds:[0BE08h], 032h
    mov bp, PRIMARY_RECORD
    jmp near ptr PlaceFourRecordsFromOffsetTables
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D1AB
    mov byte ptr ds:[SfxRequest], 01Eh
loc_0D1AB:
    mov bp, PRIMARY_RECORD
    call FindFreeRecordPoolA
    mov word ptr ds:[0A96Eh], bx
    call loc_08209
    mov word ptr ds:[bx + 2], 0
    mov word ptr ds:[bx + 8], 0Fh
    mov word ptr ds:[bx + 018h], 050h
    mov bp, bx
    mov ax, word ptr ds:[PRIMARY_RECORD + REC_X]
    add ax, 8
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov ax, word ptr ds:[PRIMARY_RECORD + REC_Y]
    sub ax, 8
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    ret
; UNKNOWN: not yet classified as code or data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,0E8h,02Fh,0CDh,08Bh
    db 02Eh,062h,0A9h,0E8h,021h,00h,0C7h,046h,04h,00h,00h,0C3h,080h,03Eh,0C0h,098h
    db 00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,0E8h,013h,0CDh,08Bh,02Eh,064h,0A9h,0E8h
    db 05h,00h,083h,046h,034h,014h,0C3h,0E8h,053h,00h,0A1h,080h,023h,05h,08h,00h
    db 089h,046h,032h,0A1h,07Eh,023h,05h,028h,00h,089h,046h,034h,0C3h
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D235
    mov byte ptr ds:[SfxRequest], 01Eh
loc_0D235:
    call loc_09F5F
    mov bp, word ptr ds:[0A966h]
    call loc_0D269
    mov word ptr ss:[bp + REC_X], 0
    mov bp, word ptr ds:[0A968h]
    jmp short loc_0D269
; UNKNOWN: not yet classified as code or data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,0E8h,06h,0CDh,08Bh
    db 02Eh,06Ah,0A9h,0E8h,09h,00h,0C7h,046h,04h,00h,00h,08Bh,02Eh,06Ch,0A9h
loc_0D269:
    call loc_0BE97
    mov word ptr ss:[bp + REC_Y], 0C8h
    mov word ptr ss:[bp + REC_X], 0C0h
    mov word ptr ss:[bp + REC_TYPE], 050h
    mov word ptr ss:[bp + REC_KIND], 4
    ret
    mov ax, word ptr ss:[bp + REC_SAVED_X]
    mov word ptr ds:[02304h], ax
    mov ax, word ptr ss:[bp + REC_SAVED_Y]
    mov word ptr ds:[02306h], ax
    mov word ptr ds:[02308h], 1
    call loc_05DB2
    mov word ptr ds:[02308h], 2
    cmp word ptr ds:[0230Ah], 0
    jne loc_0D2A4
    ret
loc_0D2A4:
    mov word ptr ss:[bp + REC_KIND], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D2B5
    mov byte ptr ds:[SfxRequest], 0Eh
loc_0D2B5:
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h
    mov si, word ptr ds:[0BED6h]
    mov bx, word ptr ds:[0BED4h]
    shl bx, 1
    mov ax, word ptr ds:[bx + si]
    mov word ptr cs:[0BDEh], ax
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BDAh], 08000h
    mov word ptr cs:[0BE0h], 0D2B6h
    mov byte ptr ds:[0BB84h], 1
    call loc_00CB8
    mov byte ptr ds:[0BB84h], 0
    mov word ptr cs:[0BDAh], 0
    xor di, di
    mov si, 08000h
    mov ds, word ptr cs:[WorkspaceSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Frame loop of up to 200 frames or until the primary button; entered when DS:2350 is 9Ch.
RunTimedSequenceUntilPrimary:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne RunTimedSequenceUntilPrimary
    call CopyWorkspaceToScreen
    mov word ptr ds:[0BED8h], 0
loc_0D318:
    call ClearByteCS066B
    call loc_0511F
    call loc_04CED
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0D32C
    call CopyWorkspaceToScreen
loc_0D32C:
    call loc_0D367
    call loc_04D64
    call far ptr loc_10112
    call loc_0073C
    call loc_060A2
    call loc_05160
    call WaitByteCS066B
    call WaitVerticalRetrace
    inc word ptr ds:[0BED8h]
    cmp word ptr ds:[0BED8h], 0C8h
    ja loc_0D35C
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_0D318
loc_0D35C:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_0D35C
    ret

loc_0D367:
    mov ah, 047h
    mov al, 3
    call DrawOffsetFromRow9EE8
    xor si, si
    mov ds, word ptr cs:[095B6h]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h

; Load levscr.enc and choose.enc, let the player pick a slot (0..5) with
; ReadChooseScreenInput and derive LevelIndex from it (slot 5 gives -1).
RunChooseScreen:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne RunChooseScreen
    call loc_05145
    mov byte ptr ds:[0BB84h], 1
    mov word ptr cs:[0BDEh], 014A3h
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BDAh], 08000h
    mov word ptr cs:[0BE0h], 0D2B6h
    mov byte ptr cs:[045EDh], 0
    call loc_00CB8
    mov byte ptr cs:[045EDh], 1
    mov word ptr cs:[0BDEh], 014B2h
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BDAh], 04000h
    mov word ptr cs:[0BE0h], 0D37Eh
    mov word ptr ds:[021C4h], 1
    call loc_00CB8
    mov word ptr ds:[021C4h], 0
    mov byte ptr ds:[0BB84h], 0
    mov word ptr cs:[0BDAh], 0
loc_0D406:
    call ClearByteCS066B
    call loc_0511F
    call loc_0D4AA
    call loc_05160
    call WaitVerticalRetrace
    call ReadChooseScreenInput
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_0D424
    call WaitByteCS066B
    jmp short loc_0D406
loc_0D424:
    mov ax, word ptr ds:[0BEDAh]
    inc ax
    cmp ax, 6
    jne loc_0D42F
    xor ax, ax
loc_0D42F:
    dec ax
    mov word ptr ds:[LevelIndex], ax
    ret

; Move the 2x3 selection in DS:BEDA with the directions and cycle DS:BEDC (0..2) with
; the D key; return on the primary button.
ReadChooseScreenInput:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_D], KEY_STATE_DOWN
    je ReadChooseScreenInput
loc_0D43B:
    call PollInputBits
    cmp byte ptr ds:[InputBits], 0
    jne loc_0D43B
loc_0D445:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_D], KEY_STATE_DOWN
    je loc_0D498
    call PollInputBits
    mov al, byte ptr ds:[0BEDAh]
    test byte ptr ds:[InputBits], IN_XPLUS
    jne loc_0D476
    test byte ptr ds:[InputBits], IN_XMINUS
    jne loc_0D480
    test byte ptr ds:[InputBits], IN_YMINUS
    jne loc_0D488
    test byte ptr ds:[InputBits], IN_YPLUS
    jne loc_0D490
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_0D445
    ret
loc_0D476:
    cmp al, 3
    jae loc_0D445
    add al, 3
loc_0D47C:
    mov byte ptr ds:[0BEDAh], al
    ret
loc_0D480:
    cmp al, 2
    jbe loc_0D445
    sub al, 3
    jmp short loc_0D47C
loc_0D488:
    or al, al
    je loc_0D445
    dec al
    jmp short loc_0D47C
loc_0D490:
    cmp al, 5
    je loc_0D445
    inc al
    jmp short loc_0D47C
loc_0D498:
    inc word ptr ds:[0BEDCh]
    cmp word ptr ds:[0BEDCh], 3
    jb loc_0D4A9
    mov word ptr ds:[0BEDCh], 0
loc_0D4A9:
    ret

loc_0D4AA:
    xor di, di
    mov si, 08000h
    mov ds, word ptr cs:[WorkspaceSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov bx, word ptr ds:[0BEDAh]
    shl bx, 1
    mov ax, word ptr ds:[bx - 04122h]
    call DrawOffsetFromRow9EE8
    mov bx, word ptr ds:[0BEDAh]
    add bx, 0
    shl bx, 1
    mov si, word ptr cs:[bx - 02C82h]
    mov ds, word ptr cs:[WorkspaceSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov bx, word ptr ds:[0BEDCh]
    shl bx, 1
    mov ax, word ptr ds:[bx - 04116h]
    call DrawOffsetFromRow9EE8
    mov bx, word ptr ds:[0BEDCh]
    add bx, 6
    shl bx, 1
    mov si, word ptr cs:[bx - 02C82h]
    mov ds, word ptr cs:[WorkspaceSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

; Called every timer tick. Starts a pending SfxRequest, advances both voices, then
; programs the speaker from voice A on even ticks and voice B on odd ones. A silent
; voice leaves the speaker playing whatever was programmed last.
SfxTimerTick:
    inc byte ptr ds:[SfxTickPhase]
    and byte ptr ds:[SfxTickPhase], 3
    mov al, byte ptr ds:[SfxRequest]
    or al, al
    je @@check_active
    call SfxStartRequest
@@check_active:
    cmp byte ptr ds:[SfxActive], 0
    je SfxReturn
    mov di, SFX_VOICE_A
    call SfxVoiceTick
    mov di, SFX_VOICE_B
    call SfxVoiceTick
    mov al, byte ptr ds:[SfxTickPhase]
    shr al, 1
    jb @@select_voice_b
    cmp byte ptr ds:[SFX_VOICE_A + SFX_VOICE_SOUNDING], 0
    je SfxReturn
    mov bx, word ptr ds:[SFX_VOICE_A + SFX_VOICE_DIVISOR]
    jmp short @@program_speaker
@@select_voice_b:
    cmp byte ptr ds:[SFX_VOICE_B + SFX_VOICE_SOUNDING], 0
    je SfxReturn
    mov bx, word ptr ds:[SFX_VOICE_B + SFX_VOICE_DIVISOR]
@@program_speaker:
    mov al, PIT_CH2_SQUARE_WAVE
    out PIT_COMMAND_PORT, al
    mov al, bl
    out PIT_CHANNEL2_PORT, al
    mov al, bh
    out PIT_CHANNEL2_PORT, al
    in al, PPI_PORT_B
    or al, PPI_SPEAKER_BITS
    out PPI_PORT_B, al
SfxReturn:
    ret

; Start effect AL. Requests >= SFX_EFFECT_COUNT stop everything (and, not being
; cleared, keep doing so every tick). While an effect plays, a higher ID is refused
; and stays pending; an equal ID restarts and a lower one pre-empts.
SfxStartRequest:
    cmp al, SFX_EFFECT_COUNT
    jb @@check_priority
    jmp near ptr SfxStopAll
@@check_priority:
    cmp byte ptr ds:[SfxActive], 0
    je @@start_effect
    cmp al, byte ptr ds:[SfxActive]
    je @@start_effect
    jae SfxReturn
@@start_effect:
    mov byte ptr ds:[SfxActive], al
    xor ah, ah
    shl ax, 1
    shl ax, 1
    mov si, SFX_EFFECT_TABLE
    add si, ax
    lodsw
    mov word ptr ds:[SFX_VOICE_A + SFX_VOICE_STREAM], ax
    lodsw
    mov word ptr ds:[SFX_VOICE_B + SFX_VOICE_STREAM], ax
    xor al, al
    mov byte ptr ds:[SFX_VOICE_A + SFX_VOICE_NOTE_STEP], al
    mov byte ptr ds:[SFX_VOICE_B + SFX_VOICE_NOTE_STEP], al
    mov byte ptr ds:[SFX_VOICE_A + SFX_VOICE_SLIDE_TICKS], al
    mov byte ptr ds:[SFX_VOICE_B + SFX_VOICE_SLIDE_TICKS], al
    mov byte ptr ds:[SfxRequest], al
    inc al
    mov byte ptr ds:[SFX_VOICE_A + SFX_VOICE_COUNTDOWN], al
    mov byte ptr ds:[SFX_VOICE_B + SFX_VOICE_COUNTDOWN], al
    ret

; One tick of the voice at DI: when its countdown expires, interpret the stream;
; otherwise apply the note step and the divisor slide.
SfxVoiceTick:
    mov bx, word ptr ds:[di + SFX_VOICE_STREAM]
    dec byte ptr ds:[di + SFX_VOICE_COUNTDOWN]
    je SfxStreamNextByte
    call SfxVoiceApplyNoteStep
    call SfxVoiceApplySlide
    ret
; Read stream bytes at BX until one ends this tick (a note, rest or hold).
SfxStreamNextByte:
    mov al, byte ptr ds:[bx]
    inc bx
    or al, al
    js SfxStreamCommandByte
    mov byte ptr ds:[di + SFX_VOICE_NOTE], al
    call SfxVoiceLoadNoteDivisor
    mov byte ptr ds:[di + SFX_VOICE_SOUNDING], 2
; Command 85h (hold) and the common tail: keep the stream position, wait a duration.
SfxStreamStoreAndWait:
    mov word ptr ds:[di + SFX_VOICE_STREAM], bx
    mov al, byte ptr ds:[di + SFX_VOICE_DURATION]
    mov byte ptr ds:[di + SFX_VOICE_COUNTDOWN], al
    ret
; Command 81h: silence this voice; the speaker goes off only if both voices are silent.
SfxCmdRest:
    mov byte ptr ds:[di + SFX_VOICE_SOUNDING], 0
    mov al, byte ptr ds:[SFX_VOICE_A + SFX_VOICE_SOUNDING]
    or al, byte ptr ds:[SFX_VOICE_B + SFX_VOICE_SOUNDING]
    jne SfxStreamStoreAndWait
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    jmp short SfxStreamStoreAndWait
; Bytes 80h..DFh dispatch through SFX_COMMAND_TABLE; E0h..FFh set the duration.
SfxStreamCommandByte:
    cmp al, SFX_STREAM_DURATION
    jae @@set_duration
    shl al, 1
    xor ah, ah
    mov si, ax
    add si, SFX_COMMAND_TABLE
    jmp word ptr ds:[si]
@@set_duration:
    sub al, SFX_DURATION_BIAS
    mov byte ptr ds:[di + SFX_VOICE_DURATION], al
    jmp short SfxStreamNextByte

SfxVoiceApplySlide:
    cmp byte ptr ds:[di + SFX_VOICE_SLIDE_TICKS], 0
    je @@done
    dec byte ptr ds:[di + SFX_VOICE_SLIDE_TICKS]
    mov ax, word ptr ds:[di + SFX_VOICE_SLIDE_DELTA]
    add word ptr ds:[di + SFX_VOICE_DIVISOR], ax
@@done:
    ret

; A nonzero step moves the note and reloads its divisor, discarding any slide so far.
SfxVoiceApplyNoteStep:
    mov al, byte ptr ds:[di + SFX_VOICE_NOTE_STEP]
    or al, al
    je SfxVoiceNoteDone
    add al, byte ptr ds:[di + SFX_VOICE_NOTE]
    mov byte ptr ds:[di + SFX_VOICE_NOTE], al

SfxVoiceLoadNoteDivisor:
    xor ah, ah
    shl al, 1
    mov si, ax
    add si, SFX_NOTE_DIVISORS
    mov ax, word ptr ds:[si]
    mov word ptr ds:[di + SFX_VOICE_DIVISOR], ax
SfxVoiceNoteDone:
    ret
; Command 80h and requests >= SFX_EFFECT_COUNT: end the effect and silence the speaker.
SfxStopAll:
    xor al, al
    mov byte ptr ds:[SfxActive], al
    mov byte ptr ds:[SFX_VOICE_A + SFX_VOICE_SOUNDING], al
    mov byte ptr ds:[SFX_VOICE_B + SFX_VOICE_SOUNDING], al
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    ret
; Commands 82h/83h: step the note down/up one semitone per tick.
SfxCmdStepDown:
    mov byte ptr ds:[di + SFX_VOICE_NOTE_STEP], 0FFh
    jmp near ptr SfxStreamNextByte
SfxCmdStepUp:
    mov byte ptr ds:[di + SFX_VOICE_NOTE_STEP], 1
    jmp near ptr SfxStreamNextByte
; Command 84h: slide the divisor by a word delta for a byte count of ticks.
SfxCmdSlide:
    mov ax, word ptr ds:[bx]
    inc bx
    inc bx
    mov word ptr ds:[di + SFX_VOICE_SLIDE_DELTA], ax
    mov al, byte ptr ds:[bx]
    inc bx
    mov byte ptr ds:[di + SFX_VOICE_SLIDE_TICKS], al
    jmp near ptr SfxStreamNextByte
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0B8h,03h,00h,0CDh,010h,0B9h,00h
    db 020h,0B4h,01h,0CDh,010h,02Eh,0C7h,06h,060h,0D6h,00h,0B8h,0E8h,0FCh,01h,074h
    db 07h,02Eh,0C7h,06h,060h,0D6h,00h,0B0h,0BAh,0FEh,0C2h,089h,016h,0AAh,021h,032h
    db 0C0h,0B4h,03Dh,09Ah,0D7h,04h,03Ah,015h,073h,0Bh,0B4h,019h,0CDh,021h,03Ch,02h
    db 072h,0E6h,0E9h,067h,086h,02Eh,0A3h,066h,0D6h,02Eh,0A1h,098h,095h,02Eh,0A3h,0F0h
    db 0ECh,02Eh,0C7h,06h,0EEh,0ECh,00h,00h,0E8h,0Fh,016h,073h,03h,0E9h,08Ch,01h
    db 02Eh,0C7h,06h,062h,0D6h,00h,00h,02Eh,0C7h,06h,064h,0D6h,01h,00h,02Eh,08Eh
    db 06h,098h,095h,033h,0F6h,026h,0ACh,03Ch,01Ah,074h,0Bh,03Ch,0Dh,075h,0F6h,02Eh
    db 0FFh,06h,064h,0D6h,0EBh,0EFh,0E8h,0ABh,00h,080h,03Eh,0C5h,098h,01h,075h,03h
    db 0E9h,059h,01h,080h,03Eh,0Bh,099h,01h,074h,025h,080h,03Eh,013h,099h,01h,074h
    db 029h,080h,03Eh,0Ch,099h,01h,074h,04Fh,080h,03Eh,014h,099h,01h,074h,060h,080h
    db 03Eh,0Dh,099h,01h,074h,01Fh,080h,03Eh,015h,099h,01h,074h,029h,0EBh,0CAh,0BDh
    db 0FFh,0FFh,0E8h,039h,00h,04Dh,075h,0FAh,0EBh,0BCh,0BDh,0FFh,0FFh,0E8h,04Ch,00h
    db 04Dh,075h,0FAh,0EBh,0B1h,0E8h,01Ch,01h,0E8h,019h,01h,0BDh,017h,00h,0E8h,01Dh
    db 00h,04Dh,075h,0FAh,0EBh,0A0h,0E8h,0Bh,01h,0E8h,08h,01h,0BDh,017h,00h,0E8h
    db 02Ah,00h,04Dh,075h,0FAh,0EBh,08Fh,0E8h,04h,00h,0E3h,08Dh,0EBh,088h,033h,0C9h
    db 02Eh,083h,03Eh,062h,0D6h,00h,074h,06h,02Eh,0FFh,0Eh,062h,0D6h,041h,0C3h,0E8h
    db 0Ah,00h,0E3h,02h,0EBh,03h,0E9h,070h,0FFh,0E9h,06Ah,0FFh,033h,0C9h,02Eh,0A1h
    db 062h,0D6h,040h,05h,018h,00h,02Eh,03Bh,06h,064h,0D6h,073h,06h,02Eh,0FFh,06h
    db 062h,0D6h,041h,0C3h,02Eh,08Eh,06h,098h,095h,033h,0FFh,02Eh,08Bh,016h,062h,0D6h
    db 0Bh,0D2h,074h,011h,0B9h,0FFh,0FFh,0B0h,0Dh,0F2h,0AEh,026h,080h,03Dh,0Ah,075h
    db 01h,047h,04Ah,075h,0EFh,08Bh,0F7h,02Eh,08Eh,01Eh,098h,095h,02Eh,08Eh,06h,060h
    db 0D6h,033h,0FFh,01Eh,056h,02Eh,08Eh,01Eh,096h,095h,0BEh,0Ah,0C3h,0B9h,050h,00h
    db 0F3h,0A5h,05Eh,01Fh,0BDh,018h,00h,033h,0D2h,0Bh,0EDh,074h,062h,0ACh,03Ch,01Ah
    db 074h,05Dh,03Ch,09h,074h,012h,03Ch,0Dh,074h,031h,0B4h,01Bh,0ABh,042h,083h,0FAh
    db 050h,075h,0E6h,033h,0D2h,04Dh,0EBh,0E1h,0B0h,020h,0B4h,01Bh,0F7h,0C2h,07h,00h
    db 074h,0Ah,0ABh,042h,0F7h,0C2h,07h,00h,075h,0F8h,0EBh,0Dh,083h,0FAh,050h,074h
    db 08h,083h,0C2h,08h,0B9h,08h,00h,0F3h,0ABh,0EBh,0BEh,080h,03Ch,0Ah,075h,01h
    db 046h,083h,0FAh,050h,074h,010h,0B0h,020h,0B4h,01Bh,0ABh,042h,083h,0FAh,050h,075h
    db 0F9h,033h,0D2h,04Dh,0EBh,0A3h,081h,0C7h,0A0h,00h,033h,0D2h,04Dh,0EBh,09Ah,02Eh
    db 08Eh,01Eh,096h,095h,052h,055h,0E8h,0Bh,00h,05Dh,05Ah,0C3h,080h,03Eh,0C5h,098h
    db 01h,074h,0F9h,0C3h,0B9h,04h,00h,0E8h,03h,00h,0E2h,0FBh,0C3h,0BAh,0DAh,03h
    db 0B4h,08h,02Eh,081h,03Eh,060h,0D6h,00h,0B8h,074h,05h,0BAh,0BAh,03h,0B4h,080h
    db 0ECh,022h,0C4h,074h,0FBh,0ECh,022h,0C4h,075h,0FBh,0C3h,0BAh,0B4h,03h,0E8h,01Bh
    db 00h,074h,018h,0BAh,0BAh,03h,0ECh,024h,080h,08Ah,0E0h,0B9h,00h,080h,0ECh,024h
    db 080h,03Ah,0E0h,0E1h,0F9h,0B0h,01h,075h,02h,0B0h,00h,0C3h,0B0h,0Fh,0EEh,042h
    db 0ECh,08Ah,0E0h,0B0h,066h,0EEh,0B9h,00h,01h,0E2h,0FEh,0ECh,086h,0E0h,0EEh,080h
    db 0FCh,066h,074h,02h,033h,0C0h,023h,0C0h,0C3h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
MAIN ends
end