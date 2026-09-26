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
extrn ChaseNegX:word
extrn ChaseNegY:word
extrn ChaseQuadrantBits:word
extrn ChaseStepPixels:word
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
extrn DropKind:word
extrn DropX:word
extrn DropY:word
extrn EncounterEndDelay:word
extrn EncounterLiveCount:word
extrn EncounterTicks:word
extrn EnergyCells:word
extrn EnergyCellsEnd:word
extrn EnergyPoints:word
extrn EnergyTanks:word
extrn ExitOrderScreen:word
extrn ExitWithError:byte
extrn FileBufferOffset:word
extrn FileBufferSegment:word
extrn FileNamePtr:word
extrn FileNotFoundMsgHead:byte
extrn FileNotFoundMsgTail:byte
extrn FileStatus:word
extrn FormationSlotCursor:word
extrn FormationSlots:word
extrn FrameCount128:word
extrn FrameCount16:word
extrn FrameCount32:word
extrn FrameCount4:word
extrn FrameCount64:word
extrn FrameCount8:word
extrn FrameDivider4:word
extrn FrontPodRecord:word
extrn Fuel:word
extrn FuelGaugeOffset:word
extrn GroupDropKind:word
extrn GroupDropKinds:byte
extrn GroupSlotIndex:word
extrn GroupSlotPtr:word
extrn GroupTable:byte
extrn HiscoreBlankLine:byte
extrn HiscoreBlock:byte
extrn HiscoreEntryRow:byte
extrn HiscoreFileName:byte
extrn HiscoreNameBuffer:byte
extrn HiscoreNameCursor:word
extrn HiscoreNamePrefix:byte
extrn HiscorePageList:word
extrn HiscoreQualified:word
extrn HiscoreRankPrefix:byte
extrn HiscoreRowPrefix:byte
extrn HudTankCompare:word
extrn IPageList:word
extrn InputBits:byte
extrn InputDeviceMode:word
extrn JitterAxisFields:word
extrn KeepLivesFlag:byte
extrn KeyBitScancodesA:byte
extrn KeyBitScancodesB:byte
extrn KeyDownTable:byte
extrn KeyLastMakeCode:byte
extrn LastKeyExtended:word
extrn LeaderScript7DEnd:word
extrn LeaderScript7EEnd:word
extrn LeaderScriptCursor:word
extrn LevelDigitChars:byte
extrn LevelIndex:word
extrn LevelMapCellHandlers:word
extrn LevelMusicTable:byte
extrn LevelNumberPrefix:byte
extrn LevelScriptClock:word
extrn LevelSkipEnabled:byte
extrn LivesLeft:word
extrn LoadSettingsFromHiscoreBlock:far
extrn MapCellX:word
extrn MapRowCellsLeft:word
extrn MapRowCursor:word
extrn MapScrollPos:word
extrn MarchDropNow:byte
extrn MarchEdgeHit:byte
extrn MarchFireNow:byte
extrn MarchStepNow:byte
extrn MarchStepX:word
extrn MenuIdleFrames:word
extrn MenuKeyLatchA:word
extrn MenuKeyLatchK:word
extrn MenuKeyLatchM:word
extrn MenuShowingHiscores:word
extrn MissileAmmo:word
extrn ModuleSoundEnabled:byte
extrn ModuleSoundRequest:byte
extrn OPageList:word
extrn OkMenuPageList:word
extrn PingPongFrames4:word
extrn PingPongFrames8:word
extrn PoolA:byte
extrn PoolACursor:word
extrn PoolAEnd:byte
extrn PoolAPointers:word
extrn PoolB:byte
extrn PoolBCursor:word
extrn PoolBEnd:byte
extrn PrimaryRecord:byte
extrn QuitAnswer:byte
extrn RapidFireEnabled:byte
extrn RecordTickCounter:word
extrn RedefPageList:word
extrn RedefPromptRow:byte
extrn RefuelActive:word
extrn SavedAllocStrategy:word
extrn SavedUpgradeSlot:word
extrn ScoreBcd:byte
extrn ScoreMessagePrefix:byte
extrn ScrollDeltaY:word
extrn ScrollSubRow:word
extrn ScrollWindowOffset:word
extrn ScrollingBackward:word
extrn SegBossActive:word
extrn SelectedUpgradeSlot:word
extrn SfxActive:byte
extrn SfxEnabled:byte
extrn SfxRequest:byte
extrn ShowPageList:far
extrn SidePodLeftInner:word
extrn SidePodLeftOuter:word
extrn SidePodRightInner:word
extrn SidePodRightOuter:word
extrn SideShotsEnabled:word
extrn SlowCount10:word
extrn SlowCount3:word
extrn SlowCount4:word
extrn SlowCount5:word
extrn SlowCount6:word
extrn SlowCount8:word
extrn SoundModuleSlot:far
extrn SoundOption:word
extrn SoundOptionFlags:byte
extrn Sprite32Bytes:word
extrn SteerArrived:word
extrn SteerSpeed:word
extrn SteerTargetX:word
extrn SteerTargetY:word
extrn SwayDirX:word
extrn SwayDropY:word
extrn SwayPhase:word
extrn SwayReversals:word
extrn SweepPath:word
extrn SweepPathLeadIn:word
extrn ThrustDrainToggle:word
extrn TrailingPodFar:word
extrn TrailingPodNear:word
extrn TurretPhaseTable:word
extrn Type21LeaderPathBody:far
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
extrn WeaponMode:word
extrn WhatOilShortageFlag:byte
extrn XorCodeHiscoreBlock:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public AdapterDrawHandlers
public AddScoreBcd
public AdvanceToAvailableUpgrade
public AimAtPlayer
public AllocGroupSlot
public AllocPoolBRecordEvicting
public AllocRecordEvicting
public ApplyFrontPod
public ApplySelectedUpgrade
public ApplySidePods
public ApplyTrailingPods
public BlitPackedStride104
public BlitPackedStride160
public BlitPackedToScreen
public BlockOffsets
public CheckCheatCodes
public ClearScreen104x200
public CollapseScreenAndClear
public CollapseScreenWithSfx
public CopyEgaPage0ToPage1
public CopyFullWorkspaceToScreen
public CopyWorkspaceToScreen
public DecodeByte5BA0
public DecodeByte5BA1
public DecodeDest
public DecodeFileFlags
public DecodeGraphicsImages
public DecodeImageIndex
public DecodePixelBytes
public DecodePlaneBits
public DecodePlaneRowBytes
public DecodeRowBuffer
public DecodeRows
public DrawEnergyGauge
public DrawFuelGauge
public DrawHud
public DrawMapRowBlocks
public DrawOffsetFromPlayfieldRow
public DrawOffsetFromScreenRow
public DrawOffsetFromWideRow
public DrawPanelGraphic
public DrawRecordSprite
public DrawSprite8Record
public DrawUpgradeSlots
public FarCallMainNearViaAX
public FindFreeRecordPoolA
public FindFreeRecordPoolB
public FrontPodAvailable
public InitEnemyRecordHere
public InitUpgradeSlots
public InsertHighScore
public Level0MapCell
public Level1MapCell
public Level2MapCell
public Level3MapCell
public Level4MapCell
public Level5MapCell
public LoadHiscoreFile
public PlayerShotsHitRecord
public RecordWorkspaceOffset
public RequestLifeStartMusic
public ResetPageAndClearScreen
public RestoreRecordBackground
public RunOptionsMenu
public SaveRecordBackground
public ScrollMapToLevelStart
public SetBestFitAllocStrategy
public SetDeltaToward
public SetHiscoreRankColor
public ShutdownGame
public SidePodsAvailable
public SmartBombAll
public SpawnAimedShot
public SpawnEnemyHere
public SpawnEnemyHereQuiet
public SpawnFromMapRow
public SpawnItemDrop
public Sprite16Offsets
public Sprite32Offsets
public Sprite8Offsets
public StartLeaderScript
public SteerTowardTarget
public StepAlongDelta
public StretchDest
public StretchFlagA
public StretchFlagB
public StretchImageRows
public StretchInHudPanel
public StretchInTheEndImage
public StretchInWindowImage
public StretchRowBytes
public StretchRowError
public StretchShownRows
public StretchSource
public TickFrameTimers
public TickRefuel
public TrailingPodsAvailable
public Type13FormationLeader
public Type24TurretLeftFire32
public Type25TurretRightFire32
public Type26WallProbeExtender
public Type27SlowDescender
public Type28EnemyHatch
public Type29EmergeThenDart
public Type2BAimedDart
public Type2DHoverFireThenPlunge
public Type2EPlungeAtPlayerColumn
public Type2FScrollingShuttle
public Type30AnimatedShooter
public Type31FallFast3
public Type32DescendThenBounce
public Type33TerrainBouncer
public Type34SideFiringTurret
public Type37VerticalBouncerShooter
public Type38WallBounceDescend
public Type39DashRightAtRow80
public Type3AHomeOnPlayerBelow80
public Type3BFallRandomFlicker
public Type3CDescendThenBounceAlt
public Type3DAnimatedTerrainBouncer
public Type3EDropThenAimedDash
public Type3FStraightLineToAimPoint
public Type40JitterFallShooter
public Type41FollowPathType41
public Type42DescendSway
public Type43FollowPathType43
public Type44FollowPathType44
public Type45FollowPathType45
public Type46HoverShootThenDive
public Type47PatrolDropShooter
public Type48CreeperAimedFire
public Type49RadialBurstFaller
public Type4AFollowPathType4A
public Type4BDescendThenBounceUpRight
public Type4CSinkThenRise
public Type4DSinkRiseThenDash
public Type4EAnimDescendThenBounce
public Type4FFallFast4Flicker
public Type51FollowType51Path
public Type52ScrollOnly
public Type53AnimateFromSpriteBase
public Type60FlyAlongAimLine
public Type68JitterDescendFiring
public Type69JitterDropToY18
public Type71FireThenDiveBelow60
public Type7AAimLineFlyer
public Type7BDropThenAim
public Type7CAimLineFlyerAlt
public Type7FMarchEnterSteer
public Type80MarchFormationMember
public Type81SweeperEnterSteer
public Type83PatrolShootDown64
public Type8APatrolShootDown32Alt
public Type8FAnimFireBurstB
public Type90TurretVolley
public Type91TurretVolleyAlt
public Type93SweepDescendClimb
public UpdateRefuelTimersAndScore
public loc_05D0B
public loc_08331
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
public loc_084C9
public loc_084D6
public loc_084F0
public loc_084FD
public loc_0878C
public loc_08D83
extrn AddFrontPod:near
extrn AddSidePods:near
extrn AddTrailingPod:near
extrn BlitPackedStride104Cga:near
extrn BlitPackedStride104Ega:near
extrn BlitPackedStride160Cga:near
extrn BlitPackedStride160Ega:near
extrn BlitPackedToScreenCga:near
extrn BlitPackedToScreenEga:near
extrn CalibrateJoystickWithAbort:near
extrn ClearCga16K:near
extrn ClearEgaPages:near
extrn ClearKeyDownTable:near
extrn ClearScreen104x200Cga:near
extrn ClearScreen104x200Ega:near
extrn ClearTandy104x200:near
extrn ClearTandy32K:near
extrn CopyFullWorkspaceToScreenCga:near
extrn CopyFullWorkspaceToScreenEga:near
extrn CopyFullWorkspaceToScreenTandy:near
extrn CopyPackedRowsStride104:near
extrn CopyPackedRowsStride160:near
extrn CopyPackedRowsToTandyBanks:near
extrn CopyWorkspace104x192ToTandy:near
extrn CopyWorkspaceToScreenCga:near
extrn CopyWorkspaceToScreenEga:near
extrn CountXReturn:near
extrn DecodeGraphicsImagesCga:near
extrn DecodeGraphicsImagesEga:near
extrn DecodeGraphicsImagesTandy:near
extrn DestroyRecord:near
extrn DrainFuelUnit:near
extrn DrawMapRowBlocksCga:near
extrn DrawMapRowBlocksEga:near
extrn DrawMapRowBlocksTandy:near
extrn DrawOffsetFromPlayfieldRowCga:near
extrn DrawOffsetFromPlayfieldRowEga:near
extrn DrawOffsetFromScreenRowCga:near
extrn DrawOffsetFromScreenRowEga:near
extrn DrawOffsetFromWideRowCga:near
extrn DrawOffsetFromWideRowEga:near
extrn DrawSprite16Shift0Cga:near
extrn DrawSprite16Shift0Ega:near
extrn DrawSprite16Shift1Cga:near
extrn DrawSprite16Shift1Ega:near
extrn DrawSprite16Shift2Cga:near
extrn DrawSprite16Shift2Ega:near
extrn DrawSprite16Shift3Cga:near
extrn DrawSprite16Shift3Ega:near
extrn DrawSprite16Shift4Ega:near
extrn DrawSprite16Shift5Ega:near
extrn DrawSprite16Shift6Ega:near
extrn DrawSprite16Shift7Ega:near
extrn DrawSprite16Tandy:near
extrn DrawSprite32Shift0Cga:near
extrn DrawSprite32Shift0Ega:near
extrn DrawSprite32Shift1Cga:near
extrn DrawSprite32Shift1Ega:near
extrn DrawSprite32Shift2Cga:near
extrn DrawSprite32Shift2Ega:near
extrn DrawSprite32Shift3Cga:near
extrn DrawSprite32Shift3Ega:near
extrn DrawSprite32Shift4Ega:near
extrn DrawSprite32Shift5Ega:near
extrn DrawSprite32Shift6Ega:near
extrn DrawSprite32Shift7Ega:near
extrn DrawSprite32Tandy:near
extrn DrawSprite8Shift0Cga:near
extrn DrawSprite8Shift0Ega:near
extrn DrawSprite8Shift1Cga:near
extrn DrawSprite8Shift1Ega:near
extrn DrawSprite8Shift2Cga:near
extrn DrawSprite8Shift2Ega:near
extrn DrawSprite8Shift3Cga:near
extrn DrawSprite8Shift3Ega:near
extrn DrawSprite8Shift4Ega:near
extrn DrawSprite8Shift5Ega:near
extrn DrawSprite8Shift6Ega:near
extrn DrawSprite8Shift7Ega:near
extrn DrawSprite8Tandy:near
extrn DrawStretchedImageCga:near
extrn DrawStretchedImageEga:near
extrn DrawStretchedImageTandy:near
extrn FinishRecordUpdate:near
extrn FlashSprite16Shift0Cga:near
extrn FlashSprite16Shift0Ega:near
extrn FlashSprite16Shift1Cga:near
extrn FlashSprite16Shift1Ega:near
extrn FlashSprite16Shift2Cga:near
extrn FlashSprite16Shift2Ega:near
extrn FlashSprite16Shift3Cga:near
extrn FlashSprite16Shift3Ega:near
extrn FlashSprite16Shift4Ega:near
extrn FlashSprite16Shift5Ega:near
extrn FlashSprite16Shift6Ega:near
extrn FlashSprite16Shift7Ega:near
extrn FlashSprite16Tandy:near
extrn FlashSprite32Shift0Cga:near
extrn FlashSprite32Shift0Ega:near
extrn FlashSprite32Shift1Cga:near
extrn FlashSprite32Shift1Ega:near
extrn FlashSprite32Shift2Cga:near
extrn FlashSprite32Shift2Ega:near
extrn FlashSprite32Shift3Cga:near
extrn FlashSprite32Shift3Ega:near
extrn FlashSprite32Shift4Ega:near
extrn FlashSprite32Shift5Ega:near
extrn FlashSprite32Shift6Ega:near
extrn FlashSprite32Shift7Ega:near
extrn FlashSprite32Tandy:near
extrn FlipEgaDrawPage:near
extrn HorizontalTerrainPatrol:near
extrn InstallKeyboardVector09:near
extrn LevelMapSegment:word
extrn LevelSpritesSegment:word
extrn LoadFileToBuffer:near
extrn MainDataSegment:word
extrn ManExplSegment:word
extrn MoveInDirection1:near
extrn MoveInDirection2:near
extrn MoveInDirection3:near
extrn MoveInDirection4:near
extrn MoveInDirection8:near
extrn NextRandomWord:near
extrn PanelImageOffsets:word
extrn PanelSegment:word
extrn PollInputBits:near
extrn PrintMessageBP:near
extrn PrintTextChar:near
extrn RecordScreenOffsetCga:near
extrn RecordScreenOffsetEga:near
extrn RecordScreenOffsetTandy:near
extrn RecordWorkspaceOffsetCga:near
extrn RecordWorkspaceOffsetEga:near
extrn RecordWorkspaceOffsetTandy:near
extrn ReleaseEmsCache:near
extrn RemoveRecordAtBX:near
extrn RequestModuleMusic:near
extrn ResetEgaPages:near
extrn RestoreBackground16Cga:near
extrn RestoreBackground16Ega:near
extrn RestoreBackground16Tandy:near
extrn RestoreBackground32Cga:near
extrn RestoreBackground32Ega:near
extrn RestoreBackground32Tandy:near
extrn RestoreBackground8Cga:near
extrn RestoreBackground8Ega:near
extrn RestoreBackground8Tandy:near
extrn RestoreKeyboardVector09:near
extrn RestoreTimerVector08:near
extrn RunAttractSequence:near
extrn SaveBackground16Cga:near
extrn SaveBackground16Ega:near
extrn SaveBackground16Tandy:near
extrn SaveBackground32Cga:near
extrn SaveBackground32Ega:near
extrn SaveBackground32Tandy:near
extrn SaveBackground8Cga:near
extrn SaveBackground8Ega:near
extrn SaveBackground8Tandy:near
extrn SaveHiscoreFile:near
extrn ScreenSegment:word
extrn ScrollBackwardOneLine:near
extrn ScrollRecordThenFinish:near
extrn ScrollStartOffset:word
extrn ShotHitsRecord:near
extrn ShowBossKeyScreen:near
extrn SpawnShotDown:near
extrn SpawnThrottledChild:near
extrn Sprites1x1Segment:word
extrn Sprites2x2CSegment:word
extrn Sprites2x2Segment:word
extrn StartPathFollow:near
extrn SteerToSaved:near
extrn StopModuleMusic:near
extrn TandyOffsetFromPlayfieldRow:near
extrn TandyOffsetFromScreenRow:near
extrn TandyOffsetFromWideRow:near
extrn TheEndSegment:word
extrn TryTerrainStep:near
extrn VideoAdapter:word
extrn WaitVerticalRetrace:near
extrn WorkspaceSegment:word
extrn loc_0B2AC:near
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

; SS:BP = BCD score: when it makes the table, shifts the lower entries down, shows the
; table and reads the player's name.
InsertHighScore:
    mov byte ptr ds:[HiscoreEntryRow], 4
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
    add byte ptr ds:[HiscoreEntryRow], 2
    add bx, 010h
    loop loc_05338
    ret
loc_0535D:
    mov word ptr ds:[HiscoreQualified], 1
    mov es, word ptr cs:[MainDataSegment]
    std
    mov si, offset HiscoreBlock + 7Fh
    mov di, offset HiscoreBlock + 8Fh
loc_0536F:
    movsb
    cmp si, bx
    jne loc_0536F
    movsb
    cld
    mov di, bx
    push di
    call ShowHighScoreTable
    mov ah, 0A8h
    mov al, 0
    mov si, 056h
    call DrawPanelGraphic
    mov dl, 0
    mov dh, byte ptr ds:[HiscoreEntryRow]
    mov ah, 2
    mov bh, 0
    int 010h
    mov dx, offset HiscoreBlankLine
    mov ah, DOS_PRINT_STRING
    int 021h
    mov al, byte ptr ds:[HiscoreEntryRow]
    mov byte ptr ds:[HiscoreRankPrefix + 1], al
    mov bp, offset HiscoreRankPrefix
    call PrintMessageBP
    mov bp, offset ScoreBcd
    call PrintBcd32
    mov al, byte ptr ds:[HiscoreEntryRow]
    mov byte ptr ds:[HiscoreNamePrefix + 1], al
    mov word ptr ds:[HiscoreNameCursor], offset HiscoreNameBuffer
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset HiscoreNameBuffer
    mov al, 020h
    mov cx, 0Ah
    rep stosb
    mov al, 0
    stosb
loc_053C9:
    mov bp, offset HiscoreNamePrefix
    call PrintMessageBP
    mov bp, offset HiscoreNameBuffer
    call PrintMessageBP
    call ReadKeyThroughDos
    cmp al, 8
    je loc_05408
    cmp al, 0Dh
    je loc_0541E
    cmp word ptr ds:[HiscoreNameCursor], offset HiscoreNameBuffer + 0Ah
    je loc_053FC
    cmp al, 020h
    jb loc_053C9
    cmp al, 07Ah
    ja loc_053C9
    mov di, word ptr ds:[HiscoreNameCursor]
    mov byte ptr ds:[di], al
    inc word ptr ds:[HiscoreNameCursor]
    jmp short loc_053C9
loc_053FC:
    call BiosBeep
    jmp short loc_053C9

BiosBeep:
    mov al, 7
    mov ah, 0Eh
    int 010h
    ret
loc_05408:
    cmp word ptr ds:[HiscoreNameCursor], offset HiscoreNameBuffer
    je loc_053FC
    dec word ptr ds:[HiscoreNameCursor]
    mov di, word ptr ds:[HiscoreNameCursor]
    mov al, 020h
    mov byte ptr ds:[di], al
    jmp short loc_053C9
loc_0541E:
    cmp word ptr ds:[HiscoreNameCursor], offset HiscoreNameBuffer + 0Ah
    je loc_05433
    mov di, word ptr ds:[HiscoreNameCursor]
    mov byte ptr ds:[di], 020h
    inc word ptr ds:[HiscoreNameCursor]
    jmp short loc_0541E
loc_05433:
    pop di
    mov es, word ptr cs:[MainDataSegment]
    mov si, offset HiscoreNameBuffer
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
; Row being drawn while listing the high scores.
HiscoreRowIndex db 0

ShowHighScoreTable:
    mov ax, offset HiscorePageList
    call far ptr ShowPageList
    mov byte ptr cs:[HiscoreRowIndex], 0
    mov cx, 8
loc_05461:
    push cx
    mov al, byte ptr cs:[HiscoreRowIndex]
    shl al, 1
    add al, 4
    mov byte ptr ds:[HiscoreRowPrefix + 1], al
    mov bp, offset HiscoreRowPrefix
    call PrintMessageBP
    mov al, byte ptr cs:[HiscoreRowIndex]
    xor ah, ah
    mov cx, 010h
    mul cx
    mov bp, offset HiscoreBlock
    add bp, ax
    push bp
    call PrintMessageBP
    pop bp
    lea bp, ss:[bp + 0Ch]
    call PrintBcd32
    pop cx
    inc byte ptr cs:[HiscoreRowIndex]
    loop loc_05461
    ret

; Reads a key through DOS (BIOS INT 09h restored meanwhile); AL = key, also in
; QuitAnswer.
ReadKeyThroughDos:
    mov ds, word ptr cs:[MainDataSegment]
    call RestoreKeyboardVector09
    mov word ptr ds:[LastKeyExtended], 0
    mov ah, DOS_CHAR_INPUT_NO_ECHO
    int 021h
    cmp al, 0
    je loc_054AF
    jmp short loc_054B7
loc_054AF:
    int 021h
    mov word ptr ds:[LastKeyExtended], 1
loc_054B7:
    mov byte ptr ds:[QuitAnswer], al
    push ax
    call InstallKeyboardVector09
    pop ax
    ret

SetHiscoreRankColor:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_054CE
    mov byte ptr ds:[HiscoreRankPrefix + 4], 0Ah
    ret
loc_054CE:
    mov byte ptr ds:[HiscoreRankPrefix + 4], 3
    ret

; Draws the input-mode and sound-option graphics with the current choices highlighted.
DrawOptionsSelections:
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

; Title menu: input mode, sound, key redefinition, info pages, boss key; alternates with
; the high scores and the intro when idle. Returns on the primary button.
RunOptionsMenu:
    mov word ptr ds:[MenuShowingHiscores], 0
loc_0555F:
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne loc_05576
    call far ptr WaitAllKeysReleased
    mov ax, offset OkMenuPageList
    call far ptr ShowPageList
    call DrawOptionsSelections
loc_05576:
    cmp word ptr ds:[MenuShowingHiscores], 0
    je loc_05582
    call ShowHighScoreTable
    jmp short loc_05585
loc_05582:
    call DrawOptionsSelections
loc_05585:
    mov word ptr ds:[MenuIdleFrames], 0
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
    mov word ptr ds:[MenuKeyLatchK], 0
    mov word ptr ds:[MenuKeyLatchA], 0
    mov word ptr ds:[MenuKeyLatchM], 0
loc_055EE:
    call WaitVerticalRetrace
    inc word ptr ds:[MenuIdleFrames]
    cmp word ptr ds:[MenuIdleFrames], 02EEh
    jb loc_05613
    cmp word ptr ds:[MenuShowingHiscores], 0
    je loc_0560A
    call RunAttractSequence
    jmp near ptr RunOptionsMenu
loc_0560A:
    mov word ptr ds:[MenuShowingHiscores], 1
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
    jmp near ptr RunOptionsMenu
loc_0562C:
    mov ax, offset IPageList
    call far ptr ShowPageList
    jmp near ptr RunOptionsMenu
loc_05637:
    call ShowBossKeyScreen
    jmp near ptr RunOptionsMenu
loc_0563D:
    cmp word ptr ds:[MenuKeyLatchK], 1
    je loc_055EE
    mov word ptr ds:[MenuKeyLatchK], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05656
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05656:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne loc_05666
    jmp near ptr loc_05576
loc_05666:
    jmp near ptr RunOptionsMenu
loc_05669:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05675
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05675:
    cmp byte ptr ds:[KeyDownTable + SCAN_J], KEY_STATE_DOWN
    je loc_05675
    call StopModuleMusic
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
    jmp near ptr RunOptionsMenu
loc_056A5:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_056A5
    jmp near ptr RunOptionsMenu
loc_056B2:
    cmp word ptr ds:[MenuKeyLatchA], 1
    jne loc_056BC
    jmp near ptr loc_055EE
loc_056BC:
    mov word ptr ds:[MenuKeyLatchA], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_056CE
    mov byte ptr ds:[SfxRequest], 01Ch
loc_056CE:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne loc_056DE
    jmp near ptr loc_05576
loc_056DE:
    jmp near ptr RunOptionsMenu
loc_056E1:
    cmp word ptr ds:[MenuKeyLatchM], 1
    jne loc_056EB
    jmp near ptr loc_055EE
loc_056EB:
    mov word ptr ds:[MenuKeyLatchM], 1
    inc word ptr ds:[SoundOption]
    and word ptr ds:[SoundOption], 3
    mov bx, word ptr ds:[SoundOption]
    shl bx, 1
    mov bx, word ptr ds:[bx + SoundOptionFlags]
    mov byte ptr ds:[SfxEnabled], bh
    mov byte ptr ds:[ModuleSoundEnabled], bl
    cmp bl, 0
    jne loc_05714
    call StopModuleMusic
loc_05714:
    mov al, 2
    call RequestModuleMusic
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_05725
    mov byte ptr ds:[SfxRequest], 01Ch
loc_05725:
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne loc_0572F
    jmp near ptr loc_05576
loc_0572F:
    jmp near ptr RunOptionsMenu
loc_05732:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0573E
    mov byte ptr ds:[SfxRequest], 01Ch
loc_0573E:
    cmp byte ptr ds:[KeyDownTable + SCAN_R], KEY_STATE_DOWN
    je loc_0573E
    mov ax, offset RedefPageList
    call far ptr ShowPageList
    mov byte ptr ds:[RedefPromptRow], 03Fh
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
    jmp near ptr RunOptionsMenu

; Show prompt graphic SI, wait for a key other than Esc/F9/F10, store its scancode at DI
; and wait for its release.
PromptAndCaptureKeyBinding:
    push di
    mov byte ptr ds:[KeyLastMakeCode], 0
    mov ah, byte ptr ds:[RedefPromptRow]
    add byte ptr ds:[RedefPromptRow], 017h
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

CollapseScreenWithSfx:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_057F4
loc_057ED:
    cmp byte ptr ds:[SfxActive], 0
    jne loc_057ED
loc_057F4:
    cmp byte ptr ds:[SfxEnabled], 0
    je CollapseScreenAndClear
    mov byte ptr ds:[SfxRequest], 5

CollapseScreenAndClear:
    call CaptureAndCollapseScreen
    mov ds, word ptr cs:[MainDataSegment]
    jmp near ptr ResetPageAndClearScreen

; Captures the screen as a packed image in the workspace and redraws it squashed
; vertically, fewer rows per retrace.
CaptureAndCollapseScreen:
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
    jmp word ptr cs:[bx + CaptureScreenRowCases]
CaptureScreenRowCases label word
    dw CaptureScreenRowCga, CaptureScreenRowEga, CaptureScreenRowTandy    ; per VideoAdapter: CGA, EGA, Tandy

CaptureScreenRowCga:
    mov cx, 050h
    rep movsb
    sub si, 050h
    add si, 02000h
    test si, 04000h
    je loc_05850
    add si, 0C050h
loc_05850:
    jmp short loc_05895

CaptureScreenRowEga:
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

CaptureScreenRowTandy:
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
    mov word ptr cs:[StretchImageRows], ax
    lodsw
    mov word ptr cs:[StretchRowBytes], ax
    mov word ptr cs:[StretchSource], si
    mov word ptr cs:[StretchDest], di
    mov word ptr cs:[StretchFlagA], 0
    mov word ptr cs:[StretchFlagB], 0
    mov es, word ptr cs:[ScreenSegment]
    mov cx, word ptr cs:[StretchImageRows]
    sub cx, 2
loc_058DF:
    push cx
    mov word ptr cs:[StretchShownRows], cx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop loc_058DF
    ret
; State of the vertical stretch/squash drawers of packed images (AdapterDrawHandlers):
; destination, source, rows and bytes per row from the image header, rows shown
; (spread evenly by the StretchRowError accumulator), two alternating flags, and a word
; used only by the uncalled variant below.
StretchDest dw 0
StretchSource dw 0
StretchImageRows dw 0
StretchRowBytes dw 0
StretchShownRows dw 0
StretchRowError dw 0
StretchFlagA dw 0
StretchFlagB dw 0
StretchWord5909 dw 0
; Uncalled variant of the progressive drawer.
loc_0590B:
loc_0590B:
    mov byte ptr ss:[KeyLastMakeCode], 0
    lodsw
    mov cs:[StretchImageRows], ax
    lodsw
    mov cs:[StretchRowBytes], ax
    mov cs:[StretchSource], si
    mov cs:[StretchDest], di
    mov word ptr cs:[StretchFlagA], 0
    mov word ptr cs:[StretchFlagB], 0
    mov word ptr cs:[StretchWord5909], 0
    mov es, cs:[ScreenSegment]
loc_0593F:
    push cx
    call SquashAndStretchUntilInput
    jne loc_05953
    call SquashAndStretchUntilInput
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
    dw offset DrawStretchedImageCga, offset DrawStretchedImageEga, offset DrawStretchedImageTandy
; Step of the unused loc_0590B; AX = 1 (NZ) when a key or the primary button stops it.
SquashAndStretchUntilInput:
    mov cx, cs:[StretchImageRows]
    sub cx, 2
loc_05968:
    push cx
    mov cs:[StretchShownRows], cx
    mov bx, cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    push ds
    mov ds, cs:[MainDataSegment]
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_059E7
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_059E7
    pop ds
    call WaitVerticalRetrace
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop loc_05968
    xor word ptr cs:[StretchFlagA], 1
    xor word ptr cs:[StretchFlagB], 1
    mov cx, cs:[StretchImageRows]
    sub cx, 2
    add word ptr cs:[StretchShownRows], 2
loc_059B6:
    push cx
    add word ptr cs:[StretchShownRows], 2
    mov bx, cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    push ds
    mov ds, cs:[MainDataSegment]
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
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
; BP = record: AX = screen offset of REC_Y/REC_X. No caller found.
RecordScreenOffset:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + RecordScreenOffsetCases]
; NOP filler: word-aligns the table.
    db 90h
RecordScreenOffsetCases label word
    dw offset RecordScreenOffsetCga, offset RecordScreenOffsetEga, offset RecordScreenOffsetTandy

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
; BP = record: AX = its WorkspaceSegment offset (FFFFh when off the playfield) and
; REC_PIXEL_PHASE for the blitters. Also ticks the gameplay REC_FLASH_TIMER down: the
; renderer owns that countdown.
RecordWorkspaceOffset:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + RecordWorkspaceOffsetCases]
RecordWorkspaceOffsetCases label word
    dw RecordWorkspaceOffsetCga, RecordWorkspaceOffsetEga, RecordWorkspaceOffsetTandy    ; per VideoAdapter: CGA, EGA, Tandy

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
; BX = LevelMap offset, DI = workspace: draws the 13 16x16 blocks of one map row.
DrawMapRowBlocks:
    mov dx, bx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + DrawMapRowBlocksCases]
DrawMapRowBlocksCases label word
    dw DrawMapRowBlocksCga, DrawMapRowBlocksEga, DrawMapRowBlocksTandy    ; per VideoAdapter: CGA, EGA, Tandy

; BP = record: copies REC_SAVE_BUFFER back at REC_WORK_OFS (and the lower half).
RestoreRecordBackground:
    mov es, word ptr cs:[WorkspaceSegment]
    mov di, word ptr ss:[bp + REC_WORK_OFS]
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + RestoreRecordBackgroundCases]
; Indexed by VideoAdapter*3 + REC_SIZE_CLASS (CGA, EGA, Tandy; sizes 0..2).
RestoreRecordBackgroundCases label word
    dw offset RestoreBackground8Cga, offset RestoreBackground16Cga, offset RestoreBackground32Cga
    dw offset RestoreBackground8Ega, offset RestoreBackground16Ega, offset RestoreBackground32Ega
    dw offset RestoreBackground8Tandy, offset RestoreBackground16Tandy, offset RestoreBackground32Tandy

; BP = record: sets REC_WORK_OFS and saves the workspace under it to REC_SAVE_BUFFER.
SaveRecordBackground:
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    add bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + SaveRecordBackgroundCases]
; NOP filler (word alignment).
    db 90h
SaveRecordBackgroundCases label word
    dw offset SaveBackground8Cga, offset SaveBackground16Cga, offset SaveBackground32Cga, offset SaveBackground8Ega
    dw offset SaveBackground16Ega, offset SaveBackground32Ega, offset SaveBackground8Tandy, offset SaveBackground16Tandy
    dw offset SaveBackground32Tandy
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
; Per-file flag bytes (the word before the file name when PerFileFlagsEnabled = 1, else FFFFh).
DecodeFileFlags dw 0
; DS:SI = file, ES:DI = destination, BP = per-file flags or FFFFh: decodes all images.
DecodeGraphicsImages:
    mov word ptr cs:[DecodeFileFlags], bp
    mov word ptr cs:[DecodeImageIndex], 0FFFFh
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + DecodeGraphicsImagesCases]
DecodeGraphicsImagesCases label word
    dw DecodeGraphicsImagesCga, DecodeGraphicsImagesEga, DecodeGraphicsImagesTandy    ; per VideoAdapter: CGA, EGA, Tandy

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

; Clears the whole video buffer for the adapter (CGA 16K, EGA both pages, Tandy 32K),
; after showing EGA page 0 again. Leaves ES = ScreenSegment.
ResetPageAndClearScreen:
    call ResetEgaPages
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + ResetPageAndClearScreenCases]
; NOP filler (word alignment).
    db 90h
ResetPageAndClearScreenCases label word
    dw offset ClearCga16K, offset ClearEgaPages, offset ClearTandy32K

; Copies 200 workspace rows to the screen from offset 0. Returns DS = MainDataSegment.
CopyFullWorkspaceToScreen:
    xor di, di
    xor si, si
    mov bp, 0C8h
    mov es, word ptr cs:[ScreenSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + CopyFullWorkspaceToScreenCases]
CopyFullWorkspaceToScreenCases label word
    dw CopyFullWorkspaceToScreenCga, CopyFullWorkspaceToScreenEga, CopyFullWorkspaceToScreenTandy    ; per VideoAdapter: CGA, EGA, Tandy

; Clears the screen, then stretches in the WINDOW.BIC image (WorkspaceSegment+7D1h:0) at
; the top left.
StretchInWindowImage:
    call ResetPageAndClearScreen
    xor di, di
    xor si, si
    mov ax, word ptr cs:[WorkspaceSegment]
    add ax, 07D0h
    inc ax
    mov ds, ax
    jmp short StretchInImage

; Game over: clears the screen and stretches in THEND.BIC at row 4Eh (falls into
; StretchInImage).
StretchInTheEndImage:
    call ResetPageAndClearScreen
    mov ah, 04Eh
    xor al, al
    call DrawOffsetFromScreenRow
    xor si, si
    mov ds, word ptr cs:[TheEndSegment]

; DS:SI = image (rows word, bytes-per-row word, data), DI = screen offset: draws it through
; AdapterDrawHandlers once per retrace, growing StretchShownRows by 2 each time.
; Returns DS = MainDataSegment.
StretchInImage:
    lodsw
    mov word ptr cs:[StretchImageRows], ax
    lodsw
    mov word ptr cs:[StretchRowBytes], ax
    mov word ptr cs:[StretchSource], si
    mov word ptr cs:[StretchDest], di
    mov word ptr cs:[StretchFlagA], 0
    mov word ptr cs:[StretchFlagB], 0
    mov word ptr cs:[StretchShownRows], 6
    mov es, word ptr cs:[ScreenSegment]
loc_05C74:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    call WaitVerticalRetrace
    add word ptr cs:[StretchShownRows], 2
    mov ax, word ptr cs:[StretchShownRows]
    cmp ax, word ptr cs:[StretchImageRows]
    jne loc_05C74
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Clears the screen and stretches in the HUD frame (panel image 25h); falls through into
; CopyEgaPage0ToPage1.
StretchInHudPanel:
    call ResetPageAndClearScreen
    mov ax, 01Bh
    call DrawOffsetFromScreenRow
    mov si, 025h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call StretchInImage

; EGA only: latch copy (write mode 1) of page 0 to page 2000h so both pages match.
CopyEgaPage0ToPage1:
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
; Print DX as four hex digits with BIOS teletype output (INT 10h AH=0Eh). No caller
; found in this image.
DebugPrintHexDX:
    push dx
    xchg dh, dl
    call DebugPrintHexDL
    pop dx
DebugPrintHexDL:
    push dx
    shr dl, 1
    shr dl, 1
    shr dl, 1
    shr dl, 1
    call DebugPrintHexDigit
    pop dx
DebugPrintHexDigit:
    and dl, 0Fh
    cmp dl, 0Ah
    jb loc_05D01
    add dl, 7
loc_05D01:
    add dl, 30h
    mov al, dl
    mov ah, 0Eh
    int 10h
    ret
loc_05D0B:
    mov ds, word ptr cs:[MainDataSegment]
    inc byte ptr ds:[ExitWithError]
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
    call ResetEgaPages
    call StopModuleMusic
    call RestoreKeyboardVector09
    call RestoreTimerVector08
    mov ax, 3
    int 010h
    cmp byte ptr ds:[ExitWithError], 0
    je loc_05D7E
    mov dx, offset FileNotFoundMsgHead
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
    mov dx, offset FileNotFoundMsgTail
    mov ah, DOS_PRINT_STRING
    int 021h
    call ReleaseEmsCache
    call far ptr RestoreAllocStrategy
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
    call far ptr RestoreAllocStrategy
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
; NOP filler (word alignment).
    db 90h
StepBySteerSpeed label word
    dw offset MoveInDirection1, offset MoveInDirection2, offset MoveInDirection4, offset MoveInDirection8
loc_05E14:
    mov word ptr ds:[SteerArrived], 1
    ret
; BX = target record: sets BP's REC_DELTA toward it.
SetDeltaToward:
    mov dx, 4
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je loc_05E27
    mov dx, 0Ch
loc_05E27:
    mov ax, ss:[bp + REC_X]
    mov cx, ds:[bx + REC_X]
    add cx, dx
    sub ax, cx
    mov ss:[bp + REC_DELTA_X], ax
    mov ax, ss:[bp + REC_Y]
    mov cx, ds:[bx + REC_Y]
    add cx, dx
    sub ax, cx
    mov ss:[bp + REC_DELTA_Y], ax
    ret
; Bresenham step of ChaseStepPixels (3, or 2) along BP's REC_DELTA.
StepAlongDelta:
    mov word ptr ds:[ChaseNegX], 0
    mov word ptr ds:[ChaseNegY], 0
    mov word ptr ds:[ChaseQuadrantBits], 0
    mov ax, word ptr ss:[bp + REC_DELTA_X]
    or ax, ax
    jns loc_05E61
    neg ax
    inc word ptr ds:[ChaseNegX]
loc_05E61:
    mov bx, word ptr ss:[bp + REC_DELTA_Y]
    or bx, bx
    jns loc_05E6E
    neg bx
    inc word ptr ds:[ChaseNegY]
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
    call SetChaseXQuadrantBit
    jmp short loc_05E99
loc_05E93:
    call SetChaseXQuadrantBit
loc_05E96:
    call SetChaseYQuadrantBit
loc_05E99:
    mov bx, offset DirectionFromQuadrant
    mov ax, word ptr ds:[ChaseQuadrantBits]
    xlat
    cmp al, 0FFh
    jne loc_05EA5
    ret
loc_05EA5:
    mov word ptr ss:[bp + REC_DIRECTION], ax
    cmp word ptr ds:[ChaseStepPixels], 3
    jne loc_05EB2
    jmp near ptr MoveInDirection3
loc_05EB2:
    jmp near ptr MoveInDirection2
; StepAlongDelta helper: ChaseQuadrantBits bit 1 if ChaseNegX = 1, else bit 2.
SetChaseXQuadrantBit:
    cmp word ptr ds:[ChaseNegX], 1
    je loc_05EC2
    or word ptr ds:[ChaseQuadrantBits], 2
    ret
loc_05EC2:
    or word ptr ds:[ChaseQuadrantBits], 1
    ret
; StepAlongDelta helper: ChaseQuadrantBits bit 4 if ChaseNegY = 1, else bit 8.
SetChaseYQuadrantBit:
    cmp word ptr ds:[ChaseNegY], 1
    je loc_05ED5
    or word ptr ds:[ChaseQuadrantBits], 8
    ret
loc_05ED5:
    or word ptr ds:[ChaseQuadrantBits], 4
    ret

; Prints ScoreMessagePrefix and the 8 digits of ScoreBcd (falls into PrintBcd32).
DrawScore:
    mov bp, offset ScoreMessagePrefix
    call PrintMessageBP
    mov bp, offset ScoreBcd

; SS:BP = 4-byte packed BCD, least significant byte first: prints 8 digits.
PrintBcd32:
    mov al, byte ptr ss:[bp + 3]
    call PrintBcdByte
    mov al, byte ptr ss:[bp + 2]
    call PrintBcdByte
    mov al, byte ptr ss:[bp + 1]
    call PrintBcdByte
    mov al, byte ptr ss:[bp]

; AL = packed BCD byte: prints both digits.
PrintBcdByte:
    push ax
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    call PrintBcdDigit
    pop ax

; Prints the low nibble of AL as '0'..'9'.
PrintBcdDigit:
    and al, 0Fh
    add al, 030h
    jmp near ptr PrintTextChar

; BX = 4-digit packed BCD points, added to ScoreBcd. Preserves AX, DX and BP.
AddScoreBcd:
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

; Music for the start of a life: 4 at MapScrollPos 9Ch, 5 at 0EA0h, else
; LevelMusicTable[LevelIndex].
RequestLifeStartMusic:
    mov al, 4
    cmp word ptr ds:[MapScrollPos], MAP_START_POS
    je loc_05F5E
    mov al, 5
    cmp word ptr ds:[MapScrollPos], MAP_END_POS
    je loc_05F5E
    mov bx, offset LevelMusicTable
    mov al, byte ptr ds:[LevelIndex]
    xlat
loc_05F5E:
    jmp near ptr RequestModuleMusic


; Per frame: restores the level music once an encounter has ended, updates the sway and
; frame counters, then TickFuelDrain.
TickFrameTimers:
    cmp word ptr ds:[EncounterLiveCount], 0
    jne loc_05F89
    cmp word ptr ds:[EncounterEndDelay], 0
    je loc_05F89
    dec word ptr ds:[EncounterEndDelay]
    jne loc_05F89
    mov bx, offset LevelMusicTable
    mov al, byte ptr ds:[LevelIndex]
    xlat
    cmp word ptr ds:[MapScrollPos], MAP_MUSIC_CHANGE_POS
    jb loc_05F86
    mov al, 6
loc_05F86:
    call RequestModuleMusic
loc_05F89:
    cmp word ptr ds:[FrameCount8], 7
    jne loc_05FBA
    cmp word ptr ds:[SwayDirX], -1
    je loc_05FAC
    inc word ptr ds:[SwayPhase]
    cmp word ptr ds:[SwayPhase], 2
    jne loc_05FBA
    neg word ptr ds:[SwayDirX]
    inc word ptr ds:[SwayReversals]
    jmp short loc_05FBA
loc_05FAC:
    dec word ptr ds:[SwayPhase]
    jne loc_05FBA
    neg word ptr ds:[SwayDirX]
    inc word ptr ds:[SwayReversals]
loc_05FBA:
    and word ptr ds:[SwayReversals], 0Fh
    jne loc_05FCB
    mov word ptr ds:[SwayDropY], 8
    inc word ptr ds:[SwayReversals]
loc_05FCB:
    inc word ptr ds:[FrameDivider4]
    and word ptr ds:[FrameDivider4], 3
    jne loc_06030
    inc word ptr ds:[SlowCount10]
    cmp word ptr ds:[SlowCount10], 0Ah
    jb loc_05FE7
    mov word ptr ds:[SlowCount10], 0
loc_05FE7:
    inc word ptr ds:[SlowCount6]
    cmp word ptr ds:[SlowCount6], 6
    jb loc_05FF8
    mov word ptr ds:[SlowCount6], 0
loc_05FF8:
    inc word ptr ds:[SlowCount5]

    cmp word ptr ds:[SlowCount5], 5
    jb loc_06009
    mov word ptr ds:[SlowCount5], 0
loc_06009:
    inc word ptr ds:[SlowCount3]
    cmp word ptr ds:[SlowCount3], 3
    jb loc_0601A
    mov word ptr ds:[SlowCount3], 0
loc_0601A:
    inc word ptr ds:[SlowCount4]
    and word ptr ds:[SlowCount4], 3
    inc word ptr ds:[SlowCount8]
    and word ptr ds:[SlowCount8], 7
    inc word ptr ds:[EncounterTicks]
loc_06030:
    xor word ptr ds:[CountGate2324], 1
    inc word ptr ds:[FrameCount4]
    and word ptr ds:[FrameCount4], 3
    inc word ptr ds:[FrameCount8]
    and word ptr ds:[FrameCount8], 7
    inc word ptr ds:[FrameCount16]
    and word ptr ds:[FrameCount16], 0Fh
    inc word ptr ds:[FrameCount32]
    and word ptr ds:[FrameCount32], 01Fh
    inc word ptr ds:[FrameCount64]
    and word ptr ds:[FrameCount64], 03Fh
    inc word ptr ds:[FrameCount128]
    and word ptr ds:[FrameCount128], 07Fh
    call TickFuelDrain
    ret

; Drains one Fuel unit every 64 frames (DifficultySetting above 1) or every 128, plus
; one more per FrameCount32 wrap in ship form 2.
TickFuelDrain:
    cmp word ptr ds:[DifficultySetting], 1
    jbe loc_0607D
    cmp word ptr ds:[FrameCount64], 03Fh
    jmp short loc_06082
loc_0607D:
    cmp word ptr ds:[FrameCount128], 07Fh
loc_06082:
    jne loc_06087
    call DrainFuelUnit
loc_06087:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 2
    je loc_0608F
    ret
loc_0608F:
    cmp word ptr ds:[FrameCount32], 01Fh
    je loc_06097
    ret
loc_06097:
    xor word ptr ds:[ThrustDrainToggle], 1
    je loc_0609F
    ret
loc_0609F:
    jmp near ptr DrainFuelUnit

UpdateRefuelTimersAndScore:
    call TickRefuel
    call TickFrameTimers
    call DrawScore
    ret

; Level load: scrolls the map from 0EA0h back to the level start (MapScrollPos 9Ch), 16
; pixels at a time, then LevelScriptClock -= 3.
ScrollMapToLevelStart:
    mov ax, word ptr cs:[ScrollStartOffset]
    mov word ptr ds:[ScrollWindowOffset], ax
    mov word ptr ds:[ScrollSubRow], 0
    mov word ptr ds:[ScrollingBackward], 0
    mov word ptr ds:[LevelScriptClock], 0
    mov word ptr ds:[MapScrollPos], MAP_END_POS
loc_060CB:
    mov cx, 010h
loc_060CE:
    push cx
    call ScrollBackwardOneLine
    pop cx
    loop loc_060CE
    cmp word ptr ds:[MapScrollPos], MAP_START_POS
    jne loc_060CB
    sub word ptr ds:[LevelScriptClock], 3
    ret

DrawLevelNumber:
    mov bp, offset LevelNumberPrefix
    call PrintMessageBP
    mov bx, offset LevelDigitChars
    mov ax, word ptr ds:[LevelIndex]
    xlat
    jmp near ptr PrintTextChar

; Draws LivesLeft ship icons and 3 - LivesLeft empty ones (panel images 1Eh, 1Fh).
DrawLivesIcons:
    mov al, 01Fh
    mov ah, 050h
    call DrawOffsetFromScreenRow
    mov si, 01Eh
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov cx, word ptr ds:[LivesLeft]
    call DrawPanelImageRow
    mov si, 01Fh
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov cx, 3
    sub cx, word ptr ds:[LivesLeft]

; SI = image in PanelSegment, CX = copies (0 allowed), DI = screen offset; each copy
; advances DI two 8-pixel columns. Returns DS = MainDataSegment.
DrawPanelImageRow:
    jcxz loc_06138
    push si
    push di
    push cx
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop cx
    pop di
    pop si
    call AdvanceDrawColumn
    call AdvanceDrawColumn
    loop DrawPanelImageRow
loc_06138:
    mov ds, word ptr cs:[MainDataSegment]
    ret

; DI += one 8-pixel column in screen bytes (CGA 2, EGA 1, Tandy 4). Clobbers BX.
AdvanceDrawColumn:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + AdvanceDrawColumnCases]
AdvanceDrawColumnCases label word
    dw AdvanceDrawColumnCga, AdvanceDrawColumnEga, AdvanceDrawColumnTandy    ; per VideoAdapter: CGA, EGA, Tandy

AdvanceDrawColumnCga:
    add di, 2
    ret

AdvanceDrawColumnEga:
    inc di
    ret

AdvanceDrawColumnTandy:
    add di, 4
    ret

; DI -= one 8-pixel column in screen bytes (CGA 2, EGA 1, Tandy 4). Clobbers BX.
RetreatDrawColumn:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + RetreatDrawColumnCases]
RetreatDrawColumnCases label word
    dw RetreatDrawColumnCga, RetreatDrawColumnEga, RetreatDrawColumnTandy    ; per VideoAdapter: CGA, EGA, Tandy

RetreatDrawColumnCga:
    sub di, 2
    ret

RetreatDrawColumnEga:
    dec di
    ret

RetreatDrawColumnTandy:
    sub di, 4
    ret

; Draws score, lives, energy gauge and level number (on both pages on EGA).
DrawHud:
    call DrawScore
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0618A
    call FlipEgaDrawPage
    call DrawScore
    call FlipEgaDrawPage
loc_0618A:
    call DrawLivesIcons
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0619E
    call FlipEgaDrawPage
    call DrawLivesIcons
    call FlipEgaDrawPage
loc_0619E:
    call DrawEnergyGauge
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_061B2
    call FlipEgaDrawPage
    call DrawEnergyGauge
    call FlipEgaDrawPage
loc_061B2:
    call DrawLevelNumber
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_061C6
    call FlipEgaDrawPage
    call DrawLevelNumber
    call FlipEgaDrawPage
loc_061C6:
    ret

DecrementFirstEnergyCell:
    mov di, offset EnergyCells
loc_061CA:
    cmp word ptr ds:[di], 0
    je loc_061D2
    dec word ptr ds:[di]
    ret
loc_061D2:
    add di, 2
    cmp di, offset EnergyCellsEnd
    jne loc_061CA
    ret

; Rebuilds EnergyCells from EnergyPoints and draws the six cells, then the tank image
; (20h + EnergyTanks). Preserves BP.
DrawEnergyGauge:
    push bp
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset EnergyCells
    mov cx, 6
    mov ax, 4
    rep stosw
    mov cx, word ptr ds:[EnergyPoints]
    jcxz loc_061FC
    or cx, cx
    js loc_061FC
loc_061F7:
    call DecrementFirstEnergyCell
    loop loc_061F7
loc_061FC:
    mov ah, 040h
    mov al, 01Fh
    call DrawOffsetFromScreenRow
    mov ds, word ptr cs:[PanelSegment]
    mov si, word ptr ss:[EnergyCells]
    call DrawEnergyCell
    mov si, word ptr ss:[EnergyCells + 2]
    call DrawEnergyCell
    mov si, word ptr ss:[EnergyCells + 4]
    call DrawEnergyCell
    mov si, word ptr ss:[EnergyCells + 6]
    call DrawEnergyCell
    mov si, word ptr ss:[EnergyCells + 8]
    call DrawEnergyCell
    mov si, word ptr ss:[EnergyCells + 0Ah]
    call DrawEnergyCell
    mov ds, word ptr cs:[MainDataSegment]
    mov ax, word ptr ds:[EnergyTanks]
    cmp ax, word ptr ds:[HudTankCompare]
    je loc_06294
    mov al, 01Fh
    mov ah, 0Ch
    call DrawOffsetFromScreenRow
    mov si, 0
    cmp word ptr ds:[EnergyTanks], -1
    je loc_0625B
    mov si, word ptr ds:[EnergyTanks]
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

; SI = cell value 0..4: draws panel image 19h + SI at DI and advances DI one column.
DrawEnergyCell:
    add si, 019h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    push di
    call BlitPackedToScreen
    pop di
    jmp near ptr AdvanceDrawColumn

; Item 3: SmartBombRecord on every live pool A record.
SmartBombAll:
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
    call SmartBombRecord
loc_062CC:
    pop cx
    loop loc_062BA
    pop bp
    ret

SmartBombRecord:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe loc_062D9
    ret
loc_062D9:
    cmp word ptr ss:[bp + REC_KIND], KIND_ENEMY
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
    jmp near ptr DestroyRecord
; BP = record: tests every live player shot in pool B (unrolled over all 34 records)
; against BP's 8-pixel cells (two columns and rows, four for size class 2) and hands
; the first hit to ShotHitsRecord.
PlayerShotsHitRecord:
    cmp word ptr ss:[bp + REC_STATUS], 0
    jne loc_062FF
    jmp near ptr PlayerShotsMissed
loc_062FF:
    cmp word ptr ss:[bp + REC_Y], 020h
    jge loc_06308
    jmp near ptr PlayerShotsMissed
loc_06308:
    cmp word ptr ss:[bp + REC_KIND], KIND_SCENERY
    jne loc_06311
    jmp near ptr PlayerShotsMissed
loc_06311:
    cmp word ptr ss:[bp + REC_TYPE], 0
    jne loc_0631A
    jmp near ptr PlayerShotsMissed
loc_0631A:
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne loc_06323
    jmp near ptr PlayerShotsMissed
loc_06323:
    cmp word ptr ss:[bp + REC_TYPE], 026h
    jne loc_0632C
    jmp near ptr PlayerShotsMissed
loc_0632C:
    mov si, word ptr ss:[bp + REC_KIND]
    mov di, word ptr ss:[bp + REC_DRAW_PASS]
    mov dx, word ptr ss:[bp + REC_X]
    and dx, 0FFF8h
    mov cx, word ptr ss:[bp + REC_Y]
    and cx, 0FFF8h
    mov bx, offset PoolB
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_063BD
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_063BD
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0638D
    jmp near ptr ShotHitsRecord
loc_0638D:
    sub ax, 8
    cmp ax, cx
    jne loc_06397
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_063B3:
    sub ax, 8
    cmp ax, cx
    jne loc_063BD
    jmp near ptr ShotHitsRecord
loc_063BD:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0643C
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_0643C
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0640C
    jmp near ptr ShotHitsRecord
loc_0640C:
    sub ax, 8
    cmp ax, cx
    jne loc_06416
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06432:
    sub ax, 8
    cmp ax, cx
    jne loc_0643C
    jmp near ptr ShotHitsRecord
loc_0643C:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_064BB
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_064BB
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0648B
    jmp near ptr ShotHitsRecord
loc_0648B:
    sub ax, 8
    cmp ax, cx
    jne loc_06495
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_064B1:
    sub ax, 8
    cmp ax, cx
    jne loc_064BB
    jmp near ptr ShotHitsRecord
loc_064BB:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0653A
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_0653A
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0650A
    jmp near ptr ShotHitsRecord
loc_0650A:
    sub ax, 8
    cmp ax, cx
    jne loc_06514
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06530:
    sub ax, 8
    cmp ax, cx
    jne loc_0653A
    jmp near ptr ShotHitsRecord
loc_0653A:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_065B9
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_065B9
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06589
    jmp near ptr ShotHitsRecord
loc_06589:
    sub ax, 8
    cmp ax, cx
    jne loc_06593
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_065AF:
    sub ax, 8
    cmp ax, cx
    jne loc_065B9
    jmp near ptr ShotHitsRecord
loc_065B9:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06638
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06638
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06608
    jmp near ptr ShotHitsRecord
loc_06608:
    sub ax, 8
    cmp ax, cx
    jne loc_06612
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_0662E:
    sub ax, 8
    cmp ax, cx
    jne loc_06638
    jmp near ptr ShotHitsRecord
loc_06638:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_066B7
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_066B7
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06687
    jmp near ptr ShotHitsRecord
loc_06687:
    sub ax, 8
    cmp ax, cx
    jne loc_06691
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_066AD:
    sub ax, 8
    cmp ax, cx
    jne loc_066B7
    jmp near ptr ShotHitsRecord
loc_066B7:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06736
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06736
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06706
    jmp near ptr ShotHitsRecord
loc_06706:
    sub ax, 8
    cmp ax, cx
    jne loc_06710
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_0672C:
    sub ax, 8
    cmp ax, cx
    jne loc_06736
    jmp near ptr ShotHitsRecord
loc_06736:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_067B5
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_067B5
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06785
    jmp near ptr ShotHitsRecord
loc_06785:
    sub ax, 8
    cmp ax, cx
    jne loc_0678F
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_067AB:
    sub ax, 8
    cmp ax, cx
    jne loc_067B5
    jmp near ptr ShotHitsRecord
loc_067B5:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06834
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06834
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06804
    jmp near ptr ShotHitsRecord
loc_06804:
    sub ax, 8
    cmp ax, cx
    jne loc_0680E
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_0682A:
    sub ax, 8
    cmp ax, cx
    jne loc_06834
    jmp near ptr ShotHitsRecord
loc_06834:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_068B3
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_068B3
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06883
    jmp near ptr ShotHitsRecord
loc_06883:
    sub ax, 8
    cmp ax, cx
    jne loc_0688D
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_068A9:
    sub ax, 8
    cmp ax, cx
    jne loc_068B3
    jmp near ptr ShotHitsRecord
loc_068B3:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06932
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06932
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06902
    jmp near ptr ShotHitsRecord
loc_06902:
    sub ax, 8
    cmp ax, cx
    jne loc_0690C
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06928:
    sub ax, 8
    cmp ax, cx
    jne loc_06932
    jmp near ptr ShotHitsRecord
loc_06932:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_069B1
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_069B1
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06981
    jmp near ptr ShotHitsRecord
loc_06981:
    sub ax, 8
    cmp ax, cx
    jne loc_0698B
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_069A7:
    sub ax, 8
    cmp ax, cx
    jne loc_069B1
    jmp near ptr ShotHitsRecord
loc_069B1:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06A30
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06A30
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06A00
    jmp near ptr ShotHitsRecord
loc_06A00:
    sub ax, 8
    cmp ax, cx
    jne loc_06A0A
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06A26:
    sub ax, 8
    cmp ax, cx
    jne loc_06A30
    jmp near ptr ShotHitsRecord
loc_06A30:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06AAF
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06AAF
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06A7F
    jmp near ptr ShotHitsRecord
loc_06A7F:
    sub ax, 8
    cmp ax, cx
    jne loc_06A89
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06AA5:
    sub ax, 8
    cmp ax, cx
    jne loc_06AAF
    jmp near ptr ShotHitsRecord
loc_06AAF:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06B2E
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06B2E
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06AFE
    jmp near ptr ShotHitsRecord
loc_06AFE:
    sub ax, 8
    cmp ax, cx
    jne loc_06B08
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06B24:
    sub ax, 8
    cmp ax, cx
    jne loc_06B2E
    jmp near ptr ShotHitsRecord
loc_06B2E:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06BAD
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06BAD
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06B7D
    jmp near ptr ShotHitsRecord
loc_06B7D:
    sub ax, 8
    cmp ax, cx
    jne loc_06B87
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06BA3:
    sub ax, 8
    cmp ax, cx
    jne loc_06BAD
    jmp near ptr ShotHitsRecord
loc_06BAD:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06C2C
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06C2C
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06BFC
    jmp near ptr ShotHitsRecord
loc_06BFC:
    sub ax, 8
    cmp ax, cx
    jne loc_06C06
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06C22:
    sub ax, 8
    cmp ax, cx
    jne loc_06C2C
    jmp near ptr ShotHitsRecord
loc_06C2C:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06CAB
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06CAB
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06C7B
    jmp near ptr ShotHitsRecord
loc_06C7B:
    sub ax, 8
    cmp ax, cx
    jne loc_06C85
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06CA1:
    sub ax, 8
    cmp ax, cx
    jne loc_06CAB
    jmp near ptr ShotHitsRecord
loc_06CAB:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06D2A
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06D2A
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06CFA
    jmp near ptr ShotHitsRecord
loc_06CFA:
    sub ax, 8
    cmp ax, cx
    jne loc_06D04
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06D20:
    sub ax, 8
    cmp ax, cx
    jne loc_06D2A
    jmp near ptr ShotHitsRecord
loc_06D2A:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06DA9
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06DA9
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06D79
    jmp near ptr ShotHitsRecord
loc_06D79:
    sub ax, 8
    cmp ax, cx
    jne loc_06D83
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06D9F:
    sub ax, 8
    cmp ax, cx
    jne loc_06DA9
    jmp near ptr ShotHitsRecord
loc_06DA9:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06E28
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06E28
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06DF8
    jmp near ptr ShotHitsRecord
loc_06DF8:
    sub ax, 8
    cmp ax, cx
    jne loc_06E02
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06E1E:
    sub ax, 8
    cmp ax, cx
    jne loc_06E28
    jmp near ptr ShotHitsRecord
loc_06E28:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06EA7
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06EA7
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06E77
    jmp near ptr ShotHitsRecord
loc_06E77:
    sub ax, 8
    cmp ax, cx
    jne loc_06E81
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06E9D:
    sub ax, 8
    cmp ax, cx
    jne loc_06EA7
    jmp near ptr ShotHitsRecord
loc_06EA7:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06F26
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06F26
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06EF6
    jmp near ptr ShotHitsRecord
loc_06EF6:
    sub ax, 8
    cmp ax, cx
    jne loc_06F00
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06F1C:
    sub ax, 8
    cmp ax, cx
    jne loc_06F26
    jmp near ptr ShotHitsRecord
loc_06F26:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_06FA5
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_06FA5
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06F75
    jmp near ptr ShotHitsRecord
loc_06F75:
    sub ax, 8
    cmp ax, cx
    jne loc_06F7F
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_06F9B:
    sub ax, 8
    cmp ax, cx
    jne loc_06FA5
    jmp near ptr ShotHitsRecord
loc_06FA5:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_07024
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_07024
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_06FF4
    jmp near ptr ShotHitsRecord
loc_06FF4:
    sub ax, 8
    cmp ax, cx
    jne loc_06FFE
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_0701A:
    sub ax, 8
    cmp ax, cx
    jne loc_07024
    jmp near ptr ShotHitsRecord
loc_07024:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_070A3
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_070A3
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_07073
    jmp near ptr ShotHitsRecord
loc_07073:
    sub ax, 8
    cmp ax, cx
    jne loc_0707D
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07099:
    sub ax, 8
    cmp ax, cx
    jne loc_070A3
    jmp near ptr ShotHitsRecord
loc_070A3:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_07122
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_07122
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_070F2
    jmp near ptr ShotHitsRecord
loc_070F2:
    sub ax, 8
    cmp ax, cx
    jne loc_070FC
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07118:
    sub ax, 8
    cmp ax, cx
    jne loc_07122
    jmp near ptr ShotHitsRecord
loc_07122:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_071A1
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_071A1
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_07171
    jmp near ptr ShotHitsRecord
loc_07171:
    sub ax, 8
    cmp ax, cx
    jne loc_0717B
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07197:
    sub ax, 8
    cmp ax, cx
    jne loc_071A1
    jmp near ptr ShotHitsRecord
loc_071A1:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_07220
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_07220
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_071F0
    jmp near ptr ShotHitsRecord
loc_071F0:
    sub ax, 8
    cmp ax, cx
    jne loc_071FA
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07216:
    sub ax, 8
    cmp ax, cx
    jne loc_07220
    jmp near ptr ShotHitsRecord
loc_07220:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0729F
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_0729F
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0726F
    jmp near ptr ShotHitsRecord
loc_0726F:
    sub ax, 8
    cmp ax, cx
    jne loc_07279
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07295:
    sub ax, 8
    cmp ax, cx
    jne loc_0729F
    jmp near ptr ShotHitsRecord
loc_0729F:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0731E
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_0731E
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_072EE
    jmp near ptr ShotHitsRecord
loc_072EE:
    sub ax, 8
    cmp ax, cx
    jne loc_072F8
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07314:
    sub ax, 8
    cmp ax, cx
    jne loc_0731E
    jmp near ptr ShotHitsRecord
loc_0731E:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0739D
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_0739D
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_0736D
    jmp near ptr ShotHitsRecord
loc_0736D:
    sub ax, 8
    cmp ax, cx
    jne loc_07377
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07393:
    sub ax, 8
    cmp ax, cx
    jne loc_0739D
    jmp near ptr ShotHitsRecord
loc_0739D:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0741C
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je loc_0741C
    mov ax, word ptr ds:[bx + REC_X]
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
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne loc_073EC
    jmp near ptr ShotHitsRecord
loc_073EC:
    sub ax, 8
    cmp ax, cx
    jne loc_073F6
    jmp near ptr ShotHitsRecord
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
    jmp near ptr ShotHitsRecord
loc_07412:
    sub ax, 8
    cmp ax, cx
    jne loc_0741C
    jmp near ptr ShotHitsRecord
loc_0741C:
    add bx, RECORD_SIZE
PlayerShotsMissed:
    ret

; Spawns the pickup DropKind at (DropX, DropY) in pool A (BX = FFFFh if none free);
; falls through into InitPickupRecord.
SpawnItemDrop:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07429
    ret
loc_07429:
    mov word ptr ds:[bx + REC_STATUS], 1
    mov ax, word ptr ds:[DropY]
    add ax, word ptr ds:[ScrollDeltaY]
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[DropX]
    cmp ax, 0C0h
    jbe loc_07442
    mov ax, 0C0h
loc_07442:
    mov word ptr ds:[bx + REC_X], ax
; BX = record: a 16x16 KIND_PICKUP for DropKind (sprite 46h + kind), not drawn yet.
InitPickupRecord:
    mov word ptr ds:[bx + REC_ANIM_COUNTER], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], KIND_PICKUP
    mov word ptr ds:[bx + REC_TYPE], 0
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    mov si, word ptr ds:[DropKind]
    mov word ptr ds:[bx + REC_ITEM_INDEX], si
    add si, 046h
    mov word ptr ds:[bx + REC_SPRITE], si
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    ret
; Spawns an aimed type 0Bh shot from BP (pool B, sprite 31h, sfx 1Ah).
SpawnAimedShot:
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
    call InitAimedShotRecord
    call AimAtPlayer
    ret
; BX = record: a live 8x8 KIND_TYPED type 0Bh shot, sprite 31h.
InitAimedShotRecord:
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 0
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_SPRITE], 031h
    mov word ptr ds:[bx + REC_DRAW_PASS], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], KIND_TYPED
    mov word ptr ds:[bx + REC_TYPE], 0Bh
    mov word ptr ds:[bx + REC_SHOT_TIMER], 0FFFFh
    ret
; BX = record: REC_DELTA_X/Y = its position minus the player's (X + 9, Y).
AimAtPlayer:
    mov ax, word ptr ds:[bx + REC_X]
    mov cx, word ptr ds:[PrimaryRecord + REC_X]
    add cx, 9
    sub ax, cx
    mov word ptr ds:[bx + REC_DELTA_X], ax
    mov ax, word ptr ds:[bx + REC_Y]
    mov cx, word ptr ds:[PrimaryRecord + REC_Y]
    sub ax, cx
    mov word ptr ds:[bx + REC_DELTA_Y], ax
    ret
; BX = a free pool A record; when the pool is full, frees the first record that is not a
; pod or the exhaust (else the first one).
AllocRecordEvicting:
    call FindFreeRecordPoolA
    cmp bx, -1
    je loc_07507
    ret
loc_07507:
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
loc_0750D:
    cmp word ptr ds:[bx + REC_KIND], KIND_EXHAUST
    je loc_07519
    cmp word ptr ds:[bx + REC_KIND], KIND_POD
    jne loc_07521
loc_07519:
    add bx, RECORD_SIZE
    loop loc_0750D
    mov bx, offset PoolA
loc_07521:
    jmp near ptr RemoveRecordAtBX

; Round-robin search of PoolA from PoolACursor for a record with REC_STATUS = 0.
; Returns BX = free record (saved as the new PoolACursor, record not claimed) or
; BX = FFFFh when all POOL_A_COUNT records are busy.
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

; FindFreeRecordPoolB; when the pool is full, frees the first pool B record that is not
; a beam link, missile or pod (else the first one). Always returns BX = record.
AllocPoolBRecordEvicting:
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
    cmp word ptr ds:[bx + REC_KIND], KIND_POD
    jne loc_07570
loc_07568:
    add bx, RECORD_SIZE
    loop loc_07556
    mov bx, offset PoolB
loc_07570:
    jmp near ptr RemoveRecordAtBX

; PoolB counterpart of FindFreeRecordPoolA, from PoolBCursor. Unlike pool A, the
; wrap to PoolB happens before each read, so a cursor equal to PoolBEnd is accepted.
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

; BP = record: blits its sprite at REC_WORK_OFS (FFFFh = skip) by REC_SIZE_CLASS; 32x32
; sprites also draw their lower half at REC_WORK_OFS_LOWER. BP is clobbered.
DrawRecordSprite:
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    shl bx, 1
    jmp word ptr cs:[bx + DrawRecordSpriteCases]
DrawRecordSpriteCases label word
    dw offset DrawSprite8Record, offset DrawSprite16Record, offset DrawSprite32Record
DrawSprite32Record:
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
    mov word ptr cs:[Sprite32HalfSource], si
    mov word ptr cs:[Sprite32HalfSegment], cx
    mov di, word ptr ss:[bp + REC_WORK_OFS]
    cmp di, -1
    je loc_075DB
    push bp
    call DrawSprite32Half
    pop bp
loc_075DB:
    mov di, word ptr ss:[bp + REC_WORK_OFS_LOWER]
    cmp di, -1
    jne loc_075E4
    ret
loc_075E4:
    mov si, word ptr cs:[Sprite32HalfSource]
    mov cx, word ptr cs:[Sprite32HalfSegment]
    mov ax, word ptr ds:[Sprite32Bytes]
    shr ax, 1
    add si, ax
; Inner entry of DrawRecordSprite: SI:CX = source, DI = workspace offset: 16 rows
; through (Flash)Sprite32Blitters.
DrawSprite32Half:
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
; NOP filler (word alignment).
    db 90h
; Source offset and segment of a 32x32 sprite, kept for drawing its lower half.
Sprite32HalfSource dw 0
Sprite32HalfSegment dw 0
; 32x32 sprite blitters (one 16-row half per call) indexed by VideoAdapter*8 +
; REC_PIXEL_PHASE (CGA uses 4 phases, EGA 8, Tandy 1); unused slots hold SkipBlit.
; FlashSprite32Blitters is used while REC_FLASH_TIMER is nonzero.
Sprite32Blitters label word
    dw offset DrawSprite32Shift0Cga, offset DrawSprite32Shift1Cga, offset DrawSprite32Shift2Cga, offset DrawSprite32Shift3Cga
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset DrawSprite32Shift0Ega, offset DrawSprite32Shift1Ega, offset DrawSprite32Shift2Ega, offset DrawSprite32Shift3Ega
    dw offset DrawSprite32Shift4Ega, offset DrawSprite32Shift5Ega, offset DrawSprite32Shift6Ega, offset DrawSprite32Shift7Ega
    dw offset DrawSprite32Tandy, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
FlashSprite32Blitters label word
    dw offset FlashSprite32Shift0Cga, offset FlashSprite32Shift1Cga, offset FlashSprite32Shift2Cga, offset FlashSprite32Shift3Cga
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset FlashSprite32Shift0Ega, offset FlashSprite32Shift1Ega, offset FlashSprite32Shift2Ega, offset FlashSprite32Shift3Ega
    dw offset FlashSprite32Shift4Ega, offset FlashSprite32Shift5Ega, offset FlashSprite32Shift6Ega, offset FlashSprite32Shift7Ega
    dw offset FlashSprite32Tandy, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
SkipBlit:
    mov ds, cs:[MainDataSegment]
    ret
DrawSprite16Record:
    mov di, word ptr ss:[bp + REC_WORK_OFS]
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
; NOP filler (word alignment).
    db 90h
; 16x16 sprite blitters, as Sprite32Blitters (VideoAdapter*8 + REC_PIXEL_PHASE);
; FlashSprite16Blitters while REC_FLASH_TIMER is nonzero.
Sprite16Blitters label word
    dw offset DrawSprite16Shift0Cga, offset DrawSprite16Shift1Cga, offset DrawSprite16Shift2Cga, offset DrawSprite16Shift3Cga
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset DrawSprite16Shift0Ega, offset DrawSprite16Shift1Ega, offset DrawSprite16Shift2Ega, offset DrawSprite16Shift3Ega
    dw offset DrawSprite16Shift4Ega, offset DrawSprite16Shift5Ega, offset DrawSprite16Shift6Ega, offset DrawSprite16Shift7Ega
    dw offset DrawSprite16Tandy, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
FlashSprite16Blitters label word
    dw offset FlashSprite16Shift0Cga, offset FlashSprite16Shift1Cga, offset FlashSprite16Shift2Cga, offset FlashSprite16Shift3Cga
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset FlashSprite16Shift0Ega, offset FlashSprite16Shift1Ega, offset FlashSprite16Shift2Ega, offset FlashSprite16Shift3Ega
    dw offset FlashSprite16Shift4Ega, offset FlashSprite16Shift5Ega, offset FlashSprite16Shift6Ega, offset FlashSprite16Shift7Ega
    dw offset FlashSprite16Tandy, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit

; BP = record: its 8x8 sprite at REC_WORK_OFS (FFFFh = skip); no flash variant.
DrawSprite8Record:
    mov di, word ptr ss:[bp + REC_WORK_OFS]
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
    dw offset DrawSprite8Shift0Cga, offset DrawSprite8Shift1Cga, offset DrawSprite8Shift2Cga, offset DrawSprite8Shift3Cga
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset DrawSprite8Shift0Ega, offset DrawSprite8Shift1Ega, offset DrawSprite8Shift2Ega, offset DrawSprite8Shift3Ega
    dw offset DrawSprite8Shift4Ega, offset DrawSprite8Shift5Ega, offset DrawSprite8Shift6Ega, offset DrawSprite8Shift7Ega
    dw offset DrawSprite8Tandy, offset SkipBlit, offset SkipBlit, offset SkipBlit
    dw offset SkipBlit, offset SkipBlit, offset SkipBlit, offset SkipBlit
loc_077B2:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_077BE
    mov byte ptr ds:[SfxRequest], 0Ch
loc_077BE:
    mov word ptr ds:[RefuelActive], 0
    ret

; While RefuelActive: Fuel + 1 until full (58h, sfx 0Ch), stopped when the ship is
; destroyed; falls into DrawFuelGauge.
TickRefuel:
    cmp word ptr ds:[RefuelActive], 1
    je loc_077CD
    ret
loc_077CD:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_077BE
    cmp word ptr ds:[Fuel], 058h
    je loc_077B2
    inc word ptr ds:[Fuel]

; Draws the fuel gauge (on both pages on EGA). Preserves BP.
DrawFuelGauge:
    push bp
    call DrawFuelGaugeOnPage
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_077F4
    call FlipEgaDrawPage
    call DrawFuelGaugeOnPage
    call FlipEgaDrawPage
loc_077F4:
    pop bp
    ret

DrawFuelGaugeOnPage:
    mov al, 01Dh
    mov ah, 05Fh
    call DrawOffsetFromScreenRow
    mov word ptr ds:[FuelGaugeOffset], di
    mov cx, word ptr ds:[Fuel]
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
    mov ax, word ptr ds:[Fuel]
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
    cmp word ptr ds:[Fuel], 010h
    jae loc_07947
    cmp word ptr ds:[RefuelActive], 1
    je loc_07947
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_07947
    mov byte ptr ds:[SfxRequest], 0Ah
loc_07947:
    ret

; Runs the level's map cell handler for each of the 13 cells of the map row at
; MapRowCursor (AL = cell byte, ES:SI = the cell, MapCellX = its pixel X); handlers
; spawn the enemies placed in the map and overwrite their cells.
SpawnFromMapRow:
    mov es, word ptr cs:[LevelMapSegment]
    mov si, word ptr ds:[MapRowCursor]
    mov word ptr ds:[MapRowCellsLeft], 0Dh
    mov word ptr ds:[MapCellX], 0
loc_0795D:
    mov al, byte ptr es:[si]
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    call word ptr ds:[bx + LevelMapCellHandlers]
    add word ptr ds:[MapCellX], 010h
    inc si
    dec word ptr ds:[MapRowCellsLeft]
    jne loc_0795D
    ret
Level1MapCell:
    cmp al, 4
    jne loc_0797E
    jmp near ptr SpawnCellClimbWalker8B
loc_0797E:
    cmp al, 7
    jne loc_07985
    jmp near ptr SpawnCellClimbWalker8C
loc_07985:
    cmp al, 06Ch
    jne loc_0798C
    jmp near ptr SpawnCellTurretLeft24
loc_0798C:
    cmp al, 06Dh
    jne loc_07993
    jmp near ptr SpawnCellTurretRight25
loc_07993:
    cmp al, 0ACh
    jne loc_0799A
    jmp near ptr SpawnCellVolleyTurret90
loc_0799A:
    cmp al, 0B1h
    jne loc_079A1
    jmp near ptr SpawnCellVolleyTurret91
loc_079A1:
    cmp al, 0C9h
    je SpawnCellHatch28
    ret
; Overwrites the 2x2 cells at ES:SI (the map is 13 cells wide) with cell 1.
Clear2x2MapCells:
    mov byte ptr es:[si], 1
    mov byte ptr es:[si + 1], 1
    mov byte ptr es:[si + 0Dh], 1
    mov byte ptr es:[si + 0Eh], 1
    ret
; Level 5 byte D9h: large type 48h, facing down, joins group.
SpawnCellCreeper48:
    call Clear2x2MapCells
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_079C6
    ret
loc_079C6:
    call InitMapLargeEnemy
    mov word ptr ds:[bx + REC_TYPE], 48h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    jmp near ptr JoinMapGroup
; Level 0 byte F8h: large type 75h, joins group.
SpawnCellSpreadShooter75:
    call Clear2x2MapCells
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_079E2
    ret
loc_079E2:
    call InitMapLargeEnemy
    mov word ptr ds:[bx + REC_TYPE], 75h
    mov word ptr ds:[bx + REC_SPRITE], 24h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    jmp near ptr JoinMapGroup
; Level 0 byte F7h: large type 72h, facing down.
SpawnCellAimedDescender72:
    call Clear2x2MapCells
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07A03
    ret
loc_07A03:
    call InitMapLargeEnemy
    mov word ptr ds:[bx + REC_TYPE], 72h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    ret
; Level 1/4 byte C9h: writes the hatch cells 26h..29h, large type 28h.
SpawnCellHatch28:
    mov byte ptr es:[si + 0Dh], 026h
    mov byte ptr es:[si + 0Eh], 027h
    mov byte ptr es:[si], 028h
    mov byte ptr es:[si + 1], 029h
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07A2D
    ret
loc_07A2D:
    call InitMapLargeEnemy
    mov word ptr ds:[bx + REC_TYPE], 028h
    mov word ptr ds:[bx + REC_SPRITE], 01Ch
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    ret
; BX = pool A record: a large (size class 2) KIND_ENEMY with 10 hit points at the
; top of the map row, X = MapCellX.
InitMapLargeEnemy:
    mov word ptr ds:[bx + REC_KIND], KIND_ENEMY
    mov ax, word ptr ds:[MapCellX]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    mov word ptr ds:[bx + REC_Y], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 2
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    mov word ptr ds:[bx + REC_HIT_POINTS], 0Ah
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    ret
; Level 1 04h, level 3 DEh, level 4 CFh, level 5 D8h.
SpawnCellClimbWalker8B:
    call SpawnMapEnemy
    jne loc_07A74
    ret
loc_07A74:
    mov word ptr ds:[bx + REC_TYPE], 08Bh
    ret
; Level 1 07h, level 3 DDh, level 4 CEh, level 5 D7h.
SpawnCellClimbWalker8C:
    call SpawnMapEnemy
    jne loc_07A80
    ret
loc_07A80:
    mov word ptr ds:[bx + REC_TYPE], 08Ch
    ret
; Level 0 byte EEh (grouped); the level 5 D8h table slot is dead.
SpawnCellClimbWalker8E:
    call SpawnMapGroupEnemy
    jne loc_07A8C
    ret
loc_07A8C:
    mov word ptr ds:[bx + REC_TYPE], 8Eh
    ret
; Level 0 byte F9h: a fuel pickup (DropKind 4).
SpawnCellFuelPickup:
    call SpawnMapEnemy
    jne loc_07A98
    ret
loc_07A98:
    mov ax, 4
    mov ds:[DropKind], ax
    call InitPickupRecord
    ret
; Level 0 byte EDh (grouped); the level 5 D7h table slot is dead.
SpawnCellClimbWalker8D:
    call SpawnMapGroupEnemy
    jne loc_07AA8
    ret
loc_07AA8:
    mov word ptr ds:[bx + REC_TYPE], 8Dh
    ret
; Level 1 byte 6Ch: type 24h facing left; the cell stays.
SpawnCellTurretLeft24:
    call SpawnMapEnemyKeepCell
    jne loc_07AB4
    ret
loc_07AB4:
    mov word ptr ds:[bx + REC_TYPE], 024h
    mov word ptr ds:[bx + REC_SPRITE], 08Fh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    ret
; Level 1 byte 6Dh: type 25h facing right; the cell stays.
SpawnCellTurretRight25:
    call SpawnMapEnemyKeepCell
    jne loc_07ACA
    ret
loc_07ACA:
    mov word ptr ds:[bx + REC_TYPE], 025h
    mov word ptr ds:[bx + REC_SPRITE], 090h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 1/4 byte ACh, level 5 D3h: type 90h facing left; the cell stays.
SpawnCellVolleyTurret90:
    call SpawnMapEnemyKeepCell
    jne loc_07AE0
    ret
loc_07AE0:
    mov word ptr ds:[bx + REC_TYPE], 090h
    mov word ptr ds:[bx + REC_SPRITE], 089h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    ret
; Level 1/4 byte B1h, level 5 D2h: type 91h facing right; the cell stays.
SpawnCellVolleyTurret91:
    call SpawnMapEnemyKeepCell
    jne loc_07AF6
    ret
loc_07AF6:
    mov word ptr ds:[bx + REC_TYPE], 091h
    mov word ptr ds:[bx + REC_SPRITE], 08Ch
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
Level2MapCell:
    cmp al, 30h
    je SpawnCellHatch2A
    cmp al, 0C4h
    je SpawnCellFireBurst8F
    cmp al, 5Ah
    je SpawnCellPlunger2E
    ret
; Level 2/5 byte 30h: large type 2Ah; the cell stays and REC_SLOT_INDEX is not set.
SpawnCellHatch2A:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_07B1C
    ret
loc_07B1C:
    mov word ptr ds:[bx + REC_KIND], KIND_ENEMY
    mov ax, ds:[MapCellX]
    mov ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    mov word ptr ds:[bx + REC_Y], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 2
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    mov word ptr ds:[bx + REC_HIT_POINTS], 0Ah
    mov word ptr ds:[bx + REC_TYPE], 2Ah
    mov word ptr ds:[bx + REC_SPRITE], 1Ch
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    ret
; Level 2 byte 5Ah: type 2Eh, 6 px higher.
SpawnCellPlunger2E:
    call SpawnMapEnemy
    jne loc_07B5A
    ret
loc_07B5A:
    mov word ptr ds:[bx + REC_TYPE], 2Eh
    sub word ptr ds:[bx + REC_Y], 6
    ret
; Level 2 byte C4h: type 8Fh facing the centre.
SpawnCellFireBurst8F:
    call SpawnMapEnemy
    jne loc_07B6A
    ret
loc_07B6A:
    mov word ptr ds:[bx + REC_TYPE], 8Fh
    mov word ptr ds:[bx + REC_SPRITE], 0BFh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_07B80
    ret
loc_07B80:
    mov word ptr ds:[bx + REC_SPRITE], 0C2h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 0 byte BCh (left half only): type 73h facing right.
SpawnCellRunnerRight73:
    call SpawnMapEnemy
    jne loc_07B91
    ret
loc_07B91:
    sub word ptr ds:[bx + REC_X], 0Ch
    push word ptr ds:[bx + REC_X]
    pop word ptr ds:[bx + REC_SAVED_X]
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    mov word ptr ds:[bx + REC_TYPE], 73h
    mov word ptr ds:[bx + REC_SPRITE], 14Ch
    ret
; Level 0 byte BBh (right half only): type 74h facing left.
SpawnCellRunnerLeft74:
    call SpawnMapEnemy
    jne loc_07BB1
    ret
loc_07BB1:
    add word ptr ds:[bx + REC_X], 0Ch
    push word ptr ds:[bx + REC_X]
    pop word ptr ds:[bx + REC_SAVED_X]
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 74h
    mov word ptr ds:[bx + REC_SPRITE], 14Fh
    ret
Level0MapCell:
    cmp word ptr ds:[MapCellX], 60h
    ja loc_07BD8
    cmp al, 0BCh
    je SpawnCellRunnerRight73
    jmp short loc_07BDC
loc_07BD8:
    cmp al, 0BBh
    je SpawnCellRunnerLeft74
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
    mov bl, ds:[bx + GroupDropKinds]
    xor bh, bh
    mov ds:[GroupDropKind], bx
    call far ptr AllocGroupSlot
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + Level0CellCases]
; NOP filler (word alignment).
    db 90h
; Map bytes E1h..F9h; the range check also admits FAh and FBh, which would index past
; the table into code (those bytes presumably never occur in level 0 maps).
Level0CellCases label word
    dw offset SpawnCellBurstFirer88, offset SpawnCellBurstFirer88, offset SpawnCellJitterShooter68, offset SpawnCellJitterDropper69
    dw offset SpawnCellCrawler6A, offset SpawnCellCrawler6A, offset SpawnCellDescender6B, offset SpawnCellDescender6C
    dw offset SpawnCellDescender6D, offset SpawnCellCrawler6E, offset SpawnCellDiver71, offset SpawnCellCruiser6F
    dw offset SpawnCellClimbWalker8D, offset SpawnCellClimbWalker8E, offset SpawnCellPatroller8A, offset SpawnCellCrawler54InwardB
    dw offset SpawnCellCrawler54InwardB, offset SpawnCellSideTurret34, offset SpawnCellSideTurret34, offset SpawnCellCrawler59
    dw offset ClearMapCellAlt, offset SpawnCellFaller4F, offset SpawnCellAimedDescender72, offset SpawnCellSpreadShooter75
    dw offset SpawnCellFuelPickup
; Level 0 byte F5h: only clears the cell (a copy of ClearMapCell).
ClearMapCellAlt:
    mov byte ptr es:[si], 1
    ret
Level3MapCell:
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
    mov bl, ds:[bx + GroupDropKinds]
    xor bh, bh
    mov ds:[GroupDropKind], bx
    call far ptr AllocGroupSlot
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + Level3CellCases]
; Map bytes CEh..E9h; the range check also admits EAh and EBh (past the table).
Level3CellCases label word
    dw offset SpawnCellLauncher86, offset SpawnCellLauncher86, offset SpawnCellCrawler54InwardA, offset SpawnCellCrawler54InwardA
    dw offset SpawnCellFireBurst87, offset SpawnCellFireBurst87, offset SpawnCellDropper55, offset SpawnCellPatroller83
    dw offset SpawnCellCrawler5F, offset SpawnCellSlider63, offset SpawnCellCrawler59, offset SpawnCellCrawler58Right
    dw offset SpawnCellCrawler57Left, offset SpawnCellWallPatroller19Down, offset SpawnCellPatroller89, offset SpawnCellClimbWalker8C
    dw offset SpawnCellClimbWalker8B, offset CountXReturn, offset SpawnCellFaller4F, offset SpawnCellBouncer37
    dw offset SpawnCellPlunger2D, offset SpawnCellCrawler5E, offset SpawnCellDropper5D, offset SpawnCellSideTurret34
    dw offset SpawnCellSideTurret34, offset SpawnCellRiser5B, offset SpawnCellPatroller47, offset SpawnCellBurster35
Level4MapCell:
    cmp al, 0ACh
    jne loc_07CA9
    jmp near ptr SpawnCellVolleyTurret90
loc_07CA9:
    cmp al, 0B1h
    jne loc_07CB0
    jmp near ptr SpawnCellVolleyTurret91
loc_07CB0:
    cmp al, 0C9h
    jne loc_07CB7
    jmp near ptr SpawnCellHatch28
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
    mov word ptr ds:[GroupDropKind], bx
    call far ptr AllocGroupSlot
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + Level4CellCases]
; Map bytes CEh..E0h; the range check also admits E1h and E2h (past the table).
Level4CellCases label word
    dw offset SpawnCellClimbWalker8C, offset SpawnCellClimbWalker8B, offset SpawnCellCrawler58Right, offset SpawnCellCrawler57Left
    dw offset SpawnCellCrawler54UpRight, offset SpawnCellCrawler54UpLeft, offset SpawnCellCrawler5F, offset SpawnCellPatroller8A
    dw offset SpawnCellFaller4F, offset SpawnCellCrawler59, offset SpawnCellPatroller83, offset SpawnCellDropper5D
    dw offset SpawnCellWallBouncer38Right, offset SpawnCellWallBouncer38Left, offset SpawnCellSideTurret34, offset SpawnCellJitterShooter68
    dw offset SpawnCellJitterDropper69, offset SpawnCellBurster35, offset SpawnCellCrawler5E
; Level 4 byte DAh: type 38h heading down-right.
SpawnCellWallBouncer38Right:
    call SpawnMapEnemy
    jne loc_07D0E
    ret
loc_07D0E:
    mov word ptr ds:[bx + REC_TYPE], 38h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_RIGHT
    ret
; Level 4 byte DBh: type 38h heading down-left.
SpawnCellWallBouncer38Left:
    call SpawnMapEnemy
    jne loc_07D1F
    ret
loc_07D1F:
    mov word ptr ds:[bx + REC_TYPE], 38h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_LEFT
    ret
; Level 4 D2h, level 5 DCh: type 54h.
SpawnCellCrawler54UpRight:
    call SpawnMapEnemy
    jne loc_07D30
    ret
loc_07D30:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 172h
    cmp word ptr ds:[LevelIndex], 4
    jne loc_07D47
    ret
loc_07D47:
    mov word ptr ds:[bx + REC_SPRITE], 17Ah
    ret
; Level 4 D3h, level 5 DDh: type 54h.
SpawnCellCrawler54UpLeft:
    call SpawnMapEnemy
    jne loc_07D53
    ret
loc_07D53:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 173h
    cmp word ptr ds:[LevelIndex], 4
    jne loc_07D6A
    ret
loc_07D6A:
    mov word ptr ds:[bx + REC_SPRITE], 17Bh
    ret
; Level 5 byte BAh: type 84h facing up.
SpawnCellLurker84Up:
    call SpawnMapEnemy
    jne loc_07D76
    ret
loc_07D76:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 156h
    ret
; Level 5 byte BBh: type 84h facing right.
SpawnCellLurker84Right:
    call SpawnMapEnemy
    jne loc_07D8C
    ret
loc_07D8C:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 157h
    ret
; Level 5 byte BCh: type 84h facing down.
SpawnCellLurker84Down:
    call SpawnMapEnemy
    jne loc_07DA2
    ret
loc_07DA2:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 158h
    ret
; Level 5 byte B6h: type 84h facing left.
SpawnCellLurker84Left:
    call SpawnMapEnemy
    jne loc_07DB8
    ret
loc_07DB8:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 159h
    ret
Level5MapCell:
    cmp al, 30h
    jne loc_07DCF
    jmp near ptr SpawnCellHatch2A
loc_07DCF:
    cmp al, 0BAh
    je SpawnCellLurker84Up
    cmp al, 0BBh
    je SpawnCellLurker84Right
    cmp al, 0BCh
    je SpawnCellLurker84Down
    cmp al, 0B6h
    je SpawnCellLurker84Left
    cmp al, 0D8h
    jne loc_07DE6
    jmp near ptr SpawnCellClimbWalker8B
loc_07DE6:
    cmp al, 0D7h
    jne loc_07DED
    jmp near ptr SpawnCellClimbWalker8C
loc_07DED:
    cmp al, 0D3h
    jne loc_07DF4
    jmp near ptr SpawnCellVolleyTurret90
loc_07DF4:
    cmp al, 0D2h
    jne loc_07DFB
    jmp near ptr SpawnCellVolleyTurret91
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
    mov bl, ds:[bx + GroupDropKinds]
    xor bh, bh
    mov ds:[GroupDropKind], bx
    call far ptr AllocGroupSlot
    pop ax
    mov bl, al
    xor bh, bh
    shl bx, 1
    jmp word ptr cs:[bx + Level5CellCases]
; Map bytes D7h..EFh; the range check also admits F0h and F1h (past the table).
Level5CellCases label word
    dw offset SpawnCellClimbWalker8D, offset SpawnCellClimbWalker8E, offset SpawnCellCreeper48, offset SpawnCellLevelFirer92Right
    dw offset SpawnCellLevelFirer92Left, offset SpawnCellCrawler54UpRight, offset SpawnCellCrawler54UpLeft, offset SpawnCellFireBurst87
    dw offset SpawnCellFireBurst87, offset SpawnCellDropper5D, offset ClearMapCell, offset ClearMapCell
    dw offset SpawnCellSlider63, offset SpawnCellShooter30, offset SpawnCellCrawler58Right, offset SpawnCellCrawler57Left
    dw offset SpawnCellWallPatroller19Right, offset SpawnCellPatroller89, offset SpawnCellPatroller47, offset SpawnCellBurster35
    dw offset SpawnCellJitterShooter68, offset SpawnCellFaller4F, offset SpawnCellBouncer37, offset SpawnCellPlunger2D
    dw offset SpawnCellCrawler5E
; Overwrites the current map cell (ES:SI) with the plain cell 1.
ClearMapCell:
    mov byte ptr es:[si], 1
    ret
; Level 5 byte E7h: type 19h facing right.
SpawnCellWallPatroller19Right:
    call SpawnMapEnemy
    jne loc_07E63
    ret
loc_07E63:
    mov word ptr ds:[bx + REC_TYPE], 19h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 5 byte E4h: type 30h facing down.
SpawnCellShooter30:
    call SpawnMapEnemy
    jne loc_07E74
    ret
loc_07E74:
    mov word ptr ds:[bx + REC_SPRITE], 46h
    mov word ptr ds:[bx + REC_TYPE], 30h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    ret
; Level 5 byte DAh: type 92h facing right.
SpawnCellLevelFirer92Right:
    call SpawnMapEnemy
    jne loc_07E8A
    ret
loc_07E8A:
    mov word ptr ds:[bx + REC_TYPE], 92h
    mov word ptr ds:[bx + REC_SPRITE], 15Ah
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 5 byte DBh: type 92h facing left.
SpawnCellLevelFirer92Left:
    call SpawnMapEnemy
    jne loc_07EA0
    ret
loc_07EA0:
    mov word ptr ds:[bx + REC_TYPE], 92h
    mov word ptr ds:[bx + REC_SPRITE], 15Bh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    ret
; Level 3 bytes CEh, CFh: type 86h facing the centre.
SpawnCellLauncher86:
    call SpawnMapEnemy
    jne loc_07EB6
    ret
loc_07EB6:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 86h
    mov word ptr ds:[bx + REC_SPRITE], 0C8h
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_07ECC
    ret
loc_07ECC:
    mov word ptr ds:[bx + REC_SPRITE], 0DAh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 0 bytes E1h, E2h: type 88h facing the centre.
SpawnCellBurstFirer88:
    call SpawnMapEnemy
    jne loc_07EDD
    ret
loc_07EDD:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 88h
    mov word ptr ds:[bx + REC_SPRITE], 0FDh
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_07EF3
    ret
loc_07EF3:
    mov word ptr ds:[bx + REC_SPRITE], 0FAh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 3 D7h, level 5 E3h: type 63h facing right.
SpawnCellSlider63:
    call SpawnMapEnemy
    jne loc_07F04
    ret
loc_07F04:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    mov word ptr ds:[bx + REC_TYPE], 63h
    mov word ptr ds:[bx + REC_SPRITE], 0E7h
    ret
; Level 0 byte EBh: type 71h facing down, joins group.
SpawnCellDiver71:
    call SpawnMapGroupEnemy
    jne loc_07F1A
    ret
loc_07F1A:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 71h
    ret
; Level 0 EFh, level 4 D5h: type 8Ah, joins group.
SpawnCellPatroller8A:
    call SpawnMapGroupEnemy
    jne loc_07F2B
    ret
loc_07F2B:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 8Ah
    ret
; Level 3 bytes D0h, D1h: type 54h heading up toward the centre.
SpawnCellCrawler54InwardA:
    call SpawnMapEnemy
    jne loc_07F3C
    ret
loc_07F3C:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 0F5h
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_07F52
    ret
loc_07F52:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 0F4h
    ret
; Level 0 byte E7h: type 6Bh.
SpawnCellDescender6B:
    call SpawnMapEnemy
    jne loc_07F63
    ret
loc_07F63:
    mov word ptr ds:[bx + REC_TYPE], 6Bh
    ret
; Level 0 byte E8h: type 6Ch, joins group.
SpawnCellDescender6C:
    call SpawnMapGroupEnemy
    jne loc_07F6F
    ret
loc_07F6F:
    mov word ptr ds:[bx + REC_TYPE], 6Ch
    mov word ptr ds:[bx + REC_SPRITE], 123h
    ret
; Level 0 byte E9h: type 6Dh.
SpawnCellDescender6D:
    call SpawnMapEnemy
    jne loc_07F80
    ret
loc_07F80:
    mov word ptr ds:[bx + REC_TYPE], 6Dh
    ret
; Level 0 bytes E5h, E6h: type 6Ah heading down toward the centre.
SpawnCellCrawler6A:
    call SpawnMapEnemy
    jne loc_07F8C
    ret
loc_07F8C:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_LEFT
    mov word ptr ds:[bx + REC_TYPE], 6Ah
    mov word ptr ds:[bx + REC_SPRITE], 11Eh
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_07FA2
    ret
loc_07FA2:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 11Dh
    ret
; Level 0 bytes F0h, F1h: type 54h facing the centre.
SpawnCellCrawler54InwardB:
    call SpawnMapEnemy
    jne loc_07FB3
    ret
loc_07FB3:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 143h
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_07FC9
    ret
loc_07FC9:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 144h
    ret
; Level 3 E3h, level 4 E0h, level 5 EFh: type 5Eh, joins group.
SpawnCellCrawler5E:
    call SpawnMapGroupEnemy
    jne loc_07FDA
    ret
loc_07FDA:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 5Eh
    mov word ptr ds:[bx + REC_SPRITE], 27h
    ret
; Level 0 byte EAh: type 6Eh facing down, joins group.
SpawnCellCrawler6E:
    call SpawnMapGroupEnemy
    jne loc_07FF0
    ret
loc_07FF0:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 6Eh
    ret
; Level 0 byte ECh: type 6Fh, 16 px outward, facing the centre.
SpawnCellCruiser6F:
    call SpawnMapGroupEnemy
    jne loc_08001
    ret
; Offset-placement use of field+8 does not define its role in other record types.
loc_08001:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 6Fh
    mov word ptr ds:[bx + REC_SPRITE], 136h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_RIGHT
    sub word ptr ds:[bx + REC_X], 10h
    cmp word ptr ds:[bx + REC_X], 60h
    jae loc_08020
    ret
loc_08020:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_LEFT
    add word ptr ds:[bx + REC_X], 20h
    ret
; Level 3 E2h, level 5 EEh: type 2Dh, joins group.
SpawnCellPlunger2D:
    call SpawnMapGroupEnemy
    jne loc_08030
    ret
loc_08030:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_TYPE], 2Dh
    ret
; Level 3 E8h, level 5 E9h: type 47h, joins group.
SpawnCellPatroller47:
    call SpawnMapGroupEnemy
    jne loc_08041
    ret
loc_08041:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 47h
    ret
; Level 0 F4h, level 3 D8h, level 4 D7h: type 59h facing the centre.
SpawnCellCrawler59:
    call SpawnMapEnemy
    jne loc_08052
    ret
loc_08052:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 59h
    mov word ptr ds:[bx + REC_SPRITE], 0E3h
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_08068
    ret
loc_08068:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    ret
; Level 3 D6h, level 4 D4h: type 5Fh facing the centre.
SpawnCellCrawler5F:
    call SpawnMapEnemy
    jne loc_08074
    ret
loc_08074:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 5Fh
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_08085
    ret
loc_08085:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 3 byte E7h: type 5Bh facing up.
SpawnCellRiser5B:
    call SpawnMapEnemy
    jne loc_08091
    ret
loc_08091:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_TYPE], 5Bh
    mov word ptr ds:[bx + REC_SPRITE], 74h
    ret
; Level 3 E4h, level 4 D9h, level 5 E0h: type 5Dh, joins group.
SpawnCellDropper5D:
    call SpawnMapGroupEnemy
    jne loc_080A7
    ret
loc_080A7:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 5Dh
    mov word ptr ds:[bx + REC_SPRITE], 77h
    ret
; Level 3 D2h, D3h, level 5 DEh, DFh: type 87h facing the centre.
SpawnCellFireBurst87:
    call SpawnMapEnemy
    jne loc_080BD
    ret
loc_080BD:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 87h
    mov word ptr ds:[bx + REC_SPRITE], 0E0h
    cmp word ptr ds:[bx + REC_X], 60h
    jna loc_080D3
    ret
loc_080D3:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 0DDh
    ret
; Level 3 byte D4h: type 55h.
SpawnCellDropper55:
    call SpawnMapEnemy
    jne loc_080E4
    ret
loc_080E4:
    mov word ptr ds:[bx + REC_TYPE], 55h
    mov word ptr ds:[bx + REC_SPRITE], 77h
    ret
; Level 0 F2h, F3h, level 3 E5h, E6h, level 4 DCh: type 34h.
SpawnCellSideTurret34:
    call SpawnMapEnemy
    jne loc_080F5
    ret
loc_080F5:
    mov word ptr ds:[bx + REC_TYPE], 34h
    ret
; Level 3 E1h, level 5 EDh: type 37h, joins group.
SpawnCellBouncer37:
    call SpawnMapGroupEnemy
    jne loc_08101
    ret
loc_08101:
    mov word ptr ds:[bx + REC_TYPE], 37h
    ret
; Level 3 D5h, level 4 D8h: type 83h, joins group.
SpawnCellPatroller83:
    call SpawnMapGroupEnemy
    jne loc_0810D
    ret
loc_0810D:
    mov word ptr ds:[bx + REC_TYPE], 83h
    ret
; Level 0 F6h, level 3 E0h, level 4 D6h, level 5 ECh: type 4Fh.
SpawnCellFaller4F:
    call SpawnMapEnemy
    jne loc_08119
    ret
loc_08119:
    mov word ptr ds:[bx + REC_TYPE], 4Fh
    ret
; Level 3 byte DBh: type 19h, joins group.
SpawnCellWallPatroller19Down:
    call SpawnMapGroupEnemy
    jne loc_08125
    ret
loc_08125:
    mov word ptr ds:[bx + REC_TYPE], 19h
    ret
; Level 3 E9h, level 4 DFh, level 5 EAh: type 35h, joins group.
SpawnCellBurster35:
    call SpawnMapGroupEnemy
    jne loc_08131
    ret
loc_08131:
    mov word ptr ds:[bx + REC_TYPE], 35h
    ret
; Level 0 E4h, level 4 DEh: type 69h.
SpawnCellJitterDropper69:
    call SpawnMapEnemy
    jne loc_0813D
    ret
loc_0813D:
    mov word ptr ds:[bx + REC_TYPE], 69h
    ret
; Level 0 E3h, level 4 DDh, level 5 EBh: type 68h (1 in 16 grouped on level 5).
SpawnCellJitterShooter68:
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0815A
    call NextRandomWord
    and bx, 0Fh
    cmp bx, 0Fh
    jne loc_0815A
    call SpawnMapGroupEnemy
    jmp short loc_0815D
loc_0815A:
    call SpawnMapEnemy
loc_0815D:
    jne loc_08160
    ret
loc_08160:
    mov word ptr ds:[bx + REC_TYPE], 68h
    ret
; Level 3 DCh, level 5 E8h: type 89h, joins group.
SpawnCellPatroller89:
    call SpawnMapGroupEnemy
    jne loc_0816C
    ret
loc_0816C:
    mov word ptr ds:[bx + REC_TYPE], 89h
    ret
; Level 3 D9h, level 4 D0h, level 5 E5h: type 58h facing right.
SpawnCellCrawler58Right:
    call SpawnMapEnemy
    jne loc_08178
    ret
loc_08178:
    mov word ptr ds:[bx + REC_TYPE], 58h
    mov word ptr ds:[bx + REC_SPRITE], 99h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 3 DAh, level 4 D1h, level 5 E6h: type 57h facing left.
SpawnCellCrawler57Left:
    call SpawnMapEnemy
    jne loc_0818E
    ret
loc_0818E:
    mov word ptr ds:[bx + REC_TYPE], 57h
    mov word ptr ds:[bx + REC_SPRITE], 9Bh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    ret
; SpawnMapEnemy, then registers the record in the current enemy group.
SpawnMapGroupEnemy:
    call SpawnMapEnemy
    cmp bx, -1
    jne JoinMapGroup
    ret
; BX = record: counts it in the group at GroupSlotPtr (with GroupDropKind as the
; group's drop) and stores GroupSlotIndex, or FFFFh without a group, in REC_SLOT_INDEX.
JoinMapGroup:
    mov ax, 0FFFFh
    cmp word ptr ds:[GroupSlotPtr], -1
    je loc_081C2
    push bx
    mov bx, ds:[GroupSlotPtr]
    inc byte ptr ds:[bx + GROUP_LIVE]
    mov al, byte ptr ds:[GroupDropKind]
    mov ds:[bx + GROUP_DROP_KIND], al
    pop bx
    mov ax, ds:[GroupSlotIndex]
loc_081C2:
    mov ds:[bx + REC_SLOT_INDEX], ax
    or ax, 1
    ret
; Clears the cell and spawns a pool A enemy at (MapCellX, 10h), invisible for now
; (REC_DRAW_PASS 0); BX = record and NZ, or ZF set when the pool is full.
SpawnMapEnemy:
    call ClearMapCell
SpawnMapEnemyKeepCell:
    call SpawnEnemyHereQuiet
    cmp bx, -1
    jne loc_081D5
    ret
loc_081D5:
    mov ax, word ptr ds:[MapCellX]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_Y], 010h
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    or ax, 1
    ret
; Takes a pool A record (BX, FFFFh if none) as a KIND_ENEMY type 14h at BP's position
; with 4 hit points and REC_SAVED = that position; SpawnEnemyHere also plays sfx 0Bh.
SpawnEnemyHereQuiet:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_081F2
    ret
loc_081F2:
    jmp short InitEnemyRecordHere
SpawnEnemyHere:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_081FD
    ret
loc_081FD:
    cmp byte ptr ds:[SfxEnabled], 0
    je InitEnemyRecordHere
    mov byte ptr ds:[SfxRequest], 0Bh
; Shared body of SpawnEnemyHere/Quiet.
InitEnemyRecordHere:
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_DRAW_PASS], 1
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[bx + REC_Y], ax
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], KIND_ENEMY
    mov word ptr ds:[bx + REC_TYPE], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 4
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    ret
; Fires SpawnThrottledChild every 32 frames; its wreck becomes type 26h facing left.
Type24TurretLeftFire32:
    cmp word ptr ds:[FrameCount32], 1Fh
    je loc_08252
    jmp near ptr ScrollRecordThenFinish
loc_08252:
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0825D
    jmp near ptr ScrollRecordThenFinish
loc_0825D:
    mov word ptr ds:[bx + REC_SPRITE], 1Eh
    jmp near ptr ScrollRecordThenFinish
; As type 24h; its wreck faces right.
Type25TurretRightFire32:
    cmp word ptr ds:[FrameCount32], 1Fh
    je loc_0826F
    jmp near ptr ScrollRecordThenFinish
loc_0826F:
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0827A
    jmp near ptr ScrollRecordThenFinish
loc_0827A:
    mov word ptr ds:[bx + REC_SPRITE], 1Ah
    jmp near ptr ScrollRecordThenFinish
; Types 90h/91h: turret alternating shots above and below every 32 frames.
Type90TurretVolley:
    mov ax, 88h
    cmp word ptr ds:[LevelIndex], 4
    jne loc_0829E
    mov ax, 16Ch
    jmp short loc_0829E
; Type 90h with sprite base 8Bh.
Type91TurretVolleyAlt:
    mov ax, 8Bh
    cmp word ptr ds:[LevelIndex], 4
    jne loc_0829E
    mov ax, 16Fh
loc_0829E:
    mov ss:[bp + REC_SPRITE], ax
    mov bx, ds:[FrameCount128]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shl bx, 1
    mov bx, ds:[bx + TurretPhaseTable]
    add ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[FrameCount32], 1Fh
    je loc_082C2
    jmp near ptr ScrollRecordThenFinish
loc_082C2:
    shl bx, 1
    jmp word ptr cs:[bx + TurretVolleyShotCases]
; NOP filler: word-aligns the table (every MAIN jump table has one).
    db 90h
TurretVolleyShotCases label word
    dw offset TurretVolleyFireUpper, offset ScrollRecordThenFinish, offset TurretVolleyFireLower
TurretVolleyFireLower:
    add word ptr ss:[bp + REC_Y], 4
    call SpawnThrottledChild
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
TurretVolleyFireUpper:
    sub word ptr ss:[bp + REC_Y], 4
    call SpawnThrottledChild
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
loc_082EC:
    cmp word ptr ds:[FrameCount4], 3
    je loc_082F6
    jmp near ptr ScrollRecordThenFinish
loc_082F6:
    mov ax, ss:[bp + REC_SAVED_X]
    mov ss:[bp + REC_X], ax
    dec word ptr ss:[bp + REC_SPRITE]
    jmp near ptr ScrollRecordThenFinish
; Moves 1 px per frame along REC_DIRECTION with a wall test, advancing the sprite when
; blocked. Role uncertain.
Type26WallProbeExtender:
    cmp word ptr ss:[bp + REC_SPRITE], 98h
    je loc_082EC
    cmp word ptr ss:[bp + REC_SPRITE], 92h
    je loc_082EC
    call TryTerrainStep
    jne loc_0831F
    cmp word ptr ss:[bp + REC_X], 0C0h
    jae loc_0831F
    jmp near ptr ScrollRecordThenFinish
loc_0831F:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0832E
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0832E:
    jmp near ptr ScrollRecordThenFinish
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
; Descends 1 px per frame plus scroll.
Type27SlowDescender:
    mov ax, ds:[SlowCount6]
    shr ax, 1
    mov bx, 27h
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0836F
    mov bx, 24h
loc_0836F:
    add ax, bx
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    jmp near ptr ScrollRecordThenFinish

; Moves each upgrade slot to the first list entry whose availability test passes (NZ);
; after 10 failures shows the empty icon 24h.
AdvanceToAvailableUpgrade:
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
    cmp word ptr ds:[WeaponMode], 0
    ret
loc_083E4:
    cmp word ptr ds:[WeaponMode], 1
    ret
loc_083EA:
    cmp word ptr ds:[WeaponMode], 2
    ret
loc_083F0:
    cmp word ptr ds:[WeaponMode], 3
    ret
loc_083F6:
    cmp word ptr ds:[WeaponMode], 4
    ret
loc_083FC:
    cmp word ptr ds:[WeaponMode], 5
    ret
loc_08402:
    mov word ptr ds:[WeaponMode], 0
    jmp short loc_08430
loc_0840A:
    mov word ptr ds:[WeaponMode], 1
    jmp short loc_08430
loc_08412:
    mov word ptr ds:[WeaponMode], 2
    jmp short loc_08430
loc_0841A:
    mov word ptr ds:[WeaponMode], 3
    jmp short loc_08430
loc_08422:
    mov word ptr ds:[WeaponMode], 4
    jmp short loc_08430
loc_0842A:
    mov word ptr ds:[WeaponMode], 5
loc_08430:
    mov word ptr ds:[SelectedUpgradeSlot], 0FFFFh
    ret
loc_08437:
    cmp word ptr ds:[SideShotsEnabled], 1
    ret
loc_0843D:
    mov word ptr ds:[SideShotsEnabled], 1
    jmp short loc_08430
loc_08445:
    cmp word ptr ds:[MissileAmmo], 0
    je loc_083DA
    jmp short loc_083D7
loc_0844E:
    mov word ptr ds:[MissileAmmo], 4
    jmp short loc_08430
FrontPodAvailable:
    cmp word ptr ds:[FrontPodRecord], -1
    jne loc_08460
    jmp near ptr loc_083DA
loc_08460:
    jmp near ptr loc_083D7
ApplyFrontPod:
    call AddFrontPod
    jmp short loc_08430
SidePodsAvailable:
    cmp word ptr ds:[SidePodLeftInner], -1
    jne loc_08472
    jmp near ptr loc_083DA
loc_08472:
    cmp word ptr ds:[SidePodRightInner], -1
    jne loc_0847C
    jmp near ptr loc_083DA
loc_0847C:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    jne loc_08486
    jmp near ptr loc_083D7
loc_08486:
    cmp word ptr ds:[SidePodLeftOuter], -1
    jne loc_08490
    jmp near ptr loc_083DA
loc_08490:
    cmp word ptr ds:[SidePodRightOuter], -1
    jne loc_0849A
    jmp near ptr loc_083DA
loc_0849A:
    jmp near ptr loc_083D7
ApplySidePods:
    call AddSidePods
    jmp short loc_08430
TrailingPodsAvailable:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 2
    je loc_084AC
    jmp near ptr loc_083D7
loc_084AC:
    cmp word ptr ds:[TrailingPodNear], -1
    jne loc_084B6
    jmp near ptr loc_083DA
loc_084B6:
    cmp word ptr ds:[TrailingPodFar], -1
    jne loc_084C0
    jmp near ptr loc_083DA
loc_084C0:
    jmp near ptr loc_083D7
ApplyTrailingPods:
    call AddTrailingPod
    jmp near ptr loc_08430
loc_084C9:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 0
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
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 1
    jmp near ptr loc_08430
loc_084F0:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 2
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
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 2
    jmp near ptr loc_08430

InitUpgradeSlots:
    mov word ptr ds:[SelectedUpgradeSlot], 0FFFFh
    mov bp, offset UpgradeSlot0
    mov ah, 087h
    call InitUpgradeSlotAtRow
    call InitUpgradeSlotAtRow
    call InitUpgradeSlotAtRow

; BP = upgrade slot, AH = screen row: resets it; returns BP = next slot, AH += 10h.
InitUpgradeSlotAtRow:
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

; Secondary button: runs the selected slot's apply routine, advances the slot and
; redraws; sfx 9 when bought. Preserves BX and BP.
ApplySelectedUpgrade:
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
    call AdvanceToAvailableUpgrade
    mov ax, word ptr ds:[SavedUpgradeSlot]
    mov word ptr ds:[SelectedUpgradeSlot], ax
    call DrawUpgradeSlots
    cmp word ptr ds:[SelectedUpgradeSlot], -1
    jne loc_0859B
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0859B
    mov byte ptr ds:[SfxRequest], 9
loc_0859B:
    pop bp
    pop bx
    ret

; Draws the four upgrade slots (on both pages on EGA). Preserves BP.
DrawUpgradeSlots:
    push bp
    call DrawUpgradeSlotsOnPage
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_085B3
    call FlipEgaDrawPage
    call DrawUpgradeSlotsOnPage
    call FlipEgaDrawPage
loc_085B3:
    pop bp
    ret

DrawUpgradeSlotsOnPage:
    mov bp, offset UpgradeSlot0
    xor di, di
    call DrawUpgradeSlot
    mov bp, offset UpgradeSlot1
    mov di, 1
    call DrawUpgradeSlot
    mov bp, offset UpgradeSlot2
    mov di, 2
    call DrawUpgradeSlot
    mov bp, offset UpgradeSlot3
    mov di, 3

; BP = upgrade slot, DI = its number (highlighted when selected); in the demo the
; selected slot shows DemoUpgradeStatus.
DrawUpgradeSlot:
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
    push word ptr ss:[bp + UPGRADE_SLOT_ICON]
loc_08605:
    push ax
    mov si, word ptr ss:[bp + UPGRADE_SLOT_IMAGE]
    add si, ax
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov di, word ptr ss:[bp + UPGRADE_SLOT_SCREEN]
    push di
    mov cx, 5
loc_0861B:
    call AdvanceDrawColumn
    loop loc_0861B
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop di
    call RetreatDrawColumn
    pop si
    add si, 017h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    push di
    call BlitPackedToScreen
    pop di
    call AdvanceDrawColumn
    pop si
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
; BP = record, CX = sprite base: steps the ramp phase (REC_DIRECTION, mod 18h) every 4th
; frame; REC_SPRITE = Type28FrameRamp[phase] + CX.
StepHatchRampFrame:
    cmp word ptr ds:[FrameDivider4], 0
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
; Types 28h/2Ah: cycles its ramp animation and releases an enemy when none is live (29h,
; 2Bh, 7Ah or 14h by level).
Type28EnemyHatch:
    mov cx, 1Ch
    cmp word ptr ds:[LevelIndex], 1
    je loc_0868A
    cmp word ptr ds:[LevelIndex], 4
    je loc_0868A
    mov cx, 1Ch
loc_0868A:
    call StepHatchRampFrame
    cmp word ptr ds:[EncounterLiveCount], 0
    je loc_08697
    jmp near ptr ScrollRecordThenFinish
loc_08697:
    cmp word ptr ss:[bp + REC_DIRECTION], 7
    je loc_086A0
    jmp near ptr ScrollRecordThenFinish
loc_086A0:
    inc word ptr ss:[bp + REC_DIRECTION]
    call SpawnEnemyHere
    cmp bx, -1
    jne loc_086AE
    jmp near ptr ScrollRecordThenFinish
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
    jmp near ptr ScrollRecordThenFinish
loc_086DA:
    mov word ptr ds:[bx + REC_TYPE], 29h
    mov word ptr ds:[bx + REC_SPRITE], 0A1h
    jmp near ptr ScrollRecordThenFinish
loc_086E7:
    mov word ptr ds:[bx + REC_TYPE], 2Bh
    mov word ptr ds:[bx + REC_SPRITE], 0A5h
    call AimAtPlayer
    jmp near ptr ScrollRecordThenFinish
loc_086F7:
    mov word ptr ds:[bx + REC_TYPE], 7Ah
    mov word ptr ds:[bx + REC_SPRITE], 20h
    call AimAtPlayer
    jmp near ptr ScrollRecordThenFinish
; Type 7Ah with sprite base 15Ch.
Type7CAimLineFlyerAlt:
    mov ax, 15Ch
    jmp short loc_0870F
; Animated type 60h flight along the aim line.
Type7AAimLineFlyer:
    mov ax, 20h
loc_0870F:
    add ax, ds:[FrameCount4]
    jmp short loc_0871C
; 2 px steps along its aimed REC_DELTA; destroyed when X leaves 0..C0h.
Type2BAimedDart:
    mov ax, 0A5h
    add ax, ds:[SlowCount4]
loc_0871C:
    mov ss:[bp + REC_SPRITE], ax
    jmp short Type60FlyAlongAimLine
; Emerges over four frames, then aims at the player and flies like type 60h.
Type29EmergeThenDart:
    cmp word ptr ss:[bp + REC_SPRITE], 0A4h
    je Type60FlyAlongAimLine
    cmp word ptr ds:[FrameCount8], 7
    je loc_08732
    jmp near ptr ScrollRecordThenFinish
loc_08732:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp word ptr ss:[bp + REC_SPRITE], 0A4h
    je loc_0873F
    jmp near ptr ScrollRecordThenFinish
loc_0873F:
    mov bx, bp
    call AimAtPlayer
; 2 px Bresenham steps along REC_DELTA; destroyed when X leaves 0..C0h.
Type60FlyAlongAimLine:
    mov word ptr ds:[ChaseStepPixels], 2
    call StepAlongDelta
    mov word ptr ds:[ChaseStepPixels], 3
    cmp word ptr ss:[bp + REC_X], 0C0h
    jg loc_08763
    cmp word ptr ss:[bp + REC_X], 0
    jl loc_08763
    jmp near ptr ScrollRecordThenFinish
loc_08763:
    call DestroyRecord
    jmp near ptr ScrollRecordThenFinish
; As type 87h with sprite base 0BFh.
Type8FAnimFireBurstB:
    mov bx, ds:[FrameCount64]
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
    jmp near ptr ScrollRecordThenFinish
loc_08794:
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0879F
    jmp near ptr ScrollRecordThenFinish
loc_0879F:
    mov word ptr ds:[bx + REC_SPRITE], 44h
    jmp near ptr ScrollRecordThenFinish
; Above Y 60h fires down every 128 frames; below falls 4 px per frame (shares type 2Dh's
; tail).
Type71FireThenDiveBelow60:
    mov ax, ds:[SlowCount8]
    add ax, 12Bh
    jmp short loc_087B5
; Above Y 60h: scrolls and fires down every 128 frames; below: falls 4 px per frame.
Type2DHoverFireThenPlunge:
    mov ax, ds:[SlowCount4]
    add ax, 93h
loc_087B5:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_Y], 60h
    ja loc_087D3
    cmp word ptr ds:[FrameCount128], 7Fh
    je loc_087C8
    jmp near ptr ScrollRecordThenFinish
loc_087C8:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
loc_087D3:
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 80h, then steers at the player's column (SteerSpeed is left from the
; previous handler).
Type2EPlungeAtPlayerColumn:
    mov ax, ds:[ScrollDeltaY]
    add ss:[bp + REC_SAVED_Y], ax
    call NextRandomWord
    and bx, 3
    add bx, 0ADh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_Y], 80h
    jnl loc_087F7
    jmp near ptr ScrollRecordThenFinish
loc_087F7:
    jne loc_087FC
    call SetPlungeTargetBelowPlayer
loc_087FC:
    call SteerToSaved
    jmp near ptr FinishRecordUpdate
; Type 2Eh: targets the player's column far below (REC_SAVED_Y 7530h); sfx 0Bh.
SetPlungeTargetBelowPlayer:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0880E
    mov byte ptr ds:[SfxRequest], 0Bh
loc_0880E:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    and ax, 0FFFEh
    mov ss:[bp + REC_SAVED_X], ax
    mov word ptr ss:[bp + REC_SAVED_Y], 7530h
    ret
; Steers to REC_SAVED (moving with the scroll); on arrival toggles REC_SAVED_X between 0
; and C0h.
Type2FScrollingShuttle:
    mov word ptr ss:[bp + REC_SPRITE], 43h
    mov word ptr ds:[SteerSpeed], 2
    call SteerToSaved
    pushf
    mov ax, ds:[ScrollDeltaY]
    add ss:[bp + REC_SAVED_Y], ax
    popf
    jne loc_0883B
    jmp near ptr ScrollRecordThenFinish
loc_0883B:
    cmp word ptr ss:[bp + REC_SAVED_X], 0
    je loc_08849
    mov word ptr ss:[bp + REC_SAVED_X], 0
    jmp near ptr ScrollRecordThenFinish
loc_08849:
    mov word ptr ss:[bp + REC_SAVED_X], 0C0h
    jmp near ptr ScrollRecordThenFinish
; Fires when FrameCount16 is 15 (every 4 frames on level 5).
Type30AnimatedShooter:
    cmp word ptr ds:[LevelIndex], 5
    jne loc_08870
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    sub ax, ss:[bp + REC_X]
    jns loc_08862
    neg ax
loc_08862:
    cmp ax, 0Ch
    jb loc_08870
    cmp word ptr ss:[bp + REC_SPRITE], 46h
    jne loc_08870
    jmp near ptr ScrollRecordThenFinish
loc_08870:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 44h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0888E
    cmp word ptr ds:[FrameCount4], 3
    jmp short loc_08893
loc_0888E:
    cmp word ptr ds:[FrameCount16], 0Fh
loc_08893:
    je loc_08898
    jmp near ptr ScrollRecordThenFinish
loc_08898:
    call SpawnThrottledChild
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_088A7
    mov byte ptr ds:[SfxRequest], 0Eh
loc_088A7:
    jmp near ptr ScrollRecordThenFinish
; Falls 3 px per frame.
Type31FallFast3:
    mov word ptr ss:[bp + REC_SPRITE], 2Eh
    add word ptr ss:[bp + REC_Y], 3
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly 90h, then becomes type 33h heading up-left.
Type32DescendThenBounce:
    mov word ptr ss:[bp + REC_SPRITE], 24h
loc_088BB:
    cmp word ptr ss:[bp + REC_Y], 90h
    je loc_088C5
    jmp near ptr ScrollRecordThenFinish
loc_088C5:
    mov word ptr ss:[bp + REC_TYPE], 33h
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
; Three terrain steps per frame on a diagonal, reflecting on a blocked step.
Type33TerrainBouncer:
    call TryTerrainStep
    jne loc_088E1
    call TryTerrainStep
    jne loc_088E1
    call TryTerrainStep
    jne loc_088E1
    jmp near ptr ScrollRecordThenFinish
loc_088E1:
    xor word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp near ptr ScrollRecordThenFinish
; Fires sideways with sfx 13h from FrameCount64 32h on; levels 0 and 6 wait until Y 50h.
Type34SideFiringTurret:
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
    jmp near ptr ScrollRecordThenFinish
loc_08915:
    cmp word ptr ds:[FrameCount64], 32h
    jae loc_0891F
    jmp near ptr ScrollRecordThenFinish
loc_0891F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0892B
    mov byte ptr ds:[SfxRequest], 13h
loc_0892B:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    cmp word ptr ds:[CountGate2324], 1
    je loc_0897C
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_RIGHT
    jmp short loc_0897C
loc_0893E:
    cmp word ptr ds:[LevelIndex], 6
    je loc_0894C
    cmp word ptr ds:[LevelIndex], 0
    jne loc_08955
loc_0894C:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae loc_08955
    jmp near ptr ScrollRecordThenFinish
loc_08955:
    cmp word ptr ds:[FrameCount64], 32h
    jae loc_0895F
    jmp near ptr ScrollRecordThenFinish
loc_0895F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0896B
    mov byte ptr ds:[SfxRequest], 13h
loc_0896B:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    cmp word ptr ds:[CountGate2324], 1
    je loc_0897C
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
loc_0897C:
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
; Bounces between Y 8 and 90h at an X-dependent speed and fires at each turn.
Type37VerticalBouncerShooter:
    mov ax, ds:[SlowCount4]
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
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je loc_089D1
    neg ax
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 8
    jna loc_089C6
    jmp near ptr ScrollRecordThenFinish
loc_089C6:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
loc_089D1:
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 90h
    jae loc_089DE
    jmp near ptr ScrollRecordThenFinish
loc_089DE:
    call SpawnThrottledChild
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    jmp near ptr ScrollRecordThenFinish
; Terrain patrol firing down every 64 frames.
Type83PatrolShootDown64:
    mov ax, ds:[SlowCount4]
    add ax, 10h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount64], 3Fh
    jne loc_089FC
    call SpawnShotDown
loc_089FC:
    jmp near ptr HorizontalTerrainPatrol
; Descends diagonally, turning at X 0 and C0h.
Type38WallBounceDescend:
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
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 80h, then dashes right 4 px per frame and is destroyed past X C0h.
Type39DashRightAtRow80:
    mov word ptr ss:[bp + REC_SPRITE], 6Eh
    cmp word ptr ss:[bp + REC_Y], 80h
    jl loc_08A52
    jne loc_08A3D
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_08A3D
    mov byte ptr ds:[SfxRequest], 0Bh
loc_08A3D:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    call MoveInDirection4
    cmp word ptr ss:[bp + REC_X], 0C0h
    ja loc_08A4F
    jmp near ptr ScrollRecordThenFinish
loc_08A4F:
    call DestroyRecord
loc_08A52:
    jmp near ptr ScrollRecordThenFinish
; Below Y 80h re-aims at the player every frame and steps toward it.
Type3AHomeOnPlayerBelow80:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    add bx, offset PingPongFrames4
    mov bx, ds:[bx]
    add bx, 0CCh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_Y], 80h
    jnl loc_08A72
    jmp near ptr ScrollRecordThenFinish
loc_08A72:
    mov bx, offset PrimaryRecord
    call SetDeltaToward
    call StepAlongDelta
    jmp near ptr ScrollRecordThenFinish
; Falls 2 px per frame with a random sprite each frame.
Type3BFallRandomFlicker:
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
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly B0h, then becomes type 3Dh heading up-left.
Type3CDescendThenBounceAlt:
    mov word ptr ss:[bp + REC_SPRITE], 0C5h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_08AB3
    jmp near ptr ScrollRecordThenFinish
loc_08AB3:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_08ABF
    mov byte ptr ds:[SfxRequest], 1Dh
loc_08ABF:
    inc word ptr ss:[bp + REC_TYPE]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
; Animated type 33h.
Type3DAnimatedTerrainBouncer:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    add bx, offset PingPongFrames4
    mov bx, ds:[bx]
    add bx, 0C5h
    mov ss:[bp + REC_SPRITE], bx
    jmp near ptr Type33TerrainBouncer
; At Y A0h aims at the player once and becomes type 3Fh.
Type3EDropThenAimedDash:
    mov word ptr ss:[bp + REC_SPRITE], 0Eh
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jnl loc_08AEC
    jmp near ptr ScrollRecordThenFinish
loc_08AEC:
    mov word ptr ss:[bp + REC_TYPE], 3Fh
    mov bx, bp
    call AimAtPlayer
; Type 60h flight along the aim line.
Type3FStraightLineToAimPoint:
    jmp near ptr Type60FlyAlongAimLine
; Jitters one random axis by 1 px; below Y 80h descends 2 px per frame and fires every
; 32 frames.
Type68JitterDescendFiring:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 24h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 4
    je loc_08B4C
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0A1h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 5
    je loc_08B4C
    mov bx, ds:[SlowCount4]
    shl bx, 1
loc_08B2E:
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 100h
    mov ss:[bp + REC_SPRITE], bx
    jmp short loc_08B4C
; Jitters one random axis by 1 px; below Y 80h falls 2 px per frame and fires every 32
; frames.
Type40JitterFallShooter:
    mov bx, ds:[SlowCount4]
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
    mov ax, ds:[FrameCount64]
    and ax, 1
    shl ax, 1
    dec ax
    add ss:[bp + si], ax
    cmp word ptr ss:[bp + REC_Y], 80h
    jnl loc_08B6F
    jmp near ptr ScrollRecordThenFinish
loc_08B6F:
    cmp word ptr ds:[FrameCount32], 1Fh
    jne loc_08B79
    call SpawnThrottledChild
loc_08B79:
    add word ptr ss:[bp + REC_Y], 2
    jmp near ptr ScrollRecordThenFinish
; Jitters one random axis by 4 px, keeping below Y 18h.
Type69JitterDropToY18:
    mov ax, ds:[FrameCount16]
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
    mov ax, ds:[FrameCount64]
    and ax, 1
    shl ax, 1
    dec ax
    shl ax, 1
    shl ax, 1
    add ss:[bp + si], ax
    cmp word ptr ss:[bp + REC_Y], 18h
    jng loc_08BC1
    jmp near ptr ScrollRecordThenFinish
loc_08BC1:
    add word ptr ss:[bp + REC_Y], 8
    jmp near ptr ScrollRecordThenFinish
; Starts the waypoint path Type41Path as type 12h (as 43h, 44h, 45h, 4Ah).
Type41FollowPathType41:
    mov word ptr ss:[bp + REC_PATH], offset Type41Path
    jmp near ptr StartPathFollow
; Starts the waypoint path Type43Path as type 12h.
Type43FollowPathType43:
    mov word ptr ss:[bp + REC_PATH], offset Type43Path
    jmp near ptr StartPathFollow
; Starts the waypoint path Type44Path as type 12h.
Type44FollowPathType44:
    mov word ptr ss:[bp + REC_PATH], offset Type44Path
    jmp near ptr StartPathFollow
; Starts the waypoint path Type45Path as type 12h.
Type45FollowPathType45:
    mov word ptr ss:[bp + REC_PATH], offset Type45Path
    jmp near ptr StartPathFollow
; Starts the waypoint path Type4APath as type 12h.
Type4AFollowPathType4A:
    mov word ptr ss:[bp + REC_PATH], offset Type4APath
    jmp near ptr StartPathFollow
; Starts the waypoint path Type51Path as type 12h.
Type51FollowType51Path:
    mov word ptr ss:[bp + REC_PATH], offset Type51Path
    jmp near ptr StartPathFollow
; Descends 1 px per frame, swaying left and right every 32 frames.
Type42DescendSway:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[FrameCount64], 1Fh
    ja loc_08C19
    dec word ptr ss:[bp + REC_X]
    jmp near ptr ScrollRecordThenFinish
loc_08C19:
    inc word ptr ss:[bp + REC_X]
    jmp near ptr ScrollRecordThenFinish
; Type 89h with sprite base 9Dh.
Type8APatrolShootDown32Alt:
    mov ax, ds:[SlowCount4]
    add ax, 9Dh
    jmp near ptr loc_0B2AC
; Above Y 60h fires down every 128 frames; below falls 4 px per frame.
Type46HoverShootThenDive:
    mov ax, ds:[SlowCount6]
    add ax, 4Bh
    jmp near ptr loc_087B5
; Terrain patrol firing down every 32 frames.
Type47PatrolDropShooter:
    mov ax, ds:[SlowCount6]
    add ax, 51h
    jmp near ptr loc_0B2AC
; Falls 2 px per frame; every 16 frames fires up to eight type 4 shots in all
; directions.
Type49RadialBurstFaller:
    mov ax, 1Dh
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ds:[FrameCount16], 0Fh
    je loc_08C4E
    jmp near ptr ScrollRecordThenFinish
loc_08C4E:
    mov cx, 8
loc_08C51:
    push cx
    call SpawnAimedShot
    pop cx
    cmp bx, -1
    jne loc_08C5E
    jmp near ptr ScrollRecordThenFinish
loc_08C5E:
    mov word ptr ds:[bx + REC_TYPE], 4
    dec cx
    mov ds:[bx + REC_DIRECTION], cx
    inc cx
    loop loc_08C51
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly 40h, then becomes type 33h heading up-right.
Type4BDescendThenBounceUpRight:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_Y], 40h
    je loc_08C87
    jmp near ptr ScrollRecordThenFinish
loc_08C87:
    mov word ptr ss:[bp + REC_TYPE], 33h
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
    jmp near ptr Type33TerrainBouncer
; Scrolls to Y B0h, then rises 4 px per frame without scrolling.
Type4CSinkThenRise:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP
    je loc_08CAE
    mov word ptr ss:[bp + REC_SPRITE], 74h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_08CA9
    jmp near ptr ScrollRecordThenFinish
loc_08CA9:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
loc_08CAE:
    mov ax, ds:[FrameCount8]
    shr ax, 1
    shr ax, 1
    add ax, 73h
    mov ss:[bp + REC_SPRITE], ax
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr FinishRecordUpdate
; Scrolls to Y 80h, rises to Y 60h, then dashes right as type 39h.
Type4DSinkRiseThenDash:
    mov word ptr ss:[bp + REC_SPRITE], 6Eh
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jne loc_08CDC
    cmp word ptr ss:[bp + REC_Y], 80h
    je loc_08CD7
    jmp near ptr ScrollRecordThenFinish
loc_08CD7:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
loc_08CDC:
    sub word ptr ss:[bp + REC_Y], 4
    cmp word ptr ss:[bp + REC_Y], 60h
    je loc_08CE9
    jmp near ptr FinishRecordUpdate
loc_08CE9:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    mov word ptr ss:[bp + REC_TYPE], 39h
    jmp near ptr Type39DashRightAtRow80
; Animated type 32h.
Type4EAnimDescendThenBounce:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
    jmp near ptr loc_088BB
; Falls 4 px per frame with a cycling sprite.
Type4FFallFast4Flicker:
    mov ax, ds:[FrameCount8]
    add ax, bp
    add ax, ds:[RecordTickCounter]
    and ax, 7
    add ax, 80h
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
; Only the scroll tail.
Type52ScrollOnly:
    jmp near ptr ScrollRecordThenFinish
; Animates from sprite base REC_SPRITE_BASE.
Type53AnimateFromSpriteBase:
    mov bx, ds:[FrameCount8]
    and bx, -2
    mov bx, ds:[bx + PingPongFrames4]
    add bx, ss:[bp + REC_SPRITE_BASE]
    mov ss:[bp + REC_SPRITE], bx
    jmp near ptr ScrollRecordThenFinish
; CF = 0 and return; no caller found.
    clc
    ret
; Descends 1 px per frame and fires an aimed shot whenever a shot slot is free.
Type48CreeperAimedFire:
    call far ptr Type48CreeperBody
    call SpawnAimedShot
    jmp near ptr ScrollRecordThenFinish
; Falls to Y 90h, aims at the player and becomes type 7Ch.
Type7BDropThenAim:
    call far ptr Type7BDropThenAimBody
    jmp near ptr ScrollRecordThenFinish
; Types 13h/15h/1Ch/1Fh/7Dh/7Eh: steers along LeaderScriptCursor and drops followers at
; each point (13h: 14h, 15h: 16h/17h, 1Ch: 1Dh/1Eh, 1Fh: five 20h; 7Dh/7Eh: 7Fh/81h).
Type13FormationLeader:
    call far ptr Type13FormationLeaderBody
    jmp near ptr FinishRecordUpdate
; Steers to REC_SAVED, then becomes type 93h; no scroll.
Type81SweeperEnterSteer:
    call far ptr Type81SweeperEnterBody
    jmp near ptr FinishRecordUpdate
; Sweeps sideways, descends and climbs back; destroyed after 100 blocked climbs.
Type93SweepDescendClimb:
    call far ptr Type93SweepBody
    cmp word ptr ss:[bp + REC_BLOCKED_CLIMBS], 064h
    jae loc_08D6D
    jmp near ptr FinishRecordUpdate
loc_08D6D:
    call DestroyRecord
    jmp near ptr FinishRecordUpdate
; Steers into its march slot (REC_SAVED), then becomes type 80h; no scroll.
Type7FMarchEnterSteer:
    call far ptr Type7FMarchEnterBody
    jmp near ptr FinishRecordUpdate
; Marches with the March* block state: shifts, drops and fires on the shared flags, and
; dives from sprite 164h on.
Type80MarchFormationMember:
    call far ptr Type80MarchMemberBody
    jmp near ptr FinishRecordUpdate
loc_08D83:
    call far ptr Type21LeaderPathBody
    jmp near ptr FinishRecordUpdate

; Far-call trampoline: lets far code call the main-frame near routine at offset AX.
; All registers and flags pass through both ways.
FarCallMainNearViaAX:
    call ax
    retf

; Same trampoline with the near target offset in BP.
FarCallMainNearViaBP:
    call bp
    retf
; NOP filler (word alignment).
    db 90h
; Built by BuildRowTables: offset of image n in its bank = n * its size, for level
; blocks (BlockBytes) and 8x8, 16x16 and 32x32 masked sprites (Sprite8Bytes ...).
BlockOffsets dw 256 dup (0)
Sprite8Offsets dw 256 dup (0)
Sprite16Offsets dw 256 dup (0)
Sprite32Offsets dw 256 dup (0)
MAIN ends

FAR0F7F segment byte public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
extrn ResetMarchState:near
extrn ResetType21Path:near
; Far: when a key was pressed (KeyLastMakeCode), advance every cheat code by it and
; apply the codes it completes, then clear KeyLastMakeCode.
CheckCheatCodes:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_0F89D
    call CheckCheatRemindMe
    call CheckCheatEveryDayIDie
    call CheckCheatWhatOilShortage
    call CheckCheatLifeInTheFastLane
    call CheckCheatBonusCheatOn
    call CheckCheatMyNameIsSmith
    call CheckCheatSchnellfeuer
    mov byte ptr ds:[KeyLastMakeCode], 0
loc_0F89D:
    retf

CheckCheatWhatOilShortage:
    mov bx, offset CheatWhatOilShortage
    call MatchCheatKey
    jne loc_0F8AB
    mov byte ptr ds:[WhatOilShortageFlag], 1
loc_0F8AB:
    ret

CheckCheatLifeInTheFastLane:
    mov bx, offset CheatLifeInTheFastLane
    call MatchCheatKey
    jne loc_0F8B9
    mov byte ptr ds:[KeepLivesFlag], 1
loc_0F8B9:
    ret

CheckCheatBonusCheatOn:
    mov bx, offset CheatBonusCheatOn
    call MatchCheatKey
    jne loc_0F8C7
    mov byte ptr ds:[BonusKeysEnabled], 1
loc_0F8C7:
    ret

CheckCheatMyNameIsSmith:
    mov bx, offset CheatMyNameIsSmith
    call MatchCheatKey
    jne loc_0F8D5
    mov byte ptr ds:[LevelSkipEnabled], 1
loc_0F8D5:
    ret

CheckCheatSchnellfeuer:
    mov bx, offset CheatGibStMirSchnellfeuer
    call MatchCheatKey
    jne loc_0F8E3
    mov byte ptr ds:[RapidFireEnabled], 1
loc_0F8E3:
    ret

; Sets all five cheat flags and AllCheatsFlag.
CheckCheatRemindMe:
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

; Clears all five cheat flags and AllCheatsFlag.
CheckCheatEveryDayIDie:
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
; scancode (then BiosBeep runs through the far bridge). A mismatch resets the cursor
; without retrying the key.
MatchCheatKey:
    mov di, word ptr ds:[bx]
    mov al, byte ptr ds:[KeyLastMakeCode]
    cmp al, byte ptr ds:[di]
    jne loc_0F94D
    inc word ptr ds:[bx]
    cmp byte ptr ds:[di + 1], 0
    jne loc_0F952
    mov bp, offset BiosBeep
    call far ptr FarCallMainNearViaBP
    jmp short loc_0F952
loc_0F94D:
    mov word ptr ds:[bx], bx
    add word ptr ds:[bx], 2
loc_0F952:
    ret

; With a GroupDropKind: GroupSlotPtr/GroupSlotIndex = the first empty GroupTable entry;
; otherwise, or when full, GroupSlotPtr = FFFFh (GroupSlotIndex is then stale).
AllocGroupSlot:
    push bx
    push cx
    cmp word ptr ds:[GroupDropKind], 0
    je loc_0F976
    mov cx, 010h
    mov word ptr ds:[GroupSlotIndex], 0
    mov bx, offset GroupTable
loc_0F968:
    cmp byte ptr ds:[bx + GROUP_LIVE], 0
    je loc_0F979
    add bx, 2
    inc word ptr ds:[GroupSlotIndex]
    loop loc_0F968
loc_0F976:
    mov bx, 0FFFFh
loc_0F979:
    mov word ptr ds:[GroupSlotPtr], bx
    pop cx
    pop bx
    retf

; DOS 3+: saves the allocation strategy and selects best fit.
SetBestFitAllocStrategy:
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

RestoreAllocStrategy:
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
; Far body of Type48CreeperAimedFire: sprite by level (level 5 also drifts toward the
; player), REC_Y + 1.
Type48CreeperBody:
    cmp word ptr ds:[LevelIndex], 5
    je loc_0F9CD
    mov ax, 1Ch
    cmp word ptr ds:[LevelIndex], 3
    je loc_0F9F2
    mov ax, ds:[FrameCount8]
    shr ax, 1
    add ax, 22h
    jmp short loc_0F9F2
loc_0F9CD:
    mov cx, 1
    mov ax, ss:[bp + REC_X]
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jb loc_0F9E1
    pushf
    neg cx
    popf
    ja loc_0F9E1
    xor cx, cx
loc_0F9E1:
    add ss:[bp + REC_X], cx
    mov bx, ds:[SlowCount8]
    and bx, -2
    mov ax, ds:[bx + PingPongFrames4]
    add ax, 26h
loc_0F9F2:
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    retf

; BX = new formation leader, AX = its leader script: starts the script and resets the
; encounter and sway state; the leader gets 20 hit points.
StartLeaderScript:
    mov word ptr ds:[LeaderScriptCursor], ax
    mov word ptr ds:[FormationSlotCursor], offset FormationSlots
    mov word ptr ds:[bx + REC_HIT_POINTS], 014h
    mov word ptr ds:[EncounterLiveCount], 1
    mov word ptr ds:[EncounterEndDelay], 064h
    mov word ptr ds:[SwayDirX], 1
    mov word ptr ds:[SwayPhase], 1
    mov word ptr ds:[SwayDropY], 0
    mov word ptr ds:[SwayReversals], 0
    mov word ptr ds:[EncounterTicks], 0
    call ResetMarchState
    call ResetType21Path
    retf

; Spin until no KeyDownTable entry is set; only the keyboard IRQ can end the wait.
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
Type7BDropThenAimBody:
    mov word ptr ss:[bp + REC_SPRITE], 15Ch
    cmp word ptr ss:[bp + REC_Y], 90h
    jl loc_0FA69
    mov word ptr ss:[bp + REC_TYPE], 7Ch
    mov bx, bp
    mov ax, offset AimAtPlayer
    call far ptr FarCallMainNearViaAX
loc_0FA69:
    retf
Type13FormationLeaderBody:
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
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne loc_0FAD8
    jmp near ptr loc_0FC38
loc_0FAD8:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 07Fh
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 5
    inc word ptr ds:[EncounterLiveCount]
    jmp near ptr loc_0FC38
loc_0FAF9:
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    jne loc_0FB06
    jmp near ptr loc_0FC38
loc_0FB06:
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne loc_0FB16
    jmp near ptr loc_0FC38
loc_0FB16:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    test ax, 1
    je loc_0FB38
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
loc_0FB38:
    mov word ptr ds:[bx + REC_TYPE], 081h
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 019h
    mov word ptr ds:[bx + REC_HIT_POINTS], 5
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    mov word ptr ds:[bx + REC_BLOCKED_CLIMBS], 0
    inc word ptr ds:[EncounterLiveCount]
    jmp near ptr loc_0FC38
loc_0FB58:
    add word ptr ds:[LeaderScriptCursor], 4
    mov cx, 5
loc_0FB60:
    push cx
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    mov si, word ptr ds:[FormationSlotCursor]
    add word ptr ds:[FormationSlotCursor], 4
    cmp bx, -1
    je loc_0FB90
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 020h
    mov word ptr ds:[bx + REC_DIVE_PHASE], 0FFFFh
    inc word ptr ds:[EncounterLiveCount]
loc_0FB90:
    pop cx
    loop loc_0FB60
    jmp near ptr loc_0FC38
loc_0FB96:
    add word ptr ds:[LeaderScriptCursor], 8
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne loc_0FBAB
    jmp near ptr loc_0FC38
loc_0FBAB:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 01Dh
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0FBCB
    mov word ptr ds:[bx + REC_TYPE], 01Eh
    mov word ptr ds:[bx + REC_SPRITE], 043h
loc_0FBCB:
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 014h
    inc word ptr ds:[EncounterLiveCount]
    jmp short loc_0FC38
loc_0FBD6:
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    je loc_0FC38
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_0FC38
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 016h
    mov word ptr ds:[bx + REC_PATH], offset SweepPath
    cmp word ptr ss:[bp + REC_Y], 040h
    je loc_0FC12
    mov word ptr ds:[bx + REC_TYPE], 017h
    mov word ptr ds:[bx + REC_PATH], offset SweepPathLeadIn
loc_0FC12:
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 3
    inc word ptr ds:[EncounterLiveCount]
    jmp short loc_0FC38
loc_0FC22:
    add word ptr ds:[LeaderScriptCursor], 4
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_0FC38
    inc word ptr ds:[EncounterLiveCount]
loc_0FC38:
    mov ax, word ptr ss:[bp + REC_DIRECTION]
    add ax, 03Bh
    mov word ptr ss:[bp + REC_SPRITE], ax
    retf
Type81SweeperEnterBody:
    mov word ptr ss:[bp + REC_SPRITE], 016Ah
    mov word ptr ds:[SteerSpeed], 1
    push word ptr ss:[bp + REC_DIRECTION]
    mov ax, offset SteerToSaved
    call far ptr FarCallMainNearViaAX
    pop word ptr ss:[bp + REC_DIRECTION]
    je loc_0FC62
    mov word ptr ss:[bp + REC_TYPE], 093h
loc_0FC62:
    retf
Type93SweepBody:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript7DEnd
    je loc_0FC6E
    jmp near ptr loc_0FE69
loc_0FC6E:
    cmp word ptr ss:[bp + REC_ENTRY_DELAY], 0
    je loc_0FC7C
    dec word ptr ss:[bp + REC_ENTRY_DELAY]
    je loc_0FC7C
    jmp near ptr loc_0FE69
loc_0FC7C:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP
    je loc_0FCC5
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
    je loc_0FCC5
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
    je loc_0FCC5
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jne loc_0FD12
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FCC0
    cmp word ptr ss:[bp + REC_Y], 0D0h
    jae loc_0FCC0
    jmp near ptr loc_0FE75
loc_0FCC0:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
loc_0FCC5:
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    je loc_0FCD2
    call Type93BlockedTurnUp
loc_0FCD2:
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    je loc_0FCDF
    call Type93BlockedTurnUp
loc_0FCDF:
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    je loc_0FCEC
    call Type93BlockedTurnUp
loc_0FCEC:
    jne loc_0FCF8
    mov word ptr ss:[bp + REC_BLOCKED_CLIMBS], 0
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
loc_0FCF8:
    cmp word ptr ss:[bp + REC_Y], 020h
    jbe loc_0FD01
    jmp near ptr loc_0FE75
loc_0FD01:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    test word ptr ss:[bp + REC_X], 2
    je loc_0FD12
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
loc_0FD12:
    mov ax, word ptr ds:[FrameCount16]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    add ax, 016Ah
    mov word ptr ss:[bp + REC_SPRITE], ax
    cmp byte ptr ds:[Type93KilledPulse], 0
    je loc_0FD5B
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    pop word ptr ss:[bp + REC_DIRECTION]
loc_0FD5B:
    mov ax, word ptr ds:[RecordTickCounter]
    and ax, 0FFh
    cmp ax, 0FFh
    jne loc_0FD72
    mov ax, offset SpawnShotDown
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[RecordTickCounter]
loc_0FD72:
    cmp word ptr ds:[RecordTickCounter], 0
    je loc_0FD81
    cmp word ptr ds:[RecordTickCounter], 02BDh
    jne loc_0FD8D
loc_0FD81:
    mov ax, offset SpawnAimedShot
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[RecordTickCounter]
loc_0FD8D:
    cmp word ptr ss:[bp + REC_X], 0
    je loc_0FE08
    cmp word ptr ss:[bp + REC_X], 0C0h
    je loc_0FDA5
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    je loc_0FDA3
    jmp near ptr loc_0FE35
loc_0FDA3:
    jmp short loc_0FDD2
loc_0FDA5:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
loc_0FDD2:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    jmp short loc_0FE69
loc_0FE01:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp short loc_0FE69
loc_0FE08:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
loc_0FE35:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    jmp short loc_0FE69
loc_0FE64:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
loc_0FE69:
    cmp word ptr ss:[bp + REC_Y], 080h
    jb loc_0FE75
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
loc_0FE75:
    retf
; BP = type 93h: counts a blocked climb (REC_BLOCKED_CLIMBS) and turns diagonally up toward
; the centre.
Type93BlockedTurnUp:
    inc word ptr ss:[bp + REC_BLOCKED_CLIMBS]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
    cmp word ptr ss:[bp + REC_X], 060h
    ja loc_0FE89
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
loc_0FE89:
    ret
Type7FMarchEnterBody:
    mov word ptr ss:[bp + REC_SPRITE], 162h
    mov word ptr ds:[SteerSpeed], 1
    mov ax, offset SteerToSaved
    call far ptr FarCallMainNearViaAX
    je loc_0FEA4
    mov word ptr ss:[bp + REC_TYPE], 80h
loc_0FEA4:
    retf
Type80MarchMemberBody:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript7EEnd
    je loc_0FEB0
    jmp near ptr loc_1000C
loc_0FEB0:
    cmp word ptr ss:[bp + REC_ENTRY_DELAY], 0
    je loc_0FEBE
    dec word ptr ss:[bp + REC_ENTRY_DELAY]
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
    mov ax, ds:[RecordTickCounter]
    and ax, 0FFh
    cmp ax, 7Dh
    je loc_0FEE5
    or ax, ax
    jne loc_0FEF6
loc_0FEE5:
    inc word ptr ds:[RecordTickCounter]
    mov word ptr ss:[bp + REC_SPRITE], 164h
    mov word ptr ss:[bp + REC_HIT_POINTS], 3
    jmp near ptr loc_1000C
loc_0FEF6:
    cmp byte ptr ds:[MarchFireNow], 0
    je loc_0FF0E
    mov byte ptr ds:[MarchFireNow], 0
    mov ax, offset SpawnAimedShot
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[RecordTickCounter]
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
    mov ds:[SteerTargetX], ax
    mov ax, ss:[bp + REC_SAVED_Y]
    and ax, 0FFFEh
    and word ptr ss:[bp + REC_Y], -2
    mov ds:[SteerTargetY], ax
    mov word ptr ds:[SteerSpeed], 1
    mov ax, offset SteerTowardTarget
    call far ptr FarCallMainNearViaAX
    mov word ptr ss:[bp + REC_SPRITE], 160h
    mov ax, ds:[FrameCount8]
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
    cmp word ptr ds:[FrameCount4], 3
    jne loc_1000C
    inc word ptr ss:[bp + REC_SPRITE]
    jmp short loc_1000C
loc_0FFC6:
    add word ptr ss:[bp + REC_Y], 5
    mov word ptr ss:[bp + REC_SPRITE], 168h
    mov ax, ds:[FrameCount8]
    shr ax, 1
    shr ax, 1
    je loc_0FFDB
    inc word ptr ss:[bp + REC_SPRITE]
loc_0FFDB:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jna loc_1000C
    mov word ptr ss:[bp + REC_Y], 0
    cmp word ptr ds:[FrameCount4], 3
    je loc_10002
loc_0FFEE:
    mov ax, offset NextRandomWord
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