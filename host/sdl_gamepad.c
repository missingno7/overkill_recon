#include "sdl_gamepad.h"

#include <SDL3/SDL.h>

#include <stdlib.h>

#include "game.h"

#define GAMEPORT_MAX_COUNT 0x3CB0u

static SDL_Gamepad *active_gamepad;
static int owns_gamepad_subsystem;
static int cleanup_registered;

/* The DOS timer loop stops after 0x10000 - 0xC350 reads (15536), so preserve
   that unsigned sample domain. Calibration and the game's strict threshold
   tests then continue to operate on counts in their original range. */
static uint16_t gameport_axis_count(Sint16 axis)
{
    uint32_t normalized = (uint32_t)((int32_t)axis + 32768);
    return (uint16_t)((normalized * GAMEPORT_MAX_COUNT + 0x8000u) >> 16);
}

static int ensure_gamepad_subsystem(void)
{
    if ((SDL_WasInit(SDL_INIT_GAMEPAD) & SDL_INIT_GAMEPAD) == 0) {
        if (!SDL_InitSubSystem(SDL_INIT_GAMEPAD)) return 0;
        owns_gamepad_subsystem = 1;
    }
    if (!cleanup_registered) {
        if (atexit(actual_sdl_gamepad_close) == 0) cleanup_registered = 1;
    }
    return 1;
}

static void open_first_gamepad(void)
{
    SDL_JoystickID *gamepad_ids;
    int count = 0;
    int i;

    gamepad_ids = SDL_GetGamepads(&count);
    if (gamepad_ids == NULL) return;
    for (i = 0; i < count; ++i) {
        if (!SDL_IsGamepad(gamepad_ids[i])) continue;
        active_gamepad = SDL_OpenGamepad(gamepad_ids[i]);
        if (active_gamepad != NULL) break;
    }
    SDL_free(gamepad_ids);
}

void actual_sdl_gamepad_close(void)
{
    if (active_gamepad != NULL) {
        SDL_CloseGamepad(active_gamepad);
        active_gamepad = NULL;
    }
    if (owns_gamepad_subsystem) {
        SDL_QuitSubSystem(SDL_INIT_GAMEPAD);
        owns_gamepad_subsystem = 0;
    }
}

int actual_sdl_gamepad_poll(uint16_t *x_count, uint16_t *y_count,
                            uint8_t *button_bits)
{
    uint16_t x = 0;
    uint16_t y = 0;
    uint8_t buttons = 0xFF;

    if (x_count != NULL) *x_count = x;
    if (y_count != NULL) *y_count = y;
    if (button_bits != NULL) *button_bits = buttons;
    if (!ensure_gamepad_subsystem()) return 0;

    /* Pump device notifications without consuming the keyboard events owned by
       sdl_input.c. If the selected pad was removed, close it and enumerate a
       replacement before sampling. With no pad, enumerate again next poll so
       later hot-plugging is picked up. */
    SDL_PumpEvents();
    if (active_gamepad != NULL && !SDL_GamepadConnected(active_gamepad)) {
        SDL_CloseGamepad(active_gamepad);
        active_gamepad = NULL;
    }
    if (active_gamepad == NULL) open_first_gamepad();
    if (active_gamepad == NULL) return 0;

    x = gameport_axis_count(SDL_GetGamepadAxis(active_gamepad,
                                                SDL_GAMEPAD_AXIS_LEFTX));
    y = gameport_axis_count(SDL_GetGamepadAxis(active_gamepad,
                                                SDL_GAMEPAD_AXIS_LEFTY));
    if (SDL_GetGamepadButton(active_gamepad, SDL_GAMEPAD_BUTTON_SOUTH))
        buttons = (uint8_t)(buttons & (uint8_t)~GAME_PORT_A_BUTTON1);
    if (SDL_GetGamepadButton(active_gamepad, SDL_GAMEPAD_BUTTON_EAST))
        buttons = (uint8_t)(buttons & (uint8_t)~GAME_PORT_A_BUTTON2);

    if (!SDL_GamepadConnected(active_gamepad)) {
        SDL_CloseGamepad(active_gamepad);
        active_gamepad = NULL;
        x = 0;
        y = 0;
        buttons = 0xFF;
        if (x_count != NULL) *x_count = x;
        if (y_count != NULL) *y_count = y;
        if (button_bits != NULL) *button_bits = buttons;
        return 0;
    }

    if (x_count != NULL) *x_count = x;
    if (y_count != NULL) *y_count = y;
    if (button_bits != NULL) *button_bits = buttons;
    return 1;
}
