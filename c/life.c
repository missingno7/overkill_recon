/* Life/demo setup over the original pools and save buffers.
   SEGMENT: CGAME
   OWNS: ResetRecordsForLife ResetInvaderFormation RequestLifeStartMusic
*/
#include "life.h"
#include "sound.h"
#ifdef OVERKILL_HOST
#include "../host/level_policies.h"
#endif

#ifndef OVERKILL_HOST
extern volatile word __far SaveBufferCursor;
#endif
Record *find_free_record_pool_a(void);
void pickup_fuel(void);
#ifndef OVERKILL_HOST
word life_request_music(word tune, word es);
#pragma aux life_request_music "LIFE_REQUEST_MUSIC" parm [ax] [si] value [ax] modify exact [ax bx es]
#endif

/* Pointer-table order matters: buffers start at the last entry. Pods retain all
   their state except the draw pass and buffer; kind and the allocation cursor
   otherwise survive. The exhaust is claimed through that same cursor. */
void reset_records_for_life(void)
{
    word n;
    Record *r;
    for (n = 0; n < 16; n++) ((word *)GroupTable)[n] = 0;
    SaveBufferCursor = GAME_OFFSET(PoolBSaveBuffers);
    for (n = POOL_B_COUNT; n != 0; n--) {
        r = GAME_PTR(Record, PoolBPointers[n - 1]);
        r->status = 0;
        r->step_error = 0;
        r->type = 0;
        r->save_buffer = SaveBufferCursor;
        SaveBufferCursor += POOL_B_SAVE_BYTES;
    }
    SaveBufferCursor = GAME_OFFSET(PoolASaveBuffers);
    for (n = POOL_A_POINTER_COUNT; n != 0; n--) {
        r = GAME_PTR(Record, PoolAPointers[n - 1]);
        r->draw_pass = 1;
        if (r->kind != KIND_POD) {
            r->status = 0;
            r->step_error = 0;
            r->flash_timer = 0;
            r->type = 0;
            r->direction = DIR_UP;
        }
        r->save_buffer = SaveBufferCursor;
        SaveBufferCursor += POOL_A_SAVE_BYTES;
    }
    PRIMARY->status = 1;
    PRIMARY->kind = KIND_PLAYER;
    PRIMARY->size_class = 2;
    PRIMARY->y = 0xC0;
    PRIMARY->x = 0x58;
    PRIMARY->draw_pass = 1;
    r = find_free_record_pool_a();
    /* Like the oracle, no full-pool check is made here. */
    r->status = 1;
    r->size_class = 1;
    r->kind = KIND_EXHAUST;
    for (n = 0; n < 26; n++) BeamList[n] = 0xFFFF;
    EnergyTanks = 3;
    EnergyPoints = 0x18;
    ShotsLiveMain = 0;
    ShotsLiveType9 = 0;
    ShotsLiveFrontPod = 0;
    ShotsLiveSide = 0;
    Fuel = 0;
    MissilesLive = 0;
    SidePodSpreadRight = 0;
    SidePodSpreadLeft = 0;
    AutoMoveExtraRecord = 0xFFFF;
    pickup_fuel();
    FireLatch = 0;
    RandomWordCursor = GAME_OFFSET(CreditRandomWords);
    EncounterLiveCount = 0;
    EncounterEndDelay = 0;
    LevelEndPhase = LEVEL_END_OFF;
    RecordTickCounter = 0;
}

void reset_invader_formation(void)
{
    InvaderSlotCursor = GAME_OFFSET(InvaderFormation);
    InvaderNextMarchLeft = 0;
    InvaderNextDropStep = 0;
}

/* The unchecked table index is the low byte of LevelIndex. The sound service
   may replace ES with its module segment; return it to the session's ABI state. */
word request_life_start_music(word es)
{
    word tune;
    if (MapScrollPos == MAP_START_POS) tune = MUSIC_LEVEL_START;
    else if (MapScrollPos == MAP_END_POS) tune = MUSIC_LEVEL_END;
#ifdef OVERKILL_HOST
    else tune = overkill_level_music(LevelIndex);
#else
    else tune = LevelMusicTable[(byte)LevelIndex];
#endif
#ifdef OVERKILL_HOST
    sound_request_module_music(tune);
    return es;
#else
    return life_request_music(tune, es);
#endif
}
