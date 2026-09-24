# Reconstruction status

This is an exact, incomplete ASM bootstrap. Byte coverage and semantic understanding are separate.

| Metric | Value |
|---|---:|
| program_image_bytes_accounted | 143088 |
| decoded_instruction_bytes | 25564 |
| reconstructed_asm_bytes | 36551 |
| opaque_raw_fallback_bytes | 106537 |
| identified_functions | 371 |
| named_functions | 26 |
| anonymous_functions | 345 |
| leaf_functions | 143 |
| C_READY | 2 |
| C_READY_WITH_ENV | 19 |
| ASM_COUPLED | 15 |
| HARDWARE | 62 |
| STRUCTURAL | 98 |
| UNKNOWN | 175 |
| semantically_supported_unique_instruction_bytes | 756 |
| unresolved_indirect_sites | 45 |
| decode_conflicts | 0 |

Build: **PASS**. Normalized program image: **BYTE_EXACT_NORMALIZED_PROGRAM_IMAGE**.
Known mismatching ranges: []. Packed original file: **not rebuilt**.

Every one of the 143,088 initialized image bytes has a source-map owner. UNKNOWN ranges use visible DB declarations and count as opaque. The instruction denominator for the whole game is not yet known. No 100% code-recovery claim is made.

Function entries and boundaries remain candidates unless the symbol evidence says otherwise. A static leaf can still depend on machine flags, asynchronous writes, shared memory or unobserved indirect control flow. C_READY does not mean C source has been produced.

Recreate this report with `python tools/verify.py`. Full independent unpack, toolchain experiments and semantic checks: `python tools/verify.py --full`.

Next: resolve remaining indirect tables with bounded-index evidence; recover keyboard/vector callbacks; account for runtime-written code; promote exact data extents and prove more leaf contracts. Whole-file repacking remains a separate unmet milestone.

## Active runtime view

The initial-entry inventory above retains 371 function candidates. The active main runtime graph has **421 candidates**, with **10987 additional identified instruction bytes**. This is reachability evidence, not a new main-code variant.

Maintained main instruction source: **36551 bytes**; explicit main UNKNOWN DB: **106537 bytes**. Initial plus runtime discovery identifies 36551 instruction bytes. See metadata/runtime/observed-coverage.json for actual execution coverage.

| Module | Total bytes | Instruction ASM | Reviewed data | Opaque bytes | Functions | Named | Leaf |
|---|---:|---:|---:|---:|---:|---:|---:|
| adlib | 16318 | 1166 | 56 | 15096 | 15 | 6 | 2 |
| roland | 14594 | 741 | 0 | 13853 | 17 | 0 | 4 |

Module totals include data and UNKNOWN bytes; they are separate input artifacts that occupy a versioned slot, not extra simultaneous main-image space. Future-C classes are recorded separately per module in metadata/status.json.

Runtime verifier: **PASS**. This verifies the reproducible candidate 9690 frontier and ASM correspondence, not global stability.

Active queues: metadata/runtime/bottom-up-queue.json and metadata/drivers/*-bottom-up-queue.json. Initial/cold inventory is retained for provenance. See [runtime-materialization.md](runtime-materialization.md) for the exact watch scope and untested paths.
