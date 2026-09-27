/* Per-frame gameplay drivers, translated from the frozen oracle (asm-semantic-oracle-v1):
   the record pass (UpdateAllRecords with the march / type 93h / segmented-boss frame
   state, UpdateRecordByKind), the handlers of types 50h, 76h..79h (the segmented boss)
   and 80h (the invader marcher), the frame timers (TickFrameTimers, fuel drain and
   refuel, UpdateRefuelTimersAndScore, the hatch ramp step) and the map scroll (forward
   and backward line steps, map row entry, the level end, checkpoints, the level start
   scroll, SmartBombAll). Same state, same results; see the oracle comments at each
   routine for the original contracts.

   Platform code stays ASM and is called through the trampolines: the score and fuel
   gauge drawing (DrawScore, DrawFuelGauge), the map row drawing into the scroll band
   (DrawMapRowIntoScrollBand; its spawn part is C in c/spawn.c), the starfield (MoveStars),
   SetDacColor6, the music request and the level map load. The REC_KIND handlers are C
   (c/enemies.c, c/pods.c) and called directly, except UpdateExhaust (ASM), which is
   entered by label with BP = record, as the oracle's KindHandlers table does.

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
*/
#include "game.h"
#include "hits.h"
#include "enemies.h"
#include "pods.h"

#define FRAME_NO_RECORD ((Record *)0xFFFF)

void steer_toward_target(Record *r);           /* c/movement.c */
Record *find_free_record_pool_a(void);         /* c/spawn.c */

/* CS-resident words of MAIN. */
extern word __far LevelMapSegment;             /* segment of the level map */
extern word __far ScrollBandBytes;             /* scroll geometry, set per video adapter */
extern word __far ScrollWrapOffset;
extern word __far ScrollStartOffset;
extern word __far PlayfieldRowBytes;
/* The MapResetList tables are CS data of MAIN; MapResetLists (DS) holds their offsets. */
extern word __far MapResetList0[];

#define FRAME_MAP_AT(off) (((__segment)LevelMapSegment) :> ((byte __based(void) *)(off)))

/* Remaining ASM, entered through the thunks in c/frame.asm (CGAME): FRAME_CALL_BP calls
   the MAIN routine at AX with BP = SI (SI passes through too) and returns the BP the
   routine leaves; every register but BP is the routine's. */
word frame_call_bp(main_routine target, Record *r);
#pragma aux frame_call_bp "FRAME_CALL_BP" parm [ax] [si] value [ax] modify exact [ax bx cx dx si di es]
/* RequestModuleMusic (AL = tune; takes its input in AX, so through FarCallMainNearViaBP). */
void frame_request_music(word tune);
#pragma aux frame_request_music "FRAME_REQUEST_MUSIC" parm [ax] modify exact [ax bx es]
/* MoveStars (far, FAR0F7F): the starfield step, platform. */
void frame_move_stars(void);
#pragma aux frame_move_stars "MoveStars" far modify exact [ax cx si]

extern void UpdateExhaust(void);              /* the record handler still in ASM */
extern void DrawScore(void);                  /* platform: text output */
extern void DrawFuelGauge(void);              /* platform: gauge drawing */
extern void DrawMapRowIntoScrollBand(void);   /* BP = spawn origin (DrawIncomingMapRow) */
extern void SetDacColor6(void);               /* SI = RGB triple */
extern void LoadLevelMap(void);
extern void SetMapTile28(void);               /* MapResetList targets (bridge labels) */
extern void SetMapTile1(void);

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
    if (live > 0x10) delay = 0x78;
    else if (live > 8) delay = 0x64;
    else if (live > 4) delay = 0x50;
    else if (live > 2) delay = 0x3C;
    else delay = 0x28;
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
        anchor = (Record *)SegBossAnchor;
        anchor->x = SegBossX;
        anchor->y = SegBossY;
        for (;;) {
            point = (word *)SegBossPathCursor;
            if (point[0] != 0xFFFF) break;
            SegBossPathCursor = (word)BossPath;
        }
        SteerTargetY = point[0] + 0x20;
        SteerTargetX = point[1];
        SteerSpeed = 2;
        steer_toward_target(anchor);
        SegBossX = anchor->x;
        SegBossY = anchor->y;
        if (SteerArrived == 0) return;
        SegBossPathCursor = (word)(point + 2);
    }
}

/* KindHandlers: the record's REC_KIND handler (0..6; the oracle's table is unchecked and
   no other kind is ever stored). Returns the BP the handler leaves: the record itself for
   every handler but UpdateExhaust (ASM), which may leave another (KIND_PLAYER is a bare
   ret). */
word frame_update_record_by_kind(Record *r)
{
    switch (r->kind) {
    case KIND_SCENERY: scroll_record_then_finish(r); break;
    case KIND_POD:     update_pod(r); break;
    case KIND_TYPED:
    case KIND_ENEMY:   run_type_handler(r); break;
    case KIND_PICKUP:  update_pickup(r); break;
    case KIND_EXHAUST: return frame_call_bp((main_routine)UpdateExhaust, r);
    }
    return (word)r;
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

    if (FramesSinceInvaderSpawn != 0xFFFF) FramesSinceInvaderSpawn++;
    InvaderMarchLeft = InvaderNextMarchLeft;
    InvaderDropStep = InvaderNextDropStep;
    InvaderNextDropStep = 0;
    if (LevelIndex == 5) {
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
                if (live > 0x10) delay = 0x0A;
                else if (live > 8) delay = 6;
                else if (live > 4) delay = 4;
                else delay = 1;
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
        r = (Record *)PoolAPointers[n - 1];
        if (++RecordTickCounter >= 0x5DC) RecordTickCounter = 0;
        if (r->status != 0) frame_update_record_by_kind(r);
    }
    SwayDropY = 0;
    for (n = POOL_B_COUNT; n != 0; n--) {
        r = (Record *)PoolBPointers[n - 1];
        bp = (word)r;
        if (r->status != 0) bp = frame_update_record_by_kind(r);
    }
    frame_move_stars();
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
    word *offset = BossPartOffsets + 2 * part;

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

    if (LeaderScriptCursor != (word)LeaderScript7EEnd) return;
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
    frame_call_bp((main_routine)DrawFuelGauge, PRIMARY);
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
        frame_request_music(MapScrollPos < MAP_MUSIC_CHANGE_POS ? LevelMusicTable[(byte)LevelIndex] : MUSIC_LATE_LEVEL);
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
    frame_call_bp((main_routine)DrawFuelGauge, PRIMARY);
}

/* Refuel, timers, then the score text; returns the BP DrawScore leaves (ScoreBcd, the
   oracle's exit BP). */
word update_refuel_timers_and_score(void)
{
    tick_refuel();
    tick_frame_timers();
    return frame_call_bp((main_routine)DrawScore, PRIMARY);
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
    r->sprite = ((direction & 0xFF00) | Type28FrameRamp[direction & 0xFF]) + base;
}

/* ---- the map scroll ---------------------------------------------------------------------- */

/* Draws the map row at MapScrollPos (spawning its objects, c/spawn.c), then MapScrollPos
   + 0Dh, LevelScriptClock - 1. Sfx 7 up to MAP_INTRO_END_POS; MUSIC_LEVEL_END when the
   clock reaches 4. */
void enter_next_map_row_forward(Record *here)
{
    frame_call_bp((main_routine)DrawMapRowIntoScrollBand, here);
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
    frame_call_bp((main_routine)DrawMapRowIntoScrollBand, here);
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
        r = (Record *)PoolAPointers[n - 1];
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
    word n, *spawn;
    Record *r;

    if (LevelEndPhase != LEVEL_END_OFF) return;
    if (EncounterLiveCount != 0 || EncounterEndDelay != 0) return;
    scroll_forward_one_line(here);
    if (ScrollSubRow != 0) return;
    if (MapScrollPos == MAP_LAST_SPAWN_POS) frame_call_bp((main_routine)SetDacColor6, (Record *)DacColor6Default);
    if (MapScrollPos != MAP_END_POS) return;
    LevelEndPhase = LEVEL_END_TO_WAYPOINT_A;
    smart_bomb_all();
    spawn = Type53SpawnTable;
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
    word off = MapScrollPos, n = 0x9C;
    word __far *entry;

    do {
        off--;
        entry = (word __far *)(((__segment)MapResetList0) :> ((word __based(void) *)MapResetLists[LevelIndex]));
        for (; *entry != 0xFFFF; entry += 2) {
            if (*FRAME_MAP_AT(off) == *entry) {
                *FRAME_MAP_AT(off) = entry[1] == (word)(main_routine)SetMapTile28 ? 0x28 : 1;
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
    word *checkpoint = (word *)LevelCheckpointPtrs[LevelIndex];
    word n, position, clock, saved;

    for (n = 3; n != 0; n--, checkpoint += 4)
        if (MapScrollPos < checkpoint[3]) break;
    position = checkpoint[0];
    clock = checkpoint[1];
    CheckpointScriptCursor = checkpoint[2];
    saved = LevelScriptClock;
    frame_call_bp((main_routine)LoadLevelMap, here);
    LevelScriptClock = saved;
    MapScrollPos = position;
    reset_map_before_view();
    MapScrollPos = MAP_RESTART_POS;
    do {
        scroll_backward_one_line(here);
    } while (MapScrollPos > position || ScrollSubRow != 0);
    LevelScriptClock = clock;
    *(word *)CheckpointCursorPtrs[LevelIndex] = CheckpointScriptCursor;
}
