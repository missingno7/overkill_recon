"""Bounded differential checks for the uncalled payment-text viewer.

The real ENC decoder and file-open retry control run in both images. The test supplies
only DOS file bytes plus the screen/probe/retrace leaves, then drives one navigation
decision and Escape release so neither run enters an unbounded viewer loop.
"""
import struct

import difftest
from difftest import Case, far
from emu import FLAG, LOAD, REG
from options import cleanup, hook
from world import World, K
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ

for _name in ('TextScreenSegment', 'TextTopLine', 'TextLineCount'):
    if _name not in difftest.FAR_LABELS:
        difftest.FAR_LABELS += (_name,)

FREE = ('SP', 'DS', 'SS')
NAV_KEYS = (K.SCAN_HOME, K.SCAN_END, K.SCAN_UP, K.SCAN_DOWN,
            K.SCAN_PGUP, K.SCAN_PGDN)


def check(value, message):
    if not value:
        raise AssertionError(message)


def word(value):
    return struct.pack('<H', value & 0xFFFF)


def return_near(side, u):
    sp = u.reg_read(REG['SP'])
    ss = u.reg_read(REG['SS'])
    ip = struct.unpack('<H', bytes(u.mem_read(ss * 16 + sp, 2)))[0]
    u.reg_write(REG['IP'], ip)
    u.reg_write(REG['SP'], (sp + 2) & 0xFFFF)


def return_far(side, u):
    sp = u.reg_read(REG['SP'])
    ss = u.reg_read(REG['SS'])
    ip, cs = struct.unpack('<HH', bytes(u.mem_read(ss * 16 + sp, 4)))
    u.reg_write(REG['IP'], ip)
    u.reg_write(REG['CS'], cs)
    u.reg_write(REG['SP'], (sp + 4) & 0xFFFF)


def set_flag(u, name, enabled):
    flags = u.reg_read(REG['FLAGS'])
    if enabled:
        flags |= FLAG[name]
    else:
        flags &= ~FLAG[name]
    u.reg_write(REG['FLAGS'], flags)


def read_z(side, segment, offset, maximum=32):
    result = bytearray()
    for i in range(maximum):
        value = side.m.u.mem_read(segment * 16 + ((offset + i) & 0xFFFF), 1)[0]
        if value == 0:
            return bytes(result)
        result.append(value)
    raise AssertionError('payment path is not terminated')


def enc_literals(payload):
    """A literal-only ENC stream followed by its 0,0,0 terminator token."""
    out = bytearray()
    cursor = 0
    while cursor < len(payload):
        count = min(8, len(payload) - cursor)
        out.append((1 << count) - 1)
        out.extend(payload[cursor:cursor + count])
        cursor += count
    if len(payload) % 8 == 0:
        out.append(0)
    out.extend(b'\0\0\0')
    return bytes(out)


def install(side, pair, *, stream, opens=(True,), drive=2, mono=False,
            read_error=False, action=(), initial_top=0, enter_escape=True,
            escape_after_unchanged_down=False):
    bag = []
    trace = dict(opens=[], dos=[], bios=[], draws=0, retraces=0, shutdown=0,
                 key_escape_reads=0, down_reads=0, escape_injected=False)

    native_open = 'ARCHIVE_OPEN_BY_NAME' in side.m.symbols
    open_at = side.m.linear('archive_open_by_name' if native_open else 'OpenResourceFile')
    probe_at = side.m.linear('ProbeMonoHercules')
    draw_at = side.m.linear('DrawPaymentTextPage')
    retrace_at = side.m.linear('WaitTextVerticalRetrace')
    shutdown_at = side.m.linear('ShutdownGame')
    key_at = side.m.data_frame * 16 + pair.sym('KeyDownTable')
    nav = tuple(action)
    open_index = [0]
    show_cs = LOAD + side.m.symbols['SHOWPAYMENTTEXT'][0]
    show_return = side.m.sentinel(show_cs)

    def code(u, address, size, _, side=side):
        if address == open_at:
            ds = u.reg_read(REG['DS'])
            dx = u.reg_read(REG['SI'] if native_open else REG['DX'])
            pathname = read_z(side, ds, dx)
            index = open_index[0]
            open_index[0] += 1
            succeeded = opens[index] if index < len(opens) else opens[-1]
            trace['opens'].append((pathname, succeeded))
            u.reg_write(REG['AX'], 0x1234 if succeeded else 2)
            if native_open:
                u.reg_write(REG['DX'], 0 if succeeded else 1)
                return_near(side, u)
            else:
                u.reg_write(REG['BX'], 0x1234)
                set_flag(u, 'CF', not succeeded)
                return_far(side, u)
            return

        if address == probe_at:
            ax = u.reg_read(REG['AX'])
            u.reg_write(REG['AX'], (ax & 0xFF00) | int(mono))
            set_flag(u, 'ZF', not mono)
            return_near(side, u)
            return

        if address == draw_at:
            trace['draws'] += 1
            if trace['draws'] == 1 and initial_top != 0:
                side.m.poke('TextTopLine', initial_top)
            u.reg_write(REG['BP'], 0x18)
            u.reg_write(REG['ES'], side.m.peek('TextScreenSegment'))
            if trace['draws'] == 2 and action:
                side.m.write(pair.sym('KeyDownTable'), bytes(K.KEY_DOWN_COUNT))
                side.m.write(pair.sym('KeyDownTable') + K.SCAN_ESC,
                             bytes((K.KEY_STATE_DOWN,)))
            return_near(side, u)
            return

        if address == retrace_at:
            trace['retraces'] += 1
            return_near(side, u)
            return

        if address == shutdown_at:
            trace['shutdown'] += 1
            return_near(side, u)
            return

        opcode = bytes(u.mem_read(address, 2))
        if opcode == b'\xCD\x10':
            ax, cx = u.reg_read(REG['AX']), u.reg_read(REG['CX'])
            trace['bios'].append((ax, cx if (ax >> 8) == 1 else None))
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
            return
        if opcode != b'\xCD\x21':
            return

        ax = u.reg_read(REG['AX'])
        function = ax >> 8
        if function == K.DOS_GET_DRIVE:
            trace['dos'].append(('drive', drive))
            u.reg_write(REG['AX'], (ax & 0xFF00) | drive)
            set_flag(u, 'CF', False)
        elif function == K.DOS_READ_FILE:
            ds, dx, count = (u.reg_read(REG['DS']), u.reg_read(REG['DX']),
                             u.reg_read(REG['CX']))
            handle = u.reg_read(REG['BX'])
            if read_error:
                trace['dos'].append(('read-error', handle, count))
                u.reg_write(REG['AX'], 5)
                set_flag(u, 'CF', True)
            else:
                amount = min(count, len(stream))
                trace['dos'].append(('read', handle, count, amount))
                if amount:
                    u.mem_write(ds * 16 + dx, stream[:amount])
                u.reg_write(REG['AX'], amount)
                set_flag(u, 'CF', False)
        elif function == K.DOS_CLOSE_FILE:
            trace['dos'].append(('close', u.reg_read(REG['BX'])))
            u.reg_write(REG['AX'], 0)
            set_flag(u, 'CF', False)
        else:
            raise AssertionError(f'unexpected DOS function {function:02X}')
        u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)

    def key_read(u, access, address, size, value, _, side=side):
        scan = address - key_at
        if scan == K.SCAN_DOWN and escape_after_unchanged_down:
            trace['down_reads'] += 1
            if trace['down_reads'] >= 2:
                side.m.write(pair.sym('KeyDownTable') + K.SCAN_DOWN, b'\0')
            return
        if (scan == K.SCAN_PGDN and escape_after_unchanged_down and
                trace['down_reads'] >= 2 and not trace['escape_injected']):
            # Inject Escape after this pass has already checked its Escape slot.
            # The final no-action jump runs once before the next pass exits.
            side.m.write(pair.sym('KeyDownTable') + K.SCAN_ESC,
                         bytes((K.KEY_STATE_DOWN,)))
            trace['escape_injected'] = True
            return
        if scan != K.SCAN_ESC:
            return
        if side.m.read(pair.sym('KeyDownTable') + scan, 1)[0] != K.KEY_STATE_DOWN:
            return
        trace['key_escape_reads'] += 1
        if trace['key_escape_reads'] == 2:
            side.m.write(pair.sym('KeyDownTable') + scan, b'\0')

    def capture_return(u, address, size, _, side=side):
        if u.reg_read(REG['CS']) != show_cs:
            return
        trace['result'] = dict(
            bp=u.reg_read(REG['BP']), es=u.reg_read(REG['ES']),
            top=side.m.peek('TextTopLine'), lines=side.m.peek('TextLineCount'),
            screen=side.m.peek('TextScreenSegment'),
            error=side.m.read(pair.sym('ExitWithError'), 1)[0],
            filename=side.m.word(pair.sym('FileNamePtr')))

    hook(side, bag, UC_HOOK_CODE, code, *side.image)
    hook(side, bag, UC_HOOK_MEM_READ, key_read, key_at,
         key_at + K.KEY_DOWN_COUNT - 1)
    hook(side, bag, UC_HOOK_CODE, capture_return, show_return)

    w = World(pair, 1)
    keys = bytearray(K.KEY_DOWN_COUNT)
    for scan in nav:
        keys[scan] = K.KEY_STATE_DOWN
    if not action and enter_escape:
        keys[K.SCAN_ESC] = K.KEY_STATE_DOWN
    w.put('KeyDownTable', keys)
    w.put(far('TextTopLine'), word(initial_top))
    w.put(far('TextLineCount'), word(0x55AA))
    return w, bag, trace


def viewer_case(pair, *, name, payload, nav=(), opens=(True,), drive=2,
                mono=False, read_error=False, initial_top=0, expected_top=None,
                expected_draws=0, expected_retraces=0, expected_shutdown=0,
                escape=True, escape_after_unchanged_down=False):
    stream = enc_literals(payload) if not read_error and opens[-1] else b''
    traces, bags = [], []
    worlds = []
    for side in (pair.a, pair.b):
        w, bag, trace = install(side, pair, stream=stream, opens=opens, drive=drive,
                                mono=mono, read_error=read_error, action=nav,
                                initial_top=initial_top, enter_escape=escape,
                                escape_after_unchanged_down=escape_after_unchanged_down)
        worlds.append(w); bags.append(bag); traces.append(trace)

    case = Case('ShowPaymentText', {'AX': 0xA55A, 'BX': 0x2468, 'CX': 0x369A,
                                    'DX': 0x48BC, 'SI': 0x5ADE, 'DI': 0x6CEF,
                                    'BP': 0x7135, 'ES': 0xB800},
                writes=worlds[0].writes(), preserve=FREE, outputs=('BP', 'ES'),
                name=name)
    try:
        yield case
        check(traces[0] == traces[1], f'{name}: service trace matches')
        trace = traces[0]
        check([row[0] for row in trace['opens']] == [b'payment.enc'] * len(opens),
              f'{name}: payment.enc open count and path')
        check([row[1] for row in trace['opens']] == list(opens),
              f'{name}: open retry results')
        check(trace['bios'] == [(3, None), (0x0103, 0x2000)],
              f'{name}: mode and hidden-cursor BIOS order')
        result = trace['result']
        check(result['screen'] == (0xB000 if mono else 0xB800),
              f'{name}: mono/color text segment')
        check(trace['draws'] == expected_draws, f'{name}: draw count')
        check(trace['retraces'] == expected_retraces, f'{name}: retrace count')
        check(trace['shutdown'] == expected_shutdown, f'{name}: shutdown count')
        if expected_top is not None:
            check(result['top'] == expected_top,
                  f'{name}: top line is {expected_top}')
        expected_lines = 0x55AA if read_error or expected_shutdown else (
            payload.split(b'\x1A', 1)[0].count(b'\r') + 1)
        check(result['lines'] == expected_lines, f'{name}: CR-counted line total')
        check(result['bp'] == (0x18 if expected_draws else 0x7135),
              f'{name}: BP follows the last draw, or stays inherited')
        check(result['es'] == ((0xB000 if mono else 0xB800)
                               if expected_draws else 0xB800),
              f'{name}: ES follows the last draw, or stays inherited')
        if expected_shutdown:
            check(result['error'] == 1,
                  f'{name}: fatal open failure increments ExitWithError')
        check(result['filename'] == pair.a.m.offset('PaymentFileName'),
              f'{name}: error state retains PaymentFileName')
        if read_error:
            check(trace['dos'] == [('read-error', 0x1234, 0x400)],
                  f'{name}: initial read error leaves the handle open')
        elif expected_shutdown == 0:
            if opens == (False, True):
                check(trace['dos'][0] == ('drive', drive),
                      f'{name}: failed open checks the current drive before retry')
            check(trace['dos'][-2:] == [('read', 0x1234, 0x400, len(stream)),
                                        ('close', 0x1234)],
                  f'{name}: actual ENC read and close')
    finally:
        cleanup(pair, [item for bag in bags for item in bag])


def scroll_case(pair, label, top, line_count, ax, name, expected_ax, expected_cx,
                expected_top):
    w = World(pair, 5).put(far('TextTopLine'), word(top))
    w.put(far('TextLineCount'), word(line_count))
    snapshots, bag = [], []
    for side in (pair.a, pair.b):
        snapshot = {}; snapshots.append(snapshot)
        cs = LOAD + side.m.symbols[label.upper()][0]
        sentinel = side.m.sentinel(cs)
        def capture(u, address, size, _, side=side, snapshot=snapshot, cs=cs):
            if u.reg_read(REG['CS']) == cs:
                snapshot['top'] = side.m.peek('TextTopLine')
                snapshot['ax'] = u.reg_read(REG['AX'])
                snapshot['cx'] = u.reg_read(REG['CX'])
                snapshot['lines'] = side.m.peek('TextLineCount')

        hook(side, bag, UC_HOOK_CODE, capture, sentinel)
    case = Case(label, {'AX': ax, 'CX': 0xA5A5, 'SI': 0x369A, 'DI': 0x48BC,
                        'BP': 0x5ADE, 'ES': 0xB800}, w.writes(),
                preserve=('SI', 'DI', 'BP', 'ES', 'DS', 'SS', 'SP'),
                outputs=('AX', 'CX'), name=name)
    try:
        yield case
        check(snapshots[0].get('top') == expected_top,
              f'{name}: top line transition')
        check(snapshots[1].get('top') == expected_top,
              f'{name}: hybrid top line transition')
        check(snapshots[0].get('ax') == expected_ax,
              f'{name}: AX output')
        check(snapshots[0].get('cx') == expected_cx,
              f'{name}: CX output')
        check(snapshots[0].get('lines') == line_count and
              snapshots[1].get('ax') == expected_ax and
              snapshots[1].get('cx') == expected_cx and
              snapshots[1].get('lines') == line_count,
              f'{name}: hybrid register/state outputs')
    finally:
        cleanup(pair, bag)


def cases(rng, scale, pair):
    for label, top, lines, ax, name, out_ax, out_cx, out_top in (
        ('PaymentTextScrollUp', 0, 40, 0x1234, 'up at zero', 0x1234, 0, 0),
        ('PaymentTextScrollUp', 9, 40, 0x5678, 'up one line', 0x5678, 1, 8),
        ('PaymentTextScrollUp', 0xFFFF, 0, 0x9ABC, 'up wraps unsigned word', 0x9ABC, 1, 0xFFFE),
        ('PaymentTextScrollDown', 0, 25, 0x1357, 'down stops at 24-line bound', 25, 0, 0),
        ('PaymentTextScrollDown', 0, 26, 0x2468, 'down uses strict bound', 25, 1, 1),
        ('PaymentTextScrollDown', 0xFFFF, 0, 0x369A, 'down candidate wraps', 24, 0, 0xFFFF),
    ):
        yield from scroll_case(pair, label, top, lines, ax, name,
                               out_ax, out_cx, out_top)

    payload = b''.join(f'line{i:02d}\r\n'.encode('ascii') for i in range(30)) + b'\x1A'
    yield from viewer_case(pair, name='ESC precedes every navigation key', payload=payload,
                           nav=(K.SCAN_ESC,) + NAV_KEYS, initial_top=4, expected_top=4,
                           expected_draws=1)
    yield from viewer_case(pair, name='Home precedes End and all scrolling keys',
                           payload=payload, nav=NAV_KEYS, initial_top=4,
                           expected_top=0, expected_draws=2)
    yield from viewer_case(pair, name='End precedes Up and page movement', payload=payload,
                           nav=(K.SCAN_END, K.SCAN_UP, K.SCAN_PGUP, K.SCAN_PGDN),
                           expected_top=6, expected_draws=2)
    yield from viewer_case(pair, name='Up precedes Page Up', payload=payload,
                           nav=(K.SCAN_UP, K.SCAN_PGUP), initial_top=4,
                           expected_top=3, expected_draws=2)
    yield from viewer_case(pair, name='Down precedes Page Down', payload=payload,
                           nav=(K.SCAN_DOWN, K.SCAN_PGDN), initial_top=4,
                           expected_top=5, expected_draws=2)
    yield from viewer_case(pair, name='Down at the lower page bound returns to polling',
                           payload=payload, nav=(K.SCAN_DOWN,), initial_top=6,
                           expected_top=6, expected_draws=1,
                           escape_after_unchanged_down=True)
    yield from viewer_case(pair, name='Page Up precedes Page Down', payload=payload,
                           nav=(K.SCAN_PGUP, K.SCAN_PGDN), initial_top=6,
                           expected_top=0, expected_draws=2, expected_retraces=8,
                           mono=True)
    yield from viewer_case(pair, name='Page Down advances by 23 attempts', payload=payload,
                           nav=(K.SCAN_PGDN,), expected_top=6, expected_draws=2,
                           expected_retraces=8)
    yield from viewer_case(pair, name='A/B current drive retries open', payload=payload,
                           opens=(False, True), drive=1, mono=True,
                           expected_top=0, expected_draws=1)
    yield from viewer_case(pair, name='line count advances on CR alone',
                           payload=b'alpha\rbeta\rgamma\x1A',
                           expected_top=0, expected_draws=1)
    yield from viewer_case(pair, name='non-removable current drive enters error shutdown',
                           payload=b'', opens=(False,), drive=2, expected_shutdown=1,
                           escape=False)
    yield from viewer_case(pair, name='initial ENC read failure waits only for Escape release',
                           payload=b'', read_error=True, expected_draws=0,
                           expected_top=4, initial_top=4)


MUTANTS = [
    ('payment.c', 'if (candidate >= TextLineCount) return;',
     'if (candidate > TextLineCount) return;'),
    ('payment.c', 'if (keys[SCAN_HOME] == KEY_STATE_DOWN) {',
     'if (keys[SCAN_END] == KEY_STATE_DOWN) {'),
    ('payment.c', 'if (drive < 2) continue;', 'if (drive < 1) continue;'),
    ('payment.c', 'if (value == 0x0D) TextLineCount++;',
     'if (value == 0x0A) TextLineCount++;'),
]
