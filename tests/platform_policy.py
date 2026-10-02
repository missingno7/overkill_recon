"""Bounded differential cases for the DOS platform-policy region.

The hardware/file boundaries are the real oracle ASM leaves. BIOS/DOS calls and
keyboard-IRQ state are mocked at their instruction boundaries; no case enters gameplay.
"""
from difftest import Case, ALL_REGS, far
from emu import REG, FLAG, LOAD
from options import hook, cleanup, check, return_service
from world import World, K
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
from capstone import Cs, CS_ARCH_X86, CS_MODE_16
import random
import struct

FREE = ('SP', 'DS', 'SS')
STATUS_FLAGS = ('CF', 'PF', 'AF', 'ZF', 'SF', 'DF', 'OF')
MD = Cs(CS_ARCH_X86, CS_MODE_16)


def set_external(side, value, symbol, size):
    at = side.m.linear(symbol)
    side.undo.append((at, bytes(side.m.u.mem_read(at, size))))
    side.m.u.mem_write(at, int(value).to_bytes(size, 'little'))


def seed_at_entry(side, bag, entry, symbol, value, size=2):
    done = [False]
    def enter(u, address, ins_size, _):
        if done[0]: return
        done[0] = True
        set_external(side, value, symbol, size)
    hook(side, bag, UC_HOOK_CODE, enter, side.m.linear(entry))


def at_return(side, bag, entry, callback):
    seg, _ = side.m.symbols[entry.upper()]
    hook(side, bag, UC_HOOK_CODE, callback, side.m.sentinel(LOAD + seg))


def port_probe(side, bag, value):
    start = side.m.linear('ProbeVgaDac')
    code = bytes(side.m.u.mem_read(start, 32))
    ins_at = None
    for ins in MD.disasm(code, start):
        if ins.mnemonic == 'in' and ins.op_str == 'al, dx':
            ins_at = ins.address
            break
    check(ins_at is not None, 'ProbeVgaDac contains its documented DAC status read')
    def read_port(u, address, size, _):
        ax = u.reg_read(REG['AX'])
        u.reg_write(REG['AX'], (ax & 0xFF00) | value)
        u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + size) & 0xFFFF)
    hook(side, bag, UC_HOOK_CODE, read_port, ins_at)


def dac_case(pair, value, initial):
    bag, flags_out = [], []
    for side in (pair.a, pair.b):
        seed_at_entry(side, bag, 'EnableFileFlagsIfVgaDac', 'PerFileFlagsEnabled', initial, 1)
        port_probe(side, bag, value)
        captured = []
        flags_out.append(captured)
        at_return(side, bag, 'EnableFileFlagsIfVgaDac',
                  lambda u, address, size, _, side=side, captured=captured:
                      captured.append(side.m.u.mem_read(side.m.linear('PerFileFlagsEnabled'), 1)[0]))
    def done(_m, _regs):
        expected = 1 if value == 1 else initial
        for side, result in zip((pair.a, pair.b), flags_out):
            check(side.m.u.reg_read(REG['AX']) == (0xA500 | value), 'DAC probe returns its AL byte')
            check(side.m.u.reg_read(REG['DX']) == 0x03C8, 'DAC probe leaves DX at the index port')
            check(result == [expected],
                  'file-flag policy sets only on DAC response 1 and never clears')
    try:
        yield Case('EnableFileFlagsIfVgaDac', {'AX': 0xA50F, 'BX': 0x1234, 'CX': 0x5678,
                   'DX': 0x9ABC, 'SI': 0x1357, 'DI': 0x2468, 'BP': 0x369A, 'ES': 0xB800},
                   preserve=('BX', 'CX', 'SI', 'DI', 'BP', 'ES', 'SP', 'DS', 'SS'),
                   flags=STATUS_FLAGS, expect=done, name=f'probe={value} initial={initial}')
    finally:
        cleanup(pair, bag)


def sound_kind(side, ptr):
    for name in ('SoundModuleNameTandy', 'SoundModuleNameRoland', 'SoundModuleNameAdlib'):
        if ptr == side.m.offset(name): return name.rsplit('Name', 1)[1].lower()
    return f'offset-{ptr:04X}'


def install_sound_services(side, bag, outcomes, trace):
    def load_file(u, address, size, _):
        name_ptr = u.reg_read(REG['DX'])
        kind = sound_kind(side, name_ptr)
        trace.append(('file', kind))
        side.m.set_word(side.m.offset('FileNamePtr'), name_ptr)
        side.m.set_word(side.m.offset('SoundModuleNamePtr'), name_ptr)
        succeeded = outcomes.get((kind, 'file'), True)
        ax = u.reg_read(REG['AX'])
        u.reg_write(REG['AX'], (ax & 0xFF00) | (1 if succeeded else 0))
        flags = u.reg_read(REG['FLAGS']) & ~(FLAG['CF'] | FLAG['ZF'] | FLAG['PF'] | FLAG['SF'] | FLAG['OF'])
        if not succeeded: flags |= FLAG['ZF'] | FLAG['PF']
        u.reg_write(REG['FLAGS'], flags)
        return_service(side)
    hook(side, bag, UC_HOOK_CODE, load_file, side.m.linear('LoadSoundModuleFile'))

    def initialize(u, address, size, _):
        name_ptr = side.m.word(side.m.offset('SoundModuleNamePtr'))
        kind = sound_kind(side, name_ptr)
        trace.append(('init', kind))
        succeeded = outcomes.get((kind, 'init'), True)
        ax = u.reg_read(REG['AX'])
        u.reg_write(REG['AX'], (ax & 0xFF00) | (1 if succeeded else 0))
        return_service(side, far=True)
    hook(side, bag, UC_HOOK_CODE, initialize, side.m.linear('SoundModuleInitEntry'))


def capture_module_request(side, bag, entry, outputs):
    at_return(side, bag, entry, lambda u, address, size, _, side=side, outputs=outputs:
              outputs.append(struct.unpack('<H', bytes(u.mem_read(
                  side.m.linear('SoundModuleSlot') + K.MODULE_MUSIC_REQUEST, 2)))[0]))


def load_case(pair, selection, outcomes, expected, loaded, last_name, enabled=1, current=0,
              initial_name=0x4321):
    bag, traces, requests = [], [], []
    for side in (pair.a, pair.b):
        trace = []; traces.append(trace)
        install_sound_services(side, bag, outcomes, trace)
        request = []; requests.append(request)
        capture_module_request(side, bag, 'LoadSoundModule', request)
    w = (World(pair, random.Random(0x10AD))
         .byte('SoundModuleSelect', selection)
         .byte('SoundModuleLoaded', 0xA5)
         .byte('ModuleSoundEnabled', enabled)
         .byte('ModuleSoundRequest', 0x77)
         .word('SoundModuleNamePtr', initial_name)
         .put(far('SoundModuleSlot', K.MODULE_MUSIC_REQUEST), bytes((0x55, current))))
    def done(_m, _regs):
        check(traces[0] == traces[1], 'sound file/init service order matches')
        check(traces[0] == expected, 'sound selection and fallback policy')
        final_loaded = 1 if loaded else 0
        final_name_offset = {'tandy': pair.sym('SoundModuleNameTandy'),
                             'roland': pair.sym('SoundModuleNameRoland'),
                             'adlib': pair.sym('SoundModuleNameAdlib')}.get(last_name, initial_name)
        for side, captured in zip((pair.a, pair.b), requests):
            check(side.m.read(pair.sym('SoundModuleLoaded'), 1)[0] == final_loaded, 'loaded latch')
            check(side.m.word(pair.sym('SoundModuleNamePtr')) == final_name_offset, 'last filename pointer')
            expected_request = 2 if loaded else 0x77
            check(side.m.read(pair.sym('ModuleSoundRequest'), 1)[0] == expected_request,
                  'music request latch changes only after successful initialization')
            want_request = (2 if enabled and loaded and current != 2 else ((current << 8) | 0x55))
            check(captured == [want_request], 'module request word follows enabled/current policy')
    try:
        yield Case('LoadSoundModule', {'AX': 0xA55A, 'BX': 0x1234, 'CX': 0x5678,
                   'DX': 0x9ABC, 'SI': 0x1357, 'DI': 0x2468, 'BP': 0x369A, 'ES': 0xB800},
                   w.writes(), preserve=('SP', 'DS', 'SS'), expect=done,
                   name=f'select={selection:02X} outcomes={outcomes}')
    finally:
        cleanup(pair, bag)


def install_pause_services(side, bag, trace):
    def wait_tick(u, address, size, _):
        trace.append(('timer-wait',))
        return_service(side)
    hook(side, bag, UC_HOOK_CODE, wait_tick, side.m.linear('WaitTimerInterruptIfModule'))

    def bios(u, address, size, _):
        if bytes(u.mem_read(address, 2)) != b'\xCD\x10': return
        ax = u.reg_read(REG['AX'])
        if ax >> 8 == 2:
            trace.append(('int10', ax, u.reg_read(REG['BX']) & 0xFF00,
                          u.reg_read(REG['DX'])))
        else:
            trace.append(('int10', ax))
        u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
    hook(side, bag, UC_HOOK_CODE, bios, *side.image)

    key_base = side.m.data_frame * 16 + side.m.offset('KeyDownTable')
    f9 = key_base + K.SCAN_F9
    last_make = side.m.data_frame * 16 + side.m.offset('KeyLastMakeCode')
    state = {'stage': 0, 'first_reads': 0, 'second_reads': 0, 'make_reads': 0, 'key_trace': []}
    def keys(u, access, address, size, value, _):
        if address == f9:
            if state['stage'] == 0:
                state['first_reads'] += 1
                state['key_trace'].append(('f9', 1))
                if state['first_reads'] == 3:
                    side.m.write(side.m.offset('KeyDownTable') + K.SCAN_F9, b'\0')
                    state['stage'] = 1
            elif state['stage'] == 2:
                state['second_reads'] += 1
                state['key_trace'].append(('f9', 2))
                if state['second_reads'] == 3:
                    side.m.write(side.m.offset('KeyDownTable') + K.SCAN_F9, b'\0')
                    state['stage'] = 3
        elif address == last_make and state['stage'] == 1:
            state['make_reads'] += 1
            current = side.m.u.mem_read(last_make, 1)[0]
            state['key_trace'].append(('make', current))
            if state['make_reads'] == 1 and current != 0:
                # Let a mutant with a missing clear terminate so its state difference is
                # reported as an ordinary differential failure rather than a hung case.
                side.m.write(side.m.offset('KeyDownTable') + K.SCAN_F9, bytes((K.KEY_STATE_DOWN,)))
                state['stage'] = 2
            elif state['make_reads'] == 2:
                side.m.write(side.m.offset('KeyLastMakeCode'), bytes((K.SCAN_SPACE,)))
                side.m.write(side.m.offset('KeyDownTable') + K.SCAN_F9, bytes((K.KEY_STATE_DOWN,)))
                state['stage'] = 2
    hook(side, bag, UC_HOOK_MEM_READ, keys, key_base, key_base + K.KEY_DOWN_COUNT - 1)
    hook(side, bag, UC_HOOK_MEM_READ, keys, last_make)
    return state


def boss_case(pair):
    bag, traces, key_states, requests = [], [], [], []
    for side in (pair.a, pair.b):
        trace = []; traces.append(trace)
        key_states.append(install_pause_services(side, bag, trace))
        request = []; requests.append(request)
        capture_module_request(side, bag, 'ShowBossKeyScreen', request)
    w = (World(pair, random.Random(0xB055))
         .word('SoundModuleLoaded', 1)
         .byte('ModuleSoundEnabled', 1)
         .byte('ModuleSoundRequest', K.MUSIC_LEVEL_END)
         .put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
         .byte('KeyLastMakeCode', 0x55)
         .put(far('SoundModuleSlot', K.MODULE_MUSIC_REQUEST), bytes((0x66, 0))))
    key_down = bytearray(K.KEY_DOWN_COUNT); key_down[K.SCAN_F9] = K.KEY_STATE_DOWN
    w.put('KeyDownTable', key_down)
    def done(_m, _regs):
        check(traces[0] == traces[1], f'boss-key BIOS and timer service order matches: {traces}')
        check([x[0] for x in traces[0]] == ['timer-wait'] * 5 + ['int10'] * 3,
              'boss-key stops music, sets text mode, renders cursor, restores mode')
        bios = [event for event in traces[0] if event[0] == 'int10']
        check(bios[0] == ('int10', 3) and bios[1][1] >> 8 == 2
              and bios[1][2] == 0 and bios[1][3] == 0x1747 and len(bios[2]) == 2,
              'boss-key selects text mode, places the BIOS cursor, and restores its mode')
        for state in key_states:
            check(state['stage'] == 3 and state['first_reads'] == 3 and state['second_reads'] == 3,
                  'boss-key waits through both F9 releases')
            check(state['make_reads'] == 2, 'boss-key clears and then waits for KeyLastMakeCode')
        for side, captured in zip((pair.a, pair.b), requests):
            check(side.m.read(pair.sym('KeyLastMakeCode'), 1)[0] == K.SCAN_SPACE,
                  'captured key make code survives the pause')
            check(side.m.read(pair.sym('ModuleSoundRequest'), 1)[0] == K.MUSIC_LEVEL_END,
                  'pause re-requests the prior tune')
            check(captured == [K.MUSIC_LEVEL_END],
                  'pause resumes music after video mode restoration')
    try:
        yield Case('ShowBossKeyScreen', {'AX': 0x1234, 'BX': 0x5678, 'CX': 0x1357,
                   'DX': 0x9ABC, 'SI': 0x2468, 'DI': 0x369A, 'BP': 0x7A12, 'ES': 0xB800},
                   w.writes(), preserve=FREE, outputs=('BP', 'ES'), expect=done,
                   name='F9 release, make, release and module resume')
    finally:
        cleanup(pair, bag)


def checksum_value(data):
    ax = 0x1234
    for value in data:
        ax = (ax + value) & 0xFFFF
        al = ax & 0xFF
        ah = ((ax >> 8) + al) & 0xFF
        ax = (ah << 8) | al
    return ax


def checksum_fixture(length, trailer_ok=True):
    body_size = length - 2
    body = bytearray((i * 37 + 11) & 0xFF for i in range(body_size))
    value = checksum_value(body)
    trailer = value if trailer_ok else value ^ 0x0100
    return bytes(body) + struct.pack('<H', trailer)


def dos_path(side, segment, offset, length):
    at = segment * 16 + offset
    return bytes(side.m.u.mem_read(at, length))


def install_checksum_io(side, bag, stream, trace, entry_label, skip, bios_keys=()):
    entry_sp = [None]
    target_seg = LOAD + side.m.symbols[entry_label.upper()][0]
    seed_at_entry(side, bag, entry_label, 'IntegritySkip', skip)

    def entry(u, address, size, _): entry_sp[0] = u.reg_read(REG['SP'])
    hook(side, bag, UC_HOOK_CODE, entry, side.m.linear(entry_label))
    cursor = {'file': 0, 'keys': list(bios_keys), 'exit': None, 'windows': []}

    def interrupts(u, address, size, _):
        opcode = bytes(u.mem_read(address, 2))
        if opcode == b'\xCD\x10':
            ax = u.reg_read(REG['AX']); bx = u.reg_read(REG['BX']); dx = u.reg_read(REG['DX'])
            if ax >> 8 == 2:
                trace.append(('int10', ax, bx & 0xFF00, dx))
            else:
                trace.append(('int10', ax))
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
            return
        if opcode == b'\xCD\x16':
            ax = u.reg_read(REG['AX']); function = ax >> 8
            if function == 1:
                available = len(cursor['keys']) != 0
                trace.append(('key-status', available))
                flags = u.reg_read(REG['FLAGS']) & ~FLAG['ZF']
                if not available: flags |= FLAG['ZF']
                u.reg_write(REG['FLAGS'], flags)
            else:
                value = cursor['keys'].pop(0) if cursor['keys'] else 0x1C0D
                trace.append(('key-read', value))
                u.reg_write(REG['AX'], value)
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
            return
        if opcode != b'\xCD\x21': return

        ax = u.reg_read(REG['AX']); ah = ax >> 8; al = ax & 0xFF
        if ah == K.DOS_ALLOCATE_MEMORY:
            trace.append(('allocate', u.reg_read(REG['BX']), 'state'))
            return
        if ah == K.DOS_OPEN_FILE:
            name_ptr = u.reg_read(REG['DX'])
            check(u.reg_read(REG['DS']) == side.m.data_frame, 'checksum open uses the state segment')
            check(al == 0, 'checksum opens read-only')
            trace.append(('open', name_ptr, dos_path(side, u.reg_read(REG['DS']), name_ptr, 14)))
            u.reg_write(REG['AX'], 0x2345)
            u.reg_write(REG['FLAGS'], u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
        elif ah == K.DOS_READ_FILE:
            ds = u.reg_read(REG['DS']); dx = u.reg_read(REG['DX']); count = u.reg_read(REG['CX'])
            check(u.reg_read(REG['BX']) == 0x2345, 'checksum read uses the opened handle')
            check(dx == 0x42 and count == 0x1400, 'checksum read uses the exact chunk window')
            segment = side.m.peek('IntegrityBufferSegment')
            check(ds == segment, 'checksum reads into the allocated buffer segment')
            n = min(count, max(0, len(stream) - cursor['file']))
            part = stream[cursor['file']:cursor['file'] + n]
            trace.append(('read', dx, count, n, cursor['file']))
            if n:
                at = ds * 16 + dx
                side.undo.append((at, bytes(u.mem_read(at, n))))
                u.mem_write(at, part)
                cursor['file'] += n
            cursor['windows'].append(('read', bytes(u.mem_read(ds * 16 + 0x1440, 2))))
            u.reg_write(REG['AX'], n)
            u.reg_write(REG['FLAGS'], u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
        elif ah == K.DOS_CLOSE_FILE:
            check(u.reg_read(REG['BX']) == 0x2345, 'checksum closes the opened handle')
            cursor['windows'].append(('close', bytes(u.mem_read(
                side.m.peek('IntegrityBufferSegment') * 16 + 0x1440, 2))))
            trace.append(('close', 'state'))
            u.reg_write(REG['AX'], 0)
            u.reg_write(REG['FLAGS'], u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
        elif ah == K.DOS_FREE_MEMORY:
            check(u.reg_read(REG['DS']) == side.m.peek('IntegrityBufferSegment'),
                  'checksum free retains the original buffer DS context')
            cursor['windows'].append(('free', bytes(u.mem_read(
                side.m.peek('IntegrityBufferSegment') * 16 + 0x1440, 2))))
            trace.append(('free', 'buffer', 'buffer'))
            return
        elif ah == K.DOS_PRINT_STRING:
            text = bytearray(); ds = u.reg_read(REG['DS']); dx = u.reg_read(REG['DX'])
            for i in range(300):
                value = u.mem_read(ds * 16 + ((dx + i) & 0xFFFF), 1)[0]
                if value == ord('$'): break
                text.append(value)
            else: check(False, 'DOS print string has a terminator')
            trace.append(('print', bytes(text)))
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
        elif ah == K.DOS_CHAR_INPUT_NO_ECHO:
            trace.append(('char-input',))
            u.reg_write(REG['AX'], (ax & 0xFF00) | 0x20)
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
        elif ah == 0x4C:
            cursor['exit'] = al
            trace.append(('exit', al))
            check(entry_sp[0] is not None, 'checksum routine entry was observed before exit')
            u.reg_write(REG['CS'], target_seg)
            u.reg_write(REG['IP'], 0xFFFE)
            u.reg_write(REG['SP'], (entry_sp[0] + 2) & 0xFFFF)
        else:
            check(False, f'unexpected DOS service {ah:02X}')
    hook(side, bag, UC_HOOK_CODE, interrupts, *side.image)
    return cursor


def checksum_case(pair, name, stream, skip=0, fatal=False, file_size=None):
    bag, traces, cursors, final_states = [], [], [], []
    for side in (pair.a, pair.b):
        trace = []; traces.append(trace)
        cursors.append(install_checksum_io(side, bag, stream, trace, 'ChecksumFileOrAbort', skip,
                                           bios_keys=(0x1C0D,) if fatal else ()))
        captured = []; final_states.append(captured)
        at_return(side, bag, 'ChecksumFileOrAbort',
                  lambda u, address, size, _, side=side, captured=captured:
                      captured.append((side.m.peek('IntegritySum'),
                                       side.m.peek('IntegrityBufferSegment'),
                                       struct.unpack('<H', bytes(u.mem_read(
                                           side.m.peek('IntegrityBufferSegment') * 16 + 0x1440, 2)))[0])))
    filename = 'IntegrityFileExe' if name == 'exe' else 'IntegrityFileData'
    w = World(pair, random.Random(0xC5EC))
    for label in ('Codeword', 'NonAsciiCodeword', 'OldNonAsciiCodeword', 'Password'):
        w.put(label, bytes((i * 19 + 7) & 0xFF for i in range(16)))
    initial_regs = {'AX': 0xA55A, 'BX': 0x1234, 'CX': 0x5678, 'DX': pair.sym(filename),
                    'SI': 0x1442, 'DI': 0x2468, 'BP': 0x369A, 'ES': 0xB800}
    def done(_m, _regs):
        check(traces[0] == traces[1], f'checksum DOS/BIOS operation sequence matches: {traces}')
        for side, cursor, captured in zip((pair.a, pair.b), cursors, final_states):
            check(captured and captured[0][0] == checksum_value(stream[:-2]),
                  'checksum running algorithm and trailer subtraction')
            check(captured[0][2] == struct.unpack('<H', stream[-2:])[0],
                  'checksum compares the trailer at the last read-window position')
            if fatal:
                check(cursor['exit'] == 1, 'corruption takes the nonlocal DOS exit with code 1')
                names = [event[0] for event in traces[0]]
                check(names[-2:] == ['char-input', 'exit'],
                      'corruption prompt drains keys, reads a key, and exits')
            else:
                check(cursor['exit'] is None, 'valid or skipped checksum returns to its caller')
            check(captured[0][1] != 0, 'checksum buffer segment is retained in CS state')
        if name == 'exe' and skip != 1 and not fatal:
            source = stream[-66:-2]
            expected = bytes(value ^ 0xAA for value in source)
            for side in (pair.a, pair.b):
                for i, label in enumerate(('Codeword', 'NonAsciiCodeword', 'OldNonAsciiCodeword', 'Password')):
                    check(side.m.read(pair.sym(label), 16) == expected[i * 16:(i + 1) * 16],
                          'EXE codeword bytes are decoded into the original DS arrays')
    try:
        yield Case('ChecksumFileOrAbort', initial_regs, w.writes(),
                   preserve=FREE if fatal else ALL_REGS,
                   flags=() if fatal else STATUS_FLAGS, expect=done,
                   name=f'{name} bytes={len(stream)} skip={skip} fatal={fatal}')
    finally:
        cleanup(pair, bag)


def cases(rng, scale, pair):
    for value, initial in ((0, 0), (1, 0), (2, 0), (0, 1), (2, 1)):
        yield from dac_case(pair, value, initial)

    yield from load_case(pair, K.SOUND_SELECT_ANY,
        {('tandy', 'file'): False, ('roland', 'file'): True, ('roland', 'init'): False,
         ('adlib', 'file'): True, ('adlib', 'init'): True},
        [('file', 'tandy'), ('file', 'roland'), ('init', 'roland'),
         ('file', 'adlib'), ('init', 'adlib')], True, 'adlib')
    yield from load_case(pair, ord('T'), {('tandy', 'file'): True, ('tandy', 'init'): False},
        [('file', 'tandy'), ('init', 'tandy')], False, 'tandy')
    yield from load_case(pair, K.SOUND_SELECT_ANY,
        {('tandy', 'file'): False, ('roland', 'file'): False, ('adlib', 'file'): False},
        [('file', 'tandy'), ('file', 'roland'), ('file', 'adlib')], False, 'adlib')
    yield from load_case(pair, ord('x'), {}, [], False, None)
    yield from load_case(pair, K.SOUND_SELECT_ADLIB,
        {('adlib', 'file'): True, ('adlib', 'init'): True},
        [('file', 'adlib'), ('init', 'adlib')], True, 'adlib', enabled=0)

    yield from boss_case(pair)

    for name, length in (('exe', 0x1400), ('data', 0x2800)):
        stream = checksum_fixture(length)
        yield from checksum_case(pair, name, stream, file_size=length)
    yield from checksum_case(pair, 'data', checksum_fixture(0x1400, trailer_ok=False), fatal=True)
    yield from checksum_case(pair, 'exe', checksum_fixture(0x1400, trailer_ok=False), skip=1)


MUTANTS = [
    ('platform_policy.c', 'if (probe_result == 1) PerFileFlagsEnabled = 1;',
     'if (probe_result != 0) PerFileFlagsEnabled = 1;'),
    ('platform_policy.c', 'if (loaded == 0)\n            loaded = platform_policy_try_sound_module((word)SoundModuleNameAdlib);',
     'if (loaded != 0)\n            loaded = platform_policy_try_sound_module((word)SoundModuleNameAdlib);'),
    ('platform_policy.c', '*last_make = 0;', '*last_make = 1;'),
    ('platform_policy.c', 'word updated = (word)(running + value);',
     'word updated = (word)(running + value + 1);'),
]
