"""ASM-vs-C differential tests: the exact oracle EXE and the DOS hybrid EXE, side by side.

Both linked programs are loaded as DOS would (tools/emu.py): build/oracle-sym is the exact
oracle image with every label public, build/hybrid the shipped hybrid. A case writes the
same bytes into both state segments (each starts from its own pristine image), enters the
same oracle label in both with the same registers (in the hybrid that label may be a
bridge into C), and then compares:

  - the whole state segment (D330h bytes), except the static code-address tables whose
    words legitimately differ between the two links and the stack scratch below the
    caller's SP (the C side uses more stack);
  - the registers and flags the routine's contract keeps or returns;
  - every write outside the state segment, in order, by symbol (code-segment variables)
    or by address (video memory), and the port traffic; an interrupt fails the case.

Suites live in tests/*.py: `cases(rng, scale, pair)` yields Case objects; an optional
MUTANTS list of (file, old, new) edits to c/*.c must each make the suite fail.

    python tools/difftest.py                    all suites, default scale
    python tools/difftest.py movement 20        one suite, 20x the default case count
    python tools/difftest.py --mutants          every mutant must be detected
"""
from common import *
from build import main_sources
from emu import Machine, FLAG, LOAD
from unicorn import UC_HOOK_MEM_WRITE
import bisect, importlib, itertools, random, re, shutil, sys, time

STATE_BYTES = 0xD330
ALL_REGS = ('AX', 'BX', 'CX', 'DX', 'SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS')

class OracleFault(AssertionError):
    """The oracle itself faulted, hung or hit an interrupt: the state is not one the game can
    reach (suites must not produce it; the fuzzer discards it)."""

class Case:
    """One call: `writes` is a list of (state offset, bytes); `preserve` names the
    registers the contract keeps, `outputs` the registers it returns, `flags` the flags
    callers consume; `expect(oracle_machine, regs)` may assert a documented property."""
    def __init__(self, label, regs=None, writes=(), preserve=ALL_REGS, outputs=(), flags=(), expect=None, name=''):
        self.label, self.regs, self.writes = label, dict(regs or {}), list(writes)
        self.preserve, self.outputs, self.flags, self.expect, self.name = preserve, outputs, flags, expect, name

class Side:
    def __init__(self, exe):
        self.m = Machine(exe)
        self.m.start_runtime()
        self.pristine = self.m.state()
        base, end = self.m.data_frame * 16, self.m.data_frame * 16 + STATE_BYTES
        self.image = (LOAD * 16, LOAD * 16 + len(self.m.image))
        self.by_address = sorted(((LOAD + seg) * 16 + off, name) for name, (seg, off) in self.m.symbols.items())
        self.keys = [a for a, _ in self.by_address]
        self.outside, self.undo = [], []
        def write(u, access, address, size, value, _):
            if not (base <= address and address + size <= end):
                self.outside.append((self.where(address), size, value & ((1 << 8 * size) - 1)))
                self.undo.append((address, bytes(u.mem_read(address, size))))
        self.m.u.hook_add(UC_HOOK_MEM_WRITE, write)

    def where(self, address):
        """A write target both links agree on: a DS offset past the state data (e.g. through a
        pointer of FFFFh), label+offset inside the image, else the address."""
        ds = self.m.data_frame * 16
        if ds + STATE_BYTES <= address < ds + 0x10000:
            return f'DS:{address - ds:04X}'
        if self.image[0] <= address < self.image[1]:
            i = bisect.bisect_right(self.keys, address) - 1
            return f'{self.by_address[i][1]}+{address - self.keys[i]:X}'
        return f'{address:05X}'

    def run(self, case, sp, fresh=True, keep=False):
        """fresh: start from the pristine state (else continue from the last step's state);
        keep: leave writes outside the state segment in place for a following step."""
        if fresh:
            self.m.set_state(self.pristine); self.undo = []
        for off, data in case.writes: self.m.write(off, data)
        self.before = self.m.read(0, STATE_BYTES)
        self.outside = []
        try:
            regs = self.m.call(case.label, case.regs, sp=sp)
            return regs, self.m.read(0, STATE_BYTES)
        finally:
            if not keep: self.rollback()

    def rollback(self):
        # Writes outside the state segment (video memory, buffers, CS variables) are undone
        # so every case starts from the same runtime.
        for address, old in reversed(self.undo): self.m.u.mem_write(address, old)
        self.undo = []

class Pair:
    def __init__(self, oracle=ROOT/'build/oracle-sym/OVERKILL.EXE', hybrid=ROOT/'build/hybrid/OVERKILL.EXE'):
        self.a, self.b = Side(oracle), Side(hybrid)
        pa, pb = self.a.pristine[:STATE_BYTES], self.b.pristine[:STATE_BYTES]
        # Static tables of code offsets differ between the two links; nothing else may.
        self.mask = bytes(1 if pa[i] != pb[i] else 0 for i in range(STATE_BYTES))
        self.stack_area = self.a.m.offset('StackArea')
        self.sym = self.a.m.offset

    def sequence(self, steps, sp=None):
        """Run steps in order on both sides, each from the state the previous step left, and
        compare after every step: the first divergence names its step."""
        try:
            for i, case in enumerate(steps):
                try:
                    self.compare(case, sp, fresh=(i == 0), keep=(i < len(steps) - 1))
                except AssertionError as e:
                    raise AssertionError(f'step {i + 1}/{len(steps)}: {e}') from None
        finally:
            self.a.rollback(); self.b.rollback()

    def compare(self, case, sp=None, fresh=True, keep=False):
        sp = self.a.m.stack_top - 0x40 if sp is None else sp
        try:
            try:
                ra, sa = self.a.run(case, sp, fresh, keep)
            except AssertionError as e:
                raise OracleFault(f'oracle: {e}') from None
            try:
                rb, sb = self.b.run(case, sp, fresh, keep)
            except AssertionError as e:
                raise AssertionError(f'hybrid only: {e}') from None
        except AssertionError:
            self.a.rollback(); self.b.rollback(); raise
        where = f'{case.label} {case.name}'
        if self.a.m.ports != self.b.m.ports:
            raise AssertionError(f'{where}: port traffic differs\n  oracle {self.a.m.ports[:6]}\n  hybrid {self.b.m.ports[:6]}')
        if self.a.outside != self.b.outside:
            raise AssertionError(f'{where}: writes outside the state segment differ\n  oracle {self.a.outside[:6]}\n  hybrid {self.b.outside[:6]}')
        # Segment values are compared relative to each image's state segment frame.
        for regs, side in ((ra, self.a), (rb, self.b)):
            for r in ('DS', 'SS', 'ES'):
                if r == 'ES' and 'ES' in case.regs and regs[r] == case.regs['ES']: regs[r] = 'unchanged'
                elif regs[r] == side.m.data_frame: regs[r] = 'state segment'
        # Preserved registers must come back as the oracle leaves them (its contract);
        # outputs must agree; other registers are scratch for this routine.
        for r in set(case.preserve) | set(case.outputs):
            if ra[r] != rb[r]: raise AssertionError(f'{where}: register {r} oracle {ra[r]} hybrid {rb[r]}')
        for f in case.flags:
            if (ra['FLAGS'] ^ rb['FLAGS']) & FLAG[f]: raise AssertionError(f'{where}: flag {f} differs')
        if sa != sb:
            for i in range(STATE_BYTES):
                if sa[i] != sb[i] and not self.mask[i] and not (self.stack_area <= i < sp - 2):
                    raise AssertionError(f'{where}: state byte {i:04X} ({self.name_of(i)}) oracle {sa[i]:02X} hybrid {sb[i]:02X}')
        if case.expect: case.expect(self.a.m, ra)
        return ra, sa

    def name_of(self, off):
        return self.a.where(self.a.m.data_frame * 16 + off)

def run_suites(names=None, scale=1, seed=0x0F67C9B, pair=None, quiet=False):
    pair = pair or Pair()
    total = 0
    for name in names or suite_names():
        module = importlib.import_module(name)
        rng = random.Random(seed); t = time.time(); n = 0
        cases = module.cases(rng, scale, pair) if hasattr(module, 'cases') else ()
        if getattr(module, 'FUZZ', ()):
            from fuzz import corpus_cases   # saved fuzz corpora replay as regression cases
            cases = itertools.chain(cases, *(corpus_cases(t) for t in module.FUZZ))
        for case in cases:
            if isinstance(case, list): pair.sequence(case); n += len(case)
            else: pair.compare(case); n += 1
        if not quiet: print(f'PASS {name}: {n} cases in {time.time() - t:.1f} s', flush=True)
        total += n
    return total

def suite_names():
    return sorted(p.stem for p in (ROOT/'tests').glob('*.py'))

def run_mutants(names=None):
    """Build a hybrid per mutant (one edit to one C file) and require every suite that
    lists it to fail: evidence that the comparisons can see the kind of slip they guard."""
    import hybrid
    killed = 0
    for name in names or suite_names():
        module = importlib.import_module(name)
        for path, old, new in getattr(module, 'MUTANTS', ()):
            cdir = ROOT/'build/mutant/c'; shutil.rmtree(cdir, ignore_errors=True); shutil.copytree(ROOT/'c', cdir)
            text = (cdir/path).read_bytes().decode('latin-1')
            if '\r\n' in text: old, new = (x.replace('\r\n', '\n').replace('\n', '\r\n') for x in (old, new))
            if text.count(old) != 1: raise ValueError(f'mutant {old!r} must match once in {path}')
            (cdir/path).write_bytes(text.replace(old, new).encode('latin-1'))
            exe, _ = hybrid.build(ROOT/'build/mutant/hybrid', c_dir=cdir)
            try:
                run_suites([name], 1, pair=Pair(hybrid=exe), quiet=True)
            except AssertionError as e:
                killed += 1; print(f'KILLED {name}: {old!r} -> {new!r}\n  {str(e).splitlines()[0]}', flush=True); continue
            raise AssertionError(f'SURVIVED {name}: {old!r} -> {new!r}')
    return killed

def coverage(names=None, scale=1):
    """Run the suites while recording which instructions of the oracle's C-owned code the
    oracle side executed; every instruction should be reached."""
    import hybrid
    from unicorn import UC_HOOK_CODE
    pair = Pair(); m = pair.a.m
    from fuzz import region_instructions
    code = {name: region_instructions(m, [name]) for name in hybrid.owned_labels()}
    hit = set()
    lo = min(min(v) for v in code.values()); hi = max(max(v) for v in code.values())
    m.u.hook_add(UC_HOOK_CODE, lambda u, address, size, _: hit.add(address), None, lo, hi)
    run_suites(names, scale, pair=pair)
    missed = 0
    for name, addresses in sorted(code.items()):
        gone = [a for a in addresses if a not in hit]; missed += len(gone)
        print(f'{name}: {len(addresses) - len(gone)}/{len(addresses)} instructions'
              + (' MISSED ' + ' '.join(f'{a:05X}' for a in gone) if gone else ''))
    return missed

if __name__ == '__main__':
    sys.path.insert(0, str(ROOT/'tests'))
    args = sys.argv[1:]
    if args and args[0] == '--coverage':
        sys.exit(1 if coverage(args[1:] or None) else 0)
    if args and args[0] == '--mutants':
        print('PASS mutants:', run_mutants(args[1:] or None), 'killed'); sys.exit()
    scale = int(args.pop()) if args and args[-1].isdigit() else 1
    print('PASS all:', run_suites(args or None, scale), 'cases')
