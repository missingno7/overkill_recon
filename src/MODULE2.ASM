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
extrn PlayerHitX:word
extrn PlayerHitY:word
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
public ApplyBeam
public ApplyForkShot
public ApplyFrontPod
public ApplyHeavyShot
public ApplyMissiles
public ApplySelectedUpgrade
public ApplyShipForm1
public ApplyShipForm2
public ApplySidePods
public ApplySideShots
public ApplySingleShot
public ApplyTrailingPods
public ApplyTwinRising16
public ApplyTwinRising3
public BeamAvailable
public BlitPackedStride104
public BlitPackedStride160
public BlitPackedToScreen
public BlockOffsets
public CheckCheatCodes
public CheckFirePhase
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
public ForkShotAvailable
public FrontPodAvailable
public HeavyShotAvailable
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
public MissilesAvailable
public PlayerShotsHitRecord
public RecordNearPlayerHitPoint
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
public ShipForm1Available
public ShipForm2Available
public ShutdownGame
public ShutdownWithError
public SidePodsAvailable
public SideShotsAvailable
public SingleShotAvailable
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
public TwinRising16Available
public TwinRising3Available
public Type13FormationLeader
public Type21LeaderPath
public Type24TurretLeftFire32
public Type25TurretRightFire32
public Type26TurretRemnant
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
public UpgradeNeverAvailable
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
extrn PatrolSpriteShootDown32:near
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
    jne @@failed
    mov ax, seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH
    mov es, ax
    xor si, si
    mov cx, HISCORE_BLOCK_BYTES
    xor ax, ax
@@sumBlock:
    add al, byte ptr es:[si]
    adc ah, 0
    inc si
    loop @@sumBlock
    cmp ax, word ptr es:[si]
    jne @@failed
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
@@failed:
    xor al, al
    ret

; SS:BP = BCD score: when it makes the table, shifts the lower entries down, shows the
; table and reads the player's name.
InsertHighScore:
    mov byte ptr ds:[HiscoreEntryRow], 4
    mov bx, offset HiscoreBlock
    mov cx, 8
@@compareEntry:
    mov al, byte ptr ds:[bx + 0Ch]
    sub al, byte ptr ss:[bp]
    mov al, byte ptr ds:[bx + 0Dh]
    sbb al, byte ptr ss:[bp + 1]
    mov al, byte ptr ds:[bx + 0Eh]
    sbb al, byte ptr ss:[bp + 2]
    mov al, byte ptr ds:[bx + 0Fh]
    sbb al, byte ptr ss:[bp + 3]
    jb @@qualifies
    add byte ptr ds:[HiscoreEntryRow], 2
    add bx, 010h
    loop @@compareEntry
    ret
@@qualifies:
    mov word ptr ds:[HiscoreQualified], 1
    mov es, word ptr cs:[MainDataSegment]
    std
    mov si, offset HiscoreBlock + 7Fh
    mov di, offset HiscoreBlock + 8Fh
@@shiftEntriesDown:
    movsb
    cmp si, bx
    jne @@shiftEntriesDown
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
EditName:
    mov bp, offset HiscoreNamePrefix
    call PrintMessageBP
    mov bp, offset HiscoreNameBuffer
    call PrintMessageBP
    call ReadKeyThroughDos
    cmp al, 8
    je HiscoreNameBackspace
    cmp al, 0Dh
    je HiscoreNamePadBlanks
    cmp word ptr ds:[HiscoreNameCursor], offset HiscoreNameBuffer + 0Ah
    je BeepAndEdit
    cmp al, 020h
    jb EditName
    cmp al, 07Ah
    ja EditName
    mov di, word ptr ds:[HiscoreNameCursor]
    mov byte ptr ds:[di], al
    inc word ptr ds:[HiscoreNameCursor]
    jmp short EditName
BeepAndEdit:
    call BiosBeep
    jmp short EditName

BiosBeep:
    mov al, 7
    mov ah, 0Eh
    int 010h
    ret
HiscoreNameBackspace:
    cmp word ptr ds:[HiscoreNameCursor], offset HiscoreNameBuffer
    je BeepAndEdit
    dec word ptr ds:[HiscoreNameCursor]
    mov di, word ptr ds:[HiscoreNameCursor]
    mov al, 020h
    mov byte ptr ds:[di], al
    jmp short EditName
HiscoreNamePadBlanks:
    cmp word ptr ds:[HiscoreNameCursor], offset HiscoreNameBuffer + 0Ah
    je @@hiscoreNameStore
    mov di, word ptr ds:[HiscoreNameCursor]
    mov byte ptr ds:[di], 020h
    inc word ptr ds:[HiscoreNameCursor]
    jmp short HiscoreNamePadBlanks
@@hiscoreNameStore:
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
@@nextRow:
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
    loop @@nextRow
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
    je @@readExtendedCode
    jmp short @@storeKey
@@readExtendedCode:
    int 021h
    mov word ptr ds:[LastKeyExtended], 1
@@storeKey:
    mov byte ptr ds:[QuitAnswer], al
    push ax
    call InstallKeyboardVector09
    pop ax
    ret

SetHiscoreRankColor:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je @@cgaColor
    mov byte ptr ds:[HiscoreRankPrefix + 4], 0Ah
    ret
@@cgaColor:
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
@@redrawMenu:
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne @@redrawPage
    call far ptr WaitAllKeysReleased
    mov ax, offset OkMenuPageList
    call far ptr ShowPageList
    call DrawOptionsSelections
@@redrawPage:
    cmp word ptr ds:[MenuShowingHiscores], 0
    je @@drawSelections
    call ShowHighScoreTable
    jmp short @@resetIdle
@@drawSelections:
    call DrawOptionsSelections
@@resetIdle:
    mov word ptr ds:[MenuIdleFrames], 0
@@pollKeys:
    cmp byte ptr ds:[KeyDownTable + SCAN_K], KEY_STATE_DOWN
    jne @@checkJ
    jmp near ptr @@keyK
@@checkJ:
    cmp byte ptr ds:[KeyDownTable + SCAN_J], KEY_STATE_DOWN
    jne @@checkA
    jmp near ptr @@keyJ
@@checkA:
    cmp byte ptr ds:[KeyDownTable + SCAN_A], KEY_STATE_DOWN
    jne @@checkR
    jmp near ptr @@keyA
@@checkR:
    cmp byte ptr ds:[KeyDownTable + SCAN_R], KEY_STATE_DOWN
    jne @@checkM
    jmp near ptr @@keyR
@@checkM:
    cmp byte ptr ds:[KeyDownTable + SCAN_M], KEY_STATE_DOWN
    jne @@checkOtherKeys
    jmp near ptr @@keyM
@@checkOtherKeys:
    cmp byte ptr ds:[KeyDownTable + SCAN_O], KEY_STATE_DOWN
    je @@showOPages
    cmp byte ptr ds:[KeyDownTable + SCAN_I], KEY_STATE_DOWN
    je @@showIPages
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne @@checkF9
    jmp near ptr ShutdownGame
@@checkF9:
    cmp byte ptr ds:[KeyDownTable + SCAN_F9], KEY_STATE_DOWN
    je @@bossKey
    mov word ptr ds:[MenuKeyLatchK], 0
    mov word ptr ds:[MenuKeyLatchA], 0
    mov word ptr ds:[MenuKeyLatchM], 0
@@idleFrame:
    call WaitVerticalRetrace
    inc word ptr ds:[MenuIdleFrames]
    cmp word ptr ds:[MenuIdleFrames], 02EEh
    jb @@checkFire
    cmp word ptr ds:[MenuShowingHiscores], 0
    je @@showHiscores
    call RunAttractSequence
    jmp near ptr RunOptionsMenu
@@showHiscores:
    mov word ptr ds:[MenuShowingHiscores], 1
    jmp near ptr @@redrawMenu
@@checkFire:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@done
    jmp near ptr @@pollKeys
@@done:
    ret
@@showOPages:
    mov ax, offset OPageList
    call far ptr ShowPageList
    jmp near ptr RunOptionsMenu
@@showIPages:
    mov ax, offset IPageList
    call far ptr ShowPageList
    jmp near ptr RunOptionsMenu
@@bossKey:
    call ShowBossKeyScreen
    jmp near ptr RunOptionsMenu
@@keyK:
    cmp word ptr ds:[MenuKeyLatchK], 1
    je @@idleFrame
    mov word ptr ds:[MenuKeyLatchK], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je @@selectKeysA
    mov byte ptr ds:[SfxRequest], 01Ch
@@selectKeysA:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne @@kRestart
    jmp near ptr @@redrawPage
@@kRestart:
    jmp near ptr RunOptionsMenu
@@keyJ:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@waitJRelease
    mov byte ptr ds:[SfxRequest], 01Ch
@@waitJRelease:
    cmp byte ptr ds:[KeyDownTable + SCAN_J], KEY_STATE_DOWN
    je @@waitJRelease
    call StopModuleMusic
    call CalibrateJoystickWithAbort
    mov al, byte ptr ds:[ModuleSoundRequest]
    call RequestModuleMusic
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne @@waitFireRelease
    cmp byte ptr ds:[SfxEnabled], 0
    je @@waitEscRelease
    mov byte ptr ds:[SfxRequest], 01Ch
@@waitEscRelease:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je @@waitEscRelease
    jmp near ptr RunOptionsMenu
@@waitFireRelease:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@waitFireRelease
    jmp near ptr RunOptionsMenu
@@keyA:
    cmp word ptr ds:[MenuKeyLatchA], 1
    jne @@latchA
    jmp near ptr @@idleFrame
@@latchA:
    mov word ptr ds:[MenuKeyLatchA], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je @@selectKeysB
    mov byte ptr ds:[SfxRequest], 01Ch
@@selectKeysB:
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne @@aRestart
    jmp near ptr @@redrawPage
@@aRestart:
    jmp near ptr RunOptionsMenu
@@keyM:
    cmp word ptr ds:[MenuKeyLatchM], 1
    jne @@cycleSound
    jmp near ptr @@idleFrame
@@cycleSound:
    mov word ptr ds:[MenuKeyLatchM], 1
    inc word ptr ds:[SoundOption]
    and word ptr ds:[SoundOption], 3
    mov bx, word ptr ds:[SoundOption]
    shl bx, 1
    mov bx, word ptr ds:[bx + SoundOptionFlags]
    mov byte ptr ds:[SfxEnabled], bh
    mov byte ptr ds:[ModuleSoundEnabled], bl
    cmp bl, 0
    jne @@restartMusic
    call StopModuleMusic
@@restartMusic:
    mov al, MUSIC_TITLE
    call RequestModuleMusic
    cmp byte ptr ds:[SfxEnabled], 0
    je @@mRedraw
    mov byte ptr ds:[SfxRequest], 01Ch
@@mRedraw:
    cmp word ptr ds:[MenuShowingHiscores], 0
    jne @@mRestart
    jmp near ptr @@redrawPage
@@mRestart:
    jmp near ptr RunOptionsMenu
@@keyR:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@waitRRelease
    mov byte ptr ds:[SfxRequest], 01Ch
@@waitRRelease:
    cmp byte ptr ds:[KeyDownTable + SCAN_R], KEY_STATE_DOWN
    je @@waitRRelease
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
@@waitKey:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je @@waitKey
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_F9
    je @@waitKey
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_F10
    je @@waitKey
    cmp byte ptr ds:[KeyLastMakeCode], SCAN_ESC
    je @@waitKey
    cmp byte ptr ds:[SfxEnabled], 0
    je @@storeScancode
    mov byte ptr ds:[SfxRequest], 01Ch
@@storeScancode:
    mov bl, byte ptr ds:[KeyLastMakeCode]
    xor bh, bh
    pop di
    mov byte ptr ds:[di], bl
    add bx, offset KeyDownTable
@@waitRelease:
    cmp byte ptr ds:[bx], 0
    jne @@waitRelease
    ret

CollapseScreenWithSfx:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@requestSfx
@@waitSfxIdle:
    cmp byte ptr ds:[SfxActive], 0
    jne @@waitSfxIdle
@@requestSfx:
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
CaptureRow:
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
    je @@cgaRowDone
    add si, 0C050h
@@cgaRowDone:
    jmp short CaptureRowDone

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
    jmp short CaptureRowDone

CaptureScreenRowTandy:
    mov cx, 050h
    rep movsw
    sub si, 0A0h
    add si, 02000h
    test si, 08000h
    je CaptureRowDone
    add si, 080A0h
CaptureRowDone:
    pop cx
    loop CaptureRow
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@startCollapse
    mov ax, 4
    out dx, ax
@@startCollapse:
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
@@collapseFrame:
    push cx
    mov word ptr cs:[StretchShownRows], cx
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop @@collapseFrame
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
; Uncalled variant of the stretch drawers: squash and stretch until a key or the
; primary button (SquashAndStretchUntilInput).
StretchUntilInputUnused:
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
@@stretchCycle:
    push cx
    call SquashAndStretchUntilInput
    jne @@stopped
    call SquashAndStretchUntilInput
    jne @@stopped
    pop cx
    loop @@stretchCycle
    mov ds, cs:[MainDataSegment]
    ret
@@stopped:
    pop cx
    mov ds, cs:[MainDataSegment]
    ret
; Per VideoAdapter: CGA, EGA and Tandy versions of the same draw routine.
AdapterDrawHandlers label word
    dw offset DrawStretchedImageCga, offset DrawStretchedImageEga, offset DrawStretchedImageTandy
; Step of the unused StretchUntilInputUnused; AX = 1 (NZ) when a key or the primary button stops it.
SquashAndStretchUntilInput:
    mov cx, cs:[StretchImageRows]
    sub cx, 2
@@squashFrame:
    push cx
    mov cs:[StretchShownRows], cx
    mov bx, cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    push ds
    mov ds, cs:[MainDataSegment]
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne @@inputSeen
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@inputSeen
    pop ds
    call WaitVerticalRetrace
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop @@squashFrame
    xor word ptr cs:[StretchFlagA], 1
    xor word ptr cs:[StretchFlagB], 1
    mov cx, cs:[StretchImageRows]
    sub cx, 2
    add word ptr cs:[StretchShownRows], 2
@@stretchFrame:
    push cx
    add word ptr cs:[StretchShownRows], 2
    mov bx, cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    push ds
    mov ds, cs:[MainDataSegment]
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@inputSeen
    pop ds
    call WaitVerticalRetrace
    call WaitVerticalRetrace
    pop cx
    dec cx
    loop @@stretchFrame
    xor ax, ax
    ret
@@inputSeen:
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
@@growFrame:
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + AdapterDrawHandlers]
    call WaitVerticalRetrace
    add word ptr cs:[StretchShownRows], 2
    mov ax, word ptr cs:[StretchShownRows]
    cmp ax, word ptr cs:[StretchImageRows]
    jne @@growFrame
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Clears the screen and stretches in the HUD frame (panel image 25h); falls through into
; CopyEgaPage0ToPage1.
StretchInHudPanel:
    call ResetPageAndClearScreen
    mov ax, 01Bh
    call DrawOffsetFromScreenRow
    mov si, PANEL_HUD_FRAME
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call StretchInImage

; EGA only: latch copy (write mode 1) of page 0 to page 2000h so both pages match.
CopyEgaPage0ToPage1:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je @@copyEga
    ret
@@copyEga:
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
    jb @@toAscii
    add dl, 7
@@toAscii:
    add dl, 30h
    mov al, dl
    mov ah, 0Eh
    int 10h
    ret
ShutdownWithError:
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
    je @@normalExit
    mov dx, offset FileNotFoundMsgHead
    mov ah, DOS_PRINT_STRING
    int 021h
    mov si, word ptr ds:[FileNamePtr]
@@findNameEnd:
    lodsb
    or al, al
    jne @@findNameEnd
    mov byte ptr ds:[si - 1], 024h
    mov dx, word ptr ds:[FileNamePtr]
    mov si, dx
    cmp byte ptr ds:[si + 1], 03Ah
    jne @@printName
    add dx, 2
@@printName:
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, offset FileNotFoundMsgTail
    mov ah, DOS_PRINT_STRING
    int 021h
    call ReleaseEmsCache
    call far ptr RestoreAllocStrategy
    mov ax, 04C00h
    int 021h
@@normalExit:
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
    jb @@xBelowTarget
    ja @@xAboveTarget
    jmp short @@compareY
@@xBelowTarget:
    mov word ptr ds:[AimQuadrantBits], 1
    jmp short @@compareY
@@xAboveTarget:
    mov word ptr ds:[AimQuadrantBits], 2
@@compareY:
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ds:[SteerTargetY]
    jl @@yBelowTarget
    jg @@yAboveTarget
    jmp short @@lookupDirection
@@yBelowTarget:
    or word ptr ds:[AimQuadrantBits], 4
    jmp short @@lookupDirection
@@yAboveTarget:
    or word ptr ds:[AimQuadrantBits], 8
@@lookupDirection:
    mov bx, offset DirectionFromQuadrant
    mov ax, word ptr ds:[AimQuadrantBits]
    xlat
    cmp al, 0FFh
    je @@arrived
    mov word ptr ss:[bp + REC_DIRECTION], ax
    mov bx, word ptr ds:[SteerSpeed]
    shl bx, 1
    jmp word ptr cs:[bx + StepBySteerSpeed]
; NOP filler (word alignment).
    db 90h
StepBySteerSpeed label word
    dw offset MoveInDirection1, offset MoveInDirection2, offset MoveInDirection4, offset MoveInDirection8
@@arrived:
    mov word ptr ds:[SteerArrived], 1
    ret
; BX = target record: sets BP's REC_DELTA toward it.
SetDeltaToward:
    mov dx, 4
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je @@computeDelta
    mov dx, 0Ch
@@computeDelta:
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
    jns @@absY
    neg ax
    inc word ptr ds:[ChaseNegX]
@@absY:
    mov bx, word ptr ss:[bp + REC_DELTA_Y]
    or bx, bx
    jns @@compareAxes
    neg bx
    inc word ptr ds:[ChaseNegY]
@@compareAxes:
    cmp ax, bx
    je @@stepXY
    ja @@xMajor
    add word ptr ss:[bp + REC_STEP_ERROR], ax
    cmp word ptr ss:[bp + REC_STEP_ERROR], bx
    jbe @@stepY
    sub word ptr ss:[bp + REC_STEP_ERROR], bx
    jmp short @@stepXY
@@xMajor:
    add word ptr ss:[bp + REC_STEP_ERROR], bx
    cmp word ptr ss:[bp + REC_STEP_ERROR], ax
    jbe @@stepXOnly
    sub word ptr ss:[bp + REC_STEP_ERROR], ax
    jmp short @@stepXY
@@stepXOnly:
    call SetChaseXQuadrantBit
    jmp short @@lookupDirection
@@stepXY:
    call SetChaseXQuadrantBit
@@stepY:
    call SetChaseYQuadrantBit
@@lookupDirection:
    mov bx, offset DirectionFromQuadrant
    mov ax, word ptr ds:[ChaseQuadrantBits]
    xlat
    cmp al, 0FFh
    jne @@move
    ret
@@move:
    mov word ptr ss:[bp + REC_DIRECTION], ax
    cmp word ptr ds:[ChaseStepPixels], 3
    jne @@moveTwo
    jmp near ptr MoveInDirection3
@@moveTwo:
    jmp near ptr MoveInDirection2
; StepAlongDelta helper: ChaseQuadrantBits bit 1 if ChaseNegX = 1, else bit 2.
SetChaseXQuadrantBit:
    cmp word ptr ds:[ChaseNegX], 1
    je @@negX
    or word ptr ds:[ChaseQuadrantBits], 2
    ret
@@negX:
    or word ptr ds:[ChaseQuadrantBits], 1
    ret
; StepAlongDelta helper: ChaseQuadrantBits bit 4 if ChaseNegY = 1, else bit 8.
SetChaseYQuadrantBit:
    cmp word ptr ds:[ChaseNegY], 1
    je @@negY
    or word ptr ds:[ChaseQuadrantBits], 8
    ret
@@negY:
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

; Music for the start of a life: MUSIC_LEVEL_START at MAP_START_POS, MUSIC_LEVEL_END
; at MAP_END_POS, else LevelMusicTable[LevelIndex].
RequestLifeStartMusic:
    mov al, MUSIC_LEVEL_START
    cmp word ptr ds:[MapScrollPos], MAP_START_POS
    je @@requestMusic
    mov al, MUSIC_LEVEL_END
    cmp word ptr ds:[MapScrollPos], MAP_END_POS
    je @@requestMusic
    mov bx, offset LevelMusicTable
    mov al, byte ptr ds:[LevelIndex]
    xlat
@@requestMusic:
    jmp near ptr RequestModuleMusic


; Per frame: restores the level music once an encounter has ended, updates the sway and
; frame counters, then TickFuelDrain.
TickFrameTimers:
    cmp word ptr ds:[EncounterLiveCount], 0
    jne @@sway
    cmp word ptr ds:[EncounterEndDelay], 0
    je @@sway
    dec word ptr ds:[EncounterEndDelay]
    jne @@sway
    mov bx, offset LevelMusicTable
    mov al, byte ptr ds:[LevelIndex]
    xlat
    cmp word ptr ds:[MapScrollPos], MAP_MUSIC_CHANGE_POS
    jb @@requestMusic
    mov al, MUSIC_LATE_LEVEL
@@requestMusic:
    call RequestModuleMusic
@@sway:
    cmp word ptr ds:[FrameCount8], 7
    jne @@checkReversals
    cmp word ptr ds:[SwayDirX], -1
    je @@swayBack
    inc word ptr ds:[SwayPhase]
    cmp word ptr ds:[SwayPhase], 2
    jne @@checkReversals
    neg word ptr ds:[SwayDirX]
    inc word ptr ds:[SwayReversals]
    jmp short @@checkReversals
@@swayBack:
    dec word ptr ds:[SwayPhase]
    jne @@checkReversals
    neg word ptr ds:[SwayDirX]
    inc word ptr ds:[SwayReversals]
@@checkReversals:
    and word ptr ds:[SwayReversals], 0Fh
    jne @@slowCounters
    mov word ptr ds:[SwayDropY], 8
    inc word ptr ds:[SwayReversals]
@@slowCounters:
    inc word ptr ds:[FrameDivider4]
    and word ptr ds:[FrameDivider4], 3
    jne @@frameCounters
    inc word ptr ds:[SlowCount10]
    cmp word ptr ds:[SlowCount10], 0Ah
    jb @@count6
    mov word ptr ds:[SlowCount10], 0
@@count6:
    inc word ptr ds:[SlowCount6]
    cmp word ptr ds:[SlowCount6], 6
    jb @@count5
    mov word ptr ds:[SlowCount6], 0
@@count5:
    inc word ptr ds:[SlowCount5]

    cmp word ptr ds:[SlowCount5], 5
    jb @@count3
    mov word ptr ds:[SlowCount5], 0
@@count3:
    inc word ptr ds:[SlowCount3]
    cmp word ptr ds:[SlowCount3], 3
    jb @@count4And8
    mov word ptr ds:[SlowCount3], 0
@@count4And8:
    inc word ptr ds:[SlowCount4]
    and word ptr ds:[SlowCount4], 3
    inc word ptr ds:[SlowCount8]
    and word ptr ds:[SlowCount8], 7
    inc word ptr ds:[EncounterTicks]
@@frameCounters:
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
    jbe @@slowDrain
    cmp word ptr ds:[FrameCount64], 03Fh
    jmp short @@testDrainTick
@@slowDrain:
    cmp word ptr ds:[FrameCount128], 07Fh
@@testDrainTick:
    jne @@checkShipForm
    call DrainFuelUnit
@@checkShipForm:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 2
    je @@checkFrame32
    ret
@@checkFrame32:
    cmp word ptr ds:[FrameCount32], 01Fh
    je @@toggleExtraDrain
    ret
@@toggleExtraDrain:
    xor word ptr ds:[ThrustDrainToggle], 1
    je @@drainExtra
    ret
@@drainExtra:
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
@@scrollBlock:
    mov cx, 010h
@@scrollLine:
    push cx
    call ScrollBackwardOneLine
    pop cx
    loop @@scrollLine
    cmp word ptr ds:[MapScrollPos], MAP_START_POS
    jne @@scrollBlock
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
    mov si, PANEL_SHIP_ICON
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov cx, word ptr ds:[LivesLeft]
    call DrawPanelImageRow
    mov si, PANEL_NO_SHIP_ICON
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov cx, 3
    sub cx, word ptr ds:[LivesLeft]

; SI = image in PanelSegment, CX = copies (0 allowed), DI = screen offset; each copy
; advances DI two 8-pixel columns. Returns DS = MainDataSegment.
DrawPanelImageRow:
    jcxz @@done
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
@@done:
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
    jne @@lives
    call FlipEgaDrawPage
    call DrawScore
    call FlipEgaDrawPage
@@lives:
    call DrawLivesIcons
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@energy
    call FlipEgaDrawPage
    call DrawLivesIcons
    call FlipEgaDrawPage
@@energy:
    call DrawEnergyGauge
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@levelNumber
    call FlipEgaDrawPage
    call DrawEnergyGauge
    call FlipEgaDrawPage
@@levelNumber:
    call DrawLevelNumber
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@done
    call FlipEgaDrawPage
    call DrawLevelNumber
    call FlipEgaDrawPage
@@done:
    ret

DecrementFirstEnergyCell:
    mov di, offset EnergyCells
@@checkCell:
    cmp word ptr ds:[di], 0
    je @@nextCell
    dec word ptr ds:[di]
    ret
@@nextCell:
    add di, 2
    cmp di, offset EnergyCellsEnd
    jne @@checkCell
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
    jcxz @@drawCells
    or cx, cx
    js @@drawCells
@@drainCell:
    call DecrementFirstEnergyCell
    loop @@drainCell
@@drawCells:
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
    je @@done
    mov al, 01Fh
    mov ah, 0Ch
    call DrawOffsetFromScreenRow
    mov si, 0
    cmp word ptr ds:[EnergyTanks], -1
    je @@drawTank
    mov si, word ptr ds:[EnergyTanks]
@@drawTank:
    add si, PANEL_TANK_GAUGE
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov al, 021h
    mov ah, 018h
    call DrawOffsetFromScreenRow
    mov si, PANEL_SHIP_ICON
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
@@done:
    pop bp
    ret

; SI = cell value 0..4: draws panel image 19h + SI at DI and advances DI one column.
DrawEnergyCell:
    add si, PANEL_ENERGY_CELL
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
    je @@scanPool
    mov byte ptr ds:[SfxRequest], 8
@@scanPool:
    push bp
    mov cx, POOL_A_COUNT
@@nextRecord:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@skipRecord
    call SmartBombRecord
@@skipRecord:
    pop cx
    loop @@nextRecord
    pop bp
    ret

SmartBombRecord:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe @@checkKind
    ret
@@checkKind:
    cmp word ptr ss:[bp + REC_KIND], KIND_ENEMY
    je @@checkType0
    ret
@@checkType0:
    cmp word ptr ss:[bp + REC_TYPE], 0
    jne @@checkType1
    ret
@@checkType1:
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne @@destroy
    ret
@@destroy:
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp near ptr DestroyRecord
; BP = record: tests every live player shot in pool B (unrolled over all 34 records)
; against BP's 8-pixel cells (two columns and rows, four for size class 2) and hands
; the first hit to ShotHitsRecord.
PlayerShotsHitRecord:
    cmp word ptr ss:[bp + REC_STATUS], 0
    jne @@checkY
    jmp near ptr PlayerShotsMissed
@@checkY:
    cmp word ptr ss:[bp + REC_Y], 020h
    jge @@checkKind
    jmp near ptr PlayerShotsMissed
@@checkKind:
    cmp word ptr ss:[bp + REC_KIND], KIND_SCENERY
    jne @@checkType0
    jmp near ptr PlayerShotsMissed
@@checkType0:
    cmp word ptr ss:[bp + REC_TYPE], 0
    jne @@checkType1
    jmp near ptr PlayerShotsMissed
@@checkType1:
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne @@checkRemnant
    jmp near ptr PlayerShotsMissed
@@checkRemnant:
    cmp word ptr ss:[bp + REC_TYPE], 026h
    jne @@testShots
    jmp near ptr PlayerShotsMissed
@@testShots:
    mov si, word ptr ss:[bp + REC_KIND]
    mov di, word ptr ss:[bp + REC_DRAW_PASS]
    mov dx, word ptr ss:[bp + REC_X]
    and dx, 0FFF8h
    mov cx, word ptr ss:[bp + REC_Y]
    and cx, 0FFF8h
    mov bx, offset PoolB
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot1
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot1
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot0CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot0CheckY
    sub ax, 8
@@shot0CheckX:
    cmp ax, dx
    je @@shot0CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot0CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot1
    sub ax, 8
    cmp ax, dx
    je @@shot0CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot1
@@shot0CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot0Row1
    jmp near ptr ShotHitsRecord
@@shot0Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot0TallRows
    jmp near ptr ShotHitsRecord
@@shot0TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot1
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot1
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot1
    sub ax, 8
    cmp ax, cx
    jne @@shot0Row3
    jmp near ptr ShotHitsRecord
@@shot0Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot1
    jmp near ptr ShotHitsRecord
@@shot1:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot2
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot2
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot1CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot1CheckY
    sub ax, 8
@@shot1CheckX:
    cmp ax, dx
    je @@shot1CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot1CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot2
    sub ax, 8
    cmp ax, dx
    je @@shot1CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot2
@@shot1CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot1Row1
    jmp near ptr ShotHitsRecord
@@shot1Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot1TallRows
    jmp near ptr ShotHitsRecord
@@shot1TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot2
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot2
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot2
    sub ax, 8
    cmp ax, cx
    jne @@shot1Row3
    jmp near ptr ShotHitsRecord
@@shot1Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot2
    jmp near ptr ShotHitsRecord
@@shot2:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot3
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot3
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot2CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot2CheckY
    sub ax, 8
@@shot2CheckX:
    cmp ax, dx
    je @@shot2CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot2CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot3
    sub ax, 8
    cmp ax, dx
    je @@shot2CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot3
@@shot2CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot2Row1
    jmp near ptr ShotHitsRecord
@@shot2Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot2TallRows
    jmp near ptr ShotHitsRecord
@@shot2TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot3
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot3
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot3
    sub ax, 8
    cmp ax, cx
    jne @@shot2Row3
    jmp near ptr ShotHitsRecord
@@shot2Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot3
    jmp near ptr ShotHitsRecord
@@shot3:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot4
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot4
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot3CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot3CheckY
    sub ax, 8
@@shot3CheckX:
    cmp ax, dx
    je @@shot3CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot3CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot4
    sub ax, 8
    cmp ax, dx
    je @@shot3CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot4
@@shot3CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot3Row1
    jmp near ptr ShotHitsRecord
@@shot3Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot3TallRows
    jmp near ptr ShotHitsRecord
@@shot3TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot4
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot4
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot4
    sub ax, 8
    cmp ax, cx
    jne @@shot3Row3
    jmp near ptr ShotHitsRecord
@@shot3Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot4
    jmp near ptr ShotHitsRecord
@@shot4:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot5
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot5
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot4CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot4CheckY
    sub ax, 8
@@shot4CheckX:
    cmp ax, dx
    je @@shot4CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot4CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot5
    sub ax, 8
    cmp ax, dx
    je @@shot4CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot5
@@shot4CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot4Row1
    jmp near ptr ShotHitsRecord
@@shot4Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot4TallRows
    jmp near ptr ShotHitsRecord
@@shot4TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot5
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot5
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot5
    sub ax, 8
    cmp ax, cx
    jne @@shot4Row3
    jmp near ptr ShotHitsRecord
@@shot4Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot5
    jmp near ptr ShotHitsRecord
@@shot5:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot6
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot6
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot5CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot5CheckY
    sub ax, 8
@@shot5CheckX:
    cmp ax, dx
    je @@shot5CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot5CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot6
    sub ax, 8
    cmp ax, dx
    je @@shot5CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot6
@@shot5CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot5Row1
    jmp near ptr ShotHitsRecord
@@shot5Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot5TallRows
    jmp near ptr ShotHitsRecord
@@shot5TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot6
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot6
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot6
    sub ax, 8
    cmp ax, cx
    jne @@shot5Row3
    jmp near ptr ShotHitsRecord
@@shot5Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot6
    jmp near ptr ShotHitsRecord
@@shot6:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot7
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot7
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot6CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot6CheckY
    sub ax, 8
@@shot6CheckX:
    cmp ax, dx
    je @@shot6CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot6CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot7
    sub ax, 8
    cmp ax, dx
    je @@shot6CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot7
@@shot6CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot6Row1
    jmp near ptr ShotHitsRecord
@@shot6Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot6TallRows
    jmp near ptr ShotHitsRecord
@@shot6TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot7
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot7
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot7
    sub ax, 8
    cmp ax, cx
    jne @@shot6Row3
    jmp near ptr ShotHitsRecord
@@shot6Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot7
    jmp near ptr ShotHitsRecord
@@shot7:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot8
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot8
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot7CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot7CheckY
    sub ax, 8
@@shot7CheckX:
    cmp ax, dx
    je @@shot7CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot7CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot8
    sub ax, 8
    cmp ax, dx
    je @@shot7CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot8
@@shot7CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot7Row1
    jmp near ptr ShotHitsRecord
@@shot7Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot7TallRows
    jmp near ptr ShotHitsRecord
@@shot7TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot8
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot8
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot8
    sub ax, 8
    cmp ax, cx
    jne @@shot7Row3
    jmp near ptr ShotHitsRecord
@@shot7Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot8
    jmp near ptr ShotHitsRecord
@@shot8:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot9
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot9
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot8CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot8CheckY
    sub ax, 8
@@shot8CheckX:
    cmp ax, dx
    je @@shot8CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot8CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot9
    sub ax, 8
    cmp ax, dx
    je @@shot8CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot9
@@shot8CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot8Row1
    jmp near ptr ShotHitsRecord
@@shot8Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot8TallRows
    jmp near ptr ShotHitsRecord
@@shot8TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot9
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot9
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot9
    sub ax, 8
    cmp ax, cx
    jne @@shot8Row3
    jmp near ptr ShotHitsRecord
@@shot8Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot9
    jmp near ptr ShotHitsRecord
@@shot9:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot10
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot10
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot9CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot9CheckY
    sub ax, 8
@@shot9CheckX:
    cmp ax, dx
    je @@shot9CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot9CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot10
    sub ax, 8
    cmp ax, dx
    je @@shot9CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot10
@@shot9CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot9Row1
    jmp near ptr ShotHitsRecord
@@shot9Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot9TallRows
    jmp near ptr ShotHitsRecord
@@shot9TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot10
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot10
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot10
    sub ax, 8
    cmp ax, cx
    jne @@shot9Row3
    jmp near ptr ShotHitsRecord
@@shot9Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot10
    jmp near ptr ShotHitsRecord
@@shot10:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot11
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot11
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot10CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot10CheckY
    sub ax, 8
@@shot10CheckX:
    cmp ax, dx
    je @@shot10CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot10CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot11
    sub ax, 8
    cmp ax, dx
    je @@shot10CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot11
@@shot10CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot10Row1
    jmp near ptr ShotHitsRecord
@@shot10Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot10TallRows
    jmp near ptr ShotHitsRecord
@@shot10TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot11
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot11
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot11
    sub ax, 8
    cmp ax, cx
    jne @@shot10Row3
    jmp near ptr ShotHitsRecord
@@shot10Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot11
    jmp near ptr ShotHitsRecord
@@shot11:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot12
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot12
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot11CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot11CheckY
    sub ax, 8
@@shot11CheckX:
    cmp ax, dx
    je @@shot11CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot11CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot12
    sub ax, 8
    cmp ax, dx
    je @@shot11CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot12
@@shot11CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot11Row1
    jmp near ptr ShotHitsRecord
@@shot11Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot11TallRows
    jmp near ptr ShotHitsRecord
@@shot11TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot12
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot12
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot12
    sub ax, 8
    cmp ax, cx
    jne @@shot11Row3
    jmp near ptr ShotHitsRecord
@@shot11Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot12
    jmp near ptr ShotHitsRecord
@@shot12:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot13
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot13
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot12CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot12CheckY
    sub ax, 8
@@shot12CheckX:
    cmp ax, dx
    je @@shot12CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot12CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot13
    sub ax, 8
    cmp ax, dx
    je @@shot12CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot13
@@shot12CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot12Row1
    jmp near ptr ShotHitsRecord
@@shot12Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot12TallRows
    jmp near ptr ShotHitsRecord
@@shot12TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot13
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot13
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot13
    sub ax, 8
    cmp ax, cx
    jne @@shot12Row3
    jmp near ptr ShotHitsRecord
@@shot12Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot13
    jmp near ptr ShotHitsRecord
@@shot13:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot14
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot14
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot13CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot13CheckY
    sub ax, 8
@@shot13CheckX:
    cmp ax, dx
    je @@shot13CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot13CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot14
    sub ax, 8
    cmp ax, dx
    je @@shot13CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot14
@@shot13CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot13Row1
    jmp near ptr ShotHitsRecord
@@shot13Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot13TallRows
    jmp near ptr ShotHitsRecord
@@shot13TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot14
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot14
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot14
    sub ax, 8
    cmp ax, cx
    jne @@shot13Row3
    jmp near ptr ShotHitsRecord
@@shot13Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot14
    jmp near ptr ShotHitsRecord
@@shot14:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot15
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot15
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot14CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot14CheckY
    sub ax, 8
@@shot14CheckX:
    cmp ax, dx
    je @@shot14CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot14CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot15
    sub ax, 8
    cmp ax, dx
    je @@shot14CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot15
@@shot14CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot14Row1
    jmp near ptr ShotHitsRecord
@@shot14Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot14TallRows
    jmp near ptr ShotHitsRecord
@@shot14TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot15
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot15
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot15
    sub ax, 8
    cmp ax, cx
    jne @@shot14Row3
    jmp near ptr ShotHitsRecord
@@shot14Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot15
    jmp near ptr ShotHitsRecord
@@shot15:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot16
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot16
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot15CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot15CheckY
    sub ax, 8
@@shot15CheckX:
    cmp ax, dx
    je @@shot15CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot15CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot16
    sub ax, 8
    cmp ax, dx
    je @@shot15CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot16
@@shot15CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot15Row1
    jmp near ptr ShotHitsRecord
@@shot15Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot15TallRows
    jmp near ptr ShotHitsRecord
@@shot15TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot16
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot16
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot16
    sub ax, 8
    cmp ax, cx
    jne @@shot15Row3
    jmp near ptr ShotHitsRecord
@@shot15Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot16
    jmp near ptr ShotHitsRecord
@@shot16:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot17
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot17
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot16CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot16CheckY
    sub ax, 8
@@shot16CheckX:
    cmp ax, dx
    je @@shot16CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot16CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot17
    sub ax, 8
    cmp ax, dx
    je @@shot16CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot17
@@shot16CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot16Row1
    jmp near ptr ShotHitsRecord
@@shot16Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot16TallRows
    jmp near ptr ShotHitsRecord
@@shot16TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot17
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot17
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot17
    sub ax, 8
    cmp ax, cx
    jne @@shot16Row3
    jmp near ptr ShotHitsRecord
@@shot16Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot17
    jmp near ptr ShotHitsRecord
@@shot17:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot18
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot18
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot17CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot17CheckY
    sub ax, 8
@@shot17CheckX:
    cmp ax, dx
    je @@shot17CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot17CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot18
    sub ax, 8
    cmp ax, dx
    je @@shot17CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot18
@@shot17CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot17Row1
    jmp near ptr ShotHitsRecord
@@shot17Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot17TallRows
    jmp near ptr ShotHitsRecord
@@shot17TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot18
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot18
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot18
    sub ax, 8
    cmp ax, cx
    jne @@shot17Row3
    jmp near ptr ShotHitsRecord
@@shot17Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot18
    jmp near ptr ShotHitsRecord
@@shot18:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot19
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot19
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot18CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot18CheckY
    sub ax, 8
@@shot18CheckX:
    cmp ax, dx
    je @@shot18CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot18CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot19
    sub ax, 8
    cmp ax, dx
    je @@shot18CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot19
@@shot18CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot18Row1
    jmp near ptr ShotHitsRecord
@@shot18Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot18TallRows
    jmp near ptr ShotHitsRecord
@@shot18TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot19
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot19
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot19
    sub ax, 8
    cmp ax, cx
    jne @@shot18Row3
    jmp near ptr ShotHitsRecord
@@shot18Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot19
    jmp near ptr ShotHitsRecord
@@shot19:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot20
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot20
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot19CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot19CheckY
    sub ax, 8
@@shot19CheckX:
    cmp ax, dx
    je @@shot19CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot19CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot20
    sub ax, 8
    cmp ax, dx
    je @@shot19CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot20
@@shot19CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot19Row1
    jmp near ptr ShotHitsRecord
@@shot19Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot19TallRows
    jmp near ptr ShotHitsRecord
@@shot19TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot20
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot20
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot20
    sub ax, 8
    cmp ax, cx
    jne @@shot19Row3
    jmp near ptr ShotHitsRecord
@@shot19Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot20
    jmp near ptr ShotHitsRecord
@@shot20:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot21
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot21
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot20CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot20CheckY
    sub ax, 8
@@shot20CheckX:
    cmp ax, dx
    je @@shot20CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot20CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot21
    sub ax, 8
    cmp ax, dx
    je @@shot20CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot21
@@shot20CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot20Row1
    jmp near ptr ShotHitsRecord
@@shot20Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot20TallRows
    jmp near ptr ShotHitsRecord
@@shot20TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot21
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot21
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot21
    sub ax, 8
    cmp ax, cx
    jne @@shot20Row3
    jmp near ptr ShotHitsRecord
@@shot20Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot21
    jmp near ptr ShotHitsRecord
@@shot21:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot22
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot22
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot21CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot21CheckY
    sub ax, 8
@@shot21CheckX:
    cmp ax, dx
    je @@shot21CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot21CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot22
    sub ax, 8
    cmp ax, dx
    je @@shot21CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot22
@@shot21CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot21Row1
    jmp near ptr ShotHitsRecord
@@shot21Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot21TallRows
    jmp near ptr ShotHitsRecord
@@shot21TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot22
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot22
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot22
    sub ax, 8
    cmp ax, cx
    jne @@shot21Row3
    jmp near ptr ShotHitsRecord
@@shot21Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot22
    jmp near ptr ShotHitsRecord
@@shot22:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot23
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot23
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot22CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot22CheckY
    sub ax, 8
@@shot22CheckX:
    cmp ax, dx
    je @@shot22CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot22CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot23
    sub ax, 8
    cmp ax, dx
    je @@shot22CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot23
@@shot22CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot22Row1
    jmp near ptr ShotHitsRecord
@@shot22Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot22TallRows
    jmp near ptr ShotHitsRecord
@@shot22TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot23
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot23
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot23
    sub ax, 8
    cmp ax, cx
    jne @@shot22Row3
    jmp near ptr ShotHitsRecord
@@shot22Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot23
    jmp near ptr ShotHitsRecord
@@shot23:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot24
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot24
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot23CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot23CheckY
    sub ax, 8
@@shot23CheckX:
    cmp ax, dx
    je @@shot23CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot23CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot24
    sub ax, 8
    cmp ax, dx
    je @@shot23CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot24
@@shot23CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot23Row1
    jmp near ptr ShotHitsRecord
@@shot23Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot23TallRows
    jmp near ptr ShotHitsRecord
@@shot23TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot24
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot24
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot24
    sub ax, 8
    cmp ax, cx
    jne @@shot23Row3
    jmp near ptr ShotHitsRecord
@@shot23Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot24
    jmp near ptr ShotHitsRecord
@@shot24:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot25
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot25
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot24CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot24CheckY
    sub ax, 8
@@shot24CheckX:
    cmp ax, dx
    je @@shot24CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot24CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot25
    sub ax, 8
    cmp ax, dx
    je @@shot24CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot25
@@shot24CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot24Row1
    jmp near ptr ShotHitsRecord
@@shot24Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot24TallRows
    jmp near ptr ShotHitsRecord
@@shot24TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot25
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot25
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot25
    sub ax, 8
    cmp ax, cx
    jne @@shot24Row3
    jmp near ptr ShotHitsRecord
@@shot24Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot25
    jmp near ptr ShotHitsRecord
@@shot25:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot26
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot26
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot25CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot25CheckY
    sub ax, 8
@@shot25CheckX:
    cmp ax, dx
    je @@shot25CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot25CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot26
    sub ax, 8
    cmp ax, dx
    je @@shot25CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot26
@@shot25CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot25Row1
    jmp near ptr ShotHitsRecord
@@shot25Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot25TallRows
    jmp near ptr ShotHitsRecord
@@shot25TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot26
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot26
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot26
    sub ax, 8
    cmp ax, cx
    jne @@shot25Row3
    jmp near ptr ShotHitsRecord
@@shot25Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot26
    jmp near ptr ShotHitsRecord
@@shot26:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot27
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot27
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot26CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot26CheckY
    sub ax, 8
@@shot26CheckX:
    cmp ax, dx
    je @@shot26CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot26CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot27
    sub ax, 8
    cmp ax, dx
    je @@shot26CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot27
@@shot26CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot26Row1
    jmp near ptr ShotHitsRecord
@@shot26Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot26TallRows
    jmp near ptr ShotHitsRecord
@@shot26TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot27
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot27
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot27
    sub ax, 8
    cmp ax, cx
    jne @@shot26Row3
    jmp near ptr ShotHitsRecord
@@shot26Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot27
    jmp near ptr ShotHitsRecord
@@shot27:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot28
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot28
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot27CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot27CheckY
    sub ax, 8
@@shot27CheckX:
    cmp ax, dx
    je @@shot27CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot27CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot28
    sub ax, 8
    cmp ax, dx
    je @@shot27CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot28
@@shot27CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot27Row1
    jmp near ptr ShotHitsRecord
@@shot27Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot27TallRows
    jmp near ptr ShotHitsRecord
@@shot27TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot28
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot28
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot28
    sub ax, 8
    cmp ax, cx
    jne @@shot27Row3
    jmp near ptr ShotHitsRecord
@@shot27Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot28
    jmp near ptr ShotHitsRecord
@@shot28:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot29
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot29
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot28CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot28CheckY
    sub ax, 8
@@shot28CheckX:
    cmp ax, dx
    je @@shot28CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot28CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot29
    sub ax, 8
    cmp ax, dx
    je @@shot28CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot29
@@shot28CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot28Row1
    jmp near ptr ShotHitsRecord
@@shot28Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot28TallRows
    jmp near ptr ShotHitsRecord
@@shot28TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot29
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot29
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot29
    sub ax, 8
    cmp ax, cx
    jne @@shot28Row3
    jmp near ptr ShotHitsRecord
@@shot28Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot29
    jmp near ptr ShotHitsRecord
@@shot29:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot30
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot30
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot29CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot29CheckY
    sub ax, 8
@@shot29CheckX:
    cmp ax, dx
    je @@shot29CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot29CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot30
    sub ax, 8
    cmp ax, dx
    je @@shot29CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot30
@@shot29CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot29Row1
    jmp near ptr ShotHitsRecord
@@shot29Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot29TallRows
    jmp near ptr ShotHitsRecord
@@shot29TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot30
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot30
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot30
    sub ax, 8
    cmp ax, cx
    jne @@shot29Row3
    jmp near ptr ShotHitsRecord
@@shot29Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot30
    jmp near ptr ShotHitsRecord
@@shot30:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot31
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot31
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot30CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot30CheckY
    sub ax, 8
@@shot30CheckX:
    cmp ax, dx
    je @@shot30CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot30CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot31
    sub ax, 8
    cmp ax, dx
    je @@shot30CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot31
@@shot30CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot30Row1
    jmp near ptr ShotHitsRecord
@@shot30Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot30TallRows
    jmp near ptr ShotHitsRecord
@@shot30TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot31
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot31
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot31
    sub ax, 8
    cmp ax, cx
    jne @@shot30Row3
    jmp near ptr ShotHitsRecord
@@shot30Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot31
    jmp near ptr ShotHitsRecord
@@shot31:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot32
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot32
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot31CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot31CheckY
    sub ax, 8
@@shot31CheckX:
    cmp ax, dx
    je @@shot31CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot31CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot32
    sub ax, 8
    cmp ax, dx
    je @@shot31CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot32
@@shot31CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot31Row1
    jmp near ptr ShotHitsRecord
@@shot31Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot31TallRows
    jmp near ptr ShotHitsRecord
@@shot31TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot32
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot32
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot32
    sub ax, 8
    cmp ax, cx
    jne @@shot31Row3
    jmp near ptr ShotHitsRecord
@@shot31Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot32
    jmp near ptr ShotHitsRecord
@@shot32:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@shot33
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@shot33
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot32CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot32CheckY
    sub ax, 8
@@shot32CheckX:
    cmp ax, dx
    je @@shot32CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot32CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot33
    sub ax, 8
    cmp ax, dx
    je @@shot32CheckY
    sub ax, 8
    cmp ax, dx
    jne @@shot33
@@shot32CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot32Row1
    jmp near ptr ShotHitsRecord
@@shot32Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot32TallRows
    jmp near ptr ShotHitsRecord
@@shot32TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@shot33
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@shot33
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@shot33
    sub ax, 8
    cmp ax, cx
    jne @@shot32Row3
    jmp near ptr ShotHitsRecord
@@shot32Row3:
    sub ax, 8
    cmp ax, cx
    jne @@shot33
    jmp near ptr ShotHitsRecord
@@shot33:
    add bx, RECORD_SIZE
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@noShotHit
    cmp word ptr ds:[bx + REC_SIDE_FLAG], 0
    je @@noShotHit
    mov ax, word ptr ds:[bx + REC_X]
    test ax, 7
    je @@shot33CheckX
    and ax, 0FFF8h
    add ax, 8
    cmp ax, dx
    je @@shot33CheckY
    sub ax, 8
@@shot33CheckX:
    cmp ax, dx
    je @@shot33CheckY
    sub ax, 8
    cmp ax, dx
    je @@shot33CheckY
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@noShotHit
    sub ax, 8
    cmp ax, dx
    je @@shot33CheckY
    sub ax, 8
    cmp ax, dx
    jne @@noShotHit
@@shot33CheckY:
    mov ax, word ptr ds:[bx + REC_Y]
    and ax, 0FFF8h
    cmp ax, cx
    jne @@shot33Row1
    jmp near ptr ShotHitsRecord
@@shot33Row1:
    sub ax, 8
    cmp ax, cx
    jne @@shot33TallRows
    jmp near ptr ShotHitsRecord
@@shot33TallRows:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    jne @@noShotHit
    cmp word ptr ss:[bp + REC_TYPE], 078h
    je @@noShotHit
    cmp word ptr ss:[bp + REC_TYPE], 079h
    je @@noShotHit
    sub ax, 8
    cmp ax, cx
    jne @@shot33Row3
    jmp near ptr ShotHitsRecord
@@shot33Row3:
    sub ax, 8
    cmp ax, cx
    jne @@noShotHit
    jmp near ptr ShotHitsRecord
@@noShotHit:
    add bx, RECORD_SIZE
PlayerShotsMissed:
    ret

; Spawns the pickup DropKind at (DropX, DropY) in pool A (BX = FFFFh if none free);
; falls through into InitPickupRecord.
SpawnItemDrop:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne @@haveRecord
    ret
@@haveRecord:
    mov word ptr ds:[bx + REC_STATUS], 1
    mov ax, word ptr ds:[DropY]
    add ax, word ptr ds:[ScrollDeltaY]
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[DropX]
    cmp ax, 0C0h
    jbe @@storeX
    mov ax, 0C0h
@@storeX:
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
    jne @@haveRecord
    ret
@@haveRecord:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@pickOffset
    mov byte ptr ds:[SfxRequest], 01Ah
@@pickOffset:
    mov cx, 0Ch
    mov dx, 0Ch
    cmp word ptr ds:[SegBossActive], 1
    jne @@placeShot
    mov cx, 01Ch
    mov dx, 8
@@placeShot:
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
    je @@evictRecord
    ret
@@evictRecord:
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
@@scanRecord:
    cmp word ptr ds:[bx + REC_KIND], KIND_EXHAUST
    je @@keepRecord
    cmp word ptr ds:[bx + REC_KIND], KIND_POD
    jne @@removeVictim
@@keepRecord:
    add bx, RECORD_SIZE
    loop @@scanRecord
    mov bx, offset PoolA
@@removeVictim:
    jmp near ptr RemoveRecordAtBX

; Round-robin search of PoolA from PoolACursor for a record with REC_STATUS = 0.
; Returns BX = free record (saved as the new PoolACursor, record not claimed) or
; BX = FFFFh when all POOL_A_COUNT records are busy.
FindFreeRecordPoolA:
    mov cx, POOL_A_COUNT
    mov bx, word ptr ds:[PoolACursor]
@@checkRecord:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@found
    add bx, RECORD_SIZE
    cmp bx, offset PoolAEnd
    jne @@nextRecord
    mov bx, offset PoolA
@@nextRecord:
    loop @@checkRecord
    mov bx, 0FFFFh
    ret
@@found:
    mov word ptr ds:[PoolACursor], bx
    ret

; FindFreeRecordPoolB; when the pool is full, frees the first pool B record that is not
; a beam link, missile or pod (else the first one). Always returns BX = record.
AllocPoolBRecordEvicting:
    call FindFreeRecordPoolB
    cmp bx, -1
    je @@evictRecord
    ret
@@evictRecord:
    mov cx, POOL_B_COUNT
    mov bx, offset PoolB
@@scanRecord:
    cmp word ptr ds:[bx + REC_TYPE], 9
    je @@keepRecord
    cmp word ptr ds:[bx + REC_TYPE], 0Ah
    je @@keepRecord
    cmp word ptr ds:[bx + REC_KIND], KIND_POD
    jne @@removeVictim
@@keepRecord:
    add bx, RECORD_SIZE
    loop @@scanRecord
    mov bx, offset PoolB
@@removeVictim:
    jmp near ptr RemoveRecordAtBX

; PoolB counterpart of FindFreeRecordPoolA, from PoolBCursor. Unlike pool A, the
; wrap to PoolB happens before each read, so a cursor equal to PoolBEnd is accepted.
FindFreeRecordPoolB:
    mov cx, POOL_B_COUNT
    mov bx, word ptr ds:[PoolBCursor]
@@wrapCheck:
    cmp bx, offset PoolBEnd
    jne @@checkRecord
    mov bx, offset PoolB
@@checkRecord:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@found
    add bx, RECORD_SIZE
    loop @@wrapCheck
    mov bx, 0FFFFh
    ret
@@found:
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
    jb @@lookupSprite
    sub bx, 01Ch
    mov cx, word ptr cs:[LevelSpritesSegment]
@@lookupSprite:
    shl bx, 1
    add bx, offset Sprite32Offsets
    mov si, word ptr cs:[bx]
    mov word ptr cs:[Sprite32HalfSource], si
    mov word ptr cs:[Sprite32HalfSegment], cx
    mov di, word ptr ss:[bp + REC_WORK_OFS]
    cmp di, -1
    je @@drawLowerHalf
    push bp
    call DrawSprite32Half
    pop bp
@@drawLowerHalf:
    mov di, word ptr ss:[bp + REC_WORK_OFS_LOWER]
    cmp di, -1
    jne @@lowerHalfSource
    ret
@@lowerHalfSource:
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
    jne @@pickBlitter
    mov dx, offset Sprite32Blitters
@@pickBlitter:
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
    jne @@visible
    ret
@@visible:
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr ss:[bp + REC_SPRITE]
    mov cx, word ptr cs:[Sprites2x2Segment]
    cmp bx, 0FAh
    jb @@lookupSprite
    sub bx, 0FAh
    mov cx, word ptr cs:[Sprites2x2CSegment]
@@lookupSprite:
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
    jne @@pickBlitter
    mov dx, offset Sprite16Blitters
@@pickBlitter:
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
    jne @@visible
    ret
@@visible:
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
RefuelTankFullTail:
    cmp byte ptr ds:[SfxEnabled], 0
    je StopRefuelTail
    mov byte ptr ds:[SfxRequest], 0Ch
StopRefuelTail:
    mov word ptr ds:[RefuelActive], 0
    ret

; While RefuelActive: Fuel + 1 until full (58h, sfx 0Ch), stopped when the ship is
; destroyed; falls into DrawFuelGauge.
TickRefuel:
    cmp word ptr ds:[RefuelActive], 1
    je @@refueling
    ret
@@refueling:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae StopRefuelTail
    cmp word ptr ds:[Fuel], 058h
    je RefuelTankFullTail
    inc word ptr ds:[Fuel]

; Draws the fuel gauge (on both pages on EGA). Preserves BP.
DrawFuelGauge:
    push bp
    call DrawFuelGaugeOnPage
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@done
    call FlipEgaDrawPage
    call DrawFuelGaugeOnPage
    call FlipEgaDrawPage
@@done:
    pop bp
    ret

DrawFuelGaugeOnPage:
    mov al, 01Dh
    mov ah, 05Fh
    call DrawOffsetFromScreenRow
    mov word ptr ds:[FuelGaugeOffset], di
    mov cx, word ptr ds:[Fuel]
    shr cx, 1
    jcxz @@noFuelBars
    jmp short @@drawFuelBar
@@noFuelBars:
    jmp near ptr @@drawEmptyBars
@@drawFuelBar:
    push cx
    mov es, word ptr cs:[ScreenSegment]
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je @@cgaFullBar
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je @@egaFullBar
    mov word ptr es:[di], 0FFCEh
    mov word ptr es:[di + 2], 0C4EEh
    test di, 06000h
    jne @@tandyFullRow2
    add di, 07F60h
@@tandyFullRow2:
    sub di, 02000h
    test di, 06000h
    jne @@tandyFullRow3
    add di, 07F60h
@@tandyFullRow3:
    sub di, 02000h
    jmp short @@nextFuelBar
@@egaFullBar:
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
    jmp short @@nextFuelBar
@@cgaFullBar:
    mov word ptr es:[di], 0A02Fh
    mov ax, 02000h
    test di, ax
    je @@cgaFullRow2
    mov ax, 0E050h
@@cgaFullRow2:
    sub di, ax
    mov ax, 02000h
    test di, ax
    je @@cgaFullRow3
    mov ax, 0E050h
@@cgaFullRow3:
    sub di, ax
@@nextFuelBar:
    pop cx
    loop @@loopFuelBar
    jmp short @@drawEmptyBars
@@loopFuelBar:
    jmp near ptr @@drawFuelBar
@@drawEmptyBars:
    mov cx, 02Ch
    mov ax, word ptr ds:[Fuel]
    shr ax, 1
    sub cx, ax
    jcxz @@barsDone
@@drawEmptyBar:
    push cx
    mov es, word ptr cs:[ScreenSegment]
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je @@cgaEmptyBar
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je @@egaEmptyBar
    mov word ptr es:[di], 0
    mov word ptr es:[di + 2], 0
    test di, 06000h
    jne @@tandyEmptyRow2
    add di, 07F60h
@@tandyEmptyRow2:
    sub di, 02000h
    test di, 06000h
    jne @@tandyEmptyRow3
    add di, 07F60h
@@tandyEmptyRow3:
    sub di, 02000h
    jmp short @@nextEmptyBar
@@egaEmptyBar:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    mov byte ptr es:[di], 0
    sub di, 028h
    sub di, 028h
    jmp short @@nextEmptyBar
@@cgaEmptyBar:
    mov word ptr es:[di], 0
    mov ax, 02000h
    test di, ax
    je @@cgaEmptyRow2
    mov ax, 0E050h
@@cgaEmptyRow2:
    sub di, ax
    mov ax, 02000h
    test di, ax
    je @@cgaEmptyRow3
    mov ax, 0E050h
@@cgaEmptyRow3:
    sub di, ax
@@nextEmptyBar:
    pop cx
    loop @@drawEmptyBar
@@barsDone:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@checkLowFuel
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
@@checkLowFuel:
    cmp word ptr ds:[Fuel], 010h
    jae @@done
    cmp word ptr ds:[RefuelActive], 1
    je @@done
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 0Ah
@@done:
    ret

; Runs the level's map cell handler for each of the 13 cells of the map row at
; MapRowCursor (AL = cell byte, ES:SI = the cell, MapCellX = its pixel X); handlers
; spawn the enemies placed in the map and overwrite their cells.
SpawnFromMapRow:
    mov es, word ptr cs:[LevelMapSegment]
    mov si, word ptr ds:[MapRowCursor]
    mov word ptr ds:[MapRowCellsLeft], 0Dh
    mov word ptr ds:[MapCellX], 0
@@nextCell:
    mov al, byte ptr es:[si]
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    call word ptr ds:[bx + LevelMapCellHandlers]
    add word ptr ds:[MapCellX], 010h
    inc si
    dec word ptr ds:[MapRowCellsLeft]
    jne @@nextCell
    ret
Level1MapCell:
    cmp al, 4
    jne @@check07
    jmp near ptr SpawnCellClimbWalker8B
@@check07:
    cmp al, 7
    jne @@check6C
    jmp near ptr SpawnCellClimbWalker8C
@@check6C:
    cmp al, 06Ch
    jne @@check6D
    jmp near ptr SpawnCellTurretLeft24
@@check6D:
    cmp al, 06Dh
    jne @@checkAC
    jmp near ptr SpawnCellTurretRight25
@@checkAC:
    cmp al, 0ACh
    jne @@checkB1
    jmp near ptr SpawnCellVolleyTurret90
@@checkB1:
    cmp al, 0B1h
    jne @@checkC9
    jmp near ptr SpawnCellVolleyTurret91
@@checkC9:
    cmp al, 0C9h
    je SpawnCellHatch28
    ret
; Overwrites the 2x2 cells at ES:SI (the map is 13 cells wide) with cell 1.
Clear2x2MapCells:
    mov byte ptr es:[si], 1
    mov byte ptr es:[si + 1], 1
    mov byte ptr es:[si + MAP_ROW_BYTES], 1
    mov byte ptr es:[si + 0Eh], 1
    ret
; Level 5 byte D9h: large type 48h, facing down, joins group.
SpawnCellCreeper48:
    call Clear2x2MapCells
    call FindFreeRecordPoolA
    cmp bx, -1
    jne @@haveRecord
    ret
@@haveRecord:
    call InitMapLargeEnemy
    mov word ptr ds:[bx + REC_TYPE], 48h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    jmp near ptr JoinMapGroup
; Level 0 byte F8h: large type 75h, joins group.
SpawnCellSpreadShooter75:
    call Clear2x2MapCells
    call FindFreeRecordPoolA
    cmp bx, -1
    jne @@haveRecord
    ret
@@haveRecord:
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
    jne @@haveRecord
    ret
@@haveRecord:
    call InitMapLargeEnemy
    mov word ptr ds:[bx + REC_TYPE], 72h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    ret
; Level 1/4 byte C9h: writes the hatch cells 26h..29h, large type 28h.
SpawnCellHatch28:
    mov byte ptr es:[si + MAP_ROW_BYTES], 026h
    mov byte ptr es:[si + 0Eh], 027h
    mov byte ptr es:[si], 028h
    mov byte ptr es:[si + 1], 029h
    call FindFreeRecordPoolA
    cmp bx, -1
    jne @@haveRecord
    ret
@@haveRecord:
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
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 08Bh
    ret
; Level 1 07h, level 3 DDh, level 4 CEh, level 5 D7h.
SpawnCellClimbWalker8C:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 08Ch
    ret
; Level 0 byte EEh (grouped); the level 5 D8h table slot is dead.
SpawnCellClimbWalker8E:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 8Eh
    ret
; Level 0 byte F9h: a fuel pickup (DropKind 4).
SpawnCellFuelPickup:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov ax, 4
    mov ds:[DropKind], ax
    call InitPickupRecord
    ret
; Level 0 byte EDh (grouped); the level 5 D7h table slot is dead.
SpawnCellClimbWalker8D:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 8Dh
    ret
; Level 1 byte 6Ch: type 24h facing left; the cell stays.
SpawnCellTurretLeft24:
    call SpawnMapEnemyKeepCell
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 024h
    mov word ptr ds:[bx + REC_SPRITE], 08Fh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    ret
; Level 1 byte 6Dh: type 25h facing right; the cell stays.
SpawnCellTurretRight25:
    call SpawnMapEnemyKeepCell
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 025h
    mov word ptr ds:[bx + REC_SPRITE], 090h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 1/4 byte ACh, level 5 D3h: type 90h facing left; the cell stays.
SpawnCellVolleyTurret90:
    call SpawnMapEnemyKeepCell
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 090h
    mov word ptr ds:[bx + REC_SPRITE], 089h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    ret
; Level 1/4 byte B1h, level 5 D2h: type 91h facing right; the cell stays.
SpawnCellVolleyTurret91:
    call SpawnMapEnemyKeepCell
    jne @@spawned
    ret
@@spawned:
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
    jne @@haveRecord
    ret
@@haveRecord:
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
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 2Eh
    sub word ptr ds:[bx + REC_Y], 6
    ret
; Level 2 byte C4h: type 8Fh facing the centre.
SpawnCellFireBurst8F:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 8Fh
    mov word ptr ds:[bx + REC_SPRITE], 0BFh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceRight
    ret
@@faceRight:
    mov word ptr ds:[bx + REC_SPRITE], 0C2h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 0 byte BCh (left half only): type 73h facing right.
SpawnCellRunnerRight73:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
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
    jne @@spawned
    ret
@@spawned:
    add word ptr ds:[bx + REC_X], 0Ch
    push word ptr ds:[bx + REC_X]
    pop word ptr ds:[bx + REC_SAVED_X]
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 74h
    mov word ptr ds:[bx + REC_SPRITE], 14Fh
    ret
Level0MapCell:
    cmp word ptr ds:[MapCellX], 60h
    ja @@rightHalf
    cmp al, 0BCh
    je SpawnCellRunnerRight73
    jmp short @@checkGroupRange
@@rightHalf:
    cmp al, 0BBh
    je SpawnCellRunnerLeft74
@@checkGroupRange:
    sub al, 0E1h
    jns @@checkUpper
    ret
@@checkUpper:
    cmp al, 1Ah
    jna @@dispatchGroupCell
    ret
@@dispatchGroupCell:
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
    jns @@checkUpper
    ret
@@checkUpper:
    cmp al, 1Dh
    jna @@dispatchGroupCell
    ret
@@dispatchGroupCell:
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
    jne @@checkB1
    jmp near ptr SpawnCellVolleyTurret90
@@checkB1:
    cmp al, 0B1h
    jne @@checkC9
    jmp near ptr SpawnCellVolleyTurret91
@@checkC9:
    cmp al, 0C9h
    jne @@checkGroupRange
    jmp near ptr SpawnCellHatch28
@@checkGroupRange:
    sub al, 0CEh
    jns @@checkUpper
    ret
@@checkUpper:
    cmp al, 014h
    jbe @@dispatchGroupCell
    ret
@@dispatchGroupCell:
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
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 38h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_RIGHT
    ret
; Level 4 byte DBh: type 38h heading down-left.
SpawnCellWallBouncer38Left:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 38h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_LEFT
    ret
; Level 4 D2h, level 5 DCh: type 54h.
SpawnCellCrawler54UpRight:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 172h
    cmp word ptr ds:[LevelIndex], 4
    jne @@nonLevel4Sprite
    ret
@@nonLevel4Sprite:
    mov word ptr ds:[bx + REC_SPRITE], 17Ah
    ret
; Level 4 D3h, level 5 DDh: type 54h.
SpawnCellCrawler54UpLeft:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 173h
    cmp word ptr ds:[LevelIndex], 4
    jne @@nonLevel4Sprite
    ret
@@nonLevel4Sprite:
    mov word ptr ds:[bx + REC_SPRITE], 17Bh
    ret
; Level 5 byte BAh: type 84h facing up.
SpawnCellLurker84Up:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 156h
    ret
; Level 5 byte BBh: type 84h facing right.
SpawnCellLurker84Right:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 157h
    ret
; Level 5 byte BCh: type 84h facing down.
SpawnCellLurker84Down:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 158h
    ret
; Level 5 byte B6h: type 84h facing left.
SpawnCellLurker84Left:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 84h
    mov word ptr ds:[bx + REC_SPRITE], 159h
    ret
Level5MapCell:
    cmp al, 30h
    jne @@checkLurkers
    jmp near ptr SpawnCellHatch2A
@@checkLurkers:
    cmp al, 0BAh
    je SpawnCellLurker84Up
    cmp al, 0BBh
    je SpawnCellLurker84Right
    cmp al, 0BCh
    je SpawnCellLurker84Down
    cmp al, 0B6h
    je SpawnCellLurker84Left
    cmp al, 0D8h
    jne @@checkD7
    jmp near ptr SpawnCellClimbWalker8B
@@checkD7:
    cmp al, 0D7h
    jne @@checkD3
    jmp near ptr SpawnCellClimbWalker8C
@@checkD3:
    cmp al, 0D3h
    jne @@checkD2
    jmp near ptr SpawnCellVolleyTurret90
@@checkD2:
    cmp al, 0D2h
    jne @@checkGroupRange
    jmp near ptr SpawnCellVolleyTurret91
@@checkGroupRange:
    sub al, 0D7h
    jns @@checkUpper
    ret
@@checkUpper:
    cmp al, 1Ah
    jna @@dispatchGroupCell
    ret
@@dispatchGroupCell:
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
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 19h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 5 byte E4h: type 30h facing down.
SpawnCellShooter30:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_SPRITE], 46h
    mov word ptr ds:[bx + REC_TYPE], 30h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    ret
; Level 5 byte DAh: type 92h facing right.
SpawnCellLevelFirer92Right:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 92h
    mov word ptr ds:[bx + REC_SPRITE], 15Ah
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 5 byte DBh: type 92h facing left.
SpawnCellLevelFirer92Left:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 92h
    mov word ptr ds:[bx + REC_SPRITE], 15Bh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    ret
; Level 3 bytes CEh, CFh: type 86h facing the centre.
SpawnCellLauncher86:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 86h
    mov word ptr ds:[bx + REC_SPRITE], 0C8h
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceRight
    ret
@@faceRight:
    mov word ptr ds:[bx + REC_SPRITE], 0DAh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 0 bytes E1h, E2h: type 88h facing the centre.
SpawnCellBurstFirer88:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 88h
    mov word ptr ds:[bx + REC_SPRITE], 0FDh
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceRight
    ret
@@faceRight:
    mov word ptr ds:[bx + REC_SPRITE], 0FAh
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 3 D7h, level 5 E3h: type 63h facing right.
SpawnCellSlider63:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    mov word ptr ds:[bx + REC_TYPE], 63h
    mov word ptr ds:[bx + REC_SPRITE], 0E7h
    ret
; Level 0 byte EBh: type 71h facing down, joins group.
SpawnCellDiver71:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 71h
    ret
; Level 0 EFh, level 4 D5h: type 8Ah, joins group.
SpawnCellPatroller8A:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 8Ah
    ret
; Level 3 bytes D0h, D1h: type 54h heading up toward the centre.
SpawnCellCrawler54InwardA:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 0F5h
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceUpRight
    ret
@@faceUpRight:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 0F4h
    ret
; Level 0 byte E7h: type 6Bh.
SpawnCellDescender6B:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 6Bh
    ret
; Level 0 byte E8h: type 6Ch, joins group.
SpawnCellDescender6C:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 6Ch
    mov word ptr ds:[bx + REC_SPRITE], 123h
    ret
; Level 0 byte E9h: type 6Dh.
SpawnCellDescender6D:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 6Dh
    ret
; Level 0 bytes E5h, E6h: type 6Ah heading down toward the centre.
SpawnCellCrawler6A:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_LEFT
    mov word ptr ds:[bx + REC_TYPE], 6Ah
    mov word ptr ds:[bx + REC_SPRITE], 11Eh
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceDownRight
    ret
@@faceDownRight:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 11Dh
    ret
; Level 0 bytes F0h, F1h: type 54h facing the centre.
SpawnCellCrawler54InwardB:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 54h
    mov word ptr ds:[bx + REC_SPRITE], 143h
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceUpRight
    ret
@@faceUpRight:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 144h
    ret
; Level 3 E3h, level 4 E0h, level 5 EFh: type 5Eh, joins group.
SpawnCellCrawler5E:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 5Eh
    mov word ptr ds:[bx + REC_SPRITE], 27h
    ret
; Level 0 byte EAh: type 6Eh facing down, joins group.
SpawnCellCrawler6E:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 6Eh
    ret
; Level 0 byte ECh: type 6Fh, 16 px outward, facing the centre.
SpawnCellCruiser6F:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
; Offset-placement use of field+8 does not define its role in other record types.
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 6Fh
    mov word ptr ds:[bx + REC_SPRITE], 136h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_RIGHT
    sub word ptr ds:[bx + REC_X], 10h
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jae @@rightSide
    ret
@@rightSide:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN_LEFT
    add word ptr ds:[bx + REC_X], 20h
    ret
; Level 3 E2h, level 5 EEh: type 2Dh, joins group.
SpawnCellPlunger2D:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_TYPE], 2Dh
    ret
; Level 3 E8h, level 5 E9h: type 47h, joins group.
SpawnCellPatroller47:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 47h
    ret
; Level 0 F4h, level 3 D8h, level 4 D7h: type 59h facing the centre.
SpawnCellCrawler59:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_TYPE], 59h
    mov word ptr ds:[bx + REC_SPRITE], 0E3h
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceUpRight
    ret
@@faceUpRight:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    ret
; Level 3 D6h, level 4 D4h: type 5Fh facing the centre.
SpawnCellCrawler5F:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 5Fh
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceRight
    ret
@@faceRight:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 3 byte E7h: type 5Bh facing up.
SpawnCellRiser5B:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_TYPE], 5Bh
    mov word ptr ds:[bx + REC_SPRITE], 74h
    ret
; Level 3 E4h, level 4 D9h, level 5 E0h: type 5Dh, joins group.
SpawnCellDropper5D:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    mov word ptr ds:[bx + REC_TYPE], 5Dh
    mov word ptr ds:[bx + REC_SPRITE], 77h
    ret
; Level 3 D2h, D3h, level 5 DEh, DFh: type 87h facing the centre.
SpawnCellFireBurst87:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
    mov word ptr ds:[bx + REC_TYPE], 87h
    mov word ptr ds:[bx + REC_SPRITE], 0E0h
    cmp word ptr ds:[bx + REC_X], PLAYFIELD_CENTER_X
    jna @@faceRight
    ret
@@faceRight:
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 0DDh
    ret
; Level 3 byte D4h: type 55h.
SpawnCellDropper55:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 55h
    mov word ptr ds:[bx + REC_SPRITE], 77h
    ret
; Level 0 F2h, F3h, level 3 E5h, E6h, level 4 DCh: type 34h.
SpawnCellSideTurret34:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 34h
    ret
; Level 3 E1h, level 5 EDh: type 37h, joins group.
SpawnCellBouncer37:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 37h
    ret
; Level 3 D5h, level 4 D8h: type 83h, joins group.
SpawnCellPatroller83:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 83h
    ret
; Level 0 F6h, level 3 E0h, level 4 D6h, level 5 ECh: type 4Fh.
SpawnCellFaller4F:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 4Fh
    ret
; Level 3 byte DBh: type 19h, joins group.
SpawnCellWallPatroller19Down:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 19h
    ret
; Level 3 E9h, level 4 DFh, level 5 EAh: type 35h, joins group.
SpawnCellBurster35:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 35h
    ret
; Level 0 E4h, level 4 DEh: type 69h.
SpawnCellJitterDropper69:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 69h
    ret
; Level 0 E3h, level 4 DDh, level 5 EBh: type 68h (1 in 16 grouped on level 5).
SpawnCellJitterShooter68:
    cmp word ptr ds:[LevelIndex], 5
    jne @@spawnUngrouped
    call NextRandomWord
    and bx, 0Fh
    cmp bx, 0Fh
    jne @@spawnUngrouped
    call SpawnMapGroupEnemy
    jmp short @@checkSpawned
@@spawnUngrouped:
    call SpawnMapEnemy
@@checkSpawned:
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 68h
    ret
; Level 3 DCh, level 5 E8h: type 89h, joins group.
SpawnCellPatroller89:
    call SpawnMapGroupEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 89h
    ret
; Level 3 D9h, level 4 D0h, level 5 E5h: type 58h facing right.
SpawnCellCrawler58Right:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
    mov word ptr ds:[bx + REC_TYPE], 58h
    mov word ptr ds:[bx + REC_SPRITE], 99h
    mov word ptr ds:[bx + REC_DIRECTION], DIR_RIGHT
    ret
; Level 3 DAh, level 4 D1h, level 5 E6h: type 57h facing left.
SpawnCellCrawler57Left:
    call SpawnMapEnemy
    jne @@spawned
    ret
@@spawned:
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
    je @@storeSlotIndex
    push bx
    mov bx, ds:[GroupSlotPtr]
    inc byte ptr ds:[bx + GROUP_LIVE]
    mov al, byte ptr ds:[GroupDropKind]
    mov ds:[bx + GROUP_DROP_KIND], al
    pop bx
    mov ax, ds:[GroupSlotIndex]
@@storeSlotIndex:
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
    jne @@haveRecord
    ret
@@haveRecord:
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
    jne @@haveRecord
    ret
@@haveRecord:
    jmp short InitEnemyRecordHere
SpawnEnemyHere:
    call FindFreeRecordPoolA
    cmp bx, -1
    jne @@haveRecord
    ret
@@haveRecord:
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
    je @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
    call SpawnThrottledChild
    cmp bx, -1
    jne @@setShotSprite
    jmp near ptr ScrollRecordThenFinish
@@setShotSprite:
    mov word ptr ds:[bx + REC_SPRITE], 1Eh
    jmp near ptr ScrollRecordThenFinish
; As type 24h; its wreck faces right.
Type25TurretRightFire32:
    cmp word ptr ds:[FrameCount32], 1Fh
    je @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
    call SpawnThrottledChild
    cmp bx, -1
    jne @@setShotSprite
    jmp near ptr ScrollRecordThenFinish
@@setShotSprite:
    mov word ptr ds:[bx + REC_SPRITE], 1Ah
    jmp near ptr ScrollRecordThenFinish
; Types 90h/91h: turret alternating shots above and below every 32 frames.
Type90TurretVolley:
    mov ax, 88h
    cmp word ptr ds:[LevelIndex], 4
    jne TurretVolleyAnimateTail
    mov ax, 16Ch
    jmp short TurretVolleyAnimateTail
; Type 90h with sprite base 8Bh.
Type91TurretVolleyAlt:
    mov ax, 8Bh
    cmp word ptr ds:[LevelIndex], 4
    jne TurretVolleyAnimateTail
    mov ax, 16Fh
TurretVolleyAnimateTail:
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
    je @@fireVolley
    jmp near ptr ScrollRecordThenFinish
@@fireVolley:
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
TurretRemnantFlickerTail:
    cmp word ptr ds:[FrameCount4], 3
    je @@flickerStep
    jmp near ptr ScrollRecordThenFinish
@@flickerStep:
    mov ax, ss:[bp + REC_SAVED_X]
    mov ss:[bp + REC_X], ax
    dec word ptr ss:[bp + REC_SPRITE]
    jmp near ptr ScrollRecordThenFinish
; What a destroyed wall turret (24h/25h) leaves: slides out along REC_DIRECTION until
; blocked, stepping its sprite, then flickers in place. Harmless: no collision, never a
; missile target.
Type26TurretRemnant:
    cmp word ptr ss:[bp + REC_SPRITE], 98h
    je TurretRemnantFlickerTail
    cmp word ptr ss:[bp + REC_SPRITE], 92h
    je TurretRemnantFlickerTail
    call TryTerrainStep
    jne @@slideStep
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    jae @@slideStep
    jmp near ptr ScrollRecordThenFinish
@@slideStep:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 1Eh
@@done:
    jmp near ptr ScrollRecordThenFinish
; CF when BP lies within 10h of PlayerHitY/X on both axes.
RecordNearPlayerHitPoint:
    mov si, word ptr ds:[PlayerHitY]
    add si, 010h
    cmp word ptr ss:[bp + REC_Y], si
    jg @@notNear
    sub si, 020h
    cmp word ptr ss:[bp + REC_Y], si
    jl @@notNear
    mov si, word ptr ds:[PlayerHitX]
    add si, 010h
    cmp word ptr ss:[bp + REC_X], si
    jg @@notNear
    sub si, 020h
    cmp word ptr ss:[bp + REC_X], si
    jl @@notNear
    stc
    ret
@@notNear:
    clc
    ret
; Descends 1 px per frame plus scroll.
Type27SlowDescender:
    mov ax, ds:[SlowCount6]
    shr ax, 1
    mov bx, 27h
    cmp word ptr ds:[LevelIndex], 5
    jne @@setSprite
    mov bx, 24h
@@setSprite:
    add ax, bx
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    jmp near ptr ScrollRecordThenFinish

; Moves each upgrade slot to the first list entry whose availability test passes (NZ);
; after 10 failures shows the empty icon 24h.
AdvanceToAvailableUpgrade:
    cmp word ptr ds:[SelectedUpgradeSlot], -1
    jne @@haveSelection
    ret
@@haveSelection:
    mov bp, word ptr ds:[SelectedUpgradeSlot]
    shl bp, 1
    add bp, offset UpgradeSlotPtrs
    mov bp, word ptr ss:[bp]
    mov si, word ptr ss:[bp + UPGRADE_SLOT_LIST]
    mov word ptr ds:[UpgradeTries], 0
@@tryEntry:
    mov bx, word ptr ss:[bp + UPGRADE_SLOT_INDEX]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov ax, word ptr ds:[bx + si + 2]
    cmp ax, 0FFFFh
    je @@wrapList
    push bp
    call ax
    pop bp
    jne @@available
    inc word ptr ss:[bp + UPGRADE_SLOT_INDEX]
    inc word ptr ds:[UpgradeTries]
    cmp word ptr ds:[UpgradeTries], 0Ah
    jb @@tryEntry
    mov word ptr ss:[bp + UPGRADE_SLOT_INDEX], 0
    mov word ptr ss:[bp + UPGRADE_SLOT_ICON], 024h
    ret
@@available:
    mov ax, word ptr ds:[bx + si]
    mov word ptr ss:[bp + UPGRADE_SLOT_ICON], ax
    ret
@@wrapList:
    mov word ptr ss:[bp + UPGRADE_SLOT_INDEX], 0
    jmp short @@tryEntry
; Upgrade list condition routines: ZF = 0 when the entry can be offered; the apply
; routines end in FinishUpgrade (SelectedUpgradeSlot = FFFFh).
UpgradeNeverAvailable:
    xor ax, ax
    ret
UpgradeAlwaysAvailable:
    xor ax, ax
    inc ax
    ret
SingleShotAvailable:
    cmp word ptr ds:[WeaponMode], WEAPON_SINGLE
    ret
HeavyShotAvailable:
    cmp word ptr ds:[WeaponMode], WEAPON_HEAVY
    ret
ForkShotAvailable:
    cmp word ptr ds:[WeaponMode], WEAPON_FORK
    ret
TwinRising3Available:
    cmp word ptr ds:[WeaponMode], WEAPON_TWIN_RISING3
    ret
TwinRising16Available:
    cmp word ptr ds:[WeaponMode], WEAPON_TWIN_RISING16
    ret
BeamAvailable:
    cmp word ptr ds:[WeaponMode], WEAPON_BEAM
    ret
ApplySingleShot:
    mov word ptr ds:[WeaponMode], WEAPON_SINGLE
    jmp short FinishUpgrade
ApplyHeavyShot:
    mov word ptr ds:[WeaponMode], WEAPON_HEAVY
    jmp short FinishUpgrade
ApplyForkShot:
    mov word ptr ds:[WeaponMode], WEAPON_FORK
    jmp short FinishUpgrade
ApplyTwinRising3:
    mov word ptr ds:[WeaponMode], WEAPON_TWIN_RISING3
    jmp short FinishUpgrade
ApplyTwinRising16:
    mov word ptr ds:[WeaponMode], WEAPON_TWIN_RISING16
    jmp short FinishUpgrade
ApplyBeam:
    mov word ptr ds:[WeaponMode], WEAPON_BEAM
FinishUpgrade:
    mov word ptr ds:[SelectedUpgradeSlot], 0FFFFh
    ret
SideShotsAvailable:
    cmp word ptr ds:[SideShotsEnabled], 1
    ret
ApplySideShots:
    mov word ptr ds:[SideShotsEnabled], 1
    jmp short FinishUpgrade
MissilesAvailable:
    cmp word ptr ds:[MissileAmmo], 0
    je UpgradeAlwaysAvailable
    jmp short UpgradeNeverAvailable
ApplyMissiles:
    mov word ptr ds:[MissileAmmo], 4
    jmp short FinishUpgrade
FrontPodAvailable:
    cmp word ptr ds:[FrontPodRecord], -1
    jne @@unavailable
    jmp near ptr UpgradeAlwaysAvailable
@@unavailable:
    jmp near ptr UpgradeNeverAvailable
ApplyFrontPod:
    call AddFrontPod
    jmp short FinishUpgrade
SidePodsAvailable:
    cmp word ptr ds:[SidePodLeftInner], -1
    jne @@checkRightInner
    jmp near ptr UpgradeAlwaysAvailable
@@checkRightInner:
    cmp word ptr ds:[SidePodRightInner], -1
    jne @@checkForm
    jmp near ptr UpgradeAlwaysAvailable
@@checkForm:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    jne @@checkLeftOuter
    jmp near ptr UpgradeNeverAvailable
@@checkLeftOuter:
    cmp word ptr ds:[SidePodLeftOuter], -1
    jne @@checkRightOuter
    jmp near ptr UpgradeAlwaysAvailable
@@checkRightOuter:
    cmp word ptr ds:[SidePodRightOuter], -1
    jne @@unavailable
    jmp near ptr UpgradeAlwaysAvailable
@@unavailable:
    jmp near ptr UpgradeNeverAvailable
ApplySidePods:
    call AddSidePods
    jmp short FinishUpgrade
TrailingPodsAvailable:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 2
    je @@checkNearPod
    jmp near ptr UpgradeNeverAvailable
@@checkNearPod:
    cmp word ptr ds:[TrailingPodNear], -1
    jne @@checkFarPod
    jmp near ptr UpgradeAlwaysAvailable
@@checkFarPod:
    cmp word ptr ds:[TrailingPodFar], -1
    jne @@unavailable
    jmp near ptr UpgradeAlwaysAvailable
@@unavailable:
    jmp near ptr UpgradeNeverAvailable
ApplyTrailingPods:
    call AddTrailingPod
    jmp near ptr FinishUpgrade
ShipForm1Available:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    jne @@unavailable
    jmp near ptr UpgradeAlwaysAvailable
@@unavailable:
    jmp near ptr UpgradeNeverAvailable
ApplyShipForm1:
    mov byte ptr ds:[SfxActive], 0
    cmp byte ptr ds:[SfxEnabled], 0
    je @@setForm
    mov byte ptr ds:[SfxRequest], 6
@@setForm:
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 1
    jmp near ptr FinishUpgrade
ShipForm2Available:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 2
    je @@unavailable
    jmp near ptr UpgradeAlwaysAvailable
@@unavailable:
    jmp near ptr UpgradeNeverAvailable
ApplyShipForm2:
    mov byte ptr ds:[SfxActive], 0
    cmp byte ptr ds:[SfxEnabled], 0
    je @@setForm
    mov byte ptr ds:[SfxRequest], 6
@@setForm:
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 2
    jmp near ptr FinishUpgrade

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
    jne @@haveSelection
    ret
@@haveSelection:
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
    jne @@done
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 9
@@done:
    pop bp
    pop bx
    ret

; Draws the four upgrade slots (on both pages on EGA). Preserves BP.
DrawUpgradeSlots:
    push bp
    call DrawUpgradeSlotsOnPage
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@done
    call FlipEgaDrawPage
    call DrawUpgradeSlotsOnPage
    call FlipEgaDrawPage
@@done:
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
    je @@notSelected
    mov si, word ptr ds:[SelectedUpgradeSlot]
    shl si, 1
    add si, offset UpgradeSlotPtrs
    cmp bp, word ptr ds:[si]
    mov ax, 1
    je @@pickIcon
@@notSelected:
    xor ax, ax
@@pickIcon:
    cmp word ptr ds:[DemoActive], 1
    jne @@slotIcon
    cmp di, word ptr ds:[SelectedUpgradeSlot]
    jne @@slotIcon
    push word ptr ds:[DemoUpgradeStatus]
    jmp short @@drawImages
@@slotIcon:
    push word ptr ss:[bp + UPGRADE_SLOT_ICON]
@@drawImages:
    push ax
    mov si, word ptr ss:[bp + UPGRADE_SLOT_IMAGE]
    add si, ax
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov di, word ptr ss:[bp + UPGRADE_SLOT_SCREEN]
    push di
    mov cx, 5
@@advanceColumn:
    call AdvanceDrawColumn
    loop @@advanceColumn
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop di
    call RetreatDrawColumn
    pop si
    add si, PANEL_UPGRADE_FRAME
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
    jne @@setSprite
    inc word ptr ss:[bp + REC_DIRECTION]
    cmp word ptr ss:[bp + REC_DIRECTION], 18h
    jb @@setSprite
    mov word ptr ss:[bp + REC_DIRECTION], 0
@@setSprite:
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
    je @@animate
    cmp word ptr ds:[LevelIndex], 4
    je @@animate
    mov cx, 1Ch
@@animate:
    call StepHatchRampFrame
    cmp word ptr ds:[EncounterLiveCount], 0
    je @@checkReleasePhase
    jmp near ptr ScrollRecordThenFinish
@@checkReleasePhase:
    cmp word ptr ss:[bp + REC_DIRECTION], 7
    je @@release
    jmp near ptr ScrollRecordThenFinish
@@release:
    inc word ptr ss:[bp + REC_DIRECTION]
    call SpawnEnemyHere
    cmp bx, -1
    jne @@configureChild
    jmp near ptr ScrollRecordThenFinish
@@configureChild:
    mov word ptr ds:[bx + REC_HIT_POINTS], 4
    add word ptr ds:[bx + REC_Y], 8
    add word ptr ds:[bx + REC_X], 8
    cmp word ptr ds:[LevelIndex], 1
    je @@childType29
    cmp word ptr ds:[LevelIndex], 4
    je @@childType29
    cmp word ptr ds:[LevelIndex], 2
    je @@childType2B
    cmp word ptr ds:[LevelIndex], 5
    je @@childType7A
    jmp near ptr ScrollRecordThenFinish
@@childType29:
    mov word ptr ds:[bx + REC_TYPE], 29h
    mov word ptr ds:[bx + REC_SPRITE], 0A1h
    jmp near ptr ScrollRecordThenFinish
@@childType2B:
    mov word ptr ds:[bx + REC_TYPE], 2Bh
    mov word ptr ds:[bx + REC_SPRITE], 0A5h
    call AimAtPlayer
    jmp near ptr ScrollRecordThenFinish
@@childType7A:
    mov word ptr ds:[bx + REC_TYPE], 7Ah
    mov word ptr ds:[bx + REC_SPRITE], 20h
    call AimAtPlayer
    jmp near ptr ScrollRecordThenFinish
; Type 7Ah with sprite base 15Ch.
Type7CAimLineFlyerAlt:
    mov ax, 15Ch
    jmp short AimLineFlyerAnimTail
; Animated type 60h flight along the aim line.
Type7AAimLineFlyer:
    mov ax, 20h
AimLineFlyerAnimTail:
    add ax, ds:[FrameCount4]
    jmp short AimedFlyerSetSpriteTail
; 2 px steps along its aimed REC_DELTA; destroyed when X leaves 0..C0h.
Type2BAimedDart:
    mov ax, 0A5h
    add ax, ds:[SlowCount4]
AimedFlyerSetSpriteTail:
    mov ss:[bp + REC_SPRITE], ax
    jmp short Type60FlyAlongAimLine
; Emerges over four frames, then aims at the player and flies like type 60h.
Type29EmergeThenDart:
    cmp word ptr ss:[bp + REC_SPRITE], 0A4h
    je Type60FlyAlongAimLine
    cmp word ptr ds:[FrameCount8], 7
    je @@emergeStep
    jmp near ptr ScrollRecordThenFinish
@@emergeStep:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp word ptr ss:[bp + REC_SPRITE], 0A4h
    je @@aim
    jmp near ptr ScrollRecordThenFinish
@@aim:
    mov bx, bp
    call AimAtPlayer
; 2 px Bresenham steps along REC_DELTA; destroyed when X leaves 0..C0h.
Type60FlyAlongAimLine:
    mov word ptr ds:[ChaseStepPixels], 2
    call StepAlongDelta
    mov word ptr ds:[ChaseStepPixels], 3
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    jg @@offscreen
    cmp word ptr ss:[bp + REC_X], 0
    jl @@offscreen
    jmp near ptr ScrollRecordThenFinish
@@offscreen:
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
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    ja CheckFirePhase
    add word ptr ss:[bp + REC_SPRITE], 3
CheckFirePhase:
    cmp cx, 3
    je @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
    call SpawnThrottledChild
    cmp bx, -1
    jne @@setShotSprite
    jmp near ptr ScrollRecordThenFinish
@@setShotSprite:
    mov word ptr ds:[bx + REC_SPRITE], 44h
    jmp near ptr ScrollRecordThenFinish
; Above Y 60h fires down every 128 frames; below falls 4 px per frame (shares type 2Dh's
; tail).
Type71FireThenDiveBelow60:
    mov ax, ds:[SlowCount8]
    add ax, 12Bh
    jmp short HoverFirePlungeTail
; Above Y 60h: scrolls and fires down every 128 frames; below: falls 4 px per frame.
Type2DHoverFireThenPlunge:
    mov ax, ds:[SlowCount4]
    add ax, 93h
HoverFirePlungeTail:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_Y], 60h
    ja @@plunge
    cmp word ptr ds:[FrameCount128], 7Fh
    je @@fireDown
    jmp near ptr ScrollRecordThenFinish
@@fireDown:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
@@plunge:
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
    jnl @@steer
    jmp near ptr ScrollRecordThenFinish
@@steer:
    jne @@steerToTarget
    call SetPlungeTargetBelowPlayer
@@steerToTarget:
    call SteerToSaved
    jmp near ptr FinishRecordUpdate
; Type 2Eh: targets the player's column far below (REC_SAVED_Y 7530h); sfx 0Bh.
SetPlungeTargetBelowPlayer:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@setTarget
    mov byte ptr ds:[SfxRequest], 0Bh
@@setTarget:
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
    jne @@arrived
    jmp near ptr ScrollRecordThenFinish
@@arrived:
    cmp word ptr ss:[bp + REC_SAVED_X], 0
    je @@targetRightEdge
    mov word ptr ss:[bp + REC_SAVED_X], 0
    jmp near ptr ScrollRecordThenFinish
@@targetRightEdge:
    mov word ptr ss:[bp + REC_SAVED_X], 0C0h
    jmp near ptr ScrollRecordThenFinish
; Fires when FrameCount16 is 15 (every 4 frames on level 5).
Type30AnimatedShooter:
    cmp word ptr ds:[LevelIndex], 5
    jne @@animate
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    sub ax, ss:[bp + REC_X]
    jns @@checkDistance
    neg ax
@@checkDistance:
    cmp ax, 0Ch
    jb @@animate
    cmp word ptr ss:[bp + REC_SPRITE], 46h
    jne @@animate
    jmp near ptr ScrollRecordThenFinish
@@animate:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 44h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 5
    jne @@level16Gate
    cmp word ptr ds:[FrameCount4], 3
    jmp short @@checkFire
@@level16Gate:
    cmp word ptr ds:[FrameCount16], 0Fh
@@checkFire:
    je @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
    call SpawnThrottledChild
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 0Eh
@@done:
    jmp near ptr ScrollRecordThenFinish
; Falls 3 px per frame.
Type31FallFast3:
    mov word ptr ss:[bp + REC_SPRITE], 2Eh
    add word ptr ss:[bp + REC_Y], 3
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly 90h, then becomes type 33h heading up-left.
Type32DescendThenBounce:
    mov word ptr ss:[bp + REC_SPRITE], 24h
DescendUntilBounceRowTail:
    cmp word ptr ss:[bp + REC_Y], 90h
    je @@startBounce
    jmp near ptr ScrollRecordThenFinish
@@startBounce:
    mov word ptr ss:[bp + REC_TYPE], 33h
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
; Three terrain steps per frame on a diagonal, reflecting on a blocked step.
Type33TerrainBouncer:
    call TryTerrainStep
    jne @@reflect
    call TryTerrainStep
    jne @@reflect
    call TryTerrainStep
    jne @@reflect
    jmp near ptr ScrollRecordThenFinish
@@reflect:
    xor word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp near ptr ScrollRecordThenFinish
; Fires sideways with sfx 13h from FrameCount64 32h on; levels 0 and 6 wait until Y 50h.
Type34SideFiringTurret:
    mov bx, ds:[LevelIndex]
    shl bx, 1
    mov bx, ds:[bx + Type34SpriteByLevel]
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    jae @@rightSide
    dec word ptr ss:[bp + REC_SPRITE]
    cmp word ptr ds:[LevelIndex], 6
    je @@leftWaitRow
    cmp word ptr ds:[LevelIndex], 0
    jne @@leftCheckFrame
@@leftWaitRow:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae @@leftCheckFrame
    jmp near ptr ScrollRecordThenFinish
@@leftCheckFrame:
    cmp word ptr ds:[FrameCount64], 32h
    jae @@leftFire
    jmp near ptr ScrollRecordThenFinish
@@leftFire:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@leftAim
    mov byte ptr ds:[SfxRequest], 13h
@@leftAim:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    cmp word ptr ds:[CountGate2324], 1
    je @@fireShot
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_RIGHT
    jmp short @@fireShot
@@rightSide:
    cmp word ptr ds:[LevelIndex], 6
    je @@rightWaitRow
    cmp word ptr ds:[LevelIndex], 0
    jne @@rightCheckFrame
@@rightWaitRow:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae @@rightCheckFrame
    jmp near ptr ScrollRecordThenFinish
@@rightCheckFrame:
    cmp word ptr ds:[FrameCount64], 32h
    jae @@rightFire
    jmp near ptr ScrollRecordThenFinish
@@rightFire:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@rightAim
    mov byte ptr ds:[SfxRequest], 13h
@@rightAim:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    cmp word ptr ds:[CountGate2324], 1
    je @@fireShot
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
@@fireShot:
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
; Bounces between Y 8 and 90h at an X-dependent speed and fires at each turn.
Type37VerticalBouncerShooter:
    mov ax, ds:[SlowCount4]
    add ax, 0B5h
    mov ss:[bp + REC_SPRITE], ax
    mov word ptr ds:[Type37Speed], 1
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    je @@moveVertically
    mov word ptr ds:[Type37Speed], 3
    cmp word ptr ss:[bp + REC_X], 50h
    je @@moveVertically
    cmp word ptr ss:[bp + REC_X], 70h
    je @@moveVertically
    mov word ptr ds:[Type37Speed], 5
@@moveVertically:
    mov ax, ds:[Type37Speed]
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je @@moveDown
    neg ax
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 8
    jna @@turnDownAtTop
    jmp near ptr ScrollRecordThenFinish
@@turnDownAtTop:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
@@moveDown:
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 90h
    jae @@turnUpAtBottom
    jmp near ptr ScrollRecordThenFinish
@@turnUpAtBottom:
    call SpawnThrottledChild
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    jmp near ptr ScrollRecordThenFinish
; Terrain patrol firing down every 64 frames.
Type83PatrolShootDown64:
    mov ax, ds:[SlowCount4]
    add ax, 10h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount64], 3Fh
    jne @@patrol
    call SpawnShotDown
@@patrol:
    jmp near ptr HorizontalTerrainPatrol
; Descends diagonally, turning at X 0 and C0h.
Type38WallBounceDescend:
    mov ax, 3
    cmp word ptr ss:[bp + REC_X], 0
    je @@setDirection
    mov ax, 5
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    je @@setDirection
    mov ax, ss:[bp + REC_DIRECTION]
@@setDirection:
    mov ss:[bp + REC_DIRECTION], ax
    mov word ptr ss:[bp + REC_SPRITE], 6Eh
    call MoveInDirection2
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 80h, then dashes right 4 px per frame and is destroyed past X C0h.
Type39DashRightAtRow80:
    mov word ptr ss:[bp + REC_SPRITE], 6Eh
    cmp word ptr ss:[bp + REC_Y], 80h
    jl @@done
    jne @@dashRight
    cmp byte ptr ds:[SfxEnabled], 0
    je @@dashRight
    mov byte ptr ds:[SfxRequest], 0Bh
@@dashRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    call MoveInDirection4
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    ja @@pastRightEdge
    jmp near ptr ScrollRecordThenFinish
@@pastRightEdge:
    call DestroyRecord
@@done:
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
    jnl @@homeOnPlayer
    jmp near ptr ScrollRecordThenFinish
@@homeOnPlayer:
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
    je @@altSpriteBase
    cmp word ptr ds:[LevelIndex], 0
    jne @@setSprite
@@altSpriteBase:
    mov cx, 152h
@@setSprite:
    add bx, cx
    mov ss:[bp + REC_SPRITE], bx
    add word ptr ss:[bp + REC_Y], 2
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly B0h, then becomes type 3Dh heading up-left.
Type3CDescendThenBounceAlt:
    mov word ptr ss:[bp + REC_SPRITE], 0C5h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je @@reachedBounceRow
    jmp near ptr ScrollRecordThenFinish
@@reachedBounceRow:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@becomeBouncer
    mov byte ptr ds:[SfxRequest], 1Dh
@@becomeBouncer:
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
    jnl @@aimAndDash
    jmp near ptr ScrollRecordThenFinish
@@aimAndDash:
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
    je JitterThenFireBelow80
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0A1h
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ds:[LevelIndex], 5
    je JitterThenFireBelow80
    mov bx, ds:[SlowCount4]
    shl bx, 1
@@otherLevelSprite:
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 100h
    mov ss:[bp + REC_SPRITE], bx
    jmp short JitterThenFireBelow80
; Jitters one random axis by 1 px; below Y 80h falls 2 px per frame and fires every 32
; frames.
Type40JitterFallShooter:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
JitterThenFireBelow80:
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
    jnl @@fallAndFire
    jmp near ptr ScrollRecordThenFinish
@@fallAndFire:
    cmp word ptr ds:[FrameCount32], 1Fh
    jne @@fall
    call SpawnThrottledChild
@@fall:
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
    jne @@setSprite
    mov bx, 178h
@@setSprite:
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
    jng @@dropBack
    jmp near ptr ScrollRecordThenFinish
@@dropBack:
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
    ja @@swayRight
    dec word ptr ss:[bp + REC_X]
    jmp near ptr ScrollRecordThenFinish
@@swayRight:
    inc word ptr ss:[bp + REC_X]
    jmp near ptr ScrollRecordThenFinish
; Type 89h with sprite base 9Dh.
Type8APatrolShootDown32Alt:
    mov ax, ds:[SlowCount4]
    add ax, 9Dh
    jmp near ptr PatrolSpriteShootDown32
; Above Y 60h fires down every 128 frames; below falls 4 px per frame.
Type46HoverShootThenDive:
    mov ax, ds:[SlowCount6]
    add ax, 4Bh
    jmp near ptr HoverFirePlungeTail
; Terrain patrol firing down every 32 frames.
Type47PatrolDropShooter:
    mov ax, ds:[SlowCount6]
    add ax, 51h
    jmp near ptr PatrolSpriteShootDown32
; Falls 2 px per frame; every 16 frames fires up to eight type 4 shots in all
; directions.
Type49RadialBurstFaller:
    mov ax, 1Dh
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ds:[FrameCount16], 0Fh
    je @@burst
    jmp near ptr ScrollRecordThenFinish
@@burst:
    mov cx, 8
@@nextShot:
    push cx
    call SpawnAimedShot
    pop cx
    cmp bx, -1
    jne @@setShotDirection
    jmp near ptr ScrollRecordThenFinish
@@setShotDirection:
    mov word ptr ds:[bx + REC_TYPE], 4
    dec cx
    mov ds:[bx + REC_DIRECTION], cx
    inc cx
    loop @@nextShot
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly 40h, then becomes type 33h heading up-right.
Type4BDescendThenBounceUpRight:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 0CFh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_Y], 40h
    je @@becomeBouncer
    jmp near ptr ScrollRecordThenFinish
@@becomeBouncer:
    mov word ptr ss:[bp + REC_TYPE], 33h
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
    jmp near ptr Type33TerrainBouncer
; Scrolls to Y B0h, then rises 4 px per frame without scrolling.
Type4CSinkThenRise:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP
    je @@rise
    mov word ptr ss:[bp + REC_SPRITE], 74h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je @@turnUp
    jmp near ptr ScrollRecordThenFinish
@@turnUp:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
@@rise:
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
    jne @@rise
    cmp word ptr ss:[bp + REC_Y], 80h
    je @@turnUp
    jmp near ptr ScrollRecordThenFinish
@@turnUp:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
@@rise:
    sub word ptr ss:[bp + REC_Y], 4
    cmp word ptr ss:[bp + REC_Y], 60h
    je @@startDash
    jmp near ptr FinishRecordUpdate
@@startDash:
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
    jmp near ptr DescendUntilBounceRowTail
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
    jae @@destroy
    jmp near ptr FinishRecordUpdate
@@destroy:
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
Type21LeaderPath:
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
    je @@done
    call CheckCheatRemindMe
    call CheckCheatEveryDayIDie
    call CheckCheatWhatOilShortage
    call CheckCheatLifeInTheFastLane
    call CheckCheatBonusCheatOn
    call CheckCheatMyNameIsSmith
    call CheckCheatSchnellfeuer
    mov byte ptr ds:[KeyLastMakeCode], 0
@@done:
    retf

CheckCheatWhatOilShortage:
    mov bx, offset CheatWhatOilShortage
    call MatchCheatKey
    jne @@done
    mov byte ptr ds:[WhatOilShortageFlag], 1
@@done:
    ret

CheckCheatLifeInTheFastLane:
    mov bx, offset CheatLifeInTheFastLane
    call MatchCheatKey
    jne @@done
    mov byte ptr ds:[KeepLivesFlag], 1
@@done:
    ret

CheckCheatBonusCheatOn:
    mov bx, offset CheatBonusCheatOn
    call MatchCheatKey
    jne @@done
    mov byte ptr ds:[BonusKeysEnabled], 1
@@done:
    ret

CheckCheatMyNameIsSmith:
    mov bx, offset CheatMyNameIsSmith
    call MatchCheatKey
    jne @@done
    mov byte ptr ds:[LevelSkipEnabled], 1
@@done:
    ret

CheckCheatSchnellfeuer:
    mov bx, offset CheatGibStMirSchnellfeuer
    call MatchCheatKey
    jne @@done
    mov byte ptr ds:[RapidFireEnabled], 1
@@done:
    ret

; Sets all five cheat flags and AllCheatsFlag.
CheckCheatRemindMe:
    mov bx, offset CheatRemindMe
    call MatchCheatKey
    jne @@done
    mov byte ptr ds:[WhatOilShortageFlag], 1
    mov byte ptr ds:[KeepLivesFlag], 1
    mov byte ptr ds:[BonusKeysEnabled], 1
    mov byte ptr ds:[LevelSkipEnabled], 1
    mov byte ptr ds:[RapidFireEnabled], 1
    mov byte ptr ds:[AllCheatsFlag], 1
@@done:
    ret

; Clears all five cheat flags and AllCheatsFlag.
CheckCheatEveryDayIDie:
    mov bx, offset CheatEveryDayIDie
    call MatchCheatKey
    jne @@done
    mov byte ptr ds:[WhatOilShortageFlag], 0
    mov byte ptr ds:[KeepLivesFlag], 0
    mov byte ptr ds:[BonusKeysEnabled], 0
    mov byte ptr ds:[LevelSkipEnabled], 0
    mov byte ptr ds:[RapidFireEnabled], 0
    mov byte ptr ds:[AllCheatsFlag], 0
@@done:
    ret

; BX = cheat entry. On a match advance its cursor; ZF = 1 when that was the last
; scancode (then BiosBeep runs through the far bridge). A mismatch resets the cursor
; without retrying the key.
MatchCheatKey:
    mov di, word ptr ds:[bx]
    mov al, byte ptr ds:[KeyLastMakeCode]
    cmp al, byte ptr ds:[di]
    jne @@resetCursor
    inc word ptr ds:[bx]
    cmp byte ptr ds:[di + 1], 0
    jne @@done
    mov bp, offset BiosBeep
    call far ptr FarCallMainNearViaBP
    jmp short @@done
@@resetCursor:
    mov word ptr ds:[bx], bx
    add word ptr ds:[bx], 2
@@done:
    ret

; With a GroupDropKind: GroupSlotPtr/GroupSlotIndex = the first empty GroupTable entry;
; otherwise, or when full, GroupSlotPtr = FFFFh (GroupSlotIndex is then stale).
AllocGroupSlot:
    push bx
    push cx
    cmp word ptr ds:[GroupDropKind], 0
    je @@noSlot
    mov cx, 010h
    mov word ptr ds:[GroupSlotIndex], 0
    mov bx, offset GroupTable
@@scanSlot:
    cmp byte ptr ds:[bx + GROUP_LIVE], 0
    je @@storeSlot
    add bx, 2
    inc word ptr ds:[GroupSlotIndex]
    loop @@scanSlot
@@noSlot:
    mov bx, 0FFFFh
@@storeSlot:
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
    jb @@done
    mov ah, DOS_ALLOC_STRATEGY
    mov al, 0
    int 021h
    mov word ptr ds:[SavedAllocStrategy], ax
    mov ah, DOS_ALLOC_STRATEGY
    mov al, 1
    mov bx, 1
    int 021h
@@done:
    retf

RestoreAllocStrategy:
    mov ah, DOS_GET_VERSION
    xor al, al
    int 021h
    cmp al, 3
    jb @@done
    mov ah, DOS_ALLOC_STRATEGY
    mov al, 1
    mov bx, word ptr ds:[SavedAllocStrategy]
    int 021h
@@done:
    retf
; Far body of Type48CreeperAimedFire: sprite by level (level 5 also drifts toward the
; player), REC_Y + 1.
Type48CreeperBody:
    cmp word ptr ds:[LevelIndex], 5
    je @@driftTowardPlayer
    mov ax, 1Ch
    cmp word ptr ds:[LevelIndex], 3
    je @@setSpriteAndDescend
    mov ax, ds:[FrameCount8]
    shr ax, 1
    add ax, 22h
    jmp short @@setSpriteAndDescend
@@driftTowardPlayer:
    mov cx, 1
    mov ax, ss:[bp + REC_X]
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jb @@applyDrift
    pushf
    neg cx
    popf
    ja @@applyDrift
    xor cx, cx
@@applyDrift:
    add ss:[bp + REC_X], cx
    mov bx, ds:[SlowCount8]
    and bx, -2
    mov ax, ds:[bx + PingPongFrames4]
    add ax, 26h
@@setSpriteAndDescend:
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
@@rescan:
    mov di, offset KeyDownTable - 1
    mov cx, KEY_DOWN_COUNT
    xor al, al
@@orNextKey:
    inc di
    or al, byte ptr ds:[di]
    loop @@orNextKey
    jne @@rescan
    pop di
    pop cx
    pop ax
    retf
Type7BDropThenAimBody:
    mov word ptr ss:[bp + REC_SPRITE], 15Ch
    cmp word ptr ss:[bp + REC_Y], 90h
    jl @@done
    mov word ptr ss:[bp + REC_TYPE], 7Ch
    mov bx, bp
    mov ax, offset AimAtPlayer
    call far ptr FarCallMainNearViaAX
@@done:
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
    jne @@arrived
    jmp near ptr @@setSprite
@@arrived:
    cmp word ptr ss:[bp + REC_TYPE], 013h
    jne @@checkType15
    jmp near ptr @@type13
@@checkType15:
    cmp word ptr ss:[bp + REC_TYPE], 015h
    jne @@checkType1C
    jmp near ptr @@type15
@@checkType1C:
    cmp word ptr ss:[bp + REC_TYPE], 01Ch
    jne @@checkType1F
    jmp near ptr @@type1C
@@checkType1F:
    cmp word ptr ss:[bp + REC_TYPE], 01Fh
    jne @@checkType7D
    jmp near ptr @@type1F
@@checkType7D:
    cmp word ptr ss:[bp + REC_TYPE], 07Dh
    je @@type7D
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    jne @@spawnMarcher
    jmp near ptr @@setSprite
@@spawnMarcher:
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne @@initMarcher
    jmp near ptr @@setSprite
@@initMarcher:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 07Fh
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 5
    inc word ptr ds:[EncounterLiveCount]
    jmp near ptr @@setSprite
@@type7D:
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    jne @@spawnSweeper
    jmp near ptr @@setSprite
@@spawnSweeper:
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne @@initSweeper
    jmp near ptr @@setSprite
@@initSweeper:
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
    je @@setSweeperType
    mov word ptr ds:[bx + REC_DIRECTION], DIR_LEFT
@@setSweeperType:
    mov word ptr ds:[bx + REC_TYPE], 081h
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 019h
    mov word ptr ds:[bx + REC_HIT_POINTS], 5
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    mov word ptr ds:[bx + REC_BLOCKED_CLIMBS], 0
    inc word ptr ds:[EncounterLiveCount]
    jmp near ptr @@setSprite
@@type1F:
    add word ptr ds:[LeaderScriptCursor], 4
    mov cx, 5
@@spawnWingman:
    push cx
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    mov si, word ptr ds:[FormationSlotCursor]
    add word ptr ds:[FormationSlotCursor], 4
    cmp bx, -1
    je @@nextWingman
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 020h
    mov word ptr ds:[bx + REC_DIVE_PHASE], 0FFFFh
    inc word ptr ds:[EncounterLiveCount]
@@nextWingman:
    pop cx
    loop @@spawnWingman
    jmp near ptr @@setSprite
@@type1C:
    add word ptr ds:[LeaderScriptCursor], 8
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    jne @@initFollower1D
    jmp near ptr @@setSprite
@@initFollower1D:
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 01Dh
    cmp word ptr ss:[bp + REC_X], 0
    jne @@setFollowerDelay
    mov word ptr ds:[bx + REC_TYPE], 01Eh
    mov word ptr ds:[bx + REC_SPRITE], 043h
@@setFollowerDelay:
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 014h
    inc word ptr ds:[EncounterLiveCount]
    jmp short @@setSprite
@@type15:
    add word ptr ds:[LeaderScriptCursor], 8
    cmp word ptr ds:[si], -1
    je @@setSprite
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je @@setSprite
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 016h
    mov word ptr ds:[bx + REC_PATH], offset SweepPath
    cmp word ptr ss:[bp + REC_Y], 040h
    je @@setPathFollowerDelay
    mov word ptr ds:[bx + REC_TYPE], 017h
    mov word ptr ds:[bx + REC_PATH], offset SweepPathLeadIn
@@setPathFollowerDelay:
    mov word ptr ds:[bx + REC_ENTRY_DELAY], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 3
    inc word ptr ds:[EncounterLiveCount]
    jmp short @@setSprite
@@type13:
    add word ptr ds:[LeaderScriptCursor], 4
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je @@setSprite
    inc word ptr ds:[EncounterLiveCount]
@@setSprite:
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
    je @@done
    mov word ptr ss:[bp + REC_TYPE], 093h
@@done:
    retf
Type93SweepBody:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript7DEnd
    je @@checkEntryDelay
    jmp near ptr @@checkDiveRow
@@checkEntryDelay:
    cmp word ptr ss:[bp + REC_ENTRY_DELAY], 0
    je @@entryDone
    dec word ptr ss:[bp + REC_ENTRY_DELAY]
    je @@entryDone
    jmp near ptr @@checkDiveRow
@@entryDone:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP
    je @@climb
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
    je @@climb
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
    je @@climb
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jne @@sweep
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@turnUp
    cmp word ptr ss:[bp + REC_Y], 0D0h
    jae @@turnUp
    jmp near ptr @@done
@@turnUp:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
@@climb:
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    je @@climbStep2
    call Type93BlockedTurnUp
@@climbStep2:
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    je @@climbStep3
    call Type93BlockedTurnUp
@@climbStep3:
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    je @@checkClimbFree
    call Type93BlockedTurnUp
@@checkClimbFree:
    jne @@checkTopRow
    mov word ptr ss:[bp + REC_BLOCKED_CLIMBS], 0
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
@@checkTopRow:
    cmp word ptr ss:[bp + REC_Y], 020h
    jbe @@turnSideways
    jmp near ptr @@done
@@turnSideways:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    test word ptr ss:[bp + REC_X], 2
    je @@sweep
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
@@sweep:
    mov ax, word ptr ds:[FrameCount16]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    add ax, 016Ah
    mov word ptr ss:[bp + REC_SPRITE], ax
    cmp byte ptr ds:[Type93KilledPulse], 0
    je @@checkBombTimer
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
@@checkBombTimer:
    mov ax, word ptr ds:[RecordTickCounter]
    and ax, 0FFh
    cmp ax, 0FFh
    jne @@checkAimedShotTimer
    mov ax, offset SpawnShotDown
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[RecordTickCounter]
@@checkAimedShotTimer:
    cmp word ptr ds:[RecordTickCounter], 0
    je @@fireAimedShot
    cmp word ptr ds:[RecordTickCounter], 02BDh
    jne @@checkEdges
@@fireAimedShot:
    mov ax, offset SpawnAimedShot
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[RecordTickCounter]
@@checkEdges:
    cmp word ptr ss:[bp + REC_X], 0
    je @@atLeftEdge
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    je @@atRightEdge
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    je @@goLeft
    jmp near ptr @@stepRight
@@goLeft:
    jmp short @@stepLeft
@@atRightEdge:
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
@@stepLeft:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseRight
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseRight
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseRight
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseRight
    jmp short @@checkDiveRow
@@reverseRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp short @@checkDiveRow
@@atLeftEdge:
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
@@stepRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseLeft
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseLeft
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseLeft
    mov ax, offset TryTerrainStep
    call far ptr FarCallMainNearViaAX
    jne @@reverseLeft
    jmp short @@checkDiveRow
@@reverseLeft:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
@@checkDiveRow:
    cmp word ptr ss:[bp + REC_Y], 080h
    jb @@done
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
@@done:
    retf
; BP = type 93h: counts a blocked climb (REC_BLOCKED_CLIMBS) and turns diagonally up toward
; the centre.
Type93BlockedTurnUp:
    inc word ptr ss:[bp + REC_BLOCKED_CLIMBS]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    ja @@done
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
@@done:
    ret
Type7FMarchEnterBody:
    mov word ptr ss:[bp + REC_SPRITE], 162h
    mov word ptr ds:[SteerSpeed], 1
    mov ax, offset SteerToSaved
    call far ptr FarCallMainNearViaAX
    je @@done
    mov word ptr ss:[bp + REC_TYPE], 80h
@@done:
    retf
Type80MarchMemberBody:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript7EEnd
    je @@checkEntryDelay
    jmp near ptr @@done
@@checkEntryDelay:
    cmp word ptr ss:[bp + REC_ENTRY_DELAY], 0
    je @@entryDone
    dec word ptr ss:[bp + REC_ENTRY_DELAY]
    je @@entryDone
    jmp near ptr @@done
@@entryDone:
    cmp byte ptr ds:[MarchStepNow], 0
    je @@checkDiving
    mov ax, ds:[MarchStepX]
    add ss:[bp + REC_SAVED_X], ax
@@checkDiving:
    mov ax, ss:[bp + REC_SPRITE]
    cmp ax, 164h
    jb @@checkDiveStart
    jmp near ptr @@diving
@@checkDiveStart:
    mov ax, ds:[RecordTickCounter]
    and ax, 0FFh
    cmp ax, 7Dh
    je @@startDive
    or ax, ax
    jne @@checkFire
@@startDive:
    inc word ptr ds:[RecordTickCounter]
    mov word ptr ss:[bp + REC_SPRITE], 164h
    mov word ptr ss:[bp + REC_HIT_POINTS], 3
    jmp near ptr @@done
@@checkFire:
    cmp byte ptr ds:[MarchFireNow], 0
    je @@marchStep
    mov byte ptr ds:[MarchFireNow], 0
    mov ax, offset SpawnAimedShot
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[RecordTickCounter]
@@marchStep:
    cmp byte ptr ds:[MarchStepNow], 0
    je @@checkInSlot
    mov ax, ds:[MarchStepX]
    add ss:[bp + REC_X], ax
    cmp word ptr ss:[bp + REC_X], 0
    je @@edgeHit
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    jne @@checkInSlot
@@edgeHit:
    inc byte ptr ds:[MarchEdgeHit]
@@checkInSlot:
    mov ax, ss:[bp + REC_SAVED_Y]
    cmp ax, ss:[bp + REC_Y]
    je @@inSlot
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
    jne @@nextSteerFrame
    jmp near ptr @@done
@@nextSteerFrame:
    inc word ptr ss:[bp + REC_SPRITE]
    jmp near ptr @@done
@@inSlot:
    cmp byte ptr ds:[MarchDropNow], 0
    je @@setMarchSprite
    add word ptr ss:[bp + REC_Y], 0Ch
    add word ptr ss:[bp + REC_SAVED_Y], 0Ch
    cmp word ptr ss:[bp + REC_Y], 0B0h
    jb @@setMarchSprite
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
@@setMarchSprite:
    mov ax, ss:[bp + REC_X]
    shr ax, 1
    and ax, 1
    add ax, 162h
    mov ss:[bp + REC_SPRITE], ax
    jmp short @@done
@@diving:
    cmp byte ptr ds:[MarchDropNow], 0
    je @@checkDiveAnim
    add word ptr ss:[bp + REC_SAVED_Y], 0Ch
    cmp word ptr ss:[bp + REC_SAVED_Y], 0B0h
    jb @@checkDiveAnim
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
@@checkDiveAnim:
    cmp ax, 168h
    jae @@diveDown
    cmp word ptr ds:[FrameCount4], 3
    jne @@done
    inc word ptr ss:[bp + REC_SPRITE]
    jmp short @@done
@@diveDown:
    add word ptr ss:[bp + REC_Y], 5
    mov word ptr ss:[bp + REC_SPRITE], 168h
    mov ax, ds:[FrameCount8]
    shr ax, 1
    shr ax, 1
    je @@checkOffBottom
    inc word ptr ss:[bp + REC_SPRITE]
@@checkOffBottom:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jna @@done
    mov word ptr ss:[bp + REC_Y], 0
    cmp word ptr ds:[FrameCount4], 3
    je @@rejoinFormation
@@pickRandomX:
    mov ax, offset NextRandomWord
    call far ptr FarCallMainNearViaAX
    cmp bl, 0C0h
    ja @@pickRandomX
    xor bh, bh
    mov ss:[bp + REC_X], bx
    jmp short @@done
@@rejoinFormation:
    mov word ptr ss:[bp + REC_SPRITE], 160h
    mov word ptr ss:[bp + REC_HIT_POINTS], 5
@@done:
    retf
FAR0F7F ends
end