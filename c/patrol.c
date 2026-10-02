/* Terrain patrol and climbing enemies, translated from the frozen oracle.
   Entered from the C type dispatch; no ASM bridge or private state.

   SEGMENT: CGAME
   OWNS: Type1AWallPatrolA Type1BWallPatrolB WallPatrolTail
   OWNS: Type32DescendThenBounce DescendUntilBounceRowTail Type33TerrainBouncer
   OWNS: Type3CDescendThenBounceAlt Type3DAnimatedTerrainBouncer
   OWNS: Type4BDescendThenBounceUpRight Type4EAnimDescendThenBounce
   OWNS: Type8DClimbWalkerB Type8EClimbWalkerBFlipped ClimbWalkerBStep
   OWNS: Type8CClimbWalkerAFlipped Type8BClimbWalkerA ClimbWalkerAStep
   OWNS: ClimbWalkerSpriteAndShoot
   OWNS: Type5BScrollPastY_B0ThenType5C Type5CRiseFast4
   OWNS: Type84LurkUntilAligned Type84DirCases Type84FacingUp Type84SameColumn
   OWNS: Type84StartCharge Type84FacingDown Type84FacingRight Type84SameRow
   OWNS: Type84StartChargeH Type84FacingLeft
*/
#include "patrol.h"
#include "enemies.h"

word climb_walker_step(Record *r);

void wall_patrol(Record *r, word base)
{
    r->sprite = (SlowCount6 >> 1) + base;
    horizontal_terrain_patrol(r);
}

/* Stop at the first blocked diagonal; its free axis may already have moved.
   Reflect the vertical component only, retaining earlier successful steps. */
void type33_terrain_bouncer(Record *r)
{
    if (try_terrain_step(r) || try_terrain_step(r) || try_terrain_step(r))
        r->direction ^= 2;
    scroll_record_then_finish(r);
}

void descend_until_bounce_row(Record *r)
{
    if (r->y == 0x90) {
        r->type = 0x33;
        r->direction = DIR_UP_LEFT;
        type33_terrain_bouncer(r);
    } else scroll_record_then_finish(r);
}

void type32_descend_then_bounce(Record *r)
{
    r->sprite = 0x24;
    descend_until_bounce_row(r);
}

void type3d_animated_bouncer(Record *r)
{
    r->sprite = PingPongFrames4[SlowCount4] + 0xC5;
    type33_terrain_bouncer(r);
}

void type3c_descend_then_bounce(Record *r)
{
    r->sprite = 0xC5;
    if (r->y != 0xB0) {
        scroll_record_then_finish(r);
        return;
    }
    if (SfxEnabled != 0) SfxRequest = 0x1D;
    r->type++;
    r->direction = DIR_UP_LEFT;
    type3d_animated_bouncer(r);
}

void type4b_descend_then_bounce(Record *r)
{
    r->sprite = PingPongFrames4[SlowCount4] + 0xCF;
    if (r->y == 0x40) {
        r->type = 0x33;
        r->direction = DIR_UP_RIGHT;
        type33_terrain_bouncer(r);
    } else scroll_record_then_finish(r);
}

void type4e_animated_descender(Record *r)
{
    r->sprite = PingPongFrames4[SlowCount4] + 0xCF;
    descend_until_bounce_row(r);
}

/* The wall helper reports blocked=1 (its ASM ZF convention differs from
   TryTerrainStep). A blocked walker keeps the direction offset but no animation. */
void climbing_walker(Record *r, word type)
{
    word animation = 0;
    word blocked;
    Record *child;

    WalkerFacingStep = (type == 0x8B || type == 0x8E) ? 1 : 0xFFFF;
    blocked = climb_walker_step(r);
    if (type == 0x8B || type == 0x8C) {
        if (!blocked) animation = SlowCount4;
        r->sprite = 0x61 + 4 * WalkerFacingStep + animation + r->direction;
    } else {
        if (!blocked) animation = PingPongFrames4[SlowCount4];
        r->sprite = 0x13A + 3 * WalkerFacingStep + animation;
        if (r->direction != DIR_UP) r->sprite += 3;
    }
    if (FrameCount128 == 0x7F || FrameCount128 == 0x6B || FrameCount128 == 0x57) {
        child = spawn_aimed_shot(r);
        if (child != NO_RECORD) {
            child->sprite = 3;
            child->x -= 8;
            child->y -= 8;
        }
    }
    scroll_record_then_finish(r);
}

void type5c_rise_fast4(Record *r)
{
    r->sprite = 0x73;
    r->y -= 4;
    scroll_record_then_finish(r);
}

/* Test before scrolling, signed and strict; crossing runs the rise immediately. */
void type5b_scroll_then_rise(Record *r)
{
    if ((sword)r->y > 0xB0) {
        r->type = 0x5C;
        type5c_rise_fast4(r);
    } else scroll_record_then_finish(r);
}

/* Valid headings are 0..7; diagonals use the preceding cardinal heading.
   An aligned lurker changes type and returns without scroll, bounds or hits. */
void type84_lurk_until_aligned(Record *r)
{
    word aligned, column, row;

    switch (r->direction & 0xFFFE) {
    case DIR_UP:
        if (PRIMARY->y > r->y) goto miss;
        goto same_column;
    case DIR_DOWN:
        if (PRIMARY->y < r->y) goto miss;
same_column:
        column = PRIMARY->x + 8;
        if (PRIMARY->sprite != 0) column += 8;
        aligned = (column & 0xFFF0) == (r->x & 0xFFF0);
        break;
    case DIR_RIGHT:
        if (PRIMARY->x < r->x) goto miss;
        goto same_row;
    default: /* DIR_LEFT */
        if (PRIMARY->x > r->x) goto miss;
same_row:
        row = r->y + 0x14;
        aligned = (PRIMARY->y & 0xFFFC) == (row & 0xFFFC);
        break;
    }
    if (aligned) {
        r->type = 0x85;
        return;
    }
miss:
    scroll_record_then_finish(r);
}
