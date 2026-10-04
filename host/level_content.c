#include "level_content.h"
#include "level_def.h"
#include "content_json.h"
#include "level_policies.h"
#include "level_timeline_data.h"
#include "level_waypoints.h"
#include "level_leaders.h"
#include "level_special_paths.h"
#include "game.h"
#include "memory.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "LEVEL_MAP_LIMITS_GEN.H"

typedef struct LevelContent {
    char id[128];
    uint16_t behavior_profile;
    uint8_t *map;
    uint8_t music;
    int live_music, live_restart;
    LevelCheckpointRestart restart;
    LevelTileRestoration *rules;
    LevelTimeline *timeline;
    LevelWaypoints *waypoints;
    LevelLeaderPaths *leaders;
    LevelSpecialPaths *special_paths;
    LevelTerrain terrain;
    int owns_terrain;
} LevelContent;

static LevelContent current;

static int integer(const JsonDocument *doc, int object, const char *key, long max, long *out)
{
    return content_json_integer(doc, content_json_member(doc, object, key), out) &&
           *out >= 0 && *out <= max;
}

static int string_is(const JsonDocument *doc, int object, const char *key, const char *value)
{
    char text[128];
    return content_json_string(doc, content_json_member(doc, object, key), text, sizeof text) &&
           !strcmp(text, value);
}

static int safe_name(const char *name, int path)
{
    size_t i;
    int component = 0;
    if (!name[0]) return 0;
    for (i = 0; name[i]; i++) {
        unsigned char c = (unsigned char)name[i];
        if ((c >= 'a' && c <= 'z') || (path && c >= 'A' && c <= 'Z') ||
            (c >= '0' && c <= '9') || c == '_' || c == '-') component++;
        else if (path && c == '/' && component) component = 0;
        else if (path && c == '.' && component && !strcmp(name + i, ".bin")) return 1;
        else return 0;
    }
    return !path && name[0] >= 'a' && name[0] <= 'z';
}

static int parse_terrain(const JsonDocument *doc, LevelTerrain *terrain)
{
    static const char *names[] = {"open", "wall", "shot_permeable_wall"};
    int section = content_json_member(doc, 0, "terrain");
    int patches = content_json_member(doc, section, "attribute_patches");
    size_t i, count = content_json_size(doc, patches);
    if (content_json_size(doc, section) != 2 ||
        !string_is(doc, section, "default", "wall") || patches < 0 ||
        doc->tokens[patches].type != CONTENT_JSON_ARRAY) return 0;
    memset(terrain->attributes, TILE_WALL, sizeof terrain->attributes);
    for (i = 0; i < count; i++) {
        int patch = content_json_at(doc, patches, i);
        unsigned attribute;
        long tile;
        if (content_json_size(doc, patch) != 2 ||
            !integer(doc, patch, "tile", 255, &tile)) return 0;
        for (attribute = 0; attribute < sizeof names / sizeof names[0]; attribute++)
            if (string_is(doc, patch, "attribute", names[attribute])) break;
        if (attribute == sizeof names / sizeof names[0]) return 0;
        /* Ordered patches are last-wins. No original pointer, capacity or
           level-1/4 shared storage is used by authored content. */
        terrain->attributes[tile] = (uint8_t)attribute;
    }
    return 1;
}

void overkill_level_content_unload(void)
{
    if (current.id[0]) overkill_level_policy_bind_current(NULL, NULL);
    overkill_level_timeline_bind_current(NULL);
    overkill_level_waypoints_bind_current(NULL);
    overkill_level_leaders_bind_current(NULL);
    overkill_level_special_paths_bind_current(NULL);
    overkill_level_terrain_bind_current(NULL);
    overkill_level_special_paths_free(current.special_paths);
    overkill_level_leaders_free(current.leaders);
    overkill_level_waypoints_free(current.waypoints);
    overkill_level_timeline_free(current.timeline);
    free(current.map);
    free(current.rules);
    memset(&current, 0, sizeof current);
}

const char *overkill_level_content_id(void) { return current.id[0] ? current.id : NULL; }
uint16_t overkill_level_content_behavior_profile(void) { return current.behavior_profile; }

int overkill_level_content_copy_map(void)
{
    word i;
    if (!current.id[0]) return 0;
    /* Reload from immutable content after a life loss. Runtime mutations stay
       in the same emulated map/state arena used by collision and spawning. */
    for (i = 0; i < MAP_END_POS; i++)
        *(byte *)overkill_segment_address(LevelMapSegment, i) = current.map[i];
    return 1;
}

int overkill_level_content_load(const char *directory, const char *original_directory,
                               char *error, size_t error_size)
{
    JsonDocument doc = {0}, original = {0};
    LevelContent next = {0};
    char path[2048], map_path[1024], field_error[160];
    long value, rows, columns, version;
    int compatibility, resources, map, music, restart;
    int ok = 0;
    size_t i;
    FILE *file = NULL;
    const char *reason = "invalid loose level definition";
    static const char *unchanged[] = {
        "format", "profile", "terrain", "checkpoints", "formations", "timeline", "paths",
        "leader_paths", "map_spawns", "map_spawn_parameters", "map_group_drops", "departure",
        "encounter", "marching_formation", "boss"
    };
    if (error && error_size) error[0] = 0;
    if (!directory || !original_directory) goto done;
    if (snprintf(path, sizeof path, "%s/level.json", directory) >= (int)sizeof path) goto done;
    if (!content_json_load(path, &doc, error, error_size)) goto done;
    if (!integer(&doc, 0, "version", 13, &version) || (version < 8) ||
        !content_json_string(&doc, content_json_member(&doc, 0, "id"), next.id, sizeof next.id) ||
        !safe_name(next.id, 0)) goto done;
    compatibility = content_json_member(&doc, 0, "compatibility");
    if (content_json_size(&doc, compatibility) != 1 ||
        !integer(&doc, compatibility, "original_level", 5, &value)) goto done;
    next.behavior_profile = (uint16_t)value;
    if (snprintf(path, sizeof path, "%s/level%u.lvl", original_directory,
                 next.behavior_profile) >= (int)sizeof path) goto done;
    if (!content_json_load(path, &original, error, error_size)) goto done;
    reason = "unsupported independent content field (must match original behavior profile)";
    /* Compare every section we cannot yet load independently. Missing, changed
       and unknown fields all fail; a compatibility profile cannot hide edits. */
    if (content_json_size(&doc, 0) != content_json_size(&original, 0) + (version >= 9 ? 1 : 0)) goto done;
    if (version == 8 && content_json_member(&doc, 0, "formation_spawn_parameters") >= 0) goto done;
    if (version >= 11) {
        int leaders = content_json_member(&doc, 0, "leader_paths");
        if (leaders < 0 || doc.tokens[leaders].type != CONTENT_JSON_OBJECT) goto done;
    }
    for (i = 0; i < sizeof unchanged / sizeof unchanged[0]; i++) {
        int a = content_json_member(&doc, 0, unchanged[i]);
        int b = content_json_member(&original, 0, unchanged[i]);
        if (version >= 9 && (!strcmp(unchanged[i], "timeline") ||
            !strcmp(unchanged[i], "formations") || !strcmp(unchanged[i], "checkpoints"))) continue;
        if (version >= 10 && !strcmp(unchanged[i], "paths")) continue;
        if (version >= 11 && !strcmp(unchanged[i], "leader_paths")) continue;
        if (version >= 13 && !strcmp(unchanged[i], "terrain")) continue;
        if (a < 0 && b < 0) continue;
        if (!content_json_equal(&doc, a, &original, b)) {
            snprintf(field_error, sizeof field_error, "%s: independent runtime loading is not implemented yet", unchanged[i]);
            reason = field_error;
            goto done;
        }
    }
    resources = content_json_member(&doc, 0, "resources");
    if (content_json_size(&doc, resources) != 4) goto done;
    for (i = 0; i < 3; i++) {
        static const char *roles[] = {"sprites", "blocks", "plaque"};
        if (!content_json_equal(&doc, content_json_member(&doc, resources, roles[i]),
                &original, content_json_member(&original,
                    content_json_member(&original, 0, "resources"), roles[i]))) {
            snprintf(field_error, sizeof field_error, "%s: independent runtime loading is not implemented yet", roles[i]);
            reason = field_error;
            goto done;
        }
    }
    reason = "invalid level-owned tile-grid map (requires 13 columns and 288 rows)";
    map = content_json_member(&doc, resources, "map");
    if (content_json_size(&doc, map) != 4 || !string_is(&doc, map, "encoding", "tile-grid") ||
        !integer(&doc, map, "columns", 13, &columns) || columns != 13 ||
        !integer(&doc, map, "rows", 288, &rows) || rows != 288 ||
        !content_json_string(&doc, content_json_member(&doc, map, "path"), map_path, sizeof map_path) ||
        !safe_name(map_path, 1)) goto done;
    if (snprintf(path, sizeof path, "%s/%s", directory, map_path) >= (int)sizeof path) goto done;
    file = fopen(path, "rb");
    next.map = malloc(MAP_END_POS);
    if (!file || !next.map || fread(next.map, 1, MAP_END_POS, file) != MAP_END_POS || fgetc(file) != EOF) goto done;
    fclose(file); file = NULL;
    reason = "map contains an unmodeled original spawn-dispatch cell";
    for (i = 0; i < MAP_END_POS; i++) {
        uint8_t tile = next.map[i];
        if (unsupported_map_tiles[next.behavior_profile][tile >> 3] & (1u << (tile & 7))) goto done;
    }
    reason = "invalid level music (supported tunes are 1..10)";
    music = content_json_member(&doc, 0, "music");
    if (!integer(&doc, music, "level", 10, &value) || !value) goto done;
    next.music = (uint8_t)value;
    if (content_json_member(&doc, music, "compatibility") >= 0) {
        if (!content_json_equal(&doc, music, &original, content_json_member(&original, 0, "music"))) goto done;
        next.live_music = 1;
    } else if (content_json_size(&doc, music) != 1) goto done;
    reason = "invalid ordered checkpoint tile restoration rules";
    restart = content_json_member(&doc, 0, "checkpoint_restart");
    if (content_json_member(&doc, restart, "compatibility") >= 0) {
        if (!content_json_equal(&doc, restart, &original, content_json_member(&original, 0, "checkpoint_restart"))) goto done;
        next.live_restart = 1;
    } else {
        int rules = content_json_member(&doc, restart, "tile_restorations");
        size_t count = content_json_size(&doc, rules);
        if (content_json_size(&doc, restart) != 2 || rules < 0 ||
            doc.tokens[rules].type != CONTENT_JSON_ARRAY || count > 65535 ||
            !integer(&doc, restart, "lookback_rows", 65535 / MAP_ROW_BYTES, &value)) goto done;
        next.restart.lookback_rows = (uint16_t)value;
        next.restart.rule_count = (uint16_t)count;
        next.rules = count ? calloc(count, sizeof *next.rules) : NULL;
        if (count && !next.rules) goto done;
        next.restart.rules = next.rules;
        for (i = 0; i < count; i++) {
            int rule = content_json_at(&doc, rules, i);
            if (content_json_size(&doc, rule) != 2 || !integer(&doc, rule, "tile", 255, &value)) goto done;
            next.rules[i].tile = (uint8_t)value;
            if (!integer(&doc, rule, "replacement", 255, &value)) goto done;
            next.rules[i].replacement = (uint8_t)value;
            if (unsupported_map_tiles[next.behavior_profile][value >> 3] & (1u << (value & 7))) {
                reason = "restoration contains an unmodeled original spawn-dispatch cell";
                goto done;
            }
        }
    }
    if (version >= 9 && !overkill_level_timeline_parse(&doc, &original, next.behavior_profile,
                                                      &next.timeline, error, error_size)) goto done;
    if (version >= 10 && !overkill_level_waypoints_parse(&doc, &original,
                                                       &next.waypoints, error, error_size)) goto done;
    if (version >= 11 && !overkill_level_leaders_parse(&doc, &original,
                                                     &next.leaders, error, error_size)) goto done;
    if (version >= 12 && !overkill_level_special_paths_parse(&doc, &original,
                    &next.special_paths, error, error_size)) goto done;
    if (version >= 13) {
        reason = "invalid level-owned terrain attributes";
        if (!parse_terrain(&doc, &next.terrain)) goto done;
        next.owns_terrain = 1;
    }
    overkill_level_content_unload();
    current = next;
    overkill_level_policy_bind_current(
        current.live_restart ? NULL : &current.restart, current.live_music ? NULL : &current.music);
    overkill_level_timeline_bind_current(current.timeline);
    overkill_level_waypoints_bind_current(current.waypoints);
    overkill_level_leaders_bind_current(current.leaders);
    overkill_level_special_paths_bind_current(current.special_paths);
    overkill_level_terrain_bind_current(current.owns_terrain ? &current.terrain : NULL);
    memset(&next, 0, sizeof next);
    ok = 1;
done:
    if (file) fclose(file);
    free(next.map);
    free(next.rules);
    overkill_level_timeline_free(next.timeline);
    overkill_level_waypoints_free(next.waypoints);
    overkill_level_leaders_free(next.leaders);
    overkill_level_special_paths_free(next.special_paths);
    content_json_free(&doc);
    content_json_free(&original);
    if (!ok && error && error_size && !error[0]) snprintf(error, error_size, "%s", reason);
    return ok;
}
