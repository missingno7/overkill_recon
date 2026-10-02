# DOS C implementation and oracle boundary

```text
original binary
      | byte exact: tools/verify.py
frozen ASM oracle (asm-semantic-oracle-v1, src/ + include/)
      | behavioural equivalence: tools/difftest.py
DOS C implementation (c/) with the original DOS hardware backend
```

The frozen ASM remains the executable specification. The C implementation reads and
writes the original state, records, tables, buffers and code-segment variables; it owns
no persistent data. Game logic and reusable coordination belong in C. DOS/BIOS calls,
interrupt entry, hardware polling, adapter raster operations and sound-module drivers
remain the platform backend until the SDL3 phase.

C regions cover record/type dispatch, movement, collision, enemies, weapons, upgrades,
player input, frame/session control, levels, options, calibration, title/intro/demo,
pages and high scores, text controls/formatting, rendering decisions, sound requests,
settings, launcher configuration, startup/shutdown policy, archive lookup, resource
cache and packed/ENC codecs.
Animation choreography is separated from its capture/scaling/pixel services. The
uncalled payment viewer also has C file/navigation control. Uncalled historical/debug
paths can remain in the oracle-derived backend; they are not part of the game's active
SDL runtime.

C-to-C calls are native. Legacy register adapters remain where ASM enters C or where a
bounded differential test still enters an old routine. Explicit stack-local metadata
carries live BP/ES/DI and decoder cursor/status outputs at those boundaries. Those words
are outputs, not shadow game state. Compiler-temporary physical registers must never
serve as implicit C state.

## Build and run

```powershell
python tools/verify.py
python tools/hybrid.py
python tools/difftest.py
python tools/difftest.py --mutants
python tools/difftest.py --coverage
python tools/stackcheck.py
python tools/graph.py
```

The build produces `build/oracle-sym`, `build/hybrid` and runnable packages under
`build/run/{oracle,hybrid}`. Run `OVERKILL.EXE /T /A` from `build/run/hybrid` in DOSBox
with Tandy hardware for the current priority configuration. The launcher EXE is still
the original launcher. The rebuilt executable image, resource container and recomputed
integrity checksum are in the extensionless `OVERKILL` file.

`hybrid.py` takes no CLI output-directory argument. An isolated experiment calls its
Python `build(out, c_dir=...)` API with a private copy of `c/`; it must not rebuild the
shared output concurrently. `difftest.py` accepts suite names and a trailing case scale.
Mutation builds have separate output directories per suite.

## Compiler and memory model

Watcom C16 10.0a is pinned by `metadata/c-toolchain-lock.json`. Its Win32 loader and
16-bit compiler are local private inputs. TASM 1.0 and TLINK 2.0 run under the local
MS-DOS Players, independently of neighboring projects.

All C files compile as one `ISLAND.C` unit in `CGAME`; all ASM adapters assemble as one
`BRIDGES.ASM` module. Near calls connect C regions. MAIN and CGAME each have a checked
64-KiB limit. The unity build requires globally unique file-scope helper names and
consistent declarations; a label defined by one bridge must not also be declared
external by another bridge in the same module.

| Item | Contract |
|---|---|
| Names | `#pragma aux default "^"`: upper-case linker names; C names use snake_case |
| Default call | SI, then DI; result AX; preserve all registers except AX; flags scratch |
| Segments | DS = SS = original state frame; DF = 0; ES is explicit when consumed |
| Data | No C statics, literals, tentative definitions or duplicate records/state |
| Arithmetic | Original 16-bit wrap and explicit signed casts; preserve original bugs |
| CS data | Far declarations or an explicit MAIN service; CGAME has a different CS |

`GAME_GEN.H` is generated from `include/*.INC` and `src/DATA.ASM`. It supplies constants,
state declarations and the 38h-byte Record with checked field offsets. The C object is
rejected if it owns data or requires unsupported local/communal symbols.

The SDL3 phase ([host-port.md](host-port.md)) must supply a host memory/address adapter as well as video, input, time,
file and audio services. These DOS C sources deliberately still use 16-bit offsets and
Watcom far-pointer syntax; they are not yet a drop-in native-host build. Preserve the
verified C decisions while replacing that platform representation.

## Derived hybrid, unchanged oracle

`OWNS:` lines identify each replaced oracle range, including its internal labels and
owned dispatch tables. `hybrid.py` copies the frozen ASM into generated output, replaces
those ranges with external C entries, expands jumps where needed and publishes symbols
for tests. It never changes `src/` or `include/`.

A MAIN adapter converts the original register contract to the C call convention.
Generated CGAME far entries make the segment crossing explicit. Remaining MAIN services
are reached by relocation-bearing far calls; the build checks every C far-call fixup.
The trampoline's AX carries its target, so an AX input needs a different adapter.

The symbol-complete oracle must still have exactly the original image and relocation
set. Hybrid packaging then combines the new linked image with the original container
and a new integrity checksum. Original assets and their metadata are never rewritten.

## Verification and limits

Differential cases use the exact oracle and C hybrid in the same emulated DOS model.
They compare the state segment, contract registers/flags, ordered writes outside state
and hardware port traffic. Link-dependent code pointers and segment identities are
compared symbolically. Stack scratch below the caller's SP is excluded; active state
must never be excluded because a mutant changed startup initialization.

Cases cover bounded routines and controlled service sequences. File fixtures hook DOS
responses, codecs also decode every shipped BIC/ENC asset, and rendering fixtures use
distinct data so wrong image selection changes observable pixels. Saved differential
fuzz corpora replay as regressions. Mutation tests require deliberate mistakes to be
detected. Coverage lists missed instructions explicitly; unreachable or out-of-domain
branches require a static explanation, not a fabricated execution.

The ordinary PASS line records the lowest active stack write below entry SP.
`stackcheck.py` additionally observes SP per opcode, verifies the actual AdLib/Roland
modules and measures their timer handlers. Its combined 512-byte stack model includes
the test caller reserve and the largest measured IRQ increment. It excludes the BIOS
chained timer phase and arbitrary interrupt timing, so it is bounded evidence rather
than a universal whole-session proof.

`graph.py` derives a migration view from the oracle and C ownership declarations.
Its original call edges include bodies already replaced by C; read the actual C callers
before declaring a residual ASM routine active. Automatic gameplay/mixed classifications
are investigation aids, not a completion percentage. The source contracts and current
tests remain the behavioral authority.
