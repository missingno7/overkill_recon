"""Literal recipe-deletion test with an atomic, reversible workspace-local move."""
import subprocess,sys
from build import *

def check():
 source=(HERE/'matching').resolve();hidden=(OUT/'recipes_absent_for_test').resolve()
 assert source.is_relative_to(HERE.resolve()) and hidden.is_relative_to(OUT.resolve())
 assert source.is_dir() and not hidden.exists()
 before={p.name:sha(p.read_bytes()) for p in source.iterdir() if p.is_file()}
 source.rename(hidden)
 try:
  assert not source.exists()
  p=subprocess.run([sys.executable,str(HERE/'run.py'),'--clean-only'],cwd=ROOT,capture_output=True,text=True,timeout=180)
  (OUT/'deletion-test.log').write_text(p.stdout+p.stderr)
  if p.returncode:raise RuntimeError(p.stdout+p.stderr)
 finally:
  hidden.rename(source)
 after={p.name:sha(p.read_bytes()) for p in source.iterdir() if p.is_file()};assert before==after
 write_json(HERE/'results/deletion.json',dict(status='PASS',method='matching directory physically absent while fresh compiler builds and clean-C tests ran; restored byte-for-byte in finally',cases=sum(sum(v.values()) for v in read_json(HERE/'results/semantics.json')['counts'].values()),recipes_before=before,recipes_after=after,generated_matching_bodies_read=False))
 print('PASS: clean C compiles and runs with matching recipes physically absent')
if __name__=='__main__':check()
