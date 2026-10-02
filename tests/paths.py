"""Waypoint followers and formation entry (c/paths.c), through RunTypeHandler
and stateful record passes. The region has no remaining ASM callers or bridges.
"""
from difftest import Case
from world import World, K, FIELDS
from enemies import world, enemy, in_domain, MAP
from fuzz import Target
import hybrid
import itertools

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'paths.c']
LOOP = ('BP', 'SP', 'DS', 'SS')
START_PATHS = {0x10: 'SteerPath10', 0x11: 'SteerPath11', 0x41: 'Type41Path',
               0x43: 'Type43Path', 0x44: 'Type44Path', 0x45: 'Type45Path',
               0x4A: 'Type4APath', 0x51: 'Type51Path', 0x66: 'PathType66', 0x67: 'PathType67'}
ENTRY_TYPES = (0x7F, 0x81)
TYPES = tuple(START_PATHS) + (0x12,) + ENTRY_TYPES

def points(pair, name=None):
    """Offsets of actual table entries, including the final offscreen waypoint.
    This reads data only; it does not model movement or record updates.
    """
    data = pair.a.pristine
    out = []
    for label in (name,) if name else START_PATHS.values():
        at = pair.sym(label)
        while True:
            out.append(at)
            if data[at] | data[at + 1] << 8 == K.LEADER_END_Y: break
            at += 4
    return out

def waypoint(pair, at):
    data = pair.a.pristine
    return ((data[at] | data[at + 1] << 8) + 0x20) & 0xFFFF, data[at + 2] | data[at + 3] << 8

def state(w, rtype):
    w = world(w.pair, w.rng, w)
    r = enemy(w, rtype)
    if rtype in ENTRY_TYPES:
        r.set(blocked_climbs=0)
    else:
        r.set(path=w.rng.choice(points(w.pair)))
    r.set(direction=w.rng.randrange(8), entry_delay=w.rng.randrange(3))
    return r

def call(w, r, name='', expect=None):
    return Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name=name, expect=expect)

def cases(rng, scale, pair):
    for rtype in START_PATHS:
        for level, demo, pos in itertools.product(range(8), (0, 1, 2),
                                                  (K.MAP_LAST_SPAWN_POS - K.MAP_ROW_BYTES,
                                                   K.MAP_LAST_SPAWN_POS,
                                                   K.MAP_LAST_SPAWN_POS + K.MAP_ROW_BYTES)):
            w = World(pair, rng)
            r = state(w, rtype)
            w.word('LevelIndex', level).word('DemoActive', demo).word('MapScrollPos', pos)
            r.set(x=0x60, y=0x60, hit_points=3)
            yield call(w, r, f'start {rtype:X} level {level} demo {demo} row {pos}')

    for at in points(pair):
        y, x = waypoint(pair, at)
        terminal = y == (K.LEADER_END_Y + 0x20) & 0xFFFF
        for delta in (-2, 0, 2):
            w = World(pair, rng)
            r = state(w, 0x12)
            r.set(path=at, x=x + delta, y=0x80 if terminal else y)
            yield call(w, r, f'waypoint {at:04X} delta {delta}')

    for rtype, heading, dx, dy in itertools.product(ENTRY_TYPES, range(8), (-2, 0, 2), (-2, 0, 2)):
        w = World(pair, rng)
        r = state(w, rtype)
        r.set(x=0x60 + dx, y=0x60 + dy, saved_x=0x60, saved_y=0x60, direction=heading)
        yield call(w, r, f'entry {rtype:X} heading {heading} delta {dx},{dy}')

    for i in range(1000 * scale):
        w = World(pair, rng)
        r = state(w, rng.choice(TYPES))
        yield call(w, r, f'random {i}')

    # Actual record passes continue after path changes and 7F->80 / 81->93 transitions.
    for i in range(20 * scale):
        w = world(pair, rng)
        w.word('SegBossActive', 0)
        for pool, count in (('PoolA', K.POOL_A_COUNT), ('PoolB', K.POOL_B_COUNT)):
            for slot in range(count): w.record(pool, slot).randomize().free()
        for slot, rtype in enumerate((0x12, 0x7F, 0x81)):
            r = enemy(w, rtype, index=slot)
            r.set(direction=K.DIR_RIGHT, entry_delay=0)
            if rtype in ENTRY_TYPES:
                r.set(x=0x60, y=0x60, saved_x=0x60, saved_y=0x60, blocked_climbs=0)
        steps = [Case('UpdateAllRecords', {}, w.writes(), LOOP, name=f'world {i} frame 0')]
        for frame in range(1, 8):
            steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'world {i} tick {frame}'))
            steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'world {i} frame {frame}'))
        yield steps

    yield from quirks(rng, pair)

def checked(cond, message):
    if not cond: raise AssertionError('oracle does not show the documented behaviour: ' + message)

def quirks(rng, pair):
    s = pair.sym
    def field(m, r, name): return m.word(r.at + FIELDS[name])

    # Arrival advances to the next point AND moves in the same frame; there is no pause.
    w = World(pair, rng)
    r = state(w, 0x12)
    at = s('Type41Path')
    y, x = waypoint(pair, at)
    r.set(path=at, x=x, y=y)
    w.word('DemoActive', 0).word('LevelIndex', 1)
    yield call(w, r, 'arrival consumes waypoint immediately',
               lambda m, regs: checked(field(m, r, 'path') == at + 4 and
                                        (field(m, r, 'x'), field(m, r, 'y')) != (x, y),
                                        'same-frame advance and movement'))

    # Sprite selection on level 5 has a fall-through only at this exact map row.
    for pos, base in ((K.MAP_LAST_SPAWN_POS - K.MAP_ROW_BYTES, 0x115),
                      (K.MAP_LAST_SPAWN_POS, 0xEC),
                      (K.MAP_LAST_SPAWN_POS + K.MAP_ROW_BYTES, 0x115)):
        w = World(pair, rng)
        r = state(w, 0x12)
        r.set(path=s('Type41Path'), x=0x60, y=0x60)
        w.word('DemoActive', 0).word('LevelIndex', 5).word('MapScrollPos', pos)
        yield call(w, r, f'level 5 sprite row {pos}',
                   lambda m, regs: checked(field(m, r, 'sprite') == field(m, r, 'direction') + base,
                                            'level 5 exact-row sprite fall-through'))

    for rtype in ENTRY_TYPES:
        # The step that reaches the slot does not change type; the next call does.
        w = World(pair, rng)
        r = state(w, rtype)
        r.set(x=0x5E, y=0x60, saved_x=0x60, saved_y=0x60, direction=K.DIR_LEFT)
        w.word('DemoActive', 0)
        after = 0x93 if rtype == 0x81 else 0x80
        first = call(w, r, f'{rtype:X} reaches slot',
                     lambda m, regs: checked(field(m, r, 'type') == rtype and field(m, r, 'x') == 0x60,
                                              'entry transition waits for next call'))
        second = Case('RunTypeHandler', {'BP': r.at}, (), LOOP, name=f'{rtype:X} already at slot',
                      expect=lambda m, regs: checked(field(m, r, 'type') == after,
                                                     'entry transition on exact arrival'))
        yield [first, second]
        if rtype == 0x81:
            w = World(pair, rng)
            r = state(w, rtype)
            r.set(x=0x50, y=0x60, saved_x=0x60, saved_y=0x60, direction=K.DIR_LEFT)
            yield call(w, r, 'sweeper preserves spawn heading',
                       lambda m, regs: checked(field(m, r, 'direction') == K.DIR_LEFT,
                                                'sweeper heading restored after steering'))

MUTANTS = [
    ('paths.c', 'r->path = (word)(point + 2);', 'r->path = (word)(point + 1);'),
    ('paths.c', 'if (SteerArrived == 0) break;', 'if (SteerArrived != 0) break;'),
    ('paths.c', 'SteerTargetY = point[0] + 0x20;', 'SteerTargetY = point[0];'),
    ('paths.c', 'LevelIndex == 0 || DemoActive == 1', 'LevelIndex == 0 && DemoActive == 1'),
    ('paths.c', 'MapScrollPos != MAP_LAST_SPAWN_POS', 'MapScrollPos < MAP_LAST_SPAWN_POS'),
    ('paths.c', 'r->direction = heading;', 'r->direction = (heading + 1) & 7;'),
    ('paths.c', 'r->hit_points = 0x14;', 'r->hit_points = 0x13;'),
    ('paths.c', 'r->type = 0x80;', 'r->type = 0x81;'),
]

def seed(types):
    def make(w):
        r = state(w, w.rng.choice(types))
        return {'BP': r.at}
    return make

GLOBALS = ('LevelIndex', 'DemoActive', 'MapScrollPos', 'ScrollDeltaY', 'EncounterLiveCount', 'FrameCount8')

def target(name, types, **extra):
    # Whole-record copies may replace the entry record with any stale slot: all
    # seeds must meet the unchecked dispatch, direction and record-size domains.
    domains = {'type': types, 'direction': range(8), 'size_class': range(3),
               'slot_index': (0xFFFF,) + tuple(range(16)), 'LevelIndex': range(8),
               'SteerSpeed': range(4)}
    domains.update(extra)
    return Target(name, 'RunTypeHandler', in_domain(seed(types), domains), REGION, LOOP,
                  types=types, globals=GLOBALS, domains=domains, pin_bp=True,
                  seeds=max(24, 4 * len(types)))

FUZZ = [target('paths_follow', (0x12,), field_36=points),
        target('paths_start', tuple(START_PATHS)),
        target('paths_entry', ENTRY_TYPES)]
