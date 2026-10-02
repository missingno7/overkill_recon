/* Player movement, position history and exhaust.
   Same DOS state; input policy comes from input_normalize.h, drawing stays ASM.

   SEGMENT: CGAME
   OWNS: InitPositionHistory RunLevelEndSequence LevelEndPhaseCases
   OWNS: LevelEndRefill LevelEndFlyToWaypointB LevelEndFlyToWaypointA Steer SteerInputToWaypoint
   OWNS: PlayerDyingTail UpdatePlayerFrame StoreApplyHistoryAndConditionalPlacement
   OWNS: StorePositionHistory AdvancePositionHistoryIfRequested ApplyPositionHistoryToRecords
   OWNS: DecRecordYByMode DecRecordYUnlessAtMin DecYUnguarded IncRecordYTwice IncRecordYUnlessAtMax
   OWNS: UpdateSidePodSpreadAtEdges UpdateSidePodSpreadRight PickupFuel AddEnergyPoint
   OWNS: UpdateExhaust PlaceAtPlayerOffset FreeRecordSilently
*/
#include "player.h"
#include "enemies.h"
#include "pods.h"
#include "input_normalize.h"

void update_beam(Record *r);
void handle_fire_button(Record *r);
void scroll_forward_and_check_level_end(Record *r);
void restart_at_checkpoint(Record *r);
void damage_player_on_terrain_contact(Record *r);
Record *find_free_record_pool_a(void);

extern void RedrawEnergyGauge(void);
void player_call_platform(main_routine target);
#pragma aux player_call_platform "FarCallMainNearViaAX" far parm [ax] modify exact [ax bx cx dx si di es]

/* Initialization has the original +9 X bias; subsequent frame stores use +8. */
void init_position_history(void)
{
    word *point = (word *)HistoryPairs;
    word i;

    for (i = 0; i < HISTORY_PAIR_COUNT; i++, point += 2) {
        point[0] = PRIMARY->y + 8;
        point[1] = PRIMARY->x + 9;
    }
    HistoryWriteCursor = (word)HistoryPairs;
    HistoryReadCursor15 = (word)HistoryPairs + HISTORY_LAG15_START;
    HistoryReadCursor31 = (word)HistoryPairs + HISTORY_LAG31_START;
    HistoryCursor47 = (word)HistoryPairs + HISTORY_LAG47_START;
}

void store_position_history(Record *r)
{
    word *point = (word *)HistoryWriteCursor;

    point[0] = r->y + 8;
    point[1] = r->x + 8;
}

/* Near pod first, far pod second, including aliased slots or history storage. */
void apply_position_history_to_records(void)
{
    Record *pod;
    word *point;

    if (TrailingPodNear != 0xFFFF) {
        pod = (Record *)TrailingPodNear;
        point = (word *)HistoryReadCursor15;
        pod->y = point[0];
        pod->x = point[1];
    }
    if (TrailingPodFar != 0xFFFF) {
        pod = (Record *)TrailingPodFar;
        point = (word *)HistoryReadCursor31;
        pod->y = point[0];
        pod->x = point[1];
    }
}

void store_apply_history_and_placement(Record *r)
{
    store_position_history(r);
    apply_position_history_to_records();
    if (DemoActive != 0 || MapScrollPos > MAP_INTRO_END_POS) place_side_pods(r);
}

/* Requested motion, rather than actual displacement, advances the ring.
   A skipped X adjustment can leave XAdjustPathTaken stale and still advance it. */
void advance_position_history_if_requested(void)
{
    if ((InputBits & INPUT_MOVEMENT_MASK) == 0 && XAdjustPathTaken == 0) return;
    HistoryWriteCursor += HISTORY_PAIR_BYTES;
    if (HistoryWriteCursor == (word)HistoryEnd) HistoryWriteCursor = (word)HistoryPairs;
    HistoryReadCursor15 += HISTORY_PAIR_BYTES;
    if (HistoryReadCursor15 == (word)HistoryEnd) HistoryReadCursor15 = (word)HistoryPairs;
    HistoryReadCursor31 += HISTORY_PAIR_BYTES;
    if (HistoryReadCursor31 == (word)HistoryEnd) HistoryReadCursor31 = (word)HistoryPairs;
    HistoryCursor47 += HISTORY_PAIR_BYTES;
    if (HistoryCursor47 == (word)HistoryEnd) HistoryCursor47 = (word)HistoryPairs;
}

void pickup_fuel(void)
{
    if (Fuel == 0x58 || RefuelActive == 1 || PRIMARY->sprite >= 3) return;
    RefuelActive = 1;
    if (DemoActive != 1 && SfxEnabled != 0) SfxRequest = 0x0D;
}

void add_energy_point(void)
{
    if (EnergyPoints == 0x18) {
        if (EnergyTanks == 3) return;
        if (SfxEnabled != 0) SfxRequest = 0x1C;
        EnergyTanks++;
        EnergyPoints = 0;
    } else EnergyPoints++;
    player_call_platform(RedrawEnergyGauge);
}

void steer_input_to_waypoint(word *point)
{
    word target;

    target = point[0];
    if (PRIMARY->y != target) InputBits = PRIMARY->y < target ? IN_YPLUS : IN_YMINUS;
    target = point[1];
    if (PRIMARY->x != target) {
        InputBits |= IN_XPLUS;
        if (PRIMARY->x > target) {
            InputBits &= 0xFE;
            InputBits |= IN_XMINUS;
        }
    }
}

/* Same-frame phase redispatch: arrival at A creates the extra type 52h record
   and immediately starts B. A full pool deliberately writes through FFFFh. */
void run_level_end_sequence(void)
{
    Record *extra;
    word spread;

    for (;;) {
        PRIMARY->x &= 0xFFFE;
        InputBits = 0;
        switch (LevelEndPhase) {
        case LEVEL_END_TO_WAYPOINT_A:
            steer_input_to_waypoint(AutopilotWaypointA);
            break;
        case LEVEL_END_TO_WAYPOINT_B:
            spread = PRIMARY->sprite == 0 ? 8 : 0x0F;
            if (SidePodSpreadLeft != spread) SidePodSpreadLeft++;
            if (SidePodSpreadRight != (word)-spread) SidePodSpreadRight--;
            steer_input_to_waypoint(AutopilotWaypointB);
            break;
        case LEVEL_END_REFILL:
            InputBits = IN_YMINUS;
            pickup_fuel();
            add_energy_point();
            if (Fuel == 0x58 && EnergyTanks == 3 && EnergyPoints == 0x18) LevelEndPhase++;
            return;
        default: /* OFF or DONE; the oracle's phase table is unchecked. */
            return;
        }
        if (InputBits != 0) return;
        LevelEndPhase++;
        if (LevelEndPhase == LEVEL_END_TO_WAYPOINT_B) {
            SidePodSpreadRight = 0;
            SidePodSpreadLeft = 0;
            extra = find_free_record_pool_a();
            extra->status = 1;
            extra->kind = KIND_ENEMY;
            extra->type = 0x52;
            extra->size_class = 2;
            extra->slot_index = 0xFFFF;
            extra->sprite = 0x0F;
            extra->y = 0x20;
            extra->x = 0x58;
            AutoMoveExtraRecord = (word)extra;
        }
    }
}

void decrement_player_y(Record *r)
{
    if (LevelEndPhase != LEVEL_END_OFF) r->y--;
    else {
        if (r->y != SHIP_Y_MIN) r->y--;
        if (r->y != SHIP_Y_MIN) r->y--;
    }
}

void increment_player_y(Record *r)
{
    if (r->y != SHIP_Y_MAX) r->y++;
    if (r->y != SHIP_Y_MAX) r->y++;
}

/* Equality sentinels, not clamps; update right spread before left spread. */
void update_side_pod_spread_at_edges(Record *r)
{
    if (MapScrollPos <= MAP_INTRO_END_POS) return;
    if (r->x == 0 && (InputBits & IN_XMINUS) != 0) {
        if (SidePodSpreadRight != (word)-8) SidePodSpreadRight--;
    } else if (SidePodSpreadRight != 0) SidePodSpreadRight++;
    if (r->x == SHIP_X_MAX && (InputBits & IN_XPLUS) != 0) {
        if (SidePodSpreadLeft != 8) SidePodSpreadLeft++;
    } else if (SidePodSpreadLeft != 0) SidePodSpreadLeft--;
}

void player_dying_tail(Record *r)
{
    if (FrameCount4 != 3) return;
    r->sprite++;
    if (r->sprite != 0x0F) return;
    r->status = 0;
    restart_at_checkpoint(r);
    LifeLostRequest = 1;
    if (Fuel == 0) GameOverRequest = 1;
}

/* Return the oracle's BP: incoming on the early level-done exit, PrimaryRecord
   after entering the ship update. Opposite direction inputs apply in order. */
word update_player_frame(word bp)
{
    Record *ship = PRIMARY;

    LifeLostRequest = 0;
    NextLevelRequest = 0;
    poll_input_bits();
    if (LevelEndPhase != LEVEL_END_OFF) run_level_end_sequence();
    if (LevelEndPhase == LEVEL_END_DONE) {
        NextLevelRequest = 1;
        return bp;
    }
    ScrollDeltaY = 0;
    update_beam(ship);
    if (EnergyTanks == 0xFFFF || Fuel == 0) {
        player_dying_tail(ship);
        return (word)ship;
    }
    if ((InputBits & IN_YMINUS) != 0) decrement_player_y(ship);
    if ((InputBits & IN_YPLUS) != 0) increment_player_y(ship);
    if ((InputBits & IN_XPLUS) != 0) inc_record_x_twice(ship);
    if ((InputBits & IN_XMINUS) != 0) dec_record_x_twice(ship);
    if (MapScrollPos > MAP_INTRO_END_POS && (InputBits & IN_BUTTON_SECONDARY) != 0)
        apply_selected_upgrade();
    scroll_forward_and_check_level_end(ship);
    handle_fire_button(ship);
    if (BonusKeysEnabled != 0 && ((volatile byte *)KeyDownTable)[SCAN_3] == KEY_STATE_DOWN)
        pickup_upgrade_selector();
    if (LevelEndPhase <= LEVEL_END_TO_WAYPOINT_A) update_side_pod_spread_at_edges(ship);
    if (LevelEndPhase == LEVEL_END_OFF) {
        damage_player_on_terrain_contact(ship);
        if (MapScrollPos > MAP_INTRO_END_POS) adjust_record_x_from_counts(ship);
    }
    advance_position_history_if_requested();
    store_apply_history_and_placement(ship);
    return (word)ship;
}

/* Table indexing is the oracle's wrapping 16-bit offset, without a new clamp.
   Write Y before reading the player's X, including if the record is the player. */
void place_at_player_offset(Record *r, word *table)
{
    word *point = (word *)((word)table + (word)(PRIMARY->sprite << 2));

    r->y = point[0] + PRIMARY->y;
    r->x = point[1] + PRIMARY->x;
}

void update_exhaust(Record *r)
{
    word frame;

    if (PRIMARY->sprite >= 3 || LevelEndPhase >= LEVEL_END_REFILL) {
        r->status = 0;
        return;
    }
    /* XLAT replaces AL only; SlowCount8 normally ranges from 0 to 7. */
    frame = SlowCount8;
    r->sprite = ((frame & 0xFF00) | ExhaustFrames[(byte)frame]) + 9;
    place_at_player_offset(r, ExhaustOffsets);
}
