; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part15 segment byte public 'CODE'
assume cs:part15,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; @1E000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E0A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E0B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E0C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E0D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E0E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E0F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E1A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E1B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E1C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E1D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E1E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E1F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E2A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E2B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E2C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E2D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E2E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E2F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E3A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E3B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E3C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E3D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E3E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E3F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E4A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E4B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E4C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E4D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E4E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E4F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E5A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E5B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E5C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E5D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E5E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E5F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E6A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E6B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E6C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E6D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E6E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E6F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E7A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E7B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E7C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E7D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E7E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E7F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E8A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E8B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E8C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E8D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,05Ch,02Bh,094h,02Bh,0CCh,02Bh,04h,02Ch,03Ch,02Ch,074h,02Ch
; @1E8E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ACh,02Ch,0E4h,02Ch,01Ch,02Dh,054h,02Dh,08Ch,02Dh,0C4h,02Dh,0FCh,02Dh,034h,02Eh
; @1E8F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Ch,02Eh,0A4h,02Eh,0DCh,02Eh,014h,02Fh,04Ch,02Fh,084h,02Fh,0BCh,02Fh,0F4h,02Fh
; @1E900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ch,030h,064h,030h,09Ch,030h,0D4h,030h,0Ch,031h,044h,031h,07Ch,031h,0B4h,031h
; @1E910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ECh,031h,024h,032h,05Ch,032h,094h,032h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E9A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E9B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E9C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E9D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E9E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1E9F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EA90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EAA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EAB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EAC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EAD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EAE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EAF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EB90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EBA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EBB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EBC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EBD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EBE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EBF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EC90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ECA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ECB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ECC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ECD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ECE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ECF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1ED90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EDA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EDB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EDC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EDD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EDE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EDF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EE90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EEA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EEB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EEC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EEE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EEF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EF90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EFA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EFB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EFC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EFD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EFE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1EFF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F0A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F0B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F0C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F0D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F0E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F0F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,0B4h,023h,05Ch,02Bh,00h,00h,0CBh,07Bh
; @1F1A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,079h,06h,07Bh,03Fh,07Ch,0A2h,07Ch,0C8h,07Dh,01h,00h,00h,00h,01h,00h
; @1F1B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,082h,096h,08Ch,096h
; @1F1C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,096h,0A0h,096h,024h,00h,0D7h,083h,0AFh,044h,00h,00h,0DEh,083h,02h,084h
; @1F1D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,0E4h,083h,0Ah,084h,02h,00h,0EAh,083h,012h,084h,03h,00h,0F0h,083h
; @1F1E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ah,084h,04h,00h,0F6h,083h,022h,084h,05h,00h,0FCh,083h,02Ah,084h,0FFh,0FFh
; @1F1F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0AFh,044h,024h,00h,0D7h,083h,0AFh,044h,06h,00h,037h,084h,03Dh,084h
; @1F200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,00h,045h,084h,04Eh,084h,0FFh,0FFh,0FFh,0FFh,0AFh,044h,024h,00h,0D7h,083h
; @1F210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,044h,09h,00h,056h,084h,063h,084h,0Ah,00h,068h,084h,09Dh,084h,0Bh,00h
; @1F220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A2h,084h,0C3h,084h,0FFh,0FFh,0FFh,0FFh,0AFh,044h,024h,00h,0D7h,083h,0AFh,044h
; @1F230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Dh,00h,0C9h,084h,0D6h,084h,0Eh,00h,0F0h,084h,0FDh,084h,0FFh,0FFh,0FFh,0FFh
; @1F240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AFh,044h,00h,00h,00h,00h,0Fh,00h,04h,096h,00h,00h,00h,00h,00h,00h
; @1F250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,00h,034h,096h,00h,00h,00h,00h,00h,00h,013h,00h,04Ch,096h,00h,00h
; @1F260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,015h,00h,06Ah,096h,00h,00h,00h,00h,01h,02h,03h,04h
; @1F270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,05h,04h,03h,02h,01h
; @1F280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,01h,00h,02h,00h,02h,00h,01h,00h,01h,00h
; @1F290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,02h,00h,01h,00h,047h,01h,0BEh,00h,0BEh,00h
; @1F2A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,01h,045h,01h,045h,01h,047h,01h,045h,01h,00h,00h,04h,00h,02h,00h
; @1F2B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,040h,00h,040h,00h,090h,00h,080h,00h,090h,00h,0A0h,00h,030h,00h
; @1F2C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,0A0h,00h,050h,00h,0A0h,00h,030h,075h,060h,00h,0A0h,00h,060h,00h
; @1F2D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,050h,00h,00h,00h,050h,00h,00h,00h,010h,00h,080h,00h,010h,00h
; @1F2E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,075h,060h,00h,0A0h,00h,070h,00h,090h,00h,080h,00h,00h,00h,080h,00h
; @1F2F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0C0h,00h,080h,00h,0C0h,00h,030h,075h,070h,00h,080h,00h,00h,00h
; @1F300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,060h,00h,070h,00h,060h,00h,030h,00h,0C0h,00h,00h,00h,0C0h,00h
; @1F310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,060h,00h,060h,00h,090h,00h,030h,075h,060h,00h,060h,00h,0A0h,00h
; @1F320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,075h,060h,00h,0B0h,00h,0C0h,00h,0B0h,00h,00h,00h,0A0h,00h,00h,00h
; @1F330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,0C0h,00h,090h,00h,0C0h,00h,090h,00h,00h,00h,080h,00h,00h,00h
; @1F340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,0C0h,00h,030h,075h,060h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h
; @1F350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,094h,097h,011h,023h,01Eh,014h,018h,017h,026h,01Fh,023h,018h,013h,014h
; @1F360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,022h,012h,00h,0A6h,097h,026h,017h,021h,012h,017h,031h,014h,023h,012h,021h
; @1F370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,01Fh,014h,026h,01Eh,031h,012h,00h,0BAh,097h,030h,018h,031h,016h,01Fh,02Eh
; @1F380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,012h,01Eh,014h,018h,031h,00h,0C9h,097h,032h,015h,031h,01Eh,032h,012h,017h
; @1F390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,01Fh,032h,017h,014h,023h,00h,0D9h,097h,022h,017h,030h,01Fh,014h,032h,017h
; @1F3A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 013h,01Fh,02Eh,023h,031h,012h,026h,026h,021h,012h,016h,012h,013h,00h,0F0h,097h
; @1F3B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 013h,012h,032h,017h,031h,020h,032h,012h,014h,018h,01Fh,032h,017h,026h,012h,015h
; @1F3C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,016h,025h,031h,018h,011h,014h,023h,012h,018h,026h,020h,021h,013h,017h,012h
; @1F3D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 031h,020h,01Fh,026h,017h,031h,012h,00h,01Ah,098h,012h,02Fh,012h,013h,015h,020h
; @1F3E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,015h,017h,020h,017h,012h,00h,090h,010h,00h,010h,00h,040h,00h,040h,00h
; @1F3F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,040h,00h,020h,00h,020h,00h,00h,00h,00h,00h,050h,00h,030h,00h
; @1F400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,070h,00h,030h,00h,090h,00h,040h,00h,090h,00h,020h,00h,0B0h,00h
; @1F410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,070h,00h,020h,00h,050h,00h,040h,00h,0A0h,00h,050h,00h,0C0h,00h
; @1F420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,090h,00h,050h,00h,060h,00h,040h,00h,040h,00h,030h,00h,030h,00h
; @1F430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,010h,00h,030h,00h,090h,00h,010h,00h,0C0h,00h,00h,00h,0B0h,00h
; @1F440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,020h,00h,030h,00h,080h,00h,010h,00h,00h,00h,030h,00h,060h,00h
; @1F450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,010h,00h,00h,00h,060h,00h,020h,00h,090h,00h,040h,00h,080h,00h
; @1F460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,02h,00h,0FFh,0FFh,00h,00h
; @1F470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F4A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F4B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F4C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F4D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F4E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F4F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,04h,0Dh,09h,090h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F5A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F5B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F5C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F5D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F5E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F5F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F6A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F6B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F6C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F6D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F6E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F6F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F7A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F7B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F7C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F7D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F7E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F7F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F8A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F8B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F8C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F8D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F8E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F8F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F9A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F9B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F9C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F9D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F9E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1F9F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FA90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FAA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FAB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FAC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FAD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FAE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FAF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FB90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FBA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FBB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FBC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FBD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FBE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FBF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FC90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FCA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FCB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FCC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FCD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FCE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FCF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FD90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FDA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FDB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FDC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FDD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FDE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FDF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FE90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FEA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FEB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FEC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FEE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FEF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @1FF00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,0FFh,02h,06h,02h,04h,03h,05h,04h
; @1FF10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,01h,07h,00h,00h,02h,06h,02h,0AAh,00h,058h,00h,00h,00h,058h,00h
; @1FF20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,090h,00h,00h,00h,00h
; Offset pairs at DS:A368; three adjacent pairs, caller index bound not proven.
; @1FF28 reviewed offset pair 0 field Y, signed value 16
    dw 010h
; @1FF2A reviewed offset pair 0 field X, signed value -8
    dw 0FFF8h
; @1FF2C reviewed offset pair 1 field Y, signed value 12
    dw 0Ch
; @1FF2E reviewed offset pair 1 field X, signed value -12
    dw 0FFF4h
; @1FF30 reviewed offset pair 2 field Y, signed value 15
    dw 0Fh
; @1FF32 reviewed offset pair 2 field X, signed value -13
    dw 0FFF3h
; Offset pairs at DS:A374; three adjacent pairs, caller index bound not proven.
; @1FF34 reviewed offset pair 0 field Y, signed value 16
    dw 010h
; @1FF36 reviewed offset pair 0 field X, signed value 24
    dw 018h
; @1FF38 reviewed offset pair 1 field Y, signed value 12
    dw 0Ch
; @1FF3A reviewed offset pair 1 field X, signed value 28
    dw 01Ch
; @1FF3C reviewed offset pair 2 field Y, signed value 15
    dw 0Fh
; @1FF3E reviewed offset pair 2 field X, signed value 29
    dw 01Dh
; Offset pairs at DS:A380; three adjacent pairs, caller index bound not proven.
; @1FF40 reviewed offset pair 0 field Y, signed value 20
    dw 014h
; @1FF42 reviewed offset pair 0 field X, signed value -20
    dw 0FFECh
; @1FF44 reviewed offset pair 1 field Y, signed value 16
    dw 010h
; @1FF46 reviewed offset pair 1 field X, signed value -24
    dw 0FFE8h
; @1FF48 reviewed offset pair 2 field Y, signed value 19
    dw 013h
; @1FF4A reviewed offset pair 2 field X, signed value -25
    dw 0FFE7h
; Offset pairs at DS:A38C; three adjacent pairs, caller index bound not proven.
; @1FF4C reviewed offset pair 0 field Y, signed value 20
    dw 014h
; @1FF4E reviewed offset pair 0 field X, signed value 36
    dw 024h
; @1FF50 reviewed offset pair 1 field Y, signed value 16
    dw 010h
; @1FF52 reviewed offset pair 1 field X, signed value 40
    dw 028h
; @1FF54 reviewed offset pair 2 field Y, signed value 19
    dw 013h
; @1FF56 reviewed offset pair 2 field X, signed value 41
    dw 029h
; @1FF58 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h
; @1FF60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,06h,00h,0Ch,00h,00h,00h,0Ch,00h
; @1FF70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0Ch,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @1FF80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @1FF90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @1FFA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,020h,00h
; @1FFB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,00h,010h,00h,020h,00h,098h,00h,013h,00h,040h,00h,028h,00h,016h,00h
; @1FFC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,088h,00h,019h,00h,00h,00h,00h,00h,00h,00h,00h,01h,02h,03h
; @1FFD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,03h,02h,01h,019h,00h,08h,00h,016h,00h,08h,00h,018h,00h,08h,00h
; @1FFE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0FFh,08h,00h,0F3h,0FFh,08h,00h,0F2h,0FFh,08h,00h,00h,00h,00h,00h
; @1FFF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0B4h,023h,050h,00h,0B0h,00h
part15 ends
end
