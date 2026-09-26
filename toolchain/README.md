# Local tools

- TASM.EXE (TASM 1.0, identical to C:/tools/tasm-1.00) assembles all sources.
- nmlgcdos/msdos.exe (from C:/tools/nmlgcdos) runs TASM.
- TLINK.EXE (TLINK 2.0) links the objects; msdos-i86/msdos.exe (the i86 MS-DOS Player)
  runs it.
- ndisasm.exe (with msys-2.0.dll, NASM-LICENSE.txt) disassembles UNKNOWN bytes during
  investigation. Its NASM syntax must be adapted to TASM; the exact build checks it.

These are local task dependencies, not claims about Overkill's historical tools.
Do not redistribute the historical binaries. Every file is hashed in
metadata/toolchain-lock.json and checked by tools/verify.py.
