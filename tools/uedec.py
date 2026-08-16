import argparse
import os
import sys
import time

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)

import ue3_pkg as package
import ue3_decompile as decompile

SCRIPT_PACKAGES = ('Core', 'Engine', 'GameFramework', 'GFxUI', 'IpDrv',
                   'Kynapse', 'OnlineSubsystemPC', 'AliceGame')

SEARCH_DIRS = (
    os.path.join(os.path.expanduser('~'), 'Library', 'Application Support', 'CrossOver',
                 'Bottles', 'Steam', 'drive_c', 'users', 'crossover', 'Desktop', 'AMR',
                 'AliceGame', 'CookedPC'),
)

PACKAGE_EXTENSIONS = ('.u', '.upk', '.umap')

RECURSION_HEADROOM = 6000


def resolve_package_path(target):
    if os.path.isfile(target):
        return target
    base, ext = os.path.splitext(target)
    candidates = [target] if ext else [target + e for e in PACKAGE_EXTENSIONS]
    for directory in SEARCH_DIRS:
        for candidate in candidates:
            path = os.path.join(directory, candidate)
            if os.path.isfile(path):
                return path
    raise SystemExit('package not found: %s' % target)


def safe_stem(name):
    cleaned = ''.join(c if c.isalnum() or c in '._-' else '_' for c in name)
    return cleaned or 'unnamed'


def class_exports(pkg):
    return [e for e in pkg.exports if pkg.class_name(e) == 'Class']


def subtree(pkg, export):
    stack = [export]
    seen = []
    while stack:
        current = stack.pop()
        seen.append(current)
        stack.extend(pkg.children_of(current))
    return seen


def count_kind(pkg, exports, kind):
    return sum(1 for e in exports if pkg.class_name(e) == kind)


def match_exports(pkg, name, kind):
    wanted = name.lower()
    exact = [e for e in pkg.find(name) if pkg.class_name(e) == kind]
    if exact:
        return exact
    return [e for e in pkg.exports
            if pkg.class_name(e) == kind and wanted in e['name'].lower()]


def owning_class(pkg, export):
    index = export['outer']
    while index > 0:
        owner = pkg.export_at(index)
        if owner is None:
            return None
        if pkg.class_name(owner) == 'Class':
            return owner
        index = owner['outer']
    return None


class Progress:
    def __init__(self, label, total, stream=None, width=32):
        self.label = label
        self.total = max(total, 1)
        self.stream = stream if stream is not None else sys.stderr
        self.width = width
        self.done = 0
        self.step = max(self.total // 200, 1)
        self.started = time.time()
        self.active = self.stream.isatty()

    def advance(self, count=1):
        self.done += count
        if self.active and self.done % self.step == 0:
            self._draw()

    def _draw(self):
        ratio = min(self.done / self.total, 1.0)
        filled = int(self.width * ratio)
        self.stream.write('\r%-18s [%s%s] %5.1f%% %d/%d' % (
            self.label, '#' * filled, '.' * (self.width - filled),
            ratio * 100.0, self.done, self.total))
        self.stream.flush()

    def finish(self):
        elapsed = time.time() - self.started
        if self.active:
            self.done = self.total
            self._draw()
            self.stream.write('\n')
        else:
            self.stream.write('%-18s %d/%d\n' % (self.label, self.done, self.total))
        self.stream.flush()
        return elapsed


def render_class(pkg, export):
    try:
        text = decompile.decompile_class(pkg, export)
    except Exception as exc:
        return decompile.RAW_MARKER + '%s: %s: %s' % (
            export['name'], type(exc).__name__, exc), False
    return text, True


def export_package(pkg, out_root, quiet=False):
    directory = os.path.join(out_root, safe_stem(pkg.name))
    os.makedirs(directory, exist_ok=True)
    classes = class_exports(pkg)
    stats = {
        'package': pkg.name,
        'classes': 0,
        'functions': count_kind(pkg, pkg.exports, 'Function'),
        'states': count_kind(pkg, pkg.exports, 'State'),
        'structs': count_kind(pkg, pkg.exports, 'ScriptStruct'),
        'enums': count_kind(pkg, pkg.exports, 'Enum'),
        'crashed': 0,
        'partial': 0,
        'lines': 0,
        'bytes': 0,
        'seconds': 0.0,
    }
    bar = None if quiet else Progress(pkg.name, len(classes))
    started = time.time()
    used = {}
    for export in classes:
        text, ok = render_class(pkg, export)
        if not ok:
            stats['crashed'] += 1
        elif decompile.RAW_MARKER in text:
            stats['partial'] += 1
        stem = safe_stem(export['name'])
        count = used.get(stem.lower(), 0)
        used[stem.lower()] = count + 1
        if count:
            stem = '%s_%d' % (stem, count)
        body = text if text.endswith('\n') else text + '\n'
        blob = body.encode('utf-8', 'replace')
        with open(os.path.join(directory, stem + '.uc'), 'wb') as handle:
            handle.write(blob)
        stats['classes'] += 1
        stats['lines'] += body.count('\n')
        stats['bytes'] += len(blob)
        if bar is not None:
            bar.advance()
    stats['seconds'] = bar.finish() if bar is not None else time.time() - started
    return stats


def list_classes(pkg, stream=sys.stdout):
    classes = class_exports(pkg)
    for export in classes:
        members = subtree(pkg, export)
        parent = pkg.obj_name(export['super_index'])
        stream.write('%-52s %-32s func=%-4d state=%-3d var=%d\n' % (
            pkg.full_path(export),
            'extends ' + parent if parent != 'None' else '',
            count_kind(pkg, members, 'Function'),
            count_kind(pkg, members, 'State'),
            sum(1 for e in members
                if pkg.class_name(e) in package.PROPERTY_REF_COUNT)))
    stream.write('%d classes, %d exports, %d names, %d imports\n' % (
        len(classes), len(pkg.exports), len(pkg.names), len(pkg.imports)))


def print_class(pkg, name, stream=sys.stdout):
    found = match_exports(pkg, name, 'Class')
    if not found:
        raise SystemExit('no class matching %r in %s' % (name, pkg.name))
    for export in found:
        stream.write(render_class(pkg, export)[0].rstrip('\n') + '\n')
    return len(found)


def print_function(pkg, spec, stream=sys.stdout):
    owner_name, _, func_name = spec.rpartition('.')
    candidates = match_exports(pkg, func_name, 'Function')
    if owner_name:
        wanted = owner_name.lower()
        scoped = []
        for export in candidates:
            owner = owning_class(pkg, export)
            if owner is not None and owner['name'].lower() == wanted:
                scoped.append(export)
        candidates = scoped
    if not candidates:
        raise SystemExit('no function matching %r in %s' % (spec, pkg.name))
    for export in candidates:
        owner = owning_class(pkg, export)
        outer = pkg.export_at(export['outer'])
        scope = pkg.full_path(owner) if owner is not None else pkg.name
        if outer is not None and pkg.class_name(outer) == 'State':
            scope += ' state ' + outer['name']
        sys.stderr.write('%s\n' % scope)
        try:
            stream.write(decompile.decompile_function(pkg, export).rstrip('\n') + '\n\n')
        except Exception as exc:
            stream.write('%s%s: %s\n\n' % (decompile.RAW_MARKER, type(exc).__name__, exc))
    return len(candidates)


def summarize(rows, elapsed, stream=sys.stderr):
    stream.write('\n%-20s %8s %10s %8s %8s %8s %9s %8s\n' % (
        'package', 'classes', 'functions', 'states', 'partial', 'failed', 'lines', 'time'))
    totals = dict(classes=0, functions=0, states=0, partial=0, crashed=0, lines=0)
    for row in rows:
        for key in totals:
            totals[key] += row[key]
        stream.write('%-20s %8d %10d %8d %8d %8d %9d %7.2fs\n' % (
            row['package'], row['classes'], row['functions'], row['states'],
            row['partial'], row['crashed'], row['lines'], row['seconds']))
    stream.write('%-20s %8d %10d %8d %8d %8d %9d %7.2fs\n' % (
        'TOTAL', totals['classes'], totals['functions'], totals['states'],
        totals['partial'], totals['crashed'], totals['lines'], elapsed))
    stream.flush()


def build_parser():
    parser = argparse.ArgumentParser(
        prog='uedec.py',
        description='UnrealScript decompiler for Unreal Engine 3 cooked packages')
    parser.add_argument('packages', nargs='+', metavar='PACKAGE')
    parser.add_argument('--out', metavar='DIR')
    parser.add_argument('--class', dest='class_name', metavar='NAME')
    parser.add_argument('--func', dest='func_name', metavar='NAME')
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--quiet', action='store_true')
    return parser


def main(argv=None):
    if sys.getrecursionlimit() < RECURSION_HEADROOM:
        sys.setrecursionlimit(RECURSION_HEADROOM)
    args = build_parser().parse_args(argv)
    rows = []
    started = time.time()
    for target in args.packages:
        path = resolve_package_path(target)
        try:
            pkg = package.Package(path)
        except package.PackageError as exc:
            sys.stderr.write('%s: %s\n' % (path, exc))
            continue
        if args.out:
            rows.append(export_package(pkg, args.out, args.quiet))
        if args.class_name:
            print_class(pkg, args.class_name)
        if args.func_name:
            print_function(pkg, args.func_name)
        if args.list or not (args.out or args.class_name or args.func_name):
            list_classes(pkg)
    if rows:
        summarize(rows, time.time() - started)
    return 0


if __name__ == '__main__':
    sys.exit(main())
