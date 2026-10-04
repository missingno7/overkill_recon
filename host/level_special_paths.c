#include "level_special_paths.h"
#include "GAME_GEN.H"
#include "LEVEL_SPECIAL_PATH_PRESETS_GEN.H"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SPECIAL_PATH_COUNT 4u
#define PATH_LIMIT 65535u
#define JSON_NO_TOKEN ((size_t)-1)

static const char *const special_names[SPECIAL_PATH_COUNT] = {
    "sweep_lead_in", "sweep_loop", "encounter_leader", "boss_anchor"
};
static const char *const ordinary_names[] = {
    "path_follower_a", "path_follower_b", "path_follower_c",
    "path_follower_d", "path_follower_e", "path_follower_f",
    "path_follower_g", "demo_path_follower", "path_follower_left",
    "path_follower_right"
};
static const LevelSpecialPoint safe_halt = {LEADER_END_Y, 0, 0, LEVEL_PATH_INVALID};
static const LevelSpecialPaths *current_paths;

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

static int exact_fields(const JsonDocument *document, int object,
                        const char *const *required, size_t required_count)
{
    size_t cursor, i;
    if (!token_is(document, object, CONTENT_JSON_OBJECT) ||
        content_json_size(document, object) != required_count) return 0;
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

static int name_in(const char *name, const char *const *names, size_t count)
{
    size_t i;
    for (i = 0; i < count; i++)
        if (strcmp(name, names[i]) == 0) return 1;
    return 0;
}

static int preset_index(const char *name)
{
    unsigned i;
    for (i = 0; i < SPECIAL_PATH_COUNT; i++)
        if (strcmp(special_names[i], name) == 0) return (int)i;
    return -1;
}

static int parse_point(const JsonDocument *document, int point,
                       uint16_t *y, uint16_t *x)
{
    static const char *const fields[] = {"x", "y"};
    long signed_x, signed_y;
    if (!exact_fields(document, point, fields, 2) ||
        !read_signed(document, point, "x", &signed_x) ||
        !read_signed(document, point, "y", &signed_y)) return 0;
    *x = (uint16_t)signed_x;
    *y = (uint16_t)((uint16_t)signed_y - 32u);
    return 1;
}

static int ending_fields(const JsonDocument *document, unsigned index, int end)
{
    static const char *const restart_fields[] = {"kind"};
    static const char *const link_fields[] = {"kind", "path"};
    const char *const *fields = index < 2 ? link_fields : restart_fields;
    size_t count = index < 2 ? 2 : 1;
    const char *expected_kind = index == 0 ? "continue" :
                                index == 1 ? "jump" : "restart";
    char kind[32];
    if (!exact_fields(document, end, fields, count) ||
        !content_json_string(document,
            content_json_member(document, end, "kind"), kind, sizeof kind) ||
        strcmp(kind, expected_kind) != 0) return 0;
    if (index < 2) {
        char target[64];
        return content_json_string(document,
                   content_json_member(document, end, "path"),
                   target, sizeof target) &&
               strcmp(target, "sweep_loop") == 0;
    }
    return 1;
}

/* Validate an ordinary special-route override. Destination includes an
   appended control point for jump/restart routes; continue routes end by
   linking their last ordinary point to sweep_loop. */
static int parse_route(const JsonDocument *document, int definition,
                       unsigned index, size_t *route_count,
                       LevelSpecialPoint *destination,
                       char *error, size_t error_size)
{
    static const char *const path_fields[] = {"points", "end"};
    int points, end;
    size_t count, cursor, i;
    uint16_t first_y = 0, first_x = 0;
    int distinct = 0;
    if (!exact_fields(document, definition, path_fields, 2)) goto invalid;
    points = content_json_member(document, definition, "points");
    end = content_json_member(document, definition, "end");
    if (!token_is(document, points, CONTENT_JSON_ARRAY) ||
        !ending_fields(document, index, end)) goto invalid;
    count = content_json_size(document, points);
    if (count == 0 || count > PATH_LIMIT - (index == 0 ? 0u : 1u)) goto invalid;
    cursor = document->tokens[points].first_child;
    for (i = 0; i < count; i++) {
        int point = cursor == JSON_NO_TOKEN ? -1 : (int)cursor;
        uint16_t y, x;
        if (!parse_point(document, point, &y, &x)) goto invalid;
        if (i == 0) {
            first_y = y;
            first_x = x;
        } else if (y != first_y || x != first_x) distinct = 1;
        if (destination) {
            destination[i].y = y;
            destination[i].x = x;
            destination[i].next = 0;
            destination[i].control = LEVEL_PATH_POINT;
        }
        cursor = document->tokens[cursor].next_sibling;
    }
    if ((index == 1 || index == 3) && !distinct) goto invalid;
    if (destination && index != 0) {
        LevelSpecialPoint *marker = &destination[count];
        marker->y = UINT16_MAX;
        marker->x = 0;
        marker->next = 0;
        marker->control = LEVEL_PATH_LINK;
    }
    *route_count = count + (index == 0 ? 0u : 1u);
    return 1;

invalid:
    set_error(error, error_size,
              "special path '%s' has invalid points or its required ending",
              special_names[index]);
    return 0;
}

void overkill_level_special_paths_bind_current(const LevelSpecialPaths *paths)
{
    current_paths = paths;
}

const LevelSpecialPaths *overkill_level_special_paths_current(void)
{
    return current_paths;
}

uint16_t overkill_special_path_start(uint16_t legacy_start)
{
    unsigned i;
    if (!current_paths) return legacy_start;
    for (i = 0; i < SPECIAL_PATH_COUNT; i++)
        if (level_special_path_presets[i].legacy_start == legacy_start)
            return current_paths->starts[i];
    return UINT16_MAX;
}

const LevelSpecialPoint *overkill_special_path_point(uint16_t ordinal)
{
    if (!current_paths) return NULL;
    if (ordinal >= current_paths->point_count || !current_paths->points)
        return &safe_halt;
    return &current_paths->points[ordinal];
}

void overkill_level_special_paths_free(LevelSpecialPaths *paths)
{
    if (!paths) return;
    free(paths->points);
    free(paths);
}

int overkill_level_special_paths_parse(const JsonDocument *document,
                                       const JsonDocument *original,
                                       LevelSpecialPaths **result,
                                       char *error, size_t error_size)
{
    LevelSpecialPaths *paths = NULL;
    size_t counts[SPECIAL_PATH_COUNT], total = 0, i, cursor;
    int section, version_token, ok = 0;
    long version;

    if (error && error_size) error[0] = '\0';
    if (!result) {
        set_error(error, error_size, "invalid special path parse result pointer");
        return 0;
    }
    *result = NULL;
    if (!token_is(document, 0, CONTENT_JSON_OBJECT) ||
        !token_is(original, 0, CONTENT_JSON_OBJECT)) {
        set_error(error, error_size, "special path parsing requires level objects");
        return 0;
    }
    (void)original;
    version_token = content_json_member(document, 0, "version");
    if (!content_json_integer(document, version_token, &version) || version < 12) {
        set_error(error, error_size, "owned special paths require level format version 12 or later");
        return 0;
    }
    section = content_json_member(document, 0, "paths");
    if (!token_is(document, section, CONTENT_JSON_OBJECT)) {
        set_error(error, error_size, "paths must be an object");
        return 0;
    }

    cursor = document->tokens[section].first_child;
    while (cursor != JSON_NO_TOKEN) {
        char name[128];
        size_t value = document->tokens[cursor].next_sibling;
        int index;
        if (value == JSON_NO_TOKEN ||
            !content_json_string(document, (int)cursor, name, sizeof name) ||
            ((index = preset_index(name)) < 0 &&
             !name_in(name, ordinary_names,
                      sizeof ordinary_names / sizeof ordinary_names[0]))) {
            set_error(error, error_size, "unknown path name");
            return 0;
        }
        if (index >= 0 &&
            !parse_route(document, (int)value, (unsigned)index, &counts[index],
                         NULL, error, error_size)) return 0;
        cursor = document->tokens[value].next_sibling;
    }

    for (i = 0; i < SPECIAL_PATH_COUNT; i++) {
        const LevelSpecialPreset *preset = &level_special_path_presets[i];
        int override = content_json_member(document, section, special_names[i]);
        size_t count;
        if (!preset->name || strcmp(preset->name, special_names[i]) != 0 ||
            !preset->points || preset->count == 0 ||
            preset->ending != (i == 0 ? 0 : i == 1 ? 1 : 2) ||
            preset->target != (i == 0 ? 1 : i)) {
            set_error(error, error_size, "generated special path presets are incomplete");
            return 0;
        }
        {
            size_t point;
            for (point = 0; point < preset->count; point++) {
                uint8_t expected_control =
                    (uint8_t)(i != 0 && point + 1 == preset->count);
                if (preset->points[point].control != expected_control) {
                    set_error(error, error_size,
                              "generated special path has an invalid control marker");
                    return 0;
                }
            }
        }
        if (override >= 0) {
            count = counts[i];
        } else count = preset->count;
        if (count == 0 || count > PATH_LIMIT - total) {
            set_error(error, error_size, "flattened special paths exceed 65535 points");
            return 0;
        }
        total += count;
    }
    if (level_special_path_presets[SPECIAL_PATH_COUNT].name != NULL) {
        set_error(error, error_size, "generated special path table must contain four entries");
        return 0;
    }

    paths = (LevelSpecialPaths *)calloc(1, sizeof *paths);
    if (!paths) {
        set_error(error, error_size, "out of memory allocating special paths");
        return 0;
    }
    paths->point_count = (uint16_t)total;
    paths->points = (LevelSpecialPoint *)calloc(total, sizeof *paths->points);
    if (!paths->points) {
        set_error(error, error_size, "out of memory allocating special path points");
        goto done;
    }

    total = 0;
    for (i = 0; i < SPECIAL_PATH_COUNT; i++) {
        const LevelSpecialPreset *preset = &level_special_path_presets[i];
        int override = content_json_member(document, section, special_names[i]);
        size_t count;
        paths->starts[i] = (uint16_t)total;
        if (override >= 0) {
            if (!parse_route(document, override, (unsigned)i, &count,
                             &paths->points[total], error, error_size)) goto done;
        } else {
            size_t j;
            count = preset->count;
            memcpy(&paths->points[total], preset->points,
                   count * sizeof *paths->points);
            for (j = 0; j < count; j++)
                if (paths->points[total + j].control > 1) {
                    set_error(error, error_size,
                              "generated special path has an invalid control point");
                    goto done;
                }
        }
        {
            size_t j;
            for (j = 0; j < count; j++) {
                LevelSpecialPoint *point = &paths->points[total + j];
                if (point->control == LEVEL_PATH_LINK) {
                    unsigned target = preset->target;
                    point->next = paths->starts[target];
                } else if (j + 1 < count) {
                    point->next = (uint16_t)(total + j + 1);
                } else if (i == 0) {
                    point->next = (uint16_t)(total + count);
                }
            }
        }
        total += count;
    }

    /* The continue path is first and always targets the second route. Its
       target is resolved only after all route starts are known. */
    {
        size_t i0 = paths->starts[0];
        size_t count0 = paths->starts[1] - paths->starts[0];
        if (count0 == 0) {
            set_error(error, error_size, "continue path has no points");
            goto done;
        }
        paths->points[i0 + count0 - 1].next = paths->starts[1];
    }

    ok = 1;
    *result = paths;
    paths = NULL;

done:
    overkill_level_special_paths_free(paths);
    return ok;
}
