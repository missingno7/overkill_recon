#include "level_timeline_data.h"

#include "GAME_GEN.H"
#include "LEVEL_PRESETS_GEN.H"

#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LEVEL_TIMELINE_MAX_ITEMS 65535u
#define JSON_NO_TOKEN ((size_t)-1)

typedef struct FormationLookup {
    char name[128];
    const LevelFormation *formation;
} FormationLookup;

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
    return index >= 0 && (size_t)index < document->count &&
        document->tokens[index].type == type;
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

static int read_string(const JsonDocument *document, int object, const char *key,
                       char *output, size_t output_size)
{
    return content_json_string(document, content_json_member(document, object, key),
                               output, output_size);
}

static int read_integer(const JsonDocument *document, int object, const char *key,
                        long minimum, long maximum, long *value)
{
    int token = content_json_member(document, object, key);
    return content_json_integer(document, token, value) &&
        *value >= minimum && *value <= maximum;
}

static int field_in(const char *name, const char *const *fields, size_t count)
{
    size_t i;
    for (i = 0; i < count; i++) if (strcmp(name, fields[i]) == 0) return 1;
    return 0;
}

static int exact_fields(const JsonDocument *document, int object,
                        const char *const *required, size_t required_count,
                        const char *const *optional, size_t optional_count)
{
    size_t cursor, property_count, i;
    if (!token_is(document, object, CONTENT_JSON_OBJECT)) return 0;
    property_count = content_json_size(document, object);
    if (property_count < required_count || property_count > required_count + optional_count) return 0;
    for (i = 0; i < required_count; i++)
        if (content_json_member(document, object, required[i]) < 0) return 0;
    cursor = document->tokens[object].first_child;
    while (cursor != JSON_NO_TOKEN) {
        char key[128];
        size_t value = document->tokens[cursor].next_sibling;
        if (value == JSON_NO_TOKEN ||
            !content_json_string(document, (int)cursor, key, sizeof key) ||
            (!field_in(key, required, required_count) &&
             !field_in(key, optional, optional_count))) return 0;
        cursor = document->tokens[value].next_sibling;
    }
    return 1;
}

static int compatibility_true(const JsonDocument *document, int object,
                              const char *field)
{
    static const char *const required[] = {"clear_event_marker"};
    static const char *const live_required[] = {"live_original"};
    const char *const *fields;
    size_t count;
    int token;
    if (strcmp(field, "live_original") == 0) {
        fields = live_required;
        count = sizeof live_required / sizeof live_required[0];
    } else {
        fields = required;
        count = sizeof required / sizeof required[0];
    }
    if (!exact_fields(document, object, fields, count, NULL, 0)) return 0;
    token = content_json_member(document, object, field);
    return token_is(document, token, CONTENT_JSON_TRUE);
}

static const LevelPresetName *find_preset(const LevelPresetName *presets, const char *name)
{
    const LevelPresetName *item;
    for (item = presets; item->name; item++)
        if (strcmp(item->name, name) == 0) return item;
    return NULL;
}

static int compare_formation_lookup(const void *a, const void *b)
{
    const FormationLookup *left = (const FormationLookup *)a;
    const FormationLookup *right = (const FormationLookup *)b;
    return strcmp(left->name, right->name);
}

static const LevelFormation *lookup_formation(const FormationLookup *lookup,
                                               size_t count, const char *name)
{
    size_t low = 0, high = count;
    while (low < high) {
        size_t middle = low + (high - low) / 2;
        int order = strcmp(name, lookup[middle].name);
        if (order == 0) return lookup[middle].formation;
        if (order < 0) high = middle;
        else low = middle + 1;
    }
    return NULL;
}

static int parse_formations(const JsonDocument *document, int formations_object,
                            LevelTimeline *timeline, FormationLookup **lookup_result,
                            char *error, size_t error_size)
{
    size_t count, cursor, i;
    FormationLookup *lookup = NULL;
    const char *const fields[] = {"enemy", "size", "layer", "members"};
    count = content_json_size(document, formations_object);
    if (!token_is(document, formations_object, CONTENT_JSON_OBJECT) || count > LEVEL_TIMELINE_MAX_ITEMS) {
        set_error(error, error_size, "formations must be a named object with at most 65535 entries");
        return 0;
    }
    timeline->formation_count = (uint16_t)count;
    if (count) {
        timeline->formations = (LevelFormation *)calloc(count, sizeof *timeline->formations);
        lookup = (FormationLookup *)calloc(count, sizeof *lookup);
        if (!timeline->formations || !lookup) {
            free(lookup);
            set_error(error, error_size, "out of memory reading formations");
            return 0;
        }
    }

    cursor = document->tokens[formations_object].first_child;
    for (i = 0; i < count; i++) {
        char name[128], enemy[128], size_name[128], layer_name[128];
        int value, member_array;
        size_t member_count, member_cursor, j;
        const LevelPresetName *preset;
        LevelFormation *formation = &timeline->formations[i];

        value = (int)cursor;
        if (cursor == JSON_NO_TOKEN ||
            !content_json_string(document, value, name, sizeof name) || !semantic_name(name)) {
            free(lookup);
            set_error(error, error_size, "formation names must match [a-z][a-z0-9_]* and fit 127 bytes");
            return 0;
        }
        if (document->tokens[cursor].next_sibling == JSON_NO_TOKEN) {
            free(lookup);
            set_error(error, error_size, "formation is missing its definition");
            return 0;
        }
        value = (int)document->tokens[cursor].next_sibling;
        if (!exact_fields(document, value, fields, sizeof fields / sizeof fields[0], NULL, 0) ||
            !read_string(document, value, "enemy", enemy, sizeof enemy) ||
            !read_string(document, value, "size", size_name, sizeof size_name) ||
            !read_string(document, value, "layer", layer_name, sizeof layer_name)) {
            free(lookup);
            set_error(error, error_size, "formation '%s' must specify enemy, size, layer and members", name);
            return 0;
        }
        preset = find_preset(level_enemy_presets, enemy);
        if (!preset) goto bad_formation_preset;
        formation->behavior = preset->value;
        preset = find_preset(level_size_presets, size_name);
        if (!preset) goto bad_formation_preset;
        formation->size = preset->value;
        preset = find_preset(level_layer_presets, layer_name);
        if (!preset) goto bad_formation_preset;
        formation->layer = preset->value;

        member_array = content_json_member(document, value, "members");
        member_count = content_json_size(document, member_array);
        if (!token_is(document, member_array, CONTENT_JSON_ARRAY) ||
            member_count == 0 || member_count > LEVEL_TIMELINE_MAX_ITEMS) {
            free(lookup);
            set_error(error, error_size, "formation '%s' must have 1..65535 members", name);
            return 0;
        }
        formation->count = (uint16_t)member_count;
        formation->members = (LevelFormationMember *)calloc(member_count, sizeof *formation->members);
        if (!formation->members) {
            free(lookup);
            set_error(error, error_size, "out of memory reading formation members");
            return 0;
        }
        member_cursor = document->tokens[member_array].first_child;
        for (j = 0; j < member_count; j++) {
            static const char *const member_fields[] = {"dx", "dy"};
            int member = (int)member_cursor;
            long dx, dy;
            if (member_cursor == JSON_NO_TOKEN ||
                !exact_fields(document, member, member_fields, 2, NULL, 0) ||
                !read_integer(document, member, "dx", -32768, 32767, &dx) ||
                !read_integer(document, member, "dy", -32768, 32767, &dy)) {
                free(lookup);
                set_error(error, error_size, "formation '%s' member offsets must be signed words", name);
                return 0;
            }
            formation->members[j].dx = (int16_t)dx;
            formation->members[j].dy = (int16_t)dy;
            member_cursor = document->tokens[member_cursor].next_sibling;
        }
        memcpy(lookup[i].name, name, strlen(name) + 1);
        lookup[i].formation = formation;
        cursor = document->tokens[value].next_sibling;
        continue;

bad_formation_preset:
        free(lookup);
        set_error(error, error_size, "formation '%s' uses an unknown enemy, size or layer preset", name);
        return 0;
    }
    if (count > 1) qsort(lookup, count, sizeof *lookup, compare_formation_lookup);
    for (i = 1; i < count; i++) {
        if (strcmp(lookup[i - 1].name, lookup[i].name) == 0) {
            free(lookup);
            set_error(error, error_size, "duplicate semantic formation name");
            return 0;
        }
    }
    *lookup_result = lookup;
    return 1;
}

static int parse_timeline(const JsonDocument *document, int timeline_array,
                          const FormationLookup *lookup, size_t formation_count,
                          LevelTimeline *timeline, char *error, size_t error_size)
{
    static const char *const required[] = {"clock", "formation", "x", "y", "group"};
    static const char *const optional[] = {"compatibility"};
    static const char *const group_fields[] = {"drop"};
    size_t count, cursor, i;
    long previous_clock = 65535;
    if (!token_is(document, timeline_array, CONTENT_JSON_ARRAY)) {
        set_error(error, error_size, "timeline must be an ordered event array");
        return 0;
    }
    count = content_json_size(document, timeline_array);
    if (count > LEVEL_TIMELINE_MAX_ITEMS) {
        set_error(error, error_size, "timeline exceeds 65535 events");
        return 0;
    }
    timeline->event_count = (uint16_t)count;
    if (count) {
        timeline->events = (LevelTimelineEvent *)calloc(count, sizeof *timeline->events);
        if (!timeline->events) {
            set_error(error, error_size, "out of memory reading timeline");
            return 0;
        }
    }
    cursor = document->tokens[timeline_array].first_child;
    for (i = 0; i < count; i++) {
        char formation_name[128], drop_name[128];
        int event = (int)cursor, compatibility, group;
        long clock, x, y;
        const LevelPresetName *drop;
        const LevelFormation *formation;
        if (cursor == JSON_NO_TOKEN ||
            !exact_fields(document, event, required, 5, optional, 1) ||
            !read_integer(document, event, "clock", 0, 65534, &clock) || clock > previous_clock ||
            !read_string(document, event, "formation", formation_name, sizeof formation_name) ||
            !semantic_name(formation_name) ||
            !read_integer(document, event, "x", -32768, 32767, &x) ||
            !read_integer(document, event, "y", -32768, 32767, &y)) {
            set_error(error, error_size, "timeline events require ordered clocks, a formation and signed-word origins");
            return 0;
        }
        formation = lookup_formation(lookup, formation_count, formation_name);
        if (!formation) {
            set_error(error, error_size, "timeline references undefined formation '%s'", formation_name);
            return 0;
        }
        group = content_json_member(document, event, "group");
        if (!exact_fields(document, group, group_fields, 1, NULL, 0) ||
            !read_string(document, group, "drop", drop_name, sizeof drop_name) ||
            !(drop = find_preset(level_drop_presets, drop_name))) {
            set_error(error, error_size, "timeline event group must specify a known drop");
            return 0;
        }
        compatibility = content_json_member(document, event, "compatibility");
        if (compatibility >= 0 && !compatibility_true(document, compatibility, "clear_event_marker")) {
            set_error(error, error_size, "timeline compatibility only supports clear_event_marker=true");
            return 0;
        }
        timeline->events[i].clock = (uint16_t)clock;
        timeline->events[i].x = (uint16_t)x;
        timeline->events[i].y = (uint16_t)y;
        timeline->events[i].marker = compatibility >= 0 ? 0 : 1;
        timeline->events[i].drop = (uint8_t)drop->value;
        timeline->events[i].formation = formation;
        previous_clock = clock;
        cursor = document->tokens[cursor].next_sibling;
    }
    return 1;
}

static int parse_checkpoints(const JsonDocument *document, int checkpoints_array,
                             LevelTimeline *timeline, char *error, size_t error_size)
{
    static const char *const fields[] = {"map_row", "script_clock", "resume_event"};
    size_t count, cursor, i;
    long previous_row = 11;
    if (!token_is(document, checkpoints_array, CONTENT_JSON_ARRAY)) {
        set_error(error, error_size, "checkpoints must be an array");
        return 0;
    }
    count = content_json_size(document, checkpoints_array);
    if (count == 0 || count > LEVEL_TIMELINE_MAX_ITEMS) {
        set_error(error, error_size, "checkpoints must contain 1..65535 entries");
        return 0;
    }
    timeline->checkpoint_count = (uint16_t)count;
    timeline->checkpoints = (LevelTimelineCheckpoint *)calloc(count, sizeof *timeline->checkpoints);
    if (!timeline->checkpoints) {
        set_error(error, error_size, "out of memory reading checkpoints");
        return 0;
    }
    cursor = document->tokens[checkpoints_array].first_child;
    for (i = 0; i < count; i++) {
        int checkpoint = (int)cursor;
        long row, clock, resume;
        if (cursor == JSON_NO_TOKEN ||
            !exact_fields(document, checkpoint, fields, 3, NULL, 0) ||
            !read_integer(document, checkpoint, "map_row", 12, 286, &row) || row <= previous_row ||
            !read_integer(document, checkpoint, "script_clock", 0, 65535, &clock) ||
            !read_integer(document, checkpoint, "resume_event", 0, timeline->event_count, &resume)) {
            set_error(error, error_size, "checkpoints require increasing rows 12..286 and valid resume ordinals");
            return 0;
        }
        timeline->checkpoints[i].map_position = (uint16_t)(row * MAP_ROW_BYTES);
        timeline->checkpoints[i].script_clock = (uint16_t)clock;
        timeline->checkpoints[i].resume_event = (uint16_t)resume;
        previous_row = row;
        cursor = document->tokens[cursor].next_sibling;
    }
    return 1;
}

static int parse_spawn_parameters(const JsonDocument *document, const JsonDocument *original,
                                  int parameters_object, LevelTimeline *timeline,
                                  char *error, size_t error_size)
{
    static const char *const required[] = {"tile_member_hit_points", "other_member_hit_points"};
    static const char *const optional[] = {"compatibility"};
    long tile_hp, other_hp;
    int compatibility, original_parameters;
    if (!exact_fields(document, parameters_object, required, 2, optional, 1) ||
        !read_integer(document, parameters_object, "tile_member_hit_points", 0, 65535, &tile_hp) ||
        !read_integer(document, parameters_object, "other_member_hit_points", 0, 65535, &other_hp)) {
        set_error(error, error_size, "formation_spawn_parameters requires two unsigned-word HP values");
        return 0;
    }
    compatibility = content_json_member(document, parameters_object, "compatibility");
    if (compatibility >= 0) {
        original_parameters = content_json_member(original, 0, "formation_spawn_parameters");
        if (!compatibility_true(document, compatibility, "live_original") ||
            original_parameters < 0 ||
            !content_json_equal(document, parameters_object, original, original_parameters)) {
            set_error(error, error_size, "live formation spawn parameters must exactly match the canonical section");
            return 0;
        }
        timeline->live_parameters = 1;
    } else {
        timeline->parameters.tile_member_hit_points = (uint16_t)tile_hp;
        timeline->parameters.other_member_hit_points = (uint16_t)other_hp;
        timeline->live_parameters = 0;
    }
    return 1;
}

void overkill_level_timeline_free(LevelTimeline *timeline)
{
    uint16_t i;
    if (!timeline) return;
    if (timeline->formations)
        for (i = 0; i < timeline->formation_count; i++) free(timeline->formations[i].members);
    free(timeline->formations);
    free(timeline->events);
    free(timeline->checkpoints);
    free(timeline);
}

int overkill_level_timeline_parse(const JsonDocument *document, const JsonDocument *original,
                                  uint16_t profile, LevelTimeline **result,
                                  char *error, size_t error_size)
{
    LevelTimeline *timeline = NULL;
    FormationLookup *lookup = NULL;
    long version;
    int formations, events, checkpoints, parameters, ok = 0;
    if (error && error_size) error[0] = '\0';
    if (!result) {
        set_error(error, error_size, "invalid timeline parse result pointer");
        return 0;
    }
    *result = NULL;
    if (!document || !original || profile > 5 || !token_is(document, 0, CONTENT_JSON_OBJECT) ||
        !token_is(original, 0, CONTENT_JSON_OBJECT)) {
        set_error(error, error_size, "timeline parsing requires two level objects and profile 0..5");
        return 0;
    }
    if (!read_integer(document, 0, "version", 9, LONG_MAX, &version) || version < 9 ||
        content_json_member(document, 0, "formations") < 0 ||
        content_json_member(document, 0, "timeline") < 0 ||
        content_json_member(document, 0, "checkpoints") < 0 ||
        content_json_member(document, 0, "formation_spawn_parameters") < 0) {
        set_error(error, error_size, "timeline parser requires version 9+ formations, timeline, checkpoints and spawn parameters");
        return 0;
    }
    timeline = (LevelTimeline *)calloc(1, sizeof *timeline);
    if (!timeline) {
        set_error(error, error_size, "out of memory allocating timeline definition");
        return 0;
    }
    timeline->behavior_profile = profile;
    formations = content_json_member(document, 0, "formations");
    events = content_json_member(document, 0, "timeline");
    checkpoints = content_json_member(document, 0, "checkpoints");
    parameters = content_json_member(document, 0, "formation_spawn_parameters");
    if (!parse_formations(document, formations, timeline, &lookup, error, error_size) ||
        !parse_timeline(document, events, lookup, timeline->formation_count,
                        timeline, error, error_size) ||
        !parse_checkpoints(document, checkpoints, timeline, error, error_size) ||
        !parse_spawn_parameters(document, original, parameters, timeline, error, error_size)) goto done;
    ok = 1;
    *result = timeline;
    timeline = NULL;

done:
    free(lookup);
    overkill_level_timeline_free(timeline);
    return ok;
}
