#include "level_timeline.h"
#include "game.h"
#include "LEVEL_TIMELINE_PARAMS_GEN.H"

static const LevelTimeline *current_timeline;

void overkill_level_timeline_bind_current(const LevelTimeline *timeline) { current_timeline = timeline; }
const LevelTimeline *overkill_level_timeline_current(void) { return current_timeline; }

uint16_t overkill_level_timeline_cursor(const LevelTimeline *timeline)
{
    return (word)(GAME_OFFSET(LevelScriptCursors) + 2 * timeline->behavior_profile);
}

void overkill_level_timeline_reset(void)
{
    if (current_timeline) *GAME_PTR(word, overkill_level_timeline_cursor(current_timeline)) = 0;
}

int overkill_level_timeline_select_checkpoint(LevelCheckpoint *selection)
{
    word i = 0;
    const LevelTimelineCheckpoint *checkpoint;
    if (!current_timeline) return 0;
    while (i + 1 < current_timeline->checkpoint_count &&
           MapScrollPos >= current_timeline->checkpoints[i + 1].map_position) i++;
    checkpoint = &current_timeline->checkpoints[i];
    selection->map_position = checkpoint->map_position;
    selection->script_clock = checkpoint->script_clock;
    CheckpointScriptCursor = checkpoint->resume_event;
    return 1;
}

int overkill_level_timeline_restore_checkpoint(void)
{
    if (!current_timeline) return 0;
    *GAME_PTR(word, overkill_level_timeline_cursor(current_timeline)) = CheckpointScriptCursor;
    return 1;
}

static const LevelFormationSpawnParameters *parameters(word index)
{
    if (current_timeline && !current_timeline->live_parameters) return &current_timeline->parameters;
    return index < 6 ? formation_spawn_parameters[index] : 0;
}

uint16_t overkill_formation_tile_hit_points(uint16_t legacy_index)
{
    const LevelFormationSpawnParameters *definition = parameters(legacy_index);
    return definition ? definition->tile_member_hit_points : (word)(legacy_index + 1);
}

uint16_t overkill_formation_other_hit_points(uint16_t legacy_index)
{
    const LevelFormationSpawnParameters *definition = parameters(legacy_index);
    return definition ? definition->other_member_hit_points : 12;
}

uint16_t overkill_timeline_director_cursor(uint16_t legacy_cursor)
{
    /* Type21 never consumes LeaderScriptCursor; retain its proven initial write
       as importer compatibility, separate from the authored member HP policy. */
    return current_timeline ? (word)(current_timeline->behavior_profile + 1) : legacy_cursor;
}
