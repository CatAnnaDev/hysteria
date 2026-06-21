import sys, struct, shutil, os, glob

ALL_ABILITIES = ["Float","DoubleJump","Shrink","Sonar","Combat","Lockon",
                 "VorpalBlade","Dodge","PepperGrinder","Aiming"]

ROOTS = [
    os.path.expanduser("~/Documents/My Games"),
    os.path.expanduser("~/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Documents/My Games"),
]

def discover():
    seen = {}
    profiles = []
    for root in ROOTS:
        for psd in glob.glob(os.path.join(root, "*", "AliceGame", "CheckPoint", "*", "PersistentData_PC.PSD")):
            real = os.path.realpath(psd)
            if real in seen:
                continue
            seen[real] = True
            parts = psd.split(os.sep)
            game = parts[-5]
            profile = parts[-2]
            profiles.append({"game": game, "profile": profile, "psd": psd})
    return profiles

def fstr(s):
    b = s.encode('latin1') + b'\x00'
    return struct.pack('<i', len(b)) + b

def read_fstr(data, i):
    ln = struct.unpack_from('<i', data, i)[0]
    if not (1 <= ln <= 128) or i+4+ln > len(data):
        return None, i
    s = data[i+4:i+4+ln]
    if s[-1:] != b'\x00' or not all(32 <= c < 127 for c in s[:-1]):
        return None, i
    return s[:-1].decode('latin1'), i+4+ln

def find_abilities(data):
    p = data.find(fstr("Float"))
    if p < 4:
        return None
    start = p - 4
    count = struct.unpack_from('<i', data, start)[0]
    if not (0 < count <= 32):
        return None
    i, names = p, []
    for _ in range(count):
        s, i = read_fstr(data, i)
        if s is None:
            break
        names.append(s)
    return {"start": start, "count": count, "names": names, "end": i}

def ability_status(psd):
    data = bytearray(open(psd, 'rb').read())
    ab = find_abilities(data)
    if not ab:
        return "abilities array not found"
    miss = [a for a in ALL_ABILITIES if a not in ab["names"]]
    return "%d/%d abilities" % (ab["count"], len(ALL_ABILITIES)) + ("" if not miss else "  (missing: %s)" % ", ".join(miss))

def cmd_list():
    profs = discover()
    if not profs:
        print("no Alice save profiles found")
        return
    for p in profs:
        print("[%s] %-10s  %s" % (p["game"][:24], p["profile"], ability_status(p["psd"])))

def unlock_file(psd):
    data = bytearray(open(psd, 'rb').read())
    ab = find_abilities(data)
    if not ab:
        print("  abilities array not found, skip"); return
    newnames = list(ab["names"]) + [a for a in ALL_ABILITIES if a not in ab["names"]]
    if len(newnames) == ab["count"]:
        print("  already complete"); return
    block = struct.pack('<i', len(newnames)) + b''.join(fstr(s) for s in newnames)
    out = data[:ab["start"]] + block + data[ab["end"]:]
    bak = psd + ".bak"
    if not os.path.exists(bak):
        shutil.copy(psd, bak)
    open(psd, 'wb').write(out)
    print("  unlocked all (%d->%d bytes, backup kept)" % (len(data), len(out)))

def cmd_unlock(filt):
    profs = discover()
    hit = [p for p in profs if filt is None or filt.lower() in p["profile"].lower()]
    if not hit:
        print("no matching profile"); return
    for p in hit:
        print("[%s] %s" % (p["game"][:24], p["profile"]))
        unlock_file(p["psd"])

SAVE_FILES = ["PersistentData_PC.PSD", "Alice2Checkpoint.sav", "GameConfig_PC.CFG"]

def cmd_clone(src, dst):
    profs = discover()
    s = next((p for p in profs if src.lower() in p["profile"].lower()), None)
    d = next((p for p in profs if dst.lower() in p["profile"].lower()), None)
    if not s or not d:
        print("source or dest profile not found (have: %s)" % ", ".join(p["profile"] for p in profs)); return
    if s["profile"] == d["profile"]:
        print("source and dest are the same"); return
    sdir = os.path.dirname(s["psd"]); ddir = os.path.dirname(d["psd"])
    print("clone [%s] -> [%s]" % (s["profile"], d["profile"]))
    for f in SAVE_FILES:
        sf = os.path.join(sdir, f); df = os.path.join(ddir, f)
        if not os.path.exists(sf):
            print("  skip %s (missing in source)" % f); continue
        if os.path.exists(df) and not os.path.exists(df + ".bak"):
            shutil.copy(df, df + ".bak")
        shutil.copy(sf, df)
        print("  copied %s (%d bytes)" % (f, os.path.getsize(df)))
    print("done (dest backed up to *.bak)")

if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else "list"
    if cmd == "list":
        cmd_list()
    elif cmd == "unlock":
        cmd_unlock(sys.argv[2] if len(sys.argv) > 2 else None)
    elif cmd == "clone":
        if len(sys.argv) < 4:
            print("usage: save_edit.py clone <fromProfile> <toProfile>")
        else:
            cmd_clone(sys.argv[2], sys.argv[3])
    elif cmd in ("info", "unlock-abilities"):
        path = sys.argv[2]
        if cmd == "info":
            print(ability_status(path))
        else:
            unlock_file(path)
    else:
        print("usage: save_edit.py [list | unlock [profile] | info <psd> | unlock-abilities <psd>]")
