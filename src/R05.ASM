; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
include MOVEMENT.INC
part05 segment byte public 'CODE'
assume cs:part05,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; Fields scoped to the AC56 response path; no entity/health identity asserted.
RESPONSE_COUNTER_20 equ 020h
RESPONSE_WORD_24 equ 024h
UpdatePlacementXOffsetsAtRecordEdges_0A616 equ 0616h
; Offset-placement use of field+8 does not define its role in other record types.
ApplyPositionHistoryToRecords_0A031 equ 031h
; Modern position-history symbols; see metadata/position-history.json.
; Modern record/state symbols; evidence in metadata/record-movement.json.
DecRecordYByMode_0A5D1 equ 05D1h
IncRecordYTwice_0A5EA equ 05EAh
DecRecordXTwice_0A5F9 equ 05F9h
IncRecordXTwice_0A607 equ 0607h
loc_0AECD equ 0ECDh
loc_0AED6 equ 0ED6h
loc_0AEE4 equ 0EE4h
loc_0AF60 equ 0F60h
loc_0B00D equ 0100Dh
loc_0B032 equ 01032h
loc_0B053 equ 01053h
loc_0B06A equ 0106Ah
loc_0B076 equ 01076h
loc_0B07D equ 0107Dh
loc_0B09C equ 0109Ch
loc_0B0B4 equ 010B4h
loc_0B0C5 equ 010C5h
loc_0B0D7 equ 010D7h
loc_0B0EA equ 010EAh
loc_0B102 equ 01102h
loc_0B10A equ 0110Ah
loc_0B10F equ 0110Fh
loc_0B121 equ 01121h
loc_0B134 equ 01134h
loc_0B14C equ 0114Ch
loc_0B158 equ 01158h
loc_0BDD0 equ 01DD0h
loc_0BDE3 equ 01DE3h
loc_0BE35 equ 01E35h
loc_0BE3A equ 01E3Ah
loc_0C237 equ 02237h
loc_04D95 equ 0AD95h
loc_05059 equ 0B059h
ReadIndexedByteAttribute_0505B equ 0B05Bh
ComputeRecordGridOffset_05073 equ 0B073h
loc_05DB2 equ 0BDB2h
loc_05E42 equ 0BE42h
loc_062F6 equ 0C2F6h
loc_07476 equ 0D476h
loc_08331 equ 0E331h
loc_09E19 equ 0FE19h
loc_09E69 equ 0FE69h
loc_0AA44 equ 0A44h
loc_0AA46 equ 0A46h
loc_0AA71 equ 0A71h
loc_0AAAB equ 0AABh
loc_0AACD equ 0ACDh
loc_0AAD3 equ 0AD3h
loc_0AADB equ 0ADBh
loc_0AAE7 equ 0AE7h
loc_0AB1A equ 0B1Ah
loc_0AB24 equ 0B24h
loc_0AB34 equ 0B34h
loc_0AB4F equ 0B4Fh
loc_0AB59 equ 0B59h
loc_0AB61 equ 0B61h
loc_0AB69 equ 0B69h
loc_0AB71 equ 0B71h
loc_0AB77 equ 0B77h
loc_0AB8C equ 0B8Ch
loc_0AB8F equ 0B8Fh
loc_0AB99 equ 0B99h
loc_0ABA3 equ 0BA3h
loc_0ABBD equ 0BBDh
loc_0ABC0 equ 0BC0h
loc_0ABCA equ 0BCAh
loc_0ABDC equ 0BDCh
loc_0ABE4 equ 0BE4h
loc_0ABEA equ 0BEAh
loc_0ABF3 equ 0BF3h
loc_0ABF9 equ 0BF9h
loc_0AC05 equ 0C05h
loc_0AC22 equ 0C22h
loc_0AC28 equ 0C28h
loc_0AC32 equ 0C32h
ProbeGridForRecordResponse_0AC3C equ 0C3Ch
RecordResponseReturnClear_0AC54 equ 0C54h
SetResponseAndStepRecordCounter_0AC56 equ 0C56h
SetRecordResponseWord_0AC62 equ 0C62h
StepRecordResponseCounter_0AC75 equ 0C75h
loc_0AC81 equ 0C81h
loc_0AC8B equ 0C8Bh
loc_0AC97 equ 0C97h
loc_0ACD2 equ 0CD2h
loc_0ACD9 equ 0CD9h
loc_0ACE8 equ 0CE8h
loc_0ACF7 equ 0CF7h
loc_0ACF9 equ 0CF9h
loc_0AD14 equ 0D14h
loc_0AD1D equ 0D1Dh
loc_0AD26 equ 0D26h
loc_0AD2F equ 0D2Fh
loc_0AD38 equ 0D38h
loc_0AD41 equ 0D41h
loc_0AD4D equ 0D4Dh
loc_0AD59 equ 0D59h
loc_0AD5A equ 0D5Ah
loc_0AD60 equ 0D60h
loc_0AD69 equ 0D69h
loc_0AD73 equ 0D73h
loc_0AD7D equ 0D7Dh
loc_0ADAF equ 0DAFh
loc_0ADC8 equ 0DC8h
loc_0ADC9 equ 0DC9h
loc_0AEE0 equ 0EE0h
loc_0AF63 equ 0F63h
loc_0B297 equ 01297h
loc_0B2A3 equ 012A3h
loc_0B729 equ 01729h
loc_0B75F equ 0175Fh
loc_0B76A equ 0176Ah
loc_0B789 equ 01789h
loc_0B791 equ 01791h
loc_0B7A1 equ 017A1h
loc_0B7A4 equ 017A4h
loc_0B7B2 equ 017B2h
loc_0B7BD equ 017BDh
loc_0B7C7 equ 017C7h
loc_0B7CE equ 017CEh
loc_0B7D7 equ 017D7h
loc_0B7F3 equ 017F3h
loc_0B80E equ 0180Eh
loc_0B826 equ 01826h
loc_0B83A equ 0183Ah
loc_0B859 equ 01859h
loc_0B85C equ 0185Ch
loc_0BC45 equ 01C45h
loc_0BC4B equ 01C4Bh
loc_0BC8A equ 01C8Ah
loc_0BC94 equ 01C94h
loc_0BC96 equ 01C96h
loc_0BCA3 equ 01CA3h
loc_0BCB0 equ 01CB0h
loc_0BCCB equ 01CCBh
loc_0BCD2 equ 01CD2h
loc_0BCD9 equ 01CD9h
loc_0BCE0 equ 01CE0h
loc_0BCE7 equ 01CE7h
loc_0BCF4 equ 01CF4h
loc_0BCF9 equ 01CF9h
loc_0BCFC equ 01CFCh
loc_0BCFF equ 01CFFh
loc_0BD09 equ 01D09h
loc_0BD0D equ 01D0Dh
loc_0BE46 equ 01E46h
loc_0BE6F equ 01E6Fh
loc_0BE84 equ 01E84h
loc_0BE97 equ 01E97h
loc_0BEA4 equ 01EA4h
loc_0BECE equ 01ECEh
loc_0BED7 equ 01ED7h
loc_0BEE0 equ 01EE0h
loc_0BEE9 equ 01EE9h
loc_0BEF8 equ 01EF8h
loc_0BF01 equ 01F01h
loc_0BF07 equ 01F07h
loc_0BF1B equ 01F1Bh
loc_0BF25 equ 01F25h
loc_0BF2D equ 01F2Dh
loc_0BF35 equ 01F35h
loc_0BF4D equ 01F4Dh
loc_0BF52 equ 01F52h
loc_0BF5F equ 01F5Fh
loc_0BF90 equ 01F90h
loc_0BF92 equ 01F92h
loc_0BF97 equ 01F97h
loc_0BFA8 equ 01FA8h
loc_0BFB2 equ 01FB2h
loc_0BFB9 equ 01FB9h
loc_0BFC7 equ 01FC7h
CopyRecordPositionPlus10_0A571 equ 0571h
DecRecordYUnlessAtMin_0A5DB equ 05DBh
DecRecordXUnlessZero_0A5FC equ 05FCh
IncRecordYUnlessAtMax_0A5ED equ 05EDh
IncRecordXBelowMax_0A60A equ 060Ah
loc_04A65 equ 0AA65h
loc_04CED equ 0ACEDh
loc_04D64 equ 0AD64h
loc_05A7E equ 0BA7Eh
loc_05A92 equ 0BA92h
loc_05AC8 equ 0BAC8h
loc_05F0D equ 0BF0Dh
loc_062AA equ 0C2AAh
FindFreeRecordPoolA_07524 equ 0D524h
loc_07547 equ 0D547h
loc_07596 equ 0D596h
loc_07746 equ 0D746h
loc_07948 equ 0D948h
loc_0837A equ 0E37Ah
loc_0859E equ 0E59Eh
loc_0A01F equ 01Fh
loc_0A030 equ 030h
loc_0A048 equ 048h
loc_0A05F equ 05Fh
loc_0A060 equ 060h
loc_0A084 equ 084h
loc_0A0A3 equ 0A3h
loc_0A0A6 equ 0A6h
loc_0A0CE equ 0CEh
loc_0A0D8 equ 0D8h
loc_0A0E8 equ 0E8h
loc_0A0F2 equ 0F2h
loc_0A0FC equ 0FCh
loc_0A114 equ 0114h
loc_0A11C equ 011Ch
loc_0A128 equ 0128h
loc_0A175 equ 0175h
loc_0A19F equ 019Fh
loc_0A1AB equ 01ABh
loc_0A1AE equ 01AEh
loc_0A1C8 equ 01C8h
loc_0A1D4 equ 01D4h
loc_0A211 equ 0211h
loc_0A21A equ 021Ah
loc_0A22A equ 022Ah
loc_0A234 equ 0234h
loc_0A255 equ 0255h
loc_0A258 equ 0258h
loc_0A262 equ 0262h
loc_0A271 equ 0271h
loc_0A289 equ 0289h
loc_0A294 equ 0294h
loc_0A2A0 equ 02A0h
loc_0A2A8 equ 02A8h
loc_0A2B4 equ 02B4h
loc_0A2D6 equ 02D6h
loc_0A378 equ 0378h
loc_0A37E equ 037Eh
loc_0A386 equ 0386h
loc_0A38E equ 038Eh
loc_0A396 equ 0396h
loc_0A3A6 equ 03A6h
loc_0A3CA equ 03CAh
loc_0A3FF equ 03FFh
loc_0A41A equ 041Ah
loc_0A420 equ 0420h
loc_0A4EA equ 04EAh
loc_0A515 equ 0515h
loc_0A51D equ 051Dh
loc_0A525 equ 0525h
loc_0A53C equ 053Ch
loc_0A568 equ 0568h
loc_0A584 equ 0584h
loc_0A58C equ 058Ch
loc_0A594 equ 0594h
loc_0A5A4 equ 05A4h
loc_0A5E2 equ 05E2h
loc_0A5E6 equ 05E6h
loc_0A5F5 equ 05F5h
loc_0A603 equ 0603h
loc_0A612 equ 0612h
loc_0A61F equ 061Fh
loc_0A63B equ 063Bh
loc_0A63C equ 063Ch
loc_0A647 equ 0647h
UpdatePlacementXGroupA_0A648 equ 0648h
loc_0A65D equ 065Dh
loc_0A662 equ 0662h
loc_0A66A equ 066Ah
loc_0A679 equ 0679h
loc_0A6A8 equ 06A8h
loc_0A6C8 equ 06C8h
loc_0A6FA equ 06FAh
loc_0A6FD equ 06FDh
loc_0A6FE equ 06FEh
loc_0A714 equ 0714h
loc_0A72F equ 072Fh
loc_0A73C equ 073Ch
loc_0A744 equ 0744h
loc_0A746 equ 0746h
loc_0A74E equ 074Eh
loc_0A765 equ 0765h
loc_0A77A equ 077Ah
loc_0A79E equ 079Eh
loc_0A7B9 equ 07B9h
loc_0A7C6 equ 07C6h
loc_0A7D0 equ 07D0h
loc_0A7E3 equ 07E3h
loc_0A7EB equ 07EBh
loc_0A81B equ 081Bh
loc_0A82D equ 082Dh
loc_0A83F equ 083Fh
loc_0A849 equ 0849h
loc_0A85B equ 085Bh
loc_0A861 equ 0861h
loc_0A873 equ 0873h
loc_0A87C equ 087Ch
loc_0A88E equ 088Eh
loc_0A894 equ 0894h
loc_0A8B8 equ 08B8h
loc_0A8C1 equ 08C1h
loc_0A8C7 equ 08C7h
loc_0A8EB equ 08EBh
loc_0A8F4 equ 08F4h
loc_0A8FF equ 08FFh
loc_0A90B equ 090Bh
loc_0A90F equ 090Fh
loc_0A921 equ 0921h
loc_0A927 equ 0927h
loc_0A939 equ 0939h
loc_0A94B equ 094Bh
loc_0A97B equ 097Bh
loc_0A980 equ 0980h
loc_0A9A9 equ 09A9h
loc_0A9B3 equ 09B3h
loc_0A9B8 equ 09B8h
loc_0A9BD equ 09BDh
loc_0A9D3 equ 09D3h
loc_0A9DD equ 09DDh
loc_0A9E0 equ 09E0h
loc_0A9FB equ 09FBh
loc_0AA04 equ 0A04h
loc_0AA10 equ 0A10h
loc_0AA22 equ 0A22h
loc_0AA2B equ 0A2Bh
loc_0AC19 equ 0C19h
loc_0B15A equ 0115Ah
loc_0B161 equ 01161h
loc_0B191 equ 01191h
loc_0B19A equ 0119Ah
loc_0B1A6 equ 011A6h
loc_0BCB1 equ 01CB1h
loc_0BCBF equ 01CBFh
loc_0BCC5 equ 01CC5h
loc_0BD17 equ 01D17h
loc_0BD43 equ 01D43h
loc_0BD56 equ 01D56h
loc_0BD5C equ 01D5Ch
loc_0BD66 equ 01D66h
loc_0BD6D equ 01D6Dh
loc_0BD7A equ 01D7Ah
loc_0BD82 equ 01D82h
loc_0BD88 equ 01D88h
loc_0BD8F equ 01D8Fh
loc_0BD9E equ 01D9Eh
loc_0BDA9 equ 01DA9h
loc_0BDAC equ 01DACh
loc_0BDB7 equ 01DB7h
loc_0BDB8 equ 01DB8h
loc_0BDC3 equ 01DC3h
loc_0BDC4 equ 01DC4h
loc_0BDCF equ 01DCFh
loc_0BFD5 equ 01FD5h
loc_0BFE1 equ 01FE1h
loc_0C017 equ 02017h
loc_0C054 equ 02054h
loc_0C591 equ 02591h
loc_0CB1C equ 02B1Ch
loc_0F797 equ 05797h
; Continuation of PlaceRecordFromOffsetPair_09FEA across the physical
; chunk boundary: same routine, not a separate clamp/feedback producer.
; @0A000 0000:A000 original=ad
    lodsw
; @0A001 0000:A001 original=034604
    add ax, word ptr ss:[bp + REC_X]
; @0A004 0000:A004 original=030698a3
    add ax, word ptr ds:[OFFSET_X_WORK]
; @0A008 0000:A008 original=030698a3
    add ax, word ptr ds:[OFFSET_X_WORK]
; @0A00C 0000:A00C original=894704
    mov word ptr ds:[bx + REC_X], ax
; @0A00F 0000:A00F original=837f0400
    cmp word ptr ds:[bx + REC_X], 0
; @0A013 0000:A013 original=7d0a
    JGE_SHORT loc_0A01F
; @0A015 0000:A015 original=c747040000
    mov word ptr ds:[bx + REC_X], 0
; @0A01A 0000:A01A original=c6069ea301
    mov byte ptr ds:[CLAMP_X_LOW_SEEN], 1
; @0A01F 0000:A01F original=817f04c000
    cmp word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
; @0A024 0000:A024 original=7e0a
    JLE_SHORT loc_0A030
; @0A026 0000:A026 original=c74704c000
    mov word ptr ds:[bx + REC_X], PLACEMENT_X_SIGNED_MAX
; @0A02B 0000:A02B original=c6069fa301
    mov byte ptr ds:[CLAMP_X_HIGH_SEEN], 1
; @0A030 0000:A030 original=c3
    ret
; sub_0000_A031
; ApplyPositionHistoryToRecords (modern reconstruction name)
; Near leaf. If DS:A962 !=FFFF, copy two sequential words from DS:[DS:A33C] to record DS:[DS:A962]+2/+4. Then
; independently do the same for A964/A33E. With DF=0 these are Y/X pairs and SI advances4 after the last copy;
; AX=last X,BX=last destination. If neither slot exists AX/BX/SI unchanged. Flags are always CMP(A964,FFFF),
; even on copy; caller9BE8 overwrites them. CX,DX,DI,BP and segments preserved. Requires valid selected
; pointers; pair abstraction assumes destinations do not alias cursors/slots/source. Actual load/store order
; remains significant; no activation/type checks.
; Evidence: metadata/symbols.json
; @0A031 0000:A031 original=833e62a9ff
    cmp word ptr ds:[HISTORY_RECORD_SLOT_15], -1
; @0A036 0000:A036 original=7410
    JE_SHORT loc_0A048
; @0A038 0000:A038 original=8b1e62a9
    mov bx, word ptr ds:[HISTORY_RECORD_SLOT_15]
; @0A03C 0000:A03C original=8b363ca3
    mov si, word ptr ds:[HISTORY_READ_CURSOR_15]
; @0A040 0000:A040 original=ad
    lodsw
; @0A041 0000:A041 original=894702
    mov word ptr ds:[bx + REC_Y], ax
; @0A044 0000:A044 original=ad
    lodsw
; @0A045 0000:A045 original=894704
    mov word ptr ds:[bx + REC_X], ax
; @0A048 0000:A048 original=833e64a9ff
    cmp word ptr ds:[HISTORY_RECORD_SLOT_31], -1
; @0A04D 0000:A04D original=7410
    JE_SHORT loc_0A05F
; @0A04F 0000:A04F original=8b1e64a9
    mov bx, word ptr ds:[HISTORY_RECORD_SLOT_31]
; @0A053 0000:A053 original=8b363ea3
    mov si, word ptr ds:[HISTORY_READ_CURSOR_31]
; @0A057 0000:A057 original=ad
    lodsw
; @0A058 0000:A058 original=894702
    mov word ptr ds:[bx + REC_Y], ax
; @0A05B 0000:A05B original=ad
    lodsw
; @0A05C 0000:A05C original=894704
    mov word ptr ds:[bx + REC_X], ax
; @0A05F 0000:A05F original=c3
    ret
; @0A060 0000:A060 original=c70680a90000
    mov word ptr ds:[0A980h], 0
; @0A066 0000:A066 original=c3
    ret
; sub_0000_A067
; @0A067 0000:A067 original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0A06C 0000:A06C original=74f2
    JE_SHORT loc_0A060
; @0A06E 0000:A06E original=833e80a900
    cmp word ptr ds:[0A980h], 0
; @0A073 0000:A073 original=740f
    JE_SHORT loc_0A084
; @0A075 0000:A075 original=803e909701
    cmp byte ptr ds:[09790h], 1
; @0A07A 0000:A07A original=7408
    JE_SHORT loc_0A084
; @0A07C 0000:A07C original=833e2a230f
    cmp word ptr ds:[0232Ah], 0Fh
; @0A081 0000:A081 original=7401
    JE_SHORT loc_0A084
; @0A083 0000:A083 original=c3
    ret
; @0A084 0000:A084 original=c70680a90100
    mov word ptr ds:[0A980h], 1
; @0A08A 0000:A08A original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @0A090 0000:A090 original=7714
    JA_SHORT loc_0A0A6
; @0A092 0000:A092 original=833eacbd00
    cmp word ptr ds:[0BDACh], 0
; @0A097 0000:A097 original=750d
    JNE_SHORT loc_0A0A6
; @0A099 0000:A099 original=833e58a902
    cmp word ptr ds:[0A958h], 2
; @0A09E 0000:A09E original=7503
    JNE_SHORT loc_0A0A3
; @0A0A0 0000:A0A0 original=e92501
    JMP_NEAR loc_0A1C8
; @0A0A3 0000:A0A3 original=e9f900
    JMP_NEAR loc_0A19F
; @0A0A6 0000:A0A6 original=a170a9
    mov ax, word ptr ds:[0A970h]
; @0A0A9 0000:A0A9 original=a3a0a3
    mov word ptr ds:[0A3A0h], ax
; @0A0AC 0000:A0AC original=a172a9
    mov ax, word ptr ds:[0A972h]
; @0A0AF 0000:A0AF original=a3a2a3
    mov word ptr ds:[0A3A2h], ax
; @0A0B2 0000:A0B2 original=a176a9
    mov ax, word ptr ds:[0A976h]
; @0A0B5 0000:A0B5 original=a3a4a3
    mov word ptr ds:[0A3A4h], ax
; @0A0B8 0000:A0B8 original=a174a9
    mov ax, word ptr ds:[0A974h]
; @0A0BB 0000:A0BB original=a3a6a3
    mov word ptr ds:[0A3A6h], ax
; @0A0BE 0000:A0BE original=833eacbd01
    cmp word ptr ds:[0BDACh], 1
; @0A0C3 0000:A0C3 original=7513
    JNE_SHORT loc_0A0D8
; @0A0C5 0000:A0C5 original=833e06be08
    cmp word ptr ds:[0BE06h], 8
; @0A0CA 0000:A0CA original=7502
    JNE_SHORT loc_0A0CE
; @0A0CC 0000:A0CC original=eb46
    JMP_SHORT loc_0A114
; @0A0CE 0000:A0CE original=833e06be0f
    cmp word ptr ds:[0BE06h], 0Fh
; @0A0D3 0000:A0D3 original=7603
    JBE_SHORT loc_0A0D8
; @0A0D5 0000:A0D5 original=e93d04
    JMP_NEAR loc_0A515
; @0A0D8 0000:A0D8 original=e83a04
    CALL_NEAR loc_0A515
; @0A0DB 0000:A0DB original=e8a604
    CALL_NEAR loc_0A584
; @0A0DE 0000:A0DE original=e81e03
    CALL_NEAR loc_0A3FF
; @0A0E1 0000:A0E1 original=e8e602
    CALL_NEAR loc_0A3CA
; @0A0E4 0000:A0E4 original=e80100
    CALL_NEAR loc_0A0E8
; @0A0E7 0000:A0E7 original=c3
    ret
; sub_0000_A0E8
; @0A0E8 0000:A0E8 original=833e58a905
    cmp word ptr ds:[0A958h], 5
; @0A0ED 0000:A0ED original=7503
    JNE_SHORT loc_0A0F2
; @0A0EF 0000:A0EF original=e8ae01
    CALL_NEAR loc_0A2A0
; @0A0F2 0000:A0F2 original=833e6ea9ff
    cmp word ptr ds:[0A96Eh], -1
; @0A0F7 0000:A0F7 original=7403
    JE_SHORT loc_0A0FC
; @0A0F9 0000:A0F9 original=e81800
    CALL_NEAR loc_0A114
; @0A0FC 0000:A0FC original=8b1e58a9
    mov bx, word ptr ds:[0A958h]
; @0A100 0000:A100 original=d1e3
    shl bx, 1
; @0A102 0000:A102 original=2effa708a1
    jmp word ptr cs:[bx - 05EF8h]
; @0A107 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,09Fh,0A1h,08Ah,0A1h,0C8h,0A1h,037h,0A3h,0F6h,0A2h,0AFh,044h
; sub_0000_A114
; @0A114 0000:A114 original=833ea6a300
    cmp word ptr ds:[0A3A6h], 0
; @0A119 0000:A119 original=7401
    JE_SHORT loc_0A11C
; @0A11B 0000:A11B original=c3
    ret
; @0A11C 0000:A11C original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A121 0000:A121 original=7405
    JE_SHORT loc_0A128
; @0A123 0000:A123 original=c606ffbe18
    mov byte ptr ds:[0BEFFh], 018h
; @0A128 0000:A128 original=ff0674a9
    inc word ptr ds:[0A974h]
; @0A12C 0000:A12C original=e84600
    CALL_NEAR loc_0A175
; @0A12F 0000:A12F original=2d0600
    sub ax, 6
; @0A132 0000:A132 original=894702
    mov word ptr ds:[bx + 2], ax
; @0A135 0000:A135 original=8b4404
    mov ax, word ptr ds:[si + 4]
; @0A138 0000:A138 original=050400
    add ax, 4
; @0A13B 0000:A13B original=894704
    mov word ptr ds:[bx + 4], ax
; @0A13E 0000:A13E original=ff0674a9
    inc word ptr ds:[0A974h]
; @0A142 0000:A142 original=e83000
    CALL_NEAR loc_0A175
; @0A145 0000:A145 original=2d0200
    sub ax, 2
; @0A148 0000:A148 original=894702
    mov word ptr ds:[bx + 2], ax
; @0A14B 0000:A14B original=8b4404
    mov ax, word ptr ds:[si + 4]
; @0A14E 0000:A14E original=2d0400
    sub ax, 4
; @0A151 0000:A151 original=894704
    mov word ptr ds:[bx + 4], ax
; @0A154 0000:A154 original=c747060700
    mov word ptr ds:[bx + 6], 7
; @0A159 0000:A159 original=ff0674a9
    inc word ptr ds:[0A974h]
; @0A15D 0000:A15D original=e81500
    CALL_NEAR loc_0A175
; @0A160 0000:A160 original=2d0200
    sub ax, 2
; @0A163 0000:A163 original=894702
    mov word ptr ds:[bx + 2], ax
; @0A166 0000:A166 original=8b4404
    mov ax, word ptr ds:[si + 4]
; @0A169 0000:A169 original=050c00
    add ax, 0Ch
; @0A16C 0000:A16C original=894704
    mov word ptr ds:[bx + 4], ax
; @0A16F 0000:A16F original=c747060100
    mov word ptr ds:[bx + 6], 1
; @0A174 0000:A174 original=c3
    ret
; sub_0000_A175
; @0A175 0000:A175 original=e87203
    CALL_NEAR loc_0A4EA
; @0A178 0000:A178 original=c747180c00
    mov word ptr ds:[bx + 018h], 0Ch
; @0A17D 0000:A17D original=c7471c0700
    mov word ptr ds:[bx + 01Ch], 7
; @0A182 0000:A182 original=8b366ea9
    mov si, word ptr ds:[0A96Eh]
; @0A186 0000:A186 original=8b4402
    mov ax, word ptr ds:[si + 2]
; @0A189 0000:A189 original=c3
    ret
; @0A18A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,01Eh,00h,0C7h,047h,08h,033h,00h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h
; @0A19A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0FFh,0BEh,014h,0C3h
; @0A19F 0000:A19F original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A1A4 0000:A1A4 original=7405
    JE_SHORT loc_0A1AB
; @0A1A6 0000:A1A6 original=c606ffbe13
    mov byte ptr ds:[0BEFFh], 013h
; @0A1AB 0000:A1AB original=e83c03
    CALL_NEAR loc_0A4EA
; sub_0000_A1AE
; @0A1AE 0000:A1AE original=8b7608
    mov si, word ptr ss:[bp + 8]
; @0A1B1 0000:A1B1 original=d1e6
    shl si, 1
; @0A1B3 0000:A1B3 original=d1e6
    shl si, 1
; @0A1B5 0000:A1B5 original=81c6a8a3
    add si, 0A3A8h
; @0A1B9 0000:A1B9 original=ad
    lodsw
; @0A1BA 0000:A1BA original=034602
    add ax, word ptr ss:[bp + 2]
; @0A1BD 0000:A1BD original=894702
    mov word ptr ds:[bx + 2], ax
; @0A1C0 0000:A1C0 original=ad
    lodsw
; @0A1C1 0000:A1C1 original=034604
    add ax, word ptr ss:[bp + 4]
; @0A1C4 0000:A1C4 original=894704
    mov word ptr ds:[bx + 4], ax
; @0A1C7 0000:A1C7 original=c3
    ret
; @0A1C8 0000:A1C8 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A1CD 0000:A1CD original=7405
    JE_SHORT loc_0A1D4
; @0A1CF 0000:A1CF original=c606ffbe15
    mov byte ptr ds:[0BEFFh], 015h
; @0A1D4 0000:A1D4 original=e81303
    CALL_NEAR loc_0A4EA
; @0A1D7 0000:A1D7 original=c747081800
    mov word ptr ds:[bx + 8], 018h
; @0A1DC 0000:A1DC original=e8cfff
    CALL_NEAR loc_0A1AE
; @0A1DF 0000:A1DF original=e80803
    CALL_NEAR loc_0A4EA
; @0A1E2 0000:A1E2 original=e8c9ff
    CALL_NEAR loc_0A1AE
; @0A1E5 0000:A1E5 original=c747060700
    mov word ptr ds:[bx + 6], 7
; @0A1EA 0000:A1EA original=c747081f00
    mov word ptr ds:[bx + 8], 01Fh
; @0A1EF 0000:A1EF original=f606be9802
    test byte ptr ds:[098BEh], 2
; @0A1F4 0000:A1F4 original=751b
    JNE_SHORT loc_0A211
; @0A1F6 0000:A1F6 original=c747060100
    mov word ptr ds:[bx + 6], 1
; @0A1FB 0000:A1FB original=c747081900
    mov word ptr ds:[bx + 8], 019h
; @0A200 0000:A200 original=f606be9801
    test byte ptr ds:[098BEh], 1
; @0A205 0000:A205 original=750a
    JNE_SHORT loc_0A211
; @0A207 0000:A207 original=c747060000
    mov word ptr ds:[bx + 6], 0
; @0A20C 0000:A20C original=c747081800
    mov word ptr ds:[bx + 8], 018h
; @0A211 0000:A211 original=c3
    ret
; sub_0000_A212
; @0A212 0000:A212 original=833e72a900
    cmp word ptr ds:[0A972h], 0
; @0A217 0000:A217 original=7501
    JNE_SHORT loc_0A21A
; @0A219 0000:A219 original=c3
    ret
; @0A21A 0000:A21A original=833e242301
    cmp word ptr ds:[02324h], 1
; @0A21F 0000:A21F original=7537
    JNE_SHORT loc_0A258
; @0A221 0000:A221 original=813eeaa3e8a3
    cmp word ptr ds:[0A3EAh], 0A3E8h
; @0A227 0000:A227 original=7501
    JNE_SHORT loc_0A22A
; @0A229 0000:A229 original=c3
    ret
; @0A22A 0000:A22A original=8b1eb4a3
    mov bx, word ptr ds:[0A3B4h]
; @0A22E 0000:A22E original=83fbff
    cmp bx, -1
; @0A231 0000:A231 original=7501
    JNE_SHORT loc_0A234
; @0A233 0000:A233 original=c3
    ret
; @0A234 0000:A234 original=837f0400
    cmp word ptr ds:[bx + 4], 0
; @0A238 0000:A238 original=741b
    JE_SHORT loc_0A255
; @0A23A 0000:A23A original=e89900
    CALL_NEAR loc_0A2D6
; @0A23D 0000:A23D original=8b1eb4a3
    mov bx, word ptr ds:[0A3B4h]
; @0A241 0000:A241 original=836f0408
    sub word ptr ds:[bx + 4], 8
; @0A245 0000:A245 original=8b1eeaa3
    mov bx, word ptr ds:[0A3EAh]
; @0A249 0000:A249 original=83eb04
    sub bx, 4
; @0A24C 0000:A24C original=8b1f
    mov bx, word ptr ds:[bx]
; @0A24E 0000:A24E original=817f04c800
    cmp word ptr ds:[bx + 4], 0C8h
; @0A253 0000:A253 original=7403
    JE_SHORT loc_0A258
; @0A255 0000:A255 original=e87e00
    CALL_NEAR loc_0A2D6
; @0A258 0000:A258 original=beb4a3
    mov si, 0A3B4h
; @0A25B 0000:A25B original=ad
    lodsw
; @0A25C 0000:A25C original=3dffff
    cmp ax, 0FFFFh
; @0A25F 0000:A25F original=7501
    JNE_SHORT loc_0A262
; @0A261 0000:A261 original=c3
    ret
; @0A262 0000:A262 original=8bd8
    mov bx, ax
; @0A264 0000:A264 original=836f0204
    sub word ptr ds:[bx + 2], 4
; @0A268 0000:A268 original=8b4f04
    mov cx, word ptr ds:[bx + 4]
; @0A26B 0000:A26B original=83c108
    add cx, 8
; @0A26E 0000:A26E original=8b7f02
    mov di, word ptr ds:[bx + 2]
; @0A271 0000:A271 original=ad
    lodsw
; @0A272 0000:A272 original=3dffff
    cmp ax, 0FFFFh
; @0A275 0000:A275 original=7412
    JE_SHORT loc_0A289
; @0A277 0000:A277 original=8bd8
    mov bx, ax
; @0A279 0000:A279 original=894f04
    mov word ptr ds:[bx + 4], cx
; @0A27C 0000:A27C original=83c108
    add cx, 8
; @0A27F 0000:A27F original=897f02
    mov word ptr ds:[bx + 2], di
; @0A282 0000:A282 original=c747086b00
    mov word ptr ds:[bx + 8], 06Bh
; @0A287 0000:A287 original=ebe8
    JMP_SHORT loc_0A271
; @0A289 0000:A289 original=83ee04
    sub si, 4
; @0A28C 0000:A28C original=8b1c
    mov bx, word ptr ds:[si]
; @0A28E 0000:A28E original=c747086c00
    mov word ptr ds:[bx + 8], 06Ch
; @0A293 0000:A293 original=c3
    ret
; sub_0000_A294
; @0A294 0000:A294 original=8b3eeaa3
    mov di, word ptr ds:[0A3EAh]
; @0A298 0000:A298 original=891d
    mov word ptr ds:[di], bx
; @0A29A 0000:A29A original=8306eaa302
    add word ptr ds:[0A3EAh], 2
; @0A29F 0000:A29F original=c3
    ret
; sub_0000_A2A0
; @0A2A0 0000:A2A0 original=833ea2a300
    cmp word ptr ds:[0A3A2h], 0
; @0A2A5 0000:A2A5 original=7401
    JE_SHORT loc_0A2A8
; @0A2A7 0000:A2A7 original=c3
    ret
; @0A2A8 0000:A2A8 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A2AD 0000:A2AD original=7405
    JE_SHORT loc_0A2B4
; @0A2AF 0000:A2AF original=c606ffbe11
    mov byte ptr ds:[0BEFFh], 011h
; @0A2B4 0000:A2B4 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0A2B9 0000:A2B9 original=c706eaa3b4a3
    mov word ptr ds:[0A3EAh], 0A3B4h
; @0A2BF 0000:A2BF original=bfb4a3
    mov di, 0A3B4h
; @0A2C2 0000:A2C2 original=b8ffff
    mov ax, 0FFFFh
; @0A2C5 0000:A2C5 original=b91a00
    mov cx, 01Ah
; @0A2C8 0000:A2C8 original=f3ab
    rep stosw
; @0A2CA 0000:A2CA original=e80900
    CALL_NEAR loc_0A2D6
; @0A2CD 0000:A2CD original=c747086a00
    mov word ptr ds:[bx + 8], 06Ah
; @0A2D2 0000:A2D2 original=836f0408
    sub word ptr ds:[bx + 4], 8
; sub_0000_A2D6
; @0A2D6 0000:A2D6 original=ff0672a9
    inc word ptr ds:[0A972h]
; @0A2DA 0000:A2DA original=e80d02
    CALL_NEAR loc_0A4EA
; @0A2DD 0000:A2DD original=e8b4ff
    CALL_NEAR loc_0A294
; @0A2E0 0000:A2E0 original=c747180900
    mov word ptr ds:[bx + 018h], 9
; @0A2E5 0000:A2E5 original=e8c6fe
    CALL_NEAR loc_0A1AE
; @0A2E8 0000:A2E8 original=836704f8
    and word ptr ds:[bx + 4], 0FFF8h
; @0A2EC 0000:A2EC original=83470408
    add word ptr ds:[bx + 4], 8
; @0A2F0 0000:A2F0 original=c747086c00
    mov word ptr ds:[bx + 8], 06Ch
; @0A2F5 0000:A2F5 original=c3
    ret
; @0A2F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,0A0h,0A3h,00h,074h,01h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h
; @0A306 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0FFh,0BEh,017h,0FFh,06h,070h,0A9h,0E8h,0D9h,01h,0C7h,047h,018h,08h,00h
; @0A316 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,035h,00h,0E8h,090h,0FEh,0FFh,06h,070h,0A9h,0E8h,0C5h,01h,0C7h
; @0A326 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,018h,08h,00h,0C7h,047h,08h,035h,00h,0E8h,07Ch,0FEh,083h,047h,02h,08h
; @0A336 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,083h,03Eh,0A0h,0A3h,00h,074h,01h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h
; @0A346 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,06h,0FFh,0BEh,016h,0FFh,06h,070h,0A9h,0E8h,098h,01h,0C7h,047h,018h,07h
; @0A356 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,08h,037h,00h,0E8h,04Fh,0FEh,0FFh,06h,070h,0A9h,0E8h,084h,01h
; @0A366 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,018h,07h,00h,0C7h,047h,08h,037h,00h,0E8h,03Bh,0FEh,083h,047h,02h
; @0A376 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,0C3h
; sub_0000_A378
; @0A378 0000:A378 original=83feff
    cmp si, -1
; @0A37B 0000:A37B original=7501
    JNE_SHORT loc_0A37E
; @0A37D 0000:A37D original=c3
    ret
; @0A37E 0000:A37E original=833e5ea900
    cmp word ptr ds:[0A95Eh], 0
; @0A383 0000:A383 original=7501
    JNE_SHORT loc_0A386
; @0A385 0000:A385 original=c3
    ret
; @0A386 0000:A386 original=833ea4a300
    cmp word ptr ds:[0A3A4h], 0
; @0A38B 0000:A38B original=7401
    JE_SHORT loc_0A38E
; @0A38D 0000:A38D original=c3
    ret
; @0A38E 0000:A38E original=e80500
    CALL_NEAR loc_0A396
; @0A391 0000:A391 original=c747180600
    mov word ptr ds:[bx + 018h], 6
; sub_0000_A396
; @0A396 0000:A396 original=ff0676a9
    inc word ptr ds:[0A976h]
; @0A39A 0000:A39A original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A39F 0000:A39F original=7405
    JE_SHORT loc_0A3A6
; @0A3A1 0000:A3A1 original=c606ffbe12
    mov byte ptr ds:[0BEFFh], 012h
; @0A3A6 0000:A3A6 original=e84101
    CALL_NEAR loc_0A4EA
; @0A3A9 0000:A3A9 original=8b4404
    mov ax, word ptr ds:[si + 4]
; @0A3AC 0000:A3AC original=050400
    add ax, 4
; @0A3AF 0000:A3AF original=894704
    mov word ptr ds:[bx + 4], ax
; @0A3B2 0000:A3B2 original=8b4402
    mov ax, word ptr ds:[si + 2]
; @0A3B5 0000:A3B5 original=050400
    add ax, 4
; @0A3B8 0000:A3B8 original=894702
    mov word ptr ds:[bx + 2], ax
; @0A3BB 0000:A3BB original=836704fc
    and word ptr ds:[bx + 4], 0FFFCh
; @0A3BF 0000:A3BF original=c747080800
    mov word ptr ds:[bx + 8], 8
; @0A3C4 0000:A3C4 original=c747180500
    mov word ptr ds:[bx + 018h], 5
; @0A3C9 0000:A3C9 original=c3
    ret
; sub_0000_A3CA
; @0A3CA 0000:A3CA original=c706eca30700
    mov word ptr ds:[0A3ECh], 7
; @0A3D0 0000:A3D0 original=8b3666a9
    mov si, word ptr ds:[0A966h]
; @0A3D4 0000:A3D4 original=e84300
    CALL_NEAR loc_0A41A
; @0A3D7 0000:A3D7 original=c706eca30100
    mov word ptr ds:[0A3ECh], 1
; @0A3DD 0000:A3DD original=8b3668a9
    mov si, word ptr ds:[0A968h]
; @0A3E1 0000:A3E1 original=e83600
    CALL_NEAR loc_0A41A
; @0A3E4 0000:A3E4 original=c706eca30700
    mov word ptr ds:[0A3ECh], 7
; @0A3EA 0000:A3EA original=8b366aa9
    mov si, word ptr ds:[0A96Ah]
; @0A3EE 0000:A3EE original=e82900
    CALL_NEAR loc_0A41A
; @0A3F1 0000:A3F1 original=c706eca30100
    mov word ptr ds:[0A3ECh], 1
; @0A3F7 0000:A3F7 original=8b366ca9
    mov si, word ptr ds:[0A96Ch]
; @0A3FB 0000:A3FB original=e81c00
    CALL_NEAR loc_0A41A
; @0A3FE 0000:A3FE original=c3
    ret
; sub_0000_A3FF
; @0A3FF 0000:A3FF original=c706eca3ffff
    mov word ptr ds:[0A3ECh], 0FFFFh
; @0A405 0000:A405 original=8b3662a9
    mov si, word ptr ds:[0A962h]
; @0A409 0000:A409 original=e80e00
    CALL_NEAR loc_0A41A
; @0A40C 0000:A40C original=e869ff
    CALL_NEAR loc_0A378
; @0A40F 0000:A40F original=8b3664a9
    mov si, word ptr ds:[0A964h]
; @0A413 0000:A413 original=e80400
    CALL_NEAR loc_0A41A
; @0A416 0000:A416 original=e85fff
    CALL_NEAR loc_0A378
; @0A419 0000:A419 original=c3
    ret
; sub_0000_A41A
; @0A41A 0000:A41A original=83feff
    cmp si, -1
; @0A41D 0000:A41D original=7501
    JNE_SHORT loc_0A420
; @0A41F 0000:A41F original=c3
    ret
; @0A420 0000:A420 original=8b1e58a9
    mov bx, word ptr ds:[0A958h]
; @0A424 0000:A424 original=d1e3
    shl bx, 1
; @0A426 0000:A426 original=2effa72ca4
    jmp word ptr cs:[bx - 05BD4h]
; @0A42B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0D7h,0A4h,090h,0A4h,099h,0A4h,064h,0A4h,038h,0A4h,0AFh,044h,083h,03Eh,0A0h
; @0A43B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A3h,00h,074h,01h,0C3h,083h,06h,070h,0A9h,02h,0E8h,08Fh,00h,0C7h,047h,018h
; @0A44B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,0C7h,047h,08h,035h,00h,0E8h,082h,00h,0C7h,047h,018h,08h,00h,0C7h
; @0A45B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,035h,00h,083h,047h,02h,08h,0C3h,083h,03Eh,0A0h,0A3h,00h,074h,01h
; @0A46B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,083h,06h,070h,0A9h,02h,0E8h,063h,00h,0C7h,047h,018h,07h,00h,0C7h,047h
; @0A47B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,037h,00h,0E8h,056h,00h,0C7h,047h,018h,07h,00h,0C7h,047h,08h,037h,00h
; @0A48B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,047h,02h,08h,0C3h,0E8h,044h,00h,0C7h,047h,08h,033h,00h,0C3h,0E8h,04Eh
; @0A49B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,08Bh,044h,02h,089h,047h,02h,08Bh,044h,04h,05h,04h,00h,089h,047h,04h
; @0A4AB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,0ECh,0A3h,089h,047h,06h,03Dh,0FFh,0FFh,075h,010h,0C7h,047h,06h,07h,00h
; @0A4BB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Ch,04h,058h,076h,05h,0C7h,047h,06h,01h,00h,083h,07Fh,06h,01h,0C7h
; @0A4CB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,019h,00h,074h,05h,0C7h,047h,08h,01Fh,00h,0C3h,0E8h,010h,00h,08Bh
; @0A4DB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,02h,089h,047h,02h,08Bh,044h,04h,05h,04h,00h,089h,047h,04h,0C3h
; sub_0000_A4EA
; @0A4EA 0000:A4EA original=e85ad0
    CALL_NEAR loc_07547
; @0A4ED 0000:A4ED original=c7070100
    mov word ptr ds:[bx], 1
; @0A4F1 0000:A4F1 original=c7471e0100
    mov word ptr ds:[bx + 01Eh], 1
; @0A4F6 0000:A4F6 original=c747060000
    mov word ptr ds:[bx + 6], 0
; @0A4FB 0000:A4FB original=c747083200
    mov word ptr ds:[bx + 8], 032h
; @0A500 0000:A500 original=c747140000
    mov word ptr ds:[bx + 014h], 0
; @0A505 0000:A505 original=c747160200
    mov word ptr ds:[bx + 016h], 2
; @0A50A 0000:A50A original=c747180200
    mov word ptr ds:[bx + 018h], 2
; @0A50F 0000:A50F original=c7471cffff
    mov word ptr ds:[bx + 01Ch], 0FFFFh
; @0A514 0000:A514 original=c3
    ret
; sub_0000_A515
; @0A515 0000:A515 original=833e60a900
    cmp word ptr ds:[0A960h], 0
; @0A51A 0000:A51A original=7501
    JNE_SHORT loc_0A51D
; @0A51C 0000:A51C original=c3
    ret
; @0A51D 0000:A51D original=833e7ea901
    cmp word ptr ds:[0A97Eh], 1
; @0A522 0000:A522 original=7501
    JNE_SHORT loc_0A525
; @0A524 0000:A524 original=c3
    ret
; @0A525 0000:A525 original=e81fd0
    CALL_NEAR loc_07547
; @0A528 0000:A528 original=e84600
    CALL_NEAR CopyRecordPositionPlus10_0A571
; @0A52B 0000:A52B original=55
    push bp
; @0A52C 0000:A52C original=8beb
    mov bp, bx
; @0A52E 0000:A52E original=e8290c
    CALL_NEAR loc_0B15A
; @0A531 0000:A531 original=8bc3
    mov ax, bx
; @0A533 0000:A533 original=8bdd
    mov bx, bp
; @0A535 0000:A535 original=5d
    pop bp
; @0A536 0000:A536 original=3dffff
    cmp ax, 0FFFFh
; @0A539 0000:A539 original=7501
    JNE_SHORT loc_0A53C
; @0A53B 0000:A53B original=c3
    ret
; @0A53C 0000:A53C original=894730
    mov word ptr ds:[bx + 030h], ax
; @0A53F 0000:A53F original=c7070100
    mov word ptr ds:[bx], 1
; @0A543 0000:A543 original=c7471e0100
    mov word ptr ds:[bx + 01Eh], 1
; @0A548 0000:A548 original=c747140000
    mov word ptr ds:[bx + 014h], 0
; @0A54D 0000:A54D original=c747160200
    mov word ptr ds:[bx + 016h], 2
; @0A552 0000:A552 original=c747180a00
    mov word ptr ds:[bx + 018h], 0Ah
; @0A557 0000:A557 original=c7471c0100
    mov word ptr ds:[bx + 01Ch], 1
; @0A55C 0000:A55C original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A561 0000:A561 original=7405
    JE_SHORT loc_0A568
; @0A563 0000:A563 original=c606ffbe11
    mov byte ptr ds:[0BEFFh], 011h
; @0A568 0000:A568 original=ff067ea9
    inc word ptr ds:[0A97Eh]
; @0A56C 0000:A56C original=ff0e60a9
    dec word ptr ds:[0A960h]
; @0A570 0000:A570 original=c3
    ret
; CopyRecordPositionPlus10
; First DS:[BX+4] = SS:[BP+4]+10 modulo 65536; then DS:[BX+2] = SS:[BP+2]+10. AX holds the
; latter result. Order matters if memory aliases. Flags are from the second ADD.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A571 0000:A571 original=8b4604
    mov ax, word ptr ss:[bp + REC_X]
; @0A574 0000:A574 original=050a00
    add ax, 0Ah
; @0A577 0000:A577 original=894704
    mov word ptr ds:[bx + REC_X], ax
; @0A57A 0000:A57A original=8b4602
    mov ax, word ptr ss:[bp + REC_Y]
; @0A57D 0000:A57D original=050a00
    add ax, 0Ah
; @0A580 0000:A580 original=894702
    mov word ptr ds:[bx + REC_Y], ax
; @0A583 0000:A583 original=c3
    ret
; sub_0000_A584
; @0A584 0000:A584 original=833e5ea900
    cmp word ptr ds:[0A95Eh], 0
; @0A589 0000:A589 original=7501
    JNE_SHORT loc_0A58C
; @0A58B 0000:A58B original=c3
    ret
; @0A58C 0000:A58C original=833ea4a300
    cmp word ptr ds:[0A3A4h], 0
; @0A591 0000:A591 original=7401
    JE_SHORT loc_0A594
; @0A593 0000:A593 original=c3
    ret
; @0A594 0000:A594 original=ff0676a9
    inc word ptr ds:[0A976h]
; @0A598 0000:A598 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A59D 0000:A59D original=7405
    JE_SHORT loc_0A5A4
; @0A59F 0000:A59F original=c606ffbe12
    mov byte ptr ds:[0BEFFh], 012h
; @0A5A4 0000:A5A4 original=e843ff
    CALL_NEAR loc_0A4EA
; @0A5A7 0000:A5A7 original=e8c7ff
    CALL_NEAR CopyRecordPositionPlus10_0A571
; @0A5AA 0000:A5AA original=836704fc
    and word ptr ds:[bx + REC_X], 0FFFCh
; @0A5AE 0000:A5AE original=c747080800
    mov word ptr ds:[bx + 8], 8
; @0A5B3 0000:A5B3 original=c747180500
    mov word ptr ds:[bx + 018h], 5
; @0A5B8 0000:A5B8 original=ff0676a9
    inc word ptr ds:[0A976h]
; @0A5BC 0000:A5BC original=e82bff
    CALL_NEAR loc_0A4EA
; @0A5BF 0000:A5BF original=e8afff
    CALL_NEAR CopyRecordPositionPlus10_0A571
; @0A5C2 0000:A5C2 original=836704fc
    and word ptr ds:[bx + REC_X], 0FFFCh
; @0A5C6 0000:A5C6 original=c747080800
    mov word ptr ds:[bx + 8], 8
; @0A5CB 0000:A5CB original=c747180600
    mov word ptr ds:[bx + 018h], 6
; @0A5D0 0000:A5D0 original=c3
    ret
; sub_0000_A5D1
; DecRecordYByMode (modern reconstruction name)
; DS:A47C==0: apply DecRecordYUnlessAtMin twice via CALL into next instruction then fallthrough re-entry. Otherwise
; decrement SS:[BP+2] once modulo65536 without boundary guard. Near return; registers/segments preserved; flags
; changed, IF/DF preserved. Mode-zero y21h becomes20h, not1Fh. Nested call consumes two stack bytes temporarily.
; Evidence: metadata/symbols.json
; @0A5D1 0000:A5D1 original=833e7ca400
    cmp word ptr ds:[MOVE_MODE_A47C], 0
; @0A5D6 0000:A5D6 original=750e
    JNE_SHORT loc_0A5E6
; @0A5D8 0000:A5D8 original=e80000
    CALL_NEAR DecRecordYUnlessAtMin_0A5DB
; DecRecordYUnlessAtMin
; Decrement word SS:[BP+2] modulo 65536 unless it equals 0020h. This is NOT a saturating
; lower-bound clamp: values below 20h also decrement. CMP always overwrites CF; DEC
; preserves that CF.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A5DB 0000:A5DB original=837e0220
    cmp word ptr ss:[bp + REC_Y], RECORD_Y_MIN
; @0A5DF 0000:A5DF original=7501
    JNE_SHORT loc_0A5E2
; @0A5E1 0000:A5E1 original=c3
    ret
; @0A5E2 0000:A5E2 original=ff4e02
    dec word ptr ss:[bp + REC_Y]
; @0A5E5 0000:A5E5 original=c3
    ret
; @0A5E6 0000:A5E6 original=ff4e02
    dec word ptr ss:[bp + REC_Y]
; @0A5E9 0000:A5E9 original=c3
    ret
; sub_0000_A5EA
; IncRecordYTwice (modern reconstruction name)
; Call IncRecordYUnlessAtMax, then fall through into it again. Two equality-guarded increments of SS:[BP+2]; BFh
; becomesC0h, values aboveC0h still increment modulo65536. Registers/segments preserved; flags changed, IF/DF
; preserved; normal outer near return.
; Evidence: metadata/symbols.json
; @0A5EA 0000:A5EA original=e80000
    CALL_NEAR IncRecordYUnlessAtMax_0A5ED
; IncRecordYUnlessAtMax
; Increment word SS:[BP+2] modulo 65536 unless it equals 00C0h; values above C0h also
; increment.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A5ED 0000:A5ED original=817e02c000
    cmp word ptr ss:[bp + REC_Y], RECORD_Y_MAX
; @0A5F2 0000:A5F2 original=7501
    JNE_SHORT loc_0A5F5
; @0A5F4 0000:A5F4 original=c3
    ret
; @0A5F5 0000:A5F5 original=ff4602
    inc word ptr ss:[bp + REC_Y]
; @0A5F8 0000:A5F8 original=c3
    ret
; sub_0000_A5F9
; DecRecordXTwice (modern reconstruction name)
; Call DecRecordXUnlessZero then fall through into it again; SS:[BP+4]=max(original-2,0) for unsigned word.
; Registers/segments preserved; flags changed, IF/DF preserved. Outer near return; inner call/return must remain
; in ASM.
; Evidence: metadata/symbols.json
; @0A5F9 0000:A5F9 original=e80000
    CALL_NEAR DecRecordXUnlessZero_0A5FC
; DecRecordXUnlessZero
; Decrement unsigned word SS:[BP+4] unless zero; register state preserved, flags changed by
; CMP/DEC.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A5FC 0000:A5FC original=837e0400
    cmp word ptr ss:[bp + REC_X], 0
; @0A600 0000:A600 original=7501
    JNE_SHORT loc_0A603
; @0A602 0000:A602 original=c3
    ret
; @0A603 0000:A603 original=ff4e04
    dec word ptr ss:[bp + REC_X]
; @0A606 0000:A606 original=c3
    ret
; sub_0000_A607
; IncRecordXTwice (modern reconstruction name)
; Call IncRecordXBelowMax then fall through into it again. Unsigned SS:[BP+4] increases up toB0h if initially below
; it; values>=B0h unchanged. General/segment registers preserved; flags changed, IF/DF preserved; outer near
; return.
; Evidence: metadata/symbols.json
; @0A607 0000:A607 original=e80000
    CALL_NEAR IncRecordXBelowMax_0A60A
; IncRecordXBelowMax
; Increment unsigned word SS:[BP+4] iff below 00B0h; values at or above B0h remain
; unchanged.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A60A 0000:A60A original=817e04b000
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
; @0A60F 0000:A60F original=7201
    JB_SHORT loc_0A612
; @0A611 0000:A611 original=c3
    ret
; @0A612 0000:A612 original=ff4604
    inc word ptr ss:[bp + REC_X]
; @0A615 0000:A615 original=c3
    ret
; sub_0000_A616
; UpdatePlacementXOffsetsAtRecordEdges (modern reconstruction name)
; Near entry. If unsigned DS:2350<=B6 return. Otherwise call UpdatePlacementXGroupA, then re-read SS:[BP+REC_X].
; If X==B0 and IN_XPLUS set, increment DS:OFFSET_X_GROUP_B unless exactly8; otherwise decrement it unless
; exactly0. Group A is updated first, preserving sequential alias effects of the original loads. Word operations
; wrap at16 bits; guards are equality-only, not saturation. Preserve all general/segment registers and IF/DF;
; arithmetic flags depend on final path. Normal near return; only group-A/B words may be written, apart from
; call stack. Requires valid callee state; normal caller record/state do not overlap.
; Evidence: metadata/symbols.json
; @0A616 0000:A616 original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @0A61C 0000:A61C original=7701
    JA_SHORT loc_0A61F
; @0A61E 0000:A61E original=c3
    ret
; @0A61F 0000:A61F original=e82600
    CALL_NEAR UpdatePlacementXGroupA_0A648
; @0A622 0000:A622 original=817e04b000
    cmp word ptr ss:[bp + REC_X], RECORD_X_MAX
; @0A627 0000:A627 original=7513
    JNE_SHORT loc_0A63C
; @0A629 0000:A629 original=f606be9801
    test byte ptr ds:[INPUT_BITS], IN_XPLUS
; @0A62E 0000:A62E original=740c
    JE_SHORT loc_0A63C
; @0A630 0000:A630 original=833e9ca308
    cmp word ptr ds:[OFFSET_X_GROUP_B], 8
; @0A635 0000:A635 original=7404
    JE_SHORT loc_0A63B
; @0A637 0000:A637 original=ff069ca3
    inc word ptr ds:[OFFSET_X_GROUP_B]
; @0A63B 0000:A63B original=c3
    ret
; @0A63C 0000:A63C original=833e9ca300
    cmp word ptr ds:[OFFSET_X_GROUP_B], 0
; @0A641 0000:A641 original=7404
    JE_SHORT loc_0A647
; @0A643 0000:A643 original=ff0e9ca3
    dec word ptr ds:[OFFSET_X_GROUP_B]
; @0A647 0000:A647 original=c3
    ret
; sub_0000_A648
; UpdatePlacementXGroupA (modern reconstruction name)
; Near leaf. Read SS:[BP+REC_X] and DS:INPUT_BITS. If X==0 and IN_XMINUS set, decrement DS:OFFSET_X_GROUP_A
; unless exactlyFFF8h; otherwise increment it unless exactly0. All arithmetic wraps at16 bits. Equality
; sentinels do not validate or clamp arbitrary accumulator values. Preserve all general and segment registers,
; IF/DF; arithmetic flags path-dependent. Normal near return; only group-A word may be written. Requires valid
; record/state storage; no hardware effects.
; Evidence: metadata/symbols.json
; @0A648 0000:A648 original=837e0400
    cmp word ptr ss:[bp + REC_X], 0
; @0A64C 0000:A64C original=7514
    JNE_SHORT loc_0A662
; @0A64E 0000:A64E original=f606be9802
    test byte ptr ds:[INPUT_BITS], IN_XMINUS
; @0A653 0000:A653 original=740d
    JE_SHORT loc_0A662
; @0A655 0000:A655 original=833e9aa3f8
    cmp word ptr ds:[OFFSET_X_GROUP_A], -8
; @0A65A 0000:A65A original=7501
    JNE_SHORT loc_0A65D
; @0A65C 0000:A65C original=c3
    ret
; @0A65D 0000:A65D original=ff0e9aa3
    dec word ptr ds:[OFFSET_X_GROUP_A]
; @0A661 0000:A661 original=c3
    ret
; @0A662 0000:A662 original=833e9aa300
    cmp word ptr ds:[OFFSET_X_GROUP_A], 0
; @0A667 0000:A667 original=7501
    JNE_SHORT loc_0A66A
; @0A669 0000:A669 original=c3
    ret
; @0A66A 0000:A66A original=ff069aa3
    inc word ptr ds:[OFFSET_X_GROUP_A]
; @0A66E 0000:A66E original=c3
    ret
; sub_0000_A66F
; @0A66F 0000:A66F original=833e7ca400
    cmp word ptr ds:[0A47Ch], 0
; @0A674 0000:A674 original=7403
    JE_SHORT loc_0A679
; @0A676 0000:A676 original=e98400
    JMP_NEAR loc_0A6FD
; @0A679 0000:A679 original=833e7ea400
    cmp word ptr ds:[0A47Eh], 0
; @0A67E 0000:A67E original=757d
    JNE_SHORT loc_0A6FD
; @0A680 0000:A680 original=833e80a400
    cmp word ptr ds:[0A480h], 0
; @0A685 0000:A685 original=7576
    JNE_SHORT loc_0A6FD
; @0A687 0000:A687 original=e87400
    CALL_NEAR loc_0A6FE
; @0A68A 0000:A68A original=833e4e2300
    cmp word ptr ds:[0234Eh], 0
; @0A68F 0000:A68F original=756c
    JNE_SHORT loc_0A6FD
; @0A691 0000:A691 original=50
    push ax
; @0A692 0000:A692 original=53
    push bx
; @0A693 0000:A693 original=51
    push cx
; @0A694 0000:A694 original=52
    push dx
; @0A695 0000:A695 original=57
    push di
; @0A696 0000:A696 original=56
    push si
; @0A697 0000:A697 original=55
    push bp
; @0A698 0000:A698 original=06
    push es
; @0A699 0000:A699 original=1e
    push ds
; @0A69A 0000:A69A original=be82a9
    mov si, 0A982h
; @0A69D 0000:A69D original=813e5023520e
    cmp word ptr ds:[02350h], 0E52h
; @0A6A3 0000:A6A3 original=7503
    JNE_SHORT loc_0A6A8
; @0A6A5 0000:A6A5 original=e8e91e
    CALL_NEAR loc_0C591
; @0A6A8 0000:A6A8 original=1f
    pop ds
; @0A6A9 0000:A6A9 original=07
    pop es
; @0A6AA 0000:A6AA original=5d
    pop bp
; @0A6AB 0000:A6AB original=5e
    pop si
; @0A6AC 0000:A6AC original=5f
    pop di
; @0A6AD 0000:A6AD original=5a
    pop dx
; @0A6AE 0000:A6AE original=59
    pop cx
; @0A6AF 0000:A6AF original=5b
    pop bx
; @0A6B0 0000:A6B0 original=58
    pop ax
; @0A6B1 0000:A6B1 original=813e5023a00e
    cmp word ptr ds:[02350h], 0EA0h
; @0A6B7 0000:A6B7 original=7544
    JNE_SHORT loc_0A6FD
; @0A6B9 0000:A6B9 original=c7067ca40100
    mov word ptr ds:[0A47Ch], 1
; @0A6BF 0000:A6BF original=e8e8bb
    CALL_NEAR loc_062AA
; @0A6C2 0000:A6C2 original=beeea3
    mov si, 0A3EEh
; @0A6C5 0000:A6C5 original=b90400
    mov cx, 4
; @0A6C8 0000:A6C8 original=51
    push cx
; @0A6C9 0000:A6C9 original=56
    push si
; @0A6CA 0000:A6CA original=e857ce
    CALL_NEAR FindFreeRecordPoolA_07524
; @0A6CD 0000:A6CD original=5e
    pop si
; @0A6CE 0000:A6CE original=83fbff
    cmp bx, -1
; @0A6D1 0000:A6D1 original=7427
    JE_SHORT loc_0A6FA
; @0A6D3 0000:A6D3 original=c7070100
    mov word ptr ds:[bx], 1
; @0A6D7 0000:A6D7 original=c747140200
    mov word ptr ds:[bx + 014h], 2
; @0A6DC 0000:A6DC original=c747160400
    mov word ptr ds:[bx + 016h], 4
; @0A6E1 0000:A6E1 original=c747185300
    mov word ptr ds:[bx + 018h], 053h
; @0A6E6 0000:A6E6 original=c74728ffff
    mov word ptr ds:[bx + 028h], 0FFFFh
; @0A6EB 0000:A6EB original=ad
    lodsw
; @0A6EC 0000:A6EC original=894702
    mov word ptr ds:[bx + 2], ax
; @0A6EF 0000:A6EF original=ad
    lodsw
; @0A6F0 0000:A6F0 original=894704
    mov word ptr ds:[bx + 4], ax
; @0A6F3 0000:A6F3 original=ad
    lodsw
; @0A6F4 0000:A6F4 original=894708
    mov word ptr ds:[bx + 8], ax
; @0A6F7 0000:A6F7 original=894736
    mov word ptr ds:[bx + 036h], ax
; @0A6FA 0000:A6FA original=59
    pop cx
; @0A6FB 0000:A6FB original=e2cb
    LOOP_SHORT loc_0A6C8
; @0A6FD 0000:A6FD original=c3
    ret
; sub_0000_A6FE
; @0A6FE 0000:A6FE original=55
    push bp
; @0A6FF 0000:A6FF original=830678a201
    add word ptr ds:[0A278h], 1
; @0A704 0000:A704 original=c70652230000
    mov word ptr ds:[02352h], 0
; @0A70A 0000:A70A original=833e4e2300
    cmp word ptr ds:[0234Eh], 0
; @0A70F 0000:A70F original=7503
    JNE_SHORT loc_0A714
; @0A711 0000:A711 original=e83a00
    CALL_NEAR loc_0A74E
; @0A714 0000:A714 original=ff0e4e23
    dec word ptr ds:[0234Eh]
; @0A718 0000:A718 original=83264e230f
    and word ptr ds:[0234Eh], 0Fh
; @0A71D 0000:A71D original=7510
    JNE_SHORT loc_0A72F
; @0A71F 0000:A71F original=833e542300
    cmp word ptr ds:[02354h], 0
; @0A724 0000:A724 original=7409
    JE_SHORT loc_0A72F
; @0A726 0000:A726 original=830650230d
    add word ptr ds:[02350h], 0Dh
; @0A72B 0000:A72B original=ff0e78a9
    dec word ptr ds:[0A978h]
; @0A72F 0000:A72F original=2ea1be95
    mov ax, word ptr cs:[095BEh]
; @0A733 0000:A733 original=39064c23
    cmp word ptr ds:[0234Ch], ax
; @0A737 0000:A737 original=7503
    JNE_SHORT loc_0A73C
; @0A739 0000:A739 original=e80a00
    CALL_NEAR loc_0A746
; @0A73C 0000:A73C original=2ea19e95
    mov ax, word ptr cs:[0959Eh]
; @0A740 0000:A740 original=29064c23
    sub word ptr ds:[0234Ch], ax
; @0A744 0000:A744 original=5d
    pop bp
; @0A745 0000:A745 original=c3
    ret
; sub_0000_A746
; @0A746 0000:A746 original=2ea1c095
    mov ax, word ptr cs:[095C0h]
; @0A74A 0000:A74A original=a34c23
    mov word ptr ds:[0234Ch], ax
; @0A74D 0000:A74D original=c3
    ret
; sub_0000_A74E
; @0A74E 0000:A74E original=e89a00
    CALL_NEAR loc_0A7EB
; @0A751 0000:A751 original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @0A757 0000:A757 original=770c
    JA_SHORT loc_0A765
; @0A759 0000:A759 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0A75E 0000:A75E original=7405
    JE_SHORT loc_0A765
; @0A760 0000:A760 original=c606ffbe07
    mov byte ptr ds:[0BEFFh], 7
; @0A765 0000:A765 original=830650230d
    add word ptr ds:[02350h], 0Dh
; @0A76A 0000:A76A original=ff0e78a9
    dec word ptr ds:[0A978h]
; @0A76E 0000:A76E original=b005
    mov al, 5
; @0A770 0000:A770 original=833e78a904
    cmp word ptr ds:[0A978h], 4
; @0A775 0000:A775 original=7503
    JNE_SHORT loc_0A77A
; @0A777 0000:A777 original=e8a223
    CALL_NEAR loc_0CB1C
; @0A77A 0000:A77A original=c70654230000
    mov word ptr ds:[02354h], 0
; @0A780 0000:A780 original=c3
    ret
; sub_0000_A781
; @0A781 0000:A781 original=55
    push bp
; @0A782 0000:A782 original=c70652230100
    mov word ptr ds:[02352h], 1
; @0A788 0000:A788 original=833e502300
    cmp word ptr ds:[02350h], 0
; @0A78D 0000:A78D original=74b5
    JE_SHORT loc_0A744
; @0A78F 0000:A78F original=830678a2ff
    add word ptr ds:[0A278h], -1
; @0A794 0000:A794 original=833e4e2300
    cmp word ptr ds:[0234Eh], 0
; @0A799 0000:A799 original=7503
    JNE_SHORT loc_0A79E
; @0A79B 0000:A79B original=e83200
    CALL_NEAR loc_0A7D0
; @0A79E 0000:A79E original=ff064e23
    inc word ptr ds:[0234Eh]
; @0A7A2 0000:A7A2 original=83264e230f
    and word ptr ds:[0234Eh], 0Fh
; @0A7A7 0000:A7A7 original=7510
    JNE_SHORT loc_0A7B9
; @0A7A9 0000:A7A9 original=833e542301
    cmp word ptr ds:[02354h], 1
; @0A7AE 0000:A7AE original=7409
    JE_SHORT loc_0A7B9
; @0A7B0 0000:A7B0 original=832e50230d
    sub word ptr ds:[02350h], 0Dh
; @0A7B5 0000:A7B5 original=ff0678a9
    inc word ptr ds:[0A978h]
; @0A7B9 0000:A7B9 original=2ea1c095
    mov ax, word ptr cs:[095C0h]
; @0A7BD 0000:A7BD original=39064c23
    cmp word ptr ds:[0234Ch], ax
; @0A7C1 0000:A7C1 original=7503
    JNE_SHORT loc_0A7C6
; @0A7C3 0000:A7C3 original=e81d00
    CALL_NEAR loc_0A7E3
; @0A7C6 0000:A7C6 original=2ea19e95
    mov ax, word ptr cs:[0959Eh]
; @0A7CA 0000:A7CA original=01064c23
    add word ptr ds:[0234Ch], ax
; @0A7CE 0000:A7CE original=5d
    pop bp
; @0A7CF 0000:A7CF original=c3
    ret
; sub_0000_A7D0
; @0A7D0 0000:A7D0 original=e81800
    CALL_NEAR loc_0A7EB
; @0A7D3 0000:A7D3 original=832e50230d
    sub word ptr ds:[02350h], 0Dh
; @0A7D8 0000:A7D8 original=ff0678a9
    inc word ptr ds:[0A978h]
; @0A7DC 0000:A7DC original=c70654230100
    mov word ptr ds:[02354h], 1
; @0A7E2 0000:A7E2 original=c3
    ret
; sub_0000_A7E3
; @0A7E3 0000:A7E3 original=2ea1be95
    mov ax, word ptr cs:[095BEh]
; @0A7E7 0000:A7E7 original=a34c23
    mov word ptr ds:[0234Ch], ax
; @0A7EA 0000:A7EA original=c3
    ret
; sub_0000_A7EB
; @0A7EB 0000:A7EB original=8b3e4c23
    mov di, word ptr ds:[0234Ch]
; @0A7EF 0000:A7EF original=2e2b3ebe95
    sub di, word ptr cs:[095BEh]
; @0A7F4 0000:A7F4 original=e82400
    CALL_NEAR loc_0A81B
; @0A7F7 0000:A7F7 original=8b364c23
    mov si, word ptr ds:[0234Ch]
; @0A7FB 0000:A7FB original=2e2b36be95
    sub si, word ptr cs:[095BEh]
; @0A800 0000:A800 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @0A805 0000:A805 original=8bfe
    mov di, si
; @0A807 0000:A807 original=2e033ec295
    add di, word ptr cs:[095C2h]
; @0A80C 0000:A80C original=2e8b0ebe95
    mov cx, word ptr cs:[095BEh]
; @0A811 0000:A811 original=d1e9
    shr cx, 1
; @0A813 0000:A813 original=f3a5
    rep movsw
; @0A815 0000:A815 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0A81A 0000:A81A original=c3
    ret
; sub_0000_A81B
; @0A81B 0000:A81B original=8b1e5023
    mov bx, word ptr ds:[02350h]
; @0A81F 0000:A81F original=833e522301
    cmp word ptr ds:[02352h], 1
; @0A824 0000:A824 original=7507
    JNE_SHORT loc_0A82D
; @0A826 0000:A826 original=81eba900
    sub bx, 0A9h
; @0A82A 0000:A82A original=e951b2
    JMP_NEAR loc_05A7E
; @0A82D 0000:A82D original=891e08a4
    mov word ptr ds:[0A408h], bx
; @0A831 0000:A831 original=813e5023520e
    cmp word ptr ds:[02350h], 0E52h
; @0A837 0000:A837 original=7706
    JA_SHORT loc_0A83F
; @0A839 0000:A839 original=e80cd1
    CALL_NEAR loc_07948
; @0A83C 0000:A83C original=e826a2
    CALL_NEAR loc_04A65
; @0A83F 0000:A83F original=8b1e5023
    mov bx, word ptr ds:[02350h]
; @0A843 0000:A843 original=e938b2
    JMP_NEAR loc_05A7E
; sub_0000_A846
; @0A846 0000:A846 original=b92400
    mov cx, 024h
; @0A849 0000:A849 original=51
    push cx
; @0A84A 0000:A84A original=8bd9
    mov bx, cx
; @0A84C 0000:A84C original=d1e3
    shl bx, 1
; @0A84E 0000:A84E original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @0A852 0000:A852 original=837e0000
    cmp word ptr ss:[bp], 0
; @0A856 0000:A856 original=7403
    JE_SHORT loc_0A85B
; @0A858 0000:A858 original=e86db2
    CALL_NEAR loc_05AC8
; @0A85B 0000:A85B original=59
    pop cx
; @0A85C 0000:A85C original=e2eb
    LOOP_SHORT loc_0A849
; @0A85E 0000:A85E original=b92200
    mov cx, 022h
; @0A861 0000:A861 original=51
    push cx
; @0A862 0000:A862 original=8bd9
    mov bx, cx
; @0A864 0000:A864 original=d1e3
    shl bx, 1
; @0A866 0000:A866 original=8baf128d
    mov bp, word ptr ds:[bx - 072EEh]
; @0A86A 0000:A86A original=837e0000
    cmp word ptr ss:[bp], 0
; @0A86E 0000:A86E original=7403
    JE_SHORT loc_0A873
; @0A870 0000:A870 original=e855b2
    CALL_NEAR loc_05AC8
; @0A873 0000:A873 original=59
    pop cx
; @0A874 0000:A874 original=e2eb
    LOOP_SHORT loc_0A861
; @0A876 0000:A876 original=e874a4
    CALL_NEAR loc_04CED
; @0A879 0000:A879 original=b92200
    mov cx, 022h
; @0A87C 0000:A87C original=51
    push cx
; @0A87D 0000:A87D original=8bd9
    mov bx, cx
; @0A87F 0000:A87F original=d1e3
    shl bx, 1
; @0A881 0000:A881 original=8baf128d
    mov bp, word ptr ds:[bx - 072EEh]
; @0A885 0000:A885 original=837e0000
    cmp word ptr ss:[bp], 0
; @0A889 0000:A889 original=7403
    JE_SHORT loc_0A88E
; @0A88B 0000:A88B original=e8b8ce
    CALL_NEAR loc_07746
; @0A88E 0000:A88E original=59
    pop cx
; @0A88F 0000:A88F original=e2eb
    LOOP_SHORT loc_0A87C
; @0A891 0000:A891 original=b92300
    mov cx, 023h
; @0A894 0000:A894 original=51
    push cx
; @0A895 0000:A895 original=8bd9
    mov bx, cx
; @0A897 0000:A897 original=d1e3
    shl bx, 1
; @0A899 0000:A899 original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @0A89D 0000:A89D original=837e0000
    cmp word ptr ss:[bp], 0
; @0A8A1 0000:A8A1 original=741e
    JE_SHORT loc_0A8C1
; @0A8A3 0000:A8A3 original=833eacbd01
    cmp word ptr ds:[0BDACh], 1
; @0A8A8 0000:A8A8 original=740e
    JE_SHORT loc_0A8B8
; @0A8AA 0000:A8AA original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @0A8B0 0000:A8B0 original=7706
    JA_SHORT loc_0A8B8
; @0A8B2 0000:A8B2 original=837e1601
    cmp word ptr ss:[bp + 016h], 1
; @0A8B6 0000:A8B6 original=7409
    JE_SHORT loc_0A8C1
; @0A8B8 0000:A8B8 original=837e0a00
    cmp word ptr ss:[bp + 0Ah], 0
; @0A8BC 0000:A8BC original=7503
    JNE_SHORT loc_0A8C1
; @0A8BE 0000:A8BE original=e8d5cc
    CALL_NEAR loc_07596
; @0A8C1 0000:A8C1 original=59
    pop cx
; @0A8C2 0000:A8C2 original=e2d0
    LOOP_SHORT loc_0A894
; @0A8C4 0000:A8C4 original=b92400
    mov cx, 024h
; @0A8C7 0000:A8C7 original=51
    push cx
; @0A8C8 0000:A8C8 original=8bd9
    mov bx, cx
; @0A8CA 0000:A8CA original=d1e3
    shl bx, 1
; @0A8CC 0000:A8CC original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @0A8D0 0000:A8D0 original=837e0000
    cmp word ptr ss:[bp], 0
; @0A8D4 0000:A8D4 original=741e
    JE_SHORT loc_0A8F4
; @0A8D6 0000:A8D6 original=833eacbd01
    cmp word ptr ds:[0BDACh], 1
; @0A8DB 0000:A8DB original=740e
    JE_SHORT loc_0A8EB
; @0A8DD 0000:A8DD original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @0A8E3 0000:A8E3 original=7706
    JA_SHORT loc_0A8EB
; @0A8E5 0000:A8E5 original=837e1601
    cmp word ptr ss:[bp + 016h], 1
; @0A8E9 0000:A8E9 original=7409
    JE_SHORT loc_0A8F4
; @0A8EB 0000:A8EB original=837e0a01
    cmp word ptr ss:[bp + 0Ah], 1
; @0A8EF 0000:A8EF original=7503
    JNE_SHORT loc_0A8F4
; @0A8F1 0000:A8F1 original=e8a2cc
    CALL_NEAR loc_07596
; @0A8F4 0000:A8F4 original=59
    pop cx
; @0A8F5 0000:A8F5 original=e2d0
    LOOP_SHORT loc_0A8C7
; @0A8F7 0000:A8F7 original=833e7ca400
    cmp word ptr ds:[0A47Ch], 0
; @0A8FC 0000:A8FC original=7501
    JNE_SHORT loc_0A8FF
; @0A8FE 0000:A8FE original=c3
    ret
; @0A8FF 0000:A8FF original=8b2e8897
    mov bp, word ptr ds:[09788h]
; @0A903 0000:A903 original=83fdff
    cmp bp, -1
; @0A906 0000:A906 original=7403
    JE_SHORT loc_0A90B
; @0A908 0000:A908 original=e88bcc
    CALL_NEAR loc_07596
; @0A90B 0000:A90B original=c3
    ret
; sub_0000_A90C
; @0A90C 0000:A90C original=b92200
    mov cx, 022h
; @0A90F 0000:A90F original=51
    push cx
; @0A910 0000:A910 original=8bd9
    mov bx, cx
; @0A912 0000:A912 original=d1e3
    shl bx, 1
; @0A914 0000:A914 original=8baf128d
    mov bp, word ptr ds:[bx - 072EEh]
; @0A918 0000:A918 original=837e0000
    cmp word ptr ss:[bp], 0
; @0A91C 0000:A91C original=7403
    JE_SHORT loc_0A921
; @0A91E 0000:A91E original=e871b1
    CALL_NEAR loc_05A92
; @0A921 0000:A921 original=59
    pop cx
; @0A922 0000:A922 original=e2eb
    LOOP_SHORT loc_0A90F
; @0A924 0000:A924 original=b92400
    mov cx, 024h
; @0A927 0000:A927 original=51
    push cx
; @0A928 0000:A928 original=8bd9
    mov bx, cx
; @0A92A 0000:A92A original=d1e3
    shl bx, 1
; @0A92C 0000:A92C original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @0A930 0000:A930 original=837e0000
    cmp word ptr ss:[bp], 0
; @0A934 0000:A934 original=7403
    JE_SHORT loc_0A939
; @0A936 0000:A936 original=e859b1
    CALL_NEAR loc_05A92
; @0A939 0000:A939 original=59
    pop cx
; @0A93A 0000:A93A original=e2eb
    LOOP_SHORT loc_0A927
; @0A93C 0000:A93C original=e825a4
    CALL_NEAR loc_04D64
; @0A93F 0000:A93F original=c3
    ret
; sub_0000_A940
; @0A940 0000:A940 original=833ecea8ff
    cmp word ptr ds:[0A8CEh], -1
; @0A945 0000:A945 original=7404
    JE_SHORT loc_0A94B
; @0A947 0000:A947 original=ff06cea8
    inc word ptr ds:[0A8CEh]
; @0A94B 0000:A94B original=a1c8a8
    mov ax, word ptr ds:[0A8C8h]
; @0A94E 0000:A94E original=a3c6a8
    mov word ptr ds:[0A8C6h], ax
; @0A951 0000:A951 original=a1cca8
    mov ax, word ptr ds:[0A8CCh]
; @0A954 0000:A954 original=a3caa8
    mov word ptr ds:[0A8CAh], ax
; @0A957 0000:A957 original=c706cca80000
    mov word ptr ds:[0A8CCh], 0
; @0A95D 0000:A95D original=833e562305
    cmp word ptr ds:[02356h], 5
; @0A962 0000:A962 original=7559
    JNE_SHORT loc_0A9BD
; @0A964 0000:A964 original=803ea29800
    cmp byte ptr ds:[098A2h], 0
; @0A969 0000:A969 original=7410
    JE_SHORT loc_0A97B
; @0A96B 0000:A96B original=f71eaa98
    neg word ptr ds:[098AAh]
; @0A96F 0000:A96F original=c606a29800
    mov byte ptr ds:[098A2h], 0
; @0A974 0000:A974 original=c606a49801
    mov byte ptr ds:[098A4h], 1
; @0A979 0000:A979 original=eb05
    JMP_SHORT loc_0A980
; @0A97B 0000:A97B original=c606a49800
    mov byte ptr ds:[098A4h], 0
; @0A980 0000:A980 original=32c9
    xor cl, cl
; @0A982 0000:A982 original=803ea59800
    cmp byte ptr ds:[098A5h], 0
; @0A987 0000:A987 original=7420
    JE_SHORT loc_0A9A9
; @0A989 0000:A989 original=fe0ea598
    dec byte ptr ds:[098A5h]
; @0A98D 0000:A98D original=7524
    JNE_SHORT loc_0A9B3
; @0A98F 0000:A98F original=a17ea4
    mov ax, word ptr ds:[0A47Eh]
; @0A992 0000:A992 original=b10a
    mov cl, 0Ah
; @0A994 0000:A994 original=3d1000
    cmp ax, 010h
; @0A997 0000:A997 original=7710
    JA_SHORT loc_0A9A9
; @0A999 0000:A999 original=b106
    mov cl, 6
; @0A99B 0000:A99B original=3d0800
    cmp ax, 8
; @0A99E 0000:A99E original=7709
    JA_SHORT loc_0A9A9
; @0A9A0 0000:A9A0 original=b104
    mov cl, 4
; @0A9A2 0000:A9A2 original=3d0400
    cmp ax, 4
; @0A9A5 0000:A9A5 original=7702
    JA_SHORT loc_0A9A9
; @0A9A7 0000:A9A7 original=b101
    mov cl, 1
; @0A9A9 0000:A9A9 original=880ea598
    mov byte ptr ds:[098A5h], cl
; @0A9AD 0000:A9AD original=fe06a398
    inc byte ptr ds:[098A3h]
; @0A9B1 0000:A9B1 original=eb05
    JMP_SHORT loc_0A9B8
; @0A9B3 0000:A9B3 original=c606a39800
    mov byte ptr ds:[098A3h], 0
; @0A9B8 0000:A9B8 original=9a1d087f0f
    CALL_FAR 0F7Fh,081Dh
; @0A9BD 0000:A9BD original=c606a99800
    mov byte ptr ds:[098A9h], 0
; @0A9C2 0000:A9C2 original=803ea89800
    cmp byte ptr ds:[098A8h], 0
; @0A9C7 0000:A9C7 original=740a
    JE_SHORT loc_0A9D3
; @0A9C9 0000:A9C9 original=c606a89800
    mov byte ptr ds:[098A8h], 0
; @0A9CE 0000:A9CE original=c606a99801
    mov byte ptr ds:[098A9h], 1
; @0A9D3 0000:A9D3 original=833ec2a801
    cmp word ptr ds:[0A8C2h], 1
; @0A9D8 0000:A9D8 original=7503
    JNE_SHORT loc_0A9DD
; @0A9DA 0000:A9DA original=e8ba4d
    CALL_NEAR loc_0F797
; @0A9DD 0000:A9DD original=b92300
    mov cx, 023h
; @0A9E0 0000:A9E0 original=51
    push cx
; @0A9E1 0000:A9E1 original=8bd9
    mov bx, cx
; @0A9E3 0000:A9E3 original=d1e3
    shl bx, 1
; @0A9E5 0000:A9E5 original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @0A9E9 0000:A9E9 original=ff064023
    inc word ptr ds:[02340h]
; @0A9ED 0000:A9ED original=813e4023dc05
    cmp word ptr ds:[02340h], 05DCh
; @0A9F3 0000:A9F3 original=7206
    JB_SHORT loc_0A9FB
; @0A9F5 0000:A9F5 original=c70640230000
    mov word ptr ds:[02340h], 0
; @0A9FB 0000:A9FB original=837e0000
    cmp word ptr ss:[bp], 0
; @0A9FF 0000:A9FF original=7403
    JE_SHORT loc_0AA04
; @0AA01 0000:AA01 original=e82700
    CALL_NEAR loc_0AA2B
; @0AA04 0000:AA04 original=59
    pop cx
; @0AA05 0000:AA05 original=e2d9
    LOOP_SHORT loc_0A9E0
; @0AA07 0000:AA07 original=c70646230000
    mov word ptr ds:[02346h], 0
; @0AA0D 0000:AA0D original=b92200
    mov cx, 022h
; @0AA10 0000:AA10 original=51
    push cx
; @0AA11 0000:AA11 original=8bd9
    mov bx, cx
; @0AA13 0000:AA13 original=d1e3
    shl bx, 1
; @0AA15 0000:AA15 original=8baf128d
    mov bp, word ptr ds:[bx - 072EEh]
; @0AA19 0000:AA19 original=837e0000
    cmp word ptr ss:[bp], 0
; @0AA1D 0000:AA1D original=7403
    JE_SHORT loc_0AA22
; @0AA1F 0000:AA1F original=e80900
    CALL_NEAR loc_0AA2B
; @0AA22 0000:AA22 original=59
    pop cx
; @0AA23 0000:AA23 original=e2eb
    LOOP_SHORT loc_0AA10
; @0AA25 0000:AA25 original=9a22097f0f
    CALL_FAR 0F7Fh,0922h
; @0AA2A 0000:AA2A original=c3
    ret
; sub_0000_AA2B
; @0AA2B 0000:AA2B original=8b5e16
    mov bx, word ptr ss:[bp + 016h]
; @0AA2E 0000:AA2E original=d1e3
    shl bx, 1
; @0AA30 0000:AA30 original=2effa736aa
    jmp word ptr cs:[bx - 055CAh]
; @0AA35 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,045h,0BCh,04h,0ADh,0AEh,0EFh,0AFh,044h,0AEh,0EFh,0C2h,0AAh,010h,0ABh
; @0AA44 0000:AA44 original=f8 runtime CFG evidence
    clc
; @0AA45 0000:AA45 original=c3 runtime CFG evidence
    ret
; @0AA46 0000:AA46 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0AA49 0000:AA49 original=0bc0 runtime CFG evidence
    or ax, ax
; @0AA4B 0000:AA4B original=78f7 runtime CFG evidence
    JS_SHORT loc_0AA44
; @0AA4D 0000:AA4D original=8b368423 runtime CFG evidence
    mov si, word ptr ds:[02384h]
; @0AA51 0000:AA51 original=83fe03 runtime CFG evidence
    cmp si, 3
; @0AA54 0000:AA54 original=73ee runtime CFG evidence
    JAE_SHORT loc_0AA44
; @0AA56 0000:AA56 original=d1e6 runtime CFG evidence
    shl si, 1
; @0AA58 0000:AA58 original=d1e6 runtime CFG evidence
    shl si, 1
; @0AA5A 0000:AA5A original=81c64e21 runtime CFG evidence
    add si, 0214Eh
; @0AA5E 0000:AA5E original=ad runtime CFG evidence
    lodsw
; @0AA5F 0000:AA5F original=03067e23 runtime CFG evidence
    add ax, word ptr ds:[0237Eh]
; @0AA63 0000:AA63 original=a3f295 runtime CFG evidence
    mov word ptr ds:[095F2h], ax
; @0AA66 0000:AA66 original=ad runtime CFG evidence
    lodsw
; @0AA67 0000:AA67 original=03068023 runtime CFG evidence
    add ax, word ptr ds:[02380h]
; @0AA6B 0000:AA6B original=a3f495 runtime CFG evidence
    mov word ptr ds:[095F4h], ax
; @0AA6E 0000:AA6E original=e9c0d8 runtime CFG evidence
    JMP_NEAR loc_08331
; @0AA71 0000:AA71 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0AA74 0000:AA74 original=0bc0 runtime CFG evidence
    or ax, ax
; @0AA76 0000:AA76 original=78cc runtime CFG evidence
    JS_SHORT loc_0AA44
; @0AA78 0000:AA78 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0AA7B 0000:AA7B original=051800 runtime CFG evidence
    add ax, 018h
; @0AA7E 0000:AA7E original=3b068023 runtime CFG evidence
    cmp ax, word ptr ds:[02380h]
; @0AA82 0000:AA82 original=7cc0 runtime CFG evidence
    JL_SHORT loc_0AA44
; @0AA84 0000:AA84 original=2d2c00 runtime CFG evidence
    sub ax, 02Ch
; @0AA87 0000:AA87 original=3b068023 runtime CFG evidence
    cmp ax, word ptr ds:[02380h]
; @0AA8B 0000:AA8B original=7fb7 runtime CFG evidence
    JG_SHORT loc_0AA44
; @0AA8D 0000:AA8D original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @0AA92 0000:AA92 original=7517 runtime CFG evidence
    JNE_SHORT loc_0AAAB
; @0AA94 0000:AA94 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0AA97 0000:AA97 original=050800 runtime CFG evidence
    add ax, 8
; @0AA9A 0000:AA9A original=3b067e23 runtime CFG evidence
    cmp ax, word ptr ds:[0237Eh]
; @0AA9E 0000:AA9E original=72a4 runtime CFG evidence
    JB_SHORT loc_0AA44
; @0AAA0 0000:AAA0 original=2d0c00 runtime CFG evidence
    sub ax, 0Ch
; @0AAA3 0000:AAA3 original=3b067e23 runtime CFG evidence
    cmp ax, word ptr ds:[0237Eh]
; @0AAA7 0000:AAA7 original=779b runtime CFG evidence
    JA_SHORT loc_0AA44
; @0AAA9 0000:AAA9 original=f9 runtime CFG evidence
    stc
; @0AAAA 0000:AAAA original=c3 runtime CFG evidence
    ret
; @0AAAB 0000:AAAB original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0AAAE 0000:AAAE original=051800 runtime CFG evidence
    add ax, 018h
; @0AAB1 0000:AAB1 original=3b067e23 runtime CFG evidence
    cmp ax, word ptr ds:[0237Eh]
; @0AAB5 0000:AAB5 original=728d runtime CFG evidence
    JB_SHORT loc_0AA44
; @0AAB7 0000:AAB7 original=2d2c00 runtime CFG evidence
    sub ax, 02Ch
; @0AABA 0000:AABA original=3b067e23 runtime CFG evidence
    cmp ax, word ptr ds:[0237Eh]
; @0AABE 0000:AABE original=7784 runtime CFG evidence
    JA_SHORT loc_0AA44
; @0AAC0 0000:AAC0 original=f9 runtime CFG evidence
    stc
; @0AAC1 0000:AAC1 original=c3 runtime CFG evidence
    ret
; @0AAC2 0000:AAC2 original=ff4602 runtime CFG evidence
    inc word ptr ss:[bp + 2]
; @0AAC5 0000:AAC5 original=e87eff runtime CFG evidence
    CALL_NEAR loc_0AA46
; @0AAC8 0000:AAC8 original=7203 runtime CFG evidence
    JB_SHORT loc_0AACD
; @0AACA 0000:AACA original=e97811 runtime CFG evidence
    JMP_NEAR loc_0BC45
; @0AACD 0000:AACD original=e80300 runtime CFG evidence
    CALL_NEAR loc_0AAD3
; @0AAD0 0000:AAD0 original=e97211 runtime CFG evidence
    JMP_NEAR loc_0BC45
; @0AAD3 0000:AAD3 original=833e842303 runtime CFG evidence
    cmp word ptr ds:[02384h], 3
; @0AAD8 0000:AAD8 original=7201 runtime CFG evidence
    JB_SHORT loc_0AADB
; @0AADA 0000:AADA original=c3 runtime CFG evidence
    ret
; @0AADB 0000:AADB original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0AAE0 0000:AAE0 original=7405 runtime CFG evidence
    JE_SHORT loc_0AAE7
; @0AAE2 0000:AAE2 original=c606ffbe07 runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 7
; @0AAE7 0000:AAE7 original=bb2000 runtime CFG evidence
    mov bx, 020h
; @0AAEA 0000:AAEA original=e820b4 runtime CFG evidence
    CALL_NEAR loc_05F0D
; @0AAED 0000:AAED original=55 runtime CFG evidence
    push bp
; @0AAEE 0000:AAEE original=2eff360aab runtime CFG evidence
    push word ptr cs:[0AB0Ah]
; @0AAF3 0000:AAF3 original=8b5e26 runtime CFG evidence
    mov bx, word ptr ss:[bp + 026h]
; @0AAF6 0000:AAF6 original=bd7c23 runtime CFG evidence
    mov bp, 0237Ch
; @0AAF9 0000:AAF9 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0AAFB 0000:AAFB original=2effa700ab runtime CFG evidence
    jmp word ptr cs:[bx - 05500h]
; @0AB00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,044h,04Dh,09Dh,067h,09Dh,0AAh,062h,0B9h,09Dh,0Ch,0ABh,05Dh,0E9h,07h,012h
; @0AB10 0000:AB10 original=833e842303 runtime CFG evidence
    cmp word ptr ds:[02384h], 3
; @0AB15 0000:AB15 original=7203 runtime CFG evidence
    JB_SHORT loc_0AB1A
; @0AB17 0000:AB17 original=e90801 runtime CFG evidence
    JMP_NEAR loc_0AC22
; @0AB1A 0000:AB1A original=833e7ca403 runtime CFG evidence
    cmp word ptr ds:[0A47Ch], 3
; @0AB1F 0000:AB1F original=7203 runtime CFG evidence
    JB_SHORT loc_0AB24
; @0AB21 0000:AB21 original=e9fe00 runtime CFG evidence
    JMP_NEAR loc_0AC22
; @0AB24 0000:AB24 original=a13623 runtime CFG evidence
    mov ax, word ptr ds:[02336h]
; @0AB27 0000:AB27 original=bb0ca4 runtime CFG evidence
    mov bx, 0A40Ch
; @0AB2A 0000:AB2A original=d7 runtime CFG evidence
    xlat
; @0AB2B 0000:AB2B original=050900 runtime CFG evidence
    add ax, 9
; @0AB2E 0000:AB2E original=894608 runtime CFG evidence
    mov word ptr ss:[bp + 8], ax
; @0AB31 0000:AB31 original=ba14a4 runtime CFG evidence
    mov dx, 0A414h
; @0AB34 0000:AB34 original=bb7c23 runtime CFG evidence
    mov bx, 0237Ch
; @0AB37 0000:AB37 original=8b7708 runtime CFG evidence
    mov si, word ptr ds:[bx + 8]
; @0AB3A 0000:AB3A original=d1e6 runtime CFG evidence
    shl si, 1
; @0AB3C 0000:AB3C original=d1e6 runtime CFG evidence
    shl si, 1
; @0AB3E 0000:AB3E original=03f2 runtime CFG evidence
    add si, dx
; @0AB40 0000:AB40 original=ad runtime CFG evidence
    lodsw
; @0AB41 0000:AB41 original=034702 runtime CFG evidence
    add ax, word ptr ds:[bx + 2]
; @0AB44 0000:AB44 original=894602 runtime CFG evidence
    mov word ptr ss:[bp + 2], ax
; @0AB47 0000:AB47 original=ad runtime CFG evidence
    lodsw
; @0AB48 0000:AB48 original=034704 runtime CFG evidence
    add ax, word ptr ds:[bx + 4]
; @0AB4B 0000:AB4B original=894604 runtime CFG evidence
    mov word ptr ss:[bp + 4], ax
; @0AB4E 0000:AB4E original=c3 runtime CFG evidence
    ret
; @0AB4F 0000:AB4F original=a13c23 runtime CFG evidence
    mov ax, word ptr ds:[0233Ch]
; @0AB52 0000:AB52 original=051800 runtime CFG evidence
    add ax, 018h
; @0AB55 0000:AB55 original=894608 runtime CFG evidence
    mov word ptr ss:[bp + 8], ax
; @0AB58 0000:AB58 original=c3 runtime CFG evidence
    ret
; @0AB59 0000:AB59 original=c7062ca46ca9 runtime CFG evidence
    mov word ptr ds:[0A42Ch], 0A96Ch
; @0AB5F 0000:AB5F original=eb16 runtime CFG evidence
    JMP_SHORT loc_0AB77
; @0AB61 0000:AB61 original=c7062ca46aa9 runtime CFG evidence
    mov word ptr ds:[0A42Ch], 0A96Ah
; @0AB67 0000:AB67 original=eb0e runtime CFG evidence
    JMP_SHORT loc_0AB77
; @0AB69 0000:AB69 original=c7062ca468a9 runtime CFG evidence
    mov word ptr ds:[0A42Ch], 0A968h
; @0AB6F 0000:AB6F original=eb06 runtime CFG evidence
    JMP_SHORT loc_0AB77
; @0AB71 0000:AB71 original=c7062ca466a9 runtime CFG evidence
    mov word ptr ds:[0A42Ch], 0A966h
; @0AB77 0000:AB77 original=833e842303 runtime CFG evidence
    cmp word ptr ds:[02384h], 3
; @0AB7C 0000:AB7C original=7311 runtime CFG evidence
    JAE_SHORT loc_0AB8F
; @0AB7E 0000:AB7E original=e8ceff runtime CFG evidence
    CALL_NEAR loc_0AB4F
; @0AB81 0000:AB81 original=e8a400 runtime CFG evidence
    CALL_NEAR loc_0AC28
; @0AB84 0000:AB84 original=7209 runtime CFG evidence
    JB_SHORT loc_0AB8F
; @0AB86 0000:AB86 original=e8f800 runtime CFG evidence
    CALL_NEAR loc_0AC81
; @0AB89 0000:AB89 original=7201 runtime CFG evidence
    JB_SHORT loc_0AB8C
; @0AB8B 0000:AB8B original=c3 runtime CFG evidence
    ret
; @0AB8C 0000:AB8C original=e80a00 runtime CFG evidence
    CALL_NEAR loc_0AB99
; @0AB8F 0000:AB8F original=8b1e2ca4 runtime CFG evidence
    mov bx, word ptr ds:[0A42Ch]
; @0AB93 0000:AB93 original=c707ffff runtime CFG evidence
    mov word ptr ds:[bx], 0FFFFh
; @0AB97 0000:AB97 original=eb5a runtime CFG evidence
    JMP_SHORT loc_0ABF3
; @0AB99 0000:AB99 original=55 runtime CFG evidence
    push bp
; @0AB9A 0000:AB9A original=8beb runtime CFG evidence
    mov bp, bx
; @0AB9C 0000:AB9C original=e82814 runtime CFG evidence
    CALL_NEAR loc_0BFC7
; @0AB9F 0000:AB9F original=8bdd runtime CFG evidence
    mov bx, bp
; @0ABA1 0000:ABA1 original=5d runtime CFG evidence
    pop bp
; @0ABA2 0000:ABA2 original=c3 runtime CFG evidence
    ret
; @0ABA3 0000:ABA3 original=891e2ea4 runtime CFG evidence
    mov word ptr ds:[0A42Eh], bx
; @0ABA7 0000:ABA7 original=833e842303 runtime CFG evidence
    cmp word ptr ds:[02384h], 3
; @0ABAC 0000:ABAC original=7312 runtime CFG evidence
    JAE_SHORT loc_0ABC0
; @0ABAE 0000:ABAE original=a13c23 runtime CFG evidence
    mov ax, word ptr ds:[0233Ch]
; @0ABB1 0000:ABB1 original=051400 runtime CFG evidence
    add ax, 014h
; @0ABB4 0000:ABB4 original=894608 runtime CFG evidence
    mov word ptr ss:[bp + 8], ax
; @0ABB7 0000:ABB7 original=e8c700 runtime CFG evidence
    CALL_NEAR loc_0AC81
; @0ABBA 0000:ABBA original=7201 runtime CFG evidence
    JB_SHORT loc_0ABBD
; @0ABBC 0000:ABBC original=c3 runtime CFG evidence
    ret
; @0ABBD 0000:ABBD original=e8d9ff runtime CFG evidence
    CALL_NEAR loc_0AB99
; @0ABC0 0000:ABC0 original=8b1e2ea4 runtime CFG evidence
    mov bx, word ptr ds:[0A42Eh]
; @0ABC4 0000:ABC4 original=c707ffff runtime CFG evidence
    mov word ptr ds:[bx], 0FFFFh
; @0ABC8 0000:ABC8 original=eb29 runtime CFG evidence
    JMP_SHORT loc_0ABF3
; @0ABCA 0000:ABCA original=833e842303 runtime CFG evidence
    cmp word ptr ds:[02384h], 3
; @0ABCF 0000:ABCF original=730b runtime CFG evidence
    JAE_SHORT loc_0ABDC
; @0ABD1 0000:ABD1 original=ba20a4 runtime CFG evidence
    mov dx, 0A420h
; @0ABD4 0000:ABD4 original=e85dff runtime CFG evidence
    CALL_NEAR loc_0AB34
; @0ABD7 0000:ABD7 original=e84e00 runtime CFG evidence
    CALL_NEAR loc_0AC28
; @0ABDA 0000:ABDA original=7308 runtime CFG evidence
    JAE_SHORT loc_0ABE4
; @0ABDC 0000:ABDC original=c7066ea9ffff runtime CFG evidence
    mov word ptr ds:[0A96Eh], 0FFFFh
; @0ABE2 0000:ABE2 original=eb0f runtime CFG evidence
    JMP_SHORT loc_0ABF3
; @0ABE4 0000:ABE4 original=e89a00 runtime CFG evidence
    CALL_NEAR loc_0AC81
; @0ABE7 0000:ABE7 original=7201 runtime CFG evidence
    JB_SHORT loc_0ABEA
; @0ABE9 0000:ABE9 original=c3 runtime CFG evidence
    ret
; @0ABEA 0000:ABEA original=c7066ea9ffff runtime CFG evidence
    mov word ptr ds:[0A96Eh], 0FFFFh
; @0ABF0 0000:ABF0 original=e8a6ff runtime CFG evidence
    CALL_NEAR loc_0AB99
; @0ABF3 0000:ABF3 original=83fdff runtime CFG evidence
    cmp bp, -1
; @0ABF6 0000:ABF6 original=7501 runtime CFG evidence
    JNE_SHORT loc_0ABF9
; @0ABF8 0000:ABF8 original=c3 runtime CFG evidence
    ret
; @0ABF9 0000:ABF9 original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0ABFE 0000:ABFE original=7405 runtime CFG evidence
    JE_SHORT loc_0AC05
; @0AC00 0000:AC00 original=c606ffbe19 runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 019h
; @0AC05 0000:AC05 original=c746180100 runtime CFG evidence
    mov word ptr ss:[bp + 018h], 1
; @0AC0A 0000:AC0A original=c746160400 runtime CFG evidence
    mov word ptr ss:[bp + 016h], 4
; @0AC0F 0000:AC0F original=c746220000 runtime CFG evidence
    mov word ptr ss:[bp + 022h], 0
; @0AC14 0000:AC14 original=c746080000 runtime CFG evidence
    mov word ptr ss:[bp + 8], 0
; @0AC19 0000:AC19 original=55
    push bp
; @0AC1A 0000:AC1A original=e85dd7
    CALL_NEAR loc_0837A
; @0AC1D 0000:AC1D original=e87ed9
    CALL_NEAR loc_0859E
; @0AC20 0000:AC20 original=5d
    pop bp
; @0AC21 0000:AC21 original=c3
    ret
; @0AC22 0000:AC22 original=c746000000 runtime CFG evidence
    mov word ptr ss:[bp], 0
; @0AC27 0000:AC27 original=c3 runtime CFG evidence
    ret
; @0AC28 0000:AC28 original=833e7ca400 runtime CFG evidence
    cmp word ptr ds:[0A47Ch], 0
; @0AC2D 0000:AC2D original=7403 runtime CFG evidence
    JE_SHORT loc_0AC32
; @0AC2F 0000:AC2F original=e912fe runtime CFG evidence
    JMP_NEAR loc_0AA44
; @0AC32 0000:AC32 original=833eacbd01 runtime CFG evidence
    cmp word ptr ds:[0BDACh], 1
; @0AC37 0000:AC37 original=7503 runtime CFG evidence
    JNE_SHORT ProbeGridForRecordResponse_0AC3C
; @0AC39 0000:AC39 original=e908fe runtime CFG evidence
    JMP_NEAR loc_0AA44
; ProbeGridForRecordResponse: internal entry after AC28 gates, not a separate proven function.
; Probe base+13, then base+14 only if first attribute is zero and X low nibble !=0.
; Negative-Y FFFF sentinel is NOT checked here: +13 wraps to 000C.
; Attribute ZF controls response entry; source/table gameplay identities remain unknown.
; @0AC3C 0000:AC3C original=e834a4 runtime CFG evidence
    CALL_NEAR ComputeRecordGridOffset_05073
; @0AC3F 0000:AC3F original=83c30d runtime CFG evidence
    add bx, 0Dh
; @0AC42 0000:AC42 original=e816a4 runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0AC45 0000:AC45 original=750f runtime CFG evidence
    JNE_SHORT SetResponseAndStepRecordCounter_0AC56
; @0AC47 0000:AC47 original=f746040f00 runtime CFG evidence
    test word ptr ss:[bp + REC_X], 0Fh
; @0AC4C 0000:AC4C original=7406 runtime CFG evidence
    JE_SHORT RecordResponseReturnClear_0AC54
; @0AC4E 0000:AC4E original=43 runtime CFG evidence
    inc bx
; @0AC4F 0000:AC4F original=e809a4 runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0AC52 0000:AC52 original=7502 runtime CFG evidence
    JNE_SHORT SetResponseAndStepRecordCounter_0AC56
; Shared clear-carry return for both grid probe and independently called response helper.
; @0AC54 0000:AC54 original=f8 runtime CFG evidence
    clc
; @0AC55 0000:AC55 original=c3 runtime CFG evidence
    ret
; SetResponseAndStepRecordCounter: also CALLed from ACF1 in the record scan.
; SS:BP record; DS state. Set +24=5; decrement +20 only when BEDC!=0 or 2324==1.
; CF=1 only on decremented zero, also clearing +24; otherwise CF=0. Zero wraps to FFFF.
; If DS:98C0!=0, write BEFF=0E. Other flag values are path-dependent.
; No general/segment register changes in this entry; shared return at AC54.
; @0AC56 0000:AC56 original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0AC5B 0000:AC5B original=7405 runtime CFG evidence
    JE_SHORT SetRecordResponseWord_0AC62
; @0AC5D 0000:AC5D original=c606ffbe0e runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 0Eh
; @0AC62 0000:AC62 original=c746240500 runtime CFG evidence
    mov word ptr ss:[bp + RESPONSE_WORD_24], 5
; @0AC67 0000:AC67 original=833edcbe00 runtime CFG evidence
    cmp word ptr ds:[0BEDCh], 0
; @0AC6C 0000:AC6C original=7507 runtime CFG evidence
    JNE_SHORT StepRecordResponseCounter_0AC75
; @0AC6E 0000:AC6E original=833e242301 runtime CFG evidence
    cmp word ptr ds:[COUNT_GATE_2324], 1
; @0AC73 0000:AC73 original=75df runtime CFG evidence
    JNE_SHORT RecordResponseReturnClear_0AC54
; @0AC75 0000:AC75 original=ff4e20 runtime CFG evidence
    dec word ptr ss:[bp + RESPONSE_COUNTER_20]
; @0AC78 0000:AC78 original=75da runtime CFG evidence
    JNE_SHORT RecordResponseReturnClear_0AC54
; @0AC7A 0000:AC7A original=c746240000 runtime CFG evidence
    mov word ptr ss:[bp + RESPONSE_WORD_24], 0
; @0AC7F 0000:AC7F original=f9 runtime CFG evidence
    stc
; @0AC80 0000:AC80 original=c3 runtime CFG evidence
    ret
; @0AC81 0000:AC81 original=833eacbd01 runtime CFG evidence
    cmp word ptr ds:[0BDACh], 1
; @0AC86 0000:AC86 original=7503 runtime CFG evidence
    JNE_SHORT loc_0AC8B
; @0AC88 0000:AC88 original=e9b9fd runtime CFG evidence
    JMP_NEAR loc_0AA44
; @0AC8B 0000:AC8B original=b92300 runtime CFG evidence
    mov cx, 023h
; @0AC8E 0000:AC8E original=bbb423 runtime CFG evidence
    mov bx, 023B4h
; @0AC91 0000:AC91 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0AC94 0000:AC94 original=8b7e02 runtime CFG evidence
    mov di, word ptr ss:[bp + 2]
; @0AC97 0000:AC97 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @0AC9A 0000:AC9A original=7436 runtime CFG evidence
    JE_SHORT loc_0ACD2
; @0AC9C 0000:AC9C original=837f1801 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 1
; @0ACA0 0000:ACA0 original=7430 runtime CFG evidence
    JE_SHORT loc_0ACD2
; @0ACA2 0000:ACA2 original=837f1401 runtime CFG evidence
    cmp word ptr ds:[bx + 014h], 1
; @0ACA6 0000:ACA6 original=752a runtime CFG evidence
    JNE_SHORT loc_0ACD2
; @0ACA8 0000:ACA8 original=8b7702 runtime CFG evidence
    mov si, word ptr ds:[bx + 2]
; @0ACAB 0000:ACAB original=83c610 runtime CFG evidence
    add si, 010h
; @0ACAE 0000:ACAE original=3bfe runtime CFG evidence
    cmp di, si
; @0ACB0 0000:ACB0 original=7f20 runtime CFG evidence
    JG_SHORT loc_0ACD2
; @0ACB2 0000:ACB2 original=83ee20 runtime CFG evidence
    sub si, 020h
; @0ACB5 0000:ACB5 original=3bfe runtime CFG evidence
    cmp di, si
; @0ACB7 0000:ACB7 original=7c19 runtime CFG evidence
    JL_SHORT loc_0ACD2
; @0ACB9 0000:ACB9 original=8b7704 runtime CFG evidence
    mov si, word ptr ds:[bx + 4]
; @0ACBC 0000:ACBC original=83c610 runtime CFG evidence
    add si, 010h
; @0ACBF 0000:ACBF original=3bc6 runtime CFG evidence
    cmp ax, si
; @0ACC1 0000:ACC1 original=7f0f runtime CFG evidence
    JG_SHORT loc_0ACD2
; @0ACC3 0000:ACC3 original=83ee20 runtime CFG evidence
    sub si, 020h
; @0ACC6 0000:ACC6 original=3bc6 runtime CFG evidence
    cmp ax, si
; @0ACC8 0000:ACC8 original=7c08 runtime CFG evidence
    JL_SHORT loc_0ACD2
; @0ACCA 0000:ACCA original=8b760e runtime CFG evidence
    mov si, word ptr ss:[bp + 0Eh]
; @0ACCD 0000:ACCD original=3b770e runtime CFG evidence
    cmp si, word ptr ds:[bx + 0Eh]
; @0ACD0 0000:ACD0 original=7507 runtime CFG evidence
    JNE_SHORT loc_0ACD9
; @0ACD2 0000:ACD2 original=83c338 runtime CFG evidence
    add bx, 038h
; @0ACD5 0000:ACD5 original=e2c0 runtime CFG evidence
    LOOP_SHORT loc_0AC97
; @0ACD7 0000:ACD7 original=f8 runtime CFG evidence
    clc
; @0ACD8 0000:ACD8 original=c3 runtime CFG evidence
    ret
; @0ACD9 0000:ACD9 original=837f1605 runtime CFG evidence
    cmp word ptr ds:[bx + 016h], 5
; @0ACDD 0000:ACDD original=741a runtime CFG evidence
    JE_SHORT loc_0ACF9
; @0ACDF 0000:ACDF original=837f1401 runtime CFG evidence
    cmp word ptr ds:[bx + 014h], 1
; @0ACE3 0000:ACE3 original=7403 runtime CFG evidence
    JE_SHORT loc_0ACE8
; @0ACE5 0000:ACE5 original=e971a3 runtime CFG evidence
    JMP_NEAR loc_05059
; @0ACE8 0000:ACE8 original=837f1604 runtime CFG evidence
    cmp word ptr ds:[bx + 016h], 4
; @0ACEC 0000:ACEC original=75e4 runtime CFG evidence
    JNE_SHORT loc_0ACD2
; @0ACEE 0000:ACEE original=e8a8fe runtime CFG evidence
    CALL_NEAR loc_0AB99
; Record scan shares the same response/counter path as the grid attribute probe.
; @0ACF1 0000:ACF1 original=e862ff runtime CFG evidence
    CALL_NEAR SetResponseAndStepRecordCounter_0AC56
; @0ACF4 0000:ACF4 original=7201 runtime CFG evidence
    JB_SHORT loc_0ACF7
; @0ACF6 0000:ACF6 original=c3 runtime CFG evidence
    ret
; @0ACF7 0000:ACF7 original=f9 runtime CFG evidence
    stc
; @0ACF8 0000:ACF8 original=c3 runtime CFG evidence
    ret
; @0ACF9 0000:ACF9 original=55 runtime CFG evidence
    push bp
; @0ACFA 0000:ACFA original=8beb runtime CFG evidence
    mov bp, bx
; @0ACFC 0000:ACFC original=e8d4fd runtime CFG evidence
    CALL_NEAR loc_0AAD3
; @0ACFF 0000:ACFF original=8bdd runtime CFG evidence
    mov bx, bp
; @0AD01 0000:AD01 original=5d runtime CFG evidence
    pop bp
; @0AD02 0000:AD02 original=f8 runtime CFG evidence
    clc
; @0AD03 0000:AD03 original=c3 runtime CFG evidence
    ret
; @0AD04 0000:AD04 original=833eacbd01 runtime CFG evidence
    cmp word ptr ds:[0BDACh], 1
; @0AD09 0000:AD09 original=7409 runtime CFG evidence
    JE_SHORT loc_0AD14
; @0AD0B 0000:AD0B original=813e5023b600 runtime CFG evidence
    cmp word ptr ds:[02350h], 0B6h
; @0AD11 0000:AD11 original=7701 runtime CFG evidence
    JA_SHORT loc_0AD14
; @0AD13 0000:AD13 original=c3 runtime CFG evidence
    ret
; @0AD14 0000:AD14 original=837e080f runtime CFG evidence
    cmp word ptr ss:[bp + 8], 0Fh
; @0AD18 0000:AD18 original=7503 runtime CFG evidence
    JNE_SHORT loc_0AD1D
; @0AD1A 0000:AD1A original=e9adfe runtime CFG evidence
    JMP_NEAR loc_0ABCA
; @0AD1D 0000:AD1D original=3b2e66a9 runtime CFG evidence
    cmp bp, word ptr ds:[0A966h]
; @0AD21 0000:AD21 original=7503 runtime CFG evidence
    JNE_SHORT loc_0AD26
; @0AD23 0000:AD23 original=e94bfe runtime CFG evidence
    JMP_NEAR loc_0AB71
; @0AD26 0000:AD26 original=3b2e68a9 runtime CFG evidence
    cmp bp, word ptr ds:[0A968h]
; @0AD2A 0000:AD2A original=7503 runtime CFG evidence
    JNE_SHORT loc_0AD2F
; @0AD2C 0000:AD2C original=e93afe runtime CFG evidence
    JMP_NEAR loc_0AB69
; @0AD2F 0000:AD2F original=3b2e6aa9 runtime CFG evidence
    cmp bp, word ptr ds:[0A96Ah]
; @0AD33 0000:AD33 original=7503 runtime CFG evidence
    JNE_SHORT loc_0AD38
; @0AD35 0000:AD35 original=e929fe runtime CFG evidence
    JMP_NEAR loc_0AB61
; @0AD38 0000:AD38 original=3b2e6ca9 runtime CFG evidence
    cmp bp, word ptr ds:[0A96Ch]
; @0AD3C 0000:AD3C original=7503 runtime CFG evidence
    JNE_SHORT loc_0AD41
; @0AD3E 0000:AD3E original=e918fe runtime CFG evidence
    JMP_NEAR loc_0AB59
; @0AD41 0000:AD41 original=bb62a9 runtime CFG evidence
    mov bx, 0A962h
; @0AD44 0000:AD44 original=3b2e62a9 runtime CFG evidence
    cmp bp, word ptr ds:[0A962h]
; @0AD48 0000:AD48 original=7503 runtime CFG evidence
    JNE_SHORT loc_0AD4D
; @0AD4A 0000:AD4A original=e956fe runtime CFG evidence
    JMP_NEAR loc_0ABA3
; @0AD4D 0000:AD4D original=bb64a9 runtime CFG evidence
    mov bx, 0A964h
; @0AD50 0000:AD50 original=3b2e64a9 runtime CFG evidence
    cmp bp, word ptr ds:[0A964h]
; @0AD54 0000:AD54 original=7503 runtime CFG evidence
    JNE_SHORT loc_0AD59
; @0AD56 0000:AD56 original=e94afe runtime CFG evidence
    JMP_NEAR loc_0ABA3
; @0AD59 0000:AD59 original=c3 runtime CFG evidence
    ret
; @0AD5A 0000:AD5A original=a178a2 runtime CFG evidence
    mov ax, word ptr ds:[0A278h]
; @0AD5D 0000:AD5D original=014602 runtime CFG evidence
    add word ptr ss:[bp + 2], ax
; @0AD60 0000:AD60 original=837e0208 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 8
; @0AD64 0000:AD64 original=7303 runtime CFG evidence
    JAE_SHORT loc_0AD69
; @0AD66 0000:AD66 original=e9ae0f runtime CFG evidence
    JMP_NEAR loc_0BD17
; @0AD69 0000:AD69 original=817e02e000 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 0E0h
; @0AD6E 0000:AD6E original=7603 runtime CFG evidence
    JBE_SHORT loc_0AD73
; @0AD70 0000:AD70 original=e9a40f runtime CFG evidence
    JMP_NEAR loc_0BD17
; @0AD73 0000:AD73 original=817e04c800 runtime CFG evidence
    cmp word ptr ss:[bp + 4], 0C8h
; @0AD78 0000:AD78 original=7603 runtime CFG evidence
    JBE_SHORT loc_0AD7D
; @0AD7A 0000:AD7A original=e99a0f runtime CFG evidence
    JMP_NEAR loc_0BD17
; @0AD7D 0000:AD7D original=837e1602 runtime CFG evidence
    cmp word ptr ss:[bp + 016h], 2
; @0AD81 0000:AD81 original=7545 runtime CFG evidence
    JNE_SHORT loc_0ADC8
; @0AD83 0000:AD83 original=837e1802 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 2
; @0AD87 0000:AD87 original=7426 runtime CFG evidence
    JE_SHORT loc_0ADAF
; @0AD89 0000:AD89 original=837e1804 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 4
; @0AD8D 0000:AD8D original=7420 runtime CFG evidence
    JE_SHORT loc_0ADAF
; @0AD8F 0000:AD8F original=837e180c runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 0Ch
; @0AD93 0000:AD93 original=741a runtime CFG evidence
    JE_SHORT loc_0ADAF
; @0AD95 0000:AD95 original=837e1805 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 5
; @0AD99 0000:AD99 original=7414 runtime CFG evidence
    JE_SHORT loc_0ADAF
; @0AD9B 0000:AD9B original=837e1806 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 6
; @0AD9F 0000:AD9F original=740e runtime CFG evidence
    JE_SHORT loc_0ADAF
; @0ADA1 0000:ADA1 original=837e1809 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 9
; @0ADA5 0000:ADA5 original=7408 runtime CFG evidence
    JE_SHORT loc_0ADAF
; @0ADA7 0000:ADA7 original=837e1808 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 8
; @0ADAB 0000:ADAB original=7402 runtime CFG evidence
    JE_SHORT loc_0ADAF
; @0ADAD 0000:ADAD original=eb19 runtime CFG evidence
    JMP_SHORT loc_0ADC8
; @0ADAF 0000:ADAF original=833eacbd01 runtime CFG evidence
    cmp word ptr ds:[0BDACh], 1
; @0ADB4 0000:ADB4 original=7412 runtime CFG evidence
    JE_SHORT loc_0ADC8
; Sibling grid probe: unlike AC3C, distinguishes attribute 1 from other nonzero bytes.
; The FFFF grid sentinel is again not checked before adding 13.
; @0ADB6 0000:ADB6 original=e8baa2 runtime CFG evidence
    CALL_NEAR ComputeRecordGridOffset_05073
; @0ADB9 0000:ADB9 original=83c30d runtime CFG evidence
    add bx, 0Dh
; @0ADBC 0000:ADBC original=e89ca2 runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0ADBF 0000:ADBF original=7407 runtime CFG evidence
    JE_SHORT loc_0ADC8
; @0ADC1 0000:ADC1 original=fec8 runtime CFG evidence
    dec al
; @0ADC3 0000:ADC3 original=7503 runtime CFG evidence
    JNE_SHORT loc_0ADC8
; @0ADC5 0000:ADC5 original=e94f0f runtime CFG evidence
    JMP_NEAR loc_0BD17
; @0ADC8 0000:ADC8 original=c3 runtime CFG evidence
    ret
; @0ADC9 0000:ADC9 original=c74602ffff runtime CFG evidence
    mov word ptr ss:[bp + 2], 0FFFFh
; @0ADCE 0000:ADCE original=eb90 runtime CFG evidence
    JMP_SHORT loc_0AD60
; @0ADD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,046h,02h,0FFh,046h,02h,0E9h,077h,04h,083h,06Eh,02h,010h,0EBh,081h,0A1h
; @0ADE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,023h,05h,05Ah,00h,089h,046h,08h,083h,06Eh,02h,03h,0E9h,071h,0FFh,0E9h
; @0ADF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,0FFh,0A1h,02Ah,023h,0D1h,0E8h,05h,00h,00h,089h,046h,08h,0FFh,04Eh,01Ch
; @0AE00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,0C7h,0B8h,050h,0B2h,050h,0E9h,05Ah,01h,083h,07Eh,01Ch,00h,074h,0Ah,0FFh
; @0AE10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,01Ch,075h,09h,0C7h,046h,06h,00h,00h,083h,06Eh,02h,02h,08Bh,046h,06h
; @0AE20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,028h,00h,089h,046h,08h,0E8h,0F9h,00h,0E9h,034h,0FFh,081h,07Eh,04h,0C8h
; @0AE30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,096h,083h,06Eh,02h,04h,0F7h,046h,04h,07h,00h,075h,020h,0F7h,046h
; @0AE40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,08h,00h,074h,019h,083h,03Eh,0ACh,0BDh,01h,074h,012h,0E8h,024h,0A2h,083h
; @0AE50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0Eh,0E8h,06h,0A2h,0C7h,046h,06h,00h,00h,03Ch,01h,074h,09h,0C7h,046h
; @0AE60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,01h,00h,083h,046h,04h,04h,0A1h,026h,023h,0D1h,0E0h,0D1h,0E0h,025h,08h
; @0AE70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03h,046h,06h,05h,08h,00h,089h,046h,08h,0E9h,0DDh,0FEh,083h,07Eh,04h
; @0AE80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,075h,03h,0E9h,043h,0FFh,083h,06Eh,02h,04h,0F7h,046h,04h,0Fh,00h,075h
; @0AE90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 019h,083h,03Eh,0ACh,0BDh,01h,074h,012h,0E8h,0D8h,0A1h,083h,0C3h,0Ch,0E8h,0BAh
; @0AEA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,0C7h,046h,06h,00h,00h,03Ch,01h,074h,09h,0C7h,046h,06h,07h,00h,083h
; @0AEB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,04h,04h,08Bh,046h,06h,05h,08h,00h,089h,046h,08h,0E9h,09Bh,0FEh
; @0AEBF 0000:AEBF original=b850b2 runtime CFG evidence
    mov ax, 0B250h
; @0AEC2 0000:AEC2 original=50 runtime CFG evidence
    push ax
; @0AEC3 0000:AEC3 original=833e562300 runtime CFG evidence
    cmp word ptr ds:[02356h], 0
; @0AEC8 0000:AEC8 original=7403 runtime CFG evidence
    JE_SHORT loc_0AECD
; @0AECA 0000:AECA original=e99300 runtime CFG evidence
    JMP_NEAR loc_0AF60
; @0AECD 0000:AECD original=837e0604 runtime CFG evidence
    cmp word ptr ss:[bp + 6], 4
; @0AED1 0000:AED1 original=7503 runtime CFG evidence
    JNE_SHORT loc_0AED6
; @0AED3 0000:AED3 original=e98a00 runtime CFG evidence
    JMP_NEAR loc_0AF60
; @0AED6 0000:AED6 original=eb0c runtime CFG evidence
    JMP_SHORT loc_0AEE4
; @0AED8 0000:AED8 original=ff4e1c runtime CFG evidence
    dec word ptr ss:[bp + 01Ch]
; @0AEDB 0000:AEDB original=7503 runtime CFG evidence
    JNE_SHORT loc_0AEE0
; @0AEDD 0000:AEDD original=e9e9fe runtime CFG evidence
    JMP_NEAR loc_0ADC9
; @0AEE0 0000:AEE0 original=b850b2 runtime CFG evidence
    mov ax, 0B250h
; @0AEE3 0000:AEE3 original=50 runtime CFG evidence
    push ax
; @0AEE4 0000:AEE4 original=8b5e06 runtime CFG evidence
    mov bx, word ptr ss:[bp + 6]
; @0AEE7 0000:AEE7 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0AEE9 0000:AEE9 original=2effa7eeae runtime CFG evidence
    jmp word ptr cs:[bx - 05112h]
; @0AEEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Bh,0AFh,010h,0AFh,014h,0AFh,0FEh,0AEh,02h,0AFh,019h,0AFh,01Dh,0AFh,07h,0AFh
; @0AEFE 0000:AEFE original=83460408 runtime CFG evidence
    add word ptr ss:[bp + 4], 8
; @0AF02 0000:AF02 original=83460208 runtime CFG evidence
    add word ptr ss:[bp + 2], 8
; @0AF06 0000:AF06 original=c3 runtime CFG evidence
    ret
; @0AF07 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,06Eh,04h,08h
; @0AF0B 0000:AF0B original=836e0208 runtime CFG evidence
    sub word ptr ss:[bp + 2], 8
; @0AF0F 0000:AF0F original=c3 runtime CFG evidence
    ret
; @0AF10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,06Eh,02h,08h
; @0AF14 0000:AF14 original=83460408 runtime CFG evidence
    add word ptr ss:[bp + 4], 8
; @0AF18 0000:AF18 original=c3 runtime CFG evidence
    ret
; @0AF19 0000:AF19 original=83460208 runtime CFG evidence
    add word ptr ss:[bp + 2], 8
; @0AF1D 0000:AF1D original=836e0408 runtime CFG evidence
    sub word ptr ss:[bp + 4], 8
; @0AF21 0000:AF21 original=c3 runtime CFG evidence
    ret
; @0AF22 0000:AF22 original=8b5e06 runtime CFG evidence
    mov bx, word ptr ss:[bp + 6]
; @0AF25 0000:AF25 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0AF27 0000:AF27 original=2effa72caf runtime CFG evidence
    jmp word ptr cs:[bx - 050D4h]
; @0AF2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 049h,0AFh,04Eh,0AFh,052h,0AFh,03Ch,0AFh,040h,0AFh,057h,0AFh,05Bh,0AFh,045h,0AFh
; @0AF3C 0000:AF3C original=83460403 runtime CFG evidence
    add word ptr ss:[bp + 4], 3
; @0AF40 0000:AF40 original=83460203 runtime CFG evidence
    add word ptr ss:[bp + 2], 3
; @0AF44 0000:AF44 original=c3 runtime CFG evidence
    ret
; @0AF45 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,06Eh,04h,03h,083h,06Eh,02h,03h,0C3h,083h,06Eh,02h,03h,083h,046h,04h
; @0AF55 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0C3h
; @0AF57 0000:AF57 original=83460203 runtime CFG evidence
    add word ptr ss:[bp + 2], 3
; @0AF5B 0000:AF5B original=836e0403 runtime CFG evidence
    sub word ptr ss:[bp + 4], 3
; @0AF5F 0000:AF5F original=c3 runtime CFG evidence
    ret
; @0AF60 0000:AF60 original=e80000 runtime CFG evidence
    CALL_NEAR loc_0AF63
; @0AF63 0000:AF63 original=8b5e06 runtime CFG evidence
    mov bx, word ptr ss:[bp + 6]
; @0AF66 0000:AF66 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0AF68 0000:AF68 original=2effa76eaf runtime CFG evidence
    jmp word ptr cs:[bx - 05092h]
; @0AF6D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,08Bh,0AFh,090h,0AFh,094h,0AFh,07Eh,0AFh,082h,0AFh,099h,0AFh,09Dh,0AFh,087h
; @0AF7D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh
; @0AF7E 0000:AF7E original=83460402 runtime CFG evidence
    add word ptr ss:[bp + 4], 2
; @0AF82 0000:AF82 original=83460202 runtime CFG evidence
    add word ptr ss:[bp + 2], 2
; @0AF86 0000:AF86 original=c3 runtime CFG evidence
    ret
; @0AF87 0000:AF87 original=836e0402 runtime CFG evidence
    sub word ptr ss:[bp + 4], 2
; @0AF8B 0000:AF8B original=836e0202 runtime CFG evidence
    sub word ptr ss:[bp + 2], 2
; @0AF8F 0000:AF8F original=c3 runtime CFG evidence
    ret
; @0AF90 0000:AF90 original=836e0202 runtime CFG evidence
    sub word ptr ss:[bp + 2], 2
; @0AF94 0000:AF94 original=83460402 runtime CFG evidence
    add word ptr ss:[bp + 4], 2
; @0AF98 0000:AF98 original=c3 runtime CFG evidence
    ret
; @0AF99 0000:AF99 original=83460202 runtime CFG evidence
    add word ptr ss:[bp + 2], 2
; @0AF9D 0000:AF9D original=836e0402 runtime CFG evidence
    sub word ptr ss:[bp + 4], 2
; @0AFA1 0000:AFA1 original=c3 runtime CFG evidence
    ret
; @0AFA2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Eh,06h,0D1h,0E3h,02Eh,0FFh,0A7h,0ACh,0AFh,0C6h,0AFh,0CAh,0AFh,0CDh,0AFh
; @0AFB2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BCh,0AFh,0BFh,0AFh,0D1h,0AFh,0D4h,0AFh,0C3h,0AFh,0FFh,046h,04h,0FFh,046h,02h
; @0AFC2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0FFh,04Eh,04h,0FFh,04Eh,02h,0C3h,0FFh,04Eh,02h,0FFh,046h,04h,0C3h,0FFh
; @0AFD2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,0FFh,04Eh,04h,0C3h
; @0AFD8 0000:AFD8 original=c70630a40000 runtime CFG evidence
    mov word ptr ds:[0A430h], 0
; @0AFDE 0000:AFDE original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0AFE1 0000:AFE1 original=a332a4 runtime CFG evidence
    mov word ptr ds:[0A432h], ax
; @0AFE4 0000:AFE4 original=a338a4 runtime CFG evidence
    mov word ptr ds:[0A438h], ax
; @0AFE7 0000:AFE7 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0AFEA 0000:AFEA original=a334a4 runtime CFG evidence
    mov word ptr ds:[0A434h], ax
; @0AFED 0000:AFED original=a336a4 runtime CFG evidence
    mov word ptr ds:[0A436h], ax
; @0AFF0 0000:AFF0 original=a178a2 runtime CFG evidence
    mov ax, word ptr ds:[0A278h]
; @0AFF3 0000:AFF3 original=014602 runtime CFG evidence
    add word ptr ss:[bp + 2], ax
; @0AFF6 0000:AFF6 original=836e0210 runtime CFG evidence
    sub word ptr ss:[bp + 2], 010h
; @0AFFA 0000:AFFA original=e81000 runtime CFG evidence
    CALL_NEAR loc_0B00D
; @0AFFD 0000:AFFD original=83460210 runtime CFG evidence
    add word ptr ss:[bp + 2], 010h
; @0B001 0000:B001 original=a178a2 runtime CFG evidence
    mov ax, word ptr ds:[0A278h]
; @0B004 0000:B004 original=294602 runtime CFG evidence
    sub word ptr ss:[bp + 2], ax
; @0B007 0000:B007 original=833e30a400 runtime CFG evidence
    cmp word ptr ds:[0A430h], 0
; @0B00C 0000:B00C original=c3 runtime CFG evidence
    ret
; Sibling grid consumer explicitly rejects BX=FFFF; grid-helper flags are dead.
; @0B00D 0000:B00D original=e863a0 runtime CFG evidence
    CALL_NEAR ComputeRecordGridOffset_05073
; @0B010 0000:B010 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0B013 0000:B013 original=741d runtime CFG evidence
    JE_SHORT loc_0B032
; @0B015 0000:B015 original=8bd3 runtime CFG evidence
    mov dx, bx
; @0B017 0000:B017 original=8b5e06 runtime CFG evidence
    mov bx, word ptr ss:[bp + 6]
; @0B01A 0000:B01A original=d1e3 runtime CFG evidence
    shl bx, 1
; @0B01C 0000:B01C original=2effa722b0 runtime CFG evidence
    jmp word ptr cs:[bx - 04FDEh]
; @0B021 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,07Dh,0B0h,0C9h,0B0h,0CCh,0B0h,039h,0B0h,03Ch,0B0h,0Ch,0B1h,0Fh,0B1h,07Ah
; @0B031 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h
; @0B032 0000:B032 original=c70630a40100 runtime CFG evidence
    mov word ptr ds:[0A430h], 1
; @0B038 0000:B038 original=c3 runtime CFG evidence
    ret
; @0B039 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,090h,00h
; @0B03C 0000:B03C original=8bda runtime CFG evidence
    mov bx, dx
; @0B03E 0000:B03E original=83eb0d runtime CFG evidence
    sub bx, 0Dh
; @0B041 0000:B041 original=e817a0 runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B044 0000:B044 original=75ec runtime CFG evidence
    JNE_SHORT loc_0B032
; @0B046 0000:B046 original=f746040f00 runtime CFG evidence
    test word ptr ss:[bp + 4], 0Fh
; @0B04B 0000:B04B original=7406 runtime CFG evidence
    JE_SHORT loc_0B053
; @0B04D 0000:B04D original=43 runtime CFG evidence
    inc bx
; @0B04E 0000:B04E original=e80aa0 runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B051 0000:B051 original=75df runtime CFG evidence
    JNE_SHORT loc_0B032
; @0B053 0000:B053 original=ff4602 runtime CFG evidence
    inc word ptr ss:[bp + 2]
; @0B056 0000:B056 original=ff0638a4 runtime CFG evidence
    inc word ptr ds:[0A438h]
; @0B05A 0000:B05A original=53 runtime CFG evidence
    push bx
; @0B05B 0000:B05B original=e8720d runtime CFG evidence
    CALL_NEAR loc_0BDD0
; @0B05E 0000:B05E original=5b runtime CFG evidence
    pop bx
; @0B05F 0000:B05F original=7309 runtime CFG evidence
    JAE_SHORT loc_0B06A
; @0B061 0000:B061 original=ff4e02 runtime CFG evidence
    dec word ptr ss:[bp + 2]
; @0B064 0000:B064 original=ff0e38a4 runtime CFG evidence
    dec word ptr ds:[0A438h]
; @0B068 0000:B068 original=ebc8 runtime CFG evidence
    JMP_SHORT loc_0B032
; @0B06A 0000:B06A original=ff065a21 runtime CFG evidence
    inc word ptr ds:[0215Ah]
; @0B06E 0000:B06E original=83265a210f runtime CFG evidence
    and word ptr ds:[0215Ah], 0Fh
; @0B073 0000:B073 original=7401 runtime CFG evidence
    JE_SHORT loc_0B076
; @0B075 0000:B075 original=c3 runtime CFG evidence
    ret
; @0B076 0000:B076 original=83ea0d runtime CFG evidence
    sub dx, 0Dh
; @0B079 0000:B079 original=c3 runtime CFG evidence
    ret
; @0B07A 0000:B07A original=e89200 runtime CFG evidence
    CALL_NEAR loc_0B10F
; @0B07D 0000:B07D original=8bda runtime CFG evidence
    mov bx, dx
; @0B07F 0000:B07F original=f7065a210f00 runtime CFG evidence
    test word ptr ds:[0215Ah], 0Fh
; @0B085 0000:B085 original=7515 runtime CFG evidence
    JNE_SHORT loc_0B09C
; @0B087 0000:B087 original=83c30d runtime CFG evidence
    add bx, 0Dh
; @0B08A 0000:B08A original=e8ce9f runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B08D 0000:B08D original=75a3 runtime CFG evidence
    JNE_SHORT loc_0B032
; @0B08F 0000:B08F original=f746040f00 runtime CFG evidence
    test word ptr ss:[bp + 4], 0Fh
; @0B094 0000:B094 original=7406 runtime CFG evidence
    JE_SHORT loc_0B09C
; @0B096 0000:B096 original=43 runtime CFG evidence
    inc bx
; @0B097 0000:B097 original=e8c19f runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B09A 0000:B09A original=7596 runtime CFG evidence
    JNE_SHORT loc_0B032
; @0B09C 0000:B09C original=ff4e02 runtime CFG evidence
    dec word ptr ss:[bp + 2]
; @0B09F 0000:B09F original=ff0e38a4 runtime CFG evidence
    dec word ptr ds:[0A438h]
; @0B0A3 0000:B0A3 original=53 runtime CFG evidence
    push bx
; @0B0A4 0000:B0A4 original=e8290d runtime CFG evidence
    CALL_NEAR loc_0BDD0
; @0B0A7 0000:B0A7 original=5b runtime CFG evidence
    pop bx
; @0B0A8 0000:B0A8 original=730a runtime CFG evidence
    JAE_SHORT loc_0B0B4
; @0B0AA 0000:B0AA original=ff4602 runtime CFG evidence
    inc word ptr ss:[bp + 2]
; @0B0AD 0000:B0AD original=ff0638a4 runtime CFG evidence
    inc word ptr ds:[0A438h]
; @0B0B1 0000:B0B1 original=e97eff runtime CFG evidence
    JMP_NEAR loc_0B032
; @0B0B4 0000:B0B4 original=ff0e5a21 runtime CFG evidence
    dec word ptr ds:[0215Ah]
; @0B0B8 0000:B0B8 original=83265a210f runtime CFG evidence
    and word ptr ds:[0215Ah], 0Fh
; @0B0BD 0000:B0BD original=833e5a210f runtime CFG evidence
    cmp word ptr ds:[0215Ah], 0Fh
; @0B0C2 0000:B0C2 original=7401 runtime CFG evidence
    JE_SHORT loc_0B0C5
; @0B0C4 0000:B0C4 original=c3 runtime CFG evidence
    ret
; @0B0C5 0000:B0C5 original=83c20d runtime CFG evidence
    add dx, 0Dh
; @0B0C8 0000:B0C8 original=c3 runtime CFG evidence
    ret
; @0B0C9 0000:B0C9 original=e8b1ff runtime CFG evidence
    CALL_NEAR loc_0B07D
; @0B0CC 0000:B0CC original=8bda runtime CFG evidence
    mov bx, dx
; @0B0CE 0000:B0CE original=43 runtime CFG evidence
    inc bx
; @0B0CF 0000:B0CF original=e8899f runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B0D2 0000:B0D2 original=7403 runtime CFG evidence
    JE_SHORT loc_0B0D7
; @0B0D4 0000:B0D4 original=e95bff runtime CFG evidence
    JMP_NEAR loc_0B032
; @0B0D7 0000:B0D7 original=f7065a210f00 runtime CFG evidence
    test word ptr ds:[0215Ah], 0Fh
; @0B0DD 0000:B0DD original=740b runtime CFG evidence
    JE_SHORT loc_0B0EA
; @0B0DF 0000:B0DF original=83eb0d runtime CFG evidence
    sub bx, 0Dh
; @0B0E2 0000:B0E2 original=e8769f runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B0E5 0000:B0E5 original=7403 runtime CFG evidence
    JE_SHORT loc_0B0EA
; @0B0E7 0000:B0E7 original=e948ff runtime CFG evidence
    JMP_NEAR loc_0B032
; @0B0EA 0000:B0EA original=ff4604 runtime CFG evidence
    inc word ptr ss:[bp + 4]
; @0B0ED 0000:B0ED original=ff0636a4 runtime CFG evidence
    inc word ptr ds:[0A436h]
; @0B0F1 0000:B0F1 original=53 runtime CFG evidence
    push bx
; @0B0F2 0000:B0F2 original=e8db0c runtime CFG evidence
    CALL_NEAR loc_0BDD0
; @0B0F5 0000:B0F5 original=5b runtime CFG evidence
    pop bx
; @0B0F6 0000:B0F6 original=730a runtime CFG evidence
    JAE_SHORT loc_0B102
; @0B0F8 0000:B0F8 original=ff4e04 runtime CFG evidence
    dec word ptr ss:[bp + 4]
; @0B0FB 0000:B0FB original=ff0e36a4 runtime CFG evidence
    dec word ptr ds:[0A436h]
; @0B0FF 0000:B0FF original=e930ff runtime CFG evidence
    JMP_NEAR loc_0B032
; @0B102 0000:B102 original=f746040f00 runtime CFG evidence
    test word ptr ss:[bp + 4], 0Fh
; @0B107 0000:B107 original=7401 runtime CFG evidence
    JE_SHORT loc_0B10A
; @0B109 0000:B109 original=c3 runtime CFG evidence
    ret
; @0B10A 0000:B10A original=42 runtime CFG evidence
    inc dx
; @0B10B 0000:B10B original=c3 runtime CFG evidence
    ret
; @0B10C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,02Dh,0FFh
; @0B10F 0000:B10F original=8bda runtime CFG evidence
    mov bx, dx
; @0B111 0000:B111 original=f746040f00 runtime CFG evidence
    test word ptr ss:[bp + 4], 0Fh
; @0B116 0000:B116 original=751c runtime CFG evidence
    JNE_SHORT loc_0B134
; @0B118 0000:B118 original=4b runtime CFG evidence
    dec bx
; @0B119 0000:B119 original=e83f9f runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B11C 0000:B11C original=7403 runtime CFG evidence
    JE_SHORT loc_0B121
; @0B11E 0000:B11E original=e911ff runtime CFG evidence
    JMP_NEAR loc_0B032
; @0B121 0000:B121 original=f7065a210f00 runtime CFG evidence
    test word ptr ds:[0215Ah], 0Fh
; @0B127 0000:B127 original=740b runtime CFG evidence
    JE_SHORT loc_0B134
; @0B129 0000:B129 original=83eb0d runtime CFG evidence
    sub bx, 0Dh
; @0B12C 0000:B12C original=e82c9f runtime CFG evidence
    CALL_NEAR ReadIndexedByteAttribute_0505B
; @0B12F 0000:B12F original=7403 runtime CFG evidence
    JE_SHORT loc_0B134
; @0B131 0000:B131 original=e9fefe runtime CFG evidence
    JMP_NEAR loc_0B032
; @0B134 0000:B134 original=ff4e04 runtime CFG evidence
    dec word ptr ss:[bp + 4]
; @0B137 0000:B137 original=ff0e36a4 runtime CFG evidence
    dec word ptr ds:[0A436h]
; @0B13B 0000:B13B original=53 runtime CFG evidence
    push bx
; @0B13C 0000:B13C original=e8910c runtime CFG evidence
    CALL_NEAR loc_0BDD0
; @0B13F 0000:B13F original=5b runtime CFG evidence
    pop bx
; @0B140 0000:B140 original=730a runtime CFG evidence
    JAE_SHORT loc_0B14C
; @0B142 0000:B142 original=ff4604 runtime CFG evidence
    inc word ptr ss:[bp + 4]
; @0B145 0000:B145 original=ff0636a4 runtime CFG evidence
    inc word ptr ds:[0A436h]
; @0B149 0000:B149 original=e9e6fe runtime CFG evidence
    JMP_NEAR loc_0B032
; @0B14C 0000:B14C original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0B14F 0000:B14F original=250f00 runtime CFG evidence
    and ax, 0Fh
; @0B152 0000:B152 original=3d0f00 runtime CFG evidence
    cmp ax, 0Fh
; @0B155 0000:B155 original=7401 runtime CFG evidence
    JE_SHORT loc_0B158
; @0B157 0000:B157 original=c3 runtime CFG evidence
    ret
; @0B158 0000:B158 original=4a runtime CFG evidence
    dec dx
; @0B159 0000:B159 original=c3 runtime CFG evidence
    ret
; sub_0000_B15A
; @0B15A 0000:B15A original=b92300
    mov cx, 023h
; @0B15D 0000:B15D original=8b1e3aa4
    mov bx, word ptr ds:[0A43Ah]
; @0B161 0000:B161 original=81fb5c2b
    cmp bx, 02B5Ch
; @0B165 0000:B165 original=7333
    JAE_SHORT loc_0B19A
; @0B167 0000:B167 original=833f00
    cmp word ptr ds:[bx], 0
; @0B16A 0000:B16A original=7425
    JE_SHORT loc_0B191
; @0B16C 0000:B16C original=837f1801
    cmp word ptr ds:[bx + 018h], 1
; @0B170 0000:B170 original=741f
    JE_SHORT loc_0B191
; @0B172 0000:B172 original=837f1826
    cmp word ptr ds:[bx + 018h], 026h
; @0B176 0000:B176 original=7419
    JE_SHORT loc_0B191
; @0B178 0000:B178 original=837f1821
    cmp word ptr ds:[bx + 018h], 021h
; @0B17C 0000:B17C original=7413
    JE_SHORT loc_0B191
; @0B17E 0000:B17E original=837f1822
    cmp word ptr ds:[bx + 018h], 022h
; @0B182 0000:B182 original=740d
    JE_SHORT loc_0B191
; @0B184 0000:B184 original=817f02e000
    cmp word ptr ds:[bx + 2], 0E0h
; @0B189 0000:B189 original=7706
    JA_SHORT loc_0B191
; @0B18B 0000:B18B original=837f1604
    cmp word ptr ds:[bx + 016h], 4
; @0B18F 0000:B18F original=7415
    JE_SHORT loc_0B1A6
; @0B191 0000:B191 original=83c338
    add bx, 038h
; @0B194 0000:B194 original=e2cb
    LOOP_SHORT loc_0B161
; @0B196 0000:B196 original=bbffff
    mov bx, 0FFFFh
; @0B199 0000:B199 original=c3
    ret
; @0B19A 0000:B19A original=c7063aa4b423
    mov word ptr ds:[0A43Ah], 023B4h
; @0B1A0 0000:B1A0 original=8b1e3aa4
    mov bx, word ptr ds:[0A43Ah]
; @0B1A4 0000:B1A4 original=ebbb
    JMP_SHORT loc_0B161
; @0B1A6 0000:B1A6 original=53
    push bx
; @0B1A7 0000:B1A7 original=83c338
    add bx, 038h
; @0B1AA 0000:B1AA original=891e3aa4
    mov word ptr ds:[0A43Ah], bx
; @0B1AE 0000:B1AE original=5b
    pop bx
; @0B1AF 0000:B1AF original=c3
    ret
; @0B1B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,028h,023h,05h,06Dh,00h,089h,046h,08h,083h,07Eh,01Ch,01h,074h,068h,0A1h
; @0B1C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,023h,05h,0Ah,00h,0A3h,06h,023h,0A1h,080h,023h,05h,0Ch,00h,0A3h,04h
; @0B1D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,0C7h,06h,08h,023h,02h,00h,083h,026h,04h,023h,0FCh,083h,026h,06h,023h
; @0B1E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FCh,083h,066h,04h,0FCh,083h,066h,02h,0FCh,0E8h,0C6h,0ABh,083h,03Eh,0Ah,023h
; @0B1F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,075h,03h,0E9h,06Ah,0FBh,083h,03Eh,07Eh,0A9h,00h,074h,04h,0FFh,0Eh,07Eh
; @0B200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,0E8h,056h,0FFh,083h,0FBh,0FFh,075h,03h,0E9h,0BDh,0FBh,089h,05Eh,030h,0C7h
; @0B210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,01Ch,01h,00h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,011h
; @0B220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,06h,07Eh,0A9h,0E9h,039h,0FBh,08Bh,05Eh,030h,083h,03Fh,00h,074h,016h,081h
; @0B230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,02h,0DCh,00h,077h,0Fh,083h,07Fh,018h,01h,074h,09h,0E8h,0DCh,0ABh,0E8h
; @0B240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0ACh,0E9h,015h,0FBh,0C7h,046h,01Ch,00h,00h,0E9h,0Dh,0FBh
; @0B24D 0000:B24D original=e8f2ab runtime CFG evidence
    CALL_NEAR loc_05E42
; @0B250 0000:B250 original=837e1e01 runtime CFG evidence
    cmp word ptr ss:[bp + 01Eh], 1
; @0B254 0000:B254 original=744d runtime CFG evidence
    JE_SHORT loc_0B2A3
; @0B256 0000:B256 original=a17e23 runtime CFG evidence
    mov ax, word ptr ds:[0237Eh]
; @0B259 0000:B259 original=8b1e8023 runtime CFG evidence
    mov bx, word ptr ds:[02380h]
; @0B25D 0000:B25D original=2d0200 runtime CFG evidence
    sub ax, 2
; @0B260 0000:B260 original=394602 runtime CFG evidence
    cmp word ptr ss:[bp + 2], ax
; @0B263 0000:B263 original=7c3e runtime CFG evidence
    JL_SHORT loc_0B2A3
; @0B265 0000:B265 original=051400 runtime CFG evidence
    add ax, 014h
; @0B268 0000:B268 original=394602 runtime CFG evidence
    cmp word ptr ss:[bp + 2], ax
; @0B26B 0000:B26B original=7f36 runtime CFG evidence
    JG_SHORT loc_0B2A3
; @0B26D 0000:B26D original=395e04 runtime CFG evidence
    cmp word ptr ss:[bp + 4], bx
; @0B270 0000:B270 original=7231 runtime CFG evidence
    JB_SHORT loc_0B2A3
; @0B272 0000:B272 original=83c314 runtime CFG evidence
    add bx, 014h
; @0B275 0000:B275 original=395e04 runtime CFG evidence
    cmp word ptr ss:[bp + 4], bx
; @0B278 0000:B278 original=7729 runtime CFG evidence
    JA_SHORT loc_0B2A3
; @0B27A 0000:B27A original=b90100 runtime CFG evidence
    mov cx, 1
; @0B27D 0000:B27D original=837e1803 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 3
; @0B281 0000:B281 original=7514 runtime CFG evidence
    JNE_SHORT loc_0B297
; @0B283 0000:B283 original=833edcbe00 runtime CFG evidence
    cmp word ptr ds:[0BEDCh], 0
; @0B288 0000:B288 original=740d runtime CFG evidence
    JE_SHORT loc_0B297
; @0B28A 0000:B28A original=b90300 runtime CFG evidence
    mov cx, 3
; @0B28D 0000:B28D original=833edcbe01 runtime CFG evidence
    cmp word ptr ds:[0BEDCh], 1
; @0B292 0000:B292 original=7403 runtime CFG evidence
    JE_SHORT loc_0B297
; @0B294 0000:B294 original=b90500 runtime CFG evidence
    mov cx, 5
; @0B297 0000:B297 original=51 runtime CFG evidence
    push cx
; @0B298 0000:B298 original=55 runtime CFG evidence
    push bp
; @0B299 0000:B299 original=e87deb runtime CFG evidence
    CALL_NEAR loc_09E19
; @0B29C 0000:B29C original=5d runtime CFG evidence
    pop bp
; @0B29D 0000:B29D original=59 runtime CFG evidence
    pop cx
; @0B29E 0000:B29E original=e2f7 runtime CFG evidence
    LOOP_SHORT loc_0B297
; @0B2A0 0000:B2A0 original=e926fb runtime CFG evidence
    JMP_NEAR loc_0ADC9
; @0B2A3 0000:B2A3 original=e9b4fa runtime CFG evidence
    JMP_NEAR loc_0AD5A
; @0B2A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,03Ch,023h,05h,01Ch,00h,089h,046h,08h,083h,03Eh,02Ch,023h,01Fh,075h,03h
; @0B2B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,028h,08h,0E9h,047h,08h,0C7h,046h,036h,05Ch,0A4h,0EBh,05h,0C7h,046h,036h
; @0B2C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,0A4h,0C7h,046h,018h,012h,00h,08Bh,076h,036h,0ADh,05h,020h,00h,0A3h,06h
; @0B2D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,01h,00h,083h,03Eh,056h,023h,00h
; @0B2E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,083h,03Eh,0ACh,0BDh,01h,075h,06h,0C7h,06h,08h,023h,02h,00h,0E8h
; @0B2F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BAh,0AAh,083h,03Eh,0Ah,023h,00h,074h,05h,089h,076h,036h,0EBh,0C9h,08Bh,046h
; @0B306 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,05h,03Bh,00h,089h,046h,08h,083h,03Eh,0ACh,0BDh,01h,075h,03h,0E9h,034h
; @0B316 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,083h,03Eh,056h,023h,05h,074h,0Eh,083h,03Eh,056h,023h,06h,074h,07h,083h
; @0B326 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,056h,023h,00h,075h,031h,08Bh,046h,06h,05h,015h,01h,089h,046h,08h,081h
; @0B336 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,050h,023h,052h,0Eh,074h,03h,0E9h,0Bh,09h,08Bh,046h,06h,05h,05h,01h
; @0B346 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,083h,03Eh,056h,023h,00h,075h,03h,0E9h,0F8h,08h,083h,03Eh,056h
; @0B356 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,06h,075h,03h,0E9h,0EEh,08h,08Bh,046h,06h,05h,02Ah,00h,089h,046h,08h
; @0B366 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,01h,075h,03h,0E9h,0DBh,08h,08Bh,046h,06h,05h,0D2h,00h
; @0B376 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,083h,03Eh,056h,023h,02h,075h,03h,0E9h,0C8h,08h,08Bh,046h,06h
; @0B386 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,0ECh,00h,089h,046h,08h,083h,03Eh,056h,023h,03h,075h,03h,0E9h,0B5h,08h
; @0B396 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,07h,075h,03h,0E9h,0ABh,08h,08Bh,046h,06h,05h,0ECh,00h
; @0B3A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,083h,03Eh,056h,023h,04h,075h,03h,0E9h,098h,08h,08Bh,046h,06h
; @0B3B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,0ECh,00h,089h,046h,08h,0E9h,08Ch,08h,0A1h,042h,023h,040h,0D1h,0E8h,05h
; @0B3C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 071h,00h,089h,046h,08h,0C3h,0E8h,0F0h,0FFh,083h,046h,02h,02h,081h,07Eh,02h
; @0B3D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,073h,03h,0E9h,068h,08h,0EBh,01Ah,0E8h,0DDh,0FFh,0FFh,046h,02h,083h
; @0B3E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,056h,023h,00h,075h,03h,0FFh,046h,02h,081h,07Eh,02h,0A0h,00h,073h,03h
; @0B3F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,04Ch,08h,0E8h,0CBh,0Bh,0E8h,03h,00h,0E9h,043h,08h,0BAh,0Ch,00h,083h
; @0B406 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,014h,02h,074h,03h,0BAh,04h,00h,08Bh,046h,04h,03h,0C2h,0A3h,0B2h,0A8h
; @0B416 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,02h,03h,0C2h,0A3h,0B4h,0A8h,0B9h,08h,00h,051h,0E8h,04Eh,0C1h,059h
; @0B426 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FBh,0FFh,074h,03Ch,051h,049h,089h,04Fh,06h,083h,0C1h,08h,089h,04Fh,08h
; @0B436 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,0B2h,0A8h,089h,047h,04h,0A1h,0B4h,0A8h,089h,047h,02h,0C7h,07h,01h,00h
; @0B446 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,01Eh,00h,00h,0C7h,047h,0Ah,01h,00h,0C7h,047h,014h,00h,00h,0C7h
; @0B456 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,016h,02h,00h,0C7h,047h,018h,03h,00h,0C7h,047h,01Ch,0FFh,0FFh,059h,0E2h
; @0B466 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BAh,0C3h,055h,0B9h,023h,00h,033h,0C0h,051h,050h,08Bh,0D9h,0D1h,0E3h,08Bh,0AFh
; @0B476 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CAh,032h,058h,083h,07Eh,00h,00h,074h,07h,083h,07Eh,016h,04h,075h,01h,040h
; @0B486 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 059h,0E2h,0E5h,05Dh,0C3h,083h,03Eh,0A0h,0A7h,032h,073h,03h,0E9h,080h,01h,083h
; @0B496 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0A0h,0A7h,05Ah,073h,03h,0E9h,0ACh,07h,0E9h,036h,01h,0E8h,0C3h,0FFh,03Dh
; @0B4A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,074h,03h,0E9h,09Eh,07h,0C7h,06h,0B6h,0A8h,00h,00h,0C7h,06h,0B8h
; @0B4B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A8h,00h,00h,0C7h,06h,0C2h,0A8h,01h,00h,0C7h,06h,0C4h,0A8h,0D4h,0D2h,0C7h
; @0B4C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,018h,078h,00h,0C7h,046h,08h,022h,00h,0C7h,046h,020h,0C8h,00h,0C7h,046h
; @0B4D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,00h,0C7h,046h,02h,00h,00h,0C7h,046h,014h,02h,00h,0C7h,046h,028h
; @0B4E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,089h,02Eh,0BEh,0A8h,0E8h,035h,0C0h,083h,0FBh,0FFh,074h,056h,09Ah,089h
; @0B4F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,07Fh,0Fh,0C7h,047h,018h,076h,00h,0C7h,047h,08h,020h,00h,089h,01Eh,0BAh
; @0B506 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A8h,0E8h,01Ah,0C0h,083h,0FBh,0FFh,074h,03Bh,09Ah,089h,08h,07Fh,0Fh,0C7h,047h
; @0B516 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,077h,00h,0C7h,047h,08h,021h,00h,0C7h,047h,04h,020h,00h,089h,01Eh,0BCh
; @0B526 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A8h,0E8h,0FAh,0BFh,083h,0FBh,0FFh,074h,01Bh,09Ah,089h,08h,07Fh,0Fh,0C7h,047h
; @0B536 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,079h,00h,0C7h,047h,08h,023h,00h,0C7h,047h,04h,020h,00h,089h,01Eh,0C0h
; @0B546 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A8h,0E9h,01h,07h,0C7h,06h,07Eh,0A4h,00h,00h,0E8h,057h,0ADh,0E9h,0F5h,06h
; @0B556 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,04h,075h,03h,0E9h,023h,0D8h,083h,03Eh,056h,023h,03h,075h
; @0B566 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,021h,0FFh,083h,03Eh,056h,023h,00h,075h,03h,0E9h,02Eh,0FFh,081h,03Eh
; @0B576 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,0A7h,0C8h,00h,073h,03h,0E9h,096h,00h,081h,03Eh,0A0h,0A7h,0F0h,00h,073h
; @0B586 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0C1h,06h,0C7h,046h,018h,022h,00h,0C7h,046h,08h,071h,00h,08Bh,0Eh
; @0B596 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 056h,023h,041h,0B8h,0Ah,00h,0F7h,0E1h,089h,046h,020h,0C7h,046h,04h,060h,00h
; @0B5A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0A2h,06h
; sub_0000_B5A9
; @0B5A9 0000:B5A9 original=c706d0a8d2a8
    mov word ptr ds:[0A8D0h], 0A8D2h
; @0B5AF 0000:B5AF original=c706c8a80000
    mov word ptr ds:[0A8C8h], 0
; @0B5B5 0000:B5B5 original=c706cca80000
    mov word ptr ds:[0A8CCh], 0
; @0B5BB 0000:B5BB original=c3
    ret
; @0B5BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0Eh,07Eh,0A4h,0C7h,046h,018h,064h,00h,0A1h,080h,023h,089h,046h,04h,0C7h
; @0B5CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,00h,00h,0C7h,046h,08h,08Eh,00h,0E9h,06Dh,06h,0C7h,06h,0CEh,0A8h
; @0B5DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,081h,03Eh,0D0h,0A8h,032h,0A9h,074h,0D6h,08Bh,036h,0D0h,0A8h,056h,0E8h
; @0B5EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0CCh,05Eh,083h,0FBh,0FFh,074h,01Eh,0ADh,05h,020h,00h,089h,047h,034h,0ADh
; @0B5FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,047h,032h,0C7h,047h,018h,061h,00h,0C7h,047h,08h,0E7h,00h,0FFh,06h,07Eh
; @0B60C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,06h,0D0h,0A8h,04h,0E9h,036h,06h,083h,03Eh,028h,023h,07h,074h,03h
; @0B61C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,02Ch,06h,0E8h,0C7h,0CBh,083h,0FBh,0FFh,075h,03h,0E9h,021h,06h,0E8h,046h
; @0B62C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,034h,010h,00h,0C7h,047h,018h,023h,00h,083h,03Eh,056h,023h,01h
; @0B63C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,020h,083h,03Eh,056h,023h,02h,074h,011h,083h,03Eh,056h,023h,03h,074h,012h
; @0B64C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,05h,074h,0Bh,0E9h,0F5h,05h,0C7h,047h,020h,01h,00h,0E9h
; @0B65C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EDh,05h,0C7h,047h,020h,0FFh,0FFh,0A1h,040h,023h,0FFh,06h,040h,023h,025h,03h
; @0B66C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,089h,047h,01Ch,0E9h,0D8h,05h,08Bh,036h,094h,0A8h,081h,0FEh,0B2h,0A8h,072h
; @0B67C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ah,0C7h,06h,094h,0A8h,096h,0A8h,08Bh,036h,094h,0A8h,0ADh,089h,047h,032h,089h
; @0B68C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 036h,094h,0A8h,0C3h,08Bh,046h,04h,03Bh,046h,032h,074h,03h,0E9h,0C1h,01h,08Bh
; @0B69C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,03Bh,046h,034h,074h,03h,0E9h,0B6h,01h,083h,07Eh,02h,020h,077h,012h
; @0B6AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,02h,01Ch,072h,0Ch,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh
; @0B6BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BEh,01Dh,083h,03Eh,056h,023h,02h,074h,03Ch,08Bh,076h,01Ch,0D1h,0E6h,0D1h,0E6h
; @0B6CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,032h,0A9h,033h,0C9h,0BAh,080h,00h,083h,03Eh,056h,023h,03h,074h,07h,083h
; @0B6DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,056h,023h,05h,075h,07h,0B8h,042h,0A9h,041h,0BAh,06Dh,00h,03h,0F0h,0ADh
; @0B6EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0D8h,08Bh,07h,0D3h,0E8h,03h,0C2h,089h,046h,08h,0ADh,01h,046h,02h,01h
; @0B6FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,034h,0E9h,04Ah,05h,08Bh,0DDh,0E8h,0DCh,0BDh,0C7h,046h,018h,02Ch,00h,0E9h
; @0B70C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Dh,05h,0A1h,03Ch,023h,05h,0B9h,00h,089h,046h,08h,0C7h,06h,012h,023h,02h
; @0B71C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E8h,022h,0A7h,0C7h,06h,012h,023h,03h,00h,0E9h,022h,05h
; @0B729 0000:B729 original=8b4632 runtime CFG evidence
    mov ax, word ptr ss:[bp + 032h]
; @0B72C 0000:B72C original=a30423 runtime CFG evidence
    mov word ptr ds:[02304h], ax
; @0B72F 0000:B72F original=8b4634 runtime CFG evidence
    mov ax, word ptr ss:[bp + 034h]
; @0B732 0000:B732 original=a30623 runtime CFG evidence
    mov word ptr ds:[02306h], ax
; @0B735 0000:B735 original=e87aa6 runtime CFG evidence
    CALL_NEAR loc_05DB2
; @0B738 0000:B738 original=833e0a2300 runtime CFG evidence
    cmp word ptr ds:[0230Ah], 0
; @0B73D 0000:B73D original=c3 runtime CFG evidence
    ret
; @0B73E 0000:B73E original=837e1cff runtime CFG evidence
    cmp word ptr ss:[bp + 01Ch], -1
; @0B742 0000:B742 original=744d runtime CFG evidence
    JE_SHORT loc_0B791
; @0B744 0000:B744 original=8b5e1c runtime CFG evidence
    mov bx, word ptr ss:[bp + 01Ch]
; @0B747 0000:B747 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0B749 0000:B749 original=2effa74eb7 runtime CFG evidence
    jmp word ptr cs:[bx - 048B2h]
; @0B74E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,0B7h,070h,0B7h,07Bh,0B7h
; @0B754 0000:B754 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0B757 0000:B757 original=3b4632 runtime CFG evidence
    cmp ax, word ptr ss:[bp + 032h]
; @0B75A 0000:B75A original=7403 runtime CFG evidence
    JE_SHORT loc_0B75F
; @0B75C 0000:B75C original=e9fd00 runtime CFG evidence
    JMP_NEAR loc_0B85C
; @0B75F 0000:B75F original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0B762 0000:B762 original=3b4634 runtime CFG evidence
    cmp ax, word ptr ss:[bp + 034h]
; @0B765 0000:B765 original=7403 runtime CFG evidence
    JE_SHORT loc_0B76A
; @0B767 0000:B767 original=e9f200 runtime CFG evidence
    JMP_NEAR loc_0B85C
; @0B76A 0000:B76A original=ff461c runtime CFG evidence
    inc word ptr ss:[bp + 01Ch]
; @0B76D 0000:B76D original=e9db04 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B770 0000:B770 original=c746087900 runtime CFG evidence
    mov word ptr ss:[bp + 8], 079h
; @0B775 0000:B775 original=ff461c runtime CFG evidence
    inc word ptr ss:[bp + 01Ch]
; @0B778 0000:B778 original=e9d004 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B77B 0000:B77B original=83460204 runtime CFG evidence
    add word ptr ss:[bp + 2], 4
; @0B77F 0000:B77F original=817e02a000 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 0A0h
; @0B784 0000:B784 original=7303 runtime CFG evidence
    JAE_SHORT loc_0B789
; @0B786 0000:B786 original=e9c204 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B789 0000:B789 original=c746087700 runtime CFG evidence
    mov word ptr ss:[bp + 8], 077h
; @0B78E 0000:B78E original=e9ba04 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B791 0000:B791 original=a13823 runtime CFG evidence
    mov ax, word ptr ds:[02338h]
; @0B794 0000:B794 original=837e0460 runtime CFG evidence
    cmp word ptr ss:[bp + 4], 060h
; @0B798 0000:B798 original=7307 runtime CFG evidence
    JAE_SHORT loc_0B7A1
; @0B79A 0000:B79A original=f7d8 runtime CFG evidence
    neg ax
; @0B79C 0000:B79C original=057f00 runtime CFG evidence
    add ax, 07Fh
; @0B79F 0000:B79F original=eb03 runtime CFG evidence
    JMP_SHORT loc_0B7A4
; @0B7A1 0000:B7A1 original=057a00 runtime CFG evidence
    add ax, 07Ah
; @0B7A4 0000:B7A4 original=894608 runtime CFG evidence
    mov word ptr ss:[bp + 8], ax
; @0B7A7 0000:B7A7 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0B7AA 0000:B7AA original=3b4632 runtime CFG evidence
    cmp ax, word ptr ss:[bp + 032h]
; @0B7AD 0000:B7AD original=7403 runtime CFG evidence
    JE_SHORT loc_0B7B2
; @0B7AF 0000:B7AF original=e9aa00 runtime CFG evidence
    JMP_NEAR loc_0B85C
; @0B7B2 0000:B7B2 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0B7B5 0000:B7B5 original=3b4634 runtime CFG evidence
    cmp ax, word ptr ss:[bp + 034h]
; @0B7B8 0000:B7B8 original=7403 runtime CFG evidence
    JE_SHORT loc_0B7BD
; @0B7BA 0000:B7BA original=e99f00 runtime CFG evidence
    JMP_NEAR loc_0B85C
; @0B7BD 0000:B7BD original=833ea0a723 runtime CFG evidence
    cmp word ptr ds:[0A7A0h], 023h
; @0B7C2 0000:B7C2 original=732f runtime CFG evidence
    JAE_SHORT loc_0B7F3
; @0B7C4 0000:B7C4 original=e98404 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B7C7 0000:B7C7 original=833e242301 runtime CFG evidence
    cmp word ptr ds:[02324h], 1
; @0B7CC 0000:B7CC original=7409 runtime CFG evidence
    JE_SHORT loc_0B7D7
; @0B7CE 0000:B7CE original=a18023 runtime CFG evidence
    mov ax, word ptr ds:[02380h]
; @0B7D1 0000:B7D1 original=050800 runtime CFG evidence
    add ax, 8
; @0B7D4 0000:B7D4 original=894632 runtime CFG evidence
    mov word ptr ss:[bp + 032h], ax
; @0B7D7 0000:B7D7 original=836632f8 runtime CFG evidence
    and word ptr ss:[bp + 032h], 0FFF8h
; @0B7DB 0000:B7DB original=c70640232800 runtime CFG evidence
    mov word ptr ds:[02340h], 028h
; @0B7E1 0000:B7E1 original=c7461c0000 runtime CFG evidence
    mov word ptr ss:[bp + 01Ch], 0
; @0B7E6 0000:B7E6 original=c746087800 runtime CFG evidence
    mov word ptr ss:[bp + 8], 078h
; @0B7EB 0000:B7EB original=c746342000 runtime CFG evidence
    mov word ptr ss:[bp + 034h], 020h
; @0B7F0 0000:B7F0 original=e95804 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B7F3 0000:B7F3 original=813e4023bc02 runtime CFG evidence
    cmp word ptr ds:[02340h], 02BCh
; @0B7F9 0000:B7F9 original=7213 runtime CFG evidence
    JB_SHORT loc_0B80E
; @0B7FB 0000:B7FB original=813e4023d002 runtime CFG evidence
    cmp word ptr ds:[02340h], 02D0h
; @0B801 0000:B801 original=770b runtime CFG evidence
    JA_SHORT loc_0B80E
; @0B803 0000:B803 original=e88f95 runtime CFG evidence
    CALL_NEAR loc_04D95
; @0B806 0000:B806 original=83e301 runtime CFG evidence
    and bx, 1
; @0B809 0000:B809 original=7503 runtime CFG evidence
    JNE_SHORT loc_0B80E
; @0B80B 0000:B80B original=e868bc runtime CFG evidence
    CALL_NEAR loc_07476
; @0B80E 0000:B80E original=833e7ea403 runtime CFG evidence
    cmp word ptr ds:[0A47Eh], 3
; @0B813 0000:B813 original=76b2 runtime CFG evidence
    JBE_SHORT loc_0B7C7
; @0B815 0000:B815 original=833e402305 runtime CFG evidence
    cmp word ptr ds:[02340h], 5
; @0B81A 0000:B81A original=72b2 runtime CFG evidence
    JB_SHORT loc_0B7CE
; @0B81C 0000:B81C original=833e2e233f runtime CFG evidence
    cmp word ptr ds:[0232Eh], 03Fh
; @0B821 0000:B821 original=7403 runtime CFG evidence
    JE_SHORT loc_0B826
; @0B823 0000:B823 original=e92504 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B826 0000:B826 original=8b3642a8 runtime CFG evidence
    mov si, word ptr ds:[0A842h]
; @0B82A 0000:B82A original=81fe94a8 runtime CFG evidence
    cmp si, 0A894h
; @0B82E 0000:B82E original=720a runtime CFG evidence
    JB_SHORT loc_0B83A
; @0B830 0000:B830 original=c70642a844a8 runtime CFG evidence
    mov word ptr ds:[0A842h], 0A844h
; @0B836 0000:B836 original=8b3642a8 runtime CFG evidence
    mov si, word ptr ds:[0A842h]
; @0B83A 0000:B83A original=ad runtime CFG evidence
    lodsw
; @0B83B 0000:B83B original=052000 runtime CFG evidence
    add ax, 020h
; @0B83E 0000:B83E original=894634 runtime CFG evidence
    mov word ptr ss:[bp + 034h], ax
; @0B841 0000:B841 original=ad runtime CFG evidence
    lodsw
; @0B842 0000:B842 original=894632 runtime CFG evidence
    mov word ptr ss:[bp + 032h], ax
; @0B845 0000:B845 original=893642a8 runtime CFG evidence
    mov word ptr ds:[0A842h], si
; @0B849 0000:B849 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0B84C 0000:B84C original=3b4634 runtime CFG evidence
    cmp ax, word ptr ss:[bp + 034h]
; @0B84F 0000:B84F original=7508 runtime CFG evidence
    JNE_SHORT loc_0B859
; @0B851 0000:B851 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0B854 0000:B854 original=3b4632 runtime CFG evidence
    cmp ax, word ptr ss:[bp + 032h]
; @0B857 0000:B857 original=74cd runtime CFG evidence
    JE_SHORT loc_0B826
; @0B859 0000:B859 original=e9ef03 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B85C 0000:B85C original=c70608230200 runtime CFG evidence
    mov word ptr ds:[02308h], 2
; @0B862 0000:B862 original=e8c4fe runtime CFG evidence
    CALL_NEAR loc_0B729
; @0B865 0000:B865 original=c746060400 runtime CFG evidence
    mov word ptr ss:[bp + 6], 4
; @0B86A 0000:B86A original=e9de03 runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @0B86D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,07Eh,0A4h,02h,077h,03h,0E9h,081h,00h,081h,07Eh,02h,0C0h,00h,077h
; @0B87D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ah,083h,03Eh,0A0h,0A7h,028h,073h,02Bh,0C7h,06h,08h,023h,01h,00h,0C7h,046h
; @0B88D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,075h,00h,083h,066h,032h,0FEh,083h,066h,04h,0FEh,083h,066h,034h,0FEh,083h
; @0B89D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,02h,0FEh,0E8h,086h,0FEh,075h,03h,0E9h,0A3h,03h,0C7h,046h,06h,04h,00h
; @0B8AD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,09Bh,03h,081h,03Eh,040h,023h,0EFh,02h,075h,03h,0E8h,0BBh,0BBh,081h,03Eh
; @0B8BD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,023h,059h,01h,075h,03h,0E8h,0B0h,0BBh,083h,03Eh,040h,023h,079h,075h,03h
; @0B8CD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0A6h,0BBh,0A1h,042h,023h,0F7h,0D8h,01h,046h,02h,0B8h,075h,00h,083h,03Eh
; @0B8DD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 042h,023h,0FFh,074h,03h,0B8h,076h,00h,089h,046h,08h,083h,03Eh,028h,023h,07h
; @0B8ED UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,059h,03h,0FFh,046h,02h,0E9h,053h,03h,0BBh,07Ch,023h,0E8h,01Dh
; @0B8FD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,0E8h,041h,0A5h,0C7h,046h,08h,076h,00h,0E9h,042h,03h,0C7h,06h,08h,023h
; @0B90D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,0E8h,017h,0FEh,075h,03h,0E9h,034h,03h,0E8h,05Ch,0BBh,083h,07Eh,032h
; @0B91D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,08h,0C7h,046h,032h,00h,00h,0E9h,023h,03h,0C7h,046h,032h,0C0h,00h
; @0B92D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,01Bh,03h,0C7h,06h,08h,023h,01h,00h,083h,03Eh,056h,023h,00h,075h,06h
; @0B93D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,08h,023h,02h,00h,0E8h,0E3h,0FDh,09Ch,08Bh,046h,06h,05h,0Dh,01h
; @0B94D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,09Dh,075h,03h,0E9h,0F5h,02h,083h,07Eh,01Ch,00h,074h,01Eh,0FFh
; @0B95D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,01Ch,074h,03h,0E9h,0E7h,02h,0C7h,046h,034h,020h,00h,083h,07Eh,018h,016h
; @0B96D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,0D9h,02h,0C7h,046h,034h,040h,00h,0E9h,0D1h,02h,083h,03Eh,0A0h
; @0B97D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A7h,031h,074h,03h,0E9h,0C7h,02h,0C7h,046h,018h,018h,00h,0E9h,0BFh,02h,0A1h
; @0B98D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,023h,025h,0FFh,03h,03Dh,0Ch,00h,075h,07h,0E8h,0DCh,0BAh,0FFh,06h,040h
; @0B99D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,08Bh,076h,036h,0ADh,03Dh,0FFh,0FFh,074h,043h,05h,020h,00h,0A3h,06h,023h
; @0B9AD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,03h,00h,0E8h,0F8h,0A3h,08Bh,046h,06h
; @0B9BD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,0Dh,01h,089h,046h,08h,083h,03Eh,0Ah,023h,00h,075h,03h,0E9h,07Eh,02h
; @0B9CD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,076h,036h,0E8h,0C2h,093h,083h,0E3h,07h,083h,0FBh,02h,075h,0B1h,0E8h,059h
; @0B9DD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,083h,0FBh,0FFh,074h,0A9h,0C7h,047h,06h,04h,00h,0EBh,0A2h,0ADh,089h,046h
; @0B9ED UNKNOWN bootstrap bytes: not reconstructed code/data
    db 036h,0EBh,09Ch,081h,03Eh,082h,0A4h,0E4h,0A4h,075h,06Fh,081h,03Eh,040h,023h,0EFh
; @0B9FD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,075h,07h,0E8h,073h,0BAh,0FFh,06h,040h,023h,0A1h,042h,023h,01h,046h,032h
; @0BA0D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,046h,023h,01h,046h,034h,081h,07Eh,034h,0D0h,00h,076h,05h,0C7h,046h,034h
; @0BA1D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,08Bh,046h,04h,03h,06h,042h,023h,03Bh,046h,032h,075h,06Eh,08Bh,046h
; @0BA2D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,03Bh,046h,034h,075h,066h,083h,03Eh,07Eh,0A4h,06h,072h,020h,0A1h,040h,023h
; @0BA3D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,0DCh,0BEh,02h,074h,0Ah,025h,0FFh,00h,03Dh,0FFh,00h,075h,01Bh,0EBh
; @0BA4D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,025h,07Fh,00h,03Dh,07Fh,00h,075h,011h,0FFh,06h,040h,023h,0BBh,07Ch,023h
; @0BA5D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0BBh,0A3h,0E8h,0DFh,0A3h,083h,046h,02h,02h,0A1h,03Ch,023h,05h,01Ch,00h
; @0BA6D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,0E9h,0D8h,01h,08Bh,046h,032h,025h,0FEh,0FFh,083h,066h,04h,0FEh
; @0BA7D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A3h,04h,023h,08Bh,046h,034h,025h,0FEh,0FFh,083h,066h,02h,0FEh,0A3h,06h,023h
; @0BA8D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,08h,023h,01h,00h,0E8h,01Ch,0A3h,0E9h,0B2h,01h,08Bh,046h,02h,03Bh
; @0BA9D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,034h,076h,0D2h,0E8h,09Eh,0A3h,083h,03Eh,07Eh,0A4h,06h,073h,0Ah,083h,03Eh
; @0BAAD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,023h,03Fh,075h,03h,0E8h,0C1h,0B9h,081h,07Eh,02h,0D0h,00h,077h,03h,0E9h
; @0BABD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ch,01h,0C7h,046h,02h,010h,00h,0E9h,084h,01h,0A1h,038h,023h,0D1h,0E8h,05h
; @0BACD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 027h,00h,089h,046h,08h,0EBh,0Bh,0A1h,038h,023h,0D1h,0E8h,05h,024h,00h,089h
; @0BADD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,0EBh,022h
; @0BAE1 0000:BAE1 original=ff7606 runtime CFG evidence
    push word ptr ss:[bp + 6]
; @0BAE4 0000:BAE4 original=c746060400 runtime CFG evidence
    mov word ptr ss:[bp + 6], 4
; @0BAE9 0000:BAE9 original=e84b07 runtime CFG evidence
    CALL_NEAR loc_0C237
; @0BAEC 0000:BAEC original=8f4606 runtime CFG evidence
    pop word ptr ss:[bp + 6]
; @0BAEF 0000:BAEF original=c3 runtime CFG evidence
    ret
; @0BAF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,03Ah,023h,05h,036h,00h,089h,046h,08h,083h,03Eh,02Eh,023h,03Fh,075h,03h
; @0BB00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0DEh,0FFh,083h,07Eh,06h,06h,075h,01Bh,0C7h,046h,06h,06h,00h,083h,07Eh
; @0BB10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,074h,08h,0E8h,0C1h,0F4h,075h,03h,0E9h,029h,01h,0C7h,046h,06h,02h
; @0BB20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E9h,021h,01h,0C7h,046h,06h,02h,00h,081h,07Eh,04h,0C0h,00h,074h,08h
; @0BB30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0A5h,0F4h,075h,03h,0E9h,0Dh,01h,0C7h,046h,06h,06h,00h,0E9h,05h,01h
; @0BB40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,052h,0A9h,0FFh,0FFh,0EBh,06h,0C7h,06h,052h,0A9h,01h,00h,0E8h,09Ch
; @0BB50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0BBh,00h,00h,074h,0Ah,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h
; @0BB60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,03Ah,01h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h
; @0BB70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,033h,0C9h,083h,07Eh,06h,00h,074h,03h,0B9h,03h,00h,03h,0C1h,0EBh,032h
; @0BB80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,052h,0A9h,0FFh,0FFh,0EBh,06h,0C7h,06h,052h,0A9h,01h,00h,0E8h,05Ch
; @0BB90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0BBh,00h,00h,074h,04h,08Bh,01Eh,03Ch,023h,0B8h,061h,00h,03h,06h,052h
; @0BBA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,0C3h,03h
; @0BBB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,089h,046h,08h,083h,03Eh,030h,023h,07Fh,074h,0Eh,083h,03Eh,030h,023h
; @0BBC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Bh,074h,07h,083h,03Eh,030h,023h,057h,075h,07Bh,0E8h,0A9h,0B8h,083h,0FBh,0FFh
; @0BBD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,073h,0C7h,047h,08h,03h,00h,083h,06Fh,04h,08h,083h,06Fh,02h,08h,0EBh
; @0BBE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,0C7h,06h,030h,0A4h,01h,00h,083h,03Eh,030h,0A4h,01h,0C3h,0C7h,06h,030h
; @0BBF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,00h,00h,0C7h,046h,06h,00h,00h,0FFh,076h,02h,0A1h,078h,0A2h,01h,046h
; @0BC00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,083h,06Eh,02h,010h,0E8h,06Bh,094h,08Fh,046h,02h,083h,0FBh,0FFh,074h,0D1h
; @0BC10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,02h,03Bh,06h,07Eh,023h,07Ch,012h,03h,01Eh,052h,0A9h,0E8h,03Bh,094h
; @0BC20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,0BFh,0E8h,0B3h,0F3h,083h,03Eh,030h,0A4h,01h,0C3h,0C7h,046h,06h,04h,00h
; @0BC30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,01Eh,052h,0A9h,083h,0EBh,0Dh,0E8h,021h,094h,074h,0A5h,0E8h,099h,0F3h,083h
; @0BC40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,030h,0A4h,01h,0C3h
; @0BC45 0000:BC45 original=a178a2 runtime CFG evidence
    mov ax, word ptr ds:[0A278h]
; @0BC48 0000:BC48 original=014602 runtime CFG evidence
    add word ptr ss:[bp + 2], ax
; @0BC4B 0000:BC4B original=e86300 runtime CFG evidence
    CALL_NEAR loc_0BCB1
; @0BC4E 0000:BC4E original=833e7ca400 runtime CFG evidence
    cmp word ptr ds:[0A47Ch], 0
; @0BC53 0000:BC53 original=7541 runtime CFG evidence
    JNE_SHORT loc_0BC96
; @0BC55 0000:BC55 original=837e1800 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 0
; @0BC59 0000:BC59 original=743b runtime CFG evidence
    JE_SHORT loc_0BC96
; @0BC5B 0000:BC5B original=837e1848 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 048h
; @0BC5F 0000:BC5F original=7435 runtime CFG evidence
    JE_SHORT loc_0BC96
; @0BC61 0000:BC61 original=837e1826 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 026h
; @0BC65 0000:BC65 original=742f runtime CFG evidence
    JE_SHORT loc_0BC96
; @0BC67 0000:BC67 original=817e188600 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 086h
; @0BC6C 0000:BC6C original=7428 runtime CFG evidence
    JE_SHORT loc_0BC96
; @0BC6E 0000:BC6E original=837e1828 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 028h
; @0BC72 0000:BC72 original=7422 runtime CFG evidence
    JE_SHORT loc_0BC96
; @0BC74 0000:BC74 original=837e1829 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 029h
; @0BC78 0000:BC78 original=741c runtime CFG evidence
    JE_SHORT loc_0BC96
; @0BC7A 0000:BC7A original=837e1834 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 034h
; @0BC7E 0000:BC7E original=7416 runtime CFG evidence
    JE_SHORT loc_0BC96
; @0BC80 0000:BC80 original=817e0240ff runtime CFG evidence
    cmp word ptr ss:[bp + 2], 0FF40h
; @0BC85 0000:BC85 original=7d03 runtime CFG evidence
    JGE_SHORT loc_0BC8A
; @0BC87 0000:BC87 original=e98d00 runtime CFG evidence
    JMP_NEAR loc_0BD17
; @0BC8A 0000:BC8A original=817e02f000 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 0F0h
; @0BC8F 0000:BC8F original=7c03 runtime CFG evidence
    JL_SHORT loc_0BC94
; @0BC91 0000:BC91 original=e98300 runtime CFG evidence
    JMP_NEAR loc_0BD17
; @0BC94 0000:BC94 original=eb0d runtime CFG evidence
    JMP_SHORT loc_0BCA3
; @0BC96 0000:BC96 original=837e02ec runtime CFG evidence
    cmp word ptr ss:[bp + 2], -014h
; @0BC9A 0000:BC9A original=7c7b runtime CFG evidence
    JL_SHORT loc_0BD17
; @0BC9C 0000:BC9C original=817e02f000 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 0F0h
; @0BCA1 0000:BCA1 original=7d74 runtime CFG evidence
    JGE_SHORT loc_0BD17
; @0BCA3 0000:BCA3 original=833e7ca400 runtime CFG evidence
    cmp word ptr ds:[0A47Ch], 0
; @0BCA8 0000:BCA8 original=7506 runtime CFG evidence
    JNE_SHORT loc_0BCB0
; @0BCAA 0000:BCAA original=e81e00 runtime CFG evidence
    CALL_NEAR loc_0BCCB
; @0BCAD 0000:BCAD original=e846a6 runtime CFG evidence
    CALL_NEAR loc_062F6
; @0BCB0 0000:BCB0 original=c3 runtime CFG evidence
    ret
; sub_0000_BCB1
; @0BCB1 0000:BCB1 original=817e04c000
    cmp word ptr ss:[bp + 4], 0C0h
; @0BCB6 0000:BCB6 original=7f07
    JG_SHORT loc_0BCBF
; @0BCB8 0000:BCB8 original=837e0400
    cmp word ptr ss:[bp + 4], 0
; @0BCBC 0000:BCBC original=7c07
    JL_SHORT loc_0BCC5
; @0BCBE 0000:BCBE original=c3
    ret
; @0BCBF 0000:BCBF original=c74604c000
    mov word ptr ss:[bp + 4], 0C0h
; @0BCC4 0000:BCC4 original=c3
    ret
; @0BCC5 0000:BCC5 original=c746040000
    mov word ptr ss:[bp + 4], 0
; @0BCCA 0000:BCCA original=c3
    ret
; @0BCCB 0000:BCCB original=837e0000 runtime CFG evidence
    cmp word ptr ss:[bp], 0
; @0BCCF 0000:BCCF original=7501 runtime CFG evidence
    JNE_SHORT loc_0BCD2
; @0BCD1 0000:BCD1 original=c3 runtime CFG evidence
    ret
; @0BCD2 0000:BCD2 original=837e1605 runtime CFG evidence
    cmp word ptr ss:[bp + 016h], 5
; @0BCD6 0000:BCD6 original=7501 runtime CFG evidence
    JNE_SHORT loc_0BCD9
; @0BCD8 0000:BCD8 original=c3 runtime CFG evidence
    ret
; @0BCD9 0000:BCD9 original=837e1800 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 0
; @0BCDD 0000:BCDD original=7501 runtime CFG evidence
    JNE_SHORT loc_0BCE0
; @0BCDF 0000:BCDF original=c3 runtime CFG evidence
    ret
; @0BCE0 0000:BCE0 original=837e1801 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 1
; @0BCE4 0000:BCE4 original=7501 runtime CFG evidence
    JNE_SHORT loc_0BCE7
; @0BCE6 0000:BCE6 original=c3 runtime CFG evidence
    ret
; @0BCE7 0000:BCE7 original=837e1401 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 1
; @0BCEB 0000:BCEB original=7407 runtime CFG evidence
    JE_SHORT loc_0BCF4
; @0BCED 0000:BCED original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0BCF1 0000:BCF1 original=7406 runtime CFG evidence
    JE_SHORT loc_0BCF9
; @0BCF3 0000:BCF3 original=c3 runtime CFG evidence
    ret
; @0BCF4 0000:BCF4 original=e84fed runtime CFG evidence
    CALL_NEAR loc_0AA46
; @0BCF7 0000:BCF7 original=eb03 runtime CFG evidence
    JMP_SHORT loc_0BCFC
; @0BCF9 0000:BCF9 original=e875ed runtime CFG evidence
    CALL_NEAR loc_0AA71
; @0BCFC 0000:BCFC original=7201 runtime CFG evidence
    JB_SHORT loc_0BCFF
; @0BCFE 0000:BCFE original=c3 runtime CFG evidence
    ret
; @0BCFF 0000:BCFF original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @0BD04 0000:BD04 original=7403 runtime CFG evidence
    JE_SHORT loc_0BD09
; @0BD06 0000:BD06 original=e8be02 runtime CFG evidence
    CALL_NEAR loc_0BFC7
; @0BD09 0000:BD09 original=e85de1 runtime CFG evidence
    CALL_NEAR loc_09E69
; @0BD0C 0000:BD0C original=c3 runtime CFG evidence
    ret
; @0BD0D 0000:BD0D original=55
    push bp
; @0BD0E 0000:BD0E original=8beb
    mov bp, bx
; @0BD10 0000:BD10 original=e80400
    CALL_NEAR loc_0BD17
; @0BD13 0000:BD13 original=8bdd
    mov bx, bp
; @0BD15 0000:BD15 original=5d
    pop bp
; @0BD16 0000:BD16 original=c3
    ret
; sub_0000_BD17
; @0BD17 0000:BD17 original=c746000000
    mov word ptr ss:[bp], 0
; @0BD1C 0000:BD1C original=837e1604
    cmp word ptr ss:[bp + 016h], 4
; @0BD20 0000:BD20 original=743a
    JE_SHORT loc_0BD5C
; @0BD22 0000:BD22 original=837e1601
    cmp word ptr ss:[bp + 016h], 1
; @0BD26 0000:BD26 original=742e
    JE_SHORT loc_0BD56
; @0BD28 0000:BD28 original=837e1807
    cmp word ptr ss:[bp + 018h], 7
; @0BD2C 0000:BD2C original=747e
    JE_SHORT loc_0BDAC
; @0BD2E 0000:BD2E original=837e1808
    cmp word ptr ss:[bp + 018h], 8
; @0BD32 0000:BD32 original=7478
    JE_SHORT loc_0BDAC
; @0BD34 0000:BD34 original=837e1809
    cmp word ptr ss:[bp + 018h], 9
; @0BD38 0000:BD38 original=7440
    JE_SHORT loc_0BD7A
; @0BD3A 0000:BD3A original=837e1806
    cmp word ptr ss:[bp + 018h], 6
; @0BD3E 0000:BD3E original=7503
    JNE_SHORT loc_0BD43
; @0BD40 0000:BD40 original=e98100
    JMP_NEAR loc_0BDC4
; @0BD43 0000:BD43 original=837e1805
    cmp word ptr ss:[bp + 018h], 5
; @0BD47 0000:BD47 original=747b
    JE_SHORT loc_0BDC4
; @0BD49 0000:BD49 original=837e180c
    cmp word ptr ss:[bp + 018h], 0Ch
; @0BD4D 0000:BD4D original=7469
    JE_SHORT loc_0BDB8
; @0BD4F 0000:BD4F original=837e180a
    cmp word ptr ss:[bp + 018h], 0Ah
; @0BD53 0000:BD53 original=7449
    JE_SHORT loc_0BD9E
; @0BD55 0000:BD55 original=c3
    ret
; @0BD56 0000:BD56 original=c746160200
    mov word ptr ss:[bp + 016h], 2
; @0BD5B 0000:BD5B original=c3
    ret
; @0BD5C 0000:BD5C original=e8f502
    CALL_NEAR loc_0C054
; @0BD5F 0000:BD5F original=837e1801
    cmp word ptr ss:[bp + 018h], 1
; @0BD63 0000:BD63 original=7501
    JNE_SHORT loc_0BD66
; @0BD65 0000:BD65 original=c3
    ret
; @0BD66 0000:BD66 original=837e28ff
    cmp word ptr ss:[bp + 028h], -1
; @0BD6A 0000:BD6A original=7501
    JNE_SHORT loc_0BD6D
; @0BD6C 0000:BD6C original=c3
    ret
; @0BD6D 0000:BD6D original=8b7628
    mov si, word ptr ss:[bp + 028h]
; @0BD70 0000:BD70 original=d1e6
    shl si, 1
; @0BD72 0000:BD72 original=81c67820
    add si, 02078h
; @0BD76 0000:BD76 original=c60400
    mov byte ptr ds:[si], 0
; @0BD79 0000:BD79 original=c3
    ret
; @0BD7A 0000:BD7A original=833e72a900
    cmp word ptr ds:[0A972h], 0
; @0BD7F 0000:BD7F original=7501
    JNE_SHORT loc_0BD82
; @0BD81 0000:BD81 original=c3
    ret
; @0BD82 0000:BD82 original=b91a00
    mov cx, 01Ah
; @0BD85 0000:BD85 original=beb4a3
    mov si, 0A3B4h
; @0BD88 0000:BD88 original=ad
    lodsw
; @0BD89 0000:BD89 original=3dffff
    cmp ax, 0FFFFh
; @0BD8C 0000:BD8C original=7501
    JNE_SHORT loc_0BD8F
; @0BD8E 0000:BD8E original=c3
    ret
; @0BD8F 0000:BD8F original=8944fe
    mov word ptr ds:[si - 2], ax
; @0BD92 0000:BD92 original=8bd8
    mov bx, ax
; @0BD94 0000:BD94 original=c7070000
    mov word ptr ds:[bx], 0
; @0BD98 0000:BD98 original=ff0e72a9
    dec word ptr ds:[0A972h]
; @0BD9C 0000:BD9C original=ebea
    JMP_SHORT loc_0BD88
; @0BD9E 0000:BD9E original=833e7ea900
    cmp word ptr ds:[0A97Eh], 0
; @0BDA3 0000:BDA3 original=7404
    JE_SHORT loc_0BDA9
; @0BDA5 0000:BDA5 original=ff0e7ea9
    dec word ptr ds:[0A97Eh]
; @0BDA9 0000:BDA9 original=e96dee
    JMP_NEAR loc_0AC19
; @0BDAC 0000:BDAC original=833e70a900
    cmp word ptr ds:[0A970h], 0
; @0BDB1 0000:BDB1 original=7404
    JE_SHORT loc_0BDB7
; @0BDB3 0000:BDB3 original=ff0e70a9
    dec word ptr ds:[0A970h]
; @0BDB7 0000:BDB7 original=c3
    ret
; @0BDB8 0000:BDB8 original=833e74a900
    cmp word ptr ds:[0A974h], 0
; @0BDBD 0000:BDBD original=7404
    JE_SHORT loc_0BDC3
; @0BDBF 0000:BDBF original=ff0e74a9
    dec word ptr ds:[0A974h]
; @0BDC3 0000:BDC3 original=c3
    ret
; @0BDC4 0000:BDC4 original=833e76a900
    cmp word ptr ds:[0A976h], 0
; @0BDC9 0000:BDC9 original=7404
    JE_SHORT loc_0BDCF
; @0BDCB 0000:BDCB original=ff0e76a9
    dec word ptr ds:[0A976h]
; @0BDCF 0000:BDCF original=c3
    ret
; @0BDD0 0000:BDD0 original=837e0a01 runtime CFG evidence
    cmp word ptr ss:[bp + 0Ah], 1
; @0BDD4 0000:BDD4 original=7464 runtime CFG evidence
    JE_SHORT loc_0BE3A
; @0BDD6 0000:BDD6 original=b92300 runtime CFG evidence
    mov cx, 023h
; @0BDD9 0000:BDD9 original=bbb423 runtime CFG evidence
    mov bx, 023B4h
; @0BDDC 0000:BDDC original=a136a4 runtime CFG evidence
    mov ax, word ptr ds:[0A436h]
; @0BDDF 0000:BDDF original=8b3e38a4 runtime CFG evidence
    mov di, word ptr ds:[0A438h]
; @0BDE3 0000:BDE3 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @0BDE6 0000:BDE6 original=744d runtime CFG evidence
    JE_SHORT loc_0BE35
; @0BDE8 0000:BDE8 original=837f0a01 runtime CFG evidence
    cmp word ptr ds:[bx + 0Ah], 1
; @0BDEC 0000:BDEC original=7447 runtime CFG evidence
    JE_SHORT loc_0BE35
; @0BDEE 0000:BDEE original=837f1401 runtime CFG evidence
    cmp word ptr ds:[bx + 014h], 1
; @0BDF2 0000:BDF2 original=7541 runtime CFG evidence
    JNE_SHORT loc_0BE35
; @0BDF4 0000:BDF4 original=837f1604 runtime CFG evidence
    cmp word ptr ds:[bx + 016h], 4
; @0BDF8 0000:BDF8 original=753b runtime CFG evidence
    JNE_SHORT loc_0BE35
; @0BDFA 0000:BDFA original=817f188200 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 082h
; @0BDFF 0000:BDFF original=7234 runtime CFG evidence
    JB_SHORT loc_0BE35
; @0BE01 0000:BE01 original=817f189400 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 094h
; @0BE06 0000:BE06 original=772d runtime CFG evidence
    JA_SHORT loc_0BE35
; @0BE08 0000:BE08 original=8b7702 runtime CFG evidence
    mov si, word ptr ds:[bx + 2]
; @0BE0B 0000:BE0B original=83c610 runtime CFG evidence
    add si, 010h
; @0BE0E 0000:BE0E original=3bfe runtime CFG evidence
    cmp di, si
; @0BE10 0000:BE10 original=7d23 runtime CFG evidence
    JGE_SHORT loc_0BE35
; @0BE12 0000:BE12 original=83ee20 runtime CFG evidence
    sub si, 020h
; @0BE15 0000:BE15 original=3bfe runtime CFG evidence
    cmp di, si
; @0BE17 0000:BE17 original=7e1c runtime CFG evidence
    JLE_SHORT loc_0BE35
; @0BE19 0000:BE19 original=8b7704 runtime CFG evidence
    mov si, word ptr ds:[bx + 4]
; @0BE1C 0000:BE1C original=83c610 runtime CFG evidence
    add si, 010h
; @0BE1F 0000:BE1F original=3bc6 runtime CFG evidence
    cmp ax, si
; @0BE21 0000:BE21 original=7d12 runtime CFG evidence
    JGE_SHORT loc_0BE35
; @0BE23 0000:BE23 original=83ee20 runtime CFG evidence
    sub si, 020h
; @0BE26 0000:BE26 original=3bc6 runtime CFG evidence
    cmp ax, si
; @0BE28 0000:BE28 original=7e0b runtime CFG evidence
    JLE_SHORT loc_0BE35
; @0BE2A 0000:BE2A original=8b760e runtime CFG evidence
    mov si, word ptr ss:[bp + 0Eh]
; @0BE2D 0000:BE2D original=3b770e runtime CFG evidence
    cmp si, word ptr ds:[bx + 0Eh]
; @0BE30 0000:BE30 original=7403 runtime CFG evidence
    JE_SHORT loc_0BE35
; @0BE32 0000:BE32 original=e92492 runtime CFG evidence
    JMP_NEAR loc_05059
; @0BE35 0000:BE35 original=83c338 runtime CFG evidence
    add bx, 038h
; @0BE38 0000:BE38 original=e2a9 runtime CFG evidence
    LOOP_SHORT loc_0BDE3
; @0BE3A 0000:BE3A original=f8 runtime CFG evidence
    clc
; @0BE3B 0000:BE3B original=c3 runtime CFG evidence
    ret
; @0BE3C 0000:BE3C original=833e242301 runtime CFG evidence
    cmp word ptr ds:[02324h], 1
; @0BE41 0000:BE41 original=7403 runtime CFG evidence
    JE_SHORT loc_0BE46
; @0BE43 0000:BE43 original=e9fffd runtime CFG evidence
    JMP_NEAR loc_0BC45
; @0BE46 0000:BE46 original=ff4622 runtime CFG evidence
    inc word ptr ss:[bp + 022h]
; @0BE49 0000:BE49 original=8b5e14 runtime CFG evidence
    mov bx, word ptr ss:[bp + 014h]
; @0BE4C 0000:BE4C original=d1e3 runtime CFG evidence
    shl bx, 1
; @0BE4E 0000:BE4E original=2effa754be runtime CFG evidence
    jmp word ptr cs:[bx - 041ACh]
; @0BE53 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,045h,0BCh,05Ah,0BEh,0B0h,0BEh
; @0BE5A 0000:BE5A original=837e2209 runtime CFG evidence
    cmp word ptr ss:[bp + 022h], 9
; @0BE5E 0000:BE5E original=7544 runtime CFG evidence
    JNE_SHORT loc_0BEA4
; @0BE60 0000:BE60 original=837e1a24 runtime CFG evidence
    cmp word ptr ss:[bp + 01Ah], 024h
; @0BE64 0000:BE64 original=7409 runtime CFG evidence
    JE_SHORT loc_0BE6F
; @0BE66 0000:BE66 original=837e1a25 runtime CFG evidence
    cmp word ptr ss:[bp + 01Ah], 025h
; @0BE6A 0000:BE6A original=7418 runtime CFG evidence
    JE_SHORT loc_0BE84
; @0BE6C 0000:BE6C original=e9a8fe runtime CFG evidence
    JMP_NEAR loc_0BD17
; @0BE6F 0000:BE6F original=c746060600 runtime CFG evidence
    mov word ptr ss:[bp + 6], 6
; @0BE74 0000:BE74 original=c746182600 runtime CFG evidence
    mov word ptr ss:[bp + 018h], 026h
; @0BE79 0000:BE79 original=c746089700 runtime CFG evidence
    mov word ptr ss:[bp + 8], 097h
; @0BE7E 0000:BE7E original=836e0408 runtime CFG evidence
    sub word ptr ss:[bp + 4], 8
; @0BE82 0000:BE82 original=eb13 runtime CFG evidence
    JMP_SHORT loc_0BE97
; @0BE84 0000:BE84 original=c746060200 runtime CFG evidence
    mov word ptr ss:[bp + 6], 2
; @0BE89 0000:BE89 original=c746182600 runtime CFG evidence
    mov word ptr ss:[bp + 018h], 026h
; @0BE8E 0000:BE8E original=c746089100 runtime CFG evidence
    mov word ptr ss:[bp + 8], 091h
; @0BE93 0000:BE93 original=83460408 runtime CFG evidence
    add word ptr ss:[bp + 4], 8
; @0BE97 0000:BE97 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0BE9A 0000:BE9A original=894632 runtime CFG evidence
    mov word ptr ss:[bp + 032h], ax
; @0BE9D 0000:BE9D original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0BEA0 0000:BEA0 original=894634 runtime CFG evidence
    mov word ptr ss:[bp + 034h], ax
; @0BEA3 0000:BEA3 original=c3 runtime CFG evidence
    ret
; @0BEA4 0000:BEA4 original=8b4622 runtime CFG evidence
    mov ax, word ptr ss:[bp + 022h]
; @0BEA7 0000:BEA7 original=050000 runtime CFG evidence
    add ax, 0
; @0BEAA 0000:BEAA original=894608 runtime CFG evidence
    mov word ptr ss:[bp + 8], ax
; @0BEAD 0000:BEAD original=e995fd runtime CFG evidence
    JMP_NEAR loc_0BC45
; @0BEB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,022h,0Ch,075h,03h,0E9h,05Eh,0FEh,08Bh,046h,022h,05h,03h,00h,089h
; @0BEC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,0E9h,080h,0FDh
; @0BEC5 0000:BEC5 original=837f1807 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 7
; @0BEC9 0000:BEC9 original=7503 runtime CFG evidence
    JNE_SHORT loc_0BECE
; @0BECB 0000:BECB original=e9eb00 runtime CFG evidence
    JMP_NEAR loc_0BFB9
; @0BECE 0000:BECE original=837f1808 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 8
; @0BED2 0000:BED2 original=7503 runtime CFG evidence
    JNE_SHORT loc_0BED7
; @0BED4 0000:BED4 original=e9e200 runtime CFG evidence
    JMP_NEAR loc_0BFB9
; @0BED7 0000:BED7 original=837f180c runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 0Ch
; @0BEDB 0000:BEDB original=7503 runtime CFG evidence
    JNE_SHORT loc_0BEE0
; @0BEDD 0000:BEDD original=e9d900 runtime CFG evidence
    JMP_NEAR loc_0BFB9
; @0BEE0 0000:BEE0 original=837f1809 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 9
; @0BEE4 0000:BEE4 original=7503 runtime CFG evidence
    JNE_SHORT loc_0BEE9
; @0BEE6 0000:BEE6 original=e9bf00 runtime CFG evidence
    JMP_NEAR loc_0BFA8
; @0BEE9 0000:BEE9 original=837f1802 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 2
; @0BEED 0000:BEED original=742c runtime CFG evidence
    JE_SHORT loc_0BF1B
; @0BEEF 0000:BEEF original=837f1806 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 6
; @0BEF3 0000:BEF3 original=7503 runtime CFG evidence
    JNE_SHORT loc_0BEF8
; @0BEF5 0000:BEF5 original=e99f00 runtime CFG evidence
    JMP_NEAR loc_0BF97
; @0BEF8 0000:BEF8 original=837f1805 runtime CFG evidence
    cmp word ptr ds:[bx + 018h], 5
; @0BEFC 0000:BEFC original=7503 runtime CFG evidence
    JNE_SHORT loc_0BF01
; @0BEFE 0000:BEFE original=e99600 runtime CFG evidence
    JMP_NEAR loc_0BF97
; @0BF01 0000:BF01 original=3b6f30 runtime CFG evidence
    cmp bp, word ptr ds:[bx + 030h]
; @0BF04 0000:BF04 original=7401 runtime CFG evidence
    JE_SHORT loc_0BF07
; @0BF06 0000:BF06 original=c3 runtime CFG evidence
    ret
; @0BF07 0000:BF07 original=c7471c0000 runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 0
; @0BF0C 0000:BF0C original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @0BF11 0000:BF11 original=7412 runtime CFG evidence
    JE_SHORT loc_0BF25
; @0BF13 0000:BF13 original=c746200000 runtime CFG evidence
    mov word ptr ss:[bp + 020h], 0
; @0BF18 0000:BF18 original=e9ac00 runtime CFG evidence
    JMP_NEAR loc_0BFC7
; @0BF1B 0000:BF1B original=c7070000 runtime CFG evidence
    mov word ptr ds:[bx], 0
; @0BF1F 0000:BF1F original=837f0833 runtime CFG evidence
    cmp word ptr ds:[bx + 8], 033h
; @0BF23 0000:BF23 original=7508 runtime CFG evidence
    JNE_SHORT loc_0BF2D
; @0BF25 0000:BF25 original=ff4e20 runtime CFG evidence
    dec word ptr ss:[bp + 020h]
; @0BF28 0000:BF28 original=7503 runtime CFG evidence
    JNE_SHORT loc_0BF2D
; @0BF2A 0000:BF2A original=e99a00 runtime CFG evidence
    JMP_NEAR loc_0BFC7
; @0BF2D 0000:BF2D original=ff4e20 runtime CFG evidence
    dec word ptr ss:[bp + 020h]
; @0BF30 0000:BF30 original=7503 runtime CFG evidence
    JNE_SHORT loc_0BF35
; @0BF32 0000:BF32 original=e99200 runtime CFG evidence
    JMP_NEAR loc_0BFC7
; @0BF35 0000:BF35 original=833edcbe01 runtime CFG evidence
    cmp word ptr ds:[0BEDCh], 1
; @0BF3A 0000:BF3A original=7411 runtime CFG evidence
    JE_SHORT loc_0BF4D
; @0BF3C 0000:BF3C original=833edcbe00 runtime CFG evidence
    cmp word ptr ds:[0BEDCh], 0
; @0BF41 0000:BF41 original=750f runtime CFG evidence
    JNE_SHORT loc_0BF52
; @0BF43 0000:BF43 original=ff4e20 runtime CFG evidence
    dec word ptr ss:[bp + 020h]
; @0BF46 0000:BF46 original=747f runtime CFG evidence
    JE_SHORT loc_0BFC7
; @0BF48 0000:BF48 original=ff4e20 runtime CFG evidence
    dec word ptr ss:[bp + 020h]
; @0BF4B 0000:BF4B original=747a runtime CFG evidence
    JE_SHORT loc_0BFC7
; @0BF4D 0000:BF4D original=ff4e20 runtime CFG evidence
    dec word ptr ss:[bp + 020h]
; @0BF50 0000:BF50 original=7475 runtime CFG evidence
    JE_SHORT loc_0BFC7
; @0BF52 0000:BF52 original=c746240500 runtime CFG evidence
    mov word ptr ss:[bp + 024h], 5
; @0BF57 0000:BF57 original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @0BF5C 0000:BF5C original=7401 runtime CFG evidence
    JE_SHORT loc_0BF5F
; @0BF5E 0000:BF5E original=c3 runtime CFG evidence
    ret
; @0BF5F 0000:BF5F original=55 runtime CFG evidence
    push bp
; @0BF60 0000:BF60 original=8b2ebaa8 runtime CFG evidence
    mov bp, word ptr ds:[0A8BAh]
; @0BF64 0000:BF64 original=c746240500 runtime CFG evidence
    mov word ptr ss:[bp + 024h], 5
; @0BF69 0000:BF69 original=8b2ebca8 runtime CFG evidence
    mov bp, word ptr ds:[0A8BCh]
; @0BF6D 0000:BF6D original=c746240500 runtime CFG evidence
    mov word ptr ss:[bp + 024h], 5
; @0BF72 0000:BF72 original=8b2ebea8 runtime CFG evidence
    mov bp, word ptr ds:[0A8BEh]
; @0BF76 0000:BF76 original=c746240500 runtime CFG evidence
    mov word ptr ss:[bp + 024h], 5
; @0BF7B 0000:BF7B original=8b2ec0a8 runtime CFG evidence
    mov bp, word ptr ds:[0A8C0h]
; @0BF7F 0000:BF7F original=c746240500 runtime CFG evidence
    mov word ptr ss:[bp + 024h], 5
; @0BF84 0000:BF84 original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0BF89 0000:BF89 original=7405 runtime CFG evidence
    JE_SHORT loc_0BF90
; @0BF8B 0000:BF8B original=c606ffbe0e runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 0Eh
; @0BF90 0000:BF90 original=5d runtime CFG evidence
    pop bp
; @0BF91 0000:BF91 original=c3 runtime CFG evidence
    ret
; @0BF92 0000:BF92 original=e878fd runtime CFG evidence
    CALL_NEAR loc_0BD0D
; @0BF95 0000:BF95 original=eb8e runtime CFG evidence
    JMP_SHORT loc_0BF25
; @0BF97 0000:BF97 original=e873fd runtime CFG evidence
    CALL_NEAR loc_0BD0D
; @0BF9A 0000:BF9A original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @0BF9F 0000:BF9F original=7484 runtime CFG evidence
    JE_SHORT loc_0BF25
; @0BFA1 0000:BFA1 original=c746200000 runtime CFG evidence
    mov word ptr ss:[bp + 020h], 0
; @0BFA6 0000:BFA6 original=eb1f runtime CFG evidence
    JMP_SHORT loc_0BFC7
; @0BFA8 0000:BFA8 original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @0BFAD 0000:BFAD original=7503 runtime CFG evidence
    JNE_SHORT loc_0BFB2
; @0BFAF 0000:BFAF original=e973ff runtime CFG evidence
    JMP_NEAR loc_0BF25
; @0BFB2 0000:BFB2 original=c746200000 runtime CFG evidence
    mov word ptr ss:[bp + 020h], 0
; @0BFB7 0000:BFB7 original=eb0e runtime CFG evidence
    JMP_SHORT loc_0BFC7
; @0BFB9 0000:BFB9 original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @0BFBE 0000:BFBE original=74d2 runtime CFG evidence
    JE_SHORT loc_0BF92
; @0BFC0 0000:BFC0 original=c746200000 runtime CFG evidence
    mov word ptr ss:[bp + 020h], 0
; @0BFC5 0000:BFC5 original=eb00 runtime CFG evidence
    JMP_SHORT loc_0BFC7
; @0BFC7 0000:BFC7 original=837e1821
    cmp word ptr ss:[bp + 018h], 021h
; @0BFCB 0000:BFCB original=7508
    JNE_SHORT loc_0BFD5
; @0BFCD 0000:BFCD original=833e562304
    cmp word ptr ds:[02356h], 4
; @0BFD2 0000:BFD2 original=7401
    JE_SHORT loc_0BFD5
; @0BFD4 0000:BFD4 original=c3
    ret
; @0BFD5 0000:BFD5 original=837e1401
    cmp word ptr ss:[bp + 014h], 1
; @0BFD9 0000:BFD9 original=bb3000
    mov bx, 030h
; @0BFDC 0000:BFDC original=7403
    JE_SHORT loc_0BFE1
; @0BFDE 0000:BFDE original=bb6000
    mov bx, 060h
; @0BFE1 0000:BFE1 original=e8299f
    CALL_NEAR loc_05F0D
; @0BFE4 0000:BFE4 original=e8cafc
    CALL_NEAR loc_0BCB1
; @0BFE7 0000:BFE7 original=55
    push bp
; @0BFE8 0000:BFE8 original=837e28ff
    cmp word ptr ss:[bp + 028h], -1
; @0BFEC 0000:BFEC original=7429
    JE_SHORT loc_0C017
; @0BFEE 0000:BFEE original=8b7628
    mov si, word ptr ss:[bp + 028h]
; @0BFF1 0000:BFF1 original=d1e6
    shl si, 1
; @0BFF3 0000:BFF3 original=81c67820
    add si, 02078h
; @0BFF7 0000:BFF7 original=803c00
    cmp byte ptr ds:[si], 0
; @0BFFA 0000:BFFA original=741b
    JE_SHORT loc_0C017
; @0BFFC 0000:BFFC original=fe0c
    dec byte ptr ds:[si]
; @0BFFE 0000:BFFE original=7517
    JNE_SHORT loc_0C017
part05 ends
end
