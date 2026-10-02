/* Shots and player energy, translated from the frozen oracle (asm-semantic-oracle-v1):
   the ship's terrain-contact damage and energy/tank loss, the player and enemy shot
   handlers (types 02h..0Ch, 0Fh) with their shared hit/scroll/bounds tails. Grid probes,
   terrain steps and climbing-walker probes are shared in c/terrain.c. Same state, same
   results; see the oracle comments at each routine for the original contracts.

   SEGMENT: CGAME
   OWNS: DamagePlayerOnTerrainContact DamagePlayerEnergy
   OWNS: LosePlayerEnergyTank CheatRefill
   OWNS: ShotScrollAndBounds ShotBoundsCheck ExpireShot UnusedDescendShot Type08RisingShot16
   OWNS: Type07RisingShot3 Type09BeamLink Type0FTimedShot2 Type0CTimedTurnUpShot
   OWNS: Type06SideShotUpRight Type05SideShotUpLeft Type04StraightShot Type02TimedStraightShot
   OWNS: Type0AHomingMissile Type0BAimedEnemyShot ShotHitPlayerCheck
*/
#include "game.h"
#include "enemies.h"
#include "pods.h"
#include "terrain.h"

/* c/movement.c */
void move_in_direction(Record *r, word n);
void steer_toward_target(Record *r);
void set_delta_toward(Record *self, Record *target);
void step_along_delta(Record *r);

/* ASM that stays in MAIN, reached through FarCallMainNearViaAX (c/game.h). BP-input
   routines go through the near thunk CALL_MAIN_BP in c/shots.asm (BP = SI around the far
   call), not an inline pragma: Watcom's cross-jump optimisation merges the tail of an
   inline `call far ptr` with another copy and drops its segment fixup (it corrupted the
   second RemoveRecord call of shot_bounds_check, since moved to C: c/pods.c). */
extern void RedrawEnergyGauge(void);     /* platform: the energy gauge (keeps BP) */
Record *find_missile_target(void);
void call_main(main_routine target);
#pragma aux call_main "FarCallMainNearViaAX" far parm [ax] modify exact [ax bx cx dx si di es]
void call_main_bp(main_routine target, Record *r);
#pragma aux call_main_bp "CALL_MAIN_BP" parm [ax] [si] modify exact [ax bx cx dx si di es]

/* LosePlayerEnergyTank (also the tail of an emptied bar): ignored in
   LEVEL_END_TO_WAYPOINT_A or while dying; difficulty 0 ignores every second loss
   (EasyHitToggle). Losing the last tank kills the ship (form 3) unless AllCheatsFlag
   refills (CheatRefill: the gauge is then not redrawn). */
void lose_player_energy_tank(void)
{
    if (LevelEndPhase == LEVEL_END_TO_WAYPOINT_A || PRIMARY->sprite >= 3) return;
    if (SfxEnabled) SfxRequest = 3;
    if (DifficultySetting == 0) {
        EasyHitToggle = (EasyHitToggle + 1) & 1;
        if (EasyHitToggle) return;
    }
    if (--EnergyTanks == 0xFFFF) {
        EnergyPoints = 0;
        if (AllCheatsFlag == 1) {
            EnergyTanks = 3;
            EnergyPoints = 0x18;
            return;
        }
        PRIMARY->sprite = 3;
        if (SfxEnabled) SfxRequest = 0x19;
    }
    call_main(RedrawEnergyGauge);
}

/* One hit: ignored in LEVEL_END_TO_WAYPOINT_A, while dying or with no tank left (FFFFh);
   flash 8 and EnergyPoints -= 1/2/3 by difficulty, each step 16-bit (a bar at 0 wraps and
   does not empty). Reaching 0 refills the bar and loses a tank. */
void damage_player_energy(void)
{
    if (LevelEndPhase == LEVEL_END_TO_WAYPOINT_A || PRIMARY->sprite >= 3 || EnergyTanks == 0xFFFF) return;
    PRIMARY->flash_timer = 8;
    if (SfxEnabled) SfxRequest = 0x0F;
    if (DifficultySetting != 0) {
        if (DifficultySetting != 1 && --EnergyPoints == 0) goto bar_empty;
        if (--EnergyPoints == 0) goto bar_empty;
    }
    if (--EnergyPoints != 0) {
        call_main(RedrawEnergyGauge);
        return;
    }
bar_empty:
    EnergyPoints = 0x18;
    lose_player_energy_tank();
}

/* BP = PrimaryRecord: terrain contact costs 2, 3 or 4 hits by DifficultySetting. */
void damage_player_on_terrain_contact(Record *ship)
{
    if (!probe_ship_terrain_collision(ship)) return;
    if (DifficultySetting != 0) {
        if (DifficultySetting != 1) damage_player_energy();
        damage_player_energy();
    }
    damage_player_energy();
    damage_player_energy();
}

/* ShotBoundsCheck: removes the shot unless 8 <= Y <= E0h and X <= C8h (unsigned), or when
   a KIND_TYPED type 2/4/5/6/8/9/0Ch shot is over a cell of attribute exactly 1 (not in
   the demo). */
void shot_bounds_check(Record *s)
{
    if (s->y < 8 || s->y > 0xE0 || s->x > 0xC8) {
        remove_record(s);
        return;
    }
    if (s->kind != KIND_TYPED) return;
    switch (s->type) {
    case 2: case 4: case 5: case 6: case 8: case 9: case 0x0C: break;
    default: return;
    }
    if (DemoActive == 1) return;
    if (map_attribute(compute_record_grid_offset(s) + MAP_ROW_BYTES) == 1) remove_record(s);
}

void shot_scroll_and_bounds(Record *s)
{
    s->y += ScrollDeltaY;
    shot_bounds_check(s);
}

/* Removal through the bounds test (Y = FFFFh). */
void expire_shot(Record *s)
{
    s->y = 0xFFFF;
    shot_bounds_check(s);
}

/* An enemy shot within PY-2..PY+12h (signed) and PX..PX+14h (unsigned; before this frame's
   scroll) costs 1 hit, a type 3 shot 1/3/5 by difficulty, and is used up even when the hit
   is ignored. Player shots (REC_PLAYER_SHOT 1) and misses take the scroll and bounds tail. */
void shot_hit_player_check(Record *s)
{
    word top, left, hits;

    if (s->player_shot != 1) {
        top = PRIMARY->y - 2;
        left = PRIMARY->x;
        if ((sword)s->y >= (sword)top && (sword)s->y <= (sword)(top + 0x14)
                && s->x >= left && s->x <= (word)(left + 0x14)) {
            hits = 1;
            if (s->type == 3 && DifficultySetting != 0) hits = DifficultySetting == 1 ? 3 : 5;
            do damage_player_energy(); while (--hits);
            expire_shot(s);
            return;
        }
    }
    shot_scroll_and_bounds(s);
}

/* No reference in the oracle: 2 px down, then the player-hit test. */
void unused_descend_shot(Record *s)
{
    s->y += 2;
    shot_hit_player_check(s);
}

/* Types 02h/03h: 8 px per frame until REC_SHOT_TIMER runs out, then the hit test. */
void type02_timed_straight_shot(Record *s)
{
    if (--s->shot_timer == 0) {
        expire_shot(s);
        return;
    }
    move_in_direction(s, 8);
    shot_hit_player_check(s);
}

/* 4 px per frame (8 on level 0 unless heading down), then the hit test. */
void type04_straight_shot(Record *s)
{
    move_in_direction(s, LevelIndex == 0 && s->direction != DIR_DOWN ? 8 : 4);
    shot_hit_player_check(s);
}

/* Side shots rise 4 px per frame. On a probe column (05h: X mod 16 = 0; 06h: X mod 16 = 8)
   a cell of attribute exactly 1 beside the shot turns it straight up for this frame (not
   in the demo); otherwise it drifts 4 px sideways. Expiry at X = 0 / C8h is equality only. */
void type05_side_shot_up_left(Record *s)
{
    if (s->x == 0) {
        expire_shot(s);
        return;
    }
    s->y -= 4;
    if ((s->x & 0x0F) == 0 && DemoActive != 1) {
        word attribute = map_attribute(compute_record_grid_offset(s) + MAP_ROW_BYTES - 1);
        s->direction = DIR_UP;
        if (attribute == 1) goto set_sprite;
    }
    s->direction = DIR_UP_LEFT;
    s->x -= 4;
set_sprite:
    s->sprite = s->direction + 8;
    shot_scroll_and_bounds(s);
}

void type06_side_shot_up_right(Record *s)
{
    if (s->x == 0xC8) {
        expire_shot(s);
        return;
    }
    s->y -= 4;
    if ((s->x & 0x0F) == 8 && DemoActive != 1) {
        word attribute = map_attribute(compute_record_grid_offset(s) + MAP_ROW_BYTES + 1);
        s->direction = DIR_UP;
        if (attribute == 1) goto set_sprite;
    }
    s->direction = DIR_UP_RIGHT;
    s->x += 4;
set_sprite:
    s->sprite = ((FrameCount4 << 2) & 8) + s->direction + 8;
    shot_scroll_and_bounds(s);
}

/* Rises 3 px per frame (no scroll); counted in ShotsLiveMain. */
void type07_rising_shot3(Record *s)
{
    s->sprite = FrameCount4 + 0x5A;
    s->y -= 3;
    shot_bounds_check(s);
}

/* Rises 16 px per frame; counted in ShotsLiveMain. */
void type08_rising_shot16(Record *s)
{
    s->y -= 0x10;
    shot_bounds_check(s);
}

/* A beam link (UpdateBeam positions it): only the bounds tail. */
void type09_beam_link(Record *s)
{
    shot_bounds_check(s);
}

/* Homing missile. Locked: 3 px Bresenham chase of REC_TARGET with scroll; a lost target
   (freed, Y > DCh unsigned, type 1; no KIND check) unlocks it. Unlocked: speed-2 steer to
   the player + (0Ah, 0Ch) on a 4-px grid, no scroll; on arrival it relocks (sfx 11h) or
   expires. */
void type0a_homing_missile(Record *m)
{
    Record *t;
    word found;

    m->sprite = FrameCount8 + 0x6D;
    if (m->missile_locked == 1) {
        t = (Record *)m->target;
        if (t->status == 0 || t->y > 0xDC || t->type == 1) {
            m->missile_locked = 0;
        } else {
            set_delta_toward(m, t);
            step_along_delta(m);
        }
        shot_scroll_and_bounds(m);
        return;
    }
    SteerTargetY = (PRIMARY->y + 0x0A) & 0xFFFC;
    SteerTargetX = (PRIMARY->x + 0x0C) & 0xFFFC;
    SteerSpeed = 2;
    m->x &= 0xFFFC;
    m->y &= 0xFFFC;
    steer_toward_target(m);
    if (SteerArrived != 0) {
        if (MissilesLive != 0) MissilesLive--;
        found = (word)find_missile_target();
        if (found == 0xFFFF) {
            expire_shot(m);
            return;
        }
        m->target = found;
        m->missile_locked = 1;
        if (SfxEnabled) SfxRequest = 0x11;
        MissilesLive++;
    }
    shot_bounds_check(m);
}

/* 3 px Bresenham steps along REC_DELTA, then the hit test. */
void type0b_aimed_enemy_shot(Record *s)
{
    step_along_delta(s);
    shot_hit_player_check(s);
}

/* 3 px per frame in REC_DIRECTION while REC_SHOT_TIMER counts down; when it runs out the
   shot turns up and also rises 2 px per frame (5 px up in all). */
void type0c_timed_turn_up_shot(Record *s)
{
    if (s->shot_timer == 0) {
        s->y -= 2;
    } else if (--s->shot_timer == 0) {
        s->direction = DIR_UP;
        s->y -= 2;
    }
    s->sprite = s->direction + 0x28;
    move_in_direction(s, 3);
    shot_bounds_check(s);
}

/* 2 px per frame until REC_SHOT_TIMER runs out, then the hit test. */
void type0f_timed_shot2(Record *s)
{
    s->sprite = FrameCount16 >> 1;
    if (--s->shot_timer == 0) {
        expire_shot(s);
        return;
    }
    move_in_direction(s, 2);
    shot_hit_player_check(s);
}
