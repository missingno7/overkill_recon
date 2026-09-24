# Reviewed symbols

All names below are modern reconstruction names. Original symbol spellings are unknown.

## ReadBufferedWordLE (0000:0615)

Call ReadBufferedByte twice; first byte saved in DS:0614, second becomes AH and saved first becomes AL. Shares scratch and inherits nonlocal error unwind from callee.

Future C class: `ASM_COUPLED`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:0248.
Callees: 0000:0624.
Register access inventory (decoder-derived, not a proven ABI): read al, eip, esp, sp; write ah, al, esp, sp.

Evidence:
- Exact calls at 0615/061B and load order at 061E/0620.
- 0614 scratch makes the helper non-reentrant.

## ReadBufferedByte (0000:0624)

Save BX at DS:0612; cursor DS:0610. If cursor >=0610h, reset to0410h and request512 bytes via DOS AH=3F, handle DS:0240. Return byte in AL, advance cursor, restore BX. DOS failure branches to02B2 which restores SP from CS:0242. Short reads are not checked here.

Future C class: `ASM_COUPLED`. Confidence: `{"boundary": "INFERRED", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:0248, 0000:0615.
Callees: 0000:065C.
Register access inventory (decoder-derived, not a proven ABI): read ax, bx, cs, cx, eip, esp, flags, sp; write ah, al, ax, bx, cx, ds, dx, esp, flags, sp.

Evidence:
- Instruction-level buffer bounds and DOS call at 0639..064A.
- Error path is a shared nonlocal stack unwind; normal near-function classification would be unsafe.

## IncrementByteCS066B (0000:066C)

Increment byte CS:066B modulo 256; INC preserves incoming CF. Near return.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:06E5.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read cs, sp; write flags, sp.

Evidence:
- Called from the observed INT 08 handler 06E5.
- Counter name deliberately remains address-based.

## ClearByteCS066B (0000:0672)

Write zero to CS:066B. Registers and flags unchanged; near return.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:95C9, 0000:CF2E, 0000:D305, 0000:D390.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read cs, sp; write sp.

Evidence:
- One MOV followed by RET; shared with IncrementByteCS066B and WaitByteCS066B.

## WaitByteCS066B (0000:0679)

Poll CS:066B until nonzero. Requires asynchronous mutation to terminate from zero; near return leaves CMP flags.

Future C class: `ASM_COUPLED`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:95C9, 0000:CF2E, 0000:D305, 0000:D390.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read cs, flags, sp; write flags, sp.

Evidence:
- Backward JE targets entry at 0679.
- INT 08 path calls IncrementByteCS066B. Do not replace with a pure function.

## InstallTimerVector08 (0000:0682)

If DS:0052 !=1, save old INT08 vector at CS:0738, program PIT ports43h/40h with36h and divisor4000h, install CS:06E5 via DOS AH25, set DS:0052=1. Uses CLI/STI and changes registers.

Future C class: `HARDWARE`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:95C9.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read al, bx, cs, di, es, flags, sp; write al, ax, di, ds, dx, es, flags, sp.

Evidence:
- DOS3508 at068C and DOS2508 at06AE.
- Port writes and values visible at069C..06A6.

## Interrupt08Handler (0000:06E5)

Entry installed by InstallTimerVector08. Calls counter/music helpers and can chain a previous vector; inspect full CFG and unresolved far calls before changing it.

Future C class: `HARDWARE`. Confidence: `{"boundary": "PROVEN", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "STRONG", "semantic_name": "STRONG"}`.

Callers: .
Callees: 0000:066C, 0000:D50E, 1022:0000.
Register access inventory (decoder-derived, not a proven ABI): read al, ax, bp, bx, cs, cx, di, dx, eip, esp, flags, si; write al, ax, bp, bx, cx, di, ds, dx, es, esp, flags, si.

Evidence:
- DS explicitly set to CS immediately before INT21/2508 at06B1.

## BuildByteToNibbleMaskTable (0000:0FE4)

For each byte0..255 write four bytes to DS:1514+4*value, mapping bits7..0 to high/low nibble masks F/0 in order. Sets ES=CS:9596 but stores use DS, which caller must supply. Changes AL,DX,DI and flags; AH,BX,CX,SI,BP,DS unchanged; DI=1917h on return.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:95C9.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read al, cs, dh, di, dl, flags, sp; write al, dh, di, dl, es, flags, sp.

Evidence:
- 0FEE..1037 expands low pairs while storing backward inside each four-byte entry; DH iterates256 values.
- Tandy3153 reads this table to expand eight one-bit glyph pixels and ANDs with a repeated four-bit color.
- tests/test_tandy_adlib.py checks all256 entries with DS deliberately distinct from ES.

## CopyPackedRowsToTandyBanks (0000:306F)

Read row count then width-units from DS:SI (two words); copy width*4 bytes per row to ES loaded from CS:95A4. DF must be clear, row count positive, ranges valid/nonoverlapping. Bank step is +2000h; if bit15 set add80A0h modulo65536. AX/BP=width*4, CX=0; SI advances4+rows*width*4; DI advances to next row start; ES and flags changed, BX/DX/DS unchanged.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5A6C.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ax, bp, cs, cx, di, es, esp, flags, si, sp; write ax, bp, cx, di, es, esp, flags, si, sp.

Evidence:
- Selector2 at5A73/5A78 dispatches here; selector1 reaches24D7, which writes four plane masks1,2,4,8 via ports3C4/3C5.
- tests/test_tandy_adlib.py verifies full destination memory against (y%4)*8192+(y//4)*160 and no port writes.

## CopyPackedRowsStride104 (0000:3097)

Read DS:SI row count and width-units, then copy width*4 bytes per row to ES=CS:9598 with104-byte row stride. DF=0, positive rows, valid nonoverlapping ranges required. AX/BP=width*4,CX=0; SI advanced4+payload; DI advanced104*rows; BX/DX/DS unchanged, ES/flags changed.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5A48.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ax, bp, cs, cx, di, es, esp, flags, si, sp; write ax, bp, cx, di, es, esp, flags, si, sp.

Evidence:
- Selector2 at5A4F/5A54 dispatches here.
- Independent memory-layout test covers seven rows and nonzero destination offsets.

## CopyPackedRowsStride160 (0000:30B4)

As CopyPackedRowsStride104 but destination stride160. DS:SI header row count and width-units; width is multiplied by4; ES=CS:9598. Requires DF=0, positive row count, valid nonoverlapping ranges. AX/BP=width*4,CX=0; SI advances4+payload; DI advances160*rows; BX/DX/DS unchanged; ES/flags changed.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5A5A.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ax, bp, cs, cx, di, es, esp, flags, si, sp; write ax, bp, cx, di, es, esp, flags, si, sp.

Evidence:
- Selector2 at5A61/5A66 dispatches here.
- Independent full-memory copy test.

## TandyOffsetFromRow9EE8 (0000:3103)

AH indexes unsigned word table DS:9EE8 (2*AH); AL is multiplied by4. AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. All other registers unchanged; arithmetic flags from final ADD. No bounds check: initializer populates only200 entries.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5A00.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ah, ax, bh, bx, sp; write ah, ax, bh, bl, bx, di, flags, sp.

Evidence:
- Caller wrapper5A00 selects this for video selector2. EGA25B6 adds AL; CGA422B adds2*AL.
- 0F61..0FA1 initializes200 interleaved row offsets.
- Isolated tests include indices199,200,255 and16-bit addition wrap.

## TandyOffsetFromRow9BC8 (0000:3118)

AH indexes unsigned word table DS:9BC8 (2*AH); AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. Other registers preserved; final ADD flags. No bounds check.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5A12.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ah, ax, bh, bx, sp; write ah, ax, bh, bl, bx, di, flags, sp.

Evidence:
- Wrapper5A12 selects this for selector2; 0F41..0F4F populates200 entries using CS:959E stride.
- Isolated tests separate DS/SS and include word wrap.

## TandyOffsetFromRow9D58 (0000:312D)

AH indexes unsigned word table DS:9D58 (2*AH); AX=DI=(table[AH]+4*AL) mod65536; BX=table[AH]. Other registers preserved; final ADD flags. No bounds check.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5A24.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ah, ax, bh, bx, sp; write ah, ax, bh, bl, bx, di, flags, sp.

Evidence:
- Wrapper5A24 selects this for selector2; 0F51..0F5F populates200 entries using CS:95A0 stride.
- Isolated tests include full byte indices and word wrap.

## ClearTandy32K (0000:3345)

ES=CS:95A4; with DF=0 write32768 zero bytes at ES:0000..7FFF. AX=CX=0,DI=8000h; BX/DX/SI/BP/DS preserved. Flags from XOR DI,DI. Does not restore ES or set DF.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5BEE.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ax, cs, cx, di, es, flags, sp; write ax, cx, di, es, flags, sp.

Evidence:
- Wrapper5BEE dispatches selector2 to3345. REP STOSW count4000h.
- Test checks entire64KiB destination, including untouched upper half.

## CopyWorkspace104x192ToTandy (0000:3354)

Read source offset from incoming DS:234C; set ES=CS:95A4 and DS=CS:9598. With DF=0 copy192 contiguous104-byte source rows into the first104 bytes of Tandy rows4..195. Then set DS=CS:9596, not incoming DS. SI advances19968, DI=1EA0h, BX=34h, CX=BP=0; AX/DX preserved; flags changed. Requires valid nonoverlapping buffers.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5BDC.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read bp, bx, cs, cx, di, es, flags, si, sp; write bp, bx, cx, di, ds, es, flags, si, sp.

Evidence:
- Selector2 of wrapper5BDC targets3354.
- 3354 reads234C before changing DS;3383 assigns CS:9596 at exit.
- Isolated full-memory test distinguishes incoming DS, source DS and returned DS; untouched pixels and padding checked.

## ClearTandy104x200 (0000:3389)

With DF=0 and ES=CS:95A4, clear the first104 bytes of each of200 Tandy display rows. Preserve remaining56 visible bytes per row and bank padding. AX=CX=BP=0, DI=1F40h; ES changed; DS/BX/DX/SI preserved. Flags changed. No clipping or DF setup.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:5BCA.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ax, bp, cs, cx, di, es, flags, sp; write ax, bp, cx, di, es, flags, sp.

Evidence:
- Selector2 of wrapper5BCA targets3389.
- Whole64KiB destination test checks exact cleared footprint and untouched bytes.

## CopyWords2And4Plus10 (0000:A571)

First DS:[BX+4] = SS:[BP+4]+10 modulo 65536; then DS:[BX+2] = SS:[BP+2]+10. AX holds the latter result. Order matters if memory aliases. Flags are from the second ADD.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:A515, 0000:A584.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read ax, bp, bx, sp; write ax, flags, sp.

Evidence:
- The two loads use BP (default SS); stores use BX (default DS).
- Tests deliberately separate DS and SS.
- No coordinate, object-type or record-size claim yet.

## DecBP2Unless20 (0000:A5DB)

Decrement word SS:[BP+2] modulo 65536 unless it equals 0020h. This is NOT a saturating lower-bound clamp: values below 20h also decrement. CMP always overwrites CF; DEC preserves that CF.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:A5D1.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read bp, flags, sp; write flags, sp.

Evidence:
- A5DB compares equality, A5E2 decrements only on not-equal.
- Boundary and wraparound tests use SS distinct from DS.

## IncBP2UnlessC0 (0000:A5ED)

Increment word SS:[BP+2] modulo 65536 unless it equals 00C0h; values above C0h also increment.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:A5EA.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read bp, flags, sp; write flags, sp.

Evidence:
- Equality comparison A5ED, INC A5F5.
- Boundary and wraparound tests.

## DecBP4UnlessZero (0000:A5FC)

Decrement unsigned word SS:[BP+4] unless zero; register state preserved, flags changed by CMP/DEC.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:A5F9.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read bp, flags, sp; write flags, sp.

Evidence:
- CMP A5FC, conditional RET A602, DEC A603.
- Boundary and wraparound tests.

## IncBP4BelowB0 (0000:A60A)

Increment unsigned word SS:[BP+4] iff below 00B0h; values at or above B0h remain unchanged.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:A607.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read bp, flags, sp; write flags, sp.

Evidence:
- JB at A60F proves unsigned comparison.
- Boundary tests include 7FFFh, 8000h and FFFFh.

## UppercaseAsciiAL (0000:C7FE)

AL in 61h..7Ah becomes AL & DFh; all other values unchanged. AH and other registers preserved. Flags reflect the final CMP or AND, not a stable boolean ABI. Near RET.

Future C class: `C_READY`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:C80B, 0000:C85B.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read al, flags, sp; write al, flags, sp.

Evidence:
- Unsigned lower/upper bound tests at C7FE/C803; AND at C808.
- All 256 inputs checked against the operation in tests/test_semantics.py.
- Callers C80B and C85B; caller/callee report retains their unresolved roles.

## AdvanceABColonPrefix (0000:C80B)

Read pointer DS:21AA. If byte +1 is colon and ASCII-case-folded byte +0 is A or B, retain it only when DS:BB86 (A) or DS:BB87 (B) equals exactly1; otherwise increment original byte +0 and retry. Case of stored prefix is preserved. Other prefixes return unchanged. Flags and AL/SI are scratch.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:C679.
Callees: 0000:C7FE.
Register access inventory (decoder-derived, not a proven ABI): read al, eip, esp, flags, si, sp; write al, esp, flags, si, sp.

Evidence:
- Meaning of UppercaseAsciiAL independently established first.
- C80F tests colon; C81B/C81F compare A/B; C824/C830 compare flags exactly1.
- Tests combine uppercase/lowercase prefixes with flag values0,1,2; no role is assigned to the flags.

## XorCopy16BytesAA (0000:C9D3)

Sixteen iterations XOR source DS:[SI] with AAh in place, then MOVSB to ES:[DI]. DF controls both pointer directions. CX becomes zero; AL unchanged. Source also changes, and aliasing is observable.

Future C class: `C_READY_WITH_ENV`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:C8BD.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read cx, di, es, flags, si, sp; write cx, di, flags, si, sp.

Evidence:
- C9D3 sets CX=16, C9D6 XORs before MOVSB, LOOP repeats.
- Tests cover DF=0/1 and distinct source/destination.

## LowercaseAsciiAL (0000:CA5B)

AL in 41h..5Ah becomes AL | 20h; all other values unchanged. AH and other registers preserved. Flags reflect final CMP or OR. Near RET.

Future C class: `C_READY`. Confidence: `{"boundary": "STRONG", "calling_convention": "STRONG", "gameplay_role": "UNKNOWN", "operation": "PROVEN", "semantic_name": "STRONG"}`.

Callers: 0000:CA98.
Callees: .
Register access inventory (decoder-derived, not a proven ABI): read al, flags, sp; write al, flags, sp.

Evidence:
- Unsigned bounds at CA5B/CA60; OR at CA65.
- All 256 inputs checked in tests/test_semantics.py.
