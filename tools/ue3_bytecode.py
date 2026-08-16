import os
import struct

try:
    import ue3_opcodes as O
except ImportError:
    import sys
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import ue3_opcodes as O

_U8 = struct.Struct('<B')
_U16 = struct.Struct('<H')
_I32 = struct.Struct('<i')
_U32 = struct.Struct('<I')
_F32 = struct.Struct('<f')
_2I = struct.Struct('<2i')
_3I = struct.Struct('<3i')
_3F = struct.Struct('<3f')

MAX_DEPTH = 192
END_FUNCTION_PARMS = 'EndFunctionParms'

FIELD_NAMES = {
    0x00: ('var',),
    0x01: ('var',),
    0x02: ('var',),
    0x03: ('var',),
    0x04: ('value',),
    0x05: ('prop', 'size', 'value'),
    0x06: ('target',),
    0x07: ('target', 'condition'),
    0x09: ('line', 'debug', 'condition'),
    0x0A: ('case',),
    0x0C: ('labels',),
    0x0D: ('label',),
    0x0E: ('prop',),
    0x0F: ('target', 'value'),
    0x10: ('index', 'array'),
    0x11: ('outer', 'name', 'flags', 'class', 'template'),
    0x12: ('object', 'skip', 'prop', 'size', 'member'),
    0x13: ('class', 'value'),
    0x14: ('target', 'value'),
    0x18: ('skip', 'value'),
    0x19: ('object', 'skip', 'prop', 'size', 'member'),
    0x1A: ('index', 'array'),
    0x1B: ('func', 'args'),
    0x1C: ('func', 'args'),
    0x1D: ('value',),
    0x1E: ('value',),
    0x1F: ('value',),
    0x20: ('value',),
    0x21: ('value',),
    0x22: ('pitch', 'yaw', 'roll'),
    0x23: ('x', 'y', 'z'),
    0x24: ('value',),
    0x29: ('var',),
    0x2C: ('value',),
    0x2D: ('value',),
    0x2E: ('class', 'value'),
    0x2F: ('value', 'target'),
    0x32: ('struct', 'left', 'right'),
    0x33: ('struct', 'left', 'right'),
    0x34: ('value',),
    0x35: ('prop', 'struct', 'is_copy', 'is_modification', 'value'),
    0x36: ('array',),
    0x37: ('func', 'args'),
    0x38: ('cast', 'value'),
    0x39: ('array', 'index', 'count', '_end'),
    0x3A: ('prop',),
    0x3B: ('left', 'right', '_end'),
    0x3C: ('left', 'right', '_end'),
    0x3D: ('left', 'right', '_end'),
    0x3E: ('left', 'right', '_end'),
    0x40: ('array', 'index', 'count', '_end'),
    0x41: ('version', 'line', 'textpos', 'opcode'),
    0x42: ('is_local', 'prop', 'func', 'args'),
    0x43: ('func', 'prop'),
    0x44: ('target', 'value'),
    0x45: ('condition', 'skip_true', 'true', 'skip_false', 'false'),
    0x46: ('array', 'skip', 'item', '_end'),
    0x47: ('array', 'skip', 'prop', 'item', '_end'),
    0x48: ('var',),
    0x49: ('size', 'value', '_end'),
    0x4B: ('func',),
    0x51: ('value',),
    0x52: ('class', 'value'),
    0x54: ('array', 'item', '_end'),
    0x55: ('array', 'skip', 'item', '_end'),
    0x56: ('array', 'skip', 'item', '_end'),
    0x57: ('array', 'skip', 'index', 'item', '_end'),
    0x58: ('array', 'item', 'with_index', 'index', 'target'),
    0x59: ('array', 'skip', 'comparator', '_end'),
    0x5A: ('skip', 'value'),
}

SPEC = {}
for _code, (_name, _kinds) in O.TOKENS.items():
    _fields = FIELD_NAMES.get(_code)
    if _fields is None or len(_fields) != len(_kinds):
        _fields = tuple('arg%d' % i for i in range(len(_kinds)))
    SPEC[_code] = (_name, tuple(zip(_kinds, _fields)))

OBJECT_FIELDS = frozenset(('var', 'prop', 'class', 'struct', 'func'))

VARIABLE_OPS = frozenset((
    'LocalVariable', 'InstanceVariable', 'StateVariable',
    'LocalOutVariable', 'NativeParm', 'UndefinedVariable'))

ASSIGN_OPS = frozenset(('Let', 'LetBool', 'LetDelegate'))

TRANSPARENT_OPS = frozenset(('Skip', 'DefaultParmValue', 'BoolVariable',
                             'InterfaceContext', 'FilterEditorOnly'))

CONDITIONAL_PRECEDENCE = 50


class BytecodeReader:
    def __init__(self, pkg, buf, start, end):
        self.pkg = pkg
        self.buf = buf
        self.start = start
        self.end = min(end, len(buf))
        self.pos = start
        self.mem = 0
        self.truncated = False
        self.unknown = []
        self.jump_targets = set()
        self.by_mem = {}
        self.depth = 0

    def read_statements(self, end=None):
        limit = self.end if end is None else min(end, self.end)
        out = []
        while self.pos < limit:
            before = self.pos
            node = self.read_expr()
            if node is None:
                break
            out.append(node)
            if node['op'] == 'EndOfScript' or node['op'] == 'EOF':
                break
            if self.pos <= before:
                self.pos = before + 1
                self.mem += 1
        return out

    def read_expr(self):
        if self.pos >= self.end:
            self.truncated = True
            return {'op': 'EOF', 'pos': self.pos, 'mem': self.mem, 'mem_end': self.mem}
        if self.depth >= MAX_DEPTH:
            node = {'op': 'DEPTH', 'pos': self.pos, 'mem': self.mem, 'mem_end': self.mem}
            self.pos = self.end
            return node
        pos = self.pos
        mem = self.mem
        code = self.buf[pos]
        self.pos = pos + 1
        self.mem = mem + 1
        if code >= O.EXTENDED_NATIVE:
            node = self._native(code, pos, mem)
        else:
            spec = SPEC.get(code)
            if spec is None:
                node = {'op': 'UNKNOWN', 'code': code, 'pos': pos, 'mem': mem, 'mem_end': self.mem}
                self.unknown.append((pos, code))
            else:
                node = {'op': spec[0], 'pos': pos, 'mem': mem}
                self.depth += 1
                for kind, field in spec[1]:
                    self._operand(node, kind, field)
                self.depth -= 1
                node['mem_end'] = self.mem
        self.by_mem[mem] = node
        return node

    def _native(self, code, pos, mem):
        if code < O.FIRST_NATIVE:
            if self.pos >= self.end:
                self.truncated = True
                return {'op': 'EOF', 'pos': pos, 'mem': mem, 'mem_end': self.mem}
            index = ((code - O.EXTENDED_NATIVE) << 8) | self.buf[self.pos]
            self.pos += 1
            self.mem += 1
        else:
            index = code
        entry = O.NATIVES.get(index)
        if entry is None:
            name, func, precedence, kind = 'Native%d' % index, 'Native%d' % index, 0, 'function'
        else:
            name, func, precedence, kind = entry
        node = {'op': 'NativeCall', 'index': index, 'name': name, 'func': func,
                'precedence': precedence, 'kind': kind, 'pos': pos, 'mem': mem}
        self.depth += 1
        node['args'] = self._read_params()
        self.depth -= 1
        node['mem_end'] = self.mem
        return node

    def _read_params(self):
        args = []
        while True:
            if self.pos >= self.end:
                self.truncated = True
                break
            before = self.pos
            node = self.read_expr()
            op = node['op']
            if op == END_FUNCTION_PARMS or op == 'EOF' or op == 'DEPTH':
                break
            args.append(node)
            if self.pos <= before:
                break
        return args

    def _operand(self, node, kind, field):
        buf = self.buf
        pos = self.pos
        if kind == 'expr':
            value = self.read_expr()
        elif kind == 'params':
            value = self._read_params()
        elif kind == 'obj':
            if pos + 4 > self.end:
                return self._short(node, field)
            index = _I32.unpack_from(buf, pos)[0]
            self.pos = pos + 4
            self.mem += O.OBJECT_REF_MEMORY_SIZE
            node[field + '_index'] = index
            value = self.object_name(index)
        elif kind == 'name':
            if pos + 8 > self.end:
                return self._short(node, field)
            value = self.name_at(pos)
            self.pos = pos + 8
            self.mem += O.NAME_MEMORY_SIZE
        elif kind == 'u8' or kind == 'cast':
            if pos + 1 > self.end:
                return self._short(node, field)
            value = buf[pos]
            self.pos = pos + 1
            self.mem += 1
            if kind == 'cast':
                node['cast_name'] = O.CASTS.get(value, 'Cast%02X' % value)
                node['cast_type'] = O.CAST_TYPE_NAMES.get(value)
        elif kind == 'u16' or kind == 'off16':
            if pos + 2 > self.end:
                return self._short(node, field)
            value = _U16.unpack_from(buf, pos)[0]
            self.pos = pos + 2
            self.mem += 2
            if kind == 'off16':
                self.jump_targets.add(value)
        elif kind == 'i32':
            if pos + 4 > self.end:
                return self._short(node, field)
            value = _I32.unpack_from(buf, pos)[0]
            self.pos = pos + 4
            self.mem += 4
        elif kind == 'f32':
            if pos + 4 > self.end:
                return self._short(node, field)
            value = _F32.unpack_from(buf, pos)[0]
            self.pos = pos + 4
            self.mem += 4
        elif kind == 'astr':
            end = buf.find(b'\0', pos, self.end)
            if end < 0:
                return self._short(node, field)
            value = bytes(buf[pos:end]).decode('latin1', 'replace')
            self.mem += end + 1 - pos
            self.pos = end + 1
        elif kind == 'ustr':
            end = pos
            while end + 2 <= self.end and (buf[end] or buf[end + 1]):
                end += 2
            if end + 2 > self.end:
                return self._short(node, field)
            value = bytes(buf[pos:end]).decode('utf-16le', 'replace')
            self.mem += end + 2 - pos
            self.pos = end + 2
        elif kind == 'case':
            if pos + 2 > self.end:
                return self._short(node, field)
            target = _U16.unpack_from(buf, pos)[0]
            self.pos = pos + 2
            self.mem += 2
            node['next'] = target
            if target == 0xFFFF:
                node['default'] = True
                node['value'] = None
            else:
                self.jump_targets.add(target)
                node['default'] = False
                node['value'] = self.read_expr()
            return
        elif kind == 'labels':
            value = self._read_labels()
        else:
            return self._short(node, field)
        if field[0] != '_':
            node[field] = value

    def _read_labels(self):
        labels = []
        buf = self.buf
        while self.pos + 12 <= self.end:
            name = self.name_at(self.pos)
            target = _I32.unpack_from(buf, self.pos + 8)[0]
            self.pos += 12
            self.mem += 12
            if name != 'None':
                self.jump_targets.add(target)
            labels.append((name, target))
            if name == 'None':
                break
        else:
            self.truncated = True
        return labels

    def _short(self, node, field):
        self.truncated = True
        node['truncated'] = True
        self.pos = self.end
        if field[0] != '_':
            node[field] = None

    def name_at(self, pos):
        index, number = _2I.unpack_from(self.buf, pos)
        names = self.pkg.names if self.pkg is not None else ()
        if 0 <= index < len(names):
            text = names[index]
        else:
            text = '?name%d' % index
        return text + ('_%d' % (number - 1)) if number > 0 else text

    def object_name(self, index):
        if index == 0:
            return 'None'
        ref = self.pkg.obj_ref(index) if self.pkg is not None else None
        if ref is None:
            return '?obj%d' % index
        return ref['name']

    def object_path(self, index):
        if self.pkg is None:
            return 'None'
        return self.pkg.object_path(index)


def read_body(pkg, export):
    data_start = export['serial_offset']
    limit = data_start + export['serial_size']
    if data_start + 48 > limit:
        return None
    storage = _U32.unpack_from(pkg.b, data_start + 44)[0]
    memory = _U32.unpack_from(pkg.b, data_start + 40)[0]
    start = data_start + 48
    if storage == 0 or start + storage > limit:
        return None
    reader = BytecodeReader(pkg, pkg.b, start, start + storage)
    statements = reader.read_statements()
    return {'reader': reader, 'statements': statements, 'storage_size': storage,
            'memory_size': memory, 'consumed': reader.pos - start, 'memory_used': reader.mem}


def format_float(value):
    if value != value or value in (float('inf'), float('-inf')):
        return '0.0'
    text = '%.1f' % value
    if _F32.unpack(_F32.pack(float(text)))[0] != value:
        for digits in range(1, 10):
            text = '%.*g' % (digits, value)
            if _F32.unpack(_F32.pack(float(text)))[0] == value:
                break
    if '.' not in text and 'e' not in text and 'E' not in text:
        text += '.0'
    return text


def quote_string(text):
    out = ['"']
    for ch in text:
        if ch == '"':
            out.append('\\"')
        elif ch == '\\':
            out.append('\\\\')
        elif ch == '\n':
            out.append('\\n')
        elif ch == '\r':
            out.append('\\r')
        elif ch == '\t':
            out.append('\\t')
        elif ord(ch) < 32:
            out.append('\\x%02x' % ord(ch))
        else:
            out.append(ch)
    out.append('"')
    return ''.join(out)


def precedence_of(node):
    while isinstance(node, dict) and node['op'] in TRANSPARENT_OPS:
        node = node.get('value')
    if not isinstance(node, dict):
        return 0
    op = node['op']
    if op == 'NativeCall' and node['kind'] == 'operator' and len(node['args']) == 2:
        return node['precedence']
    if op == 'Conditional':
        return CONDITIONAL_PRECEDENCE
    if op in ASSIGN_OPS:
        return CONDITIONAL_PRECEDENCE
    return 0


def _wrap(node, parent, right):
    text = format_expr(node)
    inner = precedence_of(node)
    if inner and parent and (inner > parent or (inner == parent and right)):
        return '(' + text + ')'
    return text


def format_args(args):
    parts = [format_expr(a) for a in args]
    while parts and parts[-1] == '':
        parts.pop()
    return ', '.join(parts)


def format_expr(node):
    if node is None:
        return ''
    op = node['op']
    if op in VARIABLE_OPS:
        return node.get('var') or ''
    if op == 'DefaultVariable':
        return 'default.' + (node.get('var') or '')
    if op == 'Self':
        return 'self'
    if op == 'Nothing' or op == 'EmptyParmValue' or op == 'NoParm':
        return ''
    if op == 'NoObject' or op == 'EmptyDelegate':
        return 'none'
    if op == 'IntZero':
        return '0'
    if op == 'IntOne':
        return '1'
    if op == 'True':
        return 'true'
    if op == 'False':
        return 'false'
    if op == 'IntConst' or op == 'IntConstByte' or op == 'ByteConst':
        return str(node.get('value'))
    if op == 'FloatConst':
        return format_float(node.get('value') or 0.0)
    if op == 'StringConst' or op == 'UnicodeStringConst':
        return quote_string(node.get('value') or '')
    if op == 'NameConst':
        return "'" + (node.get('value') or 'None') + "'"
    if op == 'ObjectConst':
        return node.get('value') or 'none'
    if op == 'RotationConst':
        return 'rot(%d, %d, %d)' % (node.get('pitch') or 0, node.get('yaw') or 0, node.get('roll') or 0)
    if op == 'VectorConst':
        return 'vect(%s, %s, %s)' % (format_float(node.get('x') or 0.0),
                                     format_float(node.get('y') or 0.0),
                                     format_float(node.get('z') or 0.0))
    if op == 'NativeCall':
        return _format_native(node)
    if op == 'VirtualFunction' or op == 'GlobalFunction':
        prefix = 'Global.' if op == 'GlobalFunction' else ''
        return '%s%s(%s)' % (prefix, node.get('func') or '', format_args(node.get('args') or ()))
    if op == 'FinalFunction':
        return '%s(%s)' % (node.get('func') or '', format_args(node.get('args') or ()))
    if op == 'DelegateFunction':
        return '%s(%s)' % (node.get('func') or '', format_args(node.get('args') or ()))
    if op == 'Context' or op == 'ClassContext':
        return '%s.%s' % (_wrap(node.get('object'), 0, False), format_expr(node.get('member')))
    if op == 'InterfaceContext':
        return format_expr(node.get('value'))
    if op == 'StructMember':
        return '%s.%s' % (_wrap(node.get('value'), 0, False), node.get('prop') or '')
    if op == 'ArrayElement' or op == 'DynArrayElement':
        return '%s[%s]' % (format_expr(node.get('array')), format_expr(node.get('index')))
    if op == 'DynArrayLength':
        return '%s.Length' % format_expr(node.get('array'))
    if op == 'DynamicCast' or op == 'InterfaceCast':
        return '%s(%s)' % (node.get('class') or '', format_expr(node.get('value')))
    if op == 'MetaCast':
        return 'class<%s>(%s)' % (node.get('class') or '', format_expr(node.get('value')))
    if op == 'PrimitiveCast':
        cast = node.get('cast_type') or node.get('cast_name') or ''
        return '%s(%s)' % (cast, format_expr(node.get('value')))
    if op in ASSIGN_OPS:
        return '%s = %s' % (format_expr(node.get('target')),
                            _wrap(node.get('value'), CONDITIONAL_PRECEDENCE, True))
    if op == 'Conditional':
        return '%s ? %s : %s' % (_wrap(node.get('condition'), CONDITIONAL_PRECEDENCE, False),
                                 format_expr(node.get('true')), format_expr(node.get('false')))
    if op == 'StructCmpEq':
        return '%s == %s' % (format_expr(node.get('left')), format_expr(node.get('right')))
    if op == 'StructCmpNe':
        return '%s != %s' % (format_expr(node.get('left')), format_expr(node.get('right')))
    if op == 'EqualEqual_DelDel' or op == 'EqualEqual_DelFunc':
        return '%s == %s' % (format_expr(node.get('left')), format_expr(node.get('right')))
    if op == 'NotEqual_DelDel' or op == 'NotEqual_DelFunc':
        return '%s != %s' % (format_expr(node.get('left')), format_expr(node.get('right')))
    if op == 'InstanceDelegate' or op == 'DelegateProperty':
        return node.get('func') or ''
    if op == 'BoolVariable':
        return format_expr(node.get('value'))
    if op == 'New':
        return 'new(%s) %s' % (format_args([node.get('outer'), node.get('name'), node.get('flags')]),
                               format_expr(node.get('class')))
    if op == 'DefaultParmValue':
        return format_expr(node.get('value'))
    if op == 'DynArrayAdd':
        return '%s.Add(%s)' % (format_expr(node.get('array')), format_expr(node.get('item')))
    if op == 'DynArrayAddItem':
        return '%s.AddItem(%s)' % (format_expr(node.get('array')), format_expr(node.get('item')))
    if op == 'DynArrayRemoveItem':
        return '%s.RemoveItem(%s)' % (format_expr(node.get('array')), format_expr(node.get('item')))
    if op == 'DynArrayInsertItem':
        return '%s.InsertItem(%s, %s)' % (format_expr(node.get('array')),
                                          format_expr(node.get('index')), format_expr(node.get('item')))
    if op == 'DynArrayInsert':
        return '%s.Insert(%s, %s)' % (format_expr(node.get('array')),
                                      format_expr(node.get('index')), format_expr(node.get('count')))
    if op == 'DynArrayRemove':
        return '%s.Remove(%s, %s)' % (format_expr(node.get('array')),
                                      format_expr(node.get('index')), format_expr(node.get('count')))
    if op == 'DynArrayFind':
        return '%s.Find(%s)' % (format_expr(node.get('array')), format_expr(node.get('item')))
    if op == 'DynArrayFindStruct':
        return '%s.Find(%s, %s)' % (format_expr(node.get('array')),
                                    format_expr(node.get('prop')), format_expr(node.get('item')))
    if op == 'DynArraySort':
        return '%s.Sort(%s)' % (format_expr(node.get('array')), format_expr(node.get('comparator')))
    if op == 'Skip':
        return format_expr(node.get('value'))
    if op == 'EatReturnValue':
        return ''
    if op == 'Return':
        inner = format_expr(node.get('value'))
        return 'return ' + inner if inner else 'return'
    if op == 'ReturnNothing':
        return ''
    if op == 'Stop':
        return 'stop'
    if op == 'Jump':
        return 'goto 0x%04X' % (node.get('target') or 0)
    if op == 'JumpIfNot':
        return 'if (!(%s)) goto 0x%04X' % (format_expr(node.get('condition')), node.get('target') or 0)
    if op == 'GotoLabel':
        return 'goto ' + format_expr(node.get('label'))
    if op == 'Switch':
        return 'switch (%s)' % format_expr(node.get('value'))
    if op == 'Case':
        return 'default:' if node.get('default') else 'case %s:' % format_expr(node.get('value'))
    if op == 'Assert':
        return 'assert(%s)' % format_expr(node.get('condition'))
    if op == 'Iterator':
        return 'foreach %s' % format_expr(node.get('value'))
    if op == 'DynArrayIterator':
        return 'foreach %s(%s)' % (format_expr(node.get('array')),
                                   format_args([node.get('item'), node.get('index')]))
    if op == 'UNKNOWN':
        return 'UNKNOWN_%02X' % node.get('code', 0)
    return op


def _format_native(node):
    args = node.get('args') or ()
    kind = node['kind']
    name = node['name']
    if kind == 'operator' and len(args) == 2:
        prec = node['precedence']
        left = _wrap(args[0], prec, False)
        right = _wrap(args[1], prec, True)
        return '%s %s %s' % (left, name, right)
    if kind == 'operator' and len(args) == 1:
        return '%s%s' % (_wrap(args[0], 0, False), name)
    if kind == 'preoperator' and len(args) == 1:
        return '%s%s' % (name, _wrap(args[0], 0, False))
    return '%s(%s)' % (name, format_args(args))


def dump_tree(node, indent=0, out=None):
    if out is None:
        out = []
    pad = '  ' * indent
    if isinstance(node, list):
        for item in node:
            dump_tree(item, indent, out)
        return out
    if not isinstance(node, dict):
        out.append('%s%r' % (pad, node))
        return out
    head = node['op']
    if head == 'NativeCall':
        head = 'NativeCall %s(%d) %s' % (node['name'], node['index'], node['kind'])
    out.append('%s%s  @mem=%d' % (pad, head, node.get('mem', -1)))
    for key in node:
        if key in ('op', 'pos', 'mem', 'mem_end', 'kind', 'name', 'index', 'precedence', 'func_index'):
            continue
        value = node[key]
        if isinstance(value, dict):
            out.append('%s  %s:' % (pad, key))
            dump_tree(value, indent + 2, out)
        elif isinstance(value, list):
            if not value:
                out.append('%s  %s: []' % (pad, key))
            else:
                out.append('%s  %s:' % (pad, key))
                for item in value:
                    dump_tree(item, indent + 2, out)
        else:
            out.append('%s  %s: %r' % (pad, key, value))
    return out
