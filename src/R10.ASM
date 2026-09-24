; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part10 segment byte public 'CODE'
assume cs:part10,ds:nothing,ss:nothing,es:nothing
chunk_base label byte

loc_15385 equ 01385h
loc_153AE equ 013AEh
loc_153BB equ 013BBh
loc_153C5 equ 013C5h
loc_153D0 equ 013D0h
loc_153DF equ 013DFh
loc_15892 equ 01892h
loc_158A4 equ 018A4h
loc_158B2 equ 018B2h
loc_158D4 equ 018D4h
loc_15906 equ 01906h
loc_15919 equ 01919h
loc_15922 equ 01922h
loc_1592A equ 0192Ah
loc_15938 equ 01938h
loc_15941 equ 01941h
loc_15955 equ 01955h
loc_1595F equ 0195Fh
loc_15979 equ 01979h
loc_15982 equ 01982h
loc_1598A equ 0198Ah
loc_1599B equ 0199Bh
loc_159CC equ 019CCh
loc_159D7 equ 019D7h
loc_159E0 equ 019E0h
loc_159EE equ 019EEh
loc_159F2 equ 019F2h
loc_159FF equ 019FFh
loc_15A0C equ 01A0Ch
loc_15A18 equ 01A18h
loc_15A21 equ 01A21h
loc_15A6D equ 01A6Dh
loc_15A7A equ 01A7Ah
loc_15A95 equ 01A95h
loc_15AA1 equ 01AA1h
loc_15AB1 equ 01AB1h
loc_15ABE equ 01ABEh
loc_15AC0 equ 01AC0h
loc_15AC7 equ 01AC7h
loc_15AD7 equ 01AD7h
loc_15AD9 equ 01AD9h
; @14000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @140A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @140B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @140C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @140D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @140E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @140F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @141A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @141B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @141C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @141D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @141E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @141F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @142A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @142B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @142C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @142D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @142E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @142F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @143A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @143B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @143C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @143D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @143E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @143F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @144A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @144B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @144C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @144D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @144E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @144F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @145A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @145B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @145C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @145D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @145E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @145F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @146A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @146B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @146C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @146D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @146E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @146F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @147A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @147B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @147C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @147D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @147E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @147F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @148A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @148B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @148C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @148D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @148E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @148F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @149A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @149B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @149C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @149D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @149E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @149F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14A90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14AA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14AB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14AC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14AD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14AE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14AF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14B90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14BA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14BB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14BC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14BD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14BE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14BF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14C90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14CA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14CB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14CC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14CD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14CE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14CF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14D90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14DA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14DB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14DC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14DD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14DE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14DF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14E90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14EA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14EB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14EC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14ED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14EE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14EF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14F90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14FA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14FB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14FC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14FD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14FE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @14FF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @150A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @150B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @150C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @150D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @150E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @150F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @151A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @151B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @151C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @151D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @151E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @151F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @152A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @152B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @152C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @152D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @152E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @152F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h
; @15346 1534:0006 original=83c406 runtime CFG evidence
    add sp, 6
; @15349 1534:0009 original=58 runtime CFG evidence
    pop ax
; @1534A 1534:000A original=8bc7 runtime CFG evidence
    mov ax, di
; @1534C 1534:000C original=5b runtime CFG evidence
    pop bx
; @1534D 1534:000D original=59 runtime CFG evidence
    pop cx
; @1534E 1534:000E original=5a runtime CFG evidence
    pop dx
; @1534F 1534:000F original=5e runtime CFG evidence
    pop si
; @15350 1534:0010 original=5f runtime CFG evidence
    pop di
; @15351 1534:0011 original=5d runtime CFG evidence
    pop bp
; @15352 1534:0012 original=1f runtime CFG evidence
    pop ds
; @15353 1534:0013 original=07 runtime CFG evidence
    pop es
; @15354 1534:0014 original=2e8f060000 runtime CFG evidence
    pop word ptr cs:[0]
; @15359 1534:0019 original=2e8f060200 runtime CFG evidence
    pop word ptr cs:[2]
; @1535E 1534:001E original=2e8f060400 runtime CFG evidence
    pop word ptr cs:[4]
; @15363 1534:0023 original=2e830e040001 runtime CFG evidence
    or word ptr cs:[4], 1
; @15369 1534:0029 original=2eff360400 runtime CFG evidence
    push word ptr cs:[4]
; @1536E 1534:002E original=0e runtime CFG evidence
    push cs
; @1536F 1534:002F original=2ec70604004e00 runtime CFG evidence
    mov word ptr cs:[4], 04Eh
; @15376 1534:0036 original=2eff360400 runtime CFG evidence
    push word ptr cs:[4]
; @1537B 1534:003B original=cf runtime CFG evidence
    iret
; sub_1534_003C
; @1537C 1534:003C original=b024
    mov al, 024h
; @1537E 1534:003E original=ba0600
    mov dx, 6
; @15381 1534:0041 original=e80100
    CALL_NEAR loc_15385
; @15384 1534:0044 original=cb
    retf
; sub_1534_0045
; @15385 1534:0045 original=1e
    push ds
; @15386 1534:0046 original=0e
    push cs
; @15387 1534:0047 original=1f
    pop ds
; @15388 1534:0048 original=b425
    mov ah, 025h
; @1538A 1534:004A original=cd21
    int 021h
; @1538C 1534:004C original=1f
    pop ds
; @1538D 1534:004D original=c3
    ret
; @1538E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ch,050h,0B4h,019h,0CDh,021h,058h,09Dh,02Eh,0FFh,02Eh,00h,00h,00h,00h,00h
; @1539E UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h
; sub_153A_0000
; @153A0 153A:0000 original=a90080
    test ax, 08000h
; @153A3 153A:0003 original=7409
    JE_SHORT loc_153AE
; @153A5 153A:0005 original=50
    push ax
; @153A6 153A:0006 original=25ff00
    and ax, 0FFh
; @153A9 153A:0009 original=2ea33a07
    mov word ptr cs:[073Ah], ax
; @153AD 153A:000D original=58
    pop ax
; @153AE 153A:000E original=a90040
    test ax, 04000h
; @153B1 153A:0011 original=7412
    JE_SHORT loc_153C5
; @153B3 153A:0013 original=50
    push ax
; @153B4 153A:0014 original=57
    push di
; @153B5 153A:0015 original=06
    push es
; @153B6 153A:0016 original=0e
    push cs
; @153B7 153A:0017 original=07
    pop es
; @153B8 153A:0018 original=bfae07
    mov di, 07AEh
; @153BB 153A:001B original=a4
    movsb
; @153BC 153A:001C original=807cffff
    cmp byte ptr ds:[si - 1], 0FFh
; @153C0 153A:0020 original=75f9
    JNE_SHORT loc_153BB
; @153C2 153A:0022 original=07
    pop es
; @153C3 153A:0023 original=5f
    pop di
; @153C4 153A:0024 original=58
    pop ax
; @153C5 153A:0025 original=a90020
    test ax, 02000h
; @153C8 153A:0028 original=7406
    JE_SHORT loc_153D0
; @153CA 153A:002A original=50
    push ax
; @153CB 153A:002B original=0e
    push cs
; @153CC 153A:002C original=e89e06
    CALL_NEAR loc_15A6D
; @153CF 153A:002F original=58
    pop ax
; @153D0 153A:0030 original=a90010
    test ax, 01000h
; @153D3 153A:0033 original=740a
    JE_SHORT loc_153DF
; @153D5 153A:0035 original=2e8c063e07
    mov word ptr cs:[073Eh], es
; @153DA 153A:003A original=2e893e3c07
    mov word ptr cs:[073Ch], di
; @153DF 153A:003F original=cb
    retf
; @153E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 057h,06h,0Eh,0E8h,091h,04h,07h,05Fh,072h,012h,053h,051h,052h,0Eh,0E8h,06Fh
; @153F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,05Ah,059h,05Bh,09Ch,050h,0Eh,0E8h,06Ah,06h,058h,09Dh,0CBh,01Eh,0Eh,07h
; @15400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0F2h,0BFh,045h,03h,0FCh,0A4h,080h,07Ch,0FFh,00h,074h,06h,080h,07Ch,0FFh
; @15410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,075h,0F3h,026h,0C6h,045h,0FFh,00h,04Eh,02Eh,089h,036h,085h,03h,02Eh,08Ch
; @15420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,087h,03h,0Eh,01Fh,0C7h,06h,089h,03h,00h,00h,0C6h,06h,044h,03h,01h
; @15430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BAh,045h,03h,0Eh,0E8h,040h,04h,073h,03h,0E9h,05Ch,02h,0B9h,01Bh,00h,033h
; @15440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D2h,0BFh,0A5h,03h,0Eh,07h,0Eh,0E8h,016h,03h,0C6h,06h,044h,03h,02h,073h
; @15450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,044h,02h,0BFh,0A5h,03h,081h,03Eh,0A5h,03h,04Dh,05Ah,0C6h,06h,044h
; @15460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,04h,074h,03h,0E9h,031h,02h,08Bh,01Eh,0ADh,03h,033h,0C9h,03h,0DBh,083h
; @15470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,00h,03h,0DBh,083h,0D1h,00h,03h,0DBh,083h,0D1h,00h,03h,0DBh,083h,0D1h
; @15480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,089h,01Eh,091h,03h,089h,0Eh,093h,03h,0A1h,0A9h,03h,048h,03h,0C0h,0B6h
; @15490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,08Ah,0D4h,08Ah,0E0h,08Ah,0C6h,03h,06h,0A7h,03h,083h,0D2h,00h,02Bh,0C3h
; @154A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Bh,0D1h,0A3h,095h,03h,089h,016h,097h,03h,0D1h,0EAh,0D1h,0D8h,0D1h,0EAh,0D1h
; @154B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D8h,0D1h,0EAh,0D1h,0D8h,0D1h,0EAh,0D1h,0D8h,05h,011h,00h,01h,06h,0AFh,03h
; @154C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,089h,03h,00h,00h,0BBh,0FFh,0FFh,0B4h,048h,0CDh,021h,0B4h,048h,0CDh
; @154D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,0C6h,06h,044h,03h,03h,073h,03h,0E9h,0BDh,01h,0A3h,089h,03h,0B4h,02Fh
; @154E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,021h,089h,01Eh,08Dh,03h,08Ch,06h,08Fh,03h,0B4h,051h,0CDh,021h,089h,01Eh
; @154F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,03h,08Eh,06h,089h,03h,08Eh,01Eh,08Bh,03h,033h,0F6h,08Bh,0FEh,0B9h,00h
; @15500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0FCh,0F3h,0A4h,0Eh,01Fh,08Eh,06h,089h,03h,0BFh,081h,00h,0C5h,036h,085h
; @15510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0A4h,080h,07Ch,0FFh,00h,075h,0F9h,04Eh,026h,0C6h,045h,0FFh,0Dh,026h,0C6h
; @15520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,0Eh,01Fh,02Bh,036h,085h,03h,08Bh,0C6h,026h,0A2h,080h,00h,08Bh,0Eh
; @15530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 091h,03h,08Bh,016h,093h,03h,083h,0E9h,01Bh,083h,0DAh,00h,08Bh,01Eh,044h,07h
; @15540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 087h,0CAh,0B8h,01h,042h,0CDh,021h,0C6h,06h,044h,03h,02h,073h,03h,0E9h,047h
; @15550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,08Bh,0Eh,095h,03h,08Bh,016h,097h,03h,0A1h,089h,03h,05h,010h,00h,08Eh
; @15560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,033h,0FFh,08Bh,01Eh,044h,07h,0Eh,0E8h,0F5h,01h,0C6h,06h,044h,03h,02h
; @15570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,03h,0E9h,023h,01h,0BEh,05Ch,07h,08Bh,04Ch,05h,08Bh,054h,07h,03h,0Eh
; @15580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AAh,07h,013h,016h,0ACh,07h,03h,0Eh,0BDh,03h,083h,0D2h,00h,087h,0CAh,08Bh
; @15590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,044h,07h,0B8h,00h,042h,0CDh,021h,0C6h,06h,044h,03h,02h,073h,03h,0E9h
; @155A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F6h,00h,083h,03Eh,0ABh,03h,00h,074h,04Ah,0B9h,04h,00h,0BFh,099h,03h,0Eh
; @155B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,08Bh,01Eh,044h,07h,0Eh,0E8h,0A7h,01h,0C6h,06h,044h,03h,02h,073h,03h
; @155C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0D5h,00h,0A1h,099h,03h,08Bh,01Eh,09Bh,03h,08Bh,0F0h,083h,0E6h,0Fh,0D1h
; @155D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,0D1h,0D8h,0D1h,0EBh,0D1h,0D8h,0D1h,0EBh,0D1h,0D8h,0D1h,0EBh,0D1h,0D8h,08Bh
; @155E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Eh,089h,03h,083h,0C1h,010h,03h,0C1h,08Eh,0C0h,026h,01h,0Ch,0FFh,0Eh,0ABh
; @155F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0EBh,0AFh,08Bh,01Eh,044h,07h,0Eh,0E8h,069h,04h,0C7h,06h,044h,07h,00h
; @15600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0A1h,0BBh,03h,03h,06h,089h,03h,05h,010h,00h,0A3h,09Fh,03h,0A1h,0B9h
; @15610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0A3h,09Dh,03h,0A1h,0B3h,03h,03h,06h,089h,03h,05h,010h,00h,0A3h,0B3h
; @15620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0B8h,021h,035h,0CDh,021h,089h,01Eh,03Dh,03h,08Ch,06h,03Fh,03h,0BAh,01Ah
; @15630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0B8h,021h,025h,0CDh,021h,08Eh,01Eh,089h,03h,0BAh,080h,00h,0B4h,01Ah,0CDh
; @15640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,0Eh,01Fh,0FAh,089h,026h,0A1h,03h,08Ch,016h,0A3h,03h,08Eh,016h,0B3h,03h
; @15650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,026h,0B5h,03h,0FBh,0A1h,089h,03h,08Eh,0C0h,08Eh,0D8h,033h,0C0h,08Bh,0D8h
; @15660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Bh,0C8h,08Bh,0D0h,08Bh,0F0h,08Bh,0F8h,08Bh,0E8h,02Eh,0FFh,02Eh,09Dh,03h,0Eh
; @15670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,0A2h,043h,03h,0FAh,08Bh,026h,0A1h,03h,08Eh,016h,0A3h,03h,0FBh,0B8h,021h
; @15680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,0C5h,016h,03Dh,03h,0CDh,021h,0Eh,01Fh,0C5h,016h,08Dh,03h,0B4h,01Ah,0CDh
; @15690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,0Eh,01Fh,0C6h,06h,044h,03h,00h,083h,03Eh,089h,03h,00h,074h,0Eh,08Eh
; @156A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,089h,03h,0B4h,049h,0CDh,021h,0C7h,06h,089h,03h,00h,00h,08Bh,01Eh,044h
; @156B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,0Eh,0E8h,0AFh,03h,0A1h,043h,03h,01Fh,0CBh,080h,0FCh,04Ch,075h,0Fh,02Eh
; @156C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,041h,03h,00h,074h,0A8h,02Eh,0FFh,0Eh,041h,03h,0EBh,0Ah,080h,0FCh
; @156D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Bh,075h,05h,02Eh,0FFh,06h,041h,03h,02Eh,0FFh,02Eh,03Dh,03h,00h,00h,00h
; @156E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @156F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,089h,01Eh,0Ch,04h,08Bh,0C1h,0Bh,0C2h,074h,038h,01Eh,06h,01Fh,053h,051h
; @15770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 052h,057h,0Bh,0D2h,075h,05h,083h,0F9h,0FFh,072h,03h,0B9h,0FFh,0FFh,08Bh,0D7h
; @15780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B4h,03Fh,051h,0CDh,021h,05Dh,072h,01Eh,05Fh,05Ah,059h,05Bh,02Bh,0CDh,083h,0DAh
; @15790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03h,0FDh,073h,07h,08Ch,0D8h,05h,00h,010h,08Eh,0D8h,08Bh,0C1h,0Bh,0C2h
; @157A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,0CCh,01Fh,033h,0C0h,0CBh,05Fh,05Ah,059h,05Bh,01Fh,0CBh,00h,00h,02Eh,089h
; @157B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,05Ch,04h,08Bh,0C1h,0Bh,0C2h,074h,03Ah,08Bh,0FEh,01Eh,06h,01Fh,053h,051h
; @157C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 052h,057h,0Bh,0D2h,075h,05h,083h,0F9h,0FFh,072h,03h,0B9h,0FFh,0FFh,08Bh,0D7h
; @157D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B4h,040h,051h,0CDh,021h,072h,01Fh,05Dh,05Fh,05Ah,059h,05Bh,02Bh,0CDh,083h,0DAh
; @157E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,03h,0FDh,073h,07h,08Ch,0D8h,05h,00h,010h,08Eh,0D8h,08Bh,0C1h,0Bh,0C2h
; @157F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,0CCh,01Fh,033h,0C0h,0CBh,05Fh,05Ah,059h,05Bh,01Fh,0CBh,00h,00h,02Eh,089h
; @15800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,0D3h,04h,02Eh,0A3h,0D5h,04h,02Eh,0F7h,06h,03Ah,07h,04h,00h,074h,0Ah
; @15810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,08Eh,06h,03Eh,07h,02Eh,08Bh,03Eh,03Ch,07h,02Eh,089h,03Eh,03Ch,07h,08Bh
; @15820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C1h,0Bh,0C2h,074h,043h,033h,0FFh,01Eh,06h,01Fh,053h,051h,052h,057h,0Bh,0D2h
; @15830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,07h,02Eh,03Bh,0Eh,0D1h,04h,072h,05h,02Eh,08Bh,0Eh,0D1h,04h,08Bh,0D7h
; @15840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B4h,03Fh,051h,0CDh,021h,072h,024h,02Eh,08Bh,01Eh,0D5h,04h,0B8h,00h,040h,0CDh
; @15850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 021h,05Dh,072h,017h,03Bh,0C5h,075h,013h,05Fh,05Ah,059h,05Bh,02Bh,0CDh,083h,0DAh
; @15860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,08Bh,0C1h,0Bh,0C2h,075h,0C3h,01Fh,033h,0C0h,0CBh,05Fh,05Ah,059h,05Bh,01Fh
; @15870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CBh,00h,00h,00h,00h,00h,00h
; sub_153A_04D7
; @15877 153A:04D7 original=56
    push si
; @15878 153A:04D8 original=57
    push di
; @15879 153A:04D9 original=2e89164607
    mov word ptr cs:[0746h], dx
; @1587E 153A:04DE original=2e8c1e4807
    mov word ptr cs:[0748h], ds
; @15883 153A:04E3 original=1e
    push ds
; @15884 153A:04E4 original=06
    push es
; @15885 153A:04E5 original=0e
    push cs
; @15886 153A:04E6 original=1f
    pop ds
; @15887 153A:04E7 original=f7063a070100
    test word ptr ds:[073Ah], 1
; @1588D 153A:04ED original=7403
    JE_SHORT loc_15892
; @1588F 153A:04EF original=e98f01
    JMP_NEAR loc_15A21
; @15892 153A:04F2 original=c70644070000
    mov word ptr ds:[0744h], 0
; @15898 153A:04F8 original=a14007
    mov ax, word ptr ds:[0740h]
; @1589B 153A:04FB original=a34207
    mov word ptr ds:[0742h], ax
; @1589E 153A:04FE original=c70644070000
    mov word ptr ds:[0744h], 0
; @158A4 153A:0504 original=8b164007
    mov dx, word ptr ds:[0740h]
; @158A8 153A:0508 original=b8023d
    mov ax, 03D02h
; @158AB 153A:050B original=cd21
    int 021h
; @158AD 153A:050D original=7303
    JAE_SHORT loc_158B2
; @158AF 153A:050F original=e92e01
    JMP_NEAR loc_159E0
; @158B2 153A:0512 original=a34407
    mov word ptr ds:[0744h], ax
; @158B5 153A:0515 original=c706aa070000
    mov word ptr ds:[07AAh], 0
; @158BB 153A:051B original=c706ac070000
    mov word ptr ds:[07ACh], 0
; @158C1 153A:0521 original=ba4a07
    mov dx, 074Ah
; @158C4 153A:0524 original=b90c00
    mov cx, 0Ch
; @158C7 153A:0527 original=8b1e4407
    mov bx, word ptr ds:[0744h]
; @158CB 153A:052B original=b43f
    mov ah, 03Fh
; @158CD 153A:052D original=cd21
    int 021h
; @158CF 153A:052F original=7303
    JAE_SHORT loc_158D4
; @158D1 153A:0531 original=e90c01
    JMP_NEAR loc_159E0
; @158D4 153A:0534 original=813e4a074d5a
    cmp word ptr ds:[074Ah], 05A4Dh
; @158DA 153A:053A original=753d
    JNE_SHORT loc_15919
; @158DC 153A:053C original=a14e07
    mov ax, word ptr ds:[074Eh]
; @158DF 153A:053F original=48
    dec ax
; @158E0 153A:0540 original=03c0
    add ax, ax
; @158E2 153A:0542 original=b600
    mov dh, 0
; @158E4 153A:0544 original=8ad4
    mov dl, ah
; @158E6 153A:0546 original=8ae0
    mov ah, al
; @158E8 153A:0548 original=8ac6
    mov al, dh
; @158EA 153A:054A original=03064c07
    add ax, word ptr ds:[074Ch]
; @158EE 153A:054E original=83d200
    adc dx, 0
; @158F1 153A:0551 original=a3aa07
    mov word ptr ds:[07AAh], ax
; @158F4 153A:0554 original=8916ac07
    mov word ptr ds:[07ACh], dx
; @158F8 153A:0558 original=8bc8
    mov cx, ax
; @158FA 153A:055A original=87ca
    xchg cx, dx
; @158FC 153A:055C original=b80042
    mov ax, 04200h
; @158FF 153A:055F original=cd21
    int 021h
; @15901 153A:0561 original=7303
    JAE_SHORT loc_15906
; @15903 153A:0563 original=e9da00
    JMP_NEAR loc_159E0
; @15906 153A:0566 original=ba4a07
    mov dx, 074Ah
; @15909 153A:0569 original=b90c00
    mov cx, 0Ch
; @1590C 153A:056C original=8b1e4407
    mov bx, word ptr ds:[0744h]
; @15910 153A:0570 original=b43f
    mov ah, 03Fh
; @15912 153A:0572 original=cd21
    int 021h
; @15914 153A:0574 original=7303
    JAE_SHORT loc_15919
; @15916 153A:0576 original=e9c700
    JMP_NEAR loc_159E0
; @15919 153A:0579 original=be4e07
    mov si, 074Eh
; @1591C 153A:057C original=bf5607
    mov di, 0756h
; @1591F 153A:057F original=b90600
    mov cx, 6
; @15922 153A:0582 original=ac
    lodsb
; @15923 153A:0583 original=3a05
    cmp al, byte ptr ds:[di]
; @15925 153A:0585 original=7403
    JE_SHORT loc_1592A
; @15927 153A:0587 original=e9b600
    JMP_NEAR loc_159E0
; @1592A 153A:058A original=47
    inc di
; @1592B 153A:058B original=e2f5
    LOOP_SHORT loc_15922
; @1592D 153A:058D original=8b0e4a07
    mov cx, word ptr ds:[074Ah]
; @15931 153A:0591 original=0bc9
    or cx, cx
; @15933 153A:0593 original=7503
    JNE_SHORT loc_15938
; @15935 153A:0595 original=e9a800
    JMP_NEAR loc_159E0
; @15938 153A:0598 original=81f92003
    cmp cx, 0320h
; @1593C 153A:059C original=7203
    JB_SHORT loc_15941
; @1593E 153A:059E original=e99f00
    JMP_NEAR loc_159E0
; @15941 153A:05A1 original=ba5c07
    mov dx, 075Ch
; @15944 153A:05A4 original=8b0e5407
    mov cx, word ptr ds:[0754h]
; @15948 153A:05A8 original=8b1e4407
    mov bx, word ptr ds:[0744h]
; @1594C 153A:05AC original=b43f
    mov ah, 03Fh
; @1594E 153A:05AE original=cd21
    int 021h
; @15950 153A:05B0 original=7303
    JAE_SHORT loc_15955
; @15952 153A:05B2 original=e98b00
    JMP_NEAR loc_159E0
; @15955 153A:05B5 original=bf5c07
    mov di, 075Ch
; @15958 153A:05B8 original=8b0e5407
    mov cx, word ptr ds:[0754h]
; @1595C 153A:05BC original=a14c07
    mov ax, word ptr ds:[074Ch]
; @1595F 153A:05BF original=3005
    xor byte ptr ds:[di], al
; @15961 153A:05C1 original=47
    inc di
; @15962 153A:05C2 original=02c4
    add al, ah
; @15964 153A:05C4 original=e2f9
    LOOP_SHORT loc_1595F
; @15966 153A:05C6 original=a34c07
    mov word ptr ds:[074Ch], ax
; @15969 153A:05C9 original=be5c07
    mov si, 075Ch
; @1596C 153A:05CC original=83c60d
    add si, 0Dh
; @1596F 153A:05CF original=c43e4607
    les di, dword ptr ds:[0746h]
; @15973 153A:05D3 original=b403
    mov ah, 3
; @15975 153A:05D5 original=0e
    push cs
; @15976 153A:05D6 original=e82801
    CALL_NEAR loc_15AA1
; @15979 153A:05D9 original=26803d20
    cmp byte ptr es:[di], 020h
; @1597D 153A:05DD original=7503
    JNE_SHORT loc_15982
; @1597F 153A:05DF original=47
    inc di
; @15980 153A:05E0 original=ebf7
    JMP_SHORT loc_15979
; @15982 153A:05E2 original=803c20
    cmp byte ptr ds:[si], 020h
; @15985 153A:05E5 original=7503
    JNE_SHORT loc_1598A
; @15987 153A:05E7 original=46
    inc si
; @15988 153A:05E8 original=ebf8
    JMP_SHORT loc_15982
; @1598A 153A:05EA original=268a05
    mov al, byte ptr es:[di]
; @1598D 153A:05ED original=47
    inc di
; @1598E 153A:05EE original=8a24
    mov ah, byte ptr ds:[si]
; @15990 153A:05F0 original=46
    inc si
; @15991 153A:05F1 original=3c61
    cmp al, 061h
; @15993 153A:05F3 original=7206
    JB_SHORT loc_1599B
; @15995 153A:05F5 original=3c7a
    cmp al, 07Ah
; @15997 153A:05F7 original=7702
    JA_SHORT loc_1599B
; @15999 153A:05F9 original=245f
    and al, 05Fh
; @1599B 153A:05FB original=3ac4
    cmp al, ah
; @1599D 153A:05FD original=7538
    JNE_SHORT loc_159D7
; @1599F 153A:05FF original=0ac0
    or al, al
; @159A1 153A:0601 original=75d6
    JNE_SHORT loc_15979
; @159A3 153A:0603 original=0ae4
    or ah, ah
; @159A5 153A:0605 original=7530
    JNE_SHORT loc_159D7
; @159A7 153A:0607 original=be5c07
    mov si, 075Ch
; @159AA 153A:060A original=8b5405
    mov dx, word ptr ds:[si + 5]
; @159AD 153A:060D original=8b4c07
    mov cx, word ptr ds:[si + 7]
; @159B0 153A:0610 original=0316aa07
    add dx, word ptr ds:[07AAh]
; @159B4 153A:0614 original=130eac07
    adc cx, word ptr ds:[07ACh]
; @159B8 153A:0618 original=b80042
    mov ax, 04200h
; @159BB 153A:061B original=8b1e4407
    mov bx, word ptr ds:[0744h]
; @159BF 153A:061F original=cd21
    int 021h
; @159C1 153A:0621 original=721d
    JB_SHORT loc_159E0
; @159C3 153A:0623 original=be5c07
    mov si, 075Ch
; @159C6 153A:0626 original=8b4c09
    mov cx, word ptr ds:[si + 9]
; @159C9 153A:0629 original=8b540b
    mov dx, word ptr ds:[si + 0Bh]
; @159CC 153A:062C original=a14407
    mov ax, word ptr ds:[0744h]
; @159CF 153A:062F original=8bd8
    mov bx, ax
; @159D1 153A:0631 original=f8
    clc
; @159D2 153A:0632 original=07
    pop es
; @159D3 153A:0633 original=1f
    pop ds
; @159D4 153A:0634 original=5f
    pop di
; @159D5 153A:0635 original=5e
    pop si
; @159D6 153A:0636 original=cb
    retf
; @159D7 153A:0637 original=ff0e4a07
    dec word ptr ds:[074Ah]
; @159DB 153A:063B original=7403
    JE_SHORT loc_159E0
; @159DD 153A:063D original=e961ff
    JMP_NEAR loc_15941
; @159E0 153A:0640 original=8b1e4407
    mov bx, word ptr ds:[0744h]
; @159E4 153A:0644 original=0bdb
    or bx, bx
; @159E6 153A:0646 original=7406
    JE_SHORT loc_159EE
; @159E8 153A:0648 original=b43e
    mov ah, 03Eh
; @159EA 153A:064A original=cd21
    int 021h
; @159EC 153A:064C original=721e
    JB_SHORT loc_15A0C
; @159EE 153A:064E original=8b364007
    mov si, word ptr ds:[0740h]
; @159F2 153A:0652 original=ac
    lodsb
; @159F3 153A:0653 original=0ac0
    or al, al
; @159F5 153A:0655 original=75fb
    JNE_SHORT loc_159F2
; @159F7 153A:0657 original=803cff
    cmp byte ptr ds:[si], 0FFh
; @159FA 153A:065A original=7503
    JNE_SHORT loc_159FF
; @159FC 153A:065C original=beae07
    mov si, 07AEh
; @159FF 153A:065F original=89364007
    mov word ptr ds:[0740h], si
; @15A03 153A:0663 original=3b364207
    cmp si, word ptr ds:[0742h]
; @15A07 153A:0667 original=7403
    JE_SHORT loc_15A0C
; @15A09 153A:0669 original=e998fe
    JMP_NEAR loc_158A4
; @15A0C 153A:066C original=8b1e4407
    mov bx, word ptr ds:[0744h]
; @15A10 153A:0670 original=0bdb
    or bx, bx
; @15A12 153A:0672 original=7404
    JE_SHORT loc_15A18
; @15A14 153A:0674 original=b43e
    mov ah, 03Eh
; @15A16 153A:0676 original=cd21
    int 021h
; @15A18 153A:0678 original=b80200
    mov ax, 2
; @15A1B 153A:067B original=f9
    stc
; @15A1C 153A:067C original=07
    pop es
; @15A1D 153A:067D original=1f
    pop ds
; @15A1E 153A:067E original=5f
    pop di
; @15A1F 153A:067F original=5e
    pop si
; @15A20 153A:0680 original=cb
    retf
; @15A21 153A:0681 original=c70644070000
    mov word ptr ds:[0744h], 0
; @15A27 153A:0687 original=c43e4607
    les di, dword ptr ds:[0746h]
; @15A2B 153A:068B original=b402
    mov ah, 2
; @15A2D 153A:068D original=0e
    push cs
; @15A2E 153A:068E original=e87000
    CALL_NEAR loc_15AA1
; @15A31 153A:0691 original=8bd7
    mov dx, di
; @15A33 153A:0693 original=1e
    push ds
; @15A34 153A:0694 original=06
    push es
; @15A35 153A:0695 original=1f
    pop ds
; @15A36 153A:0696 original=b8023d
    mov ax, 03D02h
; @15A39 153A:0699 original=cd21
    int 021h
; @15A3B 153A:069B original=1f
    pop ds
; @15A3C 153A:069C original=72ce
    JB_SHORT loc_15A0C
; @15A3E 153A:069E original=a34407
    mov word ptr ds:[0744h], ax
; @15A41 153A:06A1 original=33c9
    xor cx, cx
; @15A43 153A:06A3 original=8bd1
    mov dx, cx
; @15A45 153A:06A5 original=8bd8
    mov bx, ax
; @15A47 153A:06A7 original=b80242
    mov ax, 04202h
; @15A4A 153A:06AA original=cd21
    int 021h
; @15A4C 153A:06AC original=72be
    JB_SHORT loc_15A0C
; @15A4E 153A:06AE original=50
    push ax
; @15A4F 153A:06AF original=52
    push dx
; @15A50 153A:06B0 original=33c9
    xor cx, cx
; @15A52 153A:06B2 original=8bd1
    mov dx, cx
; @15A54 153A:06B4 original=8b1e4407
    mov bx, word ptr ds:[0744h]
; @15A58 153A:06B8 original=b80042
    mov ax, 04200h
; @15A5B 153A:06BB original=cd21
    int 021h
; @15A5D 153A:06BD original=5a
    pop dx
; @15A5E 153A:06BE original=59
    pop cx
; @15A5F 153A:06BF original=72ab
    JB_SHORT loc_15A0C
; @15A61 153A:06C1 original=e968ff
    JMP_NEAR loc_159CC
; @15A64 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Bh,0DBh,074h,04h,0B4h,03Eh,0CDh,021h,0CBh
; sub_153A_06CD
; @15A6D 153A:06CD original=b451
    mov ah, 051h
; @15A6F 153A:06CF original=cd21
    int 021h
; @15A71 153A:06D1 original=8ec3
    mov es, bx
; @15A73 153A:06D3 original=268e062c00
    mov es, word ptr es:[02Ch]
; @15A78 153A:06D8 original=33f6
    xor si, si
; @15A7A 153A:06DA original=268a04
    mov al, byte ptr es:[si]
; @15A7D 153A:06DD original=46
    inc si
; @15A7E 153A:06DE original=0ac0
    or al, al
; @15A80 153A:06E0 original=75f8
    JNE_SHORT loc_15A7A
; @15A82 153A:06E2 original=268a04
    mov al, byte ptr es:[si]
; @15A85 153A:06E5 original=0ac0
    or al, al
; @15A87 153A:06E7 original=75f1
    JNE_SHORT loc_15A7A
; @15A89 153A:06E9 original=83c603
    add si, 3
; @15A8C 153A:06EC original=1e
    push ds
; @15A8D 153A:06ED original=0e
    push cs
; @15A8E 153A:06EE original=06
    push es
; @15A8F 153A:06EF original=1f
    pop ds
; @15A90 153A:06F0 original=07
    pop es
; @15A91 153A:06F1 original=fc
    cld
; @15A92 153A:06F2 original=bfae07
    mov di, 07AEh
; @15A95 153A:06F5 original=a4
    movsb
; @15A96 153A:06F6 original=807cff00
    cmp byte ptr ds:[si - 1], 0
; @15A9A 153A:06FA original=75f9
    JNE_SHORT loc_15A95
; @15A9C 153A:06FC original=b0ff
    mov al, 0FFh
; @15A9E 153A:06FE original=aa
    stosb
; @15A9F 153A:06FF original=1f
    pop ds
; @15AA0 153A:0700 original=cb
    retf
; sub_153A_0701
; @15AA1 153A:0701 original=2ef7063a070200
    test word ptr cs:[073Ah], 2
; @15AA8 153A:0708 original=742f
    JE_SHORT loc_15AD9
; @15AAA 153A:070A original=f6c401
    test ah, 1
; @15AAD 153A:070D original=7411
    JE_SHORT loc_15AC0
; @15AAF 153A:070F original=8bee
    mov bp, si
; @15AB1 153A:0711 original=ac
    lodsb
; @15AB2 153A:0712 original=0ac0
    or al, al
; @15AB4 153A:0714 original=7408
    JE_SHORT loc_15ABE
; @15AB6 153A:0716 original=3c5c
    cmp al, 05Ch
; @15AB8 153A:0718 original=75f7
    JNE_SHORT loc_15AB1
; @15ABA 153A:071A original=8bee
    mov bp, si
; @15ABC 153A:071C original=ebf3
    JMP_SHORT loc_15AB1
; @15ABE 153A:071E original=8bf5
    mov si, bp
; @15AC0 153A:0720 original=f6c402
    test ah, 2
; @15AC3 153A:0723 original=7414
    JE_SHORT loc_15AD9
; @15AC5 153A:0725 original=8bef
    mov bp, di
; @15AC7 153A:0727 original=268a05
    mov al, byte ptr es:[di]
; @15ACA 153A:072A original=47
    inc di
; @15ACB 153A:072B original=0ac0
    or al, al
; @15ACD 153A:072D original=7408
    JE_SHORT loc_15AD7
; @15ACF 153A:072F original=3c5c
    cmp al, 05Ch
; @15AD1 153A:0731 original=75f4
    JNE_SHORT loc_15AC7
; @15AD3 153A:0733 original=8bef
    mov bp, di
; @15AD5 153A:0735 original=ebf0
    JMP_SHORT loc_15AC7
; @15AD7 153A:0737 original=8bfd
    mov di, bp
; @15AD9 153A:0739 original=cb
    retf
; @15ADA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,0AEh,07h,00h,00h,00h,00h,00h,00h,00h,00h
; @15AEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,053h,048h,041h,044h
; @15AFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Fh,057h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15B0A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15B1A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15B2A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15B3A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15B4A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15B5A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15B6A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15B7A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15B8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15B9A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15BAA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15BBA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @15BCA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,011h,08h,00h,010h
; @15BDA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,043h,045h,04Eh,054h,052h,045h,020h,053h,054h,049h,043h,04Bh,020h,048h,041h
; @15BEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,044h,04Ch,045h,020h,041h,04Eh,044h,020h,050h,055h,053h,048h,020h,046h,049h
; @15BFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 052h,045h,00h,090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @15C0A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,020h,0Ch,020h,0Ch
; @15C1A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
; @15C2A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
; @15C3A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,07h,020h,07h
; @15C4A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @15C5A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,053h,0Ch,04Eh,0Ch,041h,0Ch,046h,0Ch,055h,0Ch,020h,0Ch
; @15C6A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Ch,056h,0Ch,034h,0Ch,02Eh,0Ch,032h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
; @15C7A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch,020h,0Ch
; @15C8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Ch,020h,0Ch,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @15C9A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @15CAA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,0Eh,020h,0Eh
; @15CBA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15CCA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15CDA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15CEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15CFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15D0A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15D1A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15D2A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15D3A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15D4A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15D5A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh,020h,0Eh,044h,0Eh
; @15D6A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,0Eh,073h,0Eh,063h,0Eh,072h,0Eh,069h,0Eh,070h,0Eh,074h,0Eh,06Fh,0Eh
; @15D7A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,02Ah,0Eh,02Eh,0Eh,02Ah,0Eh
; @15D8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,048h,0Eh
; @15D9A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,0Eh,06Ch,0Eh,070h,0Eh,020h,0Eh,04Dh,0Eh,065h,0Eh,06Eh,0Eh,075h,0Eh
; @15DAA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
; @15DBA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15DCA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,04Ch,0Eh,06Fh,0Eh,067h,0Eh,067h,0Eh,065h,0Eh,064h,0Eh,020h,0Eh
; @15DDA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,0Eh,072h,0Eh,069h,0Eh,076h,0Eh,065h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh
; @15DEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
; @15DFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,04Eh,0Eh,06Fh,0Eh,02Eh,0Eh,054h,0Eh,061h,0Eh,067h,0Eh
; @15E0A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 067h,0Eh,065h,0Eh,064h,0Eh,020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh
; @15E1A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,034h,0Eh,020h,0Eh,020h,0Eh
; @15E2A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,044h,0Eh
; @15E3A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 049h,0Eh,052h,0Eh,020h,0Eh,04Ah,0Eh,075h,0Eh,073h,0Eh,074h,0Eh,069h,0Eh
; @15E4A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,0Eh,079h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
; @15E5A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15E6A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,055h,0Eh,073h,0Eh,065h,0Eh,020h,0Eh,052h,0Eh,061h,0Eh,06Dh,0Eh
; @15E7A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,0Eh,069h,0Eh,073h,0Eh,06Bh,0Eh,020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh
; @15E8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,0Eh,04Fh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
; @15E9A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,056h,0Eh,065h,0Eh,072h,0Eh,069h,0Eh,066h,0Eh,079h,0Eh
; @15EAA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh,073h,0Eh,020h,0Eh,020h,0Eh
; @15EBA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh
; @15ECA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,049h,0Eh
; @15EDA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 067h,0Eh,06Eh,0Eh,06Fh,0Eh,072h,0Eh,065h,0Eh,020h,0Eh,048h,0Eh,069h,0Eh
; @15EEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,0Eh,064h,0Eh,065h,0Eh,06Eh,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
; @15EFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,04Fh,0Eh,04Eh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15F0A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,04Ch,0Eh,069h,0Eh,073h,0Eh,074h,0Eh,069h,0Eh,06Eh,0Eh,067h,0Eh
; @15F1A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,046h,0Eh,069h,0Eh,06Ch,0Eh,065h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh
; @15F2A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,0Eh,04Fh,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
; @15F3A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,052h,0Eh,065h,0Eh,063h,0Eh,075h,0Eh,072h,0Eh,073h,0Eh
; @15F4A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,0Eh,020h,0Eh,053h,0Eh,075h,0Eh,062h,0Eh,044h,0Eh,049h,0Eh,052h,0Eh
; @15F5A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh,04Fh,0Eh,046h,0Eh,046h,0Eh
; @15F6A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,051h,0Eh
; @15F7A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,0Eh,065h,0Eh,072h,0Eh,079h,0Eh,020h,0Eh,044h,0Eh,065h,0Eh,06Ch,0Eh
; @15F8A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,0Eh,074h,0Eh,065h,0Eh,073h,0Eh,020h,0Eh,03Dh,0Eh,020h,0Eh,020h,0Eh
; @15F9A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,04Fh,0Eh,046h,0Eh,046h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15FAA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15FBA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15FCA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,0Eh,020h,0Eh
; @15FDA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15FEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @15FFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh
part10 ends
end
