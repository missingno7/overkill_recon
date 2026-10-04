/* Level spawning, translated from the frozen oracle (asm-semantic-oracle-v1): the map row
   entering the playfield (DrawIncomingMapRow minus its drawing), the level map cell
   spawners (SpawnFromMapRow, Level0..5MapCell and the SpawnCell* routines), the level
   script (RunLevelScriptEvents / ProcessLevelScript: formations, group slots, formation
   leaders), the leader bodies of types 13h/15h/1Ch/1Fh/7Dh/7Eh and 21h, and the shared
   enemy spawn (SpawnEnemyHere...). Pool allocation is shared in c/pools.c. Same state,
   same results; see the oracle comments at each routine for the original contracts.

   The level map is the segment held by the CS word LevelMapSegment (a load buffer inside
   the image); C reaches it through a far pointer built from that word each time, so the
   map has one owner. Type21PathCursor is a CS-resident word of the oracle's far segment,
   read and written in place through a far reference. Level scripts, formations and leader
   scripts are DS tables, read in place.

   SEGMENT: CGAME
   OWNS: RunLevelScriptEvents ProcessLevelScript SpawnFromMapRow
   OWNS: Level0MapCell Level0CellCases Level1MapCell Level2MapCell Level3MapCell Level3CellCases
   OWNS: Level4MapCell Level4CellCases Level5MapCell Level5CellCases
   OWNS: ClearMapCell ClearMapCellAlt Clear2x2MapCells InitMapLargeEnemy
   OWNS: SpawnCellCreeper48 SpawnCellSpreadShooter75 SpawnCellAimedDescender72 SpawnCellHatch28
   OWNS: SpawnCellClimbWalker8B SpawnCellClimbWalker8C SpawnCellClimbWalker8E SpawnCellClimbWalker8D
   OWNS: SpawnCellTurretLeft24 SpawnCellTurretRight25 SpawnCellVolleyTurret90 SpawnCellVolleyTurret91
   OWNS: SpawnCellHatch2A SpawnCellPlunger2E SpawnCellFireBurst8F SpawnCellRunnerRight73
   OWNS: SpawnCellRunnerLeft74 SpawnCellWallBouncer38Right SpawnCellWallBouncer38Left
   OWNS: SpawnCellCrawler54UpRight SpawnCellCrawler54UpLeft SpawnCellLurker84Up SpawnCellLurker84Right
   OWNS: SpawnCellLurker84Down SpawnCellLurker84Left SpawnCellWallPatroller19Right SpawnCellShooter30
   OWNS: SpawnCellRowFirer92Right SpawnCellRowFirer92Left SpawnCellLauncher86 SpawnCellBurstFirer88
   OWNS: SpawnCellSlider63 SpawnCellDiver71 SpawnCellPatroller8A SpawnCellCrawler54InwardA
   OWNS: SpawnCellDescender6B SpawnCellDescender6C SpawnCellDescender6D SpawnCellCrawler6A
   OWNS: SpawnCellCrawler54InwardB SpawnCellCrawler5E SpawnCellCrawler6E SpawnCellCruiser6F
   OWNS: SpawnCellPlunger2D SpawnCellPatroller47 SpawnCellCrawler59 SpawnCellCrawler5F SpawnCellRiser5B
   OWNS: SpawnCellDropper5D SpawnCellFireBurst87 SpawnCellDropper55 SpawnCellSideTurret34
   OWNS: SpawnCellBouncer37 SpawnCellPatroller83 SpawnCellFaller4F SpawnCellWallPatroller19Down
   OWNS: SpawnCellBurster35 SpawnCellJitterer69 SpawnCellJitterShooter68 SpawnCellPatroller89
   OWNS: SpawnCellCrawler58Right SpawnCellCrawler57Left
   OWNS: SpawnMapGroupEnemy JoinMapGroup SpawnMapEnemy SpawnMapEnemyKeepCell
   OWNS: SpawnEnemyHereQuiet SpawnEnemyHere InitEnemyRecordHere
   OWNS: Type13FormationLeader Type13FormationLeaderBody Type21LeaderPathBody ResetType21Path
   OWNS: DrawIncomingMapRow DemoStepSpawnPathEnemy51 DemoStepLaunchFrontPod
   OWNS: AllocGroupSlot StartLeaderScript ResetMarchState SpawnCellFuelPickup
*/
#include "game.h"
#include "enemies.h"
#include "hits.h"

#ifdef OVERKILL_HOST
#include "memory.h"
#include "level_def.h"
#include "level_timeline.h"
#include "map_recipes.h"
#endif

/* CS-resident words (outside the state segment). */
#ifndef OVERKILL_HOST
extern word __far LevelMapSegment;     /* MAIN: segment of the level map */
extern word __far Type21PathCursor;    /* far segment: next Type21Path waypoint (DS offset) */
#endif

/* Byte `off` of the level map (16-bit offset arithmetic, as ES:SI in the oracle). */
#ifdef OVERKILL_HOST
#define MAP_AT(off) ((byte *)overkill_segment_address(LevelMapSegment, (word)(off)))
#else
#define MAP_AT(off) (((__segment)LevelMapSegment) :> ((byte __based(void) *)(off)))
#endif

void steer_toward_target(Record *r);           /* c/movement.c */
Record *find_free_record_pool_a(void);          /* c/pools.c */

/* Level0..5MapCell bridge entry: AH = level, AL = cell byte. */
#pragma aux level_map_cell parm [si] [di] [ax] value [ax] modify exact [ax]

/* ---- shared pool helpers and enemy spawning ------------------------------------------- */

/* Shared body of SpawnEnemyHere/Quiet: a KIND_ENEMY type 14h with 4 hit points facing
   down at here's position, REC_SAVED = that position. Unchecked: NO_RECORD writes through
   FFFFh (DemoStepLaunchFrontPod). here may be r itself (a free entry record): the reads
   come after the writes that precede them in the oracle, so the order below is kept. */
void init_enemy_record_here(Record *r, Record *here)
{
    word v;

    GAME_RECORD_FIELD(r, slot_index) = 0xFFFF;
    GAME_RECORD_FIELD(r, status) = 1;
    GAME_RECORD_FIELD(r, draw_pass) = 1;
    v = here->y;
    GAME_RECORD_FIELD(r, y) = v;
    GAME_RECORD_FIELD(r, saved_y) = v;
    v = here->x;
    GAME_RECORD_FIELD(r, x) = v;
    GAME_RECORD_FIELD(r, saved_x) = v;
    GAME_RECORD_FIELD(r, direction) = DIR_DOWN;
    GAME_RECORD_FIELD(r, size_class) = 1;
    GAME_RECORD_FIELD(r, kind) = KIND_ENEMY;
    GAME_RECORD_FIELD(r, type) = 0x14;
    GAME_RECORD_FIELD(r, hit_points) = 4;
    GAME_RECORD_FIELD(r, flash_timer) = 0;
}

Record *spawn_enemy_here_quiet(Record *here)
{
    Record *r = find_free_record_pool_a();

    if (r != NO_RECORD) init_enemy_record_here(r, here);
    return r;
}

/* As SpawnEnemyHereQuiet, with sfx 0Bh when a record was found. */
Record *spawn_enemy_here(Record *here)
{
    Record *r = find_free_record_pool_a();

    if (r == NO_RECORD) return r;
    if (SfxEnabled != 0) SfxRequest = 0x0B;
    init_enemy_record_here(r, here);
    return r;
}

/* ---- group slots ---------------------------------------------------------------------- */

/* With a GroupDropKind: GroupSlotPtr/GroupSlotIndex = the first GroupTable entry with no
   live members; otherwise GroupSlotPtr = FFFFh. A zero drop leaves the index stale;
   scanning all 16 occupied entries leaves the index at 16. */
void alloc_group_slot(void)
{
    byte *entry;
    word n;

    if (GroupDropKind != 0) {
        GroupSlotIndex = 0;
        entry = GroupTable;
        for (n = 16; n != 0; n--) {
            if (entry[GROUP_LIVE] == 0) {
                GroupSlotPtr = GAME_OFFSET(entry);
                return;
            }
            entry += 2;
            GroupSlotIndex++;
        }
    }
    GroupSlotPtr = 0xFFFF;
}

/* Counts r in the group at GroupSlotPtr (which takes GroupDropKind as its drop) and stores
   GroupSlotIndex in REC_SLOT_INDEX, or FFFFh without a group. */
Record *join_map_group(Record *r)
{
    word slot = 0xFFFF;
    byte *entry;

    if (GroupSlotPtr != 0xFFFF) {
        entry = GAME_PTR(byte, GroupSlotPtr);
        entry[GROUP_LIVE]++;
        entry[GROUP_DROP_KIND] = (byte)GroupDropKind;
        slot = GroupSlotIndex;
    }
    r->slot_index = slot;
    return r;
}

/* A grouped map cell: GroupDropKind from the cell's map offset (& 3Fh), then a group slot
   (allocated for every cell of the range, even those that spawn nothing). */
void start_map_cell_group(word off)
{
    GroupDropKind = GroupDropKinds[off & 0x3F];
    alloc_group_slot();
}

/* ---- map cell spawns ------------------------------------------------------------------ */

void clear_map_cell(word off)
{
    *MAP_AT(off) = 1;
}

/* The 2x2 cells at off (13 cells per row) become cell 1. */
void clear_2x2_map_cells(word off)
{
    *MAP_AT(off) = 1;
    *MAP_AT(off + 1) = 1;
    *MAP_AT(off + MAP_ROW_BYTES) = 1;
    *MAP_AT(off + MAP_ROW_BYTES + 1) = 1;
}

/* A pool A enemy at (MapCellX, 10h) in draw pass 0; REC_SAVED = here's position (the
   player's: here is the record DrawIncomingMapRow was entered with). The cell stays. */
Record *spawn_map_enemy_keep_cell(Record *here)
{
    Record *r = spawn_enemy_here_quiet(here);

    if (r == NO_RECORD) return r;
    r->x = MapCellX;
    r->y = 0x10;
    r->draw_pass = 0;
    return r;
}

/* The cell becomes cell 1 (also when pool A is full), then SpawnMapEnemyKeepCell. */
Record *spawn_map_enemy(Record *here, word off)
{
    clear_map_cell(off);
    return spawn_map_enemy_keep_cell(here);
}

/* SpawnMapEnemy joining the group the cell dispatcher just allocated. */
Record *spawn_map_group_enemy(Record *here, word off)
{
    Record *r = spawn_map_enemy(here, off);

    if (r == NO_RECORD) return r;
    return join_map_group(r);
}

#ifdef OVERKILL_HOST
/* The retained-cell hatch omits the last slot write. Skip it directly so stale
   group fields and aliases keep the original read/write order. */
void init_map_large_enemy_fields(Record *r, word reset_slot)
{
    r->kind = KIND_ENEMY;
    r->x = MapCellX;
    r->status = 1;
    r->draw_pass = 0;
    r->y = 0;
    r->size_class = 2;
    r->flash_timer = 0;
    r->hit_points = 0x0A;
    if (reset_slot) r->slot_index = 0xFFFF;
}
#endif

/* A large (size class 2) KIND_ENEMY with 10 hit points at (MapCellX, 0), no group. */
void init_map_large_enemy(Record *r)
{
#ifdef OVERKILL_HOST
    init_map_large_enemy_fields(r, 1);
#else
    r->kind = KIND_ENEMY;
    r->x = MapCellX;
    r->status = 1;
    r->draw_pass = 0;
    r->y = 0;
    r->size_class = 2;
    r->flash_timer = 0;
    r->hit_points = 0x0A;
    r->slot_index = 0xFFFF;
#endif
}

/* Type, sprite and direction of a new map enemy, if there is one. */
void set_type_sprite_dir(Record *r, word type, word sprite, word direction)
{
    if (r == NO_RECORD) return;
    r->type = type;
    r->sprite = sprite;
    r->direction = direction;
}

void set_type(Record *r, word type)
{
    if (r != NO_RECORD) r->type = type;
}

void set_type_dir(Record *r, word type, word direction)
{
    if (r == NO_RECORD) return;
    r->type = type;
    r->direction = direction;
}

/* "Facing the centre": at or left of PLAYFIELD_CENTER_X (unsigned) the record takes the
   second sprite and direction. */
void face_centre(Record *r, word type, word sprite, word direction, word left_sprite, word left_direction)
{
    if (r == NO_RECORD) return;
    r->type = type;
    r->sprite = sprite;
    r->direction = direction;
    if (r->x <= PLAYFIELD_CENTER_X) {
        r->sprite = left_sprite;
        r->direction = left_direction;
    }
}

/* Level 5 D9h: large type 48h facing down, joins the group. */
void spawn_cell_creeper48(word off)
{
    Record *r;

    clear_2x2_map_cells(off);
    r = find_free_record_pool_a();
    if (r == NO_RECORD) return;
    init_map_large_enemy(r);
    r->type = 0x48;
    r->direction = DIR_DOWN;
    join_map_group(r);
}

/* Level 0 F8h: large type 75h, joins the group. */
void spawn_cell_spread_shooter75(word off)
{
    Record *r;

    clear_2x2_map_cells(off);
    r = find_free_record_pool_a();
    if (r == NO_RECORD) return;
    init_map_large_enemy(r);
    set_type_sprite_dir(r, 0x75, 0x24, DIR_DOWN);
    join_map_group(r);
}

/* Level 0 F7h: large type 72h facing down. */
void spawn_cell_aimed_descender72(word off)
{
    Record *r;

    clear_2x2_map_cells(off);
    r = find_free_record_pool_a();
    if (r == NO_RECORD) return;
    init_map_large_enemy(r);
    set_type_dir(r, 0x72, DIR_DOWN);
}

/* Level 1/4 C9h: the hatch cells 26h..29h, large type 28h (cells written even when pool A
   is full). */
void spawn_cell_hatch28(word off)
{
    Record *r;

    *MAP_AT(off + MAP_ROW_BYTES) = 0x26;
    *MAP_AT(off + MAP_ROW_BYTES + 1) = 0x27;
    *MAP_AT(off) = 0x28;
    *MAP_AT(off + 1) = 0x29;
    r = find_free_record_pool_a();
    if (r == NO_RECORD) return;
    init_map_large_enemy(r);
    set_type_sprite_dir(r, 0x28, 0x1C, DIR_UP);
}

/* Level 2/5 30h: large type 2Ah; the cell stays and REC_SLOT_INDEX keeps the slot's
   previous value (unlike InitMapLargeEnemy). */
void spawn_cell_hatch2a(void)
{
    Record *r = find_free_record_pool_a();

    if (r == NO_RECORD) return;
#ifdef OVERKILL_HOST
    init_map_large_enemy_fields(r, 0);
#else
    r->kind = KIND_ENEMY;
    r->x = MapCellX;
    r->status = 1;
    r->draw_pass = 0;
    r->y = 0;
    r->size_class = 2;
    r->flash_timer = 0;
    r->hit_points = 0x0A;
#endif
    set_type_sprite_dir(r, 0x2A, 0x1C, DIR_UP);
}

/* Level 2 5Ah: type 2Eh, 6 px higher. */
void spawn_cell_plunger2e(Record *here, word off)
{
    Record *r = spawn_map_enemy(here, off);

    if (r == NO_RECORD) return;
    r->type = 0x2E;
    r->y -= 6;
}

/* Level 0 BCh (left half only): type 73h, 12 px left, facing right. */
void spawn_cell_runner_right73(Record *here, word off)
{
    Record *r = spawn_map_enemy(here, off);

    if (r == NO_RECORD) return;
    r->x -= 0x0C;
    r->saved_x = r->x;
    set_type_sprite_dir(r, 0x73, 0x14C, DIR_RIGHT);
}

/* Level 0 BBh (right half only): type 74h, 12 px right, facing left. */
void spawn_cell_runner_left74(Record *here, word off)
{
    Record *r = spawn_map_enemy(here, off);

    if (r == NO_RECORD) return;
    r->x += 0x0C;
    r->saved_x = r->x;
    set_type_sprite_dir(r, 0x74, 0x14F, DIR_LEFT);
}

/* Level 0 ECh: type 6Fh, joins the group; 16 px left heading down-right, or (from the
   centre column on) 16 px right heading down-left. */
void spawn_cell_cruiser6f(Record *here, word off)
{
    Record *r = spawn_map_group_enemy(here, off);

    if (r == NO_RECORD) return;
    set_type_sprite_dir(r, 0x6F, 0x136, DIR_DOWN_RIGHT);
    r->x -= 0x10;
    if (r->x >= PLAYFIELD_CENTER_X) {
        r->direction = DIR_DOWN_LEFT;
        r->x += 0x20;
    }
}

/* Level 4 D2h / level 5 DCh (up-right) and D3h / DDh (up-left): type 54h; the sprite
   depends on the level. */
void spawn_cell_crawler54_up(Record *here, word off, word direction, word sprite)
{
    Record *r = spawn_map_enemy(here, off);

    if (r == NO_RECORD) return;
    set_type_sprite_dir(r, 0x54, sprite, direction);
    if (LevelIndex != 4) r->sprite = sprite + 8;
}

/* Level 0 E3h, level 4 DDh, level 5 EBh: type 68h; on level 5 grouped when the next
   random word has its low nibble 0Fh. */
void spawn_cell_jitter_shooter68(Record *here, word off)
{
    Record *r;

    if (LevelIndex == 5 && (next_random_word() & 0x0F) == 0x0F)
        r = spawn_map_group_enemy(here, off);
    else
        r = spawn_map_enemy(here, off);
    set_type(r, 0x68);
}

/* Level 3 D6h, level 4 D4h: type 5Fh facing the centre (no sprite). */
void spawn_cell_crawler5f(Record *here, word off)
{
    Record *r = spawn_map_enemy(here, off);

    if (r == NO_RECORD) return;
    r->direction = DIR_LEFT;
    r->type = 0x5F;
    if (r->x <= PLAYFIELD_CENTER_X) r->direction = DIR_RIGHT;
}
/* ---- per-level map cell handlers ------------------------------------------------------ */

word spawn_cell_fuel_pickup(Record *here, word off)
{
    Record *pickup = spawn_map_enemy(here, off);

    if (pickup == NO_RECORD) return off;
    DropKind = 4;
    return init_pickup_record(pickup);
}

/* Level 0: BCh left of / at the centre column, BBh right of it; E1h..F9h grouped. The
   range check also admits FAh and FBh, whose oracle table slots are code bytes (those
   map bytes never occur): here they only allocate the group slot. Returns the map offset
   to continue from (SpawnCellFuelPickup changes it). */
word level0_map_cell(Record *here, word off, byte cell)
{
    Record *r;

    if (MapCellX > PLAYFIELD_CENTER_X) {
        if (cell == 0xBB) { spawn_cell_runner_left74(here, off); return off; }
    } else if (cell == 0xBC) {
        spawn_cell_runner_right73(here, off);
        return off;
    }
    if ((byte)(cell - 0xE1) > 0x1A) return off;
    start_map_cell_group(off);
    switch (cell) {
    case 0xE1: case 0xE2:   /* BurstFirer88 */
        face_centre(spawn_map_enemy(here, off), 0x88, 0xFD, DIR_LEFT, 0xFA, DIR_RIGHT); break;
    case 0xE3: spawn_cell_jitter_shooter68(here, off); break;
    case 0xE4: set_type(spawn_map_enemy(here, off), 0x69); break;                      /* Jitterer69 */
    case 0xE5: case 0xE6:   /* Crawler6A */
        face_centre(spawn_map_enemy(here, off), 0x6A, 0x11E, DIR_DOWN_LEFT, 0x11D, DIR_DOWN_RIGHT); break;
    case 0xE7: set_type(spawn_map_enemy(here, off), 0x6B); break;                      /* Descender6B */
    case 0xE8:              /* Descender6C: grouped, keeps its direction */
        r = spawn_map_group_enemy(here, off);
        if (r != NO_RECORD) { r->type = 0x6C; r->sprite = 0x123; }
        break;
    case 0xE9: set_type(spawn_map_enemy(here, off), 0x6D); break;                      /* Descender6D */
    case 0xEA: set_type_dir(spawn_map_group_enemy(here, off), 0x6E, DIR_DOWN); break;  /* Crawler6E */
    case 0xEB: set_type_dir(spawn_map_group_enemy(here, off), 0x71, DIR_DOWN); break;  /* Diver71 */
    case 0xEC: spawn_cell_cruiser6f(here, off); break;
    case 0xED: set_type(spawn_map_group_enemy(here, off), 0x8D); break;                /* ClimbWalker8D */
    case 0xEE: set_type(spawn_map_group_enemy(here, off), 0x8E); break;                /* ClimbWalker8E */
    case 0xEF: set_type_dir(spawn_map_group_enemy(here, off), 0x8A, DIR_DOWN); break;  /* Patroller8A */
    case 0xF0: case 0xF1:   /* Crawler54InwardB */
        face_centre(spawn_map_enemy(here, off), 0x54, 0x143, DIR_UP_LEFT, 0x144, DIR_UP_RIGHT); break;
    case 0xF2: case 0xF3: set_type(spawn_map_enemy(here, off), 0x34); break;           /* SideTurret34 */
    case 0xF4:              /* Crawler59: the sprite stays for both sides */
        face_centre(spawn_map_enemy(here, off), 0x59, 0xE3, DIR_UP_LEFT, 0xE3, DIR_UP_RIGHT); break;
    case 0xF5: clear_map_cell(off); break;                                             /* ClearMapCellAlt */
    case 0xF6: set_type(spawn_map_enemy(here, off), 0x4F); break;                      /* Faller4F */
    case 0xF7: spawn_cell_aimed_descender72(off); break;
    case 0xF8: spawn_cell_spread_shooter75(off); break;
    case 0xF9: return spawn_cell_fuel_pickup(here, off);
    }
    return off;
}

/* Level 1: single cells, no groups. */
void level1_map_cell(Record *here, word off, byte cell)
{
    switch (cell) {
    case 0x04: set_type(spawn_map_enemy(here, off), 0x8B); break;                      /* ClimbWalker8B */
    case 0x07: set_type(spawn_map_enemy(here, off), 0x8C); break;                      /* ClimbWalker8C */
    case 0x6C: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x24, 0x8F, DIR_LEFT); break;
    case 0x6D: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x25, 0x90, DIR_RIGHT); break;
    case 0xAC: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x90, 0x89, DIR_LEFT); break;
    case 0xB1: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x91, 0x8C, DIR_RIGHT); break;
    case 0xC9: spawn_cell_hatch28(off); break;
    }
}

/* Level 2: hatch 2Ah, fire burst 8Fh (facing the centre), plunger 2Eh. */
void level2_map_cell(Record *here, word off, byte cell)
{
    switch (cell) {
    case 0x30: spawn_cell_hatch2a(); break;
    case 0xC4: face_centre(spawn_map_enemy(here, off), 0x8F, 0xBF, DIR_LEFT, 0xC2, DIR_RIGHT); break;
    case 0x5A: spawn_cell_plunger2e(here, off); break;
    }
}

/* Level 3: CEh..E9h grouped (DFh spawns nothing). The range check also admits EAh and
   EBh, past the oracle table (never in the map): here they only allocate the slot. */
void level3_map_cell(Record *here, word off, byte cell)
{
    Record *r;

    if ((byte)(cell - 0xCE) > 0x1D) return;
    start_map_cell_group(off);
    switch (cell) {
    case 0xCE: case 0xCF:   /* Launcher86 */
        face_centre(spawn_map_enemy(here, off), 0x86, 0xC8, DIR_LEFT, 0xDA, DIR_RIGHT); break;
    case 0xD0: case 0xD1:   /* Crawler54InwardA */
        face_centre(spawn_map_enemy(here, off), 0x54, 0xF5, DIR_UP_LEFT, 0xF4, DIR_UP_RIGHT); break;
    case 0xD2: case 0xD3:   /* FireBurst87 */
        face_centre(spawn_map_enemy(here, off), 0x87, 0xE0, DIR_LEFT, 0xDD, DIR_RIGHT); break;
    case 0xD4:              /* Dropper55: keeps its direction */
        r = spawn_map_enemy(here, off);
        if (r != NO_RECORD) { r->type = 0x55; r->sprite = 0x77; }
        break;
    case 0xD5: set_type(spawn_map_group_enemy(here, off), 0x83); break;                /* Patroller83 */
    case 0xD6: spawn_cell_crawler5f(here, off); break;
    case 0xD7: set_type_sprite_dir(spawn_map_enemy(here, off), 0x63, 0xE7, DIR_RIGHT); break;  /* Slider63 */
    case 0xD8: face_centre(spawn_map_enemy(here, off), 0x59, 0xE3, DIR_UP_LEFT, 0xE3, DIR_UP_RIGHT); break;
    case 0xD9: set_type_sprite_dir(spawn_map_enemy(here, off), 0x58, 0x99, DIR_RIGHT); break;  /* Crawler58Right */
    case 0xDA: set_type_sprite_dir(spawn_map_enemy(here, off), 0x57, 0x9B, DIR_LEFT); break;   /* Crawler57Left */
    case 0xDB: set_type(spawn_map_group_enemy(here, off), 0x19); break;                /* WallPatroller19Down */
    case 0xDC: set_type(spawn_map_group_enemy(here, off), 0x89); break;                /* Patroller89 */
    case 0xDD: set_type(spawn_map_enemy(here, off), 0x8C); break;                      /* ClimbWalker8C */
    case 0xDE: set_type(spawn_map_enemy(here, off), 0x8B); break;                      /* ClimbWalker8B */
    case 0xE0: set_type(spawn_map_enemy(here, off), 0x4F); break;                      /* Faller4F */
    case 0xE1: set_type(spawn_map_group_enemy(here, off), 0x37); break;                /* Bouncer37 */
    case 0xE2: set_type_dir(spawn_map_group_enemy(here, off), 0x2D, DIR_UP); break;    /* Plunger2D */
    case 0xE3: set_type_sprite_dir(spawn_map_group_enemy(here, off), 0x5E, 0x27, DIR_DOWN); break;  /* Crawler5E */
    case 0xE4: set_type_sprite_dir(spawn_map_group_enemy(here, off), 0x5D, 0x77, DIR_DOWN); break;  /* Dropper5D */
    case 0xE5: case 0xE6: set_type(spawn_map_enemy(here, off), 0x34); break;           /* SideTurret34 */
    case 0xE7: set_type_sprite_dir(spawn_map_enemy(here, off), 0x5B, 0x74, DIR_UP); break;     /* Riser5B */
    case 0xE8: set_type_dir(spawn_map_group_enemy(here, off), 0x47, DIR_LEFT); break;  /* Patroller47 */
    case 0xE9: set_type(spawn_map_group_enemy(here, off), 0x35); break;                /* Burster35 */
    }
}


/* Level 4: turrets and the hatch, then CEh..E0h grouped. The range check also admits E1h
   and E2h, past the oracle table (never in the map): here they only allocate the slot. */
void level4_map_cell(Record *here, word off, byte cell)
{
    switch (cell) {
    case 0xAC: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x90, 0x89, DIR_LEFT); return;
    case 0xB1: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x91, 0x8C, DIR_RIGHT); return;
    case 0xC9: spawn_cell_hatch28(off); return;
    }
    if ((byte)(cell - 0xCE) > 0x14) return;
    start_map_cell_group(off);
    switch (cell) {
    case 0xCE: set_type(spawn_map_enemy(here, off), 0x8C); break;                      /* ClimbWalker8C */
    case 0xCF: set_type(spawn_map_enemy(here, off), 0x8B); break;                      /* ClimbWalker8B */
    case 0xD0: set_type_sprite_dir(spawn_map_enemy(here, off), 0x58, 0x99, DIR_RIGHT); break;  /* Crawler58Right */
    case 0xD1: set_type_sprite_dir(spawn_map_enemy(here, off), 0x57, 0x9B, DIR_LEFT); break;   /* Crawler57Left */
    case 0xD2: spawn_cell_crawler54_up(here, off, DIR_UP_RIGHT, 0x172); break;
    case 0xD3: spawn_cell_crawler54_up(here, off, DIR_UP_LEFT, 0x173); break;
    case 0xD4: spawn_cell_crawler5f(here, off); break;
    case 0xD5: set_type_dir(spawn_map_group_enemy(here, off), 0x8A, DIR_DOWN); break;  /* Patroller8A */
    case 0xD6: set_type(spawn_map_enemy(here, off), 0x4F); break;                      /* Faller4F */
    case 0xD7: face_centre(spawn_map_enemy(here, off), 0x59, 0xE3, DIR_UP_LEFT, 0xE3, DIR_UP_RIGHT); break;
    case 0xD8: set_type(spawn_map_group_enemy(here, off), 0x83); break;                /* Patroller83 */
    case 0xD9: set_type_sprite_dir(spawn_map_group_enemy(here, off), 0x5D, 0x77, DIR_DOWN); break;  /* Dropper5D */
    case 0xDA: set_type_dir(spawn_map_enemy(here, off), 0x38, DIR_DOWN_RIGHT); break;  /* WallBouncer38Right */
    case 0xDB: set_type_dir(spawn_map_enemy(here, off), 0x38, DIR_DOWN_LEFT); break;   /* WallBouncer38Left */
    case 0xDC: set_type(spawn_map_enemy(here, off), 0x34); break;                      /* SideTurret34 */
    case 0xDD: spawn_cell_jitter_shooter68(here, off); break;
    case 0xDE: set_type(spawn_map_enemy(here, off), 0x69); break;                      /* Jitterer69 */
    case 0xDF: set_type(spawn_map_group_enemy(here, off), 0x35); break;                /* Burster35 */
    case 0xE0: set_type_sprite_dir(spawn_map_group_enemy(here, off), 0x5E, 0x27, DIR_DOWN); break;  /* Crawler5E */
    }
}

/* Level 5: hatch, lurkers, climb walkers and turrets, then D7h..EFh grouped (D7h and D8h
   never get there; E1h/E2h only clear the cell). The range check also admits F0h and
   F1h, past the oracle table (never in the map): here they only allocate the slot. */
void level5_map_cell(Record *here, word off, byte cell)
{
    switch (cell) {
    case 0x30: spawn_cell_hatch2a(); return;
    case 0xBA: set_type_sprite_dir(spawn_map_enemy(here, off), 0x84, 0x156, DIR_UP); return;
    case 0xBB: set_type_sprite_dir(spawn_map_enemy(here, off), 0x84, 0x157, DIR_RIGHT); return;
    case 0xBC: set_type_sprite_dir(spawn_map_enemy(here, off), 0x84, 0x158, DIR_DOWN); return;
    case 0xB6: set_type_sprite_dir(spawn_map_enemy(here, off), 0x84, 0x159, DIR_LEFT); return;
    case 0xD8: set_type(spawn_map_enemy(here, off), 0x8B); return;                     /* ClimbWalker8B */
    case 0xD7: set_type(spawn_map_enemy(here, off), 0x8C); return;                     /* ClimbWalker8C */
    case 0xD3: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x90, 0x89, DIR_LEFT); return;
    case 0xD2: set_type_sprite_dir(spawn_map_enemy_keep_cell(here), 0x91, 0x8C, DIR_RIGHT); return;
    }
    if ((byte)(cell - 0xD7) > 0x1A) return;
    start_map_cell_group(off);
    switch (cell) {
    case 0xD9: spawn_cell_creeper48(off); break;
    case 0xDA: set_type_sprite_dir(spawn_map_enemy(here, off), 0x92, 0x15A, DIR_RIGHT); break;  /* RowFirer92Right */
    case 0xDB: set_type_sprite_dir(spawn_map_enemy(here, off), 0x92, 0x15B, DIR_LEFT); break;   /* RowFirer92Left */
    case 0xDC: spawn_cell_crawler54_up(here, off, DIR_UP_RIGHT, 0x172); break;
    case 0xDD: spawn_cell_crawler54_up(here, off, DIR_UP_LEFT, 0x173); break;
    case 0xDE: case 0xDF:   /* FireBurst87 */
        face_centre(spawn_map_enemy(here, off), 0x87, 0xE0, DIR_LEFT, 0xDD, DIR_RIGHT); break;
    case 0xE0: set_type_sprite_dir(spawn_map_group_enemy(here, off), 0x5D, 0x77, DIR_DOWN); break;  /* Dropper5D */
    case 0xE1: case 0xE2: clear_map_cell(off); break;
    case 0xE3: set_type_sprite_dir(spawn_map_enemy(here, off), 0x63, 0xE7, DIR_RIGHT); break;  /* Slider63 */
    case 0xE4: set_type_sprite_dir(spawn_map_enemy(here, off), 0x30, 0x46, DIR_DOWN); break;   /* Shooter30 */
    case 0xE5: set_type_sprite_dir(spawn_map_enemy(here, off), 0x58, 0x99, DIR_RIGHT); break;  /* Crawler58Right */
    case 0xE6: set_type_sprite_dir(spawn_map_enemy(here, off), 0x57, 0x9B, DIR_LEFT); break;   /* Crawler57Left */
    case 0xE7: set_type_dir(spawn_map_enemy(here, off), 0x19, DIR_RIGHT); break;       /* WallPatroller19Right */
    case 0xE8: set_type(spawn_map_group_enemy(here, off), 0x89); break;                /* Patroller89 */
    case 0xE9: set_type_dir(spawn_map_group_enemy(here, off), 0x47, DIR_LEFT); break;  /* Patroller47 */
    case 0xEA: set_type(spawn_map_group_enemy(here, off), 0x35); break;                /* Burster35 */
    case 0xEB: spawn_cell_jitter_shooter68(here, off); break;
    case 0xEC: set_type(spawn_map_enemy(here, off), 0x4F); break;                      /* Faller4F */
    case 0xED: set_type(spawn_map_group_enemy(here, off), 0x37); break;                /* Bouncer37 */
    case 0xEE: set_type_dir(spawn_map_group_enemy(here, off), 0x2D, DIR_UP); break;    /* Plunger2D */
    case 0xEF: set_type_sprite_dir(spawn_map_group_enemy(here, off), 0x5E, 0x27, DIR_DOWN); break;  /* Crawler5E */
    }
}

/* The handler of level AH for cell AL at map offset off (LevelMapCellHandlers); returns
   the offset to continue from. LevelIndex is always 0..5 (the oracle's table is
   unchecked). */
word level_map_cell(Record *here, word off, word level_cell)
{
    byte cell = (byte)level_cell;
#ifdef OVERKILL_HOST
    word continuation;

    if (overkill_spawn_map_recipe(here, off, level_cell, &continuation)) return continuation;
#endif

    switch (level_cell >> 8) {
    case 0: return level0_map_cell(here, off, cell);
    case 1: level1_map_cell(here, off, cell); break;
    case 2: level2_map_cell(here, off, cell); break;
    case 3: level3_map_cell(here, off, cell); break;
    case 4: level4_map_cell(here, off, cell); break;
    case 5: level5_map_cell(here, off, cell); break;
    }
    return off;
}

/* Each of the 13 cells of the map row at MapRowCursor through the level's handler, with
   MapCellX = the cell's pixel X. A level 0 fuel pickup leaves the cursor at DropKind +
   46h (SpawnCellFuelPickup's stale SI): the rest of the row is read from there. */
void spawn_from_map_row(Record *here)
{
    word off = MapRowCursor;

    MapRowCellsLeft = MAP_ROW_BYTES;
    MapCellX = 0;
    do {
        off = level_map_cell(here, off, LevelIndex << 8 | *MAP_AT(off));
        MapCellX += 0x10;
        off++;
    } while (--MapRowCellsLeft != 0);
}

/* ---- level script and formation leaders ------------------------------------------------ */

void reset_march_state(void)
{
    MarchEdgeHit = 0;
    MarchStepNow = 0;
    MarchDelay = 1;
    MarchStepX = 2;
    MarchWord98AC = 0xFFFF;
    MarchDropNow = 0;
    MarchFireDelay = 1;
    MarchFireNow = 0;
    Type93KilledLatch = 0;
    Type93KilledPulse = 0;
}

void reset_type21_path(void)
{
    Type21PathCursor = GAME_OFFSET(Type21Path);
}

/* A new formation leader with its leader script: resets the encounter and sway state; the
   leader gets 20 hit points. */
void start_leader_script(Record *leader, word script)
{
    LeaderScriptCursor = script;
    FormationSlotCursor = GAME_OFFSET(FormationSlots);
    leader->hit_points = 0x14;
    EncounterLiveCount = 1;
    EncounterEndDelay = 0x64;
    SwayDirX = 1;
    SwayPhase = 1;
    SwayDropY = 0;
    SwayReversals = 0;
    EncounterTicks = 0;
    reset_march_state();
    reset_type21_path();
}

/* A formation member's column snap: size class 1 members outside draw pass 1 start on the
   16 px grid, moved sideways (wrapping within the 13 columns, toward the centre from the
   start side) to the first column whose map cell has attribute 0 in the row at their Y.
   A row without a clear cell never ends the search (the oracle hangs; the maps never have
   one). */
void snap_to_clear_column(Record *r)
{
    word y;
    word row;

    r->y &= 0xFFF0;
    r->x &= 0xFFF0;
    SpawnScanStartX = r->x;
    SpawnScanColumn = r->x >> 4;
    y = r->y;
    row = MapScrollPos + MAP_ROW_BYTES;
    if ((sword)y > 0) {
        while (y != 0) { row -= MAP_ROW_BYTES; y -= 0x10; }
    } else {
        while (y != 0) { row += MAP_ROW_BYTES; y += 0x10; }
    }
    SpawnScanRowPtr = row;
    while (ByteAttributeTable[*MAP_AT(SpawnScanRowPtr + SpawnScanColumn)] != 0) {
        if (SpawnScanStartX < PLAYFIELD_CENTER_X) {
            if (++SpawnScanColumn >= MAP_ROW_BYTES) SpawnScanColumn = 0;
        } else {
            if (--SpawnScanColumn == 0xFFFF) SpawnScanColumn = MAP_ROW_BYTES - 1;
        }
    }
    r->x = SpawnScanColumn << 4;
}

/* As each map row enters (DrawIncomingMapRow): every consecutive event of the level
   script whose trigger equals LevelScriptClock (equality only) spawns its formation. The
   cursor advances before spawning, so a full pool A loses the rest of the formation. */
void run_level_script_events(void)
{
    word cursor_offset, event_offset, formation_offset, member_offset;
    word count, slot;
    Record *r;
#ifdef OVERKILL_HOST
    const LevelTimeline *timeline;
    const LevelTimelineEvent *event;
    word member_index;
#endif

    for (;;) {
#ifdef OVERKILL_HOST
        timeline = overkill_level_timeline_current();
        event = 0;
        member_index = 0;
        event_offset = 0;
        member_offset = 0;
        if (timeline) {
            word ordinal;
            cursor_offset = overkill_level_timeline_cursor(timeline);
            ordinal = *GAME_PTR(word, cursor_offset);
            if (ordinal >= timeline->event_count) {
                EventTrigger = 0xFFFF;
                return;
            }
            event = &timeline->events[ordinal];
            EventTrigger = event->clock;
        } else {
            LevelDef definition;
            overkill_level_def(LevelIndex, &definition);
            cursor_offset = *GAME_PTR(word, definition.timeline_cursor);
#endif
#ifndef OVERKILL_HOST
        cursor_offset = *GAME_PTR(word, (word)(GAME_OFFSET(LevelScriptCursorPtrs) +
                                                (word)(LevelIndex * 2)));
#endif
        event_offset = *GAME_PTR(word, cursor_offset);
        EventTrigger = *GAME_PTR(word, event_offset);
        event_offset = (word)(event_offset + 2);
#ifdef OVERKILL_HOST
        }
#endif
        if (EventTrigger == 0xFFFF || EventTrigger != LevelScriptClock) return;
#ifdef OVERKILL_HOST
        if (event) {
            EventMarkerFlag = 1;
            if (!event->marker) EventMarkerFlag = 0;
            EventX = event->x;
            EventY = event->y;
            GroupDropKind = event->drop;
            /* Consume the ordinal before header writes or allocation, as with
               the original byte cursor. An exhausted pool still loses the event. */
            (*GAME_PTR(word, cursor_offset))++;
            FormationSizeClass = event->formation->size;
            FormationDrawPass = event->formation->layer;
            FormationType = event->formation->behavior;
            count = event->formation->count;
        } else {
#endif
        EventMarkerFlag = 1;
        formation_offset = *GAME_PTR(word, event_offset);
        event_offset = (word)(event_offset + 2);
        if (formation_offset == 0xFFFF) {
            EventMarkerFlag = 0;
            formation_offset = *GAME_PTR(word, event_offset);
            event_offset = (word)(event_offset + 2);
        }
        EventX = *GAME_PTR(word, event_offset);
        event_offset = (word)(event_offset + 2);
        EventY = *GAME_PTR(word, event_offset);
        event_offset = (word)(event_offset + 2);
        GroupDropKind = GroupDropKinds[EventTrigger & 0x3F];
        *GAME_PTR(word, cursor_offset) = event_offset;
        FormationSizeClass = *GAME_PTR(word, formation_offset);
        FormationDrawPass = *GAME_PTR(word, (word)(formation_offset + 2));
        FormationType = *GAME_PTR(word, (word)(formation_offset + 4));
        count = *GAME_PTR(word, (word)(formation_offset + 6));
        member_offset = (word)(formation_offset + 8);
#ifdef OVERKILL_HOST
        }
#endif
        alloc_group_slot();
        /* The count is a `loop` counter: 0 means 65536 members (until pool A is full). */
        do {
            r = find_free_record_pool_a();
            if (r == NO_RECORD) break;
            slot = 0xFFFF;
            if (GroupSlotPtr != 0xFFFF) {
                GAME_PTR(byte, (word)(GroupSlotPtr + GROUP_LIVE))[0]++;
                GAME_PTR(byte, (word)(GroupSlotPtr + GROUP_DROP_KIND))[0] = (byte)GroupDropKind;
                slot = GroupSlotIndex;
            }
            r->slot_index = slot;
            r->status = 1;
            r->draw_pass = FormationDrawPass;
            r->sprite = 0;
#ifdef OVERKILL_HOST
            if (event) {
                r->y = (word)(event->formation->members[member_index].dy + EventY);
                r->x = (word)(event->formation->members[member_index].dx + EventX);
            } else {
#endif
            r->y = (word)(*GAME_PTR(word, (word)(member_offset + 2)) + EventY);
            r->x = (word)(*GAME_PTR(word, member_offset) + EventX);
#ifdef OVERKILL_HOST
            }
#endif
            r->saved_x = r->x;
            r->saved_y = 0;
            r->direction = DIR_DOWN;
            r->size_class = FormationSizeClass;
            r->kind = KIND_ENEMY;
            r->type = FormationType;
            if (r->draw_pass != 1 && r->size_class == 1) snap_to_clear_column(r);
#ifdef OVERKILL_HOST
            r->hit_points = overkill_formation_tile_hit_points(LevelIndex);
            if (r->size_class != 1) r->hit_points = overkill_formation_other_hit_points(LevelIndex);
#else
            r->hit_points = LevelIndex + 1;
            if (r->size_class != 1) r->hit_points = 0x0C;
#endif
            r->flash_timer = 0;
            /* Type 21h starts its leader script with LevelIndex + 1 as the script pointer:
               the oracle's AX still holds it (type 21h follows Type21Path instead). */
#ifdef OVERKILL_HOST
            if (r->type == 0x21) start_leader_script(r, overkill_timeline_director_cursor(LevelIndex + 1));
#else
            if (r->type == 0x21) start_leader_script(r, LevelIndex + 1);
#endif
            if (r->type == 0x13) start_leader_script(r, GAME_OFFSET(LeaderScript13));
            if (r->type == 0x15) start_leader_script(r, GAME_OFFSET(LeaderScript15));
            if (r->type == 0x1C) start_leader_script(r, GAME_OFFSET(LeaderScript1C));
            if (r->type == 0x1F) start_leader_script(r, GAME_OFFSET(LeaderScript1F));
            if (r->type == 0x7D) start_leader_script(r, GAME_OFFSET(LeaderScript7D));
            if (r->type == 0x7E) start_leader_script(r, GAME_OFFSET(LeaderScript7E));
#ifdef OVERKILL_HOST
            if (event) member_index++;
            else
#endif
            member_offset = (word)(member_offset + 4);
        } while (--count != 0);
    }
}

/* The incoming map row (DrawIncomingMapRow): scrolling back it only draws the row 13
   rows above; forward it spawns the row's cells and runs the level script up to
   MAP_LAST_SPAWN_POS. Returns the map offset of the row the bridge draws. */
word draw_incoming_map_row(Record *here)
{
    if (ScrollingBackward == 1) return MapScrollPos - 13 * MAP_ROW_BYTES;
    MapRowCursor = MapScrollPos;
    if (MapScrollPos <= MAP_LAST_SPAWN_POS) {
        spawn_from_map_row(here);
        run_level_script_events();
    }
    return MapScrollPos;
}

/* Types 13h/15h/1Ch/1Fh/7Dh/7Eh (Type13FormationLeaderBody): steers at speed 3 to the
   leader script point (Y + 20h, X); on the call that finds it there, drops the type's
   followers at itself and advances the script (13h: one type 14h; 15h: type 16h on
   SweepPath at Y 40h, else 17h on SweepPathLeadIn; 1Ch: 1Dh, or 1Eh at X 0; 1Fh: five
   20h at the FormationSlots points; 7Dh: sweeper 81h; 7Eh (and any other type): marcher
   7Fh). 15h, 7Dh and 7Eh stop at an FFFFh follower Y. Sprite = 3Bh + direction. */
void type13_formation_leader(Record *r)
{
    word point_offset = LeaderScriptCursor;
    word slot_offset;
    word n, x;
    Record *f;

    SteerTargetY = (word)(*GAME_PTR(word, point_offset) + 0x20);
    SteerTargetX = *GAME_PTR(word, (word)(point_offset + 2));
    point_offset = (word)(point_offset + 4);
    SteerSpeed = 3;
    steer_toward_target(r);
    if (SteerArrived != 0) {
        switch (r->type) {
        case 0x13:
            LeaderScriptCursor += 4;
            if (spawn_enemy_here(r) != NO_RECORD) EncounterLiveCount++;
            break;
        case 0x15:
            LeaderScriptCursor += 8;
            if (*GAME_PTR(word, point_offset) == 0xFFFF) break;
            f = spawn_enemy_here(r);
            if (f == NO_RECORD) break;
            f->saved_y = (word)(*GAME_PTR(word, point_offset) + 0x20);
            f->saved_x = *GAME_PTR(word, (word)(point_offset + 2));
            f->type = 0x16;
            f->path = GAME_OFFSET(SweepPath);
            if (r->y != 0x40) {
                f->type = 0x17;
                f->path = GAME_OFFSET(SweepPathLeadIn);
            }
            f->entry_delay = 0x14;
            f->hit_points = 3;
            EncounterLiveCount++;
            break;
        case 0x1C:
            LeaderScriptCursor += 8;
            f = spawn_enemy_here(r);
            if (f == NO_RECORD) break;
            f->saved_y = (word)(*GAME_PTR(word, point_offset) + 0x20);
            f->saved_x = *GAME_PTR(word, (word)(point_offset + 2));
            f->type = 0x1D;
            if (r->x == 0) {
                f->type = 0x1E;
                f->sprite = 0x43;
            }
            f->entry_delay = 0x14;
            EncounterLiveCount++;
            break;
        case 0x1F:
            LeaderScriptCursor += 4;
            for (n = 5; n != 0; n--) {
                f = spawn_enemy_here(r);
                slot_offset = FormationSlotCursor;
                FormationSlotCursor += 4;
                if (f == NO_RECORD) continue;
                f->saved_y = (word)(*GAME_PTR(word, slot_offset) + 0x20);
                f->saved_x = *GAME_PTR(word, (word)(slot_offset + 2));
                f->type = 0x20;
                f->dive_phase = 0xFFFF;
                EncounterLiveCount++;
            }
            break;
        case 0x7D:
            LeaderScriptCursor += 8;
            if (*GAME_PTR(word, point_offset) == 0xFFFF) break;
            f = spawn_enemy_here(r);
            if (f == NO_RECORD) break;
            f->saved_y = (word)(*GAME_PTR(word, point_offset) + 0x20);
            x = *GAME_PTR(word, (word)(point_offset + 2));
            f->saved_x = x;
            f->direction = DIR_RIGHT;
            if (x >> 4 & 1) f->direction = DIR_LEFT;
            f->type = 0x81;
            f->entry_delay = 0x19;
            f->hit_points = 5;
            f->draw_pass = 0;
            f->blocked_climbs = 0;
            EncounterLiveCount++;
            break;
        default:
            LeaderScriptCursor += 8;
            if (*GAME_PTR(word, point_offset) == 0xFFFF) break;
            f = spawn_enemy_here(r);
            if (f == NO_RECORD) break;
            f->saved_y = (word)(*GAME_PTR(word, point_offset) + 0x20);
            f->saved_x = *GAME_PTR(word, (word)(point_offset + 2));
            f->type = 0x7F;
            f->entry_delay = 0x14;
            f->hit_points = 5;
            EncounterLiveCount++;
            break;
        }
    }
    r->sprite = r->direction + 0x3B;
}

/* Level 4 type 21h (Type21LeaderPathBody): steers at speed 3 along Type21Path (Y + 20h,
   X; restarting at its FFFFh end); at each waypoint it drops to 2 hit points and spawns
   a type 64h child with REC_SAVED = its own position. Sprite = 3Bh + direction. */
void type21_leader_path(Record *r)
{
    word point_offset;
    Record *f;

    for (;;) {
        point_offset = Type21PathCursor;
        if (*GAME_PTR(word, point_offset) != 0xFFFF) break;
        reset_type21_path();
    }
    SteerTargetY = (word)(*GAME_PTR(word, point_offset) + 0x20);
    SteerTargetX = *GAME_PTR(word, (word)(point_offset + 2));
    SteerSpeed = 3;
    steer_toward_target(r);
    if (SteerArrived != 0) {
        r->hit_points = 2;
        Type21PathCursor += 4;
        f = spawn_enemy_here(r);
        if (f != NO_RECORD) {
            f->saved_y = r->y;
            f->saved_x = r->x;
            f->type = 0x64;
            f->hit_points = 3;
            f->sprite = 0x8E;
        }
    }
    r->sprite = r->direction + 0x3B;
}

/* ---- attract demo steps ------------------------------------------------------------- */

/* A type 51h path enemy at (C0h, C8h); unchecked: a full pool A writes through FFFFh. */
void demo_step_spawn_path_enemy51(Record *here)
{
    Record *r = spawn_enemy_here(here);

    GAME_RECORD_FIELD(r, x) = PLAYFIELD_MAX_X;
    GAME_RECORD_FIELD(r, y) = 0xC8;
    GAME_RECORD_FIELD(r, type) = 0x51;
}

/* The front pod as a type 50h enemy flying to the player's (X + 8, Y - 8), sfx 1Eh;
   unchecked like the above. Returns the pod (the oracle leaves it in BP). */
Record *demo_step_launch_front_pod(void)
{
    Record *r;

    if (SfxEnabled != 0) SfxRequest = 0x1E;
    r = find_free_record_pool_a();
    FrontPodRecord = GAME_OFFSET(r);
    init_enemy_record_here(r, PRIMARY);
    GAME_RECORD_FIELD(r, y) = 0;
    GAME_RECORD_FIELD(r, sprite) = 0x0F;
    GAME_RECORD_FIELD(r, type) = 0x50;
    GAME_RECORD_FIELD(r, saved_x) = PRIMARY->x + 8;
    GAME_RECORD_FIELD(r, saved_y) = PRIMARY->y - 8;
    return r;
}
