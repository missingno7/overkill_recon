"""Bounded title staging/reveal differential tests for the candidate C region.

Install as tests/title_reveal.py with title_reveal.c/asm. The stage case stubs only
the packed-image blitter after recording its arguments. The reveal case executes the
real merge and screen-copy pixel leaves over a synthetic two-page workspace, while
input polls, retraces and the flash blitter are controlled. It never runs the demo.
"""
from difftest import Case
from world import World, K
from emu import REG
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
from options import hook, cleanup, return_service, check
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'title_reveal.c']
FREE = ('SP', 'DS', 'SS')
C_ENTRIES = {
    'StageTitleLogoPieces': 'STAGE_TITLE_LOGO_PIECES',
    'RevealTitleLogoCells': 'REVEAL_TITLE_LOGO_CELLS',
    'PollInputBits': 'POLL_INPUT_BITS',
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


def symbol_entry(side, pair, name):
    if side is pair.b and name in C_ENTRIES:
        return C_ENTRIES[name]
    return name


def code_word(side, address):
    machine = getattr(side, 'm', side)
    return struct.unpack('<H', bytes(machine.u.mem_read(address, 2)))[0]


def stage_pieces(w, name):
    pair = w.pair
    bag, observed, saved_offsets = [], [], []
    w.word('TitleLogoPiecePtr', pair.sym('TitleLogoPieces'))

    for side in (pair.a, pair.b):
        offsets_at = side.m.linear('BlueBitsImageOffsets')
        saved_offsets.append((side, offsets_at,
                              bytes(side.m.u.mem_read(offsets_at, 19 * 2))))
        side.m.u.mem_write(offsets_at,
                           b''.join(struct.pack('<H', image * 16) for image in range(19)))
        obs = dict(name=name, rowcols=[], blits=[])
        observed.append(obs)

        def offset(u, address, size, _, side=side, obs=obs):
            obs['rowcols'].append(u.reg_read(REG['AX']))
        hook(side, bag, UC_HOOK_CODE, offset, side.m.linear('DrawOffsetFromWideRow'))

        def blit(u, address, size, _, side=side, obs=obs):
            obs['blits'].append((u.reg_read(REG['DS']), u.reg_read(REG['SI']),
                                 u.reg_read(REG['DI']), u.reg_read(REG['ES'])))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, blit, side.m.linear('BlitPackedStride160'))
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    def done(m, regs):
        check(observed[0] == observed[1], f'{name}: row/column traversal and image blits')
        obs = observed[0]
        table = m.read(pair.sym('TitleLogoPieces'), 15)
        expected_rowcols = [table[i] << 8 | table[i + 1] for i in range(0, 15, 3)]
        expected_images = [table[i + 2] for i in range(0, 15, 3)]
        check(obs['rowcols'] == expected_rowcols, f'{name}: tuple row/column values')
        check(len(obs['blits']) == 5, f'{name}: exactly five staged pieces')
        image_ids = []
        workspace = m.peek('WorkspaceSegment')
        source_segment = m.peek('BlueBitsSegment')
        for ds, source, destination, es in obs['blits']:
            image = None
            for candidate in range(19):
                at = m.linear('BlueBitsImageOffsets') + candidate * 2
                if code_word(m, at) == source:
                    image = candidate
                    break
            image_ids.append(image)
            check(ds == source_segment, f'{name}: image source segment')
            check(es == workspace, f'{name}: staging page uses workspace ES')
            check(0x7D00 <= destination < 0xFA00,
                  f'{name}: staging page destination offset')
        check(image_ids == expected_images, f'{name}: tuple image selection')
        check(m.word(pair.sym('TitleLogoPiecePtr')) == pair.sym('TitleLogoPieces') + 15,
              f'{name}: piece cursor advances by five tuples')

    try:
        yield Case('StageTitleLogoPieces', {'ES': pair.a.m.peek('WorkspaceSegment')},
                   w.writes(), FREE, expect=done, name=name)
    finally:
        cleanup(pair, bag)
        for side, address, prior in reversed(saved_offsets):
            side.m.u.mem_write(address, prior)


def reveal_cells(w, name, *, unchanged=False, sfx_enabled=1, key_make=0):
    pair = w.pair
    bag, observed, saved_memory = [], [], []
    saved_pristine = []
    workspace_bytes = 2 * 0x7D00
    screen_bytes = 0x10000
    for side in (pair.a, pair.b):
        saved_pristine.append((side, side.pristine))
        workspace_at = side.m.peek('WorkspaceSegment') * 16
        screen_at = side.m.peek('ScreenSegment') * 16
        saved_memory.append((side, workspace_at,
                             bytes(side.m.u.mem_read(workspace_at, workspace_bytes))))
        saved_memory.append((side, screen_at,
                             bytes(side.m.u.mem_read(screen_at, screen_bytes))))
        fixture = bytearray(workspace_bytes)
        if unchanged:
            fixture[:0x7D00] = b'\xA5' * 0x7D00
        fixture[0x7D00:] = b'\xA5' * 0x7D00
        side.m.u.mem_write(workspace_at, bytes(fixture))
        side.m.u.mem_write(screen_at, bytes(screen_bytes))
        # Pair.run starts each image from Side.pristine; include the synthetic pixel pages.
        side.pristine = side.m.state()

    w.word('InputDeviceMode', K.INPUT_MODE_KEYS_A).byte('SfxEnabled', sfx_enabled).byte('SfxRequest', 0x53)
    w.byte('KeyLastMakeCode', key_make).put('KeyDownTable', bytes(K.KEY_DOWN_COUNT))
    sfx_reads_at = pair.sym('SfxEnabled')

    for side in (pair.a, pair.b):
        obs = dict(name=name, flashes=[], retraces=0, polls=0, sfx_reads=0)
        observed.append(obs)

        def flash(u, address, size, _, side=side, obs=obs):
            obs['flashes'].append((u.reg_read(REG['DS']), u.reg_read(REG['SI']),
                                   u.reg_read(REG['DI'])))
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, flash, side.m.linear('BlitPackedToScreen'))

        def retrace(u, address, size, _, side=side, obs=obs):
            obs['retraces'] += 1
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, retrace, side.m.linear('WaitVerticalRetrace'))

        def poll(u, address, size, _, side=side, obs=obs):
            obs['polls'] += 1
            side.m.write(pair.sym('InputBits'), b'\0')
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, poll,
             side.m.linear(symbol_entry(side, pair, 'PollInputBits')))

        sfx_at = side.m.data_frame * 16 + sfx_reads_at
        def read_sfx(u, access, address, size, value, _, obs=obs):
            obs['sfx_reads'] += 1
        hook(side, bag, UC_HOOK_MEM_READ, read_sfx, sfx_at)
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    def done(m, regs):
        check(observed[0] == observed[1], f'{name}: pixel reveal and service traces')
        obs = observed[0]
        cells = 38 + 112 + 300 + 96 + 114
        changed_cells = 0 if unchanged else cells
        cell_retraces = (changed_cells - 38) if changed_cells and key_make == 0 else 0
        delay_frames = (4 * 10 + 0x50) if key_make == 0 else 0
        check(len(obs['flashes']) == changed_cells,
              f'{name}: flash only changed cells')
        for ds, source, _ in obs['flashes']:
            check(ds == m.peek('BlueBitsSegment'), f'{name}: flash image source segment')
            check(source == code_word(m, m.linear('BlueBitsImageOffsets') + 0x12 * 2),
                  f'{name}: flash uses image 12h')
        check(obs['retraces'] == cell_retraces + delay_frames,
              f'{name}: key-gated cell and delay retraces')
        check(obs['polls'] == delay_frames, f'{name}: bounded delay input polls')
        expected_sfx_reads = 0
        if changed_cells:
            expected_sfx_reads = cells if not sfx_enabled else (38 + 300 + 96 + 114) * 2 + 112
        check(obs['sfx_reads'] == expected_sfx_reads,
              f'{name}: IRQ-visible SFX checks remain separate')
        check(m.word(pair.sym('RevealRectPtr')) == pair.sym('TitleRevealRects') + 20,
              f'{name}: rectangle cursor advances through all five rectangles')
        check(m.word(pair.sym('RevealRectsLeft')) == 1, f'{name}: final rectangle count')
        check(m.word(pair.sym('RevealColumns')) == 0x13,
              f'{name}: final rectangle column count')
        check(m.read(pair.sym('RevealRow'), 1) == b'\xB0',
              f'{name}: final row follows the last rectangle')
        check(m.read(pair.sym('RevealCol'), 1) == b'\x02',
              f'{name}: final column is restored to the last rectangle start')
        expected_sfx_request = 0x53 if not changed_cells or not sfx_enabled else 0x0E
        check(m.read(pair.sym('SfxRequest'), 1) == bytes((expected_sfx_request,)),
              f'{name}: sound request follows both volatile enable reads')

    try:
        yield Case('RevealTitleLogoCells', {}, w.writes(), FREE,
                   expect=done, name=name)
    finally:
        cleanup(pair, bag)
        for side, address, prior in reversed(saved_memory):
            side.m.u.mem_write(address, prior)
        for side, pristine in saved_pristine:
            side.pristine = pristine


def cases(rng, scale, pair):
    saved_entries = install_entries(pair)
    prior_video = [side.m.peek('VideoAdapter') for side in (pair.a, pair.b)]
    try:
        yield from stage_pieces(World(pair, rng).plausible(), 'stage all five title pieces')
        for adapter in (K.VIDEO_CGA, K.VIDEO_EGA, K.VIDEO_TANDY):
            for side in (pair.a, pair.b):
                side.m.poke('VideoAdapter', adapter)
            w = World(pair, rng).plausible()
            yield from reveal_cells(w, f'reveal five rectangles on adapter {adapter}')
            yield from reveal_cells(World(pair, rng).plausible(),
                                    f'unchanged cells on adapter {adapter}', unchanged=True)
            yield from reveal_cells(World(pair, rng).plausible(),
                                    f'SFX disabled on adapter {adapter}', sfx_enabled=0)
            yield from reveal_cells(World(pair, rng).plausible(),
                                    f'pending key skips pacing on adapter {adapter}', key_make=0x1E)
    finally:
        for side, adapter in zip((pair.a, pair.b), prior_video):
            side.m.poke('VideoAdapter', adapter)
        restore_entries(saved_entries)


MUTANTS = [
    ('title_reveal.c', 'piece < 5', 'piece < 4'),
    ('title_reveal.c', 'TitleLogoPiecePtr = (word)cursor;', 'TitleLogoPiecePtr = (word)(cursor - 1);'),
    ('title_reveal.c', 'second = title_reveal_sound_enabled();', 'second = first;'),
    ('title_reveal.c', 'rectangles_left != 5 &&', 'rectangles_left == 5 &&'),
    ('title_reveal.c', 'RevealRow + 8', 'RevealRow + 4'),
    ('title_reveal.c', 'delay_frames_until_key_or_primary(0x50);',
     'delay_frames_until_key_or_primary(0x4F);'),
    ('title_reveal.c', 'if (title_reveal_sound_enabled() != 0) SfxRequest = 0x0A;',
     'SfxRequest = 0x0A;'),
    ('title_reveal.c', 'if (title_call_main_result(TitleMergeRevealCell) != 0)',
     'if (title_call_main_result(TitleMergeRevealCell) == 0)'),
]
