; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part05 segment byte public 'CODE'
assume cs:part05,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
CopyWords2And4Plus10_0A571 equ 0571h
DecBP2Unless20_0A5DB equ 05DBh
DecBP4UnlessZero_0A5FC equ 05FCh
IncBP2UnlessC0_0A5ED equ 05EDh
IncBP4BelowB0_0A60A equ 060Ah
loc_04A65 equ 0AA65h
loc_04CED equ 0ACEDh
loc_04D64 equ 0AD64h
loc_05A7E equ 0BA7Eh
loc_05A92 equ 0BA92h
loc_05AC8 equ 0BAC8h
loc_05F0D equ 0BF0Dh
loc_062AA equ 0C2AAh
loc_07524 equ 0D524h
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
loc_0A648 equ 0648h
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
; @0A000 0000:A000 original=ad
    lodsw
; @0A001 0000:A001 original=034604
    add ax, word ptr ss:[bp + 4]
; @0A004 0000:A004 original=030698a3
    add ax, word ptr ds:[0A398h]
; @0A008 0000:A008 original=030698a3
    add ax, word ptr ds:[0A398h]
; @0A00C 0000:A00C original=894704
    mov word ptr ds:[bx + 4], ax
; @0A00F 0000:A00F original=837f0400
    cmp word ptr ds:[bx + 4], 0
; @0A013 0000:A013 original=7d0a
    JGE_SHORT loc_0A01F
; @0A015 0000:A015 original=c747040000
    mov word ptr ds:[bx + 4], 0
; @0A01A 0000:A01A original=c6069ea301
    mov byte ptr ds:[0A39Eh], 1
; @0A01F 0000:A01F original=817f04c000
    cmp word ptr ds:[bx + 4], 0C0h
; @0A024 0000:A024 original=7e0a
    JLE_SHORT loc_0A030
; @0A026 0000:A026 original=c74704c000
    mov word ptr ds:[bx + 4], 0C0h
; @0A02B 0000:A02B original=c6069fa301
    mov byte ptr ds:[0A39Fh], 1
; @0A030 0000:A030 original=c3
    ret
; sub_0000_A031
; @0A031 0000:A031 original=833e62a9ff
    cmp word ptr ds:[0A962h], -1
; @0A036 0000:A036 original=7410
    JE_SHORT loc_0A048
; @0A038 0000:A038 original=8b1e62a9
    mov bx, word ptr ds:[0A962h]
; @0A03C 0000:A03C original=8b363ca3
    mov si, word ptr ds:[0A33Ch]
; @0A040 0000:A040 original=ad
    lodsw
; @0A041 0000:A041 original=894702
    mov word ptr ds:[bx + 2], ax
; @0A044 0000:A044 original=ad
    lodsw
; @0A045 0000:A045 original=894704
    mov word ptr ds:[bx + 4], ax
; @0A048 0000:A048 original=833e64a9ff
    cmp word ptr ds:[0A964h], -1
; @0A04D 0000:A04D original=7410
    JE_SHORT loc_0A05F
; @0A04F 0000:A04F original=8b1e64a9
    mov bx, word ptr ds:[0A964h]
; @0A053 0000:A053 original=8b363ea3
    mov si, word ptr ds:[0A33Eh]
; @0A057 0000:A057 original=ad
    lodsw
; @0A058 0000:A058 original=894702
    mov word ptr ds:[bx + 2], ax
; @0A05B 0000:A05B original=ad
    lodsw
; @0A05C 0000:A05C original=894704
    mov word ptr ds:[bx + 4], ax
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
    CALL_NEAR CopyWords2And4Plus10_0A571
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
; CopyWords2And4Plus10
; First DS:[BX+4] = SS:[BP+4]+10 modulo 65536; then DS:[BX+2] = SS:[BP+2]+10. AX holds the
; latter result. Order matters if memory aliases. Flags are from the second ADD.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A571 0000:A571 original=8b4604
    mov ax, word ptr ss:[bp + 4]
; @0A574 0000:A574 original=050a00
    add ax, 0Ah
; @0A577 0000:A577 original=894704
    mov word ptr ds:[bx + 4], ax
; @0A57A 0000:A57A original=8b4602
    mov ax, word ptr ss:[bp + 2]
; @0A57D 0000:A57D original=050a00
    add ax, 0Ah
; @0A580 0000:A580 original=894702
    mov word ptr ds:[bx + 2], ax
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
    CALL_NEAR CopyWords2And4Plus10_0A571
; @0A5AA 0000:A5AA original=836704fc
    and word ptr ds:[bx + 4], 0FFFCh
; @0A5AE 0000:A5AE original=c747080800
    mov word ptr ds:[bx + 8], 8
; @0A5B3 0000:A5B3 original=c747180500
    mov word ptr ds:[bx + 018h], 5
; @0A5B8 0000:A5B8 original=ff0676a9
    inc word ptr ds:[0A976h]
; @0A5BC 0000:A5BC original=e82bff
    CALL_NEAR loc_0A4EA
; @0A5BF 0000:A5BF original=e8afff
    CALL_NEAR CopyWords2And4Plus10_0A571
; @0A5C2 0000:A5C2 original=836704fc
    and word ptr ds:[bx + 4], 0FFFCh
; @0A5C6 0000:A5C6 original=c747080800
    mov word ptr ds:[bx + 8], 8
; @0A5CB 0000:A5CB original=c747180600
    mov word ptr ds:[bx + 018h], 6
; @0A5D0 0000:A5D0 original=c3
    ret
; sub_0000_A5D1
; @0A5D1 0000:A5D1 original=833e7ca400
    cmp word ptr ds:[0A47Ch], 0
; @0A5D6 0000:A5D6 original=750e
    JNE_SHORT loc_0A5E6
; @0A5D8 0000:A5D8 original=e80000
    CALL_NEAR DecBP2Unless20_0A5DB
; DecBP2Unless20
; Decrement word SS:[BP+2] modulo 65536 unless it equals 0020h. This is NOT a saturating
; lower-bound clamp: values below 20h also decrement. CMP always overwrites CF; DEC
; preserves that CF.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A5DB 0000:A5DB original=837e0220
    cmp word ptr ss:[bp + 2], 020h
; @0A5DF 0000:A5DF original=7501
    JNE_SHORT loc_0A5E2
; @0A5E1 0000:A5E1 original=c3
    ret
; @0A5E2 0000:A5E2 original=ff4e02
    dec word ptr ss:[bp + 2]
; @0A5E5 0000:A5E5 original=c3
    ret
; @0A5E6 0000:A5E6 original=ff4e02
    dec word ptr ss:[bp + 2]
; @0A5E9 0000:A5E9 original=c3
    ret
; sub_0000_A5EA
; @0A5EA 0000:A5EA original=e80000
    CALL_NEAR IncBP2UnlessC0_0A5ED
; IncBP2UnlessC0
; Increment word SS:[BP+2] modulo 65536 unless it equals 00C0h; values above C0h also
; increment.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A5ED 0000:A5ED original=817e02c000
    cmp word ptr ss:[bp + 2], 0C0h
; @0A5F2 0000:A5F2 original=7501
    JNE_SHORT loc_0A5F5
; @0A5F4 0000:A5F4 original=c3
    ret
; @0A5F5 0000:A5F5 original=ff4602
    inc word ptr ss:[bp + 2]
; @0A5F8 0000:A5F8 original=c3
    ret
; sub_0000_A5F9
; @0A5F9 0000:A5F9 original=e80000
    CALL_NEAR DecBP4UnlessZero_0A5FC
; DecBP4UnlessZero
; Decrement unsigned word SS:[BP+4] unless zero; register state preserved, flags changed by
; CMP/DEC.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A5FC 0000:A5FC original=837e0400
    cmp word ptr ss:[bp + 4], 0
; @0A600 0000:A600 original=7501
    JNE_SHORT loc_0A603
; @0A602 0000:A602 original=c3
    ret
; @0A603 0000:A603 original=ff4e04
    dec word ptr ss:[bp + 4]
; @0A606 0000:A606 original=c3
    ret
; sub_0000_A607
; @0A607 0000:A607 original=e80000
    CALL_NEAR IncBP4BelowB0_0A60A
; IncBP4BelowB0
; Increment unsigned word SS:[BP+4] iff below 00B0h; values at or above B0h remain
; unchanged.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0A60A 0000:A60A original=817e04b000
    cmp word ptr ss:[bp + 4], 0B0h
; @0A60F 0000:A60F original=7201
    JB_SHORT loc_0A612
; @0A611 0000:A611 original=c3
    ret
; @0A612 0000:A612 original=ff4604
    inc word ptr ss:[bp + 4]
; @0A615 0000:A615 original=c3
    ret
; sub_0000_A616
; @0A616 0000:A616 original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @0A61C 0000:A61C original=7701
    JA_SHORT loc_0A61F
; @0A61E 0000:A61E original=c3
    ret
; @0A61F 0000:A61F original=e82600
    CALL_NEAR loc_0A648
; @0A622 0000:A622 original=817e04b000
    cmp word ptr ss:[bp + 4], 0B0h
; @0A627 0000:A627 original=7513
    JNE_SHORT loc_0A63C
; @0A629 0000:A629 original=f606be9801
    test byte ptr ds:[098BEh], 1
; @0A62E 0000:A62E original=740c
    JE_SHORT loc_0A63C
; @0A630 0000:A630 original=833e9ca308
    cmp word ptr ds:[0A39Ch], 8
; @0A635 0000:A635 original=7404
    JE_SHORT loc_0A63B
; @0A637 0000:A637 original=ff069ca3
    inc word ptr ds:[0A39Ch]
; @0A63B 0000:A63B original=c3
    ret
; @0A63C 0000:A63C original=833e9ca300
    cmp word ptr ds:[0A39Ch], 0
; @0A641 0000:A641 original=7404
    JE_SHORT loc_0A647
; @0A643 0000:A643 original=ff0e9ca3
    dec word ptr ds:[0A39Ch]
; @0A647 0000:A647 original=c3
    ret
; sub_0000_A648
; @0A648 0000:A648 original=837e0400
    cmp word ptr ss:[bp + 4], 0
; @0A64C 0000:A64C original=7514
    JNE_SHORT loc_0A662
; @0A64E 0000:A64E original=f606be9802
    test byte ptr ds:[098BEh], 2
; @0A653 0000:A653 original=740d
    JE_SHORT loc_0A662
; @0A655 0000:A655 original=833e9aa3f8
    cmp word ptr ds:[0A39Ah], -8
; @0A65A 0000:A65A original=7501
    JNE_SHORT loc_0A65D
; @0A65C 0000:A65C original=c3
    ret
; @0A65D 0000:A65D original=ff0e9aa3
    dec word ptr ds:[0A39Ah]
; @0A661 0000:A661 original=c3
    ret
; @0A662 0000:A662 original=833e9aa300
    cmp word ptr ds:[0A39Ah], 0
; @0A667 0000:A667 original=7501
    JNE_SHORT loc_0A66A
; @0A669 0000:A669 original=c3
    ret
; @0A66A 0000:A66A original=ff069aa3
    inc word ptr ds:[0A39Ah]
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
    CALL_NEAR loc_07524
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
    db 090h,045h,0BCh,04h,0ADh,0AEh,0EFh,0AFh,044h,0AEh,0EFh,0C2h,0AAh,010h,0ABh,0F8h
; @0AA45 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,08Bh,046h,02h,0Bh,0C0h,078h,0F7h,08Bh,036h,084h,023h,083h,0FEh,03h,073h
; @0AA55 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EEh,0D1h,0E6h,0D1h,0E6h,081h,0C6h,04Eh,021h,0ADh,03h,06h,07Eh,023h,0A3h,0F2h
; @0AA65 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0ADh,03h,06h,080h,023h,0A3h,0F4h,095h,0E9h,0C0h,0D8h,08Bh,046h,02h,0Bh
; @0AA75 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,078h,0CCh,08Bh,046h,04h,05h,018h,00h,03Bh,06h,080h,023h,07Ch,0C0h,02Dh
; @0AA85 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ch,00h,03Bh,06h,080h,023h,07Fh,0B7h,083h,03Eh,0C2h,0A8h,01h,075h,017h,08Bh
; @0AA95 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,05h,08h,00h,03Bh,06h,07Eh,023h,072h,0A4h,02Dh,0Ch,00h,03Bh,06h
; @0AAA5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,023h,077h,09Bh,0F9h,0C3h,08Bh,046h,02h,05h,018h,00h,03Bh,06h,07Eh,023h
; @0AAB5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,08Dh,02Dh,02Ch,00h,03Bh,06h,07Eh,023h,077h,084h,0F9h,0C3h,0FFh,046h,02h
; @0AAC5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,07Eh,0FFh,072h,03h,0E9h,078h,011h,0E8h,03h,00h,0E9h,072h,011h,083h,03Eh
; @0AAD5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 084h,023h,03h,072h,01h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh
; @0AAE5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BEh,07h,0BBh,020h,00h,0E8h,020h,0B4h,055h,02Eh,0FFh,036h,0Ah,0ABh,08Bh,05Eh
; @0AAF5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,0BDh,07Ch,023h,0D1h,0E3h,02Eh,0FFh,0A7h,00h,0ABh,0AFh,044h,04Dh,09Dh,067h
; @0AB05 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Dh,0AAh,062h,0B9h,09Dh,0Ch,0ABh,05Dh,0E9h,07h,012h,083h,03Eh,084h,023h,03h
; @0AB15 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,03h,0E9h,08h,01h,083h,03Eh,07Ch,0A4h,03h,072h,03h,0E9h,0FEh,00h,0A1h
; @0AB25 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 036h,023h,0BBh,0Ch,0A4h,0D7h,05h,09h,00h,089h,046h,08h,0BAh,014h,0A4h,0BBh
; @0AB35 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ch,023h,08Bh,077h,08h,0D1h,0E6h,0D1h,0E6h,03h,0F2h,0ADh,03h,047h,02h,089h
; @0AB45 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,0ADh,03h,047h,04h,089h,046h,04h,0C3h,0A1h,03Ch,023h,05h,018h,00h
; @0AB55 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,0C3h,0C7h,06h,02Ch,0A4h,06Ch,0A9h,0EBh,016h,0C7h,06h,02Ch,0A4h
; @0AB65 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Ah,0A9h,0EBh,0Eh,0C7h,06h,02Ch,0A4h,068h,0A9h,0EBh,06h,0C7h,06h,02Ch,0A4h
; @0AB75 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,0A9h,083h,03Eh,084h,023h,03h,073h,011h,0E8h,0CEh,0FFh,0E8h,0A4h,00h,072h
; @0AB85 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,0E8h,0F8h,00h,072h,01h,0C3h,0E8h,0Ah,00h,08Bh,01Eh,02Ch,0A4h,0C7h,07h
; @0AB95 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0EBh,05Ah,055h,08Bh,0EBh,0E8h,028h,014h,08Bh,0DDh,05Dh,0C3h,089h,01Eh
; @0ABA5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,0A4h,083h,03Eh,084h,023h,03h,073h,012h,0A1h,03Ch,023h,05h,014h,00h,089h
; @0ABB5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,0E8h,0C7h,00h,072h,01h,0C3h,0E8h,0D9h,0FFh,08Bh,01Eh,02Eh,0A4h,0C7h
; @0ABC5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,0FFh,0FFh,0EBh,029h,083h,03Eh,084h,023h,03h,073h,0Bh,0BAh,020h,0A4h,0E8h
; @0ABD5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Dh,0FFh,0E8h,04Eh,00h,073h,08h,0C7h,06h,06Eh,0A9h,0FFh,0FFh,0EBh,0Fh,0E8h
; @0ABE5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ah,00h,072h,01h,0C3h,0C7h,06h,06Eh,0A9h,0FFh,0FFh,0E8h,0A6h,0FFh,083h,0FDh
; @0ABF5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,075h,01h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,019h
; @0AC05 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,018h,01h,00h,0C7h,046h,016h,04h,00h,0C7h,046h,022h,00h,00h,0C7h
; @0AC15 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,00h,00h
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
; @0AC22 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,00h,00h,00h,0C3h,083h,03Eh,07Ch,0A4h,00h,074h,03h,0E9h,012h,0FEh
; @0AC32 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,0ACh,0BDh,01h,075h,03h,0E9h,08h,0FEh,0E8h,034h,0A4h,083h,0C3h,0Dh
; @0AC42 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,016h,0A4h,075h,0Fh,0F7h,046h,04h,0Fh,00h,074h,06h,043h,0E8h,09h,0A4h
; @0AC52 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,02h,0F8h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Eh
; @0AC62 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,024h,05h,00h,083h,03Eh,0DCh,0BEh,00h,075h,07h,083h,03Eh,024h,023h
; @0AC72 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,075h,0DFh,0FFh,04Eh,020h,075h,0DAh,0C7h,046h,024h,00h,00h,0F9h,0C3h,083h
; @0AC82 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0ACh,0BDh,01h,075h,03h,0E9h,0B9h,0FDh,0B9h,023h,00h,0BBh,0B4h,023h,08Bh
; @0AC92 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,04h,08Bh,07Eh,02h,083h,03Fh,00h,074h,036h,083h,07Fh,018h,01h,074h,030h
; @0ACA2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Fh,014h,01h,075h,02Ah,08Bh,077h,02h,083h,0C6h,010h,03Bh,0FEh,07Fh,020h
; @0ACB2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0EEh,020h,03Bh,0FEh,07Ch,019h,08Bh,077h,04h,083h,0C6h,010h,03Bh,0C6h,07Fh
; @0ACC2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Fh,083h,0EEh,020h,03Bh,0C6h,07Ch,08h,08Bh,076h,0Eh,03Bh,077h,0Eh,075h,07h
; @0ACD2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C3h,038h,0E2h,0C0h,0F8h,0C3h,083h,07Fh,016h,05h,074h,01Ah,083h,07Fh,014h
; @0ACE2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,074h,03h,0E9h,071h,0A3h,083h,07Fh,016h,04h,075h,0E4h,0E8h,0A8h,0FEh,0E8h
; @0ACF2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 062h,0FFh,072h,01h,0C3h,0F9h,0C3h,055h,08Bh,0EBh,0E8h,0D4h,0FDh,08Bh,0DDh,05Dh
; @0AD02 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F8h,0C3h,083h,03Eh,0ACh,0BDh,01h,074h,09h,081h,03Eh,050h,023h,0B6h,00h,077h
; @0AD12 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,083h,07Eh,08h,0Fh,075h,03h,0E9h,0ADh,0FEh,03Bh,02Eh,066h,0A9h,075h
; @0AD22 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,04Bh,0FEh,03Bh,02Eh,068h,0A9h,075h,03h,0E9h,03Ah,0FEh,03Bh,02Eh,06Ah
; @0AD32 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,075h,03h,0E9h,029h,0FEh,03Bh,02Eh,06Ch,0A9h,075h,03h,0E9h,018h,0FEh,0BBh
; @0AD42 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 062h,0A9h,03Bh,02Eh,062h,0A9h,075h,03h,0E9h,056h,0FEh,0BBh,064h,0A9h,03Bh,02Eh
; @0AD52 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,0A9h,075h,03h,0E9h,04Ah,0FEh,0C3h,0A1h,078h,0A2h,01h,046h,02h,083h,07Eh
; @0AD62 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,08h,073h,03h,0E9h,0AEh,0Fh,081h,07Eh,02h,0E0h,00h,076h,03h,0E9h,0A4h
; @0AD72 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Fh,081h,07Eh,04h,0C8h,00h,076h,03h,0E9h,09Ah,0Fh,083h,07Eh,016h,02h,075h
; @0AD82 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,083h,07Eh,018h,02h,074h,026h,083h,07Eh,018h,04h,074h,020h,083h,07Eh,018h
; @0AD92 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,074h,01Ah,083h,07Eh,018h,05h,074h,014h,083h,07Eh,018h,06h,074h,0Eh,083h
; @0ADA2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,018h,09h,074h,08h,083h,07Eh,018h,08h,074h,02h,0EBh,019h,083h,03Eh,0ACh
; @0ADB2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BDh,01h,074h,012h,0E8h,0BAh,0A2h,083h,0C3h,0Dh,0E8h,09Ch,0A2h,074h,07h,0FEh
; @0ADC2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C8h,075h,03h,0E9h,04Fh,0Fh,0C3h,0C7h,046h,02h,0FFh,0FFh,0EBh,090h,0FFh,046h
; @0ADD2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0FFh,046h,02h,0E9h,077h,04h,083h,06Eh,02h,010h,0EBh,081h,0A1h,026h,023h
; @0ADE2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,05Ah,00h,089h,046h,08h,083h,06Eh,02h,03h,0E9h,071h,0FFh,0E9h,06Eh,0FFh
; @0ADF2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,02Ah,023h,0D1h,0E8h,05h,00h,00h,089h,046h,08h,0FFh,04Eh,01Ch,074h,0C7h
; @0AE02 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,050h,0B2h,050h,0E9h,05Ah,01h,083h,07Eh,01Ch,00h,074h,0Ah,0FFh,04Eh,01Ch
; @0AE12 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,09h,0C7h,046h,06h,00h,00h,083h,06Eh,02h,02h,08Bh,046h,06h,05h,028h
; @0AE22 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,089h,046h,08h,0E8h,0F9h,00h,0E9h,034h,0FFh,081h,07Eh,04h,0C8h,00h,074h
; @0AE32 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,083h,06Eh,02h,04h,0F7h,046h,04h,07h,00h,075h,020h,0F7h,046h,04h,08h
; @0AE42 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,019h,083h,03Eh,0ACh,0BDh,01h,074h,012h,0E8h,024h,0A2h,083h,0C3h,0Eh
; @0AE52 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,06h,0A2h,0C7h,046h,06h,00h,00h,03Ch,01h,074h,09h,0C7h,046h,06h,01h
; @0AE62 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,083h,046h,04h,04h,0A1h,026h,023h,0D1h,0E0h,0D1h,0E0h,025h,08h,00h,03h
; @0AE72 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,05h,08h,00h,089h,046h,08h,0E9h,0DDh,0FEh,083h,07Eh,04h,00h,075h
; @0AE82 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,043h,0FFh,083h,06Eh,02h,04h,0F7h,046h,04h,0Fh,00h,075h,019h,083h
; @0AE92 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0ACh,0BDh,01h,074h,012h,0E8h,0D8h,0A1h,083h,0C3h,0Ch,0E8h,0BAh,0A1h,0C7h
; @0AEA2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,00h,00h,03Ch,01h,074h,09h,0C7h,046h,06h,07h,00h,083h,06Eh,04h
; @0AEB2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,08Bh,046h,06h,05h,08h,00h,089h,046h,08h,0E9h,09Bh,0FEh,0B8h,050h,0B2h
; @0AEC2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,083h,03Eh,056h,023h,00h,074h,03h,0E9h,093h,00h,083h,07Eh,06h,04h,075h
; @0AED2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,08Ah,00h,0EBh,0Ch,0FFh,04Eh,01Ch,075h,03h,0E9h,0E9h,0FEh,0B8h,050h
; @0AEE2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B2h,050h,08Bh,05Eh,06h,0D1h,0E3h,02Eh,0FFh,0A7h,0EEh,0AEh,0Bh,0AFh,010h,0AFh
; @0AEF2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,0AFh,0FEh,0AEh,02h,0AFh,019h,0AFh,01Dh,0AFh,07h,0AFh,083h,046h,04h,08h
; @0AF02 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,046h,02h,08h,0C3h,083h,06Eh,04h,08h,083h,06Eh,02h,08h,0C3h,083h,06Eh
; @0AF12 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,08h,083h,046h,04h,08h,0C3h,083h,046h,02h,08h,083h,06Eh,04h,08h,0C3h
; @0AF22 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Eh,06h,0D1h,0E3h,02Eh,0FFh,0A7h,02Ch,0AFh,049h,0AFh,04Eh,0AFh,052h,0AFh
; @0AF32 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,0AFh,040h,0AFh,057h,0AFh,05Bh,0AFh,045h,0AFh,083h,046h,04h,03h,083h,046h
; @0AF42 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,03h,0C3h,083h,06Eh,04h,03h,083h,06Eh,02h,03h,0C3h,083h,06Eh,02h,03h
; @0AF52 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,046h,04h,03h,0C3h,083h,046h,02h,03h,083h,06Eh,04h,03h,0C3h,0E8h,00h
; @0AF62 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,08Bh,05Eh,06h,0D1h,0E3h,02Eh,0FFh,0A7h,06Eh,0AFh,090h,08Bh,0AFh,090h,0AFh
; @0AF72 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 094h,0AFh,07Eh,0AFh,082h,0AFh,099h,0AFh,09Dh,0AFh,087h,0AFh,083h,046h,04h,02h
; @0AF82 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,046h,02h,02h,0C3h,083h,06Eh,04h,02h,083h,06Eh,02h,02h,0C3h,083h,06Eh
; @0AF92 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,02h,083h,046h,04h,02h,0C3h,083h,046h,02h,02h,083h,06Eh,04h,02h,0C3h
; @0AFA2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Eh,06h,0D1h,0E3h,02Eh,0FFh,0A7h,0ACh,0AFh,0C6h,0AFh,0CAh,0AFh,0CDh,0AFh
; @0AFB2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BCh,0AFh,0BFh,0AFh,0D1h,0AFh,0D4h,0AFh,0C3h,0AFh,0FFh,046h,04h,0FFh,046h,02h
; @0AFC2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0FFh,04Eh,04h,0FFh,04Eh,02h,0C3h,0FFh,04Eh,02h,0FFh,046h,04h,0C3h,0FFh
; @0AFD2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,0FFh,04Eh,04h,0C3h,0C7h,06h,030h,0A4h,00h,00h,08Bh,046h,02h,0A3h
; @0AFE2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0A4h,0A3h,038h,0A4h,08Bh,046h,04h,0A3h,034h,0A4h,0A3h,036h,0A4h,0A1h,078h
; @0AFF2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A2h,01h,046h,02h,083h,06Eh,02h,010h,0E8h,010h,00h,083h,046h,02h,010h,0A1h
; @0B002 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 078h,0A2h,029h,046h,02h,083h,03Eh,030h,0A4h,00h,0C3h,0E8h,063h,0A0h,083h,0FBh
; @0B012 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,074h,01Dh,08Bh,0D3h,08Bh,05Eh,06h,0D1h,0E3h,02Eh,0FFh,0A7h,022h,0B0h,090h
; @0B022 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Dh,0B0h,0C9h,0B0h,0CCh,0B0h,039h,0B0h,03Ch,0B0h,0Ch,0B1h,0Fh,0B1h,07Ah,0B0h
; @0B032 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,030h,0A4h,01h,00h,0C3h,0E8h,090h,00h,08Bh,0DAh,083h,0EBh,0Dh,0E8h
; @0B042 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 017h,0A0h,075h,0ECh,0F7h,046h,04h,0Fh,00h,074h,06h,043h,0E8h,0Ah,0A0h,075h
; @0B052 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0FFh,046h,02h,0FFh,06h,038h,0A4h,053h,0E8h,072h,0Dh,05Bh,073h,09h,0FFh
; @0B062 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,02h,0FFh,0Eh,038h,0A4h,0EBh,0C8h,0FFh,06h,05Ah,021h,083h,026h,05Ah,021h
; @0B072 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Fh,074h,01h,0C3h,083h,0EAh,0Dh,0C3h,0E8h,092h,00h,08Bh,0DAh,0F7h,06h,05Ah
; @0B082 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,0Fh,00h,075h,015h,083h,0C3h,0Dh,0E8h,0CEh,09Fh,075h,0A3h,0F7h,046h,04h
; @0B092 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Fh,00h,074h,06h,043h,0E8h,0C1h,09Fh,075h,096h,0FFh,04Eh,02h,0FFh,0Eh,038h
; @0B0A2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,053h,0E8h,029h,0Dh,05Bh,073h,0Ah,0FFh,046h,02h,0FFh,06h,038h,0A4h,0E9h
; @0B0B2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,0FFh,0FFh,0Eh,05Ah,021h,083h,026h,05Ah,021h,0Fh,083h,03Eh,05Ah,021h,0Fh
; @0B0C2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,01h,0C3h,083h,0C2h,0Dh,0C3h,0E8h,0B1h,0FFh,08Bh,0DAh,043h,0E8h,089h,09Fh
; @0B0D2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,05Bh,0FFh,0F7h,06h,05Ah,021h,0Fh,00h,074h,0Bh,083h,0EBh,0Dh
; @0B0E2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,076h,09Fh,074h,03h,0E9h,048h,0FFh,0FFh,046h,04h,0FFh,06h,036h,0A4h,053h
; @0B0F2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0DBh,0Ch,05Bh,073h,0Ah,0FFh,04Eh,04h,0FFh,0Eh,036h,0A4h,0E9h,030h,0FFh
; @0B102 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F7h,046h,04h,0Fh,00h,074h,01h,0C3h,042h,0C3h,0E8h,02Dh,0FFh,08Bh,0DAh,0F7h
; @0B112 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,04h,0Fh,00h,075h,01Ch,04Bh,0E8h,03Fh,09Fh,074h,03h,0E9h,011h,0FFh,0F7h
; @0B122 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,05Ah,021h,0Fh,00h,074h,0Bh,083h,0EBh,0Dh,0E8h,02Ch,09Fh,074h,03h,0E9h
; @0B132 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FEh,0FEh,0FFh,04Eh,04h,0FFh,0Eh,036h,0A4h,053h,0E8h,091h,0Ch,05Bh,073h,0Ah
; @0B142 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,046h,04h,0FFh,06h,036h,0A4h,0E9h,0E6h,0FEh,08Bh,046h,04h,025h,0Fh,00h
; @0B152 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Dh,0Fh,00h,074h,01h,0C3h,04Ah,0C3h
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
    db 00h,0ACh,0E9h,015h,0FBh,0C7h,046h,01Ch,00h,00h,0E9h,0Dh,0FBh,0E8h,0F2h,0ABh
; @0B250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,01Eh,01h,074h,04Dh,0A1h,07Eh,023h,08Bh,01Eh,080h,023h,02Dh,02h,00h
; @0B260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 039h,046h,02h,07Ch,03Eh,05h,014h,00h,039h,046h,02h,07Fh,036h,039h,05Eh,04h
; @0B270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,031h,083h,0C3h,014h,039h,05Eh,04h,077h,029h,0B9h,01h,00h,083h,07Eh,018h
; @0B280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,075h,014h,083h,03Eh,0DCh,0BEh,00h,074h,0Dh,0B9h,03h,00h,083h,03Eh,0DCh
; @0B290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BEh,01h,074h,03h,0B9h,05h,00h,051h,055h,0E8h,07Dh,0EBh,05Dh,059h,0E2h,0F7h
; @0B2A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,026h,0FBh,0E9h,0B4h,0FAh,0A1h,03Ch,023h,05h,01Ch,00h,089h,046h,08h,083h
; @0B2B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,02Ch,023h,01Fh,075h,03h,0E8h,028h,08h,0E9h,047h,08h,0C7h,046h,036h,05Ch
; @0B2C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,0EBh,05h,0C7h,046h,036h,03Ch,0A4h,0C7h,046h,018h,012h,00h,08Bh,076h,036h
; @0B2D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,05h,020h,00h,0A3h,06h,023h,0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,01h
; @0B2E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,083h,03Eh,056h,023h,00h,074h,07h,083h,03Eh,0ACh,0BDh,01h,075h,06h,0C7h
; @0B2F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,08h,023h,02h,00h,0E8h,0BAh,0AAh,083h,03Eh,0Ah,023h,00h,074h,05h,089h
; @0B300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,036h,0EBh,0C9h,08Bh,046h,06h,05h,03Bh,00h,089h,046h,08h,083h,03Eh,0ACh
; @0B310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BDh,01h,075h,03h,0E9h,034h,09h,083h,03Eh,056h,023h,05h,074h,0Eh,083h,03Eh
; @0B320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 056h,023h,06h,074h,07h,083h,03Eh,056h,023h,00h,075h,031h,08Bh,046h,06h,05h
; @0B330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,01h,089h,046h,08h,081h,03Eh,050h,023h,052h,0Eh,074h,03h,0E9h,0Bh,09h
; @0B340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,06h,05h,05h,01h,089h,046h,08h,083h,03Eh,056h,023h,00h,075h,03h
; @0B350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0F8h,08h,083h,03Eh,056h,023h,06h,075h,03h,0E9h,0EEh,08h,08Bh,046h,06h
; @0B360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,02Ah,00h,089h,046h,08h,083h,03Eh,056h,023h,01h,075h,03h,0E9h,0DBh,08h
; @0B370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,06h,05h,0D2h,00h,089h,046h,08h,083h,03Eh,056h,023h,02h,075h,03h
; @0B380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0C8h,08h,08Bh,046h,06h,05h,0ECh,00h,089h,046h,08h,083h,03Eh,056h,023h
; @0B390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,075h,03h,0E9h,0B5h,08h,083h,03Eh,056h,023h,07h,075h,03h,0E9h,0ABh,08h
; @0B3A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,06h,05h,0ECh,00h,089h,046h,08h,083h,03Eh,056h,023h,04h,075h,03h
; @0B3B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,098h,08h,08Bh,046h,06h,05h,0ECh,00h,089h,046h,08h,0E9h,08Ch,08h,0A1h
; @0B3C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 042h,023h,040h,0D1h,0E8h,05h,071h,00h,089h,046h,08h,0C3h,0E8h,0F0h,0FFh,083h
; @0B3D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,02h,081h,07Eh,02h,0A0h,00h,073h,03h,0E9h,068h,08h,0EBh,01Ah,0E8h
; @0B3E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DDh,0FFh,0FFh,046h,02h,083h,03Eh,056h,023h,00h,075h,03h,0FFh,046h,02h,081h
; @0B3F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,02h,0A0h,00h,073h,03h,0E9h,04Ch,08h,0E8h,0CBh,0Bh,0E8h,03h,00h,0E9h
; @0B400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,08h,0BAh,0Ch,00h,083h,07Eh,014h,02h,074h,03h,0BAh,04h,00h,08Bh,046h
; @0B410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,03h,0C2h,0A3h,0B2h,0A8h,08Bh,046h,02h,03h,0C2h,0A3h,0B4h,0A8h,0B9h,08h
; @0B420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,051h,0E8h,04Eh,0C1h,059h,083h,0FBh,0FFh,074h,03Ch,051h,049h,089h,04Fh,06h
; @0B430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C1h,08h,089h,04Fh,08h,0A1h,0B2h,0A8h,089h,047h,04h,0A1h,0B4h,0A8h,089h
; @0B440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,02h,0C7h,07h,01h,00h,0C7h,047h,01Eh,00h,00h,0C7h,047h,0Ah,01h,00h
; @0B450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,014h,00h,00h,0C7h,047h,016h,02h,00h,0C7h,047h,018h,03h,00h,0C7h
; @0B460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,01Ch,0FFh,0FFh,059h,0E2h,0BAh,0C3h,055h,0B9h,023h,00h,033h,0C0h,051h,050h
; @0B470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0D9h,0D1h,0E3h,08Bh,0AFh,0CAh,032h,058h,083h,07Eh,00h,00h,074h,07h,083h
; @0B480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,016h,04h,075h,01h,040h,059h,0E2h,0E5h,05Dh,0C3h,083h,03Eh,0A0h,0A7h,032h
; @0B490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,03h,0E9h,080h,01h,083h,03Eh,0A0h,0A7h,05Ah,073h,03h,0E9h,0ACh,07h,0E9h
; @0B4A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 036h,01h,0E8h,0C3h,0FFh,03Dh,01h,00h,074h,03h,0E9h,09Eh,07h,0C7h,06h,0B6h
; @0B4B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A8h,00h,00h,0C7h,06h,0B8h,0A8h,00h,00h,0C7h,06h,0C2h,0A8h,01h,00h,0C7h
; @0B4C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0C4h,0A8h,0D4h,0D2h,0C7h,046h,018h,078h,00h,0C7h,046h,08h,022h,00h,0C7h
; @0B4D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,020h,0C8h,00h,0C7h,046h,04h,00h,00h,0C7h,046h,02h,00h,00h,0C7h,046h
; @0B4E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02h,00h,0C7h,046h,028h,0FFh,0FFh,089h,02Eh,0BEh,0A8h,0E8h,035h,0C0h,083h
; @0B4F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0FFh,074h,056h,09Ah,089h,08h,07Fh,0Fh,0C7h,047h,018h,076h,00h,0C7h,047h
; @0B500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,020h,00h,089h,01Eh,0BAh,0A8h,0E8h,01Ah,0C0h,083h,0FBh,0FFh,074h,03Bh,09Ah
; @0B510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,08h,07Fh,0Fh,0C7h,047h,018h,077h,00h,0C7h,047h,08h,021h,00h,0C7h,047h
; @0B520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,020h,00h,089h,01Eh,0BCh,0A8h,0E8h,0FAh,0BFh,083h,0FBh,0FFh,074h,01Bh,09Ah
; @0B530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,08h,07Fh,0Fh,0C7h,047h,018h,079h,00h,0C7h,047h,08h,023h,00h,0C7h,047h
; @0B540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,020h,00h,089h,01Eh,0C0h,0A8h,0E9h,01h,07h,0C7h,06h,07Eh,0A4h,00h,00h
; @0B550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,057h,0ADh,0E9h,0F5h,06h,083h,03Eh,056h,023h,04h,075h,03h,0E9h,023h,0D8h
; @0B560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,03h,075h,03h,0E9h,021h,0FFh,083h,03Eh,056h,023h,00h,075h
; @0B570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,02Eh,0FFh,081h,03Eh,0A0h,0A7h,0C8h,00h,073h,03h,0E9h,096h,00h,081h
; @0B580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0A0h,0A7h,0F0h,00h,073h,03h,0E9h,0C1h,06h,0C7h,046h,018h,022h,00h,0C7h
; @0B590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,071h,00h,08Bh,0Eh,056h,023h,041h,0B8h,0Ah,00h,0F7h,0E1h,089h,046h
; @0B5A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0C7h,046h,04h,060h,00h,0E9h,0A2h,06h
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
    db 00h,0E8h,022h,0A7h,0C7h,06h,012h,023h,03h,00h,0E9h,022h,05h,08Bh,046h,032h
; @0B72C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A3h,04h,023h,08Bh,046h,034h,0A3h,06h,023h,0E8h,07Ah,0A6h,083h,03Eh,0Ah,023h
; @0B73C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C3h,083h,07Eh,01Ch,0FFh,074h,04Dh,08Bh,05Eh,01Ch,0D1h,0E3h,02Eh,0FFh,0A7h
; @0B74C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,0B7h,054h,0B7h,070h,0B7h,07Bh,0B7h,08Bh,046h,04h,03Bh,046h,032h,074h,03h
; @0B75C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0FDh,00h,08Bh,046h,02h,03Bh,046h,034h,074h,03h,0E9h,0F2h,00h,0FFh,046h
; @0B76C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ch,0E9h,0DBh,04h,0C7h,046h,08h,079h,00h,0FFh,046h,01Ch,0E9h,0D0h,04h,083h
; @0B77C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,04h,081h,07Eh,02h,0A0h,00h,073h,03h,0E9h,0C2h,04h,0C7h,046h,08h
; @0B78C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,00h,0E9h,0BAh,04h,0A1h,038h,023h,083h,07Eh,04h,060h,073h,07h,0F7h,0D8h
; @0B79C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,07Fh,00h,0EBh,03h,05h,07Ah,00h,089h,046h,08h,08Bh,046h,04h,03Bh,046h
; @0B7AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,074h,03h,0E9h,0AAh,00h,08Bh,046h,02h,03Bh,046h,034h,074h,03h,0E9h,09Fh
; @0B7BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,083h,03Eh,0A0h,0A7h,023h,073h,02Fh,0E9h,084h,04h,083h,03Eh,024h,023h,01h
; @0B7CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,09h,0A1h,080h,023h,05h,08h,00h,089h,046h,032h,083h,066h,032h,0F8h,0C7h
; @0B7DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,040h,023h,028h,00h,0C7h,046h,01Ch,00h,00h,0C7h,046h,08h,078h,00h,0C7h
; @0B7EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,034h,020h,00h,0E9h,058h,04h,081h,03Eh,040h,023h,0BCh,02h,072h,013h,081h
; @0B7FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,040h,023h,0D0h,02h,077h,0Bh,0E8h,08Fh,095h,083h,0E3h,01h,075h,03h,0E8h
; @0B80C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 068h,0BCh,083h,03Eh,07Eh,0A4h,03h,076h,0B2h,083h,03Eh,040h,023h,05h,072h,0B2h
; @0B81C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,02Eh,023h,03Fh,074h,03h,0E9h,025h,04h,08Bh,036h,042h,0A8h,081h,0FEh
; @0B82C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 094h,0A8h,072h,0Ah,0C7h,06h,042h,0A8h,044h,0A8h,08Bh,036h,042h,0A8h,0ADh,05h
; @0B83C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,089h,046h,034h,0ADh,089h,046h,032h,089h,036h,042h,0A8h,08Bh,046h,02h
; @0B84C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,046h,034h,075h,08h,08Bh,046h,04h,03Bh,046h,032h,074h,0CDh,0E9h,0EFh,03h
; @0B85C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,08h,023h,02h,00h,0E8h,0C4h,0FEh,0C7h,046h,06h,04h,00h,0E9h,0DEh
; @0B86C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,083h,03Eh,07Eh,0A4h,02h,077h,03h,0E9h,081h,00h,081h,07Eh,02h,0C0h,00h
; @0B87C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,07Ah,083h,03Eh,0A0h,0A7h,028h,073h,02Bh,0C7h,06h,08h,023h,01h,00h,0C7h
; @0B88C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,075h,00h,083h,066h,032h,0FEh,083h,066h,04h,0FEh,083h,066h,034h,0FEh
; @0B89C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,066h,02h,0FEh,0E8h,086h,0FEh,075h,03h,0E9h,0A3h,03h,0C7h,046h,06h,04h
; @0B8AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E9h,09Bh,03h,081h,03Eh,040h,023h,0EFh,02h,075h,03h,0E8h,0BBh,0BBh,081h
; @0B8BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,040h,023h,059h,01h,075h,03h,0E8h,0B0h,0BBh,083h,03Eh,040h,023h,079h,075h
; @0B8CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E8h,0A6h,0BBh,0A1h,042h,023h,0F7h,0D8h,01h,046h,02h,0B8h,075h,00h,083h
; @0B8DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,042h,023h,0FFh,074h,03h,0B8h,076h,00h,089h,046h,08h,083h,03Eh,028h,023h
; @0B8EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,074h,03h,0E9h,059h,03h,0FFh,046h,02h,0E9h,053h,03h,0BBh,07Ch,023h,0E8h
; @0B8FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Dh,0A5h,0E8h,041h,0A5h,0C7h,046h,08h,076h,00h,0E9h,042h,03h,0C7h,06h,08h
; @0B90C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,02h,00h,0E8h,017h,0FEh,075h,03h,0E9h,034h,03h,0E8h,05Ch,0BBh,083h,07Eh
; @0B91C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,00h,074h,08h,0C7h,046h,032h,00h,00h,0E9h,023h,03h,0C7h,046h,032h,0C0h
; @0B92C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E9h,01Bh,03h,0C7h,06h,08h,023h,01h,00h,083h,03Eh,056h,023h,00h,075h
; @0B93C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0C7h,06h,08h,023h,02h,00h,0E8h,0E3h,0FDh,09Ch,08Bh,046h,06h,05h,0Dh
; @0B94C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,089h,046h,08h,09Dh,075h,03h,0E9h,0F5h,02h,083h,07Eh,01Ch,00h,074h,01Eh
; @0B95C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,04Eh,01Ch,074h,03h,0E9h,0E7h,02h,0C7h,046h,034h,020h,00h,083h,07Eh,018h
; @0B96C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 016h,075h,03h,0E9h,0D9h,02h,0C7h,046h,034h,040h,00h,0E9h,0D1h,02h,083h,03Eh
; @0B97C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,0A7h,031h,074h,03h,0E9h,0C7h,02h,0C7h,046h,018h,018h,00h,0E9h,0BFh,02h
; @0B98C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,040h,023h,025h,0FFh,03h,03Dh,0Ch,00h,075h,07h,0E8h,0DCh,0BAh,0FFh,06h
; @0B99C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,023h,08Bh,076h,036h,0ADh,03Dh,0FFh,0FFh,074h,043h,05h,020h,00h,0A3h,06h
; @0B9AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,03h,00h,0E8h,0F8h,0A3h,08Bh,046h
; @0B9BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,05h,0Dh,01h,089h,046h,08h,083h,03Eh,0Ah,023h,00h,075h,03h,0E9h,07Eh
; @0B9CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,089h,076h,036h,0E8h,0C2h,093h,083h,0E3h,07h,083h,0FBh,02h,075h,0B1h,0E8h
; @0B9DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 059h,08h,083h,0FBh,0FFh,074h,0A9h,0C7h,047h,06h,04h,00h,0EBh,0A2h,0ADh,089h
; @0B9EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,036h,0EBh,09Ch,081h,03Eh,082h,0A4h,0E4h,0A4h,075h,06Fh,081h,03Eh,040h,023h
; @0B9FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EFh,02h,075h,07h,0E8h,073h,0BAh,0FFh,06h,040h,023h,0A1h,042h,023h,01h,046h
; @0BA0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0A1h,046h,023h,01h,046h,034h,081h,07Eh,034h,0D0h,00h,076h,05h,0C7h,046h
; @0BA1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,020h,00h,08Bh,046h,04h,03h,06h,042h,023h,03Bh,046h,032h,075h,06Eh,08Bh
; @0BA2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,03Bh,046h,034h,075h,066h,083h,03Eh,07Eh,0A4h,06h,072h,020h,0A1h,040h
; @0BA3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,083h,03Eh,0DCh,0BEh,02h,074h,0Ah,025h,0FFh,00h,03Dh,0FFh,00h,075h,01Bh
; @0BA4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,08h,025h,07Fh,00h,03Dh,07Fh,00h,075h,011h,0FFh,06h,040h,023h,0BBh,07Ch
; @0BA5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,0E8h,0BBh,0A3h,0E8h,0DFh,0A3h,083h,046h,02h,02h,0A1h,03Ch,023h,05h,01Ch
; @0BA6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,089h,046h,08h,0E9h,0D8h,01h,08Bh,046h,032h,025h,0FEh,0FFh,083h,066h,04h
; @0BA7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FEh,0A3h,04h,023h,08Bh,046h,034h,025h,0FEh,0FFh,083h,066h,02h,0FEh,0A3h,06h
; @0BA8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,0C7h,06h,08h,023h,01h,00h,0E8h,01Ch,0A3h,0E9h,0B2h,01h,08Bh,046h,02h
; @0BA9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,046h,034h,076h,0D2h,0E8h,09Eh,0A3h,083h,03Eh,07Eh,0A4h,06h,073h,0Ah,083h
; @0BAAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,02Eh,023h,03Fh,075h,03h,0E8h,0C1h,0B9h,081h,07Eh,02h,0D0h,00h,077h,03h
; @0BABC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,08Ch,01h,0C7h,046h,02h,010h,00h,0E9h,084h,01h,0A1h,038h,023h,0D1h,0E8h
; @0BACC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,027h,00h,089h,046h,08h,0EBh,0Bh,0A1h,038h,023h,0D1h,0E8h,05h,024h,00h
; @0BADC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,0EBh,022h,0FFh,076h,06h,0C7h,046h,06h,04h,00h,0E8h,04Bh,07h
; @0BAEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Fh,046h,06h,0C3h,0A1h,03Ah,023h,05h,036h,00h,089h,046h,08h,083h,03Eh,02Eh
; @0BAFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,03Fh,075h,03h,0E8h,0DEh,0FFh,083h,07Eh,06h,06h,075h,01Bh,0C7h,046h,06h
; @0BB0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,00h,083h,07Eh,04h,00h,074h,08h,0E8h,0C1h,0F4h,075h,03h,0E9h,029h,01h
; @0BB1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,06h,02h,00h,0E9h,021h,01h,0C7h,046h,06h,02h,00h,081h,07Eh,04h
; @0BB2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,00h,074h,08h,0E8h,0A5h,0F4h,075h,03h,0E9h,0Dh,01h,0C7h,046h,06h,06h
; @0BB3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E9h,05h,01h,0C7h,06h,052h,0A9h,0FFh,0FFh,0EBh,06h,0C7h,06h,052h,0A9h
; @0BB4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,0E8h,09Ch,00h,0BBh,00h,00h,074h,0Ah,08Bh,01Eh,03Ch,023h,0D1h,0E3h
; @0BB5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,09Fh,0D2h,096h,0B8h,03Ah,01h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h
; @0BB6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,052h,0A9h,03h,0C3h,033h,0C9h,083h,07Eh,06h,00h,074h,03h,0B9h,03h,00h
; @0BB7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0C1h,0EBh,032h,0C7h,06h,052h,0A9h,0FFh,0FFh,0EBh,06h,0C7h,06h,052h,0A9h
; @0BB8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,0E8h,05Ch,00h,0BBh,00h,00h,074h,04h,08Bh,01Eh,03Ch,023h,0B8h,061h
; @0BB9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,06h,052h,0A9h,03h,06h,052h
; @0BBAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,03h,0C3h,03h,046h,06h,089h,046h,08h,083h,03Eh,030h,023h,07Fh,074h,0Eh
; @0BBBC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,030h,023h,06Bh,074h,07h,083h,03Eh,030h,023h,057h,075h,07Bh,0E8h,0A9h
; @0BBCC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,083h,0FBh,0FFh,074h,073h,0C7h,047h,08h,03h,00h,083h,06Fh,04h,08h,083h
; @0BBDC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Fh,02h,08h,0EBh,064h,0C7h,06h,030h,0A4h,01h,00h,083h,03Eh,030h,0A4h,01h
; @0BBEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,06h,030h,0A4h,00h,00h,0C7h,046h,06h,00h,00h,0FFh,076h,02h,0A1h
; @0BBFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 078h,0A2h,01h,046h,02h,083h,06Eh,02h,010h,0E8h,06Bh,094h,08Fh,046h,02h,083h
; @0BC0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0FFh,074h,0D1h,08Bh,046h,02h,03Bh,06h,07Eh,023h,07Ch,012h,03h,01Eh,052h
; @0BC1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,0E8h,03Bh,094h,074h,0BFh,0E8h,0B3h,0F3h,083h,03Eh,030h,0A4h,01h,0C3h,0C7h
; @0BC2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,04h,00h,03h,01Eh,052h,0A9h,083h,0EBh,0Dh,0E8h,021h,094h,074h,0A5h
; @0BC3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,099h,0F3h,083h,03Eh,030h,0A4h,01h,0C3h,0A1h,078h,0A2h,01h,046h,02h,0E8h
; @0BC4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,00h,083h,03Eh,07Ch,0A4h,00h,075h,041h,083h,07Eh,018h,00h,074h,03Bh,083h
; @0BC5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,018h,048h,074h,035h,083h,07Eh,018h,026h,074h,02Fh,081h,07Eh,018h,086h,00h
; @0BC6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,028h,083h,07Eh,018h,028h,074h,022h,083h,07Eh,018h,029h,074h,01Ch,083h,07Eh
; @0BC7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,034h,074h,016h,081h,07Eh,02h,040h,0FFh,07Dh,03h,0E9h,08Dh,00h,081h,07Eh
; @0BC8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0F0h,00h,07Ch,03h,0E9h,083h,00h,0EBh,0Dh,083h,07Eh,02h,0ECh,07Ch,07Bh
; @0BC9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,07Eh,02h,0F0h,00h,07Dh,074h,083h,03Eh,07Ch,0A4h,00h,075h,06h,0E8h,01Eh
; @0BCAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E8h,046h,0A6h,0C3h
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
; @0BCCB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,00h,00h,075h,01h,0C3h,083h,07Eh,016h,05h,075h,01h,0C3h,083h,07Eh
; @0BCDB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,00h,075h,01h,0C3h,083h,07Eh,018h,01h,075h,01h,0C3h,083h,07Eh,014h,01h
; @0BCEB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,083h,07Eh,014h,02h,074h,06h,0C3h,0E8h,04Fh,0EDh,0EBh,03h,0E8h,075h
; @0BCFB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EDh,072h,01h,0C3h,083h,03Eh,0C2h,0A8h,01h,074h,03h,0E8h,0BEh,02h,0E8h,05Dh
; @0BD0B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E1h,0C3h
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
; @0BDD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,0Ah,01h,074h,064h,0B9h,023h,00h,0BBh,0B4h,023h,0A1h,036h,0A4h,08Bh
; @0BDE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,038h,0A4h,083h,03Fh,00h,074h,04Dh,083h,07Fh,0Ah,01h,074h,047h,083h,07Fh
; @0BDF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,01h,075h,041h,083h,07Fh,016h,04h,075h,03Bh,081h,07Fh,018h,082h,00h,072h
; @0BE00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,081h,07Fh,018h,094h,00h,077h,02Dh,08Bh,077h,02h,083h,0C6h,010h,03Bh,0FEh
; @0BE10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Dh,023h,083h,0EEh,020h,03Bh,0FEh,07Eh,01Ch,08Bh,077h,04h,083h,0C6h,010h,03Bh
; @0BE20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,07Dh,012h,083h,0EEh,020h,03Bh,0C6h,07Eh,0Bh,08Bh,076h,0Eh,03Bh,077h,0Eh
; @0BE30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,024h,092h,083h,0C3h,038h,0E2h,0A9h,0F8h,0C3h,083h,03Eh,024h,023h
; @0BE40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,074h,03h,0E9h,0FFh,0FDh,0FFh,046h,022h,08Bh,05Eh,014h,0D1h,0E3h,02Eh,0FFh
; @0BE50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A7h,054h,0BEh,090h,045h,0BCh,05Ah,0BEh,0B0h,0BEh,083h,07Eh,022h,09h,075h,044h
; @0BE60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,01Ah,024h,074h,09h,083h,07Eh,01Ah,025h,074h,018h,0E9h,0A8h,0FEh,0C7h
; @0BE70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,06h,00h,0C7h,046h,018h,026h,00h,0C7h,046h,08h,097h,00h,083h,06Eh
; @0BE80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,08h,0EBh,013h,0C7h,046h,06h,02h,00h,0C7h,046h,018h,026h,00h,0C7h,046h
; @0BE90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,091h,00h,083h,046h,04h,08h,08Bh,046h,04h,089h,046h,032h,08Bh,046h,02h
; @0BEA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,034h,0C3h,08Bh,046h,022h,05h,00h,00h,089h,046h,08h,0E9h,095h,0FDh
; @0BEB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,022h,0Ch,075h,03h,0E9h,05Eh,0FEh,08Bh,046h,022h,05h,03h,00h,089h
; @0BEC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,0E9h,080h,0FDh,083h,07Fh,018h,07h,075h,03h,0E9h,0EBh,00h,083h,07Fh
; @0BED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,08h,075h,03h,0E9h,0E2h,00h,083h,07Fh,018h,0Ch,075h,03h,0E9h,0D9h,00h
; @0BEE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Fh,018h,09h,075h,03h,0E9h,0BFh,00h,083h,07Fh,018h,02h,074h,02Ch,083h
; @0BEF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,018h,06h,075h,03h,0E9h,09Fh,00h,083h,07Fh,018h,05h,075h,03h,0E9h,096h
; @0BF00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,06Fh,030h,074h,01h,0C3h,0C7h,047h,01Ch,00h,00h,083h,03Eh,0C2h,0A8h
; @0BF10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,074h,012h,0C7h,046h,020h,00h,00h,0E9h,0ACh,00h,0C7h,07h,00h,00h,083h
; @0BF20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,08h,033h,075h,08h,0FFh,04Eh,020h,075h,03h,0E9h,09Ah,00h,0FFh,04Eh,020h
; @0BF30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,092h,00h,083h,03Eh,0DCh,0BEh,01h,074h,011h,083h,03Eh,0DCh,0BEh
; @0BF40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,075h,0Fh,0FFh,04Eh,020h,074h,07Fh,0FFh,04Eh,020h,074h,07Ah,0FFh,04Eh,020h
; @0BF50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,075h,0C7h,046h,024h,05h,00h,083h,03Eh,0C2h,0A8h,01h,074h,01h,0C3h,055h
; @0BF60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,02Eh,0BAh,0A8h,0C7h,046h,024h,05h,00h,08Bh,02Eh,0BCh,0A8h,0C7h,046h,024h
; @0BF70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,08Bh,02Eh,0BEh,0A8h,0C7h,046h,024h,05h,00h,08Bh,02Eh,0C0h,0A8h,0C7h
; @0BF80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,024h,05h,00h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Eh
; @0BF90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Dh,0C3h,0E8h,078h,0FDh,0EBh,08Eh,0E8h,073h,0FDh,083h,03Eh,0C2h,0A8h,01h,074h
; @0BFA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 084h,0C7h,046h,020h,00h,00h,0EBh,01Fh,083h,03Eh,0C2h,0A8h,01h,075h,03h,0E9h
; @0BFB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,0FFh,0C7h,046h,020h,00h,00h,0EBh,0Eh,083h,03Eh,0C2h,0A8h,01h,074h,0D2h
; @0BFC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,020h,00h,00h,0EBh,00h
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
