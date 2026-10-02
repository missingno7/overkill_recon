"""Bounded differential cases for the isolated display and HUD proposal."""
from difftest import Case
from world import World, K
from emu import REG
from options import hook, cleanup, return_service, check
from unicorn import UC_HOOK_CODE
import random

FREE = ('SP', 'DS', 'SS')
TEXT_WRITES = {
    'TextInGraphics': 1,
    'TextRowOffset': 0x20,
    'TextColumn': 0,
    'TextColor': 7,
}
PALETTE_TARGETS = (
    'CgaSelectBrightPaletteNoBurst', 'CgaSelectBrightPalette1',
    'CgaSelectBrightPalette0', 'CgaSelectBrightPalette1',
    'CgaSelectBrightPaletteNoBurst', 'CgaSelectBrightPalette0',
)


def set_video_adapter(pair, adapter, rebuild_rows=False):
    saved = []
    for side in (pair.a, pair.b):
        address = side.m.linear('VideoAdapter')
        old = bytes(side.m.u.mem_read(address, 2))
        saved.append((side, address, old, side.pristine))
        side.m.poke('VideoAdapter', adapter)
        if rebuild_rows:
            side.m.call('BuildRowTables')
            side.pristine = side.m.state()
    return saved


def restore_video_adapter(saved):
    for side, address, old, pristine in reversed(saved):
        side.m.u.mem_write(address, old)
        side.pristine = pristine


def install_trace(pair, labels, observed, bag):
    for side in (pair.a, pair.b):
        trace = []
        observed.append(trace)
        for label in labels:
            def enter(u, address, size, _, label=label, trace=trace):
                trace.append((label, u.reg_read(REG['BP']), u.reg_read(REG['ES']),
                              u.reg_read(REG['SI']), u.reg_read(REG['CX']),
                              u.reg_read(REG['DI'])))
            hook(side, bag, UC_HOOK_CODE, enter, side.m.linear(label))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def install_display_trace(pair, common_labels, observed, bag):
    """Trace semantic text calls on both images and retained platform draw leaves."""
    for side in (pair.a, pair.b):
        trace = []
        observed.append(trace)
        if side is pair.a:
            text_entries = (('PrintMessageBP', 'message'), ('PrintBcd32', 'bcd'))
            energy_entry = 'DrawEnergyGauge'
        else:
            text_entries = (('TEXT_PRINT_MESSAGE', 'message'),
                            ('TEXT_PRINT_BCD32', 'bcd'))
            energy_entry = 'RENDER_DRAW_ENERGY_GAUGE'

        for entry, operation in text_entries:
            def text_call(u, address, size, _, entry=entry, operation=operation,
                          side=side, trace=trace):
                if side is pair.a:
                    bp, es = u.reg_read(REG['BP']), u.reg_read(REG['ES'])
                    if operation == 'message' and bp not in (
                            pair.sym('ScoreMessagePrefix'), pair.sym('LevelNumberPrefix')):
                        return
                else:
                    metadata = u.reg_read(REG['SI'])
                    bp, es = side.m.word(metadata), side.m.word(metadata + 2)
                if es == side.m.data_frame:
                    es = 'state segment'
                trace.append((operation, bp, es))
            hook(side, bag, UC_HOOK_CODE, text_call, side.m.linear(entry))

        def energy(u, address, size, _, trace=trace):
            trace.append(('DrawEnergyGauge', u.reg_read(REG['BP']),
                          u.reg_read(REG['ES'])))
        hook(side, bag, UC_HOOK_CODE, energy, side.m.linear(energy_entry))

        for label in common_labels:
            def enter(u, address, size, _, label=label, trace=trace):
                trace.append((label, u.reg_read(REG['BP']), u.reg_read(REG['ES'])))
            hook(side, bag, UC_HOOK_CODE, enter, side.m.linear(label))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def install_character_trace(pair, observed, bag):
    for side in (pair.a, pair.b):
        trace = []
        observed.append(trace)
        def enter(u, address, size, _, trace=trace, side=side):
            if side is pair.a:
                character = u.reg_read(REG['AX']) & 0xFF
                bp, es = u.reg_read(REG['BP']), u.reg_read(REG['ES'])
            else:
                character = u.reg_read(REG['SI']) & 0xFF
                metadata = u.reg_read(REG['DI'])
                bp, es = side.m.word(metadata), side.m.word(metadata + 2)
            if es == side.m.data_frame:
                es = 'state segment'
            trace.append((character, bp, es))
        target = 'PrintTextChar' if side is pair.a else 'TEXT_EMIT_CHARACTER'
        hook(side, bag, UC_HOOK_CODE, enter, side.m.linear(target))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def install_palette_trace(pair, observed, bag):
    for side in (pair.a, pair.b):
        trace = []
        observed.append(trace)
        for label in dict.fromkeys(PALETTE_TARGETS):
            def selector(u, address, size, _, label=label, trace=trace, side=side):
                trace.append(label)
                return_service(side)
            hook(side, bag, UC_HOOK_CODE, selector, side.m.linear(label))
        def dac(u, address, size, _, trace=trace):
            trace.append('SetDacColor6')
        hook(side, bag, UC_HOOK_CODE, dac, side.m.linear('SetDacColor6'))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def world(pair, rng, lives=2, level=1):
    w = World(pair, rng)
    for name, value in TEXT_WRITES.items():
        if name == 'TextColumn' or name == 'TextColor': w.byte(name, value)
        else: w.word(name, value)
    return (w.word('LivesLeft', lives).word('LevelIndex', level)
            .word('EnergyPoints', 0x10).word('EnergyTanks', 2)
            .word('HudTankCompare', 0).put('ScoreBcd', bytes((0x56, 0x34, 0x12, 0x90))))


def cases(rng, scale, pair):
    del scale

    # The rank prefix takes CGA's bright colour only on adapter 0; all other adapter
    # values select the normal 0Ah text colour.
    for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY, 3, 0xFFFF):
        saved = set_video_adapter(pair, adapter)
        try:
            w = World(pair, rng).byte('HiscoreRankPrefix', 0x55)
            expected = 3 if adapter == K.VIDEO_CGA else 0x0A
            def expect(m, regs, expected=expected):
                check(m.read(pair.sym('HiscoreRankPrefix') + 4, 1)[0] == expected,
                      'rank-color byte follows adapter selection')
            yield Case('SetHiscoreRankColor', {'BP': 0x7234, 'ES': 0xB800}, w.writes(),
                       preserve=('BP', 'ES'), expect=expect, name=f'adapter={adapter:04X}')
        finally:
            restore_video_adapter(saved)

    # CGA table choices include values whose 16-bit shift wraps to a valid entry.
    for level in (*range(K.LEVEL_COUNT), 0x8000, 0x8001, 0x8002):
        for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY, 3):
            saved = set_video_adapter(pair, adapter)
            bag, observed = [], []
            install_palette_trace(pair, observed, bag)
            try:
                w = World(pair, rng).word('LevelIndex', level)
                expected = []
                if adapter == K.VIDEO_CGA:
                    expected.append(PALETTE_TARGETS[(level << 1 & 0xFFFF) >> 1]
                                    if (level << 1 & 0xFFFF) <= 10 else 'raw-invalid')
                else:
                    expected.append('SetDacColor6')
                try:
                    yield Case('ApplyLevelPalette', {'BP': 0x7111, 'ES': 0xB800}, w.writes(),
                               FREE, outputs=('BP', 'ES'), name=f'adapter={adapter:04X} level={level:04X}')
                    check(observed[0] == observed[1],
                          'palette target traces match between oracle and proposal')
                    trace = observed[1]
                    if expected == ['raw-invalid']:
                        check(not trace, 'invalid raw palette dispatch is left to the original code path')
                    else:
                        check(trace == expected, f'palette target {trace!r} != {expected!r}')
                finally:
                    cleanup(pair, bag)
            finally:
                restore_video_adapter(saved)

    # DrawScore enters the native text message and BCD coordinators in the candidate;
    # both still use the same MAIN character renderer as the oracle.
    bag, observed = [], []
    install_display_trace(pair, (), observed, bag)
    try:
        for score in (bytes((0, 0, 0, 0)), bytes((0x56, 0x34, 0x12, 0x90)),
                      bytes((0xFA, 0xB0, 0x1E, 0x99))):
            w = world(pair, rng).put('ScoreBcd', score)
            def expect(m, regs):
                check(regs['BP'] == pair.sym('ScoreBcd'), 'DrawScore leaves BP on ScoreBcd')
            try:
                yield Case('DrawScore', {'BP': 0x7744, 'ES': 0xB800}, w.writes(), FREE,
                           outputs=('BP', 'ES'), expect=expect, name=f'packed BCD {score.hex()}')
                expected_trace = [('message', pair.sym('ScoreMessagePrefix'), 0xB800),
                                  ('bcd', pair.sym('ScoreBcd'), 'state segment')]
                check(observed[0] == expected_trace and observed[1] == expected_trace,
                      f'native and oracle score text metadata {observed!r} != {expected_trace!r}')
            finally:
                observed[0].clear(); observed[1].clear()
    finally:
        cleanup(pair, bag)

    # XLAT indexes with AL, so only LevelIndex's low byte selects the displayed digit.
    for level in (*range(K.LEVEL_COUNT), 0x0100, 0x0101, 0x0105, 0xFFFF):
        bag, observed = [], []
        install_character_trace(pair, observed, bag)
        try:
            w = world(pair, rng, level=level)
            offset = (pair.sym('LevelDigitChars') + (level & 0xFF)) & 0xFFFF
            expected_character = pair.a.m.read(offset, 1)[0]
            def expect(m, regs, expected_character=expected_character):
                check(observed[0] == observed[1],
                      f'level text character/BP/ES trace differs: {observed!r}')
                check(observed[0][-1][0] == expected_character,
                      'low-byte XLAT value is sent to the text renderer')
            try:
                yield Case('DrawLevelNumber', {'BP': 0x7355, 'ES': 0xB800}, w.writes(), FREE,
                           outputs=('BP', 'ES'), expect=expect, name=f'level={level:04X}')
            finally:
                cleanup(pair, bag)
        finally:
            pass

    # Small counts run through the real adapter-specific screen offset and panel blitter.
    for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY):
        saved = set_video_adapter(pair, adapter, rebuild_rows=True)
        try:
            for lives in range(4):
                bag, observed = [], []
                install_trace(pair, ('DrawPanelImageRow',), observed, bag)
                w = world(pair, rng, lives=lives)
                expected_counts = (lives, (3 - lives) & 0xFFFF)
                case = Case('DrawLivesIcons', {'BP': 0x7245, 'ES': 0xB800}, w.writes(), FREE,
                            outputs=('BP', 'ES'), name=f'adapter={adapter} lives={lives}')
                try:
                    yield case
                    check(observed[0] == observed[1],
                          'panel loop service traces match between oracle and proposal')
                    trace = observed[1]
                    def row_visits(count):
                        return [0] if count == 0 else list(range(count, 0, -1))
                    visit_counts = tuple(row[4] for row in trace)
                    expected_visits = tuple(row_visits(expected_counts[0]) +
                                            row_visits(expected_counts[1]))
                    check(visit_counts == expected_visits,
                          f'panel loop counts {visit_counts!r} != {expected_visits!r}')
                    check(len(pair.a.outside) > 0, 'real panel rows write screen memory')
                    column_bytes = (2, 1, 4)[adapter]
                    expected_di = (trace[0][5] + expected_counts[0] * 2 * column_bytes) & 0xFFFF
                    second_row = trace[max(len(row_visits(expected_counts[0])), 1)]
                    check(second_row[5] == expected_di,
                          'empty icons start after the ship row using adapter byte stride')
                finally:
                    cleanup(pair, bag)
        finally:
            restore_video_adapter(saved)

    # 3 - LivesLeft is an unsigned word subtraction. Stub the shared row painter only
    # for large counts, observe its inputs, and model the real two-column DI wrap.
    for adapter, lives in ((K.VIDEO_CGA, 4), (K.VIDEO_EGA, 4), (K.VIDEO_TANDY, 4),
                           (K.VIDEO_TANDY, 0xFFFF)):
        saved = set_video_adapter(pair, adapter, rebuild_rows=True)
        bag, observed = [], []
        for side in (pair.a, pair.b):
            trace = []
            observed.append(trace)
            def skip_large_row(u, address, size, _, side=side, trace=trace, adapter=adapter):
                count = u.reg_read(REG['CX'])
                start = u.reg_read(REG['DI'])
                trace.append((u.reg_read(REG['SI']), u.reg_read(REG['BP']),
                              u.reg_read(REG['ES']), count, start))
                delta = count * 2 * (2, 1, 4)[adapter]
                u.reg_write(REG['DI'], (start + delta) & 0xFFFF)
                u.reg_write(REG['CX'], 0)
                u.reg_write(REG['DS'], side.m.peek('MainDataSegment'))
                return_service(side)
            hook(side, bag, UC_HOOK_CODE, skip_large_row, side.m.linear('DrawPanelImageRow'))
            side.m.u.ctl_remove_cache(side.image[0], side.image[1])
        w = world(pair, rng, lives=lives)
        counts = (lives, (3 - lives) & 0xFFFF)
        try:
            yield Case('DrawLivesIcons', {'BP': 0x7466, 'ES': 0xB800}, w.writes(), FREE,
                       outputs=('BP', 'ES'), name=f'wrapped counts adapter={adapter} lives={lives}')
            check([entry[3] for entry in observed[0]] == list(counts) and
                  [entry[3] for entry in observed[1]] == list(counts),
                  'wrapped life counts reach the panel painter unchanged')
            check(observed[0] == observed[1], 'large-row service traces match')
            byte_step = (2, 1, 4)[adapter]
            expected_next = (observed[0][0][4] + counts[0] * 2 * byte_step) & 0xFFFF
            check(observed[0][1][4] == expected_next,
                  '16-bit screen offset wraps across the first icon row')
        finally:
            cleanup(pair, bag)
            restore_video_adapter(saved)

    # DrawHud's native C text and energy calls preserve the oracle's page/service order.
    expected_services = {
        K.VIDEO_CGA: ['ScoreMessage', 'PrintBcd32', 'PanelRows',
                      'DrawEnergyGauge', 'LevelMessage'],
        K.VIDEO_TANDY: ['ScoreMessage', 'PrintBcd32', 'PanelRows',
                        'DrawEnergyGauge', 'LevelMessage'],
        K.VIDEO_EGA: ['ScoreMessage', 'PrintBcd32', 'FlipEgaDrawPage',
                      'ScoreMessage', 'PrintBcd32', 'FlipEgaDrawPage',
                      'PanelRows', 'FlipEgaDrawPage', 'PanelRows', 'FlipEgaDrawPage',
                      'DrawEnergyGauge', 'FlipEgaDrawPage', 'DrawEnergyGauge',
                      'FlipEgaDrawPage', 'LevelMessage', 'FlipEgaDrawPage',
                      'LevelMessage', 'FlipEgaDrawPage'],
    }
    for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY):
        saved = set_video_adapter(pair, adapter, rebuild_rows=True)
        bag, observed = [], []
        labels = ('DrawPanelImageRow', 'FlipEgaDrawPage')
        install_display_trace(pair, labels, observed, bag)
        try:
            w = world(pair, rng, lives=2, level=3)
            case = Case('DrawHud', {'BP': 0x7788, 'ES': 0xB800}, w.writes(), FREE,
                        outputs=('BP', 'ES'), name=f'adapter={adapter}')
            try:
                yield case
                def hud_service_trace(entries):
                    trace = []
                    for entry in entries:
                        label, bp = entry[0], entry[1]
                        if label == 'message':
                            if bp == pair.sym('ScoreMessagePrefix'):
                                name = 'ScoreMessage'
                            elif bp == pair.sym('LevelNumberPrefix'):
                                name = 'LevelMessage'
                            else:
                                continue
                        elif label == 'bcd':
                            name = 'PrintBcd32'
                        elif label == 'DrawPanelImageRow':
                            name = 'PanelRows'
                        else:
                            name = label
                        if not trace or trace[-1] != name: trace.append(name)
                    return trace
                oracle_trace = hud_service_trace(observed[0])
                proposal_trace = hud_service_trace(observed[1])
                check(oracle_trace == expected_services[adapter],
                      f'oracle HUD service order {oracle_trace!r} != {expected_services[adapter]!r}')
                check(proposal_trace == oracle_trace,
                      f'proposal HUD service order {proposal_trace!r} != oracle {oracle_trace!r}')
                check(len(pair.a.outside) > 0, 'HUD painter writes screen memory')
            finally:
                cleanup(pair, bag)
        finally:
            restore_video_adapter(saved)


MUTANTS = [
    ('display.c', 'case 1: selector = CgaSelectBrightPalette1; break;',
     'case 1: selector = CgaSelectBrightPalette0; break;'),
    ('display.c', 'LevelDigitChars[(byte)LevelIndex]', 'LevelDigitChars[LevelIndex]'),
    ('display.c', '(word)((word)3 - LivesLeft)', '(word)(LivesLeft - (word)3)'),
    ('display.c', 'if (VideoAdapter == VIDEO_EGA) {\n        display_service(registers, FlipEgaDrawPage);\n        display_draw_score(registers);',
     'if (VideoAdapter != VIDEO_EGA) {\n        display_service(registers, FlipEgaDrawPage);\n        display_draw_score(registers);'),
    ('display.c', 'VideoAdapter == VIDEO_CGA ? 3 : 0x0A',
     'VideoAdapter == VIDEO_CGA ? 4 : 0x0A'),
]
