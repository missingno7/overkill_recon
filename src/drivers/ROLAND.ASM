; Modern optional-module source; historical source filename unknown.
; Original resource: ROLAND.ENC; no relocation table in ENC stream.
include ENCODING.INC
driver segment byte public 'CODE'
assume cs:driver,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
loc_00108 equ 0108h
loc_00063 equ 063h
loc_000B0 equ 0B0h
loc_000B8 equ 0B8h
loc_000D0 equ 0D0h
loc_000D6 equ 0D6h
loc_000D7 equ 0D7h
loc_000EA equ 0EAh
loc_00103 equ 0103h
loc_0011C equ 011Ch
loc_0012F equ 012Fh
loc_0013E equ 013Eh
loc_00157 equ 0157h
loc_00158 equ 0158h
loc_0015E equ 015Eh
loc_0017D equ 017Dh
loc_00195 equ 0195h
loc_001AC equ 01ACh
loc_001AD equ 01ADh
loc_002EC equ 02ECh
loc_002FA equ 02FAh
loc_00336 equ 0336h
loc_0035D equ 035Dh
loc_0035E equ 035Eh
loc_00374 equ 0374h
loc_0037C equ 037Ch
loc_0038B equ 038Bh
loc_0039F equ 039Fh
loc_003AD equ 03ADh
loc_003B4 equ 03B4h
loc_003BD equ 03BDh
loc_003C4 equ 03C4h
loc_003CB equ 03CBh
loc_003D6 equ 03D6h
loc_003DF equ 03DFh
loc_003E6 equ 03E6h
loc_003EE equ 03EEh
loc_003F8 equ 03F8h
loc_003FF equ 03FFh
loc_0040B equ 040Bh
loc_00424 equ 0424h
loc_0043E equ 043Eh
; @00000 module:0000 original=e86000
    CALL_NEAR loc_00063
; @00003 module:0003 original=cb
    retf
; @00004 module:0004 original=e86d03
    CALL_NEAR loc_00374
; @00007 module:0007 original=cb
    retf
; @00008 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,030h,03h,00h,00h,054h,079h,070h,065h,020h,03Ah
; @00018 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,052h,06Fh,06Ch,061h,06Eh,064h,0Dh,0Ah,020h,046h,069h,06Ch,065h,020h,03Ah
; @00028 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,04Fh,076h,065h,072h,06Bh,069h,06Ch,06Ch,024h,044h,061h,074h,065h,020h,03Ah
; @00038 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,030h,033h,02Eh,031h,031h,02Eh,039h,032h,024h,04Dh,075h,073h,069h,063h,020h
; @00048 UNKNOWN module bytes; code/data distinction not yet proven
    db 062h,079h,020h,053h,06Fh,075h,06Eh,064h,020h,049h,06Dh,061h,067h,065h,073h,020h
; @00058 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,063h,029h,020h,031h,039h,039h,032h,00h,01h,00h
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
; @0006C module:006C original=e87d02
    CALL_NEAR loc_002EC
; @0006F module:006F original=fe0e0d00
    dec byte ptr ds:[0Dh]
; @00073 module:0073 original=bf4804
    mov di, 0448h
; @00076 module:0076 original=e83f00
    CALL_NEAR loc_000B8
; @00079 module:0079 original=bf6704
    mov di, 0467h
; @0007C module:007C original=e83900
    CALL_NEAR loc_000B8
; @0007F module:007F original=bf8604
    mov di, 0486h
; @00082 module:0082 original=e83300
    CALL_NEAR loc_000B8
; @00085 module:0085 original=bfa504
    mov di, 04A5h
; @00088 module:0088 original=e82d00
    CALL_NEAR loc_000B8
; @0008B module:008B original=bfc404
    mov di, 04C4h
; @0008E module:008E original=e82700
    CALL_NEAR loc_000B8
; @00091 module:0091 original=bfe304
    mov di, 04E3h
; @00094 module:0094 original=e82100
    CALL_NEAR loc_000B8
; @00097 module:0097 original=bf0205
    mov di, 0502h
; @0009A module:009A original=e81b00
    CALL_NEAR loc_000B8
; @0009D module:009D original=bf2105
    mov di, 0521h
; @000A0 module:00A0 original=e81500
    CALL_NEAR loc_000B8
; @000A3 module:00A3 original=803e0d0000
    cmp byte ptr ds:[0Dh], 0
; @000A8 module:00A8 original=7506
    JNE_SHORT loc_000B0
; @000AA module:00AA original=a00c00
    mov al, byte ptr ds:[0Ch]
; @000AD module:00AD original=a20d00
    mov byte ptr ds:[0Dh], al
; @000B0 module:00B0 original=1f
    pop ds
; @000B1 module:00B1 original=5e
    pop si
; @000B2 module:00B2 original=5f
    pop di
; @000B3 module:00B3 original=5a
    pop dx
; @000B4 module:00B4 original=59
    pop cx
; @000B5 module:00B5 original=5b
    pop bx
; @000B6 module:00B6 original=58
    pop ax
; @000B7 module:00B7 original=c3
    ret
; @000B8 module:00B8 original=32c0
    xor al, al
; @000BA module:00BA original=3a4510
    cmp al, byte ptr ds:[di + 010h]
; @000BD module:00BD original=7417
    JE_SHORT loc_000D6
; @000BF module:00BF original=8b5d0c
    mov bx, word ptr ds:[di + 0Ch]
; @000C2 module:00C2 original=3a060d00
    cmp al, byte ptr ds:[0Dh]
; @000C6 module:00C6 original=7508
    JNE_SHORT loc_000D0
; @000C8 module:00C8 original=fe4d01
    dec byte ptr ds:[di + 1]
; @000CB module:00CB original=740a
    JE_SHORT loc_000D7
; @000CD module:00CD original=e86e00
    CALL_NEAR loc_0013E
; @000D0 module:00D0 original=e8aa00
    CALL_NEAR loc_0017D
; @000D3 module:00D3 original=e8bf00
    CALL_NEAR loc_00195
; @000D6 module:00D6 original=c3
    ret
; @000D7 module:00D7 original=8a07
    mov al, byte ptr ds:[bx]
; @000D9 module:00D9 original=43
    inc bx
; @000DA module:00DA original=0ac0
    or al, al
; @000DC module:00DC original=783e
    JS_SHORT loc_0011C
; @000DE module:00DE original=50
    push ax
; @000DF module:00DF original=8a25
    mov ah, byte ptr ds:[di]
; @000E1 module:00E1 original=0ae4
    or ah, ah
; @000E3 module:00E3 original=7805
    JS_SHORT loc_000EA
; @000E5 module:00E5 original=b480
    mov ah, 080h
; @000E7 module:00E7 original=e82103
    CALL_NEAR loc_0040B
; @000EA module:00EA original=58
    pop ax
; @000EB module:00EB original=8805
    mov byte ptr ds:[di], al
; @000ED module:00ED original=8a451a
    mov al, byte ptr ds:[di + 01Ah]
; @000F0 module:00F0 original=88451b
    mov byte ptr ds:[di + 01Bh], al
; @000F3 module:00F3 original=8a4518
    mov al, byte ptr ds:[di + 018h]
; @000F6 module:00F6 original=043f
    add al, 03Fh
; @000F8 module:00F8 original=3a4505
    cmp al, byte ptr ds:[di + 5]
; @000FB module:00FB original=7406
    JE_SHORT loc_00103
; @000FD module:00FD original=884505
    mov byte ptr ds:[di + 5], al
; @00100 module:0100 original=e85b02
    CALL_NEAR loc_0035E
; @00103 module:0103 original=b490
    mov ah, 090h
; @00105 module:0105 original=e80303
    CALL_NEAR loc_0040B
; @00108 module:0108 original=895d0c
    mov word ptr ds:[di + 0Ch], bx
; @0010B module:010B original=8a4511
    mov al, byte ptr ds:[di + 011h]
; @0010E module:010E original=884501
    mov byte ptr ds:[di + 1], al
; @00111 module:0111 original=c3
    ret
; @00112 0000:0112 original=b480 runtime CFG evidence
    mov ah, 080h
; @00114 0000:0114 original=e8f402 runtime CFG evidence
    CALL_NEAR loc_0040B
; @00117 0000:0117 original=c605ff runtime CFG evidence
    mov byte ptr ds:[di], 0FFh
; @0011A 0000:011A original=ebec runtime CFG evidence
    JMP_SHORT loc_00108
; @0011C module:011C original=3ce0
    cmp al, 0E0h
; @0011E module:011E original=730f
    JAE_SHORT loc_0012F
; @00120 module:0120 original=3c91
    cmp al, 091h
; @00122 module:0122 original=7f34
    JG_SHORT loc_00158
; @00124 module:0124 original=d0e0
    shl al, 1
; @00126 module:0126 original=32e4
    xor ah, ah
; @00128 module:0128 original=bef501
    mov si, 01F5h
; @0012B module:012B original=03f0
    add si, ax
; @0012D module:012D original=ff24
    jmp word ptr ds:[si]
; @0012F module:012F original=2cdf
    sub al, 0DFh
; @00131 module:0131 original=884511
    mov byte ptr ds:[di + 011h], al
; @00134 module:0134 original=eba1
    JMP_SHORT loc_000D7
; @00136 0000:0136 original=8a07 runtime CFG evidence
    mov al, byte ptr ds:[bx]
; @00138 0000:0138 original=43 runtime CFG evidence
    inc bx
; @00139 0000:0139 original=884506 runtime CFG evidence
    mov byte ptr ds:[di + 6], al
; @0013C 0000:013C original=eb99 runtime CFG evidence
    JMP_SHORT loc_000D7
; @0013E module:013E original=8a4513
    mov al, byte ptr ds:[di + 013h]
; @00141 module:0141 original=0ac0
    or al, al
; @00143 module:0143 original=7412
    JE_SHORT loc_00157
; @00145 module:0145 original=50
    push ax
; @00146 module:0146 original=8a05
    mov al, byte ptr ds:[di]
; @00148 module:0148 original=b480
    mov ah, 080h
; @0014A module:014A original=e8be02
    CALL_NEAR loc_0040B
; @0014D module:014D original=58
    pop ax
; @0014E module:014E original=0205
    add al, byte ptr ds:[di]
; @00150 module:0150 original=8805
    mov byte ptr ds:[di], al
; @00152 module:0152 original=b490
    mov ah, 090h
; @00154 module:0154 original=e8b402
    CALL_NEAR loc_0040B
; @00157 module:0157 original=c3
    ret
; @00158 module:0158 original=bf4804
    mov di, 0448h
; @0015B module:015B original=b90800
    mov cx, 8
; @0015E module:015E original=886d10
    mov byte ptr ds:[di + 010h], ch
; @00161 module:0161 original=8a4507
    mov al, byte ptr ds:[di + 7]
; @00164 module:0164 original=0cb0
    or al, 0B0h
; @00166 module:0166 original=e88f02
    CALL_NEAR loc_003F8
; @00169 module:0169 original=b07b
    mov al, 07Bh
; @0016B module:016B original=e88a02
    CALL_NEAR loc_003F8
; @0016E module:016E original=32c0
    xor al, al
; @00170 module:0170 original=e88502
    CALL_NEAR loc_003F8
; @00173 module:0173 original=83c71f
    add di, 01Fh
; @00176 module:0176 original=e2e6
    LOOP_SHORT loc_0015E
; @00178 module:0178 original=890e0800
    mov word ptr ds:[8], cx
; @0017C module:017C original=c3
    ret
; @0017D module:017D original=32c0
    xor al, al
; @0017F module:017F original=3a451a
    cmp al, byte ptr ds:[di + 01Ah]
; @00182 module:0182 original=7428
    JE_SHORT loc_001AC
; @00184 module:0184 original=3a451b
    cmp al, byte ptr ds:[di + 01Bh]
; @00187 module:0187 original=7423
    JE_SHORT loc_001AC
; @00189 module:0189 original=fe4d1b
    dec byte ptr ds:[di + 01Bh]
; @0018C module:018C original=8a4519
    mov al, byte ptr ds:[di + 019h]
; @0018F module:018F original=004505
    add byte ptr ds:[di + 5], al
; @00192 module:0192 original=e9c901
    JMP_NEAR loc_0035E
; @00195 module:0195 original=fe4d1c
    dec byte ptr ds:[di + 01Ch]
; @00198 module:0198 original=7512
    JNE_SHORT loc_001AC
; @0019A module:019A original=8a451d
    mov al, byte ptr ds:[di + 01Dh]
; @0019D module:019D original=88451c
    mov byte ptr ds:[di + 01Ch], al
; @001A0 module:01A0 original=32c0
    xor al, al
; @001A2 module:01A2 original=3a4516
    cmp al, byte ptr ds:[di + 016h]
; @001A5 module:01A5 original=7406
    JE_SHORT loc_001AD
; @001A7 module:01A7 original=fe4d16
    dec byte ptr ds:[di + 016h]
; @001AA module:01AA original=7401
    JE_SHORT loc_001AD
; @001AC module:01AC original=c3
    ret
; @001AD module:01AD original=3a4517
    cmp al, byte ptr ds:[di + 017h]
; @001B0 module:01B0 original=74fa
    JE_SHORT loc_001AC
; @001B2 module:01B2 original=fe4d17
    dec byte ptr ds:[di + 017h]
; @001B5 module:01B5 original=8a4514
    mov al, byte ptr ds:[di + 014h]
; @001B8 module:01B8 original=004505
    add byte ptr ds:[di + 5], al
; @001BB module:01BB original=e9a001
    JMP_NEAR loc_0035E
; @001BE 0000:01BE original=8a4507 runtime CFG evidence
    mov al, byte ptr ds:[di + 7]
; @001C1 0000:01C1 original=0cc0 runtime CFG evidence
    or al, 0C0h
; @001C3 0000:01C3 original=e83202 runtime CFG evidence
    CALL_NEAR loc_003F8
; @001C6 0000:01C6 original=8a07 runtime CFG evidence
    mov al, byte ptr ds:[bx]
; @001C8 0000:01C8 original=43 runtime CFG evidence
    inc bx
; @001C9 0000:01C9 original=e82c02 runtime CFG evidence
    CALL_NEAR loc_003F8
; @001CC 0000:01CC original=8a4507 runtime CFG evidence
    mov al, byte ptr ds:[di + 7]
; @001CF 0000:01CF original=0cb0 runtime CFG evidence
    or al, 0B0h
; @001D1 0000:01D1 original=e82402 runtime CFG evidence
    CALL_NEAR loc_003F8
; @001D4 0000:01D4 original=b007 runtime CFG evidence
    mov al, 7
; @001D6 0000:01D6 original=e81f02 runtime CFG evidence
    CALL_NEAR loc_003F8
; @001D9 0000:01D9 original=b064 runtime CFG evidence
    mov al, 064h
; @001DB 0000:01DB original=88450e runtime CFG evidence
    mov byte ptr ds:[di + 0Eh], al
; @001DE 0000:01DE original=e81702 runtime CFG evidence
    CALL_NEAR loc_003F8
; @001E1 0000:01E1 original=e9f3fe runtime CFG evidence
    JMP_NEAR loc_000D7
; @001E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,07h,0E8h,0Fh,02h,08Ah,07h,043h,088h,045h,0Eh,0E8h,06h,02h,0E9h,0E2h
; @001F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FEh,02Ah,02h,012h,01h,08h,01h,058h,01h,044h,02h,04Dh,02h,05Bh,02h,062h
; @00204 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0E4h,01h,070h,02h,081h,02h,091h,02h,09Ch,02h,0A5h,02h,0E1h,02h,069h
; @00214 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0BEh,01h,036h,01h,08Bh,01Fh,08Bh,0Fh,043h,043h,089h,05Dh,0Ah,089h,04Dh
; @00224 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,08Bh,0D9h,0E9h,0ADh,0FEh,0A0h,08h,00h,0A2h,060h,00h,08Bh,05Dh,0Ah,08Bh
; @00234 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Fh,043h,043h,0E3h,0E0h,089h,05Dh,0Ah,089h,04Dh,0Ch,08Bh,0D9h,0E9h,093h,0FEh
; @00244 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ah,07h,043h,088h,045h,012h,0E9h,08Ah,0FEh,0B4h,080h,0E8h,0B9h,01h,032h,0C0h
; @00254 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,045h,010h,088h,045h,01Eh,0C3h,0C6h,045h,013h,01h,0E9h,075h,0FEh,0C6h,045h
; @00264 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 013h,0FFh,0E9h,06Eh,0FEh,0C6h,045h,013h,00h,0E9h,067h,0FEh,08Bh,07h,089h,045h
; @00274 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,043h,043h,08Bh,07h,089h,045h,016h,043h,043h,0E9h,056h,0FEh,08Bh,07h,089h
; @00284 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,018h,043h,043h,08Ah,07h,088h,045h,01Ah,043h,0E9h,046h,0FEh,032h,0C0h,088h
; @00294 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,01Ah,088h,045h,018h,0E9h,03Bh,0FEh,08Ah,07h,043h,088h,045h,01Dh,0E9h,032h
; @002A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FEh,08Ah,065h,07h,08Ah,0C4h,04h,0B0h,0E8h,049h,01h,0B0h,064h,0E8h,044h,01h
; @002B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0C0h,0E8h,03Fh,01h,08Ah,0C4h,08Ah,0C4h,04h,0B0h,0E8h,036h,01h,0B0h,065h
; @002C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,031h,01h,032h,0C0h,0E8h,02Ch,01h,08Ah,0C4h,04h,0B0h,0E8h,025h,01h,0B0h
; @002D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0E8h,020h,01h,08Ah,07h,0E8h,01Bh,01h,043h,0E9h,0F6h,0FDh,08Bh,01Fh,0A0h
; @002E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,0A2h,060h,00h,0E9h,0EBh,0FDh
; @002EC module:02EC original=32e4
    xor ah, ah
; @002EE module:02EE original=3a260900
    cmp ah, byte ptr ds:[9]
; @002F2 module:02F2 original=7506
    JNE_SHORT loc_002FA
; @002F4 module:02F4 original=a00800
    mov al, byte ptr ds:[8]
; @002F7 module:02F7 original=a26000
    mov byte ptr ds:[060h], al
; @002FA module:02FA original=a06000
    mov al, byte ptr ds:[060h]
; @002FD module:02FD original=0ac0
    or al, al
; @002FF module:02FF original=745c
    JE_SHORT loc_0035D
; @00301 module:0301 original=88260800
    mov byte ptr ds:[8], ah
; @00305 module:0305 original=88266000
    mov byte ptr ds:[060h], ah
; @00309 module:0309 original=50
    push ax
; @0030A module:030A original=e84bfe
    CALL_NEAR loc_00158
; @0030D module:030D original=58
    pop ax
; @0030E module:030E original=3c0b
    cmp al, 0Bh
; @00310 module:0310 original=734b
    JAE_SHORT loc_0035D
; @00312 module:0312 original=a20900
    mov byte ptr ds:[9], al
; @00315 module:0315 original=d0e0
    shl al, 1
; @00317 module:0317 original=be3e05
    mov si, 053Eh
; @0031A module:031A original=03f0
    add si, ax
; @0031C module:031C original=ad
    lodsw
; @0031D module:031D original=8bf0
    mov si, ax
; @0031F module:031F original=ac
    lodsb
; @00320 module:0320 original=a20c00
    mov byte ptr ds:[0Ch], al
; @00323 module:0323 original=ac
    lodsb
; @00324 module:0324 original=8ac8
    mov cl, al
; @00326 module:0326 original=32ed
    xor ch, ch
; @00328 module:0328 original=890e6100
    mov word ptr ds:[061h], cx
; @0032C module:032C original=baff01
    mov dx, 01FFh
; @0032F module:032F original=88360d00
    mov byte ptr ds:[0Dh], dh
; @00333 module:0333 original=bf4804
    mov di, 0448h
; @00336 module:0336 original=ad
    lodsw
; @00337 module:0337 original=8bd8
    mov bx, ax
; @00339 module:0339 original=8b07
    mov ax, word ptr ds:[bx]
; @0033B module:033B original=43
    inc bx
; @0033C module:033C original=43
    inc bx
; @0033D module:033D original=895d0a
    mov word ptr ds:[di + 0Ah], bx
; @00340 module:0340 original=89450c
    mov word ptr ds:[di + 0Ch], ax
; @00343 module:0343 original=886d12
    mov byte ptr ds:[di + 012h], ch
; @00346 module:0346 original=886d13
    mov byte ptr ds:[di + 013h], ch
; @00349 module:0349 original=886d17
    mov byte ptr ds:[di + 017h], ch
; @0034C module:034C original=886d1a
    mov byte ptr ds:[di + 01Ah], ch
; @0034F module:034F original=886d18
    mov byte ptr ds:[di + 018h], ch
; @00352 module:0352 original=887501
    mov byte ptr ds:[di + 1], dh
; @00355 module:0355 original=887510
    mov byte ptr ds:[di + 010h], dh
; @00358 module:0358 original=83c71f
    add di, 01Fh
; @0035B module:035B original=e2d9
    LOOP_SHORT loc_00336
; @0035D module:035D original=c3
    ret
; @0035E module:035E original=8a4507
    mov al, byte ptr ds:[di + 7]
; @00361 module:0361 original=0ce0
    or al, 0E0h
; @00363 module:0363 original=e89200
    CALL_NEAR loc_003F8
; @00366 module:0366 original=32c0
    xor al, al
; @00368 module:0368 original=e88d00
    CALL_NEAR loc_003F8
; @0036B module:036B original=8a4505
    mov al, byte ptr ds:[di + 5]
; @0036E module:036E original=247f
    and al, 07Fh
; @00370 module:0370 original=e88500
    CALL_NEAR loc_003F8
; @00373 module:0373 original=c3
    ret
; @00374 module:0374 original=1e
    push ds
; @00375 module:0375 original=0e
    push cs
; @00376 module:0376 original=1f
    pop ds
; @00377 module:0377 original=51
    push cx
; @00378 module:0378 original=52
    push dx
; @00379 module:0379 original=b91b00
    mov cx, 01Bh
; @0037C module:037C original=e84500
    CALL_NEAR loc_003C4
; @0037F module:037F original=3cfe
    cmp al, 0FEh
; @00381 module:0381 original=7408
    JE_SHORT loc_0038B
; @00383 module:0383 original=e2f7
    LOOP_SHORT loc_0037C
; @00385 module:0385 original=5a
    pop dx
; @00386 module:0386 original=59
    pop cx
; @00387 module:0387 original=1f
    pop ds
; @00388 module:0388 original=32c0
    xor al, al
; @0038A module:038A original=c3
    ret
; @0038B module:038B original=b0ff
    mov al, 0FFh
; @0038D module:038D original=e84f00
    CALL_NEAR loc_003DF
; @00390 module:0390 original=e82100
    CALL_NEAR loc_003B4
; @00393 module:0393 original=b03f
    mov al, 03Fh
; @00395 module:0395 original=e84700
    CALL_NEAR loc_003DF
; @00398 module:0398 original=56
    push si
; @00399 module:0399 original=e81800
    CALL_NEAR loc_003B4
; @0039C module:039C original=beee34
    mov si, 034EEh
; @0039F module:039F original=ad
    lodsw
; @003A0 module:03A0 original=0bc0
    or ax, ax
; @003A2 module:03A2 original=7409
    JE_SHORT loc_003AD
; @003A4 module:03A4 original=56
    push si
; @003A5 module:03A5 original=8bf0
    mov si, ax
; @003A7 module:03A7 original=e87a00
    CALL_NEAR loc_00424
; @003AA module:03AA original=5e
    pop si
; @003AB module:03AB original=ebf2
    JMP_SHORT loc_0039F
; @003AD module:03AD original=5e
    pop si
; @003AE module:03AE original=5a
    pop dx
; @003AF module:03AF original=59
    pop cx
; @003B0 module:03B0 original=1f
    pop ds
; @003B1 module:03B1 original=b001
    mov al, 1
; @003B3 module:03B3 original=c3
    ret
; @003B4 module:03B4 original=50
    push ax
; @003B5 module:03B5 original=51
    push cx
; @003B6 module:03B6 original=52
    push dx
; @003B7 module:03B7 original=b96400
    mov cx, 064h
; @003BA module:03BA original=ba3003
    mov dx, 0330h
; @003BD module:03BD original=ec
    in al, dx
; @003BE module:03BE original=e2fd
    LOOP_SHORT loc_003BD
; @003C0 module:03C0 original=5a
    pop dx
; @003C1 module:03C1 original=59
    pop cx
; @003C2 module:03C2 original=58
    pop ax
; @003C3 module:03C3 original=c3
    ret
; @003C4 module:03C4 original=51
    push cx
; @003C5 module:03C5 original=ba3103
    mov dx, 0331h
; @003C8 module:03C8 original=b9ffff
    mov cx, 0FFFFh
; @003CB module:03CB original=ec
    in al, dx
; @003CC module:03CC original=a840
    test al, 040h
; @003CE module:03CE original=e0fb
    LOOPNE_SHORT loc_003CB
; @003D0 module:03D0 original=b0ff
    mov al, 0FFh
; @003D2 module:03D2 original=ee
    out dx, al
; @003D3 module:03D3 original=b9ffff
    mov cx, 0FFFFh
; @003D6 module:03D6 original=ec
    in al, dx
; @003D7 module:03D7 original=a880
    test al, 080h
; @003D9 module:03D9 original=e0fb
    LOOPNE_SHORT loc_003D6
; @003DB module:03DB original=4a
    dec dx
; @003DC module:03DC original=ec
    in al, dx
; @003DD module:03DD original=59
    pop cx
; @003DE module:03DE original=c3
    ret
; @003DF module:03DF original=50
    push ax
; @003E0 module:03E0 original=52
    push dx
; @003E1 module:03E1 original=ba3103
    mov dx, 0331h
; @003E4 module:03E4 original=8ae0
    mov ah, al
; @003E6 module:03E6 original=ec
    in al, dx
; @003E7 module:03E7 original=02c0
    add al, al
; @003E9 module:03E9 original=78fb
    JS_SHORT loc_003E6
; @003EB module:03EB original=8ac4
    mov al, ah
; @003ED module:03ED original=ee
    out dx, al
; @003EE module:03EE original=ec
    in al, dx
; @003EF module:03EF original=0ac0
    or al, al
; @003F1 module:03F1 original=78fb
    JS_SHORT loc_003EE
; @003F3 module:03F3 original=4a
    dec dx
; @003F4 module:03F4 original=ec
    in al, dx
; @003F5 module:03F5 original=5a
    pop dx
; @003F6 module:03F6 original=58
    pop ax
; @003F7 module:03F7 original=c3
    ret
; @003F8 module:03F8 original=50
    push ax
; @003F9 module:03F9 original=52
    push dx
; @003FA module:03FA original=ba3103
    mov dx, 0331h
; @003FD module:03FD original=8ae0
    mov ah, al
; @003FF module:03FF original=ec
    in al, dx
; @00400 module:0400 original=02c0
    add al, al
; @00402 module:0402 original=78fb
    JS_SHORT loc_003FF
; @00404 module:0404 original=8ac4
    mov al, ah
; @00406 module:0406 original=4a
    dec dx
; @00407 module:0407 original=ee
    out dx, al
; @00408 module:0408 original=5a
    pop dx
; @00409 module:0409 original=58
    pop ax
; @0040A module:040A original=c3
    ret
; @0040B module:040B original=8a4507
    mov al, byte ptr ds:[di + 7]
; @0040E module:040E original=0ac4
    or al, ah
; @00410 module:0410 original=e8e5ff
    CALL_NEAR loc_003F8
; @00413 module:0413 original=8a05
    mov al, byte ptr ds:[di]
; @00415 module:0415 original=024512
    add al, byte ptr ds:[di + 012h]
; @00418 module:0418 original=0418
    add al, 018h
; @0041A module:041A original=e8dbff
    CALL_NEAR loc_003F8
; @0041D module:041D original=8a4506
    mov al, byte ptr ds:[di + 6]
; @00420 module:0420 original=e8d5ff
    CALL_NEAR loc_003F8
; @00423 module:0423 original=c3
    ret
; @00424 module:0424 original=50
    push ax
; @00425 module:0425 original=b0f0
    mov al, 0F0h
; @00427 module:0427 original=e8ceff
    CALL_NEAR loc_003F8
; @0042A module:042A original=b041
    mov al, 041h
; @0042C module:042C original=e8c9ff
    CALL_NEAR loc_003F8
; @0042F module:042F original=b010
    mov al, 010h
; @00431 module:0431 original=e8c4ff
    CALL_NEAR loc_003F8
; @00434 module:0434 original=b016
    mov al, 016h
; @00436 module:0436 original=e8bfff
    CALL_NEAR loc_003F8
; @00439 module:0439 original=b012
    mov al, 012h
; @0043B module:043B original=e8baff
    CALL_NEAR loc_003F8
; @0043E module:043E original=ac
    lodsb
; @0043F module:043F original=e8b6ff
    CALL_NEAR loc_003F8
; @00442 module:0442 original=3cf7
    cmp al, 0F7h
; @00444 module:0444 original=75f8
    JNE_SHORT loc_0043E
; @00446 module:0446 original=58
    pop ax
; @00447 module:0447 original=c3
    ret
; @00448 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,06Eh,00h,09h,0B0h,00h,00h,00h,00h,00h,00h,00h
; @00458 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h
; @00468 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,06Eh,00h,09h,0B1h,00h,00h,00h,00h,00h,00h,00h,00h
; @00478 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h
; @00488 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,060h,00h,01h,0B2h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00498 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h
; @004A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,060h,00h,02h,0B3h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h
; @004C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,060h,00h,03h,0B4h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h,00h
; @004E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 060h,00h,04h,0B5h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @004F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h,00h,060h
; @00508 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,05h,0B6h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00518 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,01h,01h,00h,00h,00h,00h,00h,00h,060h,00h
; @00528 UNKNOWN module bytes; code/data distinction not yet proven
    db 06h,0B7h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @00538 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,01h,01h,00h,054h,05h,070h,0Ah,0DEh,011h,0FAh,01Bh
; @00548 UNKNOWN module bytes; code/data distinction not yet proven
    db 059h,01Fh,079h,020h,049h,023h,027h,028h,044h,02Ah,0B0h,02Fh,05h,08h,066h,05h
; @00558 UNKNOWN module bytes; code/data distinction not yet proven
    db 078h,05h,0D8h,05h,08Ah,05h,0A2h,05h,0B4h,05h,0C6h,05h,0EAh,05h,0FCh,05h
; @00568 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FCh,05h,0FCh,05h,0FCh,05h,0FCh,05h,045h,06h,06Ah,06h,00h,00h,068h,05h
; @00578 UNKNOWN module bytes; code/data distinction not yet proven
    db 093h,06h,096h,06h,096h,06h,096h,06h,096h,06h,0A6h,06h,0B7h,06h,00h,00h
; @00588 UNKNOWN module bytes; code/data distinction not yet proven
    db 07Ah,05h,0C8h,06h,0CCh,06h,0CCh,06h,0CCh,06h,0FEh,06h,0C8h,06h,0CCh,06h
; @00598 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FEh,06h,060h,07h,092h,07h,00h,00h,08Eh,05h,0A2h,07h,0A2h,07h,0B0h,07h
; @005A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A6h,07h,0B0h,07h,0BAh,07h,0C3h,07h,00h,00h,0A4h,05h,0D5h,07h,0D5h,07h
; @005B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,07h,0D5h,07h,0E3h,07h,0EDh,07h,0F6h,07h,00h,00h,0B6h,05h,08h,08h
; @005C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,08h,033h,08h,08h,08h,033h,08h,0D8h,034h,06Ch,08h,00h,00h,0C8h,05h
; @005D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E4h,034h,07Eh,08h,0CFh,08h,0EEh,08h,0CFh,08h,05Bh,09h,070h,09h,00h,00h
; @005E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0DAh,05h,0E4h,034h,084h,09h,0D5h,09h,0E3h,09h,0D5h,09h,053h,0Ah,05Ch,0Ah
; @005F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,0ECh,05h,091h,078h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch
; @00608 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch
; @00618 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h
; @00628 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h
; @00638 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0Ch,0Eh
; @00648 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh
; @00658 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0E3h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @00668 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,080h,0E1h,0Ch,081h,0Ch,0E5h,0Eh,0E1h,0Ch,081h,0Ch,0E5h,0Eh,0E1h,0Ch
; @00678 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0E5h,0Eh,0E1h,0Ch,081h,0Ch,0E5h,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,081h
; @00688 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,081h,0Eh,0F5h,081h,0E1h,0Ch,0E5h,0Eh,080h,0E5h,091h,06Ch,012h,012h
; @00698 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,012h,012h
; @006A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h,081h,080h,0E5h
; @006B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,0F7h,081h,0E5h,012h,012h,012h,012h,080h
; @006C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 090h,01Ch,091h,078h,0E1h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h
; @006D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh
; @006E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh
; @006F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,0Bh,012h,017h,080h,0E1h,09h,09h,09h,09h,010h,015h,09h,09h,09h
; @00708 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h
; @00718 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h
; @00728 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h
; @00738 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,010h,015h,09h,09h,09h,09h,010h,015h,09h,09h,09h,09h,010h,015h,07h
; @00748 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,07h,07h,0Eh,013h,07h,07h,07h,07h,0Eh,013h,06h,06h,06h,06h,0Eh
; @00758 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,06h,06h,06h,06h,0Eh,012h,080h,0E1h,09h,09h,09h,09h,010h,015h,09h
; @00768 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,010h,015h,0Bh,0Bh,0Bh,0Bh,012h,017h,0Bh,0Bh,0Bh,0Bh,012h
; @00778 UNKNOWN module bytes; code/data distinction not yet proven
    db 017h,0Dh,0Dh,0Dh,0Dh,014h,019h,0Eh,0Eh,0Eh,0Eh,015h,01Ah,010h,010h,010h
; @00788 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,017h,01Ch,012h,012h,012h,012h,01Eh,082h,080h,0F7h,081h,081h,0E1h,017h,015h
; @00798 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,010h,012h,010h,0E3h,0Eh,0Bh,0FBh,081h,080h,090h,058h,091h,060h,0F7h,026h
; @007A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,02Ah,082h,026h,028h,02Ah,082h,080h,0F7h,025h,082h,026h,082h,025h,082h,02Bh
; @007B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,080h,0F7h,025h,026h,0EBh,028h,02Ah,02Dh,02Fh,080h,0F7h,081h,081h,090h,02Ch
; @007C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0FBh,081h,080h,090h,058h,091h
; @007D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 060h,0F7h,021h,023h,023h,082h,021h,023h,023h,082h,080h,0F7h,023h,082h,023h,082h
; @007E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,026h,026h,080h,0F7h,023h,023h,0EBh,025h,026h,028h,02Ah,080h,0F7h,081h
; @007F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 090h,02Bh,081h,0E1h,02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0FBh,081h,080h
; @00808 UNKNOWN module bytes; code/data distinction not yet proven
    db 090h,02Bh,0FDh,081h,0F3h,081h,081h,091h,060h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh
; @00818 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Dh,02Fh,032h,02Fh,032h,034h,0FDh,081h,0F3h,081h,081h,0E1h,023h,028h,02Ah
; @00828 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,034h,080h,0E1h,040h,03Eh,03Bh,03Eh
; @00838 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,039h,03Bh,039h,036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh
; @00848 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,02Dh,02Ah,028h,0F7h,026h,082h,0E1h,040h,03Eh,03Bh,03Eh,03Bh,039h,03Bh,039h
; @00858 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,039h,036h,02Fh,034h,032h,02Fh,032h,02Fh,02Dh,02Fh,02Dh,02Ah,02Dh,02Ah,028h
; @00868 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,02Bh,02Ah,080h,0F7h,081h,081h,090h,02Ch,0E1h,03Bh,039h,036h,034h,036h,034h
; @00878 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,032h,02Fh,0FBh,081h,080h,090h,02Ch,08Dh,03h,08Ch,01h,091h,078h,0E1h,039h
; @00888 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,032h,034h,02Fh,032h,0E7h,036h,0E1h,02Fh,032h,036h,034h,0F3h,039h,0E1h,036h
; @00898 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F7h,089h,0FDh,0FFh,02Dh
; @008A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,032h,0E1h,039h,036h,032h,034h,036h,034h,0E7h,032h,0E1h,02Fh,032h,036h,039h
; @008B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F3h,034h,0E1h,036h,034h,032h,036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah,028h,0F7h
; @008C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,0FDh,0FFh,02Dh,015h,032h,080h,090h,056h,0E8h,021h,023h,0E5h,025h,0E8h,021h
; @008D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,0E5h,025h,0E8h,023h,025h,0FDh,026h,0E8h,025h,026h,0E5h,028h,0E8h,025h,026h
; @008E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,028h,0F7h,02Bh,02Ah,080h,090h,02Ch,08Dh,03h,0E1h,039h,036h,02Fh,032h,034h
; @008F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0EBh,039h,0E1h,03Bh,039h,036h,0F1h,034h,0E1h,039h,036h,034h,036h,034h,032h
; @00908 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,02Fh,032h,02Fh,02Dh,0F7h,089h,0FDh,0FFh,02Dh,015h,032h,0E1h,034h,031h
; @00918 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,032h,031h,02Dh,034h,031h,02Fh,032h,031h,02Dh,036h,032h,02Fh,034h,032h,031h
; @00928 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,036h,032h,034h,032h,02Fh,089h,08h,00h,00h,08h,02Fh,034h,032h,02Fh,034h
; @00938 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,089h,08h,00h,00h,08h,02Fh,034h,032h,02Fh,034h,032h,089h,08h,00h,00h
; @00948 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,03Bh,039h,032h,02Fh,039h,032h,089h,08h,00h,00h,08h,03Bh,039h,032h,02Fh
; @00958 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,032h,080h,090h,056h,0E8h,021h,023h,0E5h,025h,0E8h,023h,025h,0E5h,026h,025h
; @00968 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,02Ah,028h,02Dh,02Ah,02Fh,080h,0F8h,081h,081h,090h,02Ch,091h,06Ch,0E1h
; @00978 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Dh,02Ah,028h,02Ah,028h,0E3h,026h,023h,0F9h,081h,080h,090h,02Ch,091h,04Ch
; @00988 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,08Dh,03h,0E1h,039h,036h,032h,034h,02Fh,032h,0E7h,036h,0E1h,02Fh,032h
; @00998 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,034h,0F3h,039h,0E1h,036h,034h,032h,036h,032h,02Fh,034h,02Fh,02Ah,02Fh,02Ah
; @009A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,0F7h,089h,0FDh,0FFh,02Dh,015h,032h,0E1h,039h,036h,032h,034h,036h,034h,0E7h
; @009B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E1h,02Fh,032h,036h,039h,0F3h,034h,0E1h,036h,034h,032h,036h,032h,02Fh,034h
; @009C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Ah,02Fh,02Ah,028h,0F5h,089h,0FDh,0FFh,02Dh,015h,032h,080h,090h,058h,091h
; @009D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 060h,0F7h,021h,082h,01Fh,082h,021h,082h,021h,021h,080h,090h,02Ch,091h,04Ch,0E1h
; @009E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,08Dh,03h,0E1h,039h,036h,02Fh,032h,034h,036h,0EBh,039h,0E1h,03Bh,039h,036h
; @009F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,034h,0E1h,039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,02Fh,02Dh,0F7h
; @00A08 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,0FDh,0FFh,02Dh,015h,032h,0E1h,034h,031h,02Fh,032h,031h,02Dh,034h,031h,02Fh
; @00A18 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,031h,02Dh,036h,032h,02Fh,034h,032h,031h,039h,036h,032h,034h,032h,02Fh,089h
; @00A28 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,00h,00h,08h,02Fh,034h,032h,02Fh,034h,032h,089h,08h,00h,00h,08h,02Fh
; @00A38 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,02Fh,034h,032h,089h,08h,00h,00h,08h,03Bh,039h,032h,02Fh,039h,032h
; @00A48 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,08h,00h,00h,08h,03Bh,039h,032h,02Fh,039h,080h,0F7h,021h,021h,0EBh,021h
; @00A58 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,025h,023h,080h,0F8h,081h,081h,090h,02Ch,091h,04Ch,0E1h,03Bh,039h,036h,034h
; @00A68 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,034h,0E3h,032h,02Fh,0F9h,081h,080h,06h,08h,082h,0Ah,092h,0Ah,0A6h,0Ah
; @00A78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B6h,0Ah,0C2h,0Ah,0CEh,0Ah,0DAh,0Ah,0E6h,0Ah,0F0h,0Ah,0B3h,0Bh,074h,0Ch
; @00A88 UNKNOWN module bytes; code/data distinction not yet proven
    db 074h,0Ch,074h,0Ch,074h,0Ch,00h,00h,082h,0Ah,0A6h,0Ch,0A6h,0Ch,0A6h,0Ch
; @00A98 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A6h,0Ch,0Ah,0Dh,0Ah,0Dh,0Ah,0Dh,0Ah,0Dh,00h,00h,092h,0Ah,03Ch,0Dh
; @00AA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0ECh,0Dh,09Bh,0Eh,09Bh,0Eh,09Bh,0Eh,09Bh,0Eh,00h,00h,0A6h,0Ah,0CDh,0Eh
; @00AB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EEh,0Eh,013h,0Fh,013h,0Fh,00h,00h,0B6h,0Ah,01Dh,0Fh,03Eh,0Fh,063h,0Fh
; @00AC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 063h,0Fh,00h,00h,0C2h,0Ah,06Dh,0Fh,08Eh,0Fh,0B3h,0Fh,0B3h,0Fh,00h,00h
; @00AD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0CEh,0Ah,0BDh,0Fh,0DEh,0Fh,03h,010h,03h,010h,00h,00h,0DAh,0Ah,0Dh,010h
; @00AE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 099h,010h,036h,011h,00h,00h,0E6h,0Ah,091h,078h,0E1h,0Ch,0Ch,081h,0Eh,081h
; @00AF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
; @00B08 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch
; @00B18 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h
; @00B28 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
; @00B38 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch
; @00B48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh,081h
; @00B58 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
; @00B68 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch
; @00B78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E7h,081h,0E1h,0Ch,0Eh,0Eh,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
; @00B88 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh
; @00B98 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,081h,0Ch,0Ch
; @00BA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0Ch,0Ch,081h,0Eh
; @00BB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch
; @00BC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
; @00BD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh
; @00BE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch
; @00BF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
; @00C08 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh
; @00C18 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch
; @00C28 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh
; @00C38 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,0E7h,081h,0E1h,0Ch,0Eh,0Eh,0Eh,0Eh,0Eh,0Ch,0Ch,081h,0Eh,081h
; @00C48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h,0Eh,081h,0Eh,0Ch,0Ch,081h
; @00C58 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0Eh,081h,081h,0Eh,081h,0Eh,081h,081h,0Eh,0Eh,081h,081h,0Eh
; @00C68 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0Ch,0Eh,0Ch
; @00C78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch
; @00C88 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,081h
; @00C98 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,0Ch,0Eh,081h,081h,0Ch,0Eh,0Ch,0Eh,0Eh,0Eh,080h,091h,06Ch
; @00CA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h
; @00CB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h
; @00CC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h
; @00CD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h
; @00CE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h
; @00CF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,016h,012h,016h,012h,012h,012h,016h,012h,016h,012h,012h,012h,016h,012h,016h
; @00D08 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,080h,0E1h,012h,012h,081h,012h,016h,012h,012h,012h,081h,012h,016h,012h,012h
; @00D18 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,081h,012h,016h,012h,012h,012h,081h,012h,016h,012h,012h,012h,081h,012h,016h
; @00D28 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,081h,012h,016h,012h,012h,012h,081h,012h,016h,012h,012h,012h,081h
; @00D38 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,016h,012h,080h,090h,01Ch,091h,078h,0E1h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
; @00D48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
; @00D58 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
; @00D68 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh,0Eh,09h,0Eh,013h,015h,0Eh
; @00D78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
; @00D88 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh
; @00D98 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh
; @00DA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h
; @00DB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,0E2h,015h,081h,0E1h,09h,081h,0E5h,015h,0FFh,081h,0E1h,0Eh,0Eh,0Bh,0Eh
; @00DC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh
; @00DD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Eh,012h,013h,015h,082h,081h,09h,081h,0E5h,015h,0F5h,081h,0E1h,09h,0Bh
; @00DE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Dh,0Eh,080h,0E1h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
; @00DF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh
; @00E08 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h
; @00E18 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,0Eh,013h,018h,01Ah,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h
; @00E28 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,0Eh,0Eh,09h,0Eh,013h,015h,0Eh,0Eh,09h,0Eh,013h,015h,013h,013h,0Eh
; @00E38 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h,013h,0Eh,013h,018h,01Ah,013h
; @00E48 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,0Eh,013h,018h,01Ah,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h
; @00E58 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0E2h,015h,081h
; @00E68 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,09h,081h,0E5h,015h,0FFh,081h,0E1h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh
; @00E78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h,0Eh,0Eh,0Bh,0Eh,012h,013h
; @00E88 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,015h,0E3h,012h,0E5h,013h,0E1h,015h,0E5h,017h,0E3h,01Ah,0E5h,01Ch,0E1h,01Eh
; @00E98 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,01Fh,080h,0E1h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h
; @00EA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,07h,013h,09h,015h,09h,015h
; @00EB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,015h,09h,015h,09h,015h,09h,015h,04h,010h,04h,010h,04h,010h,04h,010h
; @00EC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 04h,010h,04h,010h,080h,090h,058h,091h,030h,0F7h,02Dh,082h,02Fh,082h,02Dh,082h
; @00ED8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,082h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,0F7h,02Dh,082h,0E3h,02Bh
; @00EE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,081h,02Bh,0FFh,081h,080h,0F7h,02Dh,082h,02Fh,082h,02Dh,082h,02Fh,082h,02Dh
; @00EF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0E3h,02Bh,0E5h,081h,02Bh,0FFh,081h,0F7h,02Dh,082h,0E3h,02Bh,0E5h,081h,02Bh
; @00F08 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,081h,0E3h,02Bh,0E5h,081h,0E7h,02Bh,0E5h,081h,080h,0F7h,02Ah,082h,028h,026h
; @00F18 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,082h,028h,026h,080h,090h,058h,091h,030h,0F7h,02Ah,082h,02Bh,082h,02Ah,082h
; @00F28 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,082h,02Ah,082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h,02Ah,082h,0E3h,028h
; @00F38 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,081h,028h,0FFh,081h,080h,0F7h,02Ah,082h,02Bh,082h,02Ah,082h,02Bh,082h,02Ah
; @00F48 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0E3h,028h,0E5h,081h,028h,0FFh,081h,0F7h,02Ah,082h,0E3h,028h,0E5h,081h,028h
; @00F58 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,081h,0E3h,028h,0E5h,081h,0E7h,028h,0E5h,081h,080h,0F7h,026h,082h,024h,023h
; @00F68 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,082h,024h,023h,080h,090h,058h,091h,030h,0F7h,028h,082h,028h,082h,028h,082h
; @00F78 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,082h,026h,082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h,024h
; @00F88 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,081h,024h,0FFh,081h,080h,0F7h,028h,082h,028h,082h,028h,082h,028h,082h,026h
; @00F98 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0E3h,024h,0E5h,081h,024h,0FFh,081h,0F7h,026h,082h,0E3h,024h,0E5h,081h,024h
; @00FA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,081h,0E3h,024h,0E5h,081h,0E7h,024h,0E5h,081h,080h,0F7h,023h,082h,021h,01Fh
; @00FB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,021h,01Fh,080h,090h,058h,091h,030h,0F7h,026h,082h,024h,082h,026h,082h
; @00FC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,082h,023h,082h,0E3h,021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h
; @00FD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,081h,021h,0FFh,081h,080h,0F7h,026h,082h,024h,082h,026h,082h,024h,082h,023h
; @00FE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0E3h,021h,0E5h,081h,021h,0FFh,081h,0F7h,023h,082h,0E3h,021h,0E5h,081h,021h
; @00FF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,081h,0E3h,021h,0E5h,081h,0E7h,021h,0E5h,081h,080h,0F7h,01Fh,082h,01Dh,01Ch
; @01008 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Fh,082h,01Dh,01Ch,080h,090h,02Ch,091h,068h,0E9h,02Dh,0E1h,02Ah,0E3h,028h,0E5h
; @01018 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0F1h,026h,0E1h,028h,0E5h,02Ah,0E9h,02Fh,0FBh,02Dh,0E1h,02Fh,02Dh,02Bh,02Ah
; @01028 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,0EFh,02Dh,0E1h,028h,0E3h,02Ah,0F1h,026h,0E1h,028h,0E5h,02Ah,0E9h,02Fh,0F9h
; @01038 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E1h,02Fh,030h,032h,034h,036h,039h,02Ah,02Dh,02Fh,032h,081h,0EBh,034h,0E1h
; @01048 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,039h,036h,034h,036h,034h,032h,034h,032h,02Fh,032h,02Fh,032h,0E5h,032h,0E3h
; @01058 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,032h,082h,091h,040h,034h,032h,082h,091h,020h,034h,032h,082h,091h,010h,034h
; @01068 UNKNOWN module bytes; code/data distinction not yet proven
    db 091h,068h,0E1h,081h,02Ah,02Dh,02Fh,032h,081h,0EBh,032h,0E1h,032h,036h,034h,032h
; @01078 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,034h,0E8h,034h,0E2h,081h,0E1h,034h,039h,036h,032h,039h,036h,032h,039h,036h
; @01088 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,039h,036h,032h,039h,036h,034h,039h,036h,034h,039h,036h,034h,036h,039h,034h
; @01098 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0EBh,02Dh,0E3h,032h,0E1h,02Dh,0E3h,032h,0E7h,02Dh,0E1h,032h,034h,02Dh,032h
; @010A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,02Dh,032h,034h,02Dh,0E5h,032h,0E3h,034h,0E5h,036h,0E1h,037h,0E3h,036h,0F7h
; @010B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0E1h,036h,0E3h,037h,0E1h,039h,0E3h,037h,0E5h,036h,034h,0EDh,036h,0E1h,039h
; @010C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,036h,034h,036h,034h,0E5h,032h,0E3h,034h,0E5h,030h,0E1h,032h,0E5h,02Fh,0E3h
; @010D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,0E5h,02Dh,0E1h,02Fh,0E5h,02Bh,0E3h,02Dh,0E1h,02Ah,02Dh,032h,02Dh,034h,02Dh
; @010E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh,032h,02Dh,034h,02Dh
; @010F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,02Dh,034h,037h,036h,032h,036h,032h,036h,037h,036h,032h,036h,032h,036h,037h
; @01108 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,036h,037h,032h,036h,03Bh,039h,037h,036h,036h,034h,032h,02Fh,02Dh,0E3h,034h
; @01118 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,032h,0E1h,034h,036h,037h,036h,0E3h,034h,0EDh,032h,0E5h,028h,0E3h,02Ah,0E5h
; @01128 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,0E1h,02Dh,0E5h,02Fh,0E3h,032h,0E5h,034h,0E1h,036h,0EBh,037h,080h,0FFh,081h
; @01138 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0E1h,090h,02Bh,091h,010h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
; @01148 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,020h,03Bh,039h,03Bh,03Ch,03Bh
; @01158 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,030h,03Bh
; @01168 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh
; @01178 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,091h,040h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh
; @01188 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Ch,03Bh,039h,091h,050h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh
; @01198 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,060h,03Bh,039h,03Bh,03Ch,03Bh
; @011A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,091h,070h,03Bh
; @011B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Ch,03Bh,039h,03Bh,039h,03Bh,03Ch,03Bh,039h,039h,03Bh,039h,03Ch,03Bh
; @011C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,091h,07Eh,03Bh,039h,03Bh,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch,03Bh,039h,03Ch
; @011D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,039h,03Ch,03Bh,03Eh,080h,05h,08h,0F0h,011h,0Eh,012h,010h,012h,02Eh,012h
; @011E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 04Ch,012h,06Ah,012h,088h,012h,0A0h,012h,0B8h,012h,0B8h,012h,0B8h,012h,0FDh,012h
; @011F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B8h,012h,0B8h,012h,0B8h,012h,0FDh,012h,042h,013h,0B8h,012h,0B8h,012h,0FDh,012h
; @01208 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FDh,012h,00h,00h,0F2h,011h,085h,013h,093h,013h,093h,013h,093h,013h,0F9h,013h
; @01218 UNKNOWN module bytes; code/data distinction not yet proven
    db 093h,013h,093h,013h,093h,013h,0F9h,013h,057h,014h,0B9h,014h,0B9h,014h,01Bh,015h
; @01228 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F9h,013h,00h,00h,012h,012h,07Dh,015h,07Dh,015h,07Dh,015h,090h,015h,07Dh,015h
; @01238 UNKNOWN module bytes; code/data distinction not yet proven
    db 07Dh,015h,07Dh,015h,090h,015h,0CBh,015h,0F0h,015h,0F0h,015h,012h,016h,090h,015h
; @01248 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,030h,012h,053h,016h,053h,016h,053h,016h,066h,016h,053h,016h,053h,016h
; @01258 UNKNOWN module bytes; code/data distinction not yet proven
    db 053h,016h,066h,016h,0A1h,016h,0C6h,016h,0C6h,016h,0E8h,016h,066h,016h,00h,00h
; @01268 UNKNOWN module bytes; code/data distinction not yet proven
    db 04Eh,012h,029h,017h,029h,017h,029h,017h,03Ch,017h,029h,017h,029h,017h,029h,017h
; @01278 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,017h,077h,017h,09Ch,017h,09Ch,017h,0BEh,017h,03Ch,017h,00h,00h,06Ch,012h
; @01288 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E4h,034h,0FFh,017h,0B3h,018h,0E4h,034h,0FFh,017h,0B3h,018h,0DEh,018h,07h,019h
; @01298 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C0h,019h,0B3h,018h,00h,00h,08Ah,012h,0E4h,034h,0F6h,019h,0ACh,01Ah,0E4h,034h
; @012A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F6h,019h,0ACh,01Ah,0D5h,01Ah,041h,01Bh,010h,01Bh,0ACh,01Ah,00h,00h,0A2h,012h
; @012B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 091h,078h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @012C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @012D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @012E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @012F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,081h,0Eh,080h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh
; @01308 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh
; @01318 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,0Eh,081h,0Eh,0Eh,081h,0Eh,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
; @01328 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
; @01338 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,0E1h,0Eh,081h,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h
; @01348 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @01358 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @01368 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @01378 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0Eh,0Eh,0Eh,080h,091h,06Ch,0E5h
; @01388 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,08Eh,088h,013h,090h,01Ch,091h,078h,0E1h
; @01398 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h
; @013A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h
; @013B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch
; @013C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h
; @013D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,018h,0Eh,015h,0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h
; @013E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,013h,015h,0Ch,0Eh,015h,0Eh,013h,015h,018h,0Eh,015h,0Eh,013h,015h,0Ch
; @013F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0E1h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
; @01408 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h
; @01418 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
; @01428 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,011h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h
; @01438 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,015h,081h,015h,015h,081h,015h
; @01448 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,0EBh,015h,080h,0E1h
; @01458 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
; @01468 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
; @01478 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
; @01488 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
; @01498 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
; @014A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
; @014B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0E1h,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h
; @014C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh
; @014D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh,082h,0Eh,0Eh
; @014E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0Eh,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,010h,082h
; @014F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,010h,082h,010h,010h,082h,010h,010h,082h,010h,013h,082h,013h,013h,082h,013h
; @01508 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h,082h,013h,013h
; @01518 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,013h,080h,084h,0FBh,0E1h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h
; @01528 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h
; @01538 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h,011h,081h,011h
; @01548 UNKNOWN module bytes; code/data distinction not yet proven
    db 011h,081h,011h,011h,081h,011h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h
; @01558 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,015h,081h
; @01568 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h,015h,081h,015h
; @01578 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,015h,084h,00h,080h,090h,058h,091h,04Ah,0F7h,032h,082h,035h,0EBh,037h,039h
; @01588 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,032h,082h,035h,0EBh,037h,039h,080h,0EBh,030h,0E1h,030h,081h,030h,081h,081h
; @01598 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,030h,0E1h,030h,081h,030h,081h,081h
; @015A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,030h,0E1h,030h,081h,030h,081h,081h,0EDh,032h,0E1h,032h,081h,032h,081h,081h
; @015B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,032h,0E1h,032h,081h,032h,081h,081h,0EDh,034h,0E1h,034h,081h,034h,081h,081h
; @015C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F9h,034h,080h,0FFh,02Dh,0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0FFh,02Dh
; @015D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,02Dh,081h,081h,02Dh,081h,081h,02Dh,0FFh,02Dh,0E1h,081h,02Dh,081h,081h
; @015E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,081h,081h,02Dh,0F7h,02Dh,082h,080h,0FEh,032h,0E1h,081h,034h,081h,081h,034h
; @015F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,081h,0E2h,034h,0F7h,035h,037h,0FEh,034h,0E1h,081h,034h,081h,081h,034h,0E3h
; @01608 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E2h,034h,0F7h,037h,0F6h,082h,0E0h,081h,080h,084h,07h,0EBh,024h,0E1h,024h
; @01618 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
; @01628 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,026h,0E1h,026h
; @01638 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,026h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,028h,0E1h,028h
; @01648 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,028h,081h,081h,0F8h,028h,0E0h,081h,084h,00h,080h,090h,058h,091h,04Ah,0F7h
; @01658 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,082h,030h,0EBh,032h,034h,0F7h,02Dh,082h,030h,0EBh,032h,034h,080h,0EBh,029h
; @01668 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,029h
; @01678 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,029h,081h,029h,081h,081h,0EDh,029h,0E1h,029h,081h,029h,081h,081h,0EDh,02Bh
; @01688 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Bh,081h,02Bh,081h,081h,0EDh,02Bh,0E1h,02Bh,081h,02Bh,081h,081h,0EDh,02Dh
; @01698 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Dh,081h,02Dh,081h,081h,0F9h,02Dh,080h,0FFh,032h,0E1h,081h,032h,081h,081h
; @016A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,081h,081h,032h,0FFh,032h,0E1h,081h,032h,081h,081h,032h,081h,081h,032h,0FFh
; @016B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E1h,081h,032h,081h,081h,032h,081h,081h,032h,0F7h,032h,082h,080h,0FEh,02Dh
; @016C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,02Dh,081h,081h,02Dh,0E3h,081h,0E2h,02Dh,0F7h,030h,032h,0FEh,02Dh,0E1h
; @016D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,02Dh,081h,081h,02Dh,0E3h,081h,0E2h,02Dh,0F7h,032h,0F6h,082h,0E0h,081h,080h
; @016E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 084h,07h,0EBh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh
; @016F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh,081h,081h,0EDh,01Dh,0E1h,01Dh,081h,01Dh
; @01708 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0EDh,01Fh,0E1h,01Fh,081h,01Fh,081h,081h,0EDh,01Fh,0E1h,01Fh,081h,01Fh
; @01718 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0EDh,021h,0E1h,021h,081h,021h,081h,081h,0F8h,021h,0E0h,081h,084h,00h
; @01728 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,090h,058h,091h,04Ah,0F7h,026h,082h,029h,0EBh,02Bh,02Dh,0F7h,026h,082h,029h
; @01738 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,02Bh,02Dh,080h,0EBh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
; @01748 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,024h,081h,081h,0EDh,024h,0E1h,024h,081h,024h,081h,081h,0EDh,024h,0E1h,024h
; @01758 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,024h,081h,081h,0EDh,026h,0E1h,026h,081h,026h,081h,081h,0EDh,026h,0E1h,026h
; @01768 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,026h,081h,081h,0EDh,028h,0E1h,028h,081h,028h,081h,081h,0F9h,028h,080h,0FFh
; @01778 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h,0FFh,021h,0E1h,081h,021h,081h
; @01788 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,021h,081h,081h,021h,0FFh,021h,0E1h,081h,021h,081h,081h,021h,081h,081h,021h
; @01798 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,021h,082h,080h,0FEh,026h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h
; @017A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,029h,02Bh,0FEh,028h,0E1h,081h,028h,081h,081h,028h,0E3h,081h,0E2h,028h,0F7h
; @017B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,0F6h,082h,0E0h,081h,080h,084h,07h,0EBh,018h,0E1h,018h,081h,018h,081h,081h
; @017C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,018h,0E1h,018h,081h,018h,081h,081h
; @017D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,018h,0E1h,018h,081h,018h,081h,081h,0EDh,01Ah,0E1h,01Ah,081h,01Ah,081h,081h
; @017E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,01Ah,0E1h,01Ah,081h,01Ah,081h,081h,0EDh,01Ch,0E1h,01Ch,081h,01Ch,081h,081h
; @017F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F8h,01Ch,0E0h,081h,084h,00h,080h,090h,02Ch,091h,07Fh,08Dh,02h,08Ch,01h,089h
; @01808 UNKNOWN module bytes; code/data distinction not yet proven
    db 04h,00h,04h,010h,0E5h,03Ch,0E2h,081h,089h,04h,00h,04h,010h,03Ch,082h,081h
; @01818 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,03Ch,082h,081h
; @01828 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,04h,00h,04h,010h,0E5h,03Ch,089h,0FCh,0FFh,04h,010h,082h,0F7h,039h,0E1h
; @01838 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,039h,037h,035h,034h,0EDh,032h,0E8h,037h,03Eh,03Ch,037h,0E5h,089h,0F9h,0FFh
; @01848 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,09h,03Eh,039h,089h,04h,00h,030h,010h,0F7h,037h,082h,0E3h,032h,0E1h,037h
; @01858 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,082h,032h,037h,039h,032h,037h,039h,032h,035h,082h,037h,039h,082h,032h,037h
; @01868 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,032h,037h,039h,032h,037h,082h,039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h
; @01878 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,08Dh,05h,089h,02h,00h,024h,020h,0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h
; @01888 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h
; @01898 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,039h,032h,03Ch,035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Eh
; @018A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,032h,03Eh,037h,032h,040h,039h,034h,0E5h,040h,080h,0E3h,029h,0E1h,02Bh,0E3h
; @018B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,0E1h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh
; @018C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,02Bh,0E1h,02Dh,0E3h,02Eh,0E1h,030h,02Eh,030h,032h,0F5h,035h,0E1h,081h,032h
; @018D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,02Dh,0F7h,031h,034h,080h,090h,058h,091h,02Ch,0FFh,026h,0E1h,081h,026h,081h
; @018E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,026h,081h,081h,026h,0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h,081h,026h
; @018F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FFh,026h,0E1h,081h,026h,081h,081h,026h,081h,081h,026h,0F7h,026h,082h,080h,090h
; @01908 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,084h,00h,08Dh,02h,091h,078h,089h,04h,00h,04h,010h,0E5h,03Ch,0E2h,081h
; @01918 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,0FDh,03Ch,0E1h
; @01928 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,03Ah,0E0h,039h,037h,0F7h,035h,0E1h,032h,032h,034h,034h,081h,037h,037h,081h
; @01938 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,089h,03h,00h,07h,015h,0E8h,037h,089h,03h,00h,07h,015h,0E8h,037h,034h
; @01948 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0E5h,081h,0E2h,034h,0E0h,081h,089h,0FDh,0FFh,05h,015h,0EBh,039h,091h,060h
; @01958 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,0FDh,0FFh,05h,015h,039h,091h,040h,089h,0FDh,0FFh,05h,015h,039h,091h,020h
; @01968 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,0FDh,0FFh,05h,015h,0EDh,039h,090h,02Bh,091h,06Eh,0E1h,026h,02Dh,0E5h,032h
; @01978 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,032h,0E1h,032h,0E1h,028h,02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h
; @01988 UNKNOWN module bytes; code/data distinction not yet proven
    db 029h,02Dh,035h,035h,03Ch,082h,029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h
; @01998 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,082h,02Bh,032h,082h,02Dh,034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h
; @019A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,034h,032h,02Fh,02Dh,02Bh,028h,040h,03Eh,03Bh,039h,037h,034h,0F7h,037h,090h
; @019B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,0EBh,03Eh,0EAh,043h,0E0h,081h,080h,090h,02Ch,084h,07h,091h,078h,0E3h,029h
; @019C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Bh,0E3h,02Ch,0E1h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch
; @019D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,02Eh,02Bh,0E3h,02Bh,0E1h,02Dh,0E3h,02Eh,0E1h,030h,02Eh,030h,032h,0F5h,035h
; @019E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,032h,030h,02Dh,0F7h,031h,0F6h,034h,0E0h,081h,084h,00h,080h,0E1h,081h
; @019F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 090h,02Ch,091h,04Ch,08Dh,02h,08Ch,01h,089h,04h,00h,04h,010h,0E5h,03Ch,0E2h
; @01A08 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,03Ch,082h
; @01A18 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,089h,04h,00h,04h,010h,03Ch,082h,081h,089h,04h,00h,04h,010h,0E5h,03Ch
; @01A28 UNKNOWN module bytes; code/data distinction not yet proven
    db 089h,0FCh,0FFh,04h,010h,082h,0F7h,039h,0E1h,037h,039h,037h,035h,034h,0EDh,032h
; @01A38 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,037h,03Eh,03Ch,037h,0E5h,089h,0F9h,0FFh,0Ch,09h,03Eh,039h,089h,04h,00h
; @01A48 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,010h,0F7h,037h,082h,0E3h,032h,0E1h,037h,039h,082h,032h,037h,039h,032h,037h
; @01A58 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,032h,035h,082h,037h,039h,082h,032h,037h,039h,032h,037h,039h,032h,037h,082h
; @01A68 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Ch,082h,037h,039h,03Ch,037h,039h,0E3h,03Ch,08Dh,05h,089h,02h,00h,024h
; @01A78 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,0F7h,039h,0E1h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h
; @01A88 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Eh,039h,032h,03Ch,035h,032h,03Ch
; @01A98 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,032h,03Ch,035h,032h,03Ch,035h,032h,03Eh,037h,032h,03Eh,037h,032h,040h,039h
; @01AA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0E3h,040h,080h,0F7h,081h,081h,091h,06Ch,0E3h,029h,0E1h,02Bh,02Ch,082h,02Eh
; @01AB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h,02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Dh,0E1h
; @01AC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,0E3h,030h,0E1h,032h,030h,032h,034h,0F1h,037h,0EBh,039h,080h,0F7h,081h,081h
; @01AD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,090h,02Bh,091h,040h,0E1h,023h,028h,02Ah,02Dh,02Ah,02Dh,02Fh,02Dh,02Fh
; @01AE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,02Fh,032h,02Fh,034h,036h,039h,036h,039h,03Bh,039h,03Bh,03Eh,03Bh,03Eh,023h
; @01AF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,02Ah,02Dh,02Ah,02Dh,02Fh,02Dh,02Fh,032h,02Fh,032h,02Fh,034h,036h,039h,036h
; @01B08 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,039h,03Bh,03Eh,03Bh,03Eh,080h,0F7h,081h,081h,090h,02Ch,084h,07h,091h
; @01B18 UNKNOWN module bytes; code/data distinction not yet proven
    db 06Ch,0E3h,029h,0E1h,02Bh,02Ch,082h,02Eh,02Ch,02Eh,030h,0F5h,033h,0E1h,081h,030h
; @01B28 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Eh,02Ch,0F7h,02Eh,02Bh,0E3h,02Dh,0E1h,02Fh,0E3h,030h,0E1h,032h,030h,032h,034h
; @01B38 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,037h,0EAh,039h,0E0h,081h,084h,00h,080h,090h,02Ch,091h,04Ch,08Dh,02h,0E1h
; @01B48 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,089h,04h,00h,04h,010h,0E5h,03Ch,0E2h,081h,089h,04h,00h,04h,010h,03Ch
; @01B58 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,081h,089h,04h,00h,04h,010h,0FDh,03Ch,0E1h,03Ch,03Ah,0E0h,039h,037h,0F7h
; @01B68 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,0E1h,032h,032h,034h,034h,081h,037h,037h,081h,081h,089h,03h,00h,07h,015h
; @01B78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,037h,089h,03h,00h,07h,015h,0E8h,037h,034h,037h,0E5h,081h,0E2h,034h,0E0h
; @01B88 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,089h,0FDh,0FFh,05h,015h,0EBh,039h,091h,030h,089h,0FDh,0FFh,05h,015h,039h
; @01B98 UNKNOWN module bytes; code/data distinction not yet proven
    db 091h,020h,089h,0FDh,0FFh,05h,015h,039h,091h,010h,089h,0FDh,0FFh,05h,015h,0EDh
; @01BA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,090h,02Bh,091h,046h,0E1h,026h,02Dh,0E5h,032h,032h,032h,0E1h,032h,0E1h,028h
; @01BB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E5h,034h,034h,034h,0E1h,034h,029h,02Dh,035h,029h,02Dh,035h,035h,03Ch,082h
; @01BC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 029h,030h,082h,02Bh,032h,037h,02Bh,032h,037h,037h,03Eh,082h,02Bh,032h,082h,02Dh
; @01BD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,039h,02Dh,034h,039h,034h,039h,034h,02Dh,034h,02Dh,034h,032h,02Fh,02Dh,02Bh
; @01BE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,040h,03Eh,03Bh,039h,037h,034h,0F7h,037h,090h,02Ch,0EBh,03Eh,0E8h,043h,0E0h
; @01BF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,080h,05h,08h,0Ch,01Ch,014h,01Ch,016h,01Ch,020h,01Ch,028h,01Ch,030h,01Ch
; @01C08 UNKNOWN module bytes; code/data distinction not yet proven
    db 038h,01Ch,03Eh,01Ch,03Dh,01Dh,062h,01Dh,00h,00h,0Eh,01Ch,0A5h,01Dh,0BBh,01Dh
; @01C18 UNKNOWN module bytes; code/data distinction not yet proven
    db 0BFh,01Dh,0F1h,01Dh,00h,00h,018h,01Ch,044h,01Ch,067h,01Ch,00h,00h,022h,01Ch
; @01C28 UNKNOWN module bytes; code/data distinction not yet proven
    db 097h,01Ch,0BAh,01Ch,00h,00h,02Ah,01Ch,0EAh,01Ch,0Dh,01Dh,00h,00h,032h,01Ch
; @01C38 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,01Eh,00h,00h,038h,01Ch,0BBh,01Eh,00h,00h,03Eh,01Ch,090h,058h,091h,06Eh
; @01C48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,091h,06Eh
; @01C58 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,080h,091h
; @01C68 UNKNOWN module bytes; code/data distinction not yet proven
    db 06Eh,0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,091h
; @01C78 UNKNOWN module bytes; code/data distinction not yet proven
    db 06Eh,0E5h,028h,081h,02Bh,081h,028h,081h,091h,07Fh,0E2h,02Bh,081h,02Dh,081h,091h
; @01C88 UNKNOWN module bytes; code/data distinction not yet proven
    db 06Eh,0F7h,02Fh,082h,02Dh,0EBh,028h,091h,07Fh,0E2h,02Dh,081h,02Fh,081h,080h,090h
; @01C98 UNKNOWN module bytes; code/data distinction not yet proven
    db 058h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h,028h
; @01CA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h,028h
; @01CB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,080h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h
; @01CC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,081h,091h,06Eh,0E5h,023h,081h,028h,081h,023h,081h,091h,07Fh,0E2h,028h,081h
; @01CD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,081h,091h,06Eh,0F7h,02Dh,082h,028h,0EBh,024h,091h,07Fh,0E2h,028h,081h,02Bh
; @01CE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,080h,090h,058h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh,0E2h
; @01CF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,081h,026h,081h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh,0E2h
; @01D08 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,081h,026h,081h,080h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh
; @01D18 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,024h,081h,026h,081h,091h,06Eh,0E5h,021h,081h,024h,081h,021h,081h,091h,07Fh
; @01D28 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,024h,081h,026h,081h,091h,06Eh,0F7h,028h,082h,026h,0EBh,02Bh,091h,07Fh,0E2h
; @01D38 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,081h,028h,081h,080h,091h,078h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
; @01D48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh
; @01D58 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h
; @01D68 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @01D78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0Ch,0E1h,0Eh,081h,0Eh,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h
; @01D88 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0E5h,0Eh,0Ch,0Eh,0E3h,0Ch,0E1h
; @01D98 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E5h,0Eh,0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,091h,06Ch,0E5h
; @01DA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,081h
; @01DB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Eh,0A8h,01Dh,090h,01Ch,091h,068h,0E1h,015h,015h,015h,015h,015h,015h,018h,018h
; @01DC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,018h,018h,018h,015h,015h,015h,015h,015h,015h,018h,018h,018h,01Ah,081h,01Ah
; @01DD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,015h,015h,015h,015h,018h,018h,018h,018h,018h,018h,015h,015h,015h,015h
; @01DE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,015h,018h,018h,018h,01Ah,081h,01Ah,080h,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah
; @01DF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch,01Ch,01Ch,01Ah,01Ch,01Ch,01Ch,01Ch
; @01E08 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,01Ah,01Ah,01Ah,01Ah,01Ah,01Ah,018h,01Ah,01Ah,01Ah,01Ah,01Ah,018h,018h,018h
; @01E18 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,018h,018h,0E2h,013h,081h,01Ch,081h,080h,0F7h,081h,081h,081h,081h,090h,02Ch
; @01E28 UNKNOWN module bytes; code/data distinction not yet proven
    db 091h,07Fh,0E2h,040h,081h,091h,03Ch,040h,081h,091h,01Fh,040h,081h,091h,0Ah,040h
; @01E38 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FAh,081h,091h,07Fh,0E2h,043h,081h,091h,03Ch,043h,081h,091h,01Fh,043h,081h,091h
; @01E48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ah,043h,0FAh,081h,091h,07Fh,0E2h,040h,081h,091h,03Ch,040h,081h,091h,032h,040h
; @01E58 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,091h,028h,040h,081h,040h,081h,091h,01Eh,040h,081h,091h,014h,040h,081h,091h
; @01E68 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ah,040h,081h,091h,07Fh,03Eh,081h,091h,03Ch,03Eh,081h,091h,032h,03Eh,081h,091h
; @01E78 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,03Eh,081h,03Eh,081h,091h,01Eh,03Eh,081h,091h,014h,03Eh,081h,091h,0Ah,03Eh
; @01E88 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,091h,07Fh,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,091h,06Eh,0E1h
; @01E98 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh
; @01EA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F1h,03Eh,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0F7h,081h,081h
; @01EB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,080h,0F7h,081h,081h,081h,081h,0E0h,081h,090h,02Ch,088h,04Eh,0E2h,040h
; @01EC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,091h,03Ch,040h,081h,091h,01Fh,040h,081h,091h,0Ah,040h,0FAh,081h,091h,07Fh
; @01ED8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,043h,081h,091h,03Ch,043h,081h,091h,01Fh,043h,081h,091h,0Ah,043h,0FAh,081h
; @01EE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 091h,07Fh,0E2h,040h,081h,091h,03Ch,040h,081h,091h,032h,040h,081h,091h,028h,040h
; @01EF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,040h,081h,091h,01Eh,040h,081h,091h,014h,040h,081h,091h,0Ah,040h,081h,091h
; @01F08 UNKNOWN module bytes; code/data distinction not yet proven
    db 07Fh,03Eh,081h,091h,03Ch,03Eh,081h,091h,032h,03Eh,081h,091h,028h,03Eh,081h,03Eh
; @01F18 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,091h,01Eh,03Eh,081h,091h,014h,03Eh,081h,091h,0Ah,03Eh,081h,0F6h,081h,091h
; @01F28 UNKNOWN module bytes; code/data distinction not yet proven
    db 07Fh,0E1h,03Bh,039h,03Ch,03Bh,03Ch,03Eh,0F1h,040h,082h,0E1h,03Bh,039h,03Ch,03Bh
; @01F38 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,03Eh,0F1h,040h,082h,0E1h,02Fh,034h,037h,039h,0E3h,03Bh,0F1h,03Eh,082h,0E1h
; @01F48 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,034h,037h,039h,03Bh,081h,0E2h,032h,081h,02Fh,081h,0F7h,081h,081h,081h,081h
; @01F58 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,05h,07h,06Bh,01Fh,075h,01Fh,069h,01Fh,06Dh,01Fh,06Fh,01Fh,071h,01Fh,073h
; @01F68 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Fh,077h,01Fh,0B5h,01Fh,0CDh,01Fh,0E7h,01Fh,011h,020h,06Ah,020h,01h,020h,090h
; @01F78 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,091h,063h,0E1h,09h,0Eh,013h,0Eh,013h,015h,0Eh,013h,015h,018h,015h,01Ah
; @01F88 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Fh,018h,013h,015h,013h,0Eh,011h,016h,018h,01Bh,018h,01Dh,022h,01Bh,016h,018h
; @01F98 UNKNOWN module bytes; code/data distinction not yet proven
    db 016h,011h,0Eh,013h,015h,018h,015h,01Ah,01Fh,018h,013h,015h,013h,0Eh,013h,018h
; @01FA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ah,01Dh,01Ah,01Fh,024h,01Dh,018h,01Ah,018h,013h,08Eh,082h,01Fh,0E1h,091h,078h
; @01FB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Ch,0Eh,0Eh,0Ch,0Eh,0Ch,0Ch,0Eh,0Ch,0Ch,0Eh,0Eh,0Ch,0Eh
; @01FC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Ch,08Eh,0B5h,01Fh,0EBh,081h,090h,058h,091h,05Ch,0E5h,02Dh,02Bh,02Eh,02Dh
; @01FD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 030h,02Eh,02Dh,02Bh,02Dh,02Bh,02Eh,02Dh,032h,030h,02Eh,02Bh,08Eh,0D4h,01Fh,0EBh
; @01FE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,090h,058h,091h,05Ch,0E5h,021h,01Fh,022h,021h,024h,022h,021h,01Fh,021h,01Fh
; @01FF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 022h,021h,026h,024h,022h,01Fh,08Eh,0EEh,01Fh,091h,064h,0E5h,081h,081h,012h,012h
; @02008 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,012h,0E1h,016h,0E5h,012h,08Eh,06h,020h,090h,02Ch,091h,068h,0E1h,021h,026h
; @02018 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,026h,02Bh,02Dh,0FFh,081h,081h,081h,081h,081h,081h,0F1h,039h,0E1h,037h,032h
; @02028 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0F7h,03Ch,0F1h,039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h,039h,0E1h
; @02038 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,032h,039h,0F7h,03Ch,0F1h,039h,0E1h,037h,032h,037h,0E3h,039h,0F3h,037h,0F1h
; @02048 UNKNOWN module bytes; code/data distinction not yet proven
    db 040h,0E1h,03Eh,03Ch,039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,0F1h
; @02058 UNKNOWN module bytes; code/data distinction not yet proven
    db 040h,0E1h,03Eh,03Ch,039h,0F7h,035h,0F1h,040h,0E1h,03Eh,03Ch,039h,0F7h,037h,08Eh
; @02068 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,020h,0E1h,081h,090h,02Ch,091h,055h,021h,026h,02Bh,026h,02Bh,02Dh,08Eh,01Ch
; @02078 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,05h,08h,08Bh,020h,08Dh,020h,08Fh,020h,091h,020h,093h,020h,095h,020h,097h
; @02088 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,099h,020h,09Bh,020h,0D1h,020h,0DFh,020h,01Dh,021h,02Dh,021h,03Dh,021h,04Dh
; @02098 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,055h,022h,091h,07Fh,0E3h,0Ch,0Ch,081h,0Eh,081h,081h,0Ch,0Ch,081h,0Eh
; @020A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Ch,081h,081h,0Eh,081h,081h,0Ch,0Ch,081h,0Eh,081h,081h,0Ch,0Ch
; @020B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,081h,0Ch,0Ch,0Ch,0Eh,081h,081h,0Ch,081h,081h,0Eh,081h,081h
; @020C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Ch,081h,0Eh,081h,081h,08Eh,09Bh,020h,0E2h,091h,06Ch,012h,081h,012h,081h
; @020D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,081h,012h,081h,08Eh,0D4h,020h,090h,01Ch,091h,066h,0E1h,06h,0Ah,0Dh,06h
; @020E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah,0Dh,06h,0Ah
; @020F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,06h,0Ah,0Dh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh
; @02108 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,08h,0Dh,0Fh,0Ah,0Fh,011h,0Ah
; @02118 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,011h,08Eh,014h,021h,090h,058h,091h,05Ah,0F7h,027h,082h,029h,082h,02Bh,082h
; @02128 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,08Eh,026h,021h,090h,058h,091h,05Ah,0F7h,01Eh,082h,020h,082h,022h,082h
; @02138 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,08Eh,036h,021h,090h,058h,091h,05Ah,0F7h,023h,082h,025h,082h,027h,082h
; @02148 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,08Eh,046h,021h,090h,02Ch,091h,063h,084h,00h,0E1h,033h,081h,033h,031h
; @02158 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0EBh,033h,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h,035h,081h
; @02168 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,033h,081h,0EBh,035h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h
; @02178 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h
; @02188 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h
; @02198 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh
; @021A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h
; @021B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 05Ah,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h
; @021C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h
; @021D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,046h,037h,081h,037h
; @021E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h
; @021F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
; @02208 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,032h,037h,081h,037h,035h,081h,0EBh,037h
; @02218 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h
; @02228 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah
; @02238 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,033h,091h,01Eh,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h
; @02248 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,08Eh,03Dh,022h,090h,02Ch,091h
; @02258 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,084h,00h,0E1h,081h,033h,081h,033h,031h,081h,0EBh,033h,0E1h,081h,033h,081h
; @02268 UNKNOWN module bytes; code/data distinction not yet proven
    db 033h,031h,081h,0EBh,033h,0E1h,081h,035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h
; @02278 UNKNOWN module bytes; code/data distinction not yet proven
    db 035h,081h,035h,033h,081h,0EBh,035h,0E1h,081h,037h,081h,037h,035h,081h,0EBh,037h
; @02288 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h
; @02298 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah
; @022A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h
; @022B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,028h,037h,081h,037h,035h,081h,0EBh
; @022C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h
; @022D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h
; @022E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ah,037h,035h,033h,091h,01Eh,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h
; @022F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h
; @02308 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h
; @02318 UNKNOWN module bytes; code/data distinction not yet proven
    db 091h,014h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h,037h,081h,037h,035h,081h
; @02328 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,037h,0E1h,03Ah,037h,035h,033h,037h,081h,037h,035h,081h,0EBh,037h,0E1h,081h
; @02338 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,081h,037h,035h,081h,0E5h,037h,0E1h,03Ah,037h,035h,033h,091h,0Ah,08Eh,03Dh
; @02348 UNKNOWN module bytes; code/data distinction not yet proven
    db 022h,05h,08h,05Bh,023h,05Dh,023h,05Fh,023h,07Bh,023h,097h,023h,0B3h,023h,0CFh
; @02358 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,0E7h,023h,0FFh,023h,02Ch,024h,042h,024h,047h,024h,047h,024h,0A8h,024h,047h
; @02368 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,047h,024h,0A8h,024h,0D2h,034h,0A8h,024h,0D5h,034h,0A8h,024h,0CFh,034h,00h
; @02378 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,061h,023h,09h,025h,0Dh,025h,0Dh,025h,038h,025h,0Dh,025h,0Dh,025h,038h
; @02388 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,0D2h,034h,038h,025h,0D5h,034h,038h,025h,0CFh,034h,00h,00h,07Dh,023h,042h
; @02398 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,046h,025h,046h,025h,071h,025h,046h,025h,046h,025h,071h,025h,0D2h,034h,071h
; @023A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,0D5h,034h,071h,025h,0CFh,034h,00h,00h,099h,023h,07Bh,025h,07Fh,025h,07Fh
; @023B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,0AAh,025h,07Fh,025h,07Fh,025h,0AAh,025h,0D2h,034h,0AAh,025h,0D5h,034h,0AAh
; @023C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 025h,0CFh,034h,00h,00h,0B5h,023h,0E4h,034h,0B7h,025h,041h,026h,086h,026h,041h
; @023D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,0D2h,034h,041h,026h,0D5h,034h,041h,026h,0CFh,034h,00h,00h,0D1h,023h,0E4h
; @023E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0ECh,026h,078h,027h,0BFh,027h,078h,027h,0D2h,034h,078h,027h,0D5h,034h,078h
; @023F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 027h,0CFh,034h,00h,00h,0E9h,023h,091h,07Ch,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch
; @02408 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0E5h,0Ch,0Eh,0E3h,0Ch,0E1h,0Ch,0Eh,081h,081h,0E5h,0Ch,0Eh
; @02418 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,0Ch,0E1h,0Ch,0Eh,081h,081h,0E5h,0Ch,0Eh,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh
; @02428 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,08Eh,01h,024h,091h,07Fh,0E5h,012h,012h,012h,012h,012h,012h,012h,012h,012h
; @02438 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,081h,08Eh,02Fh,024h,090h,01Ch,091h,078h,0E1h,012h
; @02448 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h
; @02458 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h
; @02468 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,081h,010h,0Eh,0Eh,0Eh,0Eh,081h,0Eh,010h,010h,010h,010h,081h,010h,012h
; @02478 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,081h,012h,012h,012h,012h,015h,081h,015h,012h,012h,012h,012h,081h
; @02488 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,015h,081h,015h,010h,010h,010h,010h,081h,010h,010h,010h,010h
; @02498 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,081h,010h,0Eh,0Eh,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,081h,0Eh,080h
; @024A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh
; @024B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,08h,08h,08h,08h,081h,08h,08h,08h
; @024C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,0Bh,081h,0Bh,08h,08h,08h,08h,081h,08h,08h,08h,08h,08h,081h,08h
; @024D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Dh,0Dh,0Dh,0Dh,081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,0Dh,0Dh,0Dh,0Dh
; @024E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Dh,0Dh,0Dh,0Dh,010h,081h,010h,09h,09h,09h,09h,081h,09h,09h,09h
; @024F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,081h,09h,0Bh,0Bh,0Bh,0Bh,081h,0Bh,0Bh,0Bh,0Bh,0Bh,081h,0Bh
; @02508 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,090h,058h,091h,04Ch,0EEh,02Ah,0E2h,081h,028h,081h,0EEh,02Ah,0E2h,081h,028h
; @02518 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0F7h,028h,0E8h,026h,0E2h,081h,0E8h,028h,0E2h,081h,0EEh,02Ah,0E2h,081h,028h
; @02528 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0EEh,02Ah,0E2h,081h,028h,081h,0F7h,028h,0E8h,026h,0E2h,081h,0EBh,026h,080h
; @02538 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,025h,082h,020h,081h,025h,082h,082h,023h,080h,090h,058h,091h,04Ch,0EEh,02Dh
; @02548 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E2h,081h,02Dh,081h,0EEh,02Dh,0E2h,081h,02Dh,081h,0F7h,02Ch,0E8h,02Bh,0E2h,081h
; @02558 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,02Ch,0E2h,081h,0EEh,02Dh,0E2h,081h,02Dh,081h,0EEh,02Dh,0E2h,081h,02Dh,081h
; @02568 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,02Ch,0E8h,02Bh,0E2h,081h,0EBh,02Ah,080h,0F7h,081h,081h,023h,081h,081h,081h
; @02578 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,080h,090h,058h,091h,04Ch,0EEh,031h,0E2h,081h,031h,081h,0EEh,031h,0E2h
; @02588 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,031h,081h,0F7h,02Fh,0E8h,02Fh,0E2h,081h,0E8h,02Fh,0E2h,081h,0EEh,031h,0E2h
; @02598 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,031h,081h,0EEh,031h,0E2h,081h,031h,081h,0F7h,02Fh,0E8h,02Fh,0E2h,081h,0EBh
; @025A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,080h,0F7h,028h,082h,081h,0EBh,01Eh,020h,0F7h,028h,082h,021h,027h,080h,090h
; @025B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,091h,078h,08Dh,03h,08Ch,01h,089h,01h,00h,04h,040h,0F7h,036h,082h,0E1h
; @025C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,038h,036h,039h,038h,036h,038h,036h,034h,038h,036h,034h,0F7h,031h,0E5h,038h
; @025D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h,039h,0E1h,081h,02Ah,02Ch,02Dh,031h
; @025E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h,0EDh,02Ah,0E9h,081h,0E1h,02Fh,031h
; @025F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h
; @02608 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h,036h,0E3h,039h,0F7h,03Bh,0E1h,081h
; @02618 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h
; @02628 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h,045h,044h,042h,040h,042h,040h,03Dh
; @02638 UNKNOWN module bytes; code/data distinction not yet proven
    db 040h,03Dh,03Bh,039h,0F1h,036h,0E5h,081h,080h,090h,056h,0E1h,034h,036h,031h,034h
; @02648 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,034h,036h
; @02658 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,034h,036h,038h,0EFh,038h,0E7h,039h,0F4h,038h,0E2h,081h,0E1h,034h,036h,031h
; @02668 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,036h,038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,034h
; @02678 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,031h,034h,036h,038h,0EFh,039h,0E1h,038h,039h,082h,0F9h,03Bh,080h,090h,02Ch
; @02688 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E8h,038h,0FFh,031h,0E4h,081h,0E1h,036h,0E5h,039h,0E2h,031h,0ECh,034h,0E1h,02Ch
; @02698 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,02Dh,0E5h,02Ah,02Dh,0E7h,02Ah,0E5h,02Ch,0E9h,02Dh,0E1h,02Fh,0E3h,031h,0F9h
; @026A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Fh,0E1h,034h,0EDh,036h,0E1h,038h,0E3h,039h,0F9h,036h,0E5h,039h,03Dh,0EFh,045h
; @026B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,042h,0E3h,045h,0E5h,042h,0E7h,03Dh,0E3h,042h,0E1h,03Dh,0EFh,039h,0E1h,038h
; @026C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,038h,0F1h,036h,0E1h,034h,0E3h,038h,0E1h,039h,0E3h,038h,0E5h,034h,036h,031h
; @026D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F3h,034h,0E3h,02Ch,0E5h,034h,0E1h,02Ch,0E5h,034h,0E1h,02Ch,034h,0E5h,02Dh,0EDh
; @026E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E5h,081h,080h,0E1h,081h,090h,02Ch,091h,050h,08Dh,03h,08Ch,01h,089h,01h
; @026F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,04h,040h,0F7h,036h,082h,0E1h,039h,038h,036h,039h,038h,036h,038h,036h,034h
; @02708 UNKNOWN module bytes; code/data distinction not yet proven
    db 038h,036h,034h,0F7h,031h,0E5h,038h,0E3h,031h,0E5h,038h,0E1h,031h,0E3h,038h,0F5h
; @02718 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0E1h,081h,02Ah,02Ch,02Dh,031h,02Dh,02Ch,02Ah,02Ch,02Ah,02Ch,02Dh,02Ch,028h
; @02728 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EDh,02Ah,0E9h,081h,0E1h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh
; @02738 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,02Fh,031h,02Fh,02Dh,02Fh,031h,02Fh,031h,02Fh,02Dh,02Fh,031h,0EFh,038h,0E1h
; @02748 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,0E3h,039h,0F7h,03Bh,0E1h,081h,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh
; @02758 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,03Bh,03Dh,03Bh,039h,03Bh,03Dh,042h
; @02768 UNKNOWN module bytes; code/data distinction not yet proven
    db 045h,044h,042h,040h,042h,040h,03Dh,040h,03Dh,03Bh,039h,0F1h,036h,0E3h,081h,080h
; @02778 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E0h,081h,090h,056h,0E1h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h
; @02788 UNKNOWN module bytes; code/data distinction not yet proven
    db 038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,0EFh,038h,0E7h
; @02798 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,0F4h,038h,0E2h,081h,0E1h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h
; @027A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 036h,038h,034h,036h,031h,034h,036h,038h,034h,036h,031h,034h,036h,038h,0EFh,039h
; @027B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,038h,039h,082h,0F8h,03Bh,080h,0E1h,081h,090h,02Ch,0E8h,038h,0FFh,031h,0E4h
; @027C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E1h,036h,0E5h,039h,0E2h,031h,0ECh,034h,0E1h,02Ch,0E3h,02Dh,0E5h,02Ah,02Dh
; @027D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E7h,02Ah,0E5h,02Ch,0E9h,02Dh,0E1h,02Fh,0E3h,031h,0F9h,02Fh,0E1h,034h,0EDh,036h
; @027E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,038h,0E3h,039h,0F9h,036h,0E5h,039h,03Dh,0EFh,045h,0E1h,042h,0E3h,045h,0E5h
; @027F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 042h,0E7h,03Dh,0E3h,042h,0E1h,03Dh,0EFh,039h,0E1h,038h,039h,038h,0F1h,036h,0E1h
; @02808 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0E3h,038h,0E1h,039h,0E3h,038h,0E5h,034h,036h,031h,0F3h,034h,0E3h,02Ch,0E5h
; @02818 UNKNOWN module bytes; code/data distinction not yet proven
    db 034h,0E1h,02Ch,0E5h,034h,0E1h,02Ch,034h,0E5h,02Dh,0EDh,02Ah,0E3h,081h,080h,04h
; @02828 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,037h,028h,039h,028h,03Bh,028h,04Bh,028h,05Bh,028h,06Bh,028h,079h,028h,087h
; @02838 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,096h,028h,0A0h,028h,0A0h,028h,0A0h,028h,0A0h,028h,06h,029h,0A0h,028h,00h
; @02848 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,03Fh,028h,067h,029h,067h,029h,073h,029h,073h,029h,086h,029h,073h,029h,00h
; @02858 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,04Fh,028h,099h,029h,099h,029h,0A5h,029h,0A5h,029h,0BAh,029h,0A5h,029h,00h
; @02868 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,05Fh,028h,0CDh,029h,0CDh,029h,0D9h,029h,0D9h,029h,0E7h,029h,00h,00h,06Fh
; @02878 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,05h,02Ah,05h,02Ah,011h,02Ah,011h,02Ah,026h,02Ah,00h,00h,07Dh,028h,091h
; @02888 UNKNOWN module bytes; code/data distinction not yet proven
    db 07Ch,0E1h,0Ch,0Ch,081h,0Ch,081h,0Ch,0Eh,0E9h,081h,08Eh,089h,028h,091h,078h
; @02898 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,012h,012h,012h,012h,08Eh,099h,028h,090h,01Ch,091h,078h,0E1h,0Eh,081h,0Eh
; @028A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
; @028B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh
; @028C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,0Eh,081h,011h,081h,011h
; @028D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h
; @028E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h
; @028F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,011h,081h,080h,0Ch,081h
; @02908 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h
; @02918 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h
; @02928 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Ch,081h,0Fh,081h
; @02938 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h
; @02948 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h
; @02958 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,0Fh,081h,080h,090h
; @02968 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,091h,06Ah,0FFh,015h,082h,082h,018h,082h,082h,080h,0F7h,015h,0EBh,017h,018h
; @02978 UNKNOWN module bytes; code/data distinction not yet proven
    db 015h,082h,017h,018h,0F7h,015h,0EBh,017h,018h,015h,082h,017h,018h,080h,0F7h,013h
; @02988 UNKNOWN module bytes; code/data distinction not yet proven
    db 0EBh,017h,018h,013h,082h,017h,018h,0F7h,013h,0EBh,017h,018h,013h,082h,017h,018h
; @02998 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,090h,02Ch,091h,06Ah,0FFh,01Ah,082h,082h,01Dh,082h,082h,080h,091h,046h,0F7h
; @029A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,0EBh,023h,024h,021h,082h,023h,024h,0F7h,021h,0EBh,023h,024h,021h,082h,023h
; @029B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,080h,0F7h,01Fh,0EBh,023h,024h,01Fh,082h,023h,024h,0F7h,01Fh,0EBh,023h,024h
; @029C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Fh,082h,023h,024h,080h,090h,02Ch,091h,042h,0FFh,021h,082h,082h,024h,082h,082h
; @029D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,090h,056h,091h,05Ah,0F7h,03Ch,082h,082h,082h,03Ch,082h,039h,082h,080h,0F7h
; @029E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,082h,082h,082h,03Ah,082h,081h,081h,081h,081h,081h,081h,081h,0ECh,081h,0E0h
; @029F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 040h,081h,040h,0E8h,081h,0E0h,040h,081h,040h,0F5h,081h,081h,080h,090h,02Ch,091h
; @02A08 UNKNOWN module bytes; code/data distinction not yet proven
    db 042h,0FFh,026h,082h,082h,029h,082h,082h,080h,090h,056h,091h,05Ah,0F1h,03Ah,039h
; @02A18 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,082h,0E5h,081h,0F1h,03Ah,039h,0EBh,037h,0F7h,035h,082h,080h,0F7h,034h
; @02A28 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,082h,033h,082h,03Ch,03Fh,03Eh,082h,082h,082h,081h,0ECh,081h,0E0h,045h
; @02A38 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,045h,0E8h,081h,0E0h,045h,081h,045h,0F5h,081h,081h,080h,05h,08h,056h,02Ah
; @02A48 UNKNOWN module bytes; code/data distinction not yet proven
    db 064h,02Ah,076h,02Ah,08Ah,02Ah,09Ch,02Ah,0AEh,02Ah,0C0h,02Ah,0D0h,02Ah,0E0h,02Ah
; @02A58 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,02Ah,044h,02Bh,06h,02Ch,044h,02Bh,00h,00h,056h,02Ah,068h,02Ch,06Bh,02Ch
; @02A68 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Ch,02Ch,08Ch,02Ch,06Bh,02Ch,08Ch,02Ch,08Ch,02Ch,00h,00h,064h,02Ah,0ADh,02Ch
; @02A78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0B1h,02Ch,0Bh,02Dh,0Bh,02Dh,06Dh,02Dh,06Dh,02Dh,0Bh,02Dh,0Bh,02Dh,00h,00h
; @02A88 UNKNOWN module bytes; code/data distinction not yet proven
    db 076h,02Ah,09Eh,02Dh,0A2h,02Dh,0ACh,02Dh,0ACh,02Dh,0B6h,02Dh,0ACh,02Dh,0ACh,02Dh
; @02A98 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,08Ah,02Ah,0C0h,02Dh,0C4h,02Dh,0CEh,02Dh,0CEh,02Dh,0D8h,02Dh,0CEh,02Dh
; @02AA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0CEh,02Dh,00h,00h,09Ch,02Ah,0E2h,02Dh,0E6h,02Dh,0F0h,02Dh,0F0h,02Dh,0FAh,02Dh
; @02AB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F0h,02Dh,0F0h,02Dh,00h,00h,0AEh,02Ah,0E4h,034h,04h,02Eh,021h,02Eh,08Dh,02Eh
; @02AC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Dh,02Eh,0AFh,02Eh,00h,00h,0C0h,02Ah,0E4h,034h,027h,02Fh,046h,02Fh,08Dh,02Eh
; @02AD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 08Dh,02Eh,0AFh,02Eh,00h,00h,0D0h,02Ah,091h,078h,0E1h,0Ch,081h,0Ch,0Eh,081h
; @02AE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
; @02AF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
; @02B08 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Eh,0Eh,0Eh,0Eh,0Ch,081h,0Ch,0Eh,081h
; @02B18 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Eh
; @02B28 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,0Eh,0Eh
; @02B38 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h,0Ch,081h,0Ch
; @02B48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
; @02B58 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
; @02B68 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
; @02B78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
; @02B88 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
; @02B98 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
; @02BA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
; @02BB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
; @02BC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
; @02BD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch
; @02BE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
; @02BF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Eh,0Eh,0Ch,0Eh,0Eh,081h,080h,0E1h,0Ch
; @02C08 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
; @02C18 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
; @02C28 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Eh,0Eh,0Eh,0Eh,0Ch
; @02C38 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h
; @02C48 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch
; @02C58 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,081h,0Ch,081h,0Eh,0Eh,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h
; @02C68 UNKNOWN module bytes; code/data distinction not yet proven
    db 091h,078h,0E5h,019h,012h,012h,012h,012h,012h,012h,012h,019h,012h,012h,012h,012h
; @02C78 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,019h,012h,012h,012h,012h,012h,012h,012h,019h,012h,012h,012h,012h
; @02C88 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,080h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h
; @02C98 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h
; @02CA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,080h,090h,01Ch,091h,078h,0E1h,09h,082h,09h,09h,09h,09h
; @02CB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h
; @02CC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,0E1h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h
; @02CD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h,09h,09h,09h,09h,082h,09h,09h
; @02CE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h,09h,09h,09h,0E1h,09h,09h
; @02CF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,0E3h,09h
; @02D08 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,080h,0E1h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h
; @02D18 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h
; @02D28 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h,09h,013h
; @02D38 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,013h,09h,013h,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh
; @02D48 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Eh,09h,0Dh,09h,0Eh
; @02D58 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,010h,09h,0Dh,09h,0Eh,09h,010h,09h,0Dh,09h,0Eh,09h,010h,09h,0Dh
; @02D68 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,0Eh,09h,010h,080h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h
; @02D78 UNKNOWN module bytes; code/data distinction not yet proven
    db 09h,09h,082h,09h,09h,09h,09h,09h,082h,09h,09h,09h,09h,07h,082h,07h
; @02D88 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,07h,07h,07h,082h,07h,07h,07h,07h,09h,082h,09h,09h,09h,09h,09h
; @02D98 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,09h,09h,09h,09h,080h,090h,058h,091h,05Ah,0F7h,026h,082h,024h,082h,025h
; @02DA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,026h,025h,080h,0F7h,026h,082h,026h,082h,026h,082h,026h,025h,080h,0F7h,026h
; @02DB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,026h,028h,026h,026h,026h,028h,080h,090h,058h,091h,05Ah,0F7h,023h,082h,01Fh
; @02DC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,021h,082h,021h,021h,080h,0F7h,023h,082h,023h,082h,021h,082h,021h,021h,080h
; @02DD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,021h,023h,023h,025h,021h,023h,023h,025h,080h,090h,058h,091h,05Ah,0F7h,01Fh
; @02DE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,01Ch,082h,01Ch,082h,01Eh,01Ch,080h,0F7h,01Fh,082h,01Fh,082h,01Eh,082h,01Ch
; @02DF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,080h,0F7h,01Eh,01Eh,01Fh,021h,01Eh,01Eh,01Fh,021h,080h,090h,056h,091h,050h
; @02E08 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh,021h,0E9h,032h,0E7h,036h
; @02E18 UNKNOWN module bytes; code/data distinction not yet proven
    db 0FDh,02Dh,0E9h,026h,0E7h,028h,0FDh,025h,080h,090h,02Ch,091h,069h,0F7h,032h,0E1h
; @02E28 UNKNOWN module bytes; code/data distinction not yet proven
    db 039h,037h,036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h,02Dh,0EBh,031h
; @02E38 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0FBh,036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h,031h,02Dh,031h
; @02E48 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,031h,02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h,0E3h,032h,0F4h
; @02E58 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E2h,081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh,02Dh,02Fh,0F0h
; @02E68 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,0E2h,081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h,031h,032h,034h
; @02E78 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0F1h,036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh
; @02E88 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F4h,031h,0E2h,081h,080h,0E1h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h
; @02E98 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,02Dh,0F5h,036h,0E1h,081h,032h,039h,032h,02Dh,032h,039h,032h,02Dh,032h,039h
; @02EA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,036h,0F5h,039h,0E1h,081h,080h,0F1h,034h,0E3h,032h,0E5h,031h,02Fh,031h,0E7h
; @02EB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E5h,036h,0E3h,034h,0E5h,032h,031h,0F7h,02Dh,0E1h,032h,031h,02Fh,0F1h,02Dh
; @02EC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Bh,02Ah,028h,0EBh,026h,0E1h,028h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,02Fh,0E3h
; @02ED8 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,032h,034h,0F5h,031h,0E1h,037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E0h
; @02EE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0E1h,037h,03Bh,037h,032h,037h,03Bh,037h,0E8h,032h,0E2h,081h,0E1h,03Bh,039h
; @02EF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 037h,036h,034h,032h,037h,036h,034h,032h,034h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh
; @02F08 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,02Ah,028h,02Bh,02Ah,028h,0EFh,026h,0E1h,036h,032h,02Dh,032h,0EFh,036h,0E1h
; @02F18 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,02Dh,0E3h,032h,0E9h,034h,0E7h,032h,0E5h,031h,0F5h,02Dh,0E1h,081h,080h,090h
; @02F28 UNKNOWN module bytes; code/data distinction not yet proven
    db 056h,091h,03Ch,0E1h,081h,0E9h,026h,0E7h,02Ah,0FDh,021h,0E9h,024h,0E7h,028h,0FDh
; @02F38 UNKNOWN module bytes; code/data distinction not yet proven
    db 021h,0E9h,032h,0E7h,036h,0FDh,02Dh,0E9h,026h,0E7h,028h,0FBh,025h,080h,091h,06Eh
; @02F48 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,032h,0E1h,039h,037h,036h,037h,036h,034h,036h,034h,032h,034h,032h,031h,0F7h
; @02F58 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0EBh,031h,032h,0FBh,036h,0E1h,034h,0E3h,036h,0EBh,039h,0E1h,037h,031h,032h
; @02F68 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,02Dh,031h,032h,031h,02Dh,031h,032h,031h,02Dh,0F4h,028h,0E2h,081h,0F1h,034h
; @02F78 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,032h,0F4h,02Dh,0E2h,081h,0E1h,02Fh,031h,034h,0F0h,032h,0E0h,081h,0E1h,02Fh
; @02F88 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,02Fh,0F0h,02Ah,0E2h,081h,0E1h,025h,026h,028h,02Ah,02Bh,02Ah,0E9h,02Dh,0E1h
; @02F98 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,032h,034h,032h,0F1h,036h,0E1h,032h,034h,02Dh,032h,034h,02Dh,032h,034h,02Dh
; @02FA8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,034h,02Dh,0F4h,031h,0E2h,081h,080h,04h,08h,0C2h,02Fh,0EAh,02Fh,012h,030h
; @02FB8 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,030h,03Ah,030h,04Eh,030h,062h,030h,070h,030h,080h,030h,080h,030h,0A7h,030h
; @02FC8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h
; @02FD8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,0A7h,030h,00h,00h
; @02FE8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0C2h,02Fh,0D9h,030h,0D9h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h
; @02FF8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h,0E5h,030h
; @03008 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E5h,030h,0E5h,030h,0E5h,030h,00h,00h,0EAh,02Fh,0F7h,030h,0FBh,030h,01h,031h
; @03018 UNKNOWN module bytes; code/data distinction not yet proven
    db 01h,031h,063h,031h,01h,031h,01h,031h,063h,031h,00h,00h,012h,030h,025h,032h
; @03028 UNKNOWN module bytes; code/data distinction not yet proven
    db 029h,032h,02Fh,032h,02Fh,032h,039h,032h,02Fh,032h,02Fh,032h,039h,032h,00h,00h
; @03038 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,030h,04Bh,032h,04Fh,032h,055h,032h,055h,032h,05Fh,032h,055h,032h,055h,032h
; @03048 UNKNOWN module bytes; code/data distinction not yet proven
    db 05Fh,032h,00h,00h,03Ah,030h,071h,032h,075h,032h,07Bh,032h,07Bh,032h,085h,032h
; @03058 UNKNOWN module bytes; code/data distinction not yet proven
    db 07Bh,032h,07Bh,032h,085h,032h,00h,00h,04Eh,030h,097h,032h,0A5h,032h,0Eh,033h
; @03068 UNKNOWN module bytes; code/data distinction not yet proven
    db 059h,033h,0Eh,033h,00h,00h,062h,030h,0D8h,034h,0B2h,033h,0BDh,033h,028h,034h
; @03078 UNKNOWN module bytes; code/data distinction not yet proven
    db 075h,034h,028h,034h,00h,00h,070h,030h,091h,078h,0EBh,0Ch,0E1h,0Eh,0Eh,0Eh
; @03088 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,0Eh,081h,0EBh,0Ch,0E1h,0Eh,0Eh,0Eh,0Eh,081h,081h,0E5h,0Ch,0Ch,0Ch
; @03098 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0E1h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,080h,0E1h
; @030A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh
; @030B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Ch,081h
; @030C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,0Eh,081h,081h,0Ch,081h,0Ch,0Eh,081h,081h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
; @030D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,091h,078h,0EBh,019h,081h,019h,081h,019h,081h,081h,081h,080h,0E5h,012h,012h
; @030E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,012h,080h,090h
; @030F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,091h,06Eh,0F7h,013h,010h,0Bh,082h,080h,0E1h,0Bh,081h,0Bh,0Bh,081h,0Bh
; @03108 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh
; @03118 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
; @03128 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Eh,081h,0Eh,0Eh,081h,0Eh
; @03138 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0Eh,081h,0Eh,010h,081h,010h,010h,081h,010h,010h,081h,010h,010h
; @03148 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,010h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h
; @03158 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,080h,0E1h,013h,081h,013h,013h
; @03168 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h
; @03178 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
; @03188 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,013h,081h,013h,013h
; @03198 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h,013h,013h,081h
; @031A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 013h,013h,081h,013h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
; @031B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,013h,081h,013h,013h
; @031C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,010h,081h,010h,010h,081h,010h,010h,081h
; @031D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,010h,081h,010h,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh
; @031E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,0Bh,081h,0Bh,013h,081h,013h,013h
; @031F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,013h,013h,081h,013h,013h,081h,013h,010h,081h,010h,010h,081h,010h,010h,081h
; @03208 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,010h,081h,010h,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh
; @03218 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,0Eh,081h,0Eh,080h,090h,058h,091h
; @03228 UNKNOWN module bytes; code/data distinction not yet proven
    db 05Ah,0F7h,02Bh,028h,02Ah,082h,080h,0F7h,01Eh,082h,082h,082h,021h,023h,01Eh,082h
; @03238 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0F7h,02Bh,082h,02Ah,082h,02Bh,082h,02Ah,082h,02Bh,02Bh,02Ah,082h,02Bh,02Bh
; @03248 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,082h,080h,090h,058h,091h,05Ah,0F7h,026h,025h,026h,082h,080h,0F7h,01Ah,082h
; @03258 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,082h,01Eh,020h,01Ah,082h,080h,0F7h,026h,082h,026h,082h,026h,082h,026h,082h
; @03268 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,028h,026h,082h,026h,028h,026h,082h,080h,090h,058h,091h,05Ah,0F7h,023h,021h
; @03278 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,080h,0F7h,017h,082h,082h,082h,01Ah,01Ch,017h,082h,080h,0F7h,023h,082h
; @03288 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,082h,023h,082h,023h,082h,023h,023h,023h,082h,023h,023h,021h,082h,080h,090h
; @03298 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ch,091h,07Fh,0F7h,03Eh,03Dh,03Bh,082h,032h,031h,02Fh,082h,080h,0E3h,02Ah,0E1h
; @032A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E3h,028h,0EDh,02Ah,0E3h,02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h,032h,0E7h
; @032B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 031h,0E5h,02Fh,0E1h,031h,02Fh,02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh,0F7h,02Ah
; @032C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,02Ah,0E7h,028h,0E5h,026h,0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h,02Ah,0E1h
; @032D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E3h,028h,0EDh,02Ah,0E1h,02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h,0E1h,025h
; @032E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 023h,021h,0F7h,01Eh,0E8h,025h,026h,0E5h,023h,0E1h,028h,026h,028h,026h,028h,026h
; @032F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h
; @03308 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,0F7h,02Ah,082h,080h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah,02Bh,0F3h,02Ah,0E3h
; @03318 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,0F9h,026h,0F7h,02Dh,0E1h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Dh,0E5h,02Bh
; @03328 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,02Dh,0F6h,02Ah,082h,0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h,02Dh,0E3h,02Fh,0F1h
; @03338 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E1h,031h,0E5h,032h,0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh
; @03348 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E3h,02Fh,0E5h,031h,0E1h,081h,0E5h,032h,0E3h,034h,0E5h,036h,037h,0F8h,036h,082h
; @03358 UNKNOWN module bytes; code/data distinction not yet proven
    db 080h,0E1h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,0F5h,02Ah
; @03368 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,025h,026h,025h,026h,025h,026h,025h,026h,025h,026h,025h,026h,0F7h,023h
; @03378 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,028h,0E7h,02Bh,0E5h,02Ah,0E9h,028h,0E7h,026h,0E5h,025h,0F7h,023h,082h,0E9h
; @03388 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,0E7h,02Dh,0E9h,028h,0E7h,02Dh,0E5h,028h,02Bh,0E9h,02Ah,0E7h,028h,0E5h,02Bh
; @03398 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,02Ah,0E3h,02Dh,0E5h,02Bh,0EBh,02Ah,0E1h,02Bh,0E3h,02Ah,0E5h,028h,0EBh,026h
; @033A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,026h,028h,026h,025h,0F1h,023h,0F7h,02Ah,080h,090h,056h,091h,06Eh,026h,028h
; @033B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Ah,082h,091h,05Ah,080h,0E1h,081h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E3h
; @033C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E1h,02Ah,0E3h,02Dh,0EDh,02Fh,0E9h,032h,0E7h,031h,0E5h,02Fh,0E1h,031h,02Fh
; @033D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,031h,082h,02Dh,031h,02Fh,0E7h,02Dh,0F7h,02Ah,0E9h,02Ah,0E7h,028h,0E5h,026h
; @033E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,028h,0F1h,026h,082h,0E1h,081h,0E3h,02Ah,0E1h,02Dh,0E3h,028h,0EDh,02Ah,0E1h
; @033F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,02Bh,02Ah,028h,026h,025h,0E5h,023h,0E1h,025h,023h,021h,0F7h,01Eh,0E8h,025h
; @03408 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,0E5h,023h,0E1h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h
; @03418 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,0F6h,02Ah,082h,080h
; @03428 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,0FDh,02Dh,0E3h,02Bh,0E5h,02Ah,02Bh,0F3h,02Ah,0E3h,028h,0F9h,026h,0F7h
; @03438 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E1h,032h,031h,02Fh,031h,02Fh,02Dh,02Fh,02Dh,0E5h,02Bh,0E1h,02Dh,0F6h,02Ah
; @03448 UNKNOWN module bytes; code/data distinction not yet proven
    db 082h,0E1h,02Bh,0E3h,02Dh,0F1h,02Fh,0E1h,02Dh,0E3h,02Fh,0F1h,032h,0E1h,031h,0E5h
; @03458 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0E3h,031h,0F2h,02Fh,082h,0E3h,02Ah,0E1h,02Bh,0E5h,02Dh,0E3h,02Fh,0E5h,031h
; @03468 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E1h,081h,0E5h,032h,0E3h,034h,0E5h,036h,037h,0F7h,036h,082h,080h,0E1h,081h,026h
; @03478 UNKNOWN module bytes; code/data distinction not yet proven
    db 028h,026h,028h,026h,028h,026h,028h,026h,028h,026h,028h,0F5h,02Ah,0E1h,081h,025h
; @03488 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,025h,026h,025h,026h,025h,026h,025h,026h,025h,026h,0F7h,023h,0E9h,028h,0E7h
; @03498 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Bh,0E5h,02Ah,0E9h,028h,0E7h,026h,0E5h,025h,0F7h,023h,082h,0E9h,028h,0E7h,02Dh
; @034A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0E9h,028h,0E7h,02Dh,0E5h,028h,02Bh,0E9h,02Ah,0E7h,028h,0E5h,02Bh,0F7h,02Ah,0E3h
; @034B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,0E5h,02Bh,0EBh,02Ah,0E1h,02Bh,0E3h,02Ah,0E5h,028h,0EBh,026h,0E1h,026h,028h
; @034C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,025h,0F1h,023h,0F5h,02Ah,080h,084h,00h,080h,084h,02h,080h,084h,03h,080h
; @034D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,081h,081h,081h,081h,080h,0E4h,034h,00h,00h,0DEh,034h,0F7h,081h,081h,081h
; @034E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 081h,081h,081h,081h,081h,080h,06h,035h,0Ch,035h,018h,035h,024h,035h,030h,035h
; @034F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ch,035h,07Ch,038h,0F5h,037h,04h,037h,09h,036h,048h,035h,00h,00h,07Fh,00h
; @03508 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,01h,00h,0F7h,05h,05h,040h,02h,04h,018h,032h,0Ch,00h,01h,059h,0F7h
; @03518 UNKNOWN module bytes; code/data distinction not yet proven
    db 05h,05h,030h,02h,03h,018h,032h,0Ch,00h,01h,06Ah,0F7h,05h,02h,060h,02h
; @03528 UNKNOWN module bytes; code/data distinction not yet proven
    db 02h,018h,032h,0Ch,00h,01h,03Eh,0F7h,05h,02h,058h,02h,01h,018h,032h,0Ch
; @03538 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,01h,047h,0F7h,05h,01h,060h,02h,00h,018h,032h,0Ch,00h,01h,041h,0F7h
; @03548 UNKNOWN module bytes; code/data distinction not yet proven
    db 08h,08h,00h,064h,069h,073h,074h,067h,075h,069h,074h,061h,072h,00h,00h,03h
; @03558 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,024h,032h,010h,01h,00h,02Bh,04Fh,0Eh,07h,01h,00h,00h,00h,00h,00h
; @03568 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,032h,032h,032h,032h,03Eh,09h,02Ch,063h,01Ch,03h,00h,07h,019h,00h,00h
; @03578 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,02Ch,02Eh,048h,00h,025h,0Bh,025h,00h,047h,046h,06Eh,03h,02Eh,0Ch
; @03588 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,04h,020h,054h,034h,03Ah,04Ah,064h,03Dh,00h,030h,032h,010h,01h,00h
; @03598 UNKNOWN module bytes; code/data distinction not yet proven
    db 026h,036h,0Eh,00h,00h,00h,0Dh,010h,01Ch,00h,05Eh,04Bh,03Ch,032h,032h,039h
; @035A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,05Eh,01Bh,03h,00h,07h,02Dh,00h,00h,00h,03Ch,038h,058h,064h,00h
; @035B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ah,024h,03Dh,02h,04Ah,046h,06Eh,07h,01Bh,0Ch,00h,00h,04h,01Fh,04Eh,046h
; @035C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Ah,04Ah,064h,040h,00h,02Dh,032h,010h,01h,00h,00h,043h,0Eh,00h,00h,00h
; @035D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,032h,032h,032h,032h,032h,00h,00h,00h,064h,015h,03h,00h
; @035E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,048h,00h,00h,00h,04h,064h,064h,05Eh,00h,055h,02Ah,053h,040h,039h,032h
; @035F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,04h,020h,063h,05Ch,03Ah,04Ah,064h,044h,024h,027h
; @03608 UNKNOWN module bytes; code/data distinction not yet proven
    db 0F7h,08h,06h,00h,057h,061h,072h,06Dh,020h,050h,061h,064h,020h,020h,00h,07h
; @03618 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Fh,00h,024h,02Dh,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h
; @03628 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,032h,032h,032h,032h,032h,040h,01Ah,031h,064h,010h,06h,00h,07h,064h,00h
; @03638 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,024h,00h,00h,064h,035h,027h,027h,027h,05Ah,055h,05Bh,0Ch,01Bh
; @03648 UNKNOWN module bytes; code/data distinction not yet proven
    db 0Ch,00h,00h,010h,042h,064h,00h,051h,060h,062h,00h,00h,024h,037h,0Bh,01h
; @03658 UNKNOWN module bytes; code/data distinction not yet proven
    db 01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h
; @03668 UNKNOWN module bytes; code/data distinction not yet proven
    db 03Eh,01Dh,023h,064h,010h,06h,00h,07h,064h,00h,00h,00h,00h,024h,00h,00h
; @03678 UNKNOWN module bytes; code/data distinction not yet proven
    db 064h,035h,027h,027h,027h,05Ah,054h,05Bh,0Ch,01Bh,0Ch,00h,00h,010h,042h,064h
; @03688 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,051h,060h,062h,00h,00h,024h,028h,0Bh,01h,01h,00h,00h,07h,00h,00h
; @03698 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,040h,01Ah,031h,064h,010h,06h
; @036A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,07h,064h,00h,00h,00h,00h,024h,00h,00h,064h,035h,027h,027h,027h,05Ah
; @036B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 055h,05Bh,0Ch,01Bh,0Ch,00h,00h,010h,042h,064h,00h,051h,060h,062h,00h,00h
; @036C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 024h,03Ch,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h
; @036D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,032h,032h,032h,03Eh,01Dh,023h,064h,010h,06h,00h,07h,064h,00h,00h,00h
; @036E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,024h,00h,00h,064h,035h,027h,027h,027h,05Ah,054h,05Bh,0Ch,01Bh,0Ch,00h
; @036F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,010h,042h,064h,00h,051h,061h,062h,00h,00h,03Bh,0F7h,08h,04h,00h,050h
; @03708 UNKNOWN module bytes; code/data distinction not yet proven
    db 06Fh,06Ch,079h,020h,053h,079h,06Eh,074h,068h,07h,00h,07h,00h,024h,036h,0Bh
; @03718 UNKNOWN module bytes; code/data distinction not yet proven
    db 01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h
; @03728 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,042h,04h,064h,064h,010h,06h,00h,07h,064h,00h,00h,00h,00h,024h,00h
; @03738 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,01Eh,064h,027h,027h,027h,055h,04Ah,05Bh,0Ch,01Bh,0Ch,02h,00h,00h,064h
; @03748 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,02h,064h,00h,00h,00h,024h,02Eh,0Bh,01h,01h,00h,00h,07h,00h
; @03758 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,040h,06h,064h,064h,010h
; @03768 UNKNOWN module bytes; code/data distinction not yet proven
    db 06h,00h,07h,064h,00h,00h,00h,00h,024h,00h,00h,01Eh,064h,027h,027h,027h
; @03778 UNKNOWN module bytes; code/data distinction not yet proven
    db 055h,04Ah,05Bh,0Ch,01Bh,0Ch,02h,00h,00h,064h,00h,00h,02h,064h,00h,00h
; @03788 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,024h,032h,0Bh,01h,01h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h
; @03798 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,032h,032h,032h,032h,044h,00h,064h,064h,010h,06h,00h,07h,064h,064h,00h
; @037A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,024h,00h,00h,01Eh,064h,027h,027h,027h,05Bh,04Ah,05Bh,0Ch,01Bh,0Ch
; @037B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 02h,00h,00h,064h,00h,00h,02h,064h,00h,00h,00h,024h,032h,0Bh,00h,00h
; @037C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,00h
; @037D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,0Bh,00h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @037E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,032h,05Bh,0Ch,01Bh,0Ch,00h,05Bh,0F7h,08h,02h,00h
; @037F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 072h,065h,073h,06Fh,06Eh,061h,06Eh,063h,065h,020h,07h,00h,03h,01h,024h,032h
; @03808 UNKNOWN module bytes; code/data distinction not yet proven
    db 010h,01h,00h,00h,03Fh,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h,032h
; @03818 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,032h,03Dh,014h,036h,064h,01Eh,07h,06Bh,07h,064h,01Eh,00h,00h,040h,05Eh
; @03828 UNKNOWN module bytes; code/data distinction not yet proven
    db 04Ah,05Ah,00h,031h,040h,044h,029h,05Fh,056h,05Bh,0Ch,01Bh,0Ch,02h,04h,018h
; @03838 UNKNOWN module bytes; code/data distinction not yet proven
    db 018h,014h,032h,053h,03Fh,05Eh,061h,030h,024h,032h,010h,01h,00h,00h,045h,07h
; @03848 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,00h,00h,00h,032h,032h,032h,032h,032h,042h,017h,036h,064h
; @03858 UNKNOWN module bytes; code/data distinction not yet proven
    db 01Ch,07h,06Bh,07h,064h,01Eh,00h,00h,040h,048h,05Eh,05Eh,00h,031h,064h,051h
; @03868 UNKNOWN module bytes; code/data distinction not yet proven
    db 02Dh,05Fh,056h,05Bh,0Ch,01Bh,0Ch,02h,04h,014h,01Ch,022h,02Eh,056h,03Bh,064h
; @03878 UNKNOWN module bytes; code/data distinction not yet proven
    db 058h,024h,03Ah,0F7h,08h,00h,00h,046h,04Dh,020h,042h,061h,073h,073h,020h,020h
; @03888 UNKNOWN module bytes; code/data distinction not yet proven
    db 020h,07h,00h,03h,00h,024h,032h,0Fh,01h,01h,00h,00h,07h,02h,00h,00h
; @03898 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,00h,00h,00h,032h,032h,032h,032h,032h,040h,00h,023h,035h,01Ah,08h,00h
; @038A8 UNKNOWN module bytes; code/data distinction not yet proven
    db 07h,03Dh,064h,00h,03h,00h,021h,04Dh,064h,0Ch,059h,04Bh,033h,00h,062h,04Eh
; @038B8 UNKNOWN module bytes; code/data distinction not yet proven
    db 05Bh,0Ch,01Bh,0Ch,00h,00h,00h,0Bh,00h,04Fh,0Bh,05Ch,064h,064h,00h,024h
; @038C8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,0Fh,01h,01h,00h,024h,07h,00h,00h,00h,00h,00h,00h,00h,032h,032h
; @038D8 UNKNOWN module bytes; code/data distinction not yet proven
    db 032h,032h,032h,03Eh,00h,031h,035h,0Ah,08h,00h,07h,04Ah,064h,00h,03h,00h
; @038E8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,020h,064h,0Ch,064h,04Bh,023h,00h,064h,04Eh,05Bh,0Ch,01Bh,0Ch,00h,00h
; @038F8 UNKNOWN module bytes; code/data distinction not yet proven
    db 00h,0Bh,00h,04Fh,0Bh,05Ch,064h,064h,062h,0F7h
driver ends
end
