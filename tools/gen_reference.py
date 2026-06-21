import re, sys, os
from collections import defaultdict

DUMP = sys.argv[1] if len(sys.argv) > 1 else \
    "/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/hysteria_dump_all.txt"
OUT = sys.argv[2] if len(sys.argv) > 2 else \
    os.path.join(os.path.dirname(__file__), "..", "hysteria_reference.txt")

hdr = re.compile(r'^(\S.*?)  \((\w+)\)\s*$')
mem = re.compile(r'^  \+0x([0-9a-fA-F]+)\s+(\S+)\s+(\w+)(?:\s+mask=0x[0-9a-fA-F]+)?\s*$')

class_props = defaultdict(list)   # class -> [(prop, type)]
class_funcs = defaultdict(dict)   # class -> {func: [(param, type)]}

in_props = False
owner = None
owner_kind = None
with open(DUMP, 'r', errors='ignore') as f:
    for line in f:
        line = line.rstrip('\n')
        if line.startswith('=== PROPERTIES'): in_props = True; continue
        if not in_props: continue
        if line.startswith('=== END'): break
        m = hdr.match(line)
        if m:
            full, kind = m.group(1), m.group(2)
            parts = full.split('.')
            owner_kind = kind
            if kind == 'Class':
                owner = parts[-1]
            elif kind == 'Function' and len(parts) >= 2:
                owner = (parts[-2], parts[-1])   # (class, func)
            else:
                owner = None
            continue
        mm = mem.match(line)
        if mm and owner is not None:
            name, typ = mm.group(2), mm.group(3)
            if owner_kind == 'Class':
                class_props[owner].append((name, typ))
            else:
                cls, fn = owner
                class_funcs[cls].setdefault(fn, []).append((name, typ))

allc = sorted(set(class_props) | set(class_funcs))
nprops = sum(len(v) for v in class_props.values())
nfuncs = sum(len(v) for v in class_funcs.values())
with open(OUT, 'w') as o:
    o.write("HYSTERIA — Alice: Madness Returns API reference (generated)\n")
    o.write("%d classes, %d properties, %d functions\n" % (len(allc), nprops, nfuncs))
    o.write("everything below is reachable by name: get/set props, on(func), console/call.\n\n")
    for c in allc:
        o.write("=== %s ===\n" % c)
        props = class_props.get(c, [])
        if props:
            o.write("  properties:\n")
            for n, t in props:
                o.write("    %-40s %s\n" % (n, t))
        funcs = class_funcs.get(c, {})
        if funcs:
            o.write("  functions:\n")
            for fn in sorted(funcs):
                params = funcs[fn]
                sig = ", ".join("%s %s" % (t.replace("Property", "").lower(), n) for n, t in params)
                o.write("    %s(%s)\n" % (fn, sig))
        o.write("\n")
print("wrote %s: %d classes, %d properties, %d functions" % (os.path.abspath(OUT), len(allc), nprops, nfuncs))
