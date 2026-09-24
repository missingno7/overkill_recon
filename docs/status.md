# Reconstruction status

This is an exact, incomplete ASM bootstrap. Byte coverage and semantic understanding are separate.

| Metric | Value |
|---|---:|
| program_image_bytes_accounted | 143088 |
| decoded_instruction_bytes | 25564 |
| reconstructed_asm_bytes | 25564 |
| opaque_raw_fallback_bytes | 117524 |
| identified_functions | 371 |
| named_functions | 16 |
| anonymous_functions | 355 |
| leaf_functions | 143 |
| C_READY | 2 |
| C_READY_WITH_ENV | 9 |
| ASM_COUPLED | 15 |
| HARDWARE | 62 |
| STRUCTURAL | 98 |
| UNKNOWN | 185 |
| semantically_supported_unique_instruction_bytes | 400 |
| unresolved_indirect_sites | 45 |
| decode_conflicts | 0 |

Build: **PASS**. Normalized program image: **BYTE_EXACT_NORMALIZED_PROGRAM_IMAGE**.
Known mismatching ranges: []. Packed original file: **not rebuilt**.

Every one of the 143,088 initialized image bytes has a source-map owner. UNKNOWN ranges use visible DB declarations and count as opaque. The instruction denominator for the whole game is not yet known. No 100% code-recovery claim is made.

Function entries and boundaries remain candidates unless the symbol evidence says otherwise. A static leaf can still depend on machine flags, asynchronous writes, shared memory or unobserved indirect control flow. C_READY does not mean C source has been produced.

Recreate this report with `python tools/verify.py`. Full independent unpack, toolchain experiments and semantic checks: `python tools/verify.py --full`.

Next: resolve remaining indirect tables with bounded-index evidence; recover keyboard/vector callbacks; account for runtime-written code; promote exact data extents and prove more leaf contracts. Whole-file repacking remains a separate unmet milestone.
