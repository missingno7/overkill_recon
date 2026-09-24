# Local tool provenance

TASM.EXE and TLINK.EXE were copied from D:/prog/empires_reconstruction/toolchain.
Their versions/hashes are independently checked by invocation and the lock file.
The primary DOS assembler runner was copied from C:/tools/nmlgcdos/msdos.exe.
The linker runner was copied from C:/tools/msdos/binary/i86_x64/msdos.exe.
These are local task dependencies, not claims about Overkill's historical tools.
Do not redistribute the local historical binaries without appropriate rights.

NASM 2.16.03 and NDISASM were copied from the existing MSYS2 installation for
inspection/experiments; they are not the production assembler. Its supplied license
is NASM-LICENSE.txt. msys-2.0.dll accompanies those existing executables.

capstone 5.0.6 and unicorn 2.1.4 were downloaded as pinned Win64 wheels from PyPI,
then installed under toolchain/python. Their distribution metadata/licenses are
included. They are analysis and independent verification tools, not runtime game
implementations. Original unpacker instructions are never replaced with hooks.

Every dependency file is hashed in metadata/toolchain-lock.json. Python 3.10+ is a
host prerequisite; the project does not rely on its installation path. All tools
and input assets used by build/verification resolve inside overkill_recon.
