import struct, sys, os
from lzo1x import lzo1x_decompress

def ri(b, o): return struct.unpack_from('<i', b, o)[0]
def ru(b, o): return struct.unpack_from('<I', b, o)[0]

def decompress_package(path):
    raw = open(path, 'rb').read()
    if ru(raw, 0) != 0x9E2A83C1:
        raise ValueError("not a UE3 package")
    f = open(path, 'rb')
    rd_i = lambda: struct.unpack('<i', f.read(4))[0]
    rd_u = lambda: struct.unpack('<I', f.read(4))[0]
    def rd_s():
        n = rd_i(); return f.read(n).decode('latin1').rstrip('\0') if n > 0 else ""
    rd_u(); rd_u(); rd_i(); rd_s(); flags = rd_u()
    rd_i(); rd_i(); rd_i(); rd_i(); rd_i(); rd_i(); rd_i()   # name/export/import counts+offs, depends
    rd_i(); rd_i(); rd_i(); rd_i(); f.read(16)               # guids offsets, thumb, guid
    g = rd_i()
    for _ in range(g): f.read(12)
    rd_i(); rd_i()                                           # engine, cooker
    cflags = rd_u(); nch = rd_i()
    if cflags == 0 or nch == 0:
        return raw
    chunks = [(rd_i(), rd_i(), rd_i(), rd_i()) for _ in range(nch)]
    total = max(uo + us for uo, us, co, cs in chunks)
    buf = bytearray(total)
    buf[0:chunks[0][0]] = raw[0:chunks[0][0]]
    for uoff, usz, coff, csz in chunks:
        sig, bs, tc, tu = struct.unpack_from('<IIII', raw, coff)
        p = coff + 16
        nblk = (tu + bs - 1) // bs
        binfo = [struct.unpack_from('<II', raw, p + i * 8) for i in range(nblk)]
        p += nblk * 8
        pos = uoff
        for cs2, us2 in binfo:
            if cs2 == us2:
                buf[pos:pos + us2] = raw[p:p + cs2]
            else:
                dec = lzo1x_decompress(raw[p:p + cs2]); buf[pos:pos + len(dec)] = dec
            p += cs2; pos += us2
    return bytes(buf)

class Pkg:
    def __init__(self, path):
        self.path = path
        self.b = decompress_package(path)
        b = self.b
        self.filever = struct.unpack_from('<H', b, 4)[0]
        self.flags = ru(b, 0)
        o = 0x0c
        flen = ri(b, o); o += 4 + (flen if flen > 0 else 0)
        o += 4                                  # package flags
        self.name_count = ri(b, o); self.name_off = ri(b, o + 4)
        self.export_count = ri(b, o + 8); self.export_off = ri(b, o + 12)
        self.import_count = ri(b, o + 16); self.import_off = ri(b, o + 20)
        self.names = []; self.imports = []; self.exports = []

    def _fstr(self, o):
        n = ri(self.b, o)
        if n == 0: return "", o + 4
        if n < 0:
            return self.b[o+4:o+4-n*2].decode('utf-16le','replace').rstrip('\0'), o+4-n*2
        return self.b[o+4:o+4+n].decode('latin1','replace').rstrip('\0'), o+4+n

    def read_names(self):
        o = self.name_off
        for _ in range(self.name_count):
            s, o = self._fstr(o); o += 8           # name + uint64 flags
            self.names.append(s)

    def nm(self, i): return self.names[i] if 0 <= i < len(self.names) else "?%d" % i

    def _fname(self, o):
        idx = ri(self.b, o); num = ri(self.b, o + 4)
        return self.nm(idx) + ("_%d" % (num-1) if num > 0 else ""), o + 8

    def read_imports(self):
        o = self.import_off
        for _ in range(self.import_count):
            _, o = self._fname(o); cls, o = self._fname(o); o += 4; name, o = self._fname(o)
            self.imports.append(name)

    def class_of(self, ci):
        if ci == 0: return "Class"
        if ci < 0:
            i = -ci - 1; return self.imports[i] if 0 <= i < len(self.imports) else "?imp"
        i = ci - 1; return self.exports[i]['name'] if 0 <= i < len(self.exports) else "?exp"

    def read_exports(self):
        o = self.export_off
        for _ in range(self.export_count):
            ci = ri(self.b, o); o += 12                         # class, super, outer
            name, o = self._fname(o)
            o += 4 + 8                                          # archetype + objflags(uint64)
            ssize = ri(self.b, o); soff = ri(self.b, o + 4); o += 8
            o += 4                                              # export flags
            nc = ri(self.b, o); o += 4 + nc * 4                 # netobjects
            o += 16 + 4                                         # guid + package flags
            self.exports.append({'ci': ci, 'name': name, 'size': ssize, 'off': soff})

    def read_props(self, o):
        props = {}
        while True:
            name, o = self._fname(o)
            if name == "None": break
            typ, o = self._fname(o)
            size = ri(self.b, o); idx = ri(self.b, o + 4); o += 8
            if typ == "ByteProperty":
                enum, o = self._fname(o)
                if size == 8:
                    val, o = self._fname(o); props[name] = val
                else:
                    props[name] = self.b[o]; o += size
            elif typ == "IntProperty":
                props[name] = ri(self.b, o); o += 4
            elif typ == "FloatProperty":
                props[name] = struct.unpack_from('<f', self.b, o)[0]; o += 4
            elif typ == "BoolProperty":
                props[name] = self.b[o]; o += 1
            elif typ == "StructProperty":
                _, o = self._fname(o); o += size
            elif typ == "NameProperty":
                val, o = self._fname(o); props[name] = val
            else:
                o += size
        return props, o

if __name__ == '__main__':
    p = Pkg(sys.argv[1])
    p.read_names(); p.read_imports(); p.read_exports()
    print("%s  ver=%d names=%d imports=%d exports=%d  (decompressed %d bytes)" % (
        os.path.basename(p.path), p.filever, p.name_count, p.import_count, p.export_count, len(p.b)))
    classes = {}
    for e in p.exports:
        classes[p.class_of(e['ci'])] = classes.get(p.class_of(e['ci']), 0) + 1
    print("--- classes ---")
    for c, n in sorted(classes.items(), key=lambda kv: -kv[1]):
        print("  %4d  %s" % (n, c))
    filt = sys.argv[2] if len(sys.argv) > 2 else None
    print("--- exports%s ---" % ((" matching '%s'" % filt) if filt else " (first 30)"))
    shown = 0
    for e in p.exports:
        c = p.class_of(e['ci'])
        if filt and filt.lower() not in c.lower() and filt.lower() not in e['name'].lower(): continue
        print("  %-22s %-44s %9d @ %d" % (c, e['name'], e['size'], e['off']))
        shown += 1
        if not filt and shown >= 30: break
