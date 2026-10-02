"""Page-list navigation and high-score row presentation against the ASM oracle.

Page loading and retrace are bounded MAIN services; their BP/ES results remain
live across navigation. Text cases use both controlled register results and the
real DOS text/BCD renderer. Key states change at matching poll/release boundaries.
"""
from difftest import Case
from world import World, K
from emu import REG, LOAD
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
from options import hook, cleanup, return_service, check
import hybrid
import struct

REGION = ['SHOWPAGELIST', 'SHOWHIGHSCORETABLE']
FREE = ('SP', 'DS', 'SS')
PAGE_ENTRY = 'TEST_SHOW_PAGE_LIST'
PAGE_SEGMENT = 0xE000
PAGE_OFFSET = 0x0100
PAGE_KEYS = (K.SCAN_LEFT, K.SCAN_UP, K.SCAN_PGUP, K.SCAN_BACKSPACE,
             K.SCAN_RIGHT, K.SCAN_DOWN, K.SCAN_PGDN, K.SCAN_SPACE, K.SCAN_ENTER)
C_ENTRIES = {'LoadAndShowPage': 'LOAD_AND_SHOW_PAGE'}
PREVIOUS_KEYS = PAGE_KEYS[:4]
NEXT_KEYS = PAGE_KEYS[4:]


def page_shim(pair):
    """Install a near entry in unused emulated RAM that far-calls ShowPageList."""
    saved = []
    absolute = PAGE_SEGMENT * 16 + PAGE_OFFSET
    for side in (pair.a, pair.b):
        m = side.m
        target_segment, target_offset = m.symbols['SHOWPAGELIST']
        shim = (b'\x9A' + struct.pack('<HH', target_offset, (LOAD + target_segment) & 0xFFFF)
                + b'\xC3')
        old = bytes(m.u.mem_read(absolute, len(shim)))
        prior = m.symbols.get(PAGE_ENTRY)
        saved.append((side, old, prior))
        m.u.mem_write(absolute, shim)
        m.symbols[PAGE_ENTRY] = ((PAGE_SEGMENT - LOAD) & 0xFFFF, PAGE_OFFSET)
        m.u.ctl_remove_cache(absolute, absolute + len(shim))
    def restore():
        for side, old, prior in reversed(saved):
            m = side.m
            m.u.mem_write(absolute, old)
            if prior is None: m.symbols.pop(PAGE_ENTRY, None)
            else: m.symbols[PAGE_ENTRY] = prior
            m.u.ctl_remove_cache(absolute, absolute + 6)
    return restore


def key_events(side, pair, bag, obs, events, release_state=0, release_reads=2):
    """Script KeyDownTable at each poll and release ESC after a bounded hold."""
    key_base = side.m.data_frame * 16 + pair.sym('KeyDownTable')
    def read_key(u, access, address, size, value, _):
        scan = address - key_base
        if scan == K.SCAN_LEFT:
            index = obs['polls']
            check(index < len(events), f"{obs['name']}: page input stream exhausted")
            states = dict(events[index])
            obs['polls'] += 1
            obs['current'] = {'states': states, 'esc_seen': 0}
            obs['read_order'].append([])
            data = bytearray(K.KEY_DOWN_COUNT)
            for key, state in states.items(): data[key] = state & 0xFF
            side.m.write(pair.sym('KeyDownTable'), data)
        if scan in PAGE_KEYS or scan == K.SCAN_ESC:
            if obs['read_order']: obs['read_order'][-1].append(scan)
        if scan == K.SCAN_ESC and obs['current'] is not None:
            current = obs['current']
            if current['states'].get(K.SCAN_ESC, 0) == K.KEY_STATE_DOWN:
                current['esc_seen'] += 1
                if current['esc_seen'] > release_reads:
                    side.m.write(pair.sym('KeyDownTable') + K.SCAN_ESC, bytes((release_state,)))
    hook(side, bag, UC_HOOK_MEM_READ, read_key, key_base, key_base + K.KEY_DOWN_COUNT - 1)


def page_services(side, pair, bag, obs, start_index=None, mutate_registers=True):
    """Bound MAIN rendering services and record both sides of their BP/ES handoff."""
    def service(label):
        def callback(u, address, size, _, side=side, obs=obs):
            direct_c = side is pair.b and label in C_ENTRIES
            metadata = u.reg_read(REG['SI']) if direct_c else None
            before = ((side.m.word(metadata), side.m.word(metadata + 2)) if direct_c else
                      (u.reg_read(REG['BP']), u.reg_read(REG['ES'])))
            if label == 'LoadAndShowPage':
                obs['loads'].append((side.m.word(pair.sym('PageListPtr')),
                                     side.m.word(pair.sym('PageIndex')), before))
                if len(obs['loads']) == 1 and start_index is not None:
                    side.m.set_word(pair.sym('PageIndex'), start_index)
            else:
                obs['wait_inputs'].append(before)
            if mutate_registers:
                serial = len(obs['service_trace']) + 1
                after = ((0xA100 + serial * 0x31) & 0xFFFF,
                         (0xB200 + serial * 0x17) & 0xFFFF)
                if direct_c:
                    side.m.set_word(metadata, after[0]); side.m.set_word(metadata + 2, after[1])
                else:
                    u.reg_write(REG['BP'], after[0]); u.reg_write(REG['ES'], after[1])
            else:
                after = before
            obs['service_trace'].append((label, before, after))
            return_service(side)
        actual = C_ENTRIES.get(label, label) if side is pair.b else label
        hook(side, bag, UC_HOOK_CODE, callback, side.m.linear(actual))
    service('LoadAndShowPage')
    service('WaitVerticalRetrace')


def trace_contract(obs, entry_bp, entry_es, loads, retraces, final_index):
    check(len(obs['loads']) == loads, f"{obs['name']}: expected {loads} page loads, got {len(obs['loads'])}")
    check(len(obs['wait_inputs']) == retraces,
          f"{obs['name']}: expected {retraces} retraces, got {len(obs['wait_inputs'])}")
    trace = obs['service_trace']
    check(len(trace) == loads + retraces, f"{obs['name']}: service trace length")
    prior = (entry_bp, entry_es)
    for label, before, after in trace:
        check(before == prior, f"{obs['name']}: {label} did not consume prior BP/ES result")
        prior = after
    check(obs['final_index'] == final_index,
          f"{obs['name']}: PageIndex {obs['final_index']:04X}, expected {final_index:04X}")


def browse(w, events, name, start_index=None, expected_index=0, expected_loads=1,
           expected_retraces=0, expected_polls=None, mutate_registers=True,
           expect_extra=None, release_state=0, release_reads=2):
    pair = w.pair
    bag = []
    observed = []
    entry_bp, entry_es = 0x5151, 0xB800
    for side in (pair.a, pair.b):
        obs = dict(name=name, loads=[], wait_inputs=[], service_trace=[], polls=0,
                   current=None, read_order=[])
        observed.append(obs)
        page_services(side, pair, bag, obs, start_index, mutate_registers)
        key_events(side, pair, bag, obs, events, release_state, release_reads)
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        check(observed[0] == observed[1], 'matching page loads, key reads and BP/ES service trace')
        check(observed[0]['polls'] == (len(events) if expected_polls is None else expected_polls),
              f'{name}: key poll count')
        observed[0]['final_index'] = m.word(pair.sym('PageIndex'))
        trace_contract(observed[0], entry_bp, entry_es, expected_loads, expected_retraces, expected_index)
        check(m.word(pair.sym('PageListPtr')) == pair.sym('OPageList'), f'{name}: PageListPtr')
        if expect_extra: expect_extra(m, observed[0])
    try:
        yield Case(PAGE_ENTRY, {'AX': pair.sym('OPageList'), 'BP': entry_bp, 'ES': entry_es},
                   w.writes(), FREE, outputs=('BP', 'ES'), expect=done, name=name)
    finally:
        cleanup(pair, bag)


def single_page(w, name):
    pair = w.pair
    bag = []
    observed = []
    entry_bp, entry_es = 0x5151, 0xB800
    for side in (pair.a, pair.b):
        obs = dict(name=name, loads=[], wait_inputs=[], service_trace=[], polls=0,
                   current=None, read_order=[])
        observed.append(obs)
        page_services(side, pair, bag, obs, mutate_registers=True)
        key_events(side, pair, bag, obs, ())
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        check(observed[0] == observed[1], 'matching single-page service trace')
        observed[0]['final_index'] = m.word(pair.sym('PageIndex'))
        trace_contract(observed[0], entry_bp, entry_es, 1, 0, 0)
        check(observed[0]['polls'] == 0, 'single page returns without polling')
        check(m.word(pair.sym('PageListPtr')) == pair.sym('OkMenuPageList'), 'single-page list pointer')
    try:
        yield Case(PAGE_ENTRY, {'AX': pair.sym('OkMenuPageList'), 'BP': entry_bp, 'ES': entry_es},
                   w.writes(), FREE, outputs=('BP', 'ES'), expect=done, name=name)
    finally: cleanup(pair, bag)


def high_score(w, name, real_text=False):
    pair = w.pair
    bag = []
    observed = []
    row_base = pair.sym('HiscoreBlock')
    prefix = pair.sym('HiscoreRowPrefix')
    entry_bp, final_bp = 0x5151, (row_base + 7 * 16 + 12) & 0xFFFF
    entry_es = 0xB800
    for side in (pair.a, pair.b):
        obs = dict(name=name, loads=[], wait_inputs=[], texts=[], scores=[], service_trace=[])
        observed.append(obs)
        def load(u, address, size, _, side=side, obs=obs):
            if side is pair.b:
                metadata = u.reg_read(REG['SI'])
                before = (side.m.word(metadata), side.m.word(metadata + 2))
            else:
                before = (u.reg_read(REG['BP']), u.reg_read(REG['ES']))
            obs['loads'].append((side.m.word(pair.sym('PageListPtr')),
                                 side.m.word(pair.sym('PageIndex')), before))
            obs['service_trace'].append(('LoadAndShowPage', before, before))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, load, side.m.linear(
            'LOAD_AND_SHOW_PAGE' if side is pair.b else 'LoadAndShowPage'))
        def retrace(u, address, size, _, side=side, obs=obs):
            before = (u.reg_read(REG['BP']), u.reg_read(REG['ES']))
            obs['wait_inputs'].append(before)
            obs['service_trace'].append(('WaitVerticalRetrace', before, before))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, retrace, side.m.linear('WaitVerticalRetrace'))
        native_text = side is pair.b
        def message(u, address, size, _, side=side, obs=obs, native_text=native_text):
            if native_text:
                metadata = u.reg_read(REG['SI'])
                bp, es = side.m.word(metadata), side.m.word(metadata + 2)
            else:
                bp = u.reg_read(REG['BP']); es = u.reg_read(REG['ES'])
            if es == side.m.data_frame: es = 'state segment'
            if bp == prefix:
                kind, payload = 'prefix', side.m.read(bp, 6)
            elif row_base <= bp < row_base + 8 * 16 and (bp - row_base) % 16 == 0:
                kind, payload = 'name', side.m.read(bp, 12)
            else:
                raise AssertionError(f'{name}: PrintMessageBP got unexpected BP={bp:04X}')
            obs['texts'].append((kind, bp, payload, es))
            obs['service_trace'].append(('PrintMessageBP', (bp, es),
                                        ((bp + (6 if kind == 'prefix' else 3)) & 0xFFFF, es)))
            # A control-code/name renderer advances BP. The table routine must discard
            # the name result before forming the score pointer for the same row.
            next_bp = (bp + (6 if kind == 'prefix' else 3)) & 0xFFFF
            if native_text:
                side.m.set_word(metadata, next_bp)
            else:
                u.reg_write(REG['BP'], next_bp)
            return_service(side)
        if not real_text:
            hook(side, bag, UC_HOOK_CODE, message,
                 side.m.linear('TEXT_PRINT_MESSAGE' if native_text else 'PrintMessageBP'))
        def score(u, address, size, _, side=side, obs=obs, native_text=native_text):
            if native_text:
                metadata = u.reg_read(REG['SI'])
                bp, es = side.m.word(metadata), side.m.word(metadata + 2)
            else:
                bp = u.reg_read(REG['BP']); es = u.reg_read(REG['ES'])
            if es == side.m.data_frame: es = 'state segment'
            obs['scores'].append((bp, side.m.read(bp, 4), es))
            obs['service_trace'].append(('PrintBcd32', (bp, es), (bp, es)))
            if not real_text: return_service(side)
        hook(side, bag, UC_HOOK_CODE, score,
             side.m.linear('TEXT_PRINT_BCD32' if native_text else 'PrintBcd32'))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        check(observed[0] == observed[1], 'matching high-score row, score and renderer trace')
        obs = observed[0]
        check(len(obs['loads']) == 1 and obs['wait_inputs'] == [], 'high-score page uses its one-page list')
        expected_texts, expected_scores = [], []
        for row in range(8):
            expected_texts.append(('prefix', prefix,
                                   bytes((0x11, row * 2 + 4, 0, 0x10, 0x0A, 0)), entry_es))
            at = row_base + row * 16
            expected_texts.append(('name', at, m.read(at, 12), 'state segment' if real_text else entry_es))
            expected_scores.append((at + 12, m.read(at + 12, 4), entry_es))
        # Real text loops through PrintTextChar; compare its video writes and state
        # through Pair, and observe only the top-level BCD calls.
        if real_text: expected_texts = []
        check(obs['texts'] == expected_texts, f'{name}: text trace {obs["texts"][:4]} versus {expected_texts[:4]}')
        check(obs['scores'] == expected_scores, 'each BCD call uses the saved row BP + 12')
        row_writes = [value for where, size, value in pair.a.outside
                      if where.upper().startswith('HISCOREROWINDEX') and size == 1]
        check(row_writes == list(range(9)), 'CS HiscoreRowIndex writes 0 through 8')
        check(m.read(prefix + 1, 1)[0] == 18, 'last row prefix position')
        check(m.word(pair.sym('PageListPtr')) == pair.sym('HiscorePageList'), 'high-score page list pointer')
        check(regs['BP'] == final_bp and regs['ES'] == 'unchanged', 'high-score BP/ES result')
    try:
        yield Case('ShowHighScoreTable', {'BP': entry_bp, 'ES': entry_es}, w.writes(), FREE,
                   outputs=('BP', 'ES'), expect=done, name=name)
    finally: cleanup(pair, bag)


def cases(rng, scale, pair):
    restore = page_shim(pair)
    try:
        # Every directional key is recognized at a valid page index.
        for scan in NEXT_KEYS:
            w = World(pair, rng)
            yield from browse(w, [{scan: 1}, {K.SCAN_ESC: 1}], f'next key {scan:02X}',
                              expected_index=1, expected_loads=2, expected_retraces=5)
        for scan in PREVIOUS_KEYS:
            w = World(pair, rng)
            yield from browse(w, [{K.SCAN_RIGHT: 1}, {scan: 1}, {K.SCAN_ESC: 1}],
                              f'previous key {scan:02X}', expected_index=0,
                              expected_loads=3, expected_retraces=10)
        # Start/end boundaries ignore the corresponding command without delaying.
        for scan in PREVIOUS_KEYS:
            yield from browse(World(pair, rng), [{scan: 1}, {K.SCAN_ESC: 1}],
                              f'previous boundary {scan:02X}', start_index=0,
                              expected_index=0, expected_loads=1)
        for scan in NEXT_KEYS:
            yield from browse(World(pair, rng), [{scan: 1}, {K.SCAN_ESC: 1}],
                              f'next boundary {scan:02X}', start_index=9,
                              expected_index=9, expected_loads=1)
        # State must equal KEY_STATE_DOWN. These non-1 values are ignored at index 1.
        rejected = {K.SCAN_LEFT: 2, K.SCAN_UP: 0xFF, K.SCAN_PGUP: 2,
                    K.SCAN_BACKSPACE: 0xFF, K.SCAN_RIGHT: 2, K.SCAN_DOWN: 0xFF,
                    K.SCAN_PGDN: 2, K.SCAN_SPACE: 0xFF, K.SCAN_ENTER: 2,
                    K.SCAN_ESC: 1}
        yield from browse(World(pair, rng), [rejected], 'exact down state', start_index=1,
                          expected_index=1, expected_loads=1, expected_polls=1,
                          expect_extra=lambda m, obs: check(len(obs['read_order'][0]) == 12,
                                                           'all non-down commands fall through to ESC'))
        # Any nonzero word before the list enables browsing.
        w = World(pair, rng).word(pair.sym('OPageList') - 2, 0xBEEF)
        yield from browse(w, [{K.SCAN_RIGHT: 1}, {K.SCAN_ESC: 1}], 'nonzero browse word',
                          expected_index=1, expected_loads=2, expected_retraces=5)
        yield from single_page(World(pair, rng), 'single page flag zero')

        # A held command repeats on each poll; both invalid ends ignore ESC in
        # the same poll because direction priority comes first.
        yield from browse(World(pair, rng),
                          [{K.SCAN_RIGHT: 1}] * 3 + [{K.SCAN_LEFT: 1}] * 2 + [{K.SCAN_ESC: 1}],
                          'held next and previous', expected_index=1,
                          expected_loads=6, expected_retraces=25)
        for previous in PREVIOUS_KEYS:
            for following in NEXT_KEYS:
                states = {previous: 1, following: 1, K.SCAN_ESC: 1}
                yield from browse(World(pair, rng), [states, {K.SCAN_ESC: 1}],
                                  f'previous wins {previous}/{following}', start_index=1,
                                  expected_index=0, expected_loads=2, expected_retraces=5)
                yield from browse(World(pair, rng), [states, {K.SCAN_ESC: 1}],
                                  f'blocked previous wins {previous}/{following}')
        for keys in (PREVIOUS_KEYS, NEXT_KEYS):
            for first in range(len(keys)):
                states = dict.fromkeys(keys[first:], 1)
                yield from browse(World(pair, rng), [states, {K.SCAN_ESC: 1}],
                                  f'within group priority {keys}/{first}', start_index=1,
                                  expected_index=0 if keys is PREVIOUS_KEYS else 2,
                                  expected_loads=2, expected_retraces=5,
                                  expect_extra=lambda m, o, key=keys[first]:
                                      check(o['read_order'][0][-1] == key, 'first down key stops comparisons'))
        for scan in PAGE_KEYS + (K.SCAN_ESC,):
            for state in (2, 0xFF):
                yield from browse(World(pair, rng), [{scan: state}, {K.SCAN_ESC: 1}],
                                  f'non-down {scan}/{state}', start_index=1, expected_index=1)
        for released in (0, 2, 0xFF):
            yield from browse(World(pair, rng), [{K.SCAN_ESC: 1}],
                              f'ESC held then state {released}', release_state=released, release_reads=4)
        # The index increment and shifted next-entry offset are unsigned words.
        yield from browse(World(pair, rng), [{K.SCAN_RIGHT: 1}, {K.SCAN_ESC: 1}],
                          'next index FFFF wraps to zero', start_index=0xFFFF,
                          expected_index=0, expected_loads=2, expected_retraces=5)
        yield from browse(World(pair, rng), [{K.SCAN_RIGHT: 1}, {K.SCAN_ESC: 1}],
                          'next index 7FFF shifts to zero', start_index=0x7FFF,
                          expected_index=0x8000, expected_loads=2, expected_retraces=5)
        yield from browse(World(pair, rng), [{K.SCAN_LEFT: 1}, {K.SCAN_ESC: 1}],
                          'previous index 8000 is unsigned', start_index=0x8000,
                          expected_index=0x7FFF, expected_loads=2, expected_retraces=5)

        # High-score text calls deliberately return an advanced BP, as control-code and
        # name rendering does. The score pointer must still come from the saved row base.
        w = World(pair, rng)
        rows = bytearray()
        for row in range(8):
            name = bytearray(b'ABCDEFGHIJ')
            name[row % 10] = (0x10, 0x11, 0x20, 0x7A)[row % 4]
            score = bytes((0x11 + row, 0x22 + row, 0x33 + row, 0x44 + row))
            rows += bytes(name) + b' \0' + score
        w.put('HiscoreBlock', rows)
        yield from high_score(w, 'row text BP restoration')
        for i in range(40 * scale):
            w = World(pair, rng).word('TextInGraphics', 0).word('TextRowOffset', 0x1234).byte('TextColor', 0x55)
            rows = bytearray()
            for row in range(8):
                text = (b'Name', bytes((0x10, rng.randrange(256))) + b'Color',
                        bytes((0x11, row * 2 + 4, 1)) + b'Move',
                        bytes((0x10, row + 1, 0x11, row * 2 + 4, 2)) + b'Both')[row % 4]
                rows += (text + b'\0').ljust(12, b' ') + bytes(rng.randrange(256) for _ in range(4))
            w.put('HiscoreBlock', rows)
            yield from high_score(w, f'real text and BCD {i}', real_text=True)
    finally:
        restore()


MUTANTS = [
    ('pages.c', 'if (keys[SCAN_LEFT] == KEY_STATE_DOWN ||',
                'if (keys[SCAN_LEFT] != KEY_STATE_DOWN ||'),
    ('pages.c', 'if (*(word *)(word)(PageListPtr - 2) == 0) return;',
                'if (*(word *)(word)(PageListPtr - 2) != 0) return;'),
    ('pages.c', 'for (n = 0; n < 5; n++) dos_service(WaitVerticalRetrace, registers);\n            PageIndex--;',
                'for (n = 0; n < 4; n++) dos_service(WaitVerticalRetrace, registers);\n            PageIndex--;'),
    ('pages.c', 'registers->bp = row + 12;', 'registers->bp = registers->bp + 12;'),
    ('pages.c', 'PageListPtr = list;', 'PageListPtr = list + 2;'),
    ('pages.c', 'PageIndex = 0;', 'PageIndex = 1;'),
    ('pages.c', 'if (PageIndex == 0) continue;', 'if ((sword)PageIndex <= 0) continue;'),
    ('pages.c', '== 0xFFFF) continue;', '!= 0xFFFF) continue;'),
    ('pages.c', 'PageIndex++;', 'PageIndex += 2;'),
    ('pages.c', 'while (keys[SCAN_ESC] == KEY_STATE_DOWN)', 'while (keys[SCAN_ESC] != 0)'),
    ('pages.c', 'for (n = 0; n < 8; n++)', 'for (n = 0; n < 7; n++)'),
    ('pages.c', 'HiscoreRowIndex = 0;', 'HiscoreRowIndex = 1;'),
    ('pages.c', '(word)HiscoreRowIndex * 16;', '(word)HiscoreRowIndex * 12;'),
    ('pages.c', '(HiscoreRowIndex << 1) + 4', '(HiscoreRowIndex << 1) + 3'),
]
