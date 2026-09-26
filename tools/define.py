"""Give a name to data at an address, and use the name where an include constant was used.

    python tools/define.py 15BC:98BE InputBits byte [INPUT_BITS] [--apply]
    python tools/define.py 15BC:98C4 KeyDownTable label:128 [KEY_DOWN_TABLE] [--apply]

byte/word isolate one variable on its own line; label:N names a table, string or record
of N bytes. If the bytes were in an UNKNOWN run, the rest of the run stays marked. The
address must lie in a db/dw row. With a
constant, its uses in segment blocks of the same segment (all files for DATA) are
rewritten: inside [...] to the name, elsewhere to `offset Name`; the constant is dropped
from its include when no code uses it any more. --apply rebuilds first. Afterwards run
`python tools/externs.py --apply` and `python tools/verify.py`.
"""
from common import *
from where import resolve, layout, lines_by_offset
import re, sys

MARK = '; UNKNOWN: not yet classified as code or data'
SEGLINE = re.compile(r'(\w+) segment \w+ public .*')

def segment_of_lines(L):
    seg = None; out = []
    for l in L:
        m = SEGLINE.fullmatch(l)
        if m: seg = m[1]
        out.append(seg)
        if seg and l == f'{seg} ends': seg = None
    return out

def rewrite(line, const, name):
    code, sep, comment = line.partition(';')
    parts = re.split(r'(\[[^\]]*\])', code)
    tok = re.compile(r'(?<![\w@])' + re.escape(const) + r'(?![\w])')
    parts = [tok.sub(name, p) if p.startswith('[') else tok.sub('offset ' + name, p) for p in parts]
    return ''.join(parts) + sep + comment

def main(argv):
    apply = '--apply' in argv; argv = [a for a in argv if a != '--apply']
    addr, name, kind = argv[:3]; const = argv[3] if len(argv) > 3 else None
    if apply:   # listing offsets must match the current source
        from build import assemble; assemble()
    src, lst, seg, off, lin = resolve(addr); start = lin - off
    L = src.read_bytes().decode('latin-1').split('\r\n')
    rows = [(start + o, n - 1) for o, n in lines_by_offset(src, lst, seg)]
    i = max((k for a, k in rows if a <= lin), default=None)
    a = next(a for a, k in rows if k == i)
    code, _, comment = L[i].partition(';')
    m = re.fullmatch(r'\s*(?:(\w+) )?(db|dw) (.+)', code.rstrip())
    if not m: raise SystemExit(f'{addr}: not inside a db/dw row ({L[i].strip()[:50]})')
    width = 2 if m[2] == 'dw' else 1
    vals = [v.strip() for v in m[3].split(',')]
    k, rem = divmod(lin - a, width)
    if rem: raise SystemExit(f'{addr}: inside a dw item')
    length = int(kind.split(':')[1].rstrip('hH'), 16 if kind.lower().endswith('h') else 10) if kind.startswith('label:') else None
    size = {'byte': 1, 'word': 2}.get(kind)
    if kind.startswith('label') and length is None: raise SystemExit('label needs a length: label:N')
    if size and size % width: raise SystemExit('a byte variable cannot be cut from a dw row')
    take = min(len(vals) - k, -(-length // width)) if size is None else size // width
    if k + take > len(vals): raise SystemExit(f'{addr}: {kind} crosses the end of its row; split by hand')
    if size == 2 and width == 1:
        lo, hi = (int(v.rstrip('hH'), 16) for v in vals[k:k+2]); item = [f'0{hi << 8 | lo:04X}h']; d = 'dw'
    else: item = vals[k:k+take]; d = m[2]
    before, after = vals[:k], vals[k+take:]
    if m[1] and k == 0:   # row already named here: add an alias label in front
        new = [f'{name} label {"word" if width == 2 else "byte"}', L[i]]
    else:
        new = ([f'    {m[2]} {",".join(before)}'] if before else []) + [f'{name} {d} {",".join(item)}'] + \
              ([f'    {m[2]} {",".join(after)}'] if after else [])
        if m[1]: new[0] = f'{m[1]} {m[2]} {",".join(before)}'
        if comment.strip(): new[-1 if after else 0] += ' ;' + comment
    j = i - 1
    while j >= 0 and re.fullmatch(r'\s+d[bw] .*', L[j].split(';', 1)[0]): j -= 1
    unknown = j >= 0 and L[j].startswith('; UNKNOWN')
    if unknown and after:   # keep the rest of an UNKNOWN run marked
        new.insert(len(new) - 1, MARK)
    L[i:i+1] = new
    if unknown and not before and j == i - 1:   # the named item now heads the run
        del L[j]; i -= 1; j = -1
    if unknown and length is not None:   # re-mark the run after the named N bytes
        left = length - len(item) * width; r = i + len(new)
        while left > 0 and r < len(L) and re.fullmatch(r'\s+db .*', L[r].split(';', 1)[0]):
            v = [x.strip() for x in L[r].split(';', 1)[0].strip()[3:].split(',')]
            if len(v) <= left: left -= len(v); r += 1; continue
            L[r:r+1] = ['    db ' + ','.join(v[:left]), MARK, '    db ' + ','.join(v[left:])]; left = 0; r = None; break
        if r is not None and r < len(L) and re.fullmatch(r'\s+db .*', L[r].split(';', 1)[0]): L.insert(r, MARK)
    edits = {src: L}
    if const:
        own_seg = segment_of_lines(L)[i]
        for f in dict.fromkeys(ROOT/'src'/r[0] for r in layout()):
            T = edits.get(f) or f.read_bytes().decode('latin-1').split('\r\n')
            segs = segment_of_lines(T)
            T2 = [rewrite(t, const, name) if t.startswith('    ') and (own_seg == 'DATA' or s == own_seg) else t for t, s in zip(T, segs)]
            if T2 != T: edits[f] = T2
    for f, T in edits.items():
        print(f'{f.name}: {sum(1 for t in T if name in t)} lines mention {name}')
        if apply: f.write_bytes('\r\n'.join(T).encode('latin-1'))
    if const and apply:
        code = '\n'.join(l.split(';', 1)[0] for f in (ROOT/'src').rglob('*.ASM') for l in f.read_text(encoding='latin-1').splitlines())
        if not re.search(r'(?<![\w@])' + re.escape(const) + r'(?![\w])', code):
            for inc in (ROOT/'include').glob('*.INC'):
                t = inc.read_bytes().decode('latin-1').split('\r\n')
                t2 = [l for l in t if not re.fullmatch(re.escape(const) + r' equ .*', l)]
                if t2 != t: inc.write_bytes('\r\n'.join(t2).encode('latin-1')); print(f'removed {const} from {inc.name}')

if __name__ == '__main__': main(sys.argv[1:])
