"""Turn an address into a named variable and use the name in memory operands.

    python tools/define.py 15BC:98BE InputBits byte INPUT_BITS
    python tools/define.py 95BC VideoAdapter word VIDEO_ADAPTER --apply

The address (segment:offset or main-image offset) must lie in initialized data written as
db/dw rows; the row is split so the variable gets its own line. If an include constant is
given, `cs:[CONST]`/`ds:[CONST]` operands in files of the same segment become `[Name]`,
and the constant is removed from its include when nothing else uses it. Run
`python tools/externs.py --apply` and `python tools/verify.py` afterwards. Needs a build.
"""
from common import *
from where import listing_entries, resolve
import re, sys

FRAMES = {'MAIN': 0x0000, 'FAR0F7F': 0x0F7F, 'SLOT1022': 0x1022, 'SEG1534': 0x1534, 'SEG153A': 0x153A, 'DATA': 0x15BC}

def rows(src, lst, start):
    """(line index, image offset, byte count) for each db/dw row of `src`."""
    L = src.read_bytes().decode('latin-1').split('\r\n'); seen = {}; offs = {}
    for off, emits, depth, text in listing_entries(lst):
        if depth or not emits: continue
        key = text.strip(); seen[key] = seen.get(key, 0) + 1; offs.setdefault((key, seen[key]), off)
    cnt = {}; out = []
    for i, l in enumerate(L):
        key = l.split(';', 1)[0].strip(); cnt[key] = cnt.get(key, 0) + 1
        m = re.fullmatch(r'(?:\w+ )?(db|dw) (.+)', key)
        if m and (key, cnt[key]) in offs:
            n = len(m[2].split(',')) * (2 if m[1] == 'dw' else 1)
            out.append((i, start + offs[(key, cnt[key])], n))
    return L, out

def main(argv):
    apply = '--apply' in argv; argv = [a for a in argv if a != '--apply']
    addr, name, kind = argv[:3]; const = argv[3] if len(argv) > 3 else None
    size = {'byte': 1, 'word': 2}[kind]
    src, lst, off = resolve(addr)
    start = next(int(l.split()[1], 16) for l in (ROOT/'build/asm/layout.txt').read_text().splitlines() if l.split()[0] == src.name)
    lin = start + off
    L, table = rows(src, lst, start)
    hit = [(i, a, n) for i, a, n in table if a <= lin < a + n]
    if not hit: raise SystemExit(f'{addr}: not inside a db/dw row of {src.name}')
    i, a, n = hit[0]
    if lin + size > a + n: raise SystemExit(f'{addr}: {kind} crosses the end of its row; split by hand')
    code, _, comment = L[i].partition(';')
    m = re.fullmatch(r'\s*(?:(\w+) )?(db|dw) (.+)', code.rstrip())
    if m[1]: raise SystemExit(f'{addr}: row already named {m[1]}')
    vals = [v.strip() for v in m[3].split(',')]
    if m[2] == 'dw':
        if size != 2 or (lin - a) % 2: raise SystemExit('dw rows can only become word variables')
        k = (lin - a) // 2; before, item, after = vals[:k], vals[k], vals[k+1:]
        new = ([f'    dw {", ".join(before)}'] if before else []) + [f'{name} dw {item}'] + ([f'    dw {", ".join(after)}'] if after else [])
    else:
        k = lin - a; before, item, after = vals[:k], vals[k:k+size], vals[k+size:]
        if size == 2:
            lo, hi = (int(v.rstrip('hH'), 16) for v in item); item = [f'0{hi << 8 | lo:04X}h']
        new = ([f'    db {",".join(before)}'] if before else []) + [f'{name} {"db" if size == 1 else "dw"} {item[0]}'] + ([f'    db {",".join(after)}'] if after else [])
    if comment.strip(): new[0] += ' ;' + comment
    j = i - 1
    while j >= 0 and re.fullmatch(r'\s+db .*', L[j].split(';', 1)[0]): j -= 1
    if j >= 0 and L[j].startswith('; UNKNOWN'):   # keep the rest of an UNKNOWN run marked
        named = next(k for k, t in enumerate(new) if not t.startswith(' '))
        if named + 1 < len(new) or re.fullmatch(r'\s+db .*', L[i+1].split(';', 1)[0]):
            new.insert(named + 1, L[j])
    L[i:i+1] = new
    edits = {src: L}
    if const:
        seg = next(l.split()[0] for l in L if re.fullmatch(r'\w+ segment \w+ public .*', l))
        for f in [ROOT/'src'/l.strip() for l in (ROOT/'src/sources.txt').read_text().splitlines() if l.strip() and not l.startswith('#')]:
            T = edits.get(f) or f.read_bytes().decode('latin-1').split('\r\n')
            if seg == 'DATA' or seg in ' '.join(T[:40]):
                pat = re.compile(r'\b(cs|ds|es|ss):\[' + re.escape(const) + r'\]')
                T2 = [pat.sub(lambda mm: f'{mm[1]}:[{name}]', t) if t.startswith('    ') else t for t in T]
                if T2 != T: edits[f] = T2
    for f, T in edits.items():
        print(f'{f.name}: {sum(1 for x, y in zip(T, f.read_bytes().decode("latin-1").split(chr(13) + chr(10))) if x != y)} lines changed')
        if apply: f.write_bytes('\r\n'.join(T).encode('latin-1'))
    if const and apply:
        still = any(re.search(r'\b' + re.escape(const) + r'\b', f.read_text(encoding='latin-1')) for f in (ROOT/'src').rglob('*.ASM'))
        if not still:
            for inc in (ROOT/'include').glob('*.INC'):
                t = inc.read_bytes().decode('latin-1').split('\r\n')
                t2 = [l for l in t if not re.fullmatch(re.escape(const) + r' equ .*', l)]
                if t2 != t: inc.write_bytes('\r\n'.join(t2).encode('latin-1')); print(f'removed {const} from {inc.name}')

if __name__ == '__main__': main(sys.argv[1:])
