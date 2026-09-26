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

The launcher's two trailing bytes are the checksum word ChecksumFileOrAbort verifies
(sum from 1234h, per byte AX += b then AH += AL, over all preceding bytes); the last
word of OVERKILL is the same checksum over that file. Both are preserved and hashed. The large game suffix is a data container,
not a second MZ image and not proved to be linker-managed executable overlays.
tools/resources.py decodes its resource directory and the optional sound modules
(ADLIB.ENC, ROLAND.ENC), which src/drivers/ reconstructs exactly. The supplied documentation describes the game and
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
123 sites and their order in this packed stream are pinned in
`metadata/oracle.json`. This order is not automatically the original linker's
pre-packing relocation emission order. The reconstructed image stores **unrelocated**
segment words; adding the load segment at each listed site yields the loaded image.

The launcher's four stages can be extracted too (see git history for the former
launcher extraction). Its final image is 165152 bytes with entry `0000:0002` and 16
relocations. The launcher is outside this reconstruction: the game's side of its
interface (binary option bytes at PSP:81h, see ProgramEntry) and the checksum the game
verifies (ChecksumFileOrAbort) are in the source; its own code is not reconstructed.

The pure decoder in `tools/extract.py` was checked once against the original unpacking
instructions executed in an emulator (every byte matched); `tools/extract.py` plus
metadata/oracle.json is the maintained oracle.

## What exists at the boundary

The target is the **initialized module immediately before 0000:95C9 executes**,
not a post-menu or post-driver snapshot: initialized code, inline tables, strings and
zero-filled areas. The image does not say which zero bytes the original declared as
uninitialized (BSS); the source writes them as initialized data, and segments the game
allocates at run time (workspace, sprite banks, panels) are allocated in the source.

Observed code address frames are 0000, 0F7F, 1022, 1534 and 153A. These come from
actual reachable far targets and are not proof of original object/SEGDEF boundaries.
The entry loads DS and SS from CS:9596 (relocated value originally 15BC), sets SP
to A278, and begins mixed near/far calls. Far target frame 1534 at startup is visible
as an immediate before relocation. A segment-valued word in a relocation is not, by
itself, proof that the target contains code.

After the entry, startup decodes ADLIB.ENC or ROLAND.ENC (from the SHADOW container,
see tools/resources.py) into the 1022 frame (SLOT1022.ASM); src/drivers/ reconstructs
both modules exactly. The game writes no code at run time other than that module load.
Interrupt, port and DOS behaviour is documented at its sites in the source.

## Link structure and the relocation invariant

The EXEPACK stream stores relocations in 64 KiB groups, so their packed order says
little about the linker. Inside each group, however, the original order is not sorted:
it runs MAIN 0041..52CC, 0F7F F7F4..F824, MAIN 52D0..8D86, 0F7F F949..FFF4,
MAIN 9592..D695, 0F7F 100BD..1020C. TLINK emits fixups per object module, in module
order and segment order inside a module (confirmed by a two-module experiment), so
this pattern is evidence for at least three link modules that each contribute to
both MAIN and the 0F7F far segment. src/MODULE1..3.ASM reproduce that minimum; the
original may have had more modules (see the alignment evidence below).

Boundaries: MAIN 52CF is exact (between SaveHiscoreFile and LoadHiscoreFile);
the MAIN 2/3 split lies somewhere in 8D88..9592 (9592 chosen; the lone 00h at 9591
may be alignment padding); far splits lie in F826..F949 (F87C chosen, after the
settings/hiscore far helpers) and FFF6..100BD (1000D chosen). Any split inside those
ranges links identically: the chosen points are not unique. More modules than three
are possible; the pattern only proves a lower bound. Module names are modern.

TASM 1.0 (and 2.0 /m) emit a far fixup for a forward-referenced label in the same
module after the backward ones, which leaves 2 of the linked relocations out of the
original relative order. A two-pass assembler such as MASM would not; this is weak
evidence about the original toolchain, not a requirement. Therefore:

- Acceptance: the set of relocations TLINK emits equals the original 123 sites.
- Relocation order is reported as evidence only.

All 18 `jmp word ptr cs:[bx + table]` tables in MAIN are preceded by one 90h byte and
start at an even absolute address, including seven between 52CF and 9591, while code
begins at the odd address 52CF (no padding after SaveHiscoreFile's `ret`). If those
fillers are assembler `even` directives, the modules holding them started at even
addresses, so the original had more link modules than the three the relocation
runs prove. MODULE2 keeps the fillers as explicit `db 90h` because `even` there would
align relative to 52CF.

The far code at 0F7F:0980 (ShowPageList, linear 10170) starts on a paragraph after 14
zero bytes that MODULE3 cannot produce (its far part starts at the odd address 1000D):
a separate paragraph-aligned module (MODULE4.ASM) makes TLINK emit exactly that
padding, which is further evidence of more link modules than the relocation runs prove.

TASM 1.0 assembles the whole MAIN segment as one 16,800-line file (0.8 s, ample
memory), so file boundaries are a readability and evidence choice, not a tool limit.
