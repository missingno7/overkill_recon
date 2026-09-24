; Modern optional-module source; historical source filename unknown.
; Original resource: ADLIB.ENC; no relocation table in ENC stream.
include ENCODING.INC
driver segment byte public 'CODE'
assume cs:driver,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
Opl2Table04B1 equ 04B1h

Opl2BasePortWord equ 0Eh ; modern name, word at module header +0Eh
loc_00063 equ 063h
loc_000C0 equ 0C0h
loc_000C5 equ 0C5h
loc_000CD equ 0CDh
loc_000F0 equ 0F0h
loc_000F6 equ 0F6h
loc_000F7 equ 0F7h
loc_00109 equ 0109h
loc_0011B equ 011Bh
loc_0012A equ 012Ah
loc_00135 equ 0135h
loc_00181 equ 0181h
loc_0018B equ 018Bh
loc_00243 equ 0243h
StepIndex13AndWriteA0B0_00244 equ 0244h
WriteRecordA0B0Pair_0024F equ 024Fh
loc_00291 equ 0291h
loc_00297 equ 0297h
loc_002AA equ 02AAh
loc_002C8 equ 02C8h
loc_002C9 equ 02C9h
loc_002F6 equ 02F6h
loc_00302 equ 0302h
loc_00303 equ 0303h
loc_00325 equ 0325h
loc_0032C equ 032Ch
loc_00331 equ 0331h
loc_00371 equ 0371h
loc_0038D equ 038Dh
loc_00409 equ 0409h
loc_00417 equ 0417h
loc_00421 equ 0421h
loc_00430 equ 0430h
loc_0043A equ 043Ah
loc_0046D equ 046Dh
loc_004A3 equ 04A3h
WriteOpl2Table04B1_004A4 equ 04A4h
loc_004A8 equ 04A8h
loc_004E9 equ 04E9h
loc_00502 equ 0502h
loc_0050D equ 050Dh
loc_00520 equ 0520h
loc_00550 equ 0550h
WriteOpl2Register_00557 equ 0557h
DelayViaPit2Counter_00579 equ 0579h
loc_00587 equ 0587h
; @00000 module:0000 original=e86000
    CALL_NEAR loc_00063
; @00003 module:0003 original=cb
    retf
; @00004 module:0004 original=e8e204
    CALL_NEAR loc_004E9
; @00007 module:0007 original=cb
    retf
; @00008 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,088h,03h,00h,00h,054h,079h,070h,065h,020h,03Ah
; @00018 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,041h,064h,04Ch,069h,062h,0Dh,0Ah,020h,046h,069h,06Ch,065h,020h,03Ah,020h
; @00028 UNKNOWN module bytes; code/data distinction not yet proven
    db 04Fh,076h,065h,072h,06Bh,069h,06Ch,06Ch,024h,044h,061h,074h,065h,020h,03Ah,020h
; @00038 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,033h,02Eh,031h,031h,02Eh,039h,032h,024h,04Dh,075h,073h,069h,063h,020h,062h
; @00048 UNKNOWN module bytes; code/data distinction not yet proven
    db 079h,020h,053h,06Fh,075h,06Eh,064h,020h,049h,06Dh,061h,067h,065h,073h,020h,028h
; @00058 UNKNOWN module bytes; code/data distinction not yet proven
    db 063h,029h,020h,031h,039h,039h,032h,00h,01h,00h,00h
; @00063 module:0063 original=50
    push ax
; @00064 module:0064 original=53
    push bx
; @00065 module:0065 original=51
    push cx
; @00066 module:0066 original=52
    push dx
; @00067 module:0067 original=57
    push di
; @00068 module:0068 original=56
    push si
; @00069 module:0069 original=1e
    push ds
; @0006A module:006A original=0e
    push cs
; @0006B module:006B original=1f
    pop ds
; @0006C module:006C original=be6200
    mov si, 062h
; @0006F module:006F original=803c00
    cmp byte ptr ds:[si], 0
; @00072 module:0072 original=7551
    JNE_SHORT loc_000C5
; @00074 module:0074 original=fe04
    inc byte ptr ds:[si]
; @00076 module:0076 original=e89003
    CALL_NEAR loc_00409
; @00079 module:0079 original=fe0e0d00
    dec byte ptr ds:[0Dh]
; @0007D module:007D original=bfa905
    mov di, 05A9h
; @00080 module:0080 original=e84a00
    CALL_NEAR loc_000CD
; @00083 module:0083 original=bfc905
    mov di, 05C9h
; @00086 module:0086 original=e84400
    CALL_NEAR loc_000CD
; @00089 module:0089 original=bfe905
    mov di, 05E9h
; @0008C module:008C original=e83e00
    CALL_NEAR loc_000CD
; @0008F module:008F original=bf0906
    mov di, 0609h
; @00092 module:0092 original=e83800
    CALL_NEAR loc_000CD
; @00095 module:0095 original=bf2906
    mov di, 0629h
; @00098 module:0098 original=e83200
    CALL_NEAR loc_000CD
; @0009B module:009B original=bf4906
    mov di, 0649h
; @0009E module:009E original=e82c00
    CALL_NEAR loc_000CD
; @000A1 module:00A1 original=bf6906
    mov di, 0669h
; @000A4 module:00A4 original=e82600
    CALL_NEAR loc_000CD
; @000A7 module:00A7 original=bf8906
    mov di, 0689h
; @000AA module:00AA original=e82000
    CALL_NEAR loc_000CD
; @000AD module:00AD original=bfa906
    mov di, 06A9h
; @000B0 module:00B0 original=e81a00
    CALL_NEAR loc_000CD
; @000B3 module:00B3 original=803e0d0000
    cmp byte ptr ds:[0Dh], 0
; @000B8 module:00B8 original=7506
    JNE_SHORT loc_000C0
; @000BA module:00BA original=a00c00
    mov al, byte ptr ds:[0Ch]
; @000BD module:00BD original=a20d00
    mov byte ptr ds:[0Dh], al
; @000C0 module:00C0 original=c606620000
    mov byte ptr ds:[062h], 0
; @000C5 module:00C5 original=1f
    pop ds
; @000C6 module:00C6 original=5e
    pop si
; @000C7 module:00C7 original=5f
    pop di
; @000C8 module:00C8 original=5a
    pop dx
; @000C9 module:00C9 original=59
    pop cx
; @000CA module:00CA original=5b
    pop bx
; @000CB module:00CB original=58
    pop ax
; @000CC module:00CC original=c3
    ret
; @000CD module:00CD original=803e5f0000
    cmp byte ptr ds:[05Fh], 0
; @000D2 module:00D2 original=7522
    JNE_SHORT loc_000F6
; @000D4 module:00D4 original=8a4510
    mov al, byte ptr ds:[di + 010h]
; @000D7 module:00D7 original=0ac0
    or al, al
; @000D9 module:00D9 original=741b
    JE_SHORT loc_000F6
; @000DB module:00DB original=8b5d0c
    mov bx, word ptr ds:[di + 0Ch]
; @000DE module:00DE original=803e0d0000
    cmp byte ptr ds:[0Dh], 0
; @000E3 module:00E3 original=750b
    JNE_SHORT loc_000F0
; @000E5 module:00E5 original=fe4d01
    dec byte ptr ds:[di + 1]
; @000E8 module:00E8 original=740d
    JE_SHORT loc_000F7
; @000EA module:00EA original=e85701
    CALL_NEAR StepIndex13AndWriteA0B0_00244
; @000ED module:00ED original=e8ba01
    CALL_NEAR loc_002AA
; @000F0 module:00F0 original=e8d601
    CALL_NEAR loc_002C9
; @000F3 module:00F3 original=e80002
    CALL_NEAR loc_002F6
; @000F6 module:00F6 original=c3
    ret
; @000F7 module:00F7 original=8a07
    mov al, byte ptr ds:[bx]
; @000F9 module:00F9 original=43
    inc bx
; @000FA module:00FA original=0ac0
    or al, al
; @000FC module:00FC original=781d
    JS_SHORT loc_0011B
; @000FE module:00FE original=8805
    mov byte ptr ds:[di], al
; @00100 module:0100 original=8b4508
    mov ax, word ptr ds:[di + 8]
; @00103 module:0103 original=e85104
    CALL_NEAR WriteOpl2Register_00557
; @00106 module:0106 original=e84601
    CALL_NEAR WriteRecordA0B0Pair_0024F
; @00109 module:0109 original=895d0c
    mov word ptr ds:[di + 0Ch], bx
; @0010C module:010C original=8a4511
    mov al, byte ptr ds:[di + 011h]
; @0010F module:010F original=884501
    mov byte ptr ds:[di + 1], al
; @00112 module:0112 original=c3
    ret
; @00113 module:0113 original=8b4508
    mov ax, word ptr ds:[di + 8]
; @00116 module:0116 original=e83e04
    CALL_NEAR WriteOpl2Register_00557
; @00119 module:0119 original=ebee
    JMP_SHORT loc_00109
; @0011B module:011B original=3ce0
    cmp al, 0E0h
; @0011D module:011D original=7316
    JAE_SHORT loc_00135
; @0011F module:011F original=3ca0
    cmp al, 0A0h
; @00121 module:0121 original=735e
    JAE_SHORT loc_00181
; @00123 module:0123 original=3c8d
    cmp al, 08Dh
; @00125 module:0125 original=7e03
    JLE_SHORT loc_0012A
; @00127 module:0127 original=e96701
    JMP_NEAR loc_00291
; @0012A module:012A original=d0e0
    shl al, 1
; @0012C module:012C original=32e4
    xor ah, ah
; @0012E module:012E original=be5503
    mov si, 0355h
; @00131 module:0131 original=03f0
    add si, ax
; @00133 module:0133 original=ff24
    jmp word ptr ds:[si]
; @00135 module:0135 original=2cdf
    sub al, 0DFh
; @00137 module:0137 original=884511
    mov byte ptr ds:[di + 011h], al
; @0013A module:013A original=ebbb
    JMP_SHORT loc_000F7
; @0013C module:013C original=8a07
    mov al, byte ptr ds:[bx]
; @0013E module:013E original=43
    inc bx
; @0013F module:013F original=88450e
    mov byte ptr ds:[di + 0Eh], al
; @00142 module:0142 original=53
    push bx
; @00143 module:0143 original=56
    push si
; @00144 module:0144 original=8b7502
    mov si, word ptr ds:[di + 2]
; @00147 module:0147 original=8ad8
    mov bl, al
; @00149 module:0149 original=32ff
    xor bh, bh
; @0014B module:014B original=80e37f
    and bl, 07Fh
; @0014E module:014E original=8aa7c906
    mov ah, byte ptr ds:[bx + 06C9h]
; @00152 module:0152 original=8a440c
    mov al, byte ptr ds:[si + 0Ch]
; @00155 module:0155 original=d0e0
    shl al, 1
; @00157 module:0157 original=d0e0
    shl al, 1
; @00159 module:0159 original=24c0
    and al, 0C0h
; @0015B module:015B original=0ae0
    or ah, al
; @0015D module:015D original=8a4506
    mov al, byte ptr ds:[di + 6]
; @00160 module:0160 original=0440
    add al, 040h
; @00162 module:0162 original=e8f203
    CALL_NEAR WriteOpl2Register_00557
; @00165 module:0165 original=5e
    pop si
; @00166 module:0166 original=5b
    pop bx
; @00167 module:0167 original=eb8e
    JMP_SHORT loc_000F7
; @00169 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Ah,044h,0Ch,0D0h,0E0h,0D0h,0E0h,024h,0C0h,0Ah,0E0h,08Ah,045h,05h,04h,040h
; @00179 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,0DBh,03h,05Eh,05Bh,0E9h,076h,0FFh
; @00181 module:0181 original=2ca0
    sub al, 0A0h
; @00183 module:0183 original=3a4504
    cmp al, byte ptr ds:[di + 4]
; @00186 module:0186 original=7503
    JNE_SHORT loc_0018B
; @00188 module:0188 original=e96cff
    JMP_NEAR loc_000F7
; @0018B module:018B original=53
    push bx
; @0018C module:018C original=884504
    mov byte ptr ds:[di + 4], al
; @0018F module:018F original=32e4
    xor ah, ah
; @00191 module:0191 original=d0e0
    shl al, 1
; @00193 module:0193 original=d0e0
    shl al, 1
; @00195 module:0195 original=d1e0
    shl ax, 1
; @00197 module:0197 original=d1e0
    shl ax, 1
; @00199 module:0199 original=be6908
    mov si, 0869h
; @0019C module:019C original=03f0
    add si, ax
; @0019E module:019E original=897502
    mov word ptr ds:[di + 2], si
; @001A1 module:01A1 original=8b5505
    mov dx, word ptr ds:[di + 5]
; @001A4 module:01A4 original=8a24
    mov ah, byte ptr ds:[si]
; @001A6 module:01A6 original=8ac2
    mov al, dl
; @001A8 module:01A8 original=0460
    add al, 060h
; @001AA module:01AA original=e8aa03
    CALL_NEAR WriteOpl2Register_00557
; @001AD module:01AD original=8a6401
    mov ah, byte ptr ds:[si + 1]
; @001B0 module:01B0 original=8ac6
    mov al, dh
; @001B2 module:01B2 original=0460
    add al, 060h
; @001B4 module:01B4 original=e8a003
    CALL_NEAR WriteOpl2Register_00557
; @001B7 module:01B7 original=8a6402
    mov ah, byte ptr ds:[si + 2]
; @001BA module:01BA original=8ac2
    mov al, dl
; @001BC module:01BC original=0480
    add al, 080h
; @001BE module:01BE original=e89603
    CALL_NEAR WriteOpl2Register_00557
; @001C1 module:01C1 original=8a6403
    mov ah, byte ptr ds:[si + 3]
; @001C4 module:01C4 original=8ac6
    mov al, dh
; @001C6 module:01C6 original=0480
    add al, 080h
; @001C8 module:01C8 original=e88c03
    CALL_NEAR WriteOpl2Register_00557
; @001CB module:01CB original=8a6406
    mov ah, byte ptr ds:[si + 6]
; @001CE module:01CE original=8ac2
    mov al, dl
; @001D0 module:01D0 original=04e0
    add al, 0E0h
; @001D2 module:01D2 original=e88203
    CALL_NEAR WriteOpl2Register_00557
; @001D5 module:01D5 original=8a6407
    mov ah, byte ptr ds:[si + 7]
; @001D8 module:01D8 original=8ac6
    mov al, dh
; @001DA module:01DA original=04e0
    add al, 0E0h
; @001DC module:01DC original=e87803
    CALL_NEAR WriteOpl2Register_00557
; @001DF module:01DF original=8a6409
    mov ah, byte ptr ds:[si + 9]
; @001E2 module:01E2 original=8a4507
    mov al, byte ptr ds:[di + 7]
; @001E5 module:01E5 original=04c0
    add al, 0C0h
; @001E7 module:01E7 original=e86d03
    CALL_NEAR WriteOpl2Register_00557
; @001EA module:01EA original=8a6404
    mov ah, byte ptr ds:[si + 4]
; @001ED module:01ED original=8ac2
    mov al, dl
; @001EF module:01EF original=0420
    add al, 020h
; @001F1 module:01F1 original=e86303
    CALL_NEAR WriteOpl2Register_00557
; @001F4 module:01F4 original=8a6405
    mov ah, byte ptr ds:[si + 5]
; @001F7 module:01F7 original=8ac6
    mov al, dh
; @001F9 module:01F9 original=0420
    add al, 020h
; @001FB module:01FB original=e85903
    CALL_NEAR WriteOpl2Register_00557
; @001FE module:01FE original=8a5c0a
    mov bl, byte ptr ds:[si + 0Ah]
; @00201 module:0201 original=83e37f
    and bx, 07Fh
; @00204 module:0204 original=8aa7c906
    mov ah, byte ptr ds:[bx + 06C9h]
; @00208 module:0208 original=8a440c
    mov al, byte ptr ds:[si + 0Ch]
; @0020B module:020B original=d0e0
    shl al, 1
; @0020D module:020D original=d0e0
    shl al, 1
; @0020F module:020F original=24c0
    and al, 0C0h
; @00211 module:0211 original=0ae0
    or ah, al
; @00213 module:0213 original=8ac2
    mov al, dl
; @00215 module:0215 original=0440
    add al, 040h
; @00217 module:0217 original=e83d03
    CALL_NEAR WriteOpl2Register_00557
; @0021A module:021A original=8a5c0b
    mov bl, byte ptr ds:[si + 0Bh]
; @0021D module:021D original=885d0e
    mov byte ptr ds:[di + 0Eh], bl
; @00220 module:0220 original=83e37f
    and bx, 07Fh
; @00223 module:0223 original=8aa7c906
    mov ah, byte ptr ds:[bx + 06C9h]
; @00227 module:0227 original=8a440c
    mov al, byte ptr ds:[si + 0Ch]
; @0022A module:022A original=d0c8
    ror al, 1
; @0022C module:022C original=d0c8
    ror al, 1
; @0022E module:022E original=24c0
    and al, 0C0h
; @00230 module:0230 original=0ae0
    or ah, al
; @00232 module:0232 original=8ac6
    mov al, dh
; @00234 module:0234 original=0440
    add al, 040h
; @00236 module:0236 original=e81e03
    CALL_NEAR WriteOpl2Register_00557
; @00239 module:0239 original=8a4408
    mov al, byte ptr ds:[si + 8]
; @0023C module:023C original=884512
    mov byte ptr ds:[di + 012h], al
; @0023F module:023F original=5b
    pop bx
; @00240 module:0240 original=e9b4fe
    JMP_NEAR loc_000F7
; @00243 module:0243 original=c3
    ret
; StepIndex13AndWriteA0B0 (modern reconstruction name)
; Load AL=byte DS:[DI+13h]. If zero, branch backward to shared RET0243, leaving AH unchanged and no
; writes/ports. Otherwise add byte[DI] modulo256, store it at[DI], and fall through into WriteRecordA0B0Pair.
; Inherits its outputs and hardware effects; must not insert an independent RET at024F.
; Evidence: metadata/drivers/symbols.json
; @00244 module:0244 original=8a4513
    mov al, byte ptr ds:[di + 013h]
; @00247 module:0247 original=0ac0
    or al, al
; @00249 module:0249 original=74f8
    JE_SHORT loc_00243
; @0024B module:024B original=0205
    add al, byte ptr ds:[di]
; @0024D module:024D original=8805
    mov byte ptr ds:[di], al
; WriteRecordA0B0Pair (modern reconstruction name)
; DS=driver,DI=record,DF=0. i=(byte[DI]+byte[DI+12h]) mod256; w=(word DS:[07A9+((2*i) mod256)]+word[DI+1Ah])
; mod65536; h=high(w) OR byte DS:[0749+i]. Store w at+14h. Write (byte[DI+7] OR A0h,low(w)), then cache word
; (h<<8)|(byte[DI+7] OR B0h) at+8 and write its high byte OR20h to the B0-derived register. Copy+1Dh to+1Eh and
; return that byte in AL; AH=h OR20h. BX,SI,CX,DX,DI,BP and segments preserved, flags changed; inherits hardware
; effects. No index/channel/range validation.
; Evidence: metadata/drivers/symbols.json
; @0024F module:024F original=53
    push bx
; @00250 module:0250 original=56
    push si
; @00251 module:0251 original=8a05
    mov al, byte ptr ds:[di]
; @00253 module:0253 original=024512
    add al, byte ptr ds:[di + 012h]
; @00256 module:0256 original=32e4
    xor ah, ah
; @00258 module:0258 original=8bf0
    mov si, ax
; @0025A module:025A original=8a9c4907
    mov bl, byte ptr ds:[si + 0749h]
; @0025E module:025E original=d0e0
    shl al, 1
; @00260 module:0260 original=bea907
    mov si, 07A9h
; @00263 module:0263 original=03f0
    add si, ax
; @00265 module:0265 original=ad
    lodsw
; @00266 module:0266 original=03451a
    add ax, word ptr ds:[di + 01Ah]
; @00269 module:0269 original=894514
    mov word ptr ds:[di + 014h], ax
; @0026C module:026C original=0ae3
    or ah, bl
; @0026E module:026E original=50
    push ax
; @0026F module:026F original=8ae0
    mov ah, al
; @00271 module:0271 original=8a4507
    mov al, byte ptr ds:[di + 7]
; @00274 module:0274 original=0ca0
    or al, 0A0h
; @00276 module:0276 original=e8de02
    CALL_NEAR WriteOpl2Register_00557
; @00279 module:0279 original=58
    pop ax
; @0027A module:027A original=8a4507
    mov al, byte ptr ds:[di + 7]
; @0027D module:027D original=0cb0
    or al, 0B0h
; @0027F module:027F original=894508
    mov word ptr ds:[di + 8], ax
; @00282 module:0282 original=80cc20
    or ah, 020h
; @00285 module:0285 original=e8cf02
    CALL_NEAR WriteOpl2Register_00557
; @00288 module:0288 original=8a451d
    mov al, byte ptr ds:[di + 01Dh]
; @0028B module:028B original=88451e
    mov byte ptr ds:[di + 01Eh], al
; @0028E module:028E original=5e
    pop si
; @0028F module:028F original=5b
    pop bx
; @00290 module:0290 original=c3
    ret
; @00291 module:0291 original=bfa905
    mov di, 05A9h
; @00294 module:0294 original=b90900
    mov cx, 9
; @00297 module:0297 original=8b4508
    mov ax, word ptr ds:[di + 8]
; @0029A module:029A original=e8ba02
    CALL_NEAR WriteOpl2Register_00557
; @0029D module:029D original=886d10
    mov byte ptr ds:[di + 010h], ch
; @002A0 module:02A0 original=83c720
    add di, 020h
; @002A3 module:02A3 original=e2f2
    LOOP_SHORT loc_00297
; @002A5 module:02A5 original=890e0800
    mov word ptr ds:[8], cx
; @002A9 module:02A9 original=c3
    ret
; @002AA module:02AA original=803f82
    cmp byte ptr ds:[bx], 082h
; @002AD module:02AD original=7419
    JE_SHORT loc_002C8
; @002AF module:02AF original=8b7502
    mov si, word ptr ds:[di + 2]
; @002B2 module:02B2 original=8a440e
    mov al, byte ptr ds:[si + 0Eh]
; @002B5 module:02B5 original=0ac0
    or al, al
; @002B7 module:02B7 original=740f
    JE_SHORT loc_002C8
; @002B9 module:02B9 original=3a4501
    cmp al, byte ptr ds:[di + 1]
; @002BC module:02BC original=750a
    JNE_SHORT loc_002C8
; @002BE module:02BE original=8b4508
    mov ax, word ptr ds:[di + 8]
; @002C1 module:02C1 original=e89302
    CALL_NEAR WriteOpl2Register_00557
; @002C4 module:02C4 original=c6451300
    mov byte ptr ds:[di + 013h], 0
; @002C8 module:02C8 original=c3
    ret
; @002C9 module:02C9 original=32c0
    xor al, al
; @002CB module:02CB original=3a451d
    cmp al, byte ptr ds:[di + 01Dh]
; @002CE module:02CE original=7432
    JE_SHORT loc_00302
; @002D0 module:02D0 original=3a451e
    cmp al, byte ptr ds:[di + 01Eh]
; @002D3 module:02D3 original=742d
    JE_SHORT loc_00302
; @002D5 module:02D5 original=fe4d1e
    dec byte ptr ds:[di + 01Eh]
; @002D8 module:02D8 original=7428
    JE_SHORT loc_00302
; @002DA module:02DA original=51
    push cx
; @002DB module:02DB original=8b4d08
    mov cx, word ptr ds:[di + 8]
; @002DE module:02DE original=80e51c
    and ch, 01Ch
; @002E1 module:02E1 original=8b4514
    mov ax, word ptr ds:[di + 014h]
; @002E4 module:02E4 original=03451c
    add ax, word ptr ds:[di + 01Ch]
; @002E7 module:02E7 original=80e403
    and ah, 3
; @002EA module:02EA original=3dec03
    cmp ax, 03ECh
; @002ED module:02ED original=7f3d
    JG_SHORT loc_0032C
; @002EF module:02EF original=3df601
    cmp ax, 01F6h
; @002F2 module:02F2 original=7e31
    JLE_SHORT loc_00325
; @002F4 module:02F4 original=eb3b
    JMP_SHORT loc_00331
; @002F6 module:02F6 original=32c0
    xor al, al
; @002F8 module:02F8 original=3a4518
    cmp al, byte ptr ds:[di + 018h]
; @002FB module:02FB original=7406
    JE_SHORT loc_00303
; @002FD module:02FD original=fe4d18
    dec byte ptr ds:[di + 018h]
; @00300 module:0300 original=7401
    JE_SHORT loc_00303
; @00302 module:0302 original=c3
    ret
; @00303 module:0303 original=3a4519
    cmp al, byte ptr ds:[di + 019h]
; @00306 module:0306 original=74fa
    JE_SHORT loc_00302
; @00308 module:0308 original=fe4d19
    dec byte ptr ds:[di + 019h]
; @0030B module:030B original=51
    push cx
; @0030C module:030C original=8b4d08
    mov cx, word ptr ds:[di + 8]
; @0030F module:030F original=80e51c
    and ch, 01Ch
; @00312 module:0312 original=8b4514
    mov ax, word ptr ds:[di + 014h]
; @00315 module:0315 original=034516
    add ax, word ptr ds:[di + 016h]
; @00318 module:0318 original=80e403
    and ah, 3
; @0031B module:031B original=3dec03
    cmp ax, 03ECh
; @0031E module:031E original=7f0c
    JG_SHORT loc_0032C
; @00320 module:0320 original=3df601
    cmp ax, 01F6h
; @00323 module:0323 original=7f0c
    JG_SHORT loc_00331
; @00325 module:0325 original=d1e0
    shl ax, 1
; @00327 module:0327 original=80ed04
    sub ch, 4
; @0032A module:032A original=eb05
    JMP_SHORT loc_00331
; @0032C module:032C original=d1e8
    shr ax, 1
; @0032E module:032E original=80c504
    add ch, 4
; @00331 module:0331 original=80e403
    and ah, 3
; @00334 module:0334 original=894514
    mov word ptr ds:[di + 014h], ax
; @00337 module:0337 original=50
    push ax
; @00338 module:0338 original=8ae0
    mov ah, al
; @0033A module:033A original=8a4507
    mov al, byte ptr ds:[di + 7]
; @0033D module:033D original=04a0
    add al, 0A0h
; @0033F module:033F original=e81502
    CALL_NEAR WriteOpl2Register_00557
; @00342 module:0342 original=58
    pop ax
; @00343 module:0343 original=0ae5
    or ah, ch
; @00345 module:0345 original=8a4507
    mov al, byte ptr ds:[di + 7]
; @00348 module:0348 original=04b0
    add al, 0B0h
; @0034A module:034A original=894508
    mov word ptr ds:[di + 8], ax
; @0034D module:034D original=80cc20
    or ah, 020h
; @00350 module:0350 original=e80402
    CALL_NEAR WriteOpl2Register_00557
; @00353 module:0353 original=59
    pop cx
; @00354 module:0354 original=c3
    ret
; @00355 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,03h,013h,01h,09h,01h,091h,02h,0A1h,03h,0AAh,03h,0B6h,03h,0BDh,03h
; @00365 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,01h,0CBh,03h,0D6h,03h,0E7h,03h,0FEh,03h,0C4h,03h
; @00371 module:0371 original=8b1f
    mov bx, word ptr ds:[bx]
; @00373 module:0373 original=8b0f
    mov cx, word ptr ds:[bx]
; @00375 module:0375 original=43
    inc bx
; @00376 module:0376 original=43
    inc bx
; @00377 module:0377 original=895d0a
    mov word ptr ds:[di + 0Ah], bx
; @0037A module:037A original=894d0c
    mov word ptr ds:[di + 0Ch], cx
; @0037D module:037D original=8bd9
    mov bx, cx
; @0037F module:037F original=e975fd
    JMP_NEAR loc_000F7
; @00382 module:0382 original=a00800
    mov al, byte ptr ds:[8]
; @00385 module:0385 original=0ac0
    or al, al
; @00387 module:0387 original=7404
    JE_SHORT loc_0038D
; @00389 module:0389 original=a25f00
    mov byte ptr ds:[05Fh], al
; @0038C module:038C original=c3
    ret
; @0038D module:038D original=8b5d0a
    mov bx, word ptr ds:[di + 0Ah]
; @00390 module:0390 original=8b0f
    mov cx, word ptr ds:[bx]
; @00392 module:0392 original=43
    inc bx
; @00393 module:0393 original=43
    inc bx
; @00394 module:0394 original=e3db
    JCXZ_SHORT loc_00371
; @00396 module:0396 original=895d0a
    mov word ptr ds:[di + 0Ah], bx
; @00399 module:0399 original=894d0c
    mov word ptr ds:[di + 0Ch], cx
; @0039C module:039C original=8bd9
    mov bx, cx
; @0039E module:039E original=e956fd
    JMP_NEAR loc_000F7
; @003A1 0000:03A1 original=8a07 runtime CFG evidence
    mov al, byte ptr ds:[bx]
; @003A3 0000:03A3 original=43 runtime CFG evidence
    inc bx
; @003A4 0000:03A4 original=884512 runtime CFG evidence
    mov byte ptr ds:[di + 012h], al
; @003A7 0000:03A7 original=e94dfd runtime CFG evidence
    JMP_NEAR loc_000F7
; @003AA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,045h,08h,0E8h,0A7h,01h,032h,0C0h,088h,045h,010h,0C3h,0C6h,045h,013h,01h
; @003BA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,03Ah,0FDh,0C6h,045h,013h,0FFh,0E9h,033h,0FDh,0C6h,045h,013h,00h,0E9h,02Ch
; @003CA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FDh
; @003CB 0000:03CB original=8b1f runtime CFG evidence
    mov bx, word ptr ds:[bx]
; @003CD 0000:03CD original=a00800 runtime CFG evidence
    mov al, byte ptr ds:[8]
; @003D0 0000:03D0 original=a25f00 runtime CFG evidence
    mov byte ptr ds:[05Fh], al
; @003D3 0000:03D3 original=e921fd runtime CFG evidence
    JMP_NEAR loc_000F7
; @003D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,07h,089h,045h,016h,043h,043h,08Bh,07h,089h,045h,018h,043h,043h,0E9h,010h
; @003E6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FDh,08Bh,07h,089h,045h,01Ah,043h,043h,08Bh,07h,089h,045h,01Ch,043h,043h,08Ah
; @003F6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,088h,045h,01Dh,043h,0E9h,0F9h,0FCh,033h,0C0h,088h,045h,01Dh,089h,045h,01Ah
; @00406 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0EEh,0FCh
; @00409 module:0409 original=32e4
    xor ah, ah
; @0040B module:040B original=3a260900
    cmp ah, byte ptr ds:[9]
; @0040F module:040F original=7506
    JNE_SHORT loc_00417
; @00411 module:0411 original=a00800
    mov al, byte ptr ds:[8]
; @00414 module:0414 original=a25f00
    mov byte ptr ds:[05Fh], al
; @00417 module:0417 original=a05f00
    mov al, byte ptr ds:[05Fh]
; @0041A module:041A original=3ac4
    cmp al, ah
; @0041C module:041C original=7503
    JNE_SHORT loc_00421
; @0041E module:041E original=e98200
    JMP_NEAR loc_004A3
; @00421 module:0421 original=88260800
    mov byte ptr ds:[8], ah
; @00425 module:0425 original=88265f00
    mov byte ptr ds:[05Fh], ah
; @00429 module:0429 original=3c0a
    cmp al, 0Ah
; @0042B module:042B original=7603
    JBE_SHORT loc_00430
; @0042D module:042D original=e961fe
    JMP_NEAR loc_00291
; @00430 module:0430 original=50
    push ax
; @00431 module:0431 original=e87000
    CALL_NEAR WriteOpl2Table04B1_004A4
; @00434 module:0434 original=bfa905
    mov di, 05A9h
; @00437 module:0437 original=b90900
    mov cx, 9
; @0043A module:043A original=8b4508
    mov ax, word ptr ds:[di + 8]
; @0043D module:043D original=e81701
    CALL_NEAR WriteOpl2Register_00557
; @00440 module:0440 original=886d10
    mov byte ptr ds:[di + 010h], ch
; @00443 module:0443 original=83c720
    add di, 020h
; @00446 module:0446 original=e2f2
    LOOP_SHORT loc_0043A
; @00448 module:0448 original=58
    pop ax
; @00449 module:0449 original=a20900
    mov byte ptr ds:[9], al
; @0044C module:044C original=d0e0
    shl al, 1
; @0044E module:044E original=be4709
    mov si, 0947h
; @00451 module:0451 original=03f0
    add si, ax
; @00453 module:0453 original=ad
    lodsw
; @00454 module:0454 original=8bf0
    mov si, ax
; @00456 module:0456 original=ac
    lodsb
; @00457 module:0457 original=a20c00
    mov byte ptr ds:[0Ch], al
; @0045A module:045A original=ac
    lodsb
; @0045B module:045B original=8ac8
    mov cl, al
; @0045D module:045D original=32ed
    xor ch, ch
; @0045F module:045F original=890e6000
    mov word ptr ds:[060h], cx
; @00463 module:0463 original=baff01
    mov dx, 01FFh
; @00466 module:0466 original=88360d00
    mov byte ptr ds:[0Dh], dh
; @0046A module:046A original=bfa905
    mov di, 05A9h
; @0046D module:046D original=ad
    lodsw
; @0046E module:046E original=8bd8
    mov bx, ax
; @00470 module:0470 original=8b07
    mov ax, word ptr ds:[bx]
; @00472 module:0472 original=43
    inc bx
; @00473 module:0473 original=43
    inc bx
; @00474 module:0474 original=895d0a
    mov word ptr ds:[di + 0Ah], bx
; @00477 module:0477 original=89450c
    mov word ptr ds:[di + 0Ch], ax
; @0047A module:047A original=886d13
    mov byte ptr ds:[di + 013h], ch
; @0047D module:047D original=886d19
    mov byte ptr ds:[di + 019h], ch
; @00480 module:0480 original=886d1d
    mov byte ptr ds:[di + 01Dh], ch
; @00483 module:0483 original=886d1a
    mov byte ptr ds:[di + 01Ah], ch
; @00486 module:0486 original=886d1b
    mov byte ptr ds:[di + 01Bh], ch
; @00489 module:0489 original=887501
    mov byte ptr ds:[di + 1], dh
; @0048C module:048C original=887510
    mov byte ptr ds:[di + 010h], dh
; @0048F module:048F original=885504
    mov byte ptr ds:[di + 4], dl
; @00492 module:0492 original=83c720
    add di, 020h
; @00495 module:0495 original=e2d6
    LOOP_SHORT loc_0046D
; @00497 module:0497 original=b8bd00
    mov ax, 0BDh
; @0049A module:049A original=e8ba00
    CALL_NEAR WriteOpl2Register_00557
; @0049D module:049D original=b80800
    mov ax, 8
; @004A0 module:04A0 original=e8b400
    CALL_NEAR WriteOpl2Register_00557
; @004A3 module:04A3 original=c3
    ret
; WriteOpl2Table04B1 (modern reconstruction name)
; DS must address driver; DF=0. Write first word at04B1 unconditionally using AL=index,AH=data; then read words
; and stop on zero before writing it. Original table has27 pairs plus zero terminator. Returns AX=0,SI=04E9;
; other general/segment registers preserved. Flags from OR AX,AX. Inherits PIT/port61 effects from
; WriteOpl2Register.
; Evidence: metadata/drivers/symbols.json
; @004A4 module:04A4 original=beb104
    mov si, Opl2Table04B1
; @004A7 module:04A7 original=ad
    lodsw
; @004A8 module:04A8 original=e8ac00
    CALL_NEAR WriteOpl2Register_00557
; @004AB module:04AB original=ad
    lodsw
; @004AC module:04AC original=0bc0
    or ax, ax
; @004AE module:04AE original=75f8
    JNE_SHORT loc_004A8
; @004B0 module:04B0 original=c3
    ret
; Reviewed register/data pairs, not reconstructed instructions.
; Exact original5Dh andB9h entries intentionally preserved; purpose not inferred.
; @004B1 OPL2 register 40h, value 7Fh
    dw 07F40h
; @004B3 OPL2 register 41h, value 7Fh
    dw 07F41h
; @004B5 OPL2 register 42h, value 7Fh
    dw 07F42h
; @004B7 OPL2 register 43h, value 7Fh
    dw 07F43h
; @004B9 OPL2 register 44h, value 7Fh
    dw 07F44h
; @004BB OPL2 register 45h, value 7Fh
    dw 07F45h
; @004BD OPL2 register 48h, value 7Fh
    dw 07F48h
; @004BF OPL2 register 49h, value 7Fh
    dw 07F49h
; @004C1 OPL2 register 4Ah, value 7Fh
    dw 07F4Ah
; @004C3 OPL2 register 4Bh, value 7Fh
    dw 07F4Bh
; @004C5 OPL2 register 4Ch, value 7Fh
    dw 07F4Ch
; @004C7 OPL2 register 5Dh, value 7Fh
    dw 07F5Dh
; @004C9 OPL2 register 50h, value 7Fh
    dw 07F50h
; @004CB OPL2 register 51h, value 7Fh
    dw 07F51h
; @004CD OPL2 register 52h, value 7Fh
    dw 07F52h
; @004CF OPL2 register 53h, value 7Fh
    dw 07F53h
; @004D1 OPL2 register 54h, value 7Fh
    dw 07F54h
; @004D3 OPL2 register 55h, value 7Fh
    dw 07F55h
; @004D5 OPL2 register B0h, value 00h
    dw 000B0h
; @004D7 OPL2 register B1h, value 00h
    dw 000B1h
; @004D9 OPL2 register B2h, value 00h
    dw 000B2h
; @004DB OPL2 register B3h, value 00h
    dw 000B3h
; @004DD OPL2 register B4h, value 00h
    dw 000B4h
; @004DF OPL2 register B6h, value 00h
    dw 000B6h
; @004E1 OPL2 register B7h, value 00h
    dw 000B7h
; @004E3 OPL2 register B8h, value 00h
    dw 000B8h
; @004E5 OPL2 register B9h, value 00h
    dw 000B9h
; @004E7 zero terminator (checked after first pair)
    dw 00000h
; @004E9 module:04E9 original=53
    push bx
; @004EA module:04EA original=51
    push cx
; @004EB module:04EB original=52
    push dx
; @004EC module:04EC original=1e
    push ds
; @004ED module:04ED original=0e
    push cs
; @004EE module:04EE original=1f
    pop ds
; @004EF module:04EF original=8b160e00
    mov dx, word ptr ds:[Opl2BasePortWord]
; @004F3 module:04F3 original=b80100
    mov ax, 1
; @004F6 module:04F6 original=e85e00
    CALL_NEAR WriteOpl2Register_00557
; @004F9 module:04F9 original=b80460
    mov ax, 06004h
; @004FC module:04FC original=e85800
    CALL_NEAR WriteOpl2Register_00557
; @004FF module:04FF original=b90010
    mov cx, 01000h
; @00502 module:0502 original=e2fe
    LOOP_SHORT loc_00502
; @00504 module:0504 original=b80480
    mov ax, 08004h
; @00507 module:0507 original=e84d00
    CALL_NEAR WriteOpl2Register_00557
; @0050A module:050A original=b90010
    mov cx, 01000h
; @0050D module:050D original=e2fe
    LOOP_SHORT loc_0050D
; @0050F module:050F original=ec
    in al, dx
; @00510 module:0510 original=50
    push ax
; @00511 module:0511 original=b802ff
    mov ax, 0FF02h
; @00514 module:0514 original=e84000
    CALL_NEAR WriteOpl2Register_00557
; @00517 module:0517 original=b80421
    mov ax, 02104h
; @0051A module:051A original=e83a00
    CALL_NEAR WriteOpl2Register_00557
; @0051D module:051D original=b9ffff
    mov cx, 0FFFFh
; @00520 module:0520 original=e2fe
    LOOP_SHORT loc_00520
; @00522 module:0522 original=ec
    in al, dx
; @00523 module:0523 original=50
    push ax
; @00524 module:0524 original=b80460
    mov ax, 06004h
; @00527 module:0527 original=e82d00
    CALL_NEAR WriteOpl2Register_00557
; @0052A module:052A original=b80480
    mov ax, 08004h
; @0052D module:052D original=e82700
    CALL_NEAR WriteOpl2Register_00557
; @00530 module:0530 original=58
    pop ax
; @00531 module:0531 original=5b
    pop bx
; @00532 module:0532 original=24e0
    and al, 0E0h
; @00534 module:0534 original=80e3e0
    and bl, 0E0h
; @00537 module:0537 original=7517
    JNE_SHORT loc_00550
; @00539 module:0539 original=3cc0
    cmp al, 0C0h
; @0053B module:053B original=7513
    JNE_SHORT loc_00550
; @0053D module:053D original=b80120
    mov ax, 02001h
; @00540 module:0540 original=e81400
    CALL_NEAR WriteOpl2Register_00557
; @00543 module:0543 original=b80421
    mov ax, 02104h
; @00546 module:0546 original=e80e00
    CALL_NEAR WriteOpl2Register_00557
; @00549 module:0549 original=b001
    mov al, 1
; @0054B module:054B original=1f
    pop ds
; @0054C module:054C original=5a
    pop dx
; @0054D module:054D original=59
    pop cx
; @0054E module:054E original=5b
    pop bx
; @0054F module:054F original=c3
    ret
; @00550 module:0550 original=32c0
    xor al, al
; @00552 module:0552 original=1f
    pop ds
; @00553 module:0553 original=5a
    pop dx
; @00554 module:0554 original=59
    pop cx
; @00555 module:0555 original=5b
    pop bx
; @00556 module:0556 original=c3
    ret
; WriteOpl2Register (modern reconstruction name)
; AL register index, AH data, DS points to driver header. OUT base=DS:[000E],AL; call
; DelayViaPit2Counter(BX=1FFC); AL=AH; OUT base+1,AL; delay(BX=1FEC). Preserves BX/DX and other general/segment
; registers except AL, which returns equal to AH. FLAGS changed. Inherits PIT/port61 side effects and
; hardware-dependent termination.
; Evidence: metadata/drivers/symbols.json; tests/test_tandy_adlib.py
; @00557 module:0557 original=53
    push bx
; @00558 module:0558 original=52
    push dx
; @00559 module:0559 original=8b160e00
    mov dx, word ptr ds:[Opl2BasePortWord]
; @0055D module:055D original=ee
    out dx, al
; @0055E module:055E original=bbfc1f
    mov bx, 01FFCh
; @00561 module:0561 original=e81500
    CALL_NEAR DelayViaPit2Counter_00579
; @00564 module:0564 original=8ac4
    mov al, ah
; @00566 module:0566 original=42
    inc dx
; @00567 module:0567 original=ee
    out dx, al
; @00568 module:0568 original=bbec1f
    mov bx, 01FECh
; @0056B module:056B original=e80b00
    CALL_NEAR DelayViaPit2Counter_00579
; @0056E module:056E original=5a
    pop dx
; @0056F module:056F original=5b
    pop bx
; @00570 module:0570 original=c3
    ret
; ReadOpl2Status: AL <- IN(DS:[000E]); preserves AH, DX and FLAGS.
; See metadata/drivers/symbols.json and tests/test_runtime.py.
; @00571 module:0571 original=52
    push dx
; @00572 module:0572 original=8b160e00
    mov dx, word ptr ds:[Opl2BasePortWord]
; @00576 module:0576 original=ec
    in al, dx
; @00577 module:0577 original=5a
    pop dx
; @00578 module:0578 original=c3
    ret
; DelayViaPit2Counter (modern reconstruction name)
; Preserve AX and all general/segment registers. BX is a signed comparison threshold; configure port43=B6, set
; port61 bits0/1, repeatedly write1FFFh to port42, issue43=86 thenB6, read two bytes from42 and repeat while
; signed AX>BX. Finally read61 and clear bit0. Changes flags; does not restore PIT configuration or original
; port61 state. Termination depends on hardware responses; no exact-duration claim.
; Evidence: metadata/drivers/symbols.json; tests/test_tandy_adlib.py
; @00579 module:0579 original=50
    push ax
; @0057A module:057A original=b0b6
    mov al, 0B6h
; @0057C module:057C original=e643
    out 043h, al
; @0057E module:057E original=e461
    in al, 061h
; @00580 module:0580 original=0c03
    or al, 3
; @00582 module:0582 original=e661
    out 061h, al
; @00584 module:0584 original=b8ff1f
    mov ax, 01FFFh
; @00587 module:0587 original=e642
    out 042h, al
; @00589 module:0589 original=8ac4
    mov al, ah
; @0058B module:058B original=e642
    out 042h, al
; @0058D module:058D original=b086
    mov al, 086h
; @0058F module:058F original=e643
    out 043h, al
; @00591 module:0591 original=b0b6
    mov al, 0B6h
; @00593 module:0593 original=e643
    out 043h, al
; @00595 module:0595 original=e442
    in al, 042h
; @00597 module:0597 original=8ae0
    mov ah, al
; @00599 module:0599 original=e442
    in al, 042h
; @0059B module:059B original=86e0
    xchg ah, al
; @0059D module:059D original=3bc3
    cmp ax, bx
; @0059F module:059F original=7fe6
    JG_SHORT loc_00587
; @005A1 module:05A1 original=e461
    in al, 061h
; @005A3 module:05A3 original=24fe
    and al, 0FEh
; @005A5 module:05A5 original=e661
    out 061h, al
; @005A7 module:05A7 original=58
    pop ax
; @005A8 module:05A8 original=c3
    ret
; @005A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,03h,00h,0B0h,00h,00h,00h,00h,00h,00h,00h
; @005B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,01h,04h,01h,0B1h,00h,00h,00h,00h,00h,00h,00h
; @005D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @005E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,02h,05h,02h,0B2h,00h,00h,00h,00h,00h,00h,00h
; @005F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00609 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,08h,0Bh,03h,0B3h,00h,00h,00h,00h,00h,00h,00h
; @00619 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00629 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,09h,0Ch,04h,0B4h,00h,00h,00h,00h,00h,00h,00h
; @00639 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00649 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,0Ah,0Dh,05h,0B5h,00h,00h,00h,00h,00h,00h,00h
; @00659 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00669 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,010h,013h,06h,0B6h,00h,00h,00h,00h,00h,00h,00h
; @00679 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00689 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,011h,014h,07h,0B7h,00h,00h,00h,00h,00h,00h,00h
; @00699 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @006A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,012h,015h,08h,0B8h,00h,00h,00h,00h,00h,00h,00h
; @006B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @006C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Fh,03Fh,03Eh,03Eh,03Dh,03Dh,03Ch,03Ch,03Bh,03Bh,03Ah,03Ah,039h,039h,038h,038h
; @006D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,037h,036h,036h,035h,035h,034h,034h,033h,033h,032h,032h,031h,031h,030h,030h
; @006E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Fh,02Eh,02Eh,02Dh,02Dh,02Ch,02Ch,02Bh,02Bh,02Ah,02Ah,029h,029h,028h,028h
; @006F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 027h,027h,026h,026h,025h,025h,024h,024h,023h,023h,022h,022h,021h,021h,020h,020h
; @00709 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Fh,01Fh,01Eh,01Eh,01Dh,01Dh,01Ch,01Ch,01Bh,01Bh,01Ah,01Ah,019h,019h,018h,018h
; @00719 UNKNOWN module bytes; code/data distinction not yet proven
    db 017h,017h,016h,016h,015h,015h,014h,014h,013h,013h,012h,012h,011h,011h,010h,010h
; @00729 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,0Fh,0Eh,0Eh,0Dh,0Dh,0Ch,0Ch,0Bh,0Bh,0Ah,0Ah,09h,09h,08h,08h
; @00739 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,07h,06h,06h,05h,05h,04h,04h,03h,03h,02h,02h,01h,01h,00h,00h
; @00749 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00759 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,08h
; @00769 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Ch,0Ch,0Ch,0Ch,0Ch
; @00779 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,010h,010h,010h,010h,010h,010h,010h,010h,010h
; @00789 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,010h,010h,014h,014h,014h,014h,014h,014h,014h,014h,014h,014h,014h,014h,018h
; @00799 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,018h,018h,018h,018h,018h,018h,018h,018h,018h,018h,01Ch,01Ch,01Ch,01Ch,01Ch
; @007A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 059h,01h,06Dh,01h,083h,01h,09Ah,01h,0B2h,01h,0CCh,01h,0E7h,01h,05h,02h
; @007B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
; @007C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
; @007D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B2h,02h,0DBh,02h,06h,03h,034h,03h,065h,03h,099h,03h,0CFh,03h,05h,02h
; @007E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
; @007F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
; @00809 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B2h,02h,0DBh,02h,06h,03h,034h,03h,065h,03h,099h,03h,0CFh,03h,05h,02h
; @00819 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
; @00829 UNKNOWN module bytes; code/data distinction not yet proven
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
; @00839 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B2h,02h,0DBh,02h,06h,03h,034h,03h,065h,03h,099h,03h,0CFh,03h,05h,02h
; @00849 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,02h,044h,02h,067h,02h,08Bh,02h,0B2h,02h,0DBh,02h,06h,03h,034h,03h
; @00859 UNKNOWN module bytes; code/data distinction not yet proven
    db 065h,03h,099h,03h,0CFh,03h,05h,02h,023h,02h,044h,02h,067h,02h,08Bh,02h
; @00869 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,0E9h,07h,08h,00h,00h,01h,00h,0FDh,06h,07Fh,07Ch,00h,00h,00h,00h
; @00879 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,0F6h,06h,07h,00h,06h,02h,00h,0FCh,0Fh,07Fh,07Fh,00h,00h,00h,00h
; @00889 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E4h,0F5h,06h,07h,00h,06h,02h,00h,02h,0Fh,07Fh,07Fh,00h,00h,00h,00h
; @00899 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,0B9h,06h,08h,0Fh,0Fh,02h,02h,030h,0Eh,07Ch,07Fh,00h,00h,00h,00h
; @008A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,0E9h,05h,04h,01h,03h,01h,00h,00h,08h,06Eh,07Eh,00h,00h,00h,00h
; @008B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 093h,052h,0FEh,0FEh,020h,020h,03h,03h,0Ch,0Eh,04Eh,07Eh,00h,00h,00h,00h
; @008C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 093h,0E1h,088h,088h,064h,062h,00h,02h,0E8h,06h,07Fh,07Fh,00h,00h,00h,00h
; @008D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,0F1h,011h,025h,0F1h,022h,00h,00h,0Ch,08h,07Ch,078h,00h,00h,00h,00h
; @008E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 077h,081h,013h,025h,0F1h,022h,00h,00h,0Ch,08h,07Ch,072h,00h,00h,00h,00h
; @008F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C3h,082h,088h,088h,021h,023h,02h,03h,0F4h,02h,07Fh,07Fh,00h,00h,00h,00h
; @00909 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,01h,05h,0Fh,0Fh,02h,02h,024h,0Eh,07Bh,07Fh,00h,00h,00h,00h
; @00919 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A2h,054h,0F8h,0F8h,060h,021h,03h,00h,0Ch,0Ah,068h,07Fh,00h,00h,00h,00h
; @00929 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F5h,0F2h,0FEh,0FEh,020h,020h,03h,03h,018h,0Eh,04Eh,070h,00h,00h,00h,00h
; @00939 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,072h,011h,094h,062h,064h,02h,00h,0E8h,0Ch,064h,07Fh,00h,00h,00h,00h
; @00949 UNKNOWN module bytes; code/data distinction not yet proven
    db 05Dh,09h,00h,0Fh,0Bh,019h,0ECh,023h,0A9h,027h,0D5h,028h,0B9h,02Bh,0D5h,030h
; @00959 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F0h,032h,0Eh,03Ah,05h,09h,071h,09h,083h,09h,095h,09h,0A7h,09h,0BFh,09h
; @00969 UNKNOWN module bytes; code/data distinction not yet proven
    db 0D1h,09h,0E3h,09h,0F5h,09h,07h,0Ah,019h,0Ah,019h,0Ah,019h,0Ah,019h,0Ah
; @00979 UNKNOWN module bytes; code/data distinction not yet proven
    db 019h,0Ah,07Ch,0Ah,0AFh,0Ah,00h,00h,073h,09h,0E2h,0Ah,0E2h,0Ah,0E2h,0Ah
; @00989 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,0Ah,0E2h,0Ah,012h,0Bh,02Bh,0Bh,00h,00h,085h,09h,043h,0Bh,043h,0Bh
; @00999 UNKNOWN module bytes; code/data distinction not yet proven
    db 043h,0Bh,043h,0Bh,043h,0Bh,055h,0Bh,066h,0Bh,00h,00h,097h,09h,077h,0Bh
; @009A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 078h,0Bh,078h,0Bh,078h,0Bh,0AAh,0Bh,077h,0Bh,078h,0Bh,0AAh,0Bh,0Ch,0Ch
; @009B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,0Ch,00h,00h,0ABh,09h,04Eh,0Ch,04Eh,0Ch,059h,0Ch,04Eh,0Ch,059h,0Ch
; @009C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 063h,0Ch,06Ch,0Ch,00h,00h,0C1h,09h,07Dh,0Ch,07Dh,0Ch,088h,0Ch,07Dh,0Ch
; @009D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,0Ch,092h,0Ch,09Bh,0Ch,00h,00h,0D3h,09h,0ACh,0Ch,0ACh,0Ch,0D4h,0Ch
; @009E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0ACh,0Ch,0D4h,0Ch,0B8h,03Fh,0Dh,0Dh,00h,00h,0E5h,09h,0AEh,03Fh,01Eh,0Dh
; @009F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 069h,0Dh,087h,0Dh,069h,0Dh,0F2h,0Dh,06h,0Eh,00h,00h,0F7h,09h,0AEh,03Fh
; @00A09 UNKNOWN module bytes; code/data distinction not yet proven
    db 019h,0Eh,06Ah,0Eh,075h,0Eh,06Ah,0Eh,0E4h,0Eh,0EDh,0Eh,00h,00h,09h,0Ah
; @00A19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h
; @00A29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch
; @00A39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @00A49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h
; @00A59 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch
; @00A69 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh
; @00A79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,080h,0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh
; @00A89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh
; @00A99 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0E3h,0Eh,0E1h,0Eh,0Eh
; @00AA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A0h,0E1h,0Ch,081h,0Ch,0A1h,0E5h,0Eh,0A0h,0E1h
; @00AB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Ch,0A1h,0E5h,0Eh,0A0h,0E1h,0Ch,081h,0Ch,0A1h,0E5h,0Eh,0A0h,0E1h
; @00AC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Ch,0A1h,0E5h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh
; @00AD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F5h,081h,0E1h,0A0h,0Ch,0E5h,0A1h,0Eh,080h,0E5h,081h,0A2h,0Eh,081h,0Eh,081h
; @00AE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @00AF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E3h,0Eh
; @00B09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,081h,0Eh,081h,0Eh,081h,0Eh
; @00B19 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @00B29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,080h,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh
; @00B39 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Eh,081h,0Eh,0F7h,081h,0E5h,0Eh,080h,0A3h,0E5h,012h,012h,012h,012h
; @00B49 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,012h,012h,012h,012h
; @00B59 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,080h,0E5h,012h,012h
; @00B69 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,0F7h,081h,0E5h,012h,012h,012h,012h,080h,0A4h,0E1h
; @00B79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh
; @00B89 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh
; @00B99 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h
; @00BA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0E1h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h
; @00BB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h
; @00BC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h
; @00BD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h
; @00BE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,07h,07h,07h,07h,0Eh,013h
; @00BF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,07h,07h,07h,0Eh,013h,06h,06h,06h,06h,0Eh,012h,06h,06h,06h,06h
; @00C09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,012h,080h,0E1h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h
; @00C19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Dh,0Dh,0Dh,0Dh
; @00C29 UNKNOWN module bytes; code/data distinction not yet proven
    db 014h,019h,0Eh,0Eh,0Eh,0Eh,015h,01Ah,010h,010h,010h,010h,017h,01Ch,012h,012h
; @00C39 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,01Eh,082h,080h,0F7h,081h,081h,0E1h,017h,015h,012h,010h,012h,010h,0E3h
; @00C49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Bh,0FBh,081h,080h,0A5h,0F7h,026h,028h,02Ah,082h,026h,028h,02Ah,082h,080h
; @00C59 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,025h,082h,026h,082h,025h,082h,02Bh,02Ah,080h,0F7h,025h,026h,0EBh,028h,02Ah
; @00C69 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,02Fh,080h,0F7h,081h,081h,0A7h,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h
; @00C79 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,0FBh,081h,080h,0A5h,0F7h,021h,023h,023h,082h,021h,023h,023h,082h,080h,0F7h
; @00C89 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,023h,082h,023h,082h,026h,026h,080h,0F7h,023h,023h,0EBh,025h,026h,028h
; @00C99 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,080h,0F7h,081h,0A6h,081h,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h
; @00CA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FBh,081h,080h,0FDh,081h,0F3h,081h,081h,0A6h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh
; @00CB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Dh,02Fh,032h,02Fh,032h,034h,0FDh,081h,0F3h,081h,081h,0E1h,023h,028h,02Ah
; @00CC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,034h,080h,0E1h,040h,03Eh,03Bh,03Eh
; @00CD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,039h,03Bh,039h,036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh
; @00CE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,02Dh,02Ah,028h,0F7h,026h,082h,0E1h,040h,03Eh,03Bh,03Eh,03Bh,039h,03Bh,039h
; @00CF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh,02Ah,02Dh,02Ah,028h
; @00D09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,02Bh,02Ah,080h,0F7h,081h,081h,0A7h,0E1h,03Bh,039h,036h,034h,036h,034h,0E3h
; @00D19 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,02Fh,0FBh,081h,080h,0A7h,0E1h,039h,036h,032h,034h,02Fh,032h,0A8h,0E7h,036h
; @00D29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Fh,032h,036h,034h,0F3h,039h,0E1h,036h,034h,032h,036h,032h,02Fh,034h,02Fh
; @00D39 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,02Fh,02Ah,028h,0F7h,08Ah,0FCh,0FFh,02Dh,01Fh,032h,0E1h,039h,036h,032h,034h
; @00D49 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,034h,0E7h,032h,0E1h,02Fh,032h,036h,039h,0F3h,034h,0E1h,036h,034h,032h,036h
; @00D59 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F7h,08Ah,0FCh,0FFh,02Dh,01Fh,032h,080h
; @00D69 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A9h,0E8h,021h,023h,0E5h,025h,0E8h,021h,023h,0E5h,025h,0E8h,023h,025h,0FDh,026h
; @00D79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,025h,026h,0E5h,028h,0E8h,025h,026h,0E5h,028h,0F7h,02Bh,02Ah,080h,0A7h,0E1h
; @00D89 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,036h,02Fh,032h,034h,036h,0A8h,0EBh,039h,0E1h,03Bh,039h,036h,0F1h,034h,0E1h
; @00D99 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,02Fh,02Dh,0F7h,08Ah,0FCh,0FFh
; @00DA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,01Fh,032h,0E1h,034h,031h,02Fh,032h,031h,02Dh,034h,031h,02Fh,032h,031h,02Dh
; @00DB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,032h,02Fh,034h,032h,031h,039h,036h,032h,034h,032h,02Fh,08Ah,018h,00h,00h
; @00DC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 05h,02Fh,034h,032h,02Fh,034h,032h,08Ah,018h,00h,00h,05h,02Fh,034h,032h,02Fh
; @00DD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,08Ah,018h,00h,00h,05h,03Bh,039h,032h,02Fh,039h,032h,08Ah,018h,00h
; @00DE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,05h,03Bh,039h,032h,02Fh,039h,032h,080h,0A9h,0E8h,021h,023h,0E5h,025h,0E8h
; @00DF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,025h,0E5h,026h,025h,028h,026h,02Ah,028h,02Dh,02Ah,02Fh,080h,0F8h,081h,081h
; @00E09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A7h,088h,06Ch,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0F9h,081h,080h
; @00E19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A7h,088h,06Ch,0E1h,081h,0E1h,039h,036h,032h,034h,02Fh,032h,0A8h,088h,06Ch,0E7h
; @00E29 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0E1h,02Fh,032h,036h,034h,0F3h,039h,0E1h,036h,034h,032h,036h,032h,02Fh,034h
; @00E39 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Ah,02Fh,02Ah,028h,0F7h,08Ah,0FCh,0FFh,02Dh,01Fh,032h,0E1h,039h,036h,032h
; @00E49 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,036h,034h,0E7h,032h,0E1h,02Fh,032h,036h,039h,0F3h,034h,0E1h,036h,034h,032h
; @00E59 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F5h,08Ah,0FCh,0FFh,02Dh,01Fh,032h
; @00E69 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0A5h,0F7h,021h,082h,01Fh,082h,021h,082h,021h,021h,080h,0A7h,088h,06Ch,0E1h
; @00E79 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,039h,036h,02Fh,032h,034h,036h,0A8h,088h,06Ch,0EBh,039h,0E1h,03Bh,039h,036h
; @00E89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,034h,0E1h,039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,023h,02Dh,0F7h
; @00E99 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Ah,0FCh,0FFh,02Dh,01Fh,032h,0E1h,034h,031h,02Fh,032h,031h,02Dh,034h,031h,02Fh
; @00EA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,031h,02Dh,036h,032h,02Fh,034h,032h,031h,039h,036h,032h,034h,032h,02Fh,08Ah
; @00EB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,00h,00h,05h,02Fh,034h,032h,02Fh,034h,032h,08Ah,018h,00h,00h,05h,02Fh
; @00EC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,02Fh,034h,032h,08Ah,018h,00h,00h,05h,03Bh,034h,032h,02Fh,034h,032h
; @00ED9 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Ah,018h,00h,00h,05h,03Bh,034h,032h,02Fh,034h,080h,0F7h,021h,021h,0EBh,021h
; @00EE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,025h,023h,080h,0F8h,081h,081h,0A7h,088h,06Ch,0E1h,03Bh,039h,036h,034h,036h
; @00EF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0E3h,032h,02Fh,0F9h,081h,080h,06h,09h,014h,0Fh,024h,0Fh,034h,0Fh,048h
; @00F09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,058h,0Fh,064h,0Fh,070h,0Fh,07Ch,0Fh,088h,0Fh,092h,0Fh,08Fh,010h,086h
; @00F19 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,086h,011h,086h,011h,086h,011h,00h,00h,014h,0Fh,0D8h,011h,09Ah,012h,05Bh
; @00F29 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,05Bh,013h,05Bh,013h,05Bh,013h,00h,00h,024h,0Fh,08Dh,013h,08Dh,013h,08Dh
; @00F39 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,08Dh,013h,037h,014h,037h,014h,037h,014h,037h,014h,00h,00h,034h,0Fh,07Ah
; @00F49 UNKNOWN module bytes; code/data distinction not yet proven
    db 014h,027h,015h,0D6h,015h,0D6h,015h,0D6h,015h,0D6h,015h,00h,00h,048h,0Fh,08h
; @00F59 UNKNOWN module bytes; code/data distinction not yet proven
    db 016h,026h,016h,04Bh,016h,04Bh,016h,00h,00h,058h,0Fh,055h,016h,073h,016h,098h
; @00F69 UNKNOWN module bytes; code/data distinction not yet proven
    db 016h,098h,016h,00h,00h,064h,0Fh,0A2h,016h,0C0h,016h,0E5h,016h,0E5h,016h,00h
; @00F79 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,070h,0Fh,0EFh,016h,0Dh,017h,032h,017h,032h,017h,00h,00h,07Ch,0Fh,03Ch
; @00F89 UNKNOWN module bytes; code/data distinction not yet proven
    db 017h,0C6h,017h,064h,018h,00h,00h,088h,0Fh,0E1h,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @00F99 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @00FA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @00FB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @00FC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @00FD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @00FE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @00FF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @01009 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @01019 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @01029 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh
; @01039 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,0E7h,081h,0E1h
; @01049 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01059 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01069 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01079 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,081h,081h,0A1h,0Eh,0Eh
; @01089 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01099 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @010A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @010B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @010C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @010D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @010E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @010F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01109 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01119 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01129 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h
; @01139 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,0E7h,081h,0E1h,0Ch,0A1h,0Eh
; @01149 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h
; @01159 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,0Eh,0A0h,0Ch,0Ch,081h
; @01169 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h,081h,0Eh,0Eh,081h,081h
; @01179 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0A0h,0Ch
; @01189 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh
; @01199 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh
; @011A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h
; @011B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch
; @011C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0Eh,0Eh,080h,0E1h
; @011D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A2h,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
; @011E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
; @011F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h
; @01209 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
; @01219 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
; @01229 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,0Eh
; @01239 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
; @01249 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
; @01259 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,0Eh,081h,081h,0E7h,081h,0E1h,081h,0Eh,0Eh,0Eh,0Eh,0Eh
; @01269 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh
; @01279 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
; @01289 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,081h,081h,081h,081h,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @01299 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0E1h,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
; @012A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh
; @012B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh
; @012C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
; @012D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh
; @012E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh
; @012F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h
; @01309 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh
; @01319 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,0Eh,081h,0Eh,081h,081h,0E7h,081h,0E1h,081h,0Eh,0Eh,0Eh,0Eh
; @01329 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
; @01339 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h
; @01349 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @01359 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,080h,0E1h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h
; @01369 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h
; @01379 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h,0Eh,081h,081h,081h,0Eh,081h
; @01389 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,080h,0E1h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h
; @01399 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h
; @013A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h
; @013B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h
; @013C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h
; @013D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h
; @013E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h
; @013F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh
; @01409 UNKNOWN module bytes; code/data distinction not yet proven
    db 016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,012h,012h
; @01419 UNKNOWN module bytes; code/data distinction not yet proven
    db 0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,0A3h,012h,012h,0AAh,016h,0A3h,012h,0AAh
; @01429 UNKNOWN module bytes; code/data distinction not yet proven
    db 016h,0A3h,012h,012h,012h,0AAh,016h,0A3h,012h,0AAh,016h,0A3h,012h,080h,0E1h,0A3h
; @01439 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
; @01449 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
; @01459 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
; @01469 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,081h,012h,0AAh,016h,0A3h,012h,012h,012h,081h,012h,0AAh,016h,0A3h,012h
; @01479 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0A4h,0E1h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
; @01489 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h
; @01499 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
; @014A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
; @014B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h
; @014C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
; @014D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh
; @014E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E2h,015h,081h,0E1h,09h
; @014F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E5h,015h,0FFh,081h,0E1h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh
; @01509 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,015h,082h
; @01519 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,09h,081h,0E5h,015h,0F5h,081h,0E1h,09h,0Bh,0Ch,0Dh,0Eh,080h,0E1h,0Eh
; @01529 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
; @01539 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
; @01549 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh
; @01559 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
; @01569 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
; @01579 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh
; @01589 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h
; @01599 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E2h,015h,081h,0E1h,09h,081h,0E5h,015h,0FFh
; @015A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E1h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh
; @015B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E5h,015h,0E3h,012h,0E5h,013h
; @015C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,015h,0E5h,017h,0E3h,01Ah,0E5h,01Ch,0E1h,01Eh,0EBh,01Fh,080h,0E1h,07h,013h
; @015D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h
; @015E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,013h,07h,013h,07h,013h,09h,015h,09h,015h,09h,015h,09h,015h,09h,015h
; @015F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,015h,04h,010h,04h,010h,04h,010h,04h,010h,04h,010h,04h,010h,080h,0A5h
; @01609 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,02Dh,082h,02Fh,082h,02Dh,082h,02Fh,082h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh
; @01619 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FFh,081h,0F7h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,080h,0F7h,02Dh,082h
; @01629 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,082h,02Dh,082h,02Fh,082h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,0F7h
; @01639 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0E7h,081h,0E3h,02Bh,0E5h,081h,0E7h,02Bh,0E5h
; @01649 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,080h,0F7h,02Ah,082h,028h,026h,02Ah,082h,028h,026h,080h,0A5h,0F7h,02Ah,082h
; @01659 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,082h,02Ah,082h,02Bh,082h,02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h
; @01669 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,080h,0F7h,02Ah,082h,02Bh,082h,02Ah
; @01679 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,02Bh,082h,02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h,02Ah,082h,0E3h
; @01689 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,0E5h,081h,028h,0E7h,081h,0E3h,028h,0E5h,081h,0E7h,028h,0E5h,081h,080h,0F7h
; @01699 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,082h,024h,023h,026h,082h,024h,023h,080h,0A5h,0F7h,028h,082h,028h,082h,028h
; @016A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,028h,082h,026h,082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h
; @016B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,0E5h,081h,024h,0FFh,081h,080h,0F7h,028h,082h,028h,082h,028h,082h,028h,082h
; @016C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h,024h,0E5h,081h
; @016D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,0E7h,081h,0E3h,024h,0E5h,081h,0E7h,024h,0E5h,081h,080h,0F7h,023h,082h,021h
; @016E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Fh,023h,082h,021h,01Fh,080h,0A5h,0F7h,026h,082h,024h,082h,026h,082h,024h,082h
; @016F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,0E3h,021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h,0E5h,081h
; @01709 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,0FFh,081h,080h,0F7h,026h,082h,024h,082h,026h,082h,024h,082h,023h,082h,0E3h
; @01719 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h,0E5h,081h,021h,0E7h,081h
; @01729 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,021h,0E5h,081h,0E7h,021h,0E5h,081h,080h,0F7h,01Fh,082h,01Dh,01Ch,01Fh,082h
; @01739 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Dh,01Ch,080h,0ABh,0E9h,02Dh,0E1h,02Ah,0E3h,028h,0E5h,02Ah,0F1h,026h,0E1h,028h
; @01749 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,02Ah,0E9h,02Fh,0FBh,02Dh,0E1h,02Fh,02Dh,02Bh,02Ah,02Bh,0EFh,02Dh,0E1h,028h
; @01759 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,02Ah,0F1h,026h,0E1h,028h,0E5h,02Ah,0E9h,02Fh,0F9h,02Dh,0E1h,02Fh,030h,032h
; @01769 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,036h,039h,0A7h,02Ah,02Dh,02Fh,032h,081h,0EBh,034h,0E1h,036h,039h,036h,034h
; @01779 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,034h,032h,034h,032h,02Fh,032h,02Fh,032h,0E5h,032h,0E3h,034h,032h,082h,088h
; @01789 UNKNOWN module bytes; code/data distinction not yet proven
    db 064h,034h,032h,082h,088h,050h,034h,032h,082h,088h,040h,034h,0A0h,0E1h,081h,0A7h
; @01799 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,02Dh,02Fh,032h,081h,0EBh,032h,0E1h,032h,036h,034h,032h,0E3h,034h,0E8h,034h
; @017A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,081h,0E1h,034h,039h,036h,032h,039h,036h,032h,039h,036h,032h,039h,036h,032h
; @017B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,036h,034h,039h,036h,034h,039h,036h,034h,036h,039h,034h,080h,0A7h,0EBh,02Dh
; @017C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,032h,0E1h,02Dh,0E3h,032h,0E7h,02Dh,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h
; @017D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,02Dh,0E5h,032h,0E3h,034h,0E5h,036h,0E1h,037h,0E3h,036h,0F7h,034h,0E1h,036h
; @017E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,037h,0E1h,039h,0E3h,037h,0E5h,036h,034h,0EDh,036h,0E1h,039h,037h,036h,034h
; @017F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,034h,0E5h,032h,0E3h,034h,0E5h,030h,0E1h,032h,0E5h,02Fh,0E3h,030h,0E5h,02Dh
; @01809 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Fh,0E5h,02Bh,0E3h,02Dh,0E1h,02Ah,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h
; @01819 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h
; @01829 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,036h,032h,036h,032h,036h,037h,036h,032h,036h,032h,036h,037h,039h,036h,037h
; @01839 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,036h,03Bh,039h,037h,036h,036h,034h,032h,02Fh,02Dh,0E3h,034h,0EBh,032h,0E1h
; @01849 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,036h,037h,036h,0E3h,034h,0EDh,032h,0E5h,028h,0E3h,02Ah,0E5h,02Bh,0E1h,02Dh
; @01859 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,02Fh,0E3h,032h,0E5h,034h,0E1h,036h,0EBh,037h,080h,0FFh,081h,081h,081h,0E1h
; @01869 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A6h,088h,054h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh
; @01879 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Ch,03Bh,039h,088h,05Ah,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
; @01889 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,088h,060h,03Bh,039h,03Bh,03Ch,03Bh
; @01899 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,088h,066h,03Bh
; @018A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh
; @018B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,088h,06Ch,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh
; @018C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Ch,03Bh,039h,088h,072h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
; @018D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,088h,079h,03Bh,039h,03Bh,03Ch,03Bh
; @018E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,039h,03Bh,039h,03Ch,03Bh,039h,088h,07Eh,03Bh
; @018F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh
; @01909 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,080h,05h,09h,01Fh,019h,03Dh,019h,05Bh,019h,05Dh,019h,07Dh,019h,09Bh,019h
; @01919 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B9h,019h,0D7h,019h,0EFh,019h,07h,01Ah,07h,01Ah,07h,01Ah,06Ah,01Ah,07h,01Ah
; @01929 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,01Ah,07h,01Ah,06Ah,01Ah,0CBh,01Ah,07h,01Ah,07h,01Ah,06Ah,01Ah,06Ah,01Ah
; @01939 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,021h,019h,02Eh,01Bh,02Eh,01Bh,02Eh,01Bh,054h,01Bh,02Eh,01Bh,02Eh,01Bh
; @01949 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Eh,01Bh,054h,01Bh,081h,01Bh,02Eh,01Bh,02Eh,01Bh,054h,01Bh,054h,01Bh,00h,00h
; @01959 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Fh,019h,0A7h,01Bh,0B4h,01Bh,0B4h,01Bh,0B4h,01Bh,01Bh,01Ch,0B4h,01Bh,0B4h,01Bh
; @01969 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B4h,01Bh,01Bh,01Ch,079h,01Ch,07Dh,01Ch,0AEh,01Ch,0AEh,01Ch,010h,01Dh,01Bh,01Ch
; @01979 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,05Fh,019h,072h,01Dh,072h,01Dh,072h,01Dh,084h,01Dh,072h,01Dh,072h,01Dh
; @01989 UNKNOWN module bytes; code/data distinction not yet proven
    db 072h,01Dh,084h,01Dh,0BFh,01Dh,0E7h,01Dh,0E7h,01Dh,08h,01Eh,084h,01Dh,00h,00h
; @01999 UNKNOWN module bytes; code/data distinction not yet proven
    db 07Fh,019h,04Ah,01Eh,04Ah,01Eh,04Ah,01Eh,05Ch,01Eh,04Ah,01Eh,04Ah,01Eh,04Ah,01Eh
; @019A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 05Ch,01Eh,097h,01Eh,0BFh,01Eh,0BFh,01Eh,0E0h,01Eh,05Ch,01Eh,00h,00h,09Dh,019h
; @019B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 022h,01Fh,022h,01Fh,022h,01Fh,034h,01Fh,022h,01Fh,022h,01Fh,022h,01Fh,034h,01Fh
; @019C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 06Fh,01Fh,097h,01Fh,097h,01Fh,0B8h,01Fh,034h,01Fh,00h,00h,0BBh,019h,0FAh,01Fh
; @019D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,020h,0BCh,020h,0FAh,01Fh,0Ch,020h,0BCh,020h,0E7h,020h,0Fh,021h,0BCh,021h
; @019E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0BCh,020h,00h,00h,0D9h,019h,09Eh,022h,0A9h,022h,05Fh,023h,09Eh,022h,0A9h,022h
; @019F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 05Fh,023h,086h,023h,0ECh,021h,0BEh,023h,05Fh,023h,00h,00h,0F1h,019h,0A0h,0E5h
; @01A09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
; @01A19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
; @01A29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h
; @01A39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
; @01A49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
; @01A59 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,0Eh
; @01A69 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch
; @01A79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h
; @01A89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh,081h,0Eh,0Eh,081h
; @01A99 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch
; @01AA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h
; @01AB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh,081h,0Eh,0Eh,0Eh
; @01AC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,080h,0A0h,0E5h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h
; @01AD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
; @01AE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
; @01AF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h
; @01B09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
; @01B19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0A1h,0E5h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
; @01B29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0Eh,0Eh,080h,0E5h,081h,0A2h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
; @01B39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
; @01B49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0E1h,0Eh,081h,0Eh,080h,0E5h,081h,0Eh,081h,0Eh
; @01B59 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,081h,0Eh,0Eh,081h
; @01B69 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
; @01B79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,080h,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h
; @01B89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0A2h,0Eh,081h,0Eh,081h,0Eh
; @01B99 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E1h,0Eh,0Eh,0Eh,080h,0A3h,0E5h
; @01BA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,089h,0A9h,01Bh,0A4h,088h,078h,0E1h,084h
; @01BB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh
; @01BC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh
; @01BD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h
; @01BE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh
; @01BF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh
; @01C09 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h
; @01C19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,080h,0E1h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
; @01C29 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
; @01C39 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h
; @01C49 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,081h,011h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
; @01C59 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,015h,081h,015h,015h,081h
; @01C69 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,0EBh,015h,080h
; @01C79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A4h,0E1h,084h,0Ch,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
; @01C89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
; @01C99 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
; @01CA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,082h,0Eh,080h,0E1h,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
; @01CB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
; @01CC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
; @01CD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h
; @01CE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,013h,082h
; @01CF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h
; @01D09 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,082h,013h,013h,082h,013h,080h,084h,07h,0E1h,011h,081h,011h,011h,081h,011h
; @01D19 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
; @01D29 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
; @01D39 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,013h,081h,013h,013h,081h,013h
; @01D49 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
; @01D59 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h
; @01D69 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,081h,015h,0EBh,015h,084h,0Ch,080h,0A6h,088h,074h,0F7h,032h,082h,035h
; @01D79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,037h,039h,0F7h,032h,082h,035h,0EBh,037h,039h,080h,0EBh,030h,0E1h,030h,081h
; @01D89 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,081h,081h,0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,030h,0E1h,030h,081h
; @01D99 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,081h,081h,0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,032h,0E1h,032h,081h
; @01DA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,081h,081h,0EDh,032h,0E1h,032h,081h,032h,081h,081h,0EDh,034h,0E1h,034h,081h
; @01DB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,081h,081h,0F9h,034h,080h,0A6h,088h,074h,0FFh,02Dh,0E1h,081h,02Dh,081h,081h
; @01DC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,081h,081h,02Dh,0FFh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0FFh
; @01DD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0F7h,02Dh,082h,080h,084h,0E8h
; @01DE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FEh,032h,0E1h,081h,034h,081h,081h,034h,0E3h,081h,0E2h,034h,0F7h,035h,037h,0FEh
; @01DF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0E1h,081h,034h,081h,081h,034h,0E3h,081h,0E2h,034h,0F7h,037h,082h,080h,0A6h
; @01E09 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,074h,084h,0EFh,0EBh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
; @01E19 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
; @01E29 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,024h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,026h,0E1h,026h
; @01E39 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,026h,081h,081h,0EDh,028h,0E1h,028h,081h,028h,081h,081h,0F9h,028h,084h,0E8h
; @01E49 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0A6h,088h,074h,0F7h,02Dh,082h,030h,0EBh,032h,034h,0F7h,02Dh,082h,030h,0EBh
; @01E59 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,034h,080h,0EBh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h
; @01E69 UNKNOWN module bytes; code/data distinction not yet proven
    db 029h,081h,081h,0EDh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h
; @01E79 UNKNOWN module bytes; code/data distinction not yet proven
    db 029h,081h,081h,0EDh,02Bh,0E1h,02Bh,081h,02Bh,081h,081h,0EDh,02Bh,0E1h,02Bh,081h
; @01E89 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,081h,081h,0EDh,02Dh,0E1h,02Dh,081h,02Dh,081h,081h,0F9h,02Dh,080h,0A6h,088h
; @01E99 UNKNOWN module bytes; code/data distinction not yet proven
    db 074h,0FFh,032h,0E1h,081h,032h,081h,081h,032h,081h,081h,032h,0FFh,032h,0E1h,081h
; @01EA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,081h,081h,032h,081h,081h,032h,0FFh,032h,0E1h,081h,032h,081h,081h,032h,081h
; @01EB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,032h,0F7h,032h,082h,080h,084h,0E8h,0FEh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh
; @01EC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,081h,0E2h,02Dh,0F7h,030h,032h,0FEh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh,0E3h
; @01ED9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E2h,02Dh,0F7h,032h,082h,080h,0A6h,088h,074h,084h,0EFh,0EBh,01Dh,0E1h,01Dh
; @01EE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh
; @01EF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Fh,0E1h,01Fh
; @01F09 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,01Fh,081h,081h,0EDh,01Fh,0E1h,01Fh,081h,01Fh,081h,081h,0EDh,021h,0E1h,021h
; @01F19 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,021h,081h,081h,0F9h,021h,084h,0E8h,080h,0A6h,088h,074h,0F7h,026h,082h,029h
; @01F29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,02Bh,02Dh,0F7h,026h,082h,029h,0EBh,02Bh,02Dh,080h,0EBh,024h,0E1h,024h,081h
; @01F39 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h
; @01F49 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,026h,0E1h,026h,081h
; @01F59 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,028h,0E1h,028h,081h
; @01F69 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,081h,081h,0F9h,028h,080h,0A6h,088h,074h,0FFh,021h,0E1h,081h,021h,081h,081h
; @01F79 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,081h,081h,021h,0FFh,021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h,0FFh
; @01F89 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h,0F7h,021h,082h,080h,084h,0E8h
; @01F99 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FEh,026h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h,0F7h,029h,02Bh,0FEh
; @01FA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h,0F7h,02Bh,082h,080h,0A6h
; @01FB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,074h,084h,0EFh,0EBh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,018h,0E1h,018h
; @01FC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,018h,081h,081h,0EDh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,018h,0E1h,018h
; @01FD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,018h,081h,081h,0EDh,01Ah,0E1h,01Ah,081h,01Ah,081h,081h,0EDh,01Ah,0E1h,01Ah
; @01FE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,01Ah,081h,081h,0EDh,01Ch,0E1h,01Ch,081h,01Ch,081h,081h,0F9h,01Ch,084h,0E8h
; @01FF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0A6h,088h,074h,0F7h,039h,082h,03Ch,0EBh,03Eh,040h,0F7h,039h,082h,03Ch,0EBh
; @02009 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,040h,080h,0A7h,084h,00h,08Ah,04h,00h,04h,016h,0E5h,03Ch,0E2h,081h,08Ah
; @02019 UNKNOWN module bytes; code/data distinction not yet proven
    db 04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah
; @02029 UNKNOWN module bytes; code/data distinction not yet proven
    db 04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,0E5h,03Ch,08Ah,0FCh
; @02039 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FFh,04h,016h,082h,0F7h,039h,0E1h,037h,039h,037h,035h,034h,0A8h,084h,00h,0EDh
; @02049 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E8h,037h,03Eh,03Ch,037h,0E5h,08Ah,0FBh,0FFh,0Ch,011h,03Eh,039h,08Ah,03h
; @02059 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,030h,015h,0F7h,037h,082h,0E3h,032h,0E1h,037h,039h,082h,032h,037h,039h,032h
; @02069 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,039h,032h,035h,082h,037h,039h,082h,032h,037h,039h,032h,037h,039h,032h,037h
; @02079 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h,03Ch,08Ah,06h,00h,024h,020h
; @02089 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh
; @02099 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Ch,035h,032h,03Ch,035h
; @020A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,03Ch,035h,032h,03Ch,035h,032h,03Eh,037h,032h,03Eh,037h,032h,040h,039h,034h
; @020B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,040h,080h,0E3h,029h,0E1h,02Bh,0E3h,02Ch,0E1h,02Eh,02Ch,02Eh,030h,0F5h,033h
; @020C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Bh,0E1h,02Dh,0E3h,02Eh,0E1h,030h
; @020D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Eh,030h,032h,0F5h,035h,0E1h,081h,032h,030h,02Dh,0F7h,031h,034h,080h,0A6h,088h
; @020E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 074h,0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h,081h,026h,0FFh,026h,0E1h,081h
; @020F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,081h,081h,026h,081h,081h,026h,0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h
; @02109 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,026h,0F7h,026h,082h,080h,0A7h,084h,00h,08Ah,04h,00h,04h,016h,0E5h,03Ch
; @02119 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,0FDh
; @02129 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,0E1h,03Ch,03Ah,0E0h,039h,037h,0F7h,035h,0E1h,032h,032h,034h,034h,081h,037h
; @02139 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,081h,081h,08Ah,03h,00h,07h,015h,0E8h,037h,08Ah,03h,00h,07h,015h,0E8h
; @02149 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,034h,037h,0E5h,081h,0E2h,034h,0E0h,081h,08Ah,0FCh,0FFh,05h,010h,0EBh,039h
; @02159 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,064h,08Ah,0FCh,0FFh,05h,010h,039h,088h,060h,08Ah,0FCh,0FFh,05h,010h,039h
; @02169 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,050h,08Ah,0FCh,0FFh,05h,010h,0EDh,039h,0ABh,0E1h,026h,02Dh,0E5h,032h,032h
; @02179 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E1h,032h,0E1h,028h,02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h,029h
; @02189 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,035h,035h,03Ch,082h,029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h,03Eh
; @02199 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,02Bh,032h,082h,02Dh,034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h,02Dh
; @021A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,02Fh,02Dh,02Bh,028h,040h,03Eh,03Bh,039h,037h,034h,0A6h,0F7h,037h,0EBh
; @021B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,043h,080h,0A7h,084h,07h,0E3h,029h,0E1h,02Bh,0E3h,02Ch,0E1h,02Eh,02Ch,02Eh
; @021C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Bh,0E1h,02Dh,0E3h
; @021D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Eh,0E1h,030h,02Eh,030h,032h,0F5h,035h,0E1h,081h,032h,030h,02Dh,0F7h,031h,034h
; @021E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 084h,00h,080h,0A7h,088h,06Ch,084h,00h,0E1h,081h,08Ah,04h,00h,04h,016h,0E5h
; @021F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,0E2h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h
; @02209 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FDh,03Ch,0E1h,03Ch,03Ah,0E0h,039h,037h,0F7h,035h,0E1h,032h,032h,034h,034h,081h
; @02219 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,037h,081h,081h,08Ah,03h,00h,07h,015h,0E8h,037h,08Ah,03h,00h,07h,015h
; @02229 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,037h,034h,037h,0E5h,081h,0E2h,034h,0E0h,081h,08Ah,0FCh,0FFh,05h,010h,0EBh
; @02239 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,088h,05Ch,08Ah,0FCh,0FFh,05h,010h,039h,088h,054h,08Ah,0FCh,0FFh,05h,010h
; @02249 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,088h,04Ch,08Ah,0FCh,0FFh,05h,010h,0EDh,039h,0ABh,0E1h,026h,02Dh,0E5h,032h
; @02259 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,032h,0E1h,032h,0E1h,028h,02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h
; @02269 UNKNOWN module bytes; code/data distinction not yet proven
    db 029h,02Dh,035h,035h,03Ch,082h,029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h
; @02279 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,082h,02Bh,032h,082h,02Dh,034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h
; @02289 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,034h,032h,02Fh,02Dh,02Bh,028h,040h,03Eh,03Bh,039h,037h,034h,0A6h,0F7h,037h
; @02299 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,03Eh,0E9h,043h,080h,0A0h,0F7h,081h,081h,081h,081h,081h,081h,081h,081h,080h
; @022A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A7h,088h,06Ch,084h,00h,0E1h,081h,08Ah,04h,00h,04h,016h,0E5h,03Ch,0E2h,081h
; @022B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,03Ch,082h,081h
; @022C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Ah,04h,00h,04h,016h,03Ch,082h,081h,08Ah,04h,00h,04h,016h,0E5h,03Ch,08Ah
; @022D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FCh,0FFh,04h,016h,082h,0F7h,039h,0E1h,037h,039h,037h,035h,034h,0A8h,088h,06Ch
; @022E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 084h,00h,0EDh,032h,0E8h,037h,03Eh,03Ch,037h,0E5h,08Ah,0FBh,0FFh,0Ch,011h,03Eh
; @022F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,08Ah,03h,00h,030h,015h,0F7h,037h,082h,0E3h,032h,0E1h,037h,039h,082h,032h
; @02309 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,039h,032h,037h,039h,032h,035h,082h,037h,039h,082h,032h,037h,039h,032h,037h
; @02319 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,032h,037h,082h,039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h,03Ch,08Ah,06h
; @02329 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,024h,020h,0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh
; @02339 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Ch,035h
; @02349 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,03Ch,035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Eh,037h,032h,03Eh,037h,032h
; @02359 UNKNOWN module bytes; code/data distinction not yet proven
    db 040h,039h,034h,0E3h,040h,080h,0F7h,081h,081h,0E3h,029h,0E1h,02Bh,02Ch,082h,02Eh
; @02369 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Dh,0E1h
; @02379 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,0E3h,030h,0E1h,032h,030h,032h,034h,0F1h,037h,0EBh,039h,080h,0F7h,081h,081h
; @02389 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A6h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h
; @02399 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,034h,036h,039h,036h,039h,03Bh,039h,03Bh,03Eh,03Bh,03Eh,023h,028h,02Ah,02Dh
; @023A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,02Fh,034h,036h,039h,036h,039h,03Bh,039h
; @023B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,03Eh,03Bh,03Eh,080h,0F7h,081h,081h,0A7h,084h,07h,088h,06Ch,0E3h,029h,0E1h
; @023C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,02Ch,082h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh
; @023D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,0E3h,02Dh,0E1h,02Fh,0E3h,030h,0E1h,032h,030h,032h,034h,0F1h,037h,0EBh,039h
; @023E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 084h,00h,080h,05h,09h,00h,024h,08h,024h,010h,024h,018h,024h,020h,024h,028h
; @023F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,02Ch,024h,030h,024h,036h,024h,03Ch,024h,054h,024h,00h,00h,02h,024h,072h
; @02409 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,08Ah,024h,00h,00h,0Ah,024h,0A8h,024h,0C0h,024h,00h,00h,012h,024h,0DEh
; @02419 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,0Fh,025h,00h,00h,01Ah,024h,070h,025h,088h,025h,00h,00h,022h,024h,0B7h
; @02429 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,0CAh,025h,0DDh,025h,012h,026h,075h,026h,00h,00h,030h,024h,0Ch,027h,00h
; @02439 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,036h,024h,0A6h,084h,0F4h,088h,072h,0EBh,028h,02Bh,028h,0E2h,02Bh,081h,02Dh
; @02449 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0EBh,028h,02Bh,028h,0E2h,02Bh,081h,02Dh,081h,080h,0EBh,028h,02Bh,028h,0E2h
; @02459 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,081h,02Dh,081h,0EBh,028h,02Bh,028h,0E2h,02Bh,081h,02Dh,081h,0F7h,02Fh,082h
; @02469 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0EBh,028h,0E2h,02Dh,081h,02Fh,081h,080h,0A6h,084h,0F4h,088h,072h,0EBh,023h
; @02479 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,023h,0E2h,028h,081h,028h,081h,0EBh,023h,028h,023h,0E2h,028h,081h,028h,081h
; @02489 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0EBh,023h,028h,023h,0E2h,028h,081h,028h,081h,0EBh,023h,028h,023h,0E2h,028h
; @02499 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,028h,081h,0F7h,02Dh,082h,028h,0EBh,024h,0E2h,028h,081h,02Bh,081h,080h,0A6h
; @024A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 084h,0F4h,088h,072h,0EBh,021h,024h,021h,0E2h,024h,081h,026h,081h,0EBh,021h,024h
; @024B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,0E2h,024h,081h,026h,081h,080h,0EBh,021h,024h,021h,0E2h,024h,081h,026h,081h
; @024C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,021h,024h,021h,0E2h,024h,081h,026h,081h,0F7h,028h,082h,026h,0EBh,02Bh,0E2h
; @024D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,081h,028h,081h,080h,0E5h,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h
; @024E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch
; @024F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h,0Eh
; @02509 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
; @02519 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h
; @02529 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h
; @02539 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E1h,0A1h,0Eh,081h,0Eh,0E5h,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch
; @02549 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0E3h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h
; @02559 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0E5h,0A1h,0Eh,0A0h,0Ch,0A1h,0Eh,0E1h
; @02569 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,081h,0A2h,0Eh,081h,0Eh,081h,0Eh,081h
; @02579 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h
; @02589 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E1h
; @02599 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0E5h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0E1h
; @025A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0E5h,0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A3h,0E5h
; @025B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h
; @025C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h
; @025D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,089h,0CAh,025h,0A4h,088h,078h,0E1h,015h,015h,015h,015h,015h,015h,018h,018h
; @025E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,018h,018h,018h,015h,015h,015h,015h,015h,015h,018h,018h,018h,01Ah,081h,01Ah
; @025F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,015h,015h,015h,015h,018h,018h,018h,018h,018h,018h,015h,015h,015h,015h
; @02609 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,018h,018h,018h,01Ah,081h,01Ah,080h,0E1h,015h,015h,015h,015h,015h,015h
; @02619 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,018h,018h,018h,018h,018h,015h,015h,015h,015h,015h,015h,018h,018h,018h,01Ah
; @02629 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,01Ah,015h,015h,015h,015h,015h,015h,018h,018h,018h,018h,018h,018h,015h,015h
; @02639 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,015h,015h,018h,018h,018h,01Ah,081h,01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch
; @02649 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch
; @02659 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,01Ch,01Ah,01Ah,01Ah,01Ah,01Ah,01Ah,018h,01Ah,01Ah,01Ah,01Ah,01Ah,018h,018h
; @02669 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,018h,018h,018h,0E2h,013h,081h,01Ch,081h,089h,012h,026h,0F7h,081h,081h,081h
; @02679 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0A7h,084h,00h,0E2h,040h,081h,088h,070h,040h,081h,088h,068h,040h,081h,088h
; @02689 UNKNOWN module bytes; code/data distinction not yet proven
    db 060h,040h,0FAh,081h,088h,07Fh,0E2h,043h,081h,088h,070h,043h,081h,088h,068h,043h
; @02699 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,088h,060h,043h,0FAh,081h,088h,07Fh,0E2h,040h,081h,088h,070h,040h,081h,088h
; @026A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 068h,040h,081h,088h,060h,040h,081h,040h,081h,088h,058h,040h,081h,088h,050h,040h
; @026B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,088h,048h,040h,081h,088h,07Fh,03Eh,081h,088h,070h,03Eh,081h,088h,068h,03Eh
; @026C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,088h,060h,03Eh,081h,03Eh,081h,088h,058h,03Eh,081h,088h,050h,03Eh,081h,088h
; @026D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 048h,03Eh,081h,088h,07Fh,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h
; @026E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh
; @026F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,03Eh,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0F7h,081h,081h
; @02709 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,080h,0F7h,081h,081h,081h,081h,0E0h,081h,0A7h,0E2h,040h,081h,088h,070h
; @02719 UNKNOWN module bytes; code/data distinction not yet proven
    db 040h,081h,088h,068h,040h,081h,088h,060h,040h,0FAh,081h,088h,07Fh,0E2h,043h,081h
; @02729 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,070h,043h,081h,088h,068h,043h,081h,088h,060h,043h,0FAh,081h,088h,07Fh,0E2h
; @02739 UNKNOWN module bytes; code/data distinction not yet proven
    db 040h,081h,088h,070h,040h,081h,088h,068h,040h,081h,088h,060h,040h,081h,040h,081h
; @02749 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,058h,040h,081h,088h,050h,040h,081h,088h,048h,040h,081h,088h,07Fh,03Eh,081h
; @02759 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,070h,03Eh,081h,088h,068h,03Eh,081h,088h,060h,03Eh,081h,03Eh,081h,088h,058h
; @02769 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,081h,088h,050h,03Eh,081h,088h,048h,03Eh,081h,0F6h,081h,0ABh,084h,00h,0E1h
; @02779 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh
; @02789 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0E1h,02Fh,034h
; @02799 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,039h,03Bh,081h,0A7h,0E2h,032h,081h,02Fh,081h,0F7h,081h,081h,081h,081h,080h
; @027A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 05h,07h,0B9h,027h,0BBh,027h,0BDh,027h,0BFh,027h,0C1h,027h,0C3h,027h,0C5h,027h
; @027B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C7h,027h,04h,028h,026h,028h,03Fh,028h,058h,028h,071h,028h,0C7h,028h,0A4h,084h
; @027C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,0E1h,09h,0Eh,013h,0Eh,013h,015h,0Eh,013h,015h,018h,015h,01Ah,01Fh,018h
; @027D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,015h,013h,0Eh,011h,016h,018h,01Bh,018h,01Dh,022h,01Bh,016h,018h,016h,011h
; @027E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,013h,015h,018h,015h,01Ah,01Fh,018h,013h,015h,013h,0Eh,013h,018h,01Ah,01Dh
; @027F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ah,01Fh,024h,01Dh,018h,01Ah,018h,013h,089h,0D1h,027h,0E1h,0A1h,0Eh,0Eh,0A0h
; @02809 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0Eh,0A0h,0Ch,0A1h,0Eh,0A0h,0Ch,0Ch,0A1h,0Eh,0A0h,0Ch,0Ch
; @02819 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0Eh,0A0h,0Ch,0A1h,0Eh,0Eh,0A0h,0Ch,089h,04h,028h,0EBh,081h,0E1h
; @02829 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A2h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,081h,081h,0Eh,081h,081h,0Eh,0Eh,081h
; @02839 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,081h,089h,030h,028h,0EBh,081h,0A6h,088h,076h,0E5h,02Dh,02Bh,02Eh,02Dh
; @02849 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,02Eh,02Dh,02Bh,02Dh,02Bh,02Eh,02Dh,032h,030h,02Eh,02Bh,089h,045h,028h,0EBh
; @02859 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0A6h,088h,072h,0E5h,021h,01Fh,022h,021h,024h,022h,021h,01Fh,021h,01Fh,022h
; @02869 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,026h,024h,022h,01Fh,089h,05Eh,028h,0A7h,0E1h,021h,026h,02Bh,026h,02Bh,02Dh
; @02879 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FFh,081h,081h,081h,081h,081h,081h,0F1h,039h,0E1h,037h,032h,039h,0F7h,03Ch,0F1h
; @02889 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h,039h,0E1h,037h,032h,039h,0F7h
; @02899 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,0F1h,039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h,040h,0E1h,03Eh,03Ch
; @028A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,0F1h,040h,0E1h,03Eh,03Ch
; @028B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,089h,079h,028h,0E1h,081h
; @028C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A7h,088h,068h,021h,026h,02Bh,026h,02Bh,02Dh,089h,079h,028h,05h,09h,0E9h,028h
; @028D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,028h,0EDh,028h,0EFh,028h,0F1h,028h,0F3h,028h,0F5h,028h,0F7h,028h,0F9h,028h
; @028E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FBh,028h,03Fh,029h,054h,029h,061h,029h,09Eh,029h,0ABh,029h,0B8h,029h,0C5h,029h
; @028F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C8h,02Ah,0E3h,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h
; @02909 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0A0h,0Ch,081h,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h
; @02919 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,0Ch,0A1h
; @02929 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0A0h,0Ch,081h,081h,0A1h,0Eh,081h,081h,0A0h,0Ch,0Ch,081h,0A1h
; @02939 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,089h,0FBh,028h,0EBh,0A2h,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
; @02949 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,089h,03Fh,029h,0A3h,0E2h,012h,081h,012h
; @02959 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,012h,081h,012h,081h,089h,056h,029h,0A4h,084h,0Ch,0E1h,06h,0Ah,0Dh,06h
; @02969 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah
; @02979 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,06h,0Ah,0Dh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh
; @02989 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,0Ah,0Fh,011h,0Ah
; @02999 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,011h,089h,095h,029h,0A5h,0F7h,027h,082h,029h,082h,02Bh,082h,082h,082h,089h
; @029A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A4h,029h,0A5h,0F7h,01Eh,082h,020h,082h,022h,082h,082h,082h,089h,0B1h,029h,0A5h
; @029B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,023h,082h,025h,082h,027h,082h,082h,082h,089h,0BEh,029h,0A7h,0E1h,033h,081h
; @029C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 033h,031h,081h,0EBh,033h,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h
; @029D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h
; @029E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
; @029F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h
; @02A09 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h
; @02A19 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h
; @02A29 UNKNOWN module bytes; code/data distinction not yet proven
    db 033h,088h,06Eh,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h
; @02A39 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h
; @02A49 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,064h,037h
; @02A59 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h
; @02A69 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h
; @02A79 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,05Ah,037h,081h,037h,035h,081h
; @02A89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h
; @02A99 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h
; @02AA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,03Ah,037h,035h,033h,088h,050h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h
; @02AB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,089h,0B0h,02Ah,0A7h
; @02AC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,06Ch,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h,033h,081h,033h
; @02AD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,081h,0EBh,033h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h,035h
; @02AE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,035h,033h,081h,0EBh,035h,0E1h,081h,037h,081h,037h,035h,081h,0EBh,037h,0E1h
; @02AF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h
; @02B09 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h
; @02B19 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
; @02B29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,05Ah,037h,081h,037h,035h,081h,0EBh,037h
; @02B39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h
; @02B49 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah
; @02B59 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,033h,088h,050h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h
; @02B69 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh
; @02B79 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h
; @02B89 UNKNOWN module bytes; code/data distinction not yet proven
    db 046h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h
; @02B99 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h
; @02BA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,088h,03Ch,089h,0B0h,02Ah
; @02BB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 05h,09h,0CDh,02Bh,0CFh,02Bh,0D1h,02Bh,0D3h,02Bh,0EFh,02Bh,0Bh,02Ch,027h,02Ch
; @02BC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 043h,02Ch,05Fh,02Ch,07Bh,02Ch,0B4h,02Ch,0CEh,02Ch,0E3h,02Ch,0E5h,02Ch,0E5h,02Ch
; @02BD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 046h,02Dh,0E5h,02Ch,0E5h,02Ch,046h,02Dh,0BDh,030h,046h,02Dh,0C0h,030h,046h,02Dh
; @02BE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0BAh,030h,00h,00h,0D5h,02Bh,0A7h,02Dh,0AAh,02Dh,0AAh,02Dh,0D5h,02Dh,0AAh,02Dh
; @02BF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0AAh,02Dh,0D5h,02Dh,0C6h,030h,0D5h,02Dh,0C9h,030h,0D5h,02Dh,0C3h,030h,00h,00h
; @02C09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,02Bh,0DFh,02Dh,0E2h,02Dh,0E2h,02Dh,0Dh,02Eh,0E2h,02Dh,0E2h,02Dh,0Dh,02Eh
; @02C19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C6h,030h,0Dh,02Eh,0C9h,030h,0Dh,02Eh,0C3h,030h,00h,00h,0Dh,02Ch,017h,02Eh
; @02C29 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ah,02Eh,01Ah,02Eh,045h,02Eh,01Ah,02Eh,01Ah,02Eh,045h,02Eh,0C6h,030h,045h,02Eh
; @02C39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C9h,030h,045h,02Eh,0C3h,030h,00h,00h,029h,02Ch,0B8h,03Fh,0B8h,03Fh,052h,02Eh
; @02C49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C3h,030h,0D7h,02Eh,01Bh,02Fh,0C3h,030h,0D7h,02Eh,0C6h,030h,0D7h,02Eh,0C9h,030h
; @02C59 UNKNOWN module bytes; code/data distinction not yet proven
    db 0D7h,02Eh,00h,00h,047h,02Ch,0B8h,03Fh,0B8h,03Fh,082h,02Fh,0C3h,030h,09h,030h
; @02C69 UNKNOWN module bytes; code/data distinction not yet proven
    db 051h,030h,0C3h,030h,09h,030h,0C6h,030h,09h,030h,0C9h,030h,09h,030h,00h,00h
; @02C79 UNKNOWN module bytes; code/data distinction not yet proven
    db 063h,02Ch,0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,081h
; @02C89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0E5h,0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,081h,0A0h,0E5h
; @02C99 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0A1h,0Eh,0E3h,0A0h,0Ch,0E1h,0Ch,0A1h,0Eh,081h,081h,0A0h,0E5h,0Ch,0A1h
; @02CA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,089h,07Bh,02Ch,0A2h,0E5h,081h,0Eh,081h
; @02CB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh
; @02CC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,089h,0B4h,02Ch,0A3h,0E5h,012h,012h,012h,012h,012h,012h,012h,012h,012h
; @02CD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,081h,089h,0D0h,02Ch,0A4h,0E1h,012h,012h,012h,012h
; @02CE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h,012h,012h,012h
; @02CF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h,010h,081h,010h
; @02D09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,081h,0Eh,010h,010h,010h,010h,081h,010h,012h,012h,012h,012h
; @02D19 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h,012h,012h,012h
; @02D29 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h,010h,081h,010h
; @02D39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,081h,0Eh,080h,0Dh,0Dh,0Dh
; @02D49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh
; @02D59 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,0Dh,010h,081h,010h,08h,08h,08h,08h,081h,08h,08h,08h,08h,0Bh,081h
; @02D69 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,08h,08h,08h,08h,081h,08h,08h,08h,08h,08h,081h,08h,0Dh,0Dh,0Dh
; @02D79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh
; @02D89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,0Dh,010h,081h,010h,09h,09h,09h,09h,081h,09h,09h,09h,09h,09h,081h
; @02D99 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,0Bh,0Bh,0Bh,0Bh,081h,0Bh,0Bh,0Bh,0Bh,0Bh,081h,0Bh,080h,0A6h,088h
; @02DA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 076h,0EEh,02Ah,0E2h,081h,028h,081h,0EEh,02Ah,0E2h,081h,028h,081h,0F7h,028h,0E8h
; @02DB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,0E2h,081h,0E8h,028h,0E2h,081h,0EEh,02Ah,0E2h,081h,028h,081h,0EEh,02Ah,0E2h
; @02DC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,028h,081h,0F7h,028h,0E8h,026h,0E2h,081h,0EBh,026h,080h,0F7h,025h,082h,020h
; @02DD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,025h,082h,082h,023h,080h,0A6h,088h,076h,0EEh,02Dh,0E2h,081h,02Dh,081h,0EEh
; @02DE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E2h,081h,02Dh,081h,0F7h,02Ch,0E8h,02Bh,0E2h,081h,0E8h,02Ch,0E2h,081h,0EEh
; @02DF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E2h,081h,02Dh,081h,0EEh,02Dh,0E2h,081h,02Dh,081h,0F7h,02Ch,0E8h,02Bh,0E2h
; @02E09 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0EBh,02Ah,080h,0F7h,081h,081h,023h,081h,081h,081h,081h,081h,080h,0A6h,088h
; @02E19 UNKNOWN module bytes; code/data distinction not yet proven
    db 076h,0EEh,031h,0E2h,081h,031h,081h,0EEh,031h,0E2h,081h,031h,081h,0F7h,02Fh,0E8h
; @02E29 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,0E2h,081h,0E8h,02Fh,0E2h,081h,0EEh,031h,0E2h,081h,031h,081h,0EEh,031h,0E2h
; @02E39 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,031h,081h,0F7h,02Fh,0E8h,02Fh,0E2h,081h,0EBh,02Dh,080h,0F7h,028h,082h,081h
; @02E49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,01Eh,020h,0F7h,028h,082h,021h,027h,080h,0A7h,084h,0Ch,08Ah,02h,00h,04h
; @02E59 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0F7h,036h,082h,0E1h,039h,038h,036h,039h,038h,036h,038h,036h,034h,038h,036h
; @02E69 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0F7h,031h,0E5h,038h,0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h,039h,0E1h
; @02E79 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,02Ah,02Ch,02Dh,031h,02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h,0EDh,02Ah
; @02E89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,081h,0E1h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh
; @02E99 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h,036h,0E3h
; @02EA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0F7h,03Bh,0E1h,081h,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh
; @02EB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h,045h,044h
; @02EC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 042h,040h,042h,040h,03Dh,040h,03Dh,03Bh,039h,0F1h,036h,0E5h,081h,080h,0A7h,0E1h
; @02ED9 UNKNOWN module bytes; code/data distinction not yet proven
    db 04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch
; @02EE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,0EFh,050h,0E7h,051h,0F4h,050h,0E2h,081h
; @02EF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,04Ch,04Eh,049h
; @02F09 UNKNOWN module bytes; code/data distinction not yet proven
    db 04Ch,04Eh,050h,04Ch,04Eh,049h,04Ch,04Eh,050h,0EFh,051h,0E1h,050h,051h,082h,0F9h
; @02F19 UNKNOWN module bytes; code/data distinction not yet proven
    db 053h,080h,0A7h,084h,0Ch,0E8h,038h,0FFh,031h,0E4h,081h,0E1h,036h,0E5h,039h,0E2h
; @02F29 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,0ECh,034h,0E1h,02Ch,0E3h,02Dh,0E5h,02Ah,02Dh,0E7h,02Ah,0E5h,02Ch,0E9h,02Dh
; @02F39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Fh,0E3h,031h,0F9h,02Fh,0E1h,034h,0EDh,036h,0E1h,038h,0E3h,039h,0F9h,036h
; @02F49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,039h,03Dh,0EFh,045h,0E1h,042h,0E3h,045h,0E5h,042h,0E7h,03Dh,0E3h,042h,0E1h
; @02F59 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Dh,0EFh,039h,0E1h,038h,039h,038h,0F1h,036h,0E1h,034h,0E3h,038h,0E1h,039h,0E3h
; @02F69 UNKNOWN module bytes; code/data distinction not yet proven
    db 038h,0E5h,034h,036h,031h,0F3h,034h,0E3h,02Ch,0E5h,034h,0E1h,02Ch,0E5h,034h,0E1h
; @02F79 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,034h,0E5h,02Dh,0EDh,02Ah,0E5h,081h,080h,0E1h,081h,0A7h,088h,068h,08Ah,02h
; @02F89 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,04h,036h,0F7h,036h,082h,0E1h,039h,038h,036h,039h,038h,036h,038h,036h,034h
; @02F99 UNKNOWN module bytes; code/data distinction not yet proven
    db 038h,036h,034h,0F7h,031h,0E5h,038h,0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h
; @02FA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0E1h,081h,02Ah,02Ch,02Dh,031h,02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h
; @02FB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,02Ah,0E9h,081h,0E1h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh
; @02FC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h
; @02FD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0E3h,039h,0F7h,03Bh,0E1h,081h,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh
; @02FE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h
; @02FF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 045h,044h,042h,040h,042h,040h,03Dh,040h,03Dh,03Bh,039h,0F1h,036h,0E3h,081h,080h
; @03009 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,0A6h,088h,070h,0E1h,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h,028h
; @03019 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,0EFh,02Ch
; @03029 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,02Dh,0F4h,02Ch,0E2h,081h,0E1h,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h
; @03039 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,028h,02Ah,025h,028h,02Ah,02Ch,0EFh
; @03049 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E1h,02Ch,02Dh,082h,0F7h,02Fh,080h,0E1h,081h,0A7h,088h,068h,0E8h,038h,0FFh
; @03059 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,0E4h,081h,0E1h,036h,0E5h,039h,0E2h,031h,0ECh,034h,0E1h,02Ch,0E3h,02Dh,0E5h
; @03069 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,02Dh,0E7h,02Ah,0E5h,02Ch,0E9h,02Dh,0E1h,02Fh,0E3h,031h,0F9h,02Fh,0E1h,034h
; @03079 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,036h,0E1h,038h,0E3h,039h,0F9h,036h,0E5h,039h,03Dh,0EFh,045h,0E1h,042h,0E3h
; @03089 UNKNOWN module bytes; code/data distinction not yet proven
    db 045h,0E5h,042h,0E7h,03Dh,0E3h,042h,0E1h,03Dh,0EFh,039h,0E1h,038h,039h,038h,0F1h
; @03099 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0E1h,034h,0E3h,038h,0E1h,039h,0E3h,038h,0E5h,034h,036h,031h,0F3h,034h,0E3h
; @030A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,0E5h,034h,0E1h,02Ch,0E5h,034h,0E1h,02Ch,034h,0E5h,02Dh,0EDh,02Ah,0E3h,081h
; @030B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,084h,00h,080h,084h,02h,080h,084h,03h,080h,084h,0E8h,080h,084h,0EAh,080h
; @030C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 084h,0EBh,080h,084h,0F4h,080h,084h,0F6h,080h,084h,0F7h,080h,04h,08h,0E7h,030h
; @030D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,030h,0EBh,030h,0EDh,030h,0FDh,030h,0Dh,031h,01Dh,031h,02Bh,031h,039h,031h
; @030E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 048h,031h,052h,031h,05Bh,031h,05Bh,031h,05Bh,031h,05Bh,031h,0BEh,031h,05Bh,031h
; @030F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,0F1h,030h,01Fh,032h,01Fh,032h,029h,032h,029h,032h,03Ch,032h,029h,032h
; @03109 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,01h,031h,04Fh,032h,04Fh,032h,059h,032h,059h,032h,06Eh,032h,059h,032h
; @03119 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,011h,031h,081h,032h,081h,032h,08Ch,032h,08Ch,032h,097h,032h,00h,00h
; @03129 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,031h,0B5h,032h,0B5h,032h,0C0h,032h,0C0h,032h,0D2h,032h,00h,00h,02Fh,031h
; @03139 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,0A0h,0Ch,0Ch,081h,0Ch,081h,0Ch,0A1h,0Eh,0E9h,081h,089h,039h,031h,0EBh
; @03149 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0A2h,0Eh,081h,0Eh,081h,089h,04Bh,031h,0A3h,0E5h,012h,012h,012h,012h,089h
; @03159 UNKNOWN module bytes; code/data distinction not yet proven
    db 054h,031h,0A4h,0E1h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
; @03169 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
; @03179 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h
; @03189 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h
; @03199 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h
; @031A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h
; @031B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,081h,011h,081h,080h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch
; @031C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch
; @031D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch
; @031E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh
; @031F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh
; @03209 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh
; @03219 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Fh,081h,0Fh,081h,080h,0A9h,0FFh,021h,082h,082h,024h,082h,082h,0ACh,080h
; @03229 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,015h,0EBh,017h,018h,015h,082h,017h,018h,0F7h,015h,0EBh,017h,018h,015h,082h
; @03239 UNKNOWN module bytes; code/data distinction not yet proven
    db 017h,018h,080h,0F7h,013h,0EBh,017h,018h,013h,082h,017h,018h,0F7h,013h,0EBh,017h
; @03249 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,013h,082h,017h,018h,080h,0A9h,0FFh,026h,082h,082h,029h,082h,082h,0ACh,080h
; @03259 UNKNOWN module bytes; code/data distinction not yet proven
    db 088h,070h,0F7h,021h,0EBh,023h,024h,021h,082h,023h,024h,0F7h,021h,0EBh,023h,024h
; @03269 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,082h,023h,024h,080h,0F7h,01Fh,0EBh,023h,024h,01Fh,082h,023h,024h,0F7h,01Fh
; @03279 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,023h,024h,01Fh,082h,023h,024h,080h,0ACh,088h,066h,0FFh,021h,082h,082h,024h
; @03289 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,080h,0ADh,0F7h,03Ch,082h,082h,082h,03Ch,082h,039h,082h,080h,0F7h,037h
; @03299 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,082h,03Ah,082h,081h,081h,081h,081h,081h,081h,081h,0ECh,081h,0E0h,040h
; @032A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,040h,0E8h,081h,0E0h,040h,081h,040h,0F5h,081h,081h,080h,0ACh,088h,066h,0FFh
; @032B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,082h,082h,029h,082h,082h,080h,0ADh,0F1h,03Ah,039h,082h,082h,082h,0E5h,081h
; @032C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,03Ah,039h,0EBh,037h,0F7h,035h,082h,080h,0F7h,034h,082h,082h,082h,033h,082h
; @032D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,03Fh,03Eh,082h,082h,082h,081h,0ECh,081h,0E0h,045h,081h,045h,0E8h,081h,0E0h
; @032E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 045h,081h,045h,0F5h,081h,081h,080h,05h,09h,04h,033h,012h,033h,020h,033h,022h
; @032F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 033h,036h,033h,048h,033h,05Ah,033h,06Ch,033h,07Ch,033h,08Ch,033h,08Dh,033h,0Ah
; @03309 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0Ch,035h,0Ah,034h,00h,00h,04h,033h,08Ch,035h,08Eh,035h,0EFh,035h,0B1h
; @03319 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0EFh,035h,00h,00h,012h,033h,013h,037h,01Ch,037h,01Fh,037h,079h,037h,079h
; @03329 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0DBh,037h,0DBh,037h,079h,037h,079h,037h,00h,00h,022h,033h,0Ch,038h,0Dh
; @03339 UNKNOWN module bytes; code/data distinction not yet proven
    db 038h,017h,038h,017h,038h,021h,038h,017h,038h,017h,038h,00h,00h,036h,033h,02Bh
; @03349 UNKNOWN module bytes; code/data distinction not yet proven
    db 038h,02Ch,038h,036h,038h,036h,038h,040h,038h,036h,038h,036h,038h,00h,00h,048h
; @03359 UNKNOWN module bytes; code/data distinction not yet proven
    db 033h,04Ah,038h,04Bh,038h,055h,038h,055h,038h,05Fh,038h,055h,038h,055h,038h,00h
; @03369 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,05Ah,033h,0AEh,03Fh,069h,038h,083h,038h,0ECh,038h,0ECh,038h,0Eh,039h,00h
; @03379 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,06Ch,033h,0AEh,03Fh,086h,039h,0A4h,039h,0ECh,038h,0ECh,038h,0Eh,039h,00h
; @03389 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,07Ch,033h,0E1h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @03399 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @033A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @033B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h
; @033C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @033D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h
; @033E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @033F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @03409 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0E1h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03419 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03429 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03439 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03449 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03459 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03469 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03479 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03489 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @03499 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @034A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @034B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @034C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @034D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @034E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh
; @034F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0Eh,0Eh,0A0h,0Ch,0A1h,0Eh
; @03509 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,080h,0E1h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @03519 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @03529 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @03539 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h
; @03549 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @03559 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @03569 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch
; @03579 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0A1h,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh
; @03589 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,080h,0E1h,0A2h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @03599 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,0Eh,0Eh,081h,081h,081h
; @035A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
; @035B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Eh,0Eh,0Eh,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @035C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,0Eh,0Eh,0Eh,0Eh,081h,081h,081h
; @035D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @035E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
; @035F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
; @03609 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @03619 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
; @03629 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
; @03639 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @03649 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
; @03659 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
; @03669 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @03679 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
; @03689 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
; @03699 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @036A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Eh,081h,0Eh,0Eh,081h,080h,0E1h,081h,081h,081h,0Eh,081h,081h,081h
; @036B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @036C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
; @036D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,0Eh,0Eh,0Eh,0Eh,081h,081h,081h,0Eh,081h,081h,081h
; @036E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h
; @036F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,0Eh
; @03709 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A3h,0E5h,012h,012h,012h,012h
; @03719 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,015h,037h,0A4h,084h,0Ch,0E1h,09h,082h,09h,09h,09h,09h,09h,082h,09h
; @03729 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h
; @03739 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h
; @03749 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,09h,0E1h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,09h
; @03759 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,09h,09h,09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h,09h,09h,09h,09h
; @03769 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h,080h
; @03779 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h
; @03789 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h
; @03799 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h
; @037A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h
; @037B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Dh,09h,0Eh,09h,010h,09h
; @037C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,09h,0Eh,09h,010h,09h,0Dh,09h,0Eh,09h,010h,09h,0Dh,09h,0Eh,09h
; @037D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,080h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,09h,082h
; @037E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,07h,082h,07h,07h,07h,07h
; @037F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,082h,07h,07h,07h,07h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h
; @03809 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,080h,0A5h,0F7h,026h,082h,024h,082h,025h,082h,026h,025h,080h,0F7h,026h
; @03819 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,026h,082h,026h,082h,026h,025h,080h,0F7h,026h,026h,026h,028h,026h,026h,026h
; @03829 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,080h,0A5h,0F7h,023h,082h,01Fh,082h,021h,082h,021h,021h,080h,0F7h,023h,082h
; @03839 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,021h,082h,021h,021h,080h,0F7h,021h,023h,023h,025h,021h,023h,023h,025h
; @03849 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0A5h,0F7h,01Fh,082h,01Ch,082h,01Ch,082h,01Eh,01Ch,080h,0F7h,01Fh,082h,01Fh
; @03859 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,01Eh,082h,01Ch,01Ch,080h,0F7h,01Eh,01Eh,01Fh,021h,01Eh,01Eh,01Fh,021h,080h
; @03869 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A9h,0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh,021h,0E9h,032h,0E7h
; @03879 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0FDh,02Dh,0E9h,026h,0E7h,028h,0FDh,025h,080h,0A7h,0F7h,032h,0E1h,039h,037h
; @03889 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h,02Dh,0EBh,031h,032h,0FBh
; @03899 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h,031h,02Dh,031h,032h,031h
; @038A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h,0E3h,032h,0F4h,02Dh,0E2h
; @038B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh,02Dh,02Fh,0F0h,02Ah,0E2h
; @038C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h,031h,032h,034h,032h,0F1h
; @038D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,0F4h,031h
; @038E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,081h,080h,0E1h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h,032h,02Dh
; @038F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F5h,036h,0E1h,081h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h,032h,036h
; @03909 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F5h,039h,0E1h,081h,080h,0F1h,034h,0E3h,032h,0E5h,031h,02Fh,031h,0E7h,032h,0E5h
; @03919 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0E3h,034h,0E5h,032h,031h,0F7h,02Dh,0E1h,032h,031h,02Fh,0F1h,02Dh,0E1h,02Bh
; @03929 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,028h,0EBh,026h,0E1h,028h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,02Fh,0E3h,031h,032h
; @03939 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0F5h,031h,0E1h,037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E0h,081h,0E1h
; @03949 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E2h,081h,0E1h,03Bh,039h,037h,036h
; @03959 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,037h,036h,034h,032h,034h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Bh,02Ah
; @03969 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,02Bh,02Ah,028h,0EFh,026h,0E1h,036h,032h,02Dh,032h,0EFh,036h,0E1h,032h,02Dh
; @03979 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,032h,0E9h,034h,0E7h,032h,0E5h,031h,0F5h,02Dh,0E1h,081h,080h,0A9h,088h,060h
; @03989 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh,021h,0E9h,032h
; @03999 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,036h,0FDh,02Dh,0E9h,026h,0E7h,028h,0FBh,025h,080h,088h,078h,0F7h,032h,0E1h
; @039A9 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,037h,036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h,02Dh,0EBh,031h
; @039B9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0FBh,036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h,031h,02Dh,031h
; @039C9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,031h,02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h,0E3h,032h,0F4h
; @039D9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E2h,081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh,02Dh,02Fh,0F0h
; @039E9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E2h,081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h,031h,032h,034h
; @039F9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0F1h,036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh
; @03A09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F4h,031h,0E2h,081h,080h,04h,09h,022h,03Ah,04Ah,03Ah,072h,03Ah,09Ah,03Ah,0AEh
; @03A19 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ah,0C2h,03Ah,0D6h,03Ah,0EAh,03Ah,0F8h,03Ah,08h,03Bh,08h,03Bh,033h,03Bh,033h
; @03A29 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h
; @03A39 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,033h,03Bh,00h,00h,022h
; @03A49 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ah,073h,03Bh,073h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h
; @03A59 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h,03Bh,093h
; @03A69 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,093h,03Bh,093h,03Bh,00h,00h,04Ah,03Ah,0C5h,03Bh,0C5h,03Bh,0D0h,03Bh,0D0h
; @03A79 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h
; @03A89 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,0D0h,03Bh,00h,00h,0A8h
; @03A99 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Fh,0E2h,03Bh,0E3h,03Bh,0E9h,03Bh,0E9h,03Bh,04Bh,03Ch,0E9h,03Bh,0E9h,03Bh,04Bh
; @03AA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,00h,00h,09Ah,03Ah,0Dh,03Dh,0Eh,03Dh,014h,03Dh,014h,03Dh,01Eh,03Dh,014h
; @03AB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Dh,014h,03Dh,01Eh,03Dh,00h,00h,0AEh,03Ah,030h,03Dh,031h,03Dh,037h,03Dh,037h
; @03AC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Dh,041h,03Dh,037h,03Dh,037h,03Dh,041h,03Dh,00h,00h,0C2h,03Ah,053h,03Dh,054h
; @03AD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Dh,05Ah,03Dh,05Ah,03Dh,064h,03Dh,05Ah,03Dh,05Ah,03Dh,064h,03Dh,00h,00h,0D6h
; @03AE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ah,076h,03Dh,081h,03Dh,0EAh,03Dh,035h,03Eh,0EAh,03Dh,00h,00h,0EAh,03Ah,0B8h
; @03AF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Fh,08Eh,03Eh,096h,03Eh,01h,03Fh,04Eh,03Fh,01h,03Fh,00h,00h,0F8h,03Ah,0EBh
; @03B09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A0h,0Ch,0E1h,0A1h,0Eh,0Eh,0Eh,0Eh,0Eh,081h,0EBh,0A0h,0Ch,0E1h,0A1h,0Eh
; @03B19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,081h,081h,0E5h,0A0h,0Ch,0Ch,0Ch,0Ch,0E1h,0A1h,0Eh,0Eh,0Eh
; @03B29 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0A0h,0Ch,081h,0Ch,0A1h
; @03B39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h
; @03B49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h
; @03B59 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h,0Eh,081h,081h,0A0h,0Ch,081h,0Ch,0A1h
; @03B69 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0EBh,081h,0E1h,0A2h,0Eh,0Eh
; @03B79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0EDh,081h,0E1h,0Eh,0Eh,0Eh,0Eh,0FBh,081h,0E1h,0Eh,0Eh,0Eh
; @03B89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,081h,081h,081h,0Eh,081h
; @03B99 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h
; @03BA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h,081h,081h,0Eh,081h,081h,081h
; @03BB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0A3h,0EBh,019h,081h
; @03BC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 019h,081h,019h,081h,081h,081h,080h,0E5h,012h,012h,012h,012h,012h,012h,012h,012h
; @03BD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,080h,0A4h,0F7h,013h,010h,0Bh,082h,080h
; @03BE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
; @03BF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh
; @03C09 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
; @03C19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,010h,081h,010h
; @03C29 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,081h,010h,010h,081h,010h,010h,081h,010h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh
; @03C39 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
; @03C49 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,080h,0E1h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
; @03C59 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h
; @03C69 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
; @03C79 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
; @03C89 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h
; @03C99 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
; @03CA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,010h
; @03CB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,010h,010h,081h,010h,010h,081h,010h,010h,081h,010h,0Bh,081h,0Bh,0Bh,081h
; @03CC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
; @03CD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,010h
; @03CE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,010h,010h,081h,010h,010h,081h,010h,010h,081h,010h,0Eh,081h,0Eh,0Eh,081h
; @03CF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh
; @03D09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,080h,0A5h,0F7h,02Bh,028h,02Ah,082h,080h,0F7h,01Eh,082h,082h,082h
; @03D19 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,023h,01Eh,082h,080h,0F7h,02Bh,082h,02Ah,082h,02Bh,082h,02Ah,082h,02Bh,02Bh
; @03D29 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,082h,02Bh,02Bh,02Ah,082h,080h,0A5h,0F7h,026h,025h,026h,082h,080h,0F7h,01Ah
; @03D39 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,082h,01Eh,020h,01Ah,082h,080h,0F7h,026h,082h,026h,082h,026h,082h,026h
; @03D49 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,026h,028h,026h,082h,026h,028h,026h,082h,080h,0A5h,0F7h,023h,021h,023h,082h
; @03D59 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0F7h,017h,082h,082h,082h,01Ah,01Ch,017h,082h,080h,0F7h,023h,082h,023h,082h
; @03D69 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,023h,082h,023h,023h,023h,082h,023h,023h,021h,082h,080h,0A7h,0F7h,03Eh
; @03D79 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Dh,03Bh,082h,032h,031h,02Fh,082h,080h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah
; @03D89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h,032h,0E7h,031h,0E5h,02Fh,0E1h,031h
; @03D99 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh,0F7h,02Ah,0E9h,02Ah,0E7h,028h,0E5h
; @03DA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah
; @03DB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h,0E1h,025h,023h,021h,0F7h,01Eh,0E8h
; @03DC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,026h,0E5h,023h,0E1h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h
; @03DD9 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,0F7h,02Ah,082h
; @03DE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah,02Bh,0F3h,02Ah,0E3h,028h,0F9h,026h,0F7h,02Dh
; @03DF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Dh,0E5h,02Bh,0E1h,02Dh,0F6h,02Ah,082h
; @03E09 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h,02Dh,0E3h,02Fh,0F1h,032h,0E1h,031h,0E5h,032h
; @03E19 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,0E3h,02Fh,0E5h,031h,0E1h
; @03E29 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E5h,032h,0E3h,034h,0E5h,036h,037h,0F8h,036h,082h,080h,0E1h,026h,028h,026h
; @03E39 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,0F5h,02Ah,0E1h,081h,025h,026h,025h
; @03E49 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,025h,026h,025h,026h,025h,026h,025h,026h,0F7h,023h,0E9h,028h,0E7h,02Bh,0E5h
; @03E59 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E9h,028h,0E7h,026h,0E5h,025h,0F7h,023h,082h,0E9h,028h,0E7h,02Dh,0E9h,028h
; @03E69 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,02Dh,0E5h,028h,02Bh,0E9h,02Ah,0E7h,028h,0E5h,02Bh,0F7h,02Ah,0E3h,02Dh,0E5h
; @03E79 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,0EBh,02Ah,0E1h,02Bh,0E3h,02Ah,0E5h,028h,0EBh,026h,0E1h,026h,028h,026h,025h
; @03E89 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,023h,0F7h,02Ah,080h,0A9h,088h,070h,026h,028h,02Ah,082h,080h,0E1h,081h,0E3h
; @03E99 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E3h,02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h
; @03EA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E7h,031h,0E5h,02Fh,0E1h,031h,02Fh,02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh
; @03EB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,02Ah,0E9h,02Ah,0E7h,028h,0E5h,026h,0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h
; @03EC9 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E1h,02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h
; @03ED9 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,025h,023h,021h,0F7h,01Eh,0E8h,025h,026h,0E5h,023h,0E1h,028h,026h,028h,026h
; @03EE9 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h
; @03EF9 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,028h,026h,0F6h,02Ah,082h,080h,0E1h,081h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah
; @03F09 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,0F3h,02Ah,0E3h,028h,0F9h,026h,0F7h,02Dh,0E1h,032h,031h,02Fh,031h,02Fh,02Dh
; @03F19 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Dh,0E5h,02Bh,0E1h,02Dh,0F6h,02Ah,082h,0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h
; @03F29 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E3h,02Fh,0F1h,032h,0E1h,031h,0E5h,032h,0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah
; @03F39 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Bh,0E5h,02Dh,0E3h,02Fh,0E5h,031h,0E1h,081h,0E5h,032h,0E3h,034h,0E5h,036h
; @03F49 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0F7h,036h,082h,080h,0E1h,081h,026h,028h,026h,028h,026h,028h,026h,028h,026h
; @03F59 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,028h,0F5h,02Ah,0E1h,081h,025h,026h,025h,026h,025h,026h,025h,026h,025h
; @03F69 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,025h,026h,0F7h,023h,0E9h,028h,0E7h,02Bh,0E5h,02Ah,0E9h,028h,0E7h,026h,0E5h
; @03F79 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,0F7h,023h,082h,0E9h,028h,0E7h,02Dh,0E9h,028h,0E7h,02Dh,0E5h,028h,02Bh,0E9h
; @03F89 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E7h,028h,0E5h,02Bh,0F7h,02Ah,0E3h,02Dh,0E5h,02Bh,0EBh,02Ah,0E1h,02Bh,0E3h
; @03F99 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E5h,028h,0EBh,026h,0E1h,026h,028h,026h,025h,0F1h,023h,0F5h,02Ah,080h,0AEh
; @03FA9 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Fh,00h,00h,0A8h,03Fh,0F7h,081h,081h,081h,081h,081h,081h,081h,081h,080h,0F7h
; @03FB9 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,080h
driver ends
end
