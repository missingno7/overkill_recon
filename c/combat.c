/* Damage, destruction, encounter bookkeeping, rewards and player hit boxes shared
   by the DOS hybrid and native core. Stored boss links and script cursors keep their
   original DS offsets. Drops use the original pool A allocator and state directly.
   The frozen oracle holds the routine contracts, including repeated destruction,
   indestructible type 21h and signed collision bounds.

   SEGMENT: CGAME
   OWNS: BeamHit ClampRecordX DamageOne DamageTwo DestroyRecord ExplodeRecordAtBX ExplosionStartCases InitPickupRecord ReleaseEncounterMember SmartBombRecord SpawnItemDrop StartExplosion16 StartExplosion32
   OWNS: AddScoreBcd LargeRecordHitsPlayer RecordNearPlayerHitPoint SmallRecordHitsPlayer
*/
#include "combat.h"
#include "pools.h"

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
    Record *pickup = find_free_record_pool_a();
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
        if (SegBossAnchor != GAME_OFFSET(r)) explode_record(GAME_PTR(Record, SegBossAnchor));
        if (SegBossPart77 != GAME_OFFSET(r)) explode_record(GAME_PTR(Record, SegBossPart77));
        if (SegBossCore != GAME_OFFSET(r)) explode_record(GAME_PTR(Record, SegBossCore));
        if (SegBossPart79 != GAME_OFFSET(r)) explode_record(GAME_PTR(Record, SegBossPart79));
        EncounterLiveCount = 0;
        SegBossActive = 0;
        return;
    case 0x61: case 0x62: case 0x65: case 0x14: case 0x16: case 0x17: case 0x18:
    case 0x7F: case 0x80: case 0x81: case 0x1D: case 0x1E: case 0x20: case 0x21: case 0x22:
        break;
    case 0x93:
        Type93KilledLatch = 1;
        break;
    case 0x7E: script_end = GAME_OFFSET(LeaderScript7EEnd); goto leader;
    case 0x7D: script_end = GAME_OFFSET(LeaderScript7DEnd); goto leader;
    case 0x1F: script_end = GAME_OFFSET(LeaderScript1FEnd); goto leader;
    case 0x1C: script_end = GAME_OFFSET(LeaderScript1CEnd); goto leader;
    case 0x15: script_end = GAME_OFFSET(LeaderScript15End); goto leader;
    case 0x13: script_end = GAME_OFFSET(LeaderScript13End);
    leader:
        LeaderScriptCursor = script_end;
        FormationSlotCursor = GAME_OFFSET(FormationSlots);
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
    add_score_bcd(r->size_class == 1 ? 0x30 : 0x60);
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
    GAME_PTR(Record, SegBossAnchor)->flash_timer = 5;
    GAME_PTR(Record, SegBossPart77)->flash_timer = 5;
    GAME_PTR(Record, SegBossCore)->flash_timer = 5;
    GAME_PTR(Record, SegBossPart79)->flash_timer = 5;
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

/* Smart bomb on one live pool A record: an on-screen (Y <= E0h unsigned) KIND_ENEMY other
   than types 0/1 gets HP 0 and DestroyRecord (a type 21h outside level 4 survives at 0 HP).
   Drops may spawn into pool A slots SmartBombAll has not reached yet. */
void smart_bomb_record(Record *r)
{
    if (r->y > 0xE0 || r->kind != KIND_ENEMY || r->type == 0 || r->type == 1) return;
    r->hit_points = 0;
    destroy_record(r);
}

/* One byte of the score: ADC then DAA exactly as the CPU does them, also for non-BCD
   bytes. Returns the carry in bit 8. */
word pods_add_bcd_byte(word a, word b, word carry)
{
    word sum = a + b + carry;
    word al = sum & 0xFF;
    word adjust_low = ((a & 0x0F) + (b & 0x0F) + carry) > 0x0F;   /* AF of the add */

    carry = sum >> 8;
    if ((al & 0x0F) > 9 || adjust_low) al = (al + 6) & 0xFF;
    if ((sum & 0xFF) > 0x99 || carry) {
        al = (al + 0x60) & 0xFF;
        carry = 1;
    }
    return carry << 8 | al;
}

/* AddScoreBcd: `points` (4 packed BCD digits) added to the 8-digit ScoreBcd; the carry
   out of the top byte is lost (99999999 wraps). */
void add_score_bcd(word points)
{
    word c;

    c = pods_add_bcd_byte(ScoreBcd[0], points & 0xFF, 0);
    ScoreBcd[0] = (byte)c;
    c = pods_add_bcd_byte(ScoreBcd[1], points >> 8, c >> 8);
    ScoreBcd[1] = (byte)c;
    c = pods_add_bcd_byte(ScoreBcd[2], 0, c >> 8);
    ScoreBcd[2] = (byte)c;
    c = pods_add_bcd_byte(ScoreBcd[3], 0, c >> 8);
    ScoreBcd[3] = (byte)c;
}

/* 1 (the oracle's CF) when |REC_Y - PlayerHitY| <= 10h and |REC_X - PlayerHitX| <= 10h,
   signed and inclusive, with 16-bit bounds. */
word record_near_player_hit_point(Record *r)
{
    return (sword)r->y <= (sword)(PlayerHitY + 0x10) && (sword)r->y >= (sword)(PlayerHitY - 0x10)
        && (sword)r->x <= (sword)(PlayerHitX + 0x10) && (sword)r->x >= (sword)(PlayerHitX - 0x10);
}

/* Size 1 record: within 10h of the ship's hit point (PlayerHitOffsets by form, stored in
   PlayerHitY/X). Never above the playfield (REC_Y < 0) or for a destroyed ship (form 3+). */
word small_record_hits_player(Record *r)
{
    word *hit;

    if ((sword)r->y < 0 || PRIMARY->sprite >= 3) return 0;
    hit = &PlayerHitOffsets[PRIMARY->sprite * 2];
    PlayerHitY = hit[0] + PRIMARY->y;
    PlayerHitX = hit[1] + PRIMARY->x;
    return record_near_player_hit_point(r);
}

/* Size 2 record: recX-14h <= ship X <= recX+18h (signed) and recY-14h <= ship Y <= recY+18h
   (unsigned; recY-4..recY+8 while SegBossActive). Never for REC_Y < 0; no ship-form test. */
word large_record_hits_player(Record *r)
{
    word low, high;

    if ((sword)r->y < 0) return 0;
    if ((sword)(r->x + 0x18) < (sword)PRIMARY->x || (sword)(r->x - 0x14) > (sword)PRIMARY->x) return 0;
    if (SegBossActive == 1) {
        high = r->y + 8;
        low = r->y - 4;
    } else {
        high = r->y + 0x18;
        low = r->y - 0x14;
    }
    return high >= PRIMARY->y && low <= PRIMARY->y;
}
