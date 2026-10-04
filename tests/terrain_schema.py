"""Terrain authoring stays semantic and cannot encode FF into a legacy stream."""
import copy
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from level_content import duplicate_original, validate_directory
from level_format import load, validate, encode_attribute_patches


class TerrainSchemaTests(unittest.TestCase):
    def test_latest_duplicate_owns_terrain_and_all_byte_tiles(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary) / 'terrain'
            document = duplicate_original(4, directory, 'terrain_schema')
            self.assertEqual(document['version'], 13)
            document['terrain']['attribute_patches'].append({'tile': 255, 'attribute': 'open'})
            validate(document)
            with self.assertRaisesRegex(ValueError, 'loose terrain loading'):
                encode_attribute_patches(document['terrain'])
            older = copy.deepcopy(document)
            older['version'] = 12
            with self.assertRaisesRegex(ValueError, 'patch tile'):
                validate(older)
            validate_directory(directory)

    def test_legacy_encoder_and_default_remain_exact(self):
        document = load(ROOT / 'levels/original/level1.lvl')
        patches = document['terrain']['attribute_patches']
        payload = encode_attribute_patches(document['terrain'])
        self.assertEqual(len(payload), 2 * len(patches) + 1)
        self.assertEqual(payload[-1], 255)
        document['terrain']['default'] = 'open'
        with self.assertRaisesRegex(ValueError, 'initializes terrain attributes to wall'):
            validate(document)


if __name__ == '__main__':
    unittest.main()
