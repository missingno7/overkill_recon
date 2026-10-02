/* Player-shot hit dispatch and eight-way bursts in the DOS hybrid. Damage,
   destruction, encounter bookkeeping, item drops and score are shared in c/combat.c.
   The frozen oracle holds the hit-kind contracts and descend-then-burst quirks.

   SEGMENT: CGAME
   OWNS: PlayerShotsHitRecord PlayerShotsMissed
   OWNS: SetSwaySprite Type36FallThenBurst Type22DescendThenBurst DescendBurstTail SpawnEightWayBurst
   OWNS: ShotHitsRecord PierceBossHit SideShotHit PiercingHit
*/
#include "hits.h"
#include "enemies.h"
#include "pods.h"

/* The player shot `shot` overlaps r. Types 7, 8, 0Ch (piercing) and 9 (beam) destroy r
   outright and fly on; during the segmented boss they only DamageTwo, and then 7/8/0Ch are
   used up (9 is not). Types 5 and 6 are used up (RemoveRecord). Type 2 is used up by
   clearing its status only (no RemoveRecord): DamageOne, DamageTwo for sprite 33h. Any
   other shot (the missile) hits only its REC_TARGET and unlocks; it keeps REC_TARGET, so
   flying back it still hits whatever then occupies that slot; other records it passes are
   untouched, but still end PlayerShotsHitRecord's scan. */
void shot_hits_record(Record *r, Record *shot)
{
    switch (shot->type) {
    case 7: case 8: case 0x0C:
        if (SegBossActive == 1) {
            remove_record(shot);
            damage_two(r);
            return;
        }
        r->hit_points = 0;
        destroy_record(r);
        return;
    case 9:
        destroy_unless_seg_boss(r);
        return;
    case 2:
        shot->status = 0;
        if (shot->sprite == 0x33) damage_two(r);
        else damage_one(r);
        return;
    case 6: case 5:
        remove_record(shot);
        destroy_unless_seg_boss(r);
        return;
    }
    if (shot->target != (word)r) return;
    shot->missile_locked = 0;
    destroy_unless_seg_boss(r);
}

/* Tests the live player shots of pool B in slot order against r (BP) on an 8-px grid:
   the shot's cell (X & ~7) minus r's cell must be 0 or 8 (size class 2: also 10h or 18h),
   or -8 when the shot X is not cell aligned; the Y cells the same without -8, and the 10h/
   18h rows are skipped for the boss parts 78h/79h. The first shot overlapping on both axes
   goes to ShotHitsRecord and ends the scan (even a missile aimed elsewhere, which then has
   no effect). Skipped entirely: free records, REC_Y < 20h (signed), scenery and types 0,
   1 and 26h. The oracle unrolls the scan over all 34 records. */
void player_shots_hit_record(Record *r)
{
    Record *shot;
    word cell_x, cell_y, dx, dy, n;

    if (r->status == 0 || (sword)r->y < 0x20 || r->kind == KIND_SCENERY) return;
    if (r->type == 0 || r->type == 1 || r->type == 0x26) return;
    cell_x = r->x & 0xFFF8;
    cell_y = r->y & 0xFFF8;
    for (shot = POOL_B, n = POOL_B_COUNT; n != 0; shot++, n--) {
        if (shot->status == 0 || shot->player_shot == 0) continue;
        dx = (shot->x & 0xFFF8) - cell_x;
        if (!(dx == 0 || dx == 8 || ((shot->x & 7) != 0 && dx == 0xFFF8)
              || (r->size_class == 2 && (dx == 0x10 || dx == 0x18)))) continue;
        dy = (shot->y & 0xFFF8) - cell_y;
        if (dy == 0 || dy == 8
            || (r->size_class == 2 && r->type != 0x78 && r->type != 0x79 && (dy == 0x10 || dy == 0x18))) {
            shot_hits_record(r, shot);
            return;
        }
    }
}

/* REC_SPRITE 72h when SwayDirX = +1, else 71h (0 and -1 too). */
void set_sway_sprite(Record *r)
{
    r->sprite = ((word)(SwayDirX + 1) >> 1) + 0x71;
}

/* Up to eight type 3 enemy shots (8x8, sprite 8 + direction, no timeout) from r's centre
   (+4, or +0Ch for size class 2) in directions 7 down to 0, until pool B is full. */
void spawn_eight_way_burst(Record *r)
{
    Record *shot;
    word n, offset = r->size_class == 2 ? 0x0C : 4;

    BurstOriginX = r->x + offset;
    BurstOriginY = r->y + offset;
    for (n = 8; n != 0; n--) {
        shot = find_free_record_pool_b();
        if (shot == NO_RECORD) return;
        shot->direction = n - 1;
        shot->sprite = n - 1 + 8;
        shot->x = BurstOriginX;
        shot->y = BurstOriginY;
        shot->status = 1;
        shot->player_shot = 0;
        shot->draw_pass = 1;
        shot->size_class = 0;
        shot->kind = KIND_TYPED;
        shot->type = 3;
        shot->shot_timer = 0xFFFF;
    }
}

/* At Y A0h or below (unsigned): destroyed, then the burst. */
void descend_burst_tail(Record *r)
{
    destroy_record(r);
    spawn_eight_way_burst(r);
}

/* Type 36h: SwayDirX-facing sprite, falls 2 px per frame to Y A0h, then bursts. The
   bridge continues in ScrollRecordThenFinish either way (even after DestroyRecord). */
void type36_fall_then_burst(Record *r)
{
    set_sway_sprite(r);
    r->y += 2;
    if (r->y >= 0xA0) descend_burst_tail(r);
}

/* Types 22h/35h: as type 36h, falling 1 px per frame (2 on level 0). */
void type22_descend_then_burst(Record *r)
{
    set_sway_sprite(r);
    r->y++;
    if (LevelIndex == 0) r->y++;
    if (r->y >= 0xA0) descend_burst_tail(r);
}
