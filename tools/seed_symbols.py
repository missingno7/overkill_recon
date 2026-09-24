"""Reviewed semantic facts. Names describe operations, not unproven game roles."""
from common import *

def main():
    rows=[]
    def add(addr,name,category,contract,evidence,operation='PROVEN',boundary='STRONG'):
        rows.append(dict(address=addr,name=name,kind='function',category=category,contract=contract,
            confidence=dict(boundary=boundary,calling_convention='STRONG',operation=operation,semantic_name='STRONG',gameplay_role='UNKNOWN'),
            evidence=evidence,claim_axes=dict(BYTE_EXACT='verified by full-image build',SEMANTICALLY_SUPPORTED=True,STRUCTURALLY_SUPPORTED=False,HISTORICALLY_PROVEN=False)))
    add('0000:C7FE','UppercaseAsciiAL','C_READY',
        'AL in 61h..7Ah becomes AL & DFh; all other values unchanged. AH and other registers preserved. Flags reflect the final CMP or AND, not a stable boolean ABI. Near RET.',
        ['Unsigned lower/upper bound tests at C7FE/C803; AND at C808.','All 256 inputs checked against the operation in tests/test_semantics.py.','Callers C80B and C85B; caller/callee report retains their unresolved roles.'])
    add('0000:CA5B','LowercaseAsciiAL','C_READY',
        'AL in 41h..5Ah becomes AL | 20h; all other values unchanged. AH and other registers preserved. Flags reflect final CMP or OR. Near RET.',
        ['Unsigned bounds at CA5B/CA60; OR at CA65.','All 256 inputs checked in tests/test_semantics.py.'])
    add('0000:A5DB','DecBP2Unless20','C_READY_WITH_ENV',
        'Decrement word SS:[BP+2] modulo 65536 unless it equals 0020h. This is NOT a saturating lower-bound clamp: values below 20h also decrement. CMP always overwrites CF; DEC preserves that CF.',
        ['A5DB compares equality, A5E2 decrements only on not-equal.','Boundary and wraparound tests use SS distinct from DS.'])
    add('0000:A5ED','IncBP2UnlessC0','C_READY_WITH_ENV',
        'Increment word SS:[BP+2] modulo 65536 unless it equals 00C0h; values above C0h also increment.',
        ['Equality comparison A5ED, INC A5F5.','Boundary and wraparound tests.'])
    add('0000:A5FC','DecBP4UnlessZero','C_READY_WITH_ENV',
        'Decrement unsigned word SS:[BP+4] unless zero; register state preserved, flags changed by CMP/DEC.',
        ['CMP A5FC, conditional RET A602, DEC A603.','Boundary and wraparound tests.'])
    add('0000:A60A','IncBP4BelowB0','C_READY_WITH_ENV',
        'Increment unsigned word SS:[BP+4] iff below 00B0h; values at or above B0h remain unchanged.',
        ['JB at A60F proves unsigned comparison.','Boundary tests include 7FFFh, 8000h and FFFFh.'])
    add('0000:A571','CopyWords2And4Plus10','C_READY_WITH_ENV',
        'First DS:[BX+4] = SS:[BP+4]+10 modulo 65536; then DS:[BX+2] = SS:[BP+2]+10. AX holds the latter result. Order matters if memory aliases. Flags are from the second ADD.',
        ['The two loads use BP (default SS); stores use BX (default DS).','Tests deliberately separate DS and SS.','No coordinate, object-type or record-size claim yet.'])
    add('0000:066C','IncrementByteCS066B','C_READY_WITH_ENV',
        'Increment byte CS:066B modulo 256; INC preserves incoming CF. Near return.',
        ['Called from the observed INT 08 handler 06E5.','Counter name deliberately remains address-based.'])
    add('0000:0672','ClearByteCS066B','C_READY_WITH_ENV',
        'Write zero to CS:066B. Registers and flags unchanged; near return.',
        ['One MOV followed by RET; shared with IncrementByteCS066B and WaitByteCS066B.'])
    add('0000:0679','WaitByteCS066B','ASM_COUPLED',
        'Poll CS:066B until nonzero. Requires asynchronous mutation to terminate from zero; near return leaves CMP flags.',
        ['Backward JE targets entry at 0679.','INT 08 path calls IncrementByteCS066B. Do not replace with a pure function.'])
    add('0000:0615','ReadBufferedWordLE','ASM_COUPLED',
        'Call ReadBufferedByte twice; first byte saved in DS:0614, second becomes AH and saved first becomes AL. Shares scratch and inherits nonlocal error unwind from callee.',
        ['Exact calls at 0615/061B and load order at 061E/0620.','0614 scratch makes the helper non-reentrant.'])
    add('0000:0624','ReadBufferedByte','ASM_COUPLED',
        'Save BX at DS:0612; cursor DS:0610. If cursor >=0610h, reset to0410h and request512 bytes via DOS AH=3F, handle DS:0240. Return byte in AL, advance cursor, restore BX. DOS failure branches to02B2 which restores SP from CS:0242. Short reads are not checked here.',
        ['Instruction-level buffer bounds and DOS call at 0639..064A.','Error path is a shared nonlocal stack unwind; normal near-function classification would be unsafe.'],boundary='INFERRED')
    add('0000:C9D3','XorCopy16BytesAA','C_READY_WITH_ENV',
        'Sixteen iterations XOR source DS:[SI] with AAh in place, then MOVSB to ES:[DI]. DF controls both pointer directions. CX becomes zero; AL unchanged. Source also changes, and aliasing is observable.',
        ['C9D3 sets CX=16, C9D6 XORs before MOVSB, LOOP repeats.','Tests cover DF=0/1 and distinct source/destination.'])
    add('0000:0682','InstallTimerVector08','HARDWARE',
        'If DS:0052 !=1, save old INT08 vector at CS:0738, program PIT ports43h/40h with36h and divisor4000h, install CS:06E5 via DOS AH25, set DS:0052=1. Uses CLI/STI and changes registers.',
        ['DOS3508 at068C and DOS2508 at06AE.','Port writes and values visible at069C..06A6.'])
    add('0000:06E5','Interrupt08Handler','HARDWARE',
        'Entry installed by InstallTimerVector08. Calls counter/music helpers and can chain a previous vector; inspect full CFG and unresolved far calls before changing it.',
        ['DS explicitly set to CS immediately before INT21/2508 at06B1.'],operation='STRONG',boundary='PROVEN')
    add('0000:C80B','AdvanceABColonPrefix','C_READY_WITH_ENV',
        'Read pointer DS:21AA. If byte +1 is colon and ASCII-case-folded byte +0 is A or B, retain it only when DS:BB86 (A) or DS:BB87 (B) equals exactly1; otherwise increment original byte +0 and retry. Case of stored prefix is preserved. Other prefixes return unchanged. Flags and AL/SI are scratch.',
        ['Meaning of UppercaseAsciiAL independently established first.','C80F tests colon; C81B/C81F compare A/B; C824/C830 compare flags exactly1.','Tests combine uppercase/lowercase prefixes with flag values0,1,2; no role is assigned to the flags.'])
    add('0000:306F','CopyPackedRowsToTandyBanks',"C_READY_WITH_ENV",
        'Read row count then width-units from DS:SI (two words); copy width*4 bytes per row to ES loaded from CS:95A4. DF must be clear, row count positive, ranges valid/nonoverlapping. Bank step is +2000h; if bit15 set add80A0h modulo65536. AX/BP=width*4, CX=0; SI advances4+rows*width*4; DI advances to next row start; ES and flags changed, BX/DX/DS unchanged.',
        ['Selector2 at5A73/5A78 dispatches here; selector1 reaches24D7, which writes four plane masks1,2,4,8 via ports3C4/3C5.', 'tests/test_tandy_adlib.py verifies full destination memory against (y%4)*8192+(y//4)*160 and no port writes.'])
    add('0000:3097','CopyPackedRowsStride104',"C_READY_WITH_ENV",
        'Read DS:SI row count and width-units, then copy width*4 bytes per row to ES=CS:9598 with104-byte row stride. DF=0, positive rows, valid nonoverlapping ranges required. AX/BP=width*4,CX=0; SI advanced4+payload; DI advanced104*rows; BX/DX/DS unchanged, ES/flags changed.',
        ['Selector2 at5A4F/5A54 dispatches here.', 'Independent memory-layout test covers seven rows and nonzero destination offsets.'])
    add('0000:30B4','CopyPackedRowsStride160',"C_READY_WITH_ENV",
        'As CopyPackedRowsStride104 but destination stride160. DS:SI header row count and width-units; width is multiplied by4; ES=CS:9598. Requires DF=0, positive row count, valid nonoverlapping ranges. AX/BP=width*4,CX=0; SI advances4+payload; DI advances160*rows; BX/DX/DS unchanged; ES/flags changed.',
        ['Selector2 at5A61/5A66 dispatches here.', 'Independent full-memory copy test.'])
    add('0000:3103','TandyOffsetFromRow9EE8',"C_READY_WITH_ENV",
        'AH indexes unsigned word table DS:9EE8 (2*AH); AL is multiplied by4. AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. All other registers unchanged; arithmetic flags from final ADD. No bounds check: initializer populates only200 entries.',
        ['Caller wrapper5A00 selects this for video selector2. EGA25B6 adds AL; CGA422B adds2*AL.', '0F61..0FA1 initializes200 interleaved row offsets.', 'Isolated tests include indices199,200,255 and16-bit addition wrap.'])
    add('0000:3118','TandyOffsetFromRow9BC8',"C_READY_WITH_ENV",
        'AH indexes unsigned word table DS:9BC8 (2*AH); AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. Other registers preserved; final ADD flags. No bounds check.',
        ['Wrapper5A12 selects this for selector2; 0F41..0F4F populates200 entries using CS:959E stride.', 'Isolated tests separate DS/SS and include word wrap.'])
    add('0000:312D','TandyOffsetFromRow9D58',"C_READY_WITH_ENV",
        'AH indexes unsigned word table DS:9D58 (2*AH); AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. Other registers preserved; final ADD flags. No bounds check.',
        ['Wrapper5A24 selects this for selector2; 0F51..0F5F populates200 entries using CS:95A0 stride.', 'Isolated tests include full byte indices and word wrap.'])
    add('0000:3345','ClearTandy32K',"C_READY_WITH_ENV",
        'ES=CS:95A4; with DF=0 write32768 zero bytes at ES:0000..7FFF. AX=CX=0,DI=8000h; BX/DX/SI/BP/DS preserved. Flags from XOR DI,DI. Does not restore ES or set DF.',
        ['Wrapper5BEE dispatches selector2 to3345. REP STOSW count4000h.', 'Test checks entire64KiB destination, including untouched upper half.'])
    add('0000:0FE4','BuildByteToNibbleMaskTable','C_READY_WITH_ENV',
        'For each byte0..255 write four bytes to DS:1514+4*value, mapping bits7..0 to high/low nibble masks F/0 in order. Sets ES=CS:9596 but stores use DS, which caller must supply. Changes AL,DX,DI and flags; AH,BX,CX,SI,BP,DS unchanged; DI=1917h on return.',
        ['0FEE..1037 expands low pairs while storing backward inside each four-byte entry; DH iterates256 values.', 'Tandy3153 reads this table to expand eight one-bit glyph pixels and ANDs with a repeated four-bit color.', 'tests/test_tandy_adlib.py checks all256 entries with DS deliberately distinct from ES.'])
    add('0000:3354','CopyWorkspace104x192ToTandy','C_READY_WITH_ENV',
        'Read source offset from incoming DS:234C; set ES=CS:95A4 and DS=CS:9598. With DF=0 copy192 contiguous104-byte source rows into the first104 bytes of Tandy rows4..195. Then set DS=CS:9596, not incoming DS. SI advances19968, DI=1EA0h, BX=34h, CX=BP=0; AX/DX preserved; flags changed. Requires valid nonoverlapping buffers.',
        ['Selector2 of wrapper5BDC targets3354.', '3354 reads234C before changing DS;3383 assigns CS:9596 at exit.', 'Isolated full-memory test distinguishes incoming DS, source DS and returned DS; untouched pixels and padding checked.'])
    add('0000:3389','ClearTandy104x200','C_READY_WITH_ENV',
        'With DF=0 and ES=CS:95A4, clear the first104 bytes of each of200 Tandy display rows. Preserve remaining56 visible bytes per row and bank padding. AX=CX=BP=0, DI=1F40h; ES changed; DS/BX/DX/SI preserved. Flags changed. No clipping or DF setup.',
        ['Selector2 of wrapper5BCA targets3389.', 'Whole64KiB destination test checks exact cleared footprint and untouched bytes.'])
    add('0000:7524','FindFreeRecordPoolA','C_READY_WITH_ENV',
        'Near leaf. DS:95D8 supplies the first candidate. Inspect at most35 status words at stride38h in23B4..2B5B, wrapping BX after increment equals2B5C. Return BX=first zero-status record, CX=35-skipped; save BX to DS:95D8 without activating record. Full pool returns BX=FFFF,CX=0 and leaves cursor unchanged. Requires aligned in-pool cursor; unlike poolB, end cursor is not normalized before first read. AX,DX,SI,DI,BP,segments preserved; flags changed.',
        ['752B checks only word+0;7542 writes only cursor. Callers7429 andA6D3 activate selected records separately.', 'tests/test_records.py covers every valid cursor/free-slot pair, full pools and invalid end-cursor distinction.', 'Several call sites compare BX withFFFF; C450 andD1AE use BX without checking failure, so caller capacity preconditions remain open.'])
    add('0000:7573','FindFreeRecordPoolB','C_READY_WITH_ENV',
        'Near leaf. DS:95DA supplies cursor. Normalize BX==32CCh to2B5Ch before reading; inspect at most34 zero-status records at stride38h. Success returns BX and CX=34-skipped and saves cursor; failure BX=FFFF,CX=0 leaves cursor unchanged. Accept aligned pool cursor or exact end32CC; other pointers not validated. Does not activate or clear records. AX,DX,SI,DI,BP,segments preserved; flags changed.',
        ['757A wraps before reading, unlike7524;7591 only saves cursor.', 'tests/test_records.py exhausts cursor/free-slot positions and failure cases.', '7476 andC237 explicitly compare BX before writing selected records.'])
    add('0000:A5D1','DecRecordYByMode','ASM_COUPLED',
        'DS:A47C==0: apply DecBP2Unless20 twice via CALL into next instruction then fallthrough re-entry. Otherwise decrement SS:[BP+2] once modulo65536 without boundary guard. Near return; registers/segments preserved; flags changed, IF/DF preserved. Mode-zero y21h becomes20h, not1Fh. Nested call consumes two stack bytes temporarily.',
        ['9B76 calls after input bit8; BP=237C from9B5B.', 'Tests cover guard crossing, wrap, separate DS/SS and nonzero mode bypass.'])
    add('0000:A5EA','IncRecordYTwice','ASM_COUPLED',
        'Call IncBP2UnlessC0, then fall through into it again. Two equality-guarded increments of SS:[BP+2]; BFh becomesC0h, values aboveC0h still increment modulo65536. Registers/segments preserved; flags changed, IF/DF preserved; normal outer near return.',
        ['A5EA CALL has displacement0: callee starts at the pushed return IP.', '9B80 caller overwrites flags with next input TEST.', 'tests/test_records.py proves two-step boundary/wrap behavior.'])
    add('0000:A5F9','DecRecordXTwice','ASM_COUPLED',
        'Call DecBP4UnlessZero then fall through into it again; SS:[BP+4]=max(original-2,0) for unsigned word. Registers/segments preserved; flags changed, IF/DF preserved. Outer near return; inner call/return must remain in ASM.',
        ['A5F9 CALL displacement0;9B94 and9C2C call sites.', 'Caller9C2C writes A360 then XOR AX overwrites flags.', 'Isolated tests include0,1,2 andFFFF.'])
    add('0000:A607','IncRecordXTwice','ASM_COUPLED',
        'Call IncBP4BelowB0 then fall through into it again. Unsigned SS:[BP+4] increases up toB0h if initially below it; values>=B0h unchanged. General/segment registers preserved; flags changed, IF/DF preserved; outer near return.',
        ['A607 CALL displacement0;9B8A and9C15 callers.', 'Tests distinguish AFh->B0h from unguarded+2.'])
    add('0000:9C01','AdjustRecordXFromCounts','ASM_COUPLED',
        'Near entry; DS holds input/state, SS:BP the record. Clear DS:A360. If bit2 of DS:98BE absent and byte A39E==1, apply IncRecordXTwice and set A360=1. Then if bit1 absent and A39F==1, apply DecRecordXTwice and set A360=1. AH counts words A966/A96A notFFFF; AL counts A968/A96C notFFFF. If counts equal, return via shared44AF RET. Otherwise, if count difference magnitude2 or DS:2324!=1, set A360=1 and tail to one-step X increment for AH>AL, decrement otherwise. FlagA360 records taking an adjustment path even if bound prevents movement. Return AX=(AHcount<<8)|ALcount,BX=2*(ALcount+3*AHcount); CX,DX,SI,DI,BP and segments preserved. Flags are path-dependent; caller9BDF ignores them before overwrite in9CF1. Assumes normal entry and no asynchronous register corruption.',
        ['9C35 clears AX;9BFB/9BFE increment AH/AL; each called at most twice. Thus table9C70 has exactly9 entries.', '9C82/9C9C gate magnitude1 with2324;9C93/9CAD handle magnitude2 unconditionally.', 'tests/test_records.py covers all16 sentinel combinations, input auto-step order, three gate values, bound cases and unchanged DS alias.'])
    add('0000:99BF','InitPositionHistory','C_READY_WITH_ENV',
        'Near leaf. Set ES=CS:9596, BP=237Ch. With DF=0 fill48 four-byte pairs at ES:A27A with (SS:[237E]+8, SS:[2380]+9), modulo65536. Then DS:A33A/A33C/A33E/A340 become A27A/A2FE/A2BE/A27E. CX=0,DI=A33A,AX=last X+9; BX,DX,SI,DS,SS preserved. Flags from final ADD. Requires valid buffers and source not overwritten by destination for uniform-fill interpretation; loads repeat each iteration. Unlike later writes, initial X bias is9, not8.',
        ['99BF..99F5; callers9783/CFD8 initialize before record-update use.', 'Startup95D3 clears DF;95D5/95DA set DS/SS from CS9596. These are local preconditions, not an all-path segment/DF proof.', 'tests/test_history.py checks whole buffers, distinct segments, word wrap and cursor initialization.'])
    add('0000:9CD9','StorePositionHistory','C_READY_WITH_ENV',
        'Near leaf. ES=CS:9596, DI=DS:A33A; with DF=0 store SS:[BP+2]+8 then SS:[BP+4]+8 to ES:DI/DI+2, modulo65536. DI advances4; AX holds X+8, flags from final ADD. BX,CX,DX,SI,BP,DS,SS preserved. Does not move the ring cursor. Assumes valid nonoverlapping record/history for pair semantics; the second source load occurs after the first store. DF is preserved, not cleared.',
        ['9BE2 calls this before A031; incoming AX/DI/ES from9CF1 are dead here.', '99BF seeds the same pair format with a distinct X+9 bias.', 'tests/test_history.py separates DS,SS,ES and checks DF direction and alias-order behavior.'])
    add('0000:9CF1','AdvancePositionHistoryIfRequested','C_READY_WITH_ENV',
        'Near leaf. If low nibble of DS:98BE is zero and word DS:A360 is zero, return without writes. Otherwise advance each of four word cursors DS:A33A/A33C/A33E/A340 by4 modulo65536, replacing exactly A33Ah with A27Ah. Ring interpretation requires each cursor aligned within A27A..A336. No validation or >= wrap; invalid cursors remain mechanically advanced. All general/segment registers preserved. Flags changed by final TEST/CMP; caller9BDF falls through9BE2, whose9CD9 ADD kills them before use. Trigger means requested input/adjustment, not proof that a coordinate changed.',
        ['99BF supplies all four valid initial cursors; advancing preserves their relative phases.', 'A360 is set by9C01 even when a bound prevents movement.', 'tests/test_history.py exhausts each valid ring position and input nibble, and checks invalid cursor/wrap distinctions.'])
    add('0000:A031','ApplyPositionHistoryToRecords','C_READY_WITH_ENV',
        'Near leaf. If DS:A962 !=FFFF, copy two sequential words from DS:[DS:A33C] to record DS:[DS:A962]+2/+4. Then independently do the same for A964/A33E. With DF=0 these are Y/X pairs and SI advances4 after the last copy; AX=last X,BX=last destination. If neither slot exists AX/BX/SI unchanged. Flags are always CMP(A964,FFFF), even on copy; caller9BE8 overwrites them. CX,DX,DI,BP and segments preserved. Requires valid selected pointers; pair abstraction assumes destinations do not alias cursors/slots/source. Actual load/store order remains significant; no activation/type checks.',
        ['9BE5 follows StorePositionHistory; initialized read cursors lag write cursor by15 and31 entries modulo48.', 'tests/test_history.py checks absent/present slots, coincident destinations, sequential aliasing and whole data-segment footprint.', 'Record entity roles and fourth-cursor consumer remain unknown.'])
    add('0000:9FEA','PlaceRecordFromOffsetPair','C_READY_WITH_ENV',
        'Near callable leaf and fallthrough tail of9FAF. BX=FFFF returns unchanged registers, flags CMP(BX,FFFF). Otherwise with DF=0 select pair at DS:(SI+4*SS:[BP+8]) modulo65536. Store Y=pair.word0+SS:[BP+2] modulo65536 to DS:[BX+2], then raw X=pair.word1+SS:[BP+4]+2*DS:A398 modulo65536 to DS:[BX+4]. Clamp signed raw X to0..192; set byte A39E on lower clamp, A39F on upper, never clear them. AX retains raw unclamped X; SI advances past pair; BX,CX,DX,DI,BP,segments preserved. Final flags compare post-lower-clamp X with192, before optional upper store. Requires valid index/pointers and nonaliasing for pair formula; actual sequential loads/stores remain authoritative.',
        ['9FF0 reads offset index at+8;A00F/A024 use signed JGE/JLE, unlike unsigned movement bounds.', '9FAF supplies four bases12 bytes apart but does not bound index: do not silently restrict all callers to0..2.', 'tests/test_history.py checks signed clamp boundaries, wraparound, absent BX and preserved stale clamp flags.'])
    add('0000:9FAF','PlaceFourRecordsFromOffsetTables','ASM_COUPLED',
        'Closed near-entry cluster ending through shared9FEA leaf tail. Clear bytes DS:A39E/A39F. Set A398=A39A, apply PlaceRecordFromOffsetPair to slots A96C then A968 using tables A38C/A374. Set A398=A39C, apply to A96A then fall through for A966 using A380/A368. FFFF slots skipped. Clamp bytes aggregate whether any present record hit signed X clamp; they do not count records or report actual source movement. Preserve CX,DX,DI,BP and segments; AX,BX,SI scratch with path-dependent returns. No internal index bound; requires each selected table/index and record valid. Shared global A398 means non-reentrant without external protection.',
        ['9BE2 optionally runs this after the history copy.9C01 consumes A39E/A39F before the next9BE2 update, feeding clamp state back into primary-record adjustment.', 'Source order is A96C,A968,A96A,A966; exact CALL/CALL/CALL/fallthrough retained.', 'tests/test_history.py checks all16 slot-presence combinations, shared destination overwrite order and aggregate flags.'])
    platform_addresses=['0000:306F', '0000:3097', '0000:30B4', '0000:3103', '0000:3118', '0000:312D', '0000:3345', '0000:0FE4', '0000:3354', '0000:3389', '0000:0682', '0000:06E5', '0000:0615', '0000:0624']
    game_addresses=['0000:A5DB', '0000:A5ED', '0000:A5FC', '0000:A60A', '0000:A571', '0000:7524', '0000:7573', '0000:A5D1', '0000:A5EA', '0000:A5F9', '0000:A607', '0000:9C01']
    game_addresses += ['0000:99BF','0000:9CD9','0000:9CF1','0000:A031']
    game_addresses += ['0000:9FEA','0000:9FAF']
    for row in rows:
        row['concern']='PLATFORM_LOGIC' if row['address'] in platform_addresses else ('GAME_LOGIC' if row['address'] in game_addresses else 'UNKNOWN')
        row['concern_evidence']='Reviewed hardware/buffer operation' if row['concern']=='PLATFORM_LOGIC' else ('Record operations consumed by input/update/render callers; see metadata/record-movement.json' if row['concern']=='GAME_LOGIC' else 'Role not reviewed in this classification')
    write_json(ROOT/'metadata/symbols.json',dict(schema=1,symbols=rows))
    print('Recorded',len(rows),'reviewed symbols.')
if __name__=='__main__':main()
