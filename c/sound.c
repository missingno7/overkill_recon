/* Candidate C translation of the reusable PC-speaker sequencer and main-program
   music request policy.  The IRQ entry and all hardware writes remain ASM.

   SEGMENT: CGAME
   OWNS: SfxTimerTick SfxStartRequest SfxVoiceTick SfxStreamNextByte
   OWNS: SfxStreamStoreAndWait SfxStreamCommandByte SfxVoiceApplySlide
   OWNS: SfxVoiceApplyNoteStep SfxVoiceLoadNoteDivisor SfxVoiceNoteDone
   OWNS: SfxStopAll SfxCmdRest SfxCmdStepDown SfxCmdStepUp SfxCmdSlide
   OWNS: RequestModuleMusic StopModuleMusic

   The SFX stream bytes, effect table, note divisors, voice records and mailboxes are
   all the oracle's existing DS storage.  No C-owned state is introduced.  The sound
   DOS builds retain the module's SoundModuleTickEntry and hardware driver leaves.
   OVERKILL_HOST binds the optional music image to host sequencers and native devices. */
#include "sound.h"

#ifdef OVERKILL_HOST
#include "../host/sound_services.h"
#include "../host/memory.h"
#else
extern void SfxSpeakerPortOff(void);       /* MAIN; read PPI port B, mask, then write */
extern void SfxSpeakerPortProgram(void);   /* MAIN; divisor is in BX */
extern void WaitTimerInterruptIfModule(void); /* MAIN; waits for one observed timer phase */
extern byte __far SoundModuleSlot[];
#endif

#ifndef OVERKILL_HOST
void sound_call_main(main_routine target);
#pragma aux sound_call_main "FarCallMainNearViaAX" far parm [ax] modify exact [ax]
void sound_call_main_bx(main_routine target, word value);
#pragma aux sound_call_main_bx "FarCallMainNearViaAX" far parm [ax] [bx] modify exact [ax bx]
word sound_call_main_result(main_routine target);
#pragma aux sound_call_main_result "FarCallMainNearViaAX" far parm [ax] value [ax] modify exact [ax]
#endif

void sound_sfx_speaker_off(void)
{
#ifdef OVERKILL_HOST
    sound_services_speaker_off();
#else
    sound_call_main(SfxSpeakerPortOff);
#endif
}

void sound_sfx_speaker_program(word divisor)
{
#ifdef OVERKILL_HOST
    sound_services_speaker_program(divisor);
#else
    sound_call_main_bx(SfxSpeakerPortProgram, divisor);
#endif
}

word sound_sfx_word(byte *voice, byte field)
{
    return *(word *)(voice + field);
}

void sound_sfx_set_word(byte *voice, byte field, word value)
{
    *(word *)(voice + field) = value;
}

void sound_sfx_store_and_wait(byte *voice, word cursor)
{
    sound_sfx_set_word(voice, SFX_VOICE_STREAM, cursor);
    voice[SFX_VOICE_COUNTDOWN] = voice[SFX_VOICE_DURATION];
}

void sound_sfx_stop_all(void)
{
    SfxActive = 0;
    SfxVoiceA[SFX_VOICE_SOUNDING] = 0;
    SfxVoiceB[SFX_VOICE_SOUNDING] = 0;
    sound_sfx_speaker_off();
}

void sound_sfx_command_rest(byte *voice, word cursor)
{
    voice[SFX_VOICE_SOUNDING] = 0;
    if ((SfxVoiceA[SFX_VOICE_SOUNDING] | SfxVoiceB[SFX_VOICE_SOUNDING]) == 0)
        sound_sfx_speaker_off();
    sound_sfx_store_and_wait(voice, cursor);
}

void sound_sfx_command_step_down(byte *voice, word cursor)
{
    voice[SFX_VOICE_NOTE_STEP] = 0xFF;
    sound_sfx_stream_next_byte(voice, cursor);
}

void sound_sfx_command_step_up(byte *voice, word cursor)
{
    voice[SFX_VOICE_NOTE_STEP] = 1;
    sound_sfx_stream_next_byte(voice, cursor);
}

void sound_sfx_command_slide(byte *voice, word cursor)
{
    sound_sfx_set_word(voice, SFX_VOICE_SLIDE_DELTA, *GAME_PTR(word, cursor));
    cursor = (word)(cursor + 2);
    voice[SFX_VOICE_SLIDE_TICKS] = *GAME_PTR(byte, cursor);
    cursor = (word)(cursor + 1);
    sound_sfx_stream_next_byte(voice, cursor);
}

/* A note index is shifted as an 8-bit AL in the oracle.  Masking to 7Fh retains that
   wrap before the word lookup, including the original reads beyond the 84-word table. */
void sound_sfx_load_note_divisor(byte *voice)
{
    byte note = voice[SFX_VOICE_NOTE];
    word divisor = SfxNoteDivisors[note & 0x7F];
    sound_sfx_set_word(voice, SFX_VOICE_DIVISOR, divisor);
}

void sound_sfx_apply_note_step(byte *voice)
{
    byte step = voice[SFX_VOICE_NOTE_STEP];
    if (step == 0) return;
    voice[SFX_VOICE_NOTE] = (byte)(voice[SFX_VOICE_NOTE] + step);
    sound_sfx_load_note_divisor(voice);
}

void sound_sfx_apply_slide(byte *voice)
{
    if (voice[SFX_VOICE_SLIDE_TICKS] == 0) return;
    --voice[SFX_VOICE_SLIDE_TICKS];
    sound_sfx_set_word(voice, SFX_VOICE_DIVISOR,
        (word)(sound_sfx_word(voice, SFX_VOICE_DIVISOR) +
               sound_sfx_word(voice, SFX_VOICE_SLIDE_DELTA)));
}

/* Reads one stream item.  Command 80h has the original nonlocal effect: it stops both
   voices and returns from this voice tick, while SfxTimerTick still ticks voice B after
   a command from voice A because it tests SfxActive only once before both calls. */
void sound_sfx_stream_next_byte(byte *voice, word cursor)
{
    for (;;) {
        byte value = *GAME_PTR(byte, cursor);
        cursor = (word)(cursor + 1);
        if (value < SFX_STREAM_COMMAND) {
            voice[SFX_VOICE_NOTE] = value;
            sound_sfx_load_note_divisor(voice);
            voice[SFX_VOICE_SOUNDING] = 2;
            sound_sfx_store_and_wait(voice, cursor);
            return;
        }
        if (value >= SFX_STREAM_DURATION) {
            voice[SFX_VOICE_DURATION] = (byte)(value - SFX_DURATION_BIAS);
            continue;
        }
        switch (value) {
        case SFX_END:
            sound_sfx_stop_all();
            return;
        case SFX_REST:
            sound_sfx_command_rest(voice, cursor);
            return;
        case SFX_STEP_DOWN:
            voice[SFX_VOICE_NOTE_STEP] = 0xFF;
            continue;
        case SFX_STEP_UP:
            voice[SFX_VOICE_NOTE_STEP] = 1;
            continue;
        case SFX_SLIDE:
            sound_sfx_set_word(voice, SFX_VOICE_SLIDE_DELTA,
                               *GAME_PTR(word, cursor));
            cursor = (word)(cursor + 2);
            voice[SFX_VOICE_SLIDE_TICKS] = *GAME_PTR(byte, cursor);
            cursor = (word)(cursor + 1);
            continue;
        case SFX_HOLD:
            sound_sfx_store_and_wait(voice, cursor);
            return;
        default:
            /* Every current SfxEffectTable stream uses only 80h..85h commands.  The
               oracle's unchecked dispatch for other command bytes jumps through
               adjacent DS words; the C parser deliberately does not invent a C
               meaning for data outside that proven stream vocabulary. */
            return;
        }
    }
}

void sound_sfx_voice_tick(byte *voice)
{
    word cursor = sound_sfx_word(voice, SFX_VOICE_STREAM);
    --voice[SFX_VOICE_COUNTDOWN];
    if (voice[SFX_VOICE_COUNTDOWN] == 0) {
        sound_sfx_stream_next_byte(voice, cursor);
        return;
    }
    sound_sfx_apply_note_step(voice);
    sound_sfx_apply_slide(voice);
}

/* Pending requests are a last-write mailbox.  Only a successful start consumes it;
   an invalid request repeats stop-all every tick, and a higher-priority request stays
   pending until the active effect ends. */
void sound_sfx_start_request(void)
{
    byte effect = SfxRequest;
    word row;
    if (effect == 0) return;
    if (effect >= SFX_EFFECT_COUNT) {
        sound_sfx_stop_all();
        return;
    }
    if (SfxActive != 0 && effect != SfxActive && effect > SfxActive) return;

    SfxActive = effect;
    row = (word)effect * 2;
    sound_sfx_set_word(SfxVoiceA, SFX_VOICE_STREAM, SfxEffectTable[row]);
    sound_sfx_set_word(SfxVoiceB, SFX_VOICE_STREAM, SfxEffectTable[row + 1]);
    SfxVoiceA[SFX_VOICE_NOTE_STEP] = 0;
    SfxVoiceB[SFX_VOICE_NOTE_STEP] = 0;
    SfxVoiceA[SFX_VOICE_SLIDE_TICKS] = 0;
    SfxVoiceB[SFX_VOICE_SLIDE_TICKS] = 0;
    SfxRequest = 0;
    SfxVoiceA[SFX_VOICE_COUNTDOWN] = 1;
    SfxVoiceB[SFX_VOICE_COUNTDOWN] = 1;
}

void sound_sfx_tick(void)
{
    byte selected;
    word divisor;
    SfxTickPhase = (byte)((SfxTickPhase + 1) & 3);
    if (SfxRequest != 0) sound_sfx_start_request();
    if (SfxActive == 0) return;

    sound_sfx_voice_tick(SfxVoiceA);
    sound_sfx_voice_tick(SfxVoiceB);

    selected = (SfxTickPhase & 1) ? 1 : 0;
    if (selected == 0) {
        if (SfxVoiceA[SFX_VOICE_SOUNDING] == 0) return;
        divisor = sound_sfx_word(SfxVoiceA, SFX_VOICE_DIVISOR);
    } else {
        if (SfxVoiceB[SFX_VOICE_SOUNDING] == 0) return;
        divisor = sound_sfx_word(SfxVoiceB, SFX_VOICE_DIVISOR);
    }
    sound_sfx_speaker_program(divisor);
}

/* ModuleSoundRequest is an always-updated game latch.  The module header is written
   only when enabled and the requested tune differs from its current tune.  The loaded
   flag is intentionally not consulted: the original also writes the empty SLOT1022. */
void sound_request_module_music(word input_ax)
{
    byte tune = (byte)input_ax;
    word __far *request = (word __far *)(SoundModuleSlot + MODULE_MUSIC_REQUEST);
    ModuleSoundRequest = tune;
    if (ModuleSoundEnabled == 0) return;
    if (SoundModuleSlot[MODULE_MUSIC_CURRENT] == tune) return;
    *request = (word)tune;
#ifdef OVERKILL_HOST
    sound_services_music_request(tune);
#endif
}

/* Stop policy is game control; waiting for one timer phase is still the existing ASM
   service.  Return the original AX high byte plus the last wait's AL, as the five
   historical near calls leave it. */
word sound_stop_module_music(word input_ax)
{
    word tick_result = input_ax;
    word count;
    if (SoundModuleLoaded == 0) return input_ax;
    *(word __far *)(SoundModuleSlot + MODULE_MUSIC_REQUEST) = 0x00FF;
#ifdef OVERKILL_HOST
    sound_services_music_request(0xFF);
#endif
    for (count = 0; count < 5; ++count) {
#ifdef OVERKILL_HOST
        sound_services_wait_ticks(1);
        tick_result = (word)((input_ax & 0xFF00) | (tick_result & 0x00FF));
#else
        tick_result = sound_call_main_result(WaitTimerInterruptIfModule);
        tick_result = (word)((input_ax & 0xFF00) | (tick_result & 0x00FF));
#endif
    }
    return tick_result;
}
