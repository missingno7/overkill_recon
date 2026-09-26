; Link module 2 (boundaries from the original relocation order; see module 1).
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn AimQuadrantBits:word
extrn AllCheatsFlag:byte
extrn BonusKeysEnabled:byte
extrn CheatBonusCheatOn:word
extrn CheatEveryDayIDie:word
extrn CheatGibStMirSchnellfeuer:word
extrn CheatLifeInTheFastLane:word
extrn CheatMyNameIsSmith:word
extrn CheatRemindMe:word
extrn CheatWhatOilShortage:word
extrn CountGate2324:word
extrn DemoActive:word
extrn DemoUpgradeStatus:word
extrn DifficultySetting:word
extrn DirectionFromQuadrant:byte
extrn EncounterEndDelay:word
extrn EncounterLiveCount:word
extrn EncounterTicks:word
extrn ExitOrderScreen:word
extrn FileBufferOffset:word
extrn FileBufferSegment:word
extrn FileNamePtr:word
extrn FileStatus:word
extrn FormationSlotCursor:word
extrn FormationSlots:word
extrn GroupDropKinds:byte
extrn HiscoreBlock:byte
extrn HiscoreFileName:byte
extrn HiscorePageList:word
extrn HistoryRecordSlot15:word
extrn HistoryRecordSlot31:word
extrn IPageList:word
extrn InputBits:byte
extrn InputDeviceMode:word
extrn JitterAxisFields:word
extrn KeepLivesFlag:byte
extrn KeyBitScancodesA:byte
extrn KeyBitScancodesB:byte
extrn KeyDownTable:byte
extrn KeyLastMakeCode:byte
extrn LeaderScript7DEnd:word
extrn LeaderScriptCursor:word
extrn LevelIndex:word
extrn LevelMapCellHandlers:word
extrn LevelScriptClock:word
extrn LevelSkipEnabled:byte
extrn LivesLeft:word
extrn LoadSettingsFromHiscoreBlock:far
extrn MapScrollPos:word
extrn MarchDropNow:byte
extrn MarchEdgeHit:byte
extrn MarchFireNow:byte
extrn MarchStepNow:byte
extrn MarchStepX:word
extrn MinusSlotA968:word
extrn MinusSlotA96C:word
extrn ModuleSoundEnabled:byte
extrn ModuleSoundRequest:byte
extrn OPageList:word
extrn OkMenuPageList:word
extrn PingPongFrames4:word
extrn PingPongFrames8:word
extrn PlusSlotA966:word
extrn PlusSlotA96A:word
extrn PoolA:byte
extrn PoolACursor:word
extrn PoolAEnd:byte
extrn PoolAPointers:word
extrn PoolB:byte
extrn PoolBCursor:word
extrn PoolBEnd:byte
extrn PrimaryRecord:byte
extrn RapidFireEnabled:byte
extrn RedefPageList:word
extrn SavedAllocStrategy:word
extrn SavedUpgradeSlot:word
extrn ScoreBcd:byte
extrn ScrollDeltaY:word
extrn SegBossActive:word
extrn SelectedUpgradeSlot:word
extrn SfxActive:byte
extrn SfxEnabled:byte
extrn SfxRequest:byte
extrn ShowPageList:far
extrn SoundModuleSlot:far
extrn SoundOption:word
extrn SoundOptionFlags:byte
extrn Sprite32Bytes:word
extrn StackTop:word
extrn SteerArrived:word
extrn SteerSpeed:word
extrn SteerTargetX:word
extrn SteerTargetY:word
extrn SweepPath:word
extrn SweepPathLeadIn:word
extrn Type28FrameRamp:byte
extrn Type34SpriteByLevel:word
extrn Type37Speed:word
extrn Type41Path:word
extrn Type43Path:word
extrn Type44Path:word
extrn Type45Path:word
extrn Type4APath:word
extrn Type51Path:word
extrn Type93KilledPulse:byte
extrn UpgradeHitX:word
extrn UpgradeHitY:word
extrn UpgradeSlot0:word
extrn UpgradeSlot1:word
extrn UpgradeSlot2:word
extrn UpgradeSlot3:word
extrn UpgradeSlotPtrs:word
extrn UpgradeTries:word
extrn WhatOilShortageFlag:byte
extrn XorCodeHiscoreBlock:far
extrn loc_1009C:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public AdapterDrawHandlers
public BlitPackedStride104
public BlitPackedStride160
public BlitPackedToScreen
public BlockOffsets
public CheckCheatCodes
public ClearScreen104x200
public CopyWorkspaceToScreen
public DecodeByte5BA0
public DecodeByte5BA1
public DecodeDest
public DecodeFileFlags
public DecodeImageIndex
public DecodePixelBytes
public DecodePlaneBits
public DecodePlaneRowBytes
public DecodeRowBuffer
public DecodeRows
public DrawOffsetFromPlayfieldRow
public DrawOffsetFromScreenRow
public DrawOffsetFromWideRow
public DrawPanelGraphic
public FarCallMainNearViaAX
public FindFreeRecordPoolA
public FindFreeRecordPoolB
public LoadHiscoreFile
public ShutdownGame
public Sprite16Offsets
public Sprite32Offsets
public Sprite8Offsets
public SteerTowardTarget
public TypeHandler13
public TypeHandler24
public TypeHandler25
public TypeHandler26
public TypeHandler27
public TypeHandler28
public TypeHandler29
public TypeHandler2B
public TypeHandler2D
public TypeHandler2E
public TypeHandler2F
public TypeHandler30
public TypeHandler31
public TypeHandler32
public TypeHandler33
public TypeHandler34
public TypeHandler37
public TypeHandler38
public TypeHandler39
public TypeHandler3A
public TypeHandler3B
public TypeHandler3C
public TypeHandler3D
public TypeHandler3E
public TypeHandler3F
public TypeHandler40
public TypeHandler41
public TypeHandler42
public TypeHandler43
public TypeHandler44
public TypeHandler45
public TypeHandler46
public TypeHandler47
public TypeHandler48
public TypeHandler49
public TypeHandler4A
public TypeHandler4B
public TypeHandler4C
public TypeHandler4D
public TypeHandler4E
public TypeHandler4F
public TypeHandler51
public TypeHandler52
public TypeHandler53
public TypeHandler60
public TypeHandler68
public TypeHandler69
public TypeHandler71
public TypeHandler7A
public TypeHandler7B
public TypeHandler7C
public TypeHandler7F
public TypeHandler80
public TypeHandler81
public TypeHandler83
public TypeHandler8A
public TypeHandler8F
public TypeHandler90
public TypeHandler91
public TypeHandler93
public WipeDest
public WipeFlagA
public WipeFlagB
public WipeHeight
public WipeProgress
public WipeSource
public WipeStep
public WipeWidth
public loc_0532D
public loc_054C0
public loc_05559
public loc_057E6
public loc_05800
public loc_05A36
public loc_05A7E
public loc_05A92
public loc_05AC8
public loc_05BAC
public loc_05BEE
public loc_05C04
public loc_05C22
public loc_05C35
public loc_05C9A
public loc_05CB7
public loc_05D0B
public loc_05E1B
public loc_05E42
public loc_05F0D
public loc_05F43
public loc_05F61
public loc_060A2
public loc_060AC
public loc_06176
public loc_061DC
public loc_062AA
public loc_062F6
public loc_07420
public loc_07476
public loc_074E2
public loc_074FE
public loc_07547
public loc_07596
public loc_07746
public loc_077C5
public loc_077DF
public loc_07948
public loc_07977
public loc_07B06
public loc_07BCB
public loc_07C3F
public loc_07CA2
public loc_07DC8
public loc_081E9
public loc_081F4
public loc_08209
public loc_08331
public loc_0837A
public loc_083D7
public loc_083DE
public loc_083E4
public loc_083EA
public loc_083F0
public loc_083F6
public loc_083FC
public loc_08402
public loc_0840A
public loc_08412
public loc_0841A
public loc_08422
public loc_0842A
public loc_08437
public loc_0843D
public loc_08445
public loc_0844E
public loc_08456
public loc_08463
public loc_08468
public loc_0849D
public loc_084A2
public loc_084C3
public loc_084C9
public loc_084D6
public loc_084F0
public loc_084FD
public loc_08517
public loc_08546
public loc_0859E
public loc_0878C
public loc_08D83
public loc_0F953
public loc_0F980
public loc_0F9F9
extrn BlitPackedStride104Cga:near
extrn BlitPackedStride104Ega:near
extrn BlitPackedStride160Cga:near
extrn BlitPackedStride160Ega:near
extrn BlitPackedToScreenCga:near
extrn BlitPackedToScreenEga:near
extrn CalibrateJoystickWithAbort:near
extrn ClearKeyDownTable:near
extrn ClearScreen104x200Cga:near
extrn ClearScreen104x200Ega:near
extrn ClearTandy104x200:near
extrn ClearTandy32K:near
extrn CopyPackedRowsStride104:near
extrn CopyPackedRowsStride160:near
extrn CopyPackedRowsToTandyBanks:near
extrn CopyWorkspace104x192ToTandy:near
extrn CopyWorkspaceToScreenCga:near
extrn CopyWorkspaceToScreenEga:near
extrn CountXReturn:near
extrn DrawOffsetFromPlayfieldRowCga:near
extrn DrawOffsetFromPlayfieldRowEga:near
extrn DrawOffsetFromScreenRowCga:near
extrn DrawOffsetFromScreenRowEga:near
extrn DrawOffsetFromWideRowCga:near
extrn DrawOffsetFromWideRowEga:near
extrn InstallKeyboardVector09:near
extrn LevelMapSegment:word
extrn LevelSpritesSegment:word
extrn LoadFileToBuffer:near
extrn MainDataSegment:word
extrn ManExplSegment:word
extrn MoveInDirection1:near
extrn MoveInDirection2:near
extrn MoveInDirection4:near
extrn MoveInDirection8:near
extrn NextRandomWord:near
extrn PanelImageOffsets:word
extrn PanelSegment:word
extrn PollInputBits:near
extrn PrintMessageBP:near
extrn PrintTextChar:near
extrn ReleaseEmsCache:near
extrn RequestModuleMusic:near
extrn RestoreKeyboardVector09:near
extrn RestoreTimerVector08:near
extrn SaveHiscoreFile:near
extrn ScreenSegment:word
extrn ScrollStartOffset:word
extrn ShowBossKeyScreen:near
extrn SpawnThrottledChild:near
extrn Sprites1x1Segment:word
extrn Sprites2x2CSegment:word
extrn Sprites2x2Segment:word
extrn TandyOffsetFromPlayfieldRow:near
extrn TandyOffsetFromScreenRow:near
extrn TandyOffsetFromWideRow:near
extrn TheEndSegment:word
extrn VideoAdapter:word
extrn WaitVerticalRetrace:near
extrn WorkspaceSegment:word
extrn loc_0103C:near
extrn loc_010B7:near
extrn loc_010ED:near
extrn loc_011B8:near
extrn loc_012B6:near
extrn loc_013E7:near
extrn loc_0154B:near
extrn loc_0167C:near
extrn loc_0177A:near
extrn loc_01845:near
extrn loc_01899:near
extrn loc_018F7:near
extrn loc_0195F:near
extrn loc_019D1:near
extrn loc_01A39:near
extrn loc_01A97:near
extrn loc_01AEB:near
extrn loc_01B2E:near
extrn loc_01B4F:near
extrn loc_01BC6:near
extrn loc_01C61:near
extrn loc_01D1B:near
extrn loc_01DF4:near
extrn loc_01EAE:near
extrn loc_01F49:near
extrn loc_01FC0:near
extrn loc_01FFB:near
extrn loc_0203C:near
extrn loc_02083:near
extrn loc_020D0:near
extrn loc_02117:near
extrn loc_02158:near
extrn loc_02193:near
extrn loc_021D6:near
extrn loc_02223:near
extrn loc_02285:near
extrn loc_022FC:near
extrn loc_0238D:near
extrn loc_02410:near
extrn loc_0247E:near
extrn loc_02580:near
extrn loc_025E9:near
extrn loc_02737:near
extrn loc_027D9:near
extrn loc_02991:near
extrn loc_029C6:near
extrn loc_029E5:near
extrn loc_02A4F:near
extrn loc_02AB9:near
extrn loc_02AF9:near
extrn loc_02B84:near
extrn loc_02D2D:near
extrn loc_02E2D:near
extrn loc_02E6E:near
extrn loc_02ECB:near
extrn loc_02F40:near
extrn loc_02F81:near
extrn loc_02FB6:near
extrn loc_030D2:near
extrn loc_03142:near
extrn loc_033AF:near
extrn loc_034AD:near
extrn loc_034D8:near
extrn loc_03542:near
extrn loc_0356C:near
extrn loc_035CC:near
extrn loc_03657:near
extrn loc_036A2:near
extrn loc_0375B:near
extrn loc_03824:near
extrn loc_03849:near
extrn loc_0387C:near
extrn loc_038B7:near
extrn loc_038D6:near
extrn loc_038F9:near
extrn loc_03926:near
extrn loc_039DF:near
extrn loc_03AEE:near
extrn loc_03C53:near
extrn loc_03CBC:near
extrn loc_03D52:near
extrn loc_03E12:near
extrn loc_03E70:near
extrn loc_03EFB:near
extrn loc_03FB0:near
extrn loc_03FEB:near
extrn loc_0403A:near
extrn loc_0409D:near
extrn loc_040D7:near
extrn loc_0412B:near
extrn loc_041F5:near
extrn loc_04264:near
extrn loc_0446C:near
extrn loc_0450C:near
extrn loc_04684:near
extrn loc_046AA:near
extrn loc_04711:near
extrn loc_04740:near
extrn loc_0480E:near
extrn loc_04896:near
extrn loc_048E6:near
extrn loc_0497A:near
extrn loc_04A41:near
extrn loc_0511F:near
extrn loc_05145:near
extrn loc_09D91:near
extrn loc_09EE4:near
extrn loc_09F1A:near
extrn loc_09F5F:near
extrn loc_0A781:near
extrn loc_0AF22:near
extrn loc_0AFD8:near
extrn loc_0B2AC:near
extrn loc_0B2C8:near
extrn loc_0B729:near
extrn loc_0BAE1:near
extrn loc_0BB03:near
extrn loc_0BC45:near
extrn loc_0BC4B:near
extrn loc_0BD0D:near
extrn loc_0BEC5:near
extrn loc_0BFC7:near
extrn loc_0CB3E:near
extrn loc_0CBE8:near
; Load hiscore.dat: verify the checksum word over the encoded block, copy the block to
; HiscoreBlock, decode it and apply the saved settings. Returns AL=1 on success,
; AL=0 if the file is missing or damaged. The byte count read is not checked.
LoadHiscoreFile:
    mov ax, seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
    mov word ptr ds:[FileNamePtr], offset HiscoreFileName
    call LoadFileToBuffer
    cmp word ptr ds:[FileStatus], FILE_STATUS_OK
    jne loc_0532A
    mov ax, seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH
    mov es, ax
    xor si, si
    mov cx, HISCORE_BLOCK_BYTES
    xor ax, ax
loc_052F7:
    add al, byte ptr es:[si]
    adc ah, 0
    inc si
    loop loc_052F7
    cmp ax, word ptr es:[si]
    jne loc_0532A
    push ds
    push es
    pop ds
    xor si, si
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset HiscoreBlock
    mov cx, HISCORE_BLOCK_BYTES
    rep movsb
    pop ds
    call far ptr XorCodeHiscoreBlock
    call far ptr LoadSettingsFromHiscoreBlock
    mov word ptr cs:[VideoAdapter], bx
    mov al, 1
    ret
loc_0532A:
    xor al, al
    ret

loc_0532D:
    mov byte ptr ds:[02286h], 4
    mov bx, offset HiscoreBlock
    mov cx, 8
loc_05338:
    mov al, byte ptr ds:[bx + 0Ch]
    sub al, byte ptr ss:[bp]
    mov al, byte ptr ds:[bx + 0Dh]
    sbb al, byte ptr ss:[bp + 1]
    mov al, byte ptr ds:[bx + 0Eh]
    sbb al, byte ptr ss:[bp + 2]
    mov al, byte ptr ds:[bx + 0Fh]
    sbb al, byte ptr ss:[bp + 3]
    jb loc_0535D
    add byte ptr ds:[02286h], 2
    add bx, 010h
    loop loc_05338
    ret
loc_0535D:
    mov word ptr ds:[02288h], 1
    mov es, word ptr cs:[MainDataSegment]
    std
    mov si, 02257h
    mov di, 02267h
loc_0536F:
    movsb
    cmp si, bx
    jne loc_0536F
    movsb
    cld
    mov di, bx
    push di
    call loc_05450
    mov ah, 0A8h
    mov al, 0
    mov si, 056h
    call DrawPanelGraphic
    mov dl, 0
    mov dh, byte ptr ds:[02286h]
    mov ah, 2
    mov bh, 0
    int 010h
    mov dx, 0228Ah
    mov ah, DOS_PRINT_STRING
    int 021h
    mov al, byte ptr ds:[02286h]
    mov byte ptr ds:[02296h], al
    mov bp, 02295h
    call PrintMessageBP
    mov bp, offset ScoreBcd
    call loc_05EE4
    mov al, byte ptr ds:[02286h]
    mov byte ptr ds:[022AAh], al
    mov word ptr ds:[022B0h], 0229Bh
    mov es, word ptr cs:[MainDataSegment]
    mov di, 0229Bh
    mov al, 020h
    mov cx, 0Ah
    rep stosb
    mov al, 0
    stosb
loc_053C9:
    mov bp, 022A9h
    call PrintMessageBP
    mov bp, 0229Bh
    call PrintMessageBP
    call loc_05497
    cmp al, 8
    je loc_05408
    cmp al, 0Dh
    je loc_0541E
    cmp word ptr ds:[022B0h], 022A5h
    je loc_053FC
    cmp al, 020h
    jb loc_053C9
    cmp al, 07Ah
    ja loc_053C9
    mov di, word ptr ds:[022B0h]
    mov byte ptr ds:[di], al
    inc word ptr ds:[022B0h]
    jmp short loc_053C9
loc_053FC:
    call loc_05401
    jmp short loc_053C9

loc_05401:
    mov al, 7
    mov ah, 0Eh
    int 010h
    ret
loc_05408:
    cmp word ptr ds:[022B0h], 0229Bh
    je loc_053FC
    dec word ptr ds:[022B0h]
    mov di, word ptr ds:[022B0h]
    mov al, 020h
    mov byte ptr ds:[di], al
    jmp short loc_053C9
loc_0541E:
    cmp word ptr ds:[022B0h], 022A5h
    je loc_05433
    mov di, word ptr ds:[022B0h]
    mov byte ptr ds:[di], 020h
    inc word ptr ds:[022B0h]
    jmp short loc_0541E
loc_05433:
    pop di
    mov es, word ptr cs:[MainDataSegment]
    mov si, 0229Bh
    mov cx, 0Ah
    rep movsb
    inc di
    inc di
    mov ax, word ptr ds:[ScoreBcd]
    stosw
    mov ax, word ptr ds:[ScoreBcd + 2]
    stosw
    call ClearKeyDownTable
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_05450:
    mov ax, offset HiscorePageList
    call far ptr ShowPageList
    mov byte ptr cs:[0544Fh], 0
    mov cx, 8
loc_05461:
    push cx
    mov al, byte ptr cs:[0544Fh]
    shl al, 1
    add al, 4
    mov byte ptr ds:[021D3h], al
    mov bp, 021D2h
    call PrintMessageBP
    mov al, byte ptr cs:[0544Fh]
    xor ah, ah
    mov cx, 010h
    mul cx
    mov bp, offset HiscoreBlock
    add bp, ax
    push bp
    call PrintMessageBP
    pop bp
    lea bp, ss:[bp + 0Ch]
    call loc_05EE4
    pop cx
    inc byte ptr cs:[0544Fh]
    loop loc_05461
    ret

loc_05497:
    mov ds, word ptr cs:[MainDataSegment]
    call RestoreKeyboardVector09
    mov word ptr ds:[022B2h], 0
    mov ah, DOS_CHAR_INPUT_NO_ECHO
    int 021h
    cmp al, 0
    je loc_054AF
    jmp short loc_054B7
loc_054AF:
    int 021h
    mov word ptr ds:[022B2h], 1
loc_054B7:
    mov byte ptr ds:[022B4h], al
    push ax
    call InstallKeyboardVector09
    pop ax
    ret

loc_054C0:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_054CE
    mov byte ptr ds:[02299h], 0Ah
    ret
loc_054CE:
    mov byte ptr ds:[02299h], 3
    ret

loc_054D4:
    mov ah, 041h
    mov al, 9
    mov si, 040h
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    call DrawPanelGraphicNextIfEqual
    mov ah, 057h
    mov al, 9
    mov si, 042h
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    call DrawPanelGraphicNextIfEqual
    mov ah, 040h
    mov al, 013h
    mov si, 044h
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ah
    mov al, 9
    mov si, 046h
    cmp word ptr ds:[SoundOption], 0
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ah
    mov al, 010h
    mov si, 048h
    cmp word ptr ds:[SoundOption], 1
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ah
    mov al, 014h
    mov si, 04Ah
    cmp word ptr ds:[SoundOption], 2
    call DrawPanelGraphicNextIfEqual
    mov ah, 07Ch
    mov al, 019h
    mov si, 04Ch
    cmp word ptr ds:[SoundOption], 3

; Flag-driven entry: with ZF set, draw graphic SI+1 (the highlighted variant) instead.
DrawPanelGraphicNextIfEqual:
    jne DrawPanelGraphic
    inc si

; Draw PANEL.ENC graphic SI at row AH, 8-pixel column AL.
DrawPanelGraphic:
    push si
    call DrawOffsetFromScreenRow
    pop si
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_05559:
    mov word ptr ds:[022B7h], 0
loc_0555F:
    cmp word ptr ds:[022B7h], 0
    jne loc_05576
    call far ptr WaitAllKeysReleased
    mov ax, offset OkMenuPageList
    call far ptr ShowPageList
    call loc_054D4
loc_05576:
    cmp word ptr ds:[022B7h], 0
    je loc_05582
    call loc_05450
    jmp short loc_05585
loc_05582:
    call loc_054D4
loc_05585:
    mov word ptr ds:[022BFh], 0
loc_0558B:
    cmp byte ptr ds:[KeyDownTable + SCAN_K], KEY_STATE_DOWN
    jne loc_05595
    jmp near ptr loc_0563D
loc_05595:
    cmp byte ptr ds:[KeyDownTable + SCAN_J], KEY_STATE_DOWN
    jne loc_0559F
    jmp near ptr loc_05669
loc_0559F:
    cmp byte ptr ds:[KeyDownTable + SCAN_A], KEY_STATE_DOWN
    jne loc_055A9
    jmp near ptr loc_056B2
loc_055A9:
    cmp byte ptr ds:[KeyDownTable + SCAN_R], KEY_STATE_DOWN
    jne loc_055B3
    jmp near ptr loc_05732
loc_055B3:
    cmp byte ptr ds:[KeyDownTable + SCAN_M], KEY_STATE_DOWN
    jne loc_055BD
    jmp near ptr loc_056E1
loc_055BD:
    cmp byte ptr ds:[KeyDownTable + SCAN_O], KEY_STATE_DOWN
    je loc_05621
    cmp byte ptr ds:[KeyDownTable + SCAN_I], KEY_STATE_DOWN
    je loc_0562C
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne loc_055D5
    jmp near ptr ShutdownGame
loc_055D5:
    cmp byte ptr ds:[KeyDownTable + SCAN_F9], KEY_STATE_DOWN
    je loc_05637
    mov word ptr ds:[022B9h], 0
    mov word ptr ds:[022BBh], 0
    mov word ptr ds:[022BDh], 0
loc_055EE:
    call WaitVerticalRetrace
    inc word ptr ds:[022BFh]
    cmp word ptr ds:[022BFh], 02EEh
    jb loc_05613
    cmp word ptr ds:[022B7h], 0
    je loc_0560A
    call loc_0CBE8
    jmp near ptr loc_05559
loc_0560A:
    mov word ptr ds:[022B7h], 1
    jmp near ptr loc_0555F
loc_05613:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_05620
    jmp near ptr loc_0558B
loc_05620:
    ret
loc_05621:
    mov ax, offset OPageList
    call far ptr ShowPageList
    jmp near ptr loc_05559
loc_0562C:
    mov ax, offset IPageList
    call far ptr ShowPageList
    jmp near ptr loc_05559
loc_05637:
    call ShowBossKeyScreen
    jmp near ptr loc_05559
loc_0563D:
    cmp word ptr ds:[022B9h], 1
    je loc_055EE
    mov word ptr ds:[022B9h], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05656
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05656:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    cmp word ptr ds:[022B7h], 0
    jne loc_05666
    jmp near ptr loc_05576
loc_05666:
    jmp near ptr loc_05559
loc_05669:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05675
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05675:
    cmp byte ptr ds:[KeyDownTable + SCAN_J], KEY_STATE_DOWN
    je loc_05675
    call loc_0CB3E
    call CalibrateJoystickWithAbort
    mov al, byte ptr ds:[ModuleSoundRequest]
    call RequestModuleMusic
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne loc_056A5
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0569B
    mov byte ptr ds:[SfxRequest], 01Ch
loc_0569B:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je loc_0569B
    jmp near ptr loc_05559
loc_056A5:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_056A5
    jmp near ptr loc_05559
loc_056B2:
    cmp word ptr ds:[022BBh], 1
    jne loc_056BC
    jmp near ptr loc_055EE
loc_056BC:
    mov word ptr ds:[022BBh], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_056CE
    mov byte ptr ds:[SfxRequest], 01Ch
loc_056CE:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    cmp word ptr ds:[022B7h], 0
    jne loc_056DE
    jmp near ptr loc_05576
loc_056DE:
    jmp near ptr loc_05559
loc_056E1:
    cmp word ptr ds:[022BDh], 1
    jne loc_056EB
    jmp near ptr loc_055EE
loc_056EB:
    mov word ptr ds:[022BDh], 1
    inc word ptr ds:[SoundOption]
    and word ptr ds:[SoundOption], 3
    mov bx, word ptr ds:[SoundOption]
    shl bx, 1
    mov bx, word ptr ds:[bx + SoundOptionFlags]
    mov byte ptr ds:[SfxEnabled], bh
    mov byte ptr ds:[ModuleSoundEnabled], bl
    cmp bl, 0
    jne loc_05714
    call loc_0CB3E
loc_05714:
    mov al, 2
    call RequestModuleMusic
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05725
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05725:
    cmp word ptr ds:[022B7h], 0
    jne loc_0572F
    jmp near ptr loc_05576
loc_0572F:
    jmp near ptr loc_05559
loc_05732:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0573E
    mov byte ptr ds:[SfxRequest], 01Ch
loc_0573E:
    cmp byte ptr ds:[KeyDownTable + SCAN_R], KEY_STATE_DOWN
    je loc_0573E
    mov ax, offset RedefPageList
    call far ptr ShowPageList
    mov byte ptr ds:[022CAh], 03Fh
    mov si, 050h
    mov di, offset KeyBitScancodesA + KEY_SLOT_YMINUS
    call PromptAndCaptureKeyBinding
    mov si, 051h
    mov di, offset KeyBitScancodesA + KEY_SLOT_YPLUS
    call PromptAndCaptureKeyBinding
    mov si, 052h
    mov di, offset KeyBitScancodesA + KEY_SLOT_XMINUS
    call PromptAndCaptureKeyBinding
    mov si, 053h
    mov di, offset KeyBitScancodesA + KEY_SLOT_XPLUS
    call PromptAndCaptureKeyBinding
    mov si, 054h
    mov di, offset KeyBitScancodesA + KEY_SLOT_PRIMARY
    call PromptAndCaptureKeyBinding
    mov si, 055h
    mov di, offset KeyBitScancodesA + KEY_SLOT_SECONDARY
    call PromptAndCaptureKeyBinding
    mov al, byte ptr ds:[KeyBitScancodesA + KEY_SLOT_SECONDARY]
    mov byte ptr ds:[KeyBitScancodesB + KEY_SLOT_SECONDARY], al
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    jmp near ptr loc_05559

; Show prompt graphic SI, wait for a key other than Esc/F9/F10, store its scancode at DI
; and wait for its release.
PromptAndCaptureKeyBinding:
    push di
    mov byte ptr ds:[KeyLastMakeCode], 0
    mov ah, byte ptr ds:[022CAh]
    add byte ptr ds:[022CAh], 017h
    mov al, 1
    call DrawPanelGraphic
loc_057AB:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_057AB
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_F9
    je loc_057AB
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_F10
    je loc_057AB
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_ESC
    je loc_057AB
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_057D3
    mov byte ptr ds:[SfxRequest], 01Ch
loc_057D3:
    mov bl, byte ptr ds:[KeyLastMakeCode]
    xor bh, bh
    pop di
    mov byte ptr ds:[di], bl
    add bx, offset KeyDownTable
loc_057E0:
    cmp byte ptr ds:[bx], 0
    jne loc_057E0
    ret

loc_057E6:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_057F4
loc_057ED:
    cmp byte ptr ds:[SfxActive], 0
    jne loc_057ED
loc_057F4:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05800
    mov byte ptr ds:[SfxRequest], 5

loc_05800:
    call loc_0580B
    mov ds, word ptr cs:[MainDataSegment]
    jmp near ptr loc_05BEE

loc_0580B:
    xor si, si
    mov ds, word ptr cs:[ScreenSegment]
    mov es, word ptr cs:[WorkspaceSegment]
    xor di, di
    mov ax, 0C8h
    stosw
    mov ax, 028h
    stosw
    mov dx, 03CEh
    mov cx, 0C8h
loc_05827:
    push cx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05827Cases]
loc_05827Cases label word
    dw loc_0583A, loc_05852, loc_0587E    ; per VideoAdapter: CGA, EGA, Tandy

loc_0583A:
    mov cx, 050h
    rep movsb
    sub si, 050h
    add si, 02000h
    test si, 04000h
    je loc_05850
    add si, 0C050h
loc_05850:
    jmp short loc_05895

loc_05852:
    mov ax, 4
    out dx, ax
    mov cx, 028h
    rep movsb
    sub si, 028h
    inc ah
    out dx, ax
    mov cx, 028h
    rep movsb
    sub si, 028h
    inc ah
    out dx, ax
    mov cx, 028h
    rep movsb
    sub si, 028h
    inc ah
    out dx, ax
    mov cx, 028h
    rep movsb
    jmp short loc_05895

loc_0587E:
    mov cx, 050h
    rep movsw
    sub si, 0A0h
    add si, 02000h
    test si, 08000h
    je loc_05895
    add si, 080A0h
loc_05895:
    pop cx
    loop loc_05827
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_058A4
    mov ax, 4
    out dx, ax
loc_058A4:
    mov ds, word ptr cs:[WorkspaceSegment]
    xor di, di
    xor si, si
    mov cx, 1
    lodsw
    mov word ptr cs:[WipeWidth], ax
    lodsw
    mov word ptr cs:[WipeHeight], ax
    mov word ptr cs:[WipeSource], si
    mov word ptr cs:[WipeDest], di
    mov word ptr cs:[WipeFlagA], 0
    mov word ptr cs:[WipeFlagB], 0
    mov es, word ptr cs:[ScreenSegment]
    mov cx, word ptr cs:[WipeWidth]
    sub cx, 2
loc_058DF:
    push cx
    mov word ptr cs:[WipeStep], cx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop loc_058DF
    ret
; State of the progressive packed-image drawers (loc_058DF and the adapter variants):
; destination, source, width and height from the image header, step, progress, two
; alternating flags, and a word used only by the uncalled variant below.
WipeDest dw 0
WipeSource dw 0
WipeWidth dw 0
WipeHeight dw 0
WipeStep dw 0
WipeProgress dw 0
WipeFlagA dw 0
WipeFlagB dw 0
WipeWord5909 dw 0
; Uncalled variant of the progressive drawer.
loc_0590B:
loc_0590B:
    mov byte ptr ss:[KeyLastMakeCode], 0
    lodsw
    mov cs:[WipeWidth], ax
    lodsw
    mov cs:[WipeHeight], ax
    mov cs:[WipeSource], si
    mov cs:[WipeDest], di
    mov word ptr cs:[WipeFlagA], 0
    mov word ptr cs:[WipeFlagB], 0
    mov word ptr cs:[WipeWord5909], 0
    mov es, cs:[ScreenSegment]
loc_0593F:
    push cx
    call loc_05960
    jne loc_05953
    call loc_05960
    jne loc_05953
    pop cx
    loop loc_0593F
    mov ds, cs:[MainDataSegment]
    ret
loc_05953:
    pop cx
    mov ds, cs:[MainDataSegment]
    ret
; Per VideoAdapter: CGA, EGA and Tandy versions of the same draw routine.
AdapterDrawHandlers label word
    dw offset loc_0497A, offset loc_02D2D, offset loc_0375B
loc_05960:
    mov cx, cs:[WipeWidth]
    sub cx, 2
loc_05968:
    push cx
    mov cs:[WipeStep], cx
    mov bx, cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + 595Ah]
    push ds
    mov ds, cs:[MainDataSegment]
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_059E7
    call PollInputBits
    cmp byte ptr ds:[InputBits], 10h
    je loc_059E7
    pop ds
    call WaitVerticalRetrace
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop loc_05968
    xor word ptr cs:[WipeFlagA], 1
    xor word ptr cs:[WipeFlagB], 1
    mov cx, cs:[WipeWidth]
    sub cx, 2
    add word ptr cs:[WipeStep], 2
loc_059B6:
    push cx
    add word ptr cs:[WipeStep], 2
    mov bx, cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + 595Ah]
    push ds
    mov ds, cs:[MainDataSegment]
    call PollInputBits
    cmp byte ptr ds:[InputBits], 10h
    je loc_059E7
    pop ds
    call WaitVerticalRetrace
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop loc_059B6
    xor ax, ax
    ret
loc_059E7:
    pop ds
    pop cx
    xor ax, ax
    inc ax
    ret
; Per-adapter dispatch; no caller found in this image.
loc_059ED:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_059EDCases]
; NOP filler: word-aligns the table.
    db 90h
loc_059EDCases label word
    dw offset loc_04264, offset loc_025E9, offset loc_03142

; Per-adapter screen offset for row AH and 8-pixel column AL (ScreenRowOffsets on Tandy).
DrawOffsetFromScreenRow:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + DrawOffsetFromScreenRowCases]
DrawOffsetFromScreenRowCases label word
    dw DrawOffsetFromScreenRowCga, DrawOffsetFromScreenRowEga, TandyOffsetFromScreenRow    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter screen offset for row AH and 8-pixel column AL (PlayfieldRowOffsets on Tandy).
DrawOffsetFromPlayfieldRow:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + DrawOffsetFromPlayfieldRowCases]
DrawOffsetFromPlayfieldRowCases label word
    dw DrawOffsetFromPlayfieldRowCga, DrawOffsetFromPlayfieldRowEga, TandyOffsetFromPlayfieldRow    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter screen offset for row AH and 8-pixel column AL (WideRowOffsets on Tandy).
DrawOffsetFromWideRow:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + DrawOffsetFromWideRowCases]
DrawOffsetFromWideRowCases label word
    dw DrawOffsetFromWideRowCga, DrawOffsetFromWideRowEga, TandyOffsetFromWideRow    ; per VideoAdapter: CGA, EGA, Tandy
loc_05A36:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05A36Cases]
loc_05A36Cases label word
    dw loc_041F5, loc_02580, loc_030D2    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter copy of a packed image into the 104-byte-wide workspace.
BlitPackedStride104:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + BlitPackedStride104Cases]
BlitPackedStride104Cases label word
    dw BlitPackedStride104Cga, BlitPackedStride104Ega, CopyPackedRowsStride104    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter copy of a packed image into a 160-byte-wide buffer.
BlitPackedStride160:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + BlitPackedStride160Cases]
BlitPackedStride160Cases label word
    dw BlitPackedStride160Cga, BlitPackedStride160Ega, CopyPackedRowsStride160    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter draw of the packed image at DS:SI to the screen at DI.
BlitPackedToScreen:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + BlitPackedToScreenCases]
BlitPackedToScreenCases label word
    dw BlitPackedToScreenCga, BlitPackedToScreenEga, CopyPackedRowsToTandyBanks    ; per VideoAdapter: CGA, EGA, Tandy
loc_05A7E:
    mov dx, bx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05A7ECases]
loc_05A7ECases label word
    dw loc_048E6, loc_02B84, loc_036A2    ; per VideoAdapter: CGA, EGA, Tandy

loc_05A92:
    mov es, word ptr cs:[WorkspaceSegment]
    mov di, word ptr ss:[bp + REC_SCREEN_OFS]
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05A92Cases]
; Indexed by VideoAdapter*3 + REC_SIZE_CLASS (CGA, EGA, Tandy; sizes 0..2).
loc_05A92Cases label word
    dw offset loc_04711, offset loc_046AA, offset loc_04684
    dw offset loc_029E5, offset loc_029C6, offset loc_02991
    dw offset loc_03542, offset loc_034D8, offset loc_034AD

loc_05AC8:
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05AC8Cases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_05AC8Cases label word
    dw offset loc_04896, offset loc_0480E, offset loc_04740, offset loc_02AF9
    dw offset loc_02AB9, offset loc_02A4F, offset loc_03657, offset loc_035CC
    dw offset loc_0356C
; Graphics decoder (LoadGraphicsFile): one 4-plane row (4 * 28h bytes), per-pixel
; plane bytes, the image header (rows, bytes per plane row) and progress state.
DecodeRowBuffer db 0A0h dup (0)
DecodePixelBytes db 8 dup (0)
DecodePlaneRowBytes dw 0
DecodeRows dw 0
DecodeByte5BA0 db 0
DecodeByte5BA1 db 0
DecodePlaneBits db 4 dup (0)
DecodeDest dw 0
; Images decoded so far in this file; index into the per-file flag table.
DecodeImageIndex dw 0
; Per-file flag bytes (the word before the file name when CS:C5B0 = 1, else FFFFh).
DecodeFileFlags dw 0
loc_05BAC:
    mov word ptr cs:[DecodeFileFlags], bp
    mov word ptr cs:[DecodeImageIndex], 0FFFFh
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05BACCases]
loc_05BACCases label word
    dw loc_0450C, loc_027D9, loc_033AF    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter clear of the 104-byte-wide play area.
ClearScreen104x200:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + ClearScreen104x200Cases]
ClearScreen104x200Cases label word
    dw ClearScreen104x200Cga, ClearScreen104x200Ega, ClearTandy104x200    ; per VideoAdapter: CGA, EGA, Tandy

; Per-adapter copy of the workspace to the screen.
CopyWorkspaceToScreen:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + CopyWorkspaceToScreenCases]
CopyWorkspaceToScreenCases label word
    dw CopyWorkspaceToScreenCga, CopyWorkspaceToScreenEga, CopyWorkspace104x192ToTandy    ; per VideoAdapter: CGA, EGA, Tandy

loc_05BEE:
    call loc_05145
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05BEECases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_05BEECases label word
    dw offset loc_0446C, offset loc_02737, offset ClearTandy32K

loc_05C04:
    xor di, di
    xor si, si
    mov bp, 0C8h
    mov es, word ptr cs:[ScreenSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_05C04Cases]
loc_05C04Cases label word
    dw loc_04A41, loc_02E2D, loc_03824    ; per VideoAdapter: CGA, EGA, Tandy

loc_05C22:
    call loc_05BEE
    xor di, di
    xor si, si
    mov ax, word ptr cs:[WorkspaceSegment]
    add ax, 07D0h
    inc ax
    mov ds, ax
    jmp short loc_05C46

loc_05C35:
    call loc_05BEE
    mov ah, 04Eh
    xor al, al
    call DrawOffsetFromScreenRow
    xor si, si
    mov ds, word ptr cs:[TheEndSegment]

loc_05C46:
    lodsw
    mov word ptr cs:[WipeWidth], ax
    lodsw
    mov word ptr cs:[WipeHeight], ax
    mov word ptr cs:[WipeSource], si
    mov word ptr cs:[WipeDest], di
    mov word ptr cs:[WipeFlagA], 0
    mov word ptr cs:[WipeFlagB], 0
    mov word ptr cs:[WipeStep], 6
    mov es, word ptr cs:[ScreenSegment]
loc_05C74:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    call WaitVerticalRetrace
    add word ptr cs:[WipeStep], 2
    mov ax, word ptr cs:[WipeStep]
    cmp ax, word ptr cs:[WipeWidth]
    jne loc_05C74
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_05C9A:
    call loc_05BEE
    mov ax, 01Bh
    call DrawOffsetFromScreenRow
    mov si, 025h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call loc_05C46

loc_05CB7:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_05CC0
    ret
loc_05CC0:
    push ds
    mov ax, 0105h
    mov dx, 03CEh
    out dx, ax
    xor si, si
    mov di, 02000h
    mov es, word ptr cs:[ScreenSegment]
    push es
    pop ds
    mov cx, 01F40h
    rep movsb
    mov ax, 5
    mov dx, 03CEh
    out dx, ax
    pop ds
    ret
; UNKNOWN: not yet classified as code or data
    db 052h,086h,0F2h,0E8h,01h,00h,05Ah,052h,0D0h,0EAh,0D0h,0EAh,0D0h,0EAh,0D0h,0EAh
    db 0E8h,01h,00h,05Ah,080h,0E2h,0Fh,080h,0FAh,0Ah,072h,03h,080h,0C2h,07h,080h
    db 0C2h,030h,08Ah,0C2h,0B4h,0Eh,0CDh,010h,0C3h
loc_05D0B:
    mov ds, word ptr cs:[MainDataSegment]
    inc byte ptr ds:[022CFh]
; Common exit: silence the speaker, save hiscore.dat, stop sound, restore the keyboard
; vector, return to text mode and exit to DOS. If DS:22CF is nonzero an error message
; naming FileNamePtr is printed first.
ShutdownGame:
    mov ds, word ptr cs:[MainDataSegment]
    sti
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    push word ptr ds:[FileNamePtr]
    call SaveHiscoreFile
    pop word ptr ds:[FileNamePtr]
    call loc_05145
    call loc_0CB3E
    call RestoreKeyboardVector09
    call RestoreTimerVector08
    mov ax, 3
    int 010h
    cmp byte ptr ds:[022CFh], 0
    je loc_05D7E
    mov dx, 022D0h
    mov ah, DOS_PRINT_STRING
    int 021h
    mov si, word ptr ds:[FileNamePtr]
loc_05D4E:
    lodsb
    or al, al
    jne loc_05D4E
    mov byte ptr ds:[si - 1], 024h
    mov dx, word ptr ds:[FileNamePtr]
    mov si, dx
    cmp byte ptr ds:[si + 1], 03Ah
    jne loc_05D66
    add dx, 2
loc_05D66:
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, 022EDh
    mov ah, DOS_PRINT_STRING
    int 021h
    call ReleaseEmsCache
    call far ptr loc_0F99D
    mov ax, 04C00h
    int 021h
loc_05D7E:
    mov dl, 0
    mov dh, 016h
    mov ah, 2
    mov bh, 0
    int 010h
    mov ax, 0B800h
    mov es, ax
    xor di, di
    mov si, offset ExitOrderScreen
    mov cx, 07D0h
    rep movsw
    cli
    xor ax, ax
    mov es, ax
    mov al, byte ptr es:[041Ah]
    mov byte ptr es:[041Ch], al
    sti
    call ReleaseEmsCache
    call far ptr loc_0F99D
    mov ax, 04C00h
    int 021h

; BP = record: point REC_DIRECTION at (SteerTargetX, SteerTargetY) and step that way by
; SteerSpeed; exactly on target: direction kept, SteerArrived = 1, no step.
SteerTowardTarget:
    mov word ptr ds:[AimQuadrantBits], 0
    mov word ptr ds:[SteerArrived], 0
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ds:[SteerTargetX]
    jb loc_05DCB
    ja loc_05DD3
    jmp short loc_05DD9
loc_05DCB:
    mov word ptr ds:[AimQuadrantBits], 1
    jmp short loc_05DD9
loc_05DD3:
    mov word ptr ds:[AimQuadrantBits], 2
loc_05DD9:
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ds:[SteerTargetY]
    jl loc_05DE6
    jg loc_05DED
    jmp short loc_05DF2
loc_05DE6:
    or word ptr ds:[AimQuadrantBits], 4
    jmp short loc_05DF2
loc_05DED:
    or word ptr ds:[AimQuadrantBits], 8
loc_05DF2:
    mov bx, offset DirectionFromQuadrant
    mov ax, word ptr ds:[AimQuadrantBits]
    xlat
    cmp al, 0FFh
    je loc_05E14
    mov word ptr ss:[bp + REC_DIRECTION], ax
    mov bx, word ptr ds:[SteerSpeed]
    shl bx, 1
    jmp word ptr cs:[bx + StepBySteerSpeed]
; UNKNOWN: not yet classified as code or data
    db 090h
StepBySteerSpeed label word
    dw offset MoveInDirection1, offset MoveInDirection2, offset MoveInDirection4, offset MoveInDirection8
loc_05E14:
    mov word ptr ds:[SteerArrived], 1
    ret
loc_05E1B:
    mov dx, 4
    cmp word ptr ds:[bx + 14h], 1
    je loc_05E27
    mov dx, 0Ch
loc_05E27:
    mov ax, ss:[bp + REC_X]
    mov cx, ds:[bx + 4]
    add cx, dx
    sub ax, cx
    mov ss:[bp + REC_DELTA_X], ax
    mov ax, ss:[bp + REC_Y]
    mov cx, ds:[bx + 2]
    add cx, dx
    sub ax, cx
    mov ss:[bp + REC_DELTA_Y], ax
    ret
loc_05E42:
    mov word ptr ds:[0230Ch], 0
    mov word ptr ds:[0230Eh], 0
    mov word ptr ds:[02310h], 0
    mov ax, word ptr ss:[bp + REC_DELTA_X]
    or ax, ax
    jns loc_05E61
    neg ax
    inc word ptr ds:[0230Ch]
loc_05E61:
    mov bx, word ptr ss:[bp + REC_DELTA_Y]
    or bx, bx
    jns loc_05E6E
    neg bx
    inc word ptr ds:[0230Eh]
loc_05E6E:
    cmp ax, bx
    je loc_05E93
    ja loc_05E81
    add word ptr ss:[bp + REC_STEP_ERROR], ax
    cmp word ptr ss:[bp + REC_STEP_ERROR], bx
    jbe loc_05E96
    sub word ptr ss:[bp + REC_STEP_ERROR], bx
    jmp short loc_05E93
loc_05E81:
    add word ptr ss:[bp + REC_STEP_ERROR], bx
    cmp word ptr ss:[bp + REC_STEP_ERROR], ax
    jbe loc_05E8E
    sub word ptr ss:[bp + REC_STEP_ERROR], ax
    jmp short loc_05E93
loc_05E8E:
    call loc_05EB5
    jmp short loc_05E99
loc_05E93:
    call loc_05EB5
loc_05E96:
    call loc_05EC8
loc_05E99:
    mov bx, offset DirectionFromQuadrant
    mov ax, word ptr ds:[02310h]
    xlat
    cmp al, 0FFh
    jne loc_05EA5
    ret
loc_05EA5:
    mov word ptr ss:[bp + REC_DIRECTION], ax
    cmp word ptr ds:[02312h], 3
    jne loc_05EB2
    jmp near ptr loc_0AF22
loc_05EB2:
    jmp near ptr MoveInDirection2
loc_05EB5:
    cmp word ptr ds:[0230Ch], 1
    je loc_05EC2
    or word ptr ds:[02310h], 2
    ret
loc_05EC2:
    or word ptr ds:[02310h], 1
    ret
loc_05EC8:
    cmp word ptr ds:[0230Eh], 1
    je loc_05ED5
    or word ptr ds:[02310h], 8
    ret
loc_05ED5:
    or word ptr ds:[02310h], 4
    ret

loc_05EDB:
    mov bp, 02318h
    call PrintMessageBP
    mov bp, offset ScoreBcd

loc_05EE4:
    mov al, byte ptr ss:[bp + 3]
    call loc_05EF9
    mov al, byte ptr ss:[bp + 2]
    call loc_05EF9
    mov al, byte ptr ss:[bp + 1]
    call loc_05EF9
    mov al, byte ptr ss:[bp]

loc_05EF9:
    push ax
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    call loc_05F06
    pop ax

loc_05F06:
    and al, 0Fh
    add al, 030h
    jmp near ptr PrintTextChar

loc_05F0D:
    push bp
    push ax
    push dx
    mov bp, offset ScoreBcd
    mov al, byte ptr ss:[bp]
    add al, bl
    daa
    mov byte ptr ss:[bp], al
    inc bp
    mov al, byte ptr ss:[bp]
    mov dh, al
    adc al, bh
    daa
    mov byte ptr ss:[bp], al
    mov dl, al
    inc bp
    mov al, byte ptr ss:[bp]
    adc al, 0
    daa
    mov byte ptr ss:[bp], al
    inc bp
    mov al, byte ptr ss:[bp]
    adc al, 0
    daa
    mov byte ptr ss:[bp], al
    inc bp
    pop dx
    pop ax
    pop bp
    ret

loc_05F43:
    mov al, 4
    cmp word ptr ds:[MapScrollPos], 09Ch
    je loc_05F5E
    mov al, 5
    cmp word ptr ds:[MapScrollPos], 0EA0h
    je loc_05F5E
    mov bx, 0231Eh
    mov al, byte ptr ds:[LevelIndex]
    xlat
loc_05F5E:
    jmp near ptr RequestModuleMusic


; Modern record/state symbols.
loc_05F61:
    cmp word ptr ds:[EncounterLiveCount], 0
    jne loc_05F89
    cmp word ptr ds:[EncounterEndDelay], 0
    je loc_05F89
    dec word ptr ds:[EncounterEndDelay]
    jne loc_05F89
    mov bx, 0231Eh
    mov al, byte ptr ds:[LevelIndex]
    xlat
    cmp word ptr ds:[MapScrollPos], 0750h
    jb loc_05F86
    mov al, 6
loc_05F86:
    call RequestModuleMusic
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
    inc word ptr ds:[EncounterTicks]
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
    cmp word ptr ds:[DifficultySetting], 1
    jbe loc_0607D
    cmp word ptr ds:[0232Eh], 03Fh
    jmp short loc_06082
loc_0607D:
    cmp word ptr ds:[02330h], 07Fh
loc_06082:
    jne loc_06087
    call loc_09EE4
loc_06087:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 2
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
    mov ax, word ptr cs:[ScrollStartOffset]
    mov word ptr ds:[0234Ch], ax
    mov word ptr ds:[0234Eh], 0
    mov word ptr ds:[02352h], 0
    mov word ptr ds:[LevelScriptClock], 0
    mov word ptr ds:[MapScrollPos], 0EA0h
loc_060CB:
    mov cx, 010h
loc_060CE:
    push cx
    call loc_0A781
    pop cx
    loop loc_060CE
    cmp word ptr ds:[MapScrollPos], 09Ch
    jne loc_060CB
    sub word ptr ds:[LevelScriptClock], 3
    ret

loc_060E3:
    mov bp, 0235Ch
    call PrintMessageBP
    mov bx, 02362h
    mov ax, word ptr ds:[LevelIndex]
    xlat
    jmp near ptr PrintTextChar

loc_060F3:
    mov al, 01Fh
    mov ah, 050h
    call DrawOffsetFromScreenRow
    mov si, 01Eh
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov cx, word ptr ds:[LivesLeft]
    call loc_06120
    mov si, 01Fh
    shl si, 1
    add si, offset PanelImageOffsets
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
    jmp word ptr cs:[bx + loc_0613ECases]
loc_0613ECases label word
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
    jmp word ptr cs:[bx + loc_0615ACases]
loc_0615ACases label word
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
    call DrawOffsetFromScreenRow
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
    call DrawOffsetFromScreenRow
    mov si, 0
    cmp word ptr ds:[0A95Ah], -1
    je loc_0625B
    mov si, word ptr ds:[0A95Ah]
loc_0625B:
    add si, 020h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov al, 021h
    mov ah, 018h
    call DrawOffsetFromScreenRow
    mov si, 01Eh
    shl si, 1
    add si, offset PanelImageOffsets
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
    add si, offset PanelImageOffsets
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
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
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
    mov bx, offset PoolB
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
    add ax, word ptr ds:[ScrollDeltaY]
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[02376h]
    cmp ax, 0C0h
    jbe loc_07442
    mov ax, 0C0h
loc_07442:
    mov word ptr ds:[bx + REC_X], ax
loc_07445:
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
    cmp word ptr ds:[SegBossActive], 1
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
    mov cx, word ptr ds:[PrimaryRecord + REC_X]
    add cx, 9
    sub ax, cx
    mov word ptr ds:[bx + 02Ch], ax
    mov ax, word ptr ds:[bx + REC_Y]
    mov cx, word ptr ds:[PrimaryRecord + REC_Y]
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
    mov bx, offset PoolA
loc_0750D:
    cmp word ptr ds:[bx + REC_KIND], 6
    je loc_07519
    cmp word ptr ds:[bx + REC_KIND], 1
    jne loc_07521
loc_07519:
    add bx, RECORD_SIZE
    loop loc_0750D
    mov bx, offset PoolA
loc_07521:
    jmp near ptr loc_0BD0D

; Near leaf. DS:95D8 supplies the first candidate. Inspect at most35 status words at stride38h in23B4..2B5B,
; wrapping BX after increment equals2B5C. Return BX=first zero-status record, CX=35-skipped; save BX to DS:95D8
; without activating record. Full pool returns BX=FFFF,CX=0 and leaves cursor unchanged. Requires aligned in-
; pool cursor; unlike poolB, end cursor is not normalized before first read. AX,DX,SI,DI,BP,segments preserved;
; flags changed.
FindFreeRecordPoolA:
    mov cx, POOL_A_COUNT
    mov bx, word ptr ds:[PoolACursor]
loc_0752B:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_07542
    add bx, RECORD_SIZE
    cmp bx, offset PoolAEnd
    jne loc_0753C
    mov bx, offset PoolA
loc_0753C:
    loop loc_0752B
    mov bx, 0FFFFh
    ret
loc_07542:
    mov word ptr ds:[PoolACursor], bx
    ret

loc_07547:
    call FindFreeRecordPoolB
    cmp bx, -1
    je loc_07550
    ret
loc_07550:
    mov cx, POOL_B_COUNT
    mov bx, offset PoolB
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
    mov bx, offset PoolB
loc_07570:
    jmp near ptr loc_0BD0D

; Near leaf. DS:95DA supplies cursor. Normalize BX==32CCh to2B5Ch before reading; inspect at most34 zero-status
; records at stride38h. Success returns BX and CX=34-skipped and saves cursor; failure BX=FFFF,CX=0 leaves
; cursor unchanged. Accept aligned pool cursor or exact end32CC; other pointers not validated. Does not activate
; or clear records. AX,DX,SI,DI,BP,segments preserved; flags changed.
FindFreeRecordPoolB:
    mov cx, POOL_B_COUNT
    mov bx, word ptr ds:[PoolBCursor]
loc_0757A:
    cmp bx, offset PoolBEnd
    jne loc_07583
    mov bx, offset PoolB
loc_07583:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_07591
    add bx, RECORD_SIZE
    loop loc_0757A
    mov bx, 0FFFFh
    ret
loc_07591:
    mov word ptr ds:[PoolBCursor], bx
    ret

loc_07596:
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    shl bx, 1
    jmp word ptr cs:[bx + loc_07596Cases]
loc_07596Cases label word
    dw offset loc_07746, offset loc_0768E, offset loc_075A6
loc_075A6:
    mov bx, word ptr ss:[bp + REC_SPRITE]
    mov cx, word ptr cs:[ManExplSegment]
    cmp bx, 01Ch
    jb loc_075BB
    sub bx, 01Ch
    mov cx, word ptr cs:[LevelSpritesSegment]
loc_075BB:
    shl bx, 1
    add bx, offset Sprite32Offsets
    mov si, word ptr cs:[bx]
    mov word ptr cs:[07624h], si
    mov word ptr cs:[07626h], cx
    mov di, word ptr ss:[bp + REC_SCREEN_OFS]
    cmp di, -1
    je loc_075DB
    push bp
    call loc_075F5
    pop bp
loc_075DB:
    mov di, word ptr ss:[bp + REC_SCREEN_OFS_LOWER]
    cmp di, -1
    jne loc_075E4
    ret
loc_075E4:
    mov si, word ptr cs:[07624h]
    mov cx, word ptr cs:[07626h]
    mov ax, word ptr ds:[Sprite32Bytes]
    shr ax, 1
    add si, ax
loc_075F5:
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    shl bx, 1
    shl bx, 1
    add bx, word ptr ss:[bp + REC_PIXEL_PHASE]
    mov dx, offset FlashSprite32Blitters
    test word ptr ss:[bp + REC_FLASH_TIMER], 0FFFFh
    jne loc_07615
    mov dx, offset Sprite32Blitters
loc_07615:
    shl bx, 1
    add bx, dx
    mov ds, cx
    mov bp, 010h
    mov cx, bp
    jmp word ptr cs:[bx]
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h
; 32x32 sprite blitters (one 16-row half per call) indexed by VideoAdapter*8 +
; REC_PIXEL_PHASE (CGA uses 4 phases, EGA 8, Tandy 1); unused slots hold loc_07688.
; FlashSprite32Blitters is used while REC_FLASH_TIMER is nonzero.
Sprite32Blitters label word
    dw offset loc_03849, offset loc_03926, offset loc_039DF, offset loc_03AEE, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
    dw offset loc_0103C, offset loc_010ED, offset loc_011B8, offset loc_012B6, offset loc_013E7, offset loc_0154B, offset loc_0167C, offset loc_0177A
    dw offset loc_02E6E, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
FlashSprite32Blitters label word
    dw offset loc_0387C, offset loc_03C53, offset loc_03CBC, offset loc_03D52, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
    dw offset loc_010B7, offset loc_01845, offset loc_01899, offset loc_018F7, offset loc_0195F, offset loc_019D1, offset loc_01A39, offset loc_01A97
    dw offset loc_02ECB, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
loc_07688:
    mov ds, cs:[MainDataSegment]
    ret
loc_0768E:
    mov di, word ptr ss:[bp + REC_SCREEN_OFS]
    cmp di, -1
    jne loc_07697
    ret
loc_07697:
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr ss:[bp + REC_SPRITE]
    mov cx, word ptr cs:[Sprites2x2Segment]
    cmp bx, 0FAh
    jb loc_076B3
    sub bx, 0FAh
    mov cx, word ptr cs:[Sprites2x2CSegment]
loc_076B3:
    shl bx, 1
    add bx, offset Sprite16Offsets
    mov si, word ptr cs:[bx]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    shl bx, 1
    shl bx, 1
    add bx, word ptr ss:[bp + REC_PIXEL_PHASE]
    mov dx, offset FlashSprite16Blitters
    test word ptr ss:[bp + REC_FLASH_TIMER], 0FFFFh
    jne loc_076D7
    mov dx, offset Sprite16Blitters
loc_076D7:
    shl bx, 1
    add bx, dx
    mov ds, cx
    mov bp, 010h
    mov cx, bp
    jmp word ptr cs:[bx]
; UNKNOWN: not yet classified as code or data
    db 090h
; 16x16 sprite blitters, as Sprite32Blitters (VideoAdapter*8 + REC_PIXEL_PHASE);
; FlashSprite16Blitters while REC_FLASH_TIMER is nonzero.
Sprite16Blitters label word
    dw offset loc_038B7, offset loc_03E12, offset loc_03E70, offset loc_03EFB, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
    dw offset loc_01AEB, offset loc_01B4F, offset loc_01BC6, offset loc_01C61, offset loc_01D1B, offset loc_01DF4, offset loc_01EAE, offset loc_01F49
    dw offset loc_02F81, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
FlashSprite16Blitters label word
    dw offset loc_038D6, offset loc_03FB0, offset loc_03FEB, offset loc_0403A, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
    dw offset loc_01B2E, offset loc_01FC0, offset loc_01FFB, offset loc_0203C, offset loc_02083, offset loc_020D0, offset loc_02117, offset loc_02158
    dw offset loc_02F40, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688

loc_07746:
    mov di, word ptr ss:[bp + REC_SCREEN_OFS]
    cmp di, -1
    jne loc_0774F
    ret
loc_0774F:
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr ss:[bp + REC_SPRITE]
    mov cx, word ptr cs:[Sprites1x1Segment]
    shl bx, 1
    add bx, offset Sprite8Offsets
    mov si, word ptr cs:[bx]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    shl bx, 1
    shl bx, 1
    add bx, word ptr ss:[bp + REC_PIXEL_PHASE]
    mov ds, cx
    mov bp, 8
    mov cx, bp
    shl bx, 1
    jmp word ptr cs:[bx + Sprite8Blitters]
; NOP filler: word-aligns the table. 8x8 blitters, indexed as Sprite32Blitters.
    db 090h
Sprite8Blitters label word
    dw offset loc_038F9, offset loc_0409D, offset loc_040D7, offset loc_0412B
    dw offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
    dw offset loc_02193, offset loc_021D6, offset loc_02223, offset loc_02285
    dw offset loc_022FC, offset loc_0238D, offset loc_02410, offset loc_0247E
    dw offset loc_02FB6, offset loc_07688, offset loc_07688, offset loc_07688
    dw offset loc_07688, offset loc_07688, offset loc_07688, offset loc_07688
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
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
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
    call DrawOffsetFromScreenRow
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
    mov es, word ptr cs:[LevelMapSegment]
    mov si, word ptr ds:[0A408h]
    mov word ptr ds:[0A406h], 0Dh
    mov word ptr ds:[0A40Ah], 0
loc_0795D:
    mov al, byte ptr es:[si]
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    call word ptr ds:[bx + LevelMapCellHandlers]
    add word ptr ds:[0A40Ah], 010h
    inc si
    dec word ptr ds:[0A406h]
    jne loc_0795D
    ret
loc_07977:
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
loc_079A6:
    mov byte ptr es:[si], 1
    mov byte ptr es:[si + 1], 1
    mov byte ptr es:[si + 0Dh], 1
    mov byte ptr es:[si + 0Eh], 1
    ret
loc_079BA:
    call loc_079A6
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_079C6
    ret
loc_079C6:
    call loc_07A40
    mov word ptr ds:[bx + 18h], 48h
    mov word ptr ds:[bx + 6], 4
    jmp near ptr loc_081A7
loc_079D6:
    call loc_079A6
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_079E2
    ret
loc_079E2:
    call loc_07A40
    mov word ptr ds:[bx + 18h], 75h
    mov word ptr ds:[bx + 8], 24h
    mov word ptr ds:[bx + 6], 4
    jmp near ptr loc_081A7
loc_079F7:
    call loc_079A6
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07A03
    ret
loc_07A03:
    call loc_07A40
    mov word ptr ds:[bx + 18h], 72h
    mov word ptr ds:[bx + 6], 4
    ret
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
loc_07A86:
    call loc_0819E
    jne loc_07A8C
    ret
loc_07A8C:
    mov word ptr ds:[bx + 18h], 8Eh
    ret
loc_07A92:
    call loc_081C9
    jne loc_07A98
    ret
loc_07A98:
    mov ax, 4
    mov ds:[237Ah], ax
    call loc_07445
    ret
loc_07AA2:
    call loc_0819E
    jne loc_07AA8
    ret
loc_07AA8:
    mov word ptr ds:[bx + 18h], 8Dh
    ret
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
loc_07B06:
    cmp al, 30h
    je loc_07B13
    cmp al, 0C4h
    je loc_07B64
    cmp al, 5Ah
    je loc_07B54
    ret
loc_07B13:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07B1C
    ret
loc_07B1C:
    mov word ptr ds:[bx + REC_KIND], 4
    mov ax, ds:[0A40Ah]
    mov ds:[bx + REC_X], ax
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    mov word ptr ds:[bx + REC_Y], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 2
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    mov word ptr ds:[bx + REC_HIT_POINTS], 0Ah
    mov word ptr ds:[bx + REC_TYPE], 2Ah
    mov word ptr ds:[bx + REC_SPRITE], 1Ch
    mov word ptr ds:[bx + REC_DIRECTION], 0
    ret
loc_07B54:
    call loc_081C9
    jne loc_07B5A
    ret
loc_07B5A:
    mov word ptr ds:[bx + 18h], 2Eh
    sub word ptr ds:[bx + 2], 6
    ret
loc_07B64:
    call loc_081C9
    jne loc_07B6A
    ret
loc_07B6A:
    mov word ptr ds:[bx + 18h], 8Fh
    mov word ptr ds:[bx + 8], 0BFh
    mov word ptr ds:[bx + 6], 6
    cmp word ptr ds:[bx + 4], 60h
    jna loc_07B80
    ret
loc_07B80:
    mov word ptr ds:[bx + 8], 0C2h
    mov word ptr ds:[bx + 6], 2
    ret
loc_07B8B:
    call loc_081C9
    jne loc_07B91
    ret
loc_07B91:
    sub word ptr ds:[bx + 4], 0Ch
    push word ptr ds:[bx + 4]
    pop word ptr ds:[bx + 32h]
    mov word ptr ds:[bx + 6], 2
    mov word ptr ds:[bx + 18h], 73h
    mov word ptr ds:[bx + 8], 14Ch
    ret
loc_07BAB:
    call loc_081C9
    jne loc_07BB1
    ret
loc_07BB1:
    add word ptr ds:[bx + 4], 0Ch
    push word ptr ds:[bx + 4]
    pop word ptr ds:[bx + 32h]
    mov word ptr ds:[bx + 6], 6
    mov word ptr ds:[bx + 18h], 74h
    mov word ptr ds:[bx + 8], 14Fh
    ret
loc_07BCB:
    cmp word ptr ds:[0A40Ah], 60h
    ja loc_07BD8
    cmp al, 0BCh
    je loc_07B8B
    jmp short loc_07BDC
loc_07BD8:
    cmp al, 0BBh
    je loc_07BAB
loc_07BDC:
    sub al, 0E1h
    jns loc_07BE1
    ret
loc_07BE1:
    cmp al, 1Ah
    jna loc_07BE6
    ret
loc_07BE6:
    push ax
    mov bx, si
    and bx, 3Fh
    mov bl, ds:[bx - 37E6h]
    xor bh, bh
    mov ds:[2070h], bx
    call far ptr loc_0F953
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + 7C08h]
; UNKNOWN: not yet classified as code or data
    db 90h
    dw offset loc_07ED7, offset loc_07ED7, offset loc_08143, offset loc_08137
    dw offset loc_07F86, offset loc_07F86, offset loc_07F5D, offset loc_07F69
    dw offset loc_07F7A, offset loc_07FEA, offset loc_07F14, offset loc_07FFB
    dw offset loc_07AA2, offset loc_07A86, offset loc_07F25, offset loc_07FAD
    dw offset loc_07FAD, offset loc_080EF, offset loc_080EF, offset loc_0804C
    dw offset loc_07C3A, offset loc_08113, offset loc_079F7, offset loc_079D6
    dw offset loc_07A92
loc_07C3A:
    mov byte ptr es:[si], 1
    ret
loc_07C3F:
    sub al, 0CEh
    jns loc_07C44
    ret
loc_07C44:
    cmp al, 1Dh
    jna loc_07C49
    ret
loc_07C49:
    push ax
    mov bx, si
    and bx, 3Fh
    mov bl, ds:[bx - 37E6h]
    xor bh, bh
    mov ds:[2070h], bx
    call far ptr loc_0F953
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + 7C6Ah]
    dw offset loc_07EB0, offset loc_07EB0, offset loc_07F36, offset loc_07F36
    dw offset loc_080B7, offset loc_080B7, offset loc_080DE, offset loc_08107
    dw offset loc_0806E, offset loc_07EFE, offset loc_0804C, offset loc_08172
    dw offset loc_08188, offset loc_0811F, offset loc_08166, offset loc_07A7A
    dw offset loc_07A6E, offset CountXReturn, offset loc_08113, offset loc_080FB
    dw offset loc_0802A, offset loc_07FD4, offset loc_080A1, offset loc_080EF
    dw offset loc_080EF, offset loc_0808B, offset loc_0803B, offset loc_0812B
loc_07CA2:
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
    mov bl, byte ptr ds:[bx + GroupDropKinds]
    xor bh, bh
    mov word ptr ds:[02070h], bx
    call far ptr loc_0F953
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + loc_07CC1Cases]
loc_07CC1Cases label word
    dw offset loc_07A7A, offset loc_07A6E, offset loc_08172, offset loc_08188
    dw offset loc_07D2A, offset loc_07D4D, offset loc_0806E, offset loc_07F25
    dw offset loc_08113, offset loc_0804C, offset loc_08107, offset loc_080A1
    dw offset loc_07D08, offset loc_07D19, offset loc_080EF, offset loc_08143
    dw offset loc_08137, offset loc_0812B, offset loc_07FD4
loc_07D08:
    call loc_081C9
    jne loc_07D0E
    ret
loc_07D0E:
    mov word ptr ds:[bx + 18h], 38h
    mov word ptr ds:[bx + 6], 3
    ret
loc_07D19:
    call loc_081C9
    jne loc_07D1F
    ret
loc_07D1F:
    mov word ptr ds:[bx + 18h], 38h
    mov word ptr ds:[bx + 6], 5
    ret
loc_07D2A:
    call loc_081C9
    jne loc_07D30
    ret
loc_07D30:
    mov word ptr ds:[bx + 6], 1
    mov word ptr ds:[bx + 18h], 54h
    mov word ptr ds:[bx + 8], 172h
    cmp word ptr ds:[LevelIndex], 4
    jne loc_07D47
    ret
loc_07D47:
    mov word ptr ds:[bx + 8], 17Ah
    ret
loc_07D4D:
    call loc_081C9
    jne loc_07D53
    ret
loc_07D53:
    mov word ptr ds:[bx + 6], 7
    mov word ptr ds:[bx + 18h], 54h
    mov word ptr ds:[bx + 8], 173h
    cmp word ptr ds:[LevelIndex], 4
    jne loc_07D6A
    ret
loc_07D6A:
    mov word ptr ds:[bx + 8], 17Bh
    ret
loc_07D70:
    call loc_081C9
    jne loc_07D76
    ret
loc_07D76:
    mov word ptr ds:[bx + 6], 0
    mov word ptr ds:[bx + 18h], 84h
    mov word ptr ds:[bx + 8], 156h
    ret
loc_07D86:
    call loc_081C9
    jne loc_07D8C
    ret
loc_07D8C:
    mov word ptr ds:[bx + 6], 2
    mov word ptr ds:[bx + 18h], 84h
    mov word ptr ds:[bx + 8], 157h
    ret
loc_07D9C:
    call loc_081C9
    jne loc_07DA2
    ret
loc_07DA2:
    mov word ptr ds:[bx + 6], 4
    mov word ptr ds:[bx + 18h], 84h
    mov word ptr ds:[bx + 8], 158h
    ret
loc_07DB2:
    call loc_081C9
    jne loc_07DB8
    ret
loc_07DB8:
    mov word ptr ds:[bx + 6], 6
    mov word ptr ds:[bx + 18h], 84h
    mov word ptr ds:[bx + 8], 159h
    ret
loc_07DC8:
    cmp al, 30h
    jne loc_07DCF
    jmp near ptr loc_07B13
loc_07DCF:
    cmp al, 0BAh
    je loc_07D70
    cmp al, 0BBh
    je loc_07D86
    cmp al, 0BCh
    je loc_07D9C
    cmp al, 0B6h
    je loc_07DB2
    cmp al, 0D8h
    jne loc_07DE6
    jmp near ptr loc_07A6E
loc_07DE6:
    cmp al, 0D7h
    jne loc_07DED
    jmp near ptr loc_07A7A
loc_07DED:
    cmp al, 0D3h
    jne loc_07DF4
    jmp near ptr loc_07ADA
loc_07DF4:
    cmp al, 0D2h
    jne loc_07DFB
    jmp near ptr loc_07AF0
loc_07DFB:
    sub al, 0D7h
    jns loc_07E00
    ret
loc_07E00:
    cmp al, 1Ah
    jna loc_07E05
    ret
loc_07E05:
    push ax
    mov bx, si
    and bx, 3Fh
    mov bl, ds:[bx - 37E6h]
    xor bh, bh
    mov ds:[2070h], bx
    call far ptr loc_0F953
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + 7E26h]
    dw offset loc_07AA2, offset loc_07A86, offset loc_079BA, offset loc_07E84
    dw offset loc_07E9A, offset loc_07D2A, offset loc_07D4D, offset loc_080B7
    dw offset loc_080B7, offset loc_080A1, offset loc_07E58, offset loc_07E58
    dw offset loc_07EFE, offset loc_07E6E, offset loc_08172, offset loc_08188
    dw offset loc_07E5D, offset loc_08166, offset loc_0803B, offset loc_0812B
    dw offset loc_08143, offset loc_08113, offset loc_080FB, offset loc_0802A
    dw offset loc_07FD4
loc_07E58:
    mov byte ptr es:[si], 1
    ret
loc_07E5D:
    call loc_081C9
    jne loc_07E63
    ret
loc_07E63:
    mov word ptr ds:[bx + 18h], 19h
    mov word ptr ds:[bx + 6], 2
    ret
loc_07E6E:
    call loc_081C9
    jne loc_07E74
    ret
loc_07E74:
    mov word ptr ds:[bx + 8], 46h
    mov word ptr ds:[bx + 18h], 30h
    mov word ptr ds:[bx + 6], 4
    ret
loc_07E84:
    call loc_081C9
    jne loc_07E8A
    ret
loc_07E8A:
    mov word ptr ds:[bx + 18h], 92h
    mov word ptr ds:[bx + 8], 15Ah
    mov word ptr ds:[bx + 6], 2
    ret
loc_07E9A:
    call loc_081C9
    jne loc_07EA0
    ret
loc_07EA0:
    mov word ptr ds:[bx + 18h], 92h
    mov word ptr ds:[bx + 8], 15Bh
    mov word ptr ds:[bx + 6], 6
    ret
loc_07EB0:
    call loc_081C9
    jne loc_07EB6
    ret
loc_07EB6:
    mov word ptr ds:[bx + 6], 6
    mov word ptr ds:[bx + 18h], 86h
    mov word ptr ds:[bx + 8], 0C8h
    cmp word ptr ds:[bx + 4], 60h
    jna loc_07ECC
    ret
loc_07ECC:
    mov word ptr ds:[bx + 8], 0DAh
    mov word ptr ds:[bx + 6], 2
    ret
loc_07ED7:
    call loc_081C9
    jne loc_07EDD
    ret
loc_07EDD:
    mov word ptr ds:[bx + 6], 6
    mov word ptr ds:[bx + 18h], 88h
    mov word ptr ds:[bx + 8], 0FDh
    cmp word ptr ds:[bx + 4], 60h
    jna loc_07EF3
    ret
loc_07EF3:
    mov word ptr ds:[bx + 8], 0FAh
    mov word ptr ds:[bx + 6], 2
    ret
loc_07EFE:
    call loc_081C9
    jne loc_07F04
    ret
loc_07F04:
    mov word ptr ds:[bx + 6], 2
    mov word ptr ds:[bx + 18h], 63h
    mov word ptr ds:[bx + 8], 0E7h
    ret
loc_07F14:
    call loc_0819E
    jne loc_07F1A
    ret
loc_07F1A:
    mov word ptr ds:[bx + 6], 4
    mov word ptr ds:[bx + 18h], 71h
    ret
loc_07F25:
    call loc_0819E
    jne loc_07F2B
    ret
loc_07F2B:
    mov word ptr ds:[bx + 6], 4
    mov word ptr ds:[bx + 18h], 8Ah
    ret
loc_07F36:
    call loc_081C9
    jne loc_07F3C
    ret
loc_07F3C:
    mov word ptr ds:[bx + 6], 7
    mov word ptr ds:[bx + 18h], 54h
    mov word ptr ds:[bx + 8], 0F5h
    cmp word ptr ds:[bx + 4], 60h
    jna loc_07F52
    ret
loc_07F52:
    mov word ptr ds:[bx + 6], 1
    mov word ptr ds:[bx + 8], 0F4h
    ret
loc_07F5D:
    call loc_081C9
    jne loc_07F63
    ret
loc_07F63:
    mov word ptr ds:[bx + 18h], 6Bh
    ret
loc_07F69:
    call loc_0819E
    jne loc_07F6F
    ret
loc_07F6F:
    mov word ptr ds:[bx + 18h], 6Ch
    mov word ptr ds:[bx + 8], 123h
    ret
loc_07F7A:
    call loc_081C9
    jne loc_07F80
    ret
loc_07F80:
    mov word ptr ds:[bx + 18h], 6Dh
    ret
loc_07F86:
    call loc_081C9
    jne loc_07F8C
    ret
loc_07F8C:
    mov word ptr ds:[bx + 6], 5
    mov word ptr ds:[bx + 18h], 6Ah
    mov word ptr ds:[bx + 8], 11Eh
    cmp word ptr ds:[bx + 4], 60h
    jna loc_07FA2
    ret
loc_07FA2:
    mov word ptr ds:[bx + 6], 3
    mov word ptr ds:[bx + 8], 11Dh
    ret
loc_07FAD:
    call loc_081C9
    jne loc_07FB3
    ret
loc_07FB3:
    mov word ptr ds:[bx + 6], 7
    mov word ptr ds:[bx + 18h], 54h
    mov word ptr ds:[bx + 8], 143h
    cmp word ptr ds:[bx + 4], 60h
    jna loc_07FC9
    ret
loc_07FC9:
    mov word ptr ds:[bx + 6], 1
    mov word ptr ds:[bx + 8], 144h
    ret
loc_07FD4:
    call loc_0819E
    jne loc_07FDA
    ret
loc_07FDA:
    mov word ptr ds:[bx + 6], 4
    mov word ptr ds:[bx + 18h], 5Eh
    mov word ptr ds:[bx + 8], 27h
    ret
loc_07FEA:
    call loc_0819E
    jne loc_07FF0
    ret
loc_07FF0:
    mov word ptr ds:[bx + 6], 4
    mov word ptr ds:[bx + 18h], 6Eh
    ret
loc_07FFB:
    call loc_0819E
    jne loc_08001

; Offset-placement use of field+8 does not define its role in other record types.
; Modern position-history symbols.
; Modern record/state symbols.
; UNKNOWN: not yet classified as code or data
    db 0C3h
loc_08001:
    mov word ptr ds:[bx + 6], 4
    mov word ptr ds:[bx + 18h], 6Fh
    mov word ptr ds:[bx + 8], 136h
    mov word ptr ds:[bx + 6], 3
    sub word ptr ds:[bx + 4], 10h
    cmp word ptr ds:[bx + 4], 60h
    jae loc_08020
    ret
loc_08020:
    mov word ptr ds:[bx + 6], 5
    add word ptr ds:[bx + 4], 20h
    ret
loc_0802A:
    call loc_0819E
    jne loc_08030
    ret
loc_08030:
    mov word ptr ds:[bx + 6], 0
    mov word ptr ds:[bx + 18h], 2Dh
    ret
loc_0803B:
    call loc_0819E
    jne loc_08041
    ret
loc_08041:
    mov word ptr ds:[bx + 6], 6
    mov word ptr ds:[bx + 18h], 47h
    ret
loc_0804C:
    call loc_081C9
    jne loc_08052
    ret
loc_08052:
    mov word ptr ds:[bx + 6], 7
    mov word ptr ds:[bx + 18h], 59h
    mov word ptr ds:[bx + 8], 0E3h
    cmp word ptr ds:[bx + 4], 60h
    jna loc_08068
    ret
loc_08068:
    mov word ptr ds:[bx + 6], 1
    ret
loc_0806E:
    call loc_081C9
    jne loc_08074
    ret
loc_08074:
    mov word ptr ds:[bx + 6], 6
    mov word ptr ds:[bx + 18h], 5Fh
    cmp word ptr ds:[bx + 4], 60h
    jna loc_08085
    ret
loc_08085:
    mov word ptr ds:[bx + 6], 2
    ret
loc_0808B:
    call loc_081C9
    jne loc_08091
    ret
loc_08091:
    mov word ptr ds:[bx + 6], 0
    mov word ptr ds:[bx + 18h], 5Bh
    mov word ptr ds:[bx + 8], 74h
    ret
loc_080A1:
    call loc_0819E
    jne loc_080A7
    ret
loc_080A7:
    mov word ptr ds:[bx + 6], 4
    mov word ptr ds:[bx + 18h], 5Dh
    mov word ptr ds:[bx + 8], 77h
    ret
loc_080B7:
    call loc_081C9
    jne loc_080BD
    ret
loc_080BD:
    mov word ptr ds:[bx + 6], 6
    mov word ptr ds:[bx + 18h], 87h
    mov word ptr ds:[bx + 8], 0E0h
    cmp word ptr ds:[bx + 4], 60h
    jna loc_080D3
    ret
loc_080D3:
    mov word ptr ds:[bx + 6], 2
    mov word ptr ds:[bx + 8], 0DDh
    ret
loc_080DE:
    call loc_081C9
    jne loc_080E4
    ret
loc_080E4:
    mov word ptr ds:[bx + 18h], 55h
    mov word ptr ds:[bx + 8], 77h
    ret
loc_080EF:
    call loc_081C9
    jne loc_080F5
    ret
loc_080F5:
    mov word ptr ds:[bx + 18h], 34h
    ret
loc_080FB:
    call loc_0819E
    jne loc_08101
    ret
loc_08101:
    mov word ptr ds:[bx + 18h], 37h
    ret
loc_08107:
    call loc_0819E
    jne loc_0810D
    ret
loc_0810D:
    mov word ptr ds:[bx + 18h], 83h
    ret
loc_08113:
    call loc_081C9
    jne loc_08119
    ret
loc_08119:
    mov word ptr ds:[bx + 18h], 4Fh
    ret
loc_0811F:
    call loc_0819E
    jne loc_08125
    ret
loc_08125:
    mov word ptr ds:[bx + 18h], 19h
    ret
loc_0812B:
    call loc_0819E
    jne loc_08131
    ret
loc_08131:
    mov word ptr ds:[bx + 18h], 35h
    ret
loc_08137:
    call loc_081C9
    jne loc_0813D
    ret
loc_0813D:
    mov word ptr ds:[bx + 18h], 69h
    ret
loc_08143:
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0815A
    call NextRandomWord
    and bx, 0Fh
    cmp bx, 0Fh
    jne loc_0815A
    call loc_0819E
    jmp short loc_0815D
loc_0815A:
    call loc_081C9
loc_0815D:
    jne loc_08160
    ret
loc_08160:
    mov word ptr ds:[bx + 18h], 68h
    ret
loc_08166:
    call loc_0819E
    jne loc_0816C
    ret
loc_0816C:
    mov word ptr ds:[bx + 18h], 89h
    ret
loc_08172:
    call loc_081C9
    jne loc_08178
    ret
loc_08178:
    mov word ptr ds:[bx + 18h], 58h
    mov word ptr ds:[bx + 8], 99h
    mov word ptr ds:[bx + 6], 2
    ret
loc_08188:
    call loc_081C9
    jne loc_0818E
    ret
loc_0818E:
    mov word ptr ds:[bx + 18h], 57h
    mov word ptr ds:[bx + 8], 9Bh
    mov word ptr ds:[bx + 6], 6
    ret
loc_0819E:
    call loc_081C9
    cmp bx, -1
    jne loc_081A7
    ret
loc_081A7:
    mov ax, 0FFFFh
    cmp word ptr ds:[209Ah], -1
    je loc_081C2
    push bx
    mov bx, ds:[209Ah]
    inc byte ptr ds:[bx]
    mov al, ds:[2070h]
    mov ds:[bx + 1], al
    pop bx
    mov ax, ds:[2098h]
loc_081C2:
    mov ds:[bx + 28h], ax
    or ax, 1
    ret
loc_081C9:
    call loc_07E58
loc_081CC:
    call loc_081E9
    cmp bx, -1
    jne loc_081D5
    ret
loc_081D5:
    mov ax, word ptr ds:[0A40Ah]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_Y], 010h
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    or ax, 1
    ret
loc_081E9:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_081F2
    ret
loc_081F2:
    jmp short loc_08209
loc_081F4:
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
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[bx + REC_Y], ax
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_DIRECTION], 4
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], 4
    mov word ptr ds:[bx + REC_TYPE], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 4
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    ret
TypeHandler24:
    cmp word ptr ds:[232Ch], 1Fh
    je loc_08252
    jmp near ptr loc_0BC45
loc_08252:
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0825D
    jmp near ptr loc_0BC45
loc_0825D:
    mov word ptr ds:[bx + REC_SPRITE], 1Eh
    jmp near ptr loc_0BC45
TypeHandler25:
    cmp word ptr ds:[232Ch], 1Fh
    je loc_0826F
    jmp near ptr loc_0BC45
loc_0826F:
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0827A
    jmp near ptr loc_0BC45
loc_0827A:
    mov word ptr ds:[bx + REC_SPRITE], 1Ah
    jmp near ptr loc_0BC45
TypeHandler90:
    mov ax, 88h
    cmp word ptr ds:[LevelIndex], 4
    jne loc_0829E
    mov ax, 16Ch
    jmp short loc_0829E
TypeHandler91:
    mov ax, 8Bh
    cmp word ptr ds:[LevelIndex], 4
    jne loc_0829E
    mov ax, 16Fh
loc_0829E:
    mov ss:[bp + REC_SPRITE], ax
    mov bx, ds:[2330h]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shl bx, 1
    mov bx, ds:[bx - 6A16h]
    add ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[232Ch], 1Fh
    je loc_082C2
    jmp near ptr loc_0BC45
loc_082C2:
    shl bx, 1
    jmp word ptr cs:[bx + loc_082C2Cases]
; NOP filler: word-aligns the table (every MAIN jump table has one).
    db 90h
loc_082C2Cases label word
    dw offset loc_082DE, offset loc_0BC45, offset loc_082D0
loc_082D0:
    add word ptr ss:[bp + REC_Y], 4
    call SpawnThrottledChild
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC45
loc_082DE:
    sub word ptr ss:[bp + REC_Y], 4
    call SpawnThrottledChild
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC45
loc_082EC:
    cmp word ptr ds:[2326h], 3
    je loc_082F6
    jmp near ptr loc_0BC45
loc_082F6:
    mov ax, ss:[bp + REC_SAVED_X]
    mov ss:[bp + REC_X], ax
    dec word ptr ss:[bp + REC_SPRITE]
    jmp near ptr loc_0BC45
TypeHandler26:
    cmp word ptr ss:[bp + REC_SPRITE], 98h
    je loc_082EC
    cmp word ptr ss:[bp + REC_SPRITE], 92h
    je loc_082EC
    call loc_0AFD8
    jne loc_0831F
    cmp word ptr ss:[bp + REC_X], 0C0h
    jae loc_0831F
    jmp near ptr loc_0BC45
loc_0831F:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0832E
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0832E:
    jmp near ptr loc_0BC45
loc_08331:
    mov si, word ptr ds:[UpgradeHitY]
    add si, 010h
    cmp word ptr ss:[bp + REC_Y], si
    jg loc_0835B
    sub si, 020h
    cmp word ptr ss:[bp + REC_Y], si
    jl loc_0835B
    mov si, word ptr ds:[UpgradeHitX]
    add si, 010h
    cmp word ptr ss:[bp + REC_X], si
    jg loc_0835B
    sub si, 020h
    cmp word ptr ss:[bp + REC_X], si
    jl loc_0835B
    stc
    ret
loc_0835B:
    clc
    ret
TypeHandler27:
    mov ax, ds:[2338h]
    shr ax, 1
    mov bx, 27h
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0836F
    mov bx, 24h
loc_0836F:
    add ax, bx
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    jmp near ptr loc_0BC45

loc_0837A:
    cmp word ptr ds:[SelectedUpgradeSlot], -1
    jne loc_08382
    ret
loc_08382:
    mov bp, word ptr ds:[SelectedUpgradeSlot]
    shl bp, 1
    add bp, offset UpgradeSlotPtrs
    mov bp, word ptr ss:[bp]
    mov si, word ptr ss:[bp + UPGRADE_SLOT_LIST]
    mov word ptr ds:[UpgradeTries], 0
loc_08398:
    mov bx, word ptr ss:[bp + UPGRADE_SLOT_INDEX]
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
    inc word ptr ss:[bp + UPGRADE_SLOT_INDEX]
    inc word ptr ds:[UpgradeTries]
    cmp word ptr ds:[UpgradeTries], 0Ah
    jb loc_08398
    mov word ptr ss:[bp + UPGRADE_SLOT_INDEX], 0
    mov word ptr ss:[bp + UPGRADE_SLOT_ICON], 024h
    ret
loc_083CA:
    mov ax, word ptr ds:[bx + si]
    mov word ptr ss:[bp + UPGRADE_SLOT_ICON], ax
    ret
loc_083D0:
    mov word ptr ss:[bp + UPGRADE_SLOT_INDEX], 0
    jmp short loc_08398
loc_083D7:
    xor ax, ax
    ret
loc_083DA:
    xor ax, ax
    inc ax
    ret
loc_083DE:
    cmp word ptr ds:[0A958h], 0
    ret
loc_083E4:
    cmp word ptr ds:[0A958h], 1
    ret
loc_083EA:
    cmp word ptr ds:[0A958h], 2
    ret
loc_083F0:
    cmp word ptr ds:[0A958h], 3
    ret
loc_083F6:
    cmp word ptr ds:[0A958h], 4
    ret
loc_083FC:
    cmp word ptr ds:[0A958h], 5
    ret
loc_08402:
    mov word ptr ds:[0A958h], 0
    jmp short loc_08430
loc_0840A:
    mov word ptr ds:[0A958h], 1
    jmp short loc_08430
loc_08412:
    mov word ptr ds:[0A958h], 2
    jmp short loc_08430
loc_0841A:
    mov word ptr ds:[0A958h], 3
    jmp short loc_08430
loc_08422:
    mov word ptr ds:[0A958h], 4
    jmp short loc_08430
loc_0842A:
    mov word ptr ds:[0A958h], 5
loc_08430:
    mov word ptr ds:[SelectedUpgradeSlot], 0FFFFh
    ret
loc_08437:
    cmp word ptr ds:[0A95Eh], 1
    ret
loc_0843D:
    mov word ptr ds:[0A95Eh], 1
    jmp short loc_08430
loc_08445:
    cmp word ptr ds:[0A960h], 0
    je loc_083DA
    jmp short loc_083D7
loc_0844E:
    mov word ptr ds:[0A960h], 4
    jmp short loc_08430
loc_08456:
    cmp word ptr ds:[0A96Eh], -1
    jne loc_08460
    jmp near ptr loc_083DA
loc_08460:
    jmp near ptr loc_083D7
loc_08463:
    call loc_09D91
    jmp short loc_08430
loc_08468:
    cmp word ptr ds:[PlusSlotA966], -1
    jne loc_08472
    jmp near ptr loc_083DA
loc_08472:
    cmp word ptr ds:[MinusSlotA968], -1
    jne loc_0847C
    jmp near ptr loc_083DA
loc_0847C:
    cmp word ptr ds:[2384h], 0
    jne loc_08486
    jmp near ptr loc_083D7
loc_08486:
    cmp word ptr ds:[PlusSlotA96A], -1
    jne loc_08490
    jmp near ptr loc_083DA
loc_08490:
    cmp word ptr ds:[MinusSlotA96C], -1
    jne loc_0849A
    jmp near ptr loc_083DA
loc_0849A:
    jmp near ptr loc_083D7
loc_0849D:
    call loc_09F5F
    jmp short loc_08430
loc_084A2:
    cmp word ptr ds:[2384h], 2
    je loc_084AC
    jmp near ptr loc_083D7
loc_084AC:
    cmp word ptr ds:[HistoryRecordSlot15], -1
    jne loc_084B6
    jmp near ptr loc_083DA
loc_084B6:
    cmp word ptr ds:[HistoryRecordSlot31], -1
    jne loc_084C0
    jmp near ptr loc_083DA
loc_084C0:
    jmp near ptr loc_083D7
loc_084C3:
    call loc_09F1A
    jmp near ptr loc_08430
loc_084C9:
    cmp word ptr ds:[2384h], 0
    jne loc_084D3
    jmp near ptr loc_083DA
loc_084D3:
    jmp near ptr loc_083D7
loc_084D6:
    mov byte ptr ds:[SfxActive], 0
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_084E7
    mov byte ptr ds:[SfxRequest], 6
loc_084E7:
    mov word ptr ds:[2384h], 1
    jmp near ptr loc_08430
loc_084F0:
    cmp word ptr ds:[2384h], 2
    je loc_084FA
    jmp near ptr loc_083DA
loc_084FA:
    jmp near ptr loc_083D7
loc_084FD:
    mov byte ptr ds:[SfxActive], 0
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0850E
    mov byte ptr ds:[SfxRequest], 6
loc_0850E:
    mov word ptr ds:[2384h], 2
    jmp near ptr loc_08430

loc_08517:
    mov word ptr ds:[SelectedUpgradeSlot], 0FFFFh
    mov bp, offset UpgradeSlot0
    mov ah, 087h
    call loc_0852B
    call loc_0852B
    call loc_0852B

loc_0852B:
    mov al, 01Ch
    push ax
    call DrawOffsetFromScreenRow
    mov word ptr ss:[bp + UPGRADE_SLOT_ICON], 024h
    mov word ptr ss:[bp + UPGRADE_SLOT_SCREEN], di
    mov word ptr ss:[bp + UPGRADE_SLOT_INDEX], 0
    add bp, UPGRADE_SLOT_BYTES
    pop ax
    add ah, 010h
    ret

loc_08546:
    cmp word ptr ds:[SelectedUpgradeSlot], -1
    jne loc_0854E
    ret
loc_0854E:
    push bx
    push bp
    mov bp, word ptr ds:[SelectedUpgradeSlot]
    shl bp, 1
    add bp, offset UpgradeSlotPtrs
    mov bp, word ptr ss:[bp]
    mov si, word ptr ss:[bp + UPGRADE_SLOT_LIST]
    mov bx, word ptr ss:[bp + UPGRADE_SLOT_INDEX]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    push word ptr ds:[SelectedUpgradeSlot]
    call word ptr ds:[bx + si + 4]
    mov ax, word ptr ds:[SelectedUpgradeSlot]
    mov word ptr ds:[SavedUpgradeSlot], ax
    pop word ptr ds:[SelectedUpgradeSlot]
    call loc_0837A
    mov ax, word ptr ds:[SavedUpgradeSlot]
    mov word ptr ds:[SelectedUpgradeSlot], ax
    call loc_0859E
    cmp word ptr ds:[SelectedUpgradeSlot], -1
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
    mov bp, offset UpgradeSlot0
    xor di, di
    call loc_085D5
    mov bp, offset UpgradeSlot1
    mov di, 1
    call loc_085D5
    mov bp, offset UpgradeSlot2
    mov di, 2
    call loc_085D5
    mov bp, offset UpgradeSlot3
    mov di, 3

loc_085D5:
    cmp word ptr ds:[SelectedUpgradeSlot], -1
    je loc_085ED
    mov si, word ptr ds:[SelectedUpgradeSlot]
    shl si, 1
    add si, offset UpgradeSlotPtrs
    cmp bp, word ptr ds:[si]
    mov ax, 1
    je loc_085EF
loc_085ED:
    xor ax, ax
loc_085EF:
    cmp word ptr ds:[DemoActive], 1
    jne loc_08602
    cmp di, word ptr ds:[SelectedUpgradeSlot]
    jne loc_08602
    push word ptr ds:[DemoUpgradeStatus]
    jmp short loc_08605
loc_08602:
    push word ptr ss:[bp + REC_STATUS]
loc_08605:
    push ax
    mov si, word ptr ss:[bp + REC_X]
    add si, ax
    shl si, 1
    add si, offset PanelImageOffsets
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
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    push di
    call BlitPackedToScreen
    pop di
    call loc_0613E
    pop si
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_08654:
    cmp word ptr ds:[2332h], 0
    jne loc_08669
    inc word ptr ss:[bp + REC_DIRECTION]
    cmp word ptr ss:[bp + REC_DIRECTION], 18h
    jb loc_08669
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_08669:
    mov bx, offset Type28FrameRamp
    mov ax, ss:[bp + REC_DIRECTION]
    xlat
    add ax, cx
    mov ss:[bp + REC_SPRITE], ax
    ret
TypeHandler28:
    mov cx, 1Ch
    cmp word ptr ds:[LevelIndex], 1
    je loc_0868A
    cmp word ptr ds:[LevelIndex], 4
    je loc_0868A
    mov cx, 1Ch
loc_0868A:
    call loc_08654
    cmp word ptr ds:[EncounterLiveCount], 0
    je loc_08697
    jmp near ptr loc_0BC45
loc_08697:
    cmp word ptr ss:[bp + REC_DIRECTION], 7
    je loc_086A0
    jmp near ptr loc_0BC45
loc_086A0:
    inc word ptr ss:[bp + REC_DIRECTION]
    call loc_081F4
    cmp bx, -1
    jne loc_086AE
    jmp near ptr loc_0BC45
loc_086AE:
    mov word ptr ds:[bx + REC_HIT_POINTS], 4
    add word ptr ds:[bx + REC_Y], 8
    add word ptr ds:[bx + REC_X], 8
    cmp word ptr ds:[LevelIndex], 1
    je loc_086DA
    cmp word ptr ds:[LevelIndex], 4
    je loc_086DA
    cmp word ptr ds:[LevelIndex], 2
    je loc_086E7
    cmp word ptr ds:[LevelIndex], 5
    je loc_086F7
    jmp near ptr loc_0BC45
loc_086DA:
    mov word ptr ds:[bx + 18h], 29h
    mov word ptr ds:[bx + 8], 0A1h
    jmp near ptr loc_0BC45
loc_086E7:
    mov word ptr ds:[bx + 18h], 2Bh
    mov word ptr ds:[bx + 8], 0A5h
    call loc_074E2
    jmp near ptr loc_0BC45
loc_086F7:
    mov word ptr ds:[bx + 18h], 7Ah
    mov word ptr ds:[bx + 8], 20h
    call loc_074E2
    jmp near ptr loc_0BC45
TypeHandler7C:
    mov ax, 15Ch
    jmp short loc_0870F
TypeHandler7A:
    mov ax, 20h
loc_0870F:
    add ax, ds:[2326h]
    jmp short loc_0871C
TypeHandler2B:
    mov ax, 0A5h
    add ax, ds:[233Ch]
loc_0871C:
    mov ss:[bp + REC_SPRITE], ax
    jmp short TypeHandler60
TypeHandler29:
    cmp word ptr ss:[bp + REC_SPRITE], 0A4h
    je TypeHandler60
    cmp word ptr ds:[2328h], 7
    je loc_08732
    jmp near ptr loc_0BC45
loc_08732:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp word ptr ss:[bp + REC_SPRITE], 0A4h
    je loc_0873F
    jmp near ptr loc_0BC45
loc_0873F:
    mov bx, bp
    call loc_074E2
TypeHandler60:
    mov word ptr ds:[2312h], 2
    call loc_05E42
    mov word ptr ds:[2312h], 3
    cmp word ptr ss:[bp + REC_X], 0C0h
    jg loc_08763
    cmp word ptr ss:[bp + REC_X], 0
    jl loc_08763
    jmp near ptr loc_0BC45
loc_08763:
    call loc_0BFC7
    jmp near ptr loc_0BC45
TypeHandler8F:
    mov bx, ds:[232Eh]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    mov cx, bx
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames8]
    add bx, 0BFh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_X], 60h
    ja loc_0878C
    add word ptr ss:[bp + REC_SPRITE], 3
loc_0878C:
    cmp cx, 3
    je loc_08794
    jmp near ptr loc_0BC45
loc_08794:
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0879F
    jmp near ptr loc_0BC45
loc_0879F:
    mov word ptr ds:[bx + REC_SPRITE], 44h
    jmp near ptr loc_0BC45
TypeHandler71:
    mov ax, ds:[2336h]
    add ax, 12Bh
    jmp short loc_087B5
TypeHandler2D:
    mov ax, ds:[233Ch]
    add ax, 93h
loc_087B5:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_Y], 60h
    ja loc_087D3
    cmp word ptr ds:[2330h], 7Fh
    je loc_087C8
    jmp near ptr loc_0BC45
loc_087C8:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    call SpawnThrottledChild
    jmp near ptr loc_0BC45
loc_087D3:
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC45
TypeHandler2E:
    mov ax, ds:[StackTop]
    add ss:[bp + REC_SAVED_Y], ax
    call NextRandomWord
    and bx, 3
    add bx, 0ADh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_Y], 80h
    jnl loc_087F7
    jmp near ptr loc_0BC45
loc_087F7:
    jne loc_087FC
    call loc_08802
loc_087FC:
    call loc_0B729
    jmp near ptr loc_0BC4B
loc_08802:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0880E
    mov byte ptr ds:[SfxRequest], 0Bh
loc_0880E:
    mov ax, ds:[2380h]
    add ax, 8
    and ax, 0FFFEh
    mov ss:[bp + REC_SAVED_X], ax
    mov word ptr ss:[bp + REC_SAVED_Y], 7530h
    ret
TypeHandler2F:
    mov word ptr ss:[bp + REC_SPRITE], 43h
    mov word ptr ds:[2308h], 2
    call loc_0B729
    pushf
    mov ax, ds:[StackTop]
    add ss:[bp + REC_SAVED_Y], ax
    popf
    jne loc_0883B
    jmp near ptr loc_0BC45
loc_0883B:
    cmp word ptr ss:[bp + REC_SAVED_X], 0
    je loc_08849
    mov word ptr ss:[bp + REC_SAVED_X], 0
    jmp near ptr loc_0BC45
loc_08849:
    mov word ptr ss:[bp + REC_SAVED_X], 0C0h
    jmp near ptr loc_0BC45
TypeHandler30:
    cmp word ptr ds:[LevelIndex], 5
    jne loc_08870
    mov ax, ds:[2380h]
    sub ax, ss:[bp + REC_X]
    jns loc_08862
    neg ax
loc_08862:
    cmp ax, 0Ch
    jb loc_08870
    cmp word ptr ss:[bp + REC_SPRITE], 46h
    jne loc_08870
    jmp near ptr loc_0BC45
loc_08870:
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 44h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0888E
    cmp word ptr ds:[2326h], 3
    jmp short loc_08893
loc_0888E:
    cmp word ptr ds:[232Ah], 0Fh
loc_08893:
    je loc_08898
    jmp near ptr loc_0BC45
loc_08898:
    call SpawnThrottledChild
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_088A7
    mov byte ptr ds:[SfxRequest], 0Eh
loc_088A7:
    jmp near ptr loc_0BC45
TypeHandler31:
    mov word ptr ss:[bp + REC_SPRITE], 2Eh
    add word ptr ss:[bp + REC_Y], 3
    jmp near ptr loc_0BC45
TypeHandler32:
    mov word ptr ss:[bp + REC_SPRITE], 24h
loc_088BB:
    cmp word ptr ss:[bp + REC_Y], 90h
    je loc_088C5
    jmp near ptr loc_0BC45
loc_088C5:
    mov word ptr ss:[bp + REC_TYPE], 33h
    mov word ptr ss:[bp + REC_DIRECTION], 7
TypeHandler33:
    call loc_0AFD8
    jne loc_088E1
    call loc_0AFD8
    jne loc_088E1
    call loc_0AFD8
    jne loc_088E1
    jmp near ptr loc_0BC45
loc_088E1:
    xor word ptr ss:[bp + REC_DIRECTION], 2
    jmp near ptr loc_0BC45
TypeHandler34:
    mov bx, ds:[LevelIndex]
    shl bx, 1
    mov bx, ds:[bx + Type34SpriteByLevel]
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_X], 60h
    jae loc_0893E
    dec word ptr ss:[bp + REC_SPRITE]
    cmp word ptr ds:[LevelIndex], 6
    je loc_0890C
    cmp word ptr ds:[LevelIndex], 0
    jne loc_08915
loc_0890C:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae loc_08915
    jmp near ptr loc_0BC45
loc_08915:
    cmp word ptr ds:[232Eh], 32h
    jae loc_0891F
    jmp near ptr loc_0BC45
loc_0891F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0892B
    mov byte ptr ds:[SfxRequest], 13h
loc_0892B:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    cmp word ptr ds:[CountGate2324], 1
    je loc_0897C
    mov word ptr ss:[bp + REC_DIRECTION], 3
    jmp short loc_0897C
loc_0893E:
    cmp word ptr ds:[LevelIndex], 6
    je loc_0894C
    cmp word ptr ds:[LevelIndex], 0
    jne loc_08955
loc_0894C:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae loc_08955
    jmp near ptr loc_0BC45
loc_08955:
    cmp word ptr ds:[232Eh], 32h
    jae loc_0895F
    jmp near ptr loc_0BC45
loc_0895F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0896B
    mov byte ptr ds:[SfxRequest], 13h
loc_0896B:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    cmp word ptr ds:[CountGate2324], 1
    je loc_0897C
    mov word ptr ss:[bp + REC_DIRECTION], 5
loc_0897C:
    call SpawnThrottledChild
    jmp near ptr loc_0BC45
TypeHandler37:
    mov ax, ds:[233Ch]
    add ax, 0B5h
    mov ss:[bp + REC_SPRITE], ax
    mov word ptr ds:[Type37Speed], 1
    cmp word ptr ss:[bp + REC_X], 60h
    je loc_089AF
    mov word ptr ds:[Type37Speed], 3
    cmp word ptr ss:[bp + REC_X], 50h
    je loc_089AF
    cmp word ptr ss:[bp + REC_X], 70h
    je loc_089AF
    mov word ptr ds:[Type37Speed], 5
loc_089AF:
    mov ax, ds:[Type37Speed]
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    je loc_089D1
    neg ax
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 8
    jna loc_089C6
    jmp near ptr loc_0BC45
loc_089C6:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    call SpawnThrottledChild
    jmp near ptr loc_0BC45
loc_089D1:
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 90h
    jae loc_089DE
    jmp near ptr loc_0BC45
loc_089DE:
    call SpawnThrottledChild
    mov word ptr ss:[bp + REC_DIRECTION], 0
    jmp near ptr loc_0BC45
TypeHandler83:
    mov ax, ds:[233Ch]
    add ax, 10h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[232Eh], 3Fh
    jne loc_089FC
    call loc_0BAE1
loc_089FC:
    jmp near ptr loc_0BB03
TypeHandler38:
    mov ax, 3
    cmp word ptr ss:[bp + REC_X], 0
    je loc_08A15
    mov ax, 5
    cmp word ptr ss:[bp + REC_X], 0C0h
    je loc_08A15
    mov ax, ss:[bp + REC_DIRECTION]
loc_08A15:
    mov ss:[bp + REC_DIRECTION], ax
    mov word ptr ss:[bp + REC_SPRITE], 6Eh
    call MoveInDirection2
    jmp near ptr loc_0BC45
TypeHandler39:
    mov word ptr ss:[bp + REC_SPRITE], 6Eh
    cmp word ptr ss:[bp + REC_Y], 80h
    jl loc_08A52
    jne loc_08A3D
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_08A3D
    mov byte ptr ds:[SfxRequest], 0Bh
loc_08A3D:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    call MoveInDirection4
    cmp word ptr ss:[bp + REC_X], 0C0h
    ja loc_08A4F
    jmp near ptr loc_0BC45
loc_08A4F:
    call loc_0BFC7
loc_08A52:
    jmp near ptr loc_0BC45
TypeHandler3A:
    mov bx, ds:[233Ch]
    shl bx, 1
    add bx, offset PingPongFrames4
    mov bx, ds:[bx]
    add bx, 0CCh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_Y], 80h
    jnl loc_08A72
    jmp near ptr loc_0BC45
loc_08A72:
    mov bx, 237Ch
    call loc_05E1B
    call loc_05E42
    jmp near ptr loc_0BC45
TypeHandler3B:
    call NextRandomWord
    and bx, 3
    mov cx, 0A9h
    cmp word ptr ds:[LevelIndex], 6
    je loc_08A95
    cmp word ptr ds:[LevelIndex], 0
    jne loc_08A98
loc_08A95:
    mov cx, 152h
loc_08A98:
    add bx, cx
    mov ss:[bp + REC_SPRITE], bx
    add word ptr ss:[bp + REC_Y], 2
    jmp near ptr loc_0BC45
TypeHandler3C:
    mov word ptr ss:[bp + REC_SPRITE], 0C5h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_08AB3
    jmp near ptr loc_0BC45
loc_08AB3:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_08ABF
    mov byte ptr ds:[SfxRequest], 1Dh
loc_08ABF:
    inc word ptr ss:[bp + REC_TYPE]
    mov word ptr ss:[bp + REC_DIRECTION], 7
TypeHandler3D:
    mov bx, ds:[233Ch]
    shl bx, 1
    add bx, offset PingPongFrames4
    mov bx, ds:[bx]
    add bx, 0C5h
    mov ss:[bp + REC_SPRITE], bx
    jmp near ptr TypeHandler33
TypeHandler3E:
    mov word ptr ss:[bp + REC_SPRITE], 0Eh
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jnl loc_08AEC
    jmp near ptr loc_0BC45
loc_08AEC:
    mov word ptr ss:[bp + REC_TYPE], 3Fh
    mov bx, bp
    call loc_074E2
TypeHandler3F:
    jmp near ptr TypeHandler60
TypeHandler68:
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 24h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 4
    je loc_08B4C
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0A1h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 5
    je loc_08B4C
    mov bx, ds:[233Ch]
    shl bx, 1
loc_08B2E:
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 100h
    mov ss:[bp + REC_SPRITE], bx
    jmp short loc_08B4C
TypeHandler40:
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
loc_08B4C:
    call NextRandomWord
    and bx, 1
    shl bx, 1
    add bx, offset JitterAxisFields
    mov si, ds:[bx]
    mov ax, ds:[232Eh]
    and ax, 1
    shl ax, 1
    dec ax
    add ss:[bp + si], ax
    cmp word ptr ss:[bp + REC_Y], 80h
    jnl loc_08B6F
    jmp near ptr loc_0BC45
loc_08B6F:
    cmp word ptr ds:[232Ch], 1Fh
    jne loc_08B79
    call SpawnThrottledChild
loc_08B79:
    add word ptr ss:[bp + REC_Y], 2
    jmp near ptr loc_0BC45
TypeHandler69:
    mov ax, ds:[232Ah]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    mov bx, 103h
    cmp word ptr ds:[LevelIndex], 4
    jne loc_08B96
    mov bx, 178h
loc_08B96:
    add ax, bx
    mov ss:[bp + REC_SPRITE], ax
    call NextRandomWord
    and bx, 1
    shl bx, 1
    add bx, offset JitterAxisFields
    mov si, ds:[bx]
    mov ax, ds:[232Eh]
    and ax, 1
    shl ax, 1
    dec ax
    shl ax, 1
    shl ax, 1
    add ss:[bp + si], ax
    cmp word ptr ss:[bp + REC_Y], 18h
    jng loc_08BC1
    jmp near ptr loc_0BC45
loc_08BC1:
    add word ptr ss:[bp + REC_Y], 8
    jmp near ptr loc_0BC45
TypeHandler41:
    mov word ptr ss:[bp + REC_FIELD_36], offset Type41Path
    jmp near ptr loc_0B2C8
TypeHandler43:
    mov word ptr ss:[bp + REC_FIELD_36], offset Type43Path
    jmp near ptr loc_0B2C8
TypeHandler44:
    mov word ptr ss:[bp + REC_FIELD_36], offset Type44Path
    jmp near ptr loc_0B2C8
TypeHandler45:
    mov word ptr ss:[bp + REC_FIELD_36], offset Type45Path
    jmp near ptr loc_0B2C8
TypeHandler4A:
    mov word ptr ss:[bp + REC_FIELD_36], offset Type4APath
    jmp near ptr loc_0B2C8
TypeHandler51:
    mov word ptr ss:[bp + REC_FIELD_36], offset Type51Path
    jmp near ptr loc_0B2C8
TypeHandler42:
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[232Eh], 1Fh
    ja loc_08C19
    dec word ptr ss:[bp + REC_X]
    jmp near ptr loc_0BC45
loc_08C19:
    inc word ptr ss:[bp + REC_X]
    jmp near ptr loc_0BC45
TypeHandler8A:
    mov ax, ds:[233Ch]
    add ax, 9Dh
    jmp near ptr loc_0B2AC
TypeHandler46:
    mov ax, ds:[2338h]
    add ax, 4Bh
    jmp near ptr loc_087B5
TypeHandler47:
    mov ax, ds:[2338h]
    add ax, 51h
    jmp near ptr loc_0B2AC
TypeHandler49:
    mov ax, 1Dh
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ds:[232Ah], 0Fh
    je loc_08C4E
    jmp near ptr loc_0BC45
loc_08C4E:
    mov cx, 8
loc_08C51:
    push cx
    call loc_07476
    pop cx
    cmp bx, -1
    jne loc_08C5E
    jmp near ptr loc_0BC45
loc_08C5E:
    mov word ptr ds:[bx + REC_TYPE], 4
    dec cx
    mov ds:[bx + REC_DIRECTION], cx
    inc cx
    loop loc_08C51
    jmp near ptr loc_0BC45
TypeHandler4B:
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_Y], 40h
    je loc_08C87
    jmp near ptr loc_0BC45
loc_08C87:
    mov word ptr ss:[bp + REC_TYPE], 33h
    mov word ptr ss:[bp + REC_DIRECTION], 1
    jmp near ptr TypeHandler33
TypeHandler4C:
    cmp word ptr ss:[bp + REC_DIRECTION], 0
    je loc_08CAE
    mov word ptr ss:[bp + REC_SPRITE], 74h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_08CA9
    jmp near ptr loc_0BC45
loc_08CA9:
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_08CAE:
    mov ax, ds:[2328h]
    shr ax, 1
    shr ax, 1
    add ax, 73h
    mov ss:[bp + REC_SPRITE], ax
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC4B
TypeHandler4D:
    mov word ptr ss:[bp + REC_SPRITE], 6Eh
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    jne loc_08CDC
    cmp word ptr ss:[bp + REC_Y], 80h
    je loc_08CD7
    jmp near ptr loc_0BC45
loc_08CD7:
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_08CDC:
    sub word ptr ss:[bp + REC_Y], 4
    cmp word ptr ss:[bp + REC_Y], 60h
    je loc_08CE9
    jmp near ptr loc_0BC4B
loc_08CE9:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    mov word ptr ss:[bp + REC_TYPE], 39h
    jmp near ptr TypeHandler39
TypeHandler4E:
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
    jmp near ptr loc_088BB
TypeHandler4F:
    mov ax, ds:[2328h]
    add ax, bp
    add ax, ds:[2340h]
    and ax, 7
    add ax, 80h
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC45
TypeHandler52:
    jmp near ptr loc_0BC45
TypeHandler53:
    mov bx, ds:[2328h]
    and bx, -2
    mov bx, ds:[bx + PingPongFrames4]
    add bx, ss:[bp + REC_FIELD_36]
    mov ss:[bp + REC_SPRITE], bx
    jmp near ptr loc_0BC45
; UNKNOWN: not yet classified as code or data
    db 0F8h,0C3h
TypeHandler48:
    call far ptr loc_0F9B2
    call loc_07476
    jmp near ptr loc_0BC45
TypeHandler7B:
    call far ptr loc_0FA4E
    jmp near ptr loc_0BC45
TypeHandler13:
    call far ptr loc_0FA6A
    jmp near ptr loc_0BC4B
TypeHandler81:
    call far ptr loc_0FC42
    jmp near ptr loc_0BC4B
TypeHandler93:
    call far ptr loc_0FC63
    cmp word ptr ss:[bp + REC_FIELD_36], 064h
    jae loc_08D6D
    jmp near ptr loc_0BC4B
loc_08D6D:
    call loc_0BFC7
    jmp near ptr loc_0BC4B
TypeHandler7F:
    call far ptr loc_0FE8A
    jmp near ptr loc_0BC4B
TypeHandler80:
    call far ptr loc_0FEA5
    jmp near ptr loc_0BC4B
loc_08D83:
    call far ptr loc_1009C
    jmp near ptr loc_0BC4B

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
    db 090h
; Built by BuildRowTables: offset of image n in its bank = n * its size, for level
; blocks (BlockBytes) and 8x8, 16x16 and 32x32 masked sprites (Sprite8Bytes ...).
BlockOffsets dw 256 dup (0)
Sprite8Offsets dw 256 dup (0)
Sprite16Offsets dw 256 dup (0)
Sprite32Offsets dw 256 dup (0)
MAIN ends

FAR0F7F segment byte public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
extrn loc_10044:near
extrn loc_10108:near
; Far: when a key was pressed (KeyLastMakeCode), advance every cheat code by it and
; apply the codes it completes, then clear KeyLastMakeCode.
CheckCheatCodes:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_0F89D
    call loc_0F8E4
    call loc_0F90B
    call loc_0F89E
    call loc_0F8AC
    call loc_0F8BA
    call loc_0F8C8
    call loc_0F8D6
    mov byte ptr ds:[KeyLastMakeCode], 0
loc_0F89D:
    retf

loc_0F89E:
    mov bx, offset CheatWhatOilShortage
    call MatchCheatKey
    jne loc_0F8AB
    mov byte ptr ds:[WhatOilShortageFlag], 1
loc_0F8AB:
    ret

loc_0F8AC:
    mov bx, offset CheatLifeInTheFastLane
    call MatchCheatKey
    jne loc_0F8B9
    mov byte ptr ds:[KeepLivesFlag], 1
loc_0F8B9:
    ret

loc_0F8BA:
    mov bx, offset CheatBonusCheatOn
    call MatchCheatKey
    jne loc_0F8C7
    mov byte ptr ds:[BonusKeysEnabled], 1
loc_0F8C7:
    ret

loc_0F8C8:
    mov bx, offset CheatMyNameIsSmith
    call MatchCheatKey
    jne loc_0F8D5
    mov byte ptr ds:[LevelSkipEnabled], 1
loc_0F8D5:
    ret

loc_0F8D6:
    mov bx, offset CheatGibStMirSchnellfeuer
    call MatchCheatKey
    jne loc_0F8E3
    mov byte ptr ds:[RapidFireEnabled], 1
loc_0F8E3:
    ret

loc_0F8E4:
    mov bx, offset CheatRemindMe
    call MatchCheatKey
    jne loc_0F90A
    mov byte ptr ds:[WhatOilShortageFlag], 1
    mov byte ptr ds:[KeepLivesFlag], 1
    mov byte ptr ds:[BonusKeysEnabled], 1
    mov byte ptr ds:[LevelSkipEnabled], 1
    mov byte ptr ds:[RapidFireEnabled], 1
    mov byte ptr ds:[AllCheatsFlag], 1
loc_0F90A:
    ret

loc_0F90B:
    mov bx, offset CheatEveryDayIDie
    call MatchCheatKey
    jne loc_0F931
    mov byte ptr ds:[WhatOilShortageFlag], 0
    mov byte ptr ds:[KeepLivesFlag], 0
    mov byte ptr ds:[BonusKeysEnabled], 0
    mov byte ptr ds:[LevelSkipEnabled], 0
    mov byte ptr ds:[RapidFireEnabled], 0
    mov byte ptr ds:[AllCheatsFlag], 0
loc_0F931:
    ret

; BX = cheat entry. On a match advance its cursor; ZF = 1 when that was the last
; scancode (then loc_05401 runs through the far bridge). A mismatch resets the cursor
; without retrying the key.
MatchCheatKey:
    mov di, word ptr ds:[bx]
    mov al, byte ptr ds:[KeyLastMakeCode]
    cmp al, byte ptr ds:[di]
    jne loc_0F94D
    inc word ptr ds:[bx]
    cmp byte ptr ds:[di + 1], 0
    jne loc_0F952
    mov bp, offset loc_05401
    call far ptr FarCallMainNearViaBP
    jmp short loc_0F952
loc_0F94D:
    mov word ptr ds:[bx], bx
    add word ptr ds:[bx], 2
loc_0F952:
    ret

loc_0F953:
    push bx
    push cx
    cmp word ptr ds:[02070h], 0
    je loc_0F976
    mov cx, 010h
    mov word ptr ds:[02098h], 0
    mov bx, 02078h
loc_0F968:
    cmp byte ptr ds:[bx], 0
    je loc_0F979
    add bx, 2
    inc word ptr ds:[02098h]
    loop loc_0F968
loc_0F976:
    mov bx, 0FFFFh
loc_0F979:
    mov word ptr ds:[0209Ah], bx
    pop cx
    pop bx
    retf

loc_0F980:
    mov ah, DOS_GET_VERSION
    xor al, al
    int 021h
    cmp al, 3
    jb loc_0F99C
    mov ah, DOS_ALLOC_STRATEGY
    mov al, 0
    int 021h
    mov word ptr ds:[SavedAllocStrategy], ax
    mov ah, DOS_ALLOC_STRATEGY
    mov al, 1
    mov bx, 1
    int 021h
loc_0F99C:
    retf

loc_0F99D:
    mov ah, DOS_GET_VERSION
    xor al, al
    int 021h
    cmp al, 3
    jb loc_0F9B1
    mov ah, DOS_ALLOC_STRATEGY
    mov al, 1
    mov bx, word ptr ds:[SavedAllocStrategy]
    int 021h
loc_0F9B1:
    retf
loc_0F9B2:
    cmp word ptr ds:[LevelIndex], 5
    je loc_0F9CD
    mov ax, 1Ch
    cmp word ptr ds:[LevelIndex], 3
    je loc_0F9F2
    mov ax, ds:[2328h]
    shr ax, 1
    add ax, 22h
    jmp short loc_0F9F2
loc_0F9CD:
    mov cx, 1
    mov ax, ss:[bp + REC_X]
    cmp ax, ds:[2380h]
    jb loc_0F9E1
    pushf
    neg cx
    popf
    ja loc_0F9E1
    xor cx, cx
loc_0F9E1:
    add ss:[bp + REC_X], cx
    mov bx, ds:[2336h]
    and bx, -2
    mov ax, ds:[bx + PingPongFrames4]
    add ax, 26h
loc_0F9F2:
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    retf

loc_0F9F9:
    mov word ptr ds:[LeaderScriptCursor], ax
    mov word ptr ds:[FormationSlotCursor], offset FormationSlots
    mov word ptr ds:[bx + 020h], 014h
    mov word ptr ds:[EncounterLiveCount], 1
    mov word ptr ds:[EncounterEndDelay], 064h
    mov word ptr ds:[02342h], 1
    mov word ptr ds:[02344h], 1
    mov word ptr ds:[02346h], 0
    mov word ptr ds:[02348h], 0
    mov word ptr ds:[EncounterTicks], 0
    call loc_10044
    call loc_10108
    retf

; Far. Spin until no KeyDownTable entry is set; only the keyboard IRQ can end the wait.
WaitAllKeysReleased:
    push ax
    push cx
    push di
loc_0FA3B:
    mov di, offset KeyDownTable - 1
    mov cx, KEY_DOWN_COUNT
    xor al, al
loc_0FA43:
    inc di
    or al, byte ptr ds:[di]
    loop loc_0FA43
    jne loc_0FA3B
    pop di
    pop cx
    pop ax
    retf
loc_0FA4E:
    mov word ptr ss:[bp + REC_SPRITE], 15Ch
    cmp word ptr ss:[bp + REC_Y], 90h
    jl loc_0FA69
    mov word ptr ss:[bp + REC_TYPE], 7Ch
    mov bx, bp
    mov ax, 74E2h
    call far ptr FarCallMainNearViaAX
loc_0FA69:
    retf
loc_0FA6A:
    mov si, word ptr ds:[LeaderScriptCursor]
    lodsw
    add ax, 020h
    mov word ptr ds:[SteerTargetY], ax
    lodsw
    mov word ptr ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 3
    mov ax, offset SteerTowardTarget
    call far ptr FarCallMainNearViaAX
    cmp word ptr ds:[SteerArrived], 0
    jne loc_0FA91
    jmp near ptr loc_0FC38
loc_0FA91:
    cmp word ptr ss:[bp + REC_TYPE], 013h
    jne loc_0FA9A
    jmp near ptr loc_0FC22
loc_0FA9A:
    cmp word ptr ss:[bp + REC_TYPE], 015h
    jne loc_0FAA3
    jmp near ptr loc_0FBD6
loc_0FAA3:
    cmp word ptr ss:[bp + REC_TYPE], 01Ch
    jne loc_0FAAC
    jmp near ptr loc_0FB96
loc_0FAAC:
    cmp word ptr ss:[bp + REC_TYPE], 01Fh
    jne loc_0FAB5
    jmp near ptr loc_0FB58
loc_0FAB5:
    cmp word ptr ss:[bp + REC_TYPE], 07Dh
    je loc_0FAF9
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    jne loc_0FAC8
    jmp near ptr loc_0FC38
loc_0FAC8:
    mov ax, offset loc_081F4
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne loc_0FAD8
    jmp near ptr loc_0FC38
loc_0FAD8:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + 034h], ax
    lodsw
    mov word ptr ds:[bx + 032h], ax
    mov word ptr ds:[bx + 018h], 07Fh
    mov word ptr ds:[bx + 01Ch], 014h
    mov word ptr ds:[bx + 020h], 5
    inc word ptr ds:[EncounterLiveCount]
    jmp near ptr loc_0FC38
loc_0FAF9:
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    jne loc_0FB06
    jmp near ptr loc_0FC38
loc_0FB06:
    mov ax, offset loc_081F4
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne loc_0FB16
    jmp near ptr loc_0FC38
loc_0FB16:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + 034h], ax
    lodsw
    mov word ptr ds:[bx + 032h], ax
    mov word ptr ds:[bx + 6], 2
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    test ax, 1
    je loc_0FB38
    mov word ptr ds:[bx + 6], 6
loc_0FB38:
    mov word ptr ds:[bx + 018h], 081h
    mov word ptr ds:[bx + 01Ch], 019h
    mov word ptr ds:[bx + 020h], 5
    mov word ptr ds:[bx + 0Ah], 0
    mov word ptr ds:[bx + 036h], 0
    inc word ptr ds:[EncounterLiveCount]
    jmp near ptr loc_0FC38
loc_0FB58:
    add word ptr ds:[LeaderScriptCursor], 4
    mov cx, 5
loc_0FB60:
    push cx
    mov ax, offset loc_081F4
    call far ptr FarCallMainNearViaAX
    mov si, word ptr ds:[FormationSlotCursor]
    add word ptr ds:[FormationSlotCursor], 4
    cmp bx, -1
    je loc_0FB90
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + 034h], ax
    lodsw
    mov word ptr ds:[bx + 032h], ax
    mov word ptr ds:[bx + 018h], 020h
    mov word ptr ds:[bx + 01Ch], 0FFFFh
    inc word ptr ds:[EncounterLiveCount]
loc_0FB90:
    pop cx
    loop loc_0FB60
    jmp near ptr loc_0FC38
loc_0FB96:
    add word ptr ds:[LeaderScriptCursor], 8
    mov ax, offset loc_081F4
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne loc_0FBAB
    jmp near ptr loc_0FC38
loc_0FBAB:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + 034h], ax
    lodsw
    mov word ptr ds:[bx + 032h], ax
    mov word ptr ds:[bx + 018h], 01Dh
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0FBCB
    mov word ptr ds:[bx + 018h], 01Eh
    mov word ptr ds:[bx + 8], 043h
loc_0FBCB:
    mov word ptr ds:[bx + 01Ch], 014h
    inc word ptr ds:[EncounterLiveCount]
    jmp short loc_0FC38
loc_0FBD6:
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    je loc_0FC38
    mov ax, offset loc_081F4
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_0FC38
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + 034h], ax
    lodsw
    mov word ptr ds:[bx + 032h], ax
    mov word ptr ds:[bx + 018h], 016h
    mov word ptr ds:[bx + 036h], offset SweepPath
    cmp word ptr ss:[bp + REC_Y], 040h
    je loc_0FC12
    mov word ptr ds:[bx + 018h], 017h
    mov word ptr ds:[bx + 036h], offset SweepPathLeadIn
loc_0FC12:
    mov word ptr ds:[bx + 01Ch], 014h
    mov word ptr ds:[bx + 020h], 3
    inc word ptr ds:[EncounterLiveCount]
    jmp short loc_0FC38
loc_0FC22:
    add word ptr ds:[LeaderScriptCursor], 4
    mov ax, offset loc_081F4
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_0FC38
    inc word ptr ds:[EncounterLiveCount]
loc_0FC38:
    mov ax, word ptr ss:[bp + REC_DIRECTION]
    add ax, 03Bh
    mov word ptr ss:[bp + REC_SPRITE], ax
    retf
loc_0FC42:
    mov word ptr ss:[bp + REC_SPRITE], 016Ah
    mov word ptr ds:[SteerSpeed], 1
    push word ptr ss:[bp + REC_DIRECTION]
    mov ax, offset loc_0B729
    call far ptr FarCallMainNearViaAX
    pop word ptr ss:[bp + REC_DIRECTION]
    je loc_0FC62
    mov word ptr ss:[bp + REC_TYPE], 093h
loc_0FC62:
    retf
loc_0FC63:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript7DEnd
    je loc_0FC6E
    jmp near ptr loc_0FE69
loc_0FC6E:
    cmp word ptr ss:[bp + REC_FIELD_1C], 0
    je loc_0FC7C
    dec word ptr ss:[bp + REC_FIELD_1C]
    je loc_0FC7C
    jmp near ptr loc_0FE69
loc_0FC7C:
    cmp word ptr ss:[bp + REC_DIRECTION], 0
    je loc_0FCC5
    cmp word ptr ss:[bp + REC_DIRECTION], 1
    je loc_0FCC5
    cmp word ptr ss:[bp + REC_DIRECTION], 7
    je loc_0FCC5
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    jne loc_0FD12
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FCC0
    cmp word ptr ss:[bp + REC_Y], 0D0h
    jae loc_0FCC0
    jmp near ptr loc_0FE75
loc_0FCC0:
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_0FCC5:
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    je loc_0FCD2
    call loc_0FE76
loc_0FCD2:
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    je loc_0FCDF
    call loc_0FE76
loc_0FCDF:
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    je loc_0FCEC
    call loc_0FE76
loc_0FCEC:
    jne loc_0FCF8
    mov word ptr ss:[bp + REC_FIELD_36], 0
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_0FCF8:
    cmp word ptr ss:[bp + REC_Y], 020h
    jbe loc_0FD01
    jmp near ptr loc_0FE75
loc_0FD01:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    test word ptr ss:[bp + REC_X], 2
    je loc_0FD12
    mov word ptr ss:[bp + REC_DIRECTION], 2
loc_0FD12:
    mov ax, word ptr ds:[0232Ah]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    add ax, 016Ah
    mov word ptr ss:[bp + REC_SPRITE], ax
    cmp byte ptr ds:[Type93KilledPulse], 0
    je loc_0FD5B
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], 4
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    pop word ptr ss:[bp + REC_DIRECTION]
loc_0FD5B:
    mov ax, word ptr ds:[02340h]
    and ax, 0FFh
    cmp ax, 0FFh
    jne loc_0FD72
    mov ax, offset loc_0BAE1
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[02340h]
loc_0FD72:
    cmp word ptr ds:[02340h], 0
    je loc_0FD81
    cmp word ptr ds:[02340h], 02BDh
    jne loc_0FD8D
loc_0FD81:
    mov ax, offset loc_07476
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[02340h]
loc_0FD8D:
    cmp word ptr ss:[bp + REC_X], 0
    je loc_0FE08
    cmp word ptr ss:[bp + REC_X], 0C0h
    je loc_0FDA5
    cmp word ptr ss:[bp + REC_DIRECTION], 6
    je loc_0FDA3
    jmp near ptr loc_0FE35
loc_0FDA3:
    jmp short loc_0FDD2
loc_0FDA5:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
loc_0FDD2:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    jmp short loc_0FE69
loc_0FE01:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    jmp short loc_0FE69
loc_0FE08:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
loc_0FE35:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, offset loc_0AFD8
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    jmp short loc_0FE69
loc_0FE64:
    mov word ptr ss:[bp + REC_DIRECTION], 6
loc_0FE69:
    cmp word ptr ss:[bp + REC_Y], 080h
    jb loc_0FE75
    mov word ptr ss:[bp + REC_DIRECTION], 4
loc_0FE75:
    retf
loc_0FE76:
    inc word ptr ss:[bp + REC_FIELD_36]
    mov word ptr ss:[bp + REC_DIRECTION], 7
    cmp word ptr ss:[bp + REC_X], 060h
    ja loc_0FE89
    mov word ptr ss:[bp + REC_DIRECTION], 1
loc_0FE89:
    ret
loc_0FE8A:
    mov word ptr ss:[bp + REC_SPRITE], 162h
    mov word ptr ds:[2308h], 1
    mov ax, 0B729h
    call far ptr FarCallMainNearViaAX
    je loc_0FEA4
    mov word ptr ss:[bp + REC_TYPE], 80h
loc_0FEA4:
    retf
loc_0FEA5:
    cmp word ptr ds:[LeaderScriptCursor], 0A79Ch
    je loc_0FEB0
    jmp near ptr loc_1000C
loc_0FEB0:
    cmp word ptr ss:[bp + REC_FIELD_1C], 0
    je loc_0FEBE
    dec word ptr ss:[bp + REC_FIELD_1C]
    je loc_0FEBE
    jmp near ptr loc_1000C
loc_0FEBE:
    cmp byte ptr ds:[MarchStepNow], 0
    je loc_0FECB
    mov ax, ds:[MarchStepX]
    add ss:[bp + REC_SAVED_X], ax
loc_0FECB:
    mov ax, ss:[bp + REC_SPRITE]
    cmp ax, 164h
    jb loc_0FED6
    jmp near ptr loc_0FF9E
loc_0FED6:
    mov ax, ds:[2340h]
    and ax, 0FFh
    cmp ax, 7Dh
    je loc_0FEE5
    or ax, ax
    jne loc_0FEF6
loc_0FEE5:
    inc word ptr ds:[2340h]
    mov word ptr ss:[bp + REC_SPRITE], 164h
    mov word ptr ss:[bp + REC_HIT_POINTS], 3
    jmp near ptr loc_1000C
loc_0FEF6:
    cmp byte ptr ds:[MarchFireNow], 0
    je loc_0FF0E
    mov byte ptr ds:[MarchFireNow], 0
    mov ax, 7476h
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[2340h]
loc_0FF0E:
    cmp byte ptr ds:[MarchStepNow], 0
    je loc_0FF2C
    mov ax, ds:[MarchStepX]
    add ss:[bp + REC_X], ax
    cmp word ptr ss:[bp + REC_X], 0
    je loc_0FF28
    cmp word ptr ss:[bp + REC_X], 0C0h
    jne loc_0FF2C
loc_0FF28:
    inc byte ptr ds:[MarchEdgeHit]
loc_0FF2C:
    mov ax, ss:[bp + REC_SAVED_Y]
    cmp ax, ss:[bp + REC_Y]
    je loc_0FF73
    mov ax, ss:[bp + REC_SAVED_X]
    and ax, 0FFFEh
    and word ptr ss:[bp + REC_X], -2
    mov ds:[2304h], ax
    mov ax, ss:[bp + REC_SAVED_Y]
    and ax, 0FFFEh
    and word ptr ss:[bp + REC_Y], -2
    mov ds:[2306h], ax
    mov word ptr ds:[2308h], 1
    mov ax, 5DB2h
    call far ptr FarCallMainNearViaAX
    mov word ptr ss:[bp + REC_SPRITE], 160h
    mov ax, ds:[2328h]
    shr ax, 1
    shr ax, 1
    jne loc_0FF6D
    jmp near ptr loc_1000C
loc_0FF6D:
    inc word ptr ss:[bp + REC_SPRITE]
    jmp near ptr loc_1000C
loc_0FF73:
    cmp byte ptr ds:[MarchDropNow], 0
    je loc_0FF8E
    add word ptr ss:[bp + REC_Y], 0Ch
    add word ptr ss:[bp + REC_SAVED_Y], 0Ch
    cmp word ptr ss:[bp + REC_Y], 0B0h
    jb loc_0FF8E
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
loc_0FF8E:
    mov ax, ss:[bp + REC_X]
    shr ax, 1
    and ax, 1
    add ax, 162h
    mov ss:[bp + REC_SPRITE], ax
    jmp short loc_1000C
loc_0FF9E:
    cmp byte ptr ds:[MarchDropNow], 0
    je loc_0FFB5
    add word ptr ss:[bp + REC_SAVED_Y], 0Ch
    cmp word ptr ss:[bp + REC_SAVED_Y], 0B0h
    jb loc_0FFB5
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
loc_0FFB5:
    cmp ax, 168h
    jae loc_0FFC6
    cmp word ptr ds:[2326h], 3
    jne loc_1000C
    inc word ptr ss:[bp + REC_SPRITE]
    jmp short loc_1000C
loc_0FFC6:
    add word ptr ss:[bp + REC_Y], 5
    mov word ptr ss:[bp + REC_SPRITE], 168h
    mov ax, ds:[2328h]
    shr ax, 1
    shr ax, 1
    je loc_0FFDB
    inc word ptr ss:[bp + REC_SPRITE]
loc_0FFDB:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jna loc_1000C
    mov word ptr ss:[bp + REC_Y], 0
    cmp word ptr ds:[2326h], 3
    je loc_10002
loc_0FFEE:
    mov ax, 4D95h
    call far ptr FarCallMainNearViaAX
    cmp bl, 0C0h
    ja loc_0FFEE
    xor bh, bh
    mov ss:[bp + REC_X], bx
    jmp short loc_1000C
loc_10002:
    mov word ptr ss:[bp + REC_SPRITE], 160h
    mov word ptr ss:[bp + REC_HIT_POINTS], 5
loc_1000C:
    retf
FAR0F7F ends
end