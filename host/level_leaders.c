#include "level_leaders.h"
#include "game.h"
#include "LEVEL_LEADER_PRESETS_GEN.H"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LEADER_PRESET_COUNT 6u
#define LEADER_LIMIT 65535u
#define JSON_NO_TOKEN ((size_t)-1)

static const char *const leader_names[LEADER_PRESET_COUNT] = {
    "sway_leader", "sweep_leader", "bob_chase_leader",
    "slot_hopper_leader", "sweeper_leader", "march_leader"
};
static const LevelLeaderStep safe_terminal = {LEADER_END_Y, 0, 0, 0, 0, 1};
static const LevelLeaderPaths *current_leaders;

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

static int preset_index(const char *name)
{
    unsigned i;
    for (i = 0; i < LEADER_PRESET_COUNT; i++)
        if (strcmp(leader_names[i], name) == 0) return (int)i;
    return -1;
}

static int has_follower(unsigned preset)
{
    return preset == 1 || preset == 2 || preset == 4 || preset == 5;
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

static int parse_leader(const JsonDocument *document, int definition,
                        unsigned preset, size_t *count,
                        LevelLeaderStep *destination, char *error,
                        size_t error_size)
{
    static const char *const plain_fields[] = {"steps", "end"};
    static const char *const slot_fields[] = {"steps", "end", "slots"};
    static const char *const end_fields[] = {"kind", "x"};
    static const char *const target_fields[] = {"target"};
    static const char *const follower_fields[] = {"target", "follower"};
    const char *const *fields = preset == 3 ? slot_fields : plain_fields;
    size_t field_count = preset == 3 ? 3 : 2;
    int steps, end, kind_token;
    size_t step_count, cursor, i;
    long end_x;
    char kind[32];

    if (!exact_fields(document, definition, fields, field_count)) goto invalid;
    steps = content_json_member(document, definition, "steps");
    end = content_json_member(document, definition, "end");
    if (!token_is(document, steps, CONTENT_JSON_ARRAY) ||
        !exact_fields(document, end, end_fields, 2) ||
        !content_json_string(document,
            kind_token = content_json_member(document, end, "kind"),
            kind, sizeof kind) || strcmp(kind, "fly_off") != 0 ||
        !read_signed(document, end, "x", &end_x)) goto invalid;
    step_count = content_json_size(document, steps);
    if (step_count == 0 || step_count >= LEADER_LIMIT) goto invalid;

    cursor = document->tokens[steps].first_child;
    for (i = 0; i < step_count; i++) {
        int step = cursor == JSON_NO_TOKEN ? -1 : (int)cursor;
        int follower;
        if (!exact_fields(document, step,
                          has_follower(preset) ? follower_fields : target_fields,
                          has_follower(preset) ? 2 : 1)) goto invalid;
        follower = content_json_member(document, step, "follower");
        if (!destination) {
            uint16_t discard_y, discard_x;
            if (!parse_point(document,
                    content_json_member(document, step, "target"),
                    &discard_y, &discard_x)) goto invalid;
            if (preset == 2 && token_is(document, follower, CONTENT_JSON_NULL))
                goto invalid;
            if (has_follower(preset) &&
                !token_is(document, follower, CONTENT_JSON_NULL) &&
                !parse_point(document, follower, &discard_y, &discard_x)) goto invalid;
        } else {
            LevelLeaderStep *out = &destination[i];
            if (!parse_point(document,
                    content_json_member(document, step, "target"),
                    &out->y, &out->x)) goto invalid;
            out->spawn_follower = 0;
            out->follower_y = out->follower_x = 0;
            out->terminal = 0;
            if (has_follower(preset)) {
                if (token_is(document, follower, CONTENT_JSON_NULL)) {
                    if (preset == 2) goto invalid;
                    out->follower_y = UINT16_MAX;
                    out->follower_x = UINT16_MAX;
                    out->spawn_follower = 0;
                } else {
                    if (!parse_point(document, follower,
                                     &out->follower_y, &out->follower_x)) goto invalid;
                    out->spawn_follower = 1;
                }
            }
        }
        cursor = document->tokens[cursor].next_sibling;
    }
    if (destination) {
        destination[step_count].y = LEADER_END_Y;
        destination[step_count].x = (uint16_t)end_x;
        destination[step_count].follower_y = 0;
        destination[step_count].follower_x = 0;
        destination[step_count].spawn_follower = 0;
        destination[step_count].terminal = 1;
    }
    *count = step_count + 1;
    return 1;

invalid:
    set_error(error, error_size,
        "leader path '%s' requires steps with the correct target/follower fields and a fly_off end",
        leader_names[preset]);
    return 0;
}

static int parse_slots(const JsonDocument *document, int definition,
                       size_t *slot_count, LevelLeaderSlot *destination,
                       char *error, size_t error_size)
{
    int slots = content_json_member(document, definition, "slots");
    size_t count, cursor, i;
    int distinct = 0;
    if (!token_is(document, slots, CONTENT_JSON_ARRAY)) goto invalid;
    count = content_json_size(document, slots);
    if (count < 2 || count > LEADER_LIMIT) goto invalid;
    cursor = document->tokens[slots].first_child;
    for (i = 0; i < count; i++) {
        int point = cursor == JSON_NO_TOKEN ? -1 : (int)cursor;
        uint16_t y, x;
        if (!parse_point(document, point, &y, &x)) goto invalid;
        if (destination) {
            destination[i].y = y;
            destination[i].x = x;
            if (i > 0 && (destination[0].x != x || destination[0].y != y))
                distinct = 1;
        } else if (i > 0) {
            /* Determine whether the cycle can change position without storing it. */
            int first = content_json_at(document, slots, 0);
            long first_x, first_y, current_x, current_y;
            if (read_signed(document, first, "x", &first_x) &&
                read_signed(document, first, "y", &first_y) &&
                read_signed(document, point, "x", &current_x) &&
                read_signed(document, point, "y", &current_y) &&
                (first_x != current_x || first_y != current_y)) distinct = 1;
        }
        cursor = document->tokens[cursor].next_sibling;
    }
    if (!distinct) goto invalid;
    *slot_count = count;
    return 1;

invalid:
    set_error(error, error_size,
              "slot-hopper slots require at least two distinct signed positions");
    return 0;
}

void overkill_level_leaders_bind_current(const LevelLeaderPaths *leaders)
{
    current_leaders = leaders;
}

const LevelLeaderPaths *overkill_level_leaders_current(void)
{
    return current_leaders;
}

uint16_t overkill_leader_start(uint16_t legacy_start)
{
    unsigned i;
    if (!current_leaders) return legacy_start;
    for (i = 0; i < LEADER_PRESET_COUNT; i++)
        if (level_leader_presets[i].legacy_start == legacy_start)
            return current_leaders->starts[i];
    return 0xFFFF;
}

uint16_t overkill_leader_end(uint16_t legacy_end)
{
    unsigned i;
    if (!current_leaders) return legacy_end;
    for (i = 0; i < LEADER_PRESET_COUNT; i++)
        if (level_leader_presets[i].legacy_end == legacy_end)
            return current_leaders->ends[i];
    return 0xFFFF;
}

const LevelLeaderStep *overkill_leader_current_step(uint16_t ordinal)
{
    if (!current_leaders) return NULL;
    if (ordinal >= current_leaders->step_count || !current_leaders->steps)
        return &safe_terminal;
    return &current_leaders->steps[ordinal];
}

const LevelLeaderSlot *overkill_leader_slot(uint16_t ordinal)
{
    if (!current_leaders) return NULL;
    if (!current_leaders->slots || current_leaders->slot_count == 0) return NULL;
    return &current_leaders->slots[ordinal % current_leaders->slot_count];
}

uint16_t overkill_leader_slot_start(void)
{
    return current_leaders ? 0 : GAME_OFFSET(FormationSlots);
}

uint16_t overkill_leader_slot_next(uint16_t cursor)
{
    if (!current_leaders) return (uint16_t)(cursor + 4u);
    if (current_leaders->slot_count == 0) return 0;
    return (uint16_t)(((size_t)cursor + 1u) % current_leaders->slot_count);
}

uint16_t overkill_leader_slot_limit(void)
{
    return current_leaders ? current_leaders->slot_count : GAME_OFFSET(FormationSlotsEnd);
}

void overkill_level_leaders_free(LevelLeaderPaths *leaders)
{
    if (!leaders) return;
    free(leaders->steps);
    free(leaders->slots);
    free(leaders);
}

int overkill_level_leaders_parse(const JsonDocument *document,
                                 const JsonDocument *original,
                                 LevelLeaderPaths **result,
                                 char *error, size_t error_size)
{
    LevelLeaderPaths *leaders = NULL;
    size_t counts[LEADER_PRESET_COUNT], total = 0, slots_count = 0;
    size_t i, cursor;
    int section, ok = 0;

    if (error && error_size) error[0] = '\0';
    if (!result) {
        set_error(error, error_size, "invalid leader parse result pointer");
        return 0;
    }
    *result = NULL;
    if (!token_is(document, 0, CONTENT_JSON_OBJECT) ||
        !token_is(original, 0, CONTENT_JSON_OBJECT)) {
        set_error(error, error_size, "leader parsing requires level objects");
        return 0;
    }
    (void)original;
    section = content_json_member(document, 0, "leader_paths");
    if (section >= 0 && !token_is(document, section, CONTENT_JSON_OBJECT)) {
        set_error(error, error_size, "leader_paths must be an object");
        return 0;
    }

    for (i = 0; i < LEADER_PRESET_COUNT; i++) {
        const LevelLeaderPreset *preset = &level_leader_presets[i];
        int definition = section < 0 ? -1 :
            content_json_member(document, section, leader_names[i]);
        size_t step;
        if (!preset->name || strcmp(preset->name, leader_names[i]) != 0 ||
            !preset->steps || preset->count == 0 ||
            !preset->steps[preset->count - 1].terminal) {
            set_error(error, error_size, "generated leader preset table is incomplete");
            return 0;
        }
        for (step = 0; step < preset->count; step++) {
            if (!!preset->steps[step].terminal != (step + 1 == preset->count)) {
                set_error(error, error_size, "generated leader preset has an invalid terminal");
                return 0;
            }
        }
        if (definition >= 0) {
            if (!parse_leader(document, definition, (unsigned)i, &counts[i], NULL,
                              error, error_size)) return 0;
        } else counts[i] = preset->count;
        if (counts[i] > LEADER_LIMIT - total) {
            set_error(error, error_size, "flattened leader paths exceed 65535 steps");
            return 0;
        }
        total += counts[i];
        if (i == 3) {
            if (definition >= 0) {
                if (!parse_slots(document, definition, &slots_count, NULL,
                                 error, error_size)) return 0;
            } else slots_count = sizeof level_leader_slots_default /
                                  sizeof level_leader_slots_default[0];
        }
    }
    if (level_leader_presets[LEADER_PRESET_COUNT].name != NULL) {
        set_error(error, error_size, "generated leader preset table must contain six entries");
        return 0;
    }
    if (section >= 0) {
        cursor = document->tokens[section].first_child;
        while (cursor != JSON_NO_TOKEN) {
            char name[128];
            size_t value = document->tokens[cursor].next_sibling;
            if (value == JSON_NO_TOKEN ||
                !content_json_string(document, (int)cursor, name, sizeof name) ||
                preset_index(name) < 0) {
                set_error(error, error_size, "unknown leader path name");
                return 0;
            }
            cursor = document->tokens[value].next_sibling;
        }
    }
    if (slots_count < 2 || slots_count > LEADER_LIMIT) {
        set_error(error, error_size, "generated leader slot table is incomplete");
        return 0;
    }

    leaders = (LevelLeaderPaths *)calloc(1, sizeof *leaders);
    if (!leaders) {
        set_error(error, error_size, "out of memory allocating leader definition");
        return 0;
    }
    leaders->step_count = (uint16_t)total;
    leaders->slot_count = (uint16_t)slots_count;
    leaders->steps = (LevelLeaderStep *)calloc(total, sizeof *leaders->steps);
    leaders->slots = (LevelLeaderSlot *)calloc(slots_count, sizeof *leaders->slots);
    if (!leaders->steps || !leaders->slots) {
        set_error(error, error_size, "out of memory allocating leader paths");
        goto done;
    }

    total = 0;
    for (i = 0; i < LEADER_PRESET_COUNT; i++) {
        const LevelLeaderPreset *preset = &level_leader_presets[i];
        int definition = section < 0 ? -1 :
            content_json_member(document, section, leader_names[i]);
        leaders->starts[i] = (uint16_t)total;
        if (definition >= 0) {
            if (!parse_leader(document, definition, (unsigned)i, &counts[i],
                              &leaders->steps[total], error, error_size)) goto done;
        } else {
            counts[i] = preset->count;
            memcpy(&leaders->steps[total], preset->steps,
                   counts[i] * sizeof *leaders->steps);
        }
        total += counts[i];
        leaders->ends[i] = (uint16_t)(total - 1u);
    }

    {
        int slot_definition = section < 0 ? -1 :
            content_json_member(document, section, "slot_hopper_leader");
        if (slot_definition >= 0) {
            if (!parse_slots(document, slot_definition, &slots_count,
                             leaders->slots, error, error_size)) goto done;
        } else {
            memcpy(leaders->slots, level_leader_slots_default,
                   slots_count * sizeof *leaders->slots);
        }
    }
    ok = 1;
    *result = leaders;
    leaders = NULL;

done:
    overkill_level_leaders_free(leaders);
    return ok;
}
