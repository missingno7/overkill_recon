; Everything in segment frame FAR0F7F; modern file boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn FarCallMainNearViaAX:far
extrn FarCallMainNearViaBP:far
extrn InputDeviceMode:far
extrn JoyXLowThreshold:far
extrn KeepLivesFlag:far
extrn KeyLastMakeCode:far
extrn LevelSkipEnabled:far
extrn ModuleSoundEnabled:far
extrn SfxEnabled:far
extrn SoundModuleSelect:far
extrn SoundOption:far
extrn StateData:far
FAR0F7F segment para public 'CODE'
assume cs:FAR0F7F,ds:nothing,ss:nothing,es:nothing
public LoadSettingsFromHiscoreBlock
public SaveSettingsToHiscoreBlock
public WaitAllKeysReleased
public XorCodeHiscoreBlock
public loc_0F87C
public loc_0F953
public loc_0F980
public loc_0F99D
public loc_0F9F9
public loc_0FA6A
public loc_0FC42
public loc_0FC63
public loc_1000D
public loc_10112
public loc_10170
; Far. Write the 27 settings bytes at SAVED_SETTINGS: sound option, joystick
; thresholds, input mode, key table A, video adapter (from BX), sound module letter and
; words DS:BEDA/BEDC (roles unknown).
SaveSettingsToHiscoreBlock:
    mov di, SAVED_SETTINGS
    mov ax, seg StateData
    mov es, ax
    mov ax, word ptr ds:[SoundOption]
    stosw
    mov si, offset JoyXLowThreshold
    mov cx, JOY_THRESHOLD_WORDS
    rep movsw
    mov ax, word ptr ds:[InputDeviceMode]
    stosw
    mov si, KEY_BIT_SCANCODES_A
    mov cx, KEY_BIT_SCANCODE_COUNT
    rep movsb
    mov ax, bx
    stosw
    mov al, byte ptr ds:[SoundModuleSelect]
    stosb
    mov ax, word ptr ds:[0BEDAh]
    stosw
    mov ax, word ptr ds:[0BEDCh]
    stosw
    retf

; Far. Mirror of SaveSettingsToHiscoreBlock. Also derives SfxEnabled and
; ModuleSoundEnabled from the sound option, copies key-table A slot 2 to table B, and
; returns the saved video adapter in BX instead of storing it.
LoadSettingsFromHiscoreBlock:
    mov si, SAVED_SETTINGS
    mov ax, seg StateData
    mov es, ax
    lodsw
    mov word ptr ds:[SoundOption], ax
    mov bx, ax
    shl bx, 1
    mov bx, word ptr ds:[bx + SOUND_OPTION_FLAGS]
    mov byte ptr ds:[SfxEnabled], bh
    mov byte ptr ds:[ModuleSoundEnabled], bl
    mov di, offset JoyXLowThreshold
    mov cx, JOY_THRESHOLD_WORDS
    rep movsw
    lodsw
    mov word ptr ds:[InputDeviceMode], ax
    mov di, KEY_BIT_SCANCODES_A
    mov cx, KEY_BIT_SCANCODE_COUNT
    rep movsb
    mov al, byte ptr ds:[KEY_BIT_SCANCODES_A + KEY_SLOT_SECONDARY]
    mov byte ptr ds:[KEY_BIT_SCANCODES_B + KEY_SLOT_SECONDARY], al
    lodsw
    mov bx, ax
    lodsb
    mov byte ptr ds:[SoundModuleSelect], al
    lodsw
    mov word ptr ds:[0BEDAh], ax
    lodsw
    mov word ptr ds:[0BEDCh], ax
    retf

; Far. Self-inverse obfuscation of the high-score block: each byte is XORed with AAh and
; with its countdown index (ACh..1). Returns AX = 16-bit sum of the resulting bytes,
; used as the file checksum.
XorCodeHiscoreBlock:
    mov si, HISCORE_BLOCK
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

loc_0F87C:
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
    mov bx, 09792h
    call loc_0F932
    jne loc_0F8AB
    mov byte ptr ds:[0978Ch], 1
loc_0F8AB:
    ret

loc_0F8AC:
    mov bx, 097A4h
    call loc_0F932
    jne loc_0F8B9
    mov byte ptr ds:[KeepLivesFlag], 1
loc_0F8B9:
    ret

loc_0F8BA:
    mov bx, 097B8h
    call loc_0F932
    jne loc_0F8C7
    mov byte ptr ds:[0978Eh], 1
loc_0F8C7:
    ret

loc_0F8C8:
    mov bx, 097C7h
    call loc_0F932
    jne loc_0F8D5
    mov byte ptr ds:[LevelSkipEnabled], 1
loc_0F8D5:
    ret

loc_0F8D6:
    mov bx, 097D7h
    call loc_0F932
    jne loc_0F8E3
    mov byte ptr ds:[09790h], 1
loc_0F8E3:
    ret

loc_0F8E4:
    mov bx, 097EEh
    call loc_0F932
    jne loc_0F90A
    mov byte ptr ds:[0978Ch], 1
    mov byte ptr ds:[KeepLivesFlag], 1
    mov byte ptr ds:[0978Eh], 1
    mov byte ptr ds:[LevelSkipEnabled], 1
    mov byte ptr ds:[09790h], 1
    mov byte ptr ds:[09791h], 1
loc_0F90A:
    ret

loc_0F90B:
    mov bx, 09818h
    call loc_0F932
    jne loc_0F931
    mov byte ptr ds:[0978Ch], 0
    mov byte ptr ds:[KeepLivesFlag], 0
    mov byte ptr ds:[0978Eh], 0
    mov byte ptr ds:[LevelSkipEnabled], 0
    mov byte ptr ds:[09790h], 0
    mov byte ptr ds:[09791h], 0
loc_0F931:
    ret

loc_0F932:
    mov di, word ptr ds:[bx]
    mov al, byte ptr ds:[KeyLastMakeCode]
    cmp al, byte ptr ds:[di]
    jne loc_0F94D
    inc word ptr ds:[bx]
    cmp byte ptr ds:[di + 1], 0
    jne loc_0F952
    mov bp, 05401h
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
    mov word ptr ds:[0978Ah], ax
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
    mov bx, word ptr ds:[0978Ah]
    int 021h
loc_0F9B1:
    retf
; UNKNOWN: not yet classified as code or data
    db 083h,03Eh,056h,023h,05h,074h,014h,0B8h,01Ch,00h,083h,03Eh,056h,023h,03h,074h
    db 02Fh,0A1h,028h,023h,0D1h,0E8h,05h,022h,00h,0EBh,025h,0B9h,01h,00h,08Bh,046h
    db 04h,03Bh,06h,080h,023h,072h,08h,09Ch,0F7h,0D9h,09Dh,077h,02h,033h,0C9h,01h
    db 04Eh,04h,08Bh,01Eh,036h,023h,083h,0E3h,0FEh,08Bh,087h,0D2h,096h,05h,026h,00h
    db 089h,046h,08h,0FFh,046h,02h,0CBh

loc_0F9F9:
    mov word ptr ds:[0A482h], ax
    mov word ptr ds:[0A842h], 0A844h
    mov word ptr ds:[bx + 020h], 014h
    mov word ptr ds:[0A47Eh], 1
    mov word ptr ds:[0A480h], 064h
    mov word ptr ds:[02342h], 1
    mov word ptr ds:[02344h], 1
    mov word ptr ds:[02346h], 0
    mov word ptr ds:[02348h], 0
    mov word ptr ds:[0A7A0h], 0
    call loc_10044
    call loc_10108
    retf

; Far. Spin until no KEY_DOWN_TABLE entry is set; only the keyboard IRQ can end the wait.
WaitAllKeysReleased:
    push ax
    push cx
    push di
loc_0FA3B:
    mov di, KEY_DOWN_TABLE - 1
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
; UNKNOWN: not yet classified as code or data
    db 0C7h,046h,08h,05Ch,01h,081h,07Eh,02h,090h,00h,07Ch,0Fh,0C7h,046h,018h,07Ch
    db 00h,08Bh,0DDh,0B8h,0E2h,074h,09Ah,08Bh,08Dh,00h,00h,0CBh
loc_0FA6A:
    mov si, word ptr ds:[0A482h]
    lodsw
    add ax, 020h
    mov word ptr ds:[02306h], ax
    lodsw
    mov word ptr ds:[02304h], ax
    mov word ptr ds:[02308h], 3
    mov ax, 05DB2h
    call far ptr FarCallMainNearViaAX
    cmp word ptr ds:[0230Ah], 0
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
    add word ptr ds:[0A482h], 8
    cmp word ptr ds:[si], -1
    jne loc_0FAC8
    jmp near ptr loc_0FC38
loc_0FAC8:
    mov ax, 081F4h
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
    inc word ptr ds:[0A47Eh]
    jmp near ptr loc_0FC38
loc_0FAF9:
    add word ptr ds:[0A482h], 8
    cmp word ptr ds:[si], -1
    jne loc_0FB06
    jmp near ptr loc_0FC38
loc_0FB06:
    mov ax, 081F4h
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
    inc word ptr ds:[0A47Eh]
    jmp near ptr loc_0FC38
loc_0FB58:
    add word ptr ds:[0A482h], 4
    mov cx, 5
loc_0FB60:
    push cx
    mov ax, 081F4h
    call far ptr FarCallMainNearViaAX
    mov si, word ptr ds:[0A842h]
    add word ptr ds:[0A842h], 4
    cmp bx, -1
    je loc_0FB90
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + 034h], ax
    lodsw
    mov word ptr ds:[bx + 032h], ax
    mov word ptr ds:[bx + 018h], 020h
    mov word ptr ds:[bx + 01Ch], 0FFFFh
    inc word ptr ds:[0A47Eh]
loc_0FB90:
    pop cx
    loop loc_0FB60
    jmp near ptr loc_0FC38
loc_0FB96:
    add word ptr ds:[0A482h], 8
    mov ax, 081F4h
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
    inc word ptr ds:[0A47Eh]
    jmp short loc_0FC38
loc_0FBD6:
    add word ptr ds:[0A482h], 8
    cmp word ptr ds:[si], -1
    je loc_0FC38
    mov ax, 081F4h
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_0FC38
    lodsw
    add ax, 020h
    mov word ptr ds:[bx + 034h], ax
    lodsw
    mov word ptr ds:[bx + 032h], ax
    mov word ptr ds:[bx + 018h], 016h
    mov word ptr ds:[bx + 036h], 0A5D4h
    cmp word ptr ss:[bp + REC_Y], 040h
    je loc_0FC12
    mov word ptr ds:[bx + 018h], 017h
    mov word ptr ds:[bx + 036h], 0A5C4h
loc_0FC12:
    mov word ptr ds:[bx + 01Ch], 014h
    mov word ptr ds:[bx + 020h], 3
    inc word ptr ds:[0A47Eh]
    jmp short loc_0FC38
loc_0FC22:
    add word ptr ds:[0A482h], 4
    mov ax, 081F4h
    call far ptr FarCallMainNearViaAX
    cmp bx, -1
    je loc_0FC38
    inc word ptr ds:[0A47Eh]
loc_0FC38:
    mov ax, word ptr ss:[bp + REC_DIRECTION]
    add ax, 03Bh
    mov word ptr ss:[bp + REC_SPRITE], ax
    retf
loc_0FC42:
    mov word ptr ss:[bp + REC_SPRITE], 016Ah
    mov word ptr ds:[02308h], 1
    push word ptr ss:[bp + REC_DIRECTION]
    mov ax, 0B729h
    call far ptr FarCallMainNearViaAX
    pop word ptr ss:[bp + REC_DIRECTION]
    je loc_0FC62
    mov word ptr ss:[bp + REC_TYPE], 093h
loc_0FC62:
    retf
loc_0FC63:
    cmp word ptr ds:[0A482h], 0A6F0h
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
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FCC0
    cmp word ptr ss:[bp + REC_Y], 0D0h
    jae loc_0FCC0
    jmp near ptr loc_0FE75
loc_0FCC0:
    mov word ptr ss:[bp + REC_DIRECTION], 0
loc_0FCC5:
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    je loc_0FCD2
    call loc_0FE76
loc_0FCD2:
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    je loc_0FCDF
    call loc_0FE76
loc_0FCDF:
    mov ax, 0AFD8h
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
    cmp byte ptr ds:[098A9h], 0
    je loc_0FD5B
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], 4
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    pop word ptr ss:[bp + REC_DIRECTION]
loc_0FD5B:
    mov ax, word ptr ds:[02340h]
    and ax, 0FFh
    cmp ax, 0FFh
    jne loc_0FD72
    mov ax, 0BAE1h
    call far ptr FarCallMainNearViaAX
    inc word ptr ds:[02340h]
loc_0FD72:
    cmp word ptr ds:[02340h], 0
    je loc_0FD81
    cmp word ptr ds:[02340h], 02BDh
    jne loc_0FD8D
loc_0FD81:
    mov ax, 07476h
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
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
loc_0FDD2:
    mov word ptr ss:[bp + REC_DIRECTION], 6
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FE01
    jmp short loc_0FE69
loc_0FE01:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    jmp short loc_0FE69
loc_0FE08:
    mov word ptr ss:[bp + REC_DIRECTION], 4
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
loc_0FE35:
    mov word ptr ss:[bp + REC_DIRECTION], 2
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, 0AFD8h
    call far ptr FarCallMainNearViaAX
    jne loc_0FE64
    mov ax, 0AFD8h
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
; UNKNOWN: not yet classified as code or data
    db 0C7h,046h,08h,062h,01h,0C7h,06h,08h,023h,01h,00h,0B8h,029h,0B7h,09Ah,08Bh
    db 08Dh,00h,00h,074h,05h,0C7h,046h,018h,080h,00h,0CBh,081h,03Eh,082h,0A4h,09Ch
    db 0A7h,074h,03h,0E9h,05Ch,01h,083h,07Eh,01Ch,00h,074h,08h,0FFh,04Eh,01Ch,074h
    db 03h,0E9h,04Eh,01h,080h,03Eh,0A3h,098h,00h,074h,06h,0A1h,0AAh,098h,01h,046h
    db 032h,08Bh,046h,08h,03Dh,064h,01h,072h,03h,0E9h,0C8h,00h,0A1h,040h,023h,025h
    db 0FFh,00h,03Dh,07Dh,00h,074h,04h,0Bh,0C0h,075h,011h,0FFh,06h,040h,023h,0C7h
    db 046h,08h,064h,01h,0C7h,046h,020h,03h,00h,0E9h,016h,01h,080h,03Eh,0A6h,098h
    db 00h,074h,011h,0C6h,06h,0A6h,098h,00h,0B8h,076h,074h,09Ah,08Bh,08Dh,00h,00h
    db 0FFh,06h,040h,023h,080h,03Eh,0A3h,098h,00h,074h,017h,0A1h,0AAh,098h,01h,046h
    db 04h,083h,07Eh,04h,00h,074h,07h,081h,07Eh,04h,0C0h,00h,075h,04h,0FEh,06h
    db 0A2h,098h,08Bh,046h,034h,03Bh,046h,02h,074h,03Fh,08Bh,046h,032h,025h,0FEh,0FFh
    db 083h,066h,04h,0FEh,0A3h,04h,023h,08Bh,046h,034h,025h,0FEh,0FFh,083h,066h,02h
    db 0FEh,0A3h,06h,023h,0C7h,06h,08h,023h,01h,00h,0B8h,0B2h,05Dh,09Ah,08Bh,08Dh
    db 00h,00h,0C7h,046h,08h,060h,01h,0A1h,028h,023h,0D1h,0E8h,0D1h,0E8h,075h,03h
    db 0E9h,09Fh,00h,0FFh,046h,08h,0E9h,099h,00h,080h,03Eh,0A4h,098h,00h,074h,014h
    db 083h,046h,02h,0Ch,083h,046h,034h,0Ch,081h,07Eh,02h,0B0h,00h,072h,05h,0C7h
    db 046h,034h,020h,00h,08Bh,046h,04h,0D1h,0E8h,025h,01h,00h,05h,062h,01h,089h
    db 046h,08h,0EBh,06Eh,080h,03Eh,0A4h,098h,00h,074h,010h,083h,046h,034h,0Ch,081h
    db 07Eh,034h,0B0h,00h,072h,05h,0C7h,046h,034h,020h,00h,03Dh,068h,01h,073h,0Ch
    db 083h,03Eh,026h,023h,03h,075h,04Bh,0FFh,046h,08h,0EBh,046h,083h,046h,02h,05h
    db 0C7h,046h,08h,068h,01h,0A1h,028h,023h,0D1h,0E8h,0D1h,0E8h,074h,03h,0FFh,046h
    db 08h,081h,07Eh,02h,0E0h,00h,076h,02Ah,0C7h,046h,02h,00h,00h,083h,03Eh,026h
    db 023h,03h,074h,014h,0B8h,095h,04Dh,09Ah,08Bh,08Dh,00h,00h,080h,0FBh,0C0h,077h
    db 0F3h,032h,0FFh,089h,05Eh,04h
; UNKNOWN: not yet classified as code or data
    db 0EBh,0Ah,0C7h,046h,08h,060h,01h,0C7h,046h,020h,05h,00h,0CBh

loc_1000D:
    dec byte ptr ds:[098A7h]
    jne loc_1003E
    mov ax, word ptr ds:[0A47Eh]
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
; UNKNOWN: not yet classified as code or data
    db 0C7h,047h,020h,0C8h,00h,0C7h,047h,04h,00h,00h,0C7h,047h,02h,00h,00h,0C7h
    db 047h,014h,02h,00h,0C7h,047h,028h,0FFh,0FFh,0C7h,07h,01h,00h,0C7h,047h,016h
    db 04h,00h,0CBh,02Eh,08Bh,036h,020h,09h,0ADh,03Dh,0FFh,0FFh,074h,05Ch,05h,020h
    db 00h,0A3h,06h,023h,0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,03h,00h,0B8h,0B2h
    db 05Dh,09Ah,08Bh,08Dh,00h,00h,083h,03Eh,0Ah,023h,00h,074h,033h,0C7h,046h,020h
    db 02h,00h,02Eh,083h,06h,020h,09h,04h,0B8h,0F4h,081h,09Ah,08Bh,08Dh,00h,00h
    db 083h,0FBh,0FFh,074h,01Bh,08Bh,046h,02h,089h,047h,034h,08Bh,046h,04h,089h,047h
    db 032h,0C7h,047h,018h,064h,00h,0C7h,047h,020h,03h,00h,0C7h,047h,08h,08Eh,00h
    db 08Bh,046h,06h,05h,03Bh,00h,089h,046h,08h,0CBh,0E8h,02h,00h,0EBh,094h

loc_10108:
    mov word ptr cs:[0920h], 09828h
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h

loc_10112:
    cmp word ptr ds:[0A95Ah], -1
    je loc_1014F
    inc word ptr ds:[0C812h]
    and word ptr ds:[0C812h], 1
    jne loc_1014F
    mov si, 0C6C1h
    mov cx, 014h
    call loc_10150
    inc word ptr ds:[0C814h]
    and word ptr ds:[0C814h], 1
    jne loc_1014F
    mov cx, 0Ah
    call loc_10150
    inc word ptr ds:[0C816h]
    and word ptr ds:[0C816h], 1
    jne loc_1014F
    mov cx, 0Ah
    call loc_10150
loc_1014F:
    retf

loc_10150:
    inc word ptr ds:[si]
    cmp word ptr ds:[si], 0C0h
    jne loc_1015C
    mov word ptr ds:[si], 0
loc_1015C:
    add si, 6
    loop loc_10150
    ret
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

loc_10170:
    mov word ptr ds:[0BED6h], ax
    mov word ptr ds:[0BED4h], 0
loc_10179:
    mov ax, 0D2B8h
    call far ptr FarCallMainNearViaAX
    mov si, word ptr ds:[0BED6h]
    cmp word ptr ds:[si - 2], 0
    je loc_101D8
loc_1018B:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_LEFT], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_UP], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_PGUP], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_BACKSPACE], KEY_STATE_DOWN
    je loc_101D9
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_RIGHT], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_DOWN], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_PGDN], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_SPACE], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ENTER], KEY_STATE_DOWN
    je loc_101F3
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    jne loc_1018B
loc_101D1:
    cmp byte ptr ds:[KEY_DOWN_TABLE + SCAN_ESC], KEY_STATE_DOWN
    je loc_101D1
loc_101D8:
    retf
loc_101D9:
    cmp word ptr ds:[0BED4h], 0
    je loc_1018B
    mov cx, 5
loc_101E3:
    mov ax, 050C9h
    call far ptr FarCallMainNearViaAX
    loop loc_101E3
    dec word ptr ds:[0BED4h]
    jmp short loc_10179
loc_101F3:
    mov si, word ptr ds:[0BED6h]
    mov bx, word ptr ds:[0BED4h]
    inc bx
    shl bx, 1
    cmp word ptr ds:[bx + si], -1
    je loc_1018B
    mov cx, 5
loc_10206:
    mov ax, 050C9h
    call far ptr FarCallMainNearViaAX
    loop loc_10206
    inc word ptr ds:[0BED4h]
    jmp near ptr loc_10179
; UNKNOWN: not yet classified as code or data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h

FAR0F7F ends
end