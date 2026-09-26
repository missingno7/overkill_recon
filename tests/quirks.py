"""Regression corpus of original quirks and bugs (documented at their oracle sites).

Each case sets up one deterministic scenario, asserts on the ORACLE that the documented
behaviour really happens (so the documentation is tested too), and, like every suite,
compares the hybrid against it. A C translation that "fixes" one of these fails here,
whether or not its routine is C yet.
"""
from difftest import Case, ALL_REGS
import struct

RECORD = 0x38
NOT_AX_BX = tuple(r for r in ALL_REGS if r not in ('AX', 'BX'))
W = lambda v: struct.pack('<H', v & 0xFFFF)

def rec(**fields):
    r = bytearray(RECORD)
    offsets = dict(status=0, y=2, x=4, direction=6, sprite=8, draw_pass=0x0A, size_class=0x14, kind=0x16,
                   type=0x18, field_1c=0x1C, player_shot=0x1E, hit_points=0x20, flash_timer=0x24,
                   slot_index=0x28, delta_y=0x2A, delta_x=0x2C, step_error=0x2E, target=0x30,
                   saved_x=0x32, saved_y=0x34, field_36=0x36)
    for k, v in fields.items(): struct.pack_into('<H', r, offsets[k], v & 0xFFFF)
    return r

def check(cond, what):
    if not cond: raise AssertionError('oracle does not show the documented quirk: ' + what)

def cases(rng, scale, pair):
    s = pair.sym
    a0, b0 = s('PoolA') + RECORD * 5, s('PoolB') + RECORD * 3
    word = lambda m, name, extra=0: m.word(s(name) + extra)
    player = rec(status=1, y=0x4D, x=0x60, kind=3, size_class=1)

    # SpawnThrottledChild leaves BX unchanged when throttled; Type92SpawnShot then stores
    # 44h through BX = player Y & ~3 = 4Ch, i.e. the word at DS:54h: TimerTickPhase = 44h
    # and SoundModuleLoaded = 0 (module music stops for the session).
    yield Case('Type92FireWhenPlayerOnRow', {'BP': a0},
               [(s('PrimaryRecord'), player), (s('DifficultySetting'), W(0)), (s('ChildSpawnThrottle'), b'\0'),
                (s('SoundModuleLoaded'), b'\1'), (s('TimerTickPhase'), b'\1'),
                (a0, rec(status=1, y=0x38, x=0x40, kind=4, type=0x92, size_class=1, slot_index=0xFFFF))],
               ('BP', 'SP', 'DS', 'SS'), name='stale BX zeroes SoundModuleLoaded',
               expect=lambda m, r: check(m.read(s('TimerTickPhase'), 2) == b'\x44\x00', 'Type92 stale-BX write'))

    # Type 8Fh at FrameCount64 phase 3, throttled: BX is still its sprite C1h, so word 44h
    # lands at DS:C9h inside BossKeyScreen.
    yield Case('Type8FAnimFireBurstB', {'BP': a0},
               [(s('PrimaryRecord'), player), (s('DifficultySetting'), W(0)), (s('ChildSpawnThrottle'), b'\0'),
                (s('FrameCount64'), W(24)),
                (a0, rec(status=1, y=0x40, x=0x80, kind=4, type=0x8F, size_class=1, slot_index=0xFFFF))],
               ('BP', 'SP', 'DS', 'SS'), name='stale BX writes into BossKeyScreen',
               expect=lambda m, r: check(m.word(0xC9) == 0x44, 'Type8F stale-BX write at DS:C9h'))

    # SfxRequest is one mailbox: Type30's own request (0Eh) replaces its child's (0Bh).
    yield Case('Type30AnimatedShooter', {'BP': a0},
               [(s('PrimaryRecord'), player), (s('DifficultySetting'), W(2)), (s('SfxEnabled'), b'\1'),
                (s('LevelIndex'), W(1)), (s('FrameCount16'), W(15)), (s('SfxRequest'), b'\0'),
                (a0, rec(status=1, y=0x40, x=0x80, kind=4, type=0x30, size_class=1, slot_index=0xFFFF))],
               ('BP', 'SP', 'DS', 'SS'), name='sfx mailbox overwrite',
               expect=lambda m, r: check(m.read(s('SfxRequest'), 1) == b'\x0e', 'SfxRequest 0Eh wins'))

    # Shot bounds are unsigned: a shot at X = FFF0h (just left of the playfield) is removed.
    # (Entered through Type09BeamLink, which is exactly ShotBoundsCheck; that label is C now.)
    for x, y in ((0xFFF0, 0x50), (0x40, 0xFFF0), (0xC9, 0x50), (0xC8, 0x50)):
        yield Case('Type09BeamLink', {'BP': b0},
                   [(s('DemoActive'), W(1)), (b0, rec(status=1, y=y, x=x, kind=2, type=4))],
                   ('BP', 'SP', 'DS', 'SS'), name=f'unsigned bounds X={x:04X} Y={y:04X}',
                   expect=lambda m, r, keep=(x == 0xC8): check(m.word(b0) == (1 if keep else 0), 'unsigned shot bounds'))

    # DestroyRecord ignores type 21h outside level 4, even at 0 HP (the source of the FFFFh
    # wrap on its next hit): no score, the record stays live.
    yield Case('DestroyRecord', {'BP': a0},
               [(s('LevelIndex'), W(0)), (s('ScoreBcd'), b'\x00\x00\x00\x00'),
                (a0, rec(status=1, y=0x40, x=0x40, kind=4, type=0x21, size_class=2, hit_points=0, slot_index=0xFFFF))],
               ('BP', 'SP', 'DS', 'SS'), name='type 21h survives outside level 4',
               expect=lambda m, r: check(m.word(a0) == 1 and m.word(a0 + 0x18) == 0x21 and m.read(s('ScoreBcd'), 4) == bytes(4),
                                         'type 21h not destroyed'))

    # The 8-digit BCD score wraps past 99999999; the carry is lost.
    yield Case('AddScoreBcd', {'BX': 0x0001}, [(s('ScoreBcd'), b'\x99\x99\x99\x99')], name='BCD wrap',
               expect=lambda m, r: check(m.read(s('ScoreBcd'), 4) == bytes(4), 'score wraps to 0'))

    # Equality guards, not clamps: Y below SHIP_Y_MIN keeps decrementing; at it, stays.
    for y, after in ((0x1F, 0x1E), (0x20, 0x20), (0x21, 0x20)):
        yield Case('DecRecordYUnlessAtMin', {'BP': s('PrimaryRecord')}, [(s('PrimaryRecord'), rec(y=y))],
                   name=f'equality guard Y={y:X}',
                   expect=lambda m, r, after=after: check(m.word(s('PrimaryRecord') + 2) == after, 'equality-only guard'))

    # The "random" source is a fixed 16-word cycle; the cursor wraps after the last word.
    base = s('CreditRandomWords')
    for at, nxt in ((base, base + 2), (base + 30, base)):
        yield Case('NextRandomWord', {}, [(s('RandomWordCursor'), W(at))], outputs=('BX',), name=f'cursor {at - base}',
                   expect=lambda m, r, nxt=nxt: check(m.word(s('RandomWordCursor')) == nxt and r['BX'] == m.word(nxt),
                                                      'fixed word cycle'))

    # The renderer owns the hit-flash countdown: computing a record's workspace offset ticks
    # REC_FLASH_TIMER, only while it is on the playfield.
    for y, after in ((0x40, 4), (0xE0, 5)):
        yield Case('RecordWorkspaceOffset', {'BP': a0}, [(a0, rec(status=1, y=y, x=0x40, size_class=1, flash_timer=5))],
                   ('BP', 'SP', 'DS', 'SS'), outputs=('AX',), name=f'flash tick Y={y:X}',
                   expect=lambda m, r, after=after: check(m.word(a0 + 0x24) == after, 'draw-side flash countdown'))

    # Steering arrival is exact and takes two calls: the arriving step leaves SteerArrived 0;
    # the next call sets it without moving or turning.
    steer = [(s('SteerTargetX'), W(0x40) + W(0x50)), (s('SteerSpeed'), W(0))]
    yield Case('SteerTowardTarget', {'BP': a0}, steer + [(a0, rec(y=0x51, x=0x40, direction=2))], NOT_AX_BX,
               name='arriving step',
               expect=lambda m, r: check(m.word(s('SteerArrived')) == 0 and m.word(a0 + 2) == 0x50, 'arrival step'))
    yield Case('SteerTowardTarget', {'BP': a0}, steer + [(s('SteerArrived'), W(0)), (a0, rec(y=0x50, x=0x40, direction=5))], NOT_AX_BX,
               name='already there',
               expect=lambda m, r: check(m.word(s('SteerArrived')) == 1 and m.word(a0 + 6) == 5, 'arrival detected next call'))

    # A zero chase delta never "arrives": it steps up-left.
    yield Case('StepAlongDelta', {'BP': a0}, [(s('ChaseStepPixels'), W(3)), (a0, rec(y=0x50, x=0x40))], NOT_AX_BX,
               name='zero delta',
               expect=lambda m, r: check(m.word(a0 + 6) == 7 and m.word(a0 + 2) == 0x4D and m.word(a0 + 4) == 0x3D,
                                         'zero delta moves up-left'))

    # REC_STEP_ERROR is inherited from the slot's last occupant and wraps: FFFFh + 3 = 2 is
    # not above 5, so this step is X only (left), leaving 2.
    yield Case('StepAlongDelta', {'BP': a0},
               [(s('ChaseStepPixels'), W(3)), (a0, rec(y=0x50, x=0x40, delta_x=5, delta_y=3, step_error=0xFFFF))], NOT_AX_BX,
               name='stale step error wraps',
               expect=lambda m, r: check(m.word(a0 + 6) == 6 and m.word(a0 + 0x2E) == 2, 'step error wrap'))
