"""Whole high-score insertion/editor against ASM, including DOS key decoding.

Text and page presentation are observed at their existing service boundaries.
The original ReadKeyThroughDos and keyboard-buffer clear run; only DOS/BIOS
interrupts and vector installation are supplied by the bounded test environment.
"""
from difftest import Case
from world import World
from emu import REG
from unicorn import UC_HOOK_CODE
from options import hook, cleanup, return_service, check
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'hiscore.c']
C_ENTRIES = {
    'ShowHighScoreTable': 'SHOW_HIGH_SCORE_TABLE',
    'PrintMessageBP': 'TEXT_PRINT_MESSAGE',
    'PrintBcd32': 'TEXT_PRINT_BCD32',
}

def table(scores, rng):
    data = bytearray(rng.randrange(256) for _ in range(144))
    for rank, score in enumerate(scores): struct.pack_into('<I', data, rank * 16 + 12, score)
    return bytes(data)

def driven(w, stream, name, score_at='ScoreBcd', expect=None, update=False):
    pair = w.pair; bag = []; observed = []
    for side in (pair.a, pair.b):
        obs = dict(keys=0, trace=[]); observed.append(obs)
        def service(label, action=None):
            def callback(u, address, size, _, side=side, obs=obs):
                obs['trace'].append((label,))
                if action: action(u, side, obs)
                return_service(side)
            entry = C_ENTRIES.get(label, label) if side is pair.b else label
            if label == 'SaveHiscoreFile' and side is pair.b: entry = 'SAVE_HISCORE_FILE'
            hook(side, bag, UC_HOOK_CODE, callback, side.m.linear(entry))
        def panel(u, side, obs):
            obs['trace'].append(('panel', u.reg_read(REG['AX']), u.reg_read(REG['SI'])))
        def message(u, side, obs):
            if side is pair.b:
                registers = u.reg_read(REG['SI'])
                ptr = side.m.word(registers)
            else:
                ptr = u.reg_read(REG['BP'])
            length = 11 if ptr == pair.sym('HiscoreNameBuffer') else 6
            obs['trace'].append(('text', ptr, side.m.read(ptr, length)))
        def score(u, side, obs):
            if side is pair.b:
                registers = u.reg_read(REG['SI'])
                ptr = side.m.word(registers)
            else:
                ptr = u.reg_read(REG['BP'])
            obs['trace'].append(('score', side.m.read(ptr, 4)))
        if update:
            service('ResetPageAndClearScreen')
            service('SaveHiscoreFile')
        service('ShowHighScoreTable')
        service('DrawPanelGraphic', panel)
        service('PrintMessageBP', message)
        service('PrintBcd32', score)
        service('RestoreKeyboardVector09')
        service('InstallKeyboardVector09')
        def interrupts(u, address, size, _, side=side, obs=obs):
            opcode = bytes(u.mem_read(address, size))
            if opcode[:1] != b'\xCD': return
            number = opcode[1]; ax = u.reg_read(REG['AX']); ah = ax >> 8
            if number == 0x21 and ah == 7:
                check(obs['keys'] < len(stream), 'DOS input stream exhausted')
                key = stream[obs['keys']]; obs['keys'] += 1
                obs['trace'].append(('DOS key', key))
                u.reg_write(REG['AX'], (ax & 0xFF00) | key)
            elif number == 0x21 and ah == 9:
                obs['trace'].append(('DOS blank line', side.m.read(u.reg_read(REG['DX']), 11)))
            elif number == 0x10 and ah == 2:
                obs['trace'].append(('BIOS cursor', u.reg_read(REG['DX']), u.reg_read(REG['BX']) >> 8))
            elif number == 0x10 and ax == 0x0E07: obs['trace'].append(('beep',))
            else: raise AssertionError(f'unexpected interrupt {number:02X} AX={ax:04X}')
            u.reg_write(REG['IP'], (u.reg_read(REG['IP']) + size) & 0xFFFF)
        hook(side, bag, UC_HOOK_CODE, interrupts, side.image[0], side.image[1])
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])
    def done(m, regs):
        check(observed[0] == observed[1], 'matching presentation, DOS input and beep trace')
        if expect: expect(m, observed[0])
    try:
        yield Case('UpdateHighScoreTable' if update else 'InsertHighScore',
                   {'BP': pair.sym(score_at), 'SI': pair.sym(score_at)}, w.writes(), ('SP', 'DS', 'SS'),
                   expect=done, name=name)
    finally: cleanup(pair, bag)

def cases(rng, scale, pair):
    names = {'INSERTHIGHSCORE': 'INSERT_HIGH_SCORE', 'UPDATEHIGHSCORETABLE': 'UPDATE_HIGH_SCORE_TABLE'}
    prior = {name: pair.b.m.symbols.get(name) for name in names}
    for name, target in names.items(): pair.b.m.symbols[name] = pair.b.m.symbols[target]
    try:
        yield from score_cases(rng, scale, pair)
    finally:
        for name, value in prior.items():
            if value is None: pair.b.m.symbols.pop(name, None)
            else: pair.b.m.symbols[name] = value


def score_cases(rng, scale, pair):
    scores = tuple((8 - i) * 0x1000 for i in range(8))
    def world(values=scores, score=0x9000, flag=0):
        return (World(pair, rng).plausible().put('HiscoreBlock', table(values, rng))
                .put('ScoreBcd', struct.pack('<I', score)).word('HiscoreQualified', flag)
                .put('KeyDownTable', bytes([0xFF]) * 128))
    for score in (0, 0x1000, 0x1001, 0x8000, 0x8001, 0xFFFFFFFF):
        for stale in (0, 1, 0xFFFF):
            def updated(m, o):
                count = sum(t == ('SaveHiscoreFile',) for t in o['trace'])
                check(count == (m.word(pair.sym('HiscoreQualified')) != 0), 'save exactly when the new score qualified')
            yield from driven(world(score=score, flag=stale), (65, 13),
                              f'update score {score}/{stale}', expect=updated, update=True)
    for rank in range(8):
        for offset in (-1, 0, 1):
            for flag in (0, 1, 0xFFFF):
                score = scores[rank] + offset
                yield from driven(world(score=score, flag=flag), (ord('X'), 13), f'rank {rank} offset {offset} flag {flag}')
    for i, stream in enumerate(((13,), (8, 13), (8, 8, 65, 8, 8, 13),
                                tuple(b'ABCDEFGHIJ') + (13,), tuple(b'ABCDEFGHIJK') + (13,),
                                tuple(b'ABCDEFGHIJ') + (1, 31, 0x7B, 0xFF, 8, ord('z'), 13),
                                (0, 0x48, 0, 0x3B, 0, 0x7B, 13),
                                (0x20, 0x7A, 0x21, 8, 13))):
        yield from driven(world(), stream, f'editor edge {i}')
    for key in range(1, 256):
        stream = (key,) if key == 13 else (key, 13)
        yield from driven(world(), stream, f'ASCII {key}')
        full = tuple(b'0123456789') + stream
        yield from driven(world(), full, f'full ASCII {key}')
        yield from driven(world(), (0, key, 13), f'extended key {key}')
    # The input comparator and stored score are deliberately different here.
    yield from driven(world(score=1).put('HiscoreNameSlack', struct.pack('<I', 0xFFFFFFFF)),
                      (65, 13), 'external score pointer', score_at='HiscoreNameSlack')
    for value in (0, 1, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF):
        for new in (value, (value + 1) & 0xFFFFFFFF, (value - 1) & 0xFFFFFFFF):
            yield from driven(world((value,) * 8, new), (13,), f'equal table {value}/{new}')
    for i in range(300 * scale):
        values = tuple(sorted((rng.randrange(0x100000000) for _ in range(8)), reverse=True))
        score = rng.choice((*values, rng.randrange(0x100000000)))
        stream = []
        for _ in range(rng.randrange(35)):
            key = rng.choice((8, 0x20, 0x7A, 0x7B, 0xFF, rng.randrange(1, 256)))
            if key == 13: key = 12
            if rng.randrange(5) == 0: stream.append(0)
            stream.append(key)
        stream.append(13)
        yield from driven(world(values, score, rng.randrange(65536)), tuple(stream), f'random {i}')

MUTANTS = [
    ('hiscore.c', 'HiscoreQualified = 0;', 'HiscoreQualified = 1;'),
    ('hiscore.c', 'if (HiscoreQualified != 0) save_hiscore_file();', 'if (HiscoreQualified == 0) save_hiscore_file();'),
    ('hiscore.c', '*(dword *)(entry + 12) < *(dword *)score', '*(dword *)(entry + 12) <= *(dword *)score'),
    ('hiscore.c', 'rank < 8', 'rank < 7'),
    ('hiscore.c', 'source[16] = source[0];', 'source[15] = source[0];'),
    ('hiscore.c', 'HiscoreEntryRow += 2;', 'HiscoreEntryRow++;'),
    ('hiscore.c', 'key <= 0x7A', 'key < 0x7A'),
    ('hiscore.c', 'key >= 0x20', 'key > 0x20'),
    ('hiscore.c', "*(byte *)HiscoreNameCursor = ' ';\n            }", "*(byte *)HiscoreNameCursor = 0;\n            }"),
    ('hiscore.c', 'entry[12 + i] = ScoreBcd[i];', 'entry[12 + i] = score[i];'),
]
