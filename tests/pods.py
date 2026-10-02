"""Pods region (c/pods.c, c/combat.c): the front, side and trailing pods, the upgrade selector with its
condition and apply routines, RemoveRecord and the evicting pool A allocator, the explosion
steps, pickups, the player hit tests, the BCD score, the ship's pod-balance nudges and the
demo steps that launch pods.

Entries are the bridge labels (c/pods.asm) and their real callers: UpdateAllRecords
(KIND_POD), Type01ExplosionAnimation, UpdatePickup, FinishRecordUpdate, UpdatePlayerFrame,
StoreApplyHistoryAndConditionalPlacement and RunDemoScriptFrame (c/weapons.c), plus whole
frames (UpdatePlayerFrame, UpdateAllRecords, TickFrameTimers) over worlds with pods,
pickups and enemies. Register contracts are the oracle's: the registers listed are kept,
the rest are scratch.

The level map is this suite's fixed random window (MAP); ByteAttributeTable decides per
case which bytes are solid for the pods' terrain probe.
"""
from difftest import Case, ALL_REGS
from world import World, K, RECORD
from fuzz import Target
import hits as H
import weapons as WP
import random, struct
import hybrid as _hybrid

REGION = [n for n, f in _hybrid.owned_labels().items() if f in ('pods.c', 'combat.c')]
LOOP = ('BP', 'SP', 'DS', 'SS')
FREE = ('SP', 'DS', 'SS')
SIDE = ('SidePodLeftInner', 'SidePodRightInner', 'SidePodLeftOuter', 'SidePodRightOuter')
TRAILING = ('TrailingPodNear', 'TrailingPodFar')
PODS = SIDE + TRAILING + ('FrontPodRecord',)
SLOTS = ('UpgradeSlot0', 'UpgradeSlot1', 'UpgradeSlot2', 'UpgradeSlot3')
LIST_LENGTHS = (7, 3, 4, 3)             # entries of UpgradeList0..3 before the FFFFh end
ICONS = (0x24, 0, 1, 2, 3, 4, 5, 6, 7, 9, 0x0A, 0x0B, 0x0D, 0x0E)   # the lists' panel images
W = lambda v: struct.pack('<H', v & 0xFFFF)

MAP = random.Random(0x90D5).randbytes(0x10000)

def install_map(pair):
    if pair.a.map is not MAP: pair.set_map(MAP)

def terrain(w, open_share=None):
    rng = w.rng
    p = rng.choice((0.5, 0.85, 0.97, 1.0)) if open_share is None else open_share
    w.put('ByteAttributeTable', bytes(0 if rng.random() < p else rng.choice((1, 2, 0x80)) for _ in range(256)))
    w.word('ScrollSubRow', rng.randrange(16))

def upgrades(w, selected=None):
    """The four HUD slots: icon and index within their lists (the icon indexes
    PanelImageOffsets, the index the list: both unchecked), a selection (or none), the
    weapon, side shots and missiles."""
    rng = w.rng
    for name, n in zip(SLOTS, LIST_LENGTHS):
        w.word(name, rng.choice(ICONS)).word(name, rng.randrange(n + 1), K.UPGRADE_SLOT_INDEX // 2)
    w.word('SelectedUpgradeSlot', rng.choice((0xFFFF, 0, 1, 2, 3)) if selected is None else selected)
    w.word('WeaponMode', rng.randrange(6)).word('SideShotsEnabled', rng.randrange(2))
    w.word('MissileAmmo', rng.choice((0, 0, 1, 4)))

def pickup(w, index, item=None, **fields):
    rng = w.rng
    item = rng.randrange(5) if item is None else item
    r = w.record('PoolA', index).live(kind=K.KIND_PICKUP, type=0, size=1, item_index=item)
    return r.set(sprite=0x46 + item, slot_index=0xFFFF, **fields)

def pod_record(w, index, name):
    rng = w.rng
    r = w.record('PoolA', index).live(kind=K.KIND_POD, size=1, hit_points=rng.choice((1, 1, 2, 3, 0x14, 0x50, 0)))
    r.set(sprite=0x0F if name == 'FrontPodRecord' else rng.choice((0x14, 0x18, 0x19, 0x0F if rng.randrange(8) == 0 else 0x15)),
          y=rng.randrange(0x20, 0xC0) if rng.randrange(4) else rng.choice((0, 4, 0x0F, 0xFFF8, 0x7FF8, 0x8004)),
          x=r.get('x') if rng.randrange(4) else rng.choice((0, 3, 0x0F, 0xFFFC, 0x7FFC, 0x8003)), draw_pass=1)
    w.word(name, r.at)
    return r

def world(rng, pair, pods=0.6, crowd=0.6, full=None):
    """A mid-game world: the hits world (player, difficulty, groups, segmented boss), the
    map, upgrades, energy, and pool A holding pods in their slots, enemies, pickups,
    the exhaust and stale free slots (all of pool A live when `full`)."""
    w = H.world(rng, pair)
    install_map(pair); terrain(w)
    upgrades(w)
    p = w.record('PrimaryRecord', 0)
    if rng.randrange(8) == 0: p.set(sprite=3)
    w.word('DemoActive', 1 if rng.randrange(6) == 0 else 0)
    w.word('MapScrollPos', rng.choice((K.MAP_INTRO_END_POS, K.MAP_INTRO_END_POS + 1, rng.randrange(K.MAP_INTRO_END_POS, K.MAP_END_POS + 1))))
    w.word('LevelEndPhase', rng.choice((0, 0, 0, 0, 0, 1, 3)))
    w.word('FrameParity', rng.randrange(2)).word('SlowCount4', rng.randrange(4))
    w.word('EnergyTanks', rng.choice((0xFFFF, 0, 1, 2, 3))).word('EnergyPoints', rng.randrange(1, 0x19))
    w.word('Fuel', rng.choice((0x58, 0x20, 1))).word('RefuelActive', rng.randrange(2)).byte('AllCheatsFlag', 0)
    w.byte('BonusKeysEnabled', rng.randrange(2)).byte('EasyHitToggle', rng.randrange(2))
    w.word('SidePodSpreadLeft', rng.choice((0, 0, 4, 8))).word('SidePodSpreadRight', rng.choice((0, 0, 4, 8)))
    w.byte('ClampXLowSeen', rng.randrange(2)).byte('ClampXHighSeen', rng.randrange(2))
    w.word('PoolACursor', w.slot('PoolA', rng.randrange(K.POOL_A_COUNT)))
    free = list(range(K.POOL_A_COUNT)); rng.shuffle(free)
    for name in PODS:
        if rng.random() < pods: pod_record(w, free.pop(), name)
        else: w.word(name, 0xFFFF)
    if full is None: full = rng.randrange(5) == 0
    for i in free:
        k = rng.random()
        if full or k < crowd:
            j = rng.randrange(10)
            if j < 5: H.enemy(w, i)
            elif j < 8: pickup(w, i)
            elif j == 8: w.record('PoolA', i).live(kind=K.KIND_EXHAUST, type=0, size=1)
            else: w.record('PoolA', i).live(kind=K.KIND_POD, size=1)          # a pod in no slot
        else:
            w.record('PoolA', i).randomize().free()
            w.record('PoolA', i).set(size_class=rng.randrange(3), slot_index=rng.choice((0xFFFF, rng.randrange(16))))
    return w

def near(w, r, others=3):
    """Records around r (within the 10h collision window, and just outside it). The front
    pod (sprite 0Fh) is first moved to the ship (FrontPodOffsets), so its crowd is there."""
    rng = w.rng
    y, x = r.get('y'), r.get('x')
    if r.get('sprite') == 0x0F:
        p = w.record('PrimaryRecord', 0)
        y, x = p.get('y') + (-5, -0x0D, -0x0E, 0)[min(p.get('sprite'), 3)], p.get('x') + 8
    for _ in range(others):
        o = w.record('PoolA', rng.randrange(K.POOL_A_COUNT))
        if o.at == r.at or o.get('kind') == K.KIND_POD: continue
        if rng.randrange(2): H.enemy(w, (o.at - w.slot('PoolA', 0)) // RECORD, size_class=1)
        else: pickup(w, (o.at - w.slot('PoolA', 0)) // RECORD)
        o.set(y=y + rng.choice((-0x11, -0x10, -4, 0, 5, 0x10, 0x11)),
              x=x + rng.choice((-0x11, -0x10, -3, 0, 7, 0x10, 0x11)), status=1)

def a_pod(w):
    """A pod of the world (added when there is none) and its slot name."""
    rng = w.rng
    name = rng.choice(PODS)
    at = struct.unpack('<H', dict(w.writes()).get(w.sym(name), W(0xFFFF)))[0]
    if at == 0xFFFF:
        return pod_record(w, rng.randrange(K.POOL_A_COUNT), name), name
    return w.record('PoolA', (at - w.slot('PoolA', 0)) // RECORD), name

def beam_or_not(w):
    if w.rng.randrange(3) == 0:
        WP.beam(w)
    else:
        w.put('BeamList', W(0xFFFF) * 26).word('ShotsLiveType9', 0)

def _upgrade_dispatch_cases(rng, pair):
    """Drive every frozen list condition and apply token through its C-owned caller."""
    condition_rows = (
        (0, 1, 0), (0, 2, 1), (0, 3, 2), (0, 4, 3), (0, 5, 4), (0, 6, 5),
        (1, 1, 6), (1, 2, 7), (2, 1, 9), (2, 2, 0x0A), (2, 3, 0x0B),
        (3, 1, 0x0D), (3, 2, 0x0E),
    )

    def condition_world(slot, index, available):
        w = world(rng, pair, pods=0, crowd=0, full=False)
        w.fill('PoolA', 0)
        w.word('PoolACursor', w.slot('PoolA', 0))
        w.byte('BonusKeysEnabled', 0)
        w.word('SelectedUpgradeSlot', (slot - 1) & 3)
        w.word(SLOTS[slot], index, K.UPGRADE_SLOT_INDEX // 2)
        if slot == 0:
            mode = (K.WEAPON_SINGLE, K.WEAPON_HEAVY, K.WEAPON_FORK,
                    K.WEAPON_TWIN_RISING3, K.WEAPON_TWIN_RISING16,
                    K.WEAPON_BEAM)[index - 1]
            w.word('WeaponMode', mode if not available else 0xFFFF)
        elif slot == 1:
            if index == 1: w.word('SideShotsEnabled', 1 if not available else 0)
            else: w.word('MissileAmmo', 1 if not available else 0)
        elif slot == 2:
            if index == 1:
                if not available: w.word('FrontPodRecord', w.slot('PoolA', 0))
            elif index == 2:
                w.record('PrimaryRecord', 0).set(sprite=0)
                if not available:
                    for name, n in zip(PODS, range(len(PODS))):
                        w.word(name, w.slot('PoolA', n))
                    w.word('FrontPodRecord', w.slot('PoolA', 0))
            else:
                w.record('PrimaryRecord', 0).set(sprite=2 if available else 0)
                if not available:
                    for name, n in zip(PODS, range(len(PODS))):
                        w.word(name, w.slot('PoolA', n))
                    w.word('FrontPodRecord', w.slot('PoolA', 0))
        else:
            w.record('PrimaryRecord', 0).set(sprite=(0 if available else (1 if index == 1 else 2)))
        return w

    # Entry zero is the shared always-false condition; each other frozen predicate gets a
    # true and false input, so both token routing and the scan-after-rejection path run.
    for slot, index, icon in ((0, 0, 0x24),) + condition_rows:
        for available in ((False,) if index == 0 else (True, False)):
            w = condition_world(slot, index, available)
            label = f'condition slot {slot} entry {index} ' + ('available' if available else 'rejected')

            def expect(m, regs, slot=slot, index=index, icon=icon, available=available):
                got = m.word(pair.sym(SLOTS[slot]) + K.UPGRADE_SLOT_ICON)
                if available:
                    check(got == icon, f'{label}: selected condition offers its own icon')
                    check(m.word(pair.sym(SLOTS[slot]) + K.UPGRADE_SLOT_INDEX) == index,
                          f'{label}: available entry remains selected')
                else:
                    check(got != icon, f'{label}: rejected entry advances or exhausts the list')

            yield Case('PickupUpgradeSelector', {}, w.writes(), LOOP, expect=expect, name=label)

    actions = (
        (0, 1, 'weapon', K.WEAPON_SINGLE), (0, 2, 'weapon', K.WEAPON_HEAVY),
        (0, 3, 'weapon', K.WEAPON_FORK), (0, 4, 'weapon', K.WEAPON_TWIN_RISING3),
        (0, 5, 'weapon', K.WEAPON_TWIN_RISING16), (0, 6, 'weapon', K.WEAPON_BEAM),
        (1, 1, 'side_shots', 1), (1, 2, 'missiles', 4),
        (2, 1, 'front_pod', 0), (2, 2, 'side_pods', 0), (2, 3, 'trailing_pod', 0),
        (3, 1, 'ship_form', 1), (3, 2, 'ship_form', 2),
    )
    for slot, index, effect, value in actions:
        w = world(rng, pair, pods=0, crowd=0, full=False)
        w.fill('PoolA', 0)
        w.word('PoolACursor', w.slot('PoolA', 0))
        w.record('PrimaryRecord', 0).set(sprite=0, x=0x60, y=0x90)
        w.byte('BonusKeysEnabled', 0).byte('SfxEnabled', 1).byte('SfxActive', 1).byte('SfxRequest', 0x55)
        for name in PODS: w.word(name, 0xFFFF)
        w.word('SelectedUpgradeSlot', slot).word(SLOTS[slot], index, K.UPGRADE_SLOT_INDEX // 2)
        label = f'apply slot {slot} entry {index}'

        def expect(m, regs, effect=effect, value=value, label=label):
            if effect == 'weapon': check(m.peek('WeaponMode') == value, label + ': weapon mode')
            elif effect == 'side_shots': check(m.peek('SideShotsEnabled') == value, label + ': side-shot state')
            elif effect == 'missiles': check(m.peek('MissileAmmo') == value, label + ': missile count')
            elif effect == 'front_pod': check(m.peek('FrontPodRecord') != 0xFFFF, label + ': front pod slot')
            elif effect == 'side_pods':
                check(m.peek('SidePodLeftInner') != 0xFFFF and m.peek('SidePodRightInner') != 0xFFFF,
                      label + ': inner side pod slots')
            elif effect == 'trailing_pod': check(m.peek('TrailingPodNear') != 0xFFFF, label + ': trailing pod slot')
            elif effect == 'ship_form':
                check(m.word(pair.sym('PrimaryRecord') + K.REC_SPRITE) == value, label + ': ship form')
                check((m.peek('SfxActive') & 0xFF) == 0 and (m.peek('SfxRequest') & 0xFF) == 9,
                      label + ': sound reset and purchase request')
            if effect != 'ship_form':
                check(m.peek('SelectedUpgradeSlot') == 0xFFFF and (m.peek('SfxRequest') & 0xFF) == 9,
                      label + ': purchase closes selection and requests sound')

        yield Case('ApplySelectedUpgrade', {}, w.writes(), LOOP + ('BX',), expect=expect, name=label)

    # The ordinary first list entry calls ReturnNear: it leaves the selection and does not
    # issue the purchase sound even though the caller still redraws the offered list.
    w = world(rng, pair, pods=0, crowd=0, full=False)
    w.fill('PoolA', 0).word('SelectedUpgradeSlot', 0).word('UpgradeSlot0', 0, K.UPGRADE_SLOT_INDEX // 2)
    w.byte('SfxEnabled', 1).byte('SfxRequest', 0x55)
    def no_op(m, regs):
        check(m.peek('SelectedUpgradeSlot') == 0 and (m.peek('SfxRequest') & 0xFF) == 0x55,
              'ReturnNear entry keeps selection and does not sound as a purchase')
    yield Case('ApplySelectedUpgrade', {}, w.writes(), LOOP + ('BX',), expect=no_op,
               name='ReturnNear no-op entry')

def cases(rng, scale, pair):
    s = pair.sym
    n = 300 * scale
    player = s('PrimaryRecord')
    yield from _upgrade_dispatch_cases(rng, pair)
    # UpdatePod through its label (the KIND_POD dispatch of the record pass is in tests/frame.py).
    for i in range(n * 2):
        w = world(rng, pair)
        pod, name = a_pod(w)
        if rng.randrange(2): near(w, pod, rng.randrange(1, 5))
        if rng.randrange(4) == 0:
            pod.set(x=rng.randrange(0, 0xC1, 16) + rng.choice((0, 1)), hit_points=1)
        yield Case('UpdatePod', {'BP': pod.at}, w.writes(), LOOP, name=f'{name} #{i}')
    # RemoveRecord of every class; the missile refreshes the upgrade slots, the beam frees its links.
    for i in range(n):
        w = world(rng, pair)
        beam_or_not(w)
        r = w.any_record(('PoolA', 'PoolB'))
        k = rng.randrange(4)
        if k == 0 and r.at < w.slot('PoolB', 0): H.enemy(w, (r.at - w.slot('PoolA', 0)) // RECORD)
        elif k == 0: r.live(kind=K.KIND_ENEMY, type=0x14, size=1)         # not in play: pool B holds no enemies
        elif k == 1: r.live(kind=K.KIND_POD, size=1)
        else: r.live(kind=rng.choice((K.KIND_TYPED, K.KIND_TYPED, K.KIND_PICKUP, 0)), type=rng.choice((5, 6, 7, 8, 9, 0x0A, 0x0C, 2, 3)))
        for name in ('ShotsLiveMain', 'ShotsLiveSide', 'ShotsLiveFrontPod', 'MissilesLive'):
            w.word(name, rng.choice((0, 1, 3)))
        yield Case('RemoveRecord', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    # Explosion steps through Type01ExplosionAnimation (its size table), wrecks of turrets.
    for i in range(n):
        w = world(rng, pair)
        r = w.record('PoolA', rng.randrange(K.POOL_A_COUNT)).live(kind=K.KIND_ENEMY, type=1, size=rng.choice((1, 2, 0)))
        r.set(anim_counter=rng.choice((7, 8, 9, 0x0A, 0x0B, 0x0C, 0x0D)), prev_type=rng.choice((0x24, 0x25, 0x14, 0x26)))
        w.word('FrameParity', 1 if rng.randrange(4) else 0)
        yield Case('RunTypeHandler', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')   # Type01ExplosionAnimation
    # Pickups: UpdatePickup (SmallRecordHitsPlayer, CollectPickup; c/enemies.c).
    for i in range(n):
        w = world(rng, pair)
        r = pickup(w, rng.randrange(K.POOL_A_COUNT))
        p = w.record('PrimaryRecord', 0)
        r.set(y=p.get('y') + rng.randrange(-0x16, 0x1C), x=p.get('x') + rng.randrange(-0x14, 0x1C))
        if rng.randrange(8) == 0: r.set(y=rng.choice((0xFFFF, 0x8000, 0)))
        yield Case('UpdatePickup', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    # Body contact: FinishRecordUpdate (CheckRecordHitsPlayer, RemoveRecord at the bounds).
    for i in range(n):
        w = world(rng, pair)
        r = H.enemy(w)
        p = w.record('PrimaryRecord', 0)
        if rng.randrange(3): r.set(x=p.get('x') + rng.randrange(-0x1A, 0x1A), y=p.get('y') + rng.randrange(-0x1A, 0x1A))
        if rng.randrange(6) == 0: r.set(y=rng.choice((0xFF3F, 0xF0, 0xFFEB)))
        if rng.randrange(6) == 0: r.set(kind=K.KIND_PICKUP)
        H.shots_near(w, r, rng.choice((1, 2)))
        yield Case('FinishRecordUpdate', {'BP': r.at}, w.writes(), LOOP, name=f'#{i}')
    # The upgrade selector: the secondary button, pickup item 1, the refresh.
    for i in range(n):
        w = world(rng, pair, full=rng.randrange(3) == 0)
        yield Case('ApplySelectedUpgrade', {'BP': rng.randrange(0x10000), 'BX': rng.randrange(0x10000)}, w.writes(),
                   LOOP + ('BX',), name=f'#{i}')
        yield Case('PickupUpgradeSelector', {}, w.writes(), LOOP, name=f'#{i}')
    # Side pod placement and the ship's X nudges (UpdatePlayerFrame's calls), from the ship.
    for i in range(n):
        w = world(rng, pair)
        p = w.record('PrimaryRecord', 0)
        p.set(sprite=rng.choice((0, 1, 2, 3)), x=rng.choice((0, 1, 2, 0x10, 0x58, 0xAE, 0xAF, 0xB0, 0xB1, rng.randrange(0xB1))))
        w.byte('InputBits', rng.randrange(256))
        label = ('PlaceSidePods', 'AdjustRecordXFromCounts', 'DecRecordXTwice', 'IncRecordXTwice',
                 'StoreApplyHistoryAndConditionalPlacement')[i % 5]
        yield Case(label, {'BP': player}, w.writes(), LOOP, name=f'#{i}')
    # Reset, score, the remaining single entries.
    for i in range(n // 4):
        w = world(rng, pair)
        yield Case('ResetPoolAAndUpgrades', {}, w.writes(), FREE, name=f'#{i}')
    for i in range(n):
        score = bytes(rng.choice((rng.randrange(256), rng.choice((0x99, 0x09, 0x90, 0x9A, 0xFA, 0xFF, 0))))  for _ in range(4))
        yield Case('AddScoreBcd', {'BX': rng.choice((0x20, 0x30, 0x60, 0x0001, 0x9999, rng.randrange(0x10000)))},
                   [(s('ScoreBcd'), score)], ALL_REGS, name=f'#{i}')
    for i in range(n // 2):
        w = world(rng, pair)
        pod, _ = a_pod(w)
        yield Case('PodTerrainHit', {'BP': pod.at}, w.writes(), LOOP, flags=('CF',), name=f'#{i}')
        yield Case('DestroyRecordAtBX', {'BX': H.enemy(w).at}, w.writes(), LOOP + ('BX',), name=f'#{i}')
    # The ship's frame (secondary button, nudges, pod placement) with the keyboard.
    for i in range(n // 2):
        w = key_world(rng, pair)
        yield Case('UpdatePlayerFrame', {}, w.writes(), FREE, name=f'#{i}')
    # Demo steps 1..7 (pods launched home as type 50h, ship forms) through RunDemoScriptFrame.
    for i in range(n // 2):
        w = WP.demo_world(rng, pair, step=i % 7)
        w.word('DemoStepTimer', 1)
        if rng.randrange(3) == 0: w.fill('PoolA', K.POOL_A_COUNT, kind=K.KIND_ENEMY, type=0x14, size=1)
        yield Case('RunDemoScriptFrame', {'BP': player}, w.writes(), FREE, name=f'step {i % 7 + 1} #{i}')
    yield from quirks(pair)
    yield from sequences(rng, scale, pair)

def key_world(rng, pair):
    """UpdatePlayerFrame with the keyboard: Tab (secondary), Space, arrows; key 3 up (its
    bonus-key wait would hang without the keyboard interrupt)."""
    w = world(rng, pair)
    kd = pair.sym('KeyDownTable')
    w.word('InputDeviceMode', 0).word('LevelEndPhase', 0)
    w.word('EnergyTanks', rng.randrange(4)).word('Fuel', rng.randrange(1, 0x59))
    for scan in (K.SCAN_TAB, K.SCAN_SPACE, K.SCAN_LEFT, K.SCAN_RIGHT, K.SCAN_UP, K.SCAN_DOWN):
        w.byte(kd + scan, K.KEY_STATE_DOWN if rng.randrange(2) else K.KEY_STATE_UP)
    w.word('MapScrollPos', rng.choice((K.MAP_INTRO_END_POS, K.MAP_INTRO_END_POS + 1, rng.randrange(K.MAP_START_POS, K.MAP_END_POS + 1))))
    return w

# Pool A types for the frame sequences (handlers that are safe on randomised fields).
SEQUENCE_TYPES = (0x22, 0x35, 0x36, 0x14, 0x1D, 0x1E, 0x2E, 0x48, 0x81, 0x93, 0x30)

def sequences(rng, scale, pair):
    """Whole frames: the ship (upgrades, nudges, pod placement), every record (pods collide,
    collect, explode; pickups fall; enemies touch the ship) and the timers."""
    for i in range(24 * scale):
        w = key_world(rng, pair)
        w.word('DemoActive', 0).word('LevelEndPhase', 0)
        for k in range(K.POOL_A_COUNT):
            r = w.record('PoolA', k)
            if r.get('kind') == K.KIND_ENEMY and r.get('status'):
                H.enemy(w, k, type=rng.choice(SEQUENCE_TYPES), y=rng.randrange(0x20, 0xA8), x=rng.randrange(0, 0xC1))
            if r.get('kind') == K.KIND_PICKUP and r.get('status'):
                r.set(y=rng.randrange(0x40, 0xC0), x=rng.randrange(0, 0xC1))
            r.set(saved_x=rng.randrange(0, 0xC1), saved_y=rng.randrange(0x10, 0xC0), direction=rng.randrange(8))
        for k in range(K.POOL_B_COUNT):
            s_ = w.record('PoolB', k)
            if rng.randrange(3) == 0:
                s_.live(kind=K.KIND_TYPED, type=rng.choice((2, 4, 3)), size=0, player_shot=1, direction=0,
                        x=rng.randrange(0, 0xC8), y=rng.randrange(0x30, 0xC8), field_1c=0xFFFF, sprite=0x32)
                if s_.get('type') == 3: s_.set(player_shot=0, direction=4)
            else: s_.randomize().free()
        w.word('ShotsLiveType9', 0).put('BeamList', W(0xFFFF) * 26)
        steps = []
        for f in range(rng.choice((4, 8, 12))):
            first = w.writes() if f == 0 else ()
            steps.append(Case('UpdatePlayerFrame', {}, first, FREE, name=f'world {i} player {f}'))
            steps.append(Case('UpdateAllRecords', {}, (), LOOP[1:], name=f'world {i} records {f}'))
            steps.append(Case('TickFrameTimers', {}, (), LOOP[1:], name=f'world {i} tick {f}'))
        yield steps

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented quirk: ' + what)

def quirks(pair):
    """Surprising original behaviour, asserted on the oracle, then compared."""
    s = pair.sym
    rng = random.Random(0x90D)
    slot = lambda i: s('PoolA') + RECORD * i

    def base():
        w = World(pair, rng).plausible()
        install_map(pair); terrain(w, 1.0)
        w.word('DemoActive', 0).word('LevelEndPhase', 0).word('SegBossActive', 0).byte('SfxEnabled', 1)
        w.word('DifficultySetting', 2).word('MapScrollPos', 0x1000).word('LevelIndex', 1)
        w.put('GroupTable', bytes(32)).put('ScoreBcd', bytes(4))
        for name in PODS: w.word(name, 0xFFFF)
        for i in range(K.POOL_A_COUNT): w.record('PoolA', i).randomize().free()
        w.record('PrimaryRecord', 0).set(sprite=0, x=0x60, y=0x90)
        return w

    # A pod that loses its last hit point to an enemy destroys it twice: 30h + 30h points and
    # GROUP_LIVE - 2 (the group's drop comes one member early).
    w = base()
    pod = w.record('PoolA', 3).live(kind=K.KIND_POD, size=1, sprite=0x18, hit_points=1, x=0x40, y=0x50, save_buffer=1)
    w.word('SidePodLeftInner', pod.at)
    w.record('PoolA', 8).live(kind=K.KIND_ENEMY, type=0x30, size=1, x=0x44, y=0x52, slot_index=2, save_buffer=2)
    w.put('GroupTable', bytes([0, 0, 0, 0, 3, 1]) + bytes(26))
    yield Case('UpdatePod', {'BP': pod.at}, w.writes(), LOOP, name='pod kills an enemy twice',
               expect=lambda m, r: check(m.read(s('ScoreBcd'), 4) == b'\x60\0\0\0' and m.read(s('GroupTable') + 4, 1) == b'\1'
                                         and m.word(s('SidePodLeftInner')) == 0xFFFF and m.word(pod.at + K.REC_TYPE) == 1,
                                         'score and GROUP_LIVE counted twice'))
    # A dying ship (form 3) places a side pod from the next offset table's first pair.
    w = base()
    w.record('PrimaryRecord', 0).set(sprite=3, x=0x60, y=0x90)
    pod = w.record('PoolA', 4).live(kind=K.KIND_POD, size=1, sprite=0x18)
    w.word('SidePodLeftInner', pod.at).word('SidePodSpreadLeft', 0).word('SidePodSpreadRight', 0)
    yield Case('PlaceSidePods', {'BP': s('PrimaryRecord')}, w.writes(), LOOP, name='form 3 reads past the table',
               expect=lambda m, r: check(m.word(pod.at + K.REC_Y) == 0x90 + 0x10 and m.word(pod.at + K.REC_X) == 0x60 + 0x18,
                                         'LeftInner at form 3 uses RightInner (10h, 18h)'))
    # Ten failed tries: slot 1 with side shots and missiles held offers nothing (icon 24h).
    w = base()
    w.word('SelectedUpgradeSlot', 0).word('SideShotsEnabled', 1).word('MissileAmmo', 2)
    w.word('UpgradeSlot1', 6).word('UpgradeSlot1', 2, K.UPGRADE_SLOT_INDEX // 2)
    yield Case('PickupUpgradeSelector', {}, w.writes(), LOOP, name='ten tries (selection 0 -> 1)',
               expect=lambda m, r: check(m.word(s('UpgradeSlot1')) == 0x24 and m.word(s('UpgradeTries')) == 0x0A,
                                         'exhausted list shows 24h'))
    # A full pool A of pods: eviction removes PoolA[0] although it is the front pod, and the
    # new trailing pod reuses it: two slots name one record.
    w = base()
    for i in range(K.POOL_A_COUNT): w.record('PoolA', i).live(kind=K.KIND_POD, size=1)
    w.word('FrontPodRecord', slot(0)).word('SelectedUpgradeSlot', 2).word('UpgradeSlot2', 3, K.UPGRADE_SLOT_INDEX // 2)
    w.record('PrimaryRecord', 0).set(sprite=2)
    yield Case('ApplySelectedUpgrade', {}, w.writes(), LOOP + ('BX',), name='evicted front pod becomes a trailing pod',
               expect=lambda m, r: check(m.word(s('TrailingPodNear')) == slot(0) and m.word(s('FrontPodRecord')) == slot(0)
                                         and m.word(slot(0) + K.REC_SPRITE) == 0x14, 'PoolA[0] evicted and reused'))
    # A pod touching a pickup collects it (score 20h) and takes no hit.
    w = base()
    pod = w.record('PoolA', 3).live(kind=K.KIND_POD, size=1, sprite=0x0F, hit_points=1, x=0x40, y=0x50, save_buffer=1)
    w.word('FrontPodRecord', pod.at).record('PrimaryRecord', 0).set(x=0x38, y=0x5D)
    item = w.record('PoolA', 9).live(kind=K.KIND_PICKUP, type=0, size=1, item_index=0, x=0x40, y=0x48, save_buffer=2)
    yield Case('UpdatePod', {'BP': pod.at}, w.writes(), LOOP, name='pod collects a pickup',
               expect=lambda m, r: check(m.word(item.at) == 0 and m.read(s('ScoreBcd'), 1) == b'\x20'
                                         and m.word(pod.at + K.REC_HIT_POINTS) == 1, 'pickup collected, pod unhurt'))

# Plausible translation slips; each must make this suite fail (python tools/difftest.py --mutants pods).
MUTANTS = [
    ('pods.c', 'if (routine == (word)(main_routine)SingleShotAvailable) return single_shot_available();',
               'if (routine == (word)(main_routine)SingleShotAvailable) return heavy_shot_available();'), # table condition token
    ('pods.c', 'if (routine == (word)(main_routine)ApplyHeavyShot) { apply_heavy_shot(); return; }',
               'if (routine == (word)(main_routine)ApplyHeavyShot) { apply_single_shot(); return; }'),    # table apply token
    ('pods.c', 'if ((sword)y > (sword)(r->y + 0x10) || (sword)y < (sword)(r->y - 0x10)) continue;',
               'if (y > r->y + 0x10 || y < r->y - 0x10) continue;'),                                  # signedness
    ('pods.c', 'if (++UpgradeTries >= 0x0A) break;', 'if (++UpgradeTries > 0x0A) break;'),            # off by one
    ('pods.c', '    if (r->kind == KIND_POD) {\r\n        r->kind = KIND_TYPED;', '    if (r->kind == KIND_POD) {\r\n        r->kind = KIND_ENEMY;'),  # transition
    ('pods.c', '        pod->x = PLAYFIELD_MAX_X;\r\n        ClampXHighSeen = 1;', '        pod->x = PLAYFIELD_MAX_X;'),  # omitted side effect
    ('pods.c', 'if (r->kind != KIND_EXHAUST && r->kind != KIND_POD) break;', 'if (r->kind != KIND_POD) break;'),  # allocation
    ('combat.c', 'if ((sum & 0xFF) > 0x99 || carry) {', 'if (al > 0x99 || carry) {'),                    # DAA
    ('pods.c', '            FrontPodRecord = NO_SLOT;\r\n            destroy_record(enemy);\r\n            explode_pod(pod);',
               '            destroy_record(enemy);\r\n            explode_pod(pod);'),                   # slot kept
    # the CF result of a bridge (SmallRecordHitsPlayer's stub is gone: c/enemies.c calls it)
    ('pods.asm', 'call POD_TERRAIN_HIT\r\n    pop si\r\n    shr ax, 1\r\n', 'call POD_TERRAIN_HIT\r\n    pop si\r\n    or ax, ax\r\n'),
]

# Coverage-guided differential fuzzing (python tools/fuzz.py pods N [--save]).
def _pool_a(pair, extra=0): return [pair.sym('PoolA') + RECORD * i for i in range(K.POOL_A_COUNT + extra)]
def _pod_slots(pair): return [0xFFFF] + _pool_a(pair)

# Preconditions: the hits region's (size class, group slot, segmented-boss parts, level),
# pickup items 0..4 (PickupHandlers), the selection 0..3/FFFFh (UpgradeSlotPtrs), pod slots
# and cursors naming pool A records, the energy gauge's tank and point ranges, and the ship
# form 0..3 for side pod placement (the offset tables are unchecked).
DOMAINS = dict(H.DOMAINS, item_index=range(5), WeaponMode=range(6), SelectedUpgradeSlot=(0xFFFF, 0, 1, 2, 3), DemoActive=(0, 1),
               EnergyTanks=(0xFFFF, 0, 1, 2, 3), EnergyPoints=range(1, 0x19), DifficultySetting=range(4),
               LevelEndPhase=range(5), MapScrollPos=range(K.MAP_END_POS + 1), FrameParity=(0, 1), SlowCount4=range(4),
               PoolACursor=lambda pair: _pool_a(pair, 1), BonusKeysEnabled=(0, 1),
               ClampXLowSeen=(0, 1, 0x100, 0x101), SidePodSpreadLeft=range(9), SidePodSpreadRight=range(9),
               **{p: _pod_slots for p in PODS})
POD_GLOBALS = ('DemoActive', 'MapScrollPos', 'LevelEndPhase', 'DifficultySetting', 'FrameParity', 'SlowCount4',
               'SfxEnabled', 'SelectedUpgradeSlot', 'EnergyTanks', 'EnergyPoints') + PODS
UPGRADE_GLOBALS = ('SelectedUpgradeSlot', 'WeaponMode', 'SideShotsEnabled', 'MissileAmmo', 'SfxEnabled',
                   'PoolACursor', 'MissilesLive') + PODS
WATCH = ('SelectedUpgradeSlot', 'FrontPodRecord', 'SidePodLeftInner', 'TrailingPodNear', 'EncounterLiveCount')

def _update_seed(w):
    rng = w.rng
    _adopt(w, world(rng, w.pair))
    pod, _ = a_pod(w)
    if rng.randrange(2): near(w, pod, rng.randrange(1, 5))
    return {'BP': pod.at}

def _adopt(w, built):
    w._writes, w._records = built._writes, built._records
    return w

def _in_domain(seed):
    """Seed builder whose every record (also stale free ones, which the fuzzer may revive,
    and any record, since REC_KIND is mutated freely and may make it a pickup) meets DOMAINS."""
    def build(w):
        regs = seed(w)
        for r in w._records.values():
            if r.get('size_class') > 2: r.set(size_class=w.rng.randrange(3))
            if r.get('slot_index') != 0xFFFF: r.set(slot_index=r.get('slot_index') & 15)
            r.set(item_index=r.get('item_index') % 5)
        return regs
    return build

def _collide_seed(w):
    """A pod in a crowd: enemies and pickups inside and just outside its window."""
    _adopt(w, world(w.rng, w.pair, crowd=0.3))
    w.word('DemoActive', 0).word('MapScrollPos', 0x1000)
    pod, _ = a_pod(w)
    if w.rng.randrange(2): pod.set(hit_points=1)
    if w.rng.randrange(2): w.word('DifficultySetting', 1)
    near(w, pod, w.rng.randrange(2, 7))
    return {'BP': pod.at}

def _front_seed(w):
    """The front pod (placed at the ship first) in a crowd, over open terrain."""
    rng = w.rng
    _adopt(w, world(rng, w.pair, crowd=0.3))
    terrain(w, 1.0)
    w.word('DemoActive', 0).word('MapScrollPos', 0x1000).word('DifficultySetting', rng.randrange(1, 3))
    w.record('PrimaryRecord', 0).set(sprite=rng.randrange(3))
    pod = pod_record(w, rng.randrange(K.POOL_A_COUNT), 'FrontPodRecord').set(hit_points=rng.choice((1, 1, 2)))
    near(w, pod, rng.randrange(2, 7))
    return {'BP': pod.at}

def _remove_seed(w):
    rng = w.rng
    _adopt(w, world(rng, w.pair))
    beam_or_not(w)
    r = w.any_record(('PoolA', 'PoolB'))
    r.live(kind=rng.choice((K.KIND_ENEMY, K.KIND_POD, K.KIND_TYPED, K.KIND_TYPED)), type=rng.choice((5, 6, 7, 8, 9, 0x0A, 0x0C, 0x14, 1, 0x13)))
    r.set(size_class=rng.randrange(3), slot_index=rng.choice((0xFFFF, rng.randrange(16))))
    for name in ('ShotsLiveMain', 'ShotsLiveSide', 'ShotsLiveFrontPod', 'MissilesLive'): w.word(name, rng.choice((0, 1, 3)))
    return {'BP': r.at}

_upgrade_seeds = [0]
def _upgrade_seed(w):
    """Each slot and entry in turn (the fuzzer cannot move the slot index); sometimes a
    pool A of pods and the exhaust only (eviction falls back to PoolA[0])."""
    rng = w.rng
    _adopt(w, world(rng, w.pair, full=rng.randrange(3) == 0))
    k = _upgrade_seeds[0]; _upgrade_seeds[0] += 1
    slot = k % 4
    w.word('SelectedUpgradeSlot', slot)
    w.word(SLOTS[slot], (k // 4) % (LIST_LENGTHS[slot] + 1), K.UPGRADE_SLOT_INDEX // 2)
    if rng.randrange(6) == 0:
        for i in range(K.POOL_A_COUNT):
            w.record('PoolA', i).live(kind=rng.choice((K.KIND_POD, K.KIND_EXHAUST)), size=1)
    return {}

def _pickup_seed(w):
    rng = w.rng
    _adopt(w, world(rng, w.pair))
    r = pickup(w, rng.randrange(K.POOL_A_COUNT))
    p = w.record('PrimaryRecord', 0)
    r.set(y=p.get('y') + rng.randrange(-0x14, 0x1A), x=p.get('x') + rng.randrange(-0x12, 0x1A))
    return {'BP': r.at}

def _hit_seed(w):
    rng = w.rng
    _adopt(w, world(rng, w.pair))
    r = H.enemy(w, size_class=rng.choice((1, 2, 2)))
    if rng.randrange(3) == 0: w.word('SegBossActive', 1)
    p = w.record('PrimaryRecord', 0)
    r.set(x=p.get('x') + rng.randrange(-0x1A, 0x1A), y=p.get('y') + rng.randrange(-0x1A, 0x1A))
    return {'BP': r.at}

def _ship_seed(w):
    rng = w.rng
    _adopt(w, world(rng, w.pair))
    w.record('PrimaryRecord', 0).set(sprite=rng.randrange(4), x=rng.choice((0, 1, 0x58, 0xAF, 0xB0, rng.randrange(0xB1))))
    w.byte('InputBits', rng.randrange(256))
    return {'BP': w.sym('PrimaryRecord')}

def _explode_seed(w):
    rng = w.rng
    _adopt(w, world(rng, w.pair))
    r = w.record('PoolA', rng.randrange(K.POOL_A_COUNT)).live(kind=K.KIND_ENEMY, type=1, size=rng.choice((1, 2)))
    r.set(anim_counter=rng.choice((8, 8, 9, 0x0B, 0x0B, 0x0C)), prev_type=rng.choice((0x24, 0x25, 0x14)))
    w.word('FrameParity', 1)
    return {'BP': r.at}

def _demo_seed(w):
    fw = WP.demo_world(w.rng, w.pair, step=w.rng.randrange(7))
    fw.word('DemoStepTimer', 1)
    WP._adopt(w, fw)
    return {'BP': w.sym('PrimaryRecord')}

def _frame_seed(w):
    """The ship's frame: secondary button, nudges, pod placement, terrain contact."""
    _adopt(w, key_world(w.rng, w.pair))
    if w.rng.randrange(2): terrain(w, 0.5)
    return {}

def _score_seed(w):
    w.put('ScoreBcd', bytes(w.rng.randrange(256) for _ in range(4)))
    return {'BX': w.rng.randrange(0x10000)}

def _reset_seed(w):
    _adopt(w, world(w.rng, w.pair))
    return {}

EXPLODE_TYPES = (1,)
FUZZ = [
    Target('pods_update', 'UpdatePod', _in_domain(_update_seed), REGION, LOOP, types=(0, 1, 0x14, 0x30),
           globals=POD_GLOBALS, watch=WATCH, domains=DOMAINS),
    Target('pods_collide', 'UpdatePod', _in_domain(_collide_seed), REGION, LOOP, types=H.ENEMY_TYPES,
           globals=POD_GLOBALS, watch=WATCH, domains=DOMAINS),
    Target('pods_front', 'UpdatePod', _in_domain(_front_seed), REGION, LOOP, types=H.ENEMY_TYPES,
           globals=POD_GLOBALS, watch=WATCH, domains=DOMAINS),
    Target('pods_remove', 'RemoveRecord', _in_domain(_remove_seed), REGION, LOOP, types=(5, 6, 7, 8, 9, 0x0A, 0x0C, 0x14, 1, 0x13, 2),
           globals=('ShotsLiveMain', 'ShotsLiveSide', 'ShotsLiveFrontPod', 'MissilesLive', 'ShotsLiveType9', 'SelectedUpgradeSlot'),
           domains=DOMAINS),
    Target('pods_upgrade', 'ApplySelectedUpgrade', _in_domain(_upgrade_seed), REGION, LOOP + ('BX',), types=(0x14, 1, 0x13),
           globals=UPGRADE_GLOBALS, watch=WATCH, domains=DOMAINS, seeds=64),
    Target('pods_frame', 'UpdatePlayerFrame', _in_domain(_frame_seed), REGION, FREE,
           globals=UPGRADE_GLOBALS + ('FrameParity', 'ClampXLowSeen', 'MapScrollPos'), watch=WATCH, domains=DOMAINS),
    Target('pods_pickup', 'UpdatePickup', _in_domain(_pickup_seed), REGION, LOOP, types=(0,),
           globals=POD_GLOBALS + ('BonusKeysEnabled', 'Fuel', 'RefuelActive'), domains=DOMAINS),
    Target('pods_hit', 'FinishRecordUpdate', _in_domain(_hit_seed), REGION, LOOP, types=H.ENEMY_TYPES,
           globals=('SegBossActive', 'LevelEndPhase', 'DifficultySetting', 'EnergyTanks', 'EnergyPoints'), domains=DOMAINS),
    Target('pods_nudge', 'AdjustRecordXFromCounts', _in_domain(_ship_seed), REGION, LOOP, pin_bp=True,
           globals=('FrameParity', 'ClampXLowSeen') + SIDE, domains=dict(DOMAINS, sprite=range(4))),
    Target('pods_place', 'PlaceSidePods', _in_domain(_ship_seed), REGION, LOOP, pin_bp=True,
           globals=('SidePodSpreadLeft', 'SidePodSpreadRight') + SIDE, domains=dict(DOMAINS, sprite=range(4))),
    Target('pods_explode', 'RunTypeHandler', _in_domain(_explode_seed), REGION, LOOP, types=EXPLODE_TYPES,
           globals=('FrameParity', 'SelectedUpgradeSlot'), domains=dict(DOMAINS, type=EXPLODE_TYPES), seeds=32),
    Target('pods_collect', 'UpdatePickup', _in_domain(_pickup_seed), REGION, LOOP, types=(0,),
           globals=POD_GLOBALS + ('BonusKeysEnabled', 'Fuel', 'RefuelActive'), domains=DOMAINS),
    Target('pods_demo', 'RunDemoScriptFrame', _in_domain(_demo_seed), REGION, FREE, pin_bp=True,
           globals=('DemoStep', 'SfxEnabled') + PODS, domains=dict(WP.DOMAINS, DemoStep=range(7))),
    Target('pods_score', 'AddScoreBcd', _in_domain(_score_seed), REGION, ALL_REGS, domains=DOMAINS),
    Target('pods_reset', 'ResetPoolAAndUpgrades', _in_domain(_reset_seed), REGION, FREE, domains=DOMAINS, seeds=2),
]
