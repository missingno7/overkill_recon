; Modern physical chunk, NOT an inferred original object boundary.
include HARDWARE.INC
include SYSTEM.INC
include SOUND.INC
include INPUT.INC
include GAME.INC
include RECORDS.INC
include MOVEMENT.INC
locals
extrn InputBits:far
extrn LevelIndex:far
extrn SfxEnabled:far
extrn SfxRequest:far
extrn loc_1000D:far
extrn loc_10112:far
MAIN segment byte public 'CODE'
assume cs:MAIN,ds:nothing,ss:nothing,es:nothing
public ApplyPositionHistoryToRecords
public DecRecordXTwice
public DecRecordXUnlessZero
public DecRecordYByMode
public IncRecordXBelowMax
public IncRecordXTwice
public IncRecordYTwice
public UpdatePlacementXOffsetsAtRecordEdges
public loc_0A067
public loc_0A212
public loc_0A66F
public loc_0A781
public loc_0A846
public loc_0A90C
public loc_0A940
public loc_0AC19
public loc_0AF22
public loc_0AF63
public loc_0B5A9
public loc_0BC4B
public loc_0BD0D
public loc_0BE97
public loc_0BEC5
public loc_0BFC7
extrn ComputeRecordGridOffset:near
extrn FindFreeRecordPoolA:near
extrn MainDataSegment:near
extrn ReadIndexedByteAttribute:near
extrn WorkspaceSegment:near
extrn loc_04A65:near
extrn loc_04CED:near
extrn loc_04D64:near
extrn loc_04D95:near
extrn loc_05059:near
extrn loc_05A7E:near
extrn loc_05A92:near
extrn loc_05AC8:near
extrn loc_05DB2:near
extrn loc_05E42:near
extrn loc_05F0D:near
extrn loc_062AA:near
extrn loc_062F6:near
extrn loc_07420:near
extrn loc_07476:near
extrn loc_07547:near
extrn loc_07596:near
extrn loc_07746:near
extrn loc_07948:near
extrn loc_08331:near
extrn loc_0837A:near
extrn loc_0859E:near
extrn loc_09E19:near
extrn loc_09E69:near
extrn loc_0C054:near
extrn loc_0C237:near
extrn loc_0C591:near
extrn loc_0CB1C:near
extrn loc_0F797:near
; Fields scoped to the SetResponseAndStepRecordCounter response path; no entity/health identity asserted.
; Offset-placement use of field+8 does not define its role in other record types.
; Modern position-history symbols.
; Modern record/state symbols.
; Continuation of PlaceRecordFromOffsetPair across the physical
; chunk boundary: same routine, not a separate clamp/feedback producer.
    lodsw
    add ax, word ptr ss:[bp + REC_X]
    add ax, word ptr ds:[OFFSET_X_WORK]
    add ax, word ptr ds:[OFFSET_X_WORK]
    mov word ptr ds:[bx + REC_X], ax
    cmp word ptr ds:[bx + REC_X], 0
    jge loc_0A01F
    mov word ptr ds:[bx + REC_X], 0
    mov byte ptr ds:[CLAMP_X_LOW_SEEN], 1
loc_0A01F:
    cmp word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
    jle loc_0A030
    mov word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
    mov byte ptr ds:[CLAMP_X_HIGH_SEEN], 1
loc_0A030:
    ret

; Near leaf. If DS:A962 !=FFFF, copy two sequential words from DS:[DS:A33C] to record DS:[DS:A962]+2/+4. Then
; independently do the same for A964/A33E. With DF=0 these are Y/X pairs and SI advances4 after the last copy;
; AX=last X,BX=last destination. If neither slot exists AX/BX/SI unchanged. Flags are always CMP(A964,FFFF),
; even on copy; caller9BE8 overwrites them. CX,DX,DI,BP and segments preserved. Requires valid selected
; pointers; pair abstraction assumes destinations do not alias cursors/slots/source. Actual load/store order
; remains significant; no activation/type checks.
ApplyPositionHistoryToRecords:
    cmp word ptr ds:[HISTORY_RECORD_SLOT_15], -1
    je loc_0A048
    mov bx, word ptr ds:[HISTORY_RECORD_SLOT_15]
    mov si, word ptr ds:[HISTORY_READ_CURSOR_15]
    lodsw
    mov word ptr ds:[bx + REC_Y], ax
    lodsw
    mov word ptr ds:[bx + REC_X], ax
loc_0A048:
    cmp word ptr ds:[HISTORY_RECORD_SLOT_31], -1
    je loc_0A05F
    mov bx, word ptr ds:[HISTORY_RECORD_SLOT_31]
    mov si, word ptr ds:[HISTORY_READ_CURSOR_31]
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
    cmp byte ptr ds:[09790h], 1
    je loc_0A084
    cmp word ptr ds:[0232Ah], 0Fh
    je loc_0A084
    ret
loc_0A084:
    mov word ptr ds:[0A980h], 1
    cmp word ptr ds:[02350h], 0B6h
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
    jmp word ptr cs:[bx - 05EF8h]
; UNKNOWN: not yet classified as code or data
    db 090h,09Fh,0A1h,08Ah,0A1h,0C8h,0A1h,037h,0A3h,0F6h,0A2h,0AFh,044h

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
; UNKNOWN: not yet classified as code or data
    db 0E8h,01Eh,00h,0C7h,047h,08h,033h,00h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h
    db 06h,0FFh,0BEh,014h,0C3h
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
; UNKNOWN: not yet classified as code or data
    db 083h,03Eh,0A0h,0A3h,00h,074h,01h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h
    db 06h,0FFh,0BEh,017h,0FFh,06h,070h,0A9h,0E8h,0D9h,01h,0C7h,047h,018h,08h,00h
    db 0C7h,047h,08h,035h,00h,0E8h,090h,0FEh,0FFh,06h,070h,0A9h,0E8h,0C5h,01h,0C7h
    db 047h,018h,08h,00h,0C7h,047h,08h,035h,00h,0E8h,07Ch,0FEh,083h,047h,02h,08h
    db 0C3h,083h,03Eh,0A0h,0A3h,00h,074h,01h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h
    db 0C6h,06h,0FFh,0BEh,016h,0FFh,06h,070h,0A9h,0E8h,098h,01h,0C7h,047h,018h,07h
    db 00h,0C7h,047h,08h,037h,00h,0E8h,04Fh,0FEh,0FFh,06h,070h,0A9h,0E8h,084h,01h
    db 0C7h,047h,018h,07h,00h,0C7h,047h,08h,037h,00h,0E8h,03Bh,0FEh,083h,047h,02h
    db 08h,0C3h

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
    jmp word ptr cs:[bx - 05BD4h]
; UNKNOWN: not yet classified as code or data
    db 090h,0D7h,0A4h,090h,0A4h,099h,0A4h,064h,0A4h,038h,0A4h,0AFh,044h,083h,03Eh,0A0h
    db 0A3h,00h,074h,01h,0C3h,083h,06h,070h,0A9h,02h,0E8h,08Fh,00h,0C7h,047h,018h
    db 08h,00h,0C7h,047h,08h,035h,00h,0E8h,082h,00h,0C7h,047h,018h,08h,00h,0C7h
    db 047h,08h,035h,00h,083h,047h,02h,08h,0C3h,083h,03Eh,0A0h,0A3h,00h,074h,01h
    db 0C3h,083h,06h,070h,0A9h,02h,0E8h,063h,00h,0C7h,047h,018h,07h,00h,0C7h,047h
    db 08h,037h,00h,0E8h,056h,00h,0C7h,047h,018h,07h,00h,0C7h,047h,08h,037h,00h
    db 083h,047h,02h,08h,0C3h,0E8h,044h,00h,0C7h,047h,08h,033h,00h,0C3h,0E8h,04Eh
    db 00h,08Bh,044h,02h,089h,047h,02h,08Bh,044h,04h,05h,04h,00h,089h,047h,04h
    db 0A1h,0ECh,0A3h,089h,047h,06h,03Dh,0FFh,0FFh,075h,010h,0C7h,047h,06h,07h,00h
    db 083h,07Ch,04h,058h,076h,05h,0C7h,047h,06h,01h,00h,083h,07Fh,06h,01h,0C7h
    db 047h,08h,019h,00h,074h,05h,0C7h,047h,08h,01Fh,00h,0C3h,0E8h,010h,00h,08Bh
    db 044h,02h,089h,047h,02h,08Bh,044h,04h,05h,04h,00h,089h,047h,04h,0C3h

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
    cmp word ptr ds:[MOVE_MODE_A47C], 0
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
; If X==B0 and IN_XPLUS set, increment DS:OFFSET_X_GROUP_B unless exactly8; otherwise decrement it unless
; exactly0. Group A is updated first, preserving sequential alias effects of the original loads. Word operations
; wrap at16 bits; guards are equality-only, not saturation. Preserve all general/segment registers and IF/DF;
; arithmetic flags depend on final path. Normal near return; only group-A/B words may be written, apart from
; call stack. Requires valid callee state; normal caller record/state do not overlap.
UpdatePlacementXOffsetsAtRecordEdges:
    cmp word ptr ds:[02350h], 0B6h
    ja loc_0A61F
    ret
loc_0A61F:
    call UpdatePlacementXGroupA
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
    jne loc_0A63C
    test byte ptr ds:[InputBits], IN_XPLUS
    je loc_0A63C
    cmp word ptr ds:[OFFSET_X_GROUP_B], 8
    je loc_0A63B
    inc word ptr ds:[OFFSET_X_GROUP_B]
loc_0A63B:
    ret
loc_0A63C:
    cmp word ptr ds:[OFFSET_X_GROUP_B], 0
    je loc_0A647
    dec word ptr ds:[OFFSET_X_GROUP_B]
loc_0A647:
    ret

; Near leaf. Read SS:[BP+REC_X] and DS:InputBits. If X==0 and IN_XMINUS set, decrement DS:OFFSET_X_GROUP_A
; unless exactlyFFF8h; otherwise increment it unless exactly0. All arithmetic wraps at16 bits. Equality
; sentinels do not validate or clamp arbitrary accumulator values. Preserve all general and segment registers,
; IF/DF; arithmetic flags path-dependent. Normal near return; only group-A word may be written. Requires valid
; record/state storage; no hardware effects.
UpdatePlacementXGroupA:
    cmp word ptr ss:[bp + REC_X], 0
    jne loc_0A662
    test byte ptr ds:[InputBits], IN_XMINUS
    je loc_0A662
    cmp word ptr ds:[OFFSET_X_GROUP_A], -8
    jne loc_0A65D
    ret
loc_0A65D:
    dec word ptr ds:[OFFSET_X_GROUP_A]
    ret
loc_0A662:
    cmp word ptr ds:[OFFSET_X_GROUP_A], 0
    jne loc_0A66A
    ret
loc_0A66A:
    inc word ptr ds:[OFFSET_X_GROUP_A]
    ret

loc_0A66F:
    cmp word ptr ds:[0A47Ch], 0
    je loc_0A679
    jmp near ptr loc_0A6FD
loc_0A679:
    cmp word ptr ds:[0A47Eh], 0
    jne loc_0A6FD
    cmp word ptr ds:[0A480h], 0
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
    cmp word ptr ds:[02350h], 0E52h
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
    cmp word ptr ds:[02350h], 0EA0h
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
    add word ptr ds:[0A278h], 1
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
    add word ptr ds:[02350h], 0Dh
    dec word ptr ds:[0A978h]
loc_0A72F:
    mov ax, word ptr cs:[095BEh]
    cmp word ptr ds:[0234Ch], ax
    jne loc_0A73C
    call loc_0A746
loc_0A73C:
    mov ax, word ptr cs:[0959Eh]
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
    cmp word ptr ds:[02350h], 0B6h
    ja loc_0A765
    cmp byte ptr ds:[SfxEnabled], 0
    je loc_0A765
    mov byte ptr ds:[SfxRequest], 7
loc_0A765:
    add word ptr ds:[02350h], 0Dh
    dec word ptr ds:[0A978h]
    mov al, 5
    cmp word ptr ds:[0A978h], 4
    jne loc_0A77A
    call loc_0CB1C
loc_0A77A:
    mov word ptr ds:[02354h], 0
    ret

loc_0A781:
    push bp
    mov word ptr ds:[02352h], 1
    cmp word ptr ds:[02350h], 0
    je loc_0A744
    add word ptr ds:[0A278h], -1
    cmp word ptr ds:[0234Eh], 0
    jne loc_0A79E
    call loc_0A7D0
loc_0A79E:
    inc word ptr ds:[0234Eh]
    and word ptr ds:[0234Eh], 0Fh
    jne loc_0A7B9
    cmp word ptr ds:[02354h], 1
    je loc_0A7B9
    sub word ptr ds:[02350h], 0Dh
    inc word ptr ds:[0A978h]
loc_0A7B9:
    mov ax, word ptr cs:[095C0h]
    cmp word ptr ds:[0234Ch], ax
    jne loc_0A7C6
    call loc_0A7E3
loc_0A7C6:
    mov ax, word ptr cs:[0959Eh]
    add word ptr ds:[0234Ch], ax
    pop bp
    ret

loc_0A7D0:
    call loc_0A7EB
    sub word ptr ds:[02350h], 0Dh
    inc word ptr ds:[0A978h]
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
    mov bx, word ptr ds:[02350h]
    cmp word ptr ds:[02352h], 1
    jne loc_0A82D
    sub bx, 0A9h
    jmp near ptr loc_05A7E
loc_0A82D:
    mov word ptr ds:[0A408h], bx
    cmp word ptr ds:[02350h], 0E52h
    ja loc_0A83F
    call loc_07948
    call loc_04A65
loc_0A83F:
    mov bx, word ptr ds:[02350h]
    jmp near ptr loc_05A7E

loc_0A846:
    mov cx, POOL_A_POINTER_COUNT
loc_0A849:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
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
    mov bp, word ptr ds:[bx + POOL_B_POINTERS - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A873
    call loc_05AC8
loc_0A873:
    pop cx
    loop loc_0A861
    call loc_04CED
    mov cx, POOL_B_COUNT
loc_0A87C:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + POOL_B_POINTERS - 2]
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
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A8C1
    cmp word ptr ds:[0BDACh], 1
    je loc_0A8B8
    cmp word ptr ds:[02350h], 0B6h
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
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A8F4
    cmp word ptr ds:[0BDACh], 1
    je loc_0A8EB
    cmp word ptr ds:[02350h], 0B6h
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
    mov bp, word ptr ds:[bx + POOL_B_POINTERS - 2]
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
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0A939
    call loc_05A92
loc_0A939:
    pop cx
    loop loc_0A927
    call loc_04D64
    ret

loc_0A940:
    cmp word ptr ds:[0A8CEh], -1
    je loc_0A94B
    inc word ptr ds:[0A8CEh]
loc_0A94B:
    mov ax, word ptr ds:[0A8C8h]
    mov word ptr ds:[0A8C6h], ax
    mov ax, word ptr ds:[0A8CCh]
    mov word ptr ds:[0A8CAh], ax
    mov word ptr ds:[0A8CCh], 0
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
    mov ax, word ptr ds:[0A47Eh]
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
    cmp word ptr ds:[0A8C2h], 1
    jne loc_0A9DD
    call loc_0F797
loc_0A9DD:
    mov cx, POOL_A_COUNT
loc_0A9E0:
    push cx
    mov bx, cx
    shl bx, 1
    mov bp, word ptr ds:[bx + POOL_A_POINTERS - 2]
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
    mov bp, word ptr ds:[bx + POOL_B_POINTERS - 2]
    cmp word ptr ss:[bp + REC_STATUS], 0
    je loc_0AA22
    call loc_0AA2B
loc_0AA22:
    pop cx
    loop loc_0AA10
    call far ptr loc_10112
    ret

loc_0AA2B:
    mov bx, word ptr ss:[bp + 016h]
    shl bx, 1
    jmp word ptr cs:[bx - 055CAh]
; UNKNOWN: not yet classified as code or data
    db 090h,045h,0BCh,04h,0ADh,0AEh,0EFh,0AFh,044h,0AEh,0EFh,0C2h,0AAh,010h,0ABh
loc_0AA44:
    clc
    ret
loc_0AA46:
    mov ax, word ptr ss:[bp + 2]
    or ax, ax
    js loc_0AA44
    mov si, word ptr ds:[PRIMARY_RECORD + REC_SPRITE]
    cmp si, 3
    jae loc_0AA44
    shl si, 1
    shl si, 1
    add si, 0214Eh
    lodsw
    add ax, word ptr ds:[PRIMARY_RECORD + REC_Y]
    mov word ptr ds:[095F2h], ax
    lodsw
    add ax, word ptr ds:[PRIMARY_RECORD + REC_X]
    mov word ptr ds:[095F4h], ax
    jmp near ptr loc_08331
loc_0AA71:
    mov ax, word ptr ss:[bp + 2]
    or ax, ax
    js loc_0AA44
    mov ax, word ptr ss:[bp + 4]
    add ax, 018h
    cmp ax, word ptr ds:[PRIMARY_RECORD + REC_X]
    jl loc_0AA44
    sub ax, 02Ch
    cmp ax, word ptr ds:[PRIMARY_RECORD + REC_X]
    jg loc_0AA44
    cmp word ptr ds:[0A8C2h], 1
    jne loc_0AAAB
    mov ax, word ptr ss:[bp + 2]
    add ax, 8
    cmp ax, word ptr ds:[PRIMARY_RECORD + REC_Y]
    jb loc_0AA44
    sub ax, 0Ch
    cmp ax, word ptr ds:[PRIMARY_RECORD + REC_Y]
    ja loc_0AA44
    stc
    ret
loc_0AAAB:
    mov ax, word ptr ss:[bp + 2]
    add ax, 018h
    cmp ax, word ptr ds:[PRIMARY_RECORD + REC_Y]
    jb loc_0AA44
    sub ax, 02Ch
    cmp ax, word ptr ds:[PRIMARY_RECORD + REC_Y]
    ja loc_0AA44
    stc
    ret
    inc word ptr ss:[bp + 2]
    call loc_0AA46
    jb loc_0AACD
    jmp near ptr loc_0BC45
loc_0AACD:
    call loc_0AAD3
    jmp near ptr loc_0BC45
loc_0AAD3:
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
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
    mov bp, PRIMARY_RECORD
    shl bx, 1
    jmp word ptr cs:[bx - 05500h]
; UNKNOWN: not yet classified as code or data
    db 0AFh,044h,04Dh,09Dh,067h,09Dh,0AAh,062h,0B9h,09Dh,0Ch,0ABh,05Dh,0E9h,07h,012h
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
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
    mov bx, PRIMARY_RECORD
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
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
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
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
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
    cmp word ptr ds:[PRIMARY_RECORD + REC_SPRITE], 3
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
    cmp word ptr ds:[0BEDCh], 0
    jne StepRecordResponseCounter
    cmp word ptr ds:[COUNT_GATE_2324], 1
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
    mov bx, POOL_A
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
    cmp word ptr ds:[0BDACh], 1
    je loc_0AD14
    cmp word ptr ds:[02350h], 0B6h
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
    mov ax, word ptr ds:[0A278h]
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
    db 0FFh,046h,02h,0FFh,046h,02h,0E9h,077h,04h,083h,06Eh,02h,010h,0EBh,081h,0A1h
    db 026h,023h,05h,05Ah,00h,089h,046h,08h,083h,06Eh,02h,03h,0E9h,071h,0FFh,0E9h
    db 06Eh,0FFh,0A1h,02Ah,023h,0D1h,0E8h,05h,00h,00h,089h,046h,08h,0FFh,04Eh,01Ch
    db 074h,0C7h,0B8h,050h,0B2h,050h,0E9h,05Ah,01h,083h,07Eh,01Ch,00h,074h,0Ah,0FFh
    db 04Eh,01Ch,075h,09h,0C7h,046h,06h,00h,00h,083h,06Eh,02h,02h,08Bh,046h,06h
    db 05h,028h,00h,089h,046h,08h,0E8h,0F9h,00h,0E9h,034h,0FFh,081h,07Eh,04h,0C8h
    db 00h,074h,096h,083h,06Eh,02h,04h,0F7h,046h,04h,07h,00h,075h,020h,0F7h,046h
    db 04h,08h,00h,074h,019h,083h,03Eh,0ACh,0BDh,01h,074h,012h,0E8h,024h,0A2h,083h
    db 0C3h,0Eh,0E8h,06h,0A2h,0C7h,046h,06h,00h,00h,03Ch,01h,074h,09h,0C7h,046h
    db 06h,01h,00h,083h,046h,04h,04h,0A1h,026h,023h,0D1h,0E0h,0D1h,0E0h,025h,08h
    db 00h,03h,046h,06h,05h,08h,00h,089h,046h,08h,0E9h,0DDh,0FEh,083h,07Eh,04h
    db 00h,075h,03h,0E9h,043h,0FFh,083h,06Eh,02h,04h,0F7h,046h,04h,0Fh,00h,075h
    db 019h,083h,03Eh,0ACh,0BDh,01h,074h,012h,0E8h,0D8h,0A1h,083h,0C3h,0Ch,0E8h,0BAh
    db 0A1h,0C7h,046h,06h,00h,00h,03Ch,01h,074h,09h,0C7h,046h,06h,07h,00h,083h
    db 06Eh,04h,04h,08Bh,046h,06h,05h,08h,00h,089h,046h,08h,0E9h,09Bh,0FEh
    mov ax, 0B250h
    push ax
    cmp word ptr ds:[LevelIndex], 0
    je loc_0AECD
    jmp near ptr loc_0AF60
loc_0AECD:
    cmp word ptr ss:[bp + REC_DIRECTION], 4
    jne loc_0AED6
    jmp near ptr loc_0AF60
loc_0AED6:
    jmp short loc_0AEE4
    dec word ptr ss:[bp + REC_FIELD_1C]
    jne loc_0AEE0
    jmp near ptr loc_0ADC9
loc_0AEE0:
    mov ax, 0B250h
    push ax
loc_0AEE4:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx - 05112h]
; UNKNOWN: not yet classified as code or data
    db 0Bh,0AFh,010h,0AFh,014h,0AFh,0FEh,0AEh,02h,0AFh,019h,0AFh,01Dh,0AFh,07h,0AFh
    add word ptr ss:[bp + REC_X], 8
    add word ptr ss:[bp + REC_Y], 8
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,06Eh,04h,08h
    sub word ptr ss:[bp + REC_Y], 8
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,06Eh,02h,08h
    add word ptr ss:[bp + REC_X], 8
    ret
    add word ptr ss:[bp + REC_Y], 8
    sub word ptr ss:[bp + REC_X], 8
    ret
loc_0AF22:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx - 050D4h]
; UNKNOWN: not yet classified as code or data
    db 049h,0AFh,04Eh,0AFh,052h,0AFh,03Ch,0AFh,040h,0AFh,057h,0AFh,05Bh,0AFh,045h,0AFh
    add word ptr ss:[bp + REC_X], 3
    add word ptr ss:[bp + REC_Y], 3
    ret
; UNKNOWN: not yet classified as code or data
    db 083h,06Eh,04h,03h,083h,06Eh,02h,03h,0C3h,083h,06Eh,02h,03h,083h,046h,04h
    db 03h,0C3h
    add word ptr ss:[bp + REC_Y], 3
    sub word ptr ss:[bp + REC_X], 3
    ret
loc_0AF60:
    call loc_0AF63
loc_0AF63:
    mov bx, word ptr ss:[bp + REC_DIRECTION]
    shl bx, 1
    jmp word ptr cs:[bx - 05092h]
; UNKNOWN: not yet classified as code or data
    db 090h,08Bh,0AFh,090h,0AFh,094h,0AFh,07Eh,0AFh,082h,0AFh,099h,0AFh,09Dh,0AFh,087h
    db 0AFh
    add word ptr ss:[bp + REC_X], 2
    add word ptr ss:[bp + REC_Y], 2
    ret
    sub word ptr ss:[bp + REC_X], 2
    sub word ptr ss:[bp + REC_Y], 2
    ret
    sub word ptr ss:[bp + REC_Y], 2
    add word ptr ss:[bp + REC_X], 2
    ret
    add word ptr ss:[bp + REC_Y], 2
    sub word ptr ss:[bp + REC_X], 2
    ret
; UNKNOWN: not yet classified as code or data
    db 08Bh,05Eh,06h,0D1h,0E3h,02Eh,0FFh,0A7h,0ACh,0AFh,0C6h,0AFh,0CAh,0AFh,0CDh,0AFh
    db 0BCh,0AFh,0BFh,0AFh,0D1h,0AFh,0D4h,0AFh,0C3h,0AFh,0FFh,046h,04h,0FFh,046h,02h
    db 0C3h,0FFh,04Eh,04h,0FFh,04Eh,02h,0C3h,0FFh,04Eh,02h,0FFh,046h,04h,0C3h,0FFh
    db 046h,02h,0FFh,04Eh,04h,0C3h
    mov word ptr ds:[0A430h], 0
    mov ax, word ptr ss:[bp + REC_Y]
    mov word ptr ds:[0A432h], ax
    mov word ptr ds:[0A438h], ax
    mov ax, word ptr ss:[bp + REC_X]
    mov word ptr ds:[0A434h], ax
    mov word ptr ds:[0A436h], ax
    mov ax, word ptr ds:[0A278h]
    add word ptr ss:[bp + REC_Y], ax
    sub word ptr ss:[bp + REC_Y], 010h
    call loc_0B00D
    add word ptr ss:[bp + REC_Y], 010h
    mov ax, word ptr ds:[0A278h]
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
    jmp word ptr cs:[bx - 04FDEh]
; UNKNOWN: not yet classified as code or data
    db 090h,07Dh,0B0h,0C9h,0B0h,0CCh,0B0h,039h,0B0h,03Ch,0B0h,0Ch,0B1h,0Fh,0B1h,07Ah
    db 0B0h
loc_0B032:
    mov word ptr ds:[0A430h], 1
    ret
; UNKNOWN: not yet classified as code or data
    db 0E8h,090h,00h
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
    call loc_0B07D
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
; UNKNOWN: not yet classified as code or data
    db 0E8h,02Dh,0FFh
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
    mov bx, word ptr ds:[TARGET_SEARCH_CURSOR]
loc_0B161:
    cmp bx, POOL_A_END
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
    mov word ptr ds:[TARGET_SEARCH_CURSOR], POOL_A
    mov bx, word ptr ds:[TARGET_SEARCH_CURSOR]
    jmp short loc_0B161
loc_0B1A6:
    push bx
    add bx, RECORD_SIZE
    mov word ptr ds:[0A43Ah], bx
    pop bx
    ret
; UNKNOWN: not yet classified as code or data
    db 0A1h,028h,023h,05h,06Dh,00h,089h,046h,08h,083h,07Eh,01Ch,01h,074h,068h,0A1h
    db 07Eh,023h,05h,0Ah,00h,0A3h,06h,023h,0A1h,080h,023h,05h,0Ch,00h,0A3h,04h
    db 023h,0C7h,06h,08h,023h,02h,00h,083h,026h,04h,023h,0FCh,083h,026h,06h,023h
    db 0FCh,083h,066h,04h,0FCh,083h,066h,02h,0FCh,0E8h,0C6h,0ABh,083h,03Eh,0Ah,023h
    db 00h,075h,03h,0E9h,06Ah,0FBh,083h,03Eh,07Eh,0A9h,00h,074h,04h,0FFh,0Eh,07Eh
    db 0A9h,0E8h,056h,0FFh,083h,0FBh,0FFh,075h,03h,0E9h,0BDh,0FBh,089h,05Eh,030h,0C7h
    db 046h,01Ch,01h,00h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,011h
    db 0FFh,06h,07Eh,0A9h,0E9h,039h,0FBh,08Bh,05Eh,030h,083h,03Fh,00h,074h,016h,081h
    db 07Fh,02h,0DCh,00h,077h,0Fh,083h,07Fh,018h,01h,074h,09h,0E8h,0DCh,0ABh,0E8h
    db 00h,0ACh,0E9h,015h,0FBh,0C7h,046h,01Ch,00h,00h,0E9h,0Dh,0FBh
    call loc_05E42
    cmp word ptr ss:[bp + REC_SIDE_FLAG], 1
    je loc_0B2A3
    mov ax, word ptr ds:[PRIMARY_RECORD + REC_Y]
    mov bx, word ptr ds:[PRIMARY_RECORD + REC_X]
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
    cmp word ptr ds:[0BEDCh], 0
    je loc_0B297
    mov cx, 3
    cmp word ptr ds:[0BEDCh], 1
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
; UNKNOWN: not yet classified as code or data
    db 0A1h,03Ch,023h,05h,01Ch,00h,089h,046h,08h,083h,03Eh,02Ch,023h,01Fh,075h,03h
    db 0E8h,028h,08h,0E9h,047h,08h,0C7h,046h,036h,05Ch,0A4h,0EBh,05h,0C7h,046h,036h
    db 03Ch,0A4h,0C7h,046h,018h,012h,00h,08Bh,076h,036h,0ADh,05h,020h,00h,0A3h,06h
    db 023h,0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,01h,00h,083h,03Eh,056h,023h,00h
    db 074h,07h,083h,03Eh,0ACh,0BDh,01h,075h,06h,0C7h,06h,08h,023h,02h,00h,0E8h
    db 0BAh,0AAh,083h,03Eh,0Ah,023h,00h,074h,05h,089h,076h,036h,0EBh,0C9h,08Bh,046h
    db 06h,05h,03Bh,00h,089h,046h,08h,083h,03Eh,0ACh,0BDh,01h,075h,03h,0E9h,034h
    db 09h,083h,03Eh,056h,023h,05h,074h,0Eh,083h,03Eh,056h,023h,06h,074h,07h,083h
    db 03Eh,056h,023h,00h,075h,031h,08Bh,046h,06h,05h,015h,01h,089h,046h,08h,081h
    db 03Eh,050h,023h,052h,0Eh,074h,03h,0E9h,0Bh,09h,08Bh,046h,06h,05h,05h,01h
    db 089h,046h,08h,083h,03Eh,056h,023h,00h,075h,03h,0E9h,0F8h,08h,083h,03Eh,056h
    db 023h,06h,075h,03h,0E9h,0EEh,08h,08Bh,046h,06h,05h,02Ah,00h,089h,046h,08h
    db 083h,03Eh,056h,023h,01h,075h,03h,0E9h,0DBh,08h,08Bh,046h,06h,05h,0D2h,00h
    db 089h,046h,08h,083h,03Eh,056h,023h,02h,075h,03h,0E9h,0C8h,08h,08Bh,046h,06h
    db 05h,0ECh,00h,089h,046h,08h,083h,03Eh,056h,023h,03h,075h,03h,0E9h,0B5h,08h
    db 083h,03Eh,056h,023h,07h,075h,03h,0E9h,0ABh,08h,08Bh,046h,06h,05h,0ECh,00h
    db 089h,046h,08h,083h,03Eh,056h,023h,04h,075h,03h,0E9h,098h,08h,08Bh,046h,06h
    db 05h,0ECh,00h,089h,046h,08h,0E9h,08Ch,08h,0A1h,042h,023h,040h,0D1h,0E8h,05h
    db 071h,00h,089h,046h,08h,0C3h,0E8h,0F0h,0FFh,083h,046h,02h,02h,081h,07Eh,02h
    db 0A0h,00h,073h,03h,0E9h,068h,08h,0EBh,01Ah,0E8h,0DDh,0FFh,0FFh,046h,02h,083h
    db 03Eh,056h,023h,00h,075h,03h,0FFh,046h,02h,081h,07Eh,02h,0A0h,00h,073h,03h
    db 0E9h,04Ch,08h,0E8h,0CBh,0Bh,0E8h,03h,00h,0E9h,043h,08h,0BAh,0Ch,00h,083h
    db 07Eh,014h,02h,074h,03h,0BAh,04h,00h,08Bh,046h,04h,03h,0C2h,0A3h,0B2h,0A8h
    db 08Bh,046h,02h,03h,0C2h,0A3h,0B4h,0A8h,0B9h,08h,00h,051h,0E8h,04Eh,0C1h,059h
    db 083h,0FBh,0FFh,074h,03Ch,051h,049h,089h,04Fh,06h,083h,0C1h,08h,089h,04Fh,08h
    db 0A1h,0B2h,0A8h,089h,047h,04h,0A1h,0B4h,0A8h,089h,047h,02h,0C7h,07h,01h,00h
    db 0C7h,047h,01Eh,00h,00h,0C7h,047h,0Ah,01h,00h,0C7h,047h,014h,00h,00h,0C7h
    db 047h,016h,02h,00h,0C7h,047h,018h,03h,00h,0C7h,047h,01Ch,0FFh,0FFh,059h,0E2h
    db 0BAh,0C3h,055h,0B9h,023h,00h,033h,0C0h,051h,050h,08Bh,0D9h,0D1h,0E3h,08Bh,0AFh
    db 0CAh,032h,058h,083h,07Eh,00h,00h,074h,07h,083h,07Eh,016h,04h,075h,01h,040h
    db 059h,0E2h,0E5h,05Dh,0C3h,083h,03Eh,0A0h,0A7h,032h,073h,03h,0E9h,080h,01h,083h
    db 03Eh,0A0h,0A7h,05Ah,073h,03h,0E9h,0ACh,07h,0E9h,036h,01h,0E8h,0C3h,0FFh,03Dh
    db 01h,00h,074h,03h,0E9h,09Eh,07h,0C7h,06h,0B6h,0A8h,00h,00h,0C7h,06h,0B8h
    db 0A8h,00h,00h,0C7h,06h,0C2h,0A8h,01h,00h,0C7h,06h,0C4h,0A8h,0D4h,0D2h,0C7h
    db 046h,018h,078h,00h,0C7h,046h,08h,022h,00h,0C7h,046h,020h,0C8h,00h,0C7h,046h
    db 04h,00h,00h,0C7h,046h,02h,00h,00h,0C7h,046h,014h,02h,00h,0C7h,046h,028h
    db 0FFh,0FFh,089h,02Eh,0BEh,0A8h,0E8h,035h,0C0h,083h,0FBh,0FFh,074h,056h,09Ah,089h
    db 08h,07Fh,0Fh,0C7h,047h,018h,076h,00h,0C7h,047h,08h,020h,00h,089h,01Eh,0BAh
    db 0A8h,0E8h,01Ah,0C0h,083h,0FBh,0FFh,074h,03Bh,09Ah,089h,08h,07Fh,0Fh,0C7h,047h
    db 018h,077h,00h,0C7h,047h,08h,021h,00h,0C7h,047h,04h,020h,00h,089h,01Eh,0BCh
    db 0A8h,0E8h,0FAh,0BFh,083h,0FBh,0FFh,074h,01Bh,09Ah,089h,08h,07Fh,0Fh,0C7h,047h
    db 018h,079h,00h,0C7h,047h,08h,023h,00h,0C7h,047h,04h,020h,00h,089h,01Eh,0C0h
    db 0A8h,0E9h,01h,07h,0C7h,06h,07Eh,0A4h,00h,00h,0E8h,057h,0ADh,0E9h,0F5h,06h
    db 083h,03Eh,056h,023h,04h,075h,03h,0E9h,023h,0D8h,083h,03Eh,056h,023h,03h,075h
    db 03h,0E9h,021h,0FFh,083h,03Eh,056h,023h,00h,075h,03h,0E9h,02Eh,0FFh,081h,03Eh
    db 0A0h,0A7h,0C8h,00h,073h,03h,0E9h,096h,00h,081h,03Eh,0A0h,0A7h,0F0h,00h,073h
    db 03h,0E9h,0C1h,06h,0C7h,046h,018h,022h,00h,0C7h,046h,08h,071h,00h,08Bh,0Eh
    db 056h,023h,041h,0B8h,0Ah,00h,0F7h,0E1h,089h,046h,020h,0C7h,046h,04h,060h,00h
    db 0E9h,0A2h,06h

loc_0B5A9:
    mov word ptr ds:[0A8D0h], 0A8D2h
    mov word ptr ds:[0A8C8h], 0
    mov word ptr ds:[0A8CCh], 0
    ret
; UNKNOWN: not yet classified as code or data
    db 0FFh,0Eh,07Eh,0A4h,0C7h,046h,018h,064h,00h,0A1h,080h,023h,089h,046h,04h,0C7h
    db 046h,02h,00h,00h,0C7h,046h,08h,08Eh,00h,0E9h,06Dh,06h,0C7h,06h,0CEh,0A8h
    db 00h,00h,081h,03Eh,0D0h,0A8h,032h,0A9h,074h,0D6h,08Bh,036h,0D0h,0A8h,056h,0E8h
    db 06h,0CCh,05Eh,083h,0FBh,0FFh,074h,01Eh,0ADh,05h,020h,00h,089h,047h,034h,0ADh
    db 089h,047h,032h,0C7h,047h,018h,061h,00h,0C7h,047h,08h,0E7h,00h,0FFh,06h,07Eh
    db 0A4h,083h,06h,0D0h,0A8h,04h,0E9h,036h,06h,083h,03Eh,028h,023h,07h,074h,03h
    db 0E9h,02Ch,06h,0E8h,0C7h,0CBh,083h,0FBh,0FFh,075h,03h,0E9h,021h,06h,0E8h,046h
    db 00h,0C7h,047h,034h,010h,00h,0C7h,047h,018h,023h,00h,083h,03Eh,056h,023h,01h
    db 074h,020h,083h,03Eh,056h,023h,02h,074h,011h,083h,03Eh,056h,023h,03h,074h,012h
    db 083h,03Eh,056h,023h,05h,074h,0Bh,0E9h,0F5h,05h,0C7h,047h,020h,01h,00h,0E9h
    db 0EDh,05h,0C7h,047h,020h,0FFh,0FFh,0A1h,040h,023h,0FFh,06h,040h,023h,025h,03h
    db 00h,089h,047h,01Ch,0E9h,0D8h,05h,08Bh,036h,094h,0A8h,081h,0FEh,0B2h,0A8h,072h
    db 0Ah,0C7h,06h,094h,0A8h,096h,0A8h,08Bh,036h,094h,0A8h,0ADh,089h,047h,032h,089h
    db 036h,094h,0A8h,0C3h,08Bh,046h,04h,03Bh,046h,032h,074h,03h,0E9h,0C1h,01h,08Bh
    db 046h,02h,03Bh,046h,034h,074h,03h,0E9h,0B6h,01h,083h,07Eh,02h,020h,077h,012h
    db 083h,07Eh,02h,01Ch,072h,0Ch,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh
    db 0BEh,01Dh,083h,03Eh,056h,023h,02h,074h,03Ch,08Bh,076h,01Ch,0D1h,0E6h,0D1h,0E6h
    db 0B8h,032h,0A9h,033h,0C9h,0BAh,080h,00h,083h,03Eh,056h,023h,03h,074h,07h,083h
    db 03Eh,056h,023h,05h,075h,07h,0B8h,042h,0A9h,041h,0BAh,06Dh,00h,03h,0F0h,0ADh
    db 08Bh,0D8h,08Bh,07h,0D3h,0E8h,03h,0C2h,089h,046h,08h,0ADh,01h,046h,02h,01h
    db 046h,034h,0E9h,04Ah,05h,08Bh,0DDh,0E8h,0DCh,0BDh,0C7h,046h,018h,02Ch,00h,0E9h
    db 03Dh,05h,0A1h,03Ch,023h,05h,0B9h,00h,089h,046h,08h,0C7h,06h,012h,023h,02h
    db 00h,0E8h,022h,0A7h,0C7h,06h,012h,023h,03h,00h,0E9h,022h,05h
loc_0B729:
    mov ax, word ptr ss:[bp + REC_SAVED_X]
    mov word ptr ds:[02304h], ax
    mov ax, word ptr ss:[bp + REC_SAVED_Y]
    mov word ptr ds:[02306h], ax
    call loc_05DB2
    cmp word ptr ds:[0230Ah], 0
    ret
    cmp word ptr ss:[bp + REC_FIELD_1C], -1
    je loc_0B791
    mov bx, word ptr ss:[bp + REC_FIELD_1C]
    shl bx, 1
    jmp word ptr cs:[bx - 048B2h]
; UNKNOWN: not yet classified as code or data
    db 054h,0B7h,070h,0B7h,07Bh,0B7h
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
    mov word ptr ss:[bp + REC_SPRITE], 079h
    inc word ptr ss:[bp + REC_FIELD_1C]
    jmp near ptr loc_0BC4B
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
    cmp word ptr ds:[0A7A0h], 023h
    jae loc_0B7F3
    jmp near ptr loc_0BC4B
loc_0B7C7:
    cmp word ptr ds:[02324h], 1
    je loc_0B7D7
loc_0B7CE:
    mov ax, word ptr ds:[PRIMARY_RECORD + REC_X]
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
    cmp word ptr ds:[0A47Eh], 3
    jbe loc_0B7C7
    cmp word ptr ds:[02340h], 5
    jb loc_0B7CE
    cmp word ptr ds:[0232Eh], 03Fh
    je loc_0B826
    jmp near ptr loc_0BC4B
loc_0B826:
    mov si, word ptr ds:[0A842h]
    cmp si, 0A894h
    jb loc_0B83A
    mov word ptr ds:[0A842h], 0A844h
    mov si, word ptr ds:[0A842h]
loc_0B83A:
    lodsw
    add ax, 020h
    mov word ptr ss:[bp + REC_SAVED_Y], ax
    lodsw
    mov word ptr ss:[bp + REC_SAVED_X], ax
    mov word ptr ds:[0A842h], si
    mov ax, word ptr ss:[bp + REC_Y]
    cmp ax, word ptr ss:[bp + REC_SAVED_Y]
    jne loc_0B859
    mov ax, word ptr ss:[bp + REC_X]
    cmp ax, word ptr ss:[bp + REC_SAVED_X]
    je loc_0B826
loc_0B859:
    jmp near ptr loc_0BC4B
loc_0B85C:
    mov word ptr ds:[02308h], 2
    call loc_0B729
    mov word ptr ss:[bp + REC_DIRECTION], 4
    jmp near ptr loc_0BC4B
; UNKNOWN: not yet classified as code or data
    db 083h,03Eh,07Eh,0A4h,02h,077h,03h,0E9h,081h,00h,081h,07Eh,02h,0C0h,00h,077h
    db 07Ah,083h,03Eh,0A0h,0A7h,028h,073h,02Bh,0C7h,06h,08h,023h,01h,00h,0C7h,046h
    db 08h,075h,00h,083h,066h,032h,0FEh,083h,066h,04h,0FEh,083h,066h,034h,0FEh,083h
    db 066h,02h,0FEh,0E8h,086h,0FEh,075h,03h,0E9h,0A3h,03h,0C7h,046h,06h,04h,00h
    db 0E9h,09Bh,03h,081h,03Eh,040h,023h,0EFh,02h,075h,03h,0E8h,0BBh,0BBh,081h,03Eh
    db 040h,023h,059h,01h,075h,03h,0E8h,0B0h,0BBh,083h,03Eh,040h,023h,079h,075h,03h
    db 0E8h,0A6h,0BBh,0A1h,042h,023h,0F7h,0D8h,01h,046h,02h,0B8h,075h,00h,083h,03Eh
    db 042h,023h,0FFh,074h,03h,0B8h,076h,00h,089h,046h,08h,083h,03Eh,028h,023h,07h
    db 074h,03h,0E9h,059h,03h,0FFh,046h,02h,0E9h,053h,03h,0BBh,07Ch,023h,0E8h,01Dh
    db 0A5h,0E8h,041h,0A5h,0C7h,046h,08h,076h,00h,0E9h,042h,03h,0C7h,06h,08h,023h
    db 02h,00h,0E8h,017h,0FEh,075h,03h,0E9h,034h,03h,0E8h,05Ch,0BBh,083h,07Eh,032h
    db 00h,074h,08h,0C7h,046h,032h,00h,00h,0E9h,023h,03h,0C7h,046h,032h,0C0h,00h
    db 0E9h,01Bh,03h,0C7h,06h,08h,023h,01h,00h,083h,03Eh,056h,023h,00h,075h,06h
    db 0C7h,06h,08h,023h,02h,00h,0E8h,0E3h,0FDh,09Ch,08Bh,046h,06h,05h,0Dh,01h
    db 089h,046h,08h,09Dh,075h,03h,0E9h,0F5h,02h,083h,07Eh,01Ch,00h,074h,01Eh,0FFh
    db 04Eh,01Ch,074h,03h,0E9h,0E7h,02h,0C7h,046h,034h,020h,00h,083h,07Eh,018h,016h
    db 075h,03h,0E9h,0D9h,02h,0C7h,046h,034h,040h,00h,0E9h,0D1h,02h,083h,03Eh,0A0h
    db 0A7h,031h,074h,03h,0E9h,0C7h,02h,0C7h,046h,018h,018h,00h,0E9h,0BFh,02h,0A1h
    db 040h,023h,025h,0FFh,03h,03Dh,0Ch,00h,075h,07h,0E8h,0DCh,0BAh,0FFh,06h,040h
    db 023h,08Bh,076h,036h,0ADh,03Dh,0FFh,0FFh,074h,043h,05h,020h,00h,0A3h,06h,023h
    db 0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,03h,00h,0E8h,0F8h,0A3h,08Bh,046h,06h
    db 05h,0Dh,01h,089h,046h,08h,083h,03Eh,0Ah,023h,00h,075h,03h,0E9h,07Eh,02h
    db 089h,076h,036h,0E8h,0C2h,093h,083h,0E3h,07h,083h,0FBh,02h,075h,0B1h,0E8h,059h
    db 08h,083h,0FBh,0FFh,074h,0A9h,0C7h,047h,06h,04h,00h,0EBh,0A2h,0ADh,089h,046h
    db 036h,0EBh,09Ch,081h,03Eh,082h,0A4h,0E4h,0A4h,075h,06Fh,081h,03Eh,040h,023h,0EFh
    db 02h,075h,07h,0E8h,073h,0BAh,0FFh,06h,040h,023h,0A1h,042h,023h,01h,046h,032h
    db 0A1h,046h,023h,01h,046h,034h,081h,07Eh,034h,0D0h,00h,076h,05h,0C7h,046h,034h
    db 020h,00h,08Bh,046h,04h,03h,06h,042h,023h,03Bh,046h,032h,075h,06Eh,08Bh,046h
    db 02h,03Bh,046h,034h,075h,066h,083h,03Eh,07Eh,0A4h,06h,072h,020h,0A1h,040h,023h
    db 083h,03Eh,0DCh,0BEh,02h,074h,0Ah,025h,0FFh,00h,03Dh,0FFh,00h,075h,01Bh,0EBh
    db 08h,025h,07Fh,00h,03Dh,07Fh,00h,075h,011h,0FFh,06h,040h,023h,0BBh,07Ch,023h
    db 0E8h,0BBh,0A3h,0E8h,0DFh,0A3h,083h,046h,02h,02h,0A1h,03Ch,023h,05h,01Ch,00h
    db 089h,046h,08h,0E9h,0D8h,01h,08Bh,046h,032h,025h,0FEh,0FFh,083h,066h,04h,0FEh
    db 0A3h,04h,023h,08Bh,046h,034h,025h,0FEh,0FFh,083h,066h,02h,0FEh,0A3h,06h,023h
    db 0C7h,06h,08h,023h,01h,00h,0E8h,01Ch,0A3h,0E9h,0B2h,01h,08Bh,046h,02h,03Bh
    db 046h,034h,076h,0D2h,0E8h,09Eh,0A3h,083h,03Eh,07Eh,0A4h,06h,073h,0Ah,083h,03Eh
    db 02Eh,023h,03Fh,075h,03h,0E8h,0C1h,0B9h,081h,07Eh,02h,0D0h,00h,077h,03h,0E9h
    db 08Ch,01h,0C7h,046h,02h,010h,00h,0E9h,084h,01h,0A1h,038h,023h,0D1h,0E8h,05h
    db 027h,00h,089h,046h,08h,0EBh,0Bh,0A1h,038h,023h,0D1h,0E8h,05h,024h,00h,089h
    db 046h,08h,0EBh,022h
    push word ptr ss:[bp + REC_DIRECTION]
    mov word ptr ss:[bp + REC_DIRECTION], 4
    call loc_0C237
    pop word ptr ss:[bp + REC_DIRECTION]
    ret
; UNKNOWN: not yet classified as code or data
    db 0A1h,03Ah,023h,05h,036h,00h,089h,046h,08h,083h,03Eh,02Eh,023h,03Fh,075h,03h
    db 0E8h,0DEh,0FFh,083h,07Eh,06h,06h,075h,01Bh,0C7h,046h,06h,06h,00h,083h,07Eh
    db 04h,00h,074h,08h,0E8h,0C1h,0F4h,075h,03h,0E9h,029h,01h,0C7h,046h,06h,02h
    db 00h,0E9h,021h,01h,0C7h,046h,06h,02h,00h,081h,07Eh,04h,0C0h,00h,074h,08h
    db 0E8h,0A5h,0F4h,075h,03h,0E9h,0Dh,01h,0C7h,046h,06h,06h,00h,0E9h,05h,01h
    db 0C7h,06h,052h,0A9h,0FFh,0FFh,0EBh,06h,0C7h,06h,052h,0A9h,01h,00h,0E8h,09Ch
    db 00h,0BBh,00h,00h,074h,0Ah,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h
    db 0B8h,03Ah,01h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h
    db 0C3h,033h,0C9h,083h,07Eh,06h,00h,074h,03h,0B9h,03h,00h,03h,0C1h,0EBh,032h
    db 0C7h,06h,052h,0A9h,0FFh,0FFh,0EBh,06h,0C7h,06h,052h,0A9h,01h,00h,0E8h,05Ch
    db 00h,0BBh,00h,00h,074h,04h,08Bh,01Eh,03Ch,023h,0B8h,061h,00h,03h,06h,052h
    db 0A9h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,0C3h,03h
    db 046h,06h,089h,046h,08h,083h,03Eh,030h,023h,07Fh,074h,0Eh,083h,03Eh,030h,023h
    db 06Bh,074h,07h,083h,03Eh,030h,023h,057h,075h,07Bh,0E8h,0A9h,0B8h,083h,0FBh,0FFh
    db 074h,073h,0C7h,047h,08h,03h,00h,083h,06Fh,04h,08h,083h,06Fh,02h,08h,0EBh
    db 064h,0C7h,06h,030h,0A4h,01h,00h,083h,03Eh,030h,0A4h,01h,0C3h,0C7h,06h,030h
    db 0A4h,00h,00h,0C7h,046h,06h,00h,00h,0FFh,076h,02h,0A1h,078h,0A2h,01h,046h
    db 02h,083h,06Eh,02h,010h,0E8h,06Bh,094h,08Fh,046h,02h,083h,0FBh,0FFh,074h,0D1h
    db 08Bh,046h,02h,03Bh,06h,07Eh,023h,07Ch,012h,03h,01Eh,052h,0A9h,0E8h,03Bh,094h
    db 074h,0BFh,0E8h,0B3h,0F3h,083h,03Eh,030h,0A4h,01h,0C3h,0C7h,046h,06h,04h,00h
    db 03h,01Eh,052h,0A9h,083h,0EBh,0Dh,0E8h,021h,094h,074h,0A5h,0E8h,099h,0F3h,083h
    db 03Eh,030h,0A4h,01h,0C3h
loc_0BC45:
    mov ax, word ptr ds:[0A278h]
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
    cmp word ptr ds:[0A8C2h], 1
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
    mov bx, POOL_A
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
    cmp word ptr ds:[02324h], 1
    je loc_0BE46
    jmp near ptr loc_0BC45
loc_0BE46:
    inc word ptr ss:[bp + REC_ANIM_COUNTER]
    mov bx, word ptr ss:[bp + REC_SIZE_CLASS]
    shl bx, 1
    jmp word ptr cs:[bx - 041ACh]
; UNKNOWN: not yet classified as code or data
    db 090h,045h,0BCh,05Ah,0BEh,0B0h,0BEh
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
; UNKNOWN: not yet classified as code or data
    db 083h,07Eh,022h,0Ch,075h,03h,0E9h,05Eh,0FEh,08Bh,046h,022h,05h,03h,00h,089h
    db 046h,08h,0E9h,080h,0FDh
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
    cmp word ptr ds:[0A8C2h], 1
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
    cmp word ptr ds:[0BEDCh], 1
    je loc_0BF4D
    cmp word ptr ds:[0BEDCh], 0
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
    cmp word ptr ds:[0A8C2h], 1
    je loc_0BF5F
    ret
loc_0BF5F:
    push bp
    mov bp, word ptr ds:[0A8BAh]
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    mov bp, word ptr ds:[0A8BCh]
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    mov bp, word ptr ds:[0A8BEh]
    mov word ptr ss:[bp + REC_FLASH_TIMER], 5
    mov bp, word ptr ds:[0A8C0h]
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
    cmp word ptr ds:[0A8C2h], 1
    je loc_0BF25
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short loc_0BFC7
loc_0BFA8:
    cmp word ptr ds:[0A8C2h], 1
    jne loc_0BFB2
    jmp near ptr loc_0BF25
loc_0BFB2:
    mov word ptr ss:[bp + REC_HIT_POINTS], 0
    jmp short loc_0BFC7
loc_0BFB9:
    cmp word ptr ds:[0A8C2h], 1
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
    jmp word ptr cs:[bx - 03FBEh]
; UNKNOWN: not yet classified as code or data
    db 090h,0AFh,044h,048h,0C0h,04Eh,0C0h
    mov word ptr ss:[bp + REC_SPRITE], 0
    ret
; UNKNOWN: not yet classified as code or data
    db 0C7h,046h,08h,03h,00h,0C3h

MAIN ends
end