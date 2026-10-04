"""Timeline-owned formation spawn parameters and semantic preset tables."""

from level_presets import ARCHETYPES, DROPS, LAYERS, SIZES


def original_formation_spawn_parameters(level):
    """Return the original level's observed tile-member HP rule.

    Formation member hit points are level + 1 for 16x16 members and 12
    for the other members. The native timeline dispatcher preserves the
    separate director-cursor quirk in its compatibility path.
    """
    if type(level) is not int or not 0 <= level < 6:
        raise ValueError('original level must be in 0..5')
    return {
        'tile_member_hit_points': level + 1,
        'other_member_hit_points': 12,
        'compatibility': {'live_original': True},
    }


def validate_formation_spawn_parameters(document):
    """Validate the optional version-9 formation spawn parameter section."""
    if 'formation_spawn_parameters' not in document:
        return
    if type(document.get('version')) is not int or document['version'] < 9:
        raise ValueError('formation_spawn_parameters requires version 9')
    item = document['formation_spawn_parameters']
    fields = {'tile_member_hit_points', 'other_member_hit_points'}
    if isinstance(item, dict) and 'compatibility' in item:
        fields.add('compatibility')
        compatibility = item['compatibility']
        if (not isinstance(compatibility, dict) or
                compatibility != {'live_original': True} or
                type(compatibility.get('live_original')) is not bool):
            raise ValueError('formation_spawn_parameters: only live_original=true compatibility is supported')
    if not isinstance(item, dict) or set(item) != fields:
        raise ValueError('formation_spawn_parameters: unexpected fields')
    for name in ('tile_member_hit_points', 'other_member_hit_points'):
        value = item[name]
        if type(value) is not int or not 0 <= value <= 0xFFFF:
            raise ValueError(name + ' must be an unsigned word')


def generate_timeline_parameter_header(out, documents, machine=None):
    """Emit per-level authored policies, leaving original policies live."""
    if len(documents) != 6:
        raise ValueError('timeline parameter binding requires six definitions')

    lines = [
        '/* Generated from semantic formation spawn parameters. */',
        '#ifndef LEVEL_TIMELINE_PARAMS_GEN_H',
        '#define LEVEL_TIMELINE_PARAMS_GEN_H',
    ]
    bindings = []
    for level, document in enumerate(documents):
        validate_formation_spawn_parameters(document)
        item = document.get('formation_spawn_parameters')
        if item is None or 'compatibility' in item:
            if item is not None and item != original_formation_spawn_parameters(level):
                raise ValueError('formation_spawn_parameters: live_original must match the original parameters')
            bindings.append('0')
            continue

        symbol = f'level_{level}_formation_spawn_parameters'
        lines.append(
            f'static const LevelFormationSpawnParameters {symbol} = '
            f'{{{item["tile_member_hit_points"]}, {item["other_member_hit_points"]}}};'
        )
        bindings.append('&' + symbol)

    lines.append(
        'static const LevelFormationSpawnParameters *const formation_spawn_parameters[] = {' +
        ', '.join(bindings) + '};'
    )
    lines.extend(('#endif', ''))
    out.mkdir(parents=True, exist_ok=True)
    (out / 'LEVEL_TIMELINE_PARAMS_GEN.H').write_text('\n'.join(lines))


def generate_level_preset_header(out):
    """Emit semantic names for the original behavior, size, layer and drop IDs."""
    tables = (
        ('level_enemy_presets', ARCHETYPES),
        ('level_size_presets', SIZES),
        ('level_layer_presets', LAYERS),
        ('level_drop_presets', DROPS),
    )
    lines = [
        '/* Generated semantic names for the original timeline presets. */',
        '#ifndef LEVEL_PRESETS_GEN_H',
        '#define LEVEL_PRESETS_GEN_H',
    ]
    for symbol, values in tables:
        lines.append(f'static const LevelPresetName {symbol}[] = {{')
        lines.extend(f'    {{"{name}", {value}}},' for name, value in values.items())
        lines.append('    {0, 0}')
        lines.append('};')
    lines.extend(('#endif', ''))
    out.mkdir(parents=True, exist_ok=True)
    (out / 'LEVEL_PRESETS_GEN.H').write_text('\n'.join(lines))
