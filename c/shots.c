/* Shots, terrain probes and player energy, translated from the frozen oracle
   (asm-semantic-oracle-v1): the level-map grid helpers, the ship's terrain contact and
   energy/tank loss, the player and enemy shot handlers (types 02h..0Ch, 0Fh) with their
   shared hit/scroll/bounds tails, the 1-px terrain steps behind TryTerrainStep and the
   climbing walkers' wall probe. Same state, same results; see the oracle comments at each
   routine for the original contracts.

   SEGMENT: CGAME
   OWNS: ProbeShipTerrainCollision ReadIndexedByteAttribute GridOffsetNegativeY
   OWNS: ComputeRecordGridOffset DamagePlayerOnTerrainContact DamagePlayerEnergy
   OWNS: LosePlayerEnergyTank CheatRefill
   OWNS: ShotScrollAndBounds ShotBoundsCheck ExpireShot UnusedDescendShot Type08RisingShot16
   OWNS: Type07RisingShot3 Type09BeamLink Type0FTimedShot2 Type0CTimedTurnUpShot
   OWNS: Type06SideShotUpRight Type05SideShotUpLeft Type04StraightShot Type02TimedStraightShot
   OWNS: TerrainStepInDirection TerrainStepCases TerrainStepBlocked TerrainStepDownRight
   OWNS: TerrainStepDown TerrainStepUpLeft TerrainStepUp TerrainStepUpRight TerrainStepRight
   OWNS: TerrainStepDownLeft TerrainStepLeft
   OWNS: Type0AHomingMissile Type0BAimedEnemyShot ShotHitPlayerCheck
   OWNS: ClimbWalkerBlocked ClimbWalkerStep ProbeOverlapsWalker
*/
#include "game.h"
#include "pods.h"

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
extern void TryTerrainStep(void);        /* BP = record */
extern void FindMissileTarget(void);     /* BX out, clobbers CX */
void call_main(main_routine target);
#pragma aux call_main "FarCallMainNearViaAX" far parm [ax] modify exact [ax bx cx dx si di es]
void call_main_bp(main_routine target, Record *r);
#pragma aux call_main_bp "CALL_MAIN_BP" parm [ax] [si] modify exact [ax bx cx dx si di es]
word call_main_bx(main_routine target);
#pragma aux call_main_bx "FarCallMainNearViaAX" far parm [ax] value [bx] modify exact [ax bx cx]

/* The level map: MAP_ROW_BYTES cells per row in the segment held by the CS word
   LevelMapSegment (MAIN). Cell offsets are 16-bit and unchecked, as in the oracle. */
extern word __far LevelMapSegment;
#define MAP_CELL(cell) (*(byte __far *)((__segment)LevelMapSegment :> (void __near *)(cell)))

/* ReadIndexedByteAttribute: ByteAttributeTable[map byte at `cell`]. */
word map_attribute(word cell)
{
    return ByteAttributeTable[MAP_CELL(cell)];
}

/* ComputeRecordGridOffset for the point (x, y): GridYSum = ScrollSubRow + y; FFFFh when
   that is negative, else MapScrollPos - MAP_ROW_BYTES * (GridYSum >> 4) + (x >> 4). The
   oracle moves REC_Y/REC_X around its calls instead; the result and GridYSum are the same. */
word grid_offset_at(word x, word y)
{
    GridYSum = ScrollSubRow + y;
    if ((sword)GridYSum < 0) return 0xFFFF;
    return MapScrollPos - (GridYSum >> 4) * MAP_ROW_BYTES + (x >> 4);
}

word compute_record_grid_offset(Record *r)
{
    return grid_offset_at(r->x, r->y);
}

/* The ship's hit point (PlayerHitOffsets by form) over a solid cell: one map row, two when
   the point is more than 10 px into its cell; the next column too off a cell boundary.
   1 (the oracle's CF) also for a destroyed ship (form 3+). An FFFFh grid offset is not
   checked: + MAP_ROW_BYTES wraps to 000Ch. */
word probe_ship_terrain_collision(Record *ship)
{
    word *hit, x, cell, rows;

    if (ship->sprite >= 3) return 1;
    hit = &PlayerHitOffsets[ship->sprite * 2];
    x = ship->x + hit[1];
    cell = grid_offset_at(x, ship->y + hit[0]) + MAP_ROW_BYTES;
    rows = (GridYSum & 0x0F) > 0x0A ? 2 : 1;
    do {
        if (map_attribute(cell)) return 1;
        if ((x & 0x0F) && map_attribute(cell + 1)) return 1;
        cell -= MAP_ROW_BYTES;
    } while (--rows);
    return 0;
}

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
        found = call_main_bx(FindMissileTarget);
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

/* ProbeOverlapsWalker: 1 (the oracle's CF) when TerrainProbeY/X lies strictly within 10h
   (signed) of another walker: a live pool A enemy of type 82h..94h, pass 0, size 1; the
   record itself is recognised by its REC_SAVE_BUFFER. Always 0 for a pass-1 record. */
word probe_overlaps_walker(Record *r)
{
    Record *w = POOL_A;
    word n;

    if (r->draw_pass == 1) return 0;
    for (n = POOL_A_COUNT; n != 0; n--, w++) {
        if (w->status == 0 || w->draw_pass == 1 || w->size_class != 1 || w->kind != KIND_ENEMY) continue;
        if (w->type < 0x82 || w->type > 0x94) continue;
        if ((sword)TerrainProbeY >= (sword)(w->y + 0x10) || (sword)TerrainProbeY <= (sword)(w->y - 0x10)) continue;
        if ((sword)TerrainProbeX >= (sword)(w->x + 0x10) || (sword)TerrainProbeX <= (sword)(w->x - 0x10)) continue;
        if (r->save_buffer == w->save_buffer) continue;
        return 1;
    }
    return 0;
}

/* One-pixel axis steps of TerrainStepInDirection. `cell` is the running grid offset of
   the record's box (the oracle's DX); each step returns it updated for a crossed cell
   boundary, or unchanged with TerrainBlocked = 1 when the map or a walker blocks. */
word terrain_step_down(Record *r, word cell)
{
    word probe = cell - MAP_ROW_BYTES;

    if (map_attribute(probe) || ((r->x & 0x0F) && map_attribute(probe + 1))) goto blocked;
    r->y++;
    TerrainProbeY++;
    if (probe_overlaps_walker(r)) {
        r->y--;
        TerrainProbeY--;
        goto blocked;
    }
    GridYSum = (GridYSum + 1) & 0x0F;
    if (GridYSum == 0) cell -= MAP_ROW_BYTES;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

/* Probes only when the box is row-aligned (GridYSum mod 16 = 0). */
word terrain_step_up(Record *r, word cell)
{
    word probe = cell + MAP_ROW_BYTES;

    if ((GridYSum & 0x0F) == 0
            && (map_attribute(probe) || ((r->x & 0x0F) && map_attribute(probe + 1)))) goto blocked;
    r->y--;
    TerrainProbeY--;
    if (probe_overlaps_walker(r)) {
        r->y++;
        TerrainProbeY++;
        goto blocked;
    }
    GridYSum = (GridYSum - 1) & 0x0F;
    if (GridYSum == 0x0F) cell += MAP_ROW_BYTES;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

word terrain_step_right(Record *r, word cell)
{
    if (map_attribute(cell + 1) || ((GridYSum & 0x0F) && map_attribute(cell + 1 - MAP_ROW_BYTES))) goto blocked;
    r->x++;
    TerrainProbeX++;
    if (probe_overlaps_walker(r)) {
        r->x--;
        TerrainProbeX--;
        goto blocked;
    }
    if ((r->x & 0x0F) == 0) cell++;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

/* Probes only when the box is column-aligned (X mod 16 = 0). */
word terrain_step_left(Record *r, word cell)
{
    if ((r->x & 0x0F) == 0
            && (map_attribute(cell - 1) || ((GridYSum & 0x0F) && map_attribute(cell - 1 - MAP_ROW_BYTES)))) goto blocked;
    r->x--;
    TerrainProbeX--;
    if (probe_overlaps_walker(r)) {
        r->x++;
        TerrainProbeX++;
        goto blocked;
    }
    if ((r->x & 0x0F) == 0x0F) cell--;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

/* Body of TryTerrainStep: one pixel along REC_DIRECTION (0..7; the oracle's table is
   unchecked). Diagonals are two axis steps, each tried even when the first is blocked; a
   negative GridYSum (grid offset FFFFh) is blocked. */
void terrain_step_in_direction(Record *r)
{
    word cell = compute_record_grid_offset(r);

    if (cell == 0xFFFF) {
        TerrainBlocked = 1;
        return;
    }
    switch (r->direction) {
    case DIR_UP:         terrain_step_up(r, cell); break;
    case DIR_UP_RIGHT:   terrain_step_right(r, terrain_step_up(r, cell)); break;
    case DIR_RIGHT:      terrain_step_right(r, cell); break;
    case DIR_DOWN_RIGHT: terrain_step_down(r, terrain_step_right(r, cell)); break;
    case DIR_DOWN:       terrain_step_down(r, cell); break;
    case DIR_DOWN_LEFT:  terrain_step_left(r, terrain_step_down(r, cell)); break;
    case DIR_LEFT:       terrain_step_left(r, cell); break;
    case DIR_UP_LEFT:    terrain_step_up(r, terrain_step_left(r, cell)); break;
    }
}

/* Climbing walker: one TryTerrainStep up (the walker below the player: down) along a wall
   cell on its WalkerFacingStep side, probed from the box one row above the scrolled
   position; blocked (TerrainBlocked 1, the result) when there is no wall. */
word climb_walker_step(Record *w)
{
    word cell;

    TerrainBlocked = 0;
    w->direction = DIR_UP;
    cell = grid_offset_at(w->x, w->y + ScrollDeltaY - 0x10);
    if (cell != 0xFFFF) {
        cell += WalkerFacingStep;
        if ((sword)w->y < (sword)PRIMARY->y) {
            w->direction = DIR_DOWN;
            cell -= MAP_ROW_BYTES;
        }
        if (map_attribute(cell)) {
            call_main_bp(TryTerrainStep, w);
            return TerrainBlocked;
        }
    }
    TerrainBlocked = 1;
    return 1;
}
