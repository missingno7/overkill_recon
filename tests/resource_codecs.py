"""Default differential suite for packed resource and ENC decoding.

It runs bounded edge fixtures plus every shipped BIC and ENC payload. DOS reads and
closes are hooked; the format readers, state layout, and destination writes remain real.
"""
from common import ROOT
from resources import decode_enc, resources

"""Synthetic differential fixtures for the proposed in-place resource decoders.

The format tests use the existing buffer/refill paths and hook DOS reads/closes only.
"""
from difftest import Case, far
import difftest
from emu import REG, FLAG
from unicorn import UC_HOOK_CODE
import struct


_CODE_WORDS = (
    'PackedReadCursor', 'PackedFileHandle', 'PackedNamePtr',
    'PackedDestSegment', 'PackedDestOffset',
    'PackedSavedBx', 'PackedUnwindSp', 'PackedWordLow', 'PackedOutputBytes',
    'EncFileHandle', 'EncDestOffset', 'EncDestSegment', 'EncOutputBytes',
    'EncOutputBytesHigh',
)
_CODE_BYTES = ('PackedReadBuffer', 'EncReadBuffer', 'EncRingBuffer')
difftest.FAR_LABELS += tuple(
    name for name in _CODE_WORDS + _CODE_BYTES if name not in difftest.FAR_LABELS
)


def w(value):
    return struct.pack('<H', value & 0xFFFF)


def words(*values):
    return b''.join(w(value) for value in values)


def _force_ds_cs(side, label, packed_unwind=False, read_cursor=None):
    at = side.m.linear(label)
    token = []

    def enter(u, address, size, _):
        if address == at:
            u.reg_write(REG['DS'], u.reg_read(REG['CS']))
            if packed_unwind:
                target = side.m.linear('PackedUnwindSp')
                side.undo.append((target, bytes(u.mem_read(target, 2))))
                u.mem_write(target, w(u.reg_read(REG['SP'])))
            if read_cursor == 'buffer_last_byte':
                target = side.m.linear('PackedReadCursor')
                buffer_offset = side.m.symbols['PACKEDREADBUFFER'][1]
                side.undo.append((target, bytes(u.mem_read(target, 2))))
                u.mem_write(target, w(buffer_offset + 0x1FF))

    token.append(side.m.u.hook_add(UC_HOOK_CODE, enter, begin=at, end=at))
    return token[0]


def _normalize_relocated_read_cursor(pair):
    """Compare the cursor's offset from its buffer, not link-dependent MAIN address."""
    for side in (pair.a, pair.b):
        if getattr(side, '_codec_cursor_normalized', False):
            continue
        run = side.run
        side._codec_original_run = run
        buffer_offset = side.m.symbols['PACKEDREADBUFFER'][1]

        def normalized_run(case, sp, fresh=True, keep=False, _run=run, _side=side,
                           _buffer=buffer_offset):
            result = _run(case, sp, fresh, keep)
            _side.outside = [
                (where, size, (value - _buffer) & 0xFFFF
                if where.upper() == 'PACKEDREADCURSOR+0' and size == 2 else value)
                for where, size, value in _side.outside
            ]
            return result

        side.run = normalized_run
        side._codec_cursor_normalized = True


def _restore_relocated_read_cursor(pair):
    for side in (pair.a, pair.b):
        if getattr(side, '_codec_cursor_normalized', False):
            side.run = side._codec_original_run
            del side._codec_original_run
            del side._codec_cursor_normalized


def _dos_read_hook(side, stream, buffer_label, buffer_bytes, handle, events, start=0,
                   fail_read=False, fail_after=None, close_failures=0):
    position = [start]
    successful_reads = [0]
    failed_closes = [0]

    def interrupt(u, address, size, _):
        if bytes(u.mem_read(address, size)) != b'\xCD\x21':
            return
        function = u.reg_read(REG['AX']) >> 8
        bx = u.reg_read(REG['BX'])
        flags = u.reg_read(REG['FLAGS']) & ~FLAG['CF']
        if function == 0x3F:
            if bx != handle:
                raise AssertionError(f'unexpected read handle {bx:04X}')
            if u.reg_read(REG['CX']) != buffer_bytes:
                raise AssertionError(f'unexpected read length {u.reg_read(REG["CX"]):04X}')
            ds, dx = u.reg_read(REG['DS']), u.reg_read(REG['DX'])
            if dx != side.m.symbols[buffer_label.upper()][1]:
                raise AssertionError(f'unexpected buffer offset {dx:04X}')
            fail = fail_read or (fail_after is not None and successful_reads[0] >= fail_after)
            chunk = stream[position[0]:position[0] + buffer_bytes]
            if not fail:
                position[0] += len(chunk)
                successful_reads[0] += 1
            dest = ds * 16 + dx
            if not fail:
                side.undo.append((dest, bytes(u.mem_read(dest, len(chunk)))))
            if chunk and not fail:
                u.mem_write(dest, chunk)
            events.append(('read-error' if fail else 'read', buffer_label, len(chunk)))
            u.reg_write(REG['AX'], 5 if fail else len(chunk))
            if fail: flags |= FLAG['CF']
        elif function == 0x3E:
            if bx != handle:
                raise AssertionError(f'unexpected close handle {bx:04X}')
            failed_closes[0] += 1
            failed = failed_closes[0] <= close_failures
            events.append(('close-error' if failed else 'close', bx))
            u.reg_write(REG['AX'], 5 if failed else 0)
            if failed: flags |= FLAG['CF']
        else:
            raise AssertionError(f'unexpected DOS function {function:02X}')
        u.reg_write(REG['FLAGS'], flags)
        u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + size) & 0xFFFF)

    return side.m.u.hook_add(UC_HOOK_CODE, interrupt, begin=side.image[0], end=side.image[1])


def _open_resource_hook(side, events, handle=0x1234, fail_open=False, error_ax=2):
    """Hook each implementation's SHADOW entry; retain the real packed DOS reader/closer."""
    native_open = 'ARCHIVE_OPEN_BY_NAME' in side.m.symbols
    at = side.m.linear('archive_open_by_name' if native_open else 'OpenResourceFile')

    def open_file(u, address, _size, _):
        if address != at:
            return
        sp = u.reg_read(REG['SP'])
        ss = u.reg_read(REG['SS'])
        return_ip = struct.unpack('<H', u.mem_read(ss * 16 + sp, 2))[0]
        events.append(('open-error', error_ax) if fail_open else ('open', handle))
        u.reg_write(REG['AX'], error_ax if fail_open else handle)
        if native_open:
            u.reg_write(REG['DX'], 1 if fail_open else 0)
            return_bytes = 2
        else:
            u.reg_write(REG['BX'], handle)
            flags = u.reg_read(REG['FLAGS']) & ~FLAG['CF']
            if fail_open:
                flags |= FLAG['CF']
            u.reg_write(REG['FLAGS'], flags)
            u.reg_write(REG['CS'], struct.unpack('<H', u.mem_read(ss * 16 + sp + 2, 2))[0])
            return_bytes = 4
        u.reg_write(REG['SP'], (sp + return_bytes) & 0xFFFF)
        u.reg_write(REG['IP'], return_ip)

    return side.m.u.hook_add(UC_HOOK_CODE, open_file, begin=at, end=at)


def _output_trace(side, output):
    locations = {f'{0xA0000 + (offset & 0xFFFF):05X}' for offset, _, _ in output}
    return [event for event in side.outside if event[0] in locations]


def _last_word_write(side, label):
    target = label.upper() + '+0'
    for where, size, value in reversed(side.outside):
        if where.upper() == target and size == 2:
            return value
    raise AssertionError(f'no word write recorded for {label}')


def _packed_case(pair, label, stream, output, start, output_count, name,
                 headers=None, saved_bx=None):
    events = [[], []]
    hooks = []
    entry_hooks = []
    writes = [
        (far('PackedReadCursor'), w(0xFFFF)),  # First byte forces INT 21h 3Fh.
        (far('PackedFileHandle'), w(0x1234)),
        (far('PackedDestSegment'), w(0xA000)),
        (far('PackedDestOffset'), w(start)),
        (far('PackedOutputBytes'), w(0)),
    ]

    for i, side in enumerate((pair.a, pair.b)):
        hooks.append(_dos_read_hook(side, stream, 'PackedReadBuffer', 0x200,
                                    0x1234, events[i]))
        entry_hooks.append(_force_ds_cs(side, label))

    def done(m, regs):
        actual_count = _last_word_write(pair.a, 'PackedOutputBytes')
        if actual_count != output_count:
            raise AssertionError(f'output count {actual_count:04X} != {output_count:04X}')
        if events[0] != events[1]:
            raise AssertionError(f'DOS traces differ: {events[0]!r} != {events[1]!r}')
        if saved_bx is not None:
            actual_bx = _last_word_write(pair.a, 'PackedSavedBx')
            if actual_bx != saved_bx:
                raise AssertionError(f'PackedSavedBx {actual_bx:04X} != {saved_bx:04X}')
        expected = [(f'{0xA0000 + (offset & 0xFFFF):05X}', size, value)
                    for offset, size, value in output]
        for side in (pair.a, pair.b):
            actual = _output_trace(side, output)
            if actual != expected:
                raise AssertionError(f'{name}: output writes {actual!r} != {expected!r}')
        if headers is not None:
            for field, value in zip(('PackedColumnHeader0', 'PackedColumnWidth', 'PackedColumnHeader2'), headers):
                actual = _last_word_write(pair.a, field)
                if actual != value:
                    raise AssertionError(f'{field} {actual:04X} != {value:04X}')

    try:
        yield Case(label, {'AX': 0xA500, 'BX': 0x5A6C}, writes=writes,
                   preserve=('DS', 'SS', 'SP'),
                   outputs=('ES', 'DI'), flags=('CF',), expect=done, name=name)
    finally:
        for side, hook in zip((pair.a, pair.b), hooks): side.m.u.hook_del(hook)
        for side, hook in zip((pair.a, pair.b), entry_hooks): side.m.u.hook_del(hook)


def _packed_unwind_case(pair):
    events = [[], []]
    hooks = []
    entry_hooks = []
    seed_bx = 0x5A6C
    writes = [
        (far('PackedReadCursor'), w(0xFFFF)),
        (far('PackedFileHandle'), w(0x1234)),
        (far('PackedDestSegment'), w(0xA000)),
        (far('PackedDestOffset'), w(0)),
        (far('PackedOutputBytes'), w(0)),
    ]

    for i, side in enumerate((pair.a, pair.b)):
        hooks.append(_dos_read_hook(side, b'\xFF' + b'A' * 511,
                                    'PackedReadBuffer', 0x200,
                                    0x1234, events[i], fail_after=1,
                                    close_failures=1))
        entry_hooks.append(_force_ds_cs(side, 'DecodeByteEscapeRle', packed_unwind=True))

    def done(m, regs):
        if _last_word_write(pair.a, 'PackedOutputBytes') != 511:
            raise AssertionError('partial output count differs from 511')
        if _last_word_write(pair.a, 'PackedSavedBx') != ((seed_bx & 0xFF00) | 0xFF):
            raise AssertionError('read error did not retain the decoder logical BX')
        if regs['DI'] != 511 or regs['ES'] != 0xA000:
            raise AssertionError('nonlocal read failure lost the output cursor or segment')
        if not regs['FLAGS'] & FLAG['CF']:
            raise AssertionError('packed read failure must return carry set')
        expected = [('read', 'PackedReadBuffer', 0x200),
                    ('read-error', 'PackedReadBuffer', 0),
                    ('close-error', 0x1234), ('close', 0x1234)]
        if events[0] != expected or events[1] != expected:
            raise AssertionError(f'packed unwind DOS trace {events!r} != {expected!r}')

    try:
        yield Case('DecodeByteEscapeRle', {'AX': 0x7C00, 'BX': seed_bx, 'ES': 0xB800},
                   writes=writes, preserve=('DS', 'SS', 'SP'), outputs=('ES', 'DI'),
                   flags=('CF',), expect=done, name='read-error unwind with partial output')
    finally:
        for side, hook in zip((pair.a, pair.b), hooks): side.m.u.hook_del(hook)
        for side, hook in zip((pair.a, pair.b), entry_hooks): side.m.u.hook_del(hook)


def _enc_case(pair, stream, output, start, output_count, input_cursor, name,
              ring_seed=None):
    events = [[], []]
    hooks = []
    entry_hooks = []
    initial = stream[:0x400].ljust(0x400, b'\0')
    writes = [
        (far('EncFileHandle'), w(0x1234)),
        (far('EncDestSegment'), w(0xA000)),
        (far('EncDestOffset'), w(start)),
        (far('EncReadBuffer'), initial),
    ]
    if ring_seed is not None:
        ring_offset, ring_bytes = ring_seed
        writes.append((far('EncRingBuffer', ring_offset), ring_bytes))

    for i, side in enumerate((pair.a, pair.b)):
        hooks.append(_dos_read_hook(side, stream, 'EncReadBuffer', 0x400,
                                    0x1234, events[i], start=0x400))
        entry_hooks.append(_force_ds_cs(side, 'DecodeEncStream'))

    def done(m, regs):
        if (_last_word_write(pair.a, 'EncOutputBytes') != output_count or
                _last_word_write(pair.a, 'EncOutputBytesHigh') != 0):
            raise AssertionError('ENC output count differs from the fixture')
        if events[0] != events[1]:
            raise AssertionError(f'ENC read traces differ: {events[0]!r} != {events[1]!r}')
        expected = [(f'{address:05X}', 1, value) for address, value in output]
        for side in (pair.a, pair.b):
            actual = [event for event in side.outside if event[0] in {row[0] for row in expected}]
            if actual != expected:
                raise AssertionError(f'{name}: ENC output writes {actual!r} != {expected!r}')
        if regs['SI'] != input_cursor:
            raise AssertionError(f'ENC SI {regs["SI"]:04X} != {input_cursor:04X}')
        expected_bp = (0x0FEE + output_count) & 0x0FFF
        if regs['BP'] != expected_bp:
            raise AssertionError(f'ENC BP {regs["BP"]:04X} != ring cursor {expected_bp:04X}')

    try:
        yield Case('DecodeEncStream', {'ES': 0xB800}, writes=writes,
                   preserve=('DS', 'ES', 'SS', 'SP'), outputs=('SI', 'DI', 'BP'),
                   flags=('ZF', 'CF'), expect=done, name=name)
    finally:
        for side, hook in zip((pair.a, pair.b), hooks): side.m.u.hook_del(hook)
        for side, hook in zip((pair.a, pair.b), entry_hooks): side.m.u.hook_del(hook)


def _buffered_reader_case(pair, label, cursor, buffer, stream, expected_ax, name,
                          expected_cursor=1):
    events = [[], []]
    hooks = []
    entry_hooks = []
    writes = [
        (far('PackedFileHandle'), w(0x1234)),
        (far('PackedReadBuffer'), buffer),
    ]
    if cursor != 'buffer_last_byte':
        writes.append((far('PackedReadCursor'), w(cursor)))
    for i, side in enumerate((pair.a, pair.b)):
        hooks.append(_dos_read_hook(side, stream, 'PackedReadBuffer', 0x200,
                                    0x1234, events[i]))
        entry_hooks.append(_force_ds_cs(side, label,
                                        read_cursor='buffer_last_byte' if cursor == 'buffer_last_byte' else None))

    def done(_machine, regs):
        if regs['AX'] != expected_ax:
            raise AssertionError(f'{label} AX {regs["AX"]:04X} != {expected_ax:04X}')
        if events[0] != events[1]:
            raise AssertionError(f'{label} DOS refill traces differ: {events!r}')
        if _last_word_write(pair.a, 'PackedReadCursor') != expected_cursor:
            raise AssertionError(f'{label} cursor offset {_last_word_write(pair.a, "PackedReadCursor"):04X} != {expected_cursor:04X}')

    try:
        yield Case(label, {'AX': 0xA500, 'BX': 0x1234, 'CX': 0x55AA},
                   writes=writes, preserve=('BX', 'CX', 'DS', 'SS', 'SP'),
                   outputs=('AX',), flags=tuple(FLAG), expect=done, name=name)
    finally:
        for side, hook in zip((pair.a, pair.b), hooks): side.m.u.hook_del(hook)
        for side, hook in zip((pair.a, pair.b), entry_hooks): side.m.u.hook_del(hook)


def _open_resource_load_case(pair, stream, name, fail_read=False, fail_after=None,
                             close_failures=0, expected_output=b'', expected_ax=0,
                             expected_carry=0, expected_events=(), expected_cursor=None,
                             fail_open=False, open_error=2):
    events = [[], []]
    hooks = []
    writes = [
        (far('PackedNamePtr'), w(0x4567)),
        (far('PackedDestSegment'), w(0xA000)),
        (far('PackedDestOffset'), w(0x0100)),
        (far('PackedOutputBytes'), w(0xCAFE)),
        (far('PackedReadBuffer'), stream[:0x200].ljust(0x200, b'\0')),
    ]
    for i, side in enumerate((pair.a, pair.b)):
        hooks.append((side, _open_resource_hook(side, events[i], fail_open=fail_open,
                                                 error_ax=open_error)))
        hooks.append((side, _dos_read_hook(side, stream, 'PackedReadBuffer', 0x200,
                                          0x1234, events[i], fail_read=fail_read,
                                          fail_after=fail_after,
                                          close_failures=close_failures)))

    def done(_machine, regs):
        if regs['AX'] != expected_ax:
            raise AssertionError(f'LoadPackedFile AX {regs["AX"]:04X} != {expected_ax:04X}')
        if bool(regs['FLAGS'] & FLAG['CF']) != bool(expected_carry):
            raise AssertionError('LoadPackedFile carry does not match its file/decode result')
        if expected_carry:
            oracle_bx = regs['BX']
            hybrid_bx = pair.b.m.u.reg_read(REG['BX'])
            if oracle_bx != pair.a.m.data_frame or hybrid_bx != pair.b.m.data_frame:
                raise AssertionError('LoadPackedFile failure must return each link’s state segment in BX')
        if events[0] != list(expected_events) or events[1] != list(expected_events):
            raise AssertionError(f'LoadPackedFile DOS trace {events!r} != {expected_events!r}')
        if _last_word_write(pair.a, 'PackedOutputBytes') != len(expected_output):
            raise AssertionError('LoadPackedFile output count differs')
        if expected_cursor is not None and regs['DI'] != expected_cursor:
            raise AssertionError(f'LoadPackedFile DI {regs["DI"]:04X} != {expected_cursor:04X}')
        output_trace = [(0x0100 + i, 1, value)
                        for i, value in enumerate(expected_output)]
        expected_trace = [(f'{0xA0000 + offset:05X}', size, value)
                          for offset, size, value in output_trace]
        for side in (pair.a, pair.b):
            actual = _output_trace(side, output_trace)
            if actual != expected_trace:
                raise AssertionError(f'LoadPackedFile writes {actual!r} != {expected_trace!r}')

    try:
        yield Case('LoadPackedFile', {'AX': 0xA500, 'BX': 0x9999, 'DI': 0x4321,
                                      'ES': 0xB800},
                   writes=writes, preserve=('SS', 'SP'),
                   outputs=('AX', 'DS', 'ES', 'DI') + (() if expected_carry else ('BX',)),
                   flags=('CF',), expect=done, name=name)
    finally:
        for side, hook in hooks: side.m.u.hook_del(hook)


def _enc_file_case(pair, stream, name, fail_read=False, close_failures=0,
                   expected_output=b'', expected_ax=0, expected_carry=0,
                   expected_events=(), expected_si=None, expected_di=None,
                   old_count=(0x1234, 0xABCD), input_bp=0x6B2D):
    events = [[], []]
    hooks = []
    writes = [
        (far('EncFileHandle'), w(0x1234)),
        (far('EncDestSegment'), w(0x5000)),
        (far('EncDestOffset'), w(0xFFF0)),
        (far('EncOutputBytes'), w(old_count[0])),
        (far('EncOutputBytesHigh'), w(old_count[1])),
        (far('EncReadBuffer'), bytes(0x400)),
    ]
    for i, side in enumerate((pair.a, pair.b)):
        hooks.append(_dos_read_hook(side, stream, 'EncReadBuffer', 0x400, 0x1234,
                                    events[i], fail_read=fail_read,
                                    close_failures=close_failures))

    def done(_machine, regs):
        if regs['AX'] != expected_ax:
            raise AssertionError(f'DecodeEncFile AX {regs["AX"]:04X} != {expected_ax:04X}')
        if bool(regs['FLAGS'] & FLAG['CF']) != bool(expected_carry):
            raise AssertionError('DecodeEncFile carry differs from initial-read/close contract')
        if events[0] != list(expected_events) or events[1] != list(expected_events):
            raise AssertionError(f'DecodeEncFile DOS trace {events!r} != {expected_events!r}')
        if expected_si is not None and regs['SI'] != expected_si:
            raise AssertionError(f'DecodeEncFile SI {regs["SI"]:04X} != {expected_si:04X}')
        if expected_di is not None and regs['DI'] != expected_di:
            raise AssertionError(f'DecodeEncFile DI {regs["DI"]:04X} != {expected_di:04X}')
        expected_bp = input_bp if expected_carry else (0x0FEE + len(expected_output)) & 0x0FFF
        if regs['BP'] != expected_bp:
            raise AssertionError(f'DecodeEncFile BP {regs["BP"]:04X} != {expected_bp:04X}')
        expected_count = len(expected_output) if not fail_read else (
            old_count[0] | (old_count[1] << 16))
        try:
            low = _last_word_write(pair.a, 'EncOutputBytes')
        except AssertionError:
            low = old_count[0]
        try:
            high = _last_word_write(pair.a, 'EncOutputBytesHigh')
        except AssertionError:
            high = old_count[1]
        count = low | (high << 16)
        if count != expected_count:
            raise AssertionError(f'DecodeEncFile output count {count:08X} != {expected_count:08X}')
        expected_trace = [(f'{0x5FFF0 + i:05X}', 1, value)
                          for i, value in enumerate(expected_output)]
        locations = {event[0] for event in expected_trace}
        for side in (pair.a, pair.b):
            actual = [event for event in side.outside if event[0] in locations]
            if actual != expected_trace:
                raise AssertionError(f'DecodeEncFile writes {actual!r} != {expected_trace!r}')

    try:
        yield Case('DecodeEncFile', {'AX': 0xA55A, 'BX': 0xBEEF, 'SI': 0x4567,
                                     'DI': 0x89AB, 'BP': input_bp, 'ES': 0xB800},
                   writes=writes, preserve=('DS', 'ES', 'SS', 'SP'),
                   outputs=('AX', 'BX', 'SI', 'DI', 'BP'), flags=('CF',),
                   expect=done, name=name)
    finally:
        for side, hook in zip((pair.a, pair.b), hooks): side.m.u.hook_del(hook)


def _enc_counter_rollover_case(pair):
    """Compare the oracle store entry with its native C helper at the low-word carry."""
    cursor_offset = pair.a.m.stack_top - 0x80
    stack_area = pair.a.m.offset('StackArea')
    if not stack_area <= cursor_offset < pair.a.m.stack_top - 0x42:
        raise AssertionError('ENC cursor fixture must live below the differential entry SP')

    hybrid_symbols = pair.b.m.symbols
    native = hybrid_symbols.get('STORE_ENC_BYTE')
    if native is None:
        raise AssertionError('hybrid has no native STORE_ENC_BYTE C helper')
    previous_alias = hybrid_symbols.get('STOREENCBYTE')
    hybrid_symbols['STOREENCBYTE'] = native
    original_run = pair.b.run

    def call_native_store(case, sp, fresh=True, keep=False):
        if case.label != 'StoreEncByte':
            return original_run(case, sp, fresh, keep)
        adapted = Case('STORE_ENC_BYTE', {'SI': cursor_offset, 'DI': 0x005A,
                                          'ES': case.regs['ES']},
                       writes=case.writes, preserve=case.preserve,
                       outputs=case.outputs, flags=case.flags, name=case.name)
        return original_run(adapted, sp, fresh, keep)

    pair.b.run = call_native_store
    writes = [
        (far('EncOutputBytes'), w(0xFFFF)),
        (far('EncOutputBytesHigh'), w(0x2345)),
        (cursor_offset, w(0xFFFF) + w(0xA000)),
    ]

    def done(_machine, regs):
        if regs['AX'] != 0x005A or regs['DI'] != 0 or regs['ES'] != 0xB000:
            raise AssertionError('oracle StoreEncByte did not preserve AL and step wrapped ES:DI')
        if _last_word_write(pair.a, 'EncOutputBytes') != 0:
            raise AssertionError('StoreEncByte did not wrap the low output counter')
        if _last_word_write(pair.a, 'EncOutputBytesHigh') != 0x2346:
            raise AssertionError('StoreEncByte did not increment the high output counter')
        if ('AFFFF', 1, 0x5A) not in pair.a.outside:
            raise AssertionError('StoreEncByte did not write the destination byte')
        cursor = pair.b.m.read(cursor_offset, 4)
        if cursor != w(0) + w(0xB000):
            raise AssertionError(f'native StoreEncByte cursor {cursor.hex()} != 000000B0')

    try:
        yield Case('StoreEncByte', {'AX': 0x005A, 'ES': 0xA000, 'DI': 0xFFFF},
                   writes=writes, preserve=('DS', 'SS', 'SP'),
                   expect=done, name='native ENC counter rollover')
    finally:
        pair.b.run = original_run
        if previous_alias is None:
            del hybrid_symbols['STOREENCBYTE']
        else:
            hybrid_symbols['STOREENCBYTE'] = previous_alias


def synthetic_cases(rng, scale, pair):
    yield from _packed_unwind_case(pair)

    # Exercise the retained raw leaves independently: one first read and a word read
    # straddling the end of the original 512-byte packed buffer.
    yield from _buffered_reader_case(pair, 'ReadBufferedByte', 0xFFFF,
                                     bytes(0x200), b'B', 0x0042,
                                     'real packed byte refill', expected_cursor=1)
    word_buffer = bytearray(0x200)
    word_buffer[-1] = 0x34
    yield from _buffered_reader_case(pair, 'ReadBufferedWordLE', 'buffer_last_byte',
                                     bytes(word_buffer), b'\x78', 0x7834,
                                     'real packed word refill across buffer end',
                                     expected_cursor=1)

    # C owns LoadPackedFile's format selection, counter reset, decode failure and
    # close-retry decisions. Only SHADOW lookup itself is stubbed; packed DOS reads and
    # closes still pass through the real MAIN service leaves and INT 21h hooks.
    yield from _open_resource_load_case(
        pair, b'\x00\xFFA\xFF\x00',
        'LoadPackedFile mode-0 success', expected_output=b'A', expected_ax=0,
        expected_events=(('open', 0x1234), ('read', 'PackedReadBuffer', 5),
                         ('close', 0x1234)), expected_cursor=0x0101)
    yield from _open_resource_load_case(
        pair, b'\x09', 'LoadPackedFile unsupported mode', expected_ax=0xFFFF,
        expected_carry=1,
        expected_events=(('open', 0x1234), ('read', 'PackedReadBuffer', 1),
                         ('close', 0x1234)))
    yield from _open_resource_load_case(
        pair, b'', 'LoadPackedFile header read failure', fail_read=True,
        close_failures=1, expected_ax=5, expected_carry=1,
        expected_events=(('open', 0x1234), ('read-error', 'PackedReadBuffer', 0),
                         ('close-error', 0x1234), ('close', 0x1234)))
    yield from _open_resource_load_case(
        pair, b'\x00\xFF' + b'A' * 510, 'LoadPackedFile partial decode/read failure',
        fail_after=1, close_failures=1, expected_output=b'A' * 510,
        expected_ax=5, expected_carry=1,
        expected_events=(('open', 0x1234), ('read', 'PackedReadBuffer', 0x200),
                         ('read-error', 'PackedReadBuffer', 0),
                         ('close-error', 0x1234), ('close', 0x1234)),
        expected_cursor=0x0100 + 510)

    yield from _open_resource_load_case(
        pair, b'', 'LoadPackedFile open failure', fail_open=True, open_error=2,
        expected_ax=2, expected_carry=1, expected_events=(('open-error', 2),))

    # Exercise LoadPackedFile's mode-2/3/4 dispatch jumps through successful
    # short resources; the direct decoder fixtures below cover their inner branches.
    yield from _open_resource_load_case(
        pair, b'\x02' + words(0xFFFF, 0xFFFF, 0),
        'LoadPackedFile mode-2 empty resource', expected_output=b'',
        expected_events=(('open', 0x1234), ('read', 'PackedReadBuffer', 7),
                         ('close', 0x1234)), expected_cursor=0x0100)
    yield from _open_resource_load_case(
        pair, b'\x03\x01AB\x80', 'LoadPackedFile mode-3 dispatch',
        expected_output=b'AB', expected_events=(('open', 0x1234),
            ('read', 'PackedReadBuffer', 5), ('close', 0x1234)),
        expected_cursor=0x0102)
    yield from _open_resource_load_case(
        pair, b'\x04' + words(1, 1, 1) + bytes((0, ord('C'), 0x80)),
        'LoadPackedFile mode-4 dispatch', expected_output=b'C',
        expected_events=(('open', 0x1234), ('read', 'PackedReadBuffer', 10),
                         ('close', 0x1234)), expected_cursor=0x0101)

    yield from _enc_counter_rollover_case(pair)

    # DecodeEncFile owns the first 1024-byte read and closes only after a successful
    # stream. A failed first read leaves the handle open and the old output count intact.
    yield from _enc_file_case(
        pair, b'\x01A\x00\x00\x00', 'DecodeEncFile close error ignored',
        close_failures=1, expected_output=b'A', expected_ax=5,
        expected_events=(('read', 'EncReadBuffer', 5), ('close-error', 0x1234)),
        expected_si=5, expected_di=0xFFF1)
    yield from _enc_file_case(
        pair, b'', 'DecodeEncFile initial read failure', fail_read=True,
        expected_ax=5, expected_carry=1,
        expected_events=(('read-error', 'EncReadBuffer', 0),),
        expected_si=0x4567, expected_di=0x89AB)

    # Mode 0: one literal and an escape/count/value run, with 16-bit output wrap.
    stream = bytes((0xFF, ord('A'), 0xFF, 2, ord('X'), 0xFF, 0))
    yield from _packed_case(pair, 'DecodeByteEscapeRle', stream,
                            [(0xFFFF, 1, ord('A')), (0x0000, 1, ord('X')),
                             (0x0001, 1, ord('X'))], 0xFFFF, 3,
                            'byte escape run and output wrap', saved_bx=0x5AFF)

    # Mode 1: little-endian word literal, word run, and zero-count terminator.
    stream = words(0xFFFF, 0x1234, 0xFFFF, 2, 0xBEEF, 0xFFFF, 0)
    yield from _packed_case(pair, 'DecodeWordEscapeRle', stream,
                            [(0xFFFE, 2, 0x1234), (0x0000, 2, 0xBEEF),
                             (0x0002, 2, 0xBEEF)], 0xFFFE, 6,
                            'word escape run and output wrap', saved_bx=0xFFFF)

    # Mode 2: dword literal followed by a two-copy dword run.
    stream = words(0xFFFF, 0x1111, 0x2222, 0xFFFF, 2, 0xAAAA, 0xBBBB, 0xFFFF, 0)
    yield from _packed_case(pair, 'DecodeDwordEscapeRle', stream,
                            [(0xFFFC, 2, 0x1111), (0xFFFE, 2, 0x2222),
                             (0x0000, 2, 0xAAAA), (0x0002, 2, 0xBBBB),
                             (0x0004, 2, 0xAAAA), (0x0006, 2, 0xBBBB)],
                            0xFFFC, 12, 'dword literal, run, and output wrap',
                            saved_bx=0xFFFF)

    # Mode 3: literal and repeat controls. The stream consumes exactly 512 bytes before
    # its terminator, forcing a second DOS-buffer fill.
    prefix = bytearray()
    expected_bytes = bytearray()
    for count in (128, 128, 128, 124):
        prefix.append(count - 1)
        values = bytes(i & 0xFF for i in range(count))
        prefix.extend(values)
        expected_bytes.extend(values)
    if len(prefix) != 0x200:
        raise AssertionError('synthetic refill fixture must end at byte 512')
    output = [(i, 1, value) for i, value in enumerate(expected_bytes)]
    yield from _packed_case(pair, 'DecodePackBitsStream', bytes(prefix) + b'\x80',
                            output, 0, len(expected_bytes), 'PackBits buffered refill',
                            saved_bx=0x5A6C)

    # A run-value read at the buffer boundary reproduces the original xchg BL,AH
    # scratch behavior when the DOS read's byte count changes AH to zero.
    prefix = bytearray()
    output_bytes = bytearray()
    for i in range(254):
        prefix.extend((0, i & 0xFF))
        output_bytes.append(i & 0xFF)
    prefix.extend((1, ord('L'), ord('M')))  # 254*2 + 3 = 511 input bytes.
    output_bytes.extend(b'LM')
    if len(prefix) != 511:
        raise AssertionError('PackBits run fixture must place the run control at byte 511')
    stream = bytes(prefix) + bytes((0xFE, ord('R'), 0x80))
    output_bytes.extend(b'RRR')
    yield from _packed_case(pair, 'DecodePackBitsStream', stream,
                            [(i, 1, value) for i, value in enumerate(output_bytes)],
                            0, len(output_bytes), 'PackBits run and refill BX scratch',
                            saved_bx=0x5A00)

    # Mode 4: width controls two columns; the first has literals and the second a run.
    stream = words(6, 2, 3) + bytes((0x02, ord('A'), ord('B'), ord('C'), 0x80,
                                    0xFE, ord('X'), 0x80))
    yield from _packed_case(pair, 'DecodeColumnPackBits', stream,
                            [(0xFFFE, 1, ord('A')), (0x0000, 1, ord('B')),
                             (0x0002, 1, ord('C')), (0xFFFF, 1, ord('X')),
                             (0x0001, 1, ord('X')), (0x0003, 1, ord('X'))],
                            0xFFFE, 6, 'column stride and output wrap', (6, 2, 3),
                            saved_bx=0x5A6C)

    # ENC: three literals force DI wrap, then the 00 00 00 terminator.
    stream = bytes((0x07, ord('A'), ord('B'), ord('C'), 0, 0, 0))
    yield from _enc_case(pair, stream,
                         [(0xAFFFE, ord('A')), (0xAFFFF, ord('B')), (0xB0000, ord('C'))],
                         0xFFFE, 3, len(stream), 'ENC terminator and segment step')

    # ENC pushback quirk: 00 00 X pushes X back after copying three bytes from ring 0.
    stream = bytes((0, 0, 0, 1, 0, 0, 0, 0))
    yield from _enc_case(pair, stream,
                         [(0xA0000 + i, 0) for i in range(6)],
                         0, 6, len(stream), 'ENC nonzero sentinel pushback')

    # Only ring bytes 0000h..0FEDh are cleared. A reference at FEEh observes the
    # previous decode's 18-byte suffix before replacing those positions.
    stream = bytes((0, 0xEE, 0xF0, 0, 0, 0))
    stale = bytes((0x51, 0x62, 0x73))
    yield from _enc_case(pair, stream,
                         [(0xA0000 + i, value) for i, value in enumerate(stale)],
                         0, 3, len(stream), 'ENC retained ring suffix',
                         ring_seed=(0xFEE, stale))

    # 1,023 literals cross the 1 KiB refill in the middle of the final flag group.
    stream = bytearray()
    payload = bytearray()
    left = 1023
    value = 0
    while left:
        count = min(8, left)
        stream.append((1 << count) - 1)
        for _ in range(count):
            payload.append(value & 0xFF)
            stream.append(value & 0xFF)
            value += 1
        left -= count
    stream.extend((0, 0, 0))
    output = []
    for i, value in enumerate(payload):
        address = (0xAFFFE + i) if i < 2 else (0xB0000 + i - 2)
        output.append((address, value))
    yield from _enc_case(pair, bytes(stream), output, 0xFFFE, len(payload),
                         len(stream) & 0x03FF, 'ENC 1 KiB refill and output wrap')


MUTANTS = [
    ('resource_codecs.c',
     'count = (word)(257 - control);\n            /* NEG AL / XCHG AH,AL / XCHG BL,AH before reading the value. */',
     'count = (word)(256 - control);\n            /* NEG AL / XCHG AH,AL / XCHG BL,AH before reading the value. */'),
    ('resource_codecs.c', 'output = (word)(column_start + 1);', 'output = column_start;'),
    ('resource_codecs.c',
     "/* The second XCHG makes the reader's AH the new BL. */\n            input.bx = (word)((input.bx & 0xFF00) | (raw >> 8));",
     "/* The second XCHG makes the reader's AH the new BL. */\n            input.bx = (word)((input.bx & 0xFF00) | (byte)(0 - control));"),
    ('resource_codecs.c', 'i < 0x0FEE', 'i < 0x1000'),
    ('resource_codecs.c',
     'EncPushback = 1;\n    EncPushedByte = (byte)value;',
     'EncPushedByte = (byte)value;'),
    ('resource_codecs.c',
     'else {\n        result->failed = 1;\n        result->ax = codec_call_packed_close_after_failure(\n            PackedCloseAfterFailureService, 0xFFFF);',
     'else {\n        result->failed = 0;\n        result->ax = codec_call_packed_close_after_failure(\n            PackedCloseAfterFailureService, 0xFFFF);'),
    ('resource_codecs.c',
     'if ((word)(header >> 16) != 0) {',
     'if ((word)(header >> 16) == 0) {'),
    ('resource_codecs.c',
     'result->ax = codec_call_packed_close_after_failure(\n            PackedCloseAfterFailureService, error_ax);\n        result->failed = 1;\n        result->bx = MainDataSegment;\n        return;\n    }\n\n    closed = codec_call_packed_close(PackedCloseService);',
     'result->ax = codec_call_packed_close(PackedCloseService);\n        result->failed = 1;\n        result->bx = MainDataSegment;\n        return;\n    }\n\n    closed = codec_call_packed_close(PackedCloseService);'),
]


PACKED_BUFFER_BYTES = 0x200
ENC_BUFFER_BYTES = 0x400
DOS_HANDLE = 0x1234
PACKED_DEST_SEGMENT = 0xA000
PACKED_DEST_OFFSET = 0x0100
ENC_DEST_SEGMENT = 0x5000
ENC_DEST_OFFSET = 0xFFF0


def _u16(value: int) -> bytes:
    return struct.pack("<H", value & 0xFFFF)


def _packed_reference(stream: bytes):
    """Return mode, ordered (segment-offset, byte) writes, and consumed input bytes."""
    if not stream:
        raise AssertionError("empty BIC resource")
    mode = stream[0]
    pos = 1
    writes = []

    def get_byte():
        nonlocal pos
        if pos >= len(stream):
            raise AssertionError(f"BIC mode {mode} ended before its terminator at {pos}")
        value = stream[pos]
        pos += 1
        return value

    def emit(offset, value):
        writes.append((offset & 0xFFFF, value & 0xFF))

    if mode == 0:
        escape = get_byte()
        output = 0
        while True:
            value = get_byte()
            if value != escape:
                emit(output, value)
                output += 1
                continue
            count = get_byte()
            if count == 0:
                break
            value = get_byte()
            for _ in range(count):
                emit(output, value)
                output += 1
    elif mode == 3:
        output = 0
        while True:
            control = get_byte()
            if control == 0x80:
                break
            if control < 0x80:
                for _ in range(control + 1):
                    emit(output, get_byte())
                    output += 1
            else:
                value = get_byte()
                for _ in range(257 - control):
                    emit(output, value)
                    output += 1
    elif mode == 4:
        if len(stream) < 6:
            raise AssertionError("short column BIC header")
        _height_product, width, _rows = struct.unpack_from("<HHH", stream, pos)
        pos += 6
        if width == 0:
            raise AssertionError("zero-width column BIC")
        for column in range(width):
            row = 0
            while True:
                control = get_byte()
                if control == 0x80:
                    break
                if control < 0x80:
                    values = [get_byte() for _ in range(control + 1)]
                else:
                    value = get_byte()
                    values = [value] * (257 - control)
                for value in values:
                    emit(column + row * width, value)
                    row += 1
    else:
        raise AssertionError(f"unsupported shipped BIC mode {mode}")

    if len(writes) > 0x100000:
        raise AssertionError("unbounded BIC reference output")
    return mode, writes, pos


def _capture_packed(side, writes):
    """Compare ordered output stores, including repeats and 16-bit offset wrap."""
    expected = []
    for offset, value in writes:
        address = PACKED_DEST_SEGMENT * 16 + ((PACKED_DEST_OFFSET + offset) & 0xFFFF)
        expected.append((f"{address:05X}", 1, value))
    locations = {event[0] for event in expected}
    actual = [event for event in side.outside if event[0] in locations]
    if actual != expected:
        raise AssertionError(f"BIC output stores {actual[:8]!r} != reference {expected[:8]!r}")


def _packed_entry_hook(side, label):
    at = side.m.linear(label)

    def enter(u, address, _size, _):
        if address != at:
            return
        u.reg_write(REG["DS"], u.reg_read(REG["CS"]))
        cursor = side.m.linear("PackedReadCursor")
        side.undo.append((cursor, bytes(u.mem_read(cursor, 2))))
        buffer_offset = side.m.symbols["PACKEDREADBUFFER"][1]
        u.mem_write(cursor, _u16(buffer_offset + 1))

    return side.m.u.hook_add(UC_HOOK_CODE, enter, begin=at, end=at)


def _asset_packed_case(pair, row, payload, label, mode, ref_writes, consumed):
    events = [[], []]
    hooks = []
    entry_hooks = []
    initial = payload[:PACKED_BUFFER_BYTES].ljust(PACKED_BUFFER_BYTES, b"\0")
    writes = [
        (far("PackedFileHandle"), _u16(DOS_HANDLE)),
        (far("PackedDestSegment"), _u16(PACKED_DEST_SEGMENT)),
        (far("PackedDestOffset"), _u16(PACKED_DEST_OFFSET)),
        (far("PackedOutputBytes"), _u16(0)),
        (far("PackedReadBuffer"), initial),
    ]
    for i, side in enumerate((pair.a, pair.b)):
        hooks.append(_dos_read_hook(
            side, payload, "PackedReadBuffer", PACKED_BUFFER_BYTES, DOS_HANDLE,
            events[i], start=PACKED_BUFFER_BYTES,
        ))
        entry_hooks.append(_packed_entry_hook(side, label))

    # LoadPackedFile's first DOS read fills the buffer before it consumes mode byte.
    # ReadBufferedByte leaves AH from the DOS byte count while returning the mode in AL.
    first_read_bytes = min(len(payload), PACKED_BUFFER_BYTES)
    entry_ax = ((first_read_bytes & 0xFF00) | mode) & 0xFFFF
    refill_count = max(0, (consumed - 1) // PACKED_BUFFER_BYTES)
    expected_events = []
    for i in range(refill_count):
        start = PACKED_BUFFER_BYTES * (i + 1)
        expected_events.append(("read", "PackedReadBuffer", min(PACKED_BUFFER_BYTES, len(payload) - start)))
    expected_events.append(("close", DOS_HANDLE))
    expected_count = len(ref_writes) & 0xFFFF

    def done(_machine, _regs):
        actual_count = _last_word_write(pair.a, "PackedOutputBytes")
        if actual_count != expected_count:
            raise AssertionError(f"{row['name']}: count {actual_count} != {expected_count}")
        if events[0] != expected_events or events[1] != expected_events:
            raise AssertionError(
                f"{row['name']}: DOS reads {events!r} != expected {expected_events!r}"
            )
        for side in (pair.a, pair.b):
            _capture_packed(side, ref_writes)

    case = Case(
        label,
        {"AX": entry_ax, "BX": DOS_HANDLE},
        writes=writes,
        preserve=("DS", "SS", "SP"),
        outputs=("ES", "DI"),
        flags=("CF",),
        expect=done,
        name=f"{row['name']} (mode {mode}, {len(payload)} compressed bytes)",
    )

    try:
        yield case
    finally:
        for side, hook in zip((pair.a, pair.b), hooks):
            side.m.u.hook_del(hook)
        for side, hook in zip((pair.a, pair.b), entry_hooks):
            side.m.u.hook_del(hook)


def _asset_enc_case(pair, row, payload, expected_output, consumed):
    events = [[], []]
    hooks = []
    entry_hooks = []
    initial = payload[:ENC_BUFFER_BYTES].ljust(ENC_BUFFER_BYTES, b"\0")
    writes = [
        (far("EncFileHandle"), _u16(DOS_HANDLE)),
        (far("EncDestSegment"), _u16(ENC_DEST_SEGMENT)),
        (far("EncDestOffset"), _u16(ENC_DEST_OFFSET)),
        (far("EncReadBuffer"), initial),
    ]

    for i, side in enumerate((pair.a, pair.b)):
        hooks.append(_dos_read_hook(
            side, payload, "EncReadBuffer", ENC_BUFFER_BYTES, DOS_HANDLE,
            events[i], start=ENC_BUFFER_BYTES,
        ))
        entry_hooks.append(_force_ds_cs(side, "DecodeEncStream"))

    refill_count = max(0, (consumed - 1) // ENC_BUFFER_BYTES)
    expected_events = []
    for i in range(refill_count):
        start = ENC_BUFFER_BYTES * (i + 1)
        expected_events.append(("read", "EncReadBuffer", min(ENC_BUFFER_BYTES, len(payload) - start)))
    expected_low, expected_high = divmod(len(expected_output), 0x10000)
    expected_si = consumed & 0x03FF
    expected_di = (ENC_DEST_OFFSET + len(expected_output)) & 0xFFFF

    def done(_machine, regs):
        actual_count = (
            _last_word_write(pair.a, "EncOutputBytes") +
            0x10000 * _last_word_write(pair.a, "EncOutputBytesHigh")
        )
        if actual_count != len(expected_output):
            raise AssertionError(f"{row['name']}: output count {actual_count} != {len(expected_output)}")
        if events[0] != expected_events or events[1] != expected_events:
            raise AssertionError(
                f"{row['name']}: DOS refills {events!r} != expected {expected_events!r}"
            )
        if regs["SI"] != expected_si or regs["DI"] != expected_di:
            raise AssertionError(
                f"{row['name']}: final SI:DI {regs['SI']:04X}:{regs['DI']:04X} "
                f"!= expected {expected_si:04X}:{expected_di:04X}"
            )
        expected_bp = (0x0FEE + len(expected_output)) & 0x0FFF
        if regs["BP"] != expected_bp:
            raise AssertionError(
                f"{row['name']}: final BP {regs['BP']:04X} != ring cursor {expected_bp:04X}"
            )
        base = ENC_DEST_SEGMENT * 16 + ENC_DEST_OFFSET
        expected = [(f"{base + i:05X}", 1, value)
                    for i, value in enumerate(expected_output)]
        locations = {event[0] for event in expected}
        for side in (pair.a, pair.b):
            actual = [event for event in side.outside if event[0] in locations]
            if actual != expected:
                raise AssertionError(f"{row['name']}: decoded output stores differ from reference")

    case = Case(
        "DecodeEncStream",
        {"ES": 0xB800},
        writes=writes,
        preserve=("DS", "ES", "SS", "SP"),
        outputs=("SI", "DI", "BP"),
        flags=("ZF", "CF"),
        expect=done,
        name=f"{row['name']} ({len(payload)} compressed -> {len(expected_output)} bytes)",
    )

    try:
        yield case
    finally:
        for side, hook in zip((pair.a, pair.b), hooks):
            side.m.u.hook_del(hook)
        for side, hook in zip((pair.a, pair.b), entry_hooks):
            side.m.u.hook_del(hook)


def asset_cases(rng, scale, pair):
    del rng, scale
    data, rows = resources()
    packed_rows = [row for row in rows if row["name"].upper().endswith(".BIC")]
    enc_rows = [row for row in rows if row["name"].upper().endswith(".ENC")]
    if not packed_rows or not enc_rows:
        raise AssertionError("pinned SHADOW directory has no BIC or ENC assets")

    for row in packed_rows:
        payload = data[row["offset"]:row["offset"] + row["size"]]
        mode, ref_writes, consumed = _packed_reference(payload)
        label = {
            0: "DecodeByteEscapeRle",
            3: "DecodePackBitsStream",
            4: "DecodeColumnPackBits",
        }[mode]
        yield from _asset_packed_case(pair, row, payload, label, mode, ref_writes, consumed)

    for row in enc_rows:
        payload = data[row["offset"]:row["offset"] + row["size"]]
        decoded, consumed = decode_enc(payload)
        yield from _asset_enc_case(pair, row, payload, decoded, consumed)



def cases(rng, scale, pair):
    _normalize_relocated_read_cursor(pair)
    try:
        yield from synthetic_cases(rng, scale, pair)
        yield from asset_cases(rng, scale, pair)
    finally:
        _restore_relocated_read_cursor(pair)
