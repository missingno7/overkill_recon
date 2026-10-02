"""Player control, history, autopilot and exhaust (c/player.c), through the
remaining ASM entries and the C record-kind dispatcher. Hardware joystick polling,
gauge drawing and map I/O retain their DOS interfaces.
RunLevelEndSequence's EVEN alignment NOP follows an indirect jump and is unreachable;
it is the region's only uncovered oracle instruction.
"""
from difftest import Case
from world import World, K, POOLS, FIELDS
from fuzz import Target
from shots import MAP, install_map
from frame import restart_world, WINDOW
from pods import PODS, SIDE, upgrades
import hybrid
import itertools
import struct
from unicorn import UC_HOOK_CODE

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'player.c']
FREE = ('SP', 'DS', 'SS')
LOOP = ('BP',) + FREE
CURSORS = ('HistoryWriteCursor', 'HistoryReadCursor15', 'HistoryReadCursor31', 'HistoryCursor47')
KEYS = (K.SCAN_TAB, K.SCAN_SPACE, K.SCAN_UP, K.SCAN_DOWN, K.SCAN_LEFT, K.SCAN_RIGHT)
W = lambda v: struct.pack('<H', v & 0xFFFF)

def history_points(pair):
    return tuple(range(pair.sym('HistoryPairs'), pair.sym('HistoryEnd'), K.HISTORY_PAIR_BYTES))

def base(w):
    rng, s = w.rng, w.sym
    w.plausible(); install_map(w.pair)
    w.word('LevelIndex', rng.randrange(K.LEVEL_COUNT)).word('LevelEndPhase', 0)
    w.word('InputDeviceMode', 0).word('DemoActive', 0).word('SegBossActive', 0)
    w.word('Fuel', 0x58).word('EnergyTanks', 3).word('EnergyPoints', 0x18)
    w.word('RefuelActive', 0).word('EncounterLiveCount', 1).word('EncounterEndDelay', 0)
    w.word('MapScrollPos', K.MAP_INTRO_END_POS).word('ScrollSubRow', 1)
    w.word('ScrollWindowOffset', WINDOW[0]).word('LevelScriptClock', 0)
    w.byte('BonusKeysEnabled', 0).put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    w.put('ByteAttributeTable', bytes(256))
    w.word('WeaponMode', 0).word('SideShotsEnabled', 0).word('MissileAmmo', 0)
    w.word('ShotsLiveType9', 0).put('BeamList', W(0xFFFF) * 26).word('BeamListEnd', s('BeamList'))
    w.word('PoolACursor', s('PoolA')).word('PoolBCursor', s('PoolB'))
    w.word('SidePodSpreadLeft', 0).word('SidePodSpreadRight', 0).word('XAdjustPathTaken', 0)
    for name in PODS: w.word(name, 0xFFFF)
    for pool, n in POOLS.items():
        if pool == 'PrimaryRecord': continue
        for i in range(n):
            w.record(pool, i).randomize().free().set(type=0, direction=0, size_class=1, slot_index=0xFFFF)
    upgrades(w, selected=0xFFFF)
    ship = w.player(x=0x60, y=0x60, sprite=0)
    # Independent valid lag cursors expose wrap and near/far aliasing without
    # reproducing any history update behavior in the test builder.
    w.put('HistoryPairs', rng.randbytes(K.HISTORY_PAIR_COUNT * K.HISTORY_PAIR_BYTES))
    for name in CURSORS: w.word(name, rng.choice(history_points(w.pair)))
    w.word('SlowCount8', rng.randrange(8)).word('SlowCount4', rng.randrange(4))
    return ship

def keyboard(w, mask, state=1):
    keys = bytearray(K.KEY_DOWN_COUNT)
    for i, scan in enumerate(KEYS):
        if mask & (1 << i): keys[scan] = state
    w.put('KeyDownTable', keys)

def frame(w, name='', expect=None, bp=None):
    return Case('UpdatePlayerFrame', {'BP': w.sym('PrimaryRecord') if bp is None else bp},
                w.writes(), FREE, outputs=('BP',), name=name, expect=expect)

def check(cond, message):
    if not cond: raise AssertionError('oracle does not show the documented behaviour: ' + message)

def field(m, at, name): return m.word(at + FIELDS[name])

def cases(rng, scale, pair):
    s = pair.sym
    # Default/alternate/custom fallback input modes, individual bindings, low bit
    # versus nonzero key state, and every combination of the fixed six controls.
    data = pair.a.pristine
    for mode in (0, 2, 3, 0xFFFF):
        table = s('KeyBitScancodesB' if mode == 2 else 'KeyBitScancodesA')
        for scan, state in itertools.product(set(data[table:table + K.KEY_BIT_SCANCODE_COUNT]) | set(KEYS), (0, 1, 2, 3, 0x80, 0xFF)):
            w = World(pair, rng)
            keys = bytearray(K.KEY_DOWN_COUNT); keys[scan] = state
            w.word('InputDeviceMode', mode).byte('InputBits', 0xA5).put('KeyDownTable', keys)
            yield Case('PollInputBits', {}, w.writes(), LOOP, name=f'keyboard mode {mode} scan {scan:X} state {state:X}')

    for mask, x, y in itertools.product(range(64), (0, 1, K.SHIP_X_MAX - 1, K.SHIP_X_MAX),
                                       (K.SHIP_Y_MIN - 1, K.SHIP_Y_MIN, K.SHIP_Y_MIN + 1,
                                        K.SHIP_Y_MAX - 1, K.SHIP_Y_MAX, K.SHIP_Y_MAX + 1)):
        w = World(pair, rng); ship = base(w)
        ship.set(x=x, y=y)
        keyboard(w, mask)
        yield frame(w, f'controls {mask:X} x {x:X} y {y:X}')

    for x, mask, left, right in itertools.product((0, 0x60, K.SHIP_X_MAX), (0, 16, 32, 48),
                                                 (0, 7, 8, 9, 0xFFFF),
                                                 (0, 0xFFF9, 0xFFF8, 0xFFF7, 1)):
        w = World(pair, rng); ship = base(w)
        ship.set(x=x)
        keyboard(w, mask)
        w.word('MapScrollPos', K.MAP_INTRO_END_POS + 1)
        w.word('SidePodSpreadLeft', left).word('SidePodSpreadRight', right)
        yield frame(w, f'edge x {x:X} mask {mask:X} spread {left:X},{right:X}')

    for x, y in itertools.product((0, 0x7FF8, 0xFFF8, 0xFFFF), (0, 0x7FF8, 0xFFF8, 0xFFFF)):
        w = World(pair, rng); ship = base(w); ship.set(x=x, y=y)
        yield Case('InitPositionHistory', {}, w.writes(), FREE, outputs=('BP', 'ES'),
                   name=f'initialize {x:X},{y:X}')

    for cursor, demo, pos, alias in itertools.product(history_points(pair), (0, 1),
                                                     (K.MAP_INTRO_END_POS, K.MAP_INTRO_END_POS + 1), (0, 1)):
        w = World(pair, rng); ship = base(w)
        for name in CURSORS: w.word(name, cursor)
        w.word('DemoActive', demo).word('MapScrollPos', pos)
        near = w.record('PoolA', 1).live(kind=K.KIND_POD, size=1)
        far = near if alias else w.record('PoolA', 2).live(kind=K.KIND_POD, size=1)
        w.word('TrailingPodNear', near.at).word('TrailingPodFar', far.at)
        yield Case('StoreApplyHistoryAndConditionalPlacement', {'BP': ship.at}, w.writes(), LOOP,
                   name=f'history {cursor:X} demo {demo} pos {pos} alias {alias}')

    # Autopilot equality, unsigned steering, same-frame transitions, refill gates.
    for phase, x, y, sprite in itertools.product(range(1, 5), (0x57, 0x58, 0x59, 0xFFFF),
                                                 (0, 1, 0xA9, 0xAA, 0xAB, 0xFFFF), (0, 1, 2)):
        w = World(pair, rng); ship = base(w)
        ship.set(x=x, y=y, sprite=sprite)
        w.word('LevelEndPhase', phase)
        w.word('SidePodSpreadLeft', rng.choice((0, 8, 15, 16, 0xFFFF)))
        w.word('SidePodSpreadRight', rng.choice((0, 0xFFF8, 0xFFF1, 0xFFFF)))
        yield frame(w, f'autopilot phase {phase} x {x:X} y {y:X} sprite {sprite}', bp=0x1234)

    for fuel, tanks, points, demo, sound in itertools.product((1, 0x57, 0x58), range(4),
                                                             (0, 0x17, 0x18), (0, 1), (0, 1)):
        w = World(pair, rng); base(w)
        w.word('LevelEndPhase', K.LEVEL_END_REFILL).word('Fuel', fuel)
        w.word('EnergyTanks', tanks).word('EnergyPoints', points).word('DemoActive', demo)
        w.byte('SfxEnabled', sound).byte('SfxRequest', 0x37)
        yield frame(w, f'refill fuel {fuel} tanks {tanks} points {points} demo {demo} sound {sound}')

    for sprite, phase, tick in itertools.product(range(5), range(5), range(8)):
        w = World(pair, rng); ship = base(w)
        ship.set(sprite=sprite)
        w.word('LevelEndPhase', phase).word('SlowCount8', tick)
        r = w.record('PoolA', 3).live(kind=K.KIND_EXHAUST, size=0)
        yield Case('UpdateAllRecords', {'BP': r.at}, w.writes(), FREE, outputs=('BP',),
                   name=f'exhaust form {sprite} phase {phase} tick {tick}')

    for i in range(1000 * scale):
        w = World(pair, rng); ship = base(w)
        ship.set(x=rng.randrange(0xC1), y=rng.randrange(0xD0), sprite=rng.randrange(3))
        keyboard(w, rng.randrange(64))
        w.word('InputDeviceMode', rng.choice((0, 2))).word('LevelEndPhase', rng.randrange(5))
        w.word('MapScrollPos', rng.choice((K.MAP_INTRO_END_POS, K.MAP_INTRO_END_POS + 1)))
        w.word('EnergyTanks', rng.randrange(4)).word('EnergyPoints', rng.randrange(0x19))
        yield frame(w, f'random {i}')

    # Stateful autopilot to A/B, history advancement and exhaust after phase 3.
    for i in range(8 * scale):
        w = World(pair, rng); ship = base(w)
        ship.set(x=0x58, y=0xA8)
        w.word('LevelEndPhase', 1)
        w.record('PoolA', 3).live(kind=K.KIND_EXHAUST, type=0, size=0)
        steps = [frame(w, f'autopilot sequence {i} frame 0')]
        for n in range(1, 180):
            steps.append(Case('TickFrameTimers', {}, (), FREE, name=f'seq {i} tick {n}'))
            steps.append(Case('UpdatePlayerFrame', {}, (), FREE, outputs=('BP',), name=f'seq {i} ship {n}'))
            steps.append(Case('UpdateAllRecords', {}, (), FREE, name=f'seq {i} records {n}'))
        yield steps
    yield from quirks(rng, pair)
    yield from bonus_key_cases(rng, pair)
    yield from death_cases(rng, pair)

def bonus_key_cases(rng, pair):
    w = World(pair, rng); base(w)
    w.byte('BonusKeysEnabled', 1)
    yield frame(w, 'bonus key up')

    w = World(pair, rng); base(w)
    w.byte('BonusKeysEnabled', 1).byte(pair.sym('KeyDownTable') + K.SCAN_3, K.KEY_STATE_DOWN)
    released = []
    hooks = []
    # IRQ1-owned input changes at the same semantic point in both programs:
    # the selector entry, after the caller observed the key held. This tests the
    # real bonus branch without executing an IRQ or hanging in the release wait.
    for side, label in ((pair.a, 'PickupUpgradeSelector'), (pair.b, 'PICKUP_UPGRADE_SELECTOR')):
        def release(u, address, size, _, side=side):
            side.m.write(pair.sym('KeyDownTable') + K.SCAN_3, b'\0')
            released.append(side)
        at = side.m.linear(label)
        hook = side.m.u.hook_add(UC_HOOK_CODE, release, None, at, at)
        # Earlier suites may have translated this entry before the hook existed.
        # Rebuild its cached block so the release event also fires in a shared Pair.
        side.m.u.ctl_remove_cache(at, at + 1)
        hooks.append((side, hook, at))
    try:
        yield frame(w, 'bonus key released at selector entry',
                    lambda m, regs: check(len(released) == 2, 'both sides consume the same key-release event'))
    finally:
        for side, hook, at in hooks:
            side.m.u.hook_del(hook)
            side.m.u.ctl_remove_cache(at, at + 1)

def quirks(rng, pair):
    s = pair.sym
    w = World(pair, rng); ship = base(w)
    ship.set(x=0x60, y=0x60)
    yield [Case('InitPositionHistory', {}, w.writes(), FREE, name='history startup X bias',
                expect=lambda m, regs: check(m.word(s('HistoryPairs') + 2) == 0x69, 'initial X +9')),
           Case('StoreApplyHistoryAndConditionalPlacement', {'BP': ship.at}, (), LOOP,
                name='subsequent history X bias',
                expect=lambda m, regs: check(m.word(s('HistoryPairs') + 2) == 0x68, 'frame X +8'))]

    for requested in (0, 1):
        w = World(pair, rng); ship = base(w)
        ship.set(y=K.SHIP_Y_MIN)
        for name in CURSORS: w.word(name, s('HistoryEnd') - K.HISTORY_PAIR_BYTES)
        w.word('XAdjustPathTaken', requested)
        yield frame(w, f'stale nudge history {requested}',
                    lambda m, regs, requested=requested: check(m.word(s('HistoryWriteCursor')) ==
                        (s('HistoryPairs') if requested else s('HistoryEnd') - K.HISTORY_PAIR_BYTES),
                        'stale X adjustment advances history even without movement'))

    w = World(pair, rng); ship = base(w)
    ship.set(x=0x58, y=0xAA)
    w.word('LevelEndPhase', 1)
    w.fill('PoolA', K.POOL_A_COUNT, kind=K.KIND_ENEMY, type=0, size=1)
    yield frame(w, 'unchecked autopilot allocation',
                lambda m, regs: check(m.word(s('AutoMoveExtraRecord')) == 0xFFFF and m.word(0x17) == 0x52,
                                      'full pool retains the original FFFF writes'))

    w = World(pair, rng); ship = base(w)
    ship.set(x=0x59)
    w.word('LevelEndPhase', 4).word('ScrollDeltaY', 0x1234).word('LifeLostRequest', 1)
    yield frame(w, 'done leaves incoming BP and scroll intact', bp=0x4567,
                expect=lambda m, regs: check(regs['BP'] == 0x4567 and m.word(s('NextLevelRequest')) == 1
                                             and m.word(s('ScrollDeltaY')) == 0x1234
                                             and field(m, ship.at, 'x') == 0x58,
                                             'done exits before beam/scroll reset and masks X'))

def death_cases(rng, pair):
    for sprite, tick, fuel in itertools.product((3, 13, 14, 15), (2, 3), (0, 0x58)):
        w = World(pair, rng); ship = base(w)
        if sprite == 14 and tick == 3:
            restart_world(w, level=1)
        ship.set(sprite=sprite)
        w.word('LevelEndPhase', 0).word('FrameCount4', tick).word('Fuel', fuel).word('EnergyTanks', 0xFFFF)
        yield frame(w, f'dying sprite {sprite} tick {tick} fuel {fuel}')

MUTANTS = [
    ('player.c', 'keys[table[i]] & 1', 'keys[table[i]] != 0'),
    ('player.c', 'point[1] = PRIMARY->x + 9;', 'point[1] = PRIMARY->x + 8;'),
    ('player.c', 'XAdjustPathTaken == 0', 'XAdjustPathTaken != 0'),
    ('player.c', 'if (r->y != SHIP_Y_MIN) r->y--;\n        if (r->y != SHIP_Y_MIN) r->y--;',
                 'if (r->y > SHIP_Y_MIN) r->y--;\n        if (r->y > SHIP_Y_MIN) r->y--;'),
    ('player.c', 'SidePodSpreadRight != (word)-spread', 'SidePodSpreadRight == (word)-spread'),
    ('player.c', 'if (InputBits != 0) return;', 'if (InputBits == 0) return;'),
    ('player.c', 'PRIMARY->sprite >= 3 || LevelEndPhase >= LEVEL_END_REFILL',
                 'PRIMARY->sprite >= 3 || LevelEndPhase > LEVEL_END_REFILL'),
    ('player.c', 'r->sprite != 0x0F', 'r->sprite != 0x0E'),
]

def frame_seed(w):
    ship = base(w)
    keyboard(w, w.rng.randrange(64))
    w.word('LevelEndPhase', w.rng.randrange(5)).word('InputDeviceMode', w.rng.choice((0, 2)))
    ship.set(sprite=w.rng.randrange(3), x=w.rng.choice((0x58, 0x59, 0x60)),
             y=w.rng.choice((0, 0xAA, 0x60)))
    return {'BP': ship.at}

def history_seed(w):
    ship = base(w)
    near = w.record('PoolA', 1).live(kind=K.KIND_POD, size=1, sprite=0x14)
    far = near if w.rng.randrange(2) else w.record('PoolA', 2).live(kind=K.KIND_POD, size=1, sprite=0x14)
    w.word('TrailingPodNear', near.at).word('TrailingPodFar', far.at)
    return {'BP': ship.at}

def exhaust_seed(w):
    ship = base(w)
    ship.set(sprite=w.rng.randrange(5))
    r = w.record('PoolA', 3).live(kind=K.KIND_EXHAUST, type=0, size=0)
    for record in w._records.values():
        if record.at != ship.at: record.set(kind=K.KIND_EXHAUST)
    return {'BP': r.at}

def slots(pair): return (0xFFFF,) + tuple(pair.sym('PoolA') + K.RECORD_SIZE * i for i in range(K.POOL_A_COUNT))

DOMAINS = {'sprite': range(14), 'direction': range(8), 'size_class': range(3),
           'slot_index': (0xFFFF,) + tuple(range(16)), 'type': range(0x95),
           'InputDeviceMode': (0, 2, 3), 'LevelEndPhase': range(5), 'LevelIndex': range(K.LEVEL_COUNT),
           'EnergyTanks': (0xFFFF, 0, 1, 2, 3), 'EnergyPoints': range(0x19), 'Fuel': range(1, 0x59),
           'SlowCount8': range(8), 'FrameCount4': range(4), 'WeaponMode': range(6),
           'SelectedUpgradeSlot': (0xFFFF, 0, 1, 2, 3), 'BonusKeysEnabled': (0,),
           'PoolACursor': lambda p: slots(p)[1:], **{name: history_points for name in CURSORS},
           **{name: slots for name in PODS}}

def normalized(seed):
    def make(w):
        regs = seed(w)
        for r in w._records.values():
            r.set(sprite=r.get('sprite') % 14, size_class=r.get('size_class') % 3,
                  slot_index=0xFFFF, direction=r.get('direction') % 8, type=r.get('type') % 0x95)
        return regs
    return make

FUZZ = [
    Target('player_frame', 'UpdatePlayerFrame', normalized(frame_seed), REGION, FREE, outputs=('BP',),
           globals=('LevelEndPhase', 'EnergyTanks', 'EnergyPoints', 'Fuel', 'RefuelActive', 'FrameCount4',
                    'InputDeviceMode', 'SidePodSpreadLeft', 'SidePodSpreadRight', 'XAdjustPathTaken') + CURSORS,
           watch=('LevelEndPhase', 'NextLevelRequest', 'LifeLostRequest', 'HistoryWriteCursor'),
           domains=DOMAINS, pin_bp=True, seeds=40),
    Target('player_history', 'StoreApplyHistoryAndConditionalPlacement', normalized(history_seed), REGION, LOOP,
           globals=CURSORS + ('TrailingPodNear', 'TrailingPodFar', 'DemoActive', 'MapScrollPos'),
           domains=DOMAINS, pin_bp=True, seeds=24),
    Target('player_exhaust', 'UpdateAllRecords', exhaust_seed, REGION, FREE, outputs=('BP',),
           globals=('LevelEndPhase', 'SlowCount8'), domains=dict(DOMAINS, kind=(K.KIND_EXHAUST,)),
           pin_bp=True, seeds=24),
]
