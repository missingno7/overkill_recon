"""Test-state builders: memory states for the real oracle and hybrid executables.

A World collects writes into the game state segment (by label, field and offset); a Case
or fuzz corpus entry is just those writes plus an entry label and registers. Nothing here
models game behaviour: it only places values where the oracle keeps them. Field offsets
and constants come from include/*.INC (the same source as the C header).

    w = World(pair, rng)
    w.plausible()                         # counters, level, difficulty, player, scroll
    r = w.record('PoolA', 3).live(kind=K.KIND_ENEMY, type=0x12)
    r.set(saved_x=0x40); w.fill('PoolB', 34)       # a full pool B
    Case('RunTypeHandler', {'BP': r.at}, w.writes(), ...)
"""
from common import *
import re, struct

def _equates():
    rows = {}
    for path in sorted((ROOT/'include').glob('*.INC')):
        for m in re.finditer(r'^(\w+)[ \t]+equ[ \t]+([^;\r\n]+)', path.read_bytes().decode('latin-1'), re.M):
            rows[m[1]] = m[2].strip()
    values = {}
    def value(name):
        if name in values: return values[name]
        expr = re.sub(r'\b([0-9][0-9A-Fa-f]*)[hH]\b', lambda m: str(int(m[1], 16)), rows[name])
        expr = re.sub(r'\b([A-Za-z_]\w*)\b', lambda m: str(value(m[1])) if m[1] in rows else m[1], expr)
        try: values[name] = int(eval(expr, {}))
        except Exception: values[name] = None
        return values[name]
    for n in rows: value(n)
    return {n: v for n, v in values.items() if v is not None}

EQU = _equates()

class K:
    """Constants of include/*.INC as attributes (K.KIND_ENEMY, K.DIR_UP, K.RECORD_SIZE...)."""
for _n, _v in EQU.items(): setattr(K, _n, _v)

RECORD = EQU['RECORD_SIZE']
FIELDS = {n[4:].lower(): v for n, v in EQU.items() if n.startswith('REC_')}   # incl. role aliases
POOLS = {'PrimaryRecord': 1, 'PoolA': EQU['POOL_A_COUNT'], 'PoolB': EQU['POOL_B_COUNT']}
EDGE_WORDS = (0, 1, 2, 3, 4, 7, 8, 0x0F, 0x10, 0x20, 0x7F, 0x80, 0xFF, 0x100, 0x7FFE, 0x7FFF, 0x8000,
              0x8001, 0xFF00, 0xFFF0, 0xFFFC, 0xFFFE, 0xFFFF)

def edge_word(rng, near=None):
    """Edge-biased 16-bit value: boundaries, small signed values, values near `near`, anything."""
    k = rng.randrange(10)
    if k < 3: return rng.choice(EDGE_WORDS)
    if k < 5: return rng.randrange(-0x120, 0x120) & 0xFFFF
    if k < 8 and near is not None: return (near + rng.randrange(-17, 18)) & 0xFFFF
    return rng.randrange(0x10000)

class Record:
    """One 38h-byte record in a world; fields by name (RECORDS.INC without REC_)."""
    def __init__(self, world, at, data=None):
        self.world, self.at = world, at
        self.data = bytearray(data if data is not None else RECORD)
        world._records[at] = self
    def set(self, **fields):
        for name, v in fields.items(): struct.pack_into('<H', self.data, FIELDS[name], v & 0xFFFF)
        return self
    def get(self, name): return struct.unpack_from('<H', self.data, FIELDS[name])[0]
    def randomize(self):
        """Every byte random: a stale or never-initialised slot."""
        self.data[:] = bytes(self.world.rng.randrange(256) for _ in range(RECORD)); return self
    def live(self, kind=None, type=None, size=None, **fields):
        """A plausible live record: random fields, then status 1, the given kind/type, an
        on-playfield position, a direction 0..7, no group and no flash unless given."""
        rng = self.world.rng
        self.randomize()
        self.set(status=1, y=rng.randrange(-0x30, 0x100), x=rng.randrange(0, K.PLAYFIELD_MAX_X + 1),
                 direction=rng.randrange(8), slot_index=0xFFFF, flash_timer=0, draw_pass=rng.randrange(2),
                 hit_points=rng.randrange(1, 8), size_class=rng.choice((0, 1, 1, 2)) if size is None else size)
        if kind is not None: self.set(kind=kind)
        if type is not None: self.set(type=type)
        return self.set(**fields)
    def free(self, stale=True):
        """A free slot (status 0); with stale=True the old occupant's fields stay."""
        if not stale: self.data[:] = bytes(RECORD)
        return self.set(status=0)

class World:
    def __init__(self, pair, rng):
        self.pair, self.rng, self.sym = pair, rng, pair.sym
        self._writes, self._records = {}, {}

    # raw placement
    def put(self, where, data):
        off = self.sym(where) if isinstance(where, str) else where
        self._writes[off] = bytes(data); return self
    def word(self, where, value, index=0):
        off = (self.sym(where) if isinstance(where, str) else where) + 2 * index
        return self.put(off, struct.pack('<H', value & 0xFFFF))
    def byte(self, where, value):
        return self.put(where, bytes([value & 0xFF]))
    def writes(self):
        w = dict(self._writes)
        for at, r in self._records.items(): w[at] = bytes(r.data)
        return sorted(w.items())

    # records and pools
    def slot(self, pool, index): return self.sym(pool) + RECORD * index
    def record(self, pool, index):
        at = self.slot(pool, index)
        return self._records.get(at) or Record(self, at)
    def any_record(self, pools=('PoolA', 'PoolB')):
        pool = self.rng.choice(pools)
        return self.record(pool, self.rng.randrange(POOLS[pool]))
    def fill(self, pool, count, **live):
        """`count` live records at random slots of the pool, the rest free but stale."""
        slots = list(range(POOLS[pool])); self.rng.shuffle(slots)
        for i, s in enumerate(slots):
            r = self.record(pool, s)
            if i < count: r.live(**live)
            else: r.randomize().free()
        return self
    def player(self, **fields):
        rng = self.rng
        p = self.record('PrimaryRecord', 0)
        p.data[:] = bytes(RECORD)
        p.set(status=1, y=rng.randrange(K.SHIP_Y_MIN, K.SHIP_Y_MAX + 1), x=rng.randrange(0, K.SHIP_X_MAX + 1),
              sprite=rng.randrange(3), size_class=1, kind=K.KIND_PLAYER)
        return p.set(**fields)

    # global state
    def counters(self):
        for name, mod in (('FrameCount4', 4), ('FrameCount8', 8), ('FrameCount16', 16), ('FrameCount32', 32),
                          ('FrameCount64', 64), ('FrameCount128', 128), ('FrameParity', 2),
                          ('RecordTickCounter', 0x5DC), ('EncounterTicks', 0x100)):
            self.word(name, self.rng.randrange(mod))
        return self
    def plausible(self):
        """A mid-game world: counters, level, difficulty, sound flags, scroll, the player."""
        rng = self.rng
        self.counters()
        self.word('LevelIndex', rng.randrange(K.LEVEL_COUNT)).word('DifficultySetting', rng.randrange(3))
        self.byte('SfxEnabled', rng.randrange(2)).word('ScrollDeltaY', rng.choice((0, 0, 1, 2)))
        self.word('EncounterLiveCount', rng.randrange(8)).word('MissilesLive', rng.randrange(3))
        # The level map is not loaded in tests: rows past MAP_END_POS read whatever follows.
        self.word('MapScrollPos', rng.randrange(K.MAP_START_POS, K.MAP_END_POS + 1))
        self.player()
        return self
