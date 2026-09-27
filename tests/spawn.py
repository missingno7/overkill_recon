"""Spawn region (c/spawn.c): map row spawning, level script, formation leaders, pool A.

Entries: every bridge label (FindFreeRecordPoolA, SpawnMapEnemy, Level0..5MapCell,
DrawIncomingMapRow, the two demo steps), the leader handlers (types 13h... and the level 4
type 21h path) through RunTypeHandler (c/enemies.c, which also calls SpawnEnemyHere/Quiet
directly now), the real callers DrawMapRowIntoScrollBand
and EnterNextMapRowForward, and sequences of map rows entering with record updates between
them. The level map (SlotBuffer, the segment in LevelMapSegment) and Type21PathCursor live
outside the state segment and are placed with difftest.far().
"""
from difftest import Case, ALL_REGS, far
from world import World, K, RECORD
import struct

LOOP = ('BP', 'SP', 'DS', 'SS')
MAP_BYTES = K.MAP_END_POS               # 288 rows of 13 cells: all of SlotBuffer
ROW = K.MAP_ROW_BYTES

def keep(*scratch): return tuple(r for r in ALL_REGS if r not in scratch)

# Map bytes each level's handler acts on. The range checks of levels 0/3/4/5 also admit two
# bytes past their dispatch tables, which the oracle would execute as code addresses; the
# maps never hold them, so they are left out (an oracle precondition, like DIR 0..7).
CELLS = {
    0: [0xBB, 0xBC] + list(range(0xE1, 0xFA)),
    1: [0x04, 0x07, 0x6C, 0x6D, 0xAC, 0xB1, 0xC9],
    2: [0x30, 0xC4, 0x5A],
    3: list(range(0xCE, 0xEA)),
    4: [0xAC, 0xB1, 0xC9] + list(range(0xCE, 0xE1)),
    5: [0x30, 0xBA, 0xBB, 0xBC, 0xB6, 0xD2, 0xD3] + list(range(0xD7, 0xF0)),
}
FORBIDDEN = {0: {0xFA, 0xFB}, 1: set(), 2: set(), 3: {0xEA, 0xEB}, 4: {0xE1, 0xE2}, 5: {0xF0, 0xF1}}
ALL_CELLS = sorted(set(c for v in CELLS.values() for c in v))
NEVER = set().union(*FORBIDDEN.values())
PLAIN = [0, 1, 2, 3, 0x10, 0x26, 0x28, 0x55, 0x80, 0xA0, 0xFF]
LEADER_TYPES = (0x13, 0x15, 0x1C, 0x1F, 0x7D, 0x7E)
LEADER_SCRIPTS = {0x13: ('LeaderScript13', 'LeaderScript13End', 4), 0x15: ('LeaderScript15', 'LeaderScript15End', 8),
                  0x1C: ('LeaderScript1C', 'LeaderScript1CEnd', 8), 0x1F: ('LeaderScript1F', 'LeaderScript1FEnd', 4),
                  0x7D: ('LeaderScript7D', 'LeaderScript7DEnd', 8), 0x7E: ('LeaderScript7E', 'LeaderScript7EEnd', 8)}

def cell(rng, level, own=True, plain=3):
    """A map byte for a level: mostly one it acts on (own) or any level's byte it admits."""
    if rng.randrange(plain):
        return rng.choice(CELLS[level] if own else [c for c in ALL_CELLS if c not in FORBIDDEN[level]])
    return rng.choice(PLAIN)

BLOCKING = range(0x40, 0x80)      # map bytes whose attribute may be set (no level's past-table byte)

def attributes(w):
    """ByteAttributeTable (all 0 in the image) with random attributes for bytes 40h..7Fh;
    returns the clear and the blocking bytes."""
    rng = w.rng
    table = bytes(rng.choice((0, 1, 2, 0x10)) for _ in BLOCKING)
    w.put(w.sym('ByteAttributeTable') + BLOCKING[0], table)
    blocking = [b for b, a in zip(BLOCKING, table) if a]
    return [b for b in range(256) if b not in NEVER and b not in blocking], blocking

# Fuzz seeds place a window of map rows (and MapScrollPos stays in it) to keep corpora small.
WINDOW = range(100, 116)

def level_map(w, level, own=True, density=3, rows=range(MAP_BYTES // ROW), blocked=2):
    """Map rows of cells the level (own) or any level acts on (never the bytes past the
    level's dispatch table); half the rows blocking but for one cell (long column scans),
    every row with at least one attribute-clear cell (a formation column snap needs one)."""
    rng = w.rng
    clear, blocking = attributes(w)
    data = bytearray()
    for _ in rows:
        if rng.randrange(blocked): row = [cell(rng, level, own, density) if rng.randrange(density) else rng.choice(PLAIN) for _ in range(ROW)]
        else: row = [rng.choice(blocking) for _ in range(ROW)]
        row[rng.randrange(ROW)] = rng.choice(clear)
        data += bytes(row)
    w.put(far('SlotBuffer', rows[0] * ROW), data)
    return data

def groups(w):
    """GroupTable: mostly free entries, some live; sometimes all 16 taken."""
    rng = w.rng
    full = rng.randrange(6) == 0
    w.put('GroupTable', bytes(v for _ in range(16) for v in ((rng.randrange(1, 4) if full or rng.randrange(3) == 0 else 0),
                                                             rng.randrange(5))))

def pool_a(w, fill=None, compact=False):
    """Pool A with `fill` live records; compact: only their status words (the image's pool is
    all zero), else whole random records and stale free slots."""
    rng = w.rng
    n = fill if fill is not None else rng.choice((0, 3, 10, 20, 33, 34, 35, 35))
    if compact:
        for k in rng.sample(range(K.POOL_A_COUNT), n): w.word(w.slot('PoolA', k), 1)
    else:
        w.fill('PoolA', n, kind=K.KIND_ENEMY)
    w.word('PoolACursor', w.slot('PoolA', rng.randrange(K.POOL_A_COUNT)))
def random_cursor(w):
    w.word('RandomWordCursor', w.sym('CreditRandomWords') + 2 * w.rng.randrange(16))

def script_events(pair, level):
    """Offsets of the events of LevelScript<level> in the pristine state (and its end)."""
    mem = pair.a.pristine
    wd = lambda o: mem[o] | mem[o + 1] << 8
    at, out = pair.sym(f'LevelScript{level}'), []
    while True:
        out.append(at)
        if wd(at) == 0xFFFF: return out
        at += 2
        if wd(at) == 0xFFFF: at += 2
        at += 6

def real_script(w, level):
    """The level's script cursor at one of its events, the clock at or just above it."""
    rng, mem = w.rng, w.pair.a.pristine
    events = script_events(w.pair, level)
    at = rng.choice(events)
    trigger = mem[at] | mem[at + 1] << 8
    w.word('LevelScriptCursors', at, index=level)
    w.word('LevelScriptClock', trigger + rng.choice((0, 0, 0, 1, 2)) if trigger != 0xFFFF else rng.randrange(0x120))

def synthetic_script(w, level, types=None):
    """A made-up script over the level's own script area: events (one per given type, else
    one to three) mostly sharing the trigger, formations of any type, size, draw pass and
    count (0 = until pool A is full), with or without the 0FFFFh marker."""
    rng, s = w.rng, w.sym
    base = s(f'LevelScript{level}')
    form_at = s('Formation00')
    trigger = rng.randrange(0x10, 0x120)
    words, forms = [], []
    given = bool(types)
    types = types or [None] * rng.choice((1, 1, 2, 3))
    for e, ftype in enumerate(types):
        f = form_at + 2 * sum(len(x) for x in forms)
        count = rng.choice((1, 1, 2, 3, 5, 0)) if rng.randrange(8) else 0
        if given and e < len(types) - 1: count = count or 1     # only the last may fill pool A
        # Member X >= 0: the column snap reads the map row at X / 16 (a negative X would read far
        # past the map, into code whose relocated words differ between the links).
        members = [v for _ in range(max(count, 3)) for v in (16 * rng.randrange(0, 12) + rng.choice((0, 0, 3)),
                                                            -16 * rng.randrange(0, 3) + rng.choice((0, 0, 5)))]
        if ftype is None: ftype = rng.choice(LEADER_TYPES + (0x21, 0x21, 0x4F, 0x14, rng.randrange(0x100)))
        forms.append([rng.choice((1, 1, 0, 2)), rng.choice((0, 0, 1)), ftype, count] + members)
        words += [trigger if e == 0 or rng.randrange(8 if given else 4) else trigger - 1]
        if rng.randrange(3) == 0: words.append(0xFFFF)
        words += [f, rng.randrange(0, 0xC1), rng.choice((-16, -32, 0, 16, 32, -8))]
    words.append(0xFFFF)
    pack = lambda ws: struct.pack(f'<{len(ws)}H', *(v & 0xFFFF for v in ws))
    w.put(base, pack(words))
    w.put(form_at, pack([v for x in forms for v in x]))
    w.word('LevelScriptCursors', base, index=level)
    w.word('LevelScriptClock', trigger)

def row_world(w, level=None, synthetic=False, pos=None, compact=False):
    """A world for DrawIncomingMapRow: level, map, script, pools, groups, the scroll row;
    compact: map rows around WINDOW only (the fuzz seeds, whose MapScrollPos stays there)."""
    rng = w.rng
    w.plausible()
    level = rng.randrange(6) if level is None else level
    w.word('LevelIndex', level)
    rows = range(WINDOW[0] - 4, WINDOW[-1] + 8) if compact else range(MAP_BYTES // ROW)
    level_map(w, level, own=rng.randrange(3) > 0, rows=rows)
    (synthetic_script if synthetic else real_script)(w, level)
    pool_a(w, compact=compact); groups(w); random_cursor(w)
    if pos is None and compact:
        pos = ROW * rng.choice((rng.choice(WINDOW), rng.choice(WINDOW), 282, 283, 287))
    elif pos is None:
        pos = ROW * rng.choice((rng.randrange(0, 283), rng.randrange(0, 283), 282, 283, 284, 287))
    w.word('MapScrollPos', pos)
    w.word('ScrollingBackward', rng.choice((0, 0, 0, 1)))
    w.word('GroupDropKind', rng.randrange(5))
    return {'BP': w.sym('PrimaryRecord'), 'DI': rng.randrange(0x100, 0x3000)}

def leader_world(w, rtype=None, fill=None, arrive=None, special=None, compact=False):
    """A formation leader in pool A at (or near) its current script point; half the time a
    point whose follower is special (FFFFh Y, X 0)."""
    rng, s = w.rng, w.sym
    w.plausible(); pool_a(w, fill, compact); random_cursor(w)
    rtype = rng.choice(LEADER_TYPES) if rtype is None else rtype
    first, end, step = LEADER_SCRIPTS.get(rtype, LEADER_SCRIPTS[0x7E])
    mem = w.pair.a.pristine
    points = [s(first) + step * k for k in range((s(end) - s(first)) // step)]
    rare = [p for p in points if step == 8 and (mem[p + 4:p + 6] == b'\xff\xff' or mem[p + 2:p + 4] == b'\0\0')]
    if special is None: special = rng.randrange(3) == 0
    at = rng.choice(rare) if rare and special else rng.choice(points)
    w.word('LeaderScriptCursor', at)
    w.word('FormationSlotCursor', s('FormationSlots') + 4 * rng.randrange(16))
    ty, tx = (mem[at] | mem[at + 1] << 8) + 0x20, mem[at + 2] | mem[at + 3] << 8
    if arrive if arrive is not None else rng.randrange(3): x, y = tx, ty
    else: x, y = tx + rng.randrange(-3, 4), ty + rng.randrange(-3, 4)
    r = w.record('PoolA', rng.randrange(K.POOL_A_COUNT)).live(kind=K.KIND_ENEMY, type=rtype)
    r.set(x=x, y=y, direction=rng.randrange(8))
    if rng.randrange(8) == 0: r.set(status=0)        # a free entry record: the spawn may take it
    return {'BP': r.at}

def path21_world(w, end=False, compact=False):
    rng, s = w.rng, w.sym
    w.plausible(); pool_a(w, compact=compact)
    w.word('LevelIndex', 4)             # the type 21h director runs the leader path on level 4
    at = s('Type21Path') + 4 * (30 if end else rng.randrange(31))     # the 31st word is its FFFFh end
    w.put(far('Type21PathCursor'), struct.pack('<H', at))
    mem = w.pair.a.pristine
    ty, tx = ((mem[at] | mem[at + 1] << 8) + 0x20) & 0xFFFF, mem[at + 2] | mem[at + 3] << 8
    r = w.record('PoolA', rng.randrange(K.POOL_A_COUNT)).live(kind=K.KIND_ENEMY, type=0x21, size=2)
    if rng.randrange(2): r.set(x=tx, y=ty)
    return {'BP': r.at}

def cell_world(w, level):
    rng = w.rng
    w.plausible(); pool_a(w); groups(w); random_cursor(w)
    w.word('LevelIndex', rng.choice((level, level, rng.randrange(6))))
    col, row = rng.randrange(ROW), rng.randrange(282)
    off = row * ROW + col
    w.word('MapCellX', 16 * col)
    w.word('DropKind', rng.randrange(8))
    level_map(w, level)
    c = cell(w.rng, level)
    w.put(far('SlotBuffer', off), bytes([c]))
    return {'AX': rng.randrange(0x100) << 8 | c, 'SI': off, 'BP': w.sym('PrimaryRecord'), 'ES': 'LevelMapSegment'}

def cases(rng, scale, pair):
    s = pair.sym
    n = 150 * scale
    world = lambda: World(pair, rng)
    for i in range(n):
        w = world(); w.plausible(); pool_a(w)
        yield Case('FindFreeRecordPoolA', {}, w.writes(), keep('BX', 'CX'), outputs=('BX',), name=f'#{i}')
    for i in range(n):
        w = world(); w.plausible(); pool_a(w)
        off = rng.randrange(MAP_BYTES - 2 * ROW)
        w.word('MapCellX', 16 * rng.randrange(ROW))
        w.put(far('SlotBuffer', off), bytes([rng.randrange(256)]))
        yield Case('SpawnMapEnemy', {'SI': off, 'BP': s('PrimaryRecord'), 'ES': 'LevelMapSegment'}, w.writes(), keep('AX', 'BX', 'CX'),
                   outputs=('BX',), flags=('ZF',), name=f'#{i}')
    for level in range(6):
        for i in range(n * 2):
            w = world(); regs = cell_world(w, level)
            yield Case(f'Level{level}MapCell', regs, w.writes(), keep('AX', 'BX', 'CX'), outputs=('SI',), name=f'#{i}')
    for i in range(n * 2):
        w = world(); regs = row_world(w, synthetic=rng.randrange(3) == 0)
        yield Case('DrawIncomingMapRow', regs, w.writes(), LOOP, name=f'#{i}')
    for i in range(n):
        w = world(); row_world(w, synthetic=rng.randrange(2) == 0)
        yield Case('DrawMapRowIntoScrollBand', {'BP': s('PrimaryRecord')}, w.writes(), LOOP, name=f'caller #{i}')
    for i in range(n * 2):
        w = world(); regs = leader_world(w, rng.choice(LEADER_TYPES))
        yield Case('RunTypeHandler', regs, w.writes(), LOOP, name=f'#{i}')
    for i in range(n):
        w = world(); regs = path21_world(w)
        yield Case('RunTypeHandler', regs, w.writes(), LOOP, name=f'far body #{i}')
    for i in range(n):
        w = world(); w.plausible(); pool_a(w, rng.choice((0, 20, 34, 35)))
        w.byte('SfxEnabled', rng.randrange(2))
        bp = rng.choice((s('PrimaryRecord'), w.slot('PoolA', rng.randrange(35))))
        yield Case('DemoStepSpawnPathEnemy51', {'BP': bp}, w.writes(), ('SP', 'DS', 'SS'), name=f'#{i}')
        yield Case('DemoStepLaunchFrontPod', {'BP': bp}, w.writes(), ('SP', 'DS', 'SS'), outputs=('BP',), name=f'#{i}')
    yield from quirks(pair)
    for i in range(8 * scale):
        yield scroll_sequence(rng, pair, i)

def scroll_sequence(rng, pair, i):
    """Map rows entering forward (row spawns, script events, the clock) with record updates
    between them: leaders and map enemies run their handlers, which call the spawn routines
    back. EnterNextMapRowForward is C now (c/frame.c): each row enters through
    ScrollForwardAndCheckLevelEnd with a row boundary due and the scroll not held."""
    w = World(pair, rng)
    level = rng.randrange(6)
    row_world(w, level, synthetic=rng.randrange(2) == 0, pos=ROW * rng.randrange(20, 270))
    # Only records these rows spawn (and the player): slots start free and zeroed, so the
    # handlers that run in between see what the spawn routines set.
    for pool, count in (('PoolA', K.POOL_A_COUNT), ('PoolB', K.POOL_B_COUNT)):
        for k in range(count): w.record(pool, k).free(stale=False)
    w.word('ScrollingBackward', 0)
    row = lambda: [(pair.sym(n), b'\0\0') for n in ('ScrollSubRow', 'LevelEndPhase', 'EncounterLiveCount', 'EncounterEndDelay')]
    steps = [Case('ScrollForwardAndCheckLevelEnd', {'BP': pair.sym('PrimaryRecord')}, w.writes() + row(), LOOP, name=f'seq {i} row 0')]
    for f in range(1, rng.choice((6, 10, 16))):
        steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'seq {i} update {f}'))
        steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'seq {i} tick {f}'))
        steps.append(Case('ScrollForwardAndCheckLevelEnd', {'BP': pair.sym('PrimaryRecord')}, row(), LOOP, name=f'seq {i} row {f}'))
    return steps

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented quirk: ' + what)

def quirks(pair):
    """Original behaviour worth pinning (asserted on the oracle, then compared)."""
    s = pair.sym
    import random
    rng = random.Random(0x5EED)
    w16 = lambda v: struct.pack('<H', v & 0xFFFF)

    # A level 0 fuel pickup (F9h) returns with SI = DropKind + 46h (InitPickupRecord's SI):
    # SpawnFromMapRow continues the row from map offset 4Bh.
    w = World(pair, rng); w.plausible(); pool_a(w, 0)
    w.word('MapCellX', 0x20).word('LevelIndex', 0)
    yield Case('Level0MapCell', {'AX': 0xF9, 'SI': 0x500, 'BP': s('PrimaryRecord'), 'ES': 'LevelMapSegment'},
               w.writes() + [(far('SlotBuffer', 0x500), b'\xF9')], keep('AX', 'BX', 'CX'), outputs=('SI',),
               name='fuel pickup leaves SI = 4Ah', expect=lambda m, r: check(r['SI'] == 0x4A, 'SI = DropKind + 46h'))

    # A type 21h formation starts its leader script with LeaderScriptCursor = LevelIndex + 1.
    w = World(pair, rng); regs = row_world(w, 4, pos=ROW * 100)
    base, form = s('LevelScript4'), s('Formation00')
    w.put(base, struct.pack('<5H', 0x50, form, 0x40, 0xFFF0, 0xFFFF))
    w.put(form, struct.pack('<6H', 2, 1, 0x21, 1, 0, 0))
    w.word('LevelScriptCursors', base, index=4).word('LevelScriptClock', 0x50).word('ScrollingBackward', 0)
    pool_a(w, 0)
    yield Case('DrawIncomingMapRow', regs, w.writes(), LOOP, name='type 21h leader script cursor',
               expect=lambda m, r: check(m.word(s('LeaderScriptCursor')) == 5, 'LeaderScriptCursor = LevelIndex + 1'))

    # At Type21Path's FFFFh end the path restarts within the same call: the leader steers to
    # the first waypoint at once (the cursor write, Type21Path + 4 on arrival, is compared).
    w = World(pair, rng); w.plausible(); pool_a(w, 0)
    at = s('Type21Path') + 120
    r = w.record('PoolA', 3).live(kind=K.KIND_ENEMY, type=0x21, size=2).set(x=0x10, y=0x30)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes() + [(far('Type21PathCursor'), w16(at)), (s('LevelIndex'), w16(4))], LOOP,
               name='path restarts at its end',
               expect=lambda m, r: check(m.word(s('SteerTargetY')) == 0x30 and m.word(s('SteerTargetX')) == 0x10,
                                         'restart at FFFFh'))
    # A formation count of 0 is a `loop` count of 65536: members spawn until pool A is full.
    w = World(pair, rng); regs = row_world(w, 2, pos=ROW * 100)
    w.put(base := s('LevelScript2'), struct.pack('<5H', 0x60, form, 0x20, 0xFFF0, 0xFFFF))
    w.put(form, struct.pack('<8H', 2, 1, 0x4F, 0, 0, 0, 16, 0))
    w.word('LevelScriptCursors', base, index=2).word('LevelScriptClock', 0x60).word('ScrollingBackward', 0)
    w.word('MapScrollPos', ROW * 100)
    pool_a(w, 30)
    yield Case('DrawIncomingMapRow', regs, w.writes(), LOOP, name='formation count 0 fills pool A',
               expect=lambda m, r: check(all(m.word(s('PoolA') + RECORD * k) for k in range(K.POOL_A_COUNT)), 'pool A full'))

    # The column snap wraps within the row's 13 columns (never into the next row): scanning
    # right from column 5 over blocked cells wraps to 0 and stops at the clear column 2;
    # scanning left from column 7 wraps from 0 to column 12. The cells next to the row
    # (the next row's column 0, the previous row's column 12) are clear and never taken.
    for start_x, clear_col, want in ((0x50, 2, 0x20), (0x70, 10, 0xA0)):
        w = World(pair, rng); regs = row_world(w, 2, pos=ROW * 100)
        w.word('ScrollingBackward', 0)
        rows = bytearray(b'\x40' * (5 * ROW))
        rows[:ROW] = bytes(ROW)                       # row 100: nothing to spawn
        rows[2 * ROW + clear_col] = 1                 # row 102: the formation's row
        rows[3 * ROW] = 1; rows[2 * ROW - 1] = 1      # its neighbours outside the row
        w.put(far('SlotBuffer', 100 * ROW), bytes(rows))
        w.put(s('ByteAttributeTable') + 0x40, b'\x01')
        w.put(base := s('LevelScript2'), struct.pack('<5H', 0x70, form, start_x, 0xFFF0, 0xFFFF))
        w.put(form, struct.pack('<6H', 1, 0, 0x4F, 1, 0, 0))
        w.word('LevelScriptCursors', base, index=2).word('LevelScriptClock', 0x70)
        pool_a(w, 0)
        yield Case('DrawIncomingMapRow', regs, w.writes(), LOOP, name=f'column snap wraps in the row from X {start_x:X}',
                   expect=lambda m, r, want=want: check(any(m.word(s('PoolA') + RECORD * k) == 1 and m.word(s('PoolA') + RECORD * k + 0x18) == 0x4F
                                                            and m.word(s('PoolA') + RECORD * k + 4) == want for k in range(K.POOL_A_COUNT)),
                                                        f'snapped X {want:X}'))
    # The demo steps do not check for a full pool A: the path enemy is written through FFFFh
    # (REC_X lands at DS:0003).
    w = World(pair, rng); w.plausible(); pool_a(w, 35)
    yield Case('DemoStepSpawnPathEnemy51', {'BP': s('PrimaryRecord')}, w.writes(), ('SP', 'DS', 'SS'),
               name='full pool writes through FFFFh',
               expect=lambda m, r: check(m.word(3) == K.PLAYFIELD_MAX_X and m.word(0x17) == 0x51, 'writes at DS:0003/0017'))

# Plausible translation slips; each must make this suite fail (python tools/difftest.py --mutants spawn).
MUTANTS = [
    ('spawn.c', 'word n = POOL_A_COUNT;', 'word n = POOL_A_COUNT - 1;'),
    ('spawn.c', 'if ((sword)y > 0) {', 'if (y > 0) {'),
    ('spawn.c', 'case 0xF9: return call_fuel_pickup((main_routine)SpawnCellFuelPickup, here, off);',
                'case 0xF9: call_fuel_pickup((main_routine)SpawnCellFuelPickup, here, off); break;'),
    ('spawn.c', 'if (r->draw_pass != 1 && r->size_class == 1) snap_to_clear_column(r);',
                'if (r->size_class == 1) snap_to_clear_column(r);'),
    ('spawn.c', 'if (r->type == 0x21) start_leader_script(r, LevelIndex + 1);',
                'if (r->type == 0x21) start_leader_script(r, (word)LeaderScript13);'),
    ('spawn.c', '} while (--count != 0);', '} while (count-- > 1);'),
    ('spawn.c', 'if (SfxEnabled != 0) SfxRequest = 0x0B;', 'SfxRequest = 0x0B;'),
    ('spawn.c', '        if (++SpawnScanColumn >= MAP_ROW_BYTES) SpawnScanColumn = 0;',
                '        if (++SpawnScanColumn > MAP_ROW_BYTES) SpawnScanColumn = 0;'),
    ('spawn.c', '        LeaderScriptCursor += 4;\n            for (n = 5;', '        LeaderScriptCursor += 8;\n            for (n = 5;'),
    ('spawn.asm', 'DemoStepLaunchFrontPod:\r\n    call DEMO_STEP_LAUNCH_FRONT_POD\r\n    mov bp, ax\r\n',
                  'DemoStepLaunchFrontPod:\r\n    call DEMO_STEP_LAUNCH_FRONT_POD\r\n'),
]

# Coverage-guided differential fuzzing (python tools/fuzz.py spawn N).
from fuzz import Target
import hybrid as _hybrid
REGION = [n for n, f in _hybrid.owned_labels().items() if f == 'spawn.c']

# Seeds are deterministic cycles over what 8 seeds must cover (levels, leader types, the
# path end). The map is built for the seed's level, so LevelIndex is never mutated (another
# level's handler could meet bytes past its dispatch table).
import itertools
_cycles = {}
def _next(name, values): return next(_cycles.setdefault(name, itertools.cycle(values)))

def _row_seed(w): return row_world(w, _next('row', range(6)), synthetic=w.rng.randrange(3) == 0, compact=True)
def _level_seed(level):
    """Map cells of one level: every row spawns (forward, below MAP_LAST_SPAWN_POS), pool A
    from empty to full."""
    def seed(w):
        regs = row_world(w, level, pos=ROW * w.rng.choice(WINDOW), compact=True)
        level_map(w, level, rows=range(WINDOW[0] - 4, WINDOW[-1] + 8), density=12, blocked=6)
        pool_a(w, _next(f'cells{level}', (0, 10, 34, 0, 35, 20, 0, 33)), compact=True)
        w.word('ScrollingBackward', 0)
        return regs
    return seed
def _script_seed(w):
    """Every leader type (and others) in one script, in random order."""
    types = list(LEADER_TYPES + (0x21, 0x4F, w.rng.randrange(0x100)))
    w.rng.shuffle(types)
    level = _next('script', range(6))
    regs = row_world(w, level, pos=ROW * w.rng.choice(WINDOW), compact=True)
    level_map(w, level, rows=range(WINDOW[0] - 4, WINDOW[-1] + 8), density=1)   # plain cells: the pool is for the script
    pool_a(w, _next('script fill', (0, 5, 0, 12)), compact=True)
    synthetic_script(w, level, types)
    w.word('ScrollingBackward', 0)
    return regs
def _leader_seed(rtype):
    def seed(w):
        fill, special = _next(f'leader{rtype:X}', ((0, False), (34, True), (35, False), (0, True), (34, False), (35, True), (20, False), (0, False)))
        return leader_world(w, rtype, fill, arrive=True, special=special, compact=True)
    return seed
def _path21_seed(w): return path21_world(w, _next('path21', (True, False, False)), compact=True)
def _find_seed(w):
    w.plausible(); pool_a(w)
    return {}
def _demo_seed(w):
    w.plausible(); pool_a(w, w.rng.choice((0, 34, 35)), compact=True)
    return {'BP': w.sym('PrimaryRecord')}

# Preconditions: map rows inside the map (the 64 KiB window past it differs between the two
# links; here the seeds' row window); pool and table cursors only ever hold their tables'
# entries.
def _domains(extra=()):
    d = {'MapScrollPos': [ROW * r for r in list(WINDOW) + [282, 283, 287]], 'ScrollingBackward': (0, 1),
         'PoolACursor': lambda pair: range(pair.sym('PoolA'), pair.sym('PoolAEnd'), RECORD),
         'RandomWordCursor': lambda pair: range(pair.sym('CreditRandomWords'), pair.sym('CreditRandomWords') + 32, 2),
         'direction': range(8)}
    d.update(extra)
    return d
LEADER_DOMAINS = _domains({
    'LeaderScriptCursor': lambda pair: [pair.sym(a) + k for a, e, st in LEADER_SCRIPTS.values()
                                        for k in range(0, pair.sym(e) - pair.sym(a), st)],
    'FormationSlotCursor': lambda pair: range(pair.sym('FormationSlots'), pair.sym('FormationSlots') + 64, 4),
    'SteerSpeed': range(4), 'type': LEADER_TYPES})
ROW_GLOBALS = ('MapScrollPos', 'ScrollingBackward', 'LevelScriptClock', 'PoolACursor', 'SfxEnabled',
               'RandomWordCursor', 'GroupDropKind')
CELL_GLOBALS = ('MapScrollPos', 'PoolACursor', 'SfxEnabled', 'RandomWordCursor')
FUZZ = [
    Target('spawn_row', 'DrawIncomingMapRow', _row_seed, REGION, LOOP, globals=ROW_GLOBALS, watch=('GroupSlotIndex',),
           domains=_domains()),
    *[Target(f'spawn_cells{level}', 'DrawIncomingMapRow', _level_seed(level), REGION, LOOP, globals=CELL_GLOBALS,
             domains=_domains()) for level in range(6)],
    Target('spawn_script', 'DrawIncomingMapRow', _script_seed, REGION, LOOP, globals=ROW_GLOBALS, domains=_domains()),
    *[Target(f'spawn_leader{rtype:X}', 'RunTypeHandler', _leader_seed(rtype), REGION, LOOP, types=LEADER_TYPES,
             globals=('FormationSlotCursor', 'PoolACursor', 'SfxEnabled', 'EncounterLiveCount'),
             watch=('EncounterLiveCount',), domains=LEADER_DOMAINS) for rtype in LEADER_TYPES],
    Target('spawn_path21', 'RunTypeHandler', _path21_seed, REGION, LOOP, globals=('PoolACursor', 'SfxEnabled'),
           domains=_domains({'type': (0x21,), 'LevelIndex': (4,)})),
    Target('spawn_find', 'FindFreeRecordPoolA', _find_seed, REGION, keep('BX', 'CX'), outputs=('BX',),
           globals=('PoolACursor',), domains=_domains()),
    Target('spawn_demo_pod', 'DemoStepLaunchFrontPod', _demo_seed, REGION, ('SP', 'DS', 'SS'), outputs=('BP',),
           globals=('PoolACursor', 'SfxEnabled'), domains=_domains()),
    Target('spawn_demo51', 'DemoStepSpawnPathEnemy51', _demo_seed, REGION, ('SP', 'DS', 'SS'),
           globals=('PoolACursor', 'SfxEnabled'), domains=_domains()),
]