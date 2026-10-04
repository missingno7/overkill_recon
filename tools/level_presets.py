"""Semantic names for existing behavior/resource identities, not new behaviors.

Presets intentionally retain distinct REC_TYPE values even where handlers share
code. The native dispatcher and its original initialization remain authoritative.
"""
ARCHETYPES = {
    'path_follower_a': 0x10, 'path_follower_b': 0x11,
    'sway_leader': 0x13, 'sweep_leader': 0x15,
    'wall_patrol_shooter': 0x19, 'wall_patrol_a': 0x1A, 'wall_patrol_b': 0x1B,
    'bob_chase_leader': 0x1C, 'slot_hopper_leader': 0x1F,
    'encounter_director': 0x21, 'wall_turret_left': 0x24, 'wall_turret_right': 0x25,
    'slow_descender': 0x27, 'enemy_hatch': 0x28,
    'hover_fire_plunge_a': 0x2D, 'scrolling_shuttle': 0x2F,
    'animated_shooter': 0x30, 'fast_fall_3': 0x31, 'descend_bounce_a': 0x32,
    'side_turret': 0x34, 'descend_burst': 0x35, 'fall_burst': 0x36,
    'vertical_bouncer_shooter': 0x37, 'wall_bounce_descender': 0x38,
    'dash_right_at_row_80': 0x39, 'home_on_player_below_80': 0x3A,
    'fall_random_flicker': 0x3B, 'descend_bounce_b': 0x3C, 'drop_dash': 0x3E,
    'jitter_fall_shooter': 0x40, 'path_follower_c': 0x41, 'descend_sway': 0x42,
    'path_follower_d': 0x43, 'path_follower_e': 0x44, 'path_follower_f': 0x45,
    'path_follower_g': 0x4A, 'demo_path_follower': 0x51,
    'hover_fire_plunge_b': 0x46, 'patrol_shoot_down_a': 0x47,
    'descend_aimed_fire': 0x48, 'radial_burst_faller': 0x49,
    'descend_bounce_c': 0x4B, 'sink_rise': 0x4C, 'sink_rise_dash': 0x4D,
    'animated_descender': 0x4E, 'fast_fall_4_flicker': 0x4F,
    'path_follower_left': 0x66, 'path_follower_right': 0x67,
    'drop_aim': 0x7B, 'sweeper_leader': 0x7D, 'march_leader': 0x7E,
    'patrol_shoot_down_64': 0x83, 'patrol_shoot_down_b': 0x89,
    'patrol_shoot_down_c': 0x8A, 'climbing_walker_a': 0x8B, 'climbing_walker_b': 0x8C,
    'volley_turret_left': 0x90, 'volley_turret_right': 0x91,
    'fast_drop_4': 0x55, 'delayed_crawler_left': 0x57, 'delayed_crawler_right': 0x58,
    'scroll_then_rise': 0x5B, 'fast_drop_8': 0x5D, 'crawler_turn_left': 0x5E,
    'slide_then_drop': 0x63, 'low_row_jitterer': 0x69, 'descender_to_x80': 0x6B,
    'descender_to_x96_shooter': 0x6C, 'descender_to_x112': 0x6D,
    'staircase_crawler': 0x6E, 'hover_fire_plunge_c': 0x71,
    'aimed_descender': 0x72, 'spread_shot_descender': 0x75,
    'climbing_walker_c': 0x8D, 'climbing_walker_d': 0x8E, 'row_firer': 0x92,
    'plunge_at_player_column': 0x2E,
    'scroll_to_y176_then_crawl': 0x54, 'scroll_then_diagonal_crawl': 0x59,
    'crawl_turn_diagonal_down': 0x5F, 'scroll_to_y80_then_crawl': 0x6A,
    'launch_aimed_enemy': 0x86, 'animated_fire_burst_a': 0x87,
    'wait_then_fire_burst': 0x88, 'animated_fire_burst_c': 0x8F,
    'retained_cell_enemy_hatch': 0x2A, 'wait_then_cruise_firing': 0x6F,
    'wait_then_run_right': 0x73, 'wait_then_run_left': 0x74, 'lurk_until_aligned': 0x84,
    'jitter_shooter': 0x68,
}
SIZES = {'8x8': 0, '16x16': 1, '32x32': 2}
LAYERS = {'under_terrain': 0, 'over_terrain': 1}
DROPS = {'none': 0, 'upgrade': 1, 'energy': 2, 'smart_bomb': 3, 'fuel': 4}


def formation_id(definition):
    """Name an original layout by its preset and observed member geometry."""
    members = definition['members']
    if len(members) == 1:
        shape = 'single'
    elif all(member['dx'] == 0 for member in members):
        shape = 'column'
    elif all(member['dy'] == 0 for member in members):
        shape = 'row'
    else:
        shape = 'layout'
    return f"{definition['enemy']}_{shape}_{len(members)}"
