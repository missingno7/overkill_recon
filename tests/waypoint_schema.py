"""Shared waypoint catalog, generated presets and v10 path validation tests."""
from __future__ import annotations

import copy
from pathlib import Path
import re
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from export_original_levels import exact_oracle  # noqa: E402
from level_content import duplicate_original, validate_directory  # noqa: E402
from level_format import load, original_paths  # noqa: E402
import level_waypoints  # noqa: E402
from level_waypoints import (  # noqa: E402
    ORDINARY_WAYPOINT_NAMES,
    generate_waypoint_preset_header,
    original_waypoint_presets,
    validate_authored_waypoints,
)
from level_paths import source_paths  # noqa: E402
from world import K  # noqa: E402


def _header_presets(header: str):
    body = header.split("static const LevelWaypointPreset level_waypoint_presets[] = {", 1)[1]
    body = body.split("};", 1)[0]
    return re.findall(r'\{"([a-z0-9_]+)", (\d+), (\d+), waypoints_([a-z0-9_]+)\}', body)


class WaypointSchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.machine = exact_oracle(True)
        cls.documents = [load(path) for path in original_paths()]

    def test_catalog_has_ten_original_presets_and_94_points_including_terminals(self):
        presets = original_waypoint_presets()
        self.assertEqual(set(presets), set(ORDINARY_WAYPOINT_NAMES))
        self.assertEqual(len(presets), 10)
        self.assertEqual(sum(len(item["points"]) + 1 for item in presets.values()), 94)
        for name, definition in presets.items():
            with self.subTest(name=name):
                self.assertEqual(definition["end"]["kind"], "fly_off")
                self.assertGreaterEqual(len(definition["points"]), 1)

    def test_generated_header_checks_catalog_and_emits_ten_terminal_aware_presets(self):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            generate_waypoint_preset_header(output, self.machine)
            header = (output / "LEVEL_WAYPOINT_PRESETS_GEN.H").read_text(encoding="utf-8")
        rows = _header_presets(header)
        self.assertEqual(len(rows), 10)
        self.assertEqual([row[0] for row in rows], list(ORDINARY_WAYPOINT_NAMES))
        sources = source_paths(self.machine)
        presets = original_waypoint_presets()
        for name, legacy_start, count, array_name in rows:
            with self.subTest(name=name):
                self.assertEqual(array_name, name)
                self.assertEqual(int(legacy_start), sources[name][0])
                self.assertEqual(int(count), len(presets[name]["points"]) + 1)
                self.assertIn(f"static const LevelWaypoint waypoints_{name}[]", header)
                self.assertIn(f"{{{K.LEADER_END_Y}, ", header)
        self.assertIn("{0, 0, 0, 0}", header)

        changed = copy.deepcopy(presets)
        first = next(iter(changed))
        changed[first]["points"][0]["x"] += 1
        with patch.object(level_waypoints, "original_waypoint_presets", return_value=changed):
            with tempfile.TemporaryDirectory() as temp:
                with self.assertRaisesRegex(ValueError, "differs from maintained original"):
                    generate_waypoint_preset_header(Path(temp), self.machine)

    def test_owned_waypoint_counts_replace_defaults_and_special_paths_are_excluded(self):
        counts = {name: 7270 for name in ORDINARY_WAYPOINT_NAMES}
        counts[ORDINARY_WAYPOINT_NAMES[0]] = 100
        # Ten defaults total 65,530. An authored 90-word route replaces the
        # 100-word default, so the aggregate is 65,520 and remains representable.
        document = {"version": 10, "paths": {
            ORDINARY_WAYPOINT_NAMES[0]: {
                "points": [{"x": 4, "y": 32}] * 89,
                "end": {"kind": "fly_off", "x": 8},
            },
            "boss_anchor": {"points": [{"x": 0, "y": 32}] * 7000,
                            "end": {"kind": "restart"}},
        }}
        original = {"paths": {
            "boss_anchor": copy.deepcopy(document["paths"]["boss_anchor"]),
        }}
        validate_authored_waypoints(document, original, counts)

        too_many = copy.deepcopy(document)
        too_many["paths"][ORDINARY_WAYPOINT_NAMES[0]]["points"] = [
            {"x": 4, "y": 32}
        ] * 106
        with self.assertRaisesRegex(ValueError, "exceed 65535"):
            validate_authored_waypoints(too_many, original, counts)

    def test_unknown_or_malformed_owned_paths_are_rejected(self):
        original = {"paths": {}}
        valid = {"version": 10, "paths": {}}
        validate_authored_waypoints(valid, original)

        cases = []
        unknown = copy.deepcopy(valid)
        unknown["paths"]["invented_route"] = {
            "points": [{"x": 0, "y": 32}],
            "end": {"kind": "fly_off", "x": 0},
        }
        cases.append(unknown)
        for ending in ({"kind": "restart"}, {"kind": "fly_off", "x": True},
                       {"kind": "fly_off", "x": 32768},
                       {"kind": "fly_off", "x": 0, "extra": 1}):
            edited = copy.deepcopy(valid)
            edited["paths"][ORDINARY_WAYPOINT_NAMES[0]] = {
                "points": [{"x": 0, "y": 32}], "end": ending,
            }
            cases.append(edited)
        empty = copy.deepcopy(valid)
        empty["paths"][ORDINARY_WAYPOINT_NAMES[0]] = {
            "points": [], "end": {"kind": "fly_off", "x": 0},
        }
        cases.append(empty)
        bad_point = copy.deepcopy(valid)
        bad_point["paths"][ORDINARY_WAYPOINT_NAMES[0]] = {
            "points": [{"x": False, "y": 32}],
            "end": {"kind": "fly_off", "x": 0},
        }
        cases.append(bad_point)
        for index, document in enumerate(cases):
            with self.subTest(index=index):
                with self.assertRaises(ValueError):
                    validate_authored_waypoints(document, original)

    def test_nonordinary_paths_must_be_present_and_match_original(self):
        original = {"paths": {"boss_anchor": {
            "points": [{"x": 0, "y": 32}], "end": {"kind": "restart"},
        }}}
        missing = {"version": 10, "paths": {}}
        with self.assertRaisesRegex(ValueError, "must be retained"):
            validate_authored_waypoints(missing, original)
        changed = copy.deepcopy(original["paths"])
        changed["boss_anchor"]["points"][0]["x"] = 1
        with self.assertRaisesRegex(ValueError, "must remain unchanged"):
            validate_authored_waypoints({"version": 10, "paths": changed}, original)

    def test_v12_local_level_creation_and_validation(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp) / "local-level"
            duplicate_original(0, directory, "local-waypoint-test")
            document = validate_directory(directory)
            self.assertEqual(document["version"], 12)
            self.assertEqual(document["id"], "local-waypoint-test")


if __name__ == "__main__":
    unittest.main()
