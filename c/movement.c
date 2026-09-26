/* Movement and steering helpers, translated from the frozen oracle
   (asm-semantic-oracle-v1): MoveInDirectionN, SteerTowardTarget, SteerToSaved,
   SetDeltaToward, StepAlongDelta and AimAtPlayer. Same state, same results; see the
   oracle comments at each routine for the original contracts.

   OWNS: SteerTowardTarget StepBySteerSpeed SetDeltaToward StepAlongDelta
   OWNS: SetChaseXQuadrantBit SetChaseYQuadrantBit AimAtPlayer SteerToSaved
   OWNS: MoveInDirection8 Move8ByDirection MoveInDirection3 MoveInDirection3Cases
   OWNS: MoveInDirection4 MoveInDirection2 Move2ByDirection MoveInDirection1 Move1ByDirection
*/
#include "game.h"

/* BP moves n px along REC_DIRECTION (0 up, clockwise to 7); diagonals move n px on both
   axes, 16-bit wrap. The oracle's table is unchecked: only 0..7 ever reach it (every
   writer stores a DIR_ value or a DirectionFromQuadrant result). MoveInDirection4 is two
   2-px steps in the oracle, the same sum. */
void move_in_direction(Record *r, word n)
{
    switch (r->direction) {
    case DIR_UP:         r->y -= n; break;
    case DIR_UP_RIGHT:   r->y -= n; r->x += n; break;
    case DIR_RIGHT:      r->x += n; break;
    case DIR_DOWN_RIGHT: r->x += n; r->y += n; break;
    case DIR_DOWN:       r->y += n; break;
    case DIR_DOWN_LEFT:  r->y += n; r->x -= n; break;
    case DIR_LEFT:       r->x -= n; break;
    case DIR_UP_LEFT:    r->x -= n; r->y -= n; break;
    }
}

/* Aim REC_DIRECTION at (SteerTargetX, SteerTargetY) and step 1/2/4/8 px by SteerSpeed
   (0..3, caller-set). X is compared unsigned, Y signed. Arrival is exact equality only:
   the arriving step leaves SteerArrived 0; the next call finds the record there and sets
   SteerArrived 1 without moving or touching REC_DIRECTION. */
void steer_toward_target(Record *r)
{
    word bits = 0;
    byte direction;

    if (r->x < SteerTargetX) bits = 1;
    else if (r->x > SteerTargetX) bits = 2;
    if ((sword)r->y < (sword)SteerTargetY) bits |= 4;
    else if ((sword)r->y > (sword)SteerTargetY) bits |= 8;
    AimQuadrantBits = bits;
    direction = DirectionFromQuadrant[bits];
    if (direction == 0xFF) {
        SteerArrived = 1;
        return;
    }
    SteerArrived = 0;
    r->direction = direction;
    move_in_direction(r, 1 << SteerSpeed);
}

/* SteerTowardTarget toward REC_SAVED_X/Y; returns SteerArrived (the bridge turns it into
   the oracle's ZF: NZ = already there at entry, no step). */
word steer_to_saved(Record *r)
{
    SteerTargetX = r->saved_x;
    SteerTargetY = r->saved_y;
    steer_toward_target(r);
    return SteerArrived;
}

/* Self's REC_DELTA = self X/Y - (target X/Y + 4 for a size class 1 target, else + 0Ch);
   self's own size is ignored. The target may be a stale or reused slot (REC_TARGET). */
void set_delta_toward(Record *self, Record *target)
{
    word d = target->size_class == 1 ? 4 : 0x0C;

    self->delta_x = self->x - (target->x + d);
    self->delta_y = self->y - (target->y + d);
}

/* REC_DELTA = the record's position minus the player's (X + 9, Y). */
void aim_at_player(Record *r)
{
    r->delta_x = r->x - (PRIMARY->x + 9);
    r->delta_y = r->y - PRIMARY->y;
}

/* One step against REC_DELTA (= self - target; not consumed, so the heading holds until
   re-aimed). Magnitudes are 16-bit negations (8000h stays 8000h) compared unsigned. The
   major axis always steps; the minor axis steps when REC_STEP_ERROR += minor exceeds the
   major (unsigned, wrapping), which then subtracts the major; equal magnitudes step both.
   The error is inherited from the slot's previous occupant. A zero delta moves up-left.
   ChaseStepPixels 3 moves 3 px, any other value 2. */
void step_along_delta(Record *r)
{
    word dx = r->delta_x, dy = r->delta_y;
    word step_x = 1, step_y = 1;
    byte direction;

    ChaseNegX = 0;
    ChaseNegY = 0;
    if ((sword)dx < 0) { dx = -dx; ChaseNegX = 1; }
    if ((sword)dy < 0) { dy = -dy; ChaseNegY = 1; }
    if (dx > dy) {
        r->step_error += dy;
        if (r->step_error > dx) r->step_error -= dx;
        else step_y = 0;
    } else if (dx < dy) {
        r->step_error += dx;
        if (r->step_error > dy) r->step_error -= dy;
        else step_x = 0;
    }
    ChaseQuadrantBits = 0;
    if (step_x) ChaseQuadrantBits |= ChaseNegX ? 1 : 2;
    if (step_y) ChaseQuadrantBits |= ChaseNegY ? 4 : 8;
    direction = DirectionFromQuadrant[ChaseQuadrantBits];
    /* Never FFh: at least one axis bit is always set. */
    r->direction = direction;
    move_in_direction(r, ChaseStepPixels == 3 ? 3 : 2);
}
