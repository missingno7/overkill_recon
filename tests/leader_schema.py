"""Shared original leader presets and v11 owned-path validation."""
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
from level_paths import LEADER_BINDINGS, source_leaders  # noqa: E402
import level_leaders  # noqa: E402
from level_leaders import (  # noqa: E402
    generate_leader_preset_header,
    original_leader_presets,
    validate_authored_leader_paths,
)
from level_format import load, original_paths, validate  # noqa: E402


def _step(name, follower=None):
    value = {"target": {"x": 12, "y": 31}}
    if LEADER_BINDINGS[name][1] == 8:
        value["follower"] = follower
    return value


class LeaderSchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.machine = exact_oracle(True)

    def test_catalog_has_six_exact_leaders_and_twenty_slots(self):
        catalog = original_leader_presets()
        self.assertEqual(set(catalog), set(LEADER_BINDINGS))
        self.assertEqual(len(catalog), 6)
        self.assertEqual(len(catalog["slot_hopper_leader"]["slots"]), 20)
        self.assertEqual(sum(len(item["steps"]) + 1 for item in catalog.values()), 122)
        for name, definition in catalog.items():
            with self.subTest(name=name):
                self.assertEqual(definition["end"]["kind"], "fly_off")
                self.assertGreaterEqual(len(definition["steps"]), 1)

    def test_generated_defaults_match_all_oracle_starts_and_terminal_counts(self):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            generate_leader_preset_header(output, self.machine)
            header = (output / "LEVEL_LEADER_PRESETS_GEN.H").read_text(encoding="utf-8")
        body = header.split("static const LevelLeaderPreset level_leader_presets[] = {", 1)[1]
        body = body.split("};", 1)[0]
        rows = re.findall(r'\{"([a-z0-9_]+)", (\d+), (\d+), (\d+), leader_steps_([a-z0-9_]+)\}', body)
        self.assertEqual([row[0] for row in rows], list(LEADER_BINDINGS))
        sources = source_leaders(self.machine)
        catalog = original_leader_presets()
        for name, start, end, count, array in rows:
            with self.subTest(name=name):
                self.assertEqual(array, name)
                self.assertEqual(int(start), sources[name][0])
                label = LEADER_BINDINGS[name][0]
                self.assertEqual(int(end), self.machine.offset(label + "End"))
                self.assertEqual(int(count), len(catalog[name]["steps"]) + 1)
                self.assertIn(f"static const LevelLeaderStep leader_steps_{name}[]", header)
        self.assertIn("static const LevelLeaderSlot level_leader_slots_default[]", header)
        self.assertIn("{0, 0, 0, 0, 0}", header)

        altered = copy.deepcopy(catalog)
        altered["sway_leader"]["steps"][0]["target"]["x"] += 1
        with patch.object(level_leaders, "original_leader_presets", return_value=altered):
            with tempfile.TemporaryDirectory() as temp:
                with self.assertRaisesRegex(ValueError, "differs from maintained original"):
                    generate_leader_preset_header(Path(temp), self.machine)

    def test_owned_scripts_are_optional_and_semantic_v11_data(self):
        validate_authored_leader_paths({"version": 11})
        authored = {"version": 11, "leader_paths": {
            "sway_leader": {"steps": [_step("sway_leader")], "end": {"kind": "fly_off", "x": -4}},
            "bob_chase_leader": {
                "steps": [_step("bob_chase_leader", {"x": 0, "y": 31})],
                "end": {"kind": "fly_off", "x": 0},
            },
            "sweep_leader": {
                "steps": [_step("sweep_leader", None)], "end": {"kind": "fly_off", "x": 0},
            },
        }}
        validate_authored_leader_paths(authored)

    def test_bad_version_names_steps_sentinels_and_slots_are_rejected(self):
        valid_step = _step("sway_leader")
        base = {"version": 11, "leader_paths": {
            "sway_leader": {"steps": [valid_step], "end": {"kind": "fly_off", "x": 0}},
        }}
        cases = []
        old_version = copy.deepcopy(base)
        old_version["version"] = 10
        cases.append(old_version)
        for name in ("invented", "Leader"):
            edited = copy.deepcopy(base)
            edited["leader_paths"][name] = copy.deepcopy(edited["leader_paths"]["sway_leader"])
            cases.append(edited)
        bad_target = copy.deepcopy(base)
        bad_target["leader_paths"]["sway_leader"]["steps"][0]["target"]["x"] = True
        cases.append(bad_target)
        bad_bob = {"version": 11, "leader_paths": {
            "bob_chase_leader": {
                "steps": [_step("bob_chase_leader", None)],
                "end": {"kind": "fly_off", "x": 0},
            },
        }}
        cases.append(bad_bob)
        malformed_sway = copy.deepcopy(base)
        malformed_sway["leader_paths"]["sway_leader"]["steps"][0]["follower"] = {"x": 0, "y": 32}
        cases.append(malformed_sway)
        duplicate_slots = {"version": 11, "leader_paths": {
            "slot_hopper_leader": {
                "steps": [_step("slot_hopper_leader")],
                "end": {"kind": "fly_off", "x": 0},
                "slots": [{"x": 2, "y": 31}] * 2,
            },
        }}
        cases.append(duplicate_slots)
        for index, document in enumerate(cases):
            with self.subTest(index=index), self.assertRaises(ValueError):
                validate_authored_leader_paths(document)

    def test_defaults_plus_overrides_obey_word_sized_flattening_bound(self):
        short = {
            name: {"steps": [_step(name, None if name in level_leaders.NO_FOLLOWER_SENTINEL_NAMES
                                           else {"x": 1, "y": 32})],
                   "end": {"kind": "fly_off", "x": 0}}
            for name in LEADER_BINDINGS
        }
        short["slot_hopper_leader"]["slots"] = [{"x": 0, "y": 31}, {"x": 1, "y": 31}]
        document = {"version": 11, "leader_paths": {
            "sway_leader": {
                "steps": [_step("sway_leader")] * 65524,
                "end": {"kind": "fly_off", "x": 0},
            },
        }}
        with patch.object(level_leaders, "original_leader_presets", return_value=short):
            validate_authored_leader_paths(document)  # 65,535 including all six terminals.
            document["leader_paths"]["sway_leader"]["steps"] = [_step("sway_leader")] * 65525
            with self.assertRaisesRegex(ValueError, "exceed 65535"):
                validate_authored_leader_paths(document)

    def test_format_rejects_future_version_but_canonical_fixtures_validate(self):
        originals = [load(path) for path in original_paths()]
        self.assertTrue(all(document["version"] == 9 for document in originals))
        for document in originals:
            validate(document)
        unsupported = copy.deepcopy(originals[0])
        unsupported["version"] = 14
        with self.assertRaisesRegex(ValueError, "unsupported level version"):
            validate(unsupported)


if __name__ == "__main__":
    unittest.main()
