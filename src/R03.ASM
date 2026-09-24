; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part03 segment byte public 'CODE'
assume cs:part03,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
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
loc_07524 equ 01528h
loc_0752B equ 0152Fh
loc_0753C equ 01540h
loc_07542 equ 01546h
loc_07550 equ 01554h
loc_07556 equ 0155Ah
loc_07568 equ 0156Ch
loc_07570 equ 01574h
loc_07573 equ 01577h
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
; @062F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,00h,00h,075h,03h,0E9h,020h,011h,083h,07Eh,02h,020h,07Dh,03h,0E9h
; @06306 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 017h,011h,083h,07Eh,016h,00h,075h,03h,0E9h,0Eh,011h,083h,07Eh,018h,00h,075h
; @06316 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,05h,011h,083h,07Eh,018h,01h,075h,03h,0E9h,0FCh,010h,083h,07Eh,018h
; @06326 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,075h,03h,0E9h,0F3h,010h,08Bh,076h,016h,08Bh,07Eh,0Ah,08Bh,056h,04h,083h
; @06336 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,0F8h,08Bh,04Eh,02h,083h,0E1h,0F8h,0BBh,05Ch,02Bh,083h,03Fh,00h,074h,077h
; @06346 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h
; @06356 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh
; @06366 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh
; @06376 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh
; @06386 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,038h,05Bh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,02Eh
; @06396 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Bh,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h
; @063A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,012h,05Bh,02Dh,08h,00h
; @063B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,08h,05Bh,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h
; @063C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh
; @063D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h
; @063E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h
; @063F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh
; @06406 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,0B9h,05Ah,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0AFh,05Ah
; @06416 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h
; @06426 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,093h,05Ah,02Dh,08h,00h,03Bh
; @06436 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,089h,05Ah,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh
; @06446 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h
; @06456 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h
; @06466 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h
; @06476 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h
; @06486 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,03Ah,05Ah,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,030h,05Ah,083h
; @06496 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h
; @064A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,014h,05Ah,02Dh,08h,00h,03Bh,0C1h
; @064B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,0Ah,05Ah,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh
; @064C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h
; @064D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh
; @064E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h
; @064F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h
; @06506 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0BBh,059h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0B1h,059h,083h,07Eh
; @06516 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h
; @06526 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,095h,059h,02Dh,08h,00h,03Bh,0C1h,075h
; @06536 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,08Bh,059h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h
; @06546 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h
; @06556 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h
; @06566 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh
; @06576 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h
; @06586 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,03Ch,059h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,032h,059h,083h,07Eh,014h
; @06596 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh
; @065A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C1h,075h,03h,0E9h,016h,059h,02Dh,08h,00h,03Bh,0C1h,075h,03h
; @065B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0Ch,059h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h
; @065C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh
; @065D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h
; @065E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h
; @065F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h
; @06606 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BDh,058h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0B3h,058h,083h,07Eh,014h,02h
; @06616 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h
; @06626 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C1h,075h,03h,0E9h,097h,058h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h
; @06636 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Dh,058h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h
; @06646 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h
; @06656 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h
; @06666 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h
; @06676 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,03Eh
; @06686 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 058h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,034h,058h,083h,07Eh,014h,02h,075h
; @06696 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h
; @066A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,018h,058h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0Eh
; @066B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 058h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh
; @066C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h
; @066D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h
; @066E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh
; @066F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0BFh,057h
; @06706 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0B5h,057h,083h,07Eh,014h,02h,075h,020h
; @06716 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh
; @06726 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,099h,057h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,08Fh,057h
; @06736 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h
; @06746 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h
; @06756 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh
; @06766 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h
; @06776 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,040h,057h,02Dh
; @06786 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C1h,075h,03h,0E9h,036h,057h,083h,07Eh,014h,02h,075h,020h,083h
; @06796 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h
; @067A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,01Ah,057h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,010h,057h,083h
; @067B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h
; @067C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh
; @067D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h
; @067E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h
; @067F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0C1h,056h,02Dh,08h
; @06806 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C1h,075h,03h,0E9h,0B7h,056h,083h,07Eh,014h,02h,075h,020h,083h,07Eh
; @06816 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h
; @06826 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,09Bh,056h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,091h,056h,083h,0C3h
; @06836 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h
; @06846 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h
; @06856 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h
; @06866 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh
; @06876 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,042h,056h,02Dh,08h,00h
; @06886 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,038h,056h,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h
; @06896 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h
; @068A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,01Ch,056h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,012h,056h,083h,0C3h,038h
; @068B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h
; @068C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h
; @068D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h
; @068E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh
; @068F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0C3h,055h,02Dh,08h,00h,03Bh
; @06906 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,0B9h,055h,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h
; @06916 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h
; @06926 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Dh,055h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,093h,055h,083h,0C3h,038h,083h
; @06936 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h
; @06946 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh
; @06956 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh
; @06966 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h
; @06976 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,044h,055h,02Dh,08h,00h,03Bh,0C1h
; @06986 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,03Ah,055h,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h
; @06996 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,01Eh
; @069A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,014h,055h,083h,0C3h,038h,083h,03Fh
; @069B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h
; @069C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h
; @069D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh
; @069E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h
; @069F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0C5h,054h,02Dh,08h,00h,03Bh,0C1h,075h
; @06A06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0BBh,054h,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah
; @06A16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,09Fh,054h
; @06A26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,095h,054h,083h,0C3h,038h,083h,03Fh,00h
; @06A36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh
; @06A46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h
; @06A56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h
; @06A66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h
; @06A76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,046h,054h,02Dh,08h,00h,03Bh,0C1h,075h,03h
; @06A86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,03Ch,054h,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h
; @06A96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,020h,054h,02Dh
; @06AA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C1h,075h,03h,0E9h,016h,054h,083h,0C3h,038h,083h,03Fh,00h,074h
; @06AB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h
; @06AC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh
; @06AD6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h
; @06AE6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h
; @06AF6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,03Bh,0C1h,075h,03h,0E9h,0C7h,053h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h
; @06B06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BDh,053h,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh
; @06B16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0A1h,053h,02Dh,08h
; @06B26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C1h,075h,03h,0E9h,097h,053h,083h,0C3h,038h,083h,03Fh,00h,074h,077h
; @06B36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h
; @06B46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh
; @06B56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh
; @06B66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh
; @06B76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,048h,053h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,03Eh
; @06B86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h
; @06B96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,022h,053h,02Dh,08h,00h
; @06BA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,018h,053h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h
; @06BB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh
; @06BC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h
; @06BD6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h
; @06BE6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh
; @06BF6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,0C9h,052h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0BFh,052h
; @06C06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h
; @06C16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0A3h,052h,02Dh,08h,00h,03Bh
; @06C26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,099h,052h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh
; @06C36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h
; @06C46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h
; @06C56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h
; @06C66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h
; @06C76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,04Ah,052h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,040h,052h,083h
; @06C86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h
; @06C96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,024h,052h,02Dh,08h,00h,03Bh,0C1h
; @06CA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,01Ah,052h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh
; @06CB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h
; @06CC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh
; @06CD6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h
; @06CE6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h
; @06CF6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0CBh,051h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0C1h,051h,083h,07Eh
; @06D06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h
; @06D16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0A5h,051h,02Dh,08h,00h,03Bh,0C1h,075h
; @06D26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,09Bh,051h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h
; @06D36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h
; @06D46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h
; @06D56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh
; @06D66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h
; @06D76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,04Ch,051h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,042h,051h,083h,07Eh,014h
; @06D86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh
; @06D96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C1h,075h,03h,0E9h,026h,051h,02Dh,08h,00h,03Bh,0C1h,075h,03h
; @06DA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,01Ch,051h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h
; @06DB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh
; @06DC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h
; @06DD6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h
; @06DE6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h
; @06DF6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,050h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0C3h,050h,083h,07Eh,014h,02h
; @06E06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h
; @06E16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C1h,075h,03h,0E9h,0A7h,050h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h
; @06E26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Dh,050h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h
; @06E36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h
; @06E46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h
; @06E56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h
; @06E66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,04Eh
; @06E76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,044h,050h,083h,07Eh,014h,02h,075h
; @06E86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h
; @06E96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,028h,050h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,01Eh
; @06EA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh
; @06EB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h
; @06EC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h
; @06ED6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh
; @06EE6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0CFh,04Fh
; @06EF6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0C5h,04Fh,083h,07Eh,014h,02h,075h,020h
; @06F06 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh
; @06F16 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,0A9h,04Fh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,09Fh,04Fh
; @06F26 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h
; @06F36 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h
; @06F46 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh
; @06F56 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h
; @06F66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,050h,04Fh,02Dh
; @06F76 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C1h,075h,03h,0E9h,046h,04Fh,083h,07Eh,014h,02h,075h,020h,083h
; @06F86 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h
; @06F96 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,02Ah,04Fh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,020h,04Fh,083h
; @06FA6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h
; @06FB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh
; @06FC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h
; @06FD6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h
; @06FE6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0D1h,04Eh,02Dh,08h
; @06FF6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C1h,075h,03h,0E9h,0C7h,04Eh,083h,07Eh,014h,02h,075h,020h,083h,07Eh
; @07006 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h
; @07016 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0ABh,04Eh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0A1h,04Eh,083h,0C3h
; @07026 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 038h,083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h
; @07036 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h
; @07046 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h
; @07056 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh
; @07066 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,052h,04Eh,02Dh,08h,00h
; @07076 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,048h,04Eh,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h
; @07086 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 078h,074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h
; @07096 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,02Ch,04Eh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,022h,04Eh,083h,0C3h,038h
; @070A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h
; @070B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h
; @070C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h
; @070D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Bh,02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh
; @070E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0D3h,04Dh,02Dh,08h,00h,03Bh
; @070F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,0C9h,04Dh,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h
; @07106 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h
; @07116 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,04Dh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0A3h,04Dh,083h,0C3h,038h,083h
; @07126 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Fh,00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h
; @07136 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh
; @07146 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh
; @07156 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h
; @07166 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,054h,04Dh,02Dh,08h,00h,03Bh,0C1h
; @07176 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,04Ah,04Dh,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h
; @07186 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,02Eh
; @07196 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,024h,04Dh,083h,0C3h,038h,083h,03Fh
; @071A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h
; @071B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Dh,025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h
; @071C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh
; @071D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h
; @071E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,0D5h,04Ch,02Dh,08h,00h,03Bh,0C1h,075h
; @071F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0CBh,04Ch,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah
; @07206 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0AFh,04Ch
; @07216 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0A5h,04Ch,083h,0C3h,038h,083h,03Fh,00h
; @07226 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh
; @07236 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h
; @07246 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Bh,02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h
; @07256 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h
; @07266 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F8h,0FFh,03Bh,0C1h,075h,03h,0E9h,056h,04Ch,02Dh,08h,00h,03Bh,0C1h,075h,03h
; @07276 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,04Ch,04Ch,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h
; @07286 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,030h,04Ch,02Dh
; @07296 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C1h,075h,03h,0E9h,026h,04Ch,083h,0C3h,038h,083h,03Fh,00h,074h
; @072A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h
; @072B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F8h,0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh
; @072C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h
; @072D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h
; @072E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,03Bh,0C1h,075h,03h,0E9h,0D7h,04Bh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h
; @072F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,04Bh,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh
; @07306 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0B1h,04Bh,02Dh,08h
; @07316 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C1h,075h,03h,0E9h,0A7h,04Bh,083h,0C3h,038h,083h,03Fh,00h,074h,077h
; @07326 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h
; @07336 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh
; @07346 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh
; @07356 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh
; @07366 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,058h,04Bh,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,04Eh
; @07376 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Bh,083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h
; @07386 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 079h,074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,032h,04Bh,02Dh,08h,00h
; @07396 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,0C1h,075h,03h,0E9h,028h,04Bh,083h,0C3h,038h,083h,03Fh,00h,074h,077h,083h
; @073A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,01Eh,00h,074h,071h,08Bh,047h,04h,0A9h,07h,00h,074h,0Dh,025h,0F8h,0FFh
; @073B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,08h,00h,03Bh,0C2h,074h,022h,02Dh,08h,00h,03Bh,0C2h,074h,01Bh,02Dh,08h
; @073C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03Bh,0C2h,074h,014h,083h,07Eh,014h,02h,075h,04Bh,02Dh,08h,00h,03Bh,0C2h
; @073D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,02Dh,08h,00h,03Bh,0C2h,075h,03Dh,08Bh,047h,02h,025h,0F8h,0FFh,03Bh
; @073E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,0D9h,04Ah,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0CFh,04Ah
; @073F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,014h,02h,075h,020h,083h,07Eh,018h,078h,074h,01Ah,083h,07Eh,018h,079h
; @07406 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,014h,02Dh,08h,00h,03Bh,0C1h,075h,03h,0E9h,0B3h,04Ah,02Dh,08h,00h,03Bh
; @07416 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,075h,03h,0E9h,0A9h,04Ah,083h,0C3h,038h,0C3h
; sub_0000_7420
; @07420 0000:7420 original=e80101
    CALL_NEAR loc_07524
; @07423 0000:7423 original=83fbff
    cmp bx, -1
; @07426 0000:7426 original=7501
    JNE_SHORT loc_07429
; @07428 0000:7428 original=c3
    ret
; @07429 0000:7429 original=c7070100
    mov word ptr ds:[bx], 1
; @0742D 0000:742D original=a17823
    mov ax, word ptr ds:[02378h]
; @07430 0000:7430 original=030678a2
    add ax, word ptr ds:[0A278h]
; @07434 0000:7434 original=894702
    mov word ptr ds:[bx + 2], ax
; @07437 0000:7437 original=a17623
    mov ax, word ptr ds:[02376h]
; @0743A 0000:743A original=3dc000
    cmp ax, 0C0h
; @0743D 0000:743D original=7603
    JBE_SHORT loc_07442
; @0743F 0000:743F original=b8c000
    mov ax, 0C0h
; @07442 0000:7442 original=894704
    mov word ptr ds:[bx + 4], ax
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
; @07476 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0FAh,00h,083h,0FBh,0FFh,075h,01h,0C3h,080h,03Eh,0C0h,098h,00h,074h,05h
; @07486 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,06h,0FFh,0BEh,01Ah,0B9h,0Ch,00h,0BAh,0Ch,00h,083h,03Eh,0C2h,0A8h,01h
; @07496 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,06h,0B9h,01Ch,00h,0BAh,08h,00h,08Bh,046h,04h,03h,0C1h,089h,047h,04h
; @074A6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,02h,03h,0C2h,089h,047h,02h,0E8h,04h,00h,0E8h,02Eh,00h,0C3h,0C7h
; @074B6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,01h,00h,0C7h,047h,01Eh,00h,00h,0C7h,047h,06h,00h,00h,0C7h,047h,08h
; @074C6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 031h,00h,0C7h,047h,0Ah,01h,00h,0C7h,047h,014h,00h,00h,0C7h,047h,016h,02h
; @074D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,018h,0Bh,00h,0C7h,047h,01Ch,0FFh,0FFh,0C3h,08Bh,047h,04h,08Bh
; @074E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Eh,080h,023h,083h,0C1h,09h,02Bh,0C1h,089h,047h,02Ch,08Bh,047h,02h,08Bh,0Eh
; @074F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,023h,02Bh,0C1h,089h,047h,02Ah,0C3h,0E8h,023h,00h,083h,0FBh,0FFh,074h,01h
; @07506 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0B9h,023h,00h,0BBh,0B4h,023h,083h,07Fh,016h,06h,074h,06h,083h,07Fh,016h
; @07516 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,075h,08h,083h,0C3h,038h,0E2h,0EFh,0BBh,0B4h,023h,0E9h,0E9h,047h
; sub_0000_7524
; @07524 0000:7524 original=b92300
    mov cx, 023h
; @07527 0000:7527 original=8b1ed895
    mov bx, word ptr ds:[095D8h]
; @0752B 0000:752B original=833f00
    cmp word ptr ds:[bx], 0
; @0752E 0000:752E original=7412
    JE_SHORT loc_07542
; @07530 0000:7530 original=83c338
    add bx, 038h
; @07533 0000:7533 original=81fb5c2b
    cmp bx, 02B5Ch
; @07537 0000:7537 original=7503
    JNE_SHORT loc_0753C
; @07539 0000:7539 original=bbb423
    mov bx, 023B4h
; @0753C 0000:753C original=e2ed
    LOOP_SHORT loc_0752B
; @0753E 0000:753E original=bbffff
    mov bx, 0FFFFh
; @07541 0000:7541 original=c3
    ret
; @07542 0000:7542 original=891ed895
    mov word ptr ds:[095D8h], bx
; @07546 0000:7546 original=c3
    ret
; sub_0000_7547
; @07547 0000:7547 original=e82900
    CALL_NEAR loc_07573
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
; @07573 0000:7573 original=b92200
    mov cx, 022h
; @07576 0000:7576 original=8b1eda95
    mov bx, word ptr ds:[095DAh]
; @0757A 0000:757A original=81fbcc32
    cmp bx, 032CCh
; @0757E 0000:757E original=7503
    JNE_SHORT loc_07583
; @07580 0000:7580 original=bb5c2b
    mov bx, 02B5Ch
; @07583 0000:7583 original=833f00
    cmp word ptr ds:[bx], 0
; @07586 0000:7586 original=7409
    JE_SHORT loc_07591
; @07588 0000:7588 original=83c338
    add bx, 038h
; @0758B 0000:758B original=e2ed
    LOOP_SHORT loc_0757A
; @0758D 0000:758D original=bbffff
    mov bx, 0FFFFh
; @07590 0000:7590 original=c3
    ret
; @07591 0000:7591 original=891eda95
    mov word ptr ds:[095DAh], bx
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
    db 046h,077h,08Eh,076h,0A6h,075h,08Bh,05Eh,08h,02Eh,08Bh,0Eh,0A6h,095h,083h,0FBh
; @075B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ch,072h,08h,083h,0EBh,01Ch,02Eh,08Bh,0Eh,0AEh,095h,0D1h,0E3h,081h,0C3h,092h
; @075C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 093h,02Eh,08Bh,037h,02Eh,089h,036h,024h,076h,02Eh,089h,0Eh,026h,076h,08Bh,07Eh
; @075D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,083h,0FFh,0FFh,074h,05h,055h,0E8h,01Bh,00h,05Dh,08Bh,07Eh,010h,083h,0FFh
; @075E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,075h,01h,0C3h,02Eh,08Bh,036h,024h,076h,02Eh,08Bh,0Eh,026h,076h,0A1h,028h
; @075F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,0D1h,0E8h,03h,0F0h,02Eh,08Eh,06h,098h,095h,02Eh,08Bh,01Eh,0BCh,095h,0D1h
; @07600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E3h,0D1h,0E3h,0D1h,0E3h,03h,05Eh,012h,0BAh,058h,076h,0F7h,046h,024h,0FFh,0FFh
; @07610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0BAh,028h,076h,0D1h,0E3h,03h,0DAh,08Eh,0D9h,0BDh,010h,00h,08Bh,0CDh
; @07620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,0FFh,027h,090h,00h,00h,00h,00h,049h,038h,026h,039h,0DFh,039h,0EEh,03Ah
; @07630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h,088h,076h,03Ch,010h,0EDh,010h,0B8h,011h,0B6h,012h
; @07640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E7h,013h,04Bh,015h,07Ch,016h,07Ah,017h,06Eh,02Eh,088h,076h,088h,076h,088h,076h
; @07650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h,088h,076h,07Ch,038h,053h,03Ch,0BCh,03Ch,052h,03Dh
; @07660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h,088h,076h,0B7h,010h,045h,018h,099h,018h,0F7h,018h
; @07670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Fh,019h,0D1h,019h,039h,01Ah,097h,01Ah,0CBh,02Eh,088h,076h,088h,076h,088h,076h
; @07680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h,088h,076h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,07Eh
; @07690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,083h,0FFh,0FFh,075h,01h,0C3h,02Eh,08Eh,06h,098h,095h,08Bh,05Eh,08h,02Eh
; @076A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0Eh,0AAh,095h,081h,0FBh,0FAh,00h,072h,09h,081h,0EBh,0FAh,00h,02Eh,08Bh
; @076B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Eh,0ACh,095h,0D1h,0E3h,081h,0C3h,092h,091h,02Eh,08Bh,037h,02Eh,08Bh,01Eh,0BCh
; @076C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0D1h,0E3h,0D1h,0E3h,0D1h,0E3h,03h,05Eh,012h,0BAh,016h,077h,0F7h,046h,024h
; @076D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,075h,03h,0BAh,0E6h,076h,0D1h,0E3h,03h,0DAh,08Eh,0D9h,0BDh,010h,00h
; @076E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0CDh,02Eh,0FFh,027h,090h,0B7h,038h,012h,03Eh,070h,03Eh,0FBh,03Eh,088h,076h
; @076F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h,0EBh,01Ah,04Fh,01Bh,0C6h,01Bh,061h,01Ch,01Bh,01Dh
; @07700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F4h,01Dh,0AEh,01Eh,049h,01Fh,081h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h
; @07710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h,0D6h,038h,0B0h,03Fh,0EBh,03Fh,03Ah,040h,088h,076h
; @07720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h,02Eh,01Bh,0C0h,01Fh,0FBh,01Fh,03Ch,020h,083h,020h
; @07730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,020h,017h,021h,058h,021h,040h,02Fh,088h,076h,088h,076h,088h,076h,088h,076h
; @07740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,076h,088h,076h,088h,076h
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
; @07977 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,04h,075h,03h,0E9h,0F0h,00h,03Ch,07h,075h,03h,0E9h,0F5h,00h,03Ch,06Ch
; @07987 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,022h,01h,03Ch,06Dh,075h,03h,0E9h,031h,01h,03Ch,0ACh,075h,03h
; @07997 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,040h,01h,03Ch,0B1h,075h,03h,0E9h,04Fh,01h,03Ch,0C9h,074h,06Ch,0C3h,026h
; @079A7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,04h,01h,026h,0C6h,044h,01h,01h,026h,0C6h,044h,0Dh,01h,026h,0C6h,044h
; @079B7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Eh,01h,0C3h,0E8h,0E9h,0FFh,0E8h,064h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h,0E8h
; @079C7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,00h,0C7h,047h,018h,048h,00h,0C7h,047h,06h,04h,00h,0E9h,0D1h,07h,0E8h
; @079D7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,0FFh,0E8h,048h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h,0E8h,05Bh,00h,0C7h,047h
; @079E7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,075h,00h,0C7h,047h,08h,024h,00h,0C7h,047h,06h,04h,00h,0E9h,0B0h,07h
; @079F7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0ACh,0FFh,0E8h,027h,0FBh,083h,0FBh,0FFh,075h,01h,0C3h,0E8h,03Ah,00h,0C7h
; @07A07 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,018h,072h,00h,0C7h,047h,06h,04h,00h,0C3h,026h,0C6h,044h,0Dh,026h,026h
; @07A17 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,044h,0Eh,027h,026h,0C6h,04h,028h,026h,0C6h,044h,01h,029h,0E8h,0FDh,0FAh
; @07A27 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FBh,0FFh,075h,01h,0C3h,0E8h,010h,00h,0C7h,047h,018h,028h,00h,0C7h,047h
; @07A37 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,01Ch,00h,0C7h,047h,06h,00h,00h,0C3h,0C7h,047h,016h,04h,00h,0A1h,0Ah
; @07A47 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,089h,047h,04h,0C7h,07h,01h,00h,0C7h,047h,0Ah,00h,00h,0C7h,047h,02h
; @07A57 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0C7h,047h,014h,02h,00h,0C7h,047h,024h,00h,00h,0C7h,047h,020h,0Ah
; @07A67 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,028h,0FFh,0FFh,0C3h,0E8h,058h,07h,075h,01h,0C3h,0C7h,047h,018h
; @07A77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,00h,0C3h,0E8h,04Ch,07h,075h,01h,0C3h,0C7h,047h,018h,08Ch,00h,0C3h,0E8h
; @07A87 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,07h,075h,01h,0C3h,0C7h,047h,018h,08Eh,00h,0C3h,0E8h,034h,07h,075h,01h
; @07A97 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0B8h,04h,00h,0A3h,07Ah,023h,0E8h,0A4h,0F9h,0C3h,0E8h,0F9h,06h,075h,01h
; @07AA7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,018h,08Dh,00h,0C3h,0E8h,01Bh,07h,075h,01h,0C3h,0C7h,047h,018h
; @07AB7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,00h,0C7h,047h,08h,08Fh,00h,0C7h,047h,06h,06h,00h,0C3h,0E8h,05h,07h
; @07AC7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,018h,025h,00h,0C7h,047h,08h,090h,00h,0C7h,047h,06h
; @07AD7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,0C3h,0E8h,0EFh,06h,075h,01h,0C3h,0C7h,047h,018h,090h,00h,0C7h,047h
; @07AE7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,089h,00h,0C7h,047h,06h,06h,00h,0C3h,0E8h,0D9h,06h,075h,01h,0C3h,0C7h
; @07AF7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,018h,091h,00h,0C7h,047h,08h,08Ch,00h,0C7h,047h,06h,02h,00h,0C3h,03Ch
; @07B07 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,074h,09h,03Ch,0C4h,074h,056h,03Ch,05Ah,074h,042h,0C3h,0E8h,0Eh,0FAh,083h
; @07B17 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0FFh,075h,01h,0C3h,0C7h,047h,016h,04h,00h,0A1h,0Ah,0A4h,089h,047h,04h
; @07B27 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,07h,01h,00h,0C7h,047h,0Ah,00h,00h,0C7h,047h,02h,00h,00h,0C7h,047h
; @07B37 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,02h,00h,0C7h,047h,024h,00h,00h,0C7h,047h,020h,0Ah,00h,0C7h,047h,018h
; @07B47 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ah,00h,0C7h,047h,08h,01Ch,00h,0C7h,047h,06h,00h,00h,0C3h,0E8h,072h,06h
; @07B57 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,018h,02Eh,00h,083h,06Fh,02h,06h,0C3h,0E8h,062h,06h
; @07B67 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,018h,08Fh,00h,0C7h,047h,08h,0BFh,00h,0C7h,047h,06h
; @07B77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,08h,0C2h,00h,0C7h,047h
; @07B87 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,02h,00h,0C3h,0E8h,03Bh,06h,075h,01h,0C3h,083h,06Fh,04h,0Ch,0FFh,077h
; @07B97 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,08Fh,047h,032h,0C7h,047h,06h,02h,00h,0C7h,047h,018h,073h,00h,0C7h,047h
; @07BA7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,04Ch,01h,0C3h,0E8h,01Bh,06h,075h,01h,0C3h,083h,047h,04h,0Ch,0FFh,077h
; @07BB7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,08Fh,047h,032h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,074h,00h,0C7h,047h
; @07BC7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,04Fh,01h,0C3h,083h,03Eh,0Ah,0A4h,060h,077h,06h,03Ch,0BCh,074h,0B5h,0EBh
; @07BD7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,03Ch,0BBh,074h,0CFh,02Ch,0E1h,079h,01h,0C3h,03Ch,01Ah,076h,01h,0C3h,050h
; @07BE7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h,01Eh,070h,020h,09Ah
; @07BF7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh,0FFh,0A7h,08h,07Ch
; @07C07 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0D7h,07Eh,0D7h,07Eh,043h,081h,037h,081h,086h,07Fh,086h,07Fh,05Dh,07Fh,069h
; @07C17 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,07Ah,07Fh,0EAh,07Fh,014h,07Fh,0FBh,07Fh,0A2h,07Ah,086h,07Ah,025h,07Fh,0ADh
; @07C27 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,0ADh,07Fh,0EFh,080h,0EFh,080h,04Ch,080h,03Ah,07Ch,013h,081h,0F7h,079h,0D6h
; @07C37 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 079h,092h,07Ah,026h,0C6h,04h,01h,0C3h,02Ch,0CEh,079h,01h,0C3h,03Ch,01Dh,076h
; @07C47 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,050h,08Bh,0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h,01Eh
; @07C57 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,020h,09Ah,063h,01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh,0FFh
; @07C67 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A7h,06Ah,07Ch,0B0h,07Eh,0B0h,07Eh,036h,07Fh,036h,07Fh,0B7h,080h,0B7h,080h,0DEh
; @07C77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,07h,081h,06Eh,080h,0FEh,07Eh,04Ch,080h,072h,081h,088h,081h,01Fh,081h,066h
; @07C87 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,07Ah,07Ah,06Eh,07Ah,0AFh,044h,013h,081h,0FBh,080h,02Ah,080h,0D4h,07Fh,0A1h
; @07C97 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,0EFh,080h,0EFh,080h,08Bh,080h,03Bh,080h,02Bh,081h,03Ch,0ACh,075h,03h,0E9h
; @07CA7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 031h,0FEh,03Ch,0B1h,075h,03h,0E9h,040h,0FEh,03Ch,0C9h,075h,03h,0E9h,05Ah,0FDh
; @07CB7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ch,0CEh,079h,01h,0C3h,03Ch,014h,076h,01h,0C3h,050h,08Bh,0DEh,083h,0E3h,03Fh
; @07CC7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h,01Eh,070h,020h,09Ah,063h,01h,07Fh,0Fh,058h
; @07CD7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh,0FFh,0A7h,0E2h,07Ch,07Ah,07Ah,06Eh,07Ah,072h
; @07CE7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,088h,081h,02Ah,07Dh,04Dh,07Dh,06Eh,080h,025h,07Fh,013h,081h,04Ch,080h,07h
; @07CF7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,0A1h,080h,08h,07Dh,019h,07Dh,0EFh,080h,043h,081h,037h,081h,02Bh,081h,0D4h
; @07D07 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,0E8h,0BEh,04h,075h,01h,0C3h,0C7h,047h,018h,038h,00h,0C7h,047h,06h,03h
; @07D17 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C3h,0E8h,0ADh,04h,075h,01h,0C3h,0C7h,047h,018h,038h,00h,0C7h,047h,06h
; @07D27 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,0C3h,0E8h,09Ch,04h,075h,01h,0C3h,0C7h,047h,06h,01h,00h,0C7h,047h
; @07D37 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,054h,00h,0C7h,047h,08h,072h,01h,083h,03Eh,056h,023h,04h,075h,01h,0C3h
; @07D47 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,07Ah,01h,0C3h,0E8h,079h,04h,075h,01h,0C3h,0C7h,047h,06h,07h
; @07D57 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,073h,01h,083h,03Eh,056h,023h,04h
; @07D67 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,08h,07Bh,01h,0C3h,0E8h,056h,04h,075h,01h,0C3h,0C7h
; @07D77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,06h,00h,00h,0C7h,047h,018h,084h,00h,0C7h,047h,08h,056h,01h,0C3h,0E8h
; @07D87 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,04h,075h,01h,0C3h,0C7h,047h,06h,02h,00h,0C7h,047h,018h,084h,00h,0C7h
; @07D97 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,057h,01h,0C3h,0E8h,02Ah,04h,075h,01h,0C3h,0C7h,047h,06h,04h,00h
; @07DA7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,018h,084h,00h,0C7h,047h,08h,058h,01h,0C3h,0E8h,014h,04h,075h,01h
; @07DB7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,084h,00h,0C7h,047h,08h,059h,01h
; @07DC7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,03Ch,030h,075h,03h,0E9h,044h,0FDh,03Ch,0BAh,074h,09Dh,03Ch,0BBh,074h,0AFh
; @07DD7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,0BCh,074h,0C1h,03Ch,0B6h,074h,0D3h,03Ch,0D8h,075h,03h,0E9h,088h,0FCh,03Ch
; @07DE7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D7h,075h,03h,0E9h,08Dh,0FCh,03Ch,0D3h,075h,03h,0E9h,0E6h,0FCh,03Ch,0D2h,075h
; @07DF7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0F5h,0FCh,02Ch,0D7h,079h,01h,0C3h,03Ch,01Ah,076h,01h,0C3h,050h,08Bh
; @07E07 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DEh,083h,0E3h,03Fh,08Ah,09Fh,01Ah,0C8h,032h,0FFh,089h,01Eh,070h,020h,09Ah,063h
; @07E17 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,07Fh,0Fh,058h,08Ah,0D8h,032h,0FFh,0D1h,0E3h,02Eh,0FFh,0A7h,026h,07Eh,0A2h
; @07E27 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ah,086h,07Ah,0BAh,079h,084h,07Eh,09Ah,07Eh,02Ah,07Dh,04Dh,07Dh,0B7h,080h,0B7h
; @07E37 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,0A1h,080h,058h,07Eh,058h,07Eh,0FEh,07Eh,06Eh,07Eh,072h,081h,088h,081h,05Dh
; @07E47 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,066h,081h,03Bh,080h,02Bh,081h,043h,081h,013h,081h,0FBh,080h,02Ah,080h,0D4h
; @07E57 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,026h,0C6h,04h,01h,0C3h,0E8h,069h,03h,075h,01h,0C3h,0C7h,047h,018h,019h
; @07E67 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,06h,02h,00h,0C3h,0E8h,058h,03h,075h,01h,0C3h,0C7h,047h,08h
; @07E77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,00h,0C7h,047h,018h,030h,00h,0C7h,047h,06h,04h,00h,0C3h,0E8h,042h,03h
; @07E87 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,018h,092h,00h,0C7h,047h,08h,05Ah,01h,0C7h,047h,06h
; @07E97 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,0C3h,0E8h,02Ch,03h,075h,01h,0C3h,0C7h,047h,018h,092h,00h,0C7h,047h
; @07EA7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,05Bh,01h,0C7h,047h,06h,06h,00h,0C3h,0E8h,016h,03h,075h,01h,0C3h,0C7h
; @07EB7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,06h,06h,00h,0C7h,047h,018h,086h,00h,0C7h,047h,08h,0C8h,00h,083h,07Fh
; @07EC7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,060h,076h,01h,0C3h,0C7h,047h,08h,0DAh,00h,0C7h,047h,06h,02h,00h,0C3h
; @07ED7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0EFh,02h,075h,01h,0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,088h,00h
; @07EE7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,0FDh,00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,08h,0FAh
; @07EF7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,06h,02h,00h,0C3h,0E8h,0C8h,02h,075h,01h,0C3h,0C7h,047h,06h
; @07F07 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,0C7h,047h,018h,063h,00h,0C7h,047h,08h,0E7h,00h,0C3h,0E8h,087h,02h
; @07F17 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,071h,00h,0C3h,0E8h,076h
; @07F27 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,08Ah,00h,0C3h,0E8h
; @07F37 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,02h,075h,01h,0C3h,0C7h,047h,06h,07h,00h,0C7h,047h,018h,054h,00h,0C7h
; @07F47 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,0F5h,00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,06h,01h,00h
; @07F57 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,0F4h,00h,0C3h,0E8h,069h,02h,075h,01h,0C3h,0C7h,047h,018h,06Bh
; @07F67 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C3h,0E8h,032h,02h,075h,01h,0C3h,0C7h,047h,018h,06Ch,00h,0C7h,047h,08h
; @07F77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,01h,0C3h,0E8h,04Ch,02h,075h,01h,0C3h,0C7h,047h,018h,06Dh,00h,0C3h,0E8h
; @07F87 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,02h,075h,01h,0C3h,0C7h,047h,06h,05h,00h,0C7h,047h,018h,06Ah,00h,0C7h
; @07F97 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,01Eh,01h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,06h,03h,00h
; @07FA7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,01Dh,01h,0C3h,0E8h,019h,02h,075h,01h,0C3h,0C7h,047h,06h,07h
; @07FB7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,018h,054h,00h,0C7h,047h,08h,043h,01h,083h,07Fh,04h,060h,076h
; @07FC7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,0C7h,047h,06h,01h,00h,0C7h,047h,08h,044h,01h,0C3h,0E8h,0C7h,01h
; @07FD7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,05Eh,00h,0C7h,047h,08h
; @07FE7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 027h,00h,0C3h,0E8h,0B1h,01h,075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h
; @07FF7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,06Eh,00h,0C3h,0E8h,0A0h,01h,075h,01h
part03 ends
end
