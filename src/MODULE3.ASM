; Link module 3: program entry, main loop (boundaries from the relocation order).
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
extrn AutoMoveExtraRecord:word
extrn AutopilotWaypointA:word
extrn AutopilotWaypointB:word
extrn BeamList:word
extrn BeamListEnd:word
extrn BeamListTerminator:word
extrn BonusIntroItems:byte
extrn BonusKeysEnabled:byte
extrn BossPartOffsets:word
extrn BossPath:word
extrn BurstOriginX:word
extrn BurstOriginY:word
extrn ByteAttributeTable:byte
extrn ChaseStepPixels:word
extrn CheckCheatCodes:far
extrn ChildSpawnThrottle:byte
extrn ChooseSlot:word
extrn ChooseSlotPositions:word
extrn ClampXHighSeen:byte
extrn ClampXLowSeen:byte
extrn ClearWorkspaceHalfOnly:word
extrn Codeword:byte
extrn CorruptMsgHead:byte
extrn CorruptMsgPressKey:byte
extrn CorruptMsgTail:byte
extrn CountGate2324:word
extrn CreditRandomWords:byte
extrn CurrentSidePodSlot:word
extrn CurrentTrailingPodSlot:word
extrn DacColor6Default:byte
extrn DacColor6Level1:byte
extrn DebugCodewordLine:byte
extrn DebugNonAsciiCodewordLine:byte
extrn DebugOldNonAsciiCodewordLine:byte
extrn DebugPasswordLine:byte
extrn DemoActive:word
extrn DemoFireCycle:word
extrn DemoScript:word
extrn DemoStep:word
extrn DemoStepTimer:word
extrn DemoUpgradeStatus:word
extrn DescentTargetX:word
extrn DifficultyPositions:word
extrn DifficultySetting:word
extrn DirectionFromQuadrant:byte
extrn DispatchRecordX:word
extrn DispatchRecordY:word
extrn DriveAPresent:byte
extrn DriveBPresent:byte
extrn DropKind:word
extrn DropX:word
extrn DropY:word
extrn EasyHitToggle:byte
extrn EmsAvailable:byte
extrn EmsDeviceName:byte
extrn EmsFreePages:word
extrn EmsPageFrame:word
extrn EmsTotalPages:word
extrn EncounterEndDelay:word
extrn EncounterLiveCount:word
extrn EncounterTicks:word
extrn EnergyPoints:word
extrn EnergyTanks:word
extrn ExhaustFrames:byte
extrn ExhaustOffsets:word
extrn FallerColumnCursor:word
extrn FallerColumns:word
extrn FallerColumnsEnd:word
extrn FallerVariants:word
extrn FallerVariantsAlt:word
extrn FarCallMainNearViaAX:far
extrn FileBufferOffset:word
extrn FileBufferSegment:word
extrn FileByteCount:word
extrn FileCache:byte
extrn FileCacheEnd:word
extrn FileHandle:word
extrn FileNamePtr:word
extrn FileStatus:word
extrn File_CHOOSE_ENC:byte
extrn File_LEVSCR_ENC:byte
extrn File_WINDOW_BIC:byte
extrn FireLatch:word
extrn FormationSlotCursor:word
extrn FormationSlots:word
extrn FormationSlotsEnd:word
extrn FrameCount128:word
extrn FrameCount16:word
extrn FrameCount32:word
extrn FrameCount4:word
extrn FrameCount64:word
extrn FrameCount8:word
extrn FramesSinceInvaderSpawn:word
extrn FrontPodOffsets:word
extrn FrontPodRecord:word
extrn Fuel:word
extrn GameOverRequest:word
extrn GridYSum:word
extrn GroupTable:byte
extrn HistoryCursor47:word
extrn HistoryEnd:word
extrn HistoryPairs:byte
extrn HistoryReadCursor15:word
extrn HistoryReadCursor31:word
extrn HistoryWriteCursor:word
extrn ImageEnd:byte
extrn InputBits:byte
extrn InstallCriticalErrorVector:far
extrn IntegrityFileData:byte
extrn IntegrityFileExe:byte
extrn InvaderDropStep:word
extrn InvaderFormation:word
extrn InvaderFormationEnd:word
extrn InvaderMarchLeft:word
extrn InvaderNextDropStep:word
extrn InvaderNextMarchLeft:word
extrn InvaderSlotCursor:word
extrn KeepLivesFlag:byte
extrn KeyDownTable:byte
extrn KeyLastMakeCode:byte
extrn LastTileStepBackward:word
extrn LeaderScript13End:word
extrn LeaderScript15End:word
extrn LeaderScript1CEnd:word
extrn LeaderScript1FEnd:word
extrn LeaderScript7DEnd:word
extrn LeaderScript7EEnd:word
extrn LeaderScriptCursor:word
extrn LevelEndPhase:word
extrn LevelIndex:word
extrn LevelScriptClock:word
extrn LevelSkipEnabled:byte
extrn LifeLostRequest:word
extrn LivesLeft:word
extrn LoadIsEnc:byte
extrn LoadWordBB82:word
extrn MapRowCursor:word
extrn MapScrollPos:word
extrn MarchDelay:byte
extrn MarchDropNow:byte
extrn MarchEdgeHit:byte
extrn MarchFireDelay:byte
extrn MarchFireNow:byte
extrn MarchStepNow:byte
extrn MarchStepX:word
extrn MarchWord98AC:word
extrn MissileAmmo:word
extrn MissilesLive:word
extrn ModuleSoundEnabled:byte
extrn ModuleSoundRequest:byte
extrn MsgDeallocError:byte
extrn MuzzleOffsets:word
extrn NextLevelRequest:word
extrn NonAsciiCodeword:byte
extrn OffsetXWork:word
extrn OldNonAsciiCodeword:byte
extrn OpenResourceFile:far
extrn PageIndex:word
extrn PageListPtr:word
extrn Password:byte
extrn PathType66:word
extrn PathType67:word
extrn PaymentFileName:byte
extrn PaymentHelpRow:word
extrn PingPongFrames4:word
extrn PingPongFrames8:word
extrn PlayerHitOffsets:word
extrn PodShotDirection:word
extrn PoolA:byte
extrn PoolAEnd:byte
extrn PoolAPointers:word
extrn PoolASaveBuffers:byte
extrn PoolBPointers:word
extrn PoolBSaveBuffers:byte
extrn PrimaryRecord:byte
extrn QuitAnswer:byte
extrn RandomWordCursor:word
extrn RapidFireEnabled:byte
extrn RecordTickCounter:word
extrn RefuelActive:word
extrn ResLibSetup:far
extrn ResidentFiles:word
extrn ResourceArchiveList:byte
extrn RevealCellOffset:word
extrn RevealCol:byte
extrn RevealColumns:word
extrn RevealRectPtr:word
extrn RevealRectsLeft:word
extrn RevealRow:byte
extrn ScoreBcd:byte
extrn ScrollDeltaY:word
extrn ScrollSubRow:word
extrn ScrollWindowOffset:word
extrn ScrollingBackward:word
extrn SegBossActive:word
extrn SegBossAnchor:word
extrn SegBossCore:word
extrn SegBossPart77:word
extrn SegBossPart79:word
extrn SegBossPathCursor:word
extrn SegBossX:word
extrn SegBossY:word
extrn SelectedUpgradeSlot:word
extrn SequenceFrameCount:word
extrn SetBestFitAllocStrategy:far
extrn SfxActive:byte
extrn SfxCommandTable:word
extrn SfxEffectTable:word
extrn SfxEnabled:byte
extrn SfxNoteDivisors:word
extrn SfxRequest:byte
extrn SfxTickPhase:byte
extrn SfxVoiceA:byte
extrn SfxVoiceB:byte
extrn ShotsAtFireBeam:word
extrn ShotsAtFireFrontPod:word
extrn ShotsAtFireMain:word
extrn ShotsAtFireSide:word
extrn ShotsLiveFrontPod:word
extrn ShotsLiveMain:word
extrn ShotsLiveSide:word
extrn ShotsLiveType9:word
extrn ShowPageList:far
extrn SidePodLeftInner:word
extrn SidePodLeftOuter:word
extrn SidePodOffsetsLeftInner:word
extrn SidePodOffsetsLeftOuter:word
extrn SidePodOffsetsRightInner:word
extrn SidePodOffsetsRightOuter:word
extrn SidePodRightInner:word
extrn SidePodRightOuter:word
extrn SidePodSlotPtr:word
extrn SidePodSpreadLeft:word
extrn SidePodSpreadRight:word
extrn SidePodsToAdd:word
extrn SideShotsEnabled:word
extrn SlowCount4:word
extrn SlowCount5:word
extrn SlowCount6:word
extrn SlowCount8:word
extrn SoundCardCaptionAdlib:byte
extrn SoundCardCaptionRoland:byte
extrn SoundCardCaptionTandy:byte
extrn SoundModuleInitEntry:far
extrn SoundModuleLoaded:byte
extrn SoundModuleNameAdlib:byte
extrn SoundModuleNamePtr:word
extrn SoundModuleNameRoland:byte
extrn SoundModuleNameTandy:byte
extrn SoundModuleSelect:byte
extrn SoundModuleSlot:far
extrn StackTop:word
extrn StarLayerTick1:word
extrn StarLayerTick2:word
extrn StarLayerTick3:word
extrn Stars:word
extrn StateData:byte
extrn SteerArrived:word
extrn SteerPath10:word
extrn SteerPath11:word
extrn SteerSpeed:word
extrn SteerTargetX:word
extrn SteerTargetY:word
extrn SwayDirX:word
extrn SwayDropY:word
extrn TargetSearchCursor:word
extrn TerrainBlocked:word
extrn TerrainProbeX:word
extrn TerrainProbeY:word
extrn TerrainStartX:word
extrn TerrainStartY:word
extrn TextInGraphics:word
extrn TimerTickPhase:byte
extrn TitleLogoPiecePtr:word
extrn TitleLogoPieces:byte
extrn TitleRevealRects:byte
extrn TrailingPodFar:word
extrn TrailingPodNear:word
extrn Type21Path:word
extrn Type53SpawnTable:word
extrn Type86Frames:word
extrn Type86FramesDir6:word
extrn Type88Frames:word
extrn Type88FramesDir6:word
extrn Type93KilledLatch:byte
extrn Type93KilledPulse:byte
extrn UpgradeHitX:word
extrn UpgradeHitY:word
extrn VideoBiosModeTable:byte
extrn WalkerFacingStep:word
extrn WeaponMode:word
extrn WhatOilShortageFlag:byte
extrn WinScreenPageList:word
extrn Word235A:word
extrn XAdjustPathTaken:word
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public AddFrontPod
public AddSidePods
public AddTrailingPod
public ApplyLevelPalette
public BlueBitsSegment
public DestroyRecord
public DrainFuelUnit
public FinishRecordUpdate
public HorizontalTerrainPatrol
public LevelBlocksSegment
public LevelMapSegment
public LevelSpritesSegment
public LoadAndShowPage
public LoadResourceFile
public MainDataSegment
public ManExplSegment
public MapResetList0
public MapResetList1
public MapResetList2
public MapResetList3
public MapResetList4
public MapResetList5
public MoveInDirection1
public MoveInDirection2
public MoveInDirection3
public MoveInDirection4
public MoveInDirection8
public PanelSegment
public PerFileFlagsEnabled
public PlaqueSegment
public PlayfieldRowBytes
public ReleaseEmsCache
public RemoveRecordAtBX
public RequestModuleMusic
public ResetMarchState
public ResetType21Path
public RunAttractSequence
public ScreenSegment
public ScrollBackwardOneLine
public ScrollBandBytes
public ScrollMirrorDistance
public ScrollRecordThenFinish
public ScrollStartOffset
public ScrollWrapOffset
public SfxCmdRest
public SfxCmdSlide
public SfxCmdStepDown
public SfxCmdStepUp
public SfxStopAll
public SfxStreamStoreAndWait
public SfxTimerTick
public ShipSegment
public ShotHitsRecord
public SpawnShotDown
public SpawnThrottledChild
public Sprites1x1Segment
public Sprites2x2CSegment
public Sprites2x2Segment
public StartPathFollow
public SteerToSaved
public StopModuleMusic
public TextVideoSegment
public TheEndSegment
public TryTerrainStep
public Type21LeaderPathBody
public VideoAdapter
public WaitVerticalRetracePulse
public WideRowBytes
public WorkspaceSegment
public loc_0B2AC
extrn AddScoreBcd:near
extrn AdvanceToAvailableUpgrade:near
extrn AimAtPlayer:near
extrn AllocPoolBRecordEvicting:near
extrn AllocRecordEvicting:near
extrn AllocateBuffers:near
extrn ApplySelectedUpgrade:near
extrn BlitPackedStride104:near
extrn BlitPackedStride160:near
extrn BlitPackedToScreen:near
extrn BlueBitsImageOffsets:word
extrn BuildByteToNibbleMaskTable:near
extrn BuildRowTables:near
extrn CgaColorMap:byte
extrn CgaSelectBrightPalette0:near
extrn CgaSelectBrightPalette1:near
extrn CgaSelectBrightPaletteNoBurst:near
extrn CheckBossKey:near
extrn ClearScreen104x200:near
extrn ClearTimerTick:near
extrn ClearWorkspace:near
extrn CollapseScreenAndClear:near
extrn CollapseScreenWithSfx:near
extrn ComputeRecordGridOffset:near
extrn CopyFullWorkspaceToScreen:near
extrn CopyWorkspaceToScreen:near
extrn CountXReturn:near
extrn DrawEnergyGauge:near
extrn DrawFuelGauge:near
extrn DrawHud:near
extrn DrawMapRowBlocks:near
extrn DrawOffsetFromPlayfieldRow:near
extrn DrawOffsetFromScreenRow:near
extrn DrawOffsetFromWideRow:near
extrn DrawRecordSprite:near
extrn DrawSprite8Record:near
extrn DrawStars:near
extrn DrawStatusPanel:near
extrn DrawUpgradeSlots:near
extrn EraseStars:near
extrn FindFreeRecordPoolA:near
extrn FindFreeRecordPoolB:near
extrn FlipEgaDrawPage:near
extrn FlushBiosKeyboardBuffer:near
extrn InitEnemyRecordHere:near
extrn InitStars:near
extrn InitUpgradeSlots:near
extrn InstallKeyboardVector09:near
extrn InstallTimerVector08:near
extrn LoadCommonGraphics:near
extrn LoadDestOffset:word
extrn LoadDestSegment:word
extrn LoadGraphicsRecordImages:near
extrn LoadHiscoreFile:near
extrn LoadImageSlot:word
extrn LoadLevelGraphics:near
extrn LoadLevelMap:near
extrn LoadNamePtr:word
extrn LoadPackedFile:near
extrn NextRandomWord:near
extrn PackedDestOffset:word
extrn PackedDestSegment:word
extrn PackedNamePtr:word
extrn PackedOutputBytes:word
extrn PanelImageOffsets:word
extrn PlaqueImageOffset:word
extrn PlayerShotsHitRecord:near
extrn PollInputBits:near
extrn PrintMessageBP:near
extrn ProbeShipTerrainCollision:near
extrn ReadIndexedByteAttribute:near
extrn RedrawStatusPanel:near
extrn RequestLifeStartMusic:near
extrn ResetEgaPages:near
extrn ResetPageAndClearScreen:near
extrn RestartAtCheckpoint:near
extrn RestoreRecordBackground:near
extrn RunLevelScriptEvents:near
extrn RunOptionsMenu:near
extrn SaveRecordBackground:near
extrn ScrollMapToLevelStart:near
extrn SetDeltaToward:near
extrn SetHiscoreRankColor:near
extrn SetMapTile1:near
extrn SetMapTile28:near
extrn ShowEgaDrawPage:near
extrn ShowFatalErrorAndExit:near
extrn SmartBombAll:near
extrn SpawnAimedShot:near
extrn SpawnEnemyHere:near
extrn SpawnEnemyHereQuiet:near
extrn SpawnFromMapRow:near
extrn SpawnItemDrop:near
extrn SteerTowardTarget:near
extrn StepAlongDelta:near
extrn StretchInHudPanel:near
extrn StretchInTheEndImage:near
extrn StretchInWindowImage:near
extrn TickFrameTimers:near
extrn TickRefuel:near
extrn Type13FormationLeader:near
extrn Type24TurretLeftFire32:near
extrn Type25TurretRightFire32:near
extrn Type26WallProbeExtender:near
extrn Type27SlowDescender:near
extrn Type28EnemyHatch:near
extrn Type29EmergeThenDart:near
extrn Type2BAimedDart:near
extrn Type2DHoverFireThenPlunge:near
extrn Type2EPlungeAtPlayerColumn:near
extrn Type2FScrollingShuttle:near
extrn Type30AnimatedShooter:near
extrn Type31FallFast3:near
extrn Type32DescendThenBounce:near
extrn Type33TerrainBouncer:near
extrn Type34SideFiringTurret:near
extrn Type37VerticalBouncerShooter:near
extrn Type38WallBounceDescend:near
extrn Type39DashRightAtRow80:near
extrn Type3AHomeOnPlayerBelow80:near
extrn Type3BFallRandomFlicker:near
extrn Type3CDescendThenBounceAlt:near
extrn Type3DAnimatedTerrainBouncer:near
extrn Type3EDropThenAimedDash:near
extrn Type3FStraightLineToAimPoint:near
extrn Type40JitterFallShooter:near
extrn Type41FollowPathType41:near
extrn Type42DescendSway:near
extrn Type43FollowPathType43:near
extrn Type44FollowPathType44:near
extrn Type45FollowPathType45:near
extrn Type46HoverShootThenDive:near
extrn Type47PatrolDropShooter:near
extrn Type48CreeperAimedFire:near
extrn Type49RadialBurstFaller:near
extrn Type4AFollowPathType4A:near
extrn Type4BDescendThenBounceUpRight:near
extrn Type4CSinkThenRise:near
extrn Type4DSinkRiseThenDash:near
extrn Type4EAnimDescendThenBounce:near
extrn Type4FFallFast4Flicker:near
extrn Type51FollowType51Path:near
extrn Type52ScrollOnly:near
extrn Type53AnimateFromField36:near
extrn Type60FlyAlongAimLine:near
extrn Type68JitterDescendFiring:near
extrn Type69JitterDropToY18:near
extrn Type71FireThenDiveBelow60:near
extrn Type7AAimLineFlyer:near
extrn Type7BDropThenAim:near
extrn Type7CAimLineFlyerAlt:near
extrn Type7FMarchEnterSteer:near
extrn Type80MarchFormationMember:near
extrn Type81SweeperEnterSteer:near
extrn Type83PatrolShootDown64:near
extrn Type8APatrolShootDown32Alt:near
extrn Type8FAnimFireBurstB:near
extrn Type90TurretVolley:near
extrn Type91TurretVolleyAlt:near
extrn Type93SweepDescendClimb:near
extrn UpdateHighScoreTable:near
extrn UpdateRefuelTimersAndScore:near
extrn WaitTimerTick:near
extrn WaitVerticalRetrace:near
extrn loc_05059:near
extrn loc_05D0B:near
extrn loc_08331:near
extrn loc_0878C:near
extrn loc_08D83:near
; Segment of the level map (LEVnMAP.BIC, loaded into SlotBuffer).
LevelMapSegment dw seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH
; Colour text-mode video segment, used when printing without graphics (TextInGraphics = 0).
TextVideoSegment dw 0B800h
; CS word holding the state segment (seg StateData); entry loads DS/SS from it.
MainDataSegment dw seg StateData
; Segments and geometry filled in at startup (AllocateBuffers, adapter geometry).
; 64 KiB general work buffer (the play workspace ring, screen images).
WorkspaceSegment dw 0
; Level block images (LEVnBLX.BIC) and SHIP.BIC.
LevelBlocksSegment dw 0
ShipSegment dw 0
; Row widths in bytes from the adapter geometry: the 208-pixel playfield and a full
; 320-pixel row (CGA 34h/50h, EGA and Tandy 68h/A0h).
PlayfieldRowBytes dw 0
WideRowBytes dw 0
; 16 playfield rows: the ScrollWindowOffset a level starts with.
ScrollStartOffset dw 0
; Current screen segment: from the adapter's geometry table; EGA flips it between
; A000h and A200h.
ScreenSegment dw 0
; Sprite banks: MANEXPL.BIC, 1X1.BIC, 2X2.BIC, 2X2C.BIC and the level's Gn.BIC.
ManExplSegment dw 0
Sprites1x1Segment dw 0
Sprites2x2Segment dw 0
Sprites2x2CSegment dw 0
LevelSpritesSegment dw 0
; UNKNOWN: not yet classified as code or data
    db 00h,00h
; THEND.BIC.
TheEndSegment dw 0
; Holds PANEL.ENC, the menu/HUD graphics drawn by DrawPanelGraphic.
PanelSegment dw 0
; The level plaque (plaqN.enc) and BLUEBITS.BIC.
PlaqueSegment dw 0
BlueBitsSegment dw 0
; UNKNOWN: not yet classified as code or data
    db 00h,00h
; 0 CGA, 1 EGA, 2 Tandy (from PSP:82h, values above 2 become 1). Indexes the BIOS
; mode table and many dispatch tables.
VideoAdapter dw 0
; The workspace scroll ring: ScrollWindowOffset moves up one row per scroll step; at
; ScrollBandBytes (16 rows) it wraps to ScrollWrapOffset (14 bands), and the top band
; is mirrored ScrollMirrorDistance (13 bands) further down.
ScrollBandBytes dw 0
ScrollWrapOffset dw 0
ScrollMirrorDistance dw 0
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
    mov sp, offset StackTop
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
    mov dx, offset MsgDeallocError
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
    call ApplyLauncherVideoOverride
loc_09657:
    test byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_SOUND
    je loc_09662
    call ApplyLauncherSoundOverride
loc_09662:
    jmp short loc_0966E

ApplyLauncherVideoOverride:
    mov word ptr cs:[VideoAdapter], bx
    ret

ApplyLauncherSoundOverride:
    mov byte ptr ds:[SoundModuleSelect], al
    ret
loc_0966E:
    call EnableFileFlagsIfVgaDac
    call VerifyStartupChecksums
    push ds
    call InstallTimerVector08
    pop ds
    call InstallKeyboardVector09
    call SetupResourceArchive
    call MeasureRetracePolarity
    call far ptr SetBestFitAllocStrategy
    call DetectFloppyDrives
    call DetectEms
    call LoadSoundModule
    call AllocateBuffers
    call BuildRowTables
    call InitStars
    call SetHiscoreRankColor
    call LoadCommonGraphics
    mov word ptr cs:[LoadNamePtr], offset File_WINDOW_BIC
    mov ax, word ptr cs:[WorkspaceSegment]
    add ax, 07D0h
    inc ax
    mov word ptr cs:[LoadDestSegment], ax
    mov word ptr cs:[LoadImageSlot], offset PlaqueImageOffset
    call LoadGraphicsRecordImages
    call CollapseScreenAndClear
    call StretchInWindowImage
    mov cx, 0FAh
loc_096C5:
    call WaitVerticalRetrace
    loop loc_096C5
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, offset VideoBiosModeTable
    xlat
    int 010h
    mov word ptr ds:[TextInGraphics], 1
    call ResetPageAndClearScreen
    call RunAttractSequence
; Options menu and choose screen, then reset level, lives and score and start the
; first level. GameOver returns here.
StartNewGame:
    mov al, 2
    call RequestModuleMusic
    call CgaSelectBrightPalette1
    call ResetEgaPages
    call RunOptionsMenu
    mov word ptr ds:[LevelIndex], 0
    mov word ptr ds:[LivesLeft], INITIAL_LIVES
    mov word ptr ds:[Word235A], 0
    mov word ptr ds:[GameOverRequest], 0
    mov byte ptr ds:[ScoreBcd], 0
    mov byte ptr ds:[ScoreBcd + 1], 0
    mov byte ptr ds:[ScoreBcd + 2], 0
    mov byte ptr ds:[ScoreBcd + 3], 0
    call RunChooseScreen
    call StretchInHudPanel
    call ResetPoolAAndUpgrades
    mov word ptr ds:[EnergyTanks], 3
    mov word ptr ds:[EnergyPoints], 018h
    call DrawHud
    jmp short AdvanceLevel
; Entered on NextLevelRequest, or F4 when LevelSkipEnabled. An interlude screen is
; shown when the completed LevelIndex is 0.
CompleteLevel:
    cmp word ptr ds:[LevelIndex], 0
    jne AdvanceLevel
    call ShowInterludeAndWaitPrimary
    call ResetPageAndClearScreen
    call RedrawStatusPanel
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
    call ResetEgaPages
    call ClearScreen104x200
    call DrawHud
    call LoadLevelMap
    call LoadLevelGraphics
    call ScrollMapToLevelStart
; Start a life (GameOver once LivesLeft reaches -1): reset the level objects and the primary
; record, place it and redraw.
StartLife:
    cmp word ptr ds:[LivesLeft], -1
    jne @@setup_life
    jmp near ptr GameOver
@@setup_life:
    call ResetRecordsForLife
    call TickRefuel
    call InitPositionHistory
    call DrawHud
    mov bp, offset PrimaryRecord
    call StoreApplyHistoryAndConditionalPlacement
    call UpdateAllRecords
    mov word ptr ds:[RandomWordCursor], offset CreditRandomWords
    call ApplyLevelPalette
    call ResetInvaderFormation
    mov word ptr ds:[SegBossActive], 0
    call RequestLifeStartMusic
    cmp word ptr ds:[MapScrollPos], MAP_START_POS
    jne GameFrame
    call RunTimedSequenceUntilPrimary
; One game frame, paced by the timer (WaitTimerTick): update and draw, act on the
; requests raised this frame, then F4 (level skip), F10 (pause) and Esc (quit prompt).
GameFrame:
    call ClearTimerTick
    call FlipEgaDrawPage
    call DrawRecordsToWorkspace
    cmp word ptr ds:[Fuel], 0
    jne @@marker_done
    call DrawFuelEmptyPanel
@@marker_done:
    call CopyWorkspaceToScreen
    call RestoreRecordBackgrounds
    call UpdatePlayerFrame
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
    call UpdateAllRecords
    call CheckBossKey
    call UpdateRefuelTimersAndScore
    cmp byte ptr ds:[LevelSkipEnabled], 0
    je @@check_pause
    cmp byte ptr ds:[KeyDownTable + SCAN_F4], KEY_STATE_DOWN
    jne @@check_pause
    jmp near ptr CompleteLevel
@@check_pause:
    cmp byte ptr ds:[KeyDownTable + SCAN_F10], KEY_STATE_DOWN
    jne @@check_quit
    call PauseGame
@@check_quit:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je QuitPrompt
ResumeGameFrame:
    call ShowEgaDrawPage
    call WaitTimerTick
    jmp short GameFrame

; Draws panel image 29h into the scroll window while Fuel is 0.
DrawFuelEmptyPanel:
    mov al, 4
    mov ah, 058h
    call DrawOffsetFromPlayfieldRow
    add di, word ptr ds:[ScrollWindowOffset]
    mov si, 029h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedStride104
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Show a message through 0F7F:0980 (AX=BED0h), wait 75 frames, then wait for the
; primary button (not for its release).
ShowInterludeAndWaitPrimary:
    call ResetPageAndClearScreen
    mov ax, offset WinScreenPageList
    call far ptr ShowPageList
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
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je @@wait_esc_release
    call FlushBiosKeyboardBuffer
    call FlipEgaDrawPage
    mov al, 4
    mov ah, 05Ch
    call DrawOffsetFromScreenRow
    mov si, 028h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    call FlipEgaDrawPage
@@poll_yes_no:
    mov byte ptr ds:[QuitAnswer], 'N'
    cmp byte ptr ds:[KeyDownTable + SCAN_N], KEY_STATE_DOWN
    je @@answered
    mov byte ptr ds:[QuitAnswer], 'Y'
    cmp byte ptr ds:[KeyDownTable + SCAN_Y], KEY_STATE_DOWN
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
    call ResetEgaPages
    call CollapseScreenWithSfx
    call StretchInTheEndImage
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
    call ResetPoolAAndUpgrades
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
    cmp byte ptr ds:[KeyDownTable + SCAN_F10], KEY_STATE_DOWN
    je @@wait_f10_release
    call FlipEgaDrawPage
    mov al, 4
    mov ah, 048h
    call DrawOffsetFromScreenRow
    mov si, 027h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov al, 4
    mov ah, 070h
    call DrawOffsetFromScreenRow
    mov si, 026h
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    call FlipEgaDrawPage
    mov byte ptr ds:[KeyLastMakeCode], 0
@@wait_resume:
    call far ptr CheckCheatCodes
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@resume
    cmp byte ptr ds:[KeyDownTable + SCAN_F10], KEY_STATE_DOWN
    jne @@wait_resume
@@resume:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@wait_f10_release_again
    mov byte ptr ds:[SfxRequest], 01Ch
@@wait_f10_release_again:
    cmp byte ptr ds:[KeyDownTable + SCAN_F10], KEY_STATE_DOWN
    je @@wait_f10_release_again
    ret

; Fill every HistoryPairs entry with PrimaryRecord's (Y+8, X+9) and reset the write
; cursor and the three lagged read cursors. Sets BP = PrimaryRecord. Note the X bias is
; 9 here but 8 in StorePositionHistory.
InitPositionHistory:
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset HistoryPairs
    mov cx, HISTORY_PAIR_COUNT
    mov bp, offset PrimaryRecord
loc_099CD:
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 8
    stosw
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 9
    stosw
    loop loc_099CD
    mov word ptr ds:[HistoryWriteCursor], offset HistoryPairs
    mov word ptr ds:[HistoryReadCursor15], offset HistoryPairs + HISTORY_LAG15_START
    mov word ptr ds:[HistoryReadCursor31], offset HistoryPairs + HISTORY_LAG31_START
    mov word ptr ds:[HistoryCursor47], offset HistoryPairs + HISTORY_LAG47_START
    ret

; Drives the player during the end-of-level sequence (LevelEndPhase) by synthesizing
; InputBits: autopilot to two waypoints, then refill fuel and energy.
RunLevelEndSequence:
    and word ptr ds:[PrimaryRecord + REC_X], 0FFFEh
    mov byte ptr ds:[InputBits], 0
    mov bx, word ptr ds:[LevelEndPhase]
    shl bx, 1
    jmp word ptr cs:[bx + LevelEndPhaseCases]
    even
LevelEndPhaseCases label word
    dw offset CountXReturn, offset LevelEndFlyToWaypointA, offset LevelEndFlyToWaypointB, offset LevelEndRefill
    dw offset CountXReturn
LevelEndRefill:
    mov byte ptr ds:[InputBits], 8
    call PickupFuel
    call AddEnergyPoint
    cmp word ptr ds:[Fuel], 58h
    je loc_09A29
    ret
loc_09A29:
    cmp word ptr ds:[EnergyTanks], 3
    je loc_09A31
    ret
loc_09A31:
    cmp word ptr ds:[EnergyPoints], 18h
    je loc_09A39
    ret
loc_09A39:
    inc word ptr ds:[LevelEndPhase]
    ret
; Also spreads the side pods out.
LevelEndFlyToWaypointB:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    jne loc_09A5D
    cmp word ptr ds:[SidePodSpreadLeft], 8
    je loc_09A50
    inc word ptr ds:[SidePodSpreadLeft]
loc_09A50:
    cmp word ptr ds:[SidePodSpreadRight], -8
    je loc_09A73
    dec word ptr ds:[SidePodSpreadRight]
    jmp short loc_09A73
loc_09A5D:
    cmp word ptr ds:[SidePodSpreadLeft], 0Fh
    je loc_09A68
    inc word ptr ds:[SidePodSpreadLeft]
loc_09A68:
    cmp word ptr ds:[SidePodSpreadRight], -0Fh
    je loc_09A73
    dec word ptr ds:[SidePodSpreadRight]
loc_09A73:
    mov si, offset AutopilotWaypointB
    jmp short loc_09A7B
LevelEndFlyToWaypointA:
    mov si, offset AutopilotWaypointA
loc_09A7B:
    call SteerInputToWaypoint
    cmp byte ptr ds:[InputBits], 0
    je loc_09A86
    ret
loc_09A86:
    inc word ptr ds:[LevelEndPhase]
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_B
    je loc_09A94
    jmp near ptr RunLevelEndSequence
loc_09A94:
    mov word ptr ds:[SidePodSpreadRight], 0
    mov word ptr ds:[SidePodSpreadLeft], 0
    call FindFreeRecordPoolA
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_KIND], KIND_ENEMY
    mov word ptr ds:[bx + REC_TYPE], 52h
    mov word ptr ds:[bx + REC_SIZE_CLASS], 2
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    mov word ptr ds:[bx + REC_SPRITE], 0Fh
    mov word ptr ds:[bx + REC_Y], 20h
    mov word ptr ds:[bx + REC_X], 58h
    mov ds:[AutoMoveExtraRecord], bx
    jmp near ptr RunLevelEndSequence
; SI = (Y, X) waypoint: sets InputBits to move the player toward it (0 when there).
SteerInputToWaypoint:
    lodsw
    cmp word ptr ds:[PrimaryRecord + REC_Y], ax
    je loc_09AE4
    mov byte ptr ds:[InputBits], 4
    jb loc_09AE4
    mov byte ptr ds:[InputBits], 8
loc_09AE4:
    lodsw
    cmp word ptr ds:[PrimaryRecord + REC_X], ax
    je loc_09AFE
    pushf
    or byte ptr ds:[InputBits], 1
    popf
    jb loc_09AFE
    and byte ptr ds:[InputBits], 0FEh
    or byte ptr ds:[InputBits], 2
loc_09AFE:
    ret
loc_09AFF:
    cmp word ptr ds:[FrameCount4], 3
    je loc_09B07
    ret
loc_09B07:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp word ptr ss:[bp + REC_SPRITE], 0Fh
    je loc_09B11
    ret
loc_09B11:
    mov word ptr ss:[bp + REC_STATUS], 0
    call RestartAtCheckpoint
    mov word ptr ds:[LifeLostRequest], 1
    cmp word ptr ds:[Fuel], 0
    je loc_09B27
    ret
loc_09B27:
    mov word ptr ds:[GameOverRequest], 1
    ret

; Per frame: input (or the level-end autopilot), beam, movement, scroll, fire, pods and
; position history; the dying animation once EnergyTanks is -1.
UpdatePlayerFrame:
    mov word ptr ds:[LifeLostRequest], 0
    mov word ptr ds:[NextLevelRequest], 0
    call PollInputBits
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    je loc_09B47
    call RunLevelEndSequence
loc_09B47:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_DONE
    jne loc_09B55
    mov word ptr ds:[NextLevelRequest], 1
    ret
loc_09B55:
    mov word ptr ds:[ScrollDeltaY], 0
    mov bp, offset PrimaryRecord
    call UpdateBeam
    cmp word ptr ds:[EnergyTanks], -1
    je loc_09AFF
    cmp word ptr ds:[Fuel], 0
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
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    jbe loc_09BA9
    test byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
    je loc_09BA9
    call ApplySelectedUpgrade
loc_09BA9:
    call ScrollForwardAndCheckLevelEnd
    call HandleFireButton
    cmp byte ptr ds:[BonusKeysEnabled], 0
    je loc_09BC0
    cmp byte ptr ds:[KeyDownTable + SCAN_3], KEY_STATE_DOWN
    jne loc_09BC0
    call PickupUpgradeSelector
loc_09BC0:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    ja loc_09BCA
    call UpdatePlacementXOffsetsAtRecordEdges
loc_09BCA:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne loc_09BDF
    call DamagePlayerOnTerrainContact
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    jbe loc_09BDF
    call AdjustRecordXFromCounts
loc_09BDF:
    call AdvancePositionHistoryIfRequested

; Separate entry, also reached by fallthrough from the code above. BP = record.
; Record its position in the history, move the trailing pods along it, then place the
; side pods unless the map has scrolled to MapScrollPos <= B6h outside the demo.
StoreApplyHistoryAndConditionalPlacement:
    call StorePositionHistory
    call ApplyPositionHistoryToRecords
; When placement is skipped, the previous ClampXLowSeen/ClampXHighSeen survive.
    cmp word ptr ds:[DemoActive], 0
    jne loc_09BF7
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    jbe loc_09BFA
loc_09BF7:
    call PlaceSidePods
loc_09BFA:
    ret

CountLeftPod:
    inc ah
    ret

CountRightPod:
    inc al
    ret

; BP = record. Push X two steps away from an edge where a side pod was clamped (unless
; the player steers that way), then one step towards the side with fewer pods (skipped for a
; difference of one while CountGate2324 = 1). XAdjustPathTaken = 1 when any nudge path
; was taken, even if the bound kept X unchanged; it triggers a history advance.
AdjustRecordXFromCounts:
    mov word ptr ds:[XAdjustPathTaken], 0
    test byte ptr ds:[InputBits], IN_XMINUS
    jne loc_09C1E
    cmp byte ptr ds:[ClampXLowSeen], 1
    jne loc_09C1E
    call IncRecordXTwice
    mov word ptr ds:[XAdjustPathTaken], 1
loc_09C1E:
    test byte ptr ds:[InputBits], IN_XPLUS
    jne loc_09C35
    cmp byte ptr ds:[ClampXHighSeen], 1
    jne loc_09C35
    call DecRecordXTwice
    mov word ptr ds:[XAdjustPathTaken], 1
loc_09C35:
    xor ax, ax
    cmp word ptr ds:[SidePodLeftInner], -1
    je loc_09C41
    call CountLeftPod
loc_09C41:
    cmp word ptr ds:[SidePodRightInner], -1
    je loc_09C4B
    call CountRightPod
loc_09C4B:
    cmp word ptr ds:[SidePodLeftOuter], -1
    je loc_09C55
    call CountLeftPod
loc_09C55:
    cmp word ptr ds:[SidePodRightOuter], -1
    je loc_09C5F
    call CountRightPod
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
    cmp word ptr ds:[CountGate2324], 1
    jne loc_09C8A
    ret
loc_09C8A:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr IncRecordXBelowMax
CountXInc:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr IncRecordXBelowMax
CountXDecIfGate:
    cmp word ptr ds:[CountGate2324], 1
    jne loc_09CA4
    ret
loc_09CA4:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr DecRecordXUnlessZero
CountXDec:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr DecRecordXUnlessZero

; BP = PrimaryRecord: on terrain contact, DamagePlayerEnergy 2, 3 or 4 times by
; DifficultySetting. Preserves BP.
DamagePlayerOnTerrainContact:
    call ProbeShipTerrainCollision
    jb loc_09CBC
    ret
loc_09CBC:
    push bp
    cmp word ptr ds:[DifficultySetting], 0
    je loc_09CD1
    cmp word ptr ds:[DifficultySetting], 1
    je loc_09CCE
    call DamagePlayerEnergy
loc_09CCE:
    call DamagePlayerEnergy
loc_09CD1:
    call DamagePlayerEnergy
    call DamagePlayerEnergy
    pop bp
    ret

; BP = record. Store its (Y+8, X+8) at HistoryWriteCursor without advancing the cursor.
StorePositionHistory:
    mov es, word ptr cs:[MainDataSegment]
    mov di, word ptr ds:[HistoryWriteCursor]
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 8
    stosw
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 8
    stosw
    ret

; Advance the write cursor and the three lagged cursors one entry around the
; HistoryPairs ring. Triggered by movement input or XAdjustPathTaken, not by an actual
; position change; XAdjustPathTaken can be stale when AdjustRecordXFromCounts was skipped.
AdvancePositionHistoryIfRequested:
    test byte ptr ds:[InputBits], INPUT_MOVEMENT_MASK
    jne loc_09D00
    cmp word ptr ds:[XAdjustPathTaken], 0
    jne loc_09D00
    ret
loc_09D00:
    add word ptr ds:[HistoryWriteCursor], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryWriteCursor], offset HistoryEnd
    jne loc_09D13
    mov word ptr ds:[HistoryWriteCursor], offset HistoryPairs
loc_09D13:
    add word ptr ds:[HistoryReadCursor15], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryReadCursor15], offset HistoryEnd
    jne loc_09D26
    mov word ptr ds:[HistoryReadCursor15], offset HistoryPairs
loc_09D26:
    add word ptr ds:[HistoryReadCursor31], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryReadCursor31], offset HistoryEnd
    jne loc_09D39
    mov word ptr ds:[HistoryReadCursor31], offset HistoryPairs
loc_09D39:
    add word ptr ds:[HistoryCursor47], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryCursor47], offset HistoryEnd
    jne loc_09D4C
    mov word ptr ds:[HistoryCursor47], offset HistoryPairs
loc_09D4C:
    ret

; Item 1: advances SelectedUpgradeSlot (0..3) and refreshes the upgrade display.
PickupUpgradeSelector:
    cmp byte ptr ds:[BonusKeysEnabled], 0
    je loc_09D5B
loc_09D54:
    cmp byte ptr ds:[KeyDownTable + SCAN_3], KEY_STATE_DOWN
    je loc_09D54
loc_09D5B:
    inc word ptr ds:[SelectedUpgradeSlot]
    and word ptr ds:[SelectedUpgradeSlot], 3
    jmp near ptr loc_0AC19
; Item 2: an energy tank, or refilled energy when all three are held.
PickupEnergy:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09D73
    mov byte ptr ds:[SfxRequest], 1Ch
loc_09D73:
    cmp word ptr ds:[EnergyTanks], 3
    je loc_09D84
    inc word ptr ds:[EnergyTanks]
loc_09D7E:
    push bp
    call RedrawEnergyGauge
    pop bp
    ret
loc_09D84:
    cmp word ptr ds:[EnergyPoints], 18h
    je loc_09D7E
    inc word ptr ds:[EnergyPoints]
    jmp short loc_09D84
AddFrontPod:
    cmp word ptr ds:[FrontPodRecord], -1
    je loc_09D99
    ret
loc_09D99:
    call AllocRecordEvicting
    mov ds:[FrontPodRecord], bx
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], KIND_POD
    mov word ptr ds:[bx + REC_SPRITE], 0Fh
    mov word ptr ds:[bx + REC_HIT_POINTS], 14h
    ret

; Item 4: starts refuelling unless the tank is full or already refilling.
PickupFuel:
    cmp word ptr ds:[Fuel], 058h
    jne loc_09DC1
    ret
loc_09DC1:
    cmp word ptr ds:[RefuelActive], 1
    jne loc_09DC9
    ret
loc_09DC9:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_09DE9
    mov word ptr ds:[RefuelActive], 1
    cmp word ptr ds:[DemoActive], 1
    je loc_09DE9
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09DE9
    mov byte ptr ds:[SfxRequest], 0Dh
loc_09DE9:
    ret
; Level-end refill step: EnergyPoints + 1; a full bar becomes a new tank unless three
; are held.
AddEnergyPoint:
    cmp word ptr ds:[EnergyPoints], 18h
    jne loc_09E12
    cmp word ptr ds:[EnergyTanks], 3
    jne loc_09DF9
    ret
loc_09DF9:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09E05
    mov byte ptr ds:[SfxRequest], 1Ch
loc_09E05:
    inc word ptr ds:[EnergyTanks]
    mov word ptr ds:[EnergyPoints], 0
    jmp near ptr RedrawEnergyGauge
loc_09E12:
    inc word ptr ds:[EnergyPoints]
    jmp near ptr RedrawEnergyGauge

; One hit (ignored in LEVEL_END_TO_WAYPOINT_A, while dying or out of tanks): flash,
; EnergyPoints -= 1..3 by difficulty; an empty bar refills and falls into
; LosePlayerEnergyTank.
DamagePlayerEnergy:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    jne loc_09E21
    ret
loc_09E21:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb loc_09E29
    ret
loc_09E29:
    cmp word ptr ds:[EnergyTanks], -1
    jne loc_09E31
    ret
loc_09E31:
    mov word ptr ds:[PrimaryRecord + REC_FLASH_TIMER], 8
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09E43
    mov byte ptr ds:[SfxRequest], 0Fh
loc_09E43:
    cmp word ptr ds:[DifficultySetting], 0
    je loc_09E5D
    cmp word ptr ds:[DifficultySetting], 1
    je loc_09E57
    dec word ptr ds:[EnergyPoints]
    je loc_09E63
loc_09E57:
    dec word ptr ds:[EnergyPoints]
    je loc_09E63
loc_09E5D:
    dec word ptr ds:[EnergyPoints]
    jne RedrawEnergyGauge
loc_09E63:
    mov word ptr ds:[EnergyPoints], 018h
; Also called on body contact. Without tanks left the ship dies (form 3), unless
; AllCheatsFlag refills.
LosePlayerEnergyTank:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    jne loc_09E71
    ret
loc_09E71:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb loc_09E79
    ret
loc_09E79:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09E85
    mov byte ptr ds:[SfxRequest], 3
loc_09E85:
    cmp word ptr ds:[DifficultySetting], 0
    jne loc_09E98
    inc byte ptr ds:[EasyHitToggle]
    and byte ptr ds:[EasyHitToggle], 1
    je loc_09E98
    ret
loc_09E98:
    dec word ptr ds:[EnergyTanks]
    cmp word ptr ds:[EnergyTanks], -1
    jne RedrawEnergyGauge
    mov word ptr ds:[EnergyPoints], 0
    cmp byte ptr ds:[AllCheatsFlag], 1
    je loc_09ED7
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    cmp byte ptr ds:[SfxEnabled], 0
    je RedrawEnergyGauge
    mov byte ptr ds:[SfxRequest], 019h
; DrawEnergyGauge, on both pages on EGA.
RedrawEnergyGauge:
    call DrawEnergyGauge
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_09ED6
    call FlipEgaDrawPage
    call DrawEnergyGauge
    call FlipEgaDrawPage
loc_09ED6:
    ret
loc_09ED7:
    mov word ptr ds:[EnergyTanks], 3
    mov word ptr ds:[EnergyPoints], 018h
    ret

; Fuel - 1; at 0 the ship dies unless WhatOilShortageFlag refills it. Redraws the gauge.
DrainFuelUnit:
    cmp word ptr ds:[Fuel], 0
    jne loc_09EEC
    ret
loc_09EEC:
    dec word ptr ds:[Fuel]
    je loc_09EF5
    jmp near ptr DrawFuelGauge
loc_09EF5:
    cmp byte ptr ds:[WhatOilShortageFlag], 1
    je loc_09F11
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09F0E
    mov byte ptr ds:[SfxRequest], 019h
loc_09F0E:
    jmp near ptr DrawFuelGauge
loc_09F11:
    mov word ptr ds:[Fuel], 058h
    jmp near ptr DrawFuelGauge
AddTrailingPod:
    push bp
    call AddTrailingPodBody
    pop bp
    ret
; Body of AddTrailingPod: fills TrailingPodNear, else TrailingPodFar.
AddTrailingPodBody:
    cmp word ptr ds:[TrailingPodNear], -1
    jne loc_09F30
    call AllocRecordEvicting
    mov ds:[TrailingPodNear], bx
    jmp short InitPodRecord
loc_09F30:
    cmp word ptr ds:[TrailingPodFar], -1
    jne loc_09F40
    call AllocRecordEvicting
    mov ds:[TrailingPodFar], bx
    jmp short InitPodRecord
loc_09F40:
    ret
; BX = record: a live KIND_POD, size class 1, sprite 14h, 80 hit points, second draw
; pass.
InitPodRecord:
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], KIND_POD
    mov word ptr ds:[bx + REC_SPRITE], 014h
    mov word ptr ds:[bx + REC_HIT_POINTS], 050h
    mov word ptr ds:[bx + REC_DRAW_PASS], 1
    ret
; Fills up to two empty SidePod* slots in the order left inner, right inner, left outer,
; right outer.
AddSidePods:
    mov word ptr ds:[SidePodsToAdd], 2
    mov bx, offset SidePodLeftInner
    call FillSidePodSlotIfEmpty
    mov bx, offset SidePodRightInner
    call FillSidePodSlotIfEmpty
    je loc_09F81
    mov bx, offset SidePodLeftOuter
    call FillSidePodSlotIfEmpty
    je loc_09F81
    mov bx, offset SidePodRightOuter
    call FillSidePodSlotIfEmpty
loc_09F81:
    ret
FillSidePodSlotIfEmpty:
    cmp word ptr ds:[bx], -1
    je loc_09F88
    ret
loc_09F88:
    mov word ptr ds:[SidePodSlotPtr], bx
    push bp
    mov bp, offset PrimaryRecord
    call AllocRecordEvicting
    call InitPodRecord
    mov word ptr ds:[bx + REC_SPRITE], 018h
    mov word ptr ds:[bx + REC_DRAW_PASS], 1
    mov di, word ptr ds:[SidePodSlotPtr]
    mov word ptr ds:[di], bx
    call PlaceSidePods
    pop bp
    dec word ptr ds:[SidePodsToAdd]
    ret

; BP = record the pods follow. Position the four side pods from their offset tables,
; right pair spread by SidePodSpreadRight, left pair by SidePodSpreadLeft; empty slots
; are skipped. ClampXLowSeen/ClampXHighSeen report whether any pod hit the X clamp.
; Falls through into PlaceRecordFromOffsetPair for the last pod.
PlaceSidePods:
    mov byte ptr ds:[ClampXLowSeen], 0
    mov byte ptr ds:[ClampXHighSeen], 0
    mov ax, word ptr ds:[SidePodSpreadRight]
    mov word ptr ds:[OffsetXWork], ax
    mov si, offset SidePodOffsetsRightOuter
    mov bx, word ptr ds:[SidePodRightOuter]
    call PlaceRecordFromOffsetPair
    mov si, offset SidePodOffsetsRightInner
    mov bx, word ptr ds:[SidePodRightInner]
    call PlaceRecordFromOffsetPair
    mov ax, word ptr ds:[SidePodSpreadLeft]
    mov word ptr ds:[OffsetXWork], ax
    mov si, offset SidePodOffsetsLeftOuter
    mov bx, word ptr ds:[SidePodLeftOuter]
    call PlaceRecordFromOffsetPair
    mov si, offset SidePodOffsetsLeftInner
    mov bx, word ptr ds:[SidePodLeftInner]

; BX = pod record or FFFFh (no-op), SI = (Y, X) offset table, BP = anchor record.
; Pod position = anchor + table[anchor REC_SPRITE] + 2*OffsetXWork in X, with X clamped
; to 0..PLACEMENT_X_SIGNED_MAX; a clamp sets ClampXLowSeen/ClampXHighSeen (never clears).
PlaceRecordFromOffsetPair:
    cmp bx, -1
    jne loc_09FF0
    ret
; The pair index is the anchor's REC_SPRITE (ship form).
; Tables hold three pairs, but no bound check: the primary sprite can be set to 3.
loc_09FF0:
    mov ax, word ptr ss:[bp + REC_SPRITE]
    shl ax, 1
    shl ax, 1
    add si, ax
    lodsw
    add ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[bx + REC_Y], ax

    lodsw
    add ax, word ptr ss:[bp + REC_X]
    add ax, word ptr ds:[OffsetXWork]
    add ax, word ptr ds:[OffsetXWork]
    mov word ptr ds:[bx + REC_X], ax
    cmp word ptr ds:[bx + REC_X], 0
    jge loc_0A01F
    mov word ptr ds:[bx + REC_X], 0
    mov byte ptr ds:[ClampXLowSeen], 1
loc_0A01F:
    cmp word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
    jle loc_0A030
    mov word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
    mov byte ptr ds:[ClampXHighSeen], 1
loc_0A030:
    ret

; Move the trailing pods (slots TrailingPodNear/Far, FFFFh = empty) to the lagged
; history positions at HistoryReadCursor15 and HistoryReadCursor31.
ApplyPositionHistoryToRecords:
    cmp word ptr ds:[TrailingPodNear], -1
    je loc_0A048
    mov bx, word ptr ds:[TrailingPodNear]
    mov si, word ptr ds:[HistoryReadCursor15]
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
loc_0A048:
    cmp word ptr ds:[TrailingPodFar], -1
    je loc_0A05F
    mov bx, word ptr ds:[TrailingPodFar]
    mov si, word ptr ds:[HistoryReadCursor31]
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
loc_0A05F:
    ret
ClearFireLatch:
    mov word ptr ds:[FireLatch], 0
    ret

; BP = PrimaryRecord. Fires when the primary button is newly pressed, held with rapid
; fire, or every 16 frames while held. Early in the level (MapScrollPos <= B6h, not the
; demo) only the main shot fires; otherwise the ShotsLive* snapshot is taken and
; missile, side shots, pod shots and the main weapon fire in turn.
HandleFireButton:
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je ClearFireLatch
    cmp word ptr ds:[FireLatch], 0
    je loc_0A084
    cmp byte ptr ds:[RapidFireEnabled], 1
    je loc_0A084
    cmp word ptr ds:[FrameCount16], 0Fh
    je loc_0A084
    ret
loc_0A084:
    mov word ptr ds:[FireLatch], 1
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja loc_0A0A6
    cmp word ptr ds:[DemoActive], 0
    jne loc_0A0A6
    cmp word ptr ds:[WeaponMode], 2
    jne loc_0A0A3
    jmp near ptr FireForkShot
loc_0A0A3:
    jmp near ptr FireSingleShot
loc_0A0A6:
    mov ax, word ptr ds:[ShotsLiveMain]
    mov word ptr ds:[ShotsAtFireMain], ax
    mov ax, word ptr ds:[ShotsLiveType9]
    mov word ptr ds:[ShotsAtFireBeam], ax
    mov ax, word ptr ds:[ShotsLiveSide]
    mov word ptr ds:[ShotsAtFireSide], ax
    mov ax, word ptr ds:[ShotsLiveFrontPod]
    mov word ptr ds:[ShotsAtFireFrontPod], ax
    cmp word ptr ds:[DemoActive], 1
    jne loc_0A0D8
    cmp word ptr ds:[DemoStep], 8
    jne loc_0A0CE
    jmp short FireFrontPodBurst
loc_0A0CE:
    cmp word ptr ds:[DemoStep], 0Fh
    jbe loc_0A0D8
    jmp near ptr FireMissile
loc_0A0D8:
    call FireMissile
    call FirePlayerSideShots
    call FireTrailingPodShots
    call FireSidePodShots
    call FireMainWeapon
    ret

; Starts the beam in WeaponMode 5, fires the front pod burst, then the WeaponMode
; pattern.
FireMainWeapon:
    cmp word ptr ds:[WeaponMode], 5
    jne loc_0A0F2
    call StartBeam
loc_0A0F2:
    cmp word ptr ds:[FrontPodRecord], -1
    je loc_0A0FC
    call FireFrontPodBurst
loc_0A0FC:
    mov bx, word ptr ds:[WeaponMode]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0A0FCCases]
    even
loc_0A0FCCases label word
    dw offset FireSingleShot, offset FireHeavyShot, offset FireForkShot, offset FireTwinRising3
    dw offset FireTwinRising16, offset CountXReturn

; Three type 0Ch shots from FrontPodRecord (up, up-left, up-right), one burst at a
; time.
FireFrontPodBurst:
    cmp word ptr ds:[ShotsAtFireFrontPod], 0
    je loc_0A11C
    ret
loc_0A11C:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A128
    mov byte ptr ds:[SfxRequest], 018h
loc_0A128:
    inc word ptr ds:[ShotsLiveFrontPod]
    call AllocFrontPodShot
    sub ax, 6
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[si + REC_X]
    add ax, 4
    mov word ptr ds:[bx + REC_X], ax
    inc word ptr ds:[ShotsLiveFrontPod]
    call AllocFrontPodShot
    sub ax, 2
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[si + REC_X]
    sub ax, 4
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    inc word ptr ds:[ShotsLiveFrontPod]
    call AllocFrontPodShot
    sub ax, 2
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[si + REC_X]
    add ax, 0Ch
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    ret

; AllocPlayerShot as type 0Ch with REC_FIELD_1C 7; returns SI = FrontPodRecord, AX =
; its Y.
AllocFrontPodShot:
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_TYPE], 0Ch
    mov word ptr ds:[bx + REC_FIELD_1C], 7
    mov si, word ptr ds:[FrontPodRecord]
    mov ax, word ptr ds:[si + REC_Y]
    ret
; WeaponMode 1: the single shot with sprite 33h, which does an extra hit point of
; damage.
FireHeavyShot:
    call SpawnShotAtMuzzle
    mov word ptr ds:[bx + REC_SPRITE], 33h
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A19E
    mov byte ptr ds:[SfxRequest], 14h
loc_0A19E:
    ret
; WeaponMode 0: one type 2 shot straight up from the muzzle.
FireSingleShot:
    cmp byte ptr ds:[SfxEnabled], 0
    je SpawnShotAtMuzzle
    mov byte ptr ds:[SfxRequest], 013h
SpawnShotAtMuzzle:
    call AllocPlayerShot

; BX = shot: position = player + MuzzleOffsets[player REC_SPRITE].
PlaceShotAtMuzzle:
    mov si, word ptr ss:[bp + REC_SPRITE]
    shl si, 1
    shl si, 1
    add si, offset MuzzleOffsets
    lodsw
    add ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    add ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[bx + REC_X], ax
    ret
; WeaponMode 2: one shot up and one steered by the horizontal input (up-left, up-right
; or up).
FireForkShot:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A1D4
    mov byte ptr ds:[SfxRequest], 015h
loc_0A1D4:
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_SPRITE], 018h
    call PlaceShotAtMuzzle
    call AllocPlayerShot
    call PlaceShotAtMuzzle
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_SPRITE], 01Fh
    test byte ptr ds:[InputBits], IN_XMINUS
    jne loc_0A211
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 019h
    test byte ptr ds:[InputBits], IN_XPLUS
    jne loc_0A211
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_SPRITE], 018h
loc_0A211:
    ret

; Grows the beam (BeamList) by a link every other frame while it has room, raises the
; head 4 px and lines the other links up beside it.
UpdateBeam:
    cmp word ptr ds:[ShotsLiveType9], 0
    jne loc_0A21A
    ret
loc_0A21A:
    cmp word ptr ds:[CountGate2324], 1
    jne loc_0A258
    cmp word ptr ds:[BeamListEnd], offset BeamListTerminator
    jne loc_0A22A
    ret
loc_0A22A:
    mov bx, word ptr ds:[BeamList]
    cmp bx, -1
    jne loc_0A234
    ret
loc_0A234:
    cmp word ptr ds:[bx + REC_X], 0
    je loc_0A255
    call SpawnBeamLink
    mov bx, word ptr ds:[BeamList]
    sub word ptr ds:[bx + REC_X], 8
    mov bx, word ptr ds:[BeamListEnd]
    sub bx, 4
    mov bx, word ptr ds:[bx]
    cmp word ptr ds:[bx + REC_X], 0C8h
    je loc_0A258
loc_0A255:
    call SpawnBeamLink
loc_0A258:
    mov si, offset BeamList
    lodsw
    cmp ax, 0FFFFh
    jne loc_0A262
    ret
loc_0A262:
    mov bx, ax
    sub word ptr ds:[bx + REC_Y], 4
    mov cx, word ptr ds:[bx + REC_X]
    add cx, 8
    mov di, word ptr ds:[bx + REC_Y]
loc_0A271:
    lodsw
    cmp ax, 0FFFFh
    je loc_0A289
    mov bx, ax
    mov word ptr ds:[bx + REC_X], cx
    add cx, 8
    mov word ptr ds:[bx + REC_Y], di
    mov word ptr ds:[bx + REC_SPRITE], 06Bh
    jmp short loc_0A271
loc_0A289:
    sub si, 4
    mov bx, word ptr ds:[si]
    mov word ptr ds:[bx + REC_SPRITE], 06Ch
    ret

AppendBeamLink:
    mov di, word ptr ds:[BeamListEnd]
    mov word ptr ds:[di], bx
    add word ptr ds:[BeamListEnd], 2
    ret

; WeaponMode 5: resets BeamList and spawns its first two links (one beam at a time).
StartBeam:
    cmp word ptr ds:[ShotsAtFireBeam], 0
    je loc_0A2A8
    ret
loc_0A2A8:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A2B4
    mov byte ptr ds:[SfxRequest], 011h
loc_0A2B4:
    mov es, word ptr cs:[MainDataSegment]
    mov word ptr ds:[BeamListEnd], offset BeamList
    mov di, offset BeamList
    mov ax, 0FFFFh
    mov cx, 01Ah
    rep stosw
    call SpawnBeamLink
    mov word ptr ds:[bx + REC_SPRITE], 06Ah
    sub word ptr ds:[bx + REC_X], 8

SpawnBeamLink:
    inc word ptr ds:[ShotsLiveType9]
    call AllocPlayerShot
    call AppendBeamLink
    mov word ptr ds:[bx + REC_TYPE], 9
    call PlaceShotAtMuzzle
    and word ptr ds:[bx + REC_X], 0FFF8h
    add word ptr ds:[bx + REC_X], 8
    mov word ptr ds:[bx + REC_SPRITE], 06Ch
    ret
; WeaponMode 4: two type 8 shots, one burst at a time.
FireTwinRising16:
    cmp word ptr ds:[ShotsAtFireMain], 0
    je loc_0A2FE
    ret
loc_0A2FE:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A30A
    mov byte ptr ds:[SfxRequest], 17h
loc_0A30A:
    inc word ptr ds:[ShotsLiveMain]
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_TYPE], 8
    mov word ptr ds:[bx + REC_SPRITE], 35h
    call PlaceShotAtMuzzle
    inc word ptr ds:[ShotsLiveMain]
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_TYPE], 8
    mov word ptr ds:[bx + REC_SPRITE], 35h
    call PlaceShotAtMuzzle
    add word ptr ds:[bx + REC_Y], 8
    ret
; WeaponMode 3: two type 7 shots, one burst at a time.
FireTwinRising3:
    cmp word ptr ds:[ShotsAtFireMain], 0
    je loc_0A33F
    ret
loc_0A33F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A34B
    mov byte ptr ds:[SfxRequest], 16h
loc_0A34B:
    inc word ptr ds:[ShotsLiveMain]
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_TYPE], 7
    mov word ptr ds:[bx + REC_SPRITE], 37h
    call PlaceShotAtMuzzle
    inc word ptr ds:[ShotsLiveMain]
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_TYPE], 7
    mov word ptr ds:[bx + REC_SPRITE], 37h
    call PlaceShotAtMuzzle
    add word ptr ds:[bx + REC_Y], 8
    ret

; SI = pod record (FFFFh = none): its type 6 and type 5 side shots when side shots
; are enabled.
FirePodSideShots:
    cmp si, -1
    jne loc_0A37E
    ret
loc_0A37E:
    cmp word ptr ds:[SideShotsEnabled], 0
    jne loc_0A386
    ret
loc_0A386:
    cmp word ptr ds:[ShotsAtFireSide], 0
    je loc_0A38E
    ret
loc_0A38E:
    call SpawnSideShotFromSI
    mov word ptr ds:[bx + REC_TYPE], 6

SpawnSideShotFromSI:
    inc word ptr ds:[ShotsLiveSide]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A3A6
    mov byte ptr ds:[SfxRequest], 012h
loc_0A3A6:
    call AllocPlayerShot
    mov ax, word ptr ds:[si + REC_X]
    add ax, 4
    mov word ptr ds:[bx + REC_X], ax
    mov ax, word ptr ds:[si + REC_Y]
    add ax, 4
    mov word ptr ds:[bx + REC_Y], ax
    and word ptr ds:[bx + REC_X], 0FFFCh
    mov word ptr ds:[bx + REC_SPRITE], 8
    mov word ptr ds:[bx + REC_TYPE], 5
    ret

; The WeaponMode pattern from the side pods (left pods fire up-left, right
; pods up-right).
FireSidePodShots:
    mov word ptr ds:[PodShotDirection], 7
    mov si, word ptr ds:[SidePodLeftInner]
    call FirePodWeapon
    mov word ptr ds:[PodShotDirection], 1
    mov si, word ptr ds:[SidePodRightInner]
    call FirePodWeapon
    mov word ptr ds:[PodShotDirection], 7
    mov si, word ptr ds:[SidePodLeftOuter]
    call FirePodWeapon
    mov word ptr ds:[PodShotDirection], 1
    mov si, word ptr ds:[SidePodRightOuter]
    call FirePodWeapon
    ret

; The WeaponMode pattern and side shots from the two trailing pods.
FireTrailingPodShots:
    mov word ptr ds:[PodShotDirection], 0FFFFh
    mov si, word ptr ds:[TrailingPodNear]
    call FirePodWeapon
    call FirePodSideShots
    mov si, word ptr ds:[TrailingPodFar]
    call FirePodWeapon
    call FirePodSideShots
    ret

; SI = pod record (FFFFh = none): its WeaponMode pattern (no beam).
FirePodWeapon:
    cmp si, -1
    jne loc_0A420
    ret
loc_0A420:
    mov bx, word ptr ds:[WeaponMode]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0A420Cases]
    even
loc_0A420Cases label word
    dw offset SpawnShotAtPod, offset PodHeavyShot, offset PodForkShot, offset PodTwinRising3
    dw offset PodTwinRising16, offset CountXReturn
PodTwinRising16:
    cmp word ptr ds:[ShotsAtFireMain], 0
    je loc_0A440
    ret
loc_0A440:
    add word ptr ds:[ShotsLiveMain], 2
    call SpawnShotAtPod
    mov word ptr ds:[bx + REC_TYPE], 8
    mov word ptr ds:[bx + REC_SPRITE], 35h
    call SpawnShotAtPod
    mov word ptr ds:[bx + REC_TYPE], 8
    mov word ptr ds:[bx + REC_SPRITE], 35h
    add word ptr ds:[bx + REC_Y], 8
    ret
PodTwinRising3:
    cmp word ptr ds:[ShotsAtFireMain], 0
    je loc_0A46C
    ret
loc_0A46C:
    add word ptr ds:[ShotsLiveMain], 2
    call SpawnShotAtPod
    mov word ptr ds:[bx + REC_TYPE], 7
    mov word ptr ds:[bx + REC_SPRITE], 37h
    call SpawnShotAtPod
    mov word ptr ds:[bx + REC_TYPE], 7
    mov word ptr ds:[bx + REC_SPRITE], 37h
    add word ptr ds:[bx + REC_Y], 8
    ret
PodHeavyShot:
    call SpawnShotAtPod
    mov word ptr ds:[bx + REC_SPRITE], 33h
    ret
PodForkShot:
    call AllocPlayerShot
    mov ax, ds:[si + REC_Y]
    mov ds:[bx + REC_Y], ax
    mov ax, ds:[si + REC_X]
    add ax, 4
    mov ds:[bx + REC_X], ax
    mov ax, ds:[PodShotDirection]
    mov ds:[bx + REC_DIRECTION], ax
    cmp ax, 0FFFFh
    jne loc_0A4C6
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    cmp word ptr ds:[si + REC_X], 58h
    jna loc_0A4C6
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
loc_0A4C6:
    cmp word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 19h
    je loc_0A4D6
    mov word ptr ds:[bx + REC_SPRITE], 1Fh
loc_0A4D6:
    ret
SpawnShotAtPod:
    call AllocPlayerShot
    mov ax, ds:[si + REC_Y]
    mov ds:[bx + REC_Y], ax
    mov ax, ds:[si + REC_X]
    add ax, 4
    mov ds:[bx + REC_X], ax
    ret

; BX = a pool B record set up as a player shot: type 2, sprite 32h, heading up,
; REC_FIELD_1C FFFFh (lives until out of bounds).
AllocPlayerShot:
    call AllocPoolBRecordEvicting
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 1
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_SPRITE], 032h
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], KIND_TYPED
    mov word ptr ds:[bx + REC_TYPE], 2
    mov word ptr ds:[bx + REC_FIELD_1C], 0FFFFh
    ret

; Fires a homing missile (type 0Ah) at FindMissileTarget's record when missiles remain
; and none is live. Without a target the allocated record is left inactive.
; REC_DIRECTION and REC_SPRITE are not set.
FireMissile:
    cmp word ptr ds:[MissileAmmo], 0
    jne loc_0A51D
    ret
loc_0A51D:
    cmp word ptr ds:[MissilesLive], 1
    jne loc_0A525
    ret
loc_0A525:
    call AllocPoolBRecordEvicting
    call CopyRecordPositionPlus10
    push bp
    mov bp, bx
    call FindMissileTarget
    mov ax, bx
    mov bx, bp
    pop bp
    cmp ax, 0FFFFh
    jne loc_0A53C
    ret
loc_0A53C:
    mov word ptr ds:[bx + REC_TARGET], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], KIND_TYPED
    mov word ptr ds:[bx + REC_TYPE], 0Ah
    mov word ptr ds:[bx + REC_FIELD_1C], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A568
    mov byte ptr ds:[SfxRequest], 011h
loc_0A568:
    inc word ptr ds:[MissilesLive]
    dec word ptr ds:[MissileAmmo]
    ret
; First DS:[BX+4] = SS:[BP+4]+10 modulo 65536; then DS:[BX+2] = SS:[BP+2]+10. AX holds the
; latter result. Order matters if memory aliases. Flags are from the second ADD.
CopyRecordPositionPlus10:
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 0Ah
    mov word ptr ds:[bx + REC_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 0Ah
    mov word ptr ds:[bx + REC_Y], ax
    ret

; Types 5 and 6 side shots from the player when side shots are enabled, one burst at a
; time.
FirePlayerSideShots:
    cmp word ptr ds:[SideShotsEnabled], 0
    jne loc_0A58C
    ret
loc_0A58C:
    cmp word ptr ds:[ShotsAtFireSide], 0
    je loc_0A594
    ret
loc_0A594:
    inc word ptr ds:[ShotsLiveSide]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A5A4
    mov byte ptr ds:[SfxRequest], 012h
loc_0A5A4:
    call AllocPlayerShot
    call CopyRecordPositionPlus10
    and word ptr ds:[bx + REC_X], 0FFFCh
    mov word ptr ds:[bx + REC_SPRITE], 8
    mov word ptr ds:[bx + REC_TYPE], 5
    inc word ptr ds:[ShotsLiveSide]
    call AllocPlayerShot
    call CopyRecordPositionPlus10
    and word ptr ds:[bx + REC_X], 0FFFCh
    mov word ptr ds:[bx + REC_SPRITE], 8
    mov word ptr ds:[bx + REC_TYPE], 6
    ret

; BP = record. LevelEndPhase = 0: two guarded REC_Y decrements (call, then fall through
; into DecRecordYUnlessAtMin again); otherwise one unguarded decrement.
DecRecordYByMode:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne loc_0A5E6
    call DecRecordYUnlessAtMin
; Decrement REC_Y unless it equals RECORD_Y_MIN. Equality guard only: smaller values
; still decrement.
DecRecordYUnlessAtMin:
    cmp word ptr ss:[bp + REC_Y], RECORD_Y_MIN
    jne loc_0A5E2
    ret
loc_0A5E2:
    dec word ptr ss:[bp + REC_Y]
    ret
loc_0A5E6:
    dec word ptr ss:[bp + REC_Y]
    ret

; Two guarded REC_Y increments: call IncRecordYUnlessAtMax, then fall through into it.
IncRecordYTwice:
    call IncRecordYUnlessAtMax
; Increment REC_Y unless it equals RECORD_Y_MAX. Equality guard only: larger values
; still increment.
IncRecordYUnlessAtMax:
    cmp word ptr ss:[bp + REC_Y], RECORD_Y_MAX
    jne loc_0A5F5
    ret
loc_0A5F5:
    inc word ptr ss:[bp + REC_Y]
    ret

; REC_X = max(REC_X - 2, 0): call DecRecordXUnlessZero, then fall through into it.
DecRecordXTwice:
    call DecRecordXUnlessZero
; Decrement REC_X unless it is zero.
DecRecordXUnlessZero:
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0A603
    ret
loc_0A603:
    dec word ptr ss:[bp + REC_X]
    ret

; REC_X += 2, saturating at RECORD_X_MAX: call IncRecordXBelowMax, then fall through.
IncRecordXTwice:
    call IncRecordXBelowMax
; Increment REC_X while it is below RECORD_X_MAX (unsigned).
IncRecordXBelowMax:
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
    jb loc_0A612
    ret
loc_0A612:
    inc word ptr ss:[bp + REC_X]
    ret

; BP = record; no-op while MapScrollPos <= B6h. Pushing against the right edge (REC_X =
; RECORD_X_MAX with IN_XPLUS) widens SidePodSpreadLeft by one up to 8; otherwise it
; relaxes back towards 0. UpdatePlacementXGroupA does the mirror for the left edge first.
UpdatePlacementXOffsetsAtRecordEdges:
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja loc_0A61F
    ret
loc_0A61F:
    call UpdatePlacementXGroupA
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
    jne loc_0A63C
    test byte ptr ds:[InputBits], IN_XPLUS
    je loc_0A63C
    cmp word ptr ds:[SidePodSpreadLeft], 8
    je loc_0A63B
    inc word ptr ds:[SidePodSpreadLeft]
loc_0A63B:
    ret
loc_0A63C:
    cmp word ptr ds:[SidePodSpreadLeft], 0
    je loc_0A647
    dec word ptr ds:[SidePodSpreadLeft]
loc_0A647:
    ret

; BP = record. Pushing against the left edge (REC_X = 0 with IN_XMINUS) moves
; SidePodSpreadRight down by one to -8; otherwise it relaxes back towards 0.
; Guards are equality checks, not clamps.
UpdatePlacementXGroupA:
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0A662
    test byte ptr ds:[InputBits], IN_XMINUS
    je loc_0A662
    cmp word ptr ds:[SidePodSpreadRight], -8
    jne loc_0A65D
    ret
loc_0A65D:
    dec word ptr ds:[SidePodSpreadRight]
    ret
loc_0A662:
    cmp word ptr ds:[SidePodSpreadRight], 0
    jne loc_0A66A
    ret
loc_0A66A:
    inc word ptr ds:[SidePodSpreadRight]
    ret

; Scrolls one line unless an encounter or the level end holds the map; at MapScrollPos
; 0EA0h starts the level end (smart bomb, four type 53h records).
ScrollForwardAndCheckLevelEnd:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    je loc_0A679
    jmp near ptr loc_0A6FD
loc_0A679:
    cmp word ptr ds:[EncounterLiveCount], 0
    jne loc_0A6FD
    cmp word ptr ds:[EncounterEndDelay], 0
    jne loc_0A6FD
    call ScrollForwardOneLine
    cmp word ptr ds:[ScrollSubRow], 0
    jne loc_0A6FD
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
    mov si, offset DacColor6Default
    cmp word ptr ds:[MapScrollPos], MAP_LAST_SPAWN_POS
    jne loc_0A6A8
    call SetDacColor6
loc_0A6A8:
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    cmp word ptr ds:[MapScrollPos], MAP_END_POS
    jne loc_0A6FD
    mov word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    call SmartBombAll
    mov si, offset Type53SpawnTable
    mov cx, 4
loc_0A6C8:
    push cx
    push si
    call FindFreeRecordPoolA
    pop si
    cmp bx, -1
    je loc_0A6FA
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 2
    mov word ptr ds:[bx + REC_KIND], KIND_ENEMY
    mov word ptr ds:[bx + REC_TYPE], 053h
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
    lodsw
    mov word ptr ds:[bx + REC_SPRITE], ax
    mov word ptr ds:[bx + REC_FIELD_36], ax
loc_0A6FA:
    pop cx
    loop loc_0A6C8
loc_0A6FD:
    ret

; ScrollDeltaY + 1; moves ScrollWindowOffset up one row, entering a new map row every 16
; lines. Preserves BP.
ScrollForwardOneLine:
    push bp
    add word ptr ds:[ScrollDeltaY], 1
    mov word ptr ds:[ScrollingBackward], 0
    cmp word ptr ds:[ScrollSubRow], 0
    jne loc_0A714
    call EnterNextMapRowForward
loc_0A714:
    dec word ptr ds:[ScrollSubRow]
    and word ptr ds:[ScrollSubRow], 0Fh
    jne loc_0A72F
    cmp word ptr ds:[LastTileStepBackward], 0
    je loc_0A72F
    add word ptr ds:[MapScrollPos], MAP_ROW_BYTES
    dec word ptr ds:[LevelScriptClock]
loc_0A72F:
    mov ax, word ptr cs:[ScrollBandBytes]
    cmp word ptr ds:[ScrollWindowOffset], ax
    jne loc_0A73C
    call WrapScrollWindowForward
loc_0A73C:
    mov ax, word ptr cs:[PlayfieldRowBytes]
    sub word ptr ds:[ScrollWindowOffset], ax
loc_0A744:
    pop bp
    ret

WrapScrollWindowForward:
    mov ax, word ptr cs:[ScrollWrapOffset]
    mov word ptr ds:[ScrollWindowOffset], ax
    ret

; Draws the incoming map row, MapScrollPos + 0Dh, LevelScriptClock - 1.
EnterNextMapRowForward:
    call DrawMapRowIntoScrollBand
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja loc_0A765
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A765
    mov byte ptr ds:[SfxRequest], 7
loc_0A765:
    add word ptr ds:[MapScrollPos], MAP_ROW_BYTES
    dec word ptr ds:[LevelScriptClock]
    mov al, 5
    cmp word ptr ds:[LevelScriptClock], 4
    jne loc_0A77A
    call RequestModuleMusic
loc_0A77A:
    mov word ptr ds:[LastTileStepBackward], 0
    ret

; Mirror of ScrollForwardOneLine (no-op at MapScrollPos 0). Preserves BP.
ScrollBackwardOneLine:
    push bp
    mov word ptr ds:[ScrollingBackward], 1
    cmp word ptr ds:[MapScrollPos], 0
    je loc_0A744
    add word ptr ds:[ScrollDeltaY], -1
    cmp word ptr ds:[ScrollSubRow], 0
    jne loc_0A79E
    call EnterPreviousMapRowBackward
loc_0A79E:
    inc word ptr ds:[ScrollSubRow]
    and word ptr ds:[ScrollSubRow], 0Fh
    jne loc_0A7B9
    cmp word ptr ds:[LastTileStepBackward], 1
    je loc_0A7B9
    sub word ptr ds:[MapScrollPos], MAP_ROW_BYTES
    inc word ptr ds:[LevelScriptClock]
loc_0A7B9:
    mov ax, word ptr cs:[ScrollWrapOffset]
    cmp word ptr ds:[ScrollWindowOffset], ax
    jne loc_0A7C6
    call WrapScrollWindowBackward
loc_0A7C6:
    mov ax, word ptr cs:[PlayfieldRowBytes]
    add word ptr ds:[ScrollWindowOffset], ax
    pop bp
    ret

; Draws the incoming map row, MapScrollPos - 0Dh, LevelScriptClock + 1.
EnterPreviousMapRowBackward:
    call DrawMapRowIntoScrollBand
    sub word ptr ds:[MapScrollPos], MAP_ROW_BYTES
    inc word ptr ds:[LevelScriptClock]
    mov word ptr ds:[LastTileStepBackward], 1
    ret

WrapScrollWindowBackward:
    mov ax, word ptr cs:[ScrollBandBytes]
    mov word ptr ds:[ScrollWindowOffset], ax
    ret

; Draws the incoming map row above ScrollWindowOffset and copies it ScrollMirrorDistance
; further down (the wrap mirror).
DrawMapRowIntoScrollBand:
    mov di, word ptr ds:[ScrollWindowOffset]
    sub di, word ptr cs:[ScrollBandBytes]
    call DrawIncomingMapRow
    mov si, word ptr ds:[ScrollWindowOffset]
    sub si, word ptr cs:[ScrollBandBytes]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov di, si
    add di, word ptr cs:[ScrollMirrorDistance]
    mov cx, word ptr cs:[ScrollBandBytes]
    shr cx, 1
    rep movsw
    mov ds, word ptr cs:[MainDataSegment]
    ret

; DI = workspace band. Forward (up to MapScrollPos 0E52h) also spawns the row's objects
; and runs the level script.
DrawIncomingMapRow:
    mov bx, word ptr ds:[MapScrollPos]
    cmp word ptr ds:[ScrollingBackward], 1
    jne loc_0A82D
    sub bx, 0A9h
    jmp near ptr DrawMapRowBlocks
loc_0A82D:
    mov word ptr ds:[MapRowCursor], bx
    cmp word ptr ds:[MapScrollPos], MAP_LAST_SPAWN_POS
    ja loc_0A83F
    call SpawnFromMapRow
    call RunLevelScriptEvents
loc_0A83F:
    mov bx, word ptr ds:[MapScrollPos]
    jmp near ptr DrawMapRowBlocks

; Per frame: draws all live records, stars and the level-end extra record into the
; workspace, by pool and draw pass.
DrawRecordsToWorkspace:
    mov cx, POOL_A_POINTER_COUNT
loc_0A849:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A85B
    call SaveRecordBackground
loc_0A85B:
    pop cx
    loop loc_0A849
    mov cx, POOL_B_COUNT
loc_0A861:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A873
    call SaveRecordBackground
loc_0A873:
    pop cx
    loop loc_0A861
    call DrawStars
    mov cx, POOL_B_COUNT
loc_0A87C:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A88E
    call DrawSprite8Record
loc_0A88E:
    pop cx
    loop loc_0A87C
    mov cx, POOL_A_COUNT
loc_0A894:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A8C1
    cmp word ptr ds:[DemoActive], 1
    je loc_0A8B8
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja loc_0A8B8
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je loc_0A8C1
loc_0A8B8:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 0
    jne loc_0A8C1
    call DrawRecordSprite
loc_0A8C1:
    pop cx
    loop loc_0A894
    mov cx, POOL_A_POINTER_COUNT
loc_0A8C7:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A8F4
    cmp word ptr ds:[DemoActive], 1
    je loc_0A8EB
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja loc_0A8EB
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je loc_0A8F4
loc_0A8EB:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 1
    jne loc_0A8F4
    call DrawRecordSprite
loc_0A8F4:
    pop cx
    loop loc_0A8C7
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne loc_0A8FF
    ret
loc_0A8FF:
    mov bp, word ptr ds:[AutoMoveExtraRecord]
    cmp bp, -1
    je loc_0A90B
    call DrawRecordSprite
loc_0A90B:
    ret

; Undoes DrawRecordsToWorkspace from each record's REC_SAVE_BUFFER, then EraseStars.
RestoreRecordBackgrounds:
    mov cx, POOL_B_COUNT
loc_0A90F:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A921
    call RestoreRecordBackground
loc_0A921:
    pop cx
    loop loc_0A90F
    mov cx, POOL_A_POINTER_COUNT
loc_0A927:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A939
    call RestoreRecordBackground
loc_0A939:
    pop cx
    loop loc_0A927
    call EraseStars
    ret

; Per frame: march, type 93h and segmented-boss state, then UpdateRecordByKind for pool
; A and pool B, then MoveStars.
UpdateAllRecords:
    cmp word ptr ds:[FramesSinceInvaderSpawn], -1
    je loc_0A94B
    inc word ptr ds:[FramesSinceInvaderSpawn]
loc_0A94B:
    mov ax, word ptr ds:[InvaderNextMarchLeft]
    mov word ptr ds:[InvaderMarchLeft], ax
    mov ax, word ptr ds:[InvaderNextDropStep]
    mov word ptr ds:[InvaderDropStep], ax
    mov word ptr ds:[InvaderNextDropStep], 0
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0A9BD
    cmp byte ptr ds:[MarchEdgeHit], 0
    je loc_0A97B
    neg word ptr ds:[MarchStepX]
    mov byte ptr ds:[MarchEdgeHit], 0
    mov byte ptr ds:[MarchDropNow], 1
    jmp short loc_0A980
loc_0A97B:
    mov byte ptr ds:[MarchDropNow], 0
loc_0A980:
    xor cl, cl
    cmp byte ptr ds:[MarchDelay], 0
    je loc_0A9A9
    dec byte ptr ds:[MarchDelay]
    jne loc_0A9B3
    mov ax, word ptr ds:[EncounterLiveCount]
    mov cl, 0Ah
    cmp ax, 010h
    ja loc_0A9A9
    mov cl, 6
    cmp ax, 8
    ja loc_0A9A9
    mov cl, 4
    cmp ax, 4
    ja loc_0A9A9
    mov cl, 1
loc_0A9A9:
    mov byte ptr ds:[MarchDelay], cl
    inc byte ptr ds:[MarchStepNow]
    jmp short loc_0A9B8
loc_0A9B3:
    mov byte ptr ds:[MarchStepNow], 0
loc_0A9B8:
    call far ptr StepMarchFireDelay
loc_0A9BD:
    mov byte ptr ds:[Type93KilledPulse], 0
    cmp byte ptr ds:[Type93KilledLatch], 0
    je loc_0A9D3
    mov byte ptr ds:[Type93KilledLatch], 0
    mov byte ptr ds:[Type93KilledPulse], 1
loc_0A9D3:
    cmp word ptr ds:[SegBossActive], 1
    jne loc_0A9DD
    call SteerSegBossAlongPath
loc_0A9DD:
    mov cx, POOL_A_COUNT
loc_0A9E0:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    inc word ptr ds:[RecordTickCounter]
    cmp word ptr ds:[RecordTickCounter], 05DCh
    jb loc_0A9FB
    mov word ptr ds:[RecordTickCounter], 0
loc_0A9FB:
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0AA04
    call UpdateRecordByKind
loc_0AA04:
    pop cx
    loop loc_0A9E0
    mov word ptr ds:[SwayDropY], 0
    mov cx, POOL_B_COUNT
loc_0AA10:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0AA22
    call UpdateRecordByKind
loc_0AA22:
    pop cx
    loop loc_0AA10
    call far ptr MoveStars
    ret

; BP = record: run its REC_KIND handler (KindHandlers).
UpdateRecordByKind:
    mov bx, word ptr ss:[bp + REC_KIND]
    shl bx, 1
    jmp word ptr cs:[bx + KindHandlers]
    even
KindHandlers label word
    dw offset ScrollRecordThenFinish, offset UpdatePod, offset RunTypeHandler, offset CountXReturn
    dw offset RunTypeHandler, offset UpdatePickup, offset UpdateExhaust
loc_0AA44:
    clc
    ret
; BP = record: CF when within 10h of the player's hit point; NC above the playfield or
; while the ship is dying.
SmallRecordHitsPlayer:
    mov ax, word ptr ss:[bp + REC_Y]
    or ax, ax
    js loc_0AA44
    mov si, word ptr ds:[PrimaryRecord + REC_SPRITE]
    cmp si, 3
    jae loc_0AA44
    shl si, 1
    shl si, 1
    add si, offset PlayerHitOffsets
    lodsw
    add ax, word ptr ds:[PrimaryRecord + REC_Y]
    mov word ptr ds:[UpgradeHitY], ax
    lodsw
    add ax, word ptr ds:[PrimaryRecord + REC_X]
    mov word ptr ds:[UpgradeHitX], ax
    jmp near ptr loc_08331
; BP = size class 2 record: CF when the player's box overlaps it.
LargeRecordHitsPlayer:
    mov ax, word ptr ss:[bp + REC_Y]
    or ax, ax
    js loc_0AA44
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 018h
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jl loc_0AA44
    sub ax, 02Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jg loc_0AA44
    cmp word ptr ds:[SegBossActive], 1
    jne loc_0AAAB
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 8
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jb loc_0AA44
    sub ax, 0Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    ja loc_0AA44
    stc
    ret
loc_0AAAB:
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 018h
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jb loc_0AA44
    sub ax, 02Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    ja loc_0AA44
    stc
    ret
UpdatePickup:
    inc word ptr ss:[bp + REC_Y]
    call SmallRecordHitsPlayer
    jb loc_0AACD
    jmp near ptr ScrollRecordThenFinish
loc_0AACD:
    call CollectPickup
    jmp near ptr ScrollRecordThenFinish
CollectPickup:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb loc_0AADB
    ret
loc_0AADB:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0AAE7
    mov byte ptr ds:[SfxRequest], 7
loc_0AAE7:
    mov bx, 020h
    call AddScoreBcd
    push bp
; The handlers return into PickupDone (the table's last entry) to free the pickup.
    push word ptr cs:[PickupHandlers + 0Ah]
    mov bx, word ptr ss:[bp + REC_ITEM_INDEX]
    mov bp, offset PrimaryRecord
    shl bx, 1
    jmp word ptr cs:[bx + PickupHandlers]
PickupHandlers label word
    dw offset CountXReturn, offset PickupUpgradeSelector, offset PickupEnergy, offset SmartBombAll
    dw offset PickupFuel, offset PickupDone
PickupDone:
    pop bp
    jmp near ptr RemoveRecord
; BP = the exhaust: animates it under the ship; freed silently once the ship form is
; 3 or more (destroyed) or LevelEndPhase is 3 or more.
UpdateExhaust:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb loc_0AB1A
    jmp near ptr FreeRecordSilently
loc_0AB1A:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_REFILL
    jb loc_0AB24
    jmp near ptr FreeRecordSilently
loc_0AB24:
    mov ax, word ptr ds:[SlowCount8]
    mov bx, offset ExhaustFrames
    xlat
    add ax, 9
    mov word ptr ss:[bp + REC_SPRITE], ax
    mov dx, offset ExhaustOffsets
; BP = record, DX = (Y, X) table: places BP at the player's position plus the entry for
; the ship form (PrimaryRecord REC_SPRITE 0..2).
PlaceAtPlayerOffset:
    mov bx, offset PrimaryRecord
    mov si, word ptr ds:[bx + REC_SPRITE]
    shl si, 1
    shl si, 1
    add si, dx
    lodsw
    add ax, word ptr ds:[bx + REC_Y]
    mov word ptr ss:[bp + REC_Y], ax
    lodsw
    add ax, word ptr ds:[bx + REC_X]
    mov word ptr ss:[bp + REC_X], ax
    ret
AnimateSidePodSprite:
    mov ax, word ptr ds:[SlowCount4]
    add ax, 018h
    mov word ptr ss:[bp + REC_SPRITE], ax
    ret
UpdateSidePodRightOuter:
    mov word ptr ds:[CurrentSidePodSlot], offset SidePodRightOuter
    jmp short UpdateSidePod
UpdateSidePodLeftOuter:
    mov word ptr ds:[CurrentSidePodSlot], offset SidePodLeftOuter
    jmp short UpdateSidePod
UpdateSidePodRightInner:
    mov word ptr ds:[CurrentSidePodSlot], offset SidePodRightInner
    jmp short UpdateSidePod
UpdateSidePodLeftInner:
    mov word ptr ds:[CurrentSidePodSlot], offset SidePodLeftInner
; Side pods: animate, place (PlaceSidePods runs elsewhere), and lose the pod on terrain
; or on an enemy collision that takes its last hit point. When the collision kills it,
; DestroyRecordAtBX runs on the enemy a second time (original behaviour: score, sfx and
; group count twice).
UpdateSidePod:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_0AB8F
    call AnimateSidePodSprite
    call PodTerrainHit
    jb loc_0AB8F
    call PodCollideRecords
    jb loc_0AB8C
    ret
loc_0AB8C:
    call DestroyRecordAtBX
loc_0AB8F:
    mov bx, word ptr ds:[CurrentSidePodSlot]
    mov word ptr ds:[bx], 0FFFFh
    jmp short ExplodePod
; DestroyRecord for BX, preserving BP.
DestroyRecordAtBX:
    push bp
    mov bp, bx
    call DestroyRecord
    mov bx, bp
    pop bp
    ret
; BX = offset of its TrailingPod* slot. Trailing pods have no terrain check.
UpdateTrailingPod:
    mov word ptr ds:[CurrentTrailingPodSlot], bx
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_0ABC0
    mov ax, word ptr ds:[SlowCount4]
    add ax, 014h
    mov word ptr ss:[bp + REC_SPRITE], ax
    call PodCollideRecords
    jb loc_0ABBD
    ret
loc_0ABBD:
    call DestroyRecordAtBX
loc_0ABC0:
    mov bx, word ptr ds:[CurrentTrailingPodSlot]
    mov word ptr ds:[bx], 0FFFFh
    jmp short ExplodePod
UpdateFrontPod:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_0ABDC
    mov dx, offset FrontPodOffsets
    call PlaceAtPlayerOffset
    call PodTerrainHit
    jae loc_0ABE4
loc_0ABDC:
    mov word ptr ds:[FrontPodRecord], 0FFFFh
    jmp short ExplodePod
loc_0ABE4:
    call PodCollideRecords
    jb loc_0ABEA
    ret
loc_0ABEA:
    mov word ptr ds:[FrontPodRecord], 0FFFFh
    call DestroyRecordAtBX
; Shared tail: turns the lost pod BP into a dying enemy (type 1), then refreshes the
; upgrade display.
ExplodePod:
    cmp bp, -1
    jne loc_0ABF9
    ret
loc_0ABF9:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0AC05
    mov byte ptr ds:[SfxRequest], 019h
loc_0AC05:
    mov word ptr ss:[bp + REC_TYPE], 1
    mov word ptr ss:[bp + REC_KIND], KIND_ENEMY
    mov word ptr ss:[bp + REC_ANIM_COUNTER], 0
    mov word ptr ss:[bp + REC_SPRITE], 0
loc_0AC19:
    push bp
    call AdvanceToAvailableUpgrade
    call DrawUpgradeSlots
    pop bp
    ret
FreeRecordSilently:
    mov word ptr ss:[bp + REC_STATUS], 0
    ret
; CF when terrain contact took BP's last hit point; always NC in the demo or when
; LevelEndPhase is not 0.
PodTerrainHit:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    je loc_0AC32
    jmp near ptr loc_0AA44
loc_0AC32:
    cmp word ptr ds:[DemoActive], 1
    jne ProbeGridForRecordResponse
    jmp near ptr loc_0AA44
; Part of PodTerrainHit. Test the map cell at grid offset + 13 and, when X is not
; cell-aligned, its right neighbour; a nonzero attribute is a hit. The FFFFh
; negative-Y result of ComputeRecordGridOffset is not checked (+13 wraps to 000Ch).
ProbeGridForRecordResponse:
    call ComputeRecordGridOffset
    add bx, 0Dh
    call ReadIndexedByteAttribute
    jne SetResponseAndStepRecordCounter
    test word ptr ss:[bp + REC_X], 0Fh
    je RecordResponseReturnClear
    inc bx
    call ReadIndexedByteAttribute
    jne SetResponseAndStepRecordCounter
; Shared NC return of the probe and of SetResponseAndStepRecordCounter.
RecordResponseReturnClear:
    clc
    ret
; BP = pod that was hit (by terrain, or from PodCollideRecords). Request sound 0Eh and
; flash 5 frames; lose a hit point unless DifficultySetting = 0 and CountGate2324 != 1.
; CF = 1 when the last hit point is lost (flash cancelled); 0 HP would wrap to FFFFh.
SetResponseAndStepRecordCounter:
    cmp byte ptr ds:[SfxEnabled], 0
    je SetRecordResponseWord
    mov byte ptr ds:[SfxRequest], 0Eh
SetRecordResponseWord:
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    cmp word ptr ds:[DifficultySetting], 0
    jne StepRecordResponseCounter
    cmp word ptr ds:[CountGate2324], 1
    jne RecordResponseReturnClear
StepRecordResponseCounter:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    jne RecordResponseReturnClear
    mov word ptr ss:[bp + REC_FLASH_TIMER], 0
    stc
    ret
; BP = pod: the first live size-1 pool A record within 10h: a pickup is collected (NC);
; an enemy is destroyed and the pod loses a hit point (CF when it was the last). Always
; NC in the demo.
PodCollideRecords:
    cmp word ptr ds:[DemoActive], 1
    jne loc_0AC8B
    jmp near ptr loc_0AA44
loc_0AC8B:
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
    mov ax, word ptr ss:[bp + REC_X]
    mov di, word ptr ss:[bp + REC_Y]
loc_0AC97:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0ACD2
    cmp word ptr ds:[bx + REC_TYPE], 1
    je loc_0ACD2
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    jne loc_0ACD2
    mov si, word ptr ds:[bx + REC_Y]
    add si, 010h
    cmp di, si
    jg loc_0ACD2
    sub si, 020h
    cmp di, si
    jl loc_0ACD2
    mov si, word ptr ds:[bx + REC_X]
    add si, 010h
    cmp ax, si
    jg loc_0ACD2
    sub si, 020h
    cmp ax, si
    jl loc_0ACD2
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    cmp si, word ptr ds:[bx + REC_SAVE_BUFFER]
    jne loc_0ACD9
loc_0ACD2:
    add bx, RECORD_SIZE
    loop loc_0AC97
    clc
    ret
loc_0ACD9:
    cmp word ptr ds:[bx + REC_KIND], KIND_PICKUP
    je loc_0ACF9
; Always taken: the scan only accepts size class 1.
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je loc_0ACE8
    jmp near ptr loc_05059
loc_0ACE8:
    cmp word ptr ds:[bx + REC_KIND], KIND_ENEMY
    jne loc_0ACD2
    call DestroyRecordAtBX
; Record scan shares the same response/counter path as the grid attribute probe.
    call SetResponseAndStepRecordCounter
    jb loc_0ACF7
    ret
loc_0ACF7:
    stc
    ret
loc_0ACF9:
    push bp
    mov bp, bx
    call CollectPickup
    mov bx, bp
    pop bp
    clc
    ret
UpdatePod:
    cmp word ptr ds:[DemoActive], 1
    je loc_0AD14
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja loc_0AD14
    ret
loc_0AD14:
    cmp word ptr ss:[bp + REC_SPRITE], 0Fh
    jne loc_0AD1D
    jmp near ptr UpdateFrontPod
loc_0AD1D:
    cmp bp, word ptr ds:[SidePodLeftInner]
    jne loc_0AD26
    jmp near ptr UpdateSidePodLeftInner
loc_0AD26:
    cmp bp, word ptr ds:[SidePodRightInner]
    jne loc_0AD2F
    jmp near ptr UpdateSidePodRightInner
loc_0AD2F:
    cmp bp, word ptr ds:[SidePodLeftOuter]
    jne loc_0AD38
    jmp near ptr UpdateSidePodLeftOuter
loc_0AD38:
    cmp bp, word ptr ds:[SidePodRightOuter]
    jne loc_0AD41
    jmp near ptr UpdateSidePodRightOuter
loc_0AD41:
    mov bx, offset TrailingPodNear
    cmp bp, word ptr ds:[TrailingPodNear]
    jne loc_0AD4D
    jmp near ptr UpdateTrailingPod
loc_0AD4D:
    mov bx, offset TrailingPodFar
    cmp bp, word ptr ds:[TrailingPodFar]
    jne loc_0AD59
    jmp near ptr UpdateTrailingPod
loc_0AD59:
    ret
; Shot tail: scrolls, then the bounds test below.
ShotScrollAndBounds:
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
; Removes the shot outside Y 8..E0h or past X C8h, or a player shot hitting a wall.
ShotBoundsCheck:
    cmp word ptr ss:[bp + REC_Y], 8
    jae loc_0AD69
    jmp near ptr RemoveRecord
loc_0AD69:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe loc_0AD73
    jmp near ptr RemoveRecord
loc_0AD73:
    cmp word ptr ss:[bp + REC_X], 0C8h
    jbe loc_0AD7D
    jmp near ptr RemoveRecord
loc_0AD7D:
    cmp word ptr ss:[bp + REC_KIND], KIND_TYPED
    jne loc_0ADC8
    cmp word ptr ss:[bp + REC_TYPE], 2
    je loc_0ADAF
    cmp word ptr ss:[bp + REC_TYPE], 4
    je loc_0ADAF
    cmp word ptr ss:[bp + REC_TYPE], 0Ch
    je loc_0ADAF
    cmp word ptr ss:[bp + REC_TYPE], 5
    je loc_0ADAF
    cmp word ptr ss:[bp + REC_TYPE], 6
    je loc_0ADAF
    cmp word ptr ss:[bp + REC_TYPE], 9
    je loc_0ADAF
    cmp word ptr ss:[bp + REC_TYPE], 8
    je loc_0ADAF
    jmp short loc_0ADC8
loc_0ADAF:
    cmp word ptr ds:[DemoActive], 1
    je loc_0ADC8
; Remove the record when the cell at grid offset + 13 has attribute 1 exactly
; (the FFFFh negative-Y result is again not checked).
    call ComputeRecordGridOffset
    add bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0ADC8
    dec al
    jne loc_0ADC8
    jmp near ptr RemoveRecord
loc_0ADC8:
    ret
; Removes the shot through the bounds test (Y = FFFFh).
ExpireShot:
    mov word ptr ss:[bp + REC_Y], 0FFFFh
    jmp short ShotBoundsCheck
loc_0ADD0:
    inc word ptr ss:[bp + REC_Y]
    inc word ptr ss:[bp + REC_Y]
    jmp near ptr ShotHitPlayerCheck
; Rises 16 px per frame; counted in ShotsLiveMain.
Type08RisingShot16:
    sub word ptr ss:[bp + REC_Y], 10h
    jmp short ShotBoundsCheck
; Rises 3 px per frame (no scroll); counted in ShotsLiveMain.
Type07RisingShot3:
    mov ax, ds:[FrameCount4]
    add ax, 5Ah
    mov ss:[bp + REC_SPRITE], ax
    sub word ptr ss:[bp + REC_Y], 3
    jmp near ptr ShotBoundsCheck
; Only the shot bounds tail; its position is set elsewhere (ShotsLiveType9). Role
; uncertain.
Type09ExternallyMovedShot:
    jmp near ptr ShotBoundsCheck
; 2 px per frame in REC_DIRECTION until REC_FIELD_1C runs out, then the player-hit test.
Type0FTimedShot2:
    mov ax, ds:[FrameCount16]
    shr ax, 1
    add ax, 0
    mov ss:[bp + REC_SPRITE], ax
    dec word ptr ss:[bp + REC_FIELD_1C]
    je ExpireShot
    mov ax, 0B250h
    push ax
    jmp near ptr MoveInDirection2
; 3 px per frame in REC_DIRECTION while REC_FIELD_1C counts down, then turns straight
; up.
Type0CTimedTurnUpShot:
    cmp word ptr ss:[bp + REC_FIELD_1C], 0
    je loc_0AE19
    dec word ptr ss:[bp + REC_FIELD_1C]
    jne loc_0AE1D
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
loc_0AE19:
    sub word ptr ss:[bp + REC_Y], 2
loc_0AE1D:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 28h
    mov ss:[bp + REC_SPRITE], ax
    call MoveInDirection3
    jmp near ptr ShotBoundsCheck
; Mirror of type 05h drifting up-right; removed at X = C0h.
Type06SideShotUpRight:
    cmp word ptr ss:[bp + REC_X], 0C8h
    je ExpireShot
    sub word ptr ss:[bp + REC_Y], 4
    test word ptr ss:[bp + REC_X], 7
    jne loc_0AE5E
    test word ptr ss:[bp + REC_X], 8
    je loc_0AE5E
    cmp word ptr ds:[DemoActive], 1
    je loc_0AE5E
    call ComputeRecordGridOffset
    add bx, 0Eh
    call ReadIndexedByteAttribute
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    cmp al, 1
    je loc_0AE67
loc_0AE5E:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
    add word ptr ss:[bp + REC_X], 4
loc_0AE67:
    mov ax, ds:[FrameCount4]
    shl ax, 1
    shl ax, 1
    and ax, 8
    add ax, ss:[bp + REC_DIRECTION]
    add ax, 8
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr ShotScrollAndBounds
; Rises 4 px per frame; every 16 px of X probes the map: a wall turns it straight up,
; otherwise it keeps drifting up-left.
Type05SideShotUpLeft:
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0AE86
    jmp near ptr ExpireShot
loc_0AE86:
    sub word ptr ss:[bp + REC_Y], 4
    test word ptr ss:[bp + REC_X], 0Fh
    jne loc_0AEAA
    cmp word ptr ds:[DemoActive], 1
    je loc_0AEAA
    call ComputeRecordGridOffset
    add bx, 0Ch
    call ReadIndexedByteAttribute
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    cmp al, 1
    je loc_0AEB3
loc_0AEAA:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
    sub word ptr ss:[bp + REC_X], 4
loc_0AEB3:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 8
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr ShotScrollAndBounds
; 4 px per frame in REC_DIRECTION (8 px on level 0 unless heading down), then the
; player-hit test; the SpawnThrottledChild shot.
Type04StraightShot:
    mov ax, 0B250h
    push ax
    cmp word ptr ds:[LevelIndex], 0
    je loc_0AECD
    jmp near ptr MoveInDirection4
loc_0AECD:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jne loc_0AED6
    jmp near ptr MoveInDirection4
loc_0AED6:
    jmp short MoveInDirection8
; Types 02h/03h: 8 px per frame in REC_DIRECTION until REC_FIELD_1C runs out, then the
; player-hit test; type 3 hits deal 1/3/5 damage by difficulty.
Type02TimedStraightShot:
    dec word ptr ss:[bp + REC_FIELD_1C]
    jne loc_0AEE0
    jmp near ptr ExpireShot
loc_0AEE0:
    mov ax, 0B250h
    push ax
MoveInDirection8:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + Move8ByDirection]
Move8ByDirection label word
    dw offset loc_0AF0B, offset loc_0AF10, offset loc_0AF14, offset loc_0AEFE
    dw offset loc_0AF02, offset loc_0AF19, offset loc_0AF1D, offset loc_0AF07
loc_0AEFE:
    add word ptr ss:[bp + REC_X], 8
loc_0AF02:
    add word ptr ss:[bp + REC_Y], 8
    ret
loc_0AF07:
    sub word ptr ss:[bp + REC_X], 8
loc_0AF0B:
    sub word ptr ss:[bp + REC_Y], 8
    ret
loc_0AF10:
    sub word ptr ss:[bp + REC_Y], 8
loc_0AF14:
    add word ptr ss:[bp + REC_X], 8
    ret
loc_0AF19:
    add word ptr ss:[bp + REC_Y], 8
loc_0AF1D:
    sub word ptr ss:[bp + REC_X], 8
    ret
MoveInDirection3:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0AF22Cases]
loc_0AF22Cases label word
    dw offset loc_0AF49, offset loc_0AF4E, offset loc_0AF52, offset loc_0AF3C
    dw offset loc_0AF40, offset loc_0AF57, offset loc_0AF5B, offset loc_0AF45
loc_0AF3C:
    add word ptr ss:[bp + REC_X], 3
loc_0AF40:
    add word ptr ss:[bp + REC_Y], 3
    ret
loc_0AF45:
    sub word ptr ss:[bp + REC_X], 3
loc_0AF49:
    sub word ptr ss:[bp + REC_Y], 3
    ret
loc_0AF4E:
    sub word ptr ss:[bp + REC_Y], 3
loc_0AF52:
    add word ptr ss:[bp + REC_X], 3
    ret
loc_0AF57:
    add word ptr ss:[bp + REC_Y], 3
loc_0AF5B:
    sub word ptr ss:[bp + REC_X], 3
    ret
MoveInDirection4:
    call MoveInDirection2
MoveInDirection2:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + Move2ByDirection]
    even
Move2ByDirection label word
    dw offset loc_0AF8B, offset loc_0AF90, offset loc_0AF94, offset loc_0AF7E
    dw offset loc_0AF82, offset loc_0AF99, offset loc_0AF9D, offset loc_0AF87
loc_0AF7E:
    add word ptr ss:[bp + REC_X], 2
loc_0AF82:
    add word ptr ss:[bp + REC_Y], 2
    ret
loc_0AF87:
    sub word ptr ss:[bp + REC_X], 2
loc_0AF8B:
    sub word ptr ss:[bp + REC_Y], 2
    ret
loc_0AF90:
    sub word ptr ss:[bp + REC_Y], 2
loc_0AF94:
    add word ptr ss:[bp + REC_X], 2
    ret
loc_0AF99:
    add word ptr ss:[bp + REC_Y], 2
loc_0AF9D:
    sub word ptr ss:[bp + REC_X], 2
    ret
MoveInDirection1:
    mov bx, ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + Move1ByDirection]
Move1ByDirection label word
    dw offset loc_0AFC6, offset loc_0AFCA, offset loc_0AFCD, offset loc_0AFBC
    dw offset loc_0AFBF, offset loc_0AFD1, offset loc_0AFD4, offset loc_0AFC3
loc_0AFBC:
    inc word ptr ss:[bp + REC_X]
loc_0AFBF:
    inc word ptr ss:[bp + REC_Y]
    ret
loc_0AFC3:
    dec word ptr ss:[bp + REC_X]
loc_0AFC6:
    dec word ptr ss:[bp + REC_Y]
    ret
loc_0AFCA:
    dec word ptr ss:[bp + REC_Y]
loc_0AFCD:
    inc word ptr ss:[bp + REC_X]
    ret
loc_0AFD1:
    inc word ptr ss:[bp + REC_Y]
loc_0AFD4:
    dec word ptr ss:[bp + REC_X]
    ret
; Moves BP 1 px in REC_DIRECTION unless the map blocks it; NZ (and TerrainBlocked = 1) when blocked.
TryTerrainStep:
    mov word ptr ds:[TerrainBlocked], 0
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[TerrainStartY], ax
    mov word ptr ds:[TerrainProbeY], ax
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[TerrainStartX], ax
    mov word ptr ds:[TerrainProbeX], ax
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
    sub word ptr ss:[bp + REC_Y], 010h
    call TerrainStepInDirection
    add word ptr ss:[bp + REC_Y], 010h
    mov ax, word ptr ds:[ScrollDeltaY]
    sub word ptr ss:[bp + REC_Y], ax
    cmp word ptr ds:[TerrainBlocked], 0
    ret
; Sibling grid consumer explicitly rejects BX=FFFF; grid-helper flags are dead.
; Body of TryTerrainStep; diagonals are two axis steps.
TerrainStepInDirection:
    call ComputeRecordGridOffset
    cmp bx, -1
    je loc_0B032
    mov dx, bx
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0B00DCases]
    even
loc_0B00DCases label word
    dw offset TerrainStepUp, offset loc_0B0C9, offset TerrainStepRight, offset loc_0B039
    dw offset TerrainStepDown, offset loc_0B10C, offset TerrainStepLeft, offset loc_0B07A
loc_0B032:
    mov word ptr ds:[TerrainBlocked], 1
    ret
loc_0B039:
    call TerrainStepRight
TerrainStepDown:
    mov bx, dx
    sub bx, 0Dh
    call ReadIndexedByteAttribute
    jne loc_0B032
    test word ptr ss:[bp + REC_X], 0Fh
    je loc_0B053
    inc bx
    call ReadIndexedByteAttribute
    jne loc_0B032
loc_0B053:
    inc word ptr ss:[bp + REC_Y]
    inc word ptr ds:[TerrainProbeY]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae loc_0B06A
    dec word ptr ss:[bp + REC_Y]
    dec word ptr ds:[TerrainProbeY]
    jmp short loc_0B032
loc_0B06A:
    inc word ptr ds:[GridYSum]
    and word ptr ds:[GridYSum], 0Fh
    je loc_0B076
    ret
loc_0B076:
    sub dx, 0Dh
    ret
loc_0B07A:
    call TerrainStepLeft
TerrainStepUp:
    mov bx, dx
    test word ptr ds:[GridYSum], 0Fh
    jne loc_0B09C
    add bx, 0Dh
    call ReadIndexedByteAttribute
    jne loc_0B032
    test word ptr ss:[bp + REC_X], 0Fh
    je loc_0B09C
    inc bx
    call ReadIndexedByteAttribute
    jne loc_0B032
loc_0B09C:
    dec word ptr ss:[bp + REC_Y]
    dec word ptr ds:[TerrainProbeY]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae loc_0B0B4
    inc word ptr ss:[bp + REC_Y]
    inc word ptr ds:[TerrainProbeY]
    jmp near ptr loc_0B032
loc_0B0B4:
    dec word ptr ds:[GridYSum]
    and word ptr ds:[GridYSum], 0Fh
    cmp word ptr ds:[GridYSum], 0Fh
    je loc_0B0C5
    ret
loc_0B0C5:
    add dx, 0Dh
    ret
loc_0B0C9:
    call TerrainStepUp
TerrainStepRight:
    mov bx, dx
    inc bx
    call ReadIndexedByteAttribute
    je loc_0B0D7
    jmp near ptr loc_0B032
loc_0B0D7:
    test word ptr ds:[GridYSum], 0Fh
    je loc_0B0EA
    sub bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0B0EA
    jmp near ptr loc_0B032
loc_0B0EA:
    inc word ptr ss:[bp + REC_X]
    inc word ptr ds:[TerrainProbeX]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae loc_0B102
    dec word ptr ss:[bp + REC_X]
    dec word ptr ds:[TerrainProbeX]
    jmp near ptr loc_0B032
loc_0B102:
    test word ptr ss:[bp + REC_X], 0Fh
    je loc_0B10A
    ret
loc_0B10A:
    inc dx
    ret
loc_0B10C:
    call TerrainStepDown
TerrainStepLeft:
    mov bx, dx
    test word ptr ss:[bp + REC_X], 0Fh
    jne loc_0B134
    dec bx
    call ReadIndexedByteAttribute
    je loc_0B121
    jmp near ptr loc_0B032
loc_0B121:
    test word ptr ds:[GridYSum], 0Fh
    je loc_0B134
    sub bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0B134
    jmp near ptr loc_0B032
loc_0B134:
    dec word ptr ss:[bp + REC_X]
    dec word ptr ds:[TerrainProbeX]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae loc_0B14C
    inc word ptr ss:[bp + REC_X]
    inc word ptr ds:[TerrainProbeX]
    jmp near ptr loc_0B032
loc_0B14C:
    mov ax, word ptr ss:[bp + REC_X]
    and ax, 0Fh
    cmp ax, 0Fh
    je loc_0B158
    ret
loc_0B158:
    dec dx
    ret

; Finds the next live KIND_ENEMY record for the homing missile.
FindMissileTarget:
    mov cx, POOL_A_COUNT
    mov bx, word ptr ds:[TargetSearchCursor]
loc_0B161:
    cmp bx, offset PoolAEnd
    jae loc_0B19A
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0B191
    cmp word ptr ds:[bx + REC_TYPE], 1
    je loc_0B191
    cmp word ptr ds:[bx + REC_TYPE], 026h
    je loc_0B191
    cmp word ptr ds:[bx + REC_TYPE], 021h
    je loc_0B191
    cmp word ptr ds:[bx + REC_TYPE], 022h
    je loc_0B191
    cmp word ptr ds:[bx + REC_Y], 0E0h
    ja loc_0B191
    cmp word ptr ds:[bx + REC_KIND], KIND_ENEMY
    je loc_0B1A6
loc_0B191:
    add bx, RECORD_SIZE
    loop loc_0B161
    mov bx, 0FFFFh
    ret
loc_0B19A:
    mov word ptr ds:[TargetSearchCursor], offset PoolA
    mov bx, word ptr ds:[TargetSearchCursor]
    jmp short loc_0B161
loc_0B1A6:
    push bx
    add bx, RECORD_SIZE
    mov word ptr ds:[TargetSearchCursor], bx
    pop bx
    ret
; Rides with the player, then locks the next live KIND_ENEMY record and chases it 3 px
; per step; back to the player when the target is lost.
Type0AHomingMissile:
    mov ax, ds:[FrameCount8]
    add ax, 6Dh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_FIELD_1C], 1
    je loc_0B227
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    add ax, 0Ah
    mov ds:[SteerTargetY], ax
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 0Ch
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 2
    and word ptr ds:[SteerTargetX], -4
    and word ptr ds:[SteerTargetY], -4
    and word ptr ss:[bp + REC_X], -4
    and word ptr ss:[bp + REC_Y], -4
    call SteerTowardTarget
    cmp word ptr ds:[SteerArrived], 0
    jne loc_0B1F6
    jmp near ptr ShotBoundsCheck
loc_0B1F6:
    cmp word ptr ds:[MissilesLive], 0
    je loc_0B201
    dec word ptr ds:[MissilesLive]
loc_0B201:
    call FindMissileTarget
    cmp bx, -1
    jne loc_0B20C
    jmp near ptr ExpireShot
loc_0B20C:
    mov ss:[bp + REC_TARGET], bx
    mov word ptr ss:[bp + REC_FIELD_1C], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0B220
    mov byte ptr ds:[SfxRequest], 11h
loc_0B220:
    inc word ptr ds:[MissilesLive]
    jmp near ptr ShotBoundsCheck
loc_0B227:
    mov bx, ss:[bp + REC_TARGET]
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0B245
    cmp word ptr ds:[bx + REC_Y], 0DCh
    ja loc_0B245
    cmp word ptr ds:[bx + REC_TYPE], 1
    je loc_0B245
    call SetDeltaToward
    call StepAlongDelta
    jmp near ptr ShotScrollAndBounds
loc_0B245:
    mov word ptr ss:[bp + REC_FIELD_1C], 0
    jmp near ptr ShotScrollAndBounds
; 3 px Bresenham steps along REC_DELTA, then the player-hit test.
Type0BAimedEnemyShot:
    call StepAlongDelta
; Damages the player and removes the shot on a hit; otherwise the scroll and bounds tail.
ShotHitPlayerCheck:
    cmp word ptr ss:[bp + REC_SIDE_FLAG], 1
    je loc_0B2A3
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    mov bx, word ptr ds:[PrimaryRecord + REC_X]
    sub ax, 2
    cmp word ptr ss:[bp + REC_Y], ax
    jl loc_0B2A3
    add ax, 014h
    cmp word ptr ss:[bp + REC_Y], ax
    jg loc_0B2A3
    cmp word ptr ss:[bp + REC_X], bx
    jb loc_0B2A3
    add bx, 014h
    cmp word ptr ss:[bp + REC_X], bx
    ja loc_0B2A3
    mov cx, 1
    cmp word ptr ss:[bp + REC_TYPE], 3
    jne loc_0B297
    cmp word ptr ds:[DifficultySetting], 0
    je loc_0B297
    mov cx, 3
    cmp word ptr ds:[DifficultySetting], 1
    je loc_0B297
    mov cx, 5
loc_0B297:
    push cx
    push bp
    call DamagePlayerEnergy
    pop bp
    pop cx
    loop loc_0B297
    jmp near ptr ExpireShot
loc_0B2A3:
    jmp near ptr ShotScrollAndBounds
; Types 89h/8Ah: terrain patrol firing down every 32 frames.
Type89PatrolShootDown32:
    mov ax, ds:[SlowCount4]
    add ax, 1Ch
loc_0B2AC:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount32], 1Fh
    jne loc_0B2B9
    call SpawnShotDown
loc_0B2B9:
    jmp near ptr HorizontalTerrainPatrol
; Starts the waypoint path at DS:A45C as type 12h.
Type10StartPathFollowerA:
    mov word ptr ss:[bp + REC_FIELD_36], offset SteerPath10
    jmp short StartPathFollow
; Starts the waypoint path at DS:A43C as type 12h.
Type11StartPathFollowerB:
    mov word ptr ss:[bp + REC_FIELD_36], offset SteerPath11
; Turns BP into a type 12h waypoint follower of the path at REC_FIELD_36.
StartPathFollow:
    mov word ptr ss:[bp + REC_TYPE], 12h
; Steers (speed 1, 2 on level 0 and in the demo) through the (Y, X) waypoints at
; REC_FIELD_36; no end-of-path check and no scroll.
Type12WaypointPathFollower:
    mov si, ss:[bp + REC_FIELD_36]
    lodsw
    add ax, 20h
    mov ds:[SteerTargetY], ax
    lodsw
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 1
    cmp word ptr ds:[LevelIndex], 0
    je loc_0B2EF
    cmp word ptr ds:[DemoActive], 1
    jne loc_0B2F5
loc_0B2EF:
    mov word ptr ds:[SteerSpeed], 2
loc_0B2F5:
    call SteerTowardTarget
    cmp word ptr ds:[SteerArrived], 0
    je loc_0B304
    mov ss:[bp + REC_FIELD_36], si
    jmp short Type12WaypointPathFollower
loc_0B304:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 3Bh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[DemoActive], 1
    jne loc_0B317
    jmp near ptr FinishRecordUpdate
loc_0B317:
    cmp word ptr ds:[LevelIndex], 5
    je loc_0B32C
    cmp word ptr ds:[LevelIndex], 6
    je loc_0B32C
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B35D
loc_0B32C:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 115h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[MapScrollPos], MAP_LAST_SPAWN_POS
    je loc_0B340
    jmp near ptr FinishRecordUpdate
loc_0B340:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 105h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B353
    jmp near ptr FinishRecordUpdate
loc_0B353:
    cmp word ptr ds:[LevelIndex], 6
    jne loc_0B35D
    jmp near ptr FinishRecordUpdate
loc_0B35D:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 2Ah
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 1
    jne loc_0B370
    jmp near ptr FinishRecordUpdate
loc_0B370:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0D2h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 2
    jne loc_0B383
    jmp near ptr FinishRecordUpdate
loc_0B383:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 3
    jne loc_0B396
    jmp near ptr FinishRecordUpdate
loc_0B396:
    cmp word ptr ds:[LevelIndex], 7
    jne loc_0B3A0
    jmp near ptr FinishRecordUpdate
loc_0B3A0:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 4
    jne loc_0B3B3
    jmp near ptr FinishRecordUpdate
loc_0B3B3:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr FinishRecordUpdate
; BP = record: REC_SPRITE = 71h + (SwayDirX + 1) 2.
SetSwaySprite:
    mov ax, ds:[SwayDirX]
    inc ax
    shr ax, 1
    add ax, 71h
    mov ss:[bp + REC_SPRITE], ax
    ret
; As type 22h falling 2 px per frame.
Type36SwayFallThenBurst:
    call SetSwaySprite
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae loc_0B3DD
    jmp near ptr ScrollRecordThenFinish
loc_0B3DD:
    jmp short loc_0B3F9
; Types 22h/35h: sways down (1 px, 2 on level 0) to Y A0h, then destroys itself in an
; eight-way burst of type 3 shots.
Type22DescendThenBurst:
    call SetSwaySprite
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B3EF
    inc word ptr ss:[bp + REC_Y]
loc_0B3EF:
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae loc_0B3F9
    jmp near ptr ScrollRecordThenFinish
loc_0B3F9:
    call DestroyRecord
    call SpawnEightWayBurst
    jmp near ptr ScrollRecordThenFinish
; Spawns up to eight type 3 shots from BP in directions 0..7.
SpawnEightWayBurst:
    mov dx, 0Ch
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    je loc_0B40E
    mov dx, 4
loc_0B40E:
    mov ax, ss:[bp + REC_X]
    add ax, dx
    mov ds:[BurstOriginX], ax
    mov ax, ss:[bp + REC_Y]
    add ax, dx
    mov ds:[BurstOriginY], ax
    mov cx, 8
loc_0B421:
    push cx
    call FindFreeRecordPoolB
    pop cx
    cmp bx, -1
    je loc_0B467
    push cx
    dec cx
    mov ds:[bx + REC_DIRECTION], cx
    add cx, 8
    mov ds:[bx + REC_SPRITE], cx
    mov ax, ds:[BurstOriginX]
    mov ds:[bx + REC_X], ax
    mov ax, ds:[BurstOriginY]
    mov ds:[bx + REC_Y], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 0
    mov word ptr ds:[bx + REC_DRAW_PASS], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], KIND_TYPED
    mov word ptr ds:[bx + REC_TYPE], 3
    mov word ptr ds:[bx + REC_FIELD_1C], 0FFFFh
    pop cx
    loop loc_0B421
loc_0B467:
    ret
; AX = number of live KIND_ENEMY records in pool A.
CountLiveEnemies:
    push bp
    mov cx, 23h
    xor ax, ax
loc_0B46E:
    push cx
    push ax
    mov bx, cx
    shl bx, 1
    mov bp, ds:[bx + PoolAPointers - 2]
    pop ax
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0B486
    cmp word ptr ss:[bp + REC_KIND], KIND_ENEMY
    jne loc_0B486
    inc ax
loc_0B486:
    pop cx
    loop loc_0B46E
    pop bp
    ret
loc_0B48B:
    cmp word ptr ds:[EncounterTicks], 32h
    jae loc_0B495
    jmp near ptr loc_0B615
loc_0B495:
    cmp word ptr ds:[EncounterTicks], 5Ah
    jae loc_0B49F
    jmp near ptr FinishRecordUpdate
loc_0B49F:
    jmp near ptr loc_0B5D8
loc_0B4A2:
    call CountLiveEnemies
    cmp ax, 1
    je loc_0B4AD
    jmp near ptr FinishRecordUpdate
loc_0B4AD:
    mov word ptr ds:[SegBossX], 0
    mov word ptr ds:[SegBossY], 0
    mov word ptr ds:[SegBossActive], 1
    mov word ptr ds:[SegBossPathCursor], offset BossPath
    mov word ptr ss:[bp + REC_TYPE], 78h
    mov word ptr ss:[bp + REC_SPRITE], 22h
    mov word ptr ss:[bp + REC_HIT_POINTS], 0C8h
    mov word ptr ss:[bp + REC_X], 0
    mov word ptr ss:[bp + REC_Y], 0
    mov word ptr ss:[bp + REC_SIZE_CLASS], 2
    mov word ptr ss:[bp + REC_SLOT_INDEX], 0FFFFh
    mov ds:[SegBossCore], bp
    call FindFreeRecordPoolA
    cmp bx, -1
    je loc_0B54A
    call far ptr InitSegBossPartRecord
    mov word ptr ds:[bx + REC_TYPE], 76h
    mov word ptr ds:[bx + REC_SPRITE], 20h
    mov ds:[SegBossAnchor], bx
    call FindFreeRecordPoolA
    cmp bx, -1
    je loc_0B54A
    call far ptr InitSegBossPartRecord
    mov word ptr ds:[bx + REC_TYPE], 77h
    mov word ptr ds:[bx + REC_SPRITE], 21h
    mov word ptr ds:[bx + REC_X], 20h
    mov ds:[SegBossPart77], bx
    call FindFreeRecordPoolA
    cmp bx, -1
    je loc_0B54A
    call far ptr InitSegBossPartRecord
    mov word ptr ds:[bx + REC_TYPE], 79h
    mov word ptr ds:[bx + REC_SPRITE], 23h
    mov word ptr ds:[bx + REC_X], 20h
    mov ds:[SegBossPart79], bx
    jmp near ptr FinishRecordUpdate
loc_0B54A:
    mov word ptr ds:[EncounterLiveCount], 0
    call SmartBombAll
    jmp near ptr FinishRecordUpdate
; Per level encounter driver: spawns type 23h fallers, then becomes boss type 22h (level
; 0: segmented boss 78h; level 3: invaders).
Type21EncounterDirector:
    cmp word ptr ds:[LevelIndex], 4
    jne loc_0B560
    jmp near ptr loc_08D83
loc_0B560:
    cmp word ptr ds:[LevelIndex], 3
    jne loc_0B56A
    jmp near ptr loc_0B48B
loc_0B56A:
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B574
    jmp near ptr loc_0B4A2
loc_0B574:
    cmp word ptr ds:[EncounterTicks], 0C8h
    jae loc_0B57F
    jmp near ptr loc_0B615
loc_0B57F:
    cmp word ptr ds:[EncounterTicks], 0F0h
    jae loc_0B58A
    jmp near ptr FinishRecordUpdate
loc_0B58A:
    mov word ptr ss:[bp + REC_TYPE], 22h
    mov word ptr ss:[bp + REC_SPRITE], 71h
    mov cx, ds:[LevelIndex]
    inc cx
    mov ax, 0Ah
    mul cx
    mov ss:[bp + REC_HIT_POINTS], ax
    mov word ptr ss:[bp + REC_X], 60h
    jmp near ptr FinishRecordUpdate

ResetInvaderFormation:
    mov word ptr ds:[InvaderSlotCursor], offset InvaderFormation
    mov word ptr ds:[InvaderNextMarchLeft], 0
    mov word ptr ds:[InvaderNextDropStep], 0
    ret
loc_0B5BC:
    dec word ptr ds:[EncounterLiveCount]
    mov word ptr ss:[bp + REC_TYPE], 64h
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    mov ss:[bp + REC_X], ax
    mov word ptr ss:[bp + REC_Y], 0
    mov word ptr ss:[bp + REC_SPRITE], 8Eh
    jmp near ptr ScrollRecordThenFinish
loc_0B5D8:
    mov word ptr ds:[FramesSinceInvaderSpawn], 0
    cmp word ptr ds:[InvaderSlotCursor], offset InvaderFormationEnd
    je loc_0B5BC
    mov si, ds:[InvaderSlotCursor]
    push si
    call SpawnEnemyHere
    pop si
    cmp bx, -1
    je loc_0B612
    lodsw
    add ax, 20h
    mov ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 61h
    mov word ptr ds:[bx + REC_SPRITE], 0E7h
    inc word ptr ds:[EncounterLiveCount]
    add word ptr ds:[InvaderSlotCursor], 4
loc_0B612:
    jmp near ptr FinishRecordUpdate
loc_0B615:
    cmp word ptr ds:[FrameCount8], 7
    je loc_0B61F
    jmp near ptr FinishRecordUpdate
loc_0B61F:
    call SpawnEnemyHereQuiet
    cmp bx, -1
    jne loc_0B62A
    jmp near ptr FinishRecordUpdate
loc_0B62A:
    call AssignNextFallerColumn
    mov word ptr ds:[bx + REC_SAVED_Y], 10h
    mov word ptr ds:[bx + REC_TYPE], 23h
    cmp word ptr ds:[LevelIndex], 1
    je loc_0B65E
    cmp word ptr ds:[LevelIndex], 2
    je loc_0B656
    cmp word ptr ds:[LevelIndex], 3
    je loc_0B65E
    cmp word ptr ds:[LevelIndex], 5
    je loc_0B65E
    jmp near ptr FinishRecordUpdate
loc_0B656:
    mov word ptr ds:[bx + REC_HIT_POINTS], 1
    jmp near ptr FinishRecordUpdate
loc_0B65E:
    mov word ptr ds:[bx + REC_HIT_POINTS], 0FFFFh
    mov ax, ds:[RecordTickCounter]
    inc word ptr ds:[RecordTickCounter]
    and ax, 3
    mov ds:[bx + REC_FIELD_1C], ax
    jmp near ptr FinishRecordUpdate
; BX = new record: REC_SAVED_X = the next FallerColumns entry.
AssignNextFallerColumn:
    mov si, ds:[FallerColumnCursor]
    cmp si, offset FallerColumnsEnd
    jb loc_0B687
    mov word ptr ds:[FallerColumnCursor], offset FallerColumns
    mov si, ds:[FallerColumnCursor]
loc_0B687:
    lodsw
    mov ds:[bx + REC_SAVED_X], ax
    mov ds:[FallerColumnCursor], si
    ret
; Steers to its column top, then falls by the FallerVariants[REC_FIELD_1C] profile; on
; level 2 aims at the player as type 2Ch.
Type23ColumnFaller:
    mov ax, ss:[bp + REC_X]
    cmp ax, ss:[bp + REC_SAVED_X]
    je loc_0B69B
    jmp near ptr loc_0B85C
loc_0B69B:
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    je loc_0B6A6
    jmp near ptr loc_0B85C
loc_0B6A6:
    cmp word ptr ss:[bp + REC_Y], 20h
    ja loc_0B6BE
    cmp word ptr ss:[bp + REC_Y], 1Ch
    jb loc_0B6BE
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0B6BE
    mov byte ptr ds:[SfxRequest], 1Dh
loc_0B6BE:
    cmp word ptr ds:[LevelIndex], 2
    je loc_0B701
    mov si, ss:[bp + REC_FIELD_1C]
    shl si, 1
    shl si, 1
    mov ax, offset FallerVariants
    xor cx, cx
    mov dx, 80h
    cmp word ptr ds:[LevelIndex], 3
    je loc_0B6E2
    cmp word ptr ds:[LevelIndex], 5
    jne loc_0B6E9
loc_0B6E2:
    mov ax, offset FallerVariantsAlt
    inc cx
    mov dx, 6Dh
loc_0B6E9:
    add si, ax
    lodsw
    mov bx, ax
    mov ax, ds:[bx]
    shr ax, cl
    add ax, dx
    mov ss:[bp + REC_SPRITE], ax
    lodsw
    add ss:[bp + REC_Y], ax
    add ss:[bp + REC_SAVED_Y], ax
    jmp near ptr FinishRecordUpdate
loc_0B701:
    mov bx, bp
    call AimAtPlayer
    mov word ptr ss:[bp + REC_TYPE], 2Ch
    jmp near ptr FinishRecordUpdate
; 2 px steps along REC_DELTA; no scroll and no X exit test.
Type2CAimedDrifter:
    mov ax, ds:[SlowCount4]
    add ax, 0B9h
    mov ss:[bp + REC_SPRITE], ax
    mov word ptr ds:[ChaseStepPixels], 2
    call StepAlongDelta
    mov word ptr ds:[ChaseStepPixels], 3
    jmp near ptr FinishRecordUpdate
; Steers BP toward REC_SAVED_X/Y; NZ on arrival.
SteerToSaved:
    mov ax, word ptr ss:[bp + REC_SAVED_X]
    mov word ptr ds:[SteerTargetX], ax
    mov ax, word ptr ss:[bp + REC_SAVED_Y]
    mov word ptr ds:[SteerTargetY], ax
    call SteerTowardTarget
    cmp word ptr ds:[SteerArrived], 0
    ret
; Hops between formation slots; when few remain, moves above the player and drops 4 px
; per frame.
Type20SlotHopperDropper:
    cmp word ptr ss:[bp + REC_FIELD_1C], -1
    je loc_0B791
    mov bx, word ptr ss:[bp + REC_FIELD_1C]
    shl bx, 1
    jmp word ptr cs:[bx + Type20Cases]
Type20Cases label word
    dw offset Type20MoveAbovePlayer, offset Type20StartDrop, offset Type20Drop
Type20MoveAbovePlayer:
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ss:[bp + REC_SAVED_X]
    je loc_0B75F
    jmp near ptr loc_0B85C
loc_0B75F:
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ss:[bp + REC_SAVED_Y]
    je loc_0B76A
    jmp near ptr loc_0B85C
loc_0B76A:
    inc word ptr ss:[bp + REC_FIELD_1C]
    jmp near ptr FinishRecordUpdate
Type20StartDrop:
    mov word ptr ss:[bp + REC_SPRITE], 079h
    inc word ptr ss:[bp + REC_FIELD_1C]
    jmp near ptr FinishRecordUpdate
Type20Drop:
    add word ptr ss:[bp + REC_Y], 4
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae loc_0B789
    jmp near ptr FinishRecordUpdate
loc_0B789:
    mov word ptr ss:[bp + REC_SPRITE], 077h
    jmp near ptr FinishRecordUpdate
loc_0B791:
    mov ax, word ptr ds:[SlowCount6]
    cmp word ptr ss:[bp + REC_X], 060h
    jae loc_0B7A1
    neg ax
    add ax, 07Fh
    jmp short loc_0B7A4
loc_0B7A1:
    add ax, 07Ah
loc_0B7A4:
    mov word ptr ss:[bp + REC_SPRITE], ax
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ss:[bp + REC_SAVED_X]
    je loc_0B7B2
    jmp near ptr loc_0B85C
loc_0B7B2:
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ss:[bp + REC_SAVED_Y]
    je loc_0B7BD
    jmp near ptr loc_0B85C
loc_0B7BD:
    cmp word ptr ds:[EncounterTicks], 023h
    jae loc_0B7F3
    jmp near ptr FinishRecordUpdate
loc_0B7C7:
    cmp word ptr ds:[CountGate2324], 1
    je loc_0B7D7
loc_0B7CE:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    mov word ptr ss:[bp + REC_SAVED_X], ax
loc_0B7D7:
    and word ptr ss:[bp + REC_SAVED_X], 0FFF8h
    mov word ptr ds:[RecordTickCounter], 028h
    mov word ptr ss:[bp + REC_FIELD_1C], 0
    mov word ptr ss:[bp + REC_SPRITE], 078h
    mov word ptr ss:[bp + REC_SAVED_Y], 020h
    jmp near ptr FinishRecordUpdate
loc_0B7F3:
    cmp word ptr ds:[RecordTickCounter], 02BCh
    jb loc_0B80E
    cmp word ptr ds:[RecordTickCounter], 02D0h
    ja loc_0B80E
    call NextRandomWord
    and bx, 1
    jne loc_0B80E
    call SpawnAimedShot
loc_0B80E:
    cmp word ptr ds:[EncounterLiveCount], 3
    jbe loc_0B7C7
    cmp word ptr ds:[RecordTickCounter], 5
    jb loc_0B7CE
    cmp word ptr ds:[FrameCount64], 03Fh
    je loc_0B826
    jmp near ptr FinishRecordUpdate
loc_0B826:
    mov si, word ptr ds:[FormationSlotCursor]
    cmp si, offset FormationSlotsEnd
    jb loc_0B83A
    mov word ptr ds:[FormationSlotCursor], offset FormationSlots
    mov si, word ptr ds:[FormationSlotCursor]
loc_0B83A:
    lodsw
    add ax, 020h
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    lodsw
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov word ptr ds:[FormationSlotCursor], si
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ss:[bp + REC_SAVED_Y]
    jne loc_0B859
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ss:[bp + REC_SAVED_X]
    je loc_0B826
loc_0B859:
    jmp near ptr FinishRecordUpdate
loc_0B85C:
    mov word ptr ds:[SteerSpeed], 2
    call SteerToSaved
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jmp near ptr FinishRecordUpdate
; Enters its slot, then bobs, sinks and shoots; chases the player when few remain or
; once low on screen.
Type1DSlotBobThenChase:
    cmp word ptr ds:[EncounterLiveCount], 2
    ja loc_0B877
    jmp near ptr loc_0B8F8
loc_0B877:
    cmp word ptr ss:[bp + REC_Y], 0C0h
    ja loc_0B8F8
    cmp word ptr ds:[EncounterTicks], 28h
    jae loc_0B8B0
    mov word ptr ds:[SteerSpeed], 1
    mov word ptr ss:[bp + REC_SPRITE], 75h
    and word ptr ss:[bp + REC_SAVED_X], -2
    and word ptr ss:[bp + REC_X], -2
    and word ptr ss:[bp + REC_SAVED_Y], -2
    and word ptr ss:[bp + REC_Y], -2
    call SteerToSaved
    jne loc_0B8A8
    jmp near ptr FinishRecordUpdate
loc_0B8A8:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jmp near ptr FinishRecordUpdate
loc_0B8B0:
    cmp word ptr ds:[RecordTickCounter], 2EFh
    jne loc_0B8BB
    call SpawnAimedShot
loc_0B8BB:
    cmp word ptr ds:[RecordTickCounter], 159h
    jne loc_0B8C6
    call SpawnAimedShot
loc_0B8C6:
    cmp word ptr ds:[RecordTickCounter], 79h
    jne loc_0B8D0
    call SpawnAimedShot
loc_0B8D0:
    mov ax, ds:[SwayDirX]
    neg ax
    add ss:[bp + REC_Y], ax
    mov ax, 75h
    cmp word ptr ds:[SwayDirX], -1
    je loc_0B8E5
    mov ax, 76h
loc_0B8E5:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount8], 7
    je loc_0B8F2
    jmp near ptr FinishRecordUpdate
loc_0B8F2:
    inc word ptr ss:[bp + REC_Y]
    jmp near ptr FinishRecordUpdate
loc_0B8F8:
    mov bx, offset PrimaryRecord
    call SetDeltaToward
    call StepAlongDelta
    mov word ptr ss:[bp + REC_SPRITE], 76h
    jmp near ptr FinishRecordUpdate
; Steers to REC_SAVED; on arrival fires an aimed shot and toggles REC_SAVED_X between 0
; and C0h.
Type1EShuttleShooter:
    mov word ptr ds:[SteerSpeed], 2
    call SteerToSaved
    jne loc_0B917
    jmp near ptr FinishRecordUpdate
loc_0B917:
    call SpawnAimedShot
    cmp word ptr ss:[bp + REC_SAVED_X], 0
    je loc_0B928
    mov word ptr ss:[bp + REC_SAVED_X], 0
    jmp near ptr FinishRecordUpdate
loc_0B928:
    mov word ptr ss:[bp + REC_SAVED_X], 0C0h
    jmp near ptr FinishRecordUpdate
; Types 16h/17h: steers to REC_SAVED, waits REC_FIELD_1C, moves to Y 20h (16h) or 40h
; (17h); becomes type 18h at EncounterTicks 31h.
Type16SweepLeadIn:
    mov word ptr ds:[SteerSpeed], 1
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B943
    mov word ptr ds:[SteerSpeed], 2
loc_0B943:
    call SteerToSaved
    pushf
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 10Dh
    mov ss:[bp + REC_SPRITE], ax
    popf
    jne loc_0B956
    jmp near ptr FinishRecordUpdate
loc_0B956:
    cmp word ptr ss:[bp + REC_FIELD_1C], 0
    je loc_0B97A
    dec word ptr ss:[bp + REC_FIELD_1C]
    je loc_0B964
    jmp near ptr FinishRecordUpdate
loc_0B964:
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
    cmp word ptr ss:[bp + REC_TYPE], 16h
    jne loc_0B972
    jmp near ptr FinishRecordUpdate
loc_0B972:
    mov word ptr ss:[bp + REC_SAVED_Y], 40h
    jmp near ptr FinishRecordUpdate
loc_0B97A:
    cmp word ptr ds:[EncounterTicks], 31h
    je loc_0B984
    jmp near ptr FinishRecordUpdate
loc_0B984:
    mov word ptr ss:[bp + REC_TYPE], 18h
    jmp near ptr FinishRecordUpdate
; Walks the REC_FIELD_36 waypoints at speed 3 (FFFFh, address = jump); random downward
; shots and a periodic aimed shot.
Type18SweepPathLooper:
    mov ax, ds:[RecordTickCounter]
    and ax, 3FFh
    cmp ax, 0Ch
    jne loc_0B99E
    call SpawnAimedShot
    inc word ptr ds:[RecordTickCounter]
loc_0B99E:
    mov si, ss:[bp + REC_FIELD_36]
    lodsw
    cmp ax, 0FFFFh
    je loc_0B9EA
    add ax, 20h
    mov ds:[SteerTargetY], ax
    lodsw
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 3
    call SteerTowardTarget
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 10Dh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[SteerArrived], 0
    jne loc_0B9CD
    jmp near ptr FinishRecordUpdate
loc_0B9CD:
    mov ss:[bp + REC_FIELD_36], si
    call NextRandomWord
    and bx, 7
    cmp bx, 2
    jne Type18SweepPathLooper
    call SpawnThrottledChild
    cmp bx, -1
    je Type18SweepPathLooper
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    jmp short Type18SweepPathLooper
loc_0B9EA:
    lodsw
    mov ss:[bp + REC_FIELD_36], ax
    jmp short Type18SweepPathLooper
; Sways in its formation slot after the leader script ends; dives at the player when few
; remain or on a tick, wraps below D0h and returns to the slot.
Type14FormationSwayDiver:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript13End
    jne loc_0BA67
    cmp word ptr ds:[RecordTickCounter], 2EFh
    jne loc_0BA07
    call SpawnAimedShot
    inc word ptr ds:[RecordTickCounter]
loc_0BA07:
    mov ax, ds:[SwayDirX]
    add ss:[bp + REC_SAVED_X], ax
    mov ax, ds:[SwayDropY]
    add ss:[bp + REC_SAVED_Y], ax
    cmp word ptr ss:[bp + REC_SAVED_Y], 0D0h
    jna loc_0BA1F
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
loc_0BA1F:
    mov ax, ss:[bp + REC_X]
    add ax, ds:[SwayDirX]
    cmp ax, ss:[bp + REC_SAVED_X]
    jne loc_0BA99
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    jne loc_0BA99
    cmp word ptr ds:[EncounterLiveCount], 6
    jb loc_0BA5A
    mov ax, ds:[RecordTickCounter]
    cmp word ptr ds:[DifficultySetting], 2
    je loc_0BA4E
    and ax, 0FFh
    cmp ax, 0FFh
    jne loc_0BA67
    jmp short loc_0BA56
loc_0BA4E:
    and ax, 7Fh
    cmp ax, 7Fh
    jne loc_0BA67
loc_0BA56:
    inc word ptr ds:[RecordTickCounter]
loc_0BA5A:
    mov bx, offset PrimaryRecord
    call SetDeltaToward
    call StepAlongDelta
    add word ptr ss:[bp + REC_Y], 2
loc_0BA67:
    mov ax, ds:[SlowCount4]
    add ax, 1Ch
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr FinishRecordUpdate
loc_0BA73:
    mov ax, ss:[bp + REC_SAVED_X]
    and ax, 0FFFEh
    and word ptr ss:[bp + REC_X], -2
    mov ds:[SteerTargetX], ax
    mov ax, ss:[bp + REC_SAVED_Y]
    and ax, 0FFFEh
    and word ptr ss:[bp + REC_Y], -2
    mov ds:[SteerTargetY], ax
    mov word ptr ds:[SteerSpeed], 1
    call SteerTowardTarget
    jmp near ptr FinishRecordUpdate
loc_0BA99:
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    jna loc_0BA73
    call StepAlongDelta
    cmp word ptr ds:[EncounterLiveCount], 6
    jae loc_0BAB5
    cmp word ptr ds:[FrameCount64], 3Fh
    jne loc_0BAB5
    call SpawnAimedShot
loc_0BAB5:
    cmp word ptr ss:[bp + REC_Y], 0D0h
    ja loc_0BABF
    jmp near ptr FinishRecordUpdate
loc_0BABF:
    mov word ptr ss:[bp + REC_Y], 10h
    jmp near ptr FinishRecordUpdate
; Type 19h patrol without firing (sprite 27h based).
Type1BWallPatrolB:
    mov ax, ds:[SlowCount6]
    shr ax, 1
    add ax, 27h
    mov ss:[bp + REC_SPRITE], ax
    jmp short loc_0BADF
; Type 19h patrol without firing (sprite 24h based).
Type1AWallPatrolA:
    mov ax, ds:[SlowCount6]
    shr ax, 1
    add ax, 24h
    mov ss:[bp + REC_SPRITE], ax
loc_0BADF:
    jmp short HorizontalTerrainPatrol
; SpawnThrottledChild with REC_DIRECTION temporarily down.
SpawnShotDown:
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnThrottledChild
    pop word ptr ss:[bp + REC_DIRECTION]
    ret
; Patrols left and right 1 px per frame, reversing at X 0/C0h or a wall; fires downward
; every 64 frames.
Type19WallPatrolShooter:
    mov ax, ds:[SlowCount5]
    add ax, 36h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount64], 3Fh
    jne HorizontalTerrainPatrol
    call SpawnShotDown
; Walks BP 1 px left or right, reversing at X 0/C0h or a blocked step; ends in the scroll tail.
HorizontalTerrainPatrol:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    jne loc_0BB24
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    cmp word ptr ss:[bp + REC_X], 0
    je loc_0BB1C
    call TryTerrainStep
    jne loc_0BB1C
    jmp near ptr ScrollRecordThenFinish
loc_0BB1C:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp near ptr ScrollRecordThenFinish
loc_0BB24:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    cmp word ptr ss:[bp + REC_X], 0C0h
    je loc_0BB38
    call TryTerrainStep
    jne loc_0BB38
    jmp near ptr ScrollRecordThenFinish
loc_0BB38:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    jmp near ptr ScrollRecordThenFinish
; Types 8Dh/8Eh: as 8Bh with another sprite set.
Type8DClimbWalkerB:
    mov word ptr ds:[WalkerFacingStep], 0FFFFh
    jmp short loc_0BB4E
; Type 8Dh facing the other way.
Type8EClimbWalkerBFlipped:
    mov word ptr ds:[WalkerFacingStep], 1
loc_0BB4E:
    call ClimbWalkerStep
    mov bx, 0
    je loc_0BB60
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
loc_0BB60:
    mov ax, 13Ah
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, bx
    xor cx, cx
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP
    je loc_0BB7C
    mov cx, 3
loc_0BB7C:
    add ax, cx
    jmp short loc_0BBB2
; Type 8Bh facing the other way.
Type8CClimbWalkerAFlipped:
    mov word ptr ds:[WalkerFacingStep], 0FFFFh
    jmp short loc_0BB8E
; Types 8Bh/8Ch: climbs toward the player's Y along a wall, firing aimed shots.
Type8BClimbWalkerA:
    mov word ptr ds:[WalkerFacingStep], 1
loc_0BB8E:
    call ClimbWalkerStep
    mov bx, 0
    je loc_0BB9A
    mov bx, ds:[SlowCount4]
loc_0BB9A:
    mov ax, 61h
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, bx
    add ax, ss:[bp + REC_DIRECTION]
loc_0BBB2:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount128], 7Fh
    je loc_0BBCA
    cmp word ptr ds:[FrameCount128], 6Bh
    je loc_0BBCA
    cmp word ptr ds:[FrameCount128], 57h
    jne ScrollRecordThenFinish
loc_0BBCA:
    call SpawnAimedShot
    cmp bx, -1
    je ScrollRecordThenFinish
    mov word ptr ds:[bx + REC_SPRITE], 3
    sub word ptr ds:[bx + REC_X], 8
    sub word ptr ds:[bx + REC_Y], 8
    jmp short ScrollRecordThenFinish
loc_0BBE1:
    mov word ptr ds:[TerrainBlocked], 1
    cmp word ptr ds:[TerrainBlocked], 1
    ret
; BP = walker: steps up or down toward the player's Y along a wall on its facing side;
; ZF (TerrainBlocked 1) when it cannot.
ClimbWalkerStep:
    mov word ptr ds:[TerrainBlocked], 0
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    push word ptr ss:[bp + REC_Y]
    mov ax, ds:[ScrollDeltaY]
    add ss:[bp + REC_Y], ax
    sub word ptr ss:[bp + REC_Y], 10h
    call ComputeRecordGridOffset
    pop word ptr ss:[bp + REC_Y]
    cmp bx, -1
    je loc_0BBE1
    mov ax, ss:[bp + REC_Y]
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jl loc_0BC2B
    add bx, ds:[WalkerFacingStep]
    call ReadIndexedByteAttribute
    je loc_0BBE1
    call TryTerrainStep
    cmp word ptr ds:[TerrainBlocked], 1
    ret
loc_0BC2B:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    add bx, ds:[WalkerFacingStep]
    sub bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0BBE1
    call TryTerrainStep
    cmp word ptr ds:[TerrainBlocked], 1
    ret
; BP = record: move it with the playfield scroll (REC_Y += ScrollDeltaY), then
; FinishRecordUpdate. The common tail of most REC_TYPE handlers.
ScrollRecordThenFinish:
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
; Clamp X, remove the record when it leaves the screen vertically (some types
; exempt), then run the collision checks unless LevelEndPhase is set.
FinishRecordUpdate:
    call ClampRecordX
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne loc_0BC96
    cmp word ptr ss:[bp + REC_TYPE], 0
    je loc_0BC96
    cmp word ptr ss:[bp + REC_TYPE], 048h
    je loc_0BC96
    cmp word ptr ss:[bp + REC_TYPE], 026h
    je loc_0BC96
    cmp word ptr ss:[bp + REC_TYPE], 086h
    je loc_0BC96
    cmp word ptr ss:[bp + REC_TYPE], 028h
    je loc_0BC96
    cmp word ptr ss:[bp + REC_TYPE], 029h
    je loc_0BC96
    cmp word ptr ss:[bp + REC_TYPE], 034h
    je loc_0BC96
    cmp word ptr ss:[bp + REC_Y], 0FF40h
    jge loc_0BC8A
    jmp near ptr RemoveRecord
loc_0BC8A:
    cmp word ptr ss:[bp + REC_Y], 0F0h
    jl loc_0BC94
    jmp near ptr RemoveRecord
loc_0BC94:
    jmp short loc_0BCA3
loc_0BC96:
    cmp word ptr ss:[bp + REC_Y], -014h
    jl RemoveRecord
    cmp word ptr ss:[bp + REC_Y], 0F0h
    jge RemoveRecord
loc_0BCA3:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne loc_0BCB0
    call CheckRecordHitsPlayer
    call PlayerShotsHitRecord
loc_0BCB0:
    ret

; Clamp REC_X to 0..0C0h.
ClampRecordX:
    cmp word ptr ss:[bp + REC_X], 0C0h
    jg loc_0BCBF
    cmp word ptr ss:[bp + REC_X], 0
    jl loc_0BCC5
    ret
loc_0BCBF:
    mov word ptr ss:[bp + REC_X], 0C0h
    ret
loc_0BCC5:
    mov word ptr ss:[bp + REC_X], 0
    ret
; BP = record: on body contact destroys it (not during a segmented boss) and calls
; LosePlayerEnergyTank.
CheckRecordHitsPlayer:
    cmp word ptr ss:[bp + REC_STATUS], 0
    jne loc_0BCD2
    ret
loc_0BCD2:
    cmp word ptr ss:[bp + REC_KIND], KIND_PICKUP
    jne loc_0BCD9
    ret
loc_0BCD9:
    cmp word ptr ss:[bp + REC_TYPE], 0
    jne loc_0BCE0
    ret
loc_0BCE0:
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne loc_0BCE7
    ret
loc_0BCE7:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 1
    je loc_0BCF4
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    je loc_0BCF9
    ret
loc_0BCF4:
    call SmallRecordHitsPlayer
    jmp short loc_0BCFC
loc_0BCF9:
    call LargeRecordHitsPlayer
loc_0BCFC:
    jb loc_0BCFF
    ret
loc_0BCFF:
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BD09
    call DestroyRecord
loc_0BD09:
    call LosePlayerEnergyTank
    ret
; RemoveRecord for the record at BX.
RemoveRecordAtBX:
    push bp
    mov bp, bx
    call RemoveRecord
    mov bx, bp
    pop bp
    ret

; BP = record: free it (REC_STATUS = 0) and update the live counters its kind and
; type belong to (shots, encounter, pods).
RemoveRecord:
    mov word ptr ss:[bp + REC_STATUS], 0
    cmp word ptr ss:[bp + REC_KIND], KIND_ENEMY
    je loc_0BD5C
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je loc_0BD56
    cmp word ptr ss:[bp + REC_TYPE], 7
    je loc_0BDAC
    cmp word ptr ss:[bp + REC_TYPE], 8
    je loc_0BDAC
    cmp word ptr ss:[bp + REC_TYPE], 9
    je loc_0BD7A
    cmp word ptr ss:[bp + REC_TYPE], 6
    jne loc_0BD43
    jmp near ptr loc_0BDC4
loc_0BD43:
    cmp word ptr ss:[bp + REC_TYPE], 5
    je loc_0BDC4
    cmp word ptr ss:[bp + REC_TYPE], 0Ch
    je loc_0BDB8
    cmp word ptr ss:[bp + REC_TYPE], 0Ah
    je loc_0BD9E
    ret
loc_0BD56:
    mov word ptr ss:[bp + REC_KIND], KIND_TYPED
    ret
loc_0BD5C:
    call ReleaseEncounterMember
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne loc_0BD66
    ret
loc_0BD66:
    cmp word ptr ss:[bp + REC_SLOT_INDEX], -1
    jne loc_0BD6D
    ret
loc_0BD6D:
    mov si, word ptr ss:[bp + REC_SLOT_INDEX]
    shl si, 1
    add si, offset GroupTable
    mov byte ptr ds:[si + GROUP_LIVE], 0
    ret
loc_0BD7A:
    cmp word ptr ds:[ShotsLiveType9], 0
    jne loc_0BD82
    ret
loc_0BD82:
    mov cx, 01Ah
    mov si, offset BeamList
loc_0BD88:
    lodsw
    cmp ax, 0FFFFh
    jne loc_0BD8F
    ret
loc_0BD8F:
    mov word ptr ds:[si - 2], ax
    mov bx, ax
    mov word ptr ds:[bx], 0
    dec word ptr ds:[ShotsLiveType9]
    jmp short loc_0BD88
loc_0BD9E:
    cmp word ptr ds:[MissilesLive], 0
    je loc_0BDA9
    dec word ptr ds:[MissilesLive]
loc_0BDA9:
    jmp near ptr loc_0AC19
loc_0BDAC:
    cmp word ptr ds:[ShotsLiveMain], 0
    je loc_0BDB7
    dec word ptr ds:[ShotsLiveMain]
loc_0BDB7:
    ret
loc_0BDB8:
    cmp word ptr ds:[ShotsLiveFrontPod], 0
    je loc_0BDC3
    dec word ptr ds:[ShotsLiveFrontPod]
loc_0BDC3:
    ret
loc_0BDC4:
    cmp word ptr ds:[ShotsLiveSide], 0
    je loc_0BDCF
    dec word ptr ds:[ShotsLiveSide]
loc_0BDCF:
    ret
; CF when TerrainProbeY/X is within 10h of another walker (enemy types 82h..94h).
ProbeOverlapsWalker:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 1
    je loc_0BE3A
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
    mov ax, word ptr ds:[TerrainProbeX]
    mov di, word ptr ds:[TerrainProbeY]
loc_0BDE3:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je loc_0BE35
    cmp word ptr ds:[bx + REC_DRAW_PASS], 1
    je loc_0BE35
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    jne loc_0BE35
    cmp word ptr ds:[bx + REC_KIND], KIND_ENEMY
    jne loc_0BE35
    cmp word ptr ds:[bx + REC_TYPE], 082h
    jb loc_0BE35
    cmp word ptr ds:[bx + REC_TYPE], 094h
    ja loc_0BE35
    mov si, word ptr ds:[bx + REC_Y]
    add si, 010h
    cmp di, si
    jge loc_0BE35
    sub si, 020h
    cmp di, si
    jle loc_0BE35
    mov si, word ptr ds:[bx + REC_X]
    add si, 010h
    cmp ax, si
    jge loc_0BE35
    sub si, 020h
    cmp ax, si
    jle loc_0BE35
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    cmp si, word ptr ds:[bx + REC_SAVE_BUFFER]
    je loc_0BE35
    jmp near ptr loc_05059
loc_0BE35:
    add bx, RECORD_SIZE
    loop loc_0BDE3
loc_0BE3A:
    clc
    ret
; Explosion: REC_ANIM advances every 2nd frame; small ones end at 9 (types 24h/25h leave
; a type 26h wreck), large ones at 0Ch. Size class 0 only scrolls.
Type01ExplosionAnimation:
    cmp word ptr ds:[CountGate2324], 1
    je loc_0BE46
    jmp near ptr ScrollRecordThenFinish
loc_0BE46:
    inc word ptr ss:[bp + REC_ANIM_COUNTER]
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    shl bx, 1
    jmp word ptr cs:[bx + ExplosionSizeCases]
    even
ExplosionSizeCases label word
    dw offset ScrollRecordThenFinish, offset AnimateExplosion16, offset AnimateExplosion32
AnimateExplosion16:
    cmp word ptr ss:[bp + REC_ANIM_COUNTER], 9
    jne loc_0BEA4
    cmp word ptr ss:[bp + REC_PREV_TYPE], 024h
    je loc_0BE6F
    cmp word ptr ss:[bp + REC_PREV_TYPE], 025h
    je loc_0BE84
    jmp near ptr RemoveRecord
loc_0BE6F:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    mov word ptr ss:[bp + REC_TYPE], 026h
    mov word ptr ss:[bp + REC_SPRITE], 097h
    sub word ptr ss:[bp + REC_X], 8
    jmp short StoreRecordSavedPosition
loc_0BE84:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    mov word ptr ss:[bp + REC_TYPE], 026h
    mov word ptr ss:[bp + REC_SPRITE], 091h
    add word ptr ss:[bp + REC_X], 8
StoreRecordSavedPosition:
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    ret
loc_0BEA4:
    mov ax, word ptr ss:[bp + REC_ANIM_COUNTER]
    add ax, 0
    mov word ptr ss:[bp + REC_SPRITE], ax
    jmp near ptr ScrollRecordThenFinish
AnimateExplosion32:
    cmp word ptr ss:[bp + REC_ANIM_COUNTER], 0Ch
    jne loc_0BEB9
    jmp near ptr RemoveRecord
loc_0BEB9:
    mov ax, ss:[bp + REC_ANIM_COUNTER]
    add ax, 3
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr ScrollRecordThenFinish
; BX = player shot that hit BP. Types 7, 8, 0Ch and 9 pierce: they destroy BP outright
; (against the segmented boss they only damage it, and 7/8/0Ch are then used up).
; Types 5 and 6 are used up and destroy BP; type 2 is used up and takes 1..5 hit points
; by sprite and DifficultySetting; any other shot only hits its REC_TARGET.
ShotHitsRecord:
    cmp word ptr ds:[bx + REC_TYPE], 7
    jne loc_0BECE
    jmp near ptr loc_0BFB9
loc_0BECE:
    cmp word ptr ds:[bx + REC_TYPE], 8
    jne loc_0BED7
    jmp near ptr loc_0BFB9
loc_0BED7:
    cmp word ptr ds:[bx + REC_TYPE], 0Ch
    jne loc_0BEE0
    jmp near ptr loc_0BFB9
loc_0BEE0:
    cmp word ptr ds:[bx + REC_TYPE], 9
    jne loc_0BEE9
    jmp near ptr loc_0BFA8
loc_0BEE9:
    cmp word ptr ds:[bx + REC_TYPE], 2
    je loc_0BF1B
    cmp word ptr ds:[bx + REC_TYPE], 6
    jne loc_0BEF8
    jmp near ptr loc_0BF97
loc_0BEF8:
    cmp word ptr ds:[bx + REC_TYPE], 5
    jne loc_0BF01
    jmp near ptr loc_0BF97
loc_0BF01:
    cmp bp, word ptr ds:[bx + REC_TARGET]
    je loc_0BF07
    ret
loc_0BF07:
    mov word ptr ds:[bx + REC_FIELD_1C], 0
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BF25
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp near ptr DestroyRecord
loc_0BF1B:
    mov word ptr ds:[bx + REC_STATUS], 0
    cmp word ptr ds:[bx + REC_SPRITE], 033h
    jne loc_0BF2D
loc_0BF25:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    jne loc_0BF2D
    jmp near ptr DestroyRecord
loc_0BF2D:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    jne loc_0BF35
    jmp near ptr DestroyRecord
loc_0BF35:
    cmp word ptr ds:[DifficultySetting], 1
    je loc_0BF4D
    cmp word ptr ds:[DifficultySetting], 0
    jne loc_0BF52
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je DestroyRecord
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je DestroyRecord
loc_0BF4D:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je DestroyRecord
loc_0BF52:
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BF5F
    ret
loc_0BF5F:
    push bp
    mov bp, word ptr ds:[SegBossAnchor]
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    mov bp, word ptr ds:[SegBossPart77]
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    mov bp, word ptr ds:[SegBossCore]
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    mov bp, word ptr ds:[SegBossPart79]
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0BF90
    mov byte ptr ds:[SfxRequest], 0Eh
loc_0BF90:
    pop bp
    ret
loc_0BF92:
    call RemoveRecordAtBX
    jmp short loc_0BF25
loc_0BF97:
    call RemoveRecordAtBX
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BF25
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short DestroyRecord
loc_0BFA8:
    cmp word ptr ds:[SegBossActive], 1
    jne loc_0BFB2
    jmp near ptr loc_0BF25
loc_0BFB2:
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short DestroyRecord
loc_0BFB9:
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BF92
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short DestroyRecord
; Starts BP's explosion: REC_PREV_TYPE = type, type 1, sfx 19h, score and group drop.
DestroyRecord:
    cmp word ptr ss:[bp + REC_TYPE], 021h
    jne loc_0BFD5
    cmp word ptr ds:[LevelIndex], 4
    je loc_0BFD5
    ret
loc_0BFD5:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 1
    mov bx, 030h
    je loc_0BFE1
    mov bx, 060h
loc_0BFE1:
    call AddScoreBcd
    call ClampRecordX
    push bp
    cmp word ptr ss:[bp + REC_SLOT_INDEX], -1
    je loc_0C017
    mov si, word ptr ss:[bp + REC_SLOT_INDEX]
    shl si, 1
    add si, offset GroupTable
    cmp byte ptr ds:[si + GROUP_LIVE], 0
    je loc_0C017
    dec byte ptr ds:[si + GROUP_LIVE]
    jne loc_0C017

    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[DropX], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[DropY], ax
    mov al, byte ptr ds:[si + GROUP_DROP_KIND]
    xor ah, ah
    mov word ptr ds:[DropKind], ax
    call SpawnItemDrop
loc_0C017:
    pop bp
    call ReleaseEncounterMember
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0C027
    mov byte ptr ds:[SfxRequest], 019h
loc_0C027:
    mov ax, word ptr ss:[bp + REC_TYPE]
    mov word ptr ss:[bp + REC_PREV_TYPE], ax
    mov word ptr ss:[bp + REC_TYPE], 1
    mov word ptr ss:[bp + REC_ANIM_COUNTER], 0
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    shl bx, 1
    jmp word ptr cs:[bx + ExplosionStartCases]
    even
ExplosionStartCases label word
    dw offset CountXReturn, offset StartExplosion16, offset StartExplosion32
StartExplosion16:
    mov word ptr ss:[bp + REC_SPRITE], 0
    ret
StartExplosion32:
    mov word ptr ss:[bp + REC_SPRITE], 3
    ret


; BP = enemy being removed: encounter live count by REC_TYPE; a segmented-boss part
; explodes the others, leaders end their script, type 93h sets its latch.
ReleaseEncounterMember:
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
    mov ax, offset LeaderScript7EEnd
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 07Dh
    mov ax, offset LeaderScript7DEnd
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 01Fh
    mov ax, offset LeaderScript1FEnd
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 01Ch
    mov ax, offset LeaderScript1CEnd
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 015h
    mov ax, offset LeaderScript15End
    je loc_0C12D
    cmp word ptr ss:[bp + REC_TYPE], 013h
    mov ax, offset LeaderScript13End
    je loc_0C12D
    ret
loc_0C12D:
    mov word ptr ds:[LeaderScriptCursor], ax
    mov word ptr ds:[FormationSlotCursor], offset FormationSlots
    push bx
    push bp
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[DropX], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[DropY], ax
    mov ax, 2
    mov word ptr ds:[DropKind], ax
    call SpawnItemDrop
    pop bp
    pop bx
loc_0C14F:
    dec word ptr ds:[EncounterLiveCount]
    ret
loc_0C154:
    mov byte ptr ds:[Type93KilledLatch], 1
    jmp short loc_0C14F
loc_0C15B:
    mov bx, word ptr ds:[SegBossAnchor]
    cmp bx, bp
    je loc_0C166
    call ExplodeRecordAtBX
loc_0C166:
    mov bx, word ptr ds:[SegBossPart77]
    cmp bx, bp
    je loc_0C171
    call ExplodeRecordAtBX
loc_0C171:
    mov bx, word ptr ds:[SegBossCore]
    cmp bx, bp
    je loc_0C17C
    call ExplodeRecordAtBX
loc_0C17C:
    mov bx, word ptr ds:[SegBossPart79]
    cmp bx, bp
    je loc_0C187
    call ExplodeRecordAtBX
loc_0C187:
    mov word ptr ds:[EncounterLiveCount], 0
    mov word ptr ds:[SegBossActive], 0
    ret

; BX = record: starts a large explosion (type 1, sprite 3), sfx 19h.
ExplodeRecordAtBX:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0C1A0
    mov byte ptr ds:[SfxRequest], 019h
loc_0C1A0:
    mov ax, word ptr ds:[bx + REC_TYPE]
    mov word ptr ds:[bx + REC_PREV_TYPE], ax
    mov word ptr ds:[bx + REC_TYPE], 1
    mov word ptr ds:[bx + REC_ANIM_COUNTER], 0
    mov word ptr ds:[bx + REC_SPRITE], 3
    ret
; BP = record: turn it toward the primary (REC_DIRECTION from AimQuadrantBits;
; unchanged when aligned, then return) and continue in TryTerrainStep.
loc_0C1B6:
    mov ax, word ptr ss:[bp + REC_Y]
    or ax, ax
    jns loc_0C1BD
loc_0C1BD:
    mov word ptr ds:[AimQuadrantBits], 0
    mov ax, word ptr ss:[bp + REC_X]
    sub ax, 4
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jl loc_0C1DA
    sub ax, 2
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jg loc_0C1E2
    jmp short loc_0C1E8
loc_0C1DA:
    mov word ptr ds:[AimQuadrantBits], 1
    jmp short loc_0C1E8
loc_0C1E2:
    mov word ptr ds:[AimQuadrantBits], 2
loc_0C1E8:
    mov ax, word ptr ss:[bp + REC_Y]
    sub ax, 4
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jl loc_0C1FF
    sub ax, 2
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jg loc_0C206
    jmp short loc_0C20B
loc_0C1FF:
    or word ptr ds:[AimQuadrantBits], 4
    jmp short loc_0C20B
loc_0C206:
    or word ptr ds:[AimQuadrantBits], 8
loc_0C20B:
    mov bx, offset DirectionFromQuadrant
    mov ax, word ptr ds:[AimQuadrantBits]
    xlat
    cmp al, 0FFh
    jne loc_0C217
    ret
loc_0C217:
    mov word ptr ss:[bp + REC_DIRECTION], ax
    jmp near ptr TryTerrainStep

; BP = parent: as SpawnThrottledChild without the throttle, the child placed at
; parent +0Ch,+0Ch instead of +4,+4.
; BP = parent: an unthrottled SpawnThrottledChild at +0Ch, +0Ch; BX = child or FFFFh.
SpawnChildAt12:
    call FindFreeRecordPoolB
    cmp bx, -1
    jne loc_0C226
    ret
loc_0C226:
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 0Ch
    mov word ptr ds:[bx + REC_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 0Ch
    jmp short loc_0C277
; BP = parent record. Spawns a pool-B child (REC_KIND 2, REC_TYPE 4, sprite 30h) at
; parent +4,+4 moving in the parent's direction, on every 4th / 2nd / every call for
; DifficultySetting 0 / 1 / 2 (throttled: AL = 0). Unless the child is near the top
; (REC_Y < 8) or the parent below E0h, requests an effect chosen by the parent's
; REC_TYPE and returns BX = child. Pool full: BX = FFFF.
SpawnThrottledChild:
    cmp word ptr ds:[DifficultySetting], 2
    je loc_0C25F
    cmp word ptr ds:[DifficultySetting], 1
    je loc_0C253
    inc byte ptr ds:[ChildSpawnThrottle]
    and byte ptr ds:[ChildSpawnThrottle], 3
    je loc_0C25F
    xor al, al
    ret
loc_0C253:
    inc byte ptr ds:[ChildSpawnThrottle]
    and byte ptr ds:[ChildSpawnThrottle], 1
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
loc_0C277:
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ds:[bx + REC_DIRECTION], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 0
    mov word ptr ds:[bx + REC_SPRITE], 030h
    mov word ptr ds:[bx + REC_DRAW_PASS], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], KIND_TYPED
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
    jmp near ptr ShotSfx14
loc_0C2C4:
    and bx, 0Fh
    shl bx, 1
    jmp word ptr cs:[bx + ShotSfxByType]
; Indexed by the firer's REC_TYPE & 0Fh. Each entry requests one effect (when
; effects are enabled) and returns the new record in BX.
ShotSfxByType label word
    dw offset ShotSfx0B
    dw offset ShotSfx0C
    dw offset ShotSfx0E
    dw offset ShotSfx11
    dw offset ShotSfx12
    dw offset ShotSfx13
    dw offset ShotSfx14
    dw offset ShotSfx15
    dw offset ShotSfx1A
    dw offset ShotSfx1B
    dw offset ShotSfx1E
    dw offset ShotSfx18
    dw offset ShotSfx13
    dw offset ShotSfx14
    dw offset ShotSfx1B
    dw offset ShotSfx1A
ShotSfx0B:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 00Bh
@@done:
    mov bx, ax
    ret
ShotSfx0C:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 00Ch
@@done:
    mov bx, ax
    ret
ShotSfx0E:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 00Eh
@@done:
    mov bx, ax
    ret
ShotSfx11:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 011h
@@done:
    mov bx, ax
    ret
ShotSfx12:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 012h
@@done:
    mov bx, ax
    ret
ShotSfx13:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 013h
@@done:
    mov bx, ax
    ret
ShotSfx14:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 014h
@@done:
    mov bx, ax
    ret
ShotSfx15:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 015h
@@done:
    mov bx, ax
    ret
ShotSfx1A:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 01Ah
@@done:
    mov bx, ax
    ret
ShotSfx1B:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 01Bh
@@done:
    mov bx, ax
    ret
ShotSfx1E:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 01Eh
@@done:
    mov bx, ax
    ret
ShotSfx18:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 018h
@@done:
    mov bx, ax
    ret
; Next background save buffer while REC_SAVE_BUFFER is assigned to each record.
SaveBufferCursor dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h

; Life or demo start: clears the pools (pods keep their state), places the player and
; exhaust, and resets energy, shots, fuel and the level-end state.
ResetRecordsForLife:
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset GroupTable
    mov cx, 010h
    xor ax, ax
    rep stosw
    mov word ptr cs:[SaveBufferCursor], offset PoolBSaveBuffers
    mov cx, POOL_B_COUNT
loc_0C3BF:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov ax, word ptr cs:[SaveBufferCursor]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[SaveBufferCursor], POOL_B_SAVE_BYTES
    pop cx
    loop loc_0C3BF
    mov word ptr cs:[SaveBufferCursor], offset PoolASaveBuffers
    mov cx, POOL_A_POINTER_COUNT
loc_0C3F1:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    mov word ptr ss:[bp + REC_DRAW_PASS], 1
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je loc_0C41E
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_FLASH_TIMER], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
loc_0C41E:
    mov ax, word ptr cs:[SaveBufferCursor]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[SaveBufferCursor], POOL_A_SAVE_BYTES
    pop cx
    loop loc_0C3F1
    mov bp, offset PrimaryRecord
    mov word ptr ss:[bp + REC_STATUS], 1
    mov word ptr ss:[bp + REC_KIND], KIND_PLAYER
    mov word ptr ss:[bp + REC_SIZE_CLASS], 2
    mov word ptr ss:[bp + REC_Y], 0C0h
    mov word ptr ss:[bp + REC_X], 058h
    mov word ptr ss:[bp + REC_DRAW_PASS], 1
    call FindFreeRecordPoolA
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 1
    mov word ptr ds:[bx + REC_KIND], KIND_EXHAUST
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset BeamList
    mov ax, 0FFFFh
    mov cx, 01Ah
    rep stosw
    mov word ptr ds:[EnergyTanks], 3
    mov word ptr ds:[EnergyPoints], 018h
    mov word ptr ds:[ShotsLiveMain], 0
    mov word ptr ds:[ShotsLiveType9], 0
    mov word ptr ds:[ShotsLiveFrontPod], 0
    mov word ptr ds:[ShotsLiveSide], 0
    mov word ptr ds:[Fuel], 0
    mov word ptr ds:[MissilesLive], 0
    mov word ptr ds:[SidePodSpreadRight], 0
    mov word ptr ds:[SidePodSpreadLeft], 0
    mov word ptr ds:[AutoMoveExtraRecord], 0FFFFh
    call PickupFuel
    mov word ptr ds:[FireLatch], 0
    mov word ptr ds:[RandomWordCursor], offset CreditRandomWords
    mov word ptr ds:[EncounterLiveCount], 0
    mov word ptr ds:[EncounterEndDelay], 0
    mov word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    mov word ptr ds:[RecordTickCounter], 0
    ret

; Frees all of pool A, clears weapon, side shots, missiles and pod slots, and refreshes
; the upgrade display.
ResetPoolAAndUpgrades:
    mov word ptr cs:[SaveBufferCursor], offset PoolASaveBuffers
    mov cx, POOL_A_POINTER_COUNT
loc_0C4E5:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_FLASH_TIMER], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov word ptr ss:[bp + REC_DRAW_PASS], 1
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    mov ax, word ptr cs:[SaveBufferCursor]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[SaveBufferCursor], POOL_A_SAVE_BYTES
    pop cx
    loop loc_0C4E5
    mov word ptr ds:[WeaponMode], 0
    mov word ptr ds:[SideShotsEnabled], 0
    mov word ptr ds:[MissileAmmo], 0
    mov word ptr ds:[TrailingPodNear], 0FFFFh
    mov word ptr ds:[TrailingPodFar], 0FFFFh
    mov word ptr ds:[SidePodLeftInner], 0FFFFh
    mov word ptr ds:[SidePodRightInner], 0FFFFh
    mov word ptr ds:[SidePodLeftOuter], 0FFFFh
    mov word ptr ds:[SidePodRightOuter], 0FFFFh
    mov word ptr ds:[FrontPodRecord], 0FFFFh
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    call InitUpgradeSlots
    jmp near ptr DrawUpgradeSlots
loc_0C565:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    jmp word ptr cs:[bx + LevelCgaPaletteCases]
LevelCgaPaletteCases label word
    dw offset CgaSelectBrightPaletteNoBurst, offset CgaSelectBrightPalette1, offset CgaSelectBrightPalette0, offset CgaSelectBrightPalette1
    dw offset CgaSelectBrightPaletteNoBurst, offset CgaSelectBrightPalette0

; CGA: the level's palette routine; otherwise DAC colour 6 for the level (EGA with a VGA
; DAC only).
ApplyLevelPalette:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_0C565
    mov si, offset DacColor6Level1
    cmp word ptr ds:[LevelIndex], 1
    je SetDacColor6
    mov si, offset DacColor6Default

; SI = three RGB bytes: writes DAC entry 6 when VideoAdapter is EGA.
SetDacColor6:
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
; 1 enables the per-file flag bytes (DecodeFileFlags) while loading graphics.
PerFileFlagsEnabled db 0

EnableFileFlagsIfVgaDac:
    call ProbeVgaDac
    jne loc_0C5BC
    mov byte ptr cs:[PerFileFlagsEnabled], 1
loc_0C5BC:
    ret

; ZF when a VGA-compatible DAC answers (sets DAC colour 0 to black as a side effect).
ProbeVgaDac:
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

; Sets EmsAvailable to 1 when EmsDeviceName opens as a character device ready for
; output and INT 67h reports status OK, version 3.0+, a page frame and free pages (which
; it stores); else 0. The device handle is closed after the IOCTL checks.
DetectEms:
    mov dx, offset EmsDeviceName
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
    mov word ptr ds:[EmsPageFrame], bx
    mov ah, 042h
    int 067h
    or ah, ah
    jne loc_0C63A
    mov word ptr ds:[EmsTotalPages], dx
    mov word ptr ds:[EmsFreePages], bx
    or bx, bx
    je loc_0C63A
    mov byte ptr ds:[EmsAvailable], 1
    ret
loc_0C63A:
    mov byte ptr ds:[EmsAvailable], 0
    ret

; Frees the EMS handle of every FileCache entry held in EMS (EmsAvailable only).
ReleaseEmsCache:
    cmp byte ptr ds:[EmsAvailable], 0
    jne loc_0C648
    ret
loc_0C648:
    mov si, offset FileCache
loc_0C64B:
    cmp word ptr ds:[si + CACHE_NAME], -1
    jne loc_0C651
    ret
loc_0C651:
    push si
    cmp word ptr ds:[si + CACHE_SEGMENT], -1
    jne loc_0C65F
    mov dx, word ptr ds:[si + CACHE_EMS_HANDLE]
    mov ah, 045h
    int 067h
loc_0C65F:
    pop si
    add si, FILE_CACHE_ENTRY_BYTES
    jmp short loc_0C64B

; Maps logical pages 0..BX-1 of EMS handle DX to physical pages 0..BX-1.
MapEmsPages:
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

; Loads the file named by FileNamePtr to FileBufferSegment:FileBufferOffset: copied from
; FileCache when present, else read from disk (drive prompt and retry; ESC leaves through
; loc_05D0B) and then offered to CacheLoadedFile. Sets FileStatus.
LoadResourceFile:
    mov word ptr ds:[FileStatus], FILE_STATUS_OK
    call CopyFromFileCache
    jne loc_0C685
    ret
loc_0C685:
    mov word ptr ds:[LoadWordBB82], 0
loc_0C68B:
    call AdvanceABColonPrefix
    call ProbeFloppyReady
    jne loc_0C6A5
    mov dx, word ptr ds:[FileNamePtr]
    xor al, al
    mov ah, 03Dh
    call far ptr OpenResourceFile
    mov word ptr ds:[FileHandle], ax
    jae loc_0C6B7
loc_0C6A5:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je loc_0C6B4
    mov ah, DOS_GET_DRIVE
    int 021h
    cmp al, 2
    jb loc_0C68B
loc_0C6B4:
    jmp near ptr loc_05D0B
loc_0C6B7:
    cmp byte ptr ds:[LoadIsEnc], 0
    je loc_0C6DC
    mov ax, word ptr ds:[FileHandle]
    mov word ptr cs:[EncFileHandle], ax
    mov ax, word ptr ds:[FileBufferSegment]
    mov word ptr cs:[EncDestSegment], ax
    mov ax, word ptr ds:[FileBufferOffset]
    mov word ptr cs:[EncDestOffset], ax
    call DecodeEncFile
    mov ax, word ptr cs:[EncOutputBytes]
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
    call CacheLoadedFile
    ret

; Keeps a copy of the file just loaded (FileByteCount bytes) in EMS pages, or else in a
; new DOS memory block, and appends a FileCache entry. Never on Tandy, and never for
; ResidentFiles. Allocation failures just skip caching.
CacheLoadedFile:
    cmp word ptr cs:[VideoAdapter], VIDEO_TANDY
    jne loc_0C710
    ret
loc_0C710:
    mov si, offset ResidentFiles
loc_0C713:
    lodsw
    cmp ax, word ptr ds:[FileNamePtr]
    jne loc_0C71B
    ret
loc_0C71B:
    cmp ax, 0FFFFh
    jne loc_0C713
    cmp byte ptr ds:[EmsAvailable], 0
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
    mov di, word ptr ds:[FileCacheEnd]
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
    mov word ptr ds:[FileCacheEnd], di
    call MapEmsPages
    mov bx, word ptr ds:[EmsPageFrame]
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
    mov di, word ptr ds:[FileCacheEnd]
    mov ax, word ptr ds:[FileNamePtr]
    stosw
    mov ax, bx
    stosw
    mov ax, word ptr ds:[FileByteCount]
    stosw
    stosw
    stosw
    mov word ptr ds:[FileCacheEnd], di
loc_0C799:
    mov si, word ptr ds:[FileBufferOffset]
    mov ds, word ptr ds:[FileBufferSegment]
    mov es, bx
    xor di, di
    mov cx, word ptr ss:[FileByteCount]
    rep movsb
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Looks up FileNamePtr in FileCache. Hit: copies the cached bytes to
; FileBufferSegment:FileBufferOffset (mapping EMS pages first) and returns AL = 0, ZF = 1.
; Miss: AL = 1, ZF = 0.
CopyFromFileCache:
    mov si, offset FileCache
    mov ax, word ptr ds:[FileNamePtr]
loc_0C7B8:
    cmp word ptr ds:[si + CACHE_NAME], -1
    je loc_0C7FB
    cmp word ptr ds:[si + CACHE_NAME], ax
    je loc_0C7C6
    add si, FILE_CACHE_ENTRY_BYTES
    jmp short loc_0C7B8
loc_0C7C6:
    cmp word ptr ds:[si + CACHE_SEGMENT], -1
    jne loc_0C7DE
    mov dx, word ptr ds:[si + CACHE_EMS_HANDLE]
    mov bx, word ptr ds:[si + CACHE_EMS_PAGES]
    push si
    call MapEmsPages
    pop si
    mov ds, word ptr ss:[EmsPageFrame]
    jmp short loc_0C7E1
loc_0C7DE:
    mov ds, word ptr ds:[si + CACHE_SEGMENT]
loc_0C7E1:
    mov cx, word ptr ss:[si + CACHE_BYTES]
    xor si, si
    mov es, word ptr ss:[FileBufferSegment]
    mov di, word ptr ss:[FileBufferOffset]
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
    cmp byte ptr ds:[DriveAPresent], 1
    jne loc_0C82C
    ret
loc_0C82C:
    inc byte ptr ds:[si]
    jmp short AdvanceABColonPrefix
loc_0C830:
    cmp byte ptr ds:[DriveBPresent], 1
    jne loc_0C838
    ret
loc_0C838:
    inc byte ptr ds:[si]
    jmp short AdvanceABColonPrefix

; INT 11h: sets DriveAPresent and DriveBPresent.
DetectFloppyDrives:
    int 011h
    test al, 1
    jne loc_0C843
    ret
loc_0C843:
    mov byte ptr ds:[DriveAPresent], 1
    and al, 0C0h
    mov cl, 6
    shr al, cl
    inc al
    cmp al, 1
    jne loc_0C855
    ret
loc_0C855:
    mov byte ptr ds:[DriveBPresent], 1
    ret

; For A: or B: (from FileNamePtr or the current drive): NZ when a BIOS verify of
; cylinder 1 sector 1 times out.
ProbeFloppyReady:
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
    even
; State of the startup file checksum (VerifyStartupChecksums).
; Only ever cleared; 1 would skip the check.
IntegritySkip dw 0
; Checksum of the whole file, bytes read by the last chunk, running checksum, buffer.
IntegritySum dw 0
IntegrityBytesRead dw 0
IntegrityRunningSum dw 0
IntegrityBufferSegment dw 0
; Print the four DebugCodeword lines. No caller found in this image.
PrintDebugCodewords:
    mov bp, offset DebugCodewordLine
    call PrintMessageBP
    mov bp, offset DebugNonAsciiCodewordLine
    call PrintMessageBP
    mov bp, offset DebugOldNonAsciiCodewordLine
    call PrintMessageBP
    mov bp, offset DebugPasswordLine
    call PrintMessageBP
    ret

; Checksums OVERKILL.EXE and the data file (falls into ChecksumFileOrAbort).
VerifyStartupChecksums:
    mov word ptr cs:[IntegritySkip], 0
    mov dx, offset IntegrityFileExe
    call ChecksumFileOrAbort
    mov dx, offset IntegrityFileData

; DX = file name: sums it in 1400h-byte chunks; a mismatch shows the corrupt message and
; exits.
ChecksumFileOrAbort:
    mov word ptr ds:[FileNamePtr], dx
    mov bx, 0180h
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    mov word ptr cs:[IntegrityBufferSegment], ax
    xor al, al
    mov ah, DOS_OPEN_FILE
    int 021h
    mov word ptr ds:[FileHandle], ax
    mov word ptr cs:[IntegrityRunningSum], 01234h
loc_0C8DC:
    mov ds, word ptr cs:[MainDataSegment]
    mov bx, word ptr ds:[FileHandle]
    mov ds, word ptr cs:[IntegrityBufferSegment]
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
    mov word ptr cs:[IntegrityBytesRead], ax
    mov ax, word ptr cs:[IntegrityRunningSum]
    mov cx, word ptr cs:[IntegrityBytesRead]
    jcxz loc_0C925
    mov si, 042h
    mov dh, 0
loc_0C916:
    mov dl, byte ptr ds:[si]
    add ax, dx
    add ah, al
    inc si
    loop loc_0C916
    mov word ptr cs:[IntegrityRunningSum], ax
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
    mov word ptr cs:[IntegritySum], ax
    cmp ax, word ptr ds:[si]
    pushf
    cmp word ptr cs:[IntegritySkip], 1
    je loc_0C980
    cmp word ptr ss:[FileNamePtr], offset IntegrityFileExe
    jne loc_0C980
    sub si, 040h
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset Codeword
    call XorCopy16BytesAA
    mov di, offset NonAsciiCodeword
    call XorCopy16BytesAA
    mov di, offset OldNonAsciiCodeword
    call XorCopy16BytesAA
    mov di, offset Password
    call XorCopy16BytesAA
loc_0C980:
    mov es, word ptr cs:[IntegrityBufferSegment]
    mov ah, DOS_FREE_MEMORY
    int 021h
    popf
    mov ds, word ptr cs:[MainDataSegment]
    jne loc_0C992
    ret
loc_0C992:
    cmp word ptr cs:[IntegritySkip], 1
    jne loc_0C99B
    ret
loc_0C99B:
    mov ax, 3
    int 010h
    mov dx, offset CorruptMsgHead
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, word ptr ds:[FileNamePtr]
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dx, offset CorruptMsgTail
    mov ah, DOS_PRINT_STRING
    int 021h
    mov dl, 0
    mov dh, 018h
    mov ah, 2
    mov bh, 0
    int 010h
    mov dx, offset CorruptMsgPressKey
    mov ah, DOS_PRINT_STRING
    int 021h
    call DrainBiosKeysInt16
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

; Reads and discards keys through INT 16h until the BIOS queue is empty.
DrainBiosKeysInt16:
    mov ah, 1
    int 016h
    je loc_0C9E9
    xor ah, ah
    int 016h
    jmp short DrainBiosKeysInt16
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
; Print which sound module loaded (SoundCardCaption*) and wait 0AFh frames. No caller
; found in this image.
ShowSoundCardCaption:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    je loc_0CA97
    mov ax, ds:[SoundModuleNamePtr]
    mov bp, offset SoundCardCaptionAdlib
    cmp ax, offset SoundModuleNameAdlib
    je loc_0CA8C
    mov bp, offset SoundCardCaptionTandy
    cmp ax, offset SoundModuleNameTandy
    je loc_0CA8C
    mov bp, offset SoundCardCaptionRoland
    cmp ax, offset SoundModuleNameRoland
    je loc_0CA8C
    jmp short loc_0CA97
loc_0CA8C:
    call PrintMessageBP
    mov cx, 0AFh
loc_0CA92:
    call WaitVerticalRetrace
    loop loc_0CA92
loc_0CA97:
    ret

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
    mov dx, offset SoundModuleNameTandy
    call LoadSoundModuleFile
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
    mov dx, offset SoundModuleNameRoland
    call LoadSoundModuleFile
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
    mov dx, offset SoundModuleNameAdlib
    call LoadSoundModuleFile
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

RequestModuleMusic:
    mov byte ptr ds:[ModuleSoundRequest], al
    cmp byte ptr ds:[ModuleSoundEnabled], 0
    je loc_0CB3D
    xor ah, ah
    mov bx, seg SoundModuleSlot
    mov es, bx
    cmp al, byte ptr es:[MODULE_MUSIC_CURRENT]
    je loc_0CB3D
    mov word ptr es:[MODULE_MUSIC_REQUEST], ax
    mov ds, word ptr cs:[MainDataSegment]
loc_0CB3D:
    ret

; With a sound module loaded: MODULE_MUSIC_REQUEST = FFh, then waits five timer ticks so
; the module sees it. ES = module segment.
StopModuleMusic:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne loc_0CB46
    ret
loc_0CB46:
    mov ax, seg SoundModuleSlot
    mov es, ax
    mov word ptr es:[MODULE_MUSIC_REQUEST], 0FFh
    mov cx, 5
loc_0CB55:
    push cx
    call WaitTimerInterruptIfModule
    pop cx
    loop loc_0CB55
    mov ds, word ptr cs:[MainDataSegment]
    ret
; Store AL at the module's MODULE_BYTE_0A. No caller found in this image.
SetModuleByte0A:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne loc_0CB6A
    ret
loc_0CB6A:
    push es
    push bx
    mov bx, seg SoundModuleSlot
    mov es, bx
    mov byte ptr es:[MODULE_BYTE_0A], al
    pop bx
    pop es
    ret
; Request music AL even if it is current (high byte FFh first). No caller found.
ForceModuleMusic:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne loc_0CB80
    ret
loc_0CB80:
    push es
    push bx
    mov bx, seg SoundModuleSlot
    mov es, bx
    mov word ptr es:[MODULE_MUSIC_REQUEST], 0FFh
    mov byte ptr es:[MODULE_MUSIC_REQUEST], al
    pop bx
    pop es
    ret

; DX = module file name: loads it from the archive or DOS and ENC-decodes it into
; SoundModuleSlot; NZ (AL = 1) on success.
LoadSoundModuleFile:
    mov word ptr ds:[FileNamePtr], dx
    mov word ptr ds:[SoundModuleNamePtr], dx
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
    mov word ptr cs:[EncFileHandle], ax
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[EncDestSegment], seg SoundModuleSlot
    mov word ptr cs:[EncDestOffset], 0
    call DecodeEncFile
    jb loc_0CBD2
    or al, 1
    ret
loc_0CBD2:
    xor al, al
    ret

; With a sound module loaded, waits for one INT 08h tick (TimerTickPhase change).
WaitTimerInterruptIfModule:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne loc_0CBDD
    ret
loc_0CBDD:
    mov al, byte ptr ds:[TimerTickPhase]
loc_0CBE0:
    cmp al, byte ptr ds:[TimerTickPhase]
    je loc_0CBE0
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

; Title animation, then the bonus pages and demo unless a key ended it.
RunAttractSequence:
    call PlayTitleAnimation
    call ResetPageAndClearScreen
    call CgaSelectBrightPalette1
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CBFB
    call RunIntroPagesAndDemo
loc_0CBFB:
    mov cx, 01Eh
loc_0CBFE:
    call WaitVerticalRetrace
    loop loc_0CBFE
    ret

; Draws the backdrop and reveals the logo in three rounds; a key or the primary button
; cuts it short.
PlayTitleAnimation:
    mov byte ptr ds:[KeyLastMakeCode], 0
    call ResetPageAndClearScreen
    call CgaSelectBrightPalette0
    call DrawTitleBackdrop
    call CopyFullWorkspaceToScreen
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CC4E
    mov cx, 01Eh
    call DelayFramesUntilKeyOrPrimary
    mov word ptr ds:[TitleLogoPiecePtr], offset TitleLogoPieces
    call StageTitleLogoPieces
    call RevealTitleLogoCells
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CC4E
    call StageTitleLogoPieces
    call RevealTitleLogoCells
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CC4E
    call StageTitleLogoPieces
    call RevealTitleLogoCells
    mov cx, 032h
    call DelayFramesUntilKeyOrPrimary
loc_0CC4E:
    ret

; Copies the changed 8-pixel cells of the five TitleRevealRects from the staging page
; (workspace + 7D00h) to the screen with a flash and sfx.
RevealTitleLogoCells:
    mov word ptr ds:[RevealRectPtr], offset TitleRevealRects
    mov cx, 5
loc_0CC58:
    push cx
    mov word ptr ds:[RevealRectsLeft], cx
    mov si, word ptr ds:[RevealRectPtr]
    lodsb
    mov byte ptr ds:[RevealRow], al
    lodsb
    mov byte ptr ds:[RevealCol], al
    lodsb
    xor ah, ah
    mov cx, ax
    lodsb
    mov word ptr ds:[RevealColumns], ax
    mov word ptr ds:[RevealRectPtr], si
loc_0CC76:
    push cx
    push word ptr ds:[RevealCol]
    mov cx, word ptr ds:[RevealColumns]
loc_0CC7F:
    push cx
    mov ax, word ptr ds:[RevealCol]
    call DrawOffsetFromWideRow
    mov word ptr ds:[RevealCellOffset], di
    mov si, di
    add si, 07D00h
    xor dl, dl
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + RevealCellMergeCases]
    even
RevealCellMergeCases label word
    dw offset MergeRevealCellCga, offset MergeRevealCellEga, offset MergeRevealCellTandy

; Copies the cell from workspace + 7D00h into the workspace; DL = 1 if it changed.
MergeRevealCellCga:
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

MergeRevealCellTandy:
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

MergeRevealCellEga:
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
    cmp word ptr ds:[RevealRectsLeft], 4
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
    mov ax, word ptr ds:[RevealCol]
    call DrawOffsetFromScreenRow
    push di
    mov si, 012h
    shl si, 1
    add si, offset BlueBitsImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[BlueBitsSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    cmp word ptr ds:[RevealRectsLeft], 5
    je loc_0CD68
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne loc_0CD68
    call WaitVerticalRetrace
loc_0CD68:
    pop di
    mov si, word ptr ds:[RevealCellOffset]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + RevealCellShowCases]
    even
RevealCellShowCases label word
    dw offset ShowRevealCellCga, offset ShowRevealCellEga, offset ShowRevealCellTandy

; Copies the workspace cell at RevealCellOffset to the screen at DI.
ShowRevealCellCga:
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

ShowRevealCellTandy:
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

ShowRevealCellEga:
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
    inc byte ptr ds:[RevealCol]
    pop cx
    loop loc_0CE10
    jmp short loc_0CE13
loc_0CE10:
    jmp near ptr loc_0CC7F
loc_0CE13:
    pop word ptr ds:[RevealCol]
    add byte ptr ds:[RevealRow], 8
    pop cx
    loop loc_0CE21
    jmp short loc_0CE24
loc_0CE21:
    jmp near ptr loc_0CC76
loc_0CE24:
    cmp word ptr ds:[RevealRectsLeft], 5
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

; Blits the next five TitleLogoPieces into the staging page (workspace + 7D00h).
StageTitleLogoPieces:
    mov cx, 5
loc_0CE62:
    push cx
    mov si, word ptr ds:[TitleLogoPiecePtr]
    lodsb
    mov ah, al
    lodsb
    push si
    call DrawOffsetFromWideRow
    add di, 07D00h
    pop si
    lodsb
    mov word ptr ds:[TitleLogoPiecePtr], si
    xor ah, ah
    mov si, ax
    shl si, 1
    add si, offset BlueBitsImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[BlueBitsSegment]
    call BlitPackedStride160
    mov ds, word ptr cs:[MainDataSegment]
    pop cx
    loop loc_0CE62
    ret

; Composes the title background in the workspace and copies it to the staging page.
DrawTitleBackdrop:
    mov es, word ptr cs:[WorkspaceSegment]
    xor ax, ax
    call DrawOffsetFromWideRow
    mov si, 0Fh
    shl si, 1
    add si, offset BlueBitsImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[BlueBitsSegment]
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
    call DrawOffsetFromWideRow
    mov si, 010h
    shl si, 1
    add si, offset BlueBitsImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[BlueBitsSegment]
    call BlitPackedStride160
    mov ds, word ptr cs:[MainDataSegment]
    pop cx
    loop loc_0CEBD
    xor al, al
    mov ah, 0BEh
    call DrawOffsetFromWideRow
    mov si, 011h
    shl si, 1
    add si, offset BlueBitsImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[BlueBitsSegment]
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

; Tells the resource library (ResLibSetup, AX = 4000h) to search ResourceArchiveList.
SetupResourceArchive:
    mov ax, 04000h
    mov si, offset ResourceArchiveList
    call far ptr ResLibSetup
    ret

; Build the bonus intro screen one BonusIntroItems entry at a time (100 frames apart),
; then run the attract demo (DemoActive = 1, steps from DemoScript) until a key or the
; primary button.
RunIntroPagesAndDemo:
    call ResetEgaPages
    call ResetPageAndClearScreen
    mov byte ptr ds:[KeyLastMakeCode], 0
    mov cx, 4
    xor si, si
loc_0CF3E:
    push cx
    push si
    shl si, 1
    shl si, 1
    xor al, al
    mov ah, byte ptr ds:[si + BonusIntroItems]
    push word ptr ds:[si + BonusIntroItems + 2]
    push si
    call DrawOffsetFromScreenRow
    pop si
    mov al, byte ptr ds:[si + BonusIntroItems + 1]
    xor ah, ah
    mov si, ax
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    pop bp
    call PrintMessageBP
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
    mov word ptr ds:[DemoActive], 1
    call ResetEgaPages
    call ResetPageAndClearScreen
    call CgaSelectBrightPalette1
    call ClearWorkspace
    call ResetPoolAAndUpgrades
    call ResetRecordsForLife
    mov word ptr ds:[ShotsLiveMain], 0
    mov word ptr ds:[ShotsLiveType9], 0
    mov word ptr ds:[ShotsLiveSide], 0
    mov word ptr ds:[ShotsLiveFrontPod], 0
    mov word ptr ds:[MissilesLive], 0
    mov word ptr ds:[MapScrollPos], MAP_START_POS
    call InitPositionHistory
; Clear the shared byte-attribute table before calling the setup path at 007EF.
; Forward fill requires DF=0; this is state initialization, not static table contents.
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset ByteAttributeTable
    mov cx, BYTE_ATTRIBUTE_COUNT
    xor al, al
    rep stosb
    call DrawStatusPanel
    mov bp, offset PrimaryRecord
    call StoreApplyHistoryAndConditionalPlacement
    call UpdateAllRecords
    mov word ptr ds:[DemoStep], 0
    mov word ptr ds:[DemoStepTimer], 064h
    mov byte ptr ds:[KeyLastMakeCode], 0
loc_0D007:
    call ClearTimerTick
    call FlipEgaDrawPage
    call DrawRecordsToWorkspace
    call CopyWorkspaceToScreen
    call RestoreRecordBackgrounds
    call RunDemoScriptFrame
    call UpdateAllRecords
    call TickFrameTimers
    call CheckBossKey
    call ShowEgaDrawPage
    call WaitTimerTick
    cmp word ptr ds:[DemoStep], 013h
    je loc_0D040
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_0D040
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_0D007
loc_0D040:
    mov word ptr ds:[DemoActive], 0
    call ResetPageAndClearScreen
    call ClearWorkspace
    ret

; One attract-demo frame: caption, beam, forced fire; advances DemoStep when its timer
; expires and applies that step's upgrade and action.
RunDemoScriptFrame:
    mov word ptr ds:[ScrollDeltaY], 0
    mov al, 01Fh
    mov ah, 018h
    call DrawOffsetFromScreenRow
    mov bx, word ptr ds:[DemoStep]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov si, word ptr ds:[bx + DemoScript]
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    push ds
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    pop ds
    call UpdateBeam
    cmp word ptr ds:[DemoStep], 8
    jb loc_0D0CA
    cmp word ptr ds:[DemoStepTimer], 014h
    jb loc_0D0CA
    mov byte ptr ds:[InputBits], 0
    inc word ptr ds:[DemoFireCycle]
    cmp word ptr ds:[DemoFireCycle], 014h
    jb loc_0D0A4
    mov word ptr ds:[DemoFireCycle], 0
loc_0D0A4:
    cmp word ptr ds:[DemoFireCycle], 0Fh
    je loc_0D0B9
    cmp word ptr ds:[DemoFireCycle], 011h
    je loc_0D0B9
    cmp word ptr ds:[DemoFireCycle], 013h
    jne loc_0D0BE
loc_0D0B9:
    mov byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
loc_0D0BE:
    mov bp, offset PrimaryRecord
    mov word ptr ds:[FireLatch], 0
    call HandleFireButton
loc_0D0CA:
    cmp word ptr ds:[DemoStep], 0
    jne loc_0D0D4
    jmp near ptr DemoRiseShipToY60
loc_0D0D4:
    dec word ptr ds:[DemoStepTimer]
    je loc_0D0DB
    ret
loc_0D0DB:
    mov word ptr ds:[DemoStepTimer], 064h
    inc word ptr ds:[DemoStep]
    mov bx, word ptr ds:[DemoStep]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov ax, word ptr ds:[bx + DemoScript + 2]
    cmp ax, 0FFFFh
    je loc_0D107
    mov word ptr ds:[SelectedUpgradeSlot], ax
    mov ax, word ptr ds:[bx + DemoScript + 4]
    mov word ptr ds:[DemoUpgradeStatus], ax
    call DrawUpgradeSlots
loc_0D107:
    mov bx, word ptr ds:[DemoStep]
    shl bx, 1
    jmp word ptr cs:[bx + DemoStepActions]
DemoStepActions label word
    dw offset CountXReturn, offset DemoStepLaunchFrontPod, offset DemoStepLaunchInnerSidePods, offset DemoStepNextShipForm
    dw offset DemoStepLaunchOuterSidePods, offset DemoStepNextShipForm, offset DemoStepLaunchTrailingPodNear, offset DemoStepLaunchTrailingPodFar
    dw offset CountXReturn, offset CountXReturn, offset DemoStepNextWeaponMode, offset DemoStepEnableSideShots
    dw offset DemoStepNextWeaponMode, offset DemoStepNextWeaponMode, offset DemoStepNextWeaponMode, offset DemoStepNextWeaponMode
    dw offset DemoStepSpawnPathEnemy51, offset DemoStepGiveMissile, offset CountXReturn, offset CountXReturn
DemoStepSpawnPathEnemy51:
    call SpawnEnemyHere
    mov word ptr ds:[bx + REC_X], 0C0h
    mov word ptr ds:[bx + REC_Y], 0C8h
    mov word ptr ds:[bx + REC_TYPE], 51h
    ret
DemoStepNextWeaponMode:
    inc word ptr ds:[WeaponMode]
    ret
DemoStepEnableSideShots:
    mov word ptr ds:[SideShotsEnabled], 1
    ret
DemoStepGiveMissile:
    mov word ptr ds:[MissileAmmo], 1
    ret
DemoRiseShipToY60:
    cmp word ptr ds:[PrimaryRecord + REC_Y], 060h
    jne loc_0D16A
    jmp near ptr loc_0D0D4
loc_0D16A:
    dec word ptr ds:[PrimaryRecord + REC_Y]
    mov bp, offset PrimaryRecord
    call StoreApplyHistoryAndConditionalPlacement
    cmp word ptr ds:[PrimaryRecord + REC_Y], 060h
    je loc_0D17C
    ret
loc_0D17C:
    mov word ptr ds:[DemoStepTimer], 032h
    ret
DemoStepNextShipForm:
    inc word ptr ds:[PrimaryRecord + REC_SPRITE]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D193
    mov byte ptr ds:[SfxRequest], 6
loc_0D193:
    mov word ptr ds:[DemoStepTimer], 032h
    mov bp, offset PrimaryRecord
    jmp near ptr PlaceSidePods
DemoStepLaunchFrontPod:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D1AB
    mov byte ptr ds:[SfxRequest], 01Eh
loc_0D1AB:
    mov bp, offset PrimaryRecord
    call FindFreeRecordPoolA
    mov word ptr ds:[FrontPodRecord], bx
    call InitEnemyRecordHere
    mov word ptr ds:[bx + REC_Y], 0
    mov word ptr ds:[bx + REC_SPRITE], 0Fh
    mov word ptr ds:[bx + REC_TYPE], 050h
    mov bp, bx
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    sub ax, 8
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    ret
DemoStepLaunchTrailingPodNear:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D1E8
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0D1E8:
    call AddTrailingPod
    mov bp, ds:[TrailingPodNear]
    call DemoLaunchTrailingPod
    mov word ptr ss:[bp + REC_X], 0
    ret
DemoStepLaunchTrailingPodFar:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D204
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0D204:
    call AddTrailingPod
    mov bp, ds:[TrailingPodFar]
    call DemoLaunchTrailingPod
    add word ptr ss:[bp + REC_SAVED_Y], 14h
    ret
; BP = pod: DemoLaunchPod homing on the player position + (8, 28h).
DemoLaunchTrailingPod:
    call DemoLaunchPod
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    mov ss:[bp + REC_SAVED_X], ax
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    add ax, 28h
    mov ss:[bp + REC_SAVED_Y], ax
    ret
DemoStepLaunchInnerSidePods:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D235
    mov byte ptr ds:[SfxRequest], 01Eh
loc_0D235:
    call AddSidePods
    mov bp, word ptr ds:[SidePodLeftInner]
    call DemoLaunchPod
    mov word ptr ss:[bp + REC_X], 0
    mov bp, word ptr ds:[SidePodRightInner]
    jmp short DemoLaunchPod
DemoStepLaunchOuterSidePods:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D256
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0D256:
    call AddSidePods
    mov bp, ds:[SidePodLeftOuter]
    call DemoLaunchPod
    mov word ptr ss:[bp + REC_X], 0
    mov bp, ds:[SidePodRightOuter]
; BP = pod: remembers its position as REC_SAVED and restarts it at (C8h, C0h) as a type
; 50h enemy that flies home and becomes a pod again.
DemoLaunchPod:
    call StoreRecordSavedPosition
    mov word ptr ss:[bp + REC_Y], 0C8h
    mov word ptr ss:[bp + REC_X], 0C0h
    mov word ptr ss:[bp + REC_TYPE], 050h
    mov word ptr ss:[bp + REC_KIND], KIND_ENEMY
    ret
; Steers to REC_SAVED; on arrival becomes KIND_POD (sfx 0Eh) and returns without the
; scroll tail.
Type50SteerHomeThenBecomePod:
    mov ax, word ptr ss:[bp + REC_SAVED_X]
    mov word ptr ds:[SteerTargetX], ax
    mov ax, word ptr ss:[bp + REC_SAVED_Y]
    mov word ptr ds:[SteerTargetY], ax
    mov word ptr ds:[SteerSpeed], 1
    call SteerTowardTarget
    mov word ptr ds:[SteerSpeed], 2
    cmp word ptr ds:[SteerArrived], 0
    jne loc_0D2A4
    ret
loc_0D2A4:
    mov word ptr ss:[bp + REC_KIND], KIND_POD
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D2B5
    mov byte ptr ds:[SfxRequest], 0Eh
loc_0D2B5:
    ret
; Offset of the one image of the page or level screen being shown.
ScreenImageOffset dw 0

; Load page PageIndex of PageListPtr to the workspace at 8000h and show it.
LoadAndShowPage:
    mov si, word ptr ds:[PageListPtr]
    mov bx, word ptr ds:[PageIndex]
    shl bx, 1
    mov ax, word ptr ds:[bx + si]
    mov word ptr cs:[LoadNamePtr], ax
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[LoadDestSegment], ax
    mov word ptr cs:[LoadDestOffset], 08000h
    mov word ptr cs:[LoadImageSlot], offset ScreenImageOffset
    mov byte ptr ds:[LoadIsEnc], 1
    call LoadGraphicsRecordImages
    mov byte ptr ds:[LoadIsEnc], 0
    mov word ptr cs:[LoadDestOffset], 0
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
    mov word ptr ds:[SequenceFrameCount], 0
loc_0D318:
    call ClearTimerTick
    call FlipEgaDrawPage
    call DrawStars
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0D32C
    call CopyWorkspaceToScreen
loc_0D32C:
    call DrawPlaqueImage
    call EraseStars
    call far ptr MoveStars
    call CheckBossKey
    call UpdateRefuelTimersAndScore
    call ShowEgaDrawPage
    call WaitTimerTick
    call WaitVerticalRetrace
    inc word ptr ds:[SequenceFrameCount]
    cmp word ptr ds:[SequenceFrameCount], 0C8h
    ja loc_0D35C
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_0D318
loc_0D35C:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_0D35C
    ret

; Draws the first PlaqueSegment image at row 47h, column 3.
DrawPlaqueImage:
    mov ah, 047h
    mov al, 3
    call DrawOffsetFromScreenRow
    xor si, si
    mov ds, word ptr cs:[PlaqueSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    ret
; Image offsets of choose.enc (space for 9).
ChooseImageOffsets dw 9 dup (0)

; Load levscr.enc and choose.enc, let the player pick a slot (0..5) with
; ReadChooseScreenInput and derive LevelIndex from it (slot 5 gives -1).
RunChooseScreen:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne RunChooseScreen
    call ResetEgaPages
    mov byte ptr ds:[LoadIsEnc], 1
    mov word ptr cs:[LoadNamePtr], offset File_LEVSCR_ENC
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[LoadDestSegment], ax
    mov word ptr cs:[LoadDestOffset], 08000h
    mov word ptr cs:[LoadImageSlot], offset ScreenImageOffset
    mov byte ptr cs:[CgaColorMap + 7], 0
    call LoadGraphicsRecordImages
    mov byte ptr cs:[CgaColorMap + 7], 1
    mov word ptr cs:[LoadNamePtr], offset File_CHOOSE_ENC
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[LoadDestSegment], ax
    mov word ptr cs:[LoadDestOffset], 04000h
    mov word ptr cs:[LoadImageSlot], offset ChooseImageOffsets
    mov word ptr ds:[ClearWorkspaceHalfOnly], 1
    call LoadGraphicsRecordImages
    mov word ptr ds:[ClearWorkspaceHalfOnly], 0
    mov byte ptr ds:[LoadIsEnc], 0
    mov word ptr cs:[LoadDestOffset], 0
loc_0D406:
    call ClearTimerTick
    call FlipEgaDrawPage
    call DrawChooseScreen
    call ShowEgaDrawPage
    call WaitVerticalRetrace
    call ReadChooseScreenInput
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_0D424
    call WaitTimerTick
    jmp short loc_0D406
loc_0D424:
    mov ax, word ptr ds:[ChooseSlot]
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
    cmp byte ptr ds:[KeyDownTable + SCAN_D], KEY_STATE_DOWN
    je ReadChooseScreenInput
loc_0D43B:
    call PollInputBits
    cmp byte ptr ds:[InputBits], 0
    jne loc_0D43B
loc_0D445:
    cmp byte ptr ds:[KeyDownTable + SCAN_D], KEY_STATE_DOWN
    je loc_0D498
    call PollInputBits
    mov al, byte ptr ds:[ChooseSlot]
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
    mov byte ptr ds:[ChooseSlot], al
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
    inc word ptr ds:[DifficultySetting]
    cmp word ptr ds:[DifficultySetting], 3
    jb loc_0D4A9
    mov word ptr ds:[DifficultySetting], 0
loc_0D4A9:
    ret

; Draws the level choice background and the images for ChooseSlot and DifficultySetting.
DrawChooseScreen:
    xor di, di
    mov si, 08000h
    mov ds, word ptr cs:[WorkspaceSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov bx, word ptr ds:[ChooseSlot]
    shl bx, 1
    mov ax, word ptr ds:[bx + ChooseSlotPositions]
    call DrawOffsetFromScreenRow
    mov bx, word ptr ds:[ChooseSlot]
    add bx, 0
    shl bx, 1
    mov si, word ptr cs:[bx + ChooseImageOffsets]
    mov ds, word ptr cs:[WorkspaceSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov bx, word ptr ds:[DifficultySetting]
    shl bx, 1
    mov ax, word ptr ds:[bx + DifficultyPositions]
    call DrawOffsetFromScreenRow
    mov bx, word ptr ds:[DifficultySetting]
    add bx, 6
    shl bx, 1
    mov si, word ptr cs:[bx + ChooseImageOffsets]
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
    mov di, offset SfxVoiceA
    call SfxVoiceTick
    mov di, offset SfxVoiceB
    call SfxVoiceTick
    mov al, byte ptr ds:[SfxTickPhase]
    shr al, 1
    jb @@select_voice_b
    cmp byte ptr ds:[SfxVoiceA + SFX_VOICE_SOUNDING], 0
    je SfxReturn
    mov bx, word ptr ds:[SfxVoiceA + SFX_VOICE_DIVISOR]
    jmp short @@program_speaker
@@select_voice_b:
    cmp byte ptr ds:[SfxVoiceB + SFX_VOICE_SOUNDING], 0
    je SfxReturn
    mov bx, word ptr ds:[SfxVoiceB + SFX_VOICE_DIVISOR]
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
    mov si, offset SfxEffectTable
    add si, ax
    lodsw
    mov word ptr ds:[SfxVoiceA + SFX_VOICE_STREAM], ax
    lodsw
    mov word ptr ds:[SfxVoiceB + SFX_VOICE_STREAM], ax
    xor al, al
    mov byte ptr ds:[SfxVoiceA + SFX_VOICE_NOTE_STEP], al
    mov byte ptr ds:[SfxVoiceB + SFX_VOICE_NOTE_STEP], al
    mov byte ptr ds:[SfxVoiceA + SFX_VOICE_SLIDE_TICKS], al
    mov byte ptr ds:[SfxVoiceB + SFX_VOICE_SLIDE_TICKS], al
    mov byte ptr ds:[SfxRequest], al
    inc al
    mov byte ptr ds:[SfxVoiceA + SFX_VOICE_COUNTDOWN], al
    mov byte ptr ds:[SfxVoiceB + SFX_VOICE_COUNTDOWN], al
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
    mov al, byte ptr ds:[SfxVoiceA + SFX_VOICE_SOUNDING]
    or al, byte ptr ds:[SfxVoiceB + SFX_VOICE_SOUNDING]
    jne SfxStreamStoreAndWait
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    jmp short SfxStreamStoreAndWait
; Bytes 80h..DFh dispatch through SfxCommandTable; E0h..FFh set the duration.
SfxStreamCommandByte:
    cmp al, SFX_STREAM_DURATION
    jae @@set_duration
    shl al, 1
    xor ah, ah
    mov si, ax
    add si, offset SfxCommandTable
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
    add si, offset SfxNoteDivisors
    mov ax, word ptr ds:[si]
    mov word ptr ds:[di + SFX_VOICE_DIVISOR], ax
SfxVoiceNoteDone:
    ret
; Command 80h and requests >= SFX_EFFECT_COUNT: end the effect and silence the speaker.
SfxStopAll:
    xor al, al
    mov byte ptr ds:[SfxActive], al
    mov byte ptr ds:[SfxVoiceA + SFX_VOICE_SOUNDING], al
    mov byte ptr ds:[SfxVoiceB + SFX_VOICE_SOUNDING], al
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
    db 00h
; Text screen segment for ShowPaymentText (B800h colour, B000h mono).
TextScreenSegment dw 0
; First line shown and number of lines of the text file.
TextTopLine dw 0
TextLineCount dw 0
; DOS handle of the open ENC file (DecodeEncFile, ShowPaymentText).
EncFileHandle dw 0
; Show payment.enc in text mode, scrollable. No caller found in this image.
ShowPaymentText:
    mov ax, 3
    int 10h
    mov cx, 2000h
    mov ah, 1
    int 10h
    mov word ptr cs:[TextScreenSegment], 0B800h
    call ProbeMonoHercules
    je loc_0D687
    mov word ptr cs:[TextScreenSegment], 0B000h
loc_0D687:
    mov dx, offset PaymentFileName
    mov ds:[FileNamePtr], dx
    xor al, al
    mov ah, 3Dh
    call far ptr OpenResourceFile
    jae loc_0D6A4
    mov ah, 19h
    int 21h
    cmp al, 2
    jb loc_0D687
    jmp near ptr loc_05D0B
loc_0D6A4:
    mov cs:[EncFileHandle], ax
    mov ax, cs:[WorkspaceSegment]
    mov cs:[EncDestSegment], ax
    mov word ptr cs:[EncDestOffset], 0
    call DecodeEncFile
    jae loc_0D6BF
    jmp near ptr loc_0D84B
loc_0D6BF:
    mov word ptr cs:[TextTopLine], 0
    mov word ptr cs:[TextLineCount], 1
    mov es, cs:[WorkspaceSegment]
    xor si, si
loc_0D6D4:
    lods byte ptr es:[si]
    cmp al, 1Ah
    je loc_0D6E5
    cmp al, 0Dh
    jne loc_0D6D4
    inc word ptr cs:[TextLineCount]
    jmp short loc_0D6D4
loc_0D6E5:
    call DrawPaymentTextPage
loc_0D6E8:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne loc_0D6F2
    jmp near ptr loc_0D84B
loc_0D6F2:
    cmp byte ptr ds:[KeyDownTable + SCAN_HOME], KEY_STATE_DOWN
    je loc_0D71E
    cmp byte ptr ds:[KeyDownTable + SCAN_END], KEY_STATE_DOWN
    je loc_0D729
    cmp byte ptr ds:[KeyDownTable + SCAN_UP], KEY_STATE_DOWN
    je loc_0D756
    cmp byte ptr ds:[KeyDownTable + SCAN_DOWN], KEY_STATE_DOWN
    je loc_0D76E
    cmp byte ptr ds:[KeyDownTable + SCAN_PGUP], KEY_STATE_DOWN
    je loc_0D734
    cmp byte ptr ds:[KeyDownTable + SCAN_PGDN], KEY_STATE_DOWN
    je loc_0D745
    jmp short loc_0D6E8
loc_0D71E:
    mov bp, 0FFFFh
loc_0D721:
    call PaymentTextScrollUp
    dec bp
    jne loc_0D721
    jmp short loc_0D6E5
loc_0D729:
    mov bp, 0FFFFh
loc_0D72C:
    call PaymentTextScrollDown
    dec bp
    jne loc_0D72C
    jmp short loc_0D6E5
loc_0D734:
    call WaitTextRetrace4
    call WaitTextRetrace4
    mov bp, 17h
loc_0D73D:
    call PaymentTextScrollUp
    dec bp
    jne loc_0D73D
    jmp short loc_0D6E5
loc_0D745:
    call WaitTextRetrace4
    call WaitTextRetrace4
    mov bp, 17h
loc_0D74E:
    call PaymentTextScrollDown
    dec bp
    jne loc_0D74E
    jmp short loc_0D6E5
loc_0D756:
    call PaymentTextScrollUp
    jcxz loc_0D6E8
    jmp short loc_0D6E5
; TextTopLine - 1 when above 0; CX = 1 if it scrolled.
PaymentTextScrollUp:
    xor cx, cx
    cmp word ptr cs:[TextTopLine], 0
    je loc_0D76D
    dec word ptr cs:[TextTopLine]
    inc cx
loc_0D76D:
    ret
loc_0D76E:
    call PaymentTextScrollDown
    jcxz loc_0D775
    jmp short loc_0D778
loc_0D775:
    jmp near ptr loc_0D6E8
loc_0D778:
    jmp near ptr loc_0D6E5
; TextTopLine + 1 while a page remains below; CX = 1 if it scrolled.
PaymentTextScrollDown:
    xor cx, cx
    mov ax, cs:[TextTopLine]
    inc ax
    add ax, 18h
    cmp ax, cs:[TextLineCount]
    jae loc_0D792
    inc word ptr cs:[TextTopLine]
    inc cx
loc_0D792:
    ret
; Writes PaymentHelpRow and 24 text lines from TextTopLine to TextScreenSegment.
DrawPaymentTextPage:
    mov es, cs:[WorkspaceSegment]
    xor di, di
    mov dx, cs:[TextTopLine]
    or dx, dx
    je loc_0D7B4
loc_0D7A3:
    mov cx, 0FFFFh
    mov al, 0Dh
    repne scasb
    cmp byte ptr es:[di], 0Ah
    jne loc_0D7B1
    inc di
loc_0D7B1:
    dec dx
    jne loc_0D7A3
loc_0D7B4:
    mov si, di
    mov ds, cs:[WorkspaceSegment]
    mov es, cs:[TextScreenSegment]
    xor di, di
    push ds
    push si
    mov ds, cs:[MainDataSegment]
    mov si, offset PaymentHelpRow
    mov cx, 50h
    rep movsw
    pop si
    pop ds
    mov bp, 18h
    xor dx, dx
loc_0D7D8:
    or bp, bp
    je loc_0D83E
    lodsb
    cmp al, 1Ah
    je loc_0D83E
    cmp al, 9
    je loc_0D7F7
    cmp al, 0Dh
    je loc_0D81A
    mov ah, 1Bh
    stosw
    inc dx
    cmp dx, 50h
    jne loc_0D7D8
    xor dx, dx
    dec bp
    jmp short loc_0D7D8
loc_0D7F7:
    mov al, 20h
    mov ah, 1Bh
    test dx, 7
    je loc_0D80B
loc_0D801:
    stosw
    inc dx
    test dx, 7
    jne loc_0D801
    jmp short loc_0D818
loc_0D80B:
    cmp dx, 50h
    je loc_0D818
    add dx, 8
    mov cx, 8
    rep stosw
loc_0D818:
    jmp short loc_0D7D8
loc_0D81A:
    cmp byte ptr ds:[si], 0Ah
    jne loc_0D820
    inc si
loc_0D820:
    cmp dx, 50h
    je loc_0D835
    mov al, 20h
    mov ah, 1Bh
loc_0D829:
    stosw
    inc dx
    cmp dx, 50h
    jne loc_0D829
    xor dx, dx
    dec bp
    jmp short loc_0D7D8
loc_0D835:
    add di, 0A0h
    xor dx, dx
    dec bp
    jmp short loc_0D7D8
loc_0D83E:
    mov ds, cs:[MainDataSegment]
    push dx
    push bp
    call WaitTextRetrace4
    pop bp
    pop dx
    ret
loc_0D84B:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je loc_0D84B
    ret
WaitTextRetrace4:
    mov cx, 4
loc_0D856:
    call WaitTextVerticalRetrace
    loop loc_0D856
    ret
; Colour (3DAh bit 3) or Hercules (3BAh bit 7) retrace by TextScreenSegment.
WaitTextVerticalRetrace:
    mov dx, 3DAh
    mov ah, 8
    cmp word ptr cs:[TextScreenSegment], 0B800h
    je loc_0D86F
    mov dx, 3BAh
    mov ah, 80h
loc_0D86F:
    in al, dx
    and al, ah
    je loc_0D86F
loc_0D874:
    in al, dx
    and al, ah
    jne loc_0D874
    ret
; NZ when a CRTC answers at 3B4h and 3BAh bit 7 toggles (Hercules). A plain MDA returns
; ZF, so ShowPaymentText then writes to B800h.
ProbeMonoHercules:
    mov dx, 3B4h
    call ProbeCrtcAtDX
    je loc_0D89A
    mov dx, 3BAh
    in al, dx
    and al, 80h
    mov ah, al
    mov cx, 8000h
loc_0D88D:
    in al, dx
    and al, 80h
    cmp ah, al
    loope loc_0D88D
    mov al, 1
    jne loc_0D89A
    mov al, 0
loc_0D89A:
    ret
; DX = CRTC index port: NZ when register 0Fh reads back what was written (restored).
ProbeCrtcAtDX:
    mov al, 0Fh
    out dx, al
    inc dx
    in al, dx
    mov ah, al
    mov al, 66h
    out dx, al
    mov cx, 100h
loc_0D8A8:
    loop loc_0D8A8
    in al, dx
    xchg ah, al
    out dx, al
    cmp ah, 66h
    je loc_0D8B5
    xor ax, ax
loc_0D8B5:
    and ax, ax
    ret
; ENC (LZSS) input buffer, refilled 400h bytes at a time from EncFileHandle.
EncReadBuffer db 0400h dup (0)
; LZSS ring buffer: 4096 bytes, first write at 0FEEh, its first 0FEEh bytes cleared.
EncRingBuffer db 01000h dup (0)
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h

; Decode the ENC file open on EncFileHandle to EncDestSegment:EncDestOffset, then close
; it. Format is LZSS: flag bytes, literals, 12-bit position + 4-bit (length-3) pairs; a
; zero pair followed by a zero byte ends. EncOutputBytes counts the output; DS preserved.
; CF set if the first read fails.
DecodeEncFile:
    push ds
    push cs
    pop ds
    mov bx, word ptr cs:[EncFileHandle]
    mov cx, 0400h
    mov ax, 03F00h
    mov dx, offset EncReadBuffer
    int 021h
    jb loc_0ECEC
    call DecodeEncStream
    mov ax, 03E00h
    mov bx, word ptr cs:[EncFileHandle]
    int 021h
    clc
loc_0ECEC:
    pop ds
    ret
; Output pointer of DecodeEncFile (offset, segment).
EncDestOffset dw 0
EncDestSegment dw 0

DecodeEncStream:
    push es
    mov word ptr cs:[EncOutputBytes], 0
    mov word ptr cs:[EncOutputBytesHigh], 0
    les di, dword ptr cs:[EncDestOffset]
    mov byte ptr cs:[EncPushback], 0
    mov si, 0
    mov bp, 0
    mov cx, 07F7h
loc_0ED15:
    mov word ptr cs:[bp + EncRingBuffer], 0
    inc bp
    inc bp
    loop loc_0ED15
    mov bp, 0FEEh
    mov dx, 0
loc_0ED26:
    shr dx, 1
    test dx, 0100h
    jne loc_0ED35
    call ReadEncByte
    mov dl, al
    mov dh, 0FFh
loc_0ED35:
    test dx, 1
    je loc_0ED4D
    call ReadEncByte
    call StoreEncByte
    mov byte ptr cs:[bp + EncRingBuffer], al
    inc bp
    and bp, 0FFFh
    jmp short loc_0ED26
loc_0ED4D:
    call ReadEncByte
    mov ah, al
    call ReadEncByte
    xchg al, ah
    cmp ax, 0
    jne loc_0ED68
    call ReadEncByte
    cmp al, 0
    je loc_0ED95
    call PushBackEncByte
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
    mov al, byte ptr cs:[bx + EncRingBuffer]
    call StoreEncByte
    mov byte ptr cs:[bp + EncRingBuffer], al
    inc bx
    and bx, 0FFFh
    inc bp
    and bp, 0FFFh
    loop loc_0ED7A
    jmp short loc_0ED26
loc_0ED95:
    pop es
    ret

; Next input byte in AL (the pushed-back byte first), refilling EncReadBuffer from the
; file every 400h bytes. SI = buffer position; flags preserved across the refill.
ReadEncByte:
    test byte ptr cs:[EncPushback], 0FFh
    jne loc_0EDCF
    add si, offset EncReadBuffer
    lodsb
    sub si, offset EncReadBuffer
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
    mov dx, offset EncReadBuffer
    mov ax, 03F00h
    mov bx, word ptr cs:[EncFileHandle]
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
    mov al, byte ptr cs:[EncPushedByte]
    mov byte ptr cs:[EncPushback], 0
    ret

PushBackEncByte:
    mov byte ptr cs:[EncPushback], 1
    mov byte ptr cs:[EncPushedByte], al
    ret
; Bytes written by DecodeEncFile (32-bit).
EncOutputBytes dw 0
EncOutputBytesHigh dw 0

; Store AL at ES:DI, stepping ES by 1000h paragraphs when DI wraps; count it.
StoreEncByte:
    stosb
    or di, di
    jne loc_0EDF7
    push ax
    mov ax, es
    add ax, 01000h
    mov es, ax
    pop ax
loc_0EDF7:
    inc word ptr cs:[EncOutputBytes]
    jne loc_0EE03
    inc word ptr cs:[EncOutputBytesHigh]
loc_0EE03:
    ret
; Set when ReadEncByte has pushed back EncPushedByte (end-of-data check).
EncPushback db 0
EncPushedByte db 0
; Per level: map tiles rewritten before the view on a checkpoint restart
; (ResetMapBeforeView), as {tile, routine} pairs ending with 0FFFFh.
MapResetList0 dw 0E1h, offset SetMapTile1,  0E2h, offset SetMapTile1,  0E3h, offset SetMapTile1,  0E4h, offset SetMapTile1
    dw 0E5h, offset SetMapTile1,  0E6h, offset SetMapTile1,  0E7h, offset SetMapTile1,  0E8h, offset SetMapTile1
    dw 0E9h, offset SetMapTile1,  0EAh, offset SetMapTile1,  0EBh, offset SetMapTile1,  0ECh, offset SetMapTile1
    dw 0EDh, offset SetMapTile1,  0EEh, offset SetMapTile1,  0EFh, offset SetMapTile1,  0F0h, offset SetMapTile1
    dw 0F1h, offset SetMapTile1,  0F2h, offset SetMapTile1,  0F3h, offset SetMapTile1,  0F4h, offset SetMapTile1
    dw 0F5h, offset SetMapTile1,  0F6h, offset SetMapTile1,  0F7h, offset SetMapTile1,  0F8h, offset SetMapTile1
    dw 0F9h, offset SetMapTile1
    dw 0FFFFh
MapResetList1 dw 4h, offset SetMapTile1,  7h, offset SetMapTile1,  0C9h, offset SetMapTile28
    dw 0FFFFh
MapResetList2 dw 0C4h, offset SetMapTile1,  5Ah, offset SetMapTile1
    dw 0FFFFh
MapResetList3 dw 0CEh, offset SetMapTile1,  0CFh, offset SetMapTile1,  0D0h, offset SetMapTile1,  0D1h, offset SetMapTile1
    dw 0D2h, offset SetMapTile1,  0D3h, offset SetMapTile1,  0D4h, offset SetMapTile1,  0D5h, offset SetMapTile1
    dw 0D6h, offset SetMapTile1,  0D7h, offset SetMapTile1,  0D8h, offset SetMapTile1,  0D9h, offset SetMapTile1
    dw 0DAh, offset SetMapTile1,  0DBh, offset SetMapTile1,  0DCh, offset SetMapTile1,  0DDh, offset SetMapTile1
    dw 0DEh, offset SetMapTile1,  0DFh, offset SetMapTile1,  0E0h, offset SetMapTile1,  0E1h, offset SetMapTile1
    dw 0E2h, offset SetMapTile1,  0E3h, offset SetMapTile1,  0E4h, offset SetMapTile1,  0E5h, offset SetMapTile1
    dw 0E6h, offset SetMapTile1,  0E7h, offset SetMapTile1,  0E8h, offset SetMapTile1,  0E9h, offset SetMapTile1
    dw 0FFFFh
MapResetList4 dw 0C9h, offset SetMapTile28,  0CEh, offset SetMapTile1,  0CFh, offset SetMapTile1,  0D0h, offset SetMapTile1
    dw 0D1h, offset SetMapTile1,  0D2h, offset SetMapTile1,  0D3h, offset SetMapTile1,  0D4h, offset SetMapTile1
    dw 0D5h, offset SetMapTile1,  0D6h, offset SetMapTile1,  0D7h, offset SetMapTile1,  0D8h, offset SetMapTile1
    dw 0D9h, offset SetMapTile1,  0DAh, offset SetMapTile1,  0DBh, offset SetMapTile1,  0DCh, offset SetMapTile1
    dw 0DDh, offset SetMapTile1,  0DEh, offset SetMapTile1,  0DFh, offset SetMapTile1,  0E0h, offset SetMapTile1
    dw 0FFFFh
MapResetList5 dw 0D7h, offset SetMapTile1,  0D8h, offset SetMapTile1,  0D9h, offset SetMapTile1,  0DAh, offset SetMapTile1
    dw 0DBh, offset SetMapTile1,  0DCh, offset SetMapTile1,  0DDh, offset SetMapTile1,  0DEh, offset SetMapTile1
    dw 0DFh, offset SetMapTile1,  0E0h, offset SetMapTile1,  0E1h, offset SetMapTile1,  0E2h, offset SetMapTile1
    dw 0E3h, offset SetMapTile1,  0E4h, offset SetMapTile1,  0E5h, offset SetMapTile1,  0E6h, offset SetMapTile1
    dw 0E7h, offset SetMapTile1,  0E8h, offset SetMapTile1,  0E9h, offset SetMapTile1,  0EAh, offset SetMapTile1
    dw 0EBh, offset SetMapTile1,  0ECh, offset SetMapTile1,  0EDh, offset SetMapTile1,  0EEh, offset SetMapTile1
    dw 0EFh, offset SetMapTile1
    dw 0FFFFh
; REC_KIND 2 and 4: run the REC_TYPE handler (TypeHandlers).
RunTypeHandler:
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[DispatchRecordX], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[DispatchRecordY], ax
    mov bx, word ptr ss:[bp + REC_TYPE]
    shl bx, 1
    jmp word ptr cs:[bx + TypeHandlers]
; Behaviour handler per REC_TYPE (0..94h), entered with BP = record.
TypeHandlers label word
    dw offset ScrollRecordThenFinish, offset Type01ExplosionAnimation, offset Type02TimedStraightShot, offset Type02TimedStraightShot
    dw offset Type04StraightShot, offset Type05SideShotUpLeft, offset Type06SideShotUpRight, offset Type07RisingShot3
    dw offset Type08RisingShot16, offset Type09ExternallyMovedShot, offset Type0AHomingMissile, offset Type0BAimedEnemyShot
    dw offset Type0CTimedTurnUpShot, offset ScrollRecordThenFinish, offset ScrollRecordThenFinish, offset Type0FTimedShot2
    dw offset Type10StartPathFollowerA, offset Type11StartPathFollowerB, offset Type12WaypointPathFollower, offset Type13FormationLeader
    dw offset Type14FormationSwayDiver, offset Type13FormationLeader, offset Type16SweepLeadIn, offset Type16SweepLeadIn
    dw offset Type18SweepPathLooper, offset Type19WallPatrolShooter, offset Type1AWallPatrolA, offset Type1BWallPatrolB
    dw offset Type13FormationLeader, offset Type1DSlotBobThenChase, offset Type1EShuttleShooter, offset Type13FormationLeader
    dw offset Type20SlotHopperDropper, offset Type21EncounterDirector, offset Type22DescendThenBurst, offset Type23ColumnFaller
    dw offset Type24TurretLeftFire32, offset Type25TurretRightFire32, offset Type26WallProbeExtender, offset Type27SlowDescender
    dw offset Type28EnemyHatch, offset Type29EmergeThenDart, offset Type28EnemyHatch, offset Type2BAimedDart
    dw offset Type2CAimedDrifter, offset Type2DHoverFireThenPlunge, offset Type2EPlungeAtPlayerColumn, offset Type2FScrollingShuttle
    dw offset Type30AnimatedShooter, offset Type31FallFast3, offset Type32DescendThenBounce, offset Type33TerrainBouncer
    dw offset Type34SideFiringTurret, offset Type22DescendThenBurst, offset Type36SwayFallThenBurst, offset Type37VerticalBouncerShooter
    dw offset Type38WallBounceDescend, offset Type39DashRightAtRow80, offset Type3AHomeOnPlayerBelow80, offset Type3BFallRandomFlicker
    dw offset Type3CDescendThenBounceAlt, offset Type3DAnimatedTerrainBouncer, offset Type3EDropThenAimedDash, offset Type3FStraightLineToAimPoint
    dw offset Type40JitterFallShooter, offset Type41FollowPathType41, offset Type42DescendSway, offset Type43FollowPathType43
    dw offset Type44FollowPathType44, offset Type45FollowPathType45, offset Type46HoverShootThenDive, offset Type47PatrolDropShooter
    dw offset Type48CreeperAimedFire, offset Type49RadialBurstFaller, offset Type4AFollowPathType4A, offset Type4BDescendThenBounceUpRight
    dw offset Type4CSinkThenRise, offset Type4DSinkRiseThenDash, offset Type4EAnimDescendThenBounce, offset Type4FFallFast4Flicker
    dw offset Type50SteerHomeThenBecomePod, offset Type51FollowType51Path, offset Type52ScrollOnly, offset Type53AnimateFromField36
    dw offset Type54ScrollUntilY_B0ThenType56, offset Type55DropFrom_B0, offset Type56CrawlDestroyOnBlock, offset Type57ScrollToY80ThenCrawl
    dw offset Type57ScrollToY80ThenCrawl, offset Type59ScrollThenAnimateThenType5A, offset Type5ACrawlMirrorDiagonal, offset Type5BScrollPastY_B0ThenType5C
    dw offset Type5CRiseFast4, offset Type5DDropFast8, offset Type5ECrawlTurnDownToLeft, offset Type5FCrawlBounceDiagonal
    dw offset Type60FlyAlongAimLine, offset Type61InvaderSteerToSlot, offset Type62InvaderMarch, offset Type63ScriptedSlideThenDrop
    dw offset Type64DropSlow, offset Type65InvaderDiveFiring, offset Type66FollowPathType66, offset Type67FollowPathType67
    dw offset Type68JitterDescendFiring, offset Type69JitterDropToY18, offset Type6AScrollUntilY50ThenType56, offset Type6BDescendToX50
    dw offset Type6CDescendToX60Firing, offset Type6DDescendToX70, offset Type6ECrawlStaircase, offset Type6FWaitThenType70
    dw offset Type70CruiseFiring, offset Type71FireThenDiveBelow60, offset Type72DescendFiringAimed, offset Type73WaitThenRunRight
    dw offset Type74WaitThenRunLeft, offset Type75DescendSpreadShot, offset Type76SegBossPart0, offset Type77SegBossPart1
    dw offset Type78SegBossGunPart, offset Type79SegBossPart3, offset Type7AAimLineFlyer, offset Type7BDropThenAim
    dw offset Type7CAimLineFlyerAlt, offset Type13FormationLeader, offset Type13FormationLeader, offset Type7FMarchEnterSteer
    dw offset Type80MarchFormationMember, offset Type81SweeperEnterSteer, offset ScrollRecordThenFinish, offset Type83PatrolShootDown64
    dw offset Type84LurkUntilAligned, offset Type85ChargeUntilBlocked, offset Type86LaunchAimedEnemy, offset Type87AnimFireBurstA
    dw offset Type88WaitThenFireBurst, offset Type89PatrolShootDown32, offset Type8APatrolShootDown32Alt, offset Type8BClimbWalkerA
    dw offset Type8CClimbWalkerAFlipped, offset Type8DClimbWalkerB, offset Type8EClimbWalkerBFlipped, offset Type8FAnimFireBurstB
    dw offset Type90TurretVolley, offset Type91TurretVolleyAlt, offset Type92FireWhenPlayerLevel, offset Type93SweepDescendClimb
    dw offset ScrollRecordThenFinish
; Animates, then launches an aimed type 60h enemy.
Type86LaunchAimedEnemy:
    mov bx, ds:[FrameCount64]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shl bx, 1
    mov si, offset Type86FramesDir6
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    je loc_0F108
    mov si, offset Type86Frames
loc_0F108:
    mov ax, bx
    mov bx, ds:[bx + si]
    mov ss:[bp + REC_SPRITE], bx
    cmp ax, 4
    je loc_0F117
    jmp near ptr ScrollRecordThenFinish
loc_0F117:
    cmp word ptr ds:[FrameCount64], 26h
    je loc_0F121
    jmp near ptr ScrollRecordThenFinish
loc_0F121:
    call SpawnEnemyHere
    cmp bx, -1
    jne loc_0F12C
    jmp near ptr ScrollRecordThenFinish
loc_0F12C:
    call AimAtPlayer
    mov word ptr ds:[bx + REC_SPRITE], 0CBh
    mov word ptr ds:[bx + REC_TYPE], 60h
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 80h, then fires a burst in animation phase 2.
Type88WaitThenFireBurst:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae loc_0F146
    jmp near ptr ScrollRecordThenFinish
loc_0F146:
    mov bx, ds:[FrameCount64]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shl bx, 1
    mov si, offset Type88FramesDir6
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    je loc_0F160
    mov si, offset Type88Frames
loc_0F160:
    mov ax, bx
    mov bx, ds:[bx + si]
    mov ss:[bp + REC_SPRITE], bx
    cmp ax, 4
    je loc_0F16F
    jmp near ptr ScrollRecordThenFinish
loc_0F16F:
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly 50h, then continues as type 56h.
Type6AScrollUntilY50ThenType56:
    cmp word ptr ss:[bp + REC_Y], 50h
    je loc_0F17E
    jmp near ptr ScrollRecordThenFinish
loc_0F17E:
    mov word ptr ss:[bp + REC_TYPE], 56h
    jmp short Type56CrawlDestroyOnBlock
; Scrolls until Y is exactly B0h, then continues as type 56h.
Type54ScrollUntilY_B0ThenType56:
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_0F18F
    jmp near ptr ScrollRecordThenFinish
loc_0F18F:
    mov word ptr ss:[bp + REC_TYPE], 56h
; Three terrain steps per frame; destroyed when one is blocked.
Type56CrawlDestroyOnBlock:
    call TryTerrainStep
    jne loc_0F1A6
    call TryTerrainStep
    jne loc_0F1A6
    call TryTerrainStep
    jne loc_0F1A6
    jmp near ptr ScrollRecordThenFinish
loc_0F1A6:
    call DestroyRecord
    jmp near ptr ScrollRecordThenFinish
; Fires a burst while its animation is in phase 3.
Type87AnimFireBurstA:
    mov bx, ds:[FrameCount64]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    mov cx, bx
    shl bx, 1
    add bx, offset PingPongFrames8
    mov bx, ds:[bx]
    add bx, 0DDh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_X], 60h
    jae loc_0F1D0
    jmp near ptr loc_0878C
loc_0F1D0:
    add word ptr ss:[bp + REC_SPRITE], 3
    jmp near ptr loc_0878C
; Scrolls to Y B0h, then drops 4 px per frame without scrolling.
Type55DropFrom_B0:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je loc_0F1F1
    mov word ptr ss:[bp + REC_SPRITE], 73h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_0F1EC
    jmp near ptr ScrollRecordThenFinish
loc_0F1EC:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
loc_0F1F1:
    mov ax, ds:[FrameCount8]
    add ax, 77h
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr FinishRecordUpdate
; Types 57h/58h: scrolls to Y 80h, then crawls two steps per frame and is destroyed when
; blocked.
Type57ScrollToY80ThenCrawl:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae loc_0F20B
    jmp near ptr ScrollRecordThenFinish
loc_0F20B:
    jne loc_0F210
    call IncrementRecordSprite
loc_0F210:
    call TryTerrainStep
    call TryTerrainStep
    jne loc_0F21B
    jmp near ptr ScrollRecordThenFinish
loc_0F21B:
    jmp near ptr DestroyRecord
    jmp near ptr HorizontalTerrainPatrol
IncrementRecordSprite:
    inc word ptr ss:[bp + REC_SPRITE]
    ret
; Scrolls to Y 80h, animates, and becomes type 5Ah below Y C0h.
Type59ScrollThenAnimateThenType5A:
    mov word ptr ss:[bp + REC_SPRITE], 148h
    cmp word ptr ds:[LevelIndex], 0
    je loc_0F249
    cmp word ptr ds:[LevelIndex], 6
    je loc_0F249
    mov word ptr ss:[bp + REC_SPRITE], 174h
    cmp word ptr ds:[LevelIndex], 4
    je loc_0F249
    mov word ptr ss:[bp + REC_SPRITE], 0E3h
loc_0F249:
    cmp word ptr ss:[bp + REC_Y], 80h
    jg loc_0F253
    jmp near ptr ScrollRecordThenFinish
loc_0F253:
    mov ax, ds:[FrameCount4]
    add ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_Y], 0C0h
    jg loc_0F263
    jmp near ptr ScrollRecordThenFinish
loc_0F263:
    mov word ptr ss:[bp + REC_TYPE], 5Ah
; Crawls three steps per frame, mirroring its diagonal at the edges or a wall; destroyed
; when still blocked.
Type5ACrawlMirrorDiagonal:
    mov word ptr ss:[bp + REC_SPRITE], 148h
    cmp word ptr ds:[LevelIndex], 0
    je loc_0F28C
    cmp word ptr ds:[LevelIndex], 6
    je loc_0F28C
    mov word ptr ss:[bp + REC_SPRITE], 174h
    cmp word ptr ds:[LevelIndex], 4
    je loc_0F28C
    mov word ptr ss:[bp + REC_SPRITE], 0E3h
loc_0F28C:
    mov ax, ds:[FrameCount4]
    add ss:[bp + REC_SPRITE], ax
    call TryTerrainStep
    jne loc_0F2B1
    call TryTerrainStep
    jne loc_0F2B1
    call TryTerrainStep
    jne loc_0F2B1
    cmp word ptr ss:[bp + REC_X], 0
    jng loc_0F2B1
    cmp word ptr ss:[bp + REC_X], 0C0h
    jnl loc_0F2B1
    jmp near ptr ScrollRecordThenFinish
loc_0F2B1:
    xor word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    call TryTerrainStep
    je loc_0F2BD
    jmp near ptr DestroyRecord
loc_0F2BD:
    jmp near ptr ScrollRecordThenFinish
; Scrolls past Y B0h, then continues as type 5Ch.
Type5BScrollPastY_B0ThenType5C:
    cmp word ptr ss:[bp + REC_Y], 0B0h
    jg loc_0F2CA
    jmp near ptr ScrollRecordThenFinish
loc_0F2CA:
    mov word ptr ss:[bp + REC_TYPE], 5Ch
; Rises 4 px per frame.
Type5CRiseFast4:
    mov word ptr ss:[bp + REC_SPRITE], 73h
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
; Drops 8 px per frame.
Type5DDropFast8:
    mov ax, ds:[SlowCount8]
    add ax, 77h
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 8
    jmp near ptr ScrollRecordThenFinish
; Crawls four steps per frame, turning down, then down-left, then left; destroyed when
; blocked after that.
Type5ECrawlTurnDownToLeft:
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    jne loc_0F2FC
    jmp near ptr ScrollRecordThenFinish
loc_0F2FC:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je loc_0F30B
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
    je loc_0F313
    jmp near ptr DestroyRecord
loc_0F30B:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
    jmp near ptr ScrollRecordThenFinish
loc_0F313:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    jmp near ptr ScrollRecordThenFinish
; Crawls two steps per frame, alternating down and right when blocked.
Type6ECrawlStaircase:
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 128h
    mov ss:[bp + REC_SPRITE], bx
    call TryTerrainStep
    call TryTerrainStep
    jne loc_0F337
    jmp near ptr ScrollRecordThenFinish
loc_0F337:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je loc_0F345
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jmp near ptr ScrollRecordThenFinish
loc_0F345:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp near ptr ScrollRecordThenFinish
; Crawls four steps per frame, bouncing between the two downward diagonals; destroyed
; otherwise when blocked.
Type5FCrawlBounceDiagonal:
    mov ax, ds:[FrameCount4]
    add ax, 0F6h
    mov ss:[bp + REC_SPRITE], ax
    mov ax, ss:[bp + REC_Y]
    add ax, ss:[bp + REC_X]
    cmp ax, 60h
    jae loc_0F364
    jmp near ptr ScrollRecordThenFinish
loc_0F364:
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    jne loc_0F375
    jmp near ptr ScrollRecordThenFinish
loc_0F375:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    je loc_0F384
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    je loc_0F38C
    jmp near ptr DestroyRecord
loc_0F384:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_RIGHT
    jmp near ptr ScrollRecordThenFinish
loc_0F38C:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
    jmp near ptr ScrollRecordThenFinish
; Steers to its invader slot (REC_SAVED) at speed 3, then becomes type 62h.
Type61InvaderSteerToSlot:
    mov ax, ss:[bp + REC_SAVED_Y]
    mov ds:[SteerTargetY], ax
    mov ax, ss:[bp + REC_SAVED_X]
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 3
    call SteerTowardTarget
    cmp word ptr ds:[SteerArrived], 0
    jne loc_0F3B3
    jmp near ptr ScrollRecordThenFinish
loc_0F3B3:
    mov word ptr ss:[bp + REC_TYPE], 62h
    jmp near ptr ScrollRecordThenFinish
; Marches with the invader block (March* state).
Type62InvaderMarch:
    cmp word ptr ds:[FramesSinceInvaderSpawn], 18h
    jae loc_0F3C5
    jmp near ptr ScrollRecordThenFinish
loc_0F3C5:
    mov ax, ds:[InvaderDropStep]
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 0D0h
    jna loc_0F3EB
    mov word ptr ss:[bp + REC_SPRITE], 0E7h
    mov word ptr ss:[bp + REC_TYPE], 61h
    and word ptr ss:[bp + REC_Y], -8
    and word ptr ss:[bp + REC_X], -8
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
    jmp short Type61InvaderSteerToSlot
loc_0F3EB:
    mov ax, 1
    cmp word ptr ds:[EncounterLiveCount], 10h
    ja loc_0F416
    mov ax, 2
    cmp word ptr ds:[EncounterLiveCount], 8
    ja loc_0F416
    mov ax, 4
    cmp word ptr ds:[EncounterLiveCount], 4
    ja loc_0F416
    mov ax, 8
    cmp word ptr ds:[EncounterLiveCount], 1
    ja loc_0F416
    mov ax, 10h
loc_0F416:
    neg ax
    and ss:[bp + REC_X], ax
    neg ax
    mov bx, 0C0h
    mov cx, 1
    cmp word ptr ds:[InvaderMarchLeft], 0
    je loc_0F431
    neg ax
    xor bx, bx
    mov cx, 0
loc_0F431:
    add ss:[bp + REC_X], ax
    cmp ss:[bp + REC_X], bx
    jne loc_0F446
    mov ds:[InvaderNextMarchLeft], cx
    mov word ptr ds:[InvaderNextDropStep], 2
    call SpawnAimedShot
loc_0F446:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    cmp ss:[bp + REC_X], ax
    jne loc_0F45D
    call NextRandomWord
    and bx, 1Fh
    jne loc_0F45D
    mov word ptr ss:[bp + REC_TYPE], 65h
    jmp short Type63ScriptedSlideThenDrop
loc_0F45D:
    mov ax, ds:[RecordTickCounter]
    and ax, 7Fh
    cmp ax, ds:[FrameCount128]
    je loc_0F46C
    jmp near ptr ScrollRecordThenFinish
loc_0F46C:
    cmp word ptr ds:[FrameCount4], 0
    je loc_0F476
    jmp near ptr ScrollRecordThenFinish
loc_0F476:
    inc word ptr ds:[RecordTickCounter]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0F48A
    jmp near ptr ScrollRecordThenFinish
loc_0F48A:
    mov word ptr ds:[bx + REC_SPRITE], 63h
    jmp near ptr ScrollRecordThenFinish
; Dives 4 px per frame, firing aimed shots while its sprite advances.
Type65InvaderDiveFiring:
    add word ptr ss:[bp + REC_Y], 4
    cmp word ptr ds:[FrameCount4], 3
    je loc_0F4A0
    jmp near ptr ScrollRecordThenFinish
loc_0F4A0:
    cmp word ptr ss:[bp + REC_SPRITE], 0EBh
    jne loc_0F4AA
    jmp near ptr ScrollRecordThenFinish
loc_0F4AA:
    inc word ptr ss:[bp + REC_SPRITE]
    call SpawnAimedShot
    jmp near ptr ScrollRecordThenFinish
; Waits for Y 50h, then plays a scripted slide by sprite and drops 4 px per frame.
Type63ScriptedSlideThenDrop:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae loc_0F4BC
    jmp near ptr ScrollRecordThenFinish
loc_0F4BC:
    cmp word ptr ss:[bp + REC_SPRITE], 0E7h
    je loc_0F4EE
    cmp word ptr ss:[bp + REC_SPRITE], 0E8h
    je loc_0F4EE
    cmp word ptr ss:[bp + REC_SPRITE], 0E9h
    je loc_0F4DF
    cmp word ptr ss:[bp + REC_SPRITE], 0EAh
    je loc_0F4EE
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
loc_0F4DF:
    add word ptr ss:[bp + REC_X], 2
    cmp word ptr ss:[bp + REC_X], 60h
    je loc_0F4EC
    jmp near ptr ScrollRecordThenFinish
loc_0F4EC:
    jmp short loc_0F4F8
loc_0F4EE:
    cmp word ptr ds:[FrameCount4], 3
    je loc_0F4F8
    jmp near ptr ScrollRecordThenFinish
loc_0F4F8:
    inc word ptr ss:[bp + REC_SPRITE]
    jmp near ptr ScrollRecordThenFinish
; Drops 4 px per frame (2 on level 4).
Type64DropSlow:
    mov ax, 2
    cmp word ptr ds:[LevelIndex], 4
    je loc_0F50A
    add al, 2
loc_0F50A:
    add ss:[bp + REC_Y], ax
    jmp near ptr ScrollRecordThenFinish
; Starts PathType66 with 20 hit points as type 12h.
Type66FollowPathType66:
    mov word ptr ss:[bp + REC_FIELD_36], offset PathType66
    mov word ptr ss:[bp + REC_HIT_POINTS], 14h
    jmp near ptr StartPathFollow
; Starts PathType67 (type 66h mirrored) with 20 hit points as type 12h.
Type67FollowPathType67:
    mov word ptr ss:[bp + REC_FIELD_36], offset PathType67
    mov word ptr ss:[bp + REC_HIT_POINTS], 14h
    jmp near ptr StartPathFollow
; Descends while sliding 2 px per frame toward X 50h.
Type6BDescendToX50:
    mov word ptr ds:[DescentTargetX], 50h
    mov ax, ds:[FrameCount16]
    shr ax, 1
    shr ax, 1
    add ax, 11Fh
    mov ss:[bp + REC_SPRITE], ax
    jmp short loc_0F55A
; Descends while sliding toward X 70h.
Type6DDescendToX70:
    mov word ptr ds:[DescentTargetX], 70h
    mov ax, ds:[FrameCount16]
    shr ax, 1
    shr ax, 1
    add ax, 124h
    mov ss:[bp + REC_SPRITE], ax
    jmp short loc_0F55A
; Descends toward X 60h and fires; the only one of 6Bh..6Dh that shoots.
Type6CDescendToX60Firing:
    mov word ptr ds:[DescentTargetX], 60h
loc_0F55A:
    cmp word ptr ss:[bp + REC_Y], 40h
    jae loc_0F563
    jmp near ptr ScrollRecordThenFinish
loc_0F563:
    mov ax, ds:[DescentTargetX]
    cmp ss:[bp + REC_X], ax
    je loc_0F577
    ja loc_0F573
    add word ptr ss:[bp + REC_X], 2
    jmp short loc_0F577
loc_0F573:
    sub word ptr ss:[bp + REC_X], 2
loc_0F577:
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ss:[bp + REC_TYPE], 6Ch
    je loc_0F583
    jmp near ptr ScrollRecordThenFinish
loc_0F583:
    cmp word ptr ss:[bp + REC_X], 60h
    je loc_0F596
    cmp word ptr ds:[FrameCount16], 0Fh
    jne loc_0F593
    call SpawnThrottledChild
loc_0F593:
    jmp near ptr ScrollRecordThenFinish
loc_0F596:
    cmp word ptr ds:[FrameCount4], 3
    jne loc_0F5A0
    call SpawnThrottledChild
loc_0F5A0:
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 50h and becomes type 70h unless the player is just below.
Type6FWaitThenType70:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae loc_0F5AC
    jmp near ptr ScrollRecordThenFinish
loc_0F5AC:
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    sub ax, ss:[bp + REC_Y]
    cmp ax, 20h
    jae loc_0F5BA
    jmp near ptr ScrollRecordThenFinish
loc_0F5BA:
    mov word ptr ss:[bp + REC_TYPE], 70h
; Moves 2 px per frame in REC_DIRECTION, firing every 8 frames.
Type70CruiseFiring:
    mov ax, ds:[FrameCount16]
    shr ax, 1
    shr ax, 1
    add ax, 133h
    mov ss:[bp + REC_SPRITE], ax
    call MoveInDirection2
    cmp word ptr ds:[FrameCount8], 7
    jne loc_0F5D9
    call SpawnThrottledChild
loc_0F5D9:
    jmp near ptr ScrollRecordThenFinish
; Descends 1 px per frame, firing an aimed shot every other frame.
Type72DescendFiringAimed:
    mov ax, ds:[FrameCount8]
    shr ax, 1
    add ax, 1Ch
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[CountGate2324], 1
    jne loc_0F5F4
    call SpawnAimedShot
loc_0F5F4:
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 80h, then charges right as type 85h code.
Type73WaitThenRunRight:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae loc_0F601
    jmp near ptr ScrollRecordThenFinish
loc_0F601:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 14Ch
    mov ss:[bp + REC_SPRITE], bx
    jmp short Type85ChargeUntilBlocked
; Scrolls to Y 90h, then charges left as type 85h code.
Type74WaitThenRunLeft:
    cmp word ptr ss:[bp + REC_Y], 90h
    jae loc_0F623
    jmp near ptr ScrollRecordThenFinish
loc_0F623:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
    add bx, 14Fh
    mov ss:[bp + REC_SPRITE], bx
; Four terrain steps per frame in REC_DIRECTION; destroyed when blocked or at the screen
; edge.
Type85ChargeUntilBlocked:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jne loc_0F646
    cmp word ptr ss:[bp + REC_X], 0C0h
    je loc_0F663
loc_0F646:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    jne loc_0F652
    cmp word ptr ss:[bp + REC_X], 0
    je loc_0F663
loc_0F652:
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    jne loc_0F663
    jmp near ptr ScrollRecordThenFinish
loc_0F663:
    call DestroyRecord
    jmp near ptr ScrollRecordThenFinish
; Waits until the player lines up with REC_DIRECTION, then becomes type 85h; the
; switching frame returns without the scroll tail.
Type84LurkUntilAligned:
    mov bx, ss:[bp + REC_DIRECTION]
    shr bx, 1
    shl bx, 1
    jmp word ptr cs:[bx + Type84DirCases]
    even
Type84DirCases label word
    dw offset Type84FacingUp, offset Type84FacingRight, offset Type84FacingDown, offset Type84FacingLeft
; Facing up: the player must be at or above, in the same 16-pixel column.
Type84FacingUp:
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    cmp ax, ss:[bp + REC_Y]
    jna Type84SameColumn
    jmp near ptr ScrollRecordThenFinish
Type84SameColumn:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    je loc_0F699
    add ax, 8
loc_0F699:
    mov bx, ss:[bp + REC_X]
    and ax, 0FFF0h
    and bx, -10h
    cmp ax, bx
    je Type84StartCharge
    jmp near ptr ScrollRecordThenFinish
Type84StartCharge:
    mov word ptr ss:[bp + REC_TYPE], 85h
    ret
; Facing down: the player must be at or below, in the same column.
Type84FacingDown:
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    cmp ax, ss:[bp + REC_Y]
    jae loc_0F6BA
    jmp near ptr ScrollRecordThenFinish
loc_0F6BA:
    jmp short Type84SameColumn
; Facing right: the player must be at or to the right, on the same 4-pixel row.
Type84FacingRight:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    cmp ax, ss:[bp + REC_X]
    jae Type84SameRow
    jmp near ptr ScrollRecordThenFinish
Type84SameRow:
    mov bx, ss:[bp + REC_Y]
    add bx, 14h
    and bx, -4
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    and ax, 0FFFCh
    cmp ax, bx
    je Type84StartChargeH
    jmp near ptr ScrollRecordThenFinish
Type84StartChargeH:
    mov word ptr ss:[bp + REC_TYPE], 85h
    ret
; Facing left: the player must be at or to the left, on the same row.
Type84FacingLeft:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    cmp ax, ss:[bp + REC_X]
    jna loc_0F6EE
    jmp near ptr ScrollRecordThenFinish
loc_0F6EE:
    jmp short Type84SameRow
; Fires two shots when the player is on its row.
Type92FireWhenPlayerLevel:
    mov bx, ss:[bp + REC_Y]
    add bx, 14h
    and bx, -4
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    and ax, 0FFFCh
    cmp ax, bx
    je loc_0F706
    jmp near ptr ScrollRecordThenFinish
loc_0F706:
    sub word ptr ss:[bp + REC_Y], 4
    call Type92SpawnShot
    add word ptr ss:[bp + REC_Y], 8
    call Type92SpawnShot
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
; SpawnThrottledChild from BP with sprite 44h; returns BX.
Type92SpawnShot:
    call SpawnThrottledChild
    cmp bx, -1
    je loc_0F728
    mov word ptr ds:[bx + REC_SPRITE], 44h
loc_0F728:
    ret
; Descends 2 px per frame, firing a three-way downward spread every 4 frames.
Type75DescendSpreadShot:
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ds:[FrameCount4], 3
    je loc_0F737
    jmp near ptr ScrollRecordThenFinish
loc_0F737:
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
    call SpawnChildAt12
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_RIGHT
    call SpawnChildAt12
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnChildAt12
    pop word ptr ss:[bp + REC_DIRECTION]
    jmp near ptr ScrollRecordThenFinish
; Segmented boss part at (SegBossY, SegBossX) + BossPartOffsets[0].
Type76SegBossPart0:
    mov si, offset BossPartOffsets
    jmp short loc_0F779
; Segmented boss part at BossPartOffsets[1].
Type77SegBossPart1:
    mov si, offset BossPartOffsets + 4
    jmp short loc_0F779
; Segmented boss part at BossPartOffsets[2]; fires aimed shots early in each 128-frame
; cycle.
Type78SegBossGunPart:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    cmp word ptr ds:[FrameCount128], 0Fh
    ja loc_0F771
    call SpawnAimedShot
loc_0F771:
    mov si, offset BossPartOffsets + 8
    jmp short loc_0F779
; Segmented boss part at BossPartOffsets[3].
Type79SegBossPart3:
    mov si, offset BossPartOffsets + 0Ch
loc_0F779:
    lodsw
    add ax, ds:[SegBossY]
    mov ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 0
    jnl loc_0F78C
    mov word ptr ss:[bp + REC_Y], 0
loc_0F78C:
    lodsw
    add ax, ds:[SegBossX]
    mov ss:[bp + REC_X], ax
    jmp near ptr ScrollRecordThenFinish
; Steers SegBossAnchor (speed 2) along BossPath, advancing and steering again on
; arrival.
SteerSegBossAlongPath:
    mov bp, ds:[SegBossAnchor]
    push word ptr ds:[SegBossX]
    pop word ptr ss:[bp + REC_X]
    push word ptr ds:[SegBossY]
    pop word ptr ss:[bp + REC_Y]
loc_0F7A9:
    mov si, ds:[SegBossPathCursor]
    lodsw
    cmp ax, 0FFFFh
    jne loc_0F7BB
    mov word ptr ds:[SegBossPathCursor], offset BossPath
    jmp short loc_0F7A9
loc_0F7BB:
    add ax, 20h
    mov ds:[SteerTargetY], ax
    lodsw
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 2
    call SteerTowardTarget
    push word ptr ss:[bp + REC_X]
    pop word ptr ds:[SegBossX]
    push word ptr ss:[bp + REC_Y]
    pop word ptr ds:[SegBossY]
    cmp word ptr ds:[SteerArrived], 0
    jne loc_0F7E4
    ret
loc_0F7E4:
    mov ds:[SegBossPathCursor], si
    jmp short SteerSegBossAlongPath
MAIN ends

FAR0F7F segment byte public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
; Per frame: raises MarchFireNow when MarchFireDelay expires and reloads the delay
; (78h..28h, shorter with fewer live members).
StepMarchFireDelay:
    dec byte ptr ds:[MarchFireDelay]
    jne loc_1003E
    mov ax, word ptr ds:[EncounterLiveCount]
    mov cl, 078h
    cmp ax, 010h
    ja loc_10034
    mov cl, 064h
    cmp ax, 8
    ja loc_10034
    mov cl, 050h
    cmp ax, 4
    ja loc_10034
    mov cl, 03Ch
    cmp ax, 2
    ja loc_10034
    mov cl, 028h
loc_10034:
    mov byte ptr ds:[MarchFireDelay], cl
    inc byte ptr ds:[MarchFireNow]
    jmp short loc_10043
loc_1003E:
    mov byte ptr ds:[MarchFireNow], 0
loc_10043:
    retf

ResetMarchState:
    mov byte ptr ds:[MarchEdgeHit], 0
    mov byte ptr ds:[MarchStepNow], 0
    mov byte ptr ds:[MarchDelay], 1
    mov word ptr ds:[MarchStepX], 2
    mov word ptr ds:[MarchWord98AC], 0FFFFh
    mov byte ptr ds:[MarchDropNow], 0
    mov byte ptr ds:[MarchFireDelay], 1
    mov byte ptr ds:[MarchFireNow], 0
    mov byte ptr ds:[Type93KilledLatch], 0
    mov byte ptr ds:[Type93KilledPulse], 0
    ret
; BX = pool A record: a live size class 2 KIND_ENEMY with 200 hit points at (0, 0).
InitSegBossPartRecord:
    mov word ptr ds:[bx + REC_HIT_POINTS], 0C8h
    mov word ptr ds:[bx + REC_X], 0
    mov word ptr ds:[bx + REC_Y], 0
    mov word ptr ds:[bx + REC_SIZE_CLASS], 2
    mov word ptr ds:[bx + REC_SLOT_INDEX], 0FFFFh
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_KIND], KIND_ENEMY
    retf
; Level 4 type 21h: steers along Type21Path, spawning a type 64h child at each waypoint.
Type21LeaderPathBody:
    mov si, word ptr cs:[Type21PathCursor]
    lodsw
    cmp ax, 0FFFFh
    je loc_10103
    add ax, 20h
    mov ds:[SteerTargetY], ax
    lodsw
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 3
    mov ax, offset SteerTowardTarget
    call far ptr FarCallMainNearViaAX
    cmp word ptr ds:[SteerArrived], 0
    je loc_100F9
    mov word ptr ss:[bp + REC_HIT_POINTS], 2
    add word ptr cs:[Type21PathCursor], 4
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_100F9
    mov ax, ss:[bp + REC_Y]
    mov ds:[bx + REC_SAVED_Y], ax
    mov ax, ss:[bp + REC_X]
    mov ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 64h
    mov word ptr ds:[bx + REC_HIT_POINTS], 3
    mov word ptr ds:[bx + REC_SPRITE], 8Eh
loc_100F9:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 3Bh
    mov ss:[bp + REC_SPRITE], ax
    retf
loc_10103:
    call ResetType21Path
    jmp short Type21LeaderPathBody

ResetType21Path:
    mov word ptr cs:[Type21PathCursor], offset Type21Path
    ret
; Next Type21Path waypoint (CS-resident).
Type21PathCursor dw 0

MoveStars:
    cmp word ptr ds:[EnergyTanks], -1
    je loc_1014F
    inc word ptr ds:[StarLayerTick1]
    and word ptr ds:[StarLayerTick1], 1
    jne loc_1014F
    mov si, offset Stars
    mov cx, 014h
    call MoveStarLayer
    inc word ptr ds:[StarLayerTick2]
    and word ptr ds:[StarLayerTick2], 1
    jne loc_1014F
    mov cx, 0Ah
    call MoveStarLayer
    inc word ptr ds:[StarLayerTick3]
    and word ptr ds:[StarLayerTick3], 1
    jne loc_1014F
    mov cx, 0Ah
    call MoveStarLayer
loc_1014F:
    retf

MoveStarLayer:
    inc word ptr ds:[si]
    cmp word ptr ds:[si], 0C0h
    jne loc_1015C
    mov word ptr ds:[si], 0
loc_1015C:
    add si, 6
    loop MoveStarLayer
    ret
FAR0F7F ends
end ProgramEntry