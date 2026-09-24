# Tandy + AdLib: static reconstruction focus

Tandy/PCjr + AdLib/OPL2 is the selected reconstruction priority. Other original
renderers and sound/input paths remain present. This is a modern research choice,
not evidence about the authors' preferred development hardware.

## Pixel storage and address layout

The game's own instructions support the user's reason for preferring Tandy:
its reviewed display copy path handles packed pixels with ordinary memory copies,
whereas the corresponding EGA path explicitly selects and copies four planes.
No new whole-game execution was needed to establish this.

- `0FE4` builds 256 four-byte entries at **DS:1514..1913**. Each original bit
  becomes a nibble of F or 0, with bit7 in the first high nibble and bit0 in the
  last low nibble. The routine sets ES but the actual stores use DS. An isolated
  test checks all entries while deliberately giving DS and ES different values.
- `3153` reads those masks and ANDs them with a color repeated into both nibbles
  of each byte (`3180..3190`). This supports two four-bit pixels per byte.
  The full routine, including special input values16/17, is not yet named.
- `306F` consumes a two-word header: row count and width in four-byte units.
  Each row is copied with REP MOVSB, with no port operations in this routine.
  It advances between four banks by2000h, wrapping after bank3 and adding160
  bytes to the within-bank row offset.

For valid display rows the address formula is:

    row_offset(y) = (y % 4) * 8192 + (y // 4) * 160
    pixel_byte_offset = row_offset(y) + floor(x / 2)

The generic address helper uses an eight-pixel-group index rather than x in
pixels: `3103` returns `DS:9EE8[AH] + 4*AL` in AX and DI. The table initializer
`0F61..0FA1` writes 200 banked row offsets. Related helpers `3118` and `312D`
use DS:9BC8 and DS:9D58, whose initializers use strides CS:959E and CS:95A0.
The selected Tandy geometry supplies104 and160 respectively, with B800h as
CS:95A4. These are distinct workspace/display layouts; they must not be collapsed
into one universal row pitch.

There are **no bounds checks** in those three address helpers. AH200..255 still
indexes memory, even though the initializers only populate200 entries. The copy
routines require DF clear and positive row counts; zero row counts do not mean
an empty copy because of the LOOP structure. Valid, nonoverlapping buffer ranges
are caller obligations, not newly invented checks in the ASM.

The EGA counterpart `24D7` selects index2 at port3C4 and writes masks1,2,4,8 at
3C5 while copying each plane. It restores mask0F, not the incoming mask. Its
horizontal address helper `25B6` scales AL by1; CGA `422B` scales by2; Tandy
`3103` scales by4. This comparison supports a simpler packed-memory model for
these Tandy routines. It does not prove identical palettes or rendered frames.

## Reviewed leaves and immediate callers

All names below are modern reconstruction names. The exact source, register and
memory contracts, callers, confidence and future-C categories are retained in
`metadata/symbols.json`, `metadata/drivers/symbols.json`, and active graph reports.

| Address | Name | Evidence boundary |
|---|---|---|
| main0FE4 | BuildByteToNibbleMaskTable | Entire256-entry table tested |
| main306F | CopyPackedRowsToTandyBanks | Header, copy extent and four-bank transition |
| main3097 | CopyPackedRowsStride104 | Linear workspace copy with104-byte stride |
| main30B4 | CopyPackedRowsStride160 | Linear workspace copy with160-byte stride |
| main3103 | TandyOffsetFromRow9EE8 | Table lookup plus4*AL; arithmetic wrap |
| main3118 | TandyOffsetFromRow9BC8 | Same operation with distinct table |
| main312D | TandyOffsetFromRow9D58 | Same operation with distinct table |
| main3345 | ClearTandy32K | Exactly32768 zero bytes with DF clear |
| AdLib0579 | DelayViaPit2Counter | All port accesses and repeat/exit paths |
| AdLib0557 | WriteOpl2Register | Index/data order, caller-visible registers |

No routine has been moved or reimplemented. Instruction encodings and complete
image identity remain the acceptance criterion. The eight main helpers are
C_READY_WITH_ENV, since segments, tables, flags and buffer preconditions require
modeling. The two audio routines remain HARDWARE.

## AdLib dependency recovered from the bottom up

`0579` is a leaf used by `0557`. It writes PIT/channel and port61 state, polls a
16-bit value from port42, and repeats on **signed JG** against BX. It preserves
AX and the other general registers, but changes flags. It clears port61 bit0
at exit; it does not restore the original PIT setup or original port61 byte.
Hardware responses determine whether it terminates. No precise delay duration
is inferred from a modern fixture or instruction count.

With that contract established, `0557` can be named WriteOpl2Register:

1. Output AL (register index) to the base port in DS:000E.
2. Call the delay with BX=1FFC.
3. Output AH (data) to base+1.
4. Call the delay with BX=1FEC.
5. Restore BX/DX and return, with AL now equal to AH.

It preserves other general registers and segments, changes flags, and inherits
the delay's PIT/port61 effects. Tests use the original decoded module, exercise
multiple register/data pairs, and compare the full IN/OUT transcript. They do
not emulate music or claim cycle accuracy.

Next, inspect `04A4` (table-driven register writes) and `024F` (lookup followed
by A0/B0 register writes). The latter has a fallthrough edge from0244, so the
source should retain that relationship instead of forcing independent clean
function boundaries.

## Structural interpretation and limits

Repeated Tandy bank-step instruction shapes are evidence of a coding idiom,
possibly a shared source abstraction. They do not prove a macro or its name.
The analogous selector wrappers and address helpers support a family of
implementations behind shared interfaces. They do not by themselves prove
historical object boundaries or original source filenames. The AdLib resource
is independently established as a separate loaded executable module.

Machine-readable focus and evidence: `metadata/reconstruction-focus.json`.
Tests: `python -m unittest discover -s tests -p test_tandy_adlib.py -v`.
They run only isolated original routines, never startup, menu or gameplay.

## Second static batch: record operations and a display rectangle

Five more routines now have reviewed names and isolated contracts:

| Address | Modern name | Main result |
|---|---|---|
| AdLib04A4 | WriteOpl2Table04B1 | Writes27 index/data pairs, then consumes a zero terminator |
| AdLib024F | WriteRecordA0B0Pair | Computes two register writes and updates record caches |
| AdLib0244 | StepIndex13AndWriteA0B0 | Optional byte-index step, then falls through into024F |
| main3354 | CopyWorkspace104x192ToTandy | Copies104 bytes per row to display rows4..195 |
| main3389 | ClearTandy104x200 | Clears104 bytes per row across rows0..199 |

The AdLib table at04B1..04E8 is now explicit DW source:27 register/data words and
one zero terminator,56 bytes total. This is reviewed **data**, not instruction
coverage. Its word layout is proven by the consumer: low byte is the register,
high byte the data. The first word is written unconditionally; only subsequent
words are tested before writing. The test includes a zero first word to preserve
that distinction. Actual original entries5Dh andB9h remain untouched; the apparent
regular sequences omit4Dh andB5h. Whether these reflect an error, a device-specific
choice or another intent is unknown. Do not normalize them to a cleaner sequence.

The record routine at024F is named for its demonstrated A0/B0 register operation
rather than a complete music-format interpretation. With i=(field00+field12)&FF:

    w = (word[07A9 + ((2*i) & FF)] + word[record+1A]) & FFFF
    h = high(w) OR byte[0749+i]
    word[record+14] = w
    emit(register = byte[record+07] OR A0, data = low(w))
    word[record+08] = (h << 8) | (byte[record+07] OR B0)
    emit(register = low(word[record+08]), data = h OR 20)
    byte[record+1E] = byte[record+1D]

The `SHL AL,1` at025E is deliberately modeled as an eight-bit operation. It is
not `SHL AX,1`. The candidate96-entry table extents do not supply a bounds check;
the code can read outside those candidate tables. Tests include95,96,127,128,255,
byte-sum wrap and word-addition wrap. The cached word is saved **before** the
additional OR20h. Calling it an always-key-off cache would overstate the contract,
since previous operations can already have set that bit.

At0244, zero field13 branches backward to RET0243. A nonzero value is added to
field00 modulo256, and execution falls through to024F. This relationship remains
in the ASM and graph; it has not been forced into two independently returning
functions. The record layout has nine32-byte instances beginning05A9, supported
by original initialization bytes and the nine calls in0063. Only field operations
established here are named in `metadata/drivers/adlib-data.json`; no historical
STRUCT syntax or full music abstraction is claimed.

The main3354 copier reads DS:234C **before** selecting its source segment. It
loads source DS from CS:9598 and destination ES from CS:95A4. It copies19968
contiguous source bytes as192 rows of104 bytes, beginning at banked display
offset00A0 (row4). The remaining56 bytes of each visible row, other rows and
bank padding remain untouched. On return DS is assigned CS:9596, which need not
be the incoming DS. An isolated test deliberately separates all three segments.
The related3389 routine clears only the104-byte-wide region across200 rows,
not the full32KiB buffer. Both require DF clear.

The new tests execute original routines and their actual callees with explicit
port-input fixtures. No gameplay run is used. The normal full verifier performs
its existing bounded startup-oracle check separately.

## Corrected PIT repeat contract

The isolated C-matching counterexample exposed an earlier overly strong description
of0579:0584 initializes AX=1FFFh only once. The059F backedge targets0587, so the
next port42 reload uses the counter word just read. The regression now returns
1FFEh before repeating and expects1FFEh on that reload. Original ASM bytes are
unchanged. See the [research report](c-match-diff-language.md).
