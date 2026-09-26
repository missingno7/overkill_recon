"""Weapons region (c/weapons.c): the fire button and every weapon pattern, the beam,
missile targeting and the attract demo's script frame.

Entries: HandleFireButton (BP = PrimaryRecord), UpdateBeam, FindMissileTarget and
RunDemoScriptFrame, each over worlds with pods, a beam, full or free pool B, missiles
and the early-level/demo gates; their real ASM callers (UpdatePlayerFrame,
Type0AHomingMissile); stateful sequences (fire + UpdateAllRecords + TickFrameTimers; demo
frames across step changes); and documented quirks asserted on the oracle.
"""
from difftest import Case, ALL_REGS
from world import World, K, RECORD
import struct

LOOP = ('BP', 'SP', 'DS', 'SS')
DEMO = ('SP', 'DS', 'SS')                # RunDemoScriptFrame leaves BP changed
NOT_BX_CX = tuple(r for r in ALL_REGS if r not in ('BX', 'CX'))
PODS = ('SidePodLeftInner', 'SidePodRightInner', 'SidePodLeftOuter', 'SidePodRightOuter',
        'TrailingPodNear', 'TrailingPodFar', 'FrontPodRecord')
SHOT_TYPES = (2, 3, 4, 5, 6, 7, 8, 0x0B, 0x0C, 0x0F)
TARGET_TYPES = (0x14, 0x12, 0x1D, 1, 0x21, 0x22, 0x26, 0x48, 0x50)
W = lambda v: struct.pack('<H', v & 0xFFFF)

def pods(w, free):
    """Each pod slot empty (FFFFh) or a live KIND_POD in its own pool A slot."""
    for name in PODS:
        if w.rng.randrange(3) and free:
            i = free.pop()
            p = w.record('PoolA', i).live(kind=K.KIND_POD, type=0, size=1)
            p.set(x=w.rng.choice((0, 0x40, 0x58, 0x59, 0x90, 0xC0, 0x8000, 0xFFF8, w.rng.randrange(0xC9))))
            w.word(name, p.at)
        else:
            w.word(name, 0xFFFF)

def beam(w, links=None, consistent=True):
    """A beam of `links` type 9 records in pool B listed in BeamList. Consistent (as play
    builds it): links 8 px apart from a head on the 8-px grid, the tail at most C8h, and
    ShotsLiveType9 = the link count. Otherwise any head X and a stray count: growth can then
    overrun BeamListTerminator (see update_beam), which play never does."""
    rng, s = w.rng, w.sym
    n = rng.choice((1, 2, 3, 8, 24, 25, 26)) if links is None else links
    slots = rng.sample(range(K.POOL_B_COUNT), n)
    if consistent:
        head_x = 0xC8 - 8 * (n - 1) if rng.randrange(4) == 0 else 8 * rng.randrange(27 - n)
    else:
        head_x = rng.choice((0, 8, 0x10, 0x40, 0xB8, 0xC8))
    y = rng.randrange(0x10, 0xC0)
    entries = []
    for k, i in enumerate(slots):
        r = w.record('PoolB', i).live(kind=K.KIND_TYPED, type=9, size=0, player_shot=1)
        r.set(x=(head_x + 8 * k) & 0xFFFF, y=y, sprite=0x6B)
        entries.append(r.at)
    if not consistent and rng.randrange(4) == 0:
        w.record('PoolB', slots[-1]).set(x=0xC8)
    w.put('BeamList', b''.join(W(e) for e in entries) + W(0xFFFF) * (26 - n))
    w.word('BeamListEnd', s('BeamList') + 2 * n)
    w.word('ShotsLiveType9', n if consistent or rng.randrange(6) else rng.randrange(4))
    return slots

def fire_world(rng, pair, demo=None, frames=False):
    """A mid-game world where the fire button matters. frames: the world also runs whole
    record updates, so every live record must be one its handler accepts (type 12h with a
    path, no leader-path type 21h, no pods in pool B)."""
    s = pair.sym
    w = World(pair, rng).plausible()
    w.player(sprite=rng.randrange(3))
    free_a = list(range(K.POOL_A_COUNT)); rng.shuffle(free_a)
    pods(w, free_a)
    for i in free_a:                                    # enemies to target, stale slots
        r = w.record('PoolA', i)
        if rng.randrange(3):
            r.live(kind=K.KIND_ENEMY if frames or rng.randrange(5) else rng.choice((K.KIND_PICKUP, K.KIND_TYPED)),
                   type=rng.choice(TARGET_TYPES[:4] + TARGET_TYPES[5:] if frames else TARGET_TYPES),
                   y=rng.choice((0x10, 0x80, 0xE0, 0xE1, 0xFFF0, rng.randrange(0x100))))
            if r.get('type') == 0x12: r.set(field_36=s('Type41Path') + 4 * rng.randrange(6))
        else: r.randomize().free()
    used_b = set(beam(w)) if rng.randrange(3) == 0 else set()
    if not used_b:
        w.word('BeamListEnd', s('BeamList') + 2 * rng.randrange(27)).word('ShotsLiveType9', rng.choice((0, 0, 1, 3)))
    full = rng.randrange(3) == 0
    for i in range(K.POOL_B_COUNT):
        if i in used_b: continue
        r = w.record('PoolB', i)
        if full or rng.randrange(3):
            k = rng.randrange(12)
            if k == 0: r.live(kind=K.KIND_TYPED, type=0x0A, size=0, player_shot=1, target=w.slot('PoolA', rng.randrange(35)))
            elif k == 1:
                item = rng.randrange(5)     # PickupHandlers index
                r.live(kind=K.KIND_PICKUP, type=0, size=0, item_index=item, sprite=0x46 + item)
            elif k == 2 and full and not frames and rng.randrange(4) == 0: r.live(kind=K.KIND_POD, type=rng.choice((9, 0x0A, 2)), size=0)
            else: r.live(kind=K.KIND_TYPED, type=rng.choice(SHOT_TYPES), size=0, player_shot=rng.randrange(2))
        else: r.randomize().free()
    w.word('PoolBCursor', w.slot('PoolB', rng.randrange(K.POOL_B_COUNT + 1)))
    w.word('WeaponMode', rng.randrange(6))
    for name in ('ShotsLiveMain', 'ShotsLiveSide', 'ShotsLiveFrontPod'):
        w.word(name, rng.choice((0, 0, 0, 1, 2, 3)))
    w.byte('InputBits', (rng.randrange(256) | K.IN_BUTTON_PRIMARY) if rng.randrange(6) else rng.randrange(256))
    w.word('FireLatch', rng.randrange(2)).byte('RapidFireEnabled', rng.choice((0, 0, 1, 2)))
    # The level map is MAP_END_POS bytes; test worlds do not load one (its slot in the
    # image is read instead), so rows past the end would read link-dependent bytes.
    w.word('MapScrollPos', rng.choice((K.MAP_INTRO_END_POS, K.MAP_INTRO_END_POS + 1, 0, rng.randrange(K.MAP_END_POS + 1))))
    if demo is None: demo = rng.randrange(6) == 0
    w.word('DemoActive', 1 if demo else rng.choice((0, 0, 0, 2)))
    w.word('DemoStep', rng.choice((8, 0x0F, 0x10, 0x12, rng.randrange(0x13))))
    w.word('MissileAmmo', rng.choice((0, 1, 1, 3))).word('MissilesLive', rng.choice((0, 1, 2)))
    w.word('SideShotsEnabled', rng.randrange(2)).word('PodShotDirection', rng.randrange(8))
    w.word('TargetSearchCursor', w.slot('PoolA', rng.randrange(K.POOL_A_COUNT + 1)))
    return w

def demo_world(rng, pair, step=None, frames=False):
    """The attract demo at some step: DemoActive, the step's timer and fire cycle."""
    w = fire_world(rng, pair, demo=True, frames=frames)
    step = rng.randrange(0x13) if step is None else step
    w.word('DemoStep', step)
    # The demo's own upgrades so far (WeaponMode is an unchecked table index: 5 at most).
    w.word('WeaponMode', sum(1 for s in (10, 12, 13, 14, 15) if s <= step))
    w.word('DemoStepTimer', rng.choice((1, 1, 2, 0x13, 0x14, 0x15, 0x32, 0x64, 0, rng.randrange(0x65))))
    w.word('DemoFireCycle', rng.choice((0x0E, 0x0F, 0x10, 0x12, 0x13, rng.randrange(0x14))))
    w.word('SelectedUpgradeSlot', rng.choice((0xFFFF, 0, 1, 2, 3)))
    if step == 0 or rng.randrange(4) == 0:
        w.record('PrimaryRecord', 0).set(y=rng.choice((0x60, 0x61, 0x62, 0x70, 0x5F)))
    return w

def beam_world(rng, pair):
    w = fire_world(rng, pair)
    beam(w, rng.choice((None, 1, 25, 26)), consistent=rng.randrange(8) != 0)
    w.word('FrameParity', rng.randrange(2))
    if rng.randrange(8) == 0: w.put('BeamList', W(0xFFFF))           # counted but no head
    return w

def key_world(rng, pair):
    """UpdatePlayerFrame with the keyboard: fire (space) and left/right from KeyDownTable."""
    w = fire_world(rng, pair)
    kd = pair.sym('KeyDownTable')
    w.word('InputDeviceMode', 0).word('LevelEndPhase', K.LEVEL_END_OFF)
    w.word('EnergyTanks', rng.randrange(3)).word('Fuel', rng.randrange(1, 0x100))
    for scan in (K.SCAN_SPACE, K.SCAN_LEFT, K.SCAN_RIGHT, K.SCAN_UP, K.SCAN_DOWN):
        w.byte(kd + scan, K.KEY_STATE_DOWN if rng.randrange(2) else K.KEY_STATE_UP)
    return w

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented quirk: ' + what)

def quirks(rng, pair):
    s = pair.sym
    # Early in the level heavy, twin and beam modes fall back to the single shot (type 2,
    # sprite 32h), and only one shot is spawned.
    for mode in (1, 3, 4, 5):
        w = fire_world(rng, pair, demo=False)
        w.word('WeaponMode', mode).word('MapScrollPos', K.MAP_INTRO_END_POS).word('FireLatch', 0).word('DemoActive', 0)
        w.byte('InputBits', K.IN_BUTTON_PRIMARY).fill('PoolB', 0).word('PoolBCursor', s('PoolB'))
        yield Case('HandleFireButton', {'BP': s('PrimaryRecord')}, w.writes(), LOOP, name=f'intro fallback mode {mode}',
                   expect=lambda m, r: check(m.word(s('PoolB') + K.REC_TYPE) == 2 and m.word(s('PoolB') + K.REC_SPRITE) == 0x32
                                             and m.word(s('PoolB') + RECORD) == 0, 'intro single-shot fallback'))
    # The missile gate is "MissilesLive != 1": with 2 live missiles another one fires.
    w = fire_world(rng, pair, demo=False)
    w.word('MissileAmmo', 1).word('MissilesLive', 2).word('MapScrollPos', 0x1000).word('FireLatch', 0).word('DemoActive', 0)
    w.byte('InputBits', K.IN_BUTTON_PRIMARY).word('WeaponMode', 5).word('ShotsLiveType9', 1)
    w.word('SideShotsEnabled', 0).fill('PoolB', 0).word('PoolBCursor', s('PoolB'))
    for name in PODS: w.word(name, 0xFFFF)
    t = w.record('PoolA', 3).live(kind=K.KIND_ENEMY, type=0x14, y=0x40)
    w.word('TargetSearchCursor', t.at)
    yield Case('HandleFireButton', {'BP': s('PrimaryRecord')}, w.writes(), LOOP, name='third missile past the gate',
               expect=lambda m, r: check(m.word(s('MissilesLive')) == 3 and m.word(s('MissileAmmo')) == 0, 'MissilesLive != 1 gate'))
    # Without a target the missile's pool B slot is still allocated (placed, not claimed):
    # with pool B full, a shot has been evicted for nothing.
    w = fire_world(rng, pair, demo=False)
    w.word('MissileAmmo', 1).word('MissilesLive', 0).word('MapScrollPos', 0x1000).word('FireLatch', 0).word('DemoActive', 0)
    w.byte('InputBits', K.IN_BUTTON_PRIMARY).word('WeaponMode', 5).word('ShotsLiveType9', 1)
    w.word('SideShotsEnabled', 0).fill('PoolB', K.POOL_B_COUNT, kind=K.KIND_TYPED, type=2, size=0)
    for name in PODS: w.word(name, 0xFFFF)
    for i in range(K.POOL_A_COUNT): w.record('PoolA', i).randomize().free()
    yield Case('HandleFireButton', {'BP': s('PrimaryRecord')}, w.writes(), LOOP, name='targetless missile evicts',
               expect=lambda m, r: check(m.word(s('PoolB')) == 0 and m.word(s('MissileAmmo')) == 1, 'evicted without a missile'))
    # A pod side shot whose allocation evicts a KIND_ENEMY record (not in play: pool B holds
    # none) continues from the SI RemoveRecord's group clearing left (GroupTable + 2 *
    # slot), not from the pod: the shot is placed from GroupTable bytes.
    w = fire_world(rng, pair, demo=False)
    w.word('WeaponMode', 5).word('MissileAmmo', 0).word('SideShotsEnabled', 1).word('ShotsLiveSide', 0)
    w.word('ShotsLiveType9', 1).word('MapScrollPos', 0x1000).word('FireLatch', 0).byte('InputBits', K.IN_BUTTON_PRIMARY)
    w.word('DemoActive', 0).word('ShotsLiveFrontPod', 0)
    for name in PODS: w.word(name, 0xFFFF)
    pod = w.record('PoolA', 7).live(kind=K.KIND_POD, type=0, size=1, x=0x60, y=0x80)
    w.word('TrailingPodNear', pod.at)
    w.fill('PoolB', K.POOL_B_COUNT, kind=K.KIND_TYPED, type=0x0A, size=0)
    w.record('PoolB', 0).live(kind=K.KIND_ENEMY, type=0x14, size=1, slot_index=3)
    w.record('PoolB', 9).free(); w.record('PoolB', 20).free()
    w.word('PoolBCursor', s('PoolB')).put('GroupTable', bytes(range(0x20, 0x40)))
    yield Case('HandleFireButton', {'BP': s('PrimaryRecord')}, w.writes(), LOOP, name='pod side shot from stray SI',
               expect=lambda m, r: check(m.word(s('PoolB') + K.REC_TYPE) == 5 and m.word(s('PoolB') + K.REC_X) != 0x64,
                                         "side shot placed from RemoveRecord's SI"))
    # The demo's caption blitter leaves BP = its row bytes; step 10h's SpawnEnemyHere then
    # copies the position at that BP into the type 51h enemy's REC_SAVED_X/Y.
    w = demo_world(rng, pair, step=0x0F)
    w.word('DemoStepTimer', 1)
    yield Case('RunDemoScriptFrame', {'BP': s('PrimaryRecord')}, w.writes(), DEMO, name='step 10h stale BP spawn')

def cases(rng, scale, pair):
    s = pair.sym
    player = s('PrimaryRecord')
    n = 1500 * scale
    yield from quirks(rng, pair)
    for i in range(n):
        w = fire_world(rng, pair)
        yield Case('HandleFireButton', {'BP': player}, w.writes(), LOOP, name=f'#{i}')
    for i in range(n // 2):
        w = beam_world(rng, pair)
        bp = player if i % 8 else w.any_record(('PoolA', 'PoolB')).at     # the demo's stale BP
        yield Case('UpdateBeam', {'BP': bp}, w.writes(), LOOP, name=f'#{i}')
    for i in range(n // 2):
        w = fire_world(rng, pair)
        yield Case('FindMissileTarget', {'BP': w.slot('PoolB', rng.randrange(34))}, w.writes(), NOT_BX_CX,
                   outputs=('BX',), name=f'#{i}')
    for i in range(n // 2):
        w = demo_world(rng, pair)
        yield Case('RunDemoScriptFrame', {'BP': rng.choice((player, 0, 0x1234, w.slot('PoolA', 0)))}, w.writes(), DEMO, name=f'#{i}')
    # Real ASM callers: the player frame (keyboard fire) and the homing missile's relock.
    for i in range(n // 4):
        w = key_world(rng, pair)
        yield Case('UpdatePlayerFrame', {}, w.writes(), ('SP', 'DS', 'SS'), name=f'#{i}')
    for i in range(n // 4):
        w = fire_world(rng, pair)
        m = w.record('PoolB', rng.randrange(34)).live(kind=K.KIND_TYPED, type=0x0A, size=0, player_shot=1, field_1c=0)
        p = w.record('PrimaryRecord', 0)
        m.set(x=(p.get('x') + 0x0C) & ~3, y=(p.get('y') + 0x0A) & ~3)   # at the player: relock
        yield Case('Type0AHomingMissile', {'BP': m.at}, w.writes(), LOOP, name=f'relock #{i}')
    # Sequences: fire every frame with the beam and the whole record update in between.
    for i in range(20 * scale):
        w = fire_world(rng, pair, frames=True)
        if i % 2: beam(w)
        steps = [Case('HandleFireButton', {'BP': player}, w.writes(), LOOP, name=f'world {i} fire 0')]
        for f in range(1, rng.choice((4, 8, 12))):
            steps.append(Case('UpdateBeam', {'BP': player}, (), LOOP, name=f'world {i} beam {f}'))
            steps.append(Case('HandleFireButton', {'BP': player}, (), LOOP, name=f'world {i} fire {f}'))
            steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'world {i} records {f}'))
            steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'world {i} tick {f}'))
        yield steps
    # Demo frames across step changes (the real loop minus drawing and the input poll).
    for i in range(20 * scale):
        w = demo_world(rng, pair, step=i % 0x12, frames=True)
        w.word('DemoStepTimer', rng.choice((1, 2, 3, 0x15)))
        steps = [Case('RunDemoScriptFrame', {'BP': player}, w.writes(), DEMO, name=f'demo {i} frame 0')]
        for f in range(1, 8):
            steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'demo {i} records {f}'))
            steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'demo {i} tick {f}'))
            steps.append(Case('RunDemoScriptFrame', {'BP': player}, (), DEMO, name=f'demo {i} frame {f}'))
        yield steps

# Plausible translation slips; each must make this suite fail (python tools/difftest.py --mutants weapons).
MUTANTS = [
    ('weapons.c', 'if (FireLatch != 0 && RapidFireEnabled != 1', 'if (FireLatch != 0 && RapidFireEnabled == 0'),
    ('weapons.c', 'if (MapScrollPos <= MAP_INTRO_END_POS && DemoActive == 0)', 'if (MapScrollPos < MAP_INTRO_END_POS && DemoActive == 0)'),
    ('weapons.c', 'if (MissilesLive == 1) return;', 'if (MissilesLive != 0) return;'),
    ('weapons.c', 'if ((*pod)->x > 0x58) shot->direction', 'if ((sword)(*pod)->x > 0x58) shot->direction'),
    ('weapons.c', '    ShotsLiveMain += 2;\r\n', '    ShotsLiveMain += 1;\r\n'),
    ('weapons.c', 'if (n == 0) r = POOL_B;', 'if (n == 0) r = POOL_B + 1;'),
    ('weapons.c', '    shot->y = (*pod)->y + 4;\r\n    shot->x &= 0xFFFC;', '    shot->y = (*pod)->y + 4;\r\n    shot->x &= 0xFFF8;'),
    ('weapons.c', '    shot = alloc_player_shot_si(pod);\r\n    shot->x = (*pod)->x + 4;', '    shot = alloc_player_shot();\r\n    shot->x = (*pod)->x + 4;'),
    ('weapons.c', 'if (((Record *)*(word *)(BeamListEnd - 4))->x == 0xC8) goto align;', 'if (((Record *)*(word *)(BeamListEnd - 2))->x == 0xC8) goto align;'),
    ('weapons.c', 'TargetSearchCursor = (word)(r + 1);', 'TargetSearchCursor = (word)r;'),
    ('weapons.c', 'bp = draw_demo_caption(DrawDemoCaption, DemoScript[DemoStep * 3], bp);', 'draw_demo_caption(DrawDemoCaption, DemoScript[DemoStep * 3], bp);'),
    ('weapons.c', 'case 10: case 12: case 13: case 14: case 15: ++WeaponMode; break;', 'case 10: case 12: case 13: case 14: ++WeaponMode; break;'),
    ('weapons.asm', 'FindMissileTarget:\r\n    push ax\r\n', 'FindMissileTarget:\r\n'),
]

# Coverage-guided differential fuzzing (python tools/fuzz.py weapons N).
from fuzz import Target
import hybrid as _hybrid
REGION = [n for n, f in _hybrid.owned_labels().items() if f == 'weapons.c']

def _slots(pool, count):
    return lambda pair: [pair.sym(pool) + RECORD * i for i in range(count + 1)]

def _pods(pair):
    return [0xFFFF] + [pair.sym('PoolA') + RECORD * i for i in range(K.POOL_A_COUNT)]

# Preconditions: unchecked tables (WeaponMode 0..5, DemoStep 0..12h at entry, the ship's
# REC_SPRITE 0..0Eh indexing MuzzleOffsets; the mutator also moves BP to other records)
# and pointers that only ever hold their table/pool addresses.
DOMAINS = {'sprite': range(0x0F), 'SfxEnabled': (0, 1), 'WeaponMode': range(6), 'DemoStep': range(0x13), 'MapScrollPos': range(K.MAP_END_POS + 1),
           'TargetSearchCursor': _slots('PoolA', K.POOL_A_COUNT), 'PoolBCursor': _slots('PoolB', K.POOL_B_COUNT),
           'BeamListEnd': lambda pair: range(pair.sym('BeamList'), pair.sym('BeamListTerminator') + 1, 2),
           **{p: _pods for p in PODS}}
FIRE_GLOBALS = ('SfxEnabled', 'InputBits', 'FireLatch', 'RapidFireEnabled', 'FrameCount16', 'MapScrollPos', 'DemoActive', 'DemoStep',
                'WeaponMode', 'ShotsLiveMain', 'ShotsLiveType9', 'ShotsLiveSide', 'ShotsLiveFrontPod', 'MissileAmmo',
                'MissilesLive', 'SideShotsEnabled', 'TargetSearchCursor', 'PoolBCursor', 'BeamListEnd') + PODS
WATCH = ('ShotsLiveMain', 'ShotsLiveType9', 'ShotsLiveSide', 'ShotsLiveFrontPod', 'MissilesLive', 'MissileAmmo')

def _adopt(w, fw):
    """Take over a builder's world; every record's sprite inside the ship domain, since the
    mutator may move the entry BP (the ship) to any record of the state."""
    for r in fw._records.values(): r.set(sprite=r.get('sprite') % 0x0F)
    w._writes, w._records = fw._writes, fw._records

def _fire_seed(w):
    _adopt(w, fire_world(w.rng, w.pair))
    return {'BP': w.sym('PrimaryRecord')}

def _salvo_seed(w):
    """The full salvo gate open: past the intro, not the demo, no burst of any kind live."""
    fw = fire_world(w.rng, w.pair, demo=False)
    fw.word('MapScrollPos', K.MAP_INTRO_END_POS + 1 + w.rng.randrange(K.MAP_END_POS - K.MAP_INTRO_END_POS))
    fw.byte('InputBits', K.IN_BUTTON_PRIMARY | w.rng.choice((0, K.IN_XPLUS, K.IN_XMINUS))).word('FireLatch', 0)
    for name in ('ShotsLiveMain', 'ShotsLiveSide', 'ShotsLiveFrontPod', 'ShotsLiveType9'): fw.word(name, 0)
    fw.word('SideShotsEnabled', 1).word('SfxEnabled', w.rng.randrange(2))
    _adopt(w, fw)
    return {'BP': w.sym('PrimaryRecord')}

def _step_seed(w):
    """A demo step change this frame, at any step."""
    fw = demo_world(w.rng, w.pair)
    fw.word('DemoStepTimer', 1)
    _adopt(w, fw)
    return {'BP': w.sym('PrimaryRecord')}

def _beam_seed(w):
    _adopt(w, beam_world(w.rng, w.pair))
    return {'BP': w.sym('PrimaryRecord')}

def _target_seed(w):
    _adopt(w, fire_world(w.rng, w.pair))
    return {}

def _demo_seed(w):
    fw = demo_world(w.rng, w.pair, step=0 if w.rng.randrange(4) == 0 else None)
    if w.rng.randrange(2): fw.word('DemoStepTimer', 1)     # a step change this frame
    _adopt(w, fw)
    return {'BP': w.sym('PrimaryRecord')}

FUZZ = [
    Target('fire', 'HandleFireButton', _fire_seed, REGION, LOOP, types=(2, 5, 6, 7, 8, 9, 0x0A, 0x0C, 0x14, 1, 0x21, 0x22, 0x26),
           globals=FIRE_GLOBALS, watch=WATCH, domains=DOMAINS),
    Target('salvo', 'HandleFireButton', _salvo_seed, REGION, LOOP, types=(2, 5, 6, 7, 8, 9, 0x0A, 0x0C, 0x14),
           globals=FIRE_GLOBALS, watch=WATCH, domains=DOMAINS),
    Target('beam', 'UpdateBeam', _beam_seed, REGION, LOOP, types=(9, 2, 0x0A),
           globals=('ShotsLiveType9', 'FrameParity', 'BeamListEnd', 'PoolBCursor'), watch=('ShotsLiveType9',), domains=DOMAINS),
    Target('target', 'FindMissileTarget', _target_seed, REGION, NOT_BX_CX, outputs=('BX',), types=TARGET_TYPES,
           globals=('TargetSearchCursor',), domains=DOMAINS),
    Target('demo', 'RunDemoScriptFrame', _demo_seed, REGION, DEMO, types=(9, 2, 0x0A, 0x0C),
           globals=FIRE_GLOBALS + ('DemoStepTimer', 'DemoFireCycle', 'SelectedUpgradeSlot'), watch=('DemoStep', 'WeaponMode') + WATCH,
           domains=DOMAINS),
    Target('steps', 'RunDemoScriptFrame', _step_seed, REGION, DEMO, types=(9, 2, 0x0A, 0x0C),
           globals=('DemoStep', 'SfxEnabled', 'SelectedUpgradeSlot', 'WeaponMode', 'MissileAmmo', 'SideShotsEnabled'),
           watch=('DemoStep', 'WeaponMode'), domains=DOMAINS),
]
