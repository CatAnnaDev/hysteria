import struct, sys

def rva_to_off(sections, rva):
    for va, vs, raw_ptr, raw_sz in sections:
        if va <= rva < va + max(vs, raw_sz):
            return raw_ptr + (rva - va)
    return None

def load(path):
    data = open(path, 'rb').read()
    e_lfanew = struct.unpack_from('<I', data, 0x3C)[0]
    assert data[e_lfanew:e_lfanew+4] == b'PE\0\0'
    coff = e_lfanew + 4
    num_sections = struct.unpack_from('<H', data, coff+2)[0]
    opt_sz = struct.unpack_from('<H', data, coff+16)[0]
    opt = coff + 20
    magic = struct.unpack_from('<H', data, opt)[0]
    pe32plus = (magic == 0x20b)
    nrva_off = opt + (108 if pe32plus else 92)
    num_rva = struct.unpack_from('<I', data, nrva_off)[0]
    dd_off = nrva_off + 4
    dirs = []
    for i in range(num_rva):
        va, sz = struct.unpack_from('<II', data, dd_off + i*8)
        dirs.append((va, sz))
    sec_off = opt + opt_sz
    sections = []
    for i in range(num_sections):
        base = sec_off + i*40
        vs, va, raw_sz, raw_ptr = struct.unpack_from('<IIII', data, base+8)
        sections.append((va, vs, raw_ptr, raw_sz))
    return data, sections, dirs

def read_cstr(data, off):
    end = data.index(b'\0', off)
    return data[off:end].decode('latin1')

def exports(path):
    data, sections, dirs = load(path)
    va, sz = dirs[0]
    if va == 0:
        return []
    off = rva_to_off(sections, va)
    nfuncs, nnames = struct.unpack_from('<II', data, off+20)
    addr_names = struct.unpack_from('<I', data, off+32)[0]
    names_off = rva_to_off(sections, addr_names)
    out = []
    for i in range(nnames):
        nrva = struct.unpack_from('<I', data, names_off + i*4)[0]
        out.append(read_cstr(data, rva_to_off(sections, nrva)))
    return out

def imports_from(path, dllfilter=None):
    data, sections, dirs = load(path)
    va, sz = dirs[1]
    if va == 0:
        return {}
    off = rva_to_off(sections, va)
    result = {}
    i = 0
    while True:
        base = off + i*20
        oft, tstamp, fwd, name_rva, ft = struct.unpack_from('<IIIII', data, base)
        if name_rva == 0 and oft == 0 and ft == 0:
            break
        dllname = read_cstr(data, rva_to_off(sections, name_rva))
        thunk_rva = oft if oft else ft
        toff = rva_to_off(sections, thunk_rva)
        funcs = []
        j = 0
        while True:
            entry = struct.unpack_from('<I', data, toff + j*4)[0]
            if entry == 0:
                break
            if entry & 0x80000000:
                funcs.append(('ordinal', entry & 0xFFFF))
            else:
                nameoff = rva_to_off(sections, entry)
                hint = struct.unpack_from('<H', data, nameoff)[0]
                fname = read_cstr(data, nameoff+2)
                funcs.append((fname, hint))
            j += 1
        result[dllname] = funcs
        i += 1
    if dllfilter:
        return {k: v for k, v in result.items() if dllfilter.lower() in k.lower()}
    return result

if __name__ == '__main__':
    mode = sys.argv[1]
    path = sys.argv[2]
    if mode == 'exports':
        for n in exports(path):
            print(n)
    elif mode == 'imports':
        flt = sys.argv[3] if len(sys.argv) > 3 else None
        for dll, funcs in imports_from(path, flt).items():
            print(f'== {dll} ==')
            for f in funcs:
                print('  ', f)

def iat_info(path, dllfilter):
    data, sections, dirs = load(path)
    import_off = rva_to_off(sections, dirs[1][0])
    # image base
    e_lfanew = struct.unpack_from('<I', data, 0x3C)[0]
    coff = e_lfanew + 4
    opt = coff + 20
    magic = struct.unpack_from('<H', data, opt)[0]
    pe32plus = (magic == 0x20b)
    image_base = struct.unpack_from('<Q' if pe32plus else '<I', data, opt + (24 if pe32plus else 28))[0]
    i = 0
    while True:
        base = import_off + i*20
        oft, t, f, name_rva, ft = struct.unpack_from('<IIIII', data, base)
        if name_rva == 0 and oft == 0 and ft == 0:
            break
        dllname = read_cstr(data, rva_to_off(sections, name_rva))
        if dllfilter.lower() in dllname.lower():
            print(f'dll={dllname} image_base=0x{image_base:x} FirstThunk_rva=0x{ft:x}')
            thunk_rva = oft if oft else ft
            toff = rva_to_off(sections, thunk_rva)
            j = 0
            while True:
                entry = struct.unpack_from('<I', data, toff + j*4)[0]
                if entry == 0: break
                iat_va = image_base + ft + j*4
                kind = ('ordinal %d' % (entry & 0xFFFF)) if (entry & 0x80000000) else 'name'
                print(f'  slot[{j}] IAT_VA=0x{iat_va:x}  -> {kind}')
                j += 1
        i += 1

def export_addrs(path):
    data, sections, dirs = load(path)
    va, sz = dirs[0]
    off = rva_to_off(sections, va)
    base_ord = struct.unpack_from('<I', data, off+16)[0]
    nfuncs = struct.unpack_from('<I', data, off+20)[0]
    addr_funcs_rva = struct.unpack_from('<I', data, off+28)[0]
    foff = rva_to_off(sections, addr_funcs_rva)
    res = []
    for i in range(nfuncs):
        frva = struct.unpack_from('<I', data, foff + i*4)[0]
        res.append((base_ord + i, frva))
    return res
