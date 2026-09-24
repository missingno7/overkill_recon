# Remaining work, in evidence order

The initial exact ASM bootstrap is accepted. The requested final reconstruction
phase is **not complete**. This file identifies concrete outstanding work rather
than disguising unknown regions as finished reconstruction.

1. Resolve the remaining indirect sites in `metadata/analysis.json`. The initial
   three-way selector pattern is supported at startup but not proved exhaustive.
   Other table lengths require actual bounds from their callers/writers. In
   particular inspect 5AB1/5ADC, AA30, 759B, D5F9, the record-driven callbacks at
   83AC/856F, and the AX/BP bridge at 8D8B/8D8E. Do not scan arbitrary words and
   declare each plausible pointer a function.
2. Recover other installed vectors, especially keyboard handling, from actual
   DOS vector calls or IVT writes. The analyzer currently proves INT08 installation.
3. Decode reachable additions, promote only proved tables/data extents, and drive
   explicit raw source bytes down. The current bootstrap helper can produce a
   candidate transcription, but must not overwrite reviewed source without a diff.
4. Add leaf contracts and tests, then revisit callers. The buffered byte/word
   readers demonstrate why even small helpers may be ASM_COUPLED: their DOS error
   route restores an outer SP and exits through a shared tail.
5. Use CS writes and xrefs to identify self-modifying regions and add versioned
   runtime code evidence. Preserve the original initial image as a distinct oracle.
6. Recover the appended container directory, resource decoding and optional audio
   driver images from original assets. Do not substitute initialized legacy caches.
7. Run real object-topology experiments at supported candidate boundaries. The
   existing tests establish alignment/non-uniqueness behavior, not original module
   ownership. Keep library/runtime identification UNKNOWN until evidenced.
8. Reconstruct the launcher and wrapper source and a deterministic repacking route
   if technically practical. Whole original file identity is still unmet. Any
   compression token recipe or residual wrapper bytes must be explicitly accounted.
9. Build a genuine DOS launchable reconstruction once its header/allocation model
   is supported. `program.bin` is currently a normalized image, not an EXE.

Keep the two independent evidence streams in sync: semantic relationships and
binary/linker constraints. No broad C translation belongs in this phase.
