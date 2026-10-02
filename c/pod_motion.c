/* Pod placement, ship balance, pod damage and demo motion shared by DOS and host.
   Original slots and offset tables remain in DS; pointer conversions happen only at
   access. The oracle's unclamped arithmetic, stale fields and adjacent-table reads stay.

   SEGMENT: CGAME
   OWNS: AdjustRecordXFromCounts CountLeftPod CountRightPod DecRecordXTwice DecRecordXUnlessZero DemoLaunchPod
   OWNS: DemoLaunchTrailingPod DemoStepNextShipForm IncRecordXBelowMax IncRecordXTwice InitPodRecord NudgeShipLeft
   OWNS: NudgeShipLeftHalf NudgeShipRight NudgeShipRightHalf PlaceRecordFromOffsetPair PlaceSidePods PodLoseHitPoint
   OWNS: PodProbeTerrain PodTakeHit PodTakeHitSilent PodTerrainHit ReturnPodNotHit SidePodBalanceCases
   OWNS: StoreRecordSavedPosition
*/
#include "pod_motion.h"
#include "terrain.h"

#define NO_SLOT 0xFFFF

/* A live KIND_POD, size class 1, sprite 14h, 80 hit points, second draw pass. */
void init_pod_record(Record *pod)
{
    pod->status = 1;
    pod->size_class = 1;
    pod->kind = KIND_POD;
    pod->sprite = 0x14;
    pod->hit_points = 0x50;
    pod->draw_pass = 1;
}

/* PlaceRecordFromOffsetPair: pod (NO_RECORD: nothing) = anchor + table[anchor REC_SPRITE]
   (Y, X pairs) with 2 * OffsetXWork more in X, X clamped to 0..PLAYFIELD_MAX_X (signed); a
   clamp sets ClampXLowSeen/ClampXHighSeen. The tables hold three pairs and are not bound
   checked: a dying ship (sprite 3) reads the next table's first pair. */
void place_record_from_offset_pair(Record *pod, word *table, Record *anchor)
{
    word *pair;

    if (pod == NO_RECORD) return;
    pair = GAME_PTR(word, GAME_OFFSET(table) + (word)(anchor->sprite << 2));
    pod->y = pair[0] + anchor->y;
    pod->x = pair[1] + anchor->x + OffsetXWork + OffsetXWork;
    if ((sword)pod->x < 0) {
        pod->x = 0;
        ClampXLowSeen = 1;
    }
    if ((sword)pod->x > PLAYFIELD_MAX_X) {
        pod->x = PLAYFIELD_MAX_X;
        ClampXHighSeen = 1;
    }
}

/* The four side pods around `anchor`: the right pair spread by SidePodSpreadRight, the
   left pair by SidePodSpreadLeft; ClampXLowSeen/ClampXHighSeen report a clamped pod. */
void place_side_pods(Record *anchor)
{
    ClampXLowSeen = 0;
    ClampXHighSeen = 0;
    OffsetXWork = SidePodSpreadRight;
    place_record_from_offset_pair(GAME_PTR(Record, SidePodRightOuter), SidePodOffsetsRightOuter, anchor);
    place_record_from_offset_pair(GAME_PTR(Record, SidePodRightInner), SidePodOffsetsRightInner, anchor);
    OffsetXWork = SidePodSpreadLeft;
    place_record_from_offset_pair(GAME_PTR(Record, SidePodLeftOuter), SidePodOffsetsLeftOuter, anchor);
    place_record_from_offset_pair(GAME_PTR(Record, SidePodLeftInner), SidePodOffsetsLeftInner, anchor);
}

/* X - 1 unless 0; X + 1 while below SHIP_X_MAX (unsigned). */
void dec_record_x_unless_zero(Record *r)
{
    if (r->x != 0) r->x--;
}

void inc_record_x_below_max(Record *r)
{
    if (r->x < SHIP_X_MAX) r->x++;
}

void dec_record_x_twice(Record *r)
{
    dec_record_x_unless_zero(r);
    dec_record_x_unless_zero(r);
}

void inc_record_x_twice(Record *r)
{
    inc_record_x_below_max(r);
    inc_record_x_below_max(r);
}

/* Push the ship two steps away from an edge where a side pod was clamped last frame
   (unless the player steers that way), then one step toward the side with fewer pods;
   for a difference of one pod only while FrameParity != 1. XAdjustPathTaken = 1 when any
   nudge path was taken, even when the bound kept X. */
void adjust_record_x_from_counts(Record *ship)
{
    word left = 0, right = 0;

    XAdjustPathTaken = 0;
    if (!(InputBits & IN_XMINUS) && ClampXLowSeen == 1) {
        inc_record_x_twice(ship);
        XAdjustPathTaken = 1;
    }
    if (!(InputBits & IN_XPLUS) && ClampXHighSeen == 1) {
        dec_record_x_twice(ship);
        XAdjustPathTaken = 1;
    }
    if (SidePodLeftInner != NO_SLOT) left++;
    if (SidePodRightInner != NO_SLOT) right++;
    if (SidePodLeftOuter != NO_SLOT) left++;
    if (SidePodRightOuter != NO_SLOT) right++;
    switch (right + 3 * left) {             /* SidePodBalanceCases */
    case 3: case 7:                         /* NudgeShipRightHalf */
        if (FrameParity == 1) return;
        /* fall through */
    case 6:                                 /* NudgeShipRight */
        XAdjustPathTaken = 1;
        inc_record_x_below_max(ship);
        return;
    case 1: case 5:                         /* NudgeShipLeftHalf */
        if (FrameParity == 1) return;
        /* fall through */
    case 2:                                 /* NudgeShipLeft */
        XAdjustPathTaken = 1;
        dec_record_x_unless_zero(ship);
        return;
    }
}

/* PodTakeHit: sfx 0Eh, flash 5 frames; loses a hit point unless DifficultySetting 0 and
   FrameParity != 1. 1 (the oracle's CF) when that was the last one (flash cancelled); a
   pod at 0 HP wraps to FFFFh. */
word pod_take_hit(Record *pod)
{
    if (SfxEnabled) SfxRequest = 0x0E;
    pod->flash_timer = 5;
    if (DifficultySetting == 0 && FrameParity != 1) return 0;
    if (--pod->hit_points != 0) return 0;
    pod->flash_timer = 0;
    return 1;
}

/* PodTerrainHit: the map cell below the pod's grid offset (+ MAP_ROW_BYTES; the FFFFh of a
   negative GridYSum is not checked and wraps to 000Ch) and, off a cell boundary, its right
   neighbour; a solid one costs a hit. 1 when the pod lost its last hit point; never in the
   demo or during the level end. */
word pod_terrain_hit(Record *pod)
{
    word cell;

    if (LevelEndPhase != LEVEL_END_OFF || DemoActive == 1) return 0;
    cell = compute_record_grid_offset(pod) + MAP_ROW_BYTES;
    if (map_attribute(cell) || ((pod->x & 0x0F) && map_attribute(cell + 1))) return pod_take_hit(pod);
    return 0;
}

void store_record_saved_position(Record *r)
{
    GAME_RECORD_FIELD(r, saved_x) = GAME_RECORD_FIELD(r, x);
    GAME_RECORD_FIELD(r, saved_y) = GAME_RECORD_FIELD(r, y);
}

/* Steps 3 and 5: the next ship form, sfx 6, the side pods re-placed. */
void demo_step_next_ship_form(void)
{
    PRIMARY->sprite++;
    if (SfxEnabled) SfxRequest = 6;
    DemoStepTimer = 0x32;
    place_side_pods(PRIMARY);
}

/* DemoLaunchPod: the pod remembers its position as REC_SAVED and restarts at (C0h, C8h)
   as a type 50h enemy that flies home and becomes a pod again. An empty slot (FFFFh) is
   not checked: the writes wrap around the state segment. */
void demo_launch_pod(Record *pod)
{
    store_record_saved_position(pod);
    GAME_RECORD_FIELD(pod, y) = 0xC8;
    GAME_RECORD_FIELD(pod, x) = PLAYFIELD_MAX_X;
    GAME_RECORD_FIELD(pod, type) = 0x50;
    GAME_RECORD_FIELD(pod, kind) = KIND_ENEMY;
}

/* Homing on the ship + (8, 28h). */
void demo_launch_trailing_pod(Record *pod)
{
    demo_launch_pod(pod);
    GAME_RECORD_FIELD(pod, saved_x) = PRIMARY->x + 8;
    GAME_RECORD_FIELD(pod, saved_y) = PRIMARY->y + 0x28;
}
