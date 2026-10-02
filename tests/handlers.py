"""Remaining enemy families: flyers.c, firers.c and patrol.c, entered through
RunTypeHandler and complete record passes. No test-only ASM entry bridges.
Instruction accounting includes the unreachable EVEN nop between Type84's
indirect jump and Type84DirCases; all other region instructions are reachable.
"""
from difftest import Case
from world import World, K, POOLS, FIELDS
from enemies import world, enemy, in_domain, MAP
from fuzz import Target
import hybrid
import itertools

FILES = ('flyers.c', 'firers.c', 'patrol.c')
REGION = [n for n, f in hybrid.owned_labels().items() if f in FILES]
FLYERS = (0x29, 0x2B, 0x3E, 0x3F, 0x60, 0x7A, 0x7B, 0x7C)
FIRERS = (0x2D, 0x40, 0x46, 0x47, 0x68, 0x71, 0x87, 0x89, 0x8A, 0x8F)
PATROL = (0x1A, 0x1B, 0x32, 0x33, 0x3C, 0x3D, 0x4B, 0x4E, 0x5B, 0x5C, 0x84,
          0x8B, 0x8C, 0x8D, 0x8E)
TYPES = FLYERS + FIRERS + PATROL
LOOP = ('BP', 'SP', 'DS', 'SS')

def state(w, t):
    world(w.pair, w.rng, w)
    return enemy(w, t)

def base(pair, rng, t):
    w = world(pair, rng)
    for pool, count in POOLS.items():
        if pool != 'PrimaryRecord':
            for slot in range(count): w.record(pool, slot).randomize().free()
    w.word('SegBossActive', 0).word('LevelEndPhase', 0).word('ScrollDeltaY', 0)
    w.word('MapScrollPos', 0).word('ScrollSubRow', 0).word('DemoActive', 0)
    w.record('PrimaryRecord', 0).set(x=0x10, y=0xD0, sprite=0)
    r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=t, size=1,
                                  x=0x60, y=0x60, direction=K.DIR_UP_LEFT,
                                  delta_x=3, delta_y=2, step_error=1)
    return w, r

def call(w, r, name='', expect=None):
    return Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name=name, expect=expect)

def check(cond, message):
    if not cond: raise AssertionError('oracle does not show the documented behaviour: ' + message)

def field(m, r, name): return m.word(r.at + FIELDS[name])

def cases(rng, scale, pair):
    # Exact thresholds, signed-negative values and pre-scroll decision ordering.
    for t, row in ((0x32, 0x90), (0x3C, 0xB0), (0x4B, 0x40), (0x4E, 0x90),
                   (0x5B, 0xB0), (0x3E, 0xA0), (0x7B, 0x90),
                   (0x2D, 0x60), (0x46, 0x60), (0x71, 0x60)):
        for y, scroll, sound in itertools.product((row - 1, row, row + 1, 0x8000, 0xFFFF), (0, 1, 2), (0, 1)):
            w, r = base(pair, rng, t)
            r.set(y=y)
            w.word('ScrollDeltaY', scroll).word('FrameCount128', 0x7F)
            w.byte('SfxEnabled', sound).byte('SfxRequest', 0x37)
            yield call(w, r, f'threshold {t:X} y {y:X} scroll {scroll} sound {sound}')

    for sprite, phase, dx, dy in itertools.product((0xA1, 0xA3, 0xA4, 0xA5, 0xFFFF), (6, 7),
                                                   (-3, 0, 3), (-2, 0, 2)):
        w, r = base(pair, rng, 0x29)
        r.set(sprite=sprite, delta_x=dx, delta_y=dy, step_error=0xFFFF)
        w.word('FrameCount8', phase)
        yield call(w, r, f'emerge sprite {sprite:X} frame {phase} delta {dx},{dy}')

    for t, x, dx, dy in itertools.product((0x2B, 0x3F, 0x60, 0x7A, 0x7C),
                                          (0, 1, 0xBF, 0xC0, 0xC1, 0xFFFF, 0x8000),
                                          (-3, 0, 3), (-2, 0, 2)):
        w, r = base(pair, rng, t)
        r.set(x=x, delta_x=dx, delta_y=dy)
        w.word('ChaseStepPixels', 0x1234)
        yield call(w, r, f'flight {t:X} x {x:X} delta {dx},{dy}')

    # Phase, facing (both add 3 at the centre), throttled/full/allocated child.
    for t, phase, x, difficulty, throttle, full in itertools.product((0x87, 0x8F), range(8),
                                                                     (0x5F, 0x60, 0x61), range(3), range(4), (0, 1)):
        w, r = base(pair, rng, t)
        r.set(x=x)
        w.word('FrameCount64', phase * 8).word('DifficultySetting', difficulty)
        w.byte('ChildSpawnThrottle', throttle)
        if full: w.fill('PoolB', POOLS['PoolB'], kind=K.KIND_TYPED, type=4, size=0)
        yield call(w, r, f'burst {t:X} phase {phase} x {x:X} difficulty {difficulty} throttle {throttle} full {full}')

    # Lurker directional inclusivity, odd headings, wrap and ship width.
    for direction, x, y, px, py, sprite in itertools.product(range(8), (0x60, 0xFFF8),
                                                           (0x60, 0xFFF0), (0x58, 0x60, 0xFFF8),
                                                           (0x5F, 0x60, 0x74, 0xFFF0), (0, 1)):
        w, r = base(pair, rng, 0x84)
        r.set(direction=direction, x=x, y=y)
        w.record('PrimaryRecord', 0).set(x=px, y=py, sprite=sprite)
        w.word('ScrollDeltaY', 2)
        yield call(w, r, f'lurk dir {direction} r {x:X},{y:X} player {px:X},{py:X} sprite {sprite}')

    # Both random axes/signs and the threshold after jitter, not before it.
    for t, level, y, parity, firing, cursor in itertools.product(
            (0x40, 0x68), (0, 4, 5), (0x7F, 0x80, 0x81, 0xFFFF), (0, 1), (30, 31), range(16)):
        w, r = base(pair, rng, t)
        r.set(y=y)
        w.word('LevelIndex', level).word('FrameCount64', parity).word('FrameCount32', firing)
        w.word('RandomWordCursor', pair.sym('CreditRandomWords') + 2 * cursor)
        yield call(w, r, f'jitter {t:X} level {level} y {y:X} parity {parity} fire {firing} cursor {cursor}')

    for t, y, firing, difficulty, full in itertools.product((0x2D, 0x46, 0x71, 0x47, 0x89, 0x8A),
                                                           (0x60, 0x61), (0, 1), range(3), (0, 1)):
        w, r = base(pair, rng, t)
        r.set(y=y, direction=K.DIR_LEFT)
        w.word('FrameCount128', 126 + firing).word('FrameCount32', 30 + firing)
        w.word('DifficultySetting', difficulty).byte('ChildSpawnThrottle', 0)
        if full: w.fill('PoolB', POOLS['PoolB'], kind=K.KIND_TYPED, type=4, size=0)
        yield call(w, r, f'down shot {t:X} y {y:X} fire {firing} difficulty {difficulty} full {full}')

    # Map attributes all open/all solid, cell crossings, early partial steps and
    # walker animation in both vertical directions, exact firing phases/full pool.
    for t, solid, phase, x, y, firing in itertools.product(
            (0x1A, 0x1B, 0x33, 0x3D, 0x8B, 0x8C, 0x8D, 0x8E), (0, 1), range(4),
            (0, 0x60, 0x6F, 0xC0), (0x60, 0x6F), (0x56, 0x57, 0x6B, 0x7F)):
        w, r = base(pair, rng, t)
        r.set(x=x, y=y, direction=K.DIR_LEFT if phase & 1 else K.DIR_UP_RIGHT)
        w.put('ByteAttributeTable', bytes([solid]) * 256)
        w.word('SlowCount4', phase).word('SlowCount6', phase).word('FrameCount128', firing)
        w.record('PrimaryRecord', 0).set(y=y + (-1 if phase & 1 else 1))
        w.word('ScrollDeltaY', 1).word('TerrainBlocked', 0x1234)
        if firing == 0x6B: w.fill('PoolB', POOLS['PoolB'], kind=K.KIND_TYPED, type=4, size=0)
        yield call(w, r, f'terrain {t:X} solid {solid} phase {phase} x {x:X} y {y:X} fire {firing:X}')

    for i in range(2500 * scale):
        w = World(pair, rng)
        r = state(w, rng.choice(TYPES))
        yield call(w, r, f'random {i}')

    # Entire record passes across state transitions, spawning and timer updates.
    for i in range(24 * scale):
        w, _ = base(pair, rng, TYPES[i % len(TYPES)])
        for slot, t in enumerate(TYPES):
            r = enemy(w, t, index=slot)
            r.set(x=0x20 + 4 * slot, y=0x60 + slot, direction=slot % 8)
            if t == 0x29: r.set(sprite=0xA3)
        steps = [Case('UpdateAllRecords', {}, w.writes(), LOOP, name=f'world {i} frame 0')]
        for frame in range(1, 8):
            steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'world {i} tick {frame}'))
            steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'world {i} frame {frame}'))
        yield steps
    yield from quirks(rng, pair)

def quirks(rng, pair):
    for t, at in ((0x87, 0xE7), (0x8F, 0xC9)):
        w, r = base(pair, rng, t)
        w.word('FrameCount64', 24).word('DifficultySetting', 0).byte('ChildSpawnThrottle', 0)
        w.word(at, 0x1234)
        yield call(w, r, f'stale burst {t:X}',
                   lambda m, regs, at=at: check(m.word(at) == 0x44, 'pre-facing sprite used as stale BX'))

    w, r = base(pair, rng, 0x84)
    r.set(x=0x60, y=0xF5, direction=K.DIR_UP)
    w.record('PrimaryRecord', 0).set(x=0x58, y=0xE0, sprite=0)
    w.word('ScrollDeltaY', 2)
    yield call(w, r, 'lurker switch skips bounds and scroll',
               lambda m, regs: check(field(m, r, 'type') == 0x85 and field(m, r, 'status') == 1
                                      and field(m, r, 'y') == 0xF5, 'aligned transition skips entire finish tail'))

    w, r = base(pair, rng, 0x5B)
    r.set(y=0xB0)
    w.word('ScrollDeltaY', 1)
    yield [call(w, r, 'rise threshold checked before scroll',
                lambda m, regs: check(field(m, r, 'type') == 0x5B and field(m, r, 'y') == 0xB1,
                                        'B0 equality remains waiting')),
           Case('RunTypeHandler', {'BP': r.at}, (), LOOP, name='rise on next frame',
                expect=lambda m, regs: check(field(m, r, 'type') == 0x5C and field(m, r, 'y') == 0xAE,
                                              'transition runs rise in same frame'))]

MUTANTS = [
    ('firers.c', 'spawn_throttled_child(r, bx)', 'spawn_throttled_child(r, r->sprite)'),
    ('firers.c', 'r->y > 0x60', '(sword)r->y > 0x60'),
    ('firers.c', '(sword)r->y >= 0x80', '(sword)r->y > 0x80'),
    ('flyers.c', 'FrameCount8 != 7', 'FrameCount8 != 6'),
    ('flyers.c', 'ChaseStepPixels = 3;', 'ChaseStepPixels = 2;'),
    ('patrol.c', 'r->direction ^= 2;', 'r->direction ^= 1;'),
    ('patrol.c', '(sword)r->y > 0xB0', 'r->y > 0xB0'),
    ('patrol.c', '0x13A + 3 * WalkerFacingStep + animation', '0x13B + 3 * WalkerFacingStep + animation'),
    ('patrol.c', 'r->type = 0x85;\n        return;', 'r->type = 0x85;\n        scroll_record_then_finish(r);\n        return;'),
]

def seed(types):
    def make(w):
        r = state(w, w.rng.choice(types))
        if r.get('type') == 0x29: r.set(sprite=w.rng.choice((0xA1, 0xA3, 0xA4)))
        return {'BP': r.at}
    return make

def target(name, types, file):
    domains = {'type': types, 'direction': range(8), 'size_class': range(3),
               'slot_index': (0xFFFF,) + tuple(range(16)), 'LevelIndex': range(8),
               'SlowCount4': range(4), 'SlowCount6': range(6), 'SlowCount8': range(8),
               'FrameCount4': range(4), 'FrameCount8': range(8), 'FrameCount32': range(32),
               'FrameCount64': range(64), 'FrameCount128': range(128)}
    domains['RandomWordCursor'] = lambda p: range(p.sym('CreditRandomWords') - 2,
                                                 p.sym('CreditRandomWords') + 31, 2)
    region = [n for n, f in hybrid.owned_labels().items() if f == file]
    globals = ('LevelIndex', 'DifficultySetting', 'ScrollDeltaY', 'ScrollSubRow', 'MapScrollPos',
               'FrameCount64', 'FrameCount128', 'FrameCount32', 'FrameCount8',
               'SlowCount4', 'SlowCount6', 'SlowCount8', 'ChaseStepPixels', 'LevelEndPhase', 'RandomWordCursor')
    return Target(name, 'RunTypeHandler', in_domain(seed(types), domains), region, LOOP,
                  types=types, globals=globals, domains=domains, pin_bp=True, seeds=4 * len(types))

FUZZ = [target('handlers_flyers', FLYERS, 'flyers.c'),
        target('handlers_firers', FIRERS, 'firers.c'),
        target('handlers_patrol', PATROL, 'patrol.c')]
