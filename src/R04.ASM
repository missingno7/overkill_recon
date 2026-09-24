; Modern physical chunk, NOT an inferred original object boundary.
include ENCODING.INC
part04 segment byte public 'CODE'
assume cs:part04,ds:nothing,ss:nothing,es:nothing
chunk_base label byte
; Offset-placement use of field+8 does not define its role in other record types.
OFFSET_PAIR_INDEX_08 equ 08h
OFFSET_TABLE_A368 equ 0A368h
OFFSET_TABLE_A374 equ 0A374h
OFFSET_TABLE_A380 equ 0A380h
OFFSET_TABLE_A38C equ 0A38Ch
OFFSET_X_GROUP_A equ 0A39Ah
OFFSET_X_GROUP_B equ 0A39Ch
OFFSET_X_WORK equ 0A398h
; Modern position-history symbols; see metadata/position-history.json.
HISTORY_BEGIN equ 0A27Ah
HISTORY_CURSOR_47 equ 0A340h
HISTORY_END equ 0A33Ah
HISTORY_INITIAL_CURSOR_47 equ 0A27Eh
HISTORY_INITIAL_READ_15 equ 0A2FEh
HISTORY_INITIAL_READ_31 equ 0A2BEh
HISTORY_PAIR_BYTES equ 04h
HISTORY_PAIR_COUNT equ 030h
HISTORY_READ_CURSOR_15 equ 0A33Ch
HISTORY_READ_CURSOR_31 equ 0A33Eh
HISTORY_WRITE_CURSOR equ 0A33Ah
MAIN_DATA_SEGMENT equ 09596h
PRIMARY_RECORD equ 0237Ch
REC_X equ 04h
REC_Y equ 02h
CountXReturn equ 044AFh
CountXIncIfGate equ 09C82h
CountXInc equ 09C93h
CountXDecIfGate equ 09C9Ch
CountXDec equ 09CADh
; Modern record/state symbols; evidence in metadata/record-movement.json.
AUTO_XMINUS_A39F equ 0A39Fh
AUTO_XPLUS_A39E equ 0A39Eh
COUNT_GATE_2324 equ 02324h
COUNT_X_TABLE equ 09C70h
INPUT_BITS equ 098BEh
IN_XMINUS equ 02h
IN_XPLUS equ 01h
IN_YMINUS equ 08h
IN_YPLUS equ 04h
MINUS_SLOT_A968 equ 0A968h
MINUS_SLOT_A96C equ 0A96Ch
MOVE_MODE_A47C equ 0A47Ch
PLUS_SLOT_A966 equ 0A966h
PLUS_SLOT_A96A equ 0A96Ah
X_ADJUST_TAKEN equ 0A360h
loc_09C8A equ 01C8Ah
loc_09CA4 equ 01CA4h
loc_0A5FC equ 025FCh
loc_0A60A equ 0260Ah
loc_08D6D equ 0D6Dh
loc_0BFC7 equ 03FC7h
loc_074FE equ 0F4FEh
FindFreeRecordPoolA_07524 equ 0F524h
loc_07E58 equ 0FE58h
loc_081D5 equ 01D5h
loc_081E9 equ 01E9h
loc_081F2 equ 01F2h
loc_081FD equ 01FDh
loc_08209 equ 0209h
loc_0835B equ 035Bh
loc_09F41 equ 01F41h
loc_09F81 equ 01F81h
loc_09F82 equ 01F82h
loc_09F88 equ 01F88h
loc_0BC4B equ 03C4Bh
ClearByteCS066B_00672 equ 08672h
InstallTimerVector08_00682 equ 08682h
WaitByteCS066B_00679 equ 08679h
loc_00162 equ 08162h
loc_0073C equ 0873Ch
loc_00747 equ 08747h
loc_00871 equ 08871h
loc_00889 equ 08889h
loc_00B3E equ 08B3Eh
loc_00CB8 equ 08CB8h
loc_00D42 equ 08D42h
loc_00E9C equ 08E9Ch
loc_00F0B equ 08F0Bh
BuildByteToNibbleMaskTable_00FE4 equ 08FE4h
loc_04C76 equ 0CC76h
loc_04DBF equ 0CDBFh
loc_04E9F equ 0CE9Fh
loc_04FC3 equ 0CFC3h
loc_04FF9 equ 0CFF9h
loc_050BA equ 0D0BAh
loc_050C9 equ 0D0C9h
loc_0511F equ 0D11Fh
loc_05145 equ 0D145h
loc_05160 equ 0D160h
loc_05283 equ 0D283h
loc_052CF equ 0D2CFh
loc_054C0 equ 0D4C0h
loc_05559 equ 0D559h
loc_057E6 equ 0D7E6h
loc_05800 equ 0D800h
loc_05A00 equ 0DA00h
loc_05A12 equ 0DA12h
loc_05A48 equ 0DA48h
loc_05A6C equ 0DA6Ch
loc_05BCA equ 0DBCAh
loc_05BDC equ 0DBDCh
loc_05BEE equ 0DBEEh
loc_05C22 equ 0DC22h
loc_05C35 equ 0DC35h
loc_05C9A equ 0DC9Ah
loc_05F43 equ 0DF43h
loc_060A2 equ 0E0A2h
loc_060AC equ 0E0ACh
loc_0613E equ 0E13Eh
loc_0615A equ 0E15Ah
loc_06176 equ 0E176h
loc_061DC equ 0E1DCh
loc_077C5 equ 0F7C5h
loc_077DF equ 0F7DFh
loc_0837A equ 037Ah
loc_08382 equ 0382h
loc_08398 equ 0398h
loc_083CA equ 03CAh
loc_083D0 equ 03D0h
loc_0852B equ 052Bh
loc_08546 equ 0546h
loc_0854E equ 054Eh
loc_0859B equ 059Bh
loc_0859E equ 059Eh
loc_085B3 equ 05B3h
loc_085B5 equ 05B5h
loc_085D5 equ 05D5h
loc_085ED equ 05EDh
loc_085EF equ 05EFh
loc_08602 equ 0602h
loc_08605 equ 0605h
loc_0861B equ 061Bh
loc_09600 equ 01600h
loc_09620 equ 01620h
loc_0964C equ 0164Ch
loc_09657 equ 01657h
loc_09662 equ 01662h
loc_09664 equ 01664h
loc_0966A equ 0166Ah
loc_0966E equ 0166Eh
loc_096C5 equ 016C5h
loc_096E0 equ 016E0h
loc_09734 equ 01734h
loc_09744 equ 01744h
loc_09755 equ 01755h
loc_09761 equ 01761h
loc_09773 equ 01773h
loc_0977D equ 0177Dh
loc_097B2 equ 017B2h
loc_097C5 equ 017C5h
loc_097D8 equ 017D8h
loc_097E2 equ 017E2h
loc_097EC equ 017ECh
loc_09806 equ 01806h
loc_09810 equ 01810h
loc_09817 equ 01817h
loc_0981F equ 0181Fh
loc_09844 equ 01844h
loc_09852 equ 01852h
loc_09857 equ 01857h
loc_09862 equ 01862h
loc_0986E equ 0186Eh
loc_0989E equ 0189Eh
loc_098B6 equ 018B6h
loc_098C2 equ 018C2h
loc_098D1 equ 018D1h
loc_098D8 equ 018D8h
loc_098DF equ 018DFh
loc_098EB equ 018EBh
loc_098F7 equ 018F7h
loc_09902 equ 01902h
loc_09908 equ 01908h
loc_0991A equ 0191Ah
loc_09921 equ 01921h
loc_09928 equ 01928h
loc_09934 equ 01934h
loc_09937 equ 01937h
loc_09943 equ 01943h
loc_09995 equ 01995h
loc_099AB equ 019ABh
loc_099B7 equ 019B7h
InitPositionHistory_099BF equ 019BFh
loc_099CD equ 019CDh
loc_099F6 equ 019F6h
loc_09AFF equ 01AFFh
loc_09B07 equ 01B07h
loc_09B11 equ 01B11h
loc_09B27 equ 01B27h
loc_09B2E equ 01B2Eh
loc_09B47 equ 01B47h
loc_09B55 equ 01B55h
loc_09B79 equ 01B79h
loc_09B83 equ 01B83h
loc_09B8D equ 01B8Dh
loc_09B97 equ 01B97h
loc_09BA9 equ 01BA9h
loc_09BC0 equ 01BC0h
loc_09BCA equ 01BCAh
loc_09BDF equ 01BDFh
loc_09BE2 equ 01BE2h
loc_09BF7 equ 01BF7h
loc_09BFA equ 01BFAh
loc_09BFB equ 01BFBh
loc_09BFE equ 01BFEh
AdjustRecordXFromCounts_09C01 equ 01C01h
loc_09C1E equ 01C1Eh
loc_09C35 equ 01C35h
loc_09C41 equ 01C41h
loc_09C4B equ 01C4Bh
loc_09C55 equ 01C55h
loc_09C5F equ 01C5Fh
loc_09CB6 equ 01CB6h
loc_09CBC equ 01CBCh
loc_09CCE equ 01CCEh
loc_09CD1 equ 01CD1h
StorePositionHistory_09CD9 equ 01CD9h
AdvancePositionHistoryIfRequested_09CF1 equ 01CF1h
loc_09D00 equ 01D00h
loc_09D13 equ 01D13h
loc_09D26 equ 01D26h
loc_09D39 equ 01D39h
loc_09D4C equ 01D4Ch
loc_09D4D equ 01D4Dh
loc_09D54 equ 01D54h
loc_09D5B equ 01D5Bh
loc_09DC1 equ 01DC1h
loc_09DC9 equ 01DC9h
loc_09DE9 equ 01DE9h
loc_09E19 equ 01E19h
loc_09E21 equ 01E21h
loc_09E29 equ 01E29h
loc_09E31 equ 01E31h
loc_09E43 equ 01E43h
loc_09E57 equ 01E57h
loc_09E5D equ 01E5Dh
loc_09E63 equ 01E63h
loc_09E71 equ 01E71h
loc_09E79 equ 01E79h
loc_09E85 equ 01E85h
loc_09E98 equ 01E98h
loc_09EC2 equ 01EC2h
loc_09ED6 equ 01ED6h
loc_09ED7 equ 01ED7h
loc_09EEC equ 01EECh
loc_09EF5 equ 01EF5h
loc_09F0E equ 01F0Eh
loc_09F11 equ 01F11h
PlaceFourRecordsFromOffsetTables_09FAF equ 01FAFh
PlaceRecordFromOffsetPair_09FEA equ 01FEAh
loc_09FF0 equ 01FF0h
ApplyPositionHistoryToRecords_0A031 equ 02031h
loc_0A067 equ 02067h
loc_0A212 equ 02212h
DecRecordYByMode_0A5D1 equ 025D1h
IncRecordYTwice_0A5EA equ 025EAh
DecRecordXTwice_0A5F9 equ 025F9h
IncRecordXTwice_0A607 equ 02607h
loc_0A616 equ 02616h
loc_0A66F equ 0266Fh
loc_0A846 equ 02846h
loc_0A90C equ 0290Ch
loc_0A940 equ 02940h
loc_0AC19 equ 02C19h
loc_0B5A9 equ 035A9h
loc_0C3A6 equ 043A6h
loc_0C4DB equ 044DBh
loc_0C57C equ 0457Ch
loc_0C5B1 equ 045B1h
loc_0C5D6 equ 045D6h
loc_0C83C equ 0483Ch
loc_0C8AD equ 048ADh
loc_0CA13 equ 04A13h
loc_0CA98 equ 04A98h
loc_0CB1C equ 04B1Ch
loc_0CBE8 equ 04BE8h
loc_0CF22 equ 04F22h
loc_0D305 equ 05305h
loc_0D390 equ 05390h
; @08000 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,06Fh,00h,0C7h,047h,08h,036h,01h
; @08010 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,06h,03h,00h,083h,06Fh,04h,010h,083h,07Fh,04h,060h,073h,01h,0C3h
; @08020 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,06h,05h,00h,083h,047h,04h,020h,0C3h,0E8h,071h,01h,075h,01h,0C3h
; @08030 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,06h,00h,00h,0C7h,047h,018h,02Dh,00h,0C3h,0E8h,060h,01h,075h,01h
; @08040 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,047h,00h,0C3h,0E8h,07Ah,01h,075h
; @08050 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,0C7h,047h,06h,07h,00h,0C7h,047h,018h,059h,00h,0C7h,047h,08h,0E3h
; @08060 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,083h,07Fh,04h,060h,076h,01h,0C3h,0C7h,047h,06h,01h,00h,0C3h,0E8h,058h
; @08070 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,075h,01h,0C3h,0C7h,047h,06h,06h,00h,0C7h,047h,018h,05Fh,00h,083h,07Fh
; @08080 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,060h,076h,01h,0C3h,0C7h,047h,06h,02h,00h,0C3h,0E8h,03Bh,01h,075h,01h
; @08090 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,06h,00h,00h,0C7h,047h,018h,05Bh,00h,0C7h,047h,08h,074h,00h
; @080A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0E8h,0FAh,00h,075h,01h,0C3h,0C7h,047h,06h,04h,00h,0C7h,047h,018h,05Dh
; @080B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,08h,077h,00h,0C3h,0E8h,0Fh,01h,075h,01h,0C3h,0C7h,047h,06h
; @080C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,00h,0C7h,047h,018h,087h,00h,0C7h,047h,08h,0E0h,00h,083h,07Fh,04h,060h
; @080D0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 076h,01h,0C3h,0C7h,047h,06h,02h,00h,0C7h,047h,08h,0DDh,00h,0C3h,0E8h,0E8h
; @080E0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,075h,01h,0C3h,0C7h,047h,018h,055h,00h,0C7h,047h,08h,077h,00h,0C3h,0E8h
; @080F0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D7h,00h,075h,01h,0C3h,0C7h,047h,018h,034h,00h,0C3h,0E8h,0A0h,00h,075h,01h
; @08100 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,018h,037h,00h,0C3h,0E8h,094h,00h,075h,01h,0C3h,0C7h,047h,018h
; @08110 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,00h,0C3h,0E8h,0B3h,00h,075h,01h,0C3h,0C7h,047h,018h,04Fh,00h,0C3h,0E8h
; @08120 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ch,00h,075h,01h,0C3h,0C7h,047h,018h,019h,00h,0C3h,0E8h,070h,00h,075h,01h
; @08130 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C7h,047h,018h,035h,00h,0C3h,0E8h,08Fh,00h,075h,01h,0C3h,0C7h,047h,018h
; @08140 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 069h,00h,0C3h,083h,03Eh,056h,023h,05h,075h,010h,0E8h,048h,0CCh,083h,0E3h,0Fh
; @08150 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,0FBh,0Fh,075h,05h,0E8h,046h,00h,0EBh,03h,0E8h,06Ch,00h,075h,01h,0C3h
; @08160 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,018h,068h,00h,0C3h,0E8h,035h,00h,075h,01h,0C3h,0C7h,047h,018h,089h
; @08170 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C3h,0E8h,054h,00h,075h,01h,0C3h,0C7h,047h,018h,058h,00h,0C7h,047h,08h
; @08180 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 099h,00h,0C7h,047h,06h,02h,00h,0C3h,0E8h,03Eh,00h,075h,01h,0C3h,0C7h,047h
; @08190 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 018h,057h,00h,0C7h,047h,08h,09Bh,00h,0C7h,047h,06h,06h,00h,0C3h,0E8h,028h
; @081A0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,083h,0FBh,0FFh,075h,01h,0C3h,0B8h,0FFh,0FFh,083h,03Eh,09Ah,020h,0FFh,074h
; @081B0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 011h,053h,08Bh,01Eh,09Ah,020h,0FEh,07h,0A0h,070h,020h,088h,047h,01h,05Bh,0A1h
; @081C0 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 098h,020h,089h,047h,028h,0Dh,01h,00h,0C3h
; @081C9 0000:81C9 original=e88cfc runtime CFG evidence
    CALL_NEAR loc_07E58
; @081CC 0000:81CC original=e81a00 runtime CFG evidence
    CALL_NEAR loc_081E9
; @081CF 0000:81CF original=83fbff runtime CFG evidence
    cmp bx, -1
; @081D2 0000:81D2 original=7501 runtime CFG evidence
    JNE_SHORT loc_081D5
; @081D4 0000:81D4 original=c3 runtime CFG evidence
    ret
; @081D5 0000:81D5 original=a10aa4 runtime CFG evidence
    mov ax, word ptr ds:[0A40Ah]
; @081D8 0000:81D8 original=894704 runtime CFG evidence
    mov word ptr ds:[bx + 4], ax
; @081DB 0000:81DB original=c747021000 runtime CFG evidence
    mov word ptr ds:[bx + 2], 010h
; @081E0 0000:81E0 original=c7470a0000 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 0
; @081E5 0000:81E5 original=0d0100 runtime CFG evidence
    or ax, 1
; @081E8 0000:81E8 original=c3 runtime CFG evidence
    ret
; @081E9 0000:81E9 original=e838f3 runtime CFG evidence
    CALL_NEAR FindFreeRecordPoolA_07524
; @081EC 0000:81EC original=83fbff runtime CFG evidence
    cmp bx, -1
; @081EF 0000:81EF original=7501 runtime CFG evidence
    JNE_SHORT loc_081F2
; @081F1 0000:81F1 original=c3 runtime CFG evidence
    ret
; @081F2 0000:81F2 original=eb15 runtime CFG evidence
    JMP_SHORT loc_08209
; @081F4 0000:81F4 original=e82df3 runtime CFG evidence
    CALL_NEAR FindFreeRecordPoolA_07524
; @081F7 0000:81F7 original=83fbff runtime CFG evidence
    cmp bx, -1
; @081FA 0000:81FA original=7501 runtime CFG evidence
    JNE_SHORT loc_081FD
; @081FC 0000:81FC original=c3 runtime CFG evidence
    ret
; @081FD 0000:81FD original=803ec09800 runtime CFG evidence
    cmp byte ptr ds:[098C0h], 0
; @08202 0000:8202 original=7405 runtime CFG evidence
    JE_SHORT loc_08209
; @08204 0000:8204 original=c606ffbe0b runtime CFG evidence
    mov byte ptr ds:[0BEFFh], 0Bh
; @08209 0000:8209 original=c74728ffff runtime CFG evidence
    mov word ptr ds:[bx + 028h], 0FFFFh
; @0820E 0000:820E original=c7070100 runtime CFG evidence
    mov word ptr ds:[bx], 1
; @08212 0000:8212 original=c7470a0100 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 1
; @08217 0000:8217 original=8b4602 runtime CFG evidence
    mov ax, word ptr ss:[bp + 2]
; @0821A 0000:821A original=894702 runtime CFG evidence
    mov word ptr ds:[bx + 2], ax
; @0821D 0000:821D original=894734 runtime CFG evidence
    mov word ptr ds:[bx + 034h], ax
; @08220 0000:8220 original=8b4604 runtime CFG evidence
    mov ax, word ptr ss:[bp + 4]
; @08223 0000:8223 original=894704 runtime CFG evidence
    mov word ptr ds:[bx + 4], ax
; @08226 0000:8226 original=894732 runtime CFG evidence
    mov word ptr ds:[bx + 032h], ax
; @08229 0000:8229 original=c747060400 runtime CFG evidence
    mov word ptr ds:[bx + 6], 4
; @0822E 0000:822E original=c747140100 runtime CFG evidence
    mov word ptr ds:[bx + 014h], 1
; @08233 0000:8233 original=c747160400 runtime CFG evidence
    mov word ptr ds:[bx + 016h], 4
; @08238 0000:8238 original=c747181400 runtime CFG evidence
    mov word ptr ds:[bx + 018h], 014h
; @0823D 0000:823D original=c747200400 runtime CFG evidence
    mov word ptr ds:[bx + 020h], 4
; @08242 0000:8242 original=c747240000 runtime CFG evidence
    mov word ptr ds:[bx + 024h], 0
; @08247 0000:8247 original=c3 runtime CFG evidence
    ret
; @08248 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,02Ch,023h,01Fh,074h,03h,0E9h,0F3h,039h,0E8h,0E2h,03Fh,083h,0FBh,0FFh
; @08258 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,0E8h,039h,0C7h,047h,08h,01Eh,00h,0E9h,0E0h,039h,083h,03Eh,02Ch
; @08268 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,01Fh,074h,03h,0E9h,0D6h,039h,0E8h,0C5h,03Fh,083h,0FBh,0FFh,075h,03h,0E9h
; @08278 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CBh,039h,0C7h,047h,08h,01Ah,00h,0E9h,0C3h,039h,0B8h,088h,00h,083h,03Eh,056h
; @08288 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,04h,075h,012h,0B8h,06Ch,01h,0EBh,0Dh,0B8h,08Bh,00h,083h,03Eh,056h,023h
; @08298 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,075h,03h,0B8h,06Fh,01h,089h,046h,08h,08Bh,01Eh,030h,023h,0D1h,0EBh,0D1h
; @082A8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,0D1h,0E3h,08Bh,09Fh,0EAh,095h,01h,05Eh,08h
; @082B8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,02Ch,023h,01Fh,074h,03h,0E9h,083h,039h,0D1h,0E3h,02Eh,0FFh,0A7h,0CAh
; @082C8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 082h,090h,0DEh,082h,045h,0BCh,0D0h,082h,083h,046h,02h,04h,0E8h,060h,03Fh,083h
; @082D8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06Eh,02h,04h,0E9h,067h,039h,083h,06Eh,02h,04h,0E8h,052h,03Fh,083h,046h,02h
; @082E8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0E9h,059h,039h,083h,03Eh,026h,023h,03h,074h,03h,0E9h,04Fh,039h,08Bh,046h
; @082F8 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,089h,046h,04h,0FFh,04Eh,08h,0E9h,043h,039h,081h,07Eh,08h,098h,00h,074h
; @08308 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E3h,081h,07Eh,08h,092h,00h,074h,0DCh,0E8h,0C5h,02Ch,075h,0Ah,081h,07Eh,04h
; @08318 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,00h,073h,03h,0E9h,026h,039h,0FFh,046h,08h,080h,03Eh,0C0h,098h,00h,074h
; @08328 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,0C6h,06h,0FFh,0BEh,01Eh,0E9h,014h,039h
; @08331 0000:8331 original=8b36f295 runtime CFG evidence
    mov si, word ptr ds:[095F2h]
; @08335 0000:8335 original=83c610 runtime CFG evidence
    add si, 010h
; @08338 0000:8338 original=397602 runtime CFG evidence
    cmp word ptr ss:[bp + 2], si
; @0833B 0000:833B original=7f1e runtime CFG evidence
    JG_SHORT loc_0835B
; @0833D 0000:833D original=83ee20 runtime CFG evidence
    sub si, 020h
; @08340 0000:8340 original=397602 runtime CFG evidence
    cmp word ptr ss:[bp + 2], si
; @08343 0000:8343 original=7c16 runtime CFG evidence
    JL_SHORT loc_0835B
; @08345 0000:8345 original=8b36f495 runtime CFG evidence
    mov si, word ptr ds:[095F4h]
; @08349 0000:8349 original=83c610 runtime CFG evidence
    add si, 010h
; @0834C 0000:834C original=397604 runtime CFG evidence
    cmp word ptr ss:[bp + 4], si
; @0834F 0000:834F original=7f0a runtime CFG evidence
    JG_SHORT loc_0835B
; @08351 0000:8351 original=83ee20 runtime CFG evidence
    sub si, 020h
; @08354 0000:8354 original=397604 runtime CFG evidence
    cmp word ptr ss:[bp + 4], si
; @08357 0000:8357 original=7c02 runtime CFG evidence
    JL_SHORT loc_0835B
; @08359 0000:8359 original=f9 runtime CFG evidence
    stc
; @0835A 0000:835A original=c3 runtime CFG evidence
    ret
; @0835B 0000:835B original=f8 runtime CFG evidence
    clc
; @0835C 0000:835C original=c3 runtime CFG evidence
    ret
; @0835D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A1h,038h,023h,0D1h,0E8h,0BBh,027h,00h,083h,03Eh,056h,023h,05h,075h,03h,0BBh
; @0836D UNKNOWN bootstrap bytes: not reconstructed code/data
    db 024h,00h,03h,0C3h,089h,046h,08h,0FFh,046h,02h,0E9h,0CBh,038h
; sub_0000_837A
; @0837A 0000:837A original=833efa95ff
    cmp word ptr ds:[095FAh], -1
; @0837F 0000:837F original=7501
    JNE_SHORT loc_08382
; @08381 0000:8381 original=c3
    ret
; @08382 0000:8382 original=8b2efa95
    mov bp, word ptr ds:[095FAh]
; @08386 0000:8386 original=d1e5
    shl bp, 1
; @08388 0000:8388 original=81c5fc95
    add bp, 095FCh
; @0838C 0000:838C original=8b6e00
    mov bp, word ptr ss:[bp]
; @0838F 0000:838F original=8b7606
    mov si, word ptr ss:[bp + 6]
; @08392 0000:8392 original=c706f8950000
    mov word ptr ds:[095F8h], 0
; @08398 0000:8398 original=8b5e08
    mov bx, word ptr ss:[bp + 8]
; @0839B 0000:839B original=d1e3
    shl bx, 1
; @0839D 0000:839D original=8bc3
    mov ax, bx
; @0839F 0000:839F original=d1e3
    shl bx, 1
; @083A1 0000:83A1 original=03d8
    add bx, ax
; @083A3 0000:83A3 original=8b4002
    mov ax, word ptr ds:[bx + si + 2]
; @083A6 0000:83A6 original=3dffff
    cmp ax, 0FFFFh
; @083A9 0000:83A9 original=7425
    JE_SHORT loc_083D0
; @083AB 0000:83AB original=55
    push bp
; @083AC 0000:83AC original=ffd0
    call ax
; @083AE 0000:83AE original=5d
    pop bp
; @083AF 0000:83AF original=7519
    JNE_SHORT loc_083CA
; @083B1 0000:83B1 original=ff4608
    inc word ptr ss:[bp + 8]
; @083B4 0000:83B4 original=ff06f895
    inc word ptr ds:[095F8h]
; @083B8 0000:83B8 original=833ef8950a
    cmp word ptr ds:[095F8h], 0Ah
; @083BD 0000:83BD original=72d9
    JB_SHORT loc_08398
; @083BF 0000:83BF original=c746080000
    mov word ptr ss:[bp + 8], 0
; @083C4 0000:83C4 original=c746002400
    mov word ptr ss:[bp], 024h
; @083C9 0000:83C9 original=c3
    ret
; @083CA 0000:83CA original=8b00
    mov ax, word ptr ds:[bx + si]
; @083CC 0000:83CC original=894600
    mov word ptr ss:[bp], ax
; @083CF 0000:83CF original=c3
    ret
; @083D0 0000:83D0 original=c746080000
    mov word ptr ss:[bp + 8], 0
; @083D5 0000:83D5 original=ebc1
    JMP_SHORT loc_08398
; @083D7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 033h,0C0h,0C3h,033h,0C0h,040h,0C3h,083h,03Eh,058h,0A9h,00h,0C3h,083h,03Eh,058h
; @083E7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,01h,0C3h,083h,03Eh,058h,0A9h,02h,0C3h,083h,03Eh,058h,0A9h,03h,0C3h,083h
; @083F7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,058h,0A9h,04h,0C3h,083h,03Eh,058h,0A9h,05h,0C3h,0C7h,06h,058h,0A9h,00h
; @08407 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0EBh,026h,0C7h,06h,058h,0A9h,01h,00h,0EBh,01Eh,0C7h,06h,058h,0A9h,02h
; @08417 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0EBh,016h,0C7h,06h,058h,0A9h,03h,00h,0EBh,0Eh,0C7h,06h,058h,0A9h,04h
; @08427 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0EBh,06h,0C7h,06h,058h,0A9h,05h,00h,0C7h,06h,0FAh,095h,0FFh,0FFh,0C3h
; @08437 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,05Eh,0A9h,01h,0C3h,0C7h,06h,05Eh,0A9h,01h,00h,0EBh,0EBh,083h,03Eh
; @08447 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,0A9h,00h,074h,08Eh,0EBh,089h,0C7h,06h,060h,0A9h,04h,00h,0EBh,0DAh,083h
; @08457 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,06Eh,0A9h,0FFh,075h,03h,0E9h,07Ah,0FFh,0E9h,074h,0FFh,0E8h,02Bh,019h,0EBh
; @08467 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C8h,083h,03Eh,066h,0A9h,0FFh,075h,03h,0E9h,068h,0FFh,083h,03Eh,068h,0A9h,0FFh
; @08477 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E9h,05Eh,0FFh,083h,03Eh,084h,023h,00h,075h,03h,0E9h,051h,0FFh,083h
; @08487 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,06Ah,0A9h,0FFh,075h,03h,0E9h,04Ah,0FFh,083h,03Eh,06Ch,0A9h,0FFh,075h,03h
; @08497 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,040h,0FFh,0E9h,03Ah,0FFh,0E8h,0BFh,01Ah,0EBh,08Eh,083h,03Eh,084h,023h,02h
; @084A7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,02Bh,0FFh,083h,03Eh,062h,0A9h,0FFh,075h,03h,0E9h,024h,0FFh,083h
; @084B7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,064h,0A9h,0FFh,075h,03h,0E9h,01Ah,0FFh,0E9h,014h,0FFh,0E8h,054h,01Ah,0E9h
; @084C7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 067h,0FFh,083h,03Eh,084h,023h,00h,075h,03h,0E9h,07h,0FFh,0E9h,01h,0FFh,0C6h
; @084D7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,0FEh,0BEh,00h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,06h
; @084E7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,084h,023h,01h,00h,0E9h,040h,0FFh,083h,03Eh,084h,023h,02h,074h,03h
; @084F7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0E0h,0FEh,0E9h,0DAh,0FEh,0C6h,06h,0FEh,0BEh,00h,080h,03Eh,0C0h,098h,00h
; @08507 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,05h,0C6h,06h,0FFh,0BEh,06h,0C7h,06h,084h,023h,02h,00h,0E9h,019h,0FFh
; sub_0000_8517
; @08517 0000:8517 original=c706fa95ffff
    mov word ptr ds:[095FAh], 0FFFFh
; @0851D 0000:851D original=bd8296
    mov bp, 09682h
; @08520 0000:8520 original=b487
    mov ah, 087h
; @08522 0000:8522 original=e80600
    CALL_NEAR loc_0852B
; @08525 0000:8525 original=e80300
    CALL_NEAR loc_0852B
; @08528 0000:8528 original=e80000
    CALL_NEAR loc_0852B
; sub_0000_852B
; @0852B 0000:852B original=b01c
    mov al, 01Ch
; @0852D 0000:852D original=50
    push ax
; @0852E 0000:852E original=e8cfd4
    CALL_NEAR loc_05A00
; @08531 0000:8531 original=c746002400
    mov word ptr ss:[bp], 024h
; @08536 0000:8536 original=897e02
    mov word ptr ss:[bp + 2], di
; @08539 0000:8539 original=c746080000
    mov word ptr ss:[bp + 8], 0
; @0853E 0000:853E original=83c50a
    add bp, 0Ah
; @08541 0000:8541 original=58
    pop ax
; @08542 0000:8542 original=80c410
    add ah, 010h
; @08545 0000:8545 original=c3
    ret
; sub_0000_8546
; @08546 0000:8546 original=833efa95ff
    cmp word ptr ds:[095FAh], -1
; @0854B 0000:854B original=7501
    JNE_SHORT loc_0854E
; @0854D 0000:854D original=c3
    ret
; @0854E 0000:854E original=53
    push bx
; @0854F 0000:854F original=55
    push bp
; @08550 0000:8550 original=8b2efa95
    mov bp, word ptr ds:[095FAh]
; @08554 0000:8554 original=d1e5
    shl bp, 1
; @08556 0000:8556 original=81c5fc95
    add bp, 095FCh
; @0855A 0000:855A original=8b6e00
    mov bp, word ptr ss:[bp]
; @0855D 0000:855D original=8b7606
    mov si, word ptr ss:[bp + 6]
; @08560 0000:8560 original=8b5e08
    mov bx, word ptr ss:[bp + 8]
; @08563 0000:8563 original=d1e3
    shl bx, 1
; @08565 0000:8565 original=8bc3
    mov ax, bx
; @08567 0000:8567 original=d1e3
    shl bx, 1
; @08569 0000:8569 original=03d8
    add bx, ax
; @0856B 0000:856B original=ff36fa95
    push word ptr ds:[095FAh]
; @0856F 0000:856F original=ff5004
    call word ptr ds:[bx + si + 4]
; @08572 0000:8572 original=a1fa95
    mov ax, word ptr ds:[095FAh]
; @08575 0000:8575 original=a3f695
    mov word ptr ds:[095F6h], ax
; @08578 0000:8578 original=8f06fa95
    pop word ptr ds:[095FAh]
; @0857C 0000:857C original=e8fbfd
    CALL_NEAR loc_0837A
; @0857F 0000:857F original=a1f695
    mov ax, word ptr ds:[095F6h]
; @08582 0000:8582 original=a3fa95
    mov word ptr ds:[095FAh], ax
; @08585 0000:8585 original=e81600
    CALL_NEAR loc_0859E
; @08588 0000:8588 original=833efa95ff
    cmp word ptr ds:[095FAh], -1
; @0858D 0000:858D original=750c
    JNE_SHORT loc_0859B
; @0858F 0000:858F original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @08594 0000:8594 original=7405
    JE_SHORT loc_0859B
; @08596 0000:8596 original=c606ffbe09
    mov byte ptr ds:[0BEFFh], 9
; @0859B 0000:859B original=5d
    pop bp
; @0859C 0000:859C original=5b
    pop bx
; @0859D 0000:859D original=c3
    ret
; sub_0000_859E
; @0859E 0000:859E original=55
    push bp
; @0859F 0000:859F original=e81300
    CALL_NEAR loc_085B5
; @085A2 0000:85A2 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @085A8 0000:85A8 original=7509
    JNE_SHORT loc_085B3
; @085AA 0000:85AA original=e872cb
    CALL_NEAR loc_0511F
; @085AD 0000:85AD original=e80500
    CALL_NEAR loc_085B5
; @085B0 0000:85B0 original=e86ccb
    CALL_NEAR loc_0511F
; @085B3 0000:85B3 original=5d
    pop bp
; @085B4 0000:85B4 original=c3
    ret
; sub_0000_85B5
; @085B5 0000:85B5 original=bd8296
    mov bp, 09682h
; @085B8 0000:85B8 original=33ff
    xor di, di
; @085BA 0000:85BA original=e81800
    CALL_NEAR loc_085D5
; @085BD 0000:85BD original=bd8c96
    mov bp, 0968Ch
; @085C0 0000:85C0 original=bf0100
    mov di, 1
; @085C3 0000:85C3 original=e80f00
    CALL_NEAR loc_085D5
; @085C6 0000:85C6 original=bd9696
    mov bp, 09696h
; @085C9 0000:85C9 original=bf0200
    mov di, 2
; @085CC 0000:85CC original=e80600
    CALL_NEAR loc_085D5
; @085CF 0000:85CF original=bda096
    mov bp, 096A0h
; @085D2 0000:85D2 original=bf0300
    mov di, 3
; sub_0000_85D5
; @085D5 0000:85D5 original=833efa95ff
    cmp word ptr ds:[095FAh], -1
; @085DA 0000:85DA original=7411
    JE_SHORT loc_085ED
; @085DC 0000:85DC original=8b36fa95
    mov si, word ptr ds:[095FAh]
; @085E0 0000:85E0 original=d1e6
    shl si, 1
; @085E2 0000:85E2 original=81c6fc95
    add si, 095FCh
; @085E6 0000:85E6 original=3b2c
    cmp bp, word ptr ds:[si]
; @085E8 0000:85E8 original=b80100
    mov ax, 1
; @085EB 0000:85EB original=7402
    JE_SHORT loc_085EF
; @085ED 0000:85ED original=33c0
    xor ax, ax
; @085EF 0000:85EF original=833eacbd01
    cmp word ptr ds:[0BDACh], 1
; @085F4 0000:85F4 original=750c
    JNE_SHORT loc_08602
; @085F6 0000:85F6 original=3b3efa95
    cmp di, word ptr ds:[095FAh]
; @085FA 0000:85FA original=7506
    JNE_SHORT loc_08602
; @085FC 0000:85FC original=ff3616be
    push word ptr ds:[0BE16h]
; @08600 0000:8600 original=eb03
    JMP_SHORT loc_08605
; @08602 0000:8602 original=ff7600
    push word ptr ss:[bp]
; @08605 0000:8605 original=50
    push ax
; @08606 0000:8606 original=8b7604
    mov si, word ptr ss:[bp + 4]
; @08609 0000:8609 original=03f0
    add si, ax
; @0860B 0000:860B original=d1e6
    shl si, 1
; @0860D 0000:860D original=81c6e40b
    add si, 0BE4h
; @08611 0000:8611 original=2e8b34
    mov si, word ptr cs:[si]
; @08614 0000:8614 original=8b7e02
    mov di, word ptr ss:[bp + 2]
; @08617 0000:8617 original=57
    push di
; @08618 0000:8618 original=b90500
    mov cx, 5
; @0861B 0000:861B original=e820db
    CALL_NEAR loc_0613E
; @0861E 0000:861E original=e2fb
    LOOP_SHORT loc_0861B
; @08620 0000:8620 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @08625 0000:8625 original=e844d4
    CALL_NEAR loc_05A6C
; @08628 0000:8628 original=5f
    pop di
; @08629 0000:8629 original=e82edb
    CALL_NEAR loc_0615A
; @0862C 0000:862C original=5e
    pop si
; @0862D 0000:862D original=83c617
    add si, 017h
; @08630 0000:8630 original=d1e6
    shl si, 1
; @08632 0000:8632 original=81c6e40b
    add si, 0BE4h
; @08636 0000:8636 original=2e8b34
    mov si, word ptr cs:[si]
; @08639 0000:8639 original=57
    push di
; @0863A 0000:863A original=e82fd4
    CALL_NEAR loc_05A6C
; @0863D 0000:863D original=5f
    pop di
; @0863E 0000:863E original=e8fdda
    CALL_NEAR loc_0613E
; @08641 0000:8641 original=5e
    pop si
; @08642 0000:8642 original=d1e6
    shl si, 1
; @08644 0000:8644 original=81c6e40b
    add si, 0BE4h
; @08648 0000:8648 original=2e8b34
    mov si, word ptr cs:[si]
; @0864B 0000:864B original=e81ed4
    CALL_NEAR loc_05A6C
; @0864E 0000:864E original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @08653 0000:8653 original=c3
    ret
; @08654 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,032h,023h,00h,075h,0Eh,0FFh,046h,06h,083h,07Eh,06h,018h,072h,05h
; @08664 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,06h,00h,00h,0BBh,0AAh,096h,08Bh,046h,06h,0D7h,03h,0C1h,089h,046h
; @08674 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,0C3h,0B9h,01Ch,00h,083h,03Eh,056h,023h,01h,074h,0Ah,083h,03Eh,056h,023h
; @08684 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,074h,03h,0B9h,01Ch,00h,0E8h,0C7h,0FFh,083h,03Eh,07Eh,0A4h,00h,074h,03h
; @08694 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0AEh,035h,083h,07Eh,06h,07h,074h,03h,0E9h,0A5h,035h,0FFh,046h,06h,0E8h
; @086A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,0FBh,083h,0FBh,0FFh,075h,03h,0E9h,097h,035h,0C7h,047h,020h,04h,00h,083h
; @086B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 047h,02h,08h,083h,047h,04h,08h,083h,03Eh,056h,023h,01h,074h,018h,083h,03Eh
; @086C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 056h,023h,04h,074h,011h,083h,03Eh,056h,023h,02h,074h,017h,083h,03Eh,056h,023h
; @086D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,074h,020h,0E9h,06Bh,035h,0C7h,047h,018h,029h,00h,0C7h,047h,08h,0A1h,00h
; @086E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,05Eh,035h,0C7h,047h,018h,02Bh,00h,0C7h,047h,08h,0A5h,00h,0E8h,0EEh,0EDh
; @086F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,04Eh,035h,0C7h,047h,018h,07Ah,00h,0C7h,047h,08h,020h,00h,0E8h,0DEh,0EDh
; @08704 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,03Eh,035h,0B8h,05Ch,01h,0EBh,03h,0B8h,020h,00h,03h,06h,026h,023h,0EBh
; @08714 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,0B8h,0A5h,00h,03h,06h,03Ch,023h,089h,046h,08h,0EBh,023h,081h,07Eh,08h
; @08724 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A4h,00h,074h,01Ch,083h,03Eh,028h,023h,07h,074h,03h,0E9h,013h,035h,0FFh,046h
; @08734 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,081h,07Eh,08h,0A4h,00h,074h,03h,0E9h,06h,035h,08Bh,0DDh,0E8h,09Eh,0EDh
; @08744 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,06h,012h,023h,02h,00h,0E8h,0F5h,0D6h,0C7h,06h,012h,023h,03h,00h,081h
; @08754 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,04h,0C0h,00h,07Fh,09h,083h,07Eh,04h,00h,07Ch,03h,0E9h,0E2h,034h,0E8h
; @08764 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 061h,038h,0E9h,0DCh,034h,08Bh,01Eh,02Eh,023h,0D1h,0EBh,0D1h,0EBh,0D1h,0EBh,08Bh
; @08774 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CBh,0D1h,0E3h,08Bh,09Fh,0C2h,096h,081h,0C3h,0BFh,00h,089h,05Eh,08h,083h,07Eh
; @08784 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,060h,077h,04h,083h,046h,08h,03h,083h,0F9h,03h,074h,03h,0E9h,0B1h,034h
; @08794 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0A0h,03Ah,083h,0FBh,0FFh,075h,03h,0E9h,0A6h,034h,0C7h,047h,08h,044h,00h
; @087A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,09Eh,034h,0A1h,036h,023h,05h,02Bh,01h,0EBh,06h,0A1h,03Ch,023h,05h,093h
; @087B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,089h,046h,08h,083h,07Eh,02h,060h,077h,015h,083h,03Eh,030h,023h,07Fh,074h
; @087C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,07Dh,034h,0C7h,046h,06h,04h,00h,0E8h,067h,03Ah,0E9h,072h,034h,083h
; @087D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,02h,04h,0E9h,06Bh,034h,0A1h,078h,0A2h,01h,046h,034h,0E8h,0B2h,0C5h,083h
; @087E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E3h,03h,081h,0C3h,0ADh,00h,089h,05Eh,08h,081h,07Eh,02h,080h,00h,07Dh,03h
; @087F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,04Eh,034h,075h,03h,0E8h,06h,00h,0E8h,02Ah,02Fh,0E9h,049h,034h,080h,03Eh
; @08804 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Bh,0A1h,080h,023h,05h,08h,00h
; @08814 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,0FEh,0FFh,089h,046h,032h,0C7h,046h,034h,030h,075h,0C3h,0C7h,046h,08h,043h
; @08824 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,06h,08h,023h,02h,00h,0E8h,0FBh,02Eh,09Ch,0A1h,078h,0A2h,01h,046h
; @08834 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 034h,09Dh,075h,03h,0E9h,0Ah,034h,083h,07Eh,032h,00h,074h,08h,0C7h,046h,032h
; @08844 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0E9h,0FCh,033h,0C7h,046h,032h,0C0h,00h,0E9h,0F4h,033h,083h,03Eh,056h
; @08854 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,05h,075h,018h,0A1h,080h,023h,02Bh,046h,04h,079h,02h,0F7h,0D8h,03Dh,0Ch
; @08864 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,072h,09h,083h,07Eh,08h,046h,075h,03h,0E9h,0D5h,033h,08Bh,01Eh,03Ch,023h
; @08874 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,0E3h,08Bh,09Fh,0D2h,096h,083h,0C3h,044h,089h,05Eh,08h,083h,03Eh,056h,023h
; @08884 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,075h,07h,083h,03Eh,026h,023h,03h,0EBh,05h,083h,03Eh,02Ah,023h,0Fh,074h
; @08894 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0E9h,0ADh,033h,0E8h,09Ch,039h,080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h
; @088A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0FFh,0BEh,0Eh,0E9h,09Bh,033h,0C7h,046h,08h,02Eh,00h,083h,046h,02h,03h,0E9h
; @088B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08Fh,033h,0C7h,046h,08h,024h,00h,081h,07Eh,02h,090h,00h,074h,03h,0E9h,080h
; @088C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 033h,0C7h,046h,018h,033h,00h,0C7h,046h,06h,07h,00h,0E8h,06h,027h,075h,0Dh
; @088D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,01h,027h,075h,08h,0E8h,0FCh,026h,075h,03h,0E9h,064h,033h,083h,076h,06h
; @088E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0E9h,05Dh,033h,08Bh,01Eh,056h,023h,0D1h,0E3h,08Bh,09Fh,0DAh,096h,089h,05Eh
; @088F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,083h,07Eh,04h,060h,073h,043h,0FFh,04Eh,08h,083h,03Eh,056h,023h,06h,074h
; @08904 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,083h,03Eh,056h,023h,00h,075h,09h,083h,07Eh,02h,050h,073h,03h,0E9h,030h
; @08914 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 033h,083h,03Eh,02Eh,023h,032h,073h,03h,0E9h,026h,033h,080h,03Eh,0C0h,098h,00h
; @08924 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,05h,0C6h,06h,0FFh,0BEh,013h,0C7h,046h,06h,02h,00h,083h,03Eh,024h,023h
; @08934 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,074h,045h,0C7h,046h,06h,03h,00h,0EBh,03Eh,083h,03Eh,056h,023h,06h,074h
; @08944 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,083h,03Eh,056h,023h,00h,075h,09h,083h,07Eh,02h,050h,073h,03h,0E9h,0F0h
; @08954 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 032h,083h,03Eh,02Eh,023h,032h,073h,03h,0E9h,0E6h,032h,080h,03Eh,0C0h,098h,00h
; @08964 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,05h,0C6h,06h,0FFh,0BEh,013h,0C7h,046h,06h,06h,00h,083h,03Eh,024h,023h
; @08974 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,074h,05h,0C7h,046h,06h,05h,00h,0E8h,0B8h,038h,0E9h,0C3h,032h,0A1h,03Ch
; @08984 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,05h,0B5h,00h,089h,046h,08h,0C7h,06h,0EAh,096h,01h,00h,083h,07Eh,04h
; @08994 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 060h,074h,018h,0C7h,06h,0EAh,096h,03h,00h,083h,07Eh,04h,050h,074h,0Ch,083h
; @089A4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Eh,04h,070h,074h,06h,0C7h,06h,0EAh,096h,05h,00h,0A1h,0EAh,096h,083h,07Eh
; @089B4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,04h,074h,019h,0F7h,0D8h,01h,046h,02h,083h,07Eh,02h,08h,076h,03h,0E9h
; @089C4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Fh,032h,0C7h,046h,06h,04h,00h,0E8h,069h,038h,0E9h,074h,032h,01h,046h,02h
; @089D4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,07Eh,02h,090h,00h,073h,03h,0E9h,067h,032h,0E8h,056h,038h,0C7h,046h,06h
; @089E4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,0E9h,05Ch,032h,0A1h,03Ch,023h,05h,010h,00h,089h,046h,08h,083h,03Eh
; @089F4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Eh,023h,03Fh,075h,03h,0E8h,0E5h,030h,0E9h,04h,031h,0B8h,03h,00h,083h,07Eh
; @08A04 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,00h,074h,0Dh,0B8h,05h,00h,081h,07Eh,04h,0C0h,00h,074h,03h,08Bh,046h
; @08A14 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,089h,046h,06h,0C7h,046h,08h,06Eh,00h,0E8h,043h,025h,0E9h,022h,032h,0C7h
; @08A24 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 046h,08h,06Eh,00h,081h,07Eh,02h,080h,00h,07Ch,023h,075h,0Ch,080h,03Eh,0C0h
; @08A34 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,0Bh,0C7h,046h,06h,02h,00h,0E8h,01Bh
; @08A44 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 025h,081h,07Eh,04h,0C0h,00h,077h,03h,0E9h,0F6h,031h,0E8h,075h,035h,0E9h,0F0h
; @08A54 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 031h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,081h,0C3h,0D2h,096h,08Bh,01Fh,081h,0C3h,0CCh
; @08A64 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,089h,05Eh,08h,081h,07Eh,02h,080h,00h,07Dh,03h,0E9h,0D3h,031h,0BBh,07Ch
; @08A74 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,0E8h,0A3h,0D3h,0E8h,0C7h,0D3h,0E9h,0C7h,031h,0E8h,014h,0C3h,083h,0E3h,03h
; @08A84 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0B9h,0A9h,00h,083h,03Eh,056h,023h,06h,074h,07h,083h,03Eh,056h,023h,00h,075h
; @08A94 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,0B9h,052h,01h,03h,0D9h,089h,05Eh,08h,083h,046h,02h,02h,0E9h,0A1h,031h
; @08AA4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,046h,08h,0C5h,00h,081h,07Eh,02h,0B0h,00h,074h,03h,0E9h,092h,031h,080h
; @08AB4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Dh,0FFh,046h,018h,0C7h,046h
; @08AC4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,07h,00h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,081h,0C3h,0D2h,096h,08Bh,01Fh,081h
; @08AD4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0C5h,00h,089h,05Eh,08h,0E9h,0F2h,0FDh,0C7h,046h,08h,0Eh,00h,081h,07Eh
; @08AE4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,0A0h,00h,07Dh,03h,0E9h,059h,031h,0C7h,046h,018h,03Fh,00h,08Bh,0DDh,0E8h
; @08AF4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0ECh,0E9h,0E9h,04Bh,0FCh,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,083h
; @08B04 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,024h,089h,05Eh,08h,083h,03Eh,056h,023h,04h,074h,03Ch,08Bh,01Eh,03Ch,023h
; @08B14 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h,0A1h,00h,089h,05Eh,08h,083h,03Eh,056h
; @08B24 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 023h,05h,074h,024h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h
; @08B34 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,01h,089h,05Eh,08h,0EBh,011h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h
; @08B44 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 096h,081h,0C3h,0CFh,00h,089h,05Eh,08h,0E8h,046h,0C2h,083h,0E3h,01h,0D1h,0E3h
; @08B54 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 081h,0C3h,0ECh,096h,08Bh,037h,0A1h,02Eh,023h,025h,01h,00h,0D1h,0E0h,048h,01h
; @08B64 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02h,081h,07Eh,02h,080h,00h,07Dh,03h,0E9h,0D6h,030h,083h,03Eh,02Ch,023h,01Fh
; @08B74 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 075h,03h,0E8h,0BEh,036h,083h,046h,02h,02h,0E9h,0C5h,030h,0A1h,02Ah,023h,0D1h
; @08B84 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,0D1h,0E8h,0D1h,0E8h,0BBh,03h,01h,083h,03Eh,056h,023h,04h,075h,03h,0BBh
; @08B94 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 078h,01h,03h,0C3h,089h,046h,08h,0E8h,0F7h,0C1h,083h,0E3h,01h,0D1h,0E3h,081h
; @08BA4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C3h,0ECh,096h,08Bh,037h,0A1h,02Eh,023h,025h,01h,00h,0D1h,0E0h,048h,0D1h,0E0h
; @08BB4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0D1h,0E0h,01h,02h,083h,07Eh,02h,018h,07Eh,03h,0E9h,084h,030h,083h,046h,02h
; @08BC4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,0E9h,07Dh,030h,0C7h,046h,036h,0F0h,096h,0E9h,0F8h,026h,0C7h,046h,036h,0Ch
; @08BD4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 097h,0E9h,0F0h,026h,0C7h,046h,036h,024h,097h,0E9h,0E8h,026h,0C7h,046h,036h,03Ch
; @08BE4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 097h,0E9h,0E0h,026h,0C7h,046h,036h,05Ch,097h,0E9h,0D8h,026h,0C7h,046h,036h,064h
; @08BF4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 097h,0E9h,0D0h,026h,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h
; @08C04 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0CFh,00h,089h,05Eh,08h,0FFh,046h,02h,083h,03Eh,02Eh,023h,01Fh,077h,06h,0FFh
; @08C14 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04Eh,04h,0E9h,02Ch,030h,0FFh,046h,04h,0E9h,026h,030h,0A1h,03Ch,023h,05h,09Dh
; @08C24 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0E9h,084h,026h,0A1h,038h,023h,05h,04Bh,00h,0E9h,084h,0FBh,0A1h,038h,023h
; @08C34 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05h,051h,00h,0E9h,072h,026h,0B8h,01Dh,00h,089h,046h,08h,083h,046h,02h,02h
; @08C44 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,02Ah,023h,0Fh,074h,03h,0E9h,0F7h,02Fh,0B9h,08h,00h,051h,0E8h,021h
; @08C54 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,059h,083h,0FBh,0FFh,075h,03h,0E9h,0E7h,02Fh,0C7h,047h,018h,04h,00h,049h
; @08C64 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,04Fh,06h,041h,0E2h,0E7h,0E9h,0D8h,02Fh,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh
; @08C74 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Fh,0D2h,096h,081h,0C3h,0CFh,00h,089h,05Eh,08h,083h,07Eh,02h,040h,074h,03h
; @08C84 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0BEh,02Fh,0C7h,046h,018h,033h,00h,0C7h,046h,06h,01h,00h,0E9h,03Bh,0FCh
; @08C94 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,07Eh,06h,00h,074h,014h,0C7h,046h,08h,074h,00h,081h,07Eh,02h,0B0h,00h
; @08CA4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,09Ch,02Fh,0C7h,046h,06h,00h,00h,0A1h,028h,023h,0D1h,0E8h,0D1h
; @08CB4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,05h,073h,00h,089h,046h,08h,083h,06Eh,02h,04h,0E9h,089h,02Fh,0C7h,046h
; @08CC4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 08h,06Eh,00h,083h,07Eh,06h,04h,075h,0Fh,081h,07Eh,02h,080h,00h,074h,03h
; @08CD4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,06Eh,02Fh,0C7h,046h,06h,00h,00h,083h,06Eh,02h,04h,083h,07Eh,02h,060h
; @08CE4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 074h,03h,0E9h,062h,02Fh,0C7h,046h,06h,02h,00h,0C7h,046h,018h,039h,00h,0E9h
; @08CF4 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 02Dh,0FDh,08Bh,01Eh,03Ch,023h,0D1h,0E3h,08Bh,09Fh,0D2h,096h,081h,0C3h,0CFh,00h
; @08D04 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,05Eh,08h,0E9h,0B1h,0FBh,0A1h,028h,023h,03h,0C5h,03h,06h,040h,023h,025h
; @08D14 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07h,00h,05h,080h,00h,089h,046h,08h,083h,046h,02h,04h,0E9h,022h,02Fh,0E9h
; @08D24 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Fh,02Fh,08Bh,01Eh,028h,023h,083h,0E3h,0FEh,08Bh,09Fh,0D2h,096h,03h,05Eh,036h
; @08D34 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,05Eh,08h,0E9h,0Bh,02Fh,0F8h,0C3h,09Ah,0C2h,01h,07Fh,0Fh,0E8h,032h,0E7h
; @08D44 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E9h,0FEh,02Eh,09Ah,05Eh,02h,07Fh,0Fh,0E9h,0F6h,02Eh
; @08D4F 0000:8D4F original=9a7a027f0f runtime CFG evidence
    CALL_FAR 0F7Fh,027Ah
; @08D54 0000:8D54 original=e9f42e runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @08D57 0000:8D57 original=9a52047f0f runtime CFG evidence
    CALL_FAR 0F7Fh,0452h
; @08D5C 0000:8D5C original=e9ec2e runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @08D5F 0000:8D5F original=9a73047f0f runtime CFG evidence
    CALL_FAR 0F7Fh,0473h
; @08D64 0000:8D64 original=837e3664 runtime CFG evidence
    cmp word ptr ss:[bp + 036h], 064h
; @08D68 0000:8D68 original=7303 runtime CFG evidence
    JAE_SHORT loc_08D6D
; @08D6A 0000:8D6A original=e9de2e runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @08D6D 0000:8D6D original=e85732 runtime CFG evidence
    CALL_NEAR loc_0BFC7
; @08D70 0000:8D70 original=e9d82e runtime CFG evidence
    JMP_NEAR loc_0BC4B
; @08D73 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ah,09Ah,06h,07Fh,0Fh,0E9h,0D0h,02Eh,09Ah,0B5h,06h,07Fh,0Fh,0E9h,0C8h,02Eh
; @08D83 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ah,0ACh,08h,07Fh,0Fh,0E9h,0C0h,02Eh
; sub_0000_8D8B
; @08D8B 0000:8D8B original=ffd0
    call ax
; @08D8D 0000:8D8D original=cb
    retf
; sub_0000_8D8E
; @08D8E 0000:8D8E original=ffd5
    call bp
; @08D90 0000:8D90 original=cb
    retf
; @08D91 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08DA1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08DB1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08DC1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08DD1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08DE1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08DF1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E01 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E11 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E21 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E31 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E41 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E51 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E61 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E71 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E81 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08E91 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08EA1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08EB1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08EC1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08ED1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08EE1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08EF1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F01 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F11 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F21 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F31 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F41 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F51 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F61 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F71 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F81 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08F91 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08FA1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08FB1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08FC1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08FD1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08FE1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @08FF1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09001 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09011 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09021 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09031 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09041 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09051 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09061 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09071 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09081 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09091 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @090A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @090B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @090C1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @090D1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @090E1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @090F1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09101 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09111 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09121 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09131 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09141 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09151 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09161 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09171 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09181 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09191 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @091A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @091B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @091C1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @091D1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @091E1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @091F1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09201 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09211 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09221 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09231 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09241 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09251 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09261 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09271 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09281 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09291 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @092A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @092B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @092C1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @092D1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @092E1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @092F1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09301 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09311 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09321 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09331 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09341 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09351 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09361 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09371 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09381 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09391 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @093A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @093B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @093C1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @093D1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @093E1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @093F1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09401 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09411 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09421 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09431 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09441 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09451 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09461 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09471 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09481 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09491 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @094A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @094B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @094C1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @094D1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @094E1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @094F1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09501 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09511 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09521 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09531 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09541 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09551 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09561 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09571 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09581 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @09591 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,04Ah,014h,00h,0B8h,0BCh,015h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @095A1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @095B1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; @095C1 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,00h,00h,00h,00h,00h,00h,00h
; sub_0000_95C9
; @095C9 0000:95C9 original=2e8c06c495
    mov word ptr cs:[095C4h], es
; @095CE 0000:95CE original=2e8c1ec695
    mov word ptr cs:[095C6h], ds
; @095D3 0000:95D3 original=fc
    cld
; @095D4 0000:95D4 original=fa
    cli
; @095D5 0000:95D5 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @095DA 0000:95DA original=2e8e169695
    mov ss, word ptr cs:[09596h]
; @095DF 0000:95DF original=bc78a2
    mov sp, 0A278h
; @095E2 0000:95E2 original=fb
    sti
; @095E3 0000:95E3 original=9a3c003415
    CALL_FAR 01534h,03Ch
; @095E8 0000:95E8 original=2e8e06c495
    mov es, word ptr cs:[095C4h]
; @095ED 0000:95ED original=8cc0
    mov ax, es
; @095EF 0000:95EF original=bbef22
    mov bx, 022EFh
; @095F2 0000:95F2 original=2bd8
    sub bx, ax
; @095F4 0000:95F4 original=b44a
    mov ah, 04Ah
; @095F6 0000:95F6 original=cd21
    int 021h
; @095F8 0000:95F8 original=baf60f
    mov dx, 0FF6h
; @095FB 0000:95FB original=7303
    JAE_SHORT loc_09600
; @095FD 0000:95FD original=e97172
    JMP_NEAR loc_00871
; @09600 0000:9600 original=e8e179
    CALL_NEAR BuildByteToNibbleMaskTable_00FE4
; @09603 0000:9603 original=2e8e1ec695
    mov ds, word ptr cs:[095C6h]
; @09608 0000:9608 original=be8000
    mov si, 080h
; @0960B 0000:960B original=2e8e069695
    mov es, word ptr cs:[09596h]
; @09610 0000:9610 original=ac
    lodsb
; @09611 0000:9611 original=ac
    lodsb
; @09612 0000:9612 original=2ea2c895
    mov byte ptr cs:[095C8h], al
; @09616 0000:9616 original=ac
    lodsb
; @09617 0000:9617 original=32e4
    xor ah, ah
; @09619 0000:9619 original=3d0200
    cmp ax, 2
; @0961C 0000:961C original=7602
    JBE_SHORT loc_09620
; @0961E 0000:961E original=b001
    mov al, 1
; @09620 0000:9620 original=2ea3bc95
    mov word ptr cs:[095BCh], ax
; @09624 0000:9624 original=50
    push ax
; @09625 0000:9625 original=ac
    lodsb
; @09626 0000:9626 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0962B 0000:962B original=a2c4bc
    mov byte ptr ds:[0BCC4h], al
; @0962E 0000:962E original=50
    push ax
; @0962F 0000:962F original=e89dbc
    CALL_NEAR loc_052CF
; @09632 0000:9632 original=58
    pop ax
; @09633 0000:9633 original=5b
    pop bx
; @09634 0000:9634 original=2e803ec895f0
    cmp byte ptr cs:[095C8h], 0F0h
; @0963A 0000:963A original=7410
    JE_SHORT loc_0964C
; @0963C 0000:963C original=2e803ec8950f
    cmp byte ptr cs:[095C8h], 0Fh
; @09642 0000:9642 original=7408
    JE_SHORT loc_0964C
; @09644 0000:9644 original=2e803ec895ff
    cmp byte ptr cs:[095C8h], 0FFh
; @0964A 0000:964A original=7522
    JNE_SHORT loc_0966E
; @0964C 0000:964C original=2ef606c895f0
    test byte ptr cs:[095C8h], 0F0h
; @09652 0000:9652 original=7403
    JE_SHORT loc_09657
; @09654 0000:9654 original=e80d00
    CALL_NEAR loc_09664
; @09657 0000:9657 original=2ef606c8950f
    test byte ptr cs:[095C8h], 0Fh
; @0965D 0000:965D original=7403
    JE_SHORT loc_09662
; @0965F 0000:965F original=e80800
    CALL_NEAR loc_0966A
; @09662 0000:9662 original=eb0a
    JMP_SHORT loc_0966E
; sub_0000_9664
; @09664 0000:9664 original=2e891ebc95
    mov word ptr cs:[095BCh], bx
; @09669 0000:9669 original=c3
    ret
; sub_0000_966A
; @0966A 0000:966A original=a2c4bc
    mov byte ptr ds:[0BCC4h], al
; @0966D 0000:966D original=c3
    ret
; @0966E 0000:966E original=e8402f
    CALL_NEAR loc_0C5B1
; @09671 0000:9671 original=e83932
    CALL_NEAR loc_0C8AD
; @09674 0000:9674 original=1e
    push ds
; @09675 0000:9675 original=e80a70
    CALL_NEAR InstallTimerVector08_00682
; @09678 0000:9678 original=1f
    pop ds
; @09679 0000:9679 original=e823b8
    CALL_NEAR loc_04E9F
; @0967C 0000:967C original=e8a338
    CALL_NEAR loc_0CF22
; @0967F 0000:967F original=e89133
    CALL_NEAR loc_0CA13
; @09682 0000:9682 original=9a90017f0f
    CALL_FAR 0F7Fh,0190h
; @09687 0000:9687 original=e8b231
    CALL_NEAR loc_0C83C
; @0968A 0000:968A original=e8492f
    CALL_NEAR loc_0C5D6
; @0968D 0000:968D original=e80834
    CALL_NEAR loc_0CA98
; @09690 0000:9690 original=e8f671
    CALL_NEAR loc_00889
; @09693 0000:9693 original=e87578
    CALL_NEAR loc_00F0B
; @09696 0000:9696 original=e8ddb5
    CALL_NEAR loc_04C76
; @09699 0000:9699 original=e824be
    CALL_NEAR loc_054C0
; @0969C 0000:969C original=e8a376
    CALL_NEAR loc_00D42
; @0969F 0000:969F original=2ec706de0b1413
    mov word ptr cs:[0BDEh], 01314h
; @096A6 0000:96A6 original=2ea19895
    mov ax, word ptr cs:[09598h]
; @096AA 0000:96AA original=05d007
    add ax, 07D0h
; @096AD 0000:96AD original=40
    inc ax
; @096AE 0000:96AE original=2ea3dc0b
    mov word ptr cs:[0BDCh], ax
; @096B2 0000:96B2 original=2ec706e00be20b
    mov word ptr cs:[0BE0h], 0BE2h
; @096B9 0000:96B9 original=e8fc75
    CALL_NEAR loc_00CB8
; @096BC 0000:96BC original=e841c1
    CALL_NEAR loc_05800
; @096BF 0000:96BF original=e860c5
    CALL_NEAR loc_05C22
; @096C2 0000:96C2 original=b9fa00
    mov cx, 0FAh
; @096C5 0000:96C5 original=e801ba
    CALL_NEAR loc_050C9
; @096C8 0000:96C8 original=e2fb
    LOOP_SHORT loc_096C5
; @096CA 0000:96CA original=2ea1bc95
    mov ax, word ptr cs:[095BCh]
; @096CE 0000:96CE original=bbc499
    mov bx, 099C4h
; @096D1 0000:96D1 original=d7
    xlat
; @096D2 0000:96D2 original=cd10
    int 010h
; @096D4 0000:96D4 original=c706a2210100
    mov word ptr ds:[021A2h], 1
; @096DA 0000:96DA original=e811c5
    CALL_NEAR loc_05BEE
; @096DD 0000:96DD original=e80835
    CALL_NEAR loc_0CBE8
; @096E0 0000:96E0 original=b002
    mov al, 2
; @096E2 0000:96E2 original=e83734
    CALL_NEAR loc_0CB1C
; @096E5 0000:96E5 original=e8dbb8
    CALL_NEAR loc_04FC3
; @096E8 0000:96E8 original=e85aba
    CALL_NEAR loc_05145
; @096EB 0000:96EB original=e86bbe
    CALL_NEAR loc_05559
; @096EE 0000:96EE original=c70656230000
    mov word ptr ds:[02356h], 0
; @096F4 0000:96F4 original=c70658230300
    mov word ptr ds:[02358h], 3
; @096FA 0000:96FA original=c7065a230000
    mov word ptr ds:[0235Ah], 0
; @09700 0000:9700 original=c70642a30000
    mov word ptr ds:[0A342h], 0
; @09706 0000:9706 original=c606142300
    mov byte ptr ds:[02314h], 0
; @0970B 0000:970B original=c606152300
    mov byte ptr ds:[02315h], 0
; @09710 0000:9710 original=c606162300
    mov byte ptr ds:[02316h], 0
; @09715 0000:9715 original=c606172300
    mov byte ptr ds:[02317h], 0
; @0971A 0000:971A original=e8733c
    CALL_NEAR loc_0D390
; @0971D 0000:971D original=e87ac5
    CALL_NEAR loc_05C9A
; @09720 0000:9720 original=e8b82d
    CALL_NEAR loc_0C4DB
; @09723 0000:9723 original=c7065aa90300
    mov word ptr ds:[0A95Ah], 3
; @09729 0000:9729 original=c7065ca91800
    mov word ptr ds:[0A95Ch], 018h
; @0972F 0000:972F original=e844ca
    CALL_NEAR loc_06176
; @09732 0000:9732 original=eb10
    JMP_SHORT loc_09744
; @09734 0000:9734 original=833e562300
    cmp word ptr ds:[02356h], 0
; @09739 0000:9739 original=7509
    JNE_SHORT loc_09744
; @0973B 0000:973B original=e80601
    CALL_NEAR loc_09844
; @0973E 0000:973E original=e8adc4
    CALL_NEAR loc_05BEE
; @09741 0000:9741 original=e80370
    CALL_NEAR loc_00747
; @09744 0000:9744 original=ff065623
    inc word ptr ds:[02356h]
; @09748 0000:9748 original=833e562306
    cmp word ptr ds:[02356h], 6
; @0974D 0000:974D original=7206
    JB_SHORT loc_09755
; @0974F 0000:974F original=c70656230000
    mov word ptr ds:[02356h], 0
; @09755 0000:9755 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0975A 0000:975A original=7405
    JE_SHORT loc_09761
; @0975C 0000:975C original=c606ffbe04
    mov byte ptr ds:[0BEFFh], 4
; @09761 0000:9761 original=e8e1b9
    CALL_NEAR loc_05145
; @09764 0000:9764 original=e863c4
    CALL_NEAR loc_05BCA
; @09767 0000:9767 original=e80cca
    CALL_NEAR loc_06176
; @0976A 0000:976A original=e8d173
    CALL_NEAR loc_00B3E
; @0976D 0000:976D original=e82c77
    CALL_NEAR loc_00E9C
; @09770 0000:9770 original=e839c9
    CALL_NEAR loc_060AC
; @09773 0000:9773 original=833e5823ff
    cmp word ptr ds:[02358h], -1
; @09778 0000:9778 original=7503
    JNE_SHORT loc_0977D
; @0977A 0000:977A original=e96e01
    JMP_NEAR loc_098EB
; @0977D 0000:977D original=e8262c
    CALL_NEAR loc_0C3A6
; @09780 0000:9780 original=e842e0
    CALL_NEAR loc_077C5
; @09783 0000:9783 original=e83902
    CALL_NEAR InitPositionHistory_099BF
; @09786 0000:9786 original=e8edc9
    CALL_NEAR loc_06176
; @09789 0000:9789 original=bd7c23
    mov bp, 0237Ch
; @0978C 0000:978C original=e85304
    CALL_NEAR loc_09BE2
; @0978F 0000:978F original=e8ae11
    CALL_NEAR loc_0A940
; @09792 0000:9792 original=c706a620a820
    mov word ptr ds:[020A6h], 020A8h
; @09798 0000:9798 original=e8e12d
    CALL_NEAR loc_0C57C
; @0979B 0000:979B original=e80b1e
    CALL_NEAR loc_0B5A9
; @0979E 0000:979E original=c706c2a80000
    mov word ptr ds:[0A8C2h], 0
; @097A4 0000:97A4 original=e89cc7
    CALL_NEAR loc_05F43
; @097A7 0000:97A7 original=813e50239c00
    cmp word ptr ds:[02350h], 09Ch
; @097AD 0000:97AD original=7503
    JNE_SHORT loc_097B2
; @097AF 0000:97AF original=e8533b
    CALL_NEAR loc_0D305
; @097B2 0000:97B2 original=e8bd6e
    CALL_NEAR ClearByteCS066B_00672
; @097B5 0000:97B5 original=e867b9
    CALL_NEAR loc_0511F
; @097B8 0000:97B8 original=e88b10
    CALL_NEAR loc_0A846
; @097BB 0000:97BB original=833e7aa900
    cmp word ptr ds:[0A97Ah], 0
; @097C0 0000:97C0 original=7503
    JNE_SHORT loc_097C5
; @097C2 0000:97C2 original=e85a00
    CALL_NEAR loc_0981F
; @097C5 0000:97C5 original=e814c4
    CALL_NEAR loc_05BDC
; @097C8 0000:97C8 original=e84111
    CALL_NEAR loc_0A90C
; @097CB 0000:97CB original=e86003
    CALL_NEAR loc_09B2E
; @097CE 0000:97CE original=833e44a301
    cmp word ptr ds:[0A344h], 1
; @097D3 0000:97D3 original=7503
    JNE_SHORT loc_097D8
; @097D5 0000:97D5 original=e95cff
    JMP_NEAR loc_09734
; @097D8 0000:97D8 original=833e42a301
    cmp word ptr ds:[0A342h], 1
; @097DD 0000:97DD original=7503
    JNE_SHORT loc_097E2
; @097DF 0000:97DF original=e92001
    JMP_NEAR loc_09902
; @097E2 0000:97E2 original=833e46a301
    cmp word ptr ds:[0A346h], 1
; @097E7 0000:97E7 original=7503
    JNE_SHORT loc_097EC
; @097E9 0000:97E9 original=e91c01
    JMP_NEAR loc_09908
; @097EC 0000:97EC original=e85111
    CALL_NEAR loc_0A940
; @097EF 0000:97EF original=e84a6f
    CALL_NEAR loc_0073C
; @097F2 0000:97F2 original=e8adc8
    CALL_NEAR loc_060A2
; @097F5 0000:97F5 original=803e8f9700
    cmp byte ptr ds:[0978Fh], 0
; @097FA 0000:97FA original=740a
    JE_SHORT loc_09806
; @097FC 0000:97FC original=803e029901
    cmp byte ptr ds:[09902h], 1
; @09801 0000:9801 original=7503
    JNE_SHORT loc_09806
; @09803 0000:9803 original=e92eff
    JMP_NEAR loc_09734
; @09806 0000:9806 original=803e089901
    cmp byte ptr ds:[09908h], 1
; @0980B 0000:980B original=7503
    JNE_SHORT loc_09810
; @0980D 0000:980D original=e82701
    CALL_NEAR loc_09937
; @09810 0000:9810 original=803ec59801
    cmp byte ptr ds:[098C5h], 1
; @09815 0000:9815 original=744b
    JE_SHORT loc_09862
; @09817 0000:9817 original=e846b9
    CALL_NEAR loc_05160
; @0981A 0000:981A original=e85c6e
    CALL_NEAR WaitByteCS066B_00679
; @0981D 0000:981D original=eb93
    JMP_SHORT loc_097B2
; sub_0000_981F
; @0981F 0000:981F original=b004
    mov al, 4
; @09821 0000:9821 original=b458
    mov ah, 058h
; @09823 0000:9823 original=e8ecc1
    CALL_NEAR loc_05A12
; @09826 0000:9826 original=033e4c23
    add di, word ptr ds:[0234Ch]
; @0982A 0000:982A original=be2900
    mov si, 029h
; @0982D 0000:982D original=d1e6
    shl si, 1
; @0982F 0000:982F original=81c6e40b
    add si, 0BE4h
; @09833 0000:9833 original=2e8b34
    mov si, word ptr cs:[si]
; @09836 0000:9836 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @0983B 0000:983B original=e80ac2
    CALL_NEAR loc_05A48
; @0983E 0000:983E original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @09843 0000:9843 original=c3
    ret
; sub_0000_9844
; @09844 0000:9844 original=e8a7c3
    CALL_NEAR loc_05BEE
; @09847 0000:9847 original=b8d0be
    mov ax, 0BED0h
; @0984A 0000:984A original=9a80097f0f
    CALL_FAR 0F7Fh,0980h
; @0984F 0000:984F original=b94b00
    mov cx, 04Bh
; @09852 0000:9852 original=e874b8
    CALL_NEAR loc_050C9
; @09855 0000:9855 original=e2fb
    LOOP_SHORT loc_09852
; @09857 0000:9857 original=e80869
    CALL_NEAR loc_00162
; @0985A 0000:985A original=f606be9810
    test byte ptr ds:[098BEh], 010h
; @0985F 0000:985F original=74f6
    JE_SHORT loc_09857
; @09861 0000:9861 original=c3
    ret
; @09862 0000:9862 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @09867 0000:9867 original=7405
    JE_SHORT loc_0986E
; @09869 0000:9869 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @0986E 0000:986E original=803ec59801
    cmp byte ptr ds:[098C5h], 1
; @09873 0000:9873 original=74f9
    JE_SHORT loc_0986E
; @09875 0000:9875 original=e842b8
    CALL_NEAR loc_050BA
; @09878 0000:9878 original=e8a4b8
    CALL_NEAR loc_0511F
; @0987B 0000:987B original=b004
    mov al, 4
; @0987D 0000:987D original=b45c
    mov ah, 05Ch
; @0987F 0000:987F original=e87ec1
    CALL_NEAR loc_05A00
; @09882 0000:9882 original=be2800
    mov si, 028h
; @09885 0000:9885 original=d1e6
    shl si, 1
; @09887 0000:9887 original=81c6e40b
    add si, 0BE4h
; @0988B 0000:988B original=2e8b34
    mov si, word ptr cs:[si]
; @0988E 0000:988E original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @09893 0000:9893 original=e8d6c1
    CALL_NEAR loc_05A6C
; @09896 0000:9896 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0989B 0000:989B original=e881b8
    CALL_NEAR loc_0511F
; @0989E 0000:989E original=c606b4224e
    mov byte ptr ds:[022B4h], 04Eh
; @098A3 0000:98A3 original=803ef59801
    cmp byte ptr ds:[098F5h], 1
; @098A8 0000:98A8 original=740c
    JE_SHORT loc_098B6
; @098AA 0000:98AA original=c606b42259
    mov byte ptr ds:[022B4h], 059h
; @098AF 0000:98AF original=803ed99801
    cmp byte ptr ds:[098D9h], 1
; @098B4 0000:98B4 original=75e8
    JNE_SHORT loc_0989E
; @098B6 0000:98B6 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @098BB 0000:98BB original=7405
    JE_SHORT loc_098C2
; @098BD 0000:98BD original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @098C2 0000:98C2 original=8026b422df
    and byte ptr ds:[022B4h], 0DFh
; @098C7 0000:98C7 original=803eb42259
    cmp byte ptr ds:[022B4h], 059h
; @098CC 0000:98CC original=7403
    JE_SHORT loc_098D1
; @098CE 0000:98CE original=e946ff
    JMP_NEAR loc_09817
; @098D1 0000:98D1 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @098D6 0000:98D6 original=7407
    JE_SHORT loc_098DF
; @098D8 0000:98D8 original=803efebe00
    cmp byte ptr ds:[0BEFEh], 0
; @098DD 0000:98DD original=75f9
    JNE_SHORT loc_098D8
; @098DF 0000:98DF original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @098E4 0000:98E4 original=7405
    JE_SHORT loc_098EB
; @098E6 0000:98E6 original=c606ffbe01
    mov byte ptr ds:[0BEFFh], 1
; @098EB 0000:98EB original=e857b8
    CALL_NEAR loc_05145
; @098EE 0000:98EE original=e8f5be
    CALL_NEAR loc_057E6
; @098F1 0000:98F1 original=e841c3
    CALL_NEAR loc_05C35
; @098F4 0000:98F4 original=b99600
    mov cx, 096h
; @098F7 0000:98F7 original=e8cfb7
    CALL_NEAR loc_050C9
; @098FA 0000:98FA original=e2fb
    LOOP_SHORT loc_098F7
; @098FC 0000:98FC original=e884b9
    CALL_NEAR loc_05283
; @098FF 0000:98FF original=e9defd
    JMP_NEAR loc_096E0
; @09902 0000:9902 original=c70658230000
    mov word ptr ds:[02358h], 0
; @09908 0000:9908 original=e8d02b
    CALL_NEAR loc_0C4DB
; @0990B 0000:990B original=ff0e5823
    dec word ptr ds:[02358h]
; @0990F 0000:990F original=803e8d9700
    cmp byte ptr ds:[0978Dh], 0
; @09914 0000:9914 original=7404
    JE_SHORT loc_0991A
; @09916 0000:9916 original=ff065823
    inc word ptr ds:[02358h]
; @0991A 0000:991A original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0991F 0000:991F original=7407
    JE_SHORT loc_09928
; @09921 0000:9921 original=803efebe00
    cmp byte ptr ds:[0BEFEh], 0
; @09926 0000:9926 original=75f9
    JNE_SHORT loc_09921
; @09928 0000:9928 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0992D 0000:992D original=7405
    JE_SHORT loc_09934
; @0992F 0000:992F original=c606ffbe02
    mov byte ptr ds:[0BEFFh], 2
; @09934 0000:9934 original=e93cfe
    JMP_NEAR loc_09773
; sub_0000_9937
; @09937 0000:9937 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @0993C 0000:993C original=7405
    JE_SHORT loc_09943
; @0993E 0000:993E original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @09943 0000:9943 original=803e089901
    cmp byte ptr ds:[09908h], 1
; @09948 0000:9948 original=74f9
    JE_SHORT loc_09943
; @0994A 0000:994A original=e8d2b7
    CALL_NEAR loc_0511F
; @0994D 0000:994D original=b004
    mov al, 4
; @0994F 0000:994F original=b448
    mov ah, 048h
; @09951 0000:9951 original=e8acc0
    CALL_NEAR loc_05A00
; @09954 0000:9954 original=be2700
    mov si, 027h
; @09957 0000:9957 original=d1e6
    shl si, 1
; @09959 0000:9959 original=81c6e40b
    add si, 0BE4h
; @0995D 0000:995D original=2e8b34
    mov si, word ptr cs:[si]
; @09960 0000:9960 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @09965 0000:9965 original=e804c1
    CALL_NEAR loc_05A6C
; @09968 0000:9968 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0996D 0000:996D original=b004
    mov al, 4
; @0996F 0000:996F original=b470
    mov ah, 070h
; @09971 0000:9971 original=e88cc0
    CALL_NEAR loc_05A00
; @09974 0000:9974 original=be2600
    mov si, 026h
; @09977 0000:9977 original=d1e6
    shl si, 1
; @09979 0000:9979 original=81c6e40b
    add si, 0BE4h
; @0997D 0000:997D original=2e8b34
    mov si, word ptr cs:[si]
; @09980 0000:9980 original=2e8e1eb495
    mov ds, word ptr cs:[095B4h]
; @09985 0000:9985 original=e8e4c0
    CALL_NEAR loc_05A6C
; @09988 0000:9988 original=2e8e1e9695
    mov ds, word ptr cs:[09596h]
; @0998D 0000:998D original=e88fb7
    CALL_NEAR loc_0511F
; @09990 0000:9990 original=c606c39800
    mov byte ptr ds:[098C3h], 0
; @09995 0000:9995 original=9a8c007f0f
    CALL_FAR 0F7Fh,08Ch
; @0999A 0000:999A original=e8c567
    CALL_NEAR loc_00162
; @0999D 0000:999D original=803ebe9810
    cmp byte ptr ds:[098BEh], 010h
; @099A2 0000:99A2 original=7407
    JE_SHORT loc_099AB
; @099A4 0000:99A4 original=803e089901
    cmp byte ptr ds:[09908h], 1
; @099A9 0000:99A9 original=75ea
    JNE_SHORT loc_09995
; @099AB 0000:99AB original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @099B0 0000:99B0 original=7405
    JE_SHORT loc_099B7
; @099B2 0000:99B2 original=c606ffbe1c
    mov byte ptr ds:[0BEFFh], 01Ch
; @099B7 0000:99B7 original=803e089901
    cmp byte ptr ds:[09908h], 1
; @099BC 0000:99BC original=74f9
    JE_SHORT loc_099B7
; @099BE 0000:99BE original=c3
    ret
; sub_0000_99BF
; InitPositionHistory (modern reconstruction name)
; Near leaf. Set ES=CS:9596, BP=237Ch. With DF=0 fill48 four-byte pairs at ES:A27A with (SS:[237E]+8,
; SS:[2380]+9), modulo65536. Then DS:A33A/A33C/A33E/A340 become A27A/A2FE/A2BE/A27E. CX=0,DI=A33A,AX=last X+9;
; BX,DX,SI,DS,SS preserved. Flags from final ADD. Requires valid buffers and source not overwritten by
; destination for uniform-fill interpretation; loads repeat each iteration. Unlike later writes, initial X bias
; is9, not8.
; Evidence: metadata/symbols.json
; @099BF 0000:99BF original=2e8e069695
    mov es, word ptr cs:[MAIN_DATA_SEGMENT]
; @099C4 0000:99C4 original=bf7aa2
    mov di, HISTORY_BEGIN
; @099C7 0000:99C7 original=b93000
    mov cx, HISTORY_PAIR_COUNT
; @099CA 0000:99CA original=bd7c23
    mov bp, PRIMARY_RECORD
; @099CD 0000:99CD original=8b4602
    mov ax, word ptr ss:[bp + REC_Y]
; @099D0 0000:99D0 original=050800
    add ax, 8
; @099D3 0000:99D3 original=ab
    stosw
; @099D4 0000:99D4 original=8b4604
    mov ax, word ptr ss:[bp + REC_X]
; @099D7 0000:99D7 original=050900
    add ax, 9
; @099DA 0000:99DA original=ab
    stosw
; @099DB 0000:99DB original=e2f0
    LOOP_SHORT loc_099CD
; @099DD 0000:99DD original=c7063aa37aa2
    mov word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_BEGIN
; @099E3 0000:99E3 original=c7063ca3fea2
    mov word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_INITIAL_READ_15
; @099E9 0000:99E9 original=c7063ea3bea2
    mov word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_INITIAL_READ_31
; @099EF 0000:99EF original=c70640a37ea2
    mov word ptr ds:[HISTORY_CURSOR_47], HISTORY_INITIAL_CURSOR_47
; @099F5 0000:99F5 original=c3
    ret
; sub_0000_99F6
; @099F6 0000:99F6 original=83268023fe
    and word ptr ds:[02380h], 0FFFEh
; @099FB 0000:99FB original=c606be9800
    mov byte ptr ds:[098BEh], 0
; @09A00 0000:9A00 original=8b1e7ca4
    mov bx, word ptr ds:[0A47Ch]
; @09A04 0000:9A04 original=d1e3
    shl bx, 1
; @09A06 0000:9A06 original=2effa70c9a
    jmp word ptr cs:[bx - 065F4h]
; @09A0B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 090h,0AFh,044h,078h,09Ah,03Eh,09Ah,016h,09Ah,0AFh,044h,0C6h,06h,0BEh,098h,08h
; @09A1B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,09Bh,03h,0E8h,0C9h,03h,083h,03Eh,07Ah,0A9h,058h,074h,01h,0C3h,083h,03Eh
; @09A2B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 05Ah,0A9h,03h,074h,01h,0C3h,083h,03Eh,05Ch,0A9h,018h,074h,01h,0C3h,0FFh,06h
; @09A3B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 07Ch,0A4h,0C3h,083h,03Eh,084h,023h,00h,075h,018h,083h,03Eh,09Ch,0A3h,08h,074h
; @09A4B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 04h,0FFh,06h,09Ch,0A3h,083h,03Eh,09Ah,0A3h,0F8h,074h,01Ch,0FFh,0Eh,09Ah,0A3h
; @09A5B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0EBh,016h,083h,03Eh,09Ch,0A3h,0Fh,074h,04h,0FFh,06h,09Ch,0A3h,083h,03Eh,09Ah
; @09A6B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A3h,0F1h,074h,04h,0FFh,0Eh,09Ah,0A3h,0BEh,05Ch,0A3h,0EBh,03h,0BEh,058h,0A3h
; @09A7B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0E8h,053h,00h,080h,03Eh,0BEh,098h,00h,074h,01h,0C3h,0FFh,06h,07Ch,0A4h,083h
; @09A8B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,07Ch,0A4h,02h,074h,03h,0E9h,062h,0FFh,0C7h,06h,09Ah,0A3h,00h,00h,0C7h
; @09A9B UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,09Ch,0A3h,00h,00h,0E8h,081h,0DAh,0C7h,07h,01h,00h,0C7h,047h,016h,04h
; @09AAB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C7h,047h,018h,052h,00h,0C7h,047h,014h,02h,00h,0C7h,047h,028h,0FFh,0FFh
; @09ABB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0C7h,047h,08h,0Fh,00h,0C7h,047h,02h,020h,00h,0C7h,047h,04h,058h,00h,089h
; @09ACB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01Eh,088h,097h,0E9h,025h,0FFh,0ADh,039h,06h,07Eh,023h,074h,0Ch,0C6h,06h,0BEh
; @09ADB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 098h,04h,072h,05h,0C6h,06h,0BEh,098h,08h,0ADh,039h,06h,080h,023h,074h,013h
; @09AEB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 09Ch,080h,0Eh,0BEh,098h,01h,09Dh,072h,0Ah,080h,026h,0BEh,098h,0FEh,080h,0Eh
; @09AFB UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0BEh,098h,02h,0C3h
; @09AFF 0000:9AFF original=833e262303
    cmp word ptr ds:[02326h], 3
; @09B04 0000:9B04 original=7401
    JE_SHORT loc_09B07
; @09B06 0000:9B06 original=c3
    ret
; @09B07 0000:9B07 original=ff4608
    inc word ptr ss:[bp + 8]
; @09B0A 0000:9B0A original=837e080f
    cmp word ptr ss:[bp + 8], 0Fh
; @09B0E 0000:9B0E original=7401
    JE_SHORT loc_09B11
; @09B10 0000:9B10 original=c3
    ret
; @09B11 0000:9B11 original=c746000000
    mov word ptr ss:[bp], 0
; @09B16 0000:9B16 original=e8a6b2
    CALL_NEAR loc_04DBF
; @09B19 0000:9B19 original=c70646a30100
    mov word ptr ds:[0A346h], 1
; @09B1F 0000:9B1F original=833e7aa900
    cmp word ptr ds:[0A97Ah], 0
; @09B24 0000:9B24 original=7401
    JE_SHORT loc_09B27
; @09B26 0000:9B26 original=c3
    ret
; @09B27 0000:9B27 original=c70642a30100
    mov word ptr ds:[0A342h], 1
; @09B2D 0000:9B2D original=c3
    ret
; sub_0000_9B2E
; @09B2E 0000:9B2E original=c70646a30000
    mov word ptr ds:[0A346h], 0
; @09B34 0000:9B34 original=c70644a30000
    mov word ptr ds:[0A344h], 0
; @09B3A 0000:9B3A original=e82566
    CALL_NEAR loc_00162
; @09B3D 0000:9B3D original=833e7ca400
    cmp word ptr ds:[MOVE_MODE_A47C], 0
; @09B42 0000:9B42 original=7403
    JE_SHORT loc_09B47
; @09B44 0000:9B44 original=e8affe
    CALL_NEAR loc_099F6
; @09B47 0000:9B47 original=833e7ca404
    cmp word ptr ds:[MOVE_MODE_A47C], 4
; @09B4C 0000:9B4C original=7507
    JNE_SHORT loc_09B55
; @09B4E 0000:9B4E original=c70644a30100
    mov word ptr ds:[0A344h], 1
; @09B54 0000:9B54 original=c3
    ret
; @09B55 0000:9B55 original=c70678a20000
    mov word ptr ds:[0A278h], 0
; @09B5B 0000:9B5B original=bd7c23
    mov bp, 0237Ch
; @09B5E 0000:9B5E original=e8b106
    CALL_NEAR loc_0A212
; @09B61 0000:9B61 original=833e5aa9ff
    cmp word ptr ds:[0A95Ah], -1
; @09B66 0000:9B66 original=7497
    JE_SHORT loc_09AFF
; @09B68 0000:9B68 original=833e7aa900
    cmp word ptr ds:[0A97Ah], 0
; @09B6D 0000:9B6D original=7490
    JE_SHORT loc_09AFF
; @09B6F 0000:9B6F original=f606be9808
    test byte ptr ds:[INPUT_BITS], IN_YMINUS
; @09B74 0000:9B74 original=7403
    JE_SHORT loc_09B79
; @09B76 0000:9B76 original=e8580a
    CALL_NEAR DecRecordYByMode_0A5D1
; @09B79 0000:9B79 original=f606be9804
    test byte ptr ds:[INPUT_BITS], IN_YPLUS
; @09B7E 0000:9B7E original=7403
    JE_SHORT loc_09B83
; @09B80 0000:9B80 original=e8670a
    CALL_NEAR IncRecordYTwice_0A5EA
; @09B83 0000:9B83 original=f606be9801
    test byte ptr ds:[INPUT_BITS], IN_XPLUS
; @09B88 0000:9B88 original=7403
    JE_SHORT loc_09B8D
; @09B8A 0000:9B8A original=e87a0a
    CALL_NEAR IncRecordXTwice_0A607
; @09B8D 0000:9B8D original=f606be9802
    test byte ptr ds:[INPUT_BITS], IN_XMINUS
; @09B92 0000:9B92 original=7403
    JE_SHORT loc_09B97
; @09B94 0000:9B94 original=e8620a
    CALL_NEAR DecRecordXTwice_0A5F9
; @09B97 0000:9B97 original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @09B9D 0000:9B9D original=760a
    JBE_SHORT loc_09BA9
; @09B9F 0000:9B9F original=f606be9820
    test byte ptr ds:[INPUT_BITS], 020h
; @09BA4 0000:9BA4 original=7403
    JE_SHORT loc_09BA9
; @09BA6 0000:9BA6 original=e89de9
    CALL_NEAR loc_08546
; @09BA9 0000:9BA9 original=e8c30a
    CALL_NEAR loc_0A66F
; @09BAC 0000:9BAC original=e8b804
    CALL_NEAR loc_0A067
; @09BAF 0000:9BAF original=803e8e9700
    cmp byte ptr ds:[0978Eh], 0
; @09BB4 0000:9BB4 original=740a
    JE_SHORT loc_09BC0
; @09BB6 0000:9BB6 original=803ec89801
    cmp byte ptr ds:[098C8h], 1
; @09BBB 0000:9BBB original=7503
    JNE_SHORT loc_09BC0
; @09BBD 0000:9BBD original=e88d01
    CALL_NEAR loc_09D4D
; @09BC0 0000:9BC0 original=833e7ca401
    cmp word ptr ds:[MOVE_MODE_A47C], 1
; @09BC5 0000:9BC5 original=7703
    JA_SHORT loc_09BCA
; @09BC7 0000:9BC7 original=e84c0a
    CALL_NEAR loc_0A616
; @09BCA 0000:9BCA original=833e7ca400
    cmp word ptr ds:[MOVE_MODE_A47C], 0
; @09BCF 0000:9BCF original=750e
    JNE_SHORT loc_09BDF
; @09BD1 0000:9BD1 original=e8e200
    CALL_NEAR loc_09CB6
; @09BD4 0000:9BD4 original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @09BDA 0000:9BDA original=7603
    JBE_SHORT loc_09BDF
; @09BDC 0000:9BDC original=e82200
    CALL_NEAR AdjustRecordXFromCounts_09C01
; @09BDF 0000:9BDF original=e80f01
    CALL_NEAR AdvancePositionHistoryIfRequested_09CF1
; sub_0000_9BE2
; @09BE2 0000:9BE2 original=e8f400
    CALL_NEAR StorePositionHistory_09CD9
; @09BE5 0000:9BE5 original=e84904
    CALL_NEAR ApplyPositionHistoryToRecords_0A031
; @09BE8 0000:9BE8 original=833eacbd00
    cmp word ptr ds:[0BDACh], 0
; @09BED 0000:9BED original=7508
    JNE_SHORT loc_09BF7
; @09BEF 0000:9BEF original=813e5023b600
    cmp word ptr ds:[02350h], 0B6h
; @09BF5 0000:9BF5 original=7603
    JBE_SHORT loc_09BFA
; @09BF7 0000:9BF7 original=e8b503
    CALL_NEAR PlaceFourRecordsFromOffsetTables_09FAF
; @09BFA 0000:9BFA original=c3
    ret
; sub_0000_9BFB
; @09BFB 0000:9BFB original=fec4
    inc ah
; @09BFD 0000:9BFD original=c3
    ret
; sub_0000_9BFE
; @09BFE 0000:9BFE original=fec0
    inc al
; @09C00 0000:9C00 original=c3
    ret
; sub_0000_9C01
; AdjustRecordXFromCounts (modern reconstruction name)
; Near entry; DS holds input/state, SS:BP the record. Clear DS:A360. If bit2 of DS:98BE absent and byte A39E==1,
; apply IncRecordXTwice and set A360=1. Then if bit1 absent and A39F==1, apply DecRecordXTwice and set A360=1.
; AH counts words A966/A96A notFFFF; AL counts A968/A96C notFFFF. If counts equal, return via shared44AF RET.
; Otherwise, if count difference magnitude2 or DS:2324!=1, set A360=1 and tail to one-step X increment for
; AH>AL, decrement otherwise. FlagA360 records taking an adjustment path even if bound prevents movement. Return
; AX=(AHcount<<8)|ALcount,BX=2*(ALcount+3*AHcount); CX,DX,SI,DI,BP and segments preserved. Flags are path-
; dependent; caller9BDF ignores them before overwrite in9CF1. Assumes normal entry and no asynchronous register
; corruption.
; Evidence: metadata/symbols.json
; @09C01 0000:9C01 original=c70660a30000
    mov word ptr ds:[X_ADJUST_TAKEN], 0
; @09C07 0000:9C07 original=f606be9802
    test byte ptr ds:[INPUT_BITS], IN_XMINUS
; @09C0C 0000:9C0C original=7510
    JNE_SHORT loc_09C1E
; @09C0E 0000:9C0E original=803e9ea301
    cmp byte ptr ds:[AUTO_XPLUS_A39E], 1
; @09C13 0000:9C13 original=7509
    JNE_SHORT loc_09C1E
; @09C15 0000:9C15 original=e8ef09
    CALL_NEAR IncRecordXTwice_0A607
; @09C18 0000:9C18 original=c70660a30100
    mov word ptr ds:[X_ADJUST_TAKEN], 1
; @09C1E 0000:9C1E original=f606be9801
    test byte ptr ds:[INPUT_BITS], IN_XPLUS
; @09C23 0000:9C23 original=7510
    JNE_SHORT loc_09C35
; @09C25 0000:9C25 original=803e9fa301
    cmp byte ptr ds:[AUTO_XMINUS_A39F], 1
; @09C2A 0000:9C2A original=7509
    JNE_SHORT loc_09C35
; @09C2C 0000:9C2C original=e8ca09
    CALL_NEAR DecRecordXTwice_0A5F9
; @09C2F 0000:9C2F original=c70660a30100
    mov word ptr ds:[X_ADJUST_TAKEN], 1
; @09C35 0000:9C35 original=33c0
    xor ax, ax
; @09C37 0000:9C37 original=833e66a9ff
    cmp word ptr ds:[PLUS_SLOT_A966], -1
; @09C3C 0000:9C3C original=7403
    JE_SHORT loc_09C41
; @09C3E 0000:9C3E original=e8baff
    CALL_NEAR loc_09BFB
; @09C41 0000:9C41 original=833e68a9ff
    cmp word ptr ds:[MINUS_SLOT_A968], -1
; @09C46 0000:9C46 original=7403
    JE_SHORT loc_09C4B
; @09C48 0000:9C48 original=e8b3ff
    CALL_NEAR loc_09BFE
; @09C4B 0000:9C4B original=833e6aa9ff
    cmp word ptr ds:[PLUS_SLOT_A96A], -1
; @09C50 0000:9C50 original=7403
    JE_SHORT loc_09C55
; @09C52 0000:9C52 original=e8a6ff
    CALL_NEAR loc_09BFB
; @09C55 0000:9C55 original=833e6ca9ff
    cmp word ptr ds:[MINUS_SLOT_A96C], -1
; @09C5A 0000:9C5A original=7403
    JE_SHORT loc_09C5F
; @09C5C 0000:9C5C original=e89fff
    CALL_NEAR loc_09BFE
; @09C5F 0000:9C5F original=8ad8
    mov bl, al
; @09C61 0000:9C61 original=32ff
    xor bh, bh
; @09C63 0000:9C63 original=02dc
    add bl, ah
; @09C65 0000:9C65 original=02dc
    add bl, ah
; @09C67 0000:9C67 original=02dc
    add bl, ah
; @09C69 0000:9C69 original=d1e3
    shl bx, 1
; @09C6B 0000:9C6B original=2effa7709c
    jmp word ptr cs:[bx + COUNT_X_TABLE]
; Nine exhaustive targets for index AL_count + 3*AH_count, each count0..2.
; @09C70 reviewed CS-relative code pointer; counts AH=0, AL=0
    dw CountXReturn
; @09C72 reviewed CS-relative code pointer; counts AH=0, AL=1
    dw CountXDecIfGate
; @09C74 reviewed CS-relative code pointer; counts AH=0, AL=2
    dw CountXDec
; @09C76 reviewed CS-relative code pointer; counts AH=1, AL=0
    dw CountXIncIfGate
; @09C78 reviewed CS-relative code pointer; counts AH=1, AL=1
    dw CountXReturn
; @09C7A reviewed CS-relative code pointer; counts AH=1, AL=2
    dw CountXDecIfGate
; @09C7C reviewed CS-relative code pointer; counts AH=2, AL=0
    dw CountXInc
; @09C7E reviewed CS-relative code pointer; counts AH=2, AL=1
    dw CountXIncIfGate
; @09C80 reviewed CS-relative code pointer; counts AH=2, AL=2
    dw CountXReturn
; @09C82 0000:9C82 original=833e242301 runtime CFG evidence
    cmp word ptr ds:[COUNT_GATE_2324], 1
; @09C87 0000:9C87 original=7501 runtime CFG evidence
    JNE_SHORT loc_09C8A
; @09C89 0000:9C89 original=c3 runtime CFG evidence
    ret
; @09C8A 0000:9C8A original=c70660a30100 runtime CFG evidence
    mov word ptr ds:[X_ADJUST_TAKEN], 1
; @09C90 0000:9C90 original=e97709 runtime CFG evidence
    JMP_NEAR loc_0A60A
; @09C93 0000:9C93 original=c70660a30100 runtime CFG evidence
    mov word ptr ds:[X_ADJUST_TAKEN], 1
; @09C99 0000:9C99 original=e96e09 runtime CFG evidence
    JMP_NEAR loc_0A60A
; @09C9C 0000:9C9C original=833e242301 runtime CFG evidence
    cmp word ptr ds:[COUNT_GATE_2324], 1
; @09CA1 0000:9CA1 original=7501 runtime CFG evidence
    JNE_SHORT loc_09CA4
; @09CA3 0000:9CA3 original=c3 runtime CFG evidence
    ret
; @09CA4 0000:9CA4 original=c70660a30100 runtime CFG evidence
    mov word ptr ds:[X_ADJUST_TAKEN], 1
; @09CAA 0000:9CAA original=e94f09 runtime CFG evidence
    JMP_NEAR loc_0A5FC
; @09CAD 0000:9CAD original=c70660a30100 runtime CFG evidence
    mov word ptr ds:[X_ADJUST_TAKEN], 1
; @09CB3 0000:9CB3 original=e94609 runtime CFG evidence
    JMP_NEAR loc_0A5FC
; sub_0000_9CB6
; @09CB6 0000:9CB6 original=e840b3
    CALL_NEAR loc_04FF9
; @09CB9 0000:9CB9 original=7201
    JB_SHORT loc_09CBC
; @09CBB 0000:9CBB original=c3
    ret
; @09CBC 0000:9CBC original=55
    push bp
; @09CBD 0000:9CBD original=833edcbe00
    cmp word ptr ds:[0BEDCh], 0
; @09CC2 0000:9CC2 original=740d
    JE_SHORT loc_09CD1
; @09CC4 0000:9CC4 original=833edcbe01
    cmp word ptr ds:[0BEDCh], 1
; @09CC9 0000:9CC9 original=7403
    JE_SHORT loc_09CCE
; @09CCB 0000:9CCB original=e84b01
    CALL_NEAR loc_09E19
; @09CCE 0000:9CCE original=e84801
    CALL_NEAR loc_09E19
; @09CD1 0000:9CD1 original=e84501
    CALL_NEAR loc_09E19
; @09CD4 0000:9CD4 original=e84201
    CALL_NEAR loc_09E19
; @09CD7 0000:9CD7 original=5d
    pop bp
; @09CD8 0000:9CD8 original=c3
    ret
; sub_0000_9CD9
; StorePositionHistory (modern reconstruction name)
; Near leaf. ES=CS:9596, DI=DS:A33A; with DF=0 store SS:[BP+2]+8 then SS:[BP+4]+8 to ES:DI/DI+2, modulo65536. DI
; advances4; AX holds X+8, flags from final ADD. BX,CX,DX,SI,BP,DS,SS preserved. Does not move the ring cursor.
; Assumes valid nonoverlapping record/history for pair semantics; the second source load occurs after the first
; store. DF is preserved, not cleared.
; Evidence: metadata/symbols.json
; @09CD9 0000:9CD9 original=2e8e069695
    mov es, word ptr cs:[MAIN_DATA_SEGMENT]
; @09CDE 0000:9CDE original=8b3e3aa3
    mov di, word ptr ds:[HISTORY_WRITE_CURSOR]
; @09CE2 0000:9CE2 original=8b4602
    mov ax, word ptr ss:[bp + REC_Y]
; @09CE5 0000:9CE5 original=050800
    add ax, 8
; @09CE8 0000:9CE8 original=ab
    stosw
; @09CE9 0000:9CE9 original=8b4604
    mov ax, word ptr ss:[bp + REC_X]
; @09CEC 0000:9CEC original=050800
    add ax, 8
; @09CEF 0000:9CEF original=ab
    stosw
; @09CF0 0000:9CF0 original=c3
    ret
; sub_0000_9CF1
; AdvancePositionHistoryIfRequested (modern reconstruction name)
; Near leaf. If low nibble of DS:98BE is zero and word DS:A360 is zero, return without writes. Otherwise advance
; each of four word cursors DS:A33A/A33C/A33E/A340 by4 modulo65536, replacing exactly A33Ah with A27Ah. Ring
; interpretation requires each cursor aligned within A27A..A336. No validation or >= wrap; invalid cursors
; remain mechanically advanced. All general/segment registers preserved. Flags changed by final TEST/CMP;
; caller9BDF falls through9BE2, whose9CD9 ADD kills them before use. Trigger means requested input/adjustment,
; not proof that a coordinate changed.
; Evidence: metadata/symbols.json
; @09CF1 0000:9CF1 original=f606be980f
    test byte ptr ds:[098BEh], 0Fh
; @09CF6 0000:9CF6 original=7508
    JNE_SHORT loc_09D00
; @09CF8 0000:9CF8 original=833e60a300
    cmp word ptr ds:[0A360h], 0
; @09CFD 0000:9CFD original=7501
    JNE_SHORT loc_09D00
; @09CFF 0000:9CFF original=c3
    ret
; @09D00 0000:9D00 original=83063aa304
    add word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_PAIR_BYTES
; @09D05 0000:9D05 original=813e3aa33aa3
    cmp word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_END
; @09D0B 0000:9D0B original=7506
    JNE_SHORT loc_09D13
; @09D0D 0000:9D0D original=c7063aa37aa2
    mov word ptr ds:[HISTORY_WRITE_CURSOR], HISTORY_BEGIN
; @09D13 0000:9D13 original=83063ca304
    add word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_PAIR_BYTES
; @09D18 0000:9D18 original=813e3ca33aa3
    cmp word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_END
; @09D1E 0000:9D1E original=7506
    JNE_SHORT loc_09D26
; @09D20 0000:9D20 original=c7063ca37aa2
    mov word ptr ds:[HISTORY_READ_CURSOR_15], HISTORY_BEGIN
; @09D26 0000:9D26 original=83063ea304
    add word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_PAIR_BYTES
; @09D2B 0000:9D2B original=813e3ea33aa3
    cmp word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_END
; @09D31 0000:9D31 original=7506
    JNE_SHORT loc_09D39
; @09D33 0000:9D33 original=c7063ea37aa2
    mov word ptr ds:[HISTORY_READ_CURSOR_31], HISTORY_BEGIN
; @09D39 0000:9D39 original=830640a304
    add word ptr ds:[HISTORY_CURSOR_47], HISTORY_PAIR_BYTES
; @09D3E 0000:9D3E original=813e40a33aa3
    cmp word ptr ds:[HISTORY_CURSOR_47], HISTORY_END
; @09D44 0000:9D44 original=7506
    JNE_SHORT loc_09D4C
; @09D46 0000:9D46 original=c70640a37aa2
    mov word ptr ds:[HISTORY_CURSOR_47], HISTORY_BEGIN
; @09D4C 0000:9D4C original=c3
    ret
; sub_0000_9D4D
; @09D4D 0000:9D4D original=803e8e9700
    cmp byte ptr ds:[0978Eh], 0
; @09D52 0000:9D52 original=7407
    JE_SHORT loc_09D5B
; @09D54 0000:9D54 original=803ec89801
    cmp byte ptr ds:[098C8h], 1
; @09D59 0000:9D59 original=74f9
    JE_SHORT loc_09D54
; @09D5B 0000:9D5B original=ff06fa95
    inc word ptr ds:[095FAh]
; @09D5F 0000:9D5F original=8326fa9503
    and word ptr ds:[095FAh], 3
; @09D64 0000:9D64 original=e9b20e
    JMP_NEAR loc_0AC19
; @09D67 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 080h,03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Ch,083h,03Eh,05Ah,0A9h
; @09D77 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03h,074h,0Ah,0FFh,06h,05Ah,0A9h,055h,0E8h,040h,01h,05Dh,0C3h,083h,03Eh,05Ch
; @09D87 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 0A9h,018h,074h,0F3h,0FFh,06h,05Ch,0A9h,0EBh,0F3h,083h,03Eh,06Eh,0A9h,0FFh,074h
; @09D97 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,0C3h,0E8h,062h,0D7h,089h,01Eh,06Eh,0A9h,0C7h,07h,01h,00h,0C7h,047h,014h
; @09DA7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 01h,00h,0C7h,047h,016h,01h,00h,0C7h,047h,08h,0Fh,00h,0C7h,047h,020h,014h
; @09DB7 UNKNOWN bootstrap bytes: not reconstructed code/data
    db 00h,0C3h
; sub_0000_9DB9
; @09DB9 0000:9DB9 original=833e7aa958
    cmp word ptr ds:[0A97Ah], 058h
; @09DBE 0000:9DBE original=7501
    JNE_SHORT loc_09DC1
; @09DC0 0000:9DC0 original=c3
    ret
; @09DC1 0000:9DC1 original=833e7ca901
    cmp word ptr ds:[0A97Ch], 1
; @09DC6 0000:9DC6 original=7501
    JNE_SHORT loc_09DC9
; @09DC8 0000:9DC8 original=c3
    ret
; @09DC9 0000:9DC9 original=833e842303
    cmp word ptr ds:[02384h], 3
; @09DCE 0000:9DCE original=7319
    JAE_SHORT loc_09DE9
; @09DD0 0000:9DD0 original=c7067ca90100
    mov word ptr ds:[0A97Ch], 1
; @09DD6 0000:9DD6 original=833eacbd01
    cmp word ptr ds:[0BDACh], 1
; @09DDB 0000:9DDB original=740c
    JE_SHORT loc_09DE9
; @09DDD 0000:9DDD original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @09DE2 0000:9DE2 original=7405
    JE_SHORT loc_09DE9
; @09DE4 0000:9DE4 original=c606ffbe0d
    mov byte ptr ds:[0BEFFh], 0Dh
; @09DE9 0000:9DE9 original=c3
    ret
; @09DEA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 083h,03Eh,05Ch,0A9h,018h,075h,021h,083h,03Eh,05Ah,0A9h,03h,075h,01h,0C3h,080h
; @09DFA UNKNOWN bootstrap bytes: not reconstructed code/data
    db 03Eh,0C0h,098h,00h,074h,05h,0C6h,06h,0FFh,0BEh,01Ch,0FFh,06h,05Ah,0A9h,0C7h
; @09E0A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 06h,05Ch,0A9h,00h,00h,0E9h,0B0h,00h,0FFh,06h,05Ch,0A9h,0E9h,0A9h,00h
; sub_0000_9E19
; @09E19 0000:9E19 original=833e7ca401
    cmp word ptr ds:[0A47Ch], 1
; @09E1E 0000:9E1E original=7501
    JNE_SHORT loc_09E21
; @09E20 0000:9E20 original=c3
    ret
; @09E21 0000:9E21 original=833e842303
    cmp word ptr ds:[02384h], 3
; @09E26 0000:9E26 original=7201
    JB_SHORT loc_09E29
; @09E28 0000:9E28 original=c3
    ret
; @09E29 0000:9E29 original=833e5aa9ff
    cmp word ptr ds:[0A95Ah], -1
; @09E2E 0000:9E2E original=7501
    JNE_SHORT loc_09E31
; @09E30 0000:9E30 original=c3
    ret
; @09E31 0000:9E31 original=c706a0230800
    mov word ptr ds:[023A0h], 8
; @09E37 0000:9E37 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @09E3C 0000:9E3C original=7405
    JE_SHORT loc_09E43
; @09E3E 0000:9E3E original=c606ffbe0f
    mov byte ptr ds:[0BEFFh], 0Fh
; @09E43 0000:9E43 original=833edcbe00
    cmp word ptr ds:[0BEDCh], 0
; @09E48 0000:9E48 original=7413
    JE_SHORT loc_09E5D
; @09E4A 0000:9E4A original=833edcbe01
    cmp word ptr ds:[0BEDCh], 1
; @09E4F 0000:9E4F original=7406
    JE_SHORT loc_09E57
; @09E51 0000:9E51 original=ff0e5ca9
    dec word ptr ds:[0A95Ch]
; @09E55 0000:9E55 original=740c
    JE_SHORT loc_09E63
; @09E57 0000:9E57 original=ff0e5ca9
    dec word ptr ds:[0A95Ch]
; @09E5B 0000:9E5B original=7406
    JE_SHORT loc_09E63
; @09E5D 0000:9E5D original=ff0e5ca9
    dec word ptr ds:[0A95Ch]
; @09E61 0000:9E61 original=755f
    JNE_SHORT loc_09EC2
; @09E63 0000:9E63 original=c7065ca91800
    mov word ptr ds:[0A95Ch], 018h
; @09E69 0000:9E69 original=833e7ca401
    cmp word ptr ds:[0A47Ch], 1
; @09E6E 0000:9E6E original=7501
    JNE_SHORT loc_09E71
; @09E70 0000:9E70 original=c3
    ret
; @09E71 0000:9E71 original=833e842303
    cmp word ptr ds:[02384h], 3
; @09E76 0000:9E76 original=7201
    JB_SHORT loc_09E79
; @09E78 0000:9E78 original=c3
    ret
; @09E79 0000:9E79 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @09E7E 0000:9E7E original=7405
    JE_SHORT loc_09E85
; @09E80 0000:9E80 original=c606ffbe03
    mov byte ptr ds:[0BEFFh], 3
; @09E85 0000:9E85 original=833edcbe00
    cmp word ptr ds:[0BEDCh], 0
; @09E8A 0000:9E8A original=750c
    JNE_SHORT loc_09E98
; @09E8C 0000:9E8C original=fe0662a3
    inc byte ptr ds:[0A362h]
; @09E90 0000:9E90 original=802662a301
    and byte ptr ds:[0A362h], 1
; @09E95 0000:9E95 original=7401
    JE_SHORT loc_09E98
; @09E97 0000:9E97 original=c3
    ret
; @09E98 0000:9E98 original=ff0e5aa9
    dec word ptr ds:[0A95Ah]
; @09E9C 0000:9E9C original=833e5aa9ff
    cmp word ptr ds:[0A95Ah], -1
; @09EA1 0000:9EA1 original=751f
    JNE_SHORT loc_09EC2
; @09EA3 0000:9EA3 original=c7065ca90000
    mov word ptr ds:[0A95Ch], 0
; @09EA9 0000:9EA9 original=803e919701
    cmp byte ptr ds:[09791h], 1
; @09EAE 0000:9EAE original=7427
    JE_SHORT loc_09ED7
; @09EB0 0000:9EB0 original=c70684230300
    mov word ptr ds:[02384h], 3
; @09EB6 0000:9EB6 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @09EBB 0000:9EBB original=7405
    JE_SHORT loc_09EC2
; @09EBD 0000:9EBD original=c606ffbe19
    mov byte ptr ds:[0BEFFh], 019h
; @09EC2 0000:9EC2 original=e817c3
    CALL_NEAR loc_061DC
; @09EC5 0000:9EC5 original=2e833ebc9501
    cmp word ptr cs:[095BCh], 1
; @09ECB 0000:9ECB original=7509
    JNE_SHORT loc_09ED6
; @09ECD 0000:9ECD original=e84fb2
    CALL_NEAR loc_0511F
; @09ED0 0000:9ED0 original=e809c3
    CALL_NEAR loc_061DC
; @09ED3 0000:9ED3 original=e849b2
    CALL_NEAR loc_0511F
; @09ED6 0000:9ED6 original=c3
    ret
; @09ED7 0000:9ED7 original=c7065aa90300
    mov word ptr ds:[0A95Ah], 3
; @09EDD 0000:9EDD original=c7065ca91800
    mov word ptr ds:[0A95Ch], 018h
; @09EE3 0000:9EE3 original=c3
    ret
; sub_0000_9EE4
; @09EE4 0000:9EE4 original=833e7aa900
    cmp word ptr ds:[0A97Ah], 0
; @09EE9 0000:9EE9 original=7501
    JNE_SHORT loc_09EEC
; @09EEB 0000:9EEB original=c3
    ret
; @09EEC 0000:9EEC original=ff0e7aa9
    dec word ptr ds:[0A97Ah]
; @09EF0 0000:9EF0 original=7403
    JE_SHORT loc_09EF5
; @09EF2 0000:9EF2 original=e9ead8
    JMP_NEAR loc_077DF
; @09EF5 0000:9EF5 original=803e8c9701
    cmp byte ptr ds:[0978Ch], 1
; @09EFA 0000:9EFA original=7415
    JE_SHORT loc_09F11
; @09EFC 0000:9EFC original=c70684230300
    mov word ptr ds:[02384h], 3
; @09F02 0000:9F02 original=803ec09800
    cmp byte ptr ds:[098C0h], 0
; @09F07 0000:9F07 original=7405
    JE_SHORT loc_09F0E
; @09F09 0000:9F09 original=c606ffbe19
    mov byte ptr ds:[0BEFFh], 019h
; @09F0E 0000:9F0E original=e9ced8
    JMP_NEAR loc_077DF
; @09F11 0000:9F11 original=c7067aa95800
    mov word ptr ds:[0A97Ah], 058h
; @09F17 0000:9F17 original=e9c5d8
    JMP_NEAR loc_077DF
; @09F1A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 055h,0E8h,02h,00h,05Dh,0C3h,083h,03Eh,062h,0A9h,0FFh,075h,09h,0E8h,0D4h,0D5h
; @09F2A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,01Eh,062h,0A9h,0EBh,011h,083h,03Eh,064h,0A9h,0FFh,075h,09h,0E8h,0C4h,0D5h
; @09F3A UNKNOWN bootstrap bytes: not reconstructed code/data
    db 089h,01Eh,064h,0A9h,0EBh,01h,0C3h
; @09F41 0000:9F41 original=c7070100 runtime CFG evidence
    mov word ptr ds:[bx], 1
; @09F45 0000:9F45 original=c747140100 runtime CFG evidence
    mov word ptr ds:[bx + 014h], 1
; @09F4A 0000:9F4A original=c747160100 runtime CFG evidence
    mov word ptr ds:[bx + 016h], 1
; @09F4F 0000:9F4F original=c747081400 runtime CFG evidence
    mov word ptr ds:[bx + 8], 014h
; @09F54 0000:9F54 original=c747205000 runtime CFG evidence
    mov word ptr ds:[bx + 020h], 050h
; @09F59 0000:9F59 original=c7470a0100 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 1
; @09F5E 0000:9F5E original=c3 runtime CFG evidence
    ret
; @09F5F 0000:9F5F original=c70664a30200 runtime CFG evidence
    mov word ptr ds:[0A364h], 2
; @09F65 0000:9F65 original=bb66a9 runtime CFG evidence
    mov bx, 0A966h
; @09F68 0000:9F68 original=e81700 runtime CFG evidence
    CALL_NEAR loc_09F82
; @09F6B 0000:9F6B original=bb68a9 runtime CFG evidence
    mov bx, 0A968h
; @09F6E 0000:9F6E original=e81100 runtime CFG evidence
    CALL_NEAR loc_09F82
; @09F71 0000:9F71 original=740e runtime CFG evidence
    JE_SHORT loc_09F81
; @09F73 0000:9F73 original=bb6aa9 runtime CFG evidence
    mov bx, 0A96Ah
; @09F76 0000:9F76 original=e80900 runtime CFG evidence
    CALL_NEAR loc_09F82
; @09F79 0000:9F79 original=7406 runtime CFG evidence
    JE_SHORT loc_09F81
; @09F7B 0000:9F7B original=bb6ca9 runtime CFG evidence
    mov bx, 0A96Ch
; @09F7E 0000:9F7E original=e80100 runtime CFG evidence
    CALL_NEAR loc_09F82
; @09F81 0000:9F81 original=c3 runtime CFG evidence
    ret
; @09F82 0000:9F82 original=833fff runtime CFG evidence
    cmp word ptr ds:[bx], -1
; @09F85 0000:9F85 original=7401 runtime CFG evidence
    JE_SHORT loc_09F88
; @09F87 0000:9F87 original=c3 runtime CFG evidence
    ret
; @09F88 0000:9F88 original=891e66a3 runtime CFG evidence
    mov word ptr ds:[0A366h], bx
; @09F8C 0000:9F8C original=55 runtime CFG evidence
    push bp
; @09F8D 0000:9F8D original=bd7c23 runtime CFG evidence
    mov bp, 0237Ch
; @09F90 0000:9F90 original=e86bd5 runtime CFG evidence
    CALL_NEAR loc_074FE
; @09F93 0000:9F93 original=e8abff runtime CFG evidence
    CALL_NEAR loc_09F41
; @09F96 0000:9F96 original=c747081800 runtime CFG evidence
    mov word ptr ds:[bx + 8], 018h
; @09F9B 0000:9F9B original=c7470a0100 runtime CFG evidence
    mov word ptr ds:[bx + 0Ah], 1
; @09FA0 0000:9FA0 original=8b3e66a3 runtime CFG evidence
    mov di, word ptr ds:[0A366h]
; @09FA4 0000:9FA4 original=891d runtime CFG evidence
    mov word ptr ds:[di], bx
; @09FA6 0000:9FA6 original=e80600 runtime CFG evidence
    CALL_NEAR PlaceFourRecordsFromOffsetTables_09FAF
; @09FA9 0000:9FA9 original=5d runtime CFG evidence
    pop bp
; @09FAA 0000:9FAA original=ff0e64a3 runtime CFG evidence
    dec word ptr ds:[0A364h]
; @09FAE 0000:9FAE original=c3 runtime CFG evidence
    ret
; sub_0000_9FAF
; PlaceFourRecordsFromOffsetTables (modern reconstruction name)
; Closed near-entry cluster ending through shared9FEA leaf tail. Clear bytes DS:A39E/A39F. Set A398=A39A, apply
; PlaceRecordFromOffsetPair to slots A96C then A968 using tables A38C/A374. Set A398=A39C, apply to A96A then
; fall through for A966 using A380/A368. FFFF slots skipped. Clamp bytes aggregate whether any present record hit
; signed X clamp; they do not count records or report actual source movement. Preserve CX,DX,DI,BP and segments;
; AX,BX,SI scratch with path-dependent returns. No internal index bound; requires each selected table/index and
; record valid. Shared global A398 means non-reentrant without external protection.
; Evidence: metadata/symbols.json
; @09FAF 0000:9FAF original=c6069ea300
    mov byte ptr ds:[AUTO_XPLUS_A39E], 0
; @09FB4 0000:9FB4 original=c6069fa300
    mov byte ptr ds:[AUTO_XMINUS_A39F], 0
; @09FB9 0000:9FB9 original=a19aa3
    mov ax, word ptr ds:[OFFSET_X_GROUP_A]
; @09FBC 0000:9FBC original=a398a3
    mov word ptr ds:[OFFSET_X_WORK], ax
; @09FBF 0000:9FBF original=be8ca3
    mov si, OFFSET_TABLE_A38C
; @09FC2 0000:9FC2 original=8b1e6ca9
    mov bx, word ptr ds:[MINUS_SLOT_A96C]
; @09FC6 0000:9FC6 original=e82100
    CALL_NEAR PlaceRecordFromOffsetPair_09FEA
; @09FC9 0000:9FC9 original=be74a3
    mov si, OFFSET_TABLE_A374
; @09FCC 0000:9FCC original=8b1e68a9
    mov bx, word ptr ds:[MINUS_SLOT_A968]
; @09FD0 0000:9FD0 original=e81700
    CALL_NEAR PlaceRecordFromOffsetPair_09FEA
; @09FD3 0000:9FD3 original=a19ca3
    mov ax, word ptr ds:[OFFSET_X_GROUP_B]
; @09FD6 0000:9FD6 original=a398a3
    mov word ptr ds:[OFFSET_X_WORK], ax
; @09FD9 0000:9FD9 original=be80a3
    mov si, OFFSET_TABLE_A380
; @09FDC 0000:9FDC original=8b1e6aa9
    mov bx, word ptr ds:[PLUS_SLOT_A96A]
; @09FE0 0000:9FE0 original=e80700
    CALL_NEAR PlaceRecordFromOffsetPair_09FEA
; @09FE3 0000:9FE3 original=be68a3
    mov si, OFFSET_TABLE_A368
; @09FE6 0000:9FE6 original=8b1e66a9
    mov bx, word ptr ds:[PLUS_SLOT_A966]
; sub_0000_9FEA
; PlaceRecordFromOffsetPair (modern reconstruction name)
; Near callable leaf and fallthrough tail of9FAF. BX=FFFF returns unchanged registers, flags CMP(BX,FFFF).
; Otherwise with DF=0 select pair at DS:(SI+4*SS:[BP+8]) modulo65536. Store Y=pair.word0+SS:[BP+2] modulo65536
; to DS:[BX+2], then raw X=pair.word1+SS:[BP+4]+2*DS:A398 modulo65536 to DS:[BX+4]. Clamp signed raw X to0..192;
; set byte A39E on lower clamp, A39F on upper, never clear them. AX retains raw unclamped X; SI advances past
; pair; BX,CX,DX,DI,BP,segments preserved. Final flags compare post-lower-clamp X with192, before optional upper
; store. Requires valid index/pointers and nonaliasing for pair formula; actual sequential loads/stores remain
; authoritative.
; Evidence: metadata/symbols.json
; @09FEA 0000:9FEA original=83fbff
    cmp bx, -1
; @09FED 0000:9FED original=7501
    JNE_SHORT loc_09FF0
; @09FEF 0000:9FEF original=c3
    ret
; @09FF0 0000:9FF0 original=8b4608
    mov ax, word ptr ss:[bp + OFFSET_PAIR_INDEX_08]
; @09FF3 0000:9FF3 original=d1e0
    shl ax, 1
; @09FF5 0000:9FF5 original=d1e0
    shl ax, 1
; @09FF7 0000:9FF7 original=03f0
    add si, ax
; @09FF9 0000:9FF9 original=ad
    lodsw
; @09FFA 0000:9FFA original=034602
    add ax, word ptr ss:[bp + REC_Y]
; @09FFD 0000:9FFD original=894702
    mov word ptr ds:[bx + REC_Y], ax
part04 ends
end
