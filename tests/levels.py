"""Differential tests for the level, graphics-file and page-load coordinators.

Only resource I/O, decoder bodies, the BIOS keyboard tail and page blit are stubbed.
Their calls still enter at the same retained ASM labels on both images, so the suite
checks C ordering, segment/register adapters, persistent loader fields and state writes.
"""
from difftest import Case
from world import World, K
from emu import REG
from unicorn import UC_HOOK_CODE
from options import hook, cleanup, return_service, check
import hybrid
import struct

REGION = [n for n, f in hybrid.owned_labels().items() if f == 'levels.c']
REGISTERS = {'BP': 0x4567, 'ES': 0xB800}
KEEP = ('SP', 'DS', 'SS')
CS_TABLES = ('PANELIMAGEOFFSETS', 'BLUEBITSIMAGEOFFSETS',
             'PLAQUEIMAGEOFFSET', 'SCREENIMAGEOFFSET')


def cs_slot(side, value):
    """Render a CS offset table pointer symbolically across the two links."""
    for name in CS_TABLES:
        if side.m.symbols.get(name, (None, None))[1] == value:
            return name
    return value


def install_services(pair, side, bag, obs, fail_first=False, load_map=False,
                     blit=False):
    def address(label):
        return side.m.linear(label)

    def resource(u, pc, size, _, side=side, obs=obs):
        name = side.m.word(pair.sym('FileNamePtr'))
        segment = side.m.word(pair.sym('FileBufferSegment'))
        offset = side.m.word(pair.sym('FileBufferOffset'))
        if side is pair.a:
            inherited = (u.reg_read(REG['BP']), u.reg_read(REG['ES']))
        else:
            registers = u.reg_read(REG['SI'])
            inherited = (side.m.word(registers), side.m.word(registers + 2))
        obs['resource_registers'].append(inherited)
        obs['resources'].append((name, segment, offset,
                                 side.m.peek('LoadDestSegment'),
                                 side.m.peek('LoadDestOffset'),
                                 cs_slot(side, side.m.peek('LoadImageSlot')),
                                 side.m.read(pair.sym('LoadIsEnc'), 1)[0]))
        if name == pair.sym('File_BLUEBITS_BIC'):
            panel_bytes = 15 * side.m.word(pair.sym('PanelImageBytes') + 2)
            panel_at = side.m.peek('PanelSegment') * 16
            obs['panel_result'] = bytes(u.mem_read(panel_at, panel_bytes))
        if fail_first and len(obs['resources']) == 1:
            side.m.set_word(pair.sym('FileStatus'), K.FILE_STATUS_READ_FAILED)
        else:
            side.m.set_word(pair.sym('FileStatus'), K.FILE_STATUS_OK)
            if load_map:
                dest = segment * 16 + offset
                u.mem_write(dest, bytes([0x5A]) * K.MAP_END_POS)
        return_service(side)

    def prompt(u, pc, size, _, side=side, obs=obs):
        obs['prompts'] += 1
        if side is pair.a:
            inherited = (u.reg_read(REG['BP']), u.reg_read(REG['ES']))
        else:
            registers = u.reg_read(REG['SI'])
            inherited = (side.m.word(registers), side.m.word(registers + 2))
        obs['prompt_registers'].append(inherited)
        return_service(side)

    def bios_tail(u, pc, size, _, side=side, obs=obs):
        obs['bios_tail'] += 1
        if load_map:
            obs['map_result'] = bytes(u.mem_read(0x9000 * 16, K.MAP_END_POS))
        u.reg_write(REG['ES'], 0)
        return_service(side)

    def decoder(u, pc, size, _, side=side, obs=obs):
        regs = (u.reg_read(REG['BP']), u.reg_read(REG['DS']), u.reg_read(REG['ES']),
                u.reg_read(REG['SI']), u.reg_read(REG['DI']))
        obs['decoders'].append((regs, side.m.peek('LoadNamePtr'),
                               side.m.peek('LoadDestSegment'),
                               side.m.peek('LoadDestOffset'),
                               cs_slot(side, side.m.peek('LoadImageSlot')),
                               side.m.peek('LoadMakeMask'),
                               side.m.peek('LoadRecordImages'),
                               side.m.read(pair.sym('LoadIsEnc'), 1)[0]))
        side.m.poke('DecodeFileFlags', regs[0])
        side.m.poke('DecodeImageIndex', 0xFFFF)
        u.reg_write(REG['DS'], side.m.data_frame)
        u.reg_write(REG['BP'], 0xA100 + len(obs['decoders']))
        u.reg_write(REG['ES'], 0xB200 + len(obs['decoders']))
        return_service(side)

    # The oracle enters its near ASM service with physical BP/ES. The hybrid now
    # calls the native C coordinator directly with a DosRegisters* in SI.
    resource_entry = 'LoadResourceFile' if side is pair.a else 'LOAD_RESOURCE_FILE'
    hook(side, bag, UC_HOOK_CODE, resource, address(resource_entry))
    prompt_entry = ('PromptLoadErrorWaitFire' if side is pair.a
                    else 'SYSTEM_PROMPT_LOAD_ERROR_WAIT_FIRE')
    hook(side, bag, UC_HOOK_CODE, prompt, address(prompt_entry))
    hook(side, bag, UC_HOOK_CODE, bios_tail, address('FlushBiosKeyboardBuffer'))
    hook(side, bag, UC_HOOK_CODE, decoder, address('DecodeGraphicsImages'))

    if blit:
        def page_blit(u, pc, size, _, side=side, obs=obs):
            obs['blits'].append((u.reg_read(REG['BP']), u.reg_read(REG['DS']),
                                 u.reg_read(REG['ES']), u.reg_read(REG['SI']),
                                 u.reg_read(REG['DI']), side.m.peek('LoadDestOffset')))
            u.reg_write(REG['BP'], 0xCAFE)
            u.reg_write(REG['ES'], 0xD00D)
            return_service(side)
        hook(side, bag, UC_HOOK_CODE, page_blit, address('BlitPackedToScreen'))


def traced_case(pair, world, label, name, fail_first=False, load_map=False, blit=False,
                expect=None):
    bag = []
    observed = []
    for side in (pair.a, pair.b):
        obs = {'resources': [], 'resource_registers': [], 'prompts': 0,
               'prompt_registers': [],
               'bios_tail': 0, 'decoders': [], 'blits': []}
        observed.append(obs)
        install_services(pair, side, bag, obs, fail_first, load_map, blit)
        side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    def done(m, regs):
        check(observed[0] == observed[1], f'{name}: service and adapter traces match')
        check(regs['BP'] == 0xCAFE if blit else True, f'{name}: BP output')
        check(regs['ES'] == 0xD00D if blit else True, f'{name}: ES output')
        if expect: expect(m, regs, observed[0])

    try:
        yield Case(label, REGISTERS, world.writes(), KEEP, ('BP', 'ES'), expect=done, name=name)
    finally:
        cleanup(pair, bag)


def map_world(pair):
    w = (World(pair, None).word('LevelIndex', 1).word('FileStatus', 0x7777)
         .word('FileNamePtr', 0xAAAA).word('FileBufferOffset', 0xBBBB)
         .put('KeyDownTable', bytes([1]) * K.KEY_DOWN_COUNT))
    return w


def seed_cs(pair, values):
    """Temporarily seed MAIN code-segment variables that are outside World writes."""
    saved = []
    for side in (pair.a, pair.b):
        for name, value, size in values:
            if isinstance(value, str): value = side.m.symbols[value.upper()][1]
            at = side.m.linear(name)
            old = bytes(side.m.u.mem_read(at, size))
            saved.append((side, at, old))
            side.m.u.mem_write(at, int(value).to_bytes(size, 'little'))
    return saved


def restore_cs(saved):
    for side, at, old in reversed(saved): side.m.u.mem_write(at, old)


def seed_memory(pair, address, payload):
    saved = []
    for side in (pair.a, pair.b):
        old = bytes(side.m.u.mem_read(address, len(payload)))
        saved.append((side, address, old))
        side.m.u.mem_write(address, payload)
    return saved


def level_map_expect(pair, requested_level, fail_first):
    level = requested_level & 0x7FFF
    def expect(m, regs, obs):
        check(len(obs['resources']) == (2 if fail_first else 1), 'map resource attempt count')
        check(obs['prompts'] == int(fail_first), 'retry prompt count')
        check(obs['bios_tail'] == 1, 'map load clears the BIOS keyboard tail')
        selected_map = m.word(pair.sym('LevelMapFiles') + 2 * level)
        check(m.word(pair.sym('FileNamePtr')) == selected_map, 'wrapped map filename')
        check(obs['resources'][0][0] == selected_map,
              'resource service receives the selected map filename')
        check(m.word(pair.sym('FileBufferSegment')) == m.peek('LevelMapSegment'),
              'map is the direct file buffer')
        check(m.word(pair.sym('FileBufferOffset')) == 0, 'map starts at offset zero')
        for i in range(6):
            check(m.word(pair.sym('LevelScriptCursors') + 2 * i) ==
                  pair.sym('LevelScript' + str(i)), f'level script cursor {i}')
        attrs = m.read(pair.sym('ByteAttributeTable'), K.BYTE_ATTRIBUTE_COUNT)
        check(attrs[1] == 0 and attrs[0x6C] == (2 if level in (1, 4) else 1) and
              attrs[2] == 1, 'selected level patch stream is applied')
        data = obs['map_result']
        check(data[:2 * K.MAP_ROW_BYTES] == bytes([1]) * (2 * K.MAP_ROW_BYTES),
              'the first two map rows are forced to tile 1')
        check(data[K.MAP_END_ROWS_POS:K.MAP_END_POS] ==
              m.read(pair.sym('LevelEndMapRows'), 5 * K.MAP_ROW_BYTES),
              'the five fixed end rows are copied')
        check(data[2 * K.MAP_ROW_BYTES:K.MAP_END_ROWS_POS] ==
              bytes([0x5A]) * (K.MAP_END_ROWS_POS - 2 * K.MAP_ROW_BYTES),
              'the loaded map body remains intact')
        check(regs['ES'] == 0, 'FlushBiosKeyboardBuffer leaves ES=0')
    return expect


def graphics_world(pair, level=1):
    return World(pair, None).word('LevelIndex', level).word('PageIndex', 2)


def cases(rng, scale, pair):
    # Every valid map/attribute list, plus indices whose word shift wraps back to
    # valid entries. The level-1 path also exercises the dormant retry/prompt loop.
    for level in (*range(K.LEVEL_COUNT), 0x8000, 0x8001):
        fail = level == 1
        yield from traced_case(pair, map_world(pair).word('LevelIndex', level), 'LoadLevelMap',
                               f'map level/index {level:04X}', fail_first=fail, load_map=True,
                               expect=level_map_expect(pair, level, fail))

    # Shared graphics-file setup: test the caller-selected flags and the filename's
    # preceding DecodeFileFlags word. All file bytes are supplied by the decoder hook.
    flags = 0x0123
    for enabled, fail in ((1, False), (0, False), (2, False), (0xFF, False), (1, True)):
        w = World(pair, None).word('FileStatus', 0x7777)
        w.put((pair.sym('File_1X1_BIC') - 2) & 0xFFFF, struct.pack('<H', flags))
        saved = seed_cs(pair, (('LoadNamePtr', pair.sym('File_1X1_BIC'), 2),
                               ('LoadDestSegment', 0xA000, 2), ('LoadDestOffset', 0x0300, 2),
                               ('LoadImageSlot', 'PANELIMAGEOFFSETS', 2),
                               ('LoadMakeMask', 0, 2), ('LoadRecordImages', 1, 2),
                               ('PerFileFlagsEnabled', enabled, 1)))
        try:
            expected_flags = flags if enabled == 1 else 0xFFFF
            yield from traced_case(
                pair, w, 'LoadGraphicsFile', f'per-file flag mode {enabled} retry={fail}',
                fail_first=fail,
                expect=lambda m, regs, obs, expected_flags=expected_flags, fail=fail: (
                    check(len(obs['resources']) == (2 if fail else 1),
                          'graphics resource retry count'),
                    check(obs['prompts'] == int(fail), 'graphics retry prompt count'),
                    check(obs['decoders'][0][0] ==
                          (expected_flags, m.peek('WorkspaceSegment'), 0xA000, 0, 0x0300),
                          'decoder BP/DS/ES/SI/DI inputs'),
                    check(regs['BP'] == 0xA101 and regs['ES'] == 0xB201,
                          'decoder BP/ES outputs reach the C entry')))
        finally:
            restore_cs(saved)

    # One public selector is still called by ASM outside this region. Its proposed
    # bridge should select recorded/plain flags in C and carry decoder BP/ES back.
    w = World(pair, None).word('FileStatus', 0x7777)
    saved = seed_cs(pair, (('LoadNamePtr', pair.sym('File_PANEL_ENC'), 2),
                           ('LoadDestSegment', 0xA000, 2), ('LoadDestOffset', 0x0300, 2),
                           ('LoadImageSlot', 'PANELIMAGEOFFSETS', 2),
                           ('PerFileFlagsEnabled', 0, 1)))
    try:
        yield from traced_case(
            pair, w, 'LoadGraphicsRecordImages', 'record-image flag wrapper',
            expect=lambda m, regs, obs: (
                check(len(obs['decoders']) == 1, 'record-image wrapper decodes once'),
                check(obs['decoders'][0][5:7] == (0, 1),
                      'record-image wrapper clears mask and enables image records'),
                check(obs['decoders'][0][0] ==
                      (0xFFFF, m.peek('WorkspaceSegment'), 0xA000, 0, 0x0300),
                      'record-image wrapper keeps the standard decoder contract'),
                check(regs['BP'] == 0xA101 and regs['ES'] == 0xB201,
                      'record-image bridge returns decoder BP/ES')))
    finally:
        restore_cs(saved)

    # The coordinator order and destinations are exercised for each level. Common
    # graphics also covers the CGA panel byte patch; actual decode pixels stay ASM.
    for level in range(K.LEVEL_COUNT):
        w = graphics_world(pair, level)
        saved = seed_cs(pair, (('PerFileFlagsEnabled', 1, 1), ('VideoAdapter', K.VIDEO_EGA, 2)))
        try:
            yield from traced_case(pair, w, 'LoadLevelGraphics', f'level graphics {level}',
                                   expect=lambda m, regs, obs, level=level:
                                   (check(len(obs['decoders']) == 3,
                                          f'level {level}: block, sprite, plaque'),
                                    check([entry[0] for entry in obs['resources']] == [
                                        m.word(pair.sym('LevelBankFiles') + level * 4 + 2),
                                        m.word(pair.sym('LevelBankFiles') + level * 4),
                                        m.word(pair.sym('PlaqueFiles') + level * 2)],
                                        f'level {level}: blocks, sprites, plaque file order'),
                                    check(obs['resources'][2][6] == 1 and
                                          all(entry[6] == 0 for entry in obs['resources'][:2]),
                                          f'level {level}: only the plaque is encoded'),
                                    check(regs['BP'] == 0xA103 and regs['ES'] == 0,
                                          f'level {level}: decoder BP and key-clear ES outputs')))
        finally:
            restore_cs(saved)

    w = (graphics_world(pair).word('PanelImageBytes', 0)
         .word('PanelImageBytes', 4, index=1))
    for adapter in (K.VIDEO_CGA, K.VIDEO_EGA):
        panel_seed = seed_memory(pair, 0xA100 * 16, bytes([0x77]) * (15 * 4))
        saved = seed_cs(pair, (('PerFileFlagsEnabled', 1, 1), ('VideoAdapter', adapter, 2),
                               ('PanelSegment', 0xA100, 2)))
        try:
            def common_expect(m, regs, obs, adapter=adapter):
                names = [pair.sym(name) for name in (
                    'File_1X1_BIC', 'File_2X2_BIC', 'File_2X2C_BIC', 'File_MANEXPL_BIC',
                    'File_THEND_BIC', 'File_PANEL_ENC', 'File_BLUEBITS_BIC', 'File_SHIP_BIC')]
                check(len(obs['decoders']) == 8,
                      'four banks, THEND, PANEL, BLUEBITS, SHIP')
                check([entry[0] for entry in obs['resources']] == names,
                      'common graphics filename order')
                check(obs['resources'][5][6] == 1 and
                      all(entry[6] == 0 for n, entry in enumerate(obs['resources']) if n != 5),
                      'LoadIsEnc is set only for PANEL.ENC')
                expected_panel = (m.read(pair.sym('CgaPanelPatch'), 15 * 4)
                                  if adapter == K.VIDEO_CGA else bytes([0x77]) * (15 * 4))
                check(obs['panel_result'] == expected_panel,
                      'CGA patch bytes or non-CGA panel preservation')
                check(regs['BP'] == 0xA108 and regs['ES'] == 0xB208,
                      'last decoder BP/ES outputs')
            yield from traced_case(pair, w, 'LoadCommonGraphics',
                                   f'shared graphics adapter {adapter}', expect=common_expect)
        finally:
            restore_cs(saved)
            restore_cs(panel_seed)

    # Page image setup and the BP/ES handoff from the retained screen blitter.
    w = graphics_world(pair).word('PageListPtr', pair.sym('OPageList'))
    saved = seed_cs(pair, (('LoadDestOffset', 0x8888, 2),
                           ('ScreenImageOffset', 0x4444, 2)))
    try:
        yield from traced_case(pair, w, 'LoadAndShowPage', 'page image and blitter handoff',
                               blit=True,
                               expect=lambda m, regs, obs: (
                                   check(len(obs['decoders']) == 1, 'one page decode'),
                                   check(len(obs['blits']) == 1, 'one screen blit'),
                                   check(obs['blits'][0][1] == m.peek('WorkspaceSegment'),
                                         'blitter DS is workspace'),
                                   check(obs['blits'][0][3:5] == (0x8000, 0),
                                         'blitter source and destination offsets'),
                                   check(obs['resources'][0][0] ==
                                         m.word(pair.sym('OPageList') + 4),
                                         'page index two selects its page-list entry'),
                                   check(obs['resources'][0][6] == 1,
                                         'page resource is marked encoded'),
                                   check(obs['decoders'][0][4] == 'SCREENIMAGEOFFSET',
                                         'page decode records ScreenImageOffset'),
                                   check(obs['blits'][0][5] == 0,
                                         'page load resets destination offset')))
    finally:
        restore_cs(saved)


MUTANTS = [
    ('levels.c', 'if (index == ATTRIBUTE_PATCH_END) break;',
     'if (index != ATTRIBUTE_PATCH_END) break;'),
    ('levels.c', 'patch_bytes = (word)(15 * PanelImageBytes[1]);',
     'patch_bytes = (word)(14 * PanelImageBytes[1]);'),
    ('levels.c', 'flags = *(word *)(word)flag_word;',
     'flags = 0xFFFF;'),
    ('levels.c', 'if (PerFileFlagsEnabled == 1)',
     'if (PerFileFlagsEnabled != 0)'),
    ('levels.c', 'page_file_offset = (word)((word)PageListPtr + (word)((word)PageIndex << 1));',
     'page_file_offset = (word)((word)PageListPtr + (word)((word)PageIndex << 2));'),
    ('levels.c', 'LoadNamePtr = (word)File_1X1_BIC;',
     'LoadNamePtr = (word)File_2X2_BIC;'),
]
