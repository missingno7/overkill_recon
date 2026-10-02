/* Aimed flight and its entry animations. Direct C callers only; no owned data.

   SEGMENT: CGAME
   OWNS: Type7CAimLineFlyerAlt Type7AAimLineFlyer AimLineFlyerAnimTail
   OWNS: Type2BAimedDart AimedFlyerSetSpriteTail Type29EmergeThenDart
   OWNS: Type60FlyAlongAimLine Type3EDropThenAimedDash Type3FFlyAlongAimLine
   OWNS: Type7BDropThenAim Type7BDropThenAimBody
*/
#include "flyers.h"
#include "enemies.h"
#include "hits.h"

void aim_at_player(Record *r);
void step_along_delta(Record *r);

/* Keep the inherited line/error, step before testing signed X, and leave the
   shared step size at 3. Destruction still runs the scroll and finish tail. */
void fly_along_aim_line(Record *r)
{
    ChaseStepPixels = 2;
    step_along_delta(r);
    ChaseStepPixels = 3;
    if ((sword)r->x > PLAYFIELD_MAX_X || (sword)r->x < 0)
        destroy_record(r);
    scroll_record_then_finish(r);
}

void animated_aim_line_flyer(Record *r, word sprite)
{
    r->sprite = sprite;
    fly_along_aim_line(r);
}

/* Already at A4h: fly without re-aiming. Reaching A4h through animation aims
   once and moves immediately; the record keeps type 29h. */
void type29_emerge_then_dart(Record *r)
{
    if (r->sprite != 0xA4) {
        if (FrameCount8 != 7) {
            scroll_record_then_finish(r);
            return;
        }
        r->sprite++;
        if (r->sprite != 0xA4) {
            scroll_record_then_finish(r);
            return;
        }
        aim_at_player(r);
    }
    fly_along_aim_line(r);
}

void type3e_drop_then_dash(Record *r)
{
    r->sprite = 0x0E;
    if ((sword)r->y < 0xA0) {
        scroll_record_then_finish(r);
        return;
    }
    r->type = 0x3F;
    aim_at_player(r);
    fly_along_aim_line(r);
}

/* Unlike 3Eh, the switching frame only aims and scrolls, without flight. */
void type7b_drop_then_aim(Record *r)
{
    r->sprite = 0x15C;
    if ((sword)r->y >= 0x90) {
        r->type = 0x7C;
        aim_at_player(r);
    }
    scroll_record_then_finish(r);
}
