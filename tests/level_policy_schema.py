"""Schema and generated-binding tests for restart and music policies."""
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
from level_format import load, original_paths, validate  # noqa: E402
from level_policies import (  # noqa: E402
    generate_level_policy_header,
    original_checkpoint_restart,
    original_music,
    validate_level_policies,
)


def _without_live_marker(policy):
    result = copy.deepcopy(policy)
    result.pop("compatibility", None)
    return result


def _array_entries(header: str, name: str) -> list[str]:
    match = re.search(
        rf"static const [^\n]+\b{name}\[\] = \{{([^}}]*)\}};", header
    )
    if match is None:
        raise AssertionError(f"generated header has no {name} array")
    return [entry.strip() for entry in match.group(1).split(",")]


class LevelPolicySchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Reuse the already-built exact oracle; these are data/schema checks, not
        # a request to build or run the DOS game.
        cls.machine = exact_oracle(True)
        cls.documents = [load(path) for path in original_paths()]

    def _header(self, documents):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            generate_level_policy_header(output, documents, self.machine)
            return (output / "LEVEL_POLICIES_GEN.H").read_text(encoding="utf-8")

    def test_canonical_live_policies_generate_null_bindings_for_all_levels(self):
        header = self._header(self.documents)
        self.assertEqual(_array_entries(header, "level_restart_policies"), ["0"] * 6)
        self.assertEqual(_array_entries(header, "level_music_policies"), ["0"] * 6)
        for level, document in enumerate(self.documents):
            with self.subTest(level=level):
                self.assertEqual(
                    document["checkpoint_restart"],
                    original_checkpoint_restart(self.machine, level),
                )
                self.assertEqual(document["music"], original_music(self.machine, level))

    def test_explicit_original_values_generate_independent_nonnull_bindings(self):
        authored = copy.deepcopy(self.documents)
        for document in authored:
            document["checkpoint_restart"] = _without_live_marker(
                document["checkpoint_restart"]
            )
            document["music"] = _without_live_marker(document["music"])
            validate(document)

        header = self._header(authored)
        self.assertEqual(
            _array_entries(header, "level_restart_policies"),
            [f"&level_{level}_restart" for level in range(6)],
        )
        self.assertEqual(
            _array_entries(header, "level_music_policies"),
            [f"&level_{level}_music" for level in range(6)],
        )
        for level, document in enumerate(authored):
            with self.subTest(level=level):
                self.assertEqual(
                    document["checkpoint_restart"],
                    _without_live_marker(original_checkpoint_restart(self.machine, level)),
                )
                self.assertEqual(
                    document["music"],
                    _without_live_marker(original_music(self.machine, level)),
                )

    def test_changed_policy_cannot_claim_live_original_compatibility(self):
        for name in ("checkpoint_restart", "music"):
            changed = copy.deepcopy(self.documents)
            policy = changed[0][name]
            if name == "music":
                policy["level"] = policy["level"] % 10 + 1
            else:
                policy["lookback_rows"] += 1
            # It remains structurally valid, but its compatibility claim is false.
            validate(changed[0])
            with self.subTest(policy=name), tempfile.TemporaryDirectory() as temp:
                with self.assertRaisesRegex(ValueError, "live_original must match"):
                    generate_level_policy_header(Path(temp), changed, self.machine)

    def test_absent_policy_sections_fall_back_to_original_runtime_lookup(self):
        without_sections = copy.deepcopy(self.documents)
        for document in without_sections:
            document.pop("checkpoint_restart")
            document.pop("music")
            validate(document)
        header = self._header(without_sections)
        self.assertEqual(_array_entries(header, "level_restart_policies"), ["0"] * 6)
        self.assertEqual(_array_entries(header, "level_music_policies"), ["0"] * 6)

    def test_malformed_and_unknown_policy_fields_are_rejected(self):
        invalid = []
        for field, value in (
            ("lookback_rows", True),
            ("lookback_rows", 65536),
            ("unknown", 1),
            ("compatibility", {"live_original": 1}),
            ("compatibility", {"live_original": False}),
            ("compatibility", {"live_original": True, "extra": 0}),
        ):
            document = copy.deepcopy(self.documents[0])
            document["checkpoint_restart"][field] = value
            invalid.append(("checkpoint_restart", field, document))

        for field, value in (
            ("level", True),
            ("level", 256),
            ("unknown", 1),
            ("compatibility", {"live_original": "true"}),
            ("compatibility", {"live_original": True, "extra": 0}),
        ):
            document = copy.deepcopy(self.documents[0])
            document["music"][field] = value
            invalid.append(("music", field, document))

        for rule_field, value in (("tile", True), ("tile", 256),
                                  ("replacement", False), ("replacement", 256),
                                  ("unknown", 1)):
            document = copy.deepcopy(self.documents[0])
            document["checkpoint_restart"]["tile_restorations"][0][rule_field] = value
            invalid.append(("checkpoint_restart", rule_field, document))

        for name, field, document in invalid:
            with self.subTest(policy=name, field=field, value=document[name].get(field)):
                with self.assertRaises(ValueError):
                    validate(document)

    def test_policy_sections_require_version_seven(self):
        for name in ("checkpoint_restart", "music"):
            document = copy.deepcopy(self.documents[0])
            document["version"] = 6
            with self.subTest(policy=name), self.assertRaisesRegex(ValueError, "requires version 7"):
                validate_level_policies({
                    "version": 6,
                    name: document[name],
                })


if __name__ == "__main__":
    unittest.main()
