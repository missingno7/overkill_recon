"""Reproduce the bounded research sample. No production build integration."""
import argparse
from build import compile_all
from shapes import variants
from verify_clean import verify

def main():
 p=argparse.ArgumentParser();p.add_argument('--clean-only',action='store_true');a=p.parse_args()
 compile_all();manifest=variants();verify(manifest)
 if a.clean_only:
  print('PASS: clean C works without reading matching recipes, generated ASM or ABI-specialized bodies.')
  return
 from delta import generate
 from firewall import test
 from check_shims import check as shims
 from check_matching import check as matching
 from summarize import summarize
 generate();test();shims();matching();summarize()
if __name__=='__main__':main()
