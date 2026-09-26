"""Find the source line that assembles to an address, using the last build's listings.

    python tools/where.py 9C01          main-image offset (frame 0000 offset for 0000:xxxx)
    python tools/where.py 0F7F:0030     segment:offset, converted to an image offset
    python tools/where.py --adlib 0571  offset inside an optional sound module

Prints file:line and the surrounding source. Run tools/build.py (or verify.py) first.
"""
from common import *
import re, sys

LINE = re.compile(r'^[ 1-9]\s*\d+ ')

def listing_entries(lst):
    """Yield (offset or None, emits_bytes, depth, source_text) for each listing line."""
    for raw in lst.read_text(encoding='latin-1').split('\n'):
        if not LINE.match(raw): continue
        offset = raw[8:12].strip(); data = raw[14:37].strip(); text = raw[37:].split(';', 1)[0].rstrip()
        yield (int(offset, 16) if re.fullmatch(r'[0-9A-F]{4}', offset) else None, bool(data), raw[0] != ' ', text)

def locate(src, lst, offset):
    """Return the 1-based source line of the first byte-emitting line at `offset`."""
    seen = {}; last = None
    for off, emits, depth, text in listing_entries(lst):
        if depth:  # macro expansion: its bytes belong to the invoking source line
            if off == offset and emits and last: break
            continue
        key = text.strip(); seen[key] = seen.get(key, 0) + 1; last = (key, seen[key]) if key else None
        if off == offset and emits and key: break
    else: return None
    key, count = last; n = 0
    for i, line in enumerate(src.read_text(encoding='latin-1').split('\n')):
        if line.split(';', 1)[0].strip() == key:
            n += 1
            if n == count: return i + 1
    return None

def resolve(arg, driver=None):
    if driver:
        return ROOT/f'src/drivers/{driver.upper()}.ASM', ROOT/f'build/driver-asm/{driver}/{driver.upper()}.LST', int(arg, 16)
    if ':' in arg:
        seg, off = (int(v, 16) for v in arg.split(':')); linear = seg*16 + off
    else: linear = int(arg, 16)
    rows = [l.split() for l in (ROOT/'build/asm/layout.txt').read_text().splitlines()]
    name, start = max(((n, int(s, 16)) for n, s in rows if int(s, 16) <= linear), key=lambda r: r[1])
    return ROOT/'src'/name, ROOT/'build/asm'/(name[:-4] + '.LST'), linear - start

if __name__ == '__main__':
    args = sys.argv[1:]; driver = None
    if args and args[0] in ('--adlib', '--roland'): driver = args.pop(0)[2:]
    src, lst, offset = resolve(args[0], driver)
    n = locate(src, lst, offset)
    if not n: raise SystemExit(f'{args[0]}: no instruction or data line starts there in {src.name}')
    lines = src.read_text(encoding='latin-1').split('\n')
    print(f'{src.relative_to(ROOT)}:{n}')
    for i in range(max(0, n - 6), min(len(lines), n + 6)):
        print(('>' if i + 1 == n else ' '), lines[i].rstrip())
