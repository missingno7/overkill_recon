"""Bounded slices of the continuous session driver against its ASM jump entries.

Stop at the next frame or options entry, never running a full game. Service traces
compare request priority, setup order, frame tails and nonlocal state transitions.
The runtime has one StartNewGame bridge; alternate phase entries are test aliases
of that bridge with the C phase argument injected before its prologue.
"""
from difftest import Case
from world import World, K
from emu import REG, LOAD
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
from options import hook, cleanup, return_service, check
from pathlib import Path
import hybrid
import itertools
import re
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'session.c']
PHASES = dict((n, int(v)) for n, v in re.findall(r'#define (SESSION_\w+) (\d+)',
              (Path(__file__).parents[1] / 'c/session.h').read_text()))
ENTRIES = dict(zip(('StartNewGame', 'CompleteLevel', 'AdvanceLevel', 'StartLife', 'GameFrame',
                   'ResumeGameFrame', 'QuitPrompt', 'GameOver', 'ForceGameOver', 'LoseLife'),
                  ('SESSION_NEW_GAME', 'SESSION_COMPLETE_LEVEL', 'SESSION_ADVANCE_LEVEL',
                   'SESSION_START_LIFE', 'SESSION_FRAME', 'SESSION_RESUME_FRAME', 'SESSION_QUIT_PROMPT',
                   'SESSION_GAME_OVER', 'SESSION_FORCE_GAME_OVER', 'SESSION_LOSE_LIFE')))
C_ENTRIES = {'RunChooseScreen': 'RUN_CHOOSE_SCREEN', 'ShowLevelIntro': 'SHOW_LEVEL_INTRO', 'UpdateHighScoreTable': 'UPDATE_HIGH_SCORE_TABLE', 'RunOptionsMenu': 'RUN_OPTIONS_MENU', 'ResetPoolAAndUpgrades': 'RESET_POOL_A_AND_UPGRADES',
             'ScrollMapToLevelStart': 'SCROLL_MAP_TO_LEVEL_START', 'TickRefuel': 'TICK_REFUEL',
             'InitPositionHistory': 'INIT_POSITION_HISTORY',
             'StoreApplyHistoryAndConditionalPlacement': 'STORE_APPLY_HISTORY_AND_PLACEMENT',
             'UpdateAllRecords': 'UPDATE_ALL_RECORDS', 'UpdatePlayerFrame': 'UPDATE_PLAYER_FRAME',
             'UpdateRefuelTimersAndScore': 'FRAME_UPDATE_REFUEL_TIMERS_AND_SCORE', 'PauseGame': 'PAUSE_GAME',
             'ShowWinScreenAndWaitPrimary': 'SHOW_WIN_SCREEN_AND_WAIT_PRIMARY',
             'ResetRecordsForLife': 'RESET_RECORDS_FOR_LIFE',
             'ResetInvaderFormation': 'RESET_INVADER_FORMATION',
             'RequestLifeStartMusic': 'REQUEST_LIFE_START_MUSIC',
             'LoadLevelMap': 'LOAD_LEVEL_MAP', 'LoadLevelGraphics': 'LOAD_LEVEL_GRAPHICS',
             'RedrawStatusPanel': 'SYSTEM_REDRAW_STATUS_PANEL',
             'CheckBossKey': 'SYSTEM_CHECK_BOSS_KEY',
             'CollapseScreenWithSfx': 'SCREEN_TRANSITION_WITH_SFX',
             'StretchInHudPanel': 'SCREEN_ANIMATION_STRETCH_HUD_PANEL',
             'StretchInTheEndImage': 'SCREEN_ANIMATION_STRETCH_END',
             'DrawHud': 'DISPLAY_DRAW_HUD',
             'ApplyLevelPalette': 'DISPLAY_APPLY_LEVEL_PALETTE',
             'DrawRecordsToWorkspace': 'RENDER_DRAW_RECORDS_TO_WORKSPACE',
             'RestoreRecordBackgrounds': 'RENDER_RESTORE_RECORD_BACKGROUNDS'}
DIRECT_REGISTER_SERVICES = {'LoadLevelMap', 'LoadLevelGraphics',
                            'RedrawStatusPanel', 'CheckBossKey',
                            'ApplyLevelPalette', 'CollapseScreenWithSfx',
                            'StretchInHudPanel', 'StretchInTheEndImage'}

def canonical_es(side, segment):
    # The oracle and hybrid place StateData at different link-time segment values.
    return 'StateData' if segment == side.m.data_frame else segment

def base(pair, rng):
    return (World(pair, rng).plausible().word('LivesLeft', 2).word('LevelIndex', 1)
            .word('NextLevelRequest', 0).word('GameOverRequest', 0).word('LifeLostRequest', 0)
            .word('MapScrollPos', K.MAP_START_POS).word('Fuel', 12)
            .byte('SfxEnabled', 1).byte('SfxActive', 7).byte('SfxRequest', 0x55)
            .byte('KeepLivesFlag', 0).byte('LevelSkipEnabled', 0)
            .put('KeyDownTable', bytes(K.KEY_DOWN_COUNT)))

def render_world(pair, rng, count=0):
    w = base(pair, rng).word('TextInGraphics', 1).word('MapScrollPos', K.MAP_START_POS + 16)
    w.record('PrimaryRecord', 0).set(save_buffer=pair.sym('PoolASaveBuffers'), size_class=2, draw_pass=1)
    for i in range(K.POOL_A_COUNT):
        w.record('PoolA', i).set(save_buffer=pair.sym('PoolASaveBuffers') + (K.POOL_A_COUNT - i) * K.POOL_A_SAVE_BYTES)
    for i in range(K.POOL_B_COUNT):
        w.record('PoolB', i).set(save_buffer=pair.sym('PoolBSaveBuffers') + (K.POOL_B_COUNT - 1 - i) * K.POOL_B_SAVE_BYTES)
    for i in range(count):
        w.record('PoolA', i).set(status=1, kind=K.KIND_ENEMY, type=0x48 if i % 2 else 0x1D,
                                size_class=1, y=0x20 + 16 * (i % 3), x=8 + 12 * i,
                                saved_y=0x50, saved_x=0x60, hit_points=5, slot_index=0xFFFF,
                                draw_pass=i % 2, direction=K.DIR_DOWN)
    return w

def driven(w, label, name, requests=(0, 0, 0), frame_keys=(), answer=((1, 0),),
           esc_hold=0, esc_release=0, busy=0, chosen=0, stop_menu=False,
           frame_limit=None, after_pause=(), expect=None, real=False):
    pair = w.pair; bag = []; observed = []
    original_symbols = dict(pair.b.m.symbols)
    for entry in ENTRIES: pair.b.m.symbols[entry.upper()] = pair.b.m.symbols['STARTNEWGAME']
    limit = frame_limit if frame_limit is not None else (2 if label == 'GameFrame' else 1)
    key_data = bytearray(K.KEY_DOWN_COUNT)
    for scan, state in frame_keys: key_data[scan] = state
    w.put('KeyDownTable', bytes(key_data))
    for side in (pair.a, pair.b):
        obs = dict(trace=[], frames=0, esc_reads=0, answers=0, busy_reads=0, bp_es=[])
        observed.append(obs)
        caller_cs = LOAD + side.m.symbols[label.upper()][0]
        def end(u, side, obs, caller_cs=caller_cs):
            u.reg_write(REG['CS'], caller_cs)
            u.reg_write(REG['IP'], 0xFFFE)
            u.emu_stop()
        if side is pair.b and label != 'StartNewGame':
            def entry(u, address, size, _, phase=PHASES[ENTRIES[label]]): u.reg_write(REG['SI'], phase)
            hook(side, bag, UC_HOOK_CODE, entry, side.m.linear('RUN_GAME_SESSION'))
        def service(label, action=None, skip=True):
            actual = C_ENTRIES.get(label, label) if side is pair.b else label
            def callback(u, address, size, _, side=side, obs=obs, label=label):
                obs['trace'].append((label, side.m.word(pair.sym('LevelIndex')),
                                     side.m.word(pair.sym('LivesLeft')), side.m.word(pair.sym('Fuel')),
                                     side.m.read(pair.sym('SfxRequest'), 1)[0]))
                if label in DIRECT_REGISTER_SERVICES:
                    if side is pair.b:
                        metadata = u.reg_read(REG['SI'])
                        bp_value, es_value = side.m.word(metadata), side.m.word(metadata + 2)
                    else:
                        bp_value, es_value = u.reg_read(REG['BP']), u.reg_read(REG['ES'])
                    # CheckBossKey reads F9 first. With F9 up it does not consume ES;
                    # when F9 is down its redraw path establishes its own segments.
                    registers = (bp_value,) if label == 'CheckBossKey' else \
                                (bp_value, canonical_es(side, es_value))
                    obs['bp_es'].append((label, registers))
                if action: action(u, side, obs)
                if skip and not obs.get('stopped'): return_service(side)
            hook(side, bag, UC_HOOK_CODE, callback, side.m.linear(actual))
        def clear(u, side, obs):
            obs['frames'] += 1
            if obs['frames'] == limit:
                obs['stopped'] = True; end(u, side, obs)
        service('ClearTimerTick', clear)
        def menu(u, side, obs):
            if stop_menu: obs['stopped'] = True; end(u, side, obs)
        service('RunOptionsMenu', menu)
        def choose(u, side, obs): side.m.set_word(pair.sym('LevelIndex'), chosen)
        service('RunChooseScreen', choose)
        def bp_result(u, side, bp, es=None):
            u.reg_write(REG['BP'] if side is pair.a else REG['AX'], bp)
            if es is not None and side is pair.a: u.reg_write(REG['ES'], es)
        def set_register_pair(u, side, bp, es):
            if side is pair.a:
                u.reg_write(REG['BP'], bp)
                u.reg_write(REG['ES'], es)
            else:
                metadata = u.reg_read(REG['SI'])
                side.m.set_word(metadata, bp)
                side.m.set_word(metadata + 2, es)
        def hud(u, side, obs):
            set_register_pair(u, side, pair.sym('ScoreBcd'), 0xB800)
        service('DrawHud', hud)
        def load_graphics(u, side, obs):
            if side is pair.b:
                registers = u.reg_read(REG['SI'])
                side.m.set_word(registers, pair.sym('PrimaryRecord'))
                side.m.set_word(registers + 2, 0x4000)
            else:
                u.reg_write(REG['BP'], pair.sym('PrimaryRecord'))
                u.reg_write(REG['ES'], 0x4000)
        service('LoadLevelGraphics', load_graphics)
        def scroll(u, side, obs):
            pointer = u.reg_read(REG['BP'] if side is pair.a else REG['SI'])
            obs['trace'].append(('scroll anchor', pointer))
            side.m.set_word(pair.sym('MapScrollPos'), K.MAP_START_POS)
        service('ScrollMapToLevelStart', scroll, not real)
        def reset(u, side, obs):
            side.m.set_word(pair.sym('RandomWordCursor'), pair.sym('CreditRandomWords') + 4)
            side.m.set_word(pair.sym('NextLevelRequest'), 0)
            side.m.set_word(pair.sym('LifeLostRequest'), 0)
            if side is pair.a:
                u.reg_write(REG['BP'], pair.sym('PrimaryRecord'))
                u.reg_write(REG['ES'], side.m.data_frame)
        service('ResetRecordsForLife', None if real else reset, not real)
        service('ResetPoolAAndUpgrades', skip=not real)
        service('TickRefuel', skip=not real)
        def history(u, side, obs):
            if side is pair.a:
                u.reg_write(REG['BP'], pair.sym('PrimaryRecord')); u.reg_write(REG['ES'], side.m.data_frame)
        service('InitPositionHistory', None if real else history, not real)
        def placement(u, side, obs):
            pointer = u.reg_read(REG['BP'] if side is pair.a else REG['SI'])
            obs['trace'].append(('placement anchor', pointer))
            if side is pair.a: u.reg_write(REG['ES'], side.m.data_frame)
        service('StoreApplyHistoryAndConditionalPlacement', placement, not real)
        def records(u, side, obs):
            bp_result(u, side, pair.sym('PoolB') + (K.POOL_B_COUNT - 1) * K.RECORD_SIZE)
            side.m.set_word(pair.sym('RandomWordCursor'), pair.sym('CreditRandomWords') + 6)
        service('UpdateAllRecords', None if real else records, not real)
        def player(u, side, obs):
            for field, value in zip(('NextLevelRequest', 'GameOverRequest', 'LifeLostRequest'), requests):
                side.m.set_word(pair.sym(field), value)
            bp_result(u, side, pair.sym('PrimaryRecord'))
        service('UpdatePlayerFrame', None if real else player, not real)
        def timers(u, side, obs):
            set_register_pair(u, side, pair.sym('ScoreBcd'), side.m.peek('MainDataSegment'))
        service('UpdateRefuelTimersAndScore', None if real else timers, not real)
        def pause(u, side, obs):
            for scan, state in after_pause: side.m.write(pair.sym('KeyDownTable') + scan, bytes((state,)))
        service('PauseGame', pause)
        def draw_records(u, side, obs):
            first_record = side.m.word(pair.sym('PoolAPointers'))
            if side is pair.b:
                if not real: u.reg_write(REG['AX'], first_record)
            else:
                u.reg_write(REG['ES'], side.m.peek('WorkspaceSegment'))
                u.reg_write(REG['BP'], first_record)
        service('DrawRecordsToWorkspace', draw_records, not real)
        def fuel_panel(u, side, obs):
            obs['trace'].append(('fuel panel ES', u.reg_read(REG['ES'])))
        service('DrawFuelEmptyPanel', fuel_panel)
        def backgrounds(u, side, obs):
            first_record = side.m.word(pair.sym('PoolAPointers'))
            if side is pair.b:
                if not real: u.reg_write(REG['AX'], first_record)
            else:
                u.reg_write(REG['BP'], first_record)
                u.reg_write(REG['ES'], side.m.peek('WorkspaceSegment'))
        service('RestoreRecordBackgrounds', backgrounds, not real)
        for item in ('CgaSelectBrightPalette1', 'ResetEgaPages', 'StretchInHudPanel',
                     'ResetPageAndClearScreen', 'RedrawStatusPanel', 'ClearScreen104x200', 'LoadLevelMap',
                     'ApplyLevelPalette', 'ShowLevelIntro',
                     'FlipEgaDrawPage', 'CopyWorkspaceToScreen', 'CheckBossKey', 'ShowEgaDrawPage',
                     'WaitTimerTick', 'FlushBiosKeyboardBuffer', 'CollapseScreenWithSfx',
                     'StretchInTheEndImage', 'WaitVerticalRetrace', 'UpdateHighScoreTable',
                     'ShowWinScreenAndWaitPrimary'):
            service(item)
        def life_music(u, side, obs):
            if side is pair.b: u.reg_write(REG['AX'], u.reg_read(REG['SI']))
        service('RequestLifeStartMusic', None if real else life_music, not real)
        service('ResetInvaderFormation', skip=not real)
        def music(u, side, obs): obs['trace'].append(('music', u.reg_read(REG['AX']) & 0xFF))
        service('RequestModuleMusic', music)
        # Compare the real packed-panel renderer on both sides; the C side uses
        # SessionDrawQuitPrompt to supply the original position/image arguments.
        def panel(u, side, obs):
            obs['trace'].append(('quit panel', u.reg_read(REG['DI']), u.reg_read(REG['SI'])))
        service('BlitPackedToScreen', panel, False)
        key_at = side.m.data_frame * 16 + pair.sym('KeyDownTable')
        def escape(u, access, address, size, value, _, side=side, obs=obs, key_at=key_at):
            obs['esc_reads'] += 1
            # Keep the initial frame's decision separate from release waiting.
            hold = esc_hold + (1 if label == 'GameFrame' else 0)
            state = 1 if obs['esc_reads'] <= hold else esc_release
            if label == 'GameFrame' and obs['esc_reads'] == 1:
                state = next((v for scan, v in after_pause or frame_keys if scan == K.SCAN_ESC), 0)
            side.m.write(pair.sym('KeyDownTable') + K.SCAN_ESC, bytes((state,)))
        def yes_no(u, access, address, size, value, _, side=side, obs=obs):
            at = min(obs['answers'], len(answer) - 1); obs['answers'] += 1
            n, y = answer[at]
            side.m.write(pair.sym('KeyDownTable') + K.SCAN_N, bytes((n,)))
            side.m.write(pair.sym('KeyDownTable') + K.SCAN_Y, bytes((y,)))
        def idle_sfx(u, access, address, size, value, _, side=side, obs=obs):
            obs['busy_reads'] += 1
            side.m.write(pair.sym('SfxActive'), bytes((7 if obs['busy_reads'] <= busy else 0,)))
        hook(side, bag, UC_HOOK_MEM_READ, escape, key_at + K.SCAN_ESC)
        hook(side, bag, UC_HOOK_MEM_READ, yes_no, key_at + K.SCAN_N)
        hook(side, bag, UC_HOOK_MEM_READ, idle_sfx, side.m.data_frame * 16 + pair.sym('SfxActive'))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        if observed[0] != observed[1]:
            a, b = observed[0]['trace'], observed[1]['trace']
            at = next((i for i, values in enumerate(itertools.zip_longest(a, b)) if values[0] != values[1]), None)
            detail = f'trace event {at}: {a[at:at+1]} != {b[at:at+1]}' if at is not None else 'input/wait consumption'
            counters = {key: (observed[0].get(key), observed[1].get(key))
                        for key in sorted(set(observed[0]) | set(observed[1]))
                        if observed[0].get(key) != observed[1].get(key)}
            raise AssertionError(f'{name}: matching session trace: {detail}; '
                                 f'observed differences={counters}; '
                                 f'left trace={a!r}; right trace={b!r}')
        if expect: expect(m, observed[0])
    try:
        # run_game_session has no ES input; seed the oracle with the same dead value.
        yield Case(label, {'BP': pair.sym('PrimaryRecord'), 'ES': 0}, w.writes(),
                   ('DS', 'SS'), expect=done, name=name)
    finally:
        cleanup(pair, bag)
        pair.b.m.symbols = original_symbols

def cases(rng, scale, pair):
    undo = []
    for side in (pair.a, pair.b):
        bank = side.m.peek('PanelSegment') * 16
        at = side.m.linear('PanelImageOffsets') + K.PANEL_QUIT_PROMPT * 2
        offset = 0x700
        for address, data in ((at, struct.pack('<H', offset)),
                              (bank + offset, struct.pack('<HH', 1, 1) + b'\x81\x42\x24\x18')):
            undo.append((side, address, bytes(side.m.u.mem_read(address, len(data)))))
            side.m.u.mem_write(address, data)
    try:
        for chosen in (0, 1, 2, 3, 4, 0xFFFF):
            for sound in (0, 1, 0xFF):
                w = (base(pair, rng).byte('SfxEnabled', sound).word('NewGameClearedWord', 0xAA55)
                     .word('GameOverRequest', 0x3333).word('LivesLeft', 0xFFFE)
                     .put('ScoreBcd', struct.pack('<I', 0x98765432)))
                yield from driven(w, 'StartNewGame',
                                  f'new chosen {chosen} sfx {sound}', chosen=chosen)
        for label in ('CompleteLevel', 'AdvanceLevel'):
            for level, sound in itertools.product((0, 1, 4, 5, 6, 0xFFFE, 0xFFFF), (0, 1, 0xFF)):
                yield from driven(base(pair, rng).word('LevelIndex', level).byte('SfxEnabled', sound),
                                  label, f'{label} {level}/{sound}')
        for lives, position in itertools.product((0, 1, 2, 0xFFFE, 0xFFFF),
                                                  (K.MAP_START_POS, K.MAP_START_POS - 1, 0)):
            yield from driven(base(pair, rng).word('LivesLeft', lives).word('MapScrollPos', position),
                              'StartLife', f'life {lives}/{position}', stop_menu=lives == 0xFFFF)
        for label in ('LoseLife', 'ForceGameOver'):
            for lives, keep, sound, busy in itertools.product((0, 1, 0xFFFE, 0xFFFF), (0, 1, 0xFF), (0, 1), (0, 3)):
                over = keep == 0 and (label == 'ForceGameOver' or lives == 0)
                yield from driven(base(pair, rng).word('LivesLeft', lives).byte('KeepLivesFlag', keep)
                                  .byte('SfxEnabled', sound), label, f'{label} {lives}/{keep}/{sound}/{busy}',
                                  busy=busy, stop_menu=over)
        for requests in itertools.product((0, 1, 2, 0xFFFF), repeat=3):
            for fuel in (0, 12):
                over = requests[0] != 1 and requests[1] == 1
                yield from driven(base(pair, rng).word('Fuel', fuel), 'GameFrame', f'requests {requests}/{fuel}',
                                  requests=requests, stop_menu=over)
        for skip, f4, f10, esc in itertools.product((0, 1, 0xFF), (0, 1, 2), (0, 1, 2), (0, 1, 2)):
            yield from driven(base(pair, rng).byte('LevelSkipEnabled', skip), 'GameFrame',
                              f'keys {skip}/{f4}/{f10}/{esc}',
                              frame_keys=((K.SCAN_F4, f4), (K.SCAN_F10, f10), (K.SCAN_ESC, esc)))
        for n, y, sound, hold, busy in itertools.product((0, 1, 2), (0, 1, 2), (0, 1), (0, 3), (0, 3)):
            answer = ((n, y), (1, 0))
            yield from driven(base(pair, rng).byte('SfxEnabled', sound), 'QuitPrompt',
                              f'quit {n}/{y}/{sound}/{hold}/{busy}', answer=answer, esc_hold=hold,
                              busy=busy, stop_menu=n != 1 and y == 1)
        yield from driven(base(pair, rng), 'GameOver', 'game over restart', stop_menu=True)
        yield from driven(base(pair, rng), 'ResumeGameFrame', 'resume without an extra update')
        yield from driven(base(pair, rng), 'GameFrame', 'pause raises escape',
                          frame_keys=((K.SCAN_F10, 1),), after_pause=((K.SCAN_ESC, 1),))
        for keep in (1, 0xFF):
            yield from driven(base(pair, rng).byte('KeepLivesFlag', keep), 'GameFrame',
                              f'forced game over repeats with keep-lives {keep}', requests=(0, 1, 0),
                              frame_limit=4, busy=3)
        for i in range(100 * scale):
            requests = tuple(rng.choice((0, 0, 1, 2, 0xFFFF)) for _ in range(3))
            yield from driven(base(pair, rng).word('Fuel', rng.randrange(2) * 12), 'GameFrame', f'random {i}',
                              requests=requests, stop_menu=requests[0] != 1 and requests[1] == 1)
        # Raised-boundary integration: use actual record reset, refuel, history,
        # player/record updates, timers and record rendering for several frames.
        for label in ('StartLife', 'GameFrame'):
            for position in (K.MAP_START_POS, K.MAP_START_POS + 16):
                w = render_world(pair, rng).word('MapScrollPos', position)
                yield from driven(w, label, f'real {label}/{position}', real=True, frame_limit=4)
        for count, mask in itertools.product((1, 6, 12), ((), ((K.SCAN_RIGHT, 1), (K.SCAN_SPACE, 1)))):
            yield from driven(render_world(pair, rng, count), 'GameFrame', f'populated {count}/{mask}',
                              real=True, frame_keys=mask, frame_limit=9, stop_menu=True)
        for chosen in (0, 0xFFFF):
            yield from driven(render_world(pair, rng), 'StartNewGame', f'real new game {chosen}',
                              real=True, chosen=chosen, frame_limit=3)
        yield from driven(render_world(pair, rng, 12), 'GameFrame', 'populated scrolling/fire',
                          real=True, frame_keys=((K.SCAN_UP, 1), (K.SCAN_RIGHT, 1), (K.SCAN_SPACE, 1)),
                          frame_limit=9, stop_menu=True)
    finally:
        for side, at, data in reversed(undo): side.m.u.mem_write(at, data)

MUTANTS = [
    ('session.c', 'GameOverRequest = 0;', 'GameOverRequest = 1;'),
    ('session.c', 'LivesLeft = INITIAL_LIVES;', 'LivesLeft = INITIAL_LIVES - 1;'),
    ('session.c', 'for (i = 0; i < 4; i++) ScoreBcd[i] = 0;', 'for (i = 0; i < 3; i++) ScoreBcd[i] = 0;'),
    ('session.c', 'if (LevelIndex >= LEVEL_COUNT)', 'if (LevelIndex > LEVEL_COUNT)'),
    ('session.c', 'if (LivesLeft == 0xFFFF)', 'if (LivesLeft == 0)'),
    ('session.c', 'if (Fuel == 0)', 'if (Fuel != 0)'),
    ('session.c', 'NextLevelRequest == 1', 'NextLevelRequest != 0'),
    ('session.c', 'if (GameOverRequest == 1) { phase = SESSION_FORCE_GAME_OVER; break; }\n            if (LifeLostRequest == 1) { phase = SESSION_LOSE_LIFE; break; }',
                  'if (LifeLostRequest == 1) { phase = SESSION_LOSE_LIFE; break; }\n            if (GameOverRequest == 1) { phase = SESSION_FORCE_GAME_OVER; break; }'),
    ('session.c', 'LevelSkipEnabled != 0 && keys[SCAN_F4] == KEY_STATE_DOWN',
                  'LevelSkipEnabled != 0 && keys[SCAN_F4] != 0'),
    ('session.c', 'if (KeepLivesFlag != 0) LivesLeft++;', 'if (KeepLivesFlag == 1) LivesLeft++;'),
    ('session.c', 'frame < 150', 'frame < 149'),
    ('session.c', "if (keys[SCAN_N] == KEY_STATE_DOWN) break;", "if (keys[SCAN_N] == KEY_STATE_DOWN && keys[SCAN_Y] != KEY_STATE_DOWN) break;"),
    ('session.c', 'if (MapScrollPos == MAP_START_POS)', 'if (MapScrollPos != MAP_START_POS)'),
    ('session.c', 'RandomWordCursor = (word)CreditRandomWords;', 'RandomWordCursor = (word)CreditRandomWords + 2;'),
    ('dos.c', 'registers->bp = (word)result;', 'registers->bp = 0;'),
    ('dos.c', 'registers->es = (word)(result >> 16);', 'registers->es = 0;'),
]
