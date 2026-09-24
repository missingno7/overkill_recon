"""Targeted runtime probes only; no scenario may continue past gameplay entry."""
from common import *
import argparse,subprocess,concurrent.futures

def run(matrix=False,gameplay_entry=False,workers=3):
    profiles=[('tandy','adlib')]
    if matrix:profiles=[('cga','pc'),('ega','pc'),('tandy','pc'),('tandy','adlib'),('tandy','roland'),('cga','adlib'),('ega','adlib')]
    jobs=[(v,s,ROOT/'build/runtime-matrix'/f'{v}-{s}',9000000,'9690',None) for v,s in profiles]
    if gameplay_entry:jobs.append(('tandy','adlib',ROOT/'build/runtime-probe/gameplay-entry',45000000,'97b2',ROOT/'tests/scenarios/reach-gameplay.json'))
    def execute(job):
        video,sound,out,steps,stop,keys=job;out.mkdir(parents=True,exist_ok=True)
        cmd=[sys.executable,'-u',str(ROOT/'tools/runtime_machine.py'),'--video',video,'--sound',sound,'--out',str(out),'--steps',str(steps),'--stop',stop]
        if keys:cmd+=['--keys',str(keys)]
        with (out/'run.log').open('w') as log:subprocess.run(cmd,cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,check=True)
        state=read_json(out/'state.json')
        if state['reason']!='REQUESTED_FRONTIER':raise AssertionError(f'{out.name}: {state["reason"]}; inspect run.log')
        print(out.name,state['sequence'],state['reason'],flush=True);return out
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as pool:return list(pool.map(execute,jobs))
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--matrix',action='store_true');p.add_argument('--gameplay-entry',action='store_true');p.add_argument('--workers',type=int,default=3);a=p.parse_args();run(a.matrix,a.gameplay_entry,a.workers)
