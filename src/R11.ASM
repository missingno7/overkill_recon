; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part11 segment byte public 'CODE'
assume cs:part11,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; @16000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @16010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @16020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @16030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @16040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @16050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @16060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh
; @16070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,0Eh,020h,0Eh,020h,0Eh,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @160A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @160B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @160C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @160D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @160E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @160F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,07h,041h,07h,052h,07h,054h,07h,031h,07h,020h,07h,020h,07h,020h,07h
; @16130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,047h,07h,04Fh,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,02Eh,07h,042h,07h,041h,07h,054h,07h,020h,07h,020h,07h
; @16160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,043h,07h,04Fh,07h,042h,07h,04Fh,07h
; @16170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Ch,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,048h,07h,04Ch,07h,050h,07h
; @16180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @161A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @161B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @161C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,07h,041h,07h,050h,07h,045h,07h,044h,07h,020h,07h,020h,07h,020h,07h
; @161D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,045h,07h,058h,07h,045h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @161E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,045h,07h,058h,07h,049h,07h,054h,07h,020h,07h,020h,07h
; @161F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,02Eh,07h,042h,07h,041h,07h,054h,07h,020h,07h,020h,07h
; @16200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,053h,07h,054h,07h,045h,07h,042h,07h
; @16210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,07h,052h,07h,047h,07h,020h,07h,02Eh,07h,043h,07h,054h,07h,059h,07h
; @16220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,07h,050h,07h,047h,07h,052h,07h,041h,07h,042h,07h,020h,07h,020h,07h
; @16270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,045h,07h,058h,07h,045h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,05Ch,07h,04Ch,07h,049h,07h,053h,07h,054h,07h,049h,07h,04Eh,07h
; @16290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,07h,053h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @162A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,042h,07h,049h,07h,04Eh,07h,043h,07h
; @162B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Fh,07h,04Dh,07h,050h,07h,020h,07h,02Eh,07h,045h,07h,058h,07h,045h,07h
; @162C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @162D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @162E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @162F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Ch,07h,049h,07h,053h,07h,054h,07h,041h,07h,04Ch,07h,04Ch,07h,020h,07h
; @16310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,042h,07h,041h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,042h,07h,04Fh,07h,052h,07h,052h,07h,04Fh,07h,057h,07h
; @16330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,07h,044h,07h,02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,02Ah,07h
; @16340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,05Ch,071h,042h,071h,041h,071h,043h,071h,04Bh,071h
; @16350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,071h,050h,071h,035h,071h,020h,071h,02Eh,071h,020h,071h,020h,071h,020h,071h
; @16360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @163A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,07h,050h,07h,04Fh,07h,04Fh,07h,04Ch,07h,020h,07h,020h,07h,020h,07h
; @163B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @163C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,052h,07h,045h,07h,046h,07h,045h,07h,052h,07h,045h,07h
; @163D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,07h,043h,07h,02Eh,07h,045h,07h,053h,07h,020h,07h,020h,07h,020h,07h
; @163E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @163F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @16400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,05Ch,07h
; @16440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 042h,07h,041h,07h,043h,07h,04Bh,07h,055h,07h,050h,07h,036h,07h,020h,07h
; @16450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,04Dh,07h,059h,07h,046h,07h,049h,07h,04Ch,07h,045h,07h
; @16470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,07h,031h,07h,02Eh,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @164A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @164B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @164C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @164D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @164E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,07h,04Eh,07h,041h,07h,04Dh,07h,045h,07h,053h,07h,020h,07h,020h,07h
; @164F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,041h,07h,04Ch,07h,04Ch,07h,050h,07h,052h,07h,04Fh,07h
; @16510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,07h,053h,07h,02Eh,07h,04Ch,07h,05Ah,07h,048h,07h,020h,07h,020h,07h
; @16520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @16540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,07h,04Dh,07h,050h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @165A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,042h,07h,041h,07h,043h,07h,04Bh,07h,055h,07h,050h,07h
; @165B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,07h,020h,07h,02Eh,07h,041h,07h,052h,07h,043h,07h,020h,07h,020h,07h
; @165C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @165D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @165E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @165F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Ch,07h,049h,07h,042h,07h,031h,07h,030h,07h,020h,07h,020h,07h,020h,07h
; @16630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,04Ch,07h,049h,07h,042h,07h,020h,07h,02Ah,07h,020h,07h,020h,07h
; @16640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,043h,07h,04Fh,07h,04Eh,07h,054h,07h,045h,07h,04Eh,07h
; @16650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,07h,053h,07h,02Eh,07h,054h,07h,058h,07h,054h,07h,020h,07h,02Ah,07h
; @16660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @16680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @166A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @166B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @166C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 058h,07h,043h,07h,055h,07h,054h,07h,031h,07h,020h,07h,020h,07h,020h,07h
; @166D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,043h,07h,04Fh,07h,04Dh,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @166E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,052h,07h,045h,07h,041h,07h,044h,07h,020h,07h,020h,07h
; @166F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,02Eh,07h,04Dh,07h,045h,07h,020h,07h,020h,07h,020h,07h
; @16700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @16720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,07h,052h,07h,04Fh,07h,044h,07h,055h,07h,043h,07h,054h,07h,053h,07h
; @16770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,04Ch,07h,053h,07h,054h,07h,020h,07h,02Ah,07h,020h,07h,020h,07h
; @16780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,04Dh,07h,041h,07h,04Eh,07h,047h,07h,04Ch,07h,045h,07h
; @16790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,02Eh,07h,045h,07h,058h,07h,045h,07h,020h,07h,020h,07h
; @167A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @167B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @167C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @167D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @167E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @167F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,07h,04Ch,07h,04Fh,07h,057h,07h,043h,07h,048h,07h,052h,07h,054h,07h
; @16810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,046h,07h,04Ch,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,032h,07h,042h,07h,059h,07h,032h,07h,020h,07h,020h,07h
; @16830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,02Eh,07h,053h,07h,050h,07h,052h,07h,020h,07h,020h,07h
; @16840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @16860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @168A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,07h,04Ch,07h,04Fh,07h,057h,07h,043h,07h,048h,07h,052h,07h,032h,07h
; @168B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,046h,07h,04Ch,07h,043h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @168C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,042h,07h,041h,07h,043h,07h,04Bh,07h,047h,07h,052h,07h
; @168D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,07h,044h,07h,02Eh,07h,04Eh,07h,045h,07h,04Fh,07h,020h,07h,020h,07h
; @168E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @168F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h,020h,07h,020h,07h
; @16900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,02Eh,07h,020h,07h
; @16920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,0Eh,020h,07h,020h,07h,020h,07h,020h,07h
; @16940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @169A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @169B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @169C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @169D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,031h,01Eh
; @169E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,03Dh,01Eh,020h,01Eh,051h,01Eh,075h,01Eh,069h,01Eh,074h,01Eh,020h,01Eh
; @169F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,033h,01Eh,020h,01Eh,03Dh,01Eh
; @16A00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,043h,01Eh,061h,01Eh,073h,01Eh,065h,01Eh,020h,01Eh,044h,01Eh,065h,01Eh
; @16A10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,01Eh,063h,01Eh,072h,01Eh,069h,01Eh,070h,01Eh,074h,01Eh,06Fh,01Eh,072h,01Eh
; @16A20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,035h,01Eh,020h,01Eh,03Dh,01Eh,020h,01Eh
; @16A30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,01Eh,072h,01Eh,069h,01Eh,06Eh,01Eh,074h,01Eh,020h,01Eh,053h,01Eh,063h,01Eh
; @16A40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,01Eh,065h,01Eh,065h,01Eh,06Eh,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
; @16A50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
; @16A60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
; @16A70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,032h,01Eh
; @16A80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,03Dh,01Eh,020h,01Eh,048h,01Eh,065h,01Eh,06Ch,01Eh,070h,01Eh,020h,01Eh
; @16A90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,034h,01Eh,020h,01Eh,03Dh,01Eh
; @16AA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,043h,01Eh,072h,01Eh,075h,01Eh,06Eh,01Eh,063h,01Eh,068h,01Eh,020h,01Eh
; @16AB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Fh,01Eh,075h,01Eh,074h,01Eh,070h,01Eh,075h,01Eh,074h,01Eh,020h,01Eh,020h,01Eh
; @16AC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,046h,01Eh,036h,01Eh,020h,01Eh,03Dh,01Eh,020h,01Eh
; @16AD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,01Eh,068h,01Eh,06Fh,01Eh,077h,01Eh,020h,01Eh,041h,01Eh,074h,01Eh,074h,01Eh
; @16AE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,01Eh,069h,01Eh,062h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
; @16AF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,043h,01Eh,06Fh,01Eh,06Dh,01Eh,06Dh,01Eh,061h,01Eh,06Eh,01Eh
; @16B00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,01Eh,03Fh,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh,020h,01Eh
; @16B10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01Eh,020h,01Eh,020h,01Eh,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16B90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16BA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @16BB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,04Dh,065h,06Dh,06Fh,072h,079h,020h,064h,065h,02Dh
; @16BC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,06Ch,06Ch,06Fh,063h,061h,074h,069h,06Fh,06Eh,020h,065h,072h,072h,06Fh,072h
; @16BD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,06Dh,065h,06Dh,06Fh
; @16BE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,079h,024h,090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @16BF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @16C00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @16C10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @16C20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @16C30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,020h,00h,080h,00h,00h,02h,04h,011h,0C4h,0Dh,054h,014h,04Ah,00h
; @16C40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,00h,014h,00h,044h,00h,0E4h,01h,044h,02h,0DCh,00h,06Ch,07h,0A4h,0Bh
; @16C50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0Fh,02Ah,02h,04Ch,03h,02Ch,05h,05Ch,02h,084h,04h,034h,06h,0A4h,05h
; @16C60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Eh,01h,024h,03h,014h,00h,094h,00h,0A4h,00h,08h,01h,04Ah,00h,020h,00h
; @16C70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,00h,02Ch,00h,0A0h,03h,0CCh,03h,0BAh,03h,0A0h,03h,0BEh,0Bh,040h,00h
; @16C80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,00h,050h,00h,00h,0B8h,028h,00h,0A0h,00h,080h,02h,04h,022h,084h,01Bh
; @16C90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,028h,090h,00h,0C8h,00h,024h,00h,084h,00h,0C4h,03h,084h,04h,0B4h,01h
; @16CA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D4h,0Eh,044h,017h,0CCh,01Fh,050h,04h,094h,06h,054h,0Ah,0B4h,04h,04h,09h
; @16CB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,0Ch,044h,0Bh,018h,02h,044h,06h,024h,00h,024h,01h,044h,01h,0Ch,02h
; @16CC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,03Ch,00h,058h,00h,054h,00h,03Ch,07h,094h,07h,070h,07h,03Ch,07h
; @16CD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 078h,017h,080h,00h,068h,00h,0A0h,00h,00h,0A0h,040h,00h,00h,01h,00h,04h
; @16CE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,022h,084h,01Bh,0A4h,028h,090h,00h,0C8h,00h,024h,00h,084h,00h,0C4h,03h
; @16CF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 084h,04h,0B4h,01h,0D4h,0Eh,044h,017h,0CCh,01Fh,050h,04h,094h,06h,054h,0Ah
; @16D00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B4h,04h,04h,09h,064h,0Ch,044h,0Bh,018h,02h,044h,06h,024h,00h,024h,01h
; @16D10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,01h,0Ch,02h,090h,00h,03Ch,00h,058h,00h,054h,00h,03Ch,07h,094h,07h
; @16D20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,07h,03Ch,07h,078h,017h,080h,00h,068h,00h,0A0h,00h,00h,0B8h,072h,010h
; @16D30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C6h,010h,01Ah,011h,0FFh,0FFh,04Ch,045h,056h,030h,04Dh,041h,050h,02Eh,042h,049h
; @16D40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,031h,04Dh,041h,050h,02Eh,042h,049h
; @16D50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,032h,04Dh,041h,050h,02Eh,042h,049h
; @16D60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,033h,04Dh,041h,050h,02Eh,042h,049h
; @16D70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,034h,04Dh,041h,050h,02Eh,042h,049h
; @16D80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,035h,04Dh,041h,050h,02Eh,042h,049h
; @16D90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,036h,04Dh,041h,050h,02Eh,042h,049h
; @16DA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,037h,04Dh,041h,050h,02Eh,042h,049h
; @16DB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,030h,042h,04Ch,058h,02Eh,042h,049h
; @16DC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,031h,042h,04Ch,058h,02Eh,042h,049h
; @16DD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,032h,042h,04Ch,058h,02Eh,042h,049h
; @16DE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,033h,042h,04Ch,058h,02Eh,042h,049h
; @16DF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,034h,042h,04Ch,058h,02Eh,042h,049h
; @16E00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Ch,045h,056h,035h,042h,04Ch,058h,02Eh,042h,049h
; @16E10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,047h,030h,02Eh,042h,049h,043h,00h,00h,00h,0FFh
; @16E20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,047h,031h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,047h,032h,02Eh,042h
; @16E30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 049h,043h,00h,00h,00h,0FFh,0FFh,047h,033h,02Eh,042h,049h,043h,00h,00h,00h
; @16E40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,047h,034h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,047h,035h,02Eh
; @16E50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 042h,049h,043h,00h,00h,00h,0FFh,0FFh,031h,058h,031h,02Eh,042h,049h,043h,00h
; @16E60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0FFh,0FFh,032h,058h,032h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh
; @16E70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,058h,032h,043h,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,04Dh,041h,04Eh
; @16E80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,058h,050h,04Ch,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,04Ch,04Fh,047h
; @16E90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Fh,02Eh,042h,049h,043h,00h,00h,00h,0FFh,0FFh,054h,048h,045h,04Eh,044h,02Eh
; @16EA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 042h,049h,043h,00h,00h,00h,0FFh,0FFh,050h,041h,04Eh,045h,04Ch,02Eh,045h,04Eh
; @16EB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,053h,048h,049h,050h,02Eh,042h,049h,043h,00h,00h
; @16EC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0FFh,0FFh,042h,04Ch,055h,045h,042h,049h,054h,053h,02Eh,042h,049h,043h,00h
; @16ED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0FFh,0FFh,057h,049h,04Eh,044h,04Fh,057h,02Eh,042h,049h,043h,00h,00h
; @16EE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0FFh,0FFh,049h,050h,041h,047h,045h,031h,02Eh,045h,04Eh,043h,00h,00h,00h
; @16EF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,049h,050h,041h,047h,045h,032h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh
; @16F00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,049h,050h,041h,047h,045h,033h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh
; @16F10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 049h,050h,041h,047h,045h,034h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,049h
; @16F20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,041h,047h,045h,035h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h
; @16F30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 041h,047h,045h,031h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h
; @16F40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,045h,032h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h
; @16F50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,033h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h
; @16F60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,035h
; @16F70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,036h,02Eh
; @16F80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,037h,02Eh,045h
; @16F90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,038h,02Eh,045h,04Eh
; @16FA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,039h,02Eh,045h,04Eh,043h
; @16FB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,0FFh,0FFh,04Fh,050h,041h,047h,045h,031h,030h,02Eh,045h,04Eh,043h
; @16FC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,0FFh,0FFh,06Fh,06Bh,06Dh,065h,06Eh,075h,02Eh,065h,06Eh,063h,00h
; @16FD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0FFh,0FFh,063h,061h,06Ch,069h,062h,02Eh,065h,06Eh,063h,00h,00h,00h
; @16FE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,072h,065h,064h,065h,066h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh
; @16FF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 068h,069h,073h,063h,06Fh,072h,065h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh
; @17000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,069h,06Eh,073h,063h,072h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h
; @17010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Ch,061h,071h,030h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h
; @17020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 071h,031h,02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,032h
; @17030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,065h,06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,033h,02Eh,065h
; @17040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,063h,00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,034h,02Eh,065h,06Eh,063h
; @17050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,0FFh,0FFh,070h,06Ch,061h,071h,035h,02Eh,065h,06Eh,063h,00h,00h
; @17060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0FFh,0FFh,06Ch,065h,076h,073h,063h,072h,02Eh,065h,06Eh,063h,00h,00h,00h
; @17070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,063h,068h,06Fh,06Fh,073h,065h,02Eh,065h,06Eh,063h,00h,00h,00h,090h
; @17080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,011h,086h,011h,096h,011h,0A6h,011h,0B6h,011h,0C6h,011h,0D6h,011h,0E6h,011h
; @17090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 098h,012h,0A4h,012h,0B0h,012h,0BDh,012h,0CDh,012h,0DAh,012h,0E8h,012h,0F6h,012h
; @170A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,013h,014h,013h,0FFh,0FFh,00h,00h,056h,012h,0F6h,011h,061h,012h,06h,012h
; @170B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Ch,012h,016h,012h,077h,012h,026h,012h,082h,012h,036h,012h,08Dh,012h,046h,012h
; @170C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 056h,012h,0F6h,011h,077h,012h,026h,012h,095h,014h,04Fh,014h,05Dh,014h,06Bh,014h
; @170D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 079h,014h,087h,014h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @170E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @170F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @171A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @171B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @171C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @171D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @171E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @171F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @172A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @172B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @172C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @172D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @172E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @172F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @173A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @173B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @173C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @173D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @173E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @173F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @174A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @174B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @174C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @174D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,018h
; @174E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,018h,018h,00h,018h,00h,024h,048h,06Ch,06Ch,00h,00h,00h,00h,00h,024h
; @174F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,024h,024h,07Eh,024h,00h,00h,010h,07Eh,050h,07Eh,016h,07Eh,010h,00h,0C6h
; @17500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CCh,018h,030h,066h,0C6h,00h,00h,01Ch,036h,01Ch,03Bh,066h,03Bh,00h,018h,018h
; @17510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,010h,00h,00h,00h,00h,0Ch,018h,030h,030h,030h,030h,01Ch,00h,030h,018h
; @17520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,0Ch,0Ch,0Ch,038h,00h,00h,06Ch,038h,0FEh,038h,06Ch,00h,00h,00h,018h
; @17530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,07Eh,018h,018h,00h,00h,00h,00h,00h,00h,060h,060h,020h,040h,00h,00h
; @17540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,07Ch,00h,00h,00h,00h,00h,00h,00h,00h,00h,018h,018h,00h,00h,03h
; @17550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0Ch,018h,030h,060h,00h,03Ch,066h,06Eh,07Eh,076h,066h,03Ch,00h,018h,038h
; @17560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,018h,018h,018h,07Eh,00h,03Ch,066h,06h,01Ch,030h,066h,07Eh,00h,03Ch,066h
; @17570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,01Ch,06h,066h,03Ch,00h,01Ch,03Ch,06Ch,0CCh,0FEh,0Ch,01Eh,00h,07Eh,060h
; @17580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ch,06h,06h,066h,03Ch,00h,01Ch,030h,060h,07Ch,066h,066h,03Ch,00h,07Eh,066h
; @17590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0Ch,018h,018h,018h,00h,03Ch,066h,066h,03Ch,066h,066h,03Ch,00h,03Ch,066h
; @175A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,03Eh,06h,0Ch,038h,00h,00h,018h,018h,00h,018h,018h,00h,00h,00h,018h
; @175B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,00h,018h,018h,08h,010h,01Ch,030h,060h,0C0h,060h,030h,01Ch,00h,00h,03Ch
; @175C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,00h,03Ch,03Ch,00h,00h,038h,0Ch,06h,03h,06h,0Ch,038h,00h,00h,07Eh
; @175D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,0Ch,018h,00h,018h,00h,07Ch,0C6h,0DEh,0D6h,0DEh,0C0h,07Ch,00h,03Ch,066h
; @175E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,07Fh,063h,063h,063h,00h,07Ch,066h,063h,07Eh,063h,063h,07Eh,00h,03Ch,066h
; @175F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,060h,060h,063h,03Eh,00h,07Ch,066h,063h,063h,063h,063h,07Eh,00h,07Eh,060h
; @17600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,07Eh,060h,060h,07Fh,00h,07Eh,060h,060h,07Eh,060h,060h,060h,00h,03Ch,066h
; @17610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,06Fh,063h,063h,03Eh,00h,063h,063h,063h,07Fh,063h,063h,063h,00h,01Eh,0Ch
; @17620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,0Ch,0Ch,0Ch,01Eh,00h,0Fh,03h,03h,03h,03h,066h,03Ch,00h,063h,063h
; @17630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,07Ch,066h,063h,063h,00h,060h,060h,060h,060h,060h,060h,07Fh,00h,063h,077h
; @17640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,06Bh,063h,063h,063h,00h,063h,073h,07Bh,06Fh,067h,063h,063h,00h,03Ch,066h
; @17650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,063h,063h,063h,03Eh,00h,07Ch,066h,063h,07Eh,060h,060h,060h,00h,03Ch,066h
; @17660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,063h,07Bh,06Fh,03Fh,00h,07Ch,066h,063h,07Eh,063h,063h,063h,00h,03Ch,066h
; @17670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,03Eh,03h,063h,03Eh,00h,03Fh,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,063h,063h
; @17680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,063h,063h,033h,01Fh,00h,063h,063h,063h,063h,063h,036h,01Ch,00h,063h,063h
; @17690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,063h,06Bh,07Fh,036h,00h,063h,063h,036h,01Ch,036h,063h,063h,00h,033h,033h
; @176A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 033h,01Eh,0Ch,0Ch,0Ch,00h,07Eh,06h,0Ch,018h,030h,060h,07Fh,00h,00h,01Ch
; @176B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,018h,018h,018h,01Ch,00h,00h,0C0h,060h,030h,018h,0Ch,06h,00h,00h,038h
; @176C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,018h,018h,018h,038h,00h,010h,038h,07Ch,038h,038h,038h,038h,00h,00h,00h
; @176D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,0FEh,00h,03Eh,032h,020h,070h,020h,07Eh,00h,00h,00h
; @176E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,03h,03Fh,063h,03Fh,00h,060h,060h,07Ch,066h,063h,063h,07Eh,00h,00h,00h
; @176F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,066h,060h,063h,03Eh,00h,03h,03h,01Fh,033h,063h,063h,03Fh,00h,00h,00h
; @17700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,066h,07Eh,060h,03Fh,00h,01Eh,033h,030h,03Ch,030h,030h,030h,00h,00h,00h
; @17710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,033h,063h,03Fh,03h,07Eh,060h,060h,07Ch,066h,063h,063h,063h,00h,0Ch,00h
; @17720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,0Ch,0Ch,0Ch,0Ch,00h,03h,00h,03h,03h,03h,03h,066h,03Ch,060h,060h
; @17730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,066h,07Ch,066h,063h,00h,018h,018h,018h,018h,018h,018h,0Ch,00h,00h,00h
; @17740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,07Fh,06Bh,06Bh,063h,00h,00h,00h,07Ch,066h,063h,063h,063h,00h,00h,00h
; @17750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,066h,063h,063h,03Eh,00h,00h,00h,07Ch,066h,063h,07Eh,060h,060h,00h,00h
; @17760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,033h,063h,03Fh,03h,03h,00h,00h,07Eh,063h,060h,060h,060h,00h,00h,00h
; @17770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,060h,03Eh,03h,07Eh,00h,030h,030h,03Ch,030h,030h,033h,01Eh,00h,00h,00h
; @17780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,063h,063h,033h,01Fh,00h,00h,00h,063h,063h,063h,036h,01Ch,00h,00h,00h
; @17790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,063h,06Bh,07Fh,036h,00h,00h,00h,063h,036h,01Ch,036h,063h,00h,00h,00h
; @177A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,063h,033h,01Fh,03h,07Eh,00h,00h,07Eh,0Ch,018h,030h,07Fh,00h,00h,01Ch
; @177B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,030h,030h,018h,01Ch,00h,018h,018h,018h,018h,018h,018h,018h,00h,00h,038h
; @177C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,0Ch,0Ch,018h,038h,00h,00h,00h,00h,0F6h,0DEh,00h,00h,00h,0FFh,0FFh
; @177D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h
; @177E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,01h,01h,01h,011h,01h,015h,055h,055h,055h,055h
; @177F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,011h,011h,01h,011h,015h,055h,055h,055h,055h,011h,011h,01h,011h,01h,015h
; @17800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,011h,011h,05h,011h,011h,015h,055h,055h,055h,055h,011h,01h
; @17810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,011h,011h,01h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
; @17820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
; @17830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,01h,011h,01h,015h,01h,055h,055h,055h,055h,011h,011h,011h,011h,015h,015h
; @17840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,011h,011h,011h,01h,015h,05h,055h,055h,055h,055h,011h,011h
; @17850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,011h,015h,015h,055h,055h,055h,055h,01h,01h,01h,01h,01h,01h,055h,055h
; @17860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h
; @17870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,041h,044h,04h,04h,04h,04h,04h
; @17880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,044h,044h,044h,054h,044h,044h,044h,055h,055h,055h,044h,044h,04h
; @17890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,044h,044h,04h,055h,055h,055h,044h,044h,044h,044h,044h,044h,044h,055h,055h
; @178A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,040h,044h,044h,04h,04h,044h,044h,05h,055h,055h,055h,055h,055h,055h,055h
; @178B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h
; @178C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,01h,01h,01h,01h,011h,015h,01h,01h,055h,055h,015h,011h,011h
; @178D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,011h,015h,011h,015h,055h,055h,01h,015h,01h,05h,011h,015h,01h,01h,055h
; @178E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,051h,011h,05h,015h,01h,015h,011h,051h,055h,055h,01h,01h,011h,01h,011h
; @178F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,011h,01h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h
; @17900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,050h,010h,010h
; @17910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,011h,050h,010h,015h,055h,055h,051h,051h,011h,054h,051h,051h,011h,055h,055h
; @17920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,050h,050h,010h,014h,051h,050h,010h,015h,055h,055h,051h,051h,015h,014h,051h
; @17930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 051h,015h,015h,055h,055h,051h,051h,010h,014h,050h,011h,010h,015h,055h,055h,055h
; @17940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h
; @17950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,054h,04h,040h,040h,045h,040h,040h,055h,055h
; @17960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,054h,044h,044h,045h,045h,044h,045h,055h,055h,055h,054h,04h,044h,044h,045h
; @17970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,040h,055h,055h,055h,054h,014h,044h,044h,045h,044h,054h,055h,055h,055h,054h
; @17980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,044h,040h,040h,044h,040h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
; @17990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
; @179A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,050h,010h,010h,010h,010h,011h,010h,015h,055h,055h,051h,011h,011h,014h,051h
; @179B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,011h,015h,055h,055h,051h,051h,011h,014h,051h,011h,010h,015h,055h,055h,051h
; @179C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,011h,014h,051h,011h,010h,055h,055h,055h,050h,010h,011h,014h,050h,010h,011h
; @179D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h
; @179E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,051h,010h,015h,051h
; @179F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,015h,055h,055h,055h,055h,051h,011h,015h,051h,011h,015h,055h,055h,055h,055h
; @17A00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,011h,010h,010h,011h,015h,055h,055h,055h,055h,055h,011h,015h,055h,011h,015h
; @17A10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,050h,010h,015h,050h,010h,015h,055h,055h,055h,055h,055h,055h
; @17A20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h
; @17A30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,01h,011h,01h,01h,01h,01h,01h,015h,055h,055h,015h
; @17A40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,011h,011h,011h,011h,015h,015h,055h,055h,01h,01h,01h,01h,01h,011h,05h
; @17A50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,055h,055h,051h,011h,05h,011h,015h,011h,015h,015h,055h,055h,01h,011h,011h
; @17A60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,015h,011h,01h,01h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
; @17A70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,040h
; @17A80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 044h,04h,04h,04h,04h,04h,05h,055h,055h,045h,044h,044h,054h,044h,044h,054h
; @17A90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,041h,044h,04h,014h,044h,044h,04h,015h,055h,055h,045h,044h,014h
; @17AA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,044h,045h,044h,055h,055h,055h,045h,044h,044h,04h,044h,04h,04h,05h,055h
; @17AB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h
; @17AC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,040h,044h,014h,04h,04h,04h,044h
; @17AD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,055h,055h,045h,044h,044h,054h,044h,044h,04h,055h,055h,055h,040h,044h,044h
; @17AE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,04h,04h,044h,05h,055h,055h,054h,044h,044h,054h,044h,014h,045h,045h,055h
; @17AF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,040h,044h,04h,04h,044h,044h,044h,05h,055h,055h,055h,055h,055h,055h,055h
; @17B00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h
; @17B10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,050h,050h,010h,010h,010h,015h,055h,055h,055h,055h,051h,011h
; @17B20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,011h,011h,055h,055h,055h,055h,055h,051h,010h,011h,011h,010h,055h,055h,055h
; @17B30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,051h,010h,051h,011h,011h,055h,055h,055h,055h,055h,050h,011h,010h,011h
; @17B40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,015h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,07h,00h
; @17B50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,050h,010h
; @17B60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,011h,010h,015h,055h,055h,055h,055h,051h,051h,051h,011h,014h,055h,055h,055h
; @17B70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,050h,011h,051h,011h,014h,055h,055h,055h,055h,055h,055h,011h,051h,011h
; @17B80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,055h,055h,055h,055h,055h,050h,010h,010h,010h,014h,055h,055h,055h,055h,055h
; @17B90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,07h,00h,05h,00h,055h,055h,055h,055h
; @17BA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,054h,04h,040h,044h,040h,040h,040h,055h,055h
; @17BB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,054h,054h,045h,044h,051h,045h,044h,055h,055h,055h,054h,014h,044h,040h,051h
; @17BC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 041h,041h,055h,055h,055h,054h,054h,044h,044h,051h,045h,044h,055h,055h,055h,054h
; @17BD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,040h,044h,051h,040h,044h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
; @17BE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,07h,00h,05h,00h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h
; @17BF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,054h,04h,04h,044h,040h,040h,040h,055h,055h,055h,054h,054h,044h,044h,045h
; @17C00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,044h,055h,055h,055h,054h,054h,014h,044h,040h,041h,041h,055h,055h,055h,054h
; @17C10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,044h,044h,054h,045h,044h,055h,055h,055h,054h,04h,044h,04h,040h,040h,044h
; @17C20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,055h,00h,00h,00h,00h
; @17C30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17C40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17C50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17C60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,090h,00h,00h,0A8h,020h,041h,06Eh,06Fh,074h,068h,065h,072h,020h
; @17C70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,065h,067h,061h,020h,053h,074h,065h,020h,043h,06Fh,072h,06Bh,020h,043h,072h
; @17C80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,061h,074h,069h,06Fh,06Eh,021h,090h,00h,00h,0F5h,0C5h,0F7h,0C5h,0F9h,0C5h
; @17C90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,0C5h,0FDh,0C5h,0FFh,0C5h,06h,0EEh,06Ch,0EEh,07Ah,0EEh,084h,0EEh,0F6h,0EEh
; @17CA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 048h,0EFh,010h,03h,011h,0Ch,03h,020h,053h,057h,041h,050h,020h,044h,049h,053h
; @17CB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Bh,053h,02Ch,020h,050h,052h,045h,053h,053h,020h,046h,049h,052h,045h,020h,00h
; @17CC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,02h,011h,0Ch,03h,020h,052h,045h,041h,044h,020h,045h,052h,052h,04Fh,052h
; @17CD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ch,020h,050h,052h,045h,053h,053h,020h,046h,049h,052h,045h,020h,00h,011h,0Ch
; @17CE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h
; @17CF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,020h,020h,020h,020h,020h,020h,020h,020h,00h,00h,00h,00h,00h,00h,00h
; @17D00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ch,039h,010h,01Eh,018h,019h,00h,00h,02Ch,077h,07Ch,07Bh,07Ah,079h,07h,00h
; @17D10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,0Ah,00h,08h,00h,09h,00h,08h,00h,00h,00h,00h,00h,00h,090h
; @17D20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17D30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17D40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17D50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17D60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,03h
; @17D70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,0Fh,030h,033h,03Ch,03Fh,0C0h,0C3h,0CCh,0CFh,0F0h,0F3h,0FCh,0FFh,00h,055h
; @17D80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0AAh,0FFh,00h,00h,00h,00h,068h,069h,073h,063h,06Fh,072h,065h,02Eh,064h,061h
; @17D90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,00h,011h,04h,00h,010h,0Ah,00h,053h,074h,065h,020h,043h,06Fh,072h,06Bh
; @17DA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,020h,020h,00h,00h,080h,00h,00h,054h,069h,06Eh,079h,020h,057h,02Eh,020h
; @17DB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,020h,020h,00h,00h,070h,00h,00h,04Dh,02Eh,048h,06Fh,06Ch,06Ch,061h,06Eh
; @17DC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,020h,020h,00h,00h,060h,00h,00h,050h,02Eh,04Dh,075h,072h,072h,061h,079h
; @17DD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,020h,020h,00h,00h,050h,00h,00h,043h,068h,072h,069h,073h,020h,057h,06Fh
; @17DE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Fh,064h,020h,00h,00h,040h,00h,00h,04Ah,06Fh,068h,06Eh,020h,057h,02Eh,020h
; @17DF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,020h,020h,00h,00h,030h,00h,00h,052h,02Eh,054h,02Eh,053h,06Dh,069h,074h
; @17E00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 068h,020h,020h,00h,00h,020h,00h,00h,04Dh,02Eh,054h,073h,063h,068h,06Fh,065h
; @17E10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 067h,06Ch,020h,00h,00h,010h,00h,00h,03Ch,04Fh,076h,065h,072h,04Bh,069h,06Ch
; @17E20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Ch,03Eh,020h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17E30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17E40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,090h,00h,00h,00h,090h,00h,00h,020h,020h,020h,020h,020h,020h
; @17E50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,020h,020h,020h,024h,011h,00h,0Bh,010h,00h,00h,0Dh,00h,00h,00h,00h
; @17E60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,00h,00h,010h,0Fh,00h,090h
; @17E70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17E80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,01h,00h,00h,01h,01h,01h,00h,00h,090h,00h,090h,0Dh,0Ah,024h,00h
; @17E90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,049h,020h,063h,06Fh,075h,06Ch,064h,020h,06Eh,06Fh,074h,020h,066h,069h,06Eh
; @17EA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,020h,074h,068h,065h,020h,066h,069h,06Ch,065h,020h,027h,024h,027h,020h,061h
; @17EB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,079h,077h,068h,065h,072h,065h,02Ch,020h,073h,06Fh,072h,072h,079h,02Eh,0Dh
; @17EC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ah,0Dh,0Ah,024h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17ED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,03h,00h,00h,00h,00h,00h,010h,0Ah,011h,0Dh,01Dh,00h,08h,01h
; @17EE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,07h,09h,0Ah,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17EF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,010h,0Ah,011h,0Fh
; @17F20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,036h,031h,032h,033h,034h,035h,04h,00h,04h,00h,04h,00h,04h,00h
; @17F30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,04h,00h,00h,080h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17F90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17FA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17FB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17FC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17FD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17FE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @17FF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
part11 ends
end
