/* Waypoint followers and formation entry, translated from the frozen oracle.
   Remaining callers are C: no ASM entry bridge is needed. Paths remain in the
   original state segment; this region has no platform calls or private state.

   SEGMENT: CGAME
   OWNS: Type41FollowPathType41 Type43FollowPathType43 Type44FollowPathType44
   OWNS: Type45FollowPathType45 Type4AFollowPathType4A Type51FollowType51Path
   OWNS: Type10StartPathFollowerA Type11StartPathFollowerB StartPathFollow
   OWNS: Type12WaypointPathFollower Type66FollowPathType66 Type67FollowPathType67
   OWNS: Type81SweeperEnterSteer Type81SweeperEnterBody Type7FMarchEnterSteer Type7FMarchEnterBody
*/
#include "paths.h"
#include "enemies.h"

void steer_toward_target(Record *r);
word steer_to_saved(Record *r);

/* Type 12h: on exact arrival, advance REC_PATH and steer the next waypoint
   in the same call. There is no terminator check: the final LEADER_END_Y point
   sends the record offscreen, where FinishRecordUpdate removes it. */
void update_path_follower(Record *r)
{
    word *point;

    for (;;) {
        point = (word *)r->path;
        SteerTargetY = point[0] + 0x20;
        SteerTargetX = point[1];
        SteerSpeed = 1;
        if (LevelIndex == 0 || DemoActive == 1) SteerSpeed = 2;
        steer_toward_target(r);
        if (SteerArrived == 0) break;
        r->path = (word)(point + 2);
    }

    r->sprite = r->direction + 0x3B;
    if (DemoActive != 1) {
        if (LevelIndex == 0 || LevelIndex == 5 || LevelIndex == 6) {
            r->sprite = r->direction + 0x115;
            if (MapScrollPos != MAP_LAST_SPAWN_POS) {
                finish_record_update(r);
                return;
            }
            r->sprite = r->direction + 0x105;
            if (LevelIndex == 0 || LevelIndex == 6) {
                finish_record_update(r);
                return;
            }
            /* Level 5 at this exact map row falls through to the EC sprite. */
        }
        if (LevelIndex == 1) r->sprite = r->direction + 0x2A;
        else if (LevelIndex == 2) r->sprite = r->direction + 0xD2;
        else r->sprite = r->direction + 0xEC;
    }
    finish_record_update(r);
}

/* The path starters run type 12h immediately, without scrolling. Types 66h/67h
   also set 20 hit points; the other starters inherit the record's hit points. */
void start_path_follower(Record *r, word path)
{
    r->path = path;
    if (r->type == 0x66 || r->type == 0x67) r->hit_points = 0x14;
    r->type = 0x12;
    update_path_follower(r);
}

/* Type 81h keeps its spawn heading even while steering. It becomes type 93h
   only when already at REC_SAVED on entry, retaining that heading for the sweep. */
void enter_sweeper_slot(Record *r)
{
    word heading = r->direction;
    word arrived;

    r->sprite = 0x16A;
    SteerSpeed = 1;
    arrived = steer_to_saved(r);
    r->direction = heading;
    if (arrived != 0) r->type = 0x93;
    finish_record_update(r);
}

/* Type 7Fh steers into REC_SAVED and becomes type 80h on exact entry arrival.
   The transition does not run the march handler until the next record pass. */
void enter_march_slot(Record *r)
{
    r->sprite = 0x162;
    SteerSpeed = 1;
    if (steer_to_saved(r) != 0) r->type = 0x80;
    finish_record_update(r);
}
