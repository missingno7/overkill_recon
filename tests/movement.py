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
    moves = ('MoveInDirection2', 'MoveInDirection3', 'MoveInDirection4', 'MoveInDirection8')
    for i in range(n):
        at, rec = record(rng, pair)
        put(rec, 2, word(rng)); put(rec, 4, word(rng)); put(rec, 6, i % 8)
        yield Case(moves[i % 4], regs(rng, BP=at), [(at, rec)], keep('BX'), name=f'#{i}')
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
