"""Recompute the extrn/public lines of every main-program source after moving or naming code.

Each file gets `public` for its labels used elsewhere, `extrn Name:near` (inside its segment)
for same-segment labels it uses from other files, and `extrn Name:far` (before the segment,
so the frame comes from the target) for labels in other segments. Short branches cannot
reach another file and are reported.

    python tools/externs.py            # show what would change
    python tools/externs.py --apply
"""
from common import *
import re, sys
APPLY = '--apply' in sys.argv
order = [l.strip() for l in (ROOT/'src/sources.txt').read_text().splitlines() if l.strip() and not l.startswith('#')]
texts = {n: (ROOT/'src'/n).read_bytes().decode('latin-1').split('\r\n') for n in order}
seg = {n: next(l.split()[0] for l in t if re.fullmatch(r'\w+ segment \w+ public .*', l)) for n, t in texts.items()}
LABEL = re.compile(r'([A-Za-z_]\w*)(?::| label \w+| d[bw] .*)')
defined = {n: {m[1] for l in t if (m := LABEL.fullmatch(l.split(';', 1)[0].rstrip())) and not l.startswith(' ')} for n, t in texts.items()}
owner = {d: n for n, ds in defined.items() for d in ds}
IDENT = re.compile(r'(?<![\w@])([A-Za-z_]\w*)')
SHORTB = re.compile(r'^    (?:jmp short|j(?!mp)[a-z]+|loop[a-z]*) (\w+)$')
refs = {}
for n, t in texts.items():
    r = set()
    for l in t:
        code = l.split(';', 1)[0]
        if not code.startswith('    '):  # a named data line: scan its operands
            m = re.fullmatch(r'[A-Za-z_]\w* (d[bw] .*)', code.rstrip())
            code = '    ' + m[1] if m else ''
        r |= {m for m in IDENT.findall(code) if m in owner}
    refs[n] = r - defined[n]
    bad = {m[1] for l in t if (m := SHORTB.match(l))} & refs[n]
    if bad: raise SystemExit(f'{n}: short branch to external {sorted(bad)}')
users = {}
for n, r in refs.items():
    for x in r: users.setdefault(x, set()).add(n)
for n, t in texts.items():
    pub = sorted(d for d in defined[n] if users.get(d, set()) - {n})
    t = [l for l in t if not l.startswith(('public ', 'extrn '))]
    near = [f'extrn {e}:near' for e in sorted(refs[n]) if seg[owner[e]] == seg[n]]
    far = [f'extrn {e}:far' for e in sorted(refs[n]) if seg[owner[e]] != seg[n]]
    k = next(i for i, l in enumerate(t) if l.startswith('assume cs:')) + 1
    t[k:k] = [f'public {p}' for p in pub] + near
    s = next(i for i, l in enumerate(t) if re.fullmatch(r'\w+ segment \w+ public .*', l))
    t[s:s] = far  # outside the segment: frame comes from the target's segment
    ext = near + far
    print(n, 'public', len(pub), 'extrn', len(ext))
    if APPLY: (ROOT/'src'/n).write_bytes('\r\n'.join(t).encode('latin-1'))
