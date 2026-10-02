/* SDL event queue probe used by tests/host/input.py.
   SDL's own headers define every event structure and scancode value; Python only
   asks these helpers to construct and enqueue events. */
#include <SDL3/SDL.h>

enum HostKey {
    HOST_KEY_W = 1,
    HOST_KEY_B,
    HOST_KEY_C,
    HOST_KEY_LEFT_ALT,
    HOST_KEY_X,
    HOST_KEY_KEYPAD8,
    HOST_KEY_F13
};

int host_sdl_init_events(void)
{
    return SDL_Init(SDL_INIT_EVENTS) ? 1 : 0;
}

void host_sdl_quit(void)
{
    SDL_Quit();
}

void host_sdl_flush(void)
{
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
    }
}

static SDL_Scancode host_scancode(int key)
{
    switch (key) {
    case HOST_KEY_W: return SDL_SCANCODE_W;
    case HOST_KEY_B: return SDL_SCANCODE_B;
    case HOST_KEY_C: return SDL_SCANCODE_C;
    case HOST_KEY_LEFT_ALT: return SDL_SCANCODE_LALT;
    case HOST_KEY_X: return SDL_SCANCODE_X;
    case HOST_KEY_KEYPAD8: return SDL_SCANCODE_KP_8;
    case HOST_KEY_F13: return SDL_SCANCODE_F13;
    default: return SDL_SCANCODE_UNKNOWN;
    }
}

int host_sdl_key_w(void) { return HOST_KEY_W; }
int host_sdl_key_b(void) { return HOST_KEY_B; }
int host_sdl_key_c(void) { return HOST_KEY_C; }
int host_sdl_key_left_alt(void) { return HOST_KEY_LEFT_ALT; }
int host_sdl_key_x(void) { return HOST_KEY_X; }
int host_sdl_key_keypad8(void) { return HOST_KEY_KEYPAD8; }
int host_sdl_key_f13(void) { return HOST_KEY_F13; }

int host_sdl_push_key(int key, int down, int repeat)
{
    SDL_Event event;
    SDL_zero(event);
    event.type = down ? SDL_EVENT_KEY_DOWN : SDL_EVENT_KEY_UP;
    event.key.type = event.type;
    event.key.scancode = host_scancode(key);
    event.key.down = down ? true : false;
    event.key.repeat = repeat ? true : false;
    return SDL_PushEvent(&event) ? 1 : 0;
}

int host_sdl_push_focus_lost(void)
{
    SDL_Event event;
    SDL_zero(event);
    event.type = SDL_EVENT_WINDOW_FOCUS_LOST;
    event.window.type = event.type;
    return SDL_PushEvent(&event) ? 1 : 0;
}

int host_sdl_push_quit(void)
{
    SDL_Event event;
    SDL_zero(event);
    event.type = SDL_EVENT_QUIT;
    return SDL_PushEvent(&event) ? 1 : 0;
}
