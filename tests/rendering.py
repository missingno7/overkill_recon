"""Differential pixel/state cases for the proposed C renderer region.

The suite is copied to tests/rendering.py when the region is integrated. It exercises
the real ASM sprite/panel/fuel pixel leaves against the frozen renderer and compares
workspace/video writes, port traffic, the full state segment and returned registers.
"""
from difftest import Case
from world import World, K, RECORD
import struct

KEEP = ('SP', 'DS', 'SS')
RECORD_KEEP = ('BP', 'SP', 'DS', 'SS', 'ES')
W = lambda value: struct.pack('<H', value & 0xFFFF)


def _set_video(pair, adapter):
    old = []
    screen = 0xA000 if adapter == K.VIDEO_EGA else 0xB800
    for side in (pair.a, pair.b):
        m = side.m
        old.append((m.peek('VideoAdapter'), m.peek('ScreenSegment'), m.peek('EgaPageToggle')))
        m.poke('VideoAdapter', adapter)
        m.poke('ScreenSegment', screen)
        m.poke('EgaPageToggle', 0)
    return old


def _restore_video(pair, old):
    for side, saved in zip((pair.a, pair.b), old):
        side.m.poke('VideoAdapter', saved[0])
        side.m.poke('ScreenSegment', saved[1])
        side.m.poke('EgaPageToggle', saved[2])


def _workspace_fixture(pair, payload):
    saved = []
    for side in (pair.a, pair.b):
        at = side.m.peek('WorkspaceSegment') * 16
        saved.append((side, at, bytes(side.m.u.mem_read(at, 0x10000))))
        side.m.u.mem_write(at, payload)
    return saved


def _restore_workspace(saved):
    for side, at, payload in reversed(saved):
        side.m.u.mem_write(at, payload)


def _panel_fixture(pair):
    """Install distinct one-row packed panel images so slot/image choices affect pixels."""
    saved = []
    payload_size = 0x2C0
    for side in (pair.a, pair.b):
        m = side.m
        table = m.linear('PanelImageOffsets')
        table_bytes = bytes(m.u.mem_read(table, 87 * 2))
        segment = m.peek('PanelSegment')
        panel_at = segment * 16 + 0x100
        panel_bytes = bytes(m.u.mem_read(panel_at, payload_size))
        saved.append((side, table, table_bytes, panel_at, panel_bytes))

        offsets = bytearray()
        for i in range(87):
            offset = 0x100 + i * 8
            offsets += W(offset)
            pixels = bytes(((0x31 + i) & 0xFF, (0x71 + i) & 0xFF,
                            (0xB1 + i) & 0xFF, (0xF1 + i) & 0xFF))
            m.u.mem_write(segment * 16 + offset, W(1) + W(1) + pixels)
        m.u.mem_write(table, bytes(offsets))
    return saved


def _restore_panel_fixture(saved):
    for side, table, table_bytes, panel_at, panel_bytes in reversed(saved):
        side.m.u.mem_write(table, table_bytes)
        side.m.u.mem_write(panel_at, panel_bytes)


def _build_rows():
    return Case('BuildRowTables', preserve=KEEP, name='initialize adapter row tables')


def _init_stars():
    return Case('InitStars', preserve=KEEP, name='initialize adapter star columns and masks')


def _offset_case(pair, adapter, y, x, timer, name):
    w = World(pair, None).word('ScrollWindowOffset', 0x1234)
    rec = w.record('PoolA', 0).set(status=1, y=y, x=x, pixel_phase=0xAAAA,
                                  size_class=1, flash_timer=timer)
    at = pair.sym('RecordRowOffsets') + 2 * y if y < 0xE0 else None

    def expect(m, regs):
        row = 0xFFFF if at is None else m.word(at)
        if y >= 0xE0 or row == 0xFFFF:
            expected = 0xFFFF
            phase = 0xAAAA
            after_timer = timer
        else:
            expected = (row + (x >> (2 if adapter == K.VIDEO_CGA else
                                      3 if adapter == K.VIDEO_EGA else 1))) & 0xFFFF
            phase = x & (3 if adapter == K.VIDEO_CGA else
                         7 if adapter == K.VIDEO_EGA else 0xFFFF)
            if adapter == K.VIDEO_TANDY:
                phase = 0
            after_timer = (timer - 1) & 0xFFFF if timer else 0
        if regs['AX'] != expected:
            raise AssertionError(f'{name}: raw offset {regs["AX"]:04X} != {expected:04X}')
        if m.word(rec.at + K.REC_PIXEL_PHASE) != phase:
            raise AssertionError(f'{name}: phase write')
        if m.word(rec.at + K.REC_FLASH_TIMER) != after_timer:
            raise AssertionError(f'{name}: visible-only flash tick')

    return Case('RecordWorkspaceOffset', {'BP': rec.at}, w.writes(),
                ('BP', 'SP', 'DS', 'SS'), outputs=('AX',), expect=expect, name=name)


def _record_round_trip(pair, adapter, size, y, clipped, timer, name):
    w = World(pair, None).word('ScrollWindowOffset', 0x20)
    save_buffer = pair.sym('PoolASaveBuffers') + K.POOL_A_COUNT * K.POOL_A_SAVE_BYTES
    rec = w.record('PoolA', 0).set(status=1, y=y, x=0x53, sprite=(0xFA if size == 1 else
                                    0x1C if size == 2 else 1), size_class=size,
                                  flash_timer=timer, work_ofs=0xFFFF,
                                  work_ofs_lower=0xFFFF, save_buffer=save_buffer)
    writes = w.writes()
    if clipped == 'lower-only':
        writes += [(pair.sym('RecordRowOffsets') + 2 * y, W(0xFFFF))]
    elif clipped == 'upper-only':
        writes += [(pair.sym('RecordRowOffsets') + 2 * (y + 0x10), W(0xFFFF))]
    elif clipped == 'neither':
        writes += [(pair.sym('RecordRowOffsets') + 2 * y, W(0xFFFF)),
                   (pair.sym('RecordRowOffsets') + 2 * (y + 0x10), W(0xFFFF))]

    return [
        _build_rows(),
        Case('SaveRecordBackground', {'BP': rec.at, 'ES': 0xBEEF}, writes,
             RECORD_KEEP, name=name + ' save'),
        Case('DrawRecordSprite', {'BP': rec.at, 'ES': 0xBEEF}, (),
             ('SP', 'DS', 'SS', 'ES'), outputs=('BP',), name=name + ' sprite'),
        Case('RestoreRecordBackground', {'BP': rec.at, 'ES': 0xBEEF}, (),
             RECORD_KEEP, name=name + ' restore'),
    ]


def _record_sprite_offscreen(pair, size):
    w = World(pair, None)
    rec = w.record('PoolA', 0).set(status=1, y=0x50, x=0x53, sprite=0x1C,
                                  size_class=size, flash_timer=0,
                                  work_ofs=0xFFFF, work_ofs_lower=0xFFFF)
    return Case('DrawRecordSprite', {'BP': rec.at, 'ES': 0xBEEF}, w.writes(),
                RECORD_KEEP,
                name=f'size={size} direct offscreen sprite returns before blit')


def _record_pool_round_trip(pair, adapter, draw_extra=False):
    phase = K.LEVEL_END_TO_WAYPOINT_A if draw_extra else K.LEVEL_END_OFF
    w = World(pair, None).word('ScrollWindowOffset', 0).word('LevelEndPhase', phase)
    w.word('AutoMoveExtraRecord', pair.sym('PrimaryRecord') if draw_extra else 0xFFFF)
    w.word('DemoActive', 0)
    w.word('MapScrollPos', 0)
    w.put('PoolA', bytes(K.POOL_A_COUNT * RECORD))
    w.put('PoolB', bytes(K.POOL_B_COUNT * RECORD))
    primary = w.record('PrimaryRecord', 0).set(status=1, y=0xE0 if draw_extra else 0x50, x=0x58,
                  sprite=0x1C, size_class=2, kind=K.KIND_PLAYER, draw_pass=1,
                  flash_timer=3, work_ofs=0xFFFF, work_ofs_lower=0xFFFF,
                  save_buffer=pair.sym('PoolASaveBuffers'))
    b_save = pair.sym('PoolBSaveBuffers') + (K.POOL_B_COUNT - 1) * K.POOL_B_SAVE_BYTES
    w.record('PoolB', 0).set(status=1, y=0x62, x=0x31, sprite=1,
                  size_class=0, kind=K.KIND_TYPED, flash_timer=0, work_ofs=0xFFFF,
                  save_buffer=b_save)
    writes = w.writes()
    pool_a_first = pair.a.m.word(pair.sym('PoolAPointers'))

    def check_draw(m, regs):
        expected_bp = primary.at if draw_extra else pool_a_first
        if regs['BP'] != expected_bp:
            path = 'AutoMoveExtraRecord' if draw_extra else 'PoolAPointers[0]'
            raise AssertionError(f'DrawRecordsToWorkspace BP is {path}')
        if regs['ES'] != m.peek('WorkspaceSegment'):
            raise AssertionError('DrawRecordsToWorkspace ES is WorkspaceSegment')

    return [
        _build_rows(), _init_stars(),
        Case('DrawRecordsToWorkspace', {'BP': 0x4567, 'ES': 0xBEEF}, writes,
             KEEP, outputs=('BP', 'ES'), expect=check_draw,
             name=f'{adapter} pool draw with primary and pool B' +
                  (' plus level-end record' if draw_extra else '')),
        Case('RestoreRecordBackgrounds', {'BP': 0x4567, 'ES': 0xBEEF}, (), KEEP,
             outputs=('BP', 'ES'), name=f'{adapter} pool and star restore'),
    ]


def _hud_cases(pair, adapter):
    for selected, demo in ((0xFFFF, 0), (2, 0), (2, 1)):
        w = World(pair, None).word('SelectedUpgradeSlot', selected).word('DemoActive', demo)
        w.word('DemoUpgradeStatus', 0x39).word('EnergyTanks', 2)
        w.word('EnergyPoints', 24).word('HudTankCompare', 0xFFFF)
        for i in range(4):
            w.put(f'UpgradeSlot{i}', struct.pack('<5H', 0x24 + i, 0x2200 + i * 0x80,
                  0x0F + i, pair.sym(f'UpgradeList{i}'), 0))
        yield [_build_rows(),
               Case('DrawUpgradeSlots', {'BP': 0x4567, 'ES': 0xBEEF}, w.writes(),
                    ('BP', 'SP', 'DS', 'SS'), outputs=('SI', 'ES'),
                    name=f'{adapter} upgrades selected={selected:04X} demo={demo}')]

    for tanks, points, compare in ((0xFFFF, 0xFFFF, 0), (0, 0, 0xFFFF),
                                   (1, 1, 0xFFFF), (2, 24, 0xFFFF), (3, 25, 3)):
        w = World(pair, None).word('EnergyTanks', tanks).word('EnergyPoints', points)
        w.word('HudTankCompare', compare)
        def expect(m, regs, points=points):
            if points >= 0x8000 or points == 0:
                expected = [4] * 6
            else:
                remain = points
                expected = [4] * 6
                for _ in range(remain):
                    for i in range(6):
                        if expected[i]:
                            expected[i] -= 1
                            break
            actual = [m.word(pair.sym('EnergyCells') + 2 * i) for i in range(6)]
            if actual != expected:
                raise AssertionError(f'EnergyCells {actual} != {expected}')
        yield [_build_rows(),
               Case('DrawEnergyGauge', {'BP': 0x4567, 'ES': 0xBEEF}, w.writes(),
                    ('BP', 'SP', 'DS', 'SS'), outputs=('SI', 'ES'), expect=expect,
                    name=f'{adapter} energy tanks={tanks:04X} points={points}')]


def _fuel_cases(pair, adapter):
    step = 2 if adapter == K.VIDEO_CGA else (4 if adapter == K.VIDEO_TANDY else 1)
    for fuel, active, enabled, cga_row_base in (
            (0, 0, 1, None), (15, 0, 1, None), (16, 0, 1, None),
            (88, 0, 1, None), (9, 1, 1, None), (8, 0, 0, None),
            # A valid in-aperture origin makes the second CGA half-step cross into
            # the other 8 KiB bank in both the filled and empty-bar loops.
            (88, 0, 1, 0x1000), (0, 0, 1, 0x1000)):
        w = World(pair, None).word('Fuel', fuel).word('RefuelActive', active)
        w.byte('SfxEnabled', enabled).byte('SfxRequest', 0x55)
        if adapter == K.VIDEO_CGA and cga_row_base is not None:
            w.word(pair.sym('ScreenRowOffsets') + 2 * 0x5F, cga_row_base)
        def expect(m, regs, fuel=fuel, active=active, enabled=enabled, step=step):
            row = m.word(pair.sym('ScreenRowOffsets') + 2 * 0x5F)
            want_offset = (row + step * 0x1D) & 0xFFFF
            if m.word(pair.sym('FuelGaugeOffset')) != want_offset:
                raise AssertionError('FuelGaugeOffset uses adapter 8-pixel column step')
            want_sfx = 0x0A if fuel < 0x10 and active != 1 and enabled else 0x55
            if m.read(pair.sym('SfxRequest'), 1)[0] != want_sfx:
                raise AssertionError('fuel low-level sound mailbox rule')
        yield [_build_rows(),
               Case('DrawFuelGauge', {'BP': 0x4567, 'ES': 0xBEEF}, w.writes(),
                    ('BP', 'SP', 'DS', 'SS'), outputs=('DI', 'ES'), expect=expect,
                    name=f'{adapter} fuel={fuel} refuel={active} sfx={enabled}')]


def cases(rng, scale, pair):
    old_video = []
    workspace_saved = []
    panel_saved = []
    try:
        panel_saved = _panel_fixture(pair)
        # A patterned allocation makes save/restore compare real pixel bytes. Routine
        # writes are rolled back by Pair between cases, leaving this fixture in place.
        pattern = bytes((i * 29 + 7) & 0xFF for i in range(0x10000))
        workspace_saved = _workspace_fixture(pair, pattern)

        for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY):
            current_video = _set_video(pair, adapter)
            if not old_video:
                old_video = current_video
            for y, x, timer in ((0x40, 0x43, 1), (0xDF, 0x7F, 0xFFFF),
                                (0xE0, 0x12, 5), (0xFFFF, 0x80, 1)):
                yield [_build_rows(),
                       _offset_case(pair, adapter, y, x, timer,
                                    f'{adapter} offset y={y:04X} x={x:02X}')]

            for size in (0, 1, 2):
                y = 0x50
                for clipping in (None, 'upper-only', 'lower-only', 'neither'):
                    if size != 2 and clipping is not None:
                        continue
                    yield _record_round_trip(pair, adapter, size, y, clipping, 3,
                                             f'{adapter} size={size} clip={clipping}')

            for size in (0, 1):
                yield _record_round_trip(pair, adapter, size, 0xE0, None, 3,
                                         f'{adapter} size={size} offscreen clipped save/restore')

            if adapter == K.VIDEO_CGA:
                yield _record_sprite_offscreen(pair, 0)
                yield _record_sprite_offscreen(pair, 1)

            # Full ordering case includes the C star policy and actual sprite blitters.
            zero_fixture = bytes(0x10000)
            _restore_workspace(workspace_saved)
            workspace_saved = _workspace_fixture(pair, zero_fixture)
            yield _record_pool_round_trip(pair, adapter)
            yield _record_pool_round_trip(pair, adapter, draw_extra=True)
            _restore_workspace(workspace_saved)
            workspace_saved = _workspace_fixture(pair, pattern)

            yield [_build_rows(), _init_stars(),
                   Case('DrawStars', {'ES': 0xBEEF}, (), KEEP, outputs=('ES',),
                        name=f'{adapter} draw all clear stars'),
                   Case('EraseStars', {'ES': 0xBEEF}, (), KEEP, outputs=('ES',),
                        name=f'{adapter} erase plotted stars')]

            yield from _hud_cases(pair, adapter)
            yield from _fuel_cases(pair, adapter)
    finally:
        if old_video:
            _restore_video(pair, old_video)
        if workspace_saved:
            _restore_workspace(workspace_saved)
        if panel_saved:
            _restore_panel_fixture(panel_saved)


# Plausible renderer slips; the suite must observe each one through record state,
# workspace/panel pixels, or the low-fuel sound mailbox.
MUTANTS = [
    ('render.c', 'record->flash_timer = (word)(record->flash_timer - 1);',
                'record->flash_timer = (word)(record->flash_timer - 2);'),
    ('render.c', 'record->y = original_y;',
                'record->y = (word)(original_y + 0x10);'),
    ('render.c', 'if (size_class == 0) request->bytes_per_plane = 2;',
                'if (size_class == 0) request->bytes_per_plane = 1;'),
    ('render.c', 'request.planes = adapter == VIDEO_EGA ? (i < 20 ? 4 : 3) : 1;',
                'request.planes = i < 20 ? 4 : 3;'),
    ('render.c', 'highlighted = (word)(UpgradeSlotPtrs[selected] == address);',
                'highlighted = (word)(UpgradeSlotPtrs[(selected + 1) & 3] == address);'),
    ('render.c', '--EnergyCells[i];',
                'EnergyCells[i] = (word)(EnergyCells[i] + 1);'),
    ('render.c', 'if (fuel < 0x10 && RefuelActive != 1 && SfxEnabled != 0)',
                'if (fuel < 0x10 && RefuelActive == 1 && SfxEnabled != 0)'),
]
