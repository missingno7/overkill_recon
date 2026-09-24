# Native DOS swap-unit experiment

The tested unit supports **SWAP_VERIFIED_C under the reviewed caller contract**.
One nontrivial original game-logic routine can be replaced by ordinary native DOS
C plus a mechanical ABI bridge inside the same executable. This is evidence for
one incremental replacement, not a claim that every ASM label is replaceable,
that gameplay is fully verified, or that the exact ASM phase is complete.

Production remains unchanged: the 143,088-byte normalized main image, its 123
ordered relocation sites, AdLib and Roland keep their existing exact acceptance.
No production source, verifier or runtime harness imports this experiment.

## Unit and boundary

Chosen region: `0000:9CF1..9D4C`, **AdvancePositionHistoryIfRequested**, 92 bytes,
22 instructions. It is already reviewed GAME_LOGIC with ordered memory updates
and six conditional branches. It uses neither ports nor platform services. The
four cursors belong to the 48-pair position history consumed by later record
updates. Their entity roles are not guessed.

`build_swap.py` checks every recovered graph edge into the region. The sole
external edge is the near CALL at `9BDF`; no decoded entry targets its interior.
There are no calls or outgoing jumps, and the two exits are RET at `9CFF` and
`9D4C`. The prior routine ends at `9CF0` with RET. Thus enlargement was unnecessary.
Unknown executable bytes and unresolved indirect sites elsewhere prevent a
universal hidden-entry proof; the classification is scoped to this reviewed edge.

| Boundary component | Contract |
|---|---|
| Entry | Near call at `9CF1`, normal caller `9BDF` |
| State inputs | DS:98BE input byte, DS:A360 adjustment word, four word cursors at DS:A33A/A33C/A33E/A340 |
| Decision | Advance when the input low nibble or adjustment word is nonzero |
| Mutation | In address order, add four modulo 65536; replace exactly A33A with A27A |
| Memory effects | Four increment writes, plus each required wrap write; no writes on inactive path |
| Preserved | AX/BX/CX/DX/SI/DI/BP, DS/ES/SS, control flags, caller stack balance |
| Exit | Same near-return continuation, `9BE2` on the known caller |
| Arithmetic flags | Modified by ASM, dead at this caller; overwritten by the ADD in the next helper `9CD9` |
| External effects | None; no calls, interrupts, ports or callbacks inside the original unit |

Register preservation is deliberately conservative. We did not discard a scratch
register merely because one subsequent instruction happens to overwrite it.
At `9BE2`, the next CALL enters `9CD9`; its initial MOV/MOV/MOV instructions do not
consume flags, and its ADD overwrites the arithmetic flags before any use.
Differential tests also execute this unchanged continuation and compare all flags.

The state cells occupy distinct fixed addresses. Input and adjustment do not
alias cursors. Cursor *values* may coincide and need not be valid ring pointers:
C preserves the original mechanical equality-only wrapping over the entire word
domain. Ordinary history interpretation uses the initialized 48 aligned values.

The normal game establishes DS/SS at startup and SP=A278. The C bridge additionally
needs writable, unaliased temporary stack space. Measured depth from the caller's
SP is **38 bytes**, versus **2** for ASM. Tests check a 64-byte scratch envelope,
vary the incoming SP and cover both equal and different DS/SS. This is an explicit
capacity obligation for integration and future replacements, not a proof of
unbounded nesting or unused memory on every unknown path. No replacement of SS,
private runtime stack, or interrupt masking is introduced. Tests do not establish
arbitrary interrupt-interleaving or cycle equivalence. Known cursor producers are
initialization and this main update; no IRQ-driven cursor producer is established.

## Clean C and residual

The canonical source is [HISTORY.C](../research/swap_unit/HISTORY.C):

```c
void advance_history(volatile HistoryCursors far *c, u8 input, u16 adjustment)
{
    if (!(input & 15) && !adjustment) return;
    c->write += 4;
    if (c->write == 0xa33a) c->write = 0xa27a;
    c->delayed15 += 4;
    if (c->delayed15 == 0xa33a) c->delayed15 = 0xa27a;
    c->delayed31 += 4;
    if (c->delayed31 == 0xa33a) c->delayed31 = 0xa27a;
    c->other47 += 4;
    if (c->other47 == 0xa33a) c->other47 = 0xa27a;
}
```

The four fields are native unsigned 16-bit offsets. A compile-time width check
rejects an incompatible unsigned-int size. `volatile` retains the ordered initial
increment and possible wrap store; there is no hidden arithmetic in the bridge.
Natural C and final C are identical. No source shaping or matching recipe was used.

Compiler: pinned **Turbo C 2.0**, small model, 8086, near cdecl functions and an
explicit far state pointer: `-c -ms -1- -f- -N- -O -Z -G-`. Compilation uses nmlgc
MS-DOS Player; linking uses the existing pinned TLINK runner. No CRT is linked.
Generated source listings and objects are kept in `build/swap_unit/compile`.

| Residual category | Observed difference |
|---|---|
| SEMANTIC | No known difference in the tested boundary domain; trigger, constants, four mutations, wrap predicates and ordered writes agree |
| ABI | Original implicit DS globals become a far pointer and two C value arguments |
| ABI | Bridge preserves registers/segments and control flags; far entry gate adapts to the original near return |
| CODEGEN | BP frame, four LES BX reloads, and ES:[BX+field] addressing replace absolute DS accesses |
| CONTROL_FLOW_SHAPE | C shares one epilogue; original has two RET sites |
| CODEGEN | Dead arithmetic flags differ at unit return and agree after the unchanged caller continuation |
| PLATFORM | Newly generated DOS container needs its authentic trailing integrity checksum recomputed |
| UNKNOWN | Undecoded inbound edges, all interrupt interleavings and all-path stack capacity are not proved |

Original: **92 bytes / 22 instructions**. Ordinary C body: **102 bytes / 28
instructions**. ABI bridge: **42 bytes / 30 instructions**. Entry routing: six
bytes (CALL FAR, RET) replacing the first six original bytes. The rest of the
unit's old bytes remain visibly present but unreachable from its normal C entry.
They are not a fallback selected on difficult inputs.

The body mismatch is modest and intelligible. It does not suggest missing game
semantics or require another algorithm. Exact-body matching would require
specializing argument locations, rewriting memory addressing, removing the frame
and controlling epilogue layout. The previous matching study found this borderline;
this pass does not implement or rely on those transformations. Swappability is
useful without them. The generated residual is a report, not executable input.

## Synthetic verification

[verify_swap.py](../research/swap_unit/verify_swap.py) loads both actual generated
MZ executables and applies their relocation tables. It enters the unchanged CALL
at `9BDF`, executes the selected implementation, observes `9BE2`, and for valid
history cursors continues through the original `9CD9` helper to `9BE5`.

The **104,544** cases comprise:

- 48 valid cursor phases x 256 input bytes x three adjustment values: 36,864;
- all sixteen independent wrap masks and four trigger combinations, with DS/SS separated: 64;
- all 65,536 word values in each cursor position, via shifted permutations: 65,536;
- deterministic random independent cursor phases, triggers, registers and segments: 2,048;
- IF/DF/control-flag combinations on active and inactive paths: 32.

All original 22 instruction sites, both exits and every conditional path are
reached. Checks compare every general/segment register, SP and exit, control flags
at unit return, ordered non-stack writes, and the complete DS/SS memory windows
except the explicitly private 64-byte below-SP scratch envelope. Write hooks reject
any mutation outside the expected history cells and that scratch envelope. Valid
cursor tests compare all flags and memory again after the authentic next helper.
Out-of-ring cursor tests stop at unit return rather than invoking a consumer with
invalid pointers. Hooks reject unexpected interrupts/port effects.

A deliberately changed generated ADD immediate (4 to 5) must fail. The first
negative-control attempt exposed emulator translation caching after a host code
edit; it did not detect the edit. The corrected check uses a fresh CPU instance
and does detect it. That harness correction is retained. No C semantic correction
was needed. Passing tests are bounded evidence, not a formal equivalence proof.

## Real native build and packaging finding

```powershell
python research/swap_unit/build_swap.py --implementation ASM
python research/swap_unit/build_swap.py --implementation C
python research/swap_unit/run.py
```

The last command reproduces the entire experiment from maintained ASM and pinned
inputs. Outputs are `build/swap_unit/asm/PLAY.EXE` and `build/swap_unit/c/PLAY.EXE`.
They contain ordinary 8086 native code. There is no interpreter inside either game.
The emulator is used only by verification.

Both packages put the same 512-byte modern prefix before the unchanged main image.
That prefix holds the launch entry, bridge and compiled C body, padded with zeros.
Only C mode calls the C body. Each original segment relocation target is adjusted
by 20h paragraphs. Consequently the original relocation at `95F0`, used by DOS
AH=4A resizing, retains the prefix automatically. No game resize instruction or
allocation limit is patched. All relative game addresses remain the same.

Normalizing those relocation adjustments reproduces Oracle A exactly in ASM mode.
In C mode only the six entry-gate bytes differ. The preserved main payload still
has the production project's explicit UNKNOWN DB regions; this experiment does
not reclassify them as understood source.

The original resource overlay is appended with every directory/resource byte
unchanged. Both folders contain the same built MZ as `OVERKILL`, since original
startup opens that filename. The pinned original launcher `OVERKILL.EXE` is also
provided: original startup reads its integrity/registration data. Start `PLAY`,
which executes rebuilt main code. No original packed game or launcher code is
executed in the bounded PLAY verification.

The first package failed the original integrity check. Static inspection of
`C8D5/C916..C91F/C938..C94C` established a rolling checksum seeded with 1234h,
stored in the file's final word. The independently implemented rule matches both
pinned originals (OVERKILL: 925Ah; launcher: A605h). The resource directory proves
the last resource ends at file-size minus two. Recomputing only this footer for
the new container fixes packaging without bypassing the check or changing a
resource. This was a missing executable-container requirement, not a C bug.

## Bounded integration and limits

Both actual generated packages execute authentic startup through **0000:9690**
under the existing modeled DOS/BIOS/port environment, with Tandy + AdLib + keyboard.
The native prefix supplies the compact PSP tail. The original resource decoder
loads the correct AdLib image; it matches the independently extracted module.
The original DOS resize retains the prefix, and both variants stop at the same
frontier with the same instruction count.

The main state differs only at the six entry bytes and four integrity-scratch
bytes (`C88C/C88D`, `C890/C891`). These scratch words are independently checked
against the actual per-file checksum formulas, not ignored by a generic allowlist.
Their different values are expected consequences of different file contents.
Known xrefs keep these words inside the checksum routine. Global unknown-code
consumers are not disproven.

Startup does **not** call this gameplay routine. Integration certifies the real
native packaging/loading/startup; synthetic full-image execution certifies the
actual selected entry, caller and continuation. No claim is made that a natural
gameplay frame, rendering, music timing or every interrupt schedule was tested.
We deliberately did not replay the game to manufacture broader coverage.

## Outcome and next boundary

**SWAP_VERIFIED_C**, scoped to the reviewed entry and tested observable contract.
The unchanged caller can use either implementation; local boundary comparisons
agree, and both native game packages build and reach the bounded startup frontier.
The exact production verifier also passes independently: 36 tests, all normalized
main bytes and both optional modules, zero mismatches.

This is a practical puzzle piece, with measurable ABI cost and explicit proof
limits. It supports repeating the method on another closed unit, not designing a
matching language or adopting a broad source architecture. The next useful target
is the `9CD9` position store plus `A031` delayed-position application: first review
whether their scratch outputs and sequential alias effects call for a larger
closed cluster. Do not discard those effects or guess entity identities to obtain
a prettier C interface.
