"""Bounded differential coverage for startup/shutdown coordinators.

The only extra interrupt behavior is a minimal DOS-file
stub for saving hiscore.dat, BIOS INT 10h no-op/trace, AH=09 output capture, and stopping
at DOS 4C00h. Startup is cut at the first session entry; shutdown is cut at termination.
"""
from difftest import Case
from world import World, K
from emu import REG, LOAD, FLAG, WORD_REGS
from options import hook, cleanup, return_service, check
from unicorn import UC_HOOK_CODE
import random
import struct

FREE = ('SP', 'DS', 'SS')
STARTUP_ORDER = [
    'EnableFileFlagsIfVgaDac', 'VerifyStartupChecksums', 'InstallTimerVector08',
    'InstallKeyboardVector09', 'SetupResourceArchive', 'MeasureRetracePolarity',
    'SetBestFitAllocStrategy', 'DetectFloppyDrives', 'DetectEms', 'LoadSoundModule',
    'AllocateBuffers', 'BuildRowTables', 'InitStars', 'SetHiscoreRankColor',
    'LoadCommonGraphics', 'LoadGraphicsRecordImages', 'CollapseScreenAndClear',
    'StretchInWindowImage', 'WaitVerticalRetrace', 'ResetPageAndClearScreen',
]


def safe_machine_call(machine, events, name, regs=None, flags=0x0202, sp=None, limit=5000000):
    """Machine.call with bounded BIOS/DOS services for startup and termination only."""
    seg, off = machine.symbols[name.upper()]
    cs = LOAD + seg
    sentinel = machine.sentinel(cs)
    entry_sp = machine.stack_top - 0x40 if sp is None else sp
    entry_sp = (entry_sp - 2) & 0xFFFF
    machine.set_word(entry_sp, sentinel - cs * 16)
    values = dict(AX=0, BX=0, CX=0, DX=0, SI=0, DI=0, BP=0, ES=machine.data_frame)
    values.update(regs or {})
    for register, value in values.items():
        machine.u.reg_write(REG[register], value & 0xFFFF)
    for register in ('DS', 'SS'):
        machine.u.reg_write(REG[register], machine.data_frame)
    machine.u.reg_write(REG['CS'], cs)
    machine.u.reg_write(REG['IP'], off)
    machine.u.reg_write(REG['SP'], entry_sp)
    machine.u.reg_write(REG['FLAGS'], flags)
    machine.fault = None
    machine.ports = []

    def returned(u, address, size, _):
        if u.reg_read(REG['CS']) == cs and u.reg_read(REG['SP']) == entry_sp + 2:
            u.emu_stop()
    done = machine.u.hook_add(UC_HOOK_CODE, returned, None, sentinel, sentinel)

    try:
        while True:
            begin = machine.u.reg_read(REG['CS']) * 16 + machine.u.reg_read(REG['IP'])
            machine.u.emu_start(begin, 0, count=limit)
            fault = machine.fault
            if not fault:
                break
            machine.fault = None
            parts = fault.split()
            interrupt = int(parts[1][:-1], 16)
            ax = machine.u.reg_read(REG['AX'])
            if interrupt == 0x10:
                if ax >> 8 == 2:
                    bx = machine.u.reg_read(REG['BX'])
                    dx = machine.u.reg_read(REG['DX'])
                    cursor = (ax >> 8, bx >> 8, dx >> 8, dx & 255)
                    events['modes'].append(cursor)
                    events['trace'].append(('BIOSVideoCursor', cursor))
                else:
                    events['modes'].append(ax)
                    events['trace'].append(('BIOSVideo', ax))
                continue
            if interrupt != 0x21:
                raise AssertionError(f'{name}: unexpected {fault}')

            function = ax >> 8
            if function == 0x09:
                ds = machine.u.reg_read(REG['DS']); dx = machine.u.reg_read(REG['DX'])
                string = bytearray()
                while len(string) < 0x200:
                    byte = machine.u.mem_read(ds * 16 + ((dx + len(string)) & 0xFFFF), 1)[0]
                    if byte == 0x24: break
                    string.append(byte)
                check(len(string) < 0x200, 'DOS print string has a terminator')
                events['trace'].append(('DOS', function))
                events['dos'].append(('print', bytes(string) + b'$'))
                continue
            if function == 0x3C:
                ds = machine.u.reg_read(REG['DS']); dx = machine.u.reg_read(REG['DX'])
                path = bytearray()
                while len(path) < 0x100:
                    byte = machine.u.mem_read(ds * 16 + ((dx + len(path)) & 0xFFFF), 1)[0]
                    if byte == 0: break
                    path.append(byte)
                events['dos'].append(('create', bytes(path)))
                events['trace'].append(('DOS', function))
                machine.u.reg_write(REG['AX'], 0x1234)
                machine.u.reg_write(REG['FLAGS'], machine.u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
                continue
            if function == 0x40:
                ds = machine.u.reg_read(REG['DS']); dx = machine.u.reg_read(REG['DX'])
                count = machine.u.reg_read(REG['CX'])
                data = bytes(machine.u.mem_read(ds * 16 + dx, count))
                events['dos'].append(('write', count, data))
                events['trace'].append(('DOS', function))
                machine.u.reg_write(REG['AX'], count)
                machine.u.reg_write(REG['FLAGS'], machine.u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
                continue
            if function == 0x3E:
                events['dos'].append(('close', machine.u.reg_read(REG['BX'])))
                events['trace'].append(('DOS', function))
                machine.u.reg_write(REG['AX'], 0)
                machine.u.reg_write(REG['FLAGS'], machine.u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
                continue
            if function == 0x4C:
                events['dos'].append(('exit', ax & 0xFF))
                events['trace'].append(('DOS', function))
                machine.u.reg_write(REG['CS'], cs)
                machine.u.reg_write(REG['IP'], sentinel - cs * 16)
                machine.u.reg_write(REG['SP'], entry_sp + 2)
                break
            raise AssertionError(f'{name}: unsupported {fault}')

        ip = machine.u.reg_read(REG['CS']) * 16 + machine.u.reg_read(REG['IP'])
        if ip != sentinel:
            where = (machine.u.reg_read(REG['CS']), machine.u.reg_read(REG['IP']),
                     machine.u.reg_read(REG['SP']))
            raise AssertionError(f'{name}: did not reach the bounded sentinel ({ip:05X}, '
                                 f'CS:IP:SP={where!r}, trace-tail={events["trace"][-8:]!r})')
        if machine.fault:
            raise AssertionError(f'{name}: {machine.fault}')
        return {r: machine.u.reg_read(REG[r]) for r in WORD_REGS + ('SP', 'DS', 'SS', 'FLAGS')}
    finally:
        machine.u.hook_del(done)


def service_hook(side, bag, target, action, far=False):
    def enter(u, address, size, _):
        action(u)
        return_service(side, far)
    hook(side, bag, UC_HOOK_CODE, enter, side.m.linear(target))
    side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def install_bounded_calls(pair, observed):
    original = []
    for side, events in zip((pair.a, pair.b), observed):
        original.append((side, side.m.call))
        def bounded_call(name, regs=None, flags=0x0202, sp=None, limit=5000000,
                         side=side, events=events):
            return safe_machine_call(side.m, events, name, regs, flags, sp, limit)
        side.m.call = bounded_call
    return original


def restore_machine_calls(original):
    for side, call in original:
        side.m.call = call


def startup_case(pair):
    bag, observed = [], []
    w = World(pair, random.Random(12)).word('TextInGraphics', 0)
    for side in (pair.a, pair.b):
        obs = {'trace': [], 'modes': [], 'ds_after_timer': None, 'loader': [], 'session': []}
        observed.append(obs)

        def record(name, mutate=True, bad_ds=False, native=False):
            def action(u, obs=obs, side=side):
                if native:
                    at = u.reg_read(REG['SI'])
                    bp, es = struct.unpack('<HH', side.m.read(at, 4))
                else:
                    at = None
                    bp = u.reg_read(REG['BP']); es = u.reg_read(REG['ES'])
                ds = u.reg_read(REG['DS'])
                obs['trace'].append((name, bp, es,
                                     'state' if ds == side.m.data_frame else ds))
                if bad_ds:
                    u.reg_write(REG['DS'], 0x1234)
                elif mutate:
                    next_bp, next_es = (bp + 3) & 0xFFFF, (es + 5) & 0xFFFF
                    if at is None:
                        u.reg_write(REG['BP'], next_bp)
                        u.reg_write(REG['ES'], next_es)
                    else:
                        side.m.write(at, struct.pack('<HH', next_bp, next_es))
            return action

        for name in STARTUP_ORDER:
            if name == 'ResetPageAndClearScreen':
                service_hook(side, bag, name, record(name))
                continue
            if name == 'LoadGraphicsRecordImages':
                continue
            if name == 'CollapseScreenAndClear':
                target = name if side is pair.a else 'SCREEN_TRANSITION_AND_CLEAR'
                def collapse(u, obs=obs, side=side):
                    if side is pair.a:
                        bp, es = u.reg_read(REG['BP']), u.reg_read(REG['ES'])
                        at = None
                    else:
                        at = u.reg_read(REG['SI'])
                        bp, es = struct.unpack('<HH', side.m.read(at, 4))
                    ds = u.reg_read(REG['DS'])
                    obs['trace'].append(('CollapseScreenAndClear', bp, es,
                                         'state' if ds == side.m.data_frame else ds))
                    updated = struct.pack('<HH', (bp + 3) & 0xFFFF,
                                          (es + 5) & 0xFFFF)
                    if at is None:
                        u.reg_write(REG['BP'], (bp + 3) & 0xFFFF)
                        u.reg_write(REG['ES'], (es + 5) & 0xFFFF)
                    else:
                        side.m.write(at, updated)
                service_hook(side, bag, target, collapse)
                continue
            if name == 'StretchInWindowImage':
                target = name if side is pair.a else 'SCREEN_ANIMATION_STRETCH_WINDOW'
                service_hook(side, bag, target,
                             record(name, native=side is pair.b))
                continue
            if name in ('InitStars', 'SetHiscoreRankColor'):
                label = name if side is pair.a else (
                    'INIT_STARS' if name == 'InitStars' else 'DISPLAY_SET_HISCORE_RANK_COLOR')
                def observe_native(u, address, size, _, obs=obs, name=name):
                    obs['trace'].append((name,))
                hook(side, bag, UC_HOOK_CODE, observe_native, side.m.linear(label))
                side.m.u.ctl_remove_cache(side.image[0], side.image[1])
                continue
            if name == 'SetBestFitAllocStrategy':
                service_hook(side, bag, name, record(name), far=True)
            elif name == 'InstallTimerVector08':
                service_hook(side, bag, name, record(name, bad_ds=True))
            elif name == 'LoadCommonGraphics':
                if side is pair.a:
                    service_hook(side, bag, name, record(name, mutate=False))
                else:
                    def common(u, obs=obs, side=side):
                        at = u.reg_read(REG['SI'])
                        bp, es = struct.unpack('<HH', side.m.read(at, 4))
                        obs['trace'].append(('LoadCommonGraphics', bp, es, 'state'))
                    service_hook(side, bag, 'LOAD_COMMON_GRAPHICS', common)
            else:
                service_hook(side, bag, name, record(name))

        def loader(u, obs=obs, side=side):
            if side is pair.a:
                at = None
                bp = u.reg_read(REG['BP']); es = u.reg_read(REG['ES'])
                ds = u.reg_read(REG['DS'])
            else:
                at = u.reg_read(REG['SI'])
                bp, es = struct.unpack('<HH', side.m.read(at, 4))
                ds = u.reg_read(REG['DS'])
            obs['trace'].append(('LoadGraphicsRecordImages', bp, es,
                                 'state' if ds == side.m.data_frame else ds))
            slot = side.m.peek('LoadImageSlot')
            if slot == side.m.symbols['PLAQUEIMAGEOFFSET'][1]: slot = 'PlaqueImageOffset'
            obs['loader'].append((side.m.peek('LoadNamePtr'), side.m.peek('LoadDestSegment'), slot))
            if at is None:
                u.reg_write(REG['BP'], (bp + 3) & 0xFFFF)
                u.reg_write(REG['ES'], (es + 5) & 0xFFFF)
            else:
                side.m.write(at, struct.pack('<HH', (bp + 3) & 0xFFFF, (es + 5) & 0xFFFF))
        loader_label = 'LoadGraphicsRecordImages' if side is pair.a else 'LOAD_GRAPHICS_RECORD_IMAGES'
        service_hook(side, bag, loader_label, loader)

        # Attract control is C-owned on both sides. Skip the title/demo body at the
        # matching entry; its BP/ES values are deliberately not treated as outputs.
        attract = 'RunAttractSequence' if side is pair.a else 'RUN_ATTRACT_SEQUENCE'
        def attract_entry(u, obs=obs):
            obs['trace'].append(('RunAttractSequence',))
        service_hook(side, bag, attract, attract_entry)

        # Startup's final path reaches legacy StartNewGame in the oracle and directly
        # calls the native C session in the proposal. Stop both at that boundary by redirecting
        # CS:IP:SP to the Machine.call return sentinel, without running its body.
        session = 'StartNewGame' if side is pair.a else 'RUN_GAME_SESSION'
        call_cs = LOAD + side.m.symbols['STARTUPAFTEROVERRIDES'][0]
        return_sp = side.m.stack_top - 0x40
        sentinel_ip = 0xFFFE
        def stop_session(u, address, size, _, obs=obs, side=side,
                         call_cs=call_cs, return_sp=return_sp):
            if side is pair.a:
                game_bp = u.reg_read(REG['BP'])
                phase = 0
            else:
                game_bp = u.reg_read(REG['DI'])
                phase = u.reg_read(REG['SI'])
            obs['session'].append((u.reg_read(REG['BP']), u.reg_read(REG['ES']), game_bp, phase))
            u.reg_write(REG['CS'], call_cs)
            u.reg_write(REG['IP'], sentinel_ip)
            u.reg_write(REG['SP'], return_sp)
            u.emu_stop()
        hook(side, bag, UC_HOOK_CODE, stop_session, side.m.linear(session))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    case = Case('StartupAfterOverrides',
                {'AX': 0x1357, 'BP': 0x7214, 'ES': 0xB800}, w.writes(), FREE,
                name='stop before first session body')
    case._system_hooks = (pair, bag)
    case._system_observed = observed
    original_calls = install_bounded_calls(pair, observed)
    try:
        yield case
        check(observed[0]['trace'] == observed[1]['trace'], 'startup service/BP/ES/DS trace matches')
        check([x[0] for x in observed[0]['trace']].count('WaitVerticalRetrace') == 250,
              'startup waits exactly 250 retraces')
        check(observed[0]['loader'] == observed[1]['loader'],
              f'backdrop loader mailboxes match: {observed[0]["loader"]!r} vs {observed[1]["loader"]!r}')
        expected_load = (pair.sym('File_WINDOW_BIC'),
                         (pair.a.m.peek('WorkspaceSegment') + K.WIDE_PAGE_BYTES // 16 + 1) & 0xFFFF,
                         'PlaqueImageOffset')
        check(observed[0]['loader'] == [expected_load], 'WINDOW backdrop uses the original loader mailbox values')
        check(len(observed[0]['session']) == len(observed[1]['session']) == 1,
              'startup reaches one new-game entry')
        check(observed[1]['session'][0][3] == 0, 'native C session starts with phase zero')
        names = [row[0] for row in observed[0]['trace'] if row[0] != 'BIOSVideo']
        expected_names = [name for name in STARTUP_ORDER if name != 'WaitVerticalRetrace']
        expected_names += ['RunAttractSequence']
        actual_names = [name for name in names if name != 'WaitVerticalRetrace']
        check(actual_names == expected_names, 'startup follows the complete fixed service order')
        check(names.count('WaitVerticalRetrace') == 250, 'startup includes exactly 250 waits in order')
        check(observed[0]['trace'][3][3] == 'state',
              'timer-vector installation restores DS before the next service')
        check(pair.a.m.word(pair.sym('TextInGraphics')) == 1, 'oracle enables text capture after mode set')
        check(pair.b.m.word(pair.sym('TextInGraphics')) == 1, 'C enables text capture after mode set')
        check(observed[0]['modes'] == observed[1]['modes'] == [0x09], 'both sides select Tandy BIOS mode 09h')
    finally:
        restore_machine_calls(original_calls)
        cleanup(pair, bag)


def shutdown_cases(pair):
    scenarios = (
        (0, b'', False),
        (1, b'A:badfile\0', True),
        (0x7F, b'badfile\0', True),
        (0xFF, b'B:x\0', True),
        (2, b'\0', True),
    )
    for error_flag, filename_bytes, is_error in scenarios:
        bag, observed = [], []
        stack_sp = pair.a.m.stack_top - 0x40 - 0x20
        saved_mask = pair.mask
        masked = bytearray(saved_mask)
        file_segment = pair.sym('FileBufferSegment')
        masked[file_segment:file_segment + 2] = b'\1\1'
        pair.mask = bytes(masked)
        w = World(pair, random.Random(21)).byte('ExitWithError', error_flag)
        # Keep the reported resource distinct from the save service's own filename.
        filename = pair.sym('File_WINDOW_BIC')
        w.word('FileNamePtr', filename)
        w.put(pair.a.m.offset('StackTop') - 0x60, bytes(range(0x60)))
        if is_error:
            w.put('File_WINDOW_BIC', filename_bytes)
        for side in (pair.a, pair.b):
            obs = {'services': [], 'dos': [], 'modes': [], 'ports': [], 'trace': [],
                   'filename_at_reset': None}
            observed.append(obs)
            def record_service(name, u, obs, side):
                obs['services'].append(name)
                if name == 'ResetEgaPages':
                    obs['filename_at_reset'] = side.m.peek('FileNamePtr')
                ds = u.reg_read(REG['DS'])
                es = u.reg_read(REG['ES'])
                if es == side.m.data_frame: es = 'state'
                obs['trace'].append((name, u.reg_read(REG['BP']), es,
                                     'state' if ds == side.m.data_frame else ds))
            def observe_save(u, address, size, _, obs=obs, side=side):
                obs['services'].append('SaveHiscoreFile')
                # Native SaveHiscoreFile is void; only later service metadata is live.
                obs['trace'].append(('SaveHiscoreFile',))
            save_label = 'SaveHiscoreFile' if side is pair.a else 'SAVE_HISCORE_FILE'
            hook(side, bag, UC_HOOK_CODE, observe_save, side.m.linear(save_label))
            side.m.u.ctl_remove_cache(side.image[0], side.image[1])
            for name in ('ResetEgaPages', 'StopModuleMusic',
                         'RestoreKeyboardVector09', 'RestoreTimerVector08'):
                def action(u, name=name, obs=obs, side=side):
                    record_service(name, u, obs, side)
                service_hook(side, bag, name, action)
            release_label = 'ReleaseEmsCache' if side is pair.a else 'RELEASE_EMS_CACHE'
            def observe_release(u, address, size, _, obs=obs, side=side):
                obs['services'].append('ReleaseEmsCache')
                obs['trace'].append(('ReleaseEmsCache',))
                return_service(side)
            hook(side, bag, UC_HOOK_CODE, observe_release, side.m.linear(release_label))
            side.m.u.ctl_remove_cache(side.image[0], side.image[1])
            service_hook(side, bag, 'RestoreAllocStrategy',
                         lambda u, obs=obs, side=side: record_service('RestoreAllocStrategy', u, obs, side),
                         far=True)

        case = Case('ShutdownGame', {'AX': 0x2468, 'BP': 0x7312, 'ES': 0xB800}, w.writes(),
                    FREE, name=f'error flag={error_flag:02X} filename={filename_bytes!r}'
                    if is_error else 'normal')
        case.stack_sp = stack_sp  # model an abandoned IRQ/caller frame
        case._system_hooks = (pair, bag)
        case._system_observed = observed
        original_calls = install_bounded_calls(pair, observed)
        try:
            yield case
            check(observed[0]['services'] == observed[1]['services'], 'shutdown service order matches')
            check(observed[0]['trace'] == observed[1]['trace'],
                  f'shutdown service/BP/ES/DS and BIOS/DOS event trace matches: '
                  f'{observed[0]["trace"]!r} vs {observed[1]["trace"]!r}')
            check(observed[0]['services'] == ['SaveHiscoreFile', 'ResetEgaPages', 'StopModuleMusic',
                  'RestoreKeyboardVector09', 'RestoreTimerVector08', 'ReleaseEmsCache',
                  'RestoreAllocStrategy'], 'shutdown runs the fixed cleanup order')
            check(pair.a.m.word(pair.sym('FileNamePtr')) == filename, 'oracle restores pre-save FileNamePtr')
            check(pair.b.m.word(pair.sym('FileNamePtr')) == filename, 'C restores pre-save FileNamePtr')
            check(pair.a.m.word(file_segment) == pair.a.m.peek('MainDataSegment'),
                  'oracle save uses its relocated main-data segment')
            check(pair.b.m.word(file_segment) == pair.b.m.peek('MainDataSegment'),
                  'C save uses its relocated main-data segment')
            check(observed[0]['filename_at_reset'] == observed[1]['filename_at_reset'] == filename,
                  'pre-save FileNamePtr is restored before hardware cleanup begins')
            check(observed[0]['dos'] == observed[1]['dos'], 'DOS error strings and file writes match')
            check(observed[0]['modes'] == observed[1]['modes'], 'BIOS mode/cursor calls match')
            if is_error:
                original = filename_bytes
                check(pair.a.m.read(filename, len(original)) == original[:-1] + b'$',
                      'oracle mutates the filename terminator only')
                check(pair.b.m.read(filename, len(original)) == original[:-1] + b'$',
                      'C mutates the filename terminator only')
                printed_name = original[:-1]
                if printed_name[1:2] == b':':
                    printed_name = printed_name[2:]
                check([s for s in observed[0]['dos'] if s[0] == 'print'][-3:] ==
                      [("print", b"\x07I could not find the file '$"),
                       ("print", printed_name + b"$"),
                       ("print", b"' anywhere, sorry.\r\n\r\n$")],
                      'error path prints head, drive-stripped filename, then tail')
            else:
                check(pair.a.m.u.mem_read(0xB8000, 2) == pair.b.m.u.mem_read(0xB8000, 2),
                      'normal exit presents the same screen bytes')
                check(pair.a.m.u.mem_read(0x41A, 4) == pair.b.m.u.mem_read(0x41A, 4),
                      'normal exit flushes the BIOS keyboard queue identically')
            available = case.stack_sp - pair.stack_area
            for label in ('oracle', 'hybrid'):
                depth = pair.max_depth[label][0]
                check(depth < available, f'{label} shutdown fits remaining 200h-byte stack')
        finally:
            restore_machine_calls(original_calls)
            cleanup(pair, bag)
            pair.mask = saved_mask


def cases(rng, scale, pair):
    yield from startup_case(pair)
    yield from shutdown_cases(pair)


MUTANTS = [
    ('startup.c', 'dos_service(EnableFileFlagsIfVgaDac, registers);\n    dos_service(VerifyStartupChecksums, registers);',
     'dos_service(VerifyStartupChecksums, registers);\n    dos_service(EnableFileFlagsIfVgaDac, registers);'),
    ('startup.c', 'TextInGraphics = 1;', 'TextInGraphics = 0;'),
    ('shutdown.c', '*name = 0x24;', 'name[-1] = 0x24;'),
    ('shutdown.c', 'ExitWithError != 0', 'ExitWithError == 1'),
    ('shutdown.c', 'FileNamePtr = saved_file_name;',
     'FileNamePtr = (word)HiscoreFileName;\n    (void)saved_file_name;'),
]
