#include "level_waypoints.h"
#include "GAME_GEN.H"

#include "LEVEL_WAYPOINT_PRESETS_GEN.H"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define WAYPOINT_PRESET_COUNT 10u
#define WAYPOINT_LIMIT 65535u
#define WAYPOINT_END_Y LEADER_END_Y
#define JSON_NO_TOKEN ((size_t)-1)

static const char *const special_paths[] = {
    "sweep_lead_in", "sweep_loop", "encounter_leader", "boss_anchor"
};
static const LevelWaypoint safe_terminal = {WAYPOINT_END_Y, 0, 1};
static const LevelWaypoints *current_waypoints;

static void set_error(char *error, size_t error_size, const char *format, ...)
{
    va_list args;
    if (!error || error_size == 0 || error[0] != '\0') return;
    va_start(args, format);
    vsnprintf(error, error_size, format, args);
    va_end(args);
}

static int token_is(const JsonDocument *document, int index, ContentJsonType type)
{
    return document && document->tokens && index >= 0 &&
        (size_t)index < document->count && document->tokens[index].type == type;
}

static int semantic_name(const char *name)
{
    size_t i;
    if (!name[0] || name[0] < 'a' || name[0] > 'z') return 0;
    for (i = 1; name[i]; i++) {
        if ((name[i] >= 'a' && name[i] <= 'z') ||
            (name[i] >= '0' && name[i] <= '9') || name[i] == '_') continue;
        return 0;
    }
    return 1;
}

static int exact_fields(const JsonDocument *document, int object,
                        const char *const *required, size_t required_count)
{
    size_t cursor, count, i;
    if (!token_is(document, object, CONTENT_JSON_OBJECT)) return 0;
    count = content_json_size(document, object);
    if (count != required_count) return 0;
    for (i = 0; i < required_count; i++)
        if (content_json_member(document, object, required[i]) < 0) return 0;
    cursor = document->tokens[object].first_child;
    while (cursor != JSON_NO_TOKEN) {
        char key[128];
        size_t value = document->tokens[cursor].next_sibling;
        if (value == JSON_NO_TOKEN ||
            !content_json_string(document, (int)cursor, key, sizeof key)) return 0;
        for (i = 0; i < required_count; i++)
            if (strcmp(key, required[i]) == 0) break;
        if (i == required_count) return 0;
        cursor = document->tokens[value].next_sibling;
    }
    return 1;
}

static int read_signed(const JsonDocument *document, int object, const char *key,
                       long *value)
{
    int token = content_json_member(document, object, key);
    return content_json_integer(document, token, value) &&
        *value >= -32768 && *value <= 32767;
}

static int find_preset(const char *name)
{
    unsigned i;
    for (i = 0; i < WAYPOINT_PRESET_COUNT; i++)
        if (strcmp(level_waypoint_presets[i].name, name) == 0) return (int)i;
    return -1;
}

static int is_special_path(const char *name)
{
    size_t i;
    for (i = 0; i < sizeof special_paths / sizeof special_paths[0]; i++)
        if (strcmp(special_paths[i], name) == 0) return 1;
    return 0;
}

static int validate_special_paths(const JsonDocument *document,
                                  const JsonDocument *original,
                                  int paths, int original_paths,
                                  char *error, size_t error_size)
{
    size_t i;
    for (i = 0; i < sizeof special_paths / sizeof special_paths[0]; i++) {
        int actual = content_json_member(document, paths, special_paths[i]);
        int expected = content_json_member(original, original_paths, special_paths[i]);
        if ((actual < 0) != (expected < 0) ||
            (actual >= 0 && !content_json_equal(document, actual, original, expected))) {
            set_error(error, error_size, "special path '%s' must match its canonical definition",
                      special_paths[i]);
            return 0;
        }
    }
    return 1;
}

/* Read and validate an ordinary path override. With `destination` non-NULL,
   write its points and appended fly-off terminal into the owned route. */
static int path_override(const JsonDocument *document, int path,
                         size_t *route_count, LevelWaypoint *destination,
                         char *error, size_t error_size)
{
    static const char *const path_fields[] = {"points", "end"};
    static const char *const point_fields[] = {"x", "y"};
    static const char *const end_fields[] = {"kind", "x"};
    int points, end, kind_token;
    size_t count, cursor, i;
    long end_x;
    char kind[32];
    if (!exact_fields(document, path, path_fields, 2)) goto invalid_path;
    points = content_json_member(document, path, "points");
    end = content_json_member(document, path, "end");
    if (!token_is(document, points, CONTENT_JSON_ARRAY)) goto invalid_path;
    count = content_json_size(document, points);
    if (count == 0 || count >= WAYPOINT_LIMIT) goto invalid_path;
    if (!exact_fields(document, end, end_fields, 2) ||
        !content_json_string(document, kind_token = content_json_member(document, end, "kind"),
                             kind, sizeof kind) || strcmp(kind, "fly_off") != 0 ||
        !read_signed(document, end, "x", &end_x)) goto invalid_path;

    cursor = document->tokens[points].first_child;
    for (i = 0; i < count; i++) {
        long x, y;
        int point = (int)cursor;
        if (cursor == JSON_NO_TOKEN || !exact_fields(document, point, point_fields, 2) ||
            !read_signed(document, point, "x", &x) || !read_signed(document, point, "y", &y))
            goto invalid_path;
        if (destination) {
            destination[i].x = (uint16_t)x;
            destination[i].y = (uint16_t)((uint16_t)y - 32u);
            destination[i].terminal = 0;
        }
        cursor = document->tokens[cursor].next_sibling;
    }
    if (destination) {
        destination[count].x = (uint16_t)end_x;
        destination[count].y = WAYPOINT_END_Y;
        destination[count].terminal = 1;
    }
    *route_count = count + 1;
    return 1;

invalid_path:
    set_error(error, error_size,
              "ordinary waypoint requires nonempty signed points and a fly_off end");
    return 0;
}

void overkill_level_waypoints_bind_current(const LevelWaypoints *waypoints)
{
    current_waypoints = waypoints;
}

const LevelWaypoints *overkill_level_waypoints_current(void)
{
    return current_waypoints;
}

uint16_t overkill_waypoint_start(uint16_t legacy_start)
{
    unsigned i;
    if (!current_waypoints) return legacy_start;
    for (i = 0; i < WAYPOINT_PRESET_COUNT; i++) {
        if (level_waypoint_presets[i].legacy_start == legacy_start)
            return current_waypoints->starts[i];
    }
    return 0xFFFF;
}

const LevelWaypoint *overkill_waypoint_current_point(uint16_t ordinal)
{
    if (!current_waypoints) return NULL;
    if (ordinal >= current_waypoints->point_count || !current_waypoints->points)
        return &safe_terminal;
    return &current_waypoints->points[ordinal];
}

void overkill_level_waypoints_free(LevelWaypoints *waypoints)
{
    if (!waypoints) return;
    free(waypoints->points);
    free(waypoints);
}

int overkill_level_waypoints_parse(const JsonDocument *document,
                                   const JsonDocument *original,
                                   LevelWaypoints **result,
                                   char *error, size_t error_size)
{
    const LevelWaypointPreset *preset;
    LevelWaypoints *waypoints = NULL;
    size_t total = 0, i, route_count;
    int paths, original_paths, leaders, original_leaders;
    long version = 0;
    size_t cursor;
    int ok = 0;

    if (error && error_size) error[0] = '\0';
    if (!result) {
        set_error(error, error_size, "invalid waypoint parse result pointer");
        return 0;
    }
    *result = NULL;
    if (!token_is(document, 0, CONTENT_JSON_OBJECT) ||
        !token_is(original, 0, CONTENT_JSON_OBJECT)) {
        set_error(error, error_size, "waypoint parsing requires level objects");
        return 0;
    }
    paths = content_json_member(document, 0, "paths");
    original_paths = content_json_member(original, 0, "paths");
    leaders = content_json_member(document, 0, "leader_paths");
    original_leaders = content_json_member(original, 0, "leader_paths");
    content_json_integer(document, content_json_member(document, 0, "version"), &version);
    if (!token_is(document, paths, CONTENT_JSON_OBJECT) ||
        !token_is(original, original_paths, CONTENT_JSON_OBJECT) ||
        (version < 11 && ((leaders < 0) != (original_leaders < 0) ||
        (leaders >= 0 && !content_json_equal(document, leaders, original, original_leaders))))) {
        set_error(error, error_size, "paths must be an object and leader_paths must match the canonical definition");
        return 0;
    }
    if (!validate_special_paths(document, original, paths, original_paths, error, error_size)) return 0;

    /* Only the ten ordinary route presets and the four canonical special streams
       have established readers. Reject new identifiers rather than guessing. */
    cursor = document->tokens[paths].first_child;
    while (cursor != JSON_NO_TOKEN) {
        char name[128];
        int index;
        size_t value = document->tokens[cursor].next_sibling;
        if (value == JSON_NO_TOKEN ||
            !content_json_string(document, (int)cursor, name, sizeof name) ||
            !semantic_name(name) ||
            ((index = find_preset(name)) < 0 && !is_special_path(name))) {
            set_error(error, error_size, "unknown or invalid waypoint name");
            return 0;
        }
        if (index >= 0) {
            if (!path_override(document, (int)value, &route_count, NULL, error, error_size)) return 0;
        }
        cursor = document->tokens[value].next_sibling;
    }

    preset = level_waypoint_presets;
    for (i = 0; i < WAYPOINT_PRESET_COUNT; i++, preset++) {
        int override;
        if (!preset->name || !preset->points || preset->count == 0 ||
            !preset->points[preset->count - 1].terminal) {
            set_error(error, error_size, "generated waypoint preset table is incomplete");
            return 0;
        }
        for (route_count = 0; route_count + 1 < preset->count; route_count++) {
            if (preset->points[route_count].terminal) {
                set_error(error, error_size, "generated waypoint preset has an early terminal");
                return 0;
            }
        }
        override = content_json_member(document, paths, preset->name);
        if (override >= 0) {
            size_t override_count;
            if (!path_override(document, override, &override_count, NULL, error, error_size)) return 0;
            route_count = override_count;
        } else route_count = preset->count;
        if (route_count > WAYPOINT_LIMIT - total) {
            set_error(error, error_size, "flattened waypoint definition exceeds 65535 points");
            return 0;
        }
        total += route_count;
    }
    if (preset->name) {
        set_error(error, error_size, "generated waypoint table must contain exactly ten presets");
        return 0;
    }

    waypoints = (LevelWaypoints *)calloc(1, sizeof *waypoints);
    if (!waypoints) {
        set_error(error, error_size, "out of memory allocating waypoint definition");
        return 0;
    }
    waypoints->point_count = (uint16_t)total;
    waypoints->points = total ? (LevelWaypoint *)calloc(total, sizeof *waypoints->points) : NULL;
    if (total && !waypoints->points) {
        set_error(error, error_size, "out of memory allocating waypoint points");
        goto done;
    }

    total = 0;
    preset = level_waypoint_presets;
    for (i = 0; i < WAYPOINT_PRESET_COUNT; i++, preset++) {
        int override = content_json_member(document, paths, preset->name);
        waypoints->starts[i] = (uint16_t)total;
        if (override >= 0) {
            if (!path_override(document, override, &route_count,
                               &waypoints->points[total], error, error_size)) goto done;
        } else {
            route_count = preset->count;
            memcpy(&waypoints->points[total], preset->points,
                   route_count * sizeof *waypoints->points);
        }
        total += route_count;
    }
    ok = 1;
    *result = waypoints;
    waypoints = NULL;

done:
    overkill_level_waypoints_free(waypoints);
    return ok;
}
