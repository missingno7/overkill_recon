/* Pods, the upgrade selector, pickups and the player hit tests, translated from the frozen
   oracle (asm-semantic-oracle-v1): the front, side and trailing pods (adding, placing,
   updating, collisions, terrain, loss), the four-slot upgrade selector with its condition
   and apply routines, RemoveRecord and the pool A allocator that evicts through it, the
   explosion animations, pickups (collection and the player hit tests), the BCD score, the
   ship's X nudges toward the side with fewer pods, and the demo steps that launch pods.
   Same state, same results; the oracle comments at each routine hold the original
   contracts and quirks.

   Stays ASM: ReturnNear (the shared bare ret of many tables) and ReturnNoHit (a dead
   `clc / ret` after KindHandlers once its users are C). The slot pixel rendering is in
   c/render.c. Upgrade lists still contain MAIN code-address tokens; known frozen tokens
   select the existing C conditions/actions, while unknown injected tokens retain the raw
   trampoline call.

   SEGMENT: CGAME
   OWNS: UpgradeNeverAvailable UpgradeAlwaysAvailable MissilesAvailable FrontPodAvailable
   OWNS: SidePodsAvailable TrailingPodsAvailable ShipForm1Available ShipForm2Available
   OWNS: AllocRecordEvicting AdvanceToAvailableUpgrade SingleShotAvailable HeavyShotAvailable
   OWNS: ForkShotAvailable TwinRising3Available TwinRising16Available BeamAvailable
   OWNS: ApplySingleShot ApplyHeavyShot ApplyForkShot ApplyTwinRising3 ApplyTwinRising16 ApplyBeam
   OWNS: FinishUpgrade SideShotsAvailable ApplySideShots ApplyMissiles ApplyFrontPod ApplySidePods
   OWNS: ApplyTrailingPods ApplyShipForm1 ApplyShipForm2 ApplySelectedUpgrade PickupUpgradeSelector
   OWNS: AddFrontPod AddTrailingPod AddTrailingPodBody InitPodRecord AddSidePods
   OWNS: FillSidePodSlotIfEmpty PickupHandlers PickupDone AnimateSidePodSprite
   OWNS: UpdateSidePodRightOuter UpdateSidePodLeftOuter UpdateSidePodRightInner
   OWNS: UpdateSidePodLeftInner UpdateSidePod DestroyRecordAtBX UpdateTrailingPod UpdateFrontPod
   OWNS: ExplodePod RefreshUpgradeDisplay UpdatePod RemoveRecordAtBX RemoveRecord
   OWNS: AnimateExplosion16 StoreRecordSavedPosition Explosion16Frame AnimateExplosion32
   OWNS: ResetPoolAAndUpgrades DemoStepLaunchTrailingPodNear DemoStepLaunchTrailingPodFar
   OWNS: DemoLaunchTrailingPod DemoStepLaunchInnerSidePods DemoStepLaunchOuterSidePods DemoLaunchPod
   OWNS: ReturnCarrySet AddScoreBcd RecordNearPlayerHitPoint SmallRecordHitsPlayer
   OWNS: LargeRecordHitsPlayer CollectPickup PodTerrainHit PodProbeTerrain ReturnPodNotHit
   OWNS: PodTakeHit PodTakeHitSilent PodLoseHitPoint PodCollideRecords CheckRecordHitsPlayer
   OWNS: CountLeftPod CountRightPod AdjustRecordXFromCounts SidePodBalanceCases
   OWNS: NudgeShipRightHalf NudgeShipRight NudgeShipLeftHalf NudgeShipLeft PlaceSidePods
   OWNS: PlaceRecordFromOffsetPair DecRecordXTwice DecRecordXUnlessZero IncRecordXTwice
   OWNS: IncRecordXBelowMax DemoStepNextShipForm PickupEnergy InitUpgradeSlots InitUpgradeSlotAtRow
*/
#include "pods.h"
#include "hits.h"
#include "player.h"

#define NO_RECORD ((Record *)0xFFFF)
#define NO_SLOT 0xFFFF              /* empty pod slot, no selected upgrade slot */

/* c/shots.c, c/spawn.c */
word map_attribute(word cell);
word compute_record_grid_offset(Record *r);
void lose_player_energy_tank(void);
Record *find_free_record_pool_a(void);

/* The HUD upgrade slots (UpgradeSlot0..3 in DATA.ASM) and their upgrade list entries. */
typedef struct UpgradeSlot {
    word icon;          /* panel image of the offered upgrade (24h: nothing) */
    word screen;        /* screen offset (InitUpgradeSlots) */
    word image;         /* slot frame panel image */
    word list;          /* UpgradeEntry list, ended by condition FFFFh */
    word index;         /* current entry */
} UpgradeSlot;
typedef struct UpgradeEntry {
    word icon;
    word condition;     /* MAIN routine: NZ = can be offered (FFFFh ends the list) */
    word apply;         /* MAIN routine: buys it */
} UpgradeEntry;
STATIC_CHECK(pods_slot_size, sizeof(UpgradeSlot) == UPGRADE_SLOT_BYTES);
STATIC_CHECK(pods_slot_icon, (unsigned)&((UpgradeSlot *)0)->icon == UPGRADE_SLOT_ICON);
STATIC_CHECK(pods_slot_screen, (unsigned)&((UpgradeSlot *)0)->screen == UPGRADE_SLOT_SCREEN);
STATIC_CHECK(pods_slot_image, (unsigned)&((UpgradeSlot *)0)->image == UPGRADE_SLOT_IMAGE);
STATIC_CHECK(pods_slot_list, (unsigned)&((UpgradeSlot *)0)->list == UPGRADE_SLOT_LIST);
STATIC_CHECK(pods_slot_index, (unsigned)&((UpgradeSlot *)0)->index == UPGRADE_SLOT_INDEX);
STATIC_CHECK(pods_entry_size, sizeof(UpgradeEntry) == 6);

/* CS-resident word of MAIN: the next pool A save buffer handed out (every write of it is
   observable, so each one is kept). */
extern volatile word __far SaveBufferCursor;

/* ASM that stays in MAIN, reached through FarCallMainNearViaAX (c/game.h). */
void smart_bomb_all(void);              /* c/frame.c */

/* An upgrade list apply routine (a bridge label of this region, or ReturnNear). */
void pods_call_main(main_routine target);
#pragma aux pods_call_main "FarCallMainNearViaAX" far parm [ax] modify exact [ax bx cx dx si di es]
/* BP = r around the far call: the near thunk CALL_MAIN_BP of c/shots.asm (DX passes). */
void pods_call_main_bp(main_routine target, Record *r);
#pragma aux pods_call_main_bp "CALL_MAIN_BP" parm [ax] [si] modify exact [ax bx cx dx si di es]
/* An upgrade list condition routine: 1 when it returns NZ (thunk in c/pods.asm). */
word pods_call_condition(word routine);
#pragma aux pods_call_condition "PODS_CALL_CONDITION" parm [ax] value [ax] modify exact [ax]

word pods_upgrade_condition(word routine);
void pods_apply_upgrade(word routine);

/* This caller needs only the result ABI, not render.h's pixel request declarations. */
dword render_draw_upgrade_slots(void);
#pragma aux render_draw_upgrade_slots value [dx ax] modify exact [ax dx]

extern void RedrawEnergyGauge(void);

/* Fixed screen-row/8-pixel-column mapper, retained as adapter code in MAIN. */
word pods_screen_offset(word row_column);
#pragma aux pods_screen_offset "PODS_SCREEN_OFFSET" parm [si] value [ax] \
    modify exact [ax bx cx dx si di es]

/* Item 2. The equality loop deliberately wraps a 16-bit energy bar before reaching 18h. */
void pickup_energy(void)
{
    if (SfxEnabled != 0) SfxRequest = 0x1C;
    if (EnergyTanks == 3) {
        while (EnergyPoints != 0x18) EnergyPoints++;
    } else {
        EnergyTanks++;
    }
    pods_call_main(RedrawEnergyGauge);
}

/* Reset four data-backed slots. The returned word is the BP value left by the oracle:
   the offset just past UpgradeSlot3. The platform helper still selects CGA/EGA/Tandy. */
word init_upgrade_slots(void)
{
    UpgradeSlot *slot = (UpgradeSlot *)UpgradeSlot0;
    word row = 0x87;
    word n;

    SelectedUpgradeSlot = 0xFFFF;
    for (n = 0; n != 4; n++) {
        word screen = pods_screen_offset((row << 8) | 0x1C);
        slot->icon = 0x24;
        slot->screen = screen;
        slot->index = 0;
        slot++;
        row += 0x10;
    }
    return (word)slot;
}

/* ---- score ------------------------------------------------------------------------ */

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

/* ---- the upgrade selector ------------------------------------------------------------ */

UpgradeSlot *pods_selected_slot(void)
{
    return (UpgradeSlot *)UpgradeSlotPtrs[SelectedUpgradeSlot];
}

/* Selected slot only (no-op without one): from its current index the first entry whose
   condition says NZ sets the slot's icon; the FFFFh end wraps to entry 0 without counting
   as a try. After 10 tries: entry 0, icon 24h. Other slots keep stale icons.
   SelectedUpgradeSlot is 0..3 or FFFFh (UpgradeSlotPtrs is unchecked). */
void advance_to_available_upgrade(void)
{
    UpgradeSlot *slot;
    UpgradeEntry *entry;

    if (SelectedUpgradeSlot == NO_SLOT) return;
    slot = pods_selected_slot();
    UpgradeTries = 0;
    for (;;) {
        entry = (UpgradeEntry *)slot->list + slot->index;
        if (entry->condition == 0xFFFF) {
            slot->index = 0;
            continue;
        }
        if (pods_upgrade_condition(entry->condition)) {
            slot->icon = entry->icon;
            return;
        }
        slot->index++;
        if (++UpgradeTries >= 0x0A) break;
    }
    slot->index = 0;
    slot->icon = 0x24;
}

/* RefreshUpgradeDisplay: re-advance the selected slot and redraw the four slots. Returns
   SI as DrawUpgradeSlots leaves it (RemoveRecord of a missile passes it on). */
word refresh_upgrade_display(void)
{
    advance_to_available_upgrade();
    return (word)render_draw_upgrade_slots();
}

/* Secondary button (held past MAP_INTRO_END_POS, every frame): the selected slot's entry
   apply routine runs; the slot then re-advances with the old selection (past a bought
   entry), the selection becomes what the apply left (FFFFh after a purchase: sfx 9) and
   the slots are redrawn. Entry 0 (icon 24h, ReturnNear) keeps the selection. */
void apply_selected_upgrade(void)
{
    word selected = SelectedUpgradeSlot;
    UpgradeSlot *slot;

    if (selected == NO_SLOT) return;
    slot = pods_selected_slot();
    pods_apply_upgrade(((UpgradeEntry *)slot->list + slot->index)->apply);
    SavedUpgradeSlot = SelectedUpgradeSlot;
    SelectedUpgradeSlot = selected;
    advance_to_available_upgrade();
    SelectedUpgradeSlot = SavedUpgradeSlot;
    (void)render_draw_upgrade_slots();
    if (SelectedUpgradeSlot == NO_SLOT && SfxEnabled) SfxRequest = 9;
}

/* Pickup item 1 (and key 3 with BonusKeysEnabled): the next slot, (selection + 1) & 3, so
   FFFFh -> 0; empty slots are not skipped. With BonusKeysEnabled it first waits for key 3
   to be released (the keyboard interrupt updates KeyDownTable). */
void pickup_upgrade_selector(void)
{
    volatile byte *key3 = &KeyDownTable[SCAN_3];

    if (BonusKeysEnabled != 0)
        while (*key3 == KEY_STATE_DOWN) ;
    SelectedUpgradeSlot = (SelectedUpgradeSlot + 1) & 3;
    refresh_upgrade_display();
}

/* Upgrade list conditions (1 = can be offered) and apply routines; each apply ends the
   selection (FinishUpgrade). */
word single_shot_available(void) { return WeaponMode != WEAPON_SINGLE; }
word heavy_shot_available(void) { return WeaponMode != WEAPON_HEAVY; }
word fork_shot_available(void) { return WeaponMode != WEAPON_FORK; }
word twin_rising3_available(void) { return WeaponMode != WEAPON_TWIN_RISING3; }
word twin_rising16_available(void) { return WeaponMode != WEAPON_TWIN_RISING16; }
word beam_available(void) { return WeaponMode != WEAPON_BEAM; }
word side_shots_available(void) { return SideShotsEnabled != 1; }
word upgrade_never_available(void) { return 0; }      /* entry 0 (icon 24h) of every list */
word missiles_available(void) { return MissileAmmo == 0; }
word front_pod_available(void) { return FrontPodRecord == NO_SLOT; }

/* While an inner slot is empty; with both inner pods, only in forms 1/2 (any sprite but 0)
   with an outer slot empty. */
word side_pods_available(void)
{
    if (SidePodLeftInner == NO_SLOT || SidePodRightInner == NO_SLOT) return 1;
    if (PRIMARY->sprite == 0) return 0;
    return SidePodLeftOuter == NO_SLOT || SidePodRightOuter == NO_SLOT;
}

/* Ship form 2 only, with a trailing slot empty. */
word trailing_pods_available(void)
{
    if (PRIMARY->sprite != 2) return 0;
    return TrailingPodNear == NO_SLOT || TrailingPodFar == NO_SLOT;
}

/* Form 1 from form 0 only; form 2 from any form but 2 (form 0 can skip form 1). */
word ship_form1_available(void) { return PRIMARY->sprite == 0; }
word ship_form2_available(void) { return PRIMARY->sprite != 2; }

void finish_upgrade(void) { SelectedUpgradeSlot = NO_SLOT; }

void pods_set_weapon(word mode)
{
    WeaponMode = mode;
    finish_upgrade();
}
void apply_single_shot(void) { pods_set_weapon(WEAPON_SINGLE); }
void apply_heavy_shot(void) { pods_set_weapon(WEAPON_HEAVY); }
void apply_fork_shot(void) { pods_set_weapon(WEAPON_FORK); }
void apply_twin_rising3(void) { pods_set_weapon(WEAPON_TWIN_RISING3); }
void apply_twin_rising16(void) { pods_set_weapon(WEAPON_TWIN_RISING16); }
void apply_beam(void) { pods_set_weapon(WEAPON_BEAM); }

void apply_side_shots(void)
{
    SideShotsEnabled = 1;
    finish_upgrade();
}

void apply_missiles(void)
{
    MissileAmmo = 4;
    finish_upgrade();
}

/* Ship forms 1 and 2: cuts the playing sound effect, sfx 6. */
void pods_set_ship_form(word form)
{
    SfxActive = 0;
    if (SfxEnabled) SfxRequest = 6;
    PRIMARY->sprite = form;
    finish_upgrade();
}
void apply_ship_form1(void) { pods_set_ship_form(1); }
void apply_ship_form2(void) { pods_set_ship_form(2); }

/* ---- removing and allocating records -------------------------------------------------- */

/* RemoveRecord: REC_STATUS 0 and the bookkeeping of the record's class. An enemy leaves
   its encounter (ReleaseEncounterMember: a leader drops its item, possibly into this very
   slot, whose fields are read afterwards) and, unless type 1 or without a group, zeroes
   its group's GROUP_LIVE (no group drop). A pod becomes KIND_TYPED. Shot types 5-8/0Ch
   decrement their ShotsLive* count (not below 0); type 9 frees every record BeamList
   names up to its FFFFh end (the list itself is kept; ShotsLiveType9 counts down without
   a floor) unless ShotsLiveType9 is 0; the missile decrements MissilesLive and refreshes
   the upgrade slots.
   `si` is the oracle's SI on entry; the result is SI as the oracle leaves it: the group
   entry, the word after BeamList's end, DrawUpgradeSlots' leftover, else unchanged (the
   pod shots of c/weapons.c continue from it after an eviction). */
word remove_record_si(Record *r, word si)
{
    word *beam;
    byte *group;

    r->status = 0;
    if (r->kind == KIND_ENEMY) {
        release_encounter_member(r);
        if (r->type == 1 || r->slot_index == 0xFFFF) return si;
        group = GroupTable + (r->slot_index << 1);
        group[GROUP_LIVE] = 0;
        return (word)group;
    }
    if (r->kind == KIND_POD) {
        r->kind = KIND_TYPED;
        return si;
    }
    switch (r->type) {
    case 7: case 8:
        if (ShotsLiveMain != 0) ShotsLiveMain--;
        break;
    case 9:
        if (ShotsLiveType9 == 0) break;
        for (beam = BeamList; *beam != 0xFFFF; beam++) {
            ((Record *)*beam)->status = 0;
            ShotsLiveType9--;
        }
        return (word)(beam + 1);
    case 6: case 5:
        if (ShotsLiveSide != 0) ShotsLiveSide--;
        break;
    case 0x0C:
        if (ShotsLiveFrontPod != 0) ShotsLiveFrontPod--;
        break;
    case 0x0A:
        if (MissilesLive != 0) MissilesLive--;
        return refresh_upgrade_display();
    }
    return si;
}

void remove_record(Record *r)
{
    remove_record_si(r, 0);
}

/* A pool A record to claim (not marked live): a free one (FindFreeRecordPoolA), else the
   first record that is neither a pod nor the exhaust (all pods and exhaust: PoolA[0]) is
   removed and returned. A leader victim's drop takes the freed slot first and is then
   overwritten; its search leaves PoolACursor on that slot. */
Record *alloc_record_evicting(void)
{
    Record *r = find_free_record_pool_a();
    word n;

    if (r != NO_RECORD) return r;
    for (r = POOL_A, n = POOL_A_COUNT; n != 0; r++, n--)
        if (r->kind != KIND_EXHAUST && r->kind != KIND_POD) break;
    if (n == 0) r = POOL_A;
    remove_record(r);
    return r;
}

/* ---- adding pods ------------------------------------------------------------------ */

/* No-op if a front pod exists. KIND_POD, size 1, sprite 0Fh (its identity in UpdatePod),
   20 HP; REC_TYPE, REC_DRAW_PASS and REC_SLOT_INDEX stay as the slot's old occupant left
   them. */
void add_front_pod(void)
{
    Record *pod;

    if (FrontPodRecord != NO_SLOT) return;
    pod = alloc_record_evicting();
    FrontPodRecord = (word)pod;
    pod->status = 1;
    pod->size_class = 1;
    pod->kind = KIND_POD;
    pod->sprite = 0x0F;
    pod->hit_points = 0x14;
}

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

/* Fills TrailingPodNear, else TrailingPodFar, else nothing. */
void add_trailing_pod(void)
{
    Record *pod;

    if (TrailingPodNear == NO_SLOT) {
        pod = alloc_record_evicting();
        TrailingPodNear = (word)pod;
    } else if (TrailingPodFar == NO_SLOT) {
        pod = alloc_record_evicting();
        TrailingPodFar = (word)pod;
    } else {
        return;
    }
    init_pod_record(pod);
}

/* FillSidePodSlotIfEmpty: 1 (the oracle's NZ) when the slot is occupied; else a side pod
   (sprite 18h) fills it, all side pods are placed around the ship and the result is
   whether SidePodsToAdd is still nonzero after counting this one. */
word fill_side_pod_slot_if_empty(word *slot)
{
    Record *pod;

    if (*slot != NO_SLOT) return 1;
    SidePodSlotPtr = (word)slot;
    pod = alloc_record_evicting();
    init_pod_record(pod);
    pod->sprite = 0x18;
    pod->draw_pass = 1;
    *(word *)SidePodSlotPtr = (word)pod;
    place_side_pods(PRIMARY);
    return --SidePodsToAdd != 0;
}

/* Up to two empty side pod slots, in the order left inner, right inner, left outer, right
   outer (the first slot's result is not tested). */
void add_side_pods(void)
{
    SidePodsToAdd = 2;
    fill_side_pod_slot_if_empty(&SidePodLeftInner);
    if (!fill_side_pod_slot_if_empty(&SidePodRightInner)) return;
    if (!fill_side_pod_slot_if_empty(&SidePodLeftOuter)) return;
    fill_side_pod_slot_if_empty(&SidePodRightOuter);
}

void apply_front_pod(void)
{
    add_front_pod();
    finish_upgrade();
}

void apply_side_pods(void)
{
    add_side_pods();
    finish_upgrade();
}

void apply_trailing_pods(void)
{
    add_trailing_pod();
    finish_upgrade();
}

/* UpgradeList0..3 keep their MAIN offsets so the frozen DS tables need no shadow copy.
   Compare those address tokens here and run their already translated logic in C. The
   fallback keeps support for injected/unknown entries used by callers that extend a list
   at runtime; ReturnNear is the table's ordinary no-op apply. */
extern void UpgradeNeverAvailable(void);
extern void SingleShotAvailable(void);
extern void HeavyShotAvailable(void);
extern void ForkShotAvailable(void);
extern void TwinRising3Available(void);
extern void TwinRising16Available(void);
extern void BeamAvailable(void);
extern void SideShotsAvailable(void);
extern void MissilesAvailable(void);
extern void FrontPodAvailable(void);
extern void SidePodsAvailable(void);
extern void TrailingPodsAvailable(void);
extern void ShipForm1Available(void);
extern void ShipForm2Available(void);
extern void ReturnNear(void);
extern void ApplySingleShot(void);
extern void ApplyHeavyShot(void);
extern void ApplyForkShot(void);
extern void ApplyTwinRising3(void);
extern void ApplyTwinRising16(void);
extern void ApplyBeam(void);
extern void ApplySideShots(void);
extern void ApplyMissiles(void);
extern void ApplyFrontPod(void);
extern void ApplySidePods(void);
extern void ApplyTrailingPods(void);
extern void ApplyShipForm1(void);
extern void ApplyShipForm2(void);

word pods_upgrade_condition(word routine)
{
    if (routine == (word)(main_routine)UpgradeNeverAvailable) return upgrade_never_available();
    if (routine == (word)(main_routine)SingleShotAvailable) return single_shot_available();
    if (routine == (word)(main_routine)HeavyShotAvailable) return heavy_shot_available();
    if (routine == (word)(main_routine)ForkShotAvailable) return fork_shot_available();
    if (routine == (word)(main_routine)TwinRising3Available) return twin_rising3_available();
    if (routine == (word)(main_routine)TwinRising16Available) return twin_rising16_available();
    if (routine == (word)(main_routine)BeamAvailable) return beam_available();
    if (routine == (word)(main_routine)SideShotsAvailable) return side_shots_available();
    if (routine == (word)(main_routine)MissilesAvailable) return missiles_available();
    if (routine == (word)(main_routine)FrontPodAvailable) return front_pod_available();
    if (routine == (word)(main_routine)SidePodsAvailable) return side_pods_available();
    if (routine == (word)(main_routine)TrailingPodsAvailable) return trailing_pods_available();
    if (routine == (word)(main_routine)ShipForm1Available) return ship_form1_available();
    if (routine == (word)(main_routine)ShipForm2Available) return ship_form2_available();
    return pods_call_condition(routine);
}

void pods_apply_upgrade(word routine)
{
    if (routine == (word)(main_routine)ReturnNear) return;
    if (routine == (word)(main_routine)ApplySingleShot) { apply_single_shot(); return; }
    if (routine == (word)(main_routine)ApplyHeavyShot) { apply_heavy_shot(); return; }
    if (routine == (word)(main_routine)ApplyForkShot) { apply_fork_shot(); return; }
    if (routine == (word)(main_routine)ApplyTwinRising3) { apply_twin_rising3(); return; }
    if (routine == (word)(main_routine)ApplyTwinRising16) { apply_twin_rising16(); return; }
    if (routine == (word)(main_routine)ApplyBeam) { apply_beam(); return; }
    if (routine == (word)(main_routine)ApplySideShots) { apply_side_shots(); return; }
    if (routine == (word)(main_routine)ApplyMissiles) { apply_missiles(); return; }
    if (routine == (word)(main_routine)ApplyFrontPod) { apply_front_pod(); return; }
    if (routine == (word)(main_routine)ApplySidePods) { apply_side_pods(); return; }
    if (routine == (word)(main_routine)ApplyTrailingPods) { apply_trailing_pods(); return; }
    if (routine == (word)(main_routine)ApplyShipForm1) { apply_ship_form1(); return; }
    if (routine == (word)(main_routine)ApplyShipForm2) { apply_ship_form2(); return; }
    pods_call_main((main_routine)routine);
}

/* ---- placing the side pods and nudging the ship ------------------------------------------ */

/* PlaceRecordFromOffsetPair: pod (NO_RECORD: nothing) = anchor + table[anchor REC_SPRITE]
   (Y, X pairs) with 2 * OffsetXWork more in X, X clamped to 0..PLAYFIELD_MAX_X (signed); a
   clamp sets ClampXLowSeen/ClampXHighSeen. The tables hold three pairs and are not bound
   checked: a dying ship (sprite 3) reads the next table's first pair. */
void place_record_from_offset_pair(Record *pod, word *table, Record *anchor)
{
    word *pair;

    if (pod == NO_RECORD) return;
    pair = (word *)((word)table + (word)(anchor->sprite << 2));
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
    place_record_from_offset_pair((Record *)SidePodRightOuter, SidePodOffsetsRightOuter, anchor);
    place_record_from_offset_pair((Record *)SidePodRightInner, SidePodOffsetsRightInner, anchor);
    OffsetXWork = SidePodSpreadLeft;
    place_record_from_offset_pair((Record *)SidePodLeftOuter, SidePodOffsetsLeftOuter, anchor);
    place_record_from_offset_pair((Record *)SidePodLeftInner, SidePodOffsetsLeftInner, anchor);
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

/* ---- pod updates -------------------------------------------------------------------- */

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

/* The first live size-1 pool A record other than type 1 within 10h (signed, inclusive) of
   the pod, skipping the pod itself (same REC_SAVE_BUFFER): a pickup is collected; an
   enemy is destroyed and the pod takes a hit, and when that was its last hit point the
   enemy is returned (the oracle's CF with BX). Other kinds are passed over. Nothing in the
   demo. Pool B is not scanned: enemy shots never hit pods. (The oracle tests the size
   class once more before the enemy check; it is always 1 there.) */
Record *pod_collide_records(Record *pod)
{
    Record *r = POOL_A;
    word n, x, y;

    if (DemoActive == 1) return 0;
    x = pod->x;
    y = pod->y;
    for (n = POOL_A_COUNT; n != 0; n--, r++) {
        if (r->status == 0 || r->type == 1 || r->size_class != 1) continue;
        if ((sword)y > (sword)(r->y + 0x10) || (sword)y < (sword)(r->y - 0x10)) continue;
        if ((sword)x > (sword)(r->x + 0x10) || (sword)x < (sword)(r->x - 0x10)) continue;
        if (pod->save_buffer == r->save_buffer) continue;
        if (r->kind == KIND_PICKUP) {
            collect_pickup(r);
            return 0;
        }
        if (r->kind != KIND_ENEMY) continue;
        destroy_record(r);
        return pod_take_hit(pod) ? r : 0;
    }
    return 0;
}

/* ExplodePod: the lost pod becomes a dying enemy (type 1, sfx 19h) and the upgrade slots
   are refreshed. REC_PREV_TYPE is not set: a stale 24h/25h in the slot makes the pod leave
   a type 26h remnant. */
void explode_pod(Record *pod)
{
    if (pod == NO_RECORD) return;
    if (SfxEnabled) SfxRequest = 0x19;
    pod->type = 1;
    pod->kind = KIND_ENEMY;
    pod->anim_counter = 0;
    pod->sprite = 0;
    refresh_upgrade_display();
}

/* Side pods: animate; lost on terrain, when the ship is destroyed (form 3+), or when an
   enemy collision takes the last hit point. PlaceSidePods runs elsewhere. A pod losing
   its last hit point to an enemy destroys that enemy a second time (DestroyRecord has no
   type-1 guard: score, sfx and GROUP_LIVE - 1 again, so a group's drop can come one
   member early; ReleaseEncounterMember then sees type 1), like the other pods. */
void pods_update_side_pod(Record *pod, word *slot)
{
    Record *enemy;

    CurrentSidePodSlot = (word)slot;
    if (PRIMARY->sprite < 3) {
        pod->sprite = SlowCount4 + 0x18;
        if (!pod_terrain_hit(pod)) {
            enemy = pod_collide_records(pod);
            if (enemy == 0) return;
            destroy_record(enemy);
        }
    }
    *(word *)CurrentSidePodSlot = NO_SLOT;
    explode_pod(pod);
}

/* Trailing pods (moved along the position history elsewhere): no terrain check. */
void pods_update_trailing_pod(Record *pod, word *slot)
{
    Record *enemy;

    CurrentTrailingPodSlot = (word)slot;
    if (PRIMARY->sprite < 3) {
        pod->sprite = SlowCount4 + 0x14;
        enemy = pod_collide_records(pod);
        if (enemy == 0) return;
        destroy_record(enemy);
    }
    *(word *)CurrentTrailingPodSlot = NO_SLOT;
    explode_pod(pod);
}

/* The front pod rides at FrontPodOffsets from the ship (PlaceAtPlayerOffset). Its slot is
   cleared before the second DestroyRecord of the enemy (after it for the other pods). */
void pods_update_front_pod(Record *pod)
{
    Record *enemy;

    if (PRIMARY->sprite < 3) {
        place_at_player_offset(pod, FrontPodOffsets);
        if (!pod_terrain_hit(pod)) {
            enemy = pod_collide_records(pod);
            if (enemy == 0) return;
            FrontPodRecord = NO_SLOT;
            destroy_record(enemy);
            explode_pod(pod);
            return;
        }
    }
    FrontPodRecord = NO_SLOT;
    explode_pod(pod);
}

/* KIND_POD handler: frozen until MapScrollPos > MAP_INTRO_END_POS (not in the demo), then
   by identity: sprite 0Fh is the front pod, else the slot that holds the record (a pod in
   no slot does nothing). Pods never reach FinishRecordUpdate. */
void update_pod(Record *pod)
{
    if (DemoActive != 1 && MapScrollPos <= MAP_INTRO_END_POS) return;
    if (pod->sprite == 0x0F) pods_update_front_pod(pod);
    else if ((word)pod == SidePodLeftInner) pods_update_side_pod(pod, &SidePodLeftInner);
    else if ((word)pod == SidePodRightInner) pods_update_side_pod(pod, &SidePodRightInner);
    else if ((word)pod == SidePodLeftOuter) pods_update_side_pod(pod, &SidePodLeftOuter);
    else if ((word)pod == SidePodRightOuter) pods_update_side_pod(pod, &SidePodRightOuter);
    else if ((word)pod == TrailingPodNear) pods_update_trailing_pod(pod, &TrailingPodNear);
    else if ((word)pod == TrailingPodFar) pods_update_trailing_pod(pod, &TrailingPodFar);
}

/* ---- explosions ------------------------------------------------------------------- */

void store_record_saved_position(Record *r)
{
    r->saved_x = r->x;
    r->saved_y = r->y;
}

/* Small explosion step (REC_ANIM_COUNTER already advanced): frame = counter, then 1 (the
   bridge continues in ScrollRecordThenFinish). At 9 the record is removed, or a turret
   (REC_PREV_TYPE 24h/25h) leaves a type 26h wreck 8 px aside (X unclamped, stored as
   REC_SAVED); both skip the scroll and finish tail (0). */
word animate_explosion16(Record *r)
{
    if (r->anim_counter != 9) {
        r->sprite = r->anim_counter;
        return 1;
    }
    if (r->prev_type == 0x24) {
        r->direction = DIR_LEFT;
        r->type = 0x26;
        r->sprite = 0x97;
        r->x -= 8;
    } else if (r->prev_type == 0x25) {
        r->direction = DIR_RIGHT;
        r->type = 0x26;
        r->sprite = 0x91;
        r->x += 8;
    } else {
        remove_record(r);
        return 0;
    }
    store_record_saved_position(r);
    return 0;
}

/* Large explosion step: frame counter + 3 (1: scroll and finish), removed at 0Ch (0). */
word animate_explosion32(Record *r)
{
    if (r->anim_counter == 0x0C) {
        remove_record(r);
        return 0;
    }
    r->sprite = r->anim_counter + 3;
    return 1;
}

/* ---- pickups and the player hit tests ------------------------------------------------------ */

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

/* Body contact of a live record (not a pickup, not type 0/1; size 1 or 2) with the ship:
   the record is destroyed (not during a segmented boss) and a tank is lost. */
void check_record_hits_player(Record *r)
{
    word hit;

    if (r->status == 0 || r->kind == KIND_PICKUP || r->type == 0 || r->type == 1) return;
    if (r->size_class == 1) hit = small_record_hits_player(r);
    else if (r->size_class == 2) hit = large_record_hits_player(r);
    else return;
    if (!hit) return;
    if (SegBossActive != 1) destroy_record(r);
    lose_player_energy_tank();
}

/* CollectPickup: only while the ship form is below 3 (else the pickup stays): sfx 7,
   score 20h, the item's handler (PickupHandlers, with BP = PrimaryRecord in the oracle;
   REC_ITEM_INDEX 0..4, the table is unchecked), then the pickup is removed (PickupDone). */
void collect_pickup(Record *pickup)
{
    if (PRIMARY->sprite >= 3) return;
    if (SfxEnabled) SfxRequest = 7;
    add_score_bcd(0x20);
    switch (pickup->item_index) {
    case 1: pickup_upgrade_selector(); break;
    case 2: pickup_energy(); break;
    case 3: smart_bomb_all(); break;
    case 4: pickup_fuel(); break;
    /* 0: nothing (ReturnNear) */
    }
    remove_record(pickup);
}

/* ---- reset ------------------------------------------------------------------------ */

/* Frees all of pool A and the primary (PoolAPointers from the end: the primary gets the
   first save buffer), resets weapon, side shots, missiles, pod slots and ship form 0,
   resets the upgrade slots and redraws them. */
void reset_pool_a_and_upgrades(void)
{
    Record *r;
    word n;

    SaveBufferCursor = (word)PoolASaveBuffers;
    for (n = POOL_A_POINTER_COUNT; n != 0; n--) {
        r = (Record *)PoolAPointers[n - 1];
        r->status = 0;
        r->step_error = 0;
        r->flash_timer = 0;
        r->type = 0;
        r->draw_pass = 1;
        r->direction = DIR_UP;
        r->save_buffer = SaveBufferCursor;
        SaveBufferCursor += POOL_A_SAVE_BYTES;
    }
    WeaponMode = WEAPON_SINGLE;
    SideShotsEnabled = 0;
    MissileAmmo = 0;
    TrailingPodNear = NO_SLOT;
    TrailingPodFar = NO_SLOT;
    SidePodLeftInner = NO_SLOT;
    SidePodRightInner = NO_SLOT;
    SidePodLeftOuter = NO_SLOT;
    SidePodRightOuter = NO_SLOT;
    FrontPodRecord = NO_SLOT;
    PRIMARY->sprite = 0;
    (void)init_upgrade_slots();
    (void)render_draw_upgrade_slots();
}

/* ---- attract demo steps ------------------------------------------------------------ */

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
    pod->y = 0xC8;
    pod->x = PLAYFIELD_MAX_X;
    pod->type = 0x50;
    pod->kind = KIND_ENEMY;
}

/* Homing on the ship + (8, 28h). */
void demo_launch_trailing_pod(Record *pod)
{
    demo_launch_pod(pod);
    pod->saved_x = PRIMARY->x + 8;
    pod->saved_y = PRIMARY->y + 0x28;
}

/* Step 6: a trailing pod launched from X 0. */
void demo_step_launch_trailing_pod_near(void)
{
    Record *pod;

    if (SfxEnabled) SfxRequest = 0x1E;
    add_trailing_pod();
    pod = (Record *)TrailingPodNear;
    demo_launch_trailing_pod(pod);
    pod->x = 0;
}

/* Step 7: the second trailing pod, homing 14h lower (TrailingPodFar is still empty when
   the near slot was the one filled). */
void demo_step_launch_trailing_pod_far(void)
{
    Record *pod;

    if (SfxEnabled) SfxRequest = 0x1E;
    add_trailing_pod();
    pod = (Record *)TrailingPodFar;
    demo_launch_trailing_pod(pod);
    pod->saved_y += 0x14;
}

/* Steps 2 and 4: a side pod pair, the left one launched from X 0. */
void demo_step_launch_inner_side_pods(void)
{
    Record *left;

    if (SfxEnabled) SfxRequest = 0x1E;
    add_side_pods();
    left = (Record *)SidePodLeftInner;
    demo_launch_pod(left);
    left->x = 0;
    demo_launch_pod((Record *)SidePodRightInner);
}

void demo_step_launch_outer_side_pods(void)
{
    Record *left;

    if (SfxEnabled) SfxRequest = 0x1E;
    add_side_pods();
    left = (Record *)SidePodLeftOuter;
    demo_launch_pod(left);
    left->x = 0;
    demo_launch_pod((Record *)SidePodRightOuter);
}
