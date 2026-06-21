import re, sys, os

DUMP = sys.argv[1] if len(sys.argv) > 1 else \
    "/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/hysteria_dump_all.txt"
OUT = sys.argv[2] if len(sys.argv) > 2 else \
    os.path.join(os.path.dirname(__file__), "..", "hysteria", "hysteria_sdk.h")

hdr = re.compile(r'^(\S.*?)  \((\w+)\)\s*$')
mem = re.compile(r'^  \+0x([0-9a-fA-F]+)\s+(\S+)\s+(\w+)(?:\s+mask=0x([0-9a-fA-F]+))?\s*$')

def ident(s):
    return re.sub(r'[^A-Za-z0-9_]', '_', s)

ctype = {
    'IntProperty':'int', 'FloatProperty':'float', 'ByteProperty':'unsigned char',
    'ObjectProperty':'void*', 'ClassProperty':'void*', 'ComponentProperty':'void*',
    'InterfaceProperty':'void*', 'NameProperty':'int',
}

classes = {}   # leaf -> { prop -> (off, type, mask) }
in_props = False
cur = None
with open(DUMP, 'r', errors='ignore') as f:
    for line in f:
        if line.startswith('=== PROPERTIES'):
            in_props = True; continue
        if not in_props:
            continue
        if line.startswith('=== END'):
            break
        m = hdr.match(line)
        if m:
            owner, oclass = m.group(1), m.group(2)
            cur = ident(owner.split('.')[-1]) if oclass == 'Class' else None
            if cur and cur not in classes:
                classes[cur] = {}
            continue
        if cur:
            mm = mem.match(line)
            if mm:
                off, name, typ, mask = mm.group(1), ident(mm.group(2)), mm.group(3), mm.group(4)
                if name not in classes[cur]:
                    classes[cur][name] = (int(off, 16), typ, int(mask, 16) if mask else 0)

with open(OUT, 'w') as o:
    o.write("#ifndef HYSTERIA_SDK_H\n#define HYSTERIA_SDK_H\n")
    o.write("/* generated from hysteria_dump_all.txt by tools/gen_sdk.py -- do not edit */\n\n")
    ncls = nfld = 0
    for cls in sorted(classes):
        props = classes[cls]
        if not props:
            continue
        ncls += 1
        o.write("/* %s */\n" % cls)
        for name, (off, typ, mask) in sorted(props.items(), key=lambda kv: kv[1][0]):
            nfld += 1
            pre = "%s_%s" % (cls, name)
            o.write("#define %s 0x%x\n" % (pre, off))
            if typ == 'BoolProperty':
                o.write("#define %s_mask 0x%xu\n" % (pre, mask))
                o.write("static inline int %s_get(void*o){return (*(unsigned*)((char*)o+0x%x)&0x%xu)!=0;}\n" % (pre, off, mask))
                o.write("static inline void %s_set(void*o,int v){if(v)*(unsigned*)((char*)o+0x%x)|=0x%xu;else *(unsigned*)((char*)o+0x%x)&=~0x%xu;}\n" % (pre, off, mask, off, mask))
            elif typ in ctype:
                ct = ctype[typ]
                o.write("static inline %s %s_get(void*o){return *(%s*)((char*)o+0x%x);}\n" % (ct, pre, ct, off))
                o.write("static inline void %s_set(void*o,%s v){*(%s*)((char*)o+0x%x)=v;}\n" % (pre, ct, ct, off))
        o.write("\n")
    o.write("#endif\n")
    print("SDK: %d classes, %d fields -> %s" % (ncls, nfld, os.path.abspath(OUT)))
