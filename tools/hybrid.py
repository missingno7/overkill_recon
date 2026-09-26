"""Build the DOS hybrid: the frozen ASM oracle with C-owned routines replaced by C.

The oracle sources are never edited. For the hybrid build they are copied into
build/hybrid/ and every routine the C side owns is cut out of the copy:

  - `c/*.c` declare what they own in a comment line `OWNS: Label Label ...`
    (the entry labels plus every label and table inside the replaced code);
  - an owned range runs from an owned label to the next label that is not owned
    (the comment block in front of that next label stays with it);
  - code that fell through into a removed range gets an explicit `jmp`, short and
    conditional jumps into it become near jumps, and `public` lines for removed
    labels become `extrn`, so the rest of the ASM reaches the same labels, now
    defined by the region's bridge c/<region>.asm (ASM calling contract -> C function).

Then TASM assembles the derived ASM and the bridge, the C compiler compiles c/*.c
(into MAIN, or into the far code segment a `SEGMENT: NAME` line names; see far_bridge),
TLINK links everything into one EXE with the oracle's link order, and
tools/package.py makes it runnable next to the original launcher.

    python tools/hybrid.py            build build/hybrid/OVERKILL.EXE and build/run/hybrid
"""
from common import *
from build import main_sources
from dos import dos
from package import package
from extract import mz, extract
import os, re, shutil, struct, subprocess

LABEL = re.compile(r'^([A-Za-z_]\w*)(?::|\s+label\b|\s+(?:db|dw|dd)\b)', re.I)
UNCONDITIONAL = re.compile(r'^\s+(jmp|ret|retf|iret)\b', re.I)
JUMP = re.compile(r'^(\s+)(j[a-z]+)\s+(?:short\s+|near\s+ptr\s+)?([A-Za-z_]\w*)\s*$', re.I)
OPPOSITE = {'je': 'jne', 'jz': 'jnz', 'jne': 'je', 'jnz': 'jz', 'jb': 'jae', 'jc': 'jnc', 'jnae': 'jae',
            'jae': 'jb', 'jnb': 'jb', 'jnc': 'jc', 'ja': 'jbe', 'jnbe': 'jbe', 'jbe': 'ja', 'jna': 'ja',
            'jl': 'jge', 'jnge': 'jge', 'jge': 'jl', 'jnl': 'jl', 'jg': 'jle', 'jnle': 'jle', 'jle': 'jg',
            'jng': 'jg', 'js': 'jns', 'jns': 'js', 'jo': 'jno', 'jno': 'jo', 'jp': 'jnp', 'jpe': 'jnp',
            'jnp': 'jp', 'jpo': 'jp'}

def owned_labels(c_dir=ROOT/'c'):
    owned = {}
    for path in sorted(c_dir.glob('*.c')):
        for m in re.finditer(r'OWNS:([^\n*]*)', path.read_bytes().decode('latin-1')):
            for name in m[1].split(): owned[name.upper()] = path.name
    return owned

def code_segment(path):
    """Code segment of a C region: MAIN, or the far segment named by a `SEGMENT: NAME` line."""
    m = re.search(r'SEGMENT:[ \t]*(\w+)', path.read_bytes().decode('latin-1'))
    return m[1].upper() if m else 'MAIN'

def code(line):
    return line.split(';', 1)[0]

def derive(text, owned):
    """Return (derived text, removed labels) for one oracle source file."""
    lines = text.split('\r\n')
    out, removed, skipping = [], [], False
    for i, line in enumerate(lines):
        m = LABEL.match(line)
        name = m[1].upper() if m else None
        if name and name in owned:
            if not skipping:
                # Fall-through into the removed range: continue at the C side explicitly.
                # The comment block in front of a removed label belongs to it.
                while out and out[-1].startswith(';'): out.pop()
                prev = next((l for l in reversed(out) if code(l).strip()), '')
                if not UNCONDITIONAL.match(prev):
                    out.append(f'    jmp {m[1]}')
            skipping = True; removed.append(m[1]); continue
        if name and skipping and not name.startswith('@@'):
            skipping = False
            # Keep the comment block that precedes this surviving label.
            j = i
            while j > 0 and lines[j - 1].startswith(';'): j -= 1
            out.extend(lines[j:i])
        if skipping: continue
        out.append(line)
    gone = {n.upper() for n in removed}
    result = []
    for line in out:
        m = re.match(r'^public\s+(\w+)\s*$', line, re.I)
        if m and m[1].upper() in gone: continue
        j = JUMP.match(code(line))
        if j and j[3].upper() in gone:
            op = j[2].lower()
            if op == 'jmp':
                if re.search(r'\bshort\b', line, re.I): line = f'{j[1]}jmp {j[3]}'
            elif op in OPPOSITE:
                n = len(result)
                result += [f'{j[1]}{OPPOSITE[op]} @@hybridSkip{n}', f'{j[1]}jmp {j[3]}', f'@@hybridSkip{n}:']
                continue
            else:
                raise ValueError(f'cannot redirect {line.strip()!r} into removed code')
        result.append(line)
    text = '\r\n'.join(result)
    refs = sorted(n for n in removed if re.search(r'\b' + n + r'\b', '\n'.join(code(l) for l in result), re.I))
    if refs:
        at = text.index('locals\r\n') + len('locals\r\n')
        text = text[:at] + ''.join(f'extrn {n}:near\r\n' for n in refs) + text[at:]
    return text, removed

def c_expr(value):
    """TASM equ value -> C expression (hex 0C0h -> 0xC0, 'a' stays a char constant)."""
    return re.sub(r"\b([0-9][0-9A-Fa-f]*)[hH]\b", lambda m: '0x' + m[1].upper(), value.strip())

def equates():
    """(name, value) of every numeric equ in include/*.INC, in file order."""
    rows = []
    for path in sorted((ROOT/'include').glob('*.INC')):
        for m in re.finditer(r'^(\w+)[ \t]+equ[ \t]+([^;\r\n]+)', path.read_bytes().decode('latin-1'), re.M):
            rows.append((m[1], m[2].strip()))
    return rows

def state_labels():
    """(name, C type, is_array) for every label of the state segment (DATA.ASM)."""
    rows = []
    for m in re.finditer(r'^([A-Za-z_]\w*)[ \t]+(db|dw|dd|label)[ \t]+([^;\r\n]*)',
                         (ROOT/'src/DATA.ASM').read_bytes().decode('latin-1'), re.M):
        name, kind, rest = m[1], m[2].lower(), m[3].strip()
        if kind == 'label':
            if rest.lower() not in ('byte', 'word'): continue
            rows.append((name, rest.lower(), True)); continue
        ctype = {'db': 'byte', 'dw': 'word', 'dd': 'dword'}[kind]
        scalar = ',' not in rest and 'dup' not in rest.lower() and "'" not in rest
        rows.append((name, ctype, not scalar))
    return rows

def generate_header(out_dir=ROOT/'build/hybrid'):
    """build/hybrid/GAME_GEN.H: the C view of the oracle's constants, record layout and
    state-segment labels, derived from include/*.INC and src/DATA.ASM (never edited)."""
    out = ['/* Generated by tools/hybrid.py from the include files and src/DATA.ASM; do not edit. */',
           '#ifndef GAME_GEN_H', '#define GAME_GEN_H',
           'typedef unsigned char byte;', 'typedef signed char sbyte;',
           'typedef unsigned short word;', 'typedef signed short sword;', 'typedef unsigned long dword;',
           '#define STATIC_CHECK(name, cond) typedef char name[(cond) ? 1 : -1]', '']
    eq = equates()
    for name, value in eq: out.append(f'#define {name} ({c_expr(value)})')
    # The 38h-byte record: one word per REC_* offset; role aliases name the same word.
    fields = sorted((int(c_expr(v), 16) if c_expr(v).startswith('0x') else int(v), n)
                    for n, v in eq if n.startswith('REC_') and re.fullmatch(r'[0-9A-Fa-f]+h?', v))
    out += ['', 'typedef struct Record {']
    at = 0
    for off, name in fields:
        assert off == at and off % 2 == 0, ('record fields must be consecutive words', name)
        out.append(f'    word {name[4:].lower()};  /* {off:02X}h {name} */'); at += 2
    out += ['} Record;', 'STATIC_CHECK(record_size, sizeof(Record) == RECORD_SIZE);']
    for off, name in fields:
        out.append(f'STATIC_CHECK(at_{name[4:].lower()}, (unsigned)&((Record *)0)->{name[4:].lower()} == {name});')
    for name, value in eq:
        if name.startswith('REC_') and value.startswith('REC_'):
            out.append(f'#define {name[4:].lower()} {value[4:].lower()}  /* role alias of {value} */')
    out += ['']
    for name, ctype, array in state_labels():
        out.append(f'extern {ctype} {name}{"[]" if array else ""};')
    out += ['#endif', '']
    path = out_dir/'GAME_GEN.H'; path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes('\r\n'.join(out).encode('latin-1'))
    return path

def publish_labels(text):
    """Derived copy: make every global label of the file public (no bytes change), so C can
    name any state label and the differential tests can enter any routine by name."""
    public = {m.upper() for m in re.findall(r'^public\s+(\w+)', text, re.M | re.I)}
    defined = [m for m in (LABEL.match(l) for l in text.split('\r\n')) if m]
    names = [m[1] for m in defined if not m[1].startswith('@@') and m[1].upper() not in public]
    at = re.search(r'^locals[ \t]*\r?\n', text, re.M).end()
    return text[:at] + ''.join(f'public {n}\r\n' for n in dict.fromkeys(names)) + text[at:]

def check_c_object(path, segment='MAIN'):
    """C objects must add code to their code segment only: no data segments with content,
    no local (static) symbols, no communal data (TLINK 2.0 cannot link LPUBDEF/LEXTDEF/
    COMDEF). Returns the public names (the C functions)."""
    data = path.read_bytes(); names = ['']; publics = []; i = 0
    while i < len(data):
        kind, size = data[i], struct.unpack_from('<H', data, i + 1)[0]
        body = data[i + 3:i + 3 + size - 1]
        if kind in (0xB0, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8):
            raise ValueError(f'{path.name}: record {kind:02X}h (static or communal symbol) is not allowed')
        if kind == 0x96:
            j = 0
            while j < len(body): n = body[j]; names.append(body[j + 1:j + 1 + n].decode('latin-1')); j += 1 + n
        if kind == 0x98:
            length = struct.unpack_from('<H', body, 1)[0]; name = names[body[3]]
            if length and name != segment:
                raise ValueError(f'{path.name}: C data in segment {name} ({length} bytes); C owns no data')
        if kind == 0x90:
            j = 2 if body[1] else 4    # group and segment index (one byte each here), frame if absolute
            while j < len(body):
                n = body[j]; publics.append(body[j + 1:j + 1 + n].decode('latin-1').upper()); j += 1 + n + 3
        i += 3 + size
    return publics

def far_bridge(text, functions, segment):
    """Bridge of a region placed in a far code segment: the stubs stay in MAIN (the oracle
    labels and their near contracts are unchanged), each `call` to a C function becomes a
    far call to a generated far entry `<FUNCTION>_FAR: call <FUNCTION> / retf` in the
    region's segment, next to the C code."""
    targets = set()
    def far_call(m):
        if m[3].upper() not in functions: return m[0]
        if m[2].lower() != 'call': raise ValueError(f'bridge jumps into far C code: {m[0].strip()!r}')
        targets.add(m[3].upper()); return f'{m[1]}call far ptr {m[3].upper()}_FAR'
    lines = [re.sub(r'^(\s+)(j\w+|call)\s+(?:short\s+|near\s+ptr\s+)?([A-Za-z_]\w*)\s*(?=;|$)', far_call, line, flags=re.I)
             for line in text.split('\r\n')]
    at = max(i for i, l in enumerate(lines) if re.match(r'^end\b', l, re.I))
    entries = [f'{segment} segment byte public \'CODE\'', f'assume cs:{segment}']
    for name in sorted(targets):
        entries += [f'public {name}_FAR', f'{name}_FAR:', f'    call {name}', '    retf']
    return '\r\n'.join(lines[:at] + entries + [f'{segment} ends'] + lines[at:])

def watcom(args, cwd):
    for row in read_json(ROOT/'metadata/c-toolchain-lock.json')['files']:
        blob = (ROOT/row['path']).read_bytes()
        if len(blob) != row['size'] or sha(blob) != row['sha256']: raise ValueError('Hash mismatch: ' + row['path'])
    env = {k: v for k, v in os.environ.items() if k.upper() in ('SYSTEMROOT', 'WINDIR', 'TEMP', 'TMP', 'COMSPEC')}
    env['WATCOM'] = str(ROOT/'toolchain/watcom')
    p = subprocess.run([str(ROOT/'toolchain/watcom/BINNT/WCC.EXE'), *args], cwd=cwd, env=env, capture_output=True)
    text = (p.stdout + p.stderr).decode('cp437', errors='replace')
    if p.returncode: raise RuntimeError('WCC failed:\n' + text)
    return text

WCC_OPTIONS = ['-ms', '-0', '-s', '-zl', '-zld', '-zq', '-ox', '-w4', '-we', '-nc=CODE']

def build(out=ROOT/'build/hybrid', with_c=True, c_dir=ROOT/'c'):
    """Derive, compile, assemble and link. with_c=False builds the symbol-complete oracle
    (every label public, nothing owned by C), which must equal the exact oracle image."""
    out.mkdir(parents=True, exist_ok=True)
    owned = owned_labels(c_dir) if with_c else {}
    generate_header(out)
    for include in (ROOT/'include').glob('*.INC'): shutil.copyfile(include, out/include.name)
    objects, removed_all = [], []
    for path in main_sources():
        text, removed = derive(path.read_bytes().decode('latin-1'), owned)
        (out/path.name).write_bytes(publish_labels(text).encode('latin-1')); removed_all += removed
        objects.append(path.stem)
    missing = sorted(set(owned) - {n.upper() for n in removed_all})
    if missing: raise ValueError('OWNS names no oracle label: ' + ' '.join(missing))
    # All C regions compile as one unit and all bridges assemble as one module: TLINK 2.0
    # under the DOS player keeps every object open and fails (it hangs) past 13 objects
    # with a map, so the object count must not grow with the number of regions.
    c_objects, far_objects, names = [], [], set()
    sources = sorted(c_dir.glob('*.c')) if with_c else []
    if sources:
        segments = {code_segment(src) for src in sources}
        if len(segments) != 1: raise ValueError(f'all C regions must share one code segment: {segments}')
        segment = segments.pop()
        (out/'ISLAND.C').write_bytes(''.join(f'#include "{src.name}"\r\n' for src in sources).encode('latin-1'))
        obj = out/'ISLAND.OBJ'; obj.unlink(missing_ok=True)
        watcom(['ISLAND.C', *WCC_OPTIONS, f'-nt={segment}', f'-i={c_dir}', f'-i={out}', '-nm=CISLAND', '-fo=ISLAND.OBJ'], out)
        names = set(check_c_object(obj, segment))
        (c_objects if segment == 'MAIN' else far_objects).append('ISLAND')
        bridges = []
        for bridge in sorted(c_dir.glob('*.asm')):
            lines = bridge.read_bytes().decode('latin-1').replace('\r\n', '\n').split('\n')
            last = max(i for i, l in enumerate(lines) if re.match(r'^end\b', l, re.I))
            bridges += [f'; ---- {bridge.name}'] + lines[:last]
        text = '\r\n'.join(bridges + ['end', ''])
        if segment != 'MAIN': text = far_bridge(text, names, segment)
        (out/'BRIDGES.ASM').write_bytes(text.encode('latin-1')); objects.append('BRIDGES')
    for stem in objects:
        (out/(stem + '.OBJ')).unlink(missing_ok=True)
        log = dos('TASM.EXE', [f'{stem}.ASM,{stem}.OBJ,{stem}.LST'], out)
        if not (out/(stem + '.OBJ')).exists(): raise ValueError(f'TASM failed for {stem}:\n{log}')
    # Segments are placed in order of first appearance: far C segments must precede DATA,
    # because the image (the DOS block the game keeps) ends with DATA and IMAGE_END.
    at = objects.index('DATA')
    objects = objects[:at] + far_objects + objects[at:] + c_objects
    (out/'OVERKILL.EXE').unlink(missing_ok=True)
    (out/'LINK.RSP').write_text('+\n'.join(s + '.OBJ' for s in objects) + '\nOVERKILL.EXE\nOVERKILL.MAP\n')
    log = dos('TLINK.EXE', ['/s', '@LINK.RSP'], out)
    if re.search(r'^(Error|Fatal)', log, re.M) or not (out/'OVERKILL.EXE').exists(): raise ValueError('TLINK failed:\n' + log)
    if not with_c:
        _, image, relocations, _ = mz((out/'OVERKILL.EXE').read_bytes())
        oracle = read_json(ROOT/'metadata/oracle.json')
        if image != extract()[0] or sorted(relocations) != sorted(oracle['relocations']):
            raise ValueError('symbol-complete oracle build differs from the exact oracle')
    return out/'OVERKILL.EXE', removed_all

def build_all():
    """build/oracle-sym (the exact oracle, all labels public) and build/hybrid."""
    oracle, _ = build(ROOT/'build/oracle-sym', with_c=False)
    hybrid, removed = build()
    return oracle, hybrid, removed

if __name__ == '__main__':
    oracle, exe, removed = build_all()
    print('Symbol-complete oracle (exact image):', oracle)
    print('Linked', exe, '-', len(removed), 'oracle labels owned by C')
    # Code segments that hold C (MAIN is limited to 64 KiB; see docs/dos-hybrid.md).
    segments = {code_segment(p) for p in (ROOT/'c').glob('*.c')} | {'MAIN'}
    for m in re.finditer(r'^ \w+H \w+H (\w+)H (\w+)', exe.with_suffix('.MAP').read_text(), re.M):
        if m[2] in segments: print(f'  segment {m[2]}: {m[1].lstrip("0")}h bytes')
    print('Runnable:', package(exe, ROOT/'build/run/hybrid'))
    print('Oracle for comparison:', package(oracle, ROOT/'build/run/oracle'))
