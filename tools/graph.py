"""Migration graph of the frozen ASM oracle: routines, edges, state, platform evidence and
candidate C regions. Everything is derived on each run; nothing is kept by hand.

    python tools/graph.py                 needs build/oracle-sym (python tools/hybrid.py)
    python tools/graph.py --cap 8192      region size cap in bytes (default 6144)
    python tools/graph.py --show NAME     one routine: edges, callers, state, class

Output (generated, not committed): build/graph/graph.json and build/graph/report.md.

Inputs: src/sources.txt and src/*.ASM (statements), build/oracle-sym/OVERKILL.MAP (every
label is public there, so it gives every label's address), build/oracle-sym/*.LST (the
offset of every source line: code and data bytes, and a cross-check of the map),
include/*.INC (field names and values), c/*.c (`OWNS:` lines = the C island).

Units
-----
A *block* runs from one global label to the next in a code segment; its size is the
address distance to the next label (or the segment end), so padding belongs to the block
before it and block sizes sum to the segment sizes. A block whose first statement is an
instruction is code, one whose first statement is db/dw/dd is data, and a label directly
followed by another label is an alias of the block that follows.

A *routine* is a code block plus its embedded code blocks and owned tables: a data block
that contains instructions (a dispatch table followed by the cases it names), or a table
of code offsets referenced only by that routine and placed after it. For C-owned routines,
an adjacent offset table is part of the C routine only when the C `OWNS:` list names it;
unlisted tables can be platform dispatch tables or CS data used through the original
memory interface. Its bytes split into code
(instruction lines) and embedded data (tables, variables and fill inside it). Every other
data block in a code segment is *CS data* (CS-resident variables, buffers, shared
tables): it is not migratable (C owns no data), its bytes are counted separately, and
accesses to it are CS state (cs_read/cs_write), which C cannot reach without ASM help.

Edges (routine -> routine)
--------------------------
call; farcall (`call far ptr`); tail (jmp to another routine); cond (jcc, loop or jcxz to
another routine); fall (the routine's last statement is an instruction that does not end
control flow, i.e. not jmp/ret/retf/iret nor int 20h / int 21h with AH=4Ch, so it runs
into the next block); table (the routine names a table of code offsets, `dw offset X` or
a bare `dw X`, in DS or CS, directly or through nested tables: `jmp word ptr cs:[bx + T]`,
`call word ptr ds:[bx + T]`, `mov dx, offset T`); tramp (`mov R, offset X` then a far
call to a trampoline whose whole body is `call R / retf`, e.g. FarCallMainNearViaAX);
pushret (`mov R, offset X / push R`: X runs when the routine's callee returns); addr (any
other `offset X` of a code label: vector installation, `mov bp, offset X / jmp bp`).

State
-----
Memory operands are classified by instruction: mov and pop to memory write; add, sub,
adc, sbb, and, or, xor, inc, dec, not, neg, shifts, rotates and xchg read and write
(counted as both); cmp, test, push, mul/div, call/jmp through memory and source operands
read; lea and `offset X` only take an address (addr: access unknown, e.g. string
instructions). DS labels are globals; include constants inside a bracket with a base
register (bp/bx/si/di) are fields (REC_* for records, e.g. `ss:[bp + REC_X]`; other
structures' fields are listed but do not count as game state); operands with an `es:`
override are not attributed. Pool access = any access to PoolA, PoolB, PrimaryRecord,
their pointer tables or cursors. Game state = REC fields, pool access or non-platform
globals.

Classification
--------------
Hardware evidence: int, in/out, iret, cli/sti, the segment literals A000h/B000h/B800h, the
CS words ScreenSegment/WorkspaceSegment/VideoAdapter, far calls into or `seg` of the
sound-module slot (segment SLOT1022) and code inside it, and the far->near trampolines.
Platform globals are DS labels accessed only by platform-side routines. Then: platform =
platform-side and no game state; mixed = platform-side with game state (drivers and
renderers that read or write the game's globals or records: they stay ASM, and their
state is the interface); gameplay = everything else. A routine that only calls platform
routines stays gameplay. Platform-side means hardware evidence, or one of three derived
rules, iterated to a fixpoint together with the platform globals:
  helper:  no game state, and every caller is platform or mixed (blitters and decoders
           reached only through the renderer's adapter tables);
  context: no REC field or pool access, and every caller is platform (routines that only
           run inside platform code, e.g. under the timer interrupt);
  entry:   no game state, and its only out-edges are tail/fall/cond into platform code.

Regions
-------
1. Units: gameplay routines not owned by C. Platform and mixed routines stay ASM.
2. Glue (must stay together; union-find): fall and pushret edges, SCCs of more than one
   routine, and tail fragments (a routine entered only by jumps, never called,
   dispatched, fallen into or address-taken) glued to every routine that jumps to it.
   Glue that crosses into platform, mixed or C-owned code is reported, not unioned.
3. Greedy modularity merging of the glue groups (Newman): edge weights call, farcall,
   tramp 1; tail, cond 1.5; addr 0.5; table 0.1; plus state coupling 0.5/(n-1) between
   every pair of the n <= 8 units that access a DS global or CS word one of them writes.
   The pair with the largest modularity gain dQ = w_ab/m - d_a*d_b/(2m^2) is merged while
   dQ > 0 and the result fits in --cap bytes.
4. Per region: bytes, routines, internal and boundary edges, entries from ASM (future
   bridge stubs), calls into gameplay ASM (C -> ASM), platform/mixed callees, shared
   globals, CS words, adjacency to the C island. Ranking score = KB * cohesion * (1.5 if
   adjacent to C) / (1 + 0.5 * entries from ASM + 0.25 * gameplay ASM callees), with
   cohesion = internal / (internal + boundary) edges. Waves: greedy picks down the ranking
   of regions without direct edges between them.
"""
from common import *
import argparse, re
from collections import defaultdict

SYM = ROOT / 'build/oracle-sym'
OUT = ROOT / 'build/graph'

REGS = set('ax bx cx dx si di bp sp al ah bl bh cl ch dl dh cs ds es ss'.split())
KEYWORDS = REGS | {'byte', 'word', 'dword', 'ptr', 'offset', 'seg', 'short', 'near', 'far', 'dup'}
UNCONDITIONAL = {'jmp', 'ret', 'retf', 'retn', 'iret'}
LOOPS = {'loop', 'loope', 'loopne', 'loopz', 'loopnz', 'jcxz'}
PREFIXES = {'rep', 'repe', 'repz', 'repne', 'repnz', 'lock'}
RMW = {'add', 'sub', 'adc', 'sbb', 'and', 'or', 'xor', 'inc', 'dec', 'not', 'neg', 'shl',
       'shr', 'sal', 'sar', 'rol', 'ror', 'rcl', 'rcr', 'xchg'}
WRITE = {'mov', 'pop'}
HW_WORDS = {'SCREENSEGMENT': 'video', 'WORKSPACESEGMENT': 'video', 'VIDEOADAPTER': 'adapter'}
HW_SEGMENTS = {0xA000: 'A000h', 0xB000: 'B000h', 0xB800: 'B800h'}
POOL = {'POOLA', 'POOLB', 'PRIMARYRECORD', 'POOLAPOINTERS', 'POOLBPOINTERS', 'POOLAEND',
        'POOLBEND', 'POOLACURSOR', 'POOLBCURSOR'}
SOUND_SLOT = 'SLOT1022'
EDGE_WEIGHT = {'call': 1.0, 'farcall': 1.0, 'tramp': 1.0, 'tail': 1.5, 'cond': 1.5,
               'addr': 0.5, 'table': 0.1, 'fall': 3.0, 'pushret': 3.0}
STATE_WEIGHT, STATE_FANOUT = 0.5, 8
IDENT = re.compile(r'[A-Za-z_@$?][\w@$?]*')
HEXNUM = re.compile(r'^[0-9][0-9A-Fa-f]*[hH]?$')
DIRECTIVE = re.compile(r'^(public|extrn|include|locals|assume|end)\b|^\w+\s+(equ|macro)\b', re.I)

def strip_comment(line):
    out, quote = [], None
    for ch in line:
        if quote:
            if ch == quote: quote = None
        elif ch in '\'"': quote = ch
        elif ch == ';': break
        out.append(ch)
    return ''.join(out).rstrip()

def split_operands(text):
    parts, depth, cur, quote = [], 0, '', None
    for ch in text:
        if quote:
            if ch == quote: quote = None
        elif ch in '\'"': quote = ch
        elif ch == '[': depth += 1
        elif ch == ']': depth -= 1
        elif ch == ',' and depth == 0:
            parts.append(cur.strip()); cur = ''; continue
        cur += ch
    return parts + [cur.strip()] if cur.strip() else parts

EQU_VALUES = {}                 # UPPER include constant -> value, filled by read_equates

def number(text):
    """Value of a numeric literal or of a numeric include constant, else None."""
    t = text.strip()
    if re.fullmatch(r'[0-9][0-9A-Fa-f]*[hH]', t): return int(t[:-1], 16)
    if re.fullmatch(r'[0-9]+', t): return int(t)
    return EQU_VALUES.get(t.upper())

def idents(text):
    return [w for w in IDENT.findall(text) if w.lower() not in KEYWORDS and not HEXNUM.match(w)]

def row_refs(text):
    """UPPER names a db/dw/dd row stores as offsets (`dw offset X` or a bare `dw X`);
    rows with dup or $ are sizes and fill, `seg X` is a segment."""
    if '$' in text or re.search(r'\bdup\b', text, re.I): return []
    return [w.upper() for w in idents(re.sub(r'\bseg\s+\w+', '', text, flags=re.I))]

# ---------------------------------------------------------------- inputs

def read_map():
    """Segments {name: (start, length)}, module parts {(file, segment): start},
    label addresses {UPPER: linear} from the oracle-sym map."""
    text = (SYM / 'overkill.map').read_bytes().decode('latin-1')
    segs = {m[4]: (int(m[1], 16), int(m[3], 16)) for m in
            re.finditer(r'^\s*([0-9A-F]{5})H ([0-9A-F]{5})H ([0-9A-F]{5})H (\w+)', text, re.M)}
    parts = {(m[4].upper(), m[3]): int(m[1], 16) * 16 + int(m[2], 16) for m in
             re.finditer(r'^([0-9A-F]{4}):([0-9A-F]{4}) [0-9A-F]{4} C=\w+ S=(\w+) G=\S+ M=(\S+)', text, re.M)}
    publics = {m[3].upper(): int(m[1], 16) * 16 + int(m[2], 16) for m in
               re.finditer(r'^ ([0-9A-F]{4}):([0-9A-F]{4})\s+(\w+)\s*$', text.split('Publics by Value')[0], re.M)}
    return segs, parts, publics

def read_equates():
    consts = {}
    for path in sorted((ROOT / 'include').glob('*.INC')):
        for m in re.finditer(r'^(\w+)[ \t]+equ[ \t]+([^;\r\n]*)', path.read_bytes().decode('latin-1'), re.M):
            consts[m[1].upper()] = m[1]
            v = number(m[2])
            if v is not None: EQU_VALUES[m[1].upper()] = v
    return consts

def read_owned():
    owned = {}
    for path in sorted((ROOT / 'c').glob('*.c')):
        for m in re.finditer(r'OWNS:([^\n*]*)', path.read_bytes().decode('latin-1')):
            for name in m[1].split(): owned[name.upper()] = path.name
    return owned

def source_files():
    return [l.strip() for l in (ROOT / 'src/sources.txt').read_text().splitlines()
            if l.strip() and not l.startswith('#')]

class Block:
    def __init__(self, name, file, line, seg):
        self.name, self.file, self.line, self.seg = name, file, line, seg
        self.aliases, self.stmts, self.kind, self.alias_of, self.csdata = [], [], None, None, False

def parse_file(fname):
    """Blocks of one source file in source order. Statements are
    (line, 'ins'|'data'|'align'|'local'|'label', mnemonic, operand text)."""
    lines = (ROOT / 'src' / fname).read_bytes().decode('latin-1').split('\r\n')
    blocks, seg, cur = [], None, None
    def stmt(i, text):
        m = re.match(r'(\w+)\s*(.*)$', text.strip())
        if not m: return
        mn, rest = m[1].lower(), m[2]
        if mn in PREFIXES and rest:
            m = re.match(r'(\w+)\s*(.*)$', rest); mn, rest = m[1].lower(), m[2]
        kind = 'data' if mn in ('db', 'dw', 'dd') else 'align' if mn in ('even', 'align', 'org') else 'ins'
        cur.stmts.append((i + 1, kind, mn, rest))
    def new(name, i):
        nonlocal cur
        cur = Block(name, fname, i + 1, seg); blocks.append(cur)
    for i, raw in enumerate(lines):
        s = strip_comment(raw)
        if not s.strip() or DIRECTIVE.match(s): continue
        m = re.match(r'^(\w+)\s+(segment|ends)\b', s, re.I)
        if m: seg, cur = (m[1] if m[2].lower() == 'segment' else None), None; continue
        if seg is None: continue
        if cur is None and not re.match(r'^[A-Za-z_]', s): new(f'{fname}:{i + 1}', i)
        m = re.match(r'^(@@\w+):\s*(.*)$', s)
        if m: cur.stmts.append((i + 1, 'local', m[1], '')); stmt(i, m[2]); continue
        m = re.match(r'^([A-Za-z_]\w*):\s*(.*)$', s)
        if m: new(m[1], i); stmt(i, m[2]); continue
        m = re.match(r'^([A-Za-z_]\w*)\s+label\s+\w+', s, re.I)
        if m: new(m[1], i); cur.stmts.append((i + 1, 'label', 'label', '')); continue
        m = re.match(r'^([A-Za-z_]\w*)\s+(db|dw|dd)\b\s*(.*)$', s, re.I)
        if m: new(m[1], i); cur.stmts.append((i + 1, 'data', m[2].lower(), m[3])); continue
        if s[0].isspace(): stmt(i, s); continue
        raise SystemExit(f'{fname}:{i + 1}: cannot parse {s!r}')
    return blocks

def parse_data_labels():
    """DS labels of DATA.ASM: {UPPER: (name, [UPPER names its rows store as offsets])}."""
    labels, cur = {}, None
    for raw in (ROOT / 'src/DATA.ASM').read_bytes().decode('latin-1').split('\r\n'):
        s = strip_comment(raw)
        if not s.strip() or DIRECTIVE.match(s) or re.match(r'^\w+\s+(segment|ends)\b', s, re.I): continue
        m = re.match(r'^([A-Za-z_]\w*)(?::|\s+(?:label|db|dw|dd)\b)(.*)$', s, re.I)
        if m: cur = m[1].upper(); labels[cur] = (m[1], []); s = m[2]
        if cur: labels[cur][1].extend(row_refs(re.sub(r'^\s*(db|dw|dd)\b', '', s, flags=re.I)))
    return labels

def line_offsets(fname, problems):
    """{source line: (segment, offset or None)} by matching src lines to the oracle-sym
    listing in order (that copy only adds public lines)."""
    entries, seg = [], None
    for raw in (SYM / (fname.rsplit('.', 1)[0] + '.LST')).read_bytes().decode('latin-1').split('\r\n'):
        if not re.match(r'^ \s*\d+ ', raw): continue          # top-level file lines only
        code = strip_comment(raw[37:]).strip()
        m = re.match(r'^(\w+)\s+(segment|ends)\b', code, re.I)
        if m: seg = m[1] if m[2].lower() == 'segment' else None
        off = raw[8:12]
        entries.append((code[:60], seg, int(off, 16) if re.fullmatch(r'[0-9A-F]{4}', off) else None))
    out, j = {}, 0
    for i, raw in enumerate((ROOT / 'src' / fname).read_bytes().decode('latin-1').split('\r\n')):
        code = strip_comment(raw).strip()[:60]
        if not code: continue
        k = j
        while k < len(entries) and entries[k][0] != code: k += 1
        if k == len(entries):
            problems.append(f'{fname}:{i + 1}: not found in the listing'); continue
        out[i + 1] = entries[k][1:]; j = k + 1
    return out

# ---------------------------------------------------------------- model

class Model: pass

def build_model():
    M = Model()
    M.segs, parts, publics = read_map()
    M.code_segments = [s for s in M.segs if s not in ('DATA', 'IMAGE_END')]
    M.consts, M.owned, M.ds = read_equates(), read_owned(), parse_data_labels()
    M.problems = []
    blocks = []
    for f in source_files():
        if f.upper() == 'DATA.ASM': continue
        offs = line_offsets(f, M.problems)
        for b in parse_file(f):
            b.addr = parts.get((f.upper(), b.seg)) if ':' in b.name else publics.get(b.name.upper())
            if b.addr is None: M.problems.append(f'{b.name}: not in the map'); continue
            b.offsets = []
            for s in b.stmts:
                seg, off = offs.get(s[0], (b.seg, None))
                b.offsets.append(None if off is None else parts[(f.upper(), seg)] + off)
            first = next((o for o in b.offsets if o is not None), None)
            if first is not None and first != b.addr and b.stmts[0][1] != 'local':
                M.problems.append(f'{b.name}: listing address {first:05X} != map {b.addr:05X}')
            blocks.append(b)
    M.blocks = blocks
    M.byseg = defaultdict(list)
    for b in blocks: M.byseg[b.seg].append(b)
    M.unlabeled = {}
    for seg, bl in M.byseg.items():
        bl.sort(key=lambda b: (b.addr, 1 if b.stmts else 0))
        start, length = M.segs[seg]
        if bl[0].addr != start: M.unlabeled[seg] = bl[0].addr - start
        for a, b in zip(bl, bl[1:]): a.size = b.addr - a.addr
        bl[-1].size = start + length - bl[-1].addr
        for a, b in zip(bl, bl[1:]):
            if a.file == b.file and a.line > b.line: M.problems.append(f'{b.name}: address order differs from source order')
        for b in bl:          # code bytes: instruction lines up to the next line with an offset
            ends = [o for o in b.offsets if o is not None] + [b.addr + b.size]
            b.code_bytes, pos = 0, 0
            for s, o in zip(b.stmts, b.offsets):
                if o is None: continue
                pos += 1
                if s[1] == 'ins': b.code_bytes += ends[pos] - o
    for seg in M.code_segments:
        total = sum(b.size for b in M.byseg.get(seg, [])) + M.unlabeled.get(seg, 0)
        if total != M.segs[seg][1]: M.problems.append(f'{seg}: blocks sum to {total:X}, segment is {M.segs[seg][1]:X}')

    for seg, bl in M.byseg.items():
        for i in range(len(bl) - 1, -1, -1):
            b = bl[i]
            first = next((s for s in b.stmts if s[1] in ('ins', 'data')), None)
            b.has_ins = any(s[1] == 'ins' for s in b.stmts)
            if first: b.kind = 'code' if first[1] == 'ins' else 'data'
            elif b.size == 0 and i + 1 < len(bl): b.kind, b.alias_of = 'alias', bl[i + 1]
            else: b.kind = 'data'
    M.label_block = {}
    for b in blocks:
        t = b
        while t.kind == 'alias': t = t.alias_of
        M.label_block[b.name.upper()] = t
        if t is not b: t.aliases.append(b.name)

    # code offset tables: CS data blocks and DS labels, possibly nested
    M.table_entries = {k: offs for k, (n, offs) in M.ds.items()}
    for b in blocks:
        if b.kind == 'data':
            M.table_entries[b.name.upper()] = [x for s in b.stmts if s[1] == 'data' for x in row_refs(s[3])]
    M.code_labels = {k for k, b in M.label_block.items() if b.kind == 'code'}
    refs = defaultdict(set)
    for b in blocks:
        if b.kind == 'code':
            for s in b.stmts:
                if s[1] == 'ins':
                    for w in idents(s[3]): refs[w.upper()].add(b.name.upper())

    M.routines, M.owner = {}, {}
    for seg, bl in M.byseg.items():
        cur = None
        for b in bl:
            if b.kind == 'alias': continue
            key = b.name.upper()
            if b.kind == 'code':
                cur = b; b.members = [b]; M.routines[key] = b; M.owner[key] = key; continue
            users = set().union(*(refs.get(n.upper(), set()) for n in [b.name] + b.aliases))
            # C's OWNS list is also the hybrid's exact cut boundary. Do not absorb an
            # adjacent, unlisted code-pointer table into a C-owned routine just because
            # the oracle routine was its only ASM reference: the C owner may read that
            # table to select an unowned platform blitter, and C may access other such
            # CS tables directly. Embedded case code still belongs to the routine.
            cur_c_owner = M.owned.get(cur.name.upper()) if cur is not None else None
            explicitly_owned_table = cur_c_owner is not None and any(
                M.owned.get(n.upper()) == cur_c_owner for n in [b.name] + b.aliases)
            table_belongs = (code_targets(M, key) and users <= {cur.name.upper()}
                             and (cur_c_owner is None or explicitly_owned_table)) if cur is not None else False
            if cur is not None and (b.has_ins or table_belongs):
                cur.members.append(b); M.owner[key] = cur.name.upper()
            else:
                b.csdata = True
                if b.has_ins: M.problems.append(f'{b.name}: code in a data block that no routine owns')
    for k, b in M.label_block.items():
        if b.name.upper() in M.owner: M.owner[k] = M.owner[b.name.upper()]
    M.csdata = {b.name.upper(): b for b in blocks if b.csdata}
    for label, cfile in M.owned.items():       # C owns listed routines and explicitly listed tables
        k = M.owner.get(label)
        if k is None: M.problems.append(f'{cfile}: OWNS {label}, which is no routine or routine table'); continue
        r = M.routines[k]
        missing = [n for n in [b.name for b in r.members] + r.aliases if n.upper() not in M.owned]
        if missing: M.problems.append(f'{cfile}: owns part of {r.name} but not {" ".join(missing)}')
    for r in M.routines.values():
        r.size_total = sum(m.size for m in r.members)
        r.code_total = sum(m.code_bytes for m in r.members)
    M.trampolines = {}
    for k, r in M.routines.items():
        ins = [s for m in r.members for s in m.stmts if s[1] == 'ins']
        if len(ins) == 2 and ins[0][2] == 'call' and ins[0][3].lower() in REGS and ins[1][2] == 'retf':
            M.trampolines[k] = ins[0][3].lower()
    analyse(M)
    classify(M)
    return M

def code_targets(M, label, seen=None):
    """Code labels reachable through the offset table `label` (nested tables followed)."""
    seen = set() if seen is None else seen
    if label in seen: return set()
    seen.add(label)
    out = set()
    for t in M.table_entries.get(label, []):
        if t in M.code_labels: out.add(t)
        elif t in M.table_entries: out |= code_targets(M, t, seen)
    return out

def routine_of(M, label):
    return M.owner.get(label.upper())

def analyse(M):
    for key, r in M.routines.items():
        r.edges = defaultdict(int)          # (target routine, kind) -> count
        r.state = {k: set() for k in ('ds_read', 'ds_write', 'ds_addr', 'cs_read', 'cs_write', 'cs_addr',
                                      'field_read', 'field_write')}
        r.hw = defaultdict(set)
        if r.seg == SOUND_SLOT: r.hw['sound'].add('code in the sound-module slot')
        if key in M.trampolines: r.hw['trampoline'].add(f'far->near via {M.trampolines[key].upper()}')
        ins = [s for m in r.members for s in m.stmts if s[1] == 'ins']
        last_ah = last_dx = None
        r.terminates = set()          # lines of int 20h / int 21h AH=4Ch (no return)
        def edge(label, kind):
            t = routine_of(M, label)
            if t is not None and not (t == key and kind != 'fall'): r.edges[(t, kind)] += 1
        for idx, (line, _, mn, ops) in enumerate(ins):
            opl = split_operands(ops)
            names = idents(ops)
            m = re.fullmatch(r'(?:(short|near\s+ptr|far\s+ptr)\s+)?([A-Za-z_]\w*)', ops.strip(), re.I)
            target = (m[1] or '').lower() if m and m[2].lower() not in REGS else None
            if target is not None:
                label = m[2].upper()
                if mn == 'call':
                    edge(label, 'farcall' if target.startswith('far') else 'call')
                    if target.startswith('far') and seg_of(M, label) == SOUND_SLOT: r.hw['sound'].add(f'far call {m[2]}')
                elif mn == 'jmp': edge(label, 'tail')
                elif mn.startswith('j') or mn in LOOPS: edge(label, 'cond')
            for w in names:
                for t in code_targets(M, w.upper()): edge(t, 'table')
            for o in re.findall(r'\boffset\s+(\w+)', ops, re.I):
                O = o.upper()
                if O in M.code_labels:
                    kind, reg = 'addr', opl[0].lower() if mn == 'mov' and opl else None
                    for j, s2 in enumerate(ins[idx + 1: idx + 4]):
                        tm = re.fullmatch(r'far\s+ptr\s+(\w+)', s2[3].strip(), re.I)
                        if j == 0 and s2[2] == 'push' and s2[3].strip().lower() == reg: kind = 'pushret'; break
                        if s2[2] == 'call' and tm and M.trampolines.get(tm[1].upper()) == reg: kind = 'tramp'; break
                        if split_operands(s2[3])[:1] == [reg]: break
                    edge(O, kind)
                elif O in M.ds: r.state['ds_addr'].add(M.ds[O][0])
                elif O in M.csdata: r.state['cs_addr'].add(M.csdata[O].name)
            for s in re.findall(r'\bseg\s+(\w+)', ops, re.I):
                if seg_of(M, s.upper()) == SOUND_SLOT: r.hw['sound'].add(f'seg {s}')
            # hardware evidence
            if mn == 'int':
                n = number(ops)
                if n == 0x20 or (n == 0x21 and last_ah == 0x4C): r.terminates.add(line)
                r.hw['int'].add(ops if n is None else f'{n:02X}h' + (f' AH={last_ah:02X}h' if last_ah is not None and n in (0x10, 0x16, 0x21, 0x33, 0x67) else ''))
            if mn in ('in', 'out'):
                port = opl[0] if mn == 'out' else opl[1]
                r.hw['port'].add(f'dx={last_dx}' if port.lower() == 'dx' and last_dx else port)
            if mn in ('iret', 'cli', 'sti'): r.hw[mn].add(mn)
            for w in names:
                if w.upper() in HW_WORDS: r.hw[HW_WORDS[w.upper()]].add(w)
            if mn == 'mov' and len(opl) == 2:
                v = number(opl[1])
                if v in HW_SEGMENTS: r.hw['video'].add(HW_SEGMENTS[v])
                if opl[0].lower() == 'ah' and v is not None: last_ah = v
                if opl[0].lower() == 'ax' and v is not None: last_ah = v >> 8
                if opl[0].lower() == 'dx': last_dx = opl[1]
            # memory state
            for k2, op in enumerate(opl):
                o = re.sub(r'\b(offset|seg)\s+\w+', '', op, flags=re.I)
                ws = idents(o)
                if '[' not in o:
                    # a bare variable name is a memory operand in TASM
                    if mn in ('lea', 'call', 'jmp') or mn.startswith('j') or not any(w.upper() in M.ds or w.upper() in M.csdata for w in ws):
                        continue
                if re.match(r'^\s*(?:(?:byte|word|dword)\s+ptr\s+)?es:', o, re.I): continue
                if mn == 'lea': mode = 'addr'
                elif k2 == 0 and mn in WRITE: mode = 'write'
                elif mn in RMW and (k2 == 0 or mn == 'xchg'): mode = 'rw'
                else: mode = 'read'
                based = bool(re.search(r'\b(bp|bx|si|di)\b', o, re.I))
                for w in ws:
                    W = w.upper()
                    if W in M.ds: dst, name = 'ds', M.ds[W][0]
                    elif W in M.csdata or (W in M.label_block and M.label_block[W].kind == 'data'): dst, name = 'cs', M.label_block[W].name
                    elif W in M.consts and based: dst, name = 'field', M.consts[W]
                    else: continue
                    if mode == 'addr': r.state['field_read' if dst == 'field' else dst + '_addr'].add(name)
                    if mode in ('read', 'rw'): r.state[dst + '_read'].add(name)
                    if mode in ('write', 'rw'): r.state[dst + '_write'].add(name)
        # fall-through: the last statement of the last member is an instruction that continues
        stm = [s for s in r.members[-1].stmts if s[1] in ('ins', 'data')]
        r.falls_into = None
        if stm and stm[-1][1] == 'ins' and stm[-1][2] not in UNCONDITIONAL and stm[-1][0] not in r.terminates:
            bl = M.byseg[r.seg]
            i = bl.index(r.members[-1])
            nxt = bl[i + 1] if i + 1 < len(bl) else None
            while nxt is not None and nxt.kind == 'alias': nxt = nxt.alias_of
            if nxt is not None and nxt.kind == 'code':
                r.edges[(nxt.name.upper(), 'fall')] += 1; r.falls_into = nxt.name.upper()
            elif nxt is not None:
                M.problems.append(f'{r.name}: falls into data block {nxt.name}')
    for r in M.routines.values(): r.callers = defaultdict(int)
    for k, r in M.routines.items():
        for (t, kind), n in r.edges.items(): M.routines[t].callers[(k, kind)] += n

def seg_of(M, label):
    b = M.label_block.get(label)
    return b.seg if b else None

def classify(M):
    """Fixpoint: platform globals follow the platform set, derived rules extend it."""
    R = M.routines
    touch = defaultdict(set)
    for k, r in R.items():
        r.owned = M.owned.get(k)
        for kk in ('ds_read', 'ds_write', 'ds_addr'):
            for g in r.state[kk]: touch[g].add(k)
    derived = {}
    while True:
        plat = {k for k, r in R.items() if r.hw or k in derived}
        M.platform_globals = {g for g, ks in touch.items() if ks <= plat}
        for k, r in R.items():
            ds = r.state['ds_read'] | r.state['ds_write'] | r.state['ds_addr']
            r.game = dict(globals=sorted(ds - M.platform_globals), pool=sorted(g for g in ds if g.upper() in POOL),
                          fields=sorted(f for f in r.state['field_read'] | r.state['field_write'] if f.upper().startswith('REC_')))
            r.cls = 'gameplay' if k not in plat else 'mixed' if any(r.game.values()) else 'platform'
        new = {}
        for k, r in R.items():
            if r.cls != 'gameplay' or r.owned: continue
            cs = {c for (c, _) in r.callers if c != k}
            outs = {(t, kind) for (t, kind) in r.edges if t != k}
            stateless = not any(r.game.values())
            if cs and stateless and all(R[c].cls != 'gameplay' for c in cs):
                new[k] = 'helper', 'stateless, only reached from ' + names(M, sorted(cs), 3)
            elif cs and not r.game['fields'] and not r.game['pool'] and all(R[c].cls == 'platform' for c in cs):
                new[k] = 'context', 'only reached from platform code: ' + names(M, sorted(cs), 3)
            elif outs and stateless and all(kind in ('tail', 'fall', 'cond') and R[t].cls == 'platform' for t, kind in outs):
                new[k] = 'entry', 'stateless entry into ' + names(M, sorted({t for t, _ in outs}), 3)
        if not new: break
        derived.update(new)
    for k, (rule, why) in derived.items(): R[k].hw[rule].add(why)

# ---------------------------------------------------------------- graph algorithms

def sccs(nodes, succ):
    """Tarjan, iterative."""
    index, low, onstack, stack, out, n = {}, {}, set(), [], [], 0
    for root in nodes:
        if root in index: continue
        index[root] = low[root] = n; n += 1; stack.append(root); onstack.add(root)
        work = [(root, iter(succ(root)))]
        while work:
            v, it = work[-1]
            for w in it:
                if w not in index:
                    index[w] = low[w] = n; n += 1; stack.append(w); onstack.add(w)
                    work.append((w, iter(succ(w)))); break
                if w in onstack: low[v] = min(low[v], index[w])
            else:
                work.pop()
                if work: low[work[-1][0]] = min(low[work[-1][0]], low[v])
                if low[v] == index[v]:
                    comp = []
                    while True:
                        w = stack.pop(); onstack.discard(w); comp.append(w)
                        if w == v: break
                    out.append(sorted(comp))
    return out

class UnionFind:
    def __init__(self, items): self.p = {i: i for i in items}
    def find(self, x):
        while self.p[x] != x: self.p[x] = self.p[self.p[x]]; x = self.p[x]
        return x
    def union(self, a, b):
        a, b = self.find(a), self.find(b)
        if a != b: self.p[max(a, b)] = min(a, b)

def make_regions(M, cap):
    R = M.routines
    units = {k for k, r in R.items() if r.cls == 'gameplay' and not r.owned}
    uf, crossing = UnionFind(units), set()
    def glue(a, b, why):
        if a in units and b in units: uf.union(a, b)
        elif a in units or b in units: crossing.add((a, b, why))
    for k, r in R.items():
        for (t, kind) in r.edges:
            if kind in ('fall', 'pushret'): glue(k, t, kind)
    for comp in M.scc:
        for c in comp[1:]: glue(comp[0], c, 'scc')
    M.tail_fragments = {}
    for k, r in R.items():
        kinds = {kind for (_, kind) in r.callers}
        if kinds and kinds <= {'tail', 'cond'}:
            M.tail_fragments[k] = sorted({c for (c, _) in r.callers})
            for j in M.tail_fragments[k]: glue(j, k, 'tail fragment')
    M.glue_crossing = sorted(crossing)
    groups = defaultdict(set)
    for u in units: groups[uf.find(u)].add(u)
    M.glue_groups = sorted((sorted(g) for g in groups.values() if len(g) > 1), key=len, reverse=True)

    # weighted undirected graph between groups
    gid = {u: uf.find(u) for u in units}
    W = defaultdict(lambda: defaultdict(float))
    def add(a, b, w):
        if a in gid and b in gid:
            ga, gb = gid[a], gid[b]
            W[ga][gb] += w
            if ga != gb: W[gb][ga] += w
    for k, r in R.items():
        for (t, kind), n in r.edges.items():
            add(k, t, EDGE_WEIGHT[kind] * (1 if kind == 'table' else min(n, 3)))
    access = defaultdict(set); writers = defaultdict(set)
    for u in units:
        st = R[u].state
        for x in st['ds_read'] | st['ds_write'] | st['ds_addr']: access['ds:' + x].add(u)
        for x in st['cs_read'] | st['cs_write'] | st['cs_addr']: access['cs:' + x].add(u)
        for x in st['ds_write']: writers['ds:' + x].add(u)
        for x in st['cs_write']: writers['cs:' + x].add(u)
    for x, us in access.items():
        if writers[x] and 2 <= len(us) <= STATE_FANOUT:
            us = sorted(us)
            for i, a in enumerate(us):
                for b in us[i + 1:]: add(a, b, STATE_WEIGHT / (len(us) - 1))
    members = {g: set(ms) for g, ms in groups.items()}
    size = {g: sum(R[m].size_total for m in ms) for g, ms in members.items()}
    deg = {g: sum(W[g].values()) + W[g].get(g, 0.0) for g in members}   # self loops count twice
    m2 = sum(deg.values())                                               # 2m
    if not m2: return [sorted(ms) for ms in members.values()]
    while True:
        best = None
        for a in members:
            for b, w in W[a].items():
                if b <= a or size[a] + size[b] > cap: continue
                dq = 2 * w / m2 - 2 * deg[a] * deg[b] / (m2 * m2)
                if dq > 0 and (best is None or dq > best[0]): best = (dq, a, b)
        if best is None: break
        _, a, b = best
        members[a] |= members.pop(b); size[a] += size.pop(b); deg[a] += deg.pop(b)
        for o, w in W.pop(b).items():
            if o == b: W[a][a] += w; continue
            if o == a: W[a][a] += w; continue
            W[a][o] += w; W[o][a] += w; del W[o][b]
        W[a].pop(b, None)
    return [sorted(ms) for ms in members.values()]

# ---------------------------------------------------------------- region metrics

def region_metrics(M, regs):
    R = M.routines
    out = []
    for i, ms in enumerate(sorted(regs, key=lambda ms: min(R[m].addr for m in ms))):
        S = set(ms)
        internal = bin_ = bout = adj_c = 0
        entries_asm, entries_c, calls_game, calls_plat, calls_c = defaultdict(int), defaultdict(int), set(), set(), set()
        for m in ms:
            for (t, kind), n in R[m].edges.items():
                if t in S: internal += n; continue
                bout += n
                if R[t].owned: calls_c.add(t); adj_c += n
                elif R[t].cls == 'gameplay': calls_game.add(t)
                else: calls_plat.add(t)
            for (c, kind), n in R[m].callers.items():
                if c in S: continue
                bin_ += n
                if R[c].owned: entries_c[m] += n; adj_c += n
                else: entries_asm[m] += n
        wr = set().union(*(R[m].state['ds_write'] for m in ms))
        shared = set()
        for k, r in R.items():
            if k not in S: shared |= wr & (r.state['ds_read'] | r.state['ds_write'] | r.state['ds_addr'])
        own = {b.name for m in ms for b in R[m].members}        # the region's own tables move with it
        cs = set().union(*(R[m].state['cs_read'] | R[m].state['cs_write'] | R[m].state['cs_addr'] for m in ms)) - own
        removes = sorted(R[k].name for k, r in R.items() if r.owned and
                         {c for (c, _) in r.callers if not R[c].owned} and
                         {c for (c, _) in r.callers if not R[c].owned} <= S)
        nbytes = sum(R[m].size_total for m in ms)
        cohesion = internal / (internal + bin_ + bout) if internal + bin_ + bout else 1.0
        score = nbytes / 1024 * cohesion * (1.5 if adj_c else 1.0) / (1 + 0.5 * len(entries_asm) + 0.25 * len(calls_game))
        # name: the entry from outside that reaches most of the region through internal edges
        def reach(m):
            seen, todo = {m}, [m]
            while todo:
                for (t, _) in R[todo.pop()].edges:
                    if t in S and t not in seen: seen.add(t); todo.append(t)
            return sum(R[x].size_total for x in seen)
        main = max(sorted(entries_asm) or sorted(entries_c) or ms, key=lambda m: (reach(m), R[m].size_total))
        out.append(dict(
            id=f'R{i}', name=R[main].name, bytes=nbytes, code_bytes=sum(R[m].code_total for m in ms),
            routines=sorted(ms, key=lambda m: R[m].addr), internal=internal, boundary_in=bin_, boundary_out=bout,
            entries_from_asm={R[k].name: n for k, n in sorted(entries_asm.items())},
            entries_from_c={R[k].name: n for k, n in sorted(entries_c.items())},
            calls_asm_gameplay=sorted(R[k].name for k in calls_game), calls_platform=sorted(R[k].name for k in calls_plat),
            calls_c=sorted(R[k].name for k in calls_c), c_adjacency=adj_c, c_bridges_removed=removes,
            written_globals=sorted(wr), shared_globals=sorted(shared), cs_words=sorted(cs),
            cohesion=round(cohesion, 3), score=round(score, 3)))
    return out

def waves(M, mets, count=3, per_wave=6, min_bytes=512):
    """Greedy: walk the ranking, put a region in the first wave where it has no direct
    edge to a region already chosen."""
    R = M.routines
    regof = {r: m['id'] for m in mets for r in m['routines']}
    touching = {}
    for m in mets:
        t = set()
        for x in m['routines']:
            t |= {regof.get(y) for (y, _) in R[x].edges} | {regof.get(y) for (y, _) in R[x].callers}
        touching[m['id']] = t - {None, m['id']}
    out = [[] for _ in range(count)]
    for m in sorted((m for m in mets if m['bytes'] >= min_bytes), key=lambda m: -m['score']):
        for w in out:
            if len(w) < per_wave and not any(o in touching[m['id']] for o in w):
                w.append(m['id']); break
    return out

# ---------------------------------------------------------------- output

def fmt_addr(M, lin, seg):
    frame = M.segs[seg][0] >> 4
    return f'{frame:04X}:{lin - frame * 16:04X}'

def table(rows, head):
    return '\n'.join(['| ' + ' | '.join(head) + ' |', '|' + '---|' * len(head)] +
                     ['| ' + ' | '.join(str(c) for c in row) + ' |' for row in rows])

def names(M, ks, limit=12):
    ns = [M.routines[k].name if k in M.routines else k for k in ks]
    return ', '.join(ns[:limit]) + (f' (+{len(ns) - limit})' if len(ns) > limit else '')

def checks(M):
    """Known facts about the oracle that the parser must reproduce."""
    R = M.routines
    def out(n): return {(R[t].name, kind) for (t, kind) in R[routine_of(M, n)].edges}
    th = {t for (t, kind) in out('RunTypeHandler') if kind == 'table'}
    st = R[routine_of(M, 'SteerTowardTarget')].callers
    return [
        ('Type02TimedStraightShot falls into MoveInDirection8 and pushes ShotHitPlayerCheck as return address',
         {('MoveInDirection8', 'fall'), ('ShotHitPlayerCheck', 'pushret')} <= out('Type02TimedStraightShot')),
        ('KindHandlers is owned by UpdateRecordByKind and dispatches to RunTypeHandler, UpdatePod, ReturnNear ...',
         'KindHandlers' in [m.name for m in R[routine_of(M, 'UpdateRecordByKind')].members]
         and {('RunTypeHandler', 'table'), ('UpdatePod', 'table'), ('ReturnNear', 'table')} <= out('UpdateRecordByKind')),
        (f'TypeHandlers: RunTypeHandler dispatches to {len(th)} distinct handler routines',
         'Type02TimedStraightShot' in th and 'Type93SweepDescendClimb' in th),
        ('UpdateAllRecords calls UpdateRecordByKind and SteerSegBossAlongPath, far StepMarchFireDelay and MoveStars',
         {('UpdateRecordByKind', 'call'), ('SteerSegBossAlongPath', 'call'), ('StepMarchFireDelay', 'farcall'),
          ('MoveStars', 'farcall')} <= out('UpdateAllRecords')),
        (f'SteerTowardTarget has {len({c for c, _ in st})} callers, near calls and far ones via FarCallMainNearViaAX',
         {kind for (_, kind) in st} >= {'call', 'tramp'}),
        ('SpawnFromMapRow dispatches LevelMapCellHandlers (a DS table) to Level0MapCell..Level5MapCell',
         {('Level0MapCell', 'table'), ('Level5MapCell', 'table')} <= out('SpawnFromMapRow')),
        ('UpdateAllRecords reads REC_STATUS and writes RecordTickCounter',
         'REC_STATUS' in R[routine_of(M, 'UpdateAllRecords')].state['field_read']
         and 'RecordTickCounter' in R[routine_of(M, 'UpdateAllRecords')].state['ds_write']),
    ]

def make_report(M, mets, wv, args):
    R, segs = M.routines, M.segs
    regby = {m['id']: m for m in mets}
    by, cnt = defaultdict(int), defaultdict(int)
    for r in R.values():
        c = 'C-owned' if r.owned else r.cls
        by[c] += r.size_total; cnt[c] += 1
    code_total = sum(segs[s][1] for s in M.code_segments)
    rbytes = sum(r.size_total for r in R.values())
    rcode = sum(r.code_total for r in R.values())
    csb = sum(b.size for b in M.csdata.values())
    ec = defaultdict(int)
    for r in R.values():
        for (_, kind), n in r.edges.items(): ec[kind] += n
    L = ['# Migration graph of the frozen ASM oracle', '',
         'Generated by `python tools/graph.py` (method in its docstring) from src/, include/, c/ and '
         'build/oracle-sym. Do not edit; rerun.', '',
         '## Whole program', '',
         table([[s, f'{segs[s][1]:,}', f'{sum(r.size_total for r in R.values() if r.seg == s):,}',
                 f'{sum(r.code_total for r in R.values() if r.seg == s):,}',
                 f'{sum(b.size for b in M.csdata.values() if b.seg == s):,}', sum(1 for r in R.values() if r.seg == s)]
                for s in M.code_segments],
               ['segment', 'bytes', 'routine bytes', 'of which instructions', 'CS data bytes', 'routines']), '',
         f'- code segments: {code_total:,} bytes = routines {rbytes:,} ({rcode:,} instruction bytes, '
         f'{rbytes - rcode:,} embedded tables/variables/fill) + CS data {csb:,} + unlabeled {sum(M.unlabeled.values()):,}',
         '- by class (routine bytes / routines): ' + ', '.join(f'{c} {by[c]:,} / {cnt[c]}' for c in ('gameplay', 'platform', 'mixed', 'C-owned')),
         '- edges: ' + ', '.join(f'{k} {v}' for k, v in sorted(ec.items())),
         f'- SCCs of more than one routine: {sum(1 for c in M.scc if len(c) > 1)} (largest {max(len(c) for c in M.scc)}); '
         f'glue groups: {len(M.glue_groups)} (largest {len(M.glue_groups[0]) if M.glue_groups else 0} routines); '
         f'tail fragments: {len(M.tail_fragments)}',
         f'- regions: {len(mets)} ({sum(1 for m in mets if len(m["routines"]) > 1)} with more than one routine); '
         f'cap {args.cap} bytes', '']
    ok = checks(M)
    L += ['## Parser checks', ''] + [f'- {"PASS" if v else "FAIL"}: {d}' for d, v in ok]
    L += [f'- {"PASS" if not M.problems else "FAIL"}: source labels, map and listing agree; blocks sum to the '
          f'segment sizes ({len(M.problems)} problems)'] + [f'  - {p}' for p in M.problems[:40]] + ['']

    ranked = sorted((m for m in mets if m['bytes'] >= 256), key=lambda m: -m['score'])
    L += ['## Candidate regions, ranked (what can be absorbed next)', '',
          'Disjoint. *entries* = region routines entered from remaining ASM (bridge stubs); *ASM calls* = gameplay '
          'ASM routines it calls (C->ASM); *plat* = platform/mixed routines it calls; *C adj* = edges to/from the C '
          'island; *removes* = current C bridges whose ASM callers all lie in the region; in/out = boundary edges.', '',
          table([[i + 1, m['id'], m['name'], f'{m["bytes"]:,}', len(m['routines']), m['internal'],
                  f'{m["boundary_in"]}/{m["boundary_out"]}', len(m['entries_from_asm']), len(m['calls_asm_gameplay']),
                  len(m['calls_platform']), m['c_adjacency'], len(m['c_bridges_removed']), m['cohesion'], m['score']]
                 for i, m in enumerate(ranked)],
                ['#', 'id', 'region (main entry)', 'bytes', 'routines', 'internal', 'in/out', 'entries',
                 'ASM calls', 'plat', 'C adj', 'removes', 'cohesion', 'score']), '']
    small = [m for m in mets if m['bytes'] < 256]
    L += [f'{len(small)} more regions under 256 bytes ({sum(m["bytes"] for m in small):,} bytes) are in graph.json.', '']
    L += ['### Parallel waves (no direct edges between regions of one wave; regions of 512 bytes or more)', '']
    for i, w in enumerate(wv):
        L.append(f'- wave {i + 1}: ' + ', '.join(f'{x} {regby[x]["name"]} ({regby[x]["bytes"]:,})' for x in w)
                 + f' = {sum(regby[x]["bytes"] for x in w):,} bytes')
    L += ['', '### Region details', '']
    for m in ranked:
        L += [f'#### {m["id"]} {m["name"]}: {m["bytes"]:,} bytes ({m["code_bytes"]:,} instructions), '
              f'{len(m["routines"])} routines, cohesion {m["cohesion"]}', '',
              f'- routines: {names(M, m["routines"], 80)}',
              f'- entries from ASM: {", ".join(f"{k} ({v})" for k, v in m["entries_from_asm"].items()) or "-"}',
              f'- entries from C: {", ".join(m["entries_from_c"]) or "-"}',
              f'- calls gameplay ASM: {", ".join(m["calls_asm_gameplay"]) or "-"}',
              f'- calls platform/mixed: {", ".join(m["calls_platform"]) or "-"}',
              f'- calls C: {", ".join(m["calls_c"]) or "-"}; C bridges removed: {", ".join(m["c_bridges_removed"]) or "-"}',
              f'- writes {len(m["written_globals"])} globals; shared with code outside: {", ".join(m["shared_globals"]) or "-"}',
              f'- CS words: {", ".join(m["cs_words"]) or "-"}', '']
    L += ['## Glue crossing class or C boundaries', '',
          'Fall-through, pushed returns and tail fragments not unioned because one side is platform, mixed or '
          'C-owned; each needs an explicit jump or a bridge when the gameplay side moves.', '']
    L += [f'- {R[a].name} ({"C" if R[a].owned else R[a].cls}) -> {R[b].name} ({"C" if R[b].owned else R[b].cls}): {w}'
          for a, b, w in M.glue_crossing] + ['']
    L += ['## Shared tails (tail fragments entered by jumps from several routines)', '']
    L += [f'- {R[k].name} ({R[k].size_total} bytes): {names(M, v, 10)}'
          for k, v in sorted(M.tail_fragments.items(), key=lambda kv: -len(kv[1])) if len(v) > 1] + ['']
    L += ['## SCCs of more than one routine', '']
    L += [f'- {len(c)} routines, {sum(R[k].size_total for k in c):,} bytes: {names(M, c, 20)}'
          for c in sorted((c for c in M.scc if len(c) > 1), key=len, reverse=True)] + ['']
    L += ['## Platform and mixed routines', '']
    for cls in ('platform', 'mixed'):
        rs = sorted((r for r in R.values() if r.cls == cls), key=lambda r: r.addr)
        L += [f'### {cls}: {len(rs)} routines, {sum(r.size_total for r in rs):,} bytes', '']
        for r in rs:
            ev = '; '.join(f'{a}: {", ".join(sorted(b))}' for a, b in sorted(r.hw.items()))
            g = r.game
            gs = '' if cls == 'platform' else ' | game state: ' + '; '.join(filter(None, [
                'pool ' + ' '.join(g['pool']) if g['pool'] else '',
                'fields ' + ' '.join(g['fields'][:6]) + (' ...' if len(g['fields']) > 6 else '') if g['fields'] else '',
                'globals ' + ' '.join(g['globals'][:6]) + (' ...' if len(g['globals']) > 6 else '') if g['globals'] else '']))
            L.append(f'- {r.name} ({r.size_total}): {ev}{gs}')
        L.append('')
    L += ['## Migration health', '', '| measure | value |', '|---|---|'] + \
         [f'| {k} | {v:,} |' for k, v in health(M).items()] + ['']
    L += ['## C island', '', names(M, sorted((k for k, r in R.items() if r.owned), key=lambda k: R[k].addr), 200), '',
          'Platform globals (DS labels touched only by hardware routines): ' + ', '.join(sorted(M.platform_globals)), '']
    return '\n'.join(L) + '\n'

def health(M):
    """Migration health: what the C island owns, what it costs at the ASM boundary, and the
    hybrid's segment sizes (from build/hybrid, when it has been built)."""
    R = M.routines
    owned = [k for k, r in R.items() if r.owned]
    into = [(a, t) for a, r in R.items() if not r.owned for (t, kind), n in r.edges.items() if R[t].owned for _ in range(n)]
    out_ = [(a, t) for a in owned for (t, kind), n in R[a].edges.items() if not R[t].owned for _ in range(n)]
    h = {'oracle bytes owned by C': sum(R[k].size_total for k in owned),
         'oracle routines owned by C': len(owned),
         'OWNS labels': len(read_owned()),
         'gameplay bytes still ASM': sum(r.size_total for r in R.values() if r.cls == 'gameplay' and not r.owned),
         'ASM->C entry routines (bridge labels needed)': len({t for _, t in into}),
         'ASM->C call sites': len(into),
         'C->ASM call sites (oracle edges out of the island)': len(out_),
         'C->ASM distinct targets': len({t for _, t in out_})}
    mp = ROOT / 'build/hybrid/OVERKILL.MAP'
    if mp.exists():
        text = mp.read_text(errors='replace')
        for m in re.finditer(r'^ [0-9A-F]{5}H [0-9A-F]{5}H ([0-9A-F]{5})H (MAIN|CGAME)\b', text, re.M):
            h[f'hybrid segment {m[2]} bytes'] = int(m[1], 16)
        mods = re.findall(r'^[0-9A-F]{4}:[0-9A-F]{4} ([0-9A-F]{4}) C=\w+ S=(\w+) .*M=([\w.]+)', text, re.M)
        bridge = [(int(n, 16), s) for n, s, mod in mods if mod.upper() == 'BRIDGES.ASM']
        h['bridge bytes in MAIN (c/*.asm stubs)'] = sum(n for n, s in bridge if s == 'MAIN')
        h['bridge bytes in CGAME (generated far entries)'] = sum(n for n, s in bridge if s != 'MAIN')
        c = [(int(n, 16), mod) for n, s, mod in mods if '.' not in mod and int(n, 16)]
        h['C code bytes'] = sum(n for n, _ in c)
        h['C regions (c/*.c)'] = len(list((ROOT / 'c').glob('*.c')))
    return h

def show(M, name, regof):
    R = M.routines
    k = routine_of(M, name)
    if not k: raise SystemExit(f'{name}: not a routine label')
    r = R[k]
    print(f'{r.name}  {r.file}:{r.line}  {fmt_addr(M, r.addr, r.seg)}  {r.size_total} bytes ({r.code_total} instructions)  '
          f'{r.cls}' + (f'  C-owned ({r.owned})' if r.owned else '') + (f'  region {regof[k]}' if k in regof else ''))
    if r.aliases: print('  aliases:', ' '.join(r.aliases))
    if r.members[1:]: print('  tables:', ' '.join(m.name for m in r.members[1:]))
    if r.hw: print('  hardware:', '; '.join(f'{a}: {", ".join(sorted(b))}' for a, b in r.hw.items()))
    def fmt(items): return ', '.join(f'{R[t].name} ({kind}{" x%d" % n if n > 1 else ""})' for (t, kind), n in sorted(items)) or '-'
    print('  out:', fmt(r.edges.items()))
    print('  in: ', fmt(r.callers.items()))
    for kk, v in r.state.items():
        if v: print(f'  {kk}: {" ".join(sorted(v))}')

def main():
    ap = argparse.ArgumentParser(description='Migration graph of the frozen ASM oracle (see the module docstring).')
    ap.add_argument('--cap', type=int, default=6144, help='region size cap in bytes')
    ap.add_argument('--show', help='print one routine')
    args = ap.parse_args()
    if not (SYM / 'overkill.map').exists(): raise SystemExit('build/oracle-sym is missing: run python tools/hybrid.py')
    M = build_model()
    R = M.routines
    M.scc = sccs(sorted(R), lambda v: sorted({t for (t, _) in R[v].edges}))
    mets = region_metrics(M, make_regions(M, args.cap))
    regof = {r: m['id'] for m in mets for r in m['routines']}
    if args.show: show(M, args.show, regof); return
    wv = waves(M, mets)
    sccid = {m: i for i, c in enumerate(M.scc) for m in c}
    rj = {r.name: dict(
            file=r.file, line=r.line, segment=r.seg, address=fmt_addr(M, r.addr, r.seg), bytes=r.size_total,
            code_bytes=r.code_total, aliases=r.aliases, tables=[m.name for m in r.members[1:]], cls=r.cls,
            owned_by=r.owned, hardware={a: sorted(b) for a, b in r.hw.items()}, game_state=r.game,
            edges=[dict(to=R[t].name, kind=kind, count=n) for (t, kind), n in sorted(r.edges.items())],
            callers=[dict(sender=R[c].name, kind=kind, count=n) for (c, kind), n in sorted(r.callers.items())],
            state={a: sorted(b) for a, b in r.state.items()}, scc=sccid[k], region=regof.get(k),
            falls_into=R[r.falls_into].name if r.falls_into else None)
          for k, r in sorted(R.items(), key=lambda kv: kv[1].addr)}
    cs = {b.name: dict(file=b.file, line=b.line, segment=b.seg, address=fmt_addr(M, b.addr, b.seg), bytes=b.size,
                       code_offsets=sorted(R[routine_of(M, t)].name for t in code_targets(M, b.name.upper())))
          for b in sorted(M.csdata.values(), key=lambda b: b.addr)}
    write_json(OUT / 'graph.json', dict(
        routines=rj, cs_data=cs, sccs=[[R[m].name for m in c] for c in M.scc if len(c) > 1],
        glue_groups=[[R[m].name for m in g] for g in M.glue_groups],
        glue_crossing=[dict(sender=R[a].name, to=R[b].name, why=w) for a, b, w in M.glue_crossing],
        tail_fragments={R[k].name: [R[j].name for j in v] for k, v in M.tail_fragments.items()},
        regions=[dict(m, routines=[R[x].name for x in m['routines']]) for m in mets], waves=wv,
        platform_globals=sorted(M.platform_globals), problems=M.problems, parameters=dict(cap=args.cap)))
    report = make_report(M, mets, wv, args)
    (OUT / 'report.md').write_text(report, encoding='utf-8')
    head = report.split('\n### Region details')[0]
    print(head if len(head) < 12000 else head[:12000] + '\n...')
    print(f'\nWrote {OUT / "graph.json"} and {OUT / "report.md"}')

if __name__ == '__main__':
    main()
