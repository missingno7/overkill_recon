#include "content_json.h"

#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define JSON_MAX_FILE_BYTES (1024u * 1024u)
#define JSON_MAX_TOKENS 65536u
#define JSON_MAX_DEPTH 64u
#define JSON_NO_TOKEN ((size_t)-1)

typedef struct JsonParser {
    JsonDocument *document;
    size_t position;
    size_t length;
    size_t capacity;
    char *error;
    size_t error_size;
} JsonParser;

static void parser_error(JsonParser *parser, const char *format, ...)
{
    va_list args;
    if (!parser->error || parser->error_size == 0 || parser->error[0] != '\0') return;
    va_start(args, format);
    vsnprintf(parser->error, parser->error_size, format, args);
    va_end(args);
}

static int valid_index(const JsonDocument *document, int index)
{
    return document && document->tokens && index >= 0 && (size_t)index < document->count;
}

static void skip_space(JsonParser *parser)
{
    while (parser->position < parser->length) {
        char c = parser->document->text[parser->position];
        if (c != ' ' && c != '\t' && c != '\r' && c != '\n') break;
        parser->position++;
    }
}

static int add_token(JsonParser *parser, ContentJsonType type,
                     size_t start, size_t end, int *index)
{
    JsonDocument *document = parser->document;
    JsonToken *grown;
    size_t capacity;
    size_t i;

    if (document->count >= JSON_MAX_TOKENS) {
        parser_error(parser, "JSON exceeds %u tokens", (unsigned)JSON_MAX_TOKENS);
        return 0;
    }
    if (document->count == parser->capacity) {
        capacity = parser->capacity ? parser->capacity * 2 : 128;
        if (capacity > JSON_MAX_TOKENS) capacity = JSON_MAX_TOKENS;
        grown = (JsonToken *)realloc(document->tokens, capacity * sizeof *grown);
        if (!grown) {
            parser_error(parser, "out of memory parsing JSON tokens");
            return 0;
        }
        document->tokens = grown;
        parser->capacity = capacity;
    }
    i = document->count++;
    document->tokens[i].type = type;
    document->tokens[i].start = start;
    document->tokens[i].end = end;
    document->tokens[i].first_child = JSON_NO_TOKEN;
    document->tokens[i].last_child = JSON_NO_TOKEN;
    document->tokens[i].next_sibling = JSON_NO_TOKEN;
    document->tokens[i].child_count = 0;
    document->tokens[i].string_length = 0;
    document->tokens[i].string_value = NULL;
    *index = (int)i;
    return 1;
}

static void append_child(JsonDocument *document, size_t parent, size_t child)
{
    JsonToken *container = &document->tokens[parent];
    if (container->last_child == JSON_NO_TOKEN) {
        container->first_child = child;
    } else {
        document->tokens[container->last_child].next_sibling = child;
    }
    container->last_child = child;
    container->child_count++;
}

static int hex_digit(unsigned char c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

static int read_hex_quad(JsonParser *parser, unsigned *value)
{
    unsigned result = 0;
    int digit;
    unsigned i;
    for (i = 0; i < 4; i++) {
        if (parser->position >= parser->length ||
            (digit = hex_digit((unsigned char)parser->document->text[parser->position])) < 0) {
            parser_error(parser, "invalid Unicode escape at byte %lu",
                         (unsigned long)parser->position);
            return 0;
        }
        result = (result << 4) | (unsigned)digit;
        parser->position++;
    }
    *value = result;
    return 1;
}

static int utf8_width(const unsigned char *s, size_t remaining, size_t *width)
{
    unsigned char a, b, c, d;
    if (remaining == 0) return 0;
    a = s[0];
    if (a <= 0x7F) { *width = 1; return 1; }
    if (a >= 0xC2 && a <= 0xDF && remaining >= 2) {
        b = s[1];
        if ((b & 0xC0) == 0x80) { *width = 2; return 1; }
        return 0;
    }
    if (a >= 0xE0 && a <= 0xEF && remaining >= 3) {
        b = s[1]; c = s[2];
        if ((c & 0xC0) != 0x80) return 0;
        if (a == 0xE0) { if (b < 0xA0 || b > 0xBF) return 0; }
        else if (a == 0xED) { if (b < 0x80 || b > 0x9F) return 0; }
        else if ((b & 0xC0) != 0x80) return 0;
        *width = 3;
        return 1;
    }
    if (a >= 0xF0 && a <= 0xF4 && remaining >= 4) {
        b = s[1]; c = s[2]; d = s[3];
        if ((c & 0xC0) != 0x80 || (d & 0xC0) != 0x80) return 0;
        if (a == 0xF0) { if (b < 0x90 || b > 0xBF) return 0; }
        else if (a == 0xF4) { if (b < 0x80 || b > 0x8F) return 0; }
        else if ((b & 0xC0) != 0x80) return 0;
        *width = 4;
        return 1;
    }
    return 0;
}

static size_t encode_utf8(unsigned codepoint, char *output)
{
    if (codepoint <= 0x7F) {
        output[0] = (char)codepoint;
        return 1;
    }
    if (codepoint <= 0x7FF) {
        output[0] = (char)(0xC0 | (codepoint >> 6));
        output[1] = (char)(0x80 | (codepoint & 0x3F));
        return 2;
    }
    if (codepoint <= 0xFFFF) {
        output[0] = (char)(0xE0 | (codepoint >> 12));
        output[1] = (char)(0x80 | ((codepoint >> 6) & 0x3F));
        output[2] = (char)(0x80 | (codepoint & 0x3F));
        return 3;
    }
    output[0] = (char)(0xF0 | (codepoint >> 18));
    output[1] = (char)(0x80 | ((codepoint >> 12) & 0x3F));
    output[2] = (char)(0x80 | ((codepoint >> 6) & 0x3F));
    output[3] = (char)(0x80 | (codepoint & 0x3F));
    return 4;
}

static int parse_string_token(JsonParser *parser, int *index)
{
    JsonDocument *document = parser->document;
    size_t quote, start, string_end, scan, output_length = 0;
    char *decoded;
    int token_index;

    if (parser->position >= parser->length || document->text[parser->position] != '"') {
        parser_error(parser, "expected string at byte %lu", (unsigned long)parser->position);
        return 0;
    }
    quote = parser->position++;
    start = parser->position;
    /* Bound each allocation by this string, not by the remaining input. Many
       short strings near the front of a large document must stay linear-space. */
    scan = start;
    while (scan < parser->length) {
        if (document->text[scan] == '"') break;
        if (document->text[scan] == '\\') scan++;
        scan++;
    }
    if (scan == parser->length) {
        parser_error(parser, "unterminated string starting at byte %lu", (unsigned long)quote);
        return 0;
    }
    string_end = scan;
    decoded = (char *)malloc(string_end - start + 1);
    if (!decoded) {
        parser_error(parser, "out of memory decoding JSON string");
        return 0;
    }

    while (parser->position < parser->length) {
        unsigned char c = (unsigned char)document->text[parser->position++];
        if (c == '"') {
            decoded[output_length] = '\0';
            if (!add_token(parser, CONTENT_JSON_STRING, start, parser->position - 1, &token_index)) {
                free(decoded);
                return 0;
            }
            document->tokens[token_index].string_length = output_length;
            document->tokens[token_index].string_value = decoded;
            *index = token_index;
            return 1;
        }
        if (c < 0x20) {
            parser_error(parser, "unescaped control byte in string at byte %lu",
                         (unsigned long)(parser->position - 1));
            free(decoded);
            return 0;
        }
        if (c != '\\') {
            size_t width = 1;
            if (c >= 0x80) {
                parser->position--;
                if (!utf8_width((const unsigned char *)document->text + parser->position,
                                parser->length - parser->position, &width)) {
                    parser_error(parser, "invalid UTF-8 in string at byte %lu",
                                 (unsigned long)parser->position);
                    free(decoded);
                    return 0;
                }
                memcpy(decoded + output_length, document->text + parser->position, width);
                parser->position += width;
                output_length += width;
                continue;
            }
            decoded[output_length++] = (char)c;
            continue;
        }

        if (parser->position >= parser->length) {
            parser_error(parser, "unfinished string escape at byte %lu",
                         (unsigned long)(parser->position - 1));
            free(decoded);
            return 0;
        }
        c = (unsigned char)document->text[parser->position++];
        switch (c) {
        case '"': decoded[output_length++] = '"'; break;
        case '\\': decoded[output_length++] = '\\'; break;
        case '/': decoded[output_length++] = '/'; break;
        case 'b': decoded[output_length++] = '\b'; break;
        case 'f': decoded[output_length++] = '\f'; break;
        case 'n': decoded[output_length++] = '\n'; break;
        case 'r': decoded[output_length++] = '\r'; break;
        case 't': decoded[output_length++] = '\t'; break;
        case 'u': {
            unsigned codepoint, low;
            size_t width;
            if (!read_hex_quad(parser, &codepoint)) { free(decoded); return 0; }
            if (codepoint >= 0xD800 && codepoint <= 0xDBFF) {
                if (parser->length - parser->position < 6 ||
                    document->text[parser->position] != '\\' ||
                    document->text[parser->position + 1] != 'u') {
                    parser_error(parser, "unpaired high surrogate at byte %lu",
                                 (unsigned long)(parser->position - 4));
                    free(decoded);
                    return 0;
                }
                parser->position += 2;
                if (!read_hex_quad(parser, &low)) { free(decoded); return 0; }
                if (low < 0xDC00 || low > 0xDFFF) {
                    parser_error(parser, "invalid low surrogate at byte %lu",
                                 (unsigned long)(parser->position - 4));
                    free(decoded);
                    return 0;
                }
                codepoint = 0x10000 + ((codepoint - 0xD800) << 10) + (low - 0xDC00);
            } else if (codepoint >= 0xDC00 && codepoint <= 0xDFFF) {
                parser_error(parser, "unpaired low surrogate at byte %lu",
                             (unsigned long)(parser->position - 4));
                free(decoded);
                return 0;
            }
            width = encode_utf8(codepoint, decoded + output_length);
            output_length += width;
            break;
        }
        default:
            parser_error(parser, "invalid string escape at byte %lu",
                         (unsigned long)(parser->position - 1));
            free(decoded);
            return 0;
        }
    }

    parser_error(parser, "unterminated string starting at byte %lu", (unsigned long)quote);
    free(decoded);
    return 0;
}

static int parse_number(JsonParser *parser, int *index)
{
    size_t start = parser->position;
    size_t i = start;
    int token_index;
    const char *text = parser->document->text;

    if (i < parser->length && text[i] == '-') i++;
    if (i >= parser->length) goto invalid;
    if (text[i] == '0') {
        i++;
        if (i < parser->length && text[i] >= '0' && text[i] <= '9') goto invalid;
    } else if (text[i] >= '1' && text[i] <= '9') {
        do { i++; } while (i < parser->length && text[i] >= '0' && text[i] <= '9');
    } else goto invalid;
    if (i < parser->length && text[i] == '.') {
        i++;
        if (i >= parser->length || text[i] < '0' || text[i] > '9') goto invalid;
        do { i++; } while (i < parser->length && text[i] >= '0' && text[i] <= '9');
    }
    if (i < parser->length && (text[i] == 'e' || text[i] == 'E')) {
        i++;
        if (i < parser->length && (text[i] == '+' || text[i] == '-')) i++;
        if (i >= parser->length || text[i] < '0' || text[i] > '9') goto invalid;
        do { i++; } while (i < parser->length && text[i] >= '0' && text[i] <= '9');
    }
    parser->position = i;
    if (!add_token(parser, CONTENT_JSON_NUMBER, start, i, &token_index)) return 0;
    *index = token_index;
    return 1;

invalid:
    parser_error(parser, "invalid JSON number at byte %lu", (unsigned long)start);
    return 0;
}

static int parse_literal(JsonParser *parser, const char *literal,
                         ContentJsonType type, int *index)
{
    size_t length = strlen(literal);
    int token_index;
    if (parser->length - parser->position < length ||
        memcmp(parser->document->text + parser->position, literal, length) != 0) {
        parser_error(parser, "invalid JSON value at byte %lu", (unsigned long)parser->position);
        return 0;
    }
    if (!add_token(parser, type, parser->position, parser->position + length, &token_index)) return 0;
    parser->position += length;
    *index = token_index;
    return 1;
}

static int parse_value(JsonParser *parser, size_t depth, int *index);

static int parse_array(JsonParser *parser, size_t depth, int *index)
{
    int array_index, child_index;
    parser->position++;
    if (!add_token(parser, CONTENT_JSON_ARRAY, parser->position - 1, 0, &array_index)) return 0;
    skip_space(parser);
    if (parser->position < parser->length && parser->document->text[parser->position] == ']') {
        parser->document->tokens[array_index].end = ++parser->position;
        *index = array_index;
        return 1;
    }
    for (;;) {
        if (!parse_value(parser, depth + 1, &child_index)) return 0;
        append_child(parser->document, (size_t)array_index, (size_t)child_index);
        skip_space(parser);
        if (parser->position >= parser->length) break;
        if (parser->document->text[parser->position] == ']') {
            parser->document->tokens[array_index].end = ++parser->position;
            *index = array_index;
            return 1;
        }
        if (parser->document->text[parser->position++] != ',') break;
        skip_space(parser);
    }
    parser_error(parser, "expected ',' or ']' at byte %lu", (unsigned long)parser->position);
    return 0;
}

static int parse_object(JsonParser *parser, size_t depth, int *index)
{
    int object_index, key_index, value_index;
    parser->position++;
    if (!add_token(parser, CONTENT_JSON_OBJECT, parser->position - 1, 0, &object_index)) return 0;
    skip_space(parser);
    if (parser->position < parser->length && parser->document->text[parser->position] == '}') {
        parser->document->tokens[object_index].end = ++parser->position;
        *index = object_index;
        return 1;
    }
    for (;;) {
        size_t key;
        if (!parse_string_token(parser, &key_index)) return 0;
        key = (size_t)key_index;
        /* Duplicate keys are rejected before insertion so lookup is unambiguous. */
        {
            size_t existing = parser->document->tokens[object_index].first_child;
            while (existing != JSON_NO_TOKEN) {
                if (parser->document->tokens[existing].string_length ==
                        parser->document->tokens[key].string_length &&
                    memcmp(parser->document->tokens[existing].string_value,
                           parser->document->tokens[key].string_value,
                           parser->document->tokens[key].string_length) == 0) {
                    parser_error(parser, "duplicate object key near byte %lu",
                                 (unsigned long)parser->position);
                    return 0;
                }
                existing = parser->document->tokens[existing].next_sibling;
                if (existing != JSON_NO_TOKEN)
                    existing = parser->document->tokens[existing].next_sibling;
            }
        }
        append_child(parser->document, (size_t)object_index, key);
        skip_space(parser);
        if (parser->position >= parser->length || parser->document->text[parser->position++] != ':') {
            parser_error(parser, "expected ':' after object key at byte %lu",
                         (unsigned long)parser->position);
            return 0;
        }
        skip_space(parser);
        if (!parse_value(parser, depth + 1, &value_index)) return 0;
        append_child(parser->document, (size_t)object_index, (size_t)value_index);
        skip_space(parser);
        if (parser->position >= parser->length) break;
        if (parser->document->text[parser->position] == '}') {
            parser->document->tokens[object_index].end = ++parser->position;
            *index = object_index;
            return 1;
        }
        if (parser->document->text[parser->position++] != ',') break;
        skip_space(parser);
    }
    parser_error(parser, "expected ',' or '}' at byte %lu", (unsigned long)parser->position);
    return 0;
}

static int parse_value(JsonParser *parser, size_t depth, int *index)
{
    char c;
    skip_space(parser);
    if (parser->position >= parser->length) {
        parser_error(parser, "expected JSON value at end of input");
        return 0;
    }
    c = parser->document->text[parser->position];
    if (depth >= JSON_MAX_DEPTH && (c == '{' || c == '[')) {
        parser_error(parser, "JSON nesting depth reaches %u", (unsigned)JSON_MAX_DEPTH);
        return 0;
    }
    if (c == '{') return parse_object(parser, depth, index);
    if (c == '[') return parse_array(parser, depth, index);
    if (c == '"') return parse_string_token(parser, index);
    if (c == 't') return parse_literal(parser, "true", CONTENT_JSON_TRUE, index);
    if (c == 'f') return parse_literal(parser, "false", CONTENT_JSON_FALSE, index);
    if (c == 'n') return parse_literal(parser, "null", CONTENT_JSON_NULL, index);
    if (c == '-' || (c >= '0' && c <= '9')) return parse_number(parser, index);
    parser_error(parser, "invalid JSON value at byte %lu", (unsigned long)parser->position);
    return 0;
}

void content_json_free(JsonDocument *document)
{
    size_t i;
    if (!document) return;
    for (i = 0; i < document->count; i++) free(document->tokens[i].string_value);
    free(document->tokens);
    free(document->text);
    document->text = NULL;
    document->tokens = NULL;
    document->count = 0;
}

int content_json_load(const char *path, JsonDocument *document,
                      char *error, size_t error_size)
{
    FILE *file;
    size_t length;
    JsonParser parser;
    int root_index;
    if (error && error_size) error[0] = '\0';
    if (!path || !document) {
        if (error && error_size) snprintf(error, error_size, "invalid JSON load arguments");
        return 0;
    }
    document->text = NULL;
    document->tokens = NULL;
    document->count = 0;
    file = fopen(path, "rb");
    if (!file) {
        if (error && error_size) snprintf(error, error_size, "cannot open JSON file '%s'", path);
        return 0;
    }
    document->text = (char *)malloc(JSON_MAX_FILE_BYTES + 1u);
    if (!document->text) {
        fclose(file);
        if (error && error_size) snprintf(error, error_size, "out of memory reading JSON file");
        return 0;
    }
    length = fread(document->text, 1, JSON_MAX_FILE_BYTES + 1u, file);
    if (ferror(file)) {
        fclose(file);
        if (error && error_size) snprintf(error, error_size, "error reading JSON file '%s'", path);
        content_json_free(document);
        return 0;
    }
    if (length > JSON_MAX_FILE_BYTES) {
        fclose(file);
        if (error && error_size) snprintf(error, error_size, "JSON file exceeds 1 MiB");
        content_json_free(document);
        return 0;
    }
    if (fclose(file) != 0) {
        if (error && error_size) snprintf(error, error_size, "error closing JSON file '%s'", path);
        content_json_free(document);
        return 0;
    }
    document->text[length] = '\0';
    memset(&parser, 0, sizeof parser);
    parser.document = document;
    parser.length = length;
    parser.error = error;
    parser.error_size = error_size;
    if (!parse_value(&parser, 0, &root_index)) goto failed;
    skip_space(&parser);
    if (parser.position != parser.length) {
        parser_error(&parser, "trailing content at byte %lu", (unsigned long)parser.position);
        goto failed;
    }
    return 1;

failed:
    content_json_free(document);
    return 0;
}

int content_json_member(const JsonDocument *document, int object_index,
                        const char *key)
{
    size_t cursor;
    if (!key || !valid_index(document, object_index) ||
        document->tokens[object_index].type != CONTENT_JSON_OBJECT) return -1;
    cursor = document->tokens[object_index].first_child;
    while (cursor != JSON_NO_TOKEN) {
        size_t value = document->tokens[cursor].next_sibling;
        if (value == JSON_NO_TOKEN) return -1;
        if (document->tokens[cursor].string_length == strlen(key) &&
            memcmp(document->tokens[cursor].string_value, key,
                   document->tokens[cursor].string_length) == 0)
            return value <= INT_MAX ? (int)value : -1;
        cursor = document->tokens[value].next_sibling;
    }
    return -1;
}

size_t content_json_size(const JsonDocument *document, int container_index)
{
    const JsonToken *token;
    if (!valid_index(document, container_index)) return 0;
    token = &document->tokens[container_index];
    if (token->type == CONTENT_JSON_ARRAY) return token->child_count;
    if (token->type == CONTENT_JSON_OBJECT) return token->child_count / 2;
    return 0;
}

int content_json_at(const JsonDocument *document, int array_index, size_t element)
{
    size_t cursor, i;
    if (!valid_index(document, array_index) ||
        document->tokens[array_index].type != CONTENT_JSON_ARRAY) return -1;
    cursor = document->tokens[array_index].first_child;
    for (i = 0; i < element && cursor != JSON_NO_TOKEN; i++)
        cursor = document->tokens[cursor].next_sibling;
    return cursor != JSON_NO_TOKEN && cursor <= INT_MAX ? (int)cursor : -1;
}

int content_json_integer(const JsonDocument *document, int token_index, long *value)
{
    const JsonToken *token;
    const char *text;
    size_t position, length;
    unsigned long magnitude = 0, limit;
    int negative = 0;
    if (!value || !valid_index(document, token_index)) return 0;
    token = &document->tokens[token_index];
    if (token->type != CONTENT_JSON_NUMBER) return 0;
    text = document->text + token->start;
    length = token->end - token->start;
    position = 0;
    if (position < length && text[position] == '-') { negative = 1; position++; }
    if (position == length) return 0;
    limit = negative ? (unsigned long)LONG_MAX + 1ul : (unsigned long)LONG_MAX;
    for (; position < length; position++) {
        unsigned digit;
        if (text[position] < '0' || text[position] > '9') return 0;
        digit = (unsigned)(text[position] - '0');
        if (magnitude > (limit - digit) / 10ul) return 0;
        magnitude = magnitude * 10ul + digit;
    }
    if (negative) {
        if (magnitude == (unsigned long)LONG_MAX + 1ul) *value = LONG_MIN;
        else *value = -(long)magnitude;
    } else *value = (long)magnitude;
    return 1;
}

int content_json_string(const JsonDocument *document, int token_index,
                        char *buffer, size_t buffer_size)
{
    const char *value;
    size_t length;
    if (!buffer || buffer_size == 0 || !valid_index(document, token_index) ||
        document->tokens[token_index].type != CONTENT_JSON_STRING) return 0;
    value = document->tokens[token_index].string_value;
    length = document->tokens[token_index].string_length;
    if (memchr(value, '\0', length) != NULL) return 0;
    if (length >= buffer_size) return 0;
    memcpy(buffer, value, length + 1);
    return 1;
}

static int equal_tokens(const JsonDocument *left, size_t a,
                        const JsonDocument *right, size_t b, size_t depth)
{
    const JsonToken *x = &left->tokens[a];
    const JsonToken *y = &right->tokens[b];
    size_t i, j;
    if (x->type != y->type ||
        (depth >= JSON_MAX_DEPTH &&
         (x->type == CONTENT_JSON_OBJECT || x->type == CONTENT_JSON_ARRAY))) return 0;
    switch (x->type) {
    case CONTENT_JSON_OBJECT:
        if (x->child_count != y->child_count) return 0;
        i = x->first_child;
        while (i != JSON_NO_TOKEN) {
            size_t value = left->tokens[i].next_sibling;
            size_t other_value;
            if (value == JSON_NO_TOKEN) return 0;
            other_value = right->tokens[b].first_child;
            while (other_value != JSON_NO_TOKEN) {
                size_t candidate = right->tokens[other_value].next_sibling;
                if (candidate == JSON_NO_TOKEN) return 0;
                if (left->tokens[i].string_length == right->tokens[other_value].string_length &&
                    memcmp(left->tokens[i].string_value, right->tokens[other_value].string_value,
                           left->tokens[i].string_length) == 0) break;
                other_value = right->tokens[candidate].next_sibling;
            }
            if (other_value == JSON_NO_TOKEN ||
                !equal_tokens(left, value, right, (size_t)right->tokens[other_value].next_sibling,
                              depth + 1)) return 0;
            i = left->tokens[value].next_sibling;
        }
        return 1;
    case CONTENT_JSON_ARRAY:
        if (x->child_count != y->child_count) return 0;
        i = x->first_child;
        j = y->first_child;
        while (i != JSON_NO_TOKEN && j != JSON_NO_TOKEN) {
            if (!equal_tokens(left, i, right, j, depth + 1)) return 0;
            i = left->tokens[i].next_sibling;
            j = right->tokens[j].next_sibling;
        }
        return i == JSON_NO_TOKEN && j == JSON_NO_TOKEN;
    case CONTENT_JSON_STRING:
        return x->string_length == y->string_length &&
            memcmp(x->string_value, y->string_value, x->string_length) == 0;
    case CONTENT_JSON_NUMBER: {
        long first, second;
        if (content_json_integer(left, (int)a, &first) &&
            content_json_integer(right, (int)b, &second)) return first == second;
        return x->end - x->start == y->end - y->start &&
            memcmp(left->text + x->start, right->text + y->start, x->end - x->start) == 0;
    }
    case CONTENT_JSON_TRUE:
    case CONTENT_JSON_FALSE:
    case CONTENT_JSON_NULL:
        return 1;
    }
    return 0;
}

int content_json_equal(const JsonDocument *left, int left_index,
                       const JsonDocument *right, int right_index)
{
    if (!valid_index(left, left_index) || !valid_index(right, right_index)) return 0;
    return equal_tokens(left, (size_t)left_index, right, (size_t)right_index, 0);
}
