"""Recompute the extrn/public lines of every main-program source after moving or naming code.

A file may hold several segment blocks. Each file gets `public` for its labels used by
other files; `extrn Name:near` inside a block for code labels of the same segment defined
in another file; `extrn Name:byte|word` for data labels (inside the block of their segment
when the file has one); `extrn Name:far` before the first segment for code in another
segment. Short branches cannot reach another file and are reported.

    python tools/externs.py            # show what would change
    python tools/externs.py --apply
"""
from common import *
import re, sys

SEGLINE = re.compile(r'(\w+) segment \w+ public .*')
DEF = re.compile(r'([A-Za-z_]\w*)(:| label (\w+)| (d[bw]) .*)')
IDENT = re.compile(r'(?<![\w@])([A-Za-z_]\w*)')
SHORTB = re.compile(r'^    (?:jmp short|j(?!mp)[a-z]+|loop[a-z]*) (\w+)$')

def blocks(t):
    """Yield (line index, segment or None) for every line."""
    seg = None
    for i, l in enumerate(t):
        m = SEGLINE.fullmatch(l)
        if m: seg = m[1]
        yield i, seg
        if seg and l == f'{seg} ends': seg = None

def main(apply):
    order = [l.strip() for l in (ROOT/'src/sources.txt').read_text().splitlines() if l.strip() and not l.startswith('#')]
    texts = {n: [l for l in (ROOT/'src'/n).read_bytes().decode('latin-1').split('\r\n') if not l.startswith(('public ', 'extrn '))] for n in order}
    owner = {}   # label -> (file, segment, kind)
    seen = {}    # upper-case label -> defining file (TASM names are case-insensitive)
    for n, t in texts.items():
        for i, seg in blocks(t):
            m = DEF.fullmatch(t[i].split(';', 1)[0].rstrip())
            if m and not t[i].startswith(' '):
                if m[1].upper() in seen and seen[m[1].upper()] != n:
                    raise SystemExit(f'{m[1]} is defined in both {seen[m[1].upper()]} and {n}')
                seen[m[1].upper()] = n
                owner[m[1]] = (n, seg, {'db': 'byte', 'dw': 'word', 'byte': 'byte', 'word': 'word'}.get(m[4] or m[3], 'code'))
    idents = {n: {x for l in t for x in IDENT.findall(l.split(';', 1)[0])} for n, t in texts.items()}
    for n, t in texts.items():
        uses = {}    # label -> set of referencing segments
        for i, seg in blocks(t):
            code = t[i].split(';', 1)[0]
            if not code.startswith('    '):
                m = re.fullmatch(r'[A-Za-z_]\w* (d[bw] .*)', code.rstrip()); code = '    ' + m[1] if m else ''
            for x in IDENT.findall(code):
                if x in owner and owner[x][0] != n: uses.setdefault(x, set()).add(seg)
            m = SHORTB.match(t[i])
            if m and m[1] in owner and owner[m[1]][0] != n: raise SystemExit(f'{n}: short branch to external {m[1]}')
        near = {}; outside = []
        for x, segs in sorted(uses.items()):
            _, oseg, kind = owner[x]
            if kind != 'code':
                target = oseg if any(s == oseg for s in segs) else None
                (near.setdefault(target, []) if target else outside).append(f'extrn {x}:{kind}')
            elif oseg in segs: near.setdefault(oseg, []).append(f'extrn {x}:near')   # other segments may use its offset
            else: outside.append(f'extrn {x}:far')
        pub = sorted(x for x, (f, _, _) in owner.items() if f == n and any(x in idents[m] for m in texts if m != n))
        out = []; first = True
        for i, seg in blocks(t):
            l = t[i]
            if SEGLINE.fullmatch(l) and first: out += outside; first = False
            out.append(l)
            if l.startswith('assume cs:'):
                if pub: out += [f'public {p}' for p in pub]; pub = []
                out += near.get(seg, [])
        print(n, 'extrn', sum(len(v) for v in near.values()) + len(outside))
        if apply: (ROOT/'src'/n).write_bytes('\r\n'.join(out).encode('latin-1'))

if __name__ == '__main__': main('--apply' in sys.argv)
