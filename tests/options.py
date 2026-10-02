"""Options, key redefinition and choice input through their remaining ASM entries.

Input changes at corresponding key/poll boundaries; panel blits, music requests,
page-list control and keyboard-release scans run through their respective real implementations. Resource loading,
retrace, calibration and presentation have explicit bounded test boundaries. This
checks menu control and its service calls, not file loading or hardware timing.
"""
from difftest import Case
from world import World, K
from emu import REG
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
import hybrid
import itertools
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'options.c']
FREE = ('SP', 'DS', 'SS')
CONTROL_KEYS = ((K.IN_XPLUS, K.SCAN_RIGHT), (K.IN_XMINUS, K.SCAN_LEFT),
                (K.IN_YPLUS, K.SCAN_DOWN), (K.IN_YMINUS, K.SCAN_UP),
                (K.IN_BUTTON_PRIMARY, K.SCAN_SPACE), (K.IN_BUTTON_SECONDARY, K.SCAN_TAB))
BINDINGS = (K.SCAN_G, K.SCAN_H, K.SCAN_C, K.SCAN_B, K.SCAN_V, K.SCAN_N)
C_ENTRIES = {
    'RunAttractSequence': 'RUN_ATTRACT_SEQUENCE',
    'WaitAllKeysReleased': 'SYSTEM_WAIT_ALL_KEYS_RELEASED',
    'ShowPageList': 'SHOW_PAGE_LIST',
    'LoadAndShowPage': 'LOAD_AND_SHOW_PAGE',
    'ShowHighScoreTable': 'SHOW_HIGH_SCORE_TABLE',
    'PollJoystickPrimaryOrAbort': 'POLL_JOYSTICK_PRIMARY_OR_ABORT',
    'PollJoystickInputBits': 'POLL_JOYSTICK_INPUT_BITS',
    'CalibrateJoystickWithAbort': 'CALIBRATE_JOYSTICK_WITH_ABORT',
}

def check(value, message):
    if not value: raise AssertionError(message)

def base(w):
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    w.put('KeyBitScancodesA', bytes(K.KEY_BIT_SCANCODE_COUNT))
    w.put('KeyBitScancodesB', bytes(K.KEY_BIT_SCANCODE_COUNT))
    w.word('InputDeviceMode', 0).word('SoundOption', 2)
    w.byte('SfxEnabled', 1).byte('SfxRequest', 0x53)
    w.byte('ModuleSoundEnabled', 1).byte('ModuleSoundRequest', 7).byte('SoundModuleLoaded', 0)
    w.word('MenuKeyLatchK', 0).word('MenuKeyLatchA', 0).word('MenuKeyLatchM', 0)
    w.word('MenuIdleFrames', 0xA5).word('MenuShowingHiscores', 0xA5)
    w.word('ChooseSlot', 0).word('DifficultySetting', 1)
    return w

def keys(mask=0, menu=(), state=K.KEY_STATE_DOWN):
    data = bytearray(K.KEY_DOWN_COUNT)
    for bit, scan in CONTROL_KEYS:
        if mask & bit: data[scan] = state
    for scan in menu: data[scan] = state
    return bytes(data)

def return_service(side, far=False):
    u = side.m.u; sp = u.reg_read(REG['SP']); ss = u.reg_read(REG['SS'])
    data = bytes(u.mem_read(ss * 16 + sp, 4 if far else 2))
    u.reg_write(REG['IP'], struct.unpack_from('<H', data)[0])
    if far: u.reg_write(REG['CS'], struct.unpack_from('<H', data, 2)[0])
    u.reg_write(REG['SP'], (sp + (4 if far else 2)) & 0xFFFF)

def hook(side, bag, kind, callback, begin, end=None):
    bag.append((side, side.m.u.hook_add(kind, callback, None, begin, begin if end is None else end)))

def cleanup(pair, bag):
    for side, handle in bag: side.m.u.hook_del(handle)
    for side in (pair.a, pair.b): side.m.u.ctl_remove_cache(side.image[0], side.image[1])

def menu(w, events, name, hold=2, abort=False, bindings=BINDINGS, shutdown=False, expect=None,
         real_abort=False, real_presentation=False):
    pair = w.pair; bag = []; observed = []; calibration_sp = []
    initial_abort_sp = 0xA554
    if real_abort: w.word('JoyCalAbortSp', initial_abort_sp)
    saved_mask = pair.mask
    if real_abort:
        # This dormant stack address naturally moves with the C call frame. The
        # real abort must save/restore its own entry SP; assert that on each side.
        mask = bytearray(pair.mask); at = pair.sym('JoyCalAbortSp'); mask[at:at + 2] = b'\1\1'
        pair.mask = bytes(mask)
    for side in (pair.a, pair.b):
        obs = dict(polls=0, phase='release', trace=[], releases={}, prompt=0, make_reads=0,
                   capture_key=0, capture_release=0, page_reads=0, esc_reads=0, joy_polls=0)
        observed.append(obs)
        at_key = side.m.data_frame * 16 + pair.sym('KeyDownTable')
        make_at = side.m.data_frame * 16 + pair.sym('KeyLastMakeCode')
        def read_keys(u, access, address, size, value, _, side=side, obs=obs, at_key=at_key):
            scan = address - at_key
            if obs['phase'] == 'release': return
            if obs['phase'] == 'capture':
                if scan == obs['capture_key']:
                    obs['capture_release'] += 1
                    if obs['capture_release'] > hold:
                        side.m.write(pair.sym('KeyDownTable') + scan, b'\0')
                        obs['phase'] = 'menu'
                return
            if obs['phase'] == 'page':
                if scan == K.SCAN_ESC:
                    obs['page_reads'] += 1
                    if obs['page_reads'] > 1:
                        side.m.write(pair.sym('KeyDownTable') + scan, b'\0'); obs['phase'] = 'menu'
                return
            if obs['phase'] == 'abort':
                if scan == K.SCAN_ESC:
                    obs['esc_reads'] += 1
                    if obs['esc_reads'] > hold + 1:
                        side.m.write(pair.sym('KeyDownTable') + scan, b'\0'); obs['phase'] = 'menu'
                return
            if scan == K.SCAN_K:
                i = obs['polls']; obs['polls'] += 1; obs['releases'] = {}
                check(i < len(events), f'{name}: menu exhausted input stream')
                side.m.write(pair.sym('KeyDownTable'), events[i])
            elif scan in (K.SCAN_J, K.SCAN_R):
                n = obs['releases'].get(scan, 0) + 1; obs['releases'][scan] = n
                if n > hold + 1: side.m.write(pair.sym('KeyDownTable') + scan, b'\0')
        def make_code(u, access, address, size, value, _, side=side, obs=obs):
            if obs['phase'] != 'capture': return
            # Each rejected value spans its actual comparison sequence. The final
            # accepted make is read four times for validation and once for storage.
            stream = (0, K.SCAN_F9, K.SCAN_F9, K.SCAN_F10, K.SCAN_F10, K.SCAN_F10,
                      K.SCAN_ESC, K.SCAN_ESC, K.SCAN_ESC, K.SCAN_ESC)
            n = obs['make_reads']; obs['make_reads'] += 1
            scan = stream[n] if n < len(stream) else obs['capture_key']
            side.m.write(pair.sym('KeyLastMakeCode'), bytes((scan,)))
        def service(label, far=False, action=None, skip=True):
            def callback(u, address, size, _, side=side, obs=obs):
                if action: action(u, side, obs)
                else: obs['trace'].append((label,))
                if skip:
                    # C replacements return from near calls; the oracle services
                    # retain their original far-entry return shape.
                    return_service(side, far and side is pair.a)
            entry = C_ENTRIES.get(label, label) if side is pair.b else label
            hook(side, bag, UC_HOOK_CODE, callback, side.m.linear(entry))
        def wait_keys(u, side, obs):
            obs['trace'].append(('release all',))
            obs['phase'] = 'release'
            side.m.write(pair.sym('KeyDownTable'), bytes(K.KEY_DOWN_COUNT))
        service('WaitAllKeysReleased', True, wait_keys, False)
        def pages(u, side, obs):
            pointer = u.reg_read(REG['AX' if side is pair.a else 'SI']); obs['trace'].append(('page', pointer))
            obs['phase'] = 'menu'
            if side.m.word(pointer - 2):
                obs['phase'] = 'page'; obs['page_reads'] = 0
                side.m.write(pair.sym('KeyDownTable'), keys(menu=(K.SCAN_ESC,)))
        service('ShowPageList', True, pages, False)
        service('LoadAndShowPage')
        def retrace(u, side, obs):
            obs['trace'].append(('retrace', side.m.word(pair.sym('MenuIdleFrames')),
                                 side.m.word(pair.sym('MenuShowingHiscores'))))
        service('WaitVerticalRetrace', action=retrace)
        service('ShowHighScoreTable', skip=not real_presentation)
        service('RunAttractSequence', skip=not real_presentation)
        if real_presentation:
            def interrupt_title(u, side, obs):
                # A make code after the backdrop interrupts the real title code
                # before it can enter the attract demo's gameplay loop.
                side.m.write(pair.sym('KeyLastMakeCode'), bytes((K.SCAN_C,)))
            service('DrawTitleBackdrop', action=interrupt_title, skip=False)
            def reject_demo(u, address, size, _, side=side):
                raise AssertionError('title interruption must skip demo gameplay')
            entry = ('RUN_INTRO_PAGES_AND_DEMO' if side is pair.b else 'RunIntroPagesAndDemo')
            hook(side, bag, UC_HOOK_CODE, reject_demo, side.m.linear(entry))
        service('ShowBossKeyScreen')
        def calibrate(u, side, obs):
            obs['trace'].append(('calibrate',))
            if real_abort:
                calibration_sp.append((side, u.reg_read(REG['SP'])))
                return
            side.m.set_word(pair.sym('InputDeviceMode'), 0 if abort else 1)
            side.m.write(pair.sym('KeyDownTable'), keys(menu=(K.SCAN_ESC,) if abort else ()))
            if abort: obs['phase'] = 'abort'; obs['esc_reads'] = 0
        service('CalibrateJoystickWithAbort', action=calibrate, skip=not real_abort)
        if real_abort:
            def abort_calibration(u, side, obs):
                obs['phase'] = 'abort'; obs['esc_reads'] = 0
                side.m.write(pair.sym('KeyDownTable') + K.SCAN_ESC, b'\1')
            service('PollJoystickPrimaryOrAbort', action=abort_calibration, skip=False)
        def joystick(u, side, obs):
            obs['joy_polls'] += 1
            primary = side.m.read(pair.sym('KeyDownTable') + K.SCAN_SPACE, 1)[0]
            side.m.write(pair.sym('InputBits'), bytes((K.IN_BUTTON_PRIMARY if primary else 0,)))
        service('PollJoystickInputBits', action=joystick)
        def music(u, side, obs): obs['trace'].append(('music', u.reg_read(REG['AX']) & 0xFF))
        service('RequestModuleMusic', action=music, skip=False)
        service('StopModuleMusic', skip=False)
        def panel(u, side, obs):
            obs['trace'].append(('panel', u.reg_read(REG['AX']), u.reg_read(REG['SI'])))
        service('DrawPanelGraphic', action=panel, skip=False)
        def prompt(u, address, size, _, side=side, obs=obs):
            obs['trace'].append(('prompt', u.reg_read(REG['SI']), u.reg_read(REG['DI'])))
            check(obs['prompt'] < len(bindings), 'six key prompts')
            obs['capture_key'] = bindings[obs['prompt']]; obs['prompt'] += 1
            obs.update(phase='capture', make_reads=0, capture_release=0)
            side.m.write(pair.sym('KeyDownTable') + obs['capture_key'], bytes((0xFF,)))
        entry = 'PromptAndCaptureKeyBinding' if side is pair.a else 'PROMPT_AND_CAPTURE_KEY_BINDING'
        hook(side, bag, UC_HOOK_CODE, prompt, side.m.linear(entry))
        def exit_game(u, address, size, _, side=side, obs=obs):
            check(shutdown, 'unexpected DOS termination')
            obs['trace'].append(('shutdown',))
            u.reg_write(REG['IP'], 0xFFFE)
            u.emu_stop()
        hook(side, bag, UC_HOOK_CODE, exit_game, side.m.linear('ShutdownGame'))
        hook(side, bag, UC_HOOK_MEM_READ, read_keys, at_key, at_key + K.KEY_DOWN_COUNT - 1)
        hook(side, bag, UC_HOOK_MEM_READ, make_code, make_at)
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        if observed[0] != observed[1]:
            deltas = {key: (observed[0].get(key), observed[1].get(key))
                      for key in set(observed[0]) | set(observed[1])
                      if observed[0].get(key) != observed[1].get(key)}
            raise AssertionError(f'{name}: menu input/service trace mismatch: {deltas!r}')
        check(observed[0]['polls'] == len(events), 'menu ends at the supplied confirm/exit event')
        if real_abort:
            check(len(calibration_sp) == 2, 'both real calibration entries reached')
            for side, sp in calibration_sp:
                expected = sp if side is pair.a else initial_abort_sp
                check(side.m.word(pair.sym('JoyCalAbortSp')) == expected,
                      'only the legacy ASM calibration entry updates the stack mailbox')
        if expect: expect(m, observed[0])
    try:
        yield Case('RunOptionsMenu', {}, w.writes(), ('DS', 'SS') if shutdown else FREE,
                   expect=done, name=name)
    finally:
        cleanup(pair, bag)
        pair.mask = saved_mask

def choose(w, masks, name, initial_hold=0, cycle=0, expect=None):
    pair = w.pair; bag = []; observed = []
    for side in (pair.a, pair.b):
        obs = dict(phase='initial', d_reads=0, polls=0, events=[])
        observed.append(obs)
        def d_key(u, access, address, size, value, _, side=side, obs=obs):
            if obs['phase'] == 'initial':
                obs['d_reads'] += 1
                down = obs['d_reads'] <= initial_hold
                side.m.write(pair.sym('KeyDownTable') + K.SCAN_D, bytes((1 if down else 0,)))
                if not down: obs['phase'] = 'release'
            elif obs['phase'] == 'choice':
                side.m.write(pair.sym('KeyDownTable') + K.SCAN_D, bytes((cycle,)))
        def poll(u, address, size, _, side=side, obs=obs):
            i = obs['polls']; obs['polls'] += 1
            check(i < len(masks), f'{name}: choose input stream exhausted')
            mask = masks[i]; obs['events'].append(mask)
            side.m.write(pair.sym('KeyDownTable'), keys(mask))
            if obs['phase'] == 'release' and mask == 0: obs['phase'] = 'choice'
        at = side.m.data_frame * 16 + pair.sym('KeyDownTable') + K.SCAN_D
        hook(side, bag, UC_HOOK_MEM_READ, d_key, at)
        entry = 'PollInputBits' if side is pair.a else 'POLL_INPUT_BITS'
        hook(side, bag, UC_HOOK_CODE, poll, side.m.linear(entry))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        check(observed[0] == observed[1], 'matching choice input consumption')
        if expect: expect(m, observed[0])
    try:
        yield Case('ReadChooseScreenInput', {}, w.writes(), FREE, expect=done, name=name)
    finally: cleanup(pair, bag)

def cases(rng, scale, pair):
    undo = []
    for side in (pair.a, pair.b):
        bank = side.m.peek('PanelSegment') * 16
        for image in range(0x40, 0x56):
            offset = image * 16
            data = struct.pack('<HH', 1, 1) + bytes((image, image ^ 0xFF, image, image))
            for at, payload in ((side.m.linear('PanelImageOffsets') + image * 2, struct.pack('<H', offset)),
                                (bank + offset, data)):
                undo.append((side, at, bytes(side.m.u.mem_read(at, len(payload)))))
                side.m.u.mem_write(at, payload)
    try:
        yield from menu_cases(rng, scale, pair)
        yield from choose_cases(rng, scale, pair)
    finally:
        for side, at, data in reversed(undo): side.m.u.mem_write(at, data)

def menu_cases(rng, scale, pair):
    for mode, sound, enabled in itertools.product((0, 1, 2, 3, 0xAB02), (0, 1, 2, 3, 0xAB03, 0xFFFF), (0, 1, 0xFF)):
        w = base(World(pair, rng)).word('InputDeviceMode', mode).word('SoundOption', sound).byte('SfxEnabled', enabled)
        yield from menu(w, [keys(K.IN_BUTTON_PRIMARY)], f'initial mode {mode} sound {sound} sfx {enabled}')
    for scan, latch in ((K.SCAN_K, 'MenuKeyLatchK'), (K.SCAN_A, 'MenuKeyLatchA'), (K.SCAN_M, 'MenuKeyLatchM')):
        for value, sound, enabled in itertools.product((0, 1, 2, 0xFFFF), (0, 1, 2, 3, 0xFFFF), (0, 1)):
            w = base(World(pair, rng)).word(latch, value).word('SoundOption', sound).byte('SfxEnabled', enabled)
            events = [keys(menu=(scan,)), keys(menu=(scan,)), keys(), keys(menu=(scan,)), keys(K.IN_BUTTON_PRIMARY)]
            yield from menu(w, events, f'latch {scan}={value} sound {sound} sfx {enabled}')
    for scan, state in itertools.product((K.SCAN_O, K.SCAN_I, K.SCAN_F9, K.SCAN_R), (1, 2, 0xFF)):
        w = base(World(pair, rng))
        yield from menu(w, [keys(menu=(scan,), state=state), keys(K.IN_BUTTON_PRIMARY)], f'page/redefine {scan} state {state}')
    for a, b in itertools.combinations((K.SCAN_K, K.SCAN_J, K.SCAN_A, K.SCAN_R,
                                         K.SCAN_M, K.SCAN_O, K.SCAN_I, K.SCAN_F9), 2):
        w = base(World(pair, rng))
        yield from menu(w, [keys(menu=(a, b)), keys(K.IN_BUTTON_PRIMARY)], f'menu key priority {a}/{b}')
    for abort, enabled, hold in itertools.product((False, True), (0, 1), (0, 3)):
        w = base(World(pair, rng)).byte('SfxEnabled', enabled)
        yield from menu(w, [keys(menu=(K.SCAN_J,)), keys(K.IN_BUTTON_PRIMARY)],
                        f'joystick abort {abort} sfx {enabled} hold {hold}', hold=hold, abort=abort)
    for enabled, hold in itertools.product((0, 1), (0, 3)):
        w = base(World(pair, rng)).byte('SfxEnabled', enabled)
        yield from menu(w, [keys(menu=(K.SCAN_J,)), keys(K.IN_BUTTON_PRIMARY)],
                        f'real calibration abort sfx {enabled} hold {hold}', hold=hold, real_abort=True)
    w = base(World(pair, rng))
    yield from menu(w, [keys(K.IN_BUTTON_PRIMARY | K.IN_YMINUS), keys(K.IN_BUTTON_PRIMARY)], 'primary alone only')
    for scan in (K.SCAN_K, K.SCAN_A, K.SCAN_M):
        w = base(World(pair, rng))
        yield from menu(w, [keys()] * 750 + [keys(menu=(scan,)), keys(K.IN_BUTTON_PRIMARY)], f'hiscores key {scan}')
    w = base(World(pair, rng))
    yield from menu(w, [keys()] * 1500 + [keys(K.IN_BUTTON_PRIMARY)], '750/750 attract cycle',
                    expect=lambda m, obs: check(('RunAttractSequence',) in obs['trace'], 'attract after second idle phase'))
    w = base(World(pair, rng)).word('TextInGraphics', 1)
    yield from menu(w, [keys()] * 1500 + [keys(K.IN_BUTTON_PRIMARY)], 'real hiscores and interrupted title',
                    real_presentation=True)
    w = base(World(pair, rng))
    yield from menu(w, [keys(menu=(K.SCAN_ESC,))], 'DOS exit boundary', shutdown=True)
    for i in range(150 * scale):
        w = base(World(pair, rng)).word('SoundOption', rng.randrange(0x10000)).byte('SfxEnabled', rng.randrange(256))
        for name in ('MenuKeyLatchK', 'MenuKeyLatchA', 'MenuKeyLatchM'): w.word(name, rng.choice((0, 1, 2, 0xFFFF)))
        events = [keys(menu=tuple(rng.sample((K.SCAN_K, K.SCAN_A, K.SCAN_M), rng.randrange(4))))
                  for _ in range(rng.randrange(1, 20))]
        yield from menu(w, events + [keys(K.IN_BUTTON_PRIMARY)], f'random menu {i}')

def choose_cases(rng, scale, pair):
    for slot, high, mask, mode in itertools.product(range(6), (0, 0xAB00), range(64), (0, 2)):
        w = base(World(pair, rng)).word('ChooseSlot', high | slot).word('InputDeviceMode', mode)
        yield from choose(w, [K.IN_BUTTON_PRIMARY, 0, mask, K.IN_BUTTON_PRIMARY],
                          f'choose slot {high | slot} mask {mask} mode {mode}', initial_hold=2,
                          expect=lambda m, obs, high=high: check(m.word(pair.sym('ChooseSlot')) & 0xFF00 == high,
                                                                'choice high byte survives'))
    for difficulty, cycle, hold in itertools.product((0, 1, 2, 3, 0xFFFF), (1, 2, 0xFF), (0, 3)):
        w = base(World(pair, rng)).word('DifficultySetting', difficulty)
        yield from choose(w, [0, K.IN_BUTTON_PRIMARY], f'difficulty {difficulty} D {cycle} hold {hold}', hold, cycle)

MUTANTS = [
    ('options.c', 'InputBits == IN_BUTTON_PRIMARY) return;', '(InputBits & IN_BUTTON_PRIMARY) != 0) return;'),
    ('options.c', 'MenuKeyLatchM == 1', 'MenuKeyLatchM != 0'),
    ('options.c', 'MenuIdleFrames >= 0x2EE', 'MenuIdleFrames > 0x2EE'),
    ('options.c', 'SoundOption = (SoundOption + 1) & 3;', 'SoundOption = (SoundOption + 1) & 1;'),
    ('options.c', 'if (*make == SCAN_F9) continue;', 'if (*make == SCAN_F9) break;'),
    ('options.c', 'RedefPromptRow += 0x17;', 'RedefPromptRow += 0x16;'),
    ('options.c', '((byte *)&ChooseSlot)[0] = slot;', 'ChooseSlot = slot;'),
    ('options.c', 'if (slot >= 3) continue;', 'if (slot > 3) continue;'),
    ('options.c', 'if (DifficultySetting >= 3)', 'if (DifficultySetting > 3)'),
    ('options.c', 'KeyBitScancodesB[KEY_SLOT_SECONDARY] = KeyBitScancodesA[KEY_SLOT_SECONDARY];',
                  'KeyBitScancodesB[KEY_SLOT_SECONDARY] = KeyBitScancodesA[KEY_SLOT_PRIMARY];'),
    ('options.c', '0x4C + (SoundOption == 3)', '0x4C + (SoundOption == 0xAB03)'),
]
