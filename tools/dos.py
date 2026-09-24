"""Pinned DOS tool invocation with a bounded DOS environment."""
from common import *
import os,subprocess

def dos(tool,args,cwd,timeout=120):
    runner=ROOT/'toolchain'/('msdos-i86' if tool.upper()=='TLINK.EXE' else 'nmlgcdos')/'msdos.exe'
    env={k:v for k,v in os.environ.items() if k.upper() in ('SYSTEMROOT','WINDIR','TEMP','TMP','COMSPEC')}
    p=subprocess.run([str(runner),str(ROOT/'toolchain'/tool),*args],cwd=cwd,env=env,capture_output=True,timeout=timeout)
    text=(p.stdout+p.stderr).decode('cp437',errors='replace').replace('\r','')
    if p.returncode or '**Error**' in text or '**Fatal**' in text:raise RuntimeError(text)
    return text
