"""Coverage-guided differential fuzzing: the oracle's own execution picks the test states.

A target (declared by a suite as FUZZ = [Target(...)]) names an entry label, a seed
builder (tools/world.py) and the region whose oracle code guides the search. Each
candidate state runs on BOTH executables (difftest.Pair.compare: any divergence stops
the run); the oracle side also yields features:

  - branch edges (previous instruction -> instruction) inside the region's oracle code,
    which covers taken/not-taken branches and every dispatch-table target reached;
  - transitions of the entry record (REC_TYPE, REC_KIND, REC_STATUS before -> after),
    pool A/B occupancy changes (spawn, free, full), and watched globals (bucketed).

A state that shows a new feature joins the corpus and is mutated further (record fields,
types, pointers, aliasing, pool occupancy, counters and other globals, boundary values).

    python tools/fuzz.py movement 3000            fuzz the targets of tests/movement.py
    python tools/fuzz.py movement 3000 --save     also store the corpus in tests/corpus/
"""
from common import *
from difftest import Case, Pair, ALL_REGS, OracleFault
from world import World, Record, FIELDS, POOLS, RECORD, EQU, edge_word
from emu import LOAD
from build import main_sources
from unicorn import UC_HOOK_CODE
import bisect, gzip, importlib, json, random, re, sys, time, zlib

_seen = {}
for _n, _v in FIELDS.items(): _seen.setdefault(_v, _n)    # base names come before role aliases
BASE_FIELDS = list(_seen.values())

class Target:
    """entry: oracle label called; seed(world) -> regs dict (fills the world);
    region: oracle labels whose code guides coverage (default: the suite's C file OWNS);
    preserve/outputs/flags: the register contract compared; types: REC_TYPE values worth
    trying; globals: state labels the mutator may change (word-sized); domains: the value
    sets of globals or record fields whose range is a documented precondition of the
    oracle (e.g. an unchecked jump table index): the game never stores other values, so
    the mutator stays inside them."""
    def __init__(self, name, entry, seed, region=None, preserve=('BP', 'SP', 'DS', 'SS'), outputs=(),
                 flags=(), types=(), globals=(), watch=(), domains=None, pin_bp=False, seeds=8):
        self.name, self.entry, self.seed, self.region = name, entry, seed, region
        self.domains = dict(domains or {})   # value sets, or functions of the Pair
        self.pin_bp, self.seeds = pin_bp, seeds   # pin_bp: the entry record never moves (e.g. BP = PrimaryRecord)
        self.preserve, self.outputs, self.flags = preserve, outputs, flags
        self.types, self.globals, self.watch = tuple(types), tuple(globals), tuple(watch)

def code_ranges(machine, labels, sort=True):
    """(begin, end) linear ranges of the given labels' code in an oracle-sym machine: from
    the label to the next label (every label is public there)."""
    starts = sorted((LOAD + s) * 16 + o for s, o in machine.symbols.values())
    out = []
    for name in labels:
        begin = machine.linear(name)
        out.append((begin, starts[bisect.bisect_right(starts, begin)]))
    return sorted(out) if sort else out

def compare_sites(machine, labels):
    """Address -> decoded `cmp` instruction, over the region's oracle code."""
    import capstone
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16); md.detail = True
    sites = {}
    for begin, end in code_ranges(machine, labels):
        for ins in md.disasm(bytes(machine.u.mem_read(begin, end - begin)), begin):
            if ins.mnemonic == 'cmp': sites[ins.address] = ins
    return sites

def operand_values(u, ins):
    """Both operand values of a `cmp` about to execute (registers and memory now)."""
    from capstone import x86 as cx
    from unicorn.x86_const import UC_X86_REG_DS, UC_X86_REG_SS, UC_X86_REG_ES, UC_X86_REG_CS
    import unicorn.x86_const as uc
    reg = lambda r: u.reg_read(getattr(uc, 'UC_X86_REG_' + ins.reg_name(r).upper()))
    vals = []
    for op in ins.operands:
        if op.type == cx.X86_OP_IMM: vals.append(op.imm & 0xFFFF)
        elif op.type == cx.X86_OP_REG: vals.append(reg(op.reg) & 0xFFFF)
        elif op.type == cx.X86_OP_MEM:
            m = op.mem
            ea = (m.disp + (reg(m.base) if m.base else 0) + (reg(m.index) if m.index else 0)) & 0xFFFF
            if m.segment: seg = reg(m.segment)
            elif m.base and ins.reg_name(m.base) == 'bp': seg = u.reg_read(UC_X86_REG_SS)
            else: seg = u.reg_read(UC_X86_REG_DS)
            data = bytes(u.mem_read(seg * 16 + ea, op.size))
            vals.append(data[0] | (data[1] << 8 if op.size > 1 else 0))
        else: return None
    return tuple(vals) if len(vals) == 2 else None

def bucket(v):
    s = v - 0x10000 if v & 0x8000 else v
    return 'neg' if s < 0 else 'zero' if s == 0 else 'one' if s == 1 else 'small' if s < 16 else 'mid' if s < 0x100 else 'big'

class Fuzzer:
    def __init__(self, pair, target, rng):
        self.pair, self.t, self.rng = pair, target, rng
        self.domains = {k: tuple(v(pair) if callable(v) else v) for k, v in target.domains.items()}
        m = pair.a.m
        labels = target.region
        self.ranges = code_ranges(m, labels)
        self.features, self.cur, self.last, self.hit = set(), set(), None, set()
        self.cmp_sites, self.cmps = compare_sites(m, labels), []
        def code(u, address, size, _):
            self.cur.add((self.last, address)); self.hit.add(address); self.last = address
            if address in self.cmp_sites and len(self.cmps) < 64:
                pair_ = operand_values(u, self.cmp_sites[address])
                if pair_: self.cmps.append(pair_)
        for begin, end in self.ranges:
            m.u.hook_add(UC_HOOK_CODE, code, None, begin, end - 1)
        self.pools = {p: (pair.sym(p), n) for p, n in POOLS.items() if p != 'PrimaryRecord'}
        self.corpus, self.cases = [], 0

    # state representation: {offset: bytes}, regs
    def seed(self):
        w = World(self.pair, self.rng)
        regs = self.t.seed(w)
        return dict(w.writes()), dict(regs)

    def run(self, writes, regs, name):
        self.cur, self.last, self.cmps = set(), None, []
        case = Case(self.t.entry, regs, sorted(writes.items()), self.t.preserve, self.t.outputs, self.t.flags, name=name)
        self.pair.compare(case)
        self.cases += 1
        a = self.pair.a
        before, after = a.before, a.m.read(0, 0xD330)
        f = set(self.cur)
        bp = regs.get('BP')
        if bp is not None:
            for field in ('type', 'kind', 'status'):
                o = bp + FIELDS[field]
                f.add((field, before[o] | before[o + 1] << 8, after[o] | after[o + 1] << 8))
        for pool, (at, n) in self.pools.items():
            live = lambda s: sum(1 for i in range(n) if s[at + i * RECORD] | s[at + i * RECORD + 1])
            f.add((pool, min(live(before), 3), live(after) - live(before), live(after) == n))
        for name_ in self.t.watch:
            o = self.pair.sym(name_)
            b, x = before[o] | before[o + 1] << 8, after[o] | after[o + 1] << 8
            f.add((name_, bucket(b), bucket(x), b == x))
        new = f - self.features
        self.features |= f
        self.last_features = f
        return bool(new)

    def read_word(self, writes, off):
        """The word at a state offset as this candidate sets it (else the pristine value)."""
        for at, d in writes.items():
            if at <= off and off + 2 <= at + len(d): return d[off - at] | d[off - at + 1] << 8
        p = self.pair.a.pristine
        return p[off] | p[off + 1] << 8

    def write_word(self, writes, off, value):
        for at, d in writes.items():
            if at <= off and off + 2 <= at + len(d):
                d = bytearray(d); d[off - at:off - at + 2] = bytes((value & 0xFF, value >> 8)); writes[at] = bytes(d)
                return
        writes[off] = bytes((value & 0xFF, value >> 8))

    def slots(self, writes):
        """(state offset, domain key) of every word this candidate controls."""
        out = []
        for at, d in writes.items():
            if len(d) == RECORD: out += [(at + FIELDS[f], f) for f in BASE_FIELDS]
        out += [(self.pair.sym(g), g) for g in self.t.globals]
        return out

    def mutate(self, writes, regs, cmps=()):
        rng = self.rng
        writes, regs = dict(writes), dict(regs)
        records = [o for o, d in writes.items() if len(d) == RECORD]
        for _ in range(rng.choice((1, 1, 2, 3, 5))):
            k = rng.randrange(11)
            if k >= 9 and cmps:                          # solve a logged comparison
                a, b = rng.choice(cmps)
                if rng.randrange(2): a, b = b, a
                want = (b + rng.choice((0, 0, 1, -1))) & 0xFFFF
                for off, key in self.slots(writes):
                    if self.read_word(writes, off) == a and want in self.domains.get(key, (want,)):
                        self.write_word(writes, off, want)
            elif k == 8 and records:                       # equalise: copy one word into another
                # (reaches equality compares - arrival, target slots, sentinel values - that
                # random values almost never hit)
                if rng.randrange(2):                     # within one record (X -> SAVED_X...)
                    at = rng.choice(records)
                    slots = [(at, FIELDS[f], f) for f in BASE_FIELDS]
                else:
                    slots = [(at, FIELDS[f], f) for at in records for f in BASE_FIELDS]
                    slots += [(self.pair.sym(g), 0, g) for g in self.t.globals]
                (sa, so, _), (da, do, dname) = rng.sample(slots, 2)
                value = self.read_word(writes, sa + so)
                if value in self.domains.get(dname, (value,)): self.write_word(writes, da + do, value)
            elif k <= 2 and records:                     # a record field
                at = rng.choice(records); d = bytearray(writes[at])
                field = rng.choice(BASE_FIELDS); off = FIELDS[field]
                old = d[off] | d[off + 1] << 8
                if field in self.domains: v = rng.choice(self.domains[field])
                elif field == 'type' and self.t.types and rng.randrange(2): v = rng.choice(self.t.types)
                else: v = rng.choice((edge_word(rng, old), (old + rng.choice((-1, 1))) & 0xFFFF, old ^ (1 << rng.randrange(16))))
                d[off:off + 2] = bytes((v & 0xFF, v >> 8)); writes[at] = bytes(d)
            elif k == 3 and records:                     # status: live <-> free (stale)
                at = rng.choice(records); d = bytearray(writes[at])
                d[0:2] = b'\0\0' if d[0] | d[1] else b'\1\0'; writes[at] = bytes(d)
            elif k == 4 and len(records) > 1:            # aliasing: copy a record, or point at one
                a, b = rng.sample(records, 2); d = bytearray(writes[b])
                if rng.randrange(2): d[:] = writes[a]
                else:
                    off = FIELDS[rng.choice([f for f in ('target', 'field_36', 'field_1c') if f not in self.domains] or ['target'])]
                    d[off:off + 2] = bytes((a & 0xFF, a >> 8))
                writes[b] = bytes(d)
            elif k == 5:                                 # a new live record somewhere
                pool = rng.choice(list(self.pools)); at, n = self.pools[pool]
                w = World(self.pair, rng); r = Record(w, at + RECORD * rng.randrange(n))
                r.live(type=rng.choice(self.t.types) if self.t.types else None)
                for field, values in self.domains.items():
                    if field in FIELDS: r.set(**{field: rng.choice(values)})
                writes[r.at] = bytes(r.data)
            elif k == 6 and self.t.globals:              # a global
                name = rng.choice(self.t.globals); o = self.pair.sym(name)
                old = writes.get(o, self.pair.a.pristine[o:o + 2])
                old = old[0] | (old[1] << 8 if len(old) > 1 else 0)
                v = rng.choice(self.domains[name]) if name in self.domains else edge_word(rng, old)
                writes[o] = bytes((v & 0xFF, v >> 8))
            elif records and 'BP' in regs and not self.t.pin_bp:   # the entry record moves to another slot
                at = rng.choice(records); regs['BP'] = at
        return writes, regs

    def fuzz(self, iterations, seeds=None):
        seeds = self.t.seeds if seeds is None else seeds
        t0 = time.time()
        for i in range(seeds):
            w, r = self.seed()
            self.run(w, r, f'{self.t.name} seed {i}'); self.corpus.append((w, r, list(self.cmps), self.last_features))
        for i in range(iterations):
            base = self.rng.choice(self.corpus)
            w, r = self.mutate(*base[:3])
            try:
                keep = self.run(w, r, f'{self.t.name} fuzz {i}')
            except OracleFault:
                continue    # the oracle itself crashes or hangs here: an unreachable state
            except AssertionError:
                self.dump(w, r); raise
            if keep: self.corpus.append((w, r, list(self.cmps), self.last_features))
        return dict(target=self.t.name, cases=self.cases, corpus=len(self.corpus), features=len(self.features),
                    seconds=round(time.time() - t0, 1))

    def dump(self, writes, regs):
        path = ROOT/'build/fuzz'/f'{self.t.name}-failure.json'; path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(dict(entry=self.t.entry, regs=regs, writes={f'{o:04X}': d.hex() for o, d in writes.items()}), indent=1))
        print('failing state saved to', path)

    def instruction_coverage(self):
        """(hit, total, missed addresses) over the region's oracle instructions."""
        code = region_instructions(self.pair.a.m, self.t.region)
        missed = [a for a in code if a not in self.hit]
        return len(code) - len(missed), len(code), missed

def jump_tables():
    """Label -> byte size of the `X label word` + dw-row jump tables in the oracle code."""
    tables = {}
    for path in main_sources():
        text = path.read_bytes().decode('latin-1')
        for mt in re.finditer(r'^(\w+)[ \t]+label[ \t]+word[ \t]*\r?\n((?:[ \t]+dw[^\r\n]*\r?\n)+)', text, re.M | re.I):
            tables[mt[1].upper()] = 2 * sum(len(row.split(';')[0].split(',')) for row in mt[2].splitlines())
    return tables

def region_instructions(machine, labels):
    """Linear addresses of the oracle instructions in the given labels' code (jump table
    words skipped), decoded from an oracle-sym machine."""
    import capstone
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
    tables = jump_tables()
    out = []
    for (begin, end), name in zip(code_ranges(machine, labels, sort=False), labels):
        begin += tables.get(name.upper(), 0)
        out += [i.address for i in md.disasm(bytes(machine.u.mem_read(begin, end - begin)), begin)]
    return sorted(out)

def minimize(corpus):
    """Greedy set cover: the fewest entries that together keep every feature."""
    left, keep = set().union(*(e[3] for e in corpus)), []
    while left:
        best = max(corpus, key=lambda e: len(e[3] & left))
        keep.append(best); left -= best[3]
    return keep

def save_corpus(fz):
    path = ROOT/'tests/corpus'/f'{fz.t.name}.json.gz'; path.parent.mkdir(parents=True, exist_ok=True)
    rows = [dict(regs=r, writes={f'{o:04X}': d.hex() for o, d in sorted(w.items())}) for w, r, _, _ in minimize(fz.corpus)]
    path.write_bytes(gzip.compress((json.dumps(rows, indent=0, sort_keys=True) + '\n').encode(), mtime=0))
    return path

def corpus_cases(target):
    """Replay a saved corpus (tests/corpus/<target>.json.gz) as ordinary differential cases."""
    path = ROOT/'tests/corpus'/f'{target.name}.json.gz'
    if not path.exists(): return
    for i, row in enumerate(json.loads(gzip.decompress(path.read_bytes()))):
        writes = sorted((int(o, 16), bytes.fromhex(d)) for o, d in row['writes'].items())
        yield Case(target.entry, row['regs'], writes, target.preserve, target.outputs, target.flags, name=f'{target.name} corpus {i}')

def main(argv):
    """Fuzz every FUZZ target of the named suites; report per target and, per suite, the
    union coverage of its region's oracle instructions."""
    sys.path.insert(0, str(ROOT/'tests'))
    save = '--save' in argv; argv = [a for a in argv if a != '--save']
    names = [a for a in argv if not a.isdigit()]; its = int(next((a for a in argv if a.isdigit()), 2000))
    for name in names or sorted(p.stem for p in (ROOT/'tests').glob('*.py')):
        module = importlib.import_module(name)
        targets = getattr(module, 'FUZZ', ())
        hit, region = set(), set()
        for target in targets:
            fz = Fuzzer(Pair(), target, random.Random(zlib.crc32(target.name.encode())))
            stats = fz.fuzz(its)
            h, total, _ = fz.instruction_coverage()
            hit |= fz.hit; region |= set(region_instructions(fz.pair.a.m, target.region))
            print(f'PASS fuzz {target.name}: {stats["cases"]} cases, corpus {stats["corpus"]}, '
                  f'{stats["features"]} features, region instructions {h}/{total}, {stats["seconds"]} s', flush=True)
            if save: print('  corpus saved:', save_corpus(fz))
        if targets:
            missed = sorted(region - hit)
            print(f'{name}: union oracle instruction coverage {len(region) - len(missed)}/{len(region)}'
                  + (f'; missed {" ".join(f"{a:05X}" for a in missed[:32])}' if missed else ''))

if __name__ == '__main__':
    main(sys.argv[1:])
