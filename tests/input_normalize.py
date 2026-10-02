"""Differential checks for reusable joystick normalization and key-state clearing.

Axis reads and button-port reads are bounded hardware services. The test supplies the
raw 16-bit count words and byte-valued port sample, then compares the real ASM oracle
with the isolated C proposal (or current hybrid) at the existing near entry.
"""
from difftest import Case
from world import World, K
from options import check, hook, return_service, cleanup
from emu import REG
from unicorn import UC_HOOK_CODE
import capstone
import random
import struct

KEEP = ('DI', 'BP', 'ES', 'SP', 'DS', 'SS')
EDGE_THRESHOLDS = (0, 1, 2, 0x7FFF, 0x8000, 0xFFFE, 0xFFFF)
MD = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)


def boundary_counts(low, high):
    values = {0, 1, 0x7FFF, 0x8000, 0xFFFE, 0xFFFF}
    for threshold in (low, high):
        values.update(((threshold - 1) & 0xFFFF, threshold, (threshold + 1) & 0xFFFF))
    return sorted(values)


def button_sample_site(side):
    # The isolated bridge exposes a tiny raw-input leaf, while the original oracle
    # reads the same byte inline after its second axis sample.
    if 'READGAMEPORTABUTTONBITS' in side.m.symbols:
        return 'service', side.m.linear('ReadGamePortAButtonBits')
    seg, start = side.m.symbols['POLLJOYSTICKINPUTBITS']
    ends = [off for frame, off in side.m.symbols.values() if frame == seg and off > start]
    stop = min(ends) if ends else 0x10000
    linear = side.m.linear('PollJoystickInputBits')
    blob = bytes(side.m.u.mem_read(linear, stop - start))
    for ins in MD.disasm(blob, start):
        if ins.mnemonic == 'in' and ins.op_str.replace(' ', '').lower() == 'al,dx':
            return 'instruction', linear + ins.address - start
    raise AssertionError('oracle joystick routine has no bounded raw port read')


def normalized_bits(x, y, thresholds, port, button_select=K.JOY_BUTTONS_PORT_A):
    x_low, x_high, y_low, y_high = thresholds
    out = 0
    if x < x_low: out |= K.IN_XMINUS
    if x > x_high: out |= K.IN_XPLUS
    if y < y_low: out |= K.IN_YMINUS
    if y > y_high: out |= K.IN_YPLUS
    if button_select == K.JOY_BUTTONS_PORT_A:
        button1, button2 = K.GAME_PORT_A_BUTTON1, K.GAME_PORT_A_BUTTON2
    else:
        button1, button2 = K.GAME_PORT_B_BUTTON1, K.GAME_PORT_B_BUTTON2
    if port & button2 == 0: out |= K.IN_BUTTON_SECONDARY
    if port & button1 == 0: out |= K.IN_BUTTON_PRIMARY
    return out


def joystick_case(pair, x, y, thresholds, port, name, label='PollJoystickInputBits'):
    w = World(pair, random.Random((x << 16) ^ y ^ port ^ sum(thresholds)))
    w.word('InputBits', 0xA5).word('JoyButtonSelect', 0xA553)
    w.word('JoyXLowThreshold', thresholds[0]).word('JoyXHighThreshold', thresholds[1])
    w.word('JoyYLowThreshold', thresholds[2]).word('JoyYHighThreshold', thresholds[3])
    if label == 'PollInputBits': w.word('InputDeviceMode', K.INPUT_MODE_JOYSTICK)
    writes = w.writes()
    bag, observed = [], []
    # Different decoy halves make an X/Y register swap visible.
    axis_values = ((x, 0xA37C), (0x5CE1, y))
    for side in (pair.a, pair.b):
        obs = {'axes': 0, 'buttons': 0}
        observed.append(obs)

        def read_axes(u, address, size, _, side=side, obs=obs):
            index = obs['axes']
            check(index < 2, f'{name}: more than two axis samples')
            bx, cx = axis_values[index]
            obs['axes'] += 1
            u.reg_write(REG['BX'], bx)
            u.reg_write(REG['CX'], cx)
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, read_axes, side.m.linear('ReadGamePortAAxisCounts'))

        kind, at = button_sample_site(side)
        if kind == 'service':
            def read_buttons(u, address, size, _, side=side, obs=obs):
                obs['buttons'] += 1
                side.m.ports.append(('in', K.GAME_PORT))
                u.reg_write(REG['AX'], port)
                return_service(side)
            hook(side, bag, UC_HOOK_CODE, read_buttons, at)
        else:
            def read_buttons(u, address, size, _, side=side, obs=obs):
                obs['buttons'] += 1
                side.m.ports.append(('in', K.GAME_PORT))
                ax = u.reg_read(REG['AX'])
                u.reg_write(REG['AX'], (ax & 0xFF00) | port)
                u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + size) & 0xFFFF)
            hook(side, bag, UC_HOOK_CODE, read_buttons, at)

    regs = {'AX': 0x7123, 'BX': 0x4567, 'CX': 0x89AB, 'DX': 0xCDEF,
            'SI': 0x1357, 'DI': 0x2468, 'BP': 0xA55A, 'ES': 0xB800}
    def expect(m, returned):
        check(m.read(pair.sym('InputBits'), 1)[0] == normalized_bits(x, y, thresholds, port),
              f'{name}: normalized InputBits')
        check(m.word(pair.sym('JoyButtonSelect')) == K.JOY_BUTTONS_PORT_A,
              f'{name}: port A selection write')
        for index, obs in enumerate(observed):
            check(obs['axes'] == 2, f'{name}: side {index} must sample axes twice')
            check(obs['buttons'] == 1, f'{name}: side {index} must sample buttons once')
    try:
        yield Case(label, regs, writes, KEEP, name=name, expect=expect)
    finally:
        cleanup(pair, bag)


def clear_key_case(pair, pattern, head, ds, name):
    w = World(pair, random.Random(head ^ ds))
    w.put('KeyDownTable', pattern)
    bag = []
    observed = []
    for side in (pair.a, pair.b):
        obs = {'seeded': False}
        observed.append(obs)
        def seed_bios(u, address, size, _, side=side, obs=obs):
            if obs['seeded']: return
            obs['seeded'] = True
            u.reg_write(REG['FLAGS'], u.reg_read(REG['FLAGS']) & ~0x0200)
            u.mem_write(0x041A, struct.pack('<H', head))
            u.mem_write(0x041C, struct.pack('<H', 0xBEEF))
        hook(side, bag, UC_HOOK_CODE, seed_bios, side.m.linear('ClearKeyDownTable'))
    regs = {'AX': 0x7A55, 'BX': 0x1234, 'CX': 0x5678, 'DX': 0x9ABC,
            'SI': 0xDEF0, 'DI': 0x1357, 'BP': 0xA55A, 'ES': 0xB800, 'DS': ds}
    def expect(m, returned):
        check(m.read(pair.sym('KeyDownTable'), K.KEY_DOWN_COUNT) == bytes(K.KEY_DOWN_COUNT),
              f'{name}: every key state is cleared')
        check(returned['ES'] == 0, f'{name}: ES is reset by the BIOS flush')
        check(returned['BP'] == 0xA55A, f'{name}: inherited BP survives')
        for index, side in enumerate((pair.a, pair.b)):
            check(observed[index]['seeded'], f'{name}: BIOS buffer was initialized')
            tails = [value for where, size, value in side.outside if where == '0041C' and size == 1]
            check(tails and tails[-1] == (head & 0xFF), f'{name}: BIOS tail is set to the head low byte')
    try:
        yield Case('ClearKeyDownTable', regs, w.writes(), ('BP', 'SP', 'DS', 'SS'),
                   outputs=('ES',), flags=('IF',), name=name, expect=expect)
    finally:
        cleanup(pair, bag)


def cases(rng, scale, pair):
    # Every byte sample exercises all combinations of unrelated and active-low
    # button bits with one strict movement result on each axis.
    fixed_thresholds = (0x1234, 0xABCD, 0xFEDC, 0x0102)
    for port in range(256):
        yield from joystick_case(pair, 0x1233, 0x0103, fixed_thresholds, port,
                                 f'all button bytes {port:02X}')

    # Sweep every ordered threshold pair on each axis, testing equality and both
    # adjacent unsigned counts. Mirror counts across axes to keep those decisions
    # distinct while keeping the edge matrix compact.
    pairs = [(low, high) for low in EDGE_THRESHOLDS for high in EDGE_THRESHOLDS]
    for low, high in pairs:
        edges = boundary_counts(low, high)
        for index, count in enumerate(edges):
            other = edges[(index * 5 + 1) % len(edges)] ^ 0xFFFF
            yield from joystick_case(pair, count, other, (low, high, high, low), 0xFF,
                                     f'X edge {low:04X}/{high:04X} count {count:04X}')
            yield from joystick_case(pair, other, count, (high, low, low, high), 0xFF,
                                     f'Y edge {low:04X}/{high:04X} count {count:04X}')
    # Cross distinct X/Y bounds around each representative threshold pair. This catches
    # swapped axes or swapped low/high state even when the two counts happen to match.
    for index, (x_low, x_high) in enumerate(pairs):
        y_low, y_high = pairs[(index * 13) % len(pairs)]
        xs, ys = boundary_counts(x_low, x_high), boundary_counts(y_low, y_high)
        for x, y in zip(xs, ys):
            yield from joystick_case(pair, x, y, (x_low, x_high, y_low, y_high), 0xCF,
                                     f'cross edge X {x_low:04X}/{x_high:04X} '
                                     f'Y {y_low:04X}/{y_high:04X}')
    # Specifically test the joystick-mode dispatcher, including threshold equality and
    # both-direction results under reversed bounds.
    for x, y, thresholds, port in (
        (0x1000, 0x2000, (0x3000, 0x1000, 0x1000, 0x3000), 0xFF),
        (0x1000, 0x3000, (0x1000, 0x1000, 0x3000, 0x3000), 0xCF),
        (0xFFFF, 0, (0, 0xFFFF, 1, 0), 0xEF),
    ):
        yield from joystick_case(pair, x, y, thresholds, port, 'PollInputBits joystick dispatch', 'PollInputBits')

    # Deterministic full-width count/threshold fuzz supplements the deliberately dense
    # equality and neighboring edge matrix.
    for i in range(192 * scale):
        thresholds = tuple(rng.randrange(0x10000) for _ in range(4))
        x, y, port = rng.randrange(0x10000), rng.randrange(0x10000), rng.randrange(256)
        label = 'PollInputBits' if i % 16 == 0 else 'PollJoystickInputBits'
        yield from joystick_case(pair, x, y, thresholds, port, f'random16 #{i}', label)

    patterns = (bytes([0xFF]) * K.KEY_DOWN_COUNT,
                bytes((i * 37 + 1) & 0xFF for i in range(K.KEY_DOWN_COUNT)),
                bytes([0]) * K.KEY_DOWN_COUNT)
    for index, (pattern, head, ds) in enumerate(((patterns[0], 0x46, 0x1234),
                                                  (patterns[1], 0xA7, 0xBEEF),
                                                  (patterns[2], 0xFF, 0x0000))):
        yield from clear_key_case(pair, pattern, head, ds, f'clear table {index}')

MUTANTS = [
    ('input_normalize.c', 'if (x < *x_low)', 'if (x <= *x_low)'),
    ('input_normalize.c', 'if (y > *y_high)', 'if (y >= *y_high)'),
    ('input_normalize.c', 'if ((port & button2_mask) == 0)', 'if ((port & button2_mask) != 0)'),
    ('input_normalize.c', 'if ((port & button1_mask) == 0)', 'if ((port & button1_mask) != 0)'),
]
