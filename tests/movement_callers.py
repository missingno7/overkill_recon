"""Movement cluster through its callers: the record handlers (through RunTypeHandler; many
are C now, c/enemies.c and c/shots.c) and the ASM ones that still enter the C code through
a near call, far trampoline, ZF result or BX-preserving spawner, continuing into the
shared tails (collisions, bounds, removal)."""
from difftest import Case, ALL_REGS
from movement import word, regs, put, EDGE
import struct

RECORD = 0x38
# The record loop (UpdateAllRecords) relies on these across a handler.
LOOP = ('BP', 'SP', 'DS', 'SS')
PATHS = ('Type41Path', 'Type43Path', 'Type44Path', 'Type45Path', 'Type4APath')

def world(rng, pair):
    """Common state: counters, level, difficulty, the player, scroll."""
    s = pair.sym
    w = [(s('LevelIndex'), struct.pack('<H', rng.randrange(7))),
         (s('DifficultySetting'), struct.pack('<H', rng.randrange(3))),
         (s('SfxEnabled'), bytes([rng.randrange(2)])),
         (s('ScrollDeltaY'), struct.pack('<H', rng.choice((0, 0, 1, 2)))),
         (s('RecordTickCounter'), struct.pack('<H', rng.randrange(0x5DC))),
         (s('EncounterTicks'), struct.pack('<H', rng.randrange(0x100))),
         (s('EncounterLiveCount'), struct.pack('<H', rng.randrange(8))),
         (s('ChaseStepPixels'), struct.pack('<H', rng.choice((2, 3)))),
         (s('MissilesLive'), struct.pack('<H', rng.randrange(3)))]
    for name, mod in (('FrameCount4', 4), ('FrameCount8', 8), ('FrameCount16', 16), ('FrameCount32', 32),
                      ('FrameCount64', 64), ('FrameCount128', 128), ('FrameParity', 2)):
        w.append((s(name), struct.pack('<H', rng.randrange(mod))))
    player = bytearray(RECORD)
    put(player, 0, 1); put(player, 2, rng.randrange(0x20, 0xC1)); put(player, 4, rng.randrange(0, 0xB1))
    put(player, 8, rng.randrange(3)); put(player, 0x14, 1); put(player, 0x16, 3)
    w.append((s('PrimaryRecord'), player))
    return w

def live(rng, kind, rtype, size=1, near=None):
    rec = bytearray(rng.randrange(256) for _ in range(RECORD))
    put(rec, 0, 1); put(rec, 0x16, kind); put(rec, 0x18, rtype); put(rec, 0x14, size)
    put(rec, 0x0A, rng.randrange(2)); put(rec, 0x28, 0xFFFF)
    put(rec, 2, rng.randrange(-0x30, 0x100) & 0xFFFF); put(rec, 4, rng.randrange(0, 0xC1))
    put(rec, 6, rng.randrange(8)); put(rec, 0x20, rng.randrange(1, 6)); put(rec, 0x24, 0)
    return rec

def slot(pair, pool, i): return pair.sym(pool) + RECORD * i

def cases(rng, scale, pair):
    s = pair.sym
    n = 1500 * scale
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolB', rng.randrange(34))
        shot = live(rng, 2, rng.choice((2, 3)), 0)
        put(shot, 0x1E, rng.randrange(2)); put(shot, 0x1C, rng.choice((1, 2, 5, 30, 0xFFFF)))
        yield Case('RunTypeHandler', regs(rng, BP=at), w + [(at, shot)], LOOP, name=f'fallthrough #{i}')
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolB', rng.randrange(34))
        shot = live(rng, 2, 0x0B, 0)
        put(shot, 0x1E, 0); put(shot, 0x2A, word(rng)); put(shot, 0x2C, word(rng)); put(shot, 0x2E, word(rng))
        yield Case('RunTypeHandler', regs(rng, BP=at), w + [(at, shot)], LOOP, name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolB', rng.randrange(34))
        tat = slot(pair, 'PoolA', rng.randrange(35))
        target = live(rng, 4, rng.choice((0x14, 0x12, 0x1D, 1, 0x26)), rng.choice((1, 2)))
        put(target, 0, rng.choice((1, 1, 1, 0))); put(target, 2, rng.randrange(0, 0xF0))
        missile = live(rng, 2, 0x0A, 0)
        put(missile, 0x1E, 1); put(missile, 0x1C, rng.randrange(2)); put(missile, 0x30, tat)
        put(missile, 0x2E, word(rng))
        yield Case('RunTypeHandler', regs(rng, BP=at), w + [(tat, target), (at, missile)], LOOP, name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolA', rng.randrange(35))
        rec = live(rng, 4, 0x1D)
        put(rec, 0x32, rng.randrange(0, 0xC1) & ~1); put(rec, 0x34, rng.randrange(0x10, 0x90) & ~1)
        if rng.randrange(3) == 0: rec[2:6] = rec[0x34:0x36] + rec[0x32:0x34]   # already in the slot
        yield Case('RunTypeHandler', regs(rng, BP=at), w + [(at, rec)], LOOP, name=f'ZF #{i}')
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolA', rng.randrange(35))
        rec = live(rng, 4, 0x81)
        put(rec, 6, rng.choice((2, 6))); put(rec, 0x32, rng.randrange(0, 0xC1)); put(rec, 0x34, rng.randrange(0x10, 0x60))
        if rng.randrange(3) == 0: rec[2:6] = rec[0x34:0x36] + rec[0x32:0x34]
        yield Case('RunTypeHandler', regs(rng, BP=at), w + [(at, rec)], LOOP, name=f'sweeper entry #{i}')
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolA', rng.randrange(35))
        rec = live(rng, 4, 0x12)
        path = s(rng.choice(PATHS)) + 4 * rng.randrange(4)
        put(rec, 0x36, path)
        yield Case('RunTypeHandler', regs(rng, BP=at), w + [(at, rec)], LOOP, name=f'path follower #{i}')
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolA', rng.randrange(35))
        rec = live(rng, 4, 0x48)
        yield Case('SpawnAimedShot', regs(rng, BP=at), w + [(at, rec)], ('SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'), outputs=('BX',), name=f'BX #{i}')
    for i in range(n):
        w = world(rng, pair)
        at = slot(pair, 'PoolA', rng.randrange(35))
        rec = live(rng, 4, rng.choice((0x1E, 0x2E, 0x14)))
        put(rec, 0x32, rng.randrange(0, 0xC1)); put(rec, 0x34, rng.randrange(0x10, 0xC0))
        w.append((s('SteerSpeed'), struct.pack('<H', rng.randrange(4))))
        yield Case('RunTypeHandler', regs(rng, BP=at), w + [(at, rec)], LOOP, name=f'#{i}')
