; Link module 1. Module boundaries follow the original relocation order (see
; docs/executable-wrapping.md); names are modern and contents only partly understood.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn AttributePatchPointers:byte
extrn ByteAttributeTable:byte
extrn DifficultySetting:word
extrn FileBufferOffset:word
extrn FileBufferSegment:word
extrn FileByteCount:word
extrn FileHandle:word
extrn FileNamePtr:word
extrn FileStatus:word
extrn GridYSum:word
extrn HiscoreBlock:byte
extrn HiscoreFileName:byte
extrn InputBits:byte
extrn InputDeviceMode:word
extrn JoyButtonSelect:word
extrn JoyCalAbortSp:word
extrn JoyCalCenterX:word
extrn JoyCalCenterY:word
extrn JoyCalHighX:word
extrn JoyCalHighY:word
extrn JoyCalLowX:word
extrn JoyCalLowY:word
extrn JoyXHighThreshold:word
extrn JoyXLowThreshold:word
extrn JoyYHighThreshold:word
extrn JoyYLowThreshold:word
extrn KbdSavedInt09:byte
extrn KeyBitScancodesA:byte
extrn KeyBitScancodesB:byte
extrn KeyDownTable:byte
extrn KeyLastMakeCode:byte
extrn LevelIndex:word
extrn ModuleSoundEnabled:byte
extrn ModuleSoundRequest:byte
extrn MsgNotEnoughMemory:byte
extrn OpenResourceFile:far
extrn PlayfieldRowOffsets:word
extrn RecordRowOffsets:word
extrn SavedSettings:byte
extrn ScoreBcd:byte
extrn ScreenRowOffsets:word
extrn SfxEnabled:byte
extrn SoundModuleLoaded:byte
extrn SoundModuleSelect:byte
extrn SoundModuleTickEntry:far
extrn SoundOption:word
extrn SoundOptionFlags:byte
extrn StateData:byte
extrn TimerVectorInstalled:word
extrn VideoBiosModeTable:byte
extrn WideRowOffsets:word
extrn loc_0F953:far
extrn loc_0F9F9:far
extrn loc_10170:far
MAIN segment para public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public AllocateBuffers
public BlitPackedStride104Cga
public BlitPackedStride104Ega
public BlitPackedStride160Cga
public BlitPackedStride160Ega
public BlitPackedToScreenCga
public BlitPackedToScreenEga
public BuildByteToNibbleMaskTable
public BuildRowTables
public CalibrateJoystickWithAbort
public ClearByteCS066B
public ClearKeyDownTable
public ClearScreen104x200Cga
public ClearScreen104x200Ega
public ClearTandy104x200
public ComputeRecordGridOffset
public CopyPackedRowsStride104
public CopyPackedRowsStride160
public CopyPackedRowsToTandyBanks
public CopyWorkspace104x192ToTandy
public CopyWorkspaceToScreenCga
public CopyWorkspaceToScreenEga
public CountXReturn
public DrawOffsetFromPlayfieldRowCga
public DrawOffsetFromPlayfieldRowEga
public DrawOffsetFromScreenRowCga
public DrawOffsetFromScreenRowEga
public DrawOffsetFromWideRowCga
public DrawOffsetFromWideRowEga
public FlushBiosKeyboardBuffer
public InstallKeyboardVector09
public InstallTimerVector08
public LoadFileToBuffer
public LoadPackedFile
public LoadSettingsFromHiscoreBlock
public PackedDestOffset
public PackedDestSegment
public PackedNamePtr
public PackedOutputBytes
public PollInputBits
public ReadIndexedByteAttribute
public RestoreKeyboardVector09
public RestoreTimerVector08
public SaveHiscoreFile
public ShowFatalErrorAndExit
public TandyOffsetFromPlayfieldRow
public TandyOffsetFromScreenRow
public TandyOffsetFromWideRow
public UpdateHighScoreTable
public WaitByteCS066B
public WaitVerticalRetrace
public XorCodeHiscoreBlock
public loc_0073C
public loc_00747
public loc_0075F
public loc_007EF
public loc_00B3E
public loc_00CB8
public loc_00D42
public loc_00E9C
public loc_02580
public loc_027D9
public loc_02B84
public loc_02E2D
public loc_030D2
public loc_033AF
public loc_036A2
public loc_03824
public loc_041F5
public loc_0450C
public loc_048E6
public loc_04A41
public loc_04A65
public loc_04C76
public loc_04CED
public loc_04D64
public loc_04D95
public loc_04DBF
public loc_04F57
public loc_04FC3
public loc_04FF9
public loc_05059
public loc_0511F
public loc_05145
public loc_05160
public loc_0518C
public loc_0519A
public loc_0526A
extrn AttributeSourceSegment:word
extrn DrawOffsetFromScreenRow:near
extrn DrawPanelGraphic:near
extrn FindFreeRecordPoolA:near
extrn MainDataSegment:word
extrn PanelSegment:word
extrn PlayfieldRowBytes:word
extrn ScreenSegment:word
extrn SfxTimerTick:near
extrn ShutdownGame:near
extrn VideoAdapter:word
extrn WaitVerticalRetracePulse:near
extrn WideRowBytes:word
extrn WorkspaceSegment:word
extrn loc_0532D:near
extrn loc_05A36:near
extrn loc_05BAC:near
extrn loc_05BEE:near
extrn loc_05CB7:near
extrn loc_06176:near
extrn loc_077DF:near
extrn loc_0859E:near
extrn loc_0A781:near
extrn loc_0C57C:near
extrn loc_0C679:near
extrn loc_0CB1C:near
extrn loc_0CB3E:near
; UNKNOWN: not yet classified as code or data
    db 05h
; Esc during calibration jumps here from PollJoystickPrimaryOrAbort. Reloading the SP
; saved by CalibrateJoystickWithAbort makes the RET return straight to that routine's
; caller, discarding every nested frame, and input falls back to key table A.
AbortJoystickCalibration:
    mov sp, word ptr ds:[JoyCalAbortSp]
    mov byte ptr ds:[098BFh], 0
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_A
    ret

; Switch input to the joystick and calibrate it; Esc aborts via AbortJoystickCalibration.
; The roles of word DS:0014 and byte DS:98BF are unknown.
CalibrateJoystickWithAbort:
    mov word ptr ds:[JoyCalAbortSp], sp
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    mov word ptr ds:[014h], 1
    call CalibrateJoystickThresholds
    mov word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    mov byte ptr ds:[098BFh], 0
    ret

; Take three stick samples, each after the primary button is released and pressed again,
; and derive the four thresholds as unsigned midpoints: LOW/CENTER and CENTER/HIGH.
; Sample names follow that arithmetic only. 0F7F:0980 and DrawPanelGraphic (probably the prompts)
; are unreviewed.
CalibrateJoystickThresholds:
    mov word ptr ds:[JoyButtonSelect], JOY_BUTTONS_PORT_A
    mov byte ptr ds:[098BFh], 0
    mov ax, 0BEBEh
    call far ptr loc_10170
    call WaitJoystickPrimaryRelease
@@wait_low_press:
    call PollJoystickPrimaryOrAbort
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@wait_low_press
    call ReadGamePortAAxisCounts
    mov word ptr ds:[JoyCalLowX], bx
    mov word ptr ds:[JoyCalLowY], cx
    call WaitJoystickPrimaryRelease
    mov ah, 055h
    mov al, 1
    mov si, 04Eh
    call DrawPanelGraphic
@@wait_high_press:
    call PollJoystickPrimaryOrAbort
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@wait_high_press
    call ReadGamePortAAxisCounts
    mov word ptr ds:[JoyCalHighX], bx
    mov word ptr ds:[JoyCalHighY], cx
    call WaitJoystickPrimaryRelease
    mov ah, 07Dh
    mov al, 1
    mov si, 04Fh
    call DrawPanelGraphic
@@wait_center_press:
    call PollJoystickPrimaryOrAbort
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne @@wait_center_press
    call ReadGamePortAAxisCounts
    mov word ptr ds:[JoyCalCenterX], bx
    mov word ptr ds:[JoyCalCenterY], cx
    mov bx, word ptr ds:[JoyCalHighX]
    sub bx, word ptr ds:[JoyCalCenterX]
    shr bx, 1
    add bx, word ptr ds:[JoyCalCenterX]
    mov word ptr ds:[JoyXHighThreshold], bx
    mov bx, word ptr ds:[JoyCalCenterX]
    sub bx, word ptr ds:[JoyCalLowX]
    shr bx, 1
    add bx, word ptr ds:[JoyCalLowX]
    mov word ptr ds:[JoyXLowThreshold], bx
    mov bx, word ptr ds:[JoyCalHighY]
    sub bx, word ptr ds:[JoyCalCenterY]
    shr bx, 1
    add bx, word ptr ds:[JoyCalCenterY]
    mov word ptr ds:[JoyYHighThreshold], bx
    mov bx, word ptr ds:[JoyCalCenterY]
    sub bx, word ptr ds:[JoyCalLowY]
    shr bx, 1
    add bx, word ptr ds:[JoyCalLowY]
    mov word ptr ds:[JoyYLowThreshold], bx
    ret

; Fire the game-port one-shots and count, with interrupts off, how many reads each
; joystick-A axis bit stays set: BX = X, CX = Y. Gives up after 15536 reads.
; Always returns with interrupts enabled.
ReadGamePortAAxisCounts:
    xor bx, bx
    mov cx, bx
    mov si, 0C350h
    mov dx, GAME_PORT
    cli
    out dx, al
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
@@count_axis_bits:
    in al, dx
    and ax, GAME_PORT_A_AXES
    je @@done
    rcr ax, 1
    adc bx, 0
    add cx, ax
    inc si
    jne @@count_axis_bits
@@done:
    sti
    ret

; One calibration poll: abort if Esc is held, otherwise read the stick and keep only
; the primary button bit in InputBits. All registers, including DS, are preserved.
PollJoystickPrimaryOrAbort:
    cmp byte ptr ds:[KeyDownTable + SCAN_ESC], KEY_STATE_DOWN
    jne @@poll
    jmp near ptr AbortJoystickCalibration
@@poll:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
    call PollJoystickInputBits
    and byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Wait until the joystick primary button is released, then pause for 25 calls of WaitVerticalRetrace.
WaitJoystickPrimaryRelease:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
@@wait_release:
    call PollJoystickInputBits
    and byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je @@wait_release
    mov cx, 019h
@@delay:
    push cx
    call WaitVerticalRetrace
    pop cx
    loop @@delay
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Rebuild InputBits from the selected device. Keyboard: the eight scancodes of key
; table A (or B in mode 2) give bits 7..0, then Tab, Space and the arrow keys are ORed
; in. Joystick mode tail-jumps to PollJoystickInputBits, which leaves DS changed.
PollInputBits:
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_JOYSTICK
    je PollJoystickInputBits
    mov cx, KEY_BIT_SCANCODE_COUNT
    xor bx, bx
    mov si, offset KeyBitScancodesA
    cmp word ptr ds:[InputDeviceMode], INPUT_MODE_KEYS_B
    jne @@have_table
    mov si, offset KeyBitScancodesB
@@have_table:
    mov di, offset KeyDownTable
@@collect_table_key:
    mov bl, byte ptr ds:[si]
    mov al, byte ptr ds:[bx + di]
    shr al, 1
    rcl byte ptr ds:[InputBits],1
    inc si
    loop @@collect_table_key
    cmp byte ptr ds:[di + SCAN_TAB], KEY_STATE_UP
    je @@check_space
    or byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
@@check_space:
    cmp byte ptr ds:[di + SCAN_SPACE], KEY_STATE_UP
    je @@check_up
    or byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
@@check_up:
    cmp byte ptr ds:[di + SCAN_UP], KEY_STATE_UP
    je @@check_down
    or byte ptr ds:[InputBits], IN_YMINUS
@@check_down:
    cmp byte ptr ds:[di + SCAN_DOWN], KEY_STATE_UP
    je @@check_left
    or byte ptr ds:[InputBits], IN_YPLUS
@@check_left:
    cmp byte ptr ds:[di + SCAN_LEFT], KEY_STATE_UP
    je @@check_right
    or byte ptr ds:[InputBits], IN_XMINUS
@@check_right:
    cmp byte ptr ds:[di + SCAN_RIGHT], KEY_STATE_UP
    je @@done
    or byte ptr ds:[InputBits], IN_XPLUS
@@done:
    ret

; Rebuild InputBits from game port A against the calibration thresholds. Loads DS with
; the state segment and does not restore it. Buttons read 0 while pressed. The port-B
; button masks are unreachable: JoyButtonSelect is set to port A just before the test.
PollJoystickInputBits:
    mov ax, seg StateData
    mov ds, ax
    mov byte ptr ds:[InputBits], 0
    mov word ptr ds:[JoyButtonSelect], JOY_BUTTONS_PORT_A
    call ReadGamePortAAxisCounts
    mov si, bx
    cmp si, word ptr ds:[JoyXLowThreshold]
    jae @@check_x_high
    or byte ptr ds:[InputBits], IN_XMINUS
@@check_x_high:
    cmp si, word ptr ds:[JoyXHighThreshold]
    jbe @@read_y
    or byte ptr ds:[InputBits], IN_XPLUS
@@read_y:
    call ReadGamePortAAxisCounts
    mov si, cx
    cmp si, word ptr ds:[JoyYLowThreshold]
    jae @@check_y_high
    or byte ptr ds:[InputBits], IN_YMINUS
@@check_y_high:
    cmp si, word ptr ds:[JoyYHighThreshold]
    jbe @@read_buttons
    or byte ptr ds:[InputBits], IN_YPLUS
@@read_buttons:
    mov dx, GAME_PORT
    in al, dx
    cmp word ptr ds:[JoyButtonSelect], JOY_BUTTONS_PORT_A
    mov cl, GAME_PORT_A_BUTTON2
    mov ch, GAME_PORT_A_BUTTON1
    je @@test_button2
    mov cl, GAME_PORT_B_BUTTON2
    mov ch, GAME_PORT_B_BUTTON1
@@test_button2:
    test al, cl
    jne @@test_button1
    or byte ptr ds:[InputBits], IN_BUTTON_SECONDARY
@@test_button1:
    test al, ch
    jne @@done
    or byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
@@done:
    ret
; LoadPackedFile state (CS-resident; the loader runs with DS=CS).
PackedDestSegment dw 0 ; PackedDestSegment
PackedDestOffset dw 0 ; PackedDestOffset
PackedNamePtr dw 0 ; PackedNamePtr
PackedFileHandle dw 0 ; PackedFileHandle
PackedUnwindSp dw 0 ; PackedUnwindSp
PackedOutputBytes dw 0 ; PackedOutputBytes
PackedOpenFailed dw 0 ; PackedOpenFailed


; Open the packed file PackedNamePtr (through the resource container) and decode it
; to PackedDestSegment:PackedDestOffset; PackedOutputBytes counts the output. The
; first byte selects the format: 0 byte escape-RLE, 1 word escape-RLE, 2 dword
; escape-RLE, 3 PackBits (80h ends), 4 PackBits by columns. Success returns CF=0; any
; failure reloads the entry SP (PackedUnwindSp) and returns CF=1 straight to the
; caller. Short reads are not detected: the stream terminator stops decoding.
LoadPackedFile:
    mov ax, cs
    mov ds, ax
    mov word ptr ds:[PackedOutputBytes], 0
    mov word ptr ds:[PackedUnwindSp], sp
    mov word ptr ds:[PackedReadCursor], offset PackedReadBuffer + PACKED_READ_BUFFER_BYTES
    push ds
    mov dx, word ptr ds:[PackedNamePtr]
    mov ax, seg StateData
    mov ds, ax
    mov al, 0
    mov ah, 03Dh
    call far ptr OpenResourceFile
    pop ds
    mov word ptr cs:[PackedOpenFailed], 1
    jb UnwindPackedLoad
    mov word ptr cs:[PackedOpenFailed], 0
    mov word ptr ds:[PackedFileHandle], ax
    call ReadBufferedByte
    or al, al
    je DecodeByteEscapeRle
    dec al
    je DecodeWordEscapeRle
    dec al
    jne @@try_mode3
    jmp near ptr DecodeDwordEscapeRle
@@try_mode3:
    dec al
    jne @@try_mode4
    jmp near ptr DecodePackBitsStream
@@try_mode4:
    dec al
    jne @@bad_mode
    jmp near ptr DecodeColumnPackBits
@@bad_mode:
    mov ax, 0FFFFh
    jmp short FailPackedLoad
FinishPackedLoad:
    call ClosePackedFile
    mov ds, word ptr cs:[MainDataSegment]
    clc
    ret
FailPackedLoad:
    push ax
    call ClosePackedFile
    pop ax
UnwindPackedLoad:
    mov bx, seg StateData
    mov ds, bx
    mov sp, word ptr cs:[PackedUnwindSp]
    stc
    ret
DecodeByteEscapeRle:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedByte
    mov bl, al
@@next:
    call ReadBufferedByte
    cmp al, bl
    je @@escape
    stosb
    inc word ptr ds:[PackedOutputBytes]
    jmp short @@next
@@escape:
    call ReadBufferedByte
    mov cl, al
    xor ch, ch
    jcxz FinishPackedLoad
    call ReadBufferedByte
    add word ptr ds:[PackedOutputBytes], cx
    rep stosb
    jmp short @@next
DecodeWordEscapeRle:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedWordLE
    mov bx, ax
@@next:
    call ReadBufferedWordLE
    cmp ax, bx
    je @@escape
    stosw
    add word ptr ds:[PackedOutputBytes], 2
    jmp short @@next
@@escape:
    call ReadBufferedWordLE
    mov cx, ax
    jcxz FinishPackedLoad
    call ReadBufferedWordLE
    add word ptr ds:[PackedOutputBytes], cx
    add word ptr ds:[PackedOutputBytes], cx
    rep stosw
    jmp short @@next
DecodeDwordEscapeRle:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedWordLE
    mov bx, ax
@@next:
    call ReadBufferedWordLE
    cmp ax, bx
    je @@escape
    stosw
    call ReadBufferedWordLE
    stosw
    add word ptr ds:[PackedOutputBytes], 4
    jmp short @@next
@@escape:
    call ReadBufferedWordLE
    mov cx, ax
    jcxz @@finish
    jmp short @@run
@@finish:
    jmp near ptr FinishPackedLoad
@@run:
    call ReadBufferedWordLE
    push ax
    call ReadBufferedWordLE
    mov dx, ax
    pop ax
@@store_run:
    stosw
    xchg ax, dx
    stosw
    add word ptr ds:[PackedOutputBytes], 4
    xchg ax, dx
    loop @@store_run
    jmp short @@next
DecodePackBitsStream:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
@@next_control:
    call ReadBufferedByte
    cmp al, 080h
    jne @@not_end
    jmp near ptr FinishPackedLoad
@@not_end:
    jb @@copy_literal
    neg al
    xchg ah, al
    xchg bl, ah
    call ReadBufferedByte
    xchg bl, ah
@@store_run:
    stosb
    inc word ptr ds:[PackedOutputBytes]
    dec ah
    jns @@store_run
    jmp short @@next_control
@@copy_literal:
    push ax
    call ReadBufferedByte
    stosb
    inc word ptr ds:[PackedOutputBytes]
    pop ax
    dec al
    jns @@copy_literal
    jmp short @@next_control
; UNKNOWN: not yet classified as code or data
    db 090h
; DecodeColumnPackBits header: only the width word is ever read.
PackedColumnHeader0 dw 0 ; PackedColumnHeader0
PackedColumnWidth dw 0 ; PackedColumnWidth
PackedColumnHeader2 dw 0 ; PackedColumnHeader2

DecodeColumnPackBits:
    mov es, word ptr ds:[PackedDestSegment]
    mov di, word ptr ds:[PackedDestOffset]
    call ReadBufferedWordLE
    mov word ptr cs:[PackedColumnHeader0], ax
    call ReadBufferedWordLE
    mov word ptr ds:[PackedColumnWidth], ax
    call ReadBufferedWordLE
    mov word ptr ds:[PackedColumnHeader2], ax
    mov cx, word ptr cs:[PackedColumnWidth]
@@next_column:
    push cx
    push di
@@next_control:
    call ReadBufferedByte
    cmp al, 080h
    je @@column_done
    jb @@copy_literal
    neg al
    xchg ah, al
    xchg bl, ah
    call ReadBufferedByte
    xchg bl, ah
@@store_run:
    mov byte ptr es:[di], al
    add di, word ptr cs:[PackedColumnWidth]
    inc word ptr ds:[PackedOutputBytes]
    dec ah
    jns @@store_run
    jmp short @@next_control
@@copy_literal:
    push ax
    call ReadBufferedByte
    mov byte ptr es:[di], al
    add di, word ptr cs:[PackedColumnWidth]
    inc word ptr ds:[PackedOutputBytes]
    pop ax
    dec al
    jns @@copy_literal
    jmp short @@next_control
@@column_done:
    pop di
    inc di
    pop cx
    loop @@next_column
    jmp near ptr FinishPackedLoad
; UNKNOWN: not yet classified as code or data
    db 090h
; ReadBufferedByte state: a 512-byte read buffer, its cursor, the caller's BX and
; the low-byte scratch of ReadBufferedWordLE.
PackedReadBuffer db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
PackedReadCursor dw 0 ; PackedReadCursor
PackedSavedBx dw 0 ; PackedSavedBx
PackedWordLow db 0 ; PackedWordLow

; Call ReadBufferedByte twice; first byte saved in DS:0614, second becomes AH and saved
; first becomes AL. Shares scratch and inherits nonlocal error unwind from callee.
ReadBufferedWordLE:
    call ReadBufferedByte
    mov byte ptr ds:[PackedWordLow], al
    call ReadBufferedByte
    mov ah, al
    mov al, byte ptr ds:[PackedWordLow]
    ret
; Save BX at DS:0612; cursor DS:0610. If cursor >=0610h, reset to0410h and request512 bytes
; via DOS AH=3F, handle DS:0240. Return byte in AL, advance cursor, restore BX. DOS failure
; branches to02B2 which restores SP from CS:0242. Short reads are not checked here.
ReadBufferedByte:
    mov word ptr ds:[PackedSavedBx], bx
    mov bx, word ptr ds:[PackedReadCursor]
    cmp bx, offset PackedReadBuffer + PACKED_READ_BUFFER_BYTES
    jb @@take_byte
    mov word ptr ds:[PackedReadCursor], offset PackedReadBuffer
    push cx
    mov ah, DOS_READ_FILE
    mov bx, word ptr ds:[PackedFileHandle]
    mov cx, PACKED_READ_BUFFER_BYTES
    mov dx, offset PackedReadBuffer
    int 021h
    pop cx
    jae @@refilled
    jmp near ptr FailPackedLoad
@@refilled:
    mov bx, word ptr ds:[PackedReadCursor]
@@take_byte:
    mov al, byte ptr ds:[bx]
    inc word ptr ds:[PackedReadCursor]
    mov bx, word ptr ds:[PackedSavedBx]
    ret

ClosePackedFile:
    mov bx, word ptr cs:[PackedFileHandle]
    mov ah, DOS_CLOSE_FILE
    int 021h
    jae @@closed
    jmp near ptr FailPackedLoad
@@closed:
    ret
; UNKNOWN: not yet classified as code or data
    db 00h
; Increment byte CS:066B modulo 256; INC preserves incoming CF. Near return.
IncrementByteCS066B:
    inc byte ptr cs:[066Bh]
    ret
; ClearByteCS066B
; Write zero to CS:066B. Registers and flags unchanged; near return.
ClearByteCS066B:
    mov byte ptr cs:[066Bh], 0
    ret
; Poll CS:066B until nonzero. Requires asynchronous mutation to terminate from zero; near
; return leaves CMP flags.
WaitByteCS066B:
    cmp byte ptr cs:[066Bh], 0
    je WaitByteCS066B
    ret
; Once only: save the BIOS INT 08h vector in SavedInt08, speed the system timer up to
; TIMER_DIVISOR (about 72.8 Hz) and install Interrupt08Handler.
InstallTimerVector08:
    cmp word ptr ds:[TimerVectorInstalled], 1
    jne @@install
    ret
@@install:
    cli
    push es
    mov ax, DOS_GET_VECTOR*256 + 08h
    int 021h
    mov di, offset SavedInt08
    mov word ptr cs:[di], bx
    mov word ptr cs:[di + 2], es
    pop es
    mov al, PIT_CH0_SQUARE_WAVE
    out PIT_COMMAND_PORT, al
    xor al, al
    out PIT_CHANNEL0_PORT, al
    mov al, high TIMER_DIVISOR
    out PIT_CHANNEL0_PORT, al
    push ds
    push cs
    pop ds
    mov dx, 06E5h
    mov ax, DOS_SET_VECTOR*256 + 08h
    int 021h
    pop ds
    sti
    mov word ptr ds:[TimerVectorInstalled], 1
    ret

; Undo InstallTimerVector08: restore the saved INT 08h vector, the standard timer
; rate (divisor 0 = 65536) and silence the speaker.
RestoreTimerVector08:
    cmp word ptr ds:[TimerVectorInstalled], 0
    jne @@restore
    ret
@@restore:
    cli
    push ds
    lds dx, dword ptr cs:[SavedInt08]
    mov ax, DOS_SET_VECTOR*256 + 08h
    int 021h
    pop ds
    mov al, PIT_CH0_SQUARE_WAVE
    out PIT_COMMAND_PORT, al
    xor al, al
    out PIT_CHANNEL0_PORT, al
    out PIT_CHANNEL0_PORT, al
    sti
    in al, PPI_PORT_B
    and al, PPI_SPEAKER_OFF_MASK
    out PPI_PORT_B, al
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h
; Interrupt08Handler
; Entry installed by InstallTimerVector08. Calls counter/music helpers and can chain a
; previous vector; inspect full CFG and unresolved far calls before changing it.
    push ax
    push ds
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    mov ds, word ptr cs:[MainDataSegment]
    cmp byte ptr ds:[SoundModuleLoaded], 1
    jne loc_00704
    call far ptr SoundModuleTickEntry
    mov ds, word ptr cs:[MainDataSegment]
loc_00704:
    call SfxTimerTick
    mov ds, word ptr cs:[MainDataSegment]
    test byte ptr ds:[054h], 1
    jne loc_00716
    call IncrementByteCS066B
loc_00716:
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    inc byte ptr ds:[054h]
    and byte ptr ds:[054h], 3
    je loc_0072F
    pop ds
    mov al, 020h
    out 020h, al
    pop ax
    iret
loc_0072F:
    pop ds
    pop ax
    sti
    jmp dword ptr cs:[SavedInt08]
; UNKNOWN: not yet classified as code or data
    db 090h
; Far pointer (offset, segment) to the BIOS INT 08h handler, saved by InstallTimerVector08,
; restored by RestoreTimerVector08 and chained by Interrupt08Handler.
SavedInt08 db 00h,00h,00h,00h

loc_0073C:
    cmp byte ptr ds:[KeyDownTable + SCAN_F9], KEY_STATE_DOWN
    je loc_00744
    ret
loc_00744:
    call loc_0075F

loc_00747:
    call loc_007EF
    cmp word ptr ds:[0BDACh], 1
    jne loc_00752
    ret
loc_00752:
    call loc_06176
    call loc_077DF
    call loc_0859E
    call loc_0C57C
    ret

loc_0075F:
    call loc_0CB3E
    mov ax, 3
    int 010h
    mov ds, word ptr cs:[MainDataSegment]
    mov ax, 0B800h
    mov es, ax
    xor di, di
    mov si, 056h
    call loc_00854
    mov di, 1
    mov al, 0Ch
    call loc_0084C
    mov al, 0Eh
    mov cx, 01E0h
    call loc_0084F
    mov cx, 0Fh
loc_0078C:
    push cx
    mov al, 0Eh
    mov cx, 1
    call loc_0084F
    mov al, 7
    mov cx, 04Fh
    call loc_0084F
    pop cx
    loop loc_0078C
    mov al, 01Eh
    call loc_0084C
    mov al, 01Eh
    call loc_0084C
    mov di, 0731h
    mov al, 071h
    mov cx, 0Dh
    call loc_0084F
    mov dl, 047h
    mov dh, 017h
    mov ah, 2
    mov bh, 0
    int 010h
    mov ds, word ptr cs:[MainDataSegment]
loc_007C4:
    cmp byte ptr ds:[KeyDownTable + SCAN_F9], KEY_STATE_DOWN
    je loc_007C4
    mov byte ptr ds:[KeyLastMakeCode], 0
loc_007D0:
    cmp byte ptr ds:[KeyLastMakeCode], 0
    je loc_007D0
loc_007D7:
    cmp byte ptr ds:[KeyDownTable + SCAN_F9], KEY_STATE_DOWN
    je loc_007D7
    mov ax, word ptr cs:[VideoAdapter]
    mov bx, offset VideoBiosModeTable
    xlat
    int 010h
    mov al, byte ptr ds:[ModuleSoundRequest]
    call loc_0CB1C
    ret

loc_007EF:
    call loc_05145
    mov ax, 01Bh
    call DrawOffsetFromScreenRow
    mov si, 025h
    shl si, 1
    add si, 0BE4h
    mov si, word ptr cs:[si]
    mov ds, word ptr cs:[PanelSegment]
    lodsw
    mov word ptr cs:[058FDh], ax
    lodsw
    mov word ptr cs:[058FFh], ax
    mov word ptr cs:[058FBh], si
    mov word ptr cs:[058F9h], di
    mov word ptr cs:[05905h], 0
    mov word ptr cs:[05907h], 0
    mov word ptr cs:[05901h], 0C6h
    mov es, word ptr cs:[ScreenSegment]
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    call word ptr cs:[bx + 0595Ah]
    mov ds, word ptr cs:[MainDataSegment]
    call loc_05CB7
    ret

loc_0084C:
    mov cx, 050h

loc_0084F:
    stosb
    inc di
    loop loc_0084F
    ret

loc_00854:
    mov cx, 07D0h
    rep movsw
    ret
; Text mode, print MsgNotEnoughMemory, pause 200 frames and leave through ShutdownGame.
ShowOutOfMemoryAndExit:
    mov ax, 3
    int 010h
    mov dx, offset MsgNotEnoughMemory
    mov ah, DOS_PRINT_STRING
    int 021h
    mov cx, 0C8h
@@delay:
    call WaitVerticalRetrace
    loop @@delay
    jmp near ptr ShutdownGame
; Jump target, DX = $-terminated message: switch to text mode, print it, pause
; 200 ticks of WaitVerticalRetrace and leave through ShutdownGame.
ShowFatalErrorAndExit:
    push dx
    mov ax, 3
    int 010h
    pop dx
    mov ah, DOS_PRINT_STRING
    int 021h
    mov cx, 0C8h
@@delay:
    call WaitVerticalRetrace
    loop @@delay
    jmp near ptr ShutdownGame
; Running total of paragraphs requested by AllocateBuffers.
AllocatedParagraphs dw 00000h

; Copy the current adapter's geometry table to DS:1024, set ScreenSegment from it and
; allocate the game's buffers through DOS; any failure ends in ShowOutOfMemoryAndExit.
AllocateBuffers:
    mov word ptr cs:[AllocatedParagraphs], 0
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[MainDataSegment]
    mov si, word ptr cs:[VideoAdapter]
    shl si, 1
    add si, 0116Eh
    mov si, word ptr ds:[si]
    mov di, 01024h
    mov cx, 027h
    rep movsw
    lodsw
    mov word ptr cs:[PlayfieldRowBytes], ax
    lodsw
    mov word ptr cs:[WideRowBytes], ax
    lodsw
    mov word ptr cs:[ScreenSegment], ax
    mov cx, 010h
    mov ax, word ptr cs:[PlayfieldRowBytes]
    mul cx
    mov word ptr cs:[095A2h], ax
    mov word ptr cs:[095BEh], ax
    mov bx, ax
    mov cx, 0Dh
    mul cx
    mov word ptr cs:[095C2h], ax
    add ax, bx
    mov word ptr cs:[095C0h], ax
    mov bx, 01000h
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_008F1
    jmp near ptr ShowOutOfMemoryAndExit
loc_008F1:
    mov word ptr cs:[WorkspaceSegment], ax
    mov ax, 075h
    mul word ptr ds:[01024h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00915
    jmp near ptr ShowOutOfMemoryAndExit
loc_00915:
    mov word ptr cs:[095A8h], ax
    mov ax, 0FFh
    mul word ptr ds:[01026h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00939
    jmp near ptr ShowOutOfMemoryAndExit
loc_00939:
    mov word ptr cs:[095AAh], ax
    mov ax, 082h
    mul word ptr ds:[01026h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_0095D
    jmp near ptr ShowOutOfMemoryAndExit
loc_0095D:
    mov word ptr cs:[095ACh], ax
    mov ax, 0Dh
    mul word ptr ds:[01028h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00981
    jmp near ptr ShowOutOfMemoryAndExit
loc_00981:
    mov word ptr cs:[095AEh], ax
    mov ax, 01Ch
    mul word ptr ds:[01028h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_009A5
    jmp near ptr ShowOutOfMemoryAndExit
loc_009A5:
    mov word ptr cs:[095A6h], ax
    mov ax, word ptr ds:[0102Ch]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_009C5
    jmp near ptr ShowOutOfMemoryAndExit
loc_009C5:
    mov word ptr cs:[095B2h], ax
    mov bx, word ptr ds:[0102Eh]
    mov ax, 010h
    mul word ptr ds:[01030h]
    add bx, ax
    mov ax, 8
    mul word ptr ds:[01032h]
    add bx, ax
    mov ax, 7
    mul word ptr ds:[01034h]
    add bx, ax
    mov ax, 6
    mul word ptr ds:[01036h]
    add bx, ax
    mov ax, 4
    mul word ptr ds:[01038h]
    add bx, ax
    mov ax, 4
    mul word ptr ds:[0103Ah]
    add bx, ax
    mov ax, 012h
    mul word ptr ds:[0103Ch]
    add bx, ax
    mov ax, word ptr ds:[01058h]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[0105Ah]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[0105Ch]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[0105Eh]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[01060h]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[01062h]
    shl ax, 1
    add bx, ax
    mov ax, word ptr ds:[01064h]
    shl ax, 1
    add bx, ax
    add bx, word ptr ds:[01066h]
    add bx, word ptr ds:[01068h]
    mov ax, word ptr ds:[0106Ah]
    shl ax, 1
    add bx, ax
    shl ax, 1
    add bx, ax
    add bx, word ptr ds:[0106Ch]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00A6B
    jmp near ptr ShowOutOfMemoryAndExit
loc_00A6B:
    mov word ptr cs:[PanelSegment], ax
    mov bx, word ptr ds:[0106Eh]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00A8A
    jmp near ptr ShowOutOfMemoryAndExit
loc_00A8A:
    mov word ptr cs:[095B6h], ax
    mov bx, word ptr ds:[0103Eh]
    add bx, word ptr ds:[01040h]
    add bx, word ptr ds:[01042h]
    add bx, word ptr ds:[01044h]
    add bx, word ptr ds:[01046h]
    add bx, word ptr ds:[01048h]
    add bx, word ptr ds:[0104Ah]
    add bx, word ptr ds:[0104Ch]
    add bx, word ptr ds:[0104Eh]
    add bx, word ptr ds:[01050h]
    add bx, word ptr ds:[01050h]
    add bx, word ptr ds:[01050h]
    add bx, word ptr ds:[01052h]
    add bx, word ptr ds:[01052h]
    add bx, word ptr ds:[01052h]
    add bx, word ptr ds:[01054h]
    add bx, word ptr ds:[01054h]
    add bx, word ptr ds:[01054h]
    add bx, word ptr ds:[01056h]
    shr bx, 1
    shr bx, 1
    shr bx, 1
    shr bx, 1
    inc bx
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00AF1
    jmp near ptr ShowOutOfMemoryAndExit
loc_00AF1:
    mov word ptr cs:[095B8h], ax
    mov ax, 0100h
    mul word ptr ds:[01070h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00B15
    jmp near ptr ShowOutOfMemoryAndExit
loc_00B15:
    mov word ptr cs:[0959Ah], ax
    mov ax, 02Ch
    mul word ptr ds:[01070h]
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    inc ax
    mov bx, ax
    add word ptr cs:[AllocatedParagraphs], bx
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    jae loc_00B39
    jmp near ptr ShowOutOfMemoryAndExit
loc_00B39:
    mov word ptr cs:[0959Ch], ax
    ret

loc_00B3E:
    mov word ptr ds:[0C5F5h], 0C85Ch
    mov word ptr ds:[0C5F7h], 0C8D6h
    mov word ptr ds:[0C5F9h], 0CA02h
    mov word ptr ds:[0C5FBh], 0CC36h
    mov word ptr ds:[0C5FDh], 0CC80h
    mov word ptr ds:[0C5FFh], 0CCAAh
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    add bx, 014C0h
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[FileNamePtr], bx
    mov ax, word ptr cs:[09592h]
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
loc_00B7F:
    call loc_0C679
    cmp word ptr ds:[FileStatus], FILE_STATUS_OK
    je InitializeByteAttributes
    call PromptLoadErrorWaitFire
    jmp short loc_00B7F
; Initialize shared byte attributes to 1, then apply a selected sparse patch stream.
; ES uses MainDataSegment for fill; DS addresses the patch stream and table writes.
; Forward traversal requires DF=0; do not infer the selector range from this loop.
InitializeByteAttributes:
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset ByteAttributeTable
    push di
    mov cx, BYTE_ATTRIBUTE_COUNT
    mov al, 1
    rep stosb
    pop di
    mov si, word ptr ds:[LevelIndex]
    shl si, 1
    add si, offset AttributePatchPointers
    mov si, word ptr ds:[si]
; Each patch is index,value; FF terminates before a value is read.
; Consequently entry FF is not patched by this format.
ReadAttributePatchIndex:
    lodsb
    cmp al, ATTRIBUTE_PATCH_END
    je AttributePatchesDone
    xor ah, ah
    mov bx, ax
    lodsb
    mov byte ptr ds:[bx + di], al
    jmp short ReadAttributePatchIndex
AttributePatchesDone:
    mov es, word ptr cs:[AttributeSourceSegment]
    xor di, di
    mov cx, 01Ah
    mov al, 1
    rep stosb
    mov di, 0E5Fh
    mov si, 0D1BCh
    mov cx, 041h
    rep movsb
    jmp near ptr ClearKeyDownTable
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
    db 00h,00h,00h

loc_00CB8:
    mov word ptr cs:[0BD6h], 0
    mov word ptr cs:[0BD8h], 1
    jmp short loc_00CF6

loc_00CC8:
    mov word ptr cs:[0BD6h], 0
    mov word ptr cs:[0BD8h], 0
    jmp short loc_00CF6

loc_00CD8:
    mov word ptr cs:[0BD6h], 1
    mov word ptr cs:[0BD8h], 0
    jmp short loc_00CF6
; UNKNOWN: not yet classified as code or data
    db 02Eh,0C7h,06h,0D6h,0Bh,01h,00h,02Eh,0C7h,06h,0D8h,0Bh,01h,00h
loc_00CF6:
    call loc_0526A
    mov ax, word ptr cs:[WorkspaceSegment]
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
    mov ax, word ptr cs:[0BDEh]
    mov word ptr ds:[FileNamePtr], ax
    push ax
loc_00D0E:
    call loc_0C679
    cmp word ptr ds:[FileStatus], FILE_STATUS_OK
    je loc_00D1D
    call PromptLoadErrorWaitFire
    jmp short loc_00D0E
loc_00D1D:
    pop bp
    dec bp
    dec bp
    mov bp, word ptr ss:[bp]
    cmp byte ptr cs:[0C5B0h], 1
    je loc_00D2E
    mov bp, 0FFFFh
loc_00D2E:
    mov ds, word ptr cs:[WorkspaceSegment]
    mov es, word ptr cs:[0BDCh]
    mov di, word ptr cs:[0BDAh]
    xor si, si
    jmp near ptr loc_05BAC

loc_00D42:
    mov word ptr cs:[0BDEh], 01298h
    mov ax, word ptr cs:[095A8h]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012A4h
    mov ax, word ptr cs:[095AAh]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012B0h
    mov ax, word ptr cs:[095ACh]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012BDh
    mov ax, word ptr cs:[095A6h]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov word ptr cs:[0BDEh], 012DAh
    mov ax, word ptr cs:[095B2h]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0BE4h
    call loc_00CB8
    mov word ptr cs:[0BDEh], 012E8h
    mov ax, word ptr cs:[PanelSegment]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0BE4h
    mov byte ptr ds:[0BB84h], 1
    call loc_00CB8
    mov byte ptr ds:[0BB84h], 0
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    jne loc_00DE3
    mov es, word ptr cs:[PanelSegment]
    xor di, di
    mov ax, 0Fh
    mul word ptr ds:[01030h]
    mov cx, ax
    mov si, 01C16h
    rep movsb
loc_00DE3:
    mov word ptr cs:[0BDEh], 01303h
    mov ax, word ptr cs:[095B8h]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0C92h
    call loc_00CB8
    mov word ptr cs:[0BDEh], 012F6h
    mov ax, word ptr cs:[0959Ch]
    mov word ptr cs:[0BDCh], ax
    call loc_00CC8
    ret

; Read the whole file named by FileNamePtr into FileBufferSegment:FileBufferOffset.
; Callers must test FileStatus: DOS errors return early through UnwindFileError, and a
; failed read leaves the handle open.
LoadFileToBuffer:
    mov word ptr ds:[FileStatus], FILE_STATUS_OK
    call OpenFileForRead
    call ReadFileToBuffer
    jmp short CloseFileAndReturn

; Create the file named by FileNamePtr and write FileByteCount bytes from the buffer.
; Errors return early through UnwindFileError without setting FileStatus; a short write
; is not detected.
SaveBufferToFile:
    call CreateFileForWrite
    call WriteBufferToFile
CloseFileAndReturn:
    call CloseFileHandle
    ret

; DOS create; on error return from the enclosing load/save call (UnwindFileError).
CreateFileForWrite:
    mov dx, word ptr ds:[FileNamePtr]
    xor cx, cx
    mov al, 2
    mov ah, DOS_CREATE_FILE
    int 021h
    jb UnwindFileError
    mov word ptr ds:[FileHandle], ax
    ret

; DOS open for reading; on error set FileStatus and return from the enclosing load call.
OpenFileForRead:
    mov dx, word ptr ds:[FileNamePtr]
    xor al, al
    mov ah, DOS_OPEN_FILE
    int 021h
    jb @@open_failed
    mov word ptr ds:[FileHandle], ax
    ret
@@open_failed:
    mov word ptr ds:[FileStatus], FILE_STATUS_OPEN_FAILED
    jmp short UnwindFileError

; DOS write of FileByteCount bytes; on error return from the enclosing save call.
WriteBufferToFile:
    mov ax, word ptr ds:[FileBufferSegment]
    mov bx, word ptr ds:[FileHandle]
    mov cx, word ptr ds:[FileByteCount]
    mov dx, word ptr ds:[FileBufferOffset]
    push ds
    mov ds, ax
    mov ah, DOS_WRITE_FILE
    int 021h
    pop ds
    jb UnwindFileError
    ret
UnwindFileError:
    pop ax
    ret

; DOS read of up to FFFFh bytes, storing the count read; on error set FileStatus and
; return from the enclosing load call.
ReadFileToBuffer:
    mov ax, word ptr ds:[FileBufferSegment]
    mov bx, word ptr ds:[FileHandle]
    mov cx, 0FFFFh
    mov dx, word ptr ds:[FileBufferOffset]
    push ds
    mov ds, ax
    mov ah, DOS_READ_FILE
    int 021h
    pop ds
    jb @@read_failed
    mov word ptr ds:[FileByteCount], ax
    ret
@@read_failed:
    mov word ptr ds:[FileStatus], FILE_STATUS_READ_FAILED
    jmp short UnwindFileError

; DOS close of FileHandle.
CloseFileHandle:
    mov bx, word ptr ds:[FileHandle]
    mov ah, DOS_CLOSE_FILE
    int 021h
    jb UnwindFileError
    ret

loc_00E9C:
    mov ax, word ptr cs:[0959Ah]
    mov word ptr ds:[FileBufferSegment], ax
    mov word ptr ds:[FileBufferOffset], 0
    mov si, word ptr ds:[LevelIndex]
    shl si, 1
    shl si, 1
    add si, 014E8h
    lodsw
    mov word ptr ds:[014E6h], ax
    lodsw
    mov word ptr ds:[FileNamePtr], ax
    mov word ptr cs:[0BDEh], ax
    mov ax, word ptr cs:[0959Ah]
    mov word ptr cs:[0BDCh], ax
    call loc_00CC8
    mov ax, word ptr ds:[014E6h]
    mov word ptr cs:[0BDEh], ax
    mov ax, word ptr cs:[095AEh]
    mov word ptr cs:[0BDCh], ax
    call loc_00CD8
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    mov ax, word ptr ds:[bx + 01508h]
    mov word ptr cs:[0BDEh], ax
    mov ax, word ptr cs:[095B6h]
    mov word ptr cs:[0BDCh], ax
    mov word ptr cs:[0BE0h], 0BE2h
    mov byte ptr ds:[0BB84h], 1
    call loc_00CB8
    mov byte ptr ds:[0BB84h], 0
    jmp near ptr ClearKeyDownTable

BuildRowTables:
    mov ds, word ptr cs:[MainDataSegment]
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset RecordRowOffsets
    mov cx, 010h
    mov ax, 0FFFFh
    rep stosw
    mov ax, word ptr cs:[PlayfieldRowBytes]
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    neg ax
    mov cx, 0D0h
loc_00F31:
    stosw
    add ax, word ptr cs:[PlayfieldRowBytes]
    loop loc_00F31
    mov ax, 0FFFFh
    mov cx, 020h
    rep stosw
    mov di, offset PlayfieldRowOffsets
    xor ax, ax
    mov cx, 0C8h
loc_00F49:
    stosw
    add ax, word ptr cs:[PlayfieldRowBytes]
    loop loc_00F49
    mov di, offset WideRowOffsets
    xor ax, ax
    mov cx, 0C8h
loc_00F59:
    stosw
    add ax, word ptr cs:[WideRowBytes]
    loop loc_00F59
    mov di, offset ScreenRowOffsets
    mov cx, 0C8h
    xor ax, ax
loc_00F69:
    stosw
    xchg ax, di
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 0F77h]
; UNKNOWN: not yet classified as code or data
    db 07Dh,0Fh,08Dh,0Fh,092h,0Fh

    add di, 02000h
    test di, 04000h
    je loc_00F8B
    add di, 0C050h
loc_00F8B:
    jmp short loc_00FA0

    add di, 028h
    jmp short loc_00FA0

    add di, 02000h
    test di, 08000h
    je loc_00FA0
    add di, 080A0h
loc_00FA0:
    xchg ax, di
    loop loc_00F69
    push cs
    pop es
    mov di, 08D92h
    mov cx, 0100h
    xor ax, ax
loc_00FAD:
    stosw
    add ax, word ptr ds:[01070h]
    loop loc_00FAD
    mov di, 08F92h
    mov cx, 0100h
    xor ax, ax
loc_00FBC:
    stosw
    add ax, word ptr ds:[01024h]
    loop loc_00FBC
    mov di, 09192h
    mov cx, 0100h
    xor ax, ax
loc_00FCB:
    stosw
    add ax, word ptr ds:[01026h]
    loop loc_00FCB
    mov di, 09392h
    mov cx, 0100h
    xor ax, ax
loc_00FDA:
    stosw
    add ax, word ptr ds:[01028h]
    loop loc_00FDA
    jmp near ptr loc_0526A

; For every byte value, write four bytes at DS:1514+4*value expanding bits 7..0 into
; nibble masks (F or 0), i.e. one mask byte per two Tandy 4-bit pixels.
BuildByteToNibbleMaskTable:
    mov es, word ptr cs:[MainDataSegment]
    mov di, 01517h
    xor dh, dh
loc_00FEE:
    mov dl, dh
    xor al, al
    rcr dl, 1
    jae loc_00FF8
    mov al, 0Fh
loc_00FF8:
    rcr dl, 1
    jae loc_00FFE
    add al, 0F0h
loc_00FFE:
    mov byte ptr ds:[di], al
    dec di
    xor al, al
    rcr dl, 1
    jae loc_01009
    mov al, 0Fh
loc_01009:
    rcr dl, 1
    jae loc_0100F
    add al, 0F0h
loc_0100F:
    mov byte ptr ds:[di], al
    dec di
    xor al, al
    rcr dl, 1
    jae loc_0101A
    mov al, 0Fh
loc_0101A:
    rcr dl, 1
    jae loc_01020
    add al, 0F0h
loc_01020:
    mov byte ptr ds:[di], al
    dec di
    xor al, al
    rcr dl, 1
    jae loc_0102B
    mov al, 0Fh
loc_0102B:
    rcr dl, 1
    jae loc_01031
    add al, 0F0h
loc_01031:
    mov byte ptr ds:[di], al
    dec di
    add di, 8
    inc dh
    jne loc_00FEE
    ret
; UNKNOWN: not yet classified as code or data
    db 026h,08Bh,05h,023h,04h,0Bh,044h,04h,026h,089h,05h,026h,08Bh,045h,02h,023h
    db 044h,02h,0Bh,044h,06h,026h,089h,045h,02h,083h,0C7h,01Ah,026h,08Bh,05h,023h
    db 04h,0Bh,044h,08h,026h,089h,05h,026h,08Bh,045h,02h,023h,044h,02h,0Bh,044h
    db 0Ah,026h,089h,045h,02h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h,0Ch
    db 026h,089h,05h,026h,08Bh,045h,02h,023h,044h,02h,0Bh,044h,0Eh,026h,089h,045h
    db 02h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h,010h,026h,089h,05h,026h
    db 08Bh,045h,02h,023h,044h,02h,0Bh,044h,012h,026h,089h,045h,02h,083h,0C7h,01Ah
    db 083h,0C6h,014h,0E2h,08Bh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,0F7h,0D0h,026h
    db 09h,05h,026h,09h,045h,01Ah,026h,09h,045h,034h,026h,09h,045h,04Eh,08Bh,044h
    db 02h,0F7h,0D0h,026h,09h,045h,02h,026h,09h,045h,01Ch,026h,09h,045h,036h,026h
    db 09h,045h,050h,083h,0C7h,068h,083h,0C6h,014h,0E2h,0D0h,02Eh,08Eh,01Eh,096h,095h
    db 0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h
    db 045h,01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h
    db 05Dh,036h,026h,020h,055h,038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h
    db 055h,052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh
    db 044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,08Bh,044h,0Ch
    db 08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h
    db 09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,08Bh,044h,010h,08Bh,05Ch
    db 012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h
    db 04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h
    db 02h,0EBh,03h,0E9h,03Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch
    db 02h,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h
    db 026h,020h,055h,04h,026h,021h,045h,01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh
    db 026h,021h,045h,034h,026h,021h,05Dh,036h,026h,020h,055h,038h,026h,021h,045h,04Eh
    db 026h,021h,05Dh,050h,026h,020h,055h,052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh
    db 044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h
    db 09h,05Dh,01Ch,026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,08Bh
    db 044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,04Eh,026h
    db 09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h,0EBh
    db 03h,0E9h,08h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h
    db 0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h,045h
    db 01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h,05Dh
    db 036h,026h,020h,055h,038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h,055h
    db 052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h
    db 055h,04h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch
    db 026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h
    db 05Dh,036h,026h,08h,055h,038h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,04Eh
    db 026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h
    db 0EBh,03h,0E9h,0D5h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h
    db 0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,021h
    db 05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h,045h,01Ah,026h,021h,05Dh
    db 01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h,05Dh,036h,026h,020h,055h
    db 038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h,055h,052h,08Bh,044h,04h
    db 08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h
    db 026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch
    db 026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h
    db 08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h
    db 0C6h,014h,0E2h,02h,0EBh,03h,0E9h,0A2h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h
    db 0FFh,08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
    db 0D2h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D7h,0D0h
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,021h
    db 05Dh,03h,026h,020h,055h,01Ah,026h,021h,045h,01Bh,026h,021h,05Dh,01Dh,026h,020h
    db 055h,034h,026h,021h,045h,035h,026h,021h,05Dh,037h,026h,020h,055h,04Eh,026h,021h
    db 045h,04Fh,026h,021h,05Dh,051h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E7h
    db 0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h
    db 09h,045h,01h,026h,09h,05Dh,03h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h
    db 0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h
    db 0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h
    db 01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h
    db 0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,034h,026h,09h,045h,035h,026h,09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch
    db 012h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h
    db 083h,0C6h,014h,0E2h,02h,0EBh,03h,0E9h,0D5h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 0B2h,0FFh,08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h
    db 026h,021h,045h,01h,026h,021h,05Dh,03h,026h,020h,055h,01Ah,026h,021h,045h,01Bh
    db 026h,021h,05Dh,01Dh,026h,020h,055h,034h,026h,021h,045h,035h,026h,021h,05Dh,037h
    db 026h,020h,055h,04Eh,026h,021h,045h,04Fh,026h,021h,05Dh,051h,08Bh,044h,04h,08Bh
    db 05Ch,06h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h
    db 0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h
    db 09h,05Dh,03h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch
    db 0Eh,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,034h,026h,09h,045h,035h,026h
    db 09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h,083h,0C6h
    db 014h,0E2h,02h,0EBh,03h,0E9h,08h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh
    db 08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
    db 026h,020h,015h,026h,021h,045h,01h,026h,021h,05Dh,03h,026h,020h,055h,01Ah,026h
    db 021h,045h,01Bh,026h,021h,05Dh,01Dh,026h,020h,055h,034h,026h,021h,045h,035h,026h
    db 021h,05Dh,037h,026h,020h,055h,04Eh,026h,021h,045h,04Fh,026h,021h,05Dh,051h,08Bh
    db 044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,08Bh,044h,08h,08Bh
    db 05Ch,0Ah,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h
    db 055h,01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch,0Eh
    db 032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,034h
    db 026h,09h,045h,035h,026h,09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h
    db 0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h
    db 045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h,0EBh,03h
    db 0E9h,03Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh
    db 0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
    db 026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,026h,09h,045h,01Ah,026h
    db 09h,05Dh,01Ch,026h,08h,055h,01Eh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h
    db 08h,055h,038h,026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h
    db 0C7h,068h,083h,0C6h,014h,0E2h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh
    db 05Ch,02h,0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h
    db 05h,026h,09h,05Dh,02h,026h,08h,055h,04h,026h,09h,045h,01Ah,026h,09h,05Dh
    db 01Ch,026h,08h,055h,01Eh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h
    db 038h,026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h
    db 083h,0C6h,014h,0E2h,0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h
    db 0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h
    db 04h,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,026h,09h,045h
    db 034h,026h,09h,05Dh,036h,026h,08h,055h,038h,026h,09h,045h,04Eh,026h,09h,05Dh
    db 050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,09Eh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h
    db 08h,055h,04h,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,026h
    db 09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,026h,09h,045h,04Eh,026h
    db 09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,094h,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,08Bh,05Ch,02h,0F6h,0D2h,0F7h,0D0h
    db 0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h
    db 0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
    db 026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h,01Ah,026h
    db 09h,045h,01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h,035h,026h
    db 09h,05Dh,037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h
    db 0C7h,068h,083h,0C6h,014h,0E2h,09Eh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh
    db 04h,08Bh,05Ch,02h,0F6h,0D2h,0F7h,0D0h,0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h
    db 015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h,01Ah,026h,09h,045h
    db 01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h,035h,026h,09h,05Dh
    db 037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h
    db 083h,0C6h,014h,0E2h,0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,08Bh
    db 05Ch,02h,0F6h,0D2h,0F7h,0D0h,0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h
    db 01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h
    db 035h,026h,09h,05Dh,037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh
    db 051h,083h,0C7h,068h,083h,0C6h,014h,0E2h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,026h
    db 08Bh,05h,023h,04h,0Bh,044h,02h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h
    db 023h,04h,0Bh,044h,04h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h
    db 0Bh,044h,06h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h
    db 08h,026h,089h,05h,083h,0C7h,01Ah,083h,0C6h,0Ah,0E2h,0C3h,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,08Bh,04h,0F7h,0D0h,026h,09h,05h,026h,09h,045h,01Ah,026h,09h,045h
    db 034h,026h,09h,045h,04Eh,083h,0C6h,0Ah,083h,0C7h,068h,0E2h,0E5h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h
    db 026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h
    db 026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h,055h,036h,0ADh,032h
    db 0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,04Eh,026h,08h,055h,050h,083h
    db 0C7h,068h,0E2h,08Fh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h
    db 055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h,026h,020h
    db 055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h
    db 0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h
    db 09h,045h,01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h,055h,036h,0ADh,032h
    db 0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
    db 04Eh,026h,08h,055h,050h,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h,06Bh,0FFh,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h
    db 026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h
    db 026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
    db 01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h
    db 055h,036h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,04Eh,026h,08h,055h,050h,083h
    db 0C7h,068h,0E2h,02h,0EBh,03h,0E9h,04Ch,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh
    db 0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h
    db 05h,026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h
    db 034h,026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh
    db 032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,01Ah,026h,08h
    db 055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
    db 034h,026h,08h,055h,036h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 026h,09h,045h,04Eh,026h,08h,055h,050h,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h
    db 02Dh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,0ADh,0F9h,0D0h,0D4h,0D0h,0D0h
    db 0D0h,0D2h,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
    db 026h,020h,015h,026h,021h,045h,01h,026h,020h,055h,01Ah,026h,021h,045h,01Bh,026h
    db 020h,055h,034h,026h,021h,045h,035h,026h,020h,055h,04Eh,026h,021h,045h,04Fh,0ADh
    db 032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h
    db 026h,08h,055h,01Ah,026h,09h,045h,01Bh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h
    db 034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h
    db 045h,04Fh,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h,04Ch,0FFh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,0B2h,0FFh,0ADh,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D4h,0D0h
    db 0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,020h,055h,01Ah,026h,021h
    db 045h,01Bh,026h,020h,055h,034h,026h,021h,045h,035h,026h,020h,055h,04Eh,026h,021h
    db 045h,04Fh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,0ADh
    db 032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h
    db 055h,034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h
    db 0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h
    db 0E2h,02h,0EBh,03h,0E9h,06Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,0ADh
    db 0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,020h
    db 055h,01Ah,026h,021h,045h,01Bh,026h,020h,055h,034h,026h,021h,045h,035h,026h,020h
    db 055h,04Eh,026h,021h,045h,04Fh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h
    db 08h,055h,01Ah,026h,09h,045h,01Bh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h
    db 026h,08h,055h,034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
    db 0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,0E2h,08Fh,02Eh,08Eh
    db 01Eh,096h,095h,0C3h,08Bh,04h,0B2h,0FFh,0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h,055h
    db 01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h,055h
    db 050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0CBh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh
    db 04h,0B2h,0FFh,0F7h

; Modern record/state symbols.
; UNKNOWN: not yet classified as code or data
    db 0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h
    db 09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h,055h,01Ch,026h,09h
    db 045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h,055h,050h,083h,0C7h
    db 068h,083h,0C6h,0Ah,0E2h,0C5h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,0B2h,0FFh
    db 0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h
    db 01Ah,026h,08h,055h,01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h
    db 04Eh,026h,08h,055h,050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0BFh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,08Bh,04h,0B2h,0FFh,0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h
    db 055h,01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h
    db 055h,050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0B9h,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h
    db 01h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h,045h
    db 035h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah,0E2h
    db 0BFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h,0D0h
    db 0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h
    db 045h,01h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h
    db 045h,035h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah
    db 0E2h,0C5h,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h
    db 0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h,08h,055h
    db 01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h,045h,035h,026h,08h,055h
    db 04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0CBh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,026h,08Ah,05h,022h,04h,0Ah,044h,01h,026h,088h,05h,083h,0C7h
    db 01Ah,026h,08Ah,05h,022h,04h,0Ah,044h,02h,026h,088h,05h,083h,0C7h,01Ah,026h
    db 08Ah,05h,022h,04h,0Ah,044h,03h,026h,088h,05h,083h,0C7h,01Ah,026h,08Ah,05h
    db 022h,04h,0Ah,044h,04h,026h,088h,05h,083h,0C7h,01Ah,083h,0C6h,05h,0E2h,0C3h
    db 02Eh,08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,026h,021h
    db 05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,0ACh,032h,0E4h
    db 0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,026h,09h
    db 045h,01Ah,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h
    db 0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h,0E2h,0B9h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh
    db 026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,0ACh
    db 032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh,032h,0E4h,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h,0E2h,0A4h,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h
    db 0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,026h,021h,05h,026h,021h,045h,01Ah,026h,021h
    db 045h,034h,026h,021h,045h,04Eh,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh,032h,0E4h,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h
    db 0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h
    db 04Eh,083h,0C7h,068h,0E2h,08Fh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h
    db 0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h
    db 0D8h,0D0h,0DCh,026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h
    db 045h,04Eh,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh
    db 032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h
    db 0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
    db 0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h
    db 0E2h,02h,0EBh,03h,0E9h,075h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Ah,024h,0B0h
    db 0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h
    db 026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,08Ah
    db 064h,01h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h
    db 026h,09h,05h,08Ah,064h,02h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h
    db 0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah,064h,03h,032h,0C0h,0D0h,0E4h,0D0h
    db 0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah,064h,04h
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h
    db 045h,04Eh,083h,0C7h,068h,083h,0C6h,05h,0E2h,083h,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 08Ah,024h,0B0h,0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h,026h,021h
    db 05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,08Ah,064h,01h
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,05h,08Ah,064h,02h
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah,064h
    db 03h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah
    db 064h,04h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,04Eh
    db 083h,0C7h,068h,083h,0C6h,05h,0E2h,098h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Ah,024h
    db 0B0h,0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,026h,021h,05h,026h,021h,045h,01Ah,026h,021h
    db 045h,034h,026h,021h,045h,04Eh,08Ah,064h,01h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h
    db 09h,05h,08Ah,064h,02h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah
    db 064h,03h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah,064h,04h,032h
    db 0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,04Eh,083h,0C7h,068h,083h,0C6h,05h,0E2h
    db 0ADh,02Eh,08Eh,01Eh,096h,095h,0C3h

BlitPackedToScreenEga:
    lodsw
    mov cx, ax
    lodsw
    mov bp, ax
    mov es, word ptr cs:[ScreenSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
loc_024E9:
    push cx
    mov al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    pop cx
    loop loc_024E9
    mov al, 0Fh
    out dx, al
    ret

BlitPackedStride104Ega:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    mov bp, ax
loc_02523:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 01Ah
    pop cx
    loop loc_02523
    ret

BlitPackedStride160Ega:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    mov bp, ax
loc_02557:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 028h
    pop cx
    loop loc_02557
    ret
loc_02580:
    mov bx, word ptr ss:[bp + 2]
    cmp bx, 0E0h
    jae loc_025B2
    shl bx, 1
    mov bx, word ptr ds:[bx + RecordRowOffsets]
    cmp bx, -1
    je loc_025B2
    mov ax, word ptr ss:[bp + 4]
    mov cx, ax
    and cx, 7
    mov word ptr ss:[bp + 012h], cx
    shr ax, 1
    shr ax, 1
    shr ax, 1
    add ax, bx
    cmp word ptr ss:[bp + 024h], 0
    jne loc_025AE
    ret
loc_025AE:
    dec word ptr ss:[bp + 024h]
    ret
loc_025B2:
    mov ax, 0FFFFh
    ret

DrawOffsetFromScreenRowEga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + ScreenRowOffsets]
    xor ah, ah
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromPlayfieldRowEga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + PlayfieldRowOffsets]
    xor ah, ah
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromWideRowEga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + WideRowOffsets]
    xor ah, ah
    add ax, bx
    mov di, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,0D1h,0E8h
    db 0D1h,0E8h,03h,0C3h,0C3h

loc_025FE:
    cmp al, 010h
    jne loc_02605
    jmp near ptr loc_0272F
loc_02605:
    cmp al, 011h
    jne loc_0260C
    jmp near ptr loc_02718
loc_0260C:
    cmp al, 0Eh
    jne loc_02613
    jmp near ptr loc_0270C
loc_02613:
    xor ah, ah
    shl ax, 1
    shl ax, 1
    shl ax, 1
    add ax, 01816h
    mov si, ax
    mov es, word ptr cs:[ScreenSegment]
    xor ax, ax
    mov al, byte ptr ds:[0215Eh]
    add ax, word ptr ds:[02160h]
    mov di, ax
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    xor al, al
    mov byte ptr es:[di], al
    mov byte ptr es:[di + 028h], al
    mov byte ptr es:[di + 050h], al
    mov byte ptr es:[di + 078h], al
    mov byte ptr es:[di + 0A0h], al
    mov byte ptr es:[di + 0C8h], al
    mov byte ptr es:[di + 0F0h], al
    mov byte ptr es:[di + 0118h], al
    mov al, byte ptr ds:[0215Ch]
    out dx, al
    mov word ptr ds:[01914h], 4
    mov bl, byte ptr ds:[0215Ch]
    mov bh, 1
    mov cx, 4
loc_02672:
    mov al, bh
    out dx, al
    shl bh, 1
    push dx
    mov dx, 03CEh
    mov ax, word ptr ds:[01914h]
    out dx, ax
    inc byte ptr ds:[01915h]
    pop dx
    shr bl, 1
    jae loc_026B8
    lodsb
    or byte ptr es:[di], al
    lodsb
    or byte ptr es:[di + 028h], al
    lodsb
    or byte ptr es:[di + 050h], al
    lodsb
    or byte ptr es:[di + 078h], al
    lodsb
    or byte ptr es:[di + 0A0h], al
    lodsb
    or byte ptr es:[di + 0C8h], al
    lodsb
    or byte ptr es:[di + 0F0h], al
    lodsb
    or byte ptr es:[di + 0118h], al
    sub si, 8
    jmp short loc_026F6
loc_026B8:
    lodsb
    not al
    and byte ptr es:[di], al
    lodsb
    not al
    and byte ptr es:[di + 028h], al
    lodsb
    not al
    and byte ptr es:[di + 050h], al
    lodsb
    not al
    and byte ptr es:[di + 078h], al
    lodsb
    not al
    and byte ptr es:[di + 0A0h], al
    lodsb
    not al
    and byte ptr es:[di + 0C8h], al
    lodsb
    not al
    and byte ptr es:[di + 0F0h], al
    lodsb
    not al
    and byte ptr es:[di + 0118h], al
    sub si, 8
loc_026F6:
    loop loc_026FA
    jmp short loc_026FD
loc_026FA:
    jmp near ptr loc_02672
loc_026FD:
    mov al, 0Fh
    out dx, al
    add byte ptr ds:[0215Eh], 1
    cmp byte ptr ds:[0215Eh], 028h
    jb loc_02717
loc_0270C:
    mov byte ptr ds:[0215Eh], 0
    add word ptr ds:[02160h], 0140h
loc_02717:
    ret
loc_02718:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 0140h
    xor ah, ah
    mul cx
    mov word ptr ds:[02160h], ax
    mov al, byte ptr ss:[bp + 2]
    mov byte ptr ds:[0215Eh], al
    add bp, 2
    ret
loc_0272F:
    inc bp
    mov al, byte ptr ss:[bp]
    mov byte ptr ds:[0215Ch], al
    ret

    mov es, word ptr cs:[ScreenSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    xor di, di
    mov ax, di
    mov cx, 01F40h
    rep stosw
    ret

CopyWorkspaceToScreenEga:
    mov si, word ptr ds:[0234Ch]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 0Dh
    mov di, 0A0h
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov bp, 0C0h
loc_0276E:
    mov al, 1
    out dx, al
    mov cx, bx
    rep movsw
    sub di, 01Ah
    shl al, 1
    out dx, al
    mov cx, bx
    rep movsw
    sub di, 01Ah
    shl al, 1
    out dx, al
    mov cx, bx
    rep movsw
    sub di, 01Ah
    shl al, 1
    out dx, al
    mov cx, bx
    rep movsw
    add di, 0Eh
    dec bp
    jne loc_0276E
    mov al, 0Fh
    out dx, al
    mov ds, word ptr cs:[MainDataSegment]
    ret

ClearScreen104x200Ega:
    call loc_027B7
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_027B6
    call loc_0511F
    call loc_027B7
    call loc_0511F
loc_027B6:
    ret

loc_027B7:
    mov es, word ptr cs:[ScreenSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    mov al, 0Fh
    out dx, al
    xor di, di
    mov bp, 0C8h
loc_027CB:
    mov cx, 0Dh
    xor ax, ax
    rep stosw
    add di, 0Eh
    dec bp
    jne loc_027CB
    ret

loc_027D9:
    inc word ptr cs:[05BA8h]
    call loc_044D7
    jne loc_027E6
    jmp near ptr loc_044AA
loc_027E6:
    mov cx, word ptr cs:[05B9Eh]
loc_027EB:
    push cx
    cmp word ptr cs:[0BD6h], 0
    je loc_02802
    push si
    mov cx, word ptr cs:[05B9Ch]
loc_027FA:
    push cx
    call loc_02932
    pop cx
    loop loc_027FA
    pop si
loc_02802:
    mov word ptr cs:[05BA6h], di
    mov di, 05AF4h
    mov bp, 4
loc_0280D:
    mov cx, word ptr cs:[05B9Ch]
loc_02812:
    lodsb
    mov byte ptr cs:[di], al
    inc di
    loop loc_02812
    sub di, word ptr cs:[05B9Ch]
    add di, 028h
    dec bp
    jne loc_0280D
    mov di, 05AF4h
    mov cx, word ptr cs:[05B9Ch]
loc_0282C:
    push cx
    mov al, byte ptr cs:[di]
    mov ah, byte ptr cs:[di + 028h]
    mov dl, byte ptr cs:[di + 050h]
    mov dh, byte ptr cs:[di + 078h]
    mov cx, 8
loc_0283F:
    rol dh, 1
    rcl bl, 1
    rol dl, 1
    rcl bl, 1
    rol ah, 1
    rcl bl, 1
    rol al, 1
    rcl bl, 1
    and bl, 0Fh
    cmp word ptr cs:[0BD6h], 0
    je loc_02863
    cmp bl, byte ptr cs:[0]
    jne loc_02863
    xor bl, bl
loc_02863:
    cmp byte ptr cs:[0C5B0h], 1
    jne loc_0289A
    mov bp, word ptr cs:[05BAAh]
    cmp bp, -1
    je loc_0289A
    add bp, word ptr cs:[05BA8h]
    cmp byte ptr ss:[bp], 1
    je loc_0288A
    cmp byte ptr ss:[bp], 2
    je loc_02888
    jmp short loc_0289A
loc_02888:
    jmp short loc_0289A
loc_0288A:
    cmp bl, 6
    je loc_02898
    cmp bl, 0Ch
    jne loc_0289A
    mov bl, 6
    jmp short loc_0289A
loc_02898:
    mov bl, 0Ch
loc_0289A:
    shr bl, 1
    rcl byte ptr cs:[05BA2h],1
    shr bl, 1
    rcl byte ptr cs:[05BA3h],1
    shr bl, 1
    rcl byte ptr cs:[05BA4h],1
    shr bl, 1
    rcl byte ptr cs:[05BA5h],1
    loop loc_0283F
    mov al, byte ptr cs:[05BA2h]
    mov byte ptr cs:[di], al
    mov al, byte ptr cs:[05BA3h]
    mov byte ptr cs:[di + 028h], al
    mov al, byte ptr cs:[05BA4h]
    mov byte ptr cs:[di + 050h], al
    mov al, byte ptr cs:[05BA5h]
    mov byte ptr cs:[di + 078h], al
    inc di
    pop cx
    loop loc_028DD
    jmp short loc_028E0
loc_028DD:
    jmp near ptr loc_0282C
loc_028E0:
    mov di, 05AF4h
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, 05B1Ch
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, 05B44h
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, 05B6Ch
    mov cx, word ptr cs:[05B9Ch]
    call loc_0291C
    mov di, word ptr cs:[05BA6h]
    pop cx
    loop loc_02916
    jmp short loc_02919
loc_02916:
    jmp near ptr loc_027EB
loc_02919:
    jmp near ptr loc_027D9

loc_0291C:
    push cx
    mov al, byte ptr cs:[di]
    inc di
    push di
    mov di, word ptr cs:[05BA6h]
    stosb
    mov word ptr cs:[05BA6h], di
    pop di
    pop cx
    loop loc_0291C
    ret

loc_02932:
    mov byte ptr cs:[05BA0h], 0
    mov bx, word ptr cs:[05B9Ch]
    mov al, byte ptr ds:[si]
    mov ah, byte ptr ds:[bx + si]
    shl bx, 1
    mov dl, byte ptr ds:[bx + si]
    add bx, word ptr cs:[05B9Ch]
    mov dh, byte ptr ds:[bx + si]
    mov cx, 8
loc_0294F:
    push cx
    rcl dh, 1
    rcl byte ptr cs:[05BA1h],1
    rcl dl, 1
    rcl byte ptr cs:[05BA1h],1
    rcl ah, 1
    rcl byte ptr cs:[05BA1h],1
    rcl al, 1
    rcl byte ptr cs:[05BA1h],1
    and byte ptr cs:[05BA1h], 0Fh
    mov cl, byte ptr cs:[0]
    cmp byte ptr cs:[05BA1h], cl
    jne loc_02981
    stc
    jmp short loc_02982
loc_02981:
    clc
loc_02982:
    rcl byte ptr cs:[05BA0h],1
    pop cx
    loop loc_0294F
    mov al, byte ptr cs:[05BA0h]
    stosb
    inc si
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,0FFh,0FFh,074h,03h,0E8h,010h,00h,08Bh,07Eh,010h,08Bh,076h,0Eh,081h,0C6h
    db 040h,01h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,015h,00h,0B9h,010h,00h,0A5h,0A5h
    db 0A4h,03h,0FBh,0A5h,0A5h,0A4h,03h,0FBh,0A5h,0A5h,0A4h,03h,0FBh,0A5h,0A5h,0A4h
    db 03h,0FBh,0E2h,0EAh,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,017h,00h,0B9h,010h
    db 00h,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h
    db 0FBh,0E2h,0EEh,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,018h,00h,0A5h,03h,0FBh
    db 0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h
    db 03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h
    db 0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh
    db 0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h
    db 03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h
    db 0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0C3h,0E8h,0E4h
    db 02Fh,089h,046h,0Ch,03Dh,0FFh,0FFh,074h,0Fh,03h,06h,04Ch,023h,089h,046h,0Ch
    db 08Bh,0F0h,08Bh,07Eh,0Eh,0E8h,024h,00h,083h,046h,02h,010h,0E8h,0C6h,02Fh,089h
    db 046h,010h,083h,06Eh,02h,010h,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h
    db 089h,046h,010h,08Bh,0F0h,08Bh,07Eh,0Eh,081h,0C7h,040h,01h,02Eh,08Eh,06h,096h
    db 095h,02Eh,08Eh,01Eh,098h,095h,0BBh,015h,00h,0B9h,010h,00h,0A4h,0A5h,0A5h,03h
    db 0F3h,0A4h,0A5h,0A5h,03h,0F3h,0A4h,0A5h,0A5h,03h,0F3h,0A4h,0A5h,0A5h,03h,0F3h
    db 0E2h,0EAh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,07Ah,02Fh,089h,046h,0Ch,03Dh,0FFh
    db 0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh
    db 02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0BBh,017h,00h,0B9h,010h,00h
    db 0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h
    db 0E2h,0EEh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,03Ah,02Fh,089h,046h,0Ch,03Dh,0FFh
    db 0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh
    db 02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0BBh,018h,00h,0A5h,03h,0F3h
    db 0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h
    db 03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h
    db 0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h
    db 0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h
    db 03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h
    db 0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h

loc_02B84:
    mov bx, dx
    mov cx, 0Dh
    mov ax, word ptr cs:[0959Ah]
    cmp word ptr ds:[02350h], 0E5Fh
    jb loc_02B99
    mov ax, word ptr cs:[0959Ch]
loc_02B99:
    mov ds, ax
loc_02B9B:
    push cx
    push bx
    mov es, word ptr cs:[09592h]
    mov bl, byte ptr es:[bx]
    dec bl
    xor bh, bh
    shl bx, 1
    add bx, 08D92h
    mov si, word ptr cs:[bx]
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    lodsw
    mov word ptr es:[di], ax
    lodsw
    mov word ptr es:[di + 01Ah], ax
    lodsw
    mov word ptr es:[di + 034h], ax
    lodsw
    mov word ptr es:[di + 04Eh], ax
    add di, 068h
    sub di, 067Eh
    pop bx
    add bx, 1
    pop cx
    loop loc_02D24
    jmp short loc_02D27
loc_02D24:
    jmp near ptr loc_02B9B
loc_02D27:
    mov ds, word ptr cs:[MainDataSegment]
    ret

    mov word ptr cs:[05903h], 0
    mov di, word ptr cs:[058F9h]
    mov si, word ptr cs:[058FBh]
    mov cx, word ptr cs:[058FDh]
    mov bp, word ptr cs:[058FFh]
    cmp word ptr cs:[05905h], 0
    je loc_02D5C
    mov ax, bp
    shl ax, 1
    shl ax, 1
    dec cx
    mul cx
    inc cx
    add si, ax
loc_02D5C:
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
    push cx
    mov cx, word ptr cs:[058FDh]
    sub cx, word ptr cs:[05901h]
    or cx, cx
    js loc_02D8C
    shr cx, 1
    jcxz loc_02D8C
    dec cx
    jcxz loc_02D81
    mov al, 0Fh
    out dx, al
loc_02D7C:
    add di, 028h
    loop loc_02D7C
loc_02D81:
    xor al, al
    mov cx, bp
    rep stosb
    sub di, bp
    add di, 028h
loc_02D8C:
    pop cx
loc_02D8D:
    mov ax, word ptr cs:[05901h]
    cmp ax, word ptr cs:[058FDh]
    je loc_02DCB
    add word ptr cs:[05903h], ax
    mov ax, word ptr cs:[058FDh]
    cmp ax, word ptr cs:[05903h]
    ja loc_02DC6
    cmp word ptr cs:[05905h], 0
    je loc_02DBA
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    jmp short loc_02DC2
loc_02DBA:
    add si, bp
    add si, bp
    add si, bp
    add si, bp
loc_02DC2:
    loop loc_02D8D
    jmp short loc_02E23
loc_02DC6:
    sub word ptr cs:[05903h], ax
loc_02DCB:
    push cx
    mov al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    rep movsb
    sub di, bp
    shl al, 1
    out dx, al
    mov cx, bp
    cmp word ptr cs:[05907h], 1
    je loc_02DF8
    rep movsb
    jmp short loc_02DFE
loc_02DF8:
    xor al, al
    rep stosb
    add si, bp
loc_02DFE:
    sub di, bp
    add di, 028h
    cmp word ptr cs:[05905h], 0
    je loc_02E1B
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
    sub si, bp
loc_02E1B:
    pop cx
    loop loc_02E20
    jmp short loc_02E23
loc_02E20:
    jmp near ptr loc_02D8D
loc_02E23:
    mov al, 0Fh
    out dx, al
    xor al, al
    mov cx, bp
    rep stosb
    ret

loc_02E2D:
    mov ds, word ptr cs:[WorkspaceSegment]
    mov dx, 03C4h
    mov al, 2
    out dx, al
    inc dx
loc_02E39:
    mov al, 1
    out dx, al
    mov cx, 014h
    rep movsw
    sub di, 028h
    mov al, 2
    out dx, al
    mov cx, 014h
    rep movsw
    sub di, 028h
    mov al, 4
    out dx, al
    mov cx, 014h
    rep movsw
    sub di, 028h
    mov al, 8
    out dx, al
    mov cx, 014h
    rep movsw
    dec bp
    jne loc_02E39
    mov al, 0Fh
    out dx, al
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02E6E:
    mov bx, 058h
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    loop loc_02E6E
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02ECB:
    mov bx, 058h
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    add di, bx
    loop loc_02ECB
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02F40:
    mov bx, 060h
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    mov ax, word ptr ds:[si]
    not ax
    or word ptr es:[di], ax
    add si, 4
    add di, 2
    add di, bx
    loop loc_02F40
    mov ds, word ptr cs:[MainDataSegment]
    ret
loc_02F81:
    mov bx, 060h
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    loop loc_02F81
    mov ds, word ptr cs:[MainDataSegment]
    ret
    mov bx, 064h
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    lodsw
    and ax, word ptr es:[di]
    or ax, word ptr ds:[si]
    add si, 2
    stosw
    add di, bx
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Copy a packed image (DS:SI header: row count, width in 8-pixel units) to Tandy video
; memory at ES=CS:95A4, ES:DI. Tandy rows interleave across four 2000h banks: each row
; adds 2000h, and after the fourth bank adding 80A0h wraps to the first bank one 160-byte
; line further. No clipping; DF=0.
CopyPackedRowsToTandyBanks:
    lodsw
    mov cx, ax
    lodsw
    mov es, word ptr cs:[ScreenSegment]
    shl ax, 1
    shl ax, 1
    mov bp, ax
loc_0307E:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 08000h
    je loc_03093
    add di, 080A0h
loc_03093:
    pop cx
    loop loc_0307E
    ret

; Copy a packed image (DS:SI: row count, width units) into the 104-byte-wide workspace
; at ES=CS:9598, DI advancing 104 bytes per row. DF=0; no clipping.
CopyPackedRowsStride104:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    shl ax, 1
    mov bp, ax
loc_030A6:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 068h
    pop cx
    loop loc_030A6
    ret

; As CopyPackedRowsStride104, but into a 160-byte-wide buffer.
CopyPackedRowsStride160:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    shl ax, 1
    mov bp, ax
loc_030C3:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 0A0h
    pop cx
    loop loc_030C3
    ret
loc_030D2:
    mov bx, word ptr ss:[bp + REC_Y]
    cmp bx, 0E0h
    jb loc_030DE
    jmp near ptr loc_025B2
loc_030DE:
    shl bx, 1
    mov bx, word ptr ds:[bx + RecordRowOffsets]
    cmp bx, -1
    jne loc_030EC
    jmp near ptr loc_025B2
loc_030EC:
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ss:[bp + 012h], 0
    shr ax, 1
    add ax, bx
    cmp word ptr ss:[bp + 024h], 0
    jne loc_030FF
    ret
loc_030FF:
    dec word ptr ss:[bp + 024h]
    ret

; AX = DI = row offset table DS:9EE8[AH] + 4*AL (AL in 8-pixel units); BX = the table
; entry. No bounds check; the initializer fills 200 rows.
TandyOffsetFromScreenRow:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + ScreenRowOffsets]
    xor ah, ah
    shl ax, 1
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

; As TandyOffsetFromScreenRow with the row table at DS:9BC8.
TandyOffsetFromPlayfieldRow:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + PlayfieldRowOffsets]
    xor ah, ah
    shl ax, 1
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

; As TandyOffsetFromScreenRow with the row table at DS:9D58.
TandyOffsetFromWideRow:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + WideRowOffsets]
    xor ah, ah
    shl ax, 1
    shl ax, 1
    add ax, bx
    mov di, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,03h,0C3h
    db 0C3h

loc_03153:
    cmp al, 010h
    jne loc_0315A
    jmp near ptr loc_0333D
loc_0315A:
    cmp al, 011h
    jne loc_03161
    jmp near ptr loc_03322
loc_03161:
    xor ah, ah
    shl ax, 1
    shl ax, 1
    shl ax, 1
    mov si, ax
    add si, 01816h
    mov es, word ptr cs:[ScreenSegment]
    xor dx, dx
    mov dl, byte ptr ds:[0215Eh]
    add dx, word ptr ds:[02160h]
    mov di, dx
    mov dl, byte ptr ds:[0215Ch]
    shl dl, 1
    shl dl, 1
    shl dl, 1
    shl dl, 1
    or dl, byte ptr ds:[0215Ch]
    mov dh, dl
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_031C1
    add di, 080A0h
loc_031C1:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_031F0
    add di, 080A0h
loc_031F0:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0321F
    add di, 080A0h
loc_0321F:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0324E
    add di, 080A0h
loc_0324E:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0327D
    add di, 080A0h
loc_0327D:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_032AC
    add di, 080A0h
loc_032AC:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_032DB
    add di, 080A0h
loc_032DB:
    lodsb
    xor ah, ah
    mov bx, ax
    shl bx, 1
    shl bx, 1
    add bx, 01514h
    mov ax, word ptr ds:[bx]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di], cx
    mov ax, word ptr ds:[bx + 2]
    mov cx, ax
    and cx, dx
    mov word ptr es:[di + 2], cx
    add di, 02000h
    test di, 08000h
    je loc_0330A
    add di, 080A0h
loc_0330A:
    add byte ptr ds:[0215Eh], 4
    cmp byte ptr ds:[0215Eh], 0A0h
    jb loc_03321
    mov byte ptr ds:[0215Eh], 0
    add word ptr ds:[02160h], 0140h
loc_03321:
    ret
loc_03322:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 0140h
    xor ah, ah
    mul cx
    mov word ptr ds:[02160h], ax
    mov al, byte ptr ss:[bp + 2]
    shl al, 1
    shl al, 1
    mov byte ptr ds:[0215Eh], al
    add bp, 2
    ret
loc_0333D:
    inc bp
    mov al, byte ptr ss:[bp]
    mov byte ptr ds:[0215Ch], al
    ret

; Zero the whole 32 KiB Tandy video buffer (ES=CS:95A4, left in ES). DF=0.
ClearTandy32K:
    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov ax, di
    mov cx, 04000h
    rep stosw
    ret

; Copy 192 rows of the 104-byte workspace (source offset from DS:234C, segment CS:9598)
; into the left 104 bytes of Tandy rows 4..195. Leaves DS = state segment, whatever
; DS was on entry.
CopyWorkspace104x192ToTandy:
    mov si, word ptr ds:[0234Ch]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 034h
    mov di, 0A0h
    mov bp, 0C0h
loc_0336B:
    mov cx, bx
    rep movsw
    sub di, 068h
    add di, 02000h
    test di, 08000h
    je loc_03380
    add di, 080A0h
loc_03380:
    dec bp
    jne loc_0336B
    mov ds, word ptr cs:[MainDataSegment]
    ret

; Clear the left 104 bytes of all 200 Tandy rows; the rest of each row is untouched.
ClearTandy104x200:
    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov bp, 0C8h
loc_03393:
    mov cx, 034h
    xor ax, ax
    rep stosw
    sub di, 068h
    add di, 02000h
    test di, 08000h
    je loc_033AB
    add di, 080A0h
loc_033AB:
    dec bp
    jne loc_03393
    ret

loc_033AF:
    call loc_044D7
    jne loc_033B7
    jmp near ptr loc_044AA
loc_033B7:
    mov cx, word ptr cs:[05B9Eh]
loc_033BC:
    push cx
    mov cx, word ptr cs:[05B9Ch]
loc_033C2:
    push cx
    call loc_033DD
    pop cx
    loop loc_033C2
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    pop cx
    loop loc_033BC
    jmp short loc_033AF

loc_033DD:
    mov bx, word ptr cs:[05B9Ch]
    mov al, byte ptr ds:[si]
    mov ah, byte ptr ds:[bx + si]
    shl bx, 1
    mov dl, byte ptr ds:[bx + si]
    add bx, word ptr cs:[05B9Ch]
    mov dh, byte ptr ds:[bx + si]
    call loc_0344B
    mov byte ptr cs:[05B95h], cl
    mov byte ptr cs:[05B99h], ch
    call loc_0344B
    mov byte ptr cs:[05B94h], cl
    mov byte ptr cs:[05B98h], ch
    call loc_0344B
    mov byte ptr cs:[05B97h], cl
    mov byte ptr cs:[05B9Bh], ch
    call loc_0344B
    mov byte ptr cs:[05B96h], cl
    mov byte ptr cs:[05B9Ah], ch
    inc si
    cmp word ptr cs:[0BD6h], 0
    je loc_03433
    mov ax, word ptr cs:[05B9Ah]
    stosw
loc_03433:
    mov ax, word ptr cs:[05B96h]
    stosw
    cmp word ptr cs:[0BD6h], 0
    je loc_03445
    mov ax, word ptr cs:[05B98h]
    stosw
loc_03445:
    mov ax, word ptr cs:[05B94h]
    stosw
    ret

loc_0344B:
    ror dh, 1
    rcl cl, 1
    ror dl, 1
    rcl cl, 1
    ror ah, 1
    rcl cl, 1
    ror al, 1
    rcl cl, 1
    ror dh, 1
    rcl cl, 1
    ror dl, 1
    rcl cl, 1
    ror ah, 1
    rcl cl, 1
    ror al, 1
    rcl cl, 1
    ror cl, 1
    ror cl, 1
    ror cl, 1
    ror cl, 1
    cmp word ptr cs:[0BD6h], 0
    jne loc_0347C
    ret
loc_0347C:
    mov bx, ax
    xor ch, ch
    mov al, cl
    and al, 0Fh
    cmp al, byte ptr cs:[0]
    jne loc_03491
    or ch, 0Fh
    and cl, 0F0h
loc_03491:
    mov al, cl
    and al, 0F0h
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    cmp al, byte ptr cs:[0]
    jne loc_034AA
    or ch, 0F0h
    and cl, 0Fh
loc_034AA:
    mov ax, bx
    ret
    cmp di, -1
    je loc_034B5
    call loc_034C5
loc_034B5:
    mov di, word ptr ss:[bp + REC_SCREEN_OFS_LOWER]
    mov si, word ptr ss:[bp + REC_SAVE_BUFFER]
    add si, 0140h
    cmp di, -1
    jne loc_034C5
    ret
loc_034C5:
    mov bx, 058h
    mov cx, 010h
loc_034CB:
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    add di, bx
    loop loc_034CB
    ret
    cmp di, -1
    jne loc_034DE
    ret
loc_034DE:
    mov bx, 060h
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    movsw
    movsw
    movsw
    movsw
    add di, bx
    ret
    cmp di, -1
    jne loc_03548
    ret
loc_03548:
    mov bx, 064h
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    movsw
    movsw
    add di, bx
    ret
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    cmp ax, 0FFFFh
    je loc_03586
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    call loc_035AA
loc_03586:
    add word ptr ss:[bp + REC_Y], 010h
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS_LOWER], ax
    sub word ptr ss:[bp + REC_Y], 010h
    cmp ax, 0FFFFh
    jne loc_0359A
    ret
loc_0359A:
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS_LOWER], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    add di, 0140h
loc_035AA:
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 058h
    mov cx, 010h
loc_035BA:
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    add si, bx
    loop loc_035BA
    mov ds, word ptr cs:[MainDataSegment]
    ret
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    cmp ax, 0FFFFh
    jne loc_035D8
    ret
loc_035D8:
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 060h
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    movsw
    movsw
    movsw
    movsw
    add si, bx
    mov ds, word ptr cs:[MainDataSegment]
    ret
    call loc_05A36
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    cmp ax, 0FFFFh
    jne loc_03663
    ret
loc_03663:
    add ax, word ptr ds:[0234Ch]
    mov word ptr ss:[bp + REC_SCREEN_OFS], ax
    mov si, ax
    mov di, word ptr ss:[bp + REC_SAVE_BUFFER]
    mov es, word ptr cs:[MainDataSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 064h
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    movsw
    movsw
    add si, bx
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_036A2:
    mov bx, dx
    mov cx, 0Dh
    mov ax, word ptr cs:[0959Ah]
    cmp word ptr ds:[02350h], 0E5Fh
    jb loc_036B7
    mov ax, word ptr cs:[0959Ch]
loc_036B7:
    mov ds, ax
loc_036B9:
    push cx
    push bx
    mov es, word ptr cs:[09592h]
    mov bl, byte ptr es:[bx]
    dec bl
    xor bh, bh
    shl bx, 1
    add bx, 08D92h
    mov si, word ptr cs:[bx]
    mov es, word ptr cs:[WorkspaceSegment]
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    movsw
    movsw
    movsw
    movsw
    add di, 060h
    sub di, 0678h
    pop bx
    add bx, 1
    pop cx
    loop loc_03752
    jmp short loc_03755
loc_03752:
    jmp near ptr loc_036B9
loc_03755:
    mov ds, word ptr cs:[MainDataSegment]
    ret

    mov word ptr cs:[05903h], 0
    mov di, word ptr cs:[058F9h]
    mov si, word ptr cs:[058FBh]
    mov cx, word ptr cs:[058FDh]
    mov bp, word ptr cs:[058FFh]
    shl bp, 1
    shl bp, 1
    cmp word ptr cs:[05905h], 0
    je loc_0378A
    mov ax, bp
    dec cx
    mul cx
    inc cx
    add si, ax
loc_0378A:
    push cx
    mov cx, word ptr cs:[058FDh]
    sub cx, word ptr cs:[05901h]
    or cx, cx
    js loc_037C6
    shr cx, 1
    jcxz loc_037C6
    dec cx
    jcxz loc_037B0
loc_037A0:
    add di, 02000h
    test di, 08000h
    je loc_037AE
    add di, 080A0h
loc_037AE:
    loop loc_037A0
loc_037B0:
    xor al, al
    mov cx, bp
    rep stosb
    sub di, bp
    add di, 02000h
    test di, 08000h
    je loc_037C6
    add di, 080A0h
loc_037C6:
    pop cx
loc_037C7:
    mov ax, word ptr cs:[05901h]
    cmp ax, word ptr cs:[058FDh]
    je loc_037F9
    add word ptr cs:[05903h], ax
    mov ax, word ptr cs:[058FDh]
    cmp ax, word ptr cs:[05903h]
    ja loc_037F4
    cmp word ptr cs:[05905h], 0
    je loc_037EE
    sub si, bp
    jmp short loc_037F0
loc_037EE:
    add si, bp
loc_037F0:
    loop loc_037C7
    jmp short loc_0381D
loc_037F4:
    sub word ptr cs:[05903h], ax
loc_037F9:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 08000h
    je loc_0380E
    add di, 080A0h
loc_0380E:
    cmp word ptr cs:[05905h], 0
    je loc_0381A
    sub si, bp
    sub si, bp
loc_0381A:
    pop cx
    loop loc_037C7
loc_0381D:
    xor al, al
    mov cx, bp
    rep stosb
    ret

loc_03824:
    mov ds, word ptr cs:[WorkspaceSegment]
loc_03829:
    mov cx, 050h
    rep movsw
    sub di, 0A0h
    add di, 02000h
    test di, 08000h
    je loc_03840
    add di, 080A0h
loc_03840:
    dec bp
    jne loc_03829
    mov ds, word ptr cs:[MainDataSegment]
    ret
; UNKNOWN: not yet classified as code or data
    db 0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h
    db 083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h
    db 023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,083h,0C7h,02Ch,0E2h,0D3h,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh
    db 0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h
    db 05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h
    db 083h,0C7h,02h,083h,0C7h,02Ch,0E2h,0CBh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,026h
    db 023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h,083h,0C6h
    db 02h,0ABh,083h,0C7h,030h,0E2h,0E7h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0F7h,0D0h
    db 026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h,05h,083h
    db 0C6h,02h,083h,0C7h,02h,083h,0C7h,030h,0E2h,0E3h,02Eh,08Eh,01Eh,096h,095h,0C3h
    db 0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,083h,0C7h,032h,0E2h,0F1h,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h
    db 02h,083h,0C7h,032h,0E2h,0EFh,02Eh,08Eh,01Eh,096h,095h,0C3h,00h,08Bh,01Ch,08Bh
    db 044h,04h,08Bh,04Ch,08h,08Bh,054h,0Ch,02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh
    db 0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h
    db 0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,021h,01Dh,026h,021h,045h
    db 02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h,025h,039h,026h,020h,045h
    db 08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh,054h,0Eh,02Eh,0C6h,06h
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh
    db 026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h
    db 026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h,0E9h,04Dh,0FFh
    db 02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,08Bh,04Ch,08h,08Bh,054h
    db 0Ch,02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h
    db 01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh
    db 0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h
    db 021h,01Dh,026h,021h,045h,02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h
    db 025h,039h,026h,020h,045h,08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh
    db 054h,0Eh,02Eh,0C6h,06h,025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
    db 025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh,026h
    db 09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h,026h
    db 08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h,0E9h,0F7h,0FEh,02Eh
    db 08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,08Bh,04Ch,08h,08Bh,054h,0Ch
    db 02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
    db 025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh
    db 0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h
    db 0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,021h,01Dh,026h,021h,045h
    db 02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h,025h,039h,026h,020h,045h
    db 08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh,054h,0Eh,02Eh,0C6h,06h
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
    db 025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
    db 039h,026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h
    db 02Eh,0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h
    db 03h,0E9h,0A1h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h
    db 04h,0F7h,0D0h,08Bh,04Ch,08h,0F7h,0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh
    db 026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h
    db 026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,075h,09Dh,02Eh,08Eh,01Eh
    db 096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h,08Bh,04Ch,08h,0F7h
    db 0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h,025h,039h,00h,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
    db 039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h
    db 0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h
    db 0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh
    db 0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h
    db 0E9h,070h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h
    db 0F7h,0D0h,08Bh,04Ch,08h,0F7h,0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h,025h
    db 039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
    db 039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h
    db 0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h
    db 0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh
    db 0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h
    db 0E9h,046h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh
    db 0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h,045h,02h,026h,020h,055h
    db 04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh
    db 026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,075h
    db 0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh,0F9h,0D0h
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h,045h
    db 02h,026h,020h,055h,04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh,0D0h
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h
    db 083h,0C6h,08h,083h,0C7h,034h,04Dh,074h,03h,0E9h,07Bh,0FFh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h
    db 045h,02h,026h,020h,055h,04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
    db 0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h
    db 02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,074h,03h,0E9h,051h
    db 0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h
    db 0B2h,0FFh,0F6h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h
    db 08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,075h,0CBh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h,0B2h,0FFh,0F6h,0D2h,0D0h
    db 0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh

; Modern grid-probe names; roles are local, broader map ownership unresolved.
; UNKNOWN: not yet classified as code or data
    db 0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h
    db 034h,04Dh,075h,0B7h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h
    db 04h,0F7h,0D0h,0B2h,0FFh,0F6h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h
    db 0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h
    db 08h,083h,0C7h,034h,04Dh,075h,0A3h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh
    db 0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h
    db 05h,026h,020h,055h,02h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h,0C7h,034h,04Dh,075h
    db 0CCh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h,055h,02h,0ADh,032h,0D2h
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h
    db 0C7h,034h,04Dh,075h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h
    db 0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h
    db 0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h,055h,02h,0ADh
    db 032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h,0C7h,034h
    db 04Dh,075h,098h,02Eh,08Eh,01Eh,096h,095h,0C3h

BlitPackedToScreenCga:
    lodsw
    mov cx, ax
    lodsw
    mov es, word ptr cs:[ScreenSegment]
    shl ax, 1
    mov bp, ax
loc_041A6:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 04000h
    je loc_041BB
    add di, 0C050h
loc_041BB:
    pop cx
    loop loc_041A6
    ret

BlitPackedStride104Cga:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    mov bp, ax
loc_041CC:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 034h
    pop cx
    loop loc_041CC
    ret

BlitPackedStride160Cga:
    mov es, word ptr cs:[WorkspaceSegment]
    lodsw
    mov cx, ax
    lodsw
    shl ax, 1
    mov bp, ax
loc_041E7:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 050h
    pop cx
    loop loc_041E7
    ret
loc_041F5:
    mov bx, word ptr ss:[bp + 2]
    cmp bx, 0E0h
    jb loc_04201
    jmp near ptr loc_025B2
loc_04201:
    shl bx, 1
    mov bx, word ptr ds:[bx + RecordRowOffsets]
    cmp bx, -1
    jne loc_0420F
    jmp near ptr loc_025B2
loc_0420F:
    mov ax, word ptr ss:[bp + 4]
    mov cx, ax
    and cx, 3
    mov word ptr ss:[bp + 012h], cx
    shr ax, 1
    shr ax, 1
    add ax, bx
    cmp word ptr ss:[bp + 024h], 0
    jne loc_04227
    ret
loc_04227:
    dec word ptr ss:[bp + 024h]
    ret

DrawOffsetFromScreenRowCga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + ScreenRowOffsets]
    xor ah, ah
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromPlayfieldRowCga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + PlayfieldRowOffsets]
    xor ah, ah
    shl ax, 1
    add ax, bx
    mov di, ax
    ret

DrawOffsetFromWideRowCga:
    mov bl, ah
    xor bh, bh
    shl bx, 1
    mov bx, word ptr ds:[bx + WideRowOffsets]
    xor ah, ah
    shl ax, 1
    add ax, bx
    mov di, ax
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,0D1h,0E8h
    db 03h,0C3h,0C3h

loc_04277:
    cmp al, 010h
    jne loc_0427E
    jmp near ptr loc_0445E
loc_0427E:
    cmp al, 011h
    jne loc_04285
    jmp near ptr loc_04445
loc_04285:
    cmp al, 0Eh
    jne loc_0428C
    jmp near ptr loc_04439
loc_0428C:
    xor ah, ah
    shl ax, 1
    shl ax, 1
    shl ax, 1
    add ax, 01816h
    mov si, ax
    mov es, word ptr cs:[ScreenSegment]
    xor bx, bx
    mov bl, byte ptr ds:[0215Eh]
    add bx, word ptr ds:[02160h]
    mov di, bx
    mov bx, 021AEh
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_042DD
    add di, 0C050h
loc_042DD:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0430D
    add di, 0C050h
loc_0430D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0433D
    add di, 0C050h
loc_0433D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0436D
    add di, 0C050h
loc_0436D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0439D
    add di, 0C050h
loc_0439D:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_043CD
    add di, 0C050h
loc_043CD:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_043FD
    add di, 0C050h
loc_043FD:
    mov al, byte ptr ds:[si]
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di], ah
    lodsb
    and al, 0Fh
    xlat
    mov ah, al
    and ah, byte ptr ds:[0215Ch]
    mov byte ptr es:[di + 1], ah
    add di, 02000h
    test di, 04000h
    je loc_0442D
    add di, 0C050h
loc_0442D:
    add byte ptr ds:[0215Eh], 2
    cmp byte ptr ds:[0215Eh], 050h
    jb loc_04444
loc_04439:
    mov byte ptr ds:[0215Eh], 0
    add word ptr ds:[02160h], 0140h
loc_04444:
    ret
loc_04445:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 0140h
    xor ah, ah
    mul cx
    mov word ptr ds:[02160h], ax
    mov al, byte ptr ss:[bp + 2]
    add al, al
    mov byte ptr ds:[0215Eh], al
    add bp, 2
    ret
loc_0445E:
    inc bp
    mov al, byte ptr ss:[bp]
    and al, 3
    mov bx, 021BEh
    xlat
    mov byte ptr ds:[0215Ch], al
    ret

    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov ax, di
    mov cx, 02000h
    rep stosw
    ret

CopyWorkspaceToScreenCga:
    mov si, word ptr ds:[0234Ch]
    mov es, word ptr cs:[ScreenSegment]
    mov ds, word ptr cs:[WorkspaceSegment]
    mov bx, 01Ah
    mov di, 0A0h
    mov bp, 0C0h
loc_04492:
    mov cx, bx
    rep movsw
    sub di, 034h
    add di, 02000h
    test di, 04000h
    je loc_044A7
    add di, 0C050h
loc_044A7:
    dec bp
    jne loc_04492
loc_044AA:
    mov ds, word ptr cs:[MainDataSegment]
CountXReturn:
    ret

ClearScreen104x200Cga:
    mov es, word ptr cs:[ScreenSegment]
    xor di, di
    mov bp, 0C8h
loc_044BA:
    mov cx, 01Ah
    xor ax, ax
    rep stosw
    sub di, 034h
    add di, 02000h
    test di, 04000h
    je loc_044D2
    add di, 0C050h
loc_044D2:
    dec bp
    jne loc_044BA
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_044D7:
    mov ax, word ptr ds:[si]
    or ax, word ptr ds:[si + 2]
    jne loc_044DF
    ret
loc_044DF:
    mov bx, word ptr cs:[0BE0h]
    add word ptr cs:[0BE0h], 2
    lodsw
    cmp word ptr cs:[0BD8h], 0
    je loc_044F7
    mov word ptr cs:[bx], di
    stosw
loc_044F7:
    mov word ptr cs:[05B9Eh], ax
    lodsw
    cmp word ptr cs:[0BD8h], 0
    je loc_04505
    stosw
loc_04505:
    mov word ptr cs:[05B9Ch], ax
    inc ax
    ret
; UNKNOWN: not yet classified as code or data
    db 00h

loc_0450C:
    call loc_044D7
    je loc_044AA
    mov cx, word ptr cs:[05B9Eh]
loc_04516:
    push cx
    mov cx, word ptr cs:[05B9Ch]
loc_0451C:
    push cx
    call loc_04537
    pop cx
    loop loc_0451C
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    add si, word ptr cs:[05B9Ch]
    pop cx
    loop loc_04516
    jmp short loc_0450C

loc_04537:
    mov bx, word ptr cs:[05B9Ch]
    mov al, byte ptr ds:[si]
    mov ah, byte ptr ds:[bx + si]
    shl bx, 1
    mov dl, byte ptr ds:[bx + si]
    add bx, word ptr cs:[05B9Ch]
    mov dh, byte ptr ds:[bx + si]
    call loc_045F6
    mov byte ptr cs:[05B95h], cl
    mov byte ptr cs:[05B99h], ch
    call loc_045F6
    mov byte ptr cs:[05B94h], cl
    mov byte ptr cs:[05B98h], ch
    call loc_045F6
    mov byte ptr cs:[05B97h], cl
    mov byte ptr cs:[05B9Bh], ch
    call loc_045F6
    mov byte ptr cs:[05B96h], cl
    mov byte ptr cs:[05B9Ah], ch
    inc si
    cmp word ptr cs:[0BD6h], 0
    je loc_045A9
    mov al, byte ptr cs:[05B98h]
    call loc_045CB
    mov al, byte ptr cs:[05B99h]
    call loc_045CB
    mov al, byte ptr cs:[05B9Ah]
    call loc_045CB
    mov al, byte ptr cs:[05B9Bh]
    call loc_045CB
    mov ax, word ptr cs:[045E4h]
    stosw
loc_045A9:
    mov al, byte ptr cs:[05B94h]
    call loc_045CB
    mov al, byte ptr cs:[05B95h]
    call loc_045CB
    mov al, byte ptr cs:[05B96h]
    call loc_045CB
    mov al, byte ptr cs:[05B97h]
    call loc_045CB
    mov ax, word ptr cs:[045E4h]
    stosw
    ret

loc_045CB:
    call loc_045CE

loc_045CE:
    rol al, 1
    rol al, 1
    rol al, 1
    rcl word ptr cs:[045E4h],1
    rol al, 1
    rcl word ptr cs:[045E4h],1
    ret
; UNKNOWN: not yet classified as code or data
    db 090h,00h,00h,00h,00h,00h,01h,01h,01h,02h,02h,02h,01h,02h,01h,01h
    db 01h,02h,02h,01h,03h

loc_045F6:
    ror dh, 1
    rcl cl, 1
    ror dl, 1
    rcl cl, 1
    ror ah, 1
    rcl cl, 1
    ror al, 1
    rcl cl, 1
    ror dh, 1
    rcl cl, 1
    ror dl, 1
    rcl cl, 1
    ror ah, 1
    rcl cl, 1
    ror al, 1
    rcl cl, 1
    ror cl, 1
    ror cl, 1
    ror cl, 1
    ror cl, 1
    cmp word ptr cs:[0BD6h], 0
    je loc_04656
    mov bx, ax
    xor ch, ch
    mov al, cl
    and al, 0Fh
    cmp al, byte ptr cs:[0]
    jne loc_0463B
    or ch, 0Fh
    and cl, 0F0h
loc_0463B:
    mov al, cl
    and al, 0F0h
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    cmp al, byte ptr cs:[0]
    jne loc_04654
    or ch, 0F0h
    and cl, 0Fh
loc_04654:
    mov ax, bx
loc_04656:
    mov word ptr cs:[045E2h], ax
    mov al, cl
    and al, 0Fh
    mov bx, 045E6h
    db 02Eh ; decoded segment override
    xlat
    mov ah, al
    mov al, cl
    shr al, 1
    shr al, 1
    shr al, 1
    shr al, 1
    and al, 0Fh
    db 02Eh ; decoded segment override
    xlat
    shl al, 1
    shl al, 1
    shl al, 1
    shl al, 1
    or al, ah
    mov cl, al
    mov ax, word ptr cs:[045E2h]
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,0FFh,0FFh,074h,03h,0E8h,010h,00h,08Bh,07Eh,010h,08Bh,076h,0Eh,081h,0C6h
    db 040h,01h,083h,0FFh,0FFh,075h,01h,0C3h,0B9h,010h,00h,0A5h,0A5h,0A5h,0A5h,0A4h
    db 083h,0C7h,02Bh,0E2h,0F6h,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0A5h,0A5h,0A4h,083h
    db 0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h
    db 0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0C3h,083h,0FFh,0FFh
    db 075h,01h,0C3h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h
    db 0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h
    db 031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0C3h,0E8h,0F3h,012h,089h
    db 046h,0Ch,03Dh,0FFh,0FFh,074h,0Fh,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h
    db 08Bh,07Eh,0Eh,0E8h,024h,00h,083h,046h,02h,010h,0E8h,0D5h,012h,089h,046h,010h
    db 083h,06Eh,02h,010h,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h
    db 010h,08Bh,0F0h,08Bh,07Eh,0Eh,081h,0C7h,040h,01h,02Eh,08Eh,06h,096h,095h,02Eh
    db 08Eh,01Eh,098h,095h,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
    db 0A4h,083h,0C6h,02Bh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,025h,012h,089h,046h,0Ch
    db 03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh
    db 07Eh,0Eh,02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0A5h,0A5h,0A4h,083h
    db 0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h
    db 0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h
    db 0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh
    db 0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,02Eh,08Eh,01Eh,096h
    db 095h,0C3h,0E8h,09Dh,011h,089h,046h,0Ch,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h
    db 04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh,02Eh,08Eh,06h,096h,095h,02Eh
    db 08Eh,01Eh,098h,095h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h
    db 083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h
    db 0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,02Eh,08Eh,01Eh,096h
    db 095h,0C3h

loc_048E6:
    mov bx, dx
    mov cx, 0Dh
    mov ax, word ptr cs:[0959Ah]
    cmp word ptr ds:[02350h], 0E5Fh
    jb loc_048FB
    mov ax, word ptr cs:[0959Ch]
loc_048FB:
    mov ds, ax
loc_048FD:
    push cx
    push bx
    mov es, word ptr cs:[09592h]
    mov bl, byte ptr es:[bx]
    dec bl
    xor bh, bh
    shl bx, 1
    add bx, 08D92h
    mov si, word ptr cs:[bx]
    mov es, word ptr cs:[WorkspaceSegment]
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    movsw
    movsw
    add di, 030h
    sub di, 033Ch
    pop bx
    add bx, 1
    pop cx
    loop loc_048FD
    mov ds, word ptr cs:[MainDataSegment]
    ret

    mov word ptr cs:[05903h], 0
    mov di, word ptr cs:[058F9h]
    mov si, word ptr cs:[058FBh]
    mov cx, word ptr cs:[058FDh]
    mov bp, word ptr cs:[058FFh]
    shl bp, 1
    cmp word ptr cs:[05905h], 0
    je loc_049A7
    mov ax, bp
    dec cx
    mul cx
    inc cx
    add si, ax
loc_049A7:
    push cx
    mov cx, word ptr cs:[058FDh]
    sub cx, word ptr cs:[05901h]
    or cx, cx
    js loc_049E3
    shr cx, 1
    jcxz loc_049E3
    dec cx
    jcxz loc_049CD
loc_049BD:
    add di, 02000h
    test di, 04000h
    je loc_049CB
    add di, 0C050h
loc_049CB:
    loop loc_049BD
loc_049CD:
    xor al, al
    mov cx, bp
    rep stosb
    sub di, bp
    add di, 02000h
    test di, 04000h
    je loc_049E3
    add di, 0C050h
loc_049E3:
    pop cx
loc_049E4:
    mov ax, word ptr cs:[05901h]
    cmp ax, word ptr cs:[058FDh]
    je loc_04A16
    add word ptr cs:[05903h], ax
    mov ax, word ptr cs:[058FDh]
    cmp ax, word ptr cs:[05903h]
    ja loc_04A11
    cmp word ptr cs:[05905h], 0
    je loc_04A0B
    sub si, bp
    jmp short loc_04A0D
loc_04A0B:
    add si, bp
loc_04A0D:
    loop loc_049E4
    jmp short loc_04A3A
loc_04A11:
    sub word ptr cs:[05903h], ax
loc_04A16:
    push cx
    mov cx, bp
    rep movsb
    sub di, bp
    add di, 02000h
    test di, 04000h
    je loc_04A2B
    add di, 0C050h
loc_04A2B:
    cmp word ptr cs:[05905h], 0
    je loc_04A37
    sub si, bp
    sub si, bp
loc_04A37:
    pop cx
    loop loc_049E4
loc_04A3A:
    xor al, al
    mov cx, bp
    rep stosb
    ret

loc_04A41:
    mov ds, word ptr cs:[WorkspaceSegment]
loc_04A46:
    mov cx, 028h
    rep movsw
    sub di, 050h
    add di, 02000h
    test di, 04000h
    je loc_04A5C
    add di, 0C050h
loc_04A5C:
    dec bp
    jne loc_04A46
    mov ds, word ptr cs:[MainDataSegment]
    ret

loc_04A65:
    push di
loc_04A66:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    mov bx, word ptr ds:[bx - 03A17h]
    mov si, word ptr ds:[bx]
    lodsw
    mov word ptr ds:[020A4h], ax
    cmp ax, 0FFFFh
    jne loc_04A7E
    jmp near ptr loc_04C74
loc_04A7E:
    cmp ax, word ptr ds:[0A978h]
    je loc_04A87
    jmp near ptr loc_04C74
loc_04A87:
    mov byte ptr ds:[020A2h], 1
    lodsw
    cmp ax, 0FFFFh
    jne loc_04A98
    mov byte ptr ds:[020A2h], 0
    lodsw
loc_04A98:
    mov cx, ax
    lodsw
    mov word ptr ds:[0206Ch], ax
    lodsw
    mov word ptr ds:[0206Eh], ax
    push bx
    mov bx, word ptr ds:[020A4h]
    and bx, 03Fh
    mov bl, byte ptr ds:[bx - 037E6h]
    xor bh, bh
    mov ax, bx
    pop bx
    mov word ptr ds:[02070h], ax
    mov word ptr ds:[bx], si
    mov si, cx
    lodsw
    mov word ptr ds:[02072h], ax
    lodsw
    mov word ptr ds:[02074h], ax
    lodsw
    mov word ptr ds:[02076h], ax
    lodsw
    mov cx, ax
    call far ptr loc_0F953
loc_04ACE:
    push cx
    call FindFreeRecordPoolA
    cmp bx, -1
    jne loc_04ADA
    jmp near ptr loc_04C70
loc_04ADA:
    mov ax, 0FFFFh
    cmp word ptr ds:[0209Ah], -1
    je loc_04AF5
    push bx
    mov bx, word ptr ds:[0209Ah]
    inc byte ptr ds:[bx + REC_STATUS]
    mov al, byte ptr ds:[02070h]
    mov byte ptr ds:[bx + 1], al
    pop bx
    mov ax, word ptr ds:[02098h]
loc_04AF5:
    mov word ptr ds:[bx + REC_SLOT_INDEX], ax
    mov word ptr ds:[bx + REC_STATUS], 1
    mov ax, word ptr ds:[02074h]
    mov word ptr ds:[bx + REC_DRAW_PASS], ax
    mov word ptr ds:[bx + REC_SPRITE], 0
    mov ax, word ptr ds:[si + 2]
    add ax, word ptr ds:[0206Eh]
    mov word ptr ds:[bx + REC_Y], ax
    mov ax, word ptr ds:[si]
    add ax, word ptr ds:[0206Ch]
    mov word ptr ds:[bx + REC_X], ax
    mov word ptr ds:[bx + REC_SAVED_X], ax
    mov word ptr ds:[bx + REC_SAVED_Y], 0
    mov word ptr ds:[bx + REC_DIRECTION], 4
    mov ax, word ptr ds:[02072h]
    mov word ptr ds:[bx + REC_SIZE_CLASS], ax
    mov word ptr ds:[bx + REC_KIND], 4
    mov ax, word ptr ds:[02076h]
    mov word ptr ds:[bx + REC_TYPE], ax
    cmp word ptr ds:[bx + REC_DRAW_PASS], 1
    jne loc_04B41
    jmp near ptr loc_04BE7
loc_04B41:
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je loc_04B4A
    jmp near ptr loc_04BE7
loc_04B4A:
    and word ptr ds:[bx + REC_Y], 0FFF0h
    and word ptr ds:[bx + REC_X], 0FFF0h
    mov ax, word ptr ds:[bx + REC_X]
    mov word ptr ds:[020A0h], ax
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    mov word ptr ds:[0209Ch], ax
    push si
    push bx
    mov es, word ptr cs:[09592h]
    mov ax, word ptr ds:[bx + REC_Y]
    mov bx, word ptr ds:[02350h]
    add bx, 0Dh
    or ax, ax
    je loc_04B92
    js loc_04B86
loc_04B7A:
    or ax, ax
    je loc_04B92
    sub bx, 0Dh
    sub ax, 010h
    jmp short loc_04B7A
loc_04B86:
    or ax, ax
    je loc_04B92
    add bx, 0Dh
    add ax, 010h
    jmp short loc_04B86
loc_04B92:
    mov word ptr ds:[0209Eh], bx
loc_04B96:
    mov si, word ptr ds:[0209Eh]
    mov ax, word ptr ds:[0209Ch]
    add si, ax
    mov al, byte ptr es:[si]
; Same byte-attribute table as ReadIndexedByteAttribute; this consumer needs zero/nonzero.
    mov bx, offset ByteAttributeTable
    xlat
    or al, al
    je loc_04BD7
    cmp word ptr ds:[020A0h], 060h
    jb loc_04BC4
    dec word ptr ds:[0209Ch]
    cmp word ptr ds:[0209Ch], -1
    jne loc_04B96
    mov word ptr ds:[0209Ch], 0Ch
    jmp short loc_04B96
loc_04BC4:
    inc word ptr ds:[0209Ch]
    cmp word ptr ds:[0209Ch], 0Dh
    jb loc_04BD5
    mov word ptr ds:[0209Ch], 0
loc_04BD5:
    jmp short loc_04B96
loc_04BD7:
    mov ax, word ptr ds:[0209Ch]
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    pop bx
    mov word ptr ds:[bx + REC_X], ax
    pop si
loc_04BE7:
    mov word ptr ds:[bx + REC_HIT_POINTS], 1
    mov ax, word ptr ds:[LevelIndex]
    inc ax
    mov word ptr ds:[bx + REC_HIT_POINTS], ax
    cmp word ptr ds:[bx + REC_SIZE_CLASS], 1
    je loc_04BFE
    mov word ptr ds:[bx + REC_HIT_POINTS], 0Ch
loc_04BFE:
    mov word ptr ds:[bx + REC_FLASH_TIMER], 0
    cmp word ptr ds:[bx + REC_TYPE], 021h
    jne loc_04C0E
    call far ptr loc_0F9F9
loc_04C0E:
    mov ax, 0A484h
    cmp word ptr ds:[bx + 018h], 013h
    jne loc_04C1C
    call far ptr loc_0F9F9
loc_04C1C:
    mov ax, 0A4E8h
    cmp word ptr ds:[bx + 018h], 015h
    jne loc_04C2A
    call far ptr loc_0F9F9
loc_04C2A:
    mov ax, 0A7A2h
    cmp word ptr ds:[bx + 018h], 01Ch
    jne loc_04C38
    call far ptr loc_0F9F9
loc_04C38:
    mov ax, 0A82Eh
    cmp word ptr ds:[bx + 018h], 01Fh
    jne loc_04C46
    call far ptr loc_0F9F9
loc_04C46:
    mov ax, 0A638h
    cmp word ptr ds:[bx + 018h], 07Dh
    jne loc_04C54
    call far ptr loc_0F9F9
loc_04C54:
    mov ax, 0A6F4h
    cmp word ptr ds:[bx + 018h], 07Eh
    jne loc_04C62
    call far ptr loc_0F9F9
loc_04C62:
    add si, 4
    pop cx
    loop loc_04C6A
    jmp short loc_04C6D
loc_04C6A:
    jmp near ptr loc_04ACE
loc_04C6D:
    jmp near ptr loc_04A66
loc_04C70:
    pop cx
    jmp near ptr loc_04A66
loc_04C74:
    pop di
    ret

loc_04C76:
    mov si, 0C6C1h
    mov cx, 028h
loc_04C7C:
    lodsw
    lodsw
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 04C8Ah]
    dw loc_04C90, loc_04CA6, loc_04CBE    ; per VideoAdapter: CGA, EGA, Tandy

loc_04C90:
    mov bx, ax
    shr ax, 1
    shr ax, 1
    mov word ptr ds:[si - 2], ax
    and bx, 3
    add bx, 0C803h
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[si], bx
    jmp short loc_04CE7

loc_04CA6:
    mov bx, ax
    shr ax, 1
    shr ax, 1
    shr ax, 1
    mov word ptr ds:[si - 2], ax
    and bx, 7
    add bx, 0C807h
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[si], bx
    jmp short loc_04CE7

loc_04CBE:
    mov bx, ax
    shr ax, 1
    mov word ptr ds:[si - 2], ax
    and bx, 1
    add bx, 0C80Fh
    mov bx, word ptr ds:[bx]
    mov word ptr ds:[si], bx
    cmp word ptr ds:[0C818h], 0
    je loc_04CE7
    dec word ptr ds:[0C818h]
    jne loc_04CE7
    and byte ptr ds:[0C80Fh], 7
    and byte ptr ds:[0C810h], 070h
loc_04CE7:
    add si, 2
    loop loc_04C7C
    ret

loc_04CED:
    mov es, word ptr cs:[WorkspaceSegment]
    mov si, 0C6C1h
    mov di, 0C7B1h
    mov bp, 04D4Dh
    mov cx, 014h
    call loc_04D15
    mov bp, 04D51h
    mov cx, 0Ah
    call loc_04D15
    mov cx, 0Ah
    call loc_04D15
    mov word ptr ds:[di], 0FFFFh
    ret

loc_04D15:
    lodsw
    mov bx, ax
    shl bx, 1
    add bx, 09A08h
    mov bx, word ptr ds:[bx]
    add bx, word ptr ds:[0234Ch]
    lodsw
    add bx, ax
    lodsw
    cmp byte ptr es:[bx], 0
    jne loc_04D61
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_04D59
    cmp byte ptr es:[bx + 01Ah], 0
    jne loc_04D61
    cmp byte ptr es:[bx + 034h], 0
    jne loc_04D61
    cmp byte ptr es:[bx + 04Eh], 0
    jne loc_04D61
    jmp bp
; UNKNOWN: not yet classified as code or data
    db 026h,088h,047h,04Eh,026h,088h,047h,034h,026h,088h,047h,01Ah
loc_04D59:
    mov byte ptr es:[bx], al
    mov word ptr ds:[di], bx
    add di, 2
loc_04D61:
    loop loc_04D15
    ret

loc_04D64:
    mov es, word ptr cs:[WorkspaceSegment]
    mov si, 0C7B1h
    mov cx, 028h
loc_04D6F:
    lodsw
    cmp ax, 0FFFFh
    je loc_04D94
    mov di, ax
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    jne loc_04D8E
    mov byte ptr es:[di + 04Eh], 0
    mov byte ptr es:[di + 034h], 0
    mov byte ptr es:[di + 01Ah], 0
loc_04D8E:
    mov byte ptr es:[di], 0
    loop loc_04D6F
loc_04D94:
    ret
loc_04D95:
    add word ptr ds:[020A6h], 2
    cmp word ptr ds:[020A6h], 020C7h
    jb loc_04DA8
    mov word ptr ds:[020A6h], 020A8h
loc_04DA8:
    mov bx, word ptr ds:[020A6h]
    mov bx, word ptr ds:[bx]
    ret

loc_04DAF:
    lodsw
    mov di, ax
    lodsw
    mov dx, ax
    lodsw
    mov word ptr ds:[020C8h], ax
    lodsw
    cmp word ptr ds:[02350h], ax
    ret

loc_04DBF:
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    add bx, 0C601h
    mov si, word ptr ds:[bx]
    mov cx, 3
loc_04DCE:
    call loc_04DAF
    jb loc_04DD8
    loop loc_04DCE
    call loc_04DAF
loc_04DD8:
    mov si, dx
    push si
    push di
    push word ptr ds:[0A978h]
    call loc_00B3E
    pop word ptr ds:[0A978h]
    pop di
    mov word ptr ds:[02350h], di
    push di
    call loc_04E26
    mov word ptr ds:[02350h], 0E93h
    pop di
    pop si
    call loc_04E0D
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    add bx, 020CAh
    mov bx, word ptr ds:[bx]
    mov ax, word ptr ds:[020C8h]
    mov word ptr ds:[bx], ax
    ret

loc_04E0D:
    push di
    push si
    call loc_0A781
    pop si
    pop di
    cmp word ptr ds:[02350h], di
    ja loc_04E0D
    cmp word ptr ds:[0234Eh], 0
    jne loc_04E0D
    mov word ptr ds:[0A978h], si
    ret

loc_04E26:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
    mov es, word ptr cs:[09592h]
    mov si, word ptr ds:[02350h]
    mov cx, 09Ch
loc_04E3B:
    dec si
    mov bx, word ptr ds:[LevelIndex]
    shl bx, 1
    mov bx, word ptr ds:[bx + 020D6h]
loc_04E46:
    cmp word ptr cs:[bx], -1
    je loc_04E69
    mov al, byte ptr es:[si]
    xor ah, ah
    cmp ax, word ptr cs:[bx]
    jne loc_04E5A
    jmp word ptr cs:[bx + 2]
loc_04E5A:
    add bx, 4
    jmp short loc_04E46
; UNKNOWN: not yet classified as code or data
    db 026h,0C6h,04h,028h,0EBh,04h,026h,0C6h,04h,01h
loc_04E69:
    loop loc_04E3B
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Show "SWAP DISKS" or "READ ERROR" (by FileStatus), wait for a primary button press
; and release, then blank the message.
PromptLoadErrorWaitFire:
    mov bp, 020E2h
    cmp word ptr ds:[FileStatus], FILE_STATUS_OPEN_FAILED
    je loc_04E82
    mov bp, 02100h
loc_04E82:
    call loc_0518C
loc_04E85:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    jne loc_04E85
loc_04E8F:
    call PollInputBits
    cmp byte ptr ds:[InputBits], IN_BUTTON_PRIMARY
    je loc_04E8F
    mov bp, 0211Eh
    jmp near ptr loc_0518C

; Save the current INT 09h vector in KbdSavedInt09 and install
; Interrupt09KeyboardHandler. The old handler is never chained to.
InstallKeyboardVector09:
    push ds
    push es
    mov ah, DOS_GET_VECTOR
    mov al, 9
    int 021h
    mov di, offset KbdSavedInt09
    mov word ptr ds:[di], es
    mov word ptr ds:[di + 2], bx
    pop es
    push ds
    push cs
    pop ds
    mov dx, 04ED2h
    mov ah, DOS_SET_VECTOR
    mov al, 9
    int 021h
    pop ds
    pop ds
    ret

; Put back the INT 09h vector saved by InstallKeyboardVector09.
RestoreKeyboardVector09:
    push ds
    mov di, offset KbdSavedInt09
    mov dx, word ptr ds:[di + 2]
    mov ax, word ptr ds:[di]
    mov ds, ax
    mov ah, DOS_SET_VECTOR
    mov al, 9
    int 021h
    pop ds
    ret
; IRQ1: acknowledge the scancode through PPI port B, record make codes in
; KeyLastMakeCode and keep KeyDownTable current (E0/E1 prefixes clear entries
; 60h/61h). Alt+X leaves through ShutdownGame without IRET, abandoning the interrupt frame.
Interrupt09KeyboardHandler:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push bp
    push es
    push ds
    mov ds, word ptr cs:[MainDataSegment]
    in al, KBD_DATA_PORT
    mov bl, al
    in al, PPI_PORT_B
    mov ah, al
    or al, PPI_KBD_ACK
    out PPI_PORT_B, al
    xchg ah, al
    out PPI_PORT_B, al
    mov al, bl
    xor ah, ah
    mov bx, offset KeyDownTable
    test al, SCAN_RELEASE_BIT
    jne @@break_code
    mov byte ptr ds:[KeyLastMakeCode], al
    add bx, ax
    mov byte ptr ds:[bx], KEY_STATE_DOWN
    cmp bx, offset KeyDownTable + SCAN_X
    jne @@acknowledge_irq
    cmp byte ptr ds:[KeyDownTable + SCAN_ALT], KEY_STATE_DOWN
    jne @@acknowledge_irq
    mov al, PIC_EOI_IRQ1
    out PIC1_COMMAND_PORT, al
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    jmp near ptr ShutdownGame
    jmp short @@acknowledge_irq     ; unreachable after the Alt+X exit jump
@@break_code:
    and al, SCAN_CODE_MASK
    add bx, ax
    mov byte ptr ds:[bx], KEY_STATE_UP
@@acknowledge_irq:
    mov al, PIC_EOI_IRQ1
    out PIC1_COMMAND_PORT, al
    pop ds
    pop es
    pop bp
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    iret
; UNKNOWN: not yet classified as code or data
    db 02Eh,083h,03Eh,0BCh,095h,00h,074h,01h,0C3h,0E8h,080h,00h,0B8h,040h,00h,08Eh
    db 0C0h,026h,0A0h,065h,00h,0Ch,04h,0BAh,0D8h,03h,0EEh,026h,0A2h,065h,00h,0C3h

loc_04F57:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_04F60
    ret
loc_04F60:
    call loc_04F8C
    mov ah, 0Bh
    mov bh, 1
    mov bl, 0
    int 010h
    mov ax, 040h
    mov es, ax
    mov al, byte ptr es:[065h]
    and al, 0FBh
    mov dx, 03D8h
    out dx, al
    mov byte ptr es:[065h], al
    mov al, byte ptr es:[066h]
    and al, 0DFh
    or al, 0
    inc dx
    out dx, al
    mov byte ptr es:[066h], al

loc_04F8C:
    mov ax, 040h
    mov es, ax
    mov al, byte ptr es:[066h]
    or al, 010h
    mov byte ptr es:[066h], al
    mov dx, 03D9h
    out dx, al
    ret
; UNKNOWN: not yet classified as code or data
    db 02Eh,083h,03Eh,0BCh,095h,00h,074h,01h,0C3h,0E8h,03h,00h,0E8h,0B4h,0FFh,0B8h
    db 040h,00h,08Eh,0C0h,026h,0A0h,066h,00h,024h,0EFh,026h,0A2h,066h,00h,0BAh,0D9h
    db 03h,0EEh,0C3h

loc_04FC3:
    cmp word ptr cs:[VideoAdapter], VIDEO_CGA
    je loc_04FCC
    ret
loc_04FCC:
    call loc_04F8C
    mov ah, 0Bh
    mov bh, 1
    mov bl, 1
    int 010h
    mov ax, 040h
    mov es, ax
    mov al, byte ptr es:[065h]
    and al, 0FBh
    mov dx, 03D8h
    out dx, al
    mov byte ptr es:[065h], al
    mov al, byte ptr es:[066h]
    and al, 0DFh
    or al, 020h
    inc dx
    out dx, al
    mov byte ptr es:[066h], al
    ret

loc_04FF9:
    mov si, word ptr ss:[bp + 8]
    cmp si, 3
    jae loc_05059
    shl si, 1
    shl si, 1
    add si, 0214Eh
    push word ptr ss:[bp + REC_Y]
    push word ptr ss:[bp + REC_X]
    lodsw
    add word ptr ss:[bp + REC_Y], ax
    lodsw
    add word ptr ss:[bp + REC_X], ax
; Convert temporarily adjusted record coordinates to the13-byte-row grid.
; The next ADD overwrites the grid helper flags; later attribute ZF is live.
    call ComputeRecordGridOffset
    add bx, 0Dh
    mov ax, word ptr ds:[GridYSum]
    and ax, 0Fh
    cmp ax, 0Ah
    mov cx, 1
    jbe loc_0502E
    mov cx, 2
loc_0502E:
    push cx
    push bx
    call ReadIndexedByteAttribute
    jne loc_05051
    test word ptr ss:[bp + REC_X], 0Fh
    je loc_05042
    inc bx
    call ReadIndexedByteAttribute
    jne loc_05051
loc_05042:
    pop bx
    sub bx, 0Dh
    pop cx
    loop loc_0502E
    pop word ptr ss:[bp + REC_X]
    pop word ptr ss:[bp + REC_Y]
    clc
    ret
loc_05051:
    pop bx
    pop cx
    pop word ptr ss:[bp + REC_X]
    pop word ptr ss:[bp + REC_Y]
loc_05059:
    stc
    ret

; Near leaf. ES=word CS:9592. Read byte ES:BX as unsigned index; read byte DS:[C3AA+index]. Return AX=zero-
; extended attribute, SI=C3AA+index, ES=selected segment. Final OR AL,AL sets ZF/SF/PF from attribute and clears
; CF/OF (AF unspecified). Preserve BX,CX,DX,BP,DI,DS,SS and IF/DF. No memory writes except ordinary call stack.
; Requires valid segment/lookup storage; no tile or entity identity asserted.
; Lookup chain: source byte -> attribute byte; callers consume zero/nonzero.
ReadIndexedByteAttribute:
    mov si, offset ByteAttributeTable
    mov es, word ptr cs:[AttributeSourceSegment]
    mov al, byte ptr es:[bx]
    xor ah, ah
    add si, ax
    mov al, byte ptr ds:[si]
    or al, al
    ret
GridOffsetNegativeY:
    mov bx, 0FFFFh
    ret

; Near entry5073 plus shared return tail506F. AX=wrapped16-bit(DS:234E + SS:[BP+REC_Y]); store it to DS:215A. If
; its sign bit is set, return BX=FFFF via506F, preserving CX/DX and leaving AX=sum. Otherwise row=AX>>4
; unsigned; DX=row, CX=4*row, AX=SS:[BP+REC_X]>>4 unsigned; BX=DS:2350-13*row+AX modulo65536. Preserve
; SI,DI,BP,DS,ES,SS and IF/DF. Flags on negative path come from Y ADD; normal path from final BX ADD.
; Caller4FF9 needs no returned flags;4FF9 immediately overwrites them at501A. Memory writes only215A, apart
; from stack. Ordinary record and state are disjoint; no silent saturation or signed division.
ComputeRecordGridOffset:
    mov ax, word ptr ds:[0234Eh]
    add ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[GridYSum], ax
    js GridOffsetNegativeY
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    mov dx, ax
    shl ax, 1
    shl ax, 1
    mov cx, ax
    shl ax, 1
    add ax, cx
    add ax, dx
    mov bx, word ptr ds:[02350h]
    sub bx, ax
    mov ax, word ptr ss:[bp + REC_X]
    and ax, 0FFF0h
    shr ax, 1
    shr ax, 1
    shr ax, 1
    shr ax, 1
    add bx, ax
    ret

; Mark every key as released, then fall through into FlushBiosKeyboardBuffer.
ClearKeyDownTable:
    mov es, word ptr cs:[MainDataSegment]
    mov di, offset KeyDownTable
    xor al, al
    mov cx, KEY_DOWN_COUNT
    rep stosb

; Empty the BIOS keyboard buffer by setting its tail to its head (low bytes only,
; which suffices for the standard buffer at 0040:001E..003D).
FlushBiosKeyboardBuffer:
    cli
    xor ax, ax
    mov es, ax
    mov al, byte ptr es:[BIOS_KBD_BUFFER_HEAD]
    mov byte ptr es:[BIOS_KBD_BUFFER_TAIL], al
    sti
    ret

; Wait for one video frame. Used as the game's delay unit: 250 frames at startup,
; 200 after a fatal error, 25 between calibration samples.
WaitVerticalRetrace:
    jmp near ptr WaitVerticalRetracePulse
; UNKNOWN: not yet classified as code or data
    db 01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,08Dh,0B0h,080h,03Eh,0BEh,098h,00h,075h,0F6h
    db 01Fh,0C3h,01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,07Bh,0B0h,080h,03Eh,0BEh,098h,00h
    db 074h,0F6h,01Fh,0C3h,0E8h,0EBh,0FFh,0EBh,0D7h,0B4h,00h,02Eh,083h,03Eh,0BCh,095h
    db 02h,074h,011h,0BAh,0DAh,03h,0ECh,0BAh,0C0h,03h,0B0h,011h,0EEh,08Ah,0C4h,0EEh
    db 0B0h,020h,0EEh,0C3h,0B4h,00h,0BAh,0DAh,03h,0B0h,02h,0EEh,0BAh,0DEh,03h,08Ah
    db 0C4h,0EEh,0C3h

loc_0511F:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_05128
    ret
loc_05128:
    inc word ptr cs:[0515Eh]
    and word ptr cs:[0515Eh], 1
    mov word ptr cs:[ScreenSegment], 0A000h
    jne loc_0513D
    ret
loc_0513D:
    mov word ptr cs:[ScreenSegment], 0A200h
    ret

loc_05145:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_0514E
    ret
loc_0514E:
    mov word ptr cs:[0515Eh], 0
    mov word ptr cs:[ScreenSegment], 0A000h
    jmp short loc_05160
; UNKNOWN: not yet classified as code or data
    db 00h,00h

loc_05160:
    cmp word ptr cs:[VideoAdapter], VIDEO_EGA
    je loc_05169
    ret
loc_05169:
    xor bx, bx
    cmp word ptr cs:[0515Eh], 0
    je loc_05176
    mov bx, 02000h
loc_05176:
    mov dx, CRT_STATUS_PORT
    in al, dx
    test al, 8
loc_0517C:
    in al, dx
    test al, 8
    jne loc_0517C
    cli
    sub dl, 6
    mov ah, bh
    mov al, 0Ch
    out dx, ax
    sti
    ret

loc_0518C:
    mov al, byte ptr ss:[bp]
    or al, al
    jne loc_05194
    ret
loc_05194:
    call loc_0519A
    inc bp
    jmp short loc_0518C

loc_0519A:
    mov es, word ptr cs:[MainDataSegment]
    cmp word ptr ds:[021A2h], 0
    je loc_051B8
    mov bx, word ptr cs:[VideoAdapter]
    shl bx, 1
    jmp word ptr cs:[bx + 051B2h]
    dw loc_04277, loc_025FE, loc_03153    ; per VideoAdapter: CGA, EGA, Tandy
loc_051B8:
    cmp al, 010h
    je loc_051F3
    cmp al, 011h
    je loc_051D6
    mov es, word ptr cs:[09594h]
    mov di, word ptr ds:[02160h]
    mov ah, byte ptr ds:[0215Ch]
    mov word ptr es:[di], ax
    add word ptr ds:[02160h], 2
    ret
loc_051D6:
    mov al, byte ptr ss:[bp + 1]
    mov cx, 050h
    xor ah, ah
    mul cx
    mov bx, ax
    mov al, byte ptr ss:[bp + 2]
    xor ah, ah
    shl ax, 1
    add bx, ax
    mov word ptr ds:[02160h], bx
    add bp, 2
    ret
loc_051F3:
    inc bp
    mov al, byte ptr ss:[bp]
    mov byte ptr ds:[0215Ch], al
    ret
; UNKNOWN: not yet classified as code or data
    db 032h,0C0h,08Ah,0F8h,0B4h,010h,0B0h,01h,0CDh,010h,0C3h,0C7h,06h,0C2h,021h,01h
    db 00h,0E8h,07h,00h,0C7h,06h,0C2h,021h,00h,00h,0C3h,032h,0DBh,0B9h,0F0h,0D8h
    db 0E8h,015h,00h,0B9h,018h,0FCh,0E8h,0Fh,00h,0B9h,09Ch,0FFh,0E8h,09h,00h,0B1h
    db 0F6h,0E8h,04h,00h,08Ah,0C2h,0EBh,01Dh,032h,0C0h,03h,0D1h,0FEh,0C0h,072h,0FAh
    db 02Bh,0D1h,0FEh,0C8h,075h,0Fh,083h,03Eh,0C2h,021h,01h,074h,06h,0Ah,0DBh,0B0h
    db 020h,074h,06h,032h,0C0h,0FEh,0C3h,04h,030h,052h,051h,053h,083h,03Eh,0C2h,021h
    db 01h,074h,07h,0E8h,039h,0FFh,05Bh,059h,05Ah,0C3h,088h,05h,047h,0EBh,0F7h

loc_0526A:
    mov es, word ptr cs:[WorkspaceSegment]
    xor di, di
    mov ax, di
    mov cx, 08000h
    cmp word ptr ds:[021C4h], 0
    je loc_05280
    mov cx, 04000h
loc_05280:
    rep stosw
    ret

; Insert ScoreBcd into the high-score table (532D) and save hiscore.dat if it qualified.
UpdateHighScoreTable:
    mov word ptr ds:[02288h], 0
    call loc_05BEE
    mov bp, offset ScoreBcd
    call loc_0532D
    cmp word ptr ds:[02288h], 0
    jne SaveHiscoreFile
    ret

; Store the current settings into the high-score block, encode it, append the checksum
; and write hiscore.dat, then decode the block again for continued use.
SaveHiscoreFile:
    mov bx, word ptr cs:[VideoAdapter]
    call far ptr SaveSettingsToHiscoreBlock
    call far ptr XorCodeHiscoreBlock
    mov word ptr ds:[si], ax
    mov word ptr ds:[FileBufferSegment], seg StateData
    mov word ptr ds:[FileBufferOffset], offset HiscoreBlock
    mov word ptr ds:[FileByteCount], 0AEh
    mov word ptr ds:[FileNamePtr], offset HiscoreFileName
    call SaveBufferToFile
    mov si, offset HiscoreBlock
    call far ptr XorCodeHiscoreBlock
    ret
MAIN ends

FAR0F7F segment para public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
; Far. Write the 27 settings bytes at SavedSettings: sound option, joystick
; thresholds, input mode, key table A, video adapter (from BX), sound module letter and
; words DS:BEDA/BEDC (roles unknown).
SaveSettingsToHiscoreBlock:
    mov di, offset SavedSettings
    mov ax, seg StateData
    mov es, ax
    mov ax, word ptr ds:[SoundOption]
    stosw
    mov si, offset JoyXLowThreshold
    mov cx, JOY_THRESHOLD_WORDS
    rep movsw
    mov ax, word ptr ds:[InputDeviceMode]
    stosw
    mov si, offset KeyBitScancodesA
    mov cx, KEY_BIT_SCANCODE_COUNT
    rep movsb
    mov ax, bx
    stosw
    mov al, byte ptr ds:[SoundModuleSelect]
    stosb
    mov ax, word ptr ds:[0BEDAh]
    stosw
    mov ax, word ptr ds:[DifficultySetting]
    stosw
    retf

; Far. Mirror of SaveSettingsToHiscoreBlock. Also derives SfxEnabled and
; ModuleSoundEnabled from the sound option, copies key-table A slot 2 to table B, and
; returns the saved video adapter in BX instead of storing it.
LoadSettingsFromHiscoreBlock:
    mov si, offset SavedSettings
    mov ax, seg StateData
    mov es, ax
    lodsw
    mov word ptr ds:[SoundOption], ax
    mov bx, ax
    shl bx, 1
    mov bx, word ptr ds:[bx + SoundOptionFlags]
    mov byte ptr ds:[SfxEnabled], bh
    mov byte ptr ds:[ModuleSoundEnabled], bl
    mov di, offset JoyXLowThreshold
    mov cx, JOY_THRESHOLD_WORDS
    rep movsw
    lodsw
    mov word ptr ds:[InputDeviceMode], ax
    mov di, offset KeyBitScancodesA
    mov cx, KEY_BIT_SCANCODE_COUNT
    rep movsb
    mov al, byte ptr ds:[KeyBitScancodesA + KEY_SLOT_SECONDARY]
    mov byte ptr ds:[KeyBitScancodesB + KEY_SLOT_SECONDARY], al
    lodsw
    mov bx, ax
    lodsb
    mov byte ptr ds:[SoundModuleSelect], al
    lodsw
    mov word ptr ds:[0BEDAh], ax
    lodsw
    mov word ptr ds:[DifficultySetting], ax
    retf

; Far. Self-inverse obfuscation of the high-score block: each byte is XORed with AAh and
; with its countdown index (ACh..1). Returns AX = 16-bit sum of the resulting bytes,
; used as the file checksum.
XorCodeHiscoreBlock:
    mov si, offset HiscoreBlock
    mov cx, HISCORE_BLOCK_BYTES
    xor ax, ax
loc_0F86E:
    xor byte ptr ds:[si], 0AAh
    xor byte ptr ds:[si], cl
    add al, byte ptr ds:[si]
    adc ah, 0
    inc si
    loop loc_0F86E
    retf
FAR0F7F ends
end