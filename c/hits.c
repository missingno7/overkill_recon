/* Player shots hitting records, damage, destruction, item drops, explosions, encounter
   bookkeeping and the eight-way burst, translated from the frozen oracle
   (asm-semantic-oracle-v1): PlayerShotsHitRecord, ShotHitsRecord and its hit kinds,
   DestroyRecord, ReleaseEncounterMember, SpawnItemDrop, SmartBombRecord, ClampRecordX and
   the type 22h/35h/36h descend-then-burst handlers. Same state, same results; the oracle
   comments at each routine hold the original contracts. SpawnCellFuelPickup (a level 0
   map-cell handler taking ES:SI) stays ASM and reaches InitPickupRecord through the bridge.

   SEGMENT: CGAME
   OWNS: SmartBombRecord PlayerShotsHitRecord PlayerShotsMissed SpawnItemDrop InitPickupRecord
   OWNS: SetSwaySprite Type36FallThenBurst Type22DescendThenBurst DescendBurstTail SpawnEightWayBurst
   OWNS: ClampRecordX ShotHitsRecord DamageTwo DamageOne PierceBossHit SideShotHit BeamHit PiercingHit
   OWNS: DestroyRecord ExplosionStartCases StartExplosion16 StartExplosion32
   OWNS: ReleaseEncounterMember ExplodeRecordAtBX
*/
#include "hits.h"
#include "enemies.h"

/* ASM that stays in MAIN, reached through FarCallMainNearViaAX (c/game.h). */
extern void FindFreeRecordPoolA(void);   /* BX = free record (cursor saved) or FFFFh; clobbers CX */
extern void AddScoreBcd(void);           /* BX = packed BCD points; preserves every register */
extern void RemoveRecordAtBX(void);      /* RemoveRecord for BX (may re-enter this region) */

Record *call_main_find_free(main_routine finder);
#pragma aux call_main_find_free "FarCallMainNearViaAX" far parm [ax] value [bx] modify exact [ax bx cx]
void call_main_add_score(main_routine target, word points);
#pragma aux call_main_add_score "FarCallMainNearViaAX" far parm [ax] [bx] modify exact [ax]
void call_main_remove_at_bx(main_routine target, Record *r);
#pragma aux call_main_remove_at_bx "FarCallMainNearViaAX" far parm [ax] [bx] modify exact [ax bx cx dx si di es]

#define NO_RECORD ((Record *)0xFFFF)

/* Pickup record for DropKind: 16x16 KIND_PICKUP, sprite 46h + kind, draw pass 0 (under
   pass-1 records). Returns the sprite: the oracle leaves it in SI, and SpawnCellFuelPickup's
   caller SpawnFromMapRow then continues its map cell scan from that offset (the bridge
   keeps it; see tests/hits.py). */
word init_pickup_record(Record *pickup)
{
    pickup->anim_counter = 0;
    pickup->size_class = 1;
    pickup->kind = KIND_PICKUP;
    pickup->type = 0;
    pickup->slot_index = 0xFFFF;
    pickup->flash_timer = 0;
    pickup->item_index = DropKind;
    pickup->sprite = DropKind + 0x46;
    pickup->draw_pass = 0;
    return pickup->sprite;
}

/* The pickup DropKind at (DropX, DropY + ScrollDeltaY) in a free pool A slot, if any.
   X above C0h (unsigned, so a negative X too) becomes C0h. The slot may be the record
   being destroyed or released when it is already free (RemoveRecord's leader drop). */
void spawn_item_drop(void)
{
    Record *pickup = call_main_find_free(FindFreeRecordPoolA);
    word x;

    if (pickup == NO_RECORD) return;
    pickup->status = 1;
    pickup->y = DropY + ScrollDeltaY;
    x = DropX;
    if (x > PLAYFIELD_MAX_X) x = PLAYFIELD_MAX_X;
    pickup->x = x;
    init_pickup_record(pickup);
}

/* REC_X clamped to 0..PLAYFIELD_MAX_X, signed. */
void clamp_record_x(Record *r)
{
    if ((sword)r->x > PLAYFIELD_MAX_X) r->x = PLAYFIELD_MAX_X;
    else if ((sword)r->x < 0) r->x = 0;
}

/* A large explosion in place for a segmented-boss part: type 1, frame 0, sprite 3, sfx 19h. */
void explode_record(Record *part)
{
    if (SfxEnabled) SfxRequest = 0x19;
    part->prev_type = part->type;
    part->type = 1;
    part->anim_counter = 0;
    part->sprite = 3;
}

/* Encounter bookkeeping for an enemy leaving play (destroyed or removed), by REC_TYPE:
   counted members decrement EncounterLiveCount; a leader also ends its script at its End
   label, resets FormationSlotCursor and drops an energy item (DropKind 2) at its position;
   type 93h latches Type93KilledLatch; any segmented-boss part (76h..79h) explodes the other
   three (no score) and zeroes the count and SegBossActive. Type 1 (an explosion) and every
   other type match nothing. */
void release_encounter_member(Record *r)
{
    word script_end;

    switch (r->type) {
    case 0x76: case 0x77: case 0x78: case 0x79:
        if (SegBossAnchor != (word)r) explode_record((Record *)SegBossAnchor);
        if (SegBossPart77 != (word)r) explode_record((Record *)SegBossPart77);
        if (SegBossCore != (word)r) explode_record((Record *)SegBossCore);
        if (SegBossPart79 != (word)r) explode_record((Record *)SegBossPart79);
        EncounterLiveCount = 0;
        SegBossActive = 0;
        return;
    case 0x61: case 0x62: case 0x65: case 0x14: case 0x16: case 0x17: case 0x18:
    case 0x7F: case 0x80: case 0x81: case 0x1D: case 0x1E: case 0x20: case 0x21: case 0x22:
        break;
    case 0x93:
        Type93KilledLatch = 1;
        break;
    case 0x7E: script_end = (word)LeaderScript7EEnd; goto leader;
    case 0x7D: script_end = (word)LeaderScript7DEnd; goto leader;
    case 0x1F: script_end = (word)LeaderScript1FEnd; goto leader;
    case 0x1C: script_end = (word)LeaderScript1CEnd; goto leader;
    case 0x15: script_end = (word)LeaderScript15End; goto leader;
    case 0x13: script_end = (word)LeaderScript13End;
    leader:
        LeaderScriptCursor = script_end;
        FormationSlotCursor = (word)FormationSlots;
        DropX = r->x;
        DropY = r->y;
        DropKind = 2;
        spawn_item_drop();
        break;
    default:
        return;
    }
    EncounterLiveCount--;
}

/* Starts BP's explosion in place: score 30h (size 1) else 60h, X clamped, its map group's
   GROUP_LIVE - 1 with the group's drop when that reaches 0 (a group already at 0 is left
   alone), ReleaseEncounterMember, sfx 19h, REC_PREV_TYPE = type, type 1, frame 0 and the
   first explosion sprite by size class (none for size 0). Type 21h is indestructible
   outside level 4 (no score, stays live even at 0 HP). There is no type-1 guard: a record
   already exploding explodes again. REC_SLOT_INDEX is FFFFh or a GroupTable index 0..15
   and REC_SIZE_CLASS 0..2 (the oracle's tables are unchecked). */
void destroy_record(Record *r)
{
    byte *group;

    if (r->type == 0x21 && LevelIndex != 4) return;
    call_main_add_score(AddScoreBcd, r->size_class == 1 ? 0x30 : 0x60);
    clamp_record_x(r);
    if (r->slot_index != 0xFFFF) {
        group = GroupTable + (r->slot_index << 1);
        if (group[GROUP_LIVE] != 0 && --group[GROUP_LIVE] == 0) {
            DropX = r->x;
            DropY = r->y;
            DropKind = group[GROUP_DROP_KIND];
            spawn_item_drop();
        }
    }
    release_encounter_member(r);
    if (SfxEnabled) SfxRequest = 0x19;
    r->prev_type = r->type;
    r->type = 1;
    r->anim_counter = 0;
    switch (r->size_class) {
    case 1: r->sprite = 0; break;
    case 2: r->sprite = 3; break;
    }
}

/* Surviving hits flash the record for 5 frames; during the segmented boss all four parts
   flash (through the part pointers, whatever records they name) with sfx 0Eh. */
void flash_hit_record(Record *r)
{
    r->flash_timer = 5;
    if (SegBossActive != 1) return;
    ((Record *)SegBossAnchor)->flash_timer = 5;
    ((Record *)SegBossPart77)->flash_timer = 5;
    ((Record *)SegBossCore)->flash_timer = 5;
    ((Record *)SegBossPart79)->flash_timer = 5;
    if (SfxEnabled) SfxRequest = 0x0E;
}

/* One hit point, then 3/1/0 more by DifficultySetting 0/1/other; destroyed as soon as the
   count reaches exactly 0. Each step tests zero only, so a record left at 0 HP (type 21h
   outside level 4) wraps to FFFFh on its next hit. */
void damage_one(Record *r)
{
    if (--r->hit_points == 0) { destroy_record(r); return; }
    if (DifficultySetting != 1) {
        if (DifficultySetting != 0) { flash_hit_record(r); return; }
        if (--r->hit_points == 0) { destroy_record(r); return; }
        if (--r->hit_points == 0) { destroy_record(r); return; }
    }
    if (--r->hit_points == 0) { destroy_record(r); return; }
    flash_hit_record(r);
}

/* DamageOne with one extra hit point first. */
void damage_two(Record *r)
{
    if (--r->hit_points == 0) destroy_record(r);
    else damage_one(r);
}

/* Destroy outright (HP 0), or only DamageTwo during the segmented boss. */
void destroy_unless_seg_boss(Record *r)
{
    if (SegBossActive == 1) { damage_two(r); return; }
    r->hit_points = 0;
    destroy_record(r);
}

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
            call_main_remove_at_bx(RemoveRecordAtBX, shot);
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
        call_main_remove_at_bx(RemoveRecordAtBX, shot);
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

/* Smart bomb on one live pool A record: an on-screen (Y <= E0h unsigned) KIND_ENEMY other
   than types 0/1 gets HP 0 and DestroyRecord (a type 21h outside level 4 survives at 0 HP).
   Drops may spawn into pool A slots SmartBombAll has not reached yet. */
void smart_bomb_record(Record *r)
{
    if (r->y > 0xE0 || r->kind != KIND_ENEMY || r->type == 0 || r->type == 1) return;
    r->hit_points = 0;
    destroy_record(r);
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
