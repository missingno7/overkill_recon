"""Life reset and per-life music: whole state, CS cursor writes and real sound mailbox.

Stale records and mixed pod occupancy exercise selective reset, reverse save-buffer
assignment and exhaust allocation. Music runs the original module request service.
"""
from difftest import Case, ALL_REGS, far
from world import World, K
from emu import REG, LOAD
import hybrid

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'life.c']

def cases(rng, scale, pair):
    for i in range(400 * scale):
        w = World(pair, rng).plausible()
        w.put('GroupTable', bytes(rng.randrange(256) for _ in range(32)))
        w.put('BeamList', bytes(rng.randrange(256) for _ in range(52)))
        w.word('PoolACursor', w.slot('PoolA', i % K.POOL_A_COUNT))
        w.word('RefuelActive', (0, 1, 2, 0xFFFF)[i % 4])
        w.word('DemoActive', (0, 1, 2, 0xFFFF)[i // 4 % 4])
        w.byte('SfxEnabled', (0, 1, 2, 0xFF)[i // 16 % 4]).byte('SfxRequest', 0x55)
        w.record('PrimaryRecord', 0).randomize().set(sprite=i % 6, kind=i % 7)
        # Keep one non-pod so the allocator has a reachable free record.
        free = i % K.POOL_A_COUNT
        for j in range(K.POOL_A_COUNT):
            kind = K.KIND_ENEMY if j == free else rng.choice((K.KIND_POD, K.KIND_POD, K.KIND_ENEMY, 0xFFFF))
            w.record('PoolA', j).randomize().set(kind=kind, status=rng.choice((0, 1, 2, 0xFFFF)))
        for j in range(K.POOL_B_COUNT): w.record('PoolB', j).randomize()
        def expect(m, regs):
            assert regs['BP'] == pair.sym('PrimaryRecord'), 'reset returns the primary anchor'
            assert m.word(pair.sym('Fuel')) == 0, 'reset leaves fuel empty'
            assert m.word(pair.sym('EnergyPoints')) == 0x18, 'reset fills the energy bar'
        yield Case('ResetRecordsForLife', {'BP': pair.sym('PoolB'), 'ES': 0xB800}, w.writes(),
                   ('SP', 'DS', 'SS'), ('BP', 'ES'), expect=expect, name=f'stale pools {i}')
    # The routine has no runtime ASM caller left: a test alias enters the C body.
    name = 'RESETINVADERFORMATION'
    pair.b.m.symbols[name] = pair.b.m.symbols['RESET_INVADER_FORMATION']
    try:
        for i in range(20):
            w = (World(pair, rng).word('InvaderSlotCursor', rng.randrange(65536))
                 .word('InvaderNextMarchLeft', rng.randrange(65536)).word('InvaderNextDropStep', rng.randrange(65536)))
            yield Case('ResetInvaderFormation', writes=w.writes(), preserve=tuple(r for r in ALL_REGS if r != 'AX'))
    finally: del pair.b.m.symbols[name]
    name = 'REQUESTLIFESTARTMUSIC'
    pair.b.m.symbols[name] = pair.b.m.symbols['REQUEST_LIFE_START_MUSIC']
    try:
        yield from music_cases(rng, pair)
    finally: del pair.b.m.symbols[name]

def music_cases(rng, pair):
    for pos in (K.MAP_START_POS, K.MAP_END_POS, K.MAP_START_POS - 1, K.MAP_START_POS + 1,
                K.MAP_END_POS - 1, K.MAP_END_POS + 1, 0, 0xFFFF):
        for level in (0, 1, 2, 3, 4, 5, 0x100, 0x105, 0x1FF, 0xFF00):
            for enabled in (0, 1, 2, 0xFF):
                tune = (K.MUSIC_LEVEL_START if pos == K.MAP_START_POS else
                        K.MUSIC_LEVEL_END if pos == K.MAP_END_POS else
                        pair.a.pristine[pair.sym('LevelMusicTable') + (level & 255)])
                for current in (0, tune, 0xFF):
                    w = (World(pair, rng).word('MapScrollPos', pos).word('LevelIndex', level)
                         .byte('ModuleSoundEnabled', enabled).byte('ModuleSoundRequest', 0x55)
                         .put(far('SoundModuleSlot', K.MODULE_MUSIC_REQUEST), bytes((0x55, current))))
                    def returned_es(m, regs, enabled=enabled):
                        # C returns ES as ABI metadata in AX; the oracle returns it
                        # in ES. Compare both identities without a production stub.
                        expected = LOAD + pair.b.m.symbols['SOUNDMODULESLOT'][0] if enabled else 0xB800
                        assert pair.b.m.u.reg_read(REG['AX']) == expected, 'C carries the sound service ES result'
                        assert regs['ES'] == ('sound module segment' if enabled else 'unchanged'), 'oracle music ES contract'
                    yield Case('RequestLifeStartMusic', {'BP': pair.sym('PoolA'), 'SI': 0xB800, 'ES': 0xB800}, w.writes(),
                               ('BP', 'SP', 'DS', 'SS'), expect=returned_es, name=f'music {pos}/{level}/{enabled}/{current}')

MUTANTS = [
    ('life.c', 'r->kind != KIND_POD', 'r->kind == KIND_POD'),
    ('life.c', 'PoolBPointers[n - 1]', 'PoolBPointers[POOL_B_COUNT - n]'),
    ('life.c', 'PoolAPointers[n - 1]', 'PoolAPointers[POOL_A_POINTER_COUNT - n]'),
    ('life.c', 'SaveBufferCursor += POOL_A_SAVE_BYTES;', 'SaveBufferCursor += POOL_B_SAVE_BYTES;'),
    ('life.c', 'n < 26', 'n < 25'),
    ('life.c', 'PRIMARY->x = 0x58;', 'PRIMARY->x = 0x60;'),
    ('life.c', 'pickup_fuel();', 'RefuelActive = 1;'),
    ('life.c', 'InvaderNextDropStep = 0;', 'InvaderNextDropStep = 1;'),
    ('life.c', 'MapScrollPos == MAP_END_POS', 'MapScrollPos >= MAP_END_POS'),
    ('life.c', 'LevelMusicTable[(byte)LevelIndex]', 'LevelMusicTable[LevelIndex]'),
    ('life.c', 'return life_request_music(tune, es);', 'life_request_music(tune, es); return es;'),
]
