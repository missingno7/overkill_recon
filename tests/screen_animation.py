"""Real-buffer checks for screen capture and vertical image animation.

Capture cases use the original row transfer and bank progression but return at the
stretched-drawer/retrace boundary, keeping 200 captured rows cheap to compare. Raw and
wrapper stretch cases run the real CGA/EGA/Tandy drawers on distinct image fixtures.
"""
from difftest import Case
from emu import REG
from options import hook, cleanup, return_service, check
from world import K
from unicorn import UC_HOOK_CODE
import struct

KEEP = ('SP', 'SS')
W = lambda value: struct.pack('<H', value & 0xFFFF)


def _adapter(pair, adapter):
    saved = []
    screen = 0xA000 if adapter == K.VIDEO_EGA else 0xB800
    for side in (pair.a, pair.b):
        m = side.m
        saved.append((m.peek('VideoAdapter'), m.peek('ScreenSegment')))
        m.poke('VideoAdapter', adapter)
        m.poke('ScreenSegment', screen)
    return saved


def _restore_adapter(pair, saved):
    for side, words in zip((pair.a, pair.b), saved):
        side.m.poke('VideoAdapter', words[0])
        side.m.poke('ScreenSegment', words[1])


def _fixture(pair, segment, offset, payload):
    saved = []
    for side in (pair.a, pair.b):
        at = segment * 16 + offset
        old = bytes(side.m.u.mem_read(at, len(payload)))
        saved.append((side, at, old))
        side.m.u.mem_write(at, payload)
    return saved


def _restore_fixture(saved):
    for side, at, old in reversed(saved):
        side.m.u.mem_write(at, old)


def _screen_fixture(pair, adapter):
    screen = 0xA000 if adapter == K.VIDEO_EGA else 0xB800
    pattern = bytes((i * (17 + adapter * 4) + 0x39 + adapter) & 0xFF
                    for i in range(0x10000))
    return _fixture(pair, screen, 0, pattern)


def _image(rows=8, row_bytes=3, salt=0x31):
    return W(rows) + W(row_bytes) + bytes((i * 29 + salt) & 0xFF for i in range(0x200))


def _install_retrace(side, bag, counts, snapshots):
    def retrace(u, _address, _size, _):
        counts[side] += 1
        m = side.m
        snapshots[side].append((m.peek('StretchImageRows'), m.peek('StretchRowBytes'),
                                m.peek('StretchSource'), m.peek('StretchDest'),
                                m.peek('StretchShownRows'), m.peek('StretchFlagA'),
                                m.peek('StretchFlagB')))
        return_service(side)
    hook(side, bag, UC_HOOK_CODE, retrace, side.m.linear('WaitVerticalRetrace'))


def _capture_cases(pair, adapter):
    bag, counts, drawers, snapshots = [], {}, {}, {}
    try:
        for side in (pair.a, pair.b):
            counts[side] = 0
            drawers[side] = 0
            snapshots[side] = []
            _install_retrace(side, bag, counts, snapshots)
            name = ('DrawStretchedImageCga', 'DrawStretchedImageEga',
                    'DrawStretchedImageTandy')[adapter]
            def skip_draw(u, _address, _size, _, side=side):
                drawers[side] += 1
                return_service(side)
            hook(side, bag, UC_HOOK_CODE, skip_draw, side.m.linear(name))

        def complete(m, regs):
            check(counts[pair.a] == counts[pair.b] == 99,
                  f'{adapter}: capture collapse waits once per 198..2 frame')
            check(drawers[pair.a] == drawers[pair.b] == 99,
                  f'{adapter}: selected drawer called once per collapse frame')
            trace = snapshots[pair.a]
            check(trace == snapshots[pair.b],
                  f'{adapter}: shared collapse descriptor trace matches')
            rows, row_bytes, source, destination, shown, flag_a, flag_b = trace[-1]
            check([frame[4] for frame in trace] == [198 - 2 * i for i in range(99)],
                  f'{adapter}: frames visit 198,196,...,2 shown rows')
            check(rows == 200 and row_bytes == 40,
                  f'{adapter}: captured image header initializes the shared descriptor')
            check(source == 4 and destination == 0,
                  f'{adapter}: packed capture payload starts after its four-byte header')
            check(shown == 2,
                  f'{adapter}: double-decrement collapse finishes at two shown rows')
            check(flag_a == 0 and flag_b == 0,
                  f'{adapter}: collapse clears the alternating drawer flags once')
            ports = len(m.ports)
            expected = 801 if adapter == K.VIDEO_EGA else 0
            check(ports == expected,
                  f'{adapter}: capture plane selectors/reset produce {ports} port writes')
            check(regs['DS'] == m.peek('WorkspaceSegment'),
                  f'{adapter}: capture entry retains its WorkspaceSegment return')
            check(regs['ES'] == m.peek('ScreenSegment'), f'{adapter}: screen ES is returned')

        yield Case('CaptureAndCollapseScreen',
                   {'BP': 0x6543, 'ES': 0xBEEF, 'DS': 'MainDataSegment'},
                   preserve=KEEP, outputs=('BP', 'ES', 'DS'), expect=complete,
                   name=f'{adapter} real 200-row capture and bounded collapse')
    finally:
        cleanup(pair, bag)


def _stretch_case(pair, adapter, source_offset, destination, label, image_payload,
                  expected_frames=1):
    bag, counts, snapshots = [], {}, {}
    try:
        for side in (pair.a, pair.b):
            counts[side] = 0
            snapshots[side] = []
            _install_retrace(side, bag, counts, snapshots)

        def complete(m, regs):
            check(counts[pair.a] == counts[pair.b] == expected_frames,
                  f'{label}: draw-before-wait frame count {expected_frames}')
            trace = snapshots[pair.a]
            check(trace == snapshots[pair.b],
                  f'{label}: shared stretch descriptor trace matches')
            rows, row_bytes, source, screen_dest, shown, flag_a, flag_b = trace[-1]
            check(rows == 8 and row_bytes == 3,
                  f'{label}: reads both words of the caller-owned image header')
            check(source == ((source_offset + 4) & 0xFFFF),
                  f'{label}: source begins after the far image header')
            check(screen_dest == destination,
                  f'{label}: destination descriptor retains the requested screen offset')
            check(shown == 6,
                  f'{label}: draws at six shown rows before the final increment')
            check(regs['DS'] == 'state segment', f'{label}: restores DS after reading far header')
            check(regs['ES'] == m.peek('ScreenSegment'), f'{label}: drawer returns the screen segment')

        yield Case('StretchInImage',
                   {'SI': source_offset, 'DI': destination,
                    'BP': 0x4271, 'ES': 0xBEEF}, preserve=KEEP,
                   writes=[(source_offset, image_payload)],
                   outputs=('BP', 'ES', 'DS'), expect=complete, name=label)
    finally:
        cleanup(pair, bag)


def _wrapper_case(pair, wrapper, adapter, source_fixture, expected_destination,
                  label, panel_table_fixture=None, image_payload=None):
    bag, counts, snapshots = [], {}, {}
    try:
        for side in (pair.a, pair.b):
            counts[side] = 0
            snapshots[side] = []
            _install_retrace(side, bag, counts, snapshots)
            if image_payload is not None:
                def install_image(u, _address, _size, _, side=side):
                    m = side.m
                    if wrapper == 'StretchInWindowImage':
                        segment = (m.peek('WorkspaceSegment') + 0x7D1) & 0xFFFF
                        offset = 0
                    elif wrapper == 'StretchInTheEndImage':
                        segment = m.peek('TheEndSegment')
                        offset = 0
                    else:
                        segment = m.peek('PanelSegment')
                        offset = m.word(m.linear('PanelImageOffsets') +
                                        2 * K.PANEL_HUD_FRAME)
                    u.mem_write(segment * 16 + offset, image_payload)
                # BuildRowTables clears the workspace. Install the fixture at the
                # wrapper boundary so the source image exists after that setup call.
                hook(side, bag, UC_HOOK_CODE, install_image,
                     side.m.linear(wrapper))

        def complete(m, regs):
            check(counts[pair.a] == counts[pair.b] == 1,
                  f'{label}: wrapper draws once before reaching eight shown rows')
            trace = snapshots[pair.a]
            check(trace == snapshots[pair.b],
                  f'{label}: shared stretch descriptor trace matches')
            rows, row_bytes, source, screen_dest, shown, flag_a, flag_b = trace[-1]
            check(rows == 8 and row_bytes == 3,
                  f'{label}: wrapper reads the packed image header')
            expected = expected_destination(m) if callable(expected_destination) else expected_destination
            check(screen_dest == expected,
                  f'{label}: wrapper chooses its original adapter-specific screen origin')
            check(shown == 6,
                  f'{label}: wrapper draws at six shown rows before increment')
            check(regs['DS'] == 'state segment', f'{label}: wrapper returns in state DS')
            check(regs['ES'] == m.peek('ScreenSegment'), f'{label}: wrapper returns screen ES')

        yield [Case('BuildRowTables', preserve=KEEP, name=label + ' row tables'),
               Case(wrapper, {'BP': 0x3172, 'ES': 0xBEEF, 'DS': 'MainDataSegment'},
                    preserve=KEEP, outputs=('BP', 'ES', 'DS'), expect=complete,
                    name=label)]
    finally:
        cleanup(pair, bag)
        _restore_fixture(source_fixture)
        if panel_table_fixture:
            _restore_fixture(panel_table_fixture)


def cases(rng, scale, pair):
    old_adapter = None
    screen_saved = []
    try:
        for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY):
            current = _adapter(pair, adapter)
            if old_adapter is None: old_adapter = current
            screen_saved = _screen_fixture(pair, adapter)
            yield from _capture_cases(pair, adapter)
            _restore_fixture(screen_saved); screen_saved = []

            source_offset = 0x1234
            image_payload = _image(salt=0x31 + adapter)
            yield from _stretch_case(pair, adapter, source_offset,
                                     0x2468 + adapter, f'{adapter} raw image', image_payload)

            # Exercise each active wrapper's source/destination policy against a real
            # eight-row image. The native code reads the same table and segment fields.
            if adapter == K.VIDEO_CGA:
                window_segment = (pair.a.m.peek('WorkspaceSegment') + 0x7D0 + 1) & 0xFFFF
                fixture = _fixture(pair, window_segment, 0, _image(salt=0x51))
                yield from _wrapper_case(pair, 'StretchInWindowImage', adapter, fixture,
                                         0, f'{adapter} window image',
                                         image_payload=_image(salt=0x51))

                end_segment_old = [side.m.peek('TheEndSegment') for side in (pair.a, pair.b)]
                for side in (pair.a, pair.b): side.m.poke('TheEndSegment', 0x7200)
                fixture = _fixture(pair, 0x7200, 0, _image(salt=0x61))
                yield from _wrapper_case(pair, 'StretchInTheEndImage', adapter, fixture,
                                         lambda m: m.word(pair.sym('ScreenRowOffsets') + 2 * 0x4E),
                                         f'{adapter} game-over image',
                                         image_payload=_image(salt=0x61))
                for side, value in zip((pair.a, pair.b), end_segment_old):
                    side.m.poke('TheEndSegment', value)

            # HUD panel origin and the EGA page-copy tail are adapter-dependent.
            panel_table_fixture = []
            for side in (pair.a, pair.b):
                table = side.m.linear('PanelImageOffsets') + 2 * K.PANEL_HUD_FRAME
                saved = bytes(side.m.u.mem_read(table, 2))
                panel_table_fixture.append((side, table, saved))
                side.m.u.mem_write(table, W(0x6000))
            panel_fixture = _fixture(pair, pair.a.m.peek('PanelSegment'), 0x6000,
                                     _image(salt=0x71 + adapter))
            yield from _wrapper_case(pair, 'StretchInHudPanel', adapter, panel_fixture,
                                     lambda m: (m.word(pair.sym('ScreenRowOffsets')) +
                                                0x1B * (2 if adapter == K.VIDEO_CGA else
                                                        4 if adapter == K.VIDEO_TANDY else 1)),
                                     f'{adapter} HUD frame', panel_table_fixture,
                                     image_payload=_image(salt=0x71 + adapter))
    finally:
        if screen_saved: _restore_fixture(screen_saved)
        if old_adapter: _restore_adapter(pair, old_adapter)


# Mutations cover frame progression, captured-row bank wrapping, header setup and the
# startup image source segment. All test images use the valid even-height 8-row format.
MUTANTS = [
    ('screen_animation.c',
     'row = (word)(row - 1);\n        row = (word)(row - 1);',
     'row = (word)(row - 1);'),
    ('screen_animation.c',
     'if ((source & (2 * CGA_BANK_BYTES)) != 0)\n'
     '                source = (word)(source + 0xC000 + CGA_SCREEN_ROW_BYTES);',
     'if ((source & (2 * CGA_BANK_BYTES)) != 0)\n'
     '                source = (word)(source + 0xC000 + CGA_SCREEN_ROW_BYTES + 1);'),
    ('screen_animation.c',
     'StretchShownRows = 6;', 'StretchShownRows = 4;'),
    ('screen_animation.c',
     'WorkspaceSegment + WIDE_PAGE_BYTES / 16 + 1',
     'WorkspaceSegment + WIDE_PAGE_BYTES / 16'),
]
