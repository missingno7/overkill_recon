"""Enemy region (c/enemies.c): RunTypeHandler and the REC_TYPE handlers it owns, the shared
scroll/bounds/collision tail, the pickup update, the encounter director, the formation
members, the throttled child shot and the terrain step.

Entries: RunTypeHandler (every REC_TYPE 0..94h, the C handlers and the dispatch to the ASM
ones), UpdatePickup, and the bridge labels the remaining ASM reaches (ScrollRecordThenFinish,
FinishRecordUpdate, HorizontalTerrainPatrol, NextRandomWord, SpawnAimedShot,
SpawnThrottledChild, SpawnShotDown, TryTerrainStep); sequences of UpdateAllRecords and
TickFrameTimers over worlds of these types. Register contracts are the oracle's: the
registers listed are the ones it keeps.
"""
from difftest import Case, ALL_REGS
from world import World, K, RECORD, POOLS, FIELDS
from shots import MAP, install_map, terrain, walkers
import itertools, struct

import hybrid as _hybrid
REGION = [n for n, f in _hybrid.owned_labels().items() if f == 'enemies.c']
LOOP = ('BP', 'SP', 'DS', 'SS')
W = lambda v: struct.pack('<H', v & 0xFFFF)

def keep(*scratch): return tuple(r for r in ALL_REGS if r not in scratch)

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented behaviour: ' + what)

# REC_TYPE families of this region (the fuzz targets keep REC_TYPE inside one family).
TURRETS = (0x24, 0x25, 0x26, 0x90, 0x91, 0x34, 0x30, 0x37, 0x86, 0x88, 0x92, 0x75)
DESCENDERS = (0x27, 0x31, 0x38, 0x39, 0x3A, 0x3B, 0x42, 0x48, 0x49, 0x4C, 0x4D, 0x4F, 0x52, 0x53, 0x5D,
              0x64, 0x69, 0x6B, 0x6C, 0x6D, 0x6F, 0x70, 0x72, 0x2C, 0x2E, 0x2F)
CRAWLERS = (0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5E, 0x5F, 0x6A, 0x6E, 0x73, 0x74, 0x85, 0x19, 0x83, 0x26)
FORMATION = (0x14, 0x16, 0x17, 0x18, 0x1D, 0x1E, 0x20)
DIRECTOR = (0x21, 0x23)
INVADERS = (0x61, 0x62, 0x63, 0x64, 0x65)
HATCH = (0x28, 0x2A)
SWEEPER = (0x93,)
MISC = (0x00, 0x01, 0x0D, 0x0E, 0x52, 0x82, 0x94)
OWN_TYPES = tuple(sorted(set(TURRETS + DESCENDERS + CRAWLERS + FORMATION + DIRECTOR + INVADERS + HATCH + SWEEPER + MISC)))
ALL_TYPES = tuple(range(0x95))

_cycles = {}
def _next(name, values): return next(_cycles.setdefault(name, itertools.cycle(values)))

# ---- worlds --------------------------------------------------------------------------------

def world(pair, rng, w=None):
    """A mid-game world on shots.py's level map: counters (also the slow ones), level,
    difficulty, player, terrain view, encounter and formation state, cursors in their tables."""
    w = (w or World(pair, rng)).plausible()
    install_map(pair)
    terrain(w)
    s = w.sym
    for name, mod in (('SlowCount4', 4), ('SlowCount5', 5), ('SlowCount6', 6), ('SlowCount8', 8),
                      ('FrameDivider4', 4)):
        w.word(name, rng.randrange(mod))
    w.word('EncounterTicks', rng.choice((rng.randrange(0x100), 0x23, 0x28, 0x31, 0x32, 0x5A, 0xC8, 0xF0)))
    w.word('EncounterLiveCount', rng.choice((0, 1, 2, 3, 4, 5, 6, 8, 9, 0x10, 0x11, rng.randrange(0x20))))
    w.word('RecordTickCounter', rng.choice((rng.randrange(0x5DC), 0, 4, 5, 0x0C, 0x79, 0xFF, 0x159, 0x1FF,
                                             0x2BC, 0x2BD, 0x2D0, 0x2EF, 0x40C)))
    w.word('SwayDirX', rng.choice((1, 0xFFFF, 0)))
    w.word('SwayDropY', rng.choice((0, 0, 8)))
    w.word('LevelEndPhase', rng.choice((0, 0, 0, 0, 0, 1, 2)))
    w.word('SegBossActive', rng.choice((0, 0, 0, 1)))
    w.word('SteerSpeed', rng.randrange(4))
    w.word('ChaseStepPixels', rng.choice((2, 3)))
    w.byte('ChildSpawnThrottle', rng.randrange(4))
    w.byte('SfxRequest', 0)
    w.word('RandomWordCursor', s('CreditRandomWords') + 2 * rng.randrange(16))
    w.word('PoolBCursor', w.slot('PoolB', rng.randrange(POOLS['PoolB'] + 1)))
    w.word('PoolACursor', w.slot('PoolA', rng.randrange(POOLS['PoolA'])))
    w.word('FormationSlotCursor', s('FormationSlots') + 4 * rng.randrange(21))
    w.word('FallerColumnCursor', s('FallerColumns') + 2 * rng.randrange(15))
    w.word('InvaderSlotCursor', s('InvaderFormation') + 4 * rng.randrange(25))
    w.word('LeaderScriptCursor', rng.choice((s('LeaderScript13End'), s('LeaderScript7DEnd'), s('LeaderScript13'))))
    w.word('FramesSinceInvaderSpawn', rng.choice((0, 0x17, 0x18, 0x40, 0xFFFF)))
    w.word('InvaderDropStep', rng.choice((0, 0, 2)))
    w.word('InvaderMarchLeft', rng.randrange(2))
    w.byte('Type93KilledPulse', rng.choice((0, 0, 0, 1)))
    w.word('DescentTargetX', rng.choice((0x50, 0x60, 0x70)))
    if rng.randrange(2):        # the frame counters of one frame number, as TickFrameTimers keeps them
        f = rng.choice((rng.randrange(0x80), 0x1F, 0x3F, 0x5F, 0x7F, 0x26, 0x66, 0x0F, 0x07, 0x03, 0x20, 0x60))
        for name, mask in (('FrameCount4', 3), ('FrameCount8', 7), ('FrameCount16', 15), ('FrameCount32', 31),
                           ('FrameCount64', 63), ('FrameCount128', 127), ('FrameParity', 1)):
            w.word(name, f & mask)
    if rng.randrange(3) == 0: w.fill('PoolB', rng.choice((30, 33, 34)))
    if rng.randrange(6) == 0: w.fill('PoolA', rng.choice((34, 35)))
    return w

def aligned(rng, v, step=16):
    return rng.choice((v, v, (v & -step) + rng.choice((0, 1, step - 1))))

def enemy(w, rtype, pool='PoolA', index=None):
    """A live record of `rtype` with the fields its handler reads set near their edges."""
    rng, s = w.rng, w.sym
    p = w.record('PrimaryRecord', 0)
    if index is None: index = rng.randrange(POOLS[pool])
    r = w.record(pool, index).live(kind=K.KIND_ENEMY if rtype >= 0x10 else rng.choice((K.KIND_TYPED, K.KIND_ENEMY)),
                                   type=rtype, size=rng.choice((1, 1, 2, 0)))
    r.set(y=rng.choice((rng.randrange(0x10, 0xD0),) * 3 + (0x80, 0x7F, 0x81, 0x50, 0xB0, 0x90, 0x60, 0x40, 0xC0, 0xC1,
                                                          0x08, 0x18, 0x19, 0xEF, 0xF0, 0xFF41, 0xFF40, 0xFFEC, 0xFFEB)))
    r.set(x=rng.choice((rng.randrange(0, 0xC1),) * 3 + (0, 0x60, 0x5F, 0x61, 0x50, 0x70, 0xC0, 0xBF, 0xC1, 0xFFFF)))
    if rng.randrange(4) == 0: r.set(x=aligned(rng, r.get('x')), y=aligned(rng, r.get('y')))
    k = rng.randrange(6)
    if k == 0: r.set(saved_x=r.get('x'), saved_y=r.get('y'))
    elif k == 1: r.set(saved_x=r.get('x') + rng.randrange(-4, 5), saved_y=r.get('y') + rng.randrange(-4, 5))
    else: r.set(saved_x=rng.randrange(0, 0xC1), saved_y=rng.randrange(0x10, 0xC0))
    if rng.randrange(4) == 0: p.set(x=r.get('x') + rng.randrange(-8, 9), y=r.get('y') + rng.randrange(-0x18, 0x19))
    if rng.randrange(8) == 0: p.set(x=r.get('x'))
    t = rtype
    at_saved = rng.randrange(2) == 0
    if t in (0x14, 0x16, 0x17, 0x1D, 0x1E, 0x20, 0x23, 0x2F, 0x61) and at_saved:
        if t in (0x1E, 0x2F) and rng.randrange(2): r.set(x=rng.choice((0, 0xC0)))
        r.set(saved_x=r.get('x'), saved_y=r.get('y'))
    if t == 0x1D and rng.randrange(2):
        w.word('EncounterTicks', rng.choice((0x10, 0x27, 0x28))).word('EncounterLiveCount', rng.choice((2, 3, 4)))
        r.set(y=rng.choice((0x40, 0xC0, 0xC1)))
    if t == 0x69 and rng.randrange(2): r.set(y=rng.choice((0x14, 0x18, 0x1C, 0x1D)))
    if t in (0x24, 0x25, 0x90, 0x91) and rng.randrange(2):
        w.word('FrameCount32', 0x1F).word('DifficultySetting', 2)
    if t == 0x01:
        r.set(size_class=rng.randrange(3), anim_counter=rng.choice((8, 9, 0x0B, 0x0C, 2)),
              prev_type=rng.choice((0x24, 0x25, 0x14, 0x30)))
    elif t == 0x14:
        if rng.randrange(3): w.word('LeaderScriptCursor', s('LeaderScript13End'))
        if rng.randrange(2): w.word('SwayDropY', 0)
        if rng.randrange(3) == 0: w.word('RecordTickCounter', rng.choice((0xFF, 0x7F, 0x1FF, 0x17F, 0x2EF)))
        if rng.randrange(3) == 0: w.word('EncounterLiveCount', rng.choice((5, 6, 7)))
        if rng.randrange(3) == 0: r.set(y=r.get('saved_y') + rng.choice((1, 2, 8)))
    elif t in (0x16, 0x17):
        r.set(entry_delay=rng.choice((0, 0, 1, 2, 5)))
        if rng.randrange(2): w.word('EncounterTicks', 0x31)
    elif t == 0x18:
        at = s('SweepPathLeadIn') + 4 * rng.randrange((s('LeaderScript7D') - s('SweepPathLeadIn')) // 4)
        r.set(path=at)
        mem = w.pair.a.pristine
        if rng.randrange(2) and mem[at:at + 2] != b'\xff\xff':
            r.set(y=(mem[at] | mem[at + 1] << 8) + 0x20, x=mem[at + 2] | mem[at + 3] << 8)
    elif t == 0x20:
        r.set(dive_phase=rng.choice((0xFFFF, 0xFFFF, 0xFFFF, 0, 1, 2)))
        if rng.randrange(2): w.word('EncounterTicks', rng.choice((0x23, 0x40, 0x22)))
        if rng.randrange(3) == 0: w.word('RecordTickCounter', rng.choice((0x2BC, 0x2C0, 0x2D0, 0, 4, 5)))
        if rng.randrange(3) == 0: w.word('FrameCount64', 0x3F)
        if rng.randrange(3) == 0: w.word('EncounterLiveCount', rng.choice((3, 4)))
        if rng.randrange(3) == 0: r.set(y=rng.choice((0x9C, 0xA0, 0xA4)))
    elif t == 0x23:
        r.set(faller_variant=rng.randrange(4), y=rng.choice((0x1C, 0x20, 0x1B, 0x21, r.get('y'))))
        if at_saved: r.set(saved_x=r.get('x'), saved_y=r.get('y'))
    elif t == 0x2E:
        if rng.randrange(2): r.set(y=0x80)
    elif t == 0x37:
        r.set(x=rng.choice((0x50, 0x60, 0x70, r.get('x'))), y=rng.choice((8, 9, 0x0D, 0x0E, 0x8F, 0x8C, 0x8B, r.get('y'))))
    elif t in (0x28, 0x2A):
        r.set(direction=rng.choice((6, 7, 7, rng.randrange(0x18))))
        if rng.randrange(2): w.word('EncounterLiveCount', 0)
    elif t == 0x49:
        if rng.randrange(2): w.word('FrameCount16', 0x0F)
    elif t == 0x62:
        r.set(x=rng.choice((0xC0 - rng.choice((1, 2, 4, 8, 16)), rng.choice((1, 2, 4, 8, 16)), r.get('x'))))
        if rng.randrange(3) == 0: p.set(x=r.get('x') + rng.choice((1, -1, 2, -2, 4, -4)))
        if rng.randrange(3) == 0:
            w.word('FrameCount4', 0); w.word('FrameCount128', w_word(w, 'RecordTickCounter') & 0x7F)
        w.word('FramesSinceInvaderSpawn', rng.choice((0x18, 0x40, 0x17)))
    elif t == 0x6C:
        if rng.randrange(2): r.set(x=0x60); w.word('FrameCount4', rng.choice((3, 3, 2)))
    elif t == 0x86:
        if rng.randrange(2): w.word('FrameCount64', 0x26)
    elif t == 0x26:
        r.set(sprite=rng.choice((0x98, 0x92, 0x97, 0x91, 0x93)), direction=rng.choice((K.DIR_LEFT, K.DIR_RIGHT)))
    elif t == 0x30:
        r.set(sprite=rng.choice((0x46, 0x45, 0x47)))
    elif t in (0x4C, 0x4D, 0x55):
        r.set(direction=rng.choice((K.DIR_UP, K.DIR_DOWN, K.DIR_DOWN, rng.randrange(8))),
              y=rng.choice((0xB0, 0x80, 0x64, 0x60, r.get('y'))))
    elif t == 0x53:
        r.set(sprite_base=rng.randrange(0x200))
    elif t in (0x63, 0x65):
        r.set(sprite=rng.choice((0xE7, 0xE8, 0xE9, 0xEA, 0xEB, 0xEC)), x=rng.choice((0x5E, 0x5C, 0x62, r.get('x'))))
    elif t in (0x85, 0x73, 0x74, 0x19, 0x83):
        r.set(direction=rng.choice((K.DIR_LEFT, K.DIR_RIGHT, K.DIR_RIGHT, K.DIR_DOWN)))
    elif t == 0x93:
        r.set(entry_delay=rng.choice((0, 0, 1, 2)), blocked_climbs=rng.choice((0, 0x62, 0x63, 0x64, 5)),
              direction=rng.randrange(8))
        if rng.randrange(2): w.word('LeaderScriptCursor', s('LeaderScript7DEnd'))
        if rng.randrange(3) == 0: r.set(y=rng.choice((0x18, 0x20, 0x21, 0x22, 0x23, 0x7F, 0xCF, 0xD0)))
        if rng.randrange(3) == 0: w.word('RecordTickCounter', rng.choice((0xFF, 0x1FF, 0, 0x2BD)))
    elif t == 0x92:
        if rng.randrange(2): p.set(y=((r.get('y') + 0x14) & 0xFFFC) + rng.randrange(4))
    elif t == 0x6F:
        p.set(y=r.get('y') + rng.choice((0x1F, 0x20, 0x21, 0x40, -4)))
    elif t == 0x12:
        r.set(field_36=s('Type41Path') + 4 * rng.randrange(6))
    elif t == 0x0A:
        r.set(target=w.slot('PoolA', rng.randrange(POOLS['PoolA'])), size_class=0)
    elif t in (0x13, 0x15, 0x1C, 0x1F, 0x7D, 0x7E):
        w.word('LeaderScriptCursor', s('LeaderScript13'))
    elif t == 0x84:
        r.set(direction=rng.choice((0, 2, 4, 6)))
    elif t in (0x76, 0x77, 0x78, 0x79):
        w.word('SegBossActive', 1)
        for name in ('SegBossAnchor', 'SegBossPart77', 'SegBossCore', 'SegBossPart79'):
            w.word(name, w.slot('PoolA', rng.randrange(POOLS['PoolA'])))
    if t in CRAWLERS or t in (0x33, 0x3D, 0x93) or rng.randrange(4) == 0:
        walkers(w, r, wild=False)     # (95h, past RunTypeHandler's table, only when never updated)
    return r

def w_word(w, name):
    for at, d in w._writes.items():
        if at == w.sym(name) and len(d) >= 2: return d[0] | d[1] << 8
    p = w.pair.a.pristine; o = w.sym(name)
    return p[o] | p[o + 1] << 8

def pools(w, rng, busy=None):
    """Other pool A records (enemies of any family, stale free slots) around the entry."""
    for i in range(POOLS['PoolA']):
        r = w.record('PoolA', i)
        if r.at in w._records and r.get('status'): continue
        if rng.randrange(3) == 0 if busy is None else rng.random() < busy:
            r.live(kind=K.KIND_ENEMY, type=rng.choice(OWN_TYPES + (0x12, 0x14, 0x21)))
        else: r.randomize().free()

# ---- direct cases --------------------------------------------------------------------------

def cases(rng, scale, pair):
    s = pair.sym
    n = 30 * scale
    # Every REC_TYPE through RunTypeHandler (the C handlers and the dispatch to ASM ones).
    for i in range(n):
        for t in ALL_TYPES:
            w = world(pair, rng)
            if t in (0x21,): w.word('LevelIndex', rng.choice((0, 1, 2, 3, 4, 5)))
            r = enemy(w, t, pool='PoolB' if t < 0x10 and t not in (0, 1) else 'PoolA')
            if t == 0x21 and rng.randrange(2): pools(w, rng, busy=rng.choice((0, 0.1, 1.0)))
            yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name=f'type {t:02X} #{i}')
    for i in range(n * 4):
        w = world(pair, rng)
        r = w.record('PoolA', rng.randrange(POOLS['PoolA'])).live(kind=K.KIND_PICKUP, type=0, size=1)
        r.set(item_index=rng.randrange(5))
        p = w.record('PrimaryRecord', 0)
        if rng.randrange(2): r.set(x=p.get('x') + rng.randrange(-0x14, 0x15), y=p.get('y') + rng.randrange(-0x14, 0x14))
        yield Case('UpdatePickup', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    # The bridge entries with their register contracts.
    for i in range(n * 4):
        w = world(pair, rng)
        at = s('CreditRandomWords') + rng.randrange(-2, 31, 2)
        w.word('RandomWordCursor', at)
        yield Case('NextRandomWord', regs(rng), w.writes(), keep('BX'), outputs=('BX',), name=f'#{i}')
    for i in range(n * 4):
        w = world(pair, rng)
        r = enemy(w, rng.choice(OWN_TYPES + (0x78, 0x80, 0x8B)))
        if rng.randrange(8) == 0: r.set(status=0)          # a free firer: the shot may take its slot
        yield Case('SpawnAimedShot', regs(rng, BP=r.at), w.writes(), ('SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'),
                   outputs=('BX',), name=f'#{i}')
    for i in range(n * 8):
        w = world(pair, rng)
        r = enemy(w, rng.choice(OWN_TYPES + (0x87, 0x8F, 0x2D, 0x71, 0x40, 0x68, 0x92, 0x92)))
        if rng.randrange(8) == 0: r.set(status=0)
        w.word('DifficultySetting', rng.choice((0, 1, 2, 3)))
        label = rng.choice(('SpawnThrottledChild', 'SpawnThrottledChild', 'SpawnShotDown'))
        yield Case(label, regs(rng, BP=r.at), w.writes(), ('DX', 'SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'),
                   outputs=('BX',), name=f'#{i}')
    for i in range(n * 8):
        w = world(pair, rng)
        r = enemy(w, rng.choice(CRAWLERS + (0x33, 0x93)))
        r.set(direction=i % 8)
        if i % 16 >= 8:
            w.word('ScrollSubRow', 0).word('ScrollDeltaY', 0)
            r.set(x=16 * rng.randrange(1, 12) + rng.choice((0, 0x0F)), y=16 * rng.randrange(1, 12) + rng.choice((0, 0x0F)))
        yield Case('TryTerrainStep', regs(rng, BP=r.at), w.writes(), LOOP, flags=('ZF',), name=f'dir {i % 8} #{i}')
    for i in range(n * 4):
        w = world(pair, rng)
        r = enemy(w, rng.choice(OWN_TYPES + (0x33, 0x12, 0x80, 0x8B, 0x1A)), pool=rng.choice(('PoolA', 'PoolB')))
        label = rng.choice(('ScrollRecordThenFinish', 'FinishRecordUpdate', 'HorizontalTerrainPatrol'))
        yield Case(label, regs(rng, BP=r.at), w.writes(), LOOP, name=f'#{i}')
    yield from quirks(pair)
    for i in range(10 * scale):
        yield sequence(rng, pair, i)

def regs(rng, **fixed):
    r = {n: rng.randrange(0x10000) for n in ('AX', 'BX', 'CX', 'DX', 'SI', 'DI')}
    r.update(fixed); return r

def sequence(rng, pair, i):
    """UpdateAllRecords / TickFrameTimers over a world of this region's types."""
    w = world(pair, rng)
    w.word('LevelIndex', i % K.LEVEL_COUNT)
    family = (TURRETS, DESCENDERS, CRAWLERS, FORMATION, DIRECTOR + INVADERS + HATCH + SWEEPER, OWN_TYPES)[i % 6]
    for k in range(POOLS['PoolA']):
        if rng.randrange(3): enemy(w, rng.choice(family), index=k)
        else: w.record('PoolA', k).randomize().free()
    for k in range(POOLS['PoolB']):
        r = w.record('PoolB', k)
        if rng.randrange(4) == 0: r.live(kind=K.KIND_TYPED, type=rng.choice((2, 3, 4, 0x0B)), size=0, player_shot=rng.randrange(2),
                                         field_1c=rng.choice((1, 5, 30, 0xFFFF)))
        else: r.randomize().free()
    steps = [Case('UpdateAllRecords', {}, w.writes(), LOOP, name=f'world {i} frame 0')]
    for f in range(1, rng.choice((4, 8, 16))):
        steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'world {i} tick {f}'))
        steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'world {i} frame {f}'))
    return steps

def quirks(pair):
    """Documented original behaviour, asserted on the oracle, then compared."""
    s = pair.sym
    a0, b0 = s('PoolA') + RECORD * 5, s('PoolB') + RECORD * 3
    def base():
        w = World(pair, __import__('random').Random(7)).plausible()
        w.word('LevelIndex', 1).word('DifficultySetting', 0).byte('ChildSpawnThrottle', 0).word('LevelEndPhase', 0)
        w.word('ScrollDeltaY', 0).byte('SfxEnabled', 0)
        p = w.record('PrimaryRecord', 0).set(x=0x10, y=0xB0)
        return w

    # Types 24h/25h, throttled: the shot sprite 1Eh goes through RunTypeHandler's BX = REC_TYPE
    # * 2 = 48h, i.e. the word at DS:50h.
    w = base(); w.word('FrameCount32', 0x1F).put(0x50, W(0x1234))
    r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=0x24, size=1, x=0x40, y=0x40)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='type 24h stale BX',
               expect=lambda m, regs: check(m.word(0x50) == 0x1E, 'type 24h writes sprite 1Eh at DS:50h'))
    # Type 18h, throttled after a 1/8 roll: DIR_DOWN goes to DS:2 + REC_DIRECTION = DS:8.
    w = base(); w.word('RecordTickCounter', 0x100).put(8, W(0x1234))
    at = s('SweepPath')
    mem = pair.a.pristine
    r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=0x18, size=1)
    r.set(path=at, y=(mem[at] | mem[at + 1] << 8) + 0x20, x=mem[at + 2] | mem[at + 3] << 8)
    for cur in range(16):           # find a random-word position whose next word & 7 is 2
        c = s('CreditRandomWords') + 2 * cur
        v = mem[c + 2] | mem[c + 3] << 8 if cur < 15 else mem[s('CreditRandomWords')] | mem[s('CreditRandomWords') + 1] << 8
        if v & 7 == 2: break
    w.word('RandomWordCursor', c)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='type 18h stale BX = 2',
               expect=lambda m, regs: check(m.word(8) == K.DIR_DOWN, 'type 18h writes DIR_DOWN at DS:8'))
    # Type 57h: only the second terrain step is tested; at Y 80h exactly the sprite goes up.
    # A blocked crawler is destroyed without the scroll tail.
    w = base(); install_map(pair); terrain(w, 1.0)
    r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=0x57, size=1, x=0x40, y=0x80, sprite=0x100, direction=K.DIR_RIGHT)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='type 57h at Y 80h',
               expect=lambda m, regs: check(m.word(r.at + 8) == 0x101, 'sprite + 1 at Y 80h'))
    # FinishRecordUpdate: the bottom bound is signed F0h; the top -C0h, or -14h for the exempt
    # types (26h here) and during the level end.
    for t, y, phase, gone in ((0x27, 0xFF40, 0, False), (0x27, 0xFF3F, 0, True), (0x26, 0xFFEC, 0, False),
                               (0x26, 0xFFEB, 0, True), (0x27, 0xFFEB, 1, True), (0x27, 0xEF, 0, False), (0x27, 0xF0, 0, True)):
        w = base(); w.word('LevelEndPhase', phase)
        r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=t, size=1, x=0x40, y=y)
        yield Case('FinishRecordUpdate', {'BP': r.at}, w.writes(), LOOP, name=f'bounds type {t:X} Y {y:04X} phase {phase}',
                   expect=lambda m, regs, at=r.at, gone=gone: check((m.word(at) == 0) == gone, 'finish bounds'))
    # Type 93h stuck at the centre: a blocked third climb step at X 60h resets the climb count
    # (ZF of Type93BlockedTurnUp's compare), so it is never removed.
    w = base(); install_map(pair); terrain(w, 0.0)
    w.word('LeaderScriptCursor', s('LeaderScript7DEnd'))
    r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=0x93, size=1, x=0x60, y=0x60, direction=K.DIR_UP,
                                  entry_delay=0, blocked_climbs=0x63)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='type 93h at X 60h never removed',
               expect=lambda m, regs: check(m.word(r.at) == 1 and m.word(r.at + 0x36) == 0, 'climb count reset at X 60h'))
    # SpawnThrottledChild, throttled at difficulty 1: BX comes back unchanged.
    w = base(); w.word('DifficultySetting', 1).byte('ChildSpawnThrottle', 1)
    r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=0x30, size=1, x=0x40, y=0x40)
    yield Case('SpawnThrottledChild', {'BP': r.at, 'BX': 0x4321}, w.writes(), ('DX', 'SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'),
               outputs=('BX',), name='throttled keeps BX', expect=lambda m, regs: check(regs['BX'] == 0x4321, 'BX kept'))
    # The child's effect gate: none when the child's Y < 8 or the parent's Y > E0h (unsigned).
    for py, sfx in ((0xE0, True), (0xE1, False), (4, True), (3, False), (0xFFFF, False)):
        w = base(); w.word('DifficultySetting', 2).byte('SfxEnabled', 1).byte('SfxRequest', 0)
        r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=0x30, size=1, x=0x40, y=py)
        yield Case('SpawnThrottledChild', {'BP': r.at, 'BX': 0}, w.writes(), ('DX', 'SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'),
                   outputs=('BX',), name=f'effect gate parent Y {py:04X}',
                   expect=lambda m, regs, sfx=sfx: check((m.read(s('SfxRequest'), 1) == b'\x0b') == sfx, 'child effect gate (type 30h: sfx 0Bh)'))
    # Type 4Fh: the sprite adds the record address (PoolA & 7 for every slot).
    w = base(); w.word('FrameCount8', 3).word('RecordTickCounter', 0x11)
    r = w.record('PoolA', 5).live(kind=K.KIND_ENEMY, type=0x4F, size=1, x=0x40, y=0x40)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='type 4Fh address in sprite',
               expect=lambda m, regs: check(m.word(r.at + 8) == 0x80 + ((3 + r.at + 0x11) & 7), 'sprite from address'))

# ---- mutants -------------------------------------------------------------------------------

MUTANTS = [
    # bounds: the bottom limit is F0h exclusive
    ('enemies.c', 'if ((sword)r->y < (sword)0xFF40 || (sword)r->y >= 0xF0) {', 'if ((sword)r->y < (sword)0xFF40 || (sword)r->y > 0xF0) {'),
    # signedness: type 39h waits for Y 80h signed
    ('enemies.c', '    if ((sword)r->y >= 0x80) {\r\n        if (r->y == 0x80 && SfxEnabled != 0) SfxRequest = 0x0B;',
                  '    if (r->y >= 0x80) {\r\n        if (r->y == 0x80 && SfxEnabled != 0) SfxRequest = 0x0B;'),
    # the stale BX of a throttled spawn
    ('enemies.c', '            if (ChildSpawnThrottle == 0) return bx;', '            if (ChildSpawnThrottle == 0) return 0xFFFF;'),
    # Type93BlockedTurnUp's ZF result
    ('enemies.c', '    zf = 1;\r\n    if (try_terrain_step(r)) zf = type93_blocked_turn_up(r);',
                  '    zf = 1;\r\n    if (try_terrain_step(r)) zf = (type93_blocked_turn_up(r), 0);'),
    # post-increment of the shared tick counter
    ('enemies.c', '                c->faller_variant = tick & 3;', '                c->faller_variant = RecordTickCounter & 3;'),
    # wrong dispatch
    ('enemies.c', '    case 0x5E: type5e_crawl_turn_down_to_left(r); break;', '    case 0x5E: type5f_crawl_turn_diagonal_down(r); break;'),
    # off by one in the child effect gate
    ('enemies.c', '    if (c->y < 8 || parent->y > 0xE0) return c;', '    if (c->y < 8 || parent->y >= 0xE0) return c;'),
    # a DestroyRecord tail that must skip the scroll tail
    ('enemies.c', '        if (try_terrain_step(r)) {\r\n            destroy_record(r);\r\n            return;\r\n        }\r\n    }\r\n    scroll_record_then_finish(r);\r\n}\r\n\r\n/* Sprite base',
                  '        if (try_terrain_step(r)) destroy_record(r);\r\n    }\r\n    scroll_record_then_finish(r);\r\n}\r\n\r\n/* Sprite base'),
    # wrong allocation pool
    ('enemies.c', '    Record *c = find_free_record_pool_b();\r\n\r\n    if (c == NO_RECORD) return c;\r\n    c->x = parent->x + 0x0C;',
                  '    Record *c = find_free_record_pool_a();\r\n\r\n    if (c == NO_RECORD) return c;\r\n    c->x = parent->x + 0x0C;'),
    # omitted side effect: the dive tick
    ('enemies.c', 'goto set_sprite;\r\n            RecordTickCounter++;', 'goto set_sprite;\r\n'),
    # bridge preservation (AX) and the ZF result
    ('enemies.asm', 'NextRandomWord:\r\n    push ax\r\n    call NEXT_RANDOM_WORD\r\n    mov bx, ax\r\n    pop ax\r\n',
                    'NextRandomWord:\r\n    call NEXT_RANDOM_WORD\r\n    mov bx, ax\r\n'),
    ('enemies.asm', 'TryTerrainStep:\r\n    push si\r\n    mov si, bp\r\n    call TRY_TERRAIN_STEP\r\n    pop si\r\n    cmp ax, 0\r\n',
                    'TryTerrainStep:\r\n    push si\r\n    mov si, bp\r\n    call TRY_TERRAIN_STEP\r\n    pop si\r\n    cmp ax, 1\r\n'),
]

# ---- fuzz targets --------------------------------------------------------------------------

from fuzz import Target

def _single_seed(rtype, levels=range(K.LEVEL_COUNT)):
    def seed(w):
        rng = w.rng
        world(w.pair, rng, w)
        w.word('LevelIndex', _next(f'level {rtype:X}', levels))
        if rng.randrange(2): pools(w, rng)
        return {'BP': enemy(w, rtype).at}
    return seed

def _family_seed(types, pool='PoolA'):
    def seed(w):
        rng = w.rng
        world(w.pair, rng, w)
        w.word('LevelIndex', _next(f'level {types[0]:X}', range(K.LEVEL_COUNT)))
        if rng.randrange(2): pools(w, rng)
        r = enemy(w, _next(f'types {types[0]:X}', types), pool=pool)
        return {'BP': r.at}
    return seed

def _pickup_seed(w):
    rng = w.rng
    world(w.pair, rng, w)
    r = w.record('PoolA', rng.randrange(POOLS['PoolA'])).live(kind=K.KIND_PICKUP, type=0, size=1)
    r.set(item_index=rng.randrange(5))
    p = w.record('PrimaryRecord', 0)
    if rng.randrange(3): r.set(x=p.get('x') + rng.randrange(-0x12, 0x13), y=p.get('y') + rng.randrange(-0x12, 0x12))
    return {'BP': r.at}

def _child_seed(w):
    rng = w.rng
    world(w.pair, rng, w)
    w.word('DifficultySetting', _next('child difficulty', (0, 1, 2, 3)))
    r = enemy(w, _next('child types', CHILD_PARENTS))
    return {'BP': r.at, 'BX': rng.randrange(0x10000)}
CHILD_PARENTS = OWN_TYPES + (0x82, 0x8A, 0x8C, 0x8D, 0x8E, 0x92)

def _director_seed(w):
    rng = w.rng
    world(w.pair, rng, w)
    level = _next('director level', range(K.LEVEL_COUNT))
    w.word('LevelIndex', level)
    pools(w, rng, busy=_next('director fill', (0, 0.05, 0.5, 1.0)))
    r = enemy(w, 0x21)
    if rng.randrange(3) == 0:
        w.word('InvaderSlotCursor', w.sym('InvaderFormationEnd'))
    return {'BP': r.at}

def _word_at(pair, at): return pair.a.pristine[at] | pair.a.pristine[at + 1] << 8

def _cursor_before(w, want):
    """A RandomWordCursor whose next NextRandomWord satisfies want(word)."""
    base = w.sym('CreditRandomWords')
    for k in range(-1, 15):
        nxt = base + 2 * k + 2
        if nxt >= base + 31: nxt = base
        if want(_word_at(w.pair, nxt)): return base + 2 * k
    raise ValueError('no random word matches')

def _edge_states():
    """Single rare states: each builder returns the entry record after setting up the world."""
    def pool_b_full_turret(w):
        w.fill('PoolB', 34); w.word('FrameCount32', 0x1F).word('DifficultySetting', 2)
        return enemy(w, w.rng.choice((0x24, 0x25)))
    def sink_rise_turn(w):
        return enemy(w, 0x4D).set(direction=K.DIR_DOWN, y=0x80)
    def hopper_random_shot(w):
        r = enemy(w, 0x20).set(dive_phase=0xFFFF)
        r.set(saved_x=r.get('x'), saved_y=r.get('y'))
        w.word('EncounterTicks', 0x40).word('RecordTickCounter', w.rng.choice((0x2BC, 0x2C8, 0x2D0)))
        w.word('EncounterLiveCount', 8).word('RandomWordCursor', _cursor_before(w, lambda v: v & 1 == 0))
        w.fill('PoolB', w.rng.choice((0, 10)))
        return r
    def slot_bob_arrival(w):
        r = enemy(w, 0x1D).set(x=0x40, y=0x40, saved_x=0x40, saved_y=0x40)
        w.word('EncounterTicks', 0x10).word('EncounterLiveCount', 5)
        return r
    def sweep_child(w):
        at = w.sym('SweepPath') + 4 * w.rng.randrange(20)
        r = enemy(w, 0x18).set(path=at, y=_word_at(w.pair, at) + 0x20, x=_word_at(w.pair, at + 2))
        w.word('RecordTickCounter', 0x100).word('DifficultySetting', w.rng.choice((0, 2)))
        w.word('RandomWordCursor', _cursor_before(w, lambda v: v & 7 == 2))
        w.fill('PoolB', w.rng.choice((0, 10, 34)))
        return r
    def sway_dive_tick(w):
        r = enemy(w, 0x14).set(x=0x40, y=0x40, saved_x=0x40, saved_y=0x40)
        w.word('LeaderScriptCursor', w.sym('LeaderScript13End')).word('SwayDropY', 0)
        w.word('EncounterLiveCount', 8).word('DifficultySetting', w.rng.choice((0, 1, 2)))
        w.word('RecordTickCounter', w.rng.choice((0xFF, 0x1FF, 0x7F, 0x17F)))
        return r
    return (pool_b_full_turret, sink_rise_turn, hopper_random_shot, slot_bob_arrival, sweep_child, sway_dive_tick)
EDGE_STATES = _edge_states()

def _edge_seed(w):
    rng = w.rng
    world(w.pair, rng, w)
    w.word('LevelIndex', rng.choice((1, 2, 5)))
    return {'BP': _next('edge', EDGE_STATES)(w).at}

def _slots(pair): return range(pair.sym('PoolA'), pair.sym('PoolA') + RECORD * POOLS['PoolA'], RECORD)
def _cursor(first, end, step):
    return lambda pair: range(pair.sym(first), pair.sym(end) + 1, step)
# Preconditions (the game never stores other values): REC_TYPE 0..94h (RunTypeHandler's table),
# REC_DIRECTION 0..7 (movement and terrain step tables; the hatch uses it as its 0..17h ramp
# phase), REC_SIZE_CLASS 0..2, REC_SLOT_INDEX FFFFh or 0..15, REC_ITEM_INDEX 0..4 (pickups),
# the counters in their ranges (tables indexed by SlowCount4, FrameCount8/64/128), LevelIndex
# < LEVEL_COUNT, and the table cursors on their tables' entries.
DOMAINS = {
    'direction': range(8), 'size_class': range(3), 'slot_index': (0xFFFF,) + tuple(range(16)), 'item_index': range(5),
    'LevelIndex': range(K.LEVEL_COUNT), 'DifficultySetting': range(3), 'LevelEndPhase': range(5),
    'FrameCount4': range(4), 'FrameCount8': range(8), 'FrameCount16': range(16), 'FrameCount32': range(32),
    'FrameCount64': range(64), 'FrameCount128': range(128), 'FrameParity': range(2), 'SlowCount4': range(4),
    'SlowCount5': range(5), 'SlowCount6': range(6), 'SlowCount8': range(8), 'FrameDivider4': range(4),
    'ScrollDeltaY': range(4), 'ScrollSubRow': range(16), 'SteerSpeed': range(4), 'ChaseStepPixels': (2, 3),
    'RandomWordCursor': lambda pair: range(pair.sym('CreditRandomWords') - 2, pair.sym('CreditRandomWords') + 31, 2),
    'PoolBCursor': lambda pair: range(pair.sym('PoolB'), pair.sym('PoolB') + RECORD * (POOLS['PoolB'] + 1), RECORD),
    'PoolACursor': _slots,
    'FormationSlotCursor': _cursor('FormationSlots', 'FormationSlotsEnd', 4),
    'FallerColumnCursor': _cursor('FallerColumns', 'FallerColumnsEnd', 2),
    'InvaderSlotCursor': _cursor('InvaderFormation', 'InvaderFormationEnd', 4),
}
GLOBALS = ('LevelIndex', 'DifficultySetting', 'SfxEnabled', 'ScrollDeltaY', 'FrameCount4', 'FrameCount8', 'FrameCount16',
           'FrameCount32', 'FrameCount64', 'FrameCount128', 'FrameParity', 'RecordTickCounter', 'EncounterTicks',
           'EncounterLiveCount', 'LevelEndPhase', 'SegBossActive', 'ChildSpawnThrottle', 'PoolBCursor')
def _dom(types, **extra):
    d = dict(DOMAINS, type=types)
    d.update(extra); return d
def in_domain(seed, domains):
    """Seed builder whose every record meets the record-field preconditions in `domains` (the
    fuzzer copies whole records onto the entry record, so stale ones must meet them too)."""
    def build(w):
        regs = seed(w)
        for r in w._records.values():
            for field, values in domains.items():
                if field not in FIELDS: continue
                values = tuple(values(w.pair) if callable(values) else values)
                if r.get(field) not in values: r.set(**{field: w.rng.choice(values)})
        return regs
    return build

def target(name, entry, seed, domains, **kw):
    seeds = max(24, 4 * len(kw.get('types', ())))
    return Target(name, entry, in_domain(seed, domains), REGION, kw.pop('preserve', LOOP), pin_bp=True,
                  domains=domains, seeds=seeds, **kw)

WALKERS = (0x82, 0x89, 0x8B, 0x8E, 0x94, 0x81)     # ProbeOverlapsWalker's types 82h..94h (and one outside)
MAP_ROWS = range(0, K.MAP_END_POS + 1, K.MAP_ROW_BYTES)
FUZZ = [
    target('enemies_turrets', 'RunTypeHandler', _family_seed(TURRETS), _dom(TURRETS), types=TURRETS,
           globals=GLOBALS + ('SlowCount4',), watch=('ChildSpawnThrottle',)),
    target('enemies_descenders', 'RunTypeHandler', _family_seed(DESCENDERS), _dom(DESCENDERS), types=DESCENDERS,
           globals=GLOBALS + ('SlowCount4', 'SlowCount6', 'SlowCount8', 'RandomWordCursor', 'SteerSpeed', 'DescentTargetX')),
    target('enemies_crawlers', 'RunTypeHandler', _family_seed(CRAWLERS), _dom(CRAWLERS + WALKERS, MapScrollPos=MAP_ROWS),
           types=CRAWLERS, globals=GLOBALS + ('SlowCount4', 'SlowCount5', 'SlowCount8', 'MapScrollPos', 'ScrollSubRow'),
           watch=('TerrainBlocked',)),
    target('enemies_formation', 'RunTypeHandler', _family_seed(FORMATION),
           _dom(FORMATION, field_1c=(0xFFFF, 0, 1, 2),
                field_36=lambda pair: range(pair.sym('SweepPathLeadIn'), pair.sym('LeaderScript7D'), 4)),
           types=FORMATION, globals=GLOBALS + ('SwayDirX', 'SwayDropY', 'LeaderScriptCursor', 'FormationSlotCursor',
                                               'SteerSpeed', 'SlowCount4', 'SlowCount6', 'RandomWordCursor')),
    target('enemies_director', 'RunTypeHandler', _director_seed, _dom(DIRECTOR + (0x14, 0x12, 0x26, 0x30), field_1c=range(4)),
           types=DIRECTOR, globals=GLOBALS + ('InvaderSlotCursor', 'FallerColumnCursor', 'PoolACursor', 'SlowCount8'),
           watch=('EncounterLiveCount', 'SegBossActive')),
    target('enemies_faller', 'RunTypeHandler', _single_seed(0x23, (1, 2, 3, 5)), _dom((0x23, 0x2C), field_1c=range(4)),
           types=(0x23,), globals=GLOBALS + ('SlowCount8', 'SteerSpeed')),
    target('enemies_invaders', 'RunTypeHandler', _family_seed(INVADERS), _dom(INVADERS), types=INVADERS,
           globals=GLOBALS + ('FramesSinceInvaderSpawn', 'InvaderDropStep', 'InvaderMarchLeft', 'RandomWordCursor')),
    target('enemies_hatch', 'RunTypeHandler', _family_seed(HATCH), _dom(HATCH, direction=range(0x18)), types=HATCH,
           globals=GLOBALS + ('FrameDivider4', 'PoolACursor')),
    target('enemies_sweeper', 'RunTypeHandler', _family_seed(SWEEPER),
           _dom(SWEEPER + WALKERS, MapScrollPos=MAP_ROWS,
                LeaderScriptCursor=lambda pair: (pair.sym('LeaderScript7DEnd'), pair.sym('LeaderScript7D'))),
           types=SWEEPER, globals=GLOBALS + ('LeaderScriptCursor', 'Type93KilledPulse', 'MapScrollPos')),
    target('enemies_edges', 'RunTypeHandler', _edge_seed, _dom(OWN_TYPES, field_1c=(0xFFFF, 0, 1, 2),
           field_36=lambda pair: range(pair.sym('SweepPathLeadIn'), pair.sym('LeaderScript7D'), 4)),
           globals=GLOBALS + ('RandomWordCursor',)),
    target('enemies_misc', 'RunTypeHandler', _family_seed(MISC), _dom(MISC), types=MISC, globals=GLOBALS),
    target('enemies_pickup', 'UpdatePickup', _pickup_seed, _dom((0, 0x14, 0x26)), globals=GLOBALS),
    target('enemies_child', 'SpawnThrottledChild', _child_seed, _dom(CHILD_PARENTS),
           preserve=('DX', 'SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'), outputs=('BX',), globals=GLOBALS,
           watch=('ChildSpawnThrottle',)),
]
