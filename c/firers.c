/* Animation-phase shots, hovering shooters, jittering fallers and patrol shots.
   Entered directly from C; state and tables remain in the original DOS segment.

   SEGMENT: CGAME
   OWNS: Type87AnimFireBurstA Type8FAnimFireBurstB CheckFirePhase
   OWNS: Type71FireThenDiveBelow60 Type2DHoverFireThenPlunge HoverFirePlungeTail
   OWNS: Type46HoverShootThenDive Type68JitterDescendFiring Type40JitterFallShooter
   OWNS: JitterThenFireBelow80 Type8APatrolShootDown32Alt Type47PatrolShootDown32B
   OWNS: Type89PatrolShootDown32 PatrolSpriteShootDown32
*/
#include "firers.h"
#include "enemies.h"

/* Both faces add 3 at X=60h. The firing BX is the unadjusted sprite; when
   throttled, the 44h store deliberately lands in BossKeyScreen at C9h/E7h. */
void animated_fire_burst(Record *r, word base)
{
    word phase = FrameCount64 >> 3;
    word bx = PingPongFrames8[phase] + base;

    r->sprite = bx;
    if (base == 0xDD ? r->x >= PLAYFIELD_CENTER_X : r->x <= PLAYFIELD_CENTER_X)
        r->sprite += 3;
    if (phase == 3) {
        bx = spawn_throttled_child(r, bx);
        if (bx != 0xFFFF) ((Record *)bx)->sprite = 0x44;
    }
    scroll_record_then_finish(r);
}

void hover_fire_plunge(Record *r, word sprite)
{
    r->sprite = sprite;
    if (r->y > 0x60) r->y += 4;
    else if (FrameCount128 == 0x7F) {
        r->direction = DIR_DOWN;
        /* The stale result is discarded; the caller's BX has no state effect. */
        spawn_throttled_child(r, 0);
    }
    scroll_record_then_finish(r);
}

/* Random axis is consumed even above the threshold. Test Y after the jitter;
   the spawned child can alias the firer, so the +2 follows the spawn. */
void jitter_fall_shooter(Record *r, word base)
{
    word index, *coordinate;

    r->sprite = PingPongFrames4[SlowCount4] + base;
    index = next_random_word() & 1;
    coordinate = (word *)((byte *)r + JitterAxisFields[index]);
    *coordinate += (FrameCount64 & 1) ? 1 : 0xFFFF;
    if ((sword)r->y >= 0x80) {
        if (FrameCount32 == 0x1F)
            spawn_throttled_child(r, (word)&JitterAxisFields[index]);
        r->y += 2;
    }
    scroll_record_then_finish(r);
}

void patrol_shoot_down32(Record *r, word sprite)
{
    r->sprite = sprite;
    if (FrameCount32 == 0x1F) spawn_shot_down(r, 0);
    horizontal_terrain_patrol(r);
}
