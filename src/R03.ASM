; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part03 segment byte public 'CODE'
assume cs:part03,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; Modern record/state symbols; evidence in metadata/record-movement.json.
POOL_A_COUNT equ 023h
POOL_A_CURSOR equ 095D8h
POOL_A_END equ 02B5Ch
POOL_A_START equ 023B4h
POOL_B_COUNT equ 022h
POOL_B_CURSOR equ 095DAh
POOL_B_END equ 032CCh
POOL_B_START equ 02B5Ch
REC_STATUS equ 00h
REC_STRIDE equ 038h
REC_X equ 04h
REC_Y equ 02h
loc_07CA9 equ 01CADh
loc_07CB0 equ 01CB4h
loc_07CB7 equ 01CBBh
loc_07CBC equ 01CC0h
loc_07CC1 equ 01CC5h
loc_062FF equ 0303h
loc_06308 equ 030Ch
loc_06311 equ 0315h
loc_0631A equ 031Eh
loc_06323 equ 0327h
loc_0632C equ 0330h
loc_06361 equ 0365h
loc_06380 equ 0384h
loc_0638D equ 0391h
loc_06397 equ 039Bh
loc_063B3 equ 03B7h
loc_063BD equ 03C1h
loc_063E0 equ 03E4h
loc_063FF equ 0403h
loc_0640C equ 0410h
loc_06416 equ 041Ah
loc_06432 equ 0436h
loc_0643C equ 0440h
loc_0645F equ 0463h
loc_0647E equ 0482h
loc_0648B equ 048Fh
loc_06495 equ 0499h
loc_064B1 equ 04B5h
loc_064BB equ 04BFh
loc_064DE equ 04E2h
loc_064FD equ 0501h
loc_0650A equ 050Eh
loc_06514 equ 0518h
loc_06530 equ 0534h
loc_0653A equ 053Eh
loc_0655D equ 0561h
loc_0657C equ 0580h
loc_06589 equ 058Dh
loc_06593 equ 0597h
loc_065AF equ 05B3h
loc_065B9 equ 05BDh
loc_065DC equ 05E0h
loc_065FB equ 05FFh
loc_06608 equ 060Ch
loc_06612 equ 0616h
loc_0662E equ 0632h
loc_06638 equ 063Ch
loc_0665B equ 065Fh
loc_0667A equ 067Eh
loc_06687 equ 068Bh
loc_06691 equ 0695h
loc_066AD equ 06B1h
loc_066B7 equ 06BBh
loc_066DA equ 06DEh
loc_066F9 equ 06FDh
loc_06706 equ 070Ah
loc_06710 equ 0714h
loc_0672C equ 0730h
loc_06736 equ 073Ah
loc_06759 equ 075Dh
loc_06778 equ 077Ch
loc_06785 equ 0789h
loc_0678F equ 0793h
loc_067AB equ 07AFh
loc_067B5 equ 07B9h
loc_067D8 equ 07DCh
loc_067F7 equ 07FBh
loc_06804 equ 0808h
loc_0680E equ 0812h
loc_0682A equ 082Eh
loc_06834 equ 0838h
loc_06857 equ 085Bh
loc_06876 equ 087Ah
loc_06883 equ 0887h
loc_0688D equ 0891h
loc_068A9 equ 08ADh
loc_068B3 equ 08B7h
loc_068D6 equ 08DAh
loc_068F5 equ 08F9h
loc_06902 equ 0906h
loc_0690C equ 0910h
loc_06928 equ 092Ch
loc_06932 equ 0936h
loc_06955 equ 0959h
loc_06974 equ 0978h
loc_06981 equ 0985h
loc_0698B equ 098Fh
loc_069A7 equ 09ABh
loc_069B1 equ 09B5h
loc_069D4 equ 09D8h
loc_069F3 equ 09F7h
loc_06A00 equ 0A04h
loc_06A0A equ 0A0Eh
loc_06A26 equ 0A2Ah
loc_06A30 equ 0A34h
loc_06A53 equ 0A57h
loc_06A72 equ 0A76h
loc_06A7F equ 0A83h
loc_06A89 equ 0A8Dh
loc_06AA5 equ 0AA9h
loc_06AAF equ 0AB3h
loc_06AD2 equ 0AD6h
loc_06AF1 equ 0AF5h
loc_06AFE equ 0B02h
loc_06B08 equ 0B0Ch
loc_06B24 equ 0B28h
loc_06B2E equ 0B32h
loc_06B51 equ 0B55h
loc_06B70 equ 0B74h
loc_06B7D equ 0B81h
loc_06B87 equ 0B8Bh
loc_06BA3 equ 0BA7h
loc_06BAD equ 0BB1h
loc_06BD0 equ 0BD4h
loc_06BEF equ 0BF3h
loc_06BFC equ 0C00h
loc_06C06 equ 0C0Ah
loc_06C22 equ 0C26h
loc_06C2C equ 0C30h
loc_06C4F equ 0C53h
loc_06C6E equ 0C72h
loc_06C7B equ 0C7Fh
loc_06C85 equ 0C89h
loc_06CA1 equ 0CA5h
loc_06CAB equ 0CAFh
loc_06CCE equ 0CD2h
loc_06CED equ 0CF1h
loc_06CFA equ 0CFEh
loc_06D04 equ 0D08h
loc_06D20 equ 0D24h
loc_06D2A equ 0D2Eh
loc_06D4D equ 0D51h
loc_06D6C equ 0D70h
loc_06D79 equ 0D7Dh
loc_06D83 equ 0D87h
loc_06D9F equ 0DA3h
loc_06DA9 equ 0DADh
loc_06DCC equ 0DD0h
loc_06DEB equ 0DEFh
loc_06DF8 equ 0DFCh
loc_06E02 equ 0E06h
loc_06E1E equ 0E22h
loc_06E28 equ 0E2Ch
loc_06E4B equ 0E4Fh
loc_06E6A equ 0E6Eh
loc_06E77 equ 0E7Bh
loc_06E81 equ 0E85h
loc_06E9D equ 0EA1h
loc_06EA7 equ 0EABh
loc_06ECA equ 0ECEh
loc_06EE9 equ 0EEDh
loc_06EF6 equ 0EFAh
loc_06F00 equ 0F04h
loc_06F1C equ 0F20h
loc_06F26 equ 0F2Ah
loc_06F49 equ 0F4Dh
loc_06F68 equ 0F6Ch
loc_06F75 equ 0F79h
loc_06F7F equ 0F83h
loc_06F9B equ 0F9Fh
loc_06FA5 equ 0FA9h
loc_06FC8 equ 0FCCh
loc_06FE7 equ 0FEBh
loc_06FF4 equ 0FF8h
loc_06FFE equ 01002h
loc_0701A equ 0101Eh
loc_07024 equ 01028h
loc_07047 equ 0104Bh
loc_07066 equ 0106Ah
loc_07073 equ 01077h
loc_0707D equ 01081h
loc_07099 equ 0109Dh
loc_070A3 equ 010A7h
loc_070C6 equ 010CAh
loc_070E5 equ 010E9h
loc_070F2 equ 010F6h
loc_070FC equ 01100h
loc_07118 equ 0111Ch
loc_07122 equ 01126h
loc_07145 equ 01149h
loc_07164 equ 01168h
loc_07171 equ 01175h
loc_0717B equ 0117Fh
loc_07197 equ 0119Bh
loc_071A1 equ 011A5h
loc_071C4 equ 011C8h
loc_071E3 equ 011E7h
loc_071F0 equ 011F4h
loc_071FA equ 011FEh
loc_07216 equ 0121Ah
loc_07220 equ 01224h
loc_07243 equ 01247h
loc_07262 equ 01266h
loc_0726F equ 01273h
loc_07279 equ 0127Dh
loc_07295 equ 01299h
loc_0729F equ 012A3h
loc_072C2 equ 012C6h
loc_072E1 equ 012E5h
loc_072EE equ 012F2h
loc_072F8 equ 012FCh
loc_07314 equ 01318h
loc_0731E equ 01322h
loc_07341 equ 01345h
loc_07360 equ 01364h
loc_0736D equ 01371h
loc_07377 equ 0137Bh
loc_07393 equ 01397h
loc_0739D equ 013A1h
loc_073C0 equ 013C4h
loc_073DF equ 013E3h
loc_073EC equ 013F0h
loc_073F6 equ 013FAh
loc_07412 equ 01416h
loc_0741C equ 01420h
loc_0741F equ 01423h
loc_0747F equ 01483h
loc_0748B equ 0148Fh
loc_0749E equ 014A2h
loc_074B5 equ 014B9h
loc_074E2 equ 014E6h
loc_07507 equ 0150Bh
loc_0750D equ 01511h
loc_07519 equ 0151Dh
loc_07521 equ 01525h
loc_075BB equ 015BFh
loc_075DB equ 015DFh
loc_075E4 equ 015E8h
loc_075F5 equ 015F9h
loc_07615 equ 01619h
loc_07697 equ 0169Bh
loc_076B3 equ 016B7h
loc_076D7 equ 016DBh
loc_0797E equ 01982h
loc_07985 equ 01989h
loc_0798C equ 01990h
loc_07993 equ 01997h
loc_0799A equ 0199Eh
loc_079A1 equ 019A5h
loc_07A11 equ 01A15h
loc_07A2D equ 01A31h
loc_07A40 equ 01A44h
loc_07A6E equ 01A72h
loc_07A74 equ 01A78h
loc_07A7A equ 01A7Eh
loc_07A80 equ 01A84h
loc_07AAE equ 01AB2h
loc_07AB4 equ 01AB8h
loc_07AC4 equ 01AC8h
loc_07ACA equ 01ACEh
loc_07ADA equ 01ADEh
loc_07AE0 equ 01AE4h
loc_07AF0 equ 01AF4h
loc_07AF6 equ 01AFAh
loc_081C9 equ 021CDh
loc_081CC equ 021D0h
loc_0BEC5 equ 05EC9h
loc_0511F equ 0F123h
loc_0518C equ 0F190h
loc_0519A equ 0F19Eh
loc_05A00 equ 0FA04h
loc_05A6C equ 0FA70h
loc_05EDB equ 0FEDFh
loc_05F61 equ 0FF65h
loc_06009 equ 0Dh
loc_0601A equ 01Eh
loc_0606F equ 073h
loc_0607D equ 081h
loc_06082 equ 086h
loc_06087 equ 08Bh
loc_0608F equ 093h
loc_06097 equ 09Bh
loc_0609F equ 0A3h
loc_060CB equ 0CFh
loc_060CE equ 0D2h
loc_060E3 equ 0E7h
loc_060F3 equ 0F7h
loc_06120 equ 0124h
loc_06138 equ 013Ch
loc_0613E equ 0142h
loc_0618A equ 018Eh
loc_0619E equ 01A2h
loc_061B2 equ 01B6h
loc_061C6 equ 01CAh
loc_061C7 equ 01CBh
loc_061CA equ 01CEh
loc_061D2 equ 01D6h
loc_061DC equ 01E0h
loc_061F7 equ 01FBh
loc_061FC equ 0200h
loc_0625B equ 025Fh
loc_06294 equ 0298h
loc_06296 equ 029Ah
loc_062B6 equ 02BAh
loc_062BA equ 02BEh
loc_062CC equ 02D0h
loc_062D1 equ 02D5h
loc_062D9 equ 02DDh
loc_062E0 equ 02E4h
loc_062E7 equ 02EBh
loc_062EE equ 02F2h
loc_07429 equ 0142Dh
loc_07442 equ 01446h
FindFreeRecordPoolA_07524 equ 01528h
loc_0752B equ 0152Fh
loc_0753C equ 01540h
loc_07542 equ 01546h
loc_07550 equ 01554h
loc_07556 equ 0155Ah
loc_07568 equ 0156Ch
loc_07570 equ 01574h
FindFreeRecordPoolB_07573 equ 01577h
loc_0757A equ 0157Eh
loc_07583 equ 01587h
loc_07591 equ 01595h
loc_0774F equ 01753h
loc_077B2 equ 017B6h
loc_077BE equ 017C2h
loc_077C5 equ 017C9h
loc_077CD equ 017D1h
loc_077F4 equ 017F8h
loc_077F6 equ 017FAh
loc_0780B equ 0180Fh
loc_0780E equ 01812h
loc_07839 equ 0183Dh
loc_07847 equ 0184Bh
loc_0784D equ 01851h
loc_07875 equ 01879h
loc_07884 equ 01888h
loc_07890 equ 01894h
loc_07892 equ 01896h
loc_07897 equ 0189Bh
loc_0789A equ 0189Eh
loc_078A6 equ 018AAh
loc_078D1 equ 018D5h
loc_078DF equ 018E3h
loc_078E5 equ 018E9h
loc_078FB equ 018FFh
loc_0790A equ 0190Eh
loc_07916 equ 0191Ah
loc_07918 equ 0191Ch
loc_0791B equ 0191Fh
loc_0792D equ 01931h
loc_07947 equ 0194Bh
loc_0795D equ 01961h
loc_09EE4 equ 03EE8h
loc_0A781 equ 04785h
loc_0BD0D equ 05D11h
loc_0BFC7 equ 05FCBh
; @05FFC 0000:5FFC original=833e3a2305
    cmp word ptr ds:[0233Ah], 5
; @06001 0000:6001 original=7206
    JB_SHORT loc_06009
; @06003 0000:6003 original=c7063a230000
    mov word ptr ds:[0233Ah], 0
; @06009 0000:6009 original=ff063e23
    inc word ptr ds:[0233Eh]
; @0600D 0000:600D original=833e3e2303
    cmp word ptr ds:[0233Eh], 3
; @06012 0000:6012 original=7206
    JB_SHORT loc_0601A
; @06014 0000:6014 original=c7063e230000
    mov word ptr ds:[0233Eh], 0
; @0601A 0000:601A original=ff063c23
    inc word ptr ds:[0233Ch]
; @0601E 0000:601E original=83263c2303
    and word ptr ds:[0233Ch], 3
; @06023 0000:6023 original=ff063623
    inc word ptr ds:[02336h]
; @06027 0000:6027 original=8326362307
    and word ptr ds:[02336h], 7
; @0602C 0000:602C original=ff06a0a7
    inc word ptr ds:[0A7A0h]
; @06030 0000:6030 original=8336242301
    xor word ptr ds:[02324h], 1
; @06035 0000:6035 original=ff062623
    inc word ptr ds:[02326h]
; @06039 0000:6039 original=8326262303
    and word ptr ds:[02326h], 3
; @0603E 0000:603E original=ff062823
    inc word ptr ds:[02328h]
; @06042 0000:6042 original=8326282307
    and word ptr ds:[02328h], 7
; @06047 0000:6047 original=ff062a23
    inc word ptr ds:[0232Ah]
; @0604B 0000:604B original=83262a230f
    and word ptr ds:[0232Ah], 0Fh
; @06050 0000:6050 original=ff062c23
    inc word ptr ds:[0232Ch]
; @06054 0000:6054 original=83262c231f
    and word ptr ds:[0232Ch], 01Fh
; @06059 0000:6059 original=ff062e23
    inc word ptr ds:[0232Eh]
; @0605D 0000:605D original=83262e233f
    and word ptr ds:[0232Eh], 03Fh
; @06062 0000:6062 original=ff063023
    inc word ptr ds:[02330h]
; @06066 0000:6066 original=832630237f
    and word ptr ds:[02330h], 07Fh
; @0606B 0000:606B original=e80100
    CALL_NEAR loc_0606F
; @0606E 0000:606E original=c3
    ret
; sub_0000_606F
; @0606F 0000:606F original=833edcbe01
    cmp word ptr ds:[0BEDCh], 1
; @06074 0000:6074 original=7607
    JBE_SHORT loc_0607D
; @06076 0000:6076 original=833e2e233f
    cmp word ptr ds:[0232Eh], 03Fh
; @0607B 0000:607B original=eb05
    JMP_SHORT loc_06082
; @0607D 0000:607D original=833e30237f
    cmp word ptr ds:[02330h], 07Fh
; @06082 0000:6082 original=7503
    JNE_SHORT loc_06087
; @06084 0000:6084 original=e85d3e
    CALL_NEAR loc_09EE4
; @06087 0000:6087 original=833e842302
    cmp word ptr ds:[02384h], 2
; @0608C 0000:608C original=7401
    JE_SHORT loc_0608F
; @0608E 0000:608E original=c3
    ret
; @0608F 0000:608F original=833e2c231f
    cmp word ptr ds:[0232Ch], 01Fh
; @06094 0000:6094 original=7401
    JE_SHORT loc_06097
; @06096 0000:6096 original=c3
    ret
; @06097 0000:6097 original=83364a2301
    xor word ptr ds:[0234Ah], 1
; @0609C 0000:609C original=7401
    JE_SHORT loc_0609F
; @0609E 0000:609E original=c3
    ret
; @0609F 0000:609F original=e9423e
    JMP_NEAR loc_09EE4
; sub_0000_60A2
; @060A2 0000:60A2 original=e82017
    CALL_NEAR loc_077C5
; @060A5 0000:60A5 original=e8b9fe
    CALL_NEAR loc_05F61
; @060A8 0000:60A8 original=e830fe
    CALL_NEAR loc_05EDB
; @060AB 0000:60AB original=c3
    ret
; sub_0000_60AC
; @060AC 0000:60AC original=2ea1a295
    mov ax, word ptr cs:[095A2h]
; @060B0 0000:60B0 original=a34c23
    mov word ptr ds:[0234Ch], ax
; @060B3 0000:60B3 original=c7064e230000
    mov word ptr ds:[0234Eh], 0
; @060B9 0000:60B9 original=c70652230000
    mov word ptr ds:[02352h], 0
; @060BF 0000:60BF original=c70678a90000
    mov word ptr ds:[0A978h], 0
; @060C5 0000:60C5 original=c7065023a00e
    mov word ptr ds:[02350h], 0EA0h
; @060CB 0000:60CB original=b91000
    mov cx, 010h
; @060CE 0000:60CE original=51
    push cx
; @060CF 0000:60CF original=e8af46
    CALL_NEAR loc_0A781
; @060D2 0000:60D2 original=59
    pop cx
; @060D3 0000:60D3 original=e2f9
    LOOP_SHORT loc_060CE
; @060D5 0000:60D5 original=813e50239c00
    cmp word ptr ds:[02350h], 09Ch
; @060DB 0000:60DB original=75ee
    JNE_SHORT loc_060CB
; @060DD 0000:60DD original=832e78a903
    sub word ptr ds:[0A978h], 3
; @060E2 0000:60E2 original=c3
    ret
; sub_0000_60E3
; @060E3 0000:60E3 original=bd5c23
    mov bp, 0235Ch
; @060E6 0000:60E6 original=e8a3f0
    CALL_NEAR loc_0518C
; @060E9 0000:60E9 original=bb6223
    mov bx, 02362h
; @060EC 0000:60EC original=a15623
    mov ax, word ptr ds:[02356h]
; @060EF 0000:60EF original=d7
    xlat
; @060F0 0000:60F0 original=e9a7f0
    JMP_NEAR loc_0519A
; sub_0000_60F3
; @060F3 0000:60F3 original=b01f
    mov al, 01Fh
; @060F5 0000:60F5 original=b450
    mov ah, 050h
; @060F7 0000:60F7 original=e806f9
    CALL_NEAR loc_05A00
; @060FA 0000:60FA original=be1e00
    mov si, 01Eh
; @060FD 0000:60FD original=d1e6
    shl si, 1
; @060FF 0000:60FF original=81c6e40b
    add si, 0BE4h
; @06103 0000:6103 original=2e8b34
    mov si, word ptr cs:[si]
; @06106 0000:6106 original=8b0e5823
    mov cx, word ptr ds:[02358h]
; @0610A 0000:610A original=e81300
    CALL_NEAR loc_06120
; @0610D 0000:610D original=be1f00
    mov si, 01Fh
; @06110 0000:6110 original=d1e6
    shl si, 1
; @06112 0000:6112 original=81c6e40b
    add si, 0BE4h
; @06116 0000:6116 original=2e8b34
    mov si, word ptr cs:[si]
; @06119 0000:6119 original=b90300
    mov cx, 3
; @0611C 0000:611C original=2b0e5823
    sub cx, word ptr ds:[02358h]
; sub_0000_6120
; @06120 0000:6120 original=e316
    JCXZ_SHORT loc_06138
; @06122 0000:6122 original=56
    push si
; @06123 0000:6123 original=57
    push di
; @06124 0000:6124 original=51
    push cx
; @06125 0000:6125 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @0612A 0000:612A original=e83ff9
    CALL_NEAR loc_05A6C
; @0612D 0000:612D original=59
    pop cx
; @0612E 0000:612E original=5f
    pop di
; @0612F 0000:612F original=5e
    pop si
; @06130 0000:6130 original=e80b00
    CALL_NEAR loc_0613E
; @06133 0000:6133 original=e80800
    CALL_NEAR loc_0613E
; @06136 0000:6136 original=e2e8
    LOOP_SHORT loc_06120
; @06138 0000:6138 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0613D 0000:613D original=c3
    ret
; sub_0000_613E
; @0613E 0000:613E original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @06143 0000:6143 original=d1e3
    shl bx, 1
; @06145 0000:6145 original=2effa74a61
    jmp word ptr cs:[bx + 0614Ah]
; @0614A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,061h,054h,061h,056h,061h
; sub_0000_6150
; @06150 0000:6150 original=83c702
    add di, 2
; @06153 0000:6153 original=c3
    ret
; sub_0000_6154
; @06154 0000:6154 original=47
    inc di
; @06155 0000:6155 original=c3
    ret
; sub_0000_6156
; @06156 0000:6156 original=83c704
    add di, 4
; @06159 0000:6159 original=c3
    ret
; sub_0000_615A
; @0615A 0000:615A original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @0615F 0000:615F original=d1e3
    shl bx, 1
; @06161 0000:6161 original=2effa76661
    jmp word ptr cs:[bx + 06166h]
; @06166 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Ch,061h,070h,061h,072h,061h
; sub_0000_616C
; @0616C 0000:616C original=83ef02
    sub di, 2
; @0616F 0000:616F original=c3
    ret
; sub_0000_6170
; @06170 0000:6170 original=4f
    dec di
; @06171 0000:6171 original=c3
    ret
; sub_0000_6172
; @06172 0000:6172 original=83ef04
    sub di, 4
; @06175 0000:6175 original=c3
    ret
; sub_0000_6176
; @06176 0000:6176 original=e862fd
    CALL_NEAR loc_05EDB
; @06179 0000:6179 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @0617F 0000:617F original=7509
    JNE_SHORT loc_0618A
; @06181 0000:6181 original=e89bef
    CALL_NEAR loc_0511F
; @06184 0000:6184 original=e854fd
    CALL_NEAR loc_05EDB
; @06187 0000:6187 original=e895ef
    CALL_NEAR loc_0511F
; @0618A 0000:618A original=e866ff
    CALL_NEAR loc_060F3
; @0618D 0000:618D original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @06193 0000:6193 original=7509
    JNE_SHORT loc_0619E
; @06195 0000:6195 original=e887ef
    CALL_NEAR loc_0511F
; @06198 0000:6198 original=e858ff
    CALL_NEAR loc_060F3
; @0619B 0000:619B original=e881ef
    CALL_NEAR loc_0511F
; @0619E 0000:619E original=e83b00
    CALL_NEAR loc_061DC
; @061A1 0000:61A1 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @061A7 0000:61A7 original=7509
    JNE_SHORT loc_061B2
; @061A9 0000:61A9 original=e873ef
    CALL_NEAR loc_0511F
; @061AC 0000:61AC original=e82d00
    CALL_NEAR loc_061DC
; @061AF 0000:61AF original=e86def
    CALL_NEAR loc_0511F
; @061B2 0000:61B2 original=e82eff
    CALL_NEAR loc_060E3
; @061B5 0000:61B5 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @061BB 0000:61BB original=7509
    JNE_SHORT loc_061C6
; @061BD 0000:61BD original=e85fef
    CALL_NEAR loc_0511F
; @061C0 0000:61C0 original=e820ff
    CALL_NEAR loc_060E3
; @061C3 0000:61C3 original=e859ef
    CALL_NEAR loc_0511F
; @061C6 0000:61C6 original=c3
    ret
; sub_0000_61C7
; @061C7 0000:61C7 original=bf6823
    mov di, 02368h
; @061CA 0000:61CA original=833d00
    cmp word ptr ds:[di], 0
; @061CD 0000:61CD original=7403
    JE_SHORT loc_061D2
; @061CF 0000:61CF original=ff0d
    dec word ptr ds:[di]
; @061D1 0000:61D1 original=c3
    ret
; @061D2 0000:61D2 original=83c702
    add di, 2
; @061D5 0000:61D5 original=81ff7423
    cmp di, 02374h
; @061D9 0000:61D9 original=75ef
    JNE_SHORT loc_061CA
; @061DB 0000:61DB original=c3
    ret
; sub_0000_61DC
; @061DC 0000:61DC original=55
    push bp
; @061DD 0000:61DD original=2e8e069695
    mov es, word ptr cs:[09596h]
; @061E2 0000:61E2 original=bf6823
    mov di, 02368h
; @061E5 0000:61E5 original=b90600
    mov cx, 6
; @061E8 0000:61E8 original=b80400
    mov ax, 4
; @061EB 0000:61EB original=f3ab
    rep stosw
; @061ED 0000:61ED original=8b0e5ca9
    mov cx, word ptr ds:[0A95Ch]
; @061F1 0000:61F1 original=e309
    JCXZ_SHORT loc_061FC
; @061F3 0000:61F3 original=0bc9
    or cx, cx
; @061F5 0000:61F5 original=7805
    JS_SHORT loc_061FC
; @061F7 0000:61F7 original=e8cdff
    CALL_NEAR loc_061C7
; @061FA 0000:61FA original=e2fb
    LOOP_SHORT loc_061F7
; @061FC 0000:61FC original=b440
    mov ah, 040h
; @061FE 0000:61FE original=b01f
    mov al, 01Fh
; @06200 0000:6200 original=e8fdf7
    CALL_NEAR loc_05A00
; @06203 0000:6203 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @06208 0000:6208 original=368b366823
    mov si, word ptr ss:[02368h]
; @0620D 0000:620D original=e88600
    CALL_NEAR loc_06296
; @06210 0000:6210 original=368b366a23
    mov si, word ptr ss:[0236Ah]
; @06215 0000:6215 original=e87e00
    CALL_NEAR loc_06296
; @06218 0000:6218 original=368b366c23
    mov si, word ptr ss:[0236Ch]
; @0621D 0000:621D original=e87600
    CALL_NEAR loc_06296
; @06220 0000:6220 original=368b366e23
    mov si, word ptr ss:[0236Eh]
; @06225 0000:6225 original=e86e00
    CALL_NEAR loc_06296
; @06228 0000:6228 original=368b367023
    mov si, word ptr ss:[02370h]
; @0622D 0000:622D original=e86600
    CALL_NEAR loc_06296
; @06230 0000:6230 original=368b367223
    mov si, word ptr ss:[02372h]
; @06235 0000:6235 original=e85e00
    CALL_NEAR loc_06296
; @06238 0000:6238 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0623D 0000:623D original=a15aa9
    mov ax, word ptr ds:[0A95Ah]
; @06240 0000:6240 original=3b067423
    cmp ax, word ptr ds:[02374h]
; @06244 0000:6244 original=744e
    JE_SHORT loc_06294
; @06246 0000:6246 original=b01f
    mov al, 01Fh
; @06248 0000:6248 original=b40c
    mov ah, 0Ch
; @0624A 0000:624A original=e8b3f7
    CALL_NEAR loc_05A00
; @0624D 0000:624D original=be0000
    mov si, 0
; @06250 0000:6250 original=833e5aa9ff
    cmp word ptr ds:[0A95Ah], -1
; @06255 0000:6255 original=7404
    JE_SHORT loc_0625B
; @06257 0000:6257 original=8b365aa9
    mov si, word ptr ds:[0A95Ah]
; @0625B 0000:625B original=83c620
    add si, 020h
; @0625E 0000:625E original=d1e6
    shl si, 1
; @06260 0000:6260 original=81c6e40b
    add si, 0BE4h
; @06264 0000:6264 original=2e8b34
    mov si, word ptr cs:[si]
; @06267 0000:6267 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @0626C 0000:626C original=e8fdf7
    CALL_NEAR loc_05A6C
; @0626F 0000:626F original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @06274 0000:6274 original=b021
    mov al, 021h
; @06276 0000:6276 original=b418
    mov ah, 018h
; @06278 0000:6278 original=e885f7
    CALL_NEAR loc_05A00
; @0627B 0000:627B original=be1e00
    mov si, 01Eh
; @0627E 0000:627E original=d1e6
    shl si, 1
; @06280 0000:6280 original=81c6e40b
    add si, 0BE4h
; @06284 0000:6284 original=2e8b34
    mov si, word ptr cs:[si]
; @06287 0000:6287 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @0628C 0000:628C original=e8ddf7
    CALL_NEAR loc_05A6C
; @0628F 0000:628F original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @06294 0000:6294 original=5d
    pop bp
; @06295 0000:6295 original=c3
    ret
; sub_0000_6296
; @06296 0000:6296 original=83c619
    add si, 019h
; @06299 0000:6299 original=d1e6
    shl si, 1
; @0629B 0000:629B original=81c6e40b
    add si, 0BE4h
; @0629F 0000:629F original=2e8b34
    mov si, word ptr cs:[si]
; @062A2 0000:62A2 original=57
    push di
; @062A3 0000:62A3 original=e8c6f7
    CALL_NEAR loc_05A6C
; @062A6 0000:62A6 original=5f
    pop di
; @062A7 0000:62A7 original=e994fe
    JMP_NEAR loc_0613E
; sub_0000_62AA
; @062AA 0000:62AA original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @062AF 0000:62AF original=7405
    JE_SHORT loc_062B6
; @062B1 0000:62B1 original=c606ffbe08
    mov byte ptr ds:[0BEFFh], 8
; @062B6 0000:62B6 original=55
    push bp
; @062B7 0000:62B7 original=b92300
    mov cx, 023h
; @062BA 0000:62BA original=51
    push cx
; @062BB 0000:62BB original=8bd9
    mov bx, cx
; @062BD 0000:62BD original=d1e3
    shl bx, 1
; @062BF 0000:62BF original=8bafca32
    mov bp, word ptr ds:[bx + 032CAh]
; @062C3 0000:62C3 original=837e0000
    cmp word ptr ss:[bp], 0
; @062C7 0000:62C7 original=7403
    JE_SHORT loc_062CC
; @062C9 0000:62C9 original=e80500
    CALL_NEAR loc_062D1
; @062CC 0000:62CC original=59
    pop cx
; @062CD 0000:62CD original=e2eb
    LOOP_SHORT loc_062BA
; @062CF 0000:62CF original=5d
    pop bp
; @062D0 0000:62D0 original=c3
    ret
; sub_0000_62D1
; @062D1 0000:62D1 original=817e02e000
    cmp word ptr ss:[bp + 2], 0E0h
; @062D6 0000:62D6 original=7601
    JBE_SHORT loc_062D9
; @062D8 0000:62D8 original=c3
    ret
; @062D9 0000:62D9 original=837e1604
    cmp word ptr ss:[bp + 016h], 4
; @062DD 0000:62DD original=7401
    JE_SHORT loc_062E0
; @062DF 0000:62DF original=c3
    ret
; @062E0 0000:62E0 original=837e1800
    cmp word ptr ss:[bp + 018h], 0
; @062E4 0000:62E4 original=7501
    JNE_SHORT loc_062E7
; @062E6 0000:62E6 original=c3
    ret
; @062E7 0000:62E7 original=837e1801
    cmp word ptr ss:[bp + 018h], 1
; @062EB 0000:62EB original=7501
    JNE_SHORT loc_062EE
; @062ED 0000:62ED original=c3
    ret
; @062EE 0000:62EE original=c746200000
    mov word ptr ss:[bp + 020h], 0
; @062F3 0000:62F3 original=e9d15c
    JMP_NEAR loc_0BFC7
; @062F6 0000:62F6 original=837e0000 runtime CFG evidence
    cmp word ptr ss:[bp], 0
; @062FA 0000:62FA original=7503 runtime CFG evidence
    JNE_SHORT loc_062FF
; @062FC 0000:62FC original=e92011 runtime CFG evidence
    JMP_NEAR loc_0741F
; @062FF 0000:62FF original=837e0220 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 020h
; @06303 0000:6303 original=7d03 runtime CFG evidence
    JGE_SHORT loc_06308
; @06305 0000:6305 original=e91711 runtime CFG evidence
    JMP_NEAR loc_0741F
; @06308 0000:6308 original=837e1600 runtime CFG evidence
    cmp word ptr ss:[bp + 016h], 0
; @0630C 0000:630C original=7503 runtime CFG evidence
    JNE_SHORT loc_06311
; @0630E 0000:630E original=e90e11 runtime CFG evidence
    JMP_NEAR loc_0741F
; @06311 0000:6311 original=837e1800 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 0
; @06315 0000:6315 original=7503 runtime CFG evidence
    JNE_SHORT loc_0631A
; @06317 0000:6317 original=e90511 runtime CFG evidence
    JMP_NEAR loc_0741F
; @0631A 0000:631A original=837e1801 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 1
; @0631E 0000:631E original=7503 runtime CFG evidence
    JNE_SHORT loc_06323
; @06320 0000:6320 original=e9fc10 runtime CFG evidence
    JMP_NEAR loc_0741F
; @06323 0000:6323 original=837e1826 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 026h
; @06327 0000:6327 original=7503 runtime CFG evidence
    JNE_SHORT loc_0632C
; @06329 0000:6329 original=e9f310 runtime CFG evidence
    JMP_NEAR loc_0741F
; @0632C 0000:632C original=8b7616 runtime CFG evidence
    mov si, word ptr ss:[bp + 016h]
; @0632F 0000:632F original=8b7e0a runtime CFG evidence
    mov di, word ptr ss:[bp + 0Ah]
; @06332 0000:6332 original=8b5604 runtime CFG evidence
    mov dx, word ptr ss:[bp + 4]
; @06335 0000:6335 original=83e2f8 runtime CFG evidence
    and dx, 0FFF8h
; @06338 0000:6338 original=8b4e02 runtime CFG evidence
    mov cx, word ptr ss:[bp + 2]
; @0633B 0000:633B original=83e1f8 runtime CFG evidence
    and cx, 0FFF8h
; @0633E 0000:633E original=bb5c2b runtime CFG evidence
    mov bx, 02B5Ch
; @06341 0000:6341 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06344 0000:6344 original=7477 runtime CFG evidence
    JE_SHORT loc_063BD
; @06346 0000:6346 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @0634A 0000:634A original=7471 runtime CFG evidence
    JE_SHORT loc_063BD
; @0634C 0000:634C original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @0634F 0000:634F original=a90700 runtime CFG evidence
    test ax, 7
; @06352 0000:6352 original=740d runtime CFG evidence
    JE_SHORT loc_06361
; @06354 0000:6354 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06357 0000:6357 original=050800 runtime CFG evidence
    add ax, 8
; @0635A 0000:635A original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0635C 0000:635C original=7422 runtime CFG evidence
    JE_SHORT loc_06380
; @0635E 0000:635E original=2d0800 runtime CFG evidence
    sub ax, 8
; @06361 0000:6361 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06363 0000:6363 original=741b runtime CFG evidence
    JE_SHORT loc_06380
; @06365 0000:6365 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06368 0000:6368 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0636A 0000:636A original=7414 runtime CFG evidence
    JE_SHORT loc_06380
; @0636C 0000:636C original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06370 0000:6370 original=754b runtime CFG evidence
    JNE_SHORT loc_063BD
; @06372 0000:6372 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06375 0000:6375 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06377 0000:6377 original=7407 runtime CFG evidence
    JE_SHORT loc_06380
; @06379 0000:6379 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0637C 0000:637C original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0637E 0000:637E original=753d runtime CFG evidence
    JNE_SHORT loc_063BD
; @06380 0000:6380 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06383 0000:6383 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06386 0000:6386 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06388 0000:6388 original=7503 runtime CFG evidence
    JNE_SHORT loc_0638D
; @0638A 0000:638A original=e9385b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0638D 0000:638D original=2d0800 runtime CFG evidence
    sub ax, 8
; @06390 0000:6390 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06392 0000:6392 original=7503 runtime CFG evidence
    JNE_SHORT loc_06397
; @06394 0000:6394 original=e92e5b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06397 0000:6397 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0639B 0000:639B original=7520 runtime CFG evidence
    JNE_SHORT loc_063BD
; @0639D 0000:639D original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @063A1 0000:63A1 original=741a runtime CFG evidence
    JE_SHORT loc_063BD
; @063A3 0000:63A3 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @063A7 0000:63A7 original=7414 runtime CFG evidence
    JE_SHORT loc_063BD
; @063A9 0000:63A9 original=2d0800 runtime CFG evidence
    sub ax, 8
; @063AC 0000:63AC original=3bc1 runtime CFG evidence
    cmp ax, cx
; @063AE 0000:63AE original=7503 runtime CFG evidence
    JNE_SHORT loc_063B3
; @063B0 0000:63B0 original=e9125b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @063B3 0000:63B3 original=2d0800 runtime CFG evidence
    sub ax, 8
; @063B6 0000:63B6 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @063B8 0000:63B8 original=7503 runtime CFG evidence
    JNE_SHORT loc_063BD
; @063BA 0000:63BA original=e9085b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @063BD 0000:63BD original=83c338 runtime CFG evidence
    add bx, 038h
; @063C0 0000:63C0 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @063C3 0000:63C3 original=7477 runtime CFG evidence
    JE_SHORT loc_0643C
; @063C5 0000:63C5 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @063C9 0000:63C9 original=7471 runtime CFG evidence
    JE_SHORT loc_0643C
; @063CB 0000:63CB original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @063CE 0000:63CE original=a90700 runtime CFG evidence
    test ax, 7
; @063D1 0000:63D1 original=740d runtime CFG evidence
    JE_SHORT loc_063E0
; @063D3 0000:63D3 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @063D6 0000:63D6 original=050800 runtime CFG evidence
    add ax, 8
; @063D9 0000:63D9 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @063DB 0000:63DB original=7422 runtime CFG evidence
    JE_SHORT loc_063FF
; @063DD 0000:63DD original=2d0800 runtime CFG evidence
    sub ax, 8
; @063E0 0000:63E0 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @063E2 0000:63E2 original=741b runtime CFG evidence
    JE_SHORT loc_063FF
; @063E4 0000:63E4 original=2d0800 runtime CFG evidence
    sub ax, 8
; @063E7 0000:63E7 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @063E9 0000:63E9 original=7414 runtime CFG evidence
    JE_SHORT loc_063FF
; @063EB 0000:63EB original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @063EF 0000:63EF original=754b runtime CFG evidence
    JNE_SHORT loc_0643C
; @063F1 0000:63F1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @063F4 0000:63F4 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @063F6 0000:63F6 original=7407 runtime CFG evidence
    JE_SHORT loc_063FF
; @063F8 0000:63F8 original=2d0800 runtime CFG evidence
    sub ax, 8
; @063FB 0000:63FB original=3bc2 runtime CFG evidence
    cmp ax, dx
; @063FD 0000:63FD original=753d runtime CFG evidence
    JNE_SHORT loc_0643C
; @063FF 0000:63FF original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06402 0000:6402 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06405 0000:6405 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06407 0000:6407 original=7503 runtime CFG evidence
    JNE_SHORT loc_0640C
; @06409 0000:6409 original=e9b95a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0640C 0000:640C original=2d0800 runtime CFG evidence
    sub ax, 8
; @0640F 0000:640F original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06411 0000:6411 original=7503 runtime CFG evidence
    JNE_SHORT loc_06416
; @06413 0000:6413 original=e9af5a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06416 0000:6416 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0641A 0000:641A original=7520 runtime CFG evidence
    JNE_SHORT loc_0643C
; @0641C 0000:641C original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06420 0000:6420 original=741a runtime CFG evidence
    JE_SHORT loc_0643C
; @06422 0000:6422 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06426 0000:6426 original=7414 runtime CFG evidence
    JE_SHORT loc_0643C
; @06428 0000:6428 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0642B 0000:642B original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0642D 0000:642D original=7503 runtime CFG evidence
    JNE_SHORT loc_06432
; @0642F 0000:642F original=e9935a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06432 0000:6432 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06435 0000:6435 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06437 0000:6437 original=7503 runtime CFG evidence
    JNE_SHORT loc_0643C
; @06439 0000:6439 original=e9895a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0643C 0000:643C original=83c338 runtime CFG evidence
    add bx, 038h
; @0643F 0000:643F original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06442 0000:6442 original=7477 runtime CFG evidence
    JE_SHORT loc_064BB
; @06444 0000:6444 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06448 0000:6448 original=7471 runtime CFG evidence
    JE_SHORT loc_064BB
; @0644A 0000:644A original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @0644D 0000:644D original=a90700 runtime CFG evidence
    test ax, 7
; @06450 0000:6450 original=740d runtime CFG evidence
    JE_SHORT loc_0645F
; @06452 0000:6452 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06455 0000:6455 original=050800 runtime CFG evidence
    add ax, 8
; @06458 0000:6458 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0645A 0000:645A original=7422 runtime CFG evidence
    JE_SHORT loc_0647E
; @0645C 0000:645C original=2d0800 runtime CFG evidence
    sub ax, 8
; @0645F 0000:645F original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06461 0000:6461 original=741b runtime CFG evidence
    JE_SHORT loc_0647E
; @06463 0000:6463 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06466 0000:6466 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06468 0000:6468 original=7414 runtime CFG evidence
    JE_SHORT loc_0647E
; @0646A 0000:646A original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0646E 0000:646E original=754b runtime CFG evidence
    JNE_SHORT loc_064BB
; @06470 0000:6470 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06473 0000:6473 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06475 0000:6475 original=7407 runtime CFG evidence
    JE_SHORT loc_0647E
; @06477 0000:6477 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0647A 0000:647A original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0647C 0000:647C original=753d runtime CFG evidence
    JNE_SHORT loc_064BB
; @0647E 0000:647E original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06481 0000:6481 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06484 0000:6484 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06486 0000:6486 original=7503 runtime CFG evidence
    JNE_SHORT loc_0648B
; @06488 0000:6488 original=e93a5a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0648B 0000:648B original=2d0800 runtime CFG evidence
    sub ax, 8
; @0648E 0000:648E original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06490 0000:6490 original=7503 runtime CFG evidence
    JNE_SHORT loc_06495
; @06492 0000:6492 original=e9305a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06495 0000:6495 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06499 0000:6499 original=7520 runtime CFG evidence
    JNE_SHORT loc_064BB
; @0649B 0000:649B original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @0649F 0000:649F original=741a runtime CFG evidence
    JE_SHORT loc_064BB
; @064A1 0000:64A1 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @064A5 0000:64A5 original=7414 runtime CFG evidence
    JE_SHORT loc_064BB
; @064A7 0000:64A7 original=2d0800 runtime CFG evidence
    sub ax, 8
; @064AA 0000:64AA original=3bc1 runtime CFG evidence
    cmp ax, cx
; @064AC 0000:64AC original=7503 runtime CFG evidence
    JNE_SHORT loc_064B1
; @064AE 0000:64AE original=e9145a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @064B1 0000:64B1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @064B4 0000:64B4 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @064B6 0000:64B6 original=7503 runtime CFG evidence
    JNE_SHORT loc_064BB
; @064B8 0000:64B8 original=e90a5a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @064BB 0000:64BB original=83c338 runtime CFG evidence
    add bx, 038h
; @064BE 0000:64BE original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @064C1 0000:64C1 original=7477 runtime CFG evidence
    JE_SHORT loc_0653A
; @064C3 0000:64C3 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @064C7 0000:64C7 original=7471 runtime CFG evidence
    JE_SHORT loc_0653A
; @064C9 0000:64C9 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @064CC 0000:64CC original=a90700 runtime CFG evidence
    test ax, 7
; @064CF 0000:64CF original=740d runtime CFG evidence
    JE_SHORT loc_064DE
; @064D1 0000:64D1 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @064D4 0000:64D4 original=050800 runtime CFG evidence
    add ax, 8
; @064D7 0000:64D7 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @064D9 0000:64D9 original=7422 runtime CFG evidence
    JE_SHORT loc_064FD
; @064DB 0000:64DB original=2d0800 runtime CFG evidence
    sub ax, 8
; @064DE 0000:64DE original=3bc2 runtime CFG evidence
    cmp ax, dx
; @064E0 0000:64E0 original=741b runtime CFG evidence
    JE_SHORT loc_064FD
; @064E2 0000:64E2 original=2d0800 runtime CFG evidence
    sub ax, 8
; @064E5 0000:64E5 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @064E7 0000:64E7 original=7414 runtime CFG evidence
    JE_SHORT loc_064FD
; @064E9 0000:64E9 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @064ED 0000:64ED original=754b runtime CFG evidence
    JNE_SHORT loc_0653A
; @064EF 0000:64EF original=2d0800 runtime CFG evidence
    sub ax, 8
; @064F2 0000:64F2 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @064F4 0000:64F4 original=7407 runtime CFG evidence
    JE_SHORT loc_064FD
; @064F6 0000:64F6 original=2d0800 runtime CFG evidence
    sub ax, 8
; @064F9 0000:64F9 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @064FB 0000:64FB original=753d runtime CFG evidence
    JNE_SHORT loc_0653A
; @064FD 0000:64FD original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06500 0000:6500 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06503 0000:6503 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06505 0000:6505 original=7503 runtime CFG evidence
    JNE_SHORT loc_0650A
; @06507 0000:6507 original=e9bb59 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0650A 0000:650A original=2d0800 runtime CFG evidence
    sub ax, 8
; @0650D 0000:650D original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0650F 0000:650F original=7503 runtime CFG evidence
    JNE_SHORT loc_06514
; @06511 0000:6511 original=e9b159 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06514 0000:6514 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06518 0000:6518 original=7520 runtime CFG evidence
    JNE_SHORT loc_0653A
; @0651A 0000:651A original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @0651E 0000:651E original=741a runtime CFG evidence
    JE_SHORT loc_0653A
; @06520 0000:6520 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06524 0000:6524 original=7414 runtime CFG evidence
    JE_SHORT loc_0653A
; @06526 0000:6526 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06529 0000:6529 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0652B 0000:652B original=7503 runtime CFG evidence
    JNE_SHORT loc_06530
; @0652D 0000:652D original=e99559 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06530 0000:6530 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06533 0000:6533 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06535 0000:6535 original=7503 runtime CFG evidence
    JNE_SHORT loc_0653A
; @06537 0000:6537 original=e98b59 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0653A 0000:653A original=83c338 runtime CFG evidence
    add bx, 038h
; @0653D 0000:653D original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06540 0000:6540 original=7477 runtime CFG evidence
    JE_SHORT loc_065B9
; @06542 0000:6542 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06546 0000:6546 original=7471 runtime CFG evidence
    JE_SHORT loc_065B9
; @06548 0000:6548 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @0654B 0000:654B original=a90700 runtime CFG evidence
    test ax, 7
; @0654E 0000:654E original=740d runtime CFG evidence
    JE_SHORT loc_0655D
; @06550 0000:6550 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06553 0000:6553 original=050800 runtime CFG evidence
    add ax, 8
; @06556 0000:6556 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06558 0000:6558 original=7422 runtime CFG evidence
    JE_SHORT loc_0657C
; @0655A 0000:655A original=2d0800 runtime CFG evidence
    sub ax, 8
; @0655D 0000:655D original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0655F 0000:655F original=741b runtime CFG evidence
    JE_SHORT loc_0657C
; @06561 0000:6561 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06564 0000:6564 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06566 0000:6566 original=7414 runtime CFG evidence
    JE_SHORT loc_0657C
; @06568 0000:6568 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0656C 0000:656C original=754b runtime CFG evidence
    JNE_SHORT loc_065B9
; @0656E 0000:656E original=2d0800 runtime CFG evidence
    sub ax, 8
; @06571 0000:6571 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06573 0000:6573 original=7407 runtime CFG evidence
    JE_SHORT loc_0657C
; @06575 0000:6575 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06578 0000:6578 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0657A 0000:657A original=753d runtime CFG evidence
    JNE_SHORT loc_065B9
; @0657C 0000:657C original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @0657F 0000:657F original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06582 0000:6582 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06584 0000:6584 original=7503 runtime CFG evidence
    JNE_SHORT loc_06589
; @06586 0000:6586 original=e93c59 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06589 0000:6589 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0658C 0000:658C original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0658E 0000:658E original=7503 runtime CFG evidence
    JNE_SHORT loc_06593
; @06590 0000:6590 original=e93259 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06593 0000:6593 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06597 0000:6597 original=7520 runtime CFG evidence
    JNE_SHORT loc_065B9
; @06599 0000:6599 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @0659D 0000:659D original=741a runtime CFG evidence
    JE_SHORT loc_065B9
; @0659F 0000:659F original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @065A3 0000:65A3 original=7414 runtime CFG evidence
    JE_SHORT loc_065B9
; @065A5 0000:65A5 original=2d0800 runtime CFG evidence
    sub ax, 8
; @065A8 0000:65A8 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @065AA 0000:65AA original=7503 runtime CFG evidence
    JNE_SHORT loc_065AF
; @065AC 0000:65AC original=e91659 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @065AF 0000:65AF original=2d0800 runtime CFG evidence
    sub ax, 8
; @065B2 0000:65B2 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @065B4 0000:65B4 original=7503 runtime CFG evidence
    JNE_SHORT loc_065B9
; @065B6 0000:65B6 original=e90c59 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @065B9 0000:65B9 original=83c338 runtime CFG evidence
    add bx, 038h
; @065BC 0000:65BC original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @065BF 0000:65BF original=7477 runtime CFG evidence
    JE_SHORT loc_06638
; @065C1 0000:65C1 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @065C5 0000:65C5 original=7471 runtime CFG evidence
    JE_SHORT loc_06638
; @065C7 0000:65C7 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @065CA 0000:65CA original=a90700 runtime CFG evidence
    test ax, 7
; @065CD 0000:65CD original=740d runtime CFG evidence
    JE_SHORT loc_065DC
; @065CF 0000:65CF original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @065D2 0000:65D2 original=050800 runtime CFG evidence
    add ax, 8
; @065D5 0000:65D5 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @065D7 0000:65D7 original=7422 runtime CFG evidence
    JE_SHORT loc_065FB
; @065D9 0000:65D9 original=2d0800 runtime CFG evidence
    sub ax, 8
; @065DC 0000:65DC original=3bc2 runtime CFG evidence
    cmp ax, dx
; @065DE 0000:65DE original=741b runtime CFG evidence
    JE_SHORT loc_065FB
; @065E0 0000:65E0 original=2d0800 runtime CFG evidence
    sub ax, 8
; @065E3 0000:65E3 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @065E5 0000:65E5 original=7414 runtime CFG evidence
    JE_SHORT loc_065FB
; @065E7 0000:65E7 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @065EB 0000:65EB original=754b runtime CFG evidence
    JNE_SHORT loc_06638
; @065ED 0000:65ED original=2d0800 runtime CFG evidence
    sub ax, 8
; @065F0 0000:65F0 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @065F2 0000:65F2 original=7407 runtime CFG evidence
    JE_SHORT loc_065FB
; @065F4 0000:65F4 original=2d0800 runtime CFG evidence
    sub ax, 8
; @065F7 0000:65F7 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @065F9 0000:65F9 original=753d runtime CFG evidence
    JNE_SHORT loc_06638
; @065FB 0000:65FB original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @065FE 0000:65FE original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06601 0000:6601 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06603 0000:6603 original=7503 runtime CFG evidence
    JNE_SHORT loc_06608
; @06605 0000:6605 original=e9bd58 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06608 0000:6608 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0660B 0000:660B original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0660D 0000:660D original=7503 runtime CFG evidence
    JNE_SHORT loc_06612
; @0660F 0000:660F original=e9b358 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06612 0000:6612 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06616 0000:6616 original=7520 runtime CFG evidence
    JNE_SHORT loc_06638
; @06618 0000:6618 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @0661C 0000:661C original=741a runtime CFG evidence
    JE_SHORT loc_06638
; @0661E 0000:661E original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06622 0000:6622 original=7414 runtime CFG evidence
    JE_SHORT loc_06638
; @06624 0000:6624 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06627 0000:6627 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06629 0000:6629 original=7503 runtime CFG evidence
    JNE_SHORT loc_0662E
; @0662B 0000:662B original=e99758 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0662E 0000:662E original=2d0800 runtime CFG evidence
    sub ax, 8
; @06631 0000:6631 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06633 0000:6633 original=7503 runtime CFG evidence
    JNE_SHORT loc_06638
; @06635 0000:6635 original=e98d58 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06638 0000:6638 original=83c338 runtime CFG evidence
    add bx, 038h
; @0663B 0000:663B original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @0663E 0000:663E original=7477 runtime CFG evidence
    JE_SHORT loc_066B7
; @06640 0000:6640 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06644 0000:6644 original=7471 runtime CFG evidence
    JE_SHORT loc_066B7
; @06646 0000:6646 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06649 0000:6649 original=a90700 runtime CFG evidence
    test ax, 7
; @0664C 0000:664C original=740d runtime CFG evidence
    JE_SHORT loc_0665B
; @0664E 0000:664E original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06651 0000:6651 original=050800 runtime CFG evidence
    add ax, 8
; @06654 0000:6654 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06656 0000:6656 original=7422 runtime CFG evidence
    JE_SHORT loc_0667A
; @06658 0000:6658 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0665B 0000:665B original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0665D 0000:665D original=741b runtime CFG evidence
    JE_SHORT loc_0667A
; @0665F 0000:665F original=2d0800 runtime CFG evidence
    sub ax, 8
; @06662 0000:6662 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06664 0000:6664 original=7414 runtime CFG evidence
    JE_SHORT loc_0667A
; @06666 0000:6666 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0666A 0000:666A original=754b runtime CFG evidence
    JNE_SHORT loc_066B7
; @0666C 0000:666C original=2d0800 runtime CFG evidence
    sub ax, 8
; @0666F 0000:666F original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06671 0000:6671 original=7407 runtime CFG evidence
    JE_SHORT loc_0667A
; @06673 0000:6673 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06676 0000:6676 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06678 0000:6678 original=753d runtime CFG evidence
    JNE_SHORT loc_066B7
; @0667A 0000:667A original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @0667D 0000:667D original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06680 0000:6680 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06682 0000:6682 original=7503 runtime CFG evidence
    JNE_SHORT loc_06687
; @06684 0000:6684 original=e93e58 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06687 0000:6687 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0668A 0000:668A original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0668C 0000:668C original=7503 runtime CFG evidence
    JNE_SHORT loc_06691
; @0668E 0000:668E original=e93458 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06691 0000:6691 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06695 0000:6695 original=7520 runtime CFG evidence
    JNE_SHORT loc_066B7
; @06697 0000:6697 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @0669B 0000:669B original=741a runtime CFG evidence
    JE_SHORT loc_066B7
; @0669D 0000:669D original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @066A1 0000:66A1 original=7414 runtime CFG evidence
    JE_SHORT loc_066B7
; @066A3 0000:66A3 original=2d0800 runtime CFG evidence
    sub ax, 8
; @066A6 0000:66A6 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @066A8 0000:66A8 original=7503 runtime CFG evidence
    JNE_SHORT loc_066AD
; @066AA 0000:66AA original=e91858 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @066AD 0000:66AD original=2d0800 runtime CFG evidence
    sub ax, 8
; @066B0 0000:66B0 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @066B2 0000:66B2 original=7503 runtime CFG evidence
    JNE_SHORT loc_066B7
; @066B4 0000:66B4 original=e90e58 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @066B7 0000:66B7 original=83c338 runtime CFG evidence
    add bx, 038h
; @066BA 0000:66BA original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @066BD 0000:66BD original=7477 runtime CFG evidence
    JE_SHORT loc_06736
; @066BF 0000:66BF original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @066C3 0000:66C3 original=7471 runtime CFG evidence
    JE_SHORT loc_06736
; @066C5 0000:66C5 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @066C8 0000:66C8 original=a90700 runtime CFG evidence
    test ax, 7
; @066CB 0000:66CB original=740d runtime CFG evidence
    JE_SHORT loc_066DA
; @066CD 0000:66CD original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @066D0 0000:66D0 original=050800 runtime CFG evidence
    add ax, 8
; @066D3 0000:66D3 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @066D5 0000:66D5 original=7422 runtime CFG evidence
    JE_SHORT loc_066F9
; @066D7 0000:66D7 original=2d0800 runtime CFG evidence
    sub ax, 8
; @066DA 0000:66DA original=3bc2 runtime CFG evidence
    cmp ax, dx
; @066DC 0000:66DC original=741b runtime CFG evidence
    JE_SHORT loc_066F9
; @066DE 0000:66DE original=2d0800 runtime CFG evidence
    sub ax, 8
; @066E1 0000:66E1 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @066E3 0000:66E3 original=7414 runtime CFG evidence
    JE_SHORT loc_066F9
; @066E5 0000:66E5 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @066E9 0000:66E9 original=754b runtime CFG evidence
    JNE_SHORT loc_06736
; @066EB 0000:66EB original=2d0800 runtime CFG evidence
    sub ax, 8
; @066EE 0000:66EE original=3bc2 runtime CFG evidence
    cmp ax, dx
; @066F0 0000:66F0 original=7407 runtime CFG evidence
    JE_SHORT loc_066F9
; @066F2 0000:66F2 original=2d0800 runtime CFG evidence
    sub ax, 8
; @066F5 0000:66F5 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @066F7 0000:66F7 original=753d runtime CFG evidence
    JNE_SHORT loc_06736
; @066F9 0000:66F9 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @066FC 0000:66FC original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @066FF 0000:66FF original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06701 0000:6701 original=7503 runtime CFG evidence
    JNE_SHORT loc_06706
; @06703 0000:6703 original=e9bf57 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06706 0000:6706 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06709 0000:6709 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0670B 0000:670B original=7503 runtime CFG evidence
    JNE_SHORT loc_06710
; @0670D 0000:670D original=e9b557 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06710 0000:6710 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06714 0000:6714 original=7520 runtime CFG evidence
    JNE_SHORT loc_06736
; @06716 0000:6716 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @0671A 0000:671A original=741a runtime CFG evidence
    JE_SHORT loc_06736
; @0671C 0000:671C original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06720 0000:6720 original=7414 runtime CFG evidence
    JE_SHORT loc_06736
; @06722 0000:6722 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06725 0000:6725 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06727 0000:6727 original=7503 runtime CFG evidence
    JNE_SHORT loc_0672C
; @06729 0000:6729 original=e99957 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0672C 0000:672C original=2d0800 runtime CFG evidence
    sub ax, 8
; @0672F 0000:672F original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06731 0000:6731 original=7503 runtime CFG evidence
    JNE_SHORT loc_06736
; @06733 0000:6733 original=e98f57 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06736 0000:6736 original=83c338 runtime CFG evidence
    add bx, 038h
; @06739 0000:6739 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @0673C 0000:673C original=7477 runtime CFG evidence
    JE_SHORT loc_067B5
; @0673E 0000:673E original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06742 0000:6742 original=7471 runtime CFG evidence
    JE_SHORT loc_067B5
; @06744 0000:6744 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06747 0000:6747 original=a90700 runtime CFG evidence
    test ax, 7
; @0674A 0000:674A original=740d runtime CFG evidence
    JE_SHORT loc_06759
; @0674C 0000:674C original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0674F 0000:674F original=050800 runtime CFG evidence
    add ax, 8
; @06752 0000:6752 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06754 0000:6754 original=7422 runtime CFG evidence
    JE_SHORT loc_06778
; @06756 0000:6756 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06759 0000:6759 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0675B 0000:675B original=741b runtime CFG evidence
    JE_SHORT loc_06778
; @0675D 0000:675D original=2d0800 runtime CFG evidence
    sub ax, 8
; @06760 0000:6760 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06762 0000:6762 original=7414 runtime CFG evidence
    JE_SHORT loc_06778
; @06764 0000:6764 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06768 0000:6768 original=754b runtime CFG evidence
    JNE_SHORT loc_067B5
; @0676A 0000:676A original=2d0800 runtime CFG evidence
    sub ax, 8
; @0676D 0000:676D original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0676F 0000:676F original=7407 runtime CFG evidence
    JE_SHORT loc_06778
; @06771 0000:6771 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06774 0000:6774 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06776 0000:6776 original=753d runtime CFG evidence
    JNE_SHORT loc_067B5
; @06778 0000:6778 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @0677B 0000:677B original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0677E 0000:677E original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06780 0000:6780 original=7503 runtime CFG evidence
    JNE_SHORT loc_06785
; @06782 0000:6782 original=e94057 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06785 0000:6785 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06788 0000:6788 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0678A 0000:678A original=7503 runtime CFG evidence
    JNE_SHORT loc_0678F
; @0678C 0000:678C original=e93657 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0678F 0000:678F original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06793 0000:6793 original=7520 runtime CFG evidence
    JNE_SHORT loc_067B5
; @06795 0000:6795 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06799 0000:6799 original=741a runtime CFG evidence
    JE_SHORT loc_067B5
; @0679B 0000:679B original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0679F 0000:679F original=7414 runtime CFG evidence
    JE_SHORT loc_067B5
; @067A1 0000:67A1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @067A4 0000:67A4 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @067A6 0000:67A6 original=7503 runtime CFG evidence
    JNE_SHORT loc_067AB
; @067A8 0000:67A8 original=e91a57 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @067AB 0000:67AB original=2d0800 runtime CFG evidence
    sub ax, 8
; @067AE 0000:67AE original=3bc1 runtime CFG evidence
    cmp ax, cx
; @067B0 0000:67B0 original=7503 runtime CFG evidence
    JNE_SHORT loc_067B5
; @067B2 0000:67B2 original=e91057 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @067B5 0000:67B5 original=83c338 runtime CFG evidence
    add bx, 038h
; @067B8 0000:67B8 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @067BB 0000:67BB original=7477 runtime CFG evidence
    JE_SHORT loc_06834
; @067BD 0000:67BD original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @067C1 0000:67C1 original=7471 runtime CFG evidence
    JE_SHORT loc_06834
; @067C3 0000:67C3 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @067C6 0000:67C6 original=a90700 runtime CFG evidence
    test ax, 7
; @067C9 0000:67C9 original=740d runtime CFG evidence
    JE_SHORT loc_067D8
; @067CB 0000:67CB original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @067CE 0000:67CE original=050800 runtime CFG evidence
    add ax, 8
; @067D1 0000:67D1 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @067D3 0000:67D3 original=7422 runtime CFG evidence
    JE_SHORT loc_067F7
; @067D5 0000:67D5 original=2d0800 runtime CFG evidence
    sub ax, 8
; @067D8 0000:67D8 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @067DA 0000:67DA original=741b runtime CFG evidence
    JE_SHORT loc_067F7
; @067DC 0000:67DC original=2d0800 runtime CFG evidence
    sub ax, 8
; @067DF 0000:67DF original=3bc2 runtime CFG evidence
    cmp ax, dx
; @067E1 0000:67E1 original=7414 runtime CFG evidence
    JE_SHORT loc_067F7
; @067E3 0000:67E3 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @067E7 0000:67E7 original=754b runtime CFG evidence
    JNE_SHORT loc_06834
; @067E9 0000:67E9 original=2d0800 runtime CFG evidence
    sub ax, 8
; @067EC 0000:67EC original=3bc2 runtime CFG evidence
    cmp ax, dx
; @067EE 0000:67EE original=7407 runtime CFG evidence
    JE_SHORT loc_067F7
; @067F0 0000:67F0 original=2d0800 runtime CFG evidence
    sub ax, 8
; @067F3 0000:67F3 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @067F5 0000:67F5 original=753d runtime CFG evidence
    JNE_SHORT loc_06834
; @067F7 0000:67F7 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @067FA 0000:67FA original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @067FD 0000:67FD original=3bc1 runtime CFG evidence
    cmp ax, cx
; @067FF 0000:67FF original=7503 runtime CFG evidence
    JNE_SHORT loc_06804
; @06801 0000:6801 original=e9c156 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06804 0000:6804 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06807 0000:6807 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06809 0000:6809 original=7503 runtime CFG evidence
    JNE_SHORT loc_0680E
; @0680B 0000:680B original=e9b756 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0680E 0000:680E original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06812 0000:6812 original=7520 runtime CFG evidence
    JNE_SHORT loc_06834
; @06814 0000:6814 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06818 0000:6818 original=741a runtime CFG evidence
    JE_SHORT loc_06834
; @0681A 0000:681A original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0681E 0000:681E original=7414 runtime CFG evidence
    JE_SHORT loc_06834
; @06820 0000:6820 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06823 0000:6823 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06825 0000:6825 original=7503 runtime CFG evidence
    JNE_SHORT loc_0682A
; @06827 0000:6827 original=e99b56 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0682A 0000:682A original=2d0800 runtime CFG evidence
    sub ax, 8
; @0682D 0000:682D original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0682F 0000:682F original=7503 runtime CFG evidence
    JNE_SHORT loc_06834
; @06831 0000:6831 original=e99156 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06834 0000:6834 original=83c338 runtime CFG evidence
    add bx, 038h
; @06837 0000:6837 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @0683A 0000:683A original=7477 runtime CFG evidence
    JE_SHORT loc_068B3
; @0683C 0000:683C original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06840 0000:6840 original=7471 runtime CFG evidence
    JE_SHORT loc_068B3
; @06842 0000:6842 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06845 0000:6845 original=a90700 runtime CFG evidence
    test ax, 7
; @06848 0000:6848 original=740d runtime CFG evidence
    JE_SHORT loc_06857
; @0684A 0000:684A original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0684D 0000:684D original=050800 runtime CFG evidence
    add ax, 8
; @06850 0000:6850 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06852 0000:6852 original=7422 runtime CFG evidence
    JE_SHORT loc_06876
; @06854 0000:6854 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06857 0000:6857 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06859 0000:6859 original=741b runtime CFG evidence
    JE_SHORT loc_06876
; @0685B 0000:685B original=2d0800 runtime CFG evidence
    sub ax, 8
; @0685E 0000:685E original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06860 0000:6860 original=7414 runtime CFG evidence
    JE_SHORT loc_06876
; @06862 0000:6862 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06866 0000:6866 original=754b runtime CFG evidence
    JNE_SHORT loc_068B3
; @06868 0000:6868 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0686B 0000:686B original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0686D 0000:686D original=7407 runtime CFG evidence
    JE_SHORT loc_06876
; @0686F 0000:686F original=2d0800 runtime CFG evidence
    sub ax, 8
; @06872 0000:6872 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06874 0000:6874 original=753d runtime CFG evidence
    JNE_SHORT loc_068B3
; @06876 0000:6876 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06879 0000:6879 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0687C 0000:687C original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0687E 0000:687E original=7503 runtime CFG evidence
    JNE_SHORT loc_06883
; @06880 0000:6880 original=e94256 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06883 0000:6883 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06886 0000:6886 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06888 0000:6888 original=7503 runtime CFG evidence
    JNE_SHORT loc_0688D
; @0688A 0000:688A original=e93856 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0688D 0000:688D original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06891 0000:6891 original=7520 runtime CFG evidence
    JNE_SHORT loc_068B3
; @06893 0000:6893 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06897 0000:6897 original=741a runtime CFG evidence
    JE_SHORT loc_068B3
; @06899 0000:6899 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0689D 0000:689D original=7414 runtime CFG evidence
    JE_SHORT loc_068B3
; @0689F 0000:689F original=2d0800 runtime CFG evidence
    sub ax, 8
; @068A2 0000:68A2 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @068A4 0000:68A4 original=7503 runtime CFG evidence
    JNE_SHORT loc_068A9
; @068A6 0000:68A6 original=e91c56 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @068A9 0000:68A9 original=2d0800 runtime CFG evidence
    sub ax, 8
; @068AC 0000:68AC original=3bc1 runtime CFG evidence
    cmp ax, cx
; @068AE 0000:68AE original=7503 runtime CFG evidence
    JNE_SHORT loc_068B3
; @068B0 0000:68B0 original=e91256 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @068B3 0000:68B3 original=83c338 runtime CFG evidence
    add bx, 038h
; @068B6 0000:68B6 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @068B9 0000:68B9 original=7477 runtime CFG evidence
    JE_SHORT loc_06932
; @068BB 0000:68BB original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @068BF 0000:68BF original=7471 runtime CFG evidence
    JE_SHORT loc_06932
; @068C1 0000:68C1 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @068C4 0000:68C4 original=a90700 runtime CFG evidence
    test ax, 7
; @068C7 0000:68C7 original=740d runtime CFG evidence
    JE_SHORT loc_068D6
; @068C9 0000:68C9 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @068CC 0000:68CC original=050800 runtime CFG evidence
    add ax, 8
; @068CF 0000:68CF original=3bc2 runtime CFG evidence
    cmp ax, dx
; @068D1 0000:68D1 original=7422 runtime CFG evidence
    JE_SHORT loc_068F5
; @068D3 0000:68D3 original=2d0800 runtime CFG evidence
    sub ax, 8
; @068D6 0000:68D6 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @068D8 0000:68D8 original=741b runtime CFG evidence
    JE_SHORT loc_068F5
; @068DA 0000:68DA original=2d0800 runtime CFG evidence
    sub ax, 8
; @068DD 0000:68DD original=3bc2 runtime CFG evidence
    cmp ax, dx
; @068DF 0000:68DF original=7414 runtime CFG evidence
    JE_SHORT loc_068F5
; @068E1 0000:68E1 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @068E5 0000:68E5 original=754b runtime CFG evidence
    JNE_SHORT loc_06932
; @068E7 0000:68E7 original=2d0800 runtime CFG evidence
    sub ax, 8
; @068EA 0000:68EA original=3bc2 runtime CFG evidence
    cmp ax, dx
; @068EC 0000:68EC original=7407 runtime CFG evidence
    JE_SHORT loc_068F5
; @068EE 0000:68EE original=2d0800 runtime CFG evidence
    sub ax, 8
; @068F1 0000:68F1 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @068F3 0000:68F3 original=753d runtime CFG evidence
    JNE_SHORT loc_06932
; @068F5 0000:68F5 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @068F8 0000:68F8 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @068FB 0000:68FB original=3bc1 runtime CFG evidence
    cmp ax, cx
; @068FD 0000:68FD original=7503 runtime CFG evidence
    JNE_SHORT loc_06902
; @068FF 0000:68FF original=e9c355 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06902 0000:6902 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06905 0000:6905 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06907 0000:6907 original=7503 runtime CFG evidence
    JNE_SHORT loc_0690C
; @06909 0000:6909 original=e9b955 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0690C 0000:690C original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06910 0000:6910 original=7520 runtime CFG evidence
    JNE_SHORT loc_06932
; @06912 0000:6912 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06916 0000:6916 original=741a runtime CFG evidence
    JE_SHORT loc_06932
; @06918 0000:6918 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0691C 0000:691C original=7414 runtime CFG evidence
    JE_SHORT loc_06932
; @0691E 0000:691E original=2d0800 runtime CFG evidence
    sub ax, 8
; @06921 0000:6921 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06923 0000:6923 original=7503 runtime CFG evidence
    JNE_SHORT loc_06928
; @06925 0000:6925 original=e99d55 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06928 0000:6928 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0692B 0000:692B original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0692D 0000:692D original=7503 runtime CFG evidence
    JNE_SHORT loc_06932
; @0692F 0000:692F original=e99355 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06932 0000:6932 original=83c338 runtime CFG evidence
    add bx, 038h
; @06935 0000:6935 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06938 0000:6938 original=7477 runtime CFG evidence
    JE_SHORT loc_069B1
; @0693A 0000:693A original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @0693E 0000:693E original=7471 runtime CFG evidence
    JE_SHORT loc_069B1
; @06940 0000:6940 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06943 0000:6943 original=a90700 runtime CFG evidence
    test ax, 7
; @06946 0000:6946 original=740d runtime CFG evidence
    JE_SHORT loc_06955
; @06948 0000:6948 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0694B 0000:694B original=050800 runtime CFG evidence
    add ax, 8
; @0694E 0000:694E original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06950 0000:6950 original=7422 runtime CFG evidence
    JE_SHORT loc_06974
; @06952 0000:6952 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06955 0000:6955 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06957 0000:6957 original=741b runtime CFG evidence
    JE_SHORT loc_06974
; @06959 0000:6959 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0695C 0000:695C original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0695E 0000:695E original=7414 runtime CFG evidence
    JE_SHORT loc_06974
; @06960 0000:6960 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06964 0000:6964 original=754b runtime CFG evidence
    JNE_SHORT loc_069B1
; @06966 0000:6966 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06969 0000:6969 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0696B 0000:696B original=7407 runtime CFG evidence
    JE_SHORT loc_06974
; @0696D 0000:696D original=2d0800 runtime CFG evidence
    sub ax, 8
; @06970 0000:6970 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06972 0000:6972 original=753d runtime CFG evidence
    JNE_SHORT loc_069B1
; @06974 0000:6974 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06977 0000:6977 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0697A 0000:697A original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0697C 0000:697C original=7503 runtime CFG evidence
    JNE_SHORT loc_06981
; @0697E 0000:697E original=e94455 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06981 0000:6981 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06984 0000:6984 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06986 0000:6986 original=7503 runtime CFG evidence
    JNE_SHORT loc_0698B
; @06988 0000:6988 original=e93a55 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0698B 0000:698B original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0698F 0000:698F original=7520 runtime CFG evidence
    JNE_SHORT loc_069B1
; @06991 0000:6991 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06995 0000:6995 original=741a runtime CFG evidence
    JE_SHORT loc_069B1
; @06997 0000:6997 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0699B 0000:699B original=7414 runtime CFG evidence
    JE_SHORT loc_069B1
; @0699D 0000:699D original=2d0800 runtime CFG evidence
    sub ax, 8
; @069A0 0000:69A0 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @069A2 0000:69A2 original=7503 runtime CFG evidence
    JNE_SHORT loc_069A7
; @069A4 0000:69A4 original=e91e55 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @069A7 0000:69A7 original=2d0800 runtime CFG evidence
    sub ax, 8
; @069AA 0000:69AA original=3bc1 runtime CFG evidence
    cmp ax, cx
; @069AC 0000:69AC original=7503 runtime CFG evidence
    JNE_SHORT loc_069B1
; @069AE 0000:69AE original=e91455 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @069B1 0000:69B1 original=83c338 runtime CFG evidence
    add bx, 038h
; @069B4 0000:69B4 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @069B7 0000:69B7 original=7477 runtime CFG evidence
    JE_SHORT loc_06A30
; @069B9 0000:69B9 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @069BD 0000:69BD original=7471 runtime CFG evidence
    JE_SHORT loc_06A30
; @069BF 0000:69BF original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @069C2 0000:69C2 original=a90700 runtime CFG evidence
    test ax, 7
; @069C5 0000:69C5 original=740d runtime CFG evidence
    JE_SHORT loc_069D4
; @069C7 0000:69C7 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @069CA 0000:69CA original=050800 runtime CFG evidence
    add ax, 8
; @069CD 0000:69CD original=3bc2 runtime CFG evidence
    cmp ax, dx
; @069CF 0000:69CF original=7422 runtime CFG evidence
    JE_SHORT loc_069F3
; @069D1 0000:69D1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @069D4 0000:69D4 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @069D6 0000:69D6 original=741b runtime CFG evidence
    JE_SHORT loc_069F3
; @069D8 0000:69D8 original=2d0800 runtime CFG evidence
    sub ax, 8
; @069DB 0000:69DB original=3bc2 runtime CFG evidence
    cmp ax, dx
; @069DD 0000:69DD original=7414 runtime CFG evidence
    JE_SHORT loc_069F3
; @069DF 0000:69DF original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @069E3 0000:69E3 original=754b runtime CFG evidence
    JNE_SHORT loc_06A30
; @069E5 0000:69E5 original=2d0800 runtime CFG evidence
    sub ax, 8
; @069E8 0000:69E8 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @069EA 0000:69EA original=7407 runtime CFG evidence
    JE_SHORT loc_069F3
; @069EC 0000:69EC original=2d0800 runtime CFG evidence
    sub ax, 8
; @069EF 0000:69EF original=3bc2 runtime CFG evidence
    cmp ax, dx
; @069F1 0000:69F1 original=753d runtime CFG evidence
    JNE_SHORT loc_06A30
; @069F3 0000:69F3 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @069F6 0000:69F6 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @069F9 0000:69F9 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @069FB 0000:69FB original=7503 runtime CFG evidence
    JNE_SHORT loc_06A00
; @069FD 0000:69FD original=e9c554 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06A00 0000:6A00 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A03 0000:6A03 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06A05 0000:6A05 original=7503 runtime CFG evidence
    JNE_SHORT loc_06A0A
; @06A07 0000:6A07 original=e9bb54 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06A0A 0000:6A0A original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06A0E 0000:6A0E original=7520 runtime CFG evidence
    JNE_SHORT loc_06A30
; @06A10 0000:6A10 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06A14 0000:6A14 original=741a runtime CFG evidence
    JE_SHORT loc_06A30
; @06A16 0000:6A16 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06A1A 0000:6A1A original=7414 runtime CFG evidence
    JE_SHORT loc_06A30
; @06A1C 0000:6A1C original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A1F 0000:6A1F original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06A21 0000:6A21 original=7503 runtime CFG evidence
    JNE_SHORT loc_06A26
; @06A23 0000:6A23 original=e99f54 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06A26 0000:6A26 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A29 0000:6A29 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06A2B 0000:6A2B original=7503 runtime CFG evidence
    JNE_SHORT loc_06A30
; @06A2D 0000:6A2D original=e99554 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06A30 0000:6A30 original=83c338 runtime CFG evidence
    add bx, 038h
; @06A33 0000:6A33 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06A36 0000:6A36 original=7477 runtime CFG evidence
    JE_SHORT loc_06AAF
; @06A38 0000:6A38 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06A3C 0000:6A3C original=7471 runtime CFG evidence
    JE_SHORT loc_06AAF
; @06A3E 0000:6A3E original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06A41 0000:6A41 original=a90700 runtime CFG evidence
    test ax, 7
; @06A44 0000:6A44 original=740d runtime CFG evidence
    JE_SHORT loc_06A53
; @06A46 0000:6A46 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06A49 0000:6A49 original=050800 runtime CFG evidence
    add ax, 8
; @06A4C 0000:6A4C original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06A4E 0000:6A4E original=7422 runtime CFG evidence
    JE_SHORT loc_06A72
; @06A50 0000:6A50 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A53 0000:6A53 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06A55 0000:6A55 original=741b runtime CFG evidence
    JE_SHORT loc_06A72
; @06A57 0000:6A57 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A5A 0000:6A5A original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06A5C 0000:6A5C original=7414 runtime CFG evidence
    JE_SHORT loc_06A72
; @06A5E 0000:6A5E original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06A62 0000:6A62 original=754b runtime CFG evidence
    JNE_SHORT loc_06AAF
; @06A64 0000:6A64 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A67 0000:6A67 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06A69 0000:6A69 original=7407 runtime CFG evidence
    JE_SHORT loc_06A72
; @06A6B 0000:6A6B original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A6E 0000:6A6E original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06A70 0000:6A70 original=753d runtime CFG evidence
    JNE_SHORT loc_06AAF
; @06A72 0000:6A72 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06A75 0000:6A75 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06A78 0000:6A78 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06A7A 0000:6A7A original=7503 runtime CFG evidence
    JNE_SHORT loc_06A7F
; @06A7C 0000:6A7C original=e94654 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06A7F 0000:6A7F original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A82 0000:6A82 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06A84 0000:6A84 original=7503 runtime CFG evidence
    JNE_SHORT loc_06A89
; @06A86 0000:6A86 original=e93c54 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06A89 0000:6A89 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06A8D 0000:6A8D original=7520 runtime CFG evidence
    JNE_SHORT loc_06AAF
; @06A8F 0000:6A8F original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06A93 0000:6A93 original=741a runtime CFG evidence
    JE_SHORT loc_06AAF
; @06A95 0000:6A95 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06A99 0000:6A99 original=7414 runtime CFG evidence
    JE_SHORT loc_06AAF
; @06A9B 0000:6A9B original=2d0800 runtime CFG evidence
    sub ax, 8
; @06A9E 0000:6A9E original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06AA0 0000:6AA0 original=7503 runtime CFG evidence
    JNE_SHORT loc_06AA5
; @06AA2 0000:6AA2 original=e92054 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06AA5 0000:6AA5 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06AA8 0000:6AA8 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06AAA 0000:6AAA original=7503 runtime CFG evidence
    JNE_SHORT loc_06AAF
; @06AAC 0000:6AAC original=e91654 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06AAF 0000:6AAF original=83c338 runtime CFG evidence
    add bx, 038h
; @06AB2 0000:6AB2 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06AB5 0000:6AB5 original=7477 runtime CFG evidence
    JE_SHORT loc_06B2E
; @06AB7 0000:6AB7 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06ABB 0000:6ABB original=7471 runtime CFG evidence
    JE_SHORT loc_06B2E
; @06ABD 0000:6ABD original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06AC0 0000:6AC0 original=a90700 runtime CFG evidence
    test ax, 7
; @06AC3 0000:6AC3 original=740d runtime CFG evidence
    JE_SHORT loc_06AD2
; @06AC5 0000:6AC5 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06AC8 0000:6AC8 original=050800 runtime CFG evidence
    add ax, 8
; @06ACB 0000:6ACB original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06ACD 0000:6ACD original=7422 runtime CFG evidence
    JE_SHORT loc_06AF1
; @06ACF 0000:6ACF original=2d0800 runtime CFG evidence
    sub ax, 8
; @06AD2 0000:6AD2 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06AD4 0000:6AD4 original=741b runtime CFG evidence
    JE_SHORT loc_06AF1
; @06AD6 0000:6AD6 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06AD9 0000:6AD9 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06ADB 0000:6ADB original=7414 runtime CFG evidence
    JE_SHORT loc_06AF1
; @06ADD 0000:6ADD original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06AE1 0000:6AE1 original=754b runtime CFG evidence
    JNE_SHORT loc_06B2E
; @06AE3 0000:6AE3 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06AE6 0000:6AE6 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06AE8 0000:6AE8 original=7407 runtime CFG evidence
    JE_SHORT loc_06AF1
; @06AEA 0000:6AEA original=2d0800 runtime CFG evidence
    sub ax, 8
; @06AED 0000:6AED original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06AEF 0000:6AEF original=753d runtime CFG evidence
    JNE_SHORT loc_06B2E
; @06AF1 0000:6AF1 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06AF4 0000:6AF4 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06AF7 0000:6AF7 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06AF9 0000:6AF9 original=7503 runtime CFG evidence
    JNE_SHORT loc_06AFE
; @06AFB 0000:6AFB original=e9c753 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06AFE 0000:6AFE original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B01 0000:6B01 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06B03 0000:6B03 original=7503 runtime CFG evidence
    JNE_SHORT loc_06B08
; @06B05 0000:6B05 original=e9bd53 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06B08 0000:6B08 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06B0C 0000:6B0C original=7520 runtime CFG evidence
    JNE_SHORT loc_06B2E
; @06B0E 0000:6B0E original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06B12 0000:6B12 original=741a runtime CFG evidence
    JE_SHORT loc_06B2E
; @06B14 0000:6B14 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06B18 0000:6B18 original=7414 runtime CFG evidence
    JE_SHORT loc_06B2E
; @06B1A 0000:6B1A original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B1D 0000:6B1D original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06B1F 0000:6B1F original=7503 runtime CFG evidence
    JNE_SHORT loc_06B24
; @06B21 0000:6B21 original=e9a153 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06B24 0000:6B24 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B27 0000:6B27 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06B29 0000:6B29 original=7503 runtime CFG evidence
    JNE_SHORT loc_06B2E
; @06B2B 0000:6B2B original=e99753 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06B2E 0000:6B2E original=83c338 runtime CFG evidence
    add bx, 038h
; @06B31 0000:6B31 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06B34 0000:6B34 original=7477 runtime CFG evidence
    JE_SHORT loc_06BAD
; @06B36 0000:6B36 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06B3A 0000:6B3A original=7471 runtime CFG evidence
    JE_SHORT loc_06BAD
; @06B3C 0000:6B3C original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06B3F 0000:6B3F original=a90700 runtime CFG evidence
    test ax, 7
; @06B42 0000:6B42 original=740d runtime CFG evidence
    JE_SHORT loc_06B51
; @06B44 0000:6B44 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06B47 0000:6B47 original=050800 runtime CFG evidence
    add ax, 8
; @06B4A 0000:6B4A original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06B4C 0000:6B4C original=7422 runtime CFG evidence
    JE_SHORT loc_06B70
; @06B4E 0000:6B4E original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B51 0000:6B51 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06B53 0000:6B53 original=741b runtime CFG evidence
    JE_SHORT loc_06B70
; @06B55 0000:6B55 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B58 0000:6B58 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06B5A 0000:6B5A original=7414 runtime CFG evidence
    JE_SHORT loc_06B70
; @06B5C 0000:6B5C original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06B60 0000:6B60 original=754b runtime CFG evidence
    JNE_SHORT loc_06BAD
; @06B62 0000:6B62 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B65 0000:6B65 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06B67 0000:6B67 original=7407 runtime CFG evidence
    JE_SHORT loc_06B70
; @06B69 0000:6B69 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B6C 0000:6B6C original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06B6E 0000:6B6E original=753d runtime CFG evidence
    JNE_SHORT loc_06BAD
; @06B70 0000:6B70 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06B73 0000:6B73 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06B76 0000:6B76 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06B78 0000:6B78 original=7503 runtime CFG evidence
    JNE_SHORT loc_06B7D
; @06B7A 0000:6B7A original=e94853 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06B7D 0000:6B7D original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B80 0000:6B80 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06B82 0000:6B82 original=7503 runtime CFG evidence
    JNE_SHORT loc_06B87
; @06B84 0000:6B84 original=e93e53 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06B87 0000:6B87 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06B8B 0000:6B8B original=7520 runtime CFG evidence
    JNE_SHORT loc_06BAD
; @06B8D 0000:6B8D original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06B91 0000:6B91 original=741a runtime CFG evidence
    JE_SHORT loc_06BAD
; @06B93 0000:6B93 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06B97 0000:6B97 original=7414 runtime CFG evidence
    JE_SHORT loc_06BAD
; @06B99 0000:6B99 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06B9C 0000:6B9C original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06B9E 0000:6B9E original=7503 runtime CFG evidence
    JNE_SHORT loc_06BA3
; @06BA0 0000:6BA0 original=e92253 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06BA3 0000:6BA3 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06BA6 0000:6BA6 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06BA8 0000:6BA8 original=7503 runtime CFG evidence
    JNE_SHORT loc_06BAD
; @06BAA 0000:6BAA original=e91853 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06BAD 0000:6BAD original=83c338 runtime CFG evidence
    add bx, 038h
; @06BB0 0000:6BB0 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06BB3 0000:6BB3 original=7477 runtime CFG evidence
    JE_SHORT loc_06C2C
; @06BB5 0000:6BB5 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06BB9 0000:6BB9 original=7471 runtime CFG evidence
    JE_SHORT loc_06C2C
; @06BBB 0000:6BBB original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06BBE 0000:6BBE original=a90700 runtime CFG evidence
    test ax, 7
; @06BC1 0000:6BC1 original=740d runtime CFG evidence
    JE_SHORT loc_06BD0
; @06BC3 0000:6BC3 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06BC6 0000:6BC6 original=050800 runtime CFG evidence
    add ax, 8
; @06BC9 0000:6BC9 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06BCB 0000:6BCB original=7422 runtime CFG evidence
    JE_SHORT loc_06BEF
; @06BCD 0000:6BCD original=2d0800 runtime CFG evidence
    sub ax, 8
; @06BD0 0000:6BD0 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06BD2 0000:6BD2 original=741b runtime CFG evidence
    JE_SHORT loc_06BEF
; @06BD4 0000:6BD4 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06BD7 0000:6BD7 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06BD9 0000:6BD9 original=7414 runtime CFG evidence
    JE_SHORT loc_06BEF
; @06BDB 0000:6BDB original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06BDF 0000:6BDF original=754b runtime CFG evidence
    JNE_SHORT loc_06C2C
; @06BE1 0000:6BE1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06BE4 0000:6BE4 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06BE6 0000:6BE6 original=7407 runtime CFG evidence
    JE_SHORT loc_06BEF
; @06BE8 0000:6BE8 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06BEB 0000:6BEB original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06BED 0000:6BED original=753d runtime CFG evidence
    JNE_SHORT loc_06C2C
; @06BEF 0000:6BEF original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06BF2 0000:6BF2 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06BF5 0000:6BF5 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06BF7 0000:6BF7 original=7503 runtime CFG evidence
    JNE_SHORT loc_06BFC
; @06BF9 0000:6BF9 original=e9c952 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06BFC 0000:6BFC original=2d0800 runtime CFG evidence
    sub ax, 8
; @06BFF 0000:6BFF original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06C01 0000:6C01 original=7503 runtime CFG evidence
    JNE_SHORT loc_06C06
; @06C03 0000:6C03 original=e9bf52 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06C06 0000:6C06 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06C0A 0000:6C0A original=7520 runtime CFG evidence
    JNE_SHORT loc_06C2C
; @06C0C 0000:6C0C original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06C10 0000:6C10 original=741a runtime CFG evidence
    JE_SHORT loc_06C2C
; @06C12 0000:6C12 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06C16 0000:6C16 original=7414 runtime CFG evidence
    JE_SHORT loc_06C2C
; @06C18 0000:6C18 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C1B 0000:6C1B original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06C1D 0000:6C1D original=7503 runtime CFG evidence
    JNE_SHORT loc_06C22
; @06C1F 0000:6C1F original=e9a352 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06C22 0000:6C22 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C25 0000:6C25 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06C27 0000:6C27 original=7503 runtime CFG evidence
    JNE_SHORT loc_06C2C
; @06C29 0000:6C29 original=e99952 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06C2C 0000:6C2C original=83c338 runtime CFG evidence
    add bx, 038h
; @06C2F 0000:6C2F original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06C32 0000:6C32 original=7477 runtime CFG evidence
    JE_SHORT loc_06CAB
; @06C34 0000:6C34 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06C38 0000:6C38 original=7471 runtime CFG evidence
    JE_SHORT loc_06CAB
; @06C3A 0000:6C3A original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06C3D 0000:6C3D original=a90700 runtime CFG evidence
    test ax, 7
; @06C40 0000:6C40 original=740d runtime CFG evidence
    JE_SHORT loc_06C4F
; @06C42 0000:6C42 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06C45 0000:6C45 original=050800 runtime CFG evidence
    add ax, 8
; @06C48 0000:6C48 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06C4A 0000:6C4A original=7422 runtime CFG evidence
    JE_SHORT loc_06C6E
; @06C4C 0000:6C4C original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C4F 0000:6C4F original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06C51 0000:6C51 original=741b runtime CFG evidence
    JE_SHORT loc_06C6E
; @06C53 0000:6C53 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C56 0000:6C56 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06C58 0000:6C58 original=7414 runtime CFG evidence
    JE_SHORT loc_06C6E
; @06C5A 0000:6C5A original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06C5E 0000:6C5E original=754b runtime CFG evidence
    JNE_SHORT loc_06CAB
; @06C60 0000:6C60 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C63 0000:6C63 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06C65 0000:6C65 original=7407 runtime CFG evidence
    JE_SHORT loc_06C6E
; @06C67 0000:6C67 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C6A 0000:6C6A original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06C6C 0000:6C6C original=753d runtime CFG evidence
    JNE_SHORT loc_06CAB
; @06C6E 0000:6C6E original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06C71 0000:6C71 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06C74 0000:6C74 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06C76 0000:6C76 original=7503 runtime CFG evidence
    JNE_SHORT loc_06C7B
; @06C78 0000:6C78 original=e94a52 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06C7B 0000:6C7B original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C7E 0000:6C7E original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06C80 0000:6C80 original=7503 runtime CFG evidence
    JNE_SHORT loc_06C85
; @06C82 0000:6C82 original=e94052 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06C85 0000:6C85 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06C89 0000:6C89 original=7520 runtime CFG evidence
    JNE_SHORT loc_06CAB
; @06C8B 0000:6C8B original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06C8F 0000:6C8F original=741a runtime CFG evidence
    JE_SHORT loc_06CAB
; @06C91 0000:6C91 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06C95 0000:6C95 original=7414 runtime CFG evidence
    JE_SHORT loc_06CAB
; @06C97 0000:6C97 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06C9A 0000:6C9A original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06C9C 0000:6C9C original=7503 runtime CFG evidence
    JNE_SHORT loc_06CA1
; @06C9E 0000:6C9E original=e92452 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06CA1 0000:6CA1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06CA4 0000:6CA4 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06CA6 0000:6CA6 original=7503 runtime CFG evidence
    JNE_SHORT loc_06CAB
; @06CA8 0000:6CA8 original=e91a52 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06CAB 0000:6CAB original=83c338 runtime CFG evidence
    add bx, 038h
; @06CAE 0000:6CAE original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06CB1 0000:6CB1 original=7477 runtime CFG evidence
    JE_SHORT loc_06D2A
; @06CB3 0000:6CB3 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06CB7 0000:6CB7 original=7471 runtime CFG evidence
    JE_SHORT loc_06D2A
; @06CB9 0000:6CB9 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06CBC 0000:6CBC original=a90700 runtime CFG evidence
    test ax, 7
; @06CBF 0000:6CBF original=740d runtime CFG evidence
    JE_SHORT loc_06CCE
; @06CC1 0000:6CC1 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06CC4 0000:6CC4 original=050800 runtime CFG evidence
    add ax, 8
; @06CC7 0000:6CC7 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06CC9 0000:6CC9 original=7422 runtime CFG evidence
    JE_SHORT loc_06CED
; @06CCB 0000:6CCB original=2d0800 runtime CFG evidence
    sub ax, 8
; @06CCE 0000:6CCE original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06CD0 0000:6CD0 original=741b runtime CFG evidence
    JE_SHORT loc_06CED
; @06CD2 0000:6CD2 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06CD5 0000:6CD5 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06CD7 0000:6CD7 original=7414 runtime CFG evidence
    JE_SHORT loc_06CED
; @06CD9 0000:6CD9 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06CDD 0000:6CDD original=754b runtime CFG evidence
    JNE_SHORT loc_06D2A
; @06CDF 0000:6CDF original=2d0800 runtime CFG evidence
    sub ax, 8
; @06CE2 0000:6CE2 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06CE4 0000:6CE4 original=7407 runtime CFG evidence
    JE_SHORT loc_06CED
; @06CE6 0000:6CE6 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06CE9 0000:6CE9 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06CEB 0000:6CEB original=753d runtime CFG evidence
    JNE_SHORT loc_06D2A
; @06CED 0000:6CED original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06CF0 0000:6CF0 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06CF3 0000:6CF3 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06CF5 0000:6CF5 original=7503 runtime CFG evidence
    JNE_SHORT loc_06CFA
; @06CF7 0000:6CF7 original=e9cb51 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06CFA 0000:6CFA original=2d0800 runtime CFG evidence
    sub ax, 8
; @06CFD 0000:6CFD original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06CFF 0000:6CFF original=7503 runtime CFG evidence
    JNE_SHORT loc_06D04
; @06D01 0000:6D01 original=e9c151 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06D04 0000:6D04 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06D08 0000:6D08 original=7520 runtime CFG evidence
    JNE_SHORT loc_06D2A
; @06D0A 0000:6D0A original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06D0E 0000:6D0E original=741a runtime CFG evidence
    JE_SHORT loc_06D2A
; @06D10 0000:6D10 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06D14 0000:6D14 original=7414 runtime CFG evidence
    JE_SHORT loc_06D2A
; @06D16 0000:6D16 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D19 0000:6D19 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06D1B 0000:6D1B original=7503 runtime CFG evidence
    JNE_SHORT loc_06D20
; @06D1D 0000:6D1D original=e9a551 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06D20 0000:6D20 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D23 0000:6D23 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06D25 0000:6D25 original=7503 runtime CFG evidence
    JNE_SHORT loc_06D2A
; @06D27 0000:6D27 original=e99b51 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06D2A 0000:6D2A original=83c338 runtime CFG evidence
    add bx, 038h
; @06D2D 0000:6D2D original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06D30 0000:6D30 original=7477 runtime CFG evidence
    JE_SHORT loc_06DA9
; @06D32 0000:6D32 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06D36 0000:6D36 original=7471 runtime CFG evidence
    JE_SHORT loc_06DA9
; @06D38 0000:6D38 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06D3B 0000:6D3B original=a90700 runtime CFG evidence
    test ax, 7
; @06D3E 0000:6D3E original=740d runtime CFG evidence
    JE_SHORT loc_06D4D
; @06D40 0000:6D40 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06D43 0000:6D43 original=050800 runtime CFG evidence
    add ax, 8
; @06D46 0000:6D46 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06D48 0000:6D48 original=7422 runtime CFG evidence
    JE_SHORT loc_06D6C
; @06D4A 0000:6D4A original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D4D 0000:6D4D original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06D4F 0000:6D4F original=741b runtime CFG evidence
    JE_SHORT loc_06D6C
; @06D51 0000:6D51 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D54 0000:6D54 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06D56 0000:6D56 original=7414 runtime CFG evidence
    JE_SHORT loc_06D6C
; @06D58 0000:6D58 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06D5C 0000:6D5C original=754b runtime CFG evidence
    JNE_SHORT loc_06DA9
; @06D5E 0000:6D5E original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D61 0000:6D61 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06D63 0000:6D63 original=7407 runtime CFG evidence
    JE_SHORT loc_06D6C
; @06D65 0000:6D65 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D68 0000:6D68 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06D6A 0000:6D6A original=753d runtime CFG evidence
    JNE_SHORT loc_06DA9
; @06D6C 0000:6D6C original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06D6F 0000:6D6F original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06D72 0000:6D72 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06D74 0000:6D74 original=7503 runtime CFG evidence
    JNE_SHORT loc_06D79
; @06D76 0000:6D76 original=e94c51 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06D79 0000:6D79 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D7C 0000:6D7C original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06D7E 0000:6D7E original=7503 runtime CFG evidence
    JNE_SHORT loc_06D83
; @06D80 0000:6D80 original=e94251 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06D83 0000:6D83 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06D87 0000:6D87 original=7520 runtime CFG evidence
    JNE_SHORT loc_06DA9
; @06D89 0000:6D89 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06D8D 0000:6D8D original=741a runtime CFG evidence
    JE_SHORT loc_06DA9
; @06D8F 0000:6D8F original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06D93 0000:6D93 original=7414 runtime CFG evidence
    JE_SHORT loc_06DA9
; @06D95 0000:6D95 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06D98 0000:6D98 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06D9A 0000:6D9A original=7503 runtime CFG evidence
    JNE_SHORT loc_06D9F
; @06D9C 0000:6D9C original=e92651 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06D9F 0000:6D9F original=2d0800 runtime CFG evidence
    sub ax, 8
; @06DA2 0000:6DA2 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06DA4 0000:6DA4 original=7503 runtime CFG evidence
    JNE_SHORT loc_06DA9
; @06DA6 0000:6DA6 original=e91c51 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06DA9 0000:6DA9 original=83c338 runtime CFG evidence
    add bx, 038h
; @06DAC 0000:6DAC original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06DAF 0000:6DAF original=7477 runtime CFG evidence
    JE_SHORT loc_06E28
; @06DB1 0000:6DB1 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06DB5 0000:6DB5 original=7471 runtime CFG evidence
    JE_SHORT loc_06E28
; @06DB7 0000:6DB7 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06DBA 0000:6DBA original=a90700 runtime CFG evidence
    test ax, 7
; @06DBD 0000:6DBD original=740d runtime CFG evidence
    JE_SHORT loc_06DCC
; @06DBF 0000:6DBF original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06DC2 0000:6DC2 original=050800 runtime CFG evidence
    add ax, 8
; @06DC5 0000:6DC5 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06DC7 0000:6DC7 original=7422 runtime CFG evidence
    JE_SHORT loc_06DEB
; @06DC9 0000:6DC9 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06DCC 0000:6DCC original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06DCE 0000:6DCE original=741b runtime CFG evidence
    JE_SHORT loc_06DEB
; @06DD0 0000:6DD0 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06DD3 0000:6DD3 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06DD5 0000:6DD5 original=7414 runtime CFG evidence
    JE_SHORT loc_06DEB
; @06DD7 0000:6DD7 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06DDB 0000:6DDB original=754b runtime CFG evidence
    JNE_SHORT loc_06E28
; @06DDD 0000:6DDD original=2d0800 runtime CFG evidence
    sub ax, 8
; @06DE0 0000:6DE0 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06DE2 0000:6DE2 original=7407 runtime CFG evidence
    JE_SHORT loc_06DEB
; @06DE4 0000:6DE4 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06DE7 0000:6DE7 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06DE9 0000:6DE9 original=753d runtime CFG evidence
    JNE_SHORT loc_06E28
; @06DEB 0000:6DEB original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06DEE 0000:6DEE original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06DF1 0000:6DF1 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06DF3 0000:6DF3 original=7503 runtime CFG evidence
    JNE_SHORT loc_06DF8
; @06DF5 0000:6DF5 original=e9cd50 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06DF8 0000:6DF8 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06DFB 0000:6DFB original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06DFD 0000:6DFD original=7503 runtime CFG evidence
    JNE_SHORT loc_06E02
; @06DFF 0000:6DFF original=e9c350 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06E02 0000:6E02 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06E06 0000:6E06 original=7520 runtime CFG evidence
    JNE_SHORT loc_06E28
; @06E08 0000:6E08 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06E0C 0000:6E0C original=741a runtime CFG evidence
    JE_SHORT loc_06E28
; @06E0E 0000:6E0E original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06E12 0000:6E12 original=7414 runtime CFG evidence
    JE_SHORT loc_06E28
; @06E14 0000:6E14 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E17 0000:6E17 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06E19 0000:6E19 original=7503 runtime CFG evidence
    JNE_SHORT loc_06E1E
; @06E1B 0000:6E1B original=e9a750 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06E1E 0000:6E1E original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E21 0000:6E21 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06E23 0000:6E23 original=7503 runtime CFG evidence
    JNE_SHORT loc_06E28
; @06E25 0000:6E25 original=e99d50 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06E28 0000:6E28 original=83c338 runtime CFG evidence
    add bx, 038h
; @06E2B 0000:6E2B original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06E2E 0000:6E2E original=7477 runtime CFG evidence
    JE_SHORT loc_06EA7
; @06E30 0000:6E30 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06E34 0000:6E34 original=7471 runtime CFG evidence
    JE_SHORT loc_06EA7
; @06E36 0000:6E36 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06E39 0000:6E39 original=a90700 runtime CFG evidence
    test ax, 7
; @06E3C 0000:6E3C original=740d runtime CFG evidence
    JE_SHORT loc_06E4B
; @06E3E 0000:6E3E original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06E41 0000:6E41 original=050800 runtime CFG evidence
    add ax, 8
; @06E44 0000:6E44 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06E46 0000:6E46 original=7422 runtime CFG evidence
    JE_SHORT loc_06E6A
; @06E48 0000:6E48 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E4B 0000:6E4B original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06E4D 0000:6E4D original=741b runtime CFG evidence
    JE_SHORT loc_06E6A
; @06E4F 0000:6E4F original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E52 0000:6E52 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06E54 0000:6E54 original=7414 runtime CFG evidence
    JE_SHORT loc_06E6A
; @06E56 0000:6E56 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06E5A 0000:6E5A original=754b runtime CFG evidence
    JNE_SHORT loc_06EA7
; @06E5C 0000:6E5C original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E5F 0000:6E5F original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06E61 0000:6E61 original=7407 runtime CFG evidence
    JE_SHORT loc_06E6A
; @06E63 0000:6E63 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E66 0000:6E66 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06E68 0000:6E68 original=753d runtime CFG evidence
    JNE_SHORT loc_06EA7
; @06E6A 0000:6E6A original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06E6D 0000:6E6D original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06E70 0000:6E70 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06E72 0000:6E72 original=7503 runtime CFG evidence
    JNE_SHORT loc_06E77
; @06E74 0000:6E74 original=e94e50 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06E77 0000:6E77 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E7A 0000:6E7A original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06E7C 0000:6E7C original=7503 runtime CFG evidence
    JNE_SHORT loc_06E81
; @06E7E 0000:6E7E original=e94450 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06E81 0000:6E81 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06E85 0000:6E85 original=7520 runtime CFG evidence
    JNE_SHORT loc_06EA7
; @06E87 0000:6E87 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06E8B 0000:6E8B original=741a runtime CFG evidence
    JE_SHORT loc_06EA7
; @06E8D 0000:6E8D original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06E91 0000:6E91 original=7414 runtime CFG evidence
    JE_SHORT loc_06EA7
; @06E93 0000:6E93 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06E96 0000:6E96 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06E98 0000:6E98 original=7503 runtime CFG evidence
    JNE_SHORT loc_06E9D
; @06E9A 0000:6E9A original=e92850 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06E9D 0000:6E9D original=2d0800 runtime CFG evidence
    sub ax, 8
; @06EA0 0000:6EA0 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06EA2 0000:6EA2 original=7503 runtime CFG evidence
    JNE_SHORT loc_06EA7
; @06EA4 0000:6EA4 original=e91e50 runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06EA7 0000:6EA7 original=83c338 runtime CFG evidence
    add bx, 038h
; @06EAA 0000:6EAA original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06EAD 0000:6EAD original=7477 runtime CFG evidence
    JE_SHORT loc_06F26
; @06EAF 0000:6EAF original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06EB3 0000:6EB3 original=7471 runtime CFG evidence
    JE_SHORT loc_06F26
; @06EB5 0000:6EB5 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06EB8 0000:6EB8 original=a90700 runtime CFG evidence
    test ax, 7
; @06EBB 0000:6EBB original=740d runtime CFG evidence
    JE_SHORT loc_06ECA
; @06EBD 0000:6EBD original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06EC0 0000:6EC0 original=050800 runtime CFG evidence
    add ax, 8
; @06EC3 0000:6EC3 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06EC5 0000:6EC5 original=7422 runtime CFG evidence
    JE_SHORT loc_06EE9
; @06EC7 0000:6EC7 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06ECA 0000:6ECA original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06ECC 0000:6ECC original=741b runtime CFG evidence
    JE_SHORT loc_06EE9
; @06ECE 0000:6ECE original=2d0800 runtime CFG evidence
    sub ax, 8
; @06ED1 0000:6ED1 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06ED3 0000:6ED3 original=7414 runtime CFG evidence
    JE_SHORT loc_06EE9
; @06ED5 0000:6ED5 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06ED9 0000:6ED9 original=754b runtime CFG evidence
    JNE_SHORT loc_06F26
; @06EDB 0000:6EDB original=2d0800 runtime CFG evidence
    sub ax, 8
; @06EDE 0000:6EDE original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06EE0 0000:6EE0 original=7407 runtime CFG evidence
    JE_SHORT loc_06EE9
; @06EE2 0000:6EE2 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06EE5 0000:6EE5 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06EE7 0000:6EE7 original=753d runtime CFG evidence
    JNE_SHORT loc_06F26
; @06EE9 0000:6EE9 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06EEC 0000:6EEC original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06EEF 0000:6EEF original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06EF1 0000:6EF1 original=7503 runtime CFG evidence
    JNE_SHORT loc_06EF6
; @06EF3 0000:6EF3 original=e9cf4f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06EF6 0000:6EF6 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06EF9 0000:6EF9 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06EFB 0000:6EFB original=7503 runtime CFG evidence
    JNE_SHORT loc_06F00
; @06EFD 0000:6EFD original=e9c54f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06F00 0000:6F00 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06F04 0000:6F04 original=7520 runtime CFG evidence
    JNE_SHORT loc_06F26
; @06F06 0000:6F06 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06F0A 0000:6F0A original=741a runtime CFG evidence
    JE_SHORT loc_06F26
; @06F0C 0000:6F0C original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06F10 0000:6F10 original=7414 runtime CFG evidence
    JE_SHORT loc_06F26
; @06F12 0000:6F12 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F15 0000:6F15 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06F17 0000:6F17 original=7503 runtime CFG evidence
    JNE_SHORT loc_06F1C
; @06F19 0000:6F19 original=e9a94f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06F1C 0000:6F1C original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F1F 0000:6F1F original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06F21 0000:6F21 original=7503 runtime CFG evidence
    JNE_SHORT loc_06F26
; @06F23 0000:6F23 original=e99f4f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06F26 0000:6F26 original=83c338 runtime CFG evidence
    add bx, 038h
; @06F29 0000:6F29 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06F2C 0000:6F2C original=7477 runtime CFG evidence
    JE_SHORT loc_06FA5
; @06F2E 0000:6F2E original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06F32 0000:6F32 original=7471 runtime CFG evidence
    JE_SHORT loc_06FA5
; @06F34 0000:6F34 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06F37 0000:6F37 original=a90700 runtime CFG evidence
    test ax, 7
; @06F3A 0000:6F3A original=740d runtime CFG evidence
    JE_SHORT loc_06F49
; @06F3C 0000:6F3C original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06F3F 0000:6F3F original=050800 runtime CFG evidence
    add ax, 8
; @06F42 0000:6F42 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06F44 0000:6F44 original=7422 runtime CFG evidence
    JE_SHORT loc_06F68
; @06F46 0000:6F46 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F49 0000:6F49 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06F4B 0000:6F4B original=741b runtime CFG evidence
    JE_SHORT loc_06F68
; @06F4D 0000:6F4D original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F50 0000:6F50 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06F52 0000:6F52 original=7414 runtime CFG evidence
    JE_SHORT loc_06F68
; @06F54 0000:6F54 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06F58 0000:6F58 original=754b runtime CFG evidence
    JNE_SHORT loc_06FA5
; @06F5A 0000:6F5A original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F5D 0000:6F5D original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06F5F 0000:6F5F original=7407 runtime CFG evidence
    JE_SHORT loc_06F68
; @06F61 0000:6F61 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F64 0000:6F64 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06F66 0000:6F66 original=753d runtime CFG evidence
    JNE_SHORT loc_06FA5
; @06F68 0000:6F68 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06F6B 0000:6F6B original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06F6E 0000:6F6E original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06F70 0000:6F70 original=7503 runtime CFG evidence
    JNE_SHORT loc_06F75
; @06F72 0000:6F72 original=e9504f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06F75 0000:6F75 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F78 0000:6F78 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06F7A 0000:6F7A original=7503 runtime CFG evidence
    JNE_SHORT loc_06F7F
; @06F7C 0000:6F7C original=e9464f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06F7F 0000:6F7F original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06F83 0000:6F83 original=7520 runtime CFG evidence
    JNE_SHORT loc_06FA5
; @06F85 0000:6F85 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @06F89 0000:6F89 original=741a runtime CFG evidence
    JE_SHORT loc_06FA5
; @06F8B 0000:6F8B original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @06F8F 0000:6F8F original=7414 runtime CFG evidence
    JE_SHORT loc_06FA5
; @06F91 0000:6F91 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F94 0000:6F94 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06F96 0000:6F96 original=7503 runtime CFG evidence
    JNE_SHORT loc_06F9B
; @06F98 0000:6F98 original=e92a4f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06F9B 0000:6F9B original=2d0800 runtime CFG evidence
    sub ax, 8
; @06F9E 0000:6F9E original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06FA0 0000:6FA0 original=7503 runtime CFG evidence
    JNE_SHORT loc_06FA5
; @06FA2 0000:6FA2 original=e9204f runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06FA5 0000:6FA5 original=83c338 runtime CFG evidence
    add bx, 038h
; @06FA8 0000:6FA8 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @06FAB 0000:6FAB original=7477 runtime CFG evidence
    JE_SHORT loc_07024
; @06FAD 0000:6FAD original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @06FB1 0000:6FB1 original=7471 runtime CFG evidence
    JE_SHORT loc_07024
; @06FB3 0000:6FB3 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @06FB6 0000:6FB6 original=a90700 runtime CFG evidence
    test ax, 7
; @06FB9 0000:6FB9 original=740d runtime CFG evidence
    JE_SHORT loc_06FC8
; @06FBB 0000:6FBB original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06FBE 0000:6FBE original=050800 runtime CFG evidence
    add ax, 8
; @06FC1 0000:6FC1 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06FC3 0000:6FC3 original=7422 runtime CFG evidence
    JE_SHORT loc_06FE7
; @06FC5 0000:6FC5 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06FC8 0000:6FC8 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06FCA 0000:6FCA original=741b runtime CFG evidence
    JE_SHORT loc_06FE7
; @06FCC 0000:6FCC original=2d0800 runtime CFG evidence
    sub ax, 8
; @06FCF 0000:6FCF original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06FD1 0000:6FD1 original=7414 runtime CFG evidence
    JE_SHORT loc_06FE7
; @06FD3 0000:6FD3 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @06FD7 0000:6FD7 original=754b runtime CFG evidence
    JNE_SHORT loc_07024
; @06FD9 0000:6FD9 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06FDC 0000:6FDC original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06FDE 0000:6FDE original=7407 runtime CFG evidence
    JE_SHORT loc_06FE7
; @06FE0 0000:6FE0 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06FE3 0000:6FE3 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @06FE5 0000:6FE5 original=753d runtime CFG evidence
    JNE_SHORT loc_07024
; @06FE7 0000:6FE7 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @06FEA 0000:6FEA original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @06FED 0000:6FED original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06FEF 0000:6FEF original=7503 runtime CFG evidence
    JNE_SHORT loc_06FF4
; @06FF1 0000:6FF1 original=e9d14e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06FF4 0000:6FF4 original=2d0800 runtime CFG evidence
    sub ax, 8
; @06FF7 0000:6FF7 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @06FF9 0000:6FF9 original=7503 runtime CFG evidence
    JNE_SHORT loc_06FFE
; @06FFB 0000:6FFB original=e9c74e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @06FFE 0000:6FFE original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @07002 0000:7002 original=7520 runtime CFG evidence
    JNE_SHORT loc_07024
; @07004 0000:7004 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07008 0000:7008 original=741a runtime CFG evidence
    JE_SHORT loc_07024
; @0700A 0000:700A original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0700E 0000:700E original=7414 runtime CFG evidence
    JE_SHORT loc_07024
; @07010 0000:7010 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07013 0000:7013 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07015 0000:7015 original=7503 runtime CFG evidence
    JNE_SHORT loc_0701A
; @07017 0000:7017 original=e9ab4e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0701A 0000:701A original=2d0800 runtime CFG evidence
    sub ax, 8
; @0701D 0000:701D original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0701F 0000:701F original=7503 runtime CFG evidence
    JNE_SHORT loc_07024
; @07021 0000:7021 original=e9a14e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07024 0000:7024 original=83c338 runtime CFG evidence
    add bx, 038h
; @07027 0000:7027 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @0702A 0000:702A original=7477 runtime CFG evidence
    JE_SHORT loc_070A3
; @0702C 0000:702C original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @07030 0000:7030 original=7471 runtime CFG evidence
    JE_SHORT loc_070A3
; @07032 0000:7032 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @07035 0000:7035 original=a90700 runtime CFG evidence
    test ax, 7
; @07038 0000:7038 original=740d runtime CFG evidence
    JE_SHORT loc_07047
; @0703A 0000:703A original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0703D 0000:703D original=050800 runtime CFG evidence
    add ax, 8
; @07040 0000:7040 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07042 0000:7042 original=7422 runtime CFG evidence
    JE_SHORT loc_07066
; @07044 0000:7044 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07047 0000:7047 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07049 0000:7049 original=741b runtime CFG evidence
    JE_SHORT loc_07066
; @0704B 0000:704B original=2d0800 runtime CFG evidence
    sub ax, 8
; @0704E 0000:704E original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07050 0000:7050 original=7414 runtime CFG evidence
    JE_SHORT loc_07066
; @07052 0000:7052 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @07056 0000:7056 original=754b runtime CFG evidence
    JNE_SHORT loc_070A3
; @07058 0000:7058 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0705B 0000:705B original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0705D 0000:705D original=7407 runtime CFG evidence
    JE_SHORT loc_07066
; @0705F 0000:705F original=2d0800 runtime CFG evidence
    sub ax, 8
; @07062 0000:7062 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07064 0000:7064 original=753d runtime CFG evidence
    JNE_SHORT loc_070A3
; @07066 0000:7066 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @07069 0000:7069 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0706C 0000:706C original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0706E 0000:706E original=7503 runtime CFG evidence
    JNE_SHORT loc_07073
; @07070 0000:7070 original=e9524e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07073 0000:7073 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07076 0000:7076 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07078 0000:7078 original=7503 runtime CFG evidence
    JNE_SHORT loc_0707D
; @0707A 0000:707A original=e9484e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0707D 0000:707D original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @07081 0000:7081 original=7520 runtime CFG evidence
    JNE_SHORT loc_070A3
; @07083 0000:7083 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07087 0000:7087 original=741a runtime CFG evidence
    JE_SHORT loc_070A3
; @07089 0000:7089 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0708D 0000:708D original=7414 runtime CFG evidence
    JE_SHORT loc_070A3
; @0708F 0000:708F original=2d0800 runtime CFG evidence
    sub ax, 8
; @07092 0000:7092 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07094 0000:7094 original=7503 runtime CFG evidence
    JNE_SHORT loc_07099
; @07096 0000:7096 original=e92c4e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07099 0000:7099 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0709C 0000:709C original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0709E 0000:709E original=7503 runtime CFG evidence
    JNE_SHORT loc_070A3
; @070A0 0000:70A0 original=e9224e runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @070A3 0000:70A3 original=83c338 runtime CFG evidence
    add bx, 038h
; @070A6 0000:70A6 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @070A9 0000:70A9 original=7477 runtime CFG evidence
    JE_SHORT loc_07122
; @070AB 0000:70AB original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @070AF 0000:70AF original=7471 runtime CFG evidence
    JE_SHORT loc_07122
; @070B1 0000:70B1 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @070B4 0000:70B4 original=a90700 runtime CFG evidence
    test ax, 7
; @070B7 0000:70B7 original=740d runtime CFG evidence
    JE_SHORT loc_070C6
; @070B9 0000:70B9 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @070BC 0000:70BC original=050800 runtime CFG evidence
    add ax, 8
; @070BF 0000:70BF original=3bc2 runtime CFG evidence
    cmp ax, dx
; @070C1 0000:70C1 original=7422 runtime CFG evidence
    JE_SHORT loc_070E5
; @070C3 0000:70C3 original=2d0800 runtime CFG evidence
    sub ax, 8
; @070C6 0000:70C6 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @070C8 0000:70C8 original=741b runtime CFG evidence
    JE_SHORT loc_070E5
; @070CA 0000:70CA original=2d0800 runtime CFG evidence
    sub ax, 8
; @070CD 0000:70CD original=3bc2 runtime CFG evidence
    cmp ax, dx
; @070CF 0000:70CF original=7414 runtime CFG evidence
    JE_SHORT loc_070E5
; @070D1 0000:70D1 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @070D5 0000:70D5 original=754b runtime CFG evidence
    JNE_SHORT loc_07122
; @070D7 0000:70D7 original=2d0800 runtime CFG evidence
    sub ax, 8
; @070DA 0000:70DA original=3bc2 runtime CFG evidence
    cmp ax, dx
; @070DC 0000:70DC original=7407 runtime CFG evidence
    JE_SHORT loc_070E5
; @070DE 0000:70DE original=2d0800 runtime CFG evidence
    sub ax, 8
; @070E1 0000:70E1 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @070E3 0000:70E3 original=753d runtime CFG evidence
    JNE_SHORT loc_07122
; @070E5 0000:70E5 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @070E8 0000:70E8 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @070EB 0000:70EB original=3bc1 runtime CFG evidence
    cmp ax, cx
; @070ED 0000:70ED original=7503 runtime CFG evidence
    JNE_SHORT loc_070F2
; @070EF 0000:70EF original=e9d34d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @070F2 0000:70F2 original=2d0800 runtime CFG evidence
    sub ax, 8
; @070F5 0000:70F5 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @070F7 0000:70F7 original=7503 runtime CFG evidence
    JNE_SHORT loc_070FC
; @070F9 0000:70F9 original=e9c94d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @070FC 0000:70FC original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @07100 0000:7100 original=7520 runtime CFG evidence
    JNE_SHORT loc_07122
; @07102 0000:7102 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07106 0000:7106 original=741a runtime CFG evidence
    JE_SHORT loc_07122
; @07108 0000:7108 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0710C 0000:710C original=7414 runtime CFG evidence
    JE_SHORT loc_07122
; @0710E 0000:710E original=2d0800 runtime CFG evidence
    sub ax, 8
; @07111 0000:7111 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07113 0000:7113 original=7503 runtime CFG evidence
    JNE_SHORT loc_07118
; @07115 0000:7115 original=e9ad4d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07118 0000:7118 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0711B 0000:711B original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0711D 0000:711D original=7503 runtime CFG evidence
    JNE_SHORT loc_07122
; @0711F 0000:711F original=e9a34d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07122 0000:7122 original=83c338 runtime CFG evidence
    add bx, 038h
; @07125 0000:7125 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @07128 0000:7128 original=7477 runtime CFG evidence
    JE_SHORT loc_071A1
; @0712A 0000:712A original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @0712E 0000:712E original=7471 runtime CFG evidence
    JE_SHORT loc_071A1
; @07130 0000:7130 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @07133 0000:7133 original=a90700 runtime CFG evidence
    test ax, 7
; @07136 0000:7136 original=740d runtime CFG evidence
    JE_SHORT loc_07145
; @07138 0000:7138 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0713B 0000:713B original=050800 runtime CFG evidence
    add ax, 8
; @0713E 0000:713E original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07140 0000:7140 original=7422 runtime CFG evidence
    JE_SHORT loc_07164
; @07142 0000:7142 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07145 0000:7145 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07147 0000:7147 original=741b runtime CFG evidence
    JE_SHORT loc_07164
; @07149 0000:7149 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0714C 0000:714C original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0714E 0000:714E original=7414 runtime CFG evidence
    JE_SHORT loc_07164
; @07150 0000:7150 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @07154 0000:7154 original=754b runtime CFG evidence
    JNE_SHORT loc_071A1
; @07156 0000:7156 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07159 0000:7159 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0715B 0000:715B original=7407 runtime CFG evidence
    JE_SHORT loc_07164
; @0715D 0000:715D original=2d0800 runtime CFG evidence
    sub ax, 8
; @07160 0000:7160 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07162 0000:7162 original=753d runtime CFG evidence
    JNE_SHORT loc_071A1
; @07164 0000:7164 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @07167 0000:7167 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @0716A 0000:716A original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0716C 0000:716C original=7503 runtime CFG evidence
    JNE_SHORT loc_07171
; @0716E 0000:716E original=e9544d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07171 0000:7171 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07174 0000:7174 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07176 0000:7176 original=7503 runtime CFG evidence
    JNE_SHORT loc_0717B
; @07178 0000:7178 original=e94a4d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0717B 0000:717B original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0717F 0000:717F original=7520 runtime CFG evidence
    JNE_SHORT loc_071A1
; @07181 0000:7181 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07185 0000:7185 original=741a runtime CFG evidence
    JE_SHORT loc_071A1
; @07187 0000:7187 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0718B 0000:718B original=7414 runtime CFG evidence
    JE_SHORT loc_071A1
; @0718D 0000:718D original=2d0800 runtime CFG evidence
    sub ax, 8
; @07190 0000:7190 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07192 0000:7192 original=7503 runtime CFG evidence
    JNE_SHORT loc_07197
; @07194 0000:7194 original=e92e4d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07197 0000:7197 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0719A 0000:719A original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0719C 0000:719C original=7503 runtime CFG evidence
    JNE_SHORT loc_071A1
; @0719E 0000:719E original=e9244d runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @071A1 0000:71A1 original=83c338 runtime CFG evidence
    add bx, 038h
; @071A4 0000:71A4 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @071A7 0000:71A7 original=7477 runtime CFG evidence
    JE_SHORT loc_07220
; @071A9 0000:71A9 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @071AD 0000:71AD original=7471 runtime CFG evidence
    JE_SHORT loc_07220
; @071AF 0000:71AF original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @071B2 0000:71B2 original=a90700 runtime CFG evidence
    test ax, 7
; @071B5 0000:71B5 original=740d runtime CFG evidence
    JE_SHORT loc_071C4
; @071B7 0000:71B7 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @071BA 0000:71BA original=050800 runtime CFG evidence
    add ax, 8
; @071BD 0000:71BD original=3bc2 runtime CFG evidence
    cmp ax, dx
; @071BF 0000:71BF original=7422 runtime CFG evidence
    JE_SHORT loc_071E3
; @071C1 0000:71C1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @071C4 0000:71C4 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @071C6 0000:71C6 original=741b runtime CFG evidence
    JE_SHORT loc_071E3
; @071C8 0000:71C8 original=2d0800 runtime CFG evidence
    sub ax, 8
; @071CB 0000:71CB original=3bc2 runtime CFG evidence
    cmp ax, dx
; @071CD 0000:71CD original=7414 runtime CFG evidence
    JE_SHORT loc_071E3
; @071CF 0000:71CF original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @071D3 0000:71D3 original=754b runtime CFG evidence
    JNE_SHORT loc_07220
; @071D5 0000:71D5 original=2d0800 runtime CFG evidence
    sub ax, 8
; @071D8 0000:71D8 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @071DA 0000:71DA original=7407 runtime CFG evidence
    JE_SHORT loc_071E3
; @071DC 0000:71DC original=2d0800 runtime CFG evidence
    sub ax, 8
; @071DF 0000:71DF original=3bc2 runtime CFG evidence
    cmp ax, dx
; @071E1 0000:71E1 original=753d runtime CFG evidence
    JNE_SHORT loc_07220
; @071E3 0000:71E3 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @071E6 0000:71E6 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @071E9 0000:71E9 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @071EB 0000:71EB original=7503 runtime CFG evidence
    JNE_SHORT loc_071F0
; @071ED 0000:71ED original=e9d54c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @071F0 0000:71F0 original=2d0800 runtime CFG evidence
    sub ax, 8
; @071F3 0000:71F3 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @071F5 0000:71F5 original=7503 runtime CFG evidence
    JNE_SHORT loc_071FA
; @071F7 0000:71F7 original=e9cb4c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @071FA 0000:71FA original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @071FE 0000:71FE original=7520 runtime CFG evidence
    JNE_SHORT loc_07220
; @07200 0000:7200 original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07204 0000:7204 original=741a runtime CFG evidence
    JE_SHORT loc_07220
; @07206 0000:7206 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @0720A 0000:720A original=7414 runtime CFG evidence
    JE_SHORT loc_07220
; @0720C 0000:720C original=2d0800 runtime CFG evidence
    sub ax, 8
; @0720F 0000:720F original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07211 0000:7211 original=7503 runtime CFG evidence
    JNE_SHORT loc_07216
; @07213 0000:7213 original=e9af4c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07216 0000:7216 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07219 0000:7219 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0721B 0000:721B original=7503 runtime CFG evidence
    JNE_SHORT loc_07220
; @0721D 0000:721D original=e9a54c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07220 0000:7220 original=83c338 runtime CFG evidence
    add bx, 038h
; @07223 0000:7223 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @07226 0000:7226 original=7477 runtime CFG evidence
    JE_SHORT loc_0729F
; @07228 0000:7228 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @0722C 0000:722C original=7471 runtime CFG evidence
    JE_SHORT loc_0729F
; @0722E 0000:722E original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @07231 0000:7231 original=a90700 runtime CFG evidence
    test ax, 7
; @07234 0000:7234 original=740d runtime CFG evidence
    JE_SHORT loc_07243
; @07236 0000:7236 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @07239 0000:7239 original=050800 runtime CFG evidence
    add ax, 8
; @0723C 0000:723C original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0723E 0000:723E original=7422 runtime CFG evidence
    JE_SHORT loc_07262
; @07240 0000:7240 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07243 0000:7243 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07245 0000:7245 original=741b runtime CFG evidence
    JE_SHORT loc_07262
; @07247 0000:7247 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0724A 0000:724A original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0724C 0000:724C original=7414 runtime CFG evidence
    JE_SHORT loc_07262
; @0724E 0000:724E original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @07252 0000:7252 original=754b runtime CFG evidence
    JNE_SHORT loc_0729F
; @07254 0000:7254 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07257 0000:7257 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07259 0000:7259 original=7407 runtime CFG evidence
    JE_SHORT loc_07262
; @0725B 0000:725B original=2d0800 runtime CFG evidence
    sub ax, 8
; @0725E 0000:725E original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07260 0000:7260 original=753d runtime CFG evidence
    JNE_SHORT loc_0729F
; @07262 0000:7262 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @07265 0000:7265 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @07268 0000:7268 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0726A 0000:726A original=7503 runtime CFG evidence
    JNE_SHORT loc_0726F
; @0726C 0000:726C original=e9564c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0726F 0000:726F original=2d0800 runtime CFG evidence
    sub ax, 8
; @07272 0000:7272 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07274 0000:7274 original=7503 runtime CFG evidence
    JNE_SHORT loc_07279
; @07276 0000:7276 original=e94c4c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07279 0000:7279 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0727D 0000:727D original=7520 runtime CFG evidence
    JNE_SHORT loc_0729F
; @0727F 0000:727F original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07283 0000:7283 original=741a runtime CFG evidence
    JE_SHORT loc_0729F
; @07285 0000:7285 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @07289 0000:7289 original=7414 runtime CFG evidence
    JE_SHORT loc_0729F
; @0728B 0000:728B original=2d0800 runtime CFG evidence
    sub ax, 8
; @0728E 0000:728E original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07290 0000:7290 original=7503 runtime CFG evidence
    JNE_SHORT loc_07295
; @07292 0000:7292 original=e9304c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07295 0000:7295 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07298 0000:7298 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0729A 0000:729A original=7503 runtime CFG evidence
    JNE_SHORT loc_0729F
; @0729C 0000:729C original=e9264c runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0729F 0000:729F original=83c338 runtime CFG evidence
    add bx, 038h
; @072A2 0000:72A2 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @072A5 0000:72A5 original=7477 runtime CFG evidence
    JE_SHORT loc_0731E
; @072A7 0000:72A7 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @072AB 0000:72AB original=7471 runtime CFG evidence
    JE_SHORT loc_0731E
; @072AD 0000:72AD original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @072B0 0000:72B0 original=a90700 runtime CFG evidence
    test ax, 7
; @072B3 0000:72B3 original=740d runtime CFG evidence
    JE_SHORT loc_072C2
; @072B5 0000:72B5 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @072B8 0000:72B8 original=050800 runtime CFG evidence
    add ax, 8
; @072BB 0000:72BB original=3bc2 runtime CFG evidence
    cmp ax, dx
; @072BD 0000:72BD original=7422 runtime CFG evidence
    JE_SHORT loc_072E1
; @072BF 0000:72BF original=2d0800 runtime CFG evidence
    sub ax, 8
; @072C2 0000:72C2 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @072C4 0000:72C4 original=741b runtime CFG evidence
    JE_SHORT loc_072E1
; @072C6 0000:72C6 original=2d0800 runtime CFG evidence
    sub ax, 8
; @072C9 0000:72C9 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @072CB 0000:72CB original=7414 runtime CFG evidence
    JE_SHORT loc_072E1
; @072CD 0000:72CD original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @072D1 0000:72D1 original=754b runtime CFG evidence
    JNE_SHORT loc_0731E
; @072D3 0000:72D3 original=2d0800 runtime CFG evidence
    sub ax, 8
; @072D6 0000:72D6 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @072D8 0000:72D8 original=7407 runtime CFG evidence
    JE_SHORT loc_072E1
; @072DA 0000:72DA original=2d0800 runtime CFG evidence
    sub ax, 8
; @072DD 0000:72DD original=3bc2 runtime CFG evidence
    cmp ax, dx
; @072DF 0000:72DF original=753d runtime CFG evidence
    JNE_SHORT loc_0731E
; @072E1 0000:72E1 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @072E4 0000:72E4 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @072E7 0000:72E7 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @072E9 0000:72E9 original=7503 runtime CFG evidence
    JNE_SHORT loc_072EE
; @072EB 0000:72EB original=e9d74b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @072EE 0000:72EE original=2d0800 runtime CFG evidence
    sub ax, 8
; @072F1 0000:72F1 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @072F3 0000:72F3 original=7503 runtime CFG evidence
    JNE_SHORT loc_072F8
; @072F5 0000:72F5 original=e9cd4b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @072F8 0000:72F8 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @072FC 0000:72FC original=7520 runtime CFG evidence
    JNE_SHORT loc_0731E
; @072FE 0000:72FE original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07302 0000:7302 original=741a runtime CFG evidence
    JE_SHORT loc_0731E
; @07304 0000:7304 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @07308 0000:7308 original=7414 runtime CFG evidence
    JE_SHORT loc_0731E
; @0730A 0000:730A original=2d0800 runtime CFG evidence
    sub ax, 8
; @0730D 0000:730D original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0730F 0000:730F original=7503 runtime CFG evidence
    JNE_SHORT loc_07314
; @07311 0000:7311 original=e9b14b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07314 0000:7314 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07317 0000:7317 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07319 0000:7319 original=7503 runtime CFG evidence
    JNE_SHORT loc_0731E
; @0731B 0000:731B original=e9a74b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0731E 0000:731E original=83c338 runtime CFG evidence
    add bx, 038h
; @07321 0000:7321 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @07324 0000:7324 original=7477 runtime CFG evidence
    JE_SHORT loc_0739D
; @07326 0000:7326 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @0732A 0000:732A original=7471 runtime CFG evidence
    JE_SHORT loc_0739D
; @0732C 0000:732C original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @0732F 0000:732F original=a90700 runtime CFG evidence
    test ax, 7
; @07332 0000:7332 original=740d runtime CFG evidence
    JE_SHORT loc_07341
; @07334 0000:7334 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @07337 0000:7337 original=050800 runtime CFG evidence
    add ax, 8
; @0733A 0000:733A original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0733C 0000:733C original=7422 runtime CFG evidence
    JE_SHORT loc_07360
; @0733E 0000:733E original=2d0800 runtime CFG evidence
    sub ax, 8
; @07341 0000:7341 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07343 0000:7343 original=741b runtime CFG evidence
    JE_SHORT loc_07360
; @07345 0000:7345 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07348 0000:7348 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0734A 0000:734A original=7414 runtime CFG evidence
    JE_SHORT loc_07360
; @0734C 0000:734C original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @07350 0000:7350 original=754b runtime CFG evidence
    JNE_SHORT loc_0739D
; @07352 0000:7352 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07355 0000:7355 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @07357 0000:7357 original=7407 runtime CFG evidence
    JE_SHORT loc_07360
; @07359 0000:7359 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0735C 0000:735C original=3bc2 runtime CFG evidence
    cmp ax, dx
; @0735E 0000:735E original=753d runtime CFG evidence
    JNE_SHORT loc_0739D
; @07360 0000:7360 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @07363 0000:7363 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @07366 0000:7366 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07368 0000:7368 original=7503 runtime CFG evidence
    JNE_SHORT loc_0736D
; @0736A 0000:736A original=e9584b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0736D 0000:736D original=2d0800 runtime CFG evidence
    sub ax, 8
; @07370 0000:7370 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07372 0000:7372 original=7503 runtime CFG evidence
    JNE_SHORT loc_07377
; @07374 0000:7374 original=e94e4b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07377 0000:7377 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @0737B 0000:737B original=7520 runtime CFG evidence
    JNE_SHORT loc_0739D
; @0737D 0000:737D original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07381 0000:7381 original=741a runtime CFG evidence
    JE_SHORT loc_0739D
; @07383 0000:7383 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @07387 0000:7387 original=7414 runtime CFG evidence
    JE_SHORT loc_0739D
; @07389 0000:7389 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0738C 0000:738C original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0738E 0000:738E original=7503 runtime CFG evidence
    JNE_SHORT loc_07393
; @07390 0000:7390 original=e9324b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07393 0000:7393 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07396 0000:7396 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07398 0000:7398 original=7503 runtime CFG evidence
    JNE_SHORT loc_0739D
; @0739A 0000:739A original=e9284b runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0739D 0000:739D original=83c338 runtime CFG evidence
    add bx, 038h
; @073A0 0000:73A0 original=833f00 runtime CFG evidence
    cmp word ptr ds:[bx], 0
; @073A3 0000:73A3 original=7477 runtime CFG evidence
    JE_SHORT loc_0741C
; @073A5 0000:73A5 original=837f1e00 runtime CFG evidence
    cmp word ptr ds:[bx + 01Eh], 0
; @073A9 0000:73A9 original=7471 runtime CFG evidence
    JE_SHORT loc_0741C
; @073AB 0000:73AB original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + 4]
; @073AE 0000:73AE original=a90700 runtime CFG evidence
    test ax, 7
; @073B1 0000:73B1 original=740d runtime CFG evidence
    JE_SHORT loc_073C0
; @073B3 0000:73B3 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @073B6 0000:73B6 original=050800 runtime CFG evidence
    add ax, 8
; @073B9 0000:73B9 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @073BB 0000:73BB original=7422 runtime CFG evidence
    JE_SHORT loc_073DF
; @073BD 0000:73BD original=2d0800 runtime CFG evidence
    sub ax, 8
; @073C0 0000:73C0 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @073C2 0000:73C2 original=741b runtime CFG evidence
    JE_SHORT loc_073DF
; @073C4 0000:73C4 original=2d0800 runtime CFG evidence
    sub ax, 8
; @073C7 0000:73C7 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @073C9 0000:73C9 original=7414 runtime CFG evidence
    JE_SHORT loc_073DF
; @073CB 0000:73CB original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @073CF 0000:73CF original=754b runtime CFG evidence
    JNE_SHORT loc_0741C
; @073D1 0000:73D1 original=2d0800 runtime CFG evidence
    sub ax, 8
; @073D4 0000:73D4 original=3bc2 runtime CFG evidence
    cmp ax, dx
; @073D6 0000:73D6 original=7407 runtime CFG evidence
    JE_SHORT loc_073DF
; @073D8 0000:73D8 original=2d0800 runtime CFG evidence
    sub ax, 8
; @073DB 0000:73DB original=3bc2 runtime CFG evidence
    cmp ax, dx
; @073DD 0000:73DD original=753d runtime CFG evidence
    JNE_SHORT loc_0741C
; @073DF 0000:73DF original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + 2]
; @073E2 0000:73E2 original=25f8ff runtime CFG evidence
    and ax, 0FFF8h
; @073E5 0000:73E5 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @073E7 0000:73E7 original=7503 runtime CFG evidence
    JNE_SHORT loc_073EC
; @073E9 0000:73E9 original=e9d94a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @073EC 0000:73EC original=2d0800 runtime CFG evidence
    sub ax, 8
; @073EF 0000:73EF original=3bc1 runtime CFG evidence
    cmp ax, cx
; @073F1 0000:73F1 original=7503 runtime CFG evidence
    JNE_SHORT loc_073F6
; @073F3 0000:73F3 original=e9cf4a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @073F6 0000:73F6 original=837e1402 runtime CFG evidence
    cmp word ptr ss:[bp + 014h], 2
; @073FA 0000:73FA original=7520 runtime CFG evidence
    JNE_SHORT loc_0741C
; @073FC 0000:73FC original=837e1878 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 078h
; @07400 0000:7400 original=741a runtime CFG evidence
    JE_SHORT loc_0741C
; @07402 0000:7402 original=837e1879 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 079h
; @07406 0000:7406 original=7414 runtime CFG evidence
    JE_SHORT loc_0741C
; @07408 0000:7408 original=2d0800 runtime CFG evidence
    sub ax, 8
; @0740B 0000:740B original=3bc1 runtime CFG evidence
    cmp ax, cx
; @0740D 0000:740D original=7503 runtime CFG evidence
    JNE_SHORT loc_07412
; @0740F 0000:740F original=e9b34a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @07412 0000:7412 original=2d0800 runtime CFG evidence
    sub ax, 8
; @07415 0000:7415 original=3bc1 runtime CFG evidence
    cmp ax, cx
; @07417 0000:7417 original=7503 runtime CFG evidence
    JNE_SHORT loc_0741C
; @07419 0000:7419 original=e9a94a runtime CFG evidence
    JMP_NEAR loc_0BEC5
; @0741C 0000:741C original=83c338 runtime CFG evidence
    add bx, 038h
; @0741F 0000:741F original=c3 runtime CFG evidence
    ret
; sub_0000_7420
; @07420 0000:7420 original=e80101
    CALL_NEAR FindFreeRecordPoolA_07524
; @07423 0000:7423 original=83fbff
    cmp bx, -1
; @07426 0000:7426 original=7501
    JNE_SHORT loc_07429
; @07428 0000:7428 original=c3
    ret
; @07429 0000:7429 original=c7070100
    mov word ptr ds:[bx + REC_STATUS], 1
; @0742D 0000:742D original=a17823
    mov ax, word ptr ds:[02378h]
; @07430 0000:7430 original=030678a2
    add ax, word ptr ds:[0A278h]
; @07434 0000:7434 original=894702
    mov word ptr ds:[bx + REC_Y], ax
; @07437 0000:7437 original=a17623
    mov ax, word ptr ds:[02376h]
; @0743A 0000:743A original=3dc000
    cmp ax, 0C0h
; @0743D 0000:743D original=7603
    JBE_SHORT loc_07442
; @0743F 0000:743F original=b8c000
    mov ax, 0C0h
; @07442 0000:7442 original=894704
    mov word ptr ds:[bx + REC_X], ax
; @07445 0000:7445 original=c747220000
    mov word ptr ds:[bx + 022h], 0
; @0744A 0000:744A original=c747140100
    mov word ptr ds:[bx + 014h], 1
; @0744F 0000:744F original=c747160500
    mov word ptr ds:[bx + 016h], 5
; @07454 0000:7454 original=c747180000
    mov word ptr ds:[bx + 018h], 0
; @07459 0000:7459 original=c74728ffff
    mov word ptr ds:[bx + 028h], 0FFFFh
; @0745E 0000:745E original=c747240000
    mov word ptr ds:[bx + 024h], 0
; @07463 0000:7463 original=8b367a23
    mov si, word ptr ds:[0237Ah]
; @07467 0000:7467 original=897726
    mov word ptr ds:[bx + 026h], si
; @0746A 0000:746A original=83c646
    add si, 046h
; @0746D 0000:746D original=897708
    mov word ptr ds:[bx + 8], si
; @07470 0000:7470 original=c7470a0000
    mov word ptr ds:[bx + 0Ah], 0
; @07475 0000:7475 original=c3
    ret
; @07476 0000:7476 original=e8fa00 runtime CFG evidence
    CALL_NEAR FindFreeRecordPoolB_07573
; @07479 0000:7479 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0747C 0000:747C original=7501 runtime CFG evidence
    JNE_SHORT loc_0747F
; @0747E 0000:747E original=c3 runtime CFG evidence
    ret
; @0747F 0000:747F original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @07484 0000:7484 original=7405 runtime CFG evidence
    JE_SHORT loc_0748B
; @07486 0000:7486 original=c606ffbe1a runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 01Ah
; @0748B 0000:748B original=b90c00 runtime CFG evidence
    mov cx, 0Ch
; @0748E 0000:748E original=ba0c00 runtime CFG evidence
    mov dx, 0Ch
; @07491 0000:7491 original=833ec2a801 runtime CFG evidence
    cmp word ptr ds:[0A8C2h], 1
; @07496 0000:7496 original=7506 runtime CFG evidence
    JNE_SHORT loc_0749E
; @07498 0000:7498 original=b91c00 runtime CFG evidence
    mov cx, 01Ch
; @0749B 0000:749B original=ba0800 runtime CFG evidence
    mov dx, 8
; @0749E 0000:749E original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + REC_X]
; @074A1 0000:74A1 original=03c1 runtime CFG evidence
    add ax, cx
; @074A3 0000:74A3 original=894704 runtime CFG evidence
    mov word ptr ds:[bx + REC_X], ax
; @074A6 0000:74A6 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + REC_Y]
; @074A9 0000:74A9 original=03c2 runtime CFG evidence
    add ax, dx
; @074AB 0000:74AB original=894702 runtime CFG evidence
    mov word ptr ds:[bx + REC_Y], ax
; @074AE 0000:74AE original=e80400 runtime CFG evidence
    CALL_NEAR loc_074B5
; @074B1 0000:74B1 original=e82e00 runtime CFG evidence
    CALL_NEAR loc_074E2
; @074B4 0000:74B4 original=c3 runtime CFG evidence
    ret
; @074B5 0000:74B5 original=c7070100 runtime CFG evidence
    mov word ptr ds:[bx + REC_STATUS], 1
; @074B9 0000:74B9 original=c7471e0000 runtime CFG evidence
    mov word ptr ds:[bx + 01Eh], 0
; @074BE 0000:74BE original=c747060000 runtime CFG evidence
    mov word ptr ds:[bx + 6], 0
; @074C3 0000:74C3 original=c747083100 runtime CFG evidence
    mov word ptr ds:[bx + 8], 031h
; @074C8 0000:74C8 original=c7470a0100 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 1
; @074CD 0000:74CD original=c747140000 runtime CFG evidence
    mov word ptr ds:[bx + 014h], 0
; @074D2 0000:74D2 original=c747160200 runtime CFG evidence
    mov word ptr ds:[bx + 016h], 2
; @074D7 0000:74D7 original=c747180b00 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 0Bh
; @074DC 0000:74DC original=c7471cffff runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 0FFFFh
; @074E1 0000:74E1 original=c3 runtime CFG evidence
    ret
; @074E2 0000:74E2 original=8b4704 runtime CFG evidence
    mov ax, word ptr ds:[bx + REC_X]
; @074E5 0000:74E5 original=8b0e8023 runtime CFG evidence
    mov cx, word ptr ds:[02380h]
; @074E9 0000:74E9 original=83c109 runtime CFG evidence
    add cx, 9
; @074EC 0000:74EC original=2bc1 runtime CFG evidence
    sub ax, cx
; @074EE 0000:74EE original=89472c runtime CFG evidence
    mov word ptr ds:[bx + 02Ch], ax
; @074F1 0000:74F1 original=8b4702 runtime CFG evidence
    mov ax, word ptr ds:[bx + REC_Y]
; @074F4 0000:74F4 original=8b0e7e23 runtime CFG evidence
    mov cx, word ptr ds:[0237Eh]
; @074F8 0000:74F8 original=2bc1 runtime CFG evidence
    sub ax, cx
; @074FA 0000:74FA original=89472a runtime CFG evidence
    mov word ptr ds:[bx + 02Ah], ax
; @074FD 0000:74FD original=c3 runtime CFG evidence
    ret
; @074FE 0000:74FE original=e82300 runtime CFG evidence
    CALL_NEAR FindFreeRecordPoolA_07524
; @07501 0000:7501 original=83fbff runtime CFG evidence
    cmp bx, -1
; @07504 0000:7504 original=7401 runtime CFG evidence
    JE_SHORT loc_07507
; @07506 0000:7506 original=c3 runtime CFG evidence
    ret
; @07507 0000:7507 original=b92300 runtime CFG evidence
    mov cx, 023h
; @0750A 0000:750A original=bbb423 runtime CFG evidence
    mov bx, 023B4h
; @0750D 0000:750D original=837f1606 runtime CFG evidence
    cmp word ptr ds:[bx + 016h], 6
; @07511 0000:7511 original=7406 runtime CFG evidence
    JE_SHORT loc_07519
; @07513 0000:7513 original=837f1601 runtime CFG evidence
    cmp word ptr ds:[bx + 016h], 1
; @07517 0000:7517 original=7508 runtime CFG evidence
    JNE_SHORT loc_07521
; @07519 0000:7519 original=83c338 runtime CFG evidence
    add bx, 038h
; @0751C 0000:751C original=e2ef runtime CFG evidence
    LOOP_SHORT loc_0750D
; @0751E 0000:751E original=bbb423 runtime CFG evidence
    mov bx, 023B4h
; @07521 0000:7521 original=e9e947 runtime CFG evidence
    JMP_NEAR loc_0BD0D
; sub_0000_7524
; FindFreeRecordPoolA (modern reconstruction name)
; Near leaf. DS:95D8 supplies the first candidate. Inspect at most35 status words at stride38h in23B4..2B5B,
; wrapping BX after increment equals2B5C. Return BX=first zero-status record, CX=35-skipped; save BX to DS:95D8
; without activating record. Full pool returns BX=FFFF,CX=0 and leaves cursor unchanged. Requires aligned in-
; pool cursor; unlike poolB, end cursor is not normalized before first read. AX,DX,SI,DI,BP,segments preserved;
; flags changed.
; Evidence: metadata/symbols.json
; @07524 0000:7524 original=b92300
    mov cx, POOL_A_COUNT
; @07527 0000:7527 original=8b1ed895
    mov bx, word ptr ds:[POOL_A_CURSOR]
; @0752B 0000:752B original=833f00
    cmp word ptr ds:[bx + REC_STATUS], 0
; @0752E 0000:752E original=7412
    JE_SHORT loc_07542
; @07530 0000:7530 original=83c338
    add bx, REC_STRIDE
; @07533 0000:7533 original=81fb5c2b
    cmp bx, POOL_A_END
; @07537 0000:7537 original=7503
    JNE_SHORT loc_0753C
; @07539 0000:7539 original=bbb423
    mov bx, POOL_A_START
; @0753C 0000:753C original=e2ed
    LOOP_SHORT loc_0752B
; @0753E 0000:753E original=bbffff
    mov bx, 0FFFFh
; @07541 0000:7541 original=c3
    ret
; @07542 0000:7542 original=891ed895
    mov word ptr ds:[POOL_A_CURSOR], bx
; @07546 0000:7546 original=c3
    ret
; sub_0000_7547
; @07547 0000:7547 original=e82900
    CALL_NEAR FindFreeRecordPoolB_07573
; @0754A 0000:754A original=83fbff
    cmp bx, -1
; @0754D 0000:754D original=7401
    JE_SHORT loc_07550
; @0754F 0000:754F original=c3
    ret
; @07550 0000:7550 original=b92200
    mov cx, 022h
; @07553 0000:7553 original=bb5c2b
    mov bx, 02B5Ch
; @07556 0000:7556 original=837f1809
    cmp word ptr ds:[bx + 018h], 9
; @0755A 0000:755A original=740c
    JE_SHORT loc_07568
; @0755C 0000:755C original=837f180a
    cmp word ptr ds:[bx + 018h], 0Ah
; @07560 0000:7560 original=7406
    JE_SHORT loc_07568
; @07562 0000:7562 original=837f1601
    cmp word ptr ds:[bx + 016h], 1
; @07566 0000:7566 original=7508
    JNE_SHORT loc_07570
; @07568 0000:7568 original=83c338
    add bx, 038h
; @0756B 0000:756B original=e2e9
    LOOP_SHORT loc_07556
; @0756D 0000:756D original=bb5c2b
    mov bx, 02B5Ch
; @07570 0000:7570 original=e99a47
    JMP_NEAR loc_0BD0D
; sub_0000_7573
; FindFreeRecordPoolB (modern reconstruction name)
; Near leaf. DS:95DA supplies cursor. Normalize BX==32CCh to2B5Ch before reading; inspect at most34 zero-status
; records at stride38h. Success returns BX and CX=34-skipped and saves cursor; failure BX=FFFF,CX=0 leaves
; cursor unchanged. Accept aligned pool cursor or exact end32CC; other pointers not validated. Does not activate
; or clear records. AX,DX,SI,DI,BP,segments preserved; flags changed.
; Evidence: metadata/symbols.json
; @07573 0000:7573 original=b92200
    mov cx, POOL_B_COUNT
; @07576 0000:7576 original=8b1eda95
    mov bx, word ptr ds:[POOL_B_CURSOR]
; @0757A 0000:757A original=81fbcc32
    cmp bx, POOL_B_END
; @0757E 0000:757E original=7503
    JNE_SHORT loc_07583
; @07580 0000:7580 original=bb5c2b
    mov bx, POOL_B_START
; @07583 0000:7583 original=833f00
    cmp word ptr ds:[bx + REC_STATUS], 0
; @07586 0000:7586 original=7409
    JE_SHORT loc_07591
; @07588 0000:7588 original=83c338
    add bx, REC_STRIDE
; @0758B 0000:758B original=e2ed
    LOOP_SHORT loc_0757A
; @0758D 0000:758D original=bbffff
    mov bx, 0FFFFh
; @07590 0000:7590 original=c3
    ret
; @07591 0000:7591 original=891eda95
    mov word ptr ds:[POOL_B_CURSOR], bx
; @07595 0000:7595 original=c3
    ret
; sub_0000_7596
; @07596 0000:7596 original=8b5e14
    mov bx, word ptr ss:[bp + 014h]
; @07599 0000:7599 original=d1e3
    shl bx, 1
; @0759B 0000:759B original=2effa7a075
    jmp word ptr cs:[bx + 075A0h]
; @075A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,077h,08Eh,076h,0A6h,075h
; @075A6 0000:75A6 original=8b5e08 runtime CFG evidence
    mov bx, word ptr ss:[bp + 8]
; @075A9 0000:75A9 original=2e8b0ea695 runtime CFG evidence
    mov cx, word ptr cs:[095A6h]
; @075AE 0000:75AE original=83fb1c runtime CFG evidence
    cmp bx, 01Ch
; @075B1 0000:75B1 original=7208 runtime CFG evidence
    JB_SHORT loc_075BB
; @075B3 0000:75B3 original=83eb1c runtime CFG evidence
    sub bx, 01Ch
; @075B6 0000:75B6 original=2e8b0eae95 runtime CFG evidence
    mov cx, word ptr cs:[095AEh]
; @075BB 0000:75BB original=d1e3 runtime CFG evidence
    shl bx, 1
; @075BD 0000:75BD original=81c39293 runtime CFG evidence
    add bx, 09392h
; @075C1 0000:75C1 original=2e8b37 runtime CFG evidence
    mov si, word ptr cs:[bx]
; @075C4 0000:75C4 original=2e89362476 runtime CFG evidence
    mov word ptr cs:[07624h], si
; @075C9 0000:75C9 original=2e890e2676 runtime CFG evidence
    mov word ptr cs:[07626h], cx
; @075CE 0000:75CE original=8b7e0c runtime CFG evidence
    mov di, word ptr ss:[bp + 0Ch]
; @075D1 0000:75D1 original=83ffff runtime CFG evidence
    cmp di, -1
; @075D4 0000:75D4 original=7405 runtime CFG evidence
    JE_SHORT loc_075DB
; @075D6 0000:75D6 original=55 runtime CFG evidence
    push bp
; @075D7 0000:75D7 original=e81b00 runtime CFG evidence
    CALL_NEAR loc_075F5
; @075DA 0000:75DA original=5d runtime CFG evidence
    pop bp
; @075DB 0000:75DB original=8b7e10 runtime CFG evidence
    mov di, word ptr ss:[bp + 010h]
; @075DE 0000:75DE original=83ffff runtime CFG evidence
    cmp di, -1
; @075E1 0000:75E1 original=7501 runtime CFG evidence
    JNE_SHORT loc_075E4
; @075E3 0000:75E3 original=c3 runtime CFG evidence
    ret
; @075E4 0000:75E4 original=2e8b362476 runtime CFG evidence
    mov si, word ptr cs:[07624h]
; @075E9 0000:75E9 original=2e8b0e2676 runtime CFG evidence
    mov cx, word ptr cs:[07626h]
; @075EE 0000:75EE original=a12810 runtime CFG evidence
    mov ax, word ptr ds:[01028h]
; @075F1 0000:75F1 original=d1e8 runtime CFG evidence
    shr ax, 1
; @075F3 0000:75F3 original=03f0 runtime CFG evidence
    add si, ax
; @075F5 0000:75F5 original=2e8e069895 runtime CFG evidence
    mov es, word ptr cs:[09598h]
; @075FA 0000:75FA original=2e8b1ebc95 runtime CFG evidence
    mov bx, word ptr cs:[095BCh]
; @075FF 0000:75FF original=d1e3 runtime CFG evidence
    shl bx, 1
; @07601 0000:7601 original=d1e3 runtime CFG evidence
    shl bx, 1
; @07603 0000:7603 original=d1e3 runtime CFG evidence
    shl bx, 1
; @07605 0000:7605 original=035e12 runtime CFG evidence
    add bx, word ptr ss:[bp + 012h]
; @07608 0000:7608 original=ba5876 runtime CFG evidence
    mov dx, 07658h
; @0760B 0000:760B original=f74624ffff runtime CFG evidence
    test word ptr ss:[bp + 024h], 0FFFFh
; @07610 0000:7610 original=7503 runtime CFG evidence
    JNE_SHORT loc_07615
; @07612 0000:7612 original=ba2876 runtime CFG evidence
    mov dx, 07628h
; @07615 0000:7615 original=d1e3 runtime CFG evidence
    shl bx, 1
; @07617 0000:7617 original=03da runtime CFG evidence
    add bx, dx
; @07619 0000:7619 original=8ed9 runtime CFG evidence
    mov ds, cx
; @0761B 0000:761B original=bd1000 runtime CFG evidence
    mov bp, 010h
; @0761E 0000:761E original=8bcd runtime CFG evidence
    mov cx, bp
; @07620 0000:7620 original=2eff27 runtime CFG evidence
    jmp word ptr cs:[bx]
; @07623 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h,049h,038h,026h,039h,0DFh,039h,0EEh,03Ah,088h,076h,088h
; @07633 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,088h,076h,088h,076h,03Ch,010h,0EDh,010h,0B8h,011h,0B6h,012h,0E7h,013h,04Bh
; @07643 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,07Ch,016h,07Ah,017h,06Eh,02Eh,088h,076h,088h,076h,088h,076h,088h,076h,088h
; @07653 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,088h,076h,088h,076h,07Ch,038h,053h,03Ch,0BCh,03Ch,052h,03Dh,088h,076h,088h
; @07663 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,088h,076h,088h,076h,0B7h,010h,045h,018h,099h,018h,0F7h,018h,05Fh,019h,0D1h
; @07673 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 019h,039h,01Ah,097h,01Ah,0CBh,02Eh,088h,076h,088h,076h,088h,076h,088h,076h,088h
; @07683 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,088h,076h,088h,076h,02Eh,08Eh,01Eh,096h,095h,0C3h
; @0768E 0000:768E original=8b7e0c runtime CFG evidence
    mov di, word ptr ss:[bp + 0Ch]
; @07691 0000:7691 original=83ffff runtime CFG evidence
    cmp di, -1
; @07694 0000:7694 original=7501 runtime CFG evidence
    JNE_SHORT loc_07697
; @07696 0000:7696 original=c3 runtime CFG evidence
    ret
; @07697 0000:7697 original=2e8e069895 runtime CFG evidence
    mov es, word ptr cs:[09598h]
; @0769C 0000:769C original=8b5e08 runtime CFG evidence
    mov bx, word ptr ss:[bp + 8]
; @0769F 0000:769F original=2e8b0eaa95 runtime CFG evidence
    mov cx, word ptr cs:[095AAh]
; @076A4 0000:76A4 original=81fbfa00 runtime CFG evidence
    cmp bx, 0FAh
; @076A8 0000:76A8 original=7209 runtime CFG evidence
    JB_SHORT loc_076B3
; @076AA 0000:76AA original=81ebfa00 runtime CFG evidence
    sub bx, 0FAh
; @076AE 0000:76AE original=2e8b0eac95 runtime CFG evidence
    mov cx, word ptr cs:[095ACh]
; @076B3 0000:76B3 original=d1e3 runtime CFG evidence
    shl bx, 1
; @076B5 0000:76B5 original=81c39291 runtime CFG evidence
    add bx, 09192h
; @076B9 0000:76B9 original=2e8b37 runtime CFG evidence
    mov si, word ptr cs:[bx]
; @076BC 0000:76BC original=2e8b1ebc95 runtime CFG evidence
    mov bx, word ptr cs:[095BCh]
; @076C1 0000:76C1 original=d1e3 runtime CFG evidence
    shl bx, 1
; @076C3 0000:76C3 original=d1e3 runtime CFG evidence
    shl bx, 1
; @076C5 0000:76C5 original=d1e3 runtime CFG evidence
    shl bx, 1
; @076C7 0000:76C7 original=035e12 runtime CFG evidence
    add bx, word ptr ss:[bp + 012h]
; @076CA 0000:76CA original=ba1677 runtime CFG evidence
    mov dx, 07716h
; @076CD 0000:76CD original=f74624ffff runtime CFG evidence
    test word ptr ss:[bp + 024h], 0FFFFh
; @076D2 0000:76D2 original=7503 runtime CFG evidence
    JNE_SHORT loc_076D7
; @076D4 0000:76D4 original=bae676 runtime CFG evidence
    mov dx, 076E6h
; @076D7 0000:76D7 original=d1e3 runtime CFG evidence
    shl bx, 1
; @076D9 0000:76D9 original=03da runtime CFG evidence
    add bx, dx
; @076DB 0000:76DB original=8ed9 runtime CFG evidence
    mov ds, cx
; @076DD 0000:76DD original=bd1000 runtime CFG evidence
    mov bp, 010h
; @076E0 0000:76E0 original=8bcd runtime CFG evidence
    mov cx, bp
; @076E2 0000:76E2 original=2eff27 runtime CFG evidence
    jmp word ptr cs:[bx]
; @076E5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0B7h,038h,012h,03Eh,070h,03Eh,0FBh,03Eh,088h,076h,088h,076h,088h,076h,088h
; @076F5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,0EBh,01Ah,04Fh,01Bh,0C6h,01Bh,061h,01Ch,01Bh,01Dh,0F4h,01Dh,0AEh,01Eh,049h
; @07705 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,081h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h
; @07715 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,0D6h,038h,0B0h,03Fh,0EBh,03Fh,03Ah,040h,088h,076h,088h,076h,088h,076h,088h
; @07725 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,02Eh,01Bh,0C0h,01Fh,0FBh,01Fh,03Ch,020h,083h,020h,0D0h,020h,017h,021h,058h
; @07735 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,040h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h
; @07745 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h
; sub_0000_7746
; @07746 0000:7746 original=8b7e0c
    mov di, word ptr ss:[bp + 0Ch]
; @07749 0000:7749 original=83ffff
    cmp di, -1
; @0774C 0000:774C original=7501
    JNE_SHORT loc_0774F
; @0774E 0000:774E original=c3
    ret
; @0774F 0000:774F original=2e8e069895
    mov es, word ptr cs:[09598h]
; @07754 0000:7754 original=8b5e08
    mov bx, word ptr ss:[bp + 8]
; @07757 0000:7757 original=2e8b0ea895
    mov cx, word ptr cs:[095A8h]
; @0775C 0000:775C original=d1e3
    shl bx, 1
; @0775E 0000:775E original=81c3928f
    add bx, 08F92h
; @07762 0000:7762 original=2e8b37
    mov si, word ptr cs:[bx]
; @07765 0000:7765 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @0776A 0000:776A original=d1e3
    shl bx, 1
; @0776C 0000:776C original=d1e3
    shl bx, 1
; @0776E 0000:776E original=d1e3
    shl bx, 1
; @07770 0000:7770 original=035e12
    add bx, word ptr ss:[bp + 012h]
; @07773 0000:7773 original=8ed9
    mov ds, cx
; @07775 0000:7775 original=bd0800
    mov bp, 8
; @07778 0000:7778 original=8bcd
    mov cx, bp
; @0777A 0000:777A original=d1e3
    shl bx, 1
; @0777C 0000:777C original=2effa78277
    jmp word ptr cs:[bx + 07782h]
; @07781 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0F9h,038h,09Dh,040h,0D7h,040h,02Bh,041h,088h,076h,088h,076h,088h,076h,088h
; @07791 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,093h,021h,0D6h,021h,023h,022h,085h,022h,0FCh,022h,08Dh,023h,010h,024h,07Eh
; @077A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,0B6h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h,076h,088h
; @077B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h
; @077B2 0000:77B2 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @077B7 0000:77B7 original=7405
    JE_SHORT loc_077BE
; @077B9 0000:77B9 original=c606ffbe0c
    mov byte ptr ds:[0BEFFh], 0Ch
; @077BE 0000:77BE original=c7067ca90000
    mov word ptr ds:[0A97Ch], 0
; @077C4 0000:77C4 original=c3
    ret
; sub_0000_77C5
; @077C5 0000:77C5 original=833e7ca901
    cmp word ptr ds:[0A97Ch], 1
; @077CA 0000:77CA original=7401
    JE_SHORT loc_077CD
; @077CC 0000:77CC original=c3
    ret
; @077CD 0000:77CD original=833e842303
    cmp word ptr ds:[02384h], 3
; @077D2 0000:77D2 original=73ea
    JAE_SHORT loc_077BE
; @077D4 0000:77D4 original=833e7aa958
    cmp word ptr ds:[0A97Ah], 058h
; @077D9 0000:77D9 original=74d7
    JE_SHORT loc_077B2
; @077DB 0000:77DB original=ff067aa9
    inc word ptr ds:[0A97Ah]
; sub_0000_77DF
; @077DF 0000:77DF original=55
    push bp
; @077E0 0000:77E0 original=e81300
    CALL_NEAR loc_077F6
; @077E3 0000:77E3 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @077E9 0000:77E9 original=7509
    JNE_SHORT loc_077F4
; @077EB 0000:77EB original=e831d9
    CALL_NEAR loc_0511F
; @077EE 0000:77EE original=e80500
    CALL_NEAR loc_077F6
; @077F1 0000:77F1 original=e82bd9
    CALL_NEAR loc_0511F
; @077F4 0000:77F4 original=5d
    pop bp
; @077F5 0000:77F5 original=c3
    ret
; sub_0000_77F6
; @077F6 0000:77F6 original=b01d
    mov al, 01Dh
; @077F8 0000:77F8 original=b45f
    mov ah, 05Fh
; @077FA 0000:77FA original=e803e2
    CALL_NEAR loc_05A00
; @077FD 0000:77FD original=893edc95
    mov word ptr ds:[095DCh], di
; @07801 0000:7801 original=8b0e7aa9
    mov cx, word ptr ds:[0A97Ah]
; @07805 0000:7805 original=d1e9
    shr cx, 1
; @07807 0000:7807 original=e302
    JCXZ_SHORT loc_0780B
; @07809 0000:7809 original=eb03
    JMP_SHORT loc_0780E
; @0780B 0000:780B original=e98c00
    JMP_NEAR loc_0789A
; @0780E 0000:780E original=51
    push cx
; @0780F 0000:780F original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @07814 0000:7814 original=2e833ebc9500
    cmp word ptr cs:[095BCh], 0
; @0781A 0000:781A original=7459
    JE_SHORT loc_07875
; @0781C 0000:781C original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @07822 0000:7822 original=7429
    JE_SHORT loc_0784D
; @07824 0000:7824 original=26c705ceff
    mov word ptr es:[di], 0FFCEh
; @07829 0000:7829 original=26c74502eec4
    mov word ptr es:[di + 2], 0C4EEh
; @0782F 0000:782F original=f7c70060
    test di, 06000h
; @07833 0000:7833 original=7504
    JNE_SHORT loc_07839
; @07835 0000:7835 original=81c7607f
    add di, 07F60h
; @07839 0000:7839 original=81ef0020
    sub di, 02000h
; @0783D 0000:783D original=f7c70060
    test di, 06000h
; @07841 0000:7841 original=7504
    JNE_SHORT loc_07847
; @07843 0000:7843 original=81c7607f
    add di, 07F60h
; @07847 0000:7847 original=81ef0020
    sub di, 02000h
; @0784B 0000:784B original=eb45
    JMP_SHORT loc_07892
; @0784D 0000:784D original=bac403
    mov dx, 03C4h
; @07850 0000:7850 original=b002
    mov al, 2
; @07852 0000:7852 original=ee
    out dx, al
; @07853 0000:7853 original=42
    inc dx
; @07854 0000:7854 original=b001
    mov al, 1
; @07856 0000:7856 original=ee
    out dx, al
; @07857 0000:7857 original=26c60530
    mov byte ptr es:[di], 030h
; @0785B 0000:785B original=b002
    mov al, 2
; @0785D 0000:785D original=ee
    out dx, al
; @0785E 0000:785E original=26c6057c
    mov byte ptr es:[di], 07Ch
; @07862 0000:7862 original=b004
    mov al, 4
; @07864 0000:7864 original=ee
    out dx, al
; @07865 0000:7865 original=26c605ff
    mov byte ptr es:[di], 0FFh
; @07869 0000:7869 original=b008
    mov al, 8
; @0786B 0000:786B original=ee
    out dx, al
; @0786C 0000:786C original=26c605fe
    mov byte ptr es:[di], 0FEh
; @07870 0000:7870 original=83ef50
    sub di, 050h
; @07873 0000:7873 original=eb1d
    JMP_SHORT loc_07892
; @07875 0000:7875 original=26c7052fa0
    mov word ptr es:[di], 0A02Fh
; @0787A 0000:787A original=b80020
    mov ax, 02000h
; @0787D 0000:787D original=85f8
    test di, ax
; @0787F 0000:787F original=7403
    JE_SHORT loc_07884
; @07881 0000:7881 original=b850e0
    mov ax, 0E050h
; @07884 0000:7884 original=2bf8
    sub di, ax
; @07886 0000:7886 original=b80020
    mov ax, 02000h
; @07889 0000:7889 original=85f8
    test di, ax
; @0788B 0000:788B original=7403
    JE_SHORT loc_07890
; @0788D 0000:788D original=b850e0
    mov ax, 0E050h
; @07890 0000:7890 original=2bf8
    sub di, ax
; @07892 0000:7892 original=59
    pop cx
; @07893 0000:7893 original=e202
    LOOP_SHORT loc_07897
; @07895 0000:7895 original=eb03
    JMP_SHORT loc_0789A
; @07897 0000:7897 original=e974ff
    JMP_NEAR loc_0780E
; @0789A 0000:789A original=b92c00
    mov cx, 02Ch
; @0789D 0000:789D original=a17aa9
    mov ax, word ptr ds:[0A97Ah]
; @078A0 0000:78A0 original=d1e8
    shr ax, 1
; @078A2 0000:78A2 original=2bc8
    sub cx, ax
; @078A4 0000:78A4 original=e375
    JCXZ_SHORT loc_0791B
; @078A6 0000:78A6 original=51
    push cx
; @078A7 0000:78A7 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @078AC 0000:78AC original=2e833ebc9500
    cmp word ptr cs:[095BCh], 0
; @078B2 0000:78B2 original=7447
    JE_SHORT loc_078FB
; @078B4 0000:78B4 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @078BA 0000:78BA original=7429
    JE_SHORT loc_078E5
; @078BC 0000:78BC original=26c7050000
    mov word ptr es:[di], 0
; @078C1 0000:78C1 original=26c745020000
    mov word ptr es:[di + 2], 0
; @078C7 0000:78C7 original=f7c70060
    test di, 06000h
; @078CB 0000:78CB original=7504
    JNE_SHORT loc_078D1
; @078CD 0000:78CD original=81c7607f
    add di, 07F60h
; @078D1 0000:78D1 original=81ef0020
    sub di, 02000h
; @078D5 0000:78D5 original=f7c70060
    test di, 06000h
; @078D9 0000:78D9 original=7504
    JNE_SHORT loc_078DF
; @078DB 0000:78DB original=81c7607f
    add di, 07F60h
; @078DF 0000:78DF original=81ef0020
    sub di, 02000h
; @078E3 0000:78E3 original=eb33
    JMP_SHORT loc_07918
; @078E5 0000:78E5 original=bac403
    mov dx, 03C4h
; @078E8 0000:78E8 original=b002
    mov al, 2
; @078EA 0000:78EA original=ee
    out dx, al
; @078EB 0000:78EB original=42
    inc dx
; @078EC 0000:78EC original=b00f
    mov al, 0Fh
; @078EE 0000:78EE original=ee
    out dx, al
; @078EF 0000:78EF original=26c60500
    mov byte ptr es:[di], 0
; @078F3 0000:78F3 original=83ef28
    sub di, 028h
; @078F6 0000:78F6 original=83ef28
    sub di, 028h
; @078F9 0000:78F9 original=eb1d
    JMP_SHORT loc_07918
; @078FB 0000:78FB original=26c7050000
    mov word ptr es:[di], 0
; @07900 0000:7900 original=b80020
    mov ax, 02000h
; @07903 0000:7903 original=85f8
    test di, ax
; @07905 0000:7905 original=7403
    JE_SHORT loc_0790A
; @07907 0000:7907 original=b850e0
    mov ax, 0E050h
; @0790A 0000:790A original=2bf8
    sub di, ax
; @0790C 0000:790C original=b80020
    mov ax, 02000h
; @0790F 0000:790F original=85f8
    test di, ax
; @07911 0000:7911 original=7403
    JE_SHORT loc_07916
; @07913 0000:7913 original=b850e0
    mov ax, 0E050h
; @07916 0000:7916 original=2bf8
    sub di, ax
; @07918 0000:7918 original=59
    pop cx
; @07919 0000:7919 original=e28b
    LOOP_SHORT loc_078A6
; @0791B 0000:791B original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @07921 0000:7921 original=750a
    JNE_SHORT loc_0792D
; @07923 0000:7923 original=bac403
    mov dx, 03C4h
; @07926 0000:7926 original=b002
    mov al, 2
; @07928 0000:7928 original=ee
    out dx, al
; @07929 0000:7929 original=42
    inc dx
; @0792A 0000:792A original=b00f
    mov al, 0Fh
; @0792C 0000:792C original=ee
    out dx, al
; @0792D 0000:792D original=833e7aa910
    cmp word ptr ds:[0A97Ah], 010h
; @07932 0000:7932 original=7313
    JAE_SHORT loc_07947
; @07934 0000:7934 original=833e7ca901
    cmp word ptr ds:[0A97Ch], 1
; @07939 0000:7939 original=740c
    JE_SHORT loc_07947
; @0793B 0000:793B original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @07940 0000:7940 original=7405
    JE_SHORT loc_07947
; @07942 0000:7942 original=c606ffbe0a
    mov byte ptr ds:[0BEFFh], 0Ah
; @07947 0000:7947 original=c3
    ret
; sub_0000_7948
; @07948 0000:7948 original=2e8e069295
    mov es, word ptr cs:[09592h]
; @0794D 0000:794D original=8b3608a4
    mov si, word ptr ds:[0A408h]
; @07951 0000:7951 original=c70606a40d00
    mov word ptr ds:[0A406h], 0Dh
; @07957 0000:7957 original=c7060aa40000
    mov word ptr ds:[0A40Ah], 0
; @0795D 0000:795D original=268a04
    mov al, byte ptr es:[si]
; @07960 0000:7960 original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @07964 0000:7964 original=d1e3
    shl bx, 1
; @07966 0000:7966 original=ff97de95
    call word ptr ds:[bx - 06A22h]
; @0796A 0000:796A original=83060aa410
    add word ptr ds:[0A40Ah], 010h
; @0796F 0000:796F original=46
    inc si
; @07970 0000:7970 original=ff0e06a4
    dec word ptr ds:[0A406h]
; @07974 0000:7974 original=75e7
    JNE_SHORT loc_0795D
; @07976 0000:7976 original=c3
    ret
; @07977 0000:7977 original=3c04 runtime CFG evidence
    cmp al, 4
; @07979 0000:7979 original=7503 runtime CFG evidence
    JNE_SHORT loc_0797E
; @0797B 0000:797B original=e9f000 runtime CFG evidence
    JMP_NEAR loc_07A6E
; @0797E 0000:797E original=3c07 runtime CFG evidence
    cmp al, 7
; @07980 0000:7980 original=7503 runtime CFG evidence
    JNE_SHORT loc_07985
; @07982 0000:7982 original=e9f500 runtime CFG evidence
    JMP_NEAR loc_07A7A
; @07985 0000:7985 original=3c6c runtime CFG evidence
    cmp al, 06Ch
; @07987 0000:7987 original=7503 runtime CFG evidence
    JNE_SHORT loc_0798C
; @07989 0000:7989 original=e92201 runtime CFG evidence
    JMP_NEAR loc_07AAE
; @0798C 0000:798C original=3c6d runtime CFG evidence
    cmp al, 06Dh
; @0798E 0000:798E original=7503 runtime CFG evidence
    JNE_SHORT loc_07993
; @07990 0000:7990 original=e93101 runtime CFG evidence
    JMP_NEAR loc_07AC4
; @07993 0000:7993 original=3cac runtime CFG evidence
    cmp al, 0ACh
; @07995 0000:7995 original=7503 runtime CFG evidence
    JNE_SHORT loc_0799A
; @07997 0000:7997 original=e94001 runtime CFG evidence
    JMP_NEAR loc_07ADA
; @0799A 0000:799A original=3cb1 runtime CFG evidence
    cmp al, 0B1h
; @0799C 0000:799C original=7503 runtime CFG evidence
    JNE_SHORT loc_079A1
; @0799E 0000:799E original=e94f01 runtime CFG evidence
    JMP_NEAR loc_07AF0
; @079A1 0000:79A1 original=3cc9 runtime CFG evidence
    cmp al, 0C9h
; @079A3 0000:79A3 original=746c runtime CFG evidence
    JE_SHORT loc_07A11
; @079A5 0000:79A5 original=c3 runtime CFG evidence
    ret
; @079A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,0C6h,04h,01h,026h,0C6h,044h,01h,01h,026h,0C6h,044h,0Dh,01h,026h,0C6h
; @079B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,0Eh,01h,0C3h,0E8h,0E9h,0FFh,0E8h,064h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h
; @079C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,077h,00h,0C7h,047h,018h,048h,00h,0C7h,047h,06h,04h,00h,0E9h,0D1h,07h
; @079D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0CDh,0FFh,0E8h,048h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h,0E8h,05Bh,00h,0C7h
; @079E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,018h,075h,00h,0C7h,047h,08h,024h,00h,0C7h,047h,06h,04h,00h,0E9h,0B0h
; @079F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,0E8h,0ACh,0FFh,0E8h,027h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h,0E8h,03Ah,00h
; @07A06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,018h,072h,00h,0C7h,047h,06h,04h,00h,0C3h
; @07A11 0000:7A11 original=26c6440d26 runtime CFG evidence
    mov byte ptr es:[si + 0Dh], 026h
; @07A16 0000:7A16 original=26c6440e27 runtime CFG evidence
    mov byte ptr es:[si + 0Eh], 027h
; @07A1B 0000:7A1B original=26c60428 runtime CFG evidence
    mov byte ptr es:[si], 028h
; @07A1F 0000:7A1F original=26c6440129 runtime CFG evidence
    mov byte ptr es:[si + 1], 029h
; @07A24 0000:7A24 original=e8fdfa runtime CFG evidence
    CALL_NEAR FindFreeRecordPoolA_07524
; @07A27 0000:7A27 original=83fbff runtime CFG evidence
    cmp bx, -1
; @07A2A 0000:7A2A original=7501 runtime CFG evidence
    JNE_SHORT loc_07A2D
; @07A2C 0000:7A2C original=c3 runtime CFG evidence
    ret
; @07A2D 0000:7A2D original=e81000 runtime CFG evidence
    CALL_NEAR loc_07A40
; @07A30 0000:7A30 original=c747182800 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 028h
; @07A35 0000:7A35 original=c747081c00 runtime CFG evidence
    mov word ptr ds:[bx + 8], 01Ch
; @07A3A 0000:7A3A original=c747060000 runtime CFG evidence
    mov word ptr ds:[bx + 6], 0
; @07A3F 0000:7A3F original=c3 runtime CFG evidence
    ret
; @07A40 0000:7A40 original=c747160400 runtime CFG evidence
    mov word ptr ds:[bx + 016h], 4
; @07A45 0000:7A45 original=a10aa4 runtime CFG evidence
    mov ax, word ptr ds:[0A40Ah]
; @07A48 0000:7A48 original=894704 runtime CFG evidence
    mov word ptr ds:[bx + 4], ax
; @07A4B 0000:7A4B original=c7070100 runtime CFG evidence
    mov word ptr ds:[bx], 1
; @07A4F 0000:7A4F original=c7470a0000 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 0
; @07A54 0000:7A54 original=c747020000 runtime CFG evidence
    mov word ptr ds:[bx + 2], 0
; @07A59 0000:7A59 original=c747140200 runtime CFG evidence
    mov word ptr ds:[bx + 014h], 2
; @07A5E 0000:7A5E original=c747240000 runtime CFG evidence
    mov word ptr ds:[bx + 024h], 0
; @07A63 0000:7A63 original=c747200a00 runtime CFG evidence
    mov word ptr ds:[bx + 020h], 0Ah
; @07A68 0000:7A68 original=c74728ffff runtime CFG evidence
    mov word ptr ds:[bx + 028h], 0FFFFh
; @07A6D 0000:7A6D original=c3 runtime CFG evidence
    ret
; @07A6E 0000:7A6E original=e85807 runtime CFG evidence
    CALL_NEAR loc_081C9
; @07A71 0000:7A71 original=7501 runtime CFG evidence
    JNE_SHORT loc_07A74
; @07A73 0000:7A73 original=c3 runtime CFG evidence
    ret
; @07A74 0000:7A74 original=c747188b00 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 08Bh
; @07A79 0000:7A79 original=c3 runtime CFG evidence
    ret
; @07A7A 0000:7A7A original=e84c07 runtime CFG evidence
    CALL_NEAR loc_081C9
; @07A7D 0000:7A7D original=7501 runtime CFG evidence
    JNE_SHORT loc_07A80
; @07A7F 0000:7A7F original=c3 runtime CFG evidence
    ret
; @07A80 0000:7A80 original=c747188c00 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 08Ch
; @07A85 0000:7A85 original=c3 runtime CFG evidence
    ret
; @07A86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,015h,07h,075h,01h,0C3h,0C7h,047h,018h,08Eh,00h,0C3h,0E8h,034h,07h,075h
; @07A96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,0B8h,04h,00h,0A3h,07Ah,023h,0E8h,0A4h,0F9h,0C3h,0E8h,0F9h,06h,075h
; @07AA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,0C7h,047h,018h,08Dh,00h,0C3h
; @07AAE 0000:7AAE original=e81b07 runtime CFG evidence
    CALL_NEAR loc_081CC
; @07AB1 0000:7AB1 original=7501 runtime CFG evidence
    JNE_SHORT loc_07AB4
; @07AB3 0000:7AB3 original=c3 runtime CFG evidence
    ret
; @07AB4 0000:7AB4 original=c747182400 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 024h
; @07AB9 0000:7AB9 original=c747088f00 runtime CFG evidence
    mov word ptr ds:[bx + 8], 08Fh
; @07ABE 0000:7ABE original=c747060600 runtime CFG evidence
    mov word ptr ds:[bx + 6], 6
; @07AC3 0000:7AC3 original=c3 runtime CFG evidence
    ret
; @07AC4 0000:7AC4 original=e80507 runtime CFG evidence
    CALL_NEAR loc_081CC
; @07AC7 0000:7AC7 original=7501 runtime CFG evidence
    JNE_SHORT loc_07ACA
; @07AC9 0000:7AC9 original=c3 runtime CFG evidence
    ret
; @07ACA 0000:7ACA original=c747182500 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 025h
; @07ACF 0000:7ACF original=c747089000 runtime CFG evidence
    mov word ptr ds:[bx + 8], 090h
; @07AD4 0000:7AD4 original=c747060200 runtime CFG evidence
    mov word ptr ds:[bx + 6], 2
; @07AD9 0000:7AD9 original=c3 runtime CFG evidence
    ret
; @07ADA 0000:7ADA original=e8ef06 runtime CFG evidence
    CALL_NEAR loc_081CC
; @07ADD 0000:7ADD original=7501 runtime CFG evidence
    JNE_SHORT loc_07AE0
; @07ADF 0000:7ADF original=c3 runtime CFG evidence
    ret
; @07AE0 0000:7AE0 original=c747189000 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 090h
; @07AE5 0000:7AE5 original=c747088900 runtime CFG evidence
    mov word ptr ds:[bx + 8], 089h
; @07AEA 0000:7AEA original=c747060600 runtime CFG evidence
    mov word ptr ds:[bx + 6], 6
; @07AEF 0000:7AEF original=c3 runtime CFG evidence
    ret
; @07AF0 0000:7AF0 original=e8d906 runtime CFG evidence
    CALL_NEAR loc_081CC
; @07AF3 0000:7AF3 original=7501 runtime CFG evidence
    JNE_SHORT loc_07AF6
; @07AF5 0000:7AF5 original=c3 runtime CFG evidence
    ret
; @07AF6 0000:7AF6 original=c747189100 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 091h
; @07AFB 0000:7AFB original=c747088c00 runtime CFG evidence
    mov word ptr ds:[bx + 8], 08Ch
; @07B00 0000:7B00 original=c747060200 runtime CFG evidence
    mov word ptr ds:[bx + 6], 2
; @07B05 0000:7B05 original=c3 runtime CFG evidence
    ret
; @07B06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,030h,074h,09h,03Ch,0C4h,074h,056h,03Ch,05Ah,074h,042h,0C3h,0E8h,0Eh,0FAh
; @07B16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FBh,0FFh,075h,01h,0C3h,0C7h,047h,016h,04h,00h,0A1h,0Ah,0A4h,089h,047h
; @07B26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0C7h,07h,01h,00h,0C7h,047h,0Ah,00h,00h,0C7h,047h,02h,00h,00h,0C7h
; @07B36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,014h,02h,00h,0C7h,047h,024h,00h,00h,0C7h,047h,020h,0Ah,00h,0C7h,047h
; @07B46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,02Ah,00h,0C7h,047h,08h,01Ch,00h,0C7h,047h,06h,00h,00h,0C3h,0E8h,072h
; @07B56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,075h,01h,0C3h,0C7h,047h,018h,02Eh,00h,083h,06Fh,02h,06h,0C3h,0E8h,062h
; @07B66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,075h,01h,0C3h,0C7h,047h,018h,08Fh,00h,0C7h,047h,08h,0BFh,00h,0C7h,047h
; @07B76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,06h,00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,08h,0C2h,00h,0C7h
; @07B86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,06h,02h,00h,0C3h,0E8h,03Bh,06h,075h,01h,0C3h,083h,06Fh,04h,0Ch,0FFh
; @07B96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,04h,08Fh,047h,032h,0C7h,047h,06h,02h,00h,0C7h,047h,018h,073h,00h,0C7h
; @07BA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,04Ch,01h,0C3h,0E8h,01Bh,06h,075h,01h,0C3h,083h,047h,04h,0Ch,0FFh
; @07BB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,04h,08Fh,047h,032h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,074h,00h,0C7h
; @07BC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,04Fh,01h,0C3h,083h,03Eh,0Ah,0A4h,060h,077h,06h,03Ch,0BCh,074h,0B5h
; @07BD6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,04h,03Ch,0BBh,074h,0CFh,02Ch,0E1h,079h,01h,0C3h,03Ch,01Ah,076h,01h,0C3h
; @07BE6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h,01Eh,070h,020h
; @07BF6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ah,063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh,0FFh,0A7h,08h
; @07C06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ch,090h,0D7h,07Eh,0D7h,07Eh,043h,081h,037h,081h,086h,07Fh,086h,07Fh,05Dh,07Fh
; @07C16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 069h,07Fh,07Ah,07Fh,0EAh,07Fh,014h,07Fh,0FBh,07Fh,0A2h,07Ah,086h,07Ah,025h,07Fh
; @07C26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,07Fh,0ADh,07Fh,0EFh,080h,0EFh,080h,04Ch,080h,03Ah,07Ch,013h,081h,0F7h,079h
; @07C36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D6h,079h,092h,07Ah,026h,0C6h,04h,01h,0C3h,02Ch,0CEh,079h,01h,0C3h,03Ch,01Dh
; @07C46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,01h,0C3h,050h,08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h
; @07C56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,070h,020h,09Ah,063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh
; @07C66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0A7h,06Ah,07Ch,0B0h,07Eh,0B0h,07Eh,036h,07Fh,036h,07Fh,0B7h,080h,0B7h,080h
; @07C76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DEh,080h,07h,081h,06Eh,080h,0FEh,07Eh,04Ch,080h,072h,081h,088h,081h,01Fh,081h
; @07C86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,081h,07Ah,07Ah,06Eh,07Ah,0AFh,044h,013h,081h,0FBh,080h,02Ah,080h,0D4h,07Fh
; @07C96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,080h,0EFh,080h,0EFh,080h,08Bh,080h,03Bh,080h,02Bh,081h
; @07CA2 0000:7CA2 original=3cac runtime CFG evidence
    cmp al, 0ACh
; @07CA4 0000:7CA4 original=7503 runtime CFG evidence
    JNE_SHORT loc_07CA9
; @07CA6 0000:7CA6 original=e931fe runtime CFG evidence
    JMP_NEAR loc_07ADA
; @07CA9 0000:7CA9 original=3cb1 runtime CFG evidence
    cmp al, 0B1h
; @07CAB 0000:7CAB original=7503 runtime CFG evidence
    JNE_SHORT loc_07CB0
; @07CAD 0000:7CAD original=e940fe runtime CFG evidence
    JMP_NEAR loc_07AF0
; @07CB0 0000:7CB0 original=3cc9 runtime CFG evidence
    cmp al, 0C9h
; @07CB2 0000:7CB2 original=7503 runtime CFG evidence
    JNE_SHORT loc_07CB7
; @07CB4 0000:7CB4 original=e95afd runtime CFG evidence
    JMP_NEAR loc_07A11
; @07CB7 0000:7CB7 original=2cce runtime CFG evidence
    sub al, 0CEh
; @07CB9 0000:7CB9 original=7901 runtime CFG evidence
    JNS_SHORT loc_07CBC
; @07CBB 0000:7CBB original=c3 runtime CFG evidence
    ret
; @07CBC 0000:7CBC original=3c14 runtime CFG evidence
    cmp al, 014h
; @07CBE 0000:7CBE original=7601 runtime CFG evidence
    JBE_SHORT loc_07CC1
; @07CC0 0000:7CC0 original=c3 runtime CFG evidence
    ret
; @07CC1 0000:7CC1 original=50 runtime CFG evidence
    push ax
; @07CC2 0000:7CC2 original=8bde runtime CFG evidence
    mov bx, si
; @07CC4 0000:7CC4 original=83e33f runtime CFG evidence
    and bx, 03Fh
; @07CC7 0000:7CC7 original=8a9f1ac8 runtime CFG evidence
    mov bl, byte ptr ds:[bx - 037E6h]
; @07CCB 0000:7CCB original=32ff runtime CFG evidence
    xor bh, bh
; @07CCD 0000:7CCD original=891e7020 runtime CFG evidence
    mov word ptr ds:[02070h], bx
; @07CD1 0000:7CD1 original=9a63017f0f runtime CFG evidence
    CALL_FAR 0F7Fh,0163h
; @07CD6 0000:7CD6 original=58 runtime CFG evidence
    pop ax
; @07CD7 0000:7CD7 original=8ad8 runtime CFG evidence
    mov bl, al
; @07CD9 0000:7CD9 original=32ff runtime CFG evidence
    xor bh, bh
; @07CDB 0000:7CDB original=d1e3 runtime CFG evidence
    shl bx, 1
; @07CDD 0000:7CDD original=2effa7e27c runtime CFG evidence
    jmp word ptr cs:[bx + 07CE2h]
; @07CE2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ah,07Ah,06Eh,07Ah,072h,081h,088h,081h,02Ah,07Dh,04Dh,07Dh,06Eh,080h,025h,07Fh
; @07CF2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 013h,081h,04Ch,080h,07h,081h,0A1h,080h,08h,07Dh,019h,07Dh,0EFh,080h,043h,081h
; @07D02 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 037h,081h,02Bh,081h,0D4h,07Fh,0E8h,0BEh,04h,075h,01h,0C3h,0C7h,047h,018h,038h
; @07D12 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,06h,03h,00h,0C3h,0E8h,0ADh,04h,075h,01h,0C3h,0C7h,047h,018h
; @07D22 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 038h,00h,0C7h,047h,06h,05h,00h,0C3h,0E8h,09Ch,04h,075h,01h,0C3h,0C7h,047h
; @07D32 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,01h,00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,072h,01h,083h,03Eh,056h
; @07D42 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,04h,075h,01h,0C3h,0C7h,047h,08h,07Ah,01h,0C3h,0E8h,079h,04h,075h,01h
; @07D52 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,06h,07h,00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,073h,01h
; @07D62 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,04h,075h,01h,0C3h,0C7h,047h,08h,07Bh,01h,0C3h,0E8h,056h
; @07D72 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,075h,01h,0C3h,0C7h,047h,06h,00h,00h,0C7h,047h,018h,084h,00h,0C7h,047h
; @07D82 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,056h,01h,0C3h,0E8h,040h,04h,075h,01h,0C3h,0C7h,047h,06h,02h,00h,0C7h
; @07D92 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,018h,084h,00h,0C7h,047h,08h,057h,01h,0C3h,0E8h,02Ah,04h,075h,01h,0C3h
; @07DA2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,06h,04h,00h,0C7h,047h,018h,084h,00h,0C7h,047h,08h,058h,01h,0C3h
; @07DB2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,014h,04h,075h,01h,0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,084h,00h
; @07DC2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,059h,01h,0C3h,03Ch,030h,075h,03h,0E9h,044h,0FDh,03Ch,0BAh,074h
; @07DD2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Dh,03Ch,0BBh,074h,0AFh,03Ch,0BCh,074h,0C1h,03Ch,0B6h,074h,0D3h,03Ch,0D8h,075h
; @07DE2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,088h,0FCh,03Ch,0D7h,075h,03h,0E9h,08Dh,0FCh,03Ch,0D3h,075h,03h,0E9h
; @07DF2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E6h,0FCh,03Ch,0D2h,075h,03h,0E9h,0F5h,0FCh,02Ch,0D7h,079h,01h,0C3h,03Ch,01Ah
; @07E02 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,01h,0C3h,050h,08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h
; @07E12 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,070h,020h,09Ah,063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh
; @07E22 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0A7h,026h,07Eh,0A2h,07Ah,086h,07Ah,0BAh,079h,084h,07Eh,09Ah,07Eh,02Ah,07Dh
; @07E32 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,07Dh,0B7h,080h,0B7h,080h,0A1h,080h,058h,07Eh,058h,07Eh,0FEh,07Eh,06Eh,07Eh
; @07E42 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,081h,088h,081h,05Dh,07Eh,066h,081h,03Bh,080h,02Bh,081h,043h,081h,013h,081h
; @07E52 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,080h,02Ah,080h,0D4h,07Fh
; @07E58 0000:7E58 original=26c60401 runtime CFG evidence
    mov byte ptr es:[si], 1
; @07E5C 0000:7E5C original=c3 runtime CFG evidence
    ret
; @07E5D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,069h,03h,075h,01h,0C3h,0C7h,047h,018h,019h,00h,0C7h,047h,06h,02h,00h
; @07E6D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0E8h,058h,03h,075h,01h,0C3h,0C7h,047h,08h,046h,00h,0C7h,047h,018h,030h
; @07E7D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,06h,04h,00h,0C3h,0E8h,042h,03h,075h,01h,0C3h,0C7h,047h,018h
; @07E8D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 092h,00h,0C7h,047h,08h,05Ah,01h,0C7h,047h,06h,02h,00h,0C3h,0E8h,02Ch,03h
; @07E9D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,018h,092h,00h,0C7h,047h,08h,05Bh,01h,0C7h,047h,06h
; @07EAD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,00h,0C3h,0E8h,016h,03h,075h,01h,0C3h,0C7h,047h,06h,06h,00h,0C7h,047h
; @07EBD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,086h,00h,0C7h,047h,08h,0C8h,00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h
; @07ECD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,0DAh,00h,0C7h,047h,06h,02h,00h,0C3h,0E8h,0EFh,02h,075h,01h,0C3h
; @07EDD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,06h,06h,00h,0C7h,047h,018h,088h,00h,0C7h,047h,08h,0FDh,00h,083h
; @07EED UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,08h,0FAh,00h,0C7h,047h,06h,02h,00h
; @07EFD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0E8h,0C8h,02h,075h,01h,0C3h,0C7h,047h,06h,02h,00h,0C7h,047h,018h,063h
; @07F0D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,08h,0E7h,00h,0C3h,0E8h,087h,02h,075h,01h,0C3h,0C7h,047h,06h
; @07F1D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,0C7h,047h,018h,071h,00h,0C3h,0E8h,076h,02h,075h,01h,0C3h,0C7h,047h
; @07F2D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,04h,00h,0C7h,047h,018h,08Ah,00h,0C3h,0E8h,090h,02h,075h,01h,0C3h,0C7h
; @07F3D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,06h,07h,00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,0F5h,00h,083h,07Fh
; @07F4D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,060h,076h,01h,0C3h,0C7h,047h,06h,01h,00h,0C7h,047h,08h,0F4h,00h,0C3h
; @07F5D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,069h,02h,075h,01h,0C3h,0C7h,047h,018h,06Bh,00h,0C3h,0E8h,032h,02h,075h
; @07F6D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,0C7h,047h,018h,06Ch,00h,0C7h,047h,08h,023h,01h,0C3h,0E8h,04Ch,02h
; @07F7D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,018h,06Dh,00h,0C3h,0E8h,040h,02h,075h,01h,0C3h,0C7h
; @07F8D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,06h,05h,00h,0C7h,047h,018h,06Ah,00h,0C7h,047h,08h,01Eh,01h,083h,07Fh
; @07F9D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,060h,076h,01h,0C3h,0C7h,047h,06h,03h,00h,0C7h,047h,08h,01Dh,01h,0C3h
; @07FAD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,019h,02h,075h,01h,0C3h,0C7h,047h,06h,07h,00h,0C7h,047h,018h,054h,00h
; @07FBD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,043h,01h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,06h,01h
; @07FCD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,08h,044h,01h,0C3h,0E8h,0C7h,01h,075h,01h,0C3h,0C7h,047h,06h
; @07FDD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,0C7h,047h,018h,05Eh,00h,0C7h,047h,08h,027h,00h,0C3h,0E8h,0B1h,01h
; @07FED UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,06Eh,00h,0C3h,0E8h,0A0h
; @07FFD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,075h,01h
part03 ends
end
