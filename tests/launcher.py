"""Bounded entry-path comparisons for PSP policy and high-score precedence.

The DOS entry remains real ASM through PSP resize and the mask-table initializer.
Only INT 21h file/resize responses are mocked; both sides stop at the startup-policy
boundary before checksums, hardware initialization, or gameplay run.
"""
from difftest import Case, far
from world import World, K
from emu import REG, FLAG, LOAD
from options import hook, cleanup, return_service, check
from unicorn import UC_HOOK_CODE
import hybrid
import random
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'launcher.c']
FREE = ('SP', 'DS', 'SS')
PSP_SEGMENT = 0x9000
SAVED_VIDEO = 2
SAVED_SOUND = ord('a')


def encoded_hiscore():
    block = bytearray([0x22] * K.HISCORE_BLOCK_BYTES)
    struct.pack_into('<H', block, 0, 2)       # valid SoundOptionFlags index
    struct.pack_into('<H', block, 164, SAVED_VIDEO)
    block[166] = SAVED_SOUND
    coded = bytes(b ^ 0xAA ^ ((K.HISCORE_BLOCK_BYTES - i) & 255)
                  for i, b in enumerate(block))
    return coded + struct.pack('<H', sum(coded) & 0xFFFF)


def install_entry_services(pair, side, bag, mask, video, sound, file_present, resize_ok,
                           entry_sp, initial_bp, entry_pairs, dos_trace, observations):
    def enter_program(u, address, size, _):
        # Machine.call starts with DS at the game frame; DOS enters with both DS and
        # ES naming the PSP. ES already carries the test PSP segment.
        entry_sp.append(u.reg_read(REG['SP']))
        initial_bp.append(u.reg_read(REG['BP']))
        u.reg_write(REG['DS'], PSP_SEGMENT)

    hook(side, bag, UC_HOOK_CODE, enter_program, side.m.linear('ProgramEntry'))

    def critical_vector(u, address, size, _):
        return_service(side, far=True)

    hook(side, bag, UC_HOOK_CODE, critical_vector,
         side.m.linear('InstallCriticalErrorVector'))

    def interrupts(u, address, size, _):
        if bytes(u.mem_read(address, size)) != b'\xCD\x21':
            return
        ax = u.reg_read(REG['AX'])
        function = ax >> 8
        if function == K.DOS_RESIZE_MEMORY:
            check(u.reg_read(REG['ES']) == PSP_SEGMENT,
                  'PSP resize uses the entry PSP segment')
            check(u.reg_read(REG['BX']) != 0, 'PSP resize requests a nonempty image block')
            dos_trace.append(('resize', u.reg_read(REG['ES']), 'image-allocation'))
            flags = u.reg_read(REG['FLAGS']) & ~FLAG['CF']
            if not resize_ok:
                flags |= FLAG['CF']
                u.reg_write(REG['AX'], 8)
            u.reg_write(REG['FLAGS'], flags)
        elif function == K.DOS_OPEN_FILE:
            check(u.reg_read(REG['DS']) == side.m.data_frame,
                  'launcher opens hiscore.dat from the game data segment')
            check(u.reg_read(REG['DX']) == side.m.offset('HiscoreFileName'),
                  'launcher opens the high-score filename')
            dos_trace.append(('open', ax & 0xFF, file_present))
            u.reg_write(REG['AX'], 0x1234 if file_present else 5)
            flags = u.reg_read(REG['FLAGS'])
            u.reg_write(REG['FLAGS'], (flags | FLAG['CF']) if not file_present
                        else (flags & ~FLAG['CF']))
        elif function == K.DOS_READ_FILE:
            stream = encoded_hiscore()
            ds, dx, count = (u.reg_read(REG['DS']), u.reg_read(REG['DX']),
                             u.reg_read(REG['CX']))
            check(count == 0xFFFF, 'loader requests the original full read')
            dos_trace.append(('read', count, len(stream)))
            u.mem_write(ds * 16 + dx, stream)
            u.reg_write(REG['AX'], len(stream))
            u.reg_write(REG['FLAGS'], u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
        elif function == K.DOS_CLOSE_FILE:
            dos_trace.append(('close', u.reg_read(REG['BX'])))
            u.reg_write(REG['AX'], 0)
            u.reg_write(REG['FLAGS'], u.reg_read(REG['FLAGS']) & ~FLAG['CF'])
        else:
            raise AssertionError(f'unexpected launcher DOS service AH={function:02X}')
        u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + size) & 0xFFFF)

    hook(side, bag, UC_HOOK_CODE, interrupts, *side.image)

    if not resize_ok:
        def fatal_cut(u, address, size, _):
            # ShowFatalErrorAndExit is a non-returning user-visible path. Stop at its
            # entry, after verifying the resize branch without running BIOS/DOS UI.
            cs = side.m.u.reg_read(REG['CS'])
            entry_pairs.append(('resize-error', u.reg_read(REG['DX'])))
            observations.append(capture_outputs(side, u))
            u.reg_write(REG['SP'], entry_sp[0] + 2)
            u.reg_write(REG['CS'], cs)
            u.reg_write(REG['IP'], 0xFFFE)

        hook(side, bag, UC_HOOK_CODE, fatal_cut, side.m.linear('ShowFatalErrorAndExit'))
        return

    def startup_cut(u, address, size, _):
        if side is pair.a:
            bp, es = u.reg_read(REG['BP']), u.reg_read(REG['ES'])
        else:
            # The native startup coordinator receives the same BP/ES values in its
            # explicit DosRegisters argument (the first C argument enters in SI).
            ptr = u.reg_read(REG['SI'])
            data = bytes(u.mem_read(u.reg_read(REG['DS']) * 16 + ptr, 4))
            bp, es = struct.unpack('<HH', data)
        entry_pairs.append(('startup', bp, 'data-segment' if es == side.m.data_frame else es))
        observations.append(capture_outputs(side, u))
        cs = side.m.symbols['PROGRAMENTRY'][0] + LOAD
        u.reg_write(REG['SP'], entry_sp[0] + 2)
        u.reg_write(REG['CS'], cs)
        u.reg_write(REG['IP'], 0xFFFE)

    startup_label = 'StartupAfterOverrides' if side is pair.a else 'STARTUP_AFTER_OVERRIDES'
    hook(side, bag, UC_HOOK_CODE, startup_cut, side.m.linear(startup_label))


def capture_outputs(side, u):
    return {
        'video': struct.unpack('<H', bytes(u.mem_read(side.m.linear('VideoAdapter'), 2)))[0],
        'mask': u.mem_read(side.m.linear('LauncherOverrideMask'), 1)[0],
        'entry_es': struct.unpack('<H', bytes(u.mem_read(side.m.linear('EntryEsPsp'), 2)))[0],
        'entry_ds': struct.unpack('<H', bytes(u.mem_read(side.m.linear('EntryDsPsp'), 2)))[0],
        'sound': u.mem_read(side.m.data_frame * 16 + side.m.offset('SoundModuleSelect'), 1)[0],
    }


def case(pair, mask, video, sound, file_present=True, resize_ok=True):
    bag, stacks, initial_bp, boundaries, traces, observations = [], [], [], [], [], []
    saved_mask = pair.mask
    patched_mask = bytearray(saved_mask)
    file_segment_at = pair.sym('FileBufferSegment')
    patched_mask[file_segment_at:file_segment_at + 2] = b'\1\1'
    # ProgramEntry replaces the harness's incoming SP with StackTop before making
    # C calls. All of StackArea..StackTop is scratch during this bounded entry slice.
    stack_begin = pair.a.m.offset('StackArea')
    patched_mask[stack_begin:pair.a.m.stack_top] = (
        b'\1' * (pair.a.m.stack_top - stack_begin))
    pair.mask = bytes(patched_mask)
    writes = []
    for side in (pair.a, pair.b):
        stack = []; bp = []; boundary = []; trace = []; observed = []
        stacks.append(stack); initial_bp.append(bp); boundaries.append(boundary); traces.append(trace)
        observations.append(observed)
        install_entry_services(pair, side, bag, mask, video, sound, file_present,
                               resize_ok, stack, bp, boundary, trace, observed)

    # The ignored length is varied to cover zero and truncated command tails. The
    # original consumes the following three binary bytes regardless.
    length = (mask * 17) & 0xFF
    w = World(pair, random.Random(mask + video * 257 + sound)).word('FileStatus', 0)
    writes.extend(w.writes())
    writes.append((far('SlotBuffer', 0x80), bytes((length, mask, video, sound))))

    def done(_m, _regs):
        check(traces[0] == traces[1], 'DOS resize and high-score file operation order matches')
        check(boundaries[0] == boundaries[1], 'startup boundary receives matching BP/ES metadata')
        if resize_ok:
            check(boundaries[0][0][0] == 'startup', 'successful resize reaches startup policy')
            check(traces[0][0][0] == 'resize', 'PSP resize precedes high-score loading')
            expected_video = (video if video <= K.VIDEO_TANDY else 1)
            expected_sound = sound
            if file_present:
                expected_video, expected_sound = SAVED_VIDEO, SAVED_SOUND
            if mask in (K.LAUNCHER_OVERRIDE_VIDEO, K.LAUNCHER_OVERRIDE_BOTH):
                expected_video = (video if video <= K.VIDEO_TANDY else 1)
            if mask in (K.LAUNCHER_OVERRIDE_SOUND, K.LAUNCHER_OVERRIDE_BOTH):
                expected_sound = sound
            for side, observed in zip((pair.a, pair.b), observations):
                check(observed[0]['video'] == expected_video,
                      f'video policy for mask {mask:02X}')
                check(side.m.read(side.m.offset('SoundModuleSelect'), 1)[0] == expected_sound,
                      f'sound policy for mask {mask:02X}')
                check(observed[0]['entry_es'] == PSP_SEGMENT and
                      observed[0]['entry_ds'] == PSP_SEGMENT,
                      'entry preserves both PSP segment inputs')
                expected_file_segment = (LOAD + side.m.symbols['SOUNDMODULESLOT'][0]
                                         + K.SLOT_BUFFER_PARAGRAPH)
                check(side.m.word(side.m.offset('FileBufferSegment')) == expected_file_segment,
                      'high-score buffer segment tracks its linked sound slot')
                check(side.m.word(side.m.offset('FileStatus')) ==
                      (K.FILE_STATUS_OK if file_present else K.FILE_STATUS_OPEN_FAILED),
                      'hiscore file result status')
                check(observed[0]['mask'] == mask,
                      'launcher mask state')
            check(boundaries[0][0][1:] == (initial_bp[0][0], 'data-segment'),
                  'oracle startup receives post-load ES and live BP')
        else:
            check(boundaries[0] == [('resize-error', pair.a.m.offset('MsgDeallocError'))],
                  'resize failure reaches the original fatal-message entry')
            check(traces[0] and traces[0][0][0] == 'resize',
                  'resize failure is reported at the resize call')

    try:
        yield Case('ProgramEntry', {'AX': 0xA55A, 'BX': 0x1357, 'CX': 0x2468,
                    'DX': 0x369C, 'SI': 0x55AA, 'DI': 0xA55A, 'BP': 0x369A,
                    'ES': PSP_SEGMENT}, writes, preserve=FREE,
                    expect=done, name=f'mask={mask:02X} video={video:02X} sound={sound:02X}'
                    + (' missing' if not file_present else '')
                    + (' resize-error' if not resize_ok else ''))
    finally:
        cleanup(pair, bag)
        pair.mask = saved_mask


def cases(rng, scale, pair):
    for mask in range(256):
        yield from case(pair, mask, (0, 1, 2, 3, 0xFF)[mask % 5],
                        ord('A') + mask % 26, file_present=True)
    for mask, video, sound in ((0, 2, ord('R')), (0xF0, 2, ord('T')),
                               (0x0F, 1, ord('A')), (0xFF, 3, ord('X'))):
        yield from case(pair, mask, video, sound, file_present=False)
    yield from case(pair, 0xFF, 2, ord('T'), resize_ok=False)


MUTANTS = [
    ('launcher.c', 'if (video > VIDEO_TANDY)', 'if (video >= VIDEO_TANDY)'),
    ('launcher.c', 'if (mask == LAUNCHER_OVERRIDE_VIDEO || mask == LAUNCHER_OVERRIDE_SOUND ||',
     'if (mask != 0 || mask == LAUNCHER_OVERRIDE_SOUND ||'),
    ('launcher.c', 'registers->es = (word)(load_result >> 16);',
     'registers->es = (word)((load_result >> 16) + 1);'),
]
