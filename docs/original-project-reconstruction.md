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
