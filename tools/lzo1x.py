def lzo1x_decompress(src):
    src = bytes(src); ip = 0; out = bytearray()
    def L(c):
        nonlocal ip
        out.extend(src[ip:ip + c]); ip += c
    def M(m, c):
        for _ in range(c):
            out.append(out[m]); m += 1

    t = 0
    label = 'start'
    while True:
        if label == 'start':
            if src[ip] > 17:
                t = src[ip] - 17; ip += 1; L(t)
                label = 'first_literal_run'
            else:
                label = 'top'
        elif label == 'top':
            t = src[ip]; ip += 1
            if t >= 16:
                label = 'match'
            else:
                if t == 0:
                    while src[ip] == 0:
                        t += 255; ip += 1
                    t += 15 + src[ip]; ip += 1
                L(t + 3)
                label = 'first_literal_run'
        elif label == 'first_literal_run':
            t = src[ip]; ip += 1
            if t >= 16:
                label = 'match'
            else:
                m = len(out) - 0x801 - (t >> 2) - (src[ip] << 2); ip += 1
                M(m, 3)
                label = 'match_done'
        elif label == 'match':
            if t >= 64:
                m = len(out) - 1 - ((t >> 2) & 7) - (src[ip] << 3); ip += 1
                cnt = (t >> 5) - 1
            elif t >= 32:
                cnt = t & 31
                if cnt == 0:
                    while src[ip] == 0:
                        cnt += 255; ip += 1
                    cnt += 31 + src[ip]; ip += 1
                m = len(out) - 1 - (src[ip] >> 2) - (src[ip + 1] << 6); ip += 2
            elif t >= 16:
                m = len(out) - ((t & 8) << 11)
                cnt = t & 7
                if cnt == 0:
                    while src[ip] == 0:
                        cnt += 255; ip += 1
                    cnt += 7 + src[ip]; ip += 1
                m -= (src[ip] >> 2) + (src[ip + 1] << 6); ip += 2
                if m == len(out):
                    break
                m -= 0x4000
            else:
                m = len(out) - 1 - (t >> 2) - (src[ip] << 2); ip += 1
                M(m, 2)
                label = 'match_done'; continue
            M(m, cnt + 2)
            label = 'match_done'
        elif label == 'match_done':
            st = src[ip - 2] & 3
            if st == 0:
                label = 'top'
            else:
                L(st)
                t = src[ip]; ip += 1
                label = 'match'
    return bytes(out)


if __name__ == '__main__':
    import sys, struct
    p = sys.argv[1]
    f = open(p, 'rb')

    def ri(): return struct.unpack('<i', f.read(4))[0]
    def ru(): return struct.unpack('<I', f.read(4))[0]
    def rs():
        x = ri()
        return f.read(x).decode('latin1').rstrip('\0') if x > 0 else ""
    ru(); ru(); ri(); rs(); ru()
    nc = ri(); no = ri(); ec = ri(); eo = ri(); ic = ri(); io = ri(); ri()
    ri(); ri(); ri(); ri(); f.read(16)
    g = ri()
    for _ in range(g): f.read(12)
    ri(); ri()
    cflags = ru(); nch = ri()
    chunks = [(ri(), ri(), ri(), ri()) for _ in range(nch)]
    uoff, usz, coff, csz = chunks[0]
    f.seek(coff)
    sig = ru(); bs = ru(); tc = ru(); tu = ru()
    nblk = (tu + bs - 1) // bs
    binfo = [(ru(), ru()) for _ in range(nblk)]
    comp = f.read(binfo[0][0])
    dec = lzo1x_decompress(comp)
    print("block0: comp=%d -> dec=%d (expected %d)" % (len(comp), len(dec), binfo[0][1]))
    print("head ascii:", ''.join(chr(b) if 32 <= b < 127 else '.' for b in dec[:64]))
