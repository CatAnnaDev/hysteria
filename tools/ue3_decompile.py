import os
import struct

try:
    import ue3_bytecode as bytecode
    import ue3_pkg as package
except ImportError:
    import sys
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import ue3_bytecode as bytecode
    import ue3_pkg as package

_I32 = struct.Struct('<i')
_U32 = struct.Struct('<I')
_U16 = struct.Struct('<H')
_U64 = struct.Struct('<Q')
_2I = struct.Struct('<2i')

CLASS_PREAMBLE = 4
FIELD_PREAMBLE = 12

SUPER_OFFSET = 0
NEXT_OFFSET = 4
CHILDREN_OFFSET = 12
BYTECODE_SIZE_OFFSET = 28
STORAGE_SIZE_OFFSET = 32
SCRIPT_OFFSET = 36

PROPERTY_DIM_OFFSET = 8
PROPERTY_FLAGS_OFFSET = 12
PROPERTY_CATEGORY_OFFSET = 20
PROPERTY_TAIL_OFFSET = 32

ENUM_NAMES_OFFSET = 8
CONST_VALUE_OFFSET = 8
STRUCT_FLAGS_OFFSET = 36

FUNC_FINAL = 0x00000001
FUNC_DEFINED = 0x00000002
FUNC_ITERATOR = 0x00000004
FUNC_LATENT = 0x00000008
FUNC_PREOPERATOR = 0x00000010
FUNC_SINGULAR = 0x00000020
FUNC_NET = 0x00000040
FUNC_NET_RELIABLE = 0x00000080
FUNC_SIMULATED = 0x00000100
FUNC_EXEC = 0x00000200
FUNC_NATIVE = 0x00000400
FUNC_EVENT = 0x00000800
FUNC_OPERATOR = 0x00001000
FUNC_STATIC = 0x00002000
FUNC_CONST = 0x00008000
FUNC_PRIVATE = 0x00040000
FUNC_PROTECTED = 0x00080000
FUNC_DELEGATE = 0x00100000
FUNC_NET_SERVER = 0x00200000
FUNC_NET_CLIENT = 0x01000000

CPF_EDIT = 0x0000000000000001
CPF_CONST = 0x0000000000000002
CPF_INPUT = 0x0000000000000004
CPF_EXPORT = 0x0000000000000008
CPF_OPTIONAL = 0x0000000000000010
CPF_NET = 0x0000000000000020
CPF_EDIT_FIXED_SIZE = 0x0000000000000040
CPF_PARM = 0x0000000000000080
CPF_OUT = 0x0000000000000100
CPF_SKIP = 0x0000000000000200
CPF_RETURN = 0x0000000000000400
CPF_COERCE = 0x0000000000000800
CPF_NATIVE = 0x0000000000001000
CPF_TRANSIENT = 0x0000000000002000
CPF_CONFIG = 0x0000000000004000
CPF_LOCALIZED = 0x0000000000008000
CPF_TRAVEL = 0x0000000000010000
CPF_EDIT_CONST = 0x0000000000020000
CPF_GLOBAL_CONFIG = 0x0000000000040000
CPF_DUPLICATE_TRANSIENT = 0x0000000000200000
CPF_NO_EXPORT = 0x0000000000800000
CPF_NO_CLEAR = 0x0000000002000000
CPF_EDIT_INLINE = 0x0000000004000000
CPF_DEPRECATED = 0x0000000020000000
CPF_DATA_BINDING = 0x0000000040000000
CPF_REP_NOTIFY = 0x0000000100000000
CPF_INTERP = 0x0000000200000000
CPF_NON_TRANSACTIONAL = 0x0000000400000000
CPF_EDITOR_ONLY = 0x0000000800000000
CPF_NOT_FOR_CONSOLE = 0x0000001000000000
CPF_REP_RETRY = 0x0000002000000000
CPF_PRIVATE_WRITE = 0x0000004000000000
CPF_PROTECTED_WRITE = 0x0000008000000000

STATE_EDITABLE = 0x00000001
STATE_AUTO = 0x00000002
STATE_SIMULATED = 0x00000004

CLASS_ABSTRACT = 0x00000001
CLASS_CONFIG = 0x00000004
CLASS_TRANSIENT = 0x00000008
CLASS_LOCALIZED = 0x00000020
CLASS_SAFE_REPLACE = 0x00000040
CLASS_NATIVE = 0x00000080
CLASS_NO_EXPORT = 0x00000100
CLASS_PLACEABLE = 0x00000200
CLASS_PER_OBJECT_CONFIG = 0x00000400
CLASS_NATIVE_REPLICATION = 0x00000800
CLASS_EDIT_INLINE_NEW = 0x00001000
CLASS_COLLAPSE_CATEGORIES = 0x00002000
CLASS_INTERFACE = 0x00004000
CLASS_DEPRECATED = 0x02000000
CLASS_HIDE_DROPDOWN = 0x04000000

STRUCT_NATIVE = 0x00000001
STRUCT_EXPORT = 0x00000002
STRUCT_TRANSIENT = 0x00000008
STRUCT_ATOMIC = 0x00000010
STRUCT_IMMUTABLE = 0x00000020
STRUCT_IMMUTABLE_WHEN_COOKED = 0x00000080
STRUCT_ATOMIC_WHEN_COOKED = 0x00000100

RF_CLASS_DEFAULT_OBJECT = 0x0000000000000200

INDENT = '    '
RAW_MARKER = '// [raw] '
MAX_FLOW_DEPTH = 96

SIMPLE_TYPES = {
    'IntProperty': 'int', 'FloatProperty': 'float', 'BoolProperty': 'bool',
    'NameProperty': 'name', 'StrProperty': 'string', 'QWordProperty': 'qword',
    'PointerProperty': 'pointer',
}

IMPORT_OPERATORS = {
    'EqualEqual_InterfaceInterface': ('==', 24),
    'NotEqual_InterfaceInterface': ('!=', 26),
    'Multiply_MatrixMatrix': ('*', 16),
}

INVERSE_OPERATOR = {'==': '!=', '!=': '==', '<': '>=', '>': '<=', '<=': '>', '>=': '<',
                    '~=': '!=', 'ClockwiseFrom': 'ClockwiseFrom'}

VARIABLE_OPS = bytecode.VARIABLE_OPS
ASSIGN_OPS = bytecode.ASSIGN_OPS
TRANSPARENT_OPS = bytecode.TRANSPARENT_OPS
HIDDEN_OPS = frozenset(('DebugInfo', 'LabelTable', 'EndOfScript', 'EOF',
                        'IteratorNext', 'IteratorPop', 'EmptyParmValue'))
CONDITIONAL_PRECEDENCE = bytecode.CONDITIONAL_PRECEDENCE

format_float = bytecode.format_float
quote_string = bytecode.quote_string


def _u32(b, o, limit):
    if o < 0 or o + 4 > limit:
        return 0
    return _U32.unpack_from(b, o)[0]


def _i32(b, o, limit):
    if o < 0 or o + 4 > limit:
        return 0
    return _I32.unpack_from(b, o)[0]


def _u64(b, o, limit):
    if o < 0 or o + 8 > limit:
        return 0
    return _U64.unpack_from(b, o)[0]


def _u16(b, o, limit):
    if o < 0 or o + 2 > limit:
        return 0
    return _U16.unpack_from(b, o)[0]


def _name(pkg, o, limit):
    if o < 0 or o + 8 > limit:
        return 'None'
    index, number = _2I.unpack_from(pkg.b, o)
    return pkg.name_of(index, number)


def _preamble(pkg, export):
    return CLASS_PREAMBLE if pkg.class_name(export) == 'Class' else FIELD_PREAMBLE


def field_base(pkg, export):
    return export['serial_offset'] + _preamble(pkg, export)


def children_of(pkg, export):
    limit = len(pkg.b)
    head = _i32(pkg.b, field_base(pkg, export) + CHILDREN_OFFSET, limit)
    out = []
    seen = set()
    while head > 0 and head not in seen:
        seen.add(head)
        child = pkg.export_at(head)
        if child is None:
            break
        out.append(child)
        head = _i32(pkg.b, field_base(pkg, child) + NEXT_OFFSET, limit)
    return out


def script_body(pkg, export):
    base = export['serial_offset']
    limit = base + export['serial_size']
    head = base + _preamble(pkg, export)
    memory = _u32(pkg.b, head + BYTECODE_SIZE_OFFSET, limit)
    storage = _u32(pkg.b, head + STORAGE_SIZE_OFFSET, limit)
    start = head + SCRIPT_OFFSET
    if storage == 0 or start + storage > limit:
        return None
    reader = bytecode.BytecodeReader(pkg, pkg.b, start, start + storage)
    statements = reader.read_statements()
    return {'reader': reader, 'statements': statements,
            'memory_size': memory, 'storage_size': storage, 'end': start + storage}


def script_tail(pkg, export):
    base = export['serial_offset']
    limit = base + export['serial_size']
    head = base + _preamble(pkg, export)
    storage = _u32(pkg.b, head + STORAGE_SIZE_OFFSET, limit)
    return head + SCRIPT_OFFSET + storage, limit


def function_info(pkg, export):
    off, limit = script_tail(pkg, export)
    native_index = _u16(pkg.b, off, limit)
    precedence = pkg.b[off + 2] if off + 2 < limit else 0
    flags = _u32(pkg.b, off + 3, limit)
    cursor = off + 7
    rep_offset = None
    if flags & FUNC_NET:
        rep_offset = _u16(pkg.b, cursor, limit)
        cursor += 2
    friendly = _name(pkg, cursor, limit)
    return {'native_index': native_index, 'precedence': precedence, 'flags': flags,
            'rep_offset': rep_offset, 'friendly_name': friendly}


def state_info(pkg, export):
    off, limit = script_tail(pkg, export)
    probe = _u64(pkg.b, off, limit)
    ignore = _u64(pkg.b, off + 8, limit)
    label_offset = _u16(pkg.b, off + 16, limit)
    flags = _u32(pkg.b, off + 18, limit)
    count = _i32(pkg.b, off + 22, limit)
    cursor = off + 26
    funcs = []
    if 0 <= count < 4096:
        for i in range(count):
            entry = cursor + i * 12
            if entry + 12 > limit:
                break
            funcs.append((_name(pkg, entry, limit), _i32(pkg.b, entry + 8, limit)))
        cursor += count * 12
    return {'probe_mask': probe, 'ignore_mask': ignore, 'label_offset': label_offset,
            'flags': flags, 'functions': funcs, 'end': cursor}


def class_info(pkg, export):
    info = state_info(pkg, export)
    limit = export['serial_offset'] + export['serial_size']
    off = info['end']
    flags = _u32(pkg.b, off, limit)
    within = _i32(pkg.b, off + 4, limit)
    config = _name(pkg, off + 8, limit)
    off += 16
    count = _i32(pkg.b, off, limit)
    off += 4
    components = []
    if 0 <= count < 65536:
        for i in range(count):
            entry = off + i * 12
            if entry + 12 > limit:
                break
            components.append((_name(pkg, entry, limit), _i32(pkg.b, entry + 8, limit)))
        off += count * 12
    interfaces = []
    count = _i32(pkg.b, off, limit)
    off += 4
    if 0 <= count < 65536:
        for i in range(count):
            entry = off + i * 8
            if entry + 8 > limit:
                break
            interfaces.append(pkg.obj_name(_i32(pkg.b, entry, limit)))
        off += count * 8
    groups = []
    for _ in range(4):
        count = _i32(pkg.b, off, limit)
        off += 4
        bucket = []
        if 0 <= count < 65536:
            for i in range(count):
                entry = off + i * 8
                if entry + 8 > limit:
                    break
                bucket.append(_name(pkg, entry, limit))
            off += count * 8
        groups.append(bucket)
    info.update({'class_flags': flags, 'within': pkg.obj_name(within), 'config': config,
                 'components': components, 'interfaces': interfaces,
                 'dont_sort_categories': groups[0], 'hide_categories': groups[1],
                 'auto_expand_categories': groups[2], 'auto_collapse_categories': groups[3]})
    return info


def property_info(pkg, export):
    base = field_base(pkg, export)
    limit = export['serial_offset'] + export['serial_size']
    kind = pkg.class_name(export)
    dim = _i32(pkg.b, base + PROPERTY_DIM_OFFSET, limit)
    flags = _u64(pkg.b, base + PROPERTY_FLAGS_OFFSET, limit)
    category = _name(pkg, base + PROPERTY_CATEGORY_OFFSET, limit)
    tail = base + PROPERTY_TAIL_OFFSET + (2 if flags & CPF_NET else 0)
    rep_offset = _u16(pkg.b, base + PROPERTY_TAIL_OFFSET, limit) if flags & CPF_NET else None
    return {'kind': kind, 'dim': dim if dim > 0 else 1, 'flags': flags,
            'category': category, 'tail': tail, 'limit': limit, 'rep_offset': rep_offset,
            'name': export['name'], 'export': export}


def property_type(pkg, export, depth=0):
    if depth > 8:
        return 'int'
    info = property_info(pkg, export)
    kind = info['kind']
    simple = SIMPLE_TYPES.get(kind)
    if simple is not None:
        return simple
    b = pkg.b
    tail = info['tail']
    limit = info['limit']
    first = _i32(b, tail, limit)
    if kind == 'ByteProperty':
        name = pkg.obj_name(first)
        return name if first and name != 'None' else 'byte'
    if kind == 'StructProperty':
        name = pkg.obj_name(first)
        return name if first else 'struct'
    if kind in ('ObjectProperty', 'ComponentProperty', 'InterfaceProperty'):
        name = pkg.obj_name(first)
        return name if first else 'Object'
    if kind == 'ClassProperty':
        meta = pkg.obj_name(_i32(b, tail + 4, limit))
        return 'class<%s>' % meta if meta != 'None' else 'class'
    if kind == 'DelegateProperty':
        target = pkg.obj_ref(first)
        return 'delegate<%s>' % (target['name'] if target else 'None')
    if kind == 'ArrayProperty':
        inner = pkg.export_at(first)
        return 'array<%s>' % (property_type(pkg, inner, depth + 1) if inner else 'int')
    if kind == 'MapProperty':
        key = pkg.export_at(first)
        value = pkg.export_at(_i32(b, tail + 4, limit))
        return 'map<%s, %s>' % (property_type(pkg, key, depth + 1) if key else 'int',
                                property_type(pkg, value, depth + 1) if value else 'int')
    if kind == 'FixedArrayProperty':
        inner = pkg.export_at(first)
        return property_type(pkg, inner, depth + 1) if inner else 'int'
    return kind


def _inner_node(node):
    while isinstance(node, dict) and node['op'] in TRANSPARENT_OPS:
        node = node.get('value')
    return node


def _call_scope(pkg, export):
    outer = export['outer']
    cache = getattr(pkg, 'scope_cache', None)
    if cache is None:
        cache = {}
        pkg.scope_cache = cache
    names = cache.get(outer)
    if names is None:
        names = set()
        parent = pkg.export_at(outer)
        if parent is not None:
            for child in children_of(pkg, parent):
                if pkg.class_name(child) == 'Function':
                    names.add(child['name'])
        cache[outer] = names
    return outer, names


class ExpressionWriter:
    def __init__(self, pkg, scope=None):
        self.pkg = pkg
        self.operators = {}
        self.scope_outer, self.scope_names = scope if scope else (None, ())
        self.context_depth = 0

    def operator_of(self, index):
        if not index:
            return None
        found = self.operators.get(index)
        if found is None:
            found = False
            if index < 0:
                ref = self.pkg.obj_ref(index)
                entry = IMPORT_OPERATORS.get(ref['name']) if ref is not None else None
                if entry is not None:
                    found = (entry[0], entry[1], False)
            else:
                target = self.pkg.export_at(index)
                if target is not None and self.pkg.class_name(target) == 'Function':
                    info = function_info(self.pkg, target)
                    if info['flags'] & (FUNC_OPERATOR | FUNC_PREOPERATOR):
                        name = info['friendly_name']
                        if name != 'None':
                            found = (name, info['precedence'],
                                     bool(info['flags'] & FUNC_PREOPERATOR))
            self.operators[index] = found
        return found or None

    def super_prefix(self, node):
        if self.context_depth or not self.scope_names:
            return ''
        target = self.pkg.export_at(node.get('func_index') or 0)
        if target is None or target['outer'] == self.scope_outer:
            return ''
        if target['name'] not in self.scope_names:
            return ''
        return 'Super.'

    def precedence(self, node):
        node = _inner_node(node)
        if not isinstance(node, dict):
            return 0
        op = node['op']
        if op == 'NativeCall' and node.get('kind') == 'operator' and len(node.get('args') or ()) == 2:
            return node.get('precedence') or 0
        if op == 'Conditional' or op in ASSIGN_OPS:
            return CONDITIONAL_PRECEDENCE
        return 0

    def wrap(self, node, parent, right=False):
        text = self.fmt(node)
        inner = self.precedence(node)
        if inner and parent and (inner > parent or (inner == parent and right)):
            return '(' + text + ')'
        return text

    def atom(self, node):
        text = self.fmt(node)
        if self.precedence(node):
            return '(' + text + ')'
        return text

    def args(self, nodes):
        parts = [self.fmt(n) for n in (nodes or ())]
        while parts and parts[-1] == '':
            parts.pop()
        return ', '.join(parts)

    def negate(self, node):
        node = _inner_node(node)
        if isinstance(node, dict) and node['op'] == 'NativeCall':
            items = node.get('args') or ()
            name = node.get('name')
            if node.get('kind') == 'preoperator' and name == '!' and len(items) == 1:
                return self.fmt(items[0])
            if node.get('kind') == 'operator' and len(items) == 2 and name in INVERSE_OPERATOR:
                prec = node.get('precedence') or 0
                if name in COMPARISONS:
                    items = _unwidened(items)
                return '%s %s %s' % (self.wrap(items[0], prec), INVERSE_OPERATOR[name],
                                     self.wrap(items[1], prec, True))
        return '!' + self.atom(node)

    def object_literal(self, node):
        index = node.get('value_index') or 0
        pkg = self.pkg
        ref = pkg.obj_ref(index)
        if ref is None:
            return 'none'
        path = pkg.object_path(index)
        if index > 0:
            kind = pkg.class_name(ref)
        else:
            kind = ref.get('class_name') or 'Object'
        if kind == 'Class':
            return "class'%s'" % path
        return "%s'%s'" % (kind, path)

    def fmt(self, node):
        if node is None:
            return ''
        if not isinstance(node, dict):
            return str(node)
        op = node['op']
        handler = _EXPRESSIONS.get(op)
        if handler is not None:
            return handler(self, node)
        if op in VARIABLE_OPS:
            return node.get('var') or ''
        return RAW_MARKER.strip() + op


def _e_variable(w, node):
    return node.get('var') or ''


def _e_default_variable(w, node):
    return 'default.' + (node.get('var') or '')


def _e_const(w, node):
    return str(node.get('value'))


def _e_float(w, node):
    return format_float(node.get('value') or 0.0)


def _e_string(w, node):
    return quote_string(node.get('value') or '')


def _e_name(w, node):
    return "'" + (node.get('value') or 'None') + "'"


def _e_rotation(w, node):
    return 'rot(%d, %d, %d)' % (node.get('pitch') or 0, node.get('yaw') or 0,
                                node.get('roll') or 0)


def _e_vector(w, node):
    return 'vect(%s, %s, %s)' % (format_float(node.get('x') or 0.0),
                                 format_float(node.get('y') or 0.0),
                                 format_float(node.get('z') or 0.0))


BYTE_TO_INT_CAST = 0x3A
COMPARISONS = frozenset(('==', '!=', '<', '>', '<=', '>='))


def _unwidened(items):
    for item in items:
        if not isinstance(item, dict) or item['op'] != 'PrimitiveCast':
            return items
        if item.get('cast') != BYTE_TO_INT_CAST:
            return items
    return [item.get('value') for item in items]


def _e_native(w, node):
    items = node.get('args') or ()
    kind = node.get('kind')
    name = node.get('name') or ''
    if kind == 'operator' and len(items) == 2:
        prec = node.get('precedence') or 0
        if name in COMPARISONS:
            items = _unwidened(items)
        return '%s %s %s' % (w.wrap(items[0], prec), name, w.wrap(items[1], prec, True))
    if kind == 'operator' and len(items) == 1:
        return '%s%s' % (w.atom(items[0]), name)
    if kind == 'preoperator' and len(items) == 1:
        return '%s%s' % (name, w.atom(items[0]))
    return '%s(%s)' % (name, w.args(items))


def _e_call(w, node):
    items = node.get('args') or ()
    operator = w.operator_of(node.get('func_index'))
    if operator is not None:
        name, prec, is_pre = operator
        if is_pre and len(items) == 1:
            return '%s%s' % (name, w.atom(items[0]))
        if len(items) == 2:
            return '%s %s %s' % (w.wrap(items[0], prec), name, w.wrap(items[1], prec, True))
        if len(items) == 1:
            return '%s%s' % (w.atom(items[0]), name)
    prefix = w.super_prefix(node) if node['op'] == 'FinalFunction' else ''
    return '%s%s(%s)' % (prefix, node.get('func') or '', w.args(items))


def _e_global_call(w, node):
    return 'Global.%s(%s)' % (node.get('func') or '', w.args(node.get('args')))


def _e_context(w, node):
    head = w.atom(node.get('object'))
    w.context_depth += 1
    try:
        member = w.fmt(node.get('member'))
    finally:
        w.context_depth -= 1
    return '%s.%s' % (head, member)


def _e_class_context(w, node):
    node_member = node.get('member')
    head = w.atom(node.get('object'))
    w.context_depth += 1
    try:
        member = w.fmt(node_member)
    finally:
        w.context_depth -= 1
    resolved = _inner_node(node_member)
    if isinstance(resolved, dict) and resolved['op'] == 'DefaultVariable':
        return '%s.%s' % (head, member)
    keyword = 'static' if isinstance(resolved, dict) and resolved['op'] in _CALL_OPS else 'default'
    return '%s.%s.%s' % (head, keyword, member)


def _e_struct_member(w, node):
    return '%s.%s' % (w.atom(node.get('value')), node.get('prop') or '')


def _e_element(w, node):
    return '%s[%s]' % (w.atom(node.get('array')), w.fmt(node.get('index')))


def _e_length(w, node):
    return '%s.Length' % w.atom(node.get('array'))


def _e_cast(w, node):
    return '%s(%s)' % (node.get('class') or '', w.fmt(node.get('value')))


def _e_meta_cast(w, node):
    return 'class<%s>(%s)' % (node.get('class') or '', w.fmt(node.get('value')))


def _e_primitive_cast(w, node):
    kind = node.get('cast_type') or node.get('cast_name') or ''
    return '%s(%s)' % (kind, w.fmt(node.get('value')))


def _e_assign(w, node):
    return '%s = %s' % (w.fmt(node.get('target')),
                        w.wrap(node.get('value'), CONDITIONAL_PRECEDENCE, True))


def _e_conditional(w, node):
    return '%s ? %s : %s' % (w.wrap(node.get('condition'), CONDITIONAL_PRECEDENCE),
                             w.fmt(node.get('true')), w.fmt(node.get('false')))


def _e_cmp_eq(w, node):
    return '%s == %s' % (w.fmt(node.get('left')), w.fmt(node.get('right')))


def _e_cmp_ne(w, node):
    return '%s != %s' % (w.fmt(node.get('left')), w.fmt(node.get('right')))


def _e_delegate(w, node):
    return node.get('func') or ''


def _e_new(w, node):
    head = w.args([node.get('outer'), node.get('name'), node.get('flags')])
    template = w.fmt(node.get('template'))
    body = '%s' % w.fmt(node.get('class'))
    if template:
        body += '(%s)' % template
    return 'new(%s) %s' % (head, body) if head else 'new %s' % body


def _e_inner(w, node):
    return w.fmt(node.get('value'))


def _e_empty(w, node):
    return ''


def _e_none(w, node):
    return 'none'


def _e_self(w, node):
    return 'self'


def _e_return(w, node):
    inner = w.fmt(node.get('value'))
    return 'return ' + inner if inner else 'return'


def _e_assert(w, node):
    return 'assert(%s)' % w.fmt(node.get('condition'))


def _e_stop(w, node):
    return 'Stop'


def _e_goto_label(w, node):
    return 'goto ' + w.fmt(node.get('label'))


def _e_array_method(name, *fields):
    def render(w, node):
        return '%s.%s(%s)' % (w.atom(node.get('array')), name,
                              ', '.join(w.fmt(node.get(f)) for f in fields))
    return render


def _e_unknown(w, node):
    return '%sUNKNOWN_%02X' % (RAW_MARKER, node.get('code', 0))


_CALL_OPS = frozenset(('VirtualFunction', 'FinalFunction', 'GlobalFunction',
                       'DelegateFunction', 'NativeCall'))

_EXPRESSIONS = {
    'DefaultVariable': _e_default_variable,
    'Self': _e_self,
    'Nothing': _e_empty, 'EmptyParmValue': _e_empty, 'NoParm': _e_empty,
    'ReturnNothing': _e_empty, 'EatReturnValue': _e_empty,
    'NoObject': _e_none, 'EmptyDelegate': _e_none,
    'IntZero': lambda w, n: '0', 'IntOne': lambda w, n: '1',
    'True': lambda w, n: 'true', 'False': lambda w, n: 'false',
    'IntConst': _e_const, 'IntConstByte': _e_const, 'ByteConst': _e_const,
    'FloatConst': _e_float,
    'StringConst': _e_string, 'UnicodeStringConst': _e_string,
    'NameConst': _e_name,
    'ObjectConst': lambda w, n: w.object_literal(n),
    'RotationConst': _e_rotation, 'VectorConst': _e_vector,
    'NativeCall': _e_native,
    'VirtualFunction': _e_call, 'FinalFunction': _e_call, 'DelegateFunction': _e_call,
    'GlobalFunction': _e_global_call,
    'Context': _e_context, 'ClassContext': _e_class_context,
    'InterfaceContext': _e_inner, 'FilterEditorOnly': _e_inner,
    'Skip': _e_inner, 'DefaultParmValue': _e_inner, 'BoolVariable': _e_inner,
    'StructMember': _e_struct_member,
    'ArrayElement': _e_element, 'DynArrayElement': _e_element,
    'DynArrayLength': _e_length,
    'DynamicCast': _e_cast, 'InterfaceCast': _e_cast, 'MetaCast': _e_meta_cast,
    'PrimitiveCast': _e_primitive_cast,
    'Let': _e_assign, 'LetBool': _e_assign, 'LetDelegate': _e_assign,
    'Conditional': _e_conditional,
    'StructCmpEq': _e_cmp_eq, 'StructCmpNe': _e_cmp_ne,
    'EqualEqual_DelDel': _e_cmp_eq, 'EqualEqual_DelFunc': _e_cmp_eq,
    'NotEqual_DelDel': _e_cmp_ne, 'NotEqual_DelFunc': _e_cmp_ne,
    'InstanceDelegate': _e_delegate, 'DelegateProperty': _e_delegate,
    'New': _e_new,
    'Return': _e_return, 'Assert': _e_assert, 'Stop': _e_stop,
    'GotoLabel': _e_goto_label,
    'DynArrayAdd': _e_array_method('Add', 'item'),
    'DynArrayAddItem': _e_array_method('AddItem', 'item'),
    'DynArrayRemoveItem': _e_array_method('RemoveItem', 'item'),
    'DynArrayInsertItem': _e_array_method('InsertItem', 'index', 'item'),
    'DynArrayInsert': _e_array_method('Insert', 'index', 'count'),
    'DynArrayRemove': _e_array_method('Remove', 'index', 'count'),
    'DynArrayFind': _e_array_method('Find', 'item'),
    'DynArrayFindStruct': _e_array_method('Find', 'prop', 'item'),
    'DynArraySort': _e_array_method('Sort', 'comparator'),
    'UNKNOWN': _e_unknown,
}


class FlowWriter:
    def __init__(self, pkg, body, labels=None, scope=None):
        self.pkg = pkg
        self.expr = ExpressionWriter(pkg, scope)
        self.reader = body['reader'] if body else None
        self.statements = list(body['statements']) if body else []
        self.labels = dict(labels) if labels else {}
        self.hidden = set()
        self.epilogue = set()
        self.index = {}
        self.tail_mem = body['memory_size'] if body else 0
        self.optional_defaults = []
        self._prepare()

    def _prepare(self):
        for i, node in enumerate(self.statements):
            self.index[node['mem']] = i
            if node['op'] == 'LabelTable':
                for name, target in node.get('labels') or ():
                    if name != 'None':
                        self.labels[target] = name
            if node['op'] in HIDDEN_OPS:
                self.hidden.add(i)
        i = 0
        while i < len(self.statements):
            op = self.statements[i]['op']
            if op == 'Nothing':
                self.optional_defaults.append(None)
            elif op == 'DefaultParmValue':
                self.optional_defaults.append(self.expr.fmt(self.statements[i].get('value')))
            else:
                break
            self.hidden.add(i)
            i += 1
        j = len(self.statements) - 1
        while j >= 0 and self.statements[j]['op'] in ('EndOfScript', 'EOF'):
            self.hidden.add(j)
            self.epilogue.add(j)
            j -= 1
        if j >= 0:
            node = self.statements[j]
            value = node.get('value')
            if node['op'] == 'Return' and (value is None or
                                           (isinstance(value, dict) and
                                            value['op'] in ('ReturnNothing', 'Nothing'))):
                self.hidden.add(j)
                self.epilogue.add(j)

    def block_end_mem(self, hi):
        if hi < len(self.statements):
            return self.statements[hi]['mem']
        return self.tail_mem

    def render(self):
        lines = []
        self.emit(0, len(self.statements), (None, None), 0, lines, 0)
        return lines

    def emit(self, lo, hi, ctx, ind, lines, depth):
        i = lo
        while i < hi:
            before = i
            i = self.emit_one(i, hi, ctx, ind, lines, depth)
            if i <= before:
                i = before + 1
        return i

    def emit_block(self, lo, hi, ctx, ind, lines, depth):
        lines.append((ind, '{'))
        self.emit(lo, hi, ctx, ind + 1, lines, depth + 1)
        lines.append((ind, '}'))

    def statement(self, node, ind, lines):
        text = self.expr.fmt(node)
        if text:
            lines.append((ind, text + ';'))

    def jump_action(self, target, ctx):
        cont = ctx[1]
        if cont is not None and (target in cont if isinstance(cont, tuple) else target == cont):
            return 'continue'
        if ctx[0] is not None and target == ctx[0]:
            return 'break'
        name = self.labels.get(target)
        if name is not None:
            return 'goto ' + name
        return None

    def emit_one(self, i, hi, ctx, ind, lines, depth):
        node = self.statements[i]
        label = self.labels.get(node['mem'])
        if label is not None:
            lines.append((max(ind - 1, 0), label + ':'))
        if i in self.hidden:
            return i + 1
        if depth >= MAX_FLOW_DEPTH:
            self.statement(node, ind, lines)
            return i + 1
        loop = self.loop_at(i, hi)
        if loop is not None:
            return self.emit_loop(i, hi, loop, ctx, ind, lines, depth)
        op = node['op']
        if op == 'JumpIfNot':
            return self.emit_if(i, hi, ctx, ind, lines, depth)
        if op == 'Jump':
            target = node.get('target') or 0
            action = self.jump_action(target, ctx)
            if action is None:
                landing = self.index.get(target)
                if landing == hi or landing == i + 1:
                    return i + 1
                if landing is not None and landing in self.epilogue:
                    action = 'return'
            lines.append((ind, (action or ('%sgoto 0x%04X' % (RAW_MARKER, target))) + ';'))
            return i + 1
        if op == 'Switch':
            return self.emit_switch(i, hi, ctx, ind, lines, depth)
        if op == 'Iterator' or op == 'DynArrayIterator':
            return self.emit_foreach(i, hi, ctx, ind, lines, depth)
        if op == 'Case':
            lines.append((ind, RAW_MARKER + self.expr.fmt(node)))
            return i + 1
        self.statement(node, ind, lines)
        return i + 1

    def loop_at(self, i, hi):
        head = self.statements[i]['mem']
        if head in self.labels:
            return None
        closer = -1
        for k in range(i, hi):
            node = self.statements[k]
            if node['op'] in ('Jump', 'JumpIfNot') and node.get('target') == head:
                closer = k
        if closer < 0:
            return None
        return closer

    def emit_loop(self, i, hi, closer, ctx, ind, lines, depth):
        head = self.statements[i]
        back = self.statements[closer]
        if (head['op'] == 'JumpIfNot' and (head.get('target') or 0) > head['mem']
                and back['op'] == 'Jump' and closer > i):
            exit_mem = head.get('target') or 0
            return self.emit_while(i, closer, exit_mem, head.get('condition'),
                                   ctx, ind, lines, depth, hi)
        if back['op'] == 'JumpIfNot':
            exit_mem = back.get('mem_end') or back['mem']
            inner = (exit_mem, back['mem'])
            body = []
            self.emit(i, closer, inner, ind + 1, body, depth + 1)
            lines.append((ind, 'do'))
            lines.append((ind, '{'))
            lines.extend(body)
            lines.append((ind, '} until (%s);' % self.expr.fmt(back.get('condition'))))
            return closer + 1
        exit_mem = back.get('mem_end') or back['mem']
        inner = (exit_mem, (head['mem'], back['mem']))
        lines.append((ind, 'while (true)'))
        self.emit_block(i, closer, inner, ind, lines, depth)
        return closer + 1

    def emit_while(self, i, closer, exit_mem, condition, ctx, ind, lines, depth, hi):
        head = self.statements[i]
        back = self.statements[closer]
        body_lo, body_hi = i + 1, closer
        step = None
        if body_hi > body_lo:
            last = self.statements[body_hi - 1]
            step = self.step_variable(last)
            if step is not None:
                if self.targets_within(body_lo, body_hi, back['mem']):
                    step = None
                elif not self.targets_within(body_lo, body_hi, last['mem']) \
                        and step not in self.expr.fmt(head.get('condition')):
                    step = None
        if step is None:
            inner = (exit_mem, (head['mem'], back['mem']))
            lines.append((ind, 'while (%s)' % self.expr.fmt(condition)))
            self.emit_block(body_lo, body_hi, inner, ind, lines, depth)
            return self.after(closer, exit_mem)
        inc_node = self.statements[body_hi - 1]
        inner = (exit_mem, inc_node['mem'])
        init = ''
        if i > 0 and (i - 1) not in self.hidden:
            candidate = self.statements[i - 1]
            if candidate['op'] in ASSIGN_OPS and self.expr.fmt(candidate.get('target')) == step:
                if lines and lines[-1][1] == self.expr.fmt(candidate) + ';':
                    lines.pop()
                    init = self.expr.fmt(candidate)
        lines.append((ind, 'for (%s; %s; %s)' % (init, self.expr.fmt(condition),
                                                 self.expr.fmt(inc_node))))
        self.emit_block(body_lo, body_hi - 1, inner, ind, lines, depth)
        return self.after(closer, exit_mem)

    def after(self, closer, exit_mem):
        target = self.index.get(exit_mem)
        if target is not None and target > closer:
            return target
        return closer + 1

    def step_variable(self, node):
        if node['op'] == 'NativeCall' and node.get('name') in ('++', '--'):
            items = node.get('args') or ()
            if len(items) == 1:
                return self.expr.fmt(items[0])
            return None
        if node['op'] in ASSIGN_OPS:
            value = node.get('value')
            if isinstance(value, dict) and value['op'] == 'NativeCall' \
                    and value.get('name') in ('+', '-') and len(value.get('args') or ()) == 2:
                target = self.expr.fmt(node.get('target'))
                if self.expr.fmt(value['args'][0]) == target:
                    return target
        return None

    def targets_within(self, lo, hi, mem):
        for k in range(lo, hi):
            node = self.statements[k]
            if node['op'] in ('Jump', 'JumpIfNot') and node.get('target') == mem:
                return True
        return False

    def emit_if(self, i, hi, ctx, ind, lines, depth):
        node = self.statements[i]
        target = node.get('target') or 0
        condition = node.get('condition')
        end = self.index.get(target)
        if end is None or end > hi or end <= i:
            action = self.jump_action(target, ctx)
            if action is None:
                lines.append((ind, '%sif (%s) goto 0x%04X;' % (
                    RAW_MARKER, self.expr.negate(condition), target)))
            else:
                lines.append((ind, 'if (%s)' % self.expr.negate(condition)))
                lines.append((ind, '{'))
                lines.append((ind + 1, action + ';'))
                lines.append((ind, '}'))
            return i + 1
        body_hi = end
        else_lo = else_hi = None
        if body_hi - 1 > i:
            last = self.statements[body_hi - 1]
            if last['op'] == 'Jump':
                jump_target = last.get('target') or 0
                if jump_target > target and self.jump_action(jump_target, ctx) is None:
                    stop = self.index.get(jump_target)
                    if stop is not None and end < stop <= hi:
                        body_hi -= 1
                        else_lo, else_hi = end, stop
        if else_lo is not None and body_hi == i + 1:
            lines.append((ind, 'if (%s)' % self.expr.negate(condition)))
            self.emit_block(else_lo, else_hi, ctx, ind, lines, depth)
            return else_hi
        lines.append((ind, 'if (%s)' % self.expr.fmt(condition)))
        self.emit_block(i + 1, body_hi, ctx, ind, lines, depth)
        if else_lo is None:
            return end
        probe = []
        nxt = self.emit_one(else_lo, else_hi, ctx, ind, probe, depth)
        if nxt == else_hi and probe and probe[0][1].startswith('if (') and probe[0][0] == ind:
            probe[0] = (ind, 'else ' + probe[0][1])
            lines.extend(probe)
        else:
            lines.append((ind, 'else'))
            self.emit_block(else_lo, else_hi, ctx, ind, lines, depth)
        return else_hi

    def emit_switch(self, i, hi, ctx, ind, lines, depth):
        node = self.statements[i]
        cases = []
        j = i + 1
        while j < hi and self.statements[j]['op'] == 'Case':
            entry = self.statements[j]
            if entry.get('default'):
                cases.append((j, None))
                j += 1
                break
            nxt = self.index.get(entry.get('next'))
            cases.append((j, nxt))
            if nxt is None or nxt <= j:
                j += 1
                break
            j = nxt
        if not cases:
            self.statement(node, ind, lines)
            return i + 1
        end_mem = self.switch_end(cases, hi)
        end_index = self.index.get(end_mem)
        if end_index is None or end_index <= cases[-1][0]:
            end_index = hi
        inner = (end_mem, ctx[1])
        lines.append((ind, 'switch (%s)' % self.expr.fmt(node.get('value'))))
        lines.append((ind, '{'))
        for position, (start, nxt) in enumerate(cases):
            entry = self.statements[start]
            head = 'default:' if entry.get('default') else 'case %s:' % self.expr.fmt(entry.get('value'))
            lines.append((ind + 1, head))
            body_hi = nxt if nxt is not None else end_index
            if body_hi is None or body_hi > end_index:
                body_hi = end_index
            self.emit(start + 1, body_hi, inner, ind + 2, lines, depth + 1)
        lines.append((ind, '}'))
        return end_index

    def switch_end(self, cases, hi):
        targets = []
        last_start = cases[-1][0]
        for start, nxt in cases:
            stop = nxt if nxt is not None else hi
            if stop is None or stop > hi:
                stop = hi
            if stop - 1 > start:
                tail = self.statements[stop - 1]
                if tail['op'] == 'Jump' and (tail.get('target') or 0) > self.statements[last_start]['mem']:
                    targets.append(tail['target'])
        if targets:
            return min(targets)
        return self.block_end_mem(hi)

    def emit_foreach(self, i, hi, ctx, ind, lines, depth):
        node = self.statements[i]
        target = node.get('target') or 0
        end = self.index.get(target)
        if end is None or end > hi or end <= i:
            end = hi
        body_hi = end
        continue_mem = None
        if body_hi - 1 > i and self.statements[body_hi - 1]['op'] == 'IteratorPop':
            body_hi -= 1
        if body_hi - 1 > i and self.statements[body_hi - 1]['op'] == 'IteratorNext':
            continue_mem = self.statements[body_hi - 1]['mem']
            body_hi -= 1
        if node['op'] == 'Iterator':
            header = 'foreach %s' % self.expr.fmt(node.get('value'))
        else:
            parts = [self.expr.fmt(node.get('item'))]
            if node.get('with_index'):
                parts.append(self.expr.fmt(node.get('index')))
            header = 'foreach %s(%s)' % (self.expr.atom(node.get('array')), ', '.join(parts))
        inner = (target, continue_mem)
        lines.append((ind, header))
        self.emit_block(i + 1, body_hi, inner, ind, lines, depth)
        return end


def _flatten(lines):
    return '\n'.join(INDENT * level + text for level, text in lines)


def _parameters(pkg, export):
    params = []
    locals_ = []
    result = None
    for child in children_of(pkg, export):
        if pkg.class_name(child) not in package.PROPERTY_REF_COUNT:
            continue
        info = property_info(pkg, child)
        info['type'] = property_type(pkg, child)
        if info['flags'] & CPF_RETURN:
            result = info
        elif info['flags'] & CPF_PARM:
            params.append(info)
        else:
            locals_.append(info)
    return params, locals_, result


def _declaration(info):
    text = info['type']
    if info['dim'] > 1:
        return '%s %s[%d]' % (text, info['name'], info['dim'])
    return '%s %s' % (text, info['name'])


def _parameter_text(info, default):
    flags = info['flags']
    words = []
    if flags & CPF_OPTIONAL:
        words.append('optional')
    if flags & CPF_OUT:
        words.append('out')
    if flags & CPF_COERCE:
        words.append('coerce')
    if flags & CPF_CONST:
        words.append('const')
    if flags & CPF_SKIP:
        words.append('skip')
    words.append(_declaration(info))
    text = ' '.join(words)
    if default:
        text += ' = ' + default
    return text


def function_modifiers(info):
    flags = info['flags']
    words = []
    if flags & FUNC_NATIVE:
        words.append('native(%d)' % info['native_index'] if info['native_index'] else 'native')
    if flags & FUNC_NET:
        words.append('reliable' if flags & FUNC_NET_RELIABLE else 'unreliable')
        if flags & FUNC_NET_SERVER:
            words.append('server')
        if flags & FUNC_NET_CLIENT:
            words.append('client')
    if flags & FUNC_PRIVATE:
        words.append('private')
    elif flags & FUNC_PROTECTED:
        words.append('protected')
    if flags & FUNC_STATIC:
        words.append('static')
    if flags & FUNC_FINAL:
        words.append('final')
    if flags & FUNC_SIMULATED:
        words.append('simulated')
    if flags & FUNC_SINGULAR:
        words.append('singular')
    if flags & FUNC_LATENT:
        words.append('latent')
    if flags & FUNC_ITERATOR:
        words.append('iterator')
    if flags & FUNC_EXEC:
        words.append('exec')
    if flags & FUNC_CONST:
        words.append('const')
    return words


def function_keyword(info):
    flags = info['flags']
    if flags & FUNC_DELEGATE:
        return 'delegate'
    if flags & FUNC_PREOPERATOR:
        return 'preoperator'
    if flags & FUNC_OPERATOR:
        return 'operator(%d)' % info['precedence']
    if flags & FUNC_EVENT:
        return 'event'
    return 'function'


def function_signature(pkg, export, defaults=None):
    info = function_info(pkg, export)
    params, locals_, result = _parameters(pkg, export)
    words = function_modifiers(info)
    words.append(function_keyword(info))
    if result is not None:
        words.append(result['type'])
    optional_index = 0
    rendered = []
    for item in params:
        default = None
        if item['flags'] & CPF_OPTIONAL:
            if defaults and optional_index < len(defaults):
                default = defaults[optional_index]
            optional_index += 1
        rendered.append(_parameter_text(item, default))
    name = info['friendly_name'] if info['friendly_name'] != 'None' else export['name']
    return '%s %s(%s)' % (' '.join(words), name, ', '.join(rendered)), locals_, info


def _local_lines(locals_, ind):
    lines = []
    group = []
    current = None
    for item in locals_:
        text = item['type']
        entry = item['name'] if item['dim'] == 1 else '%s[%d]' % (item['name'], item['dim'])
        if text != current and group:
            lines.append((ind, 'local %s %s;' % (current, ', '.join(group))))
            group = []
        current = text
        group.append(entry)
    if group:
        lines.append((ind, 'local %s %s;' % (current, ', '.join(group))))
    return lines


def decompile_function(pkg, export, indent=0):
    try:
        body = script_body(pkg, export)
    except Exception:
        body = None
    defaults = []
    flow = None
    if body is not None:
        try:
            flow = FlowWriter(pkg, body, None, _call_scope(pkg, export))
            defaults = flow.optional_defaults
        except Exception:
            flow = None
    try:
        signature, locals_, info = function_signature(pkg, export, defaults)
    except Exception:
        return INDENT * indent + RAW_MARKER + 'unreadable function %s' % export['name']
    if body is None or flow is None or info['flags'] & FUNC_NATIVE:
        return INDENT * indent + signature + ';'
    lines = [(indent, signature), (indent, '{')]
    lines.extend(_local_lines(locals_, indent + 1))
    if locals_:
        lines.append((indent + 1, ''))
    try:
        lines.extend((level + indent + 1, text) for level, text in flow.render())
    except Exception as exc:
        lines.append((indent + 1, RAW_MARKER + 'flow reconstruction failed: %s' % exc))
        for node in body['statements']:
            lines.append((indent + 1, '%s%04X %s' % (RAW_MARKER, node['mem'],
                                                     bytecode.format_expr(node))))
    lines.append((indent, '}'))
    return _flatten(lines)


def state_modifiers(info):
    words = []
    flags = info['flags']
    if flags & STATE_AUTO:
        words.append('auto')
    if flags & STATE_SIMULATED:
        words.append('simulated')
    return words


def decompile_state(pkg, export, indent=0):
    try:
        info = state_info(pkg, export)
    except Exception:
        return INDENT * indent + RAW_MARKER + 'unreadable state %s' % export['name']
    words = state_modifiers(info)
    words.append('state')
    header = ' '.join(words) + ' ' + export['name']
    parent = pkg.obj_name(_i32(pkg.b, field_base(pkg, export) + SUPER_OFFSET, len(pkg.b)))
    if parent != 'None' and parent != export['name']:
        header += ' extends ' + parent
    lines = [(indent, header), (indent, '{')]
    functions = [child for child in children_of(pkg, export)
                 if pkg.class_name(child) == 'Function']
    for child in functions:
        lines.append((0, decompile_function(pkg, child, indent + 1)))
        lines.append((indent + 1, ''))
    body = None
    try:
        body = script_body(pkg, export)
    except Exception:
        body = None
    if body is not None:
        try:
            flow = FlowWriter(pkg, body, None, _call_scope(pkg, export))
            rendered = flow.render()
        except Exception as exc:
            rendered = [(0, RAW_MARKER + 'flow reconstruction failed: %s' % exc)]
        for level, text in rendered:
            lines.append((level + indent + 1, text))
    lines.append((indent, '}'))
    out = []
    for level, text in lines:
        out.append(text if level == 0 and text.startswith(INDENT) else INDENT * level + text)
    return '\n'.join(out)


def _enum_values(pkg, export):
    base = field_base(pkg, export)
    limit = export['serial_offset'] + export['serial_size']
    count = _i32(pkg.b, base + ENUM_NAMES_OFFSET, limit)
    values = []
    if 0 <= count < 65536:
        for i in range(count):
            values.append(_name(pkg, base + ENUM_NAMES_OFFSET + 4 + i * 8, limit))
    if values and values[-1].endswith('_MAX'):
        values.pop()
    return values


def decompile_enum(pkg, export, indent=0):
    lines = [(indent, 'enum %s' % export['name']), (indent, '{')]
    for value in _enum_values(pkg, export):
        lines.append((indent + 1, value + ','))
    lines.append((indent, '};'))
    return _flatten(lines)


def decompile_const(pkg, export, indent=0):
    base = field_base(pkg, export)
    limit = export['serial_offset'] + export['serial_size']
    text, _ = package.read_fstring(pkg.b, base + CONST_VALUE_OFFSET, limit)
    return INDENT * indent + 'const %s = %s;' % (export['name'], text or '0')


def variable_modifiers(info):
    flags = info['flags']
    words = []
    if flags & CPF_CONST:
        words.append('const')
    if flags & CPF_NATIVE:
        words.append('native')
    if flags & CPF_PRIVATE_WRITE:
        words.append('privatewrite')
    elif flags & CPF_PROTECTED_WRITE:
        words.append('protectedwrite')
    if flags & CPF_GLOBAL_CONFIG:
        words.append('globalconfig')
    elif flags & CPF_CONFIG:
        words.append('config')
    if flags & CPF_LOCALIZED:
        words.append('localized')
    if flags & CPF_TRANSIENT:
        words.append('transient')
    if flags & CPF_DUPLICATE_TRANSIENT:
        words.append('duplicatetransient')
    if flags & CPF_REP_NOTIFY:
        words.append('repnotify')
    elif flags & CPF_REP_RETRY:
        words.append('repretry')
    if flags & CPF_INPUT:
        words.append('input')
    if flags & CPF_TRAVEL:
        words.append('travel')
    if flags & CPF_EXPORT:
        words.append('export')
    if flags & CPF_NO_EXPORT:
        words.append('noexport')
    if flags & CPF_EDIT_CONST:
        words.append('editconst')
    if flags & CPF_EDIT_FIXED_SIZE:
        words.append('editfixedsize')
    if flags & CPF_EDIT_INLINE:
        words.append('editinline')
    if flags & CPF_NO_CLEAR:
        words.append('noclear')
    if flags & CPF_INTERP:
        words.append('interp')
    if flags & CPF_NON_TRANSACTIONAL:
        words.append('nontransactional')
    if flags & CPF_EDITOR_ONLY:
        words.append('editoronly')
    if flags & CPF_NOT_FOR_CONSOLE:
        words.append('notforconsole')
    if flags & CPF_DATA_BINDING:
        words.append('databinding')
    if flags & CPF_DEPRECATED:
        words.append('deprecated')
    return words


def decompile_variable(pkg, export, owner=None, indent=0):
    info = property_info(pkg, export)
    info['type'] = property_type(pkg, export)
    head = 'var'
    if info['flags'] & CPF_EDIT:
        category = info['category']
        if category == 'None' or (owner is not None and category == owner):
            head = 'var()'
        else:
            head = 'var(%s)' % category
    words = [head] + variable_modifiers(info) + [_declaration(info)]
    return INDENT * indent + ' '.join(words) + ';'


def struct_modifiers(flags):
    words = []
    if flags & STRUCT_NATIVE:
        words.append('native')
    if flags & STRUCT_EXPORT:
        words.append('export')
    if flags & STRUCT_TRANSIENT:
        words.append('transient')
    if flags & (STRUCT_IMMUTABLE | STRUCT_IMMUTABLE_WHEN_COOKED):
        words.append('immutable')
    elif flags & (STRUCT_ATOMIC | STRUCT_ATOMIC_WHEN_COOKED):
        words.append('atomic')
    return words


def decompile_struct(pkg, export, indent=0):
    base = field_base(pkg, export)
    limit = export['serial_offset'] + export['serial_size']
    flags = _u32(pkg.b, base + STRUCT_FLAGS_OFFSET, limit)
    words = ['struct'] + struct_modifiers(flags) + [export['name']]
    parent = pkg.obj_name(_i32(pkg.b, base + SUPER_OFFSET, limit))
    header = ' '.join(words)
    if parent != 'None':
        header += ' extends ' + parent
    lines = [(indent, header), (indent, '{')]
    body = []
    for child in children_of(pkg, export):
        kind = pkg.class_name(child)
        if kind == 'ScriptStruct':
            body.append(decompile_struct(pkg, child, indent + 1))
        elif kind == 'Enum':
            body.append(decompile_enum(pkg, child, indent + 1))
        elif kind == 'Const':
            body.append(decompile_const(pkg, child, indent + 1))
        elif kind in package.PROPERTY_REF_COUNT:
            body.append(decompile_variable(pkg, child, export['name'], indent + 1))
    text = _flatten(lines)
    if body:
        text += '\n' + '\n'.join(body)
    return text + '\n' + INDENT * indent + '};'


def class_modifiers(pkg, info):
    flags = info['class_flags']
    words = []
    if flags & CLASS_ABSTRACT:
        words.append('abstract')
    if flags & CLASS_NATIVE:
        words.append('native')
    if flags & CLASS_NATIVE_REPLICATION:
        words.append('nativereplication')
    if flags & CLASS_NO_EXPORT:
        words.append('noexport')
    if flags & CLASS_PLACEABLE:
        words.append('placeable')
    else:
        words.append('notplaceable')
    if flags & CLASS_TRANSIENT:
        words.append('transient')
    if flags & CLASS_PER_OBJECT_CONFIG:
        words.append('perobjectconfig')
    if flags & CLASS_EDIT_INLINE_NEW:
        words.append('editinlinenew')
    if flags & CLASS_COLLAPSE_CATEGORIES:
        words.append('collapsecategories')
    if flags & CLASS_DEPRECATED:
        words.append('deprecated')
    if flags & CLASS_HIDE_DROPDOWN:
        words.append('hidedropdown')
    if info['config'] != 'None':
        words.append('config(%s)' % info['config'])
    if info['within'] not in ('None', 'Object'):
        words.append('within %s' % info['within'])
    if info['hide_categories']:
        words.append('hidecategories(%s)' % ','.join(info['hide_categories']))
    if info['auto_expand_categories']:
        words.append('autoexpandcategories(%s)' % ','.join(info['auto_expand_categories']))
    if info['interfaces']:
        words.append('implements(%s)' % ','.join(info['interfaces']))
    return words


def _default_value(pkg, value, depth=0):
    if depth > 8:
        return '...'
    if isinstance(value, bool):
        return 'True' if value else 'False'
    if isinstance(value, float):
        return format_float(value)
    if isinstance(value, int):
        return str(value)
    if isinstance(value, str):
        return quote_string(value)
    if isinstance(value, dict):
        inner = ','.join('%s=%s' % (key, _default_value(pkg, item, depth + 1))
                         for key, item in value.items())
        return '(%s)' % inner
    if isinstance(value, tuple):
        return _default_value(pkg, value[0], depth + 1)
    if isinstance(value, (bytes, bytearray)):
        return RAW_MARKER + value.hex()
    if isinstance(value, list):
        return '(%s)' % ','.join(_default_value(pkg, item, depth + 1) for item in value)
    return str(value)


def default_properties(pkg, export, indent=0):
    default = None
    for candidate in pkg.find('Default__' + export['name']):
        if candidate['flags'] & RF_CLASS_DEFAULT_OBJECT:
            default = candidate
            break
    lines = [(indent, 'defaultproperties'), (indent, '{')]
    if default is not None:
        try:
            props, _ = pkg.export_properties(default)
        except Exception:
            props = {}
        for key, value in props.items():
            if isinstance(value, list):
                for position, item in enumerate(value):
                    lines.append((indent + 1, '%s(%d)=%s' % (key, position,
                                                             _default_value(pkg, item))))
            else:
                lines.append((indent + 1, '%s=%s' % (key, _default_value(pkg, value))))
    lines.append((indent, '}'))
    return _flatten(lines)


def replication_block(pkg, export, variables, indent=0):
    nets = [item for item in variables if item['rep_offset'] is not None]
    if not nets:
        return ''
    body = script_body(pkg, export)
    if body is None:
        return ''
    writer = ExpressionWriter(pkg)
    groups = {}
    order = []
    for item in nets:
        offset = item['rep_offset']
        if offset not in groups:
            groups[offset] = []
            order.append(offset)
        groups[offset].append(item['name'])
    lines = [(indent, 'replication'), (indent, '{')]
    for offset in order:
        node = body['reader'].by_mem.get(offset)
        condition = writer.fmt(node) if node is not None else ''
        if condition:
            lines.append((indent + 1, 'if (%s)' % condition))
            lines.append((indent + 2, ', '.join(groups[offset]) + ';'))
        else:
            lines.append((indent + 1, RAW_MARKER + 'rep@0x%04X' % offset))
            lines.append((indent + 1, ', '.join(groups[offset]) + ';'))
    lines.append((indent, '}'))
    return _flatten(lines)


def decompile_class(pkg, export, indent=0):
    if pkg.class_name(export) != 'Class':
        raise ValueError('not a class export: %s' % export['name'])
    try:
        info = class_info(pkg, export)
    except Exception:
        info = {'class_flags': 0, 'within': 'None', 'config': 'None', 'interfaces': [],
                'hide_categories': [], 'auto_expand_categories': [], 'flags': 0}
    parent = pkg.obj_name(_i32(pkg.b, field_base(pkg, export) + SUPER_OFFSET, len(pkg.b)))
    header = 'class %s' % export['name']
    if parent != 'None':
        header += ' extends ' + parent
    words = class_modifiers(pkg, info)
    chunks = [INDENT * indent + header]
    if words:
        chunks[0] += '\n' + INDENT * (indent + 1) + '\n'.join(
            INDENT * (indent + 1) + w if i else w for i, w in enumerate(words))
    chunks[0] += ';'
    consts, enums, structs, variables, functions, states = [], [], [], [], [], []
    for child in children_of(pkg, export):
        kind = pkg.class_name(child)
        if kind == 'Const':
            consts.append(child)
        elif kind == 'Enum':
            enums.append(child)
        elif kind == 'ScriptStruct':
            structs.append(child)
        elif kind == 'State':
            states.append(child)
        elif kind == 'Function':
            functions.append(child)
        elif kind in package.PROPERTY_REF_COUNT:
            variables.append(child)
    if consts:
        chunks.append('\n'.join(decompile_const(pkg, item, indent) for item in consts))
    for item in enums:
        chunks.append(decompile_enum(pkg, item, indent))
    for item in structs:
        chunks.append(decompile_struct(pkg, item, indent))
    if variables:
        chunks.append('\n'.join(decompile_variable(pkg, item, export['name'], indent)
                                for item in variables))
    rep = replication_block(pkg, export, [property_info(pkg, item) for item in variables], indent)
    if rep:
        chunks.append(rep)
    for item in functions:
        chunks.append(decompile_function(pkg, item, indent))
    for item in states:
        chunks.append(decompile_state(pkg, item, indent))
    chunks.append(default_properties(pkg, export, indent))
    return '\n\n'.join(chunk for chunk in chunks if chunk)


def decompile_export(pkg, export, indent=0):
    kind = pkg.class_name(export)
    if kind == 'Class':
        return decompile_class(pkg, export, indent)
    if kind == 'Function':
        return decompile_function(pkg, export, indent)
    if kind == 'State':
        return decompile_state(pkg, export, indent)
    if kind == 'ScriptStruct':
        return decompile_struct(pkg, export, indent)
    if kind == 'Enum':
        return decompile_enum(pkg, export, indent)
    if kind == 'Const':
        return decompile_const(pkg, export, indent)
    if kind in package.PROPERTY_REF_COUNT:
        return decompile_variable(pkg, export, None, indent)
    return INDENT * indent + RAW_MARKER + '%s %s' % (kind, export['name'])


if __name__ == '__main__':
    import sys
    if len(sys.argv) < 2:
        raise SystemExit('usage: ue3_decompile.py <package.u> [ObjectName ...]')
    target = package.Package(sys.argv[1])
    if len(sys.argv) == 2:
        for item in target.exports:
            if target.class_name(item) == 'Class':
                print(decompile_class(target, item))
                print()
    else:
        for wanted in sys.argv[2:]:
            for item in target.find(wanted):
                print(decompile_export(target, item))
                print()
