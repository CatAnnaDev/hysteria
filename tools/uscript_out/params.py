import re,sys,json
D="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/hysteria_dump_all.txt"
hdr=re.compile(r'^(\S.*?)  \((\w+)\)\s*$')
mem=re.compile(r'^  \+0x([0-9a-fA-F]+)\s+(\S+)\s+(\w+)(?:\s+mask=0x([0-9a-fA-F]+))?\s*$')
funcs={}; classes={}
inp=False; owner=None; kind=None
for line in open(D,errors='ignore'):
    line=line.rstrip('\n')
    if line.startswith('=== PROPERTIES'): inp=True; continue
    if not inp: continue
    if line.startswith('=== END'): break
    m=hdr.match(line)
    if m:
        owner,kind=m.group(1),m.group(2); continue
    mm=mem.match(line)
    if mm and owner:
        rec=(int(mm.group(1),16),mm.group(2),mm.group(3),int(mm.group(4),16) if mm.group(4) else 0)
        if kind=='Function': funcs.setdefault(owner,[]).append(rec)
        elif kind=='Class': classes.setdefault(owner,[]).append(rec)
json.dump({'funcs':funcs,'classes':classes},open('dumpprops.json','w'))
print(len(funcs),'functions',len(classes),'classes')
