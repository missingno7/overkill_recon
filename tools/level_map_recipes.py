"""First map recipe slice, curated from the maintained map-cell handlers.

All level-1 cases and the identical level-4/5 turret/hatch cases are converted.
Coverage is migration metadata: unconverted cells keep their proven procedures.
The generated native table is consumed by host/map_recipes.c, never by DOS C.
"""
import copy
from level_presets import ARCHETYPES
from world import K

DIRECTIONS = {'up': K.DIR_UP, 'up_right': K.DIR_UP_RIGHT,
              'right': K.DIR_RIGHT, 'down_right': K.DIR_DOWN_RIGHT,
              'down': K.DIR_DOWN, 'down_left': K.DIR_DOWN_LEFT,
              'left': K.DIR_LEFT, 'up_left': K.DIR_UP_LEFT}
SPAWNS = {'enemy': 0, 'large_enemy': 1}


def original_map_spawns(level):
    def recipe(tile, enemy, *, clear=False, sprite=None, direction=None, large=False, writes=()):
        result = {'tile': tile, 'spawn': 'large_enemy' if large else 'enemy',
                  'enemy': enemy, 'map_writes': list(writes)}
        if clear:
            result['map_writes'] = [{'dx': 0, 'dy': 0, 'tile': 1}]
        if sprite is not None:
            result['sprite'] = sprite
        if direction is not None:
            result['direction'] = direction
        return result
    left = recipe(0xAC, 'volley_turret_left', sprite=0x89, direction='left')
    right = recipe(0xB1, 'volley_turret_right', sprite=0x8C, direction='right')
    hatch = recipe(0xC9, 'enemy_hatch', sprite=0x1C, direction='up', large=True,
        writes=[{'dx': 0, 'dy': 1, 'tile': 0x26}, {'dx': 1, 'dy': 1, 'tile': 0x27},
                {'dx': 0, 'dy': 0, 'tile': 0x28}, {'dx': 1, 'dy': 0, 'tile': 0x29}])
    if level == 1:
        return [recipe(4, 'climbing_walker_a', clear=True),
                recipe(7, 'climbing_walker_b', clear=True),
                recipe(0x6C, 'wall_turret_left', sprite=0x8F, direction='left'),
                recipe(0x6D, 'wall_turret_right', sprite=0x90, direction='right'),
                left, right, hatch]
    if level == 4:
        return [left, right, hatch]
    if level == 5:
        left['tile'], right['tile'] = 0xD3, 0xD2
        return [right, left]
    return []


def validate_map_spawns(document):
    if 'map_spawns' not in document:
        return
    recipes = document['map_spawns']
    if not isinstance(recipes, list) or len(recipes) > 256:
        raise ValueError('map_spawns must be a list of at most 256 cell recipes')
    tiles = set()
    for recipe in recipes:
        required = {'tile', 'spawn', 'enemy', 'map_writes'}
        if not isinstance(recipe, dict) or not required <= set(recipe) or set(recipe) - required - {'sprite', 'direction'}:
            raise ValueError('map recipe must specify tile, spawn, enemy and ordered map_writes')
        tile = recipe['tile']
        if type(tile) is not int or not 0 <= tile <= 255 or tile in tiles:
            raise ValueError('map recipe tiles must be unique bytes')
        tiles.add(tile)
        for field, choices in (('spawn', SPAWNS), ('enemy', ARCHETYPES), ('direction', DIRECTIONS)):
            if field in recipe and (not isinstance(recipe[field], str) or recipe[field] not in choices):
                raise ValueError('unknown map recipe ' + field)
        if 'sprite' in recipe and (type(recipe['sprite']) is not int or not 0 <= recipe['sprite'] <= 65535):
            raise ValueError('map recipe sprite must be an unsigned bank index')
        writes = recipe['map_writes']
        if not isinstance(writes, list) or len(writes) > 65535:
            raise ValueError('map_writes must be an ordered list')
        for write in writes:
            if not isinstance(write, dict) or set(write) != {'dx', 'dy', 'tile'}:
                raise ValueError('map write must specify dx, dy and tile')
            for field in ('dx', 'dy'):
                if type(write[field]) is not int or not -32768 <= write[field] <= 32767:
                    raise ValueError('map write offsets must be signed cell coordinates')
            if type(write['tile']) is not int or not 0 <= write['tile'] <= 255:
                raise ValueError('map write tile must be a byte')


def map_recipe_bindings(documents):
    if len(documents) != 6:
        raise ValueError('map recipe bindings require six levels')
    result = []
    for level, document in enumerate(documents):
        validate_map_spawns(document)
        defaults = original_map_spawns(level)
        coverage = set(range(256)) if level == 1 else {recipe['tile'] for recipe in defaults}
        recipes = copy.deepcopy(document.get('map_spawns', defaults))
        if any(recipe['tile'] not in coverage for recipe in recipes):
            raise ValueError(f'level {level}: map cell is outside the converted recipe scope')
        result.append((coverage, recipes))
    return result


def generate_map_recipe_header(out, documents):
    """Compile validated JSON into immutable native definitions, separate from DS."""
    rows = ['/* Generated from structured level definitions; native-only data. */',
            '#ifndef MAP_RECIPES_GEN_H', '#define MAP_RECIPES_GEN_H']
    bindings = map_recipe_bindings(documents)
    for level, (_, recipes) in enumerate(bindings):
        for index, recipe in enumerate(recipes):
            if recipe['map_writes']:
                rows.append(f'static const MapCellWrite map_writes_{level}_{index}[] = {{')
                for write in recipe['map_writes']:
                    displacement = (write['dy'] * K.MAP_ROW_BYTES + write['dx']) & 65535
                    rows.append(f'    {{{displacement}, {write["tile"]}}},')
                rows.append('};')
        if recipes:
            rows.append(f'static const MapSpawnRecipe map_recipes_{level}[] = {{')
            for index, recipe in enumerate(recipes):
                writes = f'map_writes_{level}_{index}' if recipe['map_writes'] else 'NULL'
                flags = (1 if 'sprite' in recipe else 0) | (2 if 'direction' in recipe else 0)
                values = [recipe['tile'], SPAWNS[recipe['spawn']], ARCHETYPES[recipe['enemy']],
                          flags, recipe.get('sprite', 0), DIRECTIONS.get(recipe.get('direction'), 0),
                          len(recipe['map_writes']), writes]
                rows.append('    {' + ', '.join(map(str, values)) + '},')
            rows.append('};')
    rows.append('static const MapRecipeLevel map_recipe_levels[6] = {')
    for level, (coverage, recipes) in enumerate(bindings):
        mask = [sum(1 << (tile % 8) for tile in coverage if tile // 8 == byte) for byte in range(32)]
        pointer = f'map_recipes_{level}' if recipes else 'NULL'
        rows.append('    {' + pointer + ', ' + str(len(recipes)) + ', {' +
                    ', '.join(map(str, mask)) + '}},')
    rows.extend(('};', '#endif', ''))
    (out / 'MAP_RECIPES_GEN.H').write_text('\n'.join(rows))
