; Everything in segment frame DATA; modern file boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
DATA segment para public 'CODE'
assume cs:DATA,ds:nothing,ss:nothing,es:nothing
public AimQuadrantBits
public AttributePatchPointers
public ByteAttributeTable
public ChildSpawnThrottle
public ClampXHighSeen
public ClampXLowSeen
public CountGate2324
public DifficultySetting
public DirectionFromQuadrant
public FileBufferOffset
public FileBufferSegment
public FileByteCount
public FileHandle
public FileNamePtr
public FileStatus
public GameOverRequest
public GridYSum
public HiscoreBlock
public HiscoreFileName
public HistoryCursor47
public HistoryEnd
public HistoryPairs
public HistoryReadCursor15
public HistoryReadCursor31
public HistoryRecordSlot15
public HistoryRecordSlot31
public HistoryWriteCursor
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
public LevelIndex
public LevelSkipEnabled
public LifeLostRequest
public LivesLeft
public MinusSlotA968
public MinusSlotA96C
public ModuleSoundEnabled
public ModuleSoundRequest
public MoveModeA47C
public MsgDeallocError
public MsgNotEnoughMemory
public NextLevelRequest
public OffsetTableA368
public OffsetTableA374
public OffsetTableA380
public OffsetTableA38C
public OffsetXGroupA
public OffsetXGroupB
public OffsetXWork
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
public RecordRowOffsets
public SavedSettings
public ScoreBcd
public ScreenRowOffsets
public ScrollDeltaY
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
public StackTop
public StateData
public TargetSearchCursor
public TimerVectorInstalled
public VideoBiosModeTable
public WideRowOffsets
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
; UNKNOWN: not yet classified as code or data
    db 020h,0Ch,020h,0Ch
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,053h,0Ch,04Eh,0Ch,041h,0Ch,046h,0Ch,055h,0Ch,020h,0Ch
    db 020h,0Ch,056h,0Ch,034h,0Ch,02Eh,0Ch,032h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
    db 020h,0Ch,020h,0Ch,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh,020h,0Eh,044h,0Eh
    db 065h,0Eh,073h,0Eh,063h,0Eh,072h,0Eh,069h,0Eh,070h,0Eh,074h,0Eh,06Fh,0Eh
    db 072h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,02Ah,0Eh,02Eh,0Eh,02Ah,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,048h,0Eh
    db 065h,0Eh,06Ch,0Eh,070h,0Eh,020h,0Eh,04Dh,0Eh,065h,0Eh,06Eh,0Eh,075h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,04Ch,0Eh,06Fh,0Eh,067h,0Eh,067h,0Eh,065h,0Eh,064h,0Eh,020h,0Eh
    db 044h,0Eh,072h,0Eh,069h,0Eh,076h,0Eh,065h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh
    db 044h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,04Eh,0Eh,06Fh,0Eh,02Eh,0Eh,054h,0Eh,061h,0Eh,067h,0Eh
    db 067h,0Eh,065h,0Eh,064h,0Eh,020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh
    db 073h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,034h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,044h,0Eh
    db 049h,0Eh,052h,0Eh,020h,0Eh,04Ah,0Eh,075h,0Eh,073h,0Eh,074h,0Eh,069h,0Eh
    db 066h,0Eh,079h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,055h,0Eh,073h,0Eh,065h,0Eh,020h,0Eh,052h,0Eh,061h,0Eh,06Dh,0Eh
    db 064h,0Eh,069h,0Eh,073h,0Eh,06Bh,0Eh,020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh
    db 04Eh,0Eh,04Fh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,056h,0Eh,065h,0Eh,072h,0Eh,069h,0Eh,066h,0Eh,079h,0Eh
    db 020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh,073h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,049h,0Eh
    db 067h,0Eh,06Eh,0Eh,06Fh,0Eh,072h,0Eh,065h,0Eh,020h,0Eh,048h,0Eh,069h,0Eh
    db 064h,0Eh,064h,0Eh,065h,0Eh,06Eh,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,04Ch,0Eh,069h,0Eh,073h,0Eh,074h,0Eh,069h,0Eh,06Eh,0Eh,067h,0Eh
    db 020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh
    db 04Eh,0Eh,04Fh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,052h,0Eh,065h,0Eh,063h,0Eh,075h,0Eh,072h,0Eh,073h,0Eh
    db 065h,0Eh,020h,0Eh,053h,0Eh,075h,0Eh,062h,0Eh,044h,0Eh,049h,0Eh,052h,0Eh
    db 073h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,04Fh,0Eh,046h,0Eh,046h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,051h,0Eh
    db 075h,0Eh,065h,0Eh,072h,0Eh,079h,0Eh,020h,0Eh,044h,0Eh,065h,0Eh,06Ch,0Eh
    db 065h,0Eh,074h,0Eh,065h,0Eh,073h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,04Fh,0Eh,046h,0Eh,046h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh
; UNKNOWN: not yet classified as code or data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 050h,07h,041h,07h,052h,07h,054h,07h,031h,07h,020h,07h,020h,07h,020h,07h
    db 02Eh,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,047h,07h,04Fh,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,02Eh,07h,042h,07h,041h,07h,054h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,043h,07h,04Fh,07h,042h,07h,04Fh,07h
    db 04Ch,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,048h,07h,04Ch,07h,050h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 04Dh,07h,041h,07h,050h,07h,045h,07h,044h,07h,020h,07h,020h,07h,020h,07h
    db 02Eh,07h,045h,07h,058h,07h,045h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,045h,07h,058h,07h,049h,07h,054h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,02Eh,07h,042h,07h,041h,07h,054h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,053h,07h,054h,07h,045h,07h,042h,07h
    db 055h,07h,052h,07h,047h,07h,020h,07h,02Eh,07h,043h,07h,054h,07h,059h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 053h,07h,050h,07h,047h,07h,052h,07h,041h,07h,042h,07h,020h,07h,020h,07h
    db 02Eh,07h,045h,07h,058h,07h,045h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,05Ch,07h,04Ch,07h,049h,07h,053h,07h,054h,07h,049h,07h,04Eh,07h
    db 047h,07h,053h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,042h,07h,049h,07h,04Eh,07h,043h,07h
    db 04Fh,07h,04Dh,07h,050h,07h,020h,07h,02Eh,07h,045h,07h,058h,07h,045h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 04Ch,07h,049h,07h,053h,07h,054h,07h,041h,07h,04Ch,07h,04Ch,07h,020h,07h
    db 02Eh,07h,042h,07h,041h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,042h,07h,04Fh,07h,052h,07h,052h,07h,04Fh,07h,057h,07h
    db 045h,07h,044h,07h,02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,02Ah,07h
    db 020h,07h,020h,07h,020h,07h,05Ch,071h,042h,071h,041h,071h,043h,071h,04Bh,071h
    db 055h,071h,050h,071h,035h,071h,020h,071h,02Eh,071h,020h,071h,020h,071h,020h,071h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 053h,07h,050h,07h,04Fh,07h,04Fh,07h,04Ch,07h,020h,07h,020h,07h,020h,07h
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,052h,07h,045h,07h,046h,07h,045h,07h,052h,07h,045h,07h
    db 04Eh,07h,043h,07h,02Eh,07h,045h,07h,053h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,05Ch,07h
    db 042h,07h,041h,07h,043h,07h,04Bh,07h,055h,07h,050h,07h,036h,07h,020h,07h
    db 02Eh,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,04Dh,07h,059h,07h,046h,07h,049h,07h,04Ch,07h,045h,07h
    db 053h,07h,031h,07h,02Eh,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 050h,07h,04Eh,07h,041h,07h,04Dh,07h,045h,07h,053h,07h,020h,07h,020h,07h
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,041h,07h,04Ch,07h,04Ch,07h,050h,07h,052h,07h,04Fh,07h
    db 047h,07h,053h,07h,02Eh,07h,04Ch,07h,05Ah,07h,048h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 054h,07h,04Dh,07h,050h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,042h,07h,041h,07h,043h,07h,04Bh,07h,055h,07h,050h,07h
    db 032h,07h,020h,07h,02Eh,07h,041h,07h,052h,07h,043h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 04Ch,07h,049h,07h,042h,07h,031h,07h,030h,07h,020h,07h,020h,07h,020h,07h
    db 02Eh,07h,04Ch,07h,049h,07h,042h,07h,020h,07h,02Ah,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,043h,07h,04Fh,07h,04Eh,07h,054h,07h,045h,07h,04Eh,07h
    db 054h,07h,053h,07h,02Eh,07h,054h,07h,058h,07h,054h,07h,020h,07h,02Ah,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 058h,07h,043h,07h,055h,07h,054h,07h,031h,07h,020h,07h,020h,07h,020h,07h
    db 02Eh,07h,043h,07h,04Fh,07h,04Dh,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,052h,07h,045h,07h,041h,07h,044h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,02Eh,07h,04Dh,07h,045h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 050h,07h,052h,07h,04Fh,07h,044h,07h,055h,07h,043h,07h,054h,07h,053h,07h
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,02Ah,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,04Dh,07h,041h,07h,04Eh,07h,047h,07h,04Ch,07h,045h,07h
    db 020h,07h,020h,07h,02Eh,07h,045h,07h,058h,07h,045h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 046h,07h,04Ch,07h,04Fh,07h,057h,07h,043h,07h,048h,07h,052h,07h,054h,07h
    db 02Eh,07h,046h,07h,04Ch,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,032h,07h,042h,07h,059h,07h,032h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,02Eh,07h,053h,07h,050h,07h,052h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 046h,07h,04Ch,07h,04Fh,07h,057h,07h,043h,07h,048h,07h,052h,07h,032h,07h
    db 02Eh,07h,046h,07h,04Ch,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,042h,07h,041h,07h,043h,07h,04Bh,07h,047h,07h,052h,07h
    db 04Eh,07h,044h,07h,02Eh,07h,04Eh,07h,045h,07h,04Fh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,031h,01Eh
    db 020h,01Eh,03Dh,01Eh,020h,01Eh,051h,01Eh,075h,01Eh,069h,01Eh,074h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,033h,01Eh,020h,01Eh,03Dh,01Eh
    db 020h,01Eh,043h,01Eh,061h,01Eh,073h,01Eh,065h,01Eh,020h,01Eh,044h,01Eh,065h,01Eh
    db 073h,01Eh,063h,01Eh,072h,01Eh,069h,01Eh,070h,01Eh,074h,01Eh,06Fh,01Eh,072h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,035h,01Eh,020h,01Eh,03Dh,01Eh,020h,01Eh
    db 050h,01Eh,072h,01Eh,069h,01Eh,06Eh,01Eh,074h,01Eh,020h,01Eh,053h,01Eh,063h,01Eh
    db 072h,01Eh,065h,01Eh,065h,01Eh,06Eh,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,032h,01Eh
    db 020h,01Eh,03Dh,01Eh,020h,01Eh,048h,01Eh,065h,01Eh,06Ch,01Eh,070h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,034h,01Eh,020h,01Eh,03Dh,01Eh
    db 020h,01Eh,043h,01Eh,072h,01Eh,075h,01Eh,06Eh,01Eh,063h,01Eh,068h,01Eh,020h,01Eh
    db 04Fh,01Eh,075h,01Eh,074h,01Eh,070h,01Eh,075h,01Eh,074h,01Eh,020h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,036h,01Eh,020h,01Eh,03Dh,01Eh,020h,01Eh
    db 053h,01Eh,068h,01Eh,06Fh,01Eh,077h,01Eh,020h,01Eh,041h,01Eh,074h,01Eh,074h,01Eh
    db 072h,01Eh,069h,01Eh,062h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,043h,01Eh,06Fh,01Eh,06Dh,01Eh,06Dh,01Eh,061h,01Eh,06Eh,01Eh
    db 064h,01Eh,03Fh,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h
; $-terminated messages for ShowFatalErrorAndExit / ShowOutOfMemoryAndExit.
MsgDeallocError db 'Memory de-allocation error$'
; UNKNOWN: not yet classified as code or data
MsgNotEnoughMemory db 'Not enough memory$'
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,020h,00h,080h,00h,00h,02h,04h,011h,0C4h,0Dh,054h,014h,04Ah,00h
    db 066h,00h,014h,00h,044h,00h,0E4h,01h,044h,02h,0DCh,00h,06Ch,07h,0A4h,0Bh
    db 0E8h,0Fh,02Ah,02h,04Ch,03h,02Ch,05h,05Ch,02h,084h,04h,034h,06h,0A4h,05h
    db 0Eh,01h,024h,03h,014h,00h,094h,00h,0A4h,00h,08h,01h,04Ah,00h,020h,00h
    db 02Eh,00h,02Ch,00h,0A0h,03h,0CCh,03h,0BAh,03h,0A0h,03h,0BEh,0Bh,040h,00h
    db 034h,00h,050h,00h,00h,0B8h,028h,00h,0A0h,00h,080h,02h,04h,022h,084h,01Bh
    db 0A4h,028h,090h,00h,0C8h,00h,024h,00h,084h,00h,0C4h,03h,084h,04h,0B4h,01h
    db 0D4h,0Eh,044h,017h,0CCh,01Fh,050h,04h,094h,06h,054h,0Ah,0B4h,04h,04h,09h
    db 064h,0Ch,044h,0Bh,018h,02h,044h,06h,024h,00h,024h,01h,044h,01h,0Ch,02h
    db 090h,00h,03Ch,00h,058h,00h,054h,00h,03Ch,07h,094h,07h,070h,07h,03Ch,07h
    db 078h,017h,080h,00h,068h,00h,0A0h,00h,00h,0A0h,040h,00h,00h,01h,00h,04h
    db 04h,022h,084h,01Bh,0A4h,028h,090h,00h,0C8h,00h,024h,00h,084h,00h,0C4h,03h
    db 084h,04h,0B4h,01h,0D4h,0Eh,044h,017h,0CCh,01Fh,050h,04h,094h,06h,054h,0Ah
    db 0B4h,04h,04h,09h,064h,0Ch,044h,0Bh,018h,02h,044h,06h,024h,00h,024h,01h
    db 044h,01h,0Ch,02h,090h,00h,03Ch,00h,058h,00h,054h,00h,03Ch,07h,094h,07h
    db 070h,07h,03Ch,07h,078h,017h,080h,00h,068h,00h,0A0h,00h,00h,0B8h,072h,010h
    db 0C6h,010h,01Ah,011h,0FFh,0FFh,04Ch,045h,056h,030h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,031h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,032h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,033h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,034h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,035h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,036h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,037h,04Dh,041h,050h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,030h,042h,04Ch,058h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,031h,042h,04Ch,058h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,032h,042h,04Ch,058h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,033h,042h,04Ch,058h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,034h,042h,04Ch,058h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,035h,042h,04Ch,058h,02Eh,042h,049h
    db 043h,00h,00h,00h,0FFh,0FFh,047h,030h,02Eh,042h,049h,043h,00h,00h,00h,0FFh
    db 0FFh,047h,031h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,047h,032h,02Eh,042h
    db 049h,043h,00h,00h,00h,0FFh,0FFh,047h,033h,02Eh,042h,049h,043h,00h,00h,00h
    db 0FFh,0FFh,047h,034h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,047h,035h,02Eh
    db 042h,049h,043h,00h,00h,00h,0FFh,0FFh,031h,058h,031h,02Eh,042h,049h,043h,00h
    db 00h,00h,0FFh,0FFh,032h,058h,032h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh
    db 032h,058h,032h,043h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,04Dh,041h,04Eh
    db 045h,058h,050h,04Ch,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,04Ch,04Fh,047h
    db 04Fh,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,054h,048h,045h,04Eh,044h,02Eh
    db 042h,049h,043h,00h,00h,00h,0FFh,0FFh,050h,041h,04Eh,045h,04Ch,02Eh,045h,04Eh
    db 043h,00h,00h,00h,0FFh,0FFh,053h,048h,049h,050h,02Eh,042h,049h,043h,00h,00h
    db 00h,0FFh,0FFh,042h,04Ch,055h,045h,042h,049h,054h,053h,02Eh,042h,049h,043h,00h
    db 00h,00h,0FFh,0FFh,057h,049h,04Eh,044h,04Fh,057h,02Eh,042h,049h,043h,00h,00h
    db 00h,0FFh,0FFh,049h,050h,041h,047h,045h,031h,02Eh,045h,04Eh,043h,00h,00h,00h
    db 0FFh,0FFh,049h,050h,041h,047h,045h,032h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh
    db 0FFh,049h,050h,041h,047h,045h,033h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh
    db 049h,050h,041h,047h,045h,034h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,049h
    db 050h,041h,047h,045h,035h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h
    db 041h,047h,045h,031h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h
    db 047h,045h,032h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h
    db 045h,033h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h
    db 034h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,035h
    db 02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,036h,02Eh
    db 045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,037h,02Eh,045h
    db 04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,038h,02Eh,045h,04Eh
    db 043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,039h,02Eh,045h,04Eh,043h
    db 00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,031h,030h,02Eh,045h,04Eh,043h
    db 00h,00h,00h,0FFh,0FFh,06Fh,06Bh,06Dh,065h,06Eh,075h,02Eh,065h,06Eh,063h,00h
    db 00h,00h,0FFh,0FFh,063h,061h,06Ch,069h,062h,02Eh,065h,06Eh,063h,00h,00h,00h
    db 0FFh,0FFh,072h,065h,064h,065h,066h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh
    db 068h,069h,073h,063h,06Fh,072h,065h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh
    db 077h,069h,06Eh,073h,063h,072h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h
    db 06Ch,061h,071h,030h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h
    db 071h,031h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,032h
    db 02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,033h,02Eh,065h
    db 06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,034h,02Eh,065h,06Eh,063h
    db 00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,035h,02Eh,065h,06Eh,063h,00h,00h
    db 00h,0FFh,0FFh,06Ch,065h,076h,073h,063h,072h,02Eh,065h,06Eh,063h,00h,00h,00h
    db 0FFh,0FFh,063h,068h,06Fh,06Fh,073h,065h,02Eh,065h,06Eh,063h,00h,00h,00h,090h
    db 076h,011h,086h,011h,096h,011h,0A6h,011h,0B6h,011h,0C6h,011h,0D6h,011h,0E6h,011h
    db 098h,012h,0A4h,012h,0B0h,012h,0BDh,012h,0CDh,012h,0DAh,012h,0E8h,012h,0F6h,012h
    db 03h,013h,014h,013h,0FFh,0FFh,00h,00h,056h,012h,0F6h,011h,061h,012h,06h,012h
    db 06Ch,012h,016h,012h,077h,012h,026h,012h,082h,012h,036h,012h,08Dh,012h,046h,012h
    db 056h,012h,0F6h,011h,077h,012h,026h,012h,095h,014h,04Fh,014h,05Dh,014h,06Bh,014h
    db 079h,014h,087h,014h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,090h,00h,00h,0A8h,020h,041h,06Eh,06Fh,074h,068h,065h,072h,020h
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
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
; UNKNOWN: not yet classified as code or data
PoolBCursor dw 02B5Ch
; UNKNOWN: not yet classified as code or data
    db 00h,00h,0CBh,07Bh
    db 077h,079h,06h,07Bh,03Fh,07Ch,0A2h,07Ch,0C8h,07Dh,01h,00h,00h,00h,01h,00h
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
    db 080h,00h,0C0h,00h,030h,075h,060h,00h,0FFh,0FFh,00h,00h,00h
; Set by the typed-key sequence matcher (0F7F frame): keep the life count when a life
; is lost, and allow F4 to skip to the next level.
KeepLivesFlag db 00h
; UNKNOWN: not yet classified as code or data
    db 00h
LevelSkipEnabled db 00h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,094h,097h,011h,023h,01Eh,014h,018h,017h,026h,01Fh,023h,018h,013h,014h
    db 01Eh,022h,012h,00h,0A6h,097h,026h,017h,021h,012h,017h,031h,014h,023h,012h,021h
    db 01Eh,01Fh,014h,026h,01Eh,031h,012h,00h,0BAh,097h,030h,018h,031h,016h,01Fh,02Eh
    db 023h,012h,01Eh,014h,018h,031h,00h,0C9h,097h,032h,015h,031h,01Eh,032h,012h,017h
    db 01Fh,01Fh,032h,017h,014h,023h,00h,0D9h,097h,022h,017h,030h,01Fh,014h,032h,017h
    db 013h,01Fh,02Eh,023h,031h,012h,026h,026h,021h,012h,016h,012h,013h,00h,0F0h,097h
    db 013h,012h,032h,017h,031h,020h,032h,012h,014h,018h,01Fh,032h,017h,026h,012h,015h
    db 018h,016h,025h,031h,018h,011h,014h,023h,012h,018h,026h,020h,021h,013h,017h,012h
    db 031h,020h,01Fh,026h,017h,031h,012h,00h,01Ah,098h,012h,02Fh,012h,013h,015h,020h
    db 01Eh,015h,017h,020h,017h,012h,00h,090h,010h,00h,010h,00h,040h,00h,040h,00h
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
; UNKNOWN: not yet classified as code or data
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
; UNKNOWN: not yet classified as code or data
HistoryReadCursor15 dw 00000h
; UNKNOWN: not yet classified as code or data
HistoryReadCursor31 dw 00000h
HistoryCursor47 dw 00000h
; Requests raised during a frame and acted on by the main loop.
GameOverRequest dw 00000h
NextLevelRequest dw 00000h
LifeLostRequest dw 00000h
; UNKNOWN: not yet classified as code or data
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
; UNKNOWN: not yet classified as code or data
OffsetXWork dw 00000h
; UNKNOWN: not yet classified as code or data
OffsetXGroupA dw 00000h
; UNKNOWN: not yet classified as code or data
OffsetXGroupB dw 00000h
; UNKNOWN: not yet classified as code or data
ClampXLowSeen db 00h
; UNKNOWN: not yet classified as code or data
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
; UNKNOWN: not yet classified as code or data
HistoryRecordSlot31 dw 0FFFFh
; UNKNOWN: not yet classified as code or data
PlusSlotA966 dw 0FFFFh
; UNKNOWN: not yet classified as code or data
MinusSlotA968 dw 0FFFFh
; UNKNOWN: not yet classified as code or data
PlusSlotA96A dw 0FFFFh
; UNKNOWN: not yet classified as code or data
MinusSlotA96C dw 0FFFFh
; UNKNOWN: not yet classified as code or data
    db 0FFh,0FFh
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,02Ah,015h,00h,030h,024h,04h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0DAh,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0B7h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,048h,07h,04Fh,07h,057h,07h,020h,07h,054h,07h,04Fh,07h
    db 020h,07h,04Fh,07h,052h,07h,044h,07h,045h,07h,052h,07h,020h,07h,04Fh,07h
    db 056h,07h,045h,07h,052h,07h,04Bh,07h,049h,07h,04Ch,07h,04Ch,07h,020h,07h
    db 02Dh,07h,020h,07h,054h,07h,048h,07h,045h,07h,020h,07h,053h,07h,049h,07h
    db 058h,07h,020h,07h,050h,07h,04Ch,07h,041h,07h,04Eh,07h,045h,07h,054h,07h
    db 020h,07h,04Dh,07h,045h,07h,047h,07h,041h,07h,042h,07h,04Ch,07h,041h,07h
    db 053h,07h,054h,07h,021h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0C3h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0B6h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,041h,07h,06Ch,07h,06Ch,07h,020h,07h,073h,07h
    db 069h,07h,078h,07h,020h,07h,070h,07h,06Ch,07h,061h,07h,06Eh,07h,065h,07h
    db 074h,07h,073h,07h,020h,07h,06Fh,07h,066h,07h,020h,07h,04Fh,07h,076h,07h
    db 065h,07h,072h,07h,04Bh,07h,069h,07h,06Ch,07h,06Ch,07h,020h,07h,063h,07h
    db 061h,07h,06Eh,07h,020h,07h,062h,07h,065h,07h,020h,07h,06Fh,07h,072h,07h
    db 064h,07h,065h,07h,072h,07h,065h,07h,064h,07h,020h,07h,062h,07h,079h,07h
    db 020h,07h,063h,07h,061h,07h,06Ch,07h,06Ch,07h,069h,07h,06Eh,07h,067h,07h
    db 020h,07h,074h,07h,06Fh,07h,06Ch,07h,06Ch,07h,020h,07h,066h,07h,072h,07h
    db 065h,07h,065h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,066h,07h,072h,07h,06Fh,07h,06Dh,07h
    db 020h,07h,074h,07h,068h,07h,065h,07h,020h,07h,055h,07h,053h,07h,041h,07h
    db 020h,07h,06Fh,07h,072h,07h,020h,07h,043h,07h,061h,07h,06Eh,07h,061h,07h
    db 064h,07h,061h,07h,020h,07h,038h,07h,030h,07h,030h,07h,02Dh,07h,039h,07h
    db 037h,07h,032h,07h,02Dh,07h,037h,07h,034h,07h,033h,07h,034h,07h,02Ch,07h
    db 020h,07h,06Fh,07h,072h,07h,020h,07h,063h,07h,061h,07h,06Ch,07h,06Ch,07h
    db 020h,07h,033h,07h,030h,07h,031h,07h,020h,07h,032h,07h,039h,07h,039h,07h
    db 02Dh,07h,033h,07h,038h,07h,034h,07h,031h,07h,02Eh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,054h,07h,068h,07h,065h,07h,020h,07h,070h,07h
    db 072h,07h,069h,07h,063h,07h,065h,07h,020h,07h,069h,07h,073h,07h,020h,07h
    db 024h,07h,033h,07h,030h,07h,020h,07h,066h,07h,06Fh,07h,072h,07h,020h,07h
    db 074h,07h,068h,07h,065h,07h,020h,07h,073h,07h,069h,07h,078h,07h,02Dh,07h
    db 070h,07h,06Ch,07h,061h,07h,06Eh,07h,065h,07h,074h,07h,020h,07h,06Dh,07h
    db 065h,07h,067h,07h,061h,07h,062h,07h,06Ch,07h,061h,07h,073h,07h,074h,07h
    db 020h,07h,070h,07h,06Ch,07h,075h,07h,073h,07h,020h,07h,024h,07h,034h,07h
    db 020h,07h,073h,07h,068h,07h,069h,07h,070h,07h,070h,07h,069h,07h,06Eh,07h
    db 067h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,061h,07h,06Eh,07h,064h,07h,020h,07h
    db 068h,07h,061h,07h,06Eh,07h,064h,07h,06Ch,07h,069h,07h,06Eh,07h,067h,07h
    db 020h,07h,069h,07h,06Eh,07h,020h,07h,055h,07h,02Eh,07h,053h,07h,02Eh,07h
    db 020h,07h,046h,07h,075h,07h,06Eh,07h,064h,07h,073h,07h,02Eh,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,04Dh,07h,061h,07h,072h,07h,079h,07h,06Ch,07h
    db 061h,07h,06Eh,07h,064h,07h,020h,07h,072h,07h,065h,07h,073h,07h,069h,07h
    db 064h,07h,065h,07h,06Eh,07h,074h,07h,073h,07h,020h,07h,04Dh,07h,055h,07h
    db 053h,07h,054h,07h,020h,07h,061h,07h,064h,07h,064h,07h,020h,07h,035h,07h
    db 025h,07h,020h,07h,074h,07h,061h,07h,078h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,057h,07h,065h,07h,020h,07h,061h,07h,063h,07h
    db 063h,07h,065h,07h,070h,07h,074h,07h,020h,07h,056h,07h,069h,07h,073h,07h
    db 061h,07h,020h,07h,026h,07h,020h,07h,04Dh,07h,061h,07h,073h,07h,074h,07h
    db 065h,07h,072h,07h,020h,07h,043h,07h,061h,07h,072h,07h,064h,07h,02Eh,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,04Fh,07h,072h,07h,020h,07h,073h,07h,065h,07h
    db 06Eh,07h,064h,07h,020h,07h,063h,07h,068h,07h,065h,07h,063h,07h,06Bh,07h
    db 020h,07h,06Fh,07h,072h,07h,020h,07h,06Dh,07h,06Fh,07h,06Eh,07h,065h,07h
    db 079h,07h,020h,07h,06Fh,07h,072h,07h,064h,07h,065h,07h,072h,07h,020h,07h
    db 074h,07h,06Fh,07h,03Ah,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,045h,07h,070h,07h,069h,07h,063h,07h,020h,07h
    db 04Dh,07h,065h,07h,067h,07h,061h,07h,047h,07h,061h,07h,06Dh,07h,065h,07h
    db 073h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,031h,07h,030h,07h,034h,07h,030h,07h,036h,07h
    db 020h,07h,048h,07h,06Fh,07h,06Ch,07h,062h,07h,072h,07h,06Fh,07h,06Fh,07h
    db 06Bh,07h,020h,07h,044h,07h,072h,07h,069h,07h,076h,07h,065h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,050h,07h,06Fh,07h,074h,07h,06Fh,07h,06Dh,07h
    db 061h,07h,063h,07h,02Ch,07h,020h,07h,04Dh,07h,044h,07h,020h,07h,032h,07h
    db 030h,07h,038h,07h,035h,07h,034h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,055h,07h,02Eh,07h,053h,07h,02Eh,07h,041h,07h
    db 02Eh,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0C3h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0B6h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0B3h,07h,020h,07h,020h,07h,043h,07h,06Fh,07h,070h,07h,079h,07h,072h,07h
    db 069h,07h,067h,07h,068h,07h,074h,07h,020h,07h,028h,07h,063h,07h,029h,07h
    db 020h,07h,031h,07h,039h,07h,039h,07h,032h,07h,020h,07h,054h,07h,065h,07h
    db 063h,07h,068h,07h,02Dh,07h,04Eh,07h,06Fh,07h,069h,07h,072h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 0D4h,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0BCh,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
    db 020h,07h,020h,07h,020h,07h,020h,07h,045h,04Dh,04Dh,058h,058h,058h,058h,030h
    db 00h,00h,00h,00h,00h,00h,00h,00h,03Ah,0B9h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
FileStatus dw 00000h
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,090h,00h,00h,04Fh,056h,045h,052h,04Bh,049h,04Ch,04Ch
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
    db 01h,00h,023h,013h,032h,013h,041h,013h,050h,013h,05Fh,013h,0FFh,0FFh,01h,00h
    db 06Eh,013h,07Dh,013h,08Ch,013h,09Bh,013h,0AAh,013h,0B9h,013h,0C8h,013h,0D7h,013h
    db 0E6h,013h,0F5h,013h,0FFh,0FFh,00h,00h,05h,014h,0FFh,0FFh,00h,00h,014h,014h
    db 0FFh,0FFh,00h,00h,022h,014h,0FFh,0FFh,00h,00h,030h,014h,0FFh,0FFh,00h,00h
    db 040h,014h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h
DifficultySetting dw 00001h
; UNKNOWN: not yet classified as code or data
    db 02h,02Eh
    db 02h,053h,02h,078h,015h,02Eh,015h,053h,015h,078h,014h,0A5h,019h,0A5h,01Eh,0A5h
; Handlers for stream bytes 80h..85h: end, rest, step down, step up, slide, hold.
SfxCommandTable db 02Fh,0D6h,0D6h,0D5h,041h,0D6h,048h,0D6h,04Fh,0D6h,0CCh,0D5h,00h,00h
SfxActive db 00h
; Effect requested of SfxTimerTick (below 20h); lower IDs pre-empt higher ones.
SfxRequest db 00h
; PC-speaker effect player (SfxTimerTick, run every timer tick). An effect is a pair of
; byte streams, one per voice; the voices take turns driving the speaker tick by tick.
SfxTickPhase db 00h
; UNKNOWN: not yet classified as code or data
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
; UNKNOWN: not yet classified as code or data
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
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
AttributePatchPointers db 0B6h,0C4h,0FFh,0C4h,020h,0C5h
; UNKNOWN: not yet classified as code or data
    db 065h,0C5h,0FFh,0C4h,0A4h,0C5h,01h,00h,0Ch,00h,0Eh,00h,012h,00h,014h,00h
    db 017h,00h,01Ah,00h,01Bh,00h,01Eh,00h,026h,00h,02Ah,00h,02Fh,00h,033h,00h
    db 03Eh,00h,041h,00h,048h,00h,04Ch,00h,055h,00h,057h,00h,058h,00h,05Bh,00h
    db 061h,00h,064h,00h,07Bh,00h,07Eh,00h,07Fh,00h,082h,00h,096h,00h,099h,00h
    db 0B5h,00h,0BAh,00h,0BBh,00h,0BCh,00h,0BDh,00h,0C2h,00h,0DFh,00h,0FFh,01h
    db 00h,0A3h,00h,0A1h,00h,0A8h,00h,075h,00h,071h,00h,0A6h,00h,06Fh,00h,06Ch
    db 02h,06Dh,02h,07Ah,00h,08Ah,00h,094h,00h,095h,00h,0ACh,00h,0B1h,00h,0FFh
    db 01h,00h,03h,00h,0Ch,00h,0Dh,00h,013h,00h,016h,00h,01Eh,00h,023h,00h
    db 028h,00h,02Ah,00h,025h,00h,047h,00h,048h,00h,04Ch,00h,04Dh,00h,04Eh,00h
    db 04Fh,00h,050h,00h,052h,00h,058h,00h,05Ah,00h,082h,00h,087h,00h,088h,00h
    db 080h,00h,082h,00h,087h,00h,089h,00h,0AAh,00h,0ABh,00h,0ADh,00h,0E1h,00h
    db 0B0h,00h,0B1h,00h,0FFh,01h,00h,0Fh,00h,011h,00h,012h,00h,022h,00h,023h
    db 00h,055h,00h,059h,00h,05Bh,00h,060h,00h,062h,00h,063h,00h,064h,00h,066h
    db 00h,067h,00h,068h,00h,06Eh,00h,076h,00h,078h,00h,07Eh,00h,07Fh,00h,085h
    db 00h,08Ah,00h,08Bh,00h,08Ch,00h,095h,00h,096h,00h,097h,00h,098h,00h,099h
    db 00h,09Ah,00h,0FFh,01h,00h,03h,00h,0Ch,00h,0Dh,00h,013h,00h,016h,00h
    db 01Eh,00h,023h,00h,028h,00h,02Ah,00h,025h,00h,047h,00h,048h,00h,04Ch,00h
    db 04Dh,00h,04Eh,00h,04Fh,00h,050h,00h,052h,00h,058h,00h,05Ah,00h,082h,00h
    db 087h,00h,088h,00h,080h,00h,082h,00h,087h,00h,089h,00h,0AAh,00h,0ABh,00h
    db 0B0h,00h,0B1h,00h,0D2h,00h,0D3h,00h,0FFh,0F5h,0C5h,0F7h,0C5h,0F9h,0C5h,0FBh
    db 0C5h,0FDh,0C5h,0FFh,0C5h,05Ch,0C8h,0D6h,0C8h,02h,0CAh,036h,0CCh,080h,0CCh,0AAh
    db 0CCh,0Dh,0C6h,02Bh,0C6h,049h,0C6h,067h,0C6h,085h,0C6h,0A3h,0C6h,09Ch,00h,011h
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
    db 00h,00h,00h,01h,01h,04h,00h,00h,00h,00h,00h,090h,010h,01h,0E0h,0D0h
    db 0C0h,00h,0F0h,0FFh,0BDh,00h,088h,0CFh,0B0h,00h,0F0h,0FFh,0BDh,00h,068h,0CFh
    db 010h,00h,0F0h,0FFh,0ADh,00h,0B0h,0D0h,040h,00h,0F0h,0FFh,06Ch,00h,0F4h,0CFh
    db 050h,00h,0F0h,0FFh,06Bh,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,060h,00h,0F4h,0CFh
    db 080h,00h,0F0h,0FFh,05Fh,00h,0F4h,0CFh,080h,00h,0F0h,0FFh,057h,00h,088h,0CFh
    db 0B0h,00h,0F0h,0FFh,057h,00h,068h,0CFh,010h,00h,0F0h,0FFh,048h,00h,03Ch,0CFh
    db 060h,00h,0F0h,0FFh,02Dh,00h,03Ch,0CFh,060h,00h,0F0h,0FFh,04h,00h,0F4h,0CDh
    db 00h,00h,0F0h,0FFh,04h,00h,02Ch,0CEh,0B0h,00h,0F0h,0FFh,04h,00h,070h,0D0h
    db 070h,00h,00h,00h,0FFh,0FFh,010h,01h,0F8h,0D0h,0C0h,00h,0E0h,00h,0Ah,01h
    db 040h,0D1h,00h,00h,0F0h,0FFh,0FAh,00h,068h,0D1h,070h,00h,0F0h,0FFh,0EDh,00h
    db 090h,0D1h,020h,00h,0F0h,0FFh,0DCh,00h,034h,0D1h,00h,00h,0F0h,0FFh,0CFh,00h
    db 088h,0CFh,0B0h,00h,0F0h,0FFh,0BBh,00h,090h,0D1h,0C0h,00h,0F0h,0FFh,0A2h,00h
    db 0A4h,0D0h,020h,00h,0F0h,0FFh,09Ah,00h,068h,0D1h,0A0h,00h,0F0h,0FFh,098h,00h
    db 068h,0D1h,0A0h,00h,0F0h,0FFh,092h,00h,01Ch,0D1h,060h,00h,0F0h,0FFh,082h,00h
    db 0B0h,0D0h,040h,00h,0F0h,0FFh,06Eh,00h,03Ch,0CFh,010h,00h,0F0h,0FFh,06Eh,00h
    db 03Ch,0CFh,0B0h,00h,0F0h,0FFh,067h,00h,034h,0D1h,00h,00h,0F0h,0FFh,064h,00h
    db 0A4h,0D0h,0B0h,00h,0F0h,0FFh,05Bh,00h,07Ch,0D0h,080h,00h,0F0h,0FFh,046h,00h
    db 0FFh,0FFh,058h,0D0h,060h,00h,00h,00h,03Fh,00h,068h,0CFh,010h,00h,0F0h,0FFh
    db 03Ch,00h,0FFh,0FFh,018h,0D0h,00h,00h,0F0h,0FFh,03Bh,00h,0FFh,0FFh,018h,0D0h
    db 00h,00h,0F0h,0FFh,031h,00h,0FFh,0FFh,024h,0D0h,00h,00h,00h,00h,02Eh,00h
    db 0FFh,0FFh,058h,0D0h,050h,00h,00h,00h,02Eh,00h,0FFh,0FFh,064h,0D0h,060h,00h
    db 00h,00h,02Eh,00h,0FFh,0FFh,058h,0D0h,070h,00h,00h,00h,02Ah,00h,0FFh,0FFh
    db 024h,0D0h,00h,00h,00h,00h,025h,00h,0FFh,0FFh,024h,0D0h,0C0h,00h,00h,00h
    db 01Fh,00h,0FFh,0FFh,018h,0D0h,00h,00h,00h,00h,01Fh,00h,0FFh,0FFh,024h,0D0h
    db 00h,00h,00h,00h,01Eh,00h,03Ch,0D0h,040h,00h,00h,00h,01Bh,00h,0FFh,0FFh
    db 018h,0D0h,00h,00h,00h,00h,01Bh,00h,0C8h,0D0h,090h,00h,0F0h,0FFh,019h,00h
    db 0FFh,0FFh,018h,0D0h,020h,00h,00h,00h,04h,00h,070h,0D0h,070h,00h,00h,00h
    db 0FFh,0FFh,010h,01h,0ECh,0D0h,00h,00h,0F0h,0FFh,0Fh,01h,0FFh,0FFh,030h,0D0h
    db 00h,00h,0F0h,0FFh,0Ch,01h,0CCh,0CDh,010h,00h,0F0h,0FFh,04h,01h,0C4h,0CFh
    db 040h,00h,0F0h,0FFh,04h,01h,0C4h,0CFh,080h,00h,0F0h,0FFh,0F8h,00h,0FFh,0FFh
    db 0Ch,0D0h,0B0h,00h,0F0h,0FFh,0F0h,00h,01Ch,0CFh,010h,00h,0F0h,0FFh,0EAh,00h
    db 0B8h,0CDh,040h,00h,0F0h,0FFh,0E2h,00h,034h,0D1h,00h,00h,0F0h,0FFh,0DBh,00h
    db 0C8h,0D0h,010h,00h,0F0h,0FFh,0D8h,00h,0C8h,0D0h,010h,00h,0F0h,0FFh,0D3h,00h
    db 0FFh,0FFh,030h,0D0h,00h,00h,0F0h,0FFh,0D2h,00h,03Ch,0CFh,060h,00h,0F0h,0FFh
    db 0D1h,00h,0A4h,0CDh,0C0h,00h,0F0h,0FFh,0C7h,00h,0C8h,0D0h,090h,00h,0F0h,0FFh
    db 0C0h,00h,0FFh,0FFh,0Ch,0D0h,080h,00h,0F0h,0FFh,0BEh,00h,0FFh,0FFh,0DCh,0CFh
    db 0A0h,00h,0F0h,0FFh,0BCh,00h,0A8h,0CFh,050h,00h,0F0h,0FFh,0B0h,00h,0CCh,0CEh
    db 060h,00h,0F0h,0FFh,0B0h,00h,0F4h,0CEh,070h,00h,0F0h,0FFh,0AEh,00h,0FFh,0FFh
    db 0B0h,0D1h,0B0h,00h,0F0h,0FFh,0ACh,00h,0FFh,0FFh,0B0h,0D1h,0B0h,00h,0F0h,0FFh
    db 09Fh,00h,0FFh,0FFh,0A4h,0D1h,020h,00h,0F0h,0FFh,099h,00h,0FFh,0FFh,08Ch,0CDh
    db 0B0h,00h,0F0h,0FFh,094h,00h,0FFh,0FFh,0A4h,0D1h,020h,00h,0F0h,0FFh,085h,00h
    db 0FFh,0FFh,0DCh,0CFh,030h,00h,0F0h,0FFh,084h,00h,064h,0CEh,0A0h,00h,0F0h,0FFh
    db 078h,00h,03Ch,0CFh,0B0h,00h,0F0h,0FFh,075h,00h,0FFh,0FFh,0A4h,0D1h,010h,00h
    db 0F0h,0FFh,073h,00h,0FFh,0FFh,0A4h,0D1h,010h,00h,0F0h,0FFh,072h,00h,0F4h,0CFh
    db 050h,00h,0F0h,0FFh,070h,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,070h,00h,0FFh,0FFh
    db 0B0h,0D1h,0A0h,00h,0F0h,0FFh,06Eh,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,06Eh,00h
    db 0FFh,0FFh,0B0h,0D1h,0A0h,00h,0F0h,0FFh,06Ch,00h,0F4h,0CFh,050h,00h,0F0h,0FFh
    db 066h,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,062h,00h,084h,0CEh,00h,00h,0F0h,0FFh
    db 05Bh,00h,0FFh,0FFh,0Ch,0D0h,00h,00h,0F0h,0FFh,059h,00h,0FFh,0FFh,030h,0D0h
    db 00h,00h,0F0h,0FFh,058h,00h,07Ch,0CDh,020h,00h,0F0h,0FFh,051h,00h,0FFh,0FFh
    db 054h,0CDh,00h,00h,00h,00h,050h,00h,06Ch,0CDh,020h,00h,0F0h,0FFh,04Ah,00h
    db 0FFh,0FFh,0E8h,0CFh,060h,00h,0F0h,0FFh,048h,00h,0FFh,0FFh,0E8h,0CFh,070h,00h
    db 0F0h,0FFh,045h,00h,0FFh,0FFh,0E8h,0CFh,0C0h,00h,0F0h,0FFh,044h,00h,0FFh,0FFh
    db 058h,0D0h,040h,00h,00h,00h,043h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh
    db 040h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh,03Fh,00h,0FFh,0FFh,0E8h,0CFh
    db 0C0h,00h,0F0h,0FFh,03Eh,00h,090h,0D0h,0C0h,00h,0F0h,0FFh,03Bh,00h,0FFh,0FFh
    db 0DCh,0CFh,020h,00h,0F0h,0FFh,036h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh
    db 035h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh,034h,00h,0FFh,0FFh,0E8h,0CFh
    db 0C0h,00h,0F0h,0FFh,02Ah,00h,0FFh,0FFh,024h,0D0h,00h,00h,00h,00h,024h,00h
    db 0FFh,0FFh,08Ch,0CDh,060h,00h,0F0h,0FFh,021h,00h,0FFh,0FFh,0DCh,0CFh,00h,00h
    db 0F0h,0FFh,021h,00h,0FFh,0FFh,0DCh,0CFh,020h,00h,0F0h,0FFh,021h,00h,0E4h,0CDh
    db 090h,00h,0F0h,0FFh,015h,00h,028h,0CDh,060h,00h,0F0h,0FFh,04h,00h,070h,0D0h
    db 070h,00h,00h,00h,0FFh,0FFh,010h,01h,0D4h,0D0h,00h,00h,0F0h,0FFh,099h,00h
    db 0FFh,0FFh,08Ch,0CDh,060h,00h,0F0h,0FFh,088h,00h,0FFh,0FFh,098h,0CDh,050h,00h
    db 0F0h,0FFh,05Ah,00h,0FFh,0FFh,098h,0CDh,060h,00h,0F0h,0FFh,032h,00h,0FFh,0FFh
    db 08Ch,0CDh,060h,00h,0F0h,0FFh,01Ah,00h,068h,0CFh,010h,00h,0F0h,0FFh,01Ah,00h
    db 088h,0CFh,0B0h,00h,0F0h,0FFh,04h,00h,070h,0D0h,070h,00h,00h,00h,0FFh,0FFh
    db 010h,01h,04h,0D1h,00h,00h,0F0h,0FFh,0B1h,00h,0B0h,0D0h,040h,00h,0F0h,0FFh
    db 06Bh,00h,03Ch,0CFh,060h,00h,0F0h,0FFh,010h,00h,084h,0CEh,00h,00h,0F0h,0FFh
    db 04h,00h,070h,0D0h,070h,00h,00h,00h,0FFh,0FFh,010h,01h,010h,0D1h,00h,00h
    db 0F0h,0FFh,0D3h,00h,068h,0D1h,0A0h,00h,0F0h,0FFh,0D3h,00h,068h,0D1h,0A0h,00h
    db 0F0h,0FFh,0D1h,00h,068h,0D1h,0A0h,00h,0F0h,0FFh,0C8h,00h,0F4h,0CFh,050h,00h
    db 0F0h,0FFh,0C6h,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,0C4h,00h,0F4h,0CFh,050h,00h
    db 0F0h,0FFh,02Dh,00h,0FFh,0FFh,060h,0CDh,0B0h,00h,0F0h,0FFh,02Ch,00h,0FFh,0FFh
    db 060h,0CDh,0B0h,00h,0F0h,0FFh,02Bh,00h,0FFh,0FFh,060h,0CDh,0B0h,00h,0F0h,0FFh
    db 02Ah,00h,0FFh,0FFh,060h,0CDh,0B0h,00h,0F0h,0FFh,022h,00h,0FFh,0FFh,060h,0CDh
    db 010h,00h,0F0h,0FFh,021h,00h,0FFh,0FFh,060h,0CDh,010h,00h,0F0h,0FFh,04h,00h
    db 070h,0D0h,070h,00h,00h,00h,0FFh,0FFh,01h,00h,01h,00h,04Fh,00h,09h,00h
    db 00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,010h,00h,00h,00h
    db 010h,00h,0F0h,0FFh,010h,00h,0E0h,0FFh,020h,00h,00h,00h,020h,00h,0F0h,0FFh
    db 020h,00h,0E0h,0FFh,01h,00h,01h,00h,04Dh,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,01h,00h,07Bh,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
    db 04Ch,00h,02h,00h,08h,00h,00h,00h,028h,00h,00h,00h,01h,00h,01h,00h
    db 04Bh,00h,02h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,02h,00h,01h,00h
    db 048h,00h,01h,00h,00h,00h,00h,00h,02h,00h,01h,00h,049h,00h,01h,00h
    db 00h,00h,00h,00h,01h,00h,01h,00h,047h,00h,03h,00h,00h,00h,00h,00h
    db 00h,00h,0F0h,0FFh,00h,00h,0D0h,0FFh,01h,00h,01h,00h,046h,00h,03h,00h
    db 00h,00h,00h,00h,010h,00h,00h,00h,020h,00h,00h,00h,01h,00h,00h,00h
    db 08Ah,00h,04h,00h,00h,00h,00h,00h,030h,00h,00h,00h,060h,00h,00h,00h
    db 090h,00h,00h,00h,01h,00h,00h,00h,08Ah,00h,02h,00h,00h,00h,00h,00h
    db 030h,00h,00h,00h,01h,00h,01h,00h,066h,00h,0Ch,00h,00h,00h,00h,00h
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
    db 00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh,00h,00h,090h,0FFh,00h,00h,080h,0FFh
    db 00h,00h,070h,0FFh,00h,00h,060h,0FFh,00h,00h,050h,0FFh,01h,00h,01h,00h
    db 067h,00h,0Ch,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh
    db 00h,00h,090h,0FFh,00h,00h,080h,0FFh,00h,00h,070h,0FFh,00h,00h,060h,0FFh
    db 00h,00h,050h,0FFh,01h,00h,01h,00h,045h,00h,06h,00h,00h,00h,00h,00h
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
    db 00h,00h,0B0h,0FFh,01h,00h,01h,00h,045h,00h,010h,00h,00h,00h,00h,00h
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
    db 00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh,00h,00h,090h,0FFh,00h,00h,080h,0FFh
    db 00h,00h,070h,0FFh,00h,00h,060h,0FFh,00h,00h,050h,0FFh,00h,00h,040h,0FFh
    db 00h,00h,030h,0FFh,00h,00h,020h,0FFh,00h,00h,010h,0FFh,01h,00h,01h,00h
    db 043h,00h,08h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh
    db 00h,00h,090h,0FFh,01h,00h,01h,00h,044h,00h,08h,00h,00h,00h,00h,00h
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
    db 00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh,00h,00h,090h,0FFh,01h,00h,01h,00h
    db 041h,00h,06h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,01h,00h,01h,00h
    db 031h,00h,09h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh
    db 00h,00h,090h,0FFh,00h,00h,080h,0FFh,01h,00h,01h,00h,010h,00h,06h,00h
    db 00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh
    db 00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,01h,00h,01h,00h,011h,00h,06h,00h
    db 00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh
    db 00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,01h,00h,01h,00h,042h,00h,05h,00h
    db 00h,00h,00h,00h,020h,00h,0E0h,0FFh,040h,00h,0C0h,0FFh,020h,00h,0A0h,0FFh
    db 00h,00h,080h,0FFh,01h,00h,01h,00h,040h,00h,04h,00h,00h,00h,00h,00h
    db 010h,00h,00h,00h,020h,00h,00h,00h,030h,00h,00h,00h,01h,00h,01h,00h
    db 03Eh,00h,01h,00h,08h,00h,0F8h,0FFh,01h,00h,01h,00h,03Ch,00h,01h,00h
    db 00h,00h,00h,00h,01h,00h,01h,00h,03Bh,00h,04h,00h,08h,00h,010h,00h
    db 010h,00h,00h,00h,020h,00h,00h,00h,028h,00h,010h,00h,01h,00h,01h,00h
    db 03Ah,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h,083h,00h,01h,00h
    db 00h,00h,00h,00h,01h,00h,01h,00h,038h,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,01h,00h,039h,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
    db 037h,00h,05h,00h,00h,00h,00h,00h,010h,00h,00h,00h,020h,00h,00h,00h
    db 030h,00h,00h,00h,040h,00h,00h,00h,01h,00h,01h,00h,035h,00h,01h,00h
    db 00h,00h,00h,00h,01h,00h,01h,00h,036h,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,01h,00h,021h,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
    db 032h,00h,03h,00h,00h,00h,00h,00h,010h,00h,00h,00h,020h,00h,00h,00h
    db 01h,00h,01h,00h,04Eh,00h,03h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh
    db 00h,00h,0E0h,0FFh,01h,00h,01h,00h,030h,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,01h,00h,02Dh,00h,04h,00h,00h,00h,00h,00h,010h,00h,0F0h,0FFh
    db 030h,00h,0F0h,0FFh,040h,00h,00h,00h,01h,00h,00h,00h,034h,00h,01h,00h
    db 00h,00h,00h,00h,01h,00h,01h,00h,013h,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,01h,00h,015h,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
    db 01Ch,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h,01Fh,00h,01h,00h
    db 00h,00h,00h,00h,01h,00h,01h,00h,07Dh,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,01h,00h,07Eh,00h,01h,00h,00h,00h,00h,00h,01h,00h,00h,00h
    db 089h,00h,04h,00h,00h,00h,00h,00h,00h,00h,0E0h,0FFh,020h,00h,00h,00h
    db 020h,00h,0E0h,0FFh,01h,00h,01h,00h,02Fh,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,00h,00h,019h,00h,03h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh
    db 00h,00h,0E0h,0FFh,01h,00h,00h,00h,01Bh,00h,03h,00h,00h,00h,00h,00h
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,01h,00h,01h,00h,027h,00h,08h,00h
    db 00h,00h,00h,00h,010h,00h,00h,00h,00h,00h,0F0h,0FFh,010h,00h,0F0h,0FFh
    db 00h,00h,0E0h,0FFh,010h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,010h,00h,0D0h,0FFh
    db 01h,00h,00h,00h,01Ah,00h,03h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh
    db 00h,00h,0E0h,0FFh,01h,00h,00h,00h,08Ch,00h,01h,00h,00h,00h,00h,00h
    db 01h,00h,00h,00h,08Bh,00h,01h,00h,00h,00h,00h,00h,01h,01h,01h,027h
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