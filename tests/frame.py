"""Per-frame region (c/frame.c): the record pass, the frame timers, fuel and refuel, and the
map scroll (level end, checkpoints, the level start scroll, SmartBombAll).

Entries: the bridge labels (UpdateAllRecords, TickFrameTimers, TickRefuel,
UpdateRefuelTimersAndScore, StepHatchRampFrame, ScrollForwardAndCheckLevelEnd,
RestartAtCheckpoint, ScrollMapToLevelStart, SmartBombAll and the handlers of types 50h,
76h..79h and 80h); whole frames as sequences (ScrollForwardAndCheckLevelEnd,
UpdateAllRecords, UpdateRefuelTimersAndScore: record handlers in C and ASM run inside the C
record pass); and documented quirks asserted on the oracle.

The level map (SlotBuffer, the segment in LevelMapSegment) is placed with difftest.far().
RestartAtCheckpoint reloads it through LoadLevelMap: a FileCache entry names the level's map
file with the map window itself as the cached copy, so the load is a copy onto itself (no
DOS call) and the rest of LoadLevelMap (attributes, fixed rows) runs as in the game.
"""
from difftest import Case, ALL_REGS, far
from world import World, K, RECORD
import struct

LOOP = ('BP', 'SP', 'DS', 'SS')
W = lambda v: struct.pack('<H', v & 0xFFFF)
ROW = K.MAP_ROW_BYTES
SEG_BOSS_PARTS = ('SegBossAnchor', 'SegBossPart77', 'SegBossCore', 'SegBossPart79')
MY_TYPES = (0x50, 0x76, 0x77, 0x78, 0x79, 0x80)
# Handlers that are safe on randomised fields (as in tests/hits.py and tests/sequences.py).
OTHER_TYPES = (0x14, 0x1D, 0x1E, 0x2E, 0x48, 0x22, 0x35, 0x36, 0x30, 0x81, 0x93, 0x21)
SHOT_TYPES = (2, 3, 4, 0x0B)
TYPES = MY_TYPES + OTHER_TYPES + SHOT_TYPES
# ScrollWindowOffset: from ScrollBandBytes to ScrollWrapOffset in PlayfieldRowBytes steps
# (Tandy geometry of the test runtime).
WINDOW = range(0x680, 0x5B01, 0x68)

def keep(*scratch): return tuple(r for r in ALL_REGS if r not in scratch)

def boss_path(pair): return [pair.sym('BossPath') + 4 * k for k in range(23)]   # 22 points and the FFFFh end

def march(w):
    """Invader march and type 93h frame state."""
    rng = w.rng
    w.byte('MarchEdgeHit', rng.choice((0, 0, 1, 2))).byte('MarchDelay', rng.choice((0, 1, 1, 2, 5)))
    w.byte('MarchStepNow', rng.randrange(2)).byte('MarchDropNow', rng.randrange(2))
    w.byte('MarchFireDelay', rng.choice((1, 1, 2, 0x28, 0))).byte('MarchFireNow', rng.randrange(2))
    w.word('MarchStepX', rng.choice((2, 0xFFFE)))
    w.word('EncounterLiveCount', rng.choice((0, 1, 2, 3, 4, 5, 8, 9, 0x10, 0x11, 0x20)))
    w.word('FramesSinceInvaderSpawn', rng.choice((0xFFFF, 0xFFFE, 0, rng.randrange(0x100))))
    w.word('InvaderNextMarchLeft', rng.randrange(2)).word('InvaderNextDropStep', rng.choice((0, 0, 8, 0x10)))
    w.byte('Type93KilledLatch', rng.choice((0, 0, 1))).byte('Type93KilledPulse', rng.randrange(2))
    w.word('RecordTickCounter', rng.choice((rng.randrange(0x5DC), 0x5DB, 0x57D, 0x4FF, 0x7C, 0x17D)))
    w.word('LeaderScriptCursor', w.sym('LeaderScript7EEnd') if rng.randrange(4) else w.sym('LeaderScript7E'))

def marcher(r, rng):
    """A type 80h invader in any phase: entering, in or out of its slot, diving."""
    r.set(kind=K.KIND_ENEMY, type=0x80, size_class=1, field_1c=rng.choice((0, 0, 0, 1, 2, 0x10)),
          sprite=rng.choice((0x160, 0x161, 0x162, 0x163, 0x164, 0x166, 0x167, 0x168, 0x169, 0x15F)),
          x=rng.choice((2, 0xBE, 0, 0xC0, rng.randrange(0xC1))), saved_x=rng.randrange(0xC1),
          saved_y=rng.choice((0x20, 0x50, 0xA4, 0xA8, 0xB0)))
    r.set(y=rng.choice((r.get('saved_y'), r.get('saved_y'), r.get('saved_y') + rng.randrange(-5, 6), 0xE0, 0xDC, 0xE4)))
    return r

def seg_boss(w, active=None):
    """The segmented boss: four part records in pool A, the anchor steering along BossPath."""
    rng = w.rng
    if active is None: active = rng.randrange(2)
    w.word('SegBossActive', 1 if active else rng.choice((0, 2)))
    parts = rng.sample(range(K.POOL_A_COUNT), 4)
    for name, i, t in zip(SEG_BOSS_PARTS, parts, (0x76, 0x77, 0x78, 0x79)):
        w.word(name, w.slot('PoolA', i))
        w.record('PoolA', i).live(kind=K.KIND_ENEMY, type=t, size=2)
    at = rng.choice(boss_path(w.pair))
    w.word('SegBossPathCursor', at)
    w.word('SegBossX', rng.choice((0, 0x30, 0x90, rng.randrange(0xC1)))).word('SegBossY', rng.randrange(-0x28, 0xA0))
    if rng.randrange(3) == 0:      # at the waypoint: arrives, the next one is steered at once
        mem = w.pair.a.pristine
        y, x = mem[at] | mem[at + 1] << 8, mem[at + 2] | mem[at + 3] << 8
        if y != 0xFFFF: w.word('SegBossY', y + 0x20).word('SegBossX', x)
    return parts

def record(w, r):
    """A live record of any kind the pass meets: mostly enemies of this region's types."""
    rng = w.rng
    k = rng.randrange(12)
    if k < 7:
        t = rng.choice(MY_TYPES + MY_TYPES + OTHER_TYPES)
        r.live(kind=K.KIND_ENEMY, type=t)
        if t == 0x80: marcher(r, rng)
        if t in (0x76, 0x77, 0x78, 0x79): r.set(size_class=2)
        if t == 0x50: r.set(saved_x=r.get('x') + rng.randrange(-2, 3), saved_y=r.get('y') + rng.randrange(-2, 3), size_class=1)
    elif k == 7: r.live(kind=K.KIND_SCENERY, type=rng.choice((0, 0x26)))
    elif k == 8: r.live(kind=K.KIND_PICKUP, type=0, item_index=rng.randrange(5), size=1)
    elif k == 9: r.live(kind=K.KIND_EXHAUST, type=0, size=0)
    elif k == 10: r.live(kind=K.KIND_POD, type=0, size=1, sprite=rng.choice((0x14, 0x18, 0x19)))
    else: r.live(kind=K.KIND_PLAYER, type=0)
    return r

def frame_world(w, level=None, density=3):
    """A mid-game world for the record pass: march, boss and timer state, both pools."""
    rng = w.rng
    w.plausible()
    w.word('LevelIndex', rng.choice((5, 5, 0)) if level is None else level)
    w.word('DifficultySetting', rng.randrange(3)).word('LevelEndPhase', rng.choice((0, 0, 0, 1, 3)))
    for name in ('SidePodLeftInner', 'SidePodRightInner', 'SidePodLeftOuter', 'SidePodRightOuter',
                 'TrailingPodNear', 'TrailingPodFar'):
        w.word(name, 0xFFFF)
    march(w)
    w.word('SwayDropY', rng.choice((0, 8)))
    parts = seg_boss(w)
    for i in range(K.POOL_A_COUNT):
        if i in parts: continue
        r = w.record('PoolA', i)
        if rng.randrange(density): record(w, r)
        else: r.randomize().free()
    for i in range(K.POOL_B_COUNT):
        r = w.record('PoolB', i)
        if rng.randrange(2):
            r.live(kind=K.KIND_TYPED, type=rng.choice(SHOT_TYPES), size=0, player_shot=rng.randrange(2),
                   field_1c=rng.choice((0, 1, 5, 30, 0xFFFF)))
        else: r.randomize().free()
    in_domain(w)
    return w

def in_domain(w):
    """Every record (also stale free ones the fuzzer may revive) inside the oracle's
    preconditions: size class 0..2, group slot FFFFh or 0..15, direction 0..7, a type whose
    handler is safe on its fields, a pickup item 0..4."""
    rng = w.rng
    for r in w._records.values():
        if r.at == w.sym('PrimaryRecord'): continue
        if r.get('size_class') > 2: r.set(size_class=rng.randrange(3))
        if r.get('slot_index') != 0xFFFF: r.set(slot_index=r.get('slot_index') & 15)
        if r.get('direction') > 7: r.set(direction=r.get('direction') & 7)
        if r.get('type') not in TYPES: r.set(type=rng.choice(TYPES))
        if r.get('kind') > 6: r.set(kind=rng.choice((0, 2, 4, 4, 5, 6)))
        if r.get('item_index') > 4: r.set(item_index=r.get('item_index') % 5)
        if r.get('kind') == K.KIND_POD and r.get('sprite') == 0x0F: r.set(sprite=0x14)

def timers(w):
    """Frame counters and slow counters at and around their wraps, sway state, fuel."""
    rng = w.rng
    w.plausible()
    for name, mod in (('FrameCount4', 4), ('FrameCount8', 8), ('FrameCount16', 16), ('FrameCount32', 32),
                      ('FrameCount64', 64), ('FrameCount128', 128), ('FrameDivider4', 4), ('SlowCount10', 10),
                      ('SlowCount6', 6), ('SlowCount5', 5), ('SlowCount3', 3), ('SlowCount4', 4), ('SlowCount8', 8)):
        w.word(name, rng.choice((mod - 1, mod - 2, mod - 2, rng.randrange(mod), rng.randrange(mod), 0)))
    if rng.randrange(2): w.word('FrameCount8', 7)
    if rng.randrange(2): w.word('FrameDivider4', 3)
    w.word('FrameParity', rng.randrange(2))
    w.word('SwayDirX', rng.choice((1, 0xFFFF, 1, 0xFFFF, 0))).word('SwayPhase', rng.choice((0, 1, 1, 1, 2, 3)))
    w.word('SwayReversals', rng.choice((0, 0x0F, 0x1F, 0x10, rng.randrange(0x40))))
    w.word('EncounterLiveCount', rng.choice((0, 0, 1))).word('EncounterEndDelay', rng.choice((0, 1, 1, 2, 0x64)))
    w.word('MapScrollPos', rng.choice((K.MAP_MUSIC_CHANGE_POS, K.MAP_MUSIC_CHANGE_POS - ROW, ROW * rng.randrange(12, 289))))
    w.word('DifficultySetting', rng.choice((0, 1, 2, 3)))
    w.word('Fuel', rng.choice((0, 1, 1, 2, 0x57, 0x58, rng.randrange(0x59))))
    w.byte('WhatOilShortageFlag', rng.choice((0, 0, 1, 2))).byte('SfxEnabled', rng.randrange(2))
    w.word('ExtraDrainToggle', rng.randrange(2))
    w.word('RefuelActive', rng.choice((0, 1, 1, 2)))
    w.player(sprite=rng.choice((0, 1, 2, 2, 3, 4)))
    return w

def scroll_world(w, level=None, pos=None, full_map=False):
    """A world for ScrollForwardAndCheckLevelEnd with a row boundary often due."""
    rng = w.rng
    w.plausible()
    level = rng.randrange(K.LEVEL_COUNT) if level is None else level
    w.word('LevelIndex', level)
    if pos is None:
        pos = ROW * rng.choice((K.MAP_LAST_SPAWN_POS // ROW - 1, K.MAP_END_POS // ROW - 1, K.MAP_END_POS // ROW,
                                K.MAP_INTRO_END_POS // ROW, K.MAP_INTRO_END_POS // ROW - 1, rng.randrange(12, 288)))
    w.word('MapScrollPos', pos)
    w.word('ScrollSubRow', rng.choice((0, 0, 1, 1, rng.randrange(16))))
    w.word('ScrollWindowOffset', rng.choice((WINDOW[0], WINDOW[1], WINDOW[-1], rng.choice(WINDOW))))
    w.word('LastTileStepBackward', rng.choice((0, 0, 1))).word('ScrollingBackward', rng.randrange(2))
    w.word('LevelEndPhase', rng.choice((0, 0, 0, 0, 1, 2)))
    w.word('EncounterLiveCount', rng.choice((0, 0, 0, 1))).word('EncounterEndDelay', rng.choice((0, 0, 0, 1)))
    w.word('LevelScriptClock', rng.choice((5, 4, 0, rng.randrange(0x120))))
    w.byte('SfxEnabled', rng.randrange(2))
    import spawn
    spawn.pool_a(w, rng.choice((0, 3, 20, 31, 33, 34, 35)))
    rows = range(0, K.MAP_END_POS // ROW) if full_map else range(max(0, pos // ROW - 14), min(288, pos // ROW + 2))
    spawn.level_map(w, level, rows=rows)
    return {'BP': w.sym('PrimaryRecord')}

def reset_lists(pair):
    """Map bytes of each level's MapResetList (CS data, read from the oracle image)."""
    m = pair.a.m
    out = {}
    for level in range(K.LEVEL_COUNT):
        data, at, bytes_ = bytes(m.u.mem_read(m.linear(f'MapResetList{level}'), 0x200)), 0, []
        while struct.unpack_from('<H', data, at)[0] != 0xFFFF:
            bytes_.append(data[at]); at += 4
        out[level] = bytes_
    return out

def restart_world(w, level=None):
    """RestartAtCheckpoint: map rows holding the level's reset bytes (and others), the
    level's map file cached as the map window itself (LoadLevelMap copies it onto itself)."""
    rng, s = w.rng, w.sym
    w.plausible()
    level = rng.randrange(K.LEVEL_COUNT) if level is None else level
    w.word('LevelIndex', level)
    w.word('MapScrollPos', rng.choice((ROW * rng.randrange(12, 289), 0x3CF, 0x3CE, 0x750, 0x7C5, 0x777, 0xA90, 0xA8F)))
    w.word('LevelScriptClock', rng.randrange(0x120))
    w.word('ScrollSubRow', rng.randrange(16)).word('ScrollWindowOffset', rng.choice(WINDOW))
    w.word('LastTileStepBackward', rng.randrange(2))
    lists = reset_lists(w.pair)
    others = [1, 0, 0x28, 0x40, 0x55] + lists[(level + 1) % K.LEVEL_COUNT]
    data = bytes(rng.choice(lists[level]) if rng.randrange(3) else rng.choice(others) for _ in range(K.MAP_END_POS))
    w.put(far('SlotBuffer', 0), data)
    name = w.pair.a.m.word(s('LevelMapFiles') + 2 * level)
    w.put('FileCache', W(name) + W(0x9000) + W(K.MAP_END_POS) + W(0) + W(0) + W(0xFFFF))
    return {'BP': s('PrimaryRecord')}

def hatch(w):
    rng = w.rng
    w.plausible()
    w.word('FrameDivider4', rng.choice((0, 0, 1, 3)))
    r = w.record('PoolA', rng.randrange(K.POOL_A_COUNT)).live(kind=K.KIND_ENEMY, type=rng.choice((0x28, 0x2A)))
    r.set(direction=rng.choice((0, 6, 7, 0x16, 0x17, 0x18, 0x19, 0x117, 0xFFFF, rng.randrange(0x18))))
    return {'BP': r.at, 'CX': rng.choice((0x1C, 0, 0x100, rng.randrange(0x10000)))}

def cases(rng, scale, pair):
    s = pair.sym
    world = lambda: World(pair, rng)
    for i in range(150 * scale):
        w = frame_world(world())
        yield Case('UpdateAllRecords', {}, w.writes(), LOOP, name=f'pass #{i}')
    for i in range(100 * scale):
        w = frame_world(world(), level=rng.choice((0, 5)), density=6)
        r = w.record('PoolA', rng.randrange(K.POOL_A_COUNT))
        t = rng.choice(MY_TYPES)
        record(w, r); r.live(kind=K.KIND_ENEMY, type=t, size=2 if t in (0x76, 0x77, 0x78, 0x79) else 1)
        if t == 0x80: marcher(r, rng)
        if t == 0x50: r.set(saved_x=r.get('x') + rng.randrange(-2, 3), saved_y=r.get('y') + rng.randrange(-2, 3))
        in_domain(w)
        # the handlers through their caller, RunTypeHandler (c/enemies.c)
        yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name=f'type {t:X} #{i}')
    for i in range(200 * scale):
        w = timers(world())
        yield Case(rng.choice(('TickFrameTimers', 'UpdateRefuelTimersAndScore', 'TickRefuel')), {}, w.writes(), LOOP,
                   name=f'#{i}')
    for i in range(100 * scale):
        w = world(); regs = hatch(w)
        yield Case('RunTypeHandler', regs, w.writes(), LOOP, name=f'hatch #{i}')      # Type28EnemyHatch
    for i in range(120 * scale):
        w = world(); regs = scroll_world(w)
        yield Case('ScrollForwardAndCheckLevelEnd', regs, w.writes(), LOOP, name=f'#{i}')
    for i in range(30 * scale):
        w = frame_world(world(), density=2)
        yield Case('SmartBombAll', {}, w.writes(), LOOP, name=f'#{i}')
    for i in range(3 * scale):
        w = world(); regs = restart_world(w, level=i % K.LEVEL_COUNT)
        yield Case('RestartAtCheckpoint', regs, w.writes(), LOOP, name=f'#{i}')
    w = world(); regs = scroll_world(w, level=1, full_map=True)
    yield Case('ScrollMapToLevelStart', regs, w.writes(), LOOP, name='level start')
    yield from quirks(pair)
    for i in range(10 * scale):
        yield frames(rng, pair, i)

def frames(rng, pair, i):
    """Whole frames as GameFrame orders them: the scroll (with the player as spawn origin),
    the record pass, the timers and the score."""
    w = frame_world(World(pair, rng), level=rng.choice((0, 5, rng.randrange(K.LEVEL_COUNT))))
    w.word('LevelEndPhase', 0).word('EncounterEndDelay', 0)
    w.word('MapScrollPos', ROW * rng.randrange(20, 280)).word('ScrollSubRow', rng.randrange(16))
    w.word('ScrollWindowOffset', rng.choice(WINDOW)).word('RefuelActive', rng.randrange(2))
    w.word('Fuel', rng.randrange(0x59))
    bp = {'BP': pair.sym('PrimaryRecord')}
    steps = [Case('ScrollForwardAndCheckLevelEnd', bp, w.writes(), LOOP, name=f'frames {i} scroll 0')]
    for f in range(rng.choice((4, 8, 16))):
        steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'frames {i} records {f}'))
        steps.append(Case('UpdateRefuelTimersAndScore', {}, (), LOOP, name=f'frames {i} timers {f}'))
        steps.append(Case('ScrollForwardAndCheckLevelEnd', bp, (), LOOP, name=f'frames {i} scroll {f + 1}'))
    return steps

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented quirk: ' + what)

def quirks(pair):
    """Original behaviour worth pinning (asserted on the oracle, then compared)."""
    import random
    s = pair.sym
    rng = random.Random(0xF4A3E)
    word = lambda m, name, k=0: m.word(s(name) + k)

    # The hatch ramp's xlat keeps the direction's high byte: direction 117h (not stepped,
    # FrameDivider4 1) gives sprite 100h + Type28FrameRamp[17h] + base.
    w = World(pair, rng); w.plausible(); w.word('FrameDivider4', 1)
    r = w.record('PoolA', 4).live(kind=K.KIND_ENEMY, type=0x28, direction=0x117)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='ramp high byte',
               expect=lambda m, reg, at=r.at: check(m.word(at + 8) == 0x100 + 0x1C, 'sprite 11Ch'))

    # MarchDelay 0 is reloaded with 0 on level 5: a march step every frame.
    w = World(pair, rng); frame_world(w, level=5)
    w.byte('MarchDelay', 0).byte('MarchStepNow', 0)
    yield Case('UpdateAllRecords', {}, w.writes(), LOOP, name='march delay 0',
               expect=lambda m, reg: check(m.read(s('MarchDelay'), 1) == b'\0' and m.read(s('MarchStepNow'), 1) == b'\1',
                                           'MarchDelay 0 steps every frame'))

    # Type 50h returns with a bare ret: no X clamp, no bounds removal at Y F8h.
    w = World(pair, rng); w.plausible()
    r = w.record('PoolA', 7).live(kind=K.KIND_ENEMY, type=0x50, size=1, x=0xFFF0, y=0xF8, saved_x=0xFFF0, saved_y=0xF8)
    yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name='no FinishRecordUpdate',
               expect=lambda m, reg, at=r.at: check(m.word(at) == 1 and m.word(at + 4) == 0xFFF0
                                                    and m.word(at + 0x16) == K.KIND_POD, 'arrives unclamped, stays live'))

    # The level end spawns take Type53SpawnTable entries in order of the records found: with
    # two free pool A slots only the first two entries are used.
    w = World(pair, rng); regs = scroll_world(w, level=2, pos=K.MAP_END_POS)
    w.word('ScrollSubRow', 1).word('LevelEndPhase', 0).word('EncounterLiveCount', 0).word('EncounterEndDelay', 0)
    w.word('LastTileStepBackward', 0)
    w.fill('PoolA', 33, kind=K.KIND_SCENERY)       # two free slots; nothing for the smart bomb
    def two_spawns(m, reg):
        made = [k for k in range(K.POOL_A_COUNT) if m.word(s('PoolA') + RECORD * k + 0x18) == 0x53
                and m.word(s('PoolA') + RECORD * k) == 1]
        check(len(made) == 2 and sorted(m.word(s('PoolA') + RECORD * k + 8) for k in made) == [0x10, 0x13],
              'the first two table entries')
    yield Case('ScrollForwardAndCheckLevelEnd', regs, w.writes(), LOOP, name='level end with two free slots',
               expect=two_spawns)

    # Ship form 2 drains a second unit on every second FrameCount32 wrap.
    w = World(pair, rng); timers(w)
    for name, v in (('FrameCount32', 0x1E), ('FrameCount64', 0), ('FrameCount128', 0), ('Fuel', 0x40),
                    ('ExtraDrainToggle', 1), ('EncounterEndDelay', 0), ('RefuelActive', 0)):
        w.word(name, v)
    w.player(sprite=2)
    yield Case('TickFrameTimers', {}, w.writes(), LOOP, name='ship form 2 extra drain',
               expect=lambda m, reg: check(word(m, 'Fuel') == 0x3F, 'one extra unit'))

    # Past its last checkpoint the level restarts at checkpoint 3 (the fourth read compares
    # one word past the table, result unused).
    w = World(pair, rng); regs = restart_world(w, level=0)
    w.word('MapScrollPos', K.MAP_END_POS)
    yield Case('RestartAtCheckpoint', regs, w.writes(), LOOP, name='checkpoint 3',
               expect=lambda m, reg: check(word(m, 'MapScrollPos') == 0xA90 and word(m, 'LevelScriptClock') == 0x4D,
                                           'position A90h, clock 4Dh'))

# Plausible translation slips; each must make this suite fail (python tools/difftest.py --mutants frame).
MUTANTS = [
    ('frame.c', 'if (++RecordTickCounter >= 0x5DC) RecordTickCounter = 0;',
                'if (++RecordTickCounter > 0x5DC) RecordTickCounter = 0;'),
    ('frame.c', 'if ((sword)r->y < 0) r->y = 0;', 'if (r->y < 0x8000) r->y = 0;'),
    ('frame.c', '        if (r->status != 0) bp = frame_update_record_by_kind(r);',
                '        bp = frame_update_record_by_kind(r);'),
    ('frame.c', '        spawn += 3;\r\n    }', '    }'),
    ('frame.c', '    SwayDropY = 0;\r\n', ''),
    ('frame.c', '    if (DifficultySetting > 1 ? FrameCount64', '    if (DifficultySetting > 0 ? FrameCount64'),
    ('frame.c', 'r->sprite = ((direction & 0xFF00) | Type28FrameRamp[direction & 0xFF]) + base;',
                'r->sprite = Type28FrameRamp[direction & 0xFF] + base;'),
    ('frame.c', 'if (ScrollSubRow == 0 && LastTileStepBackward != 1) {', 'if (ScrollSubRow == 0) {'),
    ('frame.asm', 'UpdateAllRecords:\r\n    call UPDATE_ALL_RECORDS\r\n    mov bp, ax\r\n',
                  'UpdateAllRecords:\r\n    call UPDATE_ALL_RECORDS\r\n'),
]

# Coverage-guided differential fuzzing (python tools/fuzz.py frame N).
from fuzz import Target
import hybrid as _hybrid
import itertools
REGION = [n for n, f in _hybrid.owned_labels().items() if f == 'frame.c']
_cycles = {}
def _next(name, values): return next(_cycles.setdefault(name, itertools.cycle(values)))

def _pool_a_slots(pair): return [pair.sym('PoolA') + RECORD * i for i in range(K.POOL_A_COUNT)]

# Preconditions: the record fields the handlers index unchecked (size class, group slot,
# direction, pickup item, kind), record types whose handlers are safe on their fields, boss
# part and path pointers only into pool A / BossPath, the scroll window and map positions on
# their grids, table-indexing globals in range.
DOMAINS = {'size_class': range(3), 'slot_index': (0xFFFF,) + tuple(range(16)), 'direction': range(8),
           'item_index': range(5), 'kind': range(7), 'type': TYPES,
           **{p: _pool_a_slots for p in SEG_BOSS_PARTS}, 'SegBossPathCursor': boss_path,
           'LevelIndex': range(K.LEVEL_COUNT), 'SteerSpeed': range(4), 'ScrollingBackward': (0, 1),
           'LeaderScriptCursor': lambda pair: (pair.sym('LeaderScript7EEnd'), pair.sym('LeaderScript7E')),
           'ScrollWindowOffset': WINDOW, 'ScrollSubRow': range(16),
           'MapScrollPos': range(0, K.MAP_END_POS + 1, ROW), 'DifficultySetting': range(4)}
PASS_GLOBALS = ('LevelIndex', 'MarchEdgeHit', 'MarchDelay', 'MarchFireDelay', 'MarchStepX', 'EncounterLiveCount',
                'FramesSinceInvaderSpawn', 'Type93KilledLatch', 'RecordTickCounter', 'SegBossActive',
                'SegBossPathCursor', 'SegBossX', 'SegBossY', 'LevelEndPhase', 'FrameCount128', 'SfxEnabled',
                'LeaderScriptCursor') + SEG_BOSS_PARTS
MARCH_GLOBALS = ('MarchStepNow', 'MarchDropNow', 'MarchFireNow', 'MarchStepX', 'RecordTickCounter', 'FrameCount4',
                 'FrameCount8', 'LeaderScriptCursor', 'SfxEnabled')
TIMER_GLOBALS = ('FrameCount4', 'FrameCount8', 'FrameCount16', 'FrameCount32', 'FrameCount64', 'FrameCount128',
                 'FrameDivider4', 'SlowCount10', 'SlowCount6', 'SlowCount5', 'SlowCount3', 'SwayDirX', 'SwayPhase',
                 'SwayReversals', 'EncounterLiveCount', 'EncounterEndDelay', 'MapScrollPos', 'DifficultySetting',
                 'Fuel', 'WhatOilShortageFlag', 'SfxEnabled', 'ExtraDrainToggle', 'RefuelActive', 'LevelIndex')
SCROLL_GLOBALS = ('MapScrollPos', 'ScrollSubRow', 'ScrollWindowOffset', 'LastTileStepBackward', 'LevelEndPhase',
                  'EncounterLiveCount', 'EncounterEndDelay', 'LevelScriptClock', 'SfxEnabled', 'PoolACursor')

def _pass_seed(w):
    frame_world(w, level=_next('pass', (5, 0, 5, 1, 5, 3, 2, 4)))
    return {}
def _boss_seed(w):
    frame_world(w, level=0, density=8)
    seg_boss(w, active=True)
    if _next('boss end', (0, 1)): w.word('SegBossPathCursor', boss_path(w.pair)[-1])   # the FFFFh end
    in_domain(w)
    return {}
def _march_seed(w):
    frame_world(w, level=5, density=8)
    r = marcher(w.record('PoolA', w.rng.randrange(K.POOL_A_COUNT)).live(kind=K.KIND_ENEMY, type=0x80, size=1), w.rng)
    return {'BP': r.at}
def _pod50_seed(w):
    w.plausible()
    r = w.record('PoolA', w.rng.randrange(K.POOL_A_COUNT)).live(kind=K.KIND_ENEMY, type=0x50, size=1)
    r.set(saved_x=r.get('x') + w.rng.randrange(-3, 4), saved_y=r.get('y') + w.rng.randrange(-3, 4))
    if _next('pod50', (0, 1)): r.set(saved_x=r.get('x'), saved_y=r.get('y'))     # arrives now
    w.byte('SfxEnabled', _next('pod50 sfx', (1, 1, 0)))
    return {'BP': r.at}
def _timers_seed(w):
    timers(w)
    return {}
def _hatch_seed(w): return hatch(w)
def _scroll_seed(w):
    regs = scroll_world(w, level=_next('scroll', range(K.LEVEL_COUNT)),
                        pos=_next('scroll pos', (None, K.MAP_INTRO_END_POS - ROW, K.MAP_LAST_SPAWN_POS, K.MAP_END_POS)))
    if _next('scroll row', (0, 1)): w.word('ScrollSubRow', 1).word('LastTileStepBackward', 0)   # a row boundary now
    w.byte('SfxEnabled', _next('scroll sfx', (1, 0)))
    in_domain(w)
    return regs
def _smart_seed(w):
    frame_world(w, density=2)
    w.byte('SfxEnabled', _next('smart', (1, 0)))
    return {}

FUZZ = [
    Target('frame_pass', 'UpdateAllRecords', _pass_seed, REGION, LOOP, types=TYPES, globals=PASS_GLOBALS,
           watch=('MarchDelay', 'RecordTickCounter'), domains=DOMAINS),
    Target('frame_boss', 'UpdateAllRecords', _boss_seed, REGION, LOOP, types=TYPES, globals=PASS_GLOBALS,
           watch=('SegBossPathCursor',), domains=DOMAINS),
    Target('frame_march', 'RunTypeHandler', _march_seed, REGION, LOOP, types=(0x80,),
           globals=MARCH_GLOBALS, watch=('MarchEdgeHit',), domains=dict(DOMAINS, type=(0x80,))),
    Target('frame_pod50', 'RunTypeHandler', _pod50_seed, REGION, LOOP, types=(0x50,),
           globals=('SfxEnabled',), domains=dict(DOMAINS, type=(0x50,))),
    Target('frame_timers', 'UpdateRefuelTimersAndScore', _timers_seed, REGION, LOOP, globals=TIMER_GLOBALS,
           watch=('Fuel', 'SwayReversals'), domains={**DOMAINS, 'sprite': range(5), 'RefuelActive': (0, 1, 2)}),
    # StepHatchRampFrame through its caller, the type 28h/2Ah hatch (sprite base 1Ch).
    Target('frame_hatch', 'RunTypeHandler', _hatch_seed, REGION, LOOP, globals=('FrameDivider4',),
           domains={'FrameDivider4': range(4), 'type': (0x28, 0x2A), 'size_class': range(3),
                    'slot_index': (0xFFFF,) + tuple(range(16))}),
    Target('frame_scroll', 'ScrollForwardAndCheckLevelEnd', _scroll_seed, REGION, LOOP, globals=SCROLL_GLOBALS,
           watch=('LevelEndPhase', 'MapScrollPos'), pin_bp=True,
           domains={**DOMAINS, 'PoolACursor': _pool_a_slots}),
    Target('frame_smartbomb', 'SmartBombAll', _smart_seed, REGION, LOOP, types=TYPES, globals=('SfxEnabled',),
           domains=DOMAINS),
]
# The checkpoint restart and the level start scroll (thousands of scroll lines per case)
# have their own targets in tests/frame_restart.py.
