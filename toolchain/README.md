# Local tools

- TASM.EXE (TASM 1.0, identical to C:/tools/tasm-1.00) assembles all sources.
- nmlgcdos/msdos.exe (from C:/tools/nmlgcdos) runs TASM.
- TLINK.EXE (TLINK 2.0) links the objects; msdos-i86/msdos.exe (the i86 MS-DOS Player)
  runs it.
- ndisasm.exe (with msys-2.0.dll, NASM-LICENSE.txt) serves `tools/where.py --disasm`,
  which disassembles image bytes during investigation (NASM syntax, not TASM).

- watcom/BINNT/WCC.EXE and watcom/BINB/WCC.EXE (Watcom C16 10.0a, from C:/tools/watcom-10.0a)
  compile c/ for the DOS hybrid; pinned in metadata/c-toolchain-lock.json and used only by
  tools/hybrid.py.

These are local task dependencies, not claims about Overkill's historical tools.
Do not redistribute the historical binaries. Every file is hashed in
metadata/toolchain-lock.json and checked by tools/verify.py.
