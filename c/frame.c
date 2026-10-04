/* Per-frame gameplay drivers, translated from the frozen oracle (asm-semantic-oracle-v1):
   the record pass (UpdateAllRecords with the march / type 93h / segmented-boss frame
   state, UpdateRecordByKind), the handlers of types 50h, 76h..79h (the segmented boss)
   and 80h (the invader marcher), the frame timers (TickFrameTimers, fuel drain and
   refuel, UpdateRefuelTimersAndScore, the hatch ramp step) and the map scroll (forward
   and backward line steps, map row entry, the level end, checkpoints, the level start
   scroll, SmartBombAll). Same state, same results; see the oracle comments at each
   routine for the original contracts.

   Platform code stays ASM and is called through the trampolines: text leaves used by the
   native score coordinator, map row drawing into the scroll band (DrawMapRowIntoScrollBand;
   its spawn part is C in c/spawn.c), SetDacColor6 and music requests. Fuel-gauge drawing
   is native C in c/render.c, and checkpoint map loading is native C in c/levels.c. All
   REC_KIND handlers are C and called directly (c/enemies.c, c/pods.c, c/player.c).

   The scroll geometry words (ScrollBandBytes...), LevelMapSegment and the MapResetList
   tables are CS-resident in MAIN and are read in place through far references.

   SEGMENT: CGAME
   OWNS: UpdateAllRecords UpdateRecordByKind KindHandlers SteerSegBossAlongPath StepMarchFireDelay
   OWNS: Type50SteerHomeThenBecomePod Type76SegBossPart0 Type77SegBossPart1 Type78SegBossCore
   OWNS: Type79SegBossPart3 SegBossPlacePart Type80MarchFormationMember Type80MarchMemberBody
   OWNS: TickFrameTimers TickFuelDrain UpdateRefuelTimersAndScore DrainFuelUnit
   OWNS: RefuelTankFullTail StopRefuelTail TickRefuel StepHatchRampFrame
   OWNS: ScrollForwardAndCheckLevelEnd ScrollForwardOneLine ScrollLineDone WrapScrollWindowForward
   OWNS: EnterNextMapRowForward ScrollBackwardOneLine EnterPreviousMapRowBackward WrapScrollWindowBackward
   OWNS: ReadCheckpoint RestartAtCheckpoint ScrollToCheckpoint ScrollMapToLevelStart SmartBombAll
   OWNS: ResetMapBeforeView ResetMapScanByte SetMapTile28 SetMapTile1 ResetMapNextByte
   OWNS: InitStars InitNextStar InitStarCases InitStarCga InitStarEga InitStarTandy InitStarNext MoveStars MoveStarLayer
*/
#include "game.h"
#include "hits.h"
#include "enemies.h"
#include "pods.h"
#include "player.h"
#include "frame.h"
#include "display.h"
#include "render.h"
#include "levels.h"
#include "sound.h"

#ifdef OVERKILL_HOST
#include "level_def.h"
#include "level_policies.h"
#include "level_timeline.h"
#include "level_departure.h"
#include "level_invaders.h"
#include "level_boss.h"
#undef tick_frame_timers
#endif

#define FRAME_NO_RECORD NO_RECORD

void steer_toward_target(Record *r);           /* c/movement.c */
Record *find_free_record_pool_a(void);         /* c/spawn.c */

/* CS-resident words of MAIN. */
#ifndef OVERKILL_HOST
extern word __far LevelMapSegment;             /* segment of the level map */
extern word __far ScrollBandBytes;             /* scroll geometry, set per video adapter */
extern word __far ScrollWrapOffset;
extern word __far ScrollStartOffset;
extern word __far PlayfieldRowBytes;
/* The MapResetList tables are CS data of MAIN; MapResetLists (DS) holds their offsets. */
extern word __far MapResetList0[];
#define FRAME_MAP_AT(off) (((__segment)LevelMapSegment) :> ((byte __based(void) *)(off)))
#define FRAME_MAIN_WORD(off) \
    (*(((__segment)MapResetList0) :> ((word __based(void) *)(off))))
#else
extern void *overkill_level_map_address(word offset);
extern void host_draw_map_row_into_scroll_band(word map_row_offset);
extern void host_set_dac_color6(const byte rgb[3]);
#define FRAME_MAP_AT(off) ((byte *)overkill_level_map_address((word)(off)))
#define FRAME_MAIN_WORD(off) \
    (*(word *)overkill_segment_address(HOST_LOAD_SEGMENT, (word)(off)))
#endif

#define FRAME_STATE_WORD(array, byte_offset) \
    (*GAME_PTR(word, (word)(GAME_OFFSET(array) + (word)(byte_offset))))
#define FRAME_DS_WORD(offset) (*GAME_PTR(word, (word)(offset)))

/* Remaining ASM, entered through the thunks in c/frame.asm (CGAME): FRAME_CALL_BP calls
   the MAIN routine at AX with BP = SI (SI passes through too) and returns the BP the
   routine leaves; every register but BP is the routine's. */
#ifndef OVERKILL_HOST
word frame_call_bp(main_routine target, Record *r);
#pragma aux frame_call_bp "FRAME_CALL_BP" parm [ax] [si] value [ax] modify exact [ax bx cx dx si di es]
/* RequestModuleMusic (AL = tune; takes its input in AX, so through FarCallMainNearViaBP). */
void frame_request_music(word tune);
#pragma aux frame_request_music "FRAME_REQUEST_MUSIC" parm [ax] modify exact [ax bx es]
extern void DrawMapRowIntoScrollBand(void);   /* BP = spawn origin (DrawIncomingMapRow) */
extern void SetDacColor6(void);               /* SI = RGB triple */
extern void SetMapTile28(void);               /* MapResetList targets (bridge labels) */
extern void SetMapTile1(void);
#else
#define frame_request_music(tune) sound_request_module_music((word)(tune))
#endif

word draw_incoming_map_row(Record *here);

#define STAR_COUNT 40
#define STAR_LAYER_ONE_COUNT 20
#define STAR_LAYER_TWO_COUNT 10
#define STAR_LAYER_THREE_COUNT 10

typedef struct StarEntry {
    word y;
    word x;
    word mask;
} StarEntry;
STATIC_CHECK(frame_star_entry_size, sizeof(StarEntry) == 6);

#ifndef OVERKILL_HOST
extern volatile word __far VideoAdapter;
#endif

/* Startup-only transform of the oracle's in-place {Y, X, mask} table. The word mask
   load intentionally begins at the selected byte, matching the original unscaled lookup. */
void init_stars(void)
{
    StarEntry *star = (StarEntry *)Stars;
    word adapter = VideoAdapter;
    word n;

    for (n = 0; n != STAR_COUNT; n++, star++) {
        word pixels = star->x;
        switch (adapter) {
        case VIDEO_CGA:
            star->x = pixels >> 2;
            star->mask = *GAME_PTR(word, (word)(GAME_OFFSET(StarMasksCga) + (pixels & 3)));
            break;
        case VIDEO_EGA:
            star->x = pixels >> 3;
            star->mask = *GAME_PTR(word, (word)(GAME_OFFSET(StarMasksEga) + (pixels & 7)));
            break;
        case VIDEO_TANDY:
            star->x = pixels >> 1;
            star->mask = *GAME_PTR(word, (word)(GAME_OFFSET(StarMasksTandy) + (pixels & 1)));
            if (StarBrightCount != 0) {
                StarBrightCount--;
                if (StarBrightCount == 0) {
                    StarMasksTandy[0] &= 7;
                    StarMasksTandy[1] &= 0x70;
                }
            }
            break;
        }
    }
}

void frame_move_star_layer(StarEntry *star, word count)
{
    word n;

    for (n = 0; n != count; n++, star++) {
        star->y++;
        if (star->y == 0xC0) star->y = 0;
    }
}

void move_stars(void)
{
    if (EnergyTanks == 0xFFFF) return;
    StarLayerTick1++;
    StarLayerTick1 &= 1;
    if (StarLayerTick1 != 0) return;

    frame_move_star_layer((StarEntry *)Stars, STAR_LAYER_ONE_COUNT);
    StarLayerTick2++;
    StarLayerTick2 &= 1;
    if (StarLayerTick2 != 0) return;

    frame_move_star_layer((StarEntry *)Stars + STAR_LAYER_ONE_COUNT, STAR_LAYER_TWO_COUNT);
    StarLayerTick3++;
    StarLayerTick3 &= 1;
    if (StarLayerTick3 != 0) return;

    frame_move_star_layer((StarEntry *)Stars + STAR_LAYER_ONE_COUNT + STAR_LAYER_TWO_COUNT,
                          STAR_LAYER_THREE_COUNT);
}

/* ---- the record pass ------------------------------------------------------------------- */

/* Per frame (FAR0F7F): raises MarchFireNow when MarchFireDelay expires and reloads the
   delay, 78h down to 28h with fewer live encounter members (unsigned compares). */
void step_march_fire_delay(void)
{
    word live;
    byte delay;

    if (--MarchFireDelay != 0) {
        MarchFireNow = 0;
        return;
    }
    live = EncounterLiveCount;
#ifdef OVERKILL_HOST
    {
        LevelInvaders invaders;
        overkill_level_invaders(LevelIndex, &invaders);
        delay = overkill_march_delay(invaders.fire_delays, invaders.fire_delay_count, live);
    }
#else
    if (live > 0x10) delay = 0x78;
    else if (live > 8) delay = 0x64;
    else if (live > 4) delay = 0x50;
    else if (live > 2) delay = 0x3C;
    else delay = 0x28;
#endif
    MarchFireDelay = delay;
    MarchFireNow++;
}

/* Steers SegBossAnchor (speed 2) along BossPath from SegBossX/Y; on arrival the cursor
   advances and the next waypoint is steered in the same frame (FFFFh restarts the path).
   SegBossPathCursor only ever points into BossPath. */
void steer_seg_boss_along_path(void)
{
    Record *anchor;
    word *point;

    for (;;) {
        anchor = GAME_PTR(Record, SegBossAnchor);
        anchor->x = SegBossX;
        anchor->y = SegBossY;
        for (;;) {
            point = GAME_PTR(word, SegBossPathCursor);
            if (point[0] != 0xFFFF) break;
            SegBossPathCursor = GAME_OFFSET(BossPath);
        }
        SteerTargetY = point[0] + 0x20;
        SteerTargetX = point[1];
        SteerSpeed = 2;
        steer_toward_target(anchor);
        SegBossX = anchor->x;
        SegBossY = anchor->y;
        if (SteerArrived == 0) return;
        SegBossPathCursor = (word)(SegBossPathCursor + 4);
    }
}

/* KindHandlers: the record's REC_KIND handler (0..6; the oracle's table is unchecked and
   no other kind is ever stored). Returns the BP the handler leaves: the record itself for
   every handler (KIND_PLAYER is a bare ret). */
word frame_update_record_by_kind(Record *r)
{
    switch (r->kind) {
    case KIND_SCENERY: scroll_record_then_finish(r); break;
    case KIND_POD:     update_pod(r); break;
    case KIND_TYPED:
    case KIND_ENEMY:   run_type_handler(r); break;
    case KIND_PICKUP:  update_pickup(r); break;
    case KIND_EXHAUST: update_exhaust(r); break;
    }
    return GAME_OFFSET(r);
}

/* Per frame: the invader march latches, on level 5 the march step / drop / fire delays,
   the type 93h kill pulse and the segmented boss anchor, then every live pool A record
   from PoolAPointers[34] down to [0] (RecordTickCounter counts every visited slot, live
   or not, modulo 5DCh), SwayDropY = 0, pool B from [33] down to [0], then MoveStars. A
   record spawned during the pass runs this frame only if its slot is still ahead.
   Returns the BP the oracle leaves: the last pool B pointer, or what its handler left. */
word update_all_records(void)
{
    word n, live, bp;
    byte delay;
    Record *r;
#ifdef OVERKILL_HOST
    LevelInvaders invaders;
#endif

    if (FramesSinceInvaderSpawn != 0xFFFF) FramesSinceInvaderSpawn++;
    InvaderMarchLeft = InvaderNextMarchLeft;
    InvaderDropStep = InvaderNextDropStep;
    InvaderNextDropStep = 0;
#ifdef OVERKILL_HOST
    overkill_level_invaders(LevelIndex, &invaders);
    if (invaders.march_enabled) {
#else
    if (LevelIndex == 5) {
#endif
        if (MarchEdgeHit != 0) {
            MarchStepX = -MarchStepX;
            MarchEdgeHit = 0;
            MarchDropNow = 1;
        } else {
            MarchDropNow = 0;
        }
        /* A march step when MarchDelay runs out; the reload is 0Ah..1 by the live count
           (unsigned). A MarchDelay of 0 reloads with 0: a step every frame from then on. */
        delay = MarchDelay;
        if (delay != 0 && --delay != 0) {
            MarchDelay = delay;
            MarchStepNow = 0;
        } else {
            if (MarchDelay != 0) {
                live = EncounterLiveCount;
#ifdef OVERKILL_HOST
                delay = overkill_march_delay(invaders.step_delays, invaders.step_delay_count, live);
#else
                if (live > 0x10) delay = 0x0A;
                else if (live > 8) delay = 6;
                else if (live > 4) delay = 4;
                else delay = 1;
#endif
            }
            MarchDelay = delay;
            MarchStepNow++;
        }
        step_march_fire_delay();
    }
    Type93KilledPulse = 0;
    if (Type93KilledLatch != 0) {
        Type93KilledLatch = 0;
        Type93KilledPulse = 1;
    }
    if (SegBossActive == 1) steer_seg_boss_along_path();
    for (n = POOL_A_COUNT; n != 0; n--) {
        r = GAME_PTR(Record, PoolAPointers[n - 1]);
        if (++RecordTickCounter >= 0x5DC) RecordTickCounter = 0;
        if (r->status != 0) frame_update_record_by_kind(r);
    }
    SwayDropY = 0;
    for (n = POOL_B_COUNT; n != 0; n--) {
        r = GAME_PTR(Record, PoolBPointers[n - 1]);
        bp = GAME_OFFSET(r);
        if (r->status != 0) bp = frame_update_record_by_kind(r);
    }
    move_stars();
    return bp;
}

/* ---- record handlers --------------------------------------------------------------------- */

/* Type 50h (a demo pod flying home): steers at speed 1 to REC_SAVED, leaves SteerSpeed 2;
   on the call that finds it there it becomes KIND_POD (sfx 0Eh). The bridge returns with
   a bare ret: no FinishRecordUpdate (no clamp, bounds or collision checks). */
void type50_steer_home(Record *r)
{
    SteerTargetX = r->saved_x;
    SteerTargetY = r->saved_y;
    SteerSpeed = 1;
    steer_toward_target(r);
    SteerSpeed = 2;
    if (SteerArrived == 0) return;
    r->kind = KIND_POD;
    if (SfxEnabled != 0) SfxRequest = 0x0E;
}

/* Types 76h..79h, the segmented boss parts (part 0..3): the core (78h, part 2) faces down
   and fires aimed shots during FrameCount128 0..0Fh; every part sits at (SegBossY,
   SegBossX) + BossPartOffsets[part], Y clamped to >= 0 (signed), X not. The bridge then
   runs ScrollRecordThenFinish. */
void seg_boss_part(Record *r, word part)
{
#ifdef OVERKILL_HOST
    LevelBoss boss;
    const word *offset;
    overkill_level_boss(LevelIndex, &boss);
    offset = boss.offsets + 2 * part;
#else
    word *offset = BossPartOffsets + 2 * part;
#endif

    if (part == 2) {
        r->direction = DIR_DOWN;
        if (FrameCount128 <= 0x0F) spawn_aimed_shot(r);
    }
    r->y = offset[0] + SegBossY;
    if ((sword)r->y < 0) r->y = 0;
    r->x = offset[1] + SegBossX;
}

/* Type 80h, an invader marcher (the far body Type80MarchMemberBody; the bridge then runs
   FinishRecordUpdate). Idle until the type 7Eh leader script has ended and REC_ENTRY_DELAY
   has run out. Dives (sprite 164h, 3 HP) when RecordTickCounter & FFh is 0 or 7Dh; the
   first marcher seeing MarchFireNow clears it and fires. Out of its slot (REC_Y differs
   from REC_SAVED_Y) it steers there on even coordinates; in its slot it drops with
   MarchDropNow. X exactly 0 or C0h after a march step sets MarchEdgeHit. */
void type80_march_member(Record *r)
{
    word sprite, x;

    if (LeaderScriptCursor != GAME_OFFSET(LeaderScript7EEnd)) return;
    if (r->entry_delay != 0 && --r->entry_delay != 0) return;
    if (MarchStepNow != 0) r->saved_x += MarchStepX;
    sprite = r->sprite;
    if (sprite >= 0x164) {
        /* Diving: the slot keeps dropping with the formation. */
        if (MarchDropNow != 0) {
            r->saved_y += 0x0C;
            if (r->saved_y >= 0xB0) r->saved_y = 0x20;
        }
        if (sprite < 0x168) {
            if (FrameCount4 == 3) r->sprite++;
            return;
        }
        r->y += 5;
        r->sprite = 0x168;
        if ((FrameCount8 >> 2) != 0) r->sprite++;
        if (r->y <= 0xE0) return;
        /* Off the bottom: back in at the top, rejoining the formation on FrameCount4 = 3,
           else diving again at a random X 0..C0h. */
        r->y = 0;
        if (FrameCount4 == 3) {
            r->sprite = 0x160;
            r->hit_points = 5;
            return;
        }
        do {
            x = next_random_word() & 0xFF;
        } while (x > 0xC0);
        r->x = x;
        return;
    }
    x = RecordTickCounter & 0xFF;
    if (x == 0x7D || x == 0) {
        RecordTickCounter++;
        r->sprite = 0x164;
        r->hit_points = 3;
        return;
    }
    if (MarchFireNow != 0) {
        MarchFireNow = 0;
        spawn_aimed_shot(r);
        RecordTickCounter++;
    }
    if (MarchStepNow != 0) {
        r->x += MarchStepX;
        if (r->x == 0 || r->x == PLAYFIELD_MAX_X) MarchEdgeHit++;
    }
    if (r->saved_y != r->y) {
        SteerTargetX = r->saved_x & 0xFFFE;
        r->x &= 0xFFFE;
        SteerTargetY = r->saved_y & 0xFFFE;
        r->y &= 0xFFFE;
        SteerSpeed = 1;
        steer_toward_target(r);
        r->sprite = 0x160;
        if ((FrameCount8 >> 2) != 0) r->sprite++;
        return;
    }
    if (MarchDropNow != 0) {
        r->y += 0x0C;
        r->saved_y += 0x0C;
        if (r->y >= 0xB0) r->saved_y = 0x20;
    }
    r->sprite = ((r->x >> 1) & 1) + 0x162;
}

/* ---- frame timers, fuel and refuel ------------------------------------------------------- */

/* Fuel - 1 (nothing at 0), then the gauge. Reaching 0 kills the ship (sprite 3, sfx 19h)
   unless WhatOilShortageFlag refills it to 58h. Also runs while dying: reaching 0 then
   restarts the death animation. */
void drain_fuel_unit(void)
{
    if (Fuel == 0) return;
    if (--Fuel == 0) {
        if (WhatOilShortageFlag == 1) {
            Fuel = 0x58;
        } else {
            PRIMARY->sprite = 3;
            if (SfxEnabled != 0) SfxRequest = 0x19;
        }
    }
    render_draw_fuel_gauge();
}

/* One Fuel unit every 64 frames (DifficultySetting above 1) or every 128; in ship form 2
   one more on every second FrameCount32 wrap (ExtraDrainToggle back to 0). */
void tick_fuel_drain(void)
{
    if (DifficultySetting > 1 ? FrameCount64 == 0x3F : FrameCount128 == 0x7F) drain_fuel_unit();
    if (PRIMARY->sprite != 2 || FrameCount32 != 0x1F) return;
    ExtraDrainToggle ^= 1;
    if (ExtraDrainToggle == 0) drain_fuel_unit();
}

/* Per frame: when EncounterEndDelay runs out (no live encounter member) the level music
   again (MUSIC_LATE_LEVEL from MAP_MUSIC_CHANGE_POS on, unsigned); the sway (phase
   1..2 back and forth on FrameCount8 = 7; every 16th reversal sets SwayDropY 8), the slow
   counters every 4th frame, the frame counters, then the fuel drain. */
void tick_frame_timers(void)
{
    if (EncounterLiveCount == 0 && EncounterEndDelay != 0 && --EncounterEndDelay == 0)
        frame_request_music(MapScrollPos < MAP_MUSIC_CHANGE_POS ?
#ifdef OVERKILL_HOST
            overkill_level_music(LevelIndex)
#else
            LevelMusicTable[(byte)LevelIndex]
#endif
            : MUSIC_LATE_LEVEL);
    if (FrameCount8 == 7) {
        if (SwayDirX == 0xFFFF) {
            if (--SwayPhase == 0) {
                SwayDirX = -SwayDirX;
                SwayReversals++;
            }
        } else if (++SwayPhase == 2) {
            SwayDirX = -SwayDirX;
            SwayReversals++;
        }
    }
    SwayReversals &= 0x0F;
    if (SwayReversals == 0) {
        SwayDropY = 8;
        SwayReversals++;
    }
    FrameDivider4 = (FrameDivider4 + 1) & 3;
    if (FrameDivider4 == 0) {
        if (++SlowCount10 >= 0x0A) SlowCount10 = 0;
        if (++SlowCount6 >= 6) SlowCount6 = 0;
        if (++SlowCount5 >= 5) SlowCount5 = 0;
        if (++SlowCount3 >= 3) SlowCount3 = 0;
        SlowCount4 = (SlowCount4 + 1) & 3;
        SlowCount8 = (SlowCount8 + 1) & 7;
        EncounterTicks++;
    }
    FrameParity ^= 1;
    FrameCount4 = (FrameCount4 + 1) & 3;
    FrameCount8 = (FrameCount8 + 1) & 7;
    FrameCount16 = (FrameCount16 + 1) & 0x0F;
    FrameCount32 = (FrameCount32 + 1) & 0x1F;
    FrameCount64 = (FrameCount64 + 1) & 0x3F;
    FrameCount128 = (FrameCount128 + 1) & 0x7F;
    tick_fuel_drain();
}

/* While RefuelActive is 1: Fuel + 1 and the gauge, until 58h (sfx 0Ch, RefuelActive 0);
   stopped silently once the ship is destroyed (sprite 3 or more). */
void tick_refuel(void)
{
    if (RefuelActive != 1) return;
    if (PRIMARY->sprite >= 3) {
        RefuelActive = 0;
        return;
    }
    if (Fuel == 0x58) {
        if (SfxEnabled != 0) SfxRequest = 0x0C;
        RefuelActive = 0;
        return;
    }
    Fuel++;
    render_draw_fuel_gauge();
}

/* Refuel and timers precede score text. PrintTextChar establishes the main data segment
   and screen ES before consuming those renderer inputs, so the incoming BP/ES are dead;
   the native display coordinator writes its actual text results back into this pair. */
void frame_update_refuel_timers_and_score(DosRegisters *registers)
{
    tick_refuel();
    tick_frame_timers();
    display_draw_score(registers);
}

/* Types 28h/2Ah (the hatch ramp): every 4th frame (FrameDivider4 0) REC_DIRECTION steps
   mod 18h (a value at or above 18h also restarts at 0); REC_SPRITE = base +
   Type28FrameRamp[direction]. The oracle's xlat keeps the direction's high byte in AH and
   indexes by its low byte only (a direction at or above 18h reads past the ramp). */
void step_hatch_ramp_frame(Record *r, word base)
{
    word direction;

    if (FrameDivider4 == 0 && ++r->direction >= 0x18) r->direction = 0;
    direction = r->direction;
    r->sprite = (word)(((direction & 0xFF00) |
        *GAME_PTR(byte, (word)(GAME_OFFSET(Type28FrameRamp) + (direction & 0xFF)))) + base);
}

/* ---- the map scroll ---------------------------------------------------------------------- */

/* Draws the map row at MapScrollPos (spawning its objects, c/spawn.c), then MapScrollPos
   + 0Dh, LevelScriptClock - 1. Sfx 7 up to MAP_INTRO_END_POS; MUSIC_LEVEL_END when the
   clock reaches 4. */
void enter_next_map_row_forward(Record *here)
{
#ifdef OVERKILL_HOST
    host_draw_map_row_into_scroll_band(draw_incoming_map_row(here));
#else
    frame_call_bp((main_routine)DrawMapRowIntoScrollBand, here);
#endif
    if (MapScrollPos <= MAP_INTRO_END_POS && SfxEnabled != 0) SfxRequest = 7;
    MapScrollPos += MAP_ROW_BYTES;
    if (--LevelScriptClock == 4) frame_request_music(MUSIC_LEVEL_END);
    LastTileStepBackward = 0;
}

/* ScrollDeltaY + 1; moves ScrollWindowOffset up one pixel line, entering a new map row
   every 16 lines. A row boundary reached right after a backward row entry
   (LastTileStepBackward) advances MapScrollPos and the clock without drawing. */
void scroll_forward_one_line(Record *here)
{
    ScrollDeltaY += 1;
    ScrollingBackward = 0;
    if (ScrollSubRow == 0) enter_next_map_row_forward(here);
    ScrollSubRow = (ScrollSubRow - 1) & 0x0F;
    if (ScrollSubRow == 0 && LastTileStepBackward != 0) {
        MapScrollPos += MAP_ROW_BYTES;
        LevelScriptClock--;
    }
    if (ScrollWindowOffset == ScrollBandBytes) ScrollWindowOffset = ScrollWrapOffset;
    ScrollWindowOffset -= PlayfieldRowBytes;
}

/* Draws the row 13 rows up (DrawIncomingMapRow, backward), then MapScrollPos - 0Dh,
   LevelScriptClock + 1. */
void enter_previous_map_row_backward(Record *here)
{
#ifdef OVERKILL_HOST
    host_draw_map_row_into_scroll_band(draw_incoming_map_row(here));
#else
    frame_call_bp((main_routine)DrawMapRowIntoScrollBand, here);
#endif
    MapScrollPos -= MAP_ROW_BYTES;
    LevelScriptClock++;
    LastTileStepBackward = 1;
}

/* Mirror of scroll_forward_one_line; nothing but ScrollingBackward at MapScrollPos 0. */
void scroll_backward_one_line(Record *here)
{
    ScrollingBackward = 1;
    if (MapScrollPos == 0) return;
    ScrollDeltaY -= 1;
    if (ScrollSubRow == 0) enter_previous_map_row_backward(here);
    ScrollSubRow = (ScrollSubRow + 1) & 0x0F;
    if (ScrollSubRow == 0 && LastTileStepBackward != 1) {
        MapScrollPos -= MAP_ROW_BYTES;
        LevelScriptClock++;
    }
    if (ScrollWindowOffset == ScrollWrapOffset) ScrollWindowOffset = ScrollBandBytes;
    ScrollWindowOffset += PlayfieldRowBytes;
}

/* Item 3 and the level end: SmartBombRecord on every live pool A record, from
   PoolAPointers[34] down (sfx 8). */
void smart_bomb_all(void)
{
    word n;
    Record *r;

    if (SfxEnabled != 0) SfxRequest = 8;
    for (n = POOL_A_COUNT; n != 0; n--) {
        r = GAME_PTR(Record, PoolAPointers[n - 1]);
        if (r->status != 0) smart_bomb_record(r);
    }
}

/* Scrolls one line unless an encounter or the level end holds the map. On a row boundary:
   DAC colour 6 back to default at MAP_LAST_SPAWN_POS; at MAP_END_POS the level end starts
   (smart bomb, then the four type 53h records of Type53SpawnTable: a table entry is taken
   only by a record found; REC_DRAW_PASS, REC_FLASH_TIMER and REC_HIT_POINTS stay from the
   slot's last occupant). */
void scroll_forward_and_check_level_end(Record *here)
{
    word n;
    const word *spawn;
    Record *r;
#ifdef OVERKILL_HOST
    LevelDeparture departure;
#endif

    if (LevelEndPhase != LEVEL_END_OFF) return;
    if (EncounterLiveCount != 0 || EncounterEndDelay != 0) return;
    scroll_forward_one_line(here);
    if (ScrollSubRow != 0) return;
    if (MapScrollPos == MAP_LAST_SPAWN_POS) {
#ifdef OVERKILL_HOST
        host_set_dac_color6(DacColor6Default);
#else
        frame_call_bp((main_routine)SetDacColor6, (Record *)DacColor6Default);
#endif
    }
    if (MapScrollPos != MAP_END_POS) return;
    LevelEndPhase = LEVEL_END_TO_WAYPOINT_A;
    smart_bomb_all();
#ifdef OVERKILL_HOST
    overkill_level_departure(LevelIndex, &departure);
    spawn = departure.animated_parts;
#else
    spawn = GAME_PTR(word, GAME_OFFSET(Type53SpawnTable));
#endif
    for (n = 4; n != 0; n--) {
        r = find_free_record_pool_a();
        if (r == FRAME_NO_RECORD) continue;
        r->status = 1;
        r->size_class = 2;
        r->kind = KIND_ENEMY;
        r->type = 0x53;
        r->slot_index = 0xFFFF;
        r->y = spawn[0];
        r->x = spawn[1];
        r->sprite = spawn[2];
        r->sprite_base = spawn[2];
        spawn += 3;
    }
}

/* Level load: from MAP_END_POS scrolls back to MAP_START_POS, 16 lines at a time, then
   LevelScriptClock -= 3. */
void scroll_map_to_level_start(Record *here)
{
    word n;

    ScrollWindowOffset = ScrollStartOffset;
    ScrollSubRow = 0;
    ScrollingBackward = 0;
    LevelScriptClock = 0;
    MapScrollPos = MAP_END_POS;
    do {
        for (n = 0x10; n != 0; n--) scroll_backward_one_line(here);
    } while (MapScrollPos != MAP_START_POS);
    LevelScriptClock -= 3;
}

/* Checkpoint restart: for the 9Ch map bytes before MapScrollPos, every byte listed in the
   level's MapResetList (CS words {byte, routine}, FFFFh-terminated) is rewritten by that
   entry's routine: SetMapTile28 stores 28h, SetMapTile1 stores 1 (the lists name no
   other). */
void reset_map_before_view(void)
{
#ifdef OVERKILL_HOST
    const LevelCheckpointRestart *restart = overkill_level_checkpoint_restart(LevelIndex);
    if (restart) {
        overkill_restore_checkpoint_tiles(restart);
        return;
    }
#endif
    word off = MapScrollPos, n = 0x9C;
    word entry_offset;

    do {
        off--;
        entry_offset = FRAME_STATE_WORD(MapResetLists, (word)(LevelIndex << 1));
        for (;; entry_offset = (word)(entry_offset + 4)) {
            word map_value = FRAME_MAIN_WORD(entry_offset);
            word tile_handler;
            if (map_value == 0xFFFF) break;
            tile_handler = FRAME_MAIN_WORD((word)(entry_offset + 2));
            if (*FRAME_MAP_AT(off) == map_value) {
                *FRAME_MAP_AT(off) = tile_handler == (word)(main_routine)SetMapTile28 ? 0x28 : 1;
                break;
            }
        }
    } while (--n != 0);
}

/* After a lost life: the first of the level's checkpoints 0..2 whose next position is
   above MapScrollPos (unsigned), else checkpoint 3 (the oracle's fourth ReadCheckpoint
   compares one word past it, result unused); reloads the level map (keeping
   LevelScriptClock), resets the map bytes before the checkpoint view, scrolls back from
   MAP_RESTART_POS line by line until MapScrollPos <= the checkpoint (unsigned) on a row
   boundary (ScrollToCheckpoint), sets its clock and stores its script cursor in the
   level's LevelScriptCursors entry. */
void restart_at_checkpoint(Record *here)
{
    DosRegisters map_registers;
#ifdef OVERKILL_HOST
    LevelDef definition;
    LevelCheckpoint selection;
    word position, clock, saved;
#else
    word checkpoint = FRAME_STATE_WORD(LevelCheckpointPtrs, (word)(LevelIndex << 1));
    word n, position, clock, saved;
#endif

    /* BP was the record passed to the old MAIN call. ES is dead input here: the loader
       sets its buffer segment before any DOS service, and this routine returns no pair. */
    map_registers.bp = GAME_OFFSET(here);
    map_registers.es = 0;
#ifdef OVERKILL_HOST
    overkill_level_def(LevelIndex, &definition);
    overkill_select_checkpoint(definition.checkpoints, &selection);
    position = selection.map_position;
    clock = selection.script_clock;
#else
    for (n = 3; n != 0; n--, checkpoint = (word)(checkpoint + 8))
        if (MapScrollPos < FRAME_DS_WORD((word)(checkpoint + 6))) break;
    position = FRAME_DS_WORD(checkpoint);
    clock = FRAME_DS_WORD((word)(checkpoint + 2));
    CheckpointScriptCursor = FRAME_DS_WORD((word)(checkpoint + 4));
#endif
    saved = LevelScriptClock;
    load_level_map(&map_registers);
    LevelScriptClock = saved;
    MapScrollPos = position;
    reset_map_before_view();
    MapScrollPos = MAP_RESTART_POS;
    do {
        scroll_backward_one_line(here);
    } while (MapScrollPos > position || ScrollSubRow != 0);
    LevelScriptClock = clock;
#ifdef OVERKILL_HOST
    if (!overkill_level_timeline_restore_checkpoint())
#endif
    FRAME_DS_WORD(FRAME_STATE_WORD(CheckpointCursorPtrs, (word)(LevelIndex << 1))) =
        CheckpointScriptCursor;
}
