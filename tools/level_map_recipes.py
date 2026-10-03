"""Map recipe slices, curated from the maintained map-cell handlers.

Fixed-field cases, clear-only cells and group preparation/join phases are converted.
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
SPAWNS = {'enemy': 0, 'large_enemy': 1, 'none': 2}
MAP_GROUPS = {'allocate_only': 1, 'join_before_fields': 2, 'join_after_fields': 3}
# Version 1's explicit recipe lists replaced only this original migration scope.
# Retain its meaning when version 2 expands coverage to grouped-range cells.
V1_MAP_SCOPE = {1: set(range(256)), 4: {0xAC, 0xB1, 0xC9}, 5: {0xD2, 0xD3}}


def original_map_spawns(level, version=2):
    if version == 1:
        return [recipe for recipe in original_map_spawns(level)
                if recipe['tile'] in V1_MAP_SCOPE.get(level, set())]
    def recipe(tile, enemy=None, *, clear=False, sprite=None, direction=None, large=False,
               writes=(), group=None):
        result = {'tile': tile, 'spawn': ('large_enemy' if large else 'enemy') if enemy else 'none',
                  'map_writes': copy.deepcopy(list(writes))}
        if enemy is not None:
            result['enemy'] = enemy
        if clear:
            result['map_writes'] = [{'dx': 0, 'dy': 0, 'tile': 1}]
        if sprite is not None:
            result['sprite'] = sprite
        if direction is not None:
            result['direction'] = direction
        if group is not None:
            result['compatibility'] = {'map_group': group}
        return result
    def grouped(tile, enemy=None, *, join=False, after=False, **fields):
        return recipe(tile, enemy, group=('join_after_fields' if after else
            'join_before_fields' if join else 'allocate_only'), **fields)
    clear_square = [{'dx': 0, 'dy': 0, 'tile': 1}, {'dx': 1, 'dy': 0, 'tile': 1},
                    {'dx': 0, 'dy': 1, 'tile': 1}, {'dx': 1, 'dy': 1, 'tile': 1}]
    if level == 0:
        return [
            grouped(0xE4, 'low_row_jitterer', clear=True),
            grouped(0xE7, 'descender_to_x80', clear=True),
            grouped(0xE8, 'descender_to_x96_shooter', clear=True, sprite=0x123, join=True),
            grouped(0xE9, 'descender_to_x112', clear=True),
            grouped(0xEA, 'staircase_crawler', clear=True, direction='down', join=True),
            grouped(0xEB, 'hover_fire_plunge_c', clear=True, direction='down', join=True),
            grouped(0xED, 'climbing_walker_c', clear=True, join=True),
            grouped(0xEE, 'climbing_walker_d', clear=True, join=True),
            grouped(0xEF, 'patrol_shoot_down_c', clear=True, direction='down', join=True),
            grouped(0xF2, 'side_turret', clear=True), grouped(0xF3, 'side_turret', clear=True),
            grouped(0xF5, clear=True), grouped(0xF6, 'fast_fall_4_flicker', clear=True),
            grouped(0xF7, 'aimed_descender', large=True, direction='down', writes=clear_square),
            grouped(0xF8, 'spread_shot_descender', large=True, sprite=0x24,
                    direction='down', writes=clear_square, after=True),
        ]
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
        return [left, right, hatch,
            grouped(0xCE, 'climbing_walker_b', clear=True),
            grouped(0xCF, 'climbing_walker_a', clear=True),
            grouped(0xD0, 'delayed_crawler_right', clear=True, sprite=0x99, direction='right'),
            grouped(0xD1, 'delayed_crawler_left', clear=True, sprite=0x9B, direction='left'),
            grouped(0xD5, 'patrol_shoot_down_c', clear=True, direction='down', join=True),
            grouped(0xD6, 'fast_fall_4_flicker', clear=True),
            grouped(0xD8, 'patrol_shoot_down_64', clear=True, join=True),
            grouped(0xD9, 'fast_drop_8', clear=True, sprite=0x77, direction='down', join=True),
            grouped(0xDA, 'wall_bounce_descender', clear=True, direction='down_right'),
            grouped(0xDB, 'wall_bounce_descender', clear=True, direction='down_left'),
            grouped(0xDC, 'side_turret', clear=True), grouped(0xDE, 'low_row_jitterer', clear=True),
            grouped(0xDF, 'descend_burst', clear=True, join=True),
            grouped(0xE0, 'crawler_turn_left', clear=True, sprite=0x27, direction='down', join=True),
        ]
    if level == 5:
        left['tile'], right['tile'] = 0xD3, 0xD2
        return [right, left,
            recipe(0xD7, 'climbing_walker_b', clear=True),
            recipe(0xD8, 'climbing_walker_a', clear=True),
            grouped(0xD9, 'descend_aimed_fire', large=True, direction='down', writes=clear_square, after=True),
            grouped(0xDA, 'row_firer', clear=True, sprite=0x15A, direction='right'),
            grouped(0xDB, 'row_firer', clear=True, sprite=0x15B, direction='left'),
            grouped(0xE0, 'fast_drop_8', clear=True, sprite=0x77, direction='down', join=True),
            grouped(0xE1, clear=True), grouped(0xE2, clear=True),
            grouped(0xE3, 'slide_then_drop', clear=True, sprite=0xE7, direction='right'),
            grouped(0xE4, 'animated_shooter', clear=True, sprite=0x46, direction='down'),
            grouped(0xE5, 'delayed_crawler_right', clear=True, sprite=0x99, direction='right'),
            grouped(0xE6, 'delayed_crawler_left', clear=True, sprite=0x9B, direction='left'),
            grouped(0xE7, 'wall_patrol_shooter', clear=True, direction='right'),
            grouped(0xE8, 'patrol_shoot_down_b', clear=True, join=True),
            grouped(0xE9, 'patrol_shoot_down_a', clear=True, direction='left', join=True),
            grouped(0xEA, 'descend_burst', clear=True, join=True),
            grouped(0xEC, 'fast_fall_4_flicker', clear=True),
            grouped(0xED, 'vertical_bouncer_shooter', clear=True, join=True),
            grouped(0xEE, 'hover_fire_plunge_a', clear=True, direction='up', join=True),
            grouped(0xEF, 'crawler_turn_left', clear=True, sprite=0x27, direction='down', join=True),
        ]
    if level == 3:
        return [
            grouped(0xD4, 'fast_drop_4', clear=True, sprite=0x77),
            grouped(0xD5, 'patrol_shoot_down_64', clear=True, join=True),
            grouped(0xD7, 'slide_then_drop', clear=True, sprite=0xE7, direction='right'),
            grouped(0xD9, 'delayed_crawler_right', clear=True, sprite=0x99, direction='right'),
            grouped(0xDA, 'delayed_crawler_left', clear=True, sprite=0x9B, direction='left'),
            grouped(0xDB, 'wall_patrol_shooter', clear=True, join=True),
            grouped(0xDC, 'patrol_shoot_down_b', clear=True, join=True),
            grouped(0xDD, 'climbing_walker_b', clear=True),
            grouped(0xDE, 'climbing_walker_a', clear=True), grouped(0xDF),
            grouped(0xE0, 'fast_fall_4_flicker', clear=True),
            grouped(0xE1, 'vertical_bouncer_shooter', clear=True, join=True),
            grouped(0xE2, 'hover_fire_plunge_a', clear=True, direction='up', join=True),
            grouped(0xE3, 'crawler_turn_left', clear=True, sprite=0x27, direction='down', join=True),
            grouped(0xE4, 'fast_drop_8', clear=True, sprite=0x77, direction='down', join=True),
            grouped(0xE5, 'side_turret', clear=True), grouped(0xE6, 'side_turret', clear=True),
            grouped(0xE7, 'scroll_then_rise', clear=True, sprite=0x74, direction='up'),
            grouped(0xE8, 'patrol_shoot_down_a', clear=True, direction='left', join=True),
            grouped(0xE9, 'descend_burst', clear=True, join=True),
        ]
    return []


def validate_map_spawns(document):
    if 'map_spawns' not in document:
        return
    recipes = document['map_spawns']
    if not isinstance(recipes, list) or len(recipes) > 256:
        raise ValueError('map_spawns must be a list of at most 256 cell recipes')
    tiles = set()
    for recipe in recipes:
        required = {'tile', 'spawn', 'map_writes'}
        if isinstance(recipe, dict) and recipe.get('spawn') != 'none':
            required.add('enemy')
        optional = {'compatibility'} | ({'sprite', 'direction'} if 'enemy' in required else set())
        if not isinstance(recipe, dict) or not required <= set(recipe) or set(recipe) - required - optional:
            raise ValueError('map recipe must specify tile, spawn, ordered map_writes and enemy when spawning')
        tile = recipe['tile']
        if type(tile) is not int or not 0 <= tile <= 255 or tile in tiles:
            raise ValueError('map recipe tiles must be unique bytes')
        tiles.add(tile)
        if document['version'] == 1 and ('compatibility' in recipe or recipe['spawn'] == 'none'):
            raise ValueError('group/no-spawn map recipes require level version 2')
        if 'compatibility' in recipe:
            compatibility = recipe['compatibility']
            if not isinstance(compatibility, dict) or set(compatibility) != {'map_group'} or not isinstance(
                    compatibility['map_group'], str) or compatibility['map_group'] not in MAP_GROUPS:
                raise ValueError('unsupported map recipe group compatibility')
            if recipe['spawn'] == 'none' and compatibility['map_group'] != 'allocate_only':
                raise ValueError('non-spawning map recipes cannot join a group')
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
        defaults = original_map_spawns(level, document['version'])
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
                group = MAP_GROUPS.get(recipe.get('compatibility', {}).get('map_group'), 0)
                values = [recipe['tile'], SPAWNS[recipe['spawn']], group, ARCHETYPES.get(recipe.get('enemy'), 0),
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
