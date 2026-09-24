; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part01 segment byte public 'CODE'
assume cs:part01,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; Modern record/state symbols; evidence in metadata/record-movement.json.
REC_X equ 04h
REC_Y equ 02h
CopyWorkspace104x192ToTandy_03354 equ 01354h
ClearTandy104x200_03389 equ 01389h
CopyPackedRowsToTandyBanks_0306F equ 0106Fh
CopyPackedRowsStride104_03097 equ 01097h
CopyPackedRowsStride160_030B4 equ 010B4h
TandyOffsetFromRow9EE8_03103 equ 01103h
TandyOffsetFromRow9BC8_03118 equ 01118h
TandyOffsetFromRow9D58_0312D equ 0112Dh
ClearTandy32K_03345 equ 01345h
loc_025AE equ 05AEh
loc_025B2 equ 05B2h
loc_02E6E equ 0E6Eh
loc_02ECB equ 0ECBh
loc_02F40 equ 0F40h
loc_02F81 equ 0F81h
loc_030DE equ 010DEh
loc_030EC equ 010ECh
loc_030FF equ 010FFh
loc_034B5 equ 014B5h
loc_034C5 equ 014C5h
loc_034CB equ 014CBh
loc_034DE equ 014DEh
loc_03548 equ 01548h
loc_03586 equ 01586h
loc_0359A equ 0159Ah
loc_035AA equ 015AAh
loc_035BA equ 015BAh
loc_035D8 equ 015D8h
loc_03663 equ 01663h
loc_05A36 equ 03A36h
loc_024E9 equ 04E9h
loc_02523 equ 0523h
loc_02557 equ 0557h
loc_02605 equ 0605h
loc_0260C equ 060Ch
loc_02613 equ 0613h
loc_02672 equ 0672h
loc_026B8 equ 06B8h
loc_026F6 equ 06F6h
loc_026FA equ 06FAh
loc_026FD equ 06FDh
loc_0270C equ 070Ch
loc_02717 equ 0717h
loc_02718 equ 0718h
loc_0272F equ 072Fh
loc_0276E equ 076Eh
loc_027B6 equ 07B6h
loc_027B7 equ 07B7h
loc_027CB equ 07CBh
loc_027D9 equ 07D9h
loc_027E6 equ 07E6h
loc_027EB equ 07EBh
loc_027FA equ 07FAh
loc_02802 equ 0802h
loc_0280D equ 080Dh
loc_02812 equ 0812h
loc_0282C equ 082Ch
loc_0283F equ 083Fh
loc_02863 equ 0863h
loc_02888 equ 0888h
loc_0288A equ 088Ah
loc_02898 equ 0898h
loc_0289A equ 089Ah
loc_028DD equ 08DDh
loc_028E0 equ 08E0h
loc_02916 equ 0916h
loc_02919 equ 0919h
loc_0291C equ 091Ch
loc_02932 equ 0932h
loc_0294F equ 094Fh
loc_02981 equ 0981h
loc_02982 equ 0982h
loc_02B99 equ 0B99h
loc_02B9B equ 0B9Bh
loc_02D24 equ 0D24h
loc_02D27 equ 0D27h
loc_02D5C equ 0D5Ch
loc_02D7C equ 0D7Ch
loc_02D81 equ 0D81h
loc_02D8C equ 0D8Ch
loc_02D8D equ 0D8Dh
loc_02DBA equ 0DBAh
loc_02DC2 equ 0DC2h
loc_02DC6 equ 0DC6h
loc_02DCB equ 0DCBh
loc_02DF8 equ 0DF8h
loc_02DFE equ 0DFEh
loc_02E1B equ 0E1Bh
loc_02E20 equ 0E20h
loc_02E23 equ 0E23h
loc_02E39 equ 0E39h
loc_0307E equ 0107Eh
loc_03093 equ 01093h
loc_030A6 equ 010A6h
loc_030C3 equ 010C3h
loc_0315A equ 0115Ah
loc_03161 equ 01161h
loc_031C1 equ 011C1h
loc_031F0 equ 011F0h
loc_0321F equ 0121Fh
loc_0324E equ 0124Eh
loc_0327D equ 0127Dh
loc_032AC equ 012ACh
loc_032DB equ 012DBh
loc_0330A equ 0130Ah
loc_03321 equ 01321h
loc_03322 equ 01322h
loc_0333D equ 0133Dh
loc_0336B equ 0136Bh
loc_03380 equ 01380h
loc_03393 equ 01393h
loc_033AB equ 013ABh
loc_033AF equ 013AFh
loc_033B7 equ 013B7h
loc_033BC equ 013BCh
loc_033C2 equ 013C2h
loc_033DD equ 013DDh
loc_03433 equ 01433h
loc_03445 equ 01445h
loc_0344B equ 0144Bh
loc_0347C equ 0147Ch
loc_03491 equ 01491h
loc_034AA equ 014AAh
loc_036B7 equ 016B7h
loc_036B9 equ 016B9h
loc_03752 equ 01752h
loc_03755 equ 01755h
loc_0378A equ 0178Ah
loc_037A0 equ 017A0h
loc_037AE equ 017AEh
loc_037B0 equ 017B0h
loc_037C6 equ 017C6h
loc_037C7 equ 017C7h
loc_037EE equ 017EEh
loc_037F0 equ 017F0h
loc_037F4 equ 017F4h
loc_037F9 equ 017F9h
loc_0380E equ 0180Eh
loc_0381A equ 0181Ah
loc_0381D equ 0181Dh
loc_03829 equ 01829h
loc_03840 equ 01840h
loc_044AA equ 024AAh
loc_044D7 equ 024D7h
loc_0511F equ 0311Fh
; @02000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h
; @02010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h,055h,01Ch,026h,09h
; @02020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h,055h,050h,083h,0C7h
; @02030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 068h,083h,0C6h,0Ah,0E2h,0C5h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,04h,0B2h,0FFh
; @02040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh
; @02050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h
; @02060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,026h,08h,055h,01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h
; @02070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,026h,08h,055h,050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0BFh,02Eh,08Eh,01Eh
; @02080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h,08Bh,04h,0B2h,0FFh,0F7h,0D0h,0F6h,0D2h,0D0h,0E8h,0D0h,0DCh,0D0h
; @02090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h,0DCh,0D0h,0DAh,0D0h,0E8h,0D0h
; @020A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0DAh,026h,09h,05h,026h,08h,055h,02h,026h,09h,045h,01Ah,026h,08h
; @020B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,01Ch,026h,09h,045h,034h,026h,08h,055h,036h,026h,09h,045h,04Eh,026h,08h
; @020C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,050h,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0B9h,02Eh,08Eh,01Eh,096h,095h,0C3h
; @020D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h
; @020E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h
; @020F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h,045h
; @02100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 035h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah,0E2h
; @02110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BFh,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h,0D0h
; @02120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E4h,0D0h,0D0h,0D0h,0D2h,0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h
; @02130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,01h,026h,08h,055h,01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h
; @02140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,035h,026h,08h,055h,04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah
; @02150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,0C5h,02Eh,08Eh,01Eh,096h,095h,0C3h,0B2h,0FFh,08Bh,04h,0F6h,0D2h,0F7h,0D0h
; @02160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E4h,0D0h,0D0h,0D0h,0D2h,026h,08h,015h,026h,09h,045h,01h,026h,08h,055h
; @02170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,026h,09h,045h,01Bh,026h,08h,055h,034h,026h,09h,045h,035h,026h,08h,055h
; @02180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,026h,09h,045h,04Fh,083h,0C7h,068h,083h,0C6h,0Ah,0E2h,0CBh,02Eh,08Eh,01Eh
; @02190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h,026h,08Ah,05h,022h,04h,0Ah,044h,01h,026h,088h,05h,083h,0C7h
; @021A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,026h,08Ah,05h,022h,04h,0Ah,044h,02h,026h,088h,05h,083h,0C7h,01Ah,026h
; @021B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ah,05h,022h,04h,0Ah,044h,03h,026h,088h,05h,083h,0C7h,01Ah,026h,08Ah,05h
; @021C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 022h,04h,0Ah,044h,04h,026h,088h,05h,083h,0C7h,01Ah,083h,0C6h,05h,0E2h,0C3h
; @021D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,026h,021h
; @021E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,0ACh,032h,0E4h
; @021F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,026h,09h
; @02200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,01Ah,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h
; @02210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h,0E2h,0B9h,02Eh,08Eh,01Eh
; @02220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh
; @02230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,0ACh
; @02240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h
; @02250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh,032h,0E4h,0D0h
; @02260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h,0D0h,0E8h
; @02270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h,0E2h,0A4h,02Eh
; @02280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h
; @02290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,026h,021h,05h,026h,021h,045h,01Ah,026h,021h
; @022A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,034h,026h,021h,045h,04Eh,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
; @022B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h
; @022C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh,032h,0E4h,0D0h,0E8h
; @022D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,034h,0ACh,032h
; @022E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h
; @022F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,083h,0C7h,068h,0E2h,08Fh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ACh,0B4h,0FFh,0F9h
; @02300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h,0D8h,0D0h,0DCh,0F9h,0D0h
; @02310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h
; @02320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,04Eh,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
; @02330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,05h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h
; @02340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,01Ah,0ACh
; @02350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h
; @02360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,026h,09h,045h,034h,0ACh,032h,0E4h,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h
; @02370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0E8h,0D0h,0DCh,0D0h,0E8h,0D0h,0DCh,026h,09h,045h,04Eh,083h,0C7h,068h
; @02380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,02h,0EBh,03h,0E9h,075h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Ah,024h,0B0h
; @02390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h
; @023A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,021h,05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,08Ah
; @023B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,01h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h
; @023C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,05h,08Ah,064h,02h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h
; @023D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah,064h,03h,032h,0C0h,0D0h,0E4h,0D0h
; @023E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah,064h,04h
; @023F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h
; @02400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,04Eh,083h,0C7h,068h,083h,0C6h,05h,0E2h,083h,02Eh,08Eh,01Eh,096h,095h,0C3h
; @02410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ah,024h,0B0h,0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,0F9h,0D0h,0D4h,0D0h,0D0h,026h,021h
; @02420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,026h,021h,045h,01Ah,026h,021h,045h,034h,026h,021h,045h,04Eh,08Ah,064h,01h
; @02430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,05h,08Ah,064h,02h
; @02440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah,064h
; @02450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah
; @02460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,04h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,04Eh
; @02470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C7h,068h,083h,0C6h,05h,0E2h,098h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Ah,024h
; @02480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,0FFh,0F9h,0D0h,0D4h,0D0h,0D0h,026h,021h,05h,026h,021h,045h,01Ah,026h,021h
; @02490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,034h,026h,021h,045h,04Eh,08Ah,064h,01h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h
; @024A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,05h,08Ah,064h,02h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,01Ah,08Ah
; @024B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,03h,032h,0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,034h,08Ah,064h,04h,032h
; @024C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,0D0h,0E4h,0D0h,0D0h,026h,09h,045h,04Eh,083h,0C7h,068h,083h,0C6h,05h,0E2h
; @024D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,02Eh,08Eh,01Eh,096h,095h,0C3h
; sub_0000_24D7
; @024D7 0000:24D7 original=ad
    lodsw
; @024D8 0000:24D8 original=8bc8
    mov cx, ax
; @024DA 0000:24DA original=ad
    lodsw
; @024DB 0000:24DB original=8be8
    mov bp, ax
; @024DD 0000:24DD original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @024E2 0000:24E2 original=bac403
    mov dx, 03C4h
; @024E5 0000:24E5 original=b002
    mov al, 2
; @024E7 0000:24E7 original=ee
    out dx, al
; @024E8 0000:24E8 original=42
    inc dx
; @024E9 0000:24E9 original=51
    push cx
; @024EA 0000:24EA original=b001
    mov al, 1
; @024EC 0000:24EC original=ee
    out dx, al
; @024ED 0000:24ED original=8bcd
    mov cx, bp
; @024EF 0000:24EF original=f3a4
    rep movsb
; @024F1 0000:24F1 original=2bfd
    sub di, bp
; @024F3 0000:24F3 original=d0e0
    shl al, 1
; @024F5 0000:24F5 original=ee
    out dx, al
; @024F6 0000:24F6 original=8bcd
    mov cx, bp
; @024F8 0000:24F8 original=f3a4
    rep movsb
; @024FA 0000:24FA original=2bfd
    sub di, bp
; @024FC 0000:24FC original=d0e0
    shl al, 1
; @024FE 0000:24FE original=ee
    out dx, al
; @024FF 0000:24FF original=8bcd
    mov cx, bp
; @02501 0000:2501 original=f3a4
    rep movsb
; @02503 0000:2503 original=2bfd
    sub di, bp
; @02505 0000:2505 original=d0e0
    shl al, 1
; @02507 0000:2507 original=ee
    out dx, al
; @02508 0000:2508 original=8bcd
    mov cx, bp
; @0250A 0000:250A original=f3a4
    rep movsb
; @0250C 0000:250C original=2bfd
    sub di, bp
; @0250E 0000:250E original=83c728
    add di, 028h
; @02511 0000:2511 original=59
    pop cx
; @02512 0000:2512 original=e2d5
    LOOP_SHORT loc_024E9
; @02514 0000:2514 original=b00f
    mov al, 0Fh
; @02516 0000:2516 original=ee
    out dx, al
; @02517 0000:2517 original=c3
    ret
; sub_0000_2518
; @02518 0000:2518 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @0251D 0000:251D original=ad
    lodsw
; @0251E 0000:251E original=8bc8
    mov cx, ax
; @02520 0000:2520 original=ad
    lodsw
; @02521 0000:2521 original=8be8
    mov bp, ax
; @02523 0000:2523 original=51
    push cx
; @02524 0000:2524 original=8bcd
    mov cx, bp
; @02526 0000:2526 original=f3a4
    rep movsb
; @02528 0000:2528 original=2bfd
    sub di, bp
; @0252A 0000:252A original=83c71a
    add di, 01Ah
; @0252D 0000:252D original=8bcd
    mov cx, bp
; @0252F 0000:252F original=f3a4
    rep movsb
; @02531 0000:2531 original=2bfd
    sub di, bp
; @02533 0000:2533 original=83c71a
    add di, 01Ah
; @02536 0000:2536 original=8bcd
    mov cx, bp
; @02538 0000:2538 original=f3a4
    rep movsb
; @0253A 0000:253A original=2bfd
    sub di, bp
; @0253C 0000:253C original=83c71a
    add di, 01Ah
; @0253F 0000:253F original=8bcd
    mov cx, bp
; @02541 0000:2541 original=f3a4
    rep movsb
; @02543 0000:2543 original=2bfd
    sub di, bp
; @02545 0000:2545 original=83c71a
    add di, 01Ah
; @02548 0000:2548 original=59
    pop cx
; @02549 0000:2549 original=e2d8
    LOOP_SHORT loc_02523
; @0254B 0000:254B original=c3
    ret
; sub_0000_254C
; @0254C 0000:254C original=2e8e069895
    mov es, word ptr cs:[09598h]
; @02551 0000:2551 original=ad
    lodsw
; @02552 0000:2552 original=8bc8
    mov cx, ax
; @02554 0000:2554 original=ad
    lodsw
; @02555 0000:2555 original=8be8
    mov bp, ax
; @02557 0000:2557 original=51
    push cx
; @02558 0000:2558 original=8bcd
    mov cx, bp
; @0255A 0000:255A original=f3a4
    rep movsb
; @0255C 0000:255C original=2bfd
    sub di, bp
; @0255E 0000:255E original=83c728
    add di, 028h
; @02561 0000:2561 original=8bcd
    mov cx, bp
; @02563 0000:2563 original=f3a4
    rep movsb
; @02565 0000:2565 original=2bfd
    sub di, bp
; @02567 0000:2567 original=83c728
    add di, 028h
; @0256A 0000:256A original=8bcd
    mov cx, bp
; @0256C 0000:256C original=f3a4
    rep movsb
; @0256E 0000:256E original=2bfd
    sub di, bp
; @02570 0000:2570 original=83c728
    add di, 028h
; @02573 0000:2573 original=8bcd
    mov cx, bp
; @02575 0000:2575 original=f3a4
    rep movsb
; @02577 0000:2577 original=2bfd
    sub di, bp
; @02579 0000:2579 original=83c728
    add di, 028h
; @0257C 0000:257C original=59
    pop cx
; @0257D 0000:257D original=e2d8
    LOOP_SHORT loc_02557
; @0257F 0000:257F original=c3
    ret
; @02580 0000:2580 original=8b5e02 runtime CFG evidence
    mov bx, word ptr ss:[bp + 2]
; @02583 0000:2583 original=81fbe000 runtime CFG evidence
    cmp bx, 0E0h
; @02587 0000:2587 original=7329 runtime CFG evidence
    JAE_SHORT loc_025B2
; @02589 0000:2589 original=d1e3 runtime CFG evidence
    shl bx, 1
; @0258B 0000:258B original=8b9fc899 runtime CFG evidence
    mov bx, word ptr ds:[bx - 06638h]
; @0258F 0000:258F original=83fbff runtime CFG evidence
    cmp bx, -1
; @02592 0000:2592 original=741e runtime CFG evidence
    JE_SHORT loc_025B2
; @02594 0000:2594 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @02597 0000:2597 original=8bc8 runtime CFG evidence
    mov cx, ax
; @02599 0000:2599 original=83e107 runtime CFG evidence
    and cx, 7
; @0259C 0000:259C original=894e12 runtime CFG evidence
    mov word ptr ss:[bp + 012h], cx
; @0259F 0000:259F original=d1e8 runtime CFG evidence
    shr ax, 1
; @025A1 0000:25A1 original=d1e8 runtime CFG evidence
    shr ax, 1
; @025A3 0000:25A3 original=d1e8 runtime CFG evidence
    shr ax, 1
; @025A5 0000:25A5 original=03c3 runtime CFG evidence
    add ax, bx
; @025A7 0000:25A7 original=837e2400 runtime CFG evidence
    cmp word ptr ss:[bp + 024h], 0
; @025AB 0000:25AB original=7501 runtime CFG evidence
    JNE_SHORT loc_025AE
; @025AD 0000:25AD original=c3 runtime CFG evidence
    ret
; @025AE 0000:25AE original=ff4e24 runtime CFG evidence
    dec word ptr ss:[bp + 024h]
; @025B1 0000:25B1 original=c3 runtime CFG evidence
    ret
; @025B2 0000:25B2 original=b8ffff runtime CFG evidence
    mov ax, 0FFFFh
; @025B5 0000:25B5 original=c3 runtime CFG evidence
    ret
; sub_0000_25B6
; @025B6 0000:25B6 original=8adc
    mov bl, ah
; @025B8 0000:25B8 original=32ff
    xor bh, bh
; @025BA 0000:25BA original=d1e3
    shl bx, 1
; @025BC 0000:25BC original=8b9fe89e
    mov bx, word ptr ds:[bx - 06118h]
; @025C0 0000:25C0 original=32e4
    xor ah, ah
; @025C2 0000:25C2 original=03c3
    add ax, bx
; @025C4 0000:25C4 original=8bf8
    mov di, ax
; @025C6 0000:25C6 original=c3
    ret
; sub_0000_25C7
; @025C7 0000:25C7 original=8adc
    mov bl, ah
; @025C9 0000:25C9 original=32ff
    xor bh, bh
; @025CB 0000:25CB original=d1e3
    shl bx, 1
; @025CD 0000:25CD original=8b9fc89b
    mov bx, word ptr ds:[bx - 06438h]
; @025D1 0000:25D1 original=32e4
    xor ah, ah
; @025D3 0000:25D3 original=03c3
    add ax, bx
; @025D5 0000:25D5 original=8bf8
    mov di, ax
; @025D7 0000:25D7 original=c3
    ret
; sub_0000_25D8
; @025D8 0000:25D8 original=8adc
    mov bl, ah
; @025DA 0000:25DA original=32ff
    xor bh, bh
; @025DC 0000:25DC original=d1e3
    shl bx, 1
; @025DE 0000:25DE original=8b9f589d
    mov bx, word ptr ds:[bx - 062A8h]
; @025E2 0000:25E2 original=32e4
    xor ah, ah
; @025E4 0000:25E4 original=03c3
    add ax, bx
; @025E6 0000:25E6 original=8bf8
    mov di, ax
; @025E8 0000:25E8 original=c3
    ret
; @025E9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,0D1h,0E8h
; @025F9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,0E8h,03h,0C3h,0C3h
; sub_0000_25FE
; @025FE 0000:25FE original=3c10
    cmp al, 010h
; @02600 0000:2600 original=7503
    JNE_SHORT loc_02605
; @02602 0000:2602 original=e92a01
    JMP_NEAR loc_0272F
; @02605 0000:2605 original=3c11
    cmp al, 011h
; @02607 0000:2607 original=7503
    JNE_SHORT loc_0260C
; @02609 0000:2609 original=e90c01
    JMP_NEAR loc_02718
; @0260C 0000:260C original=3c0e
    cmp al, 0Eh
; @0260E 0000:260E original=7503
    JNE_SHORT loc_02613
; @02610 0000:2610 original=e9f900
    JMP_NEAR loc_0270C
; @02613 0000:2613 original=32e4
    xor ah, ah
; @02615 0000:2615 original=d1e0
    shl ax, 1
; @02617 0000:2617 original=d1e0
    shl ax, 1
; @02619 0000:2619 original=d1e0
    shl ax, 1
; @0261B 0000:261B original=051618
    add ax, 01816h
; @0261E 0000:261E original=8bf0
    mov si, ax
; @02620 0000:2620 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @02625 0000:2625 original=33c0
    xor ax, ax
; @02627 0000:2627 original=a05e21
    mov al, byte ptr ds:[0215Eh]
; @0262A 0000:262A original=03066021
    add ax, word ptr ds:[02160h]
; @0262E 0000:262E original=8bf8
    mov di, ax
; @02630 0000:2630 original=bac403
    mov dx, 03C4h
; @02633 0000:2633 original=b002
    mov al, 2
; @02635 0000:2635 original=ee
    out dx, al
; @02636 0000:2636 original=42
    inc dx
; @02637 0000:2637 original=b00f
    mov al, 0Fh
; @02639 0000:2639 original=ee
    out dx, al
; @0263A 0000:263A original=32c0
    xor al, al
; @0263C 0000:263C original=268805
    mov byte ptr es:[di], al
; @0263F 0000:263F original=26884528
    mov byte ptr es:[di + 028h], al
; @02643 0000:2643 original=26884550
    mov byte ptr es:[di + 050h], al
; @02647 0000:2647 original=26884578
    mov byte ptr es:[di + 078h], al
; @0264B 0000:264B original=268885a000
    mov byte ptr es:[di + 0A0h], al
; @02650 0000:2650 original=268885c800
    mov byte ptr es:[di + 0C8h], al
; @02655 0000:2655 original=268885f000
    mov byte ptr es:[di + 0F0h], al
; @0265A 0000:265A original=2688851801
    mov byte ptr es:[di + 0118h], al
; @0265F 0000:265F original=a05c21
    mov al, byte ptr ds:[0215Ch]
; @02662 0000:2662 original=ee
    out dx, al
; @02663 0000:2663 original=c70614190400
    mov word ptr ds:[01914h], 4
; @02669 0000:2669 original=8a1e5c21
    mov bl, byte ptr ds:[0215Ch]
; @0266D 0000:266D original=b701
    mov bh, 1
; @0266F 0000:266F original=b90400
    mov cx, 4
; @02672 0000:2672 original=8ac7
    mov al, bh
; @02674 0000:2674 original=ee
    out dx, al
; @02675 0000:2675 original=d0e7
    shl bh, 1
; @02677 0000:2677 original=52
    push dx
; @02678 0000:2678 original=bace03
    mov dx, 03CEh
; @0267B 0000:267B original=a11419
    mov ax, word ptr ds:[01914h]
; @0267E 0000:267E original=ef
    out dx, ax
; @0267F 0000:267F original=fe061519
    inc byte ptr ds:[01915h]
; @02683 0000:2683 original=5a
    pop dx
; @02684 0000:2684 original=d0eb
    shr bl, 1
; @02686 0000:2686 original=7330
    JAE_SHORT loc_026B8
; @02688 0000:2688 original=ac
    lodsb
; @02689 0000:2689 original=260805
    or byte ptr es:[di], al
; @0268C 0000:268C original=ac
    lodsb
; @0268D 0000:268D original=26084528
    or byte ptr es:[di + 028h], al
; @02691 0000:2691 original=ac
    lodsb
; @02692 0000:2692 original=26084550
    or byte ptr es:[di + 050h], al
; @02696 0000:2696 original=ac
    lodsb
; @02697 0000:2697 original=26084578
    or byte ptr es:[di + 078h], al
; @0269B 0000:269B original=ac
    lodsb
; @0269C 0000:269C original=260885a000
    or byte ptr es:[di + 0A0h], al
; @026A1 0000:26A1 original=ac
    lodsb
; @026A2 0000:26A2 original=260885c800
    or byte ptr es:[di + 0C8h], al
; @026A7 0000:26A7 original=ac
    lodsb
; @026A8 0000:26A8 original=260885f000
    or byte ptr es:[di + 0F0h], al
; @026AD 0000:26AD original=ac
    lodsb
; @026AE 0000:26AE original=2608851801
    or byte ptr es:[di + 0118h], al
; @026B3 0000:26B3 original=83ee08
    sub si, 8
; @026B6 0000:26B6 original=eb3e
    JMP_SHORT loc_026F6
; @026B8 0000:26B8 original=ac
    lodsb
; @026B9 0000:26B9 original=f6d0
    not al
; @026BB 0000:26BB original=262005
    and byte ptr es:[di], al
; @026BE 0000:26BE original=ac
    lodsb
; @026BF 0000:26BF original=f6d0
    not al
; @026C1 0000:26C1 original=26204528
    and byte ptr es:[di + 028h], al
; @026C5 0000:26C5 original=ac
    lodsb
; @026C6 0000:26C6 original=f6d0
    not al
; @026C8 0000:26C8 original=26204550
    and byte ptr es:[di + 050h], al
; @026CC 0000:26CC original=ac
    lodsb
; @026CD 0000:26CD original=f6d0
    not al
; @026CF 0000:26CF original=26204578
    and byte ptr es:[di + 078h], al
; @026D3 0000:26D3 original=ac
    lodsb
; @026D4 0000:26D4 original=f6d0
    not al
; @026D6 0000:26D6 original=262085a000
    and byte ptr es:[di + 0A0h], al
; @026DB 0000:26DB original=ac
    lodsb
; @026DC 0000:26DC original=f6d0
    not al
; @026DE 0000:26DE original=262085c800
    and byte ptr es:[di + 0C8h], al
; @026E3 0000:26E3 original=ac
    lodsb
; @026E4 0000:26E4 original=f6d0
    not al
; @026E6 0000:26E6 original=262085f000
    and byte ptr es:[di + 0F0h], al
; @026EB 0000:26EB original=ac
    lodsb
; @026EC 0000:26EC original=f6d0
    not al
; @026EE 0000:26EE original=2620851801
    and byte ptr es:[di + 0118h], al
; @026F3 0000:26F3 original=83ee08
    sub si, 8
; @026F6 0000:26F6 original=e202
    LOOP_SHORT loc_026FA
; @026F8 0000:26F8 original=eb03
    JMP_SHORT loc_026FD
; @026FA 0000:26FA original=e975ff
    JMP_NEAR loc_02672
; @026FD 0000:26FD original=b00f
    mov al, 0Fh
; @026FF 0000:26FF original=ee
    out dx, al
; @02700 0000:2700 original=80065e2101
    add byte ptr ds:[0215Eh], 1
; @02705 0000:2705 original=803e5e2128
    cmp byte ptr ds:[0215Eh], 028h
; @0270A 0000:270A original=720b
    JB_SHORT loc_02717
; @0270C 0000:270C original=c6065e2100
    mov byte ptr ds:[0215Eh], 0
; @02711 0000:2711 original=810660214001
    add word ptr ds:[02160h], 0140h
; @02717 0000:2717 original=c3
    ret
; @02718 0000:2718 original=8a4601
    mov al, byte ptr ss:[bp + 1]
; @0271B 0000:271B original=b94001
    mov cx, 0140h
; @0271E 0000:271E original=32e4
    xor ah, ah
; @02720 0000:2720 original=f7e1
    mul cx
; @02722 0000:2722 original=a36021
    mov word ptr ds:[02160h], ax
; @02725 0000:2725 original=8a4602
    mov al, byte ptr ss:[bp + 2]
; @02728 0000:2728 original=a25e21
    mov byte ptr ds:[0215Eh], al
; @0272B 0000:272B original=83c502
    add bp, 2
; @0272E 0000:272E original=c3
    ret
; @0272F 0000:272F original=45
    inc bp
; @02730 0000:2730 original=8a4600
    mov al, byte ptr ss:[bp]
; @02733 0000:2733 original=a25c21
    mov byte ptr ds:[0215Ch], al
; @02736 0000:2736 original=c3
    ret
; sub_0000_2737
; @02737 0000:2737 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @0273C 0000:273C original=bac403
    mov dx, 03C4h
; @0273F 0000:273F original=b002
    mov al, 2
; @02741 0000:2741 original=ee
    out dx, al
; @02742 0000:2742 original=42
    inc dx
; @02743 0000:2743 original=b00f
    mov al, 0Fh
; @02745 0000:2745 original=ee
    out dx, al
; @02746 0000:2746 original=33ff
    xor di, di
; @02748 0000:2748 original=8bc7
    mov ax, di
; @0274A 0000:274A original=b9401f
    mov cx, 01F40h
; @0274D 0000:274D original=f3ab
    rep stosw
; @0274F 0000:274F original=c3
    ret
; sub_0000_2750
; @02750 0000:2750 original=8b364c23
    mov si, word ptr ds:[0234Ch]
; @02754 0000:2754 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @02759 0000:2759 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @0275E 0000:275E original=bb0d00
    mov bx, 0Dh
; @02761 0000:2761 original=bfa000
    mov di, 0A0h
; @02764 0000:2764 original=bac403
    mov dx, 03C4h
; @02767 0000:2767 original=b002
    mov al, 2
; @02769 0000:2769 original=ee
    out dx, al
; @0276A 0000:276A original=42
    inc dx
; @0276B 0000:276B original=bdc000
    mov bp, 0C0h
; @0276E 0000:276E original=b001
    mov al, 1
; @02770 0000:2770 original=ee
    out dx, al
; @02771 0000:2771 original=8bcb
    mov cx, bx
; @02773 0000:2773 original=f3a5
    rep movsw
; @02775 0000:2775 original=83ef1a
    sub di, 01Ah
; @02778 0000:2778 original=d0e0
    shl al, 1
; @0277A 0000:277A original=ee
    out dx, al
; @0277B 0000:277B original=8bcb
    mov cx, bx
; @0277D 0000:277D original=f3a5
    rep movsw
; @0277F 0000:277F original=83ef1a
    sub di, 01Ah
; @02782 0000:2782 original=d0e0
    shl al, 1
; @02784 0000:2784 original=ee
    out dx, al
; @02785 0000:2785 original=8bcb
    mov cx, bx
; @02787 0000:2787 original=f3a5
    rep movsw
; @02789 0000:2789 original=83ef1a
    sub di, 01Ah
; @0278C 0000:278C original=d0e0
    shl al, 1
; @0278E 0000:278E original=ee
    out dx, al
; @0278F 0000:278F original=8bcb
    mov cx, bx
; @02791 0000:2791 original=f3a5
    rep movsw
; @02793 0000:2793 original=83c70e
    add di, 0Eh
; @02796 0000:2796 original=4d
    dec bp
; @02797 0000:2797 original=75d5
    JNE_SHORT loc_0276E
; @02799 0000:2799 original=b00f
    mov al, 0Fh
; @0279B 0000:279B original=ee
    out dx, al
; @0279C 0000:279C original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @027A1 0000:27A1 original=c3
    ret
; sub_0000_27A2
; @027A2 0000:27A2 original=e81200
    CALL_NEAR loc_027B7
; @027A5 0000:27A5 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @027AB 0000:27AB original=7509
    JNE_SHORT loc_027B6
; @027AD 0000:27AD original=e86f29
    CALL_NEAR loc_0511F
; @027B0 0000:27B0 original=e80400
    CALL_NEAR loc_027B7
; @027B3 0000:27B3 original=e86929
    CALL_NEAR loc_0511F
; @027B6 0000:27B6 original=c3
    ret
; sub_0000_27B7
; @027B7 0000:27B7 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @027BC 0000:27BC original=bac403
    mov dx, 03C4h
; @027BF 0000:27BF original=b002
    mov al, 2
; @027C1 0000:27C1 original=ee
    out dx, al
; @027C2 0000:27C2 original=42
    inc dx
; @027C3 0000:27C3 original=b00f
    mov al, 0Fh
; @027C5 0000:27C5 original=ee
    out dx, al
; @027C6 0000:27C6 original=33ff
    xor di, di
; @027C8 0000:27C8 original=bdc800
    mov bp, 0C8h
; @027CB 0000:27CB original=b90d00
    mov cx, 0Dh
; @027CE 0000:27CE original=33c0
    xor ax, ax
; @027D0 0000:27D0 original=f3ab
    rep stosw
; @027D2 0000:27D2 original=83c70e
    add di, 0Eh
; @027D5 0000:27D5 original=4d
    dec bp
; @027D6 0000:27D6 original=75f3
    JNE_SHORT loc_027CB
; @027D8 0000:27D8 original=c3
    ret
; sub_0000_27D9
; @027D9 0000:27D9 original=2eff06a85b
    inc word ptr cs:[05BA8h]
; @027DE 0000:27DE original=e8f61c
    CALL_NEAR loc_044D7
; @027E1 0000:27E1 original=7503
    JNE_SHORT loc_027E6
; @027E3 0000:27E3 original=e9c41c
    JMP_NEAR loc_044AA
; @027E6 0000:27E6 original=2e8b0e9e5b
    mov cx, word ptr cs:[05B9Eh]
; @027EB 0000:27EB original=51
    push cx
; @027EC 0000:27EC original=2e833ed60b00
    cmp word ptr cs:[0BD6h], 0
; @027F2 0000:27F2 original=740e
    JE_SHORT loc_02802
; @027F4 0000:27F4 original=56
    push si
; @027F5 0000:27F5 original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @027FA 0000:27FA original=51
    push cx
; @027FB 0000:27FB original=e83401
    CALL_NEAR loc_02932
; @027FE 0000:27FE original=59
    pop cx
; @027FF 0000:27FF original=e2f9
    LOOP_SHORT loc_027FA
; @02801 0000:2801 original=5e
    pop si
; @02802 0000:2802 original=2e893ea65b
    mov word ptr cs:[05BA6h], di
; @02807 0000:2807 original=bff45a
    mov di, 05AF4h
; @0280A 0000:280A original=bd0400
    mov bp, 4
; @0280D 0000:280D original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @02812 0000:2812 original=ac
    lodsb
; @02813 0000:2813 original=2e8805
    mov byte ptr cs:[di], al
; @02816 0000:2816 original=47
    inc di
; @02817 0000:2817 original=e2f9
    LOOP_SHORT loc_02812
; @02819 0000:2819 original=2e2b3e9c5b
    sub di, word ptr cs:[05B9Ch]
; @0281E 0000:281E original=83c728
    add di, 028h
; @02821 0000:2821 original=4d
    dec bp
; @02822 0000:2822 original=75e9
    JNE_SHORT loc_0280D
; @02824 0000:2824 original=bff45a
    mov di, 05AF4h
; @02827 0000:2827 original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @0282C 0000:282C original=51
    push cx
; @0282D 0000:282D original=2e8a05
    mov al, byte ptr cs:[di]
; @02830 0000:2830 original=2e8a6528
    mov ah, byte ptr cs:[di + 028h]
; @02834 0000:2834 original=2e8a5550
    mov dl, byte ptr cs:[di + 050h]
; @02838 0000:2838 original=2e8a7578
    mov dh, byte ptr cs:[di + 078h]
; @0283C 0000:283C original=b90800
    mov cx, 8
; @0283F 0000:283F original=d0c6
    rol dh, 1
; @02841 0000:2841 original=d0d3
    rcl bl, 1
; @02843 0000:2843 original=d0c2
    rol dl, 1
; @02845 0000:2845 original=d0d3
    rcl bl, 1
; @02847 0000:2847 original=d0c4
    rol ah, 1
; @02849 0000:2849 original=d0d3
    rcl bl, 1
; @0284B 0000:284B original=d0c0
    rol al, 1
; @0284D 0000:284D original=d0d3
    rcl bl, 1
; @0284F 0000:284F original=80e30f
    and bl, 0Fh
; @02852 0000:2852 original=2e833ed60b00
    cmp word ptr cs:[0BD6h], 0
; @02858 0000:2858 original=7409
    JE_SHORT loc_02863
; @0285A 0000:285A original=2e3a1e0000
    cmp bl, byte ptr cs:[0]
; @0285F 0000:285F original=7502
    JNE_SHORT loc_02863
; @02861 0000:2861 original=32db
    xor bl, bl
; @02863 0000:2863 original=2e803eb0c501
    cmp byte ptr cs:[0C5B0h], 1
; @02869 0000:2869 original=752f
    JNE_SHORT loc_0289A
; @0286B 0000:286B original=2e8b2eaa5b
    mov bp, word ptr cs:[05BAAh]
; @02870 0000:2870 original=83fdff
    cmp bp, -1
; @02873 0000:2873 original=7425
    JE_SHORT loc_0289A
; @02875 0000:2875 original=2e032ea85b
    add bp, word ptr cs:[05BA8h]
; @0287A 0000:287A original=807e0001
    cmp byte ptr ss:[bp], 1
; @0287E 0000:287E original=740a
    JE_SHORT loc_0288A
; @02880 0000:2880 original=807e0002
    cmp byte ptr ss:[bp], 2
; @02884 0000:2884 original=7402
    JE_SHORT loc_02888
; @02886 0000:2886 original=eb12
    JMP_SHORT loc_0289A
; @02888 0000:2888 original=eb10
    JMP_SHORT loc_0289A
; @0288A 0000:288A original=80fb06
    cmp bl, 6
; @0288D 0000:288D original=7409
    JE_SHORT loc_02898
; @0288F 0000:288F original=80fb0c
    cmp bl, 0Ch
; @02892 0000:2892 original=7506
    JNE_SHORT loc_0289A
; @02894 0000:2894 original=b306
    mov bl, 6
; @02896 0000:2896 original=eb02
    JMP_SHORT loc_0289A
; @02898 0000:2898 original=b30c
    mov bl, 0Ch
; @0289A 0000:289A original=d0eb
    shr bl, 1
; @0289C 0000:289C original=2ed016a25b
    rcl byte ptr cs:[05BA2h],1
; @028A1 0000:28A1 original=d0eb
    shr bl, 1
; @028A3 0000:28A3 original=2ed016a35b
    rcl byte ptr cs:[05BA3h],1
; @028A8 0000:28A8 original=d0eb
    shr bl, 1
; @028AA 0000:28AA original=2ed016a45b
    rcl byte ptr cs:[05BA4h],1
; @028AF 0000:28AF original=d0eb
    shr bl, 1
; @028B1 0000:28B1 original=2ed016a55b
    rcl byte ptr cs:[05BA5h],1
; @028B6 0000:28B6 original=e287
    LOOP_SHORT loc_0283F
; @028B8 0000:28B8 original=2ea0a25b
    mov al, byte ptr cs:[05BA2h]
; @028BC 0000:28BC original=2e8805
    mov byte ptr cs:[di], al
; @028BF 0000:28BF original=2ea0a35b
    mov al, byte ptr cs:[05BA3h]
; @028C3 0000:28C3 original=2e884528
    mov byte ptr cs:[di + 028h], al
; @028C7 0000:28C7 original=2ea0a45b
    mov al, byte ptr cs:[05BA4h]
; @028CB 0000:28CB original=2e884550
    mov byte ptr cs:[di + 050h], al
; @028CF 0000:28CF original=2ea0a55b
    mov al, byte ptr cs:[05BA5h]
; @028D3 0000:28D3 original=2e884578
    mov byte ptr cs:[di + 078h], al
; @028D7 0000:28D7 original=47
    inc di
; @028D8 0000:28D8 original=59
    pop cx
; @028D9 0000:28D9 original=e202
    LOOP_SHORT loc_028DD
; @028DB 0000:28DB original=eb03
    JMP_SHORT loc_028E0
; @028DD 0000:28DD original=e94cff
    JMP_NEAR loc_0282C
; @028E0 0000:28E0 original=bff45a
    mov di, 05AF4h
; @028E3 0000:28E3 original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @028E8 0000:28E8 original=e83100
    CALL_NEAR loc_0291C
; @028EB 0000:28EB original=bf1c5b
    mov di, 05B1Ch
; @028EE 0000:28EE original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @028F3 0000:28F3 original=e82600
    CALL_NEAR loc_0291C
; @028F6 0000:28F6 original=bf445b
    mov di, 05B44h
; @028F9 0000:28F9 original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @028FE 0000:28FE original=e81b00
    CALL_NEAR loc_0291C
; @02901 0000:2901 original=bf6c5b
    mov di, 05B6Ch
; @02904 0000:2904 original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @02909 0000:2909 original=e81000
    CALL_NEAR loc_0291C
; @0290C 0000:290C original=2e8b3ea65b
    mov di, word ptr cs:[05BA6h]
; @02911 0000:2911 original=59
    pop cx
; @02912 0000:2912 original=e202
    LOOP_SHORT loc_02916
; @02914 0000:2914 original=eb03
    JMP_SHORT loc_02919
; @02916 0000:2916 original=e9d2fe
    JMP_NEAR loc_027EB
; @02919 0000:2919 original=e9bdfe
    JMP_NEAR loc_027D9
; sub_0000_291C
; @0291C 0000:291C original=51
    push cx
; @0291D 0000:291D original=2e8a05
    mov al, byte ptr cs:[di]
; @02920 0000:2920 original=47
    inc di
; @02921 0000:2921 original=57
    push di
; @02922 0000:2922 original=2e8b3ea65b
    mov di, word ptr cs:[05BA6h]
; @02927 0000:2927 original=aa
    stosb
; @02928 0000:2928 original=2e893ea65b
    mov word ptr cs:[05BA6h], di
; @0292D 0000:292D original=5f
    pop di
; @0292E 0000:292E original=59
    pop cx
; @0292F 0000:292F original=e2eb
    LOOP_SHORT loc_0291C
; @02931 0000:2931 original=c3
    ret
; sub_0000_2932
; @02932 0000:2932 original=2ec606a05b00
    mov byte ptr cs:[05BA0h], 0
; @02938 0000:2938 original=2e8b1e9c5b
    mov bx, word ptr cs:[05B9Ch]
; @0293D 0000:293D original=8a04
    mov al, byte ptr ds:[si]
; @0293F 0000:293F original=8a20
    mov ah, byte ptr ds:[bx + si]
; @02941 0000:2941 original=d1e3
    shl bx, 1
; @02943 0000:2943 original=8a10
    mov dl, byte ptr ds:[bx + si]
; @02945 0000:2945 original=2e031e9c5b
    add bx, word ptr cs:[05B9Ch]
; @0294A 0000:294A original=8a30
    mov dh, byte ptr ds:[bx + si]
; @0294C 0000:294C original=b90800
    mov cx, 8
; @0294F 0000:294F original=51
    push cx
; @02950 0000:2950 original=d0d6
    rcl dh, 1
; @02952 0000:2952 original=2ed016a15b
    rcl byte ptr cs:[05BA1h],1
; @02957 0000:2957 original=d0d2
    rcl dl, 1
; @02959 0000:2959 original=2ed016a15b
    rcl byte ptr cs:[05BA1h],1
; @0295E 0000:295E original=d0d4
    rcl ah, 1
; @02960 0000:2960 original=2ed016a15b
    rcl byte ptr cs:[05BA1h],1
; @02965 0000:2965 original=d0d0
    rcl al, 1
; @02967 0000:2967 original=2ed016a15b
    rcl byte ptr cs:[05BA1h],1
; @0296C 0000:296C original=2e8026a15b0f
    and byte ptr cs:[05BA1h], 0Fh
; @02972 0000:2972 original=2e8a0e0000
    mov cl, byte ptr cs:[0]
; @02977 0000:2977 original=2e380ea15b
    cmp byte ptr cs:[05BA1h], cl
; @0297C 0000:297C original=7503
    JNE_SHORT loc_02981
; @0297E 0000:297E original=f9
    stc
; @0297F 0000:297F original=eb01
    JMP_SHORT loc_02982
; @02981 0000:2981 original=f8
    clc
; @02982 0000:2982 original=2ed016a05b
    rcl byte ptr cs:[05BA0h],1
; @02987 0000:2987 original=59
    pop cx
; @02988 0000:2988 original=e2c5
    LOOP_SHORT loc_0294F
; @0298A 0000:298A original=2ea0a05b
    mov al, byte ptr cs:[05BA0h]
; @0298E 0000:298E original=aa
    stosb
; @0298F 0000:298F original=46
    inc si
; @02990 0000:2990 original=c3
    ret
; @02991 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FFh,0FFh,074h,03h,0E8h,010h,00h,08Bh,07Eh,010h,08Bh,076h,0Eh,081h,0C6h
; @029A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,01h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,015h,00h,0B9h,010h,00h,0A5h,0A5h
; @029B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,03h,0FBh,0A5h,0A5h,0A4h,03h,0FBh,0A5h,0A5h,0A4h,03h,0FBh,0A5h,0A5h,0A4h
; @029C1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0FBh,0E2h,0EAh,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,017h,00h,0B9h,010h
; @029D1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h,0FBh,0A5h,0A4h,03h
; @029E1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0E2h,0EEh,0C3h,083h,0FFh,0FFh,075h,01h,0C3h,0BBh,018h,00h,0A5h,03h,0FBh
; @029F1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h
; @02A01 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h
; @02A11 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh
; @02A21 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h
; @02A31 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h
; @02A41 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0A5h,03h,0FBh,0C3h,0E8h,0E4h
; @02A51 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Fh,089h,046h,0Ch,03Dh,0FFh,0FFh,074h,0Fh,03h,06h,04Ch,023h,089h,046h,0Ch
; @02A61 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0F0h,08Bh,07Eh,0Eh,0E8h,024h,00h,083h,046h,02h,010h,0E8h,0C6h,02Fh,089h
; @02A71 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,010h,083h,06Eh,02h,010h,03Dh,0FFh,0FFh,075h,01h,0C3h,03h,06h,04Ch,023h
; @02A81 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,010h,08Bh,0F0h,08Bh,07Eh,0Eh,081h,0C7h,040h,01h,02Eh,08Eh,06h,096h
; @02A91 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,02Eh,08Eh,01Eh,098h,095h,0BBh,015h,00h,0B9h,010h,00h,0A4h,0A5h,0A5h,03h
; @02AA1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F3h,0A4h,0A5h,0A5h,03h,0F3h,0A4h,0A5h,0A5h,03h,0F3h,0A4h,0A5h,0A5h,03h,0F3h
; @02AB1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,0EAh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,07Ah,02Fh,089h,046h,0Ch,03Dh,0FFh
; @02AC1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh
; @02AD1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0BBh,017h,00h,0B9h,010h,00h
; @02AE1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h,0A5h,0A4h,03h,0F3h
; @02AF1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,0EEh,02Eh,08Eh,01Eh,096h,095h,0C3h,0E8h,03Ah,02Fh,089h,046h,0Ch,03Dh,0FFh
; @02B01 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,075h,01h,0C3h,03h,06h,04Ch,023h,089h,046h,0Ch,08Bh,0F0h,08Bh,07Eh,0Eh
; @02B11 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,08Eh,06h,096h,095h,02Eh,08Eh,01Eh,098h,095h,0BBh,018h,00h,0A5h,03h,0F3h
; @02B21 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h
; @02B31 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h
; @02B41 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h
; @02B51 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h
; @02B61 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h
; @02B71 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,0A5h,03h,0F3h,02Eh,08Eh,01Eh
; @02B81 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h
; sub_0000_2B84
; @02B84 0000:2B84 original=8bda
    mov bx, dx
; @02B86 0000:2B86 original=b90d00
    mov cx, 0Dh
; @02B89 0000:2B89 original=2ea19a95
    mov ax, word ptr cs:[0959Ah]
; @02B8D 0000:2B8D original=813e50235f0e
    cmp word ptr ds:[02350h], 0E5Fh
; @02B93 0000:2B93 original=7204
    JB_SHORT loc_02B99
; @02B95 0000:2B95 original=2ea19c95
    mov ax, word ptr cs:[0959Ch]
; @02B99 0000:2B99 original=8ed8
    mov ds, ax
; @02B9B 0000:2B9B original=51
    push cx
; @02B9C 0000:2B9C original=53
    push bx
; @02B9D 0000:2B9D original=2e8e069295
    mov es, word ptr cs:[09592h]
; @02BA2 0000:2BA2 original=268a1f
    mov bl, byte ptr es:[bx]
; @02BA5 0000:2BA5 original=fecb
    dec bl
; @02BA7 0000:2BA7 original=32ff
    xor bh, bh
; @02BA9 0000:2BA9 original=d1e3
    shl bx, 1
; @02BAB 0000:2BAB original=81c3928d
    add bx, 08D92h
; @02BAF 0000:2BAF original=2e8b37
    mov si, word ptr cs:[bx]
; @02BB2 0000:2BB2 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @02BB7 0000:2BB7 original=ad
    lodsw
; @02BB8 0000:2BB8 original=268905
    mov word ptr es:[di], ax
; @02BBB 0000:2BBB original=ad
    lodsw
; @02BBC 0000:2BBC original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02BC0 0000:2BC0 original=ad
    lodsw
; @02BC1 0000:2BC1 original=26894534
    mov word ptr es:[di + 034h], ax
; @02BC5 0000:2BC5 original=ad
    lodsw
; @02BC6 0000:2BC6 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02BCA 0000:2BCA original=83c768
    add di, 068h
; @02BCD 0000:2BCD original=ad
    lodsw
; @02BCE 0000:2BCE original=268905
    mov word ptr es:[di], ax
; @02BD1 0000:2BD1 original=ad
    lodsw
; @02BD2 0000:2BD2 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02BD6 0000:2BD6 original=ad
    lodsw
; @02BD7 0000:2BD7 original=26894534
    mov word ptr es:[di + 034h], ax
; @02BDB 0000:2BDB original=ad
    lodsw
; @02BDC 0000:2BDC original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02BE0 0000:2BE0 original=83c768
    add di, 068h
; @02BE3 0000:2BE3 original=ad
    lodsw
; @02BE4 0000:2BE4 original=268905
    mov word ptr es:[di], ax
; @02BE7 0000:2BE7 original=ad
    lodsw
; @02BE8 0000:2BE8 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02BEC 0000:2BEC original=ad
    lodsw
; @02BED 0000:2BED original=26894534
    mov word ptr es:[di + 034h], ax
; @02BF1 0000:2BF1 original=ad
    lodsw
; @02BF2 0000:2BF2 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02BF6 0000:2BF6 original=83c768
    add di, 068h
; @02BF9 0000:2BF9 original=ad
    lodsw
; @02BFA 0000:2BFA original=268905
    mov word ptr es:[di], ax
; @02BFD 0000:2BFD original=ad
    lodsw
; @02BFE 0000:2BFE original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C02 0000:2C02 original=ad
    lodsw
; @02C03 0000:2C03 original=26894534
    mov word ptr es:[di + 034h], ax
; @02C07 0000:2C07 original=ad
    lodsw
; @02C08 0000:2C08 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02C0C 0000:2C0C original=83c768
    add di, 068h
; @02C0F 0000:2C0F original=ad
    lodsw
; @02C10 0000:2C10 original=268905
    mov word ptr es:[di], ax
; @02C13 0000:2C13 original=ad
    lodsw
; @02C14 0000:2C14 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C18 0000:2C18 original=ad
    lodsw
; @02C19 0000:2C19 original=26894534
    mov word ptr es:[di + 034h], ax
; @02C1D 0000:2C1D original=ad
    lodsw
; @02C1E 0000:2C1E original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02C22 0000:2C22 original=83c768
    add di, 068h
; @02C25 0000:2C25 original=ad
    lodsw
; @02C26 0000:2C26 original=268905
    mov word ptr es:[di], ax
; @02C29 0000:2C29 original=ad
    lodsw
; @02C2A 0000:2C2A original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C2E 0000:2C2E original=ad
    lodsw
; @02C2F 0000:2C2F original=26894534
    mov word ptr es:[di + 034h], ax
; @02C33 0000:2C33 original=ad
    lodsw
; @02C34 0000:2C34 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02C38 0000:2C38 original=83c768
    add di, 068h
; @02C3B 0000:2C3B original=ad
    lodsw
; @02C3C 0000:2C3C original=268905
    mov word ptr es:[di], ax
; @02C3F 0000:2C3F original=ad
    lodsw
; @02C40 0000:2C40 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C44 0000:2C44 original=ad
    lodsw
; @02C45 0000:2C45 original=26894534
    mov word ptr es:[di + 034h], ax
; @02C49 0000:2C49 original=ad
    lodsw
; @02C4A 0000:2C4A original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02C4E 0000:2C4E original=83c768
    add di, 068h
; @02C51 0000:2C51 original=ad
    lodsw
; @02C52 0000:2C52 original=268905
    mov word ptr es:[di], ax
; @02C55 0000:2C55 original=ad
    lodsw
; @02C56 0000:2C56 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C5A 0000:2C5A original=ad
    lodsw
; @02C5B 0000:2C5B original=26894534
    mov word ptr es:[di + 034h], ax
; @02C5F 0000:2C5F original=ad
    lodsw
; @02C60 0000:2C60 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02C64 0000:2C64 original=83c768
    add di, 068h
; @02C67 0000:2C67 original=ad
    lodsw
; @02C68 0000:2C68 original=268905
    mov word ptr es:[di], ax
; @02C6B 0000:2C6B original=ad
    lodsw
; @02C6C 0000:2C6C original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C70 0000:2C70 original=ad
    lodsw
; @02C71 0000:2C71 original=26894534
    mov word ptr es:[di + 034h], ax
; @02C75 0000:2C75 original=ad
    lodsw
; @02C76 0000:2C76 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02C7A 0000:2C7A original=83c768
    add di, 068h
; @02C7D 0000:2C7D original=ad
    lodsw
; @02C7E 0000:2C7E original=268905
    mov word ptr es:[di], ax
; @02C81 0000:2C81 original=ad
    lodsw
; @02C82 0000:2C82 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C86 0000:2C86 original=ad
    lodsw
; @02C87 0000:2C87 original=26894534
    mov word ptr es:[di + 034h], ax
; @02C8B 0000:2C8B original=ad
    lodsw
; @02C8C 0000:2C8C original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02C90 0000:2C90 original=83c768
    add di, 068h
; @02C93 0000:2C93 original=ad
    lodsw
; @02C94 0000:2C94 original=268905
    mov word ptr es:[di], ax
; @02C97 0000:2C97 original=ad
    lodsw
; @02C98 0000:2C98 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02C9C 0000:2C9C original=ad
    lodsw
; @02C9D 0000:2C9D original=26894534
    mov word ptr es:[di + 034h], ax
; @02CA1 0000:2CA1 original=ad
    lodsw
; @02CA2 0000:2CA2 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02CA6 0000:2CA6 original=83c768
    add di, 068h
; @02CA9 0000:2CA9 original=ad
    lodsw
; @02CAA 0000:2CAA original=268905
    mov word ptr es:[di], ax
; @02CAD 0000:2CAD original=ad
    lodsw
; @02CAE 0000:2CAE original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02CB2 0000:2CB2 original=ad
    lodsw
; @02CB3 0000:2CB3 original=26894534
    mov word ptr es:[di + 034h], ax
; @02CB7 0000:2CB7 original=ad
    lodsw
; @02CB8 0000:2CB8 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02CBC 0000:2CBC original=83c768
    add di, 068h
; @02CBF 0000:2CBF original=ad
    lodsw
; @02CC0 0000:2CC0 original=268905
    mov word ptr es:[di], ax
; @02CC3 0000:2CC3 original=ad
    lodsw
; @02CC4 0000:2CC4 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02CC8 0000:2CC8 original=ad
    lodsw
; @02CC9 0000:2CC9 original=26894534
    mov word ptr es:[di + 034h], ax
; @02CCD 0000:2CCD original=ad
    lodsw
; @02CCE 0000:2CCE original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02CD2 0000:2CD2 original=83c768
    add di, 068h
; @02CD5 0000:2CD5 original=ad
    lodsw
; @02CD6 0000:2CD6 original=268905
    mov word ptr es:[di], ax
; @02CD9 0000:2CD9 original=ad
    lodsw
; @02CDA 0000:2CDA original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02CDE 0000:2CDE original=ad
    lodsw
; @02CDF 0000:2CDF original=26894534
    mov word ptr es:[di + 034h], ax
; @02CE3 0000:2CE3 original=ad
    lodsw
; @02CE4 0000:2CE4 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02CE8 0000:2CE8 original=83c768
    add di, 068h
; @02CEB 0000:2CEB original=ad
    lodsw
; @02CEC 0000:2CEC original=268905
    mov word ptr es:[di], ax
; @02CEF 0000:2CEF original=ad
    lodsw
; @02CF0 0000:2CF0 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02CF4 0000:2CF4 original=ad
    lodsw
; @02CF5 0000:2CF5 original=26894534
    mov word ptr es:[di + 034h], ax
; @02CF9 0000:2CF9 original=ad
    lodsw
; @02CFA 0000:2CFA original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02CFE 0000:2CFE original=83c768
    add di, 068h
; @02D01 0000:2D01 original=ad
    lodsw
; @02D02 0000:2D02 original=268905
    mov word ptr es:[di], ax
; @02D05 0000:2D05 original=ad
    lodsw
; @02D06 0000:2D06 original=2689451a
    mov word ptr es:[di + 01Ah], ax
; @02D0A 0000:2D0A original=ad
    lodsw
; @02D0B 0000:2D0B original=26894534
    mov word ptr es:[di + 034h], ax
; @02D0F 0000:2D0F original=ad
    lodsw
; @02D10 0000:2D10 original=2689454e
    mov word ptr es:[di + 04Eh], ax
; @02D14 0000:2D14 original=83c768
    add di, 068h
; @02D17 0000:2D17 original=81ef7e06
    sub di, 067Eh
; @02D1B 0000:2D1B original=5b
    pop bx
; @02D1C 0000:2D1C original=83c301
    add bx, 1
; @02D1F 0000:2D1F original=59
    pop cx
; @02D20 0000:2D20 original=e202
    LOOP_SHORT loc_02D24
; @02D22 0000:2D22 original=eb03
    JMP_SHORT loc_02D27
; @02D24 0000:2D24 original=e974fe
    JMP_NEAR loc_02B9B
; @02D27 0000:2D27 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @02D2C 0000:2D2C original=c3
    ret
; sub_0000_2D2D
; @02D2D 0000:2D2D original=2ec70603590000
    mov word ptr cs:[05903h], 0
; @02D34 0000:2D34 original=2e8b3ef958
    mov di, word ptr cs:[058F9h]
; @02D39 0000:2D39 original=2e8b36fb58
    mov si, word ptr cs:[058FBh]
; @02D3E 0000:2D3E original=2e8b0efd58
    mov cx, word ptr cs:[058FDh]
; @02D43 0000:2D43 original=2e8b2eff58
    mov bp, word ptr cs:[058FFh]
; @02D48 0000:2D48 original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @02D4E 0000:2D4E original=740c
    JE_SHORT loc_02D5C
; @02D50 0000:2D50 original=8bc5
    mov ax, bp
; @02D52 0000:2D52 original=d1e0
    shl ax, 1
; @02D54 0000:2D54 original=d1e0
    shl ax, 1
; @02D56 0000:2D56 original=49
    dec cx
; @02D57 0000:2D57 original=f7e1
    mul cx
; @02D59 0000:2D59 original=41
    inc cx
; @02D5A 0000:2D5A original=03f0
    add si, ax
; @02D5C 0000:2D5C original=bac403
    mov dx, 03C4h
; @02D5F 0000:2D5F original=b002
    mov al, 2
; @02D61 0000:2D61 original=ee
    out dx, al
; @02D62 0000:2D62 original=42
    inc dx
; @02D63 0000:2D63 original=51
    push cx
; @02D64 0000:2D64 original=2e8b0efd58
    mov cx, word ptr cs:[058FDh]
; @02D69 0000:2D69 original=2e2b0e0159
    sub cx, word ptr cs:[05901h]
; @02D6E 0000:2D6E original=0bc9
    or cx, cx
; @02D70 0000:2D70 original=781a
    JS_SHORT loc_02D8C
; @02D72 0000:2D72 original=d1e9
    shr cx, 1
; @02D74 0000:2D74 original=e316
    JCXZ_SHORT loc_02D8C
; @02D76 0000:2D76 original=49
    dec cx
; @02D77 0000:2D77 original=e308
    JCXZ_SHORT loc_02D81
; @02D79 0000:2D79 original=b00f
    mov al, 0Fh
; @02D7B 0000:2D7B original=ee
    out dx, al
; @02D7C 0000:2D7C original=83c728
    add di, 028h
; @02D7F 0000:2D7F original=e2fb
    LOOP_SHORT loc_02D7C
; @02D81 0000:2D81 original=32c0
    xor al, al
; @02D83 0000:2D83 original=8bcd
    mov cx, bp
; @02D85 0000:2D85 original=f3aa
    rep stosb
; @02D87 0000:2D87 original=2bfd
    sub di, bp
; @02D89 0000:2D89 original=83c728
    add di, 028h
; @02D8C 0000:2D8C original=59
    pop cx
; @02D8D 0000:2D8D original=2ea10159
    mov ax, word ptr cs:[05901h]
; @02D91 0000:2D91 original=2e3b06fd58
    cmp ax, word ptr cs:[058FDh]
; @02D96 0000:2D96 original=7433
    JE_SHORT loc_02DCB
; @02D98 0000:2D98 original=2e01060359
    add word ptr cs:[05903h], ax
; @02D9D 0000:2D9D original=2ea1fd58
    mov ax, word ptr cs:[058FDh]
; @02DA1 0000:2DA1 original=2e3b060359
    cmp ax, word ptr cs:[05903h]
; @02DA6 0000:2DA6 original=771e
    JA_SHORT loc_02DC6
; @02DA8 0000:2DA8 original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @02DAE 0000:2DAE original=740a
    JE_SHORT loc_02DBA
; @02DB0 0000:2DB0 original=2bf5
    sub si, bp
; @02DB2 0000:2DB2 original=2bf5
    sub si, bp
; @02DB4 0000:2DB4 original=2bf5
    sub si, bp
; @02DB6 0000:2DB6 original=2bf5
    sub si, bp
; @02DB8 0000:2DB8 original=eb08
    JMP_SHORT loc_02DC2
; @02DBA 0000:2DBA original=03f5
    add si, bp
; @02DBC 0000:2DBC original=03f5
    add si, bp
; @02DBE 0000:2DBE original=03f5
    add si, bp
; @02DC0 0000:2DC0 original=03f5
    add si, bp
; @02DC2 0000:2DC2 original=e2c9
    LOOP_SHORT loc_02D8D
; @02DC4 0000:2DC4 original=eb5d
    JMP_SHORT loc_02E23
; @02DC6 0000:2DC6 original=2e29060359
    sub word ptr cs:[05903h], ax
; @02DCB 0000:2DCB original=51
    push cx
; @02DCC 0000:2DCC original=b001
    mov al, 1
; @02DCE 0000:2DCE original=ee
    out dx, al
; @02DCF 0000:2DCF original=8bcd
    mov cx, bp
; @02DD1 0000:2DD1 original=f3a4
    rep movsb
; @02DD3 0000:2DD3 original=2bfd
    sub di, bp
; @02DD5 0000:2DD5 original=d0e0
    shl al, 1
; @02DD7 0000:2DD7 original=ee
    out dx, al
; @02DD8 0000:2DD8 original=8bcd
    mov cx, bp
; @02DDA 0000:2DDA original=f3a4
    rep movsb
; @02DDC 0000:2DDC original=2bfd
    sub di, bp
; @02DDE 0000:2DDE original=d0e0
    shl al, 1
; @02DE0 0000:2DE0 original=ee
    out dx, al
; @02DE1 0000:2DE1 original=8bcd
    mov cx, bp
; @02DE3 0000:2DE3 original=f3a4
    rep movsb
; @02DE5 0000:2DE5 original=2bfd
    sub di, bp
; @02DE7 0000:2DE7 original=d0e0
    shl al, 1
; @02DE9 0000:2DE9 original=ee
    out dx, al
; @02DEA 0000:2DEA original=8bcd
    mov cx, bp
; @02DEC 0000:2DEC original=2e833e075901
    cmp word ptr cs:[05907h], 1
; @02DF2 0000:2DF2 original=7404
    JE_SHORT loc_02DF8
; @02DF4 0000:2DF4 original=f3a4
    rep movsb
; @02DF6 0000:2DF6 original=eb06
    JMP_SHORT loc_02DFE
; @02DF8 0000:2DF8 original=32c0
    xor al, al
; @02DFA 0000:2DFA original=f3aa
    rep stosb
; @02DFC 0000:2DFC original=03f5
    add si, bp
; @02DFE 0000:2DFE original=2bfd
    sub di, bp
; @02E00 0000:2E00 original=83c728
    add di, 028h
; @02E03 0000:2E03 original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @02E09 0000:2E09 original=7410
    JE_SHORT loc_02E1B
; @02E0B 0000:2E0B original=2bf5
    sub si, bp
; @02E0D 0000:2E0D original=2bf5
    sub si, bp
; @02E0F 0000:2E0F original=2bf5
    sub si, bp
; @02E11 0000:2E11 original=2bf5
    sub si, bp
; @02E13 0000:2E13 original=2bf5
    sub si, bp
; @02E15 0000:2E15 original=2bf5
    sub si, bp
; @02E17 0000:2E17 original=2bf5
    sub si, bp
; @02E19 0000:2E19 original=2bf5
    sub si, bp
; @02E1B 0000:2E1B original=59
    pop cx
; @02E1C 0000:2E1C original=e202
    LOOP_SHORT loc_02E20
; @02E1E 0000:2E1E original=eb03
    JMP_SHORT loc_02E23
; @02E20 0000:2E20 original=e96aff
    JMP_NEAR loc_02D8D
; @02E23 0000:2E23 original=b00f
    mov al, 0Fh
; @02E25 0000:2E25 original=ee
    out dx, al
; @02E26 0000:2E26 original=32c0
    xor al, al
; @02E28 0000:2E28 original=8bcd
    mov cx, bp
; @02E2A 0000:2E2A original=f3aa
    rep stosb
; @02E2C 0000:2E2C original=c3
    ret
; sub_0000_2E2D
; @02E2D 0000:2E2D original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @02E32 0000:2E32 original=bac403
    mov dx, 03C4h
; @02E35 0000:2E35 original=b002
    mov al, 2
; @02E37 0000:2E37 original=ee
    out dx, al
; @02E38 0000:2E38 original=42
    inc dx
; @02E39 0000:2E39 original=b001
    mov al, 1
; @02E3B 0000:2E3B original=ee
    out dx, al
; @02E3C 0000:2E3C original=b91400
    mov cx, 014h
; @02E3F 0000:2E3F original=f3a5
    rep movsw
; @02E41 0000:2E41 original=83ef28
    sub di, 028h
; @02E44 0000:2E44 original=b002
    mov al, 2
; @02E46 0000:2E46 original=ee
    out dx, al
; @02E47 0000:2E47 original=b91400
    mov cx, 014h
; @02E4A 0000:2E4A original=f3a5
    rep movsw
; @02E4C 0000:2E4C original=83ef28
    sub di, 028h
; @02E4F 0000:2E4F original=b004
    mov al, 4
; @02E51 0000:2E51 original=ee
    out dx, al
; @02E52 0000:2E52 original=b91400
    mov cx, 014h
; @02E55 0000:2E55 original=f3a5
    rep movsw
; @02E57 0000:2E57 original=83ef28
    sub di, 028h
; @02E5A 0000:2E5A original=b008
    mov al, 8
; @02E5C 0000:2E5C original=ee
    out dx, al
; @02E5D 0000:2E5D original=b91400
    mov cx, 014h
; @02E60 0000:2E60 original=f3a5
    rep movsw
; @02E62 0000:2E62 original=4d
    dec bp
; @02E63 0000:2E63 original=75d4
    JNE_SHORT loc_02E39
; @02E65 0000:2E65 original=b00f
    mov al, 0Fh
; @02E67 0000:2E67 original=ee
    out dx, al
; @02E68 0000:2E68 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @02E6D 0000:2E6D original=c3
    ret
; @02E6E 0000:2E6E original=bb5800 runtime CFG evidence
    mov bx, 058h
; @02E71 0000:2E71 original=ad runtime CFG evidence
    lodsw
; @02E72 0000:2E72 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02E75 0000:2E75 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02E77 0000:2E77 original=83c602 runtime CFG evidence
    add si, 2
; @02E7A 0000:2E7A original=ab runtime CFG evidence
    stosw
; @02E7B 0000:2E7B original=ad runtime CFG evidence
    lodsw
; @02E7C 0000:2E7C original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02E7F 0000:2E7F original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02E81 0000:2E81 original=83c602 runtime CFG evidence
    add si, 2
; @02E84 0000:2E84 original=ab runtime CFG evidence
    stosw
; @02E85 0000:2E85 original=ad runtime CFG evidence
    lodsw
; @02E86 0000:2E86 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02E89 0000:2E89 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02E8B 0000:2E8B original=83c602 runtime CFG evidence
    add si, 2
; @02E8E 0000:2E8E original=ab runtime CFG evidence
    stosw
; @02E8F 0000:2E8F original=ad runtime CFG evidence
    lodsw
; @02E90 0000:2E90 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02E93 0000:2E93 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02E95 0000:2E95 original=83c602 runtime CFG evidence
    add si, 2
; @02E98 0000:2E98 original=ab runtime CFG evidence
    stosw
; @02E99 0000:2E99 original=ad runtime CFG evidence
    lodsw
; @02E9A 0000:2E9A original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02E9D 0000:2E9D original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02E9F 0000:2E9F original=83c602 runtime CFG evidence
    add si, 2
; @02EA2 0000:2EA2 original=ab runtime CFG evidence
    stosw
; @02EA3 0000:2EA3 original=ad runtime CFG evidence
    lodsw
; @02EA4 0000:2EA4 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02EA7 0000:2EA7 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02EA9 0000:2EA9 original=83c602 runtime CFG evidence
    add si, 2
; @02EAC 0000:2EAC original=ab runtime CFG evidence
    stosw
; @02EAD 0000:2EAD original=ad runtime CFG evidence
    lodsw
; @02EAE 0000:2EAE original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02EB1 0000:2EB1 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02EB3 0000:2EB3 original=83c602 runtime CFG evidence
    add si, 2
; @02EB6 0000:2EB6 original=ab runtime CFG evidence
    stosw
; @02EB7 0000:2EB7 original=ad runtime CFG evidence
    lodsw
; @02EB8 0000:2EB8 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02EBB 0000:2EBB original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02EBD 0000:2EBD original=83c602 runtime CFG evidence
    add si, 2
; @02EC0 0000:2EC0 original=ab runtime CFG evidence
    stosw
; @02EC1 0000:2EC1 original=03fb runtime CFG evidence
    add di, bx
; @02EC3 0000:2EC3 original=e2a9 runtime CFG evidence
    LOOP_SHORT loc_02E6E
; @02EC5 0000:2EC5 original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @02ECA 0000:2ECA original=c3 runtime CFG evidence
    ret
; @02ECB 0000:2ECB original=bb5800 runtime CFG evidence
    mov bx, 058h
; @02ECE 0000:2ECE original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02ED0 0000:2ED0 original=f7d0 runtime CFG evidence
    not ax
; @02ED2 0000:2ED2 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02ED5 0000:2ED5 original=83c604 runtime CFG evidence
    add si, 4
; @02ED8 0000:2ED8 original=83c702 runtime CFG evidence
    add di, 2
; @02EDB 0000:2EDB original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02EDD 0000:2EDD original=f7d0 runtime CFG evidence
    not ax
; @02EDF 0000:2EDF original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02EE2 0000:2EE2 original=83c604 runtime CFG evidence
    add si, 4
; @02EE5 0000:2EE5 original=83c702 runtime CFG evidence
    add di, 2
; @02EE8 0000:2EE8 original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02EEA 0000:2EEA original=f7d0 runtime CFG evidence
    not ax
; @02EEC 0000:2EEC original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02EEF 0000:2EEF original=83c604 runtime CFG evidence
    add si, 4
; @02EF2 0000:2EF2 original=83c702 runtime CFG evidence
    add di, 2
; @02EF5 0000:2EF5 original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02EF7 0000:2EF7 original=f7d0 runtime CFG evidence
    not ax
; @02EF9 0000:2EF9 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02EFC 0000:2EFC original=83c604 runtime CFG evidence
    add si, 4
; @02EFF 0000:2EFF original=83c702 runtime CFG evidence
    add di, 2
; @02F02 0000:2F02 original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F04 0000:2F04 original=f7d0 runtime CFG evidence
    not ax
; @02F06 0000:2F06 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F09 0000:2F09 original=83c604 runtime CFG evidence
    add si, 4
; @02F0C 0000:2F0C original=83c702 runtime CFG evidence
    add di, 2
; @02F0F 0000:2F0F original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F11 0000:2F11 original=f7d0 runtime CFG evidence
    not ax
; @02F13 0000:2F13 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F16 0000:2F16 original=83c604 runtime CFG evidence
    add si, 4
; @02F19 0000:2F19 original=83c702 runtime CFG evidence
    add di, 2
; @02F1C 0000:2F1C original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F1E 0000:2F1E original=f7d0 runtime CFG evidence
    not ax
; @02F20 0000:2F20 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F23 0000:2F23 original=83c604 runtime CFG evidence
    add si, 4
; @02F26 0000:2F26 original=83c702 runtime CFG evidence
    add di, 2
; @02F29 0000:2F29 original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F2B 0000:2F2B original=f7d0 runtime CFG evidence
    not ax
; @02F2D 0000:2F2D original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F30 0000:2F30 original=83c604 runtime CFG evidence
    add si, 4
; @02F33 0000:2F33 original=83c702 runtime CFG evidence
    add di, 2
; @02F36 0000:2F36 original=03fb runtime CFG evidence
    add di, bx
; @02F38 0000:2F38 original=e291 runtime CFG evidence
    LOOP_SHORT loc_02ECB
; @02F3A 0000:2F3A original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @02F3F 0000:2F3F original=c3 runtime CFG evidence
    ret
; @02F40 0000:2F40 original=bb6000 runtime CFG evidence
    mov bx, 060h
; @02F43 0000:2F43 original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F45 0000:2F45 original=f7d0 runtime CFG evidence
    not ax
; @02F47 0000:2F47 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F4A 0000:2F4A original=83c604 runtime CFG evidence
    add si, 4
; @02F4D 0000:2F4D original=83c702 runtime CFG evidence
    add di, 2
; @02F50 0000:2F50 original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F52 0000:2F52 original=f7d0 runtime CFG evidence
    not ax
; @02F54 0000:2F54 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F57 0000:2F57 original=83c604 runtime CFG evidence
    add si, 4
; @02F5A 0000:2F5A original=83c702 runtime CFG evidence
    add di, 2
; @02F5D 0000:2F5D original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F5F 0000:2F5F original=f7d0 runtime CFG evidence
    not ax
; @02F61 0000:2F61 original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F64 0000:2F64 original=83c604 runtime CFG evidence
    add si, 4
; @02F67 0000:2F67 original=83c702 runtime CFG evidence
    add di, 2
; @02F6A 0000:2F6A original=8b04 runtime CFG evidence
    mov ax, word ptr ds:[si]
; @02F6C 0000:2F6C original=f7d0 runtime CFG evidence
    not ax
; @02F6E 0000:2F6E original=260905 runtime CFG evidence
    or word ptr es:[di], ax
; @02F71 0000:2F71 original=83c604 runtime CFG evidence
    add si, 4
; @02F74 0000:2F74 original=83c702 runtime CFG evidence
    add di, 2
; @02F77 0000:2F77 original=03fb runtime CFG evidence
    add di, bx
; @02F79 0000:2F79 original=e2c5 runtime CFG evidence
    LOOP_SHORT loc_02F40
; @02F7B 0000:2F7B original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @02F80 0000:2F80 original=c3 runtime CFG evidence
    ret
; @02F81 0000:2F81 original=bb6000 runtime CFG evidence
    mov bx, 060h
; @02F84 0000:2F84 original=ad runtime CFG evidence
    lodsw
; @02F85 0000:2F85 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02F88 0000:2F88 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02F8A 0000:2F8A original=83c602 runtime CFG evidence
    add si, 2
; @02F8D 0000:2F8D original=ab runtime CFG evidence
    stosw
; @02F8E 0000:2F8E original=ad runtime CFG evidence
    lodsw
; @02F8F 0000:2F8F original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02F92 0000:2F92 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02F94 0000:2F94 original=83c602 runtime CFG evidence
    add si, 2
; @02F97 0000:2F97 original=ab runtime CFG evidence
    stosw
; @02F98 0000:2F98 original=ad runtime CFG evidence
    lodsw
; @02F99 0000:2F99 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02F9C 0000:2F9C original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02F9E 0000:2F9E original=83c602 runtime CFG evidence
    add si, 2
; @02FA1 0000:2FA1 original=ab runtime CFG evidence
    stosw
; @02FA2 0000:2FA2 original=ad runtime CFG evidence
    lodsw
; @02FA3 0000:2FA3 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FA6 0000:2FA6 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02FA8 0000:2FA8 original=83c602 runtime CFG evidence
    add si, 2
; @02FAB 0000:2FAB original=ab runtime CFG evidence
    stosw
; @02FAC 0000:2FAC original=03fb runtime CFG evidence
    add di, bx
; @02FAE 0000:2FAE original=e2d1 runtime CFG evidence
    LOOP_SHORT loc_02F81
; @02FB0 0000:2FB0 original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @02FB5 0000:2FB5 original=c3 runtime CFG evidence
    ret
; @02FB6 0000:2FB6 original=bb6400 runtime CFG evidence
    mov bx, 064h
; @02FB9 0000:2FB9 original=ad runtime CFG evidence
    lodsw
; @02FBA 0000:2FBA original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FBD 0000:2FBD original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02FBF 0000:2FBF original=83c602 runtime CFG evidence
    add si, 2
; @02FC2 0000:2FC2 original=ab runtime CFG evidence
    stosw
; @02FC3 0000:2FC3 original=ad runtime CFG evidence
    lodsw
; @02FC4 0000:2FC4 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FC7 0000:2FC7 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02FC9 0000:2FC9 original=83c602 runtime CFG evidence
    add si, 2
; @02FCC 0000:2FCC original=ab runtime CFG evidence
    stosw
; @02FCD 0000:2FCD original=03fb runtime CFG evidence
    add di, bx
; @02FCF 0000:2FCF original=ad runtime CFG evidence
    lodsw
; @02FD0 0000:2FD0 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FD3 0000:2FD3 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02FD5 0000:2FD5 original=83c602 runtime CFG evidence
    add si, 2
; @02FD8 0000:2FD8 original=ab runtime CFG evidence
    stosw
; @02FD9 0000:2FD9 original=ad runtime CFG evidence
    lodsw
; @02FDA 0000:2FDA original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FDD 0000:2FDD original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02FDF 0000:2FDF original=83c602 runtime CFG evidence
    add si, 2
; @02FE2 0000:2FE2 original=ab runtime CFG evidence
    stosw
; @02FE3 0000:2FE3 original=03fb runtime CFG evidence
    add di, bx
; @02FE5 0000:2FE5 original=ad runtime CFG evidence
    lodsw
; @02FE6 0000:2FE6 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FE9 0000:2FE9 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02FEB 0000:2FEB original=83c602 runtime CFG evidence
    add si, 2
; @02FEE 0000:2FEE original=ab runtime CFG evidence
    stosw
; @02FEF 0000:2FEF original=ad runtime CFG evidence
    lodsw
; @02FF0 0000:2FF0 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FF3 0000:2FF3 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @02FF5 0000:2FF5 original=83c602 runtime CFG evidence
    add si, 2
; @02FF8 0000:2FF8 original=ab runtime CFG evidence
    stosw
; @02FF9 0000:2FF9 original=03fb runtime CFG evidence
    add di, bx
; @02FFB 0000:2FFB original=ad runtime CFG evidence
    lodsw
; @02FFC 0000:2FFC original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @02FFF 0000:2FFF original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @03001 0000:3001 original=83c602 runtime CFG evidence
    add si, 2
; @03004 0000:3004 original=ab runtime CFG evidence
    stosw
; @03005 0000:3005 original=ad runtime CFG evidence
    lodsw
; @03006 0000:3006 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @03009 0000:3009 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @0300B 0000:300B original=83c602 runtime CFG evidence
    add si, 2
; @0300E 0000:300E original=ab runtime CFG evidence
    stosw
; @0300F 0000:300F original=03fb runtime CFG evidence
    add di, bx
; @03011 0000:3011 original=ad runtime CFG evidence
    lodsw
; @03012 0000:3012 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @03015 0000:3015 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @03017 0000:3017 original=83c602 runtime CFG evidence
    add si, 2
; @0301A 0000:301A original=ab runtime CFG evidence
    stosw
; @0301B 0000:301B original=ad runtime CFG evidence
    lodsw
; @0301C 0000:301C original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @0301F 0000:301F original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @03021 0000:3021 original=83c602 runtime CFG evidence
    add si, 2
; @03024 0000:3024 original=ab runtime CFG evidence
    stosw
; @03025 0000:3025 original=03fb runtime CFG evidence
    add di, bx
; @03027 0000:3027 original=ad runtime CFG evidence
    lodsw
; @03028 0000:3028 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @0302B 0000:302B original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @0302D 0000:302D original=83c602 runtime CFG evidence
    add si, 2
; @03030 0000:3030 original=ab runtime CFG evidence
    stosw
; @03031 0000:3031 original=ad runtime CFG evidence
    lodsw
; @03032 0000:3032 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @03035 0000:3035 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @03037 0000:3037 original=83c602 runtime CFG evidence
    add si, 2
; @0303A 0000:303A original=ab runtime CFG evidence
    stosw
; @0303B 0000:303B original=03fb runtime CFG evidence
    add di, bx
; @0303D 0000:303D original=ad runtime CFG evidence
    lodsw
; @0303E 0000:303E original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @03041 0000:3041 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @03043 0000:3043 original=83c602 runtime CFG evidence
    add si, 2
; @03046 0000:3046 original=ab runtime CFG evidence
    stosw
; @03047 0000:3047 original=ad runtime CFG evidence
    lodsw
; @03048 0000:3048 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @0304B 0000:304B original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @0304D 0000:304D original=83c602 runtime CFG evidence
    add si, 2
; @03050 0000:3050 original=ab runtime CFG evidence
    stosw
; @03051 0000:3051 original=03fb runtime CFG evidence
    add di, bx
; @03053 0000:3053 original=ad runtime CFG evidence
    lodsw
; @03054 0000:3054 original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @03057 0000:3057 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @03059 0000:3059 original=83c602 runtime CFG evidence
    add si, 2
; @0305C 0000:305C original=ab runtime CFG evidence
    stosw
; @0305D 0000:305D original=ad runtime CFG evidence
    lodsw
; @0305E 0000:305E original=262305 runtime CFG evidence
    and ax, word ptr es:[di]
; @03061 0000:3061 original=0b04 runtime CFG evidence
    or ax, word ptr ds:[si]
; @03063 0000:3063 original=83c602 runtime CFG evidence
    add si, 2
; @03066 0000:3066 original=ab runtime CFG evidence
    stosw
; @03067 0000:3067 original=03fb runtime CFG evidence
    add di, bx
; @03069 0000:3069 original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @0306E 0000:306E original=c3 runtime CFG evidence
    ret
; sub_0000_306F
; CopyPackedRowsToTandyBanks (modern reconstruction name)
; Read row count then width-units from DS:SI (two words); copy width*4 bytes per row to ES loaded from CS:95A4.
; DF must be clear, row count positive, ranges valid/nonoverlapping. Bank step is +2000h; if bit15 set add80A0h
; modulo65536. AX/BP=width*4, CX=0; SI advances4+rows*width*4; DI advances to next row start; ES and flags
; changed, BX/DX/DS unchanged.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @0306F 0000:306F original=ad
    lodsw
; @03070 0000:3070 original=8bc8
    mov cx, ax
; @03072 0000:3072 original=ad
    lodsw
; @03073 0000:3073 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @03078 0000:3078 original=d1e0
    shl ax, 1
; @0307A 0000:307A original=d1e0
    shl ax, 1
; @0307C 0000:307C original=8be8
    mov bp, ax
; @0307E 0000:307E original=51
    push cx
; @0307F 0000:307F original=8bcd
    mov cx, bp
; @03081 0000:3081 original=f3a4
    rep movsb
; @03083 0000:3083 original=2bfd
    sub di, bp
; @03085 0000:3085 original=81c70020
    add di, 02000h
; @03089 0000:3089 original=f7c70080
    test di, 08000h
; @0308D 0000:308D original=7404
    JE_SHORT loc_03093
; @0308F 0000:308F original=81c7a080
    add di, 080A0h
; @03093 0000:3093 original=59
    pop cx
; @03094 0000:3094 original=e2e8
    LOOP_SHORT loc_0307E
; @03096 0000:3096 original=c3
    ret
; sub_0000_3097
; CopyPackedRowsStride104 (modern reconstruction name)
; Read DS:SI row count and width-units, then copy width*4 bytes per row to ES=CS:9598 with104-byte row stride.
; DF=0, positive rows, valid nonoverlapping ranges required. AX/BP=width*4,CX=0; SI advanced4+payload; DI
; advanced104*rows; BX/DX/DS unchanged, ES/flags changed.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @03097 0000:3097 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @0309C 0000:309C original=ad
    lodsw
; @0309D 0000:309D original=8bc8
    mov cx, ax
; @0309F 0000:309F original=ad
    lodsw
; @030A0 0000:30A0 original=d1e0
    shl ax, 1
; @030A2 0000:30A2 original=d1e0
    shl ax, 1
; @030A4 0000:30A4 original=8be8
    mov bp, ax
; @030A6 0000:30A6 original=51
    push cx
; @030A7 0000:30A7 original=8bcd
    mov cx, bp
; @030A9 0000:30A9 original=f3a4
    rep movsb
; @030AB 0000:30AB original=2bfd
    sub di, bp
; @030AD 0000:30AD original=83c768
    add di, 068h
; @030B0 0000:30B0 original=59
    pop cx
; @030B1 0000:30B1 original=e2f3
    LOOP_SHORT loc_030A6
; @030B3 0000:30B3 original=c3
    ret
; sub_0000_30B4
; CopyPackedRowsStride160 (modern reconstruction name)
; As CopyPackedRowsStride104 but destination stride160. DS:SI header row count and width-units; width is
; multiplied by4; ES=CS:9598. Requires DF=0, positive row count, valid nonoverlapping ranges.
; AX/BP=width*4,CX=0; SI advances4+payload; DI advances160*rows; BX/DX/DS unchanged; ES/flags changed.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @030B4 0000:30B4 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @030B9 0000:30B9 original=ad
    lodsw
; @030BA 0000:30BA original=8bc8
    mov cx, ax
; @030BC 0000:30BC original=ad
    lodsw
; @030BD 0000:30BD original=d1e0
    shl ax, 1
; @030BF 0000:30BF original=d1e0
    shl ax, 1
; @030C1 0000:30C1 original=8be8
    mov bp, ax
; @030C3 0000:30C3 original=51
    push cx
; @030C4 0000:30C4 original=8bcd
    mov cx, bp
; @030C6 0000:30C6 original=f3a4
    rep movsb
; @030C8 0000:30C8 original=2bfd
    sub di, bp
; @030CA 0000:30CA original=81c7a000
    add di, 0A0h
; @030CE 0000:30CE original=59
    pop cx
; @030CF 0000:30CF original=e2f2
    LOOP_SHORT loc_030C3
; @030D1 0000:30D1 original=c3
    ret
; @030D2 0000:30D2 original=8b5e02 runtime CFG evidence
    mov bx, word ptr ss:[bp + REC_Y]
; @030D5 0000:30D5 original=81fbe000 runtime CFG evidence
    cmp bx, 0E0h
; @030D9 0000:30D9 original=7203 runtime CFG evidence
    JB_SHORT loc_030DE
; @030DB 0000:30DB original=e9d4f4 runtime CFG evidence
    JMP_NEAR loc_025B2
; @030DE 0000:30DE original=d1e3 runtime CFG evidence
    shl bx, 1
; @030E0 0000:30E0 original=8b9fc899 runtime CFG evidence
    mov bx, word ptr ds:[bx - 06638h]
; @030E4 0000:30E4 original=83fbff runtime CFG evidence
    cmp bx, -1
; @030E7 0000:30E7 original=7503 runtime CFG evidence
    JNE_SHORT loc_030EC
; @030E9 0000:30E9 original=e9c6f4 runtime CFG evidence
    JMP_NEAR loc_025B2
; @030EC 0000:30EC original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + REC_X]
; @030EF 0000:30EF original=c746120000 runtime CFG evidence
    mov word ptr ss:[bp + 012h], 0
; @030F4 0000:30F4 original=d1e8 runtime CFG evidence
    shr ax, 1
; @030F6 0000:30F6 original=03c3 runtime CFG evidence
    add ax, bx
; @030F8 0000:30F8 original=837e2400 runtime CFG evidence
    cmp word ptr ss:[bp + 024h], 0
; @030FC 0000:30FC original=7501 runtime CFG evidence
    JNE_SHORT loc_030FF
; @030FE 0000:30FE original=c3 runtime CFG evidence
    ret
; @030FF 0000:30FF original=ff4e24 runtime CFG evidence
    dec word ptr ss:[bp + 024h]
; @03102 0000:3102 original=c3 runtime CFG evidence
    ret
; sub_0000_3103
; TandyOffsetFromRow9EE8 (modern reconstruction name)
; AH indexes unsigned word table DS:9EE8 (2*AH); AL is multiplied by4. AX=DI=(table[AH]+4*AL) mod65536;
; BX=table[AH]. All other registers unchanged; arithmetic flags from final ADD. No bounds check: initializer
; populates only200 entries.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @03103 0000:3103 original=8adc
    mov bl, ah
; @03105 0000:3105 original=32ff
    xor bh, bh
; @03107 0000:3107 original=d1e3
    shl bx, 1
; @03109 0000:3109 original=8b9fe89e
    mov bx, word ptr ds:[bx - 06118h]
; @0310D 0000:310D original=32e4
    xor ah, ah
; @0310F 0000:310F original=d1e0
    shl ax, 1
; @03111 0000:3111 original=d1e0
    shl ax, 1
; @03113 0000:3113 original=03c3
    add ax, bx
; @03115 0000:3115 original=8bf8
    mov di, ax
; @03117 0000:3117 original=c3
    ret
; sub_0000_3118
; TandyOffsetFromRow9BC8 (modern reconstruction name)
; AH indexes unsigned word table DS:9BC8 (2*AH); AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. Other registers preserved; final ADD flags. No bounds check.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @03118 0000:3118 original=8adc
    mov bl, ah
; @0311A 0000:311A original=32ff
    xor bh, bh
; @0311C 0000:311C original=d1e3
    shl bx, 1
; @0311E 0000:311E original=8b9fc89b
    mov bx, word ptr ds:[bx - 06438h]
; @03122 0000:3122 original=32e4
    xor ah, ah
; @03124 0000:3124 original=d1e0
    shl ax, 1
; @03126 0000:3126 original=d1e0
    shl ax, 1
; @03128 0000:3128 original=03c3
    add ax, bx
; @0312A 0000:312A original=8bf8
    mov di, ax
; @0312C 0000:312C original=c3
    ret
; sub_0000_312D
; TandyOffsetFromRow9D58 (modern reconstruction name)
; AH indexes unsigned word table DS:9D58 (2*AH); AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. Other registers preserved; final ADD flags. No bounds check.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @0312D 0000:312D original=8adc
    mov bl, ah
; @0312F 0000:312F original=32ff
    xor bh, bh
; @03131 0000:3131 original=d1e3
    shl bx, 1
; @03133 0000:3133 original=8b9f589d
    mov bx, word ptr ds:[bx - 062A8h]
; @03137 0000:3137 original=32e4
    xor ah, ah
; @03139 0000:3139 original=d1e0
    shl ax, 1
; @0313B 0000:313B original=d1e0
    shl ax, 1
; @0313D 0000:313D original=03c3
    add ax, bx
; @0313F 0000:313F original=8bf8
    mov di, ax
; @03141 0000:3141 original=c3
    ret
; @03142 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,05Eh,02h,0D1h,0E3h,08Bh,09Fh,0E8h,09Eh,08Bh,046h,04h,0D1h,0E8h,03h,0C3h
; @03152 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h
; sub_0000_3153
; @03153 0000:3153 original=3c10
    cmp al, 010h
; @03155 0000:3155 original=7503
    JNE_SHORT loc_0315A
; @03157 0000:3157 original=e9e301
    JMP_NEAR loc_0333D
; @0315A 0000:315A original=3c11
    cmp al, 011h
; @0315C 0000:315C original=7503
    JNE_SHORT loc_03161
; @0315E 0000:315E original=e9c101
    JMP_NEAR loc_03322
; @03161 0000:3161 original=32e4
    xor ah, ah
; @03163 0000:3163 original=d1e0
    shl ax, 1
; @03165 0000:3165 original=d1e0
    shl ax, 1
; @03167 0000:3167 original=d1e0
    shl ax, 1
; @03169 0000:3169 original=8bf0
    mov si, ax
; @0316B 0000:316B original=81c61618
    add si, 01816h
; @0316F 0000:316F original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @03174 0000:3174 original=33d2
    xor dx, dx
; @03176 0000:3176 original=8a165e21
    mov dl, byte ptr ds:[0215Eh]
; @0317A 0000:317A original=03166021
    add dx, word ptr ds:[02160h]
; @0317E 0000:317E original=8bfa
    mov di, dx
; @03180 0000:3180 original=8a165c21
    mov dl, byte ptr ds:[0215Ch]
; @03184 0000:3184 original=d0e2
    shl dl, 1
; @03186 0000:3186 original=d0e2
    shl dl, 1
; @03188 0000:3188 original=d0e2
    shl dl, 1
; @0318A 0000:318A original=d0e2
    shl dl, 1
; @0318C 0000:318C original=0a165c21
    or dl, byte ptr ds:[0215Ch]
; @03190 0000:3190 original=8af2
    mov dh, dl
; @03192 0000:3192 original=ac
    lodsb
; @03193 0000:3193 original=32e4
    xor ah, ah
; @03195 0000:3195 original=8bd8
    mov bx, ax
; @03197 0000:3197 original=d1e3
    shl bx, 1
; @03199 0000:3199 original=d1e3
    shl bx, 1
; @0319B 0000:319B original=81c31415
    add bx, 01514h
; @0319F 0000:319F original=8b07
    mov ax, word ptr ds:[bx]
; @031A1 0000:31A1 original=8bc8
    mov cx, ax
; @031A3 0000:31A3 original=23ca
    and cx, dx
; @031A5 0000:31A5 original=26890d
    mov word ptr es:[di], cx
; @031A8 0000:31A8 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @031AB 0000:31AB original=8bc8
    mov cx, ax
; @031AD 0000:31AD original=23ca
    and cx, dx
; @031AF 0000:31AF original=26894d02
    mov word ptr es:[di + 2], cx
; @031B3 0000:31B3 original=81c70020
    add di, 02000h
; @031B7 0000:31B7 original=f7c70080
    test di, 08000h
; @031BB 0000:31BB original=7404
    JE_SHORT loc_031C1
; @031BD 0000:31BD original=81c7a080
    add di, 080A0h
; @031C1 0000:31C1 original=ac
    lodsb
; @031C2 0000:31C2 original=32e4
    xor ah, ah
; @031C4 0000:31C4 original=8bd8
    mov bx, ax
; @031C6 0000:31C6 original=d1e3
    shl bx, 1
; @031C8 0000:31C8 original=d1e3
    shl bx, 1
; @031CA 0000:31CA original=81c31415
    add bx, 01514h
; @031CE 0000:31CE original=8b07
    mov ax, word ptr ds:[bx]
; @031D0 0000:31D0 original=8bc8
    mov cx, ax
; @031D2 0000:31D2 original=23ca
    and cx, dx
; @031D4 0000:31D4 original=26890d
    mov word ptr es:[di], cx
; @031D7 0000:31D7 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @031DA 0000:31DA original=8bc8
    mov cx, ax
; @031DC 0000:31DC original=23ca
    and cx, dx
; @031DE 0000:31DE original=26894d02
    mov word ptr es:[di + 2], cx
; @031E2 0000:31E2 original=81c70020
    add di, 02000h
; @031E6 0000:31E6 original=f7c70080
    test di, 08000h
; @031EA 0000:31EA original=7404
    JE_SHORT loc_031F0
; @031EC 0000:31EC original=81c7a080
    add di, 080A0h
; @031F0 0000:31F0 original=ac
    lodsb
; @031F1 0000:31F1 original=32e4
    xor ah, ah
; @031F3 0000:31F3 original=8bd8
    mov bx, ax
; @031F5 0000:31F5 original=d1e3
    shl bx, 1
; @031F7 0000:31F7 original=d1e3
    shl bx, 1
; @031F9 0000:31F9 original=81c31415
    add bx, 01514h
; @031FD 0000:31FD original=8b07
    mov ax, word ptr ds:[bx]
; @031FF 0000:31FF original=8bc8
    mov cx, ax
; @03201 0000:3201 original=23ca
    and cx, dx
; @03203 0000:3203 original=26890d
    mov word ptr es:[di], cx
; @03206 0000:3206 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @03209 0000:3209 original=8bc8
    mov cx, ax
; @0320B 0000:320B original=23ca
    and cx, dx
; @0320D 0000:320D original=26894d02
    mov word ptr es:[di + 2], cx
; @03211 0000:3211 original=81c70020
    add di, 02000h
; @03215 0000:3215 original=f7c70080
    test di, 08000h
; @03219 0000:3219 original=7404
    JE_SHORT loc_0321F
; @0321B 0000:321B original=81c7a080
    add di, 080A0h
; @0321F 0000:321F original=ac
    lodsb
; @03220 0000:3220 original=32e4
    xor ah, ah
; @03222 0000:3222 original=8bd8
    mov bx, ax
; @03224 0000:3224 original=d1e3
    shl bx, 1
; @03226 0000:3226 original=d1e3
    shl bx, 1
; @03228 0000:3228 original=81c31415
    add bx, 01514h
; @0322C 0000:322C original=8b07
    mov ax, word ptr ds:[bx]
; @0322E 0000:322E original=8bc8
    mov cx, ax
; @03230 0000:3230 original=23ca
    and cx, dx
; @03232 0000:3232 original=26890d
    mov word ptr es:[di], cx
; @03235 0000:3235 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @03238 0000:3238 original=8bc8
    mov cx, ax
; @0323A 0000:323A original=23ca
    and cx, dx
; @0323C 0000:323C original=26894d02
    mov word ptr es:[di + 2], cx
; @03240 0000:3240 original=81c70020
    add di, 02000h
; @03244 0000:3244 original=f7c70080
    test di, 08000h
; @03248 0000:3248 original=7404
    JE_SHORT loc_0324E
; @0324A 0000:324A original=81c7a080
    add di, 080A0h
; @0324E 0000:324E original=ac
    lodsb
; @0324F 0000:324F original=32e4
    xor ah, ah
; @03251 0000:3251 original=8bd8
    mov bx, ax
; @03253 0000:3253 original=d1e3
    shl bx, 1
; @03255 0000:3255 original=d1e3
    shl bx, 1
; @03257 0000:3257 original=81c31415
    add bx, 01514h
; @0325B 0000:325B original=8b07
    mov ax, word ptr ds:[bx]
; @0325D 0000:325D original=8bc8
    mov cx, ax
; @0325F 0000:325F original=23ca
    and cx, dx
; @03261 0000:3261 original=26890d
    mov word ptr es:[di], cx
; @03264 0000:3264 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @03267 0000:3267 original=8bc8
    mov cx, ax
; @03269 0000:3269 original=23ca
    and cx, dx
; @0326B 0000:326B original=26894d02
    mov word ptr es:[di + 2], cx
; @0326F 0000:326F original=81c70020
    add di, 02000h
; @03273 0000:3273 original=f7c70080
    test di, 08000h
; @03277 0000:3277 original=7404
    JE_SHORT loc_0327D
; @03279 0000:3279 original=81c7a080
    add di, 080A0h
; @0327D 0000:327D original=ac
    lodsb
; @0327E 0000:327E original=32e4
    xor ah, ah
; @03280 0000:3280 original=8bd8
    mov bx, ax
; @03282 0000:3282 original=d1e3
    shl bx, 1
; @03284 0000:3284 original=d1e3
    shl bx, 1
; @03286 0000:3286 original=81c31415
    add bx, 01514h
; @0328A 0000:328A original=8b07
    mov ax, word ptr ds:[bx]
; @0328C 0000:328C original=8bc8
    mov cx, ax
; @0328E 0000:328E original=23ca
    and cx, dx
; @03290 0000:3290 original=26890d
    mov word ptr es:[di], cx
; @03293 0000:3293 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @03296 0000:3296 original=8bc8
    mov cx, ax
; @03298 0000:3298 original=23ca
    and cx, dx
; @0329A 0000:329A original=26894d02
    mov word ptr es:[di + 2], cx
; @0329E 0000:329E original=81c70020
    add di, 02000h
; @032A2 0000:32A2 original=f7c70080
    test di, 08000h
; @032A6 0000:32A6 original=7404
    JE_SHORT loc_032AC
; @032A8 0000:32A8 original=81c7a080
    add di, 080A0h
; @032AC 0000:32AC original=ac
    lodsb
; @032AD 0000:32AD original=32e4
    xor ah, ah
; @032AF 0000:32AF original=8bd8
    mov bx, ax
; @032B1 0000:32B1 original=d1e3
    shl bx, 1
; @032B3 0000:32B3 original=d1e3
    shl bx, 1
; @032B5 0000:32B5 original=81c31415
    add bx, 01514h
; @032B9 0000:32B9 original=8b07
    mov ax, word ptr ds:[bx]
; @032BB 0000:32BB original=8bc8
    mov cx, ax
; @032BD 0000:32BD original=23ca
    and cx, dx
; @032BF 0000:32BF original=26890d
    mov word ptr es:[di], cx
; @032C2 0000:32C2 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @032C5 0000:32C5 original=8bc8
    mov cx, ax
; @032C7 0000:32C7 original=23ca
    and cx, dx
; @032C9 0000:32C9 original=26894d02
    mov word ptr es:[di + 2], cx
; @032CD 0000:32CD original=81c70020
    add di, 02000h
; @032D1 0000:32D1 original=f7c70080
    test di, 08000h
; @032D5 0000:32D5 original=7404
    JE_SHORT loc_032DB
; @032D7 0000:32D7 original=81c7a080
    add di, 080A0h
; @032DB 0000:32DB original=ac
    lodsb
; @032DC 0000:32DC original=32e4
    xor ah, ah
; @032DE 0000:32DE original=8bd8
    mov bx, ax
; @032E0 0000:32E0 original=d1e3
    shl bx, 1
; @032E2 0000:32E2 original=d1e3
    shl bx, 1
; @032E4 0000:32E4 original=81c31415
    add bx, 01514h
; @032E8 0000:32E8 original=8b07
    mov ax, word ptr ds:[bx]
; @032EA 0000:32EA original=8bc8
    mov cx, ax
; @032EC 0000:32EC original=23ca
    and cx, dx
; @032EE 0000:32EE original=26890d
    mov word ptr es:[di], cx
; @032F1 0000:32F1 original=8b4702
    mov ax, word ptr ds:[bx + 2]
; @032F4 0000:32F4 original=8bc8
    mov cx, ax
; @032F6 0000:32F6 original=23ca
    and cx, dx
; @032F8 0000:32F8 original=26894d02
    mov word ptr es:[di + 2], cx
; @032FC 0000:32FC original=81c70020
    add di, 02000h
; @03300 0000:3300 original=f7c70080
    test di, 08000h
; @03304 0000:3304 original=7404
    JE_SHORT loc_0330A
; @03306 0000:3306 original=81c7a080
    add di, 080A0h
; @0330A 0000:330A original=80065e2104
    add byte ptr ds:[0215Eh], 4
; @0330F 0000:330F original=803e5e21a0
    cmp byte ptr ds:[0215Eh], 0A0h
; @03314 0000:3314 original=720b
    JB_SHORT loc_03321
; @03316 0000:3316 original=c6065e2100
    mov byte ptr ds:[0215Eh], 0
; @0331B 0000:331B original=810660214001
    add word ptr ds:[02160h], 0140h
; @03321 0000:3321 original=c3
    ret
; @03322 0000:3322 original=8a4601
    mov al, byte ptr ss:[bp + 1]
; @03325 0000:3325 original=b94001
    mov cx, 0140h
; @03328 0000:3328 original=32e4
    xor ah, ah
; @0332A 0000:332A original=f7e1
    mul cx
; @0332C 0000:332C original=a36021
    mov word ptr ds:[02160h], ax
; @0332F 0000:332F original=8a4602
    mov al, byte ptr ss:[bp + 2]
; @03332 0000:3332 original=d0e0
    shl al, 1
; @03334 0000:3334 original=d0e0
    shl al, 1
; @03336 0000:3336 original=a25e21
    mov byte ptr ds:[0215Eh], al
; @03339 0000:3339 original=83c502
    add bp, 2
; @0333C 0000:333C original=c3
    ret
; @0333D 0000:333D original=45
    inc bp
; @0333E 0000:333E original=8a4600
    mov al, byte ptr ss:[bp]
; @03341 0000:3341 original=a25c21
    mov byte ptr ds:[0215Ch], al
; @03344 0000:3344 original=c3
    ret
; sub_0000_3345
; ClearTandy32K (modern reconstruction name)
; ES=CS:95A4; with DF=0 write32768 zero bytes at ES:0000..7FFF. AX=CX=0,DI=8000h; BX/DX/SI/BP/DS preserved. Flags from XOR DI,DI. Does not restore ES or set DF.
; Evidence: metadata/symbols.json; tests/test_tandy_adlib.py
; @03345 0000:3345 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @0334A 0000:334A original=33ff
    xor di, di
; @0334C 0000:334C original=8bc7
    mov ax, di
; @0334E 0000:334E original=b90040
    mov cx, 04000h
; @03351 0000:3351 original=f3ab
    rep stosw
; @03353 0000:3353 original=c3
    ret
; sub_0000_3354
; CopyWorkspace104x192ToTandy (modern reconstruction name)
; Read source offset from incoming DS:234C; set ES=CS:95A4 and DS=CS:9598. With DF=0 copy192 contiguous104-byte
; source rows into the first104 bytes of Tandy rows4..195. Then set DS=CS:9596, not incoming DS. SI
; advances19968, DI=1EA0h, BX=34h, CX=BP=0; AX/DX preserved; flags changed. Requires valid nonoverlapping
; buffers.
; Evidence: metadata/symbols.json
; @03354 0000:3354 original=8b364c23
    mov si, word ptr ds:[0234Ch]
; @03358 0000:3358 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @0335D 0000:335D original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @03362 0000:3362 original=bb3400
    mov bx, 034h
; @03365 0000:3365 original=bfa000
    mov di, 0A0h
; @03368 0000:3368 original=bdc000
    mov bp, 0C0h
; @0336B 0000:336B original=8bcb
    mov cx, bx
; @0336D 0000:336D original=f3a5
    rep movsw
; @0336F 0000:336F original=83ef68
    sub di, 068h
; @03372 0000:3372 original=81c70020
    add di, 02000h
; @03376 0000:3376 original=f7c70080
    test di, 08000h
; @0337A 0000:337A original=7404
    JE_SHORT loc_03380
; @0337C 0000:337C original=81c7a080
    add di, 080A0h
; @03380 0000:3380 original=4d
    dec bp
; @03381 0000:3381 original=75e8
    JNE_SHORT loc_0336B
; @03383 0000:3383 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @03388 0000:3388 original=c3
    ret
; sub_0000_3389
; ClearTandy104x200 (modern reconstruction name)
; With DF=0 and ES=CS:95A4, clear the first104 bytes of each of200 Tandy display rows. Preserve remaining56
; visible bytes per row and bank padding. AX=CX=BP=0, DI=1F40h; ES changed; DS/BX/DX/SI preserved. Flags
; changed. No clipping or DF setup.
; Evidence: metadata/symbols.json
; @03389 0000:3389 original=2e8e06a495
    mov es, word ptr cs:[095A4h]
; @0338E 0000:338E original=33ff
    xor di, di
; @03390 0000:3390 original=bdc800
    mov bp, 0C8h
; @03393 0000:3393 original=b93400
    mov cx, 034h
; @03396 0000:3396 original=33c0
    xor ax, ax
; @03398 0000:3398 original=f3ab
    rep stosw
; @0339A 0000:339A original=83ef68
    sub di, 068h
; @0339D 0000:339D original=81c70020
    add di, 02000h
; @033A1 0000:33A1 original=f7c70080
    test di, 08000h
; @033A5 0000:33A5 original=7404
    JE_SHORT loc_033AB
; @033A7 0000:33A7 original=81c7a080
    add di, 080A0h
; @033AB 0000:33AB original=4d
    dec bp
; @033AC 0000:33AC original=75e5
    JNE_SHORT loc_03393
; @033AE 0000:33AE original=c3
    ret
; sub_0000_33AF
; @033AF 0000:33AF original=e82511
    CALL_NEAR loc_044D7
; @033B2 0000:33B2 original=7503
    JNE_SHORT loc_033B7
; @033B4 0000:33B4 original=e9f310
    JMP_NEAR loc_044AA
; @033B7 0000:33B7 original=2e8b0e9e5b
    mov cx, word ptr cs:[05B9Eh]
; @033BC 0000:33BC original=51
    push cx
; @033BD 0000:33BD original=2e8b0e9c5b
    mov cx, word ptr cs:[05B9Ch]
; @033C2 0000:33C2 original=51
    push cx
; @033C3 0000:33C3 original=e81700
    CALL_NEAR loc_033DD
; @033C6 0000:33C6 original=59
    pop cx
; @033C7 0000:33C7 original=e2f9
    LOOP_SHORT loc_033C2
; @033C9 0000:33C9 original=2e03369c5b
    add si, word ptr cs:[05B9Ch]
; @033CE 0000:33CE original=2e03369c5b
    add si, word ptr cs:[05B9Ch]
; @033D3 0000:33D3 original=2e03369c5b
    add si, word ptr cs:[05B9Ch]
; @033D8 0000:33D8 original=59
    pop cx
; @033D9 0000:33D9 original=e2e1
    LOOP_SHORT loc_033BC
; @033DB 0000:33DB original=ebd2
    JMP_SHORT loc_033AF
; sub_0000_33DD
; @033DD 0000:33DD original=2e8b1e9c5b
    mov bx, word ptr cs:[05B9Ch]
; @033E2 0000:33E2 original=8a04
    mov al, byte ptr ds:[si]
; @033E4 0000:33E4 original=8a20
    mov ah, byte ptr ds:[bx + si]
; @033E6 0000:33E6 original=d1e3
    shl bx, 1
; @033E8 0000:33E8 original=8a10
    mov dl, byte ptr ds:[bx + si]
; @033EA 0000:33EA original=2e031e9c5b
    add bx, word ptr cs:[05B9Ch]
; @033EF 0000:33EF original=8a30
    mov dh, byte ptr ds:[bx + si]
; @033F1 0000:33F1 original=e85700
    CALL_NEAR loc_0344B
; @033F4 0000:33F4 original=2e880e955b
    mov byte ptr cs:[05B95h], cl
; @033F9 0000:33F9 original=2e882e995b
    mov byte ptr cs:[05B99h], ch
; @033FE 0000:33FE original=e84a00
    CALL_NEAR loc_0344B
; @03401 0000:3401 original=2e880e945b
    mov byte ptr cs:[05B94h], cl
; @03406 0000:3406 original=2e882e985b
    mov byte ptr cs:[05B98h], ch
; @0340B 0000:340B original=e83d00
    CALL_NEAR loc_0344B
; @0340E 0000:340E original=2e880e975b
    mov byte ptr cs:[05B97h], cl
; @03413 0000:3413 original=2e882e9b5b
    mov byte ptr cs:[05B9Bh], ch
; @03418 0000:3418 original=e83000
    CALL_NEAR loc_0344B
; @0341B 0000:341B original=2e880e965b
    mov byte ptr cs:[05B96h], cl
; @03420 0000:3420 original=2e882e9a5b
    mov byte ptr cs:[05B9Ah], ch
; @03425 0000:3425 original=46
    inc si
; @03426 0000:3426 original=2e833ed60b00
    cmp word ptr cs:[0BD6h], 0
; @0342C 0000:342C original=7405
    JE_SHORT loc_03433
; @0342E 0000:342E original=2ea19a5b
    mov ax, word ptr cs:[05B9Ah]
; @03432 0000:3432 original=ab
    stosw
; @03433 0000:3433 original=2ea1965b
    mov ax, word ptr cs:[05B96h]
; @03437 0000:3437 original=ab
    stosw
; @03438 0000:3438 original=2e833ed60b00
    cmp word ptr cs:[0BD6h], 0
; @0343E 0000:343E original=7405
    JE_SHORT loc_03445
; @03440 0000:3440 original=2ea1985b
    mov ax, word ptr cs:[05B98h]
; @03444 0000:3444 original=ab
    stosw
; @03445 0000:3445 original=2ea1945b
    mov ax, word ptr cs:[05B94h]
; @03449 0000:3449 original=ab
    stosw
; @0344A 0000:344A original=c3
    ret
; sub_0000_344B
; @0344B 0000:344B original=d0ce
    ror dh, 1
; @0344D 0000:344D original=d0d1
    rcl cl, 1
; @0344F 0000:344F original=d0ca
    ror dl, 1
; @03451 0000:3451 original=d0d1
    rcl cl, 1
; @03453 0000:3453 original=d0cc
    ror ah, 1
; @03455 0000:3455 original=d0d1
    rcl cl, 1
; @03457 0000:3457 original=d0c8
    ror al, 1
; @03459 0000:3459 original=d0d1
    rcl cl, 1
; @0345B 0000:345B original=d0ce
    ror dh, 1
; @0345D 0000:345D original=d0d1
    rcl cl, 1
; @0345F 0000:345F original=d0ca
    ror dl, 1
; @03461 0000:3461 original=d0d1
    rcl cl, 1
; @03463 0000:3463 original=d0cc
    ror ah, 1
; @03465 0000:3465 original=d0d1
    rcl cl, 1
; @03467 0000:3467 original=d0c8
    ror al, 1
; @03469 0000:3469 original=d0d1
    rcl cl, 1
; @0346B 0000:346B original=d0c9
    ror cl, 1
; @0346D 0000:346D original=d0c9
    ror cl, 1
; @0346F 0000:346F original=d0c9
    ror cl, 1
; @03471 0000:3471 original=d0c9
    ror cl, 1
; @03473 0000:3473 original=2e833ed60b00
    cmp word ptr cs:[0BD6h], 0
; @03479 0000:3479 original=7501
    JNE_SHORT loc_0347C
; @0347B 0000:347B original=c3
    ret
; @0347C 0000:347C original=8bd8
    mov bx, ax
; @0347E 0000:347E original=32ed
    xor ch, ch
; @03480 0000:3480 original=8ac1
    mov al, cl
; @03482 0000:3482 original=240f
    and al, 0Fh
; @03484 0000:3484 original=2e3a060000
    cmp al, byte ptr cs:[0]
; @03489 0000:3489 original=7506
    JNE_SHORT loc_03491
; @0348B 0000:348B original=80cd0f
    or ch, 0Fh
; @0348E 0000:348E original=80e1f0
    and cl, 0F0h
; @03491 0000:3491 original=8ac1
    mov al, cl
; @03493 0000:3493 original=24f0
    and al, 0F0h
; @03495 0000:3495 original=d0e8
    shr al, 1
; @03497 0000:3497 original=d0e8
    shr al, 1
; @03499 0000:3499 original=d0e8
    shr al, 1
; @0349B 0000:349B original=d0e8
    shr al, 1
; @0349D 0000:349D original=2e3a060000
    cmp al, byte ptr cs:[0]
; @034A2 0000:34A2 original=7506
    JNE_SHORT loc_034AA
; @034A4 0000:34A4 original=80cdf0
    or ch, 0F0h
; @034A7 0000:34A7 original=80e10f
    and cl, 0Fh
; @034AA 0000:34AA original=8bc3
    mov ax, bx
; @034AC 0000:34AC original=c3
    ret
; @034AD 0000:34AD original=83ffff runtime CFG evidence
    cmp di, -1
; @034B0 0000:34B0 original=7403 runtime CFG evidence
    JE_SHORT loc_034B5
; @034B2 0000:34B2 original=e81000 runtime CFG evidence
    CALL_NEAR loc_034C5
; @034B5 0000:34B5 original=8b7e10 runtime CFG evidence
    mov di, word ptr ss:[bp + 010h]
; @034B8 0000:34B8 original=8b760e runtime CFG evidence
    mov si, word ptr ss:[bp + 0Eh]
; @034BB 0000:34BB original=81c64001 runtime CFG evidence
    add si, 0140h
; @034BF 0000:34BF original=83ffff runtime CFG evidence
    cmp di, -1
; @034C2 0000:34C2 original=7501 runtime CFG evidence
    JNE_SHORT loc_034C5
; @034C4 0000:34C4 original=c3 runtime CFG evidence
    ret
; @034C5 0000:34C5 original=bb5800 runtime CFG evidence
    mov bx, 058h
; @034C8 0000:34C8 original=b91000 runtime CFG evidence
    mov cx, 010h
; @034CB 0000:34CB original=a5 runtime CFG evidence
    movsw
; @034CC 0000:34CC original=a5 runtime CFG evidence
    movsw
; @034CD 0000:34CD original=a5 runtime CFG evidence
    movsw
; @034CE 0000:34CE original=a5 runtime CFG evidence
    movsw
; @034CF 0000:34CF original=a5 runtime CFG evidence
    movsw
; @034D0 0000:34D0 original=a5 runtime CFG evidence
    movsw
; @034D1 0000:34D1 original=a5 runtime CFG evidence
    movsw
; @034D2 0000:34D2 original=a5 runtime CFG evidence
    movsw
; @034D3 0000:34D3 original=03fb runtime CFG evidence
    add di, bx
; @034D5 0000:34D5 original=e2f4 runtime CFG evidence
    LOOP_SHORT loc_034CB
; @034D7 0000:34D7 original=c3 runtime CFG evidence
    ret
; @034D8 0000:34D8 original=83ffff runtime CFG evidence
    cmp di, -1
; @034DB 0000:34DB original=7501 runtime CFG evidence
    JNE_SHORT loc_034DE
; @034DD 0000:34DD original=c3 runtime CFG evidence
    ret
; @034DE 0000:34DE original=bb6000 runtime CFG evidence
    mov bx, 060h
; @034E1 0000:34E1 original=a5 runtime CFG evidence
    movsw
; @034E2 0000:34E2 original=a5 runtime CFG evidence
    movsw
; @034E3 0000:34E3 original=a5 runtime CFG evidence
    movsw
; @034E4 0000:34E4 original=a5 runtime CFG evidence
    movsw
; @034E5 0000:34E5 original=03fb runtime CFG evidence
    add di, bx
; @034E7 0000:34E7 original=a5 runtime CFG evidence
    movsw
; @034E8 0000:34E8 original=a5 runtime CFG evidence
    movsw
; @034E9 0000:34E9 original=a5 runtime CFG evidence
    movsw
; @034EA 0000:34EA original=a5 runtime CFG evidence
    movsw
; @034EB 0000:34EB original=03fb runtime CFG evidence
    add di, bx
; @034ED 0000:34ED original=a5 runtime CFG evidence
    movsw
; @034EE 0000:34EE original=a5 runtime CFG evidence
    movsw
; @034EF 0000:34EF original=a5 runtime CFG evidence
    movsw
; @034F0 0000:34F0 original=a5 runtime CFG evidence
    movsw
; @034F1 0000:34F1 original=03fb runtime CFG evidence
    add di, bx
; @034F3 0000:34F3 original=a5 runtime CFG evidence
    movsw
; @034F4 0000:34F4 original=a5 runtime CFG evidence
    movsw
; @034F5 0000:34F5 original=a5 runtime CFG evidence
    movsw
; @034F6 0000:34F6 original=a5 runtime CFG evidence
    movsw
; @034F7 0000:34F7 original=03fb runtime CFG evidence
    add di, bx
; @034F9 0000:34F9 original=a5 runtime CFG evidence
    movsw
; @034FA 0000:34FA original=a5 runtime CFG evidence
    movsw
; @034FB 0000:34FB original=a5 runtime CFG evidence
    movsw
; @034FC 0000:34FC original=a5 runtime CFG evidence
    movsw
; @034FD 0000:34FD original=03fb runtime CFG evidence
    add di, bx
; @034FF 0000:34FF original=a5 runtime CFG evidence
    movsw
; @03500 0000:3500 original=a5 runtime CFG evidence
    movsw
; @03501 0000:3501 original=a5 runtime CFG evidence
    movsw
; @03502 0000:3502 original=a5 runtime CFG evidence
    movsw
; @03503 0000:3503 original=03fb runtime CFG evidence
    add di, bx
; @03505 0000:3505 original=a5 runtime CFG evidence
    movsw
; @03506 0000:3506 original=a5 runtime CFG evidence
    movsw
; @03507 0000:3507 original=a5 runtime CFG evidence
    movsw
; @03508 0000:3508 original=a5 runtime CFG evidence
    movsw
; @03509 0000:3509 original=03fb runtime CFG evidence
    add di, bx
; @0350B 0000:350B original=a5 runtime CFG evidence
    movsw
; @0350C 0000:350C original=a5 runtime CFG evidence
    movsw
; @0350D 0000:350D original=a5 runtime CFG evidence
    movsw
; @0350E 0000:350E original=a5 runtime CFG evidence
    movsw
; @0350F 0000:350F original=03fb runtime CFG evidence
    add di, bx
; @03511 0000:3511 original=a5 runtime CFG evidence
    movsw
; @03512 0000:3512 original=a5 runtime CFG evidence
    movsw
; @03513 0000:3513 original=a5 runtime CFG evidence
    movsw
; @03514 0000:3514 original=a5 runtime CFG evidence
    movsw
; @03515 0000:3515 original=03fb runtime CFG evidence
    add di, bx
; @03517 0000:3517 original=a5 runtime CFG evidence
    movsw
; @03518 0000:3518 original=a5 runtime CFG evidence
    movsw
; @03519 0000:3519 original=a5 runtime CFG evidence
    movsw
; @0351A 0000:351A original=a5 runtime CFG evidence
    movsw
; @0351B 0000:351B original=03fb runtime CFG evidence
    add di, bx
; @0351D 0000:351D original=a5 runtime CFG evidence
    movsw
; @0351E 0000:351E original=a5 runtime CFG evidence
    movsw
; @0351F 0000:351F original=a5 runtime CFG evidence
    movsw
; @03520 0000:3520 original=a5 runtime CFG evidence
    movsw
; @03521 0000:3521 original=03fb runtime CFG evidence
    add di, bx
; @03523 0000:3523 original=a5 runtime CFG evidence
    movsw
; @03524 0000:3524 original=a5 runtime CFG evidence
    movsw
; @03525 0000:3525 original=a5 runtime CFG evidence
    movsw
; @03526 0000:3526 original=a5 runtime CFG evidence
    movsw
; @03527 0000:3527 original=03fb runtime CFG evidence
    add di, bx
; @03529 0000:3529 original=a5 runtime CFG evidence
    movsw
; @0352A 0000:352A original=a5 runtime CFG evidence
    movsw
; @0352B 0000:352B original=a5 runtime CFG evidence
    movsw
; @0352C 0000:352C original=a5 runtime CFG evidence
    movsw
; @0352D 0000:352D original=03fb runtime CFG evidence
    add di, bx
; @0352F 0000:352F original=a5 runtime CFG evidence
    movsw
; @03530 0000:3530 original=a5 runtime CFG evidence
    movsw
; @03531 0000:3531 original=a5 runtime CFG evidence
    movsw
; @03532 0000:3532 original=a5 runtime CFG evidence
    movsw
; @03533 0000:3533 original=03fb runtime CFG evidence
    add di, bx
; @03535 0000:3535 original=a5 runtime CFG evidence
    movsw
; @03536 0000:3536 original=a5 runtime CFG evidence
    movsw
; @03537 0000:3537 original=a5 runtime CFG evidence
    movsw
; @03538 0000:3538 original=a5 runtime CFG evidence
    movsw
; @03539 0000:3539 original=03fb runtime CFG evidence
    add di, bx
; @0353B 0000:353B original=a5 runtime CFG evidence
    movsw
; @0353C 0000:353C original=a5 runtime CFG evidence
    movsw
; @0353D 0000:353D original=a5 runtime CFG evidence
    movsw
; @0353E 0000:353E original=a5 runtime CFG evidence
    movsw
; @0353F 0000:353F original=03fb runtime CFG evidence
    add di, bx
; @03541 0000:3541 original=c3 runtime CFG evidence
    ret
; @03542 0000:3542 original=83ffff runtime CFG evidence
    cmp di, -1
; @03545 0000:3545 original=7501 runtime CFG evidence
    JNE_SHORT loc_03548
; @03547 0000:3547 original=c3 runtime CFG evidence
    ret
; @03548 0000:3548 original=bb6400 runtime CFG evidence
    mov bx, 064h
; @0354B 0000:354B original=a5 runtime CFG evidence
    movsw
; @0354C 0000:354C original=a5 runtime CFG evidence
    movsw
; @0354D 0000:354D original=03fb runtime CFG evidence
    add di, bx
; @0354F 0000:354F original=a5 runtime CFG evidence
    movsw
; @03550 0000:3550 original=a5 runtime CFG evidence
    movsw
; @03551 0000:3551 original=03fb runtime CFG evidence
    add di, bx
; @03553 0000:3553 original=a5 runtime CFG evidence
    movsw
; @03554 0000:3554 original=a5 runtime CFG evidence
    movsw
; @03555 0000:3555 original=03fb runtime CFG evidence
    add di, bx
; @03557 0000:3557 original=a5 runtime CFG evidence
    movsw
; @03558 0000:3558 original=a5 runtime CFG evidence
    movsw
; @03559 0000:3559 original=03fb runtime CFG evidence
    add di, bx
; @0355B 0000:355B original=a5 runtime CFG evidence
    movsw
; @0355C 0000:355C original=a5 runtime CFG evidence
    movsw
; @0355D 0000:355D original=03fb runtime CFG evidence
    add di, bx
; @0355F 0000:355F original=a5 runtime CFG evidence
    movsw
; @03560 0000:3560 original=a5 runtime CFG evidence
    movsw
; @03561 0000:3561 original=03fb runtime CFG evidence
    add di, bx
; @03563 0000:3563 original=a5 runtime CFG evidence
    movsw
; @03564 0000:3564 original=a5 runtime CFG evidence
    movsw
; @03565 0000:3565 original=03fb runtime CFG evidence
    add di, bx
; @03567 0000:3567 original=a5 runtime CFG evidence
    movsw
; @03568 0000:3568 original=a5 runtime CFG evidence
    movsw
; @03569 0000:3569 original=03fb runtime CFG evidence
    add di, bx
; @0356B 0000:356B original=c3 runtime CFG evidence
    ret
; @0356C 0000:356C original=e8c724 runtime CFG evidence
    CALL_NEAR loc_05A36
; @0356F 0000:356F original=89460c runtime CFG evidence
    mov word ptr ss:[bp + 0Ch], ax
; @03572 0000:3572 original=3dffff runtime CFG evidence
    cmp ax, 0FFFFh
; @03575 0000:3575 original=740f runtime CFG evidence
    JE_SHORT loc_03586
; @03577 0000:3577 original=03064c23 runtime CFG evidence
    add ax, word ptr ds:[0234Ch]
; @0357B 0000:357B original=89460c runtime CFG evidence
    mov word ptr ss:[bp + 0Ch], ax
; @0357E 0000:357E original=8bf0 runtime CFG evidence
    mov si, ax
; @03580 0000:3580 original=8b7e0e runtime CFG evidence
    mov di, word ptr ss:[bp + 0Eh]
; @03583 0000:3583 original=e82400 runtime CFG evidence
    CALL_NEAR loc_035AA
; @03586 0000:3586 original=83460210 runtime CFG evidence
    add word ptr ss:[bp + 2], 010h
; @0358A 0000:358A original=e8a924 runtime CFG evidence
    CALL_NEAR loc_05A36
; @0358D 0000:358D original=894610 runtime CFG evidence
    mov word ptr ss:[bp + 010h], ax
; @03590 0000:3590 original=836e0210 runtime CFG evidence
    sub word ptr ss:[bp + 2], 010h
; @03594 0000:3594 original=3dffff runtime CFG evidence
    cmp ax, 0FFFFh
; @03597 0000:3597 original=7501 runtime CFG evidence
    JNE_SHORT loc_0359A
; @03599 0000:3599 original=c3 runtime CFG evidence
    ret
; @0359A 0000:359A original=03064c23 runtime CFG evidence
    add ax, word ptr ds:[0234Ch]
; @0359E 0000:359E original=894610 runtime CFG evidence
    mov word ptr ss:[bp + 010h], ax
; @035A1 0000:35A1 original=8bf0 runtime CFG evidence
    mov si, ax
; @035A3 0000:35A3 original=8b7e0e runtime CFG evidence
    mov di, word ptr ss:[bp + 0Eh]
; @035A6 0000:35A6 original=81c74001 runtime CFG evidence
    add di, 0140h
; @035AA 0000:35AA original=2e8e069695 runtime CFG evidence
    mov es, word ptr cs:[09596h]
; @035AF 0000:35AF original=2e8e1e9895 runtime CFG evidence
    mov ds, word ptr cs:[09598h]
; @035B4 0000:35B4 original=bb5800 runtime CFG evidence
    mov bx, 058h
; @035B7 0000:35B7 original=b91000 runtime CFG evidence
    mov cx, 010h
; @035BA 0000:35BA original=a5 runtime CFG evidence
    movsw
; @035BB 0000:35BB original=a5 runtime CFG evidence
    movsw
; @035BC 0000:35BC original=a5 runtime CFG evidence
    movsw
; @035BD 0000:35BD original=a5 runtime CFG evidence
    movsw
; @035BE 0000:35BE original=a5 runtime CFG evidence
    movsw
; @035BF 0000:35BF original=a5 runtime CFG evidence
    movsw
; @035C0 0000:35C0 original=a5 runtime CFG evidence
    movsw
; @035C1 0000:35C1 original=a5 runtime CFG evidence
    movsw
; @035C2 0000:35C2 original=03f3 runtime CFG evidence
    add si, bx
; @035C4 0000:35C4 original=e2f4 runtime CFG evidence
    LOOP_SHORT loc_035BA
; @035C6 0000:35C6 original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @035CB 0000:35CB original=c3 runtime CFG evidence
    ret
; @035CC 0000:35CC original=e86724 runtime CFG evidence
    CALL_NEAR loc_05A36
; @035CF 0000:35CF original=89460c runtime CFG evidence
    mov word ptr ss:[bp + 0Ch], ax
; @035D2 0000:35D2 original=3dffff runtime CFG evidence
    cmp ax, 0FFFFh
; @035D5 0000:35D5 original=7501 runtime CFG evidence
    JNE_SHORT loc_035D8
; @035D7 0000:35D7 original=c3 runtime CFG evidence
    ret
; @035D8 0000:35D8 original=03064c23 runtime CFG evidence
    add ax, word ptr ds:[0234Ch]
; @035DC 0000:35DC original=89460c runtime CFG evidence
    mov word ptr ss:[bp + 0Ch], ax
; @035DF 0000:35DF original=8bf0 runtime CFG evidence
    mov si, ax
; @035E1 0000:35E1 original=8b7e0e runtime CFG evidence
    mov di, word ptr ss:[bp + 0Eh]
; @035E4 0000:35E4 original=2e8e069695 runtime CFG evidence
    mov es, word ptr cs:[09596h]
; @035E9 0000:35E9 original=2e8e1e9895 runtime CFG evidence
    mov ds, word ptr cs:[09598h]
; @035EE 0000:35EE original=bb6000 runtime CFG evidence
    mov bx, 060h
; @035F1 0000:35F1 original=a5 runtime CFG evidence
    movsw
; @035F2 0000:35F2 original=a5 runtime CFG evidence
    movsw
; @035F3 0000:35F3 original=a5 runtime CFG evidence
    movsw
; @035F4 0000:35F4 original=a5 runtime CFG evidence
    movsw
; @035F5 0000:35F5 original=03f3 runtime CFG evidence
    add si, bx
; @035F7 0000:35F7 original=a5 runtime CFG evidence
    movsw
; @035F8 0000:35F8 original=a5 runtime CFG evidence
    movsw
; @035F9 0000:35F9 original=a5 runtime CFG evidence
    movsw
; @035FA 0000:35FA original=a5 runtime CFG evidence
    movsw
; @035FB 0000:35FB original=03f3 runtime CFG evidence
    add si, bx
; @035FD 0000:35FD original=a5 runtime CFG evidence
    movsw
; @035FE 0000:35FE original=a5 runtime CFG evidence
    movsw
; @035FF 0000:35FF original=a5 runtime CFG evidence
    movsw
; @03600 0000:3600 original=a5 runtime CFG evidence
    movsw
; @03601 0000:3601 original=03f3 runtime CFG evidence
    add si, bx
; @03603 0000:3603 original=a5 runtime CFG evidence
    movsw
; @03604 0000:3604 original=a5 runtime CFG evidence
    movsw
; @03605 0000:3605 original=a5 runtime CFG evidence
    movsw
; @03606 0000:3606 original=a5 runtime CFG evidence
    movsw
; @03607 0000:3607 original=03f3 runtime CFG evidence
    add si, bx
; @03609 0000:3609 original=a5 runtime CFG evidence
    movsw
; @0360A 0000:360A original=a5 runtime CFG evidence
    movsw
; @0360B 0000:360B original=a5 runtime CFG evidence
    movsw
; @0360C 0000:360C original=a5 runtime CFG evidence
    movsw
; @0360D 0000:360D original=03f3 runtime CFG evidence
    add si, bx
; @0360F 0000:360F original=a5 runtime CFG evidence
    movsw
; @03610 0000:3610 original=a5 runtime CFG evidence
    movsw
; @03611 0000:3611 original=a5 runtime CFG evidence
    movsw
; @03612 0000:3612 original=a5 runtime CFG evidence
    movsw
; @03613 0000:3613 original=03f3 runtime CFG evidence
    add si, bx
; @03615 0000:3615 original=a5 runtime CFG evidence
    movsw
; @03616 0000:3616 original=a5 runtime CFG evidence
    movsw
; @03617 0000:3617 original=a5 runtime CFG evidence
    movsw
; @03618 0000:3618 original=a5 runtime CFG evidence
    movsw
; @03619 0000:3619 original=03f3 runtime CFG evidence
    add si, bx
; @0361B 0000:361B original=a5 runtime CFG evidence
    movsw
; @0361C 0000:361C original=a5 runtime CFG evidence
    movsw
; @0361D 0000:361D original=a5 runtime CFG evidence
    movsw
; @0361E 0000:361E original=a5 runtime CFG evidence
    movsw
; @0361F 0000:361F original=03f3 runtime CFG evidence
    add si, bx
; @03621 0000:3621 original=a5 runtime CFG evidence
    movsw
; @03622 0000:3622 original=a5 runtime CFG evidence
    movsw
; @03623 0000:3623 original=a5 runtime CFG evidence
    movsw
; @03624 0000:3624 original=a5 runtime CFG evidence
    movsw
; @03625 0000:3625 original=03f3 runtime CFG evidence
    add si, bx
; @03627 0000:3627 original=a5 runtime CFG evidence
    movsw
; @03628 0000:3628 original=a5 runtime CFG evidence
    movsw
; @03629 0000:3629 original=a5 runtime CFG evidence
    movsw
; @0362A 0000:362A original=a5 runtime CFG evidence
    movsw
; @0362B 0000:362B original=03f3 runtime CFG evidence
    add si, bx
; @0362D 0000:362D original=a5 runtime CFG evidence
    movsw
; @0362E 0000:362E original=a5 runtime CFG evidence
    movsw
; @0362F 0000:362F original=a5 runtime CFG evidence
    movsw
; @03630 0000:3630 original=a5 runtime CFG evidence
    movsw
; @03631 0000:3631 original=03f3 runtime CFG evidence
    add si, bx
; @03633 0000:3633 original=a5 runtime CFG evidence
    movsw
; @03634 0000:3634 original=a5 runtime CFG evidence
    movsw
; @03635 0000:3635 original=a5 runtime CFG evidence
    movsw
; @03636 0000:3636 original=a5 runtime CFG evidence
    movsw
; @03637 0000:3637 original=03f3 runtime CFG evidence
    add si, bx
; @03639 0000:3639 original=a5 runtime CFG evidence
    movsw
; @0363A 0000:363A original=a5 runtime CFG evidence
    movsw
; @0363B 0000:363B original=a5 runtime CFG evidence
    movsw
; @0363C 0000:363C original=a5 runtime CFG evidence
    movsw
; @0363D 0000:363D original=03f3 runtime CFG evidence
    add si, bx
; @0363F 0000:363F original=a5 runtime CFG evidence
    movsw
; @03640 0000:3640 original=a5 runtime CFG evidence
    movsw
; @03641 0000:3641 original=a5 runtime CFG evidence
    movsw
; @03642 0000:3642 original=a5 runtime CFG evidence
    movsw
; @03643 0000:3643 original=03f3 runtime CFG evidence
    add si, bx
; @03645 0000:3645 original=a5 runtime CFG evidence
    movsw
; @03646 0000:3646 original=a5 runtime CFG evidence
    movsw
; @03647 0000:3647 original=a5 runtime CFG evidence
    movsw
; @03648 0000:3648 original=a5 runtime CFG evidence
    movsw
; @03649 0000:3649 original=03f3 runtime CFG evidence
    add si, bx
; @0364B 0000:364B original=a5 runtime CFG evidence
    movsw
; @0364C 0000:364C original=a5 runtime CFG evidence
    movsw
; @0364D 0000:364D original=a5 runtime CFG evidence
    movsw
; @0364E 0000:364E original=a5 runtime CFG evidence
    movsw
; @0364F 0000:364F original=03f3 runtime CFG evidence
    add si, bx
; @03651 0000:3651 original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @03656 0000:3656 original=c3 runtime CFG evidence
    ret
; @03657 0000:3657 original=e8dc23 runtime CFG evidence
    CALL_NEAR loc_05A36
; @0365A 0000:365A original=89460c runtime CFG evidence
    mov word ptr ss:[bp + 0Ch], ax
; @0365D 0000:365D original=3dffff runtime CFG evidence
    cmp ax, 0FFFFh
; @03660 0000:3660 original=7501 runtime CFG evidence
    JNE_SHORT loc_03663
; @03662 0000:3662 original=c3 runtime CFG evidence
    ret
; @03663 0000:3663 original=03064c23 runtime CFG evidence
    add ax, word ptr ds:[0234Ch]
; @03667 0000:3667 original=89460c runtime CFG evidence
    mov word ptr ss:[bp + 0Ch], ax
; @0366A 0000:366A original=8bf0 runtime CFG evidence
    mov si, ax
; @0366C 0000:366C original=8b7e0e runtime CFG evidence
    mov di, word ptr ss:[bp + 0Eh]
; @0366F 0000:366F original=2e8e069695 runtime CFG evidence
    mov es, word ptr cs:[09596h]
; @03674 0000:3674 original=2e8e1e9895 runtime CFG evidence
    mov ds, word ptr cs:[09598h]
; @03679 0000:3679 original=bb6400 runtime CFG evidence
    mov bx, 064h
; @0367C 0000:367C original=a5 runtime CFG evidence
    movsw
; @0367D 0000:367D original=a5 runtime CFG evidence
    movsw
; @0367E 0000:367E original=03f3 runtime CFG evidence
    add si, bx
; @03680 0000:3680 original=a5 runtime CFG evidence
    movsw
; @03681 0000:3681 original=a5 runtime CFG evidence
    movsw
; @03682 0000:3682 original=03f3 runtime CFG evidence
    add si, bx
; @03684 0000:3684 original=a5 runtime CFG evidence
    movsw
; @03685 0000:3685 original=a5 runtime CFG evidence
    movsw
; @03686 0000:3686 original=03f3 runtime CFG evidence
    add si, bx
; @03688 0000:3688 original=a5 runtime CFG evidence
    movsw
; @03689 0000:3689 original=a5 runtime CFG evidence
    movsw
; @0368A 0000:368A original=03f3 runtime CFG evidence
    add si, bx
; @0368C 0000:368C original=a5 runtime CFG evidence
    movsw
; @0368D 0000:368D original=a5 runtime CFG evidence
    movsw
; @0368E 0000:368E original=03f3 runtime CFG evidence
    add si, bx
; @03690 0000:3690 original=a5 runtime CFG evidence
    movsw
; @03691 0000:3691 original=a5 runtime CFG evidence
    movsw
; @03692 0000:3692 original=03f3 runtime CFG evidence
    add si, bx
; @03694 0000:3694 original=a5 runtime CFG evidence
    movsw
; @03695 0000:3695 original=a5 runtime CFG evidence
    movsw
; @03696 0000:3696 original=03f3 runtime CFG evidence
    add si, bx
; @03698 0000:3698 original=a5 runtime CFG evidence
    movsw
; @03699 0000:3699 original=a5 runtime CFG evidence
    movsw
; @0369A 0000:369A original=03f3 runtime CFG evidence
    add si, bx
; @0369C 0000:369C original=2e8e1e9695 runtime CFG evidence
    mov ds, word ptr cs:[09596h]
; @036A1 0000:36A1 original=c3 runtime CFG evidence
    ret
; sub_0000_36A2
; @036A2 0000:36A2 original=8bda
    mov bx, dx
; @036A4 0000:36A4 original=b90d00
    mov cx, 0Dh
; @036A7 0000:36A7 original=2ea19a95
    mov ax, word ptr cs:[0959Ah]
; @036AB 0000:36AB original=813e50235f0e
    cmp word ptr ds:[02350h], 0E5Fh
; @036B1 0000:36B1 original=7204
    JB_SHORT loc_036B7
; @036B3 0000:36B3 original=2ea19c95
    mov ax, word ptr cs:[0959Ch]
; @036B7 0000:36B7 original=8ed8
    mov ds, ax
; @036B9 0000:36B9 original=51
    push cx
; @036BA 0000:36BA original=53
    push bx
; @036BB 0000:36BB original=2e8e069295
    mov es, word ptr cs:[09592h]
; @036C0 0000:36C0 original=268a1f
    mov bl, byte ptr es:[bx]
; @036C3 0000:36C3 original=fecb
    dec bl
; @036C5 0000:36C5 original=32ff
    xor bh, bh
; @036C7 0000:36C7 original=d1e3
    shl bx, 1
; @036C9 0000:36C9 original=81c3928d
    add bx, 08D92h
; @036CD 0000:36CD original=2e8b37
    mov si, word ptr cs:[bx]
; @036D0 0000:36D0 original=2e8e069895
    mov es, word ptr cs:[09598h]
; @036D5 0000:36D5 original=a5
    movsw
; @036D6 0000:36D6 original=a5
    movsw
; @036D7 0000:36D7 original=a5
    movsw
; @036D8 0000:36D8 original=a5
    movsw
; @036D9 0000:36D9 original=83c760
    add di, 060h
; @036DC 0000:36DC original=a5
    movsw
; @036DD 0000:36DD original=a5
    movsw
; @036DE 0000:36DE original=a5
    movsw
; @036DF 0000:36DF original=a5
    movsw
; @036E0 0000:36E0 original=83c760
    add di, 060h
; @036E3 0000:36E3 original=a5
    movsw
; @036E4 0000:36E4 original=a5
    movsw
; @036E5 0000:36E5 original=a5
    movsw
; @036E6 0000:36E6 original=a5
    movsw
; @036E7 0000:36E7 original=83c760
    add di, 060h
; @036EA 0000:36EA original=a5
    movsw
; @036EB 0000:36EB original=a5
    movsw
; @036EC 0000:36EC original=a5
    movsw
; @036ED 0000:36ED original=a5
    movsw
; @036EE 0000:36EE original=83c760
    add di, 060h
; @036F1 0000:36F1 original=a5
    movsw
; @036F2 0000:36F2 original=a5
    movsw
; @036F3 0000:36F3 original=a5
    movsw
; @036F4 0000:36F4 original=a5
    movsw
; @036F5 0000:36F5 original=83c760
    add di, 060h
; @036F8 0000:36F8 original=a5
    movsw
; @036F9 0000:36F9 original=a5
    movsw
; @036FA 0000:36FA original=a5
    movsw
; @036FB 0000:36FB original=a5
    movsw
; @036FC 0000:36FC original=83c760
    add di, 060h
; @036FF 0000:36FF original=a5
    movsw
; @03700 0000:3700 original=a5
    movsw
; @03701 0000:3701 original=a5
    movsw
; @03702 0000:3702 original=a5
    movsw
; @03703 0000:3703 original=83c760
    add di, 060h
; @03706 0000:3706 original=a5
    movsw
; @03707 0000:3707 original=a5
    movsw
; @03708 0000:3708 original=a5
    movsw
; @03709 0000:3709 original=a5
    movsw
; @0370A 0000:370A original=83c760
    add di, 060h
; @0370D 0000:370D original=a5
    movsw
; @0370E 0000:370E original=a5
    movsw
; @0370F 0000:370F original=a5
    movsw
; @03710 0000:3710 original=a5
    movsw
; @03711 0000:3711 original=83c760
    add di, 060h
; @03714 0000:3714 original=a5
    movsw
; @03715 0000:3715 original=a5
    movsw
; @03716 0000:3716 original=a5
    movsw
; @03717 0000:3717 original=a5
    movsw
; @03718 0000:3718 original=83c760
    add di, 060h
; @0371B 0000:371B original=a5
    movsw
; @0371C 0000:371C original=a5
    movsw
; @0371D 0000:371D original=a5
    movsw
; @0371E 0000:371E original=a5
    movsw
; @0371F 0000:371F original=83c760
    add di, 060h
; @03722 0000:3722 original=a5
    movsw
; @03723 0000:3723 original=a5
    movsw
; @03724 0000:3724 original=a5
    movsw
; @03725 0000:3725 original=a5
    movsw
; @03726 0000:3726 original=83c760
    add di, 060h
; @03729 0000:3729 original=a5
    movsw
; @0372A 0000:372A original=a5
    movsw
; @0372B 0000:372B original=a5
    movsw
; @0372C 0000:372C original=a5
    movsw
; @0372D 0000:372D original=83c760
    add di, 060h
; @03730 0000:3730 original=a5
    movsw
; @03731 0000:3731 original=a5
    movsw
; @03732 0000:3732 original=a5
    movsw
; @03733 0000:3733 original=a5
    movsw
; @03734 0000:3734 original=83c760
    add di, 060h
; @03737 0000:3737 original=a5
    movsw
; @03738 0000:3738 original=a5
    movsw
; @03739 0000:3739 original=a5
    movsw
; @0373A 0000:373A original=a5
    movsw
; @0373B 0000:373B original=83c760
    add di, 060h
; @0373E 0000:373E original=a5
    movsw
; @0373F 0000:373F original=a5
    movsw
; @03740 0000:3740 original=a5
    movsw
; @03741 0000:3741 original=a5
    movsw
; @03742 0000:3742 original=83c760
    add di, 060h
; @03745 0000:3745 original=81ef7806
    sub di, 0678h
; @03749 0000:3749 original=5b
    pop bx
; @0374A 0000:374A original=83c301
    add bx, 1
; @0374D 0000:374D original=59
    pop cx
; @0374E 0000:374E original=e202
    LOOP_SHORT loc_03752
; @03750 0000:3750 original=eb03
    JMP_SHORT loc_03755
; @03752 0000:3752 original=e964ff
    JMP_NEAR loc_036B9
; @03755 0000:3755 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0375A 0000:375A original=c3
    ret
; sub_0000_375B
; @0375B 0000:375B original=2ec70603590000
    mov word ptr cs:[05903h], 0
; @03762 0000:3762 original=2e8b3ef958
    mov di, word ptr cs:[058F9h]
; @03767 0000:3767 original=2e8b36fb58
    mov si, word ptr cs:[058FBh]
; @0376C 0000:376C original=2e8b0efd58
    mov cx, word ptr cs:[058FDh]
; @03771 0000:3771 original=2e8b2eff58
    mov bp, word ptr cs:[058FFh]
; @03776 0000:3776 original=d1e5
    shl bp, 1
; @03778 0000:3778 original=d1e5
    shl bp, 1
; @0377A 0000:377A original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @03780 0000:3780 original=7408
    JE_SHORT loc_0378A
; @03782 0000:3782 original=8bc5
    mov ax, bp
; @03784 0000:3784 original=49
    dec cx
; @03785 0000:3785 original=f7e1
    mul cx
; @03787 0000:3787 original=41
    inc cx
; @03788 0000:3788 original=03f0
    add si, ax
; @0378A 0000:378A original=51
    push cx
; @0378B 0000:378B original=2e8b0efd58
    mov cx, word ptr cs:[058FDh]
; @03790 0000:3790 original=2e2b0e0159
    sub cx, word ptr cs:[05901h]
; @03795 0000:3795 original=0bc9
    or cx, cx
; @03797 0000:3797 original=782d
    JS_SHORT loc_037C6
; @03799 0000:3799 original=d1e9
    shr cx, 1
; @0379B 0000:379B original=e329
    JCXZ_SHORT loc_037C6
; @0379D 0000:379D original=49
    dec cx
; @0379E 0000:379E original=e310
    JCXZ_SHORT loc_037B0
; @037A0 0000:37A0 original=81c70020
    add di, 02000h
; @037A4 0000:37A4 original=f7c70080
    test di, 08000h
; @037A8 0000:37A8 original=7404
    JE_SHORT loc_037AE
; @037AA 0000:37AA original=81c7a080
    add di, 080A0h
; @037AE 0000:37AE original=e2f0
    LOOP_SHORT loc_037A0
; @037B0 0000:37B0 original=32c0
    xor al, al
; @037B2 0000:37B2 original=8bcd
    mov cx, bp
; @037B4 0000:37B4 original=f3aa
    rep stosb
; @037B6 0000:37B6 original=2bfd
    sub di, bp
; @037B8 0000:37B8 original=81c70020
    add di, 02000h
; @037BC 0000:37BC original=f7c70080
    test di, 08000h
; @037C0 0000:37C0 original=7404
    JE_SHORT loc_037C6
; @037C2 0000:37C2 original=81c7a080
    add di, 080A0h
; @037C6 0000:37C6 original=59
    pop cx
; @037C7 0000:37C7 original=2ea10159
    mov ax, word ptr cs:[05901h]
; @037CB 0000:37CB original=2e3b06fd58
    cmp ax, word ptr cs:[058FDh]
; @037D0 0000:37D0 original=7427
    JE_SHORT loc_037F9
; @037D2 0000:37D2 original=2e01060359
    add word ptr cs:[05903h], ax
; @037D7 0000:37D7 original=2ea1fd58
    mov ax, word ptr cs:[058FDh]
; @037DB 0000:37DB original=2e3b060359
    cmp ax, word ptr cs:[05903h]
; @037E0 0000:37E0 original=7712
    JA_SHORT loc_037F4
; @037E2 0000:37E2 original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @037E8 0000:37E8 original=7404
    JE_SHORT loc_037EE
; @037EA 0000:37EA original=2bf5
    sub si, bp
; @037EC 0000:37EC original=eb02
    JMP_SHORT loc_037F0
; @037EE 0000:37EE original=03f5
    add si, bp
; @037F0 0000:37F0 original=e2d5
    LOOP_SHORT loc_037C7
; @037F2 0000:37F2 original=eb29
    JMP_SHORT loc_0381D
; @037F4 0000:37F4 original=2e29060359
    sub word ptr cs:[05903h], ax
; @037F9 0000:37F9 original=51
    push cx
; @037FA 0000:37FA original=8bcd
    mov cx, bp
; @037FC 0000:37FC original=f3a4
    rep movsb
; @037FE 0000:37FE original=2bfd
    sub di, bp
; @03800 0000:3800 original=81c70020
    add di, 02000h
; @03804 0000:3804 original=f7c70080
    test di, 08000h
; @03808 0000:3808 original=7404
    JE_SHORT loc_0380E
; @0380A 0000:380A original=81c7a080
    add di, 080A0h
; @0380E 0000:380E original=2e833e055900
    cmp word ptr cs:[05905h], 0
; @03814 0000:3814 original=7404
    JE_SHORT loc_0381A
; @03816 0000:3816 original=2bf5
    sub si, bp
; @03818 0000:3818 original=2bf5
    sub si, bp
; @0381A 0000:381A original=59
    pop cx
; @0381B 0000:381B original=e2aa
    LOOP_SHORT loc_037C7
; @0381D 0000:381D original=32c0
    xor al, al
; @0381F 0000:381F original=8bcd
    mov cx, bp
; @03821 0000:3821 original=f3aa
    rep stosb
; @03823 0000:3823 original=c3
    ret
; sub_0000_3824
; @03824 0000:3824 original=2e8e1e9895
    mov ds, word ptr cs:[09598h]
; @03829 0000:3829 original=b95000
    mov cx, 050h
; @0382C 0000:382C original=f3a5
    rep movsw
; @0382E 0000:382E original=81efa000
    sub di, 0A0h
; @03832 0000:3832 original=81c70020
    add di, 02000h
; @03836 0000:3836 original=f7c70080
    test di, 08000h
; @0383A 0000:383A original=7404
    JE_SHORT loc_03840
; @0383C 0000:383C original=81c7a080
    add di, 080A0h
; @03840 0000:3840 original=4d
    dec bp
; @03841 0000:3841 original=75e6
    JNE_SHORT loc_03829
; @03843 0000:3843 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @03848 0000:3848 original=c3
    ret
; @03849 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h
; @03859 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h
; @03869 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,083h,0C7h,02Ch,0E2h,0D3h,02Eh,08Eh,01Eh
; @03879 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh
; @03889 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h
; @03899 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h
; @038A9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C7h,02h,083h,0C7h,02Ch,0E2h,0CBh,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,026h
; @038B9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,0ADh,026h,023h,05h,0Bh,04h,083h,0C6h
; @038C9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0ABh,083h,0C7h,030h,0E2h,0E7h,02Eh,08Eh,01Eh,096h,095h,0C3h,0ADh,0F7h,0D0h
; @038D9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,05h,083h,0C6h,02h,083h,0C7h,02h,0ADh,0F7h,0D0h,026h,09h,05h,083h
; @038E9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,02h,083h,0C7h,02h,083h,0C7h,030h,0E2h,0E3h,02Eh,08Eh,01Eh,096h,095h,0C3h
; @038F9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,026h,023h,05h,0Bh,04h,083h,0C6h,02h,0ABh,083h,0C7h,032h,0E2h,0F1h,02Eh
; @03909 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,096h,095h,0C3h,0ADh,0F7h,0D0h,026h,09h,05h,083h,0C6h,02h,083h,0C7h
; @03919 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,083h,0C7h,032h,0E2h,0EFh,02Eh,08Eh,01Eh,096h,095h,0C3h,00h,08Bh,01Ch,08Bh
; @03929 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,04h,08Bh,04Ch,08h,08Bh,054h,0Ch,02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h
; @03939 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh
; @03949 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h
; @03959 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,021h,01Dh,026h,021h,045h
; @03969 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h,025h,039h,026h,020h,045h
; @03979 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh,054h,0Eh,02Eh,0C6h,06h
; @03989 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
; @03999 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
; @039A9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh
; @039B9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h
; @039C9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h,0E9h,04Dh,0FFh
; @039D9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,08Bh,04Ch,08h,08Bh,054h
; @039E9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
; @039F9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh
; @03A09 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h
; @03A19 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh
; @03A29 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
; @03A39 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h
; @03A49 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,01Dh,026h,021h,045h,02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h
; @03A59 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,039h,026h,020h,045h,08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh
; @03A69 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,0Eh,02Eh,0C6h,06h,025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
; @03A79 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h
; @03A89 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
; @03A99 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
; @03AA9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
; @03AB9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh,026h
; @03AC9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h,026h
; @03AD9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h,0E9h,0F7h,0FEh,02Eh
; @03AE9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,08Bh,04Ch,08h,08Bh,054h,0Ch
; @03AF9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,0C6h,06h,025h,039h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
; @03B09 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h
; @03B19 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
; @03B29 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
; @03B39 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h
; @03B49 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0F9h,0D0h
; @03B59 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh
; @03B69 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,01Eh,025h,039h,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h
; @03B79 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,021h,01Dh,026h,021h,045h
; @03B89 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,026h,021h,04Dh,04h,026h,021h,055h,06h,02Eh,0A0h,025h,039h,026h,020h,045h
; @03B99 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,08Bh,05Ch,02h,08Bh,044h,06h,08Bh,04Ch,0Ah,08Bh,054h,0Eh,02Eh,0C6h,06h
; @03BA9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
; @03BB9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
; @03BC9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h
; @03BD9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh
; @03BE9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
; @03BF9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
; @03C09 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh
; @03C19 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
; @03C29 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 039h,026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h
; @03C39 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h
; @03C49 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0A1h,0FEh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h
; @03C59 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0F7h,0D0h,08Bh,04Ch,08h,0F7h,0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h
; @03C69 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h
; @03C79 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
; @03C89 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,026h,09h,01Dh
; @03C99 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh,0A0h,025h,039h
; @03CA9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,075h,09Dh,02Eh,08Eh,01Eh
; @03CB9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h,08Bh,04Ch,08h,0F7h
; @03CC9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h,025h,039h,00h,0D0h,0EBh,0D0h,0DFh
; @03CD9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
; @03CE9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h
; @03CF9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h
; @03D09 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h
; @03D19 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h
; @03D29 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh
; @03D39 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h
; @03D49 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,070h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h
; @03D59 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F7h,0D0h,08Bh,04Ch,08h,0F7h,0D1h,08Bh,054h,0Ch,0F7h,0D2h,02Eh,0C6h,06h,025h
; @03D69 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 039h,00h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh
; @03D79 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
; @03D89 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh
; @03D99 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h
; @03DA9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h
; @03DB9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0D9h
; @03DC9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h,0D0h,0EBh,0D0h,0DFh,0D0h
; @03DD9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,0D0h,0D9h,0D0h,0DDh,0D0h,0DAh,0D0h,0DEh,02Eh,0D0h,01Eh,025h,039h
; @03DE9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,01Dh,026h,09h,045h,02h,026h,09h,04Dh,04h,026h,09h,055h,06h,02Eh
; @03DF9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,025h,039h,026h,08h,045h,08h,083h,0C6h,010h,083h,0C7h,034h,04Dh,074h,03h
; @03E09 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,046h,0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh
; @03E19 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh
; @03E29 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h,045h,02h,026h,020h,055h
; @03E39 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h
; @03E49 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh
; @03E59 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,09h,045h,02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,075h
; @03E69 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A8h,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh,0F9h,0D0h
; @03E79 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
; @03E89 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
; @03E99 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h,045h
; @03EA9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,026h,020h,055h,04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh,0D0h
; @03EB9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h
; @03EC9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h
; @03ED9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h,08h,055h,04h
; @03EE9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0C6h,08h,083h,0C7h,034h,04Dh,074h,03h,0E9h,07Bh,0FFh,02Eh,08Eh,01Eh,096h
; @03EF9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0C3h,08Bh,01Ch,08Bh,044h,04h,0B2h,0FFh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h
; @03F09 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h
; @03F19 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h
; @03F29 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D0h,0DCh,0D0h,0DAh,0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
; @03F39 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F9h,0D0h,0DBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,021h,01Dh,026h,021h
; @03F49 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,02h,026h,020h,055h,04h,08Bh,05Ch,02h,08Bh,044h,06h,032h,0D2h,0D0h,0EBh
; @03F59 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
; @03F69 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh
; @03F79 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh
; @03F89 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h
; @03F99 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,026h,08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,074h,03h,0E9h,051h
; @03FA9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,02Eh,08Eh,01Eh,096h,095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h
; @03FB9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B2h,0FFh,0F6h,0D2h,0D0h,0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,0D0h,0EBh
; @03FC9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D0h,0DFh,0D0h,0D8h,0D0h,0DCh,0D0h,0DAh,026h,09h,01Dh,026h,09h,045h,02h,026h
; @03FD9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,055h,04h,083h,0C6h,08h,083h,0C7h,034h,04Dh,075h,0CBh,02Eh,08Eh,01Eh,096h
; @03FE9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 095h,0C3h,08Bh,01Ch,0F7h,0D3h,08Bh,044h,04h,0F7h,0D0h,0B2h,0FFh,0F6h,0D2h,0D0h
; @03FF9 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,0D0h,0DFh,0D0h,0D8h,0D0h,0DCh
part01 ends
end
