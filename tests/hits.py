"""Shot-hit region (c/hits.c): player shots hitting records, damage, DestroyRecord, drops,
explosions, encounter bookkeeping, smart bomb and the descend-then-burst handlers.

Entries are the oracle labels the remaining ASM reaches (the bridge c/hits.asm) and their
real ASM callers (FinishRecordUpdate, CheckRecordHitsPlayer, DestroyRecordAtBX, RemoveRecord,
SmartBombAll, SpawnCellFuelPickup, the type handlers). Register contracts are the oracle's:
the registers listed are the ones it keeps; the rest are scratch for that routine.
"""
from difftest import Case, ALL_REGS
from world import World, K, RECORD
import struct

LOOP = ('BP', 'SP', 'DS', 'SS')
# Registers DestroyRecord, SmartBombRecord and ReleaseEncounterMember leave alone in the oracle.
KEEPS = ('DX', 'DI', 'ES') + LOOP
SEG_BOSS_PARTS = ('SegBossAnchor', 'SegBossPart77', 'SegBossCore', 'SegBossPart79')
LEADERS = (0x13, 0x15, 0x1C, 0x1F, 0x7D, 0x7E)
COUNTED = (0x61, 0x62, 0x65, 0x14, 0x16, 0x17, 0x18, 0x7F, 0x80, 0x81, 0x1D, 0x1E, 0x20, 0x21, 0x22)
ENEMY_TYPES = LEADERS + COUNTED + (0x76, 0x77, 0x78, 0x79, 0x93, 0x26, 0, 1, 0x30, 0x48, 0x35, 0x36, 0x12)
SHOT_TYPES = (2, 2, 5, 6, 7, 8, 9, 0x0A, 0x0C, 3, 4, 0x0B)

def keep(*scratch): return tuple(r for r in ALL_REGS if r not in scratch)

def world(rng, pair, seg_boss=None, w=None):
    """A mid-game world: player, counters, difficulty, groups, encounter state and (maybe)
    a segmented boss whose four parts are live pool A records."""
    w = (w or World(pair, rng)).plausible()
    w.word('DifficultySetting', rng.choice((0, 1, 2, 2, 3)))
    w.word('LevelIndex', rng.choice((0, 4, rng.randrange(K.LEVEL_COUNT))))
    w.word('SwayDirX', rng.choice((1, 0, 0xFFFF, 1)))
    w.word('EncounterLiveCount', rng.randrange(6))
    groups = bytearray(32)
    for g in range(16): groups[2 * g] = rng.choice((0, 1, 1, 2, 5)); groups[2 * g + 1] = rng.randrange(5)
    w.put('GroupTable', groups)
    w.byte('SfxRequest', 0)
    if seg_boss is None: seg_boss = rng.randrange(4) == 0
    w.word('SegBossActive', 1 if seg_boss else rng.choice((0, 0, 2)))
    parts = rng.sample(range(K.POOL_A_COUNT), 4)
    for name, i, t in zip(SEG_BOSS_PARTS, parts, (0x76, 0x77, 0x78, 0x79)):
        w.word(name, w.slot('PoolA', i))
        if seg_boss: w.record('PoolA', i).live(kind=K.KIND_ENEMY, type=t, size=2, slot_index=0xFFFF)
    return w

def enemy(w, index=None, **fields):
    rng = w.rng
    if index is None: index = rng.randrange(K.POOL_A_COUNT)
    r = w.record('PoolA', index).live(kind=K.KIND_ENEMY, type=rng.choice(ENEMY_TYPES), size=rng.choice((0, 1, 1, 2, 2)))
    r.set(y=rng.choice((rng.randrange(0x10, 0xF0),) * 6 + (0xFFF0, 0xFFE9, 0x1F, 0x20)),
          x=rng.choice((rng.randrange(0, 0xC8),) * 5 + (0xFFF8, 0xC4)), hit_points=rng.choice((1, 2, 3, 4, 5, 8, 0, 0xFFFF)),
          slot_index=rng.choice((0xFFFF, 0xFFFF, rng.randrange(16))))
    return r.set(**fields)

def shots_near(w, r, count, types=SHOT_TYPES):
    """`count` live player shots in random pool B slots, around r's 8-px cell."""
    rng = w.rng
    slots = rng.sample(range(K.POOL_B_COUNT), count)
    for i in range(K.POOL_B_COUNT):
        if i not in slots: w.record('PoolB', i).randomize().free()
    for i in slots:
        s = w.record('PoolB', i).live(kind=K.KIND_TYPED, type=rng.choice(types), size=0)
        s.set(x=(r.get('x') & ~7) + rng.randrange(-12, 30), y=(r.get('y') & ~7) + rng.randrange(-12, 30),
              player_shot=rng.choice((1, 1, 1, 0)), sprite=rng.choice((0x33, 0x32, 0x33, 0x20)),
              target=rng.choice((r.at, r.at, w.slot('PoolA', rng.randrange(K.POOL_A_COUNT)))))
        if rng.randrange(8) == 0: s.set(status=0)
    return slots

def cases(rng, scale, pair):
    s = pair.sym
    n = 500 * scale
    for i in range(n):
        w = world(rng, pair)
        r = enemy(w, kind=rng.choice((K.KIND_ENEMY,) * 6 + (K.KIND_SCENERY, K.KIND_PICKUP, K.KIND_TYPED)))
        shots_near(w, r, rng.choice((1, 2, 4, 12, 34)))
        if i % 16 == 0: r.set(status=0)
        yield Case('PlayerShotsHitRecord', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        r = enemy(w)
        if rng.randrange(3) == 0: w.fill('PoolA', K.POOL_A_COUNT)             # no slot for the drop
        yield Case('DestroyRecord', {'BP': r.at}, w.writes(), KEEPS, name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        r = enemy(w, type=rng.choice(LEADERS + (0x76, 0x78, 0x93, 0x14, 1, 0x30)))
        yield Case('ReleaseEncounterMember', {'BP': r.at}, w.writes(), keep('AX', 'BX', 'CX', 'SI'), name=f'#{i}')
        # through RemoveRecord: a leader's drop may take the record's own freed slot
        w.word('PoolACursor', r.at if rng.randrange(2) else w.slot('PoolA', 0))
        yield Case('RemoveRecord', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        r = enemy(w, y=rng.choice((0xE0, 0xE1, 0x40, 0xFFF0)))
        yield Case('SmartBombRecord', {'BP': r.at}, w.writes(), KEEPS, name=f'#{i}')
    for i in range(n // 5):
        w = world(rng, pair)
        for k in range(K.POOL_A_COUNT):
            if rng.randrange(3): enemy(w, k)
            else: w.record('PoolA', k).randomize().free()
        yield Case('SmartBombAll', {}, w.writes(), LOOP, name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        r = w.record('PoolA', rng.randrange(K.POOL_A_COUNT)).randomize()
        r.set(x=rng.choice((0, 1, 0xBF, 0xC0, 0xC1, 0x7FFF, 0x8000, 0xFFFF, rng.randrange(0x10000))))
        yield Case('ClampRecordX', {'BP': r.at, 'AX': rng.randrange(0x10000)}, w.writes(), ALL_REGS, name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        at = w.record(rng.choice(('PoolA', 'PoolB')), rng.randrange(K.POOL_B_COUNT)).randomize().at
        w.word('DropKind', rng.choice((0, 1, 2, 4, 0xFFFF, rng.randrange(0x10000))))
        yield Case('InitPickupRecord', {'BX': at, 'SI': rng.randrange(0x10000)}, w.writes(), keep('SI'), outputs=('SI',), name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        if rng.randrange(3) == 0: w.fill('PoolA', K.POOL_A_COUNT)
        w.word('MapCellX', rng.randrange(0, 0xD0, 0x10))
        regs = {'ES': 0xB800, 'SI': rng.randrange(0x100, 0x1000), 'AX': 0xF9}
        yield Case('SpawnCellFuelPickup', regs, w.writes(), ('DI', 'BP', 'SP', 'DS', 'SS'), outputs=('SI',), name=f'#{i}')
    for i in range(n):
        w = world(rng, pair)
        t = rng.choice((0x22, 0x35, 0x36))
        r = enemy(w, type=t, y=rng.choice((0x9E, 0x9F, 0xA0, 0xFFFF, rng.randrange(0x60, 0xB0))))
        if rng.randrange(3) == 0: w.fill('PoolB', rng.choice((30, 33, 34)))
        w.word('ScrollDeltaY', rng.choice((0, 1, 2)))
        handler = 'Type36FallThenBurst' if t == 0x36 else 'Type22DescendThenBurst'
        yield Case(handler, {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    # The shared tail and the contact check: ClampRecordX, CheckRecordHitsPlayer (DestroyRecord
    # on contact) and PlayerShotsHitRecord after a handler.
    for i in range(n):
        w = world(rng, pair)
        r = enemy(w)
        p = w.record('PrimaryRecord', 0)
        if rng.randrange(2): p.set(x=r.get('x') + rng.randrange(-8, 9), y=r.get('y') + rng.randrange(-8, 9))
        shots_near(w, r, rng.choice((1, 3, 8)))
        w.word('LevelEndPhase', rng.choice((0, 0, 0, 1)))
        yield Case('ScrollRecordThenFinish', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    for i in range(n // 2):
        w = world(rng, pair)
        r = enemy(w)
        yield Case('DestroyRecordAtBX', {'BX': r.at}, w.writes(), LOOP + ('BX',), name=f'#{i}')
    yield from scan_slots(rng, pair)
    yield from quirks(pair)
    yield from sequences(rng, scale, pair)

# (shot cell - record cell) on X and Y that overlap, by record size class, and misses.
HIT_DX = {1: (-8, 0, 8), 2: (-8, 0, 8, 16, 24)}
HIT_DY = {1: (0, 8), 2: (0, 8, 16, 24)}

def slot_hit(w, k, size, dx, dy, type=None):
    """Slot k of pool B overlaps the record at (dx, dy) cells; every earlier slot holds a live
    shot that overlaps on X only (or is not a player shot), later slots are free."""
    rng = w.rng
    r = enemy(w, size_class=size, y=rng.randrange(0x40, 0x90),
              type=type or rng.choice((0x14, 0x78, 0x79) if size == 2 else (0x14, 0x30)), kind=K.KIND_ENEMY)
    cx, cy = r.get('x') & ~7, r.get('y') & ~7
    for i in range(K.POOL_B_COUNT):
        s = w.record('PoolB', i)
        if i > k: s.randomize().free(); continue
        s.live(kind=K.KIND_TYPED, type=rng.choice(SHOT_TYPES), size=0, player_shot=1, target=r.at, sprite=0x20)
        if i < k:
            s.set(x=cx + rng.choice(HIT_DX[size]) * (1 if rng.randrange(4) else -3), y=cy + 40, player_shot=rng.randrange(4) != 0)
        else:
            s.set(x=cx + dx + (rng.randrange(1, 8) if dx == -8 else rng.randrange(8)), y=cy + dy + rng.randrange(8))
    return r

def scan_slots(rng, pair):
    """The unrolled scan, slot by slot, at each X offset and Y row (also the rows skipped for
    78h/79h, and a Y miss)."""
    for k in range(K.POOL_B_COUNT):
        for size in (1, 2):
            for dx in HIT_DX[size]:
                for dy in HIT_DY[size] + (32,):
                    w = world(rng, pair, seg_boss=False)
                    # tall rows always with a type that has them (78h/79h get the Y-miss row 32)
                    r = slot_hit(w, k, size, dx, dy, type=0x14 if dy in (16, 24) else None)
                    yield Case('PlayerShotsHitRecord', {'BP': r.at}, w.writes(), LOOP, name=f'slot {k} size {size} dx {dx} dy {dy}')
# Pool A types for the frame sequences: the burst handlers, counted members, a leader-less
# formation diver and chasers (handlers that are safe on randomised fields).
SEQUENCE_TYPES = (0x22, 0x35, 0x36, 0x14, 0x1D, 0x1E, 0x2E, 0x48, 0x81, 0x93, 0x21, 0x30)

def sequences(rng, scale, pair):
    """Whole frames: UpdateAllRecords (player shots fly and hit, enemies are destroyed,
    drop items, burst, release encounter members) alternating with TickFrameTimers."""
    for i in range(30 * scale):
        w = world(rng, pair)
        w.word('LevelEndPhase', 0)
        for k in range(K.POOL_A_COUNT):
            if rng.randrange(3): enemy(w, k, type=rng.choice(SEQUENCE_TYPES), y=rng.randrange(0x20, 0xA8), x=rng.randrange(0, 0xC1))
            else: w.record('PoolA', k).randomize().free()
            r = w.record('PoolA', k)
            r.set(saved_x=rng.randrange(0, 0xC1), saved_y=rng.randrange(0x10, 0xC0), direction=rng.randrange(8))
        for k in range(K.POOL_B_COUNT):
            s = w.record('PoolB', k)
            if rng.randrange(2):
                s.live(kind=K.KIND_TYPED, type=rng.choice((2, 2, 4, 3)), size=0, player_shot=1, direction=0,
                       x=rng.randrange(0, 0xC8), y=rng.randrange(0x30, 0xC8), field_1c=rng.choice((5, 30, 0xFFFF)),
                       sprite=rng.choice((0x33, 0x32)))
                if s.get('type') == 3: s.set(player_shot=0, direction=4)
            else: s.randomize().free()
        steps = [Case('UpdateAllRecords', {}, w.writes(), LOOP, name=f'world {i} frame 0')]
        for f in range(1, rng.choice((6, 10, 16))):
            steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'world {i} tick {f}'))
            steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'world {i} frame {f}'))
        yield steps

def rec(pair, **fields):
    """A zeroed record with the given fields (for deterministic quirk cases)."""
    w = World(pair, None)
    r = w.record('PoolA', 0)
    r.data[:] = bytes(RECORD)
    return bytes(r.set(**fields).data)

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented quirk: ' + what)

def quirks(pair):
    """Surprising original behaviour, asserted on the oracle, then compared."""
    s = pair.sym
    a0, a1, b0, b1 = s('PoolA') + RECORD * 5, s('PoolA') + RECORD * 6, s('PoolB') + RECORD * 2, s('PoolB') + RECORD * 9
    W = lambda v: struct.pack('<H', v & 0xFFFF)
    common = [(s('SegBossActive'), W(0)), (s('DifficultySetting'), W(2)), (s('LevelIndex'), W(1)), (s('SfxEnabled'), b'\1')]
    target = rec(pair, status=1, y=0x50, x=0x40, kind=K.KIND_ENEMY, type=0x14, size_class=1, hit_points=3, slot_index=0xFFFF)

    # A missile aimed elsewhere that overlaps the record ends the scan: the piercing shot in a
    # later slot is never tested, the record survives untouched.
    missile = rec(pair, status=1, y=0x50, x=0x40, kind=K.KIND_TYPED, type=0x0A, player_shot=1, target=a1)
    pierce = rec(pair, status=1, y=0x50, x=0x40, kind=K.KIND_TYPED, type=7, player_shot=1)
    yield Case('PlayerShotsHitRecord', {'BP': a0}, common + [(a0, target), (b0, missile), (b1, pierce)], LOOP,
               name='missile aimed elsewhere ends the scan',
               expect=lambda m, r: check(m.word(a0 + 0x18) == 0x14 and m.word(a0 + 0x20) == 3 and m.word(b1) == 1,
                                         'first overlap ends the scan'))

    # Type 2 is used up by clearing its status only: RemoveRecord is not called.
    t2 = rec(pair, status=1, y=0x50, x=0x40, kind=K.KIND_TYPED, type=2, player_shot=1, sprite=0x33)
    yield Case('PlayerShotsHitRecord', {'BP': a0}, common + [(a0, target), (b0, t2)], LOOP,
               name='type 2 shot: DamageTwo, status cleared',
               expect=lambda m, r: check(m.word(b0) == 0 and m.word(a0 + 0x20) == 1 and m.word(a0 + 0x24) == 5,
                                         'type 2 hit takes 2 HP and flashes'))

    # A type 21h left at 0 HP outside level 4 wraps to FFFFh on its next hit and flashes.
    survivor = rec(pair, status=1, y=0x50, x=0x40, kind=K.KIND_ENEMY, type=0x21, size_class=2, hit_points=0, slot_index=0xFFFF)
    t2b = rec(pair, status=1, y=0x50, x=0x40, kind=K.KIND_TYPED, type=2, player_shot=1, sprite=0x20)
    yield Case('PlayerShotsHitRecord', {'BP': a0}, common + [(a0, survivor), (b0, t2b)], LOOP,
               name='type 21h at 0 HP wraps',
               expect=lambda m, r: check(m.word(a0 + 0x20) == 0xFFFF and m.word(a0 + 0x18) == 0x21, 'HP wrap to FFFFh'))

    # InitPickupRecord leaves SI = DropKind + 46h; through SpawnCellFuelPickup that becomes
    # SpawnFromMapRow's map cursor, so the rest of the row is read from ES:004Bh on.
    yield Case('SpawnCellFuelPickup', {'ES': 0xB800, 'SI': 0x0123, 'AX': 0xF9},
               [(s('MapCellX'), W(0x40)), (s('PoolACursor'), W(a0))], ('DI', 'BP', 'SP', 'DS', 'SS'), outputs=('SI',),
               name='fuel pickup moves the map cursor',
               expect=lambda m, r: check(r['SI'] == 0x4A and m.word(a0 + 0x16) == K.KIND_PICKUP, 'SI = 4Ah after the pickup'))

    # RemoveRecord of a leader: its energy drop takes the leader's own just-freed slot, so the
    # group check afterwards reads the pickup (slot FFFFh) and GROUP_LIVE is kept.
    leader = rec(pair, status=1, y=0x50, x=0x40, kind=K.KIND_ENEMY, type=0x13, size_class=1, slot_index=3)
    groups = bytes([0, 0] * 3 + [2, 4] + [0, 0] * 12)
    yield Case('RemoveRecord', {'BP': a0}, common + [(a0, leader), (s('PoolACursor'), W(a0)), (s('GroupTable'), groups),
                                                     (s('EncounterLiveCount'), W(3))], LOOP,
               name='leader drop reuses its slot',
               expect=lambda m, r: check(m.word(a0) == 1 and m.word(a0 + 0x16) == K.KIND_PICKUP
                                         and m.read(s('GroupTable') + 6, 1) == b'\2', 'drop in the freed slot keeps GROUP_LIVE'))

# Plausible translation slips; each must make this suite fail (python tools/difftest.py --mutants).
MUTANTS = [
    ('hits.c', 'if (--r->hit_points == 0) destroy_record(r);\r\n    else damage_one(r);',
               'if (--r->hit_points == 0) destroy_record(r);'),                                   # omitted step
    ('hits.c', '(sword)r->y < 0x20', 'r->y < 0x20'),                                               # signedness
    ('hits.c', '((shot->x & 7) != 0 && dx == 0xFFF8)', '(dx == 0xFFF8)'),                          # hit box
    ('hits.c', 'r->type != 0x78 && r->type != 0x79', 'r->type != 0x78'),                           # boss rows
    ('hits.c', 'group[GROUP_LIVE] != 0 && --group[GROUP_LIVE] == 0', '--group[GROUP_LIVE] == 0'),  # wrap of a 0 group
    ('hits.c', 'call_main_find_free(FindFreeRecordPoolA)', 'call_main_find_free(FindFreeRecordPoolB)'),  # wrong pool for drops
    ('hits.c', '    case 0x93:\r\n        Type93KilledLatch = 1;\r\n        break;', '    case 0x93:\r\n        Type93KilledLatch = 1;\r\n        return;'),
    ('hits.c', 'if (x > PLAYFIELD_MAX_X) x', 'if ((sword)x > PLAYFIELD_MAX_X) x'),                  # unsigned drop X
    ('hits.asm', 'InitPickupRecord:\r\n    push ax\r\n    mov si, bx\r\n    call INIT_PICKUP_RECORD\r\n    mov si, ax\r\n',
                 'InitPickupRecord:\r\n    push ax\r\n    push si\r\n    mov si, bx\r\n    call INIT_PICKUP_RECORD\r\n    pop si\r\n'),
]

# Coverage-guided differential fuzzing (python tools/fuzz.py hits N).
from fuzz import Target
import hybrid as _hybrid
REGION = [n for n, f in _hybrid.owned_labels().items() if f == 'hits.c']

def _shothit_seed(w):
    """Every pool B slot a live player shot; most miss on one axis (so the scan goes deep),
    the others sit at each hit-box offset of the record's cell."""
    rng = w.rng
    world_into(w)
    r = enemy(w, size_class=rng.choice((1, 2, 2)), type=rng.choice(ENEMY_TYPES[:-3] + (0x78, 0x79)))
    cx, cy = r.get('x') & ~7, r.get('y') & ~7
    for i in range(K.POOL_B_COUNT):
        s = w.record('PoolB', i).live(kind=K.KIND_TYPED, type=rng.choice(SHOT_TYPES), size=0, player_shot=1, target=r.at)
        near = rng.randrange(5) == 0
        dx = rng.choice((-8, 0, 8, 16, 24)) if near or rng.randrange(2) else rng.choice((-24, -16, 32, 40))
        dy = rng.choice((0, 8, 16, 24)) if near or not rng.randrange(2) else rng.choice((-8, -16, 32, 40))
        s.set(x=cx + dx + rng.randrange(8), y=cy + dy + rng.randrange(8), sprite=rng.choice((0x33, 0x20)))
    return {'BP': r.at}

_slot_seeds = [0]
def _slot_seed(w):
    """The last pool B slot overlaps; each earlier slot holds either a live shot that
    overlaps on X only (every X offset, or a miss) or a dormant full hit (status 0) at a
    random X offset and Y row. The fuzzer's live/free toggle then wakes one dormant hit,
    reaching that row in that slot's copy of the unrolled scan."""
    rng = w.rng
    world(rng, w.pair, seg_boss=False, w=w)
    size = 2 if _slot_seeds[0] % 4 else 1; _slot_seeds[0] += 1
    r = slot_hit(w, K.POOL_B_COUNT - 1, size, rng.choice(HIT_DX[size]), rng.choice(HIT_DY[size]), type=0x14)
    cx, cy = r.get('x') & ~7, r.get('y') & ~7
    for i in range(K.POOL_B_COUNT - 1):
        s = w.record('PoolB', i)
        dx = rng.choice(HIT_DX[size] + (32, -16))
        s.set(x=cx + dx + (rng.randrange(1, 8) if dx == -8 else rng.randrange(8)))
        if rng.randrange(2): s.set(status=0, player_shot=1, y=cy + rng.choice(HIT_DY[size]) + rng.randrange(8))
    return {'BP': r.at}

def _remove_seed(w):
    """RemoveRecord of an enemy (unclamped X: the drop X clamp), leaders and boss parts."""
    world_into(w)
    r = enemy(w, type=w.rng.choice(LEADERS + (0x76, 0x93, 0x14, 1)), x=w.rng.choice((0x40, 0xC4, 0xFFF8, 0x8000)))
    w.word('PoolACursor', r.at if w.rng.randrange(2) else w.slot('PoolA', 0))
    return {'BP': r.at}

def _descend_seed(w):
    world_into(w)
    return {'BP': enemy(w, type=0x22, y=w.rng.randrange(0x9C, 0xA2)).at}
def _destroy_seed(w):
    world_into(w)
    r = enemy(w)
    if w.rng.randrange(4) == 0: w.fill('PoolA', K.POOL_A_COUNT)
    return {'BP': r.at}

def _burst_seed(w):
    world_into(w)
    r = enemy(w, type=0x36, y=w.rng.randrange(0x98, 0xA2))
    if w.rng.randrange(3) == 0: w.fill('PoolB', w.rng.choice((30, 33, 34)))
    return {'BP': r.at}

def _smart_seed(w):
    world_into(w)
    for k in range(K.POOL_A_COUNT):
        if w.rng.randrange(3): enemy(w, k)
        else: w.record('PoolA', k).randomize().free()
    return {}

def world_into(w): return world(w.rng, w.pair, w=w)

def in_domain(seed):
    """Seed builder whose every record (also stale free ones, which the fuzzer may revive or
    enter) meets the oracle preconditions in DOMAINS."""
    def build(w):
        regs = seed(w)
        for r in w._records.values():
            if r.get('size_class') > 2: r.set(size_class=w.rng.randrange(3))
            if r.get('slot_index') != 0xFFFF: r.set(slot_index=r.get('slot_index') & 15)
        return regs
    return build

def _pool_a_slots(pair): return [pair.sym('PoolA') + RECORD * i for i in range(K.POOL_A_COUNT)]

# Preconditions: REC_SIZE_CLASS indexes DestroyRecord's unchecked 3-entry table, REC_SLOT_INDEX
# is FFFFh or a GroupTable index, the segmented-boss part pointers name pool A records.
DOMAINS = {'size_class': range(3), 'slot_index': (0xFFFF,) + tuple(range(16)),
           **{p: _pool_a_slots for p in SEG_BOSS_PARTS}, 'LevelIndex': range(K.LEVEL_COUNT)}
GLOBALS = ('SegBossActive', 'DifficultySetting', 'LevelIndex', 'SfxEnabled', 'ScrollDeltaY', 'EncounterLiveCount',
           'SwayDirX') + SEG_BOSS_PARTS
FUZZ = [
    Target('shothit', 'PlayerShotsHitRecord', in_domain(_shothit_seed), REGION, types=ENEMY_TYPES + SHOT_TYPES,
           globals=GLOBALS, watch=('EncounterLiveCount', 'SegBossActive'), domains=DOMAINS),
    Target('shotslot', 'PlayerShotsHitRecord', in_domain(_slot_seed), REGION, types=ENEMY_TYPES + SHOT_TYPES,
           globals=GLOBALS, domains=DOMAINS),
    Target('destroy', 'DestroyRecord', in_domain(_destroy_seed), REGION, KEEPS, types=ENEMY_TYPES,
           globals=GLOBALS, watch=('EncounterLiveCount', 'SegBossActive', 'LeaderScriptCursor'), domains=DOMAINS),
    Target('burst', 'Type36FallThenBurst', in_domain(_burst_seed), REGION, types=(0x36, 0x22, 0x35) + ENEMY_TYPES,
           globals=GLOBALS, domains=DOMAINS),
    Target('remove', 'RemoveRecord', in_domain(_remove_seed), REGION, types=ENEMY_TYPES, globals=GLOBALS, domains=DOMAINS),
    Target('descend', 'Type22DescendThenBurst', in_domain(_descend_seed), REGION, types=(0x22, 0x35), globals=GLOBALS,
           domains=DOMAINS),    Target('smartbomb', 'SmartBombAll', in_domain(_smart_seed), REGION, types=ENEMY_TYPES, globals=GLOBALS, domains=DOMAINS),
]
