"""Title, attract and win control with synchronized keyboard/retrace boundaries.

Real keyboard normalization, logo staging blits and win page-list control execute.
Backdrop/reveal presentation, retrace hardware and the intro/demo have bounded
service hooks: this suite never enters the original full-game demo loop.
"""
from difftest import Case
from world import World, K
from emu import REG
from unicorn import UC_HOOK_CODE
from options import hook, cleanup, return_service, keys, check
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'title.c']
FREE = ('SP', 'DS', 'SS')

def driven(w, label, name, frames=1, masks=(), make=0, key_at=0,
           backdrop_key=0, reveal_key=0, demo_key=0, expect=None):
    pair = w.pair; bag = []; observed = []
    w.put('KeyDownTable', bytes(K.KEY_DOWN_COUNT)).byte('KeyLastMakeCode', make)
    for side in (pair.a, pair.b):
        obs = dict(trace=[], polls=0, frames=0, reveals=0)
        observed.append(obs)
        def service(label, action=None, skip=True, far=False):
            def callback(u, address, size, _, side=side, obs=obs):
                obs['trace'].append((label,))
                if action: action(u, side, obs)
                if skip: return_service(side, far)
            c_entries = {
                'StageTitleLogoPieces': 'STAGE_TITLE_LOGO_PIECES',
                'RevealTitleLogoCells': 'REVEAL_TITLE_LOGO_CELLS',
                'RunIntroPagesAndDemo': 'RUN_INTRO_PAGES_AND_DEMO',
                'ShowPages': 'SHOW_PAGES',
                'LoadAndShowPage': 'LOAD_AND_SHOW_PAGE',
            }
            oracle_entries = {'ShowPages': 'ShowPageList'}
            entry = c_entries.get(label, label) if side is pair.b else oracle_entries.get(label, label)
            hook(side, bag, UC_HOOK_CODE, callback, side.m.linear(entry))
        def backdrop(u, side, obs):
            # DrawTitleBackdrop establishes ES for the following staging blits.
            u.reg_write(REG['ES'], side.m.peek('WorkspaceSegment'))
            if backdrop_key: side.m.write(pair.sym('KeyLastMakeCode'), bytes((backdrop_key,)))
        service('DrawTitleBackdrop', backdrop)
        service('ResetPageAndClearScreen')
        service('CgaSelectBrightPalette0')
        service('CgaSelectBrightPalette1')
        service('CopyFullWorkspaceToScreen')
        def stage(u, side, obs):
            obs['trace'].append(('piece pointer', side.m.word(pair.sym('TitleLogoPiecePtr'))))
        service('StageTitleLogoPieces', stage, False)
        def reveal(u, side, obs):
            obs['reveals'] += 1
            if obs['reveals'] == reveal_key:
                side.m.write(pair.sym('KeyLastMakeCode'), bytes((K.SCAN_C,)))
        service('RevealTitleLogoCells', reveal)
        def intro(u, side, obs):
            if demo_key: side.m.write(pair.sym('KeyLastMakeCode'), bytes((demo_key,)))
        service('RunIntroPagesAndDemo', intro)
        def retrace(u, side, obs):
            obs['frames'] += 1
            if obs['frames'] == key_at:
                side.m.write(pair.sym('KeyLastMakeCode'), bytes((K.SCAN_C,)))
        service('WaitVerticalRetrace', retrace)
        # The oracle page viewer is far; the C coordinator enters its narrow helper.
        # Both execute the one-page list and share the bounded page-load leaf below.
        service('ShowPages', skip=False, far=True)
        service('LoadAndShowPage')
        def poll(u, address, size, _, side=side, obs=obs):
            i = obs['polls']; obs['polls'] += 1
            mask = masks[min(i, len(masks) - 1)] if masks else 0
            obs['trace'].append(('input', mask))
            side.m.write(pair.sym('KeyDownTable'), keys(mask))
        entry = 'PollInputBits' if side is pair.a else 'POLL_INPUT_BITS'
        hook(side, bag, UC_HOOK_CODE, poll, side.m.linear(entry))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        check(observed[0] == observed[1], 'matching title service trace and input consumption')
        if expect: expect(m, regs, observed[0])
    try:
        yield Case(label, {'CX': frames}, w.writes(), FREE,
                   outputs=('CX',) if label == 'DelayFramesUntilKeyOrPrimary' else (),
                   expect=done, name=name)
    finally: cleanup(pair, bag)

def cases(rng, scale, pair):
    undo = []
    for side in (pair.a, pair.b):
        bank = side.m.peek('BlueBitsSegment') * 16
        for image in range(15):
            offset = image * 16
            data = struct.pack('<HH', 1, 1) + bytes((image + 1, image ^ 0xFF, image + 1, image))
            for at, payload in ((side.m.linear('BlueBitsImageOffsets') + image * 2, struct.pack('<H', offset)),
                                (bank + offset, data)):
                undo.append((side, at, bytes(side.m.u.mem_read(at, len(payload)))))
                side.m.u.mem_write(at, payload)
    try:
        for mode in (K.INPUT_MODE_KEYS_A, K.INPUT_MODE_KEYS_B):
            def world():
                return World(pair, rng).plausible().word('InputDeviceMode', mode)
            for n in (0, 1, 2, 10, 30, 50, 75, 0xFFFF):
                for make in (1, K.SCAN_SPACE, 0xFF):
                    yield from driven(world(), 'DelayFramesUntilKeyOrPrimary', f'immediate {mode}/{n}/{make}',
                                      frames=n, make=make,
                                      expect=lambda m, r, o, n=n: check(r['CX'] == n and o['frames'] == 0, 'early key keeps CX'))
                for mask in range(64):
                    # Interrupt zero/FFFF counts promptly, while exercising their wrap.
                    stream = (mask,) if mask & K.IN_BUTTON_PRIMARY else (mask, K.IN_BUTTON_PRIMARY | mask)
                    yield from driven(world(), 'DelayFramesUntilKeyOrPrimary', f'button {mode}/{n}/{mask}',
                                      frames=n, masks=stream)
            for n in (1, 2, 10, 30, 50, 75):
                for at in (0, 1, n, n + 1):
                    yield from driven(world(), 'DelayFramesUntilKeyOrPrimary', f'key timing {mode}/{n}/{at}',
                                      frames=n, key_at=at)
            for label in ('PlayTitleAnimation', 'RunAttractSequence'):
                for back in (0, K.SCAN_C, 0xFF):
                    for reveal in range(4):
                        yield from driven(world().word('TitleLogoPiecePtr', 0x1234), label,
                                          f'{label} stage key {mode}/{back}/{reveal}',
                                          backdrop_key=back, reveal_key=reveal, demo_key=K.SCAN_ESC)
                for at in (1, 29, 30, 31, 79, 80, 81):
                    yield from driven(world(), label, f'{label} frame key {mode}/{at}', key_at=at)
                for mask in range(64):
                    yield from driven(world(), label, f'{label} primary {mode}/{mask}', masks=(mask,))
            for mask in range(64):
                tail = mask | K.IN_BUTTON_PRIMARY
                yield from driven(world(), 'ShowWinScreenAndWaitPrimary', f'win {mode}/{mask}',
                                  masks=(mask, 0, tail),
                                  expect=lambda m, r, o: check(o['frames'] == 75, 'win waits 75 frames before polling'))
        for i in range(100 * scale):
            masks = tuple(rng.randrange(64) & ~K.IN_BUTTON_PRIMARY for _ in range(rng.randrange(12)))
            masks += (rng.randrange(64) | K.IN_BUTTON_PRIMARY,)
            w = World(pair, rng).plausible().word('InputDeviceMode', rng.choice((0, 2)))
            yield from driven(w, rng.choice(('DelayFramesUntilKeyOrPrimary', 'ShowWinScreenAndWaitPrimary')),
                              f'random {i}', frames=rng.randrange(100), masks=masks)
    finally:
        for side, at, data in reversed(undo): side.m.u.mem_write(at, data)

MUTANTS = [
    ('title.c', 'if (InputBits & IN_BUTTON_PRIMARY)', 'if (InputBits == IN_BUTTON_PRIMARY)'),
    ('title.c', 'KeyLastMakeCode = SCAN_SPACE;', 'KeyLastMakeCode = SCAN_ESC;'),
    ('title.c', 'frames--;', 'frames -= 2;'),
    ('title.c', 'round < 3', 'round < 2'),
    ('title.c', 'round < 2 &&', 'round < 1 &&'),
    ('title.c', 'delay_frames_until_key_or_primary(30);', 'delay_frames_until_key_or_primary(29);'),
    ('title.c', 'delay_frames_until_key_or_primary(50);', 'delay_frames_until_key_or_primary(49);'),
    ('title.c', 'frame < 30', 'frame < 29'),
    ('title.c', 'frame < 75', 'frame < 74'),
    ('title.c', 'while ((InputBits & IN_BUTTON_PRIMARY) == 0)', 'while (InputBits != IN_BUTTON_PRIMARY)'),
]
