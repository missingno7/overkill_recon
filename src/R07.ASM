; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part07 segment byte public 'CODE'
assume cs:part07,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
loc_0FC62 equ 01C62h
loc_0FC6E equ 01C6Eh
loc_0FC7C equ 01C7Ch
loc_0FCC0 equ 01CC0h
loc_0FCC5 equ 01CC5h
loc_0FCD2 equ 01CD2h
loc_0FCDF equ 01CDFh
loc_0FCEC equ 01CECh
loc_0FCF8 equ 01CF8h
loc_0FD01 equ 01D01h
loc_0FD12 equ 01D12h
loc_0FD5B equ 01D5Bh
loc_0FD72 equ 01D72h
loc_0FD81 equ 01D81h
loc_0FD8D equ 01D8Dh
loc_0FDA3 equ 01DA3h
loc_0FDA5 equ 01DA5h
loc_0FDD2 equ 01DD2h
loc_0FE01 equ 01E01h
loc_0FE08 equ 01E08h
loc_0FE35 equ 01E35h
loc_0FE64 equ 01E64h
loc_0FE69 equ 01E69h
loc_0FE75 equ 01E75h
loc_0FE76 equ 01E76h
loc_0FE89 equ 01E89h
loc_0FA91 equ 01A91h
loc_0FA9A equ 01A9Ah
loc_0FAA3 equ 01AA3h
loc_0FAAC equ 01AACh
loc_0FAB5 equ 01AB5h
loc_0FAC8 equ 01AC8h
loc_0FAD8 equ 01AD8h
loc_0FAF9 equ 01AF9h
loc_0FB06 equ 01B06h
loc_0FB16 equ 01B16h
loc_0FB38 equ 01B38h
loc_0FB58 equ 01B58h
loc_0FB60 equ 01B60h
loc_0FB90 equ 01B90h
loc_0FB96 equ 01B96h
loc_0FBAB equ 01BABh
loc_0FBCB equ 01BCBh
loc_0FBD6 equ 01BD6h
loc_0FC12 equ 01C12h
loc_0FC22 equ 01C22h
loc_0FC38 equ 01C38h
loc_05DB2 equ 07DB2h
loc_0ECEC equ 0CECh
loc_0ECF2 equ 0CF2h
loc_0ED15 equ 0D15h
loc_0ED26 equ 0D26h
loc_0ED35 equ 0D35h
loc_0ED4D equ 0D4Dh
loc_0ED68 equ 0D68h
loc_0ED7A equ 0D7Ah
loc_0ED95 equ 0D95h
loc_0ED97 equ 0D97h
loc_0EDCE equ 0DCEh
loc_0EDCF equ 0DCFh
loc_0EDDA equ 0DDAh
loc_0EDE9 equ 0DE9h
loc_0EDF7 equ 0DF7h
loc_0EE03 equ 0E03h
loc_0F797 equ 01797h
loc_0F7A9 equ 017A9h
loc_0F7BB equ 017BBh
loc_0F7E4 equ 017E4h
loc_0F86E equ 0186Eh
loc_0F89D equ 0189Dh
loc_0F89E equ 0189Eh
loc_0F8AB equ 018ABh
loc_0F8AC equ 018ACh
loc_0F8B9 equ 018B9h
loc_0F8BA equ 018BAh
loc_0F8C7 equ 018C7h
loc_0F8C8 equ 018C8h
loc_0F8D5 equ 018D5h
loc_0F8D6 equ 018D6h
loc_0F8E3 equ 018E3h
loc_0F8E4 equ 018E4h
loc_0F90A equ 0190Ah
loc_0F90B equ 0190Bh
loc_0F931 equ 01931h
loc_0F932 equ 01932h
loc_0F94D equ 0194Dh
loc_0F952 equ 01952h
loc_0F968 equ 01968h
loc_0F976 equ 01976h
loc_0F979 equ 01979h
loc_0F99C equ 0199Ch
loc_0F9B1 equ 019B1h
loc_0FA3B equ 01A3Bh
loc_0FA43 equ 01A43h
loc_10044 equ 02044h
loc_10108 equ 02108h
; @0E000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E0A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E0B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E0C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E0D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E0E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E0F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E1A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E1B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E1C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E1D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E1E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E1F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E2A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E2B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E2C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E2D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E2E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E2F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E3A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E3B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E3C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E3D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E3E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E3F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E4A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E4B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E4C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E4D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E4E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E4F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E5A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E5B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E5C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E5D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E5E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E5F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E6A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E6B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E6C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E6D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E6E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E6F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E7A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E7B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E7C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E7D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E7E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E7F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E8A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E8B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E8C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E8D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E8E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E8F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E9A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E9B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E9C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E9D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E9E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0E9F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EA90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EAA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EAB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EAC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EAD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EAE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EAF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EB90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EBA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EBB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EBC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EBD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EBE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EBF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0EC90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0ECA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0ECB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @0ECC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h
; sub_0000_ECC9
; @0ECC9 0000:ECC9 original=1e
    push ds
; @0ECCA 0000:ECCA original=0e
    push cs
; @0ECCB 0000:ECCB original=1f
    pop ds
; @0ECCC 0000:ECCC original=2e8b1e66d6
    mov bx, word ptr cs:[0D666h]
; @0ECD1 0000:ECD1 original=b90004
    mov cx, 0400h
; @0ECD4 0000:ECD4 original=b8003f
    mov ax, 03F00h
; @0ECD7 0000:ECD7 original=bab8d8
    mov dx, 0D8B8h
; @0ECDA 0000:ECDA original=cd21
    int 021h
; @0ECDC 0000:ECDC original=720e
    JB_SHORT loc_0ECEC
; @0ECDE 0000:ECDE original=e81100
    CALL_NEAR loc_0ECF2
; @0ECE1 0000:ECE1 original=b8003e
    mov ax, 03E00h
; @0ECE4 0000:ECE4 original=2e8b1e66d6
    mov bx, word ptr cs:[0D666h]
; @0ECE9 0000:ECE9 original=cd21
    int 021h
; @0ECEB 0000:ECEB original=f8
    clc
; @0ECEC 0000:ECEC original=1f
    pop ds
; @0ECED 0000:ECED original=c3
    ret
; @0ECEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h
; sub_0000_ECF2
; @0ECF2 0000:ECF2 original=06
    push es
; @0ECF3 0000:ECF3 original=2ec706e5ed0000
    mov word ptr cs:[0EDE5h], 0
; @0ECFA 0000:ECFA original=2ec706e7ed0000
    mov word ptr cs:[0EDE7h], 0
; @0ED01 0000:ED01 original=2ec43eeeec
    les di, dword ptr cs:[0ECEEh]
; @0ED06 0000:ED06 original=2ec60604ee00
    mov byte ptr cs:[0EE04h], 0
; @0ED0C 0000:ED0C original=be0000
    mov si, 0
; @0ED0F 0000:ED0F original=bd0000
    mov bp, 0
; @0ED12 0000:ED12 original=b9f707
    mov cx, 07F7h
; @0ED15 0000:ED15 original=2ec786b8dc0000
    mov word ptr cs:[bp - 02348h], 0
; @0ED1C 0000:ED1C original=45
    inc bp
; @0ED1D 0000:ED1D original=45
    inc bp
; @0ED1E 0000:ED1E original=e2f5
    LOOP_SHORT loc_0ED15
; @0ED20 0000:ED20 original=bdee0f
    mov bp, 0FEEh
; @0ED23 0000:ED23 original=ba0000
    mov dx, 0
; @0ED26 0000:ED26 original=d1ea
    shr dx, 1
; @0ED28 0000:ED28 original=f7c20001
    test dx, 0100h
; @0ED2C 0000:ED2C original=7507
    JNE_SHORT loc_0ED35
; @0ED2E 0000:ED2E original=e86600
    CALL_NEAR loc_0ED97
; @0ED31 0000:ED31 original=8ad0
    mov dl, al
; @0ED33 0000:ED33 original=b6ff
    mov dh, 0FFh
; @0ED35 0000:ED35 original=f7c20100
    test dx, 1
; @0ED39 0000:ED39 original=7412
    JE_SHORT loc_0ED4D
; @0ED3B 0000:ED3B original=e85900
    CALL_NEAR loc_0ED97
; @0ED3E 0000:ED3E original=e8a800
    CALL_NEAR loc_0EDE9
; @0ED41 0000:ED41 original=2e8886b8dc
    mov byte ptr cs:[bp - 02348h], al
; @0ED46 0000:ED46 original=45
    inc bp
; @0ED47 0000:ED47 original=81e5ff0f
    and bp, 0FFFh
; @0ED4B 0000:ED4B original=ebd9
    JMP_SHORT loc_0ED26
; @0ED4D 0000:ED4D original=e84700
    CALL_NEAR loc_0ED97
; @0ED50 0000:ED50 original=8ae0
    mov ah, al
; @0ED52 0000:ED52 original=e84200
    CALL_NEAR loc_0ED97
; @0ED55 0000:ED55 original=86c4
    xchg al, ah
; @0ED57 0000:ED57 original=3d0000
    cmp ax, 0
; @0ED5A 0000:ED5A original=750c
    JNE_SHORT loc_0ED68
; @0ED5C 0000:ED5C original=e83800
    CALL_NEAR loc_0ED97
; @0ED5F 0000:ED5F original=3c00
    cmp al, 0
; @0ED61 0000:ED61 original=7432
    JE_SHORT loc_0ED95
; @0ED63 0000:ED63 original=e87400
    CALL_NEAR loc_0EDDA
; @0ED66 0000:ED66 original=b000
    mov al, 0
; @0ED68 0000:ED68 original=8acc
    mov cl, ah
; @0ED6A 0000:ED6A original=d0ec
    shr ah, 1
; @0ED6C 0000:ED6C original=d0ec
    shr ah, 1
; @0ED6E 0000:ED6E original=d0ec
    shr ah, 1
; @0ED70 0000:ED70 original=d0ec
    shr ah, 1
; @0ED72 0000:ED72 original=80e10f
    and cl, 0Fh
; @0ED75 0000:ED75 original=8bd8
    mov bx, ax
; @0ED77 0000:ED77 original=80c103
    add cl, 3
; @0ED7A 0000:ED7A original=2e8a87b8dc
    mov al, byte ptr cs:[bx - 02348h]
; @0ED7F 0000:ED7F original=e86700
    CALL_NEAR loc_0EDE9
; @0ED82 0000:ED82 original=2e8886b8dc
    mov byte ptr cs:[bp - 02348h], al
; @0ED87 0000:ED87 original=43
    inc bx
; @0ED88 0000:ED88 original=81e3ff0f
    and bx, 0FFFh
; @0ED8C 0000:ED8C original=45
    inc bp
; @0ED8D 0000:ED8D original=81e5ff0f
    and bp, 0FFFh
; @0ED91 0000:ED91 original=e2e7
    LOOP_SHORT loc_0ED7A
; @0ED93 0000:ED93 original=eb91
    JMP_SHORT loc_0ED26
; @0ED95 0000:ED95 original=07
    pop es
; @0ED96 0000:ED96 original=c3
    ret
; sub_0000_ED97
; @0ED97 0000:ED97 original=2ef60604eeff
    test byte ptr cs:[0EE04h], 0FFh
; @0ED9D 0000:ED9D original=7530
    JNE_SHORT loc_0EDCF
; @0ED9F 0000:ED9F original=81c6b8d8
    add si, 0D8B8h
; @0EDA3 0000:EDA3 original=ac
    lodsb
; @0EDA4 0000:EDA4 original=81eeb8d8
    sub si, 0D8B8h
; @0EDA8 0000:EDA8 original=81e6ff03
    and si, 03FFh
; @0EDAC 0000:EDAC original=7520
    JNE_SHORT loc_0EDCE
; @0EDAE 0000:EDAE original=9c
    pushf
; @0EDAF 0000:EDAF original=50
    push ax
; @0EDB0 0000:EDB0 original=53
    push bx
; @0EDB1 0000:EDB1 original=51
    push cx
; @0EDB2 0000:EDB2 original=52
    push dx
; @0EDB3 0000:EDB3 original=56
    push si
; @0EDB4 0000:EDB4 original=57
    push di
; @0EDB5 0000:EDB5 original=55
    push bp
; @0EDB6 0000:EDB6 original=bab8d8
    mov dx, 0D8B8h
; @0EDB9 0000:EDB9 original=b8003f
    mov ax, 03F00h
; @0EDBC 0000:EDBC original=2e8b1e66d6
    mov bx, word ptr cs:[0D666h]
; @0EDC1 0000:EDC1 original=b90004
    mov cx, 0400h
; @0EDC4 0000:EDC4 original=cd21
    int 021h
; @0EDC6 0000:EDC6 original=5d
    pop bp
; @0EDC7 0000:EDC7 original=5f
    pop di
; @0EDC8 0000:EDC8 original=5e
    pop si
; @0EDC9 0000:EDC9 original=5a
    pop dx
; @0EDCA 0000:EDCA original=59
    pop cx
; @0EDCB 0000:EDCB original=5b
    pop bx
; @0EDCC 0000:EDCC original=58
    pop ax
; @0EDCD 0000:EDCD original=9d
    popf
; @0EDCE 0000:EDCE original=c3
    ret
; @0EDCF 0000:EDCF original=2ea005ee
    mov al, byte ptr cs:[0EE05h]
; @0EDD3 0000:EDD3 original=2ec60604ee00
    mov byte ptr cs:[0EE04h], 0
; @0EDD9 0000:EDD9 original=c3
    ret
; sub_0000_EDDA
; @0EDDA 0000:EDDA original=2ec60604ee01
    mov byte ptr cs:[0EE04h], 1
; @0EDE0 0000:EDE0 original=2ea205ee
    mov byte ptr cs:[0EE05h], al
; @0EDE4 0000:EDE4 original=c3
    ret
; @0EDE5 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h
; sub_0000_EDE9
; @0EDE9 0000:EDE9 original=aa
    stosb
; @0EDEA 0000:EDEA original=0bff
    or di, di
; @0EDEC 0000:EDEC original=7509
    JNE_SHORT loc_0EDF7
; @0EDEE 0000:EDEE original=50
    push ax
; @0EDEF 0000:EDEF original=8cc0
    mov ax, es
; @0EDF1 0000:EDF1 original=050010
    add ax, 01000h
; @0EDF4 0000:EDF4 original=8ec0
    mov es, ax
; @0EDF6 0000:EDF6 original=58
    pop ax
; @0EDF7 0000:EDF7 original=2eff06e5ed
    inc word ptr cs:[0EDE5h]
; @0EDFC 0000:EDFC original=7505
    JNE_SHORT loc_0EE03
; @0EDFE 0000:EDFE original=2eff06e7ed
    inc word ptr cs:[0EDE7h]
; @0EE03 0000:EE03 original=c3
    ret
; @0EE04 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0E1h,00h,065h,04Eh,0E2h,00h,065h,04Eh,0E3h,00h,065h,04Eh,0E4h,00h
; @0EE14 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0E5h,00h,065h,04Eh,0E6h,00h,065h,04Eh,0E7h,00h,065h,04Eh,0E8h,00h
; @0EE24 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0E9h,00h,065h,04Eh,0EAh,00h,065h,04Eh,0EBh,00h,065h,04Eh,0ECh,00h
; @0EE34 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0EDh,00h,065h,04Eh,0EEh,00h,065h,04Eh,0EFh,00h,065h,04Eh,0F0h,00h
; @0EE44 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0F1h,00h,065h,04Eh,0F2h,00h,065h,04Eh,0F3h,00h,065h,04Eh,0F4h,00h
; @0EE54 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0F5h,00h,065h,04Eh,0F6h,00h,065h,04Eh,0F7h,00h,065h,04Eh,0F8h,00h
; @0EE64 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0F9h,00h,065h,04Eh,0FFh,0FFh,04h,00h,065h,04Eh,07h,00h,065h,04Eh
; @0EE74 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C9h,00h,05Fh,04Eh,0FFh,0FFh,0C4h,00h,065h,04Eh,05Ah,00h,065h,04Eh,0FFh,0FFh
; @0EE84 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CEh,00h,065h,04Eh,0CFh,00h,065h,04Eh,0D0h,00h,065h,04Eh,0D1h,00h,065h,04Eh
; @0EE94 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,00h,065h,04Eh,0D3h,00h,065h,04Eh,0D4h,00h,065h,04Eh,0D5h,00h,065h,04Eh
; @0EEA4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D6h,00h,065h,04Eh,0D7h,00h,065h,04Eh,0D8h,00h,065h,04Eh,0D9h,00h,065h,04Eh
; @0EEB4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,00h,065h,04Eh,0DBh,00h,065h,04Eh,0DCh,00h,065h,04Eh,0DDh,00h,065h,04Eh
; @0EEC4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DEh,00h,065h,04Eh,0DFh,00h,065h,04Eh,0E0h,00h,065h,04Eh,0E1h,00h,065h,04Eh
; @0EED4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,00h,065h,04Eh,0E3h,00h,065h,04Eh,0E4h,00h,065h,04Eh,0E5h,00h,065h,04Eh
; @0EEE4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E6h,00h,065h,04Eh,0E7h,00h,065h,04Eh,0E8h,00h,065h,04Eh,0E9h,00h,065h,04Eh
; @0EEF4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0C9h,00h,05Fh,04Eh,0CEh,00h,065h,04Eh,0CFh,00h,065h,04Eh,0D0h,00h
; @0EF04 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0D1h,00h,065h,04Eh,0D2h,00h,065h,04Eh,0D3h,00h,065h,04Eh,0D4h,00h
; @0EF14 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0D5h,00h,065h,04Eh,0D6h,00h,065h,04Eh,0D7h,00h,065h,04Eh,0D8h,00h
; @0EF24 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0D9h,00h,065h,04Eh,0DAh,00h,065h,04Eh,0DBh,00h,065h,04Eh,0DCh,00h
; @0EF34 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0DDh,00h,065h,04Eh,0DEh,00h,065h,04Eh,0DFh,00h,065h,04Eh,0E0h,00h
; @0EF44 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,04Eh,0FFh,0FFh,0D7h,00h,065h,04Eh,0D8h,00h,065h,04Eh,0D9h,00h,065h,04Eh
; @0EF54 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,00h,065h,04Eh,0DBh,00h,065h,04Eh,0DCh,00h,065h,04Eh,0DDh,00h,065h,04Eh
; @0EF64 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DEh,00h,065h,04Eh,0DFh,00h,065h,04Eh,0E0h,00h,065h,04Eh,0E1h,00h,065h,04Eh
; @0EF74 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E2h,00h,065h,04Eh,0E3h,00h,065h,04Eh,0E4h,00h,065h,04Eh,0E5h,00h,065h,04Eh
; @0EF84 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E6h,00h,065h,04Eh,0E7h,00h,065h,04Eh,0E8h,00h,065h,04Eh,0E9h,00h,065h,04Eh
; @0EF94 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EAh,00h,065h,04Eh,0EBh,00h,065h,04Eh,0ECh,00h,065h,04Eh,0EDh,00h,065h,04Eh
; @0EFA4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EEh,00h,065h,04Eh,0EFh,00h,065h,04Eh,0FFh,0FFh
; @0EFAE 0000:EFAE original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @0EFB1 0000:EFB1 original=a3fed1 runtime CFG evidence
    mov word ptr ds:[0D1FEh], ax
; @0EFB4 0000:EFB4 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0EFB7 0000:EFB7 original=a300d2 runtime CFG evidence
    mov word ptr ds:[0D200h], ax
; @0EFBA 0000:EFBA original=8b5e18 runtime CFG evidence
    mov bx, word ptr ss:[bp + 018h]
; @0EFBD 0000:EFBD original=d1e3 runtime CFG evidence
    shl bx, 1
; @0EFBF 0000:EFBF original=2effa7c4ef runtime CFG evidence
    jmp word ptr cs:[bx - 0103Ch]
; @0EFC4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,0BCh,03Ch,0BEh,0D8h,0AEh,0D8h,0AEh,0BFh,0AEh,07Dh,0AEh,02Ch,0AEh,0DFh,0ADh
; @0EFD4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D9h,0ADh,0EFh,0ADh,0B0h,0B1h,04Dh,0B2h,09h,0AEh,045h,0BCh,045h,0BCh,0F2h,0ADh
; @0EFE4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BCh,0B2h,0C3h,0B2h,0CDh,0B2h,04Fh,08Dh,0F0h,0B9h,04Fh,08Dh,030h,0B9h,030h,0B9h
; @0EFF4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ch,0B9h,0F0h,0BAh,0D4h,0BAh,0C7h,0BAh,04Fh,08Dh,06Dh,0B8h,09h,0B9h,04Fh,08Dh
; @0F004 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0B7h,056h,0B5h,0DFh,0B3h,090h,0B6h,048h,082h,065h,082h,02h,083h,05Dh,083h
; @0F014 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,086h,021h,087h,076h,086h,015h,087h,0Eh,0B7h,0AFh,087h,0DAh,087h,020h,088h
; @0F024 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 051h,088h,0AAh,088h,0B6h,088h,0CFh,088h,0E8h,088h,0DFh,0B3h,0CCh,0B3h,082h,089h
; @0F034 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,089h,023h,08Ah,055h,08Ah,07Eh,08Ah,0A4h,08Ah,0C7h,08Ah,0DDh,08Ah,0F6h,08Ah
; @0F044 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,08Bh,0C8h,08Bh,0F8h,08Bh,0D0h,08Bh,0D8h,08Bh,0E0h,08Bh,028h,08Ch,031h,08Ch
; @0F054 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,08Dh,03Ah,08Ch,0E8h,08Bh,06Dh,08Ch,094h,08Ch,0C2h,08Ch,0F6h,08Ch,0Ah,08Dh
; @0F064 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,0D2h,0F0h,08Bh,023h,08Dh,026h,08Dh,085h,0F1h,0D7h,0F1h,094h,0F1h,01h,0F2h
; @0F074 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0F2h,025h,0F2h,068h,0F2h,0C0h,0F2h,0CFh,0F2h,0DBh,0F2h,0EBh,0F2h,04Dh,0F3h
; @0F084 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,087h,094h,0F3h,0BBh,0F3h,0B3h,0F4h,0FEh,0F4h,092h,0F4h,010h,0F5h,01Dh,0F5h
; @0F094 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F9h,08Ah,080h,08Bh,075h,0F1h,02Ah,0F5h,054h,0F5h,03Fh,0F5h,01Bh,0F3h,0A3h,0F5h
; @0F0A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BFh,0F5h,0A7h,087h,0DCh,0F5h,0F7h,0F5h,019h,0F6h,029h,0F7h,058h,0F7h,05Dh,0F7h
; @0F0B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 062h,0F7h,076h,0F7h,0Ch,087h,047h,08Dh,07h,087h,04Fh,08Dh,04Fh,08Dh,073h,08Dh
; @0F0C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Bh,08Dh,057h,08Dh,045h,0BCh,0E9h,089h,069h,0F6h,039h,0F6h,0EEh,0F0h,0ACh,0F1h
; @0F0D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,0F1h,0A6h,0B2h,01Fh,08Ch,088h,0BBh,080h,0BBh,040h,0BBh,048h,0BBh,069h,087h
; @0F0E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 082h,082h,091h,082h,0F0h,0F6h,05Fh,08Dh,045h,0BCh,08Bh,01Eh,02Eh,023h,0D1h,0EBh
; @0F0F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0E3h,0BEh,02h,0D2h,083h,07Eh,06h,06h,074h
; @0F104 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0BEh,0Ah,0D2h,08Bh,0C3h,08Bh,018h,089h,05Eh,08h,03Dh,04h,00h,074h,03h
; @0F114 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,02Eh,0CBh,083h,03Eh,02Eh,023h,026h,074h,03h,0E9h,024h,0CBh,0E8h,0D0h,090h
; @0F124 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FBh,0FFh,075h,03h,0E9h,019h,0CBh,0E8h,0B3h,083h,0C7h,047h,08h,0CBh,00h
; @0F134 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,018h,060h,00h,0E9h,09h,0CBh,081h,07Eh,02h,080h,00h,073h,03h,0E9h
; @0F144 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0CAh,08Bh,01Eh,02Eh,023h,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0E3h
; @0F154 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BEh,012h,0D2h,083h,07Eh,06h,06h,074h,03h,0BEh,01Ah,0D2h,08Bh,0C3h,08Bh,018h
; @0F164 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,05Eh,08h,03Dh,04h,00h,074h,03h,0E9h,0D6h,0CAh,0E8h,0C5h,0D0h,0E9h,0D0h
; @0F174 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CAh,083h,07Eh,02h,050h,074h,03h,0E9h,0C7h,0CAh,0C7h,046h,018h,056h,00h,0EBh
; @0F184 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Fh,081h,07Eh,02h,0B0h,00h,074h,03h,0E9h,0B6h,0CAh,0C7h,046h,018h,056h,00h
; @0F194 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,041h,0BEh,075h,0Dh,0E8h,03Ch,0BEh,075h,08h,0E8h,037h,0BEh,075h,03h,0E9h
; @0F1A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Fh,0CAh,0E8h,01Eh,0CEh,0E9h,099h,0CAh,08Bh,01Eh,02Eh,023h,0D1h,0EBh,0D1h,0EBh
; @0F1B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,0EBh,08Bh,0CBh,0D1h,0E3h,081h,0C3h,0C2h,096h,08Bh,01Fh,081h,0C3h,0DDh,00h
; @0F1C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,05Eh,08h,083h,07Eh,04h,060h,073h,03h,0E9h,0BCh,095h,083h,046h,08h,03h
; @0F1D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0B5h,095h,083h,07Eh,06h,04h,074h,014h,0C7h,046h,08h,073h,00h,081h,07Eh
; @0F1E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0B0h,00h,074h,03h,0E9h,059h,0CAh,0C7h,046h,06h,04h,00h,0A1h,028h,023h
; @0F1F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,077h,00h,089h,046h,08h,083h,046h,02h,04h,0E9h,04Ah,0CAh,081h,07Eh,02h
; @0F204 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,073h,03h,0E9h,03Ah,0CAh,075h,03h,0E8h,011h,00h,0E8h,0C5h,0BDh,0E8h
; @0F214 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,0BDh,075h,03h,0E9h,02Ah,0CAh,0E9h,0A9h,0CDh,0E9h,0E2h,0C8h,0FFh,046h,08h
; @0F224 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,046h,08h,048h,01h,083h,03Eh,056h,023h,00h,074h,018h,083h,03Eh,056h
; @0F234 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,06h,074h,011h,0C7h,046h,08h,074h,01h,083h,03Eh,056h,023h,04h,074h,05h
; @0F244 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,08h,0E3h,00h,081h,07Eh,02h,080h,00h,07Fh,03h,0E9h,0F2h,0C9h,0A1h
; @0F254 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,023h,01h,046h,08h,081h,07Eh,02h,0C0h,00h,07Fh,03h,0E9h,0E2h,0C9h,0C7h
; @0F264 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,018h,05Ah,00h,0C7h,046h,08h,048h,01h,083h,03Eh,056h,023h,00h,074h,018h
; @0F274 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,06h,074h,011h,0C7h,046h,08h,074h,01h,083h,03Eh,056h,023h
; @0F284 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,074h,05h,0C7h,046h,08h,0E3h,00h,0A1h,026h,023h,01h,046h,08h,0E8h,043h
; @0F294 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BDh,075h,01Ah,0E8h,03Eh,0BDh,075h,015h,0E8h,039h,0BDh,075h,010h,083h,07Eh,04h
; @0F2A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,07Eh,0Ah,081h,07Eh,04h,0C0h,00h,07Dh,03h,0E9h,094h,0C9h,083h,076h,06h
; @0F2B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0E8h,020h,0BDh,074h,03h,0E9h,0Ah,0CDh,0E9h,085h,0C9h,081h,07Eh,02h,0B0h
; @0F2C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,07Fh,03h,0E9h,07Bh,0C9h,0C7h,046h,018h,05Ch,00h,0C7h,046h,08h,073h,00h
; @0F2D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,06Eh,02h,04h,0E9h,06Ah,0C9h,0A1h,036h,023h,05h,077h,00h,089h,046h,08h
; @0F2E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,046h,02h,08h,0E9h,05Ah,0C9h,0E8h,0EAh,0BCh,0E8h,0E7h,0BCh,0E8h,0E4h,0BCh
; @0F2F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0E1h,0BCh,075h,03h,0E9h,049h,0C9h,083h,07Eh,06h,04h,074h,09h,083h,07Eh
; @0F304 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,05h,074h,0Bh,0E9h,0BCh,0CCh,0C7h,046h,06h,05h,00h,0E9h,032h,0C9h,0C7h
; @0F314 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,06h,00h,0E9h,02Ah,0C9h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h
; @0F324 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,081h,0C3h,028h,01h,089h,05Eh,08h,0E8h,0A9h,0BCh,0E8h,0A6h,0BCh,075h,03h
; @0F334 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0Eh,0C9h,083h,07Eh,06h,04h,074h,08h,0C7h,046h,06h,04h,00h,0E9h,00h
; @0F344 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C9h,0C7h,046h,06h,02h,00h,0E9h,0F8h,0C8h,0A1h,026h,023h,05h,0F6h,00h,089h
; @0F354 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,08Bh,046h,02h,03h,046h,04h,03Dh,060h,00h,073h,03h,0E9h,0E1h,0C8h
; @0F364 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,071h,0BCh,0E8h,06Eh,0BCh,0E8h,06Bh,0BCh,0E8h,068h,0BCh,075h,03h,0E9h,0D0h
; @0F374 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C8h,083h,07Eh,06h,06h,074h,09h,083h,07Eh,06h,02h,074h,0Bh,0E9h,043h,0CCh
; @0F384 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,06h,03h,00h,0E9h,0B9h,0C8h,0C7h,046h,06h,05h,00h,0E9h,0B1h,0C8h
; @0F394 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,034h,0A3h,06h,023h,08Bh,046h,032h,0A3h,04h,023h,0C7h,06h,08h,023h
; @0F3A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,00h,0E8h,09h,06Ah,083h,03Eh,0Ah,023h,00h,075h,03h,0E9h,092h,0C8h,0C7h
; @0F3B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,018h,062h,00h,0E9h,08Ah,0C8h,083h,03Eh,0CEh,0A8h,018h,073h,03h,0E9h,080h
; @0F3C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C8h,0A1h,0CAh,0A8h,01h,046h,02h,081h,07Eh,02h,0D0h,00h,076h,019h,0C7h,046h
; @0F3D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,0E7h,00h,0C7h,046h,018h,061h,00h,083h,066h,02h,0F8h,083h,066h,04h,0F8h
; @0F3E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,034h,020h,00h,0EBh,0A9h,0B8h,01h,00h,083h,03Eh,07Eh,0A4h,010h,077h
; @0F3F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,0B8h,02h,00h,083h,03Eh,07Eh,0A4h,08h,077h,017h,0B8h,04h,00h,083h,03Eh
; @0F404 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,0A4h,04h,077h,0Dh,0B8h,08h,00h,083h,03Eh,07Eh,0A4h,01h,077h,03h,0B8h
; @0F414 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,0F7h,0D8h,021h,046h,04h,0F7h,0D8h,0BBh,0C0h,00h,0B9h,01h,00h,083h
; @0F424 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0C6h,0A8h,00h,074h,07h,0F7h,0D8h,033h,0DBh,0B9h,00h,00h,01h,046h,04h
; @0F434 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 039h,05Eh,04h,075h,0Dh,089h,0Eh,0C8h,0A8h,0C7h,06h,0CCh,0A8h,02h,00h,0E8h
; @0F444 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,080h,0A1h,080h,023h,039h,046h,04h,075h,0Fh,0E8h,044h,059h,083h,0E3h,01Fh
; @0F454 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,07h,0C7h,046h,018h,065h,00h,0EBh,056h,0A1h,040h,023h,025h,07Fh,00h,03Bh
; @0F464 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,030h,023h,074h,03h,0E9h,0D9h,0C7h,083h,03Eh,026h,023h,00h,074h,03h,0E9h
; @0F474 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CFh,0C7h,0FFh,06h,040h,023h,0C7h,046h,06h,04h,00h,0E8h,0B5h,0CDh,083h,0FBh
; @0F484 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,075h,03h,0E9h,0BBh,0C7h,0C7h,047h,08h,063h,00h,0E9h,0B3h,0C7h,083h,046h
; @0F494 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,04h,083h,03Eh,026h,023h,03h,074h,03h,0E9h,0A5h,0C7h,081h,07Eh,08h,0EBh
; @0F4A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,075h,03h,0E9h,09Bh,0C7h,0FFh,046h,08h,0E8h,0C6h,07Fh,0E9h,092h,0C7h,083h
; @0F4B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,02h,050h,073h,03h,0E9h,089h,0C7h,081h,07Eh,08h,0E7h,00h,074h,02Bh,081h
; @0F4C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,08h,0E8h,00h,074h,024h,081h,07Eh,08h,0E9h,00h,074h,0Eh,081h,07Eh,08h
; @0F4D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EAh,00h,074h,016h,083h,046h,02h,04h,0E9h,066h,0C7h,083h,046h,04h,02h,083h
; @0F4E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,04h,060h,074h,03h,0E9h,059h,0C7h,0EBh,0Ah,083h,03Eh,026h,023h,03h,074h
; @0F4F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,04Dh,0C7h,0FFh,046h,08h,0E9h,047h,0C7h,0B8h,02h,00h,083h,03Eh,056h
; @0F504 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,04h,074h,02h,04h,02h,01h,046h,02h,0E9h,035h,0C7h,0C7h,046h,036h,022h
; @0F514 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0C7h,046h,020h,014h,00h,0E9h,0ABh,0BDh,0C7h,046h,036h,072h,0D2h,0C7h,046h
; @0F524 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,014h,00h,0E9h,09Eh,0BDh,0C7h,06h,0C2h,0D2h,050h,00h,0A1h,02Ah,023h,0D1h
; @0F534 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D1h,0E8h,05h,01Fh,01h,089h,046h,08h,0EBh,01Bh,0C7h,06h,0C2h,0D2h,070h
; @0F544 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0A1h,02Ah,023h,0D1h,0E8h,0D1h,0E8h,05h,024h,01h,089h,046h,08h,0EBh,06h
; @0F554 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,0C2h,0D2h,060h,00h,083h,07Eh,02h,040h,073h,03h,0E9h,0E2h,0C6h,0A1h
; @0F564 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C2h,0D2h,039h,046h,04h,074h,0Ch,077h,06h,083h,046h,04h,02h,0EBh,04h,083h
; @0F574 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,04h,02h,0FFh,046h,02h,083h,07Eh,018h,06Ch,074h,03h,0E9h,0C2h,0C6h,083h
; @0F584 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,04h,060h,074h,0Dh,083h,03Eh,02Ah,023h,0Fh,075h,03h,0E8h,0A4h,0CCh,0E9h
; @0F594 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,0C6h,083h,03Eh,026h,023h,03h,075h,03h,0E8h,097h,0CCh,0E9h,0A2h,0C6h,083h
; @0F5A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,02h,050h,073h,03h,0E9h,099h,0C6h,0A1h,07Eh,023h,02Bh,046h,02h,03Dh,020h
; @0F5B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,073h,03h,0E9h,08Bh,0C6h,0C7h,046h,018h,070h,00h,0A1h,02Ah,023h,0D1h,0E8h
; @0F5C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,0E8h,05h,033h,01h,089h,046h,08h,0E8h,094h,0B9h,083h,03Eh,028h,023h,07h
; @0F5D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E8h,05Eh,0CCh,0E9h,069h,0C6h,0A1h,028h,023h,0D1h,0E8h,05h,01Ch,00h
; @0F5E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,0FFh,046h,02h,083h,03Eh,024h,023h,01h,075h,03h,0E8h,082h,07Eh
; @0F5F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,04Eh,0C6h,081h,07Eh,02h,080h,00h,073h,03h,0E9h,044h,0C6h,0C7h,046h,06h
; @0F604 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h,04Ch,01h
; @0F614 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,05Eh,08h,0EBh,020h,081h,07Eh,02h,090h,00h,073h,03h,0E9h,022h,0C6h,0C7h
; @0F624 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,06h,00h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h
; @0F634 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Fh,01h,089h,05Eh,08h,083h,07Eh,06h,02h,075h,07h,081h,07Eh,04h,0C0h,00h
; @0F644 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,01Dh,083h,07Eh,06h,06h,075h,06h,083h,07Eh,04h,00h,074h,011h,0E8h,083h
; @0F654 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B9h,0E8h,080h,0B9h,0E8h,07Dh,0B9h,0E8h,07Ah,0B9h,075h,03h,0E9h,0E2h,0C5h,0E8h
; @0F664 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,0C9h,0E9h,0DCh,0C5h,08Bh,05Eh,06h,0D1h,0EBh,0D1h,0E3h,02Eh,0FFh,0A7h,076h
; @0F674 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F6h,090h,07Eh,0F6h,0BCh,0F6h,0AFh,0F6h,0E3h,0F6h,0A1h,07Eh,023h,03Bh,046h,02h
; @0F684 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,03h,0E9h,0BCh,0C5h,0A1h,080h,023h,05h,08h,00h,083h,03Eh,084h,023h,00h
; @0F694 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,05h,08h,00h,08Bh,05Eh,04h,025h,0F0h,0FFh,083h,0E3h,0F0h,03Bh,0C3h
; @0F6A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,09Ch,0C5h,0C7h,046h,018h,085h,00h,0C3h,0A1h,07Eh,023h,03Bh,046h
; @0F6B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,073h,03h,0E9h,08Bh,0C5h,0EBh,0CDh,0A1h,080h,023h,03Bh,046h,04h,073h,03h
; @0F6C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,07Eh,0C5h,08Bh,05Eh,02h,083h,0C3h,014h,083h,0E3h,0FCh,0A1h,07Eh,023h,025h
; @0F6D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FCh,0FFh,03Bh,0C3h,074h,03h,0E9h,068h,0C5h,0C7h,046h,018h,085h,00h,0C3h,0A1h
; @0F6E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,023h,03Bh,046h,04h,076h,03h,0E9h,057h,0C5h,0EBh,0D7h,08Bh,05Eh,02h,083h
; @0F6F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,014h,083h,0E3h,0FCh,0A1h,07Eh,023h,025h,0FCh,0FFh,03Bh,0C3h,074h,03h,0E9h
; @0F704 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Fh,0C5h,083h,06Eh,02h,04h,0E8h,0Eh,00h,083h,046h,02h,08h,0E8h,07h,00h
; @0F714 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,06Eh,02h,04h,0E9h,02Ah,0C5h,0E8h,019h,0CBh,083h,0FBh,0FFh,074h,05h,0C7h
; @0F724 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,08h,044h,00h,0C3h,083h,046h,02h,02h,083h,03Eh,026h,023h,03h,074h,03h
; @0F734 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0Eh,0C5h,0FFh,076h,06h,0C7h,046h,06h,05h,00h,0E8h,0DBh,0CAh,0C7h,046h
; @0F744 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,03h,00h,0E8h,0D3h,0CAh,0C7h,046h,06h,04h,00h,0E8h,0CBh,0CAh,08Fh,046h
; @0F754 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0E9h,0EDh,0C4h,0BEh,0C4h,0D2h,0EBh,01Ch,0BEh,0C8h,0D2h,0EBh,017h,0C7h,046h
; @0F764 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,04h,00h,083h,03Eh,030h,023h,0Fh,077h,03h,0E8h,05h,07Dh,0BEh,0CCh,0D2h
; @0F774 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,03h,0BEh,0D0h,0D2h,0ADh,03h,06h,0B8h,0A8h,089h,046h,02h,083h,07Eh,02h
; @0F784 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,07Dh,05h,0C7h,046h,02h,00h,00h,0ADh,03h,06h,0B6h,0A8h,089h,046h,04h
; @0F794 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0AEh,0C4h
; sub_0000_F797
; @0F797 0000:F797 original=8b2ebaa8
    mov bp, word ptr ds:[0A8BAh]
; @0F79B 0000:F79B original=ff36b6a8
    push word ptr ds:[0A8B6h]
; @0F79F 0000:F79F original=8f4604
    pop word ptr ss:[bp + 4]
; @0F7A2 0000:F7A2 original=ff36b8a8
    push word ptr ds:[0A8B8h]
; @0F7A6 0000:F7A6 original=8f4602
    pop word ptr ss:[bp + 2]
; @0F7A9 0000:F7A9 original=8b36c4a8
    mov si, word ptr ds:[0A8C4h]
; @0F7AD 0000:F7AD original=ad
    lodsw
; @0F7AE 0000:F7AE original=3dffff
    cmp ax, 0FFFFh
; @0F7B1 0000:F7B1 original=7508
    JNE_SHORT loc_0F7BB
; @0F7B3 0000:F7B3 original=c706c4a8d4d2
    mov word ptr ds:[0A8C4h], 0D2D4h
; @0F7B9 0000:F7B9 original=ebee
    JMP_SHORT loc_0F7A9
; @0F7BB 0000:F7BB original=052000
    add ax, 020h
; @0F7BE 0000:F7BE original=a30623
    mov word ptr ds:[02306h], ax
; @0F7C1 0000:F7C1 original=ad
    lodsw
; @0F7C2 0000:F7C2 original=a30423
    mov word ptr ds:[02304h], ax
; @0F7C5 0000:F7C5 original=c70608230200
    mov word ptr ds:[02308h], 2
; @0F7CB 0000:F7CB original=e8e465
    CALL_NEAR loc_05DB2
; @0F7CE 0000:F7CE original=ff7604
    push word ptr ss:[bp + 4]
; @0F7D1 0000:F7D1 original=8f06b6a8
    pop word ptr ds:[0A8B6h]
; @0F7D5 0000:F7D5 original=ff7602
    push word ptr ss:[bp + 2]
; @0F7D8 0000:F7D8 original=8f06b8a8
    pop word ptr ds:[0A8B8h]
; @0F7DC 0000:F7DC original=833e0a2300
    cmp word ptr ds:[0230Ah], 0
; @0F7E1 0000:F7E1 original=7501
    JNE_SHORT loc_0F7E4
; @0F7E3 0000:F7E3 original=c3
    ret
; @0F7E4 0000:F7E4 original=8936c4a8
    mov word ptr ds:[0A8C4h], si
; @0F7E8 0000:F7E8 original=ebad
    JMP_SHORT loc_0F797
; @0F7EA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h
; sub_0F7F_0000
; @0F7F0 0F7F:0000 original=bf6822
    mov di, 02268h
; @0F7F3 0F7F:0003 original=b8bc15
    mov ax, 015BCh
; @0F7F6 0F7F:0006 original=8ec0
    mov es, ax
; @0F7F8 0F7F:0008 original=a1b522
    mov ax, word ptr ds:[022B5h]
; @0F7FB 0F7F:000B original=ab
    stosw
; @0F7FC 0F7F:000C original=be3e00
    mov si, 03Eh
; @0F7FF 0F7F:000F original=b90400
    mov cx, 4
; @0F802 0F7F:0012 original=f3a5
    rep movsw
; @0F804 0F7F:0014 original=a11000
    mov ax, word ptr ds:[010h]
; @0F807 0F7F:0017 original=ab
    stosw
; @0F808 0F7F:0018 original=be3e21
    mov si, 0213Eh
; @0F80B 0F7F:001B original=b90800
    mov cx, 8
; @0F80E 0F7F:001E original=f3a4
    rep movsb
; @0F810 0F7F:0020 original=8bc3
    mov ax, bx
; @0F812 0F7F:0022 original=ab
    stosw
; @0F813 0F7F:0023 original=a0c4bc
    mov al, byte ptr ds:[0BCC4h]
; @0F816 0F7F:0026 original=aa
    stosb
; @0F817 0F7F:0027 original=a1dabe
    mov ax, word ptr ds:[0BEDAh]
; @0F81A 0F7F:002A original=ab
    stosw
; @0F81B 0F7F:002B original=a1dcbe
    mov ax, word ptr ds:[0BEDCh]
; @0F81E 0F7F:002E original=ab
    stosw
; @0F81F 0F7F:002F original=cb
    retf
; sub_0F7F_0030
; @0F820 0F7F:0030 original=be6822
    mov si, 02268h
; @0F823 0F7F:0033 original=b8bc15
    mov ax, 015BCh
; @0F826 0F7F:0036 original=8ec0
    mov es, ax
; @0F828 0F7F:0038 original=ad
    lodsw
; @0F829 0F7F:0039 original=a3b522
    mov word ptr ds:[022B5h], ax
; @0F82C 0F7F:003C original=8bd8
    mov bx, ax
; @0F82E 0F7F:003E original=d1e3
    shl bx, 1
; @0F830 0F7F:0040 original=8b9fc122
    mov bx, word ptr ds:[bx + 022C1h]
; @0F834 0F7F:0044 original=883ec098
    mov byte ptr ds:[098C0h], bh
; @0F838 0F7F:0048 original=881ec198
    mov byte ptr ds:[098C1h], bl
; @0F83C 0F7F:004C original=bf3e00
    mov di, 03Eh
; @0F83F 0F7F:004F original=b90400
    mov cx, 4
; @0F842 0F7F:0052 original=f3a5
    rep movsw
; @0F844 0F7F:0054 original=ad
    lodsw
; @0F845 0F7F:0055 original=a31000
    mov word ptr ds:[010h], ax
; @0F848 0F7F:0058 original=bf3e21
    mov di, 0213Eh
; @0F84B 0F7F:005B original=b90800
    mov cx, 8
; @0F84E 0F7F:005E original=f3a4
    rep movsb
; @0F850 0F7F:0060 original=a04021
    mov al, byte ptr ds:[02140h]
; @0F853 0F7F:0063 original=a24821
    mov byte ptr ds:[02148h], al
; @0F856 0F7F:0066 original=ad
    lodsw
; @0F857 0F7F:0067 original=8bd8
    mov bx, ax
; @0F859 0F7F:0069 original=ac
    lodsb
; @0F85A 0F7F:006A original=a2c4bc
    mov byte ptr ds:[0BCC4h], al
; @0F85D 0F7F:006D original=ad
    lodsw
; @0F85E 0F7F:006E original=a3dabe
    mov word ptr ds:[0BEDAh], ax
; @0F861 0F7F:0071 original=ad
    lodsw
; @0F862 0F7F:0072 original=a3dcbe
    mov word ptr ds:[0BEDCh], ax
; @0F865 0F7F:0075 original=cb
    retf
; sub_0F7F_0076
; @0F866 0F7F:0076 original=bed821
    mov si, 021D8h
; @0F869 0F7F:0079 original=b9ac00
    mov cx, 0ACh
; @0F86C 0F7F:007C original=33c0
    xor ax, ax
; @0F86E 0F7F:007E original=8034aa
    xor byte ptr ds:[si], 0AAh
; @0F871 0F7F:0081 original=300c
    xor byte ptr ds:[si], cl
; @0F873 0F7F:0083 original=0204
    add al, byte ptr ds:[si]
; @0F875 0F7F:0085 original=80d400
    adc ah, 0
; @0F878 0F7F:0088 original=46
    inc si
; @0F879 0F7F:0089 original=e2f3
    LOOP_SHORT loc_0F86E
; @0F87B 0F7F:008B original=cb
    retf
; sub_0F7F_008C
; @0F87C 0F7F:008C original=803ec39800
    cmp byte ptr ds:[098C3h], 0
; @0F881 0F7F:0091 original=741a
    JE_SHORT loc_0F89D
; @0F883 0F7F:0093 original=e85e00
    CALL_NEAR loc_0F8E4
; @0F886 0F7F:0096 original=e88200
    CALL_NEAR loc_0F90B
; @0F889 0F7F:0099 original=e81200
    CALL_NEAR loc_0F89E
; @0F88C 0F7F:009C original=e81d00
    CALL_NEAR loc_0F8AC
; @0F88F 0F7F:009F original=e82800
    CALL_NEAR loc_0F8BA
; @0F892 0F7F:00A2 original=e83300
    CALL_NEAR loc_0F8C8
; @0F895 0F7F:00A5 original=e83e00
    CALL_NEAR loc_0F8D6
; @0F898 0F7F:00A8 original=c606c39800
    mov byte ptr ds:[098C3h], 0
; @0F89D 0F7F:00AD original=cb
    retf
; sub_0F7F_00AE
; @0F89E 0F7F:00AE original=bb9297
    mov bx, 09792h
; @0F8A1 0F7F:00B1 original=e88e00
    CALL_NEAR loc_0F932
; @0F8A4 0F7F:00B4 original=7505
    JNE_SHORT loc_0F8AB
; @0F8A6 0F7F:00B6 original=c6068c9701
    mov byte ptr ds:[0978Ch], 1
; @0F8AB 0F7F:00BB original=c3
    ret
; sub_0F7F_00BC
; @0F8AC 0F7F:00BC original=bba497
    mov bx, 097A4h
; @0F8AF 0F7F:00BF original=e88000
    CALL_NEAR loc_0F932
; @0F8B2 0F7F:00C2 original=7505
    JNE_SHORT loc_0F8B9
; @0F8B4 0F7F:00C4 original=c6068d9701
    mov byte ptr ds:[0978Dh], 1
; @0F8B9 0F7F:00C9 original=c3
    ret
; sub_0F7F_00CA
; @0F8BA 0F7F:00CA original=bbb897
    mov bx, 097B8h
; @0F8BD 0F7F:00CD original=e87200
    CALL_NEAR loc_0F932
; @0F8C0 0F7F:00D0 original=7505
    JNE_SHORT loc_0F8C7
; @0F8C2 0F7F:00D2 original=c6068e9701
    mov byte ptr ds:[0978Eh], 1
; @0F8C7 0F7F:00D7 original=c3
    ret
; sub_0F7F_00D8
; @0F8C8 0F7F:00D8 original=bbc797
    mov bx, 097C7h
; @0F8CB 0F7F:00DB original=e86400
    CALL_NEAR loc_0F932
; @0F8CE 0F7F:00DE original=7505
    JNE_SHORT loc_0F8D5
; @0F8D0 0F7F:00E0 original=c6068f9701
    mov byte ptr ds:[0978Fh], 1
; @0F8D5 0F7F:00E5 original=c3
    ret
; sub_0F7F_00E6
; @0F8D6 0F7F:00E6 original=bbd797
    mov bx, 097D7h
; @0F8D9 0F7F:00E9 original=e85600
    CALL_NEAR loc_0F932
; @0F8DC 0F7F:00EC original=7505
    JNE_SHORT loc_0F8E3
; @0F8DE 0F7F:00EE original=c606909701
    mov byte ptr ds:[09790h], 1
; @0F8E3 0F7F:00F3 original=c3
    ret
; sub_0F7F_00F4
; @0F8E4 0F7F:00F4 original=bbee97
    mov bx, 097EEh
; @0F8E7 0F7F:00F7 original=e84800
    CALL_NEAR loc_0F932
; @0F8EA 0F7F:00FA original=751e
    JNE_SHORT loc_0F90A
; @0F8EC 0F7F:00FC original=c6068c9701
    mov byte ptr ds:[0978Ch], 1
; @0F8F1 0F7F:0101 original=c6068d9701
    mov byte ptr ds:[0978Dh], 1
; @0F8F6 0F7F:0106 original=c6068e9701
    mov byte ptr ds:[0978Eh], 1
; @0F8FB 0F7F:010B original=c6068f9701
    mov byte ptr ds:[0978Fh], 1
; @0F900 0F7F:0110 original=c606909701
    mov byte ptr ds:[09790h], 1
; @0F905 0F7F:0115 original=c606919701
    mov byte ptr ds:[09791h], 1
; @0F90A 0F7F:011A original=c3
    ret
; sub_0F7F_011B
; @0F90B 0F7F:011B original=bb1898
    mov bx, 09818h
; @0F90E 0F7F:011E original=e82100
    CALL_NEAR loc_0F932
; @0F911 0F7F:0121 original=751e
    JNE_SHORT loc_0F931
; @0F913 0F7F:0123 original=c6068c9700
    mov byte ptr ds:[0978Ch], 0
; @0F918 0F7F:0128 original=c6068d9700
    mov byte ptr ds:[0978Dh], 0
; @0F91D 0F7F:012D original=c6068e9700
    mov byte ptr ds:[0978Eh], 0
; @0F922 0F7F:0132 original=c6068f9700
    mov byte ptr ds:[0978Fh], 0
; @0F927 0F7F:0137 original=c606909700
    mov byte ptr ds:[09790h], 0
; @0F92C 0F7F:013C original=c606919700
    mov byte ptr ds:[09791h], 0
; @0F931 0F7F:0141 original=c3
    ret
; sub_0F7F_0142
; @0F932 0F7F:0142 original=8b3f
    mov di, word ptr ds:[bx]
; @0F934 0F7F:0144 original=a0c398
    mov al, byte ptr ds:[098C3h]
; @0F937 0F7F:0147 original=3a05
    cmp al, byte ptr ds:[di]
; @0F939 0F7F:0149 original=7512
    JNE_SHORT loc_0F94D
; @0F93B 0F7F:014B original=ff07
    inc word ptr ds:[bx]
; @0F93D 0F7F:014D original=807d0100
    cmp byte ptr ds:[di + 1], 0
; @0F941 0F7F:0151 original=750f
    JNE_SHORT loc_0F952
; @0F943 0F7F:0153 original=bd0154
    mov bp, 05401h
; @0F946 0F7F:0156 original=9a8e8d0000
    CALL_FAR 00h,08D8Eh
; @0F94B 0F7F:015B original=eb05
    JMP_SHORT loc_0F952
; @0F94D 0F7F:015D original=891f
    mov word ptr ds:[bx], bx
; @0F94F 0F7F:015F original=830702
    add word ptr ds:[bx], 2
; @0F952 0F7F:0162 original=c3
    ret
; sub_0F7F_0163
; @0F953 0F7F:0163 original=53
    push bx
; @0F954 0F7F:0164 original=51
    push cx
; @0F955 0F7F:0165 original=833e702000
    cmp word ptr ds:[02070h], 0
; @0F95A 0F7F:016A original=741a
    JE_SHORT loc_0F976
; @0F95C 0F7F:016C original=b91000
    mov cx, 010h
; @0F95F 0F7F:016F original=c70698200000
    mov word ptr ds:[02098h], 0
; @0F965 0F7F:0175 original=bb7820
    mov bx, 02078h
; @0F968 0F7F:0178 original=803f00
    cmp byte ptr ds:[bx], 0
; @0F96B 0F7F:017B original=740c
    JE_SHORT loc_0F979
; @0F96D 0F7F:017D original=83c302
    add bx, 2
; @0F970 0F7F:0180 original=ff069820
    inc word ptr ds:[02098h]
; @0F974 0F7F:0184 original=e2f2
    LOOP_SHORT loc_0F968
; @0F976 0F7F:0186 original=bbffff
    mov bx, 0FFFFh
; @0F979 0F7F:0189 original=891e9a20
    mov word ptr ds:[0209Ah], bx
; @0F97D 0F7F:018D original=59
    pop cx
; @0F97E 0F7F:018E original=5b
    pop bx
; @0F97F 0F7F:018F original=cb
    retf
; sub_0F7F_0190
; @0F980 0F7F:0190 original=b430
    mov ah, 030h
; @0F982 0F7F:0192 original=32c0
    xor al, al
; @0F984 0F7F:0194 original=cd21
    int 021h
; @0F986 0F7F:0196 original=3c03
    cmp al, 3
; @0F988 0F7F:0198 original=7212
    JB_SHORT loc_0F99C
; @0F98A 0F7F:019A original=b458
    mov ah, 058h
; @0F98C 0F7F:019C original=b000
    mov al, 0
; @0F98E 0F7F:019E original=cd21
    int 021h
; @0F990 0F7F:01A0 original=a38a97
    mov word ptr ds:[0978Ah], ax
; @0F993 0F7F:01A3 original=b458
    mov ah, 058h
; @0F995 0F7F:01A5 original=b001
    mov al, 1
; @0F997 0F7F:01A7 original=bb0100
    mov bx, 1
; @0F99A 0F7F:01AA original=cd21
    int 021h
; @0F99C 0F7F:01AC original=cb
    retf
; sub_0F7F_01AD
; @0F99D 0F7F:01AD original=b430
    mov ah, 030h
; @0F99F 0F7F:01AF original=32c0
    xor al, al
; @0F9A1 0F7F:01B1 original=cd21
    int 021h
; @0F9A3 0F7F:01B3 original=3c03
    cmp al, 3
; @0F9A5 0F7F:01B5 original=720a
    JB_SHORT loc_0F9B1
; @0F9A7 0F7F:01B7 original=b458
    mov ah, 058h
; @0F9A9 0F7F:01B9 original=b001
    mov al, 1
; @0F9AB 0F7F:01BB original=8b1e8a97
    mov bx, word ptr ds:[0978Ah]
; @0F9AF 0F7F:01BF original=cd21
    int 021h
; @0F9B1 0F7F:01C1 original=cb
    retf
; @0F9B2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,056h,023h,05h,074h,014h,0B8h,01Ch,00h,083h,03Eh,056h,023h,03h,074h
; @0F9C2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Fh,0A1h,028h,023h,0D1h,0E8h,05h,022h,00h,0EBh,025h,0B9h,01h,00h,08Bh,046h
; @0F9D2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,03Bh,06h,080h,023h,072h,08h,09Ch,0F7h,0D9h,09Dh,077h,02h,033h,0C9h,01h
; @0F9E2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,04h,08Bh,01Eh,036h,023h,083h,0E3h,0FEh,08Bh,087h,0D2h,096h,05h,026h,00h
; @0F9F2 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,0FFh,046h,02h,0CBh
; sub_0F7F_0209
; @0F9F9 0F7F:0209 original=a382a4
    mov word ptr ds:[0A482h], ax
; @0F9FC 0F7F:020C original=c70642a844a8
    mov word ptr ds:[0A842h], 0A844h
; @0FA02 0F7F:0212 original=c747201400
    mov word ptr ds:[bx + 020h], 014h
; @0FA07 0F7F:0217 original=c7067ea40100
    mov word ptr ds:[0A47Eh], 1
; @0FA0D 0F7F:021D original=c70680a46400
    mov word ptr ds:[0A480h], 064h
; @0FA13 0F7F:0223 original=c70642230100
    mov word ptr ds:[02342h], 1
; @0FA19 0F7F:0229 original=c70644230100
    mov word ptr ds:[02344h], 1
; @0FA1F 0F7F:022F original=c70646230000
    mov word ptr ds:[02346h], 0
; @0FA25 0F7F:0235 original=c70648230000
    mov word ptr ds:[02348h], 0
; @0FA2B 0F7F:023B original=c706a0a70000
    mov word ptr ds:[0A7A0h], 0
; @0FA31 0F7F:0241 original=e81006
    CALL_NEAR loc_10044
; @0FA34 0F7F:0244 original=e8d106
    CALL_NEAR loc_10108
; @0FA37 0F7F:0247 original=cb
    retf
; sub_0F7F_0248
; @0FA38 0F7F:0248 original=50
    push ax
; @0FA39 0F7F:0249 original=51
    push cx
; @0FA3A 0F7F:024A original=57
    push di
; @0FA3B 0F7F:024B original=bfc398
    mov di, 098C3h
; @0FA3E 0F7F:024E original=b98000
    mov cx, 080h
; @0FA41 0F7F:0251 original=32c0
    xor al, al
; @0FA43 0F7F:0253 original=47
    inc di
; @0FA44 0F7F:0254 original=0a05
    or al, byte ptr ds:[di]
; @0FA46 0F7F:0256 original=e2fb
    LOOP_SHORT loc_0FA43
; @0FA48 0F7F:0258 original=75f1
    JNE_SHORT loc_0FA3B
; @0FA4A 0F7F:025A original=5f
    pop di
; @0FA4B 0F7F:025B original=59
    pop cx
; @0FA4C 0F7F:025C original=58
    pop ax
; @0FA4D 0F7F:025D original=cb
    retf
; @0FA4E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,08h,05Ch,01h,081h,07Eh,02h,090h,00h,07Ch,0Fh,0C7h,046h,018h,07Ch
; @0FA5E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,08Bh,0DDh,0B8h,0E2h,074h,09Ah,08Bh,08Dh,00h,00h,0CBh
; @0FA6A 0F7F:027A original=8b3682a4 runtime CFG evidence
    mov si, word ptr ds:[0A482h]
; @0FA6E 0F7F:027E original=ad runtime CFG evidence
    lodsw
; @0FA6F 0F7F:027F original=052000 runtime CFG evidence
    add ax, 020h
; @0FA72 0F7F:0282 original=a30623 runtime CFG evidence
    mov word ptr ds:[02306h], ax
; @0FA75 0F7F:0285 original=ad runtime CFG evidence
    lodsw
; @0FA76 0F7F:0286 original=a30423 runtime CFG evidence
    mov word ptr ds:[02304h], ax
; @0FA79 0F7F:0289 original=c70608230300 runtime CFG evidence
    mov word ptr ds:[02308h], 3
; @0FA7F 0F7F:028F original=b8b25d runtime CFG evidence
    mov ax, 05DB2h
; @0FA82 0F7F:0292 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FA87 0F7F:0297 original=833e0a2300 runtime CFG evidence
    cmp word ptr ds:[0230Ah], 0
; @0FA8C 0F7F:029C original=7503 runtime CFG evidence
    JNE_SHORT loc_0FA91
; @0FA8E 0F7F:029E original=e9a701 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FA91 0F7F:02A1 original=837e1813 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 013h
; @0FA95 0F7F:02A5 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FA9A
; @0FA97 0F7F:02A7 original=e98801 runtime CFG evidence
    JMP_NEAR loc_0FC22
; @0FA9A 0F7F:02AA original=837e1815 runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 015h
; @0FA9E 0F7F:02AE original=7503 runtime CFG evidence
    JNE_SHORT loc_0FAA3
; @0FAA0 0F7F:02B0 original=e93301 runtime CFG evidence
    JMP_NEAR loc_0FBD6
; @0FAA3 0F7F:02B3 original=837e181c runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 01Ch
; @0FAA7 0F7F:02B7 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FAAC
; @0FAA9 0F7F:02B9 original=e9ea00 runtime CFG evidence
    JMP_NEAR loc_0FB96
; @0FAAC 0F7F:02BC original=837e181f runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 01Fh
; @0FAB0 0F7F:02C0 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FAB5
; @0FAB2 0F7F:02C2 original=e9a300 runtime CFG evidence
    JMP_NEAR loc_0FB58
; @0FAB5 0F7F:02C5 original=837e187d runtime CFG evidence
    cmp word ptr ss:[bp + 018h], 07Dh
; @0FAB9 0F7F:02C9 original=743e runtime CFG evidence
    JE_SHORT loc_0FAF9
; @0FABB 0F7F:02CB original=830682a408 runtime CFG evidence
    add word ptr ds:[0A482h], 8
; @0FAC0 0F7F:02D0 original=833cff runtime CFG evidence
    cmp word ptr ds:[si], -1
; @0FAC3 0F7F:02D3 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FAC8
; @0FAC5 0F7F:02D5 original=e97001 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FAC8 0F7F:02D8 original=b8f481 runtime CFG evidence
    mov ax, 081F4h
; @0FACB 0F7F:02DB original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FAD0 0F7F:02E0 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0FAD3 0F7F:02E3 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FAD8
; @0FAD5 0F7F:02E5 original=e96001 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FAD8 0F7F:02E8 original=ad runtime CFG evidence
    lodsw
; @0FAD9 0F7F:02E9 original=052000 runtime CFG evidence
    add ax, 020h
; @0FADC 0F7F:02EC original=894734 runtime CFG evidence
    mov word ptr ds:[bx + 034h], ax
; @0FADF 0F7F:02EF original=ad runtime CFG evidence
    lodsw
; @0FAE0 0F7F:02F0 original=894732 runtime CFG evidence
    mov word ptr ds:[bx + 032h], ax
; @0FAE3 0F7F:02F3 original=c747187f00 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 07Fh
; @0FAE8 0F7F:02F8 original=c7471c1400 runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 014h
; @0FAED 0F7F:02FD original=c747200500 runtime CFG evidence
    mov word ptr ds:[bx + 020h], 5
; @0FAF2 0F7F:0302 original=ff067ea4 runtime CFG evidence
    inc word ptr ds:[0A47Eh]
; @0FAF6 0F7F:0306 original=e93f01 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FAF9 0F7F:0309 original=830682a408 runtime CFG evidence
    add word ptr ds:[0A482h], 8
; @0FAFE 0F7F:030E original=833cff runtime CFG evidence
    cmp word ptr ds:[si], -1
; @0FB01 0F7F:0311 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FB06
; @0FB03 0F7F:0313 original=e93201 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FB06 0F7F:0316 original=b8f481 runtime CFG evidence
    mov ax, 081F4h
; @0FB09 0F7F:0319 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FB0E 0F7F:031E original=83fbff runtime CFG evidence
    cmp bx, -1
; @0FB11 0F7F:0321 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FB16
; @0FB13 0F7F:0323 original=e92201 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FB16 0F7F:0326 original=ad runtime CFG evidence
    lodsw
; @0FB17 0F7F:0327 original=052000 runtime CFG evidence
    add ax, 020h
; @0FB1A 0F7F:032A original=894734 runtime CFG evidence
    mov word ptr ds:[bx + 034h], ax
; @0FB1D 0F7F:032D original=ad runtime CFG evidence
    lodsw
; @0FB1E 0F7F:032E original=894732 runtime CFG evidence
    mov word ptr ds:[bx + 032h], ax
; @0FB21 0F7F:0331 original=c747060200 runtime CFG evidence
    mov word ptr ds:[bx + 6], 2
; @0FB26 0F7F:0336 original=d1e8 runtime CFG evidence
    shr ax, 1
; @0FB28 0F7F:0338 original=d1e8 runtime CFG evidence
    shr ax, 1
; @0FB2A 0F7F:033A original=d1e8 runtime CFG evidence
    shr ax, 1
; @0FB2C 0F7F:033C original=d1e8 runtime CFG evidence
    shr ax, 1
; @0FB2E 0F7F:033E original=a90100 runtime CFG evidence
    test ax, 1
; @0FB31 0F7F:0341 original=7405 runtime CFG evidence
    JE_SHORT loc_0FB38
; @0FB33 0F7F:0343 original=c747060600 runtime CFG evidence
    mov word ptr ds:[bx + 6], 6
; @0FB38 0F7F:0348 original=c747188100 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 081h
; @0FB3D 0F7F:034D original=c7471c1900 runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 019h
; @0FB42 0F7F:0352 original=c747200500 runtime CFG evidence
    mov word ptr ds:[bx + 020h], 5
; @0FB47 0F7F:0357 original=c7470a0000 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 0
; @0FB4C 0F7F:035C original=c747360000 runtime CFG evidence
    mov word ptr ds:[bx + 036h], 0
; @0FB51 0F7F:0361 original=ff067ea4 runtime CFG evidence
    inc word ptr ds:[0A47Eh]
; @0FB55 0F7F:0365 original=e9e000 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FB58 0F7F:0368 original=830682a404 runtime CFG evidence
    add word ptr ds:[0A482h], 4
; @0FB5D 0F7F:036D original=b90500 runtime CFG evidence
    mov cx, 5
; @0FB60 0F7F:0370 original=51 runtime CFG evidence
    push cx
; @0FB61 0F7F:0371 original=b8f481 runtime CFG evidence
    mov ax, 081F4h
; @0FB64 0F7F:0374 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FB69 0F7F:0379 original=8b3642a8 runtime CFG evidence
    mov si, word ptr ds:[0A842h]
; @0FB6D 0F7F:037D original=830642a804 runtime CFG evidence
    add word ptr ds:[0A842h], 4
; @0FB72 0F7F:0382 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0FB75 0F7F:0385 original=7419 runtime CFG evidence
    JE_SHORT loc_0FB90
; @0FB77 0F7F:0387 original=ad runtime CFG evidence
    lodsw
; @0FB78 0F7F:0388 original=052000 runtime CFG evidence
    add ax, 020h
; @0FB7B 0F7F:038B original=894734 runtime CFG evidence
    mov word ptr ds:[bx + 034h], ax
; @0FB7E 0F7F:038E original=ad runtime CFG evidence
    lodsw
; @0FB7F 0F7F:038F original=894732 runtime CFG evidence
    mov word ptr ds:[bx + 032h], ax
; @0FB82 0F7F:0392 original=c747182000 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 020h
; @0FB87 0F7F:0397 original=c7471cffff runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 0FFFFh
; @0FB8C 0F7F:039C original=ff067ea4 runtime CFG evidence
    inc word ptr ds:[0A47Eh]
; @0FB90 0F7F:03A0 original=59 runtime CFG evidence
    pop cx
; @0FB91 0F7F:03A1 original=e2cd runtime CFG evidence
    LOOP_SHORT loc_0FB60
; @0FB93 0F7F:03A3 original=e9a200 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FB96 0F7F:03A6 original=830682a408 runtime CFG evidence
    add word ptr ds:[0A482h], 8
; @0FB9B 0F7F:03AB original=b8f481 runtime CFG evidence
    mov ax, 081F4h
; @0FB9E 0F7F:03AE original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FBA3 0F7F:03B3 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0FBA6 0F7F:03B6 original=7503 runtime CFG evidence
    JNE_SHORT loc_0FBAB
; @0FBA8 0F7F:03B8 original=e98d00 runtime CFG evidence
    JMP_NEAR loc_0FC38
; @0FBAB 0F7F:03BB original=ad runtime CFG evidence
    lodsw
; @0FBAC 0F7F:03BC original=052000 runtime CFG evidence
    add ax, 020h
; @0FBAF 0F7F:03BF original=894734 runtime CFG evidence
    mov word ptr ds:[bx + 034h], ax
; @0FBB2 0F7F:03C2 original=ad runtime CFG evidence
    lodsw
; @0FBB3 0F7F:03C3 original=894732 runtime CFG evidence
    mov word ptr ds:[bx + 032h], ax
; @0FBB6 0F7F:03C6 original=c747181d00 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 01Dh
; @0FBBB 0F7F:03CB original=837e0400 runtime CFG evidence
    cmp word ptr ss:[bp + 4], 0
; @0FBBF 0F7F:03CF original=750a runtime CFG evidence
    JNE_SHORT loc_0FBCB
; @0FBC1 0F7F:03D1 original=c747181e00 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 01Eh
; @0FBC6 0F7F:03D6 original=c747084300 runtime CFG evidence
    mov word ptr ds:[bx + 8], 043h
; @0FBCB 0F7F:03DB original=c7471c1400 runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 014h
; @0FBD0 0F7F:03E0 original=ff067ea4 runtime CFG evidence
    inc word ptr ds:[0A47Eh]
; @0FBD4 0F7F:03E4 original=eb62 runtime CFG evidence
    JMP_SHORT loc_0FC38
; @0FBD6 0F7F:03E6 original=830682a408 runtime CFG evidence
    add word ptr ds:[0A482h], 8
; @0FBDB 0F7F:03EB original=833cff runtime CFG evidence
    cmp word ptr ds:[si], -1
; @0FBDE 0F7F:03EE original=7458 runtime CFG evidence
    JE_SHORT loc_0FC38
; @0FBE0 0F7F:03F0 original=b8f481 runtime CFG evidence
    mov ax, 081F4h
; @0FBE3 0F7F:03F3 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FBE8 0F7F:03F8 original=83fbff runtime CFG evidence
    cmp bx, -1
; @0FBEB 0F7F:03FB original=744b runtime CFG evidence
    JE_SHORT loc_0FC38
; @0FBED 0F7F:03FD original=ad runtime CFG evidence
    lodsw
; @0FBEE 0F7F:03FE original=052000 runtime CFG evidence
    add ax, 020h
; @0FBF1 0F7F:0401 original=894734 runtime CFG evidence
    mov word ptr ds:[bx + 034h], ax
; @0FBF4 0F7F:0404 original=ad runtime CFG evidence
    lodsw
; @0FBF5 0F7F:0405 original=894732 runtime CFG evidence
    mov word ptr ds:[bx + 032h], ax
; @0FBF8 0F7F:0408 original=c747181600 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 016h
; @0FBFD 0F7F:040D original=c74736d4a5 runtime CFG evidence
    mov word ptr ds:[bx + 036h], 0A5D4h
; @0FC02 0F7F:0412 original=837e0240 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 040h
; @0FC06 0F7F:0416 original=740a runtime CFG evidence
    JE_SHORT loc_0FC12
; @0FC08 0F7F:0418 original=c747181700 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 017h
; @0FC0D 0F7F:041D original=c74736c4a5 runtime CFG evidence
    mov word ptr ds:[bx + 036h], 0A5C4h
; @0FC12 0F7F:0422 original=c7471c1400 runtime CFG evidence
    mov word ptr ds:[bx + 01Ch], 014h
; @0FC17 0F7F:0427 original=c747200300 runtime CFG evidence
    mov word ptr ds:[bx + 020h], 3
; @0FC1C 0F7F:042C original=ff067ea4 runtime CFG evidence
    inc word ptr ds:[0A47Eh]
; @0FC20 0F7F:0430 original=eb16 runtime CFG evidence
    JMP_SHORT loc_0FC38
; @0FC22 0F7F:0432 original=830682a404 runtime CFG evidence
    add word ptr ds:[0A482h], 4
; @0FC27 0F7F:0437 original=b8f481 runtime CFG evidence
    mov ax, 081F4h
; @0FC2A 0F7F:043A original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FC2F 0F7F:043F original=83fbff runtime CFG evidence
    cmp bx, -1
; @0FC32 0F7F:0442 original=7404 runtime CFG evidence
    JE_SHORT loc_0FC38
; @0FC34 0F7F:0444 original=ff067ea4 runtime CFG evidence
    inc word ptr ds:[0A47Eh]
; @0FC38 0F7F:0448 original=8b4606 runtime CFG evidence
    mov ax, word ptr ss:[bp + 6]
; @0FC3B 0F7F:044B original=053b00 runtime CFG evidence
    add ax, 03Bh
; @0FC3E 0F7F:044E original=894608 runtime CFG evidence
    mov word ptr ss:[bp + 8], ax
; @0FC41 0F7F:0451 original=cb runtime CFG evidence
    retf
; @0FC42 0F7F:0452 original=c746086a01 runtime CFG evidence
    mov word ptr ss:[bp + 8], 016Ah
; @0FC47 0F7F:0457 original=c70608230100 runtime CFG evidence
    mov word ptr ds:[02308h], 1
; @0FC4D 0F7F:045D original=ff7606 runtime CFG evidence
    push word ptr ss:[bp + 6]
; @0FC50 0F7F:0460 original=b829b7 runtime CFG evidence
    mov ax, 0B729h
; @0FC53 0F7F:0463 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FC58 0F7F:0468 original=8f4606 runtime CFG evidence
    pop word ptr ss:[bp + 6]
; @0FC5B 0F7F:046B original=7405 runtime CFG evidence
    JE_SHORT loc_0FC62
; @0FC5D 0F7F:046D original=c746189300 runtime CFG evidence
    mov word ptr ss:[bp + 018h], 093h
; @0FC62 0F7F:0472 original=cb runtime CFG evidence
    retf
; @0FC63 0F7F:0473 original=813e82a4f0a6 runtime CFG evidence
    cmp word ptr ds:[0A482h], 0A6F0h
; @0FC69 0F7F:0479 original=7403 runtime CFG evidence
    JE_SHORT loc_0FC6E
; @0FC6B 0F7F:047B original=e9fb01 runtime CFG evidence
    JMP_NEAR loc_0FE69
; @0FC6E 0F7F:047E original=837e1c00 runtime CFG evidence
    cmp word ptr ss:[bp + 01Ch], 0
; @0FC72 0F7F:0482 original=7408 runtime CFG evidence
    JE_SHORT loc_0FC7C
; @0FC74 0F7F:0484 original=ff4e1c runtime CFG evidence
    dec word ptr ss:[bp + 01Ch]
; @0FC77 0F7F:0487 original=7403 runtime CFG evidence
    JE_SHORT loc_0FC7C
; @0FC79 0F7F:0489 original=e9ed01 runtime CFG evidence
    JMP_NEAR loc_0FE69
; @0FC7C 0F7F:048C original=837e0600 runtime CFG evidence
    cmp word ptr ss:[bp + 6], 0
; @0FC80 0F7F:0490 original=7443 runtime CFG evidence
    JE_SHORT loc_0FCC5
; @0FC82 0F7F:0492 original=837e0601 runtime CFG evidence
    cmp word ptr ss:[bp + 6], 1
; @0FC86 0F7F:0496 original=743d runtime CFG evidence
    JE_SHORT loc_0FCC5
; @0FC88 0F7F:0498 original=837e0607 runtime CFG evidence
    cmp word ptr ss:[bp + 6], 7
; @0FC8C 0F7F:049C original=7437 runtime CFG evidence
    JE_SHORT loc_0FCC5
; @0FC8E 0F7F:049E original=837e0604 runtime CFG evidence
    cmp word ptr ss:[bp + 6], 4
; @0FC92 0F7F:04A2 original=757e runtime CFG evidence
    JNE_SHORT loc_0FD12
; @0FC94 0F7F:04A4 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FC97 0F7F:04A7 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FC9C 0F7F:04AC original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FC9F 0F7F:04AF original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FCA4 0F7F:04B4 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FCA7 0F7F:04B7 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FCAC 0F7F:04BC original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FCAF 0F7F:04BF original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FCB4 0F7F:04C4 original=750a runtime CFG evidence
    JNE_SHORT loc_0FCC0
; @0FCB6 0F7F:04C6 original=817e02d000 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 0D0h
; @0FCBB 0F7F:04CB original=7303 runtime CFG evidence
    JAE_SHORT loc_0FCC0
; @0FCBD 0F7F:04CD original=e9b501 runtime CFG evidence
    JMP_NEAR loc_0FE75
; @0FCC0 0F7F:04D0 original=c746060000 runtime CFG evidence
    mov word ptr ss:[bp + 6], 0
; @0FCC5 0F7F:04D5 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FCC8 0F7F:04D8 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FCCD 0F7F:04DD original=7403 runtime CFG evidence
    JE_SHORT loc_0FCD2
; @0FCCF 0F7F:04DF original=e8a401 runtime CFG evidence
    CALL_NEAR loc_0FE76
; @0FCD2 0F7F:04E2 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FCD5 0F7F:04E5 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FCDA 0F7F:04EA original=7403 runtime CFG evidence
    JE_SHORT loc_0FCDF
; @0FCDC 0F7F:04EC original=e89701 runtime CFG evidence
    CALL_NEAR loc_0FE76
; @0FCDF 0F7F:04EF original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FCE2 0F7F:04F2 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FCE7 0F7F:04F7 original=7403 runtime CFG evidence
    JE_SHORT loc_0FCEC
; @0FCE9 0F7F:04F9 original=e88a01 runtime CFG evidence
    CALL_NEAR loc_0FE76
; @0FCEC 0F7F:04FC original=750a runtime CFG evidence
    JNE_SHORT loc_0FCF8
; @0FCEE 0F7F:04FE original=c746360000 runtime CFG evidence
    mov word ptr ss:[bp + 036h], 0
; @0FCF3 0F7F:0503 original=c746060000 runtime CFG evidence
    mov word ptr ss:[bp + 6], 0
; @0FCF8 0F7F:0508 original=837e0220 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 020h
; @0FCFC 0F7F:050C original=7603 runtime CFG evidence
    JBE_SHORT loc_0FD01
; @0FCFE 0F7F:050E original=e97401 runtime CFG evidence
    JMP_NEAR loc_0FE75
; @0FD01 0F7F:0511 original=c746060600 runtime CFG evidence
    mov word ptr ss:[bp + 6], 6
; @0FD06 0F7F:0516 original=f746040200 runtime CFG evidence
    test word ptr ss:[bp + 4], 2
; @0FD0B 0F7F:051B original=7405 runtime CFG evidence
    JE_SHORT loc_0FD12
; @0FD0D 0F7F:051D original=c746060200 runtime CFG evidence
    mov word ptr ss:[bp + 6], 2
; @0FD12 0F7F:0522 original=a12a23 runtime CFG evidence
    mov ax, word ptr ds:[0232Ah]
; @0FD15 0F7F:0525 original=d1e8 runtime CFG evidence
    shr ax, 1
; @0FD17 0F7F:0527 original=d1e8 runtime CFG evidence
    shr ax, 1
; @0FD19 0F7F:0529 original=d1e8 runtime CFG evidence
    shr ax, 1
; @0FD1B 0F7F:052B original=056a01 runtime CFG evidence
    add ax, 016Ah
; @0FD1E 0F7F:052E original=894608 runtime CFG evidence
    mov word ptr ss:[bp + 8], ax
; @0FD21 0F7F:0531 original=803ea99800 runtime CFG evidence
    cmp byte ptr ds:[098A9h], 0
; @0FD26 0F7F:0536 original=7433 runtime CFG evidence
    JE_SHORT loc_0FD5B
; @0FD28 0F7F:0538 original=ff7606 runtime CFG evidence
    push word ptr ss:[bp + 6]
; @0FD2B 0F7F:053B original=c746060400 runtime CFG evidence
    mov word ptr ss:[bp + 6], 4
; @0FD30 0F7F:0540 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FD33 0F7F:0543 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FD38 0F7F:0548 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FD3B 0F7F:054B original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FD40 0F7F:0550 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FD43 0F7F:0553 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FD48 0F7F:0558 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FD4B 0F7F:055B original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FD50 0F7F:0560 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FD53 0F7F:0563 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FD58 0F7F:0568 original=8f4606 runtime CFG evidence
    pop word ptr ss:[bp + 6]
; @0FD5B 0F7F:056B original=a14023 runtime CFG evidence
    mov ax, word ptr ds:[02340h]
; @0FD5E 0F7F:056E original=25ff00 runtime CFG evidence
    and ax, 0FFh
; @0FD61 0F7F:0571 original=3dff00 runtime CFG evidence
    cmp ax, 0FFh
; @0FD64 0F7F:0574 original=750c runtime CFG evidence
    JNE_SHORT loc_0FD72
; @0FD66 0F7F:0576 original=b8e1ba runtime CFG evidence
    mov ax, 0BAE1h
; @0FD69 0F7F:0579 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FD6E 0F7F:057E original=ff064023 runtime CFG evidence
    inc word ptr ds:[02340h]
; @0FD72 0F7F:0582 original=833e402300 runtime CFG evidence
    cmp word ptr ds:[02340h], 0
; @0FD77 0F7F:0587 original=7408 runtime CFG evidence
    JE_SHORT loc_0FD81
; @0FD79 0F7F:0589 original=813e4023bd02 runtime CFG evidence
    cmp word ptr ds:[02340h], 02BDh
; @0FD7F 0F7F:058F original=750c runtime CFG evidence
    JNE_SHORT loc_0FD8D
; @0FD81 0F7F:0591 original=b87674 runtime CFG evidence
    mov ax, 07476h
; @0FD84 0F7F:0594 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FD89 0F7F:0599 original=ff064023 runtime CFG evidence
    inc word ptr ds:[02340h]
; @0FD8D 0F7F:059D original=837e0400 runtime CFG evidence
    cmp word ptr ss:[bp + 4], 0
; @0FD91 0F7F:05A1 original=7475 runtime CFG evidence
    JE_SHORT loc_0FE08
; @0FD93 0F7F:05A3 original=817e04c000 runtime CFG evidence
    cmp word ptr ss:[bp + 4], 0C0h
; @0FD98 0F7F:05A8 original=740b runtime CFG evidence
    JE_SHORT loc_0FDA5
; @0FD9A 0F7F:05AA original=837e0606 runtime CFG evidence
    cmp word ptr ss:[bp + 6], 6
; @0FD9E 0F7F:05AE original=7403 runtime CFG evidence
    JE_SHORT loc_0FDA3
; @0FDA0 0F7F:05B0 original=e99200 runtime CFG evidence
    JMP_NEAR loc_0FE35
; @0FDA3 0F7F:05B3 original=eb2d runtime CFG evidence
    JMP_SHORT loc_0FDD2
; @0FDA5 0F7F:05B5 original=c746060400 runtime CFG evidence
    mov word ptr ss:[bp + 6], 4
; @0FDAA 0F7F:05BA original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDAD 0F7F:05BD original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDB2 0F7F:05C2 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDB5 0F7F:05C5 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDBA 0F7F:05CA original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDBD 0F7F:05CD original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDC2 0F7F:05D2 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDC5 0F7F:05D5 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDCA 0F7F:05DA original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDCD 0F7F:05DD original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDD2 0F7F:05E2 original=c746060600 runtime CFG evidence
    mov word ptr ss:[bp + 6], 6
; @0FDD7 0F7F:05E7 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDDA 0F7F:05EA original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDDF 0F7F:05EF original=7520 runtime CFG evidence
    JNE_SHORT loc_0FE01
; @0FDE1 0F7F:05F1 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDE4 0F7F:05F4 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDE9 0F7F:05F9 original=7516 runtime CFG evidence
    JNE_SHORT loc_0FE01
; @0FDEB 0F7F:05FB original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDEE 0F7F:05FE original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDF3 0F7F:0603 original=750c runtime CFG evidence
    JNE_SHORT loc_0FE01
; @0FDF5 0F7F:0605 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FDF8 0F7F:0608 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FDFD 0F7F:060D original=7502 runtime CFG evidence
    JNE_SHORT loc_0FE01
; @0FDFF 0F7F:060F original=eb68 runtime CFG evidence
    JMP_SHORT loc_0FE69
; @0FE01 0F7F:0611 original=c746060200 runtime CFG evidence
    mov word ptr ss:[bp + 6], 2
; @0FE06 0F7F:0616 original=eb61 runtime CFG evidence
    JMP_SHORT loc_0FE69
; @0FE08 0F7F:0618 original=c746060400 runtime CFG evidence
    mov word ptr ss:[bp + 6], 4
; @0FE0D 0F7F:061D original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE10 0F7F:0620 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE15 0F7F:0625 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE18 0F7F:0628 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE1D 0F7F:062D original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE20 0F7F:0630 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE25 0F7F:0635 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE28 0F7F:0638 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE2D 0F7F:063D original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE30 0F7F:0640 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE35 0F7F:0645 original=c746060200 runtime CFG evidence
    mov word ptr ss:[bp + 6], 2
; @0FE3A 0F7F:064A original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE3D 0F7F:064D original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE42 0F7F:0652 original=7520 runtime CFG evidence
    JNE_SHORT loc_0FE64
; @0FE44 0F7F:0654 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE47 0F7F:0657 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE4C 0F7F:065C original=7516 runtime CFG evidence
    JNE_SHORT loc_0FE64
; @0FE4E 0F7F:065E original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE51 0F7F:0661 original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE56 0F7F:0666 original=750c runtime CFG evidence
    JNE_SHORT loc_0FE64
; @0FE58 0F7F:0668 original=b8d8af runtime CFG evidence
    mov ax, 0AFD8h
; @0FE5B 0F7F:066B original=9a8b8d0000 runtime CFG evidence
    CALL_FAR 00h,08D8Bh
; @0FE60 0F7F:0670 original=7502 runtime CFG evidence
    JNE_SHORT loc_0FE64
; @0FE62 0F7F:0672 original=eb05 runtime CFG evidence
    JMP_SHORT loc_0FE69
; @0FE64 0F7F:0674 original=c746060600 runtime CFG evidence
    mov word ptr ss:[bp + 6], 6
; @0FE69 0F7F:0679 original=817e028000 runtime CFG evidence
    cmp word ptr ss:[bp + 2], 080h
; @0FE6E 0F7F:067E original=7205 runtime CFG evidence
    JB_SHORT loc_0FE75
; @0FE70 0F7F:0680 original=c746060400 runtime CFG evidence
    mov word ptr ss:[bp + 6], 4
; @0FE75 0F7F:0685 original=cb runtime CFG evidence
    retf
; @0FE76 0F7F:0686 original=ff4636 runtime CFG evidence
    inc word ptr ss:[bp + 036h]
; @0FE79 0F7F:0689 original=c746060700 runtime CFG evidence
    mov word ptr ss:[bp + 6], 7
; @0FE7E 0F7F:068E original=837e0460 runtime CFG evidence
    cmp word ptr ss:[bp + 4], 060h
; @0FE82 0F7F:0692 original=7705 runtime CFG evidence
    JA_SHORT loc_0FE89
; @0FE84 0F7F:0694 original=c746060100 runtime CFG evidence
    mov word ptr ss:[bp + 6], 1
; @0FE89 0F7F:0699 original=c3 runtime CFG evidence
    ret
; @0FE8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,08h,062h,01h,0C7h,06h,08h,023h,01h,00h,0B8h,029h,0B7h,09Ah,08Bh
; @0FE9A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Dh,00h,00h,074h,05h,0C7h,046h,018h,080h,00h,0CBh,081h,03Eh,082h,0A4h,09Ch
; @0FEAA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A7h,074h,03h,0E9h,05Ch,01h,083h,07Eh,01Ch,00h,074h,08h,0FFh,04Eh,01Ch,074h
; @0FEBA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,04Eh,01h,080h,03Eh,0A3h,098h,00h,074h,06h,0A1h,0AAh,098h,01h,046h
; @0FECA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,08Bh,046h,08h,03Dh,064h,01h,072h,03h,0E9h,0C8h,00h,0A1h,040h,023h,025h
; @0FEDA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,00h,03Dh,07Dh,00h,074h,04h,0Bh,0C0h,075h,011h,0FFh,06h,040h,023h,0C7h
; @0FEEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,064h,01h,0C7h,046h,020h,03h,00h,0E9h,016h,01h,080h,03Eh,0A6h,098h
; @0FEFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,011h,0C6h,06h,0A6h,098h,00h,0B8h,076h,074h,09Ah,08Bh,08Dh,00h,00h
; @0FF0A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,06h,040h,023h,080h,03Eh,0A3h,098h,00h,074h,017h,0A1h,0AAh,098h,01h,046h
; @0FF1A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,083h,07Eh,04h,00h,074h,07h,081h,07Eh,04h,0C0h,00h,075h,04h,0FEh,06h
; @0FF2A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A2h,098h,08Bh,046h,034h,03Bh,046h,02h,074h,03Fh,08Bh,046h,032h,025h,0FEh,0FFh
; @0FF3A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,066h,04h,0FEh,0A3h,04h,023h,08Bh,046h,034h,025h,0FEh,0FFh,083h,066h,02h
; @0FF4A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FEh,0A3h,06h,023h,0C7h,06h,08h,023h,01h,00h,0B8h,0B2h,05Dh,09Ah,08Bh,08Dh
; @0FF5A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0C7h,046h,08h,060h,01h,0A1h,028h,023h,0D1h,0E8h,0D1h,0E8h,075h,03h
; @0FF6A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,09Fh,00h,0FFh,046h,08h,0E9h,099h,00h,080h,03Eh,0A4h,098h,00h,074h,014h
; @0FF7A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,046h,02h,0Ch,083h,046h,034h,0Ch,081h,07Eh,02h,0B0h,00h,072h,05h,0C7h
; @0FF8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,034h,020h,00h,08Bh,046h,04h,0D1h,0E8h,025h,01h,00h,05h,062h,01h,089h
; @0FF9A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,0EBh,06Eh,080h,03Eh,0A4h,098h,00h,074h,010h,083h,046h,034h,0Ch,081h
; @0FFAA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,034h,0B0h,00h,072h,05h,0C7h,046h,034h,020h,00h,03Dh,068h,01h,073h,0Ch
; @0FFBA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,026h,023h,03h,075h,04Bh,0FFh,046h,08h,0EBh,046h,083h,046h,02h,05h
; @0FFCA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,08h,068h,01h,0A1h,028h,023h,0D1h,0E8h,0D1h,0E8h,074h,03h,0FFh,046h
; @0FFDA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,081h,07Eh,02h,0E0h,00h,076h,02Ah,0C7h,046h,02h,00h,00h,083h,03Eh,026h
; @0FFEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,03h,074h,014h,0B8h,095h,04Dh,09Ah,08Bh,08Dh,00h,00h,080h,0FBh,0C0h,077h
; @0FFFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F3h,032h,0FFh,089h,05Eh,04h
part07 ends
end
