# Build model and acceptance

The primary deliverable is `build/program.bin`, normalized to a zero load-segment
bias, with relocations and entry in `metadata/relocations.json`. This is a load
module, **not a DOS EXE** and not directly launchable. No post-link byte patching,
binary grafting or extraction-result substitution is used to construct it.

`tools/build.py` reads maintained assembly, includes and the physical source map.
TASM 1.0, run with local nmlgc MS-DOS Player, creates 18 OMF objects. The strict local
OMF reader validates every record checksum, rejects unresolved FIXUPP and iterated
LIDATA, rejects overlapping writes/holes, and extracts the initialized LEDATA.
Their declared modern physical ordering reconstructs the entire module. TASM source
uses `.8086`, byte-aligned PUBLIC segments and explicit DS/SS/CS/ES operands where
needed. Relative branches use named absolute-offset symbols plus transparent
encoding macros. Far immediates contain normalized segment words; the original
relocation sites are verified separately. No claim of historical OMF identity is made.

A build never runs `bootstrap_source.py`, disassembles the oracle into replacement
source, reads `build/oracle` as build input or imports anything from a legacy project.
`tools/verify.py` then independently extracts the reference from `assets/OVERKILL`
and checks the entire assembled image, length, entry and ordered relocation list.
No bytes/ranges are excluded from comparison. Known differences fail acceptance
and are recorded as half-open byte ranges in `build/verification.json`.

The strongest current acceptance criterion is exact normalized module identity.
Whole packed-file identity is explicitly **not built or claimed**. Reconstructing
headers, nested compression recipes and wrapper source without hiding copied code
is still a separate milestone. The launcher is extracted/validated but has no ASM
source reconstruction yet. The appended asset container is preserved verbatim and
spatially mapped; it is not counted as code reconstruction.

## Bootstrap bytes and measured coverage

Each record in `metadata/source-map.json` owns a disjoint interval. Decoded
instructions are represented as actual mnemonics or symbolic instruction-encoding
macros. Unknown intervals contain visible `DB` declarations with an UNKNOWN comment.
They are counted as `opaque_unknown` regardless of whether they later prove to be
code, initialized data, padding or strings. Renaming DB to DW would not establish
semantic progress. Assembling a byte dump does not count as understanding it.

The source currently accounts for 25,564 instruction bytes and 117,524 raw unknown
bytes. Read `docs/status.md` for freshly generated metrics; numbers in this narrative
are the initial accepted batch. Function boundaries are inferred CFG candidates,
not a historical function table. Shared tails and remaining indirect edges are
recorded rather than forced into clean procedure boundaries.

## Determinism and failure behavior

Original assets and local tools are pinned in `metadata/inputs.json` and
`metadata/toolchain-lock.json`. Python itself is the only host prerequisite; it is
not copied into this project. The decoder/emulator packages and their wheels are
local. The `.OBJ` and `.LST` files can contain current timestamps; they are not
accepted historical artifacts. The emitted module and metadata comparisons are
byte-deterministic. A new verification starts by invalidating any old success
receipt. The full-check receipt is likewise invalidated before full checks begin.

Typical commands:

```powershell
python tools/verify.py              # fresh build + original-image comparison + reports
python tools/verify.py --full       # also two-base bootstrap execution, probes, tests
python tools/extract.py             # fresh game and launcher oracle extraction
python tools/report.py 0000:A571    # function contract and cross references
```

The toolchain experiments are a build-model laboratory. The production OMF binder
is deliberately narrower than a linker and rejects relocation records instead of
ignoring them. A future historical-linker build must earn an independently stated
acceptance criterion; it must not replace this one with a weaker comparison.
