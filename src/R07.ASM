; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part07 segment byte public 'CODE'
assume cs:part07,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
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
    db 0EEh,00h,065h,04Eh,0EFh,00h,065h,04Eh,0FFh,0FFh,08Bh,046h,04h,0A3h,0FEh,0D1h
; @0EFB4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,02h,0A3h,00h,0D2h,08Bh,05Eh,018h,0D1h,0E3h,02Eh,0FFh,0A7h,0C4h,0EFh
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
    db 00h,08Bh,0DDh,0B8h,0E2h,074h,09Ah,08Bh,08Dh,00h,00h,0CBh,08Bh,036h,082h,0A4h
; @0FA6E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,05h,020h,00h,0A3h,06h,023h,0ADh,0A3h,04h,023h,0C7h,06h,08h,023h,03h
; @0FA7E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0B8h,0B2h,05Dh,09Ah,08Bh,08Dh,00h,00h,083h,03Eh,0Ah,023h,00h,075h,03h
; @0FA8E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0A7h,01h,083h,07Eh,018h,013h,075h,03h,0E9h,088h,01h,083h,07Eh,018h,015h
; @0FA9E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,033h,01h,083h,07Eh,018h,01Ch,075h,03h,0E9h,0EAh,00h,083h,07Eh
; @0FAAE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,01Fh,075h,03h,0E9h,0A3h,00h,083h,07Eh,018h,07Dh,074h,03Eh,083h,06h,082h
; @0FABE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,08h,083h,03Ch,0FFh,075h,03h,0E9h,070h,01h,0B8h,0F4h,081h,09Ah,08Bh,08Dh
; @0FACE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,083h,0FBh,0FFh,075h,03h,0E9h,060h,01h,0ADh,05h,020h,00h,089h,047h
; @0FADE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,0ADh,089h,047h,032h,0C7h,047h,018h,07Fh,00h,0C7h,047h,01Ch,014h,00h,0C7h
; @0FAEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,020h,05h,00h,0FFh,06h,07Eh,0A4h,0E9h,03Fh,01h,083h,06h,082h,0A4h,08h
; @0FAFE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Ch,0FFh,075h,03h,0E9h,032h,01h,0B8h,0F4h,081h,09Ah,08Bh,08Dh,00h,00h
; @0FB0E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FBh,0FFh,075h,03h,0E9h,022h,01h,0ADh,05h,020h,00h,089h,047h,034h,0ADh
; @0FB1E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,047h,032h,0C7h,047h,06h,02h,00h,0D1h,0E8h,0D1h,0E8h,0D1h,0E8h,0D1h,0E8h
; @0FB2E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,01h,00h,074h,05h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,081h,00h,0C7h
; @0FB3E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,01Ch,019h,00h,0C7h,047h,020h,05h,00h,0C7h,047h,0Ah,00h,00h,0C7h,047h
; @0FB4E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 036h,00h,00h,0FFh,06h,07Eh,0A4h,0E9h,0E0h,00h,083h,06h,082h,0A4h,04h,0B9h
; @0FB5E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,051h,0B8h,0F4h,081h,09Ah,08Bh,08Dh,00h,00h,08Bh,036h,042h,0A8h,083h
; @0FB6E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,042h,0A8h,04h,083h,0FBh,0FFh,074h,019h,0ADh,05h,020h,00h,089h,047h,034h
; @0FB7E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ADh,089h,047h,032h,0C7h,047h,018h,020h,00h,0C7h,047h,01Ch,0FFh,0FFh,0FFh,06h
; @0FB8E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,0A4h,059h,0E2h,0CDh,0E9h,0A2h,00h,083h,06h,082h,0A4h,08h,0B8h,0F4h,081h
; @0FB9E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ah,08Bh,08Dh,00h,00h,083h,0FBh,0FFh,075h,03h,0E9h,08Dh,00h,0ADh,05h,020h
; @0FBAE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,089h,047h,034h,0ADh,089h,047h,032h,0C7h,047h,018h,01Dh,00h,083h,07Eh,04h
; @0FBBE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,075h,0Ah,0C7h,047h,018h,01Eh,00h,0C7h,047h,08h,043h,00h,0C7h,047h,01Ch
; @0FBCE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,00h,0FFh,06h,07Eh,0A4h,0EBh,062h,083h,06h,082h,0A4h,08h,083h,03Ch,0FFh
; @0FBDE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,058h,0B8h,0F4h,081h,09Ah,08Bh,08Dh,00h,00h,083h,0FBh,0FFh,074h,04Bh,0ADh
; @0FBEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,020h,00h,089h,047h,034h,0ADh,089h,047h,032h,0C7h,047h,018h,016h,00h,0C7h
; @0FBFE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,036h,0D4h,0A5h,083h,07Eh,02h,040h,074h,0Ah,0C7h,047h,018h,017h,00h,0C7h
; @0FC0E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,036h,0C4h,0A5h,0C7h,047h,01Ch,014h,00h,0C7h,047h,020h,03h,00h,0FFh,06h
; @0FC1E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,0A4h,0EBh,016h,083h,06h,082h,0A4h,04h,0B8h,0F4h,081h,09Ah,08Bh,08Dh,00h
; @0FC2E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,083h,0FBh,0FFh,074h,04h,0FFh,06h,07Eh,0A4h,08Bh,046h,06h,05h,03Bh,00h
; @0FC3E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,0CBh,0C7h,046h,08h,06Ah,01h,0C7h,06h,08h,023h,01h,00h,0FFh
; @0FC4E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,06h,0B8h,029h,0B7h,09Ah,08Bh,08Dh,00h,00h,08Fh,046h,06h,074h,05h,0C7h
; @0FC5E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,018h,093h,00h,0CBh,081h,03Eh,082h,0A4h,0F0h,0A6h,074h,03h,0E9h,0FBh,01h
; @0FC6E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,01Ch,00h,074h,08h,0FFh,04Eh,01Ch,074h,03h,0E9h,0EDh,01h,083h,07Eh
; @0FC7E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,00h,074h,043h,083h,07Eh,06h,01h,074h,03Dh,083h,07Eh,06h,07h,074h,037h
; @0FC8E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,06h,04h,075h,07Eh,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h
; @0FC9E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h
; @0FCAE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,09Ah,08Bh,08Dh,00h,00h,075h,0Ah,081h,07Eh,02h,0D0h,00h,073h,03h,0E9h
; @0FCBE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B5h,01h,0C7h,046h,06h,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,074h
; @0FCCE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E8h,0A4h,01h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,074h,03h,0E8h,097h
; @0FCDE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,074h,03h,0E8h,08Ah,01h,075h,0Ah
; @0FCEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,036h,00h,00h,0C7h,046h,06h,00h,00h,083h,07Eh,02h,020h,076h,03h
; @0FCFE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,074h,01h,0C7h,046h,06h,06h,00h,0F7h,046h,04h,02h,00h,074h,05h,0C7h
; @0FD0E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,06h,02h,00h,0A1h,02Ah,023h,0D1h,0E8h,0D1h,0E8h,0D1h,0E8h,05h,06Ah,01h
; @0FD1E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,046h,08h,080h,03Eh,0A9h,098h,00h,074h,033h,0FFh,076h,06h,0C7h,046h,06h
; @0FD2E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh
; @0FD3E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh
; @0FD4E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,08Fh,046h,06h,0A1h,040h,023h
; @0FD5E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,0FFh,00h,03Dh,0FFh,00h,075h,0Ch,0B8h,0E1h,0BAh,09Ah,08Bh,08Dh,00h,00h
; @0FD6E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,06h,040h,023h,083h,03Eh,040h,023h,00h,074h,08h,081h,03Eh,040h,023h,0BDh
; @0FD7E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,075h,0Ch,0B8h,076h,074h,09Ah,08Bh,08Dh,00h,00h,0FFh,06h,040h,023h,083h
; @0FD8E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,04h,00h,074h,075h,081h,07Eh,04h,0C0h,00h,074h,0Bh,083h,07Eh,06h,06h
; @0FD9E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,092h,00h,0EBh,02Dh,0C7h,046h,06h,04h,00h,0B8h,0D8h,0AFh,09Ah
; @0FDAE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah
; @0FDBE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah
; @0FDCE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,08Dh,00h,00h,0C7h,046h,06h,06h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h
; @0FDDE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,075h,020h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,075h,016h,0B8h,0D8h,0AFh
; @0FDEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ah,08Bh,08Dh,00h,00h,075h,0Ch,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,075h
; @0FDFE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0EBh,068h,0C7h,046h,06h,02h,00h,0EBh,061h,0C7h,046h,06h,04h,00h,0B8h
; @0FE0E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h
; @0FE1E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0B8h
; @0FE2E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,0C7h,046h,06h,02h,00h,0B8h,0D8h,0AFh,09Ah
; @0FE3E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,08Dh,00h,00h,075h,020h,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,075h,016h
; @0FE4E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,0D8h,0AFh,09Ah,08Bh,08Dh,00h,00h,075h,0Ch,0B8h,0D8h,0AFh,09Ah,08Bh,08Dh
; @0FE5E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,075h,02h,0EBh,05h,0C7h,046h,06h,06h,00h,081h,07Eh,02h,080h,00h
; @0FE6E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,05h,0C7h,046h,06h,04h,00h,0CBh,0FFh,046h,036h,0C7h,046h,06h,07h,00h
; @0FE7E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,04h,060h,077h,05h,0C7h,046h,06h,01h,00h,0C3h,0C7h,046h,08h,062h
; @0FE8E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C7h,06h,08h,023h,01h,00h,0B8h,029h,0B7h,09Ah,08Bh,08Dh,00h,00h,074h
; @0FE9E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,0C7h,046h,018h,080h,00h,0CBh,081h,03Eh,082h,0A4h,09Ch,0A7h,074h,03h,0E9h
; @0FEAE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Ch,01h,083h,07Eh,01Ch,00h,074h,08h,0FFh,04Eh,01Ch,074h,03h,0E9h,04Eh,01h
; @0FEBE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0A3h,098h,00h,074h,06h,0A1h,0AAh,098h,01h,046h,032h,08Bh,046h,08h
; @0FECE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Dh,064h,01h,072h,03h,0E9h,0C8h,00h,0A1h,040h,023h,025h,0FFh,00h,03Dh,07Dh
; @0FEDE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,04h,0Bh,0C0h,075h,011h,0FFh,06h,040h,023h,0C7h,046h,08h,064h,01h
; @0FEEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,020h,03h,00h,0E9h,016h,01h,080h,03Eh,0A6h,098h,00h,074h,011h,0C6h
; @0FEFE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0A6h,098h,00h,0B8h,076h,074h,09Ah,08Bh,08Dh,00h,00h,0FFh,06h,040h,023h
; @0FF0E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0A3h,098h,00h,074h,017h,0A1h,0AAh,098h,01h,046h,04h,083h,07Eh,04h
; @0FF1E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,074h,07h,081h,07Eh,04h,0C0h,00h,075h,04h,0FEh,06h,0A2h,098h,08Bh,046h
; @0FF2E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,03Bh,046h,02h,074h,03Fh,08Bh,046h,032h,025h,0FEh,0FFh,083h,066h,04h,0FEh
; @0FF3E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A3h,04h,023h,08Bh,046h,034h,025h,0FEh,0FFh,083h,066h,02h,0FEh,0A3h,06h,023h
; @0FF4E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,08h,023h,01h,00h,0B8h,0B2h,05Dh,09Ah,08Bh,08Dh,00h,00h,0C7h,046h
; @0FF5E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,060h,01h,0A1h,028h,023h,0D1h,0E8h,0D1h,0E8h,075h,03h,0E9h,09Fh,00h,0FFh
; @0FF6E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,0E9h,099h,00h,080h,03Eh,0A4h,098h,00h,074h,014h,083h,046h,02h,0Ch
; @0FF7E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,046h,034h,0Ch,081h,07Eh,02h,0B0h,00h,072h,05h,0C7h,046h,034h,020h,00h
; @0FF8E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,046h,04h,0D1h,0E8h,025h,01h,00h,05h,062h,01h,089h,046h,08h,0EBh,06Eh
; @0FF9E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0A4h,098h,00h,074h,010h,083h,046h,034h,0Ch,081h,07Eh,034h,0B0h,00h
; @0FFAE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,05h,0C7h,046h,034h,020h,00h,03Dh,068h,01h,073h,0Ch,083h,03Eh,026h,023h
; @0FFBE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,075h,04Bh,0FFh,046h,08h,0EBh,046h,083h,046h,02h,05h,0C7h,046h,08h,068h
; @0FFCE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0A1h,028h,023h,0D1h,0E8h,0D1h,0E8h,074h,03h,0FFh,046h,08h,081h,07Eh,02h
; @0FFDE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E0h,00h,076h,02Ah,0C7h,046h,02h,00h,00h,083h,03Eh,026h,023h,03h,074h,014h
; @0FFEE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,095h,04Dh,09Ah,08Bh,08Dh,00h,00h,080h,0FBh,0C0h,077h,0F3h,032h,0FFh,089h
; @0FFFE UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Eh,04h
part07 ends
end
