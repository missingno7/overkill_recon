; Everything in segment frame DATA; modern file boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
; One text-mode row: each character of TEXT followed by the attribute byte ATTR.
; A literal ! must be written !!!! (two expansion levels); split rows around %.
TEXTROW macro attr, text
    irpc c, <text>
    db '&c&', attr
    endm
endm
locals
extrn loc_07977:far
extrn loc_07B06:far
extrn loc_07BCB:far
extrn loc_07C3F:far
extrn loc_07CA2:far
extrn loc_07DC8:far
DATA segment para public 'CODE'
assume cs:DATA,ds:nothing,ss:nothing,es:nothing
public AdapterGeometry
public AimQuadrantBits
public AllCheatsFlag
public AttributePatchPointers
public BlockBytes
public BonusKeysEnabled
public BossKeyScreen
public ByteAttributeTable
public CalibPageList
public CheatBonusCheatOn
public CheatEveryDayIDie
public CheatGibStMirSchnellfeuer
public CheatLifeInTheFastLane
public CheatMyNameIsSmith
public CheatRemindMe
public CheatWhatOilShortage
public ChildSpawnThrottle
public ChooseSlot
public ChooseSlotPositions
public ClampXHighSeen
public ClampXLowSeen
public CountGate2324
public DifficultyPositions
public DifficultySetting
public DirectionFromQuadrant
public EmsAvailable
public EmsDeviceName
public EmsFreePages
public EmsPageFrame
public EmsTotalPages
public EventTrigger
public EventX
public ExitOrderScreen
public FileBufferOffset
public FileBufferSegment
public FileByteCount
public FileCache
public FileCacheEnd
public FileHandle
public FileNamePtr
public FileStatus
public File_1X1_BIC
public File_2X2C_BIC
public File_2X2_BIC
public File_BLUEBITS_BIC
public File_CHOOSE_ENC
public File_LEVSCR_ENC
public File_MANEXPL_BIC
public File_PANEL_ENC
public File_SHIP_BIC
public File_THEND_BIC
public File_WINDOW_BIC
public FormationDrawPass
public FormationSizeClass
public FormationType
public GameOverRequest
public GeometryWords
public GridYSum
public HiscoreBlock
public HiscoreFileName
public HiscorePageList
public HistoryCursor47
public HistoryEnd
public HistoryPairs
public HistoryReadCursor15
public HistoryReadCursor31
public HistoryRecordSlot15
public HistoryRecordSlot31
public HistoryWriteCursor
public IPageList
public ImageEnd
public InputBits
public InputDeviceMode
public JoyButtonSelect
public JoyCalAbortSp
public JoyCalCenterX
public JoyCalCenterY
public JoyCalHighX
public JoyCalHighY
public JoyCalLowX
public JoyCalLowY
public JoyXHighThreshold
public JoyXLowThreshold
public JoyYHighThreshold
public JoyYLowThreshold
public KbdSavedInt09
public KeepLivesFlag
public KeyBitScancodesA
public KeyBitScancodesB
public KeyDownTable
public KeyLastMakeCode
public LevelBankFiles
public LevelIndex
public LevelMapCellHandlers
public LevelMapFiles
public LevelScript0
public LevelScript1
public LevelScript2
public LevelScript3
public LevelScript4
public LevelScript5
public LevelScriptClock
public LevelScriptCursorPtrs
public LevelScriptCursors
public LevelSkipEnabled
public LifeLostRequest
public LivesLeft
public LoadIsEnc
public MinusSlotA968
public MinusSlotA96C
public ModuleSoundEnabled
public ModuleSoundRequest
public MoveModeA47C
public MsgDeallocError
public MsgNotEnoughMemory
public NextLevelRequest
public OPageList
public OffsetTableA368
public OffsetTableA374
public OffsetTableA380
public OffsetTableA38C
public OffsetXGroupA
public OffsetXGroupB
public OffsetXWork
public OkMenuPageList
public PageIndex
public PageListPtr
public PendingSpriteFile
public PlaqueFiles
public PlayfieldRowOffsets
public PlusSlotA966
public PlusSlotA96A
public PoolA
public PoolACursor
public PoolAEnd
public PoolAPointers
public PoolASaveBuffers
public PoolB
public PoolBCursor
public PoolBEnd
public PoolBPointers
public PoolBSaveBuffers
public PrimaryRecord
public QuitAnswer
public RapidFireEnabled
public RecordRowOffsets
public RedefPageList
public ResidentFiles
public SavedSettings
public ScoreBcd
public ScreenRowOffsets
public ScrollDeltaY
public SequenceFrameCount
public SfxActive
public SfxCommandTable
public SfxEffectTable
public SfxEnabled
public SfxNoteDivisors
public SfxRequest
public SfxTickPhase
public SfxVoiceA
public SfxVoiceB
public SoundModuleLoaded
public SoundModuleNameAdlib
public SoundModuleNameRoland
public SoundModuleNameTandy
public SoundModuleSelect
public SoundOption
public SoundOptionFlags
public Sprite16Bytes
public Sprite32Bytes
public Sprite8Bytes
public StackTop
public StateData
public TargetSearchCursor
public TimerVectorInstalled
public VideoBiosModeTable
public WhatOilShortageFlag
public WideRowOffsets
public WinScreenPageList
public XAdjustPathTaken
StateData label byte
; UNKNOWN: not yet classified as code or data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh
; CalibrateJoystickWithAbort saves SP here; Esc during calibration (PollJoystickPrimaryOrAbort) restores it at AbortJoystickCalibration.
JoyCalAbortSp dw 00000h
; Selects the PollInputBits source; values other than 1 (joystick) and 2 (table B)
; use key table A.
InputDeviceMode dw 00000h
; PollJoystickInputBits writes JOY_BUTTONS_PORT_A before testing it, so port-B
; buttons are unreached there.
JoyButtonSelect dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,011h,08h,00h,010h
    db 03h,043h,045h,04Eh,054h,052h,045h,020h,053h,054h,049h,043h,04Bh,020h,048h,041h
    db 04Eh,044h,04Ch,045h,020h,041h,04Eh,044h,020h,050h,055h,053h,048h,020h,046h,049h
    db 052h,045h,00h,090h
; Unsigned midpoints of the LOW/CENTER and CENTER/HIGH calibration samples.
JoyXLowThreshold dw 00000h
JoyXHighThreshold dw 00000h
JoyYLowThreshold dw 00000h
JoyYHighThreshold dw 00000h
JoyCalLowX dw 00000h
JoyCalLowY dw 00000h
JoyCalHighX dw 00000h
JoyCalHighY dw 00000h
JoyCalCenterX dw 00000h
JoyCalCenterY dw 00000h
TimerVectorInstalled dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h
; The module loads at SoundModuleSlot (SLOT1022.ASM); LoadSoundModule far-calls
; SoundModuleInitEntry and the timer handler calls SoundModuleTickEntry.
; DS byte: 1 after a module's +4 entry returns nonzero AL, else 0.
SoundModuleLoaded db 00h
; Fake "SNAFU V4.2" file-manager screen (80x25 text, character/attribute pairs),
; shown by the F9 boss key (ShowBossKeyScreen).
BossKeyScreen label word
    TEXTROW 0Ch, <                        >
    TEXTROW 07h, <            >
    TEXTROW 0Ch, <SNAFU  V4.2             >
    TEXTROW 07h, <                    >
    TEXTROW 0Eh, <                                                                                >
    TEXTROW 0Eh, <    File Descriptor =  *.*       Help Menu     =   ON      Logged Drive = D    >
    TEXTROW 07h, < >
    TEXTROW 0Eh, <    No.Tagged Files =  4         DIR Justify   =   ON      Use Ramdisk  = NO   >
    TEXTROW 07h, < >
    TEXTROW 0Eh, <    Verify Files    =  ON        Ignore Hidden =   ON      Listing File = NO   >
    TEXTROW 07h, < >
    TEXTROW 0Eh, <    Recurse SubDIRs =  OFF       Query Deletes =   OFF                         >
    TEXTROW 07h, < >
    TEXTROW 0Eh, <                                                                                >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <                                                                               >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    PART1   .C        GO      .BAT      COBOL   .HLP              .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    MAPED   .EXE      EXIT    .BAT      STEBURG .CTY              .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    SPGRAB  .EXE     \LISTINGS.         BINCOMP .EXE              .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    LISTALL .BAT      BORROWED.LST *   >
    TEXTROW 71h, <\BACKUP5 .   >
    TEXTROW 07h, <              .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    SPOOL   .LST      REFERENC.ES               .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <   \BACKUP6 .         MYFILES1.C                .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    PNAMES  .LST      ALLPROGS.LZH              .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    TMP     .LST      BACKUP2 .ARC              .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    LIB10   .LIB *    CONTENTS.TXT *            .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    XCUT1   .COM      READ    .ME               .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    PRODUCTS.LST *    MANGLE  .EXE              .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    FLOWCHRT.FLC      2BY2    .SPR              .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <    FLOWCHR2.FLC      BACKGRND.NEO              .                 .            >
    TEXTROW 0Eh, < >
    TEXTROW 07h, <                                                                               >
    TEXTROW 1Eh, <   F1 = Quit     F3 = Case Descriptor   F5 = Print Screen                       >
    TEXTROW 1Eh, <   F2 = Help     F4 = Crunch Output     F6 = Show Attrib       Command?         >
    TEXTROW 07h, <                                                                                >
; $-terminated messages for ShowFatalErrorAndExit / ShowOutOfMemoryAndExit.
MsgDeallocError db 'Memory de-allocation error$'
MsgNotEnoughMemory db 'Not enough memory$'
    even
; Active adapter geometry: copied from AdapterGeometry[VideoAdapter] at startup.
; Frame sizes in bytes of masked 8x8, 16x16 and 32x32 sprites and of unmasked 16x16
; level blocks. GeometryWords holds further per-adapter buffer and image sizes that
; AllocateBuffers sums per bank (THEND, PANEL, BLUEBITS, plaque ...); not yet named.
Sprite8Bytes dw 0
Sprite16Bytes dw 0
Sprite32Bytes dw 0
GeometryWords dw 35 dup (0)
BlockBytes dw 0
; Per-adapter geometry (CGA, EGA, Tandy): 39 words copied to the active block at
; Sprite8Bytes (DS:1024), then PlayfieldRowBytes, WideRowBytes and ScreenSegment.
; Only some of the 39 words are named so far.
CgaGeometry dw 20h, 80h, 200h, 1104h, 0DC4h, 1454h, 4Ah, 66h
    dw 14h, 44h, 1E4h, 244h, 0DCh, 76Ch, 0BA4h, 0FE8h
    dw 22Ah, 34Ch, 52Ch, 25Ch, 484h, 634h, 5A4h, 10Eh
    dw 324h, 14h, 94h, 0A4h, 108h, 4Ah, 20h, 2Eh
    dw 2Ch, 3A0h, 3CCh, 3BAh, 3A0h, 0BBEh, 40h
    dw 34h, 50h, 0B800h
EgaGeometry dw 28h, 0A0h, 280h, 2204h, 1B84h, 28A4h, 90h, 0C8h
    dw 24h, 84h, 3C4h, 484h, 1B4h, 0ED4h, 1744h, 1FCCh
    dw 450h, 694h, 0A54h, 4B4h, 904h, 0C64h, 0B44h, 218h
    dw 644h, 24h, 124h, 144h, 20Ch, 90h, 3Ch, 58h
    dw 54h, 73Ch, 794h, 770h, 73Ch, 1778h, 80h
    dw 68h, 0A0h, 0A000h
TandyGeometry dw 40h, 100h, 400h, 2204h, 1B84h, 28A4h, 90h, 0C8h
    dw 24h, 84h, 3C4h, 484h, 1B4h, 0ED4h, 1744h, 1FCCh
    dw 450h, 694h, 0A54h, 4B4h, 904h, 0C64h, 0B44h, 218h
    dw 644h, 24h, 124h, 144h, 20Ch, 90h, 3Ch, 58h
    dw 54h, 73Ch, 794h, 770h, 73Ch, 1778h, 80h
    dw 68h, 0A0h, 0B800h
; Indexed by VideoAdapter.
AdapterGeometry dw offset CgaGeometry, offset EgaGeometry, offset TandyGeometry
; Asset file names. Each is preceded by a word (FFFF in the image) that the resource
; loader reads at name-2, and followed by a zero word with no known reader.
    dw 0FFFFh
File_LEV0MAP_BIC db 'LEV0MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV1MAP_BIC db 'LEV1MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV2MAP_BIC db 'LEV2MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV3MAP_BIC db 'LEV3MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV4MAP_BIC db 'LEV4MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV5MAP_BIC db 'LEV5MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV6MAP_BIC db 'LEV6MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV7MAP_BIC db 'LEV7MAP.BIC',0
    dw 0
    dw 0FFFFh
File_LEV0BLX_BIC db 'LEV0BLX.BIC',0
    dw 0
    dw 0FFFFh
File_LEV1BLX_BIC db 'LEV1BLX.BIC',0
    dw 0
    dw 0FFFFh
File_LEV2BLX_BIC db 'LEV2BLX.BIC',0
    dw 0
    dw 0FFFFh
File_LEV3BLX_BIC db 'LEV3BLX.BIC',0
    dw 0
    dw 0FFFFh
File_LEV4BLX_BIC db 'LEV4BLX.BIC',0
    dw 0
    dw 0FFFFh
File_LEV5BLX_BIC db 'LEV5BLX.BIC',0
    dw 0
    dw 0FFFFh
File_G0_BIC db 'G0.BIC',0
    dw 0
    dw 0FFFFh
File_G1_BIC db 'G1.BIC',0
    dw 0
    dw 0FFFFh
File_G2_BIC db 'G2.BIC',0
    dw 0
    dw 0FFFFh
File_G3_BIC db 'G3.BIC',0
    dw 0
    dw 0FFFFh
File_G4_BIC db 'G4.BIC',0
    dw 0
    dw 0FFFFh
File_G5_BIC db 'G5.BIC',0
    dw 0
    dw 0FFFFh
File_1X1_BIC db '1X1.BIC',0
    dw 0
    dw 0FFFFh
File_2X2_BIC db '2X2.BIC',0
    dw 0
    dw 0FFFFh
File_2X2C_BIC db '2X2C.BIC',0
    dw 0
    dw 0FFFFh
File_MANEXPL_BIC db 'MANEXPL.BIC',0
    dw 0
    dw 0FFFFh
File_LOGO_BIC db 'LOGO.BIC',0
    dw 0
    dw 0FFFFh
File_THEND_BIC db 'THEND.BIC',0
    dw 0
    dw 0FFFFh
File_PANEL_ENC db 'PANEL.ENC',0
    dw 0
    dw 0FFFFh
File_SHIP_BIC db 'SHIP.BIC',0
    dw 0
    dw 0FFFFh
File_BLUEBITS_BIC db 'BLUEBITS.BIC',0
    dw 0
    dw 0FFFFh
File_WINDOW_BIC db 'WINDOW.BIC',0
    dw 0
    dw 0FFFFh
File_IPAGE1_ENC db 'IPAGE1.ENC',0
    dw 0
    dw 0FFFFh
File_IPAGE2_ENC db 'IPAGE2.ENC',0
    dw 0
    dw 0FFFFh
File_IPAGE3_ENC db 'IPAGE3.ENC',0
    dw 0
    dw 0FFFFh
File_IPAGE4_ENC db 'IPAGE4.ENC',0
    dw 0
    dw 0FFFFh
File_IPAGE5_ENC db 'IPAGE5.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE1_ENC db 'OPAGE1.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE2_ENC db 'OPAGE2.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE3_ENC db 'OPAGE3.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE4_ENC db 'OPAGE4.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE5_ENC db 'OPAGE5.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE6_ENC db 'OPAGE6.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE7_ENC db 'OPAGE7.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE8_ENC db 'OPAGE8.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE9_ENC db 'OPAGE9.ENC',0
    dw 0
    dw 0FFFFh
File_OPAGE10_ENC db 'OPAGE10.ENC',0
    dw 0
    dw 0FFFFh
File_OKMENU_ENC db 'okmenu.enc',0
    dw 0
    dw 0FFFFh
File_CALIB_ENC db 'calib.enc',0
    dw 0
    dw 0FFFFh
File_REDEF_ENC db 'redef.enc',0
    dw 0
    dw 0FFFFh
File_HISCORE_ENC db 'hiscore.enc',0
    dw 0
    dw 0FFFFh
File_WINSCR_ENC db 'winscr.enc',0
    dw 0
    dw 0FFFFh
File_PLAQ0_ENC db 'plaq0.enc',0
    dw 0
    dw 0FFFFh
File_PLAQ1_ENC db 'plaq1.enc',0
    dw 0
    dw 0FFFFh
File_PLAQ2_ENC db 'plaq2.enc',0
    dw 0
    dw 0FFFFh
File_PLAQ3_ENC db 'plaq3.enc',0
    dw 0
    dw 0FFFFh
File_PLAQ4_ENC db 'plaq4.enc',0
    dw 0
    dw 0FFFFh
File_PLAQ5_ENC db 'plaq5.enc',0
    dw 0
    dw 0FFFFh
File_LEVSCR_ENC db 'levscr.enc',0
    dw 0
    dw 0FFFFh
File_CHOOSE_ENC db 'choose.enc',0
    dw 0
    even
; Per LevelIndex: the level map, loaded into the segment at CS:9592.
LevelMapFiles label word
    dw offset File_LEV0MAP_BIC, offset File_LEV1MAP_BIC, offset File_LEV2MAP_BIC, offset File_LEV3MAP_BIC
    dw offset File_LEV4MAP_BIC, offset File_LEV5MAP_BIC, offset File_LEV6MAP_BIC, offset File_LEV7MAP_BIC
; Loaded once at startup; FileCacheLoad never caches these (FFFF ends the list).
ResidentFiles label word
    dw offset File_1X1_BIC, offset File_2X2_BIC, offset File_2X2C_BIC, offset File_MANEXPL_BIC
    dw offset File_LOGO_BIC, offset File_THEND_BIC, offset File_PANEL_ENC, offset File_SHIP_BIC
    dw offset File_BLUEBITS_BIC, offset File_WINDOW_BIC
    dw 0FFFFh
; Holds the G file of LevelBankFiles while the BLX file loads.
PendingSpriteFile dw 0
; Per LevelIndex: sprite bank (Gn.BIC, into CS:95AE) and block set (LEVnBLX.BIC,
; into CS:959A). Levels 6 and 7 reuse the files of levels 0 and 3.
LevelBankFiles label word
    dw offset File_G0_BIC, offset File_LEV0BLX_BIC
    dw offset File_G1_BIC, offset File_LEV1BLX_BIC
    dw offset File_G2_BIC, offset File_LEV2BLX_BIC
    dw offset File_G3_BIC, offset File_LEV3BLX_BIC
    dw offset File_G4_BIC, offset File_LEV4BLX_BIC
    dw offset File_G5_BIC, offset File_LEV5BLX_BIC
    dw offset File_G0_BIC, offset File_LEV0BLX_BIC
    dw offset File_G3_BIC, offset File_LEV3BLX_BIC
; Per LevelIndex: the plaque shown for the level, loaded into CS:95B6.
PlaqueFiles label word
    dw offset File_PLAQ5_ENC, offset File_PLAQ0_ENC, offset File_PLAQ1_ENC, offset File_PLAQ2_ENC
    dw offset File_PLAQ3_ENC, offset File_PLAQ4_ENC
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,018h
    db 018h,018h,018h,00h,018h,00h,024h,048h,06Ch,06Ch,00h,00h,00h,00h,00h,024h
    db 07Eh,024h,024h,07Eh,024h,00h,00h,010h,07Eh,050h,07Eh,016h,07Eh,010h,00h,0C6h
    db 0CCh,018h,030h,066h,0C6h,00h,00h,01Ch,036h,01Ch,03Bh,066h,03Bh,00h,018h,018h
    db 08h,010h,00h,00h,00h,00h,0Ch,018h,030h,030h,030h,030h,01Ch,00h,030h,018h
    db 0Ch,0Ch,0Ch,0Ch,038h,00h,00h,06Ch,038h,0FEh,038h,06Ch,00h,00h,00h,018h
    db 018h,07Eh,018h,018h,00h,00h,00h,00h,00h,00h,060h,060h,020h,040h,00h,00h
    db 00h,07Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,018h,018h,00h,00h,03h
    db 06h,0Ch,018h,030h,060h,00h,03Ch,066h,06Eh,07Eh,076h,066h,03Ch,00h,018h,038h
    db 018h,018h,018h,018h,07Eh,00h,03Ch,066h,06h,01Ch,030h,066h,07Eh,00h,03Ch,066h
    db 06h,01Ch,06h,066h,03Ch,00h,01Ch,03Ch,06Ch,0CCh,0FEh,0Ch,01Eh,00h,07Eh,060h
    db 07Ch,06h,06h,066h,03Ch,00h,01Ch,030h,060h,07Ch,066h,066h,03Ch,00h,07Eh,066h
    db 06h,0Ch,018h,018h,018h,00h,03Ch,066h,066h,03Ch,066h,066h,03Ch,00h,03Ch,066h
    db 066h,03Eh,06h,0Ch,038h,00h,00h,018h,018h,00h,018h,018h,00h,00h,00h,018h
    db 018h,00h,018h,018h,08h,010h,01Ch,030h,060h,0C0h,060h,030h,01Ch,00h,00h,03Ch
    db 03Ch,00h,03Ch,03Ch,00h,00h,038h,0Ch,06h,03h,06h,0Ch,038h,00h,00h,07Eh
    db 066h,0Ch,018h,00h,018h,00h,07Ch,0C6h,0DEh,0D6h,0DEh,0C0h,07Ch,00h,03Ch,066h
    db 063h,07Fh,063h,063h,063h,00h,07Ch,066h,063h,07Eh,063h,063h,07Eh,00h,03Ch,066h
    db 060h,060h,060h,063h,03Eh,00h,07Ch,066h,063h,063h,063h,063h,07Eh,00h,07Eh,060h
    db 060h,07Eh,060h,060h,07Fh,00h,07Eh,060h,060h,07Eh,060h,060h,060h,00h,03Ch,066h
    db 060h,06Fh,063h,063h,03Eh,00h,063h,063h,063h,07Fh,063h,063h,063h,00h,01Eh,0Ch
    db 0Ch,0Ch,0Ch,0Ch,01Eh,00h,0Fh,03h,03h,03h,03h,066h,03Ch,00h,063h,063h
    db 066h,07Ch,066h,063h,063h,00h,060h,060h,060h,060h,060h,060h,07Fh,00h,063h,077h
    db 07Fh,06Bh,063h,063h,063h,00h,063h,073h,07Bh,06Fh,067h,063h,063h,00h,03Ch,066h
    db 063h,063h,063h,063h,03Eh,00h,07Ch,066h,063h,07Eh,060h,060h,060h,00h,03Ch,066h
    db 063h,063h,07Bh,06Fh,03Fh,00h,07Ch,066h,063h,07Eh,063h,063h,063h,00h,03Ch,066h
    db 060h,03Eh,03h,063h,03Eh,00h,03Fh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,063h,063h
    db 063h,063h,063h,033h,01Fh,00h,063h,063h,063h,063h,063h,036h,01Ch,00h,063h,063h
    db 063h,063h,06Bh,07Fh,036h,00h,063h,063h,036h,01Ch,036h,063h,063h,00h,033h,033h
    db 033h,01Eh,0Ch,0Ch,0Ch,00h,07Eh,06h,0Ch,018h,030h,060h,07Fh,00h,00h,01Ch
    db 018h,018h,018h,018h,01Ch,00h,00h,0C0h,060h,030h,018h,0Ch,06h,00h,00h,038h
    db 018h,018h,018h,018h,038h,00h,010h,038h,07Ch,038h,038h,038h,038h,00h,00h,00h
    db 00h,00h,00h,00h,00h,0FEh,00h,03Eh,032h,020h,070h,020h,07Eh,00h,00h,00h
    db 01Eh,03h,03Fh,063h,03Fh,00h,060h,060h,07Ch,066h,063h,063h,07Eh,00h,00h,00h
    db 03Ch,066h,060h,063h,03Eh,00h,03h,03h,01Fh,033h,063h,063h,03Fh,00h,00h,00h
    db 03Ch,066h,07Eh,060h,03Fh,00h,01Eh,033h,030h,03Ch,030h,030h,030h,00h,00h,00h
    db 01Fh,033h,063h,03Fh,03h,07Eh,060h,060h,07Ch,066h,063h,063h,063h,00h,0Ch,00h
    db 0Ch,0Ch,0Ch,0Ch,0Ch,00h,03h,00h,03h,03h,03h,03h,066h,03Ch,060h,060h
    db 066h,066h,07Ch,066h,063h,00h,018h,018h,018h,018h,018h,018h,0Ch,00h,00h,00h
    db 076h,07Fh,06Bh,06Bh,063h,00h,00h,00h,07Ch,066h,063h,063h,063h,00h,00h,00h
    db 03Ch,066h,063h,063h,03Eh,00h,00h,00h,07Ch,066h,063h,07Eh,060h,060h,00h,00h
    db 01Fh,033h,063h,03Fh,03h,03h,00h,00h,07Eh,063h,060h,060h,060h,00h,00h,00h
    db 03Ch,060h,03Eh,03h,07Eh,00h,030h,030h,03Ch,030h,030h,033h,01Eh,00h,00h,00h
    db 063h,063h,063h,033h,01Fh,00h,00h,00h,063h,063h,063h,036h,01Ch,00h,00h,00h
    db 063h,063h,06Bh,07Fh,036h,00h,00h,00h,063h,036h,01Ch,036h,063h,00h,00h,00h
    db 063h,063h,033h,01Fh,03h,07Eh,00h,00h,07Eh,0Ch,018h,030h,07Fh,00h,00h,01Ch
    db 018h,030h,030h,018h,01Ch,00h,018h,018h,018h,018h,018h,018h,018h,00h,00h,038h
    db 018h,0Ch,0Ch,018h,038h,00h,00h,00h,00h,0F6h,0DEh,00h,00h,00h,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h
    db 055h,055h,055h,055h,055h,055h,01h,01h,01h,011h,01h,015h,055h,055h,055h,055h
    db 011h,011h,011h,01h,011h,015h,055h,055h,055h,055h,011h,011h,01h,011h,01h,015h
    db 055h,055h,055h,055h,011h,011h,05h,011h,011h,015h,055h,055h,055h,055h,011h,01h
    db 011h,011h,011h,01h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
    db 07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
    db 05h,01h,011h,01h,015h,01h,055h,055h,055h,055h,011h,011h,011h,011h,015h,015h
    db 055h,055h,055h,055h,011h,011h,011h,01h,015h,05h,055h,055h,055h,055h,011h,011h
    db 011h,011h,015h,015h,055h,055h,055h,055h,01h,01h,01h,01h,01h,01h,055h,055h
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,041h,044h,04h,04h,04h,04h,04h
    db 055h,055h,055h,044h,044h,044h,054h,044h,044h,044h,055h,055h,055h,044h,044h,04h
    db 044h,044h,044h,04h,055h,055h,055h,044h,044h,044h,044h,044h,044h,044h,055h,055h
    db 055h,040h,044h,044h,04h,04h,044h,044h,05h,055h,055h,055h,055h,055h,055h,055h
    db 055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h
    db 055h,055h,055h,01h,01h,01h,01h,011h,015h,01h,01h,055h,055h,015h,011h,011h
    db 015h,011h,015h,011h,015h,055h,055h,01h,015h,01h,05h,011h,015h,01h,01h,055h
    db 055h,051h,011h,05h,015h,01h,015h,011h,051h,055h,055h,01h,01h,011h,01h,011h
    db 01h,011h,01h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h
    db 05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,050h,010h,010h
    db 010h,011h,050h,010h,015h,055h,055h,051h,051h,011h,054h,051h,051h,011h,055h,055h
    db 055h,050h,050h,010h,014h,051h,050h,010h,015h,055h,055h,051h,051h,015h,014h,051h
    db 051h,015h,015h,055h,055h,051h,051h,010h,014h,050h,011h,010h,015h,055h,055h,055h
    db 055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h
    db 055h,055h,055h,055h,055h,055h,055h,054h,04h,040h,040h,045h,040h,040h,055h,055h
    db 055h,054h,044h,044h,045h,045h,044h,045h,055h,055h,055h,054h,04h,044h,044h,045h
    db 040h,040h,055h,055h,055h,054h,014h,044h,044h,045h,044h,054h,055h,055h,055h,054h
    db 044h,044h,040h,040h,044h,040h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
    db 055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
    db 055h,050h,010h,010h,010h,010h,011h,010h,015h,055h,055h,051h,011h,011h,014h,051h
    db 011h,011h,015h,055h,055h,051h,051h,011h,014h,051h,011h,010h,015h,055h,055h,051h
    db 011h,011h,014h,051h,011h,010h,055h,055h,055h,050h,010h,011h,014h,050h,010h,011h
    db 015h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,051h,010h,015h,051h
    db 010h,015h,055h,055h,055h,055h,051h,011h,015h,051h,011h,015h,055h,055h,055h,055h
    db 050h,011h,010h,010h,011h,015h,055h,055h,055h,055h,055h,011h,015h,055h,011h,015h
    db 055h,055h,055h,055h,050h,010h,015h,050h,010h,015h,055h,055h,055h,055h,055h,055h
    db 055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h
    db 055h,055h,055h,055h,055h,01h,011h,01h,01h,01h,01h,01h,015h,055h,055h,015h
    db 011h,011h,011h,011h,011h,015h,015h,055h,055h,01h,01h,01h,01h,01h,011h,05h
    db 015h,055h,055h,051h,011h,05h,011h,015h,011h,015h,015h,055h,055h,01h,011h,011h
    db 011h,015h,011h,01h,01h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
    db 07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,040h
    db 044h,04h,04h,04h,04h,04h,05h,055h,055h,045h,044h,044h,054h,044h,044h,054h
    db 055h,055h,055h,041h,044h,04h,014h,044h,044h,04h,015h,055h,055h,045h,044h,014h
    db 054h,044h,045h,044h,055h,055h,055h,045h,044h,044h,04h,044h,04h,04h,05h,055h
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,040h,044h,014h,04h,04h,04h,044h
    db 05h,055h,055h,045h,044h,044h,054h,044h,044h,04h,055h,055h,055h,040h,044h,044h
    db 014h,04h,04h,044h,05h,055h,055h,054h,044h,044h,054h,044h,014h,045h,045h,055h
    db 055h,040h,044h,04h,04h,044h,044h,044h,05h,055h,055h,055h,055h,055h,055h,055h
    db 055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h
    db 055h,055h,055h,055h,050h,050h,010h,010h,010h,015h,055h,055h,055h,055h,051h,011h
    db 011h,011h,011h,055h,055h,055h,055h,055h,051h,010h,011h,011h,010h,055h,055h,055h
    db 055h,055h,051h,010h,051h,011h,011h,055h,055h,055h,055h,055h,050h,011h,010h,011h
    db 010h,015h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h
    db 05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,050h,010h
    db 010h,011h,010h,015h,055h,055h,055h,055h,051h,051h,051h,011h,014h,055h,055h,055h
    db 055h,055h,050h,011h,051h,011h,014h,055h,055h,055h,055h,055h,055h,011h,051h,011h
    db 014h,055h,055h,055h,055h,055h,050h,010h,010h,010h,014h,055h,055h,055h,055h,055h
    db 055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h
    db 055h,055h,055h,055h,055h,055h,055h,054h,04h,040h,044h,040h,040h,040h,055h,055h
    db 055h,054h,054h,045h,044h,051h,045h,044h,055h,055h,055h,054h,014h,044h,040h,051h
    db 041h,041h,055h,055h,055h,054h,054h,044h,044h,051h,045h,044h,055h,055h,055h,054h
    db 054h,040h,044h,051h,040h,044h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
    db 055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
    db 055h,054h,04h,04h,044h,040h,040h,040h,055h,055h,055h,054h,054h,044h,044h,045h
    db 045h,044h,055h,055h,055h,054h,054h,014h,044h,040h,041h,041h,055h,055h,055h,054h
    db 054h,044h,044h,054h,045h,044h,055h,055h,055h,054h,04h,044h,04h,040h,040h,044h
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
EventX dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h
    db 00h,00h
FormationSizeClass dw 00000h
FormationDrawPass dw 00000h
FormationType dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h
    db 00h,00h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h
    db 00h,00h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,090h
EventTrigger dw 00000h
; UNKNOWN: not yet classified as code or data
    db 0A8h,020h,041h,06Eh,06Fh,074h,068h,065h,072h,020h
    db 04Dh,065h,067h,061h,020h,053h,074h,065h,020h,043h,06Fh,072h,06Bh,020h,043h,072h
    db 065h,061h,074h,069h,06Fh,06Eh,021h,090h,00h,00h,0F5h,0C5h,0F7h,0C5h,0F9h,0C5h
    db 0FBh,0C5h,0FDh,0C5h,0FFh,0C5h,06h,0EEh,06Ch,0EEh,07Ah,0EEh,084h,0EEh,0F6h,0EEh
    db 048h,0EFh,010h,03h,011h,0Ch,03h,020h,053h,057h,041h,050h,020h,044h,049h,053h
    db 04Bh,053h,02Ch,020h,050h,052h,045h,053h,053h,020h,046h,049h,052h,045h,020h,00h
    db 010h,02h,011h,0Ch,03h,020h,052h,045h,041h,044h,020h,045h,052h,052h,04Fh,052h
    db 02Ch,020h,050h,052h,045h,053h,053h,020h,046h,049h,052h,045h,020h,00h,011h,0Ch
    db 03h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h
    db 020h,020h,020h,020h,020h,020h,020h,020h,020h,00h
; Previous INT 09h vector (segment word, then offset), saved by InstallKeyboardVector09.
KbdSavedInt09 db 00h,00h,00h,00h
; Eight scancodes each, collected by RCL into InputBits bits 7..0 (slot n feeds bit
; 7-n). Table A initially holds Z,Space,Q,A,O,P for bits 5..0 and is rewritten by
; the key redefinition; table B's initial 77h..7Ch are not IBM set-1 keys.
KeyBitScancodesA db 00h,00h
; UNKNOWN: not yet classified as code or data
    db 02Ch,039h,010h,01Eh,018h,019h
KeyBitScancodesB db 00h,00h,02Ch,077h,07Ch,07Bh,07Ah,079h,07h,00h
; UNKNOWN: not yet classified as code or data
    db 08h,00h,0Ah,00h,08h,00h,09h,00h,08h,00h
; ComputeRecordGridOffset stores its wrapped Y sum here.
GridYSum dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,090h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h
; Shared DOS file descriptor used by LoadFileToBuffer and SaveBufferToFile.
FileBufferSegment dw 00000h
FileBufferOffset dw 00000h
FileByteCount dw 00000h
FileNamePtr dw 00000h
FileHandle dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,03h
    db 0Ch,0Fh,030h,033h,03Ch,03Fh,0C0h,0C3h,0CCh,0CFh,0F0h,0F3h,0FCh,0FFh,00h,055h
    db 0AAh,0FFh,00h,00h,00h,00h
HiscoreFileName db 'hiscore.dat',00h
; UNKNOWN: not yet classified as code or data
    db 011h,04h,00h,010h,0Ah,00h
; hiscore.dat image: 8 score entries then 27 settings bytes (SavedSettings), followed
; in the file by an additive checksum word; stored XOR-coded (XorCodeHiscoreBlock).
HiscoreBlock db 053h,074h,065h,020h,043h,06Fh,072h,06Bh
    db 020h,020h,020h,00h,00h,080h,00h,00h,054h,069h,06Eh,079h,020h,057h,02Eh,020h
    db 020h,020h,020h,00h,00h,070h,00h,00h,04Dh,02Eh,048h,06Fh,06Ch,06Ch,061h,06Eh
    db 064h,020h,020h,00h,00h,060h,00h,00h,050h,02Eh,04Dh,075h,072h,072h,061h,079h
    db 020h,020h,020h,00h,00h,050h,00h,00h,043h,068h,072h,069h,073h,020h,057h,06Fh
    db 06Fh,064h,020h,00h,00h,040h,00h,00h,04Ah,06Fh,068h,06Eh,020h,057h,02Eh,020h
    db 020h,020h,020h,00h,00h,030h,00h,00h,052h,02Eh,054h,02Eh,053h,06Dh,069h,074h
    db 068h,020h,020h,00h,00h,020h,00h,00h,04Dh,02Eh,054h,073h,063h,068h,06Fh,065h
    db 067h,06Ch,020h,00h,00h,010h,00h,00h,03Ch,04Fh,076h,065h,072h,04Bh,069h,06Ch
    db 06Ch,03Eh,020h,00h,00h,00h,00h,00h
SavedSettings db 00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,090h,00h,00h,020h,020h,020h,020h,020h,020h
    db 020h,020h,020h,020h,024h,011h,00h,0Bh,010h,00h,00h,0Dh,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,00h,00h,010h,0Fh,00h,090h
    db 00h,00h,00h,00h
; Quit prompt answer, 'N' or 'Y'.
QuitAnswer db 00h
SoundOption dw 00002h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h
; Indexed by SoundOption (0..3): the high byte becomes SfxEnabled, the low byte
; ModuleSoundEnabled.
SoundOptionFlags db 01h,00h,00h,01h,01h,01h,00h,00h,090h,00h,090h,0Dh,0Ah,024h,00h
; UNKNOWN: not yet classified as code or data
    db 07h,049h,020h,063h,06Fh,075h,06Ch,064h,020h,06Eh,06Fh,074h,020h,066h,069h,06Eh
    db 064h,020h,074h,068h,065h,020h,066h,069h,06Ch,065h,020h,027h,024h,027h,020h,061h
    db 06Eh,079h,077h,068h,065h,072h,065h,02Ch,020h,073h,06Fh,072h,072h,079h,02Eh,0Dh
    db 0Ah,0Dh,0Ah,024h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,03h,00h
ScoreBcd db 00h,00h,00h,00h,010h,0Ah,011h,0Dh,01Dh,00h,08h,01h
; UNKNOWN: not yet classified as code or data
    db 03h,07h,09h,0Ah
CountGate2324 dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h
    db 00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h
ScrollWindowOffset dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h
    db 00h,00h,00h,00h,00h,00h
; Level 0..5: selects LEVnMAP.BIC, the attribute patch stream and 6-entry tables;
; advanced modulo LEVEL_COUNT when a level is completed.
LevelIndex dw 00000h
; Starts at INITIAL_LIVES; the HUD draws one icon per life; -1 ends the game.
LivesLeft dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,010h,0Ah,011h,0Fh
    db 020h,00h,036h,031h,032h,033h,034h,035h,04h,00h,04h,00h,04h,00h,04h,00h
    db 04h,00h,04h,00h,00h,080h,00h,00h,00h,00h,00h,00h
; The player's record; the last entry of PoolAPointers.
PrimaryRecord db RECORD_SIZE dup (0)
; 35 records after the primary; FindFreeRecordPoolA scans from PoolACursor.
PoolA db POOL_A_COUNT * RECORD_SIZE dup (0)
; 34 records, only ever drawn as 8x8 sprites; FindFreeRecordPoolB scans from PoolBCursor.
PoolB label byte
PoolAEnd db POOL_B_COUNT * RECORD_SIZE dup (0)
PoolBEnd label byte
; Static pointers to pool A's records then the primary (36 words), and pool B's.
; Loops index them with BX = 2*CX for CX = count..1, hence the "- 2" displacements.
PoolAPointers label word
I = 0
rept POOL_A_COUNT
    dw offset PoolA + I * RECORD_SIZE
I = I + 1
endm
    dw offset PrimaryRecord
; Background saved under each record's sprite before drawing (REC_SAVE_BUFFER); assigned
; in PoolAPointers order from the end, so the primary gets the first one.
; Size 2 records use a second half at +140h.
PoolASaveBuffers db POOL_A_POINTER_COUNT * POOL_A_SAVE_BYTES dup (0)
PoolBPointers label word
I = 0
rept POOL_B_COUNT
    dw offset PoolB + I * RECORD_SIZE
I = I + 1
endm
PoolBSaveBuffers db POOL_B_COUNT * POOL_B_SAVE_BYTES dup (0)
PoolACursor dw 023B4h
PoolBCursor dw 02B5Ch
; UNKNOWN: not yet classified as code or data
    db 00h,00h
; Per LevelIndex: handler called with AL = level map byte while a map row is set up.
LevelMapCellHandlers dw offset loc_07BCB, offset loc_07977, offset loc_07B06, offset loc_07C3F, offset loc_07CA2, offset loc_07DC8
; UNKNOWN: not yet classified as code or data
    db 01h,00h,00h,00h,01h,00h
    db 02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,082h,096h,08Ch,096h
    db 096h,096h,0A0h,096h,024h,00h,0D7h,083h,0AFh,044h,00h,00h,0DEh,083h,02h,084h
    db 01h,00h,0E4h,083h,0Ah,084h,02h,00h,0EAh,083h,012h,084h,03h,00h,0F0h,083h
    db 01Ah,084h,04h,00h,0F6h,083h,022h,084h,05h,00h,0FCh,083h,02Ah,084h,0FFh,0FFh
    db 0FFh,0FFh,0AFh,044h,024h,00h,0D7h,083h,0AFh,044h,06h,00h,037h,084h,03Dh,084h
    db 07h,00h,045h,084h,04Eh,084h,0FFh,0FFh,0FFh,0FFh,0AFh,044h,024h,00h,0D7h,083h
    db 0AFh,044h,09h,00h,056h,084h,063h,084h,0Ah,00h,068h,084h,09Dh,084h,0Bh,00h
    db 0A2h,084h,0C3h,084h,0FFh,0FFh,0FFh,0FFh,0AFh,044h,024h,00h,0D7h,083h,0AFh,044h
    db 0Dh,00h,0C9h,084h,0D6h,084h,0Eh,00h,0F0h,084h,0FDh,084h,0FFh,0FFh,0FFh,0FFh
    db 0AFh,044h,00h,00h,00h,00h,0Fh,00h,04h,096h,00h,00h,00h,00h,00h,00h
    db 011h,00h,034h,096h,00h,00h,00h,00h,00h,00h,013h,00h,04Ch,096h,00h,00h
    db 00h,00h,00h,00h,015h,00h,06Ah,096h,00h,00h,00h,00h,01h,02h,03h,04h
    db 05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,04h,03h,02h,01h
    db 00h,00h,00h,00h,01h,00h,01h,00h,02h,00h,02h,00h,01h,00h,01h,00h
    db 00h,00h,00h,00h,01h,00h,02h,00h,01h,00h,047h,01h,0BEh,00h,0BEh,00h
    db 045h,01h,045h,01h,045h,01h,047h,01h,045h,01h,00h,00h,04h,00h,02h,00h
    db 080h,00h,040h,00h,040h,00h,090h,00h,080h,00h,090h,00h,0A0h,00h,030h,00h
    db 030h,00h,0A0h,00h,050h,00h,0A0h,00h,030h,075h,060h,00h,0A0h,00h,060h,00h
    db 090h,00h,050h,00h,00h,00h,050h,00h,00h,00h,010h,00h,080h,00h,010h,00h
    db 030h,075h,060h,00h,0A0h,00h,070h,00h,090h,00h,080h,00h,00h,00h,080h,00h
    db 00h,00h,0C0h,00h,080h,00h,0C0h,00h,030h,075h,070h,00h,080h,00h,00h,00h
    db 0A0h,00h,060h,00h,070h,00h,060h,00h,030h,00h,0C0h,00h,00h,00h,0C0h,00h
    db 030h,00h,060h,00h,060h,00h,090h,00h,030h,075h,060h,00h,060h,00h,0A0h,00h
    db 030h,075h,060h,00h,0B0h,00h,0C0h,00h,0B0h,00h,00h,00h,0A0h,00h,00h,00h
    db 0A0h,00h,0C0h,00h,090h,00h,0C0h,00h,090h,00h,00h,00h,080h,00h,00h,00h
    db 080h,00h,0C0h,00h,030h,075h,060h,00h,0FFh,0FFh,00h,00h
; Cheat flags, set by the typed codes below (CheckCheatCodes).
WhatOilShortageFlag db 0
; Keep the life count when a life is lost.
KeepLivesFlag db 0
; Keys 3 (and others) grant pickup effects during play.
BonusKeysEnabled db 0
; F4 skips to the next level.
LevelSkipEnabled db 0
; Fire without waiting for the fire latch (DS:A980) to clear.
RapidFireEnabled db 0
; Set only together with all the others; no reader found.
AllCheatsFlag db 0
; Typed cheat codes: a cursor to the next expected scancode, then the scancodes,
; 0-terminated. MatchCheatKey compares KeyLastMakeCode with the cursor's byte.
; WHATOILSHORTAGE: sets WhatOilShortageFlag (no reader found).
CheatWhatOilShortage dw offset CheatWhatOilShortage + 2
    db SCAN_W, SCAN_H, SCAN_A, SCAN_T, SCAN_O, SCAN_I, SCAN_L, SCAN_S, SCAN_H, SCAN_O
    db SCAN_R, SCAN_T, SCAN_A, SCAN_G, SCAN_E, 0
; LIFEINTHEFASTLANE: sets KeepLivesFlag.
CheatLifeInTheFastLane dw offset CheatLifeInTheFastLane + 2
    db SCAN_L, SCAN_I, SCAN_F, SCAN_E, SCAN_I, SCAN_N, SCAN_T, SCAN_H, SCAN_E, SCAN_F
    db SCAN_A, SCAN_S, SCAN_T, SCAN_L, SCAN_A, SCAN_N, SCAN_E, 0
; BONUSCHEATON: sets BonusKeysEnabled.
CheatBonusCheatOn dw offset CheatBonusCheatOn + 2
    db SCAN_B, SCAN_O, SCAN_N, SCAN_U, SCAN_S, SCAN_C, SCAN_H, SCAN_E, SCAN_A, SCAN_T
    db SCAN_O, SCAN_N, 0
; MYNAMEISSMITH: sets LevelSkipEnabled.
CheatMyNameIsSmith dw offset CheatMyNameIsSmith + 2
    db SCAN_M, SCAN_Y, SCAN_N, SCAN_A, SCAN_M, SCAN_E, SCAN_I, SCAN_S, SCAN_S, SCAN_M
    db SCAN_I, SCAN_T, SCAN_H, 0
; GIBSTMIRSCHNELLFEUER: sets RapidFireEnabled.
CheatGibStMirSchnellfeuer dw offset CheatGibStMirSchnellfeuer + 2
    db SCAN_G, SCAN_I, SCAN_B, SCAN_S, SCAN_T, SCAN_M, SCAN_I, SCAN_R, SCAN_S, SCAN_C
    db SCAN_H, SCAN_N, SCAN_E, SCAN_L, SCAN_L, SCAN_F, SCAN_E, SCAN_U, SCAN_E, SCAN_R
    db 0
; REMINDMETOSMILEYOUKNOWTHEOLDFRIENDSLINE: sets all six flags.
CheatRemindMe dw offset CheatRemindMe + 2
    db SCAN_R, SCAN_E, SCAN_M, SCAN_I, SCAN_N, SCAN_D, SCAN_M, SCAN_E, SCAN_T, SCAN_O
    db SCAN_S, SCAN_M, SCAN_I, SCAN_L, SCAN_E, SCAN_Y, SCAN_O, SCAN_U, SCAN_K, SCAN_N
    db SCAN_O, SCAN_W, SCAN_T, SCAN_H, SCAN_E, SCAN_O, SCAN_L, SCAN_D, SCAN_F, SCAN_R
    db SCAN_I, SCAN_E, SCAN_N, SCAN_D, SCAN_S, SCAN_L, SCAN_I, SCAN_N, SCAN_E, 0
; EVERYDAYIDIE: clears all six flags.
CheatEveryDayIDie dw offset CheatEveryDayIDie + 2
    db SCAN_E, SCAN_V, SCAN_E, SCAN_R, SCAN_Y, SCAN_D, SCAN_A, SCAN_Y, SCAN_I, SCAN_D
    db SCAN_I, SCAN_E, 0
    even
; UNKNOWN: not yet classified as code or data
    db 010h,00h,010h,00h,040h,00h,040h,00h
    db 010h,00h,040h,00h,020h,00h,020h,00h,00h,00h,00h,00h,050h,00h,030h,00h
    db 010h,00h,070h,00h,030h,00h,090h,00h,040h,00h,090h,00h,020h,00h,0B0h,00h
    db 00h,00h,070h,00h,020h,00h,050h,00h,040h,00h,0A0h,00h,050h,00h,0C0h,00h
    db 020h,00h,090h,00h,050h,00h,060h,00h,040h,00h,040h,00h,030h,00h,030h,00h
    db 020h,00h,010h,00h,030h,00h,090h,00h,010h,00h,0C0h,00h,00h,00h,0B0h,00h
    db 030h,00h,020h,00h,030h,00h,080h,00h,010h,00h,00h,00h,030h,00h,060h,00h
    db 040h,00h,010h,00h,00h,00h,060h,00h,020h,00h,090h,00h,040h,00h,080h,00h
    db 0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,02h,00h,0FFh,0FFh,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
InputBits db 00h
; UNKNOWN: not yet classified as code or data
    db 00h
; Every one of its 52 tests gates an SfxRequest write or waits on SfxActive.
SfxEnabled db 01h
; Gates CB1C's copy of ModuleSoundRequest into module header word +8.
ModuleSoundEnabled db 01h
ModuleSoundRequest db 00h
KeyLastMakeCode db 00h
; One byte per scancode, KEY_STATE_DOWN while held; kept by Interrupt09KeyboardHandler.
KeyDownTable db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h
VideoBiosModeTable db 04h,0Dh,09h
; The 90h filler byte is the assembler's word alignment (NOP) before the next table.
    even
; Row offset tables built at startup by BuildRowTables (all zero in the image).
; Indexed by 2*REC_Y (REC_Y below E0h): playfield row offset of record row REC_Y-32,
; or FFFF for rows 0..15 and 224..255.
RecordRowOffsets dw 256 dup (0)
; 200 rows at PlayfieldRowBytes, 200 at WideRowBytes, and 200 screen-memory row
; addresses in the current adapter's video layout.
PlayfieldRowOffsets dw 200 dup (0)
WideRowOffsets dw 200 dup (0)
ScreenRowOffsets dw 200 dup (0)
; The program stack (SS = DS); SP starts at StackTop.
StackArea db STACK_BYTES dup (0)
StackTop label word
; Added to REC_Y of records that move with the scrolling playfield.
ScrollDeltaY dw 0
HistoryPairs db 00h,00h,00h,00h,00h,00h
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
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
HistoryEnd label word
HistoryWriteCursor dw 00000h
HistoryReadCursor15 dw 00000h
HistoryReadCursor31 dw 00000h
HistoryCursor47 dw 00000h
; Requests raised during a frame and acted on by the main loop.
GameOverRequest dw 00000h
NextLevelRequest dw 00000h
LifeLostRequest dw 00000h
; REC_DIRECTION by AimQuadrantBits: 0 up, 2 right, 4 down, 6 left, odd values the
; diagonals between them; FFh when aligned (no move).
DirectionFromQuadrant db 0FFh,02h,06h,02h,04h,03h,05h,04h
    db 00h,01h,07h,00h,00h,02h,06h,02h
; UNKNOWN: not yet classified as code or data
    db 0AAh,00h,058h,00h,00h,00h,058h,00h
XAdjustPathTaken dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,090h,00h,00h,00h,00h
; Offset pairs at DS:A368; three adjacent pairs, caller index bound not proven.
OffsetTableA368 dw 010h ; offset pair 0 field Y, signed value 16
    dw 0FFF8h ; offset pair 0 field X, signed value -8
    dw 0Ch ; offset pair 1 field Y, signed value 12
    dw 0FFF4h ; offset pair 1 field X, signed value -12
    dw 0Fh ; offset pair 2 field Y, signed value 15
    dw 0FFF3h ; offset pair 2 field X, signed value -13
; Offset pairs at DS:A374; three adjacent pairs, caller index bound not proven.
OffsetTableA374 dw 010h ; offset pair 0 field Y, signed value 16
    dw 018h ; offset pair 0 field X, signed value 24
    dw 0Ch ; offset pair 1 field Y, signed value 12
    dw 01Ch ; offset pair 1 field X, signed value 28
    dw 0Fh ; offset pair 2 field Y, signed value 15
    dw 01Dh ; offset pair 2 field X, signed value 29
; Offset pairs at DS:A380; three adjacent pairs, caller index bound not proven.
OffsetTableA380 dw 014h ; offset pair 0 field Y, signed value 20
    dw 0FFECh ; offset pair 0 field X, signed value -20
    dw 010h ; offset pair 1 field Y, signed value 16
    dw 0FFE8h ; offset pair 1 field X, signed value -24
    dw 013h ; offset pair 2 field Y, signed value 19
    dw 0FFE7h ; offset pair 2 field X, signed value -25
; Offset pairs at DS:A38C; three adjacent pairs, caller index bound not proven.
OffsetTableA38C dw 014h ; offset pair 0 field Y, signed value 20
    dw 024h ; offset pair 0 field X, signed value 36
    dw 010h ; offset pair 1 field Y, signed value 16
    dw 028h ; offset pair 1 field X, signed value 40
    dw 013h ; offset pair 2 field Y, signed value 19
    dw 029h ; offset pair 2 field X, signed value 41
OffsetXWork dw 00000h
OffsetXGroupA dw 00000h
OffsetXGroupB dw 00000h
ClampXLowSeen db 00h
ClampXHighSeen db 00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,06h,00h,0Ch,00h,00h,00h,0Ch,00h
    db 00h,00h,0Ch,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,020h,00h
    db 018h,00h,010h,00h,020h,00h,098h,00h,013h,00h,040h,00h,028h,00h,016h,00h
    db 040h,00h,088h,00h,019h,00h,00h,00h,00h,00h,00h,00h,00h,01h,02h,03h
    db 04h,03h,02h,01h,019h,00h,08h,00h,016h,00h,08h,00h,018h,00h,08h,00h
    db 0FBh,0FFh,08h,00h,0F3h,0FFh,08h,00h,0F2h,0FFh,08h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; Round-robin cursor over pool A used by the target search at B15A.
TargetSearchCursor dw 023B4h
; UNKNOWN: not yet classified as code or data
    db 050h,00h,0B0h,00h
; UNKNOWN: not yet classified as code or data
    db 090h,00h,068h,00h,010h,00h,068h,00h,00h,00h,080h,00h,040h,00h,090h,00h
    db 0A0h,00h,068h,00h,0B0h,00h,0B0h,00h,030h,075h,0B0h,00h,050h,00h,010h,00h
    db 090h,00h,058h,00h,010h,00h,058h,00h,00h,00h,040h,00h,040h,00h,030h,00h
    db 0A0h,00h,058h,00h,0B0h,00h,010h,00h,030h,075h,010h,00h
MoveModeA47C dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h
    db 00h,00h,00h,00h,020h,00h,010h,00h,030h,00h,010h,00h,010h,00h,020h,00h
    db 040h,00h,040h,00h,020h,00h,070h,00h,010h,00h,060h,00h,030h,00h,0B0h,00h
    db 010h,00h,090h,00h,040h,00h,070h,00h,050h,00h,030h,00h,060h,00h,020h,00h
    db 010h,00h,030h,00h,010h,00h,040h,00h,020h,00h,050h,00h,010h,00h,080h,00h
    db 020h,00h,0B0h,00h,010h,00h,0A0h,00h,030h,00h,060h,00h,060h,00h,0A0h,00h
    db 050h,00h,060h,00h,050h,00h,090h,00h,040h,00h,050h,00h,040h,00h,060h,00h
    db 040h,00h,080h,00h,030h,075h,0C0h,00h,020h,00h,0C0h,00h,00h,00h,0B0h,00h
    db 020h,00h,0B0h,00h,040h,00h,0A0h,00h,020h,00h,0A0h,00h,00h,00h,090h,00h
    db 020h,00h,090h,00h,040h,00h,080h,00h,020h,00h,080h,00h,00h,00h,070h,00h
    db 020h,00h,070h,00h,040h,00h,060h,00h,020h,00h,060h,00h,00h,00h,050h,00h
    db 020h,00h,050h,00h,040h,00h,040h,00h,020h,00h,040h,00h,00h,00h,030h,00h
    db 020h,00h,030h,00h,040h,00h,020h,00h,020h,00h,020h,00h,00h,00h,010h,00h
    db 020h,00h,010h,00h,040h,00h,00h,00h,020h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
    db 080h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,080h,00h,0C0h,00h,0FFh,0FFh,0FFh,0FFh
    db 040h,00h,0C0h,00h,060h,00h,0C0h,00h,040h,00h,0B0h,00h,020h,00h,0B0h,00h
    db 040h,00h,0A0h,00h,060h,00h,0A0h,00h,040h,00h,090h,00h,020h,00h,090h,00h
    db 040h,00h,080h,00h,060h,00h,080h,00h,040h,00h,070h,00h,020h,00h,070h,00h
    db 040h,00h,060h,00h,060h,00h,060h,00h,040h,00h,050h,00h,020h,00h,050h,00h
    db 040h,00h,040h,00h,060h,00h,040h,00h,040h,00h,030h,00h,020h,00h,030h,00h
    db 040h,00h,020h,00h,060h,00h,020h,00h,040h,00h,010h,00h,020h,00h,010h,00h
    db 030h,075h,00h,00h,020h,00h,0C0h,00h,0B0h,00h,0C0h,00h,0B0h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,0B0h,00h,010h,00h,0B0h,00h,010h,00h,010h,00h
    db 020h,00h,010h,00h,020h,00h,0B0h,00h,030h,00h,0B0h,00h,030h,00h,010h,00h
    db 040h,00h,010h,00h,040h,00h,0B0h,00h,050h,00h,0B0h,00h,050h,00h,010h,00h
    db 060h,00h,010h,00h,060h,00h,0B0h,00h,070h,00h,0B0h,00h,070h,00h,010h,00h
    db 080h,00h,010h,00h,080h,00h,0B0h,00h,090h,00h,0B0h,00h,090h,00h,010h,00h
    db 0A0h,00h,010h,00h,0A0h,00h,0B0h,00h,0B0h,00h,0B0h,00h,0B0h,00h,00h,00h
    db 00h,00h,00h,00h,0FFh,0FFh,0D4h,0A5h,00h,00h,0B0h,00h,010h,00h,0B0h,00h
    db 00h,00h,0B0h,00h,010h,00h,0A0h,00h,00h,00h,0B0h,00h,010h,00h,090h,00h
    db 00h,00h,0B0h,00h,020h,00h,080h,00h,00h,00h,0B0h,00h,020h,00h,070h,00h
    db 00h,00h,060h,00h,010h,00h,060h,00h,00h,00h,010h,00h,010h,00h,010h,00h
    db 00h,00h,010h,00h,010h,00h,020h,00h,00h,00h,010h,00h,010h,00h,030h,00h
    db 00h,00h,010h,00h,020h,00h,040h,00h,00h,00h,010h,00h,020h,00h,050h,00h
    db 060h,00h,010h,00h,030h,00h,020h,00h,060h,00h,020h,00h,030h,00h,030h,00h
    db 060h,00h,030h,00h,050h,00h,030h,00h,060h,00h,040h,00h,040h,00h,050h,00h
    db 060h,00h,050h,00h,030h,00h,060h,00h,060h,00h,060h,00h,040h,00h,060h,00h
    db 060h,00h,070h,00h,050h,00h,060h,00h,060h,00h,080h,00h,040h,00h,070h,00h
    db 060h,00h,090h,00h,050h,00h,090h,00h,060h,00h,0A0h,00h,030h,00h,090h,00h
    db 060h,00h,0B0h,00h,030h,00h,0A0h,00h,090h,00h,030h,00h,0FFh,0FFh,0FFh,0FFh
    db 030h,075h,00h,00h,00h,00h,060h,00h,010h,00h,050h,00h,010h,00h,060h,00h
    db 010h,00h,070h,00h,020h,00h,060h,00h,020h,00h,060h,00h,030h,00h,060h,00h
    db 030h,00h,060h,00h,040h,00h,060h,00h,040h,00h,060h,00h,050h,00h,060h,00h
    db 050h,00h,060h,00h,060h,00h,070h,00h,060h,00h,070h,00h,050h,00h,080h,00h
    db 050h,00h,080h,00h,040h,00h,090h,00h,040h,00h,090h,00h,030h,00h,0A0h,00h
    db 050h,00h,0B0h,00h,020h,00h,0B0h,00h,030h,00h,0B0h,00h,010h,00h,0C0h,00h
    db 020h,00h,0B0h,00h,00h,00h,0C0h,00h,010h,00h,0A0h,00h,00h,00h,00h,00h
    db 010h,00h,020h,00h,010h,00h,00h,00h,020h,00h,010h,00h,020h,00h,010h,00h
    db 030h,00h,010h,00h,030h,00h,020h,00h,050h,00h,010h,00h,040h,00h,030h,00h
    db 040h,00h,030h,00h,050h,00h,040h,00h,050h,00h,040h,00h,060h,00h,050h,00h
    db 060h,00h,050h,00h,070h,00h,060h,00h,0FFh,0FFh,0FFh,0FFh,030h,075h,00h,00h
    db 00h,00h,00h,00h,0C0h,00h,030h,00h,08h,00h,010h,00h,0C0h,00h,020h,00h
    db 010h,00h,020h,00h,0C0h,00h,020h,00h,020h,00h,030h,00h,0C0h,00h,030h,00h
    db 030h,00h,040h,00h,0C0h,00h,040h,00h,040h,00h,050h,00h,0C0h,00h,040h,00h
    db 050h,00h,060h,00h,0C0h,00h,050h,00h,050h,00h,060h,00h,0B0h,00h,030h,00h
    db 060h,00h,060h,00h,0A0h,00h,040h,00h,060h,00h,060h,00h,090h,00h,040h,00h
    db 070h,00h,060h,00h,080h,00h,050h,00h,070h,00h,060h,00h,070h,00h,040h,00h
    db 080h,00h,060h,00h,060h,00h,030h,00h,090h,00h,060h,00h,050h,00h,020h,00h
    db 0A0h,00h,060h,00h,040h,00h,020h,00h,0B0h,00h,060h,00h,030h,00h,030h,00h
    db 0B8h,00h,060h,00h,00h,00h,00h,00h,00h,00h,030h,075h,00h,00h,050h,00h
    db 0C0h,00h,050h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0C0h,00h,030h,075h
    db 00h,00h,044h,0A8h,040h,00h,090h,00h,040h,00h,080h,00h,030h,00h,080h,00h
    db 030h,00h,090h,00h,020h,00h,070h,00h,020h,00h,050h,00h,030h,00h,040h,00h
    db 030h,00h,030h,00h,040h,00h,030h,00h,040h,00h,040h,00h,030h,00h,010h,00h
    db 020h,00h,010h,00h,010h,00h,010h,00h,010h,00h,020h,00h,010h,00h,030h,00h
    db 010h,00h,090h,00h,010h,00h,0A0h,00h,010h,00h,0B0h,00h,020h,00h,0B0h,00h
    db 030h,00h,0B0h,00h,096h,0A8h,080h,00h,030h,00h,00h,00h,070h,00h,090h,00h
    db 020h,00h,0C0h,00h,010h,00h,0A0h,00h,040h,00h,060h,00h,0B0h,00h,090h,00h
    db 050h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,050h,00h,0A8h,00h,050h,00h,090h,00h,050h,00h,078h,00h,050h,00h
    db 060h,00h,050h,00h,048h,00h,050h,00h,030h,00h,050h,00h,018h,00h,050h,00h
    db 00h,00h,038h,00h,00h,00h,038h,00h,018h,00h,038h,00h,030h,00h,038h,00h
    db 048h,00h,038h,00h,060h,00h,038h,00h,078h,00h,038h,00h,090h,00h,038h,00h
    db 0A8h,00h,020h,00h,0A8h,00h,020h,00h,090h,00h,020h,00h,078h,00h,020h,00h
    db 060h,00h,020h,00h,048h,00h,020h,00h,030h,00h,020h,00h,018h,00h,020h,00h
    db 00h,00h,036h,023h,02h,00h,036h,023h,03h,00h,028h,023h,04h,00h,028h,023h
    db 05h,00h,026h,023h,05h,00h,026h,023h,06h,00h,026h,023h,07h,00h,026h,023h
    db 08h,00h,00h,00h
; Aiming: bit 0 target to the right, 1 left, 2 below, 3 above (none = aligned);
; DirectionFromQuadrant maps it to REC_DIRECTION.
AimQuadrantBits dw 00000h
; Counts spawn attempts in SpawnThrottledChild; DifficultySetting picks the modulus.
ChildSpawnThrottle db 0
    even
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h
HistoryRecordSlot15 dw 0FFFFh
HistoryRecordSlot31 dw 0FFFFh
PlusSlotA966 dw 0FFFFh
MinusSlotA968 dw 0FFFFh
PlusSlotA96A dw 0FFFFh
MinusSlotA96C dw 0FFFFh
; UNKNOWN: not yet classified as code or data
    db 0FFh,0FFh
    db 00h,00h,00h,00h,00h,00h,00h,00h
LevelScriptClock dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h
    db 00h,00h,02Ah,015h,00h,030h,024h,04h
; Text-mode screen (80x25, attribute 07h) copied to B800h when the game exits.
; Box-drawing characters are CP437 bytes.
ExitOrderScreen label word
    TEXTROW 07h, <    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·      >
    TEXTROW 07h, <    ³         HOW TO ORDER OVERKILL - THE SIX PLANET MEGABLAST!!!!          º      >
    TEXTROW 07h, <    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶      >
    TEXTROW 07h, <    ³  All six planets of OverKill can be ordered by calling toll free   º      >
    TEXTROW 07h, <    ³   from the USA or Canada 800-972-7434, or call 301 299-3841.       º      >
    TEXTROW 07h, <    ³                                                                    º      >
    TEXTROW 07h, <    ³  The price is $30 for the six-planet megablast plus $4 shipping    º      >
    TEXTROW 07h, <    ³   and handling in U.S. Funds.                                      º      >
    TEXTROW 07h, <    ³                                                                    º      >
    TEXTROW 07h, <    ³  Maryland residents MUST add 5>
    db '%', 07h
    TEXTROW 07h, < tax                                º      >
    TEXTROW 07h, <    ³                                                                    º      >
    TEXTROW 07h, <    ³  We accept Visa & Master Card.                                     º      >
    TEXTROW 07h, <    ³                                                                    º      >
    TEXTROW 07h, <    ³  Or send check or money order to:                                  º      >
    TEXTROW 07h, <    ³                                                                    º      >
    TEXTROW 07h, <    ³  Epic MegaGames                                                    º      >
    TEXTROW 07h, <    ³  10406 Holbrook Drive                                              º      >
    TEXTROW 07h, <    ³  Potomac, MD 20854                                                 º      >
    TEXTROW 07h, <    ³  U.S.A.                                                            º      >
    TEXTROW 07h, <    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶      >
    TEXTROW 07h, <    ³  Copyright (c) 1992 Tech-Noir                                      º      >
    TEXTROW 07h, <    ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼      >
    TEXTROW 07h, <                                                                                >
    TEXTROW 07h, <                                                                                >
    TEXTROW 07h, <                                                                                >
; Device name opened to detect an EMS driver.
EmsDeviceName db 'EMMXXXX0',0
; 1 when EMS 3.0+ is present with a page frame and free pages (DetectEms).
EmsAvailable db 0
; From INT 67h: page frame segment (AH=41h), total and free pages (AH=42h).
EmsPageFrame dw 0
EmsTotalPages dw 0
EmsFreePages dw 0
; Next free FileCache entry.
FileCacheEnd dw offset FileCache
; Files kept after their first load, FILE_CACHE_ENTRY_BYTES each (CACHE_* fields),
; ended by a CACHE_NAME of FFFF. Nothing bounds FileCacheEnd; the image leaves room
; for FILE_CACHE_ENTRIES and a final end word.
FileCache db FILE_CACHE_ENTRIES * FILE_CACHE_ENTRY_BYTES dup (0FFh)
    dw 0FFFFh
FileStatus dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h
; Set by callers around loads of .ENC files: LoadResourceFile then decodes them with
; DecodeEncFile instead of LoadPackedFile.
LoadIsEnc db 00h
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,04Fh,056h,045h,052h,04Bh,049h,04Ch,04Ch
    db 02Eh,045h,058h,045h,00h,024h,04Fh,056h,045h,052h,04Bh,049h,04Ch,04Ch,00h,024h
    db 045h,072h,072h,06Fh,072h,020h,021h,021h,021h,021h,020h,03Ah,02Dh,0Dh,0Ah,0Dh
    db 0Ah,046h,069h,06Ch,065h,020h,027h,024h,08h,027h,020h,068h,061h,073h,020h,062h
    db 065h,065h,06Eh,020h,063h,06Fh,072h,072h,075h,070h,074h,065h,064h,02Ch,020h,06Fh
    db 072h,020h,070h,06Fh,073h,073h,069h,062h,06Ch,079h,020h,069h,06Eh,066h,065h,063h
    db 074h,065h,064h,020h,062h,079h,020h,061h,020h,076h,069h,072h,075h,073h,021h,021h
    db 024h,050h,072h,065h,073h,073h,020h,061h,06Eh,079h,020h,06Bh,065h,079h,020h,074h
    db 06Fh,020h,072h,065h,074h,075h,072h,06Eh,020h,074h,06Fh,020h,044h,04Fh,053h,02Eh
    db 02Eh,02Eh,02Eh,02Eh,02Eh,024h,011h,00h,00h,010h,0Fh,043h,06Fh,064h,065h,077h
    db 06Fh,072h,064h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,03Dh,020h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,011h,01h,00h,010h,0Fh,04Eh,06Fh,06Eh,041h,073h,063h,069h,069h,043h,06Fh
    db 064h,065h,077h,06Fh,072h,064h,020h,020h,020h,03Dh,020h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,02h,00h,010h
    db 0Fh,04Fh,04Ch,044h,04Eh,06Fh,06Eh,041h,073h,063h,069h,069h,043h,06Fh,064h,065h
    db 077h,06Fh,072h,064h,03Dh,020h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,011h,03h,00h,010h,0Fh,050h,061h,073h,073h
    db 077h,06Fh,072h,064h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,03Dh
    db 020h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h
SoundModuleSelect db 00h
; UNKNOWN: not yet classified as code or data
    db 010h,0Fh,011h,0Ch,03h,053h,06Fh,075h,06Eh,064h,020h
    db 063h,061h,072h,064h,020h,075h,073h,065h,064h,03Ah,020h,041h,064h,06Ch,069h,062h
    db 020h,063h,06Fh,06Dh,070h,061h,074h,069h,062h,06Ch,065h,00h,010h,0Fh,011h,0Ch
    db 04h,053h,06Fh,075h,06Eh,064h,020h,063h,061h,072h,064h,020h,075h,073h,065h,064h
    db 03Ah,020h,054h,061h,06Eh,064h,079h,020h,069h,06Eh,074h,065h,072h,06Eh,061h,06Ch
    db 00h,010h,0Fh,011h,0Ch,05h,053h,06Fh,075h,06Eh,064h,020h,063h,061h,072h,064h
    db 020h,075h,073h,065h,064h,03Ah,020h,052h,06Fh,06Ch,061h,06Eh,064h,020h,04Ch,041h
    db 050h,043h,031h,00h
SoundModuleNameAdlib db 'adlib.enc',00h
SoundModuleNameTandy db 'tandy.enc',00h
SoundModuleNameRoland db 'roland.enc',00h
; UNKNOWN: not yet classified as code or data
    db 090h,01Fh,07h,00h,039h,017h,03h,089h,07h,06h,08Dh,015h,09h
    db 0B6h,01h,0Ch,018h,04h,01h,035h,017h,04h,085h,04h,07h,08Dh,015h,0Ah,0B6h
    db 01h,0Dh,0Eh,02h,02h,032h,017h,05h,082h,02h,08h,08Dh,015h,0Bh,0B6h,01h
    db 0Eh,0B0h,01h,02h,013h,088h,015h,07h,010h,08h,01h,0Fh,014h,030h,016h,06h
    db 010h,080h,02h,06h,013h,00h,00h,090h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,06Fh,076h,065h,072h,06Bh,069h,06Ch,06Ch,00h,0FFh,00h,00h,024h,03Ch
    db 0BEh,0BDh,04Ch,03Dh,0D9h,0BDh,074h,03Fh,0E9h,0BDh,09Ch,03Eh,0F7h,0BDh,010h,0Fh
    db 011h,05h,06h,042h,06Fh,06Eh,075h,073h,020h,057h,065h,061h,070h,06Fh,06Eh,020h
    db 053h,065h,06Ch,065h,063h,074h,06Fh,072h,00h,011h,0Ah,06h,042h,06Fh,06Eh,075h
    db 073h,020h,053h,068h,069h,065h,06Ch,064h,00h,011h,0Fh,06h,042h,06Fh,06Eh,075h
    db 073h,020h,046h,075h,065h,06Ch,00h,011h,014h,06h,053h,06Dh,061h,072h,074h,020h
    db 042h,06Fh,06Dh,062h,00h,090h,00h,00h,00h,00h,00h,00h,010h,03h,011h,03h
    db 01Fh,00h,011h,05h,01Fh,00h,00h,00h,02Ah,00h,03h,00h,0Ch,00h,02Dh,00h
    db 02h,00h,09h,00h,030h,00h,02h,00h,0Ah,00h,033h,00h,03h,00h,0Dh,00h
    db 030h,00h,02h,00h,0Ah,00h,036h,00h,03h,00h,0Eh,00h,02Bh,00h,02h,00h
    db 0Bh,00h,02Eh,00h,02h,00h,0Bh,00h,02Dh,00h,02h,00h,09h,00h,031h,00h
    db 00h,00h,00h,00h,034h,00h,00h,00h,01h,00h,037h,00h,01h,00h,06h,00h
    db 03Bh,00h,00h,00h,02h,00h,02Ch,00h,00h,00h,03h,00h,02Fh,00h,00h,00h
    db 04h,00h,032h,00h,00h,00h,05h,00h,035h,00h,0FFh,0FFh,0FFh,0FFh,038h,00h
    db 01h,00h,07h,00h,039h,00h,0FFh,0FFh,0FFh,0FFh,03Ah,00h,0FFh,0FFh,0FFh,0FFh
; Page lists for ShowPageList: a word (1 = the pages can be browsed, 0 = show the
; single page and return), the page file names, then FFFF.
    dw 1
IPageList dw offset File_IPAGE1_ENC, offset File_IPAGE2_ENC, offset File_IPAGE3_ENC, offset File_IPAGE4_ENC
    dw offset File_IPAGE5_ENC, 0FFFFh
    dw 1
OPageList dw offset File_OPAGE1_ENC, offset File_OPAGE2_ENC, offset File_OPAGE3_ENC, offset File_OPAGE4_ENC
    dw offset File_OPAGE5_ENC, offset File_OPAGE6_ENC, offset File_OPAGE7_ENC, offset File_OPAGE8_ENC
    dw offset File_OPAGE9_ENC, offset File_OPAGE10_ENC, 0FFFFh
    dw 0
OkMenuPageList dw offset File_OKMENU_ENC, 0FFFFh
    dw 0
CalibPageList dw offset File_CALIB_ENC, 0FFFFh
    dw 0
RedefPageList dw offset File_REDEF_ENC, 0FFFFh
    dw 0
HiscorePageList dw offset File_HISCORE_ENC, 0FFFFh
    dw 0
WinScreenPageList dw offset File_WINSCR_ENC, 0FFFFh
; Page shown by ShowPageList within PageListPtr.
PageIndex dw 0
PageListPtr dw 0
; Frames run so far by RunTimedSequenceUntilPrimary.
SequenceFrameCount dw 0
; Choose-screen slot 0..5 (RunChooseScreen; saved in hiscore.dat).
ChooseSlot dw 0
; 0..2, cycled in the options menu and saved in hiscore.dat. Throttles enemy child
; spawns (SpawnThrottledChild) and gates other behaviour.
DifficultySetting dw 1
; Screen positions (AH row, AL 8-pixel column) of the six choose-screen slot images
; and the three difficulty images (ChooseImageOffsets 0..5 and 6..8).
ChooseSlotPositions dw 02E02h, 05302h, 07802h, 02E15h, 05315h, 07815h
DifficultyPositions dw 0A514h, 0A519h, 0A51Eh
; Handlers for stream bytes 80h..85h: end, rest, step down, step up, slide, hold.
SfxCommandTable db 02Fh,0D6h,0D6h,0D5h,041h,0D6h,048h,0D6h,04Fh,0D6h,0CCh,0D5h,00h,00h
SfxActive db 00h
; Effect requested of SfxTimerTick (below 20h); lower IDs pre-empt higher ones.
SfxRequest db 00h
; PC-speaker effect player (SfxTimerTick, run every timer tick). An effect is a pair of
; byte streams, one per voice; the voices take turns driving the speaker tick by tick.
SfxTickPhase db 00h
; PIT divisors a semitone apart, starting near 65.4 Hz; indexed by note, unchecked.
SfxNoteDivisors db 043h,047h,043h,043h,07Dh,03Fh,0ECh,03Bh,08Fh,038h,063h,035h,064h,032h,090h
    db 02Fh,0E4h,02Ch,05Fh,02Ah,0FFh,027h,0C0h,025h,0A2h,023h,0A2h,021h,0BEh,01Fh,0F6h
    db 01Dh,048h,01Ch,0B1h,01Ah,032h,019h,0C8h,017h,072h,016h,030h,015h,0FFh,013h,0E0h
    db 012h,0D1h,011h,0D1h,010h,0DFh,0Fh,0FBh,0Eh,024h,0Eh,059h,0Dh,099h,0Ch,0E4h
    db 0Bh,039h,0Bh,098h,0Ah,00h,0Ah,070h,09h,0E8h,08h,068h,08h,0F0h,07h,07Dh
    db 07h,011h,07h,0ABh,06h,04Bh,06h,0F1h,05h,09Ch,05h,04Bh,05h,0FFh,04h,0B7h
    db 04h,074h,04h,034h,04h,0F8h,03h,0BEh,03h,088h,03h,055h,03h,025h,03h,0F8h
    db 02h,0CDh,02h,0A5h,02h,07Fh,02h,05Bh,02h,03Ah,02h,01Ah,02h,0FCh,01h,0DFh
    db 01h,0C4h,01h,0ABh,01h,093h,01h,07Ch,01h,067h,01h,053h,01h,040h,01h,02Eh
    db 01h,01Dh,01h,0Dh,01h,0FEh,00h,0F0h,00h,0E2h,00h,0D6h,00h,0CAh,00h,0BEh
    db 00h,0B4h,00h,0AAh,00h,0A0h,00h,097h,00h,090h
SfxVoiceA db 00h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h
    db 080h,00h,01h,00h,00h,00h,00h,00h,00h,00h
SfxVoiceB db 00h,00h,00h,00h,00h,00h
    db 080h,00h,01h,00h,00h,00h,00h,00h,00h,00h
; SFX_EFFECT_COUNT entries of two stream pointers (voice A, voice B); entry 0 unused.
SfxEffectTable db 00h,00h,00h,00h,0C2h,0C2h
    db 0CBh,0C2h,0CAh,0C1h,0D5h,0C1h,0BAh,0C1h,0C2h,0C1h,0D4h,0C2h,0D4h,0C2h,066h,0C2h
    db 066h,0C2h,018h,0C1h,02Eh,0C1h,0C7h,0C0h,0CAh,0C0h,0ECh,0C0h,02h,0C1h,082h,0C1h
    db 085h,0C1h,08Eh,0C1h,0F3h,0C2h,068h,0C1h,075h,0C1h,09Bh,0C1h,0F3h,0C2h,091h,0C1h
    db 0F3h,0C2h,0E0h,0C1h,0E3h,0C1h,0CDh,0C0h,0D4h,0C0h,058h,0C2h,05Fh,0C2h,02h,0C2h
    db 02Dh,0C2h,0F4h,0C1h,0FBh,0C1h,074h,0C0h,07Bh,0C0h,066h,0C0h,06Dh,0C0h,082h,0C0h
    db 089h,0C0h,090h,0C0h,09Ch,0C0h,058h,0C0h,05Fh,0C0h,0E6h,0C1h,0EDh,0C1h,0DBh,0C0h
    db 0E3h,0C0h,0B2h,0C1h,0B6h,0C1h,0A2h,0C1h,0A9h,0C1h,04Ah,0C0h,051h,0C0h,048h,0C1h
    db 0F3h,0C2h,088h,0C1h,08Bh,0C1h,058h,0C1h,0F3h,0C2h
; UNKNOWN: not yet classified as code or data
    db 0E7h,084h,0Ch,00h,08h,03Ch
    db 080h,0E7h,084h,06h,00h,08h,030h,080h,0EBh,084h,098h,00h,0Ch,024h,080h,0EBh
    db 084h,098h,00h,0Ch,024h,080h,0E9h,084h,098h,00h,06h,03Ch,080h,0E9h,084h,098h
    db 00h,06h,03Ch,080h,0E9h,084h,060h,00h,08h,048h,080h,0E9h,084h,060h,00h,08h
    db 048h,080h,0E2h,084h,060h,00h,08h,048h,080h,0E2h,084h,060h,00h,08h,048h,080h
    db 0F7h,084h,040h,00h,0FFh,018h,084h,080h,0FFh,0FFh,085h,080h,0F7h,084h,042h,00h
    db 0FFh,01Bh,084h,080h,0FFh,0FFh,085h,080h,0E5h,084h,0E0h,07Fh,06h,030h,084h,040h
    db 080h,037h,084h,0E0h,07Fh,06h,030h,084h,040h,080h,037h,080h,0E5h,084h,0E0h,07Fh
    db 06h,037h,084h,040h,080h,03Eh,080h,0E4h,03Ch,080h,0E4h,043h,080h,0E4h,084h,082h
    db 04h,05h,048h,080h,0E4h,084h,082h,04h,05h,046h,080h,0E7h,082h,07h,0EAh,082h
    db 016h,085h,080h,0E5h,082h,0E6h,08h,0EFh,082h,015h,085h,080h,0E8h,084h,096h,00h
    db 030h,0Ch,084h,096h,00h,030h,0Ch,084h,096h,00h,030h,0Ch,084h,096h,00h,030h
    db 0Ch,080h,0E8h,084h,096h,00h,030h,01Dh,084h,096h,00h,030h,01Ch,084h,096h,00h
    db 030h,01Bh,084h,096h,00h,030h,01Ah,080h,0EFh,084h,096h,00h,030h,010h,084h,096h
    db 00h,030h,015h,084h,096h,00h,030h,018h,084h,096h,00h,030h,015h,080h,0E1h,03Ch
    db 03Eh,03Fh,040h,03Fh,03Ch,03Bh,03Ah,043h,045h,043h,041h,040h,03Fh,03Ch,03Bh,048h
    db 047h,046h,045h,043h,041h,040h,03Fh,080h,0E4h,047h,045h,043h,041h,040h,03Eh,03Ch
    db 03Bh,039h,037h,035h,034h,032h,030h,080h,0E1h,047h,045h,043h,041h,040h,03Eh,03Ch
    db 03Bh,039h,037h,035h,034h,032h,030h,080h,0F1h,084h,064h,00h,010h,013h,0E7h,084h
    db 09Ch,0FCh,06h,085h,080h,0F1h,084h,064h,00h,010h,016h,0E7h,084h,09Ch,0FCh,06h
    db 085h,080h,0E7h,01Fh,080h,0E7h,022h,080h,0E4h,037h,080h,0E4h,039h,080h,0EFh,02Bh
    db 080h,0FFh,084h,0F4h,0FFh,0FFh,02Bh,085h,085h,085h,080h,0E5h,084h,02h,00h,0Ch
    db 037h,080h,0E9h,084h,07Bh,00h,063h,02Bh,080h,0E2h,081h,0E9h,084h,07Bh,00h,063h
    db 032h,080h,0E5h,082h,01Fh,080h,0E5h,082h,02Bh,080h,0FFh,084h,080h,01h,0FFh,037h
    db 085h,080h,0FFh,084h,080h,01h,0FFh,039h,085h,080h,0FFh,082h,02Bh,082h,026h,082h
    db 01Fh,0F7h,082h,01Ah,080h,0FFh,082h,02Eh,082h,029h,082h,022h,0F7h,082h,01Dh,080h
    db 0E4h,048h,080h,0E4h,047h,080h,0F7h,084h,080h,0FEh,020h,0Ch,080h,0F7h,084h,080h
    db 0FEh,020h,0Fh,080h,0E5h,084h,0C0h,00h,018h,023h,080h,0E5h,084h,0C0h,00h,018h
    db 026h,080h,0E1h,084h,00h,0FCh,02h,018h,084h,00h,0FCh,02h,015h,084h,00h,0FCh
    db 02h,016h,084h,00h,0FCh,02h,013h,084h,00h,0FCh,02h,012h,084h,00h,0FCh,02h
    db 014h,084h,00h,0FCh,02h,015h,0E7h,084h,00h,0FCh,0Ch,01Dh,080h,0E1h,084h,00h
    db 0FCh,02h,020h,084h,00h,0FCh,02h,018h,084h,00h,0FCh,02h,01Eh,084h,00h,0FCh
    db 02h,01Dh,084h,00h,0FCh,02h,01Ah,084h,00h,0FCh,02h,017h,084h,00h,0FCh,02h
    db 015h,0E7h,084h,00h,0FCh,0Ch,021h,080h,0F7h,084h,07Fh,0FFh,018h,024h,080h,0F7h
    db 084h,07Fh,0FFh,018h,028h,080h,0F7h,084h,040h,00h,0FFh,018h,0EFh,084h,040h,00h
    db 0FFh,01Ch,0F7h,084h,040h,00h,0FFh,013h,0EFh,084h,040h,00h,0FFh,016h,0F7h,084h
    db 040h,00h,0FFh,0Eh,0EFh,084h,040h,00h,0FFh,012h,0F7h,084h,040h,00h,0FFh,09h
    db 0EFh,084h,040h,00h,0FFh,0Ch,0FFh,084h,040h,00h,0FFh,04h,080h,0F7h,084h,040h
    db 00h,0FFh,018h,0EFh,084h,040h,00h,0FFh,01Ch,0F7h,084h,040h,00h,0FFh,013h,0EFh
    db 084h,040h,00h,0FFh,016h,0F7h,084h,040h,00h,0FFh,0Eh,0EFh,084h,040h,00h,0FFh
    db 012h,080h,0FFh,084h,040h,020h,0FFh,013h,085h,085h,080h,0FFh,084h,020h,061h,0FFh
    db 010h,085h,085h,080h,0E2h,018h,081h,01Dh,081h,01Fh,081h,023h,081h,024h,081h,029h
    db 081h,02Bh,081h,02Fh,081h,030h,081h,037h,081h,03Bh,081h,081h,081h,03Ch,081h,043h
    db 081h,048h,080h,0FFh,081h,081h,081h,081h,081h,081h,081h,081h,080h,00h,070h,061h
    db 079h,06Dh,065h,06Eh,074h,02Eh,065h,06Eh,063h,00h,049h,030h,06Eh,030h,066h,030h
    db 06Fh,030h,072h,030h,06Dh,030h,061h,030h,074h,030h,069h,030h,06Fh,030h,06Eh,030h
    db 03Ah,030h,020h,030h,020h,030h,020h,030h,020h,030h,020h,030h,020h,030h,028h,030h
    db 04Bh,030h,065h,030h,079h,030h,073h,030h,03Ah,030h,02Dh,030h,020h,030h,043h,030h
    db 075h,030h,072h,030h,073h,030h,06Fh,030h,072h,030h,020h,030h,055h,030h,070h,030h
    db 020h,030h,026h,030h,020h,030h,044h,030h,06Fh,030h,077h,030h,06Eh,030h,020h,030h
    db 02Fh,030h,020h,030h,050h,030h,061h,030h,067h,030h,065h,030h,020h,030h,055h,030h
    db 070h,030h,020h,030h,026h,030h,020h,030h,044h,030h,06Fh,030h,077h,030h,06Eh,030h
    db 020h,030h,02Fh,030h,020h,030h,048h,030h,06Fh,030h,06Dh,030h,065h,030h,020h,030h
    db 02Fh,030h,020h,030h,045h,030h,06Eh,030h,064h,030h,020h,030h,02Fh,030h,020h,030h
    db 045h,030h,053h,030h,043h,030h,029h,030h,020h,030h
; Byte attributes: filled and patched by InitializeByteAttributes, read by
; ReadIndexedByteAttribute.
ByteAttributeTable db 00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h
    db 00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; Per LevelIndex: ByteAttributeTable patches applied by InitializeByteAttributes
; (levels 1 and 4 share one list).
AttributePatchPointers dw offset AttributePatches0, offset AttributePatches1, offset AttributePatches2, offset AttributePatches3, offset AttributePatches1, offset AttributePatches5
; (index, value) byte pairs ending with ATTRIBUTE_PATCH_END.
AttributePatches0 db 1h,0, 0Ch,0, 0Eh,0, 12h,0, 14h,0, 17h,0, 1Ah,0, 1Bh,0
    db 1Eh,0, 26h,0, 2Ah,0, 2Fh,0, 33h,0, 3Eh,0, 41h,0, 48h,0
    db 4Ch,0, 55h,0, 57h,0, 58h,0, 5Bh,0, 61h,0, 64h,0, 7Bh,0
    db 7Eh,0, 7Fh,0, 82h,0, 96h,0, 99h,0, 0B5h,0, 0BAh,0, 0BBh,0
    db 0BCh,0, 0BDh,0, 0C2h,0, 0DFh,0
    db ATTRIBUTE_PATCH_END
AttributePatches1 db 1h,0, 0A3h,0, 0A1h,0, 0A8h,0, 75h,0, 71h,0, 0A6h,0, 6Fh,0
    db 6Ch,2, 6Dh,2, 7Ah,0, 8Ah,0, 94h,0, 95h,0, 0ACh,0, 0B1h,0
    db ATTRIBUTE_PATCH_END
AttributePatches2 db 1h,0, 3h,0, 0Ch,0, 0Dh,0, 13h,0, 16h,0, 1Eh,0, 23h,0
    db 28h,0, 2Ah,0, 25h,0, 47h,0, 48h,0, 4Ch,0, 4Dh,0, 4Eh,0
    db 4Fh,0, 50h,0, 52h,0, 58h,0, 5Ah,0, 82h,0, 87h,0, 88h,0
    db 80h,0, 82h,0, 87h,0, 89h,0, 0AAh,0, 0ABh,0, 0ADh,0, 0E1h,0
    db 0B0h,0, 0B1h,0
    db ATTRIBUTE_PATCH_END
AttributePatches3 db 1h,0, 0Fh,0, 11h,0, 12h,0, 22h,0, 23h,0, 55h,0, 59h,0
    db 5Bh,0, 60h,0, 62h,0, 63h,0, 64h,0, 66h,0, 67h,0, 68h,0
    db 6Eh,0, 76h,0, 78h,0, 7Eh,0, 7Fh,0, 85h,0, 8Ah,0, 8Bh,0
    db 8Ch,0, 95h,0, 96h,0, 97h,0, 98h,0, 99h,0, 9Ah,0
    db ATTRIBUTE_PATCH_END
AttributePatches5 db 1h,0, 3h,0, 0Ch,0, 0Dh,0, 13h,0, 16h,0, 1Eh,0, 23h,0
    db 28h,0, 2Ah,0, 25h,0, 47h,0, 48h,0, 4Ch,0, 4Dh,0, 4Eh,0
    db 4Fh,0, 50h,0, 52h,0, 58h,0, 5Ah,0, 82h,0, 87h,0, 88h,0
    db 80h,0, 82h,0, 87h,0, 89h,0, 0AAh,0, 0ABh,0, 0B0h,0, 0B1h,0
    db 0D2h,0, 0D3h,0
    db ATTRIBUTE_PATCH_END
; Per LevelIndex: pointers to the level's script cursor (LevelScriptCursors).
LevelScriptCursorPtrs dw offset LevelScriptCursors + 0, offset LevelScriptCursors + 2, offset LevelScriptCursors + 4, offset LevelScriptCursors + 6, offset LevelScriptCursors + 8, offset LevelScriptCursors + 10
; Next event of each level's script; loc_00B3E resets them to the script starts.
LevelScriptCursors dw offset LevelScript0, offset LevelScript1, offset LevelScript2, offset LevelScript3, offset LevelScript4, offset LevelScript5
; UNKNOWN: not yet classified as code or data
    db 0Dh,0C6h,02Bh,0C6h,049h,0C6h,067h,0C6h,085h,0C6h,0A3h,0C6h,09Ch,00h,011h
    db 01h,05Ch,0C8h,0CFh,03h,0CFh,03h,0D2h,00h,064h,0C8h,050h,07h,050h,07h,08Dh
    db 00h,07Ch,0C8h,090h,0Ah,090h,0Ah,04Dh,00h,0ACh,0C8h,09Ch,00h,011h,01h,0D6h
    db 0C8h,0CFh,03h,0CFh,03h,0D2h,00h,0FEh,0C8h,0C5h,07h,0C5h,07h,084h,00h,02Eh
    db 0C9h,090h,0Ah,090h,0Ah,04Dh,00h,05Eh,0C9h,09Ch,00h,011h,01h,02h,0CAh,0CFh
    db 03h,0CFh,03h,0D2h,00h,068h,0CAh,077h,07h,077h,07h,08Ah,00h,0DEh,0CAh,090h
    db 0Ah,090h,0Ah,04Dh,00h,07Eh,0CBh,09Ch,00h,011h,01h,036h,0CCh,0CFh,03h,0CFh
    db 03h,0D2h,00h,03Eh,0CCh,0Fh,07h,0Fh,07h,092h,00h,048h,0CCh,0EBh,0Ah,0EBh
    db 0Ah,046h,00h,05Ch,0CCh,09Ch,00h,011h,01h,080h,0CCh,0B5h,03h,0B5h,03h,0D4h
    db 00h,088h,0CCh,036h,07h,036h,07h,08Fh,00h,090h,0CCh,0EBh,0Ah,0EBh,0Ah,046h
    db 00h,098h,0CCh,09Ch,00h,011h,01h,0AAh,0CCh,0CFh,03h,0CFh,03h,0D2h,00h,0C2h
    db 0CCh,05Dh,07h,05Dh,07h,08Ch,00h,0E2h,0CCh,0EBh,0Ah,0EBh,0Ah,046h,00h,0E2h
    db 0CCh,07h,00h,01Ch,00h,00h,00h,021h,00h,03Eh,00h,00h,00h,032h,00h,05h
    db 00h,00h,00h,042h,00h,03Ch,00h,00h,00h,051h,00h,029h,00h,00h,00h,085h
    db 00h,0Eh,00h,00h,00h,084h,00h,032h,00h,00h,00h,06Ch,00h,040h,00h,00h
    db 00h,0A4h,00h,055h,00h,00h,00h,089h,00h,071h,00h,00h,00h,07Dh,00h,089h
    db 00h,00h,00h,08Eh,00h,0A9h,00h,00h,00h,05Bh,00h,06Fh,00h,00h,00h,050h
    db 00h,09Ah,00h,00h,00h,06Ch,00h,052h,00h,00h,00h,035h,00h,07Fh,00h,00h
    db 00h,019h,00h,069h,00h,00h,00h,011h,00h,096h,00h,00h,00h,026h,00h,0AEh
    db 00h,00h,00h,07h,00h,0CBh,00h,00h,00h,015h,00h,024h,00h,00h,00h,048h
    db 00h,019h,00h,00h,00h,087h,00h,01Ah,00h,00h,00h,0A3h,00h,04Eh,00h,00h
    db 00h,058h,00h,04Fh,00h,00h,00h,06Eh,00h,085h,00h,00h,00h,0ACh,00h,0ABh
    db 00h,00h,00h,016h,00h,07Eh,00h,00h,00h,023h,00h,0B0h,00h,00h,00h,04Fh
    db 00h,099h,00h,00h,00h,018h,00h,021h,00h,00h,00h,046h,00h,043h,00h,00h
    db 00h,066h,00h,01Ah,00h,00h,00h,095h,00h,02Fh,00h,00h,00h,06Dh,00h,05Dh
    db 00h,00h,00h,09Eh,00h,079h,00h,00h,00h,08Dh,00h,0BFh,00h,00h,00h,049h
    db 00h,084h,00h,00h,00h,02Ah,00h,0B3h,00h,00h,00h,0Eh,00h,08Ah,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,0FFh,0FFh,03h,0Ch,030h,0C0h,01h,02h,04h,08h,010h,020h,040h,080h,0Fh
    db 0F0h,090h,00h,00h,00h,00h,00h,00h,014h,00h,03h,01h,00h,00h,00h,02h
    db 00h,04h,01h,00h,01h,00h,00h,00h,01h,04h,00h,00h,00h,03h,01h,00h
    db 00h,00h,00h,00h,01h,00h,03h,00h,00h,00h,02h,03h,01h,00h,00h,02h
    db 00h,01h,01h,00h,01h,03h,00h,01h,00h,00h,01h,00h,00h,00h,01h,03h
    db 00h,00h,00h,01h,01h,04h,00h,00h,00h,00h,00h,090h
; Level scripts: events (trigger, [0FFFFh,] formation, x, y) ending with trigger
; 0FFFFh. An event fires when its trigger equals the scroll countdown at DS:A978; the
; optional 0FFFFh clears the flag at DS:20A2 for that event. The formation's members
; spawn at x, y plus their own offsets.
LevelScript0 dw 110h, offset Formation40, 192, -16
    dw 0BDh, offset Formation20, 176, -16
    dw 0BDh, offset Formation19, 16, -16
    dw 0ADh, offset Formation37, 64, -16
    dw 6Ch, offset Formation25, 80, -16
    dw 6Bh, offset Formation25, 80, -16
    dw 60h, offset Formation25, 128, -16
    dw 5Fh, offset Formation25, 128, -16
    dw 57h, offset Formation20, 176, -16
    dw 57h, offset Formation19, 16, -16
    dw 48h, offset Formation18, 96, -16
    dw 2Dh, offset Formation18, 96, -16
    dw 4h, offset Formation11, 0, -16
    dw 4h, offset Formation12, 176, -16
    dw 4h, offset Formation33, 112, 0
    dw 0FFFFh
LevelScript1 dw 110h, offset Formation42, 192, 224
    dw 10Ah, offset Formation47, 0, -16
    dw 0FAh, offset Formation49, 112, -16
    dw 0EDh, offset Formation50, 32, -16
    dw 0DCh, offset Formation46, 0, -16
    dw 0CFh, offset Formation20, 176, -16
    dw 0BBh, offset Formation50, 192, -16
    dw 0A2h, offset Formation36, 32, -16
    dw 9Ah, offset Formation49, 160, -16
    dw 98h, offset Formation49, 160, -16
    dw 92h, offset Formation45, 96, -16
    dw 82h, offset Formation37, 64, -16
    dw 6Eh, offset Formation18, 16, -16
    dw 6Eh, offset Formation18, 176, -16
    dw 67h, offset Formation46, 0, -16
    dw 64h, offset Formation36, 176, -16
    dw 5Bh, offset Formation34, 128, -16
    dw 46h, 0FFFFh, offset Formation31, 96, 0
    dw 3Fh, offset Formation19, 16, -16
    dw 3Ch, 0FFFFh, offset Formation27, 0, -16
    dw 3Bh, 0FFFFh, offset Formation27, 0, -16
    dw 31h, 0FFFFh, offset Formation28, 0, 0
    dw 2Eh, 0FFFFh, offset Formation31, 80, 0
    dw 2Eh, 0FFFFh, offset Formation32, 96, 0
    dw 2Eh, 0FFFFh, offset Formation31, 112, 0
    dw 2Ah, 0FFFFh, offset Formation28, 0, 0
    dw 25h, 0FFFFh, offset Formation28, 192, 0
    dw 1Fh, 0FFFFh, offset Formation27, 0, 0
    dw 1Fh, 0FFFFh, offset Formation28, 0, 0
    dw 1Eh, offset Formation30, 64, 0
    dw 1Bh, 0FFFFh, offset Formation27, 0, 0
    dw 1Bh, offset Formation38, 144, -16
    dw 19h, 0FFFFh, offset Formation27, 32, 0
    dw 4h, offset Formation33, 112, 0
    dw 0FFFFh
LevelScript2 dw 110h, offset Formation41, 0, -16
    dw 10Fh, 0FFFFh, offset Formation29, 0, -16
    dw 10Ch, offset Formation09, 16, -16
    dw 104h, offset Formation22, 64, -16
    dw 104h, offset Formation22, 128, -16
    dw 0F8h, 0FFFFh, offset Formation26, 176, -16
    dw 0F0h, offset Formation17, 16, -16
    dw 0EAh, offset Formation08, 64, -16
    dw 0E2h, offset Formation46, 0, -16
    dw 0DBh, offset Formation38, 16, -16
    dw 0D8h, offset Formation38, 16, -16
    dw 0D3h, 0FFFFh, offset Formation29, 0, -16
    dw 0D2h, offset Formation18, 96, -16
    dw 0D1h, offset Formation07, 192, -16
    dw 0C7h, offset Formation38, 144, -16
    dw 0C0h, 0FFFFh, offset Formation26, 128, -16
    dw 0BEh, 0FFFFh, offset Formation23, 160, -16
    dw 0BCh, offset Formation21, 80, -16
    dw 0B0h, offset Formation15, 96, -16
    dw 0B0h, offset Formation16, 112, -16
    dw 0AEh, 0FFFFh, offset Formation52, 176, -16
    dw 0ACh, 0FFFFh, offset Formation52, 176, -16
    dw 9Fh, 0FFFFh, offset Formation51, 32, -16
    dw 99h, 0FFFFh, offset Formation05, 176, -16
    dw 94h, 0FFFFh, offset Formation51, 32, -16
    dw 85h, 0FFFFh, offset Formation23, 48, -16
    dw 84h, offset Formation13, 160, -16
    dw 78h, offset Formation18, 176, -16
    dw 75h, 0FFFFh, offset Formation51, 16, -16
    dw 73h, 0FFFFh, offset Formation51, 16, -16
    dw 72h, offset Formation25, 80, -16
    dw 70h, offset Formation25, 80, -16
    dw 70h, 0FFFFh, offset Formation52, 160, -16
    dw 6Eh, offset Formation25, 80, -16
    dw 6Eh, 0FFFFh, offset Formation52, 160, -16
    dw 6Ch, offset Formation25, 80, -16
    dw 66h, offset Formation25, 80, -16
    dw 62h, offset Formation14, 0, -16
    dw 5Bh, 0FFFFh, offset Formation26, 0, -16
    dw 59h, 0FFFFh, offset Formation29, 0, -16
    dw 58h, offset Formation04, 32, -16
    dw 51h, 0FFFFh, offset Formation01, 0, 0
    dw 50h, offset Formation03, 32, -16
    dw 4Ah, 0FFFFh, offset Formation24, 96, -16
    dw 48h, 0FFFFh, offset Formation24, 112, -16
    dw 45h, 0FFFFh, offset Formation24, 192, -16
    dw 44h, 0FFFFh, offset Formation31, 64, 0
    dw 43h, 0FFFFh, offset Formation24, 176, -16
    dw 40h, 0FFFFh, offset Formation24, 176, -16
    dw 3Fh, 0FFFFh, offset Formation24, 192, -16
    dw 3Eh, offset Formation35, 192, -16
    dw 3Bh, 0FFFFh, offset Formation23, 32, -16
    dw 36h, 0FFFFh, offset Formation24, 176, -16
    dw 35h, 0FFFFh, offset Formation24, 176, -16
    dw 34h, 0FFFFh, offset Formation24, 192, -16
    dw 2Ah, 0FFFFh, offset Formation28, 0, 0
    dw 24h, 0FFFFh, offset Formation05, 96, -16
    dw 21h, 0FFFFh, offset Formation23, 0, -16
    dw 21h, 0FFFFh, offset Formation23, 32, -16
    dw 21h, offset Formation10, 144, -16
    dw 15h, offset Formation00, 96, -16
    dw 4h, offset Formation33, 112, 0
    dw 0FFFFh
LevelScript3 dw 110h, offset Formation39, 0, -16
    dw 99h, 0FFFFh, offset Formation05, 96, -16
    dw 88h, 0FFFFh, offset Formation06, 80, -16
    dw 5Ah, 0FFFFh, offset Formation06, 96, -16
    dw 32h, 0FFFFh, offset Formation05, 96, -16
    dw 1Ah, offset Formation19, 16, -16
    dw 1Ah, offset Formation20, 176, -16
    dw 4h, offset Formation33, 112, 0
    dw 0FFFFh
LevelScript4 dw 110h, offset Formation43, 0, -16
    dw 0B1h, offset Formation37, 64, -16
    dw 6Bh, offset Formation18, 96, -16
    dw 10h, offset Formation14, 0, -16
    dw 4h, offset Formation33, 112, 0
    dw 0FFFFh
LevelScript5 dw 110h, offset Formation44, 0, -16
    dw 0D3h, offset Formation49, 160, -16
    dw 0D3h, offset Formation49, 160, -16
    dw 0D1h, offset Formation49, 160, -16
    dw 0C8h, offset Formation25, 80, -16
    dw 0C6h, offset Formation25, 80, -16
    dw 0C4h, offset Formation25, 80, -16
    dw 2Dh, 0FFFFh, offset Formation02, 176, -16
    dw 2Ch, 0FFFFh, offset Formation02, 176, -16
    dw 2Bh, 0FFFFh, offset Formation02, 176, -16
    dw 2Ah, 0FFFFh, offset Formation02, 176, -16
    dw 22h, 0FFFFh, offset Formation02, 16, -16
    dw 21h, 0FFFFh, offset Formation02, 16, -16
    dw 4h, offset Formation33, 112, 0
    dw 0FFFFh
; Formations: REC_SIZE_CLASS, REC_DRAW_PASS, REC_TYPE, member count, then member
; (x, y) offsets.
Formation00 dw 1, 1, 4Fh, 9
    dw 0, 0,  0, -16,  0, -32,  16, 0,  16, -16,  16, -32
    dw 32, 0,  32, -16,  32, -32
Formation01 dw 1, 1, 4Dh, 1
    dw 0, 0
Formation02 dw 1, 1, 7Bh, 1
    dw 0, 0
Formation03 dw 1, 1, 4Ch, 2
    dw 8, 0,  40, 0
Formation04 dw 1, 1, 4Bh, 2
    dw 0, 0,  0, -16
Formation05 dw 2, 1, 48h, 1
    dw 0, 0
Formation06 dw 2, 1, 49h, 1
    dw 0, 0
Formation07 dw 1, 1, 47h, 3
    dw 0, 0,  0, -16,  0, -48
Formation08 dw 1, 1, 46h, 3
    dw 0, 0,  16, 0,  32, 0
Formation09 dw 1, 0, 8Ah, 4
    dw 0, 0,  48, 0,  96, 0,  144, 0
Formation10 dw 1, 0, 8Ah, 2
    dw 0, 0,  48, 0
Formation11 dw 1, 1, 66h, 12
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
    dw 0, -96,  0, -112,  0, -128,  0, -144,  0, -160,  0, -176
Formation12 dw 1, 1, 67h, 12
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
    dw 0, -96,  0, -112,  0, -128,  0, -144,  0, -160,  0, -176
Formation13 dw 1, 1, 45h, 6
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
Formation14 dw 1, 1, 45h, 16
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
    dw 0, -96,  0, -112,  0, -128,  0, -144,  0, -160,  0, -176
    dw 0, -192,  0, -208,  0, -224,  0, -240
Formation15 dw 1, 1, 43h, 8
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
    dw 0, -96,  0, -112
Formation16 dw 1, 1, 44h, 8
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
    dw 0, -96,  0, -112
Formation17 dw 1, 1, 41h, 6
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
Formation18 dw 1, 1, 31h, 9
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
    dw 0, -96,  0, -112,  0, -128
Formation19 dw 1, 1, 10h, 6
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
Formation20 dw 1, 1, 11h, 6
    dw 0, 0,  0, -16,  0, -32,  0, -48,  0, -64,  0, -80
Formation21 dw 1, 1, 42h, 5
    dw 0, 0,  32, -32,  64, -64,  32, -96,  0, -128
Formation22 dw 1, 1, 40h, 4
    dw 0, 0,  16, 0,  32, 0,  48, 0
Formation23 dw 1, 1, 3Eh, 1
    dw 8, -8
Formation24 dw 1, 1, 3Ch, 1
    dw 0, 0
Formation25 dw 1, 1, 3Bh, 4
    dw 8, 16,  16, 0,  32, 0,  40, 16
Formation26 dw 1, 1, 3Ah, 1
    dw 0, 0
Formation27 dw 1, 1, 83h, 1
    dw 0, 0
Formation28 dw 1, 1, 38h, 1
    dw 0, 0
Formation29 dw 1, 1, 39h, 1
    dw 0, 0
Formation30 dw 1, 1, 37h, 5
    dw 0, 0,  16, 0,  32, 0,  48, 0,  64, 0
Formation31 dw 1, 1, 35h, 1
    dw 0, 0
Formation32 dw 1, 1, 36h, 1
    dw 0, 0
Formation33 dw 1, 1, 21h, 1
    dw 0, 0
Formation34 dw 1, 1, 32h, 3
    dw 0, 0,  16, 0,  32, 0
Formation35 dw 1, 1, 4Eh, 3
    dw 0, 0,  0, -16,  0, -32
Formation36 dw 1, 1, 30h, 1
    dw 0, 0
Formation37 dw 1, 1, 2Dh, 4
    dw 0, 0,  16, -16,  48, -16,  64, 0
Formation38 dw 1, 0, 34h, 1
    dw 0, 0
Formation39 dw 1, 1, 13h, 1
    dw 0, 0
Formation40 dw 1, 1, 15h, 1
    dw 0, 0
Formation41 dw 1, 1, 1Ch, 1
    dw 0, 0
Formation42 dw 1, 1, 1Fh, 1
    dw 0, 0
Formation43 dw 1, 1, 7Dh, 1
    dw 0, 0
Formation44 dw 1, 1, 7Eh, 1
    dw 0, 0
Formation45 dw 1, 0, 89h, 4
    dw 0, 0,  0, -32,  32, 0,  32, -32
Formation46 dw 1, 1, 2Fh, 1
    dw 0, 0
Formation47 dw 1, 0, 19h, 3
    dw 0, 0,  0, -16,  0, -32
; Not referenced by any level script.
Formation48 dw 1, 0, 1Bh, 3
    dw 0, 0,  0, -16,  0, -32
Formation49 dw 1, 1, 27h, 8
    dw 0, 0,  16, 0,  0, -16,  16, -16,  0, -32,  16, -32
    dw 0, -48,  16, -48
Formation50 dw 1, 0, 1Ah, 3
    dw 0, 0,  0, -16,  0, -32
Formation51 dw 1, 0, 8Ch, 1
    dw 0, 0
Formation52 dw 1, 0, 8Bh, 1
    dw 0, 0
; UNKNOWN: not yet classified as code or data
    db 01h,01h,01h,027h
    db 028h,029h,01h,02Ah,02Bh,02Ch,01h,01h,01h,01h,01h,01h,021h,022h,023h,01h
    db 024h,025h,026h,01h,01h,01h,01h,018h,019h,01Ah,01Bh,01Ch,01h,01Dh,01Eh,01Fh
    db 020h,01h,01h,01h,0Dh,0Eh,0Fh,010h,011h,012h,013h,014h,015h,016h,017h,01h
    db 01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch,01h,090h,00h,00h
    db 00h,00h,0C8h,00h,0C9h,00h,0CAh,00h,0C9h,00h,0DAh,00h,0DBh,00h,0DCh,00h
    db 0DBh,00h,0FDh,00h,0FEh,00h,0FFh,00h,0FEh,00h,0FAh,00h,0FBh,00h,0FCh,00h
    db 0FBh,00h,00h,00h,00h,00h,030h,00h,030h,00h,030h,00h,050h,00h,040h,00h
    db 050h,00h,040h,00h,00h,00h,070h,00h,030h,00h,070h,00h,050h,00h,080h,00h
    db 050h,00h,080h,00h,010h,00h,070h,00h,00h,00h,040h,00h,00h,00h,00h,00h
    db 040h,00h,010h,00h,050h,00h,0B0h,00h,050h,00h,0B0h,00h,00h,00h,060h,00h
    db 050h,00h,00h,00h,00h,00h,00h,00h,040h,00h,010h,00h,050h,00h,030h,075h
    db 050h,00h,00h,00h,0B0h,00h,030h,00h,080h,00h,030h,00h,060h,00h,040h,00h
    db 060h,00h,040h,00h,0B0h,00h,070h,00h,080h,00h,070h,00h,060h,00h,080h,00h
    db 060h,00h,080h,00h,0A0h,00h,070h,00h,0B0h,00h,040h,00h,0B0h,00h,00h,00h
    db 070h,00h,010h,00h,060h,00h,0B0h,00h,060h,00h,0B0h,00h,0B0h,00h,060h,00h
    db 060h,00h,00h,00h,0B0h,00h,00h,00h,070h,00h,010h,00h,060h,00h,030h,075h
    db 060h,00h,00h,00h,00h,00h,00h,00h,00h,00h,020h,00h,020h,00h,00h,00h
    db 020h,00h,020h,00h,00h,00h,00h,00h,080h,00h,00h,00h,050h,00h,040h,00h
    db 030h,00h,030h,00h,010h,00h,070h,00h,040h,00h,090h,00h,00h,00h,090h,00h
    db 080h,00h,090h,00h,040h,00h,090h,00h,00h,00h,050h,00h,020h,00h,030h,00h
    db 040h,00h,00h,00h,040h,00h,040h,00h,080h,00h,00h,00h,050h,00h,00h,00h
    db 030h,00h,020h,00h,020h,00h,070h,00h,050h,00h,050h,00h,020h,00h,070h,00h
    db 050h,00h,020h,00h,020h,00h,010h,00h,00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
DATA ends

; Empty segment marking the end of the program image (the DOS resize target).
IMAGE_END segment para public 'CODE'
ImageEnd label byte
IMAGE_END ends
end