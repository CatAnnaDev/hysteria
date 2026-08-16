import json,sys,collections
d=json.load(open('dumpprops.json'))
FL={}
for line in open('funcs.tsv'):
    a=line.rstrip('\n').split('\t')
    FL[a[1]]=(a[7],int(a[5]))
P=d['classes']; F=d['funcs']
def kind(fl):
    if 'Native' in fl: return 'NATIVE'
    if 'Defined' in fl: return 'SCRIPT'
    return 'STUB'
for cls in ['AlicePawn','AlicePlayerController','AliceGameInfo','AliceInventoryManager']:
    out=open('inv_%s.txt'%cls,'w')
    full='AliceGame.'+cls
    props=sorted(P.get(full,[]),key=lambda r:r[0])
    out.write("### %s -- %d own properties (offsets from live-process dump)\n"%(cls,len(props)))
    for o,n,t,m in props:
        out.write("  +0x%-5x %-46s %-18s%s\n"%(o,n,t,(' mask=0x%x'%m) if m else ''))
    fns=[(k,v) for k,v in FL.items() if k.split('.')[0]==cls]
    out.write("\n### %s -- %d functions (path / native-script / storage bytes / flags)\n"%(cls,len(fns)))
    for k,(fl,sz) in sorted(fns):
        parts=k.split('.')
        sig=''
        for cand in ('AliceGame.'+k,):
            if cand in F:
                ps=sorted(F[cand],key=lambda r:r[0])
                sig=', '.join('%s %s@0x%x'%(t.replace('Property','').lower(),n,o) for o,n,t,m in ps)
        out.write("  %-8s %-64s %-6d %s\n        (%s)\n"%(kind(fl),k,sz,fl,sig))
    out.close()
    print('inv_%s.txt'%cls, len(props),'props',len(fns),'funcs')
