import os
import struct

try:
    from lzo1x import lzo1x_decompress
except ImportError:
    import sys
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from lzo1x import lzo1x_decompress

PACKAGE_TAG = 0x9E2A83C1
RF_CLASS_DEFAULT_OBJECT = 0x0000000000000200
RF_ARCHETYPE_OBJECT = 0x0000000000000400
RF_HAS_STACK = 0x0200000000000000
STRUCT_IMMUTABLE = 0x00000020
CPF_NET = 0x00000020
STATE_FRAME_SIZE = 26
NET_INDEX_SIZE = 4
IMPORT_ENTRY_SIZE = 28
UFIELD_NEXT_OFFSET = 16
PROPERTY_DIM_OFFSET = 20
PROPERTY_FLAGS_OFFSET = 24
UFIELD_CHILDREN_OFFSET = 24
PROPERTY_TAIL_OFFSET = 44
STRUCT_FLAGS_OFFSET = 48
MAX_PROPERTY_DEPTH = 24
MAX_RESYNC_OFFSET = 32
MAX_CHUNK_EXPANSION = 64
MAX_CHUNK_SLACK = 1 << 20

_I32 = struct.Struct('<i')
_U32 = struct.Struct('<I')
_I64 = struct.Struct('<q')
_U64 = struct.Struct('<Q')
_F32 = struct.Struct('<f')
_2I = struct.Struct('<2i')
_3I = struct.Struct('<3i')
_4U = struct.Struct('<4I')
_6I = struct.Struct('<6i')
_7I = struct.Struct('<7i')
_2U = struct.Struct('<2I')

PROPERTY_REF_COUNT = {
    'BoolProperty': 0, 'IntProperty': 0, 'FloatProperty': 0, 'NameProperty': 0,
    'StrProperty': 0, 'QWordProperty': 0, 'PointerProperty': 0,
    'ByteProperty': 1, 'ObjectProperty': 1, 'ComponentProperty': 1,
    'InterfaceProperty': 1, 'StructProperty': 1, 'ArrayProperty': 1,
    'FixedArrayProperty': 1, 'ClassProperty': 2, 'DelegateProperty': 2,
    'MapProperty': 2,
}

BINARY_ELEMENT_SIZE = {
    'IntProperty': 4, 'FloatProperty': 4, 'BoolProperty': 4, 'ByteProperty': 1,
    'ObjectProperty': 4, 'ClassProperty': 4, 'ComponentProperty': 4,
    'NameProperty': 8, 'QWordProperty': 8, 'InterfaceProperty': 8,
    'PointerProperty': 4,
}

TAGGED_ARRAY_ELEMENT_SIZE = {
    'IntProperty': 4, 'FloatProperty': 4, 'ObjectProperty': 4, 'ClassProperty': 4,
    'ComponentProperty': 4, 'NameProperty': 8, 'QWordProperty': 8,
    'InterfaceProperty': 8, 'ByteProperty': 1,
}


class PackageError(Exception):
    pass


class TypeRegistry:
    def __init__(self):
        self.super_of = {}
        self.struct_super = {}
        self.struct_flags = {}
        self.struct_own_members = {}
        self.fields = {}
        self.component_cache = {}
        self.member_cache = {}
        self.size_cache = {}

    def register(self, pkg):
        b = pkg.b
        limit = len(b)
        pending_inner = []
        pending_structs = []
        by_index = {}
        for e in pkg.exports:
            cls = pkg.class_name(e)
            if cls == 'Class':
                sup = pkg.obj_name(e['super_index']) if e['super_index'] else None
                self.super_of[e['name']] = sup if sup != 'None' else None
                continue
            if cls == 'ScriptStruct':
                base = e['serial_offset']
                flags = read_u32(b, base + STRUCT_FLAGS_OFFSET, limit)
                if flags is not None:
                    self.struct_flags[e['name']] = flags
                sup = pkg.obj_name(e['super_index']) if e['super_index'] else None
                self.struct_super[e['name']] = sup if sup != 'None' else None
                pending_structs.append((e['name'], read_i32(b, base + UFIELD_CHILDREN_OFFSET, limit)))
                continue
            refs = PROPERTY_REF_COUNT.get(cls)
            if refs is None:
                continue
            base = e['serial_offset']
            dim = read_i32(b, base + PROPERTY_DIM_OFFSET, limit)
            flags = read_u64(b, base + PROPERTY_FLAGS_OFFSET, limit)
            if dim is None or flags is None:
                continue
            tail = base + PROPERTY_TAIL_OFFSET + (2 if flags & CPF_NET else 0)
            record = {'type': cls, 'dim': dim if dim > 0 else 1, 'flags': flags}
            values = []
            for k in range(refs):
                v = read_i32(b, tail + k * 4, limit)
                if v is None:
                    break
                values.append(v)
            if len(values) != refs:
                continue
            if cls == 'ByteProperty':
                record['enum'] = pkg.obj_name(values[0])
            elif cls == 'StructProperty':
                record['struct'] = pkg.obj_name(values[0])
            elif cls == 'ArrayProperty':
                pending_inner.append((record, values[0]))
            elif refs:
                record['class'] = pkg.obj_name(values[0])
            by_index[e['index'] + 1] = (e['name'], record)
            self.fields.setdefault(pkg.obj_name(e['outer']), {})[e['name']] = record
        for record, inner_index in pending_inner:
            record['elem'] = self.describe(pkg, inner_index)
        for name, head in pending_structs:
            self.struct_own_members[name] = self.walk_fields(pkg, head, by_index)
        self.component_cache.clear()
        self.member_cache.clear()
        self.size_cache.clear()

    def walk_fields(self, pkg, head, by_index):
        members = []
        seen = set()
        limit = len(pkg.b)
        cur = head
        while cur and cur > 0 and cur not in seen:
            seen.add(cur)
            export = pkg.export_at(cur)
            if export is None:
                break
            entry = by_index.get(cur)
            if entry is not None:
                members.append(entry)
            nxt = read_i32(pkg.b, export['serial_offset'] + UFIELD_NEXT_OFFSET, limit)
            cur = nxt if nxt else 0
        return members

    def describe(self, pkg, index, depth=0):
        if depth >= MAX_PROPERTY_DEPTH:
            return None
        inner = pkg.export_at(index)
        if inner is None:
            return None
        cls = pkg.class_name(inner)
        refs = PROPERTY_REF_COUNT.get(cls)
        if refs is None:
            return None
        base = inner['serial_offset']
        limit = len(pkg.b)
        flags = read_u64(pkg.b, base + PROPERTY_FLAGS_OFFSET, limit)
        if flags is None:
            return None
        tail = base + PROPERTY_TAIL_OFFSET + (2 if flags & CPF_NET else 0)
        record = {'type': cls, 'dim': 1, 'flags': flags}
        if refs:
            v = read_i32(pkg.b, tail, limit)
            if v is None:
                return None
            if cls == 'ByteProperty':
                record['enum'] = pkg.obj_name(v)
            elif cls == 'StructProperty':
                record['struct'] = pkg.obj_name(v)
            elif cls == 'ArrayProperty':
                record['elem'] = self.describe(pkg, v, depth + 1)
            else:
                record['class'] = pkg.obj_name(v)
        return record

    def members_of(self, struct_name, depth=0):
        cached = self.member_cache.get(struct_name)
        if cached is not None:
            return cached
        own = self.struct_own_members.get(struct_name)
        if own is None:
            return None
        parent = self.struct_super.get(struct_name)
        members = own
        if parent and depth < MAX_PROPERTY_DEPTH:
            inherited = self.members_of(parent, depth + 1)
            if inherited is None:
                return None
            members = inherited + own
        self.member_cache[struct_name] = members
        return members

    def binary_size(self, struct_name, depth=0):
        cached = self.size_cache.get(struct_name)
        if cached is not None:
            return cached
        if depth >= MAX_PROPERTY_DEPTH:
            return None
        members = self.members_of(struct_name)
        if not members:
            return None
        total = 0
        for _, record in members:
            step = BINARY_ELEMENT_SIZE.get(record['type'])
            if step is None:
                if record['type'] != 'StructProperty':
                    return None
                step = self.binary_size(record.get('struct'), depth + 1)
                if step is None:
                    return None
            total += step * record['dim']
        self.size_cache[struct_name] = total
        return total

    def is_component(self, cls):
        cached = self.component_cache.get(cls)
        if cached is not None:
            return cached
        chain = []
        cur = cls
        result = None
        seen = set()
        while cur and cur not in seen:
            if cur == 'Component':
                result = True
                break
            cached = self.component_cache.get(cur)
            if cached is not None:
                result = cached
                break
            seen.add(cur)
            chain.append(cur)
            if cur not in self.super_of:
                break
            cur = self.super_of[cur]
        if result is None and not cur:
            result = False
        if result is not None:
            for c in chain:
                self.component_cache[c] = result
            self.component_cache[cls] = result
        return result

    def lookup_field(self, owner, name):
        cur = owner
        seen = set()
        while cur and cur not in seen:
            seen.add(cur)
            table = self.fields.get(cur)
            if table is not None:
                record = table.get(name)
                if record is not None:
                    return record
            cur = self.super_of.get(cur)
        return None

    def is_immutable(self, struct_name):
        flags = self.struct_flags.get(struct_name)
        return flags is not None and (flags & STRUCT_IMMUTABLE) != 0


REGISTRY = TypeRegistry()


def read_i32(b, o, limit):
    if o < 0 or o + 4 > limit:
        return None
    return _I32.unpack_from(b, o)[0]


def read_u32(b, o, limit):
    if o < 0 or o + 4 > limit:
        return None
    return _U32.unpack_from(b, o)[0]


def read_u64(b, o, limit):
    if o < 0 or o + 8 > limit:
        return None
    return _U64.unpack_from(b, o)[0]


def read_fstring(b, o, limit):
    n = read_i32(b, o, limit)
    if n is None:
        return None, -1
    o += 4
    if n == 0:
        return '', o
    if n > 0:
        if o + n > limit:
            return None, -1
        raw = b[o:o + n]
        end = raw.find(b'\0')
        if end < 0:
            end = n
        return raw[:end].decode('latin1', 'replace'), o + n
    size = -n * 2
    if o + size > limit:
        return None, -1
    raw = b[o:o + size]
    text = raw.decode('utf-16le', 'replace')
    end = text.find('\0')
    if end >= 0:
        text = text[:end]
    return text, o + size


class Package:
    def __init__(self, path):
        self.path = path
        self.name = os.path.splitext(os.path.basename(path))[0]
        self.errors = []
        raw = self._load(path)
        self._read_summary(raw)
        self.b = self._rebuild(raw)
        self.limit = len(self.b)
        self.names = self._read_names()
        self.imports = self._read_imports()
        self.exports = self._read_exports()
        self._children = None
        self._by_name = None
        REGISTRY.register(self)

    def _load(self, path):
        try:
            with open(path, 'rb') as f:
                raw = f.read()
        except OSError as exc:
            raise PackageError(str(exc))
        if len(raw) < 64 or _U32.unpack_from(raw, 0)[0] != PACKAGE_TAG:
            raise PackageError('not a UE3 package: %s' % path)
        return raw

    def _read_summary(self, raw):
        limit = len(raw)
        version = read_u32(raw, 4, limit)
        self.file_version = version & 0xFFFF
        self.licensee_version = version >> 16
        self.total_header_size = read_i32(raw, 8, limit)
        folder, o = read_fstring(raw, 12, limit)
        if o < 0:
            raise PackageError('truncated summary: %s' % self.path)
        self.folder_name = folder
        self.package_flags = read_u32(raw, o, limit)
        o += 4
        fields = self._unpack(_6I, raw, o, limit)
        if fields is None:
            raise PackageError('truncated summary: %s' % self.path)
        (self.name_count, self.name_offset, self.export_count, self.export_offset,
         self.import_count, self.import_offset) = fields
        o += 24
        self.depends_offset = read_i32(raw, o, limit)
        o += 4 * 5 + 16
        generations = read_i32(raw, o, limit)
        if generations is None or generations < 0 or generations > 0xFFFF:
            raise PackageError('bad generation count: %s' % self.path)
        o += 4 + generations * 12
        self.engine_version = read_i32(raw, o, limit)
        self.cooker_version = read_i32(raw, o + 4, limit)
        o += 8
        self.compression_flags = read_u32(raw, o, limit)
        chunk_count = read_i32(raw, o + 4, limit)
        o += 8
        self.chunks = []
        if chunk_count is None or chunk_count < 0 or chunk_count > 0xFFFF:
            chunk_count = 0
        for _ in range(chunk_count):
            entry = self._unpack(_4U, raw, o, limit)
            if entry is None:
                break
            self.chunks.append(entry)
            o += 16
        if self.name_count is None or self.name_count < 0 or self.export_count is None:
            raise PackageError('bad table counts: %s' % self.path)

    @staticmethod
    def _unpack(fmt, b, o, limit):
        if o < 0 or o + fmt.size > limit:
            return None
        return fmt.unpack_from(b, o)

    def _rebuild(self, raw):
        if not self.compression_flags or not self.chunks:
            return raw
        total = max(uoff + usize for uoff, usize, _, _ in self.chunks)
        if total <= 0 or total > len(raw) * MAX_CHUNK_EXPANSION + MAX_CHUNK_SLACK:
            raise PackageError('implausible uncompressed size %d: %s' % (total, self.path))
        buf = bytearray(total)
        prefix = min(self.chunks[0][0], len(raw), total)
        buf[0:prefix] = raw[0:prefix]
        limit = len(raw)
        for uoff, usize, coff, csize in self.chunks:
            head = self._unpack(_4U, raw, coff, limit)
            if head is None:
                self.errors.append('chunk header out of range at %d' % coff)
                continue
            _, block_size, _, total_uncompressed = head
            if block_size == 0:
                self.errors.append('zero block size at %d' % coff)
                continue
            nblocks = (total_uncompressed + block_size - 1) // block_size
            p = coff + 16
            blocks = []
            for i in range(nblocks):
                entry = self._unpack(_2U, raw, p + i * 8, limit)
                if entry is None:
                    break
                blocks.append(entry)
            p += nblocks * 8
            pos = uoff
            for comp_size, uncomp_size in blocks:
                if p + comp_size > limit or pos + uncomp_size > total:
                    self.errors.append('block out of range at %d' % p)
                    break
                if comp_size == uncomp_size:
                    buf[pos:pos + uncomp_size] = raw[p:p + comp_size]
                else:
                    try:
                        out = lzo1x_decompress(raw[p:p + comp_size])
                    except Exception:
                        out = b''
                        self.errors.append('lzo failure at %d' % p)
                    if len(out) != uncomp_size:
                        self.errors.append('lzo size mismatch at %d' % p)
                    buf[pos:pos + min(len(out), uncomp_size)] = out[:uncomp_size]
                p += comp_size
                pos += uncomp_size
        return bytes(buf)

    def _read_names(self):
        names = []
        b = self.b
        limit = len(b)
        o = self.name_offset
        for _ in range(self.name_count):
            text, o = read_fstring(b, o, limit)
            if o < 0 or o + 8 > limit:
                self.errors.append('name table truncated at entry %d' % len(names))
                break
            names.append(text)
            o += 8
        self.name_table_end = o if o >= 0 else self.name_offset
        return names

    def _read_imports(self):
        imports = []
        b = self.b
        limit = len(b)
        o = self.import_offset
        for _ in range(self.import_count):
            entry = self._unpack(_7I, b, o, limit)
            if entry is None:
                self.errors.append('import table truncated at entry %d' % len(imports))
                break
            imports.append({
                'index': len(imports),
                'class_package': self.name_of(entry[0], entry[1]),
                'class_name': self.name_of(entry[2], entry[3]),
                'outer': entry[4],
                'name': self.name_of(entry[5], entry[6]),
            })
            o += IMPORT_ENTRY_SIZE
        self.import_table_end = o
        return imports

    def _read_exports(self):
        exports = []
        b = self.b
        limit = len(b)
        o = self.export_offset
        for _ in range(self.export_count):
            head = self._unpack(_3I, b, o, limit)
            name = self._unpack(_2I, b, o + 12, limit)
            arch = read_i32(b, o + 20, limit)
            flags = read_u64(b, o + 24, limit)
            span = self._unpack(_2I, b, o + 32, limit)
            export_flags = read_u32(b, o + 40, limit)
            net_count = read_i32(b, o + 44, limit)
            if head is None or name is None or span is None or net_count is None:
                self.errors.append('export table truncated at entry %d' % len(exports))
                break
            if net_count < 0 or o + 48 + net_count * 4 + 20 > limit:
                self.errors.append('bad net object count at entry %d' % len(exports))
                break
            serial_size, serial_offset = span
            if serial_size < 0 or serial_offset < 0 or serial_offset + serial_size > limit:
                serial_size = max(0, min(serial_size, limit - max(serial_offset, 0)))
                serial_offset = max(0, min(serial_offset, limit))
                self.errors.append('clamped export data at entry %d' % len(exports))
            exports.append({
                'index': len(exports),
                'class_index': head[0],
                'super_index': head[1],
                'outer': head[2],
                'name': self.name_of(name[0], name[1]),
                'archetype': arch,
                'flags': flags,
                'serial_size': serial_size,
                'serial_offset': serial_offset,
                'export_flags': export_flags,
            })
            o += 48 + net_count * 4 + 20
        self.export_table_end = o
        return exports

    def name_of(self, index, number=0):
        if 0 <= index < len(self.names):
            text = self.names[index]
        else:
            text = '?name%d' % index
        return text + ('_%d' % (number - 1)) if number > 0 else text

    def read_name(self, b, o, limit):
        pair = self._unpack(_2I, b, o, limit)
        if pair is None:
            return None, -1
        index, number = pair
        if not (0 <= index < len(self.names)):
            return None, -1
        text = self.names[index]
        return (text + ('_%d' % (number - 1)) if number > 0 else text), o + 8

    def obj_ref(self, index):
        if index > 0:
            i = index - 1
            return self.exports[i] if i < len(self.exports) else None
        if index < 0:
            i = -index - 1
            return self.imports[i] if i < len(self.imports) else None
        return None

    def export_at(self, index):
        if index > 0 and index - 1 < len(self.exports):
            return self.exports[index - 1]
        return None

    def obj_name(self, index):
        ref = self.obj_ref(index)
        return ref['name'] if ref is not None else 'None'

    def class_name(self, export):
        if isinstance(export, int):
            export = self.export_at(export)
        if export is None:
            return 'None'
        index = export['class_index']
        if index == 0:
            return 'Class'
        return self.obj_name(index)

    def full_path(self, export):
        index = export['index'] + 1 if isinstance(export, dict) else export
        path = self.object_path(index)
        if path == 'None':
            return path
        if index > 0:
            return self.name + '.' + path
        return path

    def object_path(self, index):
        parts = []
        seen = set()
        while index != 0 and index not in seen:
            seen.add(index)
            ref = self.obj_ref(index)
            if ref is None:
                break
            parts.append(ref['name'])
            index = ref['outer']
        return '.'.join(reversed(parts)) if parts else 'None'

    def data(self, export):
        if isinstance(export, int):
            export = self.export_at(export)
        if export is None:
            return b''
        start = export['serial_offset']
        return self.b[start:start + export['serial_size']]

    def find(self, name, exact=True):
        if self._by_name is None:
            table = {}
            for e in self.exports:
                table.setdefault(e['name'].lower(), []).append(e)
            self._by_name = table
        key = name.lower()
        if exact:
            return list(self._by_name.get(key, ()))
        return [e for e in self.exports if key in e['name'].lower()]

    def children_of(self, export):
        if self._children is None:
            table = {}
            for e in self.exports:
                table.setdefault(e['outer'], []).append(e)
            self._children = table
        index = export['index'] + 1 if isinstance(export, dict) else export
        return list(self._children.get(index, ()))

    def property_start(self, export):
        cls = self.class_name(export)
        if cls == 'Class':
            return None
        base = export['serial_offset']
        end = base + export['serial_size']
        o = base
        if export['flags'] & RF_HAS_STACK:
            o += STATE_FRAME_SIZE
        component = REGISTRY.is_component(cls)
        if component and not (export['flags'] & RF_CLASS_DEFAULT_OBJECT):
            template, after = self.read_name(self.b, o + 4, end)
            if after > 0 and template == export['name']:
                return after + NET_INDEX_SIZE
            return o + 4 + NET_INDEX_SIZE
        return o + NET_INDEX_SIZE

    def property_candidates(self, export):
        cls = self.class_name(export)
        if cls == 'Class':
            return []
        base = export['serial_offset']
        end = base + export['serial_size']
        stack = STATE_FRAME_SIZE if export['flags'] & RF_HAS_STACK else 0
        candidates = []
        primary = self.property_start(export)
        if primary is not None:
            candidates.append(primary)
        for shift in (0, 4):
            value = base + stack + shift + NET_INDEX_SIZE
            if value not in candidates:
                candidates.append(value)
        template, after = self.read_name(self.b, base + stack + 4, end)
        if after > 0 and after + NET_INDEX_SIZE not in candidates:
            candidates.append(after + NET_INDEX_SIZE)
        for k in range(0, MAX_RESYNC_OFFSET + 1, 4):
            value = base + k
            if value not in candidates:
                candidates.append(value)
        return [c for c in candidates if base <= c <= end]

    def export_properties(self, export):
        if isinstance(export, int):
            export = self.export_at(export)
        if export is None:
            return {}, -1
        end = export['serial_offset'] + export['serial_size']
        owner = self.class_name(export)
        for start in self.property_candidates(export):
            props, off = self.read_properties(self.b, start, end, owner)
            if off >= 0:
                return props, off
        return {}, -1

    def read_properties(self, buf, off, limit, owner=None, depth=0):
        props = {}
        limit = min(limit, len(buf))
        while True:
            name, after = self.read_name(buf, off, limit)
            if after < 0:
                return props, -1
            off = after
            if name == 'None':
                return props, off
            type_name, after = self.read_name(buf, off, limit)
            if after < 0:
                return props, -1
            off = after
            head = self._unpack(_2I, buf, off, limit)
            if head is None:
                return props, -1
            size, array_index = head
            off += 8
            if size < 0 or array_index < 0:
                return props, -1
            extra = None
            if type_name == 'StructProperty' or type_name == 'ByteProperty':
                extra, after = self.read_name(buf, off, limit)
                if after < 0:
                    return props, -1
                off = after
            elif type_name == 'BoolProperty':
                if off + 1 > limit:
                    return props, -1
                extra = buf[off] != 0
                off += 1
            if off + size > limit:
                return props, -1
            value = self.read_value(buf, off, size, type_name, extra, owner, name, depth)
            key = name if array_index == 0 else '%s[%d]' % (name, array_index)
            props[key] = value
            off += size

    def read_value(self, buf, off, size, type_name, extra, owner, name, depth):
        limit = off + size
        if type_name == 'BoolProperty':
            return extra
        if type_name == 'IntProperty':
            value = read_i32(buf, off, limit)
            return value if value is not None else b''
        if type_name == 'FloatProperty':
            if off + 4 > limit:
                return 0.0
            return _F32.unpack_from(buf, off)[0]
        if type_name == 'QWordProperty':
            if off + 8 > limit:
                return 0
            return _I64.unpack_from(buf, off)[0]
        if type_name == 'ByteProperty':
            if size == 8:
                text, after = self.read_name(buf, off, limit)
                return text if after > 0 else 0
            return buf[off] if off < limit else 0
        if type_name == 'NameProperty':
            text, after = self.read_name(buf, off, limit)
            return text if after > 0 else 'None'
        if type_name in ('ObjectProperty', 'ClassProperty', 'ComponentProperty', 'InterfaceProperty'):
            index = read_i32(buf, off, limit)
            return self.object_path(index) if index is not None else 'None'
        if type_name == 'DelegateProperty':
            index = read_i32(buf, off, limit)
            text, after = self.read_name(buf, off + 4, limit)
            return (self.object_path(index) if index is not None else 'None',
                    text if after > 0 else 'None')
        if type_name == 'StrProperty':
            text, after = read_fstring(buf, off, limit)
            return text if after > 0 else ''
        if type_name == 'StructProperty':
            return self.read_struct_value(buf, off, size, extra, depth)
        if type_name == 'ArrayProperty':
            return self.read_array_value(buf, off, size, owner, name, depth)
        return bytes(buf[off:limit])

    def read_struct_value(self, buf, off, size, struct_name, depth):
        if depth >= MAX_PROPERTY_DEPTH:
            return bytes(buf[off:off + size])
        if REGISTRY.is_immutable(struct_name):
            value = self.read_binary_struct(buf, off, size, struct_name, depth)
            return value if value is not None else bytes(buf[off:off + size])
        props, end = self.read_properties(buf, off, off + size, struct_name, depth + 1)
        if end == off + size:
            return props
        value = self.read_binary_struct(buf, off, size, struct_name, depth)
        return value if value is not None else bytes(buf[off:off + size])

    def read_binary_struct(self, buf, off, size, struct_name, depth):
        members = REGISTRY.members_of(struct_name)
        if not members:
            return None
        out = {}
        cursor = off
        end = off + size
        for member_name, record in members:
            for i in range(record['dim']):
                value, cursor = self.read_binary_value(buf, cursor, end, record, depth)
                if cursor < 0:
                    return None
                out[member_name if record['dim'] == 1 else '%s[%d]' % (member_name, i)] = value
        return out if cursor == end else None

    def read_binary_value(self, buf, off, end, record, depth):
        type_name = record['type']
        step = BINARY_ELEMENT_SIZE.get(type_name)
        if step is not None:
            if off + step > end:
                return None, -1
            if type_name == 'BoolProperty':
                return _I32.unpack_from(buf, off)[0] != 0, off + 4
            if type_name == 'ByteProperty':
                return buf[off], off + 1
            return self.read_value(buf, off, step, type_name, None, None, None, depth), off + step
        if type_name == 'StrProperty':
            text, after = read_fstring(buf, off, end)
            return (text, after) if after > 0 else (None, -1)
        if type_name == 'StructProperty':
            if depth >= MAX_PROPERTY_DEPTH:
                return None, -1
            inner = record.get('struct')
            size = REGISTRY.binary_size(inner)
            if size is None or off + size > end:
                return None, -1
            return self.read_binary_struct(buf, off, size, inner, depth + 1), off + size
        return None, -1

    def read_array_value(self, buf, off, size, owner, name, depth):
        end = off + size
        count = read_i32(buf, off, end)
        if count is None or count < 0:
            return bytes(buf[off:end])
        body = off + 4
        if count == 0:
            return []
        record = REGISTRY.lookup_field(owner, name) if owner else None
        element = record.get('elem') if record and record.get('type') == 'ArrayProperty' else None
        if element is None:
            return bytes(buf[body:end])
        type_name = element['type']
        step = TAGGED_ARRAY_ELEMENT_SIZE.get(type_name)
        if step is not None:
            if body + count * step > end:
                return bytes(buf[body:end])
            return [self.read_value(buf, body + i * step, step, type_name,
                                    element.get('enum'), owner, name, depth)
                    for i in range(count)]
        values = []
        if type_name == 'StrProperty':
            for _ in range(count):
                text, after = read_fstring(buf, body, end)
                if after < 0:
                    return bytes(buf[off + 4:end])
                values.append(text)
                body = after
            return values
        if type_name == 'StructProperty':
            inner = element.get('struct')
            if REGISTRY.is_immutable(inner):
                span = (end - body) // count if count else 0
                if span <= 0 or span * count != end - body:
                    return bytes(buf[body:end])
                for i in range(count):
                    values.append(self.read_struct_value(buf, body + i * span, span, inner, depth + 1))
                return values
            for _ in range(count):
                if depth >= MAX_PROPERTY_DEPTH:
                    return bytes(buf[body:end])
                props, after = self.read_properties(buf, body, end, inner, depth + 1)
                if after < 0:
                    return bytes(buf[off + 4:end])
                values.append(props)
                body = after
            return values
        if type_name == 'DelegateProperty':
            if body + count * 12 > end:
                return bytes(buf[body:end])
            return [self.read_value(buf, body + i * 12, 12, type_name, None, owner, name, depth)
                    for i in range(count)]
        return bytes(buf[body:end])


def open_package(path):
    return Package(path)


def load_script_packages(directory, names=None):
    if names is None:
        names = ('Core', 'Engine', 'GameFramework', 'GFxUI', 'IpDrv', 'Kynapse',
                 'OnlineSubsystemPC', 'AliceGame')
    packages = {}
    for base in names:
        path = os.path.join(directory, base + '.u')
        if os.path.exists(path):
            packages[base] = Package(path)
    return packages


if __name__ == '__main__':
    import sys
    for target in sys.argv[1:]:
        try:
            pkg = Package(target)
        except PackageError as exc:
            print('%s: %s' % (target, exc))
            continue
        print('%-24s ver=%d/%d names=%d imports=%d exports=%d bytes=%d errors=%d' % (
            os.path.basename(target), pkg.file_version, pkg.licensee_version,
            len(pkg.names), len(pkg.imports), len(pkg.exports), len(pkg.b), len(pkg.errors)))
