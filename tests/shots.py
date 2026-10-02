"""Shots, terrain probes and player energy (c/shots.c): every bridge entry, the real ASM
callers (RunTypeHandler, TryTerrainStep, the climbing walkers, PodTerrainHit,
CheckRecordHitsPlayer via FinishRecordUpdate, UpdatePlayerFrame) and whole-pass sequences.

The level map is read through the CS word LevelMapSegment. Its load buffer lies at a
different linear address in each link, and 16-bit cell offsets reach 64 KiB past it (into
the state segment in the oracle), so both sides are pointed at one common 64 KiB window of
free test memory (difftest's level map window) holding this suite's fixed random map (MAP);
ByteAttributeTable (state) then decides which map bytes are open, walls (1) or other solids
per case. Both sides read the same map.
"""
from difftest import Case, ALL_REGS
from world import World, K, RECORD, POOLS
from fuzz import Target
import random
import hybrid as _hybrid

REGION = [n for n, f in _hybrid.owned_labels().items() if f in ('shots.c', 'terrain.c')]
LOOP = ('BP', 'SP', 'DS', 'SS')
MAP_SEGMENT = 0x9000          # free in both machines (the test heap ends below 9000h)
HANDLERS = {2: 'Type02TimedStraightShot', 3: 'Type02TimedStraightShot', 4: 'Type04StraightShot',
            5: 'Type05SideShotUpLeft', 6: 'Type06SideShotUpRight', 7: 'Type07RisingShot3',
            8: 'Type08RisingShot16', 9: 'Type09BeamLink', 0x0A: 'Type0AHomingMissile',
            0x0B: 'Type0BAimedEnemyShot', 0x0C: 'Type0CTimedTurnUpShot', 0x0F: 'Type0FTimedShot2'}
SHOT_TYPES = tuple(HANDLERS)
WALKER_TYPES = (0x8B, 0x8C, 0x8D, 0x8E)

def map_bytes(): return random.Random(0x5107).randbytes(0x10000)
MAP = map_bytes()      # this suite's level map baseline (difftest and fuzz install it)

def install_map(pair):
    """This suite's map as the baseline of both sides (idempotent)."""
    if pair.a.map is not MAP: pair.set_map(MAP)

def terrain(w, open_share=None):
    """The map view: attribute table (share of open bytes), scroll position and sub-row."""
    rng = w.rng
    p = rng.choice((0.3, 0.6, 0.85, 0.97, 1.0)) if open_share is None else open_share
    w.put('ByteAttributeTable', bytes(0 if rng.random() < p else rng.choice((1, 1, 1, 2, 2, 0x80)) for _ in range(256)))
    w.word('MapScrollPos', K.MAP_ROW_BYTES * rng.randrange(0, 289) if rng.randrange(8) else rng.randrange(0x10000))
    w.word('ScrollSubRow', rng.randrange(16) if rng.randrange(8) else rng.choice((0x7FF0, 0x8000, 0xFFFF)))
    w.word('ScrollDeltaY', rng.choice((0, 0, 1, 2)))
    w.word('DemoActive', rng.choice((0, 0, 0, 1)))
    return w

def energy(w):
    rng = w.rng
    w.word('EnergyPoints', rng.choice((0, 1, 1, 2, 3, 5, 0x18, 0x17)))
    w.word('EnergyTanks', rng.choice((0xFFFF, 0, 0, 1, 2, 3)))
    w.word('LevelEndPhase', rng.choice((0, 0, 0, 0, 1, 2, 3)))
    w.word('DifficultySetting', rng.randrange(3))
    w.byte('AllCheatsFlag', rng.choice((0, 0, 1)))
    w.byte('EasyHitToggle', rng.randrange(2))
    w.byte('SfxEnabled', rng.randrange(2))
    w.byte('SfxRequest', 0)
    return w

def world(pair, rng):
    w = World(pair, rng).plausible()
    install_map(pair)
    terrain(w); energy(w)
    p = w.record('PrimaryRecord', 0)
    if rng.randrange(6) == 0: p.set(sprite=rng.choice((3, 4, 5)))
    return w

def shot(w, rtype=None, at=None):
    """A live pool B shot of a handled type, often placed on the player or on a probe
    column, with its type's own fields."""
    rng = w.rng
    rtype = rng.choice(SHOT_TYPES) if rtype is None else rtype
    s = w.record('PoolB', rng.randrange(POOLS['PoolB']) if at is None else at)
    s.live(kind=K.KIND_TYPED if rng.randrange(8) else rng.choice((K.KIND_ENEMY, 0)), type=rtype, size=0,
           player_shot=rng.choice((0, 0, 1, 2)), field_1c=rng.choice((0, 1, 1, 2, 5, 30, 0xFFFF)))
    p = w.record('PrimaryRecord', 0)
    k = rng.randrange(4)
    if k == 0: s.set(y=p.get('y') + rng.randrange(-4, 0x17), x=p.get('x') + rng.randrange(-3, 0x18))
    elif k == 1: s.set(x=rng.randrange(0, 0xCC, 4), y=rng.randrange(0, 0xF0))
    elif k == 2: s.set(x=rng.choice((0, 4, 8, 0x10, 0x18, 0xC4, 0xC8, 0xCC)), y=rng.choice((6, 7, 8, 9, 0xE0, 0xE1, 0xE4)))
    if rtype == 0x0A:
        t = w.record('PoolA', rng.randrange(POOLS['PoolA'])).live(kind=rng.choice((K.KIND_ENEMY, K.KIND_ENEMY, 1)),
                                                                   type=rng.choice((0x14, 0x12, 1, 0x26, 0x21, 0x8B)))
        t.set(y=rng.choice((0xDC, 0xDD, 0xE0, 0xE1)) if rng.randrange(3) == 0 else rng.randrange(0, 0xDC))
        if rng.randrange(5) == 0: t.free()
        s.set(target=t.at, field_1c=rng.choice((0, 1)))
        if rng.randrange(3):        # on the steer target already: arrival (relock or expiry)
            s.set(y=(p.get('y') + 0x0A) & 0xFFFC, x=(p.get('x') + 0x0C) & 0xFFFC)
        w.word('MissilesLive', rng.randrange(3))
        w.word('TargetSearchCursor', w.slot('PoolA', rng.randrange(POOLS['PoolA'] + 1)))
    if rtype == 0x0B:
        s.set(delta_y=rng.randrange(-0x40, 0x41), delta_x=rng.randrange(-0x40, 0x41), step_error=rng.randrange(0x40))
    return s

def walkers(w, near, count=None, wild=True):
    """Climbing/terrain walkers (types 82h..94h) around `near`: the ProbeOverlapsWalker set.
    wild: also non-enemies and type 95h (past RunTypeHandler's table: never updated then)."""
    rng = w.rng
    kinds = (K.KIND_ENEMY, K.KIND_ENEMY, K.KIND_ENEMY, 1) if wild else (K.KIND_ENEMY,)
    types = (0x82, 0x89, 0x8B, 0x8E, 0x94, 0x81) + ((0x95,) if wild else ())
    for _ in range(rng.randrange(6) if count is None else count):
        r = w.record('PoolA', rng.randrange(POOLS['PoolA']))
        if r.at == near.at: continue
        r.live(kind=rng.choice(kinds), type=rng.choice(types), size=rng.choice((1, 1, 1, 0, 2)))
        r.set(y=near.get('y') + rng.randrange(-0x14, 0x15), x=near.get('x') + rng.randrange(-0x14, 0x15),
              draw_pass=rng.choice((0, 0, 1)), save_buffer=rng.randrange(4))
    near.set(save_buffer=rng.randrange(4))

def walker(w, rtype=None, pool_index=None, wild=True):
    rng = w.rng
    r = w.record('PoolA', rng.randrange(POOLS['PoolA']) if pool_index is None else pool_index)
    r.live(kind=K.KIND_ENEMY, type=rng.choice(WALKER_TYPES) if rtype is None else rtype, size=1,
           draw_pass=rng.choice((0, 0, 0, 1)))
    if rng.randrange(2): r.set(x=rng.randrange(0, 0xC1, 16) + rng.choice((0, 0, 1, 0x0F)))
    if rng.randrange(2): r.set(y=rng.randrange(0, 0xC0, 16) + rng.choice((0, 0, 1, 0x0F)))
    walkers(w, r, wild=wild)
    return r

def regs(rng, **fixed):
    r = {n: rng.randrange(0x10000) for n in ('AX', 'BX', 'CX', 'DX', 'SI', 'DI')}
    r.update(fixed); return r

def keep(*scratch): return tuple(r for r in ALL_REGS if r not in scratch)

def cases(rng, scale, pair):
    n = 400 * scale
    s = pair.sym
    # Record handlers through RunTypeHandler (c/enemies.c), their only caller.
    for i in range(n * 3):
        w = world(pair, rng)
        t = SHOT_TYPES[i % len(SHOT_TYPES)]
        r = shot(w, t)
        yield Case('RunTypeHandler', regs(rng, BP=r.at), w.writes(), LOOP, name=f'type {t:02X}h #{i}')
    # Grid helpers as PodProbeTerrain uses them, and through PodTerrainHit.
    for i in range(n):
        w = world(pair, rng)
        r = w.any_record()
        r.live()
        yield Case('ComputeRecordGridOffset', regs(rng, BP=r.at), w.writes(), keep('AX', 'BX', 'CX', 'DX'),
                   outputs=('BX',), name=f'#{i}')
        yield Case('ReadIndexedByteAttribute', regs(rng, BX=rng.randrange(0x10000)), w.writes(), keep('AX', 'SI', 'ES'),
                   outputs=('AX', 'ES'), flags=('ZF', 'SF'), name=f'#{i}')
        pod = w.record('PoolA', rng.randrange(POOLS['PoolA'])).live(kind=K.KIND_POD, size=1)
        yield Case('PodTerrainHit', regs(rng, BP=pod.at), w.writes(), LOOP, flags=('CF',), name=f'#{i}')
    # The ship: terrain contact (UpdatePlayerFrame's call) and tank loss (CheckRecordHitsPlayer's).
    for i in range(n):
        w = world(pair, rng)
        w.word('ScrollSubRow', rng.randrange(16))
        p = w.record('PrimaryRecord', 0)
        if i % 3 == 0: p.set(x=rng.randrange(0, 0xC1, 16) + rng.choice((0, 7, 8, 9)), y=rng.randrange(0, 0xC0))
        yield Case('DamagePlayerOnTerrainContact', regs(rng, BP=s('PrimaryRecord')), w.writes(), LOOP, name=f'#{i}')
        yield Case('LosePlayerEnergyTank', regs(rng), w.writes(), LOOP, name=f'#{i}')
    # Terrain steps through TryTerrainStep, their caller (c/enemies.c).
    for i in range(n * 2):
        w = world(pair, rng)
        r = walker(w, rng.choice((0x33, 0x56, 0x8A, 0x85) + WALKER_TYPES))
        r.set(direction=i % 8)
        if i % 16 >= 8:   # box on a cell corner: both probes of a diagonal, and the crossings
            w.word('ScrollSubRow', 0).word('ScrollDeltaY', 0).word('DemoActive', 0)
            r.set(x=16 * rng.randrange(1, 12) + rng.choice((0, 0x0F)), y=16 * rng.randrange(1, 12) + rng.choice((0, 0x0F)))
            r.set(draw_pass=1)
        w.word('TerrainProbeX', r.get('x')).word('TerrainProbeY', r.get('y') + rng.randrange(-2, 3))
        yield Case('TryTerrainStep', regs(rng, BP=r.at), w.writes(),
                   LOOP, flags=('ZF',), name=f'dir {i % 8} #{i}')
    # Climbing walkers: ClimbWalkerStep (ZF result) and its callers, the type 8Bh..8Eh handlers.
    for i in range(n * 2):
        w = world(pair, rng)
        r = walker(w, WALKER_TYPES[i % 4])
        p = w.record('PrimaryRecord', 0)
        if rng.randrange(3) == 0: p.set(y=r.get('y') + rng.choice((-1, 0, 1)))
        w.word('WalkerFacingStep', rng.choice((1, 0xFFFF)))
        if i % 2: yield Case('ClimbWalkerStep', regs(rng, BP=r.at), w.writes(), LOOP, flags=('ZF',), name=f'#{i}')
        else: yield Case('RunTypeHandler', regs(rng, BP=r.at), w.writes(), LOOP, name=f'type {r.get("type"):02X}h #{i}')
    yield from quirks(pair)
    # Whole frames: player update, all records, timers; shots, walkers and patrols in the pools.
    for i in range(12 * scale):
        w = world(pair, rng)
        w.word('LevelEndPhase', rng.choice((0, 0, 0, 1))).word('EnergyTanks', rng.randrange(4))
        w.word('Fuel', 0x58).byte('InputBits', 0)
        for k in range(POOLS['PoolB']):
            if rng.randrange(2): shot(w, at=k)
            else: w.record('PoolB', k).randomize().free()
        for k in range(POOLS['PoolA']):
            if rng.randrange(3) == 0: walker(w, rng.choice(WALKER_TYPES + (0x89, 0x8A)), pool_index=k, wild=False)
        steps = []
        for f in range(rng.choice((3, 6, 10))):
            first = w.writes() if f == 0 else ()
            steps.append(Case('UpdatePlayerFrame', {}, first, LOOP[1:], name=f'world {i} player {f}'))
            steps.append(Case('UpdateAllRecords', {}, (), LOOP[1:], name=f'world {i} records {f}'))
            steps.append(Case('TickFrameTimers', {}, (), LOOP[1:], name=f'world {i} tick {f}'))
        yield steps

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented quirk: ' + what)

def quirks(pair):
    """Surprising original behaviour of the region, asserted on the oracle, then compared."""
    s = pair.sym
    rng = random.Random(0x19)
    word = lambda m, name, extra=0: m.word(s(name) + extra)

    def base(open_share=1.0):
        w = World(pair, rng).plausible()
        install_map(pair)
        terrain(w, open_share); energy(w)
        w.word('DemoActive', 0).word('LevelEndPhase', 0).byte('AllCheatsFlag', 0).byte('SfxEnabled', 1)
        return w

    # A bar at 0 is not empty: a hit wraps it to FFFFh and costs no tank.
    w = base(); w.word('EnergyPoints', 0).word('EnergyTanks', 2).word('DifficultySetting', 0)
    w.record('PrimaryRecord', 0).set(sprite=0, y=0x80, x=0x60)
    r = w.record('PoolB', 4).live(kind=K.KIND_TYPED, type=2, size=0, player_shot=0, field_1c=5, direction=K.DIR_DOWN)
    r.set(y=0x78, x=0x64)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='bar 0 wraps',
               expect=lambda m, regs: check(word(m, 'EnergyPoints') == 0xFFFF and word(m, 'EnergyTanks') == 2, 'bar wraps'))
    # Type 3 enemy shots cost 5 hits on the hardest difficulty; the shot is used up even
    # when the hits are ignored (level-end phase 1).
    for phase in (0, 1):
        w = base(); w.word('EnergyPoints', 0x18).word('EnergyTanks', 3).word('DifficultySetting', 2).word('LevelEndPhase', phase)
        p = w.record('PrimaryRecord', 0).set(sprite=0, y=0x80, x=0x60)
        r = w.record('PoolB', 4).live(kind=K.KIND_TYPED, type=3, size=0, player_shot=0, field_1c=5, direction=K.DIR_DOWN)
        r.set(y=0x80 - 8, x=0x64)
        yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name=f'type 3 hit, phase {phase}',
                   expect=lambda m, regs, phase=phase: check(
                       m.word(r.at) == 0 and word(m, 'EnergyPoints') == (0x18 if phase else 0x18 - 15),
                       'type 3 shot: 5 hits x 3 points, shot removed even when ignored'))
    # The hit window's Y test is signed: a ship at Y 1 (SHIP_Y_MIN is an equality guard, not a
    # clamp) is hit by a shot at Y 0 although PY - 2 is FFFFh.
    w = base(); w.word('EnergyPoints', 0x10).word('EnergyTanks', 2).word('DifficultySetting', 0)
    w.record('PrimaryRecord', 0).set(sprite=0, y=1, x=0x60)
    r = w.record('PoolB', 4).live(kind=K.KIND_TYPED, type=2, size=0, player_shot=0, field_1c=5, direction=K.DIR_DOWN)
    r.set(y=0xFFF8, x=0x64)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='signed hit window',
               expect=lambda m, regs: check(word(m, 'EnergyPoints') == 0x0F, 'hit at Y 0 below PY - 2 = FFFFh'))
    # Terrain contact at difficulty 2 is 4 hits of 3 points; an FFFFh grid offset (negative
    # GridYSum) is not checked by the ship probe: + 13 wraps to cell 000Ch.
    w = base(); w.word('EnergyPoints', 0x18).word('EnergyTanks', 3).word('DifficultySetting', 2)
    table = bytearray(256); table[map_bytes()[0x0C]] = 1; w.put('ByteAttributeTable', bytes(table))
    w.word('ScrollSubRow', 0).record('PrimaryRecord', 0).set(sprite=0, y=0xFFE0, x=0x40)
    yield Case('DamagePlayerOnTerrainContact', {'BP': s('PrimaryRecord')}, w.writes(), LOOP, name='negative Y probes cell 0Ch',
               expect=lambda m, regs: check(word(m, 'EnergyPoints') == 0x18 - 12, 'four hits of three points'))
    # A diagonal terrain step moves its free axis although it reports blocked (NZ): here a
    # walker 16 px above blocks the up step, the right step still happens.
    w = base(1.0); w.word('ScrollDeltaY', 0)
    r = w.record('PoolA', 7).live(kind=K.KIND_ENEMY, type=0x33, size=1, draw_pass=0, save_buffer=1)
    r.set(x=0x41, y=0x48, direction=K.DIR_UP_RIGHT)
    w.record('PoolA', 9).live(kind=K.KIND_ENEMY, type=0x8B, size=1, draw_pass=0, save_buffer=2).set(x=0x41, y=0x38)
    yield Case('TryTerrainStep', {'BP': r.at}, w.writes(), LOOP, flags=('ZF',), name='diagonal half step',
               expect=lambda m, regs: check(m.word(r.at + 4) == 0x42 and m.word(r.at + 2) == 0x48 and not regs['FLAGS'] & 0x40,
                                            'X steps, Y blocked, NZ'))
    # A side shot over a wall rises straight only on its probe frame (X mod 16 = 0).
    w = base(0.0); w.put('ByteAttributeTable', bytes([1]) * 256).word('ScrollDeltaY', 0)
    r = w.record('PoolB', 2).live(kind=K.KIND_TYPED, type=5, size=0, player_shot=1)
    r.set(x=0x40, y=0x80)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='side shot turns up at a wall',
               expect=lambda m, regs: check(m.word(r.at + 4) == 0x40 and m.word(r.at + 6) == K.DIR_UP, 'turned up, X kept'))

# Plausible translation slips; each must make this suite fail (python tools/difftest.py --mutants shots).
MUTANTS = [
    ('terrain.c', 'if ((sword)GridYSum < 0) return 0xFFFF;', 'if (GridYSum > 0x7FFF) return 0;'),
    ('terrain.c', 'rows = (GridYSum & 0x0F) > 0x0A ? 2 : 1;', 'rows = (GridYSum & 0x0F) >= 0x0A ? 2 : 1;'),
    ('shots.c', 'if ((sword)s->y >= (sword)top && (sword)s->y <= (sword)(top + 0x14)', 'if (s->y >= top && s->y <= top + 0x14'),
    ('shots.c', '        EasyHitToggle = (EasyHitToggle + 1) & 1;\r\n        if (EasyHitToggle) return;', '        if (EasyHitToggle) return;'),
    ('shots.c', '        if (MissilesLive != 0) MissilesLive--;\r\n', ''),
    ('terrain.c', 'if ((r->x & 0x0F) == 0x0F) cell--;', 'if ((r->x & 0x0F) == 0) cell--;'),
    ('terrain.c', 'if (r->save_buffer == w->save_buffer) continue;', ''),
    ('terrain.c', 'case DIR_DOWN_LEFT:  terrain_step_left(r, terrain_step_down(r, cell)); break;',
                'case DIR_DOWN_LEFT:  terrain_step_down(r, terrain_step_left(r, cell)); break;'),
    ('shots.asm', 'ClimbWalkerStep:\r\n    push si\r\n    mov si, bp\r\n    call CLIMB_WALKER_STEP\r\n    pop si\r\n    cmp ax, 1\r\n',
                  'ClimbWalkerStep:\r\n    push si\r\n    mov si, bp\r\n    call CLIMB_WALKER_STEP\r\n    pop si\r\n    cmp ax, 0\r\n'),
]

# Coverage-guided differential fuzzing (python tools/fuzz.py shots N [--save]). Shot
# families get their own targets (and seeds): the fuzzer keeps REC_TYPE inside a family.
def _base(w):
    install_map(w.pair)
    w.plausible(); terrain(w); energy(w)
    if w.rng.randrange(2): w.word('DemoActive', 0)
    return w

def _shot_seed(types):
    def seed(w):
        _base(w)
        s = shot(w, w.rng.choice(types))
        if s.get('type') in (5, 6) and w.rng.randrange(3):
            s.set(x=16 * w.rng.randrange(0, 13) + w.rng.choice((0, 8, 4)))
        if s.get('type') == 0x0A and w.rng.randrange(3): w.byte('SfxEnabled', 1)
        return {'BP': s.at}
    return seed

def _terrain_seed(w):
    install_map(w.pair)
    w.plausible(); terrain(w, w.rng.choice((None, 0.3, 0.6)))
    r = walker(w, w.rng.choice((0x33, 0x56, 0x85) + WALKER_TYPES))
    r.set(direction=w.rng.randrange(8))
    if w.rng.randrange(3): r.set(x=16 * w.rng.randrange(1, 13) + w.rng.choice((0, 0, 1, 0x0F, 0x0F)))
    return {'BP': r.at}

def _crowd_seed(w):
    """An open map and walkers packed around the stepping record: the undo paths."""
    install_map(w.pair)
    w.plausible(); terrain(w, 1.0)
    r = walker(w, w.rng.choice((0x33, 0x85) + WALKER_TYPES), wild=False).set(draw_pass=0, direction=w.rng.randrange(8))
    for k in range(w.rng.randrange(1, 4)):
        o = w.record('PoolA', w.rng.randrange(POOLS['PoolA']))
        if o.at == r.at: continue
        o.live(kind=K.KIND_ENEMY, type=w.rng.choice((0x82, 0x8B, 0x94)), size=1, draw_pass=0)
        o.set(save_buffer=r.get('save_buffer') + 1,
              x=r.get('x') + w.rng.choice((-0x11, -0x10, 0x10, 0x11, 0)), y=r.get('y') + w.rng.choice((-0x11, -0x10, 0x10, 0x11, 0)))
    return {'BP': r.at}

def _climb_seed(w):
    _base(w)
    r = walker(w)
    if w.rng.randrange(2): w.record('PrimaryRecord', 0).set(y=r.get('y') + w.rng.randrange(-2, 3))
    return {'BP': r.at}

def _ship_seed(w):
    _base(w)
    w.word('ScrollSubRow', w.rng.randrange(16))
    return {'BP': w.sym('PrimaryRecord')}

def _energy_seed(w):
    _base(w)
    return {}

def _pod_seed(w):
    _base(w)
    return {'BP': w.record('PoolA', w.rng.randrange(POOLS['PoolA'])).live(kind=K.KIND_POD, size=1).at}

ENERGY = ('EnergyPoints', 'EnergyTanks', 'LevelEndPhase', 'DifficultySetting')
MAP_GLOBALS = ('MapScrollPos', 'ScrollSubRow', 'ScrollDeltaY', 'DemoActive')
# Preconditions: RunTypeHandler's table (entered only with these types here) and REC_DIRECTION
# (0..7: MoveInDirectionN and TerrainStepCases are unchecked tables); TargetSearchCursor and
# REC_TARGET only ever hold pool A slot addresses. The energy gauge (RedrawEnergyGauge, platform)
# indexes CS tables by EnergyTanks (-1..3) and loops over EnergyPoints (0..18h, or below 0
# after the wrap quirk); counters, difficulty, level and scroll stay in their ranges.
def _slots(pair): return range(pair.sym('PoolA'), pair.sym('PoolA') + RECORD * (POOLS['PoolA'] + 1), RECORD)
DOMAINS = {'direction': range(8), 'target': _slots, 'TargetSearchCursor': _slots,
           'EnergyTanks': (0xFFFF, 0, 1, 2, 3), 'EnergyPoints': tuple(range(0x19)) + tuple(range(0xFFF0, 0x10000)),
           'DifficultySetting': range(3), 'LevelEndPhase': range(5), 'LevelIndex': range(K.LEVEL_COUNT),
           'DemoActive': (0, 1), 'ScrollDeltaY': range(4), 'ScrollSubRow': range(16), 'MissilesLive': range(4),
           'FrameCount4': range(4), 'FrameCount8': range(8), 'FrameCount16': range(16), 'FrameCount128': range(128)}
SHOT_GLOBALS = ENERGY + MAP_GLOBALS + ('LevelIndex', 'FrameCount4', 'FrameCount16')
FAMILIES = {'shots_hit': (2, 3, 4, 0x0B, 0x0F), 'shots_side': (5, 6), 'shots_rise': (7, 8, 9, 0x0C),
            'shots_missile': (0x0A,)}
FUZZ = [Target(name, 'RunTypeHandler', _shot_seed(types), REGION, LOOP, types=types,
               globals=SHOT_GLOBALS + (('MissilesLive', 'FrameCount8', 'TargetSearchCursor') if 0x0A in types else ()),
               watch=('EnergyPoints', 'EnergyTanks', 'MissilesLive'), domains=dict(DOMAINS, type=types))
        for name, types in FAMILIES.items()]
FUZZ += [
    Target('shots_energy', 'LosePlayerEnergyTank', _energy_seed, REGION, LOOP,
           globals=ENERGY, watch=('EnergyPoints', 'EnergyTanks'), domains=DOMAINS),
    Target('shots_shipterrain', 'DamagePlayerOnTerrainContact', _ship_seed, REGION, LOOP,
           globals=ENERGY + MAP_GLOBALS, watch=('EnergyPoints', 'EnergyTanks'), domains=DOMAINS),
    Target('shots_terrain', 'TryTerrainStep', _terrain_seed, REGION, LOOP, flags=('ZF',),
           globals=MAP_GLOBALS, domains=DOMAINS),
    Target('shots_crowd', 'TryTerrainStep', _crowd_seed, REGION, LOOP, flags=('ZF',),
           globals=MAP_GLOBALS, domains=DOMAINS),
    Target('shots_climb', 'RunTypeHandler', _climb_seed, REGION, LOOP, types=WALKER_TYPES,
           globals=ENERGY + MAP_GLOBALS + ('FrameCount128',), watch=('TerrainBlocked', 'EnergyTanks'),
           domains=dict(DOMAINS, type=WALKER_TYPES)),
    Target('shots_pod', 'PodTerrainHit', _pod_seed, REGION, LOOP, flags=('CF',),
           globals=MAP_GLOBALS + ('LevelEndPhase', 'DifficultySetting'), domains=DOMAINS),
]
