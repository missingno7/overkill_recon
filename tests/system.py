"""Bounded differential cases for the reusable DOS system-control region.

BIOS and pixel operations are stubbed at their narrow service boundaries; no case enters
the game session or runs past 0000:97B2.
"""
from difftest import Case, ALL_REGS
from world import World, K
from emu import REG, LOAD
from options import hook, cleanup, return_service, check
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
import random
import struct

FREE = ('SP', 'DS', 'SS')
STATUS_FLAGS = ('CF', 'PF', 'AF', 'ZF', 'SF', 'DF', 'OF')


def near_service(side, bag, label, callback, stack_pop=0):
    def enter(u, address, size, _):
        callback(u, side)
        return_service(side)
        if stack_pop:
            u.reg_write(REG['SP'], (u.reg_read(REG['SP']) + stack_pop) & 0xFFFF)
    hook(side, bag, UC_HOOK_CODE, enter, side.m.linear(label))
    side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def poll_label(side, pair):
    return 'PollInputBits' if side is pair.a else 'POLL_INPUT_BITS'


def poll_stream(side, pair, bag, stream, observed):
    def poll(u, _side):
        index = observed['polls']
        check(index < len(stream), 'input stream is long enough')
        value = stream[index]
        observed['polls'] = index + 1
        observed['inputs'].append(value)
        side.m.write(pair.sym('InputBits'), bytes((value,)))
    near_service(side, bag, poll_label(side, pair), poll)


def draw_service(side, pair, bag, name, observed, ordinal):
    def draw(u, _side):
        bp = u.reg_read(REG['BP'])
        es = u.reg_read(REG['ES'])
        observed.append((name, bp, es))
        u.reg_write(REG['BP'], (0x9100 + ordinal) & 0xFFFF)
        u.reg_write(REG['ES'], (0xB800 + ordinal) & 0xFFFF)
    near_service(side, bag, name, draw)


def redraw_service(side, pair, bag, name, observed, ordinal, state):
    legacy_name, native_name = {
        'DrawHud': ('DrawHud', 'DISPLAY_DRAW_HUD'),
        'DrawFuelGauge': ('DrawFuelGauge', 'RENDER_DRAW_FUEL_GAUGE'),
        'DrawUpgradeSlots': ('DrawUpgradeSlots', 'RENDER_DRAW_UPGRADE_SLOTS'),
        'ApplyLevelPalette': ('ApplyLevelPalette', 'DISPLAY_APPLY_LEVEL_PALETTE'),
    }[name]
    native = side is pair.b
    target = native_name if native else legacy_name
    result_es = (0xA400 + ordinal) & 0xFFFF
    result_word = (0xD000 + ordinal) & 0xFFFF

    def enter(u, address, size, _):
        if name in ('DrawHud', 'ApplyLevelPalette'):
            if native:
                at = u.reg_read(REG['SI'])
                bp, es = struct.unpack('<HH', side.m.read(at, 4))
            else:
                bp, es = u.reg_read(REG['BP']), u.reg_read(REG['ES'])
            observed.append((name, bp, es))
            if name == 'DrawHud':
                next_bp = (0x9100 + ordinal) & 0xFFFF
                next_es = (0xB800 + ordinal) & 0xFFFF
                state['bp'], state['es'] = next_bp, next_es
            else:
                # The render leaves preserve BP. This input check catches an
                # accidental assignment of returned DI/SI into the live BP pair.
                check(bp == state['bp'], f'{name} receives the BP left by DrawHud')
                check(es == state['es'], f'{name} receives returned render ES')
                next_bp = (0x9100 + ordinal) & 0xFFFF
                next_es = (0xB800 + ordinal) & 0xFFFF
                state['bp'], state['es'] = next_bp, next_es
            if native:
                side.m.write(at, struct.pack('<HH', next_bp, next_es))
            else:
                u.reg_write(REG['BP'], next_bp)
                u.reg_write(REG['ES'], next_es)
        else:
            bp = state['bp'] if native else u.reg_read(REG['BP'])
            es = state['es'] if native else u.reg_read(REG['ES'])
            check(bp == state['bp'], f'{name} preserves the live BP value')
            observed.append((name, bp, es, result_es))
            state['es'] = result_es
            if native:
                # dword results use DX:AX = ES:DI/SI.
                u.reg_write(REG['AX'], result_word)
                u.reg_write(REG['DX'], result_es)
            else:
                u.reg_write(REG['ES'], result_es)
                u.reg_write(REG['DI' if name == 'DrawFuelGauge' else 'SI'], result_word)
        return_service(side)

    hook(side, bag, UC_HOOK_CODE, enter, side.m.linear(target))
    side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def boss_case(w, pair, demo, down):
    bag, observed = [], []
    for side in (pair.a, pair.b):
        trace = []
        observed.append(trace)
        state = {'bp': None, 'es': None}
        if down:
            services = ['ShowBossKeyScreen', 'DrawStatusPanel']
            if demo != 1:
                services += ['DrawHud', 'DrawFuelGauge', 'DrawUpgradeSlots', 'ApplyLevelPalette']
            for n, name in enumerate(services):
                if name in ('ShowBossKeyScreen', 'DrawStatusPanel'):
                    draw_service(side, pair, bag, name, trace, n)
                else:
                    redraw_service(side, pair, bag, name, trace, n, state)
    case = Case('CheckBossKey', {'AX': 0x1357, 'BX': 0x2468, 'CX': 0x369A,
                                 'DX': 0x48BC, 'SI': 0x5ADE, 'DI': 0x6CEF,
                                 'BP': 0x7A12, 'ES': 0xB800}, w.writes(),
                ALL_REGS if not down else FREE,
                outputs=() if not down else ('BP', 'ES'),
                flags=STATUS_FLAGS if not down else (),
                name=f"{'down' if down else 'up'} demo={demo}")
    try:
        yield case
        if down:
            check(observed[0] == observed[1], 'boss-key service and BP/ES trace match')
            expected = ['ShowBossKeyScreen', 'DrawStatusPanel']
            if demo != 1:
                expected += ['DrawHud', 'DrawFuelGauge', 'DrawUpgradeSlots', 'ApplyLevelPalette']
            check([entry[0] for entry in observed[0]] == expected, 'boss-key redraw order')
    finally:
        cleanup(pair, bag)


def redraw_case(w, pair, demo):
    bag, observed = [], []
    services = ['DrawStatusPanel']
    if demo != 1:
        services += ['DrawHud', 'DrawFuelGauge', 'DrawUpgradeSlots', 'ApplyLevelPalette']
    for side in (pair.a, pair.b):
        trace = []
        observed.append(trace)
        state = {'bp': None, 'es': None}
        for n, name in enumerate(services):
            if name == 'DrawStatusPanel':
                draw_service(side, pair, bag, name, trace, n)
            else:
                redraw_service(side, pair, bag, name, trace, n, state)
    case = Case('RedrawStatusPanel', {'BP': 0x72A5, 'ES': 0xB800}, w.writes(), FREE,
                outputs=('BP', 'ES'), name=f'demo={demo}')
    try:
        yield case
        check(observed[0] == observed[1], 'status-panel service and register trace match')
        check([entry[0] for entry in observed[0]] == services, 'status-panel redraw order')
    finally:
        cleanup(pair, bag)


def text_char_service(side, pair, bag, observed, message_starts):
    starts = {side.m.offset(label): label for label in message_starts}
    native = side is pair.b

    def character(u, _side):
        if native:
            value = u.reg_read(REG['SI']) & 0xFF
            metadata = u.reg_read(REG['DI'])
            bp = side.m.word(metadata)
            es = side.m.word(metadata + 2)
            # Watcom passes rendered_di as the third argument at SS:[SP+2].
            # The prompt parser passes NULL; TEXT_EMIT_CHARACTER returns with RET 2.
            sp = u.reg_read(REG['SP'])
            ss = u.reg_read(REG['SS'])
            argument = struct.unpack('<H', bytes(u.mem_read(
                ss * 16 + ((sp + 2) & 0xFFFF), 2)))[0]
            check(argument == 0, 'prompt text service has no rendered-DI output slot')
        else:
            bp = u.reg_read(REG['BP'])
            es = u.reg_read(REG['ES'])
            value = u.reg_read(REG['AX']) & 0xFF
        if bp in starts:
            observed['messages'].append([bp, bytearray()])
        check(bool(observed['messages']), 'text character belongs to a prompted message')
        observed['messages'][-1][1].append(value)

        # PrintTextChar advances BP over its operands for the two text controls;
        # PrintMessageBP/text_print_message then advance once more after return.
        if value == 0x10:
            observed['messages'][-1][1].extend(side.m.read((bp + 1) & 0xFFFF, 1))
            out_bp = (bp + 1) & 0xFFFF
            out_es = side.m.peek('MainDataSegment')
            es_kind = 'state'
        elif value == 0x11:
            observed['messages'][-1][1].extend(side.m.read((bp + 1) & 0xFFFF, 2))
            out_bp = (bp + 2) & 0xFFFF
            out_es = side.m.peek('MainDataSegment')
            es_kind = 'state'
        else:
            out_bp = bp
            out_es = side.m.peek('TextVideoSegment')
            es_kind = 'text'
        observed['characters'].append((bp, value, out_bp, es_kind))
        if native:
            side.m.write(metadata, struct.pack('<HH', out_bp, out_es))
        else:
            u.reg_write(REG['BP'], out_bp)
            u.reg_write(REG['ES'], out_es)

    # The native C entry consumes its one stack-passed argument with RET 2; the
    # oracle's near service has no stack argument and uses the ordinary RET path.
    near_service(side, bag, 'TEXT_EMIT_CHARACTER' if native else 'PrintTextChar',
                 character, stack_pop=2 if native else 0)


def read_zero_terminated(side, address):
    value = bytearray()
    while len(value) < 0x100:
        byte = side.m.read(address + len(value), 1)[0]
        if byte == 0:
            return bytes(value)
        value.append(byte)
    raise AssertionError('prompt message is zero terminated')


def prompt_case(pair, status, stream):
    bag, observed = [], []
    w = World(pair, random.Random(1))
    w.word('FileStatus', status).word('TextInGraphics', 0).byte('InputBits', 0)
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    first = 'SwapDisksMessage' if status == K.FILE_STATUS_OPEN_FAILED else 'ReadErrorMessage'
    for side in (pair.a, pair.b):
        trace = {'messages': [], 'characters': [], 'polls': 0, 'inputs': []}
        observed.append(trace)
        text_char_service(side, pair, bag, trace,
                          ('SwapDisksMessage', 'ReadErrorMessage', 'BlankMessage'))
        poll_stream(side, pair, bag, stream, trace)
    case = Case('PromptLoadErrorWaitFire', {'BP': 0x7345, 'ES': 0xB800}, w.writes(), FREE,
                outputs=('BP', 'ES'), name=f'status={status:04X}')
    try:
        yield case
        check(observed[0] == observed[1], 'prompt messages and exact input consumption match')
        expected_starts = [pair.sym(first), pair.sym('BlankMessage')]
        check([message[0] for message in observed[0]['messages']] == expected_starts,
              'prompt selects by FileStatus and prints the blank message')
        expected_messages = [read_zero_terminated(pair.a, address) for address in expected_starts]
        check([bytes(message[1]) for message in observed[0]['messages']] == expected_messages,
              'native text rendering visits each full zero-terminated message')
        check(observed[0]['polls'] == len(stream), 'prompt consumes the controlled input stream')
    finally:
        cleanup(pair, bag)


def wait_case(pair, label, stream):
    bag, observed = [], []
    w = World(pair, random.Random(2)).byte('InputBits', 0xA5)
    for side in (pair.a, pair.b):
        trace = {'polls': 0, 'inputs': []}
        observed.append(trace)
        poll_stream(side, pair, bag, stream, trace)
    case = Case(label, {}, w.writes(), FREE, name=f'inputs={stream!r}')
    try:
        yield case
        check(observed[0] == observed[1], f'{label} consumes the same input stream')
        check(observed[0]['polls'] == len(stream), f'{label} has the expected poll count')
    finally:
        cleanup(pair, bag)


def wait_all_keys_case(pair):
    bag, observed = [], []
    w = World(pair, random.Random(3)).put('KeyDownTable', bytes((1,)) + bytes(K.KEY_DOWN_COUNT - 1))
    for side in (pair.a, pair.b):
        # Machine.call is intentionally near-return-only. Enter this far legacy
        # service through a tiny temporary near wrapper, then use its RET as the
        # harness sentinel return. This still executes the real far entry/body.
        wrapper = 'SYSTEM_TEST_FAR_WAIT_KEYS'
        # Keep the near-return sentinel below 1 MiB with room for Unicorn's
        # instruction fetch at FFFEh.
        wrapper_cs, wrapper_ip = 0xE000, 0x0100
        target_seg, target_ip = side.m.symbols['WAITALLKEYSRELEASED']
        target_cs = LOAD + target_seg
        side.m.symbols[wrapper] = (wrapper_cs - LOAD, wrapper_ip)
        side.m.u.mem_write(wrapper_cs * 16 + wrapper_ip,
                           b'\x9A' + struct.pack('<HH', target_ip, target_cs) + b'\xC3')
        reads = []
        observed.append(reads)
        key_base = side.m.data_frame * 16 + pair.sym('KeyDownTable')
        def release_after_first_scan(u, access, address, size, value, _, side=side, reads=reads,
                                     key_base=key_base):
            index = address - key_base
            reads.append(index)
            if index == 0 and reads.count(0) == 2:
                side.m.write(pair.sym('KeyDownTable'), b'\0')
        hook(side, bag, UC_HOOK_MEM_READ, release_after_first_scan,
             key_base, key_base + K.KEY_DOWN_COUNT - 1)
    case = Case('SYSTEM_TEST_FAR_WAIT_KEYS', {}, w.writes(), FREE, name='two complete scans')
    try:
        yield case
        expected = list(range(K.KEY_DOWN_COUNT)) * 2
        check(observed[0] == observed[1], 'both implementations read the same key slots')
        check(observed[0] == expected, 'release wait scans the entire table before rescanning')
    finally:
        cleanup(pair, bag)


def cases(rng, scale, pair):
    # VideoAdapter is CS-resident. Capture its write at execution time because
    # Side.run rolls back outside-state writes before Case.expect is evaluated.
    for adapter in (0, 1, 2, 3, 0xFFFF):
        bag, observed = [], []
        for side in (pair.a, pair.b):
            writes = []
            observed.append(writes)
            at = side.m.linear('VideoAdapter')
            def capture_video(u, access, address, size, value, _, at=at, writes=writes):
                if address == at:
                    writes.append((size, value & 0xFFFF))
            hook(side, bag, UC_HOOK_MEM_WRITE, capture_video, at, at + 1)
        case = Case('ApplyLauncherVideoOverride',
                    {'AX': 0xA55A, 'BX': adapter, 'CX': 0x1357, 'DX': 0x2468,
                     'SI': 0x369A, 'DI': 0x48BC, 'BP': 0x5ADE, 'ES': 0xB800},
                    preserve=ALL_REGS, flags=STATUS_FLAGS, name=f'adapter={adapter:04X}')
        try:
            yield case
            check(observed[0] == observed[1], 'launcher helper CS write matches')
            check(observed[0] == [(2, adapter)], 'launcher helper stores BX without validation')
        finally:
            cleanup(pair, bag)

    for down in (False, True):
        for demo in ((0, 1) if down else (0,)):
            w = World(pair, rng).word('DemoActive', demo)
            keys = bytearray(K.KEY_DOWN_COUNT)
            if down: keys[K.SCAN_F9] = K.KEY_STATE_DOWN
            w.put('KeyDownTable', keys)
            yield from boss_case(w, pair, demo, down)

    for demo in (0, 1):
        w = World(pair, rng).word('DemoActive', demo)
        yield from redraw_case(w, pair, demo)

    primary = K.IN_BUTTON_PRIMARY
    combined = primary | K.IN_XPLUS
    for status in (K.FILE_STATUS_OPEN_FAILED, K.FILE_STATUS_OK, 0xFFFF):
        yield from prompt_case(pair, status, (0, combined, primary, primary, combined))

    yield from wait_case(pair, 'WaitInputReleased', (combined, primary, 0))
    yield from wait_case(pair, 'WaitInputPressed', (0, 0, combined))
    yield from wait_case(pair, 'WaitInputClick', (0, combined, combined, 0))
    yield from wait_all_keys_case(pair)


MUTANTS = [
    ('system.c', 'rendered = render_draw_fuel_gauge();\n    registers->es = (word)(rendered >> 16);',
     'rendered = render_draw_fuel_gauge();\n    registers->bp = (word)rendered;\n    registers->es = (word)(rendered >> 16);'),
    ('system.c', 'while (*input == IN_BUTTON_PRIMARY);', 'while (*input != 0);'),
]
