# Original-project reconstruction

This document separates four independent claims:

| Claim | Meaning in this project |
|---|---|
| BYTE_EXACT | Maintained assembly produces the accepted original normalized bytes. |
| STRUCTURALLY_SUPPORTED | Binary topology and rebuild experiments support a proposed project structure. |
| SEMANTICALLY_SUPPORTED | Instruction behavior and data use support a name or relationship. |
| HISTORICALLY_PROVEN | Direct surviving evidence establishes a historical fact. |

Evidence confidence remains PROVEN, STRONG, INFERRED, SPECULATIVE or UNKNOWN per
dimension. Byte exactness never automatically upgrades any other claim. The
machine-readable companion is `metadata/project-model.json`; the checked rebuild
experiments are in `metadata/topology-experiments.json`.

## Toolchain and build model

| Question | Current conclusion | Evidence/confidence |
|---|---|---|
| Executable format | DOS MZ, then three LZ-style layers and EXEPACK | PROVEN byte-level format/transform observations; precise packer build UNKNOWN |
| Assembler | TASM 1.0 is a working reconstruction candidate | PROVEN compatibility for reconstructed subset; historical identity UNKNOWN |
| Linker | TLINK 2.0 is an experimentally available candidate | PROVEN probe behavior; historical identity UNKNOWN |
| Historical tool versions | Not identified | UNKNOWN; tool availability is not evidence of original use |
| CPU | Reconstructed subset accepted under `.8086` | PROVEN subset; complete original CPU target UNKNOWN |
| Object format | Current TASM produces 16-bit OMF | PROVEN modern rebuild fact; original objects not preserved |
| Memory model | Multiple real-mode frames, near and far transfers, explicit segment state | PROVEN observations; do not assign a C small/compact/large model |
| Code/data segmentation | Code-frame constants and relocation targets preserved | PROVEN addresses, original segment declarations/ownership UNKNOWN |
| Runtime/library | No vendor CRT or library object identified | UNKNOWN; custom startup is observable but does not exclude library code |
| Original source names, macro names, flags | Not recovered | UNKNOWN |

TASM commonly reproduces the observed register-to-register encoding direction
without special work. A first full transcription mismatched fourteen bytes in
commutative TEST/XCHG ModR/M choices. Reversing their source operand spelling,
without changing operation, reproduced them. This is **encoding compatibility**,
not an assembler fingerprint unique enough to identify the historical tool.
The current source contains only genuine decoded instructions and separately
labelled opaque bootstrap material; it is not historical source text.

## Experiments that constrain project topology

Run `python tools/topology_experiments.py` to reproduce these with local pinned
TASM/TLINK. Compilation uses the nmlgc MS-DOS Player. Linking uses the measured
upstream i86 player, as in the Empires reconstruction configuration. The runner
receives a minimal environment because inheriting this host's full environment
caused MS-DOS Player to report `too many environments`.

The probes contain two three-byte routines (`MOV AL,11h; RET` and
`MOV BL,22h; RET`) in a PUBLIC CODE segment:

| Source/object topology | Linked module bytes | Result |
|---|---|---|
| One byte-aligned object | B0 11 C3 B3 22 C3 | 6 bytes |
| Two byte-aligned objects | B0 11 C3 B3 22 C3 | Identical 6 bytes |
| Two word-aligned objects | B0 11 C3 00 B3 22 C3 | 1 padding byte |
| Two paragraph-aligned objects | first routine, 13 zeros, second routine | 19 bytes |
| Reversed byte-aligned objects | B3 22 C3 B0 11 C3 | Reordered image and entry at +3 |

**PROVEN_FOR_PROBE:** alignment and input order can constrain topology. Equally,
one object versus two byte-aligned objects is not distinguishable from these image
bytes. These experiments do not establish any particular Overkill module boundary.
They identify which observations would discriminate future hypotheses.

An additional measured TASM behavior matters to exactness: `JMP NEAR PTR` to a
short-range forward target shortened to `EB 02 90`. The modern `JMP_NEAR` encoding
macro emits E9 with a symbolic displacement so that exactness does not depend on
that optimization. Branch encoding controls are transparent source-level
instruction encoders, not opaque original-byte capsules. Their names/syntax are
modern choices. Current production combines fully initialized, fixup-free OMF
LEDATA in a recorded physical order; **it does not pretend to reproduce the
historical linker invocation**. TLINK is used for hypothesis experiments, not
silently substituted into the production path.

## What the current topology actually supports

The reached code frames are listed with exact observed extents in
`metadata/project-model.json`. In particular, the first frame ends near the next
paragraph-based code frame 0F7F. This is a useful candidate boundary to investigate,
but it could represent a linker segment, an assembler-defined segment, a combined
PUBLIC contribution, or another layout convention. No original object boundary is
currently HISTORICALLY_PROVEN.

The game uses a relocated word at CS:9596 for DS/SS, while helpers sometimes address
private state through CS. Shared DS data and code-local state are therefore
SEMANTICALLY_SUPPORTED. They do not establish how many modules declared those
segments, the segment names, or whether includes supplied the declarations.

EXEPACK records relocation sites in 64-KiB groups. Its grouping loses information
needed to infer original object emission order from the packed order alone. The
pre-packing MZ header, linker padding policy and original relocation sequence are
not currently recoverable as unique historical facts.

All 18 `src/Rxx.ASM` files are modern physical chunks of approximately 8 KiB, chosen
to keep DOS assembler input bounded and moved slightly to avoid cutting an
instruction. They are deliberately not called input/video/player modules.
There are no fabricated historical `.ASM` filenames in this project.

## Recurring author-level patterns

There are 23 currently reached instances of this measured instruction skeleton:

```asm
mov bx,cs:[95BCh]
shl bx,1
jmp word ptr cs:[bx+table]  ; some sites use CALL
```

The associated tables contain three code offsets, consistent with the startup
selector range 0..2. The analyzer follows these three candidates while retaining
an unresolved-edge flag: startup bounds do not prove all later writes stay in
range. The recurring selector idiom and table addresses are PROVEN observations.
A common source abstraction is plausible (INFERRED); a historical macro is
SPECULATIVE. Neither its name nor exact syntax survives. Copy/paste or a consistent
manual convention could yield the same pattern.

The presence of analogous low-level routines reached through these tables supports
investigating display-specific routine families. It does **not** yet establish
separate source objects or a historical VIDEO.ASM file. The byte-aligned split
experiment explains why semantic clustering by itself cannot answer that question.

The reviewed A5DB/A5ED/A5FC/A60A family shares compare/conditional-return/update
shapes. Their differences matter: equality guards and unsigned range guards are
not interchangeable. A shared author convention is supported; a parameterized
historical macro is not proved. The compiler-like or handwritten origin of any
routine remains open without stronger evidence.

## Recovered data relationships

| Storage | Measured fact | Limits |
|---|---|---|
| SS:[BP+2], SS:[BP+4] | Updated independently by four adjacent helpers; read by A571 | Record extent, signedness, coordinate meaning and entity class UNKNOWN |
| DS:[BX+2], DS:[BX+4] | A571 writes source words plus 10, with 16-bit wrap | DS need not equal SS; overlap/order matters |
| DS:0410..060F | 512-byte DOS input buffer used by 0624 | Not a high-level stream abstraction; short reads are not checked here |
| DS:0610/0612/0614 | Cursor, saved BX, first-byte scratch | Shared/non-reentrant; errors have nonlocal stack behavior |
| CS:066B | Byte incremented via INT08 path, cleared and polled by helpers | Do not prematurely attach gameplay timing units |
| CS:0738 | Saved previous INT08 far vector | Verified installation and chaining context |

These are measured fields/relationships, not claims that the original author used
a C struct, a MASM STRUC, EQU constants, a macro or an include file. A future modern
include may encode these offsets for readability while explicitly preserving this
uncertainty.

## Bottom-up structural hypotheses still to test

1. Compare actual candidate code-frame boundaries with paragraph alignment and
   relocation ownership using fresh candidate linked objects. Include models
   with PUBLIC contributions and models with independent segments.
2. Recover which indirect tables and private CS data belong to the same routine
   families. Test whether suspected module splits force padding absent in the oracle.
3. Identify repeated prologue/epilogue and port-access patterns before inferring
   library objects or reusable author macros. Preserve rival explanations.
4. Identify the optional audio drivers and runtime-written code versions. They may
   add separate executable regions absent from the pre-startup module map.
5. Recover asset/container directory extents, then distinguish actual data tables
   from unknown bytes. Do not infer BSS merely from zero-filled storage.

The original project model remains revisable. Semantic certainty and build topology
must reinforce each other before a subsystem/module hypothesis is promoted.

## Independently established runtime module topology

The main semantic model remains shared with Oracle A. A physical audio-module
boundary is now STRUCTURALLY_SUPPORTED: the original container names ADLIB.ENC
and ROLAND.ENC, selects one by startup state, decodes it at relative 1022:0000,
initializes entry +4 and calls entry +0 from its timer handler. Independent
resource decoding equals authentic loading byte-for-byte. These facts support
separate executable modules more strongly than mere adjacency or naming guesses.
They do not prove original OMF boundaries, assembler versions or ASM filenames.

The module slot has versioned identities: initial placeholder, loaded AdLib or
loaded Roland. Entry/header overlap is explicit; data writes to a loaded header
are not instruction changes to a retired placeholder. PC speaker remains resident.
The evidence does not support separate CGA/EGA/Tandy source binaries: existing
renderer functions are selected through state and tables. K/alternate/joystick
input choices also coexist as state-selected paths.

Modern src/drivers names are organizational choices; original ENC resource names
are surviving historical evidence. The driver sources preserve separate code/data
address frames, near internal calls, far entry/return ABI and CS/DS-relative state.
No fixup pass was observed between complete ENC output and initialization.

Recurring register-save, nine record-base and sound-register patterns can now be
studied within those modules. A recurring pattern is not a proven historical macro.
For example, the AdLib status-read leaf preserves DX around a port read; its source
name is modern and the operation is tested. Its port number resides in the module
header, and the register-write delay helper has PIT/speaker-control side effects.

The canonical research profile is Tandy/PCjr + AdLib/YM3812 + default keyboard.
It materializes an optional executable module and exercises the Tandy renderer.
Other video, input and Roland paths are retained. See runtime-materialization.md
and metadata/runtime/materialization.json for confidence, scope and unresolved
ESMR/stability questions. Binary identity never establishes historical source text.

## Tandy + AdLib static evidence

The current semantic priority and exact contracts are recorded in
[tandy-adlib.md](tandy-adlib.md) and `metadata/reconstruction-focus.json`.
Packed nibble masks, banked row addressing, corresponding EGA plane writes and
repeated selector wrappers support a renderer implementation family. Repeated
bank-step shapes support a source-level idiom hypothesis, not a proven macro.
No historical module boundary or filename follows from these observations alone.
The separately loaded AdLib resource remains stronger executable-module evidence.

## Record/table evidence added in the second static batch

The AdLib table04B1 is28 little-endian words,27 writes plus a zero terminator;
its interpretation is established through reviewed0557 and04A4. It is now explicit
word data in maintained ASM, counted independently from decoded instructions.
Anomalous register values remain exact. Nine32-byte driver records are supported
by repeated callers and initial bytes; field offsets now have operation-based
metadata. This supports a shared record convention without proving a historical
STRUCT, EQU include, macro or source filename. See `metadata/drivers/adlib-data.json`.

## Current structural utility: record cluster

The record search and movement cluster now supplies shared56-byte record and field
relationships across generic updates and Tandy addressing. Local modern EQU names
improve maintained source without moving physical chunks or claiming historical
module boundaries. The count-dispatch proof closes a concrete CFG gap. See
[record-movement.md](record-movement.md) and `metadata/record-movement.json`.
Further toolchain archaeology is lower priority unless it resolves an exact-build,
code-boundary or data-ownership question.

## Coordinate history and offset-placement ownership

Six reviewed entries connect a48-entry position history, two delayed record
positions and four offset-positioned records to the input-update caller. The
shared state and explicit fallthrough support a semantic cluster; they do not
prove an original source or object boundary. Modern local EQU names expose this
relationship without moving the exact physical chunks. Four adjacent Y/X pair
groups are48 bytes of maintained word data, with the caller index domain still
open. See [position-history.md](position-history.md) and its machine-readable
metadata. These facts improve future translation boundaries without assuming
historical STRUCT syntax, filenames or compiler behavior.

## Bounded C code-generation evidence

The separate ten-routine [matching study](c-match-diff-language.md) tested Turbo C2.0
and Microsoft C5.10. Neither produced natural exact matches under its normal ABI
for this sample. This is not evidence identifying or excluding OVERKILL's historical
compiler globally. ABI specialization explains much of the small-body mismatch;
return-layout choices explain a few more bytes. No new original module or compiler
claim, production C dependency or reconstruction architecture is adopted.

## Modern research swap layout

The [single-unit swap experiment](swap-unit-experiment.md) uses a512-byte prefix
for native C and its mechanical ABI bridge. Adjusted MZ relocation targets retain
that prefix through the original DOS resize without moving relative main addresses.
This is a modern research packaging choice, not a historical module/layout claim.
The original file integrity routine also independently establishes a final two-byte
checksum outside the last resource. Its rule reproduces both pinned file trailers;
research packages regenerate it rather than bypassing the original check.
Machine-readable build/boundary evidence is in research/swap_unit/results.

## Second research-only source boundary

[History transfer](history-transfer-swap.md) groups9BE2,9CD9 andA031 because the
known graph has one common external entry and no other helper callers. This is a
modern swap boundary, not a historical module claim. Four native packages combine
two independent ASM/C choices in a common1KiB prefix; only explicit entry gates
change the normalized main. Production objects and exact bytes are unchanged.
The101-byte ABI bridge for77 original bytes is evidence against assuming that
small original helpers automatically yield cheap independent C boundaries.

## Separate clean source world

The latest [clean-world experiment](clean-c-reconstruction-experiment.md) treats
historical functions as verification regions, not a required runtime decomposition.
History uses typed position objects and ring indices. Normal C callers link to C
leaves at different measured addresses in two builds. This is a modern semantic
representation under explicit preconditions, not evidence of original C or structs.
The exact ASM remains independent; prefix/trampoline labs are retained as research.
No original main image or historical ABI bridge participates in the clean runtime.

## Shared semantic vocabulary, not historical topology

`include/MOVEMENT.INC` consolidates reviewed record-coordinate, history and
placement constants across modern physical chunks. It emits no bytes. This is a
modern source-maintenance choice, not evidence of an original include or module.
The9FEA placement tail crosses R04/R05 atA000: one semantic body spans two modern
containers. The exact verifier audits the include as literal EQU definitions and
records its hash; segment topology and ordered relocations remain unchanged.

## Focused observed-frame review

The current code graph supports the following **address frames**, not five
historical OBJ files. Counts are decoded call sites, not executions or function
counts; unknown code can change them. See `structure_review` in the project model.

| Frame | Near calls | Far calls out | Far calls in | Evidence-based description |
|---|---:|---:|---:|---|
|0000|741|41|44|Main code/state and shared services; several conceptual families|
|0F7F|22|44|32|Additional code frame, substantial shared DS state and main callbacks|
|1022|0|0|4|Active main graph excludes slot contents; optional modules counted separately|
|1534|1|0|1|Critical-error handler/vector installer; CS scratch and nonlocal return|
|153A|3|0|4|DOS/path/file-service family with private CS state and caller pointers|

The cold1022 stubs and loaded ADLIB.ENC/ROLAND.ENC are separate address identities.
Their surviving resource names, independent extraction, load destination and
interfaces are stronger module evidence than proximity or semantic clustering.
Main IRQ code calls offset0; selection/startup calls offset4; request fields at8
andA are data. The recorded12 relocation words equal to1022 are not all assumed
calls. The selected module has no observed ENC relocation/fixup pass. Original
ASM/OMF source boundaries remain unknown even for these real executable modules.

0F7F begins at linearF7F0 after six zero bytes atF7EA..F7EF; its reached end10217
is followed by nine zero bytes before10220. These fit paragraph-fill hypotheses,
but neither zero run is promoted to proven linker padding. The27 candidate
functions are not27 proven source contributions. CS:0920 has a known write at
0F7F:0918, while other routines use main DS state. Heavy far callbacks weaken a
self-contained/private-module interpretation; they do not disprove a segment or
source contribution.

1534 begins at15340 and153A at153A0, only96 bytes later. The first six bytes of
1534 are **writable CS scratch**, now represented as reviewed word data. The
handler pops saved words there, sets a carry bit, then constructs an IRET to
1534:004E. Consequently the18-byte interval1538E..1539F is not pure padding.
The continuation contains code-like bytes and a CS-relative far handoff; its
nonlocal DOS stack contract remains unreviewed, and it stays UNKNOWN source.
The installer at003C and near helper0045 are now named and locally tested. The
far call at95E3 has its segment relocation at95E6; source symbols retain that
exact original relocation. Private state plus a far entry supports a platform
family, not proof of one OBJ or an original filename.

153A has CS-relative cells073A..0748 and buffer references such as07AE, while
accepting caller DS:SI and ES:DI. Its far entries0000/04D7 and near helpers06CD/
0701 support a DOS/path-service family. Large unreviewed regions prevent a full
module contract or ownership partition. Full64KiB real-mode address windows can
overlap even when currently reached physical instruction extents do not.

Seven decoded `CALL next-instruction` sites are now recorded:45CB,8528,A5D8,
A5EA,A5F9,A607,AF60. Only the four coordinate wrappers have reviewed double-step
semantics. AF60 reaches an indirect dispatch, and the other sites require their
own contracts. Repetition supports an author-level coding convention; historical
macro/include names or even macro use remain SPECULATIVE. Likewise REC_Y/REC_X,
record stride and history-pair width express supported shared concepts without
proving historical STRUC or EQU syntax.

Conceptually, current anchors are main startup/platform plumbing, input and
record/update state, history/placement, coexisting renderer paths, resident sound
service and resource handling, plus separate optional audio modules. These are
unevenly understood semantic families, not a recovered historical source tree.
The strongest next structural question is the1534 continuation/stack boundary;
it can discriminate real code/state from apparent inter-frame fill.

### Main-frame near-call bridges

All44 decoded0F7F far callbacks use the two main bridges now named in source:
`FarCallMainNearViaAX` at8D8B (`CALL AX; RETF`,43 sites) and
`FarCallMainNearViaBP` at8D8E (`CALL BP; RETF`,one site). Their far-call operands
now use symbolic bridge offsets in R07/R08. These are bridges to varying main-CS
near procedures, not one fixed shared service. Examples set AX=5DB2,81F4,AFD8,
D2B8,50C9 or BP=5401 before the crossing. The near callee returns to the bridge,
whose RETF restores the0F7F caller; its register/flag effects pass through.

This explains how near-call locality coexists with cross-frame dependencies.
Synthetic execution through real original near callees confirms the nested stack
return and callee side effects. Target domains are not yet closed: these two
indirect call sites remain unresolved rather than being treated as fixed calls.
This strengthens the connected-code-family model and weakens an execution-isolated
0F7F module hypothesis, while leaving original source/OBJ boundaries unknown.

### Concrete contribution-alignment experiment

Run `python tools/critical_vector_topology.py`. It verifies pinned inputs/tools,
extracts the original18-byte1534:003C..004D sequence, and assembles it as normal
symbolic TASM/TLINK source. A synthetic60-byte prefix supplies the original start
offset; it is explicitly not a reconstruction of the preceding handler. No probe
executable is used as game code.

| Candidate topology | Helper offset | Added padding | CALL displacement | Original18-byte sequence |
|---|---:|---:|---:|---|
|One BYTE object|0045|0|+1|exact|
|Two BYTE contributions|0045|0|+1|exact|
|WORD helper contribution|0046|1|+2|different|
|PARA helper contribution|0050|11|+12|different|

Thus a WORD/PARA contribution boundary at0045 does not fit this measured candidate
layout, whereas one versus two BYTE contributions is observationally ambiguous.
This is a constraint on the tested TASM1.0/TLINK2.0 arrangement, not proof of the
historical assembler, segment declarations or source file count. No further search
for an erased filename is warranted here. The MAP reports aggregate CODE extents;
actual symbol offsets above are measured from linked instruction bytes. All four
EXEs have zero load relocations; that does not mean the input OMF objects lack
link-time fixups. Exact reports and tool pins are in
`metadata/critical-vector-topology.json`.


### Shared response path and critical-error continuation follow-up

The grid probe at AC3C and scan at AC81 converge on AC56, sharing record fields
+20/+24 and the AC54 return. This is SEMANTICALLY_SUPPORTED shared behavior;
it does not distinguish one source contribution from several byte-aligned ones.
The dynamic attribute table C3AA..C4A9 connects startup initialization, reset,
XLAT and grid readers. Shared state is evidence of a common concept, not proof
of a historical include, STRUC or file boundary.

Independent extraction also confirms the 13-byte continuation at 1534:004E:
PUSHF; PUSH AX; MOV AH,19h; INT 21h; POP AX; POPF; far JMP CS:[0]. The handler
constructs that IRET destination after saving an outer return pointer in its
private CS words. Five zero bytes follow before frame 153A. Their role as
padding is still UNKNOWN. Promotion is deferred until a synthetic whole-handler
stack-contract test and guarded CFG edge are added; actual DOS-version stack
compatibility must not be inferred from a synthetic test. No module boundary
has been promoted from this observation.


The byte-attribute lifecycle now shares symbolic definitions across R00/R02/R06:
fill, sparse index/value patches, reset, XLAT and indexed lookup. These are
SEMANTICALLY_SUPPORTED common state relationships. The shared definitions in
MOVEMENT.INC are a modern source convenience; neither that filename nor an
original shared include/module boundary is historically proven.
