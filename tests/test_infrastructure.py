"""Acceptance infrastructure regression checks: malformed inputs, diffs and OMF."""
import unittest,sys,struct
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from common import *
from extract import extract,mz
from verify import diff_ranges,audit_source,check_hashes
from omf import segments

class InfrastructureTests(unittest.TestCase):
    def test_original_assets_and_tools_pinned(self):
        check_hashes('inputs.json');check_hashes('toolchain-lock.json')
    def test_extraction_pinned_and_relocation_bounds(self):
        for name,manifest in [('OVERKILL','oracle.json'),('OVERKILL.EXE','launcher-extraction.json')]:
            image,m=extract(name);self.assertEqual(m,read_json(ROOT/'metadata'/manifest))
            self.assertEqual(len(m['stages']),4);self.assertEqual(len(m['relocations']),len(set(m['relocations'])))
            self.assertTrue(all(0<=p<len(image)-1 for p in m['relocations']))
    def test_mz_rejects_truncation_and_separates_appended_bytes(self):
        raw=(ROOT/'assets/OVERKILL').read_bytes();h,image,_,overlay=mz(raw)
        self.assertEqual(h['executable_bytes'],50555);self.assertEqual(len(overlay),467649)
        self.assertEqual(raw[h['header_bytes']:h['executable_bytes']],image)
        for bad in (b'',raw[:100],b'ZZ'+raw[2:]):
            with self.assertRaises((ValueError,struct.error)):mz(bad)
    def test_changed_and_missing_bytes_reported(self):
        self.assertEqual(diff_ranges(b'abcde',b'abXYe'),[dict(start=2,end=4,expected_hex='6364',actual_hex='5859')])
        self.assertEqual(diff_ranges(b'ab',b'a')[0]['start'],1)
        self.assertEqual(diff_ranges(b'a',b'ab')[0]['end'],2)
        self.assertEqual(diff_ranges(b'ab',b'ab'),[])
    def test_all_bytes_have_exclusive_source_owners(self):
        counts=audit_source();self.assertEqual(sum(counts.values()),143088)
        self.assertGreater(counts['opaque_unknown'],0)
    def test_real_omf_checksum_corruption_fails(self):
        p=ROOT/'build/asm/R00.OBJ'
        if not p.exists():self.skipTest('Run a fresh assembly first')
        raw=bytearray(p.read_bytes());self.assertTrue(segments(bytes(raw)));raw[-1]^=1
        with self.assertRaises(ValueError):segments(bytes(raw))
    def test_source_independent_build_equals_fresh_extraction(self):
        p=ROOT/'build/program.bin'
        if not p.exists():self.skipTest('Run a fresh assembly first')
        self.assertEqual(p.read_bytes(),extract()[0])

if __name__=='__main__':unittest.main()
