; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part00 segment byte public 'CODE'
assume cs:part00,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
BuildByteToNibbleMaskTable_00FE4 equ 0FE4h
IncrementByteCS066B_0066C equ 066Ch
ReadBufferedByte_00624 equ 0624h
ReadBufferedWordLE_00615 equ 0615h
WaitByteCS066B_00679 equ 0679h
loc_00001 equ 01h
loc_00030 equ 030h
loc_00046 equ 046h
loc_00068 equ 068h
loc_0008A equ 08Ah
loc_000E8 equ 0E8h
loc_000FF equ 0FFh
loc_0010F equ 010Fh
loc_00111 equ 0111h
loc_0011B equ 011Bh
loc_00136 equ 0136h
loc_0013F equ 013Fh
loc_00151 equ 0151h
loc_0017B equ 017Bh
loc_0017E equ 017Eh
loc_00196 equ 0196h
loc_001A1 equ 01A1h
loc_001AC equ 01ACh
loc_001B7 equ 01B7h
loc_001C2 equ 01C2h
loc_001CD equ 01CDh
loc_001CE equ 01CEh
loc_001EE equ 01EEh
loc_001F9 equ 01F9h
loc_00209 equ 0209h
loc_00214 equ 0214h
loc_00227 equ 0227h
loc_00230 equ 0230h
loc_00239 equ 0239h
loc_00295 equ 0295h
loc_0029C equ 029Ch
loc_002A3 equ 02A3h
loc_002A8 equ 02A8h
loc_002B2 equ 02B2h
loc_002B7 equ 02B7h
loc_002C3 equ 02C3h
loc_002D0 equ 02D0h
loc_002DE equ 02DEh
loc_002F2 equ 02F2h
loc_002FF equ 02FFh
loc_0030E equ 030Eh
loc_00324 equ 0324h
loc_00331 equ 0331h
loc_00344 equ 0344h
loc_0034D equ 034Dh
loc_00350 equ 0350h
loc_0035A equ 035Ah
loc_00367 equ 0367h
loc_0036F equ 036Fh
loc_00379 equ 0379h
loc_00386 equ 0386h
loc_00391 equ 0391h
loc_003A8 equ 03A8h
loc_003C8 equ 03C8h
loc_003CA equ 03CAh
loc_003DE equ 03DEh
loc_003F0 equ 03F0h
loc_00407 equ 0407h
loc_0064D equ 064Dh
loc_00651 equ 0651h
loc_0065C equ 065Ch
loc_0066A equ 066Ah
loc_0068A equ 068Ah
loc_006C4 equ 06C4h
loc_00704 equ 0704h
loc_00716 equ 0716h
loc_0072F equ 072Fh
loc_00744 equ 0744h
loc_00752 equ 0752h
loc_0075F equ 075Fh
loc_0078C equ 078Ch
loc_007C4 equ 07C4h
loc_007D0 equ 07D0h
loc_007D7 equ 07D7h
loc_007EF equ 07EFh
loc_0084C equ 084Ch
loc_0084F equ 084Fh
loc_00854 equ 0854h
loc_0085A equ 085Ah
loc_00869 equ 0869h
loc_0087F equ 087Fh
loc_008F1 equ 08F1h
loc_00915 equ 0915h
loc_00939 equ 0939h
loc_0095D equ 095Dh
loc_00981 equ 0981h
loc_009A5 equ 09A5h
loc_009C5 equ 09C5h
loc_00A6B equ 0A6Bh
loc_00A8A equ 0A8Ah
loc_00AF1 equ 0AF1h
loc_00B15 equ 0B15h
loc_00B39 equ 0B39h
loc_00B7F equ 0B7Fh
loc_00B8E equ 0B8Eh
loc_00BAB equ 0BABh
loc_00BB9 equ 0BB9h
loc_00CB8 equ 0CB8h
loc_00CC8 equ 0CC8h
loc_00CD8 equ 0CD8h
loc_00CF6 equ 0CF6h
loc_00D0E equ 0D0Eh
loc_00D1D equ 0D1Dh
loc_00D2E equ 0D2Eh
loc_00DE3 equ 0DE3h
loc_00E23 equ 0E23h
loc_00E27 equ 0E27h
loc_00E39 equ 0E39h
loc_00E49 equ 0E49h
loc_00E51 equ 0E51h
loc_00E6B equ 0E6Bh
loc_00E6D equ 0E6Dh
loc_00E89 equ 0E89h
loc_00E91 equ 0E91h
loc_00F31 equ 0F31h
loc_00F49 equ 0F49h
loc_00F59 equ 0F59h
loc_00F69 equ 0F69h
loc_00F8B equ 0F8Bh
loc_00FA0 equ 0FA0h
loc_00FAD equ 0FADh
loc_00FBC equ 0FBCh
loc_00FCB equ 0FCBh
loc_00FDA equ 0FDAh
loc_00FEE equ 0FEEh
loc_00FF8 equ 0FF8h
loc_00FFE equ 0FFEh
loc_01009 equ 01009h
loc_0100F equ 0100Fh
loc_0101A equ 0101Ah
loc_01020 equ 01020h
loc_0102B equ 0102Bh
loc_01031 equ 01031h
loc_04E75 equ 04E75h
loc_050AB equ 050ABh
loc_050C9 equ 050C9h
loc_05145 equ 05145h
loc_0526A equ 0526Ah
loc_0553D equ 0553Dh
loc_05A00 equ 05A00h
loc_05BAC equ 05BACh
loc_05CB7 equ 05CB7h
loc_05D14 equ 05D14h
loc_06176 equ 06176h
loc_077DF equ 077DFh
loc_0859E equ 0859Eh
loc_0C57C equ 0C57Ch
loc_0C679 equ 0C679h
loc_0CB1C equ 0CB1Ch
loc_0CB3E equ 0CB3Eh
loc_0D50E equ 0D50Eh
; @00000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h
; @00001 0000:0001 original=8b260e00
    mov sp, word ptr ds:[0Eh]
; @00005 0000:0005 original=c606bf9800
    mov byte ptr ds:[098BFh], 0
; @0000A 0000:000A original=c70610000000
    mov word ptr ds:[010h], 0
; @00010 0000:0010 original=c3
    ret
; sub_0000_0011
; @00011 0000:0011 original=89260e00
    mov word ptr ds:[0Eh], sp
; @00015 0000:0015 original=c70610000100
    mov word ptr ds:[010h], 1
; @0001B 0000:001B original=c70614000100
    mov word ptr ds:[014h], 1
; @00021 0000:0021 original=e80c00
    CALL_NEAR loc_00030
; @00024 0000:0024 original=c70610000100
    mov word ptr ds:[010h], 1
; @0002A 0000:002A original=c606bf9800
    mov byte ptr ds:[098BFh], 0
; @0002F 0000:002F original=c3
    ret
; sub_0000_0030
; @00030 0000:0030 original=c70612000100
    mov word ptr ds:[012h], 1
; @00036 0000:0036 original=c606bf9800
    mov byte ptr ds:[098BFh], 0
; @0003B 0000:003B original=b8bebe
    mov ax, 0BEBEh
; @0003E 0000:003E original=9a80097f0f
    CALL_FAR 0F7Fh,0980h
; @00043 0000:0043 original=e8f000
    CALL_NEAR loc_00136
; @00046 0000:0046 original=e8c800
    CALL_NEAR loc_00111
; @00049 0000:0049 original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @0004E 0000:004E original=75f6
    JNE_SHORT loc_00046
; @00050 0000:0050 original=e89500
    CALL_NEAR loc_000E8
; @00053 0000:0053 original=891e4600
    mov word ptr ds:[046h], bx
; @00057 0000:0057 original=890e4800
    mov word ptr ds:[048h], cx
; @0005B 0000:005B original=e8d800
    CALL_NEAR loc_00136
; @0005E 0000:005E original=b455
    mov ah, 055h
; @00060 0000:0060 original=b001
    mov al, 1
; @00062 0000:0062 original=be4e00
    mov si, 04Eh
; @00065 0000:0065 original=e8d554
    CALL_NEAR loc_0553D
; @00068 0000:0068 original=e8a600
    CALL_NEAR loc_00111
; @0006B 0000:006B original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @00070 0000:0070 original=75f6
    JNE_SHORT loc_00068
; @00072 0000:0072 original=e87300
    CALL_NEAR loc_000E8
; @00075 0000:0075 original=891e4a00
    mov word ptr ds:[04Ah], bx
; @00079 0000:0079 original=890e4c00
    mov word ptr ds:[04Ch], cx
; @0007D 0000:007D original=e8b600
    CALL_NEAR loc_00136
; @00080 0000:0080 original=b47d
    mov ah, 07Dh
; @00082 0000:0082 original=b001
    mov al, 1
; @00084 0000:0084 original=be4f00
    mov si, 04Fh
; @00087 0000:0087 original=e8b354
    CALL_NEAR loc_0553D
; @0008A 0000:008A original=e88400
    CALL_NEAR loc_00111
; @0008D 0000:008D original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @00092 0000:0092 original=75f6
    JNE_SHORT loc_0008A
; @00094 0000:0094 original=e85100
    CALL_NEAR loc_000E8
; @00097 0000:0097 original=891e4e00
    mov word ptr ds:[04Eh], bx
; @0009B 0000:009B original=890e5000
    mov word ptr ds:[050h], cx
; @0009F 0000:009F original=8b1e4a00
    mov bx, word ptr ds:[04Ah]
; @000A3 0000:00A3 original=2b1e4e00
    sub bx, word ptr ds:[04Eh]
; @000A7 0000:00A7 original=d1eb
    shr bx, 1
; @000A9 0000:00A9 original=031e4e00
    add bx, word ptr ds:[04Eh]
; @000AD 0000:00AD original=891e4000
    mov word ptr ds:[040h], bx
; @000B1 0000:00B1 original=8b1e4e00
    mov bx, word ptr ds:[04Eh]
; @000B5 0000:00B5 original=2b1e4600
    sub bx, word ptr ds:[046h]
; @000B9 0000:00B9 original=d1eb
    shr bx, 1
; @000BB 0000:00BB original=031e4600
    add bx, word ptr ds:[046h]
; @000BF 0000:00BF original=891e3e00
    mov word ptr ds:[03Eh], bx
; @000C3 0000:00C3 original=8b1e4c00
    mov bx, word ptr ds:[04Ch]
; @000C7 0000:00C7 original=2b1e5000
    sub bx, word ptr ds:[050h]
; @000CB 0000:00CB original=d1eb
    shr bx, 1
; @000CD 0000:00CD original=031e5000
    add bx, word ptr ds:[050h]
; @000D1 0000:00D1 original=891e4400
    mov word ptr ds:[044h], bx
; @000D5 0000:00D5 original=8b1e5000
    mov bx, word ptr ds:[050h]
; @000D9 0000:00D9 original=2b1e4800
    sub bx, word ptr ds:[048h]
; @000DD 0000:00DD original=d1eb
    shr bx, 1
; @000DF 0000:00DF original=031e4800
    add bx, word ptr ds:[048h]
; @000E3 0000:00E3 original=891e4200
    mov word ptr ds:[042h], bx
; @000E7 0000:00E7 original=c3
    ret
; sub_0000_00E8
; @000E8 0000:00E8 original=33db
    xor bx, bx
; @000EA 0000:00EA original=8bcb
    mov cx, bx
; @000EC 0000:00EC original=be50c3
    mov si, 0C350h
; @000EF 0000:00EF original=ba0102
    mov dx, 0201h
; @000F2 0000:00F2 original=fa
    cli
; @000F3 0000:00F3 original=ee
    out dx, al
; @000F4 0000:00F4 original=90
    nop
; @000F5 0000:00F5 original=90
    nop
; @000F6 0000:00F6 original=90
    nop
; @000F7 0000:00F7 original=90
    nop
; @000F8 0000:00F8 original=90
    nop
; @000F9 0000:00F9 original=90
    nop
; @000FA 0000:00FA original=90
    nop
; @000FB 0000:00FB original=90
    nop
; @000FC 0000:00FC original=90
    nop
; @000FD 0000:00FD original=90
    nop
; @000FE 0000:00FE original=90
    nop
; @000FF 0000:00FF original=ec
    in al, dx
; @00100 0000:0100 original=250300
    and ax, 3
; @00103 0000:0103 original=740a
    JE_SHORT loc_0010F
; @00105 0000:0105 original=d1d8
    rcr ax, 1
; @00107 0000:0107 original=83d300
    adc bx, 0
; @0010A 0000:010A original=03c8
    add cx, ax
; @0010C 0000:010C original=46
    inc si
; @0010D 0000:010D original=75f0
    JNE_SHORT loc_000FF
; @0010F 0000:010F original=fb
    sti
; @00110 0000:0110 original=c3
    ret
; sub_0000_0111
; @00111 0000:0111 original=803ec59801
    cmp byte ptr ds:[098C5h], 1
; @00116 0000:0116 original=7503
    JNE_SHORT loc_0011B
; @00118 0000:0118 original=e9e6fe
    JMP_NEAR loc_00001
; @0011B 0000:011B original=50
    push ax
; @0011C 0000:011C original=53
    push bx
; @0011D 0000:011D original=51
    push cx
; @0011E 0000:011E original=52
    push dx
; @0011F 0000:011F original=57
    push di
; @00120 0000:0120 original=56
    push si
; @00121 0000:0121 original=55
    push bp
; @00122 0000:0122 original=06
    push es
; @00123 0000:0123 original=1e
    push ds
; @00124 0000:0124 original=e8a700
    CALL_NEAR loc_001CE
; @00127 0000:0127 original=8026be9810
    and byte ptr ds:[098BEh], 010h
; @0012C 0000:012C original=1f
    pop ds
; @0012D 0000:012D original=07
    pop es
; @0012E 0000:012E original=5d
    pop bp
; @0012F 0000:012F original=5e
    pop si
; @00130 0000:0130 original=5f
    pop di
; @00131 0000:0131 original=5a
    pop dx
; @00132 0000:0132 original=59
    pop cx
; @00133 0000:0133 original=5b
    pop bx
; @00134 0000:0134 original=58
    pop ax
; @00135 0000:0135 original=c3
    ret
; sub_0000_0136
; @00136 0000:0136 original=50
    push ax
; @00137 0000:0137 original=53
    push bx
; @00138 0000:0138 original=51
    push cx
; @00139 0000:0139 original=52
    push dx
; @0013A 0000:013A original=57
    push di
; @0013B 0000:013B original=56
    push si
; @0013C 0000:013C original=55
    push bp
; @0013D 0000:013D original=06
    push es
; @0013E 0000:013E original=1e
    push ds
; @0013F 0000:013F original=e88c00
    CALL_NEAR loc_001CE
; @00142 0000:0142 original=8026be9810
    and byte ptr ds:[098BEh], 010h
; @00147 0000:0147 original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @0014C 0000:014C original=74f1
    JE_SHORT loc_0013F
; @0014E 0000:014E original=b91900
    mov cx, 019h
; @00151 0000:0151 original=51
    push cx
; @00152 0000:0152 original=e8744f
    CALL_NEAR loc_050C9
; @00155 0000:0155 original=59
    pop cx
; @00156 0000:0156 original=e2f9
    LOOP_SHORT loc_00151
; @00158 0000:0158 original=1f
    pop ds
; @00159 0000:0159 original=07
    pop es
; @0015A 0000:015A original=5d
    pop bp
; @0015B 0000:015B original=5e
    pop si
; @0015C 0000:015C original=5f
    pop di
; @0015D 0000:015D original=5a
    pop dx
; @0015E 0000:015E original=59
    pop cx
; @0015F 0000:015F original=5b
    pop bx
; @00160 0000:0160 original=58
    pop ax
; @00161 0000:0161 original=c3
    ret
; sub_0000_0162
; @00162 0000:0162 original=833e100001
    cmp word ptr ds:[010h], 1
; @00167 0000:0167 original=7465
    JE_SHORT loc_001CE
; @00169 0000:0169 original=b90800
    mov cx, 8
; @0016C 0000:016C original=33db
    xor bx, bx
; @0016E 0000:016E original=be3e21
    mov si, 0213Eh
; @00171 0000:0171 original=833e100002
    cmp word ptr ds:[010h], 2
; @00176 0000:0176 original=7503
    JNE_SHORT loc_0017B
; @00178 0000:0178 original=be4621
    mov si, 02146h
; @0017B 0000:017B original=bfc498
    mov di, 098C4h
; @0017E 0000:017E original=8a1c
    mov bl, byte ptr ds:[si]
; @00180 0000:0180 original=8a01
    mov al, byte ptr ds:[bx + di]
; @00182 0000:0182 original=d0e8
    shr al, 1
; @00184 0000:0184 original=d016be98
    rcl byte ptr ds:[098BEh],1
; @00188 0000:0188 original=46
    inc si
; @00189 0000:0189 original=e2f3
    LOOP_SHORT loc_0017E
; @0018B 0000:018B original=807d0f00
    cmp byte ptr ds:[di + 0Fh], 0
; @0018F 0000:018F original=7405
    JE_SHORT loc_00196
; @00191 0000:0191 original=800ebe9820
    or byte ptr ds:[098BEh], 020h
; @00196 0000:0196 original=807d3900
    cmp byte ptr ds:[di + 039h], 0
; @0019A 0000:019A original=7405
    JE_SHORT loc_001A1
; @0019C 0000:019C original=800ebe9810
    or byte ptr ds:[098BEh], 010h
; @001A1 0000:01A1 original=807d4800
    cmp byte ptr ds:[di + 048h], 0
; @001A5 0000:01A5 original=7405
    JE_SHORT loc_001AC
; @001A7 0000:01A7 original=800ebe9808
    or byte ptr ds:[098BEh], 8
; @001AC 0000:01AC original=807d5000
    cmp byte ptr ds:[di + 050h], 0
; @001B0 0000:01B0 original=7405
    JE_SHORT loc_001B7
; @001B2 0000:01B2 original=800ebe9804
    or byte ptr ds:[098BEh], 4
; @001B7 0000:01B7 original=807d4b00
    cmp byte ptr ds:[di + 04Bh], 0
; @001BB 0000:01BB original=7405
    JE_SHORT loc_001C2
; @001BD 0000:01BD original=800ebe9802
    or byte ptr ds:[098BEh], 2
; @001C2 0000:01C2 original=807d4d00
    cmp byte ptr ds:[di + 04Dh], 0
; @001C6 0000:01C6 original=7405
    JE_SHORT loc_001CD
; @001C8 0000:01C8 original=800ebe9801
    or byte ptr ds:[098BEh], 1
; @001CD 0000:01CD original=c3
    ret
; sub_0000_01CE
; @001CE 0000:01CE original=b8bc15
    mov ax, 015BCh
; @001D1 0000:01D1 original=8ed8
    mov ds, ax
; @001D3 0000:01D3 original=c606be9800
    mov byte ptr ds:[098BEh], 0
; @001D8 0000:01D8 original=c70612000100
    mov word ptr ds:[012h], 1
; @001DE 0000:01DE original=e807ff
    CALL_NEAR loc_000E8
; @001E1 0000:01E1 original=8bf3
    mov si, bx
; @001E3 0000:01E3 original=3b363e00
    cmp si, word ptr ds:[03Eh]
; @001E7 0000:01E7 original=7305
    JAE_SHORT loc_001EE
; @001E9 0000:01E9 original=800ebe9802
    or byte ptr ds:[098BEh], 2
; @001EE 0000:01EE original=3b364000
    cmp si, word ptr ds:[040h]
; @001F2 0000:01F2 original=7605
    JBE_SHORT loc_001F9
; @001F4 0000:01F4 original=800ebe9801
    or byte ptr ds:[098BEh], 1
; @001F9 0000:01F9 original=e8ecfe
    CALL_NEAR loc_000E8
; @001FC 0000:01FC original=8bf1
    mov si, cx
; @001FE 0000:01FE original=3b364200
    cmp si, word ptr ds:[042h]
; @00202 0000:0202 original=7305
    JAE_SHORT loc_00209
; @00204 0000:0204 original=800ebe9808
    or byte ptr ds:[098BEh], 8
; @00209 0000:0209 original=3b364400
    cmp si, word ptr ds:[044h]
; @0020D 0000:020D original=7605
    JBE_SHORT loc_00214
; @0020F 0000:020F original=800ebe9804
    or byte ptr ds:[098BEh], 4
; @00214 0000:0214 original=ba0102
    mov dx, 0201h
; @00217 0000:0217 original=ec
    in al, dx
; @00218 0000:0218 original=833e120001
    cmp word ptr ds:[012h], 1
; @0021D 0000:021D original=b120
    mov cl, 020h
; @0021F 0000:021F original=b510
    mov ch, 010h
; @00221 0000:0221 original=7404
    JE_SHORT loc_00227
; @00223 0000:0223 original=b180
    mov cl, 080h
; @00225 0000:0225 original=b540
    mov ch, 040h
; @00227 0000:0227 original=84c1
    test al, cl
; @00229 0000:0229 original=7505
    JNE_SHORT loc_00230
; @0022B 0000:022B original=800ebe9820
    or byte ptr ds:[098BEh], 020h
; @00230 0000:0230 original=84c5
    test al, ch
; @00232 0000:0232 original=7505
    JNE_SHORT loc_00239
; @00234 0000:0234 original=800ebe9810
    or byte ptr ds:[098BEh], 010h
; @00239 0000:0239 original=c3
    ret
; @0023A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; sub_0000_0248
; @00248 0000:0248 original=8cc8
    mov ax, cs
; @0024A 0000:024A original=8ed8
    mov ds, ax
; @0024C 0000:024C original=c70644020000
    mov word ptr ds:[0244h], 0
; @00252 0000:0252 original=89264202
    mov word ptr ds:[0242h], sp
; @00256 0000:0256 original=c70610061006
    mov word ptr ds:[0610h], 0610h
; @0025C 0000:025C original=1e
    push ds
; @0025D 0000:025D original=8b163e02
    mov dx, word ptr ds:[023Eh]
; @00261 0000:0261 original=b8bc15
    mov ax, 015BCh
; @00264 0000:0264 original=8ed8
    mov ds, ax
; @00266 0000:0266 original=b000
    mov al, 0
; @00268 0000:0268 original=b43d
    mov ah, 03Dh
; @0026A 0000:026A original=9ad7043a15
    CALL_FAR 0153Ah,04D7h
; @0026F 0000:026F original=1f
    pop ds
; @00270 0000:0270 original=2ec70646020100
    mov word ptr cs:[0246h], 1
; @00277 0000:0277 original=723e
    JB_SHORT loc_002B7
; @00279 0000:0279 original=2ec70646020000
    mov word ptr cs:[0246h], 0
; @00280 0000:0280 original=a34002
    mov word ptr ds:[0240h], ax
; @00283 0000:0283 original=e89e03
    CALL_NEAR ReadBufferedByte_00624
; @00286 0000:0286 original=0ac0
    or al, al
; @00288 0000:0288 original=7439
    JE_SHORT loc_002C3
; @0028A 0000:028A original=fec8
    dec al
; @0028C 0000:028C original=7464
    JE_SHORT loc_002F2
; @0028E 0000:028E original=fec8
    dec al
; @00290 0000:0290 original=7503
    JNE_SHORT loc_00295
; @00292 0000:0292 original=e98f00
    JMP_NEAR loc_00324
; @00295 0000:0295 original=fec8
    dec al
; @00297 0000:0297 original=7503
    JNE_SHORT loc_0029C
; @00299 0000:0299 original=e9cb00
    JMP_NEAR loc_00367
; @0029C 0000:029C original=fec8
    dec al
; @0029E 0000:029E original=7503
    JNE_SHORT loc_002A3
; @002A0 0000:02A0 original=e90501
    JMP_NEAR loc_003A8
; @002A3 0000:02A3 original=b8ffff
    mov ax, 0FFFFh
; @002A6 0000:02A6 original=eb0a
    JMP_SHORT loc_002B2
; @002A8 0000:02A8 original=e8b103
    CALL_NEAR loc_0065C
; @002AB 0000:02AB original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @002B0 0000:02B0 original=f8
    clc
; @002B1 0000:02B1 original=c3
    ret
; @002B2 0000:02B2 original=50
    push ax
; @002B3 0000:02B3 original=e8a603
    CALL_NEAR loc_0065C
; @002B6 0000:02B6 original=58
    pop ax
; @002B7 0000:02B7 original=bbbc15
    mov bx, 015BCh
; @002BA 0000:02BA original=8edb
    mov ds, bx
; @002BC 0000:02BC original=2e8b264202
    mov sp, word ptr cs:[0242h]
; @002C1 0000:02C1 original=f9
    stc
; @002C2 0000:02C2 original=c3
    ret
; @002C3 0000:02C3 original=8e063a02
    mov es, word ptr ds:[023Ah]
; @002C7 0000:02C7 original=8b3e3c02
    mov di, word ptr ds:[023Ch]
; @002CB 0000:02CB original=e85603
    CALL_NEAR ReadBufferedByte_00624
; @002CE 0000:02CE original=8ad8
    mov bl, al
; @002D0 0000:02D0 original=e85103
    CALL_NEAR ReadBufferedByte_00624
; @002D3 0000:02D3 original=3ac3
    cmp al, bl
; @002D5 0000:02D5 original=7407
    JE_SHORT loc_002DE
; @002D7 0000:02D7 original=aa
    stosb
; @002D8 0000:02D8 original=ff064402
    inc word ptr ds:[0244h]
; @002DC 0000:02DC original=ebf2
    JMP_SHORT loc_002D0
; @002DE 0000:02DE original=e84303
    CALL_NEAR ReadBufferedByte_00624
; @002E1 0000:02E1 original=8ac8
    mov cl, al
; @002E3 0000:02E3 original=32ed
    xor ch, ch
; @002E5 0000:02E5 original=e3c1
    JCXZ_SHORT loc_002A8
; @002E7 0000:02E7 original=e83a03
    CALL_NEAR ReadBufferedByte_00624
; @002EA 0000:02EA original=010e4402
    add word ptr ds:[0244h], cx
; @002EE 0000:02EE original=f3aa
    rep stosb
; @002F0 0000:02F0 original=ebde
    JMP_SHORT loc_002D0
; @002F2 0000:02F2 original=8e063a02
    mov es, word ptr ds:[023Ah]
; @002F6 0000:02F6 original=8b3e3c02
    mov di, word ptr ds:[023Ch]
; @002FA 0000:02FA original=e81803
    CALL_NEAR ReadBufferedWordLE_00615
; @002FD 0000:02FD original=8bd8
    mov bx, ax
; @002FF 0000:02FF original=e81303
    CALL_NEAR ReadBufferedWordLE_00615
; @00302 0000:0302 original=3bc3
    cmp ax, bx
; @00304 0000:0304 original=7408
    JE_SHORT loc_0030E
; @00306 0000:0306 original=ab
    stosw
; @00307 0000:0307 original=8306440202
    add word ptr ds:[0244h], 2
; @0030C 0000:030C original=ebf1
    JMP_SHORT loc_002FF
; @0030E 0000:030E original=e80403
    CALL_NEAR ReadBufferedWordLE_00615
; @00311 0000:0311 original=8bc8
    mov cx, ax
; @00313 0000:0313 original=e393
    JCXZ_SHORT loc_002A8
; @00315 0000:0315 original=e8fd02
    CALL_NEAR ReadBufferedWordLE_00615
; @00318 0000:0318 original=010e4402
    add word ptr ds:[0244h], cx
; @0031C 0000:031C original=010e4402
    add word ptr ds:[0244h], cx
; @00320 0000:0320 original=f3ab
    rep stosw
; @00322 0000:0322 original=ebdb
    JMP_SHORT loc_002FF
; @00324 0000:0324 original=8e063a02
    mov es, word ptr ds:[023Ah]
; @00328 0000:0328 original=8b3e3c02
    mov di, word ptr ds:[023Ch]
; @0032C 0000:032C original=e8e602
    CALL_NEAR ReadBufferedWordLE_00615
; @0032F 0000:032F original=8bd8
    mov bx, ax
; @00331 0000:0331 original=e8e102
    CALL_NEAR ReadBufferedWordLE_00615
; @00334 0000:0334 original=3bc3
    cmp ax, bx
; @00336 0000:0336 original=740c
    JE_SHORT loc_00344
; @00338 0000:0338 original=ab
    stosw
; @00339 0000:0339 original=e8d902
    CALL_NEAR ReadBufferedWordLE_00615
; @0033C 0000:033C original=ab
    stosw
; @0033D 0000:033D original=8306440204
    add word ptr ds:[0244h], 4
; @00342 0000:0342 original=ebed
    JMP_SHORT loc_00331
; @00344 0000:0344 original=e8ce02
    CALL_NEAR ReadBufferedWordLE_00615
; @00347 0000:0347 original=8bc8
    mov cx, ax
; @00349 0000:0349 original=e302
    JCXZ_SHORT loc_0034D
; @0034B 0000:034B original=eb03
    JMP_SHORT loc_00350
; @0034D 0000:034D original=e958ff
    JMP_NEAR loc_002A8
; @00350 0000:0350 original=e8c202
    CALL_NEAR ReadBufferedWordLE_00615
; @00353 0000:0353 original=50
    push ax
; @00354 0000:0354 original=e8be02
    CALL_NEAR ReadBufferedWordLE_00615
; @00357 0000:0357 original=8bd0
    mov dx, ax
; @00359 0000:0359 original=58
    pop ax
; @0035A 0000:035A original=ab
    stosw
; @0035B 0000:035B original=92
    xchg ax, dx
; @0035C 0000:035C original=ab
    stosw
; @0035D 0000:035D original=8306440204
    add word ptr ds:[0244h], 4
; @00362 0000:0362 original=92
    xchg ax, dx
; @00363 0000:0363 original=e2f5
    LOOP_SHORT loc_0035A
; @00365 0000:0365 original=ebca
    JMP_SHORT loc_00331
; @00367 0000:0367 original=8e063a02
    mov es, word ptr ds:[023Ah]
; @0036B 0000:036B original=8b3e3c02
    mov di, word ptr ds:[023Ch]
; @0036F 0000:036F original=e8b202
    CALL_NEAR ReadBufferedByte_00624
; @00372 0000:0372 original=3c80
    cmp al, 080h
; @00374 0000:0374 original=7503
    JNE_SHORT loc_00379
; @00376 0000:0376 original=e92fff
    JMP_NEAR loc_002A8
; @00379 0000:0379 original=7216
    JB_SHORT loc_00391
; @0037B 0000:037B original=f6d8
    neg al
; @0037D 0000:037D original=86e0
    xchg ah, al
; @0037F 0000:037F original=86dc
    xchg bl, ah
; @00381 0000:0381 original=e8a002
    CALL_NEAR ReadBufferedByte_00624
; @00384 0000:0384 original=86dc
    xchg bl, ah
; @00386 0000:0386 original=aa
    stosb
; @00387 0000:0387 original=ff064402
    inc word ptr ds:[0244h]
; @0038B 0000:038B original=fecc
    dec ah
; @0038D 0000:038D original=79f7
    JNS_SHORT loc_00386
; @0038F 0000:038F original=ebde
    JMP_SHORT loc_0036F
; @00391 0000:0391 original=50
    push ax
; @00392 0000:0392 original=e88f02
    CALL_NEAR ReadBufferedByte_00624
; @00395 0000:0395 original=aa
    stosb
; @00396 0000:0396 original=ff064402
    inc word ptr ds:[0244h]
; @0039A 0000:039A original=58
    pop ax
; @0039B 0000:039B original=fec8
    dec al
; @0039D 0000:039D original=79f2
    JNS_SHORT loc_00391
; @0039F 0000:039F original=ebce
    JMP_SHORT loc_0036F
; @003A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h,00h,00h
; @003A8 0000:03A8 original=8e063a02
    mov es, word ptr ds:[023Ah]
; @003AC 0000:03AC original=8b3e3c02
    mov di, word ptr ds:[023Ch]
; @003B0 0000:03B0 original=e86202
    CALL_NEAR ReadBufferedWordLE_00615
; @003B3 0000:03B3 original=2ea3a203
    mov word ptr cs:[03A2h], ax
; @003B7 0000:03B7 original=e85b02
    CALL_NEAR ReadBufferedWordLE_00615
; @003BA 0000:03BA original=a3a403
    mov word ptr ds:[03A4h], ax
; @003BD 0000:03BD original=e85502
    CALL_NEAR ReadBufferedWordLE_00615
; @003C0 0000:03C0 original=a3a603
    mov word ptr ds:[03A6h], ax
; @003C3 0000:03C3 original=2e8b0ea403
    mov cx, word ptr cs:[03A4h]
; @003C8 0000:03C8 original=51
    push cx
; @003C9 0000:03C9 original=57
    push di
; @003CA 0000:03CA original=e85702
    CALL_NEAR ReadBufferedByte_00624
; @003CD 0000:03CD original=3c80
    cmp al, 080h
; @003CF 0000:03CF original=7436
    JE_SHORT loc_00407
; @003D1 0000:03D1 original=721d
    JB_SHORT loc_003F0
; @003D3 0000:03D3 original=f6d8
    neg al
; @003D5 0000:03D5 original=86e0
    xchg ah, al
; @003D7 0000:03D7 original=86dc
    xchg bl, ah
; @003D9 0000:03D9 original=e84802
    CALL_NEAR ReadBufferedByte_00624
; @003DC 0000:03DC original=86dc
    xchg bl, ah
; @003DE 0000:03DE original=268805
    mov byte ptr es:[di], al
; @003E1 0000:03E1 original=2e033ea403
    add di, word ptr cs:[03A4h]
; @003E6 0000:03E6 original=ff064402
    inc word ptr ds:[0244h]
; @003EA 0000:03EA original=fecc
    dec ah
; @003EC 0000:03EC original=79f0
    JNS_SHORT loc_003DE
; @003EE 0000:03EE original=ebda
    JMP_SHORT loc_003CA
; @003F0 0000:03F0 original=50
    push ax
; @003F1 0000:03F1 original=e83002
    CALL_NEAR ReadBufferedByte_00624
; @003F4 0000:03F4 original=268805
    mov byte ptr es:[di], al
; @003F7 0000:03F7 original=2e033ea403
    add di, word ptr cs:[03A4h]
; @003FC 0000:03FC original=ff064402
    inc word ptr ds:[0244h]
; @00400 0000:0400 original=58
    pop ax
; @00401 0000:0401 original=fec8
    dec al
; @00403 0000:0403 original=79eb
    JNS_SHORT loc_003F0
; @00405 0000:0405 original=ebc3
    JMP_SHORT loc_003CA
; @00407 0000:0407 original=5f
    pop di
; @00408 0000:0408 original=47
    inc di
; @00409 0000:0409 original=59
    pop cx
; @0040A 0000:040A original=e2bc
    LOOP_SHORT loc_003C8
; @0040C 0000:040C original=e999fe
    JMP_NEAR loc_002A8
; @0040F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0041F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0042F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0043F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0044F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0045F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0046F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0047F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0048F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0049F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004AF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004BF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004CF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004DF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004EF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004FF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0050F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0051F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0052F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0053F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0054F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0055F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0056F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0057F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0058F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0059F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005AF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005BF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005CF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005DF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005EF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005FF UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0060F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h
; ReadBufferedWordLE
; Call ReadBufferedByte twice; first byte saved in DS:0614, second becomes AH and saved
; first becomes AL. Shares scratch and inherits nonlocal error unwind from callee.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @00615 0000:0615 original=e80c00
    CALL_NEAR ReadBufferedByte_00624
; @00618 0000:0618 original=a21406
    mov byte ptr ds:[0614h], al
; @0061B 0000:061B original=e80600
    CALL_NEAR ReadBufferedByte_00624
; @0061E 0000:061E original=8ae0
    mov ah, al
; @00620 0000:0620 original=a01406
    mov al, byte ptr ds:[0614h]
; @00623 0000:0623 original=c3
    ret
; ReadBufferedByte
; Save BX at DS:0612; cursor DS:0610. If cursor >=0610h, reset to0410h and request512 bytes
; via DOS AH=3F, handle DS:0240. Return byte in AL, advance cursor, restore BX. DOS failure
; branches to02B2 which restores SP from CS:0242. Short reads are not checked here.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @00624 0000:0624 original=891e1206
    mov word ptr ds:[0612h], bx
; @00628 0000:0628 original=8b1e1006
    mov bx, word ptr ds:[0610h]
; @0062C 0000:062C original=81fb1006
    cmp bx, 0610h
; @00630 0000:0630 original=721f
    JB_SHORT loc_00651
; @00632 0000:0632 original=c70610061004
    mov word ptr ds:[0610h], 0410h
; @00638 0000:0638 original=51
    push cx
; @00639 0000:0639 original=b43f
    mov ah, 03Fh
; @0063B 0000:063B original=8b1e4002
    mov bx, word ptr ds:[0240h]
; @0063F 0000:063F original=b90002
    mov cx, 0200h
; @00642 0000:0642 original=ba1004
    mov dx, 0410h
; @00645 0000:0645 original=cd21
    int 021h
; @00647 0000:0647 original=59
    pop cx
; @00648 0000:0648 original=7303
    JAE_SHORT loc_0064D
; @0064A 0000:064A original=e965fc
    JMP_NEAR loc_002B2
; @0064D 0000:064D original=8b1e1006
    mov bx, word ptr ds:[0610h]
; @00651 0000:0651 original=8a07
    mov al, byte ptr ds:[bx]
; @00653 0000:0653 original=ff061006
    inc word ptr ds:[0610h]
; @00657 0000:0657 original=8b1e1206
    mov bx, word ptr ds:[0612h]
; @0065B 0000:065B original=c3
    ret
; sub_0000_065C
; @0065C 0000:065C original=2e8b1e4002
    mov bx, word ptr cs:[0240h]
; @00661 0000:0661 original=b43e
    mov ah, 03Eh
; @00663 0000:0663 original=cd21
    int 021h
; @00665 0000:0665 original=7303
    JAE_SHORT loc_0066A
; @00667 0000:0667 original=e948fc
    JMP_NEAR loc_002B2
; @0066A 0000:066A original=c3
    ret
; @0066B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; IncrementByteCS066B
; Increment byte CS:066B modulo 256; INC preserves incoming CF. Near return.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @0066C 0000:066C original=2efe066b06
    inc byte ptr cs:[066Bh]
; @00671 0000:0671 original=c3
    ret
; ClearByteCS066B
; Write zero to CS:066B. Registers and flags unchanged; near return.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @00672 0000:0672 original=2ec6066b0600
    mov byte ptr cs:[066Bh], 0
; @00678 0000:0678 original=c3
    ret
; WaitByteCS066B
; Poll CS:066B until nonzero. Requires asynchronous mutation to terminate from zero; near
; return leaves CMP flags.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @00679 0000:0679 original=2e803e6b0600
    cmp byte ptr cs:[066Bh], 0
; @0067F 0000:067F original=74f8
    JE_SHORT WaitByteCS066B_00679
; @00681 0000:0681 original=c3
    ret
; InstallTimerVector08
; If DS:0052 !=1, save old INT08 vector at CS:0738, program PIT ports43h/40h with36h and
; divisor4000h, install CS:06E5 via DOS AH25, set DS:0052=1. Uses CLI/STI and changes
; registers.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @00682 0000:0682 original=833e520001
    cmp word ptr ds:[052h], 1
; @00687 0000:0687 original=7501
    JNE_SHORT loc_0068A
; @00689 0000:0689 original=c3
    ret
; @0068A 0000:068A original=fa
    cli
; @0068B 0000:068B original=06
    push es
; @0068C 0000:068C original=b80835
    mov ax, 03508h
; @0068F 0000:068F original=cd21
    int 021h
; @00691 0000:0691 original=bf3807
    mov di, 0738h
; @00694 0000:0694 original=2e891d
    mov word ptr cs:[di], bx
; @00697 0000:0697 original=2e8c4502
    mov word ptr cs:[di + 2], es
; @0069B 0000:069B original=07
    pop es
; @0069C 0000:069C original=b036
    mov al, 036h
; @0069E 0000:069E original=e643
    out 043h, al
; @006A0 0000:06A0 original=32c0
    xor al, al
; @006A2 0000:06A2 original=e640
    out 040h, al
; @006A4 0000:06A4 original=b040
    mov al, 040h
; @006A6 0000:06A6 original=e640
    out 040h, al
; @006A8 0000:06A8 original=1e
    push ds
; @006A9 0000:06A9 original=0e
    push cs
; @006AA 0000:06AA original=1f
    pop ds
; @006AB 0000:06AB original=bae506
    mov dx, 06E5h
; @006AE 0000:06AE original=b80825
    mov ax, 02508h
; @006B1 0000:06B1 original=cd21
    int 021h
; @006B3 0000:06B3 original=1f
    pop ds
; @006B4 0000:06B4 original=fb
    sti
; @006B5 0000:06B5 original=c70652000100
    mov word ptr ds:[052h], 1
; @006BB 0000:06BB original=c3
    ret
; sub_0000_06BC
; @006BC 0000:06BC original=833e520000
    cmp word ptr ds:[052h], 0
; @006C1 0000:06C1 original=7501
    JNE_SHORT loc_006C4
; @006C3 0000:06C3 original=c3
    ret
; @006C4 0000:06C4 original=fa
    cli
; @006C5 0000:06C5 original=1e
    push ds
; @006C6 0000:06C6 original=2ec5163807
    lds dx, dword ptr cs:[0738h]
; @006CB 0000:06CB original=b80825
    mov ax, 02508h
; @006CE 0000:06CE original=cd21
    int 021h
; @006D0 0000:06D0 original=1f
    pop ds
; @006D1 0000:06D1 original=b036
    mov al, 036h
; @006D3 0000:06D3 original=e643
    out 043h, al
; @006D5 0000:06D5 original=32c0
    xor al, al
; @006D7 0000:06D7 original=e640
    out 040h, al
; @006D9 0000:06D9 original=e640
    out 040h, al
; @006DB 0000:06DB original=fb
    sti
; @006DC 0000:06DC original=e461
    in al, 061h
; @006DE 0000:06DE original=24fc
    and al, 0FCh
; @006E0 0000:06E0 original=e661
    out 061h, al
; @006E2 0000:06E2 original=c3
    ret
; @006E3 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h
; Interrupt08Handler
; Entry installed by InstallTimerVector08. Calls counter/music helpers and can chain a
; previous vector; inspect full CFG and unresolved far calls before changing it.
; Modern semantic name; see metadata/symbols.json for confidence and evidence.
; @006E5 0000:06E5 original=50
    push ax
; @006E6 0000:06E6 original=1e
    push ds
; @006E7 0000:06E7 original=53
    push bx
; @006E8 0000:06E8 original=51
    push cx
; @006E9 0000:06E9 original=52
    push dx
; @006EA 0000:06EA original=57
    push di
; @006EB 0000:06EB original=56
    push si
; @006EC 0000:06EC original=55
    push bp
; @006ED 0000:06ED original=06
    push es
; @006EE 0000:06EE original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @006F3 0000:06F3 original=803e550001
    cmp byte ptr ds:[055h], 1
; @006F8 0000:06F8 original=750a
    JNE_SHORT loc_00704
; @006FA 0000:06FA original=9a00002210
    CALL_FAR 01022h,00h
; @006FF 0000:06FF original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @00704 0000:0704 original=e807ce
    CALL_NEAR loc_0D50E
; @00707 0000:0707 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0070C 0000:070C original=f606540001
    test byte ptr ds:[054h], 1
; @00711 0000:0711 original=7503
    JNE_SHORT loc_00716
; @00713 0000:0713 original=e856ff
    CALL_NEAR IncrementByteCS066B_0066C
; @00716 0000:0716 original=07
    pop es
; @00717 0000:0717 original=5d
    pop bp
; @00718 0000:0718 original=5e
    pop si
; @00719 0000:0719 original=5f
    pop di
; @0071A 0000:071A original=5a
    pop dx
; @0071B 0000:071B original=59
    pop cx
; @0071C 0000:071C original=5b
    pop bx
; @0071D 0000:071D original=fe065400
    inc byte ptr ds:[054h]
; @00721 0000:0721 original=8026540003
    and byte ptr ds:[054h], 3
; @00726 0000:0726 original=7407
    JE_SHORT loc_0072F
; @00728 0000:0728 original=1f
    pop ds
; @00729 0000:0729 original=b020
    mov al, 020h
; @0072B 0000:072B original=e620
    out 020h, al
; @0072D 0000:072D original=58
    pop ax
; @0072E 0000:072E original=cf
    iret
; @0072F 0000:072F original=1f
    pop ds
; @00730 0000:0730 original=58
    pop ax
; @00731 0000:0731 original=fb
    sti
; @00732 0000:0732 original=2eff2e3807
    jmp dword ptr cs:[0738h]
; @00737 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h
; sub_0000_073C
; @0073C 0000:073C original=803e079901
    cmp byte ptr ds:[09907h], 1
; @00741 0000:0741 original=7401
    JE_SHORT loc_00744
; @00743 0000:0743 original=c3
    ret
; @00744 0000:0744 original=e81800
    CALL_NEAR loc_0075F
; sub_0000_0747
; @00747 0000:0747 original=e8a500
    CALL_NEAR loc_007EF
; @0074A 0000:074A original=833eacbd01
    cmp word ptr ds:[0BDACh], 1
; @0074F 0000:074F original=7501
    JNE_SHORT loc_00752
; @00751 0000:0751 original=c3
    ret
; @00752 0000:0752 original=e8215a
    CALL_NEAR loc_06176
; @00755 0000:0755 original=e88770
    CALL_NEAR loc_077DF
; @00758 0000:0758 original=e8437e
    CALL_NEAR loc_0859E
; @0075B 0000:075B original=e81ebe
    CALL_NEAR loc_0C57C
; @0075E 0000:075E original=c3
    ret
; sub_0000_075F
; @0075F 0000:075F original=e8dcc3
    CALL_NEAR loc_0CB3E
; @00762 0000:0762 original=b80300
    mov ax, 3
; @00765 0000:0765 original=cd10
    int 010h
; @00767 0000:0767 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0076C 0000:076C original=b800b8
    mov ax, 0B800h
; @0076F 0000:076F original=8ec0
    mov es, ax
; @00771 0000:0771 original=33ff
    xor di, di
; @00773 0000:0773 original=be5600
    mov si, 056h
; @00776 0000:0776 original=e8db00
    CALL_NEAR loc_00854
; @00779 0000:0779 original=bf0100
    mov di, 1
; @0077C 0000:077C original=b00c
    mov al, 0Ch
; @0077E 0000:077E original=e8cb00
    CALL_NEAR loc_0084C
; @00781 0000:0781 original=b00e
    mov al, 0Eh
; @00783 0000:0783 original=b9e001
    mov cx, 01E0h
; @00786 0000:0786 original=e8c600
    CALL_NEAR loc_0084F
; @00789 0000:0789 original=b90f00
    mov cx, 0Fh
; @0078C 0000:078C original=51
    push cx
; @0078D 0000:078D original=b00e
    mov al, 0Eh
; @0078F 0000:078F original=b90100
    mov cx, 1
; @00792 0000:0792 original=e8ba00
    CALL_NEAR loc_0084F
; @00795 0000:0795 original=b007
    mov al, 7
; @00797 0000:0797 original=b94f00
    mov cx, 04Fh
; @0079A 0000:079A original=e8b200
    CALL_NEAR loc_0084F
; @0079D 0000:079D original=59
    pop cx
; @0079E 0000:079E original=e2ec
    LOOP_SHORT loc_0078C
; @007A0 0000:07A0 original=b01e
    mov al, 01Eh
; @007A2 0000:07A2 original=e8a700
    CALL_NEAR loc_0084C
; @007A5 0000:07A5 original=b01e
    mov al, 01Eh
; @007A7 0000:07A7 original=e8a200
    CALL_NEAR loc_0084C
; @007AA 0000:07AA original=bf3107
    mov di, 0731h
; @007AD 0000:07AD original=b071
    mov al, 071h
; @007AF 0000:07AF original=b90d00
    mov cx, 0Dh
; @007B2 0000:07B2 original=e89a00
    CALL_NEAR loc_0084F
; @007B5 0000:07B5 original=b247
    mov dl, 047h
; @007B7 0000:07B7 original=b617
    mov dh, 017h
; @007B9 0000:07B9 original=b402
    mov ah, 2
; @007BB 0000:07BB original=b700
    mov bh, 0
; @007BD 0000:07BD original=cd10
    int 010h
; @007BF 0000:07BF original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @007C4 0000:07C4 original=803e079901
    cmp byte ptr ds:[09907h], 1
; @007C9 0000:07C9 original=74f9
    JE_SHORT loc_007C4
; @007CB 0000:07CB original=c606c39800
    mov byte ptr ds:[098C3h], 0
; @007D0 0000:07D0 original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @007D5 0000:07D5 original=74f9
    JE_SHORT loc_007D0
; @007D7 0000:07D7 original=803e079901
    cmp byte ptr ds:[09907h], 1
; @007DC 0000:07DC original=74f9
    JE_SHORT loc_007D7
; @007DE 0000:07DE original=2ea1bc95
    mov ax, word ptr cs:[095BCh]
; @007E2 0000:07E2 original=bbc499
    mov bx, 099C4h
; @007E5 0000:07E5 original=d7
    xlat
; @007E6 0000:07E6 original=cd10
    int 010h
; @007E8 0000:07E8 original=a0c298
    mov al, byte ptr ds:[098C2h]
; @007EB 0000:07EB original=e82ec3
    CALL_NEAR loc_0CB1C
; @007EE 0000:07EE original=c3
    ret
; sub_0000_07EF
; @007EF 0000:07EF original=e85349
    CALL_NEAR loc_05145
; @007F2 0000:07F2 original=b81b00
    mov ax, 01Bh
; @007F5 0000:07F5 original=e80852
    CALL_NEAR loc_05A00
; @007F8 0000:07F8 original=be2500
    mov si, 025h
; @007FB 0000:07FB original=d1e6
    shl si, 1
; @007FD 0000:07FD original=81c6e40b
    add si, 0BE4h
; @00801 0000:0801 original=2e8b34
    mov si, word ptr cs:[si]
; @00804 0000:0804 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @00809 0000:0809 original=ad
    lodsw
; @0080A 0000:080A original=2ea3fd58
    mov word ptr cs:[058FDh], ax
; @0080E 0000:080E original=ad
    lodsw
; @0080F 0000:080F original=2ea3ff58
    mov word ptr cs:[058FFh], ax
; @00813 0000:0813 original=2e8936fb58
    mov word ptr cs:[058FBh], si
; @00818 0000:0818 original=2e893ef958
    mov word ptr cs:[058F9h], di
; @0081D 0000:081D original=2ec70605590000
    mov word ptr cs:[05905h], 0
; @00824 0000:0824 original=2ec70607590000
    mov word ptr cs:[05907h], 0
; @0082B 0000:082B original=2ec7060159c600
    mov word ptr cs:[05901h], 0C6h
; @00832 0000:0832 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @00837 0000:0837 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @0083C 0000:083C original=d1e3
    shl bx, 1
; @0083E 0000:083E original=2eff975a59
    call word ptr cs:[bx + 0595Ah]
; @00843 0000:0843 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @00848 0000:0848 original=e86c54
    CALL_NEAR loc_05CB7
; @0084B 0000:084B original=c3
    ret
; sub_0000_084C
; @0084C 0000:084C original=b95000
    mov cx, 050h
; sub_0000_084F
; @0084F 0000:084F original=aa
    stosb
; @00850 0000:0850 original=47
    inc di
; @00851 0000:0851 original=e2fc
    LOOP_SHORT loc_0084F
; @00853 0000:0853 original=c3
    ret
; sub_0000_0854
; @00854 0000:0854 original=b9d007
    mov cx, 07D0h
; @00857 0000:0857 original=f3a5
    rep movsw
; @00859 0000:0859 original=c3
    ret
; @0085A 0000:085A original=b80300
    mov ax, 3
; @0085D 0000:085D original=cd10
    int 010h
; @0085F 0000:085F original=ba1110
    mov dx, 01011h
; @00862 0000:0862 original=b409
    mov ah, 9
; @00864 0000:0864 original=cd21
    int 021h
; @00866 0000:0866 original=b9c800
    mov cx, 0C8h
; @00869 0000:0869 original=e85d48
    CALL_NEAR loc_050C9
; @0086C 0000:086C original=e2fb
    LOOP_SHORT loc_00869
; @0086E 0000:086E original=e9a354
    JMP_NEAR loc_05D14
; @00871 0000:0871 original=52
    push dx
; @00872 0000:0872 original=b80300
    mov ax, 3
; @00875 0000:0875 original=cd10
    int 010h
; @00877 0000:0877 original=5a
    pop dx
; @00878 0000:0878 original=b409
    mov ah, 9
; @0087A 0000:087A original=cd21
    int 021h
; @0087C 0000:087C original=b9c800
    mov cx, 0C8h
; @0087F 0000:087F original=e84748
    CALL_NEAR loc_050C9
; @00882 0000:0882 original=e2fb
    LOOP_SHORT loc_0087F
; @00884 0000:0884 original=e98d54
    JMP_NEAR loc_05D14
; @00887 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h
; sub_0000_0889
; @00889 0000:0889 original=2ec70687080000
    mov word ptr cs:[0887h], 0
; @00890 0000:0890 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @00895 0000:0895 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0089A 0000:089A original=2e8b36bc95
    mov si, word ptr cs:[095BCh]
; @0089F 0000:089F original=d1e6
    shl si, 1
; @008A1 0000:08A1 original=81c66e11
    add si, 0116Eh
; @008A5 0000:08A5 original=8b34
    mov si, word ptr ds:[si]
; @008A7 0000:08A7 original=bf2410
    mov di, 01024h
; @008AA 0000:08AA original=b92700
    mov cx, 027h
; @008AD 0000:08AD original=f3a5
    rep movsw
; @008AF 0000:08AF original=ad
    lodsw
; @008B0 0000:08B0 original=2ea39e95
    mov word ptr cs:[0959Eh], ax
; @008B4 0000:08B4 original=ad
    lodsw
; @008B5 0000:08B5 original=2ea3a095
    mov word ptr cs:[095A0h], ax
; @008B9 0000:08B9 original=ad
    lodsw
; @008BA 0000:08BA original=2ea3a495
    mov word ptr cs:[095A4h], ax
; @008BE 0000:08BE original=b91000
    mov cx, 010h
; @008C1 0000:08C1 original=2ea19e95
    mov ax, word ptr cs:[0959Eh]
; @008C5 0000:08C5 original=f7e1
    mul cx
; @008C7 0000:08C7 original=2ea3a295
    mov word ptr cs:[095A2h], ax
; @008CB 0000:08CB original=2ea3be95
    mov word ptr cs:[095BEh], ax
; @008CF 0000:08CF original=8bd8
    mov bx, ax
; @008D1 0000:08D1 original=b90d00
    mov cx, 0Dh
; @008D4 0000:08D4 original=f7e1
    mul cx
; @008D6 0000:08D6 original=2ea3c295
    mov word ptr cs:[095C2h], ax
; @008DA 0000:08DA original=03c3
    add ax, bx
; @008DC 0000:08DC original=2ea3c095
    mov word ptr cs:[095C0h], ax
; @008E0 0000:08E0 original=bb0010
    mov bx, 01000h
; @008E3 0000:08E3 original=2e011e8708
    add word ptr cs:[0887h], bx
; @008E8 0000:08E8 original=b448
    mov ah, 048h
; @008EA 0000:08EA original=cd21
    int 021h
; @008EC 0000:08EC original=7303
    JAE_SHORT loc_008F1
; @008EE 0000:08EE original=e969ff
    JMP_NEAR loc_0085A
; @008F1 0000:08F1 original=2ea39895
    mov word ptr cs:[09598h], ax
; @008F5 0000:08F5 original=b87500
    mov ax, 075h
; @008F8 0000:08F8 original=f7262410
    mul word ptr ds:[01024h]
; @008FC 0000:08FC original=d1e8
    shr ax, 1
; @008FE 0000:08FE original=d1e8
    shr ax, 1
; @00900 0000:0900 original=d1e8
    shr ax, 1
; @00902 0000:0902 original=d1e8
    shr ax, 1
; @00904 0000:0904 original=40
    inc ax
; @00905 0000:0905 original=8bd8
    mov bx, ax
; @00907 0000:0907 original=2e011e8708
    add word ptr cs:[0887h], bx
; @0090C 0000:090C original=b448
    mov ah, 048h
; @0090E 0000:090E original=cd21
    int 021h
; @00910 0000:0910 original=7303
    JAE_SHORT loc_00915
; @00912 0000:0912 original=e945ff
    JMP_NEAR loc_0085A
; @00915 0000:0915 original=2ea3a895
    mov word ptr cs:[095A8h], ax
; @00919 0000:0919 original=b8ff00
    mov ax, 0FFh
; @0091C 0000:091C original=f7262610
    mul word ptr ds:[01026h]
; @00920 0000:0920 original=d1e8
    shr ax, 1
; @00922 0000:0922 original=d1e8
    shr ax, 1
; @00924 0000:0924 original=d1e8
    shr ax, 1
; @00926 0000:0926 original=d1e8
    shr ax, 1
; @00928 0000:0928 original=40
    inc ax
; @00929 0000:0929 original=8bd8
    mov bx, ax
; @0092B 0000:092B original=2e011e8708
    add word ptr cs:[0887h], bx
; @00930 0000:0930 original=b448
    mov ah, 048h
; @00932 0000:0932 original=cd21
    int 021h
; @00934 0000:0934 original=7303
    JAE_SHORT loc_00939
; @00936 0000:0936 original=e921ff
    JMP_NEAR loc_0085A
; @00939 0000:0939 original=2ea3aa95
    mov word ptr cs:[095AAh], ax
; @0093D 0000:093D original=b88200
    mov ax, 082h
; @00940 0000:0940 original=f7262610
    mul word ptr ds:[01026h]
; @00944 0000:0944 original=d1e8
    shr ax, 1
; @00946 0000:0946 original=d1e8
    shr ax, 1
; @00948 0000:0948 original=d1e8
    shr ax, 1
; @0094A 0000:094A original=d1e8
    shr ax, 1
; @0094C 0000:094C original=40
    inc ax
; @0094D 0000:094D original=8bd8
    mov bx, ax
; @0094F 0000:094F original=2e011e8708
    add word ptr cs:[0887h], bx
; @00954 0000:0954 original=b448
    mov ah, 048h
; @00956 0000:0956 original=cd21
    int 021h
; @00958 0000:0958 original=7303
    JAE_SHORT loc_0095D
; @0095A 0000:095A original=e9fdfe
    JMP_NEAR loc_0085A
; @0095D 0000:095D original=2ea3ac95
    mov word ptr cs:[095ACh], ax
; @00961 0000:0961 original=b80d00
    mov ax, 0Dh
; @00964 0000:0964 original=f7262810
    mul word ptr ds:[01028h]
; @00968 0000:0968 original=d1e8
    shr ax, 1
; @0096A 0000:096A original=d1e8
    shr ax, 1
; @0096C 0000:096C original=d1e8
    shr ax, 1
; @0096E 0000:096E original=d1e8
    shr ax, 1
; @00970 0000:0970 original=40
    inc ax
; @00971 0000:0971 original=8bd8
    mov bx, ax
; @00973 0000:0973 original=2e011e8708
    add word ptr cs:[0887h], bx
; @00978 0000:0978 original=b448
    mov ah, 048h
; @0097A 0000:097A original=cd21
    int 021h
; @0097C 0000:097C original=7303
    JAE_SHORT loc_00981
; @0097E 0000:097E original=e9d9fe
    JMP_NEAR loc_0085A
; @00981 0000:0981 original=2ea3ae95
    mov word ptr cs:[095AEh], ax
; @00985 0000:0985 original=b81c00
    mov ax, 01Ch
; @00988 0000:0988 original=f7262810
    mul word ptr ds:[01028h]
; @0098C 0000:098C original=d1e8
    shr ax, 1
; @0098E 0000:098E original=d1e8
    shr ax, 1
; @00990 0000:0990 original=d1e8
    shr ax, 1
; @00992 0000:0992 original=d1e8
    shr ax, 1
; @00994 0000:0994 original=40
    inc ax
; @00995 0000:0995 original=8bd8
    mov bx, ax
; @00997 0000:0997 original=2e011e8708
    add word ptr cs:[0887h], bx
; @0099C 0000:099C original=b448
    mov ah, 048h
; @0099E 0000:099E original=cd21
    int 021h
; @009A0 0000:09A0 original=7303
    JAE_SHORT loc_009A5
; @009A2 0000:09A2 original=e9b5fe
    JMP_NEAR loc_0085A
; @009A5 0000:09A5 original=2ea3a695
    mov word ptr cs:[095A6h], ax
; @009A9 0000:09A9 original=a12c10
    mov ax, word ptr ds:[0102Ch]
; @009AC 0000:09AC original=d1e8
    shr ax, 1
; @009AE 0000:09AE original=d1e8
    shr ax, 1
; @009B0 0000:09B0 original=d1e8
    shr ax, 1
; @009B2 0000:09B2 original=d1e8
    shr ax, 1
; @009B4 0000:09B4 original=40
    inc ax
; @009B5 0000:09B5 original=8bd8
    mov bx, ax
; @009B7 0000:09B7 original=2e011e8708
    add word ptr cs:[0887h], bx
; @009BC 0000:09BC original=b448
    mov ah, 048h
; @009BE 0000:09BE original=cd21
    int 021h
; @009C0 0000:09C0 original=7303
    JAE_SHORT loc_009C5
; @009C2 0000:09C2 original=e995fe
    JMP_NEAR loc_0085A
; @009C5 0000:09C5 original=2ea3b295
    mov word ptr cs:[095B2h], ax
; @009C9 0000:09C9 original=8b1e2e10
    mov bx, word ptr ds:[0102Eh]
; @009CD 0000:09CD original=b81000
    mov ax, 010h
; @009D0 0000:09D0 original=f7263010
    mul word ptr ds:[01030h]
; @009D4 0000:09D4 original=03d8
    add bx, ax
; @009D6 0000:09D6 original=b80800
    mov ax, 8
; @009D9 0000:09D9 original=f7263210
    mul word ptr ds:[01032h]
; @009DD 0000:09DD original=03d8
    add bx, ax
; @009DF 0000:09DF original=b80700
    mov ax, 7
; @009E2 0000:09E2 original=f7263410
    mul word ptr ds:[01034h]
; @009E6 0000:09E6 original=03d8
    add bx, ax
; @009E8 0000:09E8 original=b80600
    mov ax, 6
; @009EB 0000:09EB original=f7263610
    mul word ptr ds:[01036h]
; @009EF 0000:09EF original=03d8
    add bx, ax
; @009F1 0000:09F1 original=b80400
    mov ax, 4
; @009F4 0000:09F4 original=f7263810
    mul word ptr ds:[01038h]
; @009F8 0000:09F8 original=03d8
    add bx, ax
; @009FA 0000:09FA original=b80400
    mov ax, 4
; @009FD 0000:09FD original=f7263a10
    mul word ptr ds:[0103Ah]
; @00A01 0000:0A01 original=03d8
    add bx, ax
; @00A03 0000:0A03 original=b81200
    mov ax, 012h
; @00A06 0000:0A06 original=f7263c10
    mul word ptr ds:[0103Ch]
; @00A0A 0000:0A0A original=03d8
    add bx, ax
; @00A0C 0000:0A0C original=a15810
    mov ax, word ptr ds:[01058h]
; @00A0F 0000:0A0F original=d1e0
    shl ax, 1
; @00A11 0000:0A11 original=03d8
    add bx, ax
; @00A13 0000:0A13 original=a15a10
    mov ax, word ptr ds:[0105Ah]
; @00A16 0000:0A16 original=d1e0
    shl ax, 1
; @00A18 0000:0A18 original=03d8
    add bx, ax
; @00A1A 0000:0A1A original=a15c10
    mov ax, word ptr ds:[0105Ch]
; @00A1D 0000:0A1D original=d1e0
    shl ax, 1
; @00A1F 0000:0A1F original=03d8
    add bx, ax
; @00A21 0000:0A21 original=a15e10
    mov ax, word ptr ds:[0105Eh]
; @00A24 0000:0A24 original=d1e0
    shl ax, 1
; @00A26 0000:0A26 original=03d8
    add bx, ax
; @00A28 0000:0A28 original=a16010
    mov ax, word ptr ds:[01060h]
; @00A2B 0000:0A2B original=d1e0
    shl ax, 1
; @00A2D 0000:0A2D original=03d8
    add bx, ax
; @00A2F 0000:0A2F original=a16210
    mov ax, word ptr ds:[01062h]
; @00A32 0000:0A32 original=d1e0
    shl ax, 1
; @00A34 0000:0A34 original=03d8
    add bx, ax
; @00A36 0000:0A36 original=a16410
    mov ax, word ptr ds:[01064h]
; @00A39 0000:0A39 original=d1e0
    shl ax, 1
; @00A3B 0000:0A3B original=03d8
    add bx, ax
; @00A3D 0000:0A3D original=031e6610
    add bx, word ptr ds:[01066h]
; @00A41 0000:0A41 original=031e6810
    add bx, word ptr ds:[01068h]
; @00A45 0000:0A45 original=a16a10
    mov ax, word ptr ds:[0106Ah]
; @00A48 0000:0A48 original=d1e0
    shl ax, 1
; @00A4A 0000:0A4A original=03d8
    add bx, ax
; @00A4C 0000:0A4C original=d1e0
    shl ax, 1
; @00A4E 0000:0A4E original=03d8
    add bx, ax
; @00A50 0000:0A50 original=031e6c10
    add bx, word ptr ds:[0106Ch]
; @00A54 0000:0A54 original=d1eb
    shr bx, 1
; @00A56 0000:0A56 original=d1eb
    shr bx, 1
; @00A58 0000:0A58 original=d1eb
    shr bx, 1
; @00A5A 0000:0A5A original=d1eb
    shr bx, 1
; @00A5C 0000:0A5C original=43
    inc bx
; @00A5D 0000:0A5D original=2e011e8708
    add word ptr cs:[0887h], bx
; @00A62 0000:0A62 original=b448
    mov ah, 048h
; @00A64 0000:0A64 original=cd21
    int 021h
; @00A66 0000:0A66 original=7303
    JAE_SHORT loc_00A6B
; @00A68 0000:0A68 original=e9effd
    JMP_NEAR loc_0085A
; @00A6B 0000:0A6B original=2ea3b495
    mov word ptr cs:[095B4h], ax
; @00A6F 0000:0A6F original=8b1e6e10
    mov bx, word ptr ds:[0106Eh]
; @00A73 0000:0A73 original=d1eb
    shr bx, 1
; @00A75 0000:0A75 original=d1eb
    shr bx, 1
; @00A77 0000:0A77 original=d1eb
    shr bx, 1
; @00A79 0000:0A79 original=d1eb
    shr bx, 1
; @00A7B 0000:0A7B original=43
    inc bx
; @00A7C 0000:0A7C original=2e011e8708
    add word ptr cs:[0887h], bx
; @00A81 0000:0A81 original=b448
    mov ah, 048h
; @00A83 0000:0A83 original=cd21
    int 021h
; @00A85 0000:0A85 original=7303
    JAE_SHORT loc_00A8A
; @00A87 0000:0A87 original=e9d0fd
    JMP_NEAR loc_0085A
; @00A8A 0000:0A8A original=2ea3b695
    mov word ptr cs:[095B6h], ax
; @00A8E 0000:0A8E original=8b1e3e10
    mov bx, word ptr ds:[0103Eh]
; @00A92 0000:0A92 original=031e4010
    add bx, word ptr ds:[01040h]
; @00A96 0000:0A96 original=031e4210
    add bx, word ptr ds:[01042h]
; @00A9A 0000:0A9A original=031e4410
    add bx, word ptr ds:[01044h]
; @00A9E 0000:0A9E original=031e4610
    add bx, word ptr ds:[01046h]
; @00AA2 0000:0AA2 original=031e4810
    add bx, word ptr ds:[01048h]
; @00AA6 0000:0AA6 original=031e4a10
    add bx, word ptr ds:[0104Ah]
; @00AAA 0000:0AAA original=031e4c10
    add bx, word ptr ds:[0104Ch]
; @00AAE 0000:0AAE original=031e4e10
    add bx, word ptr ds:[0104Eh]
; @00AB2 0000:0AB2 original=031e5010
    add bx, word ptr ds:[01050h]
; @00AB6 0000:0AB6 original=031e5010
    add bx, word ptr ds:[01050h]
; @00ABA 0000:0ABA original=031e5010
    add bx, word ptr ds:[01050h]
; @00ABE 0000:0ABE original=031e5210
    add bx, word ptr ds:[01052h]
; @00AC2 0000:0AC2 original=031e5210
    add bx, word ptr ds:[01052h]
; @00AC6 0000:0AC6 original=031e5210
    add bx, word ptr ds:[01052h]
; @00ACA 0000:0ACA original=031e5410
    add bx, word ptr ds:[01054h]
; @00ACE 0000:0ACE original=031e5410
    add bx, word ptr ds:[01054h]
; @00AD2 0000:0AD2 original=031e5410
    add bx, word ptr ds:[01054h]
; @00AD6 0000:0AD6 original=031e5610
    add bx, word ptr ds:[01056h]
; @00ADA 0000:0ADA original=d1eb
    shr bx, 1
; @00ADC 0000:0ADC original=d1eb
    shr bx, 1
; @00ADE 0000:0ADE original=d1eb
    shr bx, 1
; @00AE0 0000:0AE0 original=d1eb
    shr bx, 1
; @00AE2 0000:0AE2 original=43
    inc bx
; @00AE3 0000:0AE3 original=2e011e8708
    add word ptr cs:[0887h], bx
; @00AE8 0000:0AE8 original=b448
    mov ah, 048h
; @00AEA 0000:0AEA original=cd21
    int 021h
; @00AEC 0000:0AEC original=7303
    JAE_SHORT loc_00AF1
; @00AEE 0000:0AEE original=e969fd
    JMP_NEAR loc_0085A
; @00AF1 0000:0AF1 original=2ea3b895
    mov word ptr cs:[095B8h], ax
; @00AF5 0000:0AF5 original=b80001
    mov ax, 0100h
; @00AF8 0000:0AF8 original=f7267010
    mul word ptr ds:[01070h]
; @00AFC 0000:0AFC original=d1e8
    shr ax, 1
; @00AFE 0000:0AFE original=d1e8
    shr ax, 1
; @00B00 0000:0B00 original=d1e8
    shr ax, 1
; @00B02 0000:0B02 original=d1e8
    shr ax, 1
; @00B04 0000:0B04 original=40
    inc ax
; @00B05 0000:0B05 original=8bd8
    mov bx, ax
; @00B07 0000:0B07 original=2e011e8708
    add word ptr cs:[0887h], bx
; @00B0C 0000:0B0C original=b448
    mov ah, 048h
; @00B0E 0000:0B0E original=cd21
    int 021h
; @00B10 0000:0B10 original=7303
    JAE_SHORT loc_00B15
; @00B12 0000:0B12 original=e945fd
    JMP_NEAR loc_0085A
; @00B15 0000:0B15 original=2ea39a95
    mov word ptr cs:[0959Ah], ax
; @00B19 0000:0B19 original=b82c00
    mov ax, 02Ch
; @00B1C 0000:0B1C original=f7267010
    mul word ptr ds:[01070h]
; @00B20 0000:0B20 original=d1e8
    shr ax, 1
; @00B22 0000:0B22 original=d1e8
    shr ax, 1
; @00B24 0000:0B24 original=d1e8
    shr ax, 1
; @00B26 0000:0B26 original=d1e8
    shr ax, 1
; @00B28 0000:0B28 original=40
    inc ax
; @00B29 0000:0B29 original=8bd8
    mov bx, ax
; @00B2B 0000:0B2B original=2e011e8708
    add word ptr cs:[0887h], bx
; @00B30 0000:0B30 original=b448
    mov ah, 048h
; @00B32 0000:0B32 original=cd21
    int 021h
; @00B34 0000:0B34 original=7303
    JAE_SHORT loc_00B39
; @00B36 0000:0B36 original=e921fd
    JMP_NEAR loc_0085A
; @00B39 0000:0B39 original=2ea39c95
    mov word ptr cs:[0959Ch], ax
; @00B3D 0000:0B3D original=c3
    ret
; sub_0000_0B3E
; @00B3E 0000:0B3E original=c706f5c55cc8
    mov word ptr ds:[0C5F5h], 0C85Ch
; @00B44 0000:0B44 original=c706f7c5d6c8
    mov word ptr ds:[0C5F7h], 0C8D6h
; @00B4A 0000:0B4A original=c706f9c502ca
    mov word ptr ds:[0C5F9h], 0CA02h
; @00B50 0000:0B50 original=c706fbc536cc
    mov word ptr ds:[0C5FBh], 0CC36h
; @00B56 0000:0B56 original=c706fdc580cc
    mov word ptr ds:[0C5FDh], 0CC80h
; @00B5C 0000:0B5C original=c706ffc5aacc
    mov word ptr ds:[0C5FFh], 0CCAAh
; @00B62 0000:0B62 original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @00B66 0000:0B66 original=d1e3
    shl bx, 1
; @00B68 0000:0B68 original=81c3c014
    add bx, 014C0h
; @00B6C 0000:0B6C original=8b1f
    mov bx, word ptr ds:[bx]
; @00B6E 0000:0B6E original=891eaa21
    mov word ptr ds:[021AAh], bx
; @00B72 0000:0B72 original=2ea19295
    mov ax, word ptr cs:[09592h]
; @00B76 0000:0B76 original=a3a421
    mov word ptr ds:[021A4h], ax
; @00B79 0000:0B79 original=c706a6210000
    mov word ptr ds:[021A6h], 0
; @00B7F 0000:0B7F original=e8f7ba
    CALL_NEAR loc_0C679
; @00B82 0000:0B82 original=833e80bb00
    cmp word ptr ds:[0BB80h], 0
; @00B87 0000:0B87 original=7405
    JE_SHORT loc_00B8E
; @00B89 0000:0B89 original=e8e942
    CALL_NEAR loc_04E75
; @00B8C 0000:0B8C original=ebf1
    JMP_SHORT loc_00B7F
; @00B8E 0000:0B8E original=2e8e069695
    mov es, word ptr cs:[09596h]
; @00B93 0000:0B93 original=bfaac3
    mov di, 0C3AAh
; @00B96 0000:0B96 original=57
    push di
; @00B97 0000:0B97 original=b90001
    mov cx, 0100h
; @00B9A 0000:0B9A original=b001
    mov al, 1
; @00B9C 0000:0B9C original=f3aa
    rep stosb
; @00B9E 0000:0B9E original=5f
    pop di
; @00B9F 0000:0B9F original=8b365623
    mov si, word ptr ds:[02356h]
; @00BA3 0000:0BA3 original=d1e6
    shl si, 1
; @00BA5 0000:0BA5 original=81c6aac4
    add si, 0C4AAh
; @00BA9 0000:0BA9 original=8b34
    mov si, word ptr ds:[si]
; @00BAB 0000:0BAB original=ac
    lodsb
; @00BAC 0000:0BAC original=3cff
    cmp al, 0FFh
; @00BAE 0000:0BAE original=7409
    JE_SHORT loc_00BB9
; @00BB0 0000:0BB0 original=32e4
    xor ah, ah
; @00BB2 0000:0BB2 original=8bd8
    mov bx, ax
; @00BB4 0000:0BB4 original=ac
    lodsb
; @00BB5 0000:0BB5 original=8801
    mov byte ptr ds:[bx + di], al
; @00BB7 0000:0BB7 original=ebf2
    JMP_SHORT loc_00BAB
; @00BB9 0000:0BB9 original=2e8e069295
    mov es, word ptr cs:[09592h]
; @00BBE 0000:0BBE original=33ff
    xor di, di
; @00BC0 0000:0BC0 original=b91a00
    mov cx, 01Ah
; @00BC3 0000:0BC3 original=b001
    mov al, 1
; @00BC5 0000:0BC5 original=f3aa
    rep stosb
; @00BC7 0000:0BC7 original=bf5f0e
    mov di, 0E5Fh
; @00BCA 0000:0BCA original=bebcd1
    mov si, 0D1BCh
; @00BCD 0000:0BCD original=b94100
    mov cx, 041h
; @00BD0 0000:0BD0 original=f3a4
    rep movsb
; @00BD2 0000:0BD2 original=e9d644
    JMP_NEAR loc_050AB
; @00BD5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00BE5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00BF5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C05 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C15 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C25 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C35 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C45 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C55 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C65 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C75 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C85 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00C95 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00CA5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00CB5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h
; sub_0000_0CB8
; @00CB8 0000:0CB8 original=2ec706d60b0000
    mov word ptr cs:[0BD6h], 0
; @00CBF 0000:0CBF original=2ec706d80b0100
    mov word ptr cs:[0BD8h], 1
; @00CC6 0000:0CC6 original=eb2e
    JMP_SHORT loc_00CF6
; sub_0000_0CC8
; @00CC8 0000:0CC8 original=2ec706d60b0000
    mov word ptr cs:[0BD6h], 0
; @00CCF 0000:0CCF original=2ec706d80b0000
    mov word ptr cs:[0BD8h], 0
; @00CD6 0000:0CD6 original=eb1e
    JMP_SHORT loc_00CF6
; sub_0000_0CD8
; @00CD8 0000:0CD8 original=2ec706d60b0100
    mov word ptr cs:[0BD6h], 1
; @00CDF 0000:0CDF original=2ec706d80b0000
    mov word ptr cs:[0BD8h], 0
; @00CE6 0000:0CE6 original=eb0e
    JMP_SHORT loc_00CF6
; @00CE8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,0C7h,06h,0D6h,0Bh,01h,00h,02Eh,0C7h,06h,0D8h,0Bh,01h,00h
; @00CF6 0000:0CF6 original=e87145
    CALL_NEAR loc_0526A
; @00CF9 0000:0CF9 original=2ea19895
    mov ax, word ptr cs:[09598h]
; @00CFD 0000:0CFD original=a3a421
    mov word ptr ds:[021A4h], ax
; @00D00 0000:0D00 original=c706a6210000
    mov word ptr ds:[021A6h], 0
; @00D06 0000:0D06 original=2ea1de0b
    mov ax, word ptr cs:[0BDEh]
; @00D0A 0000:0D0A original=a3aa21
    mov word ptr ds:[021AAh], ax
; @00D0D 0000:0D0D original=50
    push ax
; @00D0E 0000:0D0E original=e868b9
    CALL_NEAR loc_0C679
; @00D11 0000:0D11 original=833e80bb00
    cmp word ptr ds:[0BB80h], 0
; @00D16 0000:0D16 original=7405
    JE_SHORT loc_00D1D
; @00D18 0000:0D18 original=e85a41
    CALL_NEAR loc_04E75
; @00D1B 0000:0D1B original=ebf1
    JMP_SHORT loc_00D0E
; @00D1D 0000:0D1D original=5d
    pop bp
; @00D1E 0000:0D1E original=4d
    dec bp
; @00D1F 0000:0D1F original=4d
    dec bp
; @00D20 0000:0D20 original=8b6e00
    mov bp, word ptr ss:[bp]
; @00D23 0000:0D23 original=2e803eb0c501
    cmp byte ptr cs:[0C5B0h], 1
; @00D29 0000:0D29 original=7403
    JE_SHORT loc_00D2E
; @00D2B 0000:0D2B original=bdffff
    mov bp, 0FFFFh
; @00D2E 0000:0D2E original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @00D33 0000:0D33 original=2e8e06dc0b
    mov es, word ptr cs:[0BDCh]
; @00D38 0000:0D38 original=2e8b3eda0b
    mov di, word ptr cs:[0BDAh]
; @00D3D 0000:0D3D original=33f6
    xor si, si
; @00D3F 0000:0D3F original=e96a4e
    JMP_NEAR loc_05BAC
; sub_0000_0D42
; @00D42 0000:0D42 original=2ec706de0b9812
    mov word ptr cs:[0BDEh], 01298h
; @00D49 0000:0D49 original=2ea1a895
    mov ax, word ptr cs:[095A8h]
; @00D4D 0000:0D4D original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00D51 0000:0D51 original=e884ff
    CALL_NEAR loc_00CD8
; @00D54 0000:0D54 original=2ec706de0ba412
    mov word ptr cs:[0BDEh], 012A4h
; @00D5B 0000:0D5B original=2ea1aa95
    mov ax, word ptr cs:[095AAh]
; @00D5F 0000:0D5F original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00D63 0000:0D63 original=e872ff
    CALL_NEAR loc_00CD8
; @00D66 0000:0D66 original=2ec706de0bb012
    mov word ptr cs:[0BDEh], 012B0h
; @00D6D 0000:0D6D original=2ea1ac95
    mov ax, word ptr cs:[095ACh]
; @00D71 0000:0D71 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00D75 0000:0D75 original=e860ff
    CALL_NEAR loc_00CD8
; @00D78 0000:0D78 original=2ec706de0bbd12
    mov word ptr cs:[0BDEh], 012BDh
; @00D7F 0000:0D7F original=2ea1a695
    mov ax, word ptr cs:[095A6h]
; @00D83 0000:0D83 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00D87 0000:0D87 original=e84eff
    CALL_NEAR loc_00CD8
; @00D8A 0000:0D8A original=2ec706de0bda12
    mov word ptr cs:[0BDEh], 012DAh
; @00D91 0000:0D91 original=2ea1b295
    mov ax, word ptr cs:[095B2h]
; @00D95 0000:0D95 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00D99 0000:0D99 original=2ec706e00be40b
    mov word ptr cs:[0BE0h], 0BE4h
; @00DA0 0000:0DA0 original=e815ff
    CALL_NEAR loc_00CB8
; @00DA3 0000:0DA3 original=2ec706de0be812
    mov word ptr cs:[0BDEh], 012E8h
; @00DAA 0000:0DAA original=2ea1b495
    mov ax, word ptr cs:[095B4h]
; @00DAE 0000:0DAE original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00DB2 0000:0DB2 original=2ec706e00be40b
    mov word ptr cs:[0BE0h], 0BE4h
; @00DB9 0000:0DB9 original=c60684bb01
    mov byte ptr ds:[0BB84h], 1
; @00DBE 0000:0DBE original=e8f7fe
    CALL_NEAR loc_00CB8
; @00DC1 0000:0DC1 original=c60684bb00
    mov byte ptr ds:[0BB84h], 0
; @00DC6 0000:0DC6 original=2e833ebc9500
    cmp word ptr cs:[095BCh], 0
; @00DCC 0000:0DCC original=7515
    JNE_SHORT loc_00DE3
; @00DCE 0000:0DCE original=2e8e06b495
    mov es, word ptr cs:[095B4h]
; @00DD3 0000:0DD3 original=33ff
    xor di, di
; @00DD5 0000:0DD5 original=b80f00
    mov ax, 0Fh
; @00DD8 0000:0DD8 original=f7263010
    mul word ptr ds:[01030h]
; @00DDC 0000:0DDC original=8bc8
    mov cx, ax
; @00DDE 0000:0DDE original=be161c
    mov si, 01C16h
; @00DE1 0000:0DE1 original=f3a4
    rep movsb
; @00DE3 0000:0DE3 original=2ec706de0b0313
    mov word ptr cs:[0BDEh], 01303h
; @00DEA 0000:0DEA original=2ea1b895
    mov ax, word ptr cs:[095B8h]
; @00DEE 0000:0DEE original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00DF2 0000:0DF2 original=2ec706e00b920c
    mov word ptr cs:[0BE0h], 0C92h
; @00DF9 0000:0DF9 original=e8bcfe
    CALL_NEAR loc_00CB8
; @00DFC 0000:0DFC original=2ec706de0bf612
    mov word ptr cs:[0BDEh], 012F6h
; @00E03 0000:0E03 original=2ea19c95
    mov ax, word ptr cs:[0959Ch]
; @00E07 0000:0E07 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00E0B 0000:0E0B original=e8bafe
    CALL_NEAR loc_00CC8
; @00E0E 0000:0E0E original=c3
    ret
; sub_0000_0E0F
; @00E0F 0000:0E0F original=c70680bb0000
    mov word ptr ds:[0BB80h], 0
; @00E15 0000:0E15 original=e82100
    CALL_NEAR loc_00E39
; @00E18 0000:0E18 original=e85200
    CALL_NEAR loc_00E6D
; @00E1B 0000:0E1B original=eb06
    JMP_SHORT loc_00E23
; sub_0000_0E1D
; @00E1D 0000:0E1D original=e80700
    CALL_NEAR loc_00E27
; @00E20 0000:0E20 original=e82e00
    CALL_NEAR loc_00E51
; @00E23 0000:0E23 original=e86b00
    CALL_NEAR loc_00E91
; @00E26 0000:0E26 original=c3
    ret
; sub_0000_0E27
; @00E27 0000:0E27 original=8b16aa21
    mov dx, word ptr ds:[021AAh]
; @00E2B 0000:0E2B original=33c9
    xor cx, cx
; @00E2D 0000:0E2D original=b002
    mov al, 2
; @00E2F 0000:0E2F original=b43c
    mov ah, 03Ch
; @00E31 0000:0E31 original=cd21
    int 021h
; @00E33 0000:0E33 original=7236
    JB_SHORT loc_00E6B
; @00E35 0000:0E35 original=a3ac21
    mov word ptr ds:[021ACh], ax
; @00E38 0000:0E38 original=c3
    ret
; sub_0000_0E39
; @00E39 0000:0E39 original=8b16aa21
    mov dx, word ptr ds:[021AAh]
; @00E3D 0000:0E3D original=32c0
    xor al, al
; @00E3F 0000:0E3F original=b43d
    mov ah, 03Dh
; @00E41 0000:0E41 original=cd21
    int 021h
; @00E43 0000:0E43 original=7204
    JB_SHORT loc_00E49
; @00E45 0000:0E45 original=a3ac21
    mov word ptr ds:[021ACh], ax
; @00E48 0000:0E48 original=c3
    ret
; @00E49 0000:0E49 original=c70680bb0100
    mov word ptr ds:[0BB80h], 1
; @00E4F 0000:0E4F original=eb1a
    JMP_SHORT loc_00E6B
; sub_0000_0E51
; @00E51 0000:0E51 original=a1a421
    mov ax, word ptr ds:[021A4h]
; @00E54 0000:0E54 original=8b1eac21
    mov bx, word ptr ds:[021ACh]
; @00E58 0000:0E58 original=8b0ea821
    mov cx, word ptr ds:[021A8h]
; @00E5C 0000:0E5C original=8b16a621
    mov dx, word ptr ds:[021A6h]
; @00E60 0000:0E60 original=1e
    push ds
; @00E61 0000:0E61 original=8ed8
    mov ds, ax
; @00E63 0000:0E63 original=b440
    mov ah, 040h
; @00E65 0000:0E65 original=cd21
    int 021h
; @00E67 0000:0E67 original=1f
    pop ds
; @00E68 0000:0E68 original=7201
    JB_SHORT loc_00E6B
; @00E6A 0000:0E6A original=c3
    ret
; @00E6B 0000:0E6B original=58
    pop ax
; @00E6C 0000:0E6C original=c3
    ret
; sub_0000_0E6D
; @00E6D 0000:0E6D original=a1a421
    mov ax, word ptr ds:[021A4h]
; @00E70 0000:0E70 original=8b1eac21
    mov bx, word ptr ds:[021ACh]
; @00E74 0000:0E74 original=b9ffff
    mov cx, 0FFFFh
; @00E77 0000:0E77 original=8b16a621
    mov dx, word ptr ds:[021A6h]
; @00E7B 0000:0E7B original=1e
    push ds
; @00E7C 0000:0E7C original=8ed8
    mov ds, ax
; @00E7E 0000:0E7E original=b43f
    mov ah, 03Fh
; @00E80 0000:0E80 original=cd21
    int 021h
; @00E82 0000:0E82 original=1f
    pop ds
; @00E83 0000:0E83 original=7204
    JB_SHORT loc_00E89
; @00E85 0000:0E85 original=a3a821
    mov word ptr ds:[021A8h], ax
; @00E88 0000:0E88 original=c3
    ret
; @00E89 0000:0E89 original=c70680bb0200
    mov word ptr ds:[0BB80h], 2
; @00E8F 0000:0E8F original=ebda
    JMP_SHORT loc_00E6B
; sub_0000_0E91
; @00E91 0000:0E91 original=8b1eac21
    mov bx, word ptr ds:[021ACh]
; @00E95 0000:0E95 original=b43e
    mov ah, 03Eh
; @00E97 0000:0E97 original=cd21
    int 021h
; @00E99 0000:0E99 original=72d0
    JB_SHORT loc_00E6B
; @00E9B 0000:0E9B original=c3
    ret
; sub_0000_0E9C
; @00E9C 0000:0E9C original=2ea19a95
    mov ax, word ptr cs:[0959Ah]
; @00EA0 0000:0EA0 original=a3a421
    mov word ptr ds:[021A4h], ax
; @00EA3 0000:0EA3 original=c706a6210000
    mov word ptr ds:[021A6h], 0
; @00EA9 0000:0EA9 original=8b365623
    mov si, word ptr ds:[02356h]
; @00EAD 0000:0EAD original=d1e6
    shl si, 1
; @00EAF 0000:0EAF original=d1e6
    shl si, 1
; @00EB1 0000:0EB1 original=81c6e814
    add si, 014E8h
; @00EB5 0000:0EB5 original=ad
    lodsw
; @00EB6 0000:0EB6 original=a3e614
    mov word ptr ds:[014E6h], ax
; @00EB9 0000:0EB9 original=ad
    lodsw
; @00EBA 0000:0EBA original=a3aa21
    mov word ptr ds:[021AAh], ax
; @00EBD 0000:0EBD original=2ea3de0b
    mov word ptr cs:[0BDEh], ax
; @00EC1 0000:0EC1 original=2ea19a95
    mov ax, word ptr cs:[0959Ah]
; @00EC5 0000:0EC5 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00EC9 0000:0EC9 original=e8fcfd
    CALL_NEAR loc_00CC8
; @00ECC 0000:0ECC original=a1e614
    mov ax, word ptr ds:[014E6h]
; @00ECF 0000:0ECF original=2ea3de0b
    mov word ptr cs:[0BDEh], ax
; @00ED3 0000:0ED3 original=2ea1ae95
    mov ax, word ptr cs:[095AEh]
; @00ED7 0000:0ED7 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00EDB 0000:0EDB original=e8fafd
    CALL_NEAR loc_00CD8
; @00EDE 0000:0EDE original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @00EE2 0000:0EE2 original=d1e3
    shl bx, 1
; @00EE4 0000:0EE4 original=8b870815
    mov ax, word ptr ds:[bx + 01508h]
; @00EE8 0000:0EE8 original=2ea3de0b
    mov word ptr cs:[0BDEh], ax
; @00EEC 0000:0EEC original=2ea1b695
    mov ax, word ptr cs:[095B6h]
; @00EF0 0000:0EF0 original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @00EF4 0000:0EF4 original=2ec706e00be20b
    mov word ptr cs:[0BE0h], 0BE2h
; @00EFB 0000:0EFB original=c60684bb01
    mov byte ptr ds:[0BB84h], 1
; @00F00 0000:0F00 original=e8b5fd
    CALL_NEAR loc_00CB8
; @00F03 0000:0F03 original=c60684bb00
    mov byte ptr ds:[0BB84h], 0
; @00F08 0000:0F08 original=e9a041
    JMP_NEAR loc_050AB
; sub_0000_0F0B
; @00F0B 0000:0F0B original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @00F10 0000:0F10 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @00F15 0000:0F15 original=bfc899
    mov di, 099C8h
; @00F18 0000:0F18 original=b91000
    mov cx, 010h
; @00F1B 0000:0F1B original=b8ffff
    mov ax, 0FFFFh
; @00F1E 0000:0F1E original=f3ab
    rep stosw
; @00F20 0000:0F20 original=2ea19e95
    mov ax, word ptr cs:[0959Eh]
; @00F24 0000:0F24 original=d1e0
    shl ax, 1
; @00F26 0000:0F26 original=d1e0
    shl ax, 1
; @00F28 0000:0F28 original=d1e0
    shl ax, 1
; @00F2A 0000:0F2A original=d1e0
    shl ax, 1
; @00F2C 0000:0F2C original=f7d8
    neg ax
; @00F2E 0000:0F2E original=b9d000
    mov cx, 0D0h
; @00F31 0000:0F31 original=ab
    stosw
; @00F32 0000:0F32 original=2e03069e95
    add ax, word ptr cs:[0959Eh]
; @00F37 0000:0F37 original=e2f8
    LOOP_SHORT loc_00F31
; @00F39 0000:0F39 original=b8ffff
    mov ax, 0FFFFh
; @00F3C 0000:0F3C original=b92000
    mov cx, 020h
; @00F3F 0000:0F3F original=f3ab
    rep stosw
; @00F41 0000:0F41 original=bfc89b
    mov di, 09BC8h
; @00F44 0000:0F44 original=33c0
    xor ax, ax
; @00F46 0000:0F46 original=b9c800
    mov cx, 0C8h
; @00F49 0000:0F49 original=ab
    stosw
; @00F4A 0000:0F4A original=2e03069e95
    add ax, word ptr cs:[0959Eh]
; @00F4F 0000:0F4F original=e2f8
    LOOP_SHORT loc_00F49
; @00F51 0000:0F51 original=bf589d
    mov di, 09D58h
; @00F54 0000:0F54 original=33c0
    xor ax, ax
; @00F56 0000:0F56 original=b9c800
    mov cx, 0C8h
; @00F59 0000:0F59 original=ab
    stosw
; @00F5A 0000:0F5A original=2e0306a095
    add ax, word ptr cs:[095A0h]
; @00F5F 0000:0F5F original=e2f8
    LOOP_SHORT loc_00F59
; @00F61 0000:0F61 original=bfe89e
    mov di, 09EE8h
; @00F64 0000:0F64 original=b9c800
    mov cx, 0C8h
; @00F67 0000:0F67 original=33c0
    xor ax, ax
; @00F69 0000:0F69 original=ab
    stosw
; @00F6A 0000:0F6A original=97
    xchg ax, di
; @00F6B 0000:0F6B original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @00F70 0000:0F70 original=d1e3
    shl bx, 1
; @00F72 0000:0F72 original=2effa7770f
    jmp word ptr cs:[bx + 0F77h]
; @00F77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Dh,0Fh,08Dh,0Fh,092h,0Fh
; sub_0000_0F7D
; @00F7D 0000:0F7D original=81c70020
    add di, 02000h
; @00F81 0000:0F81 original=f7c70040
    test di, 04000h
; @00F85 0000:0F85 original=7404
    JE_SHORT loc_00F8B
; @00F87 0000:0F87 original=81c750c0
    add di, 0C050h
; @00F8B 0000:0F8B original=eb13
    JMP_SHORT loc_00FA0
; sub_0000_0F8D
; @00F8D 0000:0F8D original=83c728
    add di, 028h
; @00F90 0000:0F90 original=eb0e
    JMP_SHORT loc_00FA0
; sub_0000_0F92
; @00F92 0000:0F92 original=81c70020
    add di, 02000h
; @00F96 0000:0F96 original=f7c70080
    test di, 08000h
; @00F9A 0000:0F9A original=7404
    JE_SHORT loc_00FA0
; @00F9C 0000:0F9C original=81c7a080
    add di, 080A0h
; @00FA0 0000:0FA0 original=97
    xchg ax, di
; @00FA1 0000:0FA1 original=e2c6
    LOOP_SHORT loc_00F69
; @00FA3 0000:0FA3 original=0e
    push cs
; @00FA4 0000:0FA4 original=07
    pop es
; @00FA5 0000:0FA5 original=bf928d
    mov di, 08D92h
; @00FA8 0000:0FA8 original=b90001
    mov cx, 0100h
; @00FAB 0000:0FAB original=33c0
    xor ax, ax
; @00FAD 0000:0FAD original=ab
    stosw
; @00FAE 0000:0FAE original=03067010
    add ax, word ptr ds:[01070h]
; @00FB2 0000:0FB2 original=e2f9
    LOOP_SHORT loc_00FAD
; @00FB4 0000:0FB4 original=bf928f
    mov di, 08F92h
; @00FB7 0000:0FB7 original=b90001
    mov cx, 0100h
; @00FBA 0000:0FBA original=33c0
    xor ax, ax
; @00FBC 0000:0FBC original=ab
    stosw
; @00FBD 0000:0FBD original=03062410
    add ax, word ptr ds:[01024h]
; @00FC1 0000:0FC1 original=e2f9
    LOOP_SHORT loc_00FBC
; @00FC3 0000:0FC3 original=bf9291
    mov di, 09192h
; @00FC6 0000:0FC6 original=b90001
    mov cx, 0100h
; @00FC9 0000:0FC9 original=33c0
    xor ax, ax
; @00FCB 0000:0FCB original=ab
    stosw
; @00FCC 0000:0FCC original=03062610
    add ax, word ptr ds:[01026h]
; @00FD0 0000:0FD0 original=e2f9
    LOOP_SHORT loc_00FCB
; @00FD2 0000:0FD2 original=bf9293
    mov di, 09392h
; @00FD5 0000:0FD5 original=b90001
    mov cx, 0100h
; @00FD8 0000:0FD8 original=33c0
    xor ax, ax
; @00FDA 0000:0FDA original=ab
    stosw
; @00FDB 0000:0FDB original=03062810
    add ax, word ptr ds:[01028h]
; @00FDF 0000:0FDF original=e2f9
    LOOP_SHORT loc_00FDA
; @00FE1 0000:0FE1 original=e98642
    JMP_NEAR loc_0526A
; sub_0000_0FE4
; BuildByteToNibbleMaskTable (modern reconstruction name)
; For each byte0..255 write four bytes to DS:1514+4*value, mapping bits7..0 to high/low nibble masks F/0 in
; order. Sets ES=CS:9596 but stores use DS, which caller must supply. Changes AL,DX,DI and flags;
; AH,BX,CX,SI,BP,DS unchanged; DI=1917h on return.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @00FE4 0000:0FE4 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @00FE9 0000:0FE9 original=bf1715
    mov di, 01517h
; @00FEC 0000:0FEC original=32f6
    xor dh, dh
; @00FEE 0000:0FEE original=8ad6
    mov dl, dh
; @00FF0 0000:0FF0 original=32c0
    xor al, al
; @00FF2 0000:0FF2 original=d0da
    rcr dl, 1
; @00FF4 0000:0FF4 original=7302
    JAE_SHORT loc_00FF8
; @00FF6 0000:0FF6 original=b00f
    mov al, 0Fh
; @00FF8 0000:0FF8 original=d0da
    rcr dl, 1
; @00FFA 0000:0FFA original=7302
    JAE_SHORT loc_00FFE
; @00FFC 0000:0FFC original=04f0
    add al, 0F0h
; @00FFE 0000:0FFE original=8805
    mov byte ptr ds:[di], al
; @01000 0000:1000 original=4f
    dec di
; @01001 0000:1001 original=32c0
    xor al, al
; @01003 0000:1003 original=d0da
    rcr dl, 1
; @01005 0000:1005 original=7302
    JAE_SHORT loc_01009
; @01007 0000:1007 original=b00f
    mov al, 0Fh
; @01009 0000:1009 original=d0da
    rcr dl, 1
; @0100B 0000:100B original=7302
    JAE_SHORT loc_0100F
; @0100D 0000:100D original=04f0
    add al, 0F0h
; @0100F 0000:100F original=8805
    mov byte ptr ds:[di], al
; @01011 0000:1011 original=4f
    dec di
; @01012 0000:1012 original=32c0
    xor al, al
; @01014 0000:1014 original=d0da
    rcr dl, 1
; @01016 0000:1016 original=7302
    JAE_SHORT loc_0101A
; @01018 0000:1018 original=b00f
    mov al, 0Fh
; @0101A 0000:101A original=d0da
    rcr dl, 1
; @0101C 0000:101C original=7302
    JAE_SHORT loc_01020
; @0101E 0000:101E original=04f0
    add al, 0F0h
; @01020 0000:1020 original=8805
    mov byte ptr ds:[di], al
; @01022 0000:1022 original=4f
    dec di
; @01023 0000:1023 original=32c0
    xor al, al
; @01025 0000:1025 original=d0da
    rcr dl, 1
; @01027 0000:1027 original=7302
    JAE_SHORT loc_0102B
; @01029 0000:1029 original=b00f
    mov al, 0Fh
; @0102B 0000:102B original=d0da
    rcr dl, 1
; @0102D 0000:102D original=7302
    JAE_SHORT loc_01031
; @0102F 0000:102F original=04f0
    add al, 0F0h
; @01031 0000:1031 original=8805
    mov byte ptr ds:[di], al
; @01033 0000:1033 original=4f
    dec di
; @01034 0000:1034 original=83c708
    add di, 8
; @01037 0000:1037 original=fec6
    inc dh
; @01039 0000:1039 original=75b3
    JNE_SHORT loc_00FEE
; @0103B 0000:103B original=c3
    ret
; @0103C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08Bh,05h,023h,04h,0Bh,044h,04h,026h,089h,05h,026h,08Bh,045h,02h,023h
; @0104C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,02h,0Bh,044h,06h,026h,089h,045h,02h,083h,0C7h,01Ah,026h,08Bh,05h,023h
; @0105C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0Bh,044h,08h,026h,089h,05h,026h,08Bh,045h,02h,023h,044h,02h,0Bh,044h
; @0106C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ah,026h,089h,045h,02h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h,0Ch
; @0107C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,089h,05h,026h,08Bh,045h,02h,023h,044h,02h,0Bh,044h,0Eh,026h,089h,045h
; @0108C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h,010h,026h,089h,05h,026h
; @0109C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,045h,02h,023h,044h,02h,0Bh,044h,012h,026h,089h,045h,02h,083h,0C7h,01Ah
; @010AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C6h,014h,0E2h,08Bh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,0F7h,0D0h,026h
; @010BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05h,026h,09h,045h,01Ah,026h,09h,045h,034h,026h,09h,045h,04Eh,08Bh,044h
; @010CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0F7h,0D0h,026h,09h,045h,02h,026h,09h,045h,01Ch,026h,09h,045h,036h,026h
; @010DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,045h,050h,083h,0C7h,068h,083h,0C6h,014h,0E2h,0D0h,02Eh,08Eh,01Eh,096h,095h
; @010EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h
; @010FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h
; @0110C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h
; @0111C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Dh,036h,026h,020h,055h,038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h
; @0112C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
; @0113C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh
; @0114C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
; @0115C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,08Bh,044h,0Ch
; @0116C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h
; @0117C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,08Bh,044h,010h,08Bh,05Ch
; @0118C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h
; @0119C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h
; @011AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0EBh,03h,0E9h,03Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch
; @011BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h
; @011CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h
; @011DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,055h,04h,026h,021h,045h,01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh
; @011EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,021h,045h,034h,026h,021h,05Dh,036h,026h,020h,055h,038h,026h,021h,045h,04Eh
; @011FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,021h,05Dh,050h,026h,020h,055h,052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h
; @0120C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
; @0121C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh
; @0122C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
; @0123C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h
; @0124C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05Dh,01Ch,026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h
; @0125C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
; @0126C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,08Bh
; @0127C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h
; @0128C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,04Eh,026h
; @0129C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h,0EBh
; @012AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,08h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h
; @012BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h
; @012CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
; @012DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,026h,021h,05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h,045h
; @012EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,026h,021h,05Dh,01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h,05Dh
; @012FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 036h,026h,020h,055h,038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h,055h
; @0130C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 052h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
; @0131C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h
; @0132C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h
; @0133C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,04h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
; @0134C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
; @0135C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch
; @0136C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh
; @0137C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
; @0138C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h
; @0139C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Dh,036h,026h,08h,055h,038h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h
; @013AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
; @013BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,04Eh
; @013CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h
; @013DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,03h,0E9h,0D5h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h
; @013EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h
; @013FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h
; @0140C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,021h
; @0141C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,026h,021h,05Dh,02h,026h,020h,055h,04h,026h,021h,045h,01Ah,026h,021h,05Dh
; @0142C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ch,026h,020h,055h,01Eh,026h,021h,045h,034h,026h,021h,05Dh,036h,026h,020h,055h
; @0143C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 038h,026h,021h,045h,04Eh,026h,021h,05Dh,050h,026h,020h,055h,052h,08Bh,044h,04h
; @0144C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Ch,06h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h
; @0145C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h
; @0146C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h
; @0147C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,05Dh,02h,026h,08h,055h,04h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h
; @0148C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
; @0149C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
; @014AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch
; @014BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08h,055h,01Eh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h,0D2h,0D0h,0E8h,0D0h,0DCh
; @014CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
; @014DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
; @014EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0DAh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h
; @014FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
; @0150C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
; @0151C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
; @0152C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h
; @0153C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,014h,0E2h,02h,0EBh,03h,0E9h,0A2h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h
; @0154C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
; @0155C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D7h,0D0h
; @0156C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,021h
; @0157C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Dh,03h,026h,020h,055h,01Ah,026h,021h,045h,01Bh,026h,021h,05Dh,01Dh,026h,020h
; @0158C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,034h,026h,021h,045h,035h,026h,021h,05Dh,037h,026h,020h,055h,04Eh,026h,021h
; @0159C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,04Fh,026h,021h,05Dh,051h,08Bh,044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E7h
; @015AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
; @015BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h
; @015CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,045h,01h,026h,09h,05Dh,03h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h
; @015DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h
; @015EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h
; @015FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch,0Eh,032h
; @0160C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
; @0161C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
; @0162C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,055h,034h,026h,09h,045h,035h,026h,09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch
; @0163C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 012h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h
; @0164C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
; @0165C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h
; @0166C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C6h,014h,0E2h,02h,0EBh,03h,0E9h,0D5h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h
; @0167C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B2h,0FFh,08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
; @0168C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D2h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h
; @0169C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,021h,045h,01h,026h,021h,05Dh,03h,026h,020h,055h,01Ah,026h,021h,045h,01Bh
; @016AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,021h,05Dh,01Dh,026h,020h,055h,034h,026h,021h,045h,035h,026h,021h,05Dh,037h
; @016BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,055h,04Eh,026h,021h,045h,04Fh,026h,021h,05Dh,051h,08Bh,044h,04h,08Bh
; @016CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Ch,06h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h
; @016DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h
; @016EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05Dh,03h,08Bh,044h,08h,08Bh,05Ch,0Ah,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
; @016FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
; @0170C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,055h,01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch
; @0171C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Eh,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h
; @0172C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,034h,026h,09h,045h,035h,026h
; @0173C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h
; @0174C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h
; @0175C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h,083h,0C6h
; @0176C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,0E2h,02h,0EBh,03h,0E9h,08h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh
; @0177C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,04h,08Bh,05Ch,02h,0F9h,0D0h,0D7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
; @0178C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,015h,026h,021h,045h,01h,026h,021h,05Dh,03h,026h,020h,055h,01Ah,026h
; @0179C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,045h,01Bh,026h,021h,05Dh,01Dh,026h,020h,055h,034h,026h,021h,045h,035h,026h
; @017AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,05Dh,037h,026h,020h,055h,04Eh,026h,021h,045h,04Fh,026h,021h,05Dh,051h,08Bh
; @017BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,04h,08Bh,05Ch,06h,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h
; @017CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,08Bh,044h,08h,08Bh
; @017DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Ch,0Ah,032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h
; @017EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,08Bh,044h,0Ch,08Bh,05Ch,0Eh
; @017FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,034h
; @0180C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,045h,035h,026h,09h,05Dh,037h,08Bh,044h,010h,08Bh,05Ch,012h,032h,0D2h
; @0181C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h
; @0182C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h,083h,0C6h,014h,0E2h,02h,0EBh,03h
; @0183C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,03Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh
; @0184C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh
; @0185C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h,04h,026h,09h,045h,01Ah,026h
; @0186C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05Dh,01Ch,026h,08h,055h,01Eh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h
; @0187C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,055h,038h,026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h
; @0188C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,068h,083h,0C6h,014h,0E2h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh
; @0189C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Ch,02h,0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
; @018AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h
; @018BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,026h,09h,05Dh,02h,026h,08h,055h,04h,026h,09h,045h,01Ah,026h,09h,05Dh
; @018CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ch,026h,08h,055h,01Eh,026h,09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h
; @018DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 038h,026h,09h,045h,04Eh,026h,09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h
; @018EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C6h,014h,0E2h,0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h
; @018FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh
; @0190C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
; @0191C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h,08h,055h
; @0192C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,026h,09h,045h
; @0193C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,026h,09h,05Dh,036h,026h,08h,055h,038h,026h,09h,045h,04Eh,026h,09h,05Dh
; @0194C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,09Eh,02Eh,08Eh,01Eh
; @0195C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h,08Bh,04h,08Bh,05Ch,02h,0B2h,0FFh,0F7h,0D0h,0F7h,0D3h,0F6h,0D2h
; @0196C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh
; @0197C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,0D0h,0E8h
; @0198C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DBh,0D0h,0DFh,0D0h,0DAh,026h,09h,05h,026h,09h,05Dh,02h,026h
; @0199C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,055h,04h,026h,09h,045h,01Ah,026h,09h,05Dh,01Ch,026h,08h,055h,01Eh,026h
; @019AC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,045h,034h,026h,09h,05Dh,036h,026h,08h,055h,038h,026h,09h,045h,04Eh,026h
; @019BC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05Dh,050h,026h,08h,055h,052h,083h,0C7h,068h,083h,0C6h,014h,0E2h,094h,02Eh
; @019CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,08Bh,05Ch,02h,0F6h,0D2h,0F7h,0D0h
; @019DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h
; @019EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
; @019FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h,01Ah,026h
; @01A0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,045h,01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h,035h,026h
; @01A1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05Dh,037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h
; @01A2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,068h,083h,0C6h,014h,0E2h,09Eh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh
; @01A3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,08Bh,05Ch,02h,0F6h,0D2h,0F7h,0D0h,0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h
; @01A4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,08h
; @01A5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h,01Ah,026h,09h,045h
; @01A6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h,035h,026h,09h,05Dh
; @01A7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh,051h,083h,0C7h,068h
; @01A8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C6h,014h,0E2h,0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,08Bh
; @01A9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Ch,02h,0F6h,0D2h,0F7h,0D0h,0F7h,0D3h,0D0h,0E7h,0D0h,0D3h,0D0h,0D4h,0D0h,0D0h
; @01AAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h,09h,05Dh,03h,026h,08h,055h
; @01ABC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,026h,09h,045h,01Bh,026h,09h,05Dh,01Dh,026h,08h,055h,034h,026h,09h,045h
; @01ACC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 035h,026h,09h,05Dh,037h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,026h,09h,05Dh
; @01ADC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 051h,083h,0C7h,068h,083h,0C6h,014h,0E2h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,026h
; @01AEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05h,023h,04h,0Bh,044h,02h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h
; @01AFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,04h,0Bh,044h,04h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h
; @01B0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Bh,044h,06h,026h,089h,05h,083h,0C7h,01Ah,026h,08Bh,05h,023h,04h,0Bh,044h
; @01B1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,026h,089h,05h,083h,0C7h,01Ah,083h,0C6h,0Ah,0E2h,0C3h,02Eh,08Eh,01Eh,096h
; @01B2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0C3h,08Bh,04h,0F7h,0D0h,026h,09h,05h,026h,09h,045h,01Ah,026h,09h,045h
; @01B3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,026h,09h,045h,04Eh,083h,0C6h,0Ah,083h,0C7h,068h,0E2h,0E5h,02Eh,08Eh,01Eh
; @01B4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h
; @01B5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h
; @01B6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h
; @01B7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh,032h,0D2h,0D0h
; @01B8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h
; @01B9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h,055h,036h,0ADh,032h
; @01BAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,04Eh,026h,08h,055h,050h,083h
; @01BBC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,068h,0E2h,08Fh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h
; @01BCC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h
; @01BDC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h,026h,020h
; @01BEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h,0E8h,0D0h
; @01BFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h
; @01C0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h
; @01C1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,045h,01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
; @01C2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h,055h,036h,0ADh,032h
; @01C3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
; @01C4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,026h,08h,055h,050h,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h,06Bh,0FFh,02Eh
; @01C5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
; @01C6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h
; @01C7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h,034h
; @01C8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h,0D0h
; @01C9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
; @01CAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h
; @01CBC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
; @01CCC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,026h,08h,055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
; @01CDC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,034h,026h,08h
; @01CEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,036h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
; @01CFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,04Eh,026h,08h,055h,050h,083h
; @01D0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,068h,0E2h,02h,0EBh,03h,0E9h,04Ch,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh
; @01D1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
; @01D2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h
; @01D3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,026h,020h,055h,02h,026h,021h,045h,01Ah,026h,020h,055h,01Ch,026h,021h,045h
; @01D4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,026h,020h,055h,036h,026h,021h,045h,04Eh,026h,020h,055h,050h,0ADh,032h,0D2h
; @01D5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
; @01D6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,0ADh
; @01D7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
; @01D8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h,01Ah,026h,08h
; @01D9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,01Ch,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h
; @01DAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,045h
; @01DBC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,026h,08h,055h,036h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
; @01DCC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
; @01DDC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,045h,04Eh,026h,08h,055h,050h,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h
; @01DEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,0ADh,0F9h,0D0h,0D4h,0D0h,0D0h
; @01DFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D2h,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h
; @01E0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,020h,015h,026h,021h,045h,01h,026h,020h,055h,01Ah,026h,021h,045h,01Bh,026h
; @01E1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,055h,034h,026h,021h,045h,035h,026h,020h,055h,04Eh,026h,021h,045h,04Fh,0ADh
; @01E2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
; @01E3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h
; @01E4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h
; @01E5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08h,055h,01Ah,026h,09h,045h,01Bh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
; @01E6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h
; @01E7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
; @01E8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h
; @01E9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,04Fh,083h,0C7h,068h,0E2h,02h,0EBh,03h,0E9h,04Ch,0FFh,02Eh,08Eh,01Eh,096h
; @01EAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0C3h,0B2h,0FFh,0ADh,0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,0F9h,0D0h,0D4h,0D0h
; @01EBC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,020h,055h,01Ah,026h,021h
; @01ECC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,01Bh,026h,020h,055h,034h,026h,021h,045h,035h,026h,020h,055h,04Eh,026h,021h
; @01EDC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,04Fh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
; @01EEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,026h,08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
; @01EFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,0ADh
; @01F0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h
; @01F1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h
; @01F2C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h
; @01F3C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,02h,0EBh,03h,0E9h,06Bh,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,0ADh
; @01F4C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F9h,0D0h,0D4h,0D0h,0D0h,0D0h,0D2h,026h,020h,015h,026h,021h,045h,01h,026h,020h
; @01F5C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,01Ah,026h,021h,045h,01Bh,026h,020h,055h,034h,026h,021h,045h,035h,026h,020h
; @01F6C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,04Eh,026h,021h,045h,04Fh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h
; @01F7C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,015h,026h,09h,045h,01h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h
; @01F8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,055h,01Ah,026h,09h,045h,01Bh,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h
; @01F9C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08h,055h,034h,026h,09h,045h,035h,0ADh,032h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h
; @01FAC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,0E2h,08Fh,02Eh,08Eh
; @01FBC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,096h,095h,0C3h,08Bh,04h,0B2h,0FFh,0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh
; @01FCC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h,055h
; @01FDC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h,055h
; @01FEC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0CBh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh
; @01FFC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0B2h,0FFh,0F7h
part00 ends
end
