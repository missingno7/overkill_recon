#ifndef _WIN32
#define _POSIX_C_SOURCE 200809L
#endif
#include "game.h"
#include "launcher.h"
#include "shutdown.h"
#include "render.h"
#include "sound.h"
#include "memory.h"
#include "resource_services.h"
#include "file_services.h"
#include "platform_services.h"
#include "clock_services.h"
#include "video_services.h"
#include "presentation_services.h"
#include "sdl_input.h"
#include "sdl_video.h"
#include "sdl_gamepad.h"
#include "sound_services.h"
#include "adlib_sequence.h"
#include "roland_sequence.h"
#include <SDL3/SDL.h>
#include <inttypes.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif

typedef struct InputEvent {
    uint64_t time_ns;
    SDL_Scancode scan;
    int pressed;
} InputEvent;

static jmp_buf return_to_host;
static uint8_t *arena;
static InputEvent *script;
static size_t script_count, script_cursor;
static SDL_Keymod script_modifiers;
static FILE *trace;
static const char *screenshot_path;
static int headless, exit_status;
static uint64_t origin_ns, now_ns, next_present_ns, limit_ns;
static uint64_t pcm_hash = UINT64_C(14695981039346656037), pcm_frames;
static uint64_t midi_hash = UINT64_C(14695981039346656037), midi_bytes;

static int midi_sink(void *userdata, uint8_t value)
{
    (void)userdata;
    midi_hash = (midi_hash ^ value) * UINT64_C(1099511628211);
    ++midi_bytes;
    return 1;
}

static void terminate_game(int status)
{
    exit_status = status;
    longjmp(return_to_host, 1);
}

static void module_tick(void)
{
    if (SoundModuleNamePtr == GAME_OFFSET(SoundModuleNameAdlib)) adlib_sequence_tick();
    else if (SoundModuleNamePtr == GAME_OFFSET(SoundModuleNameRoland)) roland_sequence_tick();
    else {
        fprintf(stderr, "Unsupported loaded music module at DS:%04X\n", SoundModuleNamePtr);
        terminate_game(1);
    }
}

static void trace_service(word token, const HostRegisters *registers)
{
    if (trace) fprintf(trace, "service,%" PRIu64 ",%04X,%04X,%04X,%04X,%04X\n",
                       now_ns, token, registers->bp, registers->es, MapScrollPos, LevelIndex);
}

static void pcm_sink(void *userdata, const float *samples, size_t frames)
{
    size_t i;
    (void)userdata;
    /* This quantized observation never feeds back into game or sequencer state. */
    for (i = 0; i < frames * 2; ++i) {
        float sample = samples[i];
        int16_t value;
        if (sample > 1.0f) sample = 1.0f;
        if (sample < -1.0f) sample = -1.0f;
        value = (int16_t)(sample * 32767.0f);
        pcm_hash = (pcm_hash ^ (uint8_t)value) * UINT64_C(1099511628211);
        pcm_hash = (pcm_hash ^ (uint8_t)((uint16_t)value >> 8)) * UINT64_C(1099511628211);
    }
    pcm_frames += frames;
}

static void idle_game(void)
{
    now_ns = headless ? now_ns + UINT64_C(1000000) : SDL_GetTicksNS() - origin_ns;
    while (script_cursor < script_count && script[script_cursor].time_ns <= now_ns) {
        const InputEvent *input = &script[script_cursor++];
        SDL_Event event = {0};
        event.type = input->pressed ? SDL_EVENT_KEY_DOWN : SDL_EVENT_KEY_UP;
        event.key.scancode = input->scan;
        {
            SDL_Keymod modifier = SDL_KMOD_NONE;
            switch (input->scan) {
            case SDL_SCANCODE_LSHIFT: modifier = SDL_KMOD_LSHIFT; break;
            case SDL_SCANCODE_RSHIFT: modifier = SDL_KMOD_RSHIFT; break;
            case SDL_SCANCODE_LCTRL: modifier = SDL_KMOD_LCTRL; break;
            case SDL_SCANCODE_RCTRL: modifier = SDL_KMOD_RCTRL; break;
            case SDL_SCANCODE_LALT: modifier = SDL_KMOD_LALT; break;
            case SDL_SCANCODE_RALT: modifier = SDL_KMOD_RALT; break;
            case SDL_SCANCODE_CAPSLOCK:
                if (input->pressed) script_modifiers ^= SDL_KMOD_CAPS;
                break;
            case SDL_SCANCODE_NUMLOCKCLEAR:
                if (input->pressed) script_modifiers ^= SDL_KMOD_NUM;
                break;
            default: break;
            }
            if (input->pressed) script_modifiers |= modifier;
            else script_modifiers &= ~modifier;
            event.key.mod = script_modifiers;
        }
        event.key.key = SDL_GetKeyFromScancode(input->scan, SDL_KMOD_NONE, false);
        event.key.down = input->pressed != 0;
        if (overkill_sdl_apply_event(&event)) {
            DosRegisters registers = {0};
            shutdown_game(&registers);
            terminate_game(0);
        }
    }
    if (overkill_sdl_pump_input()) {
        DosRegisters registers = {0};
        shutdown_game(&registers);
        terminate_game(0);
    }
    actual_sdl_gamepad_poll(NULL, NULL, NULL);
    overkill_clock_advance(now_ns);
    if (headless) sound_services_advance_ns(now_ns);
    if (limit_ns && now_ns >= limit_ns) terminate_game(0);
    if (now_ns >= next_present_ns) {
        word row, column;
        presentation_text_get_cursor(&row, &column);
        overkill_sdl_video_text_cursor(row, column, presentation_text_cursor_visible());
        int presented = presentation_text_mode_active()
            ? overkill_sdl_video_present_text(presentation_text_segment(), (now_ns / UINT64_C(266666667) & 1) == 0)
            : overkill_sdl_video_present(VideoAdapter, overkill_video_presented_segment());
        if (!presented && TextInGraphics != 0) {
            fprintf(stderr, "SDL present: %s\n", SDL_GetError());
            terminate_game(1);
        }
        next_present_ns = now_ns + UINT64_C(16666667);
    }
    if (!headless) SDL_Delay(1);
}

static int read_script(const char *path)
{
    FILE *file = fopen(path, "r");
    char line[256];
    if (!file) return 0;
    while (fgets(line, sizeof line, file)) {
        unsigned long long ms;
        int scan, pressed;
        char extra;
        InputEvent *grown;
        if (line[0] == '#' || line[0] == '\n' || line[0] == '\r') continue;
        if (sscanf(line, "%llu %d %d %c", &ms, &scan, &pressed, &extra) != 3 ||
            scan <= SDL_SCANCODE_UNKNOWN || scan >= SDL_SCANCODE_COUNT ||
            (pressed != 0 && pressed != 1) || ms > UINT64_MAX / UINT64_C(1000000) ||
            (script_count && ms * UINT64_C(1000000) < script[script_count - 1].time_ns)) {
            fclose(file);
            return 0;
        }
        grown = realloc(script, (script_count + 1) * sizeof *script);
        if (!grown) { fclose(file); return 0; }
        script = grown;
        script[script_count++] = (InputEvent){ms * UINT64_C(1000000), (SDL_Scancode)scan, pressed};
    }
    fclose(file);
    return 1;
}

static int read_image(const char *base)
{
    char path[2048];
    FILE *file;
    if (snprintf(path, sizeof path, "%sHOST_IMAGE.BIN", base) >= (int)sizeof path) return 0;
    file = fopen(path, "rb");
    if (!file) return 0;
    arena = malloc(0x100000);
    if (!arena || fread(arena, 1, 0x100000, file) != 0x100000 || fgetc(file) != EOF) {
        fclose(file);
        return 0;
    }
    fclose(file);
    return overkill_bind_real_memory(arena, 0x100000) &&
           overkill_bind_state(arena + HOST_DATA_LINEAR, 0x10000);
}

int main(int argc, char **argv)
{
    const char *base, *input_path = NULL, *trace_path = NULL;
    const char *asset_override = NULL, *save_override = NULL;
    char asset_path[2048], save_path[2048];
    volatile word adapter = VIDEO_TANDY;
    volatile byte sound = SOUND_SELECT_ADLIB;
    volatile byte override_mask = 0;
    int i;
    DosRegisters registers = {0};
    for (i = 1; i < argc; ++i) {
        if (!strcmp(argv[i], "--headless")) headless = 1;
        else if (!strcmp(argv[i], "--milliseconds") && i + 1 < argc) {
            char *end;
            unsigned long long ms = strtoull(argv[++i], &end, 10);
            if (*end || ms > UINT64_MAX / UINT64_C(1000000)) return 2;
            limit_ns = ms * UINT64_C(1000000);
        } else if (!strcmp(argv[i], "--input-script") && i + 1 < argc) input_path = argv[++i];
        else if (!strcmp(argv[i], "--trace") && i + 1 < argc) trace_path = argv[++i];
        else if (!strcmp(argv[i], "--screenshot") && i + 1 < argc) screenshot_path = argv[++i];
        else if (!strcmp(argv[i], "--assets") && i + 1 < argc) asset_override = argv[++i];
        else if (!strcmp(argv[i], "--saves") && i + 1 < argc) save_override = argv[++i];
        else if (!strcmp(argv[i], "--video") && i + 1 < argc) {
            const char *mode = argv[++i];
            if (!strcmp(mode, "tandy")) adapter = VIDEO_TANDY;
            else if (!strcmp(mode, "cga")) adapter = VIDEO_CGA;
            else if (!strcmp(mode, "ega")) adapter = VIDEO_EGA;
            else return 2;
            override_mask |= LAUNCHER_OVERRIDE_VIDEO;
        } else if (!strcmp(argv[i], "--sound") && i + 1 < argc) {
            const char *mode = argv[++i];
            if (!strcmp(mode, "adlib")) sound = SOUND_SELECT_ADLIB;
            else if (!strcmp(mode, "roland")) sound = SOUND_SELECT_ROLAND;
            else if (!strcmp(mode, "off")) sound = 0;
            else return 2;
            override_mask |= LAUNCHER_OVERRIDE_SOUND;
        } else {
            fprintf(stderr, "Usage: %s [--video tandy|cga|ega] [--sound adlib|roland|off]\n"
                    "  [--headless --milliseconds N --input-script FILE --trace FILE]\n"
                    "  [--assets DIRECTORY --saves DIRECTORY --screenshot FILE.bmp]\n", argv[0]);
            return 2;
        }
    }
    if (headless) SDL_SetHint(SDL_HINT_VIDEO_DRIVER, "dummy");
    if (!SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_GAMEPAD)) {
        fprintf(stderr, "SDL initialization: %s\n", SDL_GetError());
        return 1;
    }
    base = SDL_GetBasePath();
    if (!base || !read_image(base)) { fprintf(stderr, "Cannot read source-built HOST_IMAGE.BIN\n"); return 1; }
    if (!overkill_bind_level_map(overkill_segment_address(LevelMapSegment, 0), 0x10000))
        return 1;
    if (snprintf(asset_path, sizeof asset_path, "%sassets", base) >= (int)sizeof asset_path ||
        snprintf(save_path, sizeof save_path, "%ssaves", base) >= (int)sizeof save_path) return 1;
    if (!overkill_resource_mount_drive('C', asset_override ? asset_override : asset_path) ||
        !overkill_resource_set_current_drive('C') ||
        !overkill_file_services_set_save_root(save_override ? save_override : save_path)) return 1;
    if (!headless) {
        char log_path[2048];
        FILE *log_file;
        if (snprintf(log_path, sizeof log_path, "%s/OVERKILL.log",
                     save_override ? save_override : save_path) < (int)sizeof log_path &&
            (log_file = fopen(log_path, "a")) != NULL) {
#ifdef _WIN32
            (void)_dup2(_fileno(log_file), _fileno(stderr));
#else
            (void)dup2(fileno(log_file), fileno(stderr));
#endif
            fclose(log_file);
            setvbuf(stderr, NULL, _IONBF, 0);
            fprintf(stderr, "\nOverkill SDL3 session, build %s %s\n", __DATE__, __TIME__);
        }
    }
    {
        word heap_start = HOST_SEGMENT_IMAGEEND;
        if (!overkill_resource_services_bind_arena(heap_start, (word)(0xA000u - heap_start))) return 1;
    }
    MainDataSegment = HOST_DATA_SEGMENT;
    overkill_clock_bind(module_tick, sound_sfx_tick);
    overkill_clock_reset(0);
    if (headless) sound_services_midi_bind_sink(midi_sink, NULL);
    if (!(headless ? sound_services_start_offline(48000) : sound_services_start())) {
        fprintf(stderr, "Audio initialization: %s\n", SDL_GetError()); return 1;
    }
    sound_services_bind_offline_pcm_sink(pcm_sink, NULL);
    if (input_path && !read_script(input_path)) { fprintf(stderr, "Invalid input script\n"); return 2; }
    if (trace_path) { trace = fopen(trace_path, "w"); if (!trace) return 1; }
    overkill_platform_bind_idle(idle_game);
    overkill_platform_bind_exit(terminate_game);
    overkill_platform_bind_trace(trace_service);
    if (!overkill_sdl_video_open()) {
        fprintf(stderr, "Video initialization: %s\n", SDL_GetError());
        return 1;
    }
    origin_ns = SDL_GetTicksNS();
    if (setjmp(return_to_host) == 0) {
        uint8_t *tail = overkill_segment_address(HOST_LOAD_SEGMENT - 0x10, PSP_COMMAND_TAIL);
        tail[0] = 3;
        tail[1] = override_mask;
        tail[2] = (byte)adapter;
        tail[3] = sound;
        *(word *)overkill_segment_address(HOST_SEGMENT_ENTRYESPSP, HOST_OFFSET_ENTRYESPSP) =
            HOST_LOAD_SEGMENT - 0x10;
        *(word *)overkill_segment_address(HOST_SEGMENT_ENTRYDSPSP, HOST_OFFSET_ENTRYDSPSP) =
            HOST_LOAD_SEGMENT - 0x10;
        {
            HostRegisters prologue = {0};
            overkill_platform_call(HOST_TOKEN_BUILDBYTETONIBBLEMASKTABLE, &prologue);
        }
        registers.es = HOST_DATA_SEGMENT;
        launcher_after_prologue(HOST_LOAD_SEGMENT - 0x10, &registers);
    }
    if (trace) {
        fprintf(trace, "settings,%04X,%02X,%04X,%04X\n",
                VideoAdapter, SoundModuleSelect, InputDeviceMode, SoundOption);
        fprintf(trace, "state,%04X,%04X,%04X,%04X,%04X,%04X,%04X,%04X\n",
                LevelIndex, MapScrollPos, LevelIntroFrames, Fuel,
                PRIMARY->x, PRIMARY->y, PRIMARY->status, LivesLeft);
        fprintf(trace, "audio,%" PRIu64 ",%016" PRIx64 "\n", pcm_frames, pcm_hash);
        fprintf(trace, "midi,%" PRIu64 ",%016" PRIx64 "\n", midi_bytes, midi_hash);
        fprintf(trace, "dropped-audio-events,%u\n", sound_services_dropped_events());
        fclose(trace);
    }
    if (screenshot_path && !overkill_sdl_video_save_bmp(screenshot_path)) {
        fprintf(stderr, "Cannot save screenshot: %s\n", SDL_GetError());
        exit_status = 1;
    }
    overkill_platform_bind_idle(NULL);
    overkill_platform_bind_trace(NULL);
    overkill_platform_bind_exit(NULL);
    adlib_sequence_unbind();
    roland_sequence_unbind();
    sound_services_midi_shutdown();
    sound_services_shutdown();
    overkill_video_services_shutdown();
    overkill_sdl_video_close();
    actual_sdl_gamepad_close();
    free(script);
    free(arena);
    SDL_Quit();
    return exit_status;
}
