"""Bounded differential-test proposal for the gameplay leaf migration.

Copy to tests/gameplay_completion.py after the owning entries are present in the
hybrid. No production source, ASM entry bridge, or extra test-only runtime stub is
needed: energy is collected through UpdatePickup, fuel through Level0MapCell,
InitStars uses its startup bridge, and MoveStars is reached by UpdateAllRecords.
InitUpgradeSlots gets a temporary symbol-table alias to its C body, matching the
existing tests/life.py pattern; the alias is removed when this generator closes.
"""
from difftest import Case, far, MAP_SEGMENT
from emu import REG
from world import World, K, RECORD
import struct

STAR_COUNT = 40


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def _energy_case(pair, rng, tanks, points, sfx_enabled, name):
    """A size-1 item-2 pickup overlaps the form-0 ship after UpdatePickup's Y step."""
    s = pair.sym
    w = World(pair, rng).plausible()
    w.fill('PoolA', 0)
    w.record('PrimaryRecord', 0).set(sprite=0, x=0x40, y=0x50)
    pickup = w.record('PoolA', 0).live(kind=K.KIND_PICKUP, type=0, size=1, item_index=2)
    pickup.set(x=0x48, y=0x56, slot_index=0xFFFF)
    w.word('EnergyTanks', tanks).word('EnergyPoints', points)
    w.word('ScrollDeltaY', 0).word('SegBossActive', 0).word('LevelEndPhase', 0)
    w.word('PoolACursor', w.slot('PoolA', 1))
    w.put('ScoreBcd', bytes(4))
    w.byte('SfxEnabled', sfx_enabled).byte('SfxRequest', 0x55)

    want_tanks = ((tanks + 1) & 0xFFFF) if tanks != 3 else 3
    want_points = 0x18 if tanks == 3 else points
    want_sfx = 0x1C if sfx_enabled else 0x55

    def expect(m, regs):
        check(m.peek('EnergyTanks') == want_tanks, 'item 2 tank/energy branch')
        check(m.peek('EnergyPoints') == want_points, 'item 2 energy-point equality wrap')
        check(m.peek('SfxRequest') & 0xFF == want_sfx, 'item 2 sound request')
        check(m.read(s('ScoreBcd'), 4) == b'\x20\0\0\0', 'collection adds 20h BCD points')
        check(m.read(pickup.at, 2) == b'\0\0', 'collected pickup is freed')

    return Case('UpdatePickup', {'BP': pickup.at}, w.writes(), ('BP', 'SP', 'DS', 'SS'),
                expect=expect, name=name)


def _upgrade_alias_cases(rng, pair):
    """Call the C body without a permanent bridge; normalize old BP vs C AX result."""
    alias = 'INITUPGRADESLOTS'
    body = 'INIT_UPGRADE_SLOTS'
    added = alias not in pair.b.m.symbols
    if added:
        pair.b.m.symbols[alias] = pair.b.m.symbols[body]
    old_video = (pair.a.m.peek('VideoAdapter'), pair.b.m.peek('VideoAdapter'))
    try:
        for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY):
            pair.a.m.poke('VideoAdapter', adapter)
            pair.b.m.poke('VideoAdapter', adapter)
            w = World(pair, rng)
            # The initializer must leave the slot image/list words alone while resetting
            # icon, adapter-specific screen offset and list index.
            for n in range(4):
                slot = pair.sym(f'UpgradeSlot{n}')
                list_at = pair.sym(f'UpgradeList{n}')
                w.put(slot, struct.pack('<5H', 0x0100 + n, 0x1110 + n,
                                        0x2200 + n, list_at, 0x3300 + n))
            w.word('SelectedUpgradeSlot', 2)
            expected_next = (pair.sym('UpgradeSlot0') + 4 * K.UPGRADE_SLOT_BYTES) & 0xFFFF

            def expect(m, regs, expected_next=expected_next):
                check(regs['BP'] == expected_next, 'oracle BP is one past UpgradeSlot3')
                check(regs['AX'] == 0xC71C, 'oracle final row/column is C7h:1Ch')
                c_ax = pair.b.m.u.reg_read(REG['AX'])
                check(c_ax == expected_next, 'C AX returns the equivalent one-past slot')

            yield Case('InitUpgradeSlots', writes=w.writes(), preserve=('SP', 'DS', 'SS'),
                       expect=expect, name=f'init four slots adapter {adapter}')
    finally:
        pair.a.m.poke('VideoAdapter', old_video[0])
        pair.b.m.poke('VideoAdapter', old_video[1])
        if added:
            del pair.b.m.symbols[alias]


def _fuel_cases(rng, pair):
    """The actual level-0 dispatcher covers both the successful and failed allocator tails."""
    s = pair.sym
    offset = 0x500
    for full in (False, True):
        w = World(pair, rng).plausible()
        w.word('LevelIndex', 0).word('MapCellX', 0x40)
        w.word('PoolACursor', w.slot('PoolA', 0))
        w.word('DropKind', 0x5A5A)
        w.put('GroupTable', bytes(32))
        w.word('GroupSlotPtr', 0xFFFF).word('GroupSlotIndex', 0)
        w.fill('PoolA', K.POOL_A_COUNT if full else 0)
        initial_cell = b'\xF9'
        writes = w.writes() + [(far('SlotBuffer', offset), initial_cell)]
        expected_si = offset if full else 0x4A

        def expect(m, regs, expected_si=expected_si, full=full):
            check(regs['SI'] == expected_si, 'level-0 fuel cell returns its map cursor')
            # Pair.Side.run rolls external writes back before Case.expect runs. The
            # differential runner retains their ordered symbol/address trace instead.
            map_address = f'{MAP_SEGMENT * 16 + offset:05X}'
            cleared_cell = (map_address, 1, 1)
            check(cleared_cell in pair.a.outside, 'oracle clears the fuel source map cell')
            check(cleared_cell in pair.b.outside, 'hybrid clears the fuel source map cell')
            check(m.peek('DropKind') == (0x5A5A if full else 4),
                  'full pool leaves DropKind stale; success selects fuel')
            if not full:
                slot = s('PoolA')
                check(m.read(slot, 2) == b'\x01\0', 'successful spawn claims a record')
                check(m.read(slot + K.REC_KIND, 2) == struct.pack('<H', K.KIND_PICKUP),
                      'successful fuel spawn initializes a pickup')

        yield Case('Level0MapCell', {'AX': 0xF9, 'SI': offset, 'BP': s('PrimaryRecord'),
                                     'ES': 'LevelMapSegment'},
                   writes, ('BP', 'DI', 'SP', 'DS', 'SS'), outputs=('SI',),
                   expect=expect, name='fuel pickup ' + ('full pool stale SI' if full else 'success SI=4Ah'))


def _stars_blob(ys=None):
    ys = ys or [((7 + 13 * i) % 0xB0) for i in range(40)]
    return b''.join(struct.pack('<3H', y & 0xFFFF, (3 + 37 * i) & 0xFF, 0xA500 + i)
                    for i, y in enumerate(ys))


def _init_star_cases(rng, pair):
    """InitStars is still a required startup entry, so enter its real ASM-to-C bridge."""
    s = pair.sym
    old_video = (pair.a.m.peek('VideoAdapter'), pair.b.m.peek('VideoAdapter'))
    try:
        for adapter, bright_count in ((K.VIDEO_CGA, 20), (K.VIDEO_EGA, 20),
                                      (K.VIDEO_TANDY, 0), (K.VIDEO_TANDY, 1),
                                      (K.VIDEO_TANDY, 20)):
            pair.a.m.poke('VideoAdapter', adapter)
            pair.b.m.poke('VideoAdapter', adapter)
            w = World(pair, rng)
            w.put('Stars', _stars_blob())
            w.put('StarMasksCga', bytes((0x03, 0x0C, 0x30, 0xC0)))
            w.put('StarMasksEga', bytes((1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80)))
            w.put('StarMasksTandy', bytes((0x0F, 0xF0)))
            # The last unscaled mask-word read can cross into the following divider word.
            w.word('StarLayerTick1', 0)
            w.word('StarBrightCount', bright_count)

            def expect(m, regs, adapter=adapter, bright_count=bright_count):
                divisor = {K.VIDEO_CGA: 4, K.VIDEO_EGA: 8,
                           K.VIDEO_TANDY: 2}[adapter]
                initial_x = [(3 + 37 * i) & 0xFF for i in range(STAR_COUNT)]
                for i, pixels in enumerate(initial_x):
                    got = struct.unpack('<H', m.read(s('Stars') + i * 6 + 2, 2))[0]
                    check(got == pixels // divisor,
                          f'star {i} pixel-to-column scale for adapter {adapter}')
                if adapter == K.VIDEO_TANDY:
                    remaining = max(0, bright_count - STAR_COUNT)
                    check(m.peek('StarBrightCount') == remaining, 'Tandy bright-star countdown')
                    expected_masks = b'\x07\x70' if bright_count != 0 and remaining == 0 else b'\x0F\xF0'
                    check(m.read(s('StarMasksTandy'), 2) == expected_masks, 'Tandy mask dim point')
                else:
                    check(m.peek('StarBrightCount') == bright_count, 'non-Tandy init leaves bright count')

            yield Case('InitStars', writes=w.writes(), preserve=('SP', 'DS', 'SS'),
                       expect=expect, name=f'InitStars adapter {adapter} bright {bright_count}')
    finally:
        pair.a.m.poke('VideoAdapter', old_video[0])
        pair.b.m.poke('VideoAdapter', old_video[1])


def _move_stars_case(rng, pair, ticks, energy, name):
    """Reach MoveStars through UpdateAllRecords, with all other records dormant."""
    s = pair.sym
    w = World(pair, rng).plausible()
    w.fill('PoolA', 0).fill('PoolB', 0)
    ys = [((7 + 13 * i) % 0xB0) for i in range(40)]
    for first in (0, 20, 30):
        ys[first] = 0xBF
    w.put('Stars', _stars_blob(ys))
    for name_tick, value in zip(('StarLayerTick1', 'StarLayerTick2', 'StarLayerTick3'), ticks):
        w.word(name_tick, value)
    w.word('EnergyTanks', energy).word('LevelIndex', 0).word('SegBossActive', 0)
    w.word('FramesSinceInvaderSpawn', 0xFFFF).word('LevelEndPhase', 0)
    w.byte('Type93KilledLatch', 0).byte('Type93KilledPulse', 0)
    w.word('InvaderNextMarchLeft', 0).word('InvaderNextDropStep', 0)
    w.word('RecordTickCounter', 0)

    if energy == 0xFFFF:
        moved = (False, False, False)
        final_ticks = ticks
    else:
        first_moves = ((ticks[0] + 1) & 1) == 0
        second_tick = ((ticks[1] + 1) & 1) if first_moves else ticks[1]
        second_moves = first_moves and second_tick == 0
        third_tick = ((ticks[2] + 1) & 1) if second_moves else ticks[2]
        third_moves = second_moves and third_tick == 0
        moved = (first_moves, second_moves, third_moves)
        final_ticks = (((ticks[0] + 1) & 1), second_tick, third_tick)

    def expect(m, regs, moved=moved, final_ticks=final_ticks):
        for first, should_move in zip((0, 20, 30), moved):
            got = struct.unpack('<H', m.read(s('Stars') + first * 6, 2))[0]
            check(got == (0 if should_move else 0xBF), f'star layer at entry {first} movement')
        for name_tick, expected in zip(('StarLayerTick1', 'StarLayerTick2', 'StarLayerTick3'), final_ticks):
            check(m.peek(name_tick) == expected, f'{name_tick} divider state')

    return Case('UpdateAllRecords', writes=w.writes(), preserve=('BP', 'SP', 'DS', 'SS'),
                expect=expect, name=name)


def cases(rng, scale, pair):
    # These cases intentionally stay small; the existing suites provide randomized breadth.
    added = []
    for alias, body in (('INITUPGRADESLOTS', 'INIT_UPGRADE_SLOTS'),):
        if alias not in pair.b.m.symbols:
            pair.b.m.symbols[alias] = pair.b.m.symbols[body]
            added.append(alias)
    old_video = (pair.a.m.peek('VideoAdapter'), pair.b.m.peek('VideoAdapter'))
    try:
        # Tank count 3 takes the equality-loop path; FFFFh demonstrates its 16-bit wrap.
        # Non-3 values increment the tank word even for FFFFh and preserve the energy bar.
        yield _energy_case(pair, rng, 3, 0xFFFF, 1, 'energy wraps FFFFh to 18h')
        yield _energy_case(pair, rng, 3, 0x17, 0, 'energy reaches 18h with sound disabled')
        yield _energy_case(pair, rng, 2, 5, 1, 'energy pickup increments tank')
        yield _energy_case(pair, rng, 0xFFFF, 5, 0, 'tank word increments through FFFFh')
        yield _energy_case(pair, rng, 3, 0x18, 1, 'energy exact equality is already full')

        yield from _upgrade_alias_cases(rng, pair)
        yield from _fuel_cases(rng, pair)
        yield from _init_star_cases(rng, pair)
        yield _move_stars_case(rng, pair, (1, 1, 1), 0, 'all three star layers advance')
        yield _move_stars_case(rng, pair, (1, 0, 1), 0, 'first star layer only')
        yield _move_stars_case(rng, pair, (1, 1, 0), 0, 'first two star layers')
        yield _move_stars_case(rng, pair, (0, 1, 1), 0, 'first divider pauses all layers')
        yield _move_stars_case(rng, pair, (1, 1, 1), 0xFFFF, 'empty tank sentinel freezes stars')
    finally:
        pair.a.m.poke('VideoAdapter', old_video[0])
        pair.b.m.poke('VideoAdapter', old_video[1])
        for alias in added:
            del pair.b.m.symbols[alias]


# Representative translation slips. Every replacement is expected to fail this suite.
MUTANTS = [
    ('pods.c', 'while (EnergyPoints != 0x18) EnergyPoints++;',
               'while (EnergyPoints < 0x18) EnergyPoints++;'),
    ('pods.c', 'if (EnergyTanks == 3) {', 'if (EnergyTanks >= 3) {'),
    ('pods.c', '        slot++;\n        row += 0x10;\n',
               '        slot++;\n        row += 0x0F;\n'),
    ('spawn.c', '    if (pickup == NO_RECORD) return off;\n    DropKind = 4;',
                '    if (pickup == NO_RECORD) return 0x4A;\n    DropKind = 4;'),
    ('spawn.c', '    return init_pickup_record(pickup);', '    return off;'),
    ('frame.c', '            star->x = pixels >> 1;', '            star->x = pixels >> 2;'),
    ('frame.c', '                if (StarBrightCount == 0) {', '                if (StarBrightCount != 0) {'),
    ('frame.c', '        if (star->y == 0xC0) star->y = 0;', '        if (star->y > 0xC0) star->y = 0;'),
    ('frame.c', '    if (EnergyTanks == 0xFFFF) return;', '    if (EnergyTanks == 0) return;'),
]
