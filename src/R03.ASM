; Modern physical chunk, NOT an inferred original object boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn LevelIndex:far
extrn LivesLeft:far
extrn SfxEnabled:far
extrn SfxRequest:far
extrn loc_0F953:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public FindFreeRecordPoolA
public FindFreeRecordPoolB
public loc_05F61
public loc_060A2
public loc_060AC
public loc_0613E
public loc_0615A
public loc_06176
public loc_061DC
public loc_062AA
public loc_062F6
public loc_07420
public loc_07476
public loc_074FE
public loc_07547
public loc_07596
public loc_07746
public loc_077C5
public loc_077DF
public loc_07948
public loc_07E58
extrn BlitPackedToScreen:near
extrn DrawOffsetFromRow9EE8:near
extrn MainDataSegment:near
extrn PanelSegment:near
extrn ScreenSegment:near
extrn VideoAdapter:near
extrn WorkspaceSegment:near
extrn loc_0511F:near
extrn loc_0518C:near
extrn loc_0519A:near
extrn loc_05EDB:near
extrn loc_081C9:near
extrn loc_081CC:near
extrn loc_09EE4:near
extrn loc_0A781:near
extrn loc_0BD0D:near
extrn loc_0BEC5:near
extrn loc_0BFC7:near
extrn loc_0CB1C:near
; Modern record/state symbols.
loc_05F61:
    cmp word ptr ds:[0A47Eh], 0
    jne loc_05F89
    cmp word ptr ds:[0A480h], 0
    je loc_05F89
    dec word ptr ds:[0A480h]
    jne loc_05F89
    mov bx, 0231Eh
    mov al, byte ptr ds:[LevelIndex]
    xlat
    cmp word ptr ds:[02350h], 0750h
    jb loc_05F86
    mov al, 6
loc_05F86:
    call loc_0CB1C
loc_05F89:
    cmp word ptr ds:[02328h], 7
    jne loc_05FBA
    cmp word ptr ds:[02342h], -1
    je loc_05FAC
    inc word ptr ds:[02344h]
    cmp word ptr ds:[02344h], 2
    jne loc_05FBA
    neg word ptr ds:[02342h]
    inc word ptr ds:[02348h]
    jmp short loc_05FBA
loc_05FAC:
    dec word ptr ds:[02344h]
    jne loc_05FBA
    neg word ptr ds:[02342h]
    inc word ptr ds:[02348h]
loc_05FBA:
    and word ptr ds:[02348h], 0Fh
    jne loc_05FCB
    mov word ptr ds:[02346h], 8
    inc word ptr ds:[02348h]
loc_05FCB:
    inc word ptr ds:[02332h]
    and word ptr ds:[02332h], 3
    jne loc_06030
    inc word ptr ds:[02334h]
    cmp word ptr ds:[02334h], 0Ah
    jb loc_05FE7
    mov word ptr ds:[02334h], 0
loc_05FE7:
    inc word ptr ds:[02338h]
    cmp word ptr ds:[02338h], 6
    jb loc_05FF8
    mov word ptr ds:[02338h], 0
loc_05FF8:
    inc word ptr ds:[0233Ah]

    cmp word ptr ds:[0233Ah], 5
    jb loc_06009
    mov word ptr ds:[0233Ah], 0
loc_06009:
    inc word ptr ds:[0233Eh]
    cmp word ptr ds:[0233Eh], 3
    jb loc_0601A
    mov word ptr ds:[0233Eh], 0
loc_0601A:
    inc word ptr ds:[0233Ch]
    and word ptr ds:[0233Ch], 3
    inc word ptr ds:[02336h]
    and word ptr ds:[02336h], 7
    inc word ptr ds:[0A7A0h]
loc_06030:
    xor word ptr ds:[02324h], 1
    inc word ptr ds:[02326h]
    and word ptr ds:[02326h], 3
    inc word ptr ds:[02328h]
    and word ptr ds:[02328h], 7
    inc word ptr ds:[0232Ah]
    and word ptr ds:[0232Ah], 0Fh
    inc word ptr ds:[0232Ch]
    and word ptr ds:[0232Ch], 01Fh
    inc word ptr ds:[0232Eh]
    and word ptr ds:[0232Eh], 03Fh
    inc word ptr ds:[02330h]
    and word ptr ds:[02330h], 07Fh
    call loc_0606F
    ret

loc_0606F:
    cmp word ptr ds:[0BEDCh], 1
    jbe loc_0607D
    cmp word ptr ds:[0232Eh], 03Fh
    jmp short loc_06082
loc_0607D:
    cmp word ptr ds:[02330h], 07Fh
loc_06082:
    jne loc_06087
    call loc_09EE4
loc_06087:
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 2
    je loc_0608F
    ret
loc_0608F:
    cmp word ptr ds:[0232Ch], 01Fh
    je loc_06097
    ret
loc_06097:
    xor word ptr ds:[0234Ah], 1
    je loc_0609F
    ret
loc_0609F:
    jmp near ptr loc_09EE4

loc_060A2:
    call loc_077C5
    call loc_05F61
    call loc_05EDB
    ret

loc_060AC:
    mov ax, word ptr cs:[095A2h]
    mov word ptr ds:[0234Ch], ax
    mov word ptr ds:[0234Eh], 0
    mov word ptr ds:[02352h], 0
    mov word ptr ds:[0A978h], 0
    mov word ptr ds:[02350h], 0EA0h
loc_060CB:
    mov cx, 010h
loc_060CE:
    push cx
    call loc_0A781
    pop cx
    loop loc_060CE
    cmp word ptr ds:[02350h], 09Ch
    jne loc_060CB
    sub word ptr ds:[0A978h], 3
    ret

loc_060E3:
    mov bp, 0235Ch
    call loc_0518C
    mov bx, 02362h
    mov ax, word ptr ds:[LevelIndex]
    xlat
    jmp near ptr loc_0519A

loc_060F3:
    mov al, 01Fh
    mov ah, 050h
    call DrawOffsetFromRow9EE8
    mov si, 01Eh
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov cx, word ptr ds:[LivesLeft]
    call loc_06120
    mov si, 01Fh
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov cx, 3
    sub cx, word ptr ds:[LivesLeft]

loc_06120:
    jcxz loc_06138
    push si
    push di
    push cx
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop cx
    pop di
    pop si
    call loc_0613E
    call loc_0613E
    loop loc_06120
loc_06138:
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_0613E:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 0614Ah]
    dw loc_06150, loc_06154, loc_06156    ; per VideoAdapter: CGA, EGA, Tandy

loc_06150:
    add di, 2
    ret

loc_06154:
    inc di
    ret

loc_06156:
    add di, 4
    ret

loc_0615A:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 06166h]
    dw loc_0616C, loc_06170, loc_06172    ; per VideoAdapter: CGA, EGA, Tandy

loc_0616C:
    sub di, 2
    ret

loc_06170:
    dec di
    ret

loc_06172:
    sub di, 4
    ret

loc_06176:
    call loc_05EDB
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0618A
    call loc_0511F
    call loc_05EDB
    call loc_0511F
loc_0618A:
    call loc_060F3
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0619E
    call loc_0511F
    call loc_060F3
    call loc_0511F
loc_0619E:
    call loc_061DC
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_061B2
    call loc_0511F
    call loc_061DC
    call loc_0511F
loc_061B2:
    call loc_060E3
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_061C6
    call loc_0511F
    call loc_060E3
    call loc_0511F
loc_061C6:
    ret

loc_061C7:
    mov di, 02368h
loc_061CA:
    cmp word ptr ds:[di], 0
    je loc_061D2
    dec word ptr ds:[di]
    ret
loc_061D2:
    add di, 2
    cmp di, 02374h
    jne loc_061CA
    ret

loc_061DC:
    push bp
    mov es, word ptr cs:[MainDataSegment]
    mov di, 02368h
    mov cx, 6
    mov ax, 4
    rep stosw
    mov cx, word ptr ds:[0A95Ch]
    jcxz loc_061FC
    or cx, cx
    js loc_061FC
loc_061F7:
    call loc_061C7
    loop loc_061F7
loc_061FC:
    mov ah, 040h
    mov al, 01Fh
    call DrawOffsetFromRow9EE8
    mov ds, word ptr cs:[PanelSegment]
    mov si, word ptr ss:[02368h]
    call loc_06296
    mov si, word ptr ss:[0236Ah]
    call loc_06296
    mov si, word ptr ss:[0236Ch]
    call loc_06296
    mov si, word ptr ss:[0236Eh]
    call loc_06296
    mov si, word ptr ss:[02370h]
    call loc_06296
    mov si, word ptr ss:[02372h]
    call loc_06296
    mov ds, word ptr cs:[MainDataSegment]
    mov ax, word ptr ds:[0A95Ah]
    cmp ax, word ptr ds:[02374h]
    je loc_06294
    mov al, 01Fh
    mov ah, 0Ch
    call DrawOffsetFromRow9EE8
    mov si, 0
    cmp word ptr ds:[0A95Ah], -1
    je loc_0625B
    mov si, word ptr ds:[0A95Ah]
loc_0625B:
    add si, 020h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov al, 021h
    mov ah, 018h
    call DrawOffsetFromRow9EE8
    mov si, 01Eh
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
loc_06294:
    pop bp
    ret

loc_06296:
    add si, 019h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    push di
    call BlitPackedToScreen
    pop di
    jmp near ptr loc_0613E

loc_062AA:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_062B6
    mov byte ptr ds:[SfxRequest], 8
loc_062B6:
    push bp
    mov cx, POOL_A_COUNT
loc_062BA:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_062CC
    call loc_062D1
loc_062CC:
    pop cx
    loop loc_062BA
    pop bp
    ret

loc_062D1:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe loc_062D9
    ret
loc_062D9:
    cmp word ptr ss:[bp + REC_KIND], 4
    je loc_062E0
    ret
loc_062E0:
    cmp word ptr ss:[bp + REC_TYPE], 0
    jne loc_062E7
    ret
loc_062E7:
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne loc_062EE
    ret
loc_062EE:
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp near ptr loc_0BFC7
loc_062F6:
    cmp word ptr ss:[bp + REC_STATUS], 0
    jne loc_062FF
    jmp near ptr loc_0741F
loc_062FF:
    cmp word ptr ss:[bp + REC_Y], 020h
    jge loc_06308
    jmp near ptr loc_0741F
loc_06308:
    cmp word ptr ss:[bp + REC_KIND], 0
    jne loc_06311
    jmp near ptr loc_0741F
loc_06311:
    cmp word ptr ss:[bp + REC_TYPE], 0
    jne loc_0631A
    jmp near ptr loc_0741F
loc_0631A:
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne loc_06323
    jmp near ptr loc_0741F
loc_06323:
    cmp word ptr ss:[bp + REC_TYPE], 026h
    jne loc_0632C
    jmp near ptr loc_0741F
loc_0632C:
    mov si, word ptr ss:[bp + REC_KIND]
    mov di, word ptr ss:[bp + REC_DRAW_PASS]
    mov dx, word ptr ss:[bp + REC_X]
    and dx, 0FFF8h
    mov cx, word ptr ss:[bp + REC_Y]
    and cx, 0FFF8h
    mov bx, POOL_B
    cmp word ptr ds:[bx], 0
    je loc_063BD
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_063BD
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06361
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06380
    sub ax, 8
loc_06361:
    cmp ax, dx
    je loc_06380
    sub ax, 8
    cmp ax, dx
    je loc_06380
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_063BD
    sub ax, 8
    cmp ax, dx
    je loc_06380
    sub ax, 8
    cmp ax, dx
    jne loc_063BD
loc_06380:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0638D
    jmp near ptr loc_0BEC5
loc_0638D:
    sub ax, 8
    cmp ax, cx
    jne loc_06397
    jmp near ptr loc_0BEC5
loc_06397:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_063BD
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_063BD
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_063BD
    sub ax, 8
    cmp ax, cx
    jne loc_063B3
    jmp near ptr loc_0BEC5
loc_063B3:
    sub ax, 8
    cmp ax, cx
    jne loc_063BD
    jmp near ptr loc_0BEC5
loc_063BD:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_0643C
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_0643C
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_063E0
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_063FF
    sub ax, 8
loc_063E0:
    cmp ax, dx
    je loc_063FF
    sub ax, 8
    cmp ax, dx
    je loc_063FF
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0643C
    sub ax, 8
    cmp ax, dx
    je loc_063FF
    sub ax, 8
    cmp ax, dx
    jne loc_0643C
loc_063FF:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0640C
    jmp near ptr loc_0BEC5
loc_0640C:
    sub ax, 8
    cmp ax, cx
    jne loc_06416
    jmp near ptr loc_0BEC5
loc_06416:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0643C
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_0643C
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_0643C
    sub ax, 8
    cmp ax, cx
    jne loc_06432
    jmp near ptr loc_0BEC5
loc_06432:
    sub ax, 8
    cmp ax, cx
    jne loc_0643C
    jmp near ptr loc_0BEC5
loc_0643C:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_064BB
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_064BB
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_0645F
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_0647E
    sub ax, 8
loc_0645F:
    cmp ax, dx
    je loc_0647E
    sub ax, 8
    cmp ax, dx
    je loc_0647E
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_064BB
    sub ax, 8
    cmp ax, dx
    je loc_0647E
    sub ax, 8
    cmp ax, dx
    jne loc_064BB
loc_0647E:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0648B
    jmp near ptr loc_0BEC5
loc_0648B:
    sub ax, 8
    cmp ax, cx
    jne loc_06495
    jmp near ptr loc_0BEC5
loc_06495:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_064BB
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_064BB
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_064BB
    sub ax, 8
    cmp ax, cx
    jne loc_064B1
    jmp near ptr loc_0BEC5
loc_064B1:
    sub ax, 8
    cmp ax, cx
    jne loc_064BB
    jmp near ptr loc_0BEC5
loc_064BB:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_0653A
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_0653A
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_064DE
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_064FD
    sub ax, 8
loc_064DE:
    cmp ax, dx
    je loc_064FD
    sub ax, 8
    cmp ax, dx
    je loc_064FD
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0653A
    sub ax, 8
    cmp ax, dx
    je loc_064FD
    sub ax, 8
    cmp ax, dx
    jne loc_0653A
loc_064FD:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0650A
    jmp near ptr loc_0BEC5
loc_0650A:
    sub ax, 8
    cmp ax, cx
    jne loc_06514
    jmp near ptr loc_0BEC5
loc_06514:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0653A
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_0653A
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_0653A
    sub ax, 8
    cmp ax, cx
    jne loc_06530
    jmp near ptr loc_0BEC5
loc_06530:
    sub ax, 8
    cmp ax, cx
    jne loc_0653A
    jmp near ptr loc_0BEC5
loc_0653A:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_065B9
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_065B9
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_0655D
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_0657C
    sub ax, 8
loc_0655D:
    cmp ax, dx
    je loc_0657C
    sub ax, 8
    cmp ax, dx
    je loc_0657C
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_065B9
    sub ax, 8
    cmp ax, dx
    je loc_0657C
    sub ax, 8
    cmp ax, dx
    jne loc_065B9
loc_0657C:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06589
    jmp near ptr loc_0BEC5
loc_06589:
    sub ax, 8
    cmp ax, cx
    jne loc_06593
    jmp near ptr loc_0BEC5
loc_06593:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_065B9
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_065B9
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_065B9
    sub ax, 8
    cmp ax, cx
    jne loc_065AF
    jmp near ptr loc_0BEC5
loc_065AF:
    sub ax, 8
    cmp ax, cx
    jne loc_065B9
    jmp near ptr loc_0BEC5
loc_065B9:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06638
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06638
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_065DC
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_065FB
    sub ax, 8
loc_065DC:
    cmp ax, dx
    je loc_065FB
    sub ax, 8
    cmp ax, dx
    je loc_065FB
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06638
    sub ax, 8
    cmp ax, dx
    je loc_065FB
    sub ax, 8
    cmp ax, dx
    jne loc_06638
loc_065FB:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06608
    jmp near ptr loc_0BEC5
loc_06608:
    sub ax, 8
    cmp ax, cx
    jne loc_06612
    jmp near ptr loc_0BEC5
loc_06612:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06638
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06638
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06638
    sub ax, 8
    cmp ax, cx
    jne loc_0662E
    jmp near ptr loc_0BEC5
loc_0662E:
    sub ax, 8
    cmp ax, cx
    jne loc_06638
    jmp near ptr loc_0BEC5
loc_06638:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_066B7
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_066B7
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_0665B
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_0667A
    sub ax, 8
loc_0665B:
    cmp ax, dx
    je loc_0667A
    sub ax, 8
    cmp ax, dx
    je loc_0667A
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_066B7
    sub ax, 8
    cmp ax, dx
    je loc_0667A
    sub ax, 8
    cmp ax, dx
    jne loc_066B7
loc_0667A:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06687
    jmp near ptr loc_0BEC5
loc_06687:
    sub ax, 8
    cmp ax, cx
    jne loc_06691
    jmp near ptr loc_0BEC5
loc_06691:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_066B7
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_066B7
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_066B7
    sub ax, 8
    cmp ax, cx
    jne loc_066AD
    jmp near ptr loc_0BEC5
loc_066AD:
    sub ax, 8
    cmp ax, cx
    jne loc_066B7
    jmp near ptr loc_0BEC5
loc_066B7:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06736
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06736
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_066DA
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_066F9
    sub ax, 8
loc_066DA:
    cmp ax, dx
    je loc_066F9
    sub ax, 8
    cmp ax, dx
    je loc_066F9
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06736
    sub ax, 8
    cmp ax, dx
    je loc_066F9
    sub ax, 8
    cmp ax, dx
    jne loc_06736
loc_066F9:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06706
    jmp near ptr loc_0BEC5
loc_06706:
    sub ax, 8
    cmp ax, cx
    jne loc_06710
    jmp near ptr loc_0BEC5
loc_06710:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06736
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06736
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06736
    sub ax, 8
    cmp ax, cx
    jne loc_0672C
    jmp near ptr loc_0BEC5
loc_0672C:
    sub ax, 8
    cmp ax, cx
    jne loc_06736
    jmp near ptr loc_0BEC5
loc_06736:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_067B5
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_067B5
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06759
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06778
    sub ax, 8
loc_06759:
    cmp ax, dx
    je loc_06778
    sub ax, 8
    cmp ax, dx
    je loc_06778
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_067B5
    sub ax, 8
    cmp ax, dx
    je loc_06778
    sub ax, 8
    cmp ax, dx
    jne loc_067B5
loc_06778:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06785
    jmp near ptr loc_0BEC5
loc_06785:
    sub ax, 8
    cmp ax, cx
    jne loc_0678F
    jmp near ptr loc_0BEC5
loc_0678F:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_067B5
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_067B5
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_067B5
    sub ax, 8
    cmp ax, cx
    jne loc_067AB
    jmp near ptr loc_0BEC5
loc_067AB:
    sub ax, 8
    cmp ax, cx
    jne loc_067B5
    jmp near ptr loc_0BEC5
loc_067B5:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06834
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06834
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_067D8
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_067F7
    sub ax, 8
loc_067D8:
    cmp ax, dx
    je loc_067F7
    sub ax, 8
    cmp ax, dx
    je loc_067F7
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06834
    sub ax, 8
    cmp ax, dx
    je loc_067F7
    sub ax, 8
    cmp ax, dx
    jne loc_06834
loc_067F7:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06804
    jmp near ptr loc_0BEC5
loc_06804:
    sub ax, 8
    cmp ax, cx
    jne loc_0680E
    jmp near ptr loc_0BEC5
loc_0680E:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06834
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06834
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06834
    sub ax, 8
    cmp ax, cx
    jne loc_0682A
    jmp near ptr loc_0BEC5
loc_0682A:
    sub ax, 8
    cmp ax, cx
    jne loc_06834
    jmp near ptr loc_0BEC5
loc_06834:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_068B3
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_068B3
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06857
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06876
    sub ax, 8
loc_06857:
    cmp ax, dx
    je loc_06876
    sub ax, 8
    cmp ax, dx
    je loc_06876
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_068B3
    sub ax, 8
    cmp ax, dx
    je loc_06876
    sub ax, 8
    cmp ax, dx
    jne loc_068B3
loc_06876:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06883
    jmp near ptr loc_0BEC5
loc_06883:
    sub ax, 8
    cmp ax, cx
    jne loc_0688D
    jmp near ptr loc_0BEC5
loc_0688D:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_068B3
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_068B3
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_068B3
    sub ax, 8
    cmp ax, cx
    jne loc_068A9
    jmp near ptr loc_0BEC5
loc_068A9:
    sub ax, 8
    cmp ax, cx
    jne loc_068B3
    jmp near ptr loc_0BEC5
loc_068B3:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06932
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06932
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_068D6
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_068F5
    sub ax, 8
loc_068D6:
    cmp ax, dx
    je loc_068F5
    sub ax, 8
    cmp ax, dx
    je loc_068F5
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06932
    sub ax, 8
    cmp ax, dx
    je loc_068F5
    sub ax, 8
    cmp ax, dx
    jne loc_06932
loc_068F5:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06902
    jmp near ptr loc_0BEC5
loc_06902:
    sub ax, 8
    cmp ax, cx
    jne loc_0690C
    jmp near ptr loc_0BEC5
loc_0690C:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06932
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06932
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06932
    sub ax, 8
    cmp ax, cx
    jne loc_06928
    jmp near ptr loc_0BEC5
loc_06928:
    sub ax, 8
    cmp ax, cx
    jne loc_06932
    jmp near ptr loc_0BEC5
loc_06932:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_069B1
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_069B1
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06955
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06974
    sub ax, 8
loc_06955:
    cmp ax, dx
    je loc_06974
    sub ax, 8
    cmp ax, dx
    je loc_06974
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_069B1
    sub ax, 8
    cmp ax, dx
    je loc_06974
    sub ax, 8
    cmp ax, dx
    jne loc_069B1
loc_06974:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06981
    jmp near ptr loc_0BEC5
loc_06981:
    sub ax, 8
    cmp ax, cx
    jne loc_0698B
    jmp near ptr loc_0BEC5
loc_0698B:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_069B1
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_069B1
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_069B1
    sub ax, 8
    cmp ax, cx
    jne loc_069A7
    jmp near ptr loc_0BEC5
loc_069A7:
    sub ax, 8
    cmp ax, cx
    jne loc_069B1
    jmp near ptr loc_0BEC5
loc_069B1:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06A30
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06A30
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_069D4
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_069F3
    sub ax, 8
loc_069D4:
    cmp ax, dx
    je loc_069F3
    sub ax, 8
    cmp ax, dx
    je loc_069F3
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06A30
    sub ax, 8
    cmp ax, dx
    je loc_069F3
    sub ax, 8
    cmp ax, dx
    jne loc_06A30
loc_069F3:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06A00
    jmp near ptr loc_0BEC5
loc_06A00:
    sub ax, 8
    cmp ax, cx
    jne loc_06A0A
    jmp near ptr loc_0BEC5
loc_06A0A:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06A30
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06A30
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06A30
    sub ax, 8
    cmp ax, cx
    jne loc_06A26
    jmp near ptr loc_0BEC5
loc_06A26:
    sub ax, 8
    cmp ax, cx
    jne loc_06A30
    jmp near ptr loc_0BEC5
loc_06A30:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06AAF
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06AAF
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06A53
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06A72
    sub ax, 8
loc_06A53:
    cmp ax, dx
    je loc_06A72
    sub ax, 8
    cmp ax, dx
    je loc_06A72
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06AAF
    sub ax, 8
    cmp ax, dx
    je loc_06A72
    sub ax, 8
    cmp ax, dx
    jne loc_06AAF
loc_06A72:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06A7F
    jmp near ptr loc_0BEC5
loc_06A7F:
    sub ax, 8
    cmp ax, cx
    jne loc_06A89
    jmp near ptr loc_0BEC5
loc_06A89:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06AAF
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06AAF
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06AAF
    sub ax, 8
    cmp ax, cx
    jne loc_06AA5
    jmp near ptr loc_0BEC5
loc_06AA5:
    sub ax, 8
    cmp ax, cx
    jne loc_06AAF
    jmp near ptr loc_0BEC5
loc_06AAF:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06B2E
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06B2E
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06AD2
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06AF1
    sub ax, 8
loc_06AD2:
    cmp ax, dx
    je loc_06AF1
    sub ax, 8
    cmp ax, dx
    je loc_06AF1
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06B2E
    sub ax, 8
    cmp ax, dx
    je loc_06AF1
    sub ax, 8
    cmp ax, dx
    jne loc_06B2E
loc_06AF1:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06AFE
    jmp near ptr loc_0BEC5
loc_06AFE:
    sub ax, 8
    cmp ax, cx
    jne loc_06B08
    jmp near ptr loc_0BEC5
loc_06B08:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06B2E
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06B2E
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06B2E
    sub ax, 8
    cmp ax, cx
    jne loc_06B24
    jmp near ptr loc_0BEC5
loc_06B24:
    sub ax, 8
    cmp ax, cx
    jne loc_06B2E
    jmp near ptr loc_0BEC5
loc_06B2E:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06BAD
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06BAD
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06B51
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06B70
    sub ax, 8
loc_06B51:
    cmp ax, dx
    je loc_06B70
    sub ax, 8
    cmp ax, dx
    je loc_06B70
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06BAD
    sub ax, 8
    cmp ax, dx
    je loc_06B70
    sub ax, 8
    cmp ax, dx
    jne loc_06BAD
loc_06B70:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06B7D
    jmp near ptr loc_0BEC5
loc_06B7D:
    sub ax, 8
    cmp ax, cx
    jne loc_06B87
    jmp near ptr loc_0BEC5
loc_06B87:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06BAD
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06BAD
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06BAD
    sub ax, 8
    cmp ax, cx
    jne loc_06BA3
    jmp near ptr loc_0BEC5
loc_06BA3:
    sub ax, 8
    cmp ax, cx
    jne loc_06BAD
    jmp near ptr loc_0BEC5
loc_06BAD:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06C2C
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06C2C
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06BD0
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06BEF
    sub ax, 8
loc_06BD0:
    cmp ax, dx
    je loc_06BEF
    sub ax, 8
    cmp ax, dx
    je loc_06BEF
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06C2C
    sub ax, 8
    cmp ax, dx
    je loc_06BEF
    sub ax, 8
    cmp ax, dx
    jne loc_06C2C
loc_06BEF:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06BFC
    jmp near ptr loc_0BEC5
loc_06BFC:
    sub ax, 8
    cmp ax, cx
    jne loc_06C06
    jmp near ptr loc_0BEC5
loc_06C06:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06C2C
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06C2C
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06C2C
    sub ax, 8
    cmp ax, cx
    jne loc_06C22
    jmp near ptr loc_0BEC5
loc_06C22:
    sub ax, 8
    cmp ax, cx
    jne loc_06C2C
    jmp near ptr loc_0BEC5
loc_06C2C:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06CAB
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06CAB
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06C4F
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06C6E
    sub ax, 8
loc_06C4F:
    cmp ax, dx
    je loc_06C6E
    sub ax, 8
    cmp ax, dx
    je loc_06C6E
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06CAB
    sub ax, 8
    cmp ax, dx
    je loc_06C6E
    sub ax, 8
    cmp ax, dx
    jne loc_06CAB
loc_06C6E:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06C7B
    jmp near ptr loc_0BEC5
loc_06C7B:
    sub ax, 8
    cmp ax, cx
    jne loc_06C85
    jmp near ptr loc_0BEC5
loc_06C85:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06CAB
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06CAB
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06CAB
    sub ax, 8
    cmp ax, cx
    jne loc_06CA1
    jmp near ptr loc_0BEC5
loc_06CA1:
    sub ax, 8
    cmp ax, cx
    jne loc_06CAB
    jmp near ptr loc_0BEC5
loc_06CAB:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06D2A
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06D2A
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06CCE
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06CED
    sub ax, 8
loc_06CCE:
    cmp ax, dx
    je loc_06CED
    sub ax, 8
    cmp ax, dx
    je loc_06CED
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06D2A
    sub ax, 8
    cmp ax, dx
    je loc_06CED
    sub ax, 8
    cmp ax, dx
    jne loc_06D2A
loc_06CED:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06CFA
    jmp near ptr loc_0BEC5
loc_06CFA:
    sub ax, 8
    cmp ax, cx
    jne loc_06D04
    jmp near ptr loc_0BEC5
loc_06D04:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06D2A
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06D2A
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06D2A
    sub ax, 8
    cmp ax, cx
    jne loc_06D20
    jmp near ptr loc_0BEC5
loc_06D20:
    sub ax, 8
    cmp ax, cx
    jne loc_06D2A
    jmp near ptr loc_0BEC5
loc_06D2A:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06DA9
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06DA9
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06D4D
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06D6C
    sub ax, 8
loc_06D4D:
    cmp ax, dx
    je loc_06D6C
    sub ax, 8
    cmp ax, dx
    je loc_06D6C
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06DA9
    sub ax, 8
    cmp ax, dx
    je loc_06D6C
    sub ax, 8
    cmp ax, dx
    jne loc_06DA9
loc_06D6C:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06D79
    jmp near ptr loc_0BEC5
loc_06D79:
    sub ax, 8
    cmp ax, cx
    jne loc_06D83
    jmp near ptr loc_0BEC5
loc_06D83:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06DA9
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06DA9
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06DA9
    sub ax, 8
    cmp ax, cx
    jne loc_06D9F
    jmp near ptr loc_0BEC5
loc_06D9F:
    sub ax, 8
    cmp ax, cx
    jne loc_06DA9
    jmp near ptr loc_0BEC5
loc_06DA9:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06E28
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06E28
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06DCC
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06DEB
    sub ax, 8
loc_06DCC:
    cmp ax, dx
    je loc_06DEB
    sub ax, 8
    cmp ax, dx
    je loc_06DEB
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06E28
    sub ax, 8
    cmp ax, dx
    je loc_06DEB
    sub ax, 8
    cmp ax, dx
    jne loc_06E28
loc_06DEB:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06DF8
    jmp near ptr loc_0BEC5
loc_06DF8:
    sub ax, 8
    cmp ax, cx
    jne loc_06E02
    jmp near ptr loc_0BEC5
loc_06E02:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06E28
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06E28
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06E28
    sub ax, 8
    cmp ax, cx
    jne loc_06E1E
    jmp near ptr loc_0BEC5
loc_06E1E:
    sub ax, 8
    cmp ax, cx
    jne loc_06E28
    jmp near ptr loc_0BEC5
loc_06E28:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06EA7
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06EA7
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06E4B
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06E6A
    sub ax, 8
loc_06E4B:
    cmp ax, dx
    je loc_06E6A
    sub ax, 8
    cmp ax, dx
    je loc_06E6A
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06EA7
    sub ax, 8
    cmp ax, dx
    je loc_06E6A
    sub ax, 8
    cmp ax, dx
    jne loc_06EA7
loc_06E6A:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06E77
    jmp near ptr loc_0BEC5
loc_06E77:
    sub ax, 8
    cmp ax, cx
    jne loc_06E81
    jmp near ptr loc_0BEC5
loc_06E81:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06EA7
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06EA7
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06EA7
    sub ax, 8
    cmp ax, cx
    jne loc_06E9D
    jmp near ptr loc_0BEC5
loc_06E9D:
    sub ax, 8
    cmp ax, cx
    jne loc_06EA7
    jmp near ptr loc_0BEC5
loc_06EA7:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06F26
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06F26
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06ECA
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06EE9
    sub ax, 8
loc_06ECA:
    cmp ax, dx
    je loc_06EE9
    sub ax, 8
    cmp ax, dx
    je loc_06EE9
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06F26
    sub ax, 8
    cmp ax, dx
    je loc_06EE9
    sub ax, 8
    cmp ax, dx
    jne loc_06F26
loc_06EE9:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06EF6
    jmp near ptr loc_0BEC5
loc_06EF6:
    sub ax, 8
    cmp ax, cx
    jne loc_06F00
    jmp near ptr loc_0BEC5
loc_06F00:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06F26
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06F26
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06F26
    sub ax, 8
    cmp ax, cx
    jne loc_06F1C
    jmp near ptr loc_0BEC5
loc_06F1C:
    sub ax, 8
    cmp ax, cx
    jne loc_06F26
    jmp near ptr loc_0BEC5
loc_06F26:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_06FA5
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_06FA5
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06F49
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06F68
    sub ax, 8
loc_06F49:
    cmp ax, dx
    je loc_06F68
    sub ax, 8
    cmp ax, dx
    je loc_06F68
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06FA5
    sub ax, 8
    cmp ax, dx
    je loc_06F68
    sub ax, 8
    cmp ax, dx
    jne loc_06FA5
loc_06F68:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06F75
    jmp near ptr loc_0BEC5
loc_06F75:
    sub ax, 8
    cmp ax, cx
    jne loc_06F7F
    jmp near ptr loc_0BEC5
loc_06F7F:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_06FA5
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_06FA5
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_06FA5
    sub ax, 8
    cmp ax, cx
    jne loc_06F9B
    jmp near ptr loc_0BEC5
loc_06F9B:
    sub ax, 8
    cmp ax, cx
    jne loc_06FA5
    jmp near ptr loc_0BEC5
loc_06FA5:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_07024
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_07024
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_06FC8
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_06FE7
    sub ax, 8
loc_06FC8:
    cmp ax, dx
    je loc_06FE7
    sub ax, 8
    cmp ax, dx
    je loc_06FE7
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_07024
    sub ax, 8
    cmp ax, dx
    je loc_06FE7
    sub ax, 8
    cmp ax, dx
    jne loc_07024
loc_06FE7:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06FF4
    jmp near ptr loc_0BEC5
loc_06FF4:
    sub ax, 8
    cmp ax, cx
    jne loc_06FFE
    jmp near ptr loc_0BEC5
loc_06FFE:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_07024
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_07024
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_07024
    sub ax, 8
    cmp ax, cx
    jne loc_0701A
    jmp near ptr loc_0BEC5
loc_0701A:
    sub ax, 8
    cmp ax, cx
    jne loc_07024
    jmp near ptr loc_0BEC5
loc_07024:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_070A3
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_070A3
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_07047
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_07066
    sub ax, 8
loc_07047:
    cmp ax, dx
    je loc_07066
    sub ax, 8
    cmp ax, dx
    je loc_07066
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_070A3
    sub ax, 8
    cmp ax, dx
    je loc_07066
    sub ax, 8
    cmp ax, dx
    jne loc_070A3
loc_07066:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_07073
    jmp near ptr loc_0BEC5
loc_07073:
    sub ax, 8
    cmp ax, cx
    jne loc_0707D
    jmp near ptr loc_0BEC5
loc_0707D:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_070A3
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_070A3
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_070A3
    sub ax, 8
    cmp ax, cx
    jne loc_07099
    jmp near ptr loc_0BEC5
loc_07099:
    sub ax, 8
    cmp ax, cx
    jne loc_070A3
    jmp near ptr loc_0BEC5
loc_070A3:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_07122
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_07122
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_070C6
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_070E5
    sub ax, 8
loc_070C6:
    cmp ax, dx
    je loc_070E5
    sub ax, 8
    cmp ax, dx
    je loc_070E5
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_07122
    sub ax, 8
    cmp ax, dx
    je loc_070E5
    sub ax, 8
    cmp ax, dx
    jne loc_07122
loc_070E5:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_070F2
    jmp near ptr loc_0BEC5
loc_070F2:
    sub ax, 8
    cmp ax, cx
    jne loc_070FC
    jmp near ptr loc_0BEC5
loc_070FC:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_07122
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_07122
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_07122
    sub ax, 8
    cmp ax, cx
    jne loc_07118
    jmp near ptr loc_0BEC5
loc_07118:
    sub ax, 8
    cmp ax, cx
    jne loc_07122
    jmp near ptr loc_0BEC5
loc_07122:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_071A1
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_071A1
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_07145
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_07164
    sub ax, 8
loc_07145:
    cmp ax, dx
    je loc_07164
    sub ax, 8
    cmp ax, dx
    je loc_07164
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_071A1
    sub ax, 8
    cmp ax, dx
    je loc_07164
    sub ax, 8
    cmp ax, dx
    jne loc_071A1
loc_07164:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_07171
    jmp near ptr loc_0BEC5
loc_07171:
    sub ax, 8
    cmp ax, cx
    jne loc_0717B
    jmp near ptr loc_0BEC5
loc_0717B:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_071A1
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_071A1
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_071A1
    sub ax, 8
    cmp ax, cx
    jne loc_07197
    jmp near ptr loc_0BEC5
loc_07197:
    sub ax, 8
    cmp ax, cx
    jne loc_071A1
    jmp near ptr loc_0BEC5
loc_071A1:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_07220
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_07220
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_071C4
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_071E3
    sub ax, 8
loc_071C4:
    cmp ax, dx
    je loc_071E3
    sub ax, 8
    cmp ax, dx
    je loc_071E3
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_07220
    sub ax, 8
    cmp ax, dx
    je loc_071E3
    sub ax, 8
    cmp ax, dx
    jne loc_07220
loc_071E3:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_071F0
    jmp near ptr loc_0BEC5
loc_071F0:
    sub ax, 8
    cmp ax, cx
    jne loc_071FA
    jmp near ptr loc_0BEC5
loc_071FA:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_07220
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_07220
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_07220
    sub ax, 8
    cmp ax, cx
    jne loc_07216
    jmp near ptr loc_0BEC5
loc_07216:
    sub ax, 8
    cmp ax, cx
    jne loc_07220
    jmp near ptr loc_0BEC5
loc_07220:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_0729F
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_0729F
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_07243
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_07262
    sub ax, 8
loc_07243:
    cmp ax, dx
    je loc_07262
    sub ax, 8
    cmp ax, dx
    je loc_07262
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0729F
    sub ax, 8
    cmp ax, dx
    je loc_07262
    sub ax, 8
    cmp ax, dx
    jne loc_0729F
loc_07262:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0726F
    jmp near ptr loc_0BEC5
loc_0726F:
    sub ax, 8
    cmp ax, cx
    jne loc_07279
    jmp near ptr loc_0BEC5
loc_07279:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0729F
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_0729F
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_0729F
    sub ax, 8
    cmp ax, cx
    jne loc_07295
    jmp near ptr loc_0BEC5
loc_07295:
    sub ax, 8
    cmp ax, cx
    jne loc_0729F
    jmp near ptr loc_0BEC5
loc_0729F:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_0731E
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_0731E
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_072C2
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_072E1
    sub ax, 8
loc_072C2:
    cmp ax, dx
    je loc_072E1
    sub ax, 8
    cmp ax, dx
    je loc_072E1
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0731E
    sub ax, 8
    cmp ax, dx
    je loc_072E1
    sub ax, 8
    cmp ax, dx
    jne loc_0731E
loc_072E1:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_072EE
    jmp near ptr loc_0BEC5
loc_072EE:
    sub ax, 8
    cmp ax, cx
    jne loc_072F8
    jmp near ptr loc_0BEC5
loc_072F8:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0731E
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_0731E
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_0731E
    sub ax, 8
    cmp ax, cx
    jne loc_07314
    jmp near ptr loc_0BEC5
loc_07314:
    sub ax, 8
    cmp ax, cx
    jne loc_0731E
    jmp near ptr loc_0BEC5
loc_0731E:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_0739D
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_0739D
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_07341
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_07360
    sub ax, 8
loc_07341:
    cmp ax, dx
    je loc_07360
    sub ax, 8
    cmp ax, dx
    je loc_07360
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0739D
    sub ax, 8
    cmp ax, dx
    je loc_07360
    sub ax, 8
    cmp ax, dx
    jne loc_0739D
loc_07360:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0736D
    jmp near ptr loc_0BEC5
loc_0736D:
    sub ax, 8
    cmp ax, cx
    jne loc_07377
    jmp near ptr loc_0BEC5
loc_07377:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0739D
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_0739D
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_0739D
    sub ax, 8
    cmp ax, cx
    jne loc_07393
    jmp near ptr loc_0BEC5
loc_07393:
    sub ax, 8
    cmp ax, cx
    jne loc_0739D
    jmp near ptr loc_0BEC5
loc_0739D:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx], 0
    je loc_0741C
    cmp word ptr ds:[bx + 01Eh], 0
    je loc_0741C
    mov ax, word ptr ds:[bx + 4]
    test ax, 7
    je loc_073C0
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je loc_073DF
    sub ax, 8
loc_073C0:
    cmp ax, dx
    je loc_073DF
    sub ax, 8
    cmp ax, dx
    je loc_073DF
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0741C
    sub ax, 8
    cmp ax, dx
    je loc_073DF
    sub ax, 8
    cmp ax, dx
    jne loc_0741C
loc_073DF:
    mov ax, word ptr ds:[bx + 2]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_073EC
    jmp near ptr loc_0BEC5
loc_073EC:
    sub ax, 8
    cmp ax, cx
    jne loc_073F6
    jmp near ptr loc_0BEC5
loc_073F6:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne loc_0741C
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je loc_0741C
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je loc_0741C
    sub ax, 8
    cmp ax, cx
    jne loc_07412
    jmp near ptr loc_0BEC5
loc_07412:
    sub ax, 8
    cmp ax, cx
    jne loc_0741C
    jmp near ptr loc_0BEC5
loc_0741C:
    add bx, RECORD_SIZE
loc_0741F:
    ret

loc_07420:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07429
    ret
loc_07429:
    mov word ptr ds:[bx + REC_STATUS], 1
    mov ax, word ptr ds:[02378h]
    add ax, word ptr ds:[0A278h]
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[02376h]
    cmp ax, 0C0h
    jbe loc_07442
    mov ax, 0C0h
loc_07442:
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_ANIM_COUNTER], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], 5
    mov word ptr ds:[bx + REC_TYPE], 0
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    mov si, word ptr ds:[0237Ah]
    mov word ptr ds:[bx + REC_ITEM_INDEX], si
    add si, 046h
    mov word ptr ds:[bx + REC_SPRITE], si
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    ret
loc_07476:
    call FindFreeRecordPoolB
    cmp bx, -1
    jne loc_0747F
    ret
loc_0747F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0748B
    mov byte ptr ds:[SfxRequest], 01Ah
loc_0748B:
    mov cx, 0Ch
    mov dx, 0Ch
    cmp word ptr ds:[0A8C2h], 1
    jne loc_0749E
    mov cx, 01Ch
    mov dx, 8
loc_0749E:
    mov ax, word ptr ss:[bp + REC_X]
    add ax, cx
    mov word ptr ds:[bx + REC_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, dx
    mov word ptr ds:[bx + REC_Y], ax
    call loc_074B5
    call loc_074E2
    ret
loc_074B5:
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + 01Eh], 0
    mov word ptr ds:[bx + 6], 0
    mov word ptr ds:[bx + 8], 031h
    mov word ptr ds:[bx + 0Ah], 1
    mov word ptr ds:[bx + 014h], 0
    mov word ptr ds:[bx + 016h], 2
    mov word ptr ds:[bx + 018h], 0Bh
    mov word ptr ds:[bx + 01Ch], 0FFFFh
    ret
loc_074E2:
    mov ax, word ptr ds:[bx + REC_X]
    mov cx, word ptr ds:[PRIMARY_RECORD + REC_X]
    add cx, 9
    sub ax, cx
    mov word ptr ds:[bx + 02Ch], ax
    mov ax, word ptr ds:[bx + REC_Y]
    mov cx, word ptr ds:[PRIMARY_RECORD + REC_Y]
    sub ax, cx
    mov word ptr ds:[bx + 02Ah], ax
    ret
loc_074FE:
    call FindFreeRecordPoolA
    cmp bx, -1
    je loc_07507
    ret
loc_07507:
    mov cx, POOL_A_COUNT
    mov bx, POOL_A
loc_0750D:
    cmp word ptr ds:[bx + REC_KIND], 6
    je loc_07519
    cmp word ptr ds:[bx + REC_KIND], 1
    jne loc_07521
loc_07519:
    add bx, RECORD_SIZE
    loop loc_0750D
    mov bx, POOL_A
loc_07521:
    jmp near ptr loc_0BD0D

; Near leaf. DS:95D8 supplies the first candidate. Inspect at most35 status words at stride38h in23B4..2B5B,
; wrapping BX after increment equals2B5C. Return BX=first zero-status record, CX=35-skipped; save BX to DS:95D8
; without activating record. Full pool returns BX=FFFF,CX=0 and leaves cursor unchanged. Requires aligned in-
; pool cursor; unlike poolB, end cursor is not normalized before first read. AX,DX,SI,DI,BP,segments preserved;
; flags changed.
FindFreeRecordPoolA:
    mov cx, POOL_A_COUNT
    mov bx, word ptr ds:[POOL_A_CURSOR]
loc_0752B:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_07542
    add bx, RECORD_SIZE
    cmp bx, POOL_A_END
    jne loc_0753C
    mov bx, POOL_A
loc_0753C:
    loop loc_0752B
    mov bx, 0FFFFh
    ret
loc_07542:
    mov word ptr ds:[POOL_A_CURSOR], bx
    ret

loc_07547:
    call FindFreeRecordPoolB
    cmp bx, -1
    je loc_07550
    ret
loc_07550:
    mov cx, POOL_B_COUNT
    mov bx, POOL_B
loc_07556:
    cmp word ptr ds:[bx + REC_TYPE], 9
    je loc_07568
    cmp word ptr ds:[bx + REC_TYPE], 0Ah
    je loc_07568
    cmp word ptr ds:[bx + REC_KIND], 1
    jne loc_07570
loc_07568:
    add bx, RECORD_SIZE
    loop loc_07556
    mov bx, POOL_B
loc_07570:
    jmp near ptr loc_0BD0D

; Near leaf. DS:95DA supplies cursor. Normalize BX==32CCh to2B5Ch before reading; inspect at most34 zero-status
; records at stride38h. Success returns BX and CX=34-skipped and saves cursor; failure BX=FFFF,CX=0 leaves
; cursor unchanged. Accept aligned pool cursor or exact end32CC; other pointers not validated. Does not activate
; or clear records. AX,DX,SI,DI,BP,segments preserved; flags changed.
FindFreeRecordPoolB:
    mov cx, POOL_B_COUNT
    mov bx, word ptr ds:[POOL_B_CURSOR]
loc_0757A:
    cmp bx, POOL_B_END
    jne loc_07583
    mov bx, POOL_B
loc_07583:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_07591
    add bx, RECORD_SIZE
    loop loc_0757A
    mov bx, 0FFFFh
    ret
loc_07591:
    mov word ptr ds:[POOL_B_CURSOR], bx
    ret

loc_07596:
    mov bx, word ptr ss:[bp + 014h]
    shl bx, 1
    jmp word ptr cs:[bx + 075A0h]
; UNKNOWN: not yet classified as code or data
    db 046h,077h,08Eh,076h,0A6h,075h
    mov bx, word ptr ss:[bp + 8]
    mov cx, word ptr cs:[095A6h]
    cmp bx, 01Ch
    jb loc_075BB
    sub bx, 01Ch
    mov cx, word ptr cs:[095AEh]
loc_075BB:
    shl bx, 1
    add bx, 09392h
    mov si, word ptr cs:[bx]
    mov word ptr cs:[07624h], si
    mov word ptr cs:[07626h], cx
    mov di, word ptr ss:[bp + 0Ch]
    cmp di, -1
    je loc_075DB
    push bp
    call loc_075F5
    pop bp
loc_075DB:
    mov di, word ptr ss:[bp + 010h]
    cmp di, -1
    jne loc_075E4
    ret
loc_075E4:
    mov si, word ptr cs:[07624h]
    mov cx, word ptr cs:[07626h]
    mov ax, word ptr ds:[01028h]
    shr ax, 1
    add si, ax
loc_075F5:
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    shl bx, 1
    shl bx, 1
    add bx, word ptr ss:[bp + 012h]
    mov dx, 07658h
    test word ptr ss:[bp + 024h], 0FFFFh
    jne loc_07615
    mov dx, 07628h
loc_07615:
    shl bx, 1
    add bx, dx
    mov ds, cx
    mov bp, 010h
    mov cx, bp
    jmp word ptr cs:[bx]
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,049h,038h,026h,039h,0DFh,039h,0EEh,03Ah,088h,076h,088h
    db 076h,088h,076h,088h,076h,03Ch,010h,0EDh,010h,0B8h,011h,0B6h,012h,0E7h,013h,04Bh
    db 015h,07Ch,016h,07Ah,017h,06Eh,02Eh,088h,076h,088h,076h,088h,076h,088h,076h,088h
    db 076h,088h,076h,088h,076h,07Ch,038h,053h,03Ch,0BCh,03Ch,052h,03Dh,088h,076h,088h
    db 076h,088h,076h,088h,076h,0B7h,010h,045h,018h,099h,018h,0F7h,018h,05Fh,019h,0D1h
    db 019h,039h,01Ah,097h,01Ah,0CBh,02Eh,088h,076h,088h,076h,088h,076h,088h,076h,088h
    db 076h,088h,076h,088h,076h,02Eh,08Eh,01Eh,096h,095h,0C3h
    mov di, word ptr ss:[bp + 0Ch]
    cmp di, -1
    jne loc_07697
    ret
loc_07697:
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr ss:[bp + 8]
    mov cx, word ptr cs:[095AAh]
    cmp bx, 0FAh
    jb loc_076B3
    sub bx, 0FAh
    mov cx, word ptr cs:[095ACh]
loc_076B3:
    shl bx, 1
    add bx, 09192h
    mov si, word ptr cs:[bx]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    shl bx, 1
    shl bx, 1
    add bx, word ptr ss:[bp + 012h]
    mov dx, 07716h
    test word ptr ss:[bp + 024h], 0FFFFh
    jne loc_076D7
    mov dx, 076E6h
loc_076D7:
    shl bx, 1
    add bx, dx
    mov ds, cx
    mov bp, 010h
    mov cx, bp
    jmp word ptr cs:[bx]
; UNKNOWN: not yet classified as code or data
    db 090h,0B7h,038h,012h,03Eh,070h,03Eh,0FBh,03Eh,088h,076h,088h,076h,088h,076h,088h
    db 076h,0EBh,01Ah,04Fh,01Bh,0C6h,01Bh,061h,01Ch,01Bh,01Dh,0F4h,01Dh,0AEh,01Eh,049h
    db 01Fh,081h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h
    db 076h,0D6h,038h,0B0h,03Fh,0EBh,03Fh,03Ah,040h,088h,076h,088h,076h,088h,076h,088h
    db 076h,02Eh,01Bh,0C0h,01Fh,0FBh,01Fh,03Ch,020h,083h,020h,0D0h,020h,017h,021h,058h
    db 021h,040h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h
    db 076h

loc_07746:
    mov di, word ptr ss:[bp + 0Ch]
    cmp di, -1
    jne loc_0774F
    ret
loc_0774F:
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr ss:[bp + 8]
    mov cx, word ptr cs:[095A8h]
    shl bx, 1
    add bx, 08F92h
    mov si, word ptr cs:[bx]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    shl bx, 1
    shl bx, 1
    add bx, word ptr ss:[bp + 012h]
    mov ds, cx
    mov bp, 8
    mov cx, bp
    shl bx, 1
    jmp word ptr cs:[bx + 07782h]
; UNKNOWN: not yet classified as code or data
    db 090h,0F9h,038h,09Dh,040h,0D7h,040h,02Bh,041h,088h,076h,088h,076h,088h,076h,088h
    db 076h,093h,021h,0D6h,021h,023h,022h,085h,022h,0FCh,022h,08Dh,023h,010h,024h,07Eh
    db 024h,0B6h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h
    db 076h
loc_077B2:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_077BE
    mov byte ptr ds:[SfxRequest], 0Ch
loc_077BE:
    mov word ptr ds:[0A97Ch], 0
    ret

loc_077C5:
    cmp word ptr ds:[0A97Ch], 1
    je loc_077CD
    ret
loc_077CD:
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
    jae loc_077BE
    cmp word ptr ds:[0A97Ah], 058h
    je loc_077B2
    inc word ptr ds:[0A97Ah]

loc_077DF:
    push bp
    call loc_077F6
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_077F4
    call loc_0511F
    call loc_077F6
    call loc_0511F
loc_077F4:
    pop bp
    ret

loc_077F6:
    mov al, 01Dh
    mov ah, 05Fh
    call DrawOffsetFromRow9EE8
    mov word ptr ds:[095DCh], di
    mov cx, word ptr ds:[0A97Ah]
    shr cx, 1
    jcxz loc_0780B
    jmp short loc_0780E
loc_0780B:
    jmp near ptr loc_0789A
loc_0780E:
    push cx
    mov es, word ptr cs:[ScreenSegment]
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_07875
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_0784D
    mov word ptr es:[di], 0FFCEh
    mov word ptr es:[di + 2], 0C4EEh
    test di, 06000h
    jne loc_07839
    add di, 07F60h
loc_07839:
    sub di, 02000h
    test di, 06000h
    jne loc_07847
    add di, 07F60h
loc_07847:
    sub di, 02000h
    jmp short loc_07892
loc_0784D:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 1
    out dx, al
    mov byte ptr es:[di], 030h
    mov al, 2
    out dx, al
    mov byte ptr es:[di], 07Ch
    mov al, 4
    out dx, al
    mov byte ptr es:[di], 0FFh
    mov al, 8
    out dx, al
    mov byte ptr es:[di], 0FEh
    sub di, 050h
    jmp short loc_07892
loc_07875:
    mov word ptr es:[di], 0A02Fh
    mov ax, 02000h
    test di, ax
    je loc_07884
    mov ax, 0E050h
loc_07884:
    sub di, ax
    mov ax, 02000h
    test di, ax
    je loc_07890
    mov ax, 0E050h
loc_07890:
    sub di, ax
loc_07892:
    pop cx
    loop loc_07897
    jmp short loc_0789A
loc_07897:
    jmp near ptr loc_0780E
loc_0789A:
    mov cx, 02Ch
    mov ax, word ptr ds:[0A97Ah]
    shr ax, 1
    sub cx, ax
    jcxz loc_0791B
loc_078A6:
    push cx
    mov es, word ptr cs:[ScreenSegment]
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_078FB
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_078E5
    mov word ptr es:[di], 0
    mov word ptr es:[di + 2], 0
    test di, 06000h
    jne loc_078D1
    add di, 07F60h
loc_078D1:
    sub di, 02000h
    test di, 06000h
    jne loc_078DF
    add di, 07F60h
loc_078DF:
    sub di, 02000h
    jmp short loc_07918
loc_078E5:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    mov byte ptr es:[di], 0
    sub di, 028h
    sub di, 028h
    jmp short loc_07918
loc_078FB:
    mov word ptr es:[di], 0
    mov ax, 02000h
    test di, ax
    je loc_0790A
    mov ax, 0E050h
loc_0790A:
    sub di, ax
    mov ax, 02000h
    test di, ax
    je loc_07916
    mov ax, 0E050h
loc_07916:
    sub di, ax
loc_07918:
    pop cx
    loop loc_078A6
loc_0791B:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0792D
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
loc_0792D:
    cmp word ptr ds:[0A97Ah], 010h
    jae loc_07947
    cmp word ptr ds:[0A97Ch], 1
    je loc_07947
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_07947
    mov byte ptr ds:[SfxRequest], 0Ah
loc_07947:
    ret

loc_07948:
    mov es, word ptr cs:[09592h]
    mov si, word ptr ds:[0A408h]
    mov word ptr ds:[0A406h], 0Dh
    mov word ptr ds:[0A40Ah], 0
loc_0795D:
    mov al, byte ptr es:[si]
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    call word ptr ds:[bx - 06A22h]
    add word ptr ds:[0A40Ah], 010h
    inc si
    dec word ptr ds:[0A406h]
    jne loc_0795D
    ret
    cmp al, 4
    jne loc_0797E
    jmp near ptr loc_07A6E
loc_0797E:
    cmp al, 7
    jne loc_07985
    jmp near ptr loc_07A7A
loc_07985:
    cmp al, 06Ch
    jne loc_0798C
    jmp near ptr loc_07AAE
loc_0798C:
    cmp al, 06Dh
    jne loc_07993
    jmp near ptr loc_07AC4
loc_07993:
    cmp al, 0ACh
    jne loc_0799A
    jmp near ptr loc_07ADA
loc_0799A:
    cmp al, 0B1h
    jne loc_079A1
    jmp near ptr loc_07AF0
loc_079A1:
    cmp al, 0C9h
    je loc_07A11
    ret
; UNKNOWN: not yet classified as code or data
    db 026h,0C6h,04h,01h,026h,0C6h,044h,01h,01h,026h,0C6h,044h,0Dh,01h,026h,0C6h
    db 044h,0Eh,01h,0C3h,0E8h,0E9h,0FFh,0E8h,064h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h
    db 0E8h,077h,00h,0C7h,047h,018h,048h,00h,0C7h,047h,06h,04h,00h,0E9h,0D1h,07h
    db 0E8h,0CDh,0FFh,0E8h,048h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h,0E8h,05Bh,00h,0C7h
    db 047h,018h,075h,00h,0C7h,047h,08h,024h,00h,0C7h,047h,06h,04h,00h,0E9h,0B0h
    db 07h,0E8h,0ACh,0FFh,0E8h,027h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h,0E8h,03Ah,00h
    db 0C7h,047h,018h,072h,00h,0C7h,047h,06h,04h,00h,0C3h
loc_07A11:
    mov byte ptr es:[si + 0Dh], 026h
    mov byte ptr es:[si + 0Eh], 027h
    mov byte ptr es:[si], 028h
    mov byte ptr es:[si + 1], 029h
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07A2D
    ret
loc_07A2D:
    call loc_07A40
    mov word ptr ds:[bx + 018h], 028h
    mov word ptr ds:[bx + 8], 01Ch
    mov word ptr ds:[bx + 6], 0
    ret
loc_07A40:
    mov word ptr ds:[bx + 016h], 4
    mov ax, word ptr ds:[0A40Ah]
    mov word ptr ds:[bx + 4], ax
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 0Ah], 0
    mov word ptr ds:[bx + 2], 0
    mov word ptr ds:[bx + 014h], 2
    mov word ptr ds:[bx + 024h], 0
    mov word ptr ds:[bx + 020h], 0Ah
    mov word ptr ds:[bx + 028h], 0FFFFh
    ret
loc_07A6E:
    call loc_081C9
    jne loc_07A74
    ret
loc_07A74:
    mov word ptr ds:[bx + 018h], 08Bh
    ret
loc_07A7A:
    call loc_081C9
    jne loc_07A80
    ret
loc_07A80:
    mov word ptr ds:[bx + 018h], 08Ch
    ret
; UNKNOWN: not yet classified as code or data
    db 0E8h,015h,07h,075h,01h,0C3h,0C7h,047h,018h,08Eh,00h,0C3h,0E8h,034h,07h,075h
    db 01h,0C3h,0B8h,04h,00h,0A3h,07Ah,023h,0E8h,0A4h,0F9h,0C3h,0E8h,0F9h,06h,075h
    db 01h,0C3h,0C7h,047h,018h,08Dh,00h,0C3h
loc_07AAE:
    call loc_081CC
    jne loc_07AB4
    ret
loc_07AB4:
    mov word ptr ds:[bx + 018h], 024h
    mov word ptr ds:[bx + 8], 08Fh
    mov word ptr ds:[bx + 6], 6
    ret
loc_07AC4:
    call loc_081CC
    jne loc_07ACA
    ret
loc_07ACA:
    mov word ptr ds:[bx + 018h], 025h
    mov word ptr ds:[bx + 8], 090h
    mov word ptr ds:[bx + 6], 2
    ret
loc_07ADA:
    call loc_081CC
    jne loc_07AE0
    ret
loc_07AE0:
    mov word ptr ds:[bx + 018h], 090h
    mov word ptr ds:[bx + 8], 089h
    mov word ptr ds:[bx + 6], 6
    ret
loc_07AF0:
    call loc_081CC
    jne loc_07AF6
    ret
loc_07AF6:
    mov word ptr ds:[bx + 018h], 091h
    mov word ptr ds:[bx + 8], 08Ch
    mov word ptr ds:[bx + 6], 2
    ret
; UNKNOWN: not yet classified as code or data
    db 03Ch,030h,074h,09h,03Ch,0C4h,074h,056h,03Ch,05Ah,074h,042h,0C3h,0E8h,0Eh,0FAh
    db 083h,0FBh,0FFh,075h,01h,0C3h,0C7h,047h,016h,04h,00h,0A1h,0Ah,0A4h,089h,047h
    db 04h,0C7h,07h,01h,00h,0C7h,047h,0Ah,00h,00h,0C7h,047h,02h,00h,00h,0C7h
    db 047h,014h,02h,00h,0C7h,047h,024h,00h,00h,0C7h,047h,020h,0Ah,00h,0C7h,047h
    db 018h,02Ah,00h,0C7h,047h,08h,01Ch,00h,0C7h,047h,06h,00h,00h,0C3h,0E8h,072h
    db 06h,075h,01h,0C3h,0C7h,047h,018h,02Eh,00h,083h,06Fh,02h,06h,0C3h,0E8h,062h
    db 06h,075h,01h,0C3h,0C7h,047h,018h,08Fh,00h,0C7h,047h,08h,0BFh,00h,0C7h,047h
    db 06h,06h,00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,08h,0C2h,00h,0C7h
    db 047h,06h,02h,00h,0C3h,0E8h,03Bh,06h,075h,01h,0C3h,083h,06Fh,04h,0Ch,0FFh
    db 077h,04h,08Fh,047h,032h,0C7h,047h,06h,02h,00h,0C7h,047h,018h,073h,00h,0C7h
    db 047h,08h,04Ch,01h,0C3h,0E8h,01Bh,06h,075h,01h,0C3h,083h,047h,04h,0Ch,0FFh
    db 077h,04h,08Fh,047h,032h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,074h,00h,0C7h
    db 047h,08h,04Fh,01h,0C3h,083h,03Eh,0Ah,0A4h,060h,077h,06h,03Ch,0BCh,074h,0B5h
    db 0EBh,04h,03Ch,0BBh,074h,0CFh,02Ch,0E1h,079h,01h,0C3h,03Ch,01Ah,076h,01h,0C3h
    db 050h,08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h,01Eh,070h,020h
    db 09Ah,063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh,0FFh,0A7h,08h
    db 07Ch,090h,0D7h,07Eh,0D7h,07Eh,043h,081h,037h,081h,086h,07Fh,086h,07Fh,05Dh,07Fh
    db 069h,07Fh,07Ah,07Fh,0EAh,07Fh,014h,07Fh,0FBh,07Fh,0A2h,07Ah,086h,07Ah,025h,07Fh
    db 0ADh,07Fh,0ADh,07Fh,0EFh,080h,0EFh,080h,04Ch,080h,03Ah,07Ch,013h,081h,0F7h,079h
    db 0D6h,079h,092h,07Ah,026h,0C6h,04h,01h,0C3h,02Ch,0CEh,079h,01h,0C3h,03Ch,01Dh
    db 076h,01h,0C3h,050h,08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h
    db 01Eh,070h,020h,09Ah,063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh
    db 0FFh,0A7h,06Ah,07Ch,0B0h,07Eh,0B0h,07Eh,036h,07Fh,036h,07Fh,0B7h,080h,0B7h,080h
    db 0DEh,080h,07h,081h,06Eh,080h,0FEh,07Eh,04Ch,080h,072h,081h,088h,081h,01Fh,081h
    db 066h,081h,07Ah,07Ah,06Eh,07Ah,0AFh,044h,013h,081h,0FBh,080h,02Ah,080h,0D4h,07Fh
    db 0A1h,080h,0EFh,080h,0EFh,080h,08Bh,080h,03Bh,080h,02Bh,081h
    cmp al, 0ACh
    jne loc_07CA9
    jmp near ptr loc_07ADA
loc_07CA9:
    cmp al, 0B1h
    jne loc_07CB0
    jmp near ptr loc_07AF0
loc_07CB0:
    cmp al, 0C9h
    jne loc_07CB7
    jmp near ptr loc_07A11
loc_07CB7:
    sub al, 0CEh
    jns loc_07CBC
    ret
loc_07CBC:
    cmp al, 014h
    jbe loc_07CC1
    ret
loc_07CC1:
    push ax
    mov bx, si
    and bx, 03Fh
    mov bl, byte ptr ds:[bx - 037E6h]
    xor bh, bh
    mov word ptr ds:[02070h], bx
    call far ptr loc_0F953
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + 07CE2h]
; UNKNOWN: not yet classified as code or data
    db 07Ah,07Ah,06Eh,07Ah,072h,081h,088h,081h,02Ah,07Dh,04Dh,07Dh,06Eh,080h,025h,07Fh
    db 013h,081h,04Ch,080h,07h,081h,0A1h,080h,08h,07Dh,019h,07Dh,0EFh,080h,043h,081h
    db 037h,081h,02Bh,081h,0D4h,07Fh,0E8h,0BEh,04h,075h,01h,0C3h,0C7h,047h,018h,038h
    db 00h,0C7h,047h,06h,03h,00h,0C3h,0E8h,0ADh,04h,075h,01h,0C3h,0C7h,047h,018h
    db 038h,00h,0C7h,047h,06h,05h,00h,0C3h,0E8h,09Ch,04h,075h,01h,0C3h,0C7h,047h
    db 06h,01h,00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,072h,01h,083h,03Eh,056h
    db 023h,04h,075h,01h,0C3h,0C7h,047h,08h,07Ah,01h,0C3h,0E8h,079h,04h,075h,01h
    db 0C3h,0C7h,047h,06h,07h,00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,073h,01h
    db 083h,03Eh,056h,023h,04h,075h,01h,0C3h,0C7h,047h,08h,07Bh,01h,0C3h,0E8h,056h
    db 04h,075h,01h,0C3h,0C7h,047h,06h,00h,00h,0C7h,047h,018h,084h,00h,0C7h,047h
    db 08h,056h,01h,0C3h,0E8h,040h,04h,075h,01h,0C3h,0C7h,047h,06h,02h,00h,0C7h
    db 047h,018h,084h,00h,0C7h,047h,08h,057h,01h,0C3h,0E8h,02Ah,04h,075h,01h,0C3h
    db 0C7h,047h,06h,04h,00h,0C7h,047h,018h,084h,00h,0C7h,047h,08h,058h,01h,0C3h
    db 0E8h,014h,04h,075h,01h,0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,084h,00h
    db 0C7h,047h,08h,059h,01h,0C3h,03Ch,030h,075h,03h,0E9h,044h,0FDh,03Ch,0BAh,074h
    db 09Dh,03Ch,0BBh,074h,0AFh,03Ch,0BCh,074h,0C1h,03Ch,0B6h,074h,0D3h,03Ch,0D8h,075h
    db 03h,0E9h,088h,0FCh,03Ch,0D7h,075h,03h,0E9h,08Dh,0FCh,03Ch,0D3h,075h,03h,0E9h
    db 0E6h,0FCh,03Ch,0D2h,075h,03h,0E9h,0F5h,0FCh,02Ch,0D7h,079h,01h,0C3h,03Ch,01Ah
    db 076h,01h,0C3h,050h,08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h
    db 01Eh,070h,020h,09Ah,063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh
    db 0FFh,0A7h,026h,07Eh,0A2h,07Ah,086h,07Ah,0BAh,079h,084h,07Eh,09Ah,07Eh,02Ah,07Dh
    db 04Dh,07Dh,0B7h,080h,0B7h,080h,0A1h,080h,058h,07Eh,058h,07Eh,0FEh,07Eh,06Eh,07Eh
    db 072h,081h,088h,081h,05Dh,07Eh,066h,081h,03Bh,080h,02Bh,081h,043h,081h,013h,081h
    db 0FBh,080h,02Ah,080h,0D4h,07Fh
loc_07E58:
    mov byte ptr es:[si], 1
    ret
; UNKNOWN: not yet classified as code or data
    db 0E8h,069h,03h,075h,01h,0C3h,0C7h,047h,018h,019h,00h,0C7h,047h,06h,02h,00h
    db 0C3h,0E8h,058h,03h,075h,01h,0C3h,0C7h,047h,08h,046h,00h,0C7h,047h,018h,030h
    db 00h,0C7h,047h,06h,04h,00h,0C3h,0E8h,042h,03h,075h,01h,0C3h,0C7h,047h,018h
    db 092h,00h,0C7h,047h,08h,05Ah,01h,0C7h,047h,06h,02h,00h,0C3h,0E8h,02Ch,03h
    db 075h,01h,0C3h,0C7h,047h,018h,092h,00h,0C7h,047h,08h,05Bh,01h,0C7h,047h,06h
    db 06h,00h,0C3h,0E8h,016h,03h,075h,01h,0C3h,0C7h,047h,06h,06h,00h,0C7h,047h
    db 018h,086h,00h,0C7h,047h,08h,0C8h,00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h
    db 047h,08h,0DAh,00h,0C7h,047h,06h,02h,00h,0C3h,0E8h,0EFh,02h,075h,01h,0C3h
    db 0C7h,047h,06h,06h,00h,0C7h,047h,018h,088h,00h,0C7h,047h,08h,0FDh,00h,083h
    db 07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,08h,0FAh,00h,0C7h,047h,06h,02h,00h
    db 0C3h,0E8h,0C8h,02h,075h,01h,0C3h,0C7h,047h,06h,02h,00h,0C7h,047h,018h,063h
    db 00h,0C7h,047h,08h,0E7h,00h,0C3h,0E8h,087h,02h,075h,01h,0C3h,0C7h,047h,06h
    db 04h,00h,0C7h,047h,018h,071h,00h,0C3h,0E8h,076h,02h,075h,01h,0C3h,0C7h,047h
    db 06h,04h,00h,0C7h,047h,018h,08Ah,00h,0C3h,0E8h,090h,02h,075h,01h,0C3h,0C7h
    db 047h,06h,07h,00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,0F5h,00h,083h,07Fh
    db 04h,060h,076h,01h,0C3h,0C7h,047h,06h,01h,00h,0C7h,047h,08h,0F4h,00h,0C3h
    db 0E8h,069h,02h,075h,01h,0C3h,0C7h,047h,018h,06Bh,00h,0C3h,0E8h,032h,02h,075h
    db 01h,0C3h,0C7h,047h,018h,06Ch,00h,0C7h,047h,08h,023h,01h,0C3h,0E8h,04Ch,02h
    db 075h,01h,0C3h,0C7h,047h,018h,06Dh,00h,0C3h,0E8h,040h,02h,075h,01h,0C3h,0C7h
    db 047h,06h,05h,00h,0C7h,047h,018h,06Ah,00h,0C7h,047h,08h,01Eh,01h,083h,07Fh
    db 04h,060h,076h,01h,0C3h,0C7h,047h,06h,03h,00h,0C7h,047h,08h,01Dh,01h,0C3h
    db 0E8h,019h,02h,075h,01h,0C3h,0C7h,047h,06h,07h,00h,0C7h,047h,018h,054h,00h
    db 0C7h,047h,08h,043h,01h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,06h,01h
    db 00h,0C7h,047h,08h,044h,01h,0C3h,0E8h,0C7h,01h,075h,01h,0C3h,0C7h,047h,06h
    db 04h,00h,0C7h,047h,018h,05Eh,00h,0C7h,047h,08h,027h,00h,0C3h,0E8h,0B1h,01h
    db 075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,06Eh,00h,0C3h,0E8h,0A0h
    db 01h,075h,01h
MAIN ends
end