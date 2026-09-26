"""Answer questions about an address, using the last build (run tools/build.py or verify.py).

    python tools/where.py 9C01               source line, enclosing label and context
    python tools/where.py 0F7F:0030          segment:offset works too
    python tools/where.py 50CC --disasm 40   disassemble 40 bytes there (NASM syntax, ndisasm)
    python tools/where.py 50CC --refs        direct references to it found in the linked image
    python tools/where.py --adlib 0571       an address inside an optional sound module

Addresses are image offsets of the linked program (frame 0000 offsets for main code).
--refs scans raw bytes, so it also finds references from still-undecoded code; hits in
db rows or data are candidates, not proof.
"""
from common import *
import re, subprocess, sys

LINE = re.compile(r'^[ 1-9]\s*\d+ ')

def listing_entries(lst):
    """Yield (offset or None, emits_bytes, depth, source code text, segment) per listing line."""
    seg = None
    for raw in lst.read_text(encoding='latin-1').split('\n'):
        if not LINE.match(raw): continue
        offset = raw[8:12].strip(); data = raw[14:37].strip(); text = raw[37:].split(';', 1)[0].rstrip()
        top = raw[0] == ' '
        m = re.fullmatch(r'\s*(\w+) segment .*', text) if top else None
        if m: seg = m[1]
        yield (int(offset, 16) if re.fullmatch(r'[0-9A-F]{4}', offset) else None, bool(data), not top, text, seg)
        if top and re.fullmatch(r'\s*\w+ ends', text): seg = None

def lines_by_offset(src, lst, segment=None):
    """[(offset, 1-based source line)] for byte-emitting lines of `segment`, in order."""
    seen = {}; last = None; hits = []
    for off, emits, depth, text, seg in listing_entries(lst):
        if depth == 0:
            key = text.strip()
            if key: seen[key] = seen.get(key, 0) + 1; last = (key, seen[key])
        if emits and off is not None and last and (segment is None or seg == segment) and (not hits or hits[-1][1] != last):
            hits.append((off, last))
    counts = {}; where = {}
    for i, line in enumerate(src.read_text(encoding='latin-1').split('\n')):
        key = line.split(';', 1)[0].strip()
        if key: counts[key] = counts.get(key, 0) + 1; where[(key, counts[key])] = i + 1
    return [(off, where[k]) for off, k in hits if k in where]

def locate(src, lst, offset, segment=None):
    """1-based source line of the byte-emitting line containing `offset` (or None)."""
    best = None
    for off, line in lines_by_offset(src, lst, segment):
        if off <= offset: best = line
        else: break
    return best

def layout():
    """[(file, segment, image start, length)] of every linked contribution."""
    return [(r[0], r[1], int(r[2], 16), int(r[3], 16)) for r in (l.split() for l in (ROOT/'build/asm/layout.txt').read_text().splitlines())]

def frames():
    """(start, end, frame paragraph) of each linked segment, from the TLINK map."""
    return [(int(m[1], 16), int(m[2], 16), int(m[1], 16) >> 4) for m in
            re.finditer(r'^\s*([0-9A-F]{5})H ([0-9A-F]{5})H ([0-9A-F]{5})H (\w+)', (ROOT/'build/asm/OVERKILL.MAP').read_text(), re.M)]

def resolve(arg, driver=None):
    """(source, listing, segment, offset within the contribution, image offset)."""
    if driver:
        return ROOT/f'src/drivers/{driver.upper()}.ASM', ROOT/f'build/driver-asm/{driver}/{driver.upper()}.LST', None, int(arg, 16), int(arg, 16)
    if ':' in arg:
        seg, off = (int(v, 16) for v in arg.split(':')); linear = seg*16 + off
    else: linear = int(arg, 16)
    name, seg, start, _ = next(r for r in layout() if r[2] <= linear < r[2] + r[3])
    return ROOT/'src'/name, ROOT/'build/asm'/(name[:-4] + '.LST'), seg, linear - start, linear

def source_line(linear):
    src, lst, seg, off, _ = resolve(f'{linear:X}')
    n = locate(src, lst, off, seg)
    text = src.read_text(encoding='latin-1').split('\n')[n-1].rstrip() if n else ''
    return src, n, text

def enclosing_label(src, n):
    lines = src.read_text(encoding='latin-1').split('\n')
    for i in range(n - 1, -1, -1):
        m = re.fullmatch(r'([A-Za-z_]\w*)(?::| d[bw] .*| label \w+)\s*', lines[i].split(';', 1)[0].rstrip())
        if m: return m[1], n - i - 1
    return None, None

def refs(linear):
    img = (ROOT/'build/program.bin').read_bytes(); fr_all = frames()
    fr = next(f for f in fr_all if f[0] <= linear <= f[1]); off = linear - fr[2]*16
    hits = []
    for p in range(len(img) - 2):
        b = img[p]
        if not (b in (0xE8, 0xE9, 0xEB, 0x9A, 0xEA) or 0x70 <= b <= 0x7F or 0xE0 <= b <= 0xE3): continue
        pf = next((f for f in fr_all if f[0] <= p <= f[1]), None)
        if pf == fr and b in (0xE8, 0xE9) and (p + 3 - fr[2]*16 + int.from_bytes(img[p+1:p+3], 'little')) & 0xFFFF == off:
            hits.append((p, 'near call' if b == 0xE8 else 'near jmp'))
        elif pf == fr and (b == 0xEB or 0x70 <= b <= 0x7F or 0xE0 <= b <= 0xE3) and p + 2 - fr[2]*16 + int.from_bytes(img[p+1:p+2], 'little', signed=True) == off:
            hits.append((p, 'short branch'))
        elif b in (0x9A, 0xEA) and p + 5 <= len(img) and int.from_bytes(img[p+1:p+3], 'little') == off and int.from_bytes(img[p+3:p+5], 'little') == fr[2]:
            hits.append((p, 'far call' if b == 0x9A else 'far jmp'))
    words = [p for p in range(len(img) - 1) if int.from_bytes(img[p:p+2], 'little') == off]
    return hits, words

def main(args):
    driver = None
    if args and args[0] in ('--adlib', '--roland'): driver = args.pop(0)[2:]
    addr = args[0]
    src, lst, seg, off, linear = resolve(addr, driver)
    if '--disasm' in args:
        n = int(args[args.index('--disasm') + 1], 0)
        binary = ROOT/(f'build/{driver}.bin' if driver else 'build/program.bin')
        origin = 0 if driver else next(f for f in frames() if f[0] <= linear <= f[1])[2] * 16
        out = subprocess.run([str(ROOT/'toolchain/ndisasm.exe'), '-b16', '-e', str(linear), '-o', str(linear - origin), str(binary)],
                             capture_output=True, text=True).stdout.splitlines()
        shown = 0
        for l in out:
            if shown >= n: break
            print(l); shown += len(l.split()[1]) // 2 if len(l.split()) > 1 else 1
        return
    if '--refs' in args:
        hits, words = refs(linear)
        for p, kind in hits:
            s, n, text = source_line(p); print(f'{kind:12} at {p:05X}  {s.name}:{n}  {text.strip()}')
        print(f'{len(words)} raw words equal the offset (possible pointers or data): ' +
              ' '.join(f'{w:05X}' for w in words[:24]) + (' ...' if len(words) > 24 else ''))
        return
    n = locate(src, lst, off, seg)
    if not n: raise SystemExit(f'{addr}: no source line found in {src.name}')
    lines = src.read_text(encoding='latin-1').split('\n')
    label, dist = enclosing_label(src, n)
    print(f'{src.relative_to(ROOT)}:{n}' + (f'  (in {label}, {dist} lines below it)' if label else ''))
    for i in range(max(0, n - 6), min(len(lines), n + 6)):
        print(('>' if i + 1 == n else ' '), lines[i].rstrip())

if __name__ == '__main__': main(sys.argv[1:])
