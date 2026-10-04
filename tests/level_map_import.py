"""Decoded original-map export checks against the packed-resource reference."""
from __future__ import annotations

from pathlib import Path
import struct
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.append(str(ROOT / "tests"))

from level_maps import (  # noqa: E402
    _decode_map_payload,
    decode_original_map,
    export_original_maps,
    original_map_dimensions,
)
from resources import resources  # noqa: E402
from resource_codecs import _packed_reference  # noqa: E402


def _reference_grid(payload: bytes) -> tuple[bytes, tuple[int, int]]:
    mode, writes, consumed = _packed_reference(payload)
    if mode != 4 or consumed != len(payload):
        raise AssertionError("original map must be a fully consumed mode-4 BIC resource")
    size, columns, rows = struct.unpack_from("<HHH", payload, 1)
    if size != columns * rows:
        raise AssertionError("reference map header has inconsistent dimensions")
    grid = bytearray(size)
    seen = set()
    for offset, value in writes:
        if offset >= size or offset in seen:
            raise AssertionError("reference decoder produced an invalid or repeated map cell")
        seen.add(offset)
        grid[offset] = value
    if len(seen) != size:
        raise AssertionError("reference decoder did not produce every map cell")
    return bytes(grid), (columns, rows)


class OriginalMapTests(unittest.TestCase):
    def test_all_original_grids_match_packed_reference(self):
        archive, directory = resources()
        by_name = {row["name"].upper(): row for row in directory}
        self.assertEqual(len([n for n in by_name if n.endswith("MAP.BIC")]), 6)
        for level in range(6):
            with self.subTest(level=level):
                name = f"LEV{level}MAP.BIC"
                row = by_name[name]
                payload = archive[row["offset"]:row["offset"] + row["size"]]
                expected, dimensions = _reference_grid(payload)
                self.assertEqual(decode_original_map(level), expected)
                self.assertEqual(decode_original_map(f"level{level}"), expected)
                self.assertEqual(decode_original_map(name), expected)
                self.assertEqual(original_map_dimensions(level), dimensions)
                self.assertEqual(dimensions[0], 13)

    def test_export_layout_and_dimensions(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            dimensions = export_original_maps(root)
            self.assertEqual(set(dimensions), {f"level{i}" for i in range(6)})
            for level in range(6):
                with self.subTest(level=level):
                    name = f"level{level}"
                    columns, rows = original_map_dimensions(level)
                    self.assertEqual(dimensions[name], {"columns": columns, "rows": rows})
                    exported = (root / name / "map.bin").read_bytes()
                    self.assertEqual(exported, decode_original_map(level))
                    self.assertEqual(len(exported), columns * rows)

    def test_names_and_malformed_maps_are_rejected(self):
        with self.assertRaises(ValueError):
            decode_original_map("level6")
        with self.assertRaises(ValueError):
            decode_original_map("level2.extra")

        def fixture(size=26, columns=13, rows=2, body=None, mode=4):
            if body is None:
                body = b"".join(bytes((0xFF, 0x40 + col, 0x80)) for col in range(13))
            return bytes((mode,)) + struct.pack("<HHH", size, columns, rows) + body

        valid = fixture()
        grid, columns, rows = _decode_map_payload(valid)
        self.assertEqual((columns, rows, len(grid)), (13, 2, 26))
        self.assertEqual(grid[0], 0x40)
        self.assertEqual(grid[13], 0x40)

        malformed = (
            (b"", "truncated"),
            (fixture(mode=3), "mode"),
            (fixture(columns=12), "columns"),
            (fixture(size=25), "dimensions"),
            (fixture(body=b"\x00\x41" + b"\x80" * 13), "has 1 rows"),
            (fixture(body=b"\xfe\x41" + b"\x80" * 13), "exceeds"),
            (valid[:-1], "terminator"),
            (valid + b"\0", "trailing bytes"),
        )
        for payload, message in malformed:
            with self.subTest(message=message, payload=payload[:8]):
                with self.assertRaisesRegex(ValueError, message):
                    _decode_map_payload(payload, name="fixture")


if __name__ == "__main__":
    unittest.main()
