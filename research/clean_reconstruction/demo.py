"""Native DOS demonstrator execution; no original game or emulator in the EXE."""
from build import *

def demo():
    env={k:v for k,v in os.environ.items() if k.upper() in ('SYSTEMROOT','WINDIR','TEMP','TMP','COMSPEC')}
    rows=[]
    for mode in ('base','moved'):
        folder=OUT/mode
        p=subprocess.run([str(ROOT/'toolchain/nmlgcdos/msdos.exe'),str(folder/'CLEAN.EXE')],cwd=folder,env=env,capture_output=True,timeout=15)
        output=(p.stdout+p.stderr).decode('cp437');assert p.returncode==0,(mode,p.returncode,output)
        rows.append(dict(layout=mode,exit_code=p.returncode,output=output,exe_sha256=sha((folder/'CLEAN.EXE').read_bytes())))
    result=dict(status='PASS',runner='pinned nmlgc MS-DOS Player',runs=rows,scope='Standalone C init plus120 ordinary C update calls and chronological result assertions; not original-game startup or gameplay')
    write_json(RESULTS/'demo.json',result);print('PASS native DOS demonstrator in both link orders',flush=True);return result
if __name__=='__main__':demo()
