# Executable wrapping and the oracle boundary

All numeric addresses below are hexadecimal unless a decimal byte count is stated.
`segment:offset` in metadata is **relative to the DOS load segment**. At the test
load segment `1010`, normalized `0000:95C9` becomes runtime `1010:95C9`.
A linear normalized image offset is `16 * relative_segment + offset`.

## Original files and exact file boundaries

`metadata/inputs.json` pins the three original inputs, byte for byte. Both programs
are 16-bit DOS MZ files with 512-byte headers, no outer MZ relocations and overlay
number zero. The MZ size, not EOF, defines the load module.

| File | Total bytes | MZ-declared executable | Appended bytes | Outer entry |
|---|---:|---:|---:|---|
| OVERKILL | 518204 | 50555 | 467649 | 0C22:000E |
| OVERKILL.EXE | 42829 | 42827 | 2 | 0A3F:000E |

The two launcher trailing bytes are preserved and hashed, but their meaning is
UNKNOWN. Do not silently discard them. The large game suffix is a data container,
not a second MZ image and not proved to be linker-managed executable overlays.
Its internal resource directory and optional code-bearing driver blocks remain
unrecovered in this project. The supplied documentation describes the game and
launcher options; it does not identify an assembler or original source layout.

## Four transformations for OVERKILL

| Stage | Input entry frame | Expanded bytes | Next entry | Relocations |
|---|---|---:|---|---:|
| LZ-style 1 | 0C22:000E | 46491 | 0B44:000E | 0 |
| LZ-style 2 | 0B44:000E | 42315 | 0A3F:000E | 0 |
| LZ-style 3 | 0A3F:000E | 80040 | 1366:0010 | 0 |
| EXEPACK | 1366:0010 | 143088 | 0000:95C9 | 123 |

The three LZ stubs contain the same measured bit-loop signature at offset 0069.
Their code matches the 0.91-style LZEXE format; the precise packing executable
version/build is not established. The LZ decoder uses prefetch of the next control
word **before** consuming the next literal when the bit counter expires. Literal,
short/long backward-copy, segment-normalization and termination cases are decoded
in `tools/extract.py`. Segment normalization changes segment:offset coordinates,
not the linear output stream position.

The final stub has `RB` at header +0E, the B0/B2 backward run commands, and a
`Packed file is corrupt` failure message. These are strong EXEPACK-family identity
evidence, consistent with the [EXEPACK format analysis](https://www.bamsoftware.com/software/exepack/).
The transformation itself is verified from this asset, not assumed from the name.
Its output length is `22EF * 16`. It preserves a **1040-byte literal prefix** and
expands the remaining bytes backwards. Treating the preserved prefix as zero was
rejected by the independent oracle comparison during development.

EXEPACK relocations are read from the offset explicitly encoded by `MOV SI,0132`
in this stub. Sixteen 64-KiB groups contain counts followed by word offsets. All
123 sites and their order in this packed stream are retained in
`metadata/relocations.json`. This order is not automatically the original linker's
pre-packing relocation emission order. The reconstructed image stores **unrelocated**
segment words; adding the load segment at each listed site yields the loaded image.

The launcher's four stages are independently extracted too; see
`metadata/launcher-extraction.json`. Its final image is 165152 bytes with entry
`0000:0002` and 16 relocations. Launcher ASM reconstruction is still outstanding.

## Independent verification, not a copied runtime snapshot

`tools/verify_unpack.py` creates zeroed memory, loads the original MZ module using its
header, supplies a minimal PSP, and executes the **original unpacking instructions**
in Unicorn. There are no legacy imports, instruction replacement hooks, DOS-service
shortcuts, pre-unpacked binaries or snapshots in the input path. Unexpected
interrupts fail the run. Execution stops before the first real program instruction.

Both programs were checked at load segments `1010` and `2010`. Every final image
byte equals the pure decoder result after applying its relocation list. This also
checks relocation values independently and catches accidentally baked-in load bases.
The initial general-register/PSP model is a documented deterministic test setup,
not a claim that all DOS versions provide identical scratch-register values.

At load 1010, the game passes through CS values 1C32, 1C43, 1B54, 1B65, 1A4F,
23AD, 2376, 32FF, then 1010. Moved stubs execute at offset 002B (LZ) or 0034
(EXEPACK). The normalized CS transitions and full stop registers are recorded in
`build/unpack-verification.json`. The 1-MiB exploratory snapshots in build are
noncanonical scratch and are never consumed by extraction or building.

## What exists at the boundary

The target is the **initialized module immediately before 0000:95C9 executes**,
not a post-menu or post-driver snapshot. It includes initialized code, inline tables,
strings and currently unclassified bytes. Zero bytes expanded by the packer are
initialized data; they must not automatically be called BSS. The original BSS
ownership, complete allocation layout and runtime memory needs remain UNKNOWN.

Observed code address frames are 0000, 0F7F, 1022, 1534 and 153A. These come from
actual reachable far targets and are not proof of original object/SEGDEF boundaries.
The entry loads DS and SS from CS:9596 (relocated value originally 15BC), sets SP
to A278, and begins mixed near/far calls. Far target frame 1534 at startup is visible
as an immediate before relocation; additional aliases/targets are retained in the
machine-readable graph as they are reached. A segment-valued word in a relocation
is not, by itself, proof that the target contains code.

At 0682 the game saves DOS INT08, programs PIT ports 43/40 with control 36 and divisor
4000, and installs CS:06E5. This is documented from its actual instructions, not from
legacy hook names. Other DOS/BIOS interrupts, port accesses, CS writes and possible
code modifications are inventoried in `metadata/xrefs.json`. Dynamic destinations,
keyboard hooks, optional audio drivers and complete runtime-written code variants
are still open work. The initial image oracle does not claim to account for all
later executable bytes loaded or generated during gameplay.

The legacy project's unpack notes were used as leads (notably the final entry and
nested stubs). All image bytes, stage sizes, relocations and entry transfers above
were independently derived from the copied originals and tested against their code.
