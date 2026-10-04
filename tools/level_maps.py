"""Extract original Overkill tile maps from their packed BIC resources.

The runtime's mode-4 decoder stores each decoded column at a 13-byte stride.
This module writes that resulting memory image directly: ``map.bin`` is a flat
row-major grid, including the original spawn-command tile values.
"""
from __future__ import annotations

from functools import lru_cache
from pathlib import Path
import re
import struct

from resources import resources


MAP_COLUMNS = 13
_MAP_RESOURCE = re.compile(r"(?:LEVEL|LEV)?([0-5])(?:MAP(?:\.BIC)?)?", re.IGNORECASE)


def unsupported_original_map_tiles(level: int) -> set[int]:
    """Guarded but unmodeled CS dispatch overreads in the original handlers.

    Level0/3/4/5CellCases end two words before their unsigned guard permits.
    Those adjacent words are not demonstrated spawn actions. Retain the oracle
    bytes, but reject importing these cells as authored content until understood.
    """
    return {0: {0xFA, 0xFB}, 1: set(), 2: set(), 3: {0xEA, 0xEB},
            4: {0xE1, 0xE2}, 5: {0xF0, 0xF1}}[level]


def generate_map_limit_header(out):
    masks = []
    for level in range(6):
        cells = unsupported_original_map_tiles(level)
        masks.append('{' + ', '.join(str(sum(1 << (cell & 7) for cell in cells
                                           if cell >> 3 == byte)) for byte in range(32)) + '}')
    Path(out, 'LEVEL_MAP_LIMITS_GEN.H').write_text(
        '/* Unmodeled original CS dispatch overreads; importer compatibility only. */\n'
        'static const uint8_t unsupported_map_tiles[6][32] = {' + ',\n'.join(masks) + '};\n')


def _level_index(name: str | int) -> int:
    if isinstance(name, int):
        if 0 <= name <= 5:
            return name
        raise ValueError(f"original level index must be 0..5, got {name}")
    match = _MAP_RESOURCE.fullmatch(str(name).strip())
    if not match:
        raise ValueError(f"not an original level/map name: {name!r}")
    return int(match.group(1))


def _decode_map_payload(payload: bytes, *, name: str = "map") -> tuple[bytes, int, int]:
    """Decode one original mode-4 map and validate its complete grid shape."""
    if len(payload) < 7:
        raise ValueError(f"{name}: truncated BIC mode/header")
    mode = payload[0]
    if mode != 4:
        raise ValueError(f"{name}: expected column PackBits mode 4, got {mode}")
    output_size, columns, rows = struct.unpack_from("<HHH", payload, 1)
    if columns != MAP_COLUMNS:
        raise ValueError(f"{name}: expected {MAP_COLUMNS} columns, got {columns}")
    if rows == 0 or output_size != columns * rows:
        raise ValueError(
            f"{name}: inconsistent dimensions {output_size} bytes, {columns}x{rows}"
        )

    tiles = bytearray(output_size)
    cursor = 7

    def read_byte() -> int:
        nonlocal cursor
        if cursor >= len(payload):
            raise ValueError(f"{name}: compressed data ends before a column terminator")
        value = payload[cursor]
        cursor += 1
        return value

    for column in range(columns):
        row = 0
        while True:
            control = read_byte()
            if control == 0x80:
                break
            if control < 0x80:
                count = control + 1
                if row + count > rows:
                    raise ValueError(f"{name}: column {column} exceeds declared row count")
                for _ in range(count):
                    tiles[(row * columns) + column] = read_byte()
                    row += 1
            else:
                count = 257 - control
                value = read_byte()
                if row + count > rows:
                    raise ValueError(f"{name}: column {column} exceeds declared row count")
                for _ in range(count):
                    tiles[(row * columns) + column] = value
                    row += 1
        if row != rows:
            raise ValueError(f"{name}: column {column} has {row} rows, expected {rows}")

    if cursor != len(payload):
        raise ValueError(f"{name}: {len(payload) - cursor} trailing bytes after final column")
    return bytes(tiles), columns, rows


@lru_cache(maxsize=1)
def _original_maps() -> tuple[tuple[bytes, int, int], ...]:
    archive, directory = resources()
    by_name = {row["name"].upper(): row for row in directory}
    maps = []
    for index in range(6):
        name = f"LEV{index}MAP.BIC"
        row = by_name.get(name)
        if row is None:
            raise ValueError(f"original resource directory is missing {name}")
        start = row["offset"]
        payload = archive[start:start + row["size"]]
        if len(payload) != row["size"]:
            raise ValueError(f"{name}: resource payload is truncated")
        maps.append(_decode_map_payload(payload, name=name))
    return tuple(maps)


def decode_original_map(name: str | int) -> bytes:
    """Return one original level's exact decoded 13-column tile grid.

    ``name`` accepts a level number, ``levelN``, ``levN``, or ``LEVnMAP.BIC``.
    The result is the unmodified byte grid written by the original BIC decoder.
    """
    return _original_maps()[_level_index(name)][0]


def original_map_dimensions(name: str | int) -> tuple[int, int]:
    """Return ``(columns, rows)`` for an original level map."""
    _, columns, rows = _original_maps()[_level_index(name)]
    return columns, rows


def export_original_maps(directory: str | Path) -> dict[str, dict[str, int]]:
    """Write ``level0/map.bin`` through ``level5/map.bin`` and return dimensions."""
    root = Path(directory)
    result = {}
    for index, (tiles, columns, rows) in enumerate(_original_maps()):
        target = root / f"level{index}" / "map.bin"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(tiles)
        result[f"level{index}"] = {"columns": columns, "rows": rows}
    return result
