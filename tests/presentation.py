"""Bounded differential cases for the C presentation proposal.

Install as tests/presentation.py after integrating presentation.c. The test-only
symbol aliases enter each C-owned DOS entry at the same point as its original
label; the two register-pair entries receive their BP/ES mailbox in stack scratch.
Resource, raster and clock services are controlled here, so no case loads a file,
waits for real time, or runs a complete title demo.
"""
from difftest import Case
from world import World, K
from emu import REG
from unicorn import UC_HOOK_CODE
from options import hook, cleanup, return_service, keys, check
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'presentation.c']
KEEP = ('SP', 'DS', 'SS')

# Same semantic entry on both images; the right-hand names are the C link symbols.
C_ENTRIES = {
    'RunIntroPagesAndDemo': 'RUN_INTRO_PAGES_AND_DEMO',
    'RunChooseScreen': 'RUN_CHOOSE_SCREEN',
    'DrawChooseScreen': 'DRAW_CHOOSE_SCREEN',
    'ShowLevelIntro': 'SHOW_LEVEL_INTRO',
    'DrawPlaqueImage': 'DRAW_PLAQUE_IMAGE',
    'DrawRecordsToWorkspace': 'RENDER_DRAW_RECORDS_TO_WORKSPACE',
    'RestoreRecordBackgrounds': 'RENDER_RESTORE_RECORD_BACKGROUNDS',
    'DrawStars': 'RENDER_DRAW_STARS',
    'EraseStars': 'RENDER_ERASE_STARS',
    'PrintMessageBP': 'TEXT_PRINT_MESSAGE',
    'DrawHud': 'DISPLAY_DRAW_HUD',
    'DrawScore': 'DISPLAY_DRAW_SCORE',
    'DrawLivesIcons': 'DISPLAY_DRAW_LIVES_ICONS',
    'DrawLevelNumber': 'DISPLAY_DRAW_LEVEL_NUMBER',
    'PollInputBits': 'POLL_INPUT_BITS',
    'LoadGraphicsRecordImages': 'LOAD_GRAPHICS_RECORD_IMAGES',
    'CheckBossKey': 'SYSTEM_CHECK_BOSS_KEY',
}


def install_entries(pair):
    saved = []
    for oracle_name, c_name in C_ENTRIES.items():
        key = oracle_name.upper()
        for side, target in ((pair.a, oracle_name.upper()), (pair.b, c_name)):
            prior = side.m.symbols.get(key)
            saved.append((side, key, prior))
            side.m.symbols[key] = side.m.symbols[target]
    return saved


def restore_entries(saved):
    for side, key, prior in reversed(saved):
        if prior is None:
            side.m.symbols.pop(key, None)
        else:
            side.m.symbols[key] = prior


def cs_slot(side, value):
    """Normalize MAIN-frame offsets that differ when the hybrid adds C code."""
    for name in ('ScreenImageOffset', 'ChooseImageOffsets'):
        if side.m.symbols.get(name.upper(), (None, None))[1] == value:
            return name
    return value


def check_pair_mailbox(pair, regs_out, bp, es, name):
    at = pair.sym('StackArea')
    c_bp = pair.b.m.word(at)
    c_es = pair.b.m.word(at + 2)
    oracle_es = es if regs_out['ES'] == 'unchanged' else regs_out['ES']
    check(c_bp == regs_out['BP'], f'{name}: C BP metadata matches oracle BP result')
    check(state_segment(pair.b, c_es) == state_segment(pair.a, oracle_es),
          f'{name}: C ES {c_es:04X} vs oracle ES {oracle_es:04X} '
          f'({state_segment(pair.b, c_es)!r} vs {state_segment(pair.a, oracle_es)!r})')


def registers(w, pair, bp=0x5151, es=0xB800):
    """A C DosRegisters argument in the unused stack area; oracle reads BP/ES."""
    at = pair.sym('StackArea')
    w.put(at, struct.pack('<HH', bp, es))
    return {'SI': at, 'BP': bp, 'ES': es}


def state_segment(side, value):
    if value == side.m.data_frame or value == side.m.peek('MainDataSegment'):
        return 'state segment'
    return value


def service_registers(side, pair, u):
    if side is pair.b:
        metadata = u.reg_read(REG['SI'])
        return side.m.word(metadata), side.m.word(metadata + 2)
    return u.reg_read(REG['BP']), u.reg_read(REG['ES'])


def service(side, bag, obs, pair, label, action=None, skip=True):
    actual = C_ENTRIES[label] if side is pair.b and label in C_ENTRIES else label
    def callback(u, address, size, _, side=side, obs=obs, label=label):
        obs['services'].append(label)
        if label in ('PrintMessageBP', 'DrawHud', 'DrawLivesIcons',
                     'DrawLevelNumber'):
            bp, es = service_registers(side, pair, u)
            obs.setdefault('bp_es_services', []).append(
                (label, (bp, state_segment(side, es))))
        if label in ('DrawStars', 'EraseStars') and side is pair.a:
            # The original wrappers leave ES on the workspace after either operation.
            u.reg_write(REG['ES'], side.m.peek('WorkspaceSegment'))
        if action:
            action(u, side, obs)
        if label == 'DrawScore':
            # DrawScore's incoming BP/ES are dead: its text routine establishes both.
            # Compare the observable output pair after the controlled text leaf runs.
            bp, es = service_registers(side, pair, u)
            obs.setdefault('bp_es_outputs', []).append(
                (label, (bp, state_segment(side, es))))
        if skip:
            return_service(side)
    hook(side, bag, UC_HOOK_CODE, callback, side.m.linear(actual))


def input_stream(side, bag, obs, pair, masks):
    def poll(u, address, size, _, side=side, obs=obs):
        index = obs['polls']
        check(index < len(masks), f"{obs['name']}: poll stream exhausted at {index}")
        side.m.write(pair.sym('KeyDownTable'), keys(masks[index]))
        obs['polls'] += 1
    actual = 'POLL_INPUT_BITS' if side is pair.b else 'PollInputBits'
    hook(side, bag, UC_HOOK_CODE, poll, side.m.linear(actual))


def prepare(pair):
    for side in (pair.a, pair.b):
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def chooser(w, slot, difficulty, name, *, masks=None, shown_slots=None):
    pair = w.pair
    bag, observed = [], []
    masks = tuple(masks if masks is not None else
                  (K.IN_BUTTON_PRIMARY, 0, 0, K.IN_BUTTON_PRIMARY))
    shown_slots = tuple(shown_slots if shown_slots is not None else (slot,))
    final_slot = shown_slots[-1]
    bp, es = 0x5151, 0xB800
    w.word('ChooseSlot', slot).word('DifficultySetting', difficulty)
    w.word('InputDeviceMode', K.INPUT_MODE_KEYS_A)
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    regs = registers(w, pair, bp, es)

    for side in (pair.a, pair.b):
        obs = dict(name=name, services=[], loads=[], positions=[], blits=[], polls=0)
        observed.append(obs)

        def loader(u, address, size, _, side=side, obs=obs):
            if side is pair.b:
                metadata = u.reg_read(REG['SI'])
                pair_in = (side.m.word(metadata), side.m.word(metadata + 2))
            else:
                pair_in = (u.reg_read(REG['BP']), u.reg_read(REG['ES']))
            obs.setdefault('bp_es_services', []).append(('LoadGraphicsRecordImages', pair_in))
            slot_ptr = side.m.peek('LoadImageSlot')
            cga7 = bytes(side.m.u.mem_read(side.m.linear('CgaColorMap') + 7, 1))[0]
            obs['loads'].append((side.m.peek('LoadNamePtr'),
                                 side.m.peek('LoadDestOffset'),
                                 side.m.peek('LoadDestSegment'), cs_slot(side, slot_ptr),
                                 side.m.read(pair.sym('LoadIsEnc'), 1)[0],
                                 side.m.word(pair.sym('ClearWorkspaceHalfOnly')),
                                 cga7))
            if side.m.peek('LoadDestOffset') == 0x8000:
                side.m.poke('ScreenImageOffset', 0x8000)
            else:
                side.m.u.mem_write(side.m.linear('ChooseImageOffsets'),
                                   struct.pack('<9H', *(0x2100 + 16 * i for i in range(9))))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, loader, side.m.linear('LoadGraphicsRecordImages'))

        if side is pair.a:
            def offset(u, address, size, _, obs=obs):
                obs['positions'].append(u.reg_read(REG['AX']))
            hook(side, bag, UC_HOOK_CODE, offset, side.m.linear('DrawOffsetFromScreenRow'))
        else:
            def image(u, address, size, _, obs=obs):
                obs['positions'].append(u.reg_read(REG['CX']))
            hook(side, bag, UC_HOOK_CODE, image, side.m.linear('PresentationDrawImage'))

        def blit(u, address, size, _, side=side, obs=obs):
            obs['blits'].append((u.reg_read(REG['DS']), u.reg_read(REG['SI']),
                                 u.reg_read(REG['DI'])))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, blit, side.m.linear('BlitPackedToScreen'))

        for label in ('ResetEgaPages', 'ClearTimerTick', 'FlipEgaDrawPage',
                      'ShowEgaDrawPage', 'WaitVerticalRetrace', 'WaitTimerTick'):
            service(side, bag, obs, pair, label)
        service(side, bag, obs, pair, 'DrawChooseScreen', skip=False)
        input_stream(side, bag, obs, pair, masks)
    prepare(pair)

    def done(m, regs_out):
        check(observed[0] == observed[1], f'{name}: resource, draw and input traces')
        obs = observed[0]
        check(len(obs['loads']) == 2, f'{name}: two bounded image loads')
        check([(entry[4], entry[5], entry[6]) for entry in obs['loads']] ==
              [(1, 0, 0), (1, 1, 1)], f'{name}: loader flags at each call')
        check(obs['polls'] == len(masks), f'{name}: bounded input poll count')
        expected_services = ['ResetEgaPages']
        for frame, _shown_slot in enumerate(shown_slots):
            expected_services.extend(('ClearTimerTick', 'FlipEgaDrawPage',
                                      'DrawChooseScreen', 'ShowEgaDrawPage',
                                      'WaitVerticalRetrace'))
            if frame + 1 < len(shown_slots):
                expected_services.append('WaitTimerTick')
        check(obs['services'] == expected_services,
              f'{name}: chooser page and frame service order {obs["services"]!r}')
        check(len(obs['blits']) == 3 * len(shown_slots),
              f'{name}: background and two markers for every shown frame')
        expected_positions = []
        for frame, shown_slot in enumerate(shown_slots):
            background, selected, selected_difficulty = obs['blits'][frame * 3:frame * 3 + 3]
            check(background[1] == 0x8000, f'{name}: frame {frame} background source offset')
            check(selected[1] == 0x2100 + 16 * shown_slot,
                  f'{name}: frame {frame} selected marker image')
            check(selected_difficulty[1] == 0x2100 + 16 * (6 + difficulty),
                  f'{name}: frame {frame} selected difficulty image')
            expected_positions.extend((m.word(pair.sym('ChooseSlotPositions') + shown_slot * 2),
                                       m.word(pair.sym('DifficultyPositions') + difficulty * 2)))
        check(obs['positions'] == expected_positions,
              f'{name}: packed row/column arguments')
        check(m.word(pair.sym('LevelIndex')) == (0xFFFF if final_slot == 5 else final_slot),
              f'{name}: LevelIndex mapping')
        check(m.read(pair.sym('LoadIsEnc'), 1) == b'\0', f'{name}: encrypted-loader flag restored')
        check(m.word(pair.sym('ClearWorkspaceHalfOnly')) == 0,
              f'{name}: half-clear flag restored')
        check(bytes(m.u.mem_read(m.linear('CgaColorMap') + 7, 1)) == b'\x01',
              f'{name}: CGA map restored')
    try:
        yield Case('RunChooseScreen', regs, w.writes(), KEEP,
                   expect=lambda m, regs_out: (done(m, regs_out),
                       check_pair_mailbox(pair, regs_out, bp, es, name)), name=name)
    finally:
        cleanup(pair, bag)


def plaque_and_intro(w, stop_after, name, video_adapter=None):
    pair = w.pair
    bag, observed = [], []
    prior_video = [side.m.peek('VideoAdapter') for side in (pair.a, pair.b)]
    if video_adapter is not None:
        for side in (pair.a, pair.b):
            side.m.poke('VideoAdapter', video_adapter)
    initial_stars = pair.a.pristine[pair.sym('Stars'):pair.sym('Stars') + 40 * 6]
    bp, es = 0x6262, 0xB800
    masks = [K.IN_BUTTON_PRIMARY, 0]
    if stop_after is None:
        masks.extend([0] * 201)
        expected_frames = 201
    else:
        masks.extend([0] * (stop_after - 1))
        masks.extend((K.IN_BUTTON_PRIMARY, 0))
        expected_frames = stop_after
    w.word('InputDeviceMode', K.INPUT_MODE_KEYS_A).word('LevelIntroFrames', 0xAAAA)
    w.word('RefuelActive', 0).word('DifficultySetting', 0)
    w.word('FrameCount128', 0).word('FrameCount32', 0).word('ExtraDrainToggle', 1)
    w.word('EncounterEndDelay', 0).word('EncounterLiveCount', 1)
    w.record('PrimaryRecord', 0).set(sprite=0)
    w.word('Fuel', 9).word('EnergyTanks', 2)
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    regs = registers(w, pair, bp, es)

    for side in (pair.a, pair.b):
        obs = dict(name=name, services=[], positions=[], blits=[], polls=0)
        observed.append(obs)
        input_stream(side, bag, obs, pair, masks)

        if side is pair.a:
            def offset(u, address, size, _, obs=obs):
                position = u.reg_read(REG['AX'])
                # Fuel-gauge placement is drawn through render.c in the hybrid, so its
                # internal coordinate helper is an implementation detail here. Keep
                # this trace focused on the plaque image argument under test.
                if position == 0x4703:
                    obs['positions'].append(position)
            hook(side, bag, UC_HOOK_CODE, offset, side.m.linear('DrawOffsetFromScreenRow'))
        else:
            def image(u, address, size, _, obs=obs):
                obs['positions'].append(u.reg_read(REG['CX']))
            hook(side, bag, UC_HOOK_CODE, image, side.m.linear('PresentationDrawImage'))

        def blit(u, address, size, _, side=side, obs=obs):
            obs['blits'].append((u.reg_read(REG['DS']), u.reg_read(REG['SI'])))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, blit, side.m.linear('BlitPackedToScreen'))

        def draw_stars(u, side=side, obs=obs):
            obs.setdefault('star_snapshots', []).append(
                side.m.read(pair.sym('Stars'), 40 * 6))
        service(side, bag, obs, pair, 'DrawStars', draw_stars)
        for label in ('ClearTimerTick', 'FlipEgaDrawPage',
                      'CopyWorkspaceToScreen', 'EraseStars', 'CheckBossKey',
                      'ShowEgaDrawPage', 'WaitTimerTick', 'WaitVerticalRetrace'):
            service(side, bag, obs, pair, label)
        def draw_score(u, side=side, obs=obs):
            if side is pair.b:
                metadata = u.reg_read(REG['SI'])
                side.m.set_word(metadata, pair.sym('ScoreBcd'))
                side.m.set_word(metadata + 2, side.m.peek('TextVideoSegment'))
            else:
                u.reg_write(REG['BP'], pair.sym('ScoreBcd'))
                u.reg_write(REG['ES'], side.m.peek('TextVideoSegment'))
        service(side, bag, obs, pair, 'DrawScore', draw_score)
        service(side, bag, obs, pair, 'DrawPlaqueImage', skip=False)
    prepare(pair)

    def done(m, regs_out):
        check(observed[0] == observed[1], f'{name}: intro frame trace mismatch')
        obs = observed[0]
        check(m.word(pair.sym('LevelIntroFrames')) == expected_frames,
              f'{name}: intro frame count')
        frame_services = ['ClearTimerTick', 'FlipEgaDrawPage', 'DrawStars']
        if video_adapter == K.VIDEO_EGA:
            frame_services.append('CopyWorkspaceToScreen')
        frame_services.extend(('DrawPlaqueImage', 'EraseStars', 'CheckBossKey',
                               'DrawScore', 'ShowEgaDrawPage', 'WaitTimerTick',
                               'WaitVerticalRetrace'))
        check(obs['services'] == ['CopyWorkspaceToScreen'] + frame_services * expected_frames,
              f'{name}: level-intro frame service order')
        check(obs['star_snapshots'][0] == initial_stars,
              f'{name}: stars render before their first movement')
        check(len(obs['blits']) == expected_frames, f'{name}: one plaque image per frame')
        check(obs['positions'].count(0x4703) == expected_frames,
              f'{name}: plaque row 47h, column 3')
        plaque_segment = m.peek('PlaqueSegment')
        check(obs['blits'] == [(plaque_segment, 0)] * expected_frames,
              f'{name}: plaque segment and first image source')
        check(obs['polls'] == (4 if stop_after == 1 else
                               2 + (stop_after - 1) + 2 if stop_after is not None else 203),
              f'{name}: bounded input polling')
    try:
        yield Case('ShowLevelIntro', regs, w.writes(), KEEP,
                   expect=lambda m, regs_out: (done(m, regs_out),
                       check_pair_mailbox(pair, regs_out, bp, es, name)), name=name)
    finally:
        cleanup(pair, bag)
        for side, adapter in zip((pair.a, pair.b), prior_video):
            side.m.poke('VideoAdapter', adapter)


def interrupted_bonus_page(w, name):
    pair = w.pair
    bag, observed = [], []
    w.word('InputDeviceMode', K.INPUT_MODE_KEYS_A).byte('KeyLastMakeCode', 0)
    w.word('DemoStep', 0xCAFE).word('DemoActive', 0)
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))

    for side in (pair.a, pair.b):
        obs = dict(name=name, services=[], positions=[], blits=[], captions=[], polls=0, retraces=0)
        observed.append(obs)
        input_stream(side, bag, obs, pair, (0,))

        def offset(u, address, size, _, side=side, obs=obs):
            obs['positions'].append(u.reg_read(REG['AX']))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, offset, side.m.linear('DrawOffsetFromScreenRow'))

        def blit(u, address, size, _, side=side, obs=obs):
            obs['blits'].append((u.reg_read(REG['DS']), u.reg_read(REG['SI'])))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, blit, side.m.linear('BlitPackedToScreen'))

        def caption(u, address, size, _, side=side, obs=obs):
            bp, es = service_registers(side, pair, u)
            obs['captions'].append((bp, state_segment(side, es)))
            return_service(side)
        actual_text = C_ENTRIES['PrintMessageBP'] if side is pair.b else 'PrintMessageBP'
        hook(side, bag, UC_HOOK_CODE, caption, side.m.linear(actual_text))

        def retrace(u, side=side, obs=obs):
            obs['retraces'] += 1
            side.m.write(pair.sym('KeyLastMakeCode'), bytes((K.SCAN_C,)))
        service(side, bag, obs, pair, 'ResetEgaPages')
        service(side, bag, obs, pair, 'ResetPageAndClearScreen')
        service(side, bag, obs, pair, 'ClearWorkspace')
        service(side, bag, obs, pair, 'WaitVerticalRetrace', retrace)
    prepare(pair)

    def done(m, regs_out):
        check(observed[0] == observed[1], f'{name}: first item and common cleanup')
        obs = observed[0]
        check(obs['polls'] == 1 and obs['retraces'] == 1, f'{name}: stops after first retrace')
        check(len(obs['captions']) == len(obs['blits']) == len(obs['positions']) == 1,
              f'{name}: exactly one bonus panel and caption')
        check(m.word(pair.sym('DemoStep')) == 0xCAFE, f'{name}: demo setup was skipped')
        check(m.word(pair.sym('DemoActive')) == 0, f'{name}: demo flag cleared on interrupted exit')
        check(m.read(pair.sym('KeyLastMakeCode'), 1)[0] == K.SCAN_C,
              f'{name}: make-code remains available to the caller')
        check(obs['services'].count('ResetPageAndClearScreen') == 2,
              f'{name}: common exit resets the page')
        check(obs['services'].count('ClearWorkspace') == 1,
              f'{name}: common exit clears the workspace')
    try:
        yield Case('RunIntroPagesAndDemo', {'ES': 0}, w.writes(), KEEP,
                   expect=done, name=name)
    finally:
        cleanup(pair, bag)


def one_demo_frame(w, name):
    pair = w.pair
    bag, observed = [], []
    prior_video = [side.m.peek('VideoAdapter') for side in (pair.a, pair.b)]
    for side in (pair.a, pair.b):
        # Make the native upgrade renderer bounded to its four single-page slots.
        side.m.poke('VideoAdapter', K.VIDEO_CGA)
    w.word('InputDeviceMode', K.INPUT_MODE_KEYS_A).byte('KeyLastMakeCode', 0)
    w.word('DemoFireCycle', 0x1234).word('DemoStep', 0xCAFE)
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    masks = (0,) * 401  # 400 bonus-page polls, then the demo-frame poll.

    for side in (pair.a, pair.b):
        obs = dict(name=name, services=[], polls=0, bonus_blits=0,
                   captions=0, retraces=0, wait_ticks=0, demo_active_at_draw=[])
        observed.append(obs)
        input_stream(side, bag, obs, pair, masks)

        def offset(u, address, size, _, side=side, obs=obs):
            obs['bonus_positions'].append(u.reg_read(REG['AX']))
        obs['bonus_positions'] = []
        hook(side, bag, UC_HOOK_CODE, offset, side.m.linear('DrawOffsetFromScreenRow'))

        def blit(u, address, size, _, side=side, obs=obs):
            if side.m.word(pair.sym('DemoActive')) == 1:
                obs['demo_blits'] = obs.get('demo_blits', 0) + 1
                obs.setdefault('demo_blit_args', []).append(
                    (u.reg_read(REG['DS']), u.reg_read(REG['SI']), u.reg_read(REG['DI'])))
            else:
                obs['bonus_blits'] += 1
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, blit, side.m.linear('BlitPackedToScreen'))

        def text(u, address, size, _, side=side, obs=obs):
            bp, es = service_registers(side, pair, u)
            obs.setdefault('caption_registers', []).append(
                (bp, state_segment(side, es)))
            obs['captions'] += 1
            return_service(side)
        actual_text = C_ENTRIES['PrintMessageBP'] if side is pair.b else 'PrintMessageBP'
        hook(side, bag, UC_HOOK_CODE, text, side.m.linear(actual_text))

        def retrace(u, side=side, obs=obs):
            obs['retraces'] += 1
        service(side, bag, obs, pair, 'WaitVerticalRetrace', retrace)

        def draw_records(u, side=side, obs=obs):
            obs['demo_active_at_draw'].append(side.m.word(pair.sym('DemoActive')))
            result = side.m.word(pair.sym('PoolAPointers'))
            if side is pair.b:
                u.reg_write(REG['AX'], result)
            else:
                u.reg_write(REG['BP'], result)
                u.reg_write(REG['ES'], side.m.peek('WorkspaceSegment'))
        for label in ('ResetEgaPages', 'ResetPageAndClearScreen',
                      'CgaSelectBrightPalette1', 'ClearWorkspace', 'DrawStatusPanel',
                      'ClearTimerTick', 'FlipEgaDrawPage', 'CopyWorkspaceToScreen',
                      'CheckBossKey', 'ShowEgaDrawPage'):
            service(side, bag, obs, pair, label)
        service(side, bag, obs, pair, 'DrawRecordsToWorkspace', draw_records)

        def restore_records(u, side=side, obs=obs):
            result = side.m.word(pair.sym('PoolAPointers'))
            if side is pair.b:
                u.reg_write(REG['AX'], result)
            else:
                u.reg_write(REG['BP'], result)
                u.reg_write(REG['ES'], side.m.peek('WorkspaceSegment'))
        service(side, bag, obs, pair, 'RestoreRecordBackgrounds', restore_records)

        def timer(u, side=side, obs=obs):
            obs['wait_ticks'] += 1
            side.m.write(pair.sym('KeyLastMakeCode'), bytes((K.SCAN_C,)))
        service(side, bag, obs, pair, 'WaitTimerTick', timer)
    prepare(pair)

    def done(m, regs_out):
        check(observed[0] == observed[1],
              f'{name}: page setup and one demo frame {observed[0]!r} != {observed[1]!r}')
        obs = observed[0]
        check(obs['polls'] == 401 and obs['retraces'] == 400,
              f'{name}: four 100-frame page intervals and one bounded demo frame')
        check(obs['bonus_blits'] == 4 and obs['captions'] == 4,
              f'{name}: four bonus images and captions')
        check(obs['wait_ticks'] == 1 and obs.get('demo_blits') == 13,
              f'{name}: one demo frame and four native three-image upgrade slots')
        check(len(obs['demo_blit_args']) == 13,
              f'{name}: twelve slot-panel blits and one first-frame packed image')
        check(obs['demo_active_at_draw'] == [1], f'{name}: demo state active during frame')
        check(m.word(pair.sym('DemoStep')) == 0 and
              m.word(pair.sym('DemoStepTimer')) == 0x64,
              f'{name}: first script rise step retains its countdown')
        check(m.word(pair.sym('PrimaryRecord') + K.REC_Y) == 0xBF,
              f'{name}: first script frame raises the ship one pixel')
        check(m.word(pair.sym('DemoFireCycle')) == 0x1234,
              f'{name}: demo fire-cycle state is retained until its active phase')
        check(m.word(pair.sym('DemoActive')) == 0, f'{name}: common demo cleanup')
        check(m.read(pair.sym('KeyLastMakeCode'), 1)[0] == K.SCAN_C,
              f'{name}: injected make-code survives exit')
    try:
        yield Case('RunIntroPagesAndDemo', {'ES': 0}, w.writes(), KEEP,
                   expect=done, name=name)
    finally:
        cleanup(pair, bag)
        for side, adapter in zip((pair.a, pair.b), prior_video):
            side.m.poke('VideoAdapter', adapter)


def cases(rng, scale, pair):
    saved = install_entries(pair)
    try:
        for slot in range(6):
            for difficulty in range(3):
                w = World(pair, rng).plausible()
                yield from chooser(w, slot, difficulty, f'choice slot {slot}, difficulty {difficulty}')
        w = World(pair, rng).plausible()
        yield from chooser(w, 0, 0, 'navigation redraw after a nonconfirming frame',
                           masks=(K.IN_BUTTON_PRIMARY, 0, 0, K.IN_YPLUS, 0,
                                  K.IN_BUTTON_PRIMARY), shown_slots=(0, 1))
        for stop_after in (1, 2, 17, 200, None):
            w = World(pair, rng).plausible()
            label = '201-frame cap' if stop_after is None else f'input after frame {stop_after}'
            yield from plaque_and_intro(w, stop_after, label)
        yield from plaque_and_intro(World(pair, rng).plausible(), 1,
                                    'EGA copies each intro draw page', K.VIDEO_EGA)
        w = World(pair, rng).plausible()
        yield from interrupted_bonus_page(w, 'interrupt first bonus page')
        w = World(pair, rng).plausible()
        yield from one_demo_frame(w, 'stop after first demo frame')
    finally:
        restore_entries(saved)


MUTANTS = [
    ('presentation.c', 'volatile byte *keys = (volatile byte *)&KeyLastMakeCode;',
     'volatile byte *keys = (volatile byte *)KeyLastMakeCode;'),
    ('presentation.c', 'if ((InputBits & IN_BUTTON_PRIMARY) != 0 || *keys != 0) goto exit_demo;',
     'if ((InputBits & IN_BUTTON_PRIMARY) != 0) goto exit_demo;'),
    ('presentation.c', 'item < 4', 'item < 3'),
    ('presentation.c', 'if (selected == 6) selected = 0;',
     'if (selected == 5) selected = 0;'),
    ('presentation.c', 'if (LevelIntroFrames > 0xC8) break;',
     'if (LevelIntroFrames >= 0xC8) break;'),
    ('presentation.c', 'DemoActive = 0;', 'DemoActive = 1;'),
    ('presentation.c', 'dos_service(WaitTimerTick, registers);\n        dos_service(WaitVerticalRetrace, registers);\n        LevelIntroFrames++;',
     'dos_service(WaitVerticalRetrace, registers);\n        dos_service(WaitTimerTick, registers);\n        LevelIntroFrames++;'),
]
