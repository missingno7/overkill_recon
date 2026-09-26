"""Exact acceptance: does the maintained source build to the original program?

1. Original assets and local tools match their pinned hashes.
2. A fresh extraction of the original matches metadata/oracle.json (image hash,
   length, entry point, ordered relocation sites).
3. The linked main image equals the extracted image byte for byte, and the EXE entry
   point equals the original's. Every relocation the linker emits is an original one;
   originals not yet emitted lie in bytes still written as numbers or UNKNOWN db.
4. Each optional sound module assembles to its decoded original resource.
Source text is otherwise free: names, comments, labels and file layout may change.
"""
from common import *
from extract import extract
from build import assemble, assemble_driver, main_sources, DRIVERS
from resources import driver
import re

def check_hashes(manifest):
    for row in read_json(ROOT/'metadata'/manifest)['files']:
        data = (ROOT/row['path']).read_bytes()
        if len(data) != row['size'] or sha(data) != row['sha256']: raise ValueError('Hash mismatch: ' + row['path'])

def check_sources():
    """Original bytes may not enter through the assembler; count UNKNOWN bytes."""
    unknown = 0
    for path in main_sources() + list(DRIVERS.values()) + list((ROOT/'include').glob('*.INC')):
        text = path.read_text(encoding='latin-1'); low = text.lower()
        for bad in ('incbin', 'include assets', 'include ../', 'include ..\\'):
            if bad in low: raise ValueError(f'Forbidden directive {bad!r} in {path.name}')
        in_unknown = False
        for line in text.splitlines():
            code = line.split(';', 1)[0].strip()
            if line.startswith('; UNKNOWN'): in_unknown = True; continue
            if line.startswith(';'): in_unknown = False  # a descriptive comment ends the run
            if not code: continue
            if in_unknown and code.lower().startswith('db '):
                if path in main_sources(): unknown += len(code[3:].split(','))
            else: in_unknown = False
    return unknown

def first_differences(expected, actual, limit=5):
    out = [f'length {len(actual)} != {len(expected)}'] if len(actual) != len(expected) else []
    i = 0
    while i < min(len(expected), len(actual)) and len(out) < limit:
        if expected[i] != actual[i]:
            j = i
            while j < min(len(expected), len(actual)) and expected[j] != actual[j]: j += 1
            out.append(f'{i:05X}..{j:05X}: expected {expected[i:j][:8].hex()} got {actual[i:j][:8].hex()}'); i = j
        else: i += 1
    return out

def verify():
    check_hashes('inputs.json'); check_hashes('toolchain-lock.json')
    unknown = check_sources()
    expected, manifest = extract(output=ROOT/'build/oracle/OVERKILL')
    if manifest != read_json(ROOT/'metadata/oracle.json'): raise ValueError('Fresh extraction differs from metadata/oracle.json')
    header, actual, relocations = assemble()
    diff = first_differences(expected, actual)
    if diff: raise AssertionError('Main image mismatch:\n  ' + '\n  '.join(diff))
    if (header['cs'], header['ip']) != (manifest['entry_cs'], manifest['entry_ip']):
        raise AssertionError(f"Entry {header['cs']:04X}:{header['ip']:04X} differs from the original")
    extra = sorted(set(relocations) - set(manifest['relocations']))
    if extra: raise AssertionError('Relocations not in the original: ' + ' '.join(f'{x:05X}' for x in extra))
    print(f'PASS main image: {len(actual)} bytes exact, entry {header["cs"]:04X}:{header["ip"]:04X}, '
          f'{len(relocations)}/{len(manifest["relocations"])} relocations linked; {unknown} bytes still UNKNOWN db')
    for name in DRIVERS:
        want, _ = driver(name); got = assemble_driver(name)
        diff = first_differences(want, got)
        if diff: raise AssertionError(f'{name} mismatch:\n  ' + '\n  '.join(diff))
        print(f'PASS {name}: {len(got)} bytes exact')

if __name__ == '__main__':
    verify()
