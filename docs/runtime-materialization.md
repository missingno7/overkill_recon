# Runtime materialization investigation

Oracle A remains the historical/bootstrap oracle: 143,088 normalized bytes,
123 ordered relocations, entry `0000:95C9`, SHA-256
`65a549e2202a467da966d4821bd937ba50cc61ce541836135898bb779e398714`.
No acceptance criterion or reviewed R00..R17 source was replaced.

The supported architecture is **shared initial main ASM plus versioned optional
sound modules**. There is no evidence in the tested paths for wholesale main-code
materialization after Oracle A. Runtime execution does expose more control flow,
and optional sound loading exposes code absent from the initial image.

## What happened at 5E42

The range is `[0000:5E42,0000:5F1B)`, 217 bytes (the legacy endpoint
5F1A is inclusive). This is a probe window, not a proven function boundary. The independent packed execution
records 217 byte stores by `32FF:0099` (REP MOVSB), of which 211 change their
previous value. They occur at callback sequences 1,346,285..1,346,501.
Oracle A is reached at sequence 1,370,856. `009B` is the following IP, explaining
the legacy attribution without moving this event into game startup.

The earlier bytes beginning `55 2E 8E 06 96 95 ...` belong to an intermediate
pre-EXEPACK image. Oracle A already has the body beginning
`C7 06 0C 23 00 00 ...`. This is **unpack materialization**, not video selection
or recurring gameplay SMC. The lossless write journal also records earlier LZ
stages writing those physical addresses. No legacy snapshot supplies any byte.
Do not demote the existing Oracle A body as a transient cold routine.

## Reproduction

```
python tools/verify.py
python tools/verify.py --full
python tools/materialize_runtime.py --video tandy --sound adlib --input keyboard
python tools/runtime_report.py main 0162
# Only for a concrete unresolved startup/entry question:
python tools/runtime_experiments.py --gameplay-entry
```

The materializer starts with pinned original files, executes all original packed
stubs, checks the independently decoded Oracle A at its entry, then executes
original startup. DOS reads use pinned asset contents; no original routine is
replaced, no resource snapshot is an input, and no game global is patched to
skip an initialization or game phase. Keyboard events enter via IRQ09 and the
original installed handler. Timer events enter via IRQ08 and execute its handler.

Default output is `build/runtime-oracle/`:

- `main-runtime.bin`: the complete 143,088-byte address-space window at the
  candidate frontier. It contains code, data, workspace and the audio slot;
  its length is **not** executable-code coverage.
- `main-executable.bin` and `executable-regions.json`: an explicit projection
  of conservatively identified main instructions, excluding the audio slot.
- `adlib-driver.bin`: the complete initialized module, including data.
- `adlib-uninitialized-module.bin` / `module-0.bin`: its authentic decoded
  bytes before initialization, independently checked against `resources.py`.
- `state.json`, `manifest.json`, `runtime-code-writes.json`: profile, registers,
  loaded modules, file-read provenance, vectors, code watches and hashes.
- `writes.bin.gz`: lossless conventional-memory write journal, including
  unchanged writes. Header `<QHHIHB` is sequence, writer CS/IP, physical
  destination, byte count, origin; old bytes and new bytes follow.
  Origins: 0 original CPU, 1 modeled DOS/BIOS write, 2 interrupt entry.
- `memory.bin`: supplementary whole-memory debugging evidence, never the only
  representation of the program.

Addresses in the execution reports use load segment 1010h, PSP 1000h. Source and
static metadata use load-relative addresses. A physical write may have many
segment aliases; journal report destination segment/offset is a canonical alias,
not a claim about the instruction's original address expression. Sequence counts
include REP iterations and interrupt-delivery callback boundaries, not CPU cycles.
Instruction visit counters are pre-execution hook visits; an IRQ stop/retry can
count the interrupted instruction twice, so they are not exact retired-instruction counts.

## Video and input

Seven startup profiles reached `0000:9690`: CGA/EGA/Tandy with PC speaker,
Tandy with AdLib/Roland, and CGA/EGA with AdLib. At this frontier, changing only
video changes exactly one byte of the main address-space window: selector
`CS:95BC` (0/1/2). No watched main instruction byte differs. The three PC-speaker
video runs also execute renderer preparation through `0000:96CE`; their
executable-write watches remain clear.

This is dispatch/state selection. The original `0889` reads the selector and
copies 39 words from a selected table to DS:1024; it sets geometry/addressing
state at CS:959E and following words. Many existing rendering wrappers select
near routine addresses through CS tables (`MOV BX,CS:[95BC]; SHL BX,1; JMP/CALL
CS:[BX+table]`). Distinct renderer routines coexist. Table copying and CS-resident
variables are not automatically instruction patching. Unknown and unexecuted
paths still limit the no-patching conclusion.

The original startup consumes the compact PSP payload at 81h..83h. Direct tests
use `0D 00`, `0D 01`, `0D 02` for PC speaker, with `41` appended for AdLib or
`52` for Roland; Tandy/AdLib is `0D 02 41`. This is the inner game's compact
payload, not a claim that a DOS user types those bytes. The original documentation
names `/C`, `/E`, `/T`, `/A`, `/R` for the launcher.

Input is runtime state, not a binary variant. `0000:0162` tests DS:0010:
0/default uses the key table at DS:213E; 2 uses DS:2146; 1 branches to the
joystick path at 01CE, including port 201h reads. The menu writes these selectors.
`tests/test_runtime.py` executes the original poller in all three states and
checks branches, ports, output bits and absence of writes to main instruction
storage. Keyboard IRQ09 at 4ED2 updates the scan-state array at DS:98C4.
The canonical initial state is keyboard; joystick code remains present.

## Optional sound modules

The original appended container has a 12-byte SHADOW header and 58 encrypted
26-byte directory records. Original code at `153A:0534..0635` finds its MZ append
base, decrypts records with an evolving XOR byte and locates resources by name.
Independent `tools/resources.py` implements those operations from the original
instructions, then independently decodes the ENC stream (`0000:ECF2..EE03`).
Every decoded module byte matches the original game's decoder output before
initialization. There is no observed fixup pass or relocation list in this format.

| Original resource | File offset | Compressed bytes | Decoded bytes |
|---|---:|---:|---:|
| ADLIB.ENC | 436669 | 8021 | 16318 |
| ROLAND.ENC | 444690 | 7548 | 14594 |

Both load at relative `1022:0000` (runtime `2032:0000` here), in the reservation
before the code frame at 1534h. Stores at main `EDE9` emit the decoded bytes.
This is **optional module loading**, not synthesized instructions. Sound selection
alone changes this executable module, main data flags, decoder workspace and
elapsed timer state; it does not replace the main program's renderer or input.
PC speaker uses resident main code and does not load either optional module.

The far entry at module offset 4 is initialized by the main sound selector.
The far entry at offset 0 is called from IRQ08 when DS:0055 enables the module.
Main code writes the request word at module +8 (CB34/CB4B/CB87), and a parameter
byte at +Ah (CB71). Both observed modules have +8 changed from 0 to 2 at 9690;
this is data, even though the initial placeholder occupied overlapping addresses.
The complete cold and loaded identities remain distinct.

AdLib accesses ports 388h/389h and probes timer status. It is an OPL2/YM3812
interface; no OPL3 extension is inferred. The status-register interpretation is
consistent with the [original Yamaha YM3812 application manual](https://c64.xentax.com/media/Yamaha_YM3812_Application_Manual.pdf).
ReadOpl2Status at module 0571 is the first reviewed driver leaf: AL receives
IN(DS:[000E]); AH, DX and FLAGS are preserved. A focused executable test checks
that contract. Its boundary is STRONG from adjacent routines and its near return;
no original caller has yet been found, so this is a reviewed callable leaf candidate,
not a claim that gameplay invokes it. Its callers and memory/port interface remain in driver metadata.
The register writer also uses PIT channel 2 and port 61h for delays; these are
real hardware side effects, not a pure function.

`src/drivers/ADLIB.ASM` and `ROLAND.ASM` rebuild their complete decoded resources
byte-exactly through the pinned nmlgc/TASM path. They contain explicit unknown
DB ranges; decoding instructions is not semantic understanding. These are modern
source filenames. The surviving ENC resource names do not prove historical ASM
filenames or the original compiler/linker.

## Candidate ESMR and stability

`0000:9690` is the earliest **tested common caller frontier** after sound selection,
resource decoding and successful optional-driver initialization. Timer and keyboard
vectors are installed by then; the video selector is fixed. It precedes substantial
renderer/asset preparation and intro evolution. It is much earlier than D007.

This is a reproducible **candidate ESMR**, not a proven earliest instruction or
an all-path stability theorem. Code bytes of the optional module are already
present before its initialization call returns; moving the boundary earlier
requires explicitly deciding which hardware-result and driver-state obligations
must have completed. That question remains open rather than being concealed by
calling a convenient address mathematically earliest.

`metadata/runtime/materialization.json` records each run's exact horizon,
frontiers, keyboard events, executable write attempts and changes. The 100M-step
intro/menu/attract run and all three renderer-preparation runs have zero watched
executable writes after 9690. Later runs are listed individually; reaching D007
alone is not proof of gameplay, since it also orchestrates intro/attract activity.
Death, all six levels, all object behaviors, bosses and ending are not certified
by those traces. No guarantee is made about unknown executable bytes.

The post-filter includes the initial conservative code map, the extended runtime
CFG, optional-module CFGs and instructions observed later in each run, so a write
before the first execution of its destination is not missed. The cold driver
stub is retired when the module loads: subsequent header/data writes must not be
misreported as SMC merely because those addresses once held stub instructions.
Unexpected post-frontier changes stay in the report; no allowlist deletes them.

## Execution-model limits and acceptance

This is an independent bounded real-mode execution harness, not a complete PC
emulator. DOS files/allocation/vectors, BIOS responses, PIT channels, retrace,
OPL2 timer status and MPU ready/ACK are explicit fixtures. IRQ cadence uses
instruction callbacks; it is not cycle accurate. The ROM model byte is FDh and
VGA DAC-index probing reports a non-VGA path. Video register writes are logged,
but display rendering and music synthesis are not validated. Unsupported
DOS/BIOS/input-port interactions fail; conventional-memory writes are journaled.
Execution outside conventional RAM is rejected except modeled BIOS IRET stubs.

Therefore B identifies code and a deterministic state under a stated environment.
It does not assert that every physical Tandy machine has identical RAM or timing.
The full verifier preserves A, compares freshly assembled modules with authentic
loading, compares rebuilt main instructions with the live projection, checks the
pinned B RAM hash in one bounded startup run. An exact-repeat experiment, including
the compressed journal, already passed; `verify_runtime.py --repeat` is reserved
for a specific determinism question rather than routine replay. Mutable RAM is generated by execution; it is not hidden
inside an alleged second reconstructed ASM dump.

## Semantic reconstruction direction

Keep R00..R17 as the exact common/main and bootstrap representation. Use the
extended main runtime CFG and per-driver CFGs for the bottom-up queue; treat
`1022:0000` and `1022:0004` as profile-dependent module entries. Retain the initial
placeholder's identity in Oracle A, but prioritize loaded driver routines for
runtime semantics. No reviewed main body needs replacing on present evidence.

Runtime observation expanded the main CFG without finding a different main-body
version. In this batch, 10,987 newly identified main instruction bytes were explicitly
promoted from UNKNOWN DB ranges to instruction source; the complete A image still
rebuilds byte-exactly, with every previously maintained instruction preserved. Main
instruction-source coverage is now 36,551 bytes; 106,537 bytes remain explicit opaque
bootstrap material. This is syntactic progress, not 10,987 bytes of semantic understanding.
No C translation was started. See `metadata/runtime/observed-coverage.json` and
`python tools/runtime_report.py main 0162` for the current graph and evidence.

## Execution scope after user review

The extended traces above were collected before the user narrowed the investigation.
They remain evidence with explicit horizons, but do not define future acceptance.
All subsequent original-game runs are capped at first gameplay entry (0000:97B2),
and require a specific unresolved question. The normal path is static bottom-up
work and byte-exact assembly verification. Full verification stops at9690.
Exhaustive gameplay-state coverage is neither practical nor required. Global
unknowns are recorded honestly and addressed through local static proofs, rather
than by attempting every level, death, object, boss or ending scenario.
