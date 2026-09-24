; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part17 segment byte public 'CODE'
assume cs:part17,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; @22000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0B6h,0C4h,0FFh,0C4h,020h,0C5h
; @22070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,0C5h,0FFh,0C4h,0A4h,0C5h,01h,00h,0Ch,00h,0Eh,00h,012h,00h,014h,00h
; @22080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 017h,00h,01Ah,00h,01Bh,00h,01Eh,00h,026h,00h,02Ah,00h,02Fh,00h,033h,00h
; @22090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,00h,041h,00h,048h,00h,04Ch,00h,055h,00h,057h,00h,058h,00h,05Bh,00h
; @220A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,00h,064h,00h,07Bh,00h,07Eh,00h,07Fh,00h,082h,00h,096h,00h,099h,00h
; @220B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B5h,00h,0BAh,00h,0BBh,00h,0BCh,00h,0BDh,00h,0C2h,00h,0DFh,00h,0FFh,01h
; @220C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0A3h,00h,0A1h,00h,0A8h,00h,075h,00h,071h,00h,0A6h,00h,06Fh,00h,06Ch
; @220D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,06Dh,02h,07Ah,00h,08Ah,00h,094h,00h,095h,00h,0ACh,00h,0B1h,00h,0FFh
; @220E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,03h,00h,0Ch,00h,0Dh,00h,013h,00h,016h,00h,01Eh,00h,023h,00h
; @220F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 028h,00h,02Ah,00h,025h,00h,047h,00h,048h,00h,04Ch,00h,04Dh,00h,04Eh,00h
; @22100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Fh,00h,050h,00h,052h,00h,058h,00h,05Ah,00h,082h,00h,087h,00h,088h,00h
; @22110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,082h,00h,087h,00h,089h,00h,0AAh,00h,0ABh,00h,0ADh,00h,0E1h,00h
; @22120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,00h,0B1h,00h,0FFh,01h,00h,0Fh,00h,011h,00h,012h,00h,022h,00h,023h
; @22130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,055h,00h,059h,00h,05Bh,00h,060h,00h,062h,00h,063h,00h,064h,00h,066h
; @22140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,067h,00h,068h,00h,06Eh,00h,076h,00h,078h,00h,07Eh,00h,07Fh,00h,085h
; @22150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,08Ah,00h,08Bh,00h,08Ch,00h,095h,00h,096h,00h,097h,00h,098h,00h,099h
; @22160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,09Ah,00h,0FFh,01h,00h,03h,00h,0Ch,00h,0Dh,00h,013h,00h,016h,00h
; @22170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,00h,023h,00h,028h,00h,02Ah,00h,025h,00h,047h,00h,048h,00h,04Ch,00h
; @22180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,00h,04Eh,00h,04Fh,00h,050h,00h,052h,00h,058h,00h,05Ah,00h,082h,00h
; @22190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 087h,00h,088h,00h,080h,00h,082h,00h,087h,00h,089h,00h,0AAh,00h,0ABh,00h
; @221A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,00h,0B1h,00h,0D2h,00h,0D3h,00h,0FFh,0F5h,0C5h,0F7h,0C5h,0F9h,0C5h,0FBh
; @221B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C5h,0FDh,0C5h,0FFh,0C5h,05Ch,0C8h,0D6h,0C8h,02h,0CAh,036h,0CCh,080h,0CCh,0AAh
; @221C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CCh,0Dh,0C6h,02Bh,0C6h,049h,0C6h,067h,0C6h,085h,0C6h,0A3h,0C6h,09Ch,00h,011h
; @221D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,05Ch,0C8h,0CFh,03h,0CFh,03h,0D2h,00h,064h,0C8h,050h,07h,050h,07h,08Dh
; @221E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,07Ch,0C8h,090h,0Ah,090h,0Ah,04Dh,00h,0ACh,0C8h,09Ch,00h,011h,01h,0D6h
; @221F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C8h,0CFh,03h,0CFh,03h,0D2h,00h,0FEh,0C8h,0C5h,07h,0C5h,07h,084h,00h,02Eh
; @22200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C9h,090h,0Ah,090h,0Ah,04Dh,00h,05Eh,0C9h,09Ch,00h,011h,01h,02h,0CAh,0CFh
; @22210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0CFh,03h,0D2h,00h,068h,0CAh,077h,07h,077h,07h,08Ah,00h,0DEh,0CAh,090h
; @22220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ah,090h,0Ah,04Dh,00h,07Eh,0CBh,09Ch,00h,011h,01h,036h,0CCh,0CFh,03h,0CFh
; @22230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0D2h,00h,03Eh,0CCh,0Fh,07h,0Fh,07h,092h,00h,048h,0CCh,0EBh,0Ah,0EBh
; @22240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ah,046h,00h,05Ch,0CCh,09Ch,00h,011h,01h,080h,0CCh,0B5h,03h,0B5h,03h,0D4h
; @22250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,088h,0CCh,036h,07h,036h,07h,08Fh,00h,090h,0CCh,0EBh,0Ah,0EBh,0Ah,046h
; @22260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,098h,0CCh,09Ch,00h,011h,01h,0AAh,0CCh,0CFh,03h,0CFh,03h,0D2h,00h,0C2h
; @22270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CCh,05Dh,07h,05Dh,07h,08Ch,00h,0E2h,0CCh,0EBh,0Ah,0EBh,0Ah,046h,00h,0E2h
; @22280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CCh,07h,00h,01Ch,00h,00h,00h,021h,00h,03Eh,00h,00h,00h,032h,00h,05h
; @22290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,042h,00h,03Ch,00h,00h,00h,051h,00h,029h,00h,00h,00h,085h
; @222A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0Eh,00h,00h,00h,084h,00h,032h,00h,00h,00h,06Ch,00h,040h,00h,00h
; @222B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0A4h,00h,055h,00h,00h,00h,089h,00h,071h,00h,00h,00h,07Dh,00h,089h
; @222C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,08Eh,00h,0A9h,00h,00h,00h,05Bh,00h,06Fh,00h,00h,00h,050h
; @222D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,09Ah,00h,00h,00h,06Ch,00h,052h,00h,00h,00h,035h,00h,07Fh,00h,00h
; @222E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,019h,00h,069h,00h,00h,00h,011h,00h,096h,00h,00h,00h,026h,00h,0AEh
; @222F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,07h,00h,0CBh,00h,00h,00h,015h,00h,024h,00h,00h,00h,048h
; @22300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,019h,00h,00h,00h,087h,00h,01Ah,00h,00h,00h,0A3h,00h,04Eh,00h,00h
; @22310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,058h,00h,04Fh,00h,00h,00h,06Eh,00h,085h,00h,00h,00h,0ACh,00h,0ABh
; @22320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,016h,00h,07Eh,00h,00h,00h,023h,00h,0B0h,00h,00h,00h,04Fh
; @22330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,099h,00h,00h,00h,018h,00h,021h,00h,00h,00h,046h,00h,043h,00h,00h
; @22340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,066h,00h,01Ah,00h,00h,00h,095h,00h,02Fh,00h,00h,00h,06Dh,00h,05Dh
; @22350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,09Eh,00h,079h,00h,00h,00h,08Dh,00h,0BFh,00h,00h,00h,049h
; @22360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,084h,00h,00h,00h,02Ah,00h,0B3h,00h,00h,00h,0Eh,00h,08Ah,00h,00h
; @22370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @22390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @223A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @223B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @223C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0FFh,0FFh,03h,0Ch,030h,0C0h,01h,02h,04h,08h,010h,020h,040h,080h,0Fh
; @223D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,090h,00h,00h,00h,00h,00h,00h,014h,00h,03h,01h,00h,00h,00h,02h
; @223E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,04h,01h,00h,01h,00h,00h,00h,01h,04h,00h,00h,00h,03h,01h,00h
; @223F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,03h,00h,00h,00h,02h,03h,01h,00h,00h,02h
; @22400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,01h,01h,00h,01h,03h,00h,01h,00h,00h,01h,00h,00h,00h,01h,03h
; @22410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,01h,01h,04h,00h,00h,00h,00h,00h,090h,010h,01h,0E0h,0D0h
; @22420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,00h,0F0h,0FFh,0BDh,00h,088h,0CFh,0B0h,00h,0F0h,0FFh,0BDh,00h,068h,0CFh
; @22430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,0F0h,0FFh,0ADh,00h,0B0h,0D0h,040h,00h,0F0h,0FFh,06Ch,00h,0F4h,0CFh
; @22440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,0F0h,0FFh,06Bh,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,060h,00h,0F4h,0CFh
; @22450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,0F0h,0FFh,05Fh,00h,0F4h,0CFh,080h,00h,0F0h,0FFh,057h,00h,088h,0CFh
; @22460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,00h,0F0h,0FFh,057h,00h,068h,0CFh,010h,00h,0F0h,0FFh,048h,00h,03Ch,0CFh
; @22470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,0F0h,0FFh,02Dh,00h,03Ch,0CFh,060h,00h,0F0h,0FFh,04h,00h,0F4h,0CDh
; @22480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,04h,00h,02Ch,0CEh,0B0h,00h,0F0h,0FFh,04h,00h,070h,0D0h
; @22490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,00h,00h,00h,0FFh,0FFh,010h,01h,0F8h,0D0h,0C0h,00h,0E0h,00h,0Ah,01h
; @224A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,0D1h,00h,00h,0F0h,0FFh,0FAh,00h,068h,0D1h,070h,00h,0F0h,0FFh,0EDh,00h
; @224B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0D1h,020h,00h,0F0h,0FFh,0DCh,00h,034h,0D1h,00h,00h,0F0h,0FFh,0CFh,00h
; @224C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,0CFh,0B0h,00h,0F0h,0FFh,0BBh,00h,090h,0D1h,0C0h,00h,0F0h,0FFh,0A2h,00h
; @224D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,0D0h,020h,00h,0F0h,0FFh,09Ah,00h,068h,0D1h,0A0h,00h,0F0h,0FFh,098h,00h
; @224E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 068h,0D1h,0A0h,00h,0F0h,0FFh,092h,00h,01Ch,0D1h,060h,00h,0F0h,0FFh,082h,00h
; @224F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,0D0h,040h,00h,0F0h,0FFh,06Eh,00h,03Ch,0CFh,010h,00h,0F0h,0FFh,06Eh,00h
; @22500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,0CFh,0B0h,00h,0F0h,0FFh,067h,00h,034h,0D1h,00h,00h,0F0h,0FFh,064h,00h
; @22510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,0D0h,0B0h,00h,0F0h,0FFh,05Bh,00h,07Ch,0D0h,080h,00h,0F0h,0FFh,046h,00h
; @22520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,058h,0D0h,060h,00h,00h,00h,03Fh,00h,068h,0CFh,010h,00h,0F0h,0FFh
; @22530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ch,00h,0FFh,0FFh,018h,0D0h,00h,00h,0F0h,0FFh,03Bh,00h,0FFh,0FFh,018h,0D0h
; @22540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,031h,00h,0FFh,0FFh,024h,0D0h,00h,00h,00h,00h,02Eh,00h
; @22550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,058h,0D0h,050h,00h,00h,00h,02Eh,00h,0FFh,0FFh,064h,0D0h,060h,00h
; @22560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,02Eh,00h,0FFh,0FFh,058h,0D0h,070h,00h,00h,00h,02Ah,00h,0FFh,0FFh
; @22570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,0D0h,00h,00h,00h,00h,025h,00h,0FFh,0FFh,024h,0D0h,0C0h,00h,00h,00h
; @22580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,00h,0FFh,0FFh,018h,0D0h,00h,00h,00h,00h,01Fh,00h,0FFh,0FFh,024h,0D0h
; @22590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01Eh,00h,03Ch,0D0h,040h,00h,00h,00h,01Bh,00h,0FFh,0FFh
; @225A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,0D0h,00h,00h,00h,00h,01Bh,00h,0C8h,0D0h,090h,00h,0F0h,0FFh,019h,00h
; @225B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,018h,0D0h,020h,00h,00h,00h,04h,00h,070h,0D0h,070h,00h,00h,00h
; @225C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,010h,01h,0ECh,0D0h,00h,00h,0F0h,0FFh,0Fh,01h,0FFh,0FFh,030h,0D0h
; @225D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,0Ch,01h,0CCh,0CDh,010h,00h,0F0h,0FFh,04h,01h,0C4h,0CFh
; @225E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,0F0h,0FFh,04h,01h,0C4h,0CFh,080h,00h,0F0h,0FFh,0F8h,00h,0FFh,0FFh
; @225F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,0D0h,0B0h,00h,0F0h,0FFh,0F0h,00h,01Ch,0CFh,010h,00h,0F0h,0FFh,0EAh,00h
; @22600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,0CDh,040h,00h,0F0h,0FFh,0E2h,00h,034h,0D1h,00h,00h,0F0h,0FFh,0DBh,00h
; @22610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C8h,0D0h,010h,00h,0F0h,0FFh,0D8h,00h,0C8h,0D0h,010h,00h,0F0h,0FFh,0D3h,00h
; @22620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,030h,0D0h,00h,00h,0F0h,0FFh,0D2h,00h,03Ch,0CFh,060h,00h,0F0h,0FFh
; @22630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,00h,0A4h,0CDh,0C0h,00h,0F0h,0FFh,0C7h,00h,0C8h,0D0h,090h,00h,0F0h,0FFh
; @22640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,00h,0FFh,0FFh,0Ch,0D0h,080h,00h,0F0h,0FFh,0BEh,00h,0FFh,0FFh,0DCh,0CFh
; @22650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,0F0h,0FFh,0BCh,00h,0A8h,0CFh,050h,00h,0F0h,0FFh,0B0h,00h,0CCh,0CEh
; @22660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,0F0h,0FFh,0B0h,00h,0F4h,0CEh,070h,00h,0F0h,0FFh,0AEh,00h,0FFh,0FFh
; @22670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,0D1h,0B0h,00h,0F0h,0FFh,0ACh,00h,0FFh,0FFh,0B0h,0D1h,0B0h,00h,0F0h,0FFh
; @22680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Fh,00h,0FFh,0FFh,0A4h,0D1h,020h,00h,0F0h,0FFh,099h,00h,0FFh,0FFh,08Ch,0CDh
; @22690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,00h,0F0h,0FFh,094h,00h,0FFh,0FFh,0A4h,0D1h,020h,00h,0F0h,0FFh,085h,00h
; @226A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0DCh,0CFh,030h,00h,0F0h,0FFh,084h,00h,064h,0CEh,0A0h,00h,0F0h,0FFh
; @226B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 078h,00h,03Ch,0CFh,0B0h,00h,0F0h,0FFh,075h,00h,0FFh,0FFh,0A4h,0D1h,010h,00h
; @226C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,073h,00h,0FFh,0FFh,0A4h,0D1h,010h,00h,0F0h,0FFh,072h,00h,0F4h,0CFh
; @226D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,0F0h,0FFh,070h,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,070h,00h,0FFh,0FFh
; @226E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B0h,0D1h,0A0h,00h,0F0h,0FFh,06Eh,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,06Eh,00h
; @226F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0B0h,0D1h,0A0h,00h,0F0h,0FFh,06Ch,00h,0F4h,0CFh,050h,00h,0F0h,0FFh
; @22700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,062h,00h,084h,0CEh,00h,00h,0F0h,0FFh
; @22710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Bh,00h,0FFh,0FFh,0Ch,0D0h,00h,00h,0F0h,0FFh,059h,00h,0FFh,0FFh,030h,0D0h
; @22720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,058h,00h,07Ch,0CDh,020h,00h,0F0h,0FFh,051h,00h,0FFh,0FFh
; @22730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 054h,0CDh,00h,00h,00h,00h,050h,00h,06Ch,0CDh,020h,00h,0F0h,0FFh,04Ah,00h
; @22740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0E8h,0CFh,060h,00h,0F0h,0FFh,048h,00h,0FFh,0FFh,0E8h,0CFh,070h,00h
; @22750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,045h,00h,0FFh,0FFh,0E8h,0CFh,0C0h,00h,0F0h,0FFh,044h,00h,0FFh,0FFh
; @22760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 058h,0D0h,040h,00h,00h,00h,043h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh
; @22770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh,03Fh,00h,0FFh,0FFh,0E8h,0CFh
; @22780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,00h,0F0h,0FFh,03Eh,00h,090h,0D0h,0C0h,00h,0F0h,0FFh,03Bh,00h,0FFh,0FFh
; @22790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DCh,0CFh,020h,00h,0F0h,0FFh,036h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh
; @227A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 035h,00h,0FFh,0FFh,0E8h,0CFh,0B0h,00h,0F0h,0FFh,034h,00h,0FFh,0FFh,0E8h,0CFh
; @227B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,00h,0F0h,0FFh,02Ah,00h,0FFh,0FFh,024h,0D0h,00h,00h,00h,00h,024h,00h
; @227C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,08Ch,0CDh,060h,00h,0F0h,0FFh,021h,00h,0FFh,0FFh,0DCh,0CFh,00h,00h
; @227D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,021h,00h,0FFh,0FFh,0DCh,0CFh,020h,00h,0F0h,0FFh,021h,00h,0E4h,0CDh
; @227E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,0F0h,0FFh,015h,00h,028h,0CDh,060h,00h,0F0h,0FFh,04h,00h,070h,0D0h
; @227F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,00h,00h,00h,0FFh,0FFh,010h,01h,0D4h,0D0h,00h,00h,0F0h,0FFh,099h,00h
; @22800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,08Ch,0CDh,060h,00h,0F0h,0FFh,088h,00h,0FFh,0FFh,098h,0CDh,050h,00h
; @22810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,05Ah,00h,0FFh,0FFh,098h,0CDh,060h,00h,0F0h,0FFh,032h,00h,0FFh,0FFh
; @22820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ch,0CDh,060h,00h,0F0h,0FFh,01Ah,00h,068h,0CFh,010h,00h,0F0h,0FFh,01Ah,00h
; @22830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 088h,0CFh,0B0h,00h,0F0h,0FFh,04h,00h,070h,0D0h,070h,00h,00h,00h,0FFh,0FFh
; @22840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,01h,04h,0D1h,00h,00h,0F0h,0FFh,0B1h,00h,0B0h,0D0h,040h,00h,0F0h,0FFh
; @22850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Bh,00h,03Ch,0CFh,060h,00h,0F0h,0FFh,010h,00h,084h,0CEh,00h,00h,0F0h,0FFh
; @22860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,070h,0D0h,070h,00h,00h,00h,0FFh,0FFh,010h,01h,010h,0D1h,00h,00h
; @22870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,0D3h,00h,068h,0D1h,0A0h,00h,0F0h,0FFh,0D3h,00h,068h,0D1h,0A0h,00h
; @22880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,0D1h,00h,068h,0D1h,0A0h,00h,0F0h,0FFh,0C8h,00h,0F4h,0CFh,050h,00h
; @22890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,0C6h,00h,0F4h,0CFh,050h,00h,0F0h,0FFh,0C4h,00h,0F4h,0CFh,050h,00h
; @228A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F0h,0FFh,02Dh,00h,0FFh,0FFh,060h,0CDh,0B0h,00h,0F0h,0FFh,02Ch,00h,0FFh,0FFh
; @228B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,0CDh,0B0h,00h,0F0h,0FFh,02Bh,00h,0FFh,0FFh,060h,0CDh,0B0h,00h,0F0h,0FFh
; @228C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Ah,00h,0FFh,0FFh,060h,0CDh,0B0h,00h,0F0h,0FFh,022h,00h,0FFh,0FFh,060h,0CDh
; @228D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,0F0h,0FFh,021h,00h,0FFh,0FFh,060h,0CDh,010h,00h,0F0h,0FFh,04h,00h
; @228E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,0D0h,070h,00h,00h,00h,0FFh,0FFh,01h,00h,01h,00h,04Fh,00h,09h,00h
; @228F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,010h,00h,00h,00h
; @22900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,0F0h,0FFh,010h,00h,0E0h,0FFh,020h,00h,00h,00h,020h,00h,0F0h,0FFh
; @22910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,0E0h,0FFh,01h,00h,01h,00h,04Dh,00h,01h,00h,00h,00h,00h,00h
; @22920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,01h,00h,07Bh,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
; @22930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Ch,00h,02h,00h,08h,00h,00h,00h,028h,00h,00h,00h,01h,00h,01h,00h
; @22940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Bh,00h,02h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,02h,00h,01h,00h
; @22950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 048h,00h,01h,00h,00h,00h,00h,00h,02h,00h,01h,00h,049h,00h,01h,00h
; @22960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,01h,00h,047h,00h,03h,00h,00h,00h,00h,00h
; @22970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,00h,00h,0D0h,0FFh,01h,00h,01h,00h,046h,00h,03h,00h
; @22980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,010h,00h,00h,00h,020h,00h,00h,00h,01h,00h,00h,00h
; @22990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Ah,00h,04h,00h,00h,00h,00h,00h,030h,00h,00h,00h,060h,00h,00h,00h
; @229A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,01h,00h,00h,00h,08Ah,00h,02h,00h,00h,00h,00h,00h
; @229B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,00h,00h,01h,00h,01h,00h,066h,00h,0Ch,00h,00h,00h,00h,00h
; @229C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
; @229D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh,00h,00h,090h,0FFh,00h,00h,080h,0FFh
; @229E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,070h,0FFh,00h,00h,060h,0FFh,00h,00h,050h,0FFh,01h,00h,01h,00h
; @229F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 067h,00h,0Ch,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
; @22A00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh
; @22A10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,090h,0FFh,00h,00h,080h,0FFh,00h,00h,070h,0FFh,00h,00h,060h,0FFh
; @22A20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,050h,0FFh,01h,00h,01h,00h,045h,00h,06h,00h,00h,00h,00h,00h
; @22A30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
; @22A40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B0h,0FFh,01h,00h,01h,00h,045h,00h,010h,00h,00h,00h,00h,00h
; @22A50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
; @22A60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh,00h,00h,090h,0FFh,00h,00h,080h,0FFh
; @22A70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,070h,0FFh,00h,00h,060h,0FFh,00h,00h,050h,0FFh,00h,00h,040h,0FFh
; @22A80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,030h,0FFh,00h,00h,020h,0FFh,00h,00h,010h,0FFh,01h,00h,01h,00h
; @22A90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 043h,00h,08h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
; @22AA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh
; @22AB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,090h,0FFh,01h,00h,01h,00h,044h,00h,08h,00h,00h,00h,00h,00h
; @22AC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh
; @22AD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh,00h,00h,090h,0FFh,01h,00h,01h,00h
; @22AE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 041h,00h,06h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
; @22AF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,01h,00h,01h,00h
; @22B00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 031h,00h,09h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh
; @22B10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0D0h,0FFh,00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,00h,00h,0A0h,0FFh
; @22B20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,090h,0FFh,00h,00h,080h,0FFh,01h,00h,01h,00h,010h,00h,06h,00h
; @22B30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh
; @22B40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,01h,00h,01h,00h,011h,00h,06h,00h
; @22B50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh
; @22B60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0C0h,0FFh,00h,00h,0B0h,0FFh,01h,00h,01h,00h,042h,00h,05h,00h
; @22B70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,020h,00h,0E0h,0FFh,040h,00h,0C0h,0FFh,020h,00h,0A0h,0FFh
; @22B80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,080h,0FFh,01h,00h,01h,00h,040h,00h,04h,00h,00h,00h,00h,00h
; @22B90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,00h,00h,020h,00h,00h,00h,030h,00h,00h,00h,01h,00h,01h,00h
; @22BA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,00h,01h,00h,08h,00h,0F8h,0FFh,01h,00h,01h,00h,03Ch,00h,01h,00h
; @22BB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,01h,00h,03Bh,00h,04h,00h,08h,00h,010h,00h
; @22BC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,00h,00h,020h,00h,00h,00h,028h,00h,010h,00h,01h,00h,01h,00h
; @22BD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ah,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h,083h,00h,01h,00h
; @22BE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,01h,00h,038h,00h,01h,00h,00h,00h,00h,00h
; @22BF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,01h,00h,039h,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
; @22C00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 037h,00h,05h,00h,00h,00h,00h,00h,010h,00h,00h,00h,020h,00h,00h,00h
; @22C10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,00h,00h,040h,00h,00h,00h,01h,00h,01h,00h,035h,00h,01h,00h
; @22C20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,01h,00h,036h,00h,01h,00h,00h,00h,00h,00h
; @22C30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,01h,00h,021h,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
; @22C40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,00h,03h,00h,00h,00h,00h,00h,010h,00h,00h,00h,020h,00h,00h,00h
; @22C50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,01h,00h,04Eh,00h,03h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh
; @22C60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0E0h,0FFh,01h,00h,01h,00h,030h,00h,01h,00h,00h,00h,00h,00h
; @22C70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,01h,00h,02Dh,00h,04h,00h,00h,00h,00h,00h,010h,00h,0F0h,0FFh
; @22C80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,0F0h,0FFh,040h,00h,00h,00h,01h,00h,00h,00h,034h,00h,01h,00h
; @22C90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,01h,00h,013h,00h,01h,00h,00h,00h,00h,00h
; @22CA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,01h,00h,015h,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h
; @22CB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Ch,00h,01h,00h,00h,00h,00h,00h,01h,00h,01h,00h,01Fh,00h,01h,00h
; @22CC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,01h,00h,01h,00h,07Dh,00h,01h,00h,00h,00h,00h,00h
; @22CD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,01h,00h,07Eh,00h,01h,00h,00h,00h,00h,00h,01h,00h,00h,00h
; @22CE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,00h,04h,00h,00h,00h,00h,00h,00h,00h,0E0h,0FFh,020h,00h,00h,00h
; @22CF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,0E0h,0FFh,01h,00h,01h,00h,02Fh,00h,01h,00h,00h,00h,00h,00h
; @22D00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,00h,00h,019h,00h,03h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh
; @22D10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0E0h,0FFh,01h,00h,00h,00h,01Bh,00h,03h,00h,00h,00h,00h,00h
; @22D20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0F0h,0FFh,00h,00h,0E0h,0FFh,01h,00h,01h,00h,027h,00h,08h,00h
; @22D30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,010h,00h,00h,00h,00h,00h,0F0h,0FFh,010h,00h,0F0h,0FFh
; @22D40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0E0h,0FFh,010h,00h,0E0h,0FFh,00h,00h,0D0h,0FFh,010h,00h,0D0h,0FFh
; @22D50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,00h,00h,01Ah,00h,03h,00h,00h,00h,00h,00h,00h,00h,0F0h,0FFh
; @22D60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0E0h,0FFh,01h,00h,00h,00h,08Ch,00h,01h,00h,00h,00h,00h,00h
; @22D70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,00h,00h,08Bh,00h,01h,00h,00h,00h,00h,00h,01h,01h,01h,027h
; @22D80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 028h,029h,01h,02Ah,02Bh,02Ch,01h,01h,01h,01h,01h,01h,021h,022h,023h,01h
; @22D90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,025h,026h,01h,01h,01h,01h,018h,019h,01Ah,01Bh,01Ch,01h,01Dh,01Eh,01Fh
; @22DA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,01h,01h,01h,0Dh,0Eh,0Fh,010h,011h,012h,013h,014h,015h,016h,017h,01h
; @22DB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch,01h,090h,00h,00h
; @22DC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0C8h,00h,0C9h,00h,0CAh,00h,0C9h,00h,0DAh,00h,0DBh,00h,0DCh,00h
; @22DD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DBh,00h,0FDh,00h,0FEh,00h,0FFh,00h,0FEh,00h,0FAh,00h,0FBh,00h,0FCh,00h
; @22DE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FBh,00h,00h,00h,00h,00h,030h,00h,030h,00h,030h,00h,050h,00h,040h,00h
; @22DF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,040h,00h,00h,00h,070h,00h,030h,00h,070h,00h,050h,00h,080h,00h
; @22E00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,080h,00h,010h,00h,070h,00h,00h,00h,040h,00h,00h,00h,00h,00h
; @22E10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,010h,00h,050h,00h,0B0h,00h,050h,00h,0B0h,00h,00h,00h,060h,00h
; @22E20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,00h,00h,00h,00h,00h,00h,040h,00h,010h,00h,050h,00h,030h,075h
; @22E30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,00h,00h,0B0h,00h,030h,00h,080h,00h,030h,00h,060h,00h,040h,00h
; @22E40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,040h,00h,0B0h,00h,070h,00h,080h,00h,070h,00h,060h,00h,080h,00h
; @22E50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,080h,00h,0A0h,00h,070h,00h,0B0h,00h,040h,00h,0B0h,00h,00h,00h
; @22E60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,00h,010h,00h,060h,00h,0B0h,00h,060h,00h,0B0h,00h,0B0h,00h,060h,00h
; @22E70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,00h,00h,0B0h,00h,00h,00h,070h,00h,010h,00h,060h,00h,030h,075h
; @22E80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,00h,00h,00h,00h,00h,00h,00h,00h,020h,00h,020h,00h,00h,00h
; @22E90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,020h,00h,00h,00h,00h,00h,080h,00h,00h,00h,050h,00h,040h,00h
; @22EA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,030h,00h,010h,00h,070h,00h,040h,00h,090h,00h,00h,00h,090h,00h
; @22EB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,090h,00h,040h,00h,090h,00h,00h,00h,050h,00h,020h,00h,030h,00h
; @22EC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,00h,00h,040h,00h,040h,00h,080h,00h,00h,00h,050h,00h,00h,00h
; @22ED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,020h,00h,020h,00h,070h,00h,050h,00h,050h,00h,020h,00h,070h,00h
; @22EE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,020h,00h,020h,00h,010h,00h,00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
part17 ends
end
