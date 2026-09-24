; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part02 segment byte public 'CODE'
assume cs:part02,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
loc_025B2 equ 0E5B2h
loc_04201 equ 0201h
loc_0420F equ 020Fh
loc_04227 equ 0227h
loc_04DA8 equ 0DA8h
loc_04F22 equ 0F22h
loc_04F29 equ 0F29h
loc_05E61 equ 01E61h
loc_05E6E equ 01E6Eh
loc_05E81 equ 01E81h
loc_05E8E equ 01E8Eh
loc_05E93 equ 01E93h
loc_05E96 equ 01E96h
loc_05E99 equ 01E99h
loc_05EA5 equ 01EA5h
loc_05EB2 equ 01EB2h
loc_05EB5 equ 01EB5h
loc_05EC2 equ 01EC2h
loc_05EC8 equ 01EC8h
loc_05ED5 equ 01ED5h
loc_0AF22 equ 06F22h
loc_0AF63 equ 06F63h
loc_00011 equ 0C011h
loc_00162 equ 0C162h
loc_006BC equ 0C6BCh
loc_0075F equ 0C75Fh
loc_00B3E equ 0CB3Eh
loc_00E0F equ 0CE0Fh
loc_00E1D equ 0CE1Dh
loc_041A6 equ 01A6h
loc_041BB equ 01BBh
loc_041CC equ 01CCh
loc_041E7 equ 01E7h
loc_0427E equ 027Eh
loc_04285 equ 0285h
loc_0428C equ 028Ch
loc_042DD equ 02DDh
loc_0430D equ 030Dh
loc_0433D equ 033Dh
loc_0436D equ 036Dh
loc_0439D equ 039Dh
loc_043CD equ 03CDh
loc_043FD equ 03FDh
loc_0442D equ 042Dh
loc_04439 equ 0439h
loc_04444 equ 0444h
loc_04445 equ 0445h
loc_0445E equ 045Eh
loc_04492 equ 0492h
loc_044A7 equ 04A7h
loc_044AA equ 04AAh
loc_044BA equ 04BAh
loc_044D2 equ 04D2h
loc_044D7 equ 04D7h
loc_044DF equ 04DFh
loc_044F7 equ 04F7h
loc_04505 equ 0505h
loc_0450C equ 050Ch
loc_04516 equ 0516h
loc_0451C equ 051Ch
loc_04537 equ 0537h
loc_045A9 equ 05A9h
loc_045CB equ 05CBh
loc_045CE equ 05CEh
loc_045F6 equ 05F6h
loc_0463B equ 063Bh
loc_04654 equ 0654h
loc_04656 equ 0656h
loc_048FB equ 08FBh
loc_048FD equ 08FDh
loc_049A7 equ 09A7h
loc_049BD equ 09BDh
loc_049CB equ 09CBh
loc_049CD equ 09CDh
loc_049E3 equ 09E3h
loc_049E4 equ 09E4h
loc_04A0B equ 0A0Bh
loc_04A0D equ 0A0Dh
loc_04A11 equ 0A11h
loc_04A16 equ 0A16h
loc_04A2B equ 0A2Bh
loc_04A37 equ 0A37h
loc_04A3A equ 0A3Ah
loc_04A46 equ 0A46h
loc_04A5C equ 0A5Ch
loc_04A66 equ 0A66h
loc_04A7E equ 0A7Eh
loc_04A87 equ 0A87h
loc_04A98 equ 0A98h
loc_04ACE equ 0ACEh
loc_04ADA equ 0ADAh
loc_04AF5 equ 0AF5h
loc_04B41 equ 0B41h
loc_04B4A equ 0B4Ah
loc_04B7A equ 0B7Ah
loc_04B86 equ 0B86h
loc_04B92 equ 0B92h
loc_04B96 equ 0B96h
loc_04BC4 equ 0BC4h
loc_04BD5 equ 0BD5h
loc_04BD7 equ 0BD7h
loc_04BE7 equ 0BE7h
loc_04BFE equ 0BFEh
loc_04C0E equ 0C0Eh
loc_04C1C equ 0C1Ch
loc_04C2A equ 0C2Ah
loc_04C38 equ 0C38h
loc_04C46 equ 0C46h
loc_04C54 equ 0C54h
loc_04C62 equ 0C62h
loc_04C6A equ 0C6Ah
loc_04C6D equ 0C6Dh
loc_04C70 equ 0C70h
loc_04C74 equ 0C74h
loc_04C7C equ 0C7Ch
loc_04CE7 equ 0CE7h
loc_04D15 equ 0D15h
loc_04D59 equ 0D59h
loc_04D61 equ 0D61h
loc_04D6F equ 0D6Fh
loc_04D8E equ 0D8Eh
loc_04D94 equ 0D94h
loc_04DAF equ 0DAFh
loc_04DCE equ 0DCEh
loc_04DD8 equ 0DD8h
loc_04E0D equ 0E0Dh
loc_04E26 equ 0E26h
loc_04E3B equ 0E3Bh
loc_04E46 equ 0E46h
loc_04E5A equ 0E5Ah
loc_04E69 equ 0E69h
loc_04E82 equ 0E82h
loc_04E85 equ 0E85h
loc_04E8F equ 0E8Fh
loc_04E9F equ 0E9Fh
loc_04EBF equ 0EBFh
loc_04F60 equ 0F60h
loc_04F8C equ 0F8Ch
loc_04FCC equ 0FCCh
loc_0502E equ 0102Eh
loc_05042 equ 01042h
loc_05051 equ 01051h
loc_05059 equ 01059h
loc_0505B equ 0105Bh
loc_0506F equ 0106Fh
loc_05073 equ 01073h
loc_050AB equ 010ABh
loc_050C9 equ 010C9h
loc_05128 equ 01128h
loc_0513D equ 0113Dh
loc_05145 equ 01145h
loc_0514E equ 0114Eh
loc_05160 equ 01160h
loc_05169 equ 01169h
loc_05176 equ 01176h
loc_0517C equ 0117Ch
loc_0518C equ 0118Ch
loc_05194 equ 01194h
loc_0519A equ 0119Ah
loc_051B8 equ 011B8h
loc_051D6 equ 011D6h
loc_051F3 equ 011F3h
loc_05280 equ 01280h
loc_0529A equ 0129Ah
loc_052F7 equ 012F7h
loc_0532A equ 0132Ah
loc_0532D equ 0132Dh
loc_05338 equ 01338h
loc_0535D equ 0135Dh
loc_0536F equ 0136Fh
loc_053C9 equ 013C9h
loc_053FC equ 013FCh
loc_05401 equ 01401h
loc_05408 equ 01408h
loc_0541E equ 0141Eh
loc_05433 equ 01433h
loc_05450 equ 01450h
loc_05461 equ 01461h
loc_05497 equ 01497h
loc_054AF equ 014AFh
loc_054B7 equ 014B7h
loc_054CE equ 014CEh
loc_054D4 equ 014D4h
loc_0553A equ 0153Ah
loc_0553D equ 0153Dh
loc_05559 equ 01559h
loc_0555F equ 0155Fh
loc_05576 equ 01576h
loc_05582 equ 01582h
loc_05585 equ 01585h
loc_0558B equ 0158Bh
loc_05595 equ 01595h
loc_0559F equ 0159Fh
loc_055A9 equ 015A9h
loc_055B3 equ 015B3h
loc_055BD equ 015BDh
loc_055D5 equ 015D5h
loc_055EE equ 015EEh
loc_0560A equ 0160Ah
loc_05613 equ 01613h
loc_05620 equ 01620h
loc_05621 equ 01621h
loc_0562C equ 0162Ch
loc_05637 equ 01637h
loc_0563D equ 0163Dh
loc_05656 equ 01656h
loc_05666 equ 01666h
loc_05669 equ 01669h
loc_05675 equ 01675h
loc_0569B equ 0169Bh
loc_056A5 equ 016A5h
loc_056B2 equ 016B2h
loc_056BC equ 016BCh
loc_056CE equ 016CEh
loc_056DE equ 016DEh
loc_056E1 equ 016E1h
loc_056EB equ 016EBh
loc_05714 equ 01714h
loc_05725 equ 01725h
loc_0572F equ 0172Fh
loc_05732 equ 01732h
loc_0573E equ 0173Eh
loc_05797 equ 01797h
loc_057AB equ 017ABh
loc_057D3 equ 017D3h
loc_057E0 equ 017E0h
loc_057ED equ 017EDh
loc_057F4 equ 017F4h
loc_05800 equ 01800h
loc_0580B equ 0180Bh
loc_05827 equ 01827h
loc_05850 equ 01850h
loc_05895 equ 01895h
loc_058A4 equ 018A4h
loc_058DF equ 018DFh
loc_05A00 equ 01A00h
loc_05A6C equ 01A6Ch
loc_05BEE equ 01BEEh
loc_05C46 equ 01C46h
loc_05C74 equ 01C74h
loc_05CC0 equ 01CC0h
loc_05D14 equ 01D14h
loc_05D4E equ 01D4Eh
loc_05D66 equ 01D66h
loc_05D7E equ 01D7Eh
loc_05DCB equ 01DCBh
loc_05DD3 equ 01DD3h
loc_05DD9 equ 01DD9h
loc_05DE6 equ 01DE6h
loc_05DED equ 01DEDh
loc_05DF2 equ 01DF2h
loc_05E14 equ 01E14h
loc_05EE4 equ 01EE4h
loc_05EF9 equ 01EF9h
loc_05F06 equ 01F06h
loc_05F5E equ 01F5Eh
loc_05F86 equ 01F86h
loc_05F89 equ 01F89h
loc_05FAC equ 01FACh
loc_05FBA equ 01FBAh
loc_05FCB equ 01FCBh
loc_05FE7 equ 01FE7h
loc_05FF8 equ 01FF8h
loc_06030 equ 02030h
FindFreeRecordPoolA_07524 equ 03524h
loc_0A781 equ 06781h
loc_0C640 equ 08640h
loc_0C9EA equ 089EAh
loc_0CB1C equ 08B1Ch
loc_0CB3E equ 08B3Eh
loc_0CBE8 equ 08BE8h
; @04000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh
; @04010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
; @04020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h
; @04030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,04Dh,075h,0B7h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h
; @04040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0F7h,0D0h,0B2h,0FFh,0F6h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
; @04050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h
; @04060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h
; @04070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h
; @04080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h
; @04090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,083h,0C7h,034h,04Dh,075h,0A3h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh
; @040A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h
; @040B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,026h,020h,055h,02h,0ADh,032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
; @040C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h,0C7h,034h,04Dh,075h
; @040D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CCh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h
; @040E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
; @040F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h,055h,02h,0ADh,032h,0D2h
; @04100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh
; @04110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h
; @04120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,034h,04Dh,075h,0B2h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0B2h,0FFh,0F9h,0D0h
; @04130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h
; @04140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h
; @04150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0F9h,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,05h,026h,020h,055h,02h,0ADh
; @04160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h
; @04170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
; @04180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,083h,0C7h,034h
; @04190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,075h,098h,02Eh,08Eh,01Eh,096h,095h,0C3h
; sub_0000_4199
; @04199 0000:4199 original=ad
    lodsw
; @0419A 0000:419A original=8bc8
    mov cx, ax
; @0419C 0000:419C original=ad
    lodsw
; @0419D 0000:419D original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @041A2 0000:41A2 original=d1e0
    shl ax, 1
; @041A4 0000:41A4 original=8be8
    mov bp, ax
; @041A6 0000:41A6 original=51
    push cx
; @041A7 0000:41A7 original=8bcd
    mov cx, bp
; @041A9 0000:41A9 original=f3a4
    rep movsb
; @041AB 0000:41AB original=2bfd
    sub di, bp
; @041AD 0000:41AD original=81c70020
    add di, 02000h
; @041B1 0000:41B1 original=f7c70040
    test di, 04000h
; @041B5 0000:41B5 original=7404
    JE_SHORT loc_041BB
; @041B7 0000:41B7 original=81c750c0
    add di, 0C050h
; @041BB 0000:41BB original=59
    pop cx
; @041BC 0000:41BC original=e2e8
    LOOP_SHORT loc_041A6
; @041BE 0000:41BE original=c3
    ret
; sub_0000_41BF
; @041BF 0000:41BF original=2e8e069895
    mov es, word ptr cs:[09598h]
; @041C4 0000:41C4 original=ad
    lodsw
; @041C5 0000:41C5 original=8bc8
    mov cx, ax
; @041C7 0000:41C7 original=ad
    lodsw
; @041C8 0000:41C8 original=d1e0
    shl ax, 1
; @041CA 0000:41CA original=8be8
    mov bp, ax
; @041CC 0000:41CC original=51
    push cx
; @041CD 0000:41CD original=8bcd
    mov cx, bp
; @041CF 0000:41CF original=f3a4
    rep movsb
; @041D1 0000:41D1 original=2bfd
    sub di, bp
; @041D3 0000:41D3 original=83c734
    add di, 034h
; @041D6 0000:41D6 original=59
    pop cx
; @041D7 0000:41D7 original=e2f3
    LOOP_SHORT loc_041CC
; @041D9 0000:41D9 original=c3
    ret
; sub_0000_41DA
; @041DA 0000:41DA original=2e8e069895
    mov es, word ptr cs:[09598h]
; @041DF 0000:41DF original=ad
    lodsw
; @041E0 0000:41E0 original=8bc8
    mov cx, ax
; @041E2 0000:41E2 original=ad
    lodsw
; @041E3 0000:41E3 original=d1e0
    shl ax, 1
; @041E5 0000:41E5 original=8be8
    mov bp, ax
; @041E7 0000:41E7 original=51
    push cx
; @041E8 0000:41E8 original=8bcd
    mov cx, bp
; @041EA 0000:41EA original=f3a4
    rep movsb
; @041EC 0000:41EC original=2bfd
    sub di, bp
; @041EE 0000:41EE original=83c750
    add di, 050h
; @041F1 0000:41F1 original=59
    pop cx
; @041F2 0000:41F2 original=e2f3
    LOOP_SHORT loc_041E7
; @041F4 0000:41F4 original=c3
    ret
; @041F5 0000:41F5 original=8b5e02 runtime CFG evidence
    mov bx, word ptr ss:[bp + 2]
; @041F8 0000:41F8 original=81fbe000 runtime CFG evidence
    cmp bx, 0E0h
; @041FC 0000:41FC original=7203 runtime CFG evidence
    JB_SHORT loc_04201
; @041FE 0000:41FE original=e9b1e3 runtime CFG evidence
    JMP_NEAR loc_025B2
; @04201 0000:4201 original=d1e3 runtime CFG evidence
    shl bx, 1
; @04203 0000:4203 original=8b9fc899 runtime CFG evidence
    mov bx, word ptr ds:[bx - 06638h]
; @04207 0000:4207 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0420A 0000:420A original=7503 runtime CFG evidence
    JNE_SHORT loc_0420F
; @0420C 0000:420C original=e9a3e3 runtime CFG evidence
    JMP_NEAR loc_025B2
; @0420F 0000:420F original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @04212 0000:4212 original=8bc8 runtime CFG evidence
    mov cx, ax
; @04214 0000:4214 original=83e103 runtime CFG evidence
    and cx, 3
; @04217 0000:4217 original=894e12 runtime CFG evidence
    mov word ptr ss:[bp + 012h], cx
; @0421A 0000:421A original=d1e8 runtime CFG evidence
    shr ax, 1
; @0421C 0000:421C original=d1e8 runtime CFG evidence
    shr ax, 1
; @0421E 0000:421E original=03c3 runtime CFG evidence
    add ax, bx
; @04220 0000:4220 original=837e2400 runtime CFG evidence
    cmp word ptr ss:[bp + 024h], 0
; @04224 0000:4224 original=7501 runtime CFG evidence
    JNE_SHORT loc_04227
; @04226 0000:4226 original=c3 runtime CFG evidence
    ret
; @04227 0000:4227 original=ff4e24 runtime CFG evidence
    dec word ptr ss:[bp + 024h]
; @0422A 0000:422A original=c3 runtime CFG evidence
    ret
; sub_0000_422B
; @0422B 0000:422B original=8adc
    mov bl, ah
; @0422D 0000:422D original=32ff
    xor bh, bh
; @0422F 0000:422F original=d1e3
    shl bx, 1
; @04231 0000:4231 original=8b9fe89e
    mov bx, word ptr ds:[bx - 06118h]
; @04235 0000:4235 original=32e4
    xor ah, ah
; @04237 0000:4237 original=d1e0
    shl ax, 1
; @04239 0000:4239 original=03c3
    add ax, bx
; @0423B 0000:423B original=8bf8
    mov di, ax
; @0423D 0000:423D original=c3
    ret
; sub_0000_423E
; @0423E 0000:423E original=8adc
    mov bl, ah
; @04240 0000:4240 original=32ff
    xor bh, bh
; @04242 0000:4242 original=d1e3
    shl bx, 1
; @04244 0000:4244 original=8b9fc89b
    mov bx, word ptr ds:[bx - 06438h]
; @04248 0000:4248 original=32e4
    xor ah, ah
; @0424A 0000:424A original=d1e0
    shl ax, 1
; @0424C 0000:424C original=03c3
    add ax, bx
; @0424E 0000:424E original=8bf8
    mov di, ax
; @04250 0000:4250 original=c3
    ret
; sub_0000_4251
; @04251 0000:4251 original=8adc
    mov bl, ah
; @04253 0000:4253 original=32ff
    xor bh, bh
; @04255 0000:4255 original=d1e3
    shl bx, 1
; @04257 0000:4257 original=8b9f589d
    mov bx, word ptr ds:[bx - 062A8h]
; @0425B 0000:425B original=32e4
    xor ah, ah
; @0425D 0000:425D original=d1e0
    shl ax, 1
; @0425F 0000:425F original=03c3
    add ax, bx
; @04261 0000:4261 original=8bf8
    mov di, ax
; @04263 0000:4263 original=c3
    ret
; @04264 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,0D1h,0E8h
; @04274 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0C3h,0C3h
; sub_0000_4277
; @04277 0000:4277 original=3c10
    cmp al, 010h
; @04279 0000:4279 original=7503
    JNE_SHORT loc_0427E
; @0427B 0000:427B original=e9e001
    JMP_NEAR loc_0445E
; @0427E 0000:427E original=3c11
    cmp al, 011h
; @04280 0000:4280 original=7503
    JNE_SHORT loc_04285
; @04282 0000:4282 original=e9c001
    JMP_NEAR loc_04445
; @04285 0000:4285 original=3c0e
    cmp al, 0Eh
; @04287 0000:4287 original=7503
    JNE_SHORT loc_0428C
; @04289 0000:4289 original=e9ad01
    JMP_NEAR loc_04439
; @0428C 0000:428C original=32e4
    xor ah, ah
; @0428E 0000:428E original=d1e0
    shl ax, 1
; @04290 0000:4290 original=d1e0
    shl ax, 1
; @04292 0000:4292 original=d1e0
    shl ax, 1
; @04294 0000:4294 original=051618
    add ax, 01816h
; @04297 0000:4297 original=8bf0
    mov si, ax
; @04299 0000:4299 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @0429E 0000:429E original=33db
    xor bx, bx
; @042A0 0000:42A0 original=8a1e5e21
    mov bl, byte ptr ds:[0215Eh]
; @042A4 0000:42A4 original=031e6021
    add bx, word ptr ds:[02160h]
; @042A8 0000:42A8 original=8bfb
    mov di, bx
; @042AA 0000:42AA original=bbae21
    mov bx, 021AEh
; @042AD 0000:42AD original=8a04
    mov al, byte ptr ds:[si]
; @042AF 0000:42AF original=d0e8
    shr al, 1
; @042B1 0000:42B1 original=d0e8
    shr al, 1
; @042B3 0000:42B3 original=d0e8
    shr al, 1
; @042B5 0000:42B5 original=d0e8
    shr al, 1
; @042B7 0000:42B7 original=d7
    xlat
; @042B8 0000:42B8 original=8ae0
    mov ah, al
; @042BA 0000:42BA original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @042BE 0000:42BE original=268825
    mov byte ptr es:[di], ah
; @042C1 0000:42C1 original=ac
    lodsb
; @042C2 0000:42C2 original=240f
    and al, 0Fh
; @042C4 0000:42C4 original=d7
    xlat
; @042C5 0000:42C5 original=8ae0
    mov ah, al
; @042C7 0000:42C7 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @042CB 0000:42CB original=26886501
    mov byte ptr es:[di + 1], ah
; @042CF 0000:42CF original=81c70020
    add di, 02000h
; @042D3 0000:42D3 original=f7c70040
    test di, 04000h
; @042D7 0000:42D7 original=7404
    JE_SHORT loc_042DD
; @042D9 0000:42D9 original=81c750c0
    add di, 0C050h
; @042DD 0000:42DD original=8a04
    mov al, byte ptr ds:[si]
; @042DF 0000:42DF original=d0e8
    shr al, 1
; @042E1 0000:42E1 original=d0e8
    shr al, 1
; @042E3 0000:42E3 original=d0e8
    shr al, 1
; @042E5 0000:42E5 original=d0e8
    shr al, 1
; @042E7 0000:42E7 original=d7
    xlat
; @042E8 0000:42E8 original=8ae0
    mov ah, al
; @042EA 0000:42EA original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @042EE 0000:42EE original=268825
    mov byte ptr es:[di], ah
; @042F1 0000:42F1 original=ac
    lodsb
; @042F2 0000:42F2 original=240f
    and al, 0Fh
; @042F4 0000:42F4 original=d7
    xlat
; @042F5 0000:42F5 original=8ae0
    mov ah, al
; @042F7 0000:42F7 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @042FB 0000:42FB original=26886501
    mov byte ptr es:[di + 1], ah
; @042FF 0000:42FF original=81c70020
    add di, 02000h
; @04303 0000:4303 original=f7c70040
    test di, 04000h
; @04307 0000:4307 original=7404
    JE_SHORT loc_0430D
; @04309 0000:4309 original=81c750c0
    add di, 0C050h
; @0430D 0000:430D original=8a04
    mov al, byte ptr ds:[si]
; @0430F 0000:430F original=d0e8
    shr al, 1
; @04311 0000:4311 original=d0e8
    shr al, 1
; @04313 0000:4313 original=d0e8
    shr al, 1
; @04315 0000:4315 original=d0e8
    shr al, 1
; @04317 0000:4317 original=d7
    xlat
; @04318 0000:4318 original=8ae0
    mov ah, al
; @0431A 0000:431A original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0431E 0000:431E original=268825
    mov byte ptr es:[di], ah
; @04321 0000:4321 original=ac
    lodsb
; @04322 0000:4322 original=240f
    and al, 0Fh
; @04324 0000:4324 original=d7
    xlat
; @04325 0000:4325 original=8ae0
    mov ah, al
; @04327 0000:4327 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0432B 0000:432B original=26886501
    mov byte ptr es:[di + 1], ah
; @0432F 0000:432F original=81c70020
    add di, 02000h
; @04333 0000:4333 original=f7c70040
    test di, 04000h
; @04337 0000:4337 original=7404
    JE_SHORT loc_0433D
; @04339 0000:4339 original=81c750c0
    add di, 0C050h
; @0433D 0000:433D original=8a04
    mov al, byte ptr ds:[si]
; @0433F 0000:433F original=d0e8
    shr al, 1
; @04341 0000:4341 original=d0e8
    shr al, 1
; @04343 0000:4343 original=d0e8
    shr al, 1
; @04345 0000:4345 original=d0e8
    shr al, 1
; @04347 0000:4347 original=d7
    xlat
; @04348 0000:4348 original=8ae0
    mov ah, al
; @0434A 0000:434A original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0434E 0000:434E original=268825
    mov byte ptr es:[di], ah
; @04351 0000:4351 original=ac
    lodsb
; @04352 0000:4352 original=240f
    and al, 0Fh
; @04354 0000:4354 original=d7
    xlat
; @04355 0000:4355 original=8ae0
    mov ah, al
; @04357 0000:4357 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0435B 0000:435B original=26886501
    mov byte ptr es:[di + 1], ah
; @0435F 0000:435F original=81c70020
    add di, 02000h
; @04363 0000:4363 original=f7c70040
    test di, 04000h
; @04367 0000:4367 original=7404
    JE_SHORT loc_0436D
; @04369 0000:4369 original=81c750c0
    add di, 0C050h
; @0436D 0000:436D original=8a04
    mov al, byte ptr ds:[si]
; @0436F 0000:436F original=d0e8
    shr al, 1
; @04371 0000:4371 original=d0e8
    shr al, 1
; @04373 0000:4373 original=d0e8
    shr al, 1
; @04375 0000:4375 original=d0e8
    shr al, 1
; @04377 0000:4377 original=d7
    xlat
; @04378 0000:4378 original=8ae0
    mov ah, al
; @0437A 0000:437A original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0437E 0000:437E original=268825
    mov byte ptr es:[di], ah
; @04381 0000:4381 original=ac
    lodsb
; @04382 0000:4382 original=240f
    and al, 0Fh
; @04384 0000:4384 original=d7
    xlat
; @04385 0000:4385 original=8ae0
    mov ah, al
; @04387 0000:4387 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0438B 0000:438B original=26886501
    mov byte ptr es:[di + 1], ah
; @0438F 0000:438F original=81c70020
    add di, 02000h
; @04393 0000:4393 original=f7c70040
    test di, 04000h
; @04397 0000:4397 original=7404
    JE_SHORT loc_0439D
; @04399 0000:4399 original=81c750c0
    add di, 0C050h
; @0439D 0000:439D original=8a04
    mov al, byte ptr ds:[si]
; @0439F 0000:439F original=d0e8
    shr al, 1
; @043A1 0000:43A1 original=d0e8
    shr al, 1
; @043A3 0000:43A3 original=d0e8
    shr al, 1
; @043A5 0000:43A5 original=d0e8
    shr al, 1
; @043A7 0000:43A7 original=d7
    xlat
; @043A8 0000:43A8 original=8ae0
    mov ah, al
; @043AA 0000:43AA original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @043AE 0000:43AE original=268825
    mov byte ptr es:[di], ah
; @043B1 0000:43B1 original=ac
    lodsb
; @043B2 0000:43B2 original=240f
    and al, 0Fh
; @043B4 0000:43B4 original=d7
    xlat
; @043B5 0000:43B5 original=8ae0
    mov ah, al
; @043B7 0000:43B7 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @043BB 0000:43BB original=26886501
    mov byte ptr es:[di + 1], ah
; @043BF 0000:43BF original=81c70020
    add di, 02000h
; @043C3 0000:43C3 original=f7c70040
    test di, 04000h
; @043C7 0000:43C7 original=7404
    JE_SHORT loc_043CD
; @043C9 0000:43C9 original=81c750c0
    add di, 0C050h
; @043CD 0000:43CD original=8a04
    mov al, byte ptr ds:[si]
; @043CF 0000:43CF original=d0e8
    shr al, 1
; @043D1 0000:43D1 original=d0e8
    shr al, 1
; @043D3 0000:43D3 original=d0e8
    shr al, 1
; @043D5 0000:43D5 original=d0e8
    shr al, 1
; @043D7 0000:43D7 original=d7
    xlat
; @043D8 0000:43D8 original=8ae0
    mov ah, al
; @043DA 0000:43DA original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @043DE 0000:43DE original=268825
    mov byte ptr es:[di], ah
; @043E1 0000:43E1 original=ac
    lodsb
; @043E2 0000:43E2 original=240f
    and al, 0Fh
; @043E4 0000:43E4 original=d7
    xlat
; @043E5 0000:43E5 original=8ae0
    mov ah, al
; @043E7 0000:43E7 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @043EB 0000:43EB original=26886501
    mov byte ptr es:[di + 1], ah
; @043EF 0000:43EF original=81c70020
    add di, 02000h
; @043F3 0000:43F3 original=f7c70040
    test di, 04000h
; @043F7 0000:43F7 original=7404
    JE_SHORT loc_043FD
; @043F9 0000:43F9 original=81c750c0
    add di, 0C050h
; @043FD 0000:43FD original=8a04
    mov al, byte ptr ds:[si]
; @043FF 0000:43FF original=d0e8
    shr al, 1
; @04401 0000:4401 original=d0e8
    shr al, 1
; @04403 0000:4403 original=d0e8
    shr al, 1
; @04405 0000:4405 original=d0e8
    shr al, 1
; @04407 0000:4407 original=d7
    xlat
; @04408 0000:4408 original=8ae0
    mov ah, al
; @0440A 0000:440A original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0440E 0000:440E original=268825
    mov byte ptr es:[di], ah
; @04411 0000:4411 original=ac
    lodsb
; @04412 0000:4412 original=240f
    and al, 0Fh
; @04414 0000:4414 original=d7
    xlat
; @04415 0000:4415 original=8ae0
    mov ah, al
; @04417 0000:4417 original=22265c21
    and ah, byte ptr ds:[0215Ch]
; @0441B 0000:441B original=26886501
    mov byte ptr es:[di + 1], ah
; @0441F 0000:441F original=81c70020
    add di, 02000h
; @04423 0000:4423 original=f7c70040
    test di, 04000h
; @04427 0000:4427 original=7404
    JE_SHORT loc_0442D
; @04429 0000:4429 original=81c750c0
    add di, 0C050h
; @0442D 0000:442D original=80065e2102
    add byte ptr ds:[0215Eh], 2
; @04432 0000:4432 original=803e5e2150
    cmp byte ptr ds:[0215Eh], 050h
; @04437 0000:4437 original=720b
    JB_SHORT loc_04444
; @04439 0000:4439 original=c6065e2100
    mov byte ptr ds:[0215Eh], 0
; @0443E 0000:443E original=810660214001
    add word ptr ds:[02160h], 0140h
; @04444 0000:4444 original=c3
    ret
; @04445 0000:4445 original=8a4601
    mov al, byte ptr ss:[bp + 1]
; @04448 0000:4448 original=b94001
    mov cx, 0140h
; @0444B 0000:444B original=32e4
    xor ah, ah
; @0444D 0000:444D original=f7e1
    mul cx
; @0444F 0000:444F original=a36021
    mov word ptr ds:[02160h], ax
; @04452 0000:4452 original=8a4602
    mov al, byte ptr ss:[bp + 2]
; @04455 0000:4455 original=02c0
    add al, al
; @04457 0000:4457 original=a25e21
    mov byte ptr ds:[0215Eh], al
; @0445A 0000:445A original=83c502
    add bp, 2
; @0445D 0000:445D original=c3
    ret
; @0445E 0000:445E original=45
    inc bp
; @0445F 0000:445F original=8a4600
    mov al, byte ptr ss:[bp]
; @04462 0000:4462 original=2403
    and al, 3
; @04464 0000:4464 original=bbbe21
    mov bx, 021BEh
; @04467 0000:4467 original=d7
    xlat
; @04468 0000:4468 original=a25c21
    mov byte ptr ds:[0215Ch], al
; @0446B 0000:446B original=c3
    ret
; sub_0000_446C
; @0446C 0000:446C original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @04471 0000:4471 original=33ff
    xor di, di
; @04473 0000:4473 original=8bc7
    mov ax, di
; @04475 0000:4475 original=b90020
    mov cx, 02000h
; @04478 0000:4478 original=f3ab
    rep stosw
; @0447A 0000:447A original=c3
    ret
; sub_0000_447B
; @0447B 0000:447B original=8b364c23
    mov si, word ptr ds:[0234Ch]
; @0447F 0000:447F original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @04484 0000:4484 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @04489 0000:4489 original=bb1a00
    mov bx, 01Ah
; @0448C 0000:448C original=bfa000
    mov di, 0A0h
; @0448F 0000:448F original=bdc000
    mov bp, 0C0h
; @04492 0000:4492 original=8bcb
    mov cx, bx
; @04494 0000:4494 original=f3a5
    rep movsw
; @04496 0000:4496 original=83ef34
    sub di, 034h
; @04499 0000:4499 original=81c70020
    add di, 02000h
; @0449D 0000:449D original=f7c70040
    test di, 04000h
; @044A1 0000:44A1 original=7404
    JE_SHORT loc_044A7
; @044A3 0000:44A3 original=81c750c0
    add di, 0C050h
; @044A7 0000:44A7 original=4d
    dec bp
; @044A8 0000:44A8 original=75e8
    JNE_SHORT loc_04492
; @044AA 0000:44AA original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @044AF 0000:44AF original=c3
    ret
; sub_0000_44B0
; @044B0 0000:44B0 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @044B5 0000:44B5 original=33ff
    xor di, di
; @044B7 0000:44B7 original=bdc800
    mov bp, 0C8h
; @044BA 0000:44BA original=b91a00
    mov cx, 01Ah
; @044BD 0000:44BD original=33c0
    xor ax, ax
; @044BF 0000:44BF original=f3ab
    rep stosw
; @044C1 0000:44C1 original=83ef34
    sub di, 034h
; @044C4 0000:44C4 original=81c70020
    add di, 02000h
; @044C8 0000:44C8 original=f7c70040
    test di, 04000h
; @044CC 0000:44CC original=7404
    JE_SHORT loc_044D2
; @044CE 0000:44CE original=81c750c0
    add di, 0C050h
; @044D2 0000:44D2 original=4d
    dec bp
; @044D3 0000:44D3 original=75e5
    JNE_SHORT loc_044BA
; @044D5 0000:44D5 original=c3
    ret
; @044D6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; sub_0000_44D7
; @044D7 0000:44D7 original=8b04
    mov ax, word ptr ds:[si]
; @044D9 0000:44D9 original=0b4402
    or ax, word ptr ds:[si + 2]
; @044DC 0000:44DC original=7501
    JNE_SHORT loc_044DF
; @044DE 0000:44DE original=c3
    ret
; @044DF 0000:44DF original=2e8b1ee00b
    mov bx, word ptr cs:[0BE0h]
; @044E4 0000:44E4 original=2e8306e00b02
    add word ptr cs:[0BE0h], 2
; @044EA 0000:44EA original=ad
    lodsw
; @044EB 0000:44EB original=2e833ed80b00
    cmp word ptr cs:[0BD8h], 0
; @044F1 0000:44F1 original=7404
    JE_SHORT loc_044F7
; @044F3 0000:44F3 original=2e893f
    mov word ptr cs:[bx], di
; @044F6 0000:44F6 original=ab
    stosw
; @044F7 0000:44F7 original=2ea39e5b
    mov word ptr cs:[05B9Eh], ax
; @044FB 0000:44FB original=ad
    lodsw
; @044FC 0000:44FC original=2e833ed80b00
    cmp word ptr cs:[0BD8h], 0
; @04502 0000:4502 original=7401
    JE_SHORT loc_04505
; @04504 0000:4504 original=ab
    stosw
; @04505 0000:4505 original=2ea39c5b
    mov word ptr cs:[05B9Ch], ax
; @04509 0000:4509 original=40
    inc ax
; @0450A 0000:450A original=c3
    ret
; @0450B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; sub_0000_450C
; @0450C 0000:450C original=e8c8ff
    CALL_NEAR loc_044D7
; @0450F 0000:450F original=7499
    JE_SHORT loc_044AA
; @04511 0000:4511 original=2e8b0e9e5b
    mov cx, word ptr cs:[05B9Eh]
; @04516 0000:4516 original=51
    push cx
; @04517 0000:4517 original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @0451C 0000:451C original=51
    push cx
; @0451D 0000:451D original=e81700
    CALL_NEAR loc_04537
; @04520 0000:4520 original=59
    pop cx
; @04521 0000:4521 original=e2f9
    LOOP_SHORT loc_0451C
; @04523 0000:4523 original=2e03369c5b
    add si, word ptr cs:[05B9Ch]
; @04528 0000:4528 original=2e03369c5b
    add si, word ptr cs:[05B9Ch]
; @0452D 0000:452D original=2e03369c5b
    add si, word ptr cs:[05B9Ch]
; @04532 0000:4532 original=59
    pop cx
; @04533 0000:4533 original=e2e1
    LOOP_SHORT loc_04516
; @04535 0000:4535 original=ebd5
    JMP_SHORT loc_0450C
; sub_0000_4537
; @04537 0000:4537 original=2e8b1e9c5b
    mov bx, word ptr cs:[05B9Ch]
; @0453C 0000:453C original=8a04
    mov al, byte ptr ds:[si]
; @0453E 0000:453E original=8a20
    mov ah, byte ptr ds:[bx + si]
; @04540 0000:4540 original=d1e3
    shl bx, 1
; @04542 0000:4542 original=8a10
    mov dl, byte ptr ds:[bx + si]
; @04544 0000:4544 original=2e031e9c5b
    add bx, word ptr cs:[05B9Ch]
; @04549 0000:4549 original=8a30
    mov dh, byte ptr ds:[bx + si]
; @0454B 0000:454B original=e8a800
    CALL_NEAR loc_045F6
; @0454E 0000:454E original=2e880e955b
    mov byte ptr cs:[05B95h], cl
; @04553 0000:4553 original=2e882e995b
    mov byte ptr cs:[05B99h], ch
; @04558 0000:4558 original=e89b00
    CALL_NEAR loc_045F6
; @0455B 0000:455B original=2e880e945b
    mov byte ptr cs:[05B94h], cl
; @04560 0000:4560 original=2e882e985b
    mov byte ptr cs:[05B98h], ch
; @04565 0000:4565 original=e88e00
    CALL_NEAR loc_045F6
; @04568 0000:4568 original=2e880e975b
    mov byte ptr cs:[05B97h], cl
; @0456D 0000:456D original=2e882e9b5b
    mov byte ptr cs:[05B9Bh], ch
; @04572 0000:4572 original=e88100
    CALL_NEAR loc_045F6
; @04575 0000:4575 original=2e880e965b
    mov byte ptr cs:[05B96h], cl
; @0457A 0000:457A original=2e882e9a5b
    mov byte ptr cs:[05B9Ah], ch
; @0457F 0000:457F original=46
    inc si
; @04580 0000:4580 original=2e833ed60b00
    cmp word ptr cs:[0BD6h], 0
; @04586 0000:4586 original=7421
    JE_SHORT loc_045A9
; @04588 0000:4588 original=2ea0985b
    mov al, byte ptr cs:[05B98h]
; @0458C 0000:458C original=e83c00
    CALL_NEAR loc_045CB
; @0458F 0000:458F original=2ea0995b
    mov al, byte ptr cs:[05B99h]
; @04593 0000:4593 original=e83500
    CALL_NEAR loc_045CB
; @04596 0000:4596 original=2ea09a5b
    mov al, byte ptr cs:[05B9Ah]
; @0459A 0000:459A original=e82e00
    CALL_NEAR loc_045CB
; @0459D 0000:459D original=2ea09b5b
    mov al, byte ptr cs:[05B9Bh]
; @045A1 0000:45A1 original=e82700
    CALL_NEAR loc_045CB
; @045A4 0000:45A4 original=2ea1e445
    mov ax, word ptr cs:[045E4h]
; @045A8 0000:45A8 original=ab
    stosw
; @045A9 0000:45A9 original=2ea0945b
    mov al, byte ptr cs:[05B94h]
; @045AD 0000:45AD original=e81b00
    CALL_NEAR loc_045CB
; @045B0 0000:45B0 original=2ea0955b
    mov al, byte ptr cs:[05B95h]
; @045B4 0000:45B4 original=e81400
    CALL_NEAR loc_045CB
; @045B7 0000:45B7 original=2ea0965b
    mov al, byte ptr cs:[05B96h]
; @045BB 0000:45BB original=e80d00
    CALL_NEAR loc_045CB
; @045BE 0000:45BE original=2ea0975b
    mov al, byte ptr cs:[05B97h]
; @045C2 0000:45C2 original=e80600
    CALL_NEAR loc_045CB
; @045C5 0000:45C5 original=2ea1e445
    mov ax, word ptr cs:[045E4h]
; @045C9 0000:45C9 original=ab
    stosw
; @045CA 0000:45CA original=c3
    ret
; sub_0000_45CB
; @045CB 0000:45CB original=e80000
    CALL_NEAR loc_045CE
; sub_0000_45CE
; @045CE 0000:45CE original=d0c0
    rol al, 1
; @045D0 0000:45D0 original=d0c0
    rol al, 1
; @045D2 0000:45D2 original=d0c0
    rol al, 1
; @045D4 0000:45D4 original=2ed116e445
    rcl word ptr cs:[045E4h],1
; @045D9 0000:45D9 original=d0c0
    rol al, 1
; @045DB 0000:45DB original=2ed116e445
    rcl word ptr cs:[045E4h],1
; @045E0 0000:45E0 original=c3
    ret
; @045E1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h,00h,01h,01h,01h,02h,02h,02h,01h,02h,01h,01h
; @045F1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,02h,02h,01h,03h
; sub_0000_45F6
; @045F6 0000:45F6 original=d0ce
    ror dh, 1
; @045F8 0000:45F8 original=d0d1
    rcl cl, 1
; @045FA 0000:45FA original=d0ca
    ror dl, 1
; @045FC 0000:45FC original=d0d1
    rcl cl, 1
; @045FE 0000:45FE original=d0cc
    ror ah, 1
; @04600 0000:4600 original=d0d1
    rcl cl, 1
; @04602 0000:4602 original=d0c8
    ror al, 1
; @04604 0000:4604 original=d0d1
    rcl cl, 1
; @04606 0000:4606 original=d0ce
    ror dh, 1
; @04608 0000:4608 original=d0d1
    rcl cl, 1
; @0460A 0000:460A original=d0ca
    ror dl, 1
; @0460C 0000:460C original=d0d1
    rcl cl, 1
; @0460E 0000:460E original=d0cc
    ror ah, 1
; @04610 0000:4610 original=d0d1
    rcl cl, 1
; @04612 0000:4612 original=d0c8
    ror al, 1
; @04614 0000:4614 original=d0d1
    rcl cl, 1
; @04616 0000:4616 original=d0c9
    ror cl, 1
; @04618 0000:4618 original=d0c9
    ror cl, 1
; @0461A 0000:461A original=d0c9
    ror cl, 1
; @0461C 0000:461C original=d0c9
    ror cl, 1
; @0461E 0000:461E original=2e833ed60b00
    cmp word ptr cs:[0BD6h], 0
; @04624 0000:4624 original=7430
    JE_SHORT loc_04656
; @04626 0000:4626 original=8bd8
    mov bx, ax
; @04628 0000:4628 original=32ed
    xor ch, ch
; @0462A 0000:462A original=8ac1
    mov al, cl
; @0462C 0000:462C original=240f
    and al, 0Fh
; @0462E 0000:462E original=2e3a060000
    cmp al, byte ptr cs:[0]
; @04633 0000:4633 original=7506
    JNE_SHORT loc_0463B
; @04635 0000:4635 original=80cd0f
    or ch, 0Fh
; @04638 0000:4638 original=80e1f0
    and cl, 0F0h
; @0463B 0000:463B original=8ac1
    mov al, cl
; @0463D 0000:463D original=24f0
    and al, 0F0h
; @0463F 0000:463F original=d0e8
    shr al, 1
; @04641 0000:4641 original=d0e8
    shr al, 1
; @04643 0000:4643 original=d0e8
    shr al, 1
; @04645 0000:4645 original=d0e8
    shr al, 1
; @04647 0000:4647 original=2e3a060000
    cmp al, byte ptr cs:[0]
; @0464C 0000:464C original=7506
    JNE_SHORT loc_04654
; @0464E 0000:464E original=80cdf0
    or ch, 0F0h
; @04651 0000:4651 original=80e10f
    and cl, 0Fh
; @04654 0000:4654 original=8bc3
    mov ax, bx
; @04656 0000:4656 original=2ea3e245
    mov word ptr cs:[045E2h], ax
; @0465A 0000:465A original=8ac1
    mov al, cl
; @0465C 0000:465C original=240f
    and al, 0Fh
; @0465E 0000:465E original=bbe645
    mov bx, 045E6h
; @04661 0000:4661 original=2ed7
    db 02Eh ; decoded segment override
    xlat
; @04663 0000:4663 original=8ae0
    mov ah, al
; @04665 0000:4665 original=8ac1
    mov al, cl
; @04667 0000:4667 original=d0e8
    shr al, 1
; @04669 0000:4669 original=d0e8
    shr al, 1
; @0466B 0000:466B original=d0e8
    shr al, 1
; @0466D 0000:466D original=d0e8
    shr al, 1
; @0466F 0000:466F original=240f
    and al, 0Fh
; @04671 0000:4671 original=2ed7
    db 02Eh ; decoded segment override
    xlat
; @04673 0000:4673 original=d0e0
    shl al, 1
; @04675 0000:4675 original=d0e0
    shl al, 1
; @04677 0000:4677 original=d0e0
    shl al, 1
; @04679 0000:4679 original=d0e0
    shl al, 1
; @0467B 0000:467B original=0ac4
    or al, ah
; @0467D 0000:467D original=8ac8
    mov cl, al
; @0467F 0000:467F original=2ea1e245
    mov ax, word ptr cs:[045E2h]
; @04683 0000:4683 original=c3
    ret
; @04684 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FFh,0FFh,074h,03h,0E8h,010h,00h,08Bh,07Eh,010h,08Bh,076h,0Eh,081h,0C6h
; @04694 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,01h,083h,0FFh,0FFh,075h,01h,0C3h,0B9h,010h,00h,0A5h,0A5h,0A5h,0A5h,0A4h
; @046A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C7h,02Bh,0E2h,0F6h,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0A5h,0A5h,0A4h,083h
; @046B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h
; @046C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh
; @046D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h
; @046E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h
; @046F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh
; @04704 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,0A5h,0A4h,083h,0C7h,02Fh,0A5h,0A5h,0A4h,083h,0C7h,02Fh,0C3h,083h,0FFh,0FFh
; @04714 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,01h,0C3h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h
; @04724 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h
; @04734 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 031h,0A5h,0A4h,083h,0C7h,031h,0A5h,0A4h,083h,0C7h,031h,0C3h,0E8h,0F3h,012h,089h
; @04744 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,0Ch,03Dh,0FFh,0FFh,074h,0Fh,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h
; @04754 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,07Eh,0Eh,0E8h,024h,00h,083h,046h,02h,010h,0E8h,0D5h,012h,089h,046h,010h
; @04764 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,06Eh,02h,010h,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h
; @04774 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,08Bh,0F0h,08Bh,07Eh,0Eh,081h,0C7h,040h,01h,02Eh,08Eh,06h,096h,095h,02Eh
; @04784 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,098h,095h,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @04794 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @047A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @047B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @047C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @047D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @047E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @047F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h,0A4h,083h,0C6h,02Bh,0A5h,0A5h,0A5h,0A5h
; @04804 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Bh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,025h,012h,089h,046h,0Ch
; @04814 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh
; @04824 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,0Eh,02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0A5h,0A5h,0A4h,083h
; @04834 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h
; @04844 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh
; @04854 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h
; @04864 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h
; @04874 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh
; @04884 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,0A5h,0A4h,083h,0C6h,02Fh,0A5h,0A5h,0A4h,083h,0C6h,02Fh,02Eh,08Eh,01Eh,096h
; @04894 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0C3h,0E8h,09Dh,011h,089h,046h,0Ch,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h
; @048A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh,02Eh,08Eh,06h,096h,095h,02Eh
; @048B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,098h,095h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h
; @048C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h
; @048D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,031h,0A5h,0A4h,083h,0C6h,031h,0A5h,0A4h,083h,0C6h,031h,02Eh,08Eh,01Eh,096h
; @048E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0C3h
; sub_0000_48E6
; @048E6 0000:48E6 original=8bda
    mov bx, dx
; @048E8 0000:48E8 original=b90d00
    mov cx, 0Dh
; @048EB 0000:48EB original=2ea19a95
    mov ax, word ptr cs:[0959Ah]
; @048EF 0000:48EF original=813e50235f0e
    cmp word ptr ds:[02350h], 0E5Fh
; @048F5 0000:48F5 original=7204
    JB_SHORT loc_048FB
; @048F7 0000:48F7 original=2ea19c95
    mov ax, word ptr cs:[0959Ch]
; @048FB 0000:48FB original=8ed8
    mov ds, ax
; @048FD 0000:48FD original=51
    push cx
; @048FE 0000:48FE original=53
    push bx
; @048FF 0000:48FF original=2e8e069295
    mov es, word ptr cs:[09592h]
; @04904 0000:4904 original=268a1f
    mov bl, byte ptr es:[bx]
; @04907 0000:4907 original=fecb
    dec bl
; @04909 0000:4909 original=32ff
    xor bh, bh
; @0490B 0000:490B original=d1e3
    shl bx, 1
; @0490D 0000:490D original=81c3928d
    add bx, 08D92h
; @04911 0000:4911 original=2e8b37
    mov si, word ptr cs:[bx]
; @04914 0000:4914 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @04919 0000:4919 original=a5
    movsw
; @0491A 0000:491A original=a5
    movsw
; @0491B 0000:491B original=83c730
    add di, 030h
; @0491E 0000:491E original=a5
    movsw
; @0491F 0000:491F original=a5
    movsw
; @04920 0000:4920 original=83c730
    add di, 030h
; @04923 0000:4923 original=a5
    movsw
; @04924 0000:4924 original=a5
    movsw
; @04925 0000:4925 original=83c730
    add di, 030h
; @04928 0000:4928 original=a5
    movsw
; @04929 0000:4929 original=a5
    movsw
; @0492A 0000:492A original=83c730
    add di, 030h
; @0492D 0000:492D original=a5
    movsw
; @0492E 0000:492E original=a5
    movsw
; @0492F 0000:492F original=83c730
    add di, 030h
; @04932 0000:4932 original=a5
    movsw
; @04933 0000:4933 original=a5
    movsw
; @04934 0000:4934 original=83c730
    add di, 030h
; @04937 0000:4937 original=a5
    movsw
; @04938 0000:4938 original=a5
    movsw
; @04939 0000:4939 original=83c730
    add di, 030h
; @0493C 0000:493C original=a5
    movsw
; @0493D 0000:493D original=a5
    movsw
; @0493E 0000:493E original=83c730
    add di, 030h
; @04941 0000:4941 original=a5
    movsw
; @04942 0000:4942 original=a5
    movsw
; @04943 0000:4943 original=83c730
    add di, 030h
; @04946 0000:4946 original=a5
    movsw
; @04947 0000:4947 original=a5
    movsw
; @04948 0000:4948 original=83c730
    add di, 030h
; @0494B 0000:494B original=a5
    movsw
; @0494C 0000:494C original=a5
    movsw
; @0494D 0000:494D original=83c730
    add di, 030h
; @04950 0000:4950 original=a5
    movsw
; @04951 0000:4951 original=a5
    movsw
; @04952 0000:4952 original=83c730
    add di, 030h
; @04955 0000:4955 original=a5
    movsw
; @04956 0000:4956 original=a5
    movsw
; @04957 0000:4957 original=83c730
    add di, 030h
; @0495A 0000:495A original=a5
    movsw
; @0495B 0000:495B original=a5
    movsw
; @0495C 0000:495C original=83c730
    add di, 030h
; @0495F 0000:495F original=a5
    movsw
; @04960 0000:4960 original=a5
    movsw
; @04961 0000:4961 original=83c730
    add di, 030h
; @04964 0000:4964 original=a5
    movsw
; @04965 0000:4965 original=a5
    movsw
; @04966 0000:4966 original=83c730
    add di, 030h
; @04969 0000:4969 original=81ef3c03
    sub di, 033Ch
; @0496D 0000:496D original=5b
    pop bx
; @0496E 0000:496E original=83c301
    add bx, 1
; @04971 0000:4971 original=59
    pop cx
; @04972 0000:4972 original=e289
    LOOP_SHORT loc_048FD
; @04974 0000:4974 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @04979 0000:4979 original=c3
    ret
; sub_0000_497A
; @0497A 0000:497A original=2ec70603590000
    mov word ptr cs:[05903h], 0
; @04981 0000:4981 original=2e8b3ef958
    mov di, word ptr cs:[058F9h]
; @04986 0000:4986 original=2e8b36fb58
    mov si, word ptr cs:[058FBh]
; @0498B 0000:498B original=2e8b0efd58
    mov cx, word ptr cs:[058FDh]
; @04990 0000:4990 original=2e8b2eff58
    mov bp, word ptr cs:[058FFh]
; @04995 0000:4995 original=d1e5
    shl bp, 1
; @04997 0000:4997 original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @0499D 0000:499D original=7408
    JE_SHORT loc_049A7
; @0499F 0000:499F original=8bc5
    mov ax, bp
; @049A1 0000:49A1 original=49
    dec cx
; @049A2 0000:49A2 original=f7e1
    mul cx
; @049A4 0000:49A4 original=41
    inc cx
; @049A5 0000:49A5 original=03f0
    add si, ax
; @049A7 0000:49A7 original=51
    push cx
; @049A8 0000:49A8 original=2e8b0efd58
    mov cx, word ptr cs:[058FDh]
; @049AD 0000:49AD original=2e2b0e0159
    sub cx, word ptr cs:[05901h]
; @049B2 0000:49B2 original=0bc9
    or cx, cx
; @049B4 0000:49B4 original=782d
    JS_SHORT loc_049E3
; @049B6 0000:49B6 original=d1e9
    shr cx, 1
; @049B8 0000:49B8 original=e329
    JCXZ_SHORT loc_049E3
; @049BA 0000:49BA original=49
    dec cx
; @049BB 0000:49BB original=e310
    JCXZ_SHORT loc_049CD
; @049BD 0000:49BD original=81c70020
    add di, 02000h
; @049C1 0000:49C1 original=f7c70040
    test di, 04000h
; @049C5 0000:49C5 original=7404
    JE_SHORT loc_049CB
; @049C7 0000:49C7 original=81c750c0
    add di, 0C050h
; @049CB 0000:49CB original=e2f0
    LOOP_SHORT loc_049BD
; @049CD 0000:49CD original=32c0
    xor al, al
; @049CF 0000:49CF original=8bcd
    mov cx, bp
; @049D1 0000:49D1 original=f3aa
    rep stosb
; @049D3 0000:49D3 original=2bfd
    sub di, bp
; @049D5 0000:49D5 original=81c70020
    add di, 02000h
; @049D9 0000:49D9 original=f7c70040
    test di, 04000h
; @049DD 0000:49DD original=7404
    JE_SHORT loc_049E3
; @049DF 0000:49DF original=81c750c0
    add di, 0C050h
; @049E3 0000:49E3 original=59
    pop cx
; @049E4 0000:49E4 original=2ea10159
    mov ax, word ptr cs:[05901h]
; @049E8 0000:49E8 original=2e3b06fd58
    cmp ax, word ptr cs:[058FDh]
; @049ED 0000:49ED original=7427
    JE_SHORT loc_04A16
; @049EF 0000:49EF original=2e01060359
    add word ptr cs:[05903h], ax
; @049F4 0000:49F4 original=2ea1fd58
    mov ax, word ptr cs:[058FDh]
; @049F8 0000:49F8 original=2e3b060359
    cmp ax, word ptr cs:[05903h]
; @049FD 0000:49FD original=7712
    JA_SHORT loc_04A11
; @049FF 0000:49FF original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @04A05 0000:4A05 original=7404
    JE_SHORT loc_04A0B
; @04A07 0000:4A07 original=2bf5
    sub si, bp
; @04A09 0000:4A09 original=eb02
    JMP_SHORT loc_04A0D
; @04A0B 0000:4A0B original=03f5
    add si, bp
; @04A0D 0000:4A0D original=e2d5
    LOOP_SHORT loc_049E4
; @04A0F 0000:4A0F original=eb29
    JMP_SHORT loc_04A3A
; @04A11 0000:4A11 original=2e29060359
    sub word ptr cs:[05903h], ax
; @04A16 0000:4A16 original=51
    push cx
; @04A17 0000:4A17 original=8bcd
    mov cx, bp
; @04A19 0000:4A19 original=f3a4
    rep movsb
; @04A1B 0000:4A1B original=2bfd
    sub di, bp
; @04A1D 0000:4A1D original=81c70020
    add di, 02000h
; @04A21 0000:4A21 original=f7c70040
    test di, 04000h
; @04A25 0000:4A25 original=7404
    JE_SHORT loc_04A2B
; @04A27 0000:4A27 original=81c750c0
    add di, 0C050h
; @04A2B 0000:4A2B original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @04A31 0000:4A31 original=7404
    JE_SHORT loc_04A37
; @04A33 0000:4A33 original=2bf5
    sub si, bp
; @04A35 0000:4A35 original=2bf5
    sub si, bp
; @04A37 0000:4A37 original=59
    pop cx
; @04A38 0000:4A38 original=e2aa
    LOOP_SHORT loc_049E4
; @04A3A 0000:4A3A original=32c0
    xor al, al
; @04A3C 0000:4A3C original=8bcd
    mov cx, bp
; @04A3E 0000:4A3E original=f3aa
    rep stosb
; @04A40 0000:4A40 original=c3
    ret
; sub_0000_4A41
; @04A41 0000:4A41 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @04A46 0000:4A46 original=b92800
    mov cx, 028h
; @04A49 0000:4A49 original=f3a5
    rep movsw
; @04A4B 0000:4A4B original=83ef50
    sub di, 050h
; @04A4E 0000:4A4E original=81c70020
    add di, 02000h
; @04A52 0000:4A52 original=f7c70040
    test di, 04000h
; @04A56 0000:4A56 original=7404
    JE_SHORT loc_04A5C
; @04A58 0000:4A58 original=81c750c0
    add di, 0C050h
; @04A5C 0000:4A5C original=4d
    dec bp
; @04A5D 0000:4A5D original=75e7
    JNE_SHORT loc_04A46
; @04A5F 0000:4A5F original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @04A64 0000:4A64 original=c3
    ret
; sub_0000_4A65
; @04A65 0000:4A65 original=57
    push di
; @04A66 0000:4A66 original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @04A6A 0000:4A6A original=d1e3
    shl bx, 1
; @04A6C 0000:4A6C original=8b9fe9c5
    mov bx, word ptr ds:[bx - 03A17h]
; @04A70 0000:4A70 original=8b37
    mov si, word ptr ds:[bx]
; @04A72 0000:4A72 original=ad
    lodsw
; @04A73 0000:4A73 original=a3a420
    mov word ptr ds:[020A4h], ax
; @04A76 0000:4A76 original=3dffff
    cmp ax, 0FFFFh
; @04A79 0000:4A79 original=7503
    JNE_SHORT loc_04A7E
; @04A7B 0000:4A7B original=e9f601
    JMP_NEAR loc_04C74
; @04A7E 0000:4A7E original=3b0678a9
    cmp ax, word ptr ds:[0A978h]
; @04A82 0000:4A82 original=7403
    JE_SHORT loc_04A87
; @04A84 0000:4A84 original=e9ed01
    JMP_NEAR loc_04C74
; @04A87 0000:4A87 original=c606a22001
    mov byte ptr ds:[020A2h], 1
; @04A8C 0000:4A8C original=ad
    lodsw
; @04A8D 0000:4A8D original=3dffff
    cmp ax, 0FFFFh
; @04A90 0000:4A90 original=7506
    JNE_SHORT loc_04A98
; @04A92 0000:4A92 original=c606a22000
    mov byte ptr ds:[020A2h], 0
; @04A97 0000:4A97 original=ad
    lodsw
; @04A98 0000:4A98 original=8bc8
    mov cx, ax
; @04A9A 0000:4A9A original=ad
    lodsw
; @04A9B 0000:4A9B original=a36c20
    mov word ptr ds:[0206Ch], ax
; @04A9E 0000:4A9E original=ad
    lodsw
; @04A9F 0000:4A9F original=a36e20
    mov word ptr ds:[0206Eh], ax
; @04AA2 0000:4AA2 original=53
    push bx
; @04AA3 0000:4AA3 original=8b1ea420
    mov bx, word ptr ds:[020A4h]
; @04AA7 0000:4AA7 original=83e33f
    and bx, 03Fh
; @04AAA 0000:4AAA original=8a9f1ac8
    mov bl, byte ptr ds:[bx - 037E6h]
; @04AAE 0000:4AAE original=32ff
    xor bh, bh
; @04AB0 0000:4AB0 original=8bc3
    mov ax, bx
; @04AB2 0000:4AB2 original=5b
    pop bx
; @04AB3 0000:4AB3 original=a37020
    mov word ptr ds:[02070h], ax
; @04AB6 0000:4AB6 original=8937
    mov word ptr ds:[bx], si
; @04AB8 0000:4AB8 original=8bf1
    mov si, cx
; @04ABA 0000:4ABA original=ad
    lodsw
; @04ABB 0000:4ABB original=a37220
    mov word ptr ds:[02072h], ax
; @04ABE 0000:4ABE original=ad
    lodsw
; @04ABF 0000:4ABF original=a37420
    mov word ptr ds:[02074h], ax
; @04AC2 0000:4AC2 original=ad
    lodsw
; @04AC3 0000:4AC3 original=a37620
    mov word ptr ds:[02076h], ax
; @04AC6 0000:4AC6 original=ad
    lodsw
; @04AC7 0000:4AC7 original=8bc8
    mov cx, ax
; @04AC9 0000:4AC9 original=9a63017f0f
    CALL_FAR 0F7Fh,0163h
; @04ACE 0000:4ACE original=51
    push cx
; @04ACF 0000:4ACF original=e8522a
    CALL_NEAR FindFreeRecordPoolA_07524
; @04AD2 0000:4AD2 original=83fbff
    cmp bx, -1
; @04AD5 0000:4AD5 original=7503
    JNE_SHORT loc_04ADA
; @04AD7 0000:4AD7 original=e99601
    JMP_NEAR loc_04C70
; @04ADA 0000:4ADA original=b8ffff
    mov ax, 0FFFFh
; @04ADD 0000:4ADD original=833e9a20ff
    cmp word ptr ds:[0209Ah], -1
; @04AE2 0000:4AE2 original=7411
    JE_SHORT loc_04AF5
; @04AE4 0000:4AE4 original=53
    push bx
; @04AE5 0000:4AE5 original=8b1e9a20
    mov bx, word ptr ds:[0209Ah]
; @04AE9 0000:4AE9 original=fe07
    inc byte ptr ds:[bx]
; @04AEB 0000:4AEB original=a07020
    mov al, byte ptr ds:[02070h]
; @04AEE 0000:4AEE original=884701
    mov byte ptr ds:[bx + 1], al
; @04AF1 0000:4AF1 original=5b
    pop bx
; @04AF2 0000:4AF2 original=a19820
    mov ax, word ptr ds:[02098h]
; @04AF5 0000:4AF5 original=894728
    mov word ptr ds:[bx + 028h], ax
; @04AF8 0000:4AF8 original=c7070100
    mov word ptr ds:[bx], 1
; @04AFC 0000:4AFC original=a17420
    mov ax, word ptr ds:[02074h]
; @04AFF 0000:4AFF original=89470a
    mov word ptr ds:[bx + 0Ah], ax
; @04B02 0000:4B02 original=c747080000
    mov word ptr ds:[bx + 8], 0
; @04B07 0000:4B07 original=8b4402
    mov ax, word ptr ds:[si + 2]
; @04B0A 0000:4B0A original=03066e20
    add ax, word ptr ds:[0206Eh]
; @04B0E 0000:4B0E original=894702
    mov word ptr ds:[bx + 2], ax
; @04B11 0000:4B11 original=8b04
    mov ax, word ptr ds:[si]
; @04B13 0000:4B13 original=03066c20
    add ax, word ptr ds:[0206Ch]
; @04B17 0000:4B17 original=894704
    mov word ptr ds:[bx + 4], ax
; @04B1A 0000:4B1A original=894732
    mov word ptr ds:[bx + 032h], ax
; @04B1D 0000:4B1D original=c747340000
    mov word ptr ds:[bx + 034h], 0
; @04B22 0000:4B22 original=c747060400
    mov word ptr ds:[bx + 6], 4
; @04B27 0000:4B27 original=a17220
    mov ax, word ptr ds:[02072h]
; @04B2A 0000:4B2A original=894714
    mov word ptr ds:[bx + 014h], ax
; @04B2D 0000:4B2D original=c747160400
    mov word ptr ds:[bx + 016h], 4
; @04B32 0000:4B32 original=a17620
    mov ax, word ptr ds:[02076h]
; @04B35 0000:4B35 original=894718
    mov word ptr ds:[bx + 018h], ax
; @04B38 0000:4B38 original=837f0a01
    cmp word ptr ds:[bx + 0Ah], 1
; @04B3C 0000:4B3C original=7503
    JNE_SHORT loc_04B41
; @04B3E 0000:4B3E original=e9a600
    JMP_NEAR loc_04BE7
; @04B41 0000:4B41 original=837f1401
    cmp word ptr ds:[bx + 014h], 1
; @04B45 0000:4B45 original=7403
    JE_SHORT loc_04B4A
; @04B47 0000:4B47 original=e99d00
    JMP_NEAR loc_04BE7
; @04B4A 0000:4B4A original=836702f0
    and word ptr ds:[bx + 2], 0FFF0h
; @04B4E 0000:4B4E original=836704f0
    and word ptr ds:[bx + 4], 0FFF0h
; @04B52 0000:4B52 original=8b4704
    mov ax, word ptr ds:[bx + 4]
; @04B55 0000:4B55 original=a3a020
    mov word ptr ds:[020A0h], ax
; @04B58 0000:4B58 original=d1e8
    shr ax, 1
; @04B5A 0000:4B5A original=d1e8
    shr ax, 1
; @04B5C 0000:4B5C original=d1e8
    shr ax, 1
; @04B5E 0000:4B5E original=d1e8
    shr ax, 1
; @04B60 0000:4B60 original=a39c20
    mov word ptr ds:[0209Ch], ax
; @04B63 0000:4B63 original=56
    push si
; @04B64 0000:4B64 original=53
    push bx
; @04B65 0000:4B65 original=2e8e069295
    mov es, word ptr cs:[09592h]
; @04B6A 0000:4B6A original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @04B6D 0000:4B6D original=8b1e5023
    mov bx, word ptr ds:[02350h]
; @04B71 0000:4B71 original=83c30d
    add bx, 0Dh
; @04B74 0000:4B74 original=0bc0
    or ax, ax
; @04B76 0000:4B76 original=741a
    JE_SHORT loc_04B92
; @04B78 0000:4B78 original=780c
    JS_SHORT loc_04B86
; @04B7A 0000:4B7A original=0bc0
    or ax, ax
; @04B7C 0000:4B7C original=7414
    JE_SHORT loc_04B92
; @04B7E 0000:4B7E original=83eb0d
    sub bx, 0Dh
; @04B81 0000:4B81 original=2d1000
    sub ax, 010h
; @04B84 0000:4B84 original=ebf4
    JMP_SHORT loc_04B7A
; @04B86 0000:4B86 original=0bc0
    or ax, ax
; @04B88 0000:4B88 original=7408
    JE_SHORT loc_04B92
; @04B8A 0000:4B8A original=83c30d
    add bx, 0Dh
; @04B8D 0000:4B8D original=051000
    add ax, 010h
; @04B90 0000:4B90 original=ebf4
    JMP_SHORT loc_04B86
; @04B92 0000:4B92 original=891e9e20
    mov word ptr ds:[0209Eh], bx
; @04B96 0000:4B96 original=8b369e20
    mov si, word ptr ds:[0209Eh]
; @04B9A 0000:4B9A original=a19c20
    mov ax, word ptr ds:[0209Ch]
; @04B9D 0000:4B9D original=03f0
    add si, ax
; @04B9F 0000:4B9F original=268a04
    mov al, byte ptr es:[si]
; @04BA2 0000:4BA2 original=bbaac3
    mov bx, 0C3AAh
; @04BA5 0000:4BA5 original=d7
    xlat
; @04BA6 0000:4BA6 original=0ac0
    or al, al
; @04BA8 0000:4BA8 original=742d
    JE_SHORT loc_04BD7
; @04BAA 0000:4BAA original=833ea02060
    cmp word ptr ds:[020A0h], 060h
; @04BAF 0000:4BAF original=7213
    JB_SHORT loc_04BC4
; @04BB1 0000:4BB1 original=ff0e9c20
    dec word ptr ds:[0209Ch]
; @04BB5 0000:4BB5 original=833e9c20ff
    cmp word ptr ds:[0209Ch], -1
; @04BBA 0000:4BBA original=75da
    JNE_SHORT loc_04B96
; @04BBC 0000:4BBC original=c7069c200c00
    mov word ptr ds:[0209Ch], 0Ch
; @04BC2 0000:4BC2 original=ebd2
    JMP_SHORT loc_04B96
; @04BC4 0000:4BC4 original=ff069c20
    inc word ptr ds:[0209Ch]
; @04BC8 0000:4BC8 original=833e9c200d
    cmp word ptr ds:[0209Ch], 0Dh
; @04BCD 0000:4BCD original=7206
    JB_SHORT loc_04BD5
; @04BCF 0000:4BCF original=c7069c200000
    mov word ptr ds:[0209Ch], 0
; @04BD5 0000:4BD5 original=ebbf
    JMP_SHORT loc_04B96
; @04BD7 0000:4BD7 original=a19c20
    mov ax, word ptr ds:[0209Ch]
; @04BDA 0000:4BDA original=d1e0
    shl ax, 1
; @04BDC 0000:4BDC original=d1e0
    shl ax, 1
; @04BDE 0000:4BDE original=d1e0
    shl ax, 1
; @04BE0 0000:4BE0 original=d1e0
    shl ax, 1
; @04BE2 0000:4BE2 original=5b
    pop bx
; @04BE3 0000:4BE3 original=894704
    mov word ptr ds:[bx + 4], ax
; @04BE6 0000:4BE6 original=5e
    pop si
; @04BE7 0000:4BE7 original=c747200100
    mov word ptr ds:[bx + 020h], 1
; @04BEC 0000:4BEC original=a15623
    mov ax, word ptr ds:[02356h]
; @04BEF 0000:4BEF original=40
    inc ax
; @04BF0 0000:4BF0 original=894720
    mov word ptr ds:[bx + 020h], ax
; @04BF3 0000:4BF3 original=837f1401
    cmp word ptr ds:[bx + 014h], 1
; @04BF7 0000:4BF7 original=7405
    JE_SHORT loc_04BFE
; @04BF9 0000:4BF9 original=c747200c00
    mov word ptr ds:[bx + 020h], 0Ch
; @04BFE 0000:4BFE original=c747240000
    mov word ptr ds:[bx + 024h], 0
; @04C03 0000:4C03 original=837f1821
    cmp word ptr ds:[bx + 018h], 021h
; @04C07 0000:4C07 original=7505
    JNE_SHORT loc_04C0E
; @04C09 0000:4C09 original=9a09027f0f
    CALL_FAR 0F7Fh,0209h
; @04C0E 0000:4C0E original=b884a4
    mov ax, 0A484h
; @04C11 0000:4C11 original=837f1813
    cmp word ptr ds:[bx + 018h], 013h
; @04C15 0000:4C15 original=7505
    JNE_SHORT loc_04C1C
; @04C17 0000:4C17 original=9a09027f0f
    CALL_FAR 0F7Fh,0209h
; @04C1C 0000:4C1C original=b8e8a4
    mov ax, 0A4E8h
; @04C1F 0000:4C1F original=837f1815
    cmp word ptr ds:[bx + 018h], 015h
; @04C23 0000:4C23 original=7505
    JNE_SHORT loc_04C2A
; @04C25 0000:4C25 original=9a09027f0f
    CALL_FAR 0F7Fh,0209h
; @04C2A 0000:4C2A original=b8a2a7
    mov ax, 0A7A2h
; @04C2D 0000:4C2D original=837f181c
    cmp word ptr ds:[bx + 018h], 01Ch
; @04C31 0000:4C31 original=7505
    JNE_SHORT loc_04C38
; @04C33 0000:4C33 original=9a09027f0f
    CALL_FAR 0F7Fh,0209h
; @04C38 0000:4C38 original=b82ea8
    mov ax, 0A82Eh
; @04C3B 0000:4C3B original=837f181f
    cmp word ptr ds:[bx + 018h], 01Fh
; @04C3F 0000:4C3F original=7505
    JNE_SHORT loc_04C46
; @04C41 0000:4C41 original=9a09027f0f
    CALL_FAR 0F7Fh,0209h
; @04C46 0000:4C46 original=b838a6
    mov ax, 0A638h
; @04C49 0000:4C49 original=837f187d
    cmp word ptr ds:[bx + 018h], 07Dh
; @04C4D 0000:4C4D original=7505
    JNE_SHORT loc_04C54
; @04C4F 0000:4C4F original=9a09027f0f
    CALL_FAR 0F7Fh,0209h
; @04C54 0000:4C54 original=b8f4a6
    mov ax, 0A6F4h
; @04C57 0000:4C57 original=837f187e
    cmp word ptr ds:[bx + 018h], 07Eh
; @04C5B 0000:4C5B original=7505
    JNE_SHORT loc_04C62
; @04C5D 0000:4C5D original=9a09027f0f
    CALL_FAR 0F7Fh,0209h
; @04C62 0000:4C62 original=83c604
    add si, 4
; @04C65 0000:4C65 original=59
    pop cx
; @04C66 0000:4C66 original=e202
    LOOP_SHORT loc_04C6A
; @04C68 0000:4C68 original=eb03
    JMP_SHORT loc_04C6D
; @04C6A 0000:4C6A original=e961fe
    JMP_NEAR loc_04ACE
; @04C6D 0000:4C6D original=e9f6fd
    JMP_NEAR loc_04A66
; @04C70 0000:4C70 original=59
    pop cx
; @04C71 0000:4C71 original=e9f2fd
    JMP_NEAR loc_04A66
; @04C74 0000:4C74 original=5f
    pop di
; @04C75 0000:4C75 original=c3
    ret
; sub_0000_4C76
; @04C76 0000:4C76 original=bec1c6
    mov si, 0C6C1h
; @04C79 0000:4C79 original=b92800
    mov cx, 028h
; @04C7C 0000:4C7C original=ad
    lodsw
; @04C7D 0000:4C7D original=ad
    lodsw
; @04C7E 0000:4C7E original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @04C83 0000:4C83 original=d1e3
    shl bx, 1
; @04C85 0000:4C85 original=2effa78a4c
    jmp word ptr cs:[bx + 04C8Ah]
; @04C8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,04Ch,0A6h,04Ch,0BEh,04Ch
; sub_0000_4C90
; @04C90 0000:4C90 original=8bd8
    mov bx, ax
; @04C92 0000:4C92 original=d1e8
    shr ax, 1
; @04C94 0000:4C94 original=d1e8
    shr ax, 1
; @04C96 0000:4C96 original=8944fe
    mov word ptr ds:[si - 2], ax
; @04C99 0000:4C99 original=83e303
    and bx, 3
; @04C9C 0000:4C9C original=81c303c8
    add bx, 0C803h
; @04CA0 0000:4CA0 original=8b1f
    mov bx, word ptr ds:[bx]
; @04CA2 0000:4CA2 original=891c
    mov word ptr ds:[si], bx
; @04CA4 0000:4CA4 original=eb41
    JMP_SHORT loc_04CE7
; sub_0000_4CA6
; @04CA6 0000:4CA6 original=8bd8
    mov bx, ax
; @04CA8 0000:4CA8 original=d1e8
    shr ax, 1
; @04CAA 0000:4CAA original=d1e8
    shr ax, 1
; @04CAC 0000:4CAC original=d1e8
    shr ax, 1
; @04CAE 0000:4CAE original=8944fe
    mov word ptr ds:[si - 2], ax
; @04CB1 0000:4CB1 original=83e307
    and bx, 7
; @04CB4 0000:4CB4 original=81c307c8
    add bx, 0C807h
; @04CB8 0000:4CB8 original=8b1f
    mov bx, word ptr ds:[bx]
; @04CBA 0000:4CBA original=891c
    mov word ptr ds:[si], bx
; @04CBC 0000:4CBC original=eb29
    JMP_SHORT loc_04CE7
; sub_0000_4CBE
; @04CBE 0000:4CBE original=8bd8
    mov bx, ax
; @04CC0 0000:4CC0 original=d1e8
    shr ax, 1
; @04CC2 0000:4CC2 original=8944fe
    mov word ptr ds:[si - 2], ax
; @04CC5 0000:4CC5 original=83e301
    and bx, 1
; @04CC8 0000:4CC8 original=81c30fc8
    add bx, 0C80Fh
; @04CCC 0000:4CCC original=8b1f
    mov bx, word ptr ds:[bx]
; @04CCE 0000:4CCE original=891c
    mov word ptr ds:[si], bx
; @04CD0 0000:4CD0 original=833e18c800
    cmp word ptr ds:[0C818h], 0
; @04CD5 0000:4CD5 original=7410
    JE_SHORT loc_04CE7
; @04CD7 0000:4CD7 original=ff0e18c8
    dec word ptr ds:[0C818h]
; @04CDB 0000:4CDB original=750a
    JNE_SHORT loc_04CE7
; @04CDD 0000:4CDD original=80260fc807
    and byte ptr ds:[0C80Fh], 7
; @04CE2 0000:4CE2 original=802610c870
    and byte ptr ds:[0C810h], 070h
; @04CE7 0000:4CE7 original=83c602
    add si, 2
; @04CEA 0000:4CEA original=e290
    LOOP_SHORT loc_04C7C
; @04CEC 0000:4CEC original=c3
    ret
; sub_0000_4CED
; @04CED 0000:4CED original=2e8e069895
    mov es, word ptr cs:[09598h]
; @04CF2 0000:4CF2 original=bec1c6
    mov si, 0C6C1h
; @04CF5 0000:4CF5 original=bfb1c7
    mov di, 0C7B1h
; @04CF8 0000:4CF8 original=bd4d4d
    mov bp, 04D4Dh
; @04CFB 0000:4CFB original=b91400
    mov cx, 014h
; @04CFE 0000:4CFE original=e81400
    CALL_NEAR loc_04D15
; @04D01 0000:4D01 original=bd514d
    mov bp, 04D51h
; @04D04 0000:4D04 original=b90a00
    mov cx, 0Ah
; @04D07 0000:4D07 original=e80b00
    CALL_NEAR loc_04D15
; @04D0A 0000:4D0A original=b90a00
    mov cx, 0Ah
; @04D0D 0000:4D0D original=e80500
    CALL_NEAR loc_04D15
; @04D10 0000:4D10 original=c705ffff
    mov word ptr ds:[di], 0FFFFh
; @04D14 0000:4D14 original=c3
    ret
; sub_0000_4D15
; @04D15 0000:4D15 original=ad
    lodsw
; @04D16 0000:4D16 original=8bd8
    mov bx, ax
; @04D18 0000:4D18 original=d1e3
    shl bx, 1
; @04D1A 0000:4D1A original=81c3089a
    add bx, 09A08h
; @04D1E 0000:4D1E original=8b1f
    mov bx, word ptr ds:[bx]
; @04D20 0000:4D20 original=031e4c23
    add bx, word ptr ds:[0234Ch]
; @04D24 0000:4D24 original=ad
    lodsw
; @04D25 0000:4D25 original=03d8
    add bx, ax
; @04D27 0000:4D27 original=ad
    lodsw
; @04D28 0000:4D28 original=26803f00
    cmp byte ptr es:[bx], 0
; @04D2C 0000:4D2C original=7533
    JNE_SHORT loc_04D61
; @04D2E 0000:4D2E original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @04D34 0000:4D34 original=7523
    JNE_SHORT loc_04D59
; @04D36 0000:4D36 original=26807f1a00
    cmp byte ptr es:[bx + 01Ah], 0
; @04D3B 0000:4D3B original=7524
    JNE_SHORT loc_04D61
; @04D3D 0000:4D3D original=26807f3400
    cmp byte ptr es:[bx + 034h], 0
; @04D42 0000:4D42 original=751d
    JNE_SHORT loc_04D61
; @04D44 0000:4D44 original=26807f4e00
    cmp byte ptr es:[bx + 04Eh], 0
; @04D49 0000:4D49 original=7516
    JNE_SHORT loc_04D61
; @04D4B 0000:4D4B original=ffe5
    jmp bp
; @04D4D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,088h,047h,04Eh,026h,088h,047h,034h,026h,088h,047h,01Ah
; @04D59 0000:4D59 original=268807
    mov byte ptr es:[bx], al
; @04D5C 0000:4D5C original=891d
    mov word ptr ds:[di], bx
; @04D5E 0000:4D5E original=83c702
    add di, 2
; @04D61 0000:4D61 original=e2b2
    LOOP_SHORT loc_04D15
; @04D63 0000:4D63 original=c3
    ret
; sub_0000_4D64
; @04D64 0000:4D64 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @04D69 0000:4D69 original=beb1c7
    mov si, 0C7B1h
; @04D6C 0000:4D6C original=b92800
    mov cx, 028h
; @04D6F 0000:4D6F original=ad
    lodsw
; @04D70 0000:4D70 original=3dffff
    cmp ax, 0FFFFh
; @04D73 0000:4D73 original=741f
    JE_SHORT loc_04D94
; @04D75 0000:4D75 original=8bf8
    mov di, ax
; @04D77 0000:4D77 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @04D7D 0000:4D7D original=750f
    JNE_SHORT loc_04D8E
; @04D7F 0000:4D7F original=26c6454e00
    mov byte ptr es:[di + 04Eh], 0
; @04D84 0000:4D84 original=26c6453400
    mov byte ptr es:[di + 034h], 0
; @04D89 0000:4D89 original=26c6451a00
    mov byte ptr es:[di + 01Ah], 0
; @04D8E 0000:4D8E original=26c60500
    mov byte ptr es:[di], 0
; @04D92 0000:4D92 original=e2db
    LOOP_SHORT loc_04D6F
; @04D94 0000:4D94 original=c3
    ret
; @04D95 0000:4D95 original=8306a62002 runtime CFG evidence
    add word ptr ds:[020A6h], 2
; @04D9A 0000:4D9A original=813ea620c720 runtime CFG evidence
    cmp word ptr ds:[020A6h], 020C7h
; @04DA0 0000:4DA0 original=7206 runtime CFG evidence
    JB_SHORT loc_04DA8
; @04DA2 0000:4DA2 original=c706a620a820 runtime CFG evidence
    mov word ptr ds:[020A6h], 020A8h
; @04DA8 0000:4DA8 original=8b1ea620 runtime CFG evidence
    mov bx, word ptr ds:[020A6h]
; @04DAC 0000:4DAC original=8b1f runtime CFG evidence
    mov bx, word ptr ds:[bx]
; @04DAE 0000:4DAE original=c3 runtime CFG evidence
    ret
; sub_0000_4DAF
; @04DAF 0000:4DAF original=ad
    lodsw
; @04DB0 0000:4DB0 original=8bf8
    mov di, ax
; @04DB2 0000:4DB2 original=ad
    lodsw
; @04DB3 0000:4DB3 original=8bd0
    mov dx, ax
; @04DB5 0000:4DB5 original=ad
    lodsw
; @04DB6 0000:4DB6 original=a3c820
    mov word ptr ds:[020C8h], ax
; @04DB9 0000:4DB9 original=ad
    lodsw
; @04DBA 0000:4DBA original=39065023
    cmp word ptr ds:[02350h], ax
; @04DBE 0000:4DBE original=c3
    ret
; sub_0000_4DBF
; @04DBF 0000:4DBF original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @04DC3 0000:4DC3 original=d1e3
    shl bx, 1
; @04DC5 0000:4DC5 original=81c301c6
    add bx, 0C601h
; @04DC9 0000:4DC9 original=8b37
    mov si, word ptr ds:[bx]
; @04DCB 0000:4DCB original=b90300
    mov cx, 3
; @04DCE 0000:4DCE original=e8deff
    CALL_NEAR loc_04DAF
; @04DD1 0000:4DD1 original=7205
    JB_SHORT loc_04DD8
; @04DD3 0000:4DD3 original=e2f9
    LOOP_SHORT loc_04DCE
; @04DD5 0000:4DD5 original=e8d7ff
    CALL_NEAR loc_04DAF
; @04DD8 0000:4DD8 original=8bf2
    mov si, dx
; @04DDA 0000:4DDA original=56
    push si
; @04DDB 0000:4DDB original=57
    push di
; @04DDC 0000:4DDC original=ff3678a9
    push word ptr ds:[0A978h]
; @04DE0 0000:4DE0 original=e85bbd
    CALL_NEAR loc_00B3E
; @04DE3 0000:4DE3 original=8f0678a9
    pop word ptr ds:[0A978h]
; @04DE7 0000:4DE7 original=5f
    pop di
; @04DE8 0000:4DE8 original=893e5023
    mov word ptr ds:[02350h], di
; @04DEC 0000:4DEC original=57
    push di
; @04DED 0000:4DED original=e83600
    CALL_NEAR loc_04E26
; @04DF0 0000:4DF0 original=c7065023930e
    mov word ptr ds:[02350h], 0E93h
; @04DF6 0000:4DF6 original=5f
    pop di
; @04DF7 0000:4DF7 original=5e
    pop si
; @04DF8 0000:4DF8 original=e81200
    CALL_NEAR loc_04E0D
; @04DFB 0000:4DFB original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @04DFF 0000:4DFF original=d1e3
    shl bx, 1
; @04E01 0000:4E01 original=81c3ca20
    add bx, 020CAh
; @04E05 0000:4E05 original=8b1f
    mov bx, word ptr ds:[bx]
; @04E07 0000:4E07 original=a1c820
    mov ax, word ptr ds:[020C8h]
; @04E0A 0000:4E0A original=8907
    mov word ptr ds:[bx], ax
; @04E0C 0000:4E0C original=c3
    ret
; sub_0000_4E0D
; @04E0D 0000:4E0D original=57
    push di
; @04E0E 0000:4E0E original=56
    push si
; @04E0F 0000:4E0F original=e86f59
    CALL_NEAR loc_0A781
; @04E12 0000:4E12 original=5e
    pop si
; @04E13 0000:4E13 original=5f
    pop di
; @04E14 0000:4E14 original=393e5023
    cmp word ptr ds:[02350h], di
; @04E18 0000:4E18 original=77f3
    JA_SHORT loc_04E0D
; @04E1A 0000:4E1A original=833e4e2300
    cmp word ptr ds:[0234Eh], 0
; @04E1F 0000:4E1F original=75ec
    JNE_SHORT loc_04E0D
; @04E21 0000:4E21 original=893678a9
    mov word ptr ds:[0A978h], si
; @04E25 0000:4E25 original=c3
    ret
; sub_0000_4E26
; @04E26 0000:4E26 original=50
    push ax
; @04E27 0000:4E27 original=53
    push bx
; @04E28 0000:4E28 original=51
    push cx
; @04E29 0000:4E29 original=52
    push dx
; @04E2A 0000:4E2A original=57
    push di
; @04E2B 0000:4E2B original=56
    push si
; @04E2C 0000:4E2C original=55
    push bp
; @04E2D 0000:4E2D original=06
    push es
; @04E2E 0000:4E2E original=1e
    push ds
; @04E2F 0000:4E2F original=2e8e069295
    mov es, word ptr cs:[09592h]
; @04E34 0000:4E34 original=8b365023
    mov si, word ptr ds:[02350h]
; @04E38 0000:4E38 original=b99c00
    mov cx, 09Ch
; @04E3B 0000:4E3B original=4e
    dec si
; @04E3C 0000:4E3C original=8b1e5623
    mov bx, word ptr ds:[02356h]
; @04E40 0000:4E40 original=d1e3
    shl bx, 1
; @04E42 0000:4E42 original=8b9fd620
    mov bx, word ptr ds:[bx + 020D6h]
; @04E46 0000:4E46 original=2e833fff
    cmp word ptr cs:[bx], -1
; @04E4A 0000:4E4A original=741d
    JE_SHORT loc_04E69
; @04E4C 0000:4E4C original=268a04
    mov al, byte ptr es:[si]
; @04E4F 0000:4E4F original=32e4
    xor ah, ah
; @04E51 0000:4E51 original=2e3b07
    cmp ax, word ptr cs:[bx]
; @04E54 0000:4E54 original=7504
    JNE_SHORT loc_04E5A
; @04E56 0000:4E56 original=2eff6702
    jmp word ptr cs:[bx + 2]
; @04E5A 0000:4E5A original=83c304
    add bx, 4
; @04E5D 0000:4E5D original=ebe7
    JMP_SHORT loc_04E46
; @04E5F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,0C6h,04h,028h,0EBh,04h,026h,0C6h,04h,01h
; @04E69 0000:4E69 original=e2d0
    LOOP_SHORT loc_04E3B
; @04E6B 0000:4E6B original=1f
    pop ds
; @04E6C 0000:4E6C original=07
    pop es
; @04E6D 0000:4E6D original=5d
    pop bp
; @04E6E 0000:4E6E original=5e
    pop si
; @04E6F 0000:4E6F original=5f
    pop di
; @04E70 0000:4E70 original=5a
    pop dx
; @04E71 0000:4E71 original=59
    pop cx
; @04E72 0000:4E72 original=5b
    pop bx
; @04E73 0000:4E73 original=58
    pop ax
; @04E74 0000:4E74 original=c3
    ret
; sub_0000_4E75
; @04E75 0000:4E75 original=bde220
    mov bp, 020E2h
; @04E78 0000:4E78 original=833e80bb01
    cmp word ptr ds:[0BB80h], 1
; @04E7D 0000:4E7D original=7403
    JE_SHORT loc_04E82
; @04E7F 0000:4E7F original=bd0021
    mov bp, 02100h
; @04E82 0000:4E82 original=e80703
    CALL_NEAR loc_0518C
; @04E85 0000:4E85 original=e8dab2
    CALL_NEAR loc_00162
; @04E88 0000:4E88 original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @04E8D 0000:4E8D original=75f6
    JNE_SHORT loc_04E85
; @04E8F 0000:4E8F original=e8d0b2
    CALL_NEAR loc_00162
; @04E92 0000:4E92 original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @04E97 0000:4E97 original=74f6
    JE_SHORT loc_04E8F
; @04E99 0000:4E99 original=bd1e21
    mov bp, 0211Eh
; @04E9C 0000:4E9C original=e9ed02
    JMP_NEAR loc_0518C
; sub_0000_4E9F
; @04E9F 0000:4E9F original=1e
    push ds
; @04EA0 0000:4EA0 original=06
    push es
; @04EA1 0000:4EA1 original=b435
    mov ah, 035h
; @04EA3 0000:4EA3 original=b009
    mov al, 9
; @04EA5 0000:4EA5 original=cd21
    int 021h
; @04EA7 0000:4EA7 original=bf3a21
    mov di, 0213Ah
; @04EAA 0000:4EAA original=8c05
    mov word ptr ds:[di], es
; @04EAC 0000:4EAC original=895d02
    mov word ptr ds:[di + 2], bx
; @04EAF 0000:4EAF original=07
    pop es
; @04EB0 0000:4EB0 original=1e
    push ds
; @04EB1 0000:4EB1 original=0e
    push cs
; @04EB2 0000:4EB2 original=1f
    pop ds
; @04EB3 0000:4EB3 original=bad24e
    mov dx, 04ED2h
; @04EB6 0000:4EB6 original=b425
    mov ah, 025h
; @04EB8 0000:4EB8 original=b009
    mov al, 9
; @04EBA 0000:4EBA original=cd21
    int 021h
; @04EBC 0000:4EBC original=1f
    pop ds
; @04EBD 0000:4EBD original=1f
    pop ds
; @04EBE 0000:4EBE original=c3
    ret
; sub_0000_4EBF
; @04EBF 0000:4EBF original=1e
    push ds
; @04EC0 0000:4EC0 original=bf3a21
    mov di, 0213Ah
; @04EC3 0000:4EC3 original=8b5502
    mov dx, word ptr ds:[di + 2]
; @04EC6 0000:4EC6 original=8b05
    mov ax, word ptr ds:[di]
; @04EC8 0000:4EC8 original=8ed8
    mov ds, ax
; @04ECA 0000:4ECA original=b425
    mov ah, 025h
; @04ECC 0000:4ECC original=b009
    mov al, 9
; @04ECE 0000:4ECE original=cd21
    int 021h
; @04ED0 0000:4ED0 original=1f
    pop ds
; @04ED1 0000:4ED1 original=c3
    ret
; @04ED2 0000:4ED2 original=50 runtime CFG evidence
    push ax
; @04ED3 0000:4ED3 original=53 runtime CFG evidence
    push bx
; @04ED4 0000:4ED4 original=51 runtime CFG evidence
    push cx
; @04ED5 0000:4ED5 original=52 runtime CFG evidence
    push dx
; @04ED6 0000:4ED6 original=57 runtime CFG evidence
    push di
; @04ED7 0000:4ED7 original=56 runtime CFG evidence
    push si
; @04ED8 0000:4ED8 original=55 runtime CFG evidence
    push bp
; @04ED9 0000:4ED9 original=06 runtime CFG evidence
    push es
; @04EDA 0000:4EDA original=1e runtime CFG evidence
    push ds
; @04EDB 0000:4EDB original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @04EE0 0000:4EE0 original=e460 runtime CFG evidence
    in al, 060h
; @04EE2 0000:4EE2 original=8ad8 runtime CFG evidence
    mov bl, al
; @04EE4 0000:4EE4 original=e461 runtime CFG evidence
    in al, 061h
; @04EE6 0000:4EE6 original=8ae0 runtime CFG evidence
    mov ah, al
; @04EE8 0000:4EE8 original=0c80 runtime CFG evidence
    or al, 080h
; @04EEA 0000:4EEA original=e661 runtime CFG evidence
    out 061h, al
; @04EEC 0000:4EEC original=86e0 runtime CFG evidence
    xchg ah, al
; @04EEE 0000:4EEE original=e661 runtime CFG evidence
    out 061h, al
; @04EF0 0000:4EF0 original=8ac3 runtime CFG evidence
    mov al, bl
; @04EF2 0000:4EF2 original=32e4 runtime CFG evidence
    xor ah, ah
; @04EF4 0000:4EF4 original=bbc498 runtime CFG evidence
    mov bx, 098C4h
; @04EF7 0000:4EF7 original=a880 runtime CFG evidence
    test al, 080h
; @04EF9 0000:4EF9 original=7527 runtime CFG evidence
    JNE_SHORT loc_04F22
; @04EFB 0000:4EFB original=a2c398 runtime CFG evidence
    mov byte ptr ds:[098C3h], al
; @04EFE 0000:4EFE original=03d8 runtime CFG evidence
    add bx, ax
; @04F00 0000:4F00 original=c60701 runtime CFG evidence
    mov byte ptr ds:[bx], 1
; @04F03 0000:4F03 original=81fbf198 runtime CFG evidence
    cmp bx, 098F1h
; @04F07 0000:4F07 original=7520 runtime CFG evidence
    JNE_SHORT loc_04F29
; @04F09 0000:4F09 original=803efc9801 runtime CFG evidence
    cmp byte ptr ds:[098FCh], 1
; @04F0E 0000:4F0E original=7519 runtime CFG evidence
    JNE_SHORT loc_04F29
; @04F10 0000:4F10 original=b061 runtime CFG evidence
    mov al, 061h
; @04F12 0000:4F12 original=e620 runtime CFG evidence
    out 020h, al
; @04F14 0000:4F14 original=1f runtime CFG evidence
    pop ds
; @04F15 0000:4F15 original=07 runtime CFG evidence
    pop es
; @04F16 0000:4F16 original=5d runtime CFG evidence
    pop bp
; @04F17 0000:4F17 original=5e runtime CFG evidence
    pop si
; @04F18 0000:4F18 original=5f runtime CFG evidence
    pop di
; @04F19 0000:4F19 original=5a runtime CFG evidence
    pop dx
; @04F1A 0000:4F1A original=59 runtime CFG evidence
    pop cx
; @04F1B 0000:4F1B original=5b runtime CFG evidence
    pop bx
; @04F1C 0000:4F1C original=58 runtime CFG evidence
    pop ax
; @04F1D 0000:4F1D original=e9f40d runtime CFG evidence
    JMP_NEAR loc_05D14
; @04F20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,07h
; @04F22 0000:4F22 original=247f runtime CFG evidence
    and al, 07Fh
; @04F24 0000:4F24 original=03d8 runtime CFG evidence
    add bx, ax
; @04F26 0000:4F26 original=c60700 runtime CFG evidence
    mov byte ptr ds:[bx], 0
; @04F29 0000:4F29 original=b061 runtime CFG evidence
    mov al, 061h
; @04F2B 0000:4F2B original=e620 runtime CFG evidence
    out 020h, al
; @04F2D 0000:4F2D original=1f runtime CFG evidence
    pop ds
; @04F2E 0000:4F2E original=07 runtime CFG evidence
    pop es
; @04F2F 0000:4F2F original=5d runtime CFG evidence
    pop bp
; @04F30 0000:4F30 original=5e runtime CFG evidence
    pop si
; @04F31 0000:4F31 original=5f runtime CFG evidence
    pop di
; @04F32 0000:4F32 original=5a runtime CFG evidence
    pop dx
; @04F33 0000:4F33 original=59 runtime CFG evidence
    pop cx
; @04F34 0000:4F34 original=5b runtime CFG evidence
    pop bx
; @04F35 0000:4F35 original=58 runtime CFG evidence
    pop ax
; @04F36 0000:4F36 original=cf runtime CFG evidence
    iret
; @04F37 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,083h,03Eh,0BCh,095h,00h,074h,01h,0C3h,0E8h,080h,00h,0B8h,040h,00h,08Eh
; @04F47 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,026h,0A0h,065h,00h,0Ch,04h,0BAh,0D8h,03h,0EEh,026h,0A2h,065h,00h,0C3h
; sub_0000_4F57
; @04F57 0000:4F57 original=2e833ebc9500
    cmp word ptr cs:[095BCh], 0
; @04F5D 0000:4F5D original=7401
    JE_SHORT loc_04F60
; @04F5F 0000:4F5F original=c3
    ret
; @04F60 0000:4F60 original=e82900
    CALL_NEAR loc_04F8C
; @04F63 0000:4F63 original=b40b
    mov ah, 0Bh
; @04F65 0000:4F65 original=b701
    mov bh, 1
; @04F67 0000:4F67 original=b300
    mov bl, 0
; @04F69 0000:4F69 original=cd10
    int 010h
; @04F6B 0000:4F6B original=b84000
    mov ax, 040h
; @04F6E 0000:4F6E original=8ec0
    mov es, ax
; @04F70 0000:4F70 original=26a06500
    mov al, byte ptr es:[065h]
; @04F74 0000:4F74 original=24fb
    and al, 0FBh
; @04F76 0000:4F76 original=bad803
    mov dx, 03D8h
; @04F79 0000:4F79 original=ee
    out dx, al
; @04F7A 0000:4F7A original=26a26500
    mov byte ptr es:[065h], al
; @04F7E 0000:4F7E original=26a06600
    mov al, byte ptr es:[066h]
; @04F82 0000:4F82 original=24df
    and al, 0DFh
; @04F84 0000:4F84 original=0c00
    or al, 0
; @04F86 0000:4F86 original=42
    inc dx
; @04F87 0000:4F87 original=ee
    out dx, al
; @04F88 0000:4F88 original=26a26600
    mov byte ptr es:[066h], al
; sub_0000_4F8C
; @04F8C 0000:4F8C original=b84000
    mov ax, 040h
; @04F8F 0000:4F8F original=8ec0
    mov es, ax
; @04F91 0000:4F91 original=26a06600
    mov al, byte ptr es:[066h]
; @04F95 0000:4F95 original=0c10
    or al, 010h
; @04F97 0000:4F97 original=26a26600
    mov byte ptr es:[066h], al
; @04F9B 0000:4F9B original=bad903
    mov dx, 03D9h
; @04F9E 0000:4F9E original=ee
    out dx, al
; @04F9F 0000:4F9F original=c3
    ret
; @04FA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,083h,03Eh,0BCh,095h,00h,074h,01h,0C3h,0E8h,03h,00h,0E8h,0B4h,0FFh,0B8h
; @04FB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,08Eh,0C0h,026h,0A0h,066h,00h,024h,0EFh,026h,0A2h,066h,00h,0BAh,0D9h
; @04FC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0EEh,0C3h
; sub_0000_4FC3
; @04FC3 0000:4FC3 original=2e833ebc9500
    cmp word ptr cs:[095BCh], 0
; @04FC9 0000:4FC9 original=7401
    JE_SHORT loc_04FCC
; @04FCB 0000:4FCB original=c3
    ret
; @04FCC 0000:4FCC original=e8bdff
    CALL_NEAR loc_04F8C
; @04FCF 0000:4FCF original=b40b
    mov ah, 0Bh
; @04FD1 0000:4FD1 original=b701
    mov bh, 1
; @04FD3 0000:4FD3 original=b301
    mov bl, 1
; @04FD5 0000:4FD5 original=cd10
    int 010h
; @04FD7 0000:4FD7 original=b84000
    mov ax, 040h
; @04FDA 0000:4FDA original=8ec0
    mov es, ax
; @04FDC 0000:4FDC original=26a06500
    mov al, byte ptr es:[065h]
; @04FE0 0000:4FE0 original=24fb
    and al, 0FBh
; @04FE2 0000:4FE2 original=bad803
    mov dx, 03D8h
; @04FE5 0000:4FE5 original=ee
    out dx, al
; @04FE6 0000:4FE6 original=26a26500
    mov byte ptr es:[065h], al
; @04FEA 0000:4FEA original=26a06600
    mov al, byte ptr es:[066h]
; @04FEE 0000:4FEE original=24df
    and al, 0DFh
; @04FF0 0000:4FF0 original=0c20
    or al, 020h
; @04FF2 0000:4FF2 original=42
    inc dx
; @04FF3 0000:4FF3 original=ee
    out dx, al
; @04FF4 0000:4FF4 original=26a26600
    mov byte ptr es:[066h], al
; @04FF8 0000:4FF8 original=c3
    ret
; sub_0000_4FF9
; @04FF9 0000:4FF9 original=8b7608
    mov si, word ptr ss:[bp + 8]
; @04FFC 0000:4FFC original=83fe03
    cmp si, 3
; @04FFF 0000:4FFF original=7358
    JAE_SHORT loc_05059
; @05001 0000:5001 original=d1e6
    shl si, 1
; @05003 0000:5003 original=d1e6
    shl si, 1
; @05005 0000:5005 original=81c64e21
    add si, 0214Eh
; @05009 0000:5009 original=ff7602
    push word ptr ss:[bp + 2]
; @0500C 0000:500C original=ff7604
    push word ptr ss:[bp + 4]
; @0500F 0000:500F original=ad
    lodsw
; @05010 0000:5010 original=014602
    add word ptr ss:[bp + 2], ax
; @05013 0000:5013 original=ad
    lodsw
; @05014 0000:5014 original=014604
    add word ptr ss:[bp + 4], ax
; @05017 0000:5017 original=e85900
    CALL_NEAR loc_05073
; @0501A 0000:501A original=83c30d
    add bx, 0Dh
; @0501D 0000:501D original=a15a21
    mov ax, word ptr ds:[0215Ah]
; @05020 0000:5020 original=250f00
    and ax, 0Fh
; @05023 0000:5023 original=3d0a00
    cmp ax, 0Ah
; @05026 0000:5026 original=b90100
    mov cx, 1
; @05029 0000:5029 original=7603
    JBE_SHORT loc_0502E
; @0502B 0000:502B original=b90200
    mov cx, 2
; @0502E 0000:502E original=51
    push cx
; @0502F 0000:502F original=53
    push bx
; @05030 0000:5030 original=e82800
    CALL_NEAR loc_0505B
; @05033 0000:5033 original=751c
    JNE_SHORT loc_05051
; @05035 0000:5035 original=f746040f00
    test word ptr ss:[bp + 4], 0Fh
; @0503A 0000:503A original=7406
    JE_SHORT loc_05042
; @0503C 0000:503C original=43
    inc bx
; @0503D 0000:503D original=e81b00
    CALL_NEAR loc_0505B
; @05040 0000:5040 original=750f
    JNE_SHORT loc_05051
; @05042 0000:5042 original=5b
    pop bx
; @05043 0000:5043 original=83eb0d
    sub bx, 0Dh
; @05046 0000:5046 original=59
    pop cx
; @05047 0000:5047 original=e2e5
    LOOP_SHORT loc_0502E
; @05049 0000:5049 original=8f4604
    pop word ptr ss:[bp + 4]
; @0504C 0000:504C original=8f4602
    pop word ptr ss:[bp + 2]
; @0504F 0000:504F original=f8
    clc
; @05050 0000:5050 original=c3
    ret
; @05051 0000:5051 original=5b
    pop bx
; @05052 0000:5052 original=59
    pop cx
; @05053 0000:5053 original=8f4604
    pop word ptr ss:[bp + 4]
; @05056 0000:5056 original=8f4602
    pop word ptr ss:[bp + 2]
; @05059 0000:5059 original=f9
    stc
; @0505A 0000:505A original=c3
    ret
; sub_0000_505B
; @0505B 0000:505B original=beaac3
    mov si, 0C3AAh
; @0505E 0000:505E original=2e8e069295
    mov es, word ptr cs:[09592h]
; @05063 0000:5063 original=268a07
    mov al, byte ptr es:[bx]
; @05066 0000:5066 original=32e4
    xor ah, ah
; @05068 0000:5068 original=03f0
    add si, ax
; @0506A 0000:506A original=8a04
    mov al, byte ptr ds:[si]
; @0506C 0000:506C original=0ac0
    or al, al
; @0506E 0000:506E original=c3
    ret
; @0506F 0000:506F original=bbffff
    mov bx, 0FFFFh
; @05072 0000:5072 original=c3
    ret
; sub_0000_5073
; @05073 0000:5073 original=a14e23
    mov ax, word ptr ds:[0234Eh]
; @05076 0000:5076 original=034602
    add ax, word ptr ss:[bp + 2]
; @05079 0000:5079 original=a35a21
    mov word ptr ds:[0215Ah], ax
; @0507C 0000:507C original=78f1
    JS_SHORT loc_0506F
; @0507E 0000:507E original=d1e8
    shr ax, 1
; @05080 0000:5080 original=d1e8
    shr ax, 1
; @05082 0000:5082 original=d1e8
    shr ax, 1
; @05084 0000:5084 original=d1e8
    shr ax, 1
; @05086 0000:5086 original=8bd0
    mov dx, ax
; @05088 0000:5088 original=d1e0
    shl ax, 1
; @0508A 0000:508A original=d1e0
    shl ax, 1
; @0508C 0000:508C original=8bc8
    mov cx, ax
; @0508E 0000:508E original=d1e0
    shl ax, 1
; @05090 0000:5090 original=03c1
    add ax, cx
; @05092 0000:5092 original=03c2
    add ax, dx
; @05094 0000:5094 original=8b1e5023
    mov bx, word ptr ds:[02350h]
; @05098 0000:5098 original=2bd8
    sub bx, ax
; @0509A 0000:509A original=8b4604
    mov ax, word ptr ss:[bp + 4]
; @0509D 0000:509D original=25f0ff
    and ax, 0FFF0h
; @050A0 0000:50A0 original=d1e8
    shr ax, 1
; @050A2 0000:50A2 original=d1e8
    shr ax, 1
; @050A4 0000:50A4 original=d1e8
    shr ax, 1
; @050A6 0000:50A6 original=d1e8
    shr ax, 1
; @050A8 0000:50A8 original=03d8
    add bx, ax
; @050AA 0000:50AA original=c3
    ret
; sub_0000_50AB
; @050AB 0000:50AB original=2e8e069695
    mov es, word ptr cs:[09596h]
; @050B0 0000:50B0 original=bfc498
    mov di, 098C4h
; @050B3 0000:50B3 original=32c0
    xor al, al
; @050B5 0000:50B5 original=b98000
    mov cx, 080h
; @050B8 0000:50B8 original=f3aa
    rep stosb
; sub_0000_50BA
; @050BA 0000:50BA original=fa
    cli
; @050BB 0000:50BB original=33c0
    xor ax, ax
; @050BD 0000:50BD original=8ec0
    mov es, ax
; @050BF 0000:50BF original=26a01a04
    mov al, byte ptr es:[041Ah]
; @050C3 0000:50C3 original=26a21c04
    mov byte ptr es:[041Ch], al
; @050C7 0000:50C7 original=fb
    sti
; @050C8 0000:50C8 original=c3
    ret
; sub_0000_50C9
; @050C9 0000:50C9 original=e91e79
    JMP_NEAR loc_0C9EA
; @050CC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,08Dh,0B0h,080h,03Eh,0BEh,098h,00h,075h,0F6h
; @050DC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,0C3h,01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,07Bh,0B0h,080h,03Eh,0BEh,098h,00h
; @050EC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,0F6h,01Fh,0C3h,0E8h,0EBh,0FFh,0EBh,0D7h,0B4h,00h,02Eh,083h,03Eh,0BCh,095h
; @050FC UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,074h,011h,0BAh,0DAh,03h,0ECh,0BAh,0C0h,03h,0B0h,011h,0EEh,08Ah,0C4h,0EEh
; @0510C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,020h,0EEh,0C3h,0B4h,00h,0BAh,0DAh,03h,0B0h,02h,0EEh,0BAh,0DEh,03h,08Ah
; @0511C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,0EEh,0C3h
; sub_0000_511F
; @0511F 0000:511F original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @05125 0000:5125 original=7401
    JE_SHORT loc_05128
; @05127 0000:5127 original=c3
    ret
; @05128 0000:5128 original=2eff065e51
    inc word ptr cs:[0515Eh]
; @0512D 0000:512D original=2e83265e5101
    and word ptr cs:[0515Eh], 1
; @05133 0000:5133 original=2ec706a49500a0
    mov word ptr cs:[095A4h], 0A000h
; @0513A 0000:513A original=7501
    JNE_SHORT loc_0513D
; @0513C 0000:513C original=c3
    ret
; @0513D 0000:513D original=2ec706a49500a2
    mov word ptr cs:[095A4h], 0A200h
; @05144 0000:5144 original=c3
    ret
; sub_0000_5145
; @05145 0000:5145 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @0514B 0000:514B original=7401
    JE_SHORT loc_0514E
; @0514D 0000:514D original=c3
    ret
; @0514E 0000:514E original=2ec7065e510000
    mov word ptr cs:[0515Eh], 0
; @05155 0000:5155 original=2ec706a49500a0
    mov word ptr cs:[095A4h], 0A000h
; @0515C 0000:515C original=eb02
    JMP_SHORT loc_05160
; @0515E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h
; sub_0000_5160
; @05160 0000:5160 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @05166 0000:5166 original=7401
    JE_SHORT loc_05169
; @05168 0000:5168 original=c3
    ret
; @05169 0000:5169 original=33db
    xor bx, bx
; @0516B 0000:516B original=2e833e5e5100
    cmp word ptr cs:[0515Eh], 0
; @05171 0000:5171 original=7403
    JE_SHORT loc_05176
; @05173 0000:5173 original=bb0020
    mov bx, 02000h
; @05176 0000:5176 original=bada03
    mov dx, 03DAh
; @05179 0000:5179 original=ec
    in al, dx
; @0517A 0000:517A original=a808
    test al, 8
; @0517C 0000:517C original=ec
    in al, dx
; @0517D 0000:517D original=a808
    test al, 8
; @0517F 0000:517F original=75fb
    JNE_SHORT loc_0517C
; @05181 0000:5181 original=fa
    cli
; @05182 0000:5182 original=80ea06
    sub dl, 6
; @05185 0000:5185 original=8ae7
    mov ah, bh
; @05187 0000:5187 original=b00c
    mov al, 0Ch
; @05189 0000:5189 original=ef
    out dx, ax
; @0518A 0000:518A original=fb
    sti
; @0518B 0000:518B original=c3
    ret
; sub_0000_518C
; @0518C 0000:518C original=8a4600
    mov al, byte ptr ss:[bp]
; @0518F 0000:518F original=0ac0
    or al, al
; @05191 0000:5191 original=7501
    JNE_SHORT loc_05194
; @05193 0000:5193 original=c3
    ret
; @05194 0000:5194 original=e80300
    CALL_NEAR loc_0519A
; @05197 0000:5197 original=45
    inc bp
; @05198 0000:5198 original=ebf2
    JMP_SHORT loc_0518C
; sub_0000_519A
; @0519A 0000:519A original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0519F 0000:519F original=833ea22100
    cmp word ptr ds:[021A2h], 0
; @051A4 0000:51A4 original=7412
    JE_SHORT loc_051B8
; @051A6 0000:51A6 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @051AB 0000:51AB original=d1e3
    shl bx, 1
; @051AD 0000:51AD original=2effa7b251
    jmp word ptr cs:[bx + 051B2h]
; @051B2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,042h,0FEh,025h,053h,031h
; @051B8 0000:51B8 original=3c10
    cmp al, 010h
; @051BA 0000:51BA original=7437
    JE_SHORT loc_051F3
; @051BC 0000:51BC original=3c11
    cmp al, 011h
; @051BE 0000:51BE original=7416
    JE_SHORT loc_051D6
; @051C0 0000:51C0 original=2e8e069495
    mov es, word ptr cs:[09594h]
; @051C5 0000:51C5 original=8b3e6021
    mov di, word ptr ds:[02160h]
; @051C9 0000:51C9 original=8a265c21
    mov ah, byte ptr ds:[0215Ch]
; @051CD 0000:51CD original=268905
    mov word ptr es:[di], ax
; @051D0 0000:51D0 original=8306602102
    add word ptr ds:[02160h], 2
; @051D5 0000:51D5 original=c3
    ret
; @051D6 0000:51D6 original=8a4601
    mov al, byte ptr ss:[bp + 1]
; @051D9 0000:51D9 original=b95000
    mov cx, 050h
; @051DC 0000:51DC original=32e4
    xor ah, ah
; @051DE 0000:51DE original=f7e1
    mul cx
; @051E0 0000:51E0 original=8bd8
    mov bx, ax
; @051E2 0000:51E2 original=8a4602
    mov al, byte ptr ss:[bp + 2]
; @051E5 0000:51E5 original=32e4
    xor ah, ah
; @051E7 0000:51E7 original=d1e0
    shl ax, 1
; @051E9 0000:51E9 original=03d8
    add bx, ax
; @051EB 0000:51EB original=891e6021
    mov word ptr ds:[02160h], bx
; @051EF 0000:51EF original=83c502
    add bp, 2
; @051F2 0000:51F2 original=c3
    ret
; @051F3 0000:51F3 original=45
    inc bp
; @051F4 0000:51F4 original=8a4600
    mov al, byte ptr ss:[bp]
; @051F7 0000:51F7 original=a25c21
    mov byte ptr ds:[0215Ch], al
; @051FA 0000:51FA original=c3
    ret
; @051FB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0C0h,08Ah,0F8h,0B4h,010h,0B0h,01h,0CDh,010h,0C3h,0C7h,06h,0C2h,021h,01h
; @0520B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E8h,07h,00h,0C7h,06h,0C2h,021h,00h,00h,0C3h,032h,0DBh,0B9h,0F0h,0D8h
; @0521B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,015h,00h,0B9h,018h,0FCh,0E8h,0Fh,00h,0B9h,09Ch,0FFh,0E8h,09h,00h,0B1h
; @0522B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F6h,0E8h,04h,00h,08Ah,0C2h,0EBh,01Dh,032h,0C0h,03h,0D1h,0FEh,0C0h,072h,0FAh
; @0523B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Bh,0D1h,0FEh,0C8h,075h,0Fh,083h,03Eh,0C2h,021h,01h,074h,06h,0Ah,0DBh,0B0h
; @0524B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,074h,06h,032h,0C0h,0FEh,0C3h,04h,030h,052h,051h,053h,083h,03Eh,0C2h,021h
; @0525B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,074h,07h,0E8h,039h,0FFh,05Bh,059h,05Ah,0C3h,088h,05h,047h,0EBh,0F7h
; sub_0000_526A
; @0526A 0000:526A original=2e8e069895
    mov es, word ptr cs:[09598h]
; @0526F 0000:526F original=33ff
    xor di, di
; @05271 0000:5271 original=8bc7
    mov ax, di
; @05273 0000:5273 original=b90080
    mov cx, 08000h
; @05276 0000:5276 original=833ec42100
    cmp word ptr ds:[021C4h], 0
; @0527B 0000:527B original=7403
    JE_SHORT loc_05280
; @0527D 0000:527D original=b90040
    mov cx, 04000h
; @05280 0000:5280 original=f3ab
    rep stosw
; @05282 0000:5282 original=c3
    ret
; sub_0000_5283
; @05283 0000:5283 original=c70688220000
    mov word ptr ds:[02288h], 0
; @05289 0000:5289 original=e86209
    CALL_NEAR loc_05BEE
; @0528C 0000:528C original=bd1423
    mov bp, 02314h
; @0528F 0000:528F original=e89b00
    CALL_NEAR loc_0532D
; @05292 0000:5292 original=833e882200
    cmp word ptr ds:[02288h], 0
; @05297 0000:5297 original=7501
    JNE_SHORT loc_0529A
; @05299 0000:5299 original=c3
    ret
; sub_0000_529A
; @0529A 0000:529A original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @0529F 0000:529F original=9a00007f0f
    CALL_FAR 0F7Fh,00h
; @052A4 0000:52A4 original=9a76007f0f
    CALL_FAR 0F7Fh,076h
; @052A9 0000:52A9 original=8904
    mov word ptr ds:[si], ax
; @052AB 0000:52AB original=c706a421bc15
    mov word ptr ds:[021A4h], 015BCh
; @052B1 0000:52B1 original=c706a621d821
    mov word ptr ds:[021A6h], 021D8h
; @052B7 0000:52B7 original=c706a821ae00
    mov word ptr ds:[021A8h], 0AEh
; @052BD 0000:52BD original=c706aa21c621
    mov word ptr ds:[021AAh], 021C6h
; @052C3 0000:52C3 original=e857bb
    CALL_NEAR loc_00E1D
; @052C6 0000:52C6 original=bed821
    mov si, 021D8h
; @052C9 0000:52C9 original=9a76007f0f
    CALL_FAR 0F7Fh,076h
; @052CE 0000:52CE original=c3
    ret
; sub_0000_52CF
; @052CF 0000:52CF original=b84a14
    mov ax, 0144Ah
; @052D2 0000:52D2 original=a3a421
    mov word ptr ds:[021A4h], ax
; @052D5 0000:52D5 original=c706a6210000
    mov word ptr ds:[021A6h], 0
; @052DB 0000:52DB original=c706aa21c621
    mov word ptr ds:[021AAh], 021C6h
; @052E1 0000:52E1 original=e82bbb
    CALL_NEAR loc_00E0F
; @052E4 0000:52E4 original=833e80bb00
    cmp word ptr ds:[0BB80h], 0
; @052E9 0000:52E9 original=753f
    JNE_SHORT loc_0532A
; @052EB 0000:52EB original=b84a14
    mov ax, 0144Ah
; @052EE 0000:52EE original=8ec0
    mov es, ax
; @052F0 0000:52F0 original=33f6
    xor si, si
; @052F2 0000:52F2 original=b9ac00
    mov cx, 0ACh
; @052F5 0000:52F5 original=33c0
    xor ax, ax
; @052F7 0000:52F7 original=260204
    add al, byte ptr es:[si]
; @052FA 0000:52FA original=80d400
    adc ah, 0
; @052FD 0000:52FD original=46
    inc si
; @052FE 0000:52FE original=e2f7
    LOOP_SHORT loc_052F7
; @05300 0000:5300 original=263b04
    cmp ax, word ptr es:[si]
; @05303 0000:5303 original=7525
    JNE_SHORT loc_0532A
; @05305 0000:5305 original=1e
    push ds
; @05306 0000:5306 original=06
    push es
; @05307 0000:5307 original=1f
    pop ds
; @05308 0000:5308 original=33f6
    xor si, si
; @0530A 0000:530A original=2e8e069695
    mov es, word ptr cs:[09596h]
; @0530F 0000:530F original=bfd821
    mov di, 021D8h
; @05312 0000:5312 original=b9ac00
    mov cx, 0ACh
; @05315 0000:5315 original=f3a4
    rep movsb
; @05317 0000:5317 original=1f
    pop ds
; @05318 0000:5318 original=9a76007f0f
    CALL_FAR 0F7Fh,076h
; @0531D 0000:531D original=9a30007f0f
    CALL_FAR 0F7Fh,030h
; @05322 0000:5322 original=2e891ebc95
    mov word ptr cs:[095BCh], bx
; @05327 0000:5327 original=b001
    mov al, 1
; @05329 0000:5329 original=c3
    ret
; @0532A 0000:532A original=32c0
    xor al, al
; @0532C 0000:532C original=c3
    ret
; sub_0000_532D
; @0532D 0000:532D original=c606862204
    mov byte ptr ds:[02286h], 4
; @05332 0000:5332 original=bbd821
    mov bx, 021D8h
; @05335 0000:5335 original=b90800
    mov cx, 8
; @05338 0000:5338 original=8a470c
    mov al, byte ptr ds:[bx + 0Ch]
; @0533B 0000:533B original=2a4600
    sub al, byte ptr ss:[bp]
; @0533E 0000:533E original=8a470d
    mov al, byte ptr ds:[bx + 0Dh]
; @05341 0000:5341 original=1a4601
    sbb al, byte ptr ss:[bp + 1]
; @05344 0000:5344 original=8a470e
    mov al, byte ptr ds:[bx + 0Eh]
; @05347 0000:5347 original=1a4602
    sbb al, byte ptr ss:[bp + 2]
; @0534A 0000:534A original=8a470f
    mov al, byte ptr ds:[bx + 0Fh]
; @0534D 0000:534D original=1a4603
    sbb al, byte ptr ss:[bp + 3]
; @05350 0000:5350 original=720b
    JB_SHORT loc_0535D
; @05352 0000:5352 original=8006862202
    add byte ptr ds:[02286h], 2
; @05357 0000:5357 original=83c310
    add bx, 010h
; @0535A 0000:535A original=e2dc
    LOOP_SHORT loc_05338
; @0535C 0000:535C original=c3
    ret
; @0535D 0000:535D original=c70688220100
    mov word ptr ds:[02288h], 1
; @05363 0000:5363 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @05368 0000:5368 original=fd
    std
; @05369 0000:5369 original=be5722
    mov si, 02257h
; @0536C 0000:536C original=bf6722
    mov di, 02267h
; @0536F 0000:536F original=a4
    movsb
; @05370 0000:5370 original=3bf3
    cmp si, bx
; @05372 0000:5372 original=75fb
    JNE_SHORT loc_0536F
; @05374 0000:5374 original=a4
    movsb
; @05375 0000:5375 original=fc
    cld
; @05376 0000:5376 original=8bfb
    mov di, bx
; @05378 0000:5378 original=57
    push di
; @05379 0000:5379 original=e8d400
    CALL_NEAR loc_05450
; @0537C 0000:537C original=b4a8
    mov ah, 0A8h
; @0537E 0000:537E original=b000
    mov al, 0
; @05380 0000:5380 original=be5600
    mov si, 056h
; @05383 0000:5383 original=e8b701
    CALL_NEAR loc_0553D
; @05386 0000:5386 original=b200
    mov dl, 0
; @05388 0000:5388 original=8a368622
    mov dh, byte ptr ds:[02286h]
; @0538C 0000:538C original=b402
    mov ah, 2
; @0538E 0000:538E original=b700
    mov bh, 0
; @05390 0000:5390 original=cd10
    int 010h
; @05392 0000:5392 original=ba8a22
    mov dx, 0228Ah
; @05395 0000:5395 original=b409
    mov ah, 9
; @05397 0000:5397 original=cd21
    int 021h
; @05399 0000:5399 original=a08622
    mov al, byte ptr ds:[02286h]
; @0539C 0000:539C original=a29622
    mov byte ptr ds:[02296h], al
; @0539F 0000:539F original=bd9522
    mov bp, 02295h
; @053A2 0000:53A2 original=e8e7fd
    CALL_NEAR loc_0518C
; @053A5 0000:53A5 original=bd1423
    mov bp, 02314h
; @053A8 0000:53A8 original=e8390b
    CALL_NEAR loc_05EE4
; @053AB 0000:53AB original=a08622
    mov al, byte ptr ds:[02286h]
; @053AE 0000:53AE original=a2aa22
    mov byte ptr ds:[022AAh], al
; @053B1 0000:53B1 original=c706b0229b22
    mov word ptr ds:[022B0h], 0229Bh
; @053B7 0000:53B7 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @053BC 0000:53BC original=bf9b22
    mov di, 0229Bh
; @053BF 0000:53BF original=b020
    mov al, 020h
; @053C1 0000:53C1 original=b90a00
    mov cx, 0Ah
; @053C4 0000:53C4 original=f3aa
    rep stosb
; @053C6 0000:53C6 original=b000
    mov al, 0
; @053C8 0000:53C8 original=aa
    stosb
; @053C9 0000:53C9 original=bda922
    mov bp, 022A9h
; @053CC 0000:53CC original=e8bdfd
    CALL_NEAR loc_0518C
; @053CF 0000:53CF original=bd9b22
    mov bp, 0229Bh
; @053D2 0000:53D2 original=e8b7fd
    CALL_NEAR loc_0518C
; @053D5 0000:53D5 original=e8bf00
    CALL_NEAR loc_05497
; @053D8 0000:53D8 original=3c08
    cmp al, 8
; @053DA 0000:53DA original=742c
    JE_SHORT loc_05408
; @053DC 0000:53DC original=3c0d
    cmp al, 0Dh
; @053DE 0000:53DE original=743e
    JE_SHORT loc_0541E
; @053E0 0000:53E0 original=813eb022a522
    cmp word ptr ds:[022B0h], 022A5h
; @053E6 0000:53E6 original=7414
    JE_SHORT loc_053FC
; @053E8 0000:53E8 original=3c20
    cmp al, 020h
; @053EA 0000:53EA original=72dd
    JB_SHORT loc_053C9
; @053EC 0000:53EC original=3c7a
    cmp al, 07Ah
; @053EE 0000:53EE original=77d9
    JA_SHORT loc_053C9
; @053F0 0000:53F0 original=8b3eb022
    mov di, word ptr ds:[022B0h]
; @053F4 0000:53F4 original=8805
    mov byte ptr ds:[di], al
; @053F6 0000:53F6 original=ff06b022
    inc word ptr ds:[022B0h]
; @053FA 0000:53FA original=ebcd
    JMP_SHORT loc_053C9
; @053FC 0000:53FC original=e80200
    CALL_NEAR loc_05401
; @053FF 0000:53FF original=ebc8
    JMP_SHORT loc_053C9
; sub_0000_5401
; @05401 0000:5401 original=b007
    mov al, 7
; @05403 0000:5403 original=b40e
    mov ah, 0Eh
; @05405 0000:5405 original=cd10
    int 010h
; @05407 0000:5407 original=c3
    ret
; @05408 0000:5408 original=813eb0229b22
    cmp word ptr ds:[022B0h], 0229Bh
; @0540E 0000:540E original=74ec
    JE_SHORT loc_053FC
; @05410 0000:5410 original=ff0eb022
    dec word ptr ds:[022B0h]
; @05414 0000:5414 original=8b3eb022
    mov di, word ptr ds:[022B0h]
; @05418 0000:5418 original=b020
    mov al, 020h
; @0541A 0000:541A original=8805
    mov byte ptr ds:[di], al
; @0541C 0000:541C original=ebab
    JMP_SHORT loc_053C9
; @0541E 0000:541E original=813eb022a522
    cmp word ptr ds:[022B0h], 022A5h
; @05424 0000:5424 original=740d
    JE_SHORT loc_05433
; @05426 0000:5426 original=8b3eb022
    mov di, word ptr ds:[022B0h]
; @0542A 0000:542A original=c60520
    mov byte ptr ds:[di], 020h
; @0542D 0000:542D original=ff06b022
    inc word ptr ds:[022B0h]
; @05431 0000:5431 original=ebeb
    JMP_SHORT loc_0541E
; @05433 0000:5433 original=5f
    pop di
; @05434 0000:5434 original=2e8e069695
    mov es, word ptr cs:[09596h]
; @05439 0000:5439 original=be9b22
    mov si, 0229Bh
; @0543C 0000:543C original=b90a00
    mov cx, 0Ah
; @0543F 0000:543F original=f3a4
    rep movsb
; @05441 0000:5441 original=47
    inc di
; @05442 0000:5442 original=47
    inc di
; @05443 0000:5443 original=a11423
    mov ax, word ptr ds:[02314h]
; @05446 0000:5446 original=ab
    stosw
; @05447 0000:5447 original=a11623
    mov ax, word ptr ds:[02316h]
; @0544A 0000:544A original=ab
    stosw
; @0544B 0000:544B original=e85dfc
    CALL_NEAR loc_050AB
; @0544E 0000:544E original=c3
    ret
; @0544F UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h
; sub_0000_5450
; @05450 0000:5450 original=b8cabe
    mov ax, 0BECAh
; @05453 0000:5453 original=9a80097f0f
    CALL_FAR 0F7Fh,0980h
; @05458 0000:5458 original=2ec6064f5400
    mov byte ptr cs:[0544Fh], 0
; @0545E 0000:545E original=b90800
    mov cx, 8
; @05461 0000:5461 original=51
    push cx
; @05462 0000:5462 original=2ea04f54
    mov al, byte ptr cs:[0544Fh]
; @05466 0000:5466 original=d0e0
    shl al, 1
; @05468 0000:5468 original=0404
    add al, 4
; @0546A 0000:546A original=a2d321
    mov byte ptr ds:[021D3h], al
; @0546D 0000:546D original=bdd221
    mov bp, 021D2h
; @05470 0000:5470 original=e819fd
    CALL_NEAR loc_0518C
; @05473 0000:5473 original=2ea04f54
    mov al, byte ptr cs:[0544Fh]
; @05477 0000:5477 original=32e4
    xor ah, ah
; @05479 0000:5479 original=b91000
    mov cx, 010h
; @0547C 0000:547C original=f7e1
    mul cx
; @0547E 0000:547E original=bdd821
    mov bp, 021D8h
; @05481 0000:5481 original=03e8
    add bp, ax
; @05483 0000:5483 original=55
    push bp
; @05484 0000:5484 original=e805fd
    CALL_NEAR loc_0518C
; @05487 0000:5487 original=5d
    pop bp
; @05488 0000:5488 original=8d6e0c
    lea bp, ss:[bp + 0Ch]
; @0548B 0000:548B original=e8560a
    CALL_NEAR loc_05EE4
; @0548E 0000:548E original=59
    pop cx
; @0548F 0000:548F original=2efe064f54
    inc byte ptr cs:[0544Fh]
; @05494 0000:5494 original=e2cb
    LOOP_SHORT loc_05461
; @05496 0000:5496 original=c3
    ret
; sub_0000_5497
; @05497 0000:5497 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0549C 0000:549C original=e820fa
    CALL_NEAR loc_04EBF
; @0549F 0000:549F original=c706b2220000
    mov word ptr ds:[022B2h], 0
; @054A5 0000:54A5 original=b407
    mov ah, 7
; @054A7 0000:54A7 original=cd21
    int 021h
; @054A9 0000:54A9 original=3c00
    cmp al, 0
; @054AB 0000:54AB original=7402
    JE_SHORT loc_054AF
; @054AD 0000:54AD original=eb08
    JMP_SHORT loc_054B7
; @054AF 0000:54AF original=cd21
    int 021h
; @054B1 0000:54B1 original=c706b2220100
    mov word ptr ds:[022B2h], 1
; @054B7 0000:54B7 original=a2b422
    mov byte ptr ds:[022B4h], al
; @054BA 0000:54BA original=50
    push ax
; @054BB 0000:54BB original=e8e1f9
    CALL_NEAR loc_04E9F
; @054BE 0000:54BE original=58
    pop ax
; @054BF 0000:54BF original=c3
    ret
; sub_0000_54C0
; @054C0 0000:54C0 original=2e833ebc9500
    cmp word ptr cs:[095BCh], 0
; @054C6 0000:54C6 original=7406
    JE_SHORT loc_054CE
; @054C8 0000:54C8 original=c60699220a
    mov byte ptr ds:[02299h], 0Ah
; @054CD 0000:54CD original=c3
    ret
; @054CE 0000:54CE original=c606992203
    mov byte ptr ds:[02299h], 3
; @054D3 0000:54D3 original=c3
    ret
; sub_0000_54D4
; @054D4 0000:54D4 original=b441
    mov ah, 041h
; @054D6 0000:54D6 original=b009
    mov al, 9
; @054D8 0000:54D8 original=be4000
    mov si, 040h
; @054DB 0000:54DB original=833e100000
    cmp word ptr ds:[010h], 0
; @054E0 0000:54E0 original=e85700
    CALL_NEAR loc_0553A
; @054E3 0000:54E3 original=b457
    mov ah, 057h
; @054E5 0000:54E5 original=b009
    mov al, 9
; @054E7 0000:54E7 original=be4200
    mov si, 042h
; @054EA 0000:54EA original=833e100001
    cmp word ptr ds:[010h], 1
; @054EF 0000:54EF original=e84800
    CALL_NEAR loc_0553A
; @054F2 0000:54F2 original=b440
    mov ah, 040h
; @054F4 0000:54F4 original=b013
    mov al, 013h
; @054F6 0000:54F6 original=be4400
    mov si, 044h
; @054F9 0000:54F9 original=833e100002
    cmp word ptr ds:[010h], 2
; @054FE 0000:54FE original=e83900
    CALL_NEAR loc_0553A
; @05501 0000:5501 original=b47a
    mov ah, 07Ah
; @05503 0000:5503 original=b009
    mov al, 9
; @05505 0000:5505 original=be4600
    mov si, 046h
; @05508 0000:5508 original=833eb52200
    cmp word ptr ds:[022B5h], 0
; @0550D 0000:550D original=e82a00
    CALL_NEAR loc_0553A
; @05510 0000:5510 original=b47a
    mov ah, 07Ah
; @05512 0000:5512 original=b010
    mov al, 010h
; @05514 0000:5514 original=be4800
    mov si, 048h
; @05517 0000:5517 original=833eb52201
    cmp word ptr ds:[022B5h], 1
; @0551C 0000:551C original=e81b00
    CALL_NEAR loc_0553A
; @0551F 0000:551F original=b47a
    mov ah, 07Ah
; @05521 0000:5521 original=b014
    mov al, 014h
; @05523 0000:5523 original=be4a00
    mov si, 04Ah
; @05526 0000:5526 original=833eb52202
    cmp word ptr ds:[022B5h], 2
; @0552B 0000:552B original=e80c00
    CALL_NEAR loc_0553A
; @0552E 0000:552E original=b47c
    mov ah, 07Ch
; @05530 0000:5530 original=b019
    mov al, 019h
; @05532 0000:5532 original=be4c00
    mov si, 04Ch
; @05535 0000:5535 original=833eb52203
    cmp word ptr ds:[022B5h], 3
; sub_0000_553A
; @0553A 0000:553A original=7501
    JNE_SHORT loc_0553D
; @0553C 0000:553C original=46
    inc si
; sub_0000_553D
; @0553D 0000:553D original=56
    push si
; @0553E 0000:553E original=e8bf04
    CALL_NEAR loc_05A00
; @05541 0000:5541 original=5e
    pop si
; @05542 0000:5542 original=d1e6
    shl si, 1
; @05544 0000:5544 original=81c6e40b
    add si, 0BE4h
; @05548 0000:5548 original=2e8b34
    mov si, word ptr cs:[si]
; @0554B 0000:554B original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @05550 0000:5550 original=e81905
    CALL_NEAR loc_05A6C
; @05553 0000:5553 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @05558 0000:5558 original=c3
    ret
; sub_0000_5559
; @05559 0000:5559 original=c706b7220000
    mov word ptr ds:[022B7h], 0
; @0555F 0000:555F original=833eb72200
    cmp word ptr ds:[022B7h], 0
; @05564 0000:5564 original=7510
    JNE_SHORT loc_05576
; @05566 0000:5566 original=9a48027f0f
    CALL_FAR 0F7Fh,0248h
; @0556B 0000:556B original=b8b8be
    mov ax, 0BEB8h
; @0556E 0000:556E original=9a80097f0f
    CALL_FAR 0F7Fh,0980h
; @05573 0000:5573 original=e85eff
    CALL_NEAR loc_054D4
; @05576 0000:5576 original=833eb72200
    cmp word ptr ds:[022B7h], 0
; @0557B 0000:557B original=7405
    JE_SHORT loc_05582
; @0557D 0000:557D original=e8d0fe
    CALL_NEAR loc_05450
; @05580 0000:5580 original=eb03
    JMP_SHORT loc_05585
; @05582 0000:5582 original=e84fff
    CALL_NEAR loc_054D4
; @05585 0000:5585 original=c706bf220000
    mov word ptr ds:[022BFh], 0
; @0558B 0000:558B original=803ee99801
    cmp byte ptr ds:[098E9h], 1
; @05590 0000:5590 original=7503
    JNE_SHORT loc_05595
; @05592 0000:5592 original=e9a800
    JMP_NEAR loc_0563D
; @05595 0000:5595 original=803ee89801
    cmp byte ptr ds:[098E8h], 1
; @0559A 0000:559A original=7503
    JNE_SHORT loc_0559F
; @0559C 0000:559C original=e9ca00
    JMP_NEAR loc_05669
; @0559F 0000:559F original=803ee29801
    cmp byte ptr ds:[098E2h], 1
; @055A4 0000:55A4 original=7503
    JNE_SHORT loc_055A9
; @055A6 0000:55A6 original=e90901
    JMP_NEAR loc_056B2
; @055A9 0000:55A9 original=803ed79801
    cmp byte ptr ds:[098D7h], 1
; @055AE 0000:55AE original=7503
    JNE_SHORT loc_055B3
; @055B0 0000:55B0 original=e97f01
    JMP_NEAR loc_05732
; @055B3 0000:55B3 original=803ef69801
    cmp byte ptr ds:[098F6h], 1
; @055B8 0000:55B8 original=7503
    JNE_SHORT loc_055BD
; @055BA 0000:55BA original=e92401
    JMP_NEAR loc_056E1
; @055BD 0000:55BD original=803edc9801
    cmp byte ptr ds:[098DCh], 1
; @055C2 0000:55C2 original=745d
    JE_SHORT loc_05621
; @055C4 0000:55C4 original=803edb9801
    cmp byte ptr ds:[098DBh], 1
; @055C9 0000:55C9 original=7461
    JE_SHORT loc_0562C
; @055CB 0000:55CB original=803ec59801
    cmp byte ptr ds:[098C5h], 1
; @055D0 0000:55D0 original=7503
    JNE_SHORT loc_055D5
; @055D2 0000:55D2 original=e93f07
    JMP_NEAR loc_05D14
; @055D5 0000:55D5 original=803e079901
    cmp byte ptr ds:[09907h], 1
; @055DA 0000:55DA original=745b
    JE_SHORT loc_05637
; @055DC 0000:55DC original=c706b9220000
    mov word ptr ds:[022B9h], 0
; @055E2 0000:55E2 original=c706bb220000
    mov word ptr ds:[022BBh], 0
; @055E8 0000:55E8 original=c706bd220000
    mov word ptr ds:[022BDh], 0
; @055EE 0000:55EE original=e8d8fa
    CALL_NEAR loc_050C9
; @055F1 0000:55F1 original=ff06bf22
    inc word ptr ds:[022BFh]
; @055F5 0000:55F5 original=813ebf22ee02
    cmp word ptr ds:[022BFh], 02EEh
; @055FB 0000:55FB original=7216
    JB_SHORT loc_05613
; @055FD 0000:55FD original=833eb72200
    cmp word ptr ds:[022B7h], 0
; @05602 0000:5602 original=7406
    JE_SHORT loc_0560A
; @05604 0000:5604 original=e8e175
    CALL_NEAR loc_0CBE8
; @05607 0000:5607 original=e94fff
    JMP_NEAR loc_05559
; @0560A 0000:560A original=c706b7220100
    mov word ptr ds:[022B7h], 1
; @05610 0000:5610 original=e94cff
    JMP_NEAR loc_0555F
; @05613 0000:5613 original=e84cab
    CALL_NEAR loc_00162
; @05616 0000:5616 original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @0561B 0000:561B original=7403
    JE_SHORT loc_05620
; @0561D 0000:561D original=e96bff
    JMP_NEAR loc_0558B
; @05620 0000:5620 original=c3
    ret
; @05621 0000:5621 original=b8a0be
    mov ax, 0BEA0h
; @05624 0000:5624 original=9a80097f0f
    CALL_FAR 0F7Fh,0980h
; @05629 0000:5629 original=e92dff
    JMP_NEAR loc_05559
; @0562C 0000:562C original=b892be
    mov ax, 0BE92h
; @0562F 0000:562F original=9a80097f0f
    CALL_FAR 0F7Fh,0980h
; @05634 0000:5634 original=e922ff
    JMP_NEAR loc_05559
; @05637 0000:5637 original=e825b1
    CALL_NEAR loc_0075F
; @0563A 0000:563A original=e91cff
    JMP_NEAR loc_05559
; @0563D 0000:563D original=833eb92201
    cmp word ptr ds:[022B9h], 1
; @05642 0000:5642 original=74aa
    JE_SHORT loc_055EE
; @05644 0000:5644 original=c706b9220100
    mov word ptr ds:[022B9h], 1
; @0564A 0000:564A original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0564F 0000:564F original=7405
    JE_SHORT loc_05656
; @05651 0000:5651 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @05656 0000:5656 original=c70610000000
    mov word ptr ds:[010h], 0
; @0565C 0000:565C original=833eb72200
    cmp word ptr ds:[022B7h], 0
; @05661 0000:5661 original=7503
    JNE_SHORT loc_05666
; @05663 0000:5663 original=e910ff
    JMP_NEAR loc_05576
; @05666 0000:5666 original=e9f0fe
    JMP_NEAR loc_05559
; @05669 0000:5669 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0566E 0000:566E original=7405
    JE_SHORT loc_05675
; @05670 0000:5670 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @05675 0000:5675 original=803ee89801
    cmp byte ptr ds:[098E8h], 1
; @0567A 0000:567A original=74f9
    JE_SHORT loc_05675
; @0567C 0000:567C original=e8bf74
    CALL_NEAR loc_0CB3E
; @0567F 0000:567F original=e88fa9
    CALL_NEAR loc_00011
; @05682 0000:5682 original=a0c298
    mov al, byte ptr ds:[098C2h]
; @05685 0000:5685 original=e89474
    CALL_NEAR loc_0CB1C
; @05688 0000:5688 original=803ec59801
    cmp byte ptr ds:[098C5h], 1
; @0568D 0000:568D original=7516
    JNE_SHORT loc_056A5
; @0568F 0000:568F original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @05694 0000:5694 original=7405
    JE_SHORT loc_0569B
; @05696 0000:5696 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @0569B 0000:569B original=803ec59801
    cmp byte ptr ds:[098C5h], 1
; @056A0 0000:56A0 original=74f9
    JE_SHORT loc_0569B
; @056A2 0000:56A2 original=e9b4fe
    JMP_NEAR loc_05559
; @056A5 0000:56A5 original=e8baaa
    CALL_NEAR loc_00162
; @056A8 0000:56A8 original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @056AD 0000:56AD original=74f6
    JE_SHORT loc_056A5
; @056AF 0000:56AF original=e9a7fe
    JMP_NEAR loc_05559
; @056B2 0000:56B2 original=833ebb2201
    cmp word ptr ds:[022BBh], 1
; @056B7 0000:56B7 original=7503
    JNE_SHORT loc_056BC
; @056B9 0000:56B9 original=e932ff
    JMP_NEAR loc_055EE
; @056BC 0000:56BC original=c706bb220100
    mov word ptr ds:[022BBh], 1
; @056C2 0000:56C2 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @056C7 0000:56C7 original=7405
    JE_SHORT loc_056CE
; @056C9 0000:56C9 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @056CE 0000:56CE original=c70610000200
    mov word ptr ds:[010h], 2
; @056D4 0000:56D4 original=833eb72200
    cmp word ptr ds:[022B7h], 0
; @056D9 0000:56D9 original=7503
    JNE_SHORT loc_056DE
; @056DB 0000:56DB original=e998fe
    JMP_NEAR loc_05576
; @056DE 0000:56DE original=e978fe
    JMP_NEAR loc_05559
; @056E1 0000:56E1 original=833ebd2201
    cmp word ptr ds:[022BDh], 1
; @056E6 0000:56E6 original=7503
    JNE_SHORT loc_056EB
; @056E8 0000:56E8 original=e903ff
    JMP_NEAR loc_055EE
; @056EB 0000:56EB original=c706bd220100
    mov word ptr ds:[022BDh], 1
; @056F1 0000:56F1 original=ff06b522
    inc word ptr ds:[022B5h]
; @056F5 0000:56F5 original=8326b52203
    and word ptr ds:[022B5h], 3
; @056FA 0000:56FA original=8b1eb522
    mov bx, word ptr ds:[022B5h]
; @056FE 0000:56FE original=d1e3
    shl bx, 1
; @05700 0000:5700 original=8b9fc122
    mov bx, word ptr ds:[bx + 022C1h]
; @05704 0000:5704 original=883ec098
    mov byte ptr ds:[098C0h], bh
; @05708 0000:5708 original=881ec198
    mov byte ptr ds:[098C1h], bl
; @0570C 0000:570C original=80fb00
    cmp bl, 0
; @0570F 0000:570F original=7503
    JNE_SHORT loc_05714
; @05711 0000:5711 original=e82a74
    CALL_NEAR loc_0CB3E
; @05714 0000:5714 original=b002
    mov al, 2
; @05716 0000:5716 original=e80374
    CALL_NEAR loc_0CB1C
; @05719 0000:5719 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0571E 0000:571E original=7405
    JE_SHORT loc_05725
; @05720 0000:5720 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @05725 0000:5725 original=833eb72200
    cmp word ptr ds:[022B7h], 0
; @0572A 0000:572A original=7503
    JNE_SHORT loc_0572F
; @0572C 0000:572C original=e947fe
    JMP_NEAR loc_05576
; @0572F 0000:572F original=e927fe
    JMP_NEAR loc_05559
; @05732 0000:5732 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @05737 0000:5737 original=7405
    JE_SHORT loc_0573E
; @05739 0000:5739 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @0573E 0000:573E original=803ed79801
    cmp byte ptr ds:[098D7h], 1
; @05743 0000:5743 original=74f9
    JE_SHORT loc_0573E
; @05745 0000:5745 original=b8c4be
    mov ax, 0BEC4h
; @05748 0000:5748 original=9a80097f0f
    CALL_FAR 0F7Fh,0980h
; @0574D 0000:574D original=c606ca223f
    mov byte ptr ds:[022CAh], 03Fh
; @05752 0000:5752 original=be5000
    mov si, 050h
; @05755 0000:5755 original=bf4221
    mov di, 02142h
; @05758 0000:5758 original=e83c00
    CALL_NEAR loc_05797
; @0575B 0000:575B original=be5100
    mov si, 051h
; @0575E 0000:575E original=bf4321
    mov di, 02143h
; @05761 0000:5761 original=e83300
    CALL_NEAR loc_05797
; @05764 0000:5764 original=be5200
    mov si, 052h
; @05767 0000:5767 original=bf4421
    mov di, 02144h
; @0576A 0000:576A original=e82a00
    CALL_NEAR loc_05797
; @0576D 0000:576D original=be5300
    mov si, 053h
; @05770 0000:5770 original=bf4521
    mov di, 02145h
; @05773 0000:5773 original=e82100
    CALL_NEAR loc_05797
; @05776 0000:5776 original=be5400
    mov si, 054h
; @05779 0000:5779 original=bf4121
    mov di, 02141h
; @0577C 0000:577C original=e81800
    CALL_NEAR loc_05797
; @0577F 0000:577F original=be5500
    mov si, 055h
; @05782 0000:5782 original=bf4021
    mov di, 02140h
; @05785 0000:5785 original=e80f00
    CALL_NEAR loc_05797
; @05788 0000:5788 original=a04021
    mov al, byte ptr ds:[02140h]
; @0578B 0000:578B original=a24821
    mov byte ptr ds:[02148h], al
; @0578E 0000:578E original=c70610000000
    mov word ptr ds:[010h], 0
; @05794 0000:5794 original=e9c2fd
    JMP_NEAR loc_05559
; sub_0000_5797
; @05797 0000:5797 original=57
    push di
; @05798 0000:5798 original=c606c39800
    mov byte ptr ds:[098C3h], 0
; @0579D 0000:579D original=8a26ca22
    mov ah, byte ptr ds:[022CAh]
; @057A1 0000:57A1 original=8006ca2217
    add byte ptr ds:[022CAh], 017h
; @057A6 0000:57A6 original=b001
    mov al, 1
; @057A8 0000:57A8 original=e892fd
    CALL_NEAR loc_0553D
; @057AB 0000:57AB original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @057B0 0000:57B0 original=74f9
    JE_SHORT loc_057AB
; @057B2 0000:57B2 original=803ec39843
    cmp byte ptr ds:[098C3h], 043h
; @057B7 0000:57B7 original=74f2
    JE_SHORT loc_057AB
; @057B9 0000:57B9 original=803ec39844
    cmp byte ptr ds:[098C3h], 044h
; @057BE 0000:57BE original=74eb
    JE_SHORT loc_057AB
; @057C0 0000:57C0 original=803ec39801
    cmp byte ptr ds:[098C3h], 1
; @057C5 0000:57C5 original=74e4
    JE_SHORT loc_057AB
; @057C7 0000:57C7 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @057CC 0000:57CC original=7405
    JE_SHORT loc_057D3
; @057CE 0000:57CE original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @057D3 0000:57D3 original=8a1ec398
    mov bl, byte ptr ds:[098C3h]
; @057D7 0000:57D7 original=32ff
    xor bh, bh
; @057D9 0000:57D9 original=5f
    pop di
; @057DA 0000:57DA original=881d
    mov byte ptr ds:[di], bl
; @057DC 0000:57DC original=81c3c498
    add bx, 098C4h
; @057E0 0000:57E0 original=803f00
    cmp byte ptr ds:[bx], 0
; @057E3 0000:57E3 original=75fb
    JNE_SHORT loc_057E0
; @057E5 0000:57E5 original=c3
    ret
; sub_0000_57E6
; @057E6 0000:57E6 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @057EB 0000:57EB original=7407
    JE_SHORT loc_057F4
; @057ED 0000:57ED original=803efebe00
    cmp byte ptr ds:[0BEFEh], 0
; @057F2 0000:57F2 original=75f9
    JNE_SHORT loc_057ED
; @057F4 0000:57F4 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @057F9 0000:57F9 original=7405
    JE_SHORT loc_05800
; @057FB 0000:57FB original=c606ffbe05
    mov byte ptr ds:[0BEFFh], 5
; sub_0000_5800
; @05800 0000:5800 original=e80800
    CALL_NEAR loc_0580B
; @05803 0000:5803 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @05808 0000:5808 original=e9e303
    JMP_NEAR loc_05BEE
; sub_0000_580B
; @0580B 0000:580B original=33f6
    xor si, si
; @0580D 0000:580D original=2e8e1ea495
    mov ds, word ptr cs:[095A4h]
; @05812 0000:5812 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @05817 0000:5817 original=33ff
    xor di, di
; @05819 0000:5819 original=b8c800
    mov ax, 0C8h
; @0581C 0000:581C original=ab
    stosw
; @0581D 0000:581D original=b82800
    mov ax, 028h
; @05820 0000:5820 original=ab
    stosw
; @05821 0000:5821 original=bace03
    mov dx, 03CEh
; @05824 0000:5824 original=b9c800
    mov cx, 0C8h
; @05827 0000:5827 original=51
    push cx
; @05828 0000:5828 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @0582D 0000:582D original=d1e3
    shl bx, 1
; @0582F 0000:582F original=2effa73458
    jmp word ptr cs:[bx + 05834h]
; @05834 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ah,058h,052h,058h,07Eh,058h
; sub_0000_583A
; @0583A 0000:583A original=b95000
    mov cx, 050h
; @0583D 0000:583D original=f3a4
    rep movsb
; @0583F 0000:583F original=83ee50
    sub si, 050h
; @05842 0000:5842 original=81c60020
    add si, 02000h
; @05846 0000:5846 original=f7c60040
    test si, 04000h
; @0584A 0000:584A original=7404
    JE_SHORT loc_05850
; @0584C 0000:584C original=81c650c0
    add si, 0C050h
; @05850 0000:5850 original=eb43
    JMP_SHORT loc_05895
; sub_0000_5852
; @05852 0000:5852 original=b80400
    mov ax, 4
; @05855 0000:5855 original=ef
    out dx, ax
; @05856 0000:5856 original=b92800
    mov cx, 028h
; @05859 0000:5859 original=f3a4
    rep movsb
; @0585B 0000:585B original=83ee28
    sub si, 028h
; @0585E 0000:585E original=fec4
    inc ah
; @05860 0000:5860 original=ef
    out dx, ax
; @05861 0000:5861 original=b92800
    mov cx, 028h
; @05864 0000:5864 original=f3a4
    rep movsb
; @05866 0000:5866 original=83ee28
    sub si, 028h
; @05869 0000:5869 original=fec4
    inc ah
; @0586B 0000:586B original=ef
    out dx, ax
; @0586C 0000:586C original=b92800
    mov cx, 028h
; @0586F 0000:586F original=f3a4
    rep movsb
; @05871 0000:5871 original=83ee28
    sub si, 028h
; @05874 0000:5874 original=fec4
    inc ah
; @05876 0000:5876 original=ef
    out dx, ax
; @05877 0000:5877 original=b92800
    mov cx, 028h
; @0587A 0000:587A original=f3a4
    rep movsb
; @0587C 0000:587C original=eb17
    JMP_SHORT loc_05895
; sub_0000_587E
; @0587E 0000:587E original=b95000
    mov cx, 050h
; @05881 0000:5881 original=f3a5
    rep movsw
; @05883 0000:5883 original=81eea000
    sub si, 0A0h
; @05887 0000:5887 original=81c60020
    add si, 02000h
; @0588B 0000:588B original=f7c60080
    test si, 08000h
; @0588F 0000:588F original=7404
    JE_SHORT loc_05895
; @05891 0000:5891 original=81c6a080
    add si, 080A0h
; @05895 0000:5895 original=59
    pop cx
; @05896 0000:5896 original=e28f
    LOOP_SHORT loc_05827
; @05898 0000:5898 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @0589E 0000:589E original=7504
    JNE_SHORT loc_058A4
; @058A0 0000:58A0 original=b80400
    mov ax, 4
; @058A3 0000:58A3 original=ef
    out dx, ax
; @058A4 0000:58A4 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @058A9 0000:58A9 original=33ff
    xor di, di
; @058AB 0000:58AB original=33f6
    xor si, si
; @058AD 0000:58AD original=b90100
    mov cx, 1
; @058B0 0000:58B0 original=ad
    lodsw
; @058B1 0000:58B1 original=2ea3fd58
    mov word ptr cs:[058FDh], ax
; @058B5 0000:58B5 original=ad
    lodsw
; @058B6 0000:58B6 original=2ea3ff58
    mov word ptr cs:[058FFh], ax
; @058BA 0000:58BA original=2e8936fb58
    mov word ptr cs:[058FBh], si
; @058BF 0000:58BF original=2e893ef958
    mov word ptr cs:[058F9h], di
; @058C4 0000:58C4 original=2ec70605590000
    mov word ptr cs:[05905h], 0
; @058CB 0000:58CB original=2ec70607590000
    mov word ptr cs:[05907h], 0
; @058D2 0000:58D2 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @058D7 0000:58D7 original=2e8b0efd58
    mov cx, word ptr cs:[058FDh]
; @058DC 0000:58DC original=83e902
    sub cx, 2
; @058DF 0000:58DF original=51
    push cx
; @058E0 0000:58E0 original=2e890e0159
    mov word ptr cs:[05901h], cx
; @058E5 0000:58E5 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @058EA 0000:58EA original=d1e3
    shl bx, 1
; @058EC 0000:58EC original=2eff975a59
    call word ptr cs:[bx + 0595Ah]
; @058F1 0000:58F1 original=e8d5f7
    CALL_NEAR loc_050C9
; @058F4 0000:58F4 original=59
    pop cx
; @058F5 0000:58F5 original=49
    dec cx
; @058F6 0000:58F6 original=e2e7
    LOOP_SHORT loc_058DF
; @058F8 0000:58F8 original=c3
    ret
; @058F9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05909 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,036h,0C6h,06h,0C3h,098h,00h,0ADh,02Eh,0A3h,0FDh,058h,0ADh,02Eh,0A3h
; @05919 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,058h,02Eh,089h,036h,0FBh,058h,02Eh,089h,03Eh,0F9h,058h,02Eh,0C7h,06h,05h
; @05929 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 059h,00h,00h,02Eh,0C7h,06h,07h,059h,00h,00h,02Eh,0C7h,06h,09h,059h,00h
; @05939 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,02Eh,08Eh,06h,0A4h,095h,051h,0E8h,01Dh,00h,075h,0Eh,0E8h,018h,00h,075h
; @05949 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,059h,0E2h,0F2h,02Eh,08Eh,01Eh,096h,095h,0C3h,059h,02Eh,08Eh,01Eh,096h,095h
; @05959 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,07Ah,049h,02Dh,02Dh,05Bh,037h,02Eh,08Bh,0Eh,0FDh,058h,083h,0E9h,02h,051h
; @05969 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,089h,0Eh,01h,059h,02Eh,08Bh,01Eh,0BCh,095h,0D1h,0E3h,02Eh,0FFh,097h,05Ah
; @05979 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 059h,01Eh,02Eh,08Eh,01Eh,096h,095h,080h,03Eh,0C3h,098h,00h,075h,060h,0E8h,0D8h
; @05989 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A7h,080h,03Eh,0BEh,098h,010h,074h,056h,01Fh,0E8h,034h,0F7h,0E8h,031h,0F7h,059h
; @05999 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 049h,0E2h,0CCh,02Eh,083h,036h,05h,059h,01h,02Eh,083h,036h,07h,059h,01h,02Eh
; @059A9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0Eh,0FDh,058h,083h,0E9h,02h,02Eh,083h,06h,01h,059h,02h,051h,02Eh,083h
; @059B9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,01h,059h,02h,02Eh,08Bh,01Eh,0BCh,095h,0D1h,0E3h,02Eh,0FFh,097h,05Ah,059h
; @059C9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,02Eh,08Eh,01Eh,096h,095h,0E8h,090h,0A7h,080h,03Eh,0BEh,098h,010h,074h,0Eh
; @059D9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,0E8h,0ECh,0F6h,0E8h,0E9h,0F6h,059h,049h,0E2h,0D2h,033h,0C0h,0C3h,01Fh,059h
; @059E9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 033h,0C0h,040h,0C3h,02Eh,08Bh,01Eh,0BCh,095h,0D1h,0E3h,02Eh,0FFh,0A7h,0FAh,059h
; @059F9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,064h,042h,0E9h,025h,042h,031h
; sub_0000_5A00
; @05A00 0000:5A00 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05A05 0000:5A05 original=d1e3
    shl bx, 1
; @05A07 0000:5A07 original=2effa70c5a
    jmp word ptr cs:[bx + 05A0Ch]
; @05A0C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Bh,042h,0B6h,025h,03h,031h
; sub_0000_5A12
; @05A12 0000:5A12 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05A17 0000:5A17 original=d1e3
    shl bx, 1
; @05A19 0000:5A19 original=2effa71e5a
    jmp word ptr cs:[bx + 05A1Eh]
; @05A1E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,042h,0C7h,025h,018h,031h
; sub_0000_5A24
; @05A24 0000:5A24 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05A29 0000:5A29 original=d1e3
    shl bx, 1
; @05A2B 0000:5A2B original=2effa7305a
    jmp word ptr cs:[bx + 05A30h]
; @05A30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 051h,042h,0D8h,025h,02Dh,031h
; @05A36 0000:5A36 original=2e8b1ebc95 runtime CFG evidence
    mov bx, word ptr cs:[095BCh]
; @05A3B 0000:5A3B original=d1e3 runtime CFG evidence
    shl bx, 1
; @05A3D 0000:5A3D original=2effa7425a runtime CFG evidence
    jmp word ptr cs:[bx + 05A42h]
; @05A42 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F5h,041h,080h,025h,0D2h,030h
; sub_0000_5A48
; @05A48 0000:5A48 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05A4D 0000:5A4D original=d1e3
    shl bx, 1
; @05A4F 0000:5A4F original=2effa7545a
    jmp word ptr cs:[bx + 05A54h]
; @05A54 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BFh,041h,018h,025h,097h,030h
; sub_0000_5A5A
; @05A5A 0000:5A5A original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05A5F 0000:5A5F original=d1e3
    shl bx, 1
; @05A61 0000:5A61 original=2effa7665a
    jmp word ptr cs:[bx + 05A66h]
; @05A66 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,041h,04Ch,025h,0B4h,030h
; sub_0000_5A6C
; @05A6C 0000:5A6C original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05A71 0000:5A71 original=d1e3
    shl bx, 1
; @05A73 0000:5A73 original=2effa7785a
    jmp word ptr cs:[bx + 05A78h]
; @05A78 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 099h,041h,0D7h,024h,06Fh,030h
; @05A7E 0000:5A7E original=8bd3
    mov dx, bx
; @05A80 0000:5A80 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05A85 0000:5A85 original=d1e3
    shl bx, 1
; @05A87 0000:5A87 original=2effa78c5a
    jmp word ptr cs:[bx + 05A8Ch]
; @05A8C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E6h,048h,084h,02Bh,0A2h,036h
; sub_0000_5A92
; @05A92 0000:5A92 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @05A97 0000:5A97 original=8b7e0c
    mov di, word ptr ss:[bp + 0Ch]
; @05A9A 0000:5A9A original=8b760e
    mov si, word ptr ss:[bp + 0Eh]
; @05A9D 0000:5A9D original=8b5e14
    mov bx, word ptr ss:[bp + 014h]
; @05AA0 0000:5AA0 original=2e031ebc95
    add bx, word ptr cs:[095BCh]
; @05AA5 0000:5AA5 original=2e031ebc95
    add bx, word ptr cs:[095BCh]
; @05AAA 0000:5AAA original=2e031ebc95
    add bx, word ptr cs:[095BCh]
; @05AAF 0000:5AAF original=d1e3
    shl bx, 1
; @05AB1 0000:5AB1 original=2effa7b65a
    jmp word ptr cs:[bx + 05AB6h]
; @05AB6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,047h,0AAh,046h,084h,046h,0E5h,029h,0C6h,029h,091h,029h,042h,035h,0D8h,034h
; @05AC6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,034h
; sub_0000_5AC8
; @05AC8 0000:5AC8 original=8b5e14
    mov bx, word ptr ss:[bp + 014h]
; @05ACB 0000:5ACB original=2e031ebc95
    add bx, word ptr cs:[095BCh]
; @05AD0 0000:5AD0 original=2e031ebc95
    add bx, word ptr cs:[095BCh]
; @05AD5 0000:5AD5 original=2e031ebc95
    add bx, word ptr cs:[095BCh]
; @05ADA 0000:5ADA original=d1e3
    shl bx, 1
; @05ADC 0000:5ADC original=2effa7e25a
    jmp word ptr cs:[bx + 05AE2h]
; @05AE1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,096h,048h,0Eh,048h,040h,047h,0F9h,02Ah,0B9h,02Ah,04Fh,02Ah,057h,036h,0CCh
; @05AF1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 035h,06Ch,035h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B01 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B11 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B21 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B31 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B41 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B51 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B61 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B71 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B81 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05B91 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05BA1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @05BAC 0000:5BAC original=2e892eaa5b
    mov word ptr cs:[05BAAh], bp
; @05BB1 0000:5BB1 original=2ec706a85bffff
    mov word ptr cs:[05BA8h], 0FFFFh
; @05BB8 0000:5BB8 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05BBD 0000:5BBD original=d1e3
    shl bx, 1
; @05BBF 0000:5BBF original=2effa7c45b
    jmp word ptr cs:[bx + 05BC4h]
; @05BC4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,045h,0D9h,027h,0AFh,033h
; sub_0000_5BCA
; @05BCA 0000:5BCA original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05BCF 0000:5BCF original=d1e3
    shl bx, 1
; @05BD1 0000:5BD1 original=2effa7d65b
    jmp word ptr cs:[bx + 05BD6h]
; @05BD6 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,044h,0A2h,027h,089h,033h
; sub_0000_5BDC
; @05BDC 0000:5BDC original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05BE1 0000:5BE1 original=d1e3
    shl bx, 1
; @05BE3 0000:5BE3 original=2effa7e85b
    jmp word ptr cs:[bx + 05BE8h]
; @05BE8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Bh,044h,050h,027h,054h,033h
; sub_0000_5BEE
; @05BEE 0000:5BEE original=e854f5
    CALL_NEAR loc_05145
; @05BF1 0000:5BF1 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05BF6 0000:5BF6 original=d1e3
    shl bx, 1
; @05BF8 0000:5BF8 original=2effa7fe5b
    jmp word ptr cs:[bx + 05BFEh]
; @05BFD UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,06Ch,044h,037h,027h,045h,033h
; sub_0000_5C04
; @05C04 0000:5C04 original=33ff
    xor di, di
; @05C06 0000:5C06 original=33f6
    xor si, si
; @05C08 0000:5C08 original=bdc800
    mov bp, 0C8h
; @05C0B 0000:5C0B original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @05C10 0000:5C10 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05C15 0000:5C15 original=d1e3
    shl bx, 1
; @05C17 0000:5C17 original=2effa71c5c
    jmp word ptr cs:[bx + 05C1Ch]
; @05C1C UNKNOWN bootstrap bytes: not reconstructed code/data
    db 041h,04Ah,02Dh,02Eh,024h,038h
; sub_0000_5C22
; @05C22 0000:5C22 original=e8c9ff
    CALL_NEAR loc_05BEE
; @05C25 0000:5C25 original=33ff
    xor di, di
; @05C27 0000:5C27 original=33f6
    xor si, si
; @05C29 0000:5C29 original=2ea19895
    mov ax, word ptr cs:[09598h]
; @05C2D 0000:5C2D original=05d007
    add ax, 07D0h
; @05C30 0000:5C30 original=40
    inc ax
; @05C31 0000:5C31 original=8ed8
    mov ds, ax
; @05C33 0000:5C33 original=eb11
    JMP_SHORT loc_05C46
; sub_0000_5C35
; @05C35 0000:5C35 original=e8b6ff
    CALL_NEAR loc_05BEE
; @05C38 0000:5C38 original=b44e
    mov ah, 04Eh
; @05C3A 0000:5C3A original=32c0
    xor al, al
; @05C3C 0000:5C3C original=e8c1fd
    CALL_NEAR loc_05A00
; @05C3F 0000:5C3F original=33f6
    xor si, si
; @05C41 0000:5C41 original=2e8e1eb295
    mov ds, word ptr cs:[095B2h]
; sub_0000_5C46
; @05C46 0000:5C46 original=ad
    lodsw
; @05C47 0000:5C47 original=2ea3fd58
    mov word ptr cs:[058FDh], ax
; @05C4B 0000:5C4B original=ad
    lodsw
; @05C4C 0000:5C4C original=2ea3ff58
    mov word ptr cs:[058FFh], ax
; @05C50 0000:5C50 original=2e8936fb58
    mov word ptr cs:[058FBh], si
; @05C55 0000:5C55 original=2e893ef958
    mov word ptr cs:[058F9h], di
; @05C5A 0000:5C5A original=2ec70605590000
    mov word ptr cs:[05905h], 0
; @05C61 0000:5C61 original=2ec70607590000
    mov word ptr cs:[05907h], 0
; @05C68 0000:5C68 original=2ec70601590600
    mov word ptr cs:[05901h], 6
; @05C6F 0000:5C6F original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @05C74 0000:5C74 original=2e8b1ebc95
    mov bx, word ptr cs:[095BCh]
; @05C79 0000:5C79 original=d1e3
    shl bx, 1
; @05C7B 0000:5C7B original=2eff975a59
    call word ptr cs:[bx + 0595Ah]
; @05C80 0000:5C80 original=e846f4
    CALL_NEAR loc_050C9
; @05C83 0000:5C83 original=2e8306015902
    add word ptr cs:[05901h], 2
; @05C89 0000:5C89 original=2ea10159
    mov ax, word ptr cs:[05901h]
; @05C8D 0000:5C8D original=2e3b06fd58
    cmp ax, word ptr cs:[058FDh]
; @05C92 0000:5C92 original=75e0
    JNE_SHORT loc_05C74
; @05C94 0000:5C94 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @05C99 0000:5C99 original=c3
    ret
; sub_0000_5C9A
; @05C9A 0000:5C9A original=e851ff
    CALL_NEAR loc_05BEE
; @05C9D 0000:5C9D original=b81b00
    mov ax, 01Bh
; @05CA0 0000:5CA0 original=e85dfd
    CALL_NEAR loc_05A00
; @05CA3 0000:5CA3 original=be2500
    mov si, 025h
; @05CA6 0000:5CA6 original=d1e6
    shl si, 1
; @05CA8 0000:5CA8 original=81c6e40b
    add si, 0BE4h
; @05CAC 0000:5CAC original=2e8b34
    mov si, word ptr cs:[si]
; @05CAF 0000:5CAF original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @05CB4 0000:5CB4 original=e88fff
    CALL_NEAR loc_05C46
; sub_0000_5CB7
; @05CB7 0000:5CB7 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @05CBD 0000:5CBD original=7401
    JE_SHORT loc_05CC0
; @05CBF 0000:5CBF original=c3
    ret
; @05CC0 0000:5CC0 original=1e
    push ds
; @05CC1 0000:5CC1 original=b80501
    mov ax, 0105h
; @05CC4 0000:5CC4 original=bace03
    mov dx, 03CEh
; @05CC7 0000:5CC7 original=ef
    out dx, ax
; @05CC8 0000:5CC8 original=33f6
    xor si, si
; @05CCA 0000:5CCA original=bf0020
    mov di, 02000h
; @05CCD 0000:5CCD original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @05CD2 0000:5CD2 original=06
    push es
; @05CD3 0000:5CD3 original=1f
    pop ds
; @05CD4 0000:5CD4 original=b9401f
    mov cx, 01F40h
; @05CD7 0000:5CD7 original=f3a4
    rep movsb
; @05CD9 0000:5CD9 original=b80500
    mov ax, 5
; @05CDC 0000:5CDC original=bace03
    mov dx, 03CEh
; @05CDF 0000:5CDF original=ef
    out dx, ax
; @05CE0 0000:5CE0 original=1f
    pop ds
; @05CE1 0000:5CE1 original=c3
    ret
; @05CE2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 052h,086h,0F2h,0E8h,01h,00h,05Ah,052h,0D0h,0EAh,0D0h,0EAh,0D0h,0EAh,0D0h,0EAh
; @05CF2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,01h,00h,05Ah,080h,0E2h,0Fh,080h,0FAh,0Ah,072h,03h,080h,0C2h,07h,080h
; @05D02 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,030h,08Ah,0C2h,0B4h,0Eh,0CDh,010h,0C3h
; @05D0B 0000:5D0B original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @05D10 0000:5D10 original=fe06cf22
    inc byte ptr ds:[022CFh]
; @05D14 0000:5D14 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @05D19 0000:5D19 original=fb
    sti
; @05D1A 0000:5D1A original=e461
    in al, 061h
; @05D1C 0000:5D1C original=24fc
    and al, 0FCh
; @05D1E 0000:5D1E original=e661
    out 061h, al
; @05D20 0000:5D20 original=ff36aa21
    push word ptr ds:[021AAh]
; @05D24 0000:5D24 original=e873f5
    CALL_NEAR loc_0529A
; @05D27 0000:5D27 original=8f06aa21
    pop word ptr ds:[021AAh]
; @05D2B 0000:5D2B original=e817f4
    CALL_NEAR loc_05145
; @05D2E 0000:5D2E original=e80d6e
    CALL_NEAR loc_0CB3E
; @05D31 0000:5D31 original=e88bf1
    CALL_NEAR loc_04EBF
; @05D34 0000:5D34 original=e885a9
    CALL_NEAR loc_006BC
; @05D37 0000:5D37 original=b80300
    mov ax, 3
; @05D3A 0000:5D3A original=cd10
    int 010h
; @05D3C 0000:5D3C original=803ecf2200
    cmp byte ptr ds:[022CFh], 0
; @05D41 0000:5D41 original=743b
    JE_SHORT loc_05D7E
; @05D43 0000:5D43 original=bad022
    mov dx, 022D0h
; @05D46 0000:5D46 original=b409
    mov ah, 9
; @05D48 0000:5D48 original=cd21
    int 021h
; @05D4A 0000:5D4A original=8b36aa21
    mov si, word ptr ds:[021AAh]
; @05D4E 0000:5D4E original=ac
    lodsb
; @05D4F 0000:5D4F original=0ac0
    or al, al
; @05D51 0000:5D51 original=75fb
    JNE_SHORT loc_05D4E
; @05D53 0000:5D53 original=c644ff24
    mov byte ptr ds:[si - 1], 024h
; @05D57 0000:5D57 original=8b16aa21
    mov dx, word ptr ds:[021AAh]
; @05D5B 0000:5D5B original=8bf2
    mov si, dx
; @05D5D 0000:5D5D original=807c013a
    cmp byte ptr ds:[si + 1], 03Ah
; @05D61 0000:5D61 original=7503
    JNE_SHORT loc_05D66
; @05D63 0000:5D63 original=83c202
    add dx, 2
; @05D66 0000:5D66 original=b409
    mov ah, 9
; @05D68 0000:5D68 original=cd21
    int 021h
; @05D6A 0000:5D6A original=baed22
    mov dx, 022EDh
; @05D6D 0000:5D6D original=b409
    mov ah, 9
; @05D6F 0000:5D6F original=cd21
    int 021h
; @05D71 0000:5D71 original=e8cc68
    CALL_NEAR loc_0C640
; @05D74 0000:5D74 original=9aad017f0f
    CALL_FAR 0F7Fh,01ADh
; @05D79 0000:5D79 original=b8004c
    mov ax, 04C00h
; @05D7C 0000:5D7C original=cd21
    int 021h
; @05D7E 0000:5D7E original=b200
    mov dl, 0
; @05D80 0000:5D80 original=b616
    mov dh, 016h
; @05D82 0000:5D82 original=b402
    mov ah, 2
; @05D84 0000:5D84 original=b700
    mov bh, 0
; @05D86 0000:5D86 original=cd10
    int 010h
; @05D88 0000:5D88 original=b800b8
    mov ax, 0B800h
; @05D8B 0000:5D8B original=8ec0
    mov es, ax
; @05D8D 0000:5D8D original=33ff
    xor di, di
; @05D8F 0000:5D8F original=be88a9
    mov si, 0A988h
; @05D92 0000:5D92 original=b9d007
    mov cx, 07D0h
; @05D95 0000:5D95 original=f3a5
    rep movsw
; @05D97 0000:5D97 original=fa
    cli
; @05D98 0000:5D98 original=33c0
    xor ax, ax
; @05D9A 0000:5D9A original=8ec0
    mov es, ax
; @05D9C 0000:5D9C original=26a01a04
    mov al, byte ptr es:[041Ah]
; @05DA0 0000:5DA0 original=26a21c04
    mov byte ptr es:[041Ch], al
; @05DA4 0000:5DA4 original=fb
    sti
; @05DA5 0000:5DA5 original=e89868
    CALL_NEAR loc_0C640
; @05DA8 0000:5DA8 original=9aad017f0f
    CALL_FAR 0F7Fh,01ADh
; @05DAD 0000:5DAD original=b8004c
    mov ax, 04C00h
; @05DB0 0000:5DB0 original=cd21
    int 021h
; sub_0000_5DB2
; @05DB2 0000:5DB2 original=c70654a90000
    mov word ptr ds:[0A954h], 0
; @05DB8 0000:5DB8 original=c7060a230000
    mov word ptr ds:[0230Ah], 0
; @05DBE 0000:5DBE original=8b4604
    mov ax, word ptr ss:[bp + 4]
; @05DC1 0000:5DC1 original=3b060423
    cmp ax, word ptr ds:[02304h]
; @05DC5 0000:5DC5 original=7204
    JB_SHORT loc_05DCB
; @05DC7 0000:5DC7 original=770a
    JA_SHORT loc_05DD3
; @05DC9 0000:5DC9 original=eb0e
    JMP_SHORT loc_05DD9
; @05DCB 0000:5DCB original=c70654a90100
    mov word ptr ds:[0A954h], 1
; @05DD1 0000:5DD1 original=eb06
    JMP_SHORT loc_05DD9
; @05DD3 0000:5DD3 original=c70654a90200
    mov word ptr ds:[0A954h], 2
; @05DD9 0000:5DD9 original=8b4602
    mov ax, word ptr ss:[bp + 2]
; @05DDC 0000:5DDC original=3b060623
    cmp ax, word ptr ds:[02306h]
; @05DE0 0000:5DE0 original=7c04
    JL_SHORT loc_05DE6
; @05DE2 0000:5DE2 original=7f09
    JG_SHORT loc_05DED
; @05DE4 0000:5DE4 original=eb0c
    JMP_SHORT loc_05DF2
; @05DE6 0000:5DE6 original=830e54a904
    or word ptr ds:[0A954h], 4
; @05DEB 0000:5DEB original=eb05
    JMP_SHORT loc_05DF2
; @05DED 0000:5DED original=830e54a908
    or word ptr ds:[0A954h], 8
; @05DF2 0000:5DF2 original=bb48a3
    mov bx, 0A348h
; @05DF5 0000:5DF5 original=a154a9
    mov ax, word ptr ds:[0A954h]
; @05DF8 0000:5DF8 original=d7
    xlat
; @05DF9 0000:5DF9 original=3cff
    cmp al, 0FFh
; @05DFB 0000:5DFB original=7417
    JE_SHORT loc_05E14
; @05DFD 0000:5DFD original=894606
    mov word ptr ss:[bp + 6], ax
; @05E00 0000:5E00 original=8b1e0823
    mov bx, word ptr ds:[02308h]
; @05E04 0000:5E04 original=d1e3
    shl bx, 1
; @05E06 0000:5E06 original=2effa70c5e
    jmp word ptr cs:[bx + 05E0Ch]
; @05E0B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0A2h,0AFh,063h,0AFh,060h,0AFh,0E4h,0AEh
; @05E14 0000:5E14 original=c7060a230100
    mov word ptr ds:[0230Ah], 1
; @05E1A 0000:5E1A original=c3
    ret
; @05E1B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BAh,04h,00h,083h,07Fh,014h,01h,074h,03h,0BAh,0Ch,00h,08Bh,046h,04h,08Bh
; @05E2B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Fh,04h,03h,0CAh,02Bh,0C1h,089h,046h,02Ch,08Bh,046h,02h,08Bh,04Fh,02h,03h
; @05E3B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CAh,02Bh,0C1h,089h,046h,02Ah,0C3h
; @05E42 0000:5E42 original=c7060c230000 runtime CFG evidence
    mov word ptr ds:[0230Ch], 0
; @05E48 0000:5E48 original=c7060e230000 runtime CFG evidence
    mov word ptr ds:[0230Eh], 0
; @05E4E 0000:5E4E original=c70610230000 runtime CFG evidence
    mov word ptr ds:[02310h], 0
; @05E54 0000:5E54 original=8b462c runtime CFG evidence
    mov ax, word ptr ss:[bp + 02Ch]
; @05E57 0000:5E57 original=0bc0 runtime CFG evidence
    or ax, ax
; @05E59 0000:5E59 original=7906 runtime CFG evidence
    JNS_SHORT loc_05E61
; @05E5B 0000:5E5B original=f7d8 runtime CFG evidence
    neg ax
; @05E5D 0000:5E5D original=ff060c23 runtime CFG evidence
    inc word ptr ds:[0230Ch]
; @05E61 0000:5E61 original=8b5e2a runtime CFG evidence
    mov bx, word ptr ss:[bp + 02Ah]
; @05E64 0000:5E64 original=0bdb runtime CFG evidence
    or bx, bx
; @05E66 0000:5E66 original=7906 runtime CFG evidence
    JNS_SHORT loc_05E6E
; @05E68 0000:5E68 original=f7db runtime CFG evidence
    neg bx
; @05E6A 0000:5E6A original=ff060e23 runtime CFG evidence
    inc word ptr ds:[0230Eh]
; @05E6E 0000:5E6E original=3bc3 runtime CFG evidence
    cmp ax, bx
; @05E70 0000:5E70 original=7421 runtime CFG evidence
    JE_SHORT loc_05E93
; @05E72 0000:5E72 original=770d runtime CFG evidence
    JA_SHORT loc_05E81
; @05E74 0000:5E74 original=01462e runtime CFG evidence
    add word ptr ss:[bp + 02Eh], ax
; @05E77 0000:5E77 original=395e2e runtime CFG evidence
    cmp word ptr ss:[bp + 02Eh], bx
; @05E7A 0000:5E7A original=761a runtime CFG evidence
    JBE_SHORT loc_05E96
; @05E7C 0000:5E7C original=295e2e runtime CFG evidence
    sub word ptr ss:[bp + 02Eh], bx
; @05E7F 0000:5E7F original=eb12 runtime CFG evidence
    JMP_SHORT loc_05E93
; @05E81 0000:5E81 original=015e2e runtime CFG evidence
    add word ptr ss:[bp + 02Eh], bx
; @05E84 0000:5E84 original=39462e runtime CFG evidence
    cmp word ptr ss:[bp + 02Eh], ax
; @05E87 0000:5E87 original=7605 runtime CFG evidence
    JBE_SHORT loc_05E8E
; @05E89 0000:5E89 original=29462e runtime CFG evidence
    sub word ptr ss:[bp + 02Eh], ax
; @05E8C 0000:5E8C original=eb05 runtime CFG evidence
    JMP_SHORT loc_05E93
; @05E8E 0000:5E8E original=e82400 runtime CFG evidence
    CALL_NEAR loc_05EB5
; @05E91 0000:5E91 original=eb06 runtime CFG evidence
    JMP_SHORT loc_05E99
; @05E93 0000:5E93 original=e81f00 runtime CFG evidence
    CALL_NEAR loc_05EB5
; @05E96 0000:5E96 original=e82f00 runtime CFG evidence
    CALL_NEAR loc_05EC8
; @05E99 0000:5E99 original=bb48a3 runtime CFG evidence
    mov bx, 0A348h
; @05E9C 0000:5E9C original=a11023 runtime CFG evidence
    mov ax, word ptr ds:[02310h]
; @05E9F 0000:5E9F original=d7 runtime CFG evidence
    xlat
; @05EA0 0000:5EA0 original=3cff runtime CFG evidence
    cmp al, 0FFh
; @05EA2 0000:5EA2 original=7501 runtime CFG evidence
    JNE_SHORT loc_05EA5
; @05EA4 0000:5EA4 original=c3 runtime CFG evidence
    ret
; @05EA5 0000:5EA5 original=894606 runtime CFG evidence
    mov word ptr ss:[bp + 6], ax
; @05EA8 0000:5EA8 original=833e122303 runtime CFG evidence
    cmp word ptr ds:[02312h], 3
; @05EAD 0000:5EAD original=7503 runtime CFG evidence
    JNE_SHORT loc_05EB2
; @05EAF 0000:5EAF original=e97050 runtime CFG evidence
    JMP_NEAR loc_0AF22
; @05EB2 0000:5EB2 original=e9ae50 runtime CFG evidence
    JMP_NEAR loc_0AF63
; @05EB5 0000:5EB5 original=833e0c2301 runtime CFG evidence
    cmp word ptr ds:[0230Ch], 1
; @05EBA 0000:5EBA original=7406 runtime CFG evidence
    JE_SHORT loc_05EC2
; @05EBC 0000:5EBC original=830e102302 runtime CFG evidence
    or word ptr ds:[02310h], 2
; @05EC1 0000:5EC1 original=c3 runtime CFG evidence
    ret
; @05EC2 0000:5EC2 original=830e102301 runtime CFG evidence
    or word ptr ds:[02310h], 1
; @05EC7 0000:5EC7 original=c3 runtime CFG evidence
    ret
; @05EC8 0000:5EC8 original=833e0e2301 runtime CFG evidence
    cmp word ptr ds:[0230Eh], 1
; @05ECD 0000:5ECD original=7406 runtime CFG evidence
    JE_SHORT loc_05ED5
; @05ECF 0000:5ECF original=830e102308 runtime CFG evidence
    or word ptr ds:[02310h], 8
; @05ED4 0000:5ED4 original=c3 runtime CFG evidence
    ret
; @05ED5 0000:5ED5 original=830e102304 runtime CFG evidence
    or word ptr ds:[02310h], 4
; @05EDA 0000:5EDA original=c3 runtime CFG evidence
    ret
; sub_0000_5EDB
; @05EDB 0000:5EDB original=bd1823
    mov bp, 02318h
; @05EDE 0000:5EDE original=e8abf2
    CALL_NEAR loc_0518C
; @05EE1 0000:5EE1 original=bd1423
    mov bp, 02314h
; sub_0000_5EE4
; @05EE4 0000:5EE4 original=8a4603
    mov al, byte ptr ss:[bp + 3]
; @05EE7 0000:5EE7 original=e80f00
    CALL_NEAR loc_05EF9
; @05EEA 0000:5EEA original=8a4602
    mov al, byte ptr ss:[bp + 2]
; @05EED 0000:5EED original=e80900
    CALL_NEAR loc_05EF9
; @05EF0 0000:5EF0 original=8a4601
    mov al, byte ptr ss:[bp + 1]
; @05EF3 0000:5EF3 original=e80300
    CALL_NEAR loc_05EF9
; @05EF6 0000:5EF6 original=8a4600
    mov al, byte ptr ss:[bp]
; sub_0000_5EF9
; @05EF9 0000:5EF9 original=50
    push ax
; @05EFA 0000:5EFA original=d0e8
    shr al, 1
; @05EFC 0000:5EFC original=d0e8
    shr al, 1
; @05EFE 0000:5EFE original=d0e8
    shr al, 1
; @05F00 0000:5F00 original=d0e8
    shr al, 1
; @05F02 0000:5F02 original=e80100
    CALL_NEAR loc_05F06
; @05F05 0000:5F05 original=58
    pop ax
; sub_0000_5F06
; @05F06 0000:5F06 original=240f
    and al, 0Fh
; @05F08 0000:5F08 original=0430
    add al, 030h
; @05F0A 0000:5F0A original=e98df2
    JMP_NEAR loc_0519A
; sub_0000_5F0D
; @05F0D 0000:5F0D original=55
    push bp
; @05F0E 0000:5F0E original=50
    push ax
; @05F0F 0000:5F0F original=52
    push dx
; @05F10 0000:5F10 original=bd1423
    mov bp, 02314h
; @05F13 0000:5F13 original=8a4600
    mov al, byte ptr ss:[bp]
; @05F16 0000:5F16 original=02c3
    add al, bl
; @05F18 0000:5F18 original=27
    daa
; @05F19 0000:5F19 original=884600
    mov byte ptr ss:[bp], al
; @05F1C 0000:5F1C original=45
    inc bp
; @05F1D 0000:5F1D original=8a4600
    mov al, byte ptr ss:[bp]
; @05F20 0000:5F20 original=8af0
    mov dh, al
; @05F22 0000:5F22 original=12c7
    adc al, bh
; @05F24 0000:5F24 original=27
    daa
; @05F25 0000:5F25 original=884600
    mov byte ptr ss:[bp], al
; @05F28 0000:5F28 original=8ad0
    mov dl, al
; @05F2A 0000:5F2A original=45
    inc bp
; @05F2B 0000:5F2B original=8a4600
    mov al, byte ptr ss:[bp]
; @05F2E 0000:5F2E original=1400
    adc al, 0
; @05F30 0000:5F30 original=27
    daa
; @05F31 0000:5F31 original=884600
    mov byte ptr ss:[bp], al
; @05F34 0000:5F34 original=45
    inc bp
; @05F35 0000:5F35 original=8a4600
    mov al, byte ptr ss:[bp]
; @05F38 0000:5F38 original=1400
    adc al, 0
; @05F3A 0000:5F3A original=27
    daa
; @05F3B 0000:5F3B original=884600
    mov byte ptr ss:[bp], al
; @05F3E 0000:5F3E original=45
    inc bp
; @05F3F 0000:5F3F original=5a
    pop dx
; @05F40 0000:5F40 original=58
    pop ax
; @05F41 0000:5F41 original=5d
    pop bp
; @05F42 0000:5F42 original=c3
    ret
; sub_0000_5F43
; @05F43 0000:5F43 original=b004
    mov al, 4
; @05F45 0000:5F45 original=813e50239c00
    cmp word ptr ds:[02350h], 09Ch
; @05F4B 0000:5F4B original=7411
    JE_SHORT loc_05F5E
; @05F4D 0000:5F4D original=b005
    mov al, 5
; @05F4F 0000:5F4F original=813e5023a00e
    cmp word ptr ds:[02350h], 0EA0h
; @05F55 0000:5F55 original=7407
    JE_SHORT loc_05F5E
; @05F57 0000:5F57 original=bb1e23
    mov bx, 0231Eh
; @05F5A 0000:5F5A original=a05623
    mov al, byte ptr ds:[02356h]
; @05F5D 0000:5F5D original=d7
    xlat
; @05F5E 0000:5F5E original=e9bb6b
    JMP_NEAR loc_0CB1C
; sub_0000_5F61
; @05F61 0000:5F61 original=833e7ea400
    cmp word ptr ds:[0A47Eh], 0
; @05F66 0000:5F66 original=7521
    JNE_SHORT loc_05F89
; @05F68 0000:5F68 original=833e80a400
    cmp word ptr ds:[0A480h], 0
; @05F6D 0000:5F6D original=741a
    JE_SHORT loc_05F89
; @05F6F 0000:5F6F original=ff0e80a4
    dec word ptr ds:[0A480h]
; @05F73 0000:5F73 original=7514
    JNE_SHORT loc_05F89
; @05F75 0000:5F75 original=bb1e23
    mov bx, 0231Eh
; @05F78 0000:5F78 original=a05623
    mov al, byte ptr ds:[02356h]
; @05F7B 0000:5F7B original=d7
    xlat
; @05F7C 0000:5F7C original=813e50235007
    cmp word ptr ds:[02350h], 0750h
; @05F82 0000:5F82 original=7202
    JB_SHORT loc_05F86
; @05F84 0000:5F84 original=b006
    mov al, 6
; @05F86 0000:5F86 original=e8936b
    CALL_NEAR loc_0CB1C
; @05F89 0000:5F89 original=833e282307
    cmp word ptr ds:[02328h], 7
; @05F8E 0000:5F8E original=752a
    JNE_SHORT loc_05FBA
; @05F90 0000:5F90 original=833e4223ff
    cmp word ptr ds:[02342h], -1
; @05F95 0000:5F95 original=7415
    JE_SHORT loc_05FAC
; @05F97 0000:5F97 original=ff064423
    inc word ptr ds:[02344h]
; @05F9B 0000:5F9B original=833e442302
    cmp word ptr ds:[02344h], 2
; @05FA0 0000:5FA0 original=7518
    JNE_SHORT loc_05FBA
; @05FA2 0000:5FA2 original=f71e4223
    neg word ptr ds:[02342h]
; @05FA6 0000:5FA6 original=ff064823
    inc word ptr ds:[02348h]
; @05FAA 0000:5FAA original=eb0e
    JMP_SHORT loc_05FBA
; @05FAC 0000:5FAC original=ff0e4423
    dec word ptr ds:[02344h]
; @05FB0 0000:5FB0 original=7508
    JNE_SHORT loc_05FBA
; @05FB2 0000:5FB2 original=f71e4223
    neg word ptr ds:[02342h]
; @05FB6 0000:5FB6 original=ff064823
    inc word ptr ds:[02348h]
; @05FBA 0000:5FBA original=832648230f
    and word ptr ds:[02348h], 0Fh
; @05FBF 0000:5FBF original=750a
    JNE_SHORT loc_05FCB
; @05FC1 0000:5FC1 original=c70646230800
    mov word ptr ds:[02346h], 8
; @05FC7 0000:5FC7 original=ff064823
    inc word ptr ds:[02348h]
; @05FCB 0000:5FCB original=ff063223
    inc word ptr ds:[02332h]
; @05FCF 0000:5FCF original=8326322303
    and word ptr ds:[02332h], 3
; @05FD4 0000:5FD4 original=755a
    JNE_SHORT loc_06030
; @05FD6 0000:5FD6 original=ff063423
    inc word ptr ds:[02334h]
; @05FDA 0000:5FDA original=833e34230a
    cmp word ptr ds:[02334h], 0Ah
; @05FDF 0000:5FDF original=7206
    JB_SHORT loc_05FE7
; @05FE1 0000:5FE1 original=c70634230000
    mov word ptr ds:[02334h], 0
; @05FE7 0000:5FE7 original=ff063823
    inc word ptr ds:[02338h]
; @05FEB 0000:5FEB original=833e382306
    cmp word ptr ds:[02338h], 6
; @05FF0 0000:5FF0 original=7206
    JB_SHORT loc_05FF8
; @05FF2 0000:5FF2 original=c70638230000
    mov word ptr ds:[02338h], 0
; @05FF8 0000:5FF8 original=ff063a23
    inc word ptr ds:[0233Ah]
part02 ends
end
