/* Enemy behaviour, translated from the frozen oracle (asm-semantic-oracle-v1): the
   REC_TYPE dispatch (RunTypeHandler) with the shared scroll/bounds/collision tail
   (ScrollRecordThenFinish, FinishRecordUpdate), the pickup update, the enemy handlers of
   the turrets, hatches, descenders, bouncers, crawlers, shooters, the formation members
   and the encounter director (types 14h..93h listed in the OWNS lines), and their helpers:
   aimed shots and the throttled child shot with its per-firer effects. Terrain movement
   is shared in c/terrain.c. Same state, same results; the oracle comments at each
   routine hold the original contracts.

   Handlers are written in the oracle's order of reads and writes: a spawned record may be
   the firing record itself when the fuzzer (or a freed slot) makes that possible.
   Every type dispatch target is now C, with direct calls across the gameplay regions.
   Remaining ASM callers reach this region through c/enemies.asm.

   Stale BX: SpawnThrottledChild returns BX unchanged when throttled, and several firers
   then write through it (see spawn_throttled_child); the C functions take and return
   that BX explicitly so the stray writes land where the oracle's do.

   UnusedTurnTowardPlayerStep has no reference in the oracle and is not translated; the
   dead `clc / ret` after Type53AnimateFromSpriteBase and the unreachable
   `jmp HorizontalTerrainPatrol` after Type57ScrollToY80ThenCrawl go with their ranges.

   SEGMENT: CGAME
   OWNS: SpawnAimedShot InitAimedShotRecord
   OWNS: Type24TurretLeftFire32 Type25TurretRightFire32 Type90TurretVolley Type91TurretVolleyAlt
   OWNS: TurretVolleyAnimateTail TurretVolleyShotCases TurretVolleyFireLower TurretVolleyFireUpper
   OWNS: TurretRemnantFlickerTail Type26TurretRemnant Type27SlowDescender Type28EnemyHatch
   OWNS: Type2EPlungeAtPlayerColumn SetPlungeTargetBelowPlayer Type2FScrollingShuttle
   OWNS: Type30AnimatedShooter Type31FallFast3 Type34SideFiringTurret Type37VerticalBouncerShooter
   OWNS: Type83PatrolShootDown64 Type38WallBounceDescend Type39DashRightAtRow80
   OWNS: Type3AHomeOnPlayerBelow80 Type3BFallRandomFlicker Type69JitterBelowY18 Type42DescendSway
   OWNS: Type49RadialBurstFaller Type4CSinkThenRise Type4DSinkRiseThenDash Type4FFallFast4Flicker
   OWNS: Type52ScrollOnly Type53AnimateFromSpriteBase Type48DescendAimedFire
   OWNS: Type93SweepDescendClimb Type21LeaderPath Type48CreeperBody Type93SweepBody
   OWNS: Type93BlockedTurnUp UpdatePickup CountLiveEnemies EncounterInvaderLevel
   OWNS: EncounterSegBossLevel Type21EncounterDirector FormationComplete EncounterSpawnInvader
   OWNS: EncounterSpawnFaller AssignNextFallerColumn Type23ColumnFaller Type2CAimedDrifter
   OWNS: Type20SlotHopperDropper Type20Cases Type20MoveAbovePlayer Type20StartDrop Type20Drop
   OWNS: Type20SlotHopper SteerToSavedTail Type1DSlotBobThenChase Type1EShuttleShooter
   OWNS: Type16SweepLeadIn Type18SweepPathLooper Type14FormationSwayDiver SpawnShotDown
   OWNS: Type19WallPatrolShooter HorizontalTerrainPatrol ScrollRecordThenFinish FinishRecordUpdate
   OWNS: Type01ExplosionAnimation ExplosionSizeCases UnusedTurnTowardPlayerStep SpawnChildAt12
   OWNS: SpawnThrottledChild InitChildRecord ShotSfxByType ShotSfx0B ShotSfx0C ShotSfx0E
   OWNS: ShotSfx11 ShotSfx12 ShotSfx13 ShotSfx14 ShotSfx15 ShotSfx1A ShotSfx1B ShotSfx1E ShotSfx18
   OWNS: RunTypeHandler TypeHandlers Type86LaunchAimedEnemy Type88WaitThenFireBurst
   OWNS: Type6AScrollUntilY50ThenType56 Type54ScrollUntilY_B0ThenType56 Type56CrawlDestroyOnBlock
   OWNS: Type55DropFast4 Type57ScrollToY80ThenCrawl IncrementRecordSprite
   OWNS: Type59ScrollThenAnimateThenType5A Type5ACrawlMirrorDiagonal Type5DDropFast8
   OWNS: Type5ECrawlTurnDownToLeft Type6ECrawlStaircase Type5FCrawlTurnDiagonalDown
   OWNS: Type61InvaderSteerToSlot Type62InvaderMarch Type65InvaderDiveFiring
   OWNS: Type63ScriptedSlideThenDrop Type64Drop4 Type6BDescendToX50 Type6DDescendToX70
   OWNS: Type6CDescendToX60Firing DescendToTargetX Type6FWaitThenType70 Type70CruiseFiring
   OWNS: Type72DescendFiringAimed Type73WaitThenRunRight Type74WaitThenRunLeft
   OWNS: Type85ChargeUntilBlocked Type92FireWhenPlayerOnRow Type92SpawnShot
   OWNS: Type75DescendSpreadShot InitSegBossPartRecord
*/
#include "enemies.h"
#include "hits.h"
#include "pods.h"
#include "paths.h"
#include "patrol.h"
#include "flyers.h"
#include "firers.h"
#include "terrain.h"
#ifdef OVERKILL_HOST
#include "level_encounter.h"
#include "level_invaders.h"
#include "level_boss.h"
#include "level_leaders.h"
#endif

/* c/movement.c */
void move_in_direction(Record *r, word n);
void steer_toward_target(Record *r);
word steer_to_saved(Record *r);
void set_delta_toward(Record *self, Record *target);
void aim_at_player(Record *r);
void step_along_delta(Record *r);
/* c/shots.c: the shot handlers (each with its own tail) */
void type02_timed_straight_shot(Record *s);
void type04_straight_shot(Record *s);
void type05_side_shot_up_left(Record *s);
void type06_side_shot_up_right(Record *s);
void type07_rising_shot3(Record *s);
void type08_rising_shot16(Record *s);
void type09_beam_link(Record *s);
void type0a_homing_missile(Record *m);
void type0b_aimed_enemy_shot(Record *s);
void type0c_timed_turn_up_shot(Record *s);
void type0f_timed_shot2(Record *s);
/* c/spawn.c */
Record *find_free_record_pool_a(void);
Record *spawn_enemy_here(Record *here);
Record *spawn_enemy_here_quiet(Record *here);
void type13_formation_leader(Record *r);
void type21_leader_path(Record *r);
/* c/frame.c: the frame region's record handlers and helpers */
void type50_steer_home(Record *r);
void seg_boss_part(Record *r, word part);
void type80_march_member(Record *r);
void step_hatch_ramp_frame(Record *r, word base);
void smart_bomb_all(void);
/* c/hits.c (hits.h): the burst descenders end in the scroll tail */
void type36_fall_then_burst(Record *r);
void type22_descend_then_burst(Record *r);

#define REC(bx) GAME_PTR(Record, bx)
/* PingPongFrames4 read at a byte offset (the oracle's `and bx, -2` forms). */
#define PING_PONG4_AT(off) (*GAME_PTR(word, (word)(GAME_OFFSET(PingPongFrames4) + (word)(off))))

/* ---- helpers ----------------------------------------------------------------------- */

/* A live 8x8 KIND_TYPED type 0Bh shot, sprite 31h, no timeout. */
void init_aimed_shot_record(Record *s)
{
    s->status = 1;
    s->player_shot = 0;
    s->direction = DIR_UP;
    s->sprite = 0x31;
    s->draw_pass = 1;
    s->size_class = 0;
    s->kind = KIND_TYPED;
    s->type = 0x0B;
    s->shot_timer = 0xFFFF;
}

/* An aimed type 0Bh shot from r (+0Ch, +0Ch; +1Ch, +8 during the segmented boss), sfx 1Ah;
   NO_RECORD when pool B is full. */
Record *spawn_aimed_shot(Record *r)
{
    Record *s = find_free_record_pool_b();
    word dx = 0x0C, dy = 0x0C;

    if (s == NO_RECORD) return s;
    if (SfxEnabled != 0) SfxRequest = 0x1A;
    if (SegBossActive == 1) {
        dx = 0x1C;
        dy = 8;
    }
    s->x = r->x + dx;
    s->y = r->y + dy;
    init_aimed_shot_record(s);
    aim_at_player(s);
    return s;
}

/* ShotSfxByType: the effect of a shot fired by `type`, indexed by type & 0Fh (type 92h
   uses entry 6, sfx 14h, directly). */
word enemies_shot_sfx(word type)
{
    if (type == 0x92) return 0x14;
    switch (type & 0x0F) {
    case 0x0: return 0x0B;
    case 0x1: return 0x0C;
    case 0x2: return 0x0E;
    case 0x3: return 0x11;
    case 0x4: return 0x12;
    case 0x5: return 0x13;
    case 0x6: return 0x14;
    case 0x7: return 0x15;
    case 0x8: return 0x1A;
    case 0x9: return 0x1B;
    case 0xA: return 0x1E;
    case 0xB: return 0x18;
    case 0xC: return 0x13;
    case 0xD: return 0x14;
    case 0xE: return 0x1B;
    default:  return 0x1A;
    }
}

/* InitChildRecord: the child c becomes a live 8x8 KIND_TYPED type 4 shot (sprite 30h, no
   timeout) at Y = y, heading like the parent. Unless the child's Y < 8 or the parent's
   Y > E0h (both unsigned: a negative child Y passes, a negative parent Y fails), the
   parent's REC_TYPE picks an effect (ShotSfxByType). The parent's fields are read after
   the child's writes, as in the oracle. */
Record *init_child_record(Record *parent, Record *c, word y)
{
    c->y = y;
    c->direction = parent->direction;
    c->status = 1;
    c->player_shot = 0;
    c->sprite = 0x30;
    c->draw_pass = 0;
    c->size_class = 0;
    c->kind = KIND_TYPED;
    c->type = 4;
    c->shot_timer = 0xFFFF;
    if (c->y < 8 || parent->y > 0xE0) return c;
    if (SfxEnabled != 0) SfxRequest = (byte)enemies_shot_sfx(parent->type);
    return c;
}

/* SpawnChildAt12: an unthrottled child at the parent's +0Ch, +0Ch. */
Record *spawn_child_at12(Record *parent)
{
    Record *c = find_free_record_pool_b();

    if (c == NO_RECORD) return c;
    c->x = parent->x + 0x0C;
    return init_child_record(parent, c, parent->y + 0x0C);
}

/* A child shot at the parent's +4, +4, on every 4th / 2nd / every call for
   DifficultySetting 0 / 1 / 2 (other values act as 0; one shared ChildSpawnThrottle,
   never reset). Returns the child, NO_RECORD (FFFFh) when pool B is full, or, when
   throttled, `bx` unchanged: the oracle returns with the caller's BX, and callers that
   test for FFFFh then write through that stale value (types 24h/25h, 62h, 92h, 18h). */
word spawn_throttled_child(Record *parent, word bx)
{
    Record *c;

    if (DifficultySetting != 2) {
        if (DifficultySetting == 1) {
            ChildSpawnThrottle = (byte)((ChildSpawnThrottle + 1) & 1);
            if (ChildSpawnThrottle == 0) return bx;
        } else {
            ChildSpawnThrottle = (byte)((ChildSpawnThrottle + 1) & 3);
            if (ChildSpawnThrottle != 0) return bx;
        }
    }
    c = find_free_record_pool_b();
    if (c == NO_RECORD) return 0xFFFF;
    c->x = parent->x + 4;
    return GAME_OFFSET(init_child_record(parent, c, parent->y + 4));
}

/* SpawnThrottledChild with REC_DIRECTION down for the call (restored after). */
word spawn_shot_down(Record *r, word bx)
{
    word direction = r->direction;

    r->direction = DIR_DOWN;
    bx = spawn_throttled_child(r, bx);
    r->direction = direction;
    return bx;
}

/* ---- the shared tail ------------------------------------------------------------------ */

/* FinishRecordUpdate: clamp X, then remove the record when REC_Y < -0C0h or >= 0F0h
   (signed; types 0, 26h, 28h, 29h, 34h, 48h, 86h and every record during the level end
   use -14h as the top bound; RemoveRecord ends the update); then, unless LevelEndPhase is
   set, body contact with the player and the player's shots (both also on a record the
   first has destroyed). */
void finish_record_update(Record *r)
{
    clamp_record_x(r);
    if (LevelEndPhase == LEVEL_END_OFF && r->type != 0 && r->type != 0x48 && r->type != 0x26
            && r->type != 0x86 && r->type != 0x28 && r->type != 0x29 && r->type != 0x34) {
        if ((sword)r->y < (sword)0xFF40 || (sword)r->y >= 0xF0) {
            remove_record(r);
            return;
        }
    } else if ((sword)r->y < -0x14 || (sword)r->y >= 0xF0) {
        remove_record(r);
        return;
    }
    if (LevelEndPhase == LEVEL_END_OFF) {
        check_record_hits_player(r);
        player_shots_hit_record(r);
    }
}

/* ScrollRecordThenFinish: move with the playfield scroll, then FinishRecordUpdate. The
   common tail of most handlers. */
void scroll_record_then_finish(Record *r)
{
    r->y += ScrollDeltaY;
    finish_record_update(r);
}

/* SteerToSavedTail: SteerToSaved at speed 2, heading reset to down, then the finish. */
void steer_to_saved_tail(Record *r)
{
    SteerSpeed = 2;
    steer_to_saved(r);
    r->direction = DIR_DOWN;
    finish_record_update(r);
}

/* ---- pickups, explosions --------------------------------------------------------------- */

/* KIND_PICKUP: falls 1 px per frame plus scroll; on contact CollectPickup frees it, and
   the scroll tail still runs on the freed record. */
void update_pickup(Record *r)
{
    r->y++;
    if (small_record_hits_player(r)) collect_pickup(r);
    scroll_record_then_finish(r);
}

/* Type 1: REC_ANIM_COUNTER advances every second frame (FrameParity 1), then the size
   class picks the frame routine (0 only scrolls; 1, 2: AnimateExplosion16/32, c/pods.c,
   which continue in the scroll tail unless the explosion ended). REC_SIZE_CLASS is 0..2
   (the oracle's table is unchecked). */
void type01_explosion_animation(Record *r)
{
    if (FrameParity != 1) {
        scroll_record_then_finish(r);
        return;
    }
    r->anim_counter++;
    switch (r->size_class) {
    case 0: scroll_record_then_finish(r); break;
    case 1: if (animate_explosion16(r)) scroll_record_then_finish(r); break;
    case 2: if (animate_explosion32(r)) scroll_record_then_finish(r); break;
    }
}

/* ---- turrets and hatches ---------------------------------------------------------------- */

/* Types 24h/25h: SpawnThrottledChild on FrameCount32 = 1Fh, the shot's sprite set after.
   A throttled spawn writes the sprite through the stale BX: RunTypeHandler's REC_TYPE * 2
   (48h/4Ah: DS:50h/52h, JoyCalCenterY / TimerVectorInstalled). Deliberate quirk. */
void enemies_wall_turret(Record *r, word shot_sprite)
{
    word bx;

    if (FrameCount32 == 0x1F) {
        bx = spawn_throttled_child(r, r->type << 1);
        if (bx != 0xFFFF) REC(bx)->sprite = shot_sprite;
    }
    scroll_record_then_finish(r);
}

void type24_turret_left_fire32(Record *r) { enemies_wall_turret(r, 0x1E); }
void type25_turret_right_fire32(Record *r) { enemies_wall_turret(r, 0x1A); }

/* Types 90h/91h (TurretVolleyAnimateTail): sprite = base + TurretPhaseTable[FrameCount128
   / 32] (phases 1, 0, 1, 2); on FrameCount32 = 1Fh phase 0 fires 4 px above, phase 2 4 px
   below, phase 1 not (TurretVolleyShotCases). FrameCount128 is 0..7Fh. */
void enemies_turret_volley(Record *r, word base)
{
    word phase;

    r->sprite = base;
    phase = TurretPhaseTable[FrameCount128 >> 5];
    r->sprite += phase;
    if (FrameCount32 == 0x1F) {
        if (phase == 0) {
            r->y -= 4;
            spawn_throttled_child(r, 0);
            r->y += 4;
        } else if (phase == 2) {
            r->y += 4;
            spawn_throttled_child(r, 4);
            r->y -= 4;
        }
    }
    scroll_record_then_finish(r);
}

void type90_turret_volley(Record *r) { enemies_turret_volley(r, LevelIndex == 4 ? 0x16C : 0x88); }
void type91_turret_volley_alt(Record *r) { enemies_turret_volley(r, LevelIndex == 4 ? 0x16F : 0x8B); }

/* Type 26h, what a destroyed wall turret leaves: at sprite 98h/92h it flickers (every 4th
   frame X snaps back to REC_SAVED_X, sprite - 1); otherwise it slides one terrain step
   and, when blocked or at X >= C0h, sprite + 1 with sfx 1Eh. */
void type26_turret_remnant(Record *r)
{
    if (r->sprite == 0x98 || r->sprite == 0x92) {
        if (FrameCount4 == 3) {
            r->x = r->saved_x;
            r->sprite--;
        }
    } else if (try_terrain_step(r) || r->x >= PLAYFIELD_MAX_X) {
        r->sprite++;
        if (SfxEnabled != 0) SfxRequest = 0x1E;
    }
    scroll_record_then_finish(r);
}

/* Type 27h: descends 1 px per frame plus scroll. */
void type27_slow_descender(Record *r)
{
    r->sprite = (SlowCount6 >> 1) + (LevelIndex == 5 ? 0x24 : 0x27);
    r->y++;
    scroll_record_then_finish(r);
}

/* Types 28h/2Ah: StepHatchRampFrame (c/frame.c, base 1Ch); at ramp phase 7 while
   EncounterLiveCount is 0 it steps the phase and releases a child at +8, +8 with 4 HP:
   29h (levels 1, 4), 2Bh aimed (level 2), 7Ah aimed (level 5), else a plain 14h. */
void type28_enemy_hatch(Record *r)
{
    Record *c;

    step_hatch_ramp_frame(r, 0x1C);
    if (EncounterLiveCount == 0 && r->direction == 7) {
        r->direction++;
        c = spawn_enemy_here(r);
        if (c != NO_RECORD) {
            c->hit_points = 4;
            c->y += 8;
            c->x += 8;
            if (LevelIndex == 1 || LevelIndex == 4) {
                c->type = 0x29;
                c->sprite = 0xA1;
            } else if (LevelIndex == 2) {
                c->type = 0x2B;
                c->sprite = 0xA5;
                aim_at_player(c);
            } else if (LevelIndex == 5) {
                c->type = 0x7A;
                c->sprite = 0x20;
                aim_at_player(c);
            }
        }
    }
    scroll_record_then_finish(r);
}

/* Type 34h: side-firing turret. Sprite by level (- 1 left of centre); fires every frame
   from FrameCount64 32h on (levels 0 and 6 only from Y 50h), sfx 13h, alternately
   straight and diagonally down (FrameParity) toward the centre. */
void type34_side_firing_turret(Record *r)
{
    word sprite = Type34SpriteByLevel[LevelIndex];

    r->sprite = sprite;
    if (r->x < PLAYFIELD_CENTER_X) {
        r->sprite--;
        if ((LevelIndex == 6 || LevelIndex == 0) && r->y < 0x50) goto done;
        if (FrameCount64 < 0x32) goto done;
        if (SfxEnabled != 0) SfxRequest = 0x13;
        r->direction = DIR_RIGHT;
        if (FrameParity != 1) r->direction = DIR_DOWN_RIGHT;
    } else {
        if ((LevelIndex == 6 || LevelIndex == 0) && r->y < 0x50) goto done;
        if (FrameCount64 < 0x32) goto done;
        if (SfxEnabled != 0) SfxRequest = 0x13;
        r->direction = DIR_LEFT;
        if (FrameParity != 1) r->direction = DIR_DOWN_LEFT;
    }
    spawn_throttled_child(r, sprite);
done:
    scroll_record_then_finish(r);
}

/* Type 86h: animates (Type86Frames by FrameCount64 / 16, the Dir6 set facing left) and
   in phase 2 at FrameCount64 26h launches an aimed type 60h enemy (sprite CBh). */
void type86_launch_aimed_enemy(Record *r)
{
    word phase = (FrameCount64 >> 4) << 1;
    Record *c;

    r->sprite = *GAME_PTR(word, (word)(GAME_OFFSET(r->direction == DIR_LEFT
            ? Type86FramesDir6 : Type86Frames) + phase));
    if (phase == 4 && FrameCount64 == 0x26) {
        c = spawn_enemy_here(r);
        if (c != NO_RECORD) {
            aim_at_player(c);
            c->sprite = 0xCB;
            c->type = 0x60;
        }
    }
    scroll_record_then_finish(r);
}

/* Type 88h: from Y 80h animates like 86h (Type88Frames) and fires in phase 2. */
void type88_wait_then_fire_burst(Record *r)
{
    word phase, sprite;

    if (r->y >= 0x80) {
        phase = (FrameCount64 >> 4) << 1;
        sprite = *GAME_PTR(word, (word)(GAME_OFFSET(r->direction == DIR_LEFT
                ? Type88FramesDir6 : Type88Frames) + phase));
        r->sprite = sprite;
        if (phase == 4) spawn_throttled_child(r, sprite);
    }
    scroll_record_then_finish(r);
}

/* Type 92h: when the player's Y (4-px aligned) equals (REC_Y + 14h) & ~3, fires a shot
   (sprite 44h) from Y - 4 and one from Y + 4. Throttled, the sprite goes through the
   stale BX: first the player row value (DS:row + 8: at player Y 4Ch..4Fh it zeroes
   SoundModuleLoaded), then the first call's result. Deliberate quirk. */
word type92_spawn_shot(Record *r, word bx)
{
    bx = spawn_throttled_child(r, bx);
    if (bx != 0xFFFF) REC(bx)->sprite = 0x44;
    return bx;
}

void type92_fire_when_player_on_row(Record *r)
{
    word row = (r->y + 0x14) & 0xFFFC;

    if ((PRIMARY->y & 0xFFFC) == row) {
        r->y -= 4;
        row = type92_spawn_shot(r, row);
        r->y += 8;
        type92_spawn_shot(r, row);
        r->y -= 4;
    }
    scroll_record_then_finish(r);
}

/* Type 75h: descends 2 px per frame; every 4 frames a three-way spread (down-left,
   down-right, down) of unthrottled children at +0Ch, heading restored after. */
void type75_descend_spread_shot(Record *r)
{
    word direction;

    r->y += 2;
    if (FrameCount4 == 3) {
        direction = r->direction;
        r->direction = DIR_DOWN_LEFT;
        spawn_child_at12(r);
        r->direction = DIR_DOWN_RIGHT;
        spawn_child_at12(r);
        r->direction = DIR_DOWN;
        spawn_child_at12(r);
        r->direction = direction;
    }
    scroll_record_then_finish(r);
}

/* ---- descenders, shooters, bouncers -------------------------------------------------- */

/* SetPlungeTargetBelowPlayer: REC_SAVED = (player X + 8 rounded down to even, 7530h), sfx 0Bh. */
void set_plunge_target_below_player(Record *r)
{
    if (SfxEnabled != 0) SfxRequest = 0x0B;
    r->saved_x = (PRIMARY->x + 8) & 0xFFFE;
    r->saved_y = 0x7530;
}

/* Type 2Eh: its target scrolls; random sprite; from Y 80h (signed) steers toward
   REC_SAVED at the SteerSpeed the previous handler left, targeting the player's column
   when exactly at Y 80h. No scroll once steering. */
void type2e_plunge_at_player_column(Record *r)
{
    r->saved_y += ScrollDeltaY;
    r->sprite = (next_random_word() & 3) + 0xAD;
    if ((sword)r->y < 0x80) {
        scroll_record_then_finish(r);
        return;
    }
    if (r->y == 0x80) set_plunge_target_below_player(r);
    steer_to_saved(r);
    finish_record_update(r);
}

/* Type 2Fh: steers to REC_SAVED at speed 2 (the target moves with the scroll); on the
   call that finds it there, REC_SAVED_X toggles between 0 and C0h. */
void type2f_scrolling_shuttle(Record *r)
{
    word arrived;

    r->sprite = 0x43;
    SteerSpeed = 2;
    arrived = steer_to_saved(r);
    r->saved_y += ScrollDeltaY;
    if (arrived) r->saved_x = r->saved_x == 0 ? PLAYFIELD_MAX_X : 0;
    scroll_record_then_finish(r);
}

/* Type 30h: animated shooter firing on FrameCount16 = 0Fh (level 5: FrameCount4 = 3, and
   frozen at sprite 46h unless the player's X is within 0Bh); sfx 0Eh after the shot,
   replacing the child's request (also when throttled). */
void type30_animated_shooter(Record *r)
{
    word dx, sprite;

    if (LevelIndex == 5) {
        dx = PRIMARY->x - r->x;
        if ((sword)dx < 0) dx = -dx;
        if (dx >= 0x0C && r->sprite == 0x46) goto done;
    }
    sprite = PingPongFrames4[SlowCount4] + 0x44;
    r->sprite = sprite;
    if (LevelIndex == 5 ? FrameCount4 == 3 : FrameCount16 == 0x0F) {
        spawn_throttled_child(r, sprite);
        if (SfxEnabled != 0) SfxRequest = 0x0E;
    }
done:
    scroll_record_then_finish(r);
}

/* Type 31h: falls 3 px per frame. */
void type31_fall_fast3(Record *r)
{
    r->sprite = 0x2E;
    r->y += 3;
    scroll_record_then_finish(r);
}

/* Type 37h: bounces between Y 8 and 90h (unsigned tests) at 1 px (X 60h), 3 (X 50h/70h)
   or 5 per frame, firing a child at each turn (at the bottom before turning up). */
void type37_vertical_bouncer_shooter(Record *r)
{
    r->sprite = SlowCount4 + 0xB5;
    Type37Speed = 1;
    if (r->x != PLAYFIELD_CENTER_X) {
        Type37Speed = 3;
        if (r->x != 0x50 && r->x != 0x70) Type37Speed = 5;
    }
    if (r->direction == DIR_DOWN) {
        r->y += Type37Speed;
        if (r->y >= 0x90) {
            spawn_throttled_child(r, 0);
            r->direction = DIR_UP;
        }
    } else {
        r->y -= Type37Speed;
        if (r->y <= 8) {
            r->direction = DIR_DOWN;
            spawn_throttled_child(r, 0);
        }
    }
    scroll_record_then_finish(r);
}

/* HorizontalTerrainPatrol: 1 px left or right, reversing at X 0/C0h or a blocked step;
   any heading but DIR_LEFT walks right. Ends in the scroll tail. */
void horizontal_terrain_patrol(Record *r)
{
    if (r->direction == DIR_LEFT) {
        r->direction = DIR_LEFT;
        if (r->x == 0 || try_terrain_step(r)) r->direction = DIR_RIGHT;
    } else {
        r->direction = DIR_RIGHT;
        if (r->x == PLAYFIELD_MAX_X || try_terrain_step(r)) r->direction = DIR_LEFT;
    }
    scroll_record_then_finish(r);
}

/* Type 83h: terrain patrol firing down every 64 frames. */
void type83_patrol_shoot_down64(Record *r)
{
    r->sprite = SlowCount4 + 0x10;
    if (FrameCount64 == 0x3F) spawn_shot_down(r, 0);
    horizontal_terrain_patrol(r);
}

/* Type 19h: terrain patrol firing down every 64 frames (sprite 36h based). */
void type19_wall_patrol_shooter(Record *r)
{
    r->sprite = SlowCount5 + 0x36;
    if (FrameCount64 == 0x3F) spawn_shot_down(r, 0);
    horizontal_terrain_patrol(r);
}

/* Type 38h: 2 px diagonal descent, turning down-right at X 0 and down-left at C0h. */
void type38_wall_bounce_descend(Record *r)
{
    if (r->x == 0) r->direction = DIR_DOWN_RIGHT;
    else if (r->x == PLAYFIELD_MAX_X) r->direction = DIR_DOWN_LEFT;
    r->sprite = 0x6E;
    move_in_direction(r, 2);
    scroll_record_then_finish(r);
}

/* Type 39h: scrolls to Y 80h (signed), then dashes right 4 px per frame (sfx 0Bh at Y 80h
   exactly) and is destroyed past X C0h (unsigned). */
void type39_dash_right_at_row80(Record *r)
{
    r->sprite = 0x6E;
    if ((sword)r->y >= 0x80) {
        if (r->y == 0x80 && SfxEnabled != 0) SfxRequest = 0x0B;
        r->direction = DIR_RIGHT;
        move_in_direction(r, 4);
        if (r->x > PLAYFIELD_MAX_X) destroy_record(r);
    }
    scroll_record_then_finish(r);
}

/* Type 3Ah: from Y 80h (signed) re-aims at the player every frame and steps toward it. */
void type3a_home_on_player_below80(Record *r)
{
    r->sprite = PingPongFrames4[SlowCount4] + 0xCC;
    if ((sword)r->y >= 0x80) {
        set_delta_toward(r, PRIMARY);
        step_along_delta(r);
    }
    scroll_record_then_finish(r);
}

/* Type 3Bh: falls 2 px per frame with a random sprite (base 152h on levels 0 and 6). */
void type3b_fall_random_flicker(Record *r)
{
    word n = next_random_word() & 3;

    r->sprite = n + (LevelIndex == 6 || LevelIndex == 0 ? 0x152 : 0xA9);
    r->y += 2;
    scroll_record_then_finish(r);
}

/* Type 69h: jitters one random axis (JitterAxisFields) by 4 px (+ on odd FrameCount64);
   pushed down 8 px whenever Y <= 18h (signed). */
void type69_jitter_below_y18(Record *r)
{
    word axis;

    r->sprite = (FrameCount16 >> 3) + (LevelIndex == 4 ? 0x178 : 0x103);
    axis = JitterAxisFields[next_random_word() & 1];
    *GAME_PTR(word, (word)(GAME_OFFSET(r) + axis)) += (((FrameCount64 & 1) << 1) - 1) << 2;
    if ((sword)r->y <= 0x18) r->y += 8;
    scroll_record_then_finish(r);
}

/* Type 42h: descends 1 px per frame, drifting left while FrameCount64 <= 1Fh, else right. */
void type42_descend_sway(Record *r)
{
    r->sprite = PingPongFrames4[SlowCount4] + 0xCF;
    r->y++;
    if (FrameCount64 > 0x1F) r->x++;
    else r->x--;
    scroll_record_then_finish(r);
}

/* Type 49h: falls 2 px per frame; every 16 frames up to eight aimed shots turned into
   type 4 shots in directions 7 down to 0 (stops when pool B is full). */
void type49_radial_burst_faller(Record *r)
{
    Record *s;
    word n;

    r->sprite = 0x1D;
    r->y += 2;
    if (FrameCount16 == 0x0F) {
        for (n = 8; n != 0; n--) {
            s = spawn_aimed_shot(r);
            if (s == NO_RECORD) break;
            s->type = 4;
            s->direction = n - 1;
        }
    }
    scroll_record_then_finish(r);
}

/* Type 4Ch: scrolls to Y B0h exactly, then (REC_DIRECTION up) rises 4 px per frame
   without the scroll. */
void type4c_sink_then_rise(Record *r)
{
    if (r->direction != DIR_UP) {
        r->sprite = 0x74;
        if (r->y != 0xB0) {
            scroll_record_then_finish(r);
            return;
        }
        r->direction = DIR_UP;
    }
    r->sprite = (FrameCount8 >> 2) + 0x73;
    r->y -= 4;
    finish_record_update(r);
}

/* Type 4Dh: scrolls to Y 80h exactly (REC_DIRECTION down = sinking), rises 4 px per frame
   without the scroll to Y 60h exactly, then becomes type 39h heading right and runs it. */
void type4d_sink_rise_then_dash(Record *r)
{
    r->sprite = 0x6E;
    if (r->direction == DIR_DOWN) {
        if (r->y != 0x80) {
            scroll_record_then_finish(r);
            return;
        }
        r->direction = DIR_UP;
    }
    r->y -= 4;
    if (r->y != 0x60) {
        finish_record_update(r);
        return;
    }
    r->direction = DIR_RIGHT;
    r->type = 0x39;
    type39_dash_right_at_row80(r);
}

/* Type 4Fh: falls 4 px per frame, sprite 80h + (FrameCount8 + record address +
   RecordTickCounter) & 7 (the address adds PoolA & 7, the same for every slot). */
void type4f_fall_fast4_flicker(Record *r)
{
    r->sprite = ((FrameCount8 + GAME_OFFSET(r) + RecordTickCounter) & 7) + 0x80;
    r->y += 4;
    scroll_record_then_finish(r);
}

/* Type 53h: animates from REC_SPRITE_BASE by FrameCount8 (0..7). */
void type53_animate_from_sprite_base(Record *r)
{
    r->sprite = PING_PONG4_AT(FrameCount8 & 0xFFFE) + r->sprite_base;
    scroll_record_then_finish(r);
}

/* Type48CreeperBody: sprite by level (1Ch on level 3, 22h + FrameCount8 / 2 else); level
   5 drifts 1 px toward the player's X (unsigned compare) with a ping-pong sprite; REC_Y + 1. */
void type48_creeper_body(Record *r)
{
    word sprite;

    if (LevelIndex == 5) {
        if (r->x < PRIMARY->x) r->x += 1;
        else if (r->x > PRIMARY->x) r->x -= 1;
        sprite = PING_PONG4_AT(SlowCount8 & 0xFFFE) + 0x26;
    } else if (LevelIndex == 3) {
        sprite = 0x1C;
    } else {
        sprite = (FrameCount8 >> 1) + 0x22;
    }
    r->sprite = sprite;
    r->y++;
}

/* Type 48h: the creeper body, then an aimed shot whenever pool B has room. */
void type48_descend_aimed_fire(Record *r)
{
    type48_creeper_body(r);
    spawn_aimed_shot(r);
    scroll_record_then_finish(r);
}

/* ---- crawlers and chargers ------------------------------------------------------------- */

/* Type 56h: three terrain steps per frame; destroyed when one is blocked. */
void type56_crawl_destroy_on_block(Record *r)
{
    if (try_terrain_step(r) || try_terrain_step(r) || try_terrain_step(r)) destroy_record(r);
    scroll_record_then_finish(r);
}

/* Types 6Ah/54h: scroll until Y is exactly 50h / B0h, then run as type 56h. */
void type6a_scroll_until_y50_then_type56(Record *r)
{
    if (r->y != 0x50) {
        scroll_record_then_finish(r);
        return;
    }
    r->type = 0x56;
    type56_crawl_destroy_on_block(r);
}

void type54_scroll_until_y_b0_then_type56(Record *r)
{
    if (r->y != 0xB0) {
        scroll_record_then_finish(r);
        return;
    }
    r->type = 0x56;
    type56_crawl_destroy_on_block(r);
}

/* Type 55h: while REC_DIRECTION is down (as its only spawner leaves it) drops 4 px per
   frame without the scroll; the scroll-to-B0h wait before it is unreachable in play. */
void type55_drop_fast4(Record *r)
{
    if (r->direction != DIR_DOWN) {
        r->sprite = 0x73;
        if (r->y != 0xB0) {
            scroll_record_then_finish(r);
            return;
        }
        r->direction = DIR_DOWN;
    }
    r->sprite = FrameCount8 + 0x77;
    r->y += 4;
    finish_record_update(r);
}

/* Types 57h/58h: scroll to Y 80h (unsigned), then two terrain steps per frame, only the
   second tested; blocked: DestroyRecord, which ends the update (no tail). At Y 80h
   exactly the sprite goes up by 1 (IncrementRecordSprite). */
void type57_scroll_to_y80_then_crawl(Record *r)
{
    if (r->y >= 0x80) {
        if (r->y == 0x80) r->sprite++;
        try_terrain_step(r);
        if (try_terrain_step(r)) {
            destroy_record(r);
            return;
        }
    }
    scroll_record_then_finish(r);
}

/* Sprite base of types 59h/5Ah: 148h on levels 0/6, 174h on level 4, else E3h. */
void enemies_crawler_sprite(Record *r)
{
    r->sprite = 0x148;
    if (LevelIndex == 0 || LevelIndex == 6) return;
    r->sprite = 0x174;
    if (LevelIndex == 4) return;
    r->sprite = 0xE3;
}

/* Type 5Ah: three terrain steps per frame; on a blocked step or at X <= 0 / >= C0h
   (signed) the diagonal is mirrored (XOR 6) and one more step is tried: still blocked,
   DestroyRecord ends the update. */
void type5a_crawl_mirror_diagonal(Record *r)
{
    enemies_crawler_sprite(r);
    r->sprite += FrameCount4;
    if (try_terrain_step(r) || try_terrain_step(r) || try_terrain_step(r)
            || (sword)r->x <= 0 || (sword)r->x >= PLAYFIELD_MAX_X) {
        r->direction ^= 6;
        if (try_terrain_step(r)) {
            destroy_record(r);
            return;
        }
    }
    scroll_record_then_finish(r);
}

/* Type 59h: scrolls to Y 80h, animates, and below Y C0h (signed) becomes type 5Ah. */
void type59_scroll_then_animate_then_type5a(Record *r)
{
    enemies_crawler_sprite(r);
    if ((sword)r->y > 0x80) {
        r->sprite += FrameCount4;
        if ((sword)r->y > 0xC0) {
            r->type = 0x5A;
            type5a_crawl_mirror_diagonal(r);
            return;
        }
    }
    scroll_record_then_finish(r);
}

/* Type 5Dh: drops 8 px per frame. */
void type5d_drop_fast8(Record *r)
{
    r->sprite = SlowCount8 + 0x77;
    r->y += 8;
    scroll_record_then_finish(r);
}

/* Type 5Eh: four terrain steps per frame, only the last tested; blocked: down turns
   down-left, down-left turns left, any other heading is destroyed (no tail). */
void type5e_crawl_turn_down_to_left(Record *r)
{
    try_terrain_step(r);
    try_terrain_step(r);
    try_terrain_step(r);
    if (try_terrain_step(r)) {
        if (r->direction == DIR_DOWN) r->direction = DIR_DOWN_LEFT;
        else if (r->direction == DIR_DOWN_LEFT) r->direction = DIR_LEFT;
        else {
            destroy_record(r);
            return;
        }
    }
    scroll_record_then_finish(r);
}

/* Type 6Eh: two terrain steps per frame (the second tested); blocked: down turns right,
   anything else turns down. */
void type6e_crawl_staircase(Record *r)
{
    r->sprite = PingPongFrames4[SlowCount4] + 0x128;
    try_terrain_step(r);
    if (try_terrain_step(r)) r->direction = r->direction == DIR_DOWN ? DIR_RIGHT : DIR_DOWN;
    scroll_record_then_finish(r);
}

/* Type 5Fh: once X + Y >= 60h (unsigned sum), four terrain steps per frame (the last
   tested); blocked: left turns down-right, right turns down-left, else destroyed. */
void type5f_crawl_turn_diagonal_down(Record *r)
{
    r->sprite = FrameCount4 + 0xF6;
    if ((word)(r->y + r->x) >= 0x60) {
        try_terrain_step(r);
        try_terrain_step(r);
        try_terrain_step(r);
        if (try_terrain_step(r)) {
            if (r->direction == DIR_LEFT) r->direction = DIR_DOWN_RIGHT;
            else if (r->direction == DIR_RIGHT) r->direction = DIR_DOWN_LEFT;
            else {
                destroy_record(r);
                return;
            }
        }
    }
    scroll_record_then_finish(r);
}

/* Type 85h: destroyed at the screen edge it heads for (C0h right, 0 left) or when the
   last of four terrain steps is blocked. */
void type85_charge_until_blocked(Record *r)
{
    if ((r->direction == DIR_RIGHT && r->x == PLAYFIELD_MAX_X)
            || (r->direction == DIR_LEFT && r->x == 0)) goto blocked;
    try_terrain_step(r);
    try_terrain_step(r);
    try_terrain_step(r);
    if (!try_terrain_step(r)) {
        scroll_record_then_finish(r);
        return;
    }
blocked:
    destroy_record(r);
    scroll_record_then_finish(r);
}

/* Types 73h/74h: scroll to Y 80h / 90h (unsigned), then charge right / left as 85h. */
void type73_wait_then_run_right(Record *r)
{
    if (r->y < 0x80) {
        scroll_record_then_finish(r);
        return;
    }
    r->direction = DIR_RIGHT;
    r->sprite = PingPongFrames4[SlowCount4] + 0x14C;
    type85_charge_until_blocked(r);
}

void type74_wait_then_run_left(Record *r)
{
    if (r->y < 0x90) {
        scroll_record_then_finish(r);
        return;
    }
    r->direction = DIR_LEFT;
    r->sprite = PingPongFrames4[SlowCount4] + 0x14F;
    type85_charge_until_blocked(r);
}

/* ---- descend-to-column shooters ------------------------------------------------------- */

/* DescendToTargetX: from Y 40h (unsigned) slides 2 px per frame toward DescentTargetX
   and descends 1 px; type 6Ch fires (every 4 frames at X 60h, else every 16). */
void descend_to_target_x(Record *r)
{
    if (r->y >= 0x40) {
        if (r->x != DescentTargetX) {
            if (r->x > DescentTargetX) r->x -= 2;
            else r->x += 2;
        }
        r->y++;
        if (r->type == 0x6C) {
            if (r->x == PLAYFIELD_CENTER_X) {
                if (FrameCount4 == 3) spawn_throttled_child(r, 0);
            } else if (FrameCount16 == 0x0F) spawn_throttled_child(r, 0);
        }
    }
    scroll_record_then_finish(r);
}

void type6b_descend_to_x50(Record *r)
{
    DescentTargetX = 0x50;
    r->sprite = (FrameCount16 >> 2) + 0x11F;
    descend_to_target_x(r);
}

void type6d_descend_to_x70(Record *r)
{
    DescentTargetX = 0x70;
    r->sprite = (FrameCount16 >> 2) + 0x124;
    descend_to_target_x(r);
}

void type6c_descend_to_x60_firing(Record *r)
{
    DescentTargetX = PLAYFIELD_CENTER_X;
    descend_to_target_x(r);
}

/* Type 70h: 2 px per frame in REC_DIRECTION, firing every 8 frames. */
void type70_cruise_firing(Record *r)
{
    r->sprite = (FrameCount16 >> 2) + 0x133;
    move_in_direction(r, 2);
    if (FrameCount8 == 7) spawn_throttled_child(r, 0);
    scroll_record_then_finish(r);
}

/* Type 6Fh: scrolls to Y 50h (unsigned); becomes type 70h (and runs it) unless the
   player is less than 20h below (unsigned difference). */
void type6f_wait_then_type70(Record *r)
{
    if (r->y < 0x50 || (word)(PRIMARY->y - r->y) < 0x20) {
        scroll_record_then_finish(r);
        return;
    }
    r->type = 0x70;
    type70_cruise_firing(r);
}

/* Type 72h: descends 1 px per frame, an aimed shot every other frame (FrameParity 1). */
void type72_descend_firing_aimed(Record *r)
{
    r->sprite = (FrameCount8 >> 1) + 0x1C;
    r->y++;
    if (FrameParity == 1) spawn_aimed_shot(r);
    scroll_record_then_finish(r);
}

/* ---- invaders (level 3) ---------------------------------------------------------------- */

/* Type 61h: steers to its slot (REC_SAVED) at speed 3; on the call that finds it there,
   becomes type 62h. */
void type61_invader_steer_to_slot(Record *r)
{
    SteerTargetY = r->saved_y;
    SteerTargetX = r->saved_x;
    SteerSpeed = 3;
    steer_toward_target(r);
    if (SteerArrived != 0) r->type = 0x62;
    scroll_record_then_finish(r);
}

/* Type 63h (and a diving 65h on its first frame): from Y 50h (unsigned) a scripted slide
   by sprite: E7h, E8h and EAh advance every 4 frames, E9h slides right 2 px until X is
   exactly 60h (from right of centre it slides to the clamp and never drops); any other
   sprite drops 4 px per frame. */
void type63_scripted_slide_then_drop(Record *r)
{
    if (r->y >= 0x50) {
        switch (r->sprite) {
        case 0xE7:
        case 0xE8:
        case 0xEA:
            if (FrameCount4 == 3) r->sprite++;
            break;
        case 0xE9:
            r->x += 2;
            if (r->x == PLAYFIELD_CENTER_X) r->sprite++;
            break;
        default:
            r->y += 4;
        }
    }
    scroll_record_then_finish(r);
}

/* Type 62h: marches with the Invader* block state, 1..10h px by EncounterLiveCount
   (X first aligned down to the step); an edge (X exactly C0h going right, 0 going left)
   sets the next reversal and a 2-px drop and fires an aimed shot. Below D0h (unsigned)
   it reverts to type 61h (slot Y 20h, X and Y aligned to 8) and steers this frame. At the
   player's X a 1/32 roll turns it into 65h, running 63h's code. It fires down (sprite
   63h) when RecordTickCounter & 7Fh = FrameCount128 and FrameCount4 = 0. A throttled shot
   writes the sprite through the stale BX: the edge value (C0h or 0), this frame's aimed
   shot, or the failed roll (1..1Fh). Deliberate quirk. */
void type62_invader_march(Record *r)
{
    word step, edge, left, bx;

    if (FramesSinceInvaderSpawn < 0x18) {
        scroll_record_then_finish(r);
        return;
    }
    r->y += InvaderDropStep;
    if (r->y > 0xD0) {
        r->sprite = 0xE7;
        r->type = 0x61;
        r->y &= 0xFFF8;
        r->x &= 0xFFF8;
        r->saved_y = 0x20;
        type61_invader_steer_to_slot(r);
        return;
    }
    if (EncounterLiveCount > 0x10) step = 1;
    else if (EncounterLiveCount > 8) step = 2;
    else if (EncounterLiveCount > 4) step = 4;
    else if (EncounterLiveCount > 1) step = 8;
    else step = 0x10;
    r->x &= -step;
    edge = PLAYFIELD_MAX_X;
    left = 1;
    if (InvaderMarchLeft != 0) {
        step = -step;
        edge = 0;
        left = 0;
    }
    bx = edge;
    r->x += step;
    if (r->x == edge) {
        InvaderNextMarchLeft = left;
        InvaderNextDropStep = 2;
        bx = GAME_OFFSET(spawn_aimed_shot(r));
    }
    if (r->x == PRIMARY->x) {
        bx = next_random_word() & 0x1F;
        if (bx == 0) {
            r->type = 0x65;
            type63_scripted_slide_then_drop(r);
            return;
        }
    }
    if ((RecordTickCounter & 0x7F) == FrameCount128 && FrameCount4 == 0) {
        RecordTickCounter++;
        r->direction = DIR_DOWN;
        bx = spawn_throttled_child(r, bx);
        if (bx != 0xFFFF) REC(bx)->sprite = 0x63;
    }
    scroll_record_then_finish(r);
}

/* Type 65h: dives 4 px per frame; every 4 frames, until sprite EBh, the sprite advances
   and an aimed shot is fired. */
void type65_invader_dive_firing(Record *r)
{
    r->y += 4;
    if (FrameCount4 == 3 && r->sprite != 0xEB) {
        r->sprite++;
        spawn_aimed_shot(r);
    }
    scroll_record_then_finish(r);
}

/* Type 64h: drops 4 px per frame (2 on level 4). */
void type64_drop4(Record *r)
{
    r->y += LevelIndex == 4 ? 2 : 4;
    scroll_record_then_finish(r);
}

/* ---- encounter director (type 21h) ------------------------------------------------------ */

/* AX of CountLiveEnemies: live KIND_ENEMY records in pool A (PoolAPointers). */
word count_live_enemies(void)
{
    word n, count = 0;
    Record *r;

    for (n = POOL_A_COUNT; n != 0; n--) {
        r = GAME_PTR(Record, PoolAPointers[n - 1]);
        if (r->status != 0 && r->kind == KIND_ENEMY) count++;
    }
    return count;
}

/* Write only the original boss initializer fields; draw pass and flash stay stale. */
#ifdef OVERKILL_HOST
static void init_seg_boss_member(Record *b, word hp, word x, word y)
{
    b->hit_points = hp;
    b->x = x;
    b->y = y;
    b->size_class = 2;
    b->slot_index = 0xFFFF;
    b->status = 1;
    b->kind = KIND_ENEMY;
}
#endif

void init_seg_boss_part_record(Record *b)
{
#ifdef OVERKILL_HOST
    LevelBoss boss;
    overkill_level_boss(LevelIndex, &boss);
    init_seg_boss_member(b, boss.hit_points, 0, 0);
#else
    b->hit_points = 0xC8;
    b->x = 0;
    b->y = 0;
    b->size_class = 2;
    b->slot_index = 0xFFFF;
    b->status = 1;
    b->kind = KIND_ENEMY;
#endif
}

/* The level 4 director (Type21LeaderPath): the far body in c/spawn.c, then the finish. */
void type21_leader_path_then_finish(Record *r)
{
    type21_leader_path(r);
    finish_record_update(r);
}

/* FormationComplete: the director leaves the encounter count and becomes a type 64h
   dropper (sprite 8Eh) at the player's X, Y 0. */
void formation_complete(Record *r)
{
    EncounterLiveCount--;
    r->type = 0x64;
    r->x = PRIMARY->x;
    r->y = 0;
    r->sprite = 0x8E;
    scroll_record_then_finish(r);
}

/* One type 61h invader (sprite E7h) at the next InvaderFormation slot (REC_SAVED = Y +
   20h, X), counted; at the formation's end the director completes instead. */
void encounter_spawn_invader(Record *r)
{
#ifdef OVERKILL_HOST
    LevelInvaders invaders;
    word cursor;
#else
    word *slot;
#endif
    Record *c;

    FramesSinceInvaderSpawn = 0;
    if (InvaderSlotCursor == GAME_OFFSET(InvaderFormationEnd)) {
        formation_complete(r);
        return;
    }
#ifdef OVERKILL_HOST
    cursor = InvaderSlotCursor;
    overkill_level_invaders(LevelIndex, &invaders);
#else
    slot = GAME_PTR(word, InvaderSlotCursor);
#endif
    c = spawn_enemy_here(r);
    if (c != NO_RECORD) {
#ifdef OVERKILL_HOST
        c->saved_y = overkill_invader_slot_word(invaders.slot_overrides, cursor) + 0x20;
        c->saved_x = overkill_invader_slot_word(invaders.slot_overrides, (word)(cursor + 2));
#else
        c->saved_y = GAME_INDEX(word, slot, 0) + 0x20;
        c->saved_x = GAME_INDEX(word, slot, 1);
#endif
        c->type = 0x61;
        c->sprite = 0xE7;
        EncounterLiveCount++;
        InvaderSlotCursor += 4;
    }
    finish_record_update(r);
}

/* REC_SAVED_X = the next FallerColumns entry (the cursor wraps at FallerColumnsEnd). */
void assign_next_faller_column(Record *c)
{
    word at = FallerColumnCursor;

    if (at >= GAME_OFFSET(FallerColumnsEnd)) {
        FallerColumnCursor = GAME_OFFSET(FallerColumns);
        at = FallerColumnCursor;
    }
    c->saved_x = *GAME_PTR(word, at);
    FallerColumnCursor = (word)(at + 2);
}

/* On FrameCount8 = 7 a quiet type 23h faller at the director (column top Y 10h): 1 HP on
   level 2; levels 1, 3, 5: invulnerable (FFFFh) with variant RecordTickCounter & 3 (the
   counter advances); other levels keep the spawn's 4 HP. */
void encounter_spawn_faller(Record *r)
{
    Record *c;
    word tick;
#ifdef OVERKILL_HOST
    LevelEncounter encounter;
#endif

    if (FrameCount8 == 7) {
        c = spawn_enemy_here_quiet(r);
        if (c != NO_RECORD) {
            assign_next_faller_column(c);
            c->saved_y = 0x10;
            c->type = 0x23;
#ifdef OVERKILL_HOST
            overkill_level_encounter(LevelIndex, &encounter);
            if (encounter.faller_hp_override) c->hit_points = encounter.faller_hit_points;
            if (encounter.faller_variant_tick) {
                tick = RecordTickCounter++;
                c->faller_variant = tick & 3;
            }
#else
            if (LevelIndex == 2) c->hit_points = 1;
            else if (LevelIndex == 1 || LevelIndex == 3 || LevelIndex == 5) {
                c->hit_points = 0xFFFF;
                tick = RecordTickCounter++;
                c->faller_variant = tick & 3;
            }
#endif
        }
    }
    finish_record_update(r);
}

/* Level 3: fallers until EncounterTicks 32h, a pause, and from 5Ah one invader per call. */
void encounter_invader_level(Record *r)
{
#ifdef OVERKILL_HOST
    LevelEncounter encounter;
    overkill_level_encounter(LevelIndex, &encounter);
    if (EncounterTicks < encounter.invader_fallers_until_tick) encounter_spawn_faller(r);
    else if (EncounterTicks < encounter.invaders_at_tick) finish_record_update(r);
#else
    if (EncounterTicks < 0x32) encounter_spawn_faller(r);
    else if (EncounterTicks < 0x5A) finish_record_update(r);
#endif
    else encounter_spawn_invader(r);
}

/* Level 0: once the director is the only live KIND_ENEMY in pool A, it becomes the
   segmented boss core (type 78h) and three parts (76h anchor, 77h, 79h) are made. Pool A
   full: EncounterLiveCount 0 and SmartBombAll, which also destroys this core; its
   ReleaseEncounterMember then explodes the stale part pointers. */
void encounter_seg_boss_level(Record *r)
{
    Record *b;
#ifdef OVERKILL_HOST
    LevelBoss boss;
#endif

    if (count_live_enemies() == 1) {
#ifdef OVERKILL_HOST
        overkill_level_boss(LevelIndex, &boss);
#endif
        SegBossX = 0;
        SegBossY = 0;
        SegBossActive = 1;
        SegBossPathCursor = GAME_OFFSET(BossPath);
        r->type = 0x78;
#ifdef OVERKILL_HOST
        r->sprite = boss.parts[BOSS_CORE].sprite;
        r->hit_points = boss.hit_points;
        r->x = boss.parts[BOSS_CORE].spawn_x;
        r->y = boss.parts[BOSS_CORE].spawn_y;
#else
        r->sprite = 0x22;
        r->hit_points = 0xC8;
        r->x = 0;
        r->y = 0;
#endif
        r->size_class = 2;
        r->slot_index = 0xFFFF;
        SegBossCore = GAME_OFFSET(r);
        b = find_free_record_pool_a();
        if (b == NO_RECORD) goto failed;
#ifdef OVERKILL_HOST
        init_seg_boss_member(b, boss.hit_points, boss.parts[BOSS_ANCHOR].spawn_x,
                             boss.parts[BOSS_ANCHOR].spawn_y);
#else
        init_seg_boss_part_record(b);
#endif
        b->type = 0x76;
#ifdef OVERKILL_HOST
        b->sprite = boss.parts[BOSS_ANCHOR].sprite;
#else
        b->sprite = 0x20;
#endif
        SegBossAnchor = GAME_OFFSET(b);
        b = find_free_record_pool_a();
        if (b == NO_RECORD) goto failed;
#ifdef OVERKILL_HOST
        /* The original writes zero X during initialization, then the side-part
           X after type and sprite. Keep both stages, including live aliases. */
        init_seg_boss_member(b, boss.hit_points, 0, boss.parts[BOSS_UPPER_RIGHT].spawn_y);
#else
        init_seg_boss_part_record(b);
#endif
        b->type = 0x77;
#ifdef OVERKILL_HOST
        b->sprite = boss.parts[BOSS_UPPER_RIGHT].sprite;
        b->x = boss.parts[BOSS_UPPER_RIGHT].spawn_x;
#else
        b->sprite = 0x21;
        b->x = 0x20;
#endif
        SegBossPart77 = GAME_OFFSET(b);
        b = find_free_record_pool_a();
        if (b == NO_RECORD) goto failed;
#ifdef OVERKILL_HOST
        init_seg_boss_member(b, boss.hit_points, 0, boss.parts[BOSS_LOWER_RIGHT].spawn_y);
#else
        init_seg_boss_part_record(b);
#endif
        b->type = 0x79;
#ifdef OVERKILL_HOST
        b->sprite = boss.parts[BOSS_LOWER_RIGHT].sprite;
        b->x = boss.parts[BOSS_LOWER_RIGHT].spawn_x;
#else
        b->sprite = 0x23;
        b->x = 0x20;
#endif
        SegBossPart79 = GAME_OFFSET(b);
    }
    finish_record_update(r);
    return;
failed:
    EncounterLiveCount = 0;
    smart_bomb_all();
    finish_record_update(r);
}

/* Type 21h, the encounter director: level 4 the leader path, level 3 fallers and
   invaders, level 0 the segmented boss; levels 1, 2, 5 (and 6) fallers until
   EncounterTicks C8h, then from F0h a type 22h burster at X 60h with 0Ah * (LevelIndex + 1)
   HP. */
void type21_encounter_director(Record *r)
{
#ifdef OVERKILL_HOST
    LevelEncounter encounter;
    overkill_level_encounter(LevelIndex, &encounter);
    if (encounter.kind == ENCOUNTER_LEADER_PATH) type21_leader_path_then_finish(r);
    else if (encounter.kind == ENCOUNTER_INVADER_FORMATION) encounter_invader_level(r);
    else if (encounter.kind == ENCOUNTER_SEGMENTED_BOSS) encounter_seg_boss_level(r);
    else if (EncounterTicks < encounter.burster_fallers_until_tick) encounter_spawn_faller(r);
    else {
        if (EncounterTicks >= encounter.burster_at_tick) {
            r->type = 0x22;
            r->sprite = encounter.burster_sprite;
            /* The original reads LevelIndex for HP after both record writes.
               A record can alias that state; keep this selection live. */
            overkill_level_encounter(LevelIndex, &encounter);
            r->hit_points = encounter.burster_hit_points;
            r->x = encounter.burster_x;
        }
        finish_record_update(r);
    }
#else
    if (LevelIndex == 4) type21_leader_path_then_finish(r);
    else if (LevelIndex == 3) encounter_invader_level(r);
    else if (LevelIndex == 0) encounter_seg_boss_level(r);
    else if (EncounterTicks < 0xC8) encounter_spawn_faller(r);
    else {
        if (EncounterTicks >= 0xF0) {
            r->type = 0x22;
            r->sprite = 0x71;
            r->hit_points = (LevelIndex + 1) * 0x0A;
            r->x = PLAYFIELD_CENTER_X;
        }
        finish_record_update(r);
    }
#endif
}

/* Type 23h: steers to its column top (SteerToSavedTail) until there exactly; sfx 1Dh
   while Y is 1Ch..20h; level 2 aims at the player and becomes type 2Ch; else falls by its
   FallerVariants entry {counter address, Y step} (FallerVariantsAlt on levels 3/5: counter
   / 2, base 6Dh; else base 80h), moving REC_SAVED_Y along. REC_FALLER_VARIANT is 0..3. */
void type23_column_faller(Record *r)
{
    word *variant, shift, base;
#ifdef OVERKILL_HOST
    LevelEncounter encounter;
#endif

    if (r->x != r->saved_x || r->y != r->saved_y) {
        steer_to_saved_tail(r);
        return;
    }
    if (r->y <= 0x20 && r->y >= 0x1C && SfxEnabled != 0) SfxRequest = 0x1D;
#ifdef OVERKILL_HOST
    overkill_level_encounter(LevelIndex, &encounter);
    if (encounter.faller_motion == FALLER_AIMED_DRIFT) {
#else
    if (LevelIndex == 2) {
#endif
        aim_at_player(r);
        r->type = 0x2C;
        finish_record_update(r);
        return;
    }
    variant = FallerVariants;
    shift = 0;
    base = 0x80;
#ifdef OVERKILL_HOST
    if (encounter.faller_motion == FALLER_ALTERNATE_ANIMATED) {
#else
    if (LevelIndex == 3 || LevelIndex == 5) {
#endif
        variant = FallerVariantsAlt;
        shift = 1;
        base = 0x6D;
    }
    variant = GAME_PTR(word, (word)(GAME_OFFSET(variant) + (r->faller_variant << 2)));
    r->sprite = (*GAME_PTR(word, variant[0]) >> shift) + base;
    r->y += variant[1];
    r->saved_y += variant[1];
    finish_record_update(r);
}

/* Type 2Ch: 2 px steps along REC_DELTA; no scroll and no X exit test. */
void type2c_aimed_drifter(Record *r)
{
    r->sprite = SlowCount4 + 0xB9;
    ChaseStepPixels = 2;
    step_along_delta(r);
    ChaseStepPixels = 3;
    finish_record_update(r);
}

/* ---- formation members ---------------------------------------------------------------- */

/* Type 20h in its slot: sprite by half; steers to the slot (SteerToSavedTail); from
   EncounterTicks 23h random aimed shots while RecordTickCounter is 2BCh..2D0h; with 3 or
   fewer left (or RecordTickCounter < 5: at the player's X) it starts the drop, which sets
   the global RecordTickCounter to 28h; else on FrameCount64 3Fh it hops to the next
   FormationSlots point that is not where it is. */
void type20_slot_hopper(Record *r)
{
    word *slot;
#ifdef OVERKILL_HOST
    const LevelLeaderSlot *owned_slot;
#endif

    r->sprite = r->x < PLAYFIELD_CENTER_X ? 0x7F - SlowCount6 : SlowCount6 + 0x7A;
    if (r->x != r->saved_x || r->y != r->saved_y) {
        steer_to_saved_tail(r);
        return;
    }
    if (EncounterTicks < 0x23) goto finish;
    if (RecordTickCounter >= 0x2BC && RecordTickCounter <= 0x2D0 && (next_random_word() & 1) == 0)
        spawn_aimed_shot(r);
    if (EncounterLiveCount <= 3) {
        if (FrameParity == 1) goto start_drop;
        goto target_player_x;
    }
    if (RecordTickCounter < 5) goto target_player_x;
    if (FrameCount64 != 0x3F) goto finish;
    do {
        slot = GAME_PTR(word, FormationSlotCursor);
#ifdef OVERKILL_HOST
        if (FormationSlotCursor >= overkill_leader_slot_limit()) {
            FormationSlotCursor = overkill_leader_slot_start();
            slot = GAME_PTR(word, FormationSlotCursor);
        }
        owned_slot = overkill_leader_slot(FormationSlotCursor);
        r->saved_y = (owned_slot ? owned_slot->y : GAME_INDEX(word, slot, 0)) + 0x20;
        r->saved_x = owned_slot ? owned_slot->x : GAME_INDEX(word, slot, 1);
        FormationSlotCursor = overkill_leader_slot_next(FormationSlotCursor);
#else
        if (FormationSlotCursor >= GAME_OFFSET(FormationSlotsEnd)) {
            FormationSlotCursor = GAME_OFFSET(FormationSlots);
            slot = GAME_PTR(word, FormationSlotCursor);
        }
        r->saved_y = GAME_INDEX(word, slot, 0) + 0x20;
        r->saved_x = GAME_INDEX(word, slot, 1);
        FormationSlotCursor = (word)(FormationSlotCursor + 4);
#endif
    } while (r->y == r->saved_y && r->x == r->saved_x);
    goto finish;
target_player_x:
    r->saved_x = PRIMARY->x + 8;
start_drop:
    r->saved_x &= 0xFFF8;
    RecordTickCounter = 0x28;
    r->dive_phase = 0;
    r->sprite = 0x78;
    r->saved_y = 0x20;
finish:
    finish_record_update(r);
}

/* Type 20h: REC_DIVE_PHASE FFFFh hops between slots; 0 moves above the player, 1 starts
   the drop (sprite 79h), 2 drops 4 px per frame (sprite 77h from Y A0h, unsigned). The
   phase is FFFFh or 0..2 (the oracle's Type20Cases is unchecked). */
void type20_slot_hopper_dropper(Record *r)
{
    switch (r->dive_phase) {
    case 0xFFFF:
        type20_slot_hopper(r);
        return;
    case 0:
        if (r->x != r->saved_x || r->y != r->saved_y) {
            steer_to_saved_tail(r);
            return;
        }
        r->dive_phase++;
        break;
    case 1:
        r->sprite = 0x79;
        r->dive_phase++;
        break;
    case 2:
        r->y += 4;
        if (r->y >= 0xA0) r->sprite = 0x77;
        break;
    }
    finish_record_update(r);
}

/* Type 1Dh: until EncounterTicks 28h steers to its slot at speed 1 (positions made even
   first); then bobs with SwayDirX, sinks 1 px every 8 frames and fires at three
   RecordTickCounter values; chases the player when 2 or fewer are left or below Y C0h
   (unsigned). */
void type1d_slot_bob_then_chase(Record *r)
{
    if (EncounterLiveCount <= 2 || r->y > 0xC0) {
        set_delta_toward(r, PRIMARY);
        step_along_delta(r);
        r->sprite = 0x76;
    } else if (EncounterTicks < 0x28) {
        SteerSpeed = 1;
        r->sprite = 0x75;
        r->saved_x &= 0xFFFE;
        r->x &= 0xFFFE;
        r->saved_y &= 0xFFFE;
        r->y &= 0xFFFE;
        if (steer_to_saved(r)) r->direction = DIR_DOWN;
    } else {
        if (RecordTickCounter == 0x2EF) spawn_aimed_shot(r);
        if (RecordTickCounter == 0x159) spawn_aimed_shot(r);
        if (RecordTickCounter == 0x79) spawn_aimed_shot(r);
        r->y -= SwayDirX;
        r->sprite = SwayDirX == 0xFFFF ? 0x75 : 0x76;
        if (FrameCount8 == 7) r->y++;
    }
    finish_record_update(r);
}

/* Type 1Eh: steers to REC_SAVED at speed 2; on the call that finds it there, an aimed
   shot and REC_SAVED_X toggles between 0 and C0h. */
void type1e_shuttle_shooter(Record *r)
{
    SteerSpeed = 2;
    if (steer_to_saved(r)) {
        spawn_aimed_shot(r);
        r->saved_x = r->saved_x == 0 ? PLAYFIELD_MAX_X : 0;
    }
    finish_record_update(r);
}

/* Types 16h/17h: steer to REC_SAVED (speed 2 on level 0, else 1; sprite 10Dh + heading);
   then REC_ENTRY_DELAY counts down, and its end moves the target to Y 20h (16h) or 40h
   (17h); with no delay left, EncounterTicks exactly 31h makes it type 18h. */
void type16_sweep_lead_in(Record *r)
{
    word arrived;

    SteerSpeed = 1;
    if (LevelIndex == 0) SteerSpeed = 2;
    arrived = steer_to_saved(r);
    r->sprite = r->direction + 0x10D;
    if (arrived) {
        if (r->entry_delay != 0) {
            if (--r->entry_delay == 0) {
                r->saved_y = 0x20;
                if (r->type != 0x16) r->saved_y = 0x40;
            }
        } else if (EncounterTicks == 0x31) r->type = 0x18;
    }
    finish_record_update(r);
}

/* Type 18h: walks the REC_PATH waypoints (Y + 20h, X; FFFFh then an address = jump) at
   speed 3, re-entering itself after each arrival within the frame; an aimed shot when
   RecordTickCounter & 3FFh = 0Ch; after each arrival a 1/8 roll fires a child and sets
   its heading down. A throttled child writes DIR_DOWN through the stale BX = 2 (DS:8).
   Deliberate quirk. */
void type18_sweep_path_looper(Record *r)
{
    word *path, bx;

    for (;;) {
        if ((RecordTickCounter & 0x3FF) == 0x0C) {
            spawn_aimed_shot(r);
            RecordTickCounter++;
        }
        path = GAME_PTR(word, r->path);
        if (GAME_INDEX(word, path, 0) == 0xFFFF) {
            r->path = GAME_INDEX(word, path, 1);
            continue;
        }
        SteerTargetY = GAME_INDEX(word, path, 0) + 0x20;
        SteerTargetX = GAME_INDEX(word, path, 1);
        SteerSpeed = 3;
        steer_toward_target(r);
        r->sprite = r->direction + 0x10D;
        if (SteerArrived == 0) break;
        r->path = (word)(r->path + 4);
        bx = next_random_word() & 7;
        if (bx != 2) continue;
        bx = spawn_throttled_child(r, bx);
        if (bx != 0xFFFF) REC(bx)->direction = DIR_DOWN;
    }
    finish_record_update(r);
}

/* Type 14h: sways its slot (REC_SAVED += SwayDirX, SwayDropY; below D0h back to Y 20h)
   once LeaderScript13End is reached; in its slot it dives at the player when fewer than
   6 are left or on a RecordTickCounter tick (& FFh = FFh; & 7Fh = 7Fh at difficulty 2);
   out of the slot below it (unsigned) it keeps stepping, fires on FrameCount64 3Fh when
   fewer than 6 are left and wraps to Y 10h below D0h; above it steers back at speed 1
   (positions made even). */
void type14_formation_sway_diver(Record *r)
{
    word tick;

#ifdef OVERKILL_HOST
    if (LeaderScriptCursor == overkill_leader_end(GAME_OFFSET(LeaderScript13End))) {
#else
    if (LeaderScriptCursor == GAME_OFFSET(LeaderScript13End)) {
#endif
        if (RecordTickCounter == 0x2EF) {
            spawn_aimed_shot(r);
            RecordTickCounter++;
        }
        r->saved_x += SwayDirX;
        r->saved_y += SwayDropY;
        if (r->saved_y > 0xD0) r->saved_y = 0x20;
        if ((word)(r->x + SwayDirX) != r->saved_x || r->y != r->saved_y) {
            if (r->y <= r->saved_y) {
                SteerTargetX = r->saved_x & 0xFFFE;
                r->x &= 0xFFFE;
                SteerTargetY = r->saved_y & 0xFFFE;
                r->y &= 0xFFFE;
                SteerSpeed = 1;
                steer_toward_target(r);
            } else {
                step_along_delta(r);
                if (EncounterLiveCount < 6 && FrameCount64 == 0x3F) spawn_aimed_shot(r);
                if (r->y > 0xD0) r->y = 0x10;
            }
            finish_record_update(r);
            return;
        }
        if (EncounterLiveCount >= 6) {
            tick = RecordTickCounter;
            if (DifficultySetting == 2) {
                if ((tick & 0x7F) != 0x7F) goto set_sprite;
            } else if ((tick & 0xFF) != 0xFF) goto set_sprite;
            RecordTickCounter++;
        }
        set_delta_toward(r, PRIMARY);
        step_along_delta(r);
        r->y += 2;
    }
set_sprite:
    r->sprite = SlowCount4 + 0x1C;
    finish_record_update(r);
}

/* ---- the type 93h sweeper ------------------------------------------------------------ */

/* Type93BlockedTurnUp: counts a blocked climb and turns diagonally up toward the centre;
   returns the oracle's ZF (X exactly 60h), which its last caller tests. */
word type93_blocked_turn_up(Record *r)
{
    r->blocked_climbs++;
    r->direction = DIR_UP_LEFT;
    if (r->x > PLAYFIELD_CENTER_X) return 0;
    r->direction = DIR_UP_RIGHT;
    return r->x == PLAYFIELD_CENTER_X;
}

/* `n` terrain steps (heading already set), results ignored. */
void enemies_terrain_steps(Record *r, word n)
{
    do try_terrain_step(r); while (--n);
}

/* Up to four terrain steps in `direction`; a blocked one turns to `reverse` and stops. */
void enemies_sweep_steps(Record *r, word direction, word reverse)
{
    word n = 4;

    r->direction = direction;
    do {
        if (try_terrain_step(r)) {
            r->direction = reverse;
            return;
        }
    } while (--n);
}

/* Type93SweepBody: waits for LeaderScript7DEnd and REC_ENTRY_DELAY; heading down it
   descends four terrain steps (only the 4th tested) and turns up when blocked or at Y D0h
   (unsigned); climbing takes three steps, each blocked one counting (Type93BlockedTurnUp);
   a free third step (or a blocked one at X 60h) resets the counter and heads straight up;
   at Y <= 20h it turns sideways (by X & 2) and sweeps: sprite by FrameCount16, five steps
   down on Type93KilledPulse, a down shot when RecordTickCounter & FFh = FFh, an aimed shot
   at 0 and 2BDh, five steps down at X 0 / C0h, then up to four steps sideways, reversing
   when blocked. From Y 80h (unsigned) it heads down. */
void type93_sweep_body(Record *r)
{
    word zf, direction;

#ifdef OVERKILL_HOST
    if (LeaderScriptCursor != overkill_leader_end(GAME_OFFSET(LeaderScript7DEnd))) goto check_dive_row;
#else
    if (LeaderScriptCursor != GAME_OFFSET(LeaderScript7DEnd)) goto check_dive_row;
#endif
    if (r->entry_delay != 0 && --r->entry_delay != 0) goto check_dive_row;
    direction = r->direction;
    if (direction == DIR_UP || direction == DIR_UP_RIGHT || direction == DIR_UP_LEFT) goto climb;
    if (direction != DIR_DOWN) goto sweep;
    enemies_terrain_steps(r, 3);
    if (!try_terrain_step(r) && r->y < 0xD0) return;
    r->direction = DIR_UP;
climb:
    if (try_terrain_step(r)) type93_blocked_turn_up(r);
    if (try_terrain_step(r)) type93_blocked_turn_up(r);
    zf = 1;
    if (try_terrain_step(r)) zf = type93_blocked_turn_up(r);
    if (zf) {
        r->blocked_climbs = 0;
        r->direction = DIR_UP;
    }
    if (r->y > 0x20) return;
    r->direction = DIR_LEFT;
    if (r->x & 2) r->direction = DIR_RIGHT;
sweep:
    r->sprite = (FrameCount16 >> 3) + 0x16A;
    if (Type93KilledPulse != 0) {
        direction = r->direction;
        r->direction = DIR_DOWN;
        enemies_terrain_steps(r, 5);
        r->direction = direction;
    }
    if ((RecordTickCounter & 0xFF) == 0xFF) {
        spawn_shot_down(r, 0);
        RecordTickCounter++;
    }
    if (RecordTickCounter == 0 || RecordTickCounter == 0x2BD) {
        spawn_aimed_shot(r);
        RecordTickCounter++;
    }
    if (r->x == 0) {
        r->direction = DIR_DOWN;
        enemies_terrain_steps(r, 5);
        enemies_sweep_steps(r, DIR_RIGHT, DIR_LEFT);
    } else if (r->x == PLAYFIELD_MAX_X) {
        r->direction = DIR_DOWN;
        enemies_terrain_steps(r, 5);
        enemies_sweep_steps(r, DIR_LEFT, DIR_RIGHT);
    } else if (r->direction == DIR_LEFT) {
        enemies_sweep_steps(r, DIR_LEFT, DIR_RIGHT);
    } else {
        enemies_sweep_steps(r, DIR_RIGHT, DIR_LEFT);
    }
check_dive_row:
    if (r->y >= 0x80) r->direction = DIR_DOWN;
}

/* Type 93h: the sweep body; destroyed after 100 blocked climbs (unsigned). */
void type93_sweep_descend_climb(Record *r)
{
    type93_sweep_body(r);
    if (r->blocked_climbs >= 0x64) destroy_record(r);
    finish_record_update(r);
}

/* ---- the dispatch --------------------------------------------------------------------- */

/* RunTypeHandler (REC_KIND 2 and 4): DispatchRecordX/Y = the record's position, then its
   REC_TYPE handler (TypeHandlers, 0..94h: the oracle's table is unchecked). All
   handlers call their C helpers and shared tails directly. */
void run_type_handler(Record *r)
{
    DispatchRecordX = r->x;
    DispatchRecordY = r->y;
    switch (r->type) {
    case 0x00: case 0x0D: case 0x0E: case 0x82: case 0x94:
        scroll_record_then_finish(r); break;
    case 0x01: type01_explosion_animation(r); break;
    case 0x02: case 0x03: type02_timed_straight_shot(r); break;
    case 0x04: type04_straight_shot(r); break;
    case 0x05: type05_side_shot_up_left(r); break;
    case 0x06: type06_side_shot_up_right(r); break;
    case 0x07: type07_rising_shot3(r); break;
    case 0x08: type08_rising_shot16(r); break;
    case 0x09: type09_beam_link(r); break;
    case 0x0A: type0a_homing_missile(r); break;
    case 0x0B: type0b_aimed_enemy_shot(r); break;
    case 0x0C: type0c_timed_turn_up_shot(r); break;
    case 0x0F: type0f_timed_shot2(r); break;
    case 0x10: start_path_follower(r, GAME_OFFSET(SteerPath10)); break;
    case 0x11: start_path_follower(r, GAME_OFFSET(SteerPath11)); break;
    case 0x12: update_path_follower(r); break;
    case 0x13: case 0x15: case 0x1C: case 0x1F: case 0x7D: case 0x7E:
        type13_formation_leader(r);
        finish_record_update(r);
        break;
    case 0x14: type14_formation_sway_diver(r); break;
    case 0x16: case 0x17: type16_sweep_lead_in(r); break;
    case 0x18: type18_sweep_path_looper(r); break;
    case 0x19: type19_wall_patrol_shooter(r); break;
    case 0x1A: wall_patrol(r, 0x24); break;
    case 0x1B: wall_patrol(r, 0x27); break;
    case 0x1D: type1d_slot_bob_then_chase(r); break;
    case 0x1E: type1e_shuttle_shooter(r); break;
    case 0x20: type20_slot_hopper_dropper(r); break;
    case 0x21: type21_encounter_director(r); break;
    case 0x22: case 0x35:
        type22_descend_then_burst(r);
        scroll_record_then_finish(r);
        break;
    case 0x23: type23_column_faller(r); break;
    case 0x24: type24_turret_left_fire32(r); break;
    case 0x25: type25_turret_right_fire32(r); break;
    case 0x26: type26_turret_remnant(r); break;
    case 0x27: type27_slow_descender(r); break;
    case 0x28: case 0x2A: type28_enemy_hatch(r); break;
    case 0x29: type29_emerge_then_dart(r); break;
    case 0x2B: animated_aim_line_flyer(r, SlowCount4 + 0xA5); break;
    case 0x2C: type2c_aimed_drifter(r); break;
    case 0x2D: hover_fire_plunge(r, SlowCount4 + 0x93); break;
    case 0x2E: type2e_plunge_at_player_column(r); break;
    case 0x2F: type2f_scrolling_shuttle(r); break;
    case 0x30: type30_animated_shooter(r); break;
    case 0x31: type31_fall_fast3(r); break;
    case 0x32: type32_descend_then_bounce(r); break;
    case 0x33: type33_terrain_bouncer(r); break;
    case 0x34: type34_side_firing_turret(r); break;
    case 0x36:
        type36_fall_then_burst(r);
        scroll_record_then_finish(r);
        break;
    case 0x37: type37_vertical_bouncer_shooter(r); break;
    case 0x38: type38_wall_bounce_descend(r); break;
    case 0x39: type39_dash_right_at_row80(r); break;
    case 0x3A: type3a_home_on_player_below80(r); break;
    case 0x3B: type3b_fall_random_flicker(r); break;
    case 0x3C: type3c_descend_then_bounce(r); break;
    case 0x3D: type3d_animated_bouncer(r); break;
    case 0x3E: type3e_drop_then_dash(r); break;
    case 0x3F: fly_along_aim_line(r); break;
    case 0x40: jitter_fall_shooter(r, 0xCF); break;
    case 0x41: start_path_follower(r, GAME_OFFSET(Type41Path)); break;
    case 0x42: type42_descend_sway(r); break;
    case 0x43: start_path_follower(r, GAME_OFFSET(Type43Path)); break;
    case 0x44: start_path_follower(r, GAME_OFFSET(Type44Path)); break;
    case 0x45: start_path_follower(r, GAME_OFFSET(Type45Path)); break;
    case 0x46: hover_fire_plunge(r, SlowCount6 + 0x4B); break;
    case 0x47: patrol_shoot_down32(r, SlowCount6 + 0x51); break;
    case 0x48: type48_descend_aimed_fire(r); break;
    case 0x49: type49_radial_burst_faller(r); break;
    case 0x4A: start_path_follower(r, GAME_OFFSET(Type4APath)); break;
    case 0x4B: type4b_descend_then_bounce(r); break;
    case 0x4C: type4c_sink_then_rise(r); break;
    case 0x4D: type4d_sink_rise_then_dash(r); break;
    case 0x4E: type4e_animated_descender(r); break;
    case 0x4F: type4f_fall_fast4_flicker(r); break;
    case 0x50: type50_steer_home(r); break;          /* no finish tail */
    case 0x51: start_path_follower(r, GAME_OFFSET(Type51Path)); break;
    case 0x52: scroll_record_then_finish(r); break;   /* Type52ScrollOnly */
    case 0x53: type53_animate_from_sprite_base(r); break;
    case 0x54: type54_scroll_until_y_b0_then_type56(r); break;
    case 0x55: type55_drop_fast4(r); break;
    case 0x56: type56_crawl_destroy_on_block(r); break;
    case 0x57: case 0x58: type57_scroll_to_y80_then_crawl(r); break;
    case 0x59: type59_scroll_then_animate_then_type5a(r); break;
    case 0x5A: type5a_crawl_mirror_diagonal(r); break;
    case 0x5B: type5b_scroll_then_rise(r); break;
    case 0x5C: type5c_rise_fast4(r); break;
    case 0x5D: type5d_drop_fast8(r); break;
    case 0x5E: type5e_crawl_turn_down_to_left(r); break;
    case 0x5F: type5f_crawl_turn_diagonal_down(r); break;
    case 0x60: fly_along_aim_line(r); break;
    case 0x61: type61_invader_steer_to_slot(r); break;
    case 0x62: type62_invader_march(r); break;
    case 0x63: type63_scripted_slide_then_drop(r); break;
    case 0x64: type64_drop4(r); break;
    case 0x65: type65_invader_dive_firing(r); break;
    case 0x66: start_path_follower(r, GAME_OFFSET(PathType66)); break;
    case 0x67: start_path_follower(r, GAME_OFFSET(PathType67)); break;
    case 0x68: jitter_fall_shooter(r, LevelIndex == 4 ? 0x24 : LevelIndex == 5 ? 0xA1 : 0x100); break;
    case 0x69: type69_jitter_below_y18(r); break;
    case 0x6A: type6a_scroll_until_y50_then_type56(r); break;
    case 0x6B: type6b_descend_to_x50(r); break;
    case 0x6C: type6c_descend_to_x60_firing(r); break;
    case 0x6D: type6d_descend_to_x70(r); break;
    case 0x6E: type6e_crawl_staircase(r); break;
    case 0x6F: type6f_wait_then_type70(r); break;
    case 0x70: type70_cruise_firing(r); break;
    case 0x71: hover_fire_plunge(r, SlowCount8 + 0x12B); break;
    case 0x72: type72_descend_firing_aimed(r); break;
    case 0x73: type73_wait_then_run_right(r); break;
    case 0x74: type74_wait_then_run_left(r); break;
    case 0x75: type75_descend_spread_shot(r); break;
    case 0x76: case 0x77: case 0x78: case 0x79:
        seg_boss_part(r, r->type - 0x76);
        scroll_record_then_finish(r);
        break;
    case 0x7A: animated_aim_line_flyer(r, FrameCount4 + 0x20); break;
    case 0x7B: type7b_drop_then_aim(r); break;
    case 0x7C: animated_aim_line_flyer(r, FrameCount4 + 0x15C); break;
    case 0x7F: enter_march_slot(r); break;
    case 0x80:
        type80_march_member(r);
        finish_record_update(r);
        break;
    case 0x81: enter_sweeper_slot(r); break;
    case 0x83: type83_patrol_shoot_down64(r); break;
    case 0x84: type84_lurk_until_aligned(r); break;
    case 0x85: type85_charge_until_blocked(r); break;
    case 0x86: type86_launch_aimed_enemy(r); break;
    case 0x87: animated_fire_burst(r, 0xDD); break;
    case 0x88: type88_wait_then_fire_burst(r); break;
    case 0x89: patrol_shoot_down32(r, SlowCount4 + 0x1C); break;
    case 0x8A: patrol_shoot_down32(r, SlowCount4 + 0x9D); break;
    case 0x8B: case 0x8C: case 0x8D: case 0x8E: climbing_walker(r, r->type); break;
    case 0x8F: animated_fire_burst(r, 0xBF); break;
    case 0x90: type90_turret_volley(r); break;
    case 0x91: type91_turret_volley_alt(r); break;
    case 0x92: type92_fire_when_player_on_row(r); break;
    case 0x93: type93_sweep_descend_climb(r); break;
    }
}
