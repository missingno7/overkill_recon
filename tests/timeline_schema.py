"""Python schema and generator checks for version-9 timeline parameters."""
from __future__ import annotations

import copy
from pathlib import Path
import re
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from export_original_levels import exact_oracle  # noqa: E402
from level_bindings import bind_level_documents  # noqa: E402
from level_format import load, original_paths, validate  # noqa: E402
from level_timeline import (  # noqa: E402
    generate_level_preset_header,
    generate_timeline_parameter_header,
    original_formation_spawn_parameters,
)


def _parameter_entries(header: str) -> list[str]:
    match = re.search(
        r"static const LevelFormationSpawnParameters \*const formation_spawn_parameters\[\] = \{([^}]*)\};",
        header,
    )
    if match is None:
        raise AssertionError("generated header has no formation_spawn_parameters array")
    return [entry.strip() for entry in match.group(1).split(",")]


class TimelineSchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.machine = exact_oracle(True)
        cls.documents = [load(path) for path in original_paths()]

    def _timeline_header(self, documents):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            generate_timeline_parameter_header(output, documents, self.machine)
            return (output / "LEVEL_TIMELINE_PARAMS_GEN.H").read_text(encoding="utf-8")

    def test_canonical_live_parameters_match_original_and_bind_null_for_all_levels(self):
        header = self._timeline_header(self.documents)
        self.assertEqual(_parameter_entries(header), ["0"] * 6)
        for level, document in enumerate(self.documents):
            with self.subTest(level=level):
                self.assertEqual(
                    document["formation_spawn_parameters"],
                    original_formation_spawn_parameters(level),
                )

    def test_authored_hp_values_are_owned_and_get_independent_bindings(self):
        authored = copy.deepcopy(self.documents)
        for level, document in enumerate(authored):
            document["formation_spawn_parameters"] = {
                "tile_member_hit_points": 0 if level == 0 else 100 + level,
                "other_member_hit_points": 0xFFFF,
            }
            validate(document)

        header = self._timeline_header(authored)
        self.assertEqual(
            _parameter_entries(header),
            [f"&level_{level}_formation_spawn_parameters" for level in range(6)],
        )
        self.assertIn(
            "static const LevelFormationSpawnParameters level_0_formation_spawn_parameters = {0, 65535};",
            header,
        )
        self.assertIn(
            "static const LevelFormationSpawnParameters level_5_formation_spawn_parameters = {105, 65535};",
            header,
        )

    def test_changed_values_cannot_claim_live_original(self):
        edited = copy.deepcopy(self.documents)
        edited[2]["formation_spawn_parameters"]["tile_member_hit_points"] += 1
        validate(edited[2])
        with tempfile.TemporaryDirectory() as temp:
            with self.assertRaisesRegex(ValueError, "live_original must match"):
                generate_timeline_parameter_header(Path(temp), edited, self.machine)

    def test_absent_old_section_remains_a_live_fallback(self):
        older = copy.deepcopy(self.documents)
        for document in older:
            document["version"] = 8
            document.pop("formation_spawn_parameters")
            validate(document)
        self.assertEqual(_parameter_entries(self._timeline_header(older)), ["0"] * 6)

    def test_version_eight_cannot_authoredly_supply_new_parameters(self):
        document = copy.deepcopy(self.documents[0])
        document["version"] = 8
        with self.assertRaisesRegex(ValueError, "requires version 9"):
            validate(document)

    def test_checkpoint_count_is_open_in_v9_schema_but_ds_binding_stays_four(self):
        for count in (1, 5):
            edited = copy.deepcopy(self.documents)
            edited[0]["checkpoints"] = [
                {"map_row": 12 + 10 * index, "script_clock": 0,
                 "resume_event": 0}
                for index in range(count)
            ]
            with self.subTest(count=count):
                validate(edited[0])
                if count == 5:
                    with self.assertRaisesRegex(ValueError, "requires four checkpoints"):
                        bind_level_documents(self.machine, edited)

        empty = copy.deepcopy(self.documents[0])
        empty["checkpoints"] = []
        with self.assertRaisesRegex(ValueError, "nonempty list"):
            validate(empty)

    def test_formation_names_accept_127_bytes_and_reject_long_or_nonsemantic_names(self):
        valid = copy.deepcopy(self.documents[0])
        old_name = next(iter(valid["formations"]))
        long_name = "a" * 127
        valid["formations"][long_name] = valid["formations"].pop(old_name)
        for event in valid["timeline"]:
            if event["formation"] == old_name:
                event["formation"] = long_name
        validate(valid)

        for bad_name in ("a" * 128, "Upper", "not-semantic"):
            edited = copy.deepcopy(valid)
            formation = edited["formations"].pop(long_name)
            edited["formations"][bad_name] = formation
            for event in edited["timeline"]:
                if event["formation"] == long_name:
                    event["formation"] = bad_name
            with self.subTest(name=bad_name[:16], length=len(bad_name)):
                with self.assertRaises(ValueError):
                    validate(edited)

    def test_parameter_fields_and_compatibility_are_strict(self):
        malformed = []
        for field, value in (
            ("tile_member_hit_points", True),
            ("tile_member_hit_points", -1),
            ("tile_member_hit_points", 65536),
            ("other_member_hit_points", 1.5),
            ("unknown", 1),
            ("compatibility", {"live_original": False}),
            ("compatibility", {"live_original": 1}),
            ("compatibility", {"live_original": True, "extra": 0}),
            ("compatibility", "live_original"),
        ):
            edited = copy.deepcopy(self.documents[0])
            edited["formation_spawn_parameters"][field] = value
            malformed.append((field, value, edited))

        missing = copy.deepcopy(self.documents[0])
        del missing["formation_spawn_parameters"]["other_member_hit_points"]
        malformed.append(("missing other_member_hit_points", None, missing))
        for field, value, edited in malformed:
            with self.subTest(field=field, value=value):
                with self.assertRaises(ValueError):
                    validate(edited)

    def test_preset_name_header_uses_semantic_ids_and_terminated_tables(self):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            generate_level_preset_header(output)
            header = (output / "LEVEL_PRESETS_GEN.H").read_text(encoding="utf-8")
        for table, name in (("level_enemy_presets", '"side_turret"'),
                            ("level_size_presets", '"16x16"'),
                            ("level_layer_presets", '"under_terrain"'),
                            ("level_drop_presets", '"smart_bomb"')):
            with self.subTest(table=table):
                self.assertIn(f"{table}[]", header)
                self.assertIn(name, header)
                section = header.split(f"{table}[]", 1)[1].split("};", 1)[0]
                self.assertIn("{0, 0}", section)


if __name__ == "__main__":
    unittest.main()
