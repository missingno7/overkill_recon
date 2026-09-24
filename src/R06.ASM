; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
include MOVEMENT.INC
part06 segment byte public 'CODE'
assume cs:part06,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
FindFreeRecordPoolB_07573 equ 0B573h
loc_0C253 equ 0253h
loc_0C25F equ 025Fh
loc_0C268 equ 0268h
loc_0C2AE equ 02AEh
loc_0C2B6 equ 02B6h
loc_0C2C4 equ 02C4h
loc_0C327 equ 0327h
loc_0C348 equ 0348h
loc_0C354 equ 0354h
loc_05DB2 equ 09DB2h
loc_08209 equ 0C209h
loc_09F5F equ 0DF5Fh
PlaceFourRecordsFromOffsetTables_09FAF equ 0DFAFh
loc_0BE97 equ 0FE97h
loc_0D193 equ 01193h
loc_0D1AB equ 011ABh
loc_0D235 equ 01235h
loc_0D269 equ 01269h
loc_0D2A4 equ 012A4h
loc_0D2B5 equ 012B5h
loc_0D5CC equ 015CCh
AdvanceABColonPrefix_0C80B equ 080Bh
ClearByteCS066B_00672 equ 04672h
LowercaseAsciiAL_0CA5B equ 0A5Bh
UppercaseAsciiAL_0C7FE equ 07FEh
WaitByteCS066B_00679 equ 04679h
XorCopy16BytesAA_0C9D3 equ 09D3h
loc_00162 equ 04162h
loc_00248 equ 04248h
loc_0073C equ 0473Ch
loc_007EF equ 047EFh
loc_00CB8 equ 04CB8h
loc_04CED equ 08CEDh
loc_04D64 equ 08D64h
loc_04F57 equ 08F57h
loc_04FC3 equ 08FC3h
loc_050C9 equ 090C9h
loc_0511F equ 0911Fh
loc_05145 equ 09145h
loc_05160 equ 09160h
loc_0518C equ 0918Ch
loc_0526A equ 0926Ah
loc_05A00 equ 09A00h
loc_05A24 equ 09A24h
loc_05A5A equ 09A5Ah
loc_05A6C equ 09A6Ch
loc_05BDC equ 09BDCh
loc_05BEE equ 09BEEh
loc_05C04 equ 09C04h
loc_05D0B equ 09D0Bh
loc_05F61 equ 09F61h
loc_060A2 equ 0A0A2h
loc_07420 equ 0B420h
FindFreeRecordPoolA_07524 equ 0B524h
loc_08517 equ 0C517h
loc_0859E equ 0C59Eh
InitPositionHistory_099BF equ 0D9BFh
StoreApplyHistoryAndConditionalPlacement_09BE2 equ 0DBE2h
loc_09DB9 equ 0DDB9h
loc_0A067 equ 0E067h
loc_0A212 equ 0E212h
loc_0A846 equ 0E846h
loc_0A90C equ 0E90Ch
loc_0A940 equ 0E940h
loc_0C027 equ 027h
loc_0C054 equ 054h
loc_0C05D equ 05Dh
loc_0C066 equ 066h
loc_0C06F equ 06Fh
loc_0C078 equ 078h
loc_0C081 equ 081h
loc_0C08A equ 08Ah
loc_0C093 equ 093h
loc_0C09C equ 09Ch
loc_0C0A5 equ 0A5h
loc_0C0AE equ 0AEh
loc_0C0B7 equ 0B7h
loc_0C0C0 equ 0C0h
loc_0C0CA equ 0CAh
loc_0C12D equ 012Dh
loc_0C14F equ 014Fh
loc_0C154 equ 0154h
loc_0C15B equ 015Bh
loc_0C166 equ 0166h
loc_0C171 equ 0171h
loc_0C17C equ 017Ch
loc_0C187 equ 0187h
loc_0C194 equ 0194h
loc_0C1A0 equ 01A0h
loc_0C3A6 equ 03A6h
loc_0C3BF equ 03BFh
loc_0C3F1 equ 03F1h
loc_0C41E equ 041Eh
loc_0C4DB equ 04DBh
loc_0C4E5 equ 04E5h
loc_0C565 equ 0565h
loc_0C591 equ 0591h
loc_0C59A equ 059Ah
loc_0C5BC equ 05BCh
loc_0C5BD equ 05BDh
loc_0C63A equ 063Ah
loc_0C648 equ 0648h
loc_0C64B equ 064Bh
loc_0C651 equ 0651h
loc_0C65F equ 065Fh
loc_0C665 equ 0665h
loc_0C669 equ 0669h
loc_0C685 equ 0685h
loc_0C68B equ 068Bh
loc_0C6A5 equ 06A5h
loc_0C6B4 equ 06B4h
loc_0C6B7 equ 06B7h
loc_0C6DC equ 06DCh
loc_0C700 equ 0700h
loc_0C707 equ 0707h
loc_0C710 equ 0710h
loc_0C713 equ 0713h
loc_0C71B equ 071Bh
loc_0C72D equ 072Dh
loc_0C737 equ 0737h
loc_0C769 equ 0769h
loc_0C77D equ 077Dh
loc_0C799 equ 0799h
loc_0C7B2 equ 07B2h
loc_0C7B8 equ 07B8h
loc_0C7C6 equ 07C6h
loc_0C7DE equ 07DEh
loc_0C7E1 equ 07E1h
loc_0C7FB equ 07FBh
loc_0C803 equ 0803h
loc_0C808 equ 0808h
loc_0C816 equ 0816h
loc_0C824 equ 0824h
loc_0C82C equ 082Ch
loc_0C830 equ 0830h
loc_0C838 equ 0838h
loc_0C843 equ 0843h
loc_0C855 equ 0855h
loc_0C85B equ 085Bh
loc_0C86D equ 086Dh
loc_0C886 equ 0886h
loc_0C8BD equ 08BDh
loc_0C8DC equ 08DCh
loc_0C916 equ 0916h
loc_0C925 equ 0925h
loc_0C980 equ 0980h
loc_0C992 equ 0992h
loc_0C99B equ 099Bh
loc_0C9D6 equ 09D6h
loc_0C9DD equ 09DDh
loc_0C9E9 equ 09E9h
loc_0C9F1 equ 09F1h
loc_0C9FC equ 09FCh
loc_0CA02 equ 0A02h
loc_0CA0D equ 0A0Dh
loc_0CA18 equ 0A18h
loc_0CA1D equ 0A1Dh
loc_0CA27 equ 0A27h
loc_0CA2D equ 0A2Dh
loc_0CA36 equ 0A36h
loc_0CA3C equ 0A3Ch
loc_0CA4C equ 0A4Ch
loc_0CA54 equ 0A54h
loc_0CA60 equ 0A60h
loc_0CA65 equ 0A65h
loc_0CAB0 equ 0AB0h
loc_0CACB equ 0ACBh
loc_0CAD2 equ 0AD2h
loc_0CAED equ 0AEDh
loc_0CAF4 equ 0AF4h
loc_0CB0F equ 0B0Fh
loc_0CB15 equ 0B15h
loc_0CB3D equ 0B3Dh
loc_0CB46 equ 0B46h
loc_0CB55 equ 0B55h
loc_0CB95 equ 0B95h
loc_0CBB4 equ 0BB4h
loc_0CBD2 equ 0BD2h
loc_0CBD5 equ 0BD5h
loc_0CBDD equ 0BDDh
loc_0CBE0 equ 0BE0h
loc_0CBFB equ 0BFBh
loc_0CBFE equ 0BFEh
loc_0CC04 equ 0C04h
loc_0CC4E equ 0C4Eh
loc_0CC4F equ 0C4Fh
loc_0CC58 equ 0C58h
loc_0CC76 equ 0C76h
loc_0CC7F equ 0C7Fh
loc_0CCAD equ 0CADh
loc_0CCBA equ 0CBAh
loc_0CCC7 equ 0CC7h
loc_0CCD4 equ 0CD4h
loc_0CCE4 equ 0CE4h
loc_0CCF3 equ 0CF3h
loc_0CD00 equ 0D00h
loc_0CD08 equ 0D08h
loc_0CD0F equ 0D0Fh
loc_0CD29 equ 0D29h
loc_0CD2B equ 0D2Bh
loc_0CD37 equ 0D37h
loc_0CD68 equ 0D68h
loc_0CD8D equ 0D8Dh
loc_0CDA3 equ 0DA3h
loc_0CDAA equ 0DAAh
loc_0CDC8 equ 0DC8h
loc_0CDD6 equ 0DD6h
loc_0CE02 equ 0E02h
loc_0CE07 equ 0E07h
loc_0CE10 equ 0E10h
loc_0CE13 equ 0E13h
loc_0CE21 equ 0E21h
loc_0CE24 equ 0E24h
loc_0CE31 equ 0E31h
loc_0CE36 equ 0E36h
loc_0CE39 equ 0E39h
loc_0CE40 equ 0E40h
loc_0CE48 equ 0E48h
loc_0CE59 equ 0E59h
loc_0CE5F equ 0E5Fh
loc_0CE62 equ 0E62h
loc_0CE97 equ 0E97h
loc_0CEBD equ 0EBDh
loc_0CF2E equ 0F2Eh
loc_0CF3E equ 0F3Eh
loc_0CF78 equ 0F78h
loc_0CF97 equ 0F97h
loc_0CF9C equ 0F9Ch
loc_0D007 equ 01007h
loc_0D040 equ 01040h
loc_0D04D equ 0104Dh
loc_0D0A4 equ 010A4h
loc_0D0B9 equ 010B9h
loc_0D0BE equ 010BEh
loc_0D0CA equ 010CAh
loc_0D0D4 equ 010D4h
loc_0D0DB equ 010DBh
loc_0D107 equ 01107h
loc_0D160 equ 01160h
loc_0D16A equ 0116Ah
loc_0D17C equ 0117Ch
loc_0D305 equ 01305h
loc_0D318 equ 01318h
loc_0D32C equ 0132Ch
loc_0D35C equ 0135Ch
loc_0D367 equ 01367h
loc_0D390 equ 01390h
loc_0D406 equ 01406h
loc_0D424 equ 01424h
loc_0D42F equ 0142Fh
loc_0D434 equ 01434h
loc_0D43B equ 0143Bh
loc_0D445 equ 01445h
loc_0D476 equ 01476h
loc_0D47C equ 0147Ch
loc_0D480 equ 01480h
loc_0D488 equ 01488h
loc_0D490 equ 01490h
loc_0D498 equ 01498h
loc_0D4A9 equ 014A9h
loc_0D4AA equ 014AAh
loc_0D521 equ 01521h
loc_0D548 equ 01548h
loc_0D553 equ 01553h
loc_0D565 equ 01565h
loc_0D566 equ 01566h
loc_0D56D equ 0156Dh
loc_0D57C equ 0157Ch
loc_0D5AC equ 015ACh
loc_0D5BB equ 015BBh
loc_0D5EB equ 015EBh
loc_0D5FB equ 015FBh
loc_0D602 equ 01602h
loc_0D611 equ 01611h
loc_0D612 equ 01612h
loc_0D61F equ 0161Fh
loc_0D62E equ 0162Eh
loc_0D62F equ 0162Fh
loc_0ECC9 equ 02CC9h
; @0C000 0000:C000 original=8b4604
    mov ax, word ptr ss:[bp + 4]
; @0C003 0000:C003 original=a37623
    mov word ptr ds:[02376h], ax
; @0C006 0000:C006 original=8b4602
    mov ax, word ptr ss:[bp + 2]
; @0C009 0000:C009 original=a37823
    mov word ptr ds:[02378h], ax
; @0C00C 0000:C00C original=8a4401
    mov al, byte ptr ds:[si + 1]
; @0C00F 0000:C00F original=32e4
    xor ah, ah
; @0C011 0000:C011 original=a37a23
    mov word ptr ds:[0237Ah], ax
; @0C014 0000:C014 original=e809b4
    CALL_NEAR loc_07420
; @0C017 0000:C017 original=5d
    pop bp
; @0C018 0000:C018 original=e83900
    CALL_NEAR loc_0C054
; @0C01B 0000:C01B original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0C020 0000:C020 original=7405
    JE_SHORT loc_0C027
; @0C022 0000:C022 original=c606ffbe19
    mov byte ptr ds:[0BEFFh], 019h
; @0C027 0000:C027 original=8b4618
    mov ax, word ptr ss:[bp + 018h]
; @0C02A 0000:C02A original=89461a
    mov word ptr ss:[bp + 01Ah], ax
; @0C02D 0000:C02D original=c746180100
    mov word ptr ss:[bp + 018h], 1
; @0C032 0000:C032 original=c746220000
    mov word ptr ss:[bp + 022h], 0
; @0C037 0000:C037 original=8b5e14
    mov bx, word ptr ss:[bp + 014h]
; @0C03A 0000:C03A original=d1e3
    shl bx, 1
; @0C03C 0000:C03C original=2effa742c0
    jmp word ptr cs:[bx - 03FBEh]
; @0C041 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0AFh,044h,048h,0C0h,04Eh,0C0h
; @0C048 0000:C048 original=c746080000 runtime CFG evidence
    mov word ptr ss:[bp + 8], 0
; @0C04D 0000:C04D original=c3 runtime CFG evidence
    ret
; @0C04E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,08h,03h,00h,0C3h
; sub_0000_C054
; @0C054 0000:C054 original=837e1876
    cmp word ptr ss:[bp + 018h], 076h
; @0C058 0000:C058 original=7503
    JNE_SHORT loc_0C05D
; @0C05A 0000:C05A original=e9fe00
    JMP_NEAR loc_0C15B
; @0C05D 0000:C05D original=837e1877
    cmp word ptr ss:[bp + 018h], 077h
; @0C061 0000:C061 original=7503
    JNE_SHORT loc_0C066
; @0C063 0000:C063 original=e9f500
    JMP_NEAR loc_0C15B
; @0C066 0000:C066 original=837e1878
    cmp word ptr ss:[bp + 018h], 078h
; @0C06A 0000:C06A original=7503
    JNE_SHORT loc_0C06F
; @0C06C 0000:C06C original=e9ec00
    JMP_NEAR loc_0C15B
; @0C06F 0000:C06F original=837e1879
    cmp word ptr ss:[bp + 018h], 079h
; @0C073 0000:C073 original=7503
    JNE_SHORT loc_0C078
; @0C075 0000:C075 original=e9e300
    JMP_NEAR loc_0C15B
; @0C078 0000:C078 original=837e1861
    cmp word ptr ss:[bp + 018h], 061h
; @0C07C 0000:C07C original=7503
    JNE_SHORT loc_0C081
; @0C07E 0000:C07E original=e9ce00
    JMP_NEAR loc_0C14F
; @0C081 0000:C081 original=837e1862
    cmp word ptr ss:[bp + 018h], 062h
; @0C085 0000:C085 original=7503
    JNE_SHORT loc_0C08A
; @0C087 0000:C087 original=e9c500
    JMP_NEAR loc_0C14F
; @0C08A 0000:C08A original=837e1865
    cmp word ptr ss:[bp + 018h], 065h
; @0C08E 0000:C08E original=7503
    JNE_SHORT loc_0C093
; @0C090 0000:C090 original=e9bc00
    JMP_NEAR loc_0C14F
; @0C093 0000:C093 original=837e1814
    cmp word ptr ss:[bp + 018h], 014h
; @0C097 0000:C097 original=7503
    JNE_SHORT loc_0C09C
; @0C099 0000:C099 original=e9b300
    JMP_NEAR loc_0C14F
; @0C09C 0000:C09C original=837e1816
    cmp word ptr ss:[bp + 018h], 016h
; @0C0A0 0000:C0A0 original=7503
    JNE_SHORT loc_0C0A5
; @0C0A2 0000:C0A2 original=e9aa00
    JMP_NEAR loc_0C14F
; @0C0A5 0000:C0A5 original=837e1817
    cmp word ptr ss:[bp + 018h], 017h
; @0C0A9 0000:C0A9 original=7503
    JNE_SHORT loc_0C0AE
; @0C0AB 0000:C0AB original=e9a100
    JMP_NEAR loc_0C14F
; @0C0AE 0000:C0AE original=837e1818
    cmp word ptr ss:[bp + 018h], 018h
; @0C0B2 0000:C0B2 original=7503
    JNE_SHORT loc_0C0B7
; @0C0B4 0000:C0B4 original=e99800
    JMP_NEAR loc_0C14F
; @0C0B7 0000:C0B7 original=837e187f
    cmp word ptr ss:[bp + 018h], 07Fh
; @0C0BB 0000:C0BB original=7503
    JNE_SHORT loc_0C0C0
; @0C0BD 0000:C0BD original=e98f00
    JMP_NEAR loc_0C14F
; @0C0C0 0000:C0C0 original=817e188000
    cmp word ptr ss:[bp + 018h], 080h
; @0C0C5 0000:C0C5 original=7503
    JNE_SHORT loc_0C0CA
; @0C0C7 0000:C0C7 original=e98500
    JMP_NEAR loc_0C14F
; @0C0CA 0000:C0CA original=817e188100
    cmp word ptr ss:[bp + 018h], 081h
; @0C0CF 0000:C0CF original=747e
    JE_SHORT loc_0C14F
; @0C0D1 0000:C0D1 original=817e189300
    cmp word ptr ss:[bp + 018h], 093h
; @0C0D6 0000:C0D6 original=747c
    JE_SHORT loc_0C154
; @0C0D8 0000:C0D8 original=837e181d
    cmp word ptr ss:[bp + 018h], 01Dh
; @0C0DC 0000:C0DC original=7471
    JE_SHORT loc_0C14F
; @0C0DE 0000:C0DE original=837e181e
    cmp word ptr ss:[bp + 018h], 01Eh
; @0C0E2 0000:C0E2 original=746b
    JE_SHORT loc_0C14F
; @0C0E4 0000:C0E4 original=837e1820
    cmp word ptr ss:[bp + 018h], 020h
; @0C0E8 0000:C0E8 original=7465
    JE_SHORT loc_0C14F
; @0C0EA 0000:C0EA original=837e1821
    cmp word ptr ss:[bp + 018h], 021h
; @0C0EE 0000:C0EE original=745f
    JE_SHORT loc_0C14F
; @0C0F0 0000:C0F0 original=837e1822
    cmp word ptr ss:[bp + 018h], 022h
; @0C0F4 0000:C0F4 original=7459
    JE_SHORT loc_0C14F
; @0C0F6 0000:C0F6 original=837e187e
    cmp word ptr ss:[bp + 018h], 07Eh
; @0C0FA 0000:C0FA original=b89ca7
    mov ax, 0A79Ch
; @0C0FD 0000:C0FD original=742e
    JE_SHORT loc_0C12D
; @0C0FF 0000:C0FF original=837e187d
    cmp word ptr ss:[bp + 018h], 07Dh
; @0C103 0000:C103 original=b8f0a6
    mov ax, 0A6F0h
; @0C106 0000:C106 original=7425
    JE_SHORT loc_0C12D
; @0C108 0000:C108 original=837e181f
    cmp word ptr ss:[bp + 018h], 01Fh
; @0C10C 0000:C10C original=b83ea8
    mov ax, 0A83Eh
; @0C10F 0000:C10F original=741c
    JE_SHORT loc_0C12D
; @0C111 0000:C111 original=837e181c
    cmp word ptr ss:[bp + 018h], 01Ch
; @0C115 0000:C115 original=b82aa8
    mov ax, 0A82Ah
; @0C118 0000:C118 original=7413
    JE_SHORT loc_0C12D
; @0C11A 0000:C11A original=837e1815
    cmp word ptr ss:[bp + 018h], 015h
; @0C11E 0000:C11E original=b8c0a5
    mov ax, 0A5C0h
; @0C121 0000:C121 original=740a
    JE_SHORT loc_0C12D
; @0C123 0000:C123 original=837e1813
    cmp word ptr ss:[bp + 018h], 013h
; @0C127 0000:C127 original=b8e4a4
    mov ax, 0A4E4h
; @0C12A 0000:C12A original=7401
    JE_SHORT loc_0C12D
; @0C12C 0000:C12C original=c3
    ret
; @0C12D 0000:C12D original=a382a4
    mov word ptr ds:[0A482h], ax
; @0C130 0000:C130 original=c70642a844a8
    mov word ptr ds:[0A842h], 0A844h
; @0C136 0000:C136 original=53
    push bx
; @0C137 0000:C137 original=55
    push bp
; @0C138 0000:C138 original=8b4604
    mov ax, word ptr ss:[bp + 4]
; @0C13B 0000:C13B original=a37623
    mov word ptr ds:[02376h], ax
; @0C13E 0000:C13E original=8b4602
    mov ax, word ptr ss:[bp + 2]
; @0C141 0000:C141 original=a37823
    mov word ptr ds:[02378h], ax
; @0C144 0000:C144 original=b80200
    mov ax, 2
; @0C147 0000:C147 original=a37a23
    mov word ptr ds:[0237Ah], ax
; @0C14A 0000:C14A original=e8d3b2
    CALL_NEAR loc_07420
; @0C14D 0000:C14D original=5d
    pop bp
; @0C14E 0000:C14E original=5b
    pop bx
; @0C14F 0000:C14F original=ff0e7ea4
    dec word ptr ds:[0A47Eh]
; @0C153 0000:C153 original=c3
    ret
; @0C154 0000:C154 original=c606a89801
    mov byte ptr ds:[098A8h], 1
; @0C159 0000:C159 original=ebf4
    JMP_SHORT loc_0C14F
; @0C15B 0000:C15B original=8b1ebaa8
    mov bx, word ptr ds:[0A8BAh]
; @0C15F 0000:C15F original=3bdd
    cmp bx, bp
; @0C161 0000:C161 original=7403
    JE_SHORT loc_0C166
; @0C163 0000:C163 original=e82e00
    CALL_NEAR loc_0C194
; @0C166 0000:C166 original=8b1ebca8
    mov bx, word ptr ds:[0A8BCh]
; @0C16A 0000:C16A original=3bdd
    cmp bx, bp
; @0C16C 0000:C16C original=7403
    JE_SHORT loc_0C171
; @0C16E 0000:C16E original=e82300
    CALL_NEAR loc_0C194
; @0C171 0000:C171 original=8b1ebea8
    mov bx, word ptr ds:[0A8BEh]
; @0C175 0000:C175 original=3bdd
    cmp bx, bp
; @0C177 0000:C177 original=7403
    JE_SHORT loc_0C17C
; @0C179 0000:C179 original=e81800
    CALL_NEAR loc_0C194
; @0C17C 0000:C17C original=8b1ec0a8
    mov bx, word ptr ds:[0A8C0h]
; @0C180 0000:C180 original=3bdd
    cmp bx, bp
; @0C182 0000:C182 original=7403
    JE_SHORT loc_0C187
; @0C184 0000:C184 original=e80d00
    CALL_NEAR loc_0C194
; @0C187 0000:C187 original=c7067ea40000
    mov word ptr ds:[0A47Eh], 0
; @0C18D 0000:C18D original=c706c2a80000
    mov word ptr ds:[0A8C2h], 0
; @0C193 0000:C193 original=c3
    ret
; sub_0000_C194
; @0C194 0000:C194 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0C199 0000:C199 original=7405
    JE_SHORT loc_0C1A0
; @0C19B 0000:C19B original=c606ffbe19
    mov byte ptr ds:[0BEFFh], 019h
; @0C1A0 0000:C1A0 original=8b4718
    mov ax, word ptr ds:[bx + 018h]
; @0C1A3 0000:C1A3 original=89471a
    mov word ptr ds:[bx + 01Ah], ax
; @0C1A6 0000:C1A6 original=c747180100
    mov word ptr ds:[bx + 018h], 1
; @0C1AB 0000:C1AB original=c747220000
    mov word ptr ds:[bx + 022h], 0
; @0C1B0 0000:C1B0 original=c747080300
    mov word ptr ds:[bx + 8], 3
; @0C1B5 0000:C1B5 original=c3
    ret
; @0C1B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,02h,0Bh,0C0h,079h,00h,0C7h,06h,054h,0A9h,00h,00h,08Bh,046h,04h
; @0C1C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,04h,00h,03Bh,06h,080h,023h,07Ch,0Bh,02Dh,02h,00h,03Bh,06h,080h,023h
; @0C1D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,0Ah,0EBh,0Eh,0C7h,06h,054h,0A9h,01h,00h,0EBh,06h,0C7h,06h,054h,0A9h
; @0C1E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,08Bh,046h,02h,02Dh,04h,00h,03Bh,06h,07Eh,023h,07Ch,0Bh,02Dh,02h
; @0C1F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,06h,07Eh,023h,07Fh,09h,0EBh,0Ch,083h,0Eh,054h,0A9h,04h,0EBh,05h
; @0C206 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0Eh,054h,0A9h,08h,0BBh,048h,0A3h,0A1h,054h,0A9h,0D7h,03Ch,0FFh,075h,01h
; @0C216 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,089h,046h,06h,0E9h,0BBh,0EDh,0E8h,053h,0B3h,083h,0FBh,0FFh,075h,01h,0C3h
; @0C226 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,04h,05h,0Ch,00h,089h,047h,04h,08Bh,046h,02h,05h,0Ch,00h,0EBh
; @0C236 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h
; @0C237 0000:C237 original=833edcbe02 runtime CFG evidence
    cmp word ptr ds:[0BEDCh], 2
; @0C23C 0000:C23C original=7421 runtime CFG evidence
    JE_SHORT loc_0C25F
; @0C23E 0000:C23E original=833edcbe01 runtime CFG evidence
    cmp word ptr ds:[0BEDCh], 1
; @0C243 0000:C243 original=740e runtime CFG evidence
    JE_SHORT loc_0C253
; @0C245 0000:C245 original=fe0656a9 runtime CFG evidence
    inc byte ptr ds:[0A956h]
; @0C249 0000:C249 original=802656a903 runtime CFG evidence
    and byte ptr ds:[0A956h], 3
; @0C24E 0000:C24E original=740f runtime CFG evidence
    JE_SHORT loc_0C25F
; @0C250 0000:C250 original=32c0 runtime CFG evidence
    xor al, al
; @0C252 0000:C252 original=c3 runtime CFG evidence
    ret
; @0C253 0000:C253 original=fe0656a9 runtime CFG evidence
    inc byte ptr ds:[0A956h]
; @0C257 0000:C257 original=802656a901 runtime CFG evidence
    and byte ptr ds:[0A956h], 1
; @0C25C 0000:C25C original=7501 runtime CFG evidence
    JNE_SHORT loc_0C25F
; @0C25E 0000:C25E original=c3 runtime CFG evidence
    ret
; @0C25F 0000:C25F original=e811b3 runtime CFG evidence
    CALL_NEAR FindFreeRecordPoolB_07573
; @0C262 0000:C262 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0C265 0000:C265 original=7501 runtime CFG evidence
    JNE_SHORT loc_0C268
; @0C267 0000:C267 original=c3 runtime CFG evidence
    ret
; @0C268 0000:C268 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0C26B 0000:C26B original=050400 runtime CFG evidence
    add ax, 4
; @0C26E 0000:C26E original=894704 runtime CFG evidence
    mov word ptr ds:[bx + 4], ax
; @0C271 0000:C271 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0C274 0000:C274 original=050400 runtime CFG evidence
    add ax, 4
; @0C277 0000:C277 original=894702 runtime CFG evidence
    mov word ptr ds:[bx + 2], ax
; @0C27A 0000:C27A original=8b4606 runtime CFG evidence
    mov ax, word ptr ss:[bp + 6]
; @0C27D 0000:C27D original=894706 runtime CFG evidence
    mov word ptr ds:[bx + 6], ax
; @0C280 0000:C280 original=c7070100 runtime CFG evidence
    mov word ptr ds:[bx], 1
; @0C284 0000:C284 original=c7471e0000 runtime CFG evidence
    mov word ptr ds:[bx + 01Eh], 0
; @0C289 0000:C289 original=c747083000 runtime CFG evidence
    mov word ptr ds:[bx + 8], 030h
; @0C28E 0000:C28E original=c7470a0000 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 0
; @0C293 0000:C293 original=c747140000 runtime CFG evidence
    mov word ptr ds:[bx + 014h], 0
; @0C298 0000:C298 original=c747160200 runtime CFG evidence
    mov word ptr ds:[bx + 016h], 2
; @0C29D 0000:C29D original=c747180400 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 4
; @0C2A2 0000:C2A2 original=c7471cffff runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 0FFFFh
; @0C2A7 0000:C2A7 original=837f0208 runtime CFG evidence
    cmp word ptr ds:[bx + 2], 8
; @0C2AB 0000:C2AB original=7301 runtime CFG evidence
    JAE_SHORT loc_0C2AE
; @0C2AD 0000:C2AD original=c3 runtime CFG evidence
    ret
; @0C2AE 0000:C2AE original=817e02e000 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 0E0h
; @0C2B3 0000:C2B3 original=7601 runtime CFG evidence
    JBE_SHORT loc_0C2B6
; @0C2B5 0000:C2B5 original=c3 runtime CFG evidence
    ret
; @0C2B6 0000:C2B6 original=8bc3 runtime CFG evidence
    mov ax, bx
; @0C2B8 0000:C2B8 original=8b5e18 runtime CFG evidence
    mov bx, word ptr ss:[bp + 018h]
; @0C2BB 0000:C2BB original=81fb9200 runtime CFG evidence
    cmp bx, 092h
; @0C2BF 0000:C2BF original=7503 runtime CFG evidence
    JNE_SHORT loc_0C2C4
; @0C2C1 0000:C2C1 original=e98400 runtime CFG evidence
    JMP_NEAR loc_0C348
; @0C2C4 0000:C2C4 original=83e30f runtime CFG evidence
    and bx, 0Fh
; @0C2C7 0000:C2C7 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0C2C9 0000:C2C9 original=2effa7cec2 runtime CFG evidence
    jmp word ptr cs:[bx - 03D32h]
; @0C2CE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EEh,0C2h,0FDh,0C2h,0Ch,0C3h,01Bh,0C3h,02Ah,0C3h,039h,0C3h,048h,0C3h,057h,0C3h
; @0C2DE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,0C3h,075h,0C3h,084h,0C3h,093h,0C3h,039h,0C3h,048h,0C3h,075h,0C3h,066h,0C3h
; @0C2EE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Bh,08Bh,0D8h,0C3h,080h
; @0C2FE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Ch,08Bh,0D8h,0C3h,080h,03Eh
; @0C30E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Eh,08Bh,0D8h,0C3h
; @0C31B 0000:C31B original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0C320 0000:C320 original=7405 runtime CFG evidence
    JE_SHORT loc_0C327
; @0C322 0000:C322 original=c606ffbe11 runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 011h
; @0C327 0000:C327 original=8bd8 runtime CFG evidence
    mov bx, ax
; @0C329 0000:C329 original=c3 runtime CFG evidence
    ret
; @0C32A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,012h,08Bh,0D8h,0C3h,080h
; @0C33A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,013h,08Bh,0D8h,0C3h
; @0C348 0000:C348 original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0C34D 0000:C34D original=7405 runtime CFG evidence
    JE_SHORT loc_0C354
; @0C34F 0000:C34F original=c606ffbe14 runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 014h
; @0C354 0000:C354 original=8bd8 runtime CFG evidence
    mov bx, ax
; @0C356 0000:C356 original=c3 runtime CFG evidence
    ret
; @0C357 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,015h,08Bh,0D8h,0C3h,080h
; @0C367 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Ah,08Bh,0D8h,0C3h,080h,03Eh
; @0C377 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Bh,08Bh,0D8h,0C3h,080h,03Eh,0C0h
; @0C387 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,08Bh,0D8h,0C3h,080h,03Eh,0C0h,098h
; @0C397 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,05h,0C6h,06h,0FFh,0BEh,018h,08Bh,0D8h,0C3h,00h,00h,00h,00h
; sub_0000_C3A6
; @0C3A6 0000:C3A6 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0C3AB 0000:C3AB original=bf7820
    mov di, 02078h
; @0C3AE 0000:C3AE original=b91000
    mov cx, 010h
; @0C3B1 0000:C3B1 original=33c0
    xor ax, ax
; @0C3B3 0000:C3B3 original=f3ab
    rep stosw
; @0C3B5 0000:C3B5 original=2ec706a2c3588d
    mov word ptr cs:[0C3A2h], 08D58h
; @0C3BC 0000:C3BC original=b92200
    mov cx, 022h
; @0C3BF 0000:C3BF original=51
    push cx
; @0C3C0 0000:C3C0 original=8bd9
    mov bx, cx
; @0C3C2 0000:C3C2 original=d1e3
    shl bx, 1
; @0C3C4 0000:C3C4 original=8baf128d
    mov bp, word ptr ds:[bx - 072EEh]
; @0C3C8 0000:C3C8 original=c746000000
    mov word ptr ss:[bp], 0
; @0C3CD 0000:C3CD original=c7462e0000
    mov word ptr ss:[bp + 02Eh], 0
; @0C3D2 0000:C3D2 original=c746180000
    mov word ptr ss:[bp + 018h], 0
; @0C3D7 0000:C3D7 original=2ea1a2c3
    mov ax, word ptr cs:[0C3A2h]
; @0C3DB 0000:C3DB original=89460e
    mov word ptr ss:[bp + 0Eh], ax
; @0C3DE 0000:C3DE original=2e8306a2c340
    add word ptr cs:[0C3A2h], 040h
; @0C3E4 0000:C3E4 original=59
    pop cx
; @0C3E5 0000:C3E5 original=e2d8
    LOOP_SHORT loc_0C3BF
; @0C3E7 0000:C3E7 original=2ec706a2c31433
    mov word ptr cs:[0C3A2h], 03314h
; @0C3EE 0000:C3EE original=b92400
    mov cx, 024h
; @0C3F1 0000:C3F1 original=51
    push cx
; @0C3F2 0000:C3F2 original=8bd9
    mov bx, cx
; @0C3F4 0000:C3F4 original=d1e3
    shl bx, 1
; @0C3F6 0000:C3F6 original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @0C3FA 0000:C3FA original=c7460a0100
    mov word ptr ss:[bp + 0Ah], 1
; @0C3FF 0000:C3FF original=837e1601
    cmp word ptr ss:[bp + 016h], 1
; @0C403 0000:C403 original=7419
    JE_SHORT loc_0C41E
; @0C405 0000:C405 original=c746000000
    mov word ptr ss:[bp], 0
; @0C40A 0000:C40A original=c7462e0000
    mov word ptr ss:[bp + 02Eh], 0
; @0C40F 0000:C40F original=c746240000
    mov word ptr ss:[bp + 024h], 0
; @0C414 0000:C414 original=c746180000
    mov word ptr ss:[bp + 018h], 0
; @0C419 0000:C419 original=c746060000
    mov word ptr ss:[bp + 6], 0
; @0C41E 0000:C41E original=2ea1a2c3
    mov ax, word ptr cs:[0C3A2h]
; @0C422 0000:C422 original=89460e
    mov word ptr ss:[bp + 0Eh], ax
; @0C425 0000:C425 original=2e8106a2c38002
    add word ptr cs:[0C3A2h], 0280h
; @0C42C 0000:C42C original=59
    pop cx
; @0C42D 0000:C42D original=e2c2
    LOOP_SHORT loc_0C3F1
; @0C42F 0000:C42F original=bd7c23
    mov bp, 0237Ch
; @0C432 0000:C432 original=c746000100
    mov word ptr ss:[bp], 1
; @0C437 0000:C437 original=c746160300
    mov word ptr ss:[bp + 016h], 3
; @0C43C 0000:C43C original=c746140200
    mov word ptr ss:[bp + 014h], 2
; @0C441 0000:C441 original=c74602c000
    mov word ptr ss:[bp + 2], 0C0h
; @0C446 0000:C446 original=c746045800
    mov word ptr ss:[bp + 4], 058h
; @0C44B 0000:C44B original=c7460a0100
    mov word ptr ss:[bp + 0Ah], 1
; @0C450 0000:C450 original=e8d1b0
    CALL_NEAR FindFreeRecordPoolA_07524
; @0C453 0000:C453 original=c7070100
    mov word ptr ds:[bx], 1
; @0C457 0000:C457 original=c747140100
    mov word ptr ds:[bx + 014h], 1
; @0C45C 0000:C45C original=c747160600
    mov word ptr ds:[bx + 016h], 6
; @0C461 0000:C461 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0C466 0000:C466 original=bfb4a3
    mov di, 0A3B4h
; @0C469 0000:C469 original=b8ffff
    mov ax, 0FFFFh
; @0C46C 0000:C46C original=b91a00
    mov cx, 01Ah
; @0C46F 0000:C46F original=f3ab
    rep stosw
; @0C471 0000:C471 original=c7065aa90300
    mov word ptr ds:[0A95Ah], 3
; @0C477 0000:C477 original=c7065ca91800
    mov word ptr ds:[0A95Ch], 018h
; @0C47D 0000:C47D original=c70670a90000
    mov word ptr ds:[0A970h], 0
; @0C483 0000:C483 original=c70672a90000
    mov word ptr ds:[0A972h], 0
; @0C489 0000:C489 original=c70674a90000
    mov word ptr ds:[0A974h], 0
; @0C48F 0000:C48F original=c70676a90000
    mov word ptr ds:[0A976h], 0
; @0C495 0000:C495 original=c7067aa90000
    mov word ptr ds:[0A97Ah], 0
; @0C49B 0000:C49B original=c7067ea90000
    mov word ptr ds:[0A97Eh], 0
; @0C4A1 0000:C4A1 original=c7069aa30000
    mov word ptr ds:[OFFSET_X_GROUP_A], 0
; @0C4A7 0000:C4A7 original=c7069ca30000
    mov word ptr ds:[OFFSET_X_GROUP_B], 0
; @0C4AD 0000:C4AD original=c7068897ffff
    mov word ptr ds:[09788h], 0FFFFh
; @0C4B3 0000:C4B3 original=e803d9
    CALL_NEAR loc_09DB9
; @0C4B6 0000:C4B6 original=c70680a90000
    mov word ptr ds:[0A980h], 0
; @0C4BC 0000:C4BC original=c706a620a820
    mov word ptr ds:[020A6h], 020A8h
; @0C4C2 0000:C4C2 original=c7067ea40000
    mov word ptr ds:[0A47Eh], 0
; @0C4C8 0000:C4C8 original=c70680a40000
    mov word ptr ds:[0A480h], 0
; @0C4CE 0000:C4CE original=c7067ca40000
    mov word ptr ds:[0A47Ch], 0
; @0C4D4 0000:C4D4 original=c70640230000
    mov word ptr ds:[02340h], 0
; @0C4DA 0000:C4DA original=c3
    ret
; sub_0000_C4DB
; @0C4DB 0000:C4DB original=2ec706a2c31433
    mov word ptr cs:[0C3A2h], 03314h
; @0C4E2 0000:C4E2 original=b92400
    mov cx, 024h
; @0C4E5 0000:C4E5 original=51
    push cx
; @0C4E6 0000:C4E6 original=8bd9
    mov bx, cx
; @0C4E8 0000:C4E8 original=d1e3
    shl bx, 1
; @0C4EA 0000:C4EA original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @0C4EE 0000:C4EE original=c746000000
    mov word ptr ss:[bp], 0
; @0C4F3 0000:C4F3 original=c7462e0000
    mov word ptr ss:[bp + 02Eh], 0
; @0C4F8 0000:C4F8 original=c746240000
    mov word ptr ss:[bp + 024h], 0
; @0C4FD 0000:C4FD original=c746180000
    mov word ptr ss:[bp + 018h], 0
; @0C502 0000:C502 original=c7460a0100
    mov word ptr ss:[bp + 0Ah], 1
; @0C507 0000:C507 original=c746060000
    mov word ptr ss:[bp + 6], 0
; @0C50C 0000:C50C original=2ea1a2c3
    mov ax, word ptr cs:[0C3A2h]
; @0C510 0000:C510 original=89460e
    mov word ptr ss:[bp + 0Eh], ax
; @0C513 0000:C513 original=2e8106a2c38002
    add word ptr cs:[0C3A2h], 0280h
; @0C51A 0000:C51A original=59
    pop cx
; @0C51B 0000:C51B original=e2c8
    LOOP_SHORT loc_0C4E5
; @0C51D 0000:C51D original=c70658a90000
    mov word ptr ds:[0A958h], 0
; @0C523 0000:C523 original=c7065ea90000
    mov word ptr ds:[0A95Eh], 0
; @0C529 0000:C529 original=c70660a90000
    mov word ptr ds:[0A960h], 0
; @0C52F 0000:C52F original=c70662a9ffff
    mov word ptr ds:[0A962h], 0FFFFh
; @0C535 0000:C535 original=c70664a9ffff
    mov word ptr ds:[0A964h], 0FFFFh
; @0C53B 0000:C53B original=c70666a9ffff
    mov word ptr ds:[0A966h], 0FFFFh
; @0C541 0000:C541 original=c70668a9ffff
    mov word ptr ds:[0A968h], 0FFFFh
; @0C547 0000:C547 original=c7066aa9ffff
    mov word ptr ds:[0A96Ah], 0FFFFh
; @0C54D 0000:C54D original=c7066ca9ffff
    mov word ptr ds:[0A96Ch], 0FFFFh
; @0C553 0000:C553 original=c7066ea9ffff
    mov word ptr ds:[0A96Eh], 0FFFFh
; @0C559 0000:C559 original=c70684230000
    mov word ptr ds:[02384h], 0
; @0C55F 0000:C55F original=e8b5bf
    CALL_NEAR loc_08517
; @0C562 0000:C562 original=e939c0
    JMP_NEAR loc_0859E
; @0C565 0000:C565 original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @0C569 0000:C569 original=d1e3
    shl bx, 1
; @0C56B 0000:C56B original=2effa770c5
    jmp word ptr cs:[bx - 03A90h]
; @0C570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 037h,04Fh,0C3h,04Fh,057h,04Fh,0C3h,04Fh,037h,04Fh,057h,04Fh
; sub_0000_C57C
; @0C57C 0000:C57C original=2e833ebc9500
    cmp word ptr cs:[095BCh], 0
; @0C582 0000:C582 original=74e1
    JE_SHORT loc_0C565
; @0C584 0000:C584 original=be85a9
    mov si, 0A985h
; @0C587 0000:C587 original=833e562301
    cmp word ptr ds:[02356h], 1
; @0C58C 0000:C58C original=7403
    JE_SHORT loc_0C591
; @0C58E 0000:C58E original=be82a9
    mov si, 0A982h
; sub_0000_C591
; @0C591 0000:C591 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @0C597 0000:C597 original=7401
    JE_SHORT loc_0C59A
; @0C599 0000:C599 original=c3
    ret
; @0C59A 0000:C59A original=fa
    cli
; @0C59B 0000:C59B original=bac803
    mov dx, 03C8h
; @0C59E 0000:C59E original=b006
    mov al, 6
; @0C5A0 0000:C5A0 original=ee
    out dx, al
; @0C5A1 0000:C5A1 original=42
    inc dx
; @0C5A2 0000:C5A2 original=ac
    lodsb
; @0C5A3 0000:C5A3 original=ee
    out dx, al
; @0C5A4 0000:C5A4 original=ac
    lodsb
; @0C5A5 0000:C5A5 original=ee
    out dx, al
; @0C5A6 0000:C5A6 original=ac
    lodsb
; @0C5A7 0000:C5A7 original=ee
    out dx, al
; @0C5A8 0000:C5A8 original=bac803
    mov dx, 03C8h
; @0C5AB 0000:C5AB original=ec
    in al, dx
; @0C5AC 0000:C5AC original=fb
    sti
; @0C5AD 0000:C5AD original=3c07
    cmp al, 7
; @0C5AF 0000:C5AF original=c3
    ret
; @0C5B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; sub_0000_C5B1
; @0C5B1 0000:C5B1 original=e80900
    CALL_NEAR loc_0C5BD
; @0C5B4 0000:C5B4 original=7506
    JNE_SHORT loc_0C5BC
; @0C5B6 0000:C5B6 original=2ec606b0c501
    mov byte ptr cs:[0C5B0h], 1
; @0C5BC 0000:C5BC original=c3
    ret
; sub_0000_C5BD
; @0C5BD 0000:C5BD original=fa
    cli
; @0C5BE 0000:C5BE original=bac803
    mov dx, 03C8h
; @0C5C1 0000:C5C1 original=b000
    mov al, 0
; @0C5C3 0000:C5C3 original=ee
    out dx, al
; @0C5C4 0000:C5C4 original=42
    inc dx
; @0C5C5 0000:C5C5 original=b000
    mov al, 0
; @0C5C7 0000:C5C7 original=ee
    out dx, al
; @0C5C8 0000:C5C8 original=b000
    mov al, 0
; @0C5CA 0000:C5CA original=ee
    out dx, al
; @0C5CB 0000:C5CB original=b000
    mov al, 0
; @0C5CD 0000:C5CD original=ee
    out dx, al
; @0C5CE 0000:C5CE original=bac803
    mov dx, 03C8h
; @0C5D1 0000:C5D1 original=ec
    in al, dx
; @0C5D2 0000:C5D2 original=fb
    sti
; @0C5D3 0000:C5D3 original=3c01
    cmp al, 1
; @0C5D5 0000:C5D5 original=c3
    ret
; sub_0000_C5D6
; @0C5D6 0000:C5D6 original=ba28b9
    mov dx, 0B928h
; @0C5D9 0000:C5D9 original=b8003d
    mov ax, 03D00h
; @0C5DC 0000:C5DC original=cd21
    int 021h
; @0C5DE 0000:C5DE original=725a
    JB_SHORT loc_0C63A
; @0C5E0 0000:C5E0 original=8bd8
    mov bx, ax
; @0C5E2 0000:C5E2 original=b80044
    mov ax, 04400h
; @0C5E5 0000:C5E5 original=cd21
    int 021h
; @0C5E7 0000:C5E7 original=7251
    JB_SHORT loc_0C63A
; @0C5E9 0000:C5E9 original=81e28000
    and dx, 080h
; @0C5ED 0000:C5ED original=744b
    JE_SHORT loc_0C63A
; @0C5EF 0000:C5EF original=b80744
    mov ax, 04407h
; @0C5F2 0000:C5F2 original=cd21
    int 021h
; @0C5F4 0000:C5F4 original=7244
    JB_SHORT loc_0C63A
; @0C5F6 0000:C5F6 original=0ac0
    or al, al
; @0C5F8 0000:C5F8 original=7440
    JE_SHORT loc_0C63A
; @0C5FA 0000:C5FA original=b43e
    mov ah, 03Eh
; @0C5FC 0000:C5FC original=cd21
    int 021h
; @0C5FE 0000:C5FE original=723a
    JB_SHORT loc_0C63A
; @0C600 0000:C600 original=b440
    mov ah, 040h
; @0C602 0000:C602 original=cd67
    int 067h
; @0C604 0000:C604 original=0ae4
    or ah, ah
; @0C606 0000:C606 original=7532
    JNE_SHORT loc_0C63A
; @0C608 0000:C608 original=b446
    mov ah, 046h
; @0C60A 0000:C60A original=cd67
    int 067h
; @0C60C 0000:C60C original=0ae4
    or ah, ah
; @0C60E 0000:C60E original=752a
    JNE_SHORT loc_0C63A
; @0C610 0000:C610 original=3c30
    cmp al, 030h
; @0C612 0000:C612 original=7226
    JB_SHORT loc_0C63A
; @0C614 0000:C614 original=b441
    mov ah, 041h
; @0C616 0000:C616 original=cd67
    int 067h
; @0C618 0000:C618 original=0ae4
    or ah, ah
; @0C61A 0000:C61A original=751e
    JNE_SHORT loc_0C63A
; @0C61C 0000:C61C original=891e32b9
    mov word ptr ds:[0B932h], bx
; @0C620 0000:C620 original=b442
    mov ah, 042h
; @0C622 0000:C622 original=cd67
    int 067h
; @0C624 0000:C624 original=0ae4
    or ah, ah
; @0C626 0000:C626 original=7512
    JNE_SHORT loc_0C63A
; @0C628 0000:C628 original=891634b9
    mov word ptr ds:[0B934h], dx
; @0C62C 0000:C62C original=891e36b9
    mov word ptr ds:[0B936h], bx
; @0C630 0000:C630 original=0bdb
    or bx, bx
; @0C632 0000:C632 original=7406
    JE_SHORT loc_0C63A
; @0C634 0000:C634 original=c60631b901
    mov byte ptr ds:[0B931h], 1
; @0C639 0000:C639 original=c3
    ret
; @0C63A 0000:C63A original=c60631b900
    mov byte ptr ds:[0B931h], 0
; @0C63F 0000:C63F original=c3
    ret
; sub_0000_C640
; @0C640 0000:C640 original=803e31b900
    cmp byte ptr ds:[0B931h], 0
; @0C645 0000:C645 original=7501
    JNE_SHORT loc_0C648
; @0C647 0000:C647 original=c3
    ret
; @0C648 0000:C648 original=be3ab9
    mov si, 0B93Ah
; @0C64B 0000:C64B original=833cff
    cmp word ptr ds:[si], -1
; @0C64E 0000:C64E original=7501
    JNE_SHORT loc_0C651
; @0C650 0000:C650 original=c3
    ret
; @0C651 0000:C651 original=56
    push si
; @0C652 0000:C652 original=837c02ff
    cmp word ptr ds:[si + 2], -1
; @0C656 0000:C656 original=7507
    JNE_SHORT loc_0C65F
; @0C658 0000:C658 original=8b5406
    mov dx, word ptr ds:[si + 6]
; @0C65B 0000:C65B original=b445
    mov ah, 045h
; @0C65D 0000:C65D original=cd67
    int 067h
; @0C65F 0000:C65F original=5e
    pop si
; @0C660 0000:C660 original=83c60a
    add si, 0Ah
; @0C663 0000:C663 original=ebe6
    JMP_SHORT loc_0C64B
; sub_0000_C665
; @0C665 0000:C665 original=8bcb
    mov cx, bx
; @0C667 0000:C667 original=33c0
    xor ax, ax
; @0C669 0000:C669 original=50
    push ax
; @0C66A 0000:C66A original=51
    push cx
; @0C66B 0000:C66B original=52
    push dx
; @0C66C 0000:C66C original=8bd8
    mov bx, ax
; @0C66E 0000:C66E original=b444
    mov ah, 044h
; @0C670 0000:C670 original=cd67
    int 067h
; @0C672 0000:C672 original=5a
    pop dx
; @0C673 0000:C673 original=59
    pop cx
; @0C674 0000:C674 original=58
    pop ax
; @0C675 0000:C675 original=40
    inc ax
; @0C676 0000:C676 original=e2f1
    LOOP_SHORT loc_0C669
; @0C678 0000:C678 original=c3
    ret
; sub_0000_C679
; @0C679 0000:C679 original=c70680bb0000
    mov word ptr ds:[0BB80h], 0
; @0C67F 0000:C67F original=e83001
    CALL_NEAR loc_0C7B2
; @0C682 0000:C682 original=7501
    JNE_SHORT loc_0C685
; @0C684 0000:C684 original=c3
    ret
; @0C685 0000:C685 original=c70682bb0000
    mov word ptr ds:[0BB82h], 0
; @0C68B 0000:C68B original=e87d01
    CALL_NEAR AdvanceABColonPrefix_0C80B
; @0C68E 0000:C68E original=e8ca01
    CALL_NEAR loc_0C85B
; @0C691 0000:C691 original=7512
    JNE_SHORT loc_0C6A5
; @0C693 0000:C693 original=8b16aa21
    mov dx, word ptr ds:[021AAh]
; @0C697 0000:C697 original=32c0
    xor al, al
; @0C699 0000:C699 original=b43d
    mov ah, 03Dh
; @0C69B 0000:C69B original=9ad7043a15
    CALL_FAR 0153Ah,04D7h
; @0C6A0 0000:C6A0 original=a3ac21
    mov word ptr ds:[021ACh], ax
; @0C6A3 0000:C6A3 original=7312
    JAE_SHORT loc_0C6B7
; @0C6A5 0000:C6A5 original=803ec59801
    cmp byte ptr ds:[098C5h], 1
; @0C6AA 0000:C6AA original=7408
    JE_SHORT loc_0C6B4
; @0C6AC 0000:C6AC original=b419
    mov ah, 019h
; @0C6AE 0000:C6AE original=cd21
    int 021h
; @0C6B0 0000:C6B0 original=3c02
    cmp al, 2
; @0C6B2 0000:C6B2 original=72d7
    JB_SHORT loc_0C68B
; @0C6B4 0000:C6B4 original=e95496
    JMP_NEAR loc_05D0B
; @0C6B7 0000:C6B7 original=803e84bb00
    cmp byte ptr ds:[0BB84h], 0
; @0C6BC 0000:C6BC original=741e
    JE_SHORT loc_0C6DC
; @0C6BE 0000:C6BE original=a1ac21
    mov ax, word ptr ds:[021ACh]
; @0C6C1 0000:C6C1 original=2ea366d6
    mov word ptr cs:[0D666h], ax
; @0C6C5 0000:C6C5 original=a1a421
    mov ax, word ptr ds:[021A4h]
; @0C6C8 0000:C6C8 original=2ea3f0ec
    mov word ptr cs:[0ECF0h], ax
; @0C6CC 0000:C6CC original=a1a621
    mov ax, word ptr ds:[021A6h]
; @0C6CF 0000:C6CF original=2ea3eeec
    mov word ptr cs:[0ECEEh], ax
; @0C6D3 0000:C6D3 original=e8f325
    CALL_NEAR loc_0ECC9
; @0C6D6 0000:C6D6 original=2ea1e5ed
    mov ax, word ptr cs:[0EDE5h]
; @0C6DA 0000:C6DA original=eb24
    JMP_SHORT loc_0C700
; @0C6DC 0000:C6DC original=8b1eac21
    mov bx, word ptr ds:[021ACh]
; @0C6E0 0000:C6E0 original=b43e
    mov ah, 03Eh
; @0C6E2 0000:C6E2 original=cd21
    int 021h
; @0C6E4 0000:C6E4 original=a1aa21
    mov ax, word ptr ds:[021AAh]
; @0C6E7 0000:C6E7 original=2ea33e02
    mov word ptr cs:[023Eh], ax
; @0C6EB 0000:C6EB original=a1a421
    mov ax, word ptr ds:[021A4h]
; @0C6EE 0000:C6EE original=2ea33a02
    mov word ptr cs:[023Ah], ax
; @0C6F2 0000:C6F2 original=a1a621
    mov ax, word ptr ds:[021A6h]
; @0C6F5 0000:C6F5 original=2ea33c02
    mov word ptr cs:[023Ch], ax
; @0C6F9 0000:C6F9 original=e84c3b
    CALL_NEAR loc_00248
; @0C6FC 0000:C6FC original=2ea14402
    mov ax, word ptr cs:[0244h]
; @0C700 0000:C700 original=a3a821
    mov word ptr ds:[021A8h], ax
; @0C703 0000:C703 original=e80100
    CALL_NEAR loc_0C707
; @0C706 0000:C706 original=c3
    ret
; sub_0000_C707
; @0C707 0000:C707 original=2e833ebc9502
    cmp word ptr cs:[095BCh], 2
; @0C70D 0000:C70D original=7501
    JNE_SHORT loc_0C710
; @0C70F 0000:C70F original=c3
    ret
; @0C710 0000:C710 original=bed014
    mov si, 014D0h
; @0C713 0000:C713 original=ad
    lodsw
; @0C714 0000:C714 original=3b06aa21
    cmp ax, word ptr ds:[021AAh]
; @0C718 0000:C718 original=7501
    JNE_SHORT loc_0C71B
; @0C71A 0000:C71A original=c3
    ret
; @0C71B 0000:C71B original=3dffff
    cmp ax, 0FFFFh
; @0C71E 0000:C71E original=75f3
    JNE_SHORT loc_0C713
; @0C720 0000:C720 original=803e31b900
    cmp byte ptr ds:[0B931h], 0
; @0C725 0000:C725 original=7442
    JE_SHORT loc_0C769
; @0C727 0000:C727 original=bb0100
    mov bx, 1
; @0C72A 0000:C72A original=a1a821
    mov ax, word ptr ds:[021A8h]
; @0C72D 0000:C72D original=2d0040
    sub ax, 04000h
; @0C730 0000:C730 original=7205
    JB_SHORT loc_0C737
; @0C732 0000:C732 original=7403
    JE_SHORT loc_0C737
; @0C734 0000:C734 original=43
    inc bx
; @0C735 0000:C735 original=ebf6
    JMP_SHORT loc_0C72D
; @0C737 0000:C737 original=b443
    mov ah, 043h
; @0C739 0000:C739 original=53
    push bx
; @0C73A 0000:C73A original=cd67
    int 067h
; @0C73C 0000:C73C original=5b
    pop bx
; @0C73D 0000:C73D original=0ae4
    or ah, ah
; @0C73F 0000:C73F original=7528
    JNE_SHORT loc_0C769
; @0C741 0000:C741 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0C746 0000:C746 original=8b3e38b9
    mov di, word ptr ds:[0B938h]
; @0C74A 0000:C74A original=a1aa21
    mov ax, word ptr ds:[021AAh]
; @0C74D 0000:C74D original=ab
    stosw
; @0C74E 0000:C74E original=b8ffff
    mov ax, 0FFFFh
; @0C751 0000:C751 original=ab
    stosw
; @0C752 0000:C752 original=a1a821
    mov ax, word ptr ds:[021A8h]
; @0C755 0000:C755 original=ab
    stosw
; @0C756 0000:C756 original=8bc2
    mov ax, dx
; @0C758 0000:C758 original=ab
    stosw
; @0C759 0000:C759 original=8bc3
    mov ax, bx
; @0C75B 0000:C75B original=ab
    stosw
; @0C75C 0000:C75C original=893e38b9
    mov word ptr ds:[0B938h], di
; @0C760 0000:C760 original=e802ff
    CALL_NEAR loc_0C665
; @0C763 0000:C763 original=8b1e32b9
    mov bx, word ptr ds:[0B932h]
; @0C767 0000:C767 original=eb30
    JMP_SHORT loc_0C799
; @0C769 0000:C769 original=8b1ea821
    mov bx, word ptr ds:[021A8h]
; @0C76D 0000:C76D original=d1eb
    shr bx, 1
; @0C76F 0000:C76F original=d1eb
    shr bx, 1
; @0C771 0000:C771 original=d1eb
    shr bx, 1
; @0C773 0000:C773 original=d1eb
    shr bx, 1
; @0C775 0000:C775 original=43
    inc bx
; @0C776 0000:C776 original=b448
    mov ah, 048h
; @0C778 0000:C778 original=cd21
    int 021h
; @0C77A 0000:C77A original=7301
    JAE_SHORT loc_0C77D
; @0C77C 0000:C77C original=c3
    ret
; @0C77D 0000:C77D original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0C782 0000:C782 original=8bd8
    mov bx, ax
; @0C784 0000:C784 original=8b3e38b9
    mov di, word ptr ds:[0B938h]
; @0C788 0000:C788 original=a1aa21
    mov ax, word ptr ds:[021AAh]
; @0C78B 0000:C78B original=ab
    stosw
; @0C78C 0000:C78C original=8bc3
    mov ax, bx
; @0C78E 0000:C78E original=ab
    stosw
; @0C78F 0000:C78F original=a1a821
    mov ax, word ptr ds:[021A8h]
; @0C792 0000:C792 original=ab
    stosw
; @0C793 0000:C793 original=ab
    stosw
; @0C794 0000:C794 original=ab
    stosw
; @0C795 0000:C795 original=893e38b9
    mov word ptr ds:[0B938h], di
; @0C799 0000:C799 original=8b36a621
    mov si, word ptr ds:[021A6h]
; @0C79D 0000:C79D original=8e1ea421
    mov ds, word ptr ds:[021A4h]
; @0C7A1 0000:C7A1 original=8ec3
    mov es, bx
; @0C7A3 0000:C7A3 original=33ff
    xor di, di
; @0C7A5 0000:C7A5 original=368b0ea821
    mov cx, word ptr ss:[021A8h]
; @0C7AA 0000:C7AA original=f3a4
    rep movsb
; @0C7AC 0000:C7AC original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0C7B1 0000:C7B1 original=c3
    ret
; sub_0000_C7B2
; @0C7B2 0000:C7B2 original=be3ab9
    mov si, 0B93Ah
; @0C7B5 0000:C7B5 original=a1aa21
    mov ax, word ptr ds:[021AAh]
; @0C7B8 0000:C7B8 original=833cff
    cmp word ptr ds:[si], -1
; @0C7BB 0000:C7BB original=743e
    JE_SHORT loc_0C7FB
; @0C7BD 0000:C7BD original=3904
    cmp word ptr ds:[si], ax
; @0C7BF 0000:C7BF original=7405
    JE_SHORT loc_0C7C6
; @0C7C1 0000:C7C1 original=83c60a
    add si, 0Ah
; @0C7C4 0000:C7C4 original=ebf2
    JMP_SHORT loc_0C7B8
; @0C7C6 0000:C7C6 original=837c02ff
    cmp word ptr ds:[si + 2], -1
; @0C7CA 0000:C7CA original=7512
    JNE_SHORT loc_0C7DE
; @0C7CC 0000:C7CC original=8b5406
    mov dx, word ptr ds:[si + 6]
; @0C7CF 0000:C7CF original=8b5c08
    mov bx, word ptr ds:[si + 8]
; @0C7D2 0000:C7D2 original=56
    push si
; @0C7D3 0000:C7D3 original=e88ffe
    CALL_NEAR loc_0C665
; @0C7D6 0000:C7D6 original=5e
    pop si
; @0C7D7 0000:C7D7 original=368e1e32b9
    mov ds, word ptr ss:[0B932h]
; @0C7DC 0000:C7DC original=eb03
    JMP_SHORT loc_0C7E1
; @0C7DE 0000:C7DE original=8e5c02
    mov ds, word ptr ds:[si + 2]
; @0C7E1 0000:C7E1 original=368b4c04
    mov cx, word ptr ss:[si + 4]
; @0C7E5 0000:C7E5 original=33f6
    xor si, si
; @0C7E7 0000:C7E7 original=368e06a421
    mov es, word ptr ss:[021A4h]
; @0C7EC 0000:C7EC original=368b3ea621
    mov di, word ptr ss:[021A6h]
; @0C7F1 0000:C7F1 original=f3a4
    rep movsb
; @0C7F3 0000:C7F3 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0C7F8 0000:C7F8 original=32c0
    xor al, al
; @0C7FA 0000:C7FA original=c3
    ret
; @0C7FB 0000:C7FB original=0c01
    or al, 1
; @0C7FD 0000:C7FD original=c3
    ret
; UppercaseAsciiAL
; AL in 61h..7Ah becomes AL & DFh; all other values unchanged. AH and other registers
; preserved. Flags reflect the final CMP or AND, not a stable boolean ABI. Near RET.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0C7FE 0000:C7FE original=3c61
    cmp al, 061h
; @0C800 0000:C800 original=7301
    JAE_SHORT loc_0C803
; @0C802 0000:C802 original=c3
    ret
; @0C803 0000:C803 original=3c7a
    cmp al, 07Ah
; @0C805 0000:C805 original=7601
    JBE_SHORT loc_0C808
; @0C807 0000:C807 original=c3
    ret
; @0C808 0000:C808 original=24df
    and al, 0DFh
; @0C80A 0000:C80A original=c3
    ret
; AdvanceABColonPrefix
; Read pointer DS:21AA. If byte +1 is colon and ASCII-case-folded byte +0 is A or B, retain
; it only when DS:BB86 (A) or DS:BB87 (B) equals exactly1; otherwise increment original byte
; +0 and retry. Case of stored prefix is preserved. Other prefixes return unchanged. Flags
; and AL/SI are scratch.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0C80B 0000:C80B original=8b36aa21
    mov si, word ptr ds:[021AAh]
; @0C80F 0000:C80F original=807c013a
    cmp byte ptr ds:[si + 1], 03Ah
; @0C813 0000:C813 original=7401
    JE_SHORT loc_0C816
; @0C815 0000:C815 original=c3
    ret
; @0C816 0000:C816 original=8a04
    mov al, byte ptr ds:[si]
; @0C818 0000:C818 original=e8e3ff
    CALL_NEAR UppercaseAsciiAL_0C7FE
; @0C81B 0000:C81B original=3c41
    cmp al, 041h
; @0C81D 0000:C81D original=7405
    JE_SHORT loc_0C824
; @0C81F 0000:C81F original=3c42
    cmp al, 042h
; @0C821 0000:C821 original=740d
    JE_SHORT loc_0C830
; @0C823 0000:C823 original=c3
    ret
; @0C824 0000:C824 original=803e86bb01
    cmp byte ptr ds:[0BB86h], 1
; @0C829 0000:C829 original=7501
    JNE_SHORT loc_0C82C
; @0C82B 0000:C82B original=c3
    ret
; @0C82C 0000:C82C original=fe04
    inc byte ptr ds:[si]
; @0C82E 0000:C82E original=ebdb
    JMP_SHORT AdvanceABColonPrefix_0C80B
; @0C830 0000:C830 original=803e87bb01
    cmp byte ptr ds:[0BB87h], 1
; @0C835 0000:C835 original=7501
    JNE_SHORT loc_0C838
; @0C837 0000:C837 original=c3
    ret
; @0C838 0000:C838 original=fe04
    inc byte ptr ds:[si]
; @0C83A 0000:C83A original=ebcf
    JMP_SHORT AdvanceABColonPrefix_0C80B
; sub_0000_C83C
; @0C83C 0000:C83C original=cd11
    int 011h
; @0C83E 0000:C83E original=a801
    test al, 1
; @0C840 0000:C840 original=7501
    JNE_SHORT loc_0C843
; @0C842 0000:C842 original=c3
    ret
; @0C843 0000:C843 original=c60686bb01
    mov byte ptr ds:[0BB86h], 1
; @0C848 0000:C848 original=24c0
    and al, 0C0h
; @0C84A 0000:C84A original=b106
    mov cl, 6
; @0C84C 0000:C84C original=d2e8
    shr al, cl
; @0C84E 0000:C84E original=fec0
    inc al
; @0C850 0000:C850 original=3c01
    cmp al, 1
; @0C852 0000:C852 original=7501
    JNE_SHORT loc_0C855
; @0C854 0000:C854 original=c3
    ret
; @0C855 0000:C855 original=c60687bb01
    mov byte ptr ds:[0BB87h], 1
; @0C85A 0000:C85A original=c3
    ret
; sub_0000_C85B
; @0C85B 0000:C85B original=8b36aa21
    mov si, word ptr ds:[021AAh]
; @0C85F 0000:C85F original=8a04
    mov al, byte ptr ds:[si]
; @0C861 0000:C861 original=807c013a
    cmp byte ptr ds:[si + 1], 03Ah
; @0C865 0000:C865 original=7406
    JE_SHORT loc_0C86D
; @0C867 0000:C867 original=b419
    mov ah, 019h
; @0C869 0000:C869 original=cd21
    int 021h
; @0C86B 0000:C86B original=0441
    add al, 041h
; @0C86D 0000:C86D original=e88eff
    CALL_NEAR UppercaseAsciiAL_0C7FE
; @0C870 0000:C870 original=2c41
    sub al, 041h
; @0C872 0000:C872 original=3c02
    cmp al, 2
; @0C874 0000:C874 original=7310
    JAE_SHORT loc_0C886
; @0C876 0000:C876 original=8ad0
    mov dl, al
; @0C878 0000:C878 original=b600
    mov dh, 0
; @0C87A 0000:C87A original=b90101
    mov cx, 0101h
; @0C87D 0000:C87D original=b80104
    mov ax, 0401h
; @0C880 0000:C880 original=cd13
    int 013h
; @0C882 0000:C882 original=80e480
    and ah, 080h
; @0C885 0000:C885 original=c3
    ret
; @0C886 0000:C886 original=32c0
    xor al, al
; @0C888 0000:C888 original=c3
    ret
; @0C889 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0BDh,016h,0BCh,0E8h,0F2h
; @0C899 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,0BDh,041h,0BCh,0E8h,0ECh,088h,0BDh,06Ch,0BCh,0E8h,0E6h,088h,0BDh,097h,0BCh
; @0C8A9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0E0h,088h,0C3h
; sub_0000_C8AD
; @0C8AD 0000:C8AD original=2ec7068ac80000
    mov word ptr cs:[0C88Ah], 0
; @0C8B4 0000:C8B4 original=ba88bb
    mov dx, 0BB88h
; @0C8B7 0000:C8B7 original=e80300
    CALL_NEAR loc_0C8BD
; @0C8BA 0000:C8BA original=ba96bb
    mov dx, 0BB96h
; sub_0000_C8BD
; @0C8BD 0000:C8BD original=8916aa21
    mov word ptr ds:[021AAh], dx
; @0C8C1 0000:C8C1 original=bb8001
    mov bx, 0180h
; @0C8C4 0000:C8C4 original=b448
    mov ah, 048h
; @0C8C6 0000:C8C6 original=cd21
    int 021h
; @0C8C8 0000:C8C8 original=2ea392c8
    mov word ptr cs:[0C892h], ax
; @0C8CC 0000:C8CC original=32c0
    xor al, al
; @0C8CE 0000:C8CE original=b43d
    mov ah, 03Dh
; @0C8D0 0000:C8D0 original=cd21
    int 021h
; @0C8D2 0000:C8D2 original=a3ac21
    mov word ptr ds:[021ACh], ax
; @0C8D5 0000:C8D5 original=2ec70690c83412
    mov word ptr cs:[0C890h], 01234h
; @0C8DC 0000:C8DC original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0C8E1 0000:C8E1 original=8b1eac21
    mov bx, word ptr ds:[021ACh]
; @0C8E5 0000:C8E5 original=2e8e1e92c8
    mov ds, word ptr cs:[0C892h]
; @0C8EA 0000:C8EA original=b94200
    mov cx, 042h
; @0C8ED 0000:C8ED original=33ff
    xor di, di
; @0C8EF 0000:C8EF original=56
    push si
; @0C8F0 0000:C8F0 original=be0014
    mov si, 01400h
; @0C8F3 0000:C8F3 original=1e
    push ds
; @0C8F4 0000:C8F4 original=07
    pop es
; @0C8F5 0000:C8F5 original=f3a4
    rep movsb
; @0C8F7 0000:C8F7 original=b90014
    mov cx, 01400h
; @0C8FA 0000:C8FA original=ba4200
    mov dx, 042h
; @0C8FD 0000:C8FD original=b43f
    mov ah, 03Fh
; @0C8FF 0000:C8FF original=cd21
    int 021h
; @0C901 0000:C901 original=5e
    pop si
; @0C902 0000:C902 original=2ea38ec8
    mov word ptr cs:[0C88Eh], ax
; @0C906 0000:C906 original=2ea190c8
    mov ax, word ptr cs:[0C890h]
; @0C90A 0000:C90A original=2e8b0e8ec8
    mov cx, word ptr cs:[0C88Eh]
; @0C90F 0000:C90F original=e314
    JCXZ_SHORT loc_0C925
; @0C911 0000:C911 original=be4200
    mov si, 042h
; @0C914 0000:C914 original=b600
    mov dh, 0
; @0C916 0000:C916 original=8a14
    mov dl, byte ptr ds:[si]
; @0C918 0000:C918 original=03c2
    add ax, dx
; @0C91A 0000:C91A original=02e0
    add ah, al
; @0C91C 0000:C91C original=46
    inc si
; @0C91D 0000:C91D original=e2f7
    LOOP_SHORT loc_0C916
; @0C91F 0000:C91F original=2ea390c8
    mov word ptr cs:[0C890h], ax
; @0C923 0000:C923 original=ebb7
    JMP_SHORT loc_0C8DC
; @0C925 0000:C925 original=50
    push ax
; @0C926 0000:C926 original=56
    push si
; @0C927 0000:C927 original=1e
    push ds
; @0C928 0000:C928 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0C92D 0000:C92D original=8b1eac21
    mov bx, word ptr ds:[021ACh]
; @0C931 0000:C931 original=b43e
    mov ah, 03Eh
; @0C933 0000:C933 original=cd21
    int 021h
; @0C935 0000:C935 original=1f
    pop ds
; @0C936 0000:C936 original=5e
    pop si
; @0C937 0000:C937 original=58
    pop ax
; @0C938 0000:C938 original=b600
    mov dh, 0
; @0C93A 0000:C93A original=4e
    dec si
; @0C93B 0000:C93B original=8a14
    mov dl, byte ptr ds:[si]
; @0C93D 0000:C93D original=2ae0
    sub ah, al
; @0C93F 0000:C93F original=2bc2
    sub ax, dx
; @0C941 0000:C941 original=4e
    dec si
; @0C942 0000:C942 original=8a14
    mov dl, byte ptr ds:[si]
; @0C944 0000:C944 original=2ae0
    sub ah, al
; @0C946 0000:C946 original=2bc2
    sub ax, dx
; @0C948 0000:C948 original=2ea38cc8
    mov word ptr cs:[0C88Ch], ax
; @0C94C 0000:C94C original=3b04
    cmp ax, word ptr ds:[si]
; @0C94E 0000:C94E original=9c
    pushf
; @0C94F 0000:C94F original=2e833e8ac801
    cmp word ptr cs:[0C88Ah], 1
; @0C955 0000:C955 original=7429
    JE_SHORT loc_0C980
; @0C957 0000:C957 original=36813eaa2188bb
    cmp word ptr ss:[021AAh], 0BB88h
; @0C95E 0000:C95E original=7520
    JNE_SHORT loc_0C980
; @0C960 0000:C960 original=83ee40
    sub si, 040h
; @0C963 0000:C963 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0C968 0000:C968 original=bf30bc
    mov di, 0BC30h
; @0C96B 0000:C96B original=e86500
    CALL_NEAR XorCopy16BytesAA_0C9D3
; @0C96E 0000:C96E original=bf5bbc
    mov di, 0BC5Bh
; @0C971 0000:C971 original=e85f00
    CALL_NEAR XorCopy16BytesAA_0C9D3
; @0C974 0000:C974 original=bf86bc
    mov di, 0BC86h
; @0C977 0000:C977 original=e85900
    CALL_NEAR XorCopy16BytesAA_0C9D3
; @0C97A 0000:C97A original=bfb1bc
    mov di, 0BCB1h
; @0C97D 0000:C97D original=e85300
    CALL_NEAR XorCopy16BytesAA_0C9D3
; @0C980 0000:C980 original=2e8e0692c8
    mov es, word ptr cs:[0C892h]
; @0C985 0000:C985 original=b449
    mov ah, 049h
; @0C987 0000:C987 original=cd21
    int 021h
; @0C989 0000:C989 original=9d
    popf
; @0C98A 0000:C98A original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0C98F 0000:C98F original=7501
    JNE_SHORT loc_0C992
; @0C991 0000:C991 original=c3
    ret
; @0C992 0000:C992 original=2e833e8ac801
    cmp word ptr cs:[0C88Ah], 1
; @0C998 0000:C998 original=7501
    JNE_SHORT loc_0C99B
; @0C99A 0000:C99A original=c3
    ret
; @0C99B 0000:C99B original=b80300
    mov ax, 3
; @0C99E 0000:C99E original=cd10
    int 010h
; @0C9A0 0000:C9A0 original=baa0bb
    mov dx, 0BBA0h
; @0C9A3 0000:C9A3 original=b409
    mov ah, 9
; @0C9A5 0000:C9A5 original=cd21
    int 021h
; @0C9A7 0000:C9A7 original=8b16aa21
    mov dx, word ptr ds:[021AAh]
; @0C9AB 0000:C9AB original=b409
    mov ah, 9
; @0C9AD 0000:C9AD original=cd21
    int 021h
; @0C9AF 0000:C9AF original=bab8bb
    mov dx, 0BBB8h
; @0C9B2 0000:C9B2 original=b409
    mov ah, 9
; @0C9B4 0000:C9B4 original=cd21
    int 021h
; @0C9B6 0000:C9B6 original=b200
    mov dl, 0
; @0C9B8 0000:C9B8 original=b618
    mov dh, 018h
; @0C9BA 0000:C9BA original=b402
    mov ah, 2
; @0C9BC 0000:C9BC original=b700
    mov bh, 0
; @0C9BE 0000:C9BE original=cd10
    int 010h
; @0C9C0 0000:C9C0 original=baf1bb
    mov dx, 0BBF1h
; @0C9C3 0000:C9C3 original=b409
    mov ah, 9
; @0C9C5 0000:C9C5 original=cd21
    int 021h
; @0C9C7 0000:C9C7 original=e81300
    CALL_NEAR loc_0C9DD
; @0C9CA 0000:C9CA original=b407
    mov ah, 7
; @0C9CC 0000:C9CC original=cd21
    int 021h
; @0C9CE 0000:C9CE original=b8014c
    mov ax, 04C01h
; @0C9D1 0000:C9D1 original=cd21
    int 021h
; XorCopy16BytesAA
; Sixteen iterations XOR source DS:[SI] with AAh in place, then MOVSB to ES:[DI]. DF
; controls both pointer directions. CX becomes zero; AL unchanged. Source also changes, and
; aliasing is observable.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0C9D3 0000:C9D3 original=b91000
    mov cx, 010h
; @0C9D6 0000:C9D6 original=8034aa
    xor byte ptr ds:[si], 0AAh
; @0C9D9 0000:C9D9 original=a4
    movsb
; @0C9DA 0000:C9DA original=e2fa
    LOOP_SHORT loc_0C9D6
; @0C9DC 0000:C9DC original=c3
    ret
; sub_0000_C9DD
; @0C9DD 0000:C9DD original=b401
    mov ah, 1
; @0C9DF 0000:C9DF original=cd16
    int 016h
; @0C9E1 0000:C9E1 original=7406
    JE_SHORT loc_0C9E9
; @0C9E3 0000:C9E3 original=32e4
    xor ah, ah
; @0C9E5 0000:C9E5 original=cd16
    int 016h
; @0C9E7 0000:C9E7 original=ebf4
    JMP_SHORT loc_0C9DD
; @0C9E9 0000:C9E9 original=c3
    ret
; @0C9EA 0000:C9EA original=e80400
    CALL_NEAR loc_0C9F1
; @0C9ED 0000:C9ED original=e81200
    CALL_NEAR loc_0CA02
; @0C9F0 0000:C9F0 original=c3
    ret
; sub_0000_C9F1
; @0C9F1 0000:C9F1 original=bada03
    mov dx, 03DAh
; @0C9F4 0000:C9F4 original=2e803e5aca01
    cmp byte ptr cs:[0CA5Ah], 1
; @0C9FA 0000:C9FA original=7411
    JE_SHORT loc_0CA0D
; @0C9FC 0000:C9FC original=ec
    in al, dx
; @0C9FD 0000:C9FD original=a808
    test al, 8
; @0C9FF 0000:C9FF original=74fb
    JE_SHORT loc_0C9FC
; @0CA01 0000:CA01 original=c3
    ret
; sub_0000_CA02
; @0CA02 0000:CA02 original=bada03
    mov dx, 03DAh
; @0CA05 0000:CA05 original=2e803e5aca01
    cmp byte ptr cs:[0CA5Ah], 1
; @0CA0B 0000:CA0B original=74ef
    JE_SHORT loc_0C9FC
; @0CA0D 0000:CA0D original=ec
    in al, dx
; @0CA0E 0000:CA0E original=a808
    test al, 8
; @0CA10 0000:CA10 original=75fb
    JNE_SHORT loc_0CA0D
; @0CA12 0000:CA12 original=c3
    ret
; sub_0000_CA13
; @0CA13 0000:CA13 original=9c
    pushf
; @0CA14 0000:CA14 original=fa
    cli
; @0CA15 0000:CA15 original=bada03
    mov dx, 03DAh
; @0CA18 0000:CA18 original=ec
    in al, dx
; @0CA19 0000:CA19 original=a808
    test al, 8
; @0CA1B 0000:CA1B original=74fb
    JE_SHORT loc_0CA18
; @0CA1D 0000:CA1D original=ec
    in al, dx
; @0CA1E 0000:CA1E original=a808
    test al, 8
; @0CA20 0000:CA20 original=75fb
    JNE_SHORT loc_0CA1D
; @0CA22 0000:CA22 original=be0000
    mov si, 0
; @0CA25 0000:CA25 original=b100
    mov cl, 0
; @0CA27 0000:CA27 original=ec
    in al, dx
; @0CA28 0000:CA28 original=fec1
    inc cl
; @0CA2A 0000:CA2A original=7501
    JNE_SHORT loc_0CA2D
; @0CA2C 0000:CA2C original=46
    inc si
; @0CA2D 0000:CA2D original=a808
    test al, 8
; @0CA2F 0000:CA2F original=74f6
    JE_SHORT loc_0CA27
; @0CA31 0000:CA31 original=bf0000
    mov di, 0
; @0CA34 0000:CA34 original=b300
    mov bl, 0
; @0CA36 0000:CA36 original=ec
    in al, dx
; @0CA37 0000:CA37 original=fec3
    inc bl
; @0CA39 0000:CA39 original=7501
    JNE_SHORT loc_0CA3C
; @0CA3B 0000:CA3B original=47
    inc di
; @0CA3C 0000:CA3C original=a808
    test al, 8
; @0CA3E 0000:CA3E original=75f6
    JNE_SHORT loc_0CA36
; @0CA40 0000:CA40 original=b001
    mov al, 1
; @0CA42 0000:CA42 original=3bfe
    cmp di, si
; @0CA44 0000:CA44 original=7406
    JE_SHORT loc_0CA4C
; @0CA46 0000:CA46 original=730c
    JAE_SHORT loc_0CA54
; @0CA48 0000:CA48 original=b000
    mov al, 0
; @0CA4A 0000:CA4A original=eb08
    JMP_SHORT loc_0CA54
; @0CA4C 0000:CA4C original=b001
    mov al, 1
; @0CA4E 0000:CA4E original=3ad9
    cmp bl, cl
; @0CA50 0000:CA50 original=7302
    JAE_SHORT loc_0CA54
; @0CA52 0000:CA52 original=b000
    mov al, 0
; @0CA54 0000:CA54 original=2ea25aca
    mov byte ptr cs:[0CA5Ah], al
; @0CA58 0000:CA58 original=9d
    popf
; @0CA59 0000:CA59 original=c3
    ret
; @0CA5A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; LowercaseAsciiAL
; AL in 41h..5Ah becomes AL | 20h; all other values unchanged. AH and other registers
; preserved. Flags reflect final CMP or OR. Near RET.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0CA5B 0000:CA5B original=3c41
    cmp al, 041h
; @0CA5D 0000:CA5D original=7301
    JAE_SHORT loc_0CA60
; @0CA5F 0000:CA5F original=c3
    ret
; @0CA60 0000:CA60 original=3c5a
    cmp al, 05Ah
; @0CA62 0000:CA62 original=7601
    JBE_SHORT loc_0CA65
; @0CA64 0000:CA64 original=c3
    ret
; @0CA65 0000:CA65 original=0c20
    or al, 020h
; @0CA67 0000:CA67 original=c3
    ret
; @0CA68 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,055h,00h,00h,074h,028h,0A1h,0C2h,0BCh,0BDh,0C5h,0BCh,03Dh,034h,0BDh
; @0CA78 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,012h,0BDh,0ECh,0BCh,03Dh,03Eh,0BDh,074h,0Ah,0BDh,011h,0BDh,03Dh,048h,0BDh
; @0CA88 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,02h,0EBh,0Bh,0E8h,0FDh,086h,0B9h,0AFh,00h,0E8h,034h,086h,0E2h,0FBh,0C3h
; sub_0000_CA98
; @0CA98 0000:CA98 original=a0c4bc
    mov al, byte ptr ds:[0BCC4h]
; @0CA9B 0000:CA9B original=3cff
    cmp al, 0FFh
; @0CA9D 0000:CA9D original=7411
    JE_SHORT loc_0CAB0
; @0CA9F 0000:CA9F original=e8b9ff
    CALL_NEAR LowercaseAsciiAL_0CA5B
; @0CAA2 0000:CAA2 original=3c72
    cmp al, 072h
; @0CAA4 0000:CAA4 original=742c
    JE_SHORT loc_0CAD2
; @0CAA6 0000:CAA6 original=3c61
    cmp al, 061h
; @0CAA8 0000:CAA8 original=744a
    JE_SHORT loc_0CAF4
; @0CAAA 0000:CAAA original=3c74
    cmp al, 074h
; @0CAAC 0000:CAAC original=7402
    JE_SHORT loc_0CAB0
; @0CAAE 0000:CAAE original=eb5f
    JMP_SHORT loc_0CB0F
; @0CAB0 0000:CAB0 original=ba3ebd
    mov dx, 0BD3Eh
; @0CAB3 0000:CAB3 original=e8df00
    CALL_NEAR loc_0CB95
; @0CAB6 0000:CAB6 original=7413
    JE_SHORT loc_0CACB
; @0CAB8 0000:CAB8 original=b82210
    mov ax, 01022h
; @0CABB 0000:CABB original=8ec0
    mov es, ax
; @0CABD 0000:CABD original=9a04002210
    CALL_FAR 01022h,04h
; @0CAC2 0000:CAC2 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CAC7 0000:CAC7 original=0ac0
    or al, al
; @0CAC9 0000:CAC9 original=754a
    JNE_SHORT loc_0CB15
; @0CACB 0000:CACB original=803ec4bcff
    cmp byte ptr ds:[0BCC4h], 0FFh
; @0CAD0 0000:CAD0 original=753d
    JNE_SHORT loc_0CB0F
; @0CAD2 0000:CAD2 original=ba48bd
    mov dx, 0BD48h
; @0CAD5 0000:CAD5 original=e8bd00
    CALL_NEAR loc_0CB95
; @0CAD8 0000:CAD8 original=7413
    JE_SHORT loc_0CAED
; @0CADA 0000:CADA original=b82210
    mov ax, 01022h
; @0CADD 0000:CADD original=8ec0
    mov es, ax
; @0CADF 0000:CADF original=9a04002210
    CALL_FAR 01022h,04h
; @0CAE4 0000:CAE4 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CAE9 0000:CAE9 original=0ac0
    or al, al
; @0CAEB 0000:CAEB original=7528
    JNE_SHORT loc_0CB15
; @0CAED 0000:CAED original=803ec4bcff
    cmp byte ptr ds:[0BCC4h], 0FFh
; @0CAF2 0000:CAF2 original=751b
    JNE_SHORT loc_0CB0F
; @0CAF4 0000:CAF4 original=ba34bd
    mov dx, 0BD34h
; @0CAF7 0000:CAF7 original=e89b00
    CALL_NEAR loc_0CB95
; @0CAFA 0000:CAFA original=7413
    JE_SHORT loc_0CB0F
; @0CAFC 0000:CAFC original=b82210
    mov ax, 01022h
; @0CAFF 0000:CAFF original=8ec0
    mov es, ax
; @0CB01 0000:CB01 original=9a04002210
    CALL_FAR 01022h,04h
; @0CB06 0000:CB06 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CB0B 0000:CB0B original=0ac0
    or al, al
; @0CB0D 0000:CB0D original=7506
    JNE_SHORT loc_0CB15
; @0CB0F 0000:CB0F original=c606550000
    mov byte ptr ds:[055h], 0
; @0CB14 0000:CB14 original=c3
    ret
; @0CB15 0000:CB15 original=c606550001
    mov byte ptr ds:[055h], 1
; @0CB1A 0000:CB1A original=b002
    mov al, 2
; sub_0000_CB1C
; @0CB1C 0000:CB1C original=a2c298
    mov byte ptr ds:[098C2h], al
; @0CB1F 0000:CB1F original=803ec19800
    cmp byte ptr ds:[098C1h], 0
; @0CB24 0000:CB24 original=7417
    JE_SHORT loc_0CB3D
; @0CB26 0000:CB26 original=32e4
    xor ah, ah
; @0CB28 0000:CB28 original=bb2210
    mov bx, 01022h
; @0CB2B 0000:CB2B original=8ec3
    mov es, bx
; @0CB2D 0000:CB2D original=263a060900
    cmp al, byte ptr es:[9]
; @0CB32 0000:CB32 original=7409
    JE_SHORT loc_0CB3D
; @0CB34 0000:CB34 original=26a30800
    mov word ptr es:[8], ax
; @0CB38 0000:CB38 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CB3D 0000:CB3D original=c3
    ret
; sub_0000_CB3E
; @0CB3E 0000:CB3E original=803e550000
    cmp byte ptr ds:[055h], 0
; @0CB43 0000:CB43 original=7501
    JNE_SHORT loc_0CB46
; @0CB45 0000:CB45 original=c3
    ret
; @0CB46 0000:CB46 original=b82210
    mov ax, 01022h
; @0CB49 0000:CB49 original=8ec0
    mov es, ax
; @0CB4B 0000:CB4B original=26c7060800ff00
    mov word ptr es:[8], 0FFh
; @0CB52 0000:CB52 original=b90500
    mov cx, 5
; @0CB55 0000:CB55 original=51
    push cx
; @0CB56 0000:CB56 original=e87c00
    CALL_NEAR loc_0CBD5
; @0CB59 0000:CB59 original=59
    pop cx
; @0CB5A 0000:CB5A original=e2f9
    LOOP_SHORT loc_0CB55
; @0CB5C 0000:CB5C original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CB61 0000:CB61 original=c3
    ret
; @0CB62 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,055h,00h,00h,075h,01h,0C3h,06h,053h,0BBh,022h,010h,08Eh,0C3h,026h
; @0CB72 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A2h,0Ah,00h,05Bh,07h,0C3h,080h,03Eh,055h,00h,00h,075h,01h,0C3h,06h,053h
; @0CB82 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BBh,022h,010h,08Eh,0C3h,026h,0C7h,06h,08h,00h,0FFh,00h,026h,0A2h,08h,00h
; @0CB92 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Bh,07h,0C3h
; sub_0000_CB95
; @0CB95 0000:CB95 original=8916aa21
    mov word ptr ds:[021AAh], dx
; @0CB99 0000:CB99 original=8916c2bc
    mov word ptr ds:[0BCC2h], dx
; @0CB9D 0000:CB9D original=32c0
    xor al, al
; @0CB9F 0000:CB9F original=b43d
    mov ah, 03Dh
; @0CBA1 0000:CBA1 original=9ad7043a15
    CALL_FAR 0153Ah,04D7h
; @0CBA6 0000:CBA6 original=730c
    JAE_SHORT loc_0CBB4
; @0CBA8 0000:CBA8 original=8b16aa21
    mov dx, word ptr ds:[021AAh]
; @0CBAC 0000:CBAC original=32c0
    xor al, al
; @0CBAE 0000:CBAE original=b43d
    mov ah, 03Dh
; @0CBB0 0000:CBB0 original=cd21
    int 021h
; @0CBB2 0000:CBB2 original=721e
    JB_SHORT loc_0CBD2
; @0CBB4 0000:CBB4 original=2ea366d6
    mov word ptr cs:[0D666h], ax
; @0CBB8 0000:CBB8 original=2ea19895
    mov ax, word ptr cs:[09598h]
; @0CBBC 0000:CBBC original=2ec706f0ec2210
    mov word ptr cs:[0ECF0h], 01022h
; @0CBC3 0000:CBC3 original=2ec706eeec0000
    mov word ptr cs:[0ECEEh], 0
; @0CBCA 0000:CBCA original=e8fc20
    CALL_NEAR loc_0ECC9
; @0CBCD 0000:CBCD original=7203
    JB_SHORT loc_0CBD2
; @0CBCF 0000:CBCF original=0c01
    or al, 1
; @0CBD1 0000:CBD1 original=c3
    ret
; @0CBD2 0000:CBD2 original=32c0
    xor al, al
; @0CBD4 0000:CBD4 original=c3
    ret
; sub_0000_CBD5
; @0CBD5 0000:CBD5 original=803e550000
    cmp byte ptr ds:[055h], 0
; @0CBDA 0000:CBDA original=7501
    JNE_SHORT loc_0CBDD
; @0CBDC 0000:CBDC original=c3
    ret
; @0CBDD 0000:CBDD original=a05400
    mov al, byte ptr ds:[054h]
; @0CBE0 0000:CBE0 original=3a065400
    cmp al, byte ptr ds:[054h]
; @0CBE4 0000:CBE4 original=74fa
    JE_SHORT loc_0CBE0
; @0CBE6 0000:CBE6 original=c3
    ret
; @0CBE7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; sub_0000_CBE8
; @0CBE8 0000:CBE8 original=e81900
    CALL_NEAR loc_0CC04
; @0CBEB 0000:CBEB original=e80090
    CALL_NEAR loc_05BEE
; @0CBEE 0000:CBEE original=e8d283
    CALL_NEAR loc_04FC3
; @0CBF1 0000:CBF1 original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0CBF6 0000:CBF6 original=7503
    JNE_SHORT loc_0CBFB
; @0CBF8 0000:CBF8 original=e83303
    CALL_NEAR loc_0CF2E
; @0CBFB 0000:CBFB original=b91e00
    mov cx, 01Eh
; @0CBFE 0000:CBFE original=e8c884
    CALL_NEAR loc_050C9
; @0CC01 0000:CC01 original=e2fb
    LOOP_SHORT loc_0CBFE
; @0CC03 0000:CC03 original=c3
    ret
; sub_0000_CC04
; @0CC04 0000:CC04 original=c606c39800
    mov byte ptr ds:[098C3h], 0
; @0CC09 0000:CC09 original=e8e28f
    CALL_NEAR loc_05BEE
; @0CC0C 0000:CC0C original=e84883
    CALL_NEAR loc_04F57
; @0CC0F 0000:CC0F original=e88502
    CALL_NEAR loc_0CE97
; @0CC12 0000:CC12 original=e8ef8f
    CALL_NEAR loc_05C04
; @0CC15 0000:CC15 original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0CC1A 0000:CC1A original=7532
    JNE_SHORT loc_0CC4E
; @0CC1C 0000:CC1C original=b91e00
    mov cx, 01Eh
; @0CC1F 0000:CC1F original=e81e02
    CALL_NEAR loc_0CE40
; @0CC22 0000:CC22 original=c70698bd54bd
    mov word ptr ds:[0BD98h], 0BD54h
; @0CC28 0000:CC28 original=e83402
    CALL_NEAR loc_0CE5F
; @0CC2B 0000:CC2B original=e82100
    CALL_NEAR loc_0CC4F
; @0CC2E 0000:CC2E original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0CC33 0000:CC33 original=7519
    JNE_SHORT loc_0CC4E
; @0CC35 0000:CC35 original=e82702
    CALL_NEAR loc_0CE5F
; @0CC38 0000:CC38 original=e81400
    CALL_NEAR loc_0CC4F
; @0CC3B 0000:CC3B original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0CC40 0000:CC40 original=750c
    JNE_SHORT loc_0CC4E
; @0CC42 0000:CC42 original=e81a02
    CALL_NEAR loc_0CE5F
; @0CC45 0000:CC45 original=e80700
    CALL_NEAR loc_0CC4F
; @0CC48 0000:CC48 original=b93200
    mov cx, 032h
; @0CC4B 0000:CC4B original=e8f201
    CALL_NEAR loc_0CE40
; @0CC4E 0000:CC4E original=c3
    ret
; sub_0000_CC4F
; @0CC4F 0000:CC4F original=c7069abd81bd
    mov word ptr ds:[0BD9Ah], 0BD81h
; @0CC55 0000:CC55 original=b90500
    mov cx, 5
; @0CC58 0000:CC58 original=51
    push cx
; @0CC59 0000:CC59 original=890ea0bd
    mov word ptr ds:[0BDA0h], cx
; @0CC5D 0000:CC5D original=8b369abd
    mov si, word ptr ds:[0BD9Ah]
; @0CC61 0000:CC61 original=ac
    lodsb
; @0CC62 0000:CC62 original=a296bd
    mov byte ptr ds:[0BD96h], al
; @0CC65 0000:CC65 original=ac
    lodsb
; @0CC66 0000:CC66 original=a295bd
    mov byte ptr ds:[0BD95h], al
; @0CC69 0000:CC69 original=ac
    lodsb
; @0CC6A 0000:CC6A original=32e4
    xor ah, ah
; @0CC6C 0000:CC6C original=8bc8
    mov cx, ax
; @0CC6E 0000:CC6E original=ac
    lodsb
; @0CC6F 0000:CC6F original=a39cbd
    mov word ptr ds:[0BD9Ch], ax
; @0CC72 0000:CC72 original=89369abd
    mov word ptr ds:[0BD9Ah], si
; @0CC76 0000:CC76 original=51
    push cx
; @0CC77 0000:CC77 original=ff3695bd
    push word ptr ds:[0BD95h]
; @0CC7B 0000:CC7B original=8b0e9cbd
    mov cx, word ptr ds:[0BD9Ch]
; @0CC7F 0000:CC7F original=51
    push cx
; @0CC80 0000:CC80 original=a195bd
    mov ax, word ptr ds:[0BD95h]
; @0CC83 0000:CC83 original=e89e8d
    CALL_NEAR loc_05A24
; @0CC86 0000:CC86 original=893e9ebd
    mov word ptr ds:[0BD9Eh], di
; @0CC8A 0000:CC8A original=8bf7
    mov si, di
; @0CC8C 0000:CC8C original=81c6007d
    add si, 07D00h
; @0CC90 0000:CC90 original=32d2
    xor dl, dl
; @0CC92 0000:CC92 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @0CC97 0000:CC97 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @0CC9C 0000:CC9C original=d1e3
    shl bx, 1
; @0CC9E 0000:CC9E original=2effa7a4cc
    jmp word ptr cs:[bx - 0335Ch]
; @0CCA3 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0AAh,0CCh,0F0h,0CCh,0C4h,0CCh
; sub_0000_CCAA
; @0CCAA 0000:CCAA original=b90800
    mov cx, 8
; @0CCAD 0000:CCAD original=268b04
    mov ax, word ptr es:[si]
; @0CCB0 0000:CCB0 original=263b05
    cmp ax, word ptr es:[di]
; @0CCB3 0000:CCB3 original=7405
    JE_SHORT loc_0CCBA
; @0CCB5 0000:CCB5 original=b201
    mov dl, 1
; @0CCB7 0000:CCB7 original=268905
    mov word ptr es:[di], ax
; @0CCBA 0000:CCBA original=83c750
    add di, 050h
; @0CCBD 0000:CCBD original=83c650
    add si, 050h
; @0CCC0 0000:CCC0 original=e2eb
    LOOP_SHORT loc_0CCAD
; @0CCC2 0000:CCC2 original=eb44
    JMP_SHORT loc_0CD08
; sub_0000_CCC4
; @0CCC4 0000:CCC4 original=b90800
    mov cx, 8
; @0CCC7 0000:CCC7 original=268b04
    mov ax, word ptr es:[si]
; @0CCCA 0000:CCCA original=263b05
    cmp ax, word ptr es:[di]
; @0CCCD 0000:CCCD original=7405
    JE_SHORT loc_0CCD4
; @0CCCF 0000:CCCF original=b201
    mov dl, 1
; @0CCD1 0000:CCD1 original=268905
    mov word ptr es:[di], ax
; @0CCD4 0000:CCD4 original=268b4402
    mov ax, word ptr es:[si + 2]
; @0CCD8 0000:CCD8 original=263b4502
    cmp ax, word ptr es:[di + 2]
; @0CCDC 0000:CCDC original=7406
    JE_SHORT loc_0CCE4
; @0CCDE 0000:CCDE original=b201
    mov dl, 1
; @0CCE0 0000:CCE0 original=26894502
    mov word ptr es:[di + 2], ax
; @0CCE4 0000:CCE4 original=81c7a000
    add di, 0A0h
; @0CCE8 0000:CCE8 original=81c6a000
    add si, 0A0h
; @0CCEC 0000:CCEC original=e2d9
    LOOP_SHORT loc_0CCC7
; @0CCEE 0000:CCEE original=eb18
    JMP_SHORT loc_0CD08
; sub_0000_CCF0
; @0CCF0 0000:CCF0 original=b92000
    mov cx, 020h
; @0CCF3 0000:CCF3 original=268a04
    mov al, byte ptr es:[si]
; @0CCF6 0000:CCF6 original=263a05
    cmp al, byte ptr es:[di]
; @0CCF9 0000:CCF9 original=7405
    JE_SHORT loc_0CD00
; @0CCFB 0000:CCFB original=b201
    mov dl, 1
; @0CCFD 0000:CCFD original=268805
    mov byte ptr es:[di], al
; @0CD00 0000:CD00 original=83c728
    add di, 028h
; @0CD03 0000:CD03 original=83c628
    add si, 028h
; @0CD06 0000:CD06 original=e2eb
    LOOP_SHORT loc_0CCF3
; @0CD08 0000:CD08 original=0ad2
    or dl, dl
; @0CD0A 0000:CD0A original=7503
    JNE_SHORT loc_0CD0F
; @0CD0C 0000:CD0C original=e9f800
    JMP_NEAR loc_0CE07
; @0CD0F 0000:CD0F original=833ea0bd04
    cmp word ptr ds:[0BDA0h], 4
; @0CD14 0000:CD14 original=7415
    JE_SHORT loc_0CD2B
; @0CD16 0000:CD16 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0CD1B 0000:CD1B original=741a
    JE_SHORT loc_0CD37
; @0CD1D 0000:CD1D original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0CD22 0000:CD22 original=7405
    JE_SHORT loc_0CD29
; @0CD24 0000:CD24 original=c606ffbe0e
    mov byte ptr ds:[0BEFFh], 0Eh
; @0CD29 0000:CD29 original=eb0c
    JMP_SHORT loc_0CD37
; @0CD2B 0000:CD2B original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0CD30 0000:CD30 original=7405
    JE_SHORT loc_0CD37
; @0CD32 0000:CD32 original=c606ffbe0a
    mov byte ptr ds:[0BEFFh], 0Ah
; @0CD37 0000:CD37 original=a195bd
    mov ax, word ptr ds:[0BD95h]
; @0CD3A 0000:CD3A original=e8c38c
    CALL_NEAR loc_05A00
; @0CD3D 0000:CD3D original=57
    push di
; @0CD3E 0000:CD3E original=be1200
    mov si, 012h
; @0CD41 0000:CD41 original=d1e6
    shl si, 1
; @0CD43 0000:CD43 original=81c6920c
    add si, 0C92h
; @0CD47 0000:CD47 original=2e8b34
    mov si, word ptr cs:[si]
; @0CD4A 0000:CD4A original=2e8e1eb895
    mov ds, word ptr cs:[095B8h]
; @0CD4F 0000:CD4F original=e81a8d
    CALL_NEAR loc_05A6C
; @0CD52 0000:CD52 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CD57 0000:CD57 original=833ea0bd05
    cmp word ptr ds:[0BDA0h], 5
; @0CD5C 0000:CD5C original=740a
    JE_SHORT loc_0CD68
; @0CD5E 0000:CD5E original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0CD63 0000:CD63 original=7503
    JNE_SHORT loc_0CD68
; @0CD65 0000:CD65 original=e86183
    CALL_NEAR loc_050C9
; @0CD68 0000:CD68 original=5f
    pop di
; @0CD69 0000:CD69 original=8b369ebd
    mov si, word ptr ds:[0BD9Eh]
; @0CD6D 0000:CD6D original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @0CD72 0000:CD72 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @0CD77 0000:CD77 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @0CD7C 0000:CD7C original=d1e3
    shl bx, 1
; @0CD7E 0000:CD7E original=2effa784cd
    jmp word ptr cs:[bx - 0327Ch]
; @0CD83 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,08Ah,0CDh,0CCh,0CDh,0A7h,0CDh
; sub_0000_CD8A
; @0CD8A 0000:CD8A original=b90800
    mov cx, 8
; @0CD8D 0000:CD8D original=8b04
    mov ax, word ptr ds:[si]
; @0CD8F 0000:CD8F original=268905
    mov word ptr es:[di], ax
; @0CD92 0000:CD92 original=83c650
    add si, 050h
; @0CD95 0000:CD95 original=81c70020
    add di, 02000h
; @0CD99 0000:CD99 original=f7c70040
    test di, 04000h
; @0CD9D 0000:CD9D original=7404
    JE_SHORT loc_0CDA3
; @0CD9F 0000:CD9F original=81c750c0
    add di, 0C050h
; @0CDA3 0000:CDA3 original=e2e8
    LOOP_SHORT loc_0CD8D
; @0CDA5 0000:CDA5 original=eb5b
    JMP_SHORT loc_0CE02
; sub_0000_CDA7
; @0CDA7 0000:CDA7 original=b90800
    mov cx, 8
; @0CDAA 0000:CDAA original=8b04
    mov ax, word ptr ds:[si]
; @0CDAC 0000:CDAC original=268905
    mov word ptr es:[di], ax
; @0CDAF 0000:CDAF original=8b4402
    mov ax, word ptr ds:[si + 2]
; @0CDB2 0000:CDB2 original=26894502
    mov word ptr es:[di + 2], ax
; @0CDB6 0000:CDB6 original=81c6a000
    add si, 0A0h
; @0CDBA 0000:CDBA original=81c70020
    add di, 02000h
; @0CDBE 0000:CDBE original=f7c70080
    test di, 08000h
; @0CDC2 0000:CDC2 original=7404
    JE_SHORT loc_0CDC8
; @0CDC4 0000:CDC4 original=81c7a080
    add di, 080A0h
; @0CDC8 0000:CDC8 original=e2e0
    LOOP_SHORT loc_0CDAA
; @0CDCA 0000:CDCA original=eb36
    JMP_SHORT loc_0CE02
; sub_0000_CDCC
; @0CDCC 0000:CDCC original=bac403
    mov dx, 03C4h
; @0CDCF 0000:CDCF original=b002
    mov al, 2
; @0CDD1 0000:CDD1 original=ee
    out dx, al
; @0CDD2 0000:CDD2 original=42
    inc dx
; @0CDD3 0000:CDD3 original=b90800
    mov cx, 8
; @0CDD6 0000:CDD6 original=b001
    mov al, 1
; @0CDD8 0000:CDD8 original=ee
    out dx, al
; @0CDD9 0000:CDD9 original=8a04
    mov al, byte ptr ds:[si]
; @0CDDB 0000:CDDB original=268805
    mov byte ptr es:[di], al
; @0CDDE 0000:CDDE original=b002
    mov al, 2
; @0CDE0 0000:CDE0 original=ee
    out dx, al
; @0CDE1 0000:CDE1 original=8a4428
    mov al, byte ptr ds:[si + 028h]
; @0CDE4 0000:CDE4 original=268805
    mov byte ptr es:[di], al
; @0CDE7 0000:CDE7 original=b004
    mov al, 4
; @0CDE9 0000:CDE9 original=ee
    out dx, al
; @0CDEA 0000:CDEA original=8a4450
    mov al, byte ptr ds:[si + 050h]
; @0CDED 0000:CDED original=268805
    mov byte ptr es:[di], al
; @0CDF0 0000:CDF0 original=b008
    mov al, 8
; @0CDF2 0000:CDF2 original=ee
    out dx, al
; @0CDF3 0000:CDF3 original=8a4478
    mov al, byte ptr ds:[si + 078h]
; @0CDF6 0000:CDF6 original=268805
    mov byte ptr es:[di], al
; @0CDF9 0000:CDF9 original=83c728
    add di, 028h
; @0CDFC 0000:CDFC original=81c6a000
    add si, 0A0h
; @0CE00 0000:CE00 original=e2d4
    LOOP_SHORT loc_0CDD6
; @0CE02 0000:CE02 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CE07 0000:CE07 original=fe0695bd
    inc byte ptr ds:[0BD95h]
; @0CE0B 0000:CE0B original=59
    pop cx
; @0CE0C 0000:CE0C original=e202
    LOOP_SHORT loc_0CE10
; @0CE0E 0000:CE0E original=eb03
    JMP_SHORT loc_0CE13
; @0CE10 0000:CE10 original=e96cfe
    JMP_NEAR loc_0CC7F
; @0CE13 0000:CE13 original=8f0695bd
    pop word ptr ds:[0BD95h]
; @0CE17 0000:CE17 original=800696bd08
    add byte ptr ds:[0BD96h], 8
; @0CE1C 0000:CE1C original=59
    pop cx
; @0CE1D 0000:CE1D original=e202
    LOOP_SHORT loc_0CE21
; @0CE1F 0000:CE1F original=eb03
    JMP_SHORT loc_0CE24
; @0CE21 0000:CE21 original=e952fe
    JMP_NEAR loc_0CC76
; @0CE24 0000:CE24 original=833ea0bd05
    cmp word ptr ds:[0BDA0h], 5
; @0CE29 0000:CE29 original=7406
    JE_SHORT loc_0CE31
; @0CE2B 0000:CE2B original=b90a00
    mov cx, 0Ah
; @0CE2E 0000:CE2E original=e80f00
    CALL_NEAR loc_0CE40
; @0CE31 0000:CE31 original=59
    pop cx
; @0CE32 0000:CE32 original=e202
    LOOP_SHORT loc_0CE36
; @0CE34 0000:CE34 original=eb03
    JMP_SHORT loc_0CE39
; @0CE36 0000:CE36 original=e91ffe
    JMP_NEAR loc_0CC58
; @0CE39 0000:CE39 original=b95000
    mov cx, 050h
; @0CE3C 0000:CE3C original=e80100
    CALL_NEAR loc_0CE40
; @0CE3F 0000:CE3F original=c3
    ret
; sub_0000_CE40
; @0CE40 0000:CE40 original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0CE45 0000:CE45 original=7401
    JE_SHORT loc_0CE48
; @0CE47 0000:CE47 original=c3
    ret
; @0CE48 0000:CE48 original=51
    push cx
; @0CE49 0000:CE49 original=e81633
    CALL_NEAR loc_00162
; @0CE4C 0000:CE4C original=59
    pop cx
; @0CE4D 0000:CE4D original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0CE52 0000:CE52 original=7405
    JE_SHORT loc_0CE59
; @0CE54 0000:CE54 original=c606c39839
    mov byte ptr ds:[098C3h], 039h
; @0CE59 0000:CE59 original=e86d82
    CALL_NEAR loc_050C9
; @0CE5C 0000:CE5C original=e2e2
    LOOP_SHORT loc_0CE40
; @0CE5E 0000:CE5E original=c3
    ret
; sub_0000_CE5F
; @0CE5F 0000:CE5F original=b90500
    mov cx, 5
; @0CE62 0000:CE62 original=51
    push cx
; @0CE63 0000:CE63 original=8b3698bd
    mov si, word ptr ds:[0BD98h]
; @0CE67 0000:CE67 original=ac
    lodsb
; @0CE68 0000:CE68 original=8ae0
    mov ah, al
; @0CE6A 0000:CE6A original=ac
    lodsb
; @0CE6B 0000:CE6B original=56
    push si
; @0CE6C 0000:CE6C original=e8b58b
    CALL_NEAR loc_05A24
; @0CE6F 0000:CE6F original=81c7007d
    add di, 07D00h
; @0CE73 0000:CE73 original=5e
    pop si
; @0CE74 0000:CE74 original=ac
    lodsb
; @0CE75 0000:CE75 original=893698bd
    mov word ptr ds:[0BD98h], si
; @0CE79 0000:CE79 original=32e4
    xor ah, ah
; @0CE7B 0000:CE7B original=8bf0
    mov si, ax
; @0CE7D 0000:CE7D original=d1e6
    shl si, 1
; @0CE7F 0000:CE7F original=81c6920c
    add si, 0C92h
; @0CE83 0000:CE83 original=2e8b34
    mov si, word ptr cs:[si]
; @0CE86 0000:CE86 original=2e8e1eb895
    mov ds, word ptr cs:[095B8h]
; @0CE8B 0000:CE8B original=e8cc8b
    CALL_NEAR loc_05A5A
; @0CE8E 0000:CE8E original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CE93 0000:CE93 original=59
    pop cx
; @0CE94 0000:CE94 original=e2cc
    LOOP_SHORT loc_0CE62
; @0CE96 0000:CE96 original=c3
    ret
; sub_0000_CE97
; @0CE97 0000:CE97 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @0CE9C 0000:CE9C original=33c0
    xor ax, ax
; @0CE9E 0000:CE9E original=e8838b
    CALL_NEAR loc_05A24
; @0CEA1 0000:CEA1 original=be0f00
    mov si, 0Fh
; @0CEA4 0000:CEA4 original=d1e6
    shl si, 1
; @0CEA6 0000:CEA6 original=81c6920c
    add si, 0C92h
; @0CEAA 0000:CEAA original=2e8b34
    mov si, word ptr cs:[si]
; @0CEAD 0000:CEAD original=2e8e1eb895
    mov ds, word ptr cs:[095B8h]
; @0CEB2 0000:CEB2 original=e8a58b
    CALL_NEAR loc_05A5A
; @0CEB5 0000:CEB5 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CEBA 0000:CEBA original=b91200
    mov cx, 012h
; @0CEBD 0000:CEBD original=51
    push cx
; @0CEBE 0000:CEBE original=8ae1
    mov ah, cl
; @0CEC0 0000:CEC0 original=02e4
    add ah, ah
; @0CEC2 0000:CEC2 original=8ac4
    mov al, ah
; @0CEC4 0000:CEC4 original=02e4
    add ah, ah
; @0CEC6 0000:CEC6 original=02e4
    add ah, ah
; @0CEC8 0000:CEC8 original=02e0
    add ah, al
; @0CECA 0000:CECA original=32c0
    xor al, al
; @0CECC 0000:CECC original=e8558b
    CALL_NEAR loc_05A24
; @0CECF 0000:CECF original=be1000
    mov si, 010h
; @0CED2 0000:CED2 original=d1e6
    shl si, 1
; @0CED4 0000:CED4 original=81c6920c
    add si, 0C92h
; @0CED8 0000:CED8 original=2e8b34
    mov si, word ptr cs:[si]
; @0CEDB 0000:CEDB original=2e8e1eb895
    mov ds, word ptr cs:[095B8h]
; @0CEE0 0000:CEE0 original=e8778b
    CALL_NEAR loc_05A5A
; @0CEE3 0000:CEE3 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CEE8 0000:CEE8 original=59
    pop cx
; @0CEE9 0000:CEE9 original=e2d2
    LOOP_SHORT loc_0CEBD
; @0CEEB 0000:CEEB original=32c0
    xor al, al
; @0CEED 0000:CEED original=b4be
    mov ah, 0BEh
; @0CEEF 0000:CEEF original=e8328b
    CALL_NEAR loc_05A24
; @0CEF2 0000:CEF2 original=be1100
    mov si, 011h
; @0CEF5 0000:CEF5 original=d1e6
    shl si, 1
; @0CEF7 0000:CEF7 original=81c6920c
    add si, 0C92h
; @0CEFB 0000:CEFB original=2e8b34
    mov si, word ptr cs:[si]
; @0CEFE 0000:CEFE original=2e8e1eb895
    mov ds, word ptr cs:[095B8h]
; @0CF03 0000:CF03 original=e8548b
    CALL_NEAR loc_05A5A
; @0CF06 0000:CF06 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CF0B 0000:CF0B original=2e8e069895
    mov es, word ptr cs:[09598h]
; @0CF10 0000:CF10 original=06
    push es
; @0CF11 0000:CF11 original=1f
    pop ds
; @0CF12 0000:CF12 original=33f6
    xor si, si
; @0CF14 0000:CF14 original=bf007d
    mov di, 07D00h
; @0CF17 0000:CF17 original=b9007d
    mov cx, 07D00h
; @0CF1A 0000:CF1A original=f3a4
    rep movsb
; @0CF1C 0000:CF1C original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CF21 0000:CF21 original=c3
    ret
; sub_0000_CF22
; @0CF22 0000:CF22 original=b80040
    mov ax, 04000h
; @0CF25 0000:CF25 original=bea2bd
    mov si, 0BDA2h
; @0CF28 0000:CF28 original=9a00003a15
    CALL_FAR 0153Ah,00h
; @0CF2D 0000:CF2D original=c3
    ret
; sub_0000_CF2E
; @0CF2E 0000:CF2E original=e81482
    CALL_NEAR loc_05145
; @0CF31 0000:CF31 original=e8ba8c
    CALL_NEAR loc_05BEE
; @0CF34 0000:CF34 original=c606c39800
    mov byte ptr ds:[098C3h], 0
; @0CF39 0000:CF39 original=b90400
    mov cx, 4
; @0CF3C 0000:CF3C original=33f6
    xor si, si
; @0CF3E 0000:CF3E original=51
    push cx
; @0CF3F 0000:CF3F original=56
    push si
; @0CF40 0000:CF40 original=d1e6
    shl si, 1
; @0CF42 0000:CF42 original=d1e6
    shl si, 1
; @0CF44 0000:CF44 original=32c0
    xor al, al
; @0CF46 0000:CF46 original=8aa4aebd
    mov ah, byte ptr ds:[si - 04252h]
; @0CF4A 0000:CF4A original=ffb4b0bd
    push word ptr ds:[si - 04250h]
; @0CF4E 0000:CF4E original=56
    push si
; @0CF4F 0000:CF4F original=e8ae8a
    CALL_NEAR loc_05A00
; @0CF52 0000:CF52 original=5e
    pop si
; @0CF53 0000:CF53 original=8a84afbd
    mov al, byte ptr ds:[si - 04251h]
; @0CF57 0000:CF57 original=32e4
    xor ah, ah
; @0CF59 0000:CF59 original=8bf0
    mov si, ax
; @0CF5B 0000:CF5B original=d1e6
    shl si, 1
; @0CF5D 0000:CF5D original=81c6e40b
    add si, 0BE4h
; @0CF61 0000:CF61 original=2e8b34
    mov si, word ptr cs:[si]
; @0CF64 0000:CF64 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @0CF69 0000:CF69 original=e8008b
    CALL_NEAR loc_05A6C
; @0CF6C 0000:CF6C original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0CF71 0000:CF71 original=5d
    pop bp
; @0CF72 0000:CF72 original=e81782
    CALL_NEAR loc_0518C
; @0CF75 0000:CF75 original=b96400
    mov cx, 064h
; @0CF78 0000:CF78 original=e84e81
    CALL_NEAR loc_050C9
; @0CF7B 0000:CF7B original=51
    push cx
; @0CF7C 0000:CF7C original=e8e331
    CALL_NEAR loc_00162
; @0CF7F 0000:CF7F original=59
    pop cx
; @0CF80 0000:CF80 original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0CF85 0000:CF85 original=7510
    JNE_SHORT loc_0CF97
; @0CF87 0000:CF87 original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0CF8C 0000:CF8C original=7509
    JNE_SHORT loc_0CF97
; @0CF8E 0000:CF8E original=e2e8
    LOOP_SHORT loc_0CF78
; @0CF90 0000:CF90 original=5e
    pop si
; @0CF91 0000:CF91 original=46
    inc si
; @0CF92 0000:CF92 original=59
    pop cx
; @0CF93 0000:CF93 original=e2a9
    LOOP_SHORT loc_0CF3E
; @0CF95 0000:CF95 original=eb05
    JMP_SHORT loc_0CF9C
; @0CF97 0000:CF97 original=5e
    pop si
; @0CF98 0000:CF98 original=59
    pop cx
; @0CF99 0000:CF99 original=e9a400
    JMP_NEAR loc_0D040
; @0CF9C 0000:CF9C original=c706acbd0100
    mov word ptr ds:[0BDACh], 1
; @0CFA2 0000:CFA2 original=e8a081
    CALL_NEAR loc_05145
; @0CFA5 0000:CFA5 original=e8468c
    CALL_NEAR loc_05BEE
; @0CFA8 0000:CFA8 original=e81880
    CALL_NEAR loc_04FC3
; @0CFAB 0000:CFAB original=e8bc82
    CALL_NEAR loc_0526A
; @0CFAE 0000:CFAE original=e82af5
    CALL_NEAR loc_0C4DB
; @0CFB1 0000:CFB1 original=e8f2f3
    CALL_NEAR loc_0C3A6
; @0CFB4 0000:CFB4 original=c70670a90000
    mov word ptr ds:[0A970h], 0
; @0CFBA 0000:CFBA original=c70672a90000
    mov word ptr ds:[0A972h], 0
; @0CFC0 0000:CFC0 original=c70676a90000
    mov word ptr ds:[0A976h], 0
; @0CFC6 0000:CFC6 original=c70674a90000
    mov word ptr ds:[0A974h], 0
; @0CFCC 0000:CFCC original=c7067ea90000
    mov word ptr ds:[0A97Eh], 0
; @0CFD2 0000:CFD2 original=c70650239c00
    mov word ptr ds:[02350h], 09Ch
; @0CFD8 0000:CFD8 original=e8e4c9
    CALL_NEAR InitPositionHistory_099BF
; Clear the shared byte-attribute table before calling the setup path at 007EF.
; Forward fill requires DF=0; this is state initialization, not static table contents.
; @0CFDB 0000:CFDB original=2e8e069695
    mov es, word ptr cs:[MAIN_DATA_SEGMENT]
; @0CFE0 0000:CFE0 original=bfaac3
    mov di, BYTE_ATTRIBUTE_TABLE
; @0CFE3 0000:CFE3 original=b90001
    mov cx, BYTE_ATTRIBUTE_COUNT
; @0CFE6 0000:CFE6 original=32c0
    xor al, al
; @0CFE8 0000:CFE8 original=f3aa
    rep stosb
; @0CFEA 0000:CFEA original=e80238
    CALL_NEAR loc_007EF
; @0CFED 0000:CFED original=bd7c23
    mov bp, 0237Ch
; @0CFF0 0000:CFF0 original=e8efcb
    CALL_NEAR StoreApplyHistoryAndConditionalPlacement_09BE2
; @0CFF3 0000:CFF3 original=e84ad9
    CALL_NEAR loc_0A940
; @0CFF6 0000:CFF6 original=c70606be0000
    mov word ptr ds:[0BE06h], 0
; @0CFFC 0000:CFFC original=c70608be6400
    mov word ptr ds:[0BE08h], 064h
; @0D002 0000:D002 original=c606c39800
    mov byte ptr ds:[098C3h], 0
; @0D007 0000:D007 original=e86836
    CALL_NEAR ClearByteCS066B_00672
; @0D00A 0000:D00A original=e81281
    CALL_NEAR loc_0511F
; @0D00D 0000:D00D original=e836d8
    CALL_NEAR loc_0A846
; @0D010 0000:D010 original=e8c98b
    CALL_NEAR loc_05BDC
; @0D013 0000:D013 original=e8f6d8
    CALL_NEAR loc_0A90C
; @0D016 0000:D016 original=e83400
    CALL_NEAR loc_0D04D
; @0D019 0000:D019 original=e824d9
    CALL_NEAR loc_0A940
; @0D01C 0000:D01C original=e8428f
    CALL_NEAR loc_05F61
; @0D01F 0000:D01F original=e81a37
    CALL_NEAR loc_0073C
; @0D022 0000:D022 original=e83b81
    CALL_NEAR loc_05160
; @0D025 0000:D025 original=e85136
    CALL_NEAR WaitByteCS066B_00679
; @0D028 0000:D028 original=833e06be13
    cmp word ptr ds:[0BE06h], 013h
; @0D02D 0000:D02D original=7411
    JE_SHORT loc_0D040
; @0D02F 0000:D02F original=e83031
    CALL_NEAR loc_00162
; @0D032 0000:D032 original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0D037 0000:D037 original=7507
    JNE_SHORT loc_0D040
; @0D039 0000:D039 original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0D03E 0000:D03E original=74c7
    JE_SHORT loc_0D007
; @0D040 0000:D040 original=c706acbd0000
    mov word ptr ds:[0BDACh], 0
; @0D046 0000:D046 original=e8a58b
    CALL_NEAR loc_05BEE
; @0D049 0000:D049 original=e81e82
    CALL_NEAR loc_0526A
; @0D04C 0000:D04C original=c3
    ret
; sub_0000_D04D
; @0D04D 0000:D04D original=c70678a20000
    mov word ptr ds:[0A278h], 0
; @0D053 0000:D053 original=b01f
    mov al, 01Fh
; @0D055 0000:D055 original=b418
    mov ah, 018h
; @0D057 0000:D057 original=e8a689
    CALL_NEAR loc_05A00
; @0D05A 0000:D05A original=8b1e06be
    mov bx, word ptr ds:[0BE06h]
; @0D05E 0000:D05E original=d1e3
    shl bx, 1
; @0D060 0000:D060 original=8bc3
    mov ax, bx
; @0D062 0000:D062 original=d1e3
    shl bx, 1
; @0D064 0000:D064 original=03d8
    add bx, ax
; @0D066 0000:D066 original=8bb718be
    mov si, word ptr ds:[bx - 041E8h]
; @0D06A 0000:D06A original=d1e6
    shl si, 1
; @0D06C 0000:D06C original=81c6e40b
    add si, 0BE4h
; @0D070 0000:D070 original=2e8b34
    mov si, word ptr cs:[si]
; @0D073 0000:D073 original=1e
    push ds
; @0D074 0000:D074 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @0D079 0000:D079 original=e8f089
    CALL_NEAR loc_05A6C
; @0D07C 0000:D07C original=1f
    pop ds
; @0D07D 0000:D07D original=e892d1
    CALL_NEAR loc_0A212
; @0D080 0000:D080 original=833e06be08
    cmp word ptr ds:[0BE06h], 8
; @0D085 0000:D085 original=7243
    JB_SHORT loc_0D0CA
; @0D087 0000:D087 original=833e08be14
    cmp word ptr ds:[0BE08h], 014h
; @0D08C 0000:D08C original=723c
    JB_SHORT loc_0D0CA
; @0D08E 0000:D08E original=c606be9800
    mov byte ptr ds:[098BEh], 0
; @0D093 0000:D093 original=ff060abe
    inc word ptr ds:[0BE0Ah]
; @0D097 0000:D097 original=833e0abe14
    cmp word ptr ds:[0BE0Ah], 014h
; @0D09C 0000:D09C original=7206
    JB_SHORT loc_0D0A4
; @0D09E 0000:D09E original=c7060abe0000
    mov word ptr ds:[0BE0Ah], 0
; @0D0A4 0000:D0A4 original=833e0abe0f
    cmp word ptr ds:[0BE0Ah], 0Fh
; @0D0A9 0000:D0A9 original=740e
    JE_SHORT loc_0D0B9
; @0D0AB 0000:D0AB original=833e0abe11
    cmp word ptr ds:[0BE0Ah], 011h
; @0D0B0 0000:D0B0 original=7407
    JE_SHORT loc_0D0B9
; @0D0B2 0000:D0B2 original=833e0abe13
    cmp word ptr ds:[0BE0Ah], 013h
; @0D0B7 0000:D0B7 original=7505
    JNE_SHORT loc_0D0BE
; @0D0B9 0000:D0B9 original=c606be9810
    mov byte ptr ds:[098BEh], 010h
; @0D0BE 0000:D0BE original=bd7c23
    mov bp, 0237Ch
; @0D0C1 0000:D0C1 original=c70680a90000
    mov word ptr ds:[0A980h], 0
; @0D0C7 0000:D0C7 original=e89dcf
    CALL_NEAR loc_0A067
; @0D0CA 0000:D0CA original=833e06be00
    cmp word ptr ds:[0BE06h], 0
; @0D0CF 0000:D0CF original=7503
    JNE_SHORT loc_0D0D4
; @0D0D1 0000:D0D1 original=e98c00
    JMP_NEAR loc_0D160
; @0D0D4 0000:D0D4 original=ff0e08be
    dec word ptr ds:[0BE08h]
; @0D0D8 0000:D0D8 original=7401
    JE_SHORT loc_0D0DB
; @0D0DA 0000:D0DA original=c3
    ret
; @0D0DB 0000:D0DB original=c70608be6400
    mov word ptr ds:[0BE08h], 064h
; @0D0E1 0000:D0E1 original=ff0606be
    inc word ptr ds:[0BE06h]
; @0D0E5 0000:D0E5 original=8b1e06be
    mov bx, word ptr ds:[0BE06h]
; @0D0E9 0000:D0E9 original=d1e3
    shl bx, 1
; @0D0EB 0000:D0EB original=8bc3
    mov ax, bx
; @0D0ED 0000:D0ED original=d1e3
    shl bx, 1
; @0D0EF 0000:D0EF original=03d8
    add bx, ax
; @0D0F1 0000:D0F1 original=8b871abe
    mov ax, word ptr ds:[bx - 041E6h]
; @0D0F5 0000:D0F5 original=3dffff
    cmp ax, 0FFFFh
; @0D0F8 0000:D0F8 original=740d
    JE_SHORT loc_0D107
; @0D0FA 0000:D0FA original=a3fa95
    mov word ptr ds:[095FAh], ax
; @0D0FD 0000:D0FD original=8b871cbe
    mov ax, word ptr ds:[bx - 041E4h]
; @0D101 0000:D101 original=a316be
    mov word ptr ds:[0BE16h], ax
; @0D104 0000:D104 original=e897b4
    CALL_NEAR loc_0859E
; @0D107 0000:D107 original=8b1e06be
    mov bx, word ptr ds:[0BE06h]
; @0D10B 0000:D10B original=d1e3
    shl bx, 1
; @0D10D 0000:D10D original=2effa712d1
    jmp word ptr cs:[bx - 02EEEh]
; @0D112 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,044h,09Fh,0D1h,029h,0D2h,083h,0D1h,04Ah,0D2h,083h,0D1h,0DCh,0D1h,0F8h,0D1h
; @0D122 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,044h,0AFh,044h,04Dh,0D1h,052h,0D1h,04Dh,0D1h,04Dh,0D1h,04Dh,0D1h,04Dh,0D1h
; @0D132 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ah,0D1h,059h,0D1h,0AFh,044h,0AFh,044h,0E8h,0B7h,0B0h,0C7h,047h,04h,0C0h,00h
; @0D142 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,02h,0C8h,00h,0C7h,047h,018h,051h,00h,0C3h,0FFh,06h,058h,0A9h,0C3h
; @0D152 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,05Eh,0A9h,01h,00h,0C3h,0C7h,06h,060h,0A9h,01h,00h,0C3h
; @0D160 0000:D160 original=833e7e2360
    cmp word ptr ds:[0237Eh], 060h
; @0D165 0000:D165 original=7503
    JNE_SHORT loc_0D16A
; @0D167 0000:D167 original=e96aff
    JMP_NEAR loc_0D0D4
; @0D16A 0000:D16A original=ff0e7e23
    dec word ptr ds:[0237Eh]
; @0D16E 0000:D16E original=bd7c23
    mov bp, 0237Ch
; @0D171 0000:D171 original=e86eca
    CALL_NEAR StoreApplyHistoryAndConditionalPlacement_09BE2
; @0D174 0000:D174 original=833e7e2360
    cmp word ptr ds:[0237Eh], 060h
; @0D179 0000:D179 original=7401
    JE_SHORT loc_0D17C
; @0D17B 0000:D17B original=c3
    ret
; @0D17C 0000:D17C original=c70608be3200
    mov word ptr ds:[0BE08h], 032h
; @0D182 0000:D182 original=c3
    ret
; @0D183 0000:D183 original=ff068423 runtime CFG evidence
    inc word ptr ds:[02384h]
; @0D187 0000:D187 original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0D18C 0000:D18C original=7405 runtime CFG evidence
    JE_SHORT loc_0D193
; @0D18E 0000:D18E original=c606ffbe06 runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 6
; @0D193 0000:D193 original=c70608be3200 runtime CFG evidence
    mov word ptr ds:[0BE08h], 032h
; @0D199 0000:D199 original=bd7c23 runtime CFG evidence
    mov bp, 0237Ch
; @0D19C 0000:D19C original=e910ce runtime CFG evidence
    JMP_NEAR PlaceFourRecordsFromOffsetTables_09FAF
; @0D19F 0000:D19F original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0D1A4 0000:D1A4 original=7405 runtime CFG evidence
    JE_SHORT loc_0D1AB
; @0D1A6 0000:D1A6 original=c606ffbe1e runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 01Eh
; @0D1AB 0000:D1AB original=bd7c23 runtime CFG evidence
    mov bp, 0237Ch
; @0D1AE 0000:D1AE original=e873a3 runtime CFG evidence
    CALL_NEAR FindFreeRecordPoolA_07524
; @0D1B1 0000:D1B1 original=891e6ea9 runtime CFG evidence
    mov word ptr ds:[0A96Eh], bx
; @0D1B5 0000:D1B5 original=e851b0 runtime CFG evidence
    CALL_NEAR loc_08209
; @0D1B8 0000:D1B8 original=c747020000 runtime CFG evidence
    mov word ptr ds:[bx + 2], 0
; @0D1BD 0000:D1BD original=c747080f00 runtime CFG evidence
    mov word ptr ds:[bx + 8], 0Fh
; @0D1C2 0000:D1C2 original=c747185000 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 050h
; @0D1C7 0000:D1C7 original=8beb runtime CFG evidence
    mov bp, bx
; @0D1C9 0000:D1C9 original=a18023 runtime CFG evidence
    mov ax, word ptr ds:[02380h]
; @0D1CC 0000:D1CC original=050800 runtime CFG evidence
    add ax, 8
; @0D1CF 0000:D1CF original=894632 runtime CFG evidence
    mov word ptr ss:[bp + 032h], ax
; @0D1D2 0000:D1D2 original=a17e23 runtime CFG evidence
    mov ax, word ptr ds:[0237Eh]
; @0D1D5 0000:D1D5 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0D1D8 0000:D1D8 original=894634 runtime CFG evidence
    mov word ptr ss:[bp + 034h], ax
; @0D1DB 0000:D1DB original=c3 runtime CFG evidence
    ret
; @0D1DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,0E8h,02Fh,0CDh,08Bh
; @0D1EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,062h,0A9h,0E8h,021h,00h,0C7h,046h,04h,00h,00h,0C3h,080h,03Eh,0C0h,098h
; @0D1FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,0E8h,013h,0CDh,08Bh,02Eh,064h,0A9h,0E8h
; @0D20C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,083h,046h,034h,014h,0C3h,0E8h,053h,00h,0A1h,080h,023h,05h,08h,00h
; @0D21C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,032h,0A1h,07Eh,023h,05h,028h,00h,089h,046h,034h,0C3h
; @0D229 0000:D229 original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0D22E 0000:D22E original=7405 runtime CFG evidence
    JE_SHORT loc_0D235
; @0D230 0000:D230 original=c606ffbe1e runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 01Eh
; @0D235 0000:D235 original=e827cd runtime CFG evidence
    CALL_NEAR loc_09F5F
; @0D238 0000:D238 original=8b2e66a9 runtime CFG evidence
    mov bp, word ptr ds:[0A966h]
; @0D23C 0000:D23C original=e82a00 runtime CFG evidence
    CALL_NEAR loc_0D269
; @0D23F 0000:D23F original=c746040000 runtime CFG evidence
    mov word ptr ss:[bp + 4], 0
; @0D244 0000:D244 original=8b2e68a9 runtime CFG evidence
    mov bp, word ptr ds:[0A968h]
; @0D248 0000:D248 original=eb1f runtime CFG evidence
    JMP_SHORT loc_0D269
; @0D24A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Eh,0E8h,06h,0CDh,08Bh
; @0D25A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,06Ah,0A9h,0E8h,09h,00h,0C7h,046h,04h,00h,00h,08Bh,02Eh,06Ch,0A9h
; @0D269 0000:D269 original=e82bec runtime CFG evidence
    CALL_NEAR loc_0BE97
; @0D26C 0000:D26C original=c74602c800 runtime CFG evidence
    mov word ptr ss:[bp + 2], 0C8h
; @0D271 0000:D271 original=c74604c000 runtime CFG evidence
    mov word ptr ss:[bp + 4], 0C0h
; @0D276 0000:D276 original=c746185000 runtime CFG evidence
    mov word ptr ss:[bp + 018h], 050h
; @0D27B 0000:D27B original=c746160400 runtime CFG evidence
    mov word ptr ss:[bp + 016h], 4
; @0D280 0000:D280 original=c3 runtime CFG evidence
    ret
; @0D281 0000:D281 original=8b4632 runtime CFG evidence
    mov ax, word ptr ss:[bp + 032h]
; @0D284 0000:D284 original=a30423 runtime CFG evidence
    mov word ptr ds:[02304h], ax
; @0D287 0000:D287 original=8b4634 runtime CFG evidence
    mov ax, word ptr ss:[bp + 034h]
; @0D28A 0000:D28A original=a30623 runtime CFG evidence
    mov word ptr ds:[02306h], ax
; @0D28D 0000:D28D original=c70608230100 runtime CFG evidence
    mov word ptr ds:[02308h], 1
; @0D293 0000:D293 original=e81c8b runtime CFG evidence
    CALL_NEAR loc_05DB2
; @0D296 0000:D296 original=c70608230200 runtime CFG evidence
    mov word ptr ds:[02308h], 2
; @0D29C 0000:D29C original=833e0a2300 runtime CFG evidence
    cmp word ptr ds:[0230Ah], 0
; @0D2A1 0000:D2A1 original=7501 runtime CFG evidence
    JNE_SHORT loc_0D2A4
; @0D2A3 0000:D2A3 original=c3 runtime CFG evidence
    ret
; @0D2A4 0000:D2A4 original=c746160100 runtime CFG evidence
    mov word ptr ss:[bp + 016h], 1
; @0D2A9 0000:D2A9 original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @0D2AE 0000:D2AE original=7405 runtime CFG evidence
    JE_SHORT loc_0D2B5
; @0D2B0 0000:D2B0 original=c606ffbe0e runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 0Eh
; @0D2B5 0000:D2B5 original=c3 runtime CFG evidence
    ret
; @0D2B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h
; @0D2B8 0000:D2B8 original=8b36d6be runtime CFG evidence
    mov si, word ptr ds:[0BED6h]
; @0D2BC 0000:D2BC original=8b1ed4be runtime CFG evidence
    mov bx, word ptr ds:[0BED4h]
; @0D2C0 0000:D2C0 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0D2C2 0000:D2C2 original=8b00 runtime CFG evidence
    mov ax, word ptr ds:[bx + si]
; @0D2C4 0000:D2C4 original=2ea3de0b runtime CFG evidence
    mov word ptr cs:[0BDEh], ax
; @0D2C8 0000:D2C8 original=2ea19895 runtime CFG evidence
    mov ax, word ptr cs:[09598h]
; @0D2CC 0000:D2CC original=2ea3dc0b runtime CFG evidence
    mov word ptr cs:[0BDCh], ax
; @0D2D0 0000:D2D0 original=2ec706da0b0080 runtime CFG evidence
    mov word ptr cs:[0BDAh], 08000h
; @0D2D7 0000:D2D7 original=2ec706e00bb6d2 runtime CFG evidence
    mov word ptr cs:[0BE0h], 0D2B6h
; @0D2DE 0000:D2DE original=c60684bb01 runtime CFG evidence
    mov byte ptr ds:[0BB84h], 1
; @0D2E3 0000:D2E3 original=e8d239 runtime CFG evidence
    CALL_NEAR loc_00CB8
; @0D2E6 0000:D2E6 original=c60684bb00 runtime CFG evidence
    mov byte ptr ds:[0BB84h], 0
; @0D2EB 0000:D2EB original=2ec706da0b0000 runtime CFG evidence
    mov word ptr cs:[0BDAh], 0
; @0D2F2 0000:D2F2 original=33ff runtime CFG evidence
    xor di, di
; @0D2F4 0000:D2F4 original=be0080 runtime CFG evidence
    mov si, 08000h
; @0D2F7 0000:D2F7 original=2e8e1e9895 runtime CFG evidence
    mov ds, word ptr cs:[09598h]
; @0D2FC 0000:D2FC original=e86d87 runtime CFG evidence
    CALL_NEAR loc_05A6C
; @0D2FF 0000:D2FF original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @0D304 0000:D304 original=c3 runtime CFG evidence
    ret
; sub_0000_D305
; @0D305 0000:D305 original=e85a2e
    CALL_NEAR loc_00162
; @0D308 0000:D308 original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0D30D 0000:D30D original=75f6
    JNE_SHORT loc_0D305
; @0D30F 0000:D30F original=e8ca88
    CALL_NEAR loc_05BDC
; @0D312 0000:D312 original=c706d8be0000
    mov word ptr ds:[0BED8h], 0
; @0D318 0000:D318 original=e85733
    CALL_NEAR ClearByteCS066B_00672
; @0D31B 0000:D31B original=e8017e
    CALL_NEAR loc_0511F
; @0D31E 0000:D31E original=e8cc79
    CALL_NEAR loc_04CED
; @0D321 0000:D321 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @0D327 0000:D327 original=7503
    JNE_SHORT loc_0D32C
; @0D329 0000:D329 original=e8b088
    CALL_NEAR loc_05BDC
; @0D32C 0000:D32C original=e83800
    CALL_NEAR loc_0D367
; @0D32F 0000:D32F original=e8327a
    CALL_NEAR loc_04D64
; @0D332 0000:D332 original=9a22097f0f
    CALL_FAR 0F7Fh,0922h
; @0D337 0000:D337 original=e80234
    CALL_NEAR loc_0073C
; @0D33A 0000:D33A original=e8658d
    CALL_NEAR loc_060A2
; @0D33D 0000:D33D original=e8207e
    CALL_NEAR loc_05160
; @0D340 0000:D340 original=e83633
    CALL_NEAR WaitByteCS066B_00679
; @0D343 0000:D343 original=e8837d
    CALL_NEAR loc_050C9
; @0D346 0000:D346 original=ff06d8be
    inc word ptr ds:[0BED8h]
; @0D34A 0000:D34A original=813ed8bec800
    cmp word ptr ds:[0BED8h], 0C8h
; @0D350 0000:D350 original=770a
    JA_SHORT loc_0D35C
; @0D352 0000:D352 original=e80d2e
    CALL_NEAR loc_00162
; @0D355 0000:D355 original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0D35A 0000:D35A original=74bc
    JE_SHORT loc_0D318
; @0D35C 0000:D35C original=e8032e
    CALL_NEAR loc_00162
; @0D35F 0000:D35F original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0D364 0000:D364 original=75f6
    JNE_SHORT loc_0D35C
; @0D366 0000:D366 original=c3
    ret
; sub_0000_D367
; @0D367 0000:D367 original=b447
    mov ah, 047h
; @0D369 0000:D369 original=b003
    mov al, 3
; @0D36B 0000:D36B original=e89286
    CALL_NEAR loc_05A00
; @0D36E 0000:D36E original=33f6
    xor si, si
; @0D370 0000:D370 original=2e8e1eb695
    mov ds, word ptr cs:[095B6h]
; @0D375 0000:D375 original=e8f486
    CALL_NEAR loc_05A6C
; @0D378 0000:D378 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0D37D 0000:D37D original=c3
    ret
; @0D37E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D38E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h
; sub_0000_D390
; @0D390 0000:D390 original=e8cf2d
    CALL_NEAR loc_00162
; @0D393 0000:D393 original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0D398 0000:D398 original=75f6
    JNE_SHORT loc_0D390
; @0D39A 0000:D39A original=e8a87d
    CALL_NEAR loc_05145
; @0D39D 0000:D39D original=c60684bb01
    mov byte ptr ds:[0BB84h], 1
; @0D3A2 0000:D3A2 original=2ec706de0ba314
    mov word ptr cs:[0BDEh], 014A3h
; @0D3A9 0000:D3A9 original=2ea19895
    mov ax, word ptr cs:[09598h]
; @0D3AD 0000:D3AD original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @0D3B1 0000:D3B1 original=2ec706da0b0080
    mov word ptr cs:[0BDAh], 08000h
; @0D3B8 0000:D3B8 original=2ec706e00bb6d2
    mov word ptr cs:[0BE0h], 0D2B6h
; @0D3BF 0000:D3BF original=2ec606ed4500
    mov byte ptr cs:[045EDh], 0
; @0D3C5 0000:D3C5 original=e8f038
    CALL_NEAR loc_00CB8
; @0D3C8 0000:D3C8 original=2ec606ed4501
    mov byte ptr cs:[045EDh], 1
; @0D3CE 0000:D3CE original=2ec706de0bb214
    mov word ptr cs:[0BDEh], 014B2h
; @0D3D5 0000:D3D5 original=2ea19895
    mov ax, word ptr cs:[09598h]
; @0D3D9 0000:D3D9 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @0D3DD 0000:D3DD original=2ec706da0b0040
    mov word ptr cs:[0BDAh], 04000h
; @0D3E4 0000:D3E4 original=2ec706e00b7ed3
    mov word ptr cs:[0BE0h], 0D37Eh
; @0D3EB 0000:D3EB original=c706c4210100
    mov word ptr ds:[021C4h], 1
; @0D3F1 0000:D3F1 original=e8c438
    CALL_NEAR loc_00CB8
; @0D3F4 0000:D3F4 original=c706c4210000
    mov word ptr ds:[021C4h], 0
; @0D3FA 0000:D3FA original=c60684bb00
    mov byte ptr ds:[0BB84h], 0
; @0D3FF 0000:D3FF original=2ec706da0b0000
    mov word ptr cs:[0BDAh], 0
; @0D406 0000:D406 original=e86932
    CALL_NEAR ClearByteCS066B_00672
; @0D409 0000:D409 original=e8137d
    CALL_NEAR loc_0511F
; @0D40C 0000:D40C original=e89b00
    CALL_NEAR loc_0D4AA
; @0D40F 0000:D40F original=e84e7d
    CALL_NEAR loc_05160
; @0D412 0000:D412 original=e8b47c
    CALL_NEAR loc_050C9
; @0D415 0000:D415 original=e81c00
    CALL_NEAR loc_0D434
; @0D418 0000:D418 original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0D41D 0000:D41D original=7505
    JNE_SHORT loc_0D424
; @0D41F 0000:D41F original=e85732
    CALL_NEAR WaitByteCS066B_00679
; @0D422 0000:D422 original=ebe2
    JMP_SHORT loc_0D406
; @0D424 0000:D424 original=a1dabe
    mov ax, word ptr ds:[0BEDAh]
; @0D427 0000:D427 original=40
    inc ax
; @0D428 0000:D428 original=3d0600
    cmp ax, 6
; @0D42B 0000:D42B original=7502
    JNE_SHORT loc_0D42F
; @0D42D 0000:D42D original=33c0
    xor ax, ax
; @0D42F 0000:D42F original=48
    dec ax
; @0D430 0000:D430 original=a35623
    mov word ptr ds:[02356h], ax
; @0D433 0000:D433 original=c3
    ret
; sub_0000_D434
; @0D434 0000:D434 original=803ee49801
    cmp byte ptr ds:[098E4h], 1
; @0D439 0000:D439 original=74f9
    JE_SHORT loc_0D434
; @0D43B 0000:D43B original=e8242d
    CALL_NEAR loc_00162
; @0D43E 0000:D43E original=803ebe9800
    cmp byte ptr ds:[098BEh], 0
; @0D443 0000:D443 original=75f6
    JNE_SHORT loc_0D43B
; @0D445 0000:D445 original=803ee49801
    cmp byte ptr ds:[098E4h], 1
; @0D44A 0000:D44A original=744c
    JE_SHORT loc_0D498
; @0D44C 0000:D44C original=e8132d
    CALL_NEAR loc_00162
; @0D44F 0000:D44F original=a0dabe
    mov al, byte ptr ds:[0BEDAh]
; @0D452 0000:D452 original=f606be9801
    test byte ptr ds:[098BEh], 1
; @0D457 0000:D457 original=751d
    JNE_SHORT loc_0D476
; @0D459 0000:D459 original=f606be9802
    test byte ptr ds:[098BEh], 2
; @0D45E 0000:D45E original=7520
    JNE_SHORT loc_0D480
; @0D460 0000:D460 original=f606be9808
    test byte ptr ds:[098BEh], 8
; @0D465 0000:D465 original=7521
    JNE_SHORT loc_0D488
; @0D467 0000:D467 original=f606be9804
    test byte ptr ds:[098BEh], 4
; @0D46C 0000:D46C original=7522
    JNE_SHORT loc_0D490
; @0D46E 0000:D46E original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0D473 0000:D473 original=74d0
    JE_SHORT loc_0D445
; @0D475 0000:D475 original=c3
    ret
; @0D476 0000:D476 original=3c03
    cmp al, 3
; @0D478 0000:D478 original=73cb
    JAE_SHORT loc_0D445
; @0D47A 0000:D47A original=0403
    add al, 3
; @0D47C 0000:D47C original=a2dabe
    mov byte ptr ds:[0BEDAh], al
; @0D47F 0000:D47F original=c3
    ret
; @0D480 0000:D480 original=3c02
    cmp al, 2
; @0D482 0000:D482 original=76c1
    JBE_SHORT loc_0D445
; @0D484 0000:D484 original=2c03
    sub al, 3
; @0D486 0000:D486 original=ebf4
    JMP_SHORT loc_0D47C
; @0D488 0000:D488 original=0ac0
    or al, al
; @0D48A 0000:D48A original=74b9
    JE_SHORT loc_0D445
; @0D48C 0000:D48C original=fec8
    dec al
; @0D48E 0000:D48E original=ebec
    JMP_SHORT loc_0D47C
; @0D490 0000:D490 original=3c05
    cmp al, 5
; @0D492 0000:D492 original=74b1
    JE_SHORT loc_0D445
; @0D494 0000:D494 original=fec0
    inc al
; @0D496 0000:D496 original=ebe4
    JMP_SHORT loc_0D47C
; @0D498 0000:D498 original=ff06dcbe
    inc word ptr ds:[0BEDCh]
; @0D49C 0000:D49C original=833edcbe03
    cmp word ptr ds:[0BEDCh], 3
; @0D4A1 0000:D4A1 original=7206
    JB_SHORT loc_0D4A9
; @0D4A3 0000:D4A3 original=c706dcbe0000
    mov word ptr ds:[0BEDCh], 0
; @0D4A9 0000:D4A9 original=c3
    ret
; sub_0000_D4AA
; @0D4AA 0000:D4AA original=33ff
    xor di, di
; @0D4AC 0000:D4AC original=be0080
    mov si, 08000h
; @0D4AF 0000:D4AF original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @0D4B4 0000:D4B4 original=e8b585
    CALL_NEAR loc_05A6C
; @0D4B7 0000:D4B7 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0D4BC 0000:D4BC original=8b1edabe
    mov bx, word ptr ds:[0BEDAh]
; @0D4C0 0000:D4C0 original=d1e3
    shl bx, 1
; @0D4C2 0000:D4C2 original=8b87debe
    mov ax, word ptr ds:[bx - 04122h]
; @0D4C6 0000:D4C6 original=e83785
    CALL_NEAR loc_05A00
; @0D4C9 0000:D4C9 original=8b1edabe
    mov bx, word ptr ds:[0BEDAh]
; @0D4CD 0000:D4CD original=83c300
    add bx, 0
; @0D4D0 0000:D4D0 original=d1e3
    shl bx, 1
; @0D4D2 0000:D4D2 original=2e8bb77ed3
    mov si, word ptr cs:[bx - 02C82h]
; @0D4D7 0000:D4D7 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @0D4DC 0000:D4DC original=e88d85
    CALL_NEAR loc_05A6C
; @0D4DF 0000:D4DF original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0D4E4 0000:D4E4 original=8b1edcbe
    mov bx, word ptr ds:[0BEDCh]
; @0D4E8 0000:D4E8 original=d1e3
    shl bx, 1
; @0D4EA 0000:D4EA original=8b87eabe
    mov ax, word ptr ds:[bx - 04116h]
; @0D4EE 0000:D4EE original=e80f85
    CALL_NEAR loc_05A00
; @0D4F1 0000:D4F1 original=8b1edcbe
    mov bx, word ptr ds:[0BEDCh]
; @0D4F5 0000:D4F5 original=83c306
    add bx, 6
; @0D4F8 0000:D4F8 original=d1e3
    shl bx, 1
; @0D4FA 0000:D4FA original=2e8bb77ed3
    mov si, word ptr cs:[bx - 02C82h]
; @0D4FF 0000:D4FF original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @0D504 0000:D504 original=e86585
    CALL_NEAR loc_05A6C
; @0D507 0000:D507 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0D50C 0000:D50C original=c3
    ret
; @0D50D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; sub_0000_D50E
; @0D50E 0000:D50E original=fe0600bf
    inc byte ptr ds:[0BF00h]
; @0D512 0000:D512 original=802600bf03
    and byte ptr ds:[0BF00h], 3
; @0D517 0000:D517 original=a0ffbe
    mov al, byte ptr ds:[0BEFFh]
; @0D51A 0000:D51A original=0ac0
    or al, al
; @0D51C 0000:D51C original=7403
    JE_SHORT loc_0D521
; @0D51E 0000:D51E original=e84500
    CALL_NEAR loc_0D566
; @0D521 0000:D521 original=803efebe00
    cmp byte ptr ds:[0BEFEh], 0
; @0D526 0000:D526 original=743d
    JE_SHORT loc_0D565
; @0D528 0000:D528 original=bfaabf
    mov di, 0BFAAh
; @0D52B 0000:D52B original=e87e00
    CALL_NEAR loc_0D5AC
; @0D52E 0000:D52E original=bfbabf
    mov di, 0BFBAh
; @0D531 0000:D531 original=e87800
    CALL_NEAR loc_0D5AC
; @0D534 0000:D534 original=a000bf
    mov al, byte ptr ds:[0BF00h]
; @0D537 0000:D537 original=d0e8
    shr al, 1
; @0D539 0000:D539 original=720d
    JB_SHORT loc_0D548
; @0D53B 0000:D53B original=803eb3bf00
    cmp byte ptr ds:[0BFB3h], 0
; @0D540 0000:D540 original=7423
    JE_SHORT loc_0D565
; @0D542 0000:D542 original=8b1eb0bf
    mov bx, word ptr ds:[0BFB0h]
; @0D546 0000:D546 original=eb0b
    JMP_SHORT loc_0D553
; @0D548 0000:D548 original=803ec3bf00
    cmp byte ptr ds:[0BFC3h], 0
; @0D54D 0000:D54D original=7416
    JE_SHORT loc_0D565
; @0D54F 0000:D54F original=8b1ec0bf
    mov bx, word ptr ds:[0BFC0h]
; @0D553 0000:D553 original=b0b6
    mov al, 0B6h
; @0D555 0000:D555 original=e643
    out 043h, al
; @0D557 0000:D557 original=8ac3
    mov al, bl
; @0D559 0000:D559 original=e642
    out 042h, al
; @0D55B 0000:D55B original=8ac7
    mov al, bh
; @0D55D 0000:D55D original=e642
    out 042h, al
; @0D55F 0000:D55F original=e461
    in al, 061h
; @0D561 0000:D561 original=0c03
    or al, 3
; @0D563 0000:D563 original=e661
    out 061h, al
; @0D565 0000:D565 original=c3
    ret
; sub_0000_D566
; @0D566 0000:D566 original=3c20
    cmp al, 020h
; @0D568 0000:D568 original=7203
    JB_SHORT loc_0D56D
; @0D56A 0000:D56A original=e9c200
    JMP_NEAR loc_0D62F
; @0D56D 0000:D56D original=803efebe00
    cmp byte ptr ds:[0BEFEh], 0
; @0D572 0000:D572 original=7408
    JE_SHORT loc_0D57C
; @0D574 0000:D574 original=3a06febe
    cmp al, byte ptr ds:[0BEFEh]
; @0D578 0000:D578 original=7402
    JE_SHORT loc_0D57C
; @0D57A 0000:D57A original=73e9
    JAE_SHORT loc_0D565
; @0D57C 0000:D57C original=a2febe
    mov byte ptr ds:[0BEFEh], al
; @0D57F 0000:D57F original=32e4
    xor ah, ah
; @0D581 0000:D581 original=d1e0
    shl ax, 1
; @0D583 0000:D583 original=d1e0
    shl ax, 1
; @0D585 0000:D585 original=becabf
    mov si, 0BFCAh
; @0D588 0000:D588 original=03f0
    add si, ax
; @0D58A 0000:D58A original=ad
    lodsw
; @0D58B 0000:D58B original=a3acbf
    mov word ptr ds:[0BFACh], ax
; @0D58E 0000:D58E original=ad
    lodsw
; @0D58F 0000:D58F original=a3bcbf
    mov word ptr ds:[0BFBCh], ax
; @0D592 0000:D592 original=32c0
    xor al, al
; @0D594 0000:D594 original=a2b5bf
    mov byte ptr ds:[0BFB5h], al
; @0D597 0000:D597 original=a2c5bf
    mov byte ptr ds:[0BFC5h], al
; @0D59A 0000:D59A original=a2b8bf
    mov byte ptr ds:[0BFB8h], al
; @0D59D 0000:D59D original=a2c8bf
    mov byte ptr ds:[0BFC8h], al
; @0D5A0 0000:D5A0 original=a2ffbe
    mov byte ptr ds:[0BEFFh], al
; @0D5A3 0000:D5A3 original=fec0
    inc al
; @0D5A5 0000:D5A5 original=a2b2bf
    mov byte ptr ds:[0BFB2h], al
; @0D5A8 0000:D5A8 original=a2c2bf
    mov byte ptr ds:[0BFC2h], al
; @0D5AB 0000:D5AB original=c3
    ret
; sub_0000_D5AC
; @0D5AC 0000:D5AC original=8b5d02
    mov bx, word ptr ds:[di + 2]
; @0D5AF 0000:D5AF original=fe4d08
    dec byte ptr ds:[di + 8]
; @0D5B2 0000:D5B2 original=7407
    JE_SHORT loc_0D5BB
; @0D5B4 0000:D5B4 original=e85b00
    CALL_NEAR loc_0D612
; @0D5B7 0000:D5B7 original=e84800
    CALL_NEAR loc_0D602
; @0D5BA 0000:D5BA original=c3
    ret
; @0D5BB 0000:D5BB original=8a07
    mov al, byte ptr ds:[bx]
; @0D5BD 0000:D5BD original=43
    inc bx
; @0D5BE 0000:D5BE original=0ac0
    or al, al
; @0D5C0 0000:D5C0 original=7829
    JS_SHORT loc_0D5EB
; @0D5C2 0000:D5C2 original=884504
    mov byte ptr ds:[di + 4], al
; @0D5C5 0000:D5C5 original=e85700
    CALL_NEAR loc_0D61F
; @0D5C8 0000:D5C8 original=c6450902
    mov byte ptr ds:[di + 9], 2
; @0D5CC 0000:D5CC original=895d02
    mov word ptr ds:[di + 2], bx
; @0D5CF 0000:D5CF original=8a4505
    mov al, byte ptr ds:[di + 5]
; @0D5D2 0000:D5D2 original=884508
    mov byte ptr ds:[di + 8], al
; @0D5D5 0000:D5D5 original=c3
    ret
; @0D5D6 0000:D5D6 original=c6450900 runtime CFG evidence
    mov byte ptr ds:[di + 9], 0
; @0D5DA 0000:D5DA original=a0b3bf runtime CFG evidence
    mov al, byte ptr ds:[0BFB3h]
; @0D5DD 0000:D5DD original=0a06c3bf runtime CFG evidence
    or al, byte ptr ds:[0BFC3h]
; @0D5E1 0000:D5E1 original=75e9 runtime CFG evidence
    JNE_SHORT loc_0D5CC
; @0D5E3 0000:D5E3 original=e461 runtime CFG evidence
    in al, 061h
; @0D5E5 0000:D5E5 original=24fc runtime CFG evidence
    and al, 0FCh
; @0D5E7 0000:D5E7 original=e661 runtime CFG evidence
    out 061h, al
; @0D5E9 0000:D5E9 original=ebe1 runtime CFG evidence
    JMP_SHORT loc_0D5CC
; @0D5EB 0000:D5EB original=3ce0
    cmp al, 0E0h
; @0D5ED 0000:D5ED original=730c
    JAE_SHORT loc_0D5FB
; @0D5EF 0000:D5EF original=d0e0
    shl al, 1
; @0D5F1 0000:D5F1 original=32e4
    xor ah, ah
; @0D5F3 0000:D5F3 original=8bf0
    mov si, ax
; @0D5F5 0000:D5F5 original=81c6f0be
    add si, 0BEF0h
; @0D5F9 0000:D5F9 original=ff24
    jmp word ptr ds:[si]
; @0D5FB 0000:D5FB original=2cdf
    sub al, 0DFh
; @0D5FD 0000:D5FD original=884505
    mov byte ptr ds:[di + 5], al
; @0D600 0000:D600 original=ebb9
    JMP_SHORT loc_0D5BB
; sub_0000_D602
; @0D602 0000:D602 original=807d0e00
    cmp byte ptr ds:[di + 0Eh], 0
; @0D606 0000:D606 original=7409
    JE_SHORT loc_0D611
; @0D608 0000:D608 original=fe4d0e
    dec byte ptr ds:[di + 0Eh]
; @0D60B 0000:D60B original=8b450c
    mov ax, word ptr ds:[di + 0Ch]
; @0D60E 0000:D60E original=014506
    add word ptr ds:[di + 6], ax
; @0D611 0000:D611 original=c3
    ret
; sub_0000_D612
; @0D612 0000:D612 original=8a450b
    mov al, byte ptr ds:[di + 0Bh]
; @0D615 0000:D615 original=0ac0
    or al, al
; @0D617 0000:D617 original=7415
    JE_SHORT loc_0D62E
; @0D619 0000:D619 original=024504
    add al, byte ptr ds:[di + 4]
; @0D61C 0000:D61C original=884504
    mov byte ptr ds:[di + 4], al
; sub_0000_D61F
; @0D61F 0000:D61F original=32e4
    xor ah, ah
; @0D621 0000:D621 original=d0e0
    shl al, 1
; @0D623 0000:D623 original=8bf0
    mov si, ax
; @0D625 0000:D625 original=81c601bf
    add si, 0BF01h
; @0D629 0000:D629 original=8b04
    mov ax, word ptr ds:[si]
; @0D62B 0000:D62B original=894506
    mov word ptr ds:[di + 6], ax
; @0D62E 0000:D62E original=c3
    ret
; @0D62F 0000:D62F original=32c0
    xor al, al
; @0D631 0000:D631 original=a2febe
    mov byte ptr ds:[0BEFEh], al
; @0D634 0000:D634 original=a2b3bf
    mov byte ptr ds:[0BFB3h], al
; @0D637 0000:D637 original=a2c3bf
    mov byte ptr ds:[0BFC3h], al
; @0D63A 0000:D63A original=e461
    in al, 061h
; @0D63C 0000:D63C original=24fc
    and al, 0FCh
; @0D63E 0000:D63E original=e661
    out 061h, al
; @0D640 0000:D640 original=c3
    ret
; @0D641 0000:D641 original=c6450bff runtime CFG evidence
    mov byte ptr ds:[di + 0Bh], 0FFh
; @0D645 0000:D645 original=e973ff runtime CFG evidence
    JMP_NEAR loc_0D5BB
; @0D648 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,045h,0Bh,01h,0E9h,06Ch,0FFh
; @0D64F 0000:D64F original=8b07 runtime CFG evidence
    mov ax, word ptr ds:[bx]
; @0D651 0000:D651 original=43 runtime CFG evidence
    inc bx
; @0D652 0000:D652 original=43 runtime CFG evidence
    inc bx
; @0D653 0000:D653 original=89450c runtime CFG evidence
    mov word ptr ds:[di + 0Ch], ax
; @0D656 0000:D656 original=8a07 runtime CFG evidence
    mov al, byte ptr ds:[bx]
; @0D658 0000:D658 original=43 runtime CFG evidence
    inc bx
; @0D659 0000:D659 original=88450e runtime CFG evidence
    mov byte ptr ds:[di + 0Eh], al
; @0D65C 0000:D65C original=e95cff runtime CFG evidence
    JMP_NEAR loc_0D5BB
; @0D65F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0B8h,03h,00h,0CDh,010h,0B9h,00h
; @0D66F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0B4h,01h,0CDh,010h,02Eh,0C7h,06h,060h,0D6h,00h,0B8h,0E8h,0FCh,01h,074h
; @0D67F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,02Eh,0C7h,06h,060h,0D6h,00h,0B0h,0BAh,0FEh,0C2h,089h,016h,0AAh,021h,032h
; @0D68F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,0B4h,03Dh,09Ah,0D7h,04h,03Ah,015h,073h,0Bh,0B4h,019h,0CDh,021h,03Ch,02h
; @0D69F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,0E6h,0E9h,067h,086h,02Eh,0A3h,066h,0D6h,02Eh,0A1h,098h,095h,02Eh,0A3h,0F0h
; @0D6AF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ECh,02Eh,0C7h,06h,0EEh,0ECh,00h,00h,0E8h,0Fh,016h,073h,03h,0E9h,08Ch,01h
; @0D6BF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,0C7h,06h,062h,0D6h,00h,00h,02Eh,0C7h,06h,064h,0D6h,01h,00h,02Eh,08Eh
; @0D6CF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,098h,095h,033h,0F6h,026h,0ACh,03Ch,01Ah,074h,0Bh,03Ch,0Dh,075h,0F6h,02Eh
; @0D6DF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,06h,064h,0D6h,0EBh,0EFh,0E8h,0ABh,00h,080h,03Eh,0C5h,098h,01h,075h,03h
; @0D6EF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,059h,01h,080h,03Eh,0Bh,099h,01h,074h,025h,080h,03Eh,013h,099h,01h,074h
; @0D6FF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 029h,080h,03Eh,0Ch,099h,01h,074h,04Fh,080h,03Eh,014h,099h,01h,074h,060h,080h
; @0D70F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0Dh,099h,01h,074h,01Fh,080h,03Eh,015h,099h,01h,074h,029h,0EBh,0CAh,0BDh
; @0D71F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0E8h,039h,00h,04Dh,075h,0FAh,0EBh,0BCh,0BDh,0FFh,0FFh,0E8h,04Ch,00h
; @0D72F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,075h,0FAh,0EBh,0B1h,0E8h,01Ch,01h,0E8h,019h,01h,0BDh,017h,00h,0E8h,01Dh
; @0D73F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,04Dh,075h,0FAh,0EBh,0A0h,0E8h,0Bh,01h,0E8h,08h,01h,0BDh,017h,00h,0E8h
; @0D74F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ah,00h,04Dh,075h,0FAh,0EBh,08Fh,0E8h,04h,00h,0E3h,08Dh,0EBh,088h,033h,0C9h
; @0D75F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,083h,03Eh,062h,0D6h,00h,074h,06h,02Eh,0FFh,0Eh,062h,0D6h,041h,0C3h,0E8h
; @0D76F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ah,00h,0E3h,02h,0EBh,03h,0E9h,070h,0FFh,0E9h,06Ah,0FFh,033h,0C9h,02Eh,0A1h
; @0D77F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 062h,0D6h,040h,05h,018h,00h,02Eh,03Bh,06h,064h,0D6h,073h,06h,02Eh,0FFh,06h
; @0D78F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 062h,0D6h,041h,0C3h,02Eh,08Eh,06h,098h,095h,033h,0FFh,02Eh,08Bh,016h,062h,0D6h
; @0D79F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Bh,0D2h,074h,011h,0B9h,0FFh,0FFh,0B0h,0Dh,0F2h,0AEh,026h,080h,03Dh,0Ah,075h
; @0D7AF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,047h,04Ah,075h,0EFh,08Bh,0F7h,02Eh,08Eh,01Eh,098h,095h,02Eh,08Eh,06h,060h
; @0D7BF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D6h,033h,0FFh,01Eh,056h,02Eh,08Eh,01Eh,096h,095h,0BEh,0Ah,0C3h,0B9h,050h,00h
; @0D7CF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F3h,0A5h,05Eh,01Fh,0BDh,018h,00h,033h,0D2h,0Bh,0EDh,074h,062h,0ACh,03Ch,01Ah
; @0D7DF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,05Dh,03Ch,09h,074h,012h,03Ch,0Dh,074h,031h,0B4h,01Bh,0ABh,042h,083h,0FAh
; @0D7EF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,075h,0E6h,033h,0D2h,04Dh,0EBh,0E1h,0B0h,020h,0B4h,01Bh,0F7h,0C2h,07h,00h
; @0D7FF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,0Ah,0ABh,042h,0F7h,0C2h,07h,00h,075h,0F8h,0EBh,0Dh,083h,0FAh,050h,074h
; @0D80F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,083h,0C2h,08h,0B9h,08h,00h,0F3h,0ABh,0EBh,0BEh,080h,03Ch,0Ah,075h,01h
; @0D81F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,083h,0FAh,050h,074h,010h,0B0h,020h,0B4h,01Bh,0ABh,042h,083h,0FAh,050h,075h
; @0D82F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F9h,033h,0D2h,04Dh,0EBh,0A3h,081h,0C7h,0A0h,00h,033h,0D2h,04Dh,0EBh,09Ah,02Eh
; @0D83F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,096h,095h,052h,055h,0E8h,0Bh,00h,05Dh,05Ah,0C3h,080h,03Eh,0C5h,098h
; @0D84F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,074h,0F9h,0C3h,0B9h,04h,00h,0E8h,03h,00h,0E2h,0FBh,0C3h,0BAh,0DAh,03h
; @0D85F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B4h,08h,02Eh,081h,03Eh,060h,0D6h,00h,0B8h,074h,05h,0BAh,0BAh,03h,0B4h,080h
; @0D86F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ECh,022h,0C4h,074h,0FBh,0ECh,022h,0C4h,075h,0FBh,0C3h,0BAh,0B4h,03h,0E8h,01Bh
; @0D87F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,018h,0BAh,0BAh,03h,0ECh,024h,080h,08Ah,0E0h,0B9h,00h,080h,0ECh,024h
; @0D88F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Ah,0E0h,0E1h,0F9h,0B0h,01h,075h,02h,0B0h,00h,0C3h,0B0h,0Fh,0EEh,042h
; @0D89F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ECh,08Ah,0E0h,0B0h,066h,0EEh,0B9h,00h,01h,0E2h,0FEh,0ECh,086h,0E0h,0EEh,080h
; @0D8AF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FCh,066h,074h,02h,033h,0C0h,023h,0C0h,0C3h,00h,00h,00h,00h,00h,00h,00h
; @0D8BF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D8CF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D8DF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D8EF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D8FF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D90F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D91F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D92F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D93F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D94F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D95F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D96F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D97F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D98F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D99F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D9AF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D9BF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D9CF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D9DF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D9EF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0D9FF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA0F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA1F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA2F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA3F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA4F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA5F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA6F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA7F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA8F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DA9F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DAAF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DABF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DACF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DADF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DAEF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DAFF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB0F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB1F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB2F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB3F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB4F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB5F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB6F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB7F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB8F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DB9F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DBAF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DBBF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DBCF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DBDF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DBEF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DBFF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC0F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC1F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC2F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC3F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC4F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC5F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC6F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC7F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC8F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DC9F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DCAF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DCBF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DCCF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DCDF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DCEF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DCFF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD0F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD1F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD2F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD3F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD4F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD5F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD6F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD7F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD8F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DD9F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DDAF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DDBF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DDCF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DDDF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DDEF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DDFF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE0F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE1F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE2F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE3F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE4F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE5F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE6F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE7F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE8F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DE9F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DEAF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DEBF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DECF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DEDF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DEEF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DEFF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF0F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF1F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF2F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF3F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF4F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF5F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF6F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF7F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF8F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DF9F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DFAF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DFBF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DFCF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DFDF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DFEF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0DFFF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
part06 ends
end
