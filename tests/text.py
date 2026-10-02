"""Differential cases for C text/BCD/decimal routines and the retained renderer."""
from difftest import Case, STATE_BYTES
from world import World

FREE = ('SP', 'DS', 'SS')
TEXT_SLOT = 0xD300
BUFFER_SLOT = 0xD380
ADAPTERS = (0, 1, 2)


def check(value, message):
    if not value:
        raise AssertionError(message)


def set_adapter(pair, value):
    saved = []
    for side in (pair.a, pair.b):
        at = side.m.linear('VideoAdapter')
        old = bytes(side.m.u.mem_read(at, 2))
        saved.append((side, at, old))
        side.m.u.mem_write(at, value.to_bytes(2, 'little'))
    return saved


def restore_adapter(saved):
    for side, at, old in reversed(saved):
        side.m.u.mem_write(at, old)


def put_wrapped(world, start, data):
    for index, value in enumerate(data):
        world.byte((start + index) & 0xFFFF, value)


def read_wrapped(pair, machine, start, length):
    result = bytearray()
    for index in range(length):
        offset = (start + index) & 0xFFFF
        if offset < STATE_BYTES:
            result.append(machine.read(offset, 1)[0])
        else:
            where = f'DS:{offset:04X}'
            writes = [value for target, size, value in pair.a.outside
                      if target.upper() == where and size == 1]
            check(bool(writes), f'missing buffer write at {where}')
            result.append(writes[-1])
    return bytes(result)


def message_case(pair, rng, data, start=TEXT_SLOT, graphics=0, name='message',
                 expected_bp=None, expected_color=None):
    world = (World(pair, rng).word('TextInGraphics', graphics)
             .word('TextRowOffset', 0x20).byte('TextColumn', 0)
             .byte('TextColor', 7))
    put_wrapped(world, start, data)

    def expect(machine, regs):
        if expected_bp is not None:
            check(regs['BP'] == expected_bp, f'{name}: BP {regs["BP"]:04X}')
        if expected_color is not None:
            check(machine.read(pair.sym('TextColor'), 1)[0] == expected_color,
                  f'{name}: TextColor')

    return Case('PrintMessageBP', {'BP': start, 'ES': 0xBEEF}, world.writes(),
                preserve=FREE, outputs=('BP', 'ES'), expect=expect, name=name)


def character_case(pair, rng, character, start, payload, graphics, name):
    """Enter the original single-character ABI, including its explicit DI result."""
    world = (World(pair, rng).word('TextInGraphics', graphics)
             .word('TextRowOffset', 0x20).byte('TextColumn', 0x03)
             .byte('TextColor', 0x07))
    put_wrapped(world, start, bytes((character,)) + payload)
    return Case('PrintTextChar', {'AX': 0xA500 | character, 'BP': start,
                                  'DI': 0x7654, 'ES': 0xBEEF}, world.writes(),
                preserve=FREE, outputs=('BP', 'ES', 'DI'), name=name)


def bcd_case(pair, rng, graphics, name, start=TEXT_SLOT):
    world = (World(pair, rng).word('TextInGraphics', graphics)
             .word('TextRowOffset', 0x20).byte('TextColumn', 0)
             .byte('TextColor', 0x0A))
    put_wrapped(world, start, bytes((0xFA, 0xB0, 0x1E, 0x99)))
    return Case('PrintBcd32', {'BP': start, 'ES': 0xBEEF}, world.writes(),
                preserve=FREE, outputs=('BP', 'ES'),
                expect=lambda m, r, expected_bp=start:
                check(r['BP'] == expected_bp, 'BCD preserves BP'),
                name=name)


def decimal_console_case(pair, rng, value, graphics=0, adapter=2, name='decimal'):
    world = (World(pair, rng).word('DecimalToBuffer', 0)
             .word('TextInGraphics', graphics).word('TextRowOffset', 0)
            .byte('TextColumn', 0).byte('TextColor', 0x0F))
    saved = set_adapter(pair, adapter)

    def expect(machine, regs):
        check(regs['DX'] == value % 10, f'{name}: DX remainder {regs["DX"]}')
        check(regs['BP'] == 0x7171, f'{name}: BP preserved for printable digits')
        if graphics == 0:
            check(machine.word(pair.sym('TextRowOffset')) == 10,
                  f'{name}: prints five characters')
            check(regs['DI'] == 8, f'{name}: final text DI {regs["DI"]}')

    case = Case('PrintDecimalDX', {'DX': value, 'DI': BUFFER_SLOT, 'BP': 0x7171,
                                   'ES': 0xBEEF}, world.writes(),
                preserve=FREE, outputs=('DX', 'DI', 'BP', 'ES'), expect=expect,
                name=name)
    return case, saved


def buffer_case(pair, rng, label, value, destination, initial_flag, expected_flag,
                name):
    world = (World(pair, rng).word('DecimalToBuffer', initial_flag)
             .word('TextInGraphics', 0).word('TextRowOffset', 0)
             .byte('TextColumn', 0).byte('TextColor', 7))
    put_wrapped(world, destination, bytes((0xA5,)) * 5)
    case = Case(label, {'DX': value, 'DI': destination, 'BP': 0x7171, 'ES': 0xBEEF},
                world.writes(), preserve=FREE,
                outputs=('DX', 'DI', 'BP', 'ES'), name=name)

    def expect(machine, regs):
        expected = bytes(ord(ch) for ch in str(value).rjust(5, '0'))
        actual = read_wrapped(pair, machine, destination, 5)
        check(actual == expected, f'{name}: buffer {actual!r}, expected {expected!r}')
        check(machine.word(pair.sym('DecimalToBuffer')) == expected_flag,
              f'{name}: DecimalToBuffer result')
        check(machine.word(pair.sym('TextRowOffset')) == 0,
              f'{name}: buffer mode does not render')
        check(regs['DI'] == ((destination + 5) & 0xFFFF), f'{name}: DI advances five')
        check(regs['DX'] == value % 10, f'{name}: DX is units remainder')
        check(regs['BP'] == 0x7171 and regs['ES'] == 'unchanged',
              f'{name}: buffer mode preserves BP/ES')

    case.expect = expect
    return case


def uppercase_case(value):
    original_ax = 0xA500 | value
    return Case('UppercaseAsciiAL', {'AX': original_ax, 'BX': 0x1234, 'CX': 0x4567,
                                     'DX': 0x89AB, 'SI': 0x1357, 'DI': 0x2468,
                                     'BP': 0x7171, 'ES': 0xBEEF},
                preserve=('SP', 'DS', 'SS', 'BX', 'CX', 'DX', 'SI', 'DI', 'BP', 'ES'),
                outputs=('AX',), flags=('CF', 'PF', 'ZF', 'SF', 'OF'),
                expect=lambda m, r, value=value:
                check(r['AX'] == (0xA500 | (value - 0x20 if 0x61 <= value <= 0x7A else value)),
                      f'uppercase {value:02X}: AX {r["AX"]:04X}'),
                name=f'uppercase byte {value:02X}')


def cases(rng, scale, pair):
    # The message walk and the single-character entry both exercise the shared C policy.
    controls = bytes((0x10, 0x0D, 0x11, 3, 4, ord('A'), 0))
    for adapter in ADAPTERS:
        saved = set_adapter(pair, adapter)
        try:
            yield message_case(pair, rng, controls, graphics=1,
                               expected_bp=TEXT_SLOT + 6,
                               name=f'graphics controls adapter {adapter}')
            yield message_case(pair, rng, bytes((ord('A'), 0x0E, ord('B'), 0)),
                               graphics=1, expected_bp=TEXT_SLOT + 3,
                               name=f'graphics newline adapter {adapter}')
            yield character_case(pair, rng, 0x10, TEXT_SLOT, b'\x0D', 1,
                                 f'direct graphics color {adapter}')
            yield character_case(pair, rng, 0x11, TEXT_SLOT, b'\xFF\xFE', 1,
                                 f'direct graphics position {adapter}')
            yield character_case(pair, rng, ord('A'), TEXT_SLOT, b'', 1,
                                 f'direct graphics glyph {adapter}')
            yield bcd_case(pair, rng, 1, f'graphics BCD adapter {adapter}')
        finally:
            restore_adapter(saved)

    # CGA masks the payload to two bits before its DS color-fill lookup.
    for payload in (0x04, 0xFF):
        saved = set_adapter(pair, 0)
        try:
            yield character_case(pair, rng, 0x10, TEXT_SLOT, bytes((payload,)), 1,
                                 f'direct CGA raw color payload {payload:02X}')
        finally:
            restore_adapter(saved)

    yield character_case(pair, rng, 0x10, 0xFFFF, b'\x0E', 0,
                         'direct text color payload and BP wrap')
    yield character_case(pair, rng, 0x11, 0xFFFE, b'\xFD\x02', 0,
                         'direct text position payload and BP wrap')
    for adapter in ADAPTERS:
        saved = set_adapter(pair, adapter)
        try:
            yield character_case(pair, rng, 0x11, 0xFFFE, b'\xFF\xFE', 1,
                                 f'direct graphics position wrap {adapter}')
        finally:
            restore_adapter(saved)

    yield message_case(pair, rng, controls, expected_bp=TEXT_SLOT + 6,
                       expected_color=0x0D, name='text controls advance BP')
    yield message_case(pair, rng, b'\0', expected_bp=TEXT_SLOT,
                       name='empty message preserves BP')
    yield message_case(pair, rng, bytes((0x10, 0x0E, 0)), start=0xFFFE,
                       expected_bp=0, expected_color=0x0E,
                       name='control parameter crosses offset wrap')
    yield message_case(pair, rng, bytes((ord('Z'), 0)), start=0xFFFF,
                       expected_bp=0, name='character and terminator cross offset wrap')
    yield bcd_case(pair, rng, 0, 'BCD source crosses offset wrap', start=0xFFFE)

    # Exercise every pixel renderer's actual DI/ES/write behavior for numeric text.
    for adapter in ADAPTERS:
        saved = set_adapter(pair, adapter)
        try:
            for value in (0, 1, 42, 10000, 65535):
                case, _ = decimal_console_case(pair, rng, value, graphics=1,
                                                adapter=adapter,
                                                name=f'graphics decimal {adapter}/{value}')
                yield case
        finally:
            restore_adapter(saved)

    for value in (0, 1, 9, 10, 42, 99, 100, 9999, 10000, 65535):
        case, saved = decimal_console_case(pair, rng, value,
                                            name=f'text decimal {value}')
        try:
            yield case
        finally:
            restore_adapter(saved)
    for value in (0, 1, 42, 10000, 65535):
        yield buffer_case(pair, rng, 'PrintDecimalDX', value, BUFFER_SLOT, 1, 1,
                          f'direct buffer {value}')
        yield buffer_case(pair, rng, 'FormatDecimalToBuffer', value, BUFFER_SLOT, 2, 0,
                          f'format buffer {value}')
    yield buffer_case(pair, rng, 'FormatDecimalToBuffer', 23, 0xFFFE, 0, 0,
                      'format buffer wraps DI')

    for index in range(40 * scale):
        value = rng.randrange(0x10000)
        case, saved = decimal_console_case(pair, rng, value, name=f'random decimal {index}')
        try:
            yield case
        finally:
            restore_adapter(saved)

    for value in range(256):
        yield uppercase_case(value)


MUTANTS = [
    ('text.c', 'cursor = (word)(registers->bp + 1);',
     'cursor = registers->bp;'),
    ('text.c', '(value & 0x0F) + 0x30', '(value & 0x0F) + 0x31'),
    ('text.c', 'word buffered = (DecimalToBuffer == 1);',
     'word buffered = (DecimalToBuffer != 1);'),
    ('text.c', 'state->dx = remaining;', 'state->dx = state->dx;'),
    ('text.c', 'if (character >= 0x61 && character <= 0x7A)',
     'if (character > 0x61 && character <= 0x7A)'),
    ('text.c', 'registers->bp = (word)(bp + 1);',
     'registers->bp = (word)(bp + 2);'),
    ('text.c', 'column = text_read_stack_byte((word)(bp + 2));',
     'column = text_read_stack_byte((word)(bp + 1));'),
    ('text.c', 'value = (byte)(value & 3);', 'value = value;'),
    ('text.c', '(byte)(column << 2)', '(byte)(column << 1)'),
]
