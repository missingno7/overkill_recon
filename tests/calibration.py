"""Joystick calibration through bounded input, port, retrace, and renderer services.

The suite enters only CalibrateJoystickWithAbort in the exact oracle and hybrid. The
page controller stays live with a bounded LoadAndShowPage hook. Set real_panel=True
only after the emulator has a valid PanelSegment/image fixture.
"""
from difftest import Case
from world import World, K
from emu import REG
from options import hook, cleanup, return_service, check
from unicorn import UC_HOOK_CODE
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'calibration.c']
FREE = ('SP', 'DS', 'SS')
ENTRY_BP, ENTRY_ES = 0x5151, 0xB800
PAGE_BP, PAGE_ES = 0x6201, 0xA100
PANEL_ES = (0xA201, 0xA202)
C_ENTRIES = {
    'CalibrateJoystickWithAbort': 'CALIBRATE_JOYSTICK_WITH_ABORT',
    'LoadAndShowPage': 'LOAD_AND_SHOW_PAGE',
    'PollJoystickInputBits': 'POLL_JOYSTICK_INPUT_BITS',
}

# Deliberately nonmonotonic unsigned samples. Both high/low midpoint expressions
# cross 16-bit wrap boundaries, and odd deltas check the original SHR truncation.
WRAP_SAMPLES = ((0x0020, 0xFFF0), (0x0010, 0x0005), (0xFFF0, 0xFFFC))
RELEASE_INPUTS = (0x10, 0, 0x30, 0, 0x10, 0)
PRESS_INPUTS = (0x20, 0x01, 0x11, 0x20, 0x10, 0x01, 0x10)


def midpoint(a, b):
    return (a + (((b - a) & 0xFFFF) >> 1)) & 0xFFFF


def seed(rng, pair):
    """Make omitted writes and partial abort updates visible."""
    w = World(pair, rng)
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    w.byte('InputBits', 0xA5).word('InputDeviceMode', 0xA551)
    w.word('PageIndex', 0xA561).word('PageListPtr', 0xA562)
    w.byte('JoyCalUnusedByte', 0xA7).word('JoyCalibratingFlag', 0xA552)
    w.word('JoyButtonSelect', 0xA553).word('JoyCalAbortSp', 0xA554)
    w.put('StackArea', struct.pack('<HH', ENTRY_BP, ENTRY_ES))
    for i, name in enumerate(('JoyCalLowX', 'JoyCalLowY', 'JoyCalHighX', 'JoyCalHighY',
                              'JoyCalCenterX', 'JoyCalCenterY', 'JoyXLowThreshold',
                              'JoyXHighThreshold', 'JoyYLowThreshold', 'JoyYHighThreshold')):
        w.word(name, 0xB100 + 0x111 * i + rng.randrange(0x100))
    return w


def draw_trace(side, bag, obs, real_panel=False):
    """Observe DrawPanelGraphic; default to a deterministic ES-changing service stub.

    real_panel=True leaves the routine live and requires a valid packed-panel fixture.
    """
    def panel(u, address, size, _, side=side, obs=obs):
        n = len(obs['panels'])
        check(n < 2, 'calibration draws exactly two prompt panels at most')
        ax, si, es = u.reg_read(REG['AX']), u.reg_read(REG['SI']), u.reg_read(REG['ES'])
        obs['panel_es_in'].append(es)
        if real_panel:
            obs['panels'].append((ax, si, None))
            return
        obs['panels'].append((ax, si, PANEL_ES[n]))
        u.reg_write(REG['ES'], PANEL_ES[n])
        return_service(side)

    hook(side, bag, UC_HOOK_CODE, panel, side.m.linear('DrawPanelGraphic'))
def calibration_case(w, name, release_inputs, press_inputs, axes,
                     abort_at=None, esc_during_release=False, real_panel=False,
                     legacy_bridge=False):
    """One bounded execution with hooks at the original service entry points.

    abort_at=(group, attempt) sets Esc on that PollJoystickPrimaryOrAbort call. Groups
    1..3 are the low/high/center press loops; attempt allows Esc after rejected input.
    """
    pair = w.pair
    bag, observed = [], []
    saved_mask = pair.mask
    mask = bytearray(pair.mask)
    mailbox = pair.sym('JoyCalAbortSp')
    mask[mailbox:mailbox + 2] = b'\1\1'
    pair.mask = bytes(mask)

    for side in (pair.a, pair.b):
        obs = dict(entry_sp=None, phase='release', release_index=0, press_attempts={},
                   release_at=0, press_at=0, axis_at=0, retraces=0, retrace_mark=0,
                   release_periods=[], raw_release=[], raw_press=[], axes=[], panels=[], panel_es_in=[],
                   page=[], press_entries=[], ignored_esc=False)
        observed.append(obs)

        def entry(u, address, size, _, obs=obs):
            check(obs['entry_sp'] is None, f'{name}: calibration entered once')
            obs['entry_sp'] = u.reg_read(REG['SP'])
        entry_label = ('CalibrateJoystickWithAbort' if side is pair.a or legacy_bridge
                       else C_ENTRIES['CalibrateJoystickWithAbort'])
        hook(side, bag, UC_HOOK_CODE, entry, side.m.linear(entry_label))

        def load_page(u, address, size, _, side=side, obs=obs):
            if side is pair.b:
                metadata = u.reg_read(REG['SI'])
                before = (side.m.word(metadata), side.m.word(metadata + 2))
            else:
                metadata = None
                before = (u.reg_read(REG['BP']), u.reg_read(REG['ES']))
            obs['page'].append((side.m.word(pair.sym('PageListPtr')),
                                side.m.word(pair.sym('PageIndex')), before, (PAGE_BP, PAGE_ES)))
            if metadata is not None:
                side.m.set_word(metadata, PAGE_BP)
                side.m.set_word(metadata + 2, PAGE_ES)
            else:
                u.reg_write(REG['BP'], PAGE_BP)
                u.reg_write(REG['ES'], PAGE_ES)
            return_service(side)
        page_entry = C_ENTRIES['LoadAndShowPage'] if side is pair.b else 'LoadAndShowPage'
        hook(side, bag, UC_HOOK_CODE, load_page, side.m.linear(page_entry))

        def primary_poll(u, address, size, _, side=side, obs=obs):
            group = obs['axis_at'] + 1
            attempt = obs['press_attempts'].get(group, 0) + 1
            obs['press_attempts'][group] = attempt
            obs['phase'] = 'press'
            if attempt == 1:
                obs['release_periods'].append(obs['retraces'] - obs['retrace_mark'])
                obs['retrace_mark'] = obs['retraces']
            esc = side.m.read(pair.sym('KeyDownTable') + K.SCAN_ESC, 1)[0]
            if esc_during_release and group == 1 and esc == K.KEY_STATE_DOWN:
                obs['ignored_esc'] = True
            should_abort = abort_at == (group, attempt)
            side.m.write(pair.sym('KeyDownTable') + K.SCAN_ESC,
                         bytes((K.KEY_STATE_DOWN if should_abort else K.KEY_STATE_UP,)))
            obs['press_entries'].append((group, attempt, should_abort))
        entry_name = ('PollJoystickPrimaryOrAbort' if side is pair.a
                      else 'POLL_JOYSTICK_PRIMARY_OR_ABORT')
        hook(side, bag, UC_HOOK_CODE, primary_poll, side.m.linear(entry_name))

        def joystick_input(u, address, size, _, side=side, obs=obs):
            if obs['phase'] == 'release':
                check(obs['release_at'] < len(release_inputs), f'{name}: release input exhausted')
                bits = release_inputs[obs['release_at']]
                obs['release_at'] += 1
                obs['raw_release'].append(bits)
                if esc_during_release and obs['release_index'] == 0:
                    side.m.write(pair.sym('KeyDownTable') + K.SCAN_ESC, bytes((K.KEY_STATE_DOWN,)))
                if (bits & K.IN_BUTTON_PRIMARY) == 0:
                    obs['release_index'] += 1
            else:
                check(obs['press_at'] < len(press_inputs), f'{name}: press input exhausted')
                bits = press_inputs[obs['press_at']]
                obs['press_at'] += 1
                obs['raw_press'].append(bits)
            side.m.write(pair.sym('InputBits'), bytes((bits & 0xFF,)))
            return_service(side)
        poll_entry = (C_ENTRIES['PollJoystickInputBits'] if side is pair.b
                      else 'PollJoystickInputBits')
        hook(side, bag, UC_HOOK_CODE, joystick_input, side.m.linear(poll_entry))

        def retrace(u, address, size, _, side=side, obs=obs):
            obs['retraces'] += 1
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, retrace, side.m.linear('WaitVerticalRetrace'))

        def read_axes(u, address, size, _, side=side, obs=obs):
            check(obs['axis_at'] < len(axes), f'{name}: axis input exhausted')
            check(side.m.read(pair.sym('InputBits'), 1)[0] == K.IN_BUTTON_PRIMARY,
                  f'{name}: accepted press leaves exactly IN_BUTTON_PRIMARY')
            bx, cx = axes[obs['axis_at']]
            obs['axes'].append((bx, cx))
            obs['axis_at'] += 1
            obs['phase'] = 'release'
            u.reg_write(REG['BX'], bx)
            u.reg_write(REG['CX'], cx)
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, read_axes, side.m.linear('ReadGamePortAAxisCounts'))

        draw_trace(side, bag, obs, real_panel)

        side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    sample_count = len(axes) if abort_at is None else abort_at[0] - 1
    def done(m, regs):
        for key in observed[0]:
            if key == 'panel_es_in':
                continue  # incoming ES is a renderer scratch; compare its defined output instead.
            if observed[0][key] != observed[1][key]:
                raise AssertionError(f'{name}: trace mismatch {key}: oracle={observed[0][key]!r}, hybrid={observed[1][key]!r}')
        for side, obs in zip((pair.a, pair.b), observed):
            check(obs['entry_sp'] is not None, f'{name}: calibration entry observed')
            expected_mailbox = (obs['entry_sp'] if side is pair.a or legacy_bridge
                                else 0xA554)
            check(side.m.word(mailbox) == expected_mailbox,
                  f'{name}: only the ASM entry updates the abort-stack mailbox')
            check(obs['page'] == [(pair.sym('CalibPageList'), 0,
                                   (ENTRY_BP, ENTRY_ES), (PAGE_BP, PAGE_ES))],
                  f'{name}: real page controller loads the calibration page once')
            check(obs['axes'] == list(axes[:sample_count]), f'{name}: axis sample order')
            expected_panels = [(0x5501, 0x4E), (0x7D01, 0x4F)][:min(sample_count, 2)]
            check([(p[0], p[1]) for p in obs['panels']] == expected_panels,
                  f'{name}: panel position/image trace')
            if not real_panel:
                expected_es_trace = [(0x5501, 0x4E, PANEL_ES[0]),
                                     (0x7D01, 0x4F, PANEL_ES[1])][:min(sample_count, 2)]
                check(obs['panels'] == expected_es_trace, f'{name}: panel ES output trace')
                expected_es_in = ((PAGE_ES, PANEL_ES[0]) if side is pair.a
                                  else (ENTRY_ES, PANEL_ES[0]))[:min(sample_count, 2)]
                check(tuple(obs['panel_es_in']) == expected_es_in,
                      f'{name}: panel incoming ES scratch on {"oracle" if side is pair.a else "hybrid"}')
            expected_periods = [25] * (3 if abort_at is None else abort_at[0])
            periods = list(obs['release_periods'])
            check(periods == expected_periods,
                  f'{name}: release periods {periods}, total {obs["retraces"]}, expected {expected_periods}')
            check(obs['retraces'] == 25 * (3 if abort_at is None else abort_at[0]),
                  f'{name}: total release retraces')
            check(obs['ignored_esc'] == esc_during_release,
                  f'{name}: Esc was present during release and ignored until a press poll')

        if not legacy_bridge:
            expected_bp = PAGE_BP
            check(regs['BP'] == expected_bp, f'{name}: returned BP matches page-service metadata')
            if not real_panel:
                expected_es = PANEL_ES[min(sample_count, 2) - 1] if sample_count else PAGE_ES
                check(regs['ES'] == expected_es,
                      f'{name}: returned ES matches page and panel service metadata')
            c_metadata = (pair.b.m.word(pair.sym('StackArea')),
                          pair.b.m.word(pair.sym('StackArea') + 2))
            check(c_metadata == (regs['BP'], regs['ES']),
                  f'{name}: native calibration returns BP/ES through DosRegisters')
        check(m.word(pair.sym('JoyButtonSelect')) == K.JOY_BUTTONS_PORT_A, f'{name}: port A selected')
        check(m.word(pair.sym('JoyCalibratingFlag')) == 1, f'{name}: calibration flag set')
        check(m.read(pair.sym('JoyCalUnusedByte'), 1)[0] == 0, f'{name}: unused byte cleared')

        if abort_at is None:
            low, high, center = axes
            expected = {
                'JoyCalLowX': low[0], 'JoyCalLowY': low[1],
                'JoyCalHighX': high[0], 'JoyCalHighY': high[1],
                'JoyCalCenterX': center[0], 'JoyCalCenterY': center[1],
                'JoyXHighThreshold': midpoint(center[0], high[0]),
                'JoyXLowThreshold': midpoint(low[0], center[0]),
                'JoyYHighThreshold': midpoint(center[1], high[1]),
                'JoyYLowThreshold': midpoint(low[1], center[1]),
            }
            check(m.word(pair.sym('InputDeviceMode')) == K.INPUT_MODE_JOYSTICK,
                  f'{name}: successful calibration keeps joystick input')
            for field, value in expected.items():
                check(m.word(pair.sym(field)) == value, f'{name}: {field} midpoint/sample value')
            check(observed[0]['raw_press'] == list(PRESS_INPUTS),
                  f'{name}: secondary/directional noise is rejected; masked primary is exact')
            check(observed[0]['raw_release'] == list(RELEASE_INPUTS),
                  f'{name}: primary must release at each wait')
            check(m.read(pair.sym('InputBits'), 1)[0] == K.IN_BUTTON_PRIMARY,
                  f'{name}: center press remains the final input sample')
        else:
            check(m.word(pair.sym('InputDeviceMode')) == K.INPUT_MODE_KEYS_A,
                  f'{name}: Esc falls back to keyboard table A')
            check(observed[0]['press_entries'][-1] == (*abort_at, True),
                  f'{name}: abort is taken at the requested press poll')
            expected_entries = ([(group, 1, False) for group in range(1, abort_at[0])] +
                                [(abort_at[0], attempt, False)
                                 for attempt in range(1, abort_at[1])] + [(*abort_at, True)])
            check(observed[0]['press_entries'] == expected_entries,
                  f'{name}: only the requested poll observes Esc')
            expected_press_prefix = ([K.IN_BUTTON_PRIMARY] * (abort_at[0] - 1) +
                                     [K.IN_BUTTON_SECONDARY] * (abort_at[1] - 1))
            check(observed[0]['raw_press'] == expected_press_prefix,
                  f'{name}: abort follows the intended ignored primary polls')
            check(m.read(pair.sym('InputBits'), 1)[0] == 0,
                  f'{name}: abort leaves the last released input sample')
            # Abort preserves uncollected samples and all thresholds; earlier axis reads
            # remain stored, exactly as the original nonlocal return does.
            for i, field in enumerate(('JoyCalLowX', 'JoyCalLowY', 'JoyCalHighX', 'JoyCalHighY',
                                       'JoyCalCenterX', 'JoyCalCenterY')):
                if i < 2 * sample_count:
                    value = axes[i // 2][i % 2]
                    check(m.word(pair.sym(field)) == value, f'{name}: completed {field} retained')
            for field in ('JoyXLowThreshold', 'JoyXHighThreshold',
                          'JoyYLowThreshold', 'JoyYHighThreshold'):
                old = dict(w.writes()).get(pair.sym(field))
                check(m.read(pair.sym(field), 2) == old, f'{name}: abort leaves {field} untouched')

    try:
        yield Case('CalibrateJoystickWithAbort', {'BP': ENTRY_BP, 'ES': ENTRY_ES,
                                                   'SI': pair.sym('StackArea')}, w.writes(),
                   FREE, expect=done, name=name)
    finally:
        cleanup(pair, bag)
        pair.mask = saved_mask


def full_case(rng, pair, axes, name, esc=False):
    w = seed(rng, pair)
    return calibration_case(w, name, RELEASE_INPUTS, PRESS_INPUTS, axes,
                            esc_during_release=esc)


def abort_case(rng, pair, group, attempt=1):
    w = seed(rng, pair)
    axes = WRAP_SAMPLES[:group - 1]
    releases = (0,) * group
    presses = (K.IN_BUTTON_PRIMARY,) * (group - 1) + (K.IN_BUTTON_SECONDARY,) * (attempt - 1)
    return calibration_case(w, f'Esc at press group {group}, attempt {attempt}',
                            releases, presses, axes, abort_at=(group, attempt))


def cases(rng, scale, pair):
    saved = []
    for side, target in ((pair.a, 'CALIBRATEJOYSTICKWITHABORT'),
                         (pair.b, C_ENTRIES['CalibrateJoystickWithAbort'])):
        prior = side.m.symbols.get('CALIBRATEJOYSTICKWITHABORT')
        saved.append((side, prior))
        side.m.symbols['CALIBRATEJOYSTICKWITHABORT'] = side.m.symbols[target]
    try:
        yield from full_case(rng, pair, WRAP_SAMPLES, 'unsigned wrap and exact primary', esc=True)
        for group in (1, 2, 3):
            yield from abort_case(rng, pair, group)
        # Abort after one nonprimary poll in the high-sample loop.
        yield from abort_case(rng, pair, 2, attempt=2)
        for i in range(32 * scale):
            axes = tuple(tuple(rng.randrange(0x10000) for _ in range(2)) for _ in range(3))
            yield from full_case(rng, pair, axes, f'random unsigned samples #{i}')
    finally:
        for side, prior in reversed(saved):
            if prior is None: side.m.symbols.pop('CALIBRATEJOYSTICKWITHABORT', None)
            else: side.m.symbols['CALIBRATEJOYSTICKWITHABORT'] = prior
    # Exercise the retained MAIN wrapper itself as well as the native C body. This
    # validates the wrapper's actual SP mailbox write and BP/ES stack handoff.
    w = seed(rng, pair)
    yield from calibration_case(w, 'legacy MAIN adapter mailbox', RELEASE_INPUTS,
                                PRESS_INPUTS, WRAP_SAMPLES, legacy_bridge=True)


# Each edit is unique and should be killed by this bounded differential suite.
MUTANTS = [
    ('calibration.c', 'for (n = 0; n < 25; n++)', 'for (n = 0; n < 24; n++)'),
    ('calibration.c', 'poll_joystick_input_bits();\n    InputBits &= IN_BUTTON_PRIMARY;\n    return 0;',
     'poll_joystick_input_bits();\n    InputBits &= IN_BUTTON_SECONDARY;\n    return 0;'),
    ('calibration.c', 'if (((volatile byte *)KeyDownTable)[SCAN_ESC] == KEY_STATE_DOWN) return 1;',
     'if (((volatile byte *)KeyDownTable)[SCAN_ESC] == KEY_STATE_DOWN) return 0;'),
    ('calibration.c', 'JoyXHighThreshold = JoyCalCenterX + ((word)(JoyCalHighX - JoyCalCenterX) >> 1);',
     'JoyXHighThreshold = JoyCalHighX + ((word)(JoyCalCenterX - JoyCalHighX) >> 1);'),
    ('calibration.c', 'do {\n        poll_joystick_input_bits();',
     'do {\n        if (((volatile byte *)KeyDownTable)[SCAN_ESC] == KEY_STATE_DOWN) break;\n'
     '        poll_joystick_input_bits();'),
]
