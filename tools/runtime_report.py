"""Query the active main/driver CFG without conflating address identities."""
from common import *
import argparse

def query(module,address):
    if module=='main':functions=read_json(ROOT/'metadata/runtime/functions.json')
    else:
        functions=read_json(ROOT/'metadata/drivers'/f'{module}-analysis.json')['functions']
        named={s['address']:s for s in read_json(ROOT/'metadata/drivers/symbols.json')['symbols'] if s['module']==module}
        for f in functions:
            if f['address'] in named:f.update(named[f['address']]);f['named']=True
    names={f['address']:f['name'] for f in functions}
    for f in functions:
        f['resolved_relations']={key:[dict(address=a,name=names.get(a,a)) for a in f[key]] for key in ('callers','callees','tail_targets')}
    return [f for f in functions if address.lower() in (f['address']+' '+f['name']).lower()]
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('module',choices=['main','adlib','roland']);p.add_argument('address');a=p.parse_args();print(json.dumps(query(a.module,a.address),indent=2))
