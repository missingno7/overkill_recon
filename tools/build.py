"""Assemble with TASM 1.0 and link with TLINK, both under local MS-DOS Players.

Main program: every file in src/sources.txt is assembled, then TLINK links the objects
in that order into build/asm/OVERKILL.EXE. The EXE load module is the program image.
Files that share a segment name form one segment (one address frame of the original).
Optional sound modules are separate single-file programs, linked the same way.
Listings (.LST) and the TLINK map land in the build directory for address lookup.
No bytes from the original assets enter the build.
"""
from common import *
from dos import dos
from extract import mz
import re, shutil

def main_sources():
    lines = (ROOT/'src/sources.txt').read_text().splitlines()
    return [ROOT/'src'/l.strip() for l in lines if l.strip() and not l.startswith('#')]

DRIVERS = {'adlib': ROOT/'src/drivers/ADLIB.ASM', 'roland': ROOT/'src/drivers/ROLAND.ASM'}

def assemble_and_link(paths, build, exe):
    """Assemble `paths` in `build`, link them into `exe`; return (header, image, relocations)."""
    build.mkdir(parents=True, exist_ok=True)
    for include in (ROOT/'include').glob('*.INC'):
        shutil.copyfile(include, build/include.name)
    for path in paths:
        shutil.copyfile(path, build/path.name)
        obj = build/(path.stem + '.OBJ'); obj.unlink(missing_ok=True)
        log = dos('TASM.EXE', [f'{path.name},{path.stem}.OBJ,{path.stem}.LST'], build)
        (build/(path.stem + '.log')).write_text(log)
        if not obj.exists(): raise ValueError(f'TASM failed for {path.name}; see {build/(path.stem + ".log")}')
    stem = exe[:-4]; (build/exe).unlink(missing_ok=True)
    (build/'LINK.RSP').write_text('+\n'.join(p.stem + '.OBJ' for p in paths) + f'\n{exe}\n{stem}.MAP\n')
    log = dos('TLINK.EXE', ['/s', '@LINK.RSP'], build)
    (build/(stem + '.log')).write_text(log)
    if re.search(r'^(Error|Fatal)', log, re.M) or not (build/exe).exists(): raise ValueError('TLINK failed:\n' + log)
    header, image, relocations, _ = mz((build/exe).read_bytes())
    return header, image, relocations

def assemble():
    header, image, relocations = assemble_and_link(main_sources(), ROOT/'build/asm', 'OVERKILL.EXE')
    (ROOT/'build/program.bin').write_bytes(image)
    # file, segment, image start and length of every contribution, for tools/where.py
    names = {p.stem.upper(): p.name for p in main_sources()}
    rows = [f'{names[m[5].upper()]} {m[4]} {int(m[1], 16)*16 + int(m[2], 16):05X} {m[3]}' for m in re.finditer(
        r'^([0-9A-F]{4}):([0-9A-F]{4}) ([0-9A-F]{4}) C=\w+ S=(\w+) .*M=(\w+)\.ASM', (ROOT/'build/asm/OVERKILL.MAP').read_text(), re.M)]
    (ROOT/'build/asm/layout.txt').write_text('\n'.join(rows) + '\n')
    return header, image, relocations

def assemble_driver(name):
    _, image, _ = assemble_and_link([DRIVERS[name]], ROOT/'build/driver-asm'/name, name.upper() + '.EXE')
    (ROOT/'build'/f'{name}.bin').write_bytes(image)
    return image

if __name__ == '__main__':
    print('Linked', len(assemble()[1]), 'bytes')
    for name in DRIVERS: print(name, len(assemble_driver(name)), 'bytes')
