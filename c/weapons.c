/* The player's fire button and every weapon pattern, the beam, homing-missile targeting
   and the attract demo's per-frame script, translated from the frozen oracle
   (asm-semantic-oracle-v1): HandleFireButton and everything it fires, UpdateBeam,
   FindMissileTarget, AllocPlayerShot/AllocPoolBRecordEvicting, RunDemoScriptFrame with
   its countdown and the small demo steps. Same state, same results; the oracle comments
   at each routine document the original contracts and quirks.

   "ship" is the oracle's BP: PrimaryRecord for the real fire button; in the demo's
   UpdateBeam whatever the caption blitter left in BP (see run_demo_script_frame).

   SEGMENT: CGAME
   OWNS: AllocPoolBRecordEvicting ClearFireLatch HandleFireButton FireMainWeapon
   OWNS: WeaponPatternCases FireFrontPodBurst AllocFrontPodShot FireHeavyShot FireSingleShot
   OWNS: SpawnShotAtMuzzle PlaceShotAtMuzzle FireForkShot UpdateBeam AppendBeamLink StartBeam
   OWNS: SpawnBeamLink FireTwinRising16 FireTwinRising3 FirePodSideShots SpawnSideShotFromSI
   OWNS: FireSidePodShots FireTrailingPodShots FirePodWeapon PodWeaponPatternCases
   OWNS: PodTwinRising16 PodTwinRising3 PodHeavyShot PodForkShot SpawnShotAtPod
   OWNS: AllocPlayerShot FireMissile CopyRecordPositionPlus10 FirePlayerSideShots
   OWNS: FindMissileTarget RunDemoScriptFrame DemoCountDownStep DemoStepActions
   OWNS: DemoStepNextWeaponMode DemoStepEnableSideShots DemoStepGiveMissile DemoRiseShipToY60
*/
#include "game.h"
#include "enemies.h"
#include "pods.h"
#include "player.h"
#include "render.h"


/* Player shot types (REC_TYPE of pool B records spawned here). */
#define SHOT_STRAIGHT 2         /* single, heavy, fork, pod shots */
#define SHOT_SIDE_UP_LEFT 5
#define SHOT_SIDE_UP_RIGHT 6
#define SHOT_RISING3 7          /* WEAPON_TWIN_RISING3 */
#define SHOT_RISING16 8         /* WEAPON_TWIN_RISING16 */
#define SHOT_BEAM_LINK 9
#define SHOT_MISSILE 0x0A
#define SHOT_FRONT_POD 0x0C

/* ASM that stays in MAIN, reached through FarCallMainNearViaAX (c/game.h). */
extern void DrawDemoCaption(void);          /* platform thunk in c/weapons.asm */
extern Record *demo_step_launch_front_pod(void);
extern void demo_step_spawn_path_enemy51(Record *here);


/* DrawDemoCaption with SI = PanelSegment image and BP = bp: the result is BP as the
   blitter leaves it (its row width), which the oracle passes on as UpdateBeam's BP. */
Record *draw_demo_caption(main_routine target, word image, Record *bp);
#pragma aux draw_demo_caption = "push bp" "mov bp, di" "call far ptr FarCallMainNearViaAX" \
    "mov ax, bp" "pop bp" parm [ax] [si] [di] value [ax] modify exact [ax bx cx dx si di es]

void handle_fire_button(Record *ship);

/* FindFreeRecordPoolB; when pool B is full, removes the first record that is not a beam
   link, a missile or KIND_POD (all of them kept: the first record) and returns it.
   *si is the oracle's SI, which the pod shots keep their pod in: RemoveRecord changes it
   for a KIND_ENEMY victim (group clearing) and for the all-kept fallback victim (the
   BeamList walk), and the pod code then goes on from that SI. Neither happens in play
   (pool B never holds KIND_ENEMY records; 34 kept records need more beam links and
   missiles than exist), and most such stray pod shots are evicted and rewritten by the
   next allocation of the salvo, but the effect is kept. */
Record *alloc_pool_b_evicting(Record **si)
{
    Record *r = find_free_record_pool_b();
    word n;

    if (r != NO_RECORD) return r;
    for (r = POOL_B, n = POOL_B_COUNT; n != 0; ++r, --n)
        if (r->type != SHOT_BEAM_LINK && r->type != SHOT_MISSILE && r->kind != KIND_POD) break;
    if (n == 0) r = POOL_B;
    *si = (Record *)remove_record_si(r, (word)*si);
    return r;
}

/* A pool B record set up as a player shot: type 2, sprite 32h, heading up,
   REC_SHOT_TIMER FFFFh (lives until out of bounds). *si as in alloc_pool_b_evicting. */
Record *alloc_player_shot_si(Record **si)
{
    Record *shot = alloc_pool_b_evicting(si);

    shot->status = 1;
    shot->player_shot = 1;
    shot->direction = DIR_UP;
    shot->sprite = 0x32;
    shot->size_class = 0;
    shot->kind = KIND_TYPED;
    shot->type = SHOT_STRAIGHT;
    shot->shot_timer = 0xFFFF;
    return shot;
}

/* The same for shots that do not use SI afterwards. */
Record *alloc_player_shot(void)
{
    Record *si;

    return alloc_player_shot_si(&si);
}

/* Shot position = ship + MuzzleOffsets[ship REC_SPRITE] (dY, dX). The table is only
   3 entries long; larger sprites (the dying ship) read on into BeamList (16-bit wrap). */
void place_shot_at_muzzle(Record *shot, Record *ship)
{
    word *muzzle = (word *)((word)MuzzleOffsets + (word)(ship->sprite << 2));

    shot->y = muzzle[0] + ship->y;
    shot->x = muzzle[1] + ship->x;
}

Record *spawn_shot_at_muzzle(Record *ship)
{
    Record *shot = alloc_player_shot();

    place_shot_at_muzzle(shot, ship);
    return shot;
}

/* WEAPON_SINGLE: one type 2 shot straight up from the muzzle. Modes 0..2 are uncounted:
   they fire on every accepted trigger. */
void fire_single_shot(Record *ship)
{
    if (SfxEnabled) SfxRequest = 0x13;
    spawn_shot_at_muzzle(ship);
}

/* WEAPON_HEAVY: the single shot with sprite 33h (an extra hit point of damage). */
void fire_heavy_shot(Record *ship)
{
    spawn_shot_at_muzzle(ship)->sprite = 0x33;
    if (SfxEnabled) SfxRequest = 0x14;
}

/* WEAPON_FORK: one shot up and one steered by the horizontal input (IN_XMINUS wins). */
void fire_fork_shot(Record *ship)
{
    Record *shot;

    if (SfxEnabled) SfxRequest = 0x15;
    shot = alloc_player_shot();
    shot->sprite = 0x18;
    place_shot_at_muzzle(shot, ship);
    shot = alloc_player_shot();
    place_shot_at_muzzle(shot, ship);
    shot->direction = DIR_UP_LEFT;
    shot->sprite = 0x1F;
    if (InputBits & IN_XMINUS) return;
    shot->direction = DIR_UP_RIGHT;
    shot->sprite = 0x19;
    if (InputBits & IN_XPLUS) return;
    shot->direction = DIR_UP;
    shot->sprite = 0x18;
}

/* ++ShotsLiveType9 and a new type 9 link appended at BeamListEnd (unchecked here), at the
   muzzle snapped to 8 px + 8, sprite 6Ch. */
Record *spawn_beam_link(Record *ship)
{
    Record *link;

    ++ShotsLiveType9;
    link = alloc_player_shot();
    *(word *)BeamListEnd = (word)link;
    BeamListEnd += 2;
    link->type = SHOT_BEAM_LINK;
    place_shot_at_muzzle(link, ship);
    link->x = (link->x & 0xFFF8) + 8;
    link->sprite = 0x6C;
    return link;
}

/* WEAPON_BEAM: one beam at a time. Resets BeamList (FFFFh up to its terminator) and
   spawns the head (sprite 6Ah, 8 px left) and a second link. */
void start_beam(Record *ship)
{
    word *entry;
    Record *head;

    if (ShotsAtFireBeam != 0) return;
    if (SfxEnabled) SfxRequest = 0x11;
    BeamListEnd = (word)BeamList;
    for (entry = BeamList; entry != &BeamListTerminator; ++entry) *entry = 0xFFFF;
    head = spawn_beam_link(ship);
    head->sprite = 0x6A;
    head->x -= 8;
    spawn_beam_link(ship);
}

/* Each frame every link takes the head's Y (the head rises 4 px) and X = head X + 8 * i;
   sprites 6Bh, tail 6Ch. On FrameParity 1 it first grows: head X != 0 adds a link and
   shifts the head 8 px left, plus one more unless the old tail's X is C8h; head X = 0
   adds one. A full BeamList returns before aligning (no rise on those frames). The
   second growth link is appended without a new full check: it can overwrite
   BeamListTerminator, and the walk then runs on past the list, through whatever words
   follow it, until one is FFFFh (volatile: those stray "links" may overlap each other
   and the end of the segment, so the stores stay in the oracle's order). */
void update_beam(Record *ship)
{
    word *entry;
    volatile Record *link;
    word x, y;

    if (ShotsLiveType9 == 0) return;
    if (FrameParity == 1) {
        if (BeamListEnd == (word)&BeamListTerminator) return;
        if (BeamList[0] == 0xFFFF) return;
        if (((Record *)BeamList[0])->x != 0) {
            spawn_beam_link(ship);
            ((Record *)BeamList[0])->x -= 8;
            if (((Record *)*(word *)(BeamListEnd - 4))->x == 0xC8) goto align;
        }
        spawn_beam_link(ship);
    }
align:
    entry = BeamList;
    if (*entry == 0xFFFF) return;
    link = (Record *)*entry++;
    link->y -= 4;
    x = link->x + 8;
    y = link->y;
    while (*entry != 0xFFFF) {
        link = (Record *)*entry++;
        link->x = x;
        x += 8;
        link->y = y;
        link->sprite = 0x6B;
    }
    /* The entry before the terminator: the tail, or the head of a one-link beam. */
    ((Record *)entry[-1])->sprite = 0x6C;
}

/* Two shots of the given rising type (7: sprite 37h, 8: sprite 35h) from the muzzle, the
   second 8 px lower; each counted in ShotsLiveMain before it is allocated. */
void spawn_twin_rising(Record *ship, word type)
{
    Record *shot;
    word sprite = type == SHOT_RISING16 ? 0x35 : 0x37;

    ++ShotsLiveMain;
    shot = alloc_player_shot();
    shot->type = type;
    shot->sprite = sprite;
    place_shot_at_muzzle(shot, ship);
    ++ShotsLiveMain;
    shot = alloc_player_shot();
    shot->type = type;
    shot->sprite = sprite;
    place_shot_at_muzzle(shot, ship);
    shot->y += 8;
}

/* WEAPON_TWIN_RISING16 / WEAPON_TWIN_RISING3: one burst at a time. */
void fire_twin_rising16(Record *ship)
{
    if (ShotsAtFireMain != 0) return;
    if (SfxEnabled) SfxRequest = 0x17;
    spawn_twin_rising(ship, SHOT_RISING16);
}

void fire_twin_rising3(Record *ship)
{
    if (ShotsAtFireMain != 0) return;
    if (SfxEnabled) SfxRequest = 0x16;
    spawn_twin_rising(ship, SHOT_RISING3);
}

/* ++ShotsLiveSide and a type 5 side shot at pod (X + 4) & ~3, Y + 4, sprite 8. */
Record *spawn_side_shot(Record **pod)
{
    Record *shot;

    ++ShotsLiveSide;
    if (SfxEnabled) SfxRequest = 0x12;
    shot = alloc_player_shot_si(pod);
    shot->x = (*pod)->x + 4;
    shot->y = (*pod)->y + 4;
    shot->x &= 0xFFFC;
    shot->sprite = 8;
    shot->type = SHOT_SIDE_UP_LEFT;
    return shot;
}

/* *pod (the oracle's SI; FFFFh = none): its type 6 and type 5 side shots when side
   shots are enabled, one burst at a time. */
void fire_pod_side_shots(Record **pod)
{
    if (*pod == NO_RECORD) return;
    if (SideShotsEnabled == 0) return;
    if (ShotsAtFireSide != 0) return;
    spawn_side_shot(pod)->type = SHOT_SIDE_UP_RIGHT;
    spawn_side_shot(pod);
}

/* A player shot at pod (Y, X + 4). */
Record *spawn_shot_at_pod(Record **pod)
{
    Record *shot = alloc_player_shot_si(pod);

    shot->y = (*pod)->y;
    shot->x = (*pod)->x + 4;
    return shot;
}

/* Pod twin modes add 2 to ShotsLiveMain per pod, gated by the same ShotsAtFireMain
   snapshot, so every pod fires in the same salvo. */
void pod_twin_rising(Record **pod, word type)
{
    Record *shot;
    word sprite = type == SHOT_RISING16 ? 0x35 : 0x37;

    if (ShotsAtFireMain != 0) return;
    ShotsLiveMain += 2;
    shot = spawn_shot_at_pod(pod);
    shot->type = type;
    shot->sprite = sprite;
    shot = spawn_shot_at_pod(pod);
    shot->type = type;
    shot->sprite = sprite;
    shot->y += 8;
}

/* One diagonal shot at pod (Y, X + 4) in PodShotDirection; trailing pods (FFFFh): up-left
   when pod X <= 58h (unsigned), else up-right. Sprite 19h up-right, 1Fh otherwise. */
void pod_fork_shot(Record **pod)
{
    Record *shot = alloc_player_shot_si(pod);

    shot->y = (*pod)->y;
    shot->x = (*pod)->x + 4;
    shot->direction = PodShotDirection;
    if (PodShotDirection == 0xFFFF) {
        shot->direction = DIR_UP_LEFT;
        if ((*pod)->x > 0x58) shot->direction = DIR_UP_RIGHT;
    }
    shot->sprite = shot->direction == DIR_UP_RIGHT ? 0x19 : 0x1F;
}

/* *pod (the oracle's SI; FFFFh = none): its WeaponMode pattern. Modes 0..2 are uncounted and
   silent; beam mode fires nothing. WeaponMode is an unchecked table index in the oracle
   (always 0..5). */
void fire_pod_weapon(Record **pod)
{
    if (*pod == NO_RECORD) return;
    switch (WeaponMode) {
    case WEAPON_SINGLE: spawn_shot_at_pod(pod); break;
    case WEAPON_HEAVY: spawn_shot_at_pod(pod)->sprite = 0x33; break;
    case WEAPON_FORK: pod_fork_shot(pod); break;
    case WEAPON_TWIN_RISING3: pod_twin_rising(pod, SHOT_RISING3); break;
    case WEAPON_TWIN_RISING16: pod_twin_rising(pod, SHOT_RISING16); break;
    }
}

/* Each side pod's weapon; PodShotDirection (up-left for the left pods, up-right for the
   right ones) matters only to the fork shot. */
void fire_side_pod_shots(void)
{
    Record *pod;

    PodShotDirection = DIR_UP_LEFT;
    pod = (Record *)SidePodLeftInner;
    fire_pod_weapon(&pod);
    PodShotDirection = DIR_UP_RIGHT;
    pod = (Record *)SidePodRightInner;
    fire_pod_weapon(&pod);
    PodShotDirection = DIR_UP_LEFT;
    pod = (Record *)SidePodLeftOuter;
    fire_pod_weapon(&pod);
    PodShotDirection = DIR_UP_RIGHT;
    pod = (Record *)SidePodRightOuter;
    fire_pod_weapon(&pod);
}

/* The weapon and side shots of the two trailing pods (fork shots outward by pod X); the
   side shots go on from the SI the weapon left (see alloc_pool_b_evicting). */
void fire_trailing_pod_shots(void)
{
    Record *pod;

    PodShotDirection = 0xFFFF;
    pod = (Record *)TrailingPodNear;
    fire_pod_weapon(&pod);
    fire_pod_side_shots(&pod);
    pod = (Record *)TrailingPodFar;
    fire_pod_weapon(&pod);
    fire_pod_side_shots(&pod);
}

/* An AllocPlayerShot of type 0Ch with REC_SHOT_TIMER 7. */
Record *alloc_front_pod_shot(void)
{
    Record *shot = alloc_player_shot();

    shot->type = SHOT_FRONT_POD;
    shot->shot_timer = 7;
    return shot;
}

/* Three type 0Ch shots from FrontPodRecord (up, up-left, up-right), one burst at a time.
   FrontPodRecord is not checked here (the demo's step 8 fires it directly). */
void fire_front_pod_burst(void)
{
    Record *shot, *pod;

    if (ShotsAtFireFrontPod != 0) return;
    if (SfxEnabled) SfxRequest = 0x18;
    ++ShotsLiveFrontPod;
    shot = alloc_front_pod_shot();
    pod = (Record *)FrontPodRecord;
    shot->y = pod->y - 6;
    shot->x = pod->x + 4;
    ++ShotsLiveFrontPod;
    shot = alloc_front_pod_shot();
    pod = (Record *)FrontPodRecord;
    shot->y = pod->y - 2;
    shot->x = pod->x - 4;
    shot->direction = DIR_UP_LEFT;
    ++ShotsLiveFrontPod;
    shot = alloc_front_pod_shot();
    pod = (Record *)FrontPodRecord;
    shot->y = pod->y - 2;
    shot->x = pod->x + 0x0C;
    shot->direction = DIR_UP_RIGHT;
}

/* Round-robin from TargetSearchCursor: the next live KIND_ENEMY, not types 1/21h/22h/26h,
   with Y <= E0h (unsigned); FFFFh when none of POOL_A_COUNT records qualifies. A cursor at
   or past PoolAEnd restarts at PoolA without using up a step. */
Record *find_missile_target(void)
{
    word n = POOL_A_COUNT;
    Record *r = (Record *)TargetSearchCursor;

    for (;;) {
        if ((word)r >= (word)PoolAEnd) {
            TargetSearchCursor = (word)PoolA;
            r = POOL_A;
            continue;
        }
        if (r->status != 0 && r->type != 1 && r->type != 0x26 && r->type != 0x21 && r->type != 0x22
            && r->y <= 0xE0 && r->kind == KIND_ENEMY) {
            TargetSearchCursor = (word)(r + 1);
            return r;
        }
        ++r;
        if (--n == 0) return NO_RECORD;
    }
}

/* Record dst's X, then Y = src's + 0Ah each. */
void copy_position_plus10(Record *dst, Record *src)
{
    dst->x = src->x + 0x0A;
    dst->y = src->y + 0x0A;
}

/* A homing missile (type 0Ah) at FindMissileTarget's record when missiles remain and
   MissilesLive is not exactly 1. Without a target the allocated record is left as it
   was (already placed; an eviction has still happened). REC_DIRECTION, REC_SPRITE and
   REC_STEP_ERROR are not set: the first chase steps depend on the slot's old occupant. */
void fire_missile(Record *ship)
{
    Record *si, *missile, *target;

    if (MissileAmmo == 0) return;
    if (MissilesLive == 1) return;
    missile = alloc_pool_b_evicting(&si);
    copy_position_plus10(missile, ship);
    target = find_missile_target();
    if (target == NO_RECORD) return;
    missile->target = (word)target;
    missile->status = 1;
    missile->player_shot = 1;
    missile->size_class = 0;
    missile->kind = KIND_TYPED;
    missile->type = SHOT_MISSILE;
    missile->missile_locked = 1;
    if (SfxEnabled) SfxRequest = 0x11;
    ++MissilesLive;
    --MissileAmmo;
}

/* Types 5 and 6 side shots from the ship when side shots are enabled, one burst at a
   time (one sound request for the pair). */
void fire_player_side_shots(Record *ship)
{
    Record *shot;

    if (SideShotsEnabled == 0) return;
    if (ShotsAtFireSide != 0) return;
    ++ShotsLiveSide;
    if (SfxEnabled) SfxRequest = 0x12;
    shot = alloc_player_shot();
    copy_position_plus10(shot, ship);
    shot->x &= 0xFFFC;
    shot->sprite = 8;
    shot->type = SHOT_SIDE_UP_LEFT;
    ++ShotsLiveSide;
    shot = alloc_player_shot();
    copy_position_plus10(shot, ship);
    shot->x &= 0xFFFC;
    shot->sprite = 8;
    shot->type = SHOT_SIDE_UP_RIGHT;
}

/* Starts the beam in WEAPON_BEAM, fires the front pod burst when there is a front pod,
   then the WeaponMode pattern (an unchecked table index in the oracle, always 0..5). */
void fire_main_weapon(Record *ship)
{
    if (WeaponMode == WEAPON_BEAM) start_beam(ship);
    if (FrontPodRecord != 0xFFFF) fire_front_pod_burst();
    switch (WeaponMode) {
    case WEAPON_SINGLE: fire_single_shot(ship); break;
    case WEAPON_HEAVY: fire_heavy_shot(ship); break;
    case WEAPON_FORK: fire_fork_shot(ship); break;
    case WEAPON_TWIN_RISING3: fire_twin_rising3(ship); break;
    case WEAPON_TWIN_RISING16: fire_twin_rising16(ship); break;
    }
}

/* Fires when the primary button is newly pressed, held with rapid fire, or every 16
   frames while held; released clears FireLatch. Early in the level (MapScrollPos <=
   MAP_INTRO_END_POS, not the demo) only the single shot fires (the fork shot in
   WEAPON_FORK; heavy, twin and beam fall back to it). Otherwise the ShotsLive* snapshot
   is taken and missile, side shots, pod shots and the main weapon fire in turn. Demo:
   step 8 fires only the front pod burst, steps 10h.. only the missile. */
void handle_fire_button(Record *ship)
{
    if (!(InputBits & IN_BUTTON_PRIMARY)) {
        FireLatch = 0;
        return;
    }
    if (FireLatch != 0 && RapidFireEnabled != 1 && FrameCount16 != 0x0F) return;
    FireLatch = 1;
    if (MapScrollPos <= MAP_INTRO_END_POS && DemoActive == 0) {
        if (WeaponMode == WEAPON_FORK) fire_fork_shot(ship);
        else fire_single_shot(ship);
        return;
    }
    ShotsAtFireMain = ShotsLiveMain;
    ShotsAtFireBeam = ShotsLiveType9;
    ShotsAtFireSide = ShotsLiveSide;
    ShotsAtFireFrontPod = ShotsLiveFrontPod;
    if (DemoActive == 1) {
        if (DemoStep == 8) {
            fire_front_pod_burst();
            return;
        }
        if (DemoStep > 0x0F) {
            fire_missile(ship);
            return;
        }
    }
    fire_missile(ship);
    fire_player_side_shots(ship);
    fire_trailing_pod_shots();
    fire_side_pod_shots();
    fire_main_weapon(ship);
}

/* Counts DemoStepTimer down; at 0 reloads it (64h), advances DemoStep, shows that
   step's upgrade slot and status (unless FFFFh) and runs its action. DemoStep indexes
   the oracle's action table unchecked (the demo ends at step 13h, before 14h). bp is the
   oracle's BP here, the ship or the blitter's leftover: only the path-enemy spawn
   reads it (SpawnEnemyHere copies its position into REC_SAVED_X/Y). */
void demo_count_down_step(Record *bp)
{
    word *row;

    if (--DemoStepTimer != 0) return;
    DemoStepTimer = 0x64;
    ++DemoStep;
    row = &DemoScript[DemoStep * 3];
    if (row[1] != 0xFFFF) {
        SelectedUpgradeSlot = row[1];
        DemoUpgradeStatus = row[2];
        /* The native renderer returns the old ES:SI pixel cursor. No demo-step action
           consumes that cursor; it preserves BP as DrawUpgradeSlots did. */
        render_draw_upgrade_slots();
    }
    switch (DemoStep) {
    case 1: bp = demo_step_launch_front_pod(); break;
    case 2: demo_step_launch_inner_side_pods(); break;
    case 3: case 5: demo_step_next_ship_form(); break;
    case 4: demo_step_launch_outer_side_pods(); break;
    case 6: demo_step_launch_trailing_pod_near(); break;
    case 7: demo_step_launch_trailing_pod_far(); break;
    case 10: case 12: case 13: case 14: case 15: ++WeaponMode; break;
    case 11: SideShotsEnabled = 1; break;
    case 16: demo_step_spawn_path_enemy51(bp); break;
    case 17: MissileAmmo = 1; break;
    /* 0, 8, 9, 18, 19: no action. */
    }
}

/* Step 0: the ship rises 1 px per frame (with position history and pod placement) to
   Y = 60h, then waits 32h frames; the countdown runs only once it is there. */
void demo_rise_ship_to_y60(Record *bp)
{
    if (PRIMARY->y == 0x60) {
        demo_count_down_step(bp);
        return;
    }
    --PRIMARY->y;
    store_apply_history_and_placement(PRIMARY);
    if (PRIMARY->y == 0x60) DemoStepTimer = 0x32;
}

/* One attract-demo frame: caption, beam, forced fire; advances DemoStep when its timer
   expires and applies that step's upgrade and action. From step 8, while DemoStepTimer
   >= 14h, the button is pressed on frames 0Fh, 11h and 13h of a 14h-frame DemoFireCycle
   (FireLatch cleared each frame). BP is not set before UpdateBeam: the caption blitter
   leaves its row width there, so new beam links take a stale muzzle anchor (UpdateBeam
   re-aligns every link to the head in the same call), and on frames without forced fire
   the step action also gets that BP. */
void run_demo_script_frame(Record *bp)
{
    ScrollDeltaY = 0;
    bp = draw_demo_caption(DrawDemoCaption, DemoScript[DemoStep * 3], bp);
    update_beam(bp);
    if (DemoStep >= 8 && DemoStepTimer >= 0x14) {
        InputBits = 0;
        if (++DemoFireCycle >= 0x14) DemoFireCycle = 0;
        if (DemoFireCycle == 0x0F || DemoFireCycle == 0x11 || DemoFireCycle == 0x13)
            InputBits = IN_BUTTON_PRIMARY;
        bp = PRIMARY;
        FireLatch = 0;
        handle_fire_button(bp);
    }
    if (DemoStep != 0) demo_count_down_step(bp);
    else demo_rise_ship_to_y60(bp);
}
