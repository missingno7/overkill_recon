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
extrn LevelIntroFrames:word
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
extrn PlayerHitX:word
extrn PlayerHitY:word
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
public PatrolSpriteShootDown32
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
extrn CheckFirePhase:near
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
extrn RecordNearPlayerHitPoint:near
extrn RedrawStatusPanel:near
extrn RequestLifeStartMusic:near
extrn ResetEgaPages:near
extrn ResetPageAndClearScreen:near
extrn RestartAtCheckpoint:near
extrn RestoreRecordBackground:near
extrn ReturnCarrySet:near
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
extrn ShutdownWithError:near
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
extrn Type21LeaderPath:near
extrn Type24TurretLeftFire32:near
extrn Type25TurretRightFire32:near
extrn Type26TurretRemnant:near
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
extrn Type3FFlyAlongAimLine:near
extrn Type40JitterFallShooter:near
extrn Type41FollowPathType41:near
extrn Type42DescendSway:near
extrn Type43FollowPathType43:near
extrn Type44FollowPathType44:near
extrn Type45FollowPathType45:near
extrn Type46HoverShootThenDive:near
extrn Type47PatrolShootDown32B:near
extrn Type48DescendAimedFire:near
extrn Type49RadialBurstFaller:near
extrn Type4AFollowPathType4A:near
extrn Type4BDescendThenBounceUpRight:near
extrn Type4CSinkThenRise:near
extrn Type4DSinkRiseThenDash:near
extrn Type4EAnimDescendThenBounce:near
extrn Type4FFallFast4Flicker:near
extrn Type51FollowType51Path:near
extrn Type52ScrollOnly:near
extrn Type53AnimateFromSpriteBase:near
extrn Type60FlyAlongAimLine:near
extrn Type68JitterDescendFiring:near
extrn Type69JitterBelowY18:near
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
; Segment of the level map (LEVnMAP.BIC, loaded into SlotBuffer): 13 cells per row from
; offset 0; cell = block number + 1, also a ByteAttributeTable index. LoadLevelMap sets
; rows 0-1 to 1 and rows 283-287 from LevelEndMapRows.
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
; Sprite banks. Ids: 8x8 n -> 1X1; 16x16 n < FAh -> 2X2, else 2X2C n - FAh; 32x32
; n < 1Ch -> MANEXPL, else Gn n - 1Ch (two 16-row halves). Map cell c -> LEVnBLX block
; c - 1; from MAP_END_ROWS_POS, SHIP.BIC block c - 1.
ManExplSegment dw 0
Sprites1x1Segment dw 0
Sprites2x2Segment dw 0
Sprites2x2CSegment dw 0
LevelSpritesSegment dw 0
; Unreferenced CS word among the bank segment variables.
UnusedSegmentWord1E db 00h,00h
; THEND.BIC.
TheEndSegment dw 0
; Holds PANEL.ENC, the menu/HUD graphics drawn by DrawPanelGraphic.
PanelSegment dw 0
; The level plaque (plaqN.enc) and BLUEBITS.BIC.
PlaqueSegment dw 0
BlueBitsSegment dw 0
; Unreferenced CS word among the bank segment variables.
UnusedSegmentWord28 db 00h,00h
; 0 CGA, 1 EGA, 2 Tandy (PSP:82h, values above 2 become 1; hiscore.dat
; overrides it, unclamped, unless the launcher mask is F0h/FFh). Indexes the BIOS
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

; EXE entry. OVERKILL.EXE (the launcher) EXECs this file, OVERKILL, passing binary bytes
; at PSP:81h, not text: an override mask, the adapter (0 CGA, 1 EGA, 2 Tandy; above 2
; becomes 1) and the sound module letter ('t', 'r', 'a', FFh any). Settings saved in
; hiscore.dat win unless the mask is exactly F0h (video), 0Fh (sound) or FFh (both).
; The PSP block shrinks to end at ImageEnd; the stack is DATA's StackArea. Then init,
; set the BIOS video mode and run the game loops; never returns (exits through
; ShutdownGame).
ProgramEntry:
    mov word ptr cs:[EntryEsPsp], es
    mov word ptr cs:[EntryDsPsp], ds
    cld
    cli
    mov ds, word ptr cs:[MainDataSegment]
    mov ss, word ptr cs:[MainDataSegment]
    mov sp, offset StackTop
    sti
; From here DOS calls fail with CF set instead of prompting; INT 24h is never restored
; (DOS restores it from the PSP at exit).
    call far ptr InstallCriticalErrorVector
    mov es, word ptr cs:[EntryEsPsp]
    mov ax, es
    mov bx, seg ImageEnd
    sub bx, ax
    mov ah, DOS_RESIZE_MEMORY
    int 021h
    mov dx, offset MsgDeallocError
    jae @@memoryResized
    jmp near ptr ShowFatalErrorAndExit
@@memoryResized:
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
    jbe @@storeVideoAdapter
    mov al, 1
@@storeVideoAdapter:
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
    je @@applyOverrides
    cmp byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_SOUND
    je @@applyOverrides
    cmp byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_BOTH
    jne StartupAfterOverrides
@@applyOverrides:
    test byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_VIDEO
    je @@checkSoundOverride
    call ApplyLauncherVideoOverride
@@checkSoundOverride:
    test byte ptr cs:[LauncherOverrideMask], LAUNCHER_OVERRIDE_SOUND
    je @@overridesDone
    call ApplyLauncherSoundOverride
@@overridesDone:
    jmp short StartupAfterOverrides

ApplyLauncherVideoOverride:
    mov word ptr cs:[VideoAdapter], bx
    ret

ApplyLauncherSoundOverride:
    mov byte ptr ds:[SoundModuleSelect], al
    ret
; Init order: VGA DAC probe, checksums (may exit with code 1), INT 08h (72.8 Hz), INT 09h,
; archive list, retrace polarity, best-fit DOS allocation, floppies, EMS, sound module
; (requests MUSIC_TITLE), buffers, row tables, stars, rank colour, common graphics.
; hiscore.dat was already applied above. No video mode is set yet: the launcher's screen
; is captured and collapsed and WINDOW.BIC stretched in before the BIOS mode set clears it.
StartupAfterOverrides:
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
@@pauseLoop:
    call WaitVerticalRetrace
    loop @@pauseLoop
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, offset VideoBiosModeTable
    xlat
    int 010h
    mov word ptr ds:[TextInGraphics], 1
    call ResetPageAndClearScreen
    call RunAttractSequence
; Options menu and choose screen, then reset level, lives and score and start the
; first level. GameOver returns here. Kept across levels: score, lives, upgrades, pods,
; ship form; lost on death: upgrades, pods, ship form (ResetPoolAAndUpgrades).
StartNewGame:
    mov al, MUSIC_TITLE
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
; Entered on NextLevelRequest, or F4 when LevelSkipEnabled. After the sixth level
; (LevelIndex 0) the win screen is shown and play continues at LevelIndex 1.
CompleteLevel:
    cmp word ptr ds:[LevelIndex], 0
    jne AdvanceLevel
    call ShowWinScreenAndWaitPrimary
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
; record, place it and redraw. Energy and tanks are refilled and Fuel refuels from 0.
; RandomWordCursor is reset again after the first UpdateAllRecords.
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
    call ShowLevelIntro
; One game frame, paced by the timer (WaitTimerTick): update and draw, act on the
; requests raised this frame, then F4 (level skip), F10 (pause) and Esc (quit prompt).
; Draws the state of the previous update: EGA targets the hidden page, the workspace window
; goes to the screen, and backgrounds are restored before UpdatePlayerFrame scrolls the ring
; (REC_WORK_OFS stays valid); the EGA page is shown at the end of the frame.
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
; Drawn into the workspace and never restored: it stays until the map is redrawn
; (scrolling stops while Fuel is 0).
DrawFuelEmptyPanel:
    mov al, 4
    mov ah, 058h
    call DrawOffsetFromPlayfieldRow
    add di, word ptr ds:[ScrollWindowOffset]
    mov si, PANEL_FUEL_EMPTY
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedStride104
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Shows WinScreenPageList, waits 75 frames, then waits for the primary button (not for
; its release).
ShowWinScreenAndWaitPrimary:
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
    mov si, PANEL_QUIT_PROMPT
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
; GameOverRequest: zero LivesLeft so that LoseLife ends the game. With KeepLivesFlag the
; life is given back and GameOverRequest stays set, so the life restarts every frame.
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

; F10: show the pause graphics until the primary button (alone) or F10. Cheat codes are
; read only here.
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
    mov si, PANEL_PAUSE_UPPER
    shl si, 1
    add si, offset PanelImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    call BlitPackedToScreen
    mov ds, word ptr cs:[MainDataSegment]
    mov al, 4
    mov ah, 070h
    call DrawOffsetFromScreenRow
    mov si, PANEL_PAUSE_LOWER
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
@@fillEntry:
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 8
    stosw
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 9
    stosw
    loop @@fillEntry
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
    mov byte ptr ds:[InputBits], IN_YMINUS
    call PickupFuel
    call AddEnergyPoint
    cmp word ptr ds:[Fuel], 58h
    je @@checkTanks
    ret
@@checkTanks:
    cmp word ptr ds:[EnergyTanks], 3
    je @@checkEnergy
    ret
@@checkEnergy:
    cmp word ptr ds:[EnergyPoints], 18h
    je @@refillDone
    ret
@@refillDone:
    inc word ptr ds:[LevelEndPhase]
    ret
; Also spreads the side pods out.
LevelEndFlyToWaypointB:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    jne @@widenSpread
    cmp word ptr ds:[SidePodSpreadLeft], 8
    je @@narrowRightSpread
    inc word ptr ds:[SidePodSpreadLeft]
@@narrowRightSpread:
    cmp word ptr ds:[SidePodSpreadRight], -8
    je @@steerToB
    dec word ptr ds:[SidePodSpreadRight]
    jmp short @@steerToB
@@widenSpread:
    cmp word ptr ds:[SidePodSpreadLeft], 0Fh
    je @@widenRightSpread
    inc word ptr ds:[SidePodSpreadLeft]
@@widenRightSpread:
    cmp word ptr ds:[SidePodSpreadRight], -0Fh
    je @@steerToB
    dec word ptr ds:[SidePodSpreadRight]
@@steerToB:
    mov si, offset AutopilotWaypointB
    jmp short Steer
LevelEndFlyToWaypointA:
    mov si, offset AutopilotWaypointA
Steer:
    call SteerInputToWaypoint
    cmp byte ptr ds:[InputBits], 0
    je @@waypointReached
    ret
@@waypointReached:
    inc word ptr ds:[LevelEndPhase]
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_B
    je @@spawnLevelEndRecord
    jmp near ptr RunLevelEndSequence
@@spawnLevelEndRecord:
    mov word ptr ds:[SidePodSpreadRight], 0
    mov word ptr ds:[SidePodSpreadLeft], 0
    ; Unchecked: a full pool writes through FFFFh; REC_DRAW_PASS is left stale.
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
; SI = (Y, X) waypoint: sets InputBits toward it (unsigned compares). An equal axis adds no
; bit, so InputBits stays as the caller cleared it (RunLevelEndSequence).
SteerInputToWaypoint:
    lodsw
    cmp word ptr ds:[PrimaryRecord + REC_Y], ax
    je @@steerX
    mov byte ptr ds:[InputBits], IN_YPLUS
    jb @@steerX
    mov byte ptr ds:[InputBits], IN_YMINUS
@@steerX:
    lodsw
    cmp word ptr ds:[PrimaryRecord + REC_X], ax
    je @@done
    pushf
    or byte ptr ds:[InputBits], IN_XPLUS
    popf
    jb @@done
    and byte ptr ds:[InputBits], 0FEh
    or byte ptr ds:[InputBits], IN_XMINUS
@@done:
    ret
PlayerDyingTail:
    cmp word ptr ds:[FrameCount4], 3
    je @@nextDeathFrame
    ret
@@nextDeathFrame:
    inc word ptr ss:[bp + REC_SPRITE]
    cmp word ptr ss:[bp + REC_SPRITE], 0Fh
    je @@deathAnimDone
    ret
@@deathAnimDone:
    mov word ptr ss:[bp + REC_STATUS], 0
    call RestartAtCheckpoint
    mov word ptr ds:[LifeLostRequest], 1
    cmp word ptr ds:[Fuel], 0
    je @@gameOver
    ret
@@gameOver:
    mov word ptr ds:[GameOverRequest], 1
    ret

; Per frame, in order: input (or the level-end autopilot), UpdateBeam; when dying
; (EnergyTanks -1 or Fuel 0) only the dying animation, no scroll. Otherwise Y-, Y+, X+, X-
; steps (opposite keys both apply), upgrade, one scroll line, fire, edge spread, terrain
; damage, pod X nudge, position history, pod placement.
UpdatePlayerFrame:
    mov word ptr ds:[LifeLostRequest], 0
    mov word ptr ds:[NextLevelRequest], 0
    call PollInputBits
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    je @@checkLevelEndDone
    call RunLevelEndSequence
@@checkLevelEndDone:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_DONE
    jne @@updateShip
    mov word ptr ds:[NextLevelRequest], 1
    ret
@@updateShip:
    mov word ptr ds:[ScrollDeltaY], 0
    mov bp, offset PrimaryRecord
    call UpdateBeam
    cmp word ptr ds:[EnergyTanks], -1
    je PlayerDyingTail
    cmp word ptr ds:[Fuel], 0
    je PlayerDyingTail
    test byte ptr ds:[InputBits], IN_YMINUS
    je @@checkYPlus
    call DecRecordYByMode
@@checkYPlus:
    test byte ptr ds:[InputBits], IN_YPLUS
    je @@checkXPlus
    call IncRecordYTwice
@@checkXPlus:
    test byte ptr ds:[InputBits], IN_XPLUS
    je @@checkXMinus
    call IncRecordXTwice
@@checkXMinus:
    test byte ptr ds:[InputBits], IN_XMINUS
    je @@checkUpgradeButton
    call DecRecordXTwice
@@checkUpgradeButton:
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    jbe @@scrollAndFire
    test byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
    je @@scrollAndFire
    call ApplySelectedUpgrade
@@scrollAndFire:
    call ScrollForwardAndCheckLevelEnd
    call HandleFireButton
    cmp byte ptr ds:[BonusKeysEnabled], 0
    je @@checkEdgeSpread
    cmp byte ptr ds:[KeyDownTable + SCAN_3], KEY_STATE_DOWN
    jne @@checkEdgeSpread
    call PickupUpgradeSelector
@@checkEdgeSpread:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    ja @@checkTerrain
    call UpdatePlacementXOffsetsAtRecordEdges
@@checkTerrain:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne @@advanceHistory
    call DamagePlayerOnTerrainContact
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    jbe @@advanceHistory
    call AdjustRecordXFromCounts
@@advanceHistory:
    call AdvancePositionHistoryIfRequested

; Separate entry, also reached by fallthrough from the code above. BP = record.
; Record its position in the history, move the trailing pods along it, then place the
; side pods unless the map has scrolled to MapScrollPos <= B6h outside the demo.
StoreApplyHistoryAndConditionalPlacement:
    call StorePositionHistory
    call ApplyPositionHistoryToRecords
; When placement is skipped, the previous ClampXLowSeen/ClampXHighSeen survive.
    cmp word ptr ds:[DemoActive], 0
    jne @@placePods
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    jbe @@done
@@placePods:
    call PlaceSidePods
@@done:
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
    jne @@checkHighClamp
    cmp byte ptr ds:[ClampXLowSeen], 1
    jne @@checkHighClamp
    call IncRecordXTwice
    mov word ptr ds:[XAdjustPathTaken], 1
@@checkHighClamp:
    test byte ptr ds:[InputBits], IN_XPLUS
    jne @@countPods
    cmp byte ptr ds:[ClampXHighSeen], 1
    jne @@countPods
    call DecRecordXTwice
    mov word ptr ds:[XAdjustPathTaken], 1
@@countPods:
    xor ax, ax
    cmp word ptr ds:[SidePodLeftInner], -1
    je @@checkRightInner
    call CountLeftPod
@@checkRightInner:
    cmp word ptr ds:[SidePodRightInner], -1
    je @@checkLeftOuter
    call CountRightPod
@@checkLeftOuter:
    cmp word ptr ds:[SidePodLeftOuter], -1
    je @@checkRightOuter
    call CountLeftPod
@@checkRightOuter:
    cmp word ptr ds:[SidePodRightOuter], -1
    je @@dispatchCounts
    call CountRightPod
@@dispatchCounts:
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
    jne @@nudgeRight
    ret
@@nudgeRight:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr IncRecordXBelowMax
CountXInc:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr IncRecordXBelowMax
CountXDecIfGate:
    cmp word ptr ds:[CountGate2324], 1
    jne @@nudgeLeft
    ret
@@nudgeLeft:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr DecRecordXUnlessZero
CountXDec:
    mov word ptr ds:[XAdjustPathTaken], 1
    jmp near ptr DecRecordXUnlessZero

; BP = PrimaryRecord: on terrain contact, DamagePlayerEnergy 2, 3 or 4 times by
; DifficultySetting. Preserves BP.
DamagePlayerOnTerrainContact:
    call ProbeShipTerrainCollision
    jb @@terrainHit
    ret
@@terrainHit:
    push bp
    cmp word ptr ds:[DifficultySetting], 0
    je @@damageTwice
    cmp word ptr ds:[DifficultySetting], 1
    je @@damageThreeTimes
    call DamagePlayerEnergy
@@damageThreeTimes:
    call DamagePlayerEnergy
@@damageTwice:
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
    jne @@advanceWrite
    cmp word ptr ds:[XAdjustPathTaken], 0
    jne @@advanceWrite
    ret
@@advanceWrite:
    add word ptr ds:[HistoryWriteCursor], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryWriteCursor], offset HistoryEnd
    jne @@advanceLag15
    mov word ptr ds:[HistoryWriteCursor], offset HistoryPairs
@@advanceLag15:
    add word ptr ds:[HistoryReadCursor15], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryReadCursor15], offset HistoryEnd
    jne @@advanceLag31
    mov word ptr ds:[HistoryReadCursor15], offset HistoryPairs
@@advanceLag31:
    add word ptr ds:[HistoryReadCursor31], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryReadCursor31], offset HistoryEnd
    jne @@advanceLag47
    mov word ptr ds:[HistoryReadCursor31], offset HistoryPairs
@@advanceLag47:
    add word ptr ds:[HistoryCursor47], HISTORY_PAIR_BYTES
    cmp word ptr ds:[HistoryCursor47], offset HistoryEnd
    jne @@done
    mov word ptr ds:[HistoryCursor47], offset HistoryPairs
@@done:
    ret

; Item 1: advances SelectedUpgradeSlot (0..3) and refreshes the upgrade display.
PickupUpgradeSelector:
    cmp byte ptr ds:[BonusKeysEnabled], 0
    je @@nextSlot
@@waitKeyRelease:
    cmp byte ptr ds:[KeyDownTable + SCAN_3], KEY_STATE_DOWN
    je @@waitKeyRelease
@@nextSlot:
    inc word ptr ds:[SelectedUpgradeSlot]
    and word ptr ds:[SelectedUpgradeSlot], 3
    jmp near ptr RefreshUpgradeDisplay
; Item 2: an energy tank, or refilled energy when all three are held.
PickupEnergy:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@addTank
    mov byte ptr ds:[SfxRequest], 1Ch
@@addTank:
    cmp word ptr ds:[EnergyTanks], 3
    je @@fillEnergy
    inc word ptr ds:[EnergyTanks]
@@redrawGauge:
    push bp
    call RedrawEnergyGauge
    pop bp
    ret
@@fillEnergy:
    cmp word ptr ds:[EnergyPoints], 18h
    je @@redrawGauge
    inc word ptr ds:[EnergyPoints]
    jmp short @@fillEnergy
AddFrontPod:
    cmp word ptr ds:[FrontPodRecord], -1
    je @@allocPod
    ret
@@allocPod:
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
    jne @@checkRefuelling
    ret
@@checkRefuelling:
    cmp word ptr ds:[RefuelActive], 1
    jne @@startRefuel
    ret
@@startRefuel:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae @@done
    mov word ptr ds:[RefuelActive], 1
    cmp word ptr ds:[DemoActive], 1
    je @@done
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 0Dh
@@done:
    ret
; Level-end refill step: EnergyPoints + 1; a full bar becomes a new tank unless three
; are held.
AddEnergyPoint:
    cmp word ptr ds:[EnergyPoints], 18h
    jne @@addPoint
    cmp word ptr ds:[EnergyTanks], 3
    jne @@newTank
    ret
@@newTank:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@addTank
    mov byte ptr ds:[SfxRequest], 1Ch
@@addTank:
    inc word ptr ds:[EnergyTanks]
    mov word ptr ds:[EnergyPoints], 0
    jmp near ptr RedrawEnergyGauge
@@addPoint:
    inc word ptr ds:[EnergyPoints]
    jmp near ptr RedrawEnergyGauge

; One hit (ignored in LEVEL_END_TO_WAYPOINT_A, while dying or out of tanks): flash,
; EnergyPoints -= 1..3 by difficulty; an empty bar refills and falls into
; LosePlayerEnergyTank.
DamagePlayerEnergy:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    jne @@checkShipAlive
    ret
@@checkShipAlive:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb @@checkTanksLeft
    ret
@@checkTanksLeft:
    cmp word ptr ds:[EnergyTanks], -1
    jne @@takeHit
    ret
@@takeHit:
    mov word ptr ds:[PrimaryRecord + REC_FLASH_TIMER], 8
    cmp byte ptr ds:[SfxEnabled], 0
    je @@applyDamage
    mov byte ptr ds:[SfxRequest], 0Fh
@@applyDamage:
    cmp word ptr ds:[DifficultySetting], 0
    je @@damageOne
    cmp word ptr ds:[DifficultySetting], 1
    je @@damageTwo
    dec word ptr ds:[EnergyPoints]
    je @@barEmpty
@@damageTwo:
    dec word ptr ds:[EnergyPoints]
    je @@barEmpty
@@damageOne:
    dec word ptr ds:[EnergyPoints]
    jne RedrawEnergyGauge
@@barEmpty:
    mov word ptr ds:[EnergyPoints], 018h
; Also called on body contact. Without tanks left the ship dies (form 3), unless
; AllCheatsFlag refills.
LosePlayerEnergyTank:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    jne @@checkShipAlive
    ret
@@checkShipAlive:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb @@loseTank
    ret
@@loseTank:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@checkEasyToggle
    mov byte ptr ds:[SfxRequest], 3
@@checkEasyToggle:
    cmp word ptr ds:[DifficultySetting], 0
    jne @@decTanks
    inc byte ptr ds:[EasyHitToggle]
    and byte ptr ds:[EasyHitToggle], 1
    je @@decTanks
    ret
@@decTanks:
    dec word ptr ds:[EnergyTanks]
    cmp word ptr ds:[EnergyTanks], -1
    jne RedrawEnergyGauge
    mov word ptr ds:[EnergyPoints], 0
    cmp byte ptr ds:[AllCheatsFlag], 1
    je CheatRefill
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    cmp byte ptr ds:[SfxEnabled], 0
    je RedrawEnergyGauge
    mov byte ptr ds:[SfxRequest], 019h
; DrawEnergyGauge, on both pages on EGA.
RedrawEnergyGauge:
    call DrawEnergyGauge
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@done
    call FlipEgaDrawPage
    call DrawEnergyGauge
    call FlipEgaDrawPage
@@done:
    ret
CheatRefill:
    mov word ptr ds:[EnergyTanks], 3
    mov word ptr ds:[EnergyPoints], 018h
    ret

; Fuel - 1; at 0 the ship dies unless WhatOilShortageFlag refills it. Redraws the gauge.
DrainFuelUnit:
    cmp word ptr ds:[Fuel], 0
    jne @@drain
    ret
@@drain:
    dec word ptr ds:[Fuel]
    je @@fuelEmpty
    jmp near ptr DrawFuelGauge
@@fuelEmpty:
    cmp byte ptr ds:[WhatOilShortageFlag], 1
    je @@cheatRefuel
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    cmp byte ptr ds:[SfxEnabled], 0
    je @@redrawGauge
    mov byte ptr ds:[SfxRequest], 019h
@@redrawGauge:
    jmp near ptr DrawFuelGauge
@@cheatRefuel:
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
    jne @@tryFarSlot
    call AllocRecordEvicting
    mov ds:[TrailingPodNear], bx
    jmp short InitPodRecord
@@tryFarSlot:
    cmp word ptr ds:[TrailingPodFar], -1
    jne @@done
    call AllocRecordEvicting
    mov ds:[TrailingPodFar], bx
    jmp short InitPodRecord
@@done:
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
    je @@done
    mov bx, offset SidePodLeftOuter
    call FillSidePodSlotIfEmpty
    je @@done
    mov bx, offset SidePodRightOuter
    call FillSidePodSlotIfEmpty
@@done:
    ret
FillSidePodSlotIfEmpty:
    cmp word ptr ds:[bx], -1
    je @@fillSlot
    ret
@@fillSlot:
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
    jne @@placePod
    ret
; The pair index is the anchor's REC_SPRITE (ship form).
; Tables hold three pairs, but no bound check: the primary sprite can be set to 3.
@@placePod:
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
    jge @@checkHighClamp
    mov word ptr ds:[bx + REC_X], 0
    mov byte ptr ds:[ClampXLowSeen], 1
@@checkHighClamp:
    cmp word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
    jle @@done
    mov word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
    mov byte ptr ds:[ClampXHighSeen], 1
@@done:
    ret

; Move the trailing pods (slots TrailingPodNear/Far, FFFFh = empty) to the lagged
; history positions at HistoryReadCursor15 and HistoryReadCursor31.
ApplyPositionHistoryToRecords:
    cmp word ptr ds:[TrailingPodNear], -1
    je @@placeFarPod
    mov bx, word ptr ds:[TrailingPodNear]
    mov si, word ptr ds:[HistoryReadCursor15]
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
@@placeFarPod:
    cmp word ptr ds:[TrailingPodFar], -1
    je @@done
    mov bx, word ptr ds:[TrailingPodFar]
    mov si, word ptr ds:[HistoryReadCursor31]
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
@@done:
    ret
ClearFireLatch:
    mov word ptr ds:[FireLatch], 0
    ret

; BP = PrimaryRecord. Fires when the primary button is newly pressed, held with rapid
; fire, or every 16 frames while held. Early in the level (MapScrollPos <= B6h, not the
; demo) only the main shot fires; otherwise the ShotsLive* snapshot is taken and
; missile, side shots, pod shots and the main weapon fire in turn. Demo: step 8 fires
; only FireFrontPodBurst; steps 10h..12h only the missile.
HandleFireButton:
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je ClearFireLatch
    cmp word ptr ds:[FireLatch], 0
    je @@fire
    cmp byte ptr ds:[RapidFireEnabled], 1
    je @@fire
    cmp word ptr ds:[FrameCount16], 0Fh
    je @@fire
    ret
@@fire:
    mov word ptr ds:[FireLatch], 1
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja @@fullSalvo
    cmp word ptr ds:[DemoActive], 0
    jne @@fullSalvo
    cmp word ptr ds:[WeaponMode], WEAPON_FORK
    jne @@singleShot
    jmp near ptr FireForkShot
@@singleShot:
    jmp near ptr FireSingleShot
@@fullSalvo:
    mov ax, word ptr ds:[ShotsLiveMain]
    mov word ptr ds:[ShotsAtFireMain], ax
    mov ax, word ptr ds:[ShotsLiveType9]
    mov word ptr ds:[ShotsAtFireBeam], ax
    mov ax, word ptr ds:[ShotsLiveSide]
    mov word ptr ds:[ShotsAtFireSide], ax
    mov ax, word ptr ds:[ShotsLiveFrontPod]
    mov word ptr ds:[ShotsAtFireFrontPod], ax
    cmp word ptr ds:[DemoActive], 1
    jne @@fireAll
    cmp word ptr ds:[DemoStep], 8
    jne @@checkDemoMissile
    jmp short FireFrontPodBurst
@@checkDemoMissile:
    cmp word ptr ds:[DemoStep], 0Fh
    jbe @@fireAll
    jmp near ptr FireMissile
@@fireAll:
    call FireMissile
    call FirePlayerSideShots
    call FireTrailingPodShots
    call FireSidePodShots
    call FireMainWeapon
    ret

; Starts the beam in WeaponMode 5, fires the front pod burst, then the WeaponMode
; pattern.
FireMainWeapon:
    cmp word ptr ds:[WeaponMode], WEAPON_BEAM
    jne @@checkFrontPod
    call StartBeam
@@checkFrontPod:
    cmp word ptr ds:[FrontPodRecord], -1
    je @@firePattern
    call FireFrontPodBurst
@@firePattern:
    mov bx, word ptr ds:[WeaponMode]
    shl bx, 1
    jmp word ptr cs:[bx + WeaponPatternCases]
    even
WeaponPatternCases label word
    dw offset FireSingleShot, offset FireHeavyShot, offset FireForkShot, offset FireTwinRising3
    dw offset FireTwinRising16, offset CountXReturn

; Three type 0Ch shots from FrontPodRecord (up, up-left, up-right), one burst at a
; time.
FireFrontPodBurst:
    cmp word ptr ds:[ShotsAtFireFrontPod], 0
    je @@spawnBurst
    ret
@@spawnBurst:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@spawnShots
    mov byte ptr ds:[SfxRequest], 018h
@@spawnShots:
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

; AllocPlayerShot as type 0Ch with REC_SHOT_TIMER 7; returns SI = FrontPodRecord, AX =
; its Y.
AllocFrontPodShot:
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_TYPE], 0Ch
    mov word ptr ds:[bx + REC_SHOT_TIMER], 7
    mov si, word ptr ds:[FrontPodRecord]
    mov ax, word ptr ds:[si + REC_Y]
    ret
; WeaponMode 1: the single shot with sprite 33h, which does an extra hit point of
; damage.
FireHeavyShot:
    call SpawnShotAtMuzzle
    mov word ptr ds:[bx + REC_SPRITE], 33h
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 14h
@@done:
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
    je @@spawnShots
    mov byte ptr ds:[SfxRequest], 015h
@@spawnShots:
    call AllocPlayerShot
    mov word ptr ds:[bx + REC_SPRITE], 018h
    call PlaceShotAtMuzzle
    call AllocPlayerShot
    call PlaceShotAtMuzzle
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    mov word ptr ds:[bx + REC_SPRITE], 01Fh
    test byte ptr ds:[InputBits], IN_XMINUS
    jne @@done
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 019h
    test byte ptr ds:[InputBits], IN_XPLUS
    jne @@done
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_SPRITE], 018h
@@done:
    ret

; Grows the beam (BeamList) by a link every other frame while it has room, raises the
; head 4 px and lines the other links up beside it.
UpdateBeam:
    cmp word ptr ds:[ShotsLiveType9], 0
    jne @@checkGrowFrame
    ret
@@checkGrowFrame:
    cmp word ptr ds:[CountGate2324], 1
    jne @@alignLinks
    cmp word ptr ds:[BeamListEnd], offset BeamListTerminator
    jne @@checkHead
    ret
@@checkHead:
    mov bx, word ptr ds:[BeamList]
    cmp bx, -1
    jne @@growBeam
    ret
@@growBeam:
    cmp word ptr ds:[bx + REC_X], 0
    je @@addLink
    call SpawnBeamLink
    mov bx, word ptr ds:[BeamList]
    sub word ptr ds:[bx + REC_X], 8
    mov bx, word ptr ds:[BeamListEnd]
    sub bx, 4
    mov bx, word ptr ds:[bx]
    cmp word ptr ds:[bx + REC_X], 0C8h
    je @@alignLinks
@@addLink:
    call SpawnBeamLink
@@alignLinks:
    mov si, offset BeamList
    lodsw
    cmp ax, 0FFFFh
    jne @@raiseHead
    ret
@@raiseHead:
    mov bx, ax
    sub word ptr ds:[bx + REC_Y], 4
    mov cx, word ptr ds:[bx + REC_X]
    add cx, 8
    mov di, word ptr ds:[bx + REC_Y]
@@nextLink:
    lodsw
    cmp ax, 0FFFFh
    je @@markTail
    mov bx, ax
    mov word ptr ds:[bx + REC_X], cx
    add cx, 8
    mov word ptr ds:[bx + REC_Y], di
    mov word ptr ds:[bx + REC_SPRITE], 06Bh
    jmp short @@nextLink
@@markTail:
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
    je @@start
    ret
@@start:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@resetList
    mov byte ptr ds:[SfxRequest], 011h
@@resetList:
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
    je @@start
    ret
@@start:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@spawnShots
    mov byte ptr ds:[SfxRequest], 17h
@@spawnShots:
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
    je @@start
    ret
@@start:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@spawnShots
    mov byte ptr ds:[SfxRequest], 16h
@@spawnShots:
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
    jne @@checkEnabled
    ret
@@checkEnabled:
    cmp word ptr ds:[SideShotsEnabled], 0
    jne @@checkLive
    ret
@@checkLive:
    cmp word ptr ds:[ShotsAtFireSide], 0
    je @@spawnPair
    ret
@@spawnPair:
    call SpawnSideShotFromSI
    mov word ptr ds:[bx + REC_TYPE], 6

SpawnSideShotFromSI:
    inc word ptr ds:[ShotsLiveSide]
    cmp byte ptr ds:[SfxEnabled], 0
    je @@spawnShot
    mov byte ptr ds:[SfxRequest], 012h
@@spawnShot:
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
    jne @@dispatchPattern
    ret
@@dispatchPattern:
    mov bx, word ptr ds:[WeaponMode]
    shl bx, 1
    jmp word ptr cs:[bx + PodWeaponPatternCases]
    even
PodWeaponPatternCases label word
    dw offset SpawnShotAtPod, offset PodHeavyShot, offset PodForkShot, offset PodTwinRising3
    dw offset PodTwinRising16, offset CountXReturn
PodTwinRising16:
    cmp word ptr ds:[ShotsAtFireMain], 0
    je @@spawnShots
    ret
@@spawnShots:
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
    je @@spawnShots
    ret
@@spawnShots:
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
    jne @@setSprite
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_LEFT
    cmp word ptr ds:[si + REC_X], 58h
    jna @@setSprite
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
@@setSprite:
    cmp word ptr ds:[bx + REC_DIRECTION], DIR_UP_RIGHT
    mov word ptr ds:[bx + REC_SPRITE], 19h
    je @@done
    mov word ptr ds:[bx + REC_SPRITE], 1Fh
@@done:
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
; REC_SHOT_TIMER FFFFh (lives until out of bounds).
AllocPlayerShot:
    call AllocPoolBRecordEvicting
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 1
    mov word ptr ds:[bx + REC_DIRECTION], DIR_UP
    mov word ptr ds:[bx + REC_SPRITE], 032h
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], KIND_TYPED
    mov word ptr ds:[bx + REC_TYPE], 2
    mov word ptr ds:[bx + REC_SHOT_TIMER], 0FFFFh
    ret

; Fires a homing missile (type 0Ah) at FindMissileTarget's record when missiles remain
; and none is live. Without a target the allocated record is left inactive.
; REC_DIRECTION and REC_SPRITE are not set.
FireMissile:
    cmp word ptr ds:[MissileAmmo], 0
    jne @@checkLive
    ret
@@checkLive:
    cmp word ptr ds:[MissilesLive], 1
    jne @@spawnMissile
    ret
@@spawnMissile:
    call AllocPoolBRecordEvicting
    call CopyRecordPositionPlus10
    push bp
    mov bp, bx
    call FindMissileTarget
    mov ax, bx
    mov bx, bp
    pop bp
    cmp ax, 0FFFFh
    jne @@lockTarget
    ret
@@lockTarget:
    mov word ptr ds:[bx + REC_TARGET], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov word ptr ds:[bx + REC_SIDE_FLAG], 1
    mov word ptr ds:[bx + REC_SIZE_CLASS], 0
    mov word ptr ds:[bx + REC_KIND], KIND_TYPED
    mov word ptr ds:[bx + REC_TYPE], 0Ah
    mov word ptr ds:[bx + REC_MISSILE_LOCKED], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je @@countMissile
    mov byte ptr ds:[SfxRequest], 011h
@@countMissile:
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
    jne @@checkLive
    ret
@@checkLive:
    cmp word ptr ds:[ShotsAtFireSide], 0
    je @@spawnShots
    ret
@@spawnShots:
    inc word ptr ds:[ShotsLiveSide]
    cmp byte ptr ds:[SfxEnabled], 0
    je @@spawnPair
    mov byte ptr ds:[SfxRequest], 012h
@@spawnPair:
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
    jne DecYUnguarded
    call DecRecordYUnlessAtMin
; Decrement REC_Y unless it equals RECORD_Y_MIN. Equality guard only: smaller values
; still decrement.
DecRecordYUnlessAtMin:
    cmp word ptr ss:[bp + REC_Y], RECORD_Y_MIN
    jne @@decY
    ret
@@decY:
    dec word ptr ss:[bp + REC_Y]
    ret
DecYUnguarded:
    dec word ptr ss:[bp + REC_Y]
    ret

; Two guarded REC_Y increments: call IncRecordYUnlessAtMax, then fall through into it.
IncRecordYTwice:
    call IncRecordYUnlessAtMax
; Increment REC_Y unless it equals RECORD_Y_MAX. Equality guard only: larger values
; still increment.
IncRecordYUnlessAtMax:
    cmp word ptr ss:[bp + REC_Y], RECORD_Y_MAX
    jne @@incY
    ret
@@incY:
    inc word ptr ss:[bp + REC_Y]
    ret

; REC_X = max(REC_X - 2, 0): call DecRecordXUnlessZero, then fall through into it.
DecRecordXTwice:
    call DecRecordXUnlessZero
; Decrement REC_X unless it is zero.
DecRecordXUnlessZero:
    cmp word ptr ss:[bp + REC_X], 0
    jne @@decX
    ret
@@decX:
    dec word ptr ss:[bp + REC_X]
    ret

; REC_X += 2, saturating at RECORD_X_MAX: call IncRecordXBelowMax, then fall through.
IncRecordXTwice:
    call IncRecordXBelowMax
; Increment REC_X while it is below RECORD_X_MAX (unsigned).
IncRecordXBelowMax:
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
    jb @@incX
    ret
@@incX:
    inc word ptr ss:[bp + REC_X]
    ret

; BP = record; no-op while MapScrollPos <= B6h. Pushing against the right edge (REC_X =
; RECORD_X_MAX with IN_XPLUS) widens SidePodSpreadLeft by one up to 8; otherwise it
; relaxes back towards 0. UpdatePlacementXGroupA does the mirror for the left edge first.
UpdatePlacementXOffsetsAtRecordEdges:
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja @@updateSpread
    ret
@@updateSpread:
    call UpdatePlacementXGroupA
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
    jne @@relaxLeftSpread
    test byte ptr ds:[InputBits], IN_XPLUS
    je @@relaxLeftSpread
    cmp word ptr ds:[SidePodSpreadLeft], 8
    je @@atMax
    inc word ptr ds:[SidePodSpreadLeft]
@@atMax:
    ret
@@relaxLeftSpread:
    cmp word ptr ds:[SidePodSpreadLeft], 0
    je @@atZero
    dec word ptr ds:[SidePodSpreadLeft]
@@atZero:
    ret

; BP = record. Pushing against the left edge (REC_X = 0 with IN_XMINUS) moves
; SidePodSpreadRight down by one to -8; otherwise it relaxes back towards 0.
; Guards are equality checks, not clamps.
UpdatePlacementXGroupA:
    cmp word ptr ss:[bp + REC_X], 0
    jne @@relaxRightSpread
    test byte ptr ds:[InputBits], IN_XMINUS
    je @@relaxRightSpread
    cmp word ptr ds:[SidePodSpreadRight], -8
    jne @@decSpread
    ret
@@decSpread:
    dec word ptr ds:[SidePodSpreadRight]
    ret
@@relaxRightSpread:
    cmp word ptr ds:[SidePodSpreadRight], 0
    jne @@incSpread
    ret
@@incSpread:
    inc word ptr ds:[SidePodSpreadRight]
    ret

; Scrolls one line unless an encounter or the level end holds the map; at MapScrollPos
; MAP_END_POS starts the level end (smart bomb, four type 53h records).
ScrollForwardAndCheckLevelEnd:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    je @@checkEncounter
    jmp near ptr @@done
@@checkEncounter:
    cmp word ptr ds:[EncounterLiveCount], 0
    jne @@done
    cmp word ptr ds:[EncounterEndDelay], 0
    jne @@done
    call ScrollForwardOneLine
    cmp word ptr ds:[ScrollSubRow], 0
    jne @@done
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
    jne @@restoreRegs
    call SetDacColor6
@@restoreRegs:
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
    jne @@done
    mov word ptr ds:[LevelEndPhase], LEVEL_END_TO_WAYPOINT_A
    call SmartBombAll
    mov si, offset Type53SpawnTable
    mov cx, 4
@@spawnNext:
    push cx
    push si
    call FindFreeRecordPoolA
    pop si
    cmp bx, -1
    je @@nextSpawn
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
    mov word ptr ds:[bx + REC_SPRITE_BASE], ax
@@nextSpawn:
    pop cx
    loop @@spawnNext
@@done:
    ret

; ScrollDeltaY + 1; moves ScrollWindowOffset up one pixel line, entering a new map row
; every 16 lines. Preserves BP.
ScrollForwardOneLine:
    push bp
    add word ptr ds:[ScrollDeltaY], 1
    mov word ptr ds:[ScrollingBackward], 0
    cmp word ptr ds:[ScrollSubRow], 0
    jne @@stepSubRow
    call EnterNextMapRowForward
@@stepSubRow:
    dec word ptr ds:[ScrollSubRow]
    and word ptr ds:[ScrollSubRow], 0Fh
    jne @@checkWindowWrap
    cmp word ptr ds:[LastTileStepBackward], 0
    je @@checkWindowWrap
    add word ptr ds:[MapScrollPos], MAP_ROW_BYTES
    dec word ptr ds:[LevelScriptClock]
@@checkWindowWrap:
    mov ax, word ptr cs:[ScrollBandBytes]
    cmp word ptr ds:[ScrollWindowOffset], ax
    jne @@moveWindow
    call WrapScrollWindowForward
@@moveWindow:
    mov ax, word ptr cs:[PlayfieldRowBytes]
    sub word ptr ds:[ScrollWindowOffset], ax
ScrollLineDone:
    pop bp
    ret

WrapScrollWindowForward:
    mov ax, word ptr cs:[ScrollWrapOffset]
    mov word ptr ds:[ScrollWindowOffset], ax
    ret

; Draws the map row at MapScrollPos, then MapScrollPos + 0Dh, LevelScriptClock - 1.
EnterNextMapRowForward:
    call DrawMapRowIntoScrollBand
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja @@advanceMapRow
    cmp byte ptr ds:[SfxEnabled], 0
    je @@advanceMapRow
    mov byte ptr ds:[SfxRequest], 7
@@advanceMapRow:
    add word ptr ds:[MapScrollPos], MAP_ROW_BYTES
    dec word ptr ds:[LevelScriptClock]
    mov al, MUSIC_LEVEL_END
    cmp word ptr ds:[LevelScriptClock], 4
    jne @@clearBackwardStep
    call RequestModuleMusic
@@clearBackwardStep:
    mov word ptr ds:[LastTileStepBackward], 0
    ret

; Mirror of ScrollForwardOneLine (no-op at MapScrollPos 0). Preserves BP.
ScrollBackwardOneLine:
    push bp
    mov word ptr ds:[ScrollingBackward], 1
    cmp word ptr ds:[MapScrollPos], 0
    je ScrollLineDone
    add word ptr ds:[ScrollDeltaY], -1
    cmp word ptr ds:[ScrollSubRow], 0
    jne @@stepSubRow
    call EnterPreviousMapRowBackward
@@stepSubRow:
    inc word ptr ds:[ScrollSubRow]
    and word ptr ds:[ScrollSubRow], 0Fh
    jne @@checkWindowWrap
    cmp word ptr ds:[LastTileStepBackward], 1
    je @@checkWindowWrap
    sub word ptr ds:[MapScrollPos], MAP_ROW_BYTES
    inc word ptr ds:[LevelScriptClock]
@@checkWindowWrap:
    mov ax, word ptr cs:[ScrollWrapOffset]
    cmp word ptr ds:[ScrollWindowOffset], ax
    jne @@moveWindow
    call WrapScrollWindowBackward
@@moveWindow:
    mov ax, word ptr cs:[PlayfieldRowBytes]
    add word ptr ds:[ScrollWindowOffset], ax
    pop bp
    ret

; Draws the map row at MapScrollPos - 0A9h (entering 13 rows down), then
; MapScrollPos - 0Dh, LevelScriptClock + 1.
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

; DI = workspace band. Forward (up to MAP_LAST_SPAWN_POS) also spawns the row's objects
; and runs the level script.
DrawIncomingMapRow:
    mov bx, word ptr ds:[MapScrollPos]
    cmp word ptr ds:[ScrollingBackward], 1
    jne @@forwardRow
    sub bx, 13 * MAP_ROW_BYTES
    jmp near ptr DrawMapRowBlocks
@@forwardRow:
    mov word ptr ds:[MapRowCursor], bx
    cmp word ptr ds:[MapScrollPos], MAP_LAST_SPAWN_POS
    ja @@drawBlocks
    call SpawnFromMapRow
    call RunLevelScriptEvents
@@drawBlocks:
    mov bx, word ptr ds:[MapScrollPos]
    jmp near ptr DrawMapRowBlocks

; Per frame: saves backgrounds (pool A with the primary, then B), draws stars, pool B
; (8x8), pool A pass 0 (no primary), then pass 1 (primary first). Pods stay hidden until
; MapScrollPos > MAP_INTRO_END_POS (not in the demo). The level-end extra record is
; drawn once more at the end.
DrawRecordsToWorkspace:
    mov cx, POOL_A_POINTER_COUNT
@@saveNextA:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextSaveA
    call SaveRecordBackground
@@nextSaveA:
    pop cx
    loop @@saveNextA
    mov cx, POOL_B_COUNT
@@saveNextB:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextSaveB
    call SaveRecordBackground
@@nextSaveB:
    pop cx
    loop @@saveNextB
    call DrawStars
    mov cx, POOL_B_COUNT
@@drawNextB:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextDrawB
    call DrawSprite8Record
@@nextDrawB:
    pop cx
    loop @@drawNextB
    mov cx, POOL_A_COUNT
@@drawNextPass0:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextPass0
    cmp word ptr ds:[DemoActive], 1
    je @@checkPass0
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja @@checkPass0
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je @@nextPass0
@@checkPass0:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 0
    jne @@nextPass0
    call DrawRecordSprite
@@nextPass0:
    pop cx
    loop @@drawNextPass0
    mov cx, POOL_A_POINTER_COUNT
@@drawNextPass1:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextPass1
    cmp word ptr ds:[DemoActive], 1
    je @@checkPass1
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja @@checkPass1
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je @@nextPass1
@@checkPass1:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 1
    jne @@nextPass1
    call DrawRecordSprite
@@nextPass1:
    pop cx
    loop @@drawNextPass1
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne @@drawExtraRecord
    ret
@@drawExtraRecord:
    mov bp, word ptr ds:[AutoMoveExtraRecord]
    cmp bp, -1
    je @@done
    call DrawRecordSprite
@@done:
    ret

; Undoes DrawRecordsToWorkspace from each record's REC_SAVE_BUFFER, then EraseStars.
RestoreRecordBackgrounds:
    mov cx, POOL_B_COUNT
@@restoreNextB:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextRestoreB
    call RestoreRecordBackground
@@nextRestoreB:
    pop cx
    loop @@restoreNextB
    mov cx, POOL_A_POINTER_COUNT
@@restoreNextA:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextRestoreA
    call RestoreRecordBackground
@@nextRestoreA:
    pop cx
    loop @@restoreNextA
    call EraseStars
    ret

; Per frame: march, type 93h and segmented-boss state, then UpdateRecordByKind for pool
; A from PoolA[34] down to PoolA[0] (the primary is not updated here), then pool B from
; [33] down to [0], then MoveStars. A record spawned mid-pass is updated this frame only
; if its slot is still ahead; everything is drawn next frame.
UpdateAllRecords:
    cmp word ptr ds:[FramesSinceInvaderSpawn], -1
    je @@latchMarch
    inc word ptr ds:[FramesSinceInvaderSpawn]
@@latchMarch:
    mov ax, word ptr ds:[InvaderNextMarchLeft]
    mov word ptr ds:[InvaderMarchLeft], ax
    mov ax, word ptr ds:[InvaderNextDropStep]
    mov word ptr ds:[InvaderDropStep], ax
    mov word ptr ds:[InvaderNextDropStep], 0
    cmp word ptr ds:[LevelIndex], 5
    jne @@type93Pulse
    cmp byte ptr ds:[MarchEdgeHit], 0
    je @@noDrop
    neg word ptr ds:[MarchStepX]
    mov byte ptr ds:[MarchEdgeHit], 0
    mov byte ptr ds:[MarchDropNow], 1
    jmp short @@stepMarchDelay
@@noDrop:
    mov byte ptr ds:[MarchDropNow], 0
@@stepMarchDelay:
    xor cl, cl
    cmp byte ptr ds:[MarchDelay], 0
    je @@reloadMarchDelay
    dec byte ptr ds:[MarchDelay]
    jne @@noMarchStep
    mov ax, word ptr ds:[EncounterLiveCount]
    mov cl, 0Ah
    cmp ax, 010h
    ja @@reloadMarchDelay
    mov cl, 6
    cmp ax, 8
    ja @@reloadMarchDelay
    mov cl, 4
    cmp ax, 4
    ja @@reloadMarchDelay
    mov cl, 1
@@reloadMarchDelay:
    mov byte ptr ds:[MarchDelay], cl
    inc byte ptr ds:[MarchStepNow]
    jmp short @@stepFireDelay
@@noMarchStep:
    mov byte ptr ds:[MarchStepNow], 0
@@stepFireDelay:
    call far ptr StepMarchFireDelay
@@type93Pulse:
    mov byte ptr ds:[Type93KilledPulse], 0
    cmp byte ptr ds:[Type93KilledLatch], 0
    je @@checkSegBoss
    mov byte ptr ds:[Type93KilledLatch], 0
    mov byte ptr ds:[Type93KilledPulse], 1
@@checkSegBoss:
    cmp word ptr ds:[SegBossActive], 1
    jne @@updatePoolA
    call SteerSegBossAlongPath
@@updatePoolA:
    mov cx, POOL_A_COUNT
@@nextRecordA:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    inc word ptr ds:[RecordTickCounter]
    cmp word ptr ds:[RecordTickCounter], 05DCh
    jb @@updateRecordA
    mov word ptr ds:[RecordTickCounter], 0
@@updateRecordA:
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@loopA
    call UpdateRecordByKind
@@loopA:
    pop cx
    loop @@nextRecordA
    mov word ptr ds:[SwayDropY], 0
    mov cx, POOL_B_COUNT
@@nextRecordB:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@loopB
    call UpdateRecordByKind
@@loopB:
    pop cx
    loop @@nextRecordB
    call far ptr MoveStars
    ret

; BP = record: run its REC_KIND handler (KindHandlers).
UpdateRecordByKind:
    mov bx, word ptr ss:[bp + REC_KIND]
    shl bx, 1
    jmp word ptr cs:[bx + KindHandlers]
    even
; KIND_PLAYER is a bare ret (CountXReturn); the primary is never visited anyway.
KindHandlers label word
    dw offset ScrollRecordThenFinish, offset UpdatePod, offset RunTypeHandler, offset CountXReturn
    dw offset RunTypeHandler, offset UpdatePickup, offset UpdateExhaust
; Shared exit: CF clear (no hit).
ReturnNoHit:
    clc
    ret
; BP = record: CF when within 10h of the player's hit point; NC above the playfield or
; while the ship is dying.
SmallRecordHitsPlayer:
    mov ax, word ptr ss:[bp + REC_Y]
    or ax, ax
    js ReturnNoHit
    mov si, word ptr ds:[PrimaryRecord + REC_SPRITE]
    cmp si, 3
    jae ReturnNoHit
    shl si, 1
    shl si, 1
    add si, offset PlayerHitOffsets
    lodsw
    add ax, word ptr ds:[PrimaryRecord + REC_Y]
    mov word ptr ds:[PlayerHitY], ax
    lodsw
    add ax, word ptr ds:[PrimaryRecord + REC_X]
    mov word ptr ds:[PlayerHitX], ax
    jmp near ptr RecordNearPlayerHitPoint
; BP = size class 2 record: CF when recX-14h <= player X <= recX+18h (signed) and
; recY-14h <= player Y <= recY+18h (unsigned; recY-4..recY+8 while SegBossActive);
; NC when REC_Y < 0. No ship-form check.
LargeRecordHitsPlayer:
    mov ax, word ptr ss:[bp + REC_Y]
    or ax, ax
    js ReturnNoHit
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 018h
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jl ReturnNoHit
    sub ax, 02Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jg ReturnNoHit
    cmp word ptr ds:[SegBossActive], 1
    jne @@normalBox
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 8
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jb ReturnNoHit
    sub ax, 0Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    ja ReturnNoHit
    stc
    ret
@@normalBox:
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 018h
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jb ReturnNoHit
    sub ax, 02Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    ja ReturnNoHit
    stc
    ret
; BP = pickup: falls 1 px per frame plus scroll; on contact CollectPickup frees it, and
; the scroll tail still runs on the freed record.
UpdatePickup:
    inc word ptr ss:[bp + REC_Y]
    call SmallRecordHitsPlayer
    jb @@collect
    jmp near ptr ScrollRecordThenFinish
@@collect:
    call CollectPickup
    jmp near ptr ScrollRecordThenFinish
CollectPickup:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb @@collect
    ret
@@collect:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@scoreAndDispatch
    mov byte ptr ds:[SfxRequest], 7
@@scoreAndDispatch:
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
    jb @@checkLevelEnd
    jmp near ptr FreeRecordSilently
@@checkLevelEnd:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_REFILL
    jb @@animate
    jmp near ptr FreeRecordSilently
@@animate:
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
    jae @@losePod
    call AnimateSidePodSprite
    call PodTerrainHit
    jb @@losePod
    call PodCollideRecords
    jb @@destroyEnemy
    ret
@@destroyEnemy:
    call DestroyRecordAtBX
@@losePod:
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
    jae @@losePod
    mov ax, word ptr ds:[SlowCount4]
    add ax, 014h
    mov word ptr ss:[bp + REC_SPRITE], ax
    call PodCollideRecords
    jb @@destroyEnemy
    ret
@@destroyEnemy:
    call DestroyRecordAtBX
@@losePod:
    mov bx, word ptr ds:[CurrentTrailingPodSlot]
    mov word ptr ds:[bx], 0FFFFh
    jmp short ExplodePod
UpdateFrontPod:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae @@losePod
    mov dx, offset FrontPodOffsets
    call PlaceAtPlayerOffset
    call PodTerrainHit
    jae @@checkCollision
@@losePod:
    mov word ptr ds:[FrontPodRecord], 0FFFFh
    jmp short ExplodePod
@@checkCollision:
    call PodCollideRecords
    jb @@podHitEnemy
    ret
@@podHitEnemy:
    mov word ptr ds:[FrontPodRecord], 0FFFFh
    call DestroyRecordAtBX
; Shared tail: turns the lost pod BP into a dying enemy (type 1), then refreshes the
; upgrade display. REC_PREV_TYPE is not set: a stale 24h/25h in the slot makes the pod
; leave a type 26h remnant.
ExplodePod:
    cmp bp, -1
    jne @@explode
    ret
@@explode:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@becomeDyingEnemy
    mov byte ptr ds:[SfxRequest], 019h
@@becomeDyingEnemy:
    mov word ptr ss:[bp + REC_TYPE], 1
    mov word ptr ss:[bp + REC_KIND], KIND_ENEMY
    mov word ptr ss:[bp + REC_ANIM_COUNTER], 0
    mov word ptr ss:[bp + REC_SPRITE], 0
RefreshUpgradeDisplay:
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
    je @@checkDemo
    jmp near ptr ReturnNoHit
@@checkDemo:
    cmp word ptr ds:[DemoActive], 1
    jne ProbeGridForRecordResponse
    jmp near ptr ReturnNoHit
; Part of PodTerrainHit. Test the map cell at grid offset + 13 and, when X is not
; cell-aligned, its right neighbour; a nonzero attribute is a hit. The FFFFh
; negative-Y result of ComputeRecordGridOffset is not checked (+13 wraps to 000Ch).
ProbeGridForRecordResponse:
    call ComputeRecordGridOffset
    add bx, MAP_ROW_BYTES
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
; BP = pod: the first live size-1 enemy or pickup in pool A within 10h (type 1 and BP
; itself skipped): a pickup is collected (NC);
; an enemy is destroyed and the pod loses a hit point (CF when it was the last). Always
; NC in the demo.
PodCollideRecords:
    cmp word ptr ds:[DemoActive], 1
    jne @@scan
    jmp near ptr ReturnNoHit
@@scan:
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
    mov ax, word ptr ss:[bp + REC_X]
    mov di, word ptr ss:[bp + REC_Y]
@@checkRecord:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@nextRecord
    cmp word ptr ds:[bx + REC_TYPE], 1
    je @@nextRecord
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    jne @@nextRecord
    mov si, word ptr ds:[bx + REC_Y]
    add si, 010h
    cmp di, si
    jg @@nextRecord
    sub si, 020h
    cmp di, si
    jl @@nextRecord
    mov si, word ptr ds:[bx + REC_X]
    add si, 010h
    cmp ax, si
    jg @@nextRecord
    sub si, 020h
    cmp ax, si
    jl @@nextRecord
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    cmp si, word ptr ds:[bx + REC_SAVE_BUFFER]
    jne @@hit
@@nextRecord:
    add bx, RECORD_SIZE
    loop @@checkRecord
    clc
    ret
@@hit:
    cmp word ptr ds:[bx + REC_KIND], KIND_PICKUP
    je @@collectPickup
; Always taken: the scan only accepts size class 1.
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je @@checkEnemy
    jmp near ptr ReturnCarrySet
@@checkEnemy:
    cmp word ptr ds:[bx + REC_KIND], KIND_ENEMY
    jne @@nextRecord
    call DestroyRecordAtBX
; Record scan shares the same response/counter path as the grid attribute probe.
    call SetResponseAndStepRecordCounter
    jb @@podDestroyed
    ret
@@podDestroyed:
    stc
    ret
@@collectPickup:
    push bp
    mov bp, bx
    call CollectPickup
    mov bx, bp
    pop bp
    clc
    ret
; BP = pod: dispatch by identity (sprite 0Fh = front pod, else the slot holding BP);
; frozen until MapScrollPos > MAP_INTRO_END_POS (not in the demo). Pods never reach
; FinishRecordUpdate.
UpdatePod:
    cmp word ptr ds:[DemoActive], 1
    je @@dispatchPod
    cmp word ptr ds:[MapScrollPos], MAP_INTRO_END_POS
    ja @@dispatchPod
    ret
@@dispatchPod:
    cmp word ptr ss:[bp + REC_SPRITE], 0Fh
    jne @@checkLeftInner
    jmp near ptr UpdateFrontPod
@@checkLeftInner:
    cmp bp, word ptr ds:[SidePodLeftInner]
    jne @@checkRightInner
    jmp near ptr UpdateSidePodLeftInner
@@checkRightInner:
    cmp bp, word ptr ds:[SidePodRightInner]
    jne @@checkLeftOuter
    jmp near ptr UpdateSidePodRightInner
@@checkLeftOuter:
    cmp bp, word ptr ds:[SidePodLeftOuter]
    jne @@checkRightOuter
    jmp near ptr UpdateSidePodLeftOuter
@@checkRightOuter:
    cmp bp, word ptr ds:[SidePodRightOuter]
    jne @@checkTrailingNear
    jmp near ptr UpdateSidePodRightOuter
@@checkTrailingNear:
    mov bx, offset TrailingPodNear
    cmp bp, word ptr ds:[TrailingPodNear]
    jne @@checkTrailingFar
    jmp near ptr UpdateTrailingPod
@@checkTrailingFar:
    mov bx, offset TrailingPodFar
    cmp bp, word ptr ds:[TrailingPodFar]
    jne @@done
    jmp near ptr UpdateTrailingPod
@@done:
    ret
; Shot tail: scrolls, then the bounds test below.
ShotScrollAndBounds:
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
; Removes the shot outside Y 8..E0h or past X C8h, or a player shot hitting a wall.
ShotBoundsCheck:
    cmp word ptr ss:[bp + REC_Y], 8
    jae @@checkBottom
    jmp near ptr RemoveRecord
@@checkBottom:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe @@checkRight
    jmp near ptr RemoveRecord
@@checkRight:
    cmp word ptr ss:[bp + REC_X], 0C8h
    jbe @@checkWallShot
    jmp near ptr RemoveRecord
@@checkWallShot:
    cmp word ptr ss:[bp + REC_KIND], KIND_TYPED
    jne @@done
    cmp word ptr ss:[bp + REC_TYPE], 2
    je @@probeWall
    cmp word ptr ss:[bp + REC_TYPE], 4
    je @@probeWall
    cmp word ptr ss:[bp + REC_TYPE], 0Ch
    je @@probeWall
    cmp word ptr ss:[bp + REC_TYPE], 5
    je @@probeWall
    cmp word ptr ss:[bp + REC_TYPE], 6
    je @@probeWall
    cmp word ptr ss:[bp + REC_TYPE], 9
    je @@probeWall
    cmp word ptr ss:[bp + REC_TYPE], 8
    je @@probeWall
    jmp short @@done
@@probeWall:
    cmp word ptr ds:[DemoActive], 1
    je @@done
; Remove the record when the cell at grid offset + 13 has attribute 1 exactly (Y >= 8
; is already enforced above, so the FFFFh result cannot occur here).
    call ComputeRecordGridOffset
    add bx, MAP_ROW_BYTES
    call ReadIndexedByteAttribute
    je @@done
    dec al
    jne @@done
    jmp near ptr RemoveRecord
@@done:
    ret
; Removes the shot through the bounds test (Y = FFFFh).
ExpireShot:
    mov word ptr ss:[bp + REC_Y], 0FFFFh
    jmp short ShotBoundsCheck
; No reference found: moves the shot 2 px down, then the player-hit test.
UnusedDescendShot:
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
; A link of the player's beam (BeamList): UpdateBeam positions it; the handler only
; applies the shot bounds tail.
Type09BeamLink:
    jmp near ptr ShotBoundsCheck
; 2 px per frame in REC_DIRECTION until REC_SHOT_TIMER runs out, then the player-hit test.
Type0FTimedShot2:
    mov ax, ds:[FrameCount16]
    shr ax, 1
    add ax, 0
    mov ss:[bp + REC_SPRITE], ax
    dec word ptr ss:[bp + REC_SHOT_TIMER]
    je ExpireShot
; Return into ShotHitPlayerCheck after the move.
    mov ax, offset ShotHitPlayerCheck
    push ax
    jmp near ptr MoveInDirection2
; 3 px per frame in REC_DIRECTION while REC_SHOT_TIMER counts down, then straight up at
; 5 px per frame.
Type0CTimedTurnUpShot:
    cmp word ptr ss:[bp + REC_SHOT_TIMER], 0
    je @@rise
    dec word ptr ss:[bp + REC_SHOT_TIMER]
    jne @@move
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
@@rise:
    sub word ptr ss:[bp + REC_Y], 2
@@move:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 28h
    mov ss:[bp + REC_SPRITE], ax
    call MoveInDirection3
    jmp near ptr ShotBoundsCheck
; Mirror of type 05h drifting up-right (probes the map at X mod 16 = 8); removed at
; X = C8h.
Type06SideShotUpRight:
    cmp word ptr ss:[bp + REC_X], 0C8h
    je ExpireShot
    sub word ptr ss:[bp + REC_Y], 4
    test word ptr ss:[bp + REC_X], 7
    jne @@driftUpRight
    test word ptr ss:[bp + REC_X], 8
    je @@driftUpRight
    cmp word ptr ds:[DemoActive], 1
    je @@driftUpRight
    call ComputeRecordGridOffset
    add bx, 0Eh
    call ReadIndexedByteAttribute
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    cmp al, 1
    je @@setSprite
@@driftUpRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_RIGHT
    add word ptr ss:[bp + REC_X], 4
@@setSprite:
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
    jne @@rise
    jmp near ptr ExpireShot
@@rise:
    sub word ptr ss:[bp + REC_Y], 4
    test word ptr ss:[bp + REC_X], 0Fh
    jne @@driftUpLeft
    cmp word ptr ds:[DemoActive], 1
    je @@driftUpLeft
    call ComputeRecordGridOffset
    add bx, 0Ch
    call ReadIndexedByteAttribute
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
    cmp al, 1
    je @@setSprite
@@driftUpLeft:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP_LEFT
    sub word ptr ss:[bp + REC_X], 4
@@setSprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 8
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr ShotScrollAndBounds
; 4 px per frame in REC_DIRECTION (8 px on level 0 unless heading down), then the
; player-hit test; the SpawnThrottledChild shot.
Type04StraightShot:
; Return into ShotHitPlayerCheck after the move.
    mov ax, offset ShotHitPlayerCheck
    push ax
    cmp word ptr ds:[LevelIndex], 0
    je @@checkDown
    jmp near ptr MoveInDirection4
@@checkDown:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jne @@moveFast
    jmp near ptr MoveInDirection4
@@moveFast:
    jmp short MoveInDirection8
; Types 02h/03h: 8 px per frame in REC_DIRECTION until REC_SHOT_TIMER runs out, then the
; player-hit test; type 3 hits deal 1/3/5 damage by difficulty.
Type02TimedStraightShot:
    dec word ptr ss:[bp + REC_SHOT_TIMER]
    jne @@move
    jmp near ptr ExpireShot
@@move:
; Return into ShotHitPlayerCheck after the move.
    mov ax, offset ShotHitPlayerCheck
    push ax
; MoveInDirectionN: BP moves N px along REC_DIRECTION (0 up, clockwise to 7); diagonals
; move N px on both axes. The direction is not range-checked; clobbers BX.
MoveInDirection8:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + Move8ByDirection]
Move8ByDirection label word
    dw offset @@moveUp, offset @@moveUpRight, offset @@moveRight, offset @@moveDownRight
    dw offset @@moveDown, offset @@moveDownLeft, offset @@moveLeft, offset @@moveUpLeft
@@moveDownRight:
    add word ptr ss:[bp + REC_X], 8
@@moveDown:
    add word ptr ss:[bp + REC_Y], 8
    ret
@@moveUpLeft:
    sub word ptr ss:[bp + REC_X], 8
@@moveUp:
    sub word ptr ss:[bp + REC_Y], 8
    ret
@@moveUpRight:
    sub word ptr ss:[bp + REC_Y], 8
@@moveRight:
    add word ptr ss:[bp + REC_X], 8
    ret
@@moveDownLeft:
    add word ptr ss:[bp + REC_Y], 8
@@moveLeft:
    sub word ptr ss:[bp + REC_X], 8
    ret
MoveInDirection3:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + MoveInDirection3Cases]
MoveInDirection3Cases label word
    dw offset @@moveUp, offset @@moveUpRight, offset @@moveRight, offset @@moveDownRight
    dw offset @@moveDown, offset @@moveDownLeft, offset @@moveLeft, offset @@moveUpLeft
@@moveDownRight:
    add word ptr ss:[bp + REC_X], 3
@@moveDown:
    add word ptr ss:[bp + REC_Y], 3
    ret
@@moveUpLeft:
    sub word ptr ss:[bp + REC_X], 3
@@moveUp:
    sub word ptr ss:[bp + REC_Y], 3
    ret
@@moveUpRight:
    sub word ptr ss:[bp + REC_Y], 3
@@moveRight:
    add word ptr ss:[bp + REC_X], 3
    ret
@@moveDownLeft:
    add word ptr ss:[bp + REC_Y], 3
@@moveLeft:
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
    dw offset @@moveUp, offset @@moveUpRight, offset @@moveRight, offset @@moveDownRight
    dw offset @@moveDown, offset @@moveDownLeft, offset @@moveLeft, offset @@moveUpLeft
@@moveDownRight:
    add word ptr ss:[bp + REC_X], 2
@@moveDown:
    add word ptr ss:[bp + REC_Y], 2
    ret
@@moveUpLeft:
    sub word ptr ss:[bp + REC_X], 2
@@moveUp:
    sub word ptr ss:[bp + REC_Y], 2
    ret
@@moveUpRight:
    sub word ptr ss:[bp + REC_Y], 2
@@moveRight:
    add word ptr ss:[bp + REC_X], 2
    ret
@@moveDownLeft:
    add word ptr ss:[bp + REC_Y], 2
@@moveLeft:
    sub word ptr ss:[bp + REC_X], 2
    ret
MoveInDirection1:
    mov bx, ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + Move1ByDirection]
Move1ByDirection label word
    dw offset @@moveUp, offset @@moveUpRight, offset @@moveRight, offset @@moveDownRight
    dw offset @@moveDown, offset @@moveDownLeft, offset @@moveLeft, offset @@moveUpLeft
@@moveDownRight:
    inc word ptr ss:[bp + REC_X]
@@moveDown:
    inc word ptr ss:[bp + REC_Y]
    ret
@@moveUpLeft:
    dec word ptr ss:[bp + REC_X]
@@moveUp:
    dec word ptr ss:[bp + REC_Y]
    ret
@@moveUpRight:
    dec word ptr ss:[bp + REC_Y]
@@moveRight:
    inc word ptr ss:[bp + REC_X]
    ret
@@moveDownLeft:
    inc word ptr ss:[bp + REC_Y]
@@moveLeft:
    dec word ptr ss:[bp + REC_X]
    ret
; Moves BP 1 px in REC_DIRECTION unless the map blocks it; NZ (and TerrainBlocked = 1)
; when blocked. BP is a 16x16 box at (X, Y + ScrollDeltaY). Diagonals try both axis steps
; separately, so one axis may move while NZ reports blocked; a walker overlap undoes it.
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
; A negative GridYSum (BX = FFFFh) counts as blocked.
; Body of TryTerrainStep; diagonals are two axis steps.
TerrainStepInDirection:
    call ComputeRecordGridOffset
    cmp bx, -1
    je TerrainStepBlocked
    mov dx, bx
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + TerrainStepCases]
    even
TerrainStepCases label word
    dw offset TerrainStepUp, offset TerrainStepUpRight, offset TerrainStepRight, offset TerrainStepDownRight
    dw offset TerrainStepDown, offset TerrainStepDownLeft, offset TerrainStepLeft, offset TerrainStepUpLeft
TerrainStepBlocked:
    mov word ptr ds:[TerrainBlocked], 1
    ret
TerrainStepDownRight:
    call TerrainStepRight
TerrainStepDown:
    mov bx, dx
    sub bx, MAP_ROW_BYTES
    call ReadIndexedByteAttribute
    jne TerrainStepBlocked
    test word ptr ss:[bp + REC_X], 0Fh
    je @@moveDown
    inc bx
    call ReadIndexedByteAttribute
    jne TerrainStepBlocked
@@moveDown:
    inc word ptr ss:[bp + REC_Y]
    inc word ptr ds:[TerrainProbeY]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae @@moved
    dec word ptr ss:[bp + REC_Y]
    dec word ptr ds:[TerrainProbeY]
    jmp short TerrainStepBlocked
@@moved:
    inc word ptr ds:[GridYSum]
    and word ptr ds:[GridYSum], 0Fh
    je @@crossedRowDown
    ret
@@crossedRowDown:
    sub dx, MAP_ROW_BYTES
    ret
TerrainStepUpLeft:
    call TerrainStepLeft
TerrainStepUp:
    mov bx, dx
    test word ptr ds:[GridYSum], 0Fh
    jne @@moveUp
    add bx, MAP_ROW_BYTES
    call ReadIndexedByteAttribute
    jne TerrainStepBlocked
    test word ptr ss:[bp + REC_X], 0Fh
    je @@moveUp
    inc bx
    call ReadIndexedByteAttribute
    jne TerrainStepBlocked
@@moveUp:
    dec word ptr ss:[bp + REC_Y]
    dec word ptr ds:[TerrainProbeY]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae @@moved
    inc word ptr ss:[bp + REC_Y]
    inc word ptr ds:[TerrainProbeY]
    jmp near ptr TerrainStepBlocked
@@moved:
    dec word ptr ds:[GridYSum]
    and word ptr ds:[GridYSum], 0Fh
    cmp word ptr ds:[GridYSum], 0Fh
    je @@crossedRowUp
    ret
@@crossedRowUp:
    add dx, MAP_ROW_BYTES
    ret
TerrainStepUpRight:
    call TerrainStepUp
TerrainStepRight:
    mov bx, dx
    inc bx
    call ReadIndexedByteAttribute
    je @@checkSecondRow
    jmp near ptr TerrainStepBlocked
@@checkSecondRow:
    test word ptr ds:[GridYSum], 0Fh
    je @@moveRight
    sub bx, MAP_ROW_BYTES
    call ReadIndexedByteAttribute
    je @@moveRight
    jmp near ptr TerrainStepBlocked
@@moveRight:
    inc word ptr ss:[bp + REC_X]
    inc word ptr ds:[TerrainProbeX]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae @@moved
    dec word ptr ss:[bp + REC_X]
    dec word ptr ds:[TerrainProbeX]
    jmp near ptr TerrainStepBlocked
@@moved:
    test word ptr ss:[bp + REC_X], 0Fh
    je @@crossedColumn
    ret
@@crossedColumn:
    inc dx
    ret
TerrainStepDownLeft:
    call TerrainStepDown
TerrainStepLeft:
    mov bx, dx
    test word ptr ss:[bp + REC_X], 0Fh
    jne @@moveLeft
    dec bx
    call ReadIndexedByteAttribute
    je @@checkSecondRow
    jmp near ptr TerrainStepBlocked
@@checkSecondRow:
    test word ptr ds:[GridYSum], 0Fh
    je @@moveLeft
    sub bx, MAP_ROW_BYTES
    call ReadIndexedByteAttribute
    je @@moveLeft
    jmp near ptr TerrainStepBlocked
@@moveLeft:
    dec word ptr ss:[bp + REC_X]
    dec word ptr ds:[TerrainProbeX]
    push bx
    call ProbeOverlapsWalker
    pop bx
    jae @@moved
    inc word ptr ss:[bp + REC_X]
    inc word ptr ds:[TerrainProbeX]
    jmp near ptr TerrainStepBlocked
@@moved:
    mov ax, word ptr ss:[bp + REC_X]
    and ax, 0Fh
    cmp ax, 0Fh
    je @@crossedColumn
    ret
@@crossedColumn:
    dec dx
    ret

; Finds the next live KIND_ENEMY record for the homing missile.
FindMissileTarget:
    mov cx, POOL_A_COUNT
    mov bx, word ptr ds:[TargetSearchCursor]
@@checkRecord:
    cmp bx, offset PoolAEnd
    jae @@wrapToPoolStart
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@nextRecord
    cmp word ptr ds:[bx + REC_TYPE], 1
    je @@nextRecord
    cmp word ptr ds:[bx + REC_TYPE], 026h
    je @@nextRecord
    cmp word ptr ds:[bx + REC_TYPE], 021h
    je @@nextRecord
    cmp word ptr ds:[bx + REC_TYPE], 022h
    je @@nextRecord
    cmp word ptr ds:[bx + REC_Y], 0E0h
    ja @@nextRecord
    cmp word ptr ds:[bx + REC_KIND], KIND_ENEMY
    je @@found
@@nextRecord:
    add bx, RECORD_SIZE
    loop @@checkRecord
    mov bx, 0FFFFh
    ret
@@wrapToPoolStart:
    mov word ptr ds:[TargetSearchCursor], offset PoolA
    mov bx, word ptr ds:[TargetSearchCursor]
    jmp short @@checkRecord
@@found:
    push bx
    add bx, RECORD_SIZE
    mov word ptr ds:[TargetSearchCursor], bx
    pop bx
    ret
; Steers (speed 2) to the player, then locks the next live enemy (sfx 11h) or expires;
; chases it by 3 px Bresenham steps; returns to the player when the target is lost.
Type0AHomingMissile:
    mov ax, ds:[FrameCount8]
    add ax, 6Dh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_MISSILE_LOCKED], 1
    je @@chaseTarget
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
    jne @@reachedPlayer
    jmp near ptr ShotBoundsCheck
@@reachedPlayer:
    cmp word ptr ds:[MissilesLive], 0
    je @@lockTarget
    dec word ptr ds:[MissilesLive]
@@lockTarget:
    call FindMissileTarget
    cmp bx, -1
    jne @@targetFound
    jmp near ptr ExpireShot
@@targetFound:
    mov ss:[bp + REC_TARGET], bx
    mov word ptr ss:[bp + REC_MISSILE_LOCKED], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je @@countMissile
    mov byte ptr ds:[SfxRequest], 11h
@@countMissile:
    inc word ptr ds:[MissilesLive]
    jmp near ptr ShotBoundsCheck
@@chaseTarget:
    mov bx, ss:[bp + REC_TARGET]
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@targetLost
    cmp word ptr ds:[bx + REC_Y], 0DCh
    ja @@targetLost
    cmp word ptr ds:[bx + REC_TYPE], 1
    je @@targetLost
    call SetDeltaToward
    call StepAlongDelta
    jmp near ptr ShotScrollAndBounds
@@targetLost:
    mov word ptr ss:[bp + REC_MISSILE_LOCKED], 0
    jmp near ptr ShotScrollAndBounds
; 3 px Bresenham steps along REC_DELTA, then the player-hit test.
Type0BAimedEnemyShot:
    call StepAlongDelta
; Damages the player and removes the shot on a hit; otherwise the scroll and bounds tail.
; Hit: PY-2 <= shot Y <= PY+12h (signed), PX <= shot X <= PX+14h (unsigned), before this
; frame's scroll. The shot is used up even when DamagePlayerEnergy ignores the hit.
ShotHitPlayerCheck:
    cmp word ptr ss:[bp + REC_SIDE_FLAG], 1
    je @@missed
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    mov bx, word ptr ds:[PrimaryRecord + REC_X]
    sub ax, 2
    cmp word ptr ss:[bp + REC_Y], ax
    jl @@missed
    add ax, 014h
    cmp word ptr ss:[bp + REC_Y], ax
    jg @@missed
    cmp word ptr ss:[bp + REC_X], bx
    jb @@missed
    add bx, 014h
    cmp word ptr ss:[bp + REC_X], bx
    ja @@missed
    mov cx, 1
    cmp word ptr ss:[bp + REC_TYPE], 3
    jne @@damageLoop
    cmp word ptr ds:[DifficultySetting], 0
    je @@damageLoop
    mov cx, 3
    cmp word ptr ds:[DifficultySetting], 1
    je @@damageLoop
    mov cx, 5
@@damageLoop:
    push cx
    push bp
    call DamagePlayerEnergy
    pop bp
    pop cx
    loop @@damageLoop
    jmp near ptr ExpireShot
@@missed:
    jmp near ptr ShotScrollAndBounds
; Types 89h/8Ah: terrain patrol firing down every 32 frames.
Type89PatrolShootDown32:
    mov ax, ds:[SlowCount4]
    add ax, 1Ch
PatrolSpriteShootDown32:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount32], 1Fh
    jne @@patrol
    call SpawnShotDown
@@patrol:
    jmp near ptr HorizontalTerrainPatrol
; Starts the waypoint path SteerPath10 as type 12h.
Type10StartPathFollowerA:
    mov word ptr ss:[bp + REC_PATH], offset SteerPath10
    jmp short StartPathFollow
; Starts the waypoint path SteerPath11 as type 12h.
Type11StartPathFollowerB:
    mov word ptr ss:[bp + REC_PATH], offset SteerPath11
; Turns BP into a type 12h waypoint follower of the path at REC_PATH.
StartPathFollow:
    mov word ptr ss:[bp + REC_TYPE], 12h
; Steers (speed 1, 2 on level 0 and in the demo) through the (Y, X) waypoints at
; REC_PATH; no end-of-path check and no scroll.
; Waypoint Y gets +20h. On arrival REC_PATH advances and the next waypoint is steered in
; the same call, so the record moves every frame; LEADER_END_Y is never reached.
Type12WaypointPathFollower:
    mov si, ss:[bp + REC_PATH]
    lodsw
    add ax, 20h
    mov ds:[SteerTargetY], ax
    lodsw
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 1
    cmp word ptr ds:[LevelIndex], 0
    je @@fastSpeed
    cmp word ptr ds:[DemoActive], 1
    jne @@steer
@@fastSpeed:
    mov word ptr ds:[SteerSpeed], 2
@@steer:
    call SteerTowardTarget
    cmp word ptr ds:[SteerArrived], 0
    je @@pickSprite
    mov ss:[bp + REC_PATH], si
    jmp short Type12WaypointPathFollower
@@pickSprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 3Bh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[DemoActive], 1
    jne @@levelSprite
    jmp near ptr FinishRecordUpdate
@@levelSprite:
    cmp word ptr ds:[LevelIndex], 5
    je @@level056Sprite
    cmp word ptr ds:[LevelIndex], 6
    je @@level056Sprite
    cmp word ptr ds:[LevelIndex], 0
    jne @@level1Sprite
@@level056Sprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 115h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[MapScrollPos], MAP_LAST_SPAWN_POS
    je @@lastSpawnSprite
    jmp near ptr FinishRecordUpdate
@@lastSpawnSprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 105h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 0
    jne @@checkLevel6
    jmp near ptr FinishRecordUpdate
@@checkLevel6:
    cmp word ptr ds:[LevelIndex], 6
    jne @@level1Sprite
    jmp near ptr FinishRecordUpdate
@@level1Sprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 2Ah
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 1
    jne @@level2Sprite
    jmp near ptr FinishRecordUpdate
@@level2Sprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0D2h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 2
    jne @@level3Sprite
    jmp near ptr FinishRecordUpdate
@@level3Sprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 3
    jne @@checkLevel7
    jmp near ptr FinishRecordUpdate
@@checkLevel7:
    cmp word ptr ds:[LevelIndex], 7
    jne @@level4Sprite
    jmp near ptr FinishRecordUpdate
@@level4Sprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 4
    jne @@otherLevelSprite
    jmp near ptr FinishRecordUpdate
@@otherLevelSprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr FinishRecordUpdate
; BP: REC_SPRITE = 72h when SwayDirX = +1, else 71h (also for 0). Clobbers AX.
SetSwaySprite:
    mov ax, ds:[SwayDirX]
    inc ax
    shr ax, 1
    add ax, 71h
    mov ss:[bp + REC_SPRITE], ax
    ret
; As type 22h falling 2 px per frame.
Type36FallThenBurst:
    call SetSwaySprite
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae @@reachedBurstY
    jmp near ptr ScrollRecordThenFinish
@@reachedBurstY:
    jmp short DescendBurstTail
; Types 22h/35h: falls 1 px (2 on level 0) with a SwayDirX-facing sprite to Y A0h,
; then DestroyRecord and an eight-way burst of type 3 shots.
Type22DescendThenBurst:
    call SetSwaySprite
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[LevelIndex], 0
    jne @@checkBurstY
    inc word ptr ss:[bp + REC_Y]
@@checkBurstY:
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae DescendBurstTail
    jmp near ptr ScrollRecordThenFinish
DescendBurstTail:
    call DestroyRecord
    call SpawnEightWayBurst
    jmp near ptr ScrollRecordThenFinish
; Spawns up to eight type 3 shots from BP in directions 0..7.
SpawnEightWayBurst:
    mov dx, 0Ch
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    je @@setOrigin
    mov dx, 4
@@setOrigin:
    mov ax, ss:[bp + REC_X]
    add ax, dx
    mov ds:[BurstOriginX], ax
    mov ax, ss:[bp + REC_Y]
    add ax, dx
    mov ds:[BurstOriginY], ax
    mov cx, 8
@@spawnShot:
    push cx
    call FindFreeRecordPoolB
    pop cx
    cmp bx, -1
    je @@done
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
    mov word ptr ds:[bx + REC_SHOT_TIMER], 0FFFFh
    pop cx
    loop @@spawnShot
@@done:
    ret
; AX = number of live KIND_ENEMY records in pool A.
CountLiveEnemies:
    push bp
    mov cx, POOL_A_COUNT
    xor ax, ax
@@checkRecord:
    push cx
    push ax
    mov bx, cx
    shl bx, 1
    mov bp, ds:[bx + PoolAPointers - 2]
    pop ax
    cmp word ptr ss:[bp + REC_STATUS], 0
    je @@nextRecord
    cmp word ptr ss:[bp + REC_KIND], KIND_ENEMY
    jne @@nextRecord
    inc ax
@@nextRecord:
    pop cx
    loop @@checkRecord
    pop bp
    ret
EncounterInvaderLevel:
    cmp word ptr ds:[EncounterTicks], 32h
    jae @@checkInvaderStart
    jmp near ptr EncounterSpawnFaller
@@checkInvaderStart:
    cmp word ptr ds:[EncounterTicks], 5Ah
    jae @@startInvaders
    jmp near ptr FinishRecordUpdate
@@startInvaders:
    jmp near ptr EncounterSpawnInvader
EncounterSegBossLevel:
    call CountLiveEnemies
    cmp ax, 1
    je @@spawnSegBoss
    jmp near ptr FinishRecordUpdate
@@spawnSegBoss:
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
    je @@bossPartsFailed
    call far ptr InitSegBossPartRecord
    mov word ptr ds:[bx + REC_TYPE], 76h
    mov word ptr ds:[bx + REC_SPRITE], 20h
    mov ds:[SegBossAnchor], bx
    call FindFreeRecordPoolA
    cmp bx, -1
    je @@bossPartsFailed
    call far ptr InitSegBossPartRecord
    mov word ptr ds:[bx + REC_TYPE], 77h
    mov word ptr ds:[bx + REC_SPRITE], 21h
    mov word ptr ds:[bx + REC_X], 20h
    mov ds:[SegBossPart77], bx
    call FindFreeRecordPoolA
    cmp bx, -1
    je @@bossPartsFailed
    call far ptr InitSegBossPartRecord
    mov word ptr ds:[bx + REC_TYPE], 79h
    mov word ptr ds:[bx + REC_SPRITE], 23h
    mov word ptr ds:[bx + REC_X], 20h
    mov ds:[SegBossPart79], bx
    jmp near ptr FinishRecordUpdate
; Unchecked: SegBossActive stays 1 and the part pointers are stale (0 before any boss), so
; SteerSegBossAlongPath and the part-kill explosions touch stale records.
@@bossPartsFailed:
    mov word ptr ds:[EncounterLiveCount], 0
    call SmartBombAll
    jmp near ptr FinishRecordUpdate
; Encounter director (Formation33 at trigger 4; indestructible except on level 4). Level 4:
; Type21LeaderPath. Levels 1/2/5: a 23h faller on each FrameCount8 = 7 until EncounterTicks
; C8h, at F0h boss 22h (HP 0Ah * (LevelIndex + 1)). Level 3: fallers, then one invader per
; update. Level 0: the segmented boss once CountLiveEnemies == 1 (itself; equality).
; Level 3: once InvaderFormationEnd is reached it becomes type 64h (sprite 8Eh) at the
; player's X, Y 0, leaving the encounter count. Level 0: it becomes the boss core 78h.
Type21EncounterDirector:
    cmp word ptr ds:[LevelIndex], 4
    jne @@checkLevel3
    jmp near ptr Type21LeaderPath
@@checkLevel3:
    cmp word ptr ds:[LevelIndex], 3
    jne @@checkLevel0
    jmp near ptr EncounterInvaderLevel
@@checkLevel0:
    cmp word ptr ds:[LevelIndex], 0
    jne @@fallerPhase
    jmp near ptr EncounterSegBossLevel
@@fallerPhase:
    cmp word ptr ds:[EncounterTicks], 0C8h
    jae @@checkBossTime
    jmp near ptr EncounterSpawnFaller
@@checkBossTime:
    cmp word ptr ds:[EncounterTicks], 0F0h
    jae @@becomeBoss22
    jmp near ptr FinishRecordUpdate
@@becomeBoss22:
    mov word ptr ss:[bp + REC_TYPE], 22h
    mov word ptr ss:[bp + REC_SPRITE], 71h
    mov cx, ds:[LevelIndex]
    inc cx
    mov ax, 0Ah
    mul cx
    mov ss:[bp + REC_HIT_POINTS], ax
    mov word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    jmp near ptr FinishRecordUpdate

ResetInvaderFormation:
    mov word ptr ds:[InvaderSlotCursor], offset InvaderFormation
    mov word ptr ds:[InvaderNextMarchLeft], 0
    mov word ptr ds:[InvaderNextDropStep], 0
    ret
FormationComplete:
    dec word ptr ds:[EncounterLiveCount]
    mov word ptr ss:[bp + REC_TYPE], 64h
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    mov ss:[bp + REC_X], ax
    mov word ptr ss:[bp + REC_Y], 0
    mov word ptr ss:[bp + REC_SPRITE], 8Eh
    jmp near ptr ScrollRecordThenFinish
EncounterSpawnInvader:
    mov word ptr ds:[FramesSinceInvaderSpawn], 0
    cmp word ptr ds:[InvaderSlotCursor], offset InvaderFormationEnd
    je FormationComplete
    mov si, ds:[InvaderSlotCursor]
    push si
    call SpawnEnemyHere
    pop si
    cmp bx, -1
    je @@done
    lodsw
    add ax, 20h
    mov ds:[bx + REC_SAVED_Y], ax
    lodsw
    mov ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 61h
    mov word ptr ds:[bx + REC_SPRITE], 0E7h
    inc word ptr ds:[EncounterLiveCount]
    add word ptr ds:[InvaderSlotCursor], 4
@@done:
    jmp near ptr FinishRecordUpdate
EncounterSpawnFaller:
    cmp word ptr ds:[FrameCount8], 7
    je @@spawnFaller
    jmp near ptr FinishRecordUpdate
@@spawnFaller:
    call SpawnEnemyHereQuiet
    cmp bx, -1
    jne @@setupFaller
    jmp near ptr FinishRecordUpdate
@@setupFaller:
    call AssignNextFallerColumn
    mov word ptr ds:[bx + REC_SAVED_Y], 10h
    mov word ptr ds:[bx + REC_TYPE], 23h
    cmp word ptr ds:[LevelIndex], 1
    je @@invulnerableFaller
    cmp word ptr ds:[LevelIndex], 2
    je @@level2Faller
    cmp word ptr ds:[LevelIndex], 3
    je @@invulnerableFaller
    cmp word ptr ds:[LevelIndex], 5
    je @@invulnerableFaller
    jmp near ptr FinishRecordUpdate
@@level2Faller:
    mov word ptr ds:[bx + REC_HIT_POINTS], 1
    jmp near ptr FinishRecordUpdate
@@invulnerableFaller:
    mov word ptr ds:[bx + REC_HIT_POINTS], 0FFFFh
    mov ax, ds:[RecordTickCounter]
    inc word ptr ds:[RecordTickCounter]
    and ax, 3
    mov ds:[bx + REC_FALLER_VARIANT], ax
    jmp near ptr FinishRecordUpdate
; BX = new record: REC_SAVED_X = the next FallerColumns entry.
AssignNextFallerColumn:
    mov si, ds:[FallerColumnCursor]
    cmp si, offset FallerColumnsEnd
    jb @@takeColumn
    mov word ptr ds:[FallerColumnCursor], offset FallerColumns
    mov si, ds:[FallerColumnCursor]
@@takeColumn:
    lodsw
    mov ds:[bx + REC_SAVED_X], ax
    mov ds:[FallerColumnCursor], si
    ret
; Steers to its column top, then falls by the FallerVariants[REC_FALLER_VARIANT] profile; on
; level 2 aims at the player as type 2Ch.
Type23ColumnFaller:
    mov ax, ss:[bp + REC_X]
    cmp ax, ss:[bp + REC_SAVED_X]
    je @@checkY
    jmp near ptr SteerToSavedTail
@@checkY:
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    je @@atColumnTop
    jmp near ptr SteerToSavedTail
@@atColumnTop:
    cmp word ptr ss:[bp + REC_Y], 20h
    ja @@fall
    cmp word ptr ss:[bp + REC_Y], 1Ch
    jb @@fall
    cmp byte ptr ds:[SfxEnabled], 0
    je @@fall
    mov byte ptr ds:[SfxRequest], 1Dh
@@fall:
    cmp word ptr ds:[LevelIndex], 2
    je @@aimAtPlayer
    mov si, ss:[bp + REC_FALLER_VARIANT]
    shl si, 1
    shl si, 1
    mov ax, offset FallerVariants
    xor cx, cx
    mov dx, 80h
    cmp word ptr ds:[LevelIndex], 3
    je @@altVariants
    cmp word ptr ds:[LevelIndex], 5
    jne @@applyVariant
@@altVariants:
    mov ax, offset FallerVariantsAlt
    inc cx
    mov dx, 6Dh
@@applyVariant:
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
@@aimAtPlayer:
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
; Steers BP toward REC_SAVED_X/Y at the caller's SteerSpeed (overwrites SteerTarget*).
; NZ = SteerArrived: already there at entry, no step this call.
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
; Fires random aimed shots while RecordTickCounter is 2BCh..2D0h. The drop sets the
; global RecordTickCounter = 28h, targets (player X + 8) & ~7 unless CountGate2324 = 1,
; and keeps falling 4 px per frame past A0h.
Type20SlotHopperDropper:
    cmp word ptr ss:[bp + REC_DIVE_PHASE], -1
    je Type20SlotHopper
    mov bx, word ptr ss:[bp + REC_DIVE_PHASE]
    shl bx, 1
    jmp word ptr cs:[bx + Type20Cases]
Type20Cases label word
    dw offset Type20MoveAbovePlayer, offset Type20StartDrop, offset Type20Drop
Type20MoveAbovePlayer:
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ss:[bp + REC_SAVED_X]
    je @@checkY
    jmp near ptr SteerToSavedTail
@@checkY:
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ss:[bp + REC_SAVED_Y]
    je @@arrived
    jmp near ptr SteerToSavedTail
@@arrived:
    inc word ptr ss:[bp + REC_DIVE_PHASE]
    jmp near ptr FinishRecordUpdate
Type20StartDrop:
    mov word ptr ss:[bp + REC_SPRITE], 079h
    inc word ptr ss:[bp + REC_DIVE_PHASE]
    jmp near ptr FinishRecordUpdate
Type20Drop:
    add word ptr ss:[bp + REC_Y], 4
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae @@landed
    jmp near ptr FinishRecordUpdate
@@landed:
    mov word ptr ss:[bp + REC_SPRITE], 077h
    jmp near ptr FinishRecordUpdate
Type20SlotHopper:
    mov ax, word ptr ds:[SlowCount6]
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    jae @@rightHalfSprite
    neg ax
    add ax, 07Fh
    jmp short @@setSprite
@@rightHalfSprite:
    add ax, 07Ah
@@setSprite:
    mov word ptr ss:[bp + REC_SPRITE], ax
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ss:[bp + REC_SAVED_X]
    je @@checkSlotY
    jmp near ptr SteerToSavedTail
@@checkSlotY:
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ss:[bp + REC_SAVED_Y]
    je @@inSlot
    jmp near ptr SteerToSavedTail
@@inSlot:
    cmp word ptr ds:[EncounterTicks], 023h
    jae @@maybeShoot
    jmp near ptr FinishRecordUpdate
@@fewLeft:
    cmp word ptr ds:[CountGate2324], 1
    je @@startDrop
@@targetPlayerX:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    mov word ptr ss:[bp + REC_SAVED_X], ax
@@startDrop:
    and word ptr ss:[bp + REC_SAVED_X], 0FFF8h
    mov word ptr ds:[RecordTickCounter], 028h
    mov word ptr ss:[bp + REC_DIVE_PHASE], 0
    mov word ptr ss:[bp + REC_SPRITE], 078h
    mov word ptr ss:[bp + REC_SAVED_Y], 020h
    jmp near ptr FinishRecordUpdate
@@maybeShoot:
    cmp word ptr ds:[RecordTickCounter], 02BCh
    jb @@checkLiveCount
    cmp word ptr ds:[RecordTickCounter], 02D0h
    ja @@checkLiveCount
    call NextRandomWord
    and bx, 1
    jne @@checkLiveCount
    call SpawnAimedShot
@@checkLiveCount:
    cmp word ptr ds:[EncounterLiveCount], 3
    jbe @@fewLeft
    cmp word ptr ds:[RecordTickCounter], 5
    jb @@targetPlayerX
    cmp word ptr ds:[FrameCount64], 03Fh
    je @@nextSlot
    jmp near ptr FinishRecordUpdate
@@nextSlot:
    mov si, word ptr ds:[FormationSlotCursor]
    cmp si, offset FormationSlotsEnd
    jb @@takeSlot
    mov word ptr ds:[FormationSlotCursor], offset FormationSlots
    mov si, word ptr ds:[FormationSlotCursor]
@@takeSlot:
    lodsw
    add ax, 020h
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    lodsw
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov word ptr ds:[FormationSlotCursor], si
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ss:[bp + REC_SAVED_Y]
    jne @@done
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ss:[bp + REC_SAVED_X]
    je @@nextSlot
@@done:
    jmp near ptr FinishRecordUpdate
; Shared tail: SteerToSaved at speed 2, then REC_DIRECTION = DIR_DOWN, then
; FinishRecordUpdate.
SteerToSavedTail:
    mov word ptr ds:[SteerSpeed], 2
    call SteerToSaved
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jmp near ptr FinishRecordUpdate
; Enters its slot, then bobs, sinks and shoots; chases the player when few remain or
; once low on screen.
Type1DSlotBobThenChase:
    cmp word ptr ds:[EncounterLiveCount], 2
    ja @@checkLow
    jmp near ptr @@chasePlayer
@@checkLow:
    cmp word ptr ss:[bp + REC_Y], 0C0h
    ja @@chasePlayer
    cmp word ptr ds:[EncounterTicks], 28h
    jae @@bob
    mov word ptr ds:[SteerSpeed], 1
    mov word ptr ss:[bp + REC_SPRITE], 75h
    and word ptr ss:[bp + REC_SAVED_X], -2
    and word ptr ss:[bp + REC_X], -2
    and word ptr ss:[bp + REC_SAVED_Y], -2
    and word ptr ss:[bp + REC_Y], -2
    call SteerToSaved
    jne @@arrived
    jmp near ptr FinishRecordUpdate
@@arrived:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jmp near ptr FinishRecordUpdate
@@bob:
    cmp word ptr ds:[RecordTickCounter], 2EFh
    jne @@checkShot2
    call SpawnAimedShot
@@checkShot2:
    cmp word ptr ds:[RecordTickCounter], 159h
    jne @@checkShot3
    call SpawnAimedShot
@@checkShot3:
    cmp word ptr ds:[RecordTickCounter], 79h
    jne @@sway
    call SpawnAimedShot
@@sway:
    mov ax, ds:[SwayDirX]
    neg ax
    add ss:[bp + REC_Y], ax
    mov ax, 75h
    cmp word ptr ds:[SwayDirX], -1
    je @@setSprite
    mov ax, 76h
@@setSprite:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount8], 7
    je @@sink
    jmp near ptr FinishRecordUpdate
@@sink:
    inc word ptr ss:[bp + REC_Y]
    jmp near ptr FinishRecordUpdate
@@chasePlayer:
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
    jne @@arrived
    jmp near ptr FinishRecordUpdate
@@arrived:
    call SpawnAimedShot
    cmp word ptr ss:[bp + REC_SAVED_X], 0
    je @@shuttleRight
    mov word ptr ss:[bp + REC_SAVED_X], 0
    jmp near ptr FinishRecordUpdate
@@shuttleRight:
    mov word ptr ss:[bp + REC_SAVED_X], 0C0h
    jmp near ptr FinishRecordUpdate
; Types 16h/17h: steers to REC_SAVED, waits REC_ENTRY_DELAY, moves to Y 20h (16h) or 40h
; (17h); becomes type 18h at EncounterTicks 31h.
Type16SweepLeadIn:
    mov word ptr ds:[SteerSpeed], 1
    cmp word ptr ds:[LevelIndex], 0
    jne @@steer
    mov word ptr ds:[SteerSpeed], 2
@@steer:
    call SteerToSaved
    pushf
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 10Dh
    mov ss:[bp + REC_SPRITE], ax
    popf
    jne @@arrived
    jmp near ptr FinishRecordUpdate
@@arrived:
    cmp word ptr ss:[bp + REC_ENTRY_DELAY], 0
    je @@waitSweep
    dec word ptr ss:[bp + REC_ENTRY_DELAY]
    je @@delayDone
    jmp near ptr FinishRecordUpdate
@@delayDone:
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
    cmp word ptr ss:[bp + REC_TYPE], 16h
    jne @@type17Y
    jmp near ptr FinishRecordUpdate
@@type17Y:
    mov word ptr ss:[bp + REC_SAVED_Y], 40h
    jmp near ptr FinishRecordUpdate
@@waitSweep:
    cmp word ptr ds:[EncounterTicks], 31h
    je @@startSweep
    jmp near ptr FinishRecordUpdate
@@startSweep:
    mov word ptr ss:[bp + REC_TYPE], 18h
    jmp near ptr FinishRecordUpdate
; Walks the REC_PATH waypoints at speed 3 (FFFFh, address = jump); random downward
; shots and a periodic aimed shot.
; A throttled down shot writes DIR_DOWN through the stale BX = 2 (SpawnThrottledChild).
Type18SweepPathLooper:
    mov ax, ds:[RecordTickCounter]
    and ax, 3FFh
    cmp ax, 0Ch
    jne @@followPath
    call SpawnAimedShot
    inc word ptr ds:[RecordTickCounter]
@@followPath:
    mov si, ss:[bp + REC_PATH]
    lodsw
    cmp ax, 0FFFFh
    je @@pathJump
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
    jne @@nextWaypoint
    jmp near ptr FinishRecordUpdate
@@nextWaypoint:
    mov ss:[bp + REC_PATH], si
    call NextRandomWord
    and bx, 7
    cmp bx, 2
    jne Type18SweepPathLooper
    call SpawnThrottledChild
    cmp bx, -1
    je Type18SweepPathLooper
    mov word ptr ds:[bx + REC_DIRECTION], DIR_DOWN
    jmp short Type18SweepPathLooper
@@pathJump:
    lodsw
    mov ss:[bp + REC_PATH], ax
    jmp short Type18SweepPathLooper
; Sways in its formation slot after the leader script ends; dives at the player when few
; remain or on a tick, wraps below D0h and returns to the slot.
Type14FormationSwayDiver:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript13End
    jne @@setSprite
    cmp word ptr ds:[RecordTickCounter], 2EFh
    jne @@sway
    call SpawnAimedShot
    inc word ptr ds:[RecordTickCounter]
@@sway:
    mov ax, ds:[SwayDirX]
    add ss:[bp + REC_SAVED_X], ax
    mov ax, ds:[SwayDropY]
    add ss:[bp + REC_SAVED_Y], ax
    cmp word ptr ss:[bp + REC_SAVED_Y], 0D0h
    jna @@checkInSlot
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
@@checkInSlot:
    mov ax, ss:[bp + REC_X]
    add ax, ds:[SwayDirX]
    cmp ax, ss:[bp + REC_SAVED_X]
    jne @@outOfSlot
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    jne @@outOfSlot
    cmp word ptr ds:[EncounterLiveCount], 6
    jb @@dive
    mov ax, ds:[RecordTickCounter]
    cmp word ptr ds:[DifficultySetting], 2
    je @@hardDiveTick
    and ax, 0FFh
    cmp ax, 0FFh
    jne @@setSprite
    jmp short @@diveTick
@@hardDiveTick:
    and ax, 7Fh
    cmp ax, 7Fh
    jne @@setSprite
@@diveTick:
    inc word ptr ds:[RecordTickCounter]
@@dive:
    mov bx, offset PrimaryRecord
    call SetDeltaToward
    call StepAlongDelta
    add word ptr ss:[bp + REC_Y], 2
@@setSprite:
    mov ax, ds:[SlowCount4]
    add ax, 1Ch
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr FinishRecordUpdate
@@returnToSlot:
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
@@outOfSlot:
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    jna @@returnToSlot
    call StepAlongDelta
    cmp word ptr ds:[EncounterLiveCount], 6
    jae @@checkWrap
    cmp word ptr ds:[FrameCount64], 3Fh
    jne @@checkWrap
    call SpawnAimedShot
@@checkWrap:
    cmp word ptr ss:[bp + REC_Y], 0D0h
    ja @@wrapToTop
    jmp near ptr FinishRecordUpdate
@@wrapToTop:
    mov word ptr ss:[bp + REC_Y], 10h
    jmp near ptr FinishRecordUpdate
; Type 19h patrol without firing (sprite 27h based).
Type1BWallPatrolB:
    mov ax, ds:[SlowCount6]
    shr ax, 1
    add ax, 27h
    mov ss:[bp + REC_SPRITE], ax
    jmp short WallPatrolTail
; Type 19h patrol without firing (sprite 24h based).
Type1AWallPatrolA:
    mov ax, ds:[SlowCount6]
    shr ax, 1
    add ax, 24h
    mov ss:[bp + REC_SPRITE], ax
WallPatrolTail:
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
    jne @@walkRight
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    cmp word ptr ss:[bp + REC_X], 0
    je @@turnRight
    call TryTerrainStep
    jne @@turnRight
    jmp near ptr ScrollRecordThenFinish
@@turnRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp near ptr ScrollRecordThenFinish
@@walkRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    je @@turnLeft
    call TryTerrainStep
    jne @@turnLeft
    jmp near ptr ScrollRecordThenFinish
@@turnLeft:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    jmp near ptr ScrollRecordThenFinish
; Types 8Dh/8Eh: as 8Bh with another sprite set.
Type8DClimbWalkerB:
    mov word ptr ds:[WalkerFacingStep], 0FFFFh
    jmp short ClimbWalkerBStep
; Type 8Dh facing the other way.
Type8EClimbWalkerBFlipped:
    mov word ptr ds:[WalkerFacingStep], 1
ClimbWalkerBStep:
    call ClimbWalkerStep
    mov bx, 0
    je @@pickSprite
    mov bx, ds:[SlowCount4]
    shl bx, 1
    mov bx, ds:[bx + PingPongFrames4]
@@pickSprite:
    mov ax, 13Ah
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, bx
    xor cx, cx
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_UP
    je @@addDirOffset
    mov cx, 3
@@addDirOffset:
    add ax, cx
    jmp short ClimbWalkerSpriteAndShoot
; Type 8Bh facing the other way.
Type8CClimbWalkerAFlipped:
    mov word ptr ds:[WalkerFacingStep], 0FFFFh
    jmp short ClimbWalkerAStep
; Types 8Bh/8Ch: climbs toward the player's Y along a wall, firing aimed shots.
Type8BClimbWalkerA:
    mov word ptr ds:[WalkerFacingStep], 1
ClimbWalkerAStep:
    call ClimbWalkerStep
    mov bx, 0
    je @@pickSprite
    mov bx, ds:[SlowCount4]
@@pickSprite:
    mov ax, 61h
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, bx
    add ax, ss:[bp + REC_DIRECTION]
ClimbWalkerSpriteAndShoot:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[FrameCount128], 7Fh
    je @@shoot
    cmp word ptr ds:[FrameCount128], 6Bh
    je @@shoot
    cmp word ptr ds:[FrameCount128], 57h
    jne ScrollRecordThenFinish
@@shoot:
    call SpawnAimedShot
    cmp bx, -1
    je ScrollRecordThenFinish
    mov word ptr ds:[bx + REC_SPRITE], 3
    sub word ptr ds:[bx + REC_X], 8
    sub word ptr ds:[bx + REC_Y], 8
    jmp short ScrollRecordThenFinish
ClimbWalkerBlocked:
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
    je ClimbWalkerBlocked
    mov ax, ss:[bp + REC_Y]
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jl @@climbDown
    add bx, ds:[WalkerFacingStep]
    call ReadIndexedByteAttribute
    je ClimbWalkerBlocked
    call TryTerrainStep
    cmp word ptr ds:[TerrainBlocked], 1
    ret
@@climbDown:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    add bx, ds:[WalkerFacingStep]
    sub bx, MAP_ROW_BYTES
    call ReadIndexedByteAttribute
    je ClimbWalkerBlocked
    call TryTerrainStep
    cmp word ptr ds:[TerrainBlocked], 1
    ret
; BP = record: move it with the playfield scroll (REC_Y += ScrollDeltaY), then
; FinishRecordUpdate. The common tail of most REC_TYPE handlers.
ScrollRecordThenFinish:
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
; Clamp X; remove the record when REC_Y < -0C0h or >= 0F0h (signed; types 0, 26h, 28h,
; 29h, 34h, 48h, 86h and all records during the level end use -14h as the top bound);
; then the collision checks unless LevelEndPhase is set.
FinishRecordUpdate:
    call ClampRecordX
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne @@exemptBounds
    cmp word ptr ss:[bp + REC_TYPE], 0
    je @@exemptBounds
    cmp word ptr ss:[bp + REC_TYPE], 048h
    je @@exemptBounds
    cmp word ptr ss:[bp + REC_TYPE], 026h
    je @@exemptBounds
    cmp word ptr ss:[bp + REC_TYPE], 086h
    je @@exemptBounds
    cmp word ptr ss:[bp + REC_TYPE], 028h
    je @@exemptBounds
    cmp word ptr ss:[bp + REC_TYPE], 029h
    je @@exemptBounds
    cmp word ptr ss:[bp + REC_TYPE], 034h
    je @@exemptBounds
    cmp word ptr ss:[bp + REC_Y], 0FF40h
    jge @@checkBottom
    jmp near ptr RemoveRecord
@@checkBottom:
    cmp word ptr ss:[bp + REC_Y], 0F0h
    jl @@onScreen
    jmp near ptr RemoveRecord
@@onScreen:
    jmp short @@collisions
@@exemptBounds:
    cmp word ptr ss:[bp + REC_Y], -014h
    jl RemoveRecord
    cmp word ptr ss:[bp + REC_Y], 0F0h
    jge RemoveRecord
@@collisions:
    cmp word ptr ds:[LevelEndPhase], LEVEL_END_OFF
    jne @@done
    call CheckRecordHitsPlayer
    call PlayerShotsHitRecord
@@done:
    ret

; Clamp REC_X to 0..PLAYFIELD_MAX_X (signed).
ClampRecordX:
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    jg @@clampRight
    cmp word ptr ss:[bp + REC_X], 0
    jl @@clampLeft
    ret
@@clampRight:
    mov word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    ret
@@clampLeft:
    mov word ptr ss:[bp + REC_X], 0
    ret
; BP = record: on body contact destroys it (not during a segmented boss) and calls
; LosePlayerEnergyTank.
CheckRecordHitsPlayer:
    cmp word ptr ss:[bp + REC_STATUS], 0
    jne @@checkKind
    ret
@@checkKind:
    cmp word ptr ss:[bp + REC_KIND], KIND_PICKUP
    jne @@checkType0
    ret
@@checkType0:
    cmp word ptr ss:[bp + REC_TYPE], 0
    jne @@checkType1
    ret
@@checkType1:
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne @@checkSize
    ret
@@checkSize:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 1
    je @@smallHit
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 2
    je @@largeHit
    ret
@@smallHit:
    call SmallRecordHitsPlayer
    jmp short @@testHit
@@largeHit:
    call LargeRecordHitsPlayer
@@testHit:
    jb @@hit
    ret
@@hit:
    cmp word ptr ds:[SegBossActive], 1
    je @@loseTank
    call DestroyRecord
@@loseTank:
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

; BP = record: REC_STATUS = 0 and per-class bookkeeping. Enemy: ReleaseEncounterMember
; (leaders drop their item even when leaving the screen) and, unless type 1, zero its
; group's GROUP_LIVE (no drop). Pod -> KIND_TYPED. Type 9: frees the whole BeamList.
RemoveRecord:
    mov word ptr ss:[bp + REC_STATUS], 0
    cmp word ptr ss:[bp + REC_KIND], KIND_ENEMY
    je @@enemyFreed
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je @@podFreed
    cmp word ptr ss:[bp + REC_TYPE], 7
    je @@mainShotFreed
    cmp word ptr ss:[bp + REC_TYPE], 8
    je @@mainShotFreed
    cmp word ptr ss:[bp + REC_TYPE], 9
    je @@beamFreed
    cmp word ptr ss:[bp + REC_TYPE], 6
    jne @@checkType5
    jmp near ptr @@sideShotFreed
@@checkType5:
    cmp word ptr ss:[bp + REC_TYPE], 5
    je @@sideShotFreed
    cmp word ptr ss:[bp + REC_TYPE], 0Ch
    je @@frontPodShotFreed
    cmp word ptr ss:[bp + REC_TYPE], 0Ah
    je @@missileFreed
    ret
@@podFreed:
    mov word ptr ss:[bp + REC_KIND], KIND_TYPED
    ret
@@enemyFreed:
    call ReleaseEncounterMember
    cmp word ptr ss:[bp + REC_TYPE], 1
    jne @@checkGroup
    ret
@@checkGroup:
    cmp word ptr ss:[bp + REC_SLOT_INDEX], -1
    jne @@clearGroupLive
    ret
@@clearGroupLive:
    mov si, word ptr ss:[bp + REC_SLOT_INDEX]
    shl si, 1
    add si, offset GroupTable
    mov byte ptr ds:[si + GROUP_LIVE], 0
    ret
@@beamFreed:
    cmp word ptr ds:[ShotsLiveType9], 0
    jne @@clearBeamList
    ret
; Frees every record listed in BeamList. Each entry is written back unchanged (the
; list itself is not cleared) and CX is loaded but never used.
@@clearBeamList:
    mov cx, 01Ah
    mov si, offset BeamList
@@nextBeam:
    lodsw
    cmp ax, 0FFFFh
    jne @@clearBeamSegment
    ret
@@clearBeamSegment:
    mov word ptr ds:[si - 2], ax
    mov bx, ax
    mov word ptr ds:[bx + REC_STATUS], 0
    dec word ptr ds:[ShotsLiveType9]
    jmp short @@nextBeam
@@missileFreed:
    cmp word ptr ds:[MissilesLive], 0
    je @@missileTail
    dec word ptr ds:[MissilesLive]
@@missileTail:
    jmp near ptr RefreshUpgradeDisplay
@@mainShotFreed:
    cmp word ptr ds:[ShotsLiveMain], 0
    je @@mainShotDone
    dec word ptr ds:[ShotsLiveMain]
@@mainShotDone:
    ret
@@frontPodShotFreed:
    cmp word ptr ds:[ShotsLiveFrontPod], 0
    je @@frontPodShotDone
    dec word ptr ds:[ShotsLiveFrontPod]
@@frontPodShotDone:
    ret
@@sideShotFreed:
    cmp word ptr ds:[ShotsLiveSide], 0
    je @@sideShotDone
    dec word ptr ds:[ShotsLiveSide]
@@sideShotDone:
    ret
; CF when TerrainProbeY/X is strictly within 10h (signed) of another walker (enemy types
; 82h..94h, pass 0, size 1; BP itself skipped by its REC_SAVE_BUFFER). NC for pass-1 BP.
ProbeOverlapsWalker:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 1
    je @@noOverlap
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
    mov ax, word ptr ds:[TerrainProbeX]
    mov di, word ptr ds:[TerrainProbeY]
@@checkRecord:
    cmp word ptr ds:[bx + REC_STATUS], 0
    je @@nextRecord
    cmp word ptr ds:[bx + REC_DRAW_PASS], 1
    je @@nextRecord
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    jne @@nextRecord
    cmp word ptr ds:[bx + REC_KIND], KIND_ENEMY
    jne @@nextRecord
    cmp word ptr ds:[bx + REC_TYPE], 082h
    jb @@nextRecord
    cmp word ptr ds:[bx + REC_TYPE], 094h
    ja @@nextRecord
    mov si, word ptr ds:[bx + REC_Y]
    add si, 010h
    cmp di, si
    jge @@nextRecord
    sub si, 020h
    cmp di, si
    jle @@nextRecord
    mov si, word ptr ds:[bx + REC_X]
    add si, 010h
    cmp ax, si
    jge @@nextRecord
    sub si, 020h
    cmp ax, si
    jle @@nextRecord
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    cmp si, word ptr ds:[bx + REC_SAVE_BUFFER]
    je @@nextRecord
    jmp near ptr ReturnCarrySet
@@nextRecord:
    add bx, RECORD_SIZE
    loop @@checkRecord
@@noOverlap:
    clc
    ret
; Explosion: REC_ANIM advances every 2nd frame; small ones end at 9 (types 24h/25h leave
; a type 26h wreck), large ones at 0Ch. Size class 0 only scrolls.
Type01ExplosionAnimation:
    cmp word ptr ds:[CountGate2324], 1
    je @@advance
    jmp near ptr ScrollRecordThenFinish
@@advance:
    inc word ptr ss:[bp + REC_ANIM_COUNTER]
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    shl bx, 1
    jmp word ptr cs:[bx + ExplosionSizeCases]
    even
ExplosionSizeCases label word
    dw offset ScrollRecordThenFinish, offset AnimateExplosion16, offset AnimateExplosion32
AnimateExplosion16:
    cmp word ptr ss:[bp + REC_ANIM_COUNTER], 9
    jne Explosion16Frame
    cmp word ptr ss:[bp + REC_PREV_TYPE], 024h
    je @@leaveWreckLeft
    cmp word ptr ss:[bp + REC_PREV_TYPE], 025h
    je @@leaveWreckRight
    jmp near ptr RemoveRecord
@@leaveWreckLeft:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    mov word ptr ss:[bp + REC_TYPE], 026h
    mov word ptr ss:[bp + REC_SPRITE], 097h
    sub word ptr ss:[bp + REC_X], 8
    jmp short StoreRecordSavedPosition
@@leaveWreckRight:
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
Explosion16Frame:
    mov ax, word ptr ss:[bp + REC_ANIM_COUNTER]
    add ax, 0
    mov word ptr ss:[bp + REC_SPRITE], ax
    jmp near ptr ScrollRecordThenFinish
AnimateExplosion32:
    cmp word ptr ss:[bp + REC_ANIM_COUNTER], 0Ch
    jne @@nextFrame
    jmp near ptr RemoveRecord
@@nextFrame:
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
    jne @@checkType8
    jmp near ptr PiercingHit
@@checkType8:
    cmp word ptr ds:[bx + REC_TYPE], 8
    jne @@checkType0C
    jmp near ptr PiercingHit
@@checkType0C:
    cmp word ptr ds:[bx + REC_TYPE], 0Ch
    jne @@checkType9
    jmp near ptr PiercingHit
@@checkType9:
    cmp word ptr ds:[bx + REC_TYPE], 9
    jne @@checkType2
    jmp near ptr BeamHit
@@checkType2:
    cmp word ptr ds:[bx + REC_TYPE], 2
    je @@type2Hit
    cmp word ptr ds:[bx + REC_TYPE], 6
    jne @@checkType5
    jmp near ptr SideShotHit
@@checkType5:
    cmp word ptr ds:[bx + REC_TYPE], 5
    jne @@checkTarget
    jmp near ptr SideShotHit
@@checkTarget:
    cmp bp, word ptr ds:[bx + REC_TARGET]
    je @@missileHit
    ret
@@missileHit:
    mov word ptr ds:[bx + REC_MISSILE_LOCKED], 0
    cmp word ptr ds:[SegBossActive], 1
    je DamageTwo
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp near ptr DestroyRecord
@@type2Hit:
    mov word ptr ds:[bx + REC_STATUS], 0
    cmp word ptr ds:[bx + REC_SPRITE], 033h
    jne DamageOne
DamageTwo:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    jne DamageOne
    jmp near ptr DestroyRecord
DamageOne:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    jne @@difficultyDamage
    jmp near ptr DestroyRecord
@@difficultyDamage:
    cmp word ptr ds:[DifficultySetting], 1
    je @@extraDamage
    cmp word ptr ds:[DifficultySetting], 0
    jne @@flash
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je DestroyRecord
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je DestroyRecord
@@extraDamage:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je DestroyRecord
@@flash:
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    cmp word ptr ds:[SegBossActive], 1
    je @@flashBossParts
    ret
@@flashBossParts:
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
    je @@done
    mov byte ptr ds:[SfxRequest], 0Eh
@@done:
    pop bp
    ret
PierceBossHit:
    call RemoveRecordAtBX
    jmp short DamageTwo
SideShotHit:
    call RemoveRecordAtBX
    cmp word ptr ds:[SegBossActive], 1
    je DamageTwo
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short DestroyRecord
BeamHit:
    cmp word ptr ds:[SegBossActive], 1
    jne @@destroyOutright
    jmp near ptr DamageTwo
@@destroyOutright:
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short DestroyRecord
PiercingHit:
    cmp word ptr ds:[SegBossActive], 1
    je PierceBossHit
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short DestroyRecord
; Starts BP's explosion in place: REC_PREV_TYPE = type, type 1, frame 0 (size 1/2 sprite
; 0/3), score 30h (size 1) else 60h, sfx 19h, ReleaseEncounterMember, GROUP_LIVE - 1
; with the drop at 0. Type 21h is indestructible outside level 4. No type-1 guard.
DestroyRecord:
    cmp word ptr ss:[bp + REC_TYPE], 021h
    jne @@score
    cmp word ptr ds:[LevelIndex], 4
    je @@score
    ret
@@score:
    cmp word ptr ss:[bp + REC_SIZE_CLASS], 1
    mov bx, 030h
    je @@addScore
    mov bx, 060h
@@addScore:
    call AddScoreBcd
    call ClampRecordX
    push bp
    cmp word ptr ss:[bp + REC_SLOT_INDEX], -1
    je @@release
    mov si, word ptr ss:[bp + REC_SLOT_INDEX]
    shl si, 1
    add si, offset GroupTable
    cmp byte ptr ds:[si + GROUP_LIVE], 0
    je @@release
    dec byte ptr ds:[si + GROUP_LIVE]
    jne @@release

    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[DropX], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[DropY], ax
    mov al, byte ptr ds:[si + GROUP_DROP_KIND]
    xor ah, ah
    mov word ptr ds:[DropKind], ax
    call SpawnItemDrop
@@release:
    pop bp
    call ReleaseEncounterMember
    cmp byte ptr ds:[SfxEnabled], 0
    je @@startExplosion
    mov byte ptr ds:[SfxRequest], 019h
@@startExplosion:
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
    jne @@checkType77
    jmp near ptr @@segBossPartKilled
@@checkType77:
    cmp word ptr ss:[bp + REC_TYPE], 077h
    jne @@checkType78
    jmp near ptr @@segBossPartKilled
@@checkType78:
    cmp word ptr ss:[bp + REC_TYPE], 078h
    jne @@checkType79
    jmp near ptr @@segBossPartKilled
@@checkType79:
    cmp word ptr ss:[bp + REC_TYPE], 079h
    jne @@checkType61
    jmp near ptr @@segBossPartKilled
@@checkType61:
    cmp word ptr ss:[bp + REC_TYPE], 061h
    jne @@checkType62
    jmp near ptr @@countDown
@@checkType62:
    cmp word ptr ss:[bp + REC_TYPE], 062h
    jne @@checkType65
    jmp near ptr @@countDown
@@checkType65:
    cmp word ptr ss:[bp + REC_TYPE], 065h
    jne @@checkType14
    jmp near ptr @@countDown
@@checkType14:
    cmp word ptr ss:[bp + REC_TYPE], 014h
    jne @@checkType16
    jmp near ptr @@countDown
@@checkType16:
    cmp word ptr ss:[bp + REC_TYPE], 016h
    jne @@checkType17
    jmp near ptr @@countDown
@@checkType17:
    cmp word ptr ss:[bp + REC_TYPE], 017h
    jne @@checkType18
    jmp near ptr @@countDown
@@checkType18:
    cmp word ptr ss:[bp + REC_TYPE], 018h
    jne @@checkType7F
    jmp near ptr @@countDown
@@checkType7F:
    cmp word ptr ss:[bp + REC_TYPE], 07Fh
    jne @@checkType80
    jmp near ptr @@countDown
@@checkType80:
    cmp word ptr ss:[bp + REC_TYPE], 080h
    jne @@checkType81
    jmp near ptr @@countDown
@@checkType81:
    cmp word ptr ss:[bp + REC_TYPE], 081h
    je @@countDown
    cmp word ptr ss:[bp + REC_TYPE], 093h
    je @@type93Killed
    cmp word ptr ss:[bp + REC_TYPE], 01Dh
    je @@countDown
    cmp word ptr ss:[bp + REC_TYPE], 01Eh
    je @@countDown
    cmp word ptr ss:[bp + REC_TYPE], 020h
    je @@countDown
    cmp word ptr ss:[bp + REC_TYPE], 021h
    je @@countDown
    cmp word ptr ss:[bp + REC_TYPE], 022h
    je @@countDown
    cmp word ptr ss:[bp + REC_TYPE], 07Eh
    mov ax, offset LeaderScript7EEnd
    je @@leaderKilled
    cmp word ptr ss:[bp + REC_TYPE], 07Dh
    mov ax, offset LeaderScript7DEnd
    je @@leaderKilled
    cmp word ptr ss:[bp + REC_TYPE], 01Fh
    mov ax, offset LeaderScript1FEnd
    je @@leaderKilled
    cmp word ptr ss:[bp + REC_TYPE], 01Ch
    mov ax, offset LeaderScript1CEnd
    je @@leaderKilled
    cmp word ptr ss:[bp + REC_TYPE], 015h
    mov ax, offset LeaderScript15End
    je @@leaderKilled
    cmp word ptr ss:[bp + REC_TYPE], 013h
    mov ax, offset LeaderScript13End
    je @@leaderKilled
    ret
@@leaderKilled:
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
@@countDown:
    dec word ptr ds:[EncounterLiveCount]
    ret
@@type93Killed:
    mov byte ptr ds:[Type93KilledLatch], 1
    jmp short @@countDown
@@segBossPartKilled:
    mov bx, word ptr ds:[SegBossAnchor]
    cmp bx, bp
    je @@explodePart77
    call ExplodeRecordAtBX
@@explodePart77:
    mov bx, word ptr ds:[SegBossPart77]
    cmp bx, bp
    je @@explodeCore
    call ExplodeRecordAtBX
@@explodeCore:
    mov bx, word ptr ds:[SegBossCore]
    cmp bx, bp
    je @@explodePart79
    call ExplodeRecordAtBX
@@explodePart79:
    mov bx, word ptr ds:[SegBossPart79]
    cmp bx, bp
    je @@bossDone
    call ExplodeRecordAtBX
@@bossDone:
    mov word ptr ds:[EncounterLiveCount], 0
    mov word ptr ds:[SegBossActive], 0
    ret

; BX = record: starts a large explosion (type 1, sprite 3), sfx 19h.
ExplodeRecordAtBX:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@startExplosion
    mov byte ptr ds:[SfxRequest], 019h
@@startExplosion:
    mov ax, word ptr ds:[bx + REC_TYPE]
    mov word ptr ds:[bx + REC_PREV_TYPE], ax
    mov word ptr ds:[bx + REC_TYPE], 1
    mov word ptr ds:[bx + REC_ANIM_COUNTER], 0
    mov word ptr ds:[bx + REC_SPRITE], 3
    ret
; No reference found. BP = record: turn it toward the primary (REC_DIRECTION from
; AimQuadrantBits; unchanged when aligned, then return) and continue in TryTerrainStep.
UnusedTurnTowardPlayerStep:
    mov ax, word ptr ss:[bp + REC_Y]
    or ax, ax
    jns @@aimX
@@aimX:
    mov word ptr ds:[AimQuadrantBits], 0
    mov ax, word ptr ss:[bp + REC_X]
    sub ax, 4
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jl @@playerRight
    sub ax, 2
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jg @@playerLeft
    jmp short @@aimY
@@playerRight:
    mov word ptr ds:[AimQuadrantBits], 1
    jmp short @@aimY
@@playerLeft:
    mov word ptr ds:[AimQuadrantBits], 2
@@aimY:
    mov ax, word ptr ss:[bp + REC_Y]
    sub ax, 4
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jl @@playerBelow
    sub ax, 2
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jg @@playerAbove
    jmp short @@lookupDirection
@@playerBelow:
    or word ptr ds:[AimQuadrantBits], 4
    jmp short @@lookupDirection
@@playerAbove:
    or word ptr ds:[AimQuadrantBits], 8
@@lookupDirection:
    mov bx, offset DirectionFromQuadrant
    mov ax, word ptr ds:[AimQuadrantBits]
    xlat
    cmp al, 0FFh
    jne @@turnAndStep
    ret
@@turnAndStep:
    mov word ptr ss:[bp + REC_DIRECTION], ax
    jmp near ptr TryTerrainStep

; BP = parent: an unthrottled SpawnThrottledChild at +0Ch, +0Ch; BX = child or FFFFh.
SpawnChildAt12:
    call FindFreeRecordPoolB
    cmp bx, -1
    jne @@placeChild
    ret
@@placeChild:
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 0Ch
    mov word ptr ds:[bx + REC_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 0Ch
    jmp short InitChildRecord
; BP = parent record. Spawns a pool-B child (REC_KIND 2, REC_TYPE 4, sprite 30h) at
; parent +4,+4 moving in the parent's direction, on every 4th / 2nd / every call for
; DifficultySetting 0 / 1 / 2. Unless the child is near the top (REC_Y < 8) or the
; parent below E0h (unsigned), requests an effect chosen by the parent's REC_TYPE and
; returns BX = child. Pool full: BX = FFFFh. Throttled: returns with BX UNCHANGED (AL = 0
; only at difficulty 0); callers that test BX = FFFFh then write through the stale BX
; (types 24h/25h: RunTypeHandler's REC_TYPE * 2, hitting DS:0050/0052).
SpawnThrottledChild:
    cmp word ptr ds:[DifficultySetting], 2
    je @@spawn
    cmp word ptr ds:[DifficultySetting], 1
    je @@throttleHalf
    inc byte ptr ds:[ChildSpawnThrottle]
    and byte ptr ds:[ChildSpawnThrottle], 3
    je @@spawn
    xor al, al
    ret
@@throttleHalf:
    inc byte ptr ds:[ChildSpawnThrottle]
    and byte ptr ds:[ChildSpawnThrottle], 1
    jne @@spawn
    ret
@@spawn:
    call FindFreeRecordPoolB
    cmp bx, -1
    jne @@placeChild
    ret
@@placeChild:
    mov ax, word ptr ss:[bp + REC_X]
    add ax, 4
    mov word ptr ds:[bx + REC_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    add ax, 4
InitChildRecord:
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
    mov word ptr ds:[bx + REC_SHOT_TIMER], 0FFFFh
    cmp word ptr ds:[bx + REC_Y], 8
    jae @@checkParentY
    ret
@@checkParentY:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe @@requestSfx
    ret
@@requestSfx:
    mov ax, bx
    mov bx, word ptr ss:[bp + REC_TYPE]
    cmp bx, 092h
    jne @@sfxByType
    jmp near ptr ShotSfx14
@@sfxByType:
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
; Unreferenced CS word.
UnusedWordAfterSaveCursor db 00h,00h

; Life or demo start: clears the pools (pods keep their state), places the player and
; exhaust, and resets energy, shots, fuel and the level-end state. Pool A (with the
; primary) all get REC_DRAW_PASS 1; REC_KIND is not reset; PoolACursor is kept.
ResetRecordsForLife:
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset GroupTable
    mov cx, 010h
    xor ax, ax
    rep stosw
    mov word ptr cs:[SaveBufferCursor], offset PoolBSaveBuffers
    mov cx, POOL_B_COUNT
@@resetPoolB:
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
    loop @@resetPoolB
    mov word ptr cs:[SaveBufferCursor], offset PoolASaveBuffers
    mov cx, POOL_A_POINTER_COUNT
@@resetPoolA:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    mov word ptr ss:[bp + REC_DRAW_PASS], 1
    cmp word ptr ss:[bp + REC_KIND], KIND_POD
    je @@assignSaveBuffer
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_FLASH_TIMER], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov word ptr ss:[bp + REC_DIRECTION], DIR_UP
@@assignSaveBuffer:
    mov ax, word ptr cs:[SaveBufferCursor]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[SaveBufferCursor], POOL_A_SAVE_BYTES
    pop cx
    loop @@resetPoolA
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
@@resetRecord:
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
    loop @@resetRecord
    mov word ptr ds:[WeaponMode], WEAPON_SINGLE
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
ApplyCgaLevelPalette:
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
    je ApplyCgaLevelPalette
    mov si, offset DacColor6Level1
    cmp word ptr ds:[LevelIndex], 1
    je SetDacColor6
    mov si, offset DacColor6Default

; SI = three RGB bytes: writes DAC entry 6 when VideoAdapter is EGA.
SetDacColor6:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je @@writeDac
    ret
@@writeDac:
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
; 1 enables the per-file flag bytes (DecodeFileFlags); set only when a VGA DAC answers
; (EnableFileFlagsIfVgaDac), read by the EGA decoder only.
PerFileFlagsEnabled db 0

EnableFileFlagsIfVgaDac:
    call ProbeVgaDac
    jne @@done
    mov byte ptr cs:[PerFileFlagsEnabled], 1
@@done:
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
    jb @@noEms
    mov bx, ax
    mov ax, 04400h
    int 021h
    jb @@noEms
    and dx, 080h
    je @@noEms
    mov ax, 04407h
    int 021h
    jb @@noEms
    or al, al
    je @@noEms
    mov ah, DOS_CLOSE_FILE
    int 021h
    jb @@noEms
    mov ah, 040h
    int 067h
    or ah, ah
    jne @@noEms
    mov ah, 046h
    int 067h
    or ah, ah
    jne @@noEms
    cmp al, 030h
    jb @@noEms
    mov ah, 041h
    int 067h
    or ah, ah
    jne @@noEms
    mov word ptr ds:[EmsPageFrame], bx
    mov ah, 042h
    int 067h
    or ah, ah
    jne @@noEms
    mov word ptr ds:[EmsTotalPages], dx
    mov word ptr ds:[EmsFreePages], bx
    or bx, bx
    je @@noEms
    mov byte ptr ds:[EmsAvailable], 1
    ret
@@noEms:
    mov byte ptr ds:[EmsAvailable], 0
    ret

; Frees the EMS handle of every FileCache entry held in EMS (EmsAvailable only).
ReleaseEmsCache:
    cmp byte ptr ds:[EmsAvailable], 0
    jne @@scanCache
    ret
@@scanCache:
    mov si, offset FileCache
@@nextEntry:
    cmp word ptr ds:[si + CACHE_NAME], -1
    jne @@checkEntry
    ret
@@checkEntry:
    push si
    cmp word ptr ds:[si + CACHE_SEGMENT], -1
    jne @@advance
    mov dx, word ptr ds:[si + CACHE_EMS_HANDLE]
    mov ah, 045h
    int 067h
@@advance:
    pop si
    add si, FILE_CACHE_ENTRY_BYTES
    jmp short @@nextEntry

; Maps logical pages 0..BX-1 of EMS handle DX to physical pages 0..BX-1.
MapEmsPages:
    mov cx, bx
    xor ax, ax
@@mapPage:
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
    loop @@mapPage
    ret

; Loads the file named by FileNamePtr to FileBufferSegment:FileBufferOffset: copied from
; FileCache when present, else read from disk (retried silently while the current drive is A: or B: and ESC is not
; held; otherwise leaves through
; ShutdownWithError) and then offered to CacheLoadedFile. FileStatus is always OK on
; return: open failures retry or shut down, and a failed LoadPackedFile (CF) is ignored
; (its partial output is still cached), so callers' retry loops never trigger.
LoadResourceFile:
    mov word ptr ds:[FileStatus], FILE_STATUS_OK
    call CopyFromFileCache
    jne @@notCached
    ret
@@notCached:
    mov word ptr ds:[LoadWordBB82], 0
@@retryOpen:
    call AdvanceABColonPrefix
    call ProbeFloppyReady
    jne @@openFailed
    mov dx, word ptr ds:[FileNamePtr]
    xor al, al
    mov ah, 03Dh
    call far ptr OpenResourceFile
    mov word ptr ds:[FileHandle], ax
    jae @@opened
@@openFailed:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je @@abortLoad
    mov ah, DOS_GET_DRIVE
    int 021h
    cmp al, 2
    jb @@retryOpen
@@abortLoad:
    jmp near ptr ShutdownWithError
@@opened:
    cmp byte ptr ds:[LoadIsEnc], 0
    je @@loadPacked
    mov ax, word ptr ds:[FileHandle]
    mov word ptr cs:[EncFileHandle], ax
    mov ax, word ptr ds:[FileBufferSegment]
    mov word ptr cs:[EncDestSegment], ax
    mov ax, word ptr ds:[FileBufferOffset]
    mov word ptr cs:[EncDestOffset], ax
    call DecodeEncFile
    mov ax, word ptr cs:[EncOutputBytes]
    jmp short @@loaded
@@loadPacked:
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
@@loaded:
    mov word ptr ds:[FileByteCount], ax
    call CacheLoadedFile
    ret

; Keeps a copy of the file just loaded (FileByteCount bytes) in EMS pages, or else in a
; new DOS memory block, and appends a FileCache entry. Never on Tandy, and never for
; ResidentFiles. Allocation failures just skip caching.
CacheLoadedFile:
    cmp word ptr cs:[VideoAdapter], VIDEO_TANDY
    jne @@checkResident
    ret
@@checkResident:
    mov si, offset ResidentFiles
@@nextResident:
    lodsw
    cmp ax, word ptr ds:[FileNamePtr]
    jne @@checkListEnd
    ret
@@checkListEnd:
    cmp ax, 0FFFFh
    jne @@nextResident
    cmp byte ptr ds:[EmsAvailable], 0
    je @@allocDos
    mov bx, 1
    mov ax, word ptr ds:[FileByteCount]
@@countPages:
    sub ax, 04000h
    jb @@allocEms
    je @@allocEms
    inc bx
    jmp short @@countPages
@@allocEms:
    mov ah, 043h
    push bx
    int 067h
    pop bx
    or ah, ah
    jne @@allocDos
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
    jmp short @@copyToCache
@@allocDos:
    mov bx, word ptr ds:[FileByteCount]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae @@dosAllocated
    ret
@@dosAllocated:
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
@@copyToCache:
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
@@scanEntry:
    cmp word ptr ds:[si + CACHE_NAME], -1
    je @@miss
    cmp word ptr ds:[si + CACHE_NAME], ax
    je @@found
    add si, FILE_CACHE_ENTRY_BYTES
    jmp short @@scanEntry
@@found:
    cmp word ptr ds:[si + CACHE_SEGMENT], -1
    jne @@conventionalCopy
    mov dx, word ptr ds:[si + CACHE_EMS_HANDLE]
    mov bx, word ptr ds:[si + CACHE_EMS_PAGES]
    push si
    call MapEmsPages
    pop si
    mov ds, word ptr ss:[EmsPageFrame]
    jmp short @@copyEntry
@@conventionalCopy:
    mov ds, word ptr ds:[si + CACHE_SEGMENT]
@@copyEntry:
    mov cx, word ptr ss:[si + CACHE_BYTES]
    xor si, si
    mov es, word ptr ss:[FileBufferSegment]
    mov di, word ptr ss:[FileBufferOffset]
    rep movsb
    mov ds, word ptr cs:[MainDataSegment]
    xor al, al
    ret
@@miss:
    or al, 1
    ret
; AL in 61h..7Ah becomes AL & DFh; all other values unchanged. AH and other registers
; preserved. Flags reflect the final CMP or AND, not a stable boolean ABI. Near RET.
UppercaseAsciiAL:
    cmp al, 061h
    jae @@checkBelowZ
    ret
@@checkBelowZ:
    cmp al, 07Ah
    jbe @@toUpper
    ret
@@toUpper:
    and al, 0DFh
    ret
; FileNamePtr with an "A:" or "B:" prefix: keep it only when DriveAPresent/DriveBPresent is
; exactly 1, otherwise advance the drive letter and retry. Other names return unchanged.
AdvanceABColonPrefix:
    mov si, word ptr ds:[FileNamePtr]
    cmp byte ptr ds:[si + 1], 03Ah
    je @@hasColon
    ret
@@hasColon:
    mov al, byte ptr ds:[si]
    call UppercaseAsciiAL
    cmp al, 041h
    je @@driveA
    cmp al, 042h
    je @@driveB
    ret
@@driveA:
    cmp byte ptr ds:[DriveAPresent], 1
    jne @@tryNextFromA
    ret
@@tryNextFromA:
    inc byte ptr ds:[si]
    jmp short AdvanceABColonPrefix
@@driveB:
    cmp byte ptr ds:[DriveBPresent], 1
    jne @@tryNextFromB
    ret
@@tryNextFromB:
    inc byte ptr ds:[si]
    jmp short AdvanceABColonPrefix

; INT 11h: sets DriveAPresent and DriveBPresent.
DetectFloppyDrives:
    int 011h
    test al, 1
    jne @@haveFloppy
    ret
@@haveFloppy:
    mov byte ptr ds:[DriveAPresent], 1
    and al, 0C0h
    mov cl, 6
    shr al, cl
    inc al
    cmp al, 1
    jne @@haveDriveB
    ret
@@haveDriveB:
    mov byte ptr ds:[DriveBPresent], 1
    ret

; For A: or B: (from FileNamePtr or the current drive): NZ when a BIOS verify of
; cylinder 1 sector 1 times out.
ProbeFloppyReady:
    mov si, word ptr ds:[FileNamePtr]
    mov al, byte ptr ds:[si]
    cmp byte ptr ds:[si + 1], 03Ah
    je @@haveDriveLetter
    mov ah, DOS_GET_DRIVE
    int 021h
    add al, 041h
@@haveDriveLetter:
    call UppercaseAsciiAL
    sub al, 041h
    cmp al, 2
    jae @@notFloppy
    mov dl, al
    mov dh, 0
    mov cx, 0101h
    mov ax, 0401h
    int 013h
    and ah, 080h
    ret
@@notFloppy:
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

; Checksums OVERKILL.EXE (the launcher) and OVERKILL (this program's own file, which also
; carries the SHADOW archive), both in the current directory; falls into ChecksumFileOrAbort.
VerifyStartupChecksums:
    mov word ptr cs:[IntegritySkip], 0
    mov dx, offset IntegrityFileExe
    call ChecksumFileOrAbort
    mov dx, offset IntegrityFileData

; DX = file name. Sum from 1234h, per byte AX += b then AH += AL, over all but the last
; word, which must equal it. For OVERKILL.EXE the 64 bytes before that word also give
; Codeword..Password (XOR AAh), read only by uncalled code. DOS errors unchecked; a
; mismatch prints, waits for a key and exits with code 1 (not through ShutdownGame).
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
@@readChunk:
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
    jcxz @@endOfFile
    mov si, 042h
    mov dh, 0
@@sumByte:
    mov dl, byte ptr ds:[si]
    add ax, dx
    add ah, al
    inc si
    loop @@sumByte
    mov word ptr cs:[IntegrityRunningSum], ax
    jmp short @@readChunk
@@endOfFile:
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
    je @@freeBuffer
    cmp word ptr ss:[FileNamePtr], offset IntegrityFileExe
    jne @@freeBuffer
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
@@freeBuffer:
    mov es, word ptr cs:[IntegrityBufferSegment]
    mov ah, DOS_FREE_MEMORY
    int 021h
    popf
    mov ds, word ptr cs:[MainDataSegment]
    jne @@mismatch
    ret
@@mismatch:
    cmp word ptr cs:[IntegritySkip], 1
    jne @@reportCorrupt
    ret
@@reportCorrupt:
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
@@xorCopyByte:
    xor byte ptr ds:[si], 0AAh
    movsb
    loop @@xorCopyByte
    ret

; Reads and discards keys through INT 16h until the BIOS queue is empty.
DrainBiosKeysInt16:
    mov ah, 1
    int 016h
    je @@empty
    xor ah, ah
    int 016h
    jmp short DrainBiosKeysInt16
@@empty:
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
    jae @@checkAboveZ
    ret
@@checkAboveZ:
    cmp al, 05Ah
    jbe @@toLower
    ret
@@toLower:
    or al, 020h
    ret
; Print which sound module loaded (SoundCardCaption*) and wait 0AFh frames. No caller
; found in this image.
ShowSoundCardCaption:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    je @@done
    mov ax, ds:[SoundModuleNamePtr]
    mov bp, offset SoundCardCaptionAdlib
    cmp ax, offset SoundModuleNameAdlib
    je @@printCaption
    mov bp, offset SoundCardCaptionTandy
    cmp ax, offset SoundModuleNameTandy
    je @@printCaption
    mov bp, offset SoundCardCaptionRoland
    cmp ax, offset SoundModuleNameRoland
    je @@printCaption
    jmp short @@done
@@printCaption:
    call PrintMessageBP
    mov cx, 0AFh
@@waitFrame:
    call WaitVerticalRetrace
    loop @@waitFrame
@@done:
    ret

; Load and initialize the optional sound module named by SoundModuleSelect ('t', 'r',
; 'a'; FFh tries tandy, roland, then adlib) into SOUND_MODULE_SEGMENT. On success sets
; SoundModuleLoaded and falls into RequestModuleMusic with AL = MUSIC_TITLE.
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
    mov al, MUSIC_TITLE

; Music seam: AL = MUSIC_* tune. Written into the loaded module's header word
; MODULE_MUSIC_REQUEST unless it is already MODULE_MUSIC_CURRENT; the module's own
; timer tick picks it up.
RequestModuleMusic:
    mov byte ptr ds:[ModuleSoundRequest], al
    cmp byte ptr ds:[ModuleSoundEnabled], 0
    je @@done
    xor ah, ah
    mov bx, seg SoundModuleSlot
    mov es, bx
    cmp al, byte ptr es:[MODULE_MUSIC_CURRENT]
    je @@done
    mov word ptr es:[MODULE_MUSIC_REQUEST], ax
    mov ds, word ptr cs:[MainDataSegment]
@@done:
    ret

; With a sound module loaded: MODULE_MUSIC_REQUEST = FFh, then waits five timer ticks so
; the module sees it. ES = module segment.
StopModuleMusic:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne @@sendStop
    ret
@@sendStop:
    mov ax, seg SoundModuleSlot
    mov es, ax
    mov word ptr es:[MODULE_MUSIC_REQUEST], 0FFh
    mov cx, 5
@@waitTick:
    push cx
    call WaitTimerInterruptIfModule
    pop cx
    loop @@waitTick
    mov ds, word ptr cs:[MainDataSegment]
    ret
; Store AL at the module's MODULE_BYTE_0A. No caller found in this image.
SetModuleByte0A:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne @@store
    ret
@@store:
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
    jne @@store
    ret
@@store:
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
    jae @@decode
    mov dx, word ptr ds:[FileNamePtr]
    xor al, al
    mov ah, DOS_OPEN_FILE
    int 021h
    jb @@failed
@@decode:
    mov word ptr cs:[EncFileHandle], ax
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[EncDestSegment], seg SoundModuleSlot
    mov word ptr cs:[EncDestOffset], 0
    call DecodeEncFile
    jb @@failed
    or al, 1
    ret
@@failed:
    xor al, al
    ret

; With a sound module loaded, waits for one INT 08h tick (TimerTickPhase change).
WaitTimerInterruptIfModule:
    cmp byte ptr ds:[SoundModuleLoaded], 0
    jne @@waitTick
    ret
@@waitTick:
    mov al, byte ptr ds:[TimerTickPhase]
@@pollTick:
    cmp al, byte ptr ds:[TimerTickPhase]
    je @@pollTick
    ret
; Unreferenced zero byte between routines.
UnusedByte3655 db 00h

; Title animation, then the bonus pages and demo unless a key ended it.
RunAttractSequence:
    call PlayTitleAnimation
    call ResetPageAndClearScreen
    call CgaSelectBrightPalette1
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne @@pause
    call RunIntroPagesAndDemo
@@pause:
    mov cx, 01Eh
@@waitFrame:
    call WaitVerticalRetrace
    loop @@waitFrame
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
    jne @@done
    mov cx, 01Eh
    call DelayFramesUntilKeyOrPrimary
    mov word ptr ds:[TitleLogoPiecePtr], offset TitleLogoPieces
    call StageTitleLogoPieces
    call RevealTitleLogoCells
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne @@done
    call StageTitleLogoPieces
    call RevealTitleLogoCells
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne @@done
    call StageTitleLogoPieces
    call RevealTitleLogoCells
    mov cx, 032h
    call DelayFramesUntilKeyOrPrimary
@@done:
    ret

; Copies the changed 8-pixel cells of the five TitleRevealRects from the staging page
; (workspace + 7D00h) to the screen with a flash and sfx.
RevealTitleLogoCells:
    mov word ptr ds:[RevealRectPtr], offset TitleRevealRects
    mov cx, 5
NextRect:
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
NextRow:
    push cx
    push word ptr ds:[RevealCol]
    mov cx, word ptr ds:[RevealColumns]
RevealCellLoop:
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
@@compareRow:
    mov ax, word ptr es:[si]
    cmp ax, word ptr es:[di]
    je @@nextRow
    mov dl, 1
    mov word ptr es:[di], ax
@@nextRow:
    add di, 050h
    add si, 050h
    loop @@compareRow
    jmp short RevealCellMerged

MergeRevealCellTandy:
    mov cx, 8
@@compareRow:
    mov ax, word ptr es:[si]
    cmp ax, word ptr es:[di]
    je @@compareSecondWord
    mov dl, 1
    mov word ptr es:[di], ax
@@compareSecondWord:
    mov ax, word ptr es:[si + 2]
    cmp ax, word ptr es:[di + 2]
    je @@nextRow
    mov dl, 1
    mov word ptr es:[di + 2], ax
@@nextRow:
    add di, 0A0h
    add si, 0A0h
    loop @@compareRow
    jmp short RevealCellMerged

MergeRevealCellEga:
    mov cx, 020h
@@compareRow:
    mov al, byte ptr es:[si]
    cmp al, byte ptr es:[di]
    je @@nextRow
    mov dl, 1
    mov byte ptr es:[di], al
@@nextRow:
    add di, 028h
    add si, 028h
    loop @@compareRow
RevealCellMerged:
    or dl, dl
    jne @@cellChanged
    jmp near ptr RevealNextColumn
@@cellChanged:
    cmp word ptr ds:[RevealRectsLeft], 4
    je @@firstRectSfx
    cmp byte ptr ds:[SfxEnabled], 0
    je @@flash
    cmp byte ptr ds:[SfxEnabled], 0
    je @@sfxChosen
    mov byte ptr ds:[SfxRequest], 0Eh
@@sfxChosen:
    jmp short @@flash
@@firstRectSfx:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@flash
    mov byte ptr ds:[SfxRequest], 0Ah
@@flash:
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
    je @@showCell
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne @@showCell
    call WaitVerticalRetrace
@@showCell:
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
@@copyRow:
    mov ax, word ptr ds:[si]
    mov word ptr es:[di], ax
    add si, 050h
    add di, 02000h
    test di, 04000h
    je @@nextRow
    add di, 0C050h
@@nextRow:
    loop @@copyRow
    jmp short RevealCellShown

ShowRevealCellTandy:
    mov cx, 8
@@copyRow:
    mov ax, word ptr ds:[si]
    mov word ptr es:[di], ax
    mov ax, word ptr ds:[si + 2]
    mov word ptr es:[di + 2], ax
    add si, 0A0h
    add di, 02000h
    test di, 08000h
    je @@nextRow
    add di, 080A0h
@@nextRow:
    loop @@copyRow
    jmp short RevealCellShown

ShowRevealCellEga:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov cx, 8
@@copyRow:
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
    loop @@copyRow
RevealCellShown:
    mov ds, word ptr cs:[MainDataSegment]
RevealNextColumn:
    inc byte ptr ds:[RevealCol]
    pop cx
    loop @@continueColumns
    jmp short @@rowDone
@@continueColumns:
    jmp near ptr RevealCellLoop
@@rowDone:
    pop word ptr ds:[RevealCol]
    add byte ptr ds:[RevealRow], 8
    pop cx
    loop @@continueRows
    jmp short @@rectDone
@@continueRows:
    jmp near ptr NextRow
@@rectDone:
    cmp word ptr ds:[RevealRectsLeft], 5
    je @@nextRectCount
    mov cx, 0Ah
    call DelayFramesUntilKeyOrPrimary
@@nextRectCount:
    pop cx
    loop @@continueRects
    jmp short @@allRectsDone
@@continueRects:
    jmp near ptr NextRect
@@allRectsDone:
    mov cx, 050h
    call DelayFramesUntilKeyOrPrimary
    ret

; Wait up to CX frames. A make code or the primary button (recorded as a Space make
; code) ends it early and stays visible in KeyLastMakeCode for the caller.
DelayFramesUntilKeyOrPrimary:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je @@pollFrame
    ret
@@pollFrame:
    push cx
    call PollInputBits
    pop cx
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@waitFrame
    mov byte ptr ds:[KeyLastMakeCode], SCAN_SPACE
@@waitFrame:
    call WaitVerticalRetrace
    loop DelayFramesUntilKeyOrPrimary
    ret

; Blits the next five TitleLogoPieces into the staging page (workspace + 7D00h).
StageTitleLogoPieces:
    mov cx, 5
@@nextPiece:
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
    loop @@nextPiece
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
@@drawStrip:
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
    loop @@drawStrip
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
@@nextItem:
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
@@waitFrame:
    call WaitVerticalRetrace
    push cx
    call PollInputBits
    pop cx
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@interrupted
    cmp byte ptr ds:[KeyLastMakeCode], 0
    jne @@interrupted
    loop @@waitFrame
    pop si
    inc si
    pop cx
    loop @@nextItem
    jmp short @@startDemo
@@interrupted:
    pop si
    pop cx
    jmp near ptr @@exitDemo
@@startDemo:
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
; Demo: every tile attribute 0 (open).
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
@@demoFrame:
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
    je @@exitDemo
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@exitDemo
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je @@demoFrame
@@exitDemo:
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
    jb @@stepAction
    cmp word ptr ds:[DemoStepTimer], 014h
    jb @@stepAction
    mov byte ptr ds:[InputBits], 0
    inc word ptr ds:[DemoFireCycle]
    cmp word ptr ds:[DemoFireCycle], 014h
    jb @@checkFireFrame
    mov word ptr ds:[DemoFireCycle], 0
@@checkFireFrame:
    cmp word ptr ds:[DemoFireCycle], 0Fh
    je @@pressFire
    cmp word ptr ds:[DemoFireCycle], 011h
    je @@pressFire
    cmp word ptr ds:[DemoFireCycle], 013h
    jne @@handleFire
@@pressFire:
    mov byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
@@handleFire:
    mov bp, offset PrimaryRecord
    mov word ptr ds:[FireLatch], 0
    call HandleFireButton
@@stepAction:
    cmp word ptr ds:[DemoStep], 0
    jne DemoCountDownStep
    jmp near ptr DemoRiseShipToY60
DemoCountDownStep:
    dec word ptr ds:[DemoStepTimer]
    je @@nextStep
    ret
@@nextStep:
    mov word ptr ds:[DemoStepTimer], 064h
    inc word ptr ds:[DemoStep]
    mov bx, word ptr ds:[DemoStep]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov ax, word ptr ds:[bx + DemoScript + 2]
    cmp ax, 0FFFFh
    je @@dispatchStep
    mov word ptr ds:[SelectedUpgradeSlot], ax
    mov ax, word ptr ds:[bx + DemoScript + 4]
    mov word ptr ds:[DemoUpgradeStatus], ax
    call DrawUpgradeSlots
@@dispatchStep:
    mov bx, word ptr ds:[DemoStep]
    shl bx, 1
    jmp word ptr cs:[bx + DemoStepActions]
DemoStepActions label word
    dw offset CountXReturn, offset DemoStepLaunchFrontPod, offset DemoStepLaunchInnerSidePods, offset DemoStepNextShipForm
    dw offset DemoStepLaunchOuterSidePods, offset DemoStepNextShipForm, offset DemoStepLaunchTrailingPodNear, offset DemoStepLaunchTrailingPodFar
    dw offset CountXReturn, offset CountXReturn, offset DemoStepNextWeaponMode, offset DemoStepEnableSideShots
    dw offset DemoStepNextWeaponMode, offset DemoStepNextWeaponMode, offset DemoStepNextWeaponMode, offset DemoStepNextWeaponMode
    dw offset DemoStepSpawnPathEnemy51, offset DemoStepGiveMissile, offset CountXReturn, offset CountXReturn
; Uses BX without checking for FFFFh (pool A full).
DemoStepSpawnPathEnemy51:
    call SpawnEnemyHere
    mov word ptr ds:[bx + REC_X], PLAYFIELD_MAX_X
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
    jne @@rise
    jmp near ptr DemoCountDownStep
@@rise:
    dec word ptr ds:[PrimaryRecord + REC_Y]
    mov bp, offset PrimaryRecord
    call StoreApplyHistoryAndConditionalPlacement
    cmp word ptr ds:[PrimaryRecord + REC_Y], 060h
    je @@arrived
    ret
@@arrived:
    mov word ptr ds:[DemoStepTimer], 032h
    ret
DemoStepNextShipForm:
    inc word ptr ds:[PrimaryRecord + REC_SPRITE]
    cmp byte ptr ds:[SfxEnabled], 0
    je @@setTimer
    mov byte ptr ds:[SfxRequest], 6
@@setTimer:
    mov word ptr ds:[DemoStepTimer], 032h
    mov bp, offset PrimaryRecord
    jmp near ptr PlaceSidePods
; Uses BX without checking for FFFFh (pool A full).
DemoStepLaunchFrontPod:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@launch
    mov byte ptr ds:[SfxRequest], 01Eh
@@launch:
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
    je @@launch
    mov byte ptr ds:[SfxRequest], 1Eh
@@launch:
    call AddTrailingPod
    mov bp, ds:[TrailingPodNear]
    call DemoLaunchTrailingPod
    mov word ptr ss:[bp + REC_X], 0
    ret
DemoStepLaunchTrailingPodFar:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@launch
    mov byte ptr ds:[SfxRequest], 1Eh
@@launch:
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
    je @@launch
    mov byte ptr ds:[SfxRequest], 01Eh
@@launch:
    call AddSidePods
    mov bp, word ptr ds:[SidePodLeftInner]
    call DemoLaunchPod
    mov word ptr ss:[bp + REC_X], 0
    mov bp, word ptr ds:[SidePodRightInner]
    jmp short DemoLaunchPod
DemoStepLaunchOuterSidePods:
    cmp byte ptr ds:[SfxEnabled], 0
    je @@launch
    mov byte ptr ds:[SfxRequest], 1Eh
@@launch:
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
    mov word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    mov word ptr ss:[bp + REC_TYPE], 050h
    mov word ptr ss:[bp + REC_KIND], KIND_ENEMY
    ret
; Steers to REC_SAVED; on arrival becomes KIND_POD (sfx 0Eh). Returns with a bare ret:
; never reaches FinishRecordUpdate (no clamp, bounds or collision checks).
Type50SteerHomeThenBecomePod:
    mov ax, word ptr ss:[bp + REC_SAVED_X]
    mov word ptr ds:[SteerTargetX], ax
    mov ax, word ptr ss:[bp + REC_SAVED_Y]
    mov word ptr ds:[SteerTargetY], ax
    mov word ptr ds:[SteerSpeed], 1
    call SteerTowardTarget
    mov word ptr ds:[SteerSpeed], 2
    cmp word ptr ds:[SteerArrived], 0
    jne @@arrived
    ret
@@arrived:
    mov word ptr ss:[bp + REC_KIND], KIND_POD
    cmp byte ptr ds:[SfxEnabled], 0
    je @@done
    mov byte ptr ds:[SfxRequest], 0Eh
@@done:
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

; Level intro: the plaque over the moving starfield for up to 200 frames or until the
; primary button. Runs when a life starts at the level start (MAP_START_POS), not at a
; later checkpoint.
ShowLevelIntro:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne ShowLevelIntro
    call CopyWorkspaceToScreen
    mov word ptr ds:[LevelIntroFrames], 0
@@frame:
    call ClearTimerTick
    call FlipEgaDrawPage
    call DrawStars
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne @@drawPlaque
    call CopyWorkspaceToScreen
@@drawPlaque:
    call DrawPlaqueImage
    call EraseStars
    call far ptr MoveStars
    call CheckBossKey
    call UpdateRefuelTimersAndScore
    call ShowEgaDrawPage
    call WaitTimerTick
    call WaitVerticalRetrace
    inc word ptr ds:[LevelIntroFrames]
    cmp word ptr ds:[LevelIntroFrames], 0C8h
    ja @@waitRelease
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@frame
@@waitRelease:
    call PollInputBits
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@waitRelease
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
@@frame:
    call ClearTimerTick
    call FlipEgaDrawPage
    call DrawChooseScreen
    call ShowEgaDrawPage
    call WaitVerticalRetrace
    call ReadChooseScreenInput
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@chosen
    call WaitTimerTick
    jmp short @@frame
@@chosen:
    mov ax, word ptr ds:[ChooseSlot]
    inc ax
    cmp ax, 6
    jne @@storeLevel
    xor ax, ax
@@storeLevel:
    dec ax
    mov word ptr ds:[LevelIndex], ax
    ret

; Move the 2x3 selection in ChooseSlot with the directions and cycle DifficultySetting (0..2) with
; the D key; return on the primary button.
ReadChooseScreenInput:
    cmp byte ptr ds:[KeyDownTable + SCAN_D], KEY_STATE_DOWN
    je ReadChooseScreenInput
@@waitRelease:
    call PollInputBits
    cmp byte ptr ds:[InputBits], 0
    jne @@waitRelease
@@poll:
    cmp byte ptr ds:[KeyDownTable + SCAN_D], KEY_STATE_DOWN
    je @@cycleDifficulty
    call PollInputBits
    mov al, byte ptr ds:[ChooseSlot]
    test byte ptr ds:[InputBits], IN_XPLUS
    jne @@moveRight
    test byte ptr ds:[InputBits], IN_XMINUS
    jne @@moveLeft
    test byte ptr ds:[InputBits], IN_YMINUS
    jne @@moveUp
    test byte ptr ds:[InputBits], IN_YPLUS
    jne @@moveDown
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@poll
    ret
@@moveRight:
    cmp al, 3
    jae @@poll
    add al, 3
@@storeSlot:
    mov byte ptr ds:[ChooseSlot], al
    ret
@@moveLeft:
    cmp al, 2
    jbe @@poll
    sub al, 3
    jmp short @@storeSlot
@@moveUp:
    or al, al
    je @@poll
    dec al
    jmp short @@storeSlot
@@moveDown:
    cmp al, 5
    je @@poll
    inc al
    jmp short @@storeSlot
@@cycleDifficulty:
    inc word ptr ds:[DifficultySetting]
    cmp word ptr ds:[DifficultySetting], 3
    jb @@done
    mov word ptr ds:[DifficultySetting], 0
@@done:
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
; Unreferenced zero byte between routines.
UnusedByte3F7B db 00h

; Called every timer tick. Starts a pending SfxRequest, advances both voices, then
; programs the speaker from voice A on even ticks and voice B on odd ones. A silent
; voice leaves the speaker playing whatever was programmed last.
; SfxActive is tested once, before both voices tick: if voice A's END stops the effect,
; voice B still ticks and may sound, and the speaker then stays on until the next effect.
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
; Commands 82h/83h: step the note down/up one semitone per tick. The step persists for
; later notes until the next effect starts; a note held d ticks is stepped d - 1 times.
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
; Unreferenced zero byte before the payment-text variables.
UnusedByte40CD db 00h
; Text screen segment for ShowPaymentText (B800h colour, B000h mono).
TextScreenSegment dw 0
; First line shown and number of lines of the text file.
TextTopLine dw 0
TextLineCount dw 0
; DOS handle of the open ENC file (DecodeEncFile, ShowPaymentText).
EncFileHandle dw 0
; Show payment.enc in text mode, scrollable. No caller found in this image.
; Leaves text mode with the cursor hidden; returns on Esc; a missing payment.enc off A:/B:
; goes to ShutdownWithError.
ShowPaymentText:
    mov ax, 3
    int 10h
    mov cx, 2000h
    mov ah, 1
    int 10h
    mov word ptr cs:[TextScreenSegment], 0B800h
    call ProbeMonoHercules
    je @@openFile
    mov word ptr cs:[TextScreenSegment], 0B000h
@@openFile:
    mov dx, offset PaymentFileName
    mov ds:[FileNamePtr], dx
    xor al, al
    mov ah, 3Dh
    call far ptr OpenResourceFile
    jae @@decode
    mov ah, 19h
    int 21h
    cmp al, 2
    jb @@openFile
    jmp near ptr ShutdownWithError
@@decode:
    mov cs:[EncFileHandle], ax
    mov ax, cs:[WorkspaceSegment]
    mov cs:[EncDestSegment], ax
    mov word ptr cs:[EncDestOffset], 0
    call DecodeEncFile
    jae @@countLines
    jmp near ptr PaymentTextWaitEscRelease
@@countLines:
    mov word ptr cs:[TextTopLine], 0
    mov word ptr cs:[TextLineCount], 1
    mov es, cs:[WorkspaceSegment]
    xor si, si
@@scanByte:
    lods byte ptr es:[si]
    cmp al, 1Ah
    je PaymentTextRedraw
    cmp al, 0Dh
    jne @@scanByte
    inc word ptr cs:[TextLineCount]
    jmp short @@scanByte
PaymentTextRedraw:
    call DrawPaymentTextPage
PaymentTextPollKeys:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne @@checkNavKeys
    jmp near ptr PaymentTextWaitEscRelease
@@checkNavKeys:
    cmp byte ptr ds:[KeyDownTable + SCAN_HOME], KEY_STATE_DOWN
    je @@homeKey
    cmp byte ptr ds:[KeyDownTable + SCAN_END], KEY_STATE_DOWN
    je @@endKey
    cmp byte ptr ds:[KeyDownTable + SCAN_UP], KEY_STATE_DOWN
    je @@lineUp
    cmp byte ptr ds:[KeyDownTable + SCAN_DOWN], KEY_STATE_DOWN
    je PaymentTextLineDown
    cmp byte ptr ds:[KeyDownTable + SCAN_PGUP], KEY_STATE_DOWN
    je @@pageUp
    cmp byte ptr ds:[KeyDownTable + SCAN_PGDN], KEY_STATE_DOWN
    je @@pageDown
    jmp short PaymentTextPollKeys
@@homeKey:
    mov bp, 0FFFFh
@@homeStep:
    call PaymentTextScrollUp
    dec bp
    jne @@homeStep
    jmp short PaymentTextRedraw
@@endKey:
    mov bp, 0FFFFh
@@endStep:
    call PaymentTextScrollDown
    dec bp
    jne @@endStep
    jmp short PaymentTextRedraw
@@pageUp:
    call WaitTextRetrace4
    call WaitTextRetrace4
    mov bp, 17h
@@pageUpStep:
    call PaymentTextScrollUp
    dec bp
    jne @@pageUpStep
    jmp short PaymentTextRedraw
@@pageDown:
    call WaitTextRetrace4
    call WaitTextRetrace4
    mov bp, 17h
@@pageDownStep:
    call PaymentTextScrollDown
    dec bp
    jne @@pageDownStep
    jmp short PaymentTextRedraw
@@lineUp:
    call PaymentTextScrollUp
    jcxz PaymentTextPollKeys
    jmp short PaymentTextRedraw
; TextTopLine - 1 when above 0; CX = 1 if it scrolled.
PaymentTextScrollUp:
    xor cx, cx
    cmp word ptr cs:[TextTopLine], 0
    je @@done
    dec word ptr cs:[TextTopLine]
    inc cx
@@done:
    ret
PaymentTextLineDown:
    call PaymentTextScrollDown
    jcxz @@paymentLineDownUnchanged
    jmp short @@paymentLineDownRedraw
@@paymentLineDownUnchanged:
    jmp near ptr PaymentTextPollKeys
@@paymentLineDownRedraw:
    jmp near ptr PaymentTextRedraw
; TextTopLine + 1 while a page remains below; CX = 1 if it scrolled.
PaymentTextScrollDown:
    xor cx, cx
    mov ax, cs:[TextTopLine]
    inc ax
    add ax, 18h
    cmp ax, cs:[TextLineCount]
    jae @@done
    inc word ptr cs:[TextTopLine]
    inc cx
@@done:
    ret
; Writes PaymentHelpRow and 24 text lines from TextTopLine to TextScreenSegment.
DrawPaymentTextPage:
    mov es, cs:[WorkspaceSegment]
    xor di, di
    mov dx, cs:[TextTopLine]
    or dx, dx
    je @@copyText
@@skipLine:
    mov cx, 0FFFFh
    mov al, 0Dh
    repne scasb
    cmp byte ptr es:[di], 0Ah
    jne @@lineSkipped
    inc di
@@lineSkipped:
    dec dx
    jne @@skipLine
@@copyText:
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
@@nextChar:
    or bp, bp
    je @@pageDone
    lodsb
    cmp al, 1Ah
    je @@pageDone
    cmp al, 9
    je @@tab
    cmp al, 0Dh
    je @@carriageReturn
    mov ah, 1Bh
    stosw
    inc dx
    cmp dx, 50h
    jne @@nextChar
    xor dx, dx
    dec bp
    jmp short @@nextChar
@@tab:
    mov al, 20h
    mov ah, 1Bh
    test dx, 7
    je @@fullTab
@@padToTabStop:
    stosw
    inc dx
    test dx, 7
    jne @@padToTabStop
    jmp short @@tabDone
@@fullTab:
    cmp dx, 50h
    je @@tabDone
    add dx, 8
    mov cx, 8
    rep stosw
@@tabDone:
    jmp short @@nextChar
@@carriageReturn:
    cmp byte ptr ds:[si], 0Ah
    jne @@padLine
    inc si
@@padLine:
    cmp dx, 50h
    je @@emptyLineWrap
    mov al, 20h
    mov ah, 1Bh
@@padChar:
    stosw
    inc dx
    cmp dx, 50h
    jne @@padChar
    xor dx, dx
    dec bp
    jmp short @@nextChar
@@emptyLineWrap:
    add di, 0A0h
    xor dx, dx
    dec bp
    jmp short @@nextChar
@@pageDone:
    mov ds, cs:[MainDataSegment]
    push dx
    push bp
    call WaitTextRetrace4
    pop bp
    pop dx
    ret
PaymentTextWaitEscRelease:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je PaymentTextWaitEscRelease
    ret
WaitTextRetrace4:
    mov cx, 4
@@waitRetrace:
    call WaitTextVerticalRetrace
    loop @@waitRetrace
    ret
; Colour (3DAh bit 3) or Hercules (3BAh bit 7) retrace by TextScreenSegment.
WaitTextVerticalRetrace:
    mov dx, 3DAh
    mov ah, 8
    cmp word ptr cs:[TextScreenSegment], 0B800h
    je @@waitRetraceStart
    mov dx, 3BAh
    mov ah, 80h
@@waitRetraceStart:
    in al, dx
    and al, ah
    je @@waitRetraceStart
@@waitRetraceEnd:
    in al, dx
    and al, ah
    jne @@waitRetraceEnd
    ret
; NZ when a CRTC answers at 3B4h and 3BAh bit 7 toggles (Hercules). A plain MDA returns
; ZF, so ShowPaymentText then writes to B800h.
ProbeMonoHercules:
    mov dx, 3B4h
    call ProbeCrtcAtDX
    je @@done
    mov dx, 3BAh
    in al, dx
    and al, 80h
    mov ah, al
    mov cx, 8000h
@@watchBit:
    in al, dx
    and al, 80h
    cmp ah, al
    loope @@watchBit
    mov al, 1
    jne @@done
    mov al, 0
@@done:
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
@@settle:
    loop @@settle
    in al, dx
    xchg ah, al
    out dx, al
    cmp ah, 66h
    je @@setFlags
    xor ax, ax
@@setFlags:
    and ax, ax
    ret
; ENC (LZSS) input buffer, refilled 400h bytes at a time from EncFileHandle.
EncReadBuffer db 0400h dup (0)
; LZSS ring buffer: 4096 bytes, first write at 0FEEh. Only [0, 0FEEh) is cleared per file:
; the last 18 bytes keep the previous ENC file's output.
EncRingBuffer db 01000h dup (0)
; LZSS allocation slack: the ring is sized N + F - 1 (4096 + 18 - 1), but
; DecodeEncFile wraps its index at 4096, so these 17 bytes are never touched.
EncRingBufferSlack db 00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h

; Decode the ENC file open on EncFileHandle to EncDestSegment:EncDestOffset, then close
; it. LZSS: flag bytes LSB first, 1 = literal, 0 = pair b0, b1: copy (b1 & 0Fh) + 3 bytes
; from ring[b0 | (b1 & F0h) << 4]. Pair 0, 0 then byte 0 ends; pair 0, 0 then a nonzero X
; is an ordinary 3-byte copy from ring 0, and X is read again as the next input byte. EncOutputBytes counts the output; DS preserved.
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
    jb @@done
    call DecodeEncStream
    mov ax, 03E00h
    mov bx, word ptr cs:[EncFileHandle]
    int 021h
    clc
@@done:
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
@@clearRing:
    mov word ptr cs:[bp + EncRingBuffer], 0
    inc bp
    inc bp
    loop @@clearRing
    mov bp, 0FEEh
    mov dx, 0
@@nextToken:
    shr dx, 1
    test dx, 0100h
    jne @@checkFlag
    call ReadEncByte
    mov dl, al
    mov dh, 0FFh
@@checkFlag:
    test dx, 1
    je @@backReference
    call ReadEncByte
    call StoreEncByte
    mov byte ptr cs:[bp + EncRingBuffer], al
    inc bp
    and bp, 0FFFh
    jmp short @@nextToken
@@backReference:
    call ReadEncByte
    mov ah, al
    call ReadEncByte
    xchg al, ah
    cmp ax, 0
    jne @@copyMatch
    call ReadEncByte
    cmp al, 0
    je @@done
    call PushBackEncByte
    mov al, 0
@@copyMatch:
    mov cl, ah
    shr ah, 1
    shr ah, 1
    shr ah, 1
    shr ah, 1
    and cl, 0Fh
    mov bx, ax
    add cl, 3
@@copyMatchByte:
    mov al, byte ptr cs:[bx + EncRingBuffer]
    call StoreEncByte
    mov byte ptr cs:[bp + EncRingBuffer], al
    inc bx
    and bx, 0FFFh
    inc bp
    and bp, 0FFFh
    loop @@copyMatchByte
    jmp short @@nextToken
@@done:
    pop es
    ret

; Next input byte in AL (the pushed-back byte first), refilling EncReadBuffer from the
; file every 400h bytes. SI = buffer position; flags preserved across the refill.
ReadEncByte:
    test byte ptr cs:[EncPushback], 0FFh
    jne @@takePushback
    add si, offset EncReadBuffer
    lodsb
    sub si, offset EncReadBuffer
    and si, 03FFh
    jne @@done
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
@@done:
    ret
@@takePushback:
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
    jne @@count
    push ax
    mov ax, es
    add ax, 01000h
    mov es, ax
    pop ax
@@count:
    inc word ptr cs:[EncOutputBytes]
    jne @@done
    inc word ptr cs:[EncOutputBytesHigh]
@@done:
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
; In handler comments "destroyed" means DestroyRecord (explosion, score, sfx 19h, drop),
; never a silent removal; a `jmp DestroyRecord` skips the finish tail that frame.
TypeHandlers label word
    dw offset ScrollRecordThenFinish, offset Type01ExplosionAnimation, offset Type02TimedStraightShot, offset Type02TimedStraightShot
    dw offset Type04StraightShot, offset Type05SideShotUpLeft, offset Type06SideShotUpRight, offset Type07RisingShot3
    dw offset Type08RisingShot16, offset Type09BeamLink, offset Type0AHomingMissile, offset Type0BAimedEnemyShot
    dw offset Type0CTimedTurnUpShot, offset ScrollRecordThenFinish, offset ScrollRecordThenFinish, offset Type0FTimedShot2
    dw offset Type10StartPathFollowerA, offset Type11StartPathFollowerB, offset Type12WaypointPathFollower, offset Type13FormationLeader
    dw offset Type14FormationSwayDiver, offset Type13FormationLeader, offset Type16SweepLeadIn, offset Type16SweepLeadIn
    dw offset Type18SweepPathLooper, offset Type19WallPatrolShooter, offset Type1AWallPatrolA, offset Type1BWallPatrolB
    dw offset Type13FormationLeader, offset Type1DSlotBobThenChase, offset Type1EShuttleShooter, offset Type13FormationLeader
    dw offset Type20SlotHopperDropper, offset Type21EncounterDirector, offset Type22DescendThenBurst, offset Type23ColumnFaller
    dw offset Type24TurretLeftFire32, offset Type25TurretRightFire32, offset Type26TurretRemnant, offset Type27SlowDescender
    dw offset Type28EnemyHatch, offset Type29EmergeThenDart, offset Type28EnemyHatch, offset Type2BAimedDart
    dw offset Type2CAimedDrifter, offset Type2DHoverFireThenPlunge, offset Type2EPlungeAtPlayerColumn, offset Type2FScrollingShuttle
    dw offset Type30AnimatedShooter, offset Type31FallFast3, offset Type32DescendThenBounce, offset Type33TerrainBouncer
    dw offset Type34SideFiringTurret, offset Type22DescendThenBurst, offset Type36FallThenBurst, offset Type37VerticalBouncerShooter
    dw offset Type38WallBounceDescend, offset Type39DashRightAtRow80, offset Type3AHomeOnPlayerBelow80, offset Type3BFallRandomFlicker
    dw offset Type3CDescendThenBounceAlt, offset Type3DAnimatedTerrainBouncer, offset Type3EDropThenAimedDash, offset Type3FFlyAlongAimLine
    dw offset Type40JitterFallShooter, offset Type41FollowPathType41, offset Type42DescendSway, offset Type43FollowPathType43
    dw offset Type44FollowPathType44, offset Type45FollowPathType45, offset Type46HoverShootThenDive, offset Type47PatrolShootDown32B
    dw offset Type48DescendAimedFire, offset Type49RadialBurstFaller, offset Type4AFollowPathType4A, offset Type4BDescendThenBounceUpRight
    dw offset Type4CSinkThenRise, offset Type4DSinkRiseThenDash, offset Type4EAnimDescendThenBounce, offset Type4FFallFast4Flicker
    dw offset Type50SteerHomeThenBecomePod, offset Type51FollowType51Path, offset Type52ScrollOnly, offset Type53AnimateFromSpriteBase
    dw offset Type54ScrollUntilY_B0ThenType56, offset Type55DropFrom_B0, offset Type56CrawlDestroyOnBlock, offset Type57ScrollToY80ThenCrawl
    dw offset Type57ScrollToY80ThenCrawl, offset Type59ScrollThenAnimateThenType5A, offset Type5ACrawlMirrorDiagonal, offset Type5BScrollPastY_B0ThenType5C
    dw offset Type5CRiseFast4, offset Type5DDropFast8, offset Type5ECrawlTurnDownToLeft, offset Type5FCrawlTurnDiagonalDown
    dw offset Type60FlyAlongAimLine, offset Type61InvaderSteerToSlot, offset Type62InvaderMarch, offset Type63ScriptedSlideThenDrop
    dw offset Type64Drop4, offset Type65InvaderDiveFiring, offset Type66FollowPathType66, offset Type67FollowPathType67
    dw offset Type68JitterDescendFiring, offset Type69JitterBelowY18, offset Type6AScrollUntilY50ThenType56, offset Type6BDescendToX50
    dw offset Type6CDescendToX60Firing, offset Type6DDescendToX70, offset Type6ECrawlStaircase, offset Type6FWaitThenType70
    dw offset Type70CruiseFiring, offset Type71FireThenDiveBelow60, offset Type72DescendFiringAimed, offset Type73WaitThenRunRight
    dw offset Type74WaitThenRunLeft, offset Type75DescendSpreadShot, offset Type76SegBossPart0, offset Type77SegBossPart1
    dw offset Type78SegBossCore, offset Type79SegBossPart3, offset Type7AAimLineFlyer, offset Type7BDropThenAim
    dw offset Type7CAimLineFlyerAlt, offset Type13FormationLeader, offset Type13FormationLeader, offset Type7FMarchEnterSteer
    dw offset Type80MarchFormationMember, offset Type81SweeperEnterSteer, offset ScrollRecordThenFinish, offset Type83PatrolShootDown64
    dw offset Type84LurkUntilAligned, offset Type85ChargeUntilBlocked, offset Type86LaunchAimedEnemy, offset Type87AnimFireBurstA
    dw offset Type88WaitThenFireBurst, offset Type89PatrolShootDown32, offset Type8APatrolShootDown32Alt, offset Type8BClimbWalkerA
    dw offset Type8CClimbWalkerAFlipped, offset Type8DClimbWalkerB, offset Type8EClimbWalkerBFlipped, offset Type8FAnimFireBurstB
    dw offset Type90TurretVolley, offset Type91TurretVolleyAlt, offset Type92FireWhenPlayerOnRow, offset Type93SweepDescendClimb
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
    je @@setSprite
    mov si, offset Type86Frames
@@setSprite:
    mov ax, bx
    mov bx, ds:[bx + si]
    mov ss:[bp + REC_SPRITE], bx
    cmp ax, 4
    je @@checkLaunchFrame
    jmp near ptr ScrollRecordThenFinish
@@checkLaunchFrame:
    cmp word ptr ds:[FrameCount64], 26h
    je @@launch
    jmp near ptr ScrollRecordThenFinish
@@launch:
    call SpawnEnemyHere
    cmp bx, -1
    jne @@aim
    jmp near ptr ScrollRecordThenFinish
@@aim:
    call AimAtPlayer
    mov word ptr ds:[bx + REC_SPRITE], 0CBh
    mov word ptr ds:[bx + REC_TYPE], 60h
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 80h, then fires a burst in animation phase 2.
Type88WaitThenFireBurst:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae @@animate
    jmp near ptr ScrollRecordThenFinish
@@animate:
    mov bx, ds:[FrameCount64]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shl bx, 1
    mov si, offset Type88FramesDir6
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    je @@setSprite
    mov si, offset Type88Frames
@@setSprite:
    mov ax, bx
    mov bx, ds:[bx + si]
    mov ss:[bp + REC_SPRITE], bx
    cmp ax, 4
    je @@fireBurst
    jmp near ptr ScrollRecordThenFinish
@@fireBurst:
    call SpawnThrottledChild
    jmp near ptr ScrollRecordThenFinish
; Scrolls until Y is exactly 50h, then continues as type 56h.
Type6AScrollUntilY50ThenType56:
    cmp word ptr ss:[bp + REC_Y], 50h
    je @@becomeCrawler
    jmp near ptr ScrollRecordThenFinish
@@becomeCrawler:
    mov word ptr ss:[bp + REC_TYPE], 56h
    jmp short Type56CrawlDestroyOnBlock
; Scrolls until Y is exactly B0h, then continues as type 56h.
Type54ScrollUntilY_B0ThenType56:
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je @@becomeCrawler
    jmp near ptr ScrollRecordThenFinish
@@becomeCrawler:
    mov word ptr ss:[bp + REC_TYPE], 56h
; Three terrain steps per frame; destroyed when one is blocked.
Type56CrawlDestroyOnBlock:
    call TryTerrainStep
    jne @@blocked
    call TryTerrainStep
    jne @@blocked
    call TryTerrainStep
    jne @@blocked
    jmp near ptr ScrollRecordThenFinish
@@blocked:
    call DestroyRecord
    jmp near ptr ScrollRecordThenFinish
; Fires a burst while its animation is in phase 3.
; A throttled spawn writes sprite 44h through the stale BX (see SpawnThrottledChild).
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
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    jae @@rightHalf
    jmp near ptr CheckFirePhase
@@rightHalf:
    add word ptr ss:[bp + REC_SPRITE], 3
    jmp near ptr CheckFirePhase
; Scrolls to Y B0h, then drops 4 px per frame without scrolling.
Type55DropFrom_B0:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je @@drop
    mov word ptr ss:[bp + REC_SPRITE], 73h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je @@startDrop
    jmp near ptr ScrollRecordThenFinish
@@startDrop:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
@@drop:
    mov ax, ds:[FrameCount8]
    add ax, 77h
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr FinishRecordUpdate
; Types 57h/58h: scrolls to Y 80h, then crawls two steps per frame and is destroyed when
; blocked.
; Only the second terrain step is tested; at Y = 80h exactly the sprite goes up by 1.
Type57ScrollToY80ThenCrawl:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae @@reachedY80
    jmp near ptr ScrollRecordThenFinish
@@reachedY80:
    jne @@crawl
    call IncrementRecordSprite
@@crawl:
    call TryTerrainStep
    call TryTerrainStep
    jne @@blocked
    jmp near ptr ScrollRecordThenFinish
@@blocked:
    jmp near ptr DestroyRecord
; Unreachable: no reference to this jump was found.
    jmp near ptr HorizontalTerrainPatrol
IncrementRecordSprite:
    inc word ptr ss:[bp + REC_SPRITE]
    ret
; Scrolls to Y 80h, animates, and becomes type 5Ah below Y C0h.
Type59ScrollThenAnimateThenType5A:
    mov word ptr ss:[bp + REC_SPRITE], 148h
    cmp word ptr ds:[LevelIndex], 0
    je @@checkY
    cmp word ptr ds:[LevelIndex], 6
    je @@checkY
    mov word ptr ss:[bp + REC_SPRITE], 174h
    cmp word ptr ds:[LevelIndex], 4
    je @@checkY
    mov word ptr ss:[bp + REC_SPRITE], 0E3h
@@checkY:
    cmp word ptr ss:[bp + REC_Y], 80h
    jg @@animate
    jmp near ptr ScrollRecordThenFinish
@@animate:
    mov ax, ds:[FrameCount4]
    add ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_Y], 0C0h
    jg @@becomeType5A
    jmp near ptr ScrollRecordThenFinish
@@becomeType5A:
    mov word ptr ss:[bp + REC_TYPE], 5Ah
; Crawls three steps per frame, mirroring its diagonal at the edges or a wall; destroyed
; when still blocked.
Type5ACrawlMirrorDiagonal:
    mov word ptr ss:[bp + REC_SPRITE], 148h
    cmp word ptr ds:[LevelIndex], 0
    je @@crawl
    cmp word ptr ds:[LevelIndex], 6
    je @@crawl
    mov word ptr ss:[bp + REC_SPRITE], 174h
    cmp word ptr ds:[LevelIndex], 4
    je @@crawl
    mov word ptr ss:[bp + REC_SPRITE], 0E3h
@@crawl:
    mov ax, ds:[FrameCount4]
    add ss:[bp + REC_SPRITE], ax
    call TryTerrainStep
    jne @@mirror
    call TryTerrainStep
    jne @@mirror
    call TryTerrainStep
    jne @@mirror
    cmp word ptr ss:[bp + REC_X], 0
    jng @@mirror
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    jnl @@mirror
    jmp near ptr ScrollRecordThenFinish
@@mirror:
    xor word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    call TryTerrainStep
    je @@continueScroll
    jmp near ptr DestroyRecord
@@continueScroll:
    jmp near ptr ScrollRecordThenFinish
; Scrolls past Y B0h, then continues as type 5Ch.
Type5BScrollPastY_B0ThenType5C:
    cmp word ptr ss:[bp + REC_Y], 0B0h
    jg @@becomeType5C
    jmp near ptr ScrollRecordThenFinish
@@becomeType5C:
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
; Four terrain steps per frame (only the last tested); when blocked: down -> down-left
; -> left; blocked in any other direction: DestroyRecord.
Type5ECrawlTurnDownToLeft:
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    jne @@blocked
    jmp near ptr ScrollRecordThenFinish
@@blocked:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je @@turnDownLeft
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
    je @@turnLeft
    jmp near ptr DestroyRecord
@@turnDownLeft:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_LEFT
    jmp near ptr ScrollRecordThenFinish
@@turnLeft:
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
    jne @@blocked
    jmp near ptr ScrollRecordThenFinish
@@blocked:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    je @@turnRight
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    jmp near ptr ScrollRecordThenFinish
@@turnRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    jmp near ptr ScrollRecordThenFinish
; Once X + Y >= 60h: four terrain steps per frame; blocked while left/right it turns
; down-right/down-left, otherwise DestroyRecord.
Type5FCrawlTurnDiagonalDown:
    mov ax, ds:[FrameCount4]
    add ax, 0F6h
    mov ss:[bp + REC_SPRITE], ax
    mov ax, ss:[bp + REC_Y]
    add ax, ss:[bp + REC_X]
    cmp ax, 60h
    jae @@crawl
    jmp near ptr ScrollRecordThenFinish
@@crawl:
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    jne @@blocked
    jmp near ptr ScrollRecordThenFinish
@@blocked:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    je @@bounceDownRight
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_RIGHT
    je @@bounceDownLeft
    jmp near ptr DestroyRecord
@@bounceDownRight:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN_RIGHT
    jmp near ptr ScrollRecordThenFinish
@@bounceDownLeft:
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
    jne @@arrived
    jmp near ptr ScrollRecordThenFinish
@@arrived:
    mov word ptr ss:[bp + REC_TYPE], 62h
    jmp near ptr ScrollRecordThenFinish
; Marches with the Invader* block (step 1..10h px by EncounterLiveCount); an edge sets the
; next reversal/drop. Below D0h it reverts to type 61h (re-entry at slot Y 20h); when
; its X equals the player's and a 1/32 roll passes it becomes 65h and runs type 63h's
; code this frame; fires down (sprite 63h) on a RecordTickCounter/FrameCount128 match.
Type62InvaderMarch:
    cmp word ptr ds:[FramesSinceInvaderSpawn], 18h
    jae @@march
    jmp near ptr ScrollRecordThenFinish
@@march:
    mov ax, ds:[InvaderDropStep]
    add ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 0D0h
    jna @@stepByLiveCount
    mov word ptr ss:[bp + REC_SPRITE], 0E7h
    mov word ptr ss:[bp + REC_TYPE], 61h
    and word ptr ss:[bp + REC_Y], -8
    and word ptr ss:[bp + REC_X], -8
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
    jmp short Type61InvaderSteerToSlot
@@stepByLiveCount:
    mov ax, 1
    cmp word ptr ds:[EncounterLiveCount], 10h
    ja @@stepX
    mov ax, 2
    cmp word ptr ds:[EncounterLiveCount], 8
    ja @@stepX
    mov ax, 4
    cmp word ptr ds:[EncounterLiveCount], 4
    ja @@stepX
    mov ax, 8
    cmp word ptr ds:[EncounterLiveCount], 1
    ja @@stepX
    mov ax, 10h
@@stepX:
    neg ax
    and ss:[bp + REC_X], ax
    neg ax
    mov bx, 0C0h
    mov cx, 1
    cmp word ptr ds:[InvaderMarchLeft], 0
    je @@moveX
    neg ax
    xor bx, bx
    mov cx, 0
@@moveX:
    add ss:[bp + REC_X], ax
    cmp ss:[bp + REC_X], bx
    jne @@checkDive
    mov ds:[InvaderNextMarchLeft], cx
    mov word ptr ds:[InvaderNextDropStep], 2
    call SpawnAimedShot
@@checkDive:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    cmp ss:[bp + REC_X], ax
    jne @@checkFire
    call NextRandomWord
    and bx, 1Fh
    jne @@checkFire
    mov word ptr ss:[bp + REC_TYPE], 65h
    jmp short Type63ScriptedSlideThenDrop
@@checkFire:
    mov ax, ds:[RecordTickCounter]
    and ax, 7Fh
    cmp ax, ds:[FrameCount128]
    je @@checkPhase
    jmp near ptr ScrollRecordThenFinish
@@checkPhase:
    cmp word ptr ds:[FrameCount4], 0
    je @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
    inc word ptr ds:[RecordTickCounter]
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    call SpawnThrottledChild
    cmp bx, -1
    jne @@setShotSprite
    jmp near ptr ScrollRecordThenFinish
@@setShotSprite:
    mov word ptr ds:[bx + REC_SPRITE], 63h
    jmp near ptr ScrollRecordThenFinish
; Dives 4 px per frame, firing aimed shots while its sprite advances.
Type65InvaderDiveFiring:
    add word ptr ss:[bp + REC_Y], 4
    cmp word ptr ds:[FrameCount4], 3
    je @@fireFrame
    jmp near ptr ScrollRecordThenFinish
@@fireFrame:
    cmp word ptr ss:[bp + REC_SPRITE], 0EBh
    jne @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
    inc word ptr ss:[bp + REC_SPRITE]
    call SpawnAimedShot
    jmp near ptr ScrollRecordThenFinish
; Waits for Y 50h, then plays a scripted slide by sprite and drops 4 px per frame.
Type63ScriptedSlideThenDrop:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae @@scripted
    jmp near ptr ScrollRecordThenFinish
@@scripted:
    cmp word ptr ss:[bp + REC_SPRITE], 0E7h
    je @@advanceOnPhase
    cmp word ptr ss:[bp + REC_SPRITE], 0E8h
    je @@advanceOnPhase
    cmp word ptr ss:[bp + REC_SPRITE], 0E9h
    je @@slideRight
    cmp word ptr ss:[bp + REC_SPRITE], 0EAh
    je @@advanceOnPhase
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr ScrollRecordThenFinish
@@slideRight:
    add word ptr ss:[bp + REC_X], 2
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    je @@reachedCenter
    jmp near ptr ScrollRecordThenFinish
@@reachedCenter:
    jmp short @@nextSprite
@@advanceOnPhase:
    cmp word ptr ds:[FrameCount4], 3
    je @@nextSprite
    jmp near ptr ScrollRecordThenFinish
@@nextSprite:
    inc word ptr ss:[bp + REC_SPRITE]
    jmp near ptr ScrollRecordThenFinish
; Drops 4 px per frame (2 on level 4).
Type64Drop4:
    mov ax, 2
    cmp word ptr ds:[LevelIndex], 4
    je @@drop
    add al, 2
@@drop:
    add ss:[bp + REC_Y], ax
    jmp near ptr ScrollRecordThenFinish
; Starts PathType66 with 20 hit points as type 12h.
Type66FollowPathType66:
    mov word ptr ss:[bp + REC_PATH], offset PathType66
    mov word ptr ss:[bp + REC_HIT_POINTS], 14h
    jmp near ptr StartPathFollow
; Starts PathType67 (type 66h mirrored) with 20 hit points as type 12h.
Type67FollowPathType67:
    mov word ptr ss:[bp + REC_PATH], offset PathType67
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
    jmp short DescendToTargetX
; Descends while sliding toward X 70h.
Type6DDescendToX70:
    mov word ptr ds:[DescentTargetX], 70h
    mov ax, ds:[FrameCount16]
    shr ax, 1
    shr ax, 1
    add ax, 124h
    mov ss:[bp + REC_SPRITE], ax
    jmp short DescendToTargetX
; Descends toward X 60h and fires; the only one of 6Bh..6Dh that shoots.
Type6CDescendToX60Firing:
    mov word ptr ds:[DescentTargetX], 60h
DescendToTargetX:
    cmp word ptr ss:[bp + REC_Y], 40h
    jae @@slide
    jmp near ptr ScrollRecordThenFinish
@@slide:
    mov ax, ds:[DescentTargetX]
    cmp ss:[bp + REC_X], ax
    je @@descend
    ja @@slideLeft
    add word ptr ss:[bp + REC_X], 2
    jmp short @@descend
@@slideLeft:
    sub word ptr ss:[bp + REC_X], 2
@@descend:
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ss:[bp + REC_TYPE], 6Ch
    je @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_CENTER_X
    je @@centerFire
    cmp word ptr ds:[FrameCount16], 0Fh
    jne @@offCenterDone
    call SpawnThrottledChild
@@offCenterDone:
    jmp near ptr ScrollRecordThenFinish
@@centerFire:
    cmp word ptr ds:[FrameCount4], 3
    jne @@centerDone
    call SpawnThrottledChild
@@centerDone:
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 50h and becomes type 70h unless the player is just below.
Type6FWaitThenType70:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae @@checkPlayer
    jmp near ptr ScrollRecordThenFinish
@@checkPlayer:
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    sub ax, ss:[bp + REC_Y]
    cmp ax, 20h
    jae @@becomeType70
    jmp near ptr ScrollRecordThenFinish
@@becomeType70:
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
    jne @@done
    call SpawnThrottledChild
@@done:
    jmp near ptr ScrollRecordThenFinish
; Descends 1 px per frame, firing an aimed shot every other frame.
Type72DescendFiringAimed:
    mov ax, ds:[FrameCount8]
    shr ax, 1
    add ax, 1Ch
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[CountGate2324], 1
    jne @@done
    call SpawnAimedShot
@@done:
    jmp near ptr ScrollRecordThenFinish
; Scrolls to Y 80h, then charges right as type 85h code.
Type73WaitThenRunRight:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae @@startRun
    jmp near ptr ScrollRecordThenFinish
@@startRun:
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
    jae @@startRun
    jmp near ptr ScrollRecordThenFinish
@@startRun:
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
    jne @@checkLeftEdge
    cmp word ptr ss:[bp + REC_X], PLAYFIELD_MAX_X
    je @@blocked
@@checkLeftEdge:
    cmp word ptr ss:[bp + REC_DIRECTION], DIR_LEFT
    jne @@charge
    cmp word ptr ss:[bp + REC_X], 0
    je @@blocked
@@charge:
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    call TryTerrainStep
    jne @@blocked
    jmp near ptr ScrollRecordThenFinish
@@blocked:
    call DestroyRecord
    jmp near ptr ScrollRecordThenFinish
; Waits until the player lines up with REC_DIRECTION, then becomes type 85h; the
; switching frame returns without the scroll tail.
; Row test: player Y & ~3 == (REC_Y + 14h) & ~3. The switch frame skips
; FinishRecordUpdate entirely.
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
    je @@compareColumn
    add ax, 8
@@compareColumn:
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
    jae @@checkColumn
    jmp near ptr ScrollRecordThenFinish
@@checkColumn:
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
    jna @@checkRow
    jmp near ptr ScrollRecordThenFinish
@@checkRow:
    jmp short Type84SameRow
; Each frame the player's Y (4-px aligned) equals REC_Y + 14h, fires throttled shots
; from Y - 4 and Y + 4 (sprite 44h).
Type92FireWhenPlayerOnRow:
    mov bx, ss:[bp + REC_Y]
    add bx, 14h
    and bx, -4
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    and ax, 0FFFCh
    cmp ax, bx
    je @@fire
    jmp near ptr ScrollRecordThenFinish
@@fire:
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
    je @@done
    mov word ptr ds:[bx + REC_SPRITE], 44h
@@done:
    ret
; Descends 2 px per frame, firing a three-way downward spread every 4 frames.
Type75DescendSpreadShot:
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ds:[FrameCount4], 3
    je @@fireSpread
    jmp near ptr ScrollRecordThenFinish
@@fireSpread:
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
    jmp short SegBossPlacePart
; Segmented boss part at BossPartOffsets[1].
Type77SegBossPart1:
    mov si, offset BossPartOffsets + 4
    jmp short SegBossPlacePart
; Segmented boss core (the former type 21h director) at BossPartOffsets[2]; fires aimed
; shots during FrameCount128 0..0Fh.
Type78SegBossCore:
    mov word ptr ss:[bp + REC_DIRECTION], DIR_DOWN
    cmp word ptr ds:[FrameCount128], 0Fh
    ja @@placePart
    call SpawnAimedShot
@@placePart:
    mov si, offset BossPartOffsets + 8
    jmp short SegBossPlacePart
; Segmented boss part at BossPartOffsets[3].
Type79SegBossPart3:
    mov si, offset BossPartOffsets + 0Ch
SegBossPlacePart:
    lodsw
    add ax, ds:[SegBossY]
    mov ss:[bp + REC_Y], ax
    cmp word ptr ss:[bp + REC_Y], 0
    jnl @@setX
    mov word ptr ss:[bp + REC_Y], 0
@@setX:
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
@@readWaypoint:
    mov si, ds:[SegBossPathCursor]
    lodsw
    cmp ax, 0FFFFh
    jne @@steer
    mov word ptr ds:[SegBossPathCursor], offset BossPath
    jmp short @@readWaypoint
@@steer:
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
    jne @@arrived
    ret
@@arrived:
    mov ds:[SegBossPathCursor], si
    jmp short SteerSegBossAlongPath
MAIN ends

FAR0F7F segment byte public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
; Per frame: raises MarchFireNow when MarchFireDelay expires and reloads the delay
; (78h..28h, shorter with fewer live members).
StepMarchFireDelay:
    dec byte ptr ds:[MarchFireDelay]
    jne @@notYet
    mov ax, word ptr ds:[EncounterLiveCount]
    mov cl, 078h
    cmp ax, 010h
    ja @@reloadDelay
    mov cl, 064h
    cmp ax, 8
    ja @@reloadDelay
    mov cl, 050h
    cmp ax, 4
    ja @@reloadDelay
    mov cl, 03Ch
    cmp ax, 2
    ja @@reloadDelay
    mov cl, 028h
@@reloadDelay:
    mov byte ptr ds:[MarchFireDelay], cl
    inc byte ptr ds:[MarchFireNow]
    jmp short @@done
@@notYet:
    mov byte ptr ds:[MarchFireNow], 0
@@done:
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
    je @@restartPath
    add ax, 20h
    mov ds:[SteerTargetY], ax
    lodsw
    mov ds:[SteerTargetX], ax
    mov word ptr ds:[SteerSpeed], 3
    mov ax, offset SteerTowardTarget
    call far ptr FarCallMainNearViaAX
    cmp word ptr ds:[SteerArrived], 0
    je @@setSprite
    mov word ptr ss:[bp + REC_HIT_POINTS], 2
    add word ptr cs:[Type21PathCursor], 4
    mov ax, offset SpawnEnemyHere
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je @@setSprite
    mov ax, ss:[bp + REC_Y]
    mov ds:[bx + REC_SAVED_Y], ax
    mov ax, ss:[bp + REC_X]
    mov ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_TYPE], 64h
    mov word ptr ds:[bx + REC_HIT_POINTS], 3
    mov word ptr ds:[bx + REC_SPRITE], 8Eh
@@setSprite:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 3Bh
    mov ss:[bp + REC_SPRITE], ax
    retf
@@restartPath:
    call ResetType21Path
    jmp short Type21LeaderPathBody

ResetType21Path:
    mov word ptr cs:[Type21PathCursor], offset Type21Path
    ret
; Next Type21Path waypoint (CS-resident).
Type21PathCursor dw 0

; Layer 1 moves down a row every 2nd frame, layer 2 every 4th, layer 3 every 8th (nested
; dividers); Y wraps C0h to 0. Frozen while EnergyTanks is -1.
MoveStars:
    cmp word ptr ds:[EnergyTanks], -1
    je @@done
    inc word ptr ds:[StarLayerTick1]
    and word ptr ds:[StarLayerTick1], 1
    jne @@done
    mov si, offset Stars
    mov cx, 014h
    call MoveStarLayer
    inc word ptr ds:[StarLayerTick2]
    and word ptr ds:[StarLayerTick2], 1
    jne @@done
    mov cx, 0Ah
    call MoveStarLayer
    inc word ptr ds:[StarLayerTick3]
    and word ptr ds:[StarLayerTick3], 1
    jne @@done
    mov cx, 0Ah
    call MoveStarLayer
@@done:
    retf

MoveStarLayer:
    inc word ptr ds:[si]
    cmp word ptr ds:[si], 0C0h
    jne @@nextStar
    mov word ptr ds:[si], 0
@@nextStar:
    add si, 6
    loop MoveStarLayer
    ret
FAR0F7F ends
end ProgramEntry