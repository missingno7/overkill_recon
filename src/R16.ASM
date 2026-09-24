; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part16 segment byte public 'CODE'
assume cs:part16,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; @20000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,068h,00h,010h,00h,068h,00h,00h,00h,080h,00h,040h,00h,090h,00h
; @20010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,068h,00h,0B0h,00h,0B0h,00h,030h,075h,0B0h,00h,050h,00h,010h,00h
; @20020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,058h,00h,010h,00h,058h,00h,00h,00h,040h,00h,040h,00h,030h,00h
; @20030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,058h,00h,0B0h,00h,010h,00h,030h,075h,010h,00h,00h,00h,00h,00h
; @20040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,020h,00h,010h,00h,030h,00h,010h,00h,010h,00h,020h,00h
; @20050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,040h,00h,020h,00h,070h,00h,010h,00h,060h,00h,030h,00h,0B0h,00h
; @20060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,090h,00h,040h,00h,070h,00h,050h,00h,030h,00h,060h,00h,020h,00h
; @20070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,030h,00h,010h,00h,040h,00h,020h,00h,050h,00h,010h,00h,080h,00h
; @20080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,0B0h,00h,010h,00h,0A0h,00h,030h,00h,060h,00h,060h,00h,0A0h,00h
; @20090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,060h,00h,050h,00h,090h,00h,040h,00h,050h,00h,040h,00h,060h,00h
; @200A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,080h,00h,030h,075h,0C0h,00h,020h,00h,0C0h,00h,00h,00h,0B0h,00h
; @200B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,0B0h,00h,040h,00h,0A0h,00h,020h,00h,0A0h,00h,00h,00h,090h,00h
; @200C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,090h,00h,040h,00h,080h,00h,020h,00h,080h,00h,00h,00h,070h,00h
; @200D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,070h,00h,040h,00h,060h,00h,020h,00h,060h,00h,00h,00h,050h,00h
; @200E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,050h,00h,040h,00h,040h,00h,020h,00h,040h,00h,00h,00h,030h,00h
; @200F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,030h,00h,040h,00h,020h,00h,020h,00h,020h,00h,00h,00h,010h,00h
; @20100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,010h,00h,040h,00h,00h,00h,020h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
; @20110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,080h,00h,0C0h,00h,0FFh,0FFh,0FFh,0FFh
; @20120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,0C0h,00h,060h,00h,0C0h,00h,040h,00h,0B0h,00h,020h,00h,0B0h,00h
; @20130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,0A0h,00h,060h,00h,0A0h,00h,040h,00h,090h,00h,020h,00h,090h,00h
; @20140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,080h,00h,060h,00h,080h,00h,040h,00h,070h,00h,020h,00h,070h,00h
; @20150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,060h,00h,060h,00h,060h,00h,040h,00h,050h,00h,020h,00h,050h,00h
; @20160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,040h,00h,060h,00h,040h,00h,040h,00h,030h,00h,020h,00h,030h,00h
; @20170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,020h,00h,060h,00h,020h,00h,040h,00h,010h,00h,020h,00h,010h,00h
; @20180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,075h,00h,00h,020h,00h,0C0h,00h,0B0h,00h,0C0h,00h,0B0h,00h,00h,00h
; @20190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,0B0h,00h,010h,00h,0B0h,00h,010h,00h,010h,00h
; @201A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,010h,00h,020h,00h,0B0h,00h,030h,00h,0B0h,00h,030h,00h,010h,00h
; @201B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,010h,00h,040h,00h,0B0h,00h,050h,00h,0B0h,00h,050h,00h,010h,00h
; @201C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,010h,00h,060h,00h,0B0h,00h,070h,00h,0B0h,00h,070h,00h,010h,00h
; @201D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,010h,00h,080h,00h,0B0h,00h,090h,00h,0B0h,00h,090h,00h,010h,00h
; @201E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,010h,00h,0A0h,00h,0B0h,00h,0B0h,00h,0B0h,00h,0B0h,00h,00h,00h
; @201F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,0FFh,0FFh,0D4h,0A5h,00h,00h,0B0h,00h,010h,00h,0B0h,00h
; @20200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B0h,00h,010h,00h,0A0h,00h,00h,00h,0B0h,00h,010h,00h,090h,00h
; @20210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0B0h,00h,020h,00h,080h,00h,00h,00h,0B0h,00h,020h,00h,070h,00h
; @20220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,060h,00h,010h,00h,060h,00h,00h,00h,010h,00h,010h,00h,010h,00h
; @20230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,010h,00h,010h,00h,020h,00h,00h,00h,010h,00h,010h,00h,030h,00h
; @20240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,010h,00h,020h,00h,040h,00h,00h,00h,010h,00h,020h,00h,050h,00h
; @20250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,010h,00h,030h,00h,020h,00h,060h,00h,020h,00h,030h,00h,030h,00h
; @20260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,030h,00h,050h,00h,030h,00h,060h,00h,040h,00h,040h,00h,050h,00h
; @20270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,050h,00h,030h,00h,060h,00h,060h,00h,060h,00h,040h,00h,060h,00h
; @20280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,070h,00h,050h,00h,060h,00h,060h,00h,080h,00h,040h,00h,070h,00h
; @20290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,090h,00h,050h,00h,090h,00h,060h,00h,0A0h,00h,030h,00h,090h,00h
; @202A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,0B0h,00h,030h,00h,0A0h,00h,090h,00h,030h,00h,0FFh,0FFh,0FFh,0FFh
; @202B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,075h,00h,00h,00h,00h,060h,00h,010h,00h,050h,00h,010h,00h,060h,00h
; @202C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,070h,00h,020h,00h,060h,00h,020h,00h,060h,00h,030h,00h,060h,00h
; @202D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,060h,00h,040h,00h,060h,00h,040h,00h,060h,00h,050h,00h,060h,00h
; @202E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,060h,00h,060h,00h,070h,00h,060h,00h,070h,00h,050h,00h,080h,00h
; @202F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,080h,00h,040h,00h,090h,00h,040h,00h,090h,00h,030h,00h,0A0h,00h
; @20300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,0B0h,00h,020h,00h,0B0h,00h,030h,00h,0B0h,00h,010h,00h,0C0h,00h
; @20310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,0B0h,00h,00h,00h,0C0h,00h,010h,00h,0A0h,00h,00h,00h,00h,00h
; @20320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,020h,00h,010h,00h,00h,00h,020h,00h,010h,00h,020h,00h,010h,00h
; @20330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,010h,00h,030h,00h,020h,00h,050h,00h,010h,00h,040h,00h,030h,00h
; @20340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,030h,00h,050h,00h,040h,00h,050h,00h,040h,00h,060h,00h,050h,00h
; @20350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,050h,00h,070h,00h,060h,00h,0FFh,0FFh,0FFh,0FFh,030h,075h,00h,00h
; @20360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,0C0h,00h,030h,00h,08h,00h,010h,00h,0C0h,00h,020h,00h
; @20370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,020h,00h,0C0h,00h,020h,00h,020h,00h,030h,00h,0C0h,00h,030h,00h
; @20380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,040h,00h,0C0h,00h,040h,00h,040h,00h,050h,00h,0C0h,00h,040h,00h
; @20390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,060h,00h,0C0h,00h,050h,00h,050h,00h,060h,00h,0B0h,00h,030h,00h
; @203A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,060h,00h,0A0h,00h,040h,00h,060h,00h,060h,00h,090h,00h,040h,00h
; @203B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,00h,060h,00h,080h,00h,050h,00h,070h,00h,060h,00h,070h,00h,040h,00h
; @203C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,060h,00h,060h,00h,030h,00h,090h,00h,060h,00h,050h,00h,020h,00h
; @203D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A0h,00h,060h,00h,040h,00h,020h,00h,0B0h,00h,060h,00h,030h,00h,030h,00h
; @203E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B8h,00h,060h,00h,00h,00h,00h,00h,00h,00h,030h,075h,00h,00h,050h,00h
; @203F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,00h,050h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0C0h,00h,030h,075h
; @20400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,044h,0A8h,040h,00h,090h,00h,040h,00h,080h,00h,030h,00h,080h,00h
; @20410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,090h,00h,020h,00h,070h,00h,020h,00h,050h,00h,030h,00h,040h,00h
; @20420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,030h,00h,040h,00h,030h,00h,040h,00h,040h,00h,030h,00h,010h,00h
; @20430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,010h,00h,010h,00h,010h,00h,010h,00h,020h,00h,010h,00h,030h,00h
; @20440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,00h,090h,00h,010h,00h,0A0h,00h,010h,00h,0B0h,00h,020h,00h,0B0h,00h
; @20450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,0B0h,00h,096h,0A8h,080h,00h,030h,00h,00h,00h,070h,00h,090h,00h
; @20460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,0C0h,00h,010h,00h,0A0h,00h,040h,00h,060h,00h,0B0h,00h,090h,00h
; @20470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @20480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @20490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,050h,00h,0A8h,00h,050h,00h,090h,00h,050h,00h,078h,00h,050h,00h
; @204A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,050h,00h,048h,00h,050h,00h,030h,00h,050h,00h,018h,00h,050h,00h
; @204B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,038h,00h,00h,00h,038h,00h,018h,00h,038h,00h,030h,00h,038h,00h
; @204C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 048h,00h,038h,00h,060h,00h,038h,00h,078h,00h,038h,00h,090h,00h,038h,00h
; @204D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A8h,00h,020h,00h,0A8h,00h,020h,00h,090h,00h,020h,00h,078h,00h,020h,00h
; @204E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,00h,020h,00h,048h,00h,020h,00h,030h,00h,020h,00h,018h,00h,020h,00h
; @204F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,036h,023h,02h,00h,036h,023h,03h,00h,028h,023h,04h,00h,028h,023h
; @20500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,00h,026h,023h,05h,00h,026h,023h,06h,00h,026h,023h,07h,00h,026h,023h
; @20510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,00h,00h,00h,00h,00h,00h,090h,00h,00h,00h,00h,00h,00h,00h,00h
; @20520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @20530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @20540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,02Ah,015h,00h,030h,024h,04h,020h,07h,020h,07h,020h,07h,020h,07h
; @20550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0DAh,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @20560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @20570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @20580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @20590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @205A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @205B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @205C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @205D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0B7h,07h,020h,07h,020h,07h
; @205E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @205F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,048h,07h,04Fh,07h,057h,07h,020h,07h,054h,07h,04Fh,07h
; @20610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,04Fh,07h,052h,07h,044h,07h,045h,07h,052h,07h,020h,07h,04Fh,07h
; @20620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 056h,07h,045h,07h,052h,07h,04Bh,07h,049h,07h,04Ch,07h,04Ch,07h,020h,07h
; @20630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,07h,020h,07h,054h,07h,048h,07h,045h,07h,020h,07h,053h,07h,049h,07h
; @20640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 058h,07h,020h,07h,050h,07h,04Ch,07h,041h,07h,04Eh,07h,045h,07h,054h,07h
; @20650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,04Dh,07h,045h,07h,047h,07h,041h,07h,042h,07h,04Ch,07h,041h,07h
; @20660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,07h,054h,07h,021h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @206A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @206B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @206C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @206D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @206E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @206F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @20700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @20710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0B6h,07h,020h,07h,020h,07h
; @20720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,041h,07h,06Ch,07h,06Ch,07h,020h,07h,073h,07h
; @20740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 069h,07h,078h,07h,020h,07h,070h,07h,06Ch,07h,061h,07h,06Eh,07h,065h,07h
; @20750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,073h,07h,020h,07h,06Fh,07h,066h,07h,020h,07h,04Fh,07h,076h,07h
; @20760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,07h,072h,07h,04Bh,07h,069h,07h,06Ch,07h,06Ch,07h,020h,07h,063h,07h
; @20770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,07h,06Eh,07h,020h,07h,062h,07h,065h,07h,020h,07h,06Fh,07h,072h,07h
; @20780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,07h,065h,07h,072h,07h,065h,07h,064h,07h,020h,07h,062h,07h,079h,07h
; @20790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,063h,07h,061h,07h,06Ch,07h,06Ch,07h,069h,07h,06Eh,07h,067h,07h
; @207A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,074h,07h,06Fh,07h,06Ch,07h,06Ch,07h,020h,07h,066h,07h,072h,07h
; @207B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,07h,065h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @207C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @207D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,066h,07h,072h,07h,06Fh,07h,06Dh,07h
; @207E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,074h,07h,068h,07h,065h,07h,020h,07h,055h,07h,053h,07h,041h,07h
; @207F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,06Fh,07h,072h,07h,020h,07h,043h,07h,061h,07h,06Eh,07h,061h,07h
; @20800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,07h,061h,07h,020h,07h,038h,07h,030h,07h,030h,07h,02Dh,07h,039h,07h
; @20810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 037h,07h,032h,07h,02Dh,07h,037h,07h,034h,07h,033h,07h,034h,07h,02Ch,07h
; @20820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,06Fh,07h,072h,07h,020h,07h,063h,07h,061h,07h,06Ch,07h,06Ch,07h
; @20830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,033h,07h,030h,07h,031h,07h,020h,07h,032h,07h,039h,07h,039h,07h
; @20840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,07h,033h,07h,038h,07h,034h,07h,031h,07h,02Eh,07h,020h,07h,020h,07h
; @20850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @208A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @208B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @208C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @208D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @208E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @208F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,054h,07h,068h,07h,065h,07h,020h,07h,070h,07h
; @20920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,07h,069h,07h,063h,07h,065h,07h,020h,07h,069h,07h,073h,07h,020h,07h
; @20930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,07h,033h,07h,030h,07h,020h,07h,066h,07h,06Fh,07h,072h,07h,020h,07h
; @20940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,068h,07h,065h,07h,020h,07h,073h,07h,069h,07h,078h,07h,02Dh,07h
; @20950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,07h,06Ch,07h,061h,07h,06Eh,07h,065h,07h,074h,07h,020h,07h,06Dh,07h
; @20960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,07h,067h,07h,061h,07h,062h,07h,06Ch,07h,061h,07h,073h,07h,074h,07h
; @20970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,070h,07h,06Ch,07h,075h,07h,073h,07h,020h,07h,024h,07h,034h,07h
; @20980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,073h,07h,068h,07h,069h,07h,070h,07h,070h,07h,069h,07h,06Eh,07h
; @20990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 067h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @209A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @209B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,061h,07h,06Eh,07h,064h,07h,020h,07h
; @209C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 068h,07h,061h,07h,06Eh,07h,064h,07h,06Ch,07h,069h,07h,06Eh,07h,067h,07h
; @209D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,069h,07h,06Eh,07h,020h,07h,055h,07h,02Eh,07h,053h,07h,02Eh,07h
; @209E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,046h,07h,075h,07h,06Eh,07h,064h,07h,073h,07h,02Eh,07h,020h,07h
; @209F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20A40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20A90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20AA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20AB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20AC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20AD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20AE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20AF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,04Dh,07h,061h,07h,072h,07h,079h,07h,06Ch,07h
; @20B00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,07h,06Eh,07h,064h,07h,020h,07h,072h,07h,065h,07h,073h,07h,069h,07h
; @20B10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,07h,065h,07h,06Eh,07h,074h,07h,073h,07h,020h,07h,04Dh,07h,055h,07h
; @20B20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,07h,054h,07h,020h,07h,061h,07h,064h,07h,064h,07h,020h,07h,035h,07h
; @20B30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,07h,020h,07h,074h,07h,061h,07h,078h,07h,020h,07h,020h,07h,020h,07h
; @20B40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20B50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20B60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20B70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20B80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20B90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20BA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20BB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20BC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20BD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20BE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20BF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20C00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20C10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20C20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20C30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,057h,07h,065h,07h,020h,07h,061h,07h,063h,07h
; @20C40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,07h,065h,07h,070h,07h,074h,07h,020h,07h,056h,07h,069h,07h,073h,07h
; @20C50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,07h,020h,07h,026h,07h,020h,07h,04Dh,07h,061h,07h,073h,07h,074h,07h
; @20C60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,07h,072h,07h,020h,07h,043h,07h,061h,07h,072h,07h,064h,07h,02Eh,07h
; @20C70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20C80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20C90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20CA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20CB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20CC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20CD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20CE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20CF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20D00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20D10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20D20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20D30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20D40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20D50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20D60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20D70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,04Fh,07h,072h,07h,020h,07h,073h,07h,065h,07h
; @20D80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,07h,064h,07h,020h,07h,063h,07h,068h,07h,065h,07h,063h,07h,06Bh,07h
; @20D90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,06Fh,07h,072h,07h,020h,07h,06Dh,07h,06Fh,07h,06Eh,07h,065h,07h
; @20DA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 079h,07h,020h,07h,06Fh,07h,072h,07h,064h,07h,065h,07h,072h,07h,020h,07h
; @20DB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,07h,06Fh,07h,03Ah,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20DC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20DD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20DE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20DF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20E00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20E90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20EA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20EB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,045h,07h,070h,07h,069h,07h,063h,07h,020h,07h
; @20EC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Dh,07h,065h,07h,067h,07h,061h,07h,047h,07h,061h,07h,06Dh,07h,065h,07h
; @20ED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20EE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20EF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20F00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20F10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20F20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20F30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20F40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20F50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,031h,07h,030h,07h,034h,07h,030h,07h,036h,07h
; @20F60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,048h,07h,06Fh,07h,06Ch,07h,062h,07h,072h,07h,06Fh,07h,06Fh,07h
; @20F70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Bh,07h,020h,07h,044h,07h,072h,07h,069h,07h,076h,07h,065h,07h,020h,07h
; @20F80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20F90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20FA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20FB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20FC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20FD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @20FE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @20FF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,050h,07h,06Fh,07h,074h,07h,06Fh,07h,06Dh,07h
; @21000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,07h,063h,07h,02Ch,07h,020h,07h,04Dh,07h,044h,07h,020h,07h,032h,07h
; @21010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,07h,038h,07h,035h,07h,034h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @21080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,055h,07h,02Eh,07h,053h,07h,02Eh,07h,041h,07h
; @210A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @210B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @210C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @210D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @210E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @210F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @21120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @21140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @21150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @21160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @21170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @21180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @21190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @211A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h
; @211B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0C4h,07h,0B6h,07h,020h,07h,020h,07h
; @211C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @211D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B3h,07h,020h,07h,020h,07h,043h,07h,06Fh,07h,070h,07h,079h,07h,072h,07h
; @211E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 069h,07h,067h,07h,068h,07h,074h,07h,020h,07h,028h,07h,063h,07h,029h,07h
; @211F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,031h,07h,039h,07h,039h,07h,032h,07h,020h,07h,054h,07h,065h,07h
; @21200 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,07h,068h,07h,02Dh,07h,04Eh,07h,06Fh,07h,069h,07h,072h,07h,020h,07h
; @21210 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21220 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21230 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21240 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21250 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,0BAh,07h,020h,07h,020h,07h
; @21260 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21270 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D4h,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @21280 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @21290 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @212A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @212B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @212C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @212D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @212E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h
; @212F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0CDh,07h,0BCh,07h,020h,07h,020h,07h
; @21300 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21310 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21320 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21330 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21340 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21350 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21360 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21370 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21380 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21390 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @213A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @213B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @213C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @213D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @213E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @213F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21400 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21410 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21420 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21430 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21440 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21450 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21460 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21470 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21480 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @21490 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @214A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @214B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @214C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @214D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h,020h,07h
; @214E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,07h,020h,07h,020h,07h,020h,07h,045h,04Dh,04Dh,058h,058h,058h,058h,030h
; @214F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,03Ah,0B9h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21500 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21510 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21520 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21530 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21540 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21550 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21560 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21570 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21580 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21590 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @215A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @215B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @215C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @215D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @215E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @215F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21600 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21610 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21620 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21630 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21640 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21650 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21660 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21670 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21680 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21690 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @216A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @216B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @216C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @216D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @216E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @216F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21700 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21710 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21720 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21730 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
; @21740 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,090h,00h,00h,04Fh,056h,045h,052h,04Bh,049h,04Ch,04Ch
; @21750 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,045h,058h,045h,00h,024h,04Fh,056h,045h,052h,04Bh,049h,04Ch,04Ch,00h,024h
; @21760 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,072h,072h,06Fh,072h,020h,021h,021h,021h,021h,020h,03Ah,02Dh,0Dh,0Ah,0Dh
; @21770 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ah,046h,069h,06Ch,065h,020h,027h,024h,08h,027h,020h,068h,061h,073h,020h,062h
; @21780 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 065h,065h,06Eh,020h,063h,06Fh,072h,072h,075h,070h,074h,065h,064h,02Ch,020h,06Fh
; @21790 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 072h,020h,070h,06Fh,073h,073h,069h,062h,06Ch,079h,020h,069h,06Eh,066h,065h,063h
; @217A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,065h,064h,020h,062h,079h,020h,061h,020h,076h,069h,072h,075h,073h,021h,021h
; @217B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,050h,072h,065h,073h,073h,020h,061h,06Eh,079h,020h,06Bh,065h,079h,020h,074h
; @217C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Fh,020h,072h,065h,074h,075h,072h,06Eh,020h,074h,06Fh,020h,044h,04Fh,053h,02Eh
; @217D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,02Eh,02Eh,02Eh,02Eh,024h,011h,00h,00h,010h,0Fh,043h,06Fh,064h,065h,077h
; @217E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Fh,072h,064h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,03Dh,020h
; @217F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21800 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,011h,01h,00h,010h,0Fh,04Eh,06Fh,06Eh,041h,073h,063h,069h,069h,043h,06Fh
; @21810 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 064h,065h,077h,06Fh,072h,064h,020h,020h,020h,03Dh,020h,00h,00h,00h,00h,00h
; @21820 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,02h,00h,010h
; @21830 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Fh,04Fh,04Ch,044h,04Eh,06Fh,06Eh,041h,073h,063h,069h,069h,043h,06Fh,064h,065h
; @21840 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,06Fh,072h,064h,03Dh,020h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21850 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,011h,03h,00h,010h,0Fh,050h,061h,073h,073h
; @21860 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 077h,06Fh,072h,064h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,03Dh
; @21870 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21880 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,010h,0Fh,011h,0Ch,03h,053h,06Fh,075h,06Eh,064h,020h
; @21890 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 063h,061h,072h,064h,020h,075h,073h,065h,064h,03Ah,020h,041h,064h,06Ch,069h,062h
; @218A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,063h,06Fh,06Dh,070h,061h,074h,069h,062h,06Ch,065h,00h,010h,0Fh,011h,0Ch
; @218B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,053h,06Fh,075h,06Eh,064h,020h,063h,061h,072h,064h,020h,075h,073h,065h,064h
; @218C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ah,020h,054h,061h,06Eh,064h,079h,020h,069h,06Eh,074h,065h,072h,06Eh,061h,06Ch
; @218D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,010h,0Fh,011h,0Ch,05h,053h,06Fh,075h,06Eh,064h,020h,063h,061h,072h,064h
; @218E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,075h,073h,065h,064h,03Ah,020h,052h,06Fh,06Ch,061h,06Eh,064h,020h,04Ch,041h
; @218F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 050h,043h,031h,00h,061h,064h,06Ch,069h,062h,02Eh,065h,06Eh,063h,00h,074h,061h
; @21900 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,064h,079h,02Eh,065h,06Eh,063h,00h,072h,06Fh,06Ch,061h,06Eh,064h,02Eh,065h
; @21910 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,063h,00h,090h,01Fh,07h,00h,039h,017h,03h,089h,07h,06h,08Dh,015h,09h
; @21920 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B6h,01h,0Ch,018h,04h,01h,035h,017h,04h,085h,04h,07h,08Dh,015h,0Ah,0B6h
; @21930 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0Dh,0Eh,02h,02h,032h,017h,05h,082h,02h,08h,08Dh,015h,0Bh,0B6h,01h
; @21940 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Eh,0B0h,01h,02h,013h,088h,015h,07h,010h,08h,01h,0Fh,014h,030h,016h,06h
; @21950 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,080h,02h,06h,013h,00h,00h,090h,00h,00h,00h,00h,00h,00h,00h,00h
; @21960 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,06Fh,076h,065h,072h,06Bh,069h,06Ch,06Ch,00h,0FFh,00h,00h,024h,03Ch
; @21970 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BEh,0BDh,04Ch,03Dh,0D9h,0BDh,074h,03Fh,0E9h,0BDh,09Ch,03Eh,0F7h,0BDh,010h,0Fh
; @21980 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,05h,06h,042h,06Fh,06Eh,075h,073h,020h,057h,065h,061h,070h,06Fh,06Eh,020h
; @21990 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 053h,065h,06Ch,065h,063h,074h,06Fh,072h,00h,011h,0Ah,06h,042h,06Fh,06Eh,075h
; @219A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,020h,053h,068h,069h,065h,06Ch,064h,00h,011h,0Fh,06h,042h,06Fh,06Eh,075h
; @219B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 073h,020h,046h,075h,065h,06Ch,00h,011h,014h,06h,053h,06Dh,061h,072h,074h,020h
; @219C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 042h,06Fh,06Dh,062h,00h,090h,00h,00h,00h,00h,00h,00h,010h,03h,011h,03h
; @219D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,00h,011h,05h,01Fh,00h,00h,00h,02Ah,00h,03h,00h,0Ch,00h,02Dh,00h
; @219E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,00h,09h,00h,030h,00h,02h,00h,0Ah,00h,033h,00h,03h,00h,0Dh,00h
; @219F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,00h,02h,00h,0Ah,00h,036h,00h,03h,00h,0Eh,00h,02Bh,00h,02h,00h
; @21A00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Bh,00h,02Eh,00h,02h,00h,0Bh,00h,02Dh,00h,02h,00h,09h,00h,031h,00h
; @21A10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,034h,00h,00h,00h,01h,00h,037h,00h,01h,00h,06h,00h
; @21A20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,00h,00h,00h,02h,00h,02Ch,00h,00h,00h,03h,00h,02Fh,00h,00h,00h
; @21A30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,032h,00h,00h,00h,05h,00h,035h,00h,0FFh,0FFh,0FFh,0FFh,038h,00h
; @21A40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,07h,00h,039h,00h,0FFh,0FFh,0FFh,0FFh,03Ah,00h,0FFh,0FFh,0FFh,0FFh
; @21A50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,023h,013h,032h,013h,041h,013h,050h,013h,05Fh,013h,0FFh,0FFh,01h,00h
; @21A60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,013h,07Dh,013h,08Ch,013h,09Bh,013h,0AAh,013h,0B9h,013h,0C8h,013h,0D7h,013h
; @21A70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E6h,013h,0F5h,013h,0FFh,0FFh,00h,00h,05h,014h,0FFh,0FFh,00h,00h,014h,014h
; @21A80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0FFh,00h,00h,022h,014h,0FFh,0FFh,00h,00h,030h,014h,0FFh,0FFh,00h,00h
; @21A90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,014h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,01h,00h,02h,02Eh
; @21AA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,053h,02h,078h,015h,02Eh,015h,053h,015h,078h,014h,0A5h,019h,0A5h,01Eh,0A5h
; @21AB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Fh,0D6h,0D6h,0D5h,041h,0D6h,048h,0D6h,04Fh,0D6h,0CCh,0D5h,00h,00h,00h,00h
; @21AC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,043h,047h,043h,043h,07Dh,03Fh,0ECh,03Bh,08Fh,038h,063h,035h,064h,032h,090h
; @21AD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Fh,0E4h,02Ch,05Fh,02Ah,0FFh,027h,0C0h,025h,0A2h,023h,0A2h,021h,0BEh,01Fh,0F6h
; @21AE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Dh,048h,01Ch,0B1h,01Ah,032h,019h,0C8h,017h,072h,016h,030h,015h,0FFh,013h,0E0h
; @21AF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 012h,0D1h,011h,0D1h,010h,0DFh,0Fh,0FBh,0Eh,024h,0Eh,059h,0Dh,099h,0Ch,0E4h
; @21B00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Bh,039h,0Bh,098h,0Ah,00h,0Ah,070h,09h,0E8h,08h,068h,08h,0F0h,07h,07Dh
; @21B10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,011h,07h,0ABh,06h,04Bh,06h,0F1h,05h,09Ch,05h,04Bh,05h,0FFh,04h,0B7h
; @21B20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,074h,04h,034h,04h,0F8h,03h,0BEh,03h,088h,03h,055h,03h,025h,03h,0F8h
; @21B30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0CDh,02h,0A5h,02h,07Fh,02h,05Bh,02h,03Ah,02h,01Ah,02h,0FCh,01h,0DFh
; @21B40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C4h,01h,0ABh,01h,093h,01h,07Ch,01h,067h,01h,053h,01h,040h,01h,02Eh
; @21B50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,01Dh,01h,0Dh,01h,0FEh,00h,0F0h,00h,0E2h,00h,0D6h,00h,0CAh,00h,0BEh
; @21B60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0B4h,00h,0AAh,00h,0A0h,00h,097h,00h,090h,00h,00h,00h,00h,00h,00h
; @21B70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21B80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,00h,01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0C2h,0C2h
; @21B90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CBh,0C2h,0CAh,0C1h,0D5h,0C1h,0BAh,0C1h,0C2h,0C1h,0D4h,0C2h,0D4h,0C2h,066h,0C2h
; @21BA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 066h,0C2h,018h,0C1h,02Eh,0C1h,0C7h,0C0h,0CAh,0C0h,0ECh,0C0h,02h,0C1h,082h,0C1h
; @21BB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 085h,0C1h,08Eh,0C1h,0F3h,0C2h,068h,0C1h,075h,0C1h,09Bh,0C1h,0F3h,0C2h,091h,0C1h
; @21BC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F3h,0C2h,0E0h,0C1h,0E3h,0C1h,0CDh,0C0h,0D4h,0C0h,058h,0C2h,05Fh,0C2h,02h,0C2h
; @21BD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,0C2h,0F4h,0C1h,0FBh,0C1h,074h,0C0h,07Bh,0C0h,066h,0C0h,06Dh,0C0h,082h,0C0h
; @21BE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,0C0h,090h,0C0h,09Ch,0C0h,058h,0C0h,05Fh,0C0h,0E6h,0C1h,0EDh,0C1h,0DBh,0C0h
; @21BF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E3h,0C0h,0B2h,0C1h,0B6h,0C1h,0A2h,0C1h,0A9h,0C1h,04Ah,0C0h,051h,0C0h,048h,0C1h
; @21C00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F3h,0C2h,088h,0C1h,08Bh,0C1h,058h,0C1h,0F3h,0C2h,0E7h,084h,0Ch,00h,08h,03Ch
; @21C10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,0E7h,084h,06h,00h,08h,030h,080h,0EBh,084h,098h,00h,0Ch,024h,080h,0EBh
; @21C20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 084h,098h,00h,0Ch,024h,080h,0E9h,084h,098h,00h,06h,03Ch,080h,0E9h,084h,098h
; @21C30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,06h,03Ch,080h,0E9h,084h,060h,00h,08h,048h,080h,0E9h,084h,060h,00h,08h
; @21C40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 048h,080h,0E2h,084h,060h,00h,08h,048h,080h,0E2h,084h,060h,00h,08h,048h,080h
; @21C50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0F7h,084h,040h,00h,0FFh,018h,084h,080h,0FFh,0FFh,085h,080h,0F7h,084h,042h,00h
; @21C60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,01Bh,084h,080h,0FFh,0FFh,085h,080h,0E5h,084h,0E0h,07Fh,06h,030h,084h,040h
; @21C70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,037h,084h,0E0h,07Fh,06h,030h,084h,040h,080h,037h,080h,0E5h,084h,0E0h,07Fh
; @21C80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,037h,084h,040h,080h,03Eh,080h,0E4h,03Ch,080h,0E4h,043h,080h,0E4h,084h,082h
; @21C90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,05h,048h,080h,0E4h,084h,082h,04h,05h,046h,080h,0E7h,082h,07h,0EAh,082h
; @21CA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 016h,085h,080h,0E5h,082h,0E6h,08h,0EFh,082h,015h,085h,080h,0E8h,084h,096h,00h
; @21CB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,0Ch,084h,096h,00h,030h,0Ch,084h,096h,00h,030h,0Ch,084h,096h,00h,030h
; @21CC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0Ch,080h,0E8h,084h,096h,00h,030h,01Dh,084h,096h,00h,030h,01Ch,084h,096h,00h
; @21CD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 030h,01Bh,084h,096h,00h,030h,01Ah,080h,0EFh,084h,096h,00h,030h,010h,084h,096h
; @21CE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,030h,015h,084h,096h,00h,030h,018h,084h,096h,00h,030h,015h,080h,0E1h,03Ch
; @21CF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,03Fh,040h,03Fh,03Ch,03Bh,03Ah,043h,045h,043h,041h,040h,03Fh,03Ch,03Bh,048h
; @21D00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,046h,045h,043h,041h,040h,03Fh,080h,0E4h,047h,045h,043h,041h,040h,03Eh,03Ch
; @21D10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,039h,037h,035h,034h,032h,030h,080h,0E1h,047h,045h,043h,041h,040h,03Eh,03Ch
; @21D20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Bh,039h,037h,035h,034h,032h,030h,080h,0F1h,084h,064h,00h,010h,013h,0E7h,084h
; @21D30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ch,0FCh,06h,085h,080h,0F1h,084h,064h,00h,010h,016h,0E7h,084h,09Ch,0FCh,06h
; @21D40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 085h,080h,0E7h,01Fh,080h,0E7h,022h,080h,0E4h,037h,080h,0E4h,039h,080h,0EFh,02Bh
; @21D50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,0FFh,084h,0F4h,0FFh,0FFh,02Bh,085h,085h,085h,080h,0E5h,084h,02h,00h,0Ch
; @21D60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 037h,080h,0E9h,084h,07Bh,00h,063h,02Bh,080h,0E2h,081h,0E9h,084h,07Bh,00h,063h
; @21D70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,080h,0E5h,082h,01Fh,080h,0E5h,082h,02Bh,080h,0FFh,084h,080h,01h,0FFh,037h
; @21D80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 085h,080h,0FFh,084h,080h,01h,0FFh,039h,085h,080h,0FFh,082h,02Bh,082h,026h,082h
; @21D90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,0F7h,082h,01Ah,080h,0FFh,082h,02Eh,082h,029h,082h,022h,0F7h,082h,01Dh,080h
; @21DA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E4h,048h,080h,0E4h,047h,080h,0F7h,084h,080h,0FEh,020h,0Ch,080h,0F7h,084h,080h
; @21DB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FEh,020h,0Fh,080h,0E5h,084h,0C0h,00h,018h,023h,080h,0E5h,084h,0C0h,00h,018h
; @21DC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 026h,080h,0E1h,084h,00h,0FCh,02h,018h,084h,00h,0FCh,02h,015h,084h,00h,0FCh
; @21DD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,016h,084h,00h,0FCh,02h,013h,084h,00h,0FCh,02h,012h,084h,00h,0FCh,02h
; @21DE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 014h,084h,00h,0FCh,02h,015h,0E7h,084h,00h,0FCh,0Ch,01Dh,080h,0E1h,084h,00h
; @21DF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FCh,02h,020h,084h,00h,0FCh,02h,018h,084h,00h,0FCh,02h,01Eh,084h,00h,0FCh
; @21E00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,01Dh,084h,00h,0FCh,02h,01Ah,084h,00h,0FCh,02h,017h,084h,00h,0FCh,02h
; @21E10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 015h,0E7h,084h,00h,0FCh,0Ch,021h,080h,0F7h,084h,07Fh,0FFh,018h,024h,080h,0F7h
; @21E20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 084h,07Fh,0FFh,018h,028h,080h,0F7h,084h,040h,00h,0FFh,018h,0EFh,084h,040h,00h
; @21E30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,01Ch,0F7h,084h,040h,00h,0FFh,013h,0EFh,084h,040h,00h,0FFh,016h,0F7h,084h
; @21E40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 040h,00h,0FFh,0Eh,0EFh,084h,040h,00h,0FFh,012h,0F7h,084h,040h,00h,0FFh,09h
; @21E50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EFh,084h,040h,00h,0FFh,0Ch,0FFh,084h,040h,00h,0FFh,04h,080h,0F7h,084h,040h
; @21E60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0FFh,018h,0EFh,084h,040h,00h,0FFh,01Ch,0F7h,084h,040h,00h,0FFh,013h,0EFh
; @21E70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 084h,040h,00h,0FFh,016h,0F7h,084h,040h,00h,0FFh,0Eh,0EFh,084h,040h,00h,0FFh
; @21E80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 012h,080h,0FFh,084h,040h,020h,0FFh,013h,085h,085h,080h,0FFh,084h,020h,061h,0FFh
; @21E90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 010h,085h,085h,080h,0E2h,018h,081h,01Dh,081h,01Fh,081h,023h,081h,024h,081h,029h
; @21EA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,02Bh,081h,02Fh,081h,030h,081h,037h,081h,03Bh,081h,081h,081h,03Ch,081h,043h
; @21EB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,048h,080h,0FFh,081h,081h,081h,081h,081h,081h,081h,081h,080h,00h,070h,061h
; @21EC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 079h,06Dh,065h,06Eh,074h,02Eh,065h,06Eh,063h,00h,049h,030h,06Eh,030h,066h,030h
; @21ED0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Fh,030h,072h,030h,06Dh,030h,061h,030h,074h,030h,069h,030h,06Fh,030h,06Eh,030h
; @21EE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Ah,030h,020h,030h,020h,030h,020h,030h,020h,030h,020h,030h,020h,030h,028h,030h
; @21EF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Bh,030h,065h,030h,079h,030h,073h,030h,03Ah,030h,02Dh,030h,020h,030h,043h,030h
; @21F00 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,030h,072h,030h,073h,030h,06Fh,030h,072h,030h,020h,030h,055h,030h,070h,030h
; @21F10 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,030h,026h,030h,020h,030h,044h,030h,06Fh,030h,077h,030h,06Eh,030h,020h,030h
; @21F20 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Fh,030h,020h,030h,050h,030h,061h,030h,067h,030h,065h,030h,020h,030h,055h,030h
; @21F30 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 070h,030h,020h,030h,026h,030h,020h,030h,044h,030h,06Fh,030h,077h,030h,06Eh,030h
; @21F40 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 020h,030h,02Fh,030h,020h,030h,048h,030h,06Fh,030h,06Dh,030h,065h,030h,020h,030h
; @21F50 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Fh,030h,020h,030h,045h,030h,06Eh,030h,064h,030h,020h,030h,02Fh,030h,020h,030h
; @21F60 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 045h,030h,053h,030h,043h,030h,029h,030h,020h,030h,00h,00h,00h,00h,00h,00h
; @21F70 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21F80 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21F90 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21FA0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21FB0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21FC0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21FD0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21FE0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @21FF0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
part16 ends
end
