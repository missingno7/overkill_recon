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
    write_json(ROOT/'metadata/symbols.json',dict(schema=1,symbols=rows))
    print('Recorded',len(rows),'reviewed symbols.')
if __name__=='__main__':main()
