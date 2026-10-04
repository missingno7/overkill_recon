"""Level-owned restart restoration and tune selection; no shared table writes."""
import struct
from world import K
from emu import LOAD


def original_checkpoint_restart(machine, level):
    cursor = machine.word(machine.offset('MapResetLists') + level * 2)
    handlers = {machine.symbols[name.upper()][1]: tile
                for name, tile in (('SetMapTile1', 1), ('SetMapTile28', 40))}
    rules = []
    for _ in range(16384):
        tile = struct.unpack('<H', machine.u.mem_read(LOAD * 16 + cursor, 2))[0]
        if tile == 65535:
            return {'lookback_rows': 12, 'tile_restorations': rules,
                    'compatibility': {'live_original': True}}
        handler = struct.unpack('<H', machine.u.mem_read(LOAD * 16 + ((cursor + 2) & 65535), 2))[0]
        if tile > 255 or handler not in handlers:
            raise ValueError('unmodeled original map reset action')
        rules.append({'tile': tile, 'replacement': handlers[handler]})
        cursor = (cursor + 4) & 65535
    raise ValueError('unterminated original map reset list')


def original_music(machine, level):
    return {'level': machine.read(machine.offset('LevelMusicTable') + level, 1)[0],
            'compatibility': {'live_original': True}}


def validate_level_policies(document):
    for name in ('checkpoint_restart', 'music'):
        if name not in document:
            continue
        if document['version'] < 7:
            raise ValueError(name + ' requires version 7')
        item = document[name]
        keys = {'lookback_rows', 'tile_restorations'} if name == 'checkpoint_restart' else {'level'}
        if isinstance(item, dict) and 'compatibility' in item:
            keys.add('compatibility')
            if item['compatibility'] != {'live_original': True} or type(
                    item['compatibility'].get('live_original')) is not bool:
                raise ValueError(name + ': only live_original=true compatibility is supported')
        if not isinstance(item, dict) or set(item) != keys:
            raise ValueError(name + ': unexpected fields')
        if name == 'music':
            # Both original sound modules have ten tunes, indexed 1..10.
            if type(item['level']) is not int or not 1 <= item['level'] <= 10:
                raise ValueError('music.level must be a supported tune (1..10)')
            continue
        if type(item['lookback_rows']) is not int or not 0 <= item['lookback_rows'] <= 65535 // K.MAP_ROW_BYTES:
            raise ValueError('restart lookback_rows is outside the map word window')
        rules = item['tile_restorations']
        if not isinstance(rules, list) or len(rules) > 65535:
            raise ValueError('tile_restorations must be an ordered list')
        for rule in rules:
            if not isinstance(rule, dict) or set(rule) != {'tile', 'replacement'} or any(
                    type(value) is not int or not 0 <= value <= 255 for value in rule.values()):
                raise ValueError('tile restoration requires tile and replacement bytes')


def generate_level_policy_header(out, documents, machine):
    from level_format import validate
    if len(documents) != 6:
        raise ValueError('original policy binding requires six definitions')
    lines = ['/* Generated from semantic restart/music policies. */',
             '#ifndef LEVEL_POLICIES_GEN_H', '#define LEVEL_POLICIES_GEN_H']
    restarts, music = [], []
    for index, document in enumerate(documents):
        validate(document)
        for name, original in (('checkpoint_restart', original_checkpoint_restart(machine, index)),
                               ('music', original_music(machine, index))):
            item = document.get(name)
            if item is None or 'compatibility' in item:
                if item is not None and item != original:
                    raise ValueError(name + ': live_original must match the original policy')
                (restarts if name == 'checkpoint_restart' else music).append('0')
                continue
            if name == 'music':
                symbol = f'level_{index}_music'
                lines.append(f'static const uint8_t {symbol} = {item["level"]};')
                music.append('&' + symbol)
            else:
                symbol = f'level_{index}_restart'
                rules = item['tile_restorations']
                if rules:
                    lines.append(f'static const LevelTileRestoration {symbol}_rules[] = {{' +
                                 ', '.join('{%d, %d}' % (r['tile'], r['replacement']) for r in rules) + '};')
                lines.append(f'static const LevelCheckpointRestart {symbol} = {{' +
                             f'{item["lookback_rows"]}, {len(rules)}, ' + (symbol + '_rules' if rules else '0') + '};')
                restarts.append('&' + symbol)
    lines += ['static const LevelCheckpointRestart *const level_restart_policies[] = {' + ', '.join(restarts) + '};',
              'static const uint8_t *const level_music_policies[] = {' + ', '.join(music) + '};', '#endif', '']
    out.mkdir(parents=True, exist_ok=True)
    (out / 'LEVEL_POLICIES_GEN.H').write_text('\n'.join(lines))
