"""Pause and cheat control (c/pause.c), entered through the real PauseGame entry.

Input events arrive at the cheat-poll boundary on both images. F10 release waits
also receive controlled releases. The BIOS teletype bell is observed and returned
with flags intact; its device implementation and IRQ timing are outside this suite.
Panel rendering runs through the original ASM and its video writes are compared.
"""
from difftest import Case
from world import World, K
from emu import REG
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
import hybrid
import itertools
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'pause.c']
FREE = ('SP', 'DS', 'SS')
CHEATS = ('CheatRemindMe', 'CheatEveryDayIDie', 'CheatWhatOilShortage',
          'CheatLifeInTheFastLane', 'CheatBonusCheatOn', 'CheatMyNameIsSmith',
          'CheatGibStMirSchnellfeuer')
FLAGS = ('WhatOilShortageFlag', 'KeepLivesFlag', 'BonusKeysEnabled',
         'LevelSkipEnabled', 'RapidFireEnabled', 'AllCheatsFlag')
CONTROLS = (K.SCAN_SPACE, K.SCAN_UP, K.SCAN_TAB, K.SCAN_LEFT, K.SCAN_RIGHT, K.SCAN_DOWN)

def code(pair, label):
    at = pair.sym(label) + 2
    data = pair.a.pristine
    end = data.index(0, at)
    return tuple(data[at:end])

def base(w):
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    w.put('KeyBitScancodesA', bytes(K.KEY_BIT_SCANCODE_COUNT))
    w.put('KeyBitScancodesB', bytes(K.KEY_BIT_SCANCODE_COUNT))
    w.word('InputDeviceMode', 0).byte('KeyLastMakeCode', 0x7F)
    w.byte('SfxEnabled', 0).byte('SfxRequest', 0x53).byte('InputBits', 0xFF)
    for label in CHEATS: w.word(label, w.sym(label) + 2)
    for label in FLAGS: w.byte(label, 0)
    return w

def event(key=0, mask=0, f10=0):
    return key, mask, f10

def check(cond, why):
    if not cond: raise AssertionError(why)

def driven(w, events, name, initial_hold=0, final_hold=0, expect=None, continuation=(), beep_key=None):
    """One bounded input stream, delivered at corresponding semantic boundaries.
    No cheat effects or cursor transitions are simulated: both executables do them.
    """
    pair = w.pair
    hooks, observations = [], []
    streams = [events] + list(continuation)
    if initial_hold: w.byte(w.sym('KeyDownTable') + K.SCAN_F10, K.KEY_STATE_DOWN)
    for side, label in ((pair.a, 'CheckCheatCodes'), (pair.b, 'CHECK_CHEAT_CODES')):
        obs = dict(run=-1, polls=0, beeps=0, reads=0, current=None)
        observations.append(obs)
        def enter(u, address, size, _, side=side, obs=obs):
            obs.update(run=obs['run'] + 1, polls=0, beeps=0, reads=0, current=None)
            side.m.write(pair.sym('KeyDownTable') + K.SCAN_F10,
                         bytes((K.KEY_STATE_DOWN if initial_hold else 0,)))
        def poll(u, address, size, _, side=side, obs=obs):
            i = obs['polls']; obs['polls'] += 1
            stream = streams[obs['run']]
            if i >= len(stream):
                raise AssertionError('pause did not resume after the supplied input stream')
            key, mask, f10 = stream[i]
            keys = bytearray(K.KEY_DOWN_COUNT)
            for bit, scan in enumerate(CONTROLS):
                if mask & (1 << bit): keys[scan] = K.KEY_STATE_DOWN
            keys[K.SCAN_F10] = f10
            side.m.write(pair.sym('KeyDownTable'), keys)
            if key is not None: side.m.write(pair.sym('KeyLastMakeCode'), bytes((key,)))
            obs['current'] = stream[i]; obs['reads'] = 0
        def release(u, access, address, size, value, _, side=side, obs=obs):
            obs['reads'] += 1
            held = initial_hold if obs['current'] is None else final_hold + 1
            f10 = K.KEY_STATE_DOWN if obs['current'] is None else obs['current'][2]
            if f10 == K.KEY_STATE_DOWN and obs['reads'] > held:
                side.m.write(pair.sym('KeyDownTable') + K.SCAN_F10, b'\0')
        def beep(u, address, size, _, side=side, obs=obs):
            check(u.reg_read(REG['AX']) == 0x0E07, 'BIOS teletype bell ABI')
            obs['beeps'] += 1
            if beep_key is not None: side.m.write(pair.sym('KeyLastMakeCode'), bytes((beep_key,)))
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + 2) & 0xFFFF)
        at = side.m.linear(label)
        bell = side.m.linear('BiosBeep') + 4
        key = side.m.data_frame * 16 + pair.sym('KeyDownTable') + K.SCAN_F10
        entry = side.m.linear('PauseGame' if side is pair.a else 'PAUSE_GAME')
        hooks.extend(((side, side.m.u.hook_add(UC_HOOK_CODE, enter, None, entry, entry)),
                      (side, side.m.u.hook_add(UC_HOOK_CODE, poll, None, at, at)),
                      (side, side.m.u.hook_add(UC_HOOK_MEM_READ, release, None, key, key)),
                      (side, side.m.u.hook_add(UC_HOOK_CODE, beep, None, bell, bell))))
        # New hooks must instrument blocks translated by previous suites too.
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        check(observations[0] == observations[1], 'identical input consumption and beep events')
        check(observations[0]['polls'] == len(streams[observations[0]['run']]),
              'primary alone or F10 resumes at the intended poll')
        if expect: expect(m, observations[0])
    try:
        steps = [Case('PauseGame', {}, w.writes() if i == 0 else (), FREE,
                      expect=done, name=f'{name} pause {i}') for i in range(len(streams))]
        yield steps if len(steps) > 1 else steps[0]
    finally:
        for side, hook in hooks: side.m.u.hook_del(hook)
        for side in (pair.a, pair.b): side.m.u.ctl_remove_cache(side.image[0], side.image[1])

def cases(rng, scale, pair):
    # Distinct valid packed images exercise both panel indices and their positions.
    # Restore fixture bytes afterward so later suites keep their original baseline.
    undo = []
    for side in (pair.a, pair.b):
        bank = side.m.peek('PanelSegment') * 16
        for image, offset, rows, width, value in ((K.PANEL_PAUSE_UPPER, 0x40, 2, 1, 0xA6),
                                                  (K.PANEL_PAUSE_LOWER, 0x80, 3, 2, 0x59)):
            table = side.m.linear('PanelImageOffsets') + image * 2
            data = struct.pack('<HH', rows, width) + bytes((value,)) * (rows * width * 4)
            for at, payload in ((table, struct.pack('<H', offset)), (bank + offset, data)):
                undo.append((side, at, bytes(side.m.u.mem_read(at, len(payload)))))
                side.m.u.mem_write(at, payload)
    try:
        yield from pause_cases(rng, scale, pair)
    finally:
        for side, at, data in reversed(undo): side.m.u.mem_write(at, data)

def pause_cases(rng, scale, pair):
    w = base(World(pair, rng))
    for label in CHEATS: w.word(label, pair.sym(label) + 3)
    yield from driven(w, [event(None, mask=1)], 'discard stale make code on pause entry',
                      expect=lambda m, obs: check(all(m.word(pair.sym(label)) == pair.sym(label) + 3
                                                     for label in CHEATS), 'pause preserves partial cursors'))
    w = base(World(pair, rng))
    yield from driven(w, [event(K.SCAN_R, mask=1)], 'consume make code before immediate resume',
                      expect=lambda m, obs: check(m.read(pair.sym('KeyLastMakeCode'), 1) == b'\0',
                                                 'make-code mailbox cleared before resume'))
    # Exact primary equality, both F10 waits, alternate keyboard modes and sound.
    for sound, mode, initial, final in itertools.product((0, 1, 2, 0xFF), (0, 2, 3, 0xFFFF), (0, 3), (0, 3)):
        w = base(World(pair, rng))
        w.byte('SfxEnabled', sound).word('InputDeviceMode', mode)
        events = [event(mask=3), event(mask=5), event(mask=1)]
        yield from driven(w, events, f'primary sound {sound} mode {mode} hold {initial}/{final}', initial, final)
        w = base(World(pair, rng)); w.byte('SfxEnabled', sound).word('InputDeviceMode', mode)
        yield from driven(w, [event(f10=2), event(f10=0xFF), event(f10=1)],
                          f'F10 sound {sound} mode {mode} hold {initial}/{final}', initial, final)

    for label in CHEATS:
        keys = code(pair, label)
        def completed(m, obs, label=label):
            check(obs['beeps'] == 1, 'one bell per completed code')
            check(m.word(pair.sym(label)) == pair.sym(label) + 2 + len(code(pair, label)),
                  'completed cursor stays at its terminator')
        w = base(World(pair, rng))
        for flag in FLAGS: w.byte(flag, 0xA5)
        yield from driven(w, [event(key) for key in keys] + [event(mask=1)], label, expect=completed)
        w = base(World(pair, rng))
        yield from driven(w, [event(key) for key in keys[:-1]] + [event(keys[-1], mask=1)],
                          f'{label} complete and resume in same poll', expect=completed)
        # Exhaust every valid cursor with both its matching and a mismatching key.
        for i, wanted in enumerate(keys):
            for key in (wanted, 0x7F):
                w = base(World(pair, rng)); w.word(label, pair.sym(label) + 2 + i)
                yield from driven(w, [event(key), event(mask=1)], f'{label} cursor {i} key {key}')
        # The first key on a mismatch is consumed rather than retried.
        w = base(World(pair, rng)); w.word(label, pair.sym(label) + 3)
        yield from driven(w, [event(keys[0]), event(mask=1)], f'{label} overlapping first key',
                          expect=lambda m, obs, label=label: check(m.word(pair.sym(label)) == pair.sym(label) + 2,
                                                                 'mismatch does not retry the key'))
        for split in range(1, len(keys)):
            w = base(World(pair, rng))
            yield from driven(w, [event(key) for key in keys[:split]] + [event(mask=1)],
                              f'{label} persists at split {split}',
                              continuation=([event(key) for key in keys[split:]] + [event(mask=1)],),
                              expect=lambda m, obs: check(obs['beeps'] == obs['run'],
                                                         'partial cheat persists across pause calls'))
        w = base(World(pair, rng))
        yield from driven(w, [event(key) for key in keys * 3] + [event(mask=1)],
                          f'{label} repeated after terminator')

    w = base(World(pair, rng))
    yield from driven(w, [event(key) for key in code(pair, 'CheatRemindMe')] + [event(mask=1)],
                      'make-code replacement during BIOS bell', beep_key=K.SCAN_N)

    # Force simultaneous completions to prove the seven calls' ordering.
    for key in (K.SCAN_E, K.SCAN_N, K.SCAN_H, K.SCAN_R):
        w = base(World(pair, rng))
        for label in CHEATS:
            keys = code(pair, label)
            w.word(label, pair.sym(label) + 2 + len(keys) - 1)
        yield from driven(w, [event(key), event(mask=1)], f'simultaneous final key {key}')

    for i in range(1000 * scale):
        w = base(World(pair, rng))
        for flag in FLAGS: w.byte(flag, rng.choice((0, 1, 2, 0xFF)))
        if i % 2 == 0:
            for label in CHEATS:
                w.word(label, pair.sym(label) + 2 + rng.randrange(len(code(pair, label)) + 1))
            keys = [rng.randrange(1, 0x80) for _ in range(rng.randrange(1, 20))]
        else:
            # Mutate real typed streams: concatenate, insert, delete, substitute,
            # or duplicate keys. Only the oracle decides which prefixes survive.
            keys = list(itertools.chain.from_iterable(code(pair, rng.choice(CHEATS))
                                                       for _ in range(rng.randrange(1, 4))))
            for _ in range(rng.randrange(4)):
                at = rng.randrange(len(keys)); change = rng.randrange(4)
                if change == 0: keys.insert(at, rng.randrange(1, 0x80))
                elif change == 1: del keys[at]
                elif change == 2: keys[at] = rng.randrange(1, 0x80)
                else: keys.insert(at, keys[at])
        w.word('InputDeviceMode', rng.choice((0, 2, 3, 0xFFFF))).byte('SfxEnabled', rng.randrange(256))
        events = [event(key) for key in keys]
        yield from driven(w, events + [event(mask=1)], f'random {i}', rng.randrange(4), rng.randrange(4))

MUTANTS = [
    ('pause.c', 'InputBits == IN_BUTTON_PRIMARY', '(InputBits & IN_BUTTON_PRIMARY) != 0'),
    ('pause.c', '(*entry)++;', '(*entry) += 2;'),
    ('pause.c', '*entry = (word)entry + 2;', '*entry = (word)entry + 3;'),
    ('pause.c', 'if (cursor[1] != 0) return 0;', 'if (cursor[1] == 0) return 0;'),
    ('pause.c', 'set_all_cheat_flags(0);', 'set_all_cheat_flags(1);'),
    ('pause.c', 'KeyLastMakeCode = 0;\n}', 'KeyLastMakeCode = 1;\n}'),
    ('pause.c', 'if (match_cheat_key(&CheatRemindMe)) set_all_cheat_flags(1);\n    if (match_cheat_key(&CheatEveryDayIDie)) set_all_cheat_flags(0);',
                'if (match_cheat_key(&CheatEveryDayIDie)) set_all_cheat_flags(0);\n    if (match_cheat_key(&CheatRemindMe)) set_all_cheat_flags(1);'),
    ('pause.c', '0x7004, PANEL_PAUSE_LOWER', '0x4804, PANEL_PAUSE_LOWER'),
    ('pause.c', 'pause_call_platform(FlipEgaDrawPage);\n    KeyLastMakeCode = 0;',
                'pause_call_platform(FlipEgaDrawPage);\n    KeyLastMakeCode = 1;'),
]
