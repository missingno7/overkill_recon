"""Settings/high-score file control through the real ASM DOS file services.

Supply only INT 21h file responses. Compare file bytes and ordered operations,
whole state, CS video writes, registers and error unwinds. Short files deliberately
retain the stale slot-buffer suffix; the original does not check the read length.
"""
from difftest import Case, ALL_REGS, far
from world import World, K
from emu import REG, FLAG, LOAD
from options import hook, cleanup, check
from unicorn import UC_HOOK_CODE
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'settings.c']

def block(rng, sound=2, video=2):
    data = bytearray(rng.randrange(256) for _ in range(K.HISCORE_BLOCK_BYTES))
    struct.pack_into('<H', data, 144, sound)
    struct.pack_into('<H', data, 164, video)
    return bytes(data)

def encoded(data):
    coded = bytes(b ^ 0xAA ^ ((K.HISCORE_BLOCK_BYTES - i) & 255) for i, b in enumerate(data))
    return coded + struct.pack('<H', sum(coded) & 65535)

def state(pair, rng, sound=2):
    w = World(pair, rng).put('HiscoreBlock', block(rng)).word('SoundOption', sound)
    for field in ('JoyXLowThreshold', 'JoyXHighThreshold', 'JoyYLowThreshold', 'JoyYHighThreshold',
                  'InputDeviceMode', 'JoyButtonSelect', 'ChooseSlot', 'DifficultySetting',
                  'HiscoreChecksum', 'FileByteCount', 'FileHandle', 'FileStatus'):
        w.word(field, rng.randrange(65536))
    for field in ('KeyBitScancodesA', 'KeyBitScancodesB'):
        w.put(field, bytes(rng.randrange(256) for _ in range(K.KEY_BIT_SCANCODE_COUNT)))
    for field in ('SoundModuleSelect', 'SfxEnabled', 'ModuleSoundEnabled'):
        w.byte(field, rng.randrange(256))
    return w

def file_case(w, loading, name, stream=b'', baseline=None, error=None, count=None, video=2, success=None):
    pair = w.pair; bag = []; observed = []
    mask = pair.mask
    # This word is a relocated DOS segment. Check its identity at every operation
    # and on return on each side, then exclude only its numeric link difference.
    patched = bytearray(mask); at = pair.sym('FileBufferSegment'); patched[at:at + 2] = b'\1\1'
    pair.mask = bytes(patched)
    if loading:
        baseline = baseline if baseline is not None else bytes(K.HISCORE_BLOCK_BYTES + 2)
        w.put(far('SoundModuleSlot', K.SLOT_BUFFER_PARAGRAPH * 16), baseline)
        final = bytearray(baseline)
        if error not in ('open', 'read'): final[:len(stream)] = stream
        valid = sum(final[:K.HISCORE_BLOCK_BYTES]) & 65535 == struct.unpack_from('<H', final, K.HISCORE_BLOCK_BYTES)[0]
        expected_success = error not in ('open', 'read') and valid
        if success is not None: check(expected_success == success, 'fixture success matches intent')
    for side in (pair.a, pair.b):
        obs = []; observed.append(obs)
        video_at = side.m.linear('VideoAdapter')
        old_video = bytes(side.m.u.mem_read(video_at, 2))
        side.m.u.mem_write(video_at, struct.pack('<H', video))
        def interrupts(u, address, size, _, side=side, obs=obs):
            if bytes(u.mem_read(address, size)) != b'\xCD\x21': return
            ax = u.reg_read(REG['AX']); function = ax >> 8
            operation = {K.DOS_OPEN_FILE:'open', K.DOS_READ_FILE:'read', K.DOS_CREATE_FILE:'create',
                         K.DOS_WRITE_FILE:'write', K.DOS_CLOSE_FILE:'close'}.get(function)
            check(operation is not None, f'unexpected DOS function {function:02X}')
            expected_segment = (LOAD + side.m.symbols['SOUNDMODULESLOT'][0] + K.SLOT_BUFFER_PARAGRAPH
                                if loading else side.m.data_frame)
            check(side.m.word(pair.sym('FileBufferSegment')) == expected_segment, 'file buffer segment identity')
            check(side.m.word(pair.sym('FileNamePtr')) == pair.sym('HiscoreFileName'), 'hiscore filename pointer')
            check(side.m.word(pair.sym('FileBufferOffset')) == (0 if loading else pair.sym('HiscoreBlock')), 'file buffer offset')
            if operation in ('open', 'create'):
                check(u.reg_read(REG['DS']) == side.m.data_frame, 'DOS filename segment')
                check(u.reg_read(REG['DX']) == pair.sym('HiscoreFileName'), 'DOS filename offset')
                obs.append((operation, ax & 255, u.reg_read(REG['CX']) if operation == 'create' else None))
                result = 0x1234
            elif operation in ('read', 'write'):
                ds = u.reg_read(REG['DS']); dx = u.reg_read(REG['DX']); length = u.reg_read(REG['CX'])
                check(ds == expected_segment, 'DOS buffer segment')
                check(u.reg_read(REG['BX']) == 0x1234, 'DOS handle')
                check(dx == (0 if loading else pair.sym('HiscoreBlock')), 'DOS buffer offset')
                check(length == (0xFFFF if loading else K.HISCORE_BLOCK_BYTES + 2), 'DOS byte request')
                if operation == 'read':
                    obs.append(('read', length, bytes(stream)))
                    if error != 'read' and stream:
                        dest = ds * 16 + dx
                        side.undo.append((dest, bytes(u.mem_read(dest, len(stream)))))
                        u.mem_write(dest, bytes(stream))
                    result = len(stream) if count is None else count
                else:
                    obs.append(('write', bytes(u.mem_read(ds * 16 + dx, length))))
                    result = length if count is None else count
            else:
                check(u.reg_read(REG['BX']) == 0x1234, 'DOS close handle')
                obs.append(('close',)); result = 0
            flags = u.reg_read(REG['FLAGS']) & ~FLAG['CF']
            if operation == error: flags |= FLAG['CF']; result = 5
            u.reg_write(REG['AX'], result)
            u.reg_write(REG['FLAGS'], flags)
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + size) & 65535)
        hook(side, bag, UC_HOOK_CODE, interrupts, side.image[0], side.image[1])
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
        # Preserve externally seeded CS data independently of the normal CPU undo.
        obs.append(('seed', video_at, old_video))
    seeds = [obs.pop() for obs in observed]
    def done(m, regs):
        check(observed[0] == observed[1], f'matching DOS file trace {name}')
        for side in (pair.a, pair.b):
            segment = (LOAD + side.m.symbols['SOUNDMODULESLOT'][0] + K.SLOT_BUFFER_PARAGRAPH
                       if loading else side.m.data_frame)
            check(side.m.word(pair.sym('FileBufferSegment')) == segment, 'returned buffer segment identity')
            if loading:
                check(side.m.u.reg_read(REG['AX']) & 255 == int(expected_success), 'load success byte')
                expected_es = (0xB800 if error in ('open', 'read') else
                               side.m.data_frame if expected_success else segment)
            else: expected_es = side.m.data_frame
            check(side.m.u.reg_read(REG['ES']) == expected_es, 'file controller ES result')
    try:
        yield Case('LoadHiscoreFile' if loading else 'SaveHiscoreFile',
                   {'BP': pair.sym('ScoreBcd'), 'ES': 0xB800}, w.writes(), ('BP', 'SP', 'DS', 'SS'),
                   expect=done, name=name)
    finally:
        cleanup(pair, bag); pair.mask = mask
        for side, seed in zip((pair.a, pair.b), seeds): side.m.u.mem_write(seed[1], seed[2])

def cases(rng, scale, pair):
    for sound in (0, 1, 2, 3, 4, 7, 0x100, 0x8000, 0x8001, 0xFFFF):
        for video in (0, 1, 2, 3, 0xFFFF):
            data = block(rng, sound, video)
            yield from file_case(state(pair, rng), True, f'load {sound}/{video}', encoded(data), success=True)
    data = block(rng); valid = encoded(data)
    for length in (0, 1, 2, 143, 144, 145, 171, 172, 173, 174):
        # A valid stale suffix proves that even a zero-byte successful read can
        # apply saved settings. A corrupt checksum leaves the initial state.
        yield from file_case(state(pair, rng), True, f'short valid {length}', valid[:length], valid, success=True)
        broken = bytearray(valid); broken[-1] ^= 1
        yield from file_case(state(pair, rng), True, f'short bad {length}', bytes(broken[:length]), bytes(broken), success=False)
    for error in ('open', 'read', 'close'):
        yield from file_case(state(pair, rng), True, f'load error {error}', valid, error=error)
    for error in (None, 'create', 'write', 'close'):
        for sound in (0, 1, 2, 3, 0xFFFF):
            for video in (0, 1, 2, 0xFFFF):
                yield from file_case(state(pair, rng, sound), False, f'save {error}/{sound}/{video}', error=error, video=video)
    for count in (0, 1, 171, 172, 173):
        yield from file_case(state(pair, rng), False, f'short write {count}', count=count)
    for i in range(300 * scale):
        sound = rng.choice((0, 1, 2, 3, 4, 7, 0x8000, 0xFFFF))
        data = block(rng, sound, rng.randrange(65536))
        stream = bytearray(encoded(data))
        if i % 3 == 0: stream[rng.randrange(len(stream))] ^= 1 << rng.randrange(8)
        yield from file_case(state(pair, rng, sound), True, f'random load {i}', bytes(stream))
        yield from file_case(state(pair, rng, sound), False, f'random save {i}', video=rng.randrange(65536))
    for value in range(256):
        w = state(pair, rng)
        yield Case('ApplyLauncherSoundOverride', {'AX': 0xA500 | value, 'SI': 0x55AA}, w.writes(), ALL_REGS,
                   flags=('CF', 'PF', 'AF', 'ZF', 'SF', 'DF', 'OF'), name=f'module byte {value}')

MUTANTS = [
    ('settings.c', '*(word *)p = video;', '*(word *)p = video + 1;'),
    ('settings.c', '*p++ = SoundModuleSelect;', '*(word *)p = SoundModuleSelect; p += 2;'),
    ('settings.c', 'KEY_BIT_SCANCODE_COUNT; n++) *p++', 'KEY_BIT_SCANCODE_COUNT - 1; n++) *p++'),
    ('settings.c', 'JOY_THRESHOLD_WORDS; n++, p += 2)\n        *(word *)p', 'JOY_THRESHOLD_WORDS - 1; n++, p += 2)\n        *(word *)p'),
    ('settings.c', 'SfxEnabled = (byte)(flags >> 8);', 'SfxEnabled = (byte)flags;'),
    ('settings.c', 'KeyBitScancodesB[KEY_SLOT_SECONDARY] =', 'KeyBitScancodesB[KEY_SLOT_PRIMARY] ='),
    ('settings.c', '(byte)(HISCORE_BLOCK_BYTES - n)', '(byte)(HISCORE_BLOCK_BYTES - n - 1)'),
    ('settings.c', 'sum += value;', 'sum += HiscoreBlock[0];'),
    ('settings.c', 'FileByteCount = HISCORE_BLOCK_BYTES + 2;', 'FileByteCount = HISCORE_BLOCK_BYTES;'),
    ('settings.c', 'if (FileStatus != FILE_STATUS_OK)', 'if (FileStatus == FILE_STATUS_OK)'),
    ('settings.c', 'if (sum != *(word __far *)(SlotBuffer + HISCORE_BLOCK_BYTES))',
     'if (FileByteCount != HISCORE_BLOCK_BYTES + 2 || sum != *(word __far *)(SlotBuffer + HISCORE_BLOCK_BYTES))'),
    ('settings.c', 'VideoAdapter = load_settings_from_hiscore_block();', 'load_settings_from_hiscore_block();'),
    ('settings.c', 'xor_code_hiscore_block();\n}', '/* leave the block encoded */\n}'),
]
