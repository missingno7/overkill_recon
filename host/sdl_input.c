#include "sdl_input.h"

#include "game.h"
#include "input_normalize.h"

static uint8_t character_queue[128];
static unsigned character_read, character_write;
static int character_mode;

void overkill_sdl_character_mode(int enabled)
{
    character_mode = enabled != 0;
}

void overkill_sdl_flush_characters(void)
{
    character_read = character_write = 0;
}

int overkill_sdl_read_character(void)
{
    if (character_read == character_write) return -1;
    return character_queue[character_read++ & 127];
}

static void queue_character(uint8_t character)
{
    /* The platform BIOS buffer also refuses new keys when it is full. */
    if (character_write - character_read < 128)
        character_queue[character_write++ & 127] = character;
}

static void queue_key_character(const SDL_KeyboardEvent *key, int scan)
{
    SDL_Keycode symbol = key->key;
    int shift = (key->mod & SDL_KMOD_SHIFT) != 0;
    int caps = (key->mod & SDL_KMOD_CAPS) != 0;
    if (!character_mode) return;
    if (scan == 0x1d || scan == 0x2a || scan == 0x36 || scan == 0x38 ||
        scan == 0x3a || scan == 0x45 || scan == 0x46) return;
    if ((key->mod & SDL_KMOD_ALT) != 0) {
        queue_character(0);
        queue_character((uint8_t)scan);
        return;
    }
    /* SDL keypad symbols are outside ASCII. BIOS character input supplies
       arithmetic keys directly and toggles keypad digits with Num Lock/Shift. */
    switch (key->scancode) {
    case SDL_SCANCODE_KP_ENTER: queue_character(13); return;
    case SDL_SCANCODE_KP_MULTIPLY: queue_character('*'); return;
    case SDL_SCANCODE_KP_DIVIDE: queue_character('/'); return;
    case SDL_SCANCODE_KP_MINUS: queue_character('-'); return;
    case SDL_SCANCODE_KP_PLUS: queue_character('+'); return;
    default: break;
    }
    if (((key->mod & SDL_KMOD_NUM) != 0) != shift) {
        if (key->scancode >= SDL_SCANCODE_KP_1 &&
            key->scancode <= SDL_SCANCODE_KP_9) {
            queue_character((uint8_t)('1' + key->scancode - SDL_SCANCODE_KP_1));
            return;
        }
        if (key->scancode == SDL_SCANCODE_KP_0) {
            queue_character('0');
            return;
        }
        if (key->scancode == SDL_SCANCODE_KP_PERIOD ||
            key->scancode == SDL_SCANCODE_KP_COMMA) {
            queue_character(key->scancode == SDL_SCANCODE_KP_PERIOD ? '.' : ',');
            return;
        }
    }
    if (symbol >= 'a' && symbol <= 'z') {
        if ((key->mod & SDL_KMOD_CTRL) != 0) symbol -= 'a' - 1;
        else if (shift != caps) symbol -= 'a' - 'A';
    } else if (shift && symbol < 128) {
        const char *normal = "1234567890-=[]\\;',./`";
        const char *shifted = "!@#$%^&*()_+{}|:\"<>?~";
        unsigned i;
        for (i = 0; normal[i]; ++i)
            if (symbol == (SDL_Keycode)(unsigned char)normal[i]) {
                symbol = (SDL_Keycode)(unsigned char)shifted[i];
                break;
            }
    }
    if (symbol > 0 && symbol < 128) queue_character((uint8_t)symbol);
    else if (scan != 0) {
        queue_character(0);
        queue_character((uint8_t)scan);
    }
}

/* Convert SDL's physical PC-keyboard positions to the set-1 make code used by
   KeyDownTable. Codes that do not have a single set-1 key slot are ignored. */
static int pc_set1_code(SDL_Scancode scancode)
{
    switch (scancode) {
    case SDL_SCANCODE_ESCAPE: return SCAN_ESC;
    case SDL_SCANCODE_1: return 0x02;
    case SDL_SCANCODE_2: return 0x03;
    case SDL_SCANCODE_3: return SCAN_3;
    case SDL_SCANCODE_4: return 0x05;
    case SDL_SCANCODE_5: return 0x06;
    case SDL_SCANCODE_6: return 0x07;
    case SDL_SCANCODE_7: return 0x08;
    case SDL_SCANCODE_8: return 0x09;
    case SDL_SCANCODE_9: return 0x0a;
    case SDL_SCANCODE_0: return 0x0b;
    case SDL_SCANCODE_MINUS: return 0x0c;
    case SDL_SCANCODE_EQUALS: return 0x0d;
    case SDL_SCANCODE_BACKSPACE: return SCAN_BACKSPACE;
    case SDL_SCANCODE_TAB: return SCAN_TAB;
    case SDL_SCANCODE_Q: return SCAN_Q;
    case SDL_SCANCODE_W: return SCAN_W;
    case SDL_SCANCODE_E: return SCAN_E;
    case SDL_SCANCODE_R: return SCAN_R;
    case SDL_SCANCODE_T: return SCAN_T;
    case SDL_SCANCODE_Y: return SCAN_Y;
    case SDL_SCANCODE_U: return SCAN_U;
    case SDL_SCANCODE_I: return SCAN_I;
    case SDL_SCANCODE_O: return SCAN_O;
    case SDL_SCANCODE_P: return SCAN_P;
    case SDL_SCANCODE_LEFTBRACKET: return 0x1a;
    case SDL_SCANCODE_RIGHTBRACKET: return 0x1b;
    case SDL_SCANCODE_RETURN: return SCAN_ENTER;
    case SDL_SCANCODE_LCTRL:
    case SDL_SCANCODE_RCTRL: return 0x1d;
    case SDL_SCANCODE_A: return SCAN_A;
    case SDL_SCANCODE_S: return SCAN_S;
    case SDL_SCANCODE_D: return SCAN_D;
    case SDL_SCANCODE_F: return SCAN_F;
    case SDL_SCANCODE_G: return SCAN_G;
    case SDL_SCANCODE_H: return SCAN_H;
    case SDL_SCANCODE_J: return SCAN_J;
    case SDL_SCANCODE_K: return SCAN_K;
    case SDL_SCANCODE_L: return SCAN_L;
    case SDL_SCANCODE_SEMICOLON: return 0x27;
    case SDL_SCANCODE_APOSTROPHE: return 0x28;
    case SDL_SCANCODE_GRAVE: return 0x29;
    case SDL_SCANCODE_LSHIFT: return 0x2a;
    case SDL_SCANCODE_BACKSLASH:
    case SDL_SCANCODE_NONUSHASH: return 0x2b;
    case SDL_SCANCODE_Z: return SCAN_Z;
    case SDL_SCANCODE_X: return SCAN_X;
    case SDL_SCANCODE_C: return SCAN_C;
    case SDL_SCANCODE_V: return SCAN_V;
    case SDL_SCANCODE_B: return SCAN_B;
    case SDL_SCANCODE_N: return SCAN_N;
    case SDL_SCANCODE_M: return SCAN_M;
    case SDL_SCANCODE_COMMA: return 0x33;
    case SDL_SCANCODE_PERIOD: return 0x34;
    case SDL_SCANCODE_SLASH: return 0x35;
    case SDL_SCANCODE_RSHIFT: return 0x36;
    case SDL_SCANCODE_KP_MULTIPLY: return 0x37;
    case SDL_SCANCODE_LALT:
    case SDL_SCANCODE_RALT: return SCAN_ALT;
    case SDL_SCANCODE_SPACE: return SCAN_SPACE;
    case SDL_SCANCODE_CAPSLOCK: return 0x3a;
    case SDL_SCANCODE_F1: return 0x3b;
    case SDL_SCANCODE_F2: return 0x3c;
    case SDL_SCANCODE_F3: return 0x3d;
    case SDL_SCANCODE_F4: return SCAN_F4;
    case SDL_SCANCODE_F5: return 0x3f;
    case SDL_SCANCODE_F6: return 0x40;
    case SDL_SCANCODE_F7: return 0x41;
    case SDL_SCANCODE_F8: return 0x42;
    case SDL_SCANCODE_F9: return SCAN_F9;
    case SDL_SCANCODE_F10: return SCAN_F10;
    case SDL_SCANCODE_NUMLOCKCLEAR: return 0x45;
    case SDL_SCANCODE_SCROLLLOCK: return 0x46;
    case SDL_SCANCODE_HOME: return SCAN_HOME;
    case SDL_SCANCODE_UP: return SCAN_UP;
    case SDL_SCANCODE_PAGEUP: return SCAN_PGUP;
    case SDL_SCANCODE_LEFT: return SCAN_LEFT;
    case SDL_SCANCODE_RIGHT: return SCAN_RIGHT;
    case SDL_SCANCODE_END: return SCAN_END;
    case SDL_SCANCODE_DOWN: return SCAN_DOWN;
    case SDL_SCANCODE_PAGEDOWN: return SCAN_PGDN;
    case SDL_SCANCODE_INSERT: return 0x52;
    case SDL_SCANCODE_DELETE: return 0x53;
    case SDL_SCANCODE_F11: return 0x57;
    case SDL_SCANCODE_F12: return 0x58;
    case SDL_SCANCODE_NONUSBACKSLASH: return 0x56;
    case SDL_SCANCODE_PRINTSCREEN: return 0x37;

    /* Enhanced-keyboard navigation positions share the original numeric
       keypad slots. Aliases intentionally address the same held-key bytes. */
    case SDL_SCANCODE_KP_7: return SCAN_HOME;
    case SDL_SCANCODE_KP_8: return SCAN_UP;
    case SDL_SCANCODE_KP_9: return SCAN_PGUP;
    case SDL_SCANCODE_KP_4: return SCAN_LEFT;
    case SDL_SCANCODE_KP_5: return 0x4c;
    case SDL_SCANCODE_KP_6: return SCAN_RIGHT;
    case SDL_SCANCODE_KP_1: return SCAN_END;
    case SDL_SCANCODE_KP_2: return SCAN_DOWN;
    case SDL_SCANCODE_KP_3: return SCAN_PGDN;
    case SDL_SCANCODE_KP_0: return 0x52;
    case SDL_SCANCODE_KP_PERIOD:
    case SDL_SCANCODE_KP_COMMA: return 0x53;
    case SDL_SCANCODE_KP_DIVIDE: return 0x35;
    case SDL_SCANCODE_KP_ENTER: return SCAN_ENTER;
    case SDL_SCANCODE_KP_MINUS: return 0x4a;
    case SDL_SCANCODE_KP_PLUS: return 0x4e;

    default: return 0;
    }
}

int overkill_sdl_apply_event(const SDL_Event *event)
{
    volatile byte *keys;
    int scan;

    if (event == 0) return 0;

    switch (event->type) {
    case SDL_EVENT_QUIT:
        return 1;

    case SDL_EVENT_WINDOW_FOCUS_LOST:
        /* SDL may not deliver key-up events while the window lacks focus. */
        clear_key_down_table();
        return 0;

    case SDL_EVENT_KEY_DOWN:
        scan = pc_set1_code(event->key.scancode);
        if (scan == 0) return 0;
        keys = (volatile byte *)KeyDownTable;
        ((volatile byte *)&KeyLastMakeCode)[0] = (byte)scan;
        keys[scan] = KEY_STATE_DOWN;
        queue_key_character(&event->key, scan);
        /* IRQ1 exits immediately on the X make when the shared Alt slot is set.
           Repeated SDL key-downs still perform the same make-code update. */
        if (scan == SCAN_X && keys[SCAN_ALT] == KEY_STATE_DOWN) return 1;
        return 0;

    case SDL_EVENT_KEY_UP:
        scan = pc_set1_code(event->key.scancode);
        if (scan == 0) return 0;
        keys = (volatile byte *)KeyDownTable;
        keys[scan] = KEY_STATE_UP;
        return 0;

    default:
        return 0;
    }
}

int overkill_sdl_pump_input(void)
{
    SDL_Event event;

    while (SDL_PollEvent(&event)) {
        if (overkill_sdl_apply_event(&event)) return 1;
    }
    return 0;
}
