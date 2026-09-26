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
extrn BonusKeysEnabled:byte
extrn BossPath:word
extrn BurstOriginX:word
extrn BurstOriginY:word
extrn ByteAttributeTable:byte
extrn CheckCheatCodes:far
extrn ChildSpawnThrottle:byte
extrn ChooseSlot:word
extrn ChooseSlotPositions:word
extrn ClampXHighSeen:byte
extrn ClampXLowSeen:byte
extrn CountGate2324:word
extrn DescentTargetX:word
extrn DifficultyPositions:word
extrn DifficultySetting:word
extrn DirectionFromQuadrant:byte
extrn DispatchRecordX:word
extrn DispatchRecordY:word
extrn EmsAvailable:byte
extrn EmsDeviceName:byte
extrn EmsFreePages:word
extrn EmsPageFrame:word
extrn EmsTotalPages:word
extrn EncounterEndDelay:word
extrn EncounterLiveCount:word
extrn EncounterTicks:word
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
extrn FormationSlotCursor:word
extrn FormationSlots:word
extrn FramesSinceInvaderSpawn:word
extrn GameOverRequest:word
extrn HistoryCursor47:word
extrn HistoryEnd:word
extrn HistoryPairs:byte
extrn HistoryReadCursor15:word
extrn HistoryReadCursor31:word
extrn HistoryRecordSlot15:word
extrn HistoryRecordSlot31:word
extrn HistoryWriteCursor:word
extrn ImageEnd:byte
extrn InputBits:byte
extrn InstallCriticalErrorVector:far
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
extrn LeaderScript13End:word
extrn LeaderScript15End:word
extrn LeaderScript1CEnd:word
extrn LeaderScript1FEnd:word
extrn LeaderScript7DEnd:word
extrn LeaderScript7EEnd:word
extrn LeaderScriptCursor:word
extrn LevelIndex:word
extrn LevelScriptClock:word
extrn LevelSkipEnabled:byte
extrn LifeLostRequest:word
extrn LivesLeft:word
extrn LoadIsEnc:byte
extrn MapScrollPos:word
extrn MinusSlotA968:word
extrn MinusSlotA96C:word
extrn ModuleSoundEnabled:byte
extrn ModuleSoundRequest:byte
extrn MoveModeA47C:word
extrn MsgDeallocError:byte
extrn NextLevelRequest:word
extrn OffsetTableA368:word
extrn OffsetTableA374:word
extrn OffsetTableA380:word
extrn OffsetTableA38C:word
extrn OffsetXGroupA:word
extrn OffsetXGroupB:word
extrn OffsetXWork:word
extrn OpenResourceFile:far
extrn PageIndex:word
extrn PageListPtr:word
extrn PaymentFileName:byte
extrn PaymentHelpRow:word
extrn PlusSlotA966:word
extrn PlusSlotA96A:word
extrn PoolA:byte
extrn PoolAEnd:byte
extrn PoolAPointers:word
extrn PoolASaveBuffers:byte
extrn PoolBPointers:word
extrn PoolBSaveBuffers:byte
extrn PrimaryRecord:byte
extrn QuitAnswer:byte
extrn RapidFireEnabled:byte
extrn ResidentFiles:word
extrn ScoreBcd:byte
extrn ScrollDeltaY:word
extrn SegBossActive:word
extrn SegBossAnchor:word
extrn SegBossCore:word
extrn SegBossPart77:word
extrn SegBossPart79:word
extrn SegBossPathCursor:word
extrn SegBossX:word
extrn SegBossY:word
extrn SequenceFrameCount:word
extrn SfxActive:byte
extrn SfxCommandTable:word
extrn SfxEffectTable:word
extrn SfxEnabled:byte
extrn SfxNoteDivisors:word
extrn SfxRequest:byte
extrn SfxTickPhase:byte
extrn SfxVoiceA:byte
extrn SfxVoiceB:byte
extrn SoundModuleInitEntry:far
extrn SoundModuleLoaded:byte
extrn SoundModuleNameAdlib:byte
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
extrn SteerSpeed:word
extrn SteerTargetX:word
extrn SteerTargetY:word
extrn TargetSearchCursor:word
extrn Type86Frames:word
extrn Type86FramesDir6:word
extrn Type88Frames:word
extrn Type88FramesDir6:word
extrn VideoBiosModeTable:byte
extrn WalkerFacingStep:word
extrn WhatOilShortageFlag:byte
extrn WinScreenPageList:word
extrn XAdjustPathTaken:word
extrn loc_0F980:far
extrn loc_153A0:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public BlueBitsSegment
public LevelBlocksSegment
public LevelMapSegment
public LevelSpritesSegment
public LoadResourceFile
public MainDataSegment
public ManExplSegment
public MoveInDirection1
public MoveInDirection2
public MoveInDirection4
public MoveInDirection8
public PanelSegment
public PlaqueSegment
public PlayfieldRowBytes
public ReleaseEmsCache
public RequestModuleMusic
public ScreenSegment
public SfxCmdRest
public SfxCmdSlide
public SfxCmdStepDown
public SfxCmdStepUp
public SfxStopAll
public SfxStreamStoreAndWait
public SfxTimerTick
public ShipSegment
public ShowPageList
public SpawnThrottledChild
public Sprites1x1Segment
public Sprites2x2CSegment
public Sprites2x2Segment
public TheEndSegment
public VideoAdapter
public WaitVerticalRetracePulse
public WideRowBytes
public WorkspaceSegment
public loc_09D91
public loc_09EE4
public loc_09F1A
public loc_09F5F
public loc_0A781
public loc_0AF22
public loc_0AFD8
public loc_0B2AC
public loc_0B2C8
public loc_0B729
public loc_0BAE1
public loc_0BB03
public loc_0BC45
public loc_0BC4B
public loc_0BD0D
public loc_0BEC5
public loc_0BFC7
public loc_0C57C
public loc_0CB3E
public loc_0CBE8
public loc_10044
public loc_1009C
public loc_10108
extrn AllocateBuffers:near
extrn BlitPackedStride104:near
extrn BlitPackedStride160:near
extrn BlitPackedToScreen:near
extrn BlueBitsImageOffsets:word
extrn BuildByteToNibbleMaskTable:near
extrn BuildRowTables:near
extrn ClearByteCS066B:near
extrn ClearScreen104x200:near
extrn ComputeRecordGridOffset:near
extrn CopyWorkspaceToScreen:near
extrn CountXReturn:near
extrn DrawOffsetFromPlayfieldRow:near
extrn DrawOffsetFromScreenRow:near
extrn DrawOffsetFromWideRow:near
extrn DrawStars:near
extrn EraseStars:near
extrn FindFreeRecordPoolA:near
extrn FindFreeRecordPoolB:near
extrn FlushBiosKeyboardBuffer:near
extrn InitStars:near
extrn InstallKeyboardVector09:near
extrn InstallTimerVector08:near
extrn LoadDestOffset:word
extrn LoadDestSegment:word
extrn LoadGraphicsRecordImages:near
extrn LoadHiscoreFile:near
extrn LoadImageSlot:word
extrn LoadNamePtr:word
extrn LoadPackedFile:near
extrn PackedDestOffset:word
extrn PackedDestSegment:word
extrn PackedNamePtr:word
extrn PackedOutputBytes:word
extrn PanelImageOffsets:word
extrn PlaqueImageOffset:word
extrn PollInputBits:near
extrn ReadIndexedByteAttribute:near
extrn RestartAtCheckpoint:near
extrn ShowFatalErrorAndExit:near
extrn SteerTowardTarget:near
extrn TypeHandler13:near
extrn TypeHandler24:near
extrn TypeHandler25:near
extrn TypeHandler26:near
extrn TypeHandler27:near
extrn TypeHandler28:near
extrn TypeHandler29:near
extrn TypeHandler2B:near
extrn TypeHandler2D:near
extrn TypeHandler2E:near
extrn TypeHandler2F:near
extrn TypeHandler30:near
extrn TypeHandler31:near
extrn TypeHandler32:near
extrn TypeHandler33:near
extrn TypeHandler34:near
extrn TypeHandler37:near
extrn TypeHandler38:near
extrn TypeHandler39:near
extrn TypeHandler3A:near
extrn TypeHandler3B:near
extrn TypeHandler3C:near
extrn TypeHandler3D:near
extrn TypeHandler3E:near
extrn TypeHandler3F:near
extrn TypeHandler40:near
extrn TypeHandler41:near
extrn TypeHandler42:near
extrn TypeHandler43:near
extrn TypeHandler44:near
extrn TypeHandler45:near
extrn TypeHandler46:near
extrn TypeHandler47:near
extrn TypeHandler48:near
extrn TypeHandler49:near
extrn TypeHandler4A:near
extrn TypeHandler4B:near
extrn TypeHandler4C:near
extrn TypeHandler4D:near
extrn TypeHandler4E:near
extrn TypeHandler4F:near
extrn TypeHandler51:near
extrn TypeHandler52:near
extrn TypeHandler53:near
extrn TypeHandler60:near
extrn TypeHandler68:near
extrn TypeHandler69:near
extrn TypeHandler71:near
extrn TypeHandler7A:near
extrn TypeHandler7B:near
extrn TypeHandler7C:near
extrn TypeHandler7F:near
extrn TypeHandler80:near
extrn TypeHandler81:near
extrn TypeHandler83:near
extrn TypeHandler8A:near
extrn TypeHandler8F:near
extrn TypeHandler90:near
extrn TypeHandler91:near
extrn TypeHandler93:near
extrn UpdateHighScoreTable:near
extrn WaitByteCS066B:near
extrn WaitVerticalRetrace:near
extrn loc_0073C:near
extrn loc_00747:near
extrn loc_007EF:near
extrn loc_00B3E:near
extrn loc_00D42:near
extrn loc_00E9C:near
extrn loc_04A65:near
extrn loc_04D95:near
extrn loc_04F37:near
extrn loc_04F57:near
extrn loc_04FC3:near
extrn loc_04FF9:near
extrn loc_05059:near
extrn loc_0511F:near
extrn loc_05145:near
extrn loc_05160:near
extrn loc_0518C:near
extrn loc_0526A:near
extrn loc_054C0:near
extrn loc_05559:near
extrn loc_057E6:near
extrn loc_05800:near
extrn loc_05A7E:near
extrn loc_05A92:near
extrn loc_05AC8:near
extrn loc_05BEE:near
extrn loc_05C04:near
extrn loc_05C22:near
extrn loc_05C35:near
extrn loc_05C9A:near
extrn loc_05D0B:near
extrn loc_05E1B:near
extrn loc_05E42:near
extrn loc_05F0D:near
extrn loc_05F43:near
extrn loc_05F61:near
extrn loc_060A2:near
extrn loc_060AC:near
extrn loc_06176:near
extrn loc_061DC:near
extrn loc_062AA:near
extrn loc_062F6:near
extrn loc_07420:near
extrn loc_07476:near
extrn loc_074E2:near
extrn loc_074FE:near
extrn loc_07547:near
extrn loc_07596:near
extrn loc_07746:near
extrn loc_077C5:near
extrn loc_077DF:near
extrn loc_07948:near
extrn loc_081E9:near
extrn loc_081F4:near
extrn loc_08209:near
extrn loc_08331:near
extrn loc_0837A:near
extrn loc_08517:near
extrn loc_08546:near
extrn loc_0859E:near
extrn loc_0878C:near
extrn loc_08D83:near
; Segment of the level map (LEVnMAP.BIC, loaded into SlotBuffer).
LevelMapSegment dw seg SoundModuleSlot + SLOT_BUFFER_PARAGRAPH
; B800h; its reader has not been reviewed.
    dw 0B800h
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
    call DetectEms
    call LoadSoundModule
    call AllocateBuffers
    call BuildRowTables
    call InitStars
    call loc_054C0
    call loc_00D42
    mov word ptr cs:[LoadNamePtr], offset File_WINDOW_BIC
    mov ax, word ptr cs:[WorkspaceSegment]
    add ax, 07D0h
    inc ax
    mov word ptr cs:[LoadDestSegment], ax
    mov word ptr cs:[LoadImageSlot], offset PlaqueImageOffset
    call LoadGraphicsRecordImages
    call loc_05800
    call loc_05C22
    mov cx, 0FAh
loc_096C5:
    call WaitVerticalRetrace
    loop loc_096C5
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, offset VideoBiosModeTable
    xlat
    int 010h
    mov word ptr ds:[021A2h], 1
    call loc_05BEE
    call loc_0CBE8
; Options menu and choose screen, then reset level, lives and score and start the
; first level. GameOver returns here.
StartNewGame:
    mov al, 2
    call RequestModuleMusic
    call loc_04FC3
    call loc_05145
    call loc_05559
    mov word ptr ds:[LevelIndex], 0
    mov word ptr ds:[LivesLeft], INITIAL_LIVES
    mov word ptr ds:[0235Ah], 0
    mov word ptr ds:[GameOverRequest], 0
    mov byte ptr ds:[ScoreBcd], 0
    mov byte ptr ds:[ScoreBcd + 1], 0
    mov byte ptr ds:[ScoreBcd + 2], 0
    mov byte ptr ds:[ScoreBcd + 3], 0
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
    mov bp, offset PrimaryRecord
    call StoreApplyHistoryAndConditionalPlacement
    call loc_0A940
    mov word ptr ds:[020A6h], 020A8h
    call loc_0C57C
    call loc_0B5A9
    mov word ptr ds:[SegBossActive], 0
    call loc_05F43
    cmp word ptr ds:[MapScrollPos], 09Ch
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
    call loc_05160
    call WaitByteCS066B
    jmp short GameFrame

loc_0981F:
    mov al, 4
    mov ah, 058h
    call DrawOffsetFromPlayfieldRow
    add di, word ptr ds:[0234Ch]
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
    call loc_05BEE
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
    call loc_0511F
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
    call loc_0511F
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
    cmp byte ptr ds:[KeyDownTable + SCAN_F10], KEY_STATE_DOWN
    je @@wait_f10_release
    call loc_0511F
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
    call loc_0511F
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

; Near leaf. Set ES=CS:9596, BP=237Ch. With DF=0 fill48 four-byte pairs at ES:A27A with (SS:[237E]+8,
; SS:[2380]+9), modulo65536. Then DS:A33A/A33C/A33E/A340 become A27A/A2FE/A2BE/A27E. CX=0,DI=A33A,AX=last X+9;
; BX,DX,SI,DS,SS preserved. Flags from final ADD. Requires valid buffers and source not overwritten by
; destination for uniform-fill interpretation; loads repeat each iteration. Unlike later writes, initial X bias
; is9, not8.
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

loc_099F6:
    and word ptr ds:[PrimaryRecord + REC_X], 0FFFEh
    mov byte ptr ds:[InputBits], 0
    mov bx, word ptr ds:[0A47Ch]
    shl bx, 1
    jmp word ptr cs:[bx + loc_099F6Cases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_099F6Cases label word
    dw offset CountXReturn, offset loc_09A78, offset loc_09A3E, offset loc_09A16
    dw offset CountXReturn
loc_09A16:
    mov byte ptr ds:[InputBits], 8
    call loc_09DB9
    call loc_09DEA
    cmp word ptr ds:[0A97Ah], 58h
    je loc_09A29
    ret
loc_09A29:
    cmp word ptr ds:[0A95Ah], 3
    je loc_09A31
    ret
loc_09A31:
    cmp word ptr ds:[0A95Ch], 18h
    je loc_09A39
    ret
loc_09A39:
    inc word ptr ds:[MoveModeA47C]
    ret
loc_09A3E:
    cmp word ptr ds:[2384h], 0
    jne loc_09A5D
    cmp word ptr ds:[OffsetXGroupB], 8
    je loc_09A50
    inc word ptr ds:[OffsetXGroupB]
loc_09A50:
    cmp word ptr ds:[OffsetXGroupA], -8
    je loc_09A73
    dec word ptr ds:[OffsetXGroupA]
    jmp short loc_09A73
loc_09A5D:
    cmp word ptr ds:[OffsetXGroupB], 0Fh
    je loc_09A68
    inc word ptr ds:[OffsetXGroupB]
loc_09A68:
    cmp word ptr ds:[OffsetXGroupA], -0Fh
    je loc_09A73
    dec word ptr ds:[OffsetXGroupA]
loc_09A73:
    mov si, 0A35Ch
    jmp short loc_09A7B
loc_09A78:
    mov si, 0A358h
loc_09A7B:
    call loc_09AD1
    cmp byte ptr ds:[InputBits], 0
    je loc_09A86
    ret
loc_09A86:
    inc word ptr ds:[MoveModeA47C]
    cmp word ptr ds:[MoveModeA47C], 2
    je loc_09A94
    jmp near ptr loc_099F6
loc_09A94:
    mov word ptr ds:[OffsetXGroupA], 0
    mov word ptr ds:[OffsetXGroupB], 0
    call FindFreeRecordPoolA
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 16h], 4
    mov word ptr ds:[bx + 18h], 52h
    mov word ptr ds:[bx + 14h], 2
    mov word ptr ds:[bx + 28h], 0FFFFh
    mov word ptr ds:[bx + 8], 0Fh
    mov word ptr ds:[bx + 2], 20h
    mov word ptr ds:[bx + 4], 58h
    mov ds:[9788h], bx
    jmp near ptr loc_099F6
loc_09AD1:
    lodsw
    cmp ds:[237Eh], ax
    je loc_09AE4
    mov byte ptr ds:[InputBits], 4
    jb loc_09AE4
    mov byte ptr ds:[InputBits], 8
loc_09AE4:
    lodsw
    cmp ds:[2380h], ax
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
    call RestartAtCheckpoint
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
    cmp word ptr ds:[MoveModeA47C], 0
    je loc_09B47
    call loc_099F6
loc_09B47:
    cmp word ptr ds:[MoveModeA47C], 4
    jne loc_09B55
    mov word ptr ds:[NextLevelRequest], 1
    ret
loc_09B55:
    mov word ptr ds:[ScrollDeltaY], 0
    mov bp, offset PrimaryRecord
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
    cmp word ptr ds:[MapScrollPos], 0B6h
    jbe loc_09BA9
    test byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
    je loc_09BA9
    call loc_08546
loc_09BA9:
    call loc_0A66F
    call loc_0A067
    cmp byte ptr ds:[BonusKeysEnabled], 0
    je loc_09BC0
    cmp byte ptr ds:[KeyDownTable + SCAN_3], KEY_STATE_DOWN
    jne loc_09BC0
    call loc_09D4D
loc_09BC0:
    cmp word ptr ds:[MoveModeA47C], 1
    ja loc_09BCA
    call UpdatePlacementXOffsetsAtRecordEdges
loc_09BCA:
    cmp word ptr ds:[MoveModeA47C], 0
    jne loc_09BDF
    call loc_09CB6
    cmp word ptr ds:[MapScrollPos], 0B6h
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
    cmp word ptr ds:[MapScrollPos], 0B6h
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
    cmp word ptr ds:[PlusSlotA966], -1
    je loc_09C41
    call loc_09BFB
loc_09C41:
    cmp word ptr ds:[MinusSlotA968], -1
    je loc_09C4B
    call loc_09BFE
loc_09C4B:
    cmp word ptr ds:[PlusSlotA96A], -1
    je loc_09C55
    call loc_09BFB
loc_09C55:
    cmp word ptr ds:[MinusSlotA96C], -1
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

loc_09CB6:
    call loc_04FF9
    jb loc_09CBC
    ret
loc_09CBC:
    push bp
    cmp word ptr ds:[DifficultySetting], 0
    je loc_09CD1
    cmp word ptr ds:[DifficultySetting], 1
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
    mov di, word ptr ds:[HistoryWriteCursor]
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

loc_09D4D:
    cmp byte ptr ds:[BonusKeysEnabled], 0
    je loc_09D5B
loc_09D54:
    cmp byte ptr ds:[KeyDownTable + SCAN_3], KEY_STATE_DOWN
    je loc_09D54
loc_09D5B:
    inc word ptr ds:[095FAh]
    and word ptr ds:[095FAh], 3
    jmp near ptr loc_0AC19
loc_09D67:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09D73
    mov byte ptr ds:[SfxRequest], 1Ch
loc_09D73:
    cmp word ptr ds:[0A95Ah], 3
    je loc_09D84
    inc word ptr ds:[0A95Ah]
loc_09D7E:
    push bp
    call loc_09EC2
    pop bp
    ret
loc_09D84:
    cmp word ptr ds:[0A95Ch], 18h
    je loc_09D7E
    inc word ptr ds:[0A95Ch]
    jmp short loc_09D84
loc_09D91:
    cmp word ptr ds:[0A96Eh], -1
    je loc_09D99
    ret
loc_09D99:
    call loc_074FE
    mov ds:[0A96Eh], bx
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 14h], 1
    mov word ptr ds:[bx + 16h], 1
    mov word ptr ds:[bx + 8], 0Fh
    mov word ptr ds:[bx + 20h], 14h
    ret

loc_09DB9:
    cmp word ptr ds:[0A97Ah], 058h
    jne loc_09DC1
    ret
loc_09DC1:
    cmp word ptr ds:[0A97Ch], 1
    jne loc_09DC9
    ret
loc_09DC9:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_09DE9
    mov word ptr ds:[0A97Ch], 1
    cmp word ptr ds:[0BDACh], 1
    je loc_09DE9
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09DE9
    mov byte ptr ds:[SfxRequest], 0Dh
loc_09DE9:
    ret
loc_09DEA:
    cmp word ptr ds:[0A95Ch], 18h
    jne loc_09E12
    cmp word ptr ds:[0A95Ah], 3
    jne loc_09DF9
    ret
loc_09DF9:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09E05
    mov byte ptr ds:[SfxRequest], 1Ch
loc_09E05:
    inc word ptr ds:[0A95Ah]
    mov word ptr ds:[0A95Ch], 0
    jmp near ptr loc_09EC2
loc_09E12:
    inc word ptr ds:[0A95Ch]
    jmp near ptr loc_09EC2

loc_09E19:
    cmp word ptr ds:[0A47Ch], 1
    jne loc_09E21
    ret
loc_09E21:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb loc_09E29
    ret
loc_09E29:
    cmp word ptr ds:[0A95Ah], -1
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
    inc byte ptr ds:[0A362h]
    and byte ptr ds:[0A362h], 1
    je loc_09E98
    ret
loc_09E98:
    dec word ptr ds:[0A95Ah]
    cmp word ptr ds:[0A95Ah], -1
    jne loc_09EC2
    mov word ptr ds:[0A95Ch], 0
    cmp byte ptr ds:[AllCheatsFlag], 1
    je loc_09ED7
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 3
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
    cmp byte ptr ds:[WhatOilShortageFlag], 1
    je loc_09F11
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_09F0E
    mov byte ptr ds:[SfxRequest], 019h
loc_09F0E:
    jmp near ptr loc_077DF
loc_09F11:
    mov word ptr ds:[0A97Ah], 058h
    jmp near ptr loc_077DF
loc_09F1A:
    push bp
    call loc_09F20
    pop bp
    ret
loc_09F20:
    cmp word ptr ds:[HistoryRecordSlot15], -1
    jne loc_09F30
    call loc_074FE
    mov ds:[HistoryRecordSlot15], bx
    jmp short loc_09F41
loc_09F30:
    cmp word ptr ds:[HistoryRecordSlot31], -1
    jne loc_09F40
    call loc_074FE
    mov ds:[HistoryRecordSlot31], bx
    jmp short loc_09F41
loc_09F40:
    ret
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
    mov bp, offset PrimaryRecord
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
    mov byte ptr ds:[ClampXLowSeen], 0
    mov byte ptr ds:[ClampXHighSeen], 0
    mov ax, word ptr ds:[OffsetXGroupA]
    mov word ptr ds:[OffsetXWork], ax
    mov si, offset OffsetTableA38C
    mov bx, word ptr ds:[MinusSlotA96C]
    call PlaceRecordFromOffsetPair
    mov si, offset OffsetTableA374
    mov bx, word ptr ds:[MinusSlotA968]
    call PlaceRecordFromOffsetPair
    mov ax, word ptr ds:[OffsetXGroupB]
    mov word ptr ds:[OffsetXWork], ax
    mov si, offset OffsetTableA380
    mov bx, word ptr ds:[PlusSlotA96A]
    call PlaceRecordFromOffsetPair
    mov si, offset OffsetTableA368
    mov bx, word ptr ds:[PlusSlotA966]

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

; Fields scoped to the SetResponseAndStepRecordCounter response path; no entity/health identity asserted.
; Offset-placement use of field+8 does not define its role in other record types.
; Modern position-history symbols.
; Modern record/state symbols.
; Continuation of PlaceRecordFromOffsetPair across the physical
; chunk boundary: same routine, not a separate clamp/feedback producer.
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

; Near leaf. If DS:A962 !=FFFF, copy two sequential words from DS:[DS:A33C] to record DS:[DS:A962]+2/+4. Then
; independently do the same for A964/A33E. With DF=0 these are Y/X pairs and SI advances4 after the last copy;
; AX=last X,BX=last destination. If neither slot exists AX/BX/SI unchanged. Flags are always CMP(A964,FFFF),
; even on copy; caller9BE8 overwrites them. CX,DX,DI,BP and segments preserved. Requires valid selected
; pointers; pair abstraction assumes destinations do not alias cursors/slots/source. Actual load/store order
; remains significant; no activation/type checks.
ApplyPositionHistoryToRecords:
    cmp word ptr ds:[HistoryRecordSlot15], -1
    je loc_0A048
    mov bx, word ptr ds:[HistoryRecordSlot15]
    mov si, word ptr ds:[HistoryReadCursor15]
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
loc_0A048:
    cmp word ptr ds:[HistoryRecordSlot31], -1
    je loc_0A05F
    mov bx, word ptr ds:[HistoryRecordSlot31]
    mov si, word ptr ds:[HistoryReadCursor31]
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
loc_0A05F:
    ret
loc_0A060:
    mov word ptr ds:[0A980h], 0
    ret

loc_0A067:
    test byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_0A060
    cmp word ptr ds:[0A980h], 0
    je loc_0A084
    cmp byte ptr ds:[RapidFireEnabled], 1
    je loc_0A084
    cmp word ptr ds:[0232Ah], 0Fh
    je loc_0A084
    ret
loc_0A084:
    mov word ptr ds:[0A980h], 1
    cmp word ptr ds:[MapScrollPos], 0B6h
    ja loc_0A0A6
    cmp word ptr ds:[0BDACh], 0
    jne loc_0A0A6
    cmp word ptr ds:[0A958h], 2
    jne loc_0A0A3
    jmp near ptr loc_0A1C8
loc_0A0A3:
    jmp near ptr loc_0A19F
loc_0A0A6:
    mov ax, word ptr ds:[0A970h]
    mov word ptr ds:[0A3A0h], ax
    mov ax, word ptr ds:[0A972h]
    mov word ptr ds:[0A3A2h], ax
    mov ax, word ptr ds:[0A976h]
    mov word ptr ds:[0A3A4h], ax
    mov ax, word ptr ds:[0A974h]
    mov word ptr ds:[0A3A6h], ax
    cmp word ptr ds:[0BDACh], 1
    jne loc_0A0D8
    cmp word ptr ds:[0BE06h], 8
    jne loc_0A0CE
    jmp short loc_0A114
loc_0A0CE:
    cmp word ptr ds:[0BE06h], 0Fh
    jbe loc_0A0D8
    jmp near ptr loc_0A515
loc_0A0D8:
    call loc_0A515
    call loc_0A584
    call loc_0A3FF
    call loc_0A3CA
    call loc_0A0E8
    ret

loc_0A0E8:
    cmp word ptr ds:[0A958h], 5
    jne loc_0A0F2
    call loc_0A2A0
loc_0A0F2:
    cmp word ptr ds:[0A96Eh], -1
    je loc_0A0FC
    call loc_0A114
loc_0A0FC:
    mov bx, word ptr ds:[0A958h]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0A0FCCases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0A0FCCases label word
    dw offset loc_0A19F, offset loc_0A18A, offset loc_0A1C8, offset loc_0A337
    dw offset loc_0A2F6, offset CountXReturn

loc_0A114:
    cmp word ptr ds:[0A3A6h], 0
    je loc_0A11C
    ret
loc_0A11C:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A128
    mov byte ptr ds:[SfxRequest], 018h
loc_0A128:
    inc word ptr ds:[0A974h]
    call loc_0A175
    sub ax, 6
    mov word ptr ds:[bx + 2], ax
    mov ax, word ptr ds:[si + 4]
    add ax, 4
    mov word ptr ds:[bx + 4], ax
    inc word ptr ds:[0A974h]
    call loc_0A175
    sub ax, 2
    mov word ptr ds:[bx + 2], ax
    mov ax, word ptr ds:[si + 4]
    sub ax, 4
    mov word ptr ds:[bx + 4], ax
    mov word ptr ds:[bx + 6], 7
    inc word ptr ds:[0A974h]
    call loc_0A175
    sub ax, 2
    mov word ptr ds:[bx + 2], ax
    mov ax, word ptr ds:[si + 4]
    add ax, 0Ch
    mov word ptr ds:[bx + 4], ax
    mov word ptr ds:[bx + 6], 1
    ret

loc_0A175:
    call loc_0A4EA
    mov word ptr ds:[bx + 018h], 0Ch
    mov word ptr ds:[bx + 01Ch], 7
    mov si, word ptr ds:[0A96Eh]
    mov ax, word ptr ds:[si + 2]
    ret
loc_0A18A:
    call loc_0A1AB
    mov word ptr ds:[bx + 8], 33h
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A19E
    mov byte ptr ds:[SfxRequest], 14h
loc_0A19E:
    ret
loc_0A19F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A1AB
    mov byte ptr ds:[SfxRequest], 013h
loc_0A1AB:
    call loc_0A4EA

loc_0A1AE:
    mov si, word ptr ss:[bp + 8]
    shl si, 1
    shl si, 1
    add si, 0A3A8h
    lodsw
    add ax, word ptr ss:[bp + 2]
    mov word ptr ds:[bx + 2], ax
    lodsw
    add ax, word ptr ss:[bp + 4]
    mov word ptr ds:[bx + 4], ax
    ret
loc_0A1C8:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A1D4
    mov byte ptr ds:[SfxRequest], 015h
loc_0A1D4:
    call loc_0A4EA
    mov word ptr ds:[bx + 8], 018h
    call loc_0A1AE
    call loc_0A4EA
    call loc_0A1AE
    mov word ptr ds:[bx + 6], 7
    mov word ptr ds:[bx + 8], 01Fh
    test byte ptr ds:[InputBits], IN_XMINUS
    jne loc_0A211
    mov word ptr ds:[bx + 6], 1
    mov word ptr ds:[bx + 8], 019h
    test byte ptr ds:[InputBits], IN_XPLUS
    jne loc_0A211
    mov word ptr ds:[bx + 6], 0
    mov word ptr ds:[bx + 8], 018h
loc_0A211:
    ret

loc_0A212:
    cmp word ptr ds:[0A972h], 0
    jne loc_0A21A
    ret
loc_0A21A:
    cmp word ptr ds:[02324h], 1
    jne loc_0A258
    cmp word ptr ds:[0A3EAh], 0A3E8h
    jne loc_0A22A
    ret
loc_0A22A:
    mov bx, word ptr ds:[0A3B4h]
    cmp bx, -1
    jne loc_0A234
    ret
loc_0A234:
    cmp word ptr ds:[bx + 4], 0
    je loc_0A255
    call loc_0A2D6
    mov bx, word ptr ds:[0A3B4h]
    sub word ptr ds:[bx + 4], 8
    mov bx, word ptr ds:[0A3EAh]
    sub bx, 4
    mov bx, word ptr ds:[bx]
    cmp word ptr ds:[bx + 4], 0C8h
    je loc_0A258
loc_0A255:
    call loc_0A2D6
loc_0A258:
    mov si, 0A3B4h
    lodsw
    cmp ax, 0FFFFh
    jne loc_0A262
    ret
loc_0A262:
    mov bx, ax
    sub word ptr ds:[bx + 2], 4
    mov cx, word ptr ds:[bx + 4]
    add cx, 8
    mov di, word ptr ds:[bx + 2]
loc_0A271:
    lodsw
    cmp ax, 0FFFFh
    je loc_0A289
    mov bx, ax
    mov word ptr ds:[bx + 4], cx
    add cx, 8
    mov word ptr ds:[bx + 2], di
    mov word ptr ds:[bx + 8], 06Bh
    jmp short loc_0A271
loc_0A289:
    sub si, 4
    mov bx, word ptr ds:[si]
    mov word ptr ds:[bx + 8], 06Ch
    ret

loc_0A294:
    mov di, word ptr ds:[0A3EAh]
    mov word ptr ds:[di], bx
    add word ptr ds:[0A3EAh], 2
    ret

loc_0A2A0:
    cmp word ptr ds:[0A3A2h], 0
    je loc_0A2A8
    ret
loc_0A2A8:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A2B4
    mov byte ptr ds:[SfxRequest], 011h
loc_0A2B4:
    mov es, word ptr cs:[MainDataSegment]
    mov word ptr ds:[0A3EAh], 0A3B4h
    mov di, 0A3B4h
    mov ax, 0FFFFh
    mov cx, 01Ah
    rep stosw
    call loc_0A2D6
    mov word ptr ds:[bx + 8], 06Ah
    sub word ptr ds:[bx + 4], 8

loc_0A2D6:
    inc word ptr ds:[0A972h]
    call loc_0A4EA
    call loc_0A294
    mov word ptr ds:[bx + 018h], 9
    call loc_0A1AE
    and word ptr ds:[bx + 4], 0FFF8h
    add word ptr ds:[bx + 4], 8
    mov word ptr ds:[bx + 8], 06Ch
    ret
loc_0A2F6:
    cmp word ptr ds:[0A3A0h], 0
    je loc_0A2FE
    ret
loc_0A2FE:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A30A
    mov byte ptr ds:[SfxRequest], 17h
loc_0A30A:
    inc word ptr ds:[0A970h]
    call loc_0A4EA
    mov word ptr ds:[bx + 18h], 8
    mov word ptr ds:[bx + 8], 35h
    call loc_0A1AE
    inc word ptr ds:[0A970h]
    call loc_0A4EA
    mov word ptr ds:[bx + 18h], 8
    mov word ptr ds:[bx + 8], 35h
    call loc_0A1AE
    add word ptr ds:[bx + 2], 8
    ret
loc_0A337:
    cmp word ptr ds:[0A3A0h], 0
    je loc_0A33F
    ret
loc_0A33F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A34B
    mov byte ptr ds:[SfxRequest], 16h
loc_0A34B:
    inc word ptr ds:[0A970h]
    call loc_0A4EA
    mov word ptr ds:[bx + 18h], 7
    mov word ptr ds:[bx + 8], 37h
    call loc_0A1AE
    inc word ptr ds:[0A970h]
    call loc_0A4EA
    mov word ptr ds:[bx + 18h], 7
    mov word ptr ds:[bx + 8], 37h
    call loc_0A1AE
    add word ptr ds:[bx + 2], 8
    ret

loc_0A378:
    cmp si, -1
    jne loc_0A37E
    ret
loc_0A37E:
    cmp word ptr ds:[0A95Eh], 0
    jne loc_0A386
    ret
loc_0A386:
    cmp word ptr ds:[0A3A4h], 0
    je loc_0A38E
    ret
loc_0A38E:
    call loc_0A396
    mov word ptr ds:[bx + 018h], 6

loc_0A396:
    inc word ptr ds:[0A976h]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A3A6
    mov byte ptr ds:[SfxRequest], 012h
loc_0A3A6:
    call loc_0A4EA
    mov ax, word ptr ds:[si + 4]
    add ax, 4
    mov word ptr ds:[bx + 4], ax
    mov ax, word ptr ds:[si + 2]
    add ax, 4
    mov word ptr ds:[bx + 2], ax
    and word ptr ds:[bx + 4], 0FFFCh
    mov word ptr ds:[bx + 8], 8
    mov word ptr ds:[bx + 018h], 5
    ret

loc_0A3CA:
    mov word ptr ds:[0A3ECh], 7
    mov si, word ptr ds:[0A966h]
    call loc_0A41A
    mov word ptr ds:[0A3ECh], 1
    mov si, word ptr ds:[0A968h]
    call loc_0A41A
    mov word ptr ds:[0A3ECh], 7
    mov si, word ptr ds:[0A96Ah]
    call loc_0A41A
    mov word ptr ds:[0A3ECh], 1
    mov si, word ptr ds:[0A96Ch]
    call loc_0A41A
    ret

loc_0A3FF:
    mov word ptr ds:[0A3ECh], 0FFFFh
    mov si, word ptr ds:[0A962h]
    call loc_0A41A
    call loc_0A378
    mov si, word ptr ds:[0A964h]
    call loc_0A41A
    call loc_0A378
    ret

loc_0A41A:
    cmp si, -1
    jne loc_0A420
    ret
loc_0A420:
    mov bx, word ptr ds:[0A958h]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0A420Cases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0A420Cases label word
    dw offset loc_0A4D7, offset loc_0A490, offset loc_0A499, offset loc_0A464
    dw offset loc_0A438, offset CountXReturn
loc_0A438:
    cmp word ptr ds:[0A3A0h], 0
    je loc_0A440
    ret
loc_0A440:
    add word ptr ds:[0A970h], 2
    call loc_0A4D7
    mov word ptr ds:[bx + 18h], 8
    mov word ptr ds:[bx + 8], 35h
    call loc_0A4D7
    mov word ptr ds:[bx + 18h], 8
    mov word ptr ds:[bx + 8], 35h
    add word ptr ds:[bx + 2], 8
    ret
loc_0A464:
    cmp word ptr ds:[0A3A0h], 0
    je loc_0A46C
    ret
loc_0A46C:
    add word ptr ds:[0A970h], 2
    call loc_0A4D7
    mov word ptr ds:[bx + 18h], 7
    mov word ptr ds:[bx + 8], 37h
    call loc_0A4D7
    mov word ptr ds:[bx + 18h], 7
    mov word ptr ds:[bx + 8], 37h
    add word ptr ds:[bx + 2], 8
    ret
loc_0A490:
    call loc_0A4D7
    mov word ptr ds:[bx + 8], 33h
    ret
loc_0A499:
    call loc_0A4EA
    mov ax, ds:[si + 2]
    mov ds:[bx + 2], ax
    mov ax, ds:[si + 4]
    add ax, 4
    mov ds:[bx + 4], ax
    mov ax, ds:[0A3ECh]
    mov ds:[bx + 6], ax
    cmp ax, 0FFFFh
    jne loc_0A4C6
    mov word ptr ds:[bx + 6], 7
    cmp word ptr ds:[si + 4], 58h
    jna loc_0A4C6
    mov word ptr ds:[bx + 6], 1
loc_0A4C6:
    cmp word ptr ds:[bx + 6], 1
    mov word ptr ds:[bx + 8], 19h
    je loc_0A4D6
    mov word ptr ds:[bx + 8], 1Fh
loc_0A4D6:
    ret
loc_0A4D7:
    call loc_0A4EA
    mov ax, ds:[si + 2]
    mov ds:[bx + 2], ax
    mov ax, ds:[si + 4]
    add ax, 4
    mov ds:[bx + 4], ax
    ret

loc_0A4EA:
    call loc_07547
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 01Eh], 1
    mov word ptr ds:[bx + 6], 0
    mov word ptr ds:[bx + 8], 032h
    mov word ptr ds:[bx + 014h], 0
    mov word ptr ds:[bx + 016h], 2
    mov word ptr ds:[bx + 018h], 2
    mov word ptr ds:[bx + 01Ch], 0FFFFh
    ret

loc_0A515:
    cmp word ptr ds:[0A960h], 0
    jne loc_0A51D
    ret
loc_0A51D:
    cmp word ptr ds:[0A97Eh], 1
    jne loc_0A525
    ret
loc_0A525:
    call loc_07547
    call CopyRecordPositionPlus10
    push bp
    mov bp, bx
    call loc_0B15A
    mov ax, bx
    mov bx, bp
    pop bp
    cmp ax, 0FFFFh
    jne loc_0A53C
    ret
loc_0A53C:
    mov word ptr ds:[bx + 030h], ax
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 01Eh], 1
    mov word ptr ds:[bx + 014h], 0
    mov word ptr ds:[bx + 016h], 2
    mov word ptr ds:[bx + 018h], 0Ah
    mov word ptr ds:[bx + 01Ch], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A568
    mov byte ptr ds:[SfxRequest], 011h
loc_0A568:
    inc word ptr ds:[0A97Eh]
    dec word ptr ds:[0A960h]
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

loc_0A584:
    cmp word ptr ds:[0A95Eh], 0
    jne loc_0A58C
    ret
loc_0A58C:
    cmp word ptr ds:[0A3A4h], 0
    je loc_0A594
    ret
loc_0A594:
    inc word ptr ds:[0A976h]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A5A4
    mov byte ptr ds:[SfxRequest], 012h
loc_0A5A4:
    call loc_0A4EA
    call CopyRecordPositionPlus10
    and word ptr ds:[bx + REC_X], 0FFFCh
    mov word ptr ds:[bx + 8], 8
    mov word ptr ds:[bx + 018h], 5
    inc word ptr ds:[0A976h]
    call loc_0A4EA
    call CopyRecordPositionPlus10
    and word ptr ds:[bx + REC_X], 0FFFCh
    mov word ptr ds:[bx + 8], 8
    mov word ptr ds:[bx + 018h], 6
    ret

; DS:A47C==0: apply DecRecordYUnlessAtMin twice via CALL into next instruction then fallthrough re-entry. Otherwise
; decrement SS:[BP+2] once modulo65536 without boundary guard. Near return; registers/segments preserved; flags
; changed, IF/DF preserved. Mode-zero y21h becomes20h, not1Fh. Nested call consumes two stack bytes temporarily.
DecRecordYByMode:
    cmp word ptr ds:[MoveModeA47C], 0
    jne loc_0A5E6
    call DecRecordYUnlessAtMin
; Decrement word SS:[BP+2] modulo 65536 unless it equals 0020h. This is NOT a saturating
; lower-bound clamp: values below 20h also decrement. CMP always overwrites CF; DEC
; preserves that CF.
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

; Call IncRecordYUnlessAtMax, then fall through into it again. Two equality-guarded increments of SS:[BP+2]; BFh
; becomesC0h, values aboveC0h still increment modulo65536. Registers/segments preserved; flags changed, IF/DF
; preserved; normal outer near return.
IncRecordYTwice:
    call IncRecordYUnlessAtMax
; Increment word SS:[BP+2] modulo 65536 unless it equals 00C0h; values above C0h also
; increment.
IncRecordYUnlessAtMax:
    cmp word ptr ss:[bp + REC_Y], RECORD_Y_MAX
    jne loc_0A5F5
    ret
loc_0A5F5:
    inc word ptr ss:[bp + REC_Y]
    ret

; Call DecRecordXUnlessZero then fall through into it again; SS:[BP+4]=max(original-2,0) for unsigned word.
; Registers/segments preserved; flags changed, IF/DF preserved. Outer near return; inner call/return must remain
; in ASM.
DecRecordXTwice:
    call DecRecordXUnlessZero
; Decrement unsigned word SS:[BP+4] unless zero; register state preserved, flags changed by
; CMP/DEC.
DecRecordXUnlessZero:
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0A603
    ret
loc_0A603:
    dec word ptr ss:[bp + REC_X]
    ret

; Call IncRecordXBelowMax then fall through into it again. Unsigned SS:[BP+4] increases up toB0h if initially below
; it; values>=B0h unchanged. General/segment registers preserved; flags changed, IF/DF preserved; outer near
; return.
IncRecordXTwice:
    call IncRecordXBelowMax
; Increment unsigned word SS:[BP+4] iff below 00B0h; values at or above B0h remain
; unchanged.
IncRecordXBelowMax:
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
    jb loc_0A612
    ret
loc_0A612:
    inc word ptr ss:[bp + REC_X]
    ret

; Near entry. If unsigned DS:2350<=B6 return. Otherwise call UpdatePlacementXGroupA, then re-read SS:[BP+REC_X].
; If X==B0 and IN_XPLUS set, increment DS:OffsetXGroupB unless exactly8; otherwise decrement it unless
; exactly0. Group A is updated first, preserving sequential alias effects of the original loads. Word operations
; wrap at16 bits; guards are equality-only, not saturation. Preserve all general/segment registers and IF/DF;
; arithmetic flags depend on final path. Normal near return; only group-A/B words may be written, apart from
; call stack. Requires valid callee state; normal caller record/state do not overlap.
UpdatePlacementXOffsetsAtRecordEdges:
    cmp word ptr ds:[MapScrollPos], 0B6h
    ja loc_0A61F
    ret
loc_0A61F:
    call UpdatePlacementXGroupA
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
    jne loc_0A63C
    test byte ptr ds:[InputBits], IN_XPLUS
    je loc_0A63C
    cmp word ptr ds:[OffsetXGroupB], 8
    je loc_0A63B
    inc word ptr ds:[OffsetXGroupB]
loc_0A63B:
    ret
loc_0A63C:
    cmp word ptr ds:[OffsetXGroupB], 0
    je loc_0A647
    dec word ptr ds:[OffsetXGroupB]
loc_0A647:
    ret

; Near leaf. Read SS:[BP+REC_X] and DS:InputBits. If X==0 and IN_XMINUS set, decrement DS:OffsetXGroupA
; unless exactlyFFF8h; otherwise increment it unless exactly0. All arithmetic wraps at16 bits. Equality
; sentinels do not validate or clamp arbitrary accumulator values. Preserve all general and segment registers,
; IF/DF; arithmetic flags path-dependent. Normal near return; only group-A word may be written. Requires valid
; record/state storage; no hardware effects.
UpdatePlacementXGroupA:
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0A662
    test byte ptr ds:[InputBits], IN_XMINUS
    je loc_0A662
    cmp word ptr ds:[OffsetXGroupA], -8
    jne loc_0A65D
    ret
loc_0A65D:
    dec word ptr ds:[OffsetXGroupA]
    ret
loc_0A662:
    cmp word ptr ds:[OffsetXGroupA], 0
    jne loc_0A66A
    ret
loc_0A66A:
    inc word ptr ds:[OffsetXGroupA]
    ret

loc_0A66F:
    cmp word ptr ds:[0A47Ch], 0
    je loc_0A679
    jmp near ptr loc_0A6FD
loc_0A679:
    cmp word ptr ds:[EncounterLiveCount], 0
    jne loc_0A6FD
    cmp word ptr ds:[EncounterEndDelay], 0
    jne loc_0A6FD
    call loc_0A6FE
    cmp word ptr ds:[0234Eh], 0
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
    mov si, 0A982h
    cmp word ptr ds:[MapScrollPos], 0E52h
    jne loc_0A6A8
    call loc_0C591
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
    cmp word ptr ds:[MapScrollPos], 0EA0h
    jne loc_0A6FD
    mov word ptr ds:[0A47Ch], 1
    call loc_062AA
    mov si, 0A3EEh
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
    mov word ptr ds:[bx + REC_KIND], 4
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

loc_0A6FE:
    push bp
    add word ptr ds:[ScrollDeltaY], 1
    mov word ptr ds:[02352h], 0
    cmp word ptr ds:[0234Eh], 0
    jne loc_0A714
    call loc_0A74E
loc_0A714:
    dec word ptr ds:[0234Eh]
    and word ptr ds:[0234Eh], 0Fh
    jne loc_0A72F
    cmp word ptr ds:[02354h], 0
    je loc_0A72F
    add word ptr ds:[MapScrollPos], 0Dh
    dec word ptr ds:[LevelScriptClock]
loc_0A72F:
    mov ax, word ptr cs:[095BEh]
    cmp word ptr ds:[0234Ch], ax
    jne loc_0A73C
    call loc_0A746
loc_0A73C:
    mov ax, word ptr cs:[PlayfieldRowBytes]
    sub word ptr ds:[0234Ch], ax
loc_0A744:
    pop bp
    ret

loc_0A746:
    mov ax, word ptr cs:[095C0h]
    mov word ptr ds:[0234Ch], ax
    ret

loc_0A74E:
    call loc_0A7EB
    cmp word ptr ds:[MapScrollPos], 0B6h
    ja loc_0A765
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A765
    mov byte ptr ds:[SfxRequest], 7
loc_0A765:
    add word ptr ds:[MapScrollPos], 0Dh
    dec word ptr ds:[LevelScriptClock]
    mov al, 5
    cmp word ptr ds:[LevelScriptClock], 4
    jne loc_0A77A
    call RequestModuleMusic
loc_0A77A:
    mov word ptr ds:[02354h], 0
    ret

loc_0A781:
    push bp
    mov word ptr ds:[02352h], 1
    cmp word ptr ds:[MapScrollPos], 0
    je loc_0A744
    add word ptr ds:[ScrollDeltaY], -1
    cmp word ptr ds:[0234Eh], 0
    jne loc_0A79E
    call loc_0A7D0
loc_0A79E:
    inc word ptr ds:[0234Eh]
    and word ptr ds:[0234Eh], 0Fh
    jne loc_0A7B9
    cmp word ptr ds:[02354h], 1
    je loc_0A7B9
    sub word ptr ds:[MapScrollPos], 0Dh
    inc word ptr ds:[LevelScriptClock]
loc_0A7B9:
    mov ax, word ptr cs:[095C0h]
    cmp word ptr ds:[0234Ch], ax
    jne loc_0A7C6
    call loc_0A7E3
loc_0A7C6:
    mov ax, word ptr cs:[PlayfieldRowBytes]
    add word ptr ds:[0234Ch], ax
    pop bp
    ret

loc_0A7D0:
    call loc_0A7EB
    sub word ptr ds:[MapScrollPos], 0Dh
    inc word ptr ds:[LevelScriptClock]
    mov word ptr ds:[02354h], 1
    ret

loc_0A7E3:
    mov ax, word ptr cs:[095BEh]
    mov word ptr ds:[0234Ch], ax
    ret

loc_0A7EB:
    mov di, word ptr ds:[0234Ch]
    sub di, word ptr cs:[095BEh]
    call loc_0A81B
    mov si, word ptr ds:[0234Ch]
    sub si, word ptr cs:[095BEh]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov di, si
    add di, word ptr cs:[095C2h]
    mov cx, word ptr cs:[095BEh]
    shr cx, 1
    rep movsw
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_0A81B:
    mov bx, word ptr ds:[MapScrollPos]
    cmp word ptr ds:[02352h], 1
    jne loc_0A82D
    sub bx, 0A9h
    jmp near ptr loc_05A7E
loc_0A82D:
    mov word ptr ds:[0A408h], bx
    cmp word ptr ds:[MapScrollPos], 0E52h
    ja loc_0A83F
    call loc_07948
    call loc_04A65
loc_0A83F:
    mov bx, word ptr ds:[MapScrollPos]
    jmp near ptr loc_05A7E

loc_0A846:
    mov cx, POOL_A_POINTER_COUNT
loc_0A849:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A85B
    call loc_05AC8
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
    call loc_05AC8
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
    call loc_07746
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
    cmp word ptr ds:[0BDACh], 1
    je loc_0A8B8
    cmp word ptr ds:[MapScrollPos], 0B6h
    ja loc_0A8B8
    cmp word ptr ss:[bp + REC_KIND], 1
    je loc_0A8C1
loc_0A8B8:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 0
    jne loc_0A8C1
    call loc_07596
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
    cmp word ptr ds:[0BDACh], 1
    je loc_0A8EB
    cmp word ptr ds:[MapScrollPos], 0B6h
    ja loc_0A8EB
    cmp word ptr ss:[bp + REC_KIND], 1
    je loc_0A8F4
loc_0A8EB:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 1
    jne loc_0A8F4
    call loc_07596
loc_0A8F4:
    pop cx
    loop loc_0A8C7
    cmp word ptr ds:[0A47Ch], 0
    jne loc_0A8FF
    ret
loc_0A8FF:
    mov bp, word ptr ds:[09788h]
    cmp bp, -1
    je loc_0A90B
    call loc_07596
loc_0A90B:
    ret

loc_0A90C:
    mov cx, POOL_B_COUNT
loc_0A90F:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A921
    call loc_05A92
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
    call loc_05A92
loc_0A939:
    pop cx
    loop loc_0A927
    call EraseStars
    ret

loc_0A940:
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
    cmp byte ptr ds:[098A2h], 0
    je loc_0A97B
    neg word ptr ds:[098AAh]
    mov byte ptr ds:[098A2h], 0
    mov byte ptr ds:[098A4h], 1
    jmp short loc_0A980
loc_0A97B:
    mov byte ptr ds:[098A4h], 0
loc_0A980:
    xor cl, cl
    cmp byte ptr ds:[098A5h], 0
    je loc_0A9A9
    dec byte ptr ds:[098A5h]
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
    mov byte ptr ds:[098A5h], cl
    inc byte ptr ds:[098A3h]
    jmp short loc_0A9B8
loc_0A9B3:
    mov byte ptr ds:[098A3h], 0
loc_0A9B8:
    call far ptr loc_1000D
loc_0A9BD:
    mov byte ptr ds:[098A9h], 0
    cmp byte ptr ds:[098A8h], 0
    je loc_0A9D3
    mov byte ptr ds:[098A8h], 0
    mov byte ptr ds:[098A9h], 1
loc_0A9D3:
    cmp word ptr ds:[SegBossActive], 1
    jne loc_0A9DD
    call loc_0F797
loc_0A9DD:
    mov cx, POOL_A_COUNT
loc_0A9E0:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolAPointers - 2]
    inc word ptr ds:[02340h]
    cmp word ptr ds:[02340h], 05DCh
    jb loc_0A9FB
    mov word ptr ds:[02340h], 0
loc_0A9FB:
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0AA04
    call loc_0AA2B
loc_0AA04:
    pop cx
    loop loc_0A9E0
    mov word ptr ds:[02346h], 0
    mov cx, POOL_B_COUNT
loc_0AA10:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + PoolBPointers - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0AA22
    call loc_0AA2B
loc_0AA22:
    pop cx
    loop loc_0AA10
    call far ptr MoveStars
    ret

loc_0AA2B:
    mov bx, word ptr ss:[bp + 016h]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0AA2BCases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0AA2BCases label word
    dw offset loc_0BC45, offset loc_0AD04, offset loc_0EFAE, offset CountXReturn
    dw offset loc_0EFAE, offset loc_0AAC2, offset loc_0AB10
loc_0AA44:
    clc
    ret
loc_0AA46:
    mov ax, word ptr ss:[bp + 2]
    or ax, ax
    js loc_0AA44
    mov si, word ptr ds:[PrimaryRecord + REC_SPRITE]
    cmp si, 3
    jae loc_0AA44
    shl si, 1
    shl si, 1
    add si, 0214Eh
    lodsw
    add ax, word ptr ds:[PrimaryRecord + REC_Y]
    mov word ptr ds:[095F2h], ax
    lodsw
    add ax, word ptr ds:[PrimaryRecord + REC_X]
    mov word ptr ds:[095F4h], ax
    jmp near ptr loc_08331
loc_0AA71:
    mov ax, word ptr ss:[bp + 2]
    or ax, ax
    js loc_0AA44
    mov ax, word ptr ss:[bp + 4]
    add ax, 018h
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jl loc_0AA44
    sub ax, 02Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_X]
    jg loc_0AA44
    cmp word ptr ds:[SegBossActive], 1
    jne loc_0AAAB
    mov ax, word ptr ss:[bp + 2]
    add ax, 8
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jb loc_0AA44
    sub ax, 0Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    ja loc_0AA44
    stc
    ret
loc_0AAAB:
    mov ax, word ptr ss:[bp + 2]
    add ax, 018h
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    jb loc_0AA44
    sub ax, 02Ch
    cmp ax, word ptr ds:[PrimaryRecord + REC_Y]
    ja loc_0AA44
    stc
    ret
loc_0AAC2:
    inc word ptr ss:[bp + 2]
    call loc_0AA46
    jb loc_0AACD
    jmp near ptr loc_0BC45
loc_0AACD:
    call loc_0AAD3
    jmp near ptr loc_0BC45
loc_0AAD3:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb loc_0AADB
    ret
loc_0AADB:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0AAE7
    mov byte ptr ds:[SfxRequest], 7
loc_0AAE7:
    mov bx, 020h
    call loc_05F0D
    push bp
    push word ptr cs:[0AB0Ah]
    mov bx, word ptr ss:[bp + 026h]
    mov bp, offset PrimaryRecord
    shl bx, 1
    jmp word ptr cs:[bx + loc_0AAE7Cases]
loc_0AAE7Cases label word
    dw offset CountXReturn, offset loc_09D4D, offset loc_09D67, offset loc_062AA
    dw offset loc_09DB9, offset loc_0AB0C
loc_0AB0C:
    pop bp
    jmp near ptr loc_0BD17
loc_0AB10:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jb loc_0AB1A
    jmp near ptr loc_0AC22
loc_0AB1A:
    cmp word ptr ds:[0A47Ch], 3
    jb loc_0AB24
    jmp near ptr loc_0AC22
loc_0AB24:
    mov ax, word ptr ds:[02336h]
    mov bx, 0A40Ch
    xlat
    add ax, 9
    mov word ptr ss:[bp + REC_SPRITE], ax
    mov dx, 0A414h
loc_0AB34:
    mov bx, offset PrimaryRecord
    mov si, word ptr ds:[bx + 8]
    shl si, 1
    shl si, 1
    add si, dx
    lodsw
    add ax, word ptr ds:[bx + 2]
    mov word ptr ss:[bp + REC_Y], ax
    lodsw
    add ax, word ptr ds:[bx + 4]
    mov word ptr ss:[bp + REC_X], ax
    ret
loc_0AB4F:
    mov ax, word ptr ds:[0233Ch]
    add ax, 018h
    mov word ptr ss:[bp + REC_SPRITE], ax
    ret
loc_0AB59:
    mov word ptr ds:[0A42Ch], 0A96Ch
    jmp short loc_0AB77
loc_0AB61:
    mov word ptr ds:[0A42Ch], 0A96Ah
    jmp short loc_0AB77
loc_0AB69:
    mov word ptr ds:[0A42Ch], 0A968h
    jmp short loc_0AB77
loc_0AB71:
    mov word ptr ds:[0A42Ch], 0A966h
loc_0AB77:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_0AB8F
    call loc_0AB4F
    call loc_0AC28
    jb loc_0AB8F
    call loc_0AC81
    jb loc_0AB8C
    ret
loc_0AB8C:
    call loc_0AB99
loc_0AB8F:
    mov bx, word ptr ds:[0A42Ch]
    mov word ptr ds:[bx], 0FFFFh
    jmp short loc_0ABF3
loc_0AB99:
    push bp
    mov bp, bx
    call loc_0BFC7
    mov bx, bp
    pop bp
    ret
loc_0ABA3:
    mov word ptr ds:[0A42Eh], bx
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_0ABC0
    mov ax, word ptr ds:[0233Ch]
    add ax, 014h
    mov word ptr ss:[bp + REC_SPRITE], ax
    call loc_0AC81
    jb loc_0ABBD
    ret
loc_0ABBD:
    call loc_0AB99
loc_0ABC0:
    mov bx, word ptr ds:[0A42Eh]
    mov word ptr ds:[bx], 0FFFFh
    jmp short loc_0ABF3
loc_0ABCA:
    cmp word ptr ds:[PrimaryRecord + REC_SPRITE], 3
    jae loc_0ABDC
    mov dx, 0A420h
    call loc_0AB34
    call loc_0AC28
    jae loc_0ABE4
loc_0ABDC:
    mov word ptr ds:[0A96Eh], 0FFFFh
    jmp short loc_0ABF3
loc_0ABE4:
    call loc_0AC81
    jb loc_0ABEA
    ret
loc_0ABEA:
    mov word ptr ds:[0A96Eh], 0FFFFh
    call loc_0AB99
loc_0ABF3:
    cmp bp, -1
    jne loc_0ABF9
    ret
loc_0ABF9:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0AC05
    mov byte ptr ds:[SfxRequest], 019h
loc_0AC05:
    mov word ptr ss:[bp + REC_TYPE], 1
    mov word ptr ss:[bp + REC_KIND], 4
    mov word ptr ss:[bp + REC_ANIM_COUNTER], 0
    mov word ptr ss:[bp + REC_SPRITE], 0
loc_0AC19:
    push bp
    call loc_0837A
    call loc_0859E
    pop bp
    ret
loc_0AC22:
    mov word ptr ss:[bp + REC_STATUS], 0
    ret
loc_0AC28:
    cmp word ptr ds:[0A47Ch], 0
    je loc_0AC32
    jmp near ptr loc_0AA44
loc_0AC32:
    cmp word ptr ds:[0BDACh], 1
    jne ProbeGridForRecordResponse
    jmp near ptr loc_0AA44
; ProbeGridForRecordResponse: internal entry after AC28 gates, not a separate proven function.
; Probe base+13, then base+14 only if first attribute is zero and X low nibble !=0.
; Negative-Y FFFF sentinel is NOT checked here: +13 wraps to 000C.
; Attribute ZF controls response entry; source/table gameplay identities remain unknown.
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
; Shared clear-carry return for both grid probe and independently called response helper.
RecordResponseReturnClear:
    clc
    ret
; SetResponseAndStepRecordCounter: also CALLed from ACF1 in the record scan.
; SS:BP record; DS state. Set +24=5; decrement +20 only when BEDC!=0 or 2324==1.
; CF=1 only on decremented zero, also clearing +24; otherwise CF=0. Zero wraps to FFFF.
; If DS:98C0!=0, write BEFF=0E. Other flag values are path-dependent.
; No general/segment register changes in this entry; shared return at RecordResponseReturnClear.
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
loc_0AC81:
    cmp word ptr ds:[0BDACh], 1
    jne loc_0AC8B
    jmp near ptr loc_0AA44
loc_0AC8B:
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
    mov ax, word ptr ss:[bp + REC_X]
    mov di, word ptr ss:[bp + REC_Y]
loc_0AC97:
    cmp word ptr ds:[bx], 0
    je loc_0ACD2
    cmp word ptr ds:[bx + 018h], 1
    je loc_0ACD2
    cmp word ptr ds:[bx + 014h], 1
    jne loc_0ACD2
    mov si, word ptr ds:[bx + 2]
    add si, 010h
    cmp di, si
    jg loc_0ACD2
    sub si, 020h
    cmp di, si
    jl loc_0ACD2
    mov si, word ptr ds:[bx + 4]
    add si, 010h
    cmp ax, si
    jg loc_0ACD2
    sub si, 020h
    cmp ax, si
    jl loc_0ACD2
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    cmp si, word ptr ds:[bx + 0Eh]
    jne loc_0ACD9
loc_0ACD2:
    add bx, RECORD_SIZE
    loop loc_0AC97
    clc
    ret
loc_0ACD9:
    cmp word ptr ds:[bx + 016h], 5
    je loc_0ACF9
    cmp word ptr ds:[bx + 014h], 1
    je loc_0ACE8
    jmp near ptr loc_05059
loc_0ACE8:
    cmp word ptr ds:[bx + 016h], 4
    jne loc_0ACD2
    call loc_0AB99
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
    call loc_0AAD3
    mov bx, bp
    pop bp
    clc
    ret
loc_0AD04:
    cmp word ptr ds:[0BDACh], 1
    je loc_0AD14
    cmp word ptr ds:[MapScrollPos], 0B6h
    ja loc_0AD14
    ret
loc_0AD14:
    cmp word ptr ss:[bp + REC_SPRITE], 0Fh
    jne loc_0AD1D
    jmp near ptr loc_0ABCA
loc_0AD1D:
    cmp bp, word ptr ds:[0A966h]
    jne loc_0AD26
    jmp near ptr loc_0AB71
loc_0AD26:
    cmp bp, word ptr ds:[0A968h]
    jne loc_0AD2F
    jmp near ptr loc_0AB69
loc_0AD2F:
    cmp bp, word ptr ds:[0A96Ah]
    jne loc_0AD38
    jmp near ptr loc_0AB61
loc_0AD38:
    cmp bp, word ptr ds:[0A96Ch]
    jne loc_0AD41
    jmp near ptr loc_0AB59
loc_0AD41:
    mov bx, 0A962h
    cmp bp, word ptr ds:[0A962h]
    jne loc_0AD4D
    jmp near ptr loc_0ABA3
loc_0AD4D:
    mov bx, 0A964h
    cmp bp, word ptr ds:[0A964h]
    jne loc_0AD59
    jmp near ptr loc_0ABA3
loc_0AD59:
    ret
loc_0AD5A:
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
loc_0AD60:
    cmp word ptr ss:[bp + REC_Y], 8
    jae loc_0AD69
    jmp near ptr loc_0BD17
loc_0AD69:
    cmp word ptr ss:[bp + REC_Y], 0E0h
    jbe loc_0AD73
    jmp near ptr loc_0BD17
loc_0AD73:
    cmp word ptr ss:[bp + REC_X], 0C8h
    jbe loc_0AD7D
    jmp near ptr loc_0BD17
loc_0AD7D:
    cmp word ptr ss:[bp + REC_KIND], 2
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
    cmp word ptr ds:[0BDACh], 1
    je loc_0ADC8
; Sibling grid probe: unlike ProbeGridForRecordResponse, distinguishes attribute 1 from other nonzero bytes.
; The FFFF grid sentinel is again not checked before adding 13.
    call ComputeRecordGridOffset
    add bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0ADC8
    dec al
    jne loc_0ADC8
    jmp near ptr loc_0BD17
loc_0ADC8:
    ret
loc_0ADC9:
    mov word ptr ss:[bp + REC_Y], 0FFFFh
    jmp short loc_0AD60
; UNKNOWN: not yet classified as code or data
    db 0FFh,046h,02h,0FFh,046h,02h,0E9h,077h,04h
TypeHandler08:
    sub word ptr ss:[bp + REC_Y], 10h
    jmp short loc_0AD60
TypeHandler07:
    mov ax, ds:[2326h]
    add ax, 5Ah
    mov ss:[bp + REC_SPRITE], ax
    sub word ptr ss:[bp + REC_Y], 3
    jmp near ptr loc_0AD60
TypeHandler09:
    jmp near ptr loc_0AD60
TypeHandler0F:
    mov ax, ds:[232Ah]
    shr ax, 1
    add ax, 0
    mov ss:[bp + REC_SPRITE], ax
    dec word ptr ss:[bp + REC_FIELD_1C]
    je loc_0ADC9
    mov ax, 0B250h
    push ax
    jmp near ptr MoveInDirection2
TypeHandler0C:
    cmp word ptr ss:[bp + REC_FIELD_1C], 0
    je loc_0AE19
    dec word ptr ss:[bp + REC_FIELD_1C]
    jne loc_0AE1D
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_0AE19:
    sub word ptr ss:[bp + REC_Y], 2
loc_0AE1D:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 28h
    mov ss:[bp + REC_SPRITE], ax
    call loc_0AF22
    jmp near ptr loc_0AD60
TypeHandler06:
    cmp word ptr ss:[bp + REC_X], 0C8h
    je loc_0ADC9
    sub word ptr ss:[bp + REC_Y], 4
    test word ptr ss:[bp + REC_X], 7
    jne loc_0AE5E
    test word ptr ss:[bp + REC_X], 8
    je loc_0AE5E
    cmp word ptr ds:[0BDACh], 1
    je loc_0AE5E
    call ComputeRecordGridOffset
    add bx, 0Eh
    call ReadIndexedByteAttribute
    mov word ptr ss:[bp + REC_DIRECTION], 0
    cmp al, 1
    je loc_0AE67
loc_0AE5E:
    mov word ptr ss:[bp + REC_DIRECTION], 1
    add word ptr ss:[bp + REC_X], 4
loc_0AE67:
    mov ax, ds:[2326h]
    shl ax, 1
    shl ax, 1
    and ax, 8
    add ax, ss:[bp + REC_DIRECTION]
    add ax, 8
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr loc_0AD5A
TypeHandler05:
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0AE86
    jmp near ptr loc_0ADC9
loc_0AE86:
    sub word ptr ss:[bp + REC_Y], 4
    test word ptr ss:[bp + REC_X], 0Fh
    jne loc_0AEAA
    cmp word ptr ds:[0BDACh], 1
    je loc_0AEAA
    call ComputeRecordGridOffset
    add bx, 0Ch
    call ReadIndexedByteAttribute
    mov word ptr ss:[bp + REC_DIRECTION], 0
    cmp al, 1
    je loc_0AEB3
loc_0AEAA:
    mov word ptr ss:[bp + REC_DIRECTION], 7
    sub word ptr ss:[bp + REC_X], 4
loc_0AEB3:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 8
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr loc_0AD5A
TypeHandler04:
    mov ax, 0B250h
    push ax
    cmp word ptr ds:[LevelIndex], 0
    je loc_0AECD
    jmp near ptr MoveInDirection4
loc_0AECD:
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    jne loc_0AED6
    jmp near ptr MoveInDirection4
loc_0AED6:
    jmp short MoveInDirection8
TypeHandler02:
    dec word ptr ss:[bp + REC_FIELD_1C]
    jne loc_0AEE0
    jmp near ptr loc_0ADC9
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
loc_0AF22:
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
; UNKNOWN: not yet classified as code or data
    db 090h
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
loc_0AFD8:
    mov word ptr ds:[0A430h], 0
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[0A432h], ax
    mov word ptr ds:[0A438h], ax
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[0A434h], ax
    mov word ptr ds:[0A436h], ax
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
    sub word ptr ss:[bp + REC_Y], 010h
    call loc_0B00D
    add word ptr ss:[bp + REC_Y], 010h
    mov ax, word ptr ds:[ScrollDeltaY]
    sub word ptr ss:[bp + REC_Y], ax
    cmp word ptr ds:[0A430h], 0
    ret
; Sibling grid consumer explicitly rejects BX=FFFF; grid-helper flags are dead.
loc_0B00D:
    call ComputeRecordGridOffset
    cmp bx, -1
    je loc_0B032
    mov dx, bx
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0B00DCases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0B00DCases label word
    dw offset loc_0B07D, offset loc_0B0C9, offset loc_0B0CC, offset loc_0B039
    dw offset loc_0B03C, offset loc_0B10C, offset loc_0B10F, offset loc_0B07A
loc_0B032:
    mov word ptr ds:[0A430h], 1
    ret
loc_0B039:
    call loc_0B0CC
loc_0B03C:
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
    inc word ptr ds:[0A438h]
    push bx
    call loc_0BDD0
    pop bx
    jae loc_0B06A
    dec word ptr ss:[bp + REC_Y]
    dec word ptr ds:[0A438h]
    jmp short loc_0B032
loc_0B06A:
    inc word ptr ds:[0215Ah]
    and word ptr ds:[0215Ah], 0Fh
    je loc_0B076
    ret
loc_0B076:
    sub dx, 0Dh
    ret
loc_0B07A:
    call loc_0B10F
loc_0B07D:
    mov bx, dx
    test word ptr ds:[0215Ah], 0Fh
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
    dec word ptr ds:[0A438h]
    push bx
    call loc_0BDD0
    pop bx
    jae loc_0B0B4
    inc word ptr ss:[bp + REC_Y]
    inc word ptr ds:[0A438h]
    jmp near ptr loc_0B032
loc_0B0B4:
    dec word ptr ds:[0215Ah]
    and word ptr ds:[0215Ah], 0Fh
    cmp word ptr ds:[0215Ah], 0Fh
    je loc_0B0C5
    ret
loc_0B0C5:
    add dx, 0Dh
    ret
loc_0B0C9:
    call loc_0B07D
loc_0B0CC:
    mov bx, dx
    inc bx
    call ReadIndexedByteAttribute
    je loc_0B0D7
    jmp near ptr loc_0B032
loc_0B0D7:
    test word ptr ds:[0215Ah], 0Fh
    je loc_0B0EA
    sub bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0B0EA
    jmp near ptr loc_0B032
loc_0B0EA:
    inc word ptr ss:[bp + REC_X]
    inc word ptr ds:[0A436h]
    push bx
    call loc_0BDD0
    pop bx
    jae loc_0B102
    dec word ptr ss:[bp + REC_X]
    dec word ptr ds:[0A436h]
    jmp near ptr loc_0B032
loc_0B102:
    test word ptr ss:[bp + REC_X], 0Fh
    je loc_0B10A
    ret
loc_0B10A:
    inc dx
    ret
loc_0B10C:
    call loc_0B03C
loc_0B10F:
    mov bx, dx
    test word ptr ss:[bp + REC_X], 0Fh
    jne loc_0B134
    dec bx
    call ReadIndexedByteAttribute
    je loc_0B121
    jmp near ptr loc_0B032
loc_0B121:
    test word ptr ds:[0215Ah], 0Fh
    je loc_0B134
    sub bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0B134
    jmp near ptr loc_0B032
loc_0B134:
    dec word ptr ss:[bp + REC_X]
    dec word ptr ds:[0A436h]
    push bx
    call loc_0BDD0
    pop bx
    jae loc_0B14C
    inc word ptr ss:[bp + REC_X]
    inc word ptr ds:[0A436h]
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

loc_0B15A:
    mov cx, POOL_A_COUNT
    mov bx, word ptr ds:[TargetSearchCursor]
loc_0B161:
    cmp bx, offset PoolAEnd
    jae loc_0B19A
    cmp word ptr ds:[bx], 0
    je loc_0B191
    cmp word ptr ds:[bx + 018h], 1
    je loc_0B191
    cmp word ptr ds:[bx + 018h], 026h
    je loc_0B191
    cmp word ptr ds:[bx + 018h], 021h
    je loc_0B191
    cmp word ptr ds:[bx + 018h], 022h
    je loc_0B191
    cmp word ptr ds:[bx + 2], 0E0h
    ja loc_0B191
    cmp word ptr ds:[bx + 016h], 4
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
    mov word ptr ds:[0A43Ah], bx
    pop bx
    ret
TypeHandler0A:
    mov ax, ds:[2328h]
    add ax, 6Dh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_FIELD_1C], 1
    je loc_0B227
    mov ax, ds:[237Eh]
    add ax, 0Ah
    mov ds:[2306h], ax
    mov ax, ds:[2380h]
    add ax, 0Ch
    mov ds:[2304h], ax
    mov word ptr ds:[2308h], 2
    and word ptr ds:[2304h], -4
    and word ptr ds:[2306h], -4
    and word ptr ss:[bp + REC_X], -4
    and word ptr ss:[bp + REC_Y], -4
    call SteerTowardTarget
    cmp word ptr ds:[230Ah], 0
    jne loc_0B1F6
    jmp near ptr loc_0AD60
loc_0B1F6:
    cmp word ptr ds:[0A97Eh], 0
    je loc_0B201
    dec word ptr ds:[0A97Eh]
loc_0B201:
    call loc_0B15A
    cmp bx, -1
    jne loc_0B20C
    jmp near ptr loc_0ADC9
loc_0B20C:
    mov ss:[bp + REC_TARGET], bx
    mov word ptr ss:[bp + REC_FIELD_1C], 1
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0B220
    mov byte ptr ds:[SfxRequest], 11h
loc_0B220:
    inc word ptr ds:[0A97Eh]
    jmp near ptr loc_0AD60
loc_0B227:
    mov bx, ss:[bp + REC_TARGET]
    cmp word ptr ds:[bx], 0
    je loc_0B245
    cmp word ptr ds:[bx + 2], 0DCh
    ja loc_0B245
    cmp word ptr ds:[bx + 18h], 1
    je loc_0B245
    call loc_05E1B
    call loc_05E42
    jmp near ptr loc_0AD5A
loc_0B245:
    mov word ptr ss:[bp + REC_FIELD_1C], 0
    jmp near ptr loc_0AD5A
TypeHandler0B:
    call loc_05E42
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
    call loc_09E19
    pop bp
    pop cx
    loop loc_0B297
    jmp near ptr loc_0ADC9
loc_0B2A3:
    jmp near ptr loc_0AD5A
TypeHandler89:
    mov ax, ds:[233Ch]
    add ax, 1Ch
loc_0B2AC:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[232Ch], 1Fh
    jne loc_0B2B9
    call loc_0BAE1
loc_0B2B9:
    jmp near ptr loc_0BB03
TypeHandler10:
    mov word ptr ss:[bp + REC_FIELD_36], 0A45Ch
    jmp short loc_0B2C8
TypeHandler11:
    mov word ptr ss:[bp + REC_FIELD_36], 0A43Ch
loc_0B2C8:
    mov word ptr ss:[bp + REC_TYPE], 12h
TypeHandler12:
    mov si, ss:[bp + REC_FIELD_36]
    lodsw
    add ax, 20h
    mov ds:[2306h], ax
    lodsw
    mov ds:[2304h], ax
    mov word ptr ds:[2308h], 1
    cmp word ptr ds:[LevelIndex], 0
    je loc_0B2EF
    cmp word ptr ds:[0BDACh], 1
    jne loc_0B2F5
loc_0B2EF:
    mov word ptr ds:[2308h], 2
loc_0B2F5:
    call SteerTowardTarget
    cmp word ptr ds:[230Ah], 0
    je loc_0B304
    mov ss:[bp + REC_FIELD_36], si
    jmp short TypeHandler12
loc_0B304:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 3Bh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[0BDACh], 1
    jne loc_0B317
    jmp near ptr loc_0BC4B
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
    cmp word ptr ds:[2350h], 0E52h
    je loc_0B340
    jmp near ptr loc_0BC4B
loc_0B340:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 105h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B353
    jmp near ptr loc_0BC4B
loc_0B353:
    cmp word ptr ds:[LevelIndex], 6
    jne loc_0B35D
    jmp near ptr loc_0BC4B
loc_0B35D:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 2Ah
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 1
    jne loc_0B370
    jmp near ptr loc_0BC4B
loc_0B370:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0D2h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 2
    jne loc_0B383
    jmp near ptr loc_0BC4B
loc_0B383:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 3
    jne loc_0B396
    jmp near ptr loc_0BC4B
loc_0B396:
    cmp word ptr ds:[LevelIndex], 7
    jne loc_0B3A0
    jmp near ptr loc_0BC4B
loc_0B3A0:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[LevelIndex], 4
    jne loc_0B3B3
    jmp near ptr loc_0BC4B
loc_0B3B3:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 0ECh
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr loc_0BC4B
loc_0B3BF:
    mov ax, ds:[2342h]
    inc ax
    shr ax, 1
    add ax, 71h
    mov ss:[bp + REC_SPRITE], ax
    ret
TypeHandler36:
    call loc_0B3BF
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae loc_0B3DD
    jmp near ptr loc_0BC45
loc_0B3DD:
    jmp short loc_0B3F9
TypeHandler22:
    call loc_0B3BF
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B3EF
    inc word ptr ss:[bp + REC_Y]
loc_0B3EF:
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae loc_0B3F9
    jmp near ptr loc_0BC45
loc_0B3F9:
    call loc_0BFC7
    call loc_0B402
    jmp near ptr loc_0BC45
loc_0B402:
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
    mov ds:[bx + 6], cx
    add cx, 8
    mov ds:[bx + 8], cx
    mov ax, ds:[BurstOriginX]
    mov ds:[bx + 4], ax
    mov ax, ds:[BurstOriginY]
    mov ds:[bx + 2], ax
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 1Eh], 0
    mov word ptr ds:[bx + 0Ah], 1
    mov word ptr ds:[bx + 14h], 0
    mov word ptr ds:[bx + 16h], 2
    mov word ptr ds:[bx + 18h], 3
    mov word ptr ds:[bx + 1Ch], 0FFFFh
    pop cx
    loop loc_0B421
loc_0B467:
    ret
loc_0B468:
    push bp
    mov cx, 23h
    xor ax, ax
loc_0B46E:
    push cx
    push ax
    mov bx, cx
    shl bx, 1
    mov bp, ds:[bx + 32CAh]
    pop ax
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0B486
    cmp word ptr ss:[bp + REC_KIND], 4
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
    jmp near ptr loc_0BC4B
loc_0B49F:
    jmp near ptr loc_0B5D8
loc_0B4A2:
    call loc_0B468
    cmp ax, 1
    je loc_0B4AD
    jmp near ptr loc_0BC4B
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
    call far ptr loc_10079
    mov word ptr ds:[bx + 18h], 76h
    mov word ptr ds:[bx + 8], 20h
    mov ds:[SegBossAnchor], bx
    call FindFreeRecordPoolA
    cmp bx, -1
    je loc_0B54A
    call far ptr loc_10079
    mov word ptr ds:[bx + 18h], 77h
    mov word ptr ds:[bx + 8], 21h
    mov word ptr ds:[bx + 4], 20h
    mov ds:[SegBossPart77], bx
    call FindFreeRecordPoolA
    cmp bx, -1
    je loc_0B54A
    call far ptr loc_10079
    mov word ptr ds:[bx + 18h], 79h
    mov word ptr ds:[bx + 8], 23h
    mov word ptr ds:[bx + 4], 20h
    mov ds:[SegBossPart79], bx
    jmp near ptr loc_0BC4B
loc_0B54A:
    mov word ptr ds:[EncounterLiveCount], 0
    call loc_062AA
    jmp near ptr loc_0BC4B
TypeHandler21:
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
    jmp near ptr loc_0BC4B
loc_0B58A:
    mov word ptr ss:[bp + REC_TYPE], 22h
    mov word ptr ss:[bp + REC_SPRITE], 71h
    mov cx, ds:[LevelIndex]
    inc cx
    mov ax, 0Ah
    mul cx
    mov ss:[bp + REC_HIT_POINTS], ax
    mov word ptr ss:[bp + REC_X], 60h
    jmp near ptr loc_0BC4B

loc_0B5A9:
    mov word ptr ds:[InvaderSlotCursor], offset InvaderFormation
    mov word ptr ds:[InvaderNextMarchLeft], 0
    mov word ptr ds:[InvaderNextDropStep], 0
    ret
loc_0B5BC:
    dec word ptr ds:[EncounterLiveCount]
    mov word ptr ss:[bp + REC_TYPE], 64h
    mov ax, ds:[2380h]
    mov ss:[bp + REC_X], ax
    mov word ptr ss:[bp + REC_Y], 0
    mov word ptr ss:[bp + REC_SPRITE], 8Eh
    jmp near ptr loc_0BC45
loc_0B5D8:
    mov word ptr ds:[FramesSinceInvaderSpawn], 0
    cmp word ptr ds:[InvaderSlotCursor], offset InvaderFormationEnd
    je loc_0B5BC
    mov si, ds:[InvaderSlotCursor]
    push si
    call loc_081F4
    pop si
    cmp bx, -1
    je loc_0B612
    lodsw
    add ax, 20h
    mov ds:[bx + 34h], ax
    lodsw
    mov ds:[bx + 32h], ax
    mov word ptr ds:[bx + 18h], 61h
    mov word ptr ds:[bx + 8], 0E7h
    inc word ptr ds:[EncounterLiveCount]
    add word ptr ds:[InvaderSlotCursor], 4
loc_0B612:
    jmp near ptr loc_0BC4B
loc_0B615:
    cmp word ptr ds:[2328h], 7
    je loc_0B61F
    jmp near ptr loc_0BC4B
loc_0B61F:
    call loc_081E9
    cmp bx, -1
    jne loc_0B62A
    jmp near ptr loc_0BC4B
loc_0B62A:
    call loc_0B673
    mov word ptr ds:[bx + 34h], 10h
    mov word ptr ds:[bx + 18h], 23h
    cmp word ptr ds:[LevelIndex], 1
    je loc_0B65E
    cmp word ptr ds:[LevelIndex], 2
    je loc_0B656
    cmp word ptr ds:[LevelIndex], 3
    je loc_0B65E
    cmp word ptr ds:[LevelIndex], 5
    je loc_0B65E
    jmp near ptr loc_0BC4B
loc_0B656:
    mov word ptr ds:[bx + 20h], 1
    jmp near ptr loc_0BC4B
loc_0B65E:
    mov word ptr ds:[bx + 20h], 0FFFFh
    mov ax, ds:[2340h]
    inc word ptr ds:[2340h]
    and ax, 3
    mov ds:[bx + 1Ch], ax
    jmp near ptr loc_0BC4B
loc_0B673:
    mov si, ds:[FallerColumnCursor]
    cmp si, offset FallerColumnsEnd
    jb loc_0B687
    mov word ptr ds:[FallerColumnCursor], offset FallerColumns
    mov si, ds:[FallerColumnCursor]
loc_0B687:
    lodsw
    mov ds:[bx + 32h], ax
    mov ds:[FallerColumnCursor], si
    ret
TypeHandler23:
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
    jmp near ptr loc_0BC4B
loc_0B701:
    mov bx, bp
    call loc_074E2
    mov word ptr ss:[bp + REC_TYPE], 2Ch
    jmp near ptr loc_0BC4B
TypeHandler2C:
    mov ax, ds:[233Ch]
    add ax, 0B9h
    mov ss:[bp + REC_SPRITE], ax
    mov word ptr ds:[2312h], 2
    call loc_05E42
    mov word ptr ds:[2312h], 3
    jmp near ptr loc_0BC4B
loc_0B729:
    mov ax, word ptr ss:[bp + REC_SAVED_X]
    mov word ptr ds:[SteerTargetX], ax
    mov ax, word ptr ss:[bp + REC_SAVED_Y]
    mov word ptr ds:[SteerTargetY], ax
    call SteerTowardTarget
    cmp word ptr ds:[SteerArrived], 0
    ret
TypeHandler20:
    cmp word ptr ss:[bp + REC_FIELD_1C], -1
    je loc_0B791
    mov bx, word ptr ss:[bp + REC_FIELD_1C]
    shl bx, 1
    jmp word ptr cs:[bx + TypeHandler20Cases]
TypeHandler20Cases label word
    dw offset loc_0B754, offset loc_0B770, offset loc_0B77B
loc_0B754:
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
    jmp near ptr loc_0BC4B
loc_0B770:
    mov word ptr ss:[bp + REC_SPRITE], 079h
    inc word ptr ss:[bp + REC_FIELD_1C]
    jmp near ptr loc_0BC4B
loc_0B77B:
    add word ptr ss:[bp + REC_Y], 4
    cmp word ptr ss:[bp + REC_Y], 0A0h
    jae loc_0B789
    jmp near ptr loc_0BC4B
loc_0B789:
    mov word ptr ss:[bp + REC_SPRITE], 077h
    jmp near ptr loc_0BC4B
loc_0B791:
    mov ax, word ptr ds:[02338h]
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
    jmp near ptr loc_0BC4B
loc_0B7C7:
    cmp word ptr ds:[02324h], 1
    je loc_0B7D7
loc_0B7CE:
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    mov word ptr ss:[bp + REC_SAVED_X], ax
loc_0B7D7:
    and word ptr ss:[bp + REC_SAVED_X], 0FFF8h
    mov word ptr ds:[02340h], 028h
    mov word ptr ss:[bp + REC_FIELD_1C], 0
    mov word ptr ss:[bp + REC_SPRITE], 078h
    mov word ptr ss:[bp + REC_SAVED_Y], 020h
    jmp near ptr loc_0BC4B
loc_0B7F3:
    cmp word ptr ds:[02340h], 02BCh
    jb loc_0B80E
    cmp word ptr ds:[02340h], 02D0h
    ja loc_0B80E
    call loc_04D95
    and bx, 1
    jne loc_0B80E
    call loc_07476
loc_0B80E:
    cmp word ptr ds:[EncounterLiveCount], 3
    jbe loc_0B7C7
    cmp word ptr ds:[02340h], 5
    jb loc_0B7CE
    cmp word ptr ds:[0232Eh], 03Fh
    je loc_0B826
    jmp near ptr loc_0BC4B
loc_0B826:
    mov si, word ptr ds:[FormationSlotCursor]
    cmp si, 0A894h
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
    jmp near ptr loc_0BC4B
loc_0B85C:
    mov word ptr ds:[SteerSpeed], 2
    call loc_0B729
    mov word ptr ss:[bp + REC_DIRECTION], 4
    jmp near ptr loc_0BC4B
TypeHandler1D:
    cmp word ptr ds:[EncounterLiveCount], 2
    ja loc_0B877
    jmp near ptr loc_0B8F8
loc_0B877:
    cmp word ptr ss:[bp + REC_Y], 0C0h
    ja loc_0B8F8
    cmp word ptr ds:[EncounterTicks], 28h
    jae loc_0B8B0
    mov word ptr ds:[2308h], 1
    mov word ptr ss:[bp + REC_SPRITE], 75h
    and word ptr ss:[bp + REC_SAVED_X], -2
    and word ptr ss:[bp + REC_X], -2
    and word ptr ss:[bp + REC_SAVED_Y], -2
    and word ptr ss:[bp + REC_Y], -2
    call loc_0B729
    jne loc_0B8A8
    jmp near ptr loc_0BC4B
loc_0B8A8:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    jmp near ptr loc_0BC4B
loc_0B8B0:
    cmp word ptr ds:[2340h], 2EFh
    jne loc_0B8BB
    call loc_07476
loc_0B8BB:
    cmp word ptr ds:[2340h], 159h
    jne loc_0B8C6
    call loc_07476
loc_0B8C6:
    cmp word ptr ds:[2340h], 79h
    jne loc_0B8D0
    call loc_07476
loc_0B8D0:
    mov ax, ds:[2342h]
    neg ax
    add ss:[bp + REC_Y], ax
    mov ax, 75h
    cmp word ptr ds:[2342h], -1
    je loc_0B8E5
    mov ax, 76h
loc_0B8E5:
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[2328h], 7
    je loc_0B8F2
    jmp near ptr loc_0BC4B
loc_0B8F2:
    inc word ptr ss:[bp + REC_Y]
    jmp near ptr loc_0BC4B
loc_0B8F8:
    mov bx, 237Ch
    call loc_05E1B
    call loc_05E42
    mov word ptr ss:[bp + REC_SPRITE], 76h
    jmp near ptr loc_0BC4B
TypeHandler1E:
    mov word ptr ds:[2308h], 2
    call loc_0B729
    jne loc_0B917
    jmp near ptr loc_0BC4B
loc_0B917:
    call loc_07476
    cmp word ptr ss:[bp + REC_SAVED_X], 0
    je loc_0B928
    mov word ptr ss:[bp + REC_SAVED_X], 0
    jmp near ptr loc_0BC4B
loc_0B928:
    mov word ptr ss:[bp + REC_SAVED_X], 0C0h
    jmp near ptr loc_0BC4B
TypeHandler16:
    mov word ptr ds:[2308h], 1
    cmp word ptr ds:[LevelIndex], 0
    jne loc_0B943
    mov word ptr ds:[2308h], 2
loc_0B943:
    call loc_0B729
    pushf
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 10Dh
    mov ss:[bp + REC_SPRITE], ax
    popf
    jne loc_0B956
    jmp near ptr loc_0BC4B
loc_0B956:
    cmp word ptr ss:[bp + REC_FIELD_1C], 0
    je loc_0B97A
    dec word ptr ss:[bp + REC_FIELD_1C]
    je loc_0B964
    jmp near ptr loc_0BC4B
loc_0B964:
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
    cmp word ptr ss:[bp + REC_TYPE], 16h
    jne loc_0B972
    jmp near ptr loc_0BC4B
loc_0B972:
    mov word ptr ss:[bp + REC_SAVED_Y], 40h
    jmp near ptr loc_0BC4B
loc_0B97A:
    cmp word ptr ds:[EncounterTicks], 31h
    je loc_0B984
    jmp near ptr loc_0BC4B
loc_0B984:
    mov word ptr ss:[bp + REC_TYPE], 18h
    jmp near ptr loc_0BC4B
TypeHandler18:
    mov ax, ds:[2340h]
    and ax, 3FFh
    cmp ax, 0Ch
    jne loc_0B99E
    call loc_07476
    inc word ptr ds:[2340h]
loc_0B99E:
    mov si, ss:[bp + REC_FIELD_36]
    lodsw
    cmp ax, 0FFFFh
    je loc_0B9EA
    add ax, 20h
    mov ds:[2306h], ax
    lodsw
    mov ds:[2304h], ax
    mov word ptr ds:[2308h], 3
    call SteerTowardTarget
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 10Dh
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[230Ah], 0
    jne loc_0B9CD
    jmp near ptr loc_0BC4B
loc_0B9CD:
    mov ss:[bp + REC_FIELD_36], si
    call loc_04D95
    and bx, 7
    cmp bx, 2
    jne TypeHandler18
    call SpawnThrottledChild
    cmp bx, -1
    je TypeHandler18
    mov word ptr ds:[bx + 6], 4
    jmp short TypeHandler18
loc_0B9EA:
    lodsw
    mov ss:[bp + REC_FIELD_36], ax
    jmp short TypeHandler18
TypeHandler14:
    cmp word ptr ds:[LeaderScriptCursor], offset LeaderScript13End
    jne loc_0BA67
    cmp word ptr ds:[2340h], 2EFh
    jne loc_0BA07
    call loc_07476
    inc word ptr ds:[2340h]
loc_0BA07:
    mov ax, ds:[2342h]
    add ss:[bp + REC_SAVED_X], ax
    mov ax, ds:[2346h]
    add ss:[bp + REC_SAVED_Y], ax
    cmp word ptr ss:[bp + REC_SAVED_Y], 0D0h
    jna loc_0BA1F
    mov word ptr ss:[bp + REC_SAVED_Y], 20h
loc_0BA1F:
    mov ax, ss:[bp + REC_X]
    add ax, ds:[2342h]
    cmp ax, ss:[bp + REC_SAVED_X]
    jne loc_0BA99
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    jne loc_0BA99
    cmp word ptr ds:[EncounterLiveCount], 6
    jb loc_0BA5A
    mov ax, ds:[2340h]
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
    inc word ptr ds:[2340h]
loc_0BA5A:
    mov bx, 237Ch
    call loc_05E1B
    call loc_05E42
    add word ptr ss:[bp + REC_Y], 2
loc_0BA67:
    mov ax, ds:[233Ch]
    add ax, 1Ch
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr loc_0BC4B
loc_0BA73:
    mov ax, ss:[bp + REC_SAVED_X]
    and ax, 0FFFEh
    and word ptr ss:[bp + REC_X], -2
    mov ds:[2304h], ax
    mov ax, ss:[bp + REC_SAVED_Y]
    and ax, 0FFFEh
    and word ptr ss:[bp + REC_Y], -2
    mov ds:[2306h], ax
    mov word ptr ds:[2308h], 1
    call SteerTowardTarget
    jmp near ptr loc_0BC4B
loc_0BA99:
    mov ax, ss:[bp + REC_Y]
    cmp ax, ss:[bp + REC_SAVED_Y]
    jna loc_0BA73
    call loc_05E42
    cmp word ptr ds:[EncounterLiveCount], 6
    jae loc_0BAB5
    cmp word ptr ds:[232Eh], 3Fh
    jne loc_0BAB5
    call loc_07476
loc_0BAB5:
    cmp word ptr ss:[bp + REC_Y], 0D0h
    ja loc_0BABF
    jmp near ptr loc_0BC4B
loc_0BABF:
    mov word ptr ss:[bp + REC_Y], 10h
    jmp near ptr loc_0BC4B
TypeHandler1B:
    mov ax, ds:[2338h]
    shr ax, 1
    add ax, 27h
    mov ss:[bp + REC_SPRITE], ax
    jmp short loc_0BADF
TypeHandler1A:
    mov ax, ds:[2338h]
    shr ax, 1
    add ax, 24h
    mov ss:[bp + REC_SPRITE], ax
loc_0BADF:
    jmp short loc_0BB03
loc_0BAE1:
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], 4
    call SpawnThrottledChild
    pop word ptr ss:[bp + REC_DIRECTION]
    ret
TypeHandler19:
    mov ax, ds:[233Ah]
    add ax, 36h
    mov ss:[bp + REC_SPRITE], ax
    cmp word ptr ds:[232Eh], 3Fh
    jne loc_0BB03
    call loc_0BAE1
loc_0BB03:
    cmp word ptr ss:[bp + REC_DIRECTION], 6
    jne loc_0BB24
    mov word ptr ss:[bp + REC_DIRECTION], 6
    cmp word ptr ss:[bp + REC_X], 0
    je loc_0BB1C
    call loc_0AFD8
    jne loc_0BB1C
    jmp near ptr loc_0BC45
loc_0BB1C:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    jmp near ptr loc_0BC45
loc_0BB24:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    cmp word ptr ss:[bp + REC_X], 0C0h
    je loc_0BB38
    call loc_0AFD8
    jne loc_0BB38
    jmp near ptr loc_0BC45
loc_0BB38:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    jmp near ptr loc_0BC45
TypeHandler8D:
    mov word ptr ds:[WalkerFacingStep], 0FFFFh
    jmp short loc_0BB4E
TypeHandler8E:
    mov word ptr ds:[WalkerFacingStep], 1
loc_0BB4E:
    call loc_0BBED
    mov bx, 0
    je loc_0BB60
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx - 692Eh]
loc_0BB60:
    mov ax, 13Ah
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, ds:[WalkerFacingStep]
    add ax, bx
    xor cx, cx
    cmp word ptr ss:[bp + REC_DIRECTION], 0
    je loc_0BB7C
    mov cx, 3
loc_0BB7C:
    add ax, cx
    jmp short loc_0BBB2
TypeHandler8C:
    mov word ptr ds:[WalkerFacingStep], 0FFFFh
    jmp short loc_0BB8E
TypeHandler8B:
    mov word ptr ds:[WalkerFacingStep], 1
loc_0BB8E:
    call loc_0BBED
    mov bx, 0
    je loc_0BB9A
    mov bx, ds:[233Ch]
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
    cmp word ptr ds:[2330h], 7Fh
    je loc_0BBCA
    cmp word ptr ds:[2330h], 6Bh
    je loc_0BBCA
    cmp word ptr ds:[2330h], 57h
    jne loc_0BC45
loc_0BBCA:
    call loc_07476
    cmp bx, -1
    je loc_0BC45
    mov word ptr ds:[bx + 8], 3
    sub word ptr ds:[bx + 4], 8
    sub word ptr ds:[bx + 2], 8
    jmp short loc_0BC45
loc_0BBE1:
    mov word ptr ds:[0A430h], 1
    cmp word ptr ds:[0A430h], 1
    ret
loc_0BBED:
    mov word ptr ds:[0A430h], 0
    mov word ptr ss:[bp + REC_DIRECTION], 0
    push word ptr ss:[bp + REC_Y]
    mov ax, ds:[StackTop]
    add ss:[bp + REC_Y], ax
    sub word ptr ss:[bp + REC_Y], 10h
    call ComputeRecordGridOffset
    pop word ptr ss:[bp + REC_Y]
    cmp bx, -1
    je loc_0BBE1
    mov ax, ss:[bp + REC_Y]
    cmp ax, ds:[237Eh]
    jl loc_0BC2B
    add bx, ds:[WalkerFacingStep]
    call ReadIndexedByteAttribute
    je loc_0BBE1
    call loc_0AFD8
    cmp word ptr ds:[0A430h], 1
    ret
loc_0BC2B:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    add bx, ds:[WalkerFacingStep]
    sub bx, 0Dh
    call ReadIndexedByteAttribute
    je loc_0BBE1
    call loc_0AFD8
    cmp word ptr ds:[0A430h], 1
    ret
loc_0BC45:
    mov ax, word ptr ds:[ScrollDeltaY]
    add word ptr ss:[bp + REC_Y], ax
loc_0BC4B:
    call loc_0BCB1
    cmp word ptr ds:[0A47Ch], 0
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
    jmp near ptr loc_0BD17
loc_0BC8A:
    cmp word ptr ss:[bp + REC_Y], 0F0h
    jl loc_0BC94
    jmp near ptr loc_0BD17
loc_0BC94:
    jmp short loc_0BCA3
loc_0BC96:
    cmp word ptr ss:[bp + REC_Y], -014h
    jl loc_0BD17
    cmp word ptr ss:[bp + REC_Y], 0F0h
    jge loc_0BD17
loc_0BCA3:
    cmp word ptr ds:[0A47Ch], 0
    jne loc_0BCB0
    call loc_0BCCB
    call loc_062F6
loc_0BCB0:
    ret

loc_0BCB1:
    cmp word ptr ss:[bp + 4], 0C0h
    jg loc_0BCBF
    cmp word ptr ss:[bp + 4], 0
    jl loc_0BCC5
    ret
loc_0BCBF:
    mov word ptr ss:[bp + 4], 0C0h
    ret
loc_0BCC5:
    mov word ptr ss:[bp + 4], 0
    ret
loc_0BCCB:
    cmp word ptr ss:[bp], 0
    jne loc_0BCD2
    ret
loc_0BCD2:
    cmp word ptr ss:[bp + 016h], 5
    jne loc_0BCD9
    ret
loc_0BCD9:
    cmp word ptr ss:[bp + 018h], 0
    jne loc_0BCE0
    ret
loc_0BCE0:
    cmp word ptr ss:[bp + 018h], 1
    jne loc_0BCE7
    ret
loc_0BCE7:
    cmp word ptr ss:[bp + 014h], 1
    je loc_0BCF4
    cmp word ptr ss:[bp + 014h], 2
    je loc_0BCF9
    ret
loc_0BCF4:
    call loc_0AA46
    jmp short loc_0BCFC
loc_0BCF9:
    call loc_0AA71
loc_0BCFC:
    jb loc_0BCFF
    ret
loc_0BCFF:
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BD09
    call loc_0BFC7
loc_0BD09:
    call loc_09E69
    ret
loc_0BD0D:
    push bp
    mov bp, bx
    call loc_0BD17
    mov bx, bp
    pop bp
    ret

loc_0BD17:
    mov word ptr ss:[bp + REC_STATUS], 0
    cmp word ptr ss:[bp + REC_KIND], 4
    je loc_0BD5C
    cmp word ptr ss:[bp + REC_KIND], 1
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
    mov word ptr ss:[bp + REC_KIND], 2
    ret
loc_0BD5C:
    call loc_0C054
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
    add si, 02078h
    mov byte ptr ds:[si], 0
    ret
loc_0BD7A:
    cmp word ptr ds:[0A972h], 0
    jne loc_0BD82
    ret
loc_0BD82:
    mov cx, 01Ah
    mov si, 0A3B4h
loc_0BD88:
    lodsw
    cmp ax, 0FFFFh
    jne loc_0BD8F
    ret
loc_0BD8F:
    mov word ptr ds:[si - 2], ax
    mov bx, ax
    mov word ptr ds:[bx], 0
    dec word ptr ds:[0A972h]
    jmp short loc_0BD88
loc_0BD9E:
    cmp word ptr ds:[0A97Eh], 0
    je loc_0BDA9
    dec word ptr ds:[0A97Eh]
loc_0BDA9:
    jmp near ptr loc_0AC19
loc_0BDAC:
    cmp word ptr ds:[0A970h], 0
    je loc_0BDB7
    dec word ptr ds:[0A970h]
loc_0BDB7:
    ret
loc_0BDB8:
    cmp word ptr ds:[0A974h], 0
    je loc_0BDC3
    dec word ptr ds:[0A974h]
loc_0BDC3:
    ret
loc_0BDC4:
    cmp word ptr ds:[0A976h], 0
    je loc_0BDCF
    dec word ptr ds:[0A976h]
loc_0BDCF:
    ret
loc_0BDD0:
    cmp word ptr ss:[bp + REC_DRAW_PASS], 1
    je loc_0BE3A
    mov cx, POOL_A_COUNT
    mov bx, offset PoolA
    mov ax, word ptr ds:[0A436h]
    mov di, word ptr ds:[0A438h]
loc_0BDE3:
    cmp word ptr ds:[bx], 0
    je loc_0BE35
    cmp word ptr ds:[bx + 0Ah], 1
    je loc_0BE35
    cmp word ptr ds:[bx + 014h], 1
    jne loc_0BE35
    cmp word ptr ds:[bx + 016h], 4
    jne loc_0BE35
    cmp word ptr ds:[bx + 018h], 082h
    jb loc_0BE35
    cmp word ptr ds:[bx + 018h], 094h
    ja loc_0BE35
    mov si, word ptr ds:[bx + 2]
    add si, 010h
    cmp di, si
    jge loc_0BE35
    sub si, 020h
    cmp di, si
    jle loc_0BE35
    mov si, word ptr ds:[bx + 4]
    add si, 010h
    cmp ax, si
    jge loc_0BE35
    sub si, 020h
    cmp ax, si
    jle loc_0BE35
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    cmp si, word ptr ds:[bx + 0Eh]
    je loc_0BE35
    jmp near ptr loc_05059
loc_0BE35:
    add bx, RECORD_SIZE
    loop loc_0BDE3
loc_0BE3A:
    clc
    ret
TypeHandler01:
    cmp word ptr ds:[02324h], 1
    je loc_0BE46
    jmp near ptr loc_0BC45
loc_0BE46:
    inc word ptr ss:[bp + REC_ANIM_COUNTER]
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0BE46Cases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0BE46Cases label word
    dw offset loc_0BC45, offset loc_0BE5A, offset loc_0BEB0
loc_0BE5A:
    cmp word ptr ss:[bp + REC_ANIM_COUNTER], 9
    jne loc_0BEA4
    cmp word ptr ss:[bp + REC_PREV_TYPE], 024h
    je loc_0BE6F
    cmp word ptr ss:[bp + REC_PREV_TYPE], 025h
    je loc_0BE84
    jmp near ptr loc_0BD17
loc_0BE6F:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    mov word ptr ss:[bp + REC_TYPE], 026h
    mov word ptr ss:[bp + REC_SPRITE], 097h
    sub word ptr ss:[bp + REC_X], 8
    jmp short loc_0BE97
loc_0BE84:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    mov word ptr ss:[bp + REC_TYPE], 026h
    mov word ptr ss:[bp + REC_SPRITE], 091h
    add word ptr ss:[bp + REC_X], 8
loc_0BE97:
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    ret
loc_0BEA4:
    mov ax, word ptr ss:[bp + REC_ANIM_COUNTER]
    add ax, 0
    mov word ptr ss:[bp + REC_SPRITE], ax
    jmp near ptr loc_0BC45
loc_0BEB0:
    cmp word ptr ss:[bp + REC_ANIM_COUNTER], 0Ch
    jne loc_0BEB9
    jmp near ptr loc_0BD17
loc_0BEB9:
    mov ax, ss:[bp + REC_ANIM_COUNTER]
    add ax, 3
    mov ss:[bp + REC_SPRITE], ax
    jmp near ptr loc_0BC45
loc_0BEC5:
    cmp word ptr ds:[bx + 018h], 7
    jne loc_0BECE
    jmp near ptr loc_0BFB9
loc_0BECE:
    cmp word ptr ds:[bx + 018h], 8
    jne loc_0BED7
    jmp near ptr loc_0BFB9
loc_0BED7:
    cmp word ptr ds:[bx + 018h], 0Ch
    jne loc_0BEE0
    jmp near ptr loc_0BFB9
loc_0BEE0:
    cmp word ptr ds:[bx + 018h], 9
    jne loc_0BEE9
    jmp near ptr loc_0BFA8
loc_0BEE9:
    cmp word ptr ds:[bx + 018h], 2
    je loc_0BF1B
    cmp word ptr ds:[bx + 018h], 6
    jne loc_0BEF8
    jmp near ptr loc_0BF97
loc_0BEF8:
    cmp word ptr ds:[bx + 018h], 5
    jne loc_0BF01
    jmp near ptr loc_0BF97
loc_0BF01:
    cmp bp, word ptr ds:[bx + 030h]
    je loc_0BF07
    ret
loc_0BF07:
    mov word ptr ds:[bx + 01Ch], 0
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BF25
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp near ptr loc_0BFC7
loc_0BF1B:
    mov word ptr ds:[bx], 0
    cmp word ptr ds:[bx + 8], 033h
    jne loc_0BF2D
loc_0BF25:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    jne loc_0BF2D
    jmp near ptr loc_0BFC7
loc_0BF2D:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    jne loc_0BF35
    jmp near ptr loc_0BFC7
loc_0BF35:
    cmp word ptr ds:[DifficultySetting], 1
    je loc_0BF4D
    cmp word ptr ds:[DifficultySetting], 0
    jne loc_0BF52
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je loc_0BFC7
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je loc_0BFC7
loc_0BF4D:
    dec word ptr ss:[bp + REC_HIT_POINTS]
    je loc_0BFC7
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
    call loc_0BD0D
    jmp short loc_0BF25
loc_0BF97:
    call loc_0BD0D
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BF25
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short loc_0BFC7
loc_0BFA8:
    cmp word ptr ds:[SegBossActive], 1
    jne loc_0BFB2
    jmp near ptr loc_0BF25
loc_0BFB2:
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short loc_0BFC7
loc_0BFB9:
    cmp word ptr ds:[SegBossActive], 1
    je loc_0BF92
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short loc_0BFC7
loc_0BFC7:
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
    call loc_05F0D
    call loc_0BCB1
    push bp
    cmp word ptr ss:[bp + REC_SLOT_INDEX], -1
    je loc_0C017
    mov si, word ptr ss:[bp + REC_SLOT_INDEX]
    shl si, 1
    add si, 02078h
    cmp byte ptr ds:[si], 0
    je loc_0C017
    dec byte ptr ds:[si]
    jne loc_0C017

    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[02376h], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[02378h], ax
    mov al, byte ptr ds:[si + 1]
    xor ah, ah
    mov word ptr ds:[0237Ah], ax
    call loc_07420
loc_0C017:
    pop bp
    call loc_0C054
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
    jmp word ptr cs:[bx + loc_0C027Cases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0C027Cases label word
    dw offset CountXReturn, offset loc_0C048, offset loc_0C04E
loc_0C048:
    mov word ptr ss:[bp + REC_SPRITE], 0
    ret
loc_0C04E:
    mov word ptr ss:[bp + REC_SPRITE], 3
    ret


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
    mov word ptr ds:[02376h], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[02378h], ax
    mov ax, 2
    mov word ptr ds:[0237Ah], ax
    call loc_07420
    pop bp
    pop bx
loc_0C14F:
    dec word ptr ds:[EncounterLiveCount]
    ret
loc_0C154:
    mov byte ptr ds:[098A8h], 1
    jmp short loc_0C14F
loc_0C15B:
    mov bx, word ptr ds:[SegBossAnchor]
    cmp bx, bp
    je loc_0C166
    call loc_0C194
loc_0C166:
    mov bx, word ptr ds:[SegBossPart77]
    cmp bx, bp
    je loc_0C171
    call loc_0C194
loc_0C171:
    mov bx, word ptr ds:[SegBossCore]
    cmp bx, bp
    je loc_0C17C
    call loc_0C194
loc_0C17C:
    mov bx, word ptr ds:[SegBossPart79]
    cmp bx, bp
    je loc_0C187
    call loc_0C194
loc_0C187:
    mov word ptr ds:[EncounterLiveCount], 0
    mov word ptr ds:[SegBossActive], 0
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
; BP = record: turn it toward the primary (REC_DIRECTION from AimQuadrantBits;
; unchanged when aligned, then return) and continue in loc_0AFD8.
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
    jmp near ptr loc_0AFD8

; BP = parent: as SpawnThrottledChild without the throttle, the child placed at
; parent +0Ch,+0Ch instead of +4,+4.
loc_0C21D:
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
    add ds:[bx + si], al

loc_0C3A6:
    mov es, word ptr cs:[MainDataSegment]
    mov di, 02078h
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
    cmp word ptr ss:[bp + REC_KIND], 1
    je loc_0C41E
    mov word ptr ss:[bp + REC_STATUS], 0
    mov word ptr ss:[bp + REC_STEP_ERROR], 0
    mov word ptr ss:[bp + REC_FLASH_TIMER], 0
    mov word ptr ss:[bp + REC_TYPE], 0
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_0C41E:
    mov ax, word ptr cs:[SaveBufferCursor]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[SaveBufferCursor], POOL_A_SAVE_BYTES
    pop cx
    loop loc_0C3F1
    mov bp, offset PrimaryRecord
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
    mov word ptr ds:[OffsetXGroupA], 0
    mov word ptr ds:[OffsetXGroupB], 0
    mov word ptr ds:[09788h], 0FFFFh
    call loc_09DB9
    mov word ptr ds:[0A980h], 0
    mov word ptr ds:[020A6h], 020A8h
    mov word ptr ds:[EncounterLiveCount], 0
    mov word ptr ds:[EncounterEndDelay], 0
    mov word ptr ds:[0A47Ch], 0
    mov word ptr ds:[02340h], 0
    ret

loc_0C4DB:
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
    mov word ptr ss:[bp + REC_DIRECTION], 0
    mov ax, word ptr cs:[SaveBufferCursor]
    mov word ptr ss:[bp + REC_SAVE_BUFFER], ax
    add word ptr cs:[SaveBufferCursor], POOL_A_SAVE_BYTES
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
    mov word ptr ds:[PrimaryRecord + REC_SPRITE], 0
    call loc_08517
    jmp near ptr loc_0859E
loc_0C565:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0C565Cases]
loc_0C565Cases label word
    dw offset loc_04F37, offset loc_04FC3, offset loc_04F57, offset loc_04FC3
    dw offset loc_04F37, offset loc_04F57

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
    mov dx, offset SoundModuleNameTandy
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
    mov dx, offset SoundModuleNameRoland
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
    mov dx, offset SoundModuleNameAdlib
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

loc_0CB3E:
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
    call loc_0CBD5
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
    call DrawOffsetFromWideRow
    mov word ptr ds:[0BD9Eh], di
    mov si, di
    add si, 07D00h
    xor dl, dl
    mov es, word ptr cs:[WorkspaceSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + loc_0CC7FCases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0CC7FCases label word
    dw offset loc_0CCAA, offset loc_0CCF0, offset loc_0CCC4

loc_0CCAA:
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

loc_0CCC4:
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

loc_0CCF0:
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
    call DrawOffsetFromScreenRow
    push di
    mov si, 012h
    shl si, 1
    add si, offset BlueBitsImageOffsets
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[BlueBitsSegment]
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
    jmp word ptr cs:[bx + loc_0CD68Cases]
; UNKNOWN: not yet classified as code or data
    db 090h
loc_0CD68Cases label word
    dw offset loc_0CD8A, offset loc_0CDCC, offset loc_0CDA7

loc_0CD8A:
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

loc_0CDA7:
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

loc_0CDCC:
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
    call DrawOffsetFromWideRow
    add di, 07D00h
    pop si
    lodsb
    mov word ptr ds:[0BD98h], si
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

loc_0CE97:
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
    call DrawOffsetFromScreenRow
    pop si
    mov al, byte ptr ds:[si - 04251h]
    xor ah, ah
    mov si, ax
    shl si, 1
    add si, offset PanelImageOffsets
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
    mov word ptr ds:[MapScrollPos], 09Ch
    call InitPositionHistory
; Clear the shared byte-attribute table before calling the setup path at 007EF.
; Forward fill requires DF=0; this is state initialization, not static table contents.
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset ByteAttributeTable
    mov cx, BYTE_ATTRIBUTE_COUNT
    xor al, al
    rep stosb
    call loc_007EF
    mov bp, offset PrimaryRecord
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
    mov word ptr ds:[ScrollDeltaY], 0
    mov al, 01Fh
    mov ah, 018h
    call DrawOffsetFromScreenRow
    mov bx, word ptr ds:[0BE06h]
    shl bx, 1
    mov ax, bx
    shl bx, 1
    add bx, ax
    mov si, word ptr ds:[bx - 041E8h]
    shl si, 1
    add si, offset PanelImageOffsets
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
    mov bp, offset PrimaryRecord
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
    jmp word ptr cs:[bx + loc_0D107Cases]
loc_0D107Cases label word
    dw offset CountXReturn, offset loc_0D19F, offset loc_0D229, offset loc_0D183
    dw offset loc_0D24A, offset loc_0D183, offset loc_0D1DC, offset loc_0D1F8
    dw offset CountXReturn, offset CountXReturn, offset loc_0D14D, offset loc_0D152
    dw offset loc_0D14D, offset loc_0D14D, offset loc_0D14D, offset loc_0D14D
    dw offset loc_0D13A, offset loc_0D159, offset CountXReturn, offset CountXReturn
loc_0D13A:
    call loc_081F4
    mov word ptr ds:[bx + 4], 0C0h
    mov word ptr ds:[bx + 2], 0C8h
    mov word ptr ds:[bx + 18h], 51h
    ret
loc_0D14D:
    inc word ptr ds:[0A958h]
    ret
loc_0D152:
    mov word ptr ds:[0A95Eh], 1
    ret
loc_0D159:
    mov word ptr ds:[0A960h], 1
    ret
loc_0D160:
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
    mov word ptr ds:[0BE08h], 032h
    ret
loc_0D183:
    inc word ptr ds:[PrimaryRecord + REC_SPRITE]
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D193
    mov byte ptr ds:[SfxRequest], 6
loc_0D193:
    mov word ptr ds:[0BE08h], 032h
    mov bp, offset PrimaryRecord
    jmp near ptr PlaceFourRecordsFromOffsetTables
loc_0D19F:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D1AB
    mov byte ptr ds:[SfxRequest], 01Eh
loc_0D1AB:
    mov bp, offset PrimaryRecord
    call FindFreeRecordPoolA
    mov word ptr ds:[0A96Eh], bx
    call loc_08209
    mov word ptr ds:[bx + 2], 0
    mov word ptr ds:[bx + 8], 0Fh
    mov word ptr ds:[bx + 018h], 050h
    mov bp, bx
    mov ax, word ptr ds:[PrimaryRecord + REC_X]
    add ax, 8
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov ax, word ptr ds:[PrimaryRecord + REC_Y]
    sub ax, 8
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    ret
loc_0D1DC:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D1E8
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0D1E8:
    call loc_09F1A
    mov bp, ds:[HistoryRecordSlot15]
    call loc_0D213
    mov word ptr ss:[bp + REC_X], 0
    ret
loc_0D1F8:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D204
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0D204:
    call loc_09F1A
    mov bp, ds:[HistoryRecordSlot31]
    call loc_0D213
    add word ptr ss:[bp + REC_SAVED_Y], 14h
    ret
loc_0D213:
    call loc_0D269
    mov ax, ds:[2380h]
    add ax, 8
    mov ss:[bp + REC_SAVED_X], ax
    mov ax, ds:[237Eh]
    add ax, 28h
    mov ss:[bp + REC_SAVED_Y], ax
    ret
loc_0D229:
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
loc_0D24A:
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0D256
    mov byte ptr ds:[SfxRequest], 1Eh
loc_0D256:
    call loc_09F5F
    mov bp, ds:[PlusSlotA96A]
    call loc_0D269
    mov word ptr ss:[bp + REC_X], 0
    mov bp, ds:[MinusSlotA96C]
loc_0D269:
    call loc_0BE97
    mov word ptr ss:[bp + REC_Y], 0C8h
    mov word ptr ss:[bp + REC_X], 0C0h
    mov word ptr ss:[bp + REC_TYPE], 050h
    mov word ptr ss:[bp + REC_KIND], 4
    ret
TypeHandler50:
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
    mov word ptr ss:[bp + REC_KIND], 1
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
    call ClearByteCS066B
    call loc_0511F
    call DrawStars
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_0D32C
    call CopyWorkspaceToScreen
loc_0D32C:
    call loc_0D367
    call EraseStars
    call far ptr MoveStars
    call loc_0073C
    call loc_060A2
    call loc_05160
    call WaitByteCS066B
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

loc_0D367:
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
    call loc_05145
    mov byte ptr ds:[LoadIsEnc], 1
    mov word ptr cs:[LoadNamePtr], offset File_LEVSCR_ENC
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[LoadDestSegment], ax
    mov word ptr cs:[LoadDestOffset], 08000h
    mov word ptr cs:[LoadImageSlot], offset ScreenImageOffset
    mov byte ptr cs:[045EDh], 0
    call LoadGraphicsRecordImages
    mov byte ptr cs:[045EDh], 1
    mov word ptr cs:[LoadNamePtr], offset File_CHOOSE_ENC
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr cs:[LoadDestSegment], ax
    mov word ptr cs:[LoadDestOffset], 04000h
    mov word ptr cs:[LoadImageSlot], offset ChooseImageOffsets
    mov word ptr ds:[021C4h], 1
    call LoadGraphicsRecordImages
    mov word ptr ds:[021C4h], 0
    mov byte ptr ds:[LoadIsEnc], 0
    mov word ptr cs:[LoadDestOffset], 0
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

loc_0D4AA:
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
    call loc_0D87A
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
    call loc_0D793
loc_0D6E8:
    cmp byte ptr ds:[98C5h], 1
    jne loc_0D6F2
    jmp near ptr loc_0D84B
loc_0D6F2:
    cmp byte ptr ds:[990Bh], 1
    je loc_0D71E
    cmp byte ptr ds:[9913h], 1
    je loc_0D729
    cmp byte ptr ds:[990Ch], 1
    je loc_0D756
    cmp byte ptr ds:[9914h], 1
    je loc_0D76E
    cmp byte ptr ds:[990Dh], 1
    je loc_0D734
    cmp byte ptr ds:[9915h], 1
    je loc_0D745
    jmp short loc_0D6E8
loc_0D71E:
    mov bp, 0FFFFh
loc_0D721:
    call loc_0D75D
    dec bp
    jne loc_0D721
    jmp short loc_0D6E5
loc_0D729:
    mov bp, 0FFFFh
loc_0D72C:
    call loc_0D77B
    dec bp
    jne loc_0D72C
    jmp short loc_0D6E5
loc_0D734:
    call loc_0D853
    call loc_0D853
    mov bp, 17h
loc_0D73D:
    call loc_0D75D
    dec bp
    jne loc_0D73D
    jmp short loc_0D6E5
loc_0D745:
    call loc_0D853
    call loc_0D853
    mov bp, 17h
loc_0D74E:
    call loc_0D77B
    dec bp
    jne loc_0D74E
    jmp short loc_0D6E5
loc_0D756:
    call loc_0D75D
    jcxz loc_0D6E8
    jmp short loc_0D6E5
loc_0D75D:
    xor cx, cx
    cmp word ptr cs:[TextTopLine], 0
    je loc_0D76D
    dec word ptr cs:[TextTopLine]
    inc cx
loc_0D76D:
    ret
loc_0D76E:
    call loc_0D77B
    jcxz loc_0D775
    jmp short loc_0D778
loc_0D775:
    jmp near ptr loc_0D6E8
loc_0D778:
    jmp near ptr loc_0D6E5
loc_0D77B:
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
loc_0D793:
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
    call loc_0D853
    pop bp
    pop dx
    ret
loc_0D84B:
    cmp byte ptr ds:[98C5h], 1
    je loc_0D84B
    ret
loc_0D853:
    mov cx, 4
loc_0D856:
    call loc_0D85C
    loop loc_0D856
    ret
loc_0D85C:
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
loc_0D87A:
    mov dx, 3B4h
    call loc_0D89B
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
loc_0D89B:
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

; Decode the ENC (LZSS: flag bytes, literals, 12-bit position + 4-bit length-3 pairs, a
; zero pair followed by a zero byte ends) file open on EncFileHandle to EncDestSegment:EncDestOffset, then close
; it. EncOutputBytes counts the output; DS preserved. CF set if the first read fails.
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
; UNKNOWN: not yet classified as code or data
    db 0E1h,00h,065h,04Eh,0E2h,00h,065h,04Eh,0E3h,00h,065h,04Eh,0E4h,00h
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
loc_0EFAE:
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[DispatchRecordX], ax
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[DispatchRecordY], ax
    mov bx, word ptr ss:[bp + REC_TYPE]
    shl bx, 1
    jmp word ptr cs:[bx + TypeHandlers]
; Behaviour handler per REC_TYPE (0..94h), entered with BP = record.
TypeHandlers label word
    dw offset loc_0BC45, offset TypeHandler01, offset TypeHandler02, offset TypeHandler02
    dw offset TypeHandler04, offset TypeHandler05, offset TypeHandler06, offset TypeHandler07
    dw offset TypeHandler08, offset TypeHandler09, offset TypeHandler0A, offset TypeHandler0B
    dw offset TypeHandler0C, offset loc_0BC45, offset loc_0BC45, offset TypeHandler0F
    dw offset TypeHandler10, offset TypeHandler11, offset TypeHandler12, offset TypeHandler13
    dw offset TypeHandler14, offset TypeHandler13, offset TypeHandler16, offset TypeHandler16
    dw offset TypeHandler18, offset TypeHandler19, offset TypeHandler1A, offset TypeHandler1B
    dw offset TypeHandler13, offset TypeHandler1D, offset TypeHandler1E, offset TypeHandler13
    dw offset TypeHandler20, offset TypeHandler21, offset TypeHandler22, offset TypeHandler23
    dw offset TypeHandler24, offset TypeHandler25, offset TypeHandler26, offset TypeHandler27
    dw offset TypeHandler28, offset TypeHandler29, offset TypeHandler28, offset TypeHandler2B
    dw offset TypeHandler2C, offset TypeHandler2D, offset TypeHandler2E, offset TypeHandler2F
    dw offset TypeHandler30, offset TypeHandler31, offset TypeHandler32, offset TypeHandler33
    dw offset TypeHandler34, offset TypeHandler22, offset TypeHandler36, offset TypeHandler37
    dw offset TypeHandler38, offset TypeHandler39, offset TypeHandler3A, offset TypeHandler3B
    dw offset TypeHandler3C, offset TypeHandler3D, offset TypeHandler3E, offset TypeHandler3F
    dw offset TypeHandler40, offset TypeHandler41, offset TypeHandler42, offset TypeHandler43
    dw offset TypeHandler44, offset TypeHandler45, offset TypeHandler46, offset TypeHandler47
    dw offset TypeHandler48, offset TypeHandler49, offset TypeHandler4A, offset TypeHandler4B
    dw offset TypeHandler4C, offset TypeHandler4D, offset TypeHandler4E, offset TypeHandler4F
    dw offset TypeHandler50, offset TypeHandler51, offset TypeHandler52, offset TypeHandler53
    dw offset TypeHandler54, offset TypeHandler55, offset TypeHandler56, offset TypeHandler57
    dw offset TypeHandler57, offset TypeHandler59, offset TypeHandler5A, offset TypeHandler5B
    dw offset TypeHandler5C, offset TypeHandler5D, offset TypeHandler5E, offset TypeHandler5F
    dw offset TypeHandler60, offset TypeHandler61, offset TypeHandler62, offset TypeHandler63
    dw offset TypeHandler64, offset TypeHandler65, offset TypeHandler66, offset TypeHandler67
    dw offset TypeHandler68, offset TypeHandler69, offset TypeHandler6A, offset TypeHandler6B
    dw offset TypeHandler6C, offset TypeHandler6D, offset TypeHandler6E, offset TypeHandler6F
    dw offset TypeHandler70, offset TypeHandler71, offset TypeHandler72, offset TypeHandler73
    dw offset TypeHandler74, offset TypeHandler75, offset TypeHandler76, offset TypeHandler77
    dw offset TypeHandler78, offset TypeHandler79, offset TypeHandler7A, offset TypeHandler7B
    dw offset TypeHandler7C, offset TypeHandler13, offset TypeHandler13, offset TypeHandler7F
    dw offset TypeHandler80, offset TypeHandler81, offset loc_0BC45, offset TypeHandler83
    dw offset TypeHandler84, offset TypeHandler85, offset TypeHandler86, offset TypeHandler87
    dw offset TypeHandler88, offset TypeHandler89, offset TypeHandler8A, offset TypeHandler8B
    dw offset TypeHandler8C, offset TypeHandler8D, offset TypeHandler8E, offset TypeHandler8F
    dw offset TypeHandler90, offset TypeHandler91, offset TypeHandler92, offset TypeHandler93
    dw offset loc_0BC45
TypeHandler86:
    mov bx, ds:[232Eh]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shl bx, 1
    mov si, offset Type86FramesDir6
    cmp word ptr ss:[bp + REC_DIRECTION], 6
    je loc_0F108
    mov si, offset Type86Frames
loc_0F108:
    mov ax, bx
    mov bx, ds:[bx + si]
    mov ss:[bp + REC_SPRITE], bx
    cmp ax, 4
    je loc_0F117
    jmp near ptr loc_0BC45
loc_0F117:
    cmp word ptr ds:[232Eh], 26h
    je loc_0F121
    jmp near ptr loc_0BC45
loc_0F121:
    call loc_081F4
    cmp bx, -1
    jne loc_0F12C
    jmp near ptr loc_0BC45
loc_0F12C:
    call loc_074E2
    mov word ptr ds:[bx + 8], 0CBh
    mov word ptr ds:[bx + 18h], 60h
    jmp near ptr loc_0BC45
TypeHandler88:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae loc_0F146
    jmp near ptr loc_0BC45
loc_0F146:
    mov bx, ds:[232Eh]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shl bx, 1
    mov si, offset Type88FramesDir6
    cmp word ptr ss:[bp + REC_DIRECTION], 6
    je loc_0F160
    mov si, offset Type88Frames
loc_0F160:
    mov ax, bx
    mov bx, ds:[bx + si]
    mov ss:[bp + REC_SPRITE], bx
    cmp ax, 4
    je loc_0F16F
    jmp near ptr loc_0BC45
loc_0F16F:
    call SpawnThrottledChild
    jmp near ptr loc_0BC45
TypeHandler6A:
    cmp word ptr ss:[bp + REC_Y], 50h
    je loc_0F17E
    jmp near ptr loc_0BC45
loc_0F17E:
    mov word ptr ss:[bp + REC_TYPE], 56h
    jmp short TypeHandler56
TypeHandler54:
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_0F18F
    jmp near ptr loc_0BC45
loc_0F18F:
    mov word ptr ss:[bp + REC_TYPE], 56h
TypeHandler56:
    call loc_0AFD8
    jne loc_0F1A6
    call loc_0AFD8
    jne loc_0F1A6
    call loc_0AFD8
    jne loc_0F1A6
    jmp near ptr loc_0BC45
loc_0F1A6:
    call loc_0BFC7
    jmp near ptr loc_0BC45
TypeHandler87:
    mov bx, ds:[232Eh]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    mov cx, bx
    shl bx, 1
    add bx, 96C2h
    mov bx, ds:[bx]
    add bx, 0DDh
    mov ss:[bp + REC_SPRITE], bx
    cmp word ptr ss:[bp + REC_X], 60h
    jae loc_0F1D0
    jmp near ptr loc_0878C
loc_0F1D0:
    add word ptr ss:[bp + REC_SPRITE], 3
    jmp near ptr loc_0878C
TypeHandler55:
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    je loc_0F1F1
    mov word ptr ss:[bp + REC_SPRITE], 73h
    cmp word ptr ss:[bp + REC_Y], 0B0h
    je loc_0F1EC
    jmp near ptr loc_0BC45
loc_0F1EC:
    mov word ptr ss:[bp + REC_DIRECTION], 4
loc_0F1F1:
    mov ax, ds:[2328h]
    add ax, 77h
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC4B
TypeHandler57:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae loc_0F20B
    jmp near ptr loc_0BC45
loc_0F20B:
    jne loc_0F210
    call loc_0F221
loc_0F210:
    call loc_0AFD8
    call loc_0AFD8
    jne loc_0F21B
    jmp near ptr loc_0BC45
loc_0F21B:
    jmp near ptr loc_0BFC7
    jmp near ptr loc_0BB03
loc_0F221:
    inc word ptr ss:[bp + REC_SPRITE]
    ret
TypeHandler59:
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
    jmp near ptr loc_0BC45
loc_0F253:
    mov ax, ds:[2326h]
    add ss:[bp + REC_SPRITE], ax
    cmp word ptr ss:[bp + REC_Y], 0C0h
    jg loc_0F263
    jmp near ptr loc_0BC45
loc_0F263:
    mov word ptr ss:[bp + REC_TYPE], 5Ah
TypeHandler5A:
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
    mov ax, ds:[2326h]
    add ss:[bp + REC_SPRITE], ax
    call loc_0AFD8
    jne loc_0F2B1
    call loc_0AFD8
    jne loc_0F2B1
    call loc_0AFD8
    jne loc_0F2B1
    cmp word ptr ss:[bp + REC_X], 0
    jng loc_0F2B1
    cmp word ptr ss:[bp + REC_X], 0C0h
    jnl loc_0F2B1
    jmp near ptr loc_0BC45
loc_0F2B1:
    xor word ptr ss:[bp + REC_DIRECTION], 6
    call loc_0AFD8
    je loc_0F2BD
    jmp near ptr loc_0BFC7
loc_0F2BD:
    jmp near ptr loc_0BC45
TypeHandler5B:
    cmp word ptr ss:[bp + REC_Y], 0B0h
    jg loc_0F2CA
    jmp near ptr loc_0BC45
loc_0F2CA:
    mov word ptr ss:[bp + REC_TYPE], 5Ch
TypeHandler5C:
    mov word ptr ss:[bp + REC_SPRITE], 73h
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC45
TypeHandler5D:
    mov ax, ds:[2336h]
    add ax, 77h
    mov ss:[bp + REC_SPRITE], ax
    add word ptr ss:[bp + REC_Y], 8
    jmp near ptr loc_0BC45
TypeHandler5E:
    call loc_0AFD8
    call loc_0AFD8
    call loc_0AFD8
    call loc_0AFD8
    jne loc_0F2FC
    jmp near ptr loc_0BC45
loc_0F2FC:
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    je loc_0F30B
    cmp word ptr ss:[bp + REC_DIRECTION], 5
    je loc_0F313
    jmp near ptr loc_0BFC7
loc_0F30B:
    mov word ptr ss:[bp + REC_DIRECTION], 5
    jmp near ptr loc_0BC45
loc_0F313:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    jmp near ptr loc_0BC45
TypeHandler6E:
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx - 692Eh]
    add bx, 128h
    mov ss:[bp + REC_SPRITE], bx
    call loc_0AFD8
    call loc_0AFD8
    jne loc_0F337
    jmp near ptr loc_0BC45
loc_0F337:
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    je loc_0F345
    mov word ptr ss:[bp + REC_DIRECTION], 4
    jmp near ptr loc_0BC45
loc_0F345:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    jmp near ptr loc_0BC45
TypeHandler5F:
    mov ax, ds:[2326h]
    add ax, 0F6h
    mov ss:[bp + REC_SPRITE], ax
    mov ax, ss:[bp + REC_Y]
    add ax, ss:[bp + REC_X]
    cmp ax, 60h
    jae loc_0F364
    jmp near ptr loc_0BC45
loc_0F364:
    call loc_0AFD8
    call loc_0AFD8
    call loc_0AFD8
    call loc_0AFD8
    jne loc_0F375
    jmp near ptr loc_0BC45
loc_0F375:
    cmp word ptr ss:[bp + REC_DIRECTION], 6
    je loc_0F384
    cmp word ptr ss:[bp + REC_DIRECTION], 2
    je loc_0F38C
    jmp near ptr loc_0BFC7
loc_0F384:
    mov word ptr ss:[bp + REC_DIRECTION], 3
    jmp near ptr loc_0BC45
loc_0F38C:
    mov word ptr ss:[bp + REC_DIRECTION], 5
    jmp near ptr loc_0BC45
TypeHandler61:
    mov ax, ss:[bp + REC_SAVED_Y]
    mov ds:[2306h], ax
    mov ax, ss:[bp + REC_SAVED_X]
    mov ds:[2304h], ax
    mov word ptr ds:[2308h], 3
    call SteerTowardTarget
    cmp word ptr ds:[230Ah], 0
    jne loc_0F3B3
    jmp near ptr loc_0BC45
loc_0F3B3:
    mov word ptr ss:[bp + REC_TYPE], 62h
    jmp near ptr loc_0BC45
TypeHandler62:
    cmp word ptr ds:[FramesSinceInvaderSpawn], 18h
    jae loc_0F3C5
    jmp near ptr loc_0BC45
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
    jmp short TypeHandler61
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
    call loc_07476
loc_0F446:
    mov ax, ds:[2380h]
    cmp ss:[bp + REC_X], ax
    jne loc_0F45D
    call loc_04D95
    and bx, 1Fh
    jne loc_0F45D
    mov word ptr ss:[bp + REC_TYPE], 65h
    jmp short TypeHandler63
loc_0F45D:
    mov ax, ds:[2340h]
    and ax, 7Fh
    cmp ax, ds:[2330h]
    je loc_0F46C
    jmp near ptr loc_0BC45
loc_0F46C:
    cmp word ptr ds:[2326h], 0
    je loc_0F476
    jmp near ptr loc_0BC45
loc_0F476:
    inc word ptr ds:[2340h]
    mov word ptr ss:[bp + REC_DIRECTION], 4
    call SpawnThrottledChild
    cmp bx, -1
    jne loc_0F48A
    jmp near ptr loc_0BC45
loc_0F48A:
    mov word ptr ds:[bx + 8], 63h
    jmp near ptr loc_0BC45
TypeHandler65:
    add word ptr ss:[bp + REC_Y], 4
    cmp word ptr ds:[2326h], 3
    je loc_0F4A0
    jmp near ptr loc_0BC45
loc_0F4A0:
    cmp word ptr ss:[bp + REC_SPRITE], 0EBh
    jne loc_0F4AA
    jmp near ptr loc_0BC45
loc_0F4AA:
    inc word ptr ss:[bp + REC_SPRITE]
    call loc_07476
    jmp near ptr loc_0BC45
TypeHandler63:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae loc_0F4BC
    jmp near ptr loc_0BC45
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
    jmp near ptr loc_0BC45
loc_0F4DF:
    add word ptr ss:[bp + REC_X], 2
    cmp word ptr ss:[bp + REC_X], 60h
    je loc_0F4EC
    jmp near ptr loc_0BC45
loc_0F4EC:
    jmp short loc_0F4F8
loc_0F4EE:
    cmp word ptr ds:[2326h], 3
    je loc_0F4F8
    jmp near ptr loc_0BC45
loc_0F4F8:
    inc word ptr ss:[bp + REC_SPRITE]
    jmp near ptr loc_0BC45
TypeHandler64:
    mov ax, 2
    cmp word ptr ds:[LevelIndex], 4
    je loc_0F50A
    add al, 2
loc_0F50A:
    add ss:[bp + REC_Y], ax
    jmp near ptr loc_0BC45
TypeHandler66:
    mov word ptr ss:[bp + REC_FIELD_36], 0D222h
    mov word ptr ss:[bp + REC_HIT_POINTS], 14h
    jmp near ptr loc_0B2C8
TypeHandler67:
    mov word ptr ss:[bp + REC_FIELD_36], 0D272h
    mov word ptr ss:[bp + REC_HIT_POINTS], 14h
    jmp near ptr loc_0B2C8
TypeHandler6B:
    mov word ptr ds:[DescentTargetX], 50h
    mov ax, ds:[232Ah]
    shr ax, 1
    shr ax, 1
    add ax, 11Fh
    mov ss:[bp + REC_SPRITE], ax
    jmp short loc_0F55A
TypeHandler6D:
    mov word ptr ds:[DescentTargetX], 70h
    mov ax, ds:[232Ah]
    shr ax, 1
    shr ax, 1
    add ax, 124h
    mov ss:[bp + REC_SPRITE], ax
    jmp short loc_0F55A
TypeHandler6C:
    mov word ptr ds:[DescentTargetX], 60h
loc_0F55A:
    cmp word ptr ss:[bp + REC_Y], 40h
    jae loc_0F563
    jmp near ptr loc_0BC45
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
    jmp near ptr loc_0BC45
loc_0F583:
    cmp word ptr ss:[bp + REC_X], 60h
    je loc_0F596
    cmp word ptr ds:[232Ah], 0Fh
    jne loc_0F593
    call SpawnThrottledChild
loc_0F593:
    jmp near ptr loc_0BC45
loc_0F596:
    cmp word ptr ds:[2326h], 3
    jne loc_0F5A0
    call SpawnThrottledChild
loc_0F5A0:
    jmp near ptr loc_0BC45
TypeHandler6F:
    cmp word ptr ss:[bp + REC_Y], 50h
    jae loc_0F5AC
    jmp near ptr loc_0BC45
loc_0F5AC:
    mov ax, ds:[237Eh]
    sub ax, ss:[bp + REC_Y]
    cmp ax, 20h
    jae loc_0F5BA
    jmp near ptr loc_0BC45
loc_0F5BA:
    mov word ptr ss:[bp + REC_TYPE], 70h
TypeHandler70:
    mov ax, ds:[232Ah]
    shr ax, 1
    shr ax, 1
    add ax, 133h
    mov ss:[bp + REC_SPRITE], ax
    call MoveInDirection2
    cmp word ptr ds:[2328h], 7
    jne loc_0F5D9
    call SpawnThrottledChild
loc_0F5D9:
    jmp near ptr loc_0BC45
TypeHandler72:
    mov ax, ds:[2328h]
    shr ax, 1
    add ax, 1Ch
    mov ss:[bp + REC_SPRITE], ax
    inc word ptr ss:[bp + REC_Y]
    cmp word ptr ds:[CountGate2324], 1
    jne loc_0F5F4
    call loc_07476
loc_0F5F4:
    jmp near ptr loc_0BC45
TypeHandler73:
    cmp word ptr ss:[bp + REC_Y], 80h
    jae loc_0F601
    jmp near ptr loc_0BC45
loc_0F601:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx - 692Eh]
    add bx, 14Ch
    mov ss:[bp + REC_SPRITE], bx
    jmp short TypeHandler85
TypeHandler74:
    cmp word ptr ss:[bp + REC_Y], 90h
    jae loc_0F623
    jmp near ptr loc_0BC45
loc_0F623:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    mov bx, ds:[233Ch]
    shl bx, 1
    mov bx, ds:[bx - 692Eh]
    add bx, 14Fh
    mov ss:[bp + REC_SPRITE], bx
TypeHandler85:
    cmp word ptr ss:[bp + REC_DIRECTION], 2
    jne loc_0F646
    cmp word ptr ss:[bp + REC_X], 0C0h
    je loc_0F663
loc_0F646:
    cmp word ptr ss:[bp + REC_DIRECTION], 6
    jne loc_0F652
    cmp word ptr ss:[bp + REC_X], 0
    je loc_0F663
loc_0F652:
    call loc_0AFD8
    call loc_0AFD8
    call loc_0AFD8
    call loc_0AFD8
    jne loc_0F663
    jmp near ptr loc_0BC45
loc_0F663:
    call loc_0BFC7
    jmp near ptr loc_0BC45
TypeHandler84:
    mov bx, ss:[bp + REC_DIRECTION]
    shr bx, 1
loc_0F66E:
    shl bx, 1
    jmp word ptr cs:[bx - 98Ah]
    nop
    jng loc_0F66E
    mov sp, 0AFF6h
    mul bl
    mul byte ptr ds:[bx + di + 237Eh]
    cmp ax, ss:[bp + REC_Y]
    jna loc_0F689
    jmp near ptr loc_0BC45
loc_0F689:
    mov ax, ds:[2380h]
    add ax, 8
    cmp word ptr ds:[2384h], 0
    je loc_0F699
    add ax, 8
loc_0F699:
    mov bx, ss:[bp + REC_X]
    and ax, 0FFF0h
    and bx, -10h
    cmp ax, bx
    je loc_0F6A9
    jmp near ptr loc_0BC45
loc_0F6A9:
    mov word ptr ss:[bp + REC_TYPE], 85h
    ret
    mov ax, ds:[237Eh]
    cmp ax, ss:[bp + REC_Y]
    jae loc_0F6BA
    jmp near ptr loc_0BC45
loc_0F6BA:
    jmp short loc_0F689
    mov ax, ds:[2380h]
    cmp ax, ss:[bp + REC_X]
    jae loc_0F6C7
    jmp near ptr loc_0BC45
loc_0F6C7:
    mov bx, ss:[bp + REC_Y]
    add bx, 14h
    and bx, -4
    mov ax, ds:[237Eh]
    and ax, 0FFFCh
    cmp ax, bx
    je loc_0F6DD
    jmp near ptr loc_0BC45
loc_0F6DD:
    mov word ptr ss:[bp + REC_TYPE], 85h
    ret
    mov ax, ds:[2380h]
    cmp ax, ss:[bp + REC_X]
    jna loc_0F6EE
    jmp near ptr loc_0BC45
loc_0F6EE:
    jmp short loc_0F6C7
TypeHandler92:
    mov bx, ss:[bp + REC_Y]
    add bx, 14h
    and bx, -4
    mov ax, ds:[237Eh]
    and ax, 0FFFCh
    cmp ax, bx
    je loc_0F706
    jmp near ptr loc_0BC45
loc_0F706:
    sub word ptr ss:[bp + REC_Y], 4
    call loc_0F71B
    add word ptr ss:[bp + REC_Y], 8
    call loc_0F71B
    sub word ptr ss:[bp + REC_Y], 4
    jmp near ptr loc_0BC45
loc_0F71B:
    call SpawnThrottledChild
    cmp bx, -1
    je loc_0F728
    mov word ptr ds:[bx + 8], 44h
loc_0F728:
    ret
TypeHandler75:
    add word ptr ss:[bp + REC_Y], 2
    cmp word ptr ds:[2326h], 3
    je loc_0F737
    jmp near ptr loc_0BC45
loc_0F737:
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], 5
    call loc_0C21D
    mov word ptr ss:[bp + REC_DIRECTION], 3
    call loc_0C21D
    mov word ptr ss:[bp + REC_DIRECTION], 4
    call loc_0C21D
    pop word ptr ss:[bp + REC_DIRECTION]
    jmp near ptr loc_0BC45
TypeHandler76:
    mov si, 0D2C4h
    jmp short loc_0F779
TypeHandler77:
    mov si, 0D2C8h
    jmp short loc_0F779
TypeHandler78:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    cmp word ptr ds:[2330h], 0Fh
    ja loc_0F771
    call loc_07476
loc_0F771:
    mov si, 0D2CCh
    jmp short loc_0F779
TypeHandler79:
    mov si, 0D2D0h
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
    jmp near ptr loc_0BC45
loc_0F797:
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
    mov ds:[2306h], ax
    lodsw
    mov ds:[2304h], ax
    mov word ptr ds:[2308h], 2
    call SteerTowardTarget
    push word ptr ss:[bp + REC_X]
    pop word ptr ds:[SegBossX]
    push word ptr ss:[bp + REC_Y]
    pop word ptr ds:[SegBossY]
    cmp word ptr ds:[230Ah], 0
    jne loc_0F7E4
    ret
loc_0F7E4:
    mov ds:[SegBossPathCursor], si
    jmp short loc_0F797
MAIN ends

FAR0F7F segment byte public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
loc_1000D:
    dec byte ptr ds:[098A7h]
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
    mov byte ptr ds:[098A7h], cl
    inc byte ptr ds:[098A6h]
    jmp short loc_10043
loc_1003E:
    mov byte ptr ds:[098A6h], 0
loc_10043:
    retf

loc_10044:
    mov byte ptr ds:[098A2h], 0
    mov byte ptr ds:[098A3h], 0
    mov byte ptr ds:[098A5h], 1
    mov word ptr ds:[098AAh], 2
    mov word ptr ds:[098ACh], 0FFFFh
    mov byte ptr ds:[098A4h], 0
    mov byte ptr ds:[098A7h], 1
    mov byte ptr ds:[098A6h], 0
    mov byte ptr ds:[098A8h], 0
    mov byte ptr ds:[098A9h], 0
    ret
loc_10079:
    mov word ptr ds:[bx + 20h], 0C8h
    mov word ptr ds:[bx + 4], 0
    mov word ptr ds:[bx + 2], 0
    mov word ptr ds:[bx + 14h], 2
    mov word ptr ds:[bx + 28h], 0FFFFh
    mov word ptr ds:[bx], 1
    mov word ptr ds:[bx + 16h], 4
    retf
loc_1009C:
    mov si, cs:[920h]
    lodsw
    cmp ax, 0FFFFh
    je loc_10103
    add ax, 20h
    mov ds:[2306h], ax
    lodsw
    mov ds:[2304h], ax
    mov word ptr ds:[2308h], 3
    mov ax, 5DB2h
    call far ptr FarCallMainNearViaAX
    cmp word ptr ds:[230Ah], 0
    je loc_100F9
    mov word ptr ss:[bp + REC_HIT_POINTS], 2
    add word ptr cs:[920h], 4
    mov ax, 81F4h
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_100F9
    mov ax, ss:[bp + REC_Y]
    mov ds:[bx + 34h], ax
    mov ax, ss:[bp + REC_X]
    mov ds:[bx + 32h], ax
    mov word ptr ds:[bx + 18h], 64h
    mov word ptr ds:[bx + 20h], 3
    mov word ptr ds:[bx + 8], 8Eh
loc_100F9:
    mov ax, ss:[bp + REC_DIRECTION]
    add ax, 3Bh
    mov ss:[bp + REC_SPRITE], ax
    retf
loc_10103:
    call loc_10108
    jmp short loc_1009C

loc_10108:
    mov word ptr cs:[0920h], 09828h
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h

MoveStars:
    cmp word ptr ds:[0A95Ah], -1
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
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

ShowPageList:
    mov word ptr ds:[PageListPtr], ax
    mov word ptr ds:[PageIndex], 0
loc_10179:
    mov ax, offset LoadAndShowPage
    call far ptr FarCallMainNearViaAX
    mov si, word ptr ds:[PageListPtr]
    cmp word ptr ds:[si - 2], 0
    je loc_101D8
loc_1018B:
    cmp byte ptr ds:[KeyDownTable + SCAN_LEFT], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KeyDownTable + SCAN_UP], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KeyDownTable + SCAN_PGUP], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KeyDownTable + SCAN_BACKSPACE], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KeyDownTable + SCAN_RIGHT], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KeyDownTable + SCAN_DOWN], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KeyDownTable + SCAN_PGDN], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KeyDownTable + SCAN_SPACE], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KeyDownTable + SCAN_ENTER], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne loc_1018B
loc_101D1:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    je loc_101D1
loc_101D8:
    retf
loc_101D9:
    cmp word ptr ds:[PageIndex], 0
    je loc_1018B
    mov cx, 5
loc_101E3:
    mov ax, offset WaitVerticalRetrace
    call far ptr FarCallMainNearViaAX
    loop loc_101E3
    dec word ptr ds:[PageIndex]
    jmp short loc_10179
loc_101F3:
    mov si, word ptr ds:[PageListPtr]
    mov bx, word ptr ds:[PageIndex]
    inc bx
    shl bx, 1
    cmp word ptr ds:[bx + si], -1
    je loc_1018B
    mov cx, 5
loc_10206:
    mov ax, offset WaitVerticalRetrace
    call far ptr FarCallMainNearViaAX
    loop loc_10206
    inc word ptr ds:[PageIndex]
    jmp near ptr loc_10179
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h
FAR0F7F ends
end ProgramEntry