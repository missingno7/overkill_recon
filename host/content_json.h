#ifndef OVERKILL_CONTENT_JSON_H
#define OVERKILL_CONTENT_JSON_H

#include <stddef.h>

typedef enum ContentJsonType {
    CONTENT_JSON_OBJECT,
    CONTENT_JSON_ARRAY,
    CONTENT_JSON_STRING,
    CONTENT_JSON_NUMBER,
    CONTENT_JSON_TRUE,
    CONTENT_JSON_FALSE,
    CONTENT_JSON_NULL
} ContentJsonType;

typedef struct JsonToken {
    ContentJsonType type;
    size_t start;
    size_t end;
    size_t first_child;
    size_t last_child;
    size_t next_sibling;
    size_t child_count;
    size_t string_length;
    char *string_value;
} JsonToken;

/* Initialize documents as {0}. Free a successfully or partially loaded document
   before reusing it. The parser owns text, tokens and decoded string values. */
typedef struct JsonDocument {
    char *text;
    JsonToken *tokens;
    size_t count;
} JsonDocument;

/* Strict, bounded JSON input: at most 1 MiB, 64 levels of nesting and 64K tokens.
   On failure, returns 0, leaves document empty and writes a concise error when
   an error buffer is supplied. */
int content_json_load(const char *path, JsonDocument *document,
                      char *error, size_t error_size);
void content_json_free(JsonDocument *document);

/* Object lookup is direct-member-only and returns -1 when absent or invalid.
   Object size is its property count; array size is its element count. `at` is
   array-only. */
int content_json_member(const JsonDocument *document, int object_index,
                        const char *key);
size_t content_json_size(const JsonDocument *document, int container_index);
int content_json_at(const JsonDocument *document, int array_index, size_t element);

/* Conversion succeeds only for JSON strings and integer-form JSON numbers that
   fit in `long`. String output is UTF-8 and includes a terminating NUL. */
int content_json_integer(const JsonDocument *document, int token_index, long *value);
int content_json_string(const JsonDocument *document, int token_index,
                        char *buffer, size_t buffer_size);

/* Objects compare independent of property order; arrays compare in order.
   Strings compare after JSON escape decoding. Integers compare by value; other
   number spellings must match. */
int content_json_equal(const JsonDocument *left, int left_index,
                       const JsonDocument *right, int right_index);

#endif
