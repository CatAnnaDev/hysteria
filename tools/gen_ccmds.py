import json, glob, os

ROOT = "/Users/anna/start_game_project"
BIN = "/opt/homebrew/opt/mingw-w64/toolchain-i686/bin"
GCC = BIN + "/i686-w64-mingw32-gcc"
GXX = BIN + "/i686-w64-mingw32-g++"
API = ROOT + "/hysteria"

cmds = []
def add(f, cxx):
    comp = GXX if cxx else GCC
    cmds.append({
        "directory": os.path.dirname(f),
        "file": f,
        "arguments": [comp, "-I" + API, "-c", f, "-o", "/dev/null"],
    })

for f in sorted(glob.glob(ROOT + "/hysteria/*.c")): add(f, False)
for f in sorted(glob.glob(ROOT + "/mods/*/*.c")): add(f, False)
for f in sorted(glob.glob(ROOT + "/mods/*/*.cpp")): add(f, True)

open(ROOT + "/compile_commands.json", "w").write(json.dumps(cmds, indent=1))
print("wrote %d entries -> %s/compile_commands.json" % (len(cmds), ROOT))
