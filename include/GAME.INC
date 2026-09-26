; Game session state, modern names from code behaviour. DS offsets in the state segment.

; Number of levels (LevelIndex wraps modulo this).
LEVEL_COUNT equ 06h
; LivesLeft at the start of a game.
INITIAL_LIVES equ 03h
; 8-digit packed BCD score, least significant byte first; compared with the
; high-score entries (+0Ch..+0Fh) when the game ends.
; Waypoint Y that ends a leader script (never reached).
LEADER_END_Y equ 7530h
; Upgrade selector slot fields (UpgradeSlot0..3).
UPGRADE_SLOT_ICON equ 0
UPGRADE_SLOT_SCREEN equ 2
UPGRADE_SLOT_IMAGE equ 4
UPGRADE_SLOT_LIST equ 6
UPGRADE_SLOT_INDEX equ 8
UPGRADE_SLOT_BYTES equ 0Ah
; LevelEndPhase: the end-of-level sequence started at MapScrollPos 0EA0h.
LEVEL_END_OFF equ 0
; Autopilot to AutopilotWaypointA.
LEVEL_END_TO_WAYPOINT_A equ 1
; Autopilot to AutopilotWaypointB, side pods drawn in toward the ship.
LEVEL_END_TO_WAYPOINT_B equ 2
; Refuel and refill energy until full while the ship climbs 1 px per frame (IN_YMINUS,
; unguarded, so Y can go negative).
LEVEL_END_REFILL equ 3
; Raises NextLevelRequest.
LEVEL_END_DONE equ 4
; Level map: 13 cells per row; MapScrollPos is a row start (row * MAP_ROW_BYTES).
MAP_ROW_BYTES equ 0Dh
; Where a level (or a life) starts scrolling; life-start music 4 plays here.
MAP_START_POS equ 12 * MAP_ROW_BYTES
; Up to here only the single (or fork) shot fires and pods stay idle (outside the demo).
MAP_INTRO_END_POS equ 14 * MAP_ROW_BYTES
; An encounter ending at or beyond this position restores MUSIC_LATE_LEVEL instead of
; the level tune (TickFrameTimers); nothing changes on merely crossing it.
MAP_MUSIC_CHANGE_POS equ 144 * MAP_ROW_BYTES
; Last row that spawns map objects and runs the level script.
MAP_LAST_SPAWN_POS equ 282 * MAP_ROW_BYTES
; First of the LevelEndMapRows (drawn with ShipSegment blocks).
MAP_END_ROWS_POS equ 283 * MAP_ROW_BYTES
; Scroll position set before scrolling back to a checkpoint.
MAP_RESTART_POS equ 287 * MAP_ROW_BYTES
; Reaching it starts the level end (LevelEndPhase).
MAP_END_POS equ 288 * MAP_ROW_BYTES
; WeaponMode values (FireMainWeapon, FirePodWeapon).
WEAPON_SINGLE equ 0
WEAPON_HEAVY equ 1
WEAPON_FORK equ 2
WEAPON_TWIN_RISING3 equ 3
WEAPON_TWIN_RISING16 equ 4
WEAPON_BEAM equ 5
; Record X range on the playfield (0..PLAYFIELD_MAX_X) and its centre line, which
; decides which way edge-spawned enemies face.
PLAYFIELD_MAX_X equ 0C0h
PLAYFIELD_CENTER_X equ 60h
; PANEL.ENC images (PanelImageOffsets indices) drawn by the HUD code.
PANEL_UPGRADE_FRAME equ 17h
; + cell value 0..4.
PANEL_ENERGY_CELL equ 19h
PANEL_SHIP_ICON equ 1Eh
PANEL_NO_SHIP_ICON equ 1Fh
; + EnergyTanks.
PANEL_TANK_GAUGE equ 20h
PANEL_HUD_FRAME equ 25h
PANEL_PAUSE_LOWER equ 26h
PANEL_PAUSE_UPPER equ 27h
PANEL_QUIT_PROMPT equ 28h
PANEL_FUEL_EMPTY equ 29h
