"""Shared special path presets and v12 ownership validation."""
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
from level_paths import source_paths, validate_path_sections  # noqa: E402
import level_special_paths  # noqa: E402
from level_special_paths import (  # noqa: E402
    SPECIAL_PATH_NAMES,
    generate_special_path_preset_header,
    original_special_path_presets,
    validate_authored_special_paths,
)
from level_waypoints import validate_authored_waypoints  # noqa: E402


class SpecialPathSchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.machine = exact_oracle(True)
        cls.originals = [load(path) for path in original_paths()]

    def test_catalog_and_generated_header_match_four_special_oracle_streams(self):
        presets = original_special_path_presets()
        self.assertEqual(set(presets), set(SPECIAL_PATH_NAMES))
        sources = source_paths(self.machine)
        self.assertEqual(presets, {name: sources[name][2] for name in SPECIAL_PATH_NAMES})
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            generate_special_path_preset_header(output, self.machine)
            header = (output / "LEVEL_SPECIAL_PATH_PRESETS_GEN.H").read_text(encoding="utf-8")
        body = header.split("static const LevelSpecialPreset level_special_path_presets[] = {", 1)[1]
        body = body.split("};", 1)[0]
        rows = re.findall(
            r'\{"([a-z0-9_]+)", (\d+), (\d+), (\d+), (\d+), special_path_([a-z0-9_]+)\}', body)
        self.assertEqual([row[0] for row in rows], list(SPECIAL_PATH_NAMES))
        ending_codes = {"continue": 0, "jump": 1, "restart": 2}
        targets = {"sweep_lead_in": 1, "sweep_loop": 1,
                   "encounter_leader": 2, "boss_anchor": 3}
        for name, start, count, ending, target, symbol in rows:
            definition = presets[name]
            source = sources[name]
            with self.subTest(name=name):
                self.assertEqual(symbol, name)
                self.assertEqual(int(start), source[0])
                self.assertEqual(int(count), len(definition["points"]) +
                                 (definition["end"]["kind"] != "continue"))
                self.assertEqual(int(ending), ending_codes[definition["end"]["kind"]])
                self.assertEqual(int(target), targets[name])
                if definition["end"]["kind"] != "continue":
                    self.assertIn("{0xFFFF, 0, 0, 1}", header)
        self.assertIn("{0, 0, 0, 0, 0, 0}", header)

    def test_v12_can_own_partial_special_paths_but_v11_cannot(self):
        original = self.originals[0]
        override = {"points": [{"x": -5, "y": 31}, {"x": 7, "y": 44}],
                    "end": {"kind": "continue", "path": "sweep_loop"}}
        authored = {"version": 12, "paths": {"sweep_lead_in": override}}
        validate_authored_waypoints(authored, original)
        validate_path_sections(authored)
        with self.assertRaisesRegex(ValueError, "undefined path"):
            validate_path_sections({"version": 11, "paths": {"sweep_lead_in": override}})
        with self.assertRaisesRegex(ValueError, "must be retained"):
            validate_authored_waypoints({"version": 11, "paths": {}}, original)
        changed = {"version": 11, "paths": copy.deepcopy(original["paths"])}
        changed["paths"]["sweep_lead_in"] = copy.deepcopy(override)
        with self.assertRaisesRegex(ValueError, "must remain unchanged"):
            validate_authored_waypoints(changed, original)

    def test_special_endings_and_loop_safety_are_fixed(self):
        definitions = {
            "sweep_lead_in": {"points": [{"x": 0, "y": 31}],
                              "end": {"kind": "continue", "path": "sweep_loop"}},
            "sweep_loop": {"points": [{"x": 0, "y": 31}, {"x": 1, "y": 31}],
                           "end": {"kind": "jump", "path": "sweep_loop"}},
            "encounter_leader": {"points": [{"x": 0, "y": 31}],
                                 "end": {"kind": "restart"}},
            "boss_anchor": {"points": [{"x": 0, "y": 31}, {"x": 1, "y": 31}],
                            "end": {"kind": "restart"}},
        }
        for name, definition in definitions.items():
            with self.subTest(name=name):
                validate_authored_special_paths({"version": 12, "paths": {name: definition}},
                                                {"paths": {}})
        invalid = copy.deepcopy(definitions)
        invalid["sweep_lead_in"]["end"] = {"kind": "restart"}
        with self.assertRaisesRegex(ValueError, "ending topology"):
            validate_authored_special_paths({"version": 12, "paths": invalid}, {"paths": {}})
        for name in ("sweep_loop", "boss_anchor"):
            same_point = copy.deepcopy(definitions[name])
            same_point["points"] = [{"x": 0, "y": 31}] * 2
            with self.subTest(name=name), self.assertRaisesRegex(ValueError, "distinct"):
                validate_authored_special_paths({"version": 12, "paths": {name: same_point}},
                                                {"paths": {}})

    def test_special_pool_word_limit_counts_control_nodes_and_replaced_defaults(self):
        defaults = {name: 1 for name in SPECIAL_PATH_NAMES}
        point_a, point_b = {"x": 1, "y": 31}, {"x": 2, "y": 31}
        accepted = {"points": [point_a, point_b] * 32765 + [point_a],
                    "end": {"kind": "jump", "path": "sweep_loop"}}
        with patch.object(level_special_paths, "original_special_path_presets",
                          return_value={name: {
                                            "points": [{"x": 0, "y": 31}],
                                            "end": level_special_paths.SPECIAL_PATH_ENDINGS[name],
                                        } for name in SPECIAL_PATH_NAMES}):
            # 65,531 points plus one jump node, with three untouched defaults.
            validate_authored_special_paths({"version": 12, "paths": {"sweep_loop": accepted}},
                                            {"paths": {}}, defaults)
            too_many = copy.deepcopy(accepted)
            too_many["points"].append(point_b)
            with self.assertRaisesRegex(ValueError, "exceed 65535"):
                validate_authored_special_paths(
                    {"version": 12, "paths": {"sweep_loop": too_many}}, {"paths": {}}, defaults)

    def test_latest_duplicate_uses_v12_and_validates(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp) / "special-path-level"
            duplicate_original(0, directory, "special-path-test")
            document = validate_directory(directory)
        self.assertEqual(document["version"], 12)


if __name__ == "__main__":
    unittest.main()
