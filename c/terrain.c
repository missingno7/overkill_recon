/* Shared grid probes and one-pixel terrain movement, translated from the frozen oracle
   (asm-semantic-oracle-v1). This region owns map lookup, ship/map collision, walker
   overlap and climbing, and the TryTerrainStep orchestration. Map cell offsets remain
   unchecked 16-bit offsets into the level-map load buffer.

   SEGMENT: CGAME
   OWNS: ProbeShipTerrainCollision ReadIndexedByteAttribute GridOffsetNegativeY
   OWNS: ComputeRecordGridOffset ClimbWalkerBlocked ClimbWalkerStep ProbeOverlapsWalker
   OWNS: TerrainStepInDirection TerrainStepCases TerrainStepBlocked TerrainStepDownRight
   OWNS: TerrainStepDown TerrainStepUpLeft TerrainStepUp TerrainStepUpRight TerrainStepRight
   OWNS: TerrainStepDownLeft TerrainStepLeft TryTerrainStep
*/
#include "terrain.h"

/* The level map: MAP_ROW_BYTES cells per row in the segment held by the CS word
   LevelMapSegment (MAIN). Cell offsets are 16-bit and unchecked, as in the oracle. */
#ifdef OVERKILL_HOST
#define MAP_CELL(cell) (*(byte *)overkill_level_map_address(cell))
#else
extern word __far LevelMapSegment;
#define MAP_CELL(cell) (*(byte __far *)((__segment)LevelMapSegment :> (void __near *)(cell)))
#endif

/* ReadIndexedByteAttribute: ByteAttributeTable[map byte at `cell`]. */
word map_attribute(word cell)
{
    return ByteAttributeTable[MAP_CELL(cell)];
}

/* ComputeRecordGridOffset for the point (x, y): GridYSum = ScrollSubRow + y; FFFFh when
   that is negative, else MapScrollPos - MAP_ROW_BYTES * (GridYSum >> 4) + (x >> 4). The
   oracle moves REC_Y/REC_X around its calls instead; the result and GridYSum are the same. */
word grid_offset_at(word x, word y)
{
    GridYSum = ScrollSubRow + y;
    if ((sword)GridYSum < 0) return 0xFFFF;
    return MapScrollPos - (GridYSum >> 4) * MAP_ROW_BYTES + (x >> 4);
}

word compute_record_grid_offset(Record *r)
{
    return grid_offset_at(r->x, r->y);
}

/* The ship's hit point (PlayerHitOffsets by form) over a solid cell: one map row, two when
   the point is more than 10 px into its cell; the next column too off a cell boundary.
   1 (the oracle's CF) also for a destroyed ship (form 3+). An FFFFh grid offset is not
   checked: + MAP_ROW_BYTES wraps to 000Ch. */
word probe_ship_terrain_collision(Record *ship)
{
    word *hit, x, cell, rows;

    if (ship->sprite >= 3) return 1;
    hit = &PlayerHitOffsets[ship->sprite * 2];
    x = ship->x + hit[1];
    cell = grid_offset_at(x, ship->y + hit[0]) + MAP_ROW_BYTES;
    rows = (GridYSum & 0x0F) > 0x0A ? 2 : 1;
    do {
        if (map_attribute(cell)) return 1;
        if ((x & 0x0F) && map_attribute(cell + 1)) return 1;
        cell -= MAP_ROW_BYTES;
    } while (--rows);
    return 0;
}

/* ProbeOverlapsWalker: 1 (the oracle's CF) when TerrainProbeY/X lies strictly within 10h
   (signed) of another walker: a live pool A enemy of type 82h..94h, pass 0, size 1; the
   record itself is recognised by its REC_SAVE_BUFFER. Always 0 for a pass-1 record. */
word probe_overlaps_walker(Record *r)
{
    Record *w = POOL_A;
    word n;

    if (r->draw_pass == 1) return 0;
    for (n = POOL_A_COUNT; n != 0; n--, w++) {
        if (w->status == 0 || w->draw_pass == 1 || w->size_class != 1 || w->kind != KIND_ENEMY) continue;
        if (w->type < 0x82 || w->type > 0x94) continue;
        if ((sword)TerrainProbeY >= (sword)(w->y + 0x10) || (sword)TerrainProbeY <= (sword)(w->y - 0x10)) continue;
        if ((sword)TerrainProbeX >= (sword)(w->x + 0x10) || (sword)TerrainProbeX <= (sword)(w->x - 0x10)) continue;
        if (r->save_buffer == w->save_buffer) continue;
        return 1;
    }
    return 0;
}

/* One-pixel axis steps of TerrainStepInDirection. `cell` is the running grid offset of
   the record's box (the oracle's DX); each step returns it updated for a crossed cell
   boundary, or unchanged with TerrainBlocked = 1 when the map or a walker blocks. */
word terrain_step_down(Record *r, word cell)
{
    word probe = cell - MAP_ROW_BYTES;

    if (map_attribute(probe) || ((r->x & 0x0F) && map_attribute(probe + 1))) goto blocked;
    r->y++;
    TerrainProbeY++;
    if (probe_overlaps_walker(r)) {
        r->y--;
        TerrainProbeY--;
        goto blocked;
    }
    GridYSum = (GridYSum + 1) & 0x0F;
    if (GridYSum == 0) cell -= MAP_ROW_BYTES;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

/* Probes only when the box is row-aligned (GridYSum mod 16 = 0). */
word terrain_step_up(Record *r, word cell)
{
    word probe = cell + MAP_ROW_BYTES;

    if ((GridYSum & 0x0F) == 0
            && (map_attribute(probe) || ((r->x & 0x0F) && map_attribute(probe + 1)))) goto blocked;
    r->y--;
    TerrainProbeY--;
    if (probe_overlaps_walker(r)) {
        r->y++;
        TerrainProbeY++;
        goto blocked;
    }
    GridYSum = (GridYSum - 1) & 0x0F;
    if (GridYSum == 0x0F) cell += MAP_ROW_BYTES;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

word terrain_step_right(Record *r, word cell)
{
    if (map_attribute(cell + 1) || ((GridYSum & 0x0F) && map_attribute(cell + 1 - MAP_ROW_BYTES))) goto blocked;
    r->x++;
    TerrainProbeX++;
    if (probe_overlaps_walker(r)) {
        r->x--;
        TerrainProbeX--;
        goto blocked;
    }
    if ((r->x & 0x0F) == 0) cell++;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

/* Probes only when the box is column-aligned (X mod 16 = 0). */
word terrain_step_left(Record *r, word cell)
{
    if ((r->x & 0x0F) == 0
            && (map_attribute(cell - 1) || ((GridYSum & 0x0F) && map_attribute(cell - 1 - MAP_ROW_BYTES)))) goto blocked;
    r->x--;
    TerrainProbeX--;
    if (probe_overlaps_walker(r)) {
        r->x++;
        TerrainProbeX++;
        goto blocked;
    }
    if ((r->x & 0x0F) == 0x0F) cell--;
    return cell;
blocked:
    TerrainBlocked = 1;
    return cell;
}

/* Body of TryTerrainStep: one pixel along REC_DIRECTION (0..7; the oracle's table is
   unchecked). Diagonals are two axis steps, each tried even when the first is blocked; a
   negative GridYSum (grid offset FFFFh) is blocked. */
void terrain_step_in_direction(Record *r)
{
    word cell = compute_record_grid_offset(r);

    if (cell == 0xFFFF) {
        TerrainBlocked = 1;
        return;
    }
    switch (r->direction) {
    case DIR_UP:         terrain_step_up(r, cell); break;
    case DIR_UP_RIGHT:   terrain_step_right(r, terrain_step_up(r, cell)); break;
    case DIR_RIGHT:      terrain_step_right(r, cell); break;
    case DIR_DOWN_RIGHT: terrain_step_down(r, terrain_step_right(r, cell)); break;
    case DIR_DOWN:       terrain_step_down(r, cell); break;
    case DIR_DOWN_LEFT:  terrain_step_left(r, terrain_step_down(r, cell)); break;
    case DIR_LEFT:       terrain_step_left(r, cell); break;
    case DIR_UP_LEFT:    terrain_step_up(r, terrain_step_left(r, cell)); break;
    }
}

/* Climbing walker: one TryTerrainStep up (the walker below the player: down) along a wall
   cell on its WalkerFacingStep side, probed from the box one row above the scrolled
   position; blocked (TerrainBlocked 1, the result) when there is no wall. */
word climb_walker_step(Record *w)
{
    word cell;

    TerrainBlocked = 0;
    w->direction = DIR_UP;
    cell = grid_offset_at(w->x, w->y + ScrollDeltaY - 0x10);
    if (cell != 0xFFFF) {
        cell += WalkerFacingStep;
        if ((sword)w->y < (sword)PRIMARY->y) {
            w->direction = DIR_DOWN;
            cell -= MAP_ROW_BYTES;
        }
        if (map_attribute(cell)) {
            try_terrain_step(w);
            return TerrainBlocked;
        }
    }
    TerrainBlocked = 1;
    return 1;
}

/* TryTerrainStep: one pixel along REC_DIRECTION unless the map (or a walker) blocks it;
   returns TerrainBlocked (the bridge turns it into the oracle's ZF). The step works on the
   16x16 box at (X, Y + ScrollDeltaY - 10h); Y is moved back afterwards, keeping any step. */
word try_terrain_step(Record *r)
{
    TerrainBlocked = 0;
    TerrainStartY = r->y;
    TerrainProbeY = r->y;
    TerrainStartX = r->x;
    TerrainProbeX = r->x;
    r->y += ScrollDeltaY;
    r->y -= 0x10;
    terrain_step_in_direction(r);
    r->y += 0x10;
    r->y -= ScrollDeltaY;
    return TerrainBlocked;
}
