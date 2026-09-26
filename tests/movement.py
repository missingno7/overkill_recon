"""Movement/steering cluster (c/movement.c): every entry label, random and edge states.

Register contracts are the oracle's (see each routine's comment): the routine may clobber
the listed scratch registers; every other register must come back as the oracle leaves it.
"""
from difftest import Case, ALL_REGS
import struct

EDGE = (0, 1, 2, 3, 4, 7, 8, 9, 0x0C, 0x7FFE, 0x7FFF, 0x8000, 0x8001, 0xFFF8, 0xFFFC, 0xFFFD, 0xFFFE, 0xFFFF)
RECORD = 0x38

def word(rng, near=None):
    """A 16-bit value: edges, small signed values, values near `near`, or anything."""
    k = rng.randrange(10)
    if k < 3: return rng.choice(EDGE)
    if k < 5: return rng.randrange(-0x120, 0x120) & 0xFFFF
    if k < 8 and near is not None: return (near + rng.randrange(-17, 18)) & 0xFFFF
    return rng.randrange(0x10000)

def keep(*scratch):
    return tuple(r for r in ALL_REGS if r not in scratch)

def regs(rng, **fixed):
    r = {n: rng.randrange(0x10000) for n in ('AX', 'BX', 'CX', 'DX', 'SI', 'DI')}
    r['ES'] = rng.choice((0, 0xA000, 0xB800, rng.randrange(0x10000)))
    r.update(fixed); return r

def record(rng, pair, avoid=()):
    """Offset of a random pool A slot (or the primary), and 38h random bytes for it."""
    base = pair.sym('PrimaryRecord')
    while True:
        at = base + RECORD * rng.randrange(36)
        if at not in avoid: break
    data = bytearray(rng.randrange(256) for _ in range(RECORD))
    return at, data

def put(data, off, value): struct.pack_into('<H', data, off, value & 0xFFFF)

def cases(rng, scale, pair):
    s = pair.sym
    n = 6000 * scale
    # MoveInDirection3/8 have no ASM caller left (c/shots.c calls move_in_direction).
    moves = ('MoveInDirection2', 'MoveInDirection4')
    for i in range(n):
        at, rec = record(rng, pair)
        put(rec, 2, word(rng)); put(rec, 4, word(rng)); put(rec, 6, i % 8)
        yield Case(moves[i // 8 % 2], regs(rng, BP=at), [(at, rec)], keep('BX'), name=f'#{i}')
    for i in range(n):
        at, rec = record(rng, pair)
        tx, ty = word(rng), word(rng)
        put(rec, 4, word(rng, tx)); put(rec, 2, word(rng, ty))
        writes = [(at, rec), (s('SteerTargetX'), struct.pack('<HH', tx, ty)),
                  (s('SteerSpeed'), struct.pack('<H', i % 4)),
                  (s('SteerArrived'), struct.pack('<H', rng.choice((0, 1, 0xFFFF))))]
        yield Case('SteerTowardTarget', regs(rng, BP=at), writes, keep('AX', 'BX'), name=f'#{i}')
    for i in range(n):
        at, rec = record(rng, pair)
        sx, sy = word(rng), word(rng)
        put(rec, 0x32, sx); put(rec, 0x34, sy)
        put(rec, 4, word(rng, sx)); put(rec, 2, word(rng, sy))
        writes = [(at, rec), (s('SteerSpeed'), struct.pack('<H', i % 4))]
        yield Case('SteerToSaved', regs(rng, BP=at), writes, keep('AX', 'BX'), flags=('ZF',), name=f'#{i}')
    for i in range(n):
        at, rec = record(rng, pair)
        tat, trec = record(rng, pair)
        put(trec, 0x14, rng.choice((0, 1, 2, 1, word(rng))))
        writes = [(tat, trec), (at, rec)] if rng.randrange(2) else [(at, rec), (tat, trec)]
        if rng.randrange(8) == 0: tat = at   # self as target
        yield Case('SetDeltaToward', regs(rng, BP=at, BX=tat), writes, keep('AX', 'CX', 'DX'), name=f'#{i}')
    for i in range(n):
        at, rec = record(rng, pair)
        pat, prim = s('PrimaryRecord'), bytearray(rng.randrange(256) for _ in range(RECORD))
        writes = [(pat, prim), (at, rec)]
        yield Case('AimAtPlayer', regs(rng, BX=at), writes, keep('AX', 'CX'), name=f'#{i}')
    for i in range(n * 2):
        at, rec = record(rng, pair)
        put(rec, 0x2A, word(rng)); put(rec, 0x2C, word(rng)); put(rec, 0x2E, word(rng))
        if i % 7 == 0: put(rec, 0x2A, rec[0x2C] | rec[0x2D] << 8)          # |dX| = |dY|
        if i % 11 == 0: put(rec, 0x2A, -(rec[0x2C] | rec[0x2D] << 8))
        if i % 13 == 0: put(rec, 0x2A, 0); put(rec, 0x2C, 0)                # zero delta
        pixels = rng.choice((3, 3, 2, 0, 1, 4, 0xFFFF, 0x0103))
        writes = [(at, rec), (s('ChaseStepPixels'), struct.pack('<H', pixels))]
        yield Case('StepAlongDelta', regs(rng, BP=at), writes, keep('AX', 'BX'), name=f'#{i}')

# Plausible translation slips; each must make this suite fail (python tools/difftest.py --mutants).
MUTANTS = [
    ('movement.c', 'if (r->x < SteerTargetX) bits = 1;', 'if ((sword)r->x < (sword)SteerTargetX) bits = 1;'),
    ('movement.c', 'if ((sword)r->y < (sword)SteerTargetY) bits |= 4;', 'if (r->y < SteerTargetY) bits |= 4;'),
    ('movement.c', 'SteerArrived = 1;\n        return;', 'SteerArrived = 1;'),
    ('movement.c', 'if (r->step_error > dx) r->step_error -= dx;', 'if (r->step_error >= dx) r->step_error -= dx;'),
    ('movement.c', 'ChaseStepPixels == 3 ? 3 : 2', 'ChaseStepPixels'),
    ('movement.c', 'target->size_class == 1 ? 4 : 0x0C', 'target->size_class != 0 ? 4 : 0x0C'),
    ('movement.c', '(PRIMARY->x + 9)', '(PRIMARY->x + 8)'),
    ('movement.c', 'if ((sword)dx < 0)', 'if ((sword)dx <= 0)'),
    ('movement.c', 'case DIR_DOWN_LEFT:  r->y += n; r->x -= n;', 'case DIR_DOWN_LEFT:  r->y += n; r->x += n;'),
    ('movement.asm', 'MoveInDirectionN:\r\n    push ax\r\n', 'MoveInDirectionN:\r\n'),
]

# Coverage-guided differential fuzzing (python tools/fuzz.py movement N): the movement
# region's oracle code guides the search from these entries.
from fuzz import Target
from world import K
import hybrid as _hybrid
REGION = [n for n, f in _hybrid.owned_labels().items() if f == 'movement.c']

def _steer_seed(w):
    r = w.record('PoolA', w.rng.randrange(35)).live()
    tx, ty = r.get('x') + w.rng.randrange(-20, 21), r.get('y') + w.rng.randrange(-20, 21)
    w.word('SteerTargetX', tx).word('SteerTargetY', ty).word('SteerSpeed', w.rng.randrange(4))
    return {'BP': r.at}

def _step_seed(w):
    r = w.record('PoolB', w.rng.randrange(34)).live(delta_x=w.rng.randrange(-40, 41), delta_y=w.rng.randrange(-40, 41))
    w.word('ChaseStepPixels', w.rng.choice((2, 3)))
    return {'BP': r.at}

def _missile_seed(w):
    w.plausible()
    t = w.record('PoolA', w.rng.randrange(35)).live(kind=K.KIND_ENEMY, type=0x14)
    m = w.record('PoolB', w.rng.randrange(34)).live(kind=K.KIND_TYPED, type=0x0A, size=0, player_shot=1,
                                                     field_1c=w.rng.randrange(2), target=t.at)
    return {'BP': m.at}

def _path_seed(w):
    w.plausible()
    r = w.record('PoolA', w.rng.randrange(35)).live(kind=K.KIND_ENEMY, type=0x12)
    r.set(field_36=w.sym(w.rng.choice(('Type41Path', 'Type43Path', 'Type44Path'))))
    return {'BP': r.at}

def _aim_seed(w):
    w.plausible()
    if w.rng.randrange(3) == 0: w.fill('PoolB', w.rng.choice((33, 34)))
    return {'BP': w.record('PoolA', w.rng.randrange(35)).live(kind=K.KIND_ENEMY, type=0x48).at}

def _slot_seed(w):
    w.plausible()
    r = w.record('PoolA', w.rng.randrange(35)).live(kind=K.KIND_ENEMY, type=0x1D)
    r.set(saved_x=r.get('x') + w.rng.randrange(-8, 9), saved_y=r.get('y') + w.rng.randrange(-8, 9))
    return {'BP': r.at}

NOT_AX_BX = tuple(r for r in ALL_REGS if r not in ('AX', 'BX'))
# Preconditions: unchecked jump tables (SteerSpeed, REC_DIRECTION); every writer stays inside.
DOMAINS = {'SteerSpeed': range(4), 'direction': range(8)}
FUZZ = [
    Target('steer', 'SteerTowardTarget', _steer_seed, REGION, NOT_AX_BX, globals=('SteerTargetX', 'SteerTargetY', 'SteerSpeed'), domains=DOMAINS),
    Target('step', 'StepAlongDelta', _step_seed, REGION, NOT_AX_BX, globals=('ChaseStepPixels',), domains=DOMAINS),
    Target('missile', 'Type0AHomingMissile', _missile_seed, REGION, types=(0x14, 0x12, 0x26, 1, 0x21),
           globals=('MissilesLive', 'FrameCount8', 'DemoActive', 'SfxEnabled', 'ScrollDeltaY'), watch=('MissilesLive',), domains=DOMAINS),
    Target('aimshot', 'SpawnAimedShot', _aim_seed, REGION, ('SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'), outputs=('BX',),
           globals=('SegBossActive', 'SfxEnabled', 'PoolBCursor'), domains=DOMAINS),
    Target('slotbob', 'Type1DSlotBobThenChase', _slot_seed, REGION, types=(0x1D,),
           globals=('EncounterTicks', 'EncounterLiveCount', 'SteerSpeed', 'FrameCount8', 'RecordTickCounter'), domains=DOMAINS),
    Target('pathfollow', 'Type12WaypointPathFollower', _path_seed, REGION,
           globals=('LevelIndex', 'DemoActive', 'MapScrollPos'),
           # REC_PATH only ever points at a waypoint of the Type41..Type51 path tables.
           domains=dict(DOMAINS, field_36=lambda pair: range(pair.sym('Type41Path'), pair.sym('AutoMoveExtraRecord'), 4))),
]
