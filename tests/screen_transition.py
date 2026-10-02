"""Bounded ASM-vs-C checks for the reusable screen-transition policy.

The packed capture/squash backend and adapter clear are returned from at their real
service boundaries. This keeps the policy test deterministic while verifying its
service order, volatile sound decisions, DS repair, and BP/ES handoff.
"""
from difftest import Case
from emu import REG
from options import hook, cleanup, return_service, check
from world import World
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
import random, struct

FREE = ('SP', 'DS', 'SS')


def segment_kind(side, value):
    if value in (side.m.data_frame, side.m.peek('MainDataSegment')):
        return 'main'
    for name in ('WorkspaceSegment', 'ScreenSegment'):
        if value == side.m.peek(name):
            return name
    return value


def install_services(side, bag, observed, config):
    if 'SCREEN_ANIMATION_CAPTURE_COLLAPSE' in side.m.symbols:
        def capture(u, _address, _size, _):
            pair_at = side.m.data_frame * 16 + u.reg_read(REG['SI'])
            bp, es = struct.unpack('<HH', bytes(u.mem_read(pair_at, 4)))
            observed['trace'].append(('capture', segment_kind(side, u.reg_read(REG['DS'])), bp, es))
            # The native coordinator writes the same explicit service-result pair the
            # following clear consumes. DS remains the C state segment throughout.
            u.mem_write(pair_at, struct.pack('<HH', 0xB17E, side.m.peek('ScreenSegment')))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, capture,
             side.m.linear('SCREEN_ANIMATION_CAPTURE_COLLAPSE'))
    else:
        def capture(u, _address, _size, _):
            observed['trace'].append(('capture', segment_kind(side, u.reg_read(REG['DS'])),
                                      u.reg_read(REG['BP']), u.reg_read(REG['ES'])))
            # The frozen entry returns with DS on its packed-image workspace, ES on
            # screen, and arbitrary BP left by the pixel backend.
            u.reg_write(REG['DS'], side.m.peek('WorkspaceSegment'))
            u.reg_write(REG['ES'], side.m.peek('ScreenSegment'))
            u.reg_write(REG['BP'], 0xB17E)
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, capture,
             side.m.linear('CaptureAndCollapseScreen'))

    def clear(u, _address, _size, _):
        observed['trace'].append(('clear', segment_kind(side, u.reg_read(REG['DS'])),
                                  u.reg_read(REG['BP']), u.reg_read(REG['ES'])))
        # ResetPageAndClearScreen preserves BP and leaves ES on ScreenSegment.
        u.reg_write(REG['ES'], side.m.peek('ScreenSegment'))
        return_service(side)
    hook(side, bag, UC_HOOK_CODE, clear,
         side.m.linear('ResetPageAndClearScreen'))

    sound_at = side.m.data_frame * 16 + side.m.offset('SfxEnabled')
    active_at = side.m.data_frame * 16 + side.m.offset('SfxActive')

    def sound_read(u, _access, address, _size, _value, _):
        if address != sound_at:
            return
        observed['sound_reads'] += 1
        if observed['sound_reads'] == 2 and config.get('flip_enabled') is not None:
            side.m.write(side.m.offset('SfxEnabled'), bytes((config['flip_enabled'],)))
    hook(side, bag, UC_HOOK_MEM_READ, sound_read, sound_at)

    def active_read(u, _access, address, _size, _value, _):
        if address != active_at:
            return
        observed['active_reads'] += 1
        if observed['active_reads'] == config.get('busy_reads'):
            side.m.write(side.m.offset('SfxActive'), b'\0')
    hook(side, bag, UC_HOOK_MEM_READ, active_read, active_at)


def transition_case(pair, rng, entry, enabled, active, request, flip_enabled=None,
                    busy_reads=0):
    bag, observations = [], []
    config = {'flip_enabled': flip_enabled, 'busy_reads': busy_reads}
    for side in (pair.a, pair.b):
        observed = {'trace': [], 'sound_reads': 0, 'active_reads': 0}
        observations.append(observed)
        install_services(side, bag, observed, config)

    w = (World(pair, rng).byte('SfxEnabled', enabled)
         .byte('SfxActive', active).byte('SfxRequest', request))

    def done(_m, regs_out):
        check(observations[0] == observations[1],
              f'{entry}: service and volatile-read traces match')
        expected_trace = [
            ('capture', 'main', 0x7234, 0xB800),
            ('clear', 'main', 0xB17E, pair.a.m.peek('ScreenSegment')),
        ]
        check(observations[0]['trace'] == expected_trace,
              f'{entry}: capture, DS repair, and clear handoff '
              f'{observations[0]["trace"]!r}')
        want_reads = 0 if entry == 'CollapseScreenAndClear' else 2
        check(observations[0]['sound_reads'] == want_reads,
              f'{entry}: independent volatile SfxEnabled reads')
        expected_active_reads = busy_reads if busy_reads else int(
            entry == 'CollapseScreenWithSfx' and enabled != 0)
        check(observations[0]['active_reads'] == expected_active_reads,
              f'{entry}: busy SfxActive polling count '
              f'{observations[0]["active_reads"]} expected {expected_active_reads}')
        expected_enabled = enabled if flip_enabled is None else flip_enabled
        expected_request = 5 if entry == 'CollapseScreenWithSfx' and expected_enabled else request
        for side in (pair.a, pair.b):
            check(side.m.read(pair.sym('SfxRequest'), 1)[0] == expected_request,
                  f'{entry}: request byte {expected_request:02X}')
            check(side.m.read(pair.sym('SfxEnabled'), 1)[0] == expected_enabled,
                  f'{entry}: second-check test changed enabled byte as requested')
        check(regs_out['BP'] == 0xB17E, f'{entry}: clear BP result propagates to caller')
        check(regs_out['ES'] in ('unchanged', pair.a.m.peek('ScreenSegment')),
              f'{entry}: clear ES result propagates as ScreenSegment '
              f'({regs_out["ES"]!r})')

    try:
        yield Case(entry, {'BP': 0x7234, 'ES': 0xB800, 'DS': 'MainDataSegment'},
                   w.writes(), preserve=FREE, outputs=('BP', 'ES'), expect=done,
                   name=f'enabled={enabled:02X} active={active:02X} '
                        f'flip={flip_enabled!r} busy={busy_reads}')
    finally:
        cleanup(pair, bag)


def cases(rng, scale, pair):
    yield from transition_case(pair, rng, 'CollapseScreenWithSfx', 0, 0x44, 0x59,
                               flip_enabled=1)
    yield from transition_case(pair, rng, 'CollapseScreenWithSfx', 1, 7, 0x59,
                               flip_enabled=0, busy_reads=3)
    yield from transition_case(pair, rng, 'CollapseScreenWithSfx', 2, 0, 0x59)
    yield from transition_case(pair, rng, 'CollapseScreenAndClear', 1, 0x77, 0x39)


MUTANTS = [
    ('screen_transition.c',
     'if (*enabled != 0) {\n        while (*active != 0) { }\n    }\n    if (*enabled != 0) SfxRequest = 5;',
     'byte enabled_before_wait = *enabled;\n    if (enabled_before_wait != 0) {\n'
     '        while (*active != 0) { }\n    }\n'
     '    if (enabled_before_wait != 0) SfxRequest = 5;'),
    ('screen_transition.c',
     'if (*enabled != 0) SfxRequest = 5;\n\n'
     '    screen_animation_capture_collapse(registers);\n'
     '    dos_service(ResetPageAndClearScreen, registers);',
     'if (*enabled != 0) SfxRequest = 5;\n\n'
     '    dos_service(ResetPageAndClearScreen, registers);'),
]
