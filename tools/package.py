"""Package a linked game EXE as a runnable OVERKILL next to the original launcher.

The original OVERKILL file is the packed program followed by the SHADOW resource
container; the game finds the container at its own MZ-declared size and checks the
file's last word (ChecksumFileOrAbort). A runnable copy is therefore: the linked EXE
(unpacked is fine), the original container bytes, and a recomputed checksum word.
OVERKILL.EXE (the launcher) and OVERKILL.DOC are copied unchanged.

    python tools/package.py build/asm/OVERKILL.EXE build/run/oracle
"""
from common import *
import shutil, struct, sys

def checksum(data):
    """Sum from 1234h: per byte AX += b, then AH += AL (ChecksumFileOrAbort)."""
    ax = 0x1234
    for b in data:
        ax = (ax + b) & 0xFFFF
        ax = ((((ax >> 8) + ax) & 0xFF) << 8) | (ax & 0xFF)
    return ax

def mz_size(data):
    pages, last = struct.unpack_from('<HH', data, 4)[0], struct.unpack_from('<H', data, 2)[0]
    return (pages - 1) * 512 + last

def package(exe_path, out_dir):
    original = (ROOT/'assets/OVERKILL').read_bytes()
    container = original[mz_size(original):-2]
    exe = bytearray(Path(exe_path).read_bytes())
    if len(exe) != mz_size(exe) and not (len(exe) % 512 == 0 and exe[2:4] == b'\0\0'):
        raise ValueError('EXE size differs from its MZ header')
    if len(exe) % 512 == 0:
        # The game computes the container base as (pages - 1) * 512 + last-page bytes, which
        # is wrong for a zero last-page field: keep the EXE off a page boundary.
        exe += b'\0'; struct.pack_into('<HH', exe, 2, len(exe) % 512, (len(exe) + 511) // 512)
    body = bytes(exe) + container
    out = Path(out_dir); out.mkdir(parents=True, exist_ok=True)
    (out/'OVERKILL').write_bytes(body + struct.pack('<H', checksum(body)))
    for name in ('OVERKILL.EXE', 'OVERKILL.DOC'):
        shutil.copyfile(ROOT/'assets'/name, out/name)
    return out/'OVERKILL'

if __name__ == '__main__':
    print(package(sys.argv[1], sys.argv[2]))
