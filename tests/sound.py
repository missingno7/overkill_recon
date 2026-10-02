"""Bounded sound-region equivalence cases for promotion into tests/sound.py.

The emulator's IN/OUT hooks stand in for the PIT and PPI: they record every access in
order and return zero for IN, without running a whole IRQ or game frame.  The one timer
wait case advances only TimerTickPhase on the memory read that an interrupt would change.
"""
from difftest import Case, ALL_REGS, far
from world import World, K
from emu import LOAD
from unicorn import UC_HOOK_MEM_READ
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'sound.c']

IRQ_SCRATCH = ('AX', 'BX', 'DX', 'SI', 'DI')
TICK_PRESERVE = tuple(r for r in ALL_REGS if r not in IRQ_SCRATCH)
SFX_STREAM_FIXTURE = 'SfxStream12'   # classified but absent from SfxEffectTable

def voice(cursor=0, countdown=1, sounding=0, duration=1, note=0,
          note_step=0, divisor=128, slide_delta=0, slide_ticks=0):
    data = bytearray(16)
    struct.pack_into('<H', data, K.SFX_VOICE_STREAM, cursor & 0xFFFF)
    data[K.SFX_VOICE_NOTE] = note & 0xFF
    data[K.SFX_VOICE_DURATION] = duration & 0xFF
    struct.pack_into('<H', data, K.SFX_VOICE_DIVISOR, divisor & 0xFFFF)
    data[K.SFX_VOICE_COUNTDOWN] = countdown & 0xFF
    data[K.SFX_VOICE_SOUNDING] = sounding & 0xFF
    data[K.SFX_VOICE_NOTE_STEP] = note_step & 0xFF
    struct.pack_into('<H', data, K.SFX_VOICE_SLIDE_DELTA, slide_delta & 0xFFFF)
    data[K.SFX_VOICE_SLIDE_TICKS] = slide_ticks & 0xFF
    return bytes(data)

def empty_world(pair, rng, phase=0):
    return (World(pair, rng)
            .byte('SfxActive', 0).byte('SfxRequest', 0)
            .byte('SfxTickPhase', phase)
            .put('SfxVoiceA', voice())
            .put('SfxVoiceB', voice()))

def tick(name='', writes=(), regs=None):
    return Case('SfxTimerTick', regs or {'ES': 0xB800}, writes,
                preserve=TICK_PRESERVE, name=name)

def play_effect_sequences(rng, pair, scale):
    # Each table entry runs through the first 72 ticks.  This reaches request consume,
    # alternating voice output, note durations, rests, slides, steps and many endings;
    # isolated command streams below cover the short corner cases deterministically.
    for effect in range(1, K.SFX_EFFECT_COUNT):
        w = empty_world(pair, rng, phase=(effect - 1) & 3).byte('SfxRequest', effect)
        steps = [tick(f'effect {effect:02X} request', w.writes())]
        steps.extend(tick(f'effect {effect:02X} tick {n}') for n in range(71 * scale))
        yield steps

def stream_sequence(pair, rng, label, stream, *, a=None, b=None, phase=0, ticks=5):
    w = empty_world(pair, rng, phase)
    cursor = pair.sym(SFX_STREAM_FIXTURE)
    w.put(SFX_STREAM_FIXTURE, bytes(stream))
    w.byte('SfxActive', 1)
    w.put('SfxVoiceA', a if a is not None else voice(cursor=cursor))
    w.put('SfxVoiceB', b if b is not None else voice(cursor=cursor, countdown=2))
    steps = [tick(label + ' first', w.writes())]
    steps.extend(tick(label + f' tick {n}') for n in range(1, ticks))
    return steps

def priority_sequences(rng, pair):
    # A refused higher ID stays pending while the active voices continue.  Equal IDs
    # restart; lower IDs replace; invalid IDs stop but are not consumed and stop again.
    for active, request, phase, expected in ((5, 6, 0, 'higher stays pending'),
                                              (5, 5, 1, 'equal restarts'),
                                              (6, 4, 2, 'lower preempts')):
        w = empty_world(pair, rng, phase).byte('SfxActive', active).byte('SfxRequest', request)
        safe_stream = pair.sym('SfxStream55')
        w.put('SfxVoiceA', voice(cursor=safe_stream, countdown=3, sounding=2))
        w.put('SfxVoiceB', voice(cursor=safe_stream, countdown=3, sounding=2))
        steps = [tick(expected, w.writes())]
        steps.append(tick(expected + ' next tick'))
        yield steps
    w = empty_world(pair, rng).byte('SfxRequest', K.SFX_EFFECT_COUNT)
    yield [tick('invalid request repeats stop', w.writes()), tick('invalid request repeats again')]

def music_cases(rng, pair):
    for enabled in (0, 1, 2, 0xFF):
        for loaded in (0, 1):
            for tune, current in ((0, 0), (2, 0), (2, 2), (0xFF, 1), (5, 0xFF)):
                input_ax = ((rng.randrange(256) << 8) | tune)
                w = (World(pair, rng).byte('ModuleSoundEnabled', enabled)
                     .byte('ModuleSoundRequest', 0xA5).byte('SoundModuleLoaded', loaded)
                     .put(far('SoundModuleSlot', K.MODULE_MUSIC_REQUEST), bytes((0x5A, current))))
                yield Case('RequestModuleMusic', {'AX': input_ax, 'BX': 0xBEEF, 'ES': 0xB800},
                           w.writes(), preserve=('CX', 'DX', 'SI', 'DI', 'BP', 'SP', 'DS', 'SS'),
                           # BX is a relocated segment value; ES is normalized by difftest.
                           outputs=('AX', 'ES'), flags=('CF', 'PF', 'AF', 'ZF', 'SF', 'OF'),
                           name=f'enabled={enabled:02X}, loaded={loaded}, tune={tune:02X}, current={current:02X}')

def timer_read_hook(pair, side):
    at = side.m.data_frame * 16 + pair.sym('TimerTickPhase')
    reads = {'count': 0}
    def advance_once_per_wait(u, access, address, size, value, _):
        if address != at: return
        reads['count'] += 1
        # WaitTimerInterruptIfModule reads once to latch the old phase, once to observe
        # it unchanged, then once after a tick.  Only the third read models the IRQ's
        # one-byte phase update; this is not a simulated module or game tick.
        if reads['count'] % 3 == 0:
            old = bytes(u.mem_read(at, 1))[0]
            u.mem_write(at, bytes(((old + 1) & 3,)))
    return side.m.u.hook_add(UC_HOOK_MEM_READ, advance_once_per_wait, None, at, at)

def stop_module_cases(pair):
    hooks = [timer_read_hook(pair, side) for side in (pair.a, pair.b)]
    try:
        # The unloaded branch is an immediate return with every register unchanged.
        w = (World(pair, None).byte('SoundModuleLoaded', 0)
             .put(far('SoundModuleSlot', K.MODULE_MUSIC_REQUEST), b'\x13\x07'))
        yield Case('StopModuleMusic', {'AX': 0xABCD, 'BX': 0x1234, 'CX': 0x5678, 'ES': 0xB800},
                   w.writes(), preserve=ALL_REGS, flags=('CF', 'PF', 'AF', 'ZF', 'SF', 'OF'),
                   name='no module returns without waiting')

        # For a loaded module the request word becomes 00FFh and exactly five observed
        # phase changes release the policy wait; no SoundModuleTickEntry is emulated.
        start_phase, input_ax = 2, 0xABCD
        w = (World(pair, None).byte('SoundModuleLoaded', 1).byte('TimerTickPhase', start_phase)
             .put(far('SoundModuleSlot', K.MODULE_MUSIC_REQUEST), b'\x13\x07'))
        def expected_ax(m, regs):
            module_segment = LOAD + m.symbols['SOUNDMODULESLOT'][0]
            expected = (module_segment & 0xFF00) | ((start_phase + 4) & 3)
            assert regs['AX'] == expected, f'last timer wait AX should be {expected:04X}'
            final_phase = m.word(pair.sym('TimerTickPhase')) & 0xFF
            assert final_phase == ((start_phase + 5) & 3), f'timer phase ended {final_phase}, expected {(start_phase + 5) & 3}'
        yield Case('StopModuleMusic', {'AX': input_ax, 'BX': 0x1234, 'CX': 0x5678, 'ES': 0xB800},
                   w.writes(), preserve=('BX', 'DX', 'SI', 'DI', 'BP', 'SP', 'DS', 'SS'),
                   outputs=('CX', 'ES'), expect=expected_ax, name='five bounded timer waits')
    finally:
        for side, hook in zip((pair.a, pair.b), hooks): side.m.u.hook_del(hook)

def cases(rng, scale, pair):
    yield from play_effect_sequences(rng, pair, scale)
    yield from priority_sequences(rng, pair)

    # Every command has a compact stream fixture.  The selected phase keeps the test
    # focused on the command's immediate port effect when both voices are otherwise idle.
    yield stream_sequence(pair, rng, 'end stops both voices', [K.SFX_END, 7], ticks=1)
    yield stream_sequence(pair, rng, 'rest silences lone voice', [K.SFX_REST, 7],
                          a=voice(cursor=pair.sym(SFX_STREAM_FIXTURE), sounding=2), ticks=1)
    yield stream_sequence(pair, rng, 'rest leaves other voice sounding', [K.SFX_REST, 7],
                          a=voice(cursor=pair.sym(SFX_STREAM_FIXTURE), sounding=2),
                          b=voice(cursor=pair.sym(SFX_STREAM_FIXTURE), countdown=2, sounding=2), phase=3, ticks=1)
    yield stream_sequence(pair, rng, 'step down and duration', [K.SFX_DURATION_BIAS + 4, K.SFX_STEP_DOWN, 7, K.SFX_END], ticks=6)
    yield stream_sequence(pair, rng, 'step up', [K.SFX_STEP_UP, 12, K.SFX_END], ticks=3)
    yield stream_sequence(pair, rng, 'slide uses signed word delta and byte count',
                          [K.SFX_SLIDE, 0x12, 0x34, 3, 9, K.SFX_END], ticks=6)
    yield stream_sequence(pair, rng, 'hold consumes its command before waiting',
                          [K.SFX_HOLD, 13, K.SFX_END], ticks=5)

    # END in A must not cancel voice B's tick: after phase increments to 1, B is selected,
    # so the same call emits
    # an off sequence followed by PIT programming and a speaker-enable read/write.
    a = voice(cursor=pair.sym(SFX_STREAM_FIXTURE), sounding=2)
    b = voice(cursor=pair.sym(SFX_STREAM_FIXTURE) + 1, countdown=1, sounding=0)
    yield stream_sequence(pair, rng, 'voice B ticks after voice A END', [K.SFX_END, 7],
                          a=a, b=b, phase=0, ticks=1)

    # Note-step arithmetic wraps in AL before indexing the divisor table.  The original
    # unchecked read past the table is intentionally compared as part of the state.
    w = empty_world(pair, rng, phase=0).byte('SfxActive', 1)
    stream = pair.sym(SFX_STREAM_FIXTURE)
    w.put(SFX_STREAM_FIXTURE, bytes([7, K.SFX_END]))
    w.put('SfxVoiceA', voice(cursor=stream, countdown=2, note=0, note_step=0xFF, sounding=2))
    w.put('SfxVoiceB', voice(cursor=stream, countdown=2))
    yield [tick('wrapped note step reads the original adjacent word', w.writes())]

    yield from music_cases(rng, pair)
    yield from stop_module_cases(pair)

MUTANTS = [
    ('sound.c', '(SfxTickPhase & 1)', '(SfxTickPhase & 2)'),
    ('sound.c', 'effect > SfxActive', 'effect < SfxActive'),
    ('sound.c', 'ModuleSoundRequest = tune;',
     'if (ModuleSoundEnabled != 0) ModuleSoundRequest = tune;'),
    ('sound.c', 'SfxRequest = 0;', 'SfxRequest = effect;'),
    ('sound.c', 'voice[SFX_VOICE_SOUNDING] = 2;', 'voice[SFX_VOICE_SOUNDING] = 0;'),
    ('sound.c', 'case SFX_HOLD:\n            sound_sfx_store_and_wait(voice, cursor);\n            return;',
     'case SFX_HOLD:\n            sound_sfx_store_and_wait(voice, (word)(cursor + 1));\n            return;'),
    ('sound.c', 'sound_sfx_voice_tick(SfxVoiceB);',
     'if (SfxActive != 0) sound_sfx_voice_tick(SfxVoiceB);'),
    ('sound.c', 'if (SoundModuleSlot[MODULE_MUSIC_CURRENT] == tune) return;',
     'if (SoundModuleSlot[MODULE_MUSIC_CURRENT] != tune) return;'),
]
