EXTENDED_NATIVE = 0x60
FIRST_NATIVE = 0x70
MAX_NATIVE = 0x1000

OBJECT_REF_FILE_SIZE = 4
OBJECT_REF_MEMORY_SIZE = 8
NAME_FILE_SIZE = 8
NAME_MEMORY_SIZE = 8

EX_LocalVariable = 0x00
EX_InstanceVariable = 0x01
EX_DefaultVariable = 0x02
EX_StateVariable = 0x03
EX_Return = 0x04
EX_Switch = 0x05
EX_Jump = 0x06
EX_JumpIfNot = 0x07
EX_Stop = 0x08
EX_Assert = 0x09
EX_Case = 0x0A
EX_Nothing = 0x0B
EX_LabelTable = 0x0C
EX_GotoLabel = 0x0D
EX_EatReturnValue = 0x0E
EX_Let = 0x0F
EX_DynArrayElement = 0x10
EX_New = 0x11
EX_ClassContext = 0x12
EX_MetaCast = 0x13
EX_LetBool = 0x14
EX_EndParmValue = 0x15
EX_EndFunctionParms = 0x16
EX_Self = 0x17
EX_Skip = 0x18
EX_Context = 0x19
EX_ArrayElement = 0x1A
EX_VirtualFunction = 0x1B
EX_FinalFunction = 0x1C
EX_IntConst = 0x1D
EX_FloatConst = 0x1E
EX_StringConst = 0x1F
EX_ObjectConst = 0x20
EX_NameConst = 0x21
EX_RotationConst = 0x22
EX_VectorConst = 0x23
EX_ByteConst = 0x24
EX_IntZero = 0x25
EX_IntOne = 0x26
EX_True = 0x27
EX_False = 0x28
EX_NativeParm = 0x29
EX_NoObject = 0x2A
EX_IntConstByte = 0x2C
EX_BoolVariable = 0x2D
EX_DynamicCast = 0x2E
EX_Iterator = 0x2F
EX_IteratorPop = 0x30
EX_IteratorNext = 0x31
EX_StructCmpEq = 0x32
EX_StructCmpNe = 0x33
EX_UnicodeStringConst = 0x34
EX_StructMember = 0x35
EX_DynArrayLength = 0x36
EX_GlobalFunction = 0x37
EX_PrimitiveCast = 0x38
EX_DynArrayInsert = 0x39
EX_ReturnNothing = 0x3A
EX_EqualEqual_DelDel = 0x3B
EX_NotEqual_DelDel = 0x3C
EX_EqualEqual_DelFunc = 0x3D
EX_NotEqual_DelFunc = 0x3E
EX_EmptyDelegate = 0x3F
EX_DynArrayRemove = 0x40
EX_DebugInfo = 0x41
EX_DelegateFunction = 0x42
EX_DelegateProperty = 0x43
EX_LetDelegate = 0x44
EX_Conditional = 0x45
EX_DynArrayFind = 0x46
EX_DynArrayFindStruct = 0x47
EX_LocalOutVariable = 0x48
EX_DefaultParmValue = 0x49
EX_EmptyParmValue = 0x4A
EX_InstanceDelegate = 0x4B
EX_UndefinedVariable = 0x50
EX_InterfaceContext = 0x51
EX_InterfaceCast = 0x52
EX_EndOfScript = 0x53
EX_DynArrayAdd = 0x54
EX_DynArrayAddItem = 0x55
EX_DynArrayRemoveItem = 0x56
EX_DynArrayInsertItem = 0x57
EX_DynArrayIterator = 0x58
EX_DynArraySort = 0x59
EX_FilterEditorOnly = 0x5A

TOKENS = {
    0x00: ('LocalVariable', ('obj',)),
    0x01: ('InstanceVariable', ('obj',)),
    0x02: ('DefaultVariable', ('obj',)),
    0x03: ('StateVariable', ('obj',)),
    0x04: ('Return', ('expr',)),
    0x05: ('Switch', ('obj', 'u8', 'expr')),
    0x06: ('Jump', ('off16',)),
    0x07: ('JumpIfNot', ('off16', 'expr')),
    0x08: ('Stop', ()),
    0x09: ('Assert', ('u16', 'u8', 'expr')),
    0x0A: ('Case', ('case',)),
    0x0B: ('Nothing', ()),
    0x0C: ('LabelTable', ('labels',)),
    0x0D: ('GotoLabel', ('expr',)),
    0x0E: ('EatReturnValue', ('obj',)),
    0x0F: ('Let', ('expr', 'expr')),
    0x10: ('DynArrayElement', ('expr', 'expr')),
    0x11: ('New', ('expr', 'expr', 'expr', 'expr', 'expr')),
    0x12: ('ClassContext', ('expr', 'u16', 'obj', 'u8', 'expr')),
    0x13: ('MetaCast', ('obj', 'expr')),
    0x14: ('LetBool', ('expr', 'expr')),
    0x15: ('EndParmValue', ()),
    0x16: ('EndFunctionParms', ()),
    0x17: ('Self', ()),
    0x18: ('Skip', ('u16', 'expr')),
    0x19: ('Context', ('expr', 'u16', 'obj', 'u8', 'expr')),
    0x1A: ('ArrayElement', ('expr', 'expr')),
    0x1B: ('VirtualFunction', ('name', 'params')),
    0x1C: ('FinalFunction', ('obj', 'params')),
    0x1D: ('IntConst', ('i32',)),
    0x1E: ('FloatConst', ('f32',)),
    0x1F: ('StringConst', ('astr',)),
    0x20: ('ObjectConst', ('obj',)),
    0x21: ('NameConst', ('name',)),
    0x22: ('RotationConst', ('i32', 'i32', 'i32')),
    0x23: ('VectorConst', ('f32', 'f32', 'f32')),
    0x24: ('ByteConst', ('u8',)),
    0x25: ('IntZero', ()),
    0x26: ('IntOne', ()),
    0x27: ('True', ()),
    0x28: ('False', ()),
    0x29: ('NativeParm', ('obj',)),
    0x2A: ('NoObject', ()),
    0x2C: ('IntConstByte', ('u8',)),
    0x2D: ('BoolVariable', ('expr',)),
    0x2E: ('DynamicCast', ('obj', 'expr')),
    0x2F: ('Iterator', ('expr', 'off16')),
    0x30: ('IteratorPop', ()),
    0x31: ('IteratorNext', ()),
    0x32: ('StructCmpEq', ('obj', 'expr', 'expr')),
    0x33: ('StructCmpNe', ('obj', 'expr', 'expr')),
    0x34: ('UnicodeStringConst', ('ustr',)),
    0x35: ('StructMember', ('obj', 'obj', 'u8', 'u8', 'expr')),
    0x36: ('DynArrayLength', ('expr',)),
    0x37: ('GlobalFunction', ('name', 'params')),
    0x38: ('PrimitiveCast', ('cast', 'expr')),
    0x39: ('DynArrayInsert', ('expr', 'expr', 'expr', 'expr')),
    0x3A: ('ReturnNothing', ('obj',)),
    0x3B: ('EqualEqual_DelDel', ('expr', 'expr', 'expr')),
    0x3C: ('NotEqual_DelDel', ('expr', 'expr', 'expr')),
    0x3D: ('EqualEqual_DelFunc', ('expr', 'expr', 'expr')),
    0x3E: ('NotEqual_DelFunc', ('expr', 'expr', 'expr')),
    0x3F: ('EmptyDelegate', ()),
    0x40: ('DynArrayRemove', ('expr', 'expr', 'expr', 'expr')),
    0x41: ('DebugInfo', ('i32', 'i32', 'i32', 'u8')),
    0x42: ('DelegateFunction', ('u8', 'obj', 'name', 'params')),
    0x43: ('DelegateProperty', ('name', 'obj')),
    0x44: ('LetDelegate', ('expr', 'expr')),
    0x45: ('Conditional', ('expr', 'u16', 'expr', 'u16', 'expr')),
    0x46: ('DynArrayFind', ('expr', 'u16', 'expr', 'expr')),
    0x47: ('DynArrayFindStruct', ('expr', 'u16', 'expr', 'expr', 'expr')),
    0x48: ('LocalOutVariable', ('obj',)),
    0x49: ('DefaultParmValue', ('u16', 'expr', 'expr')),
    0x4A: ('EmptyParmValue', ()),
    0x4B: ('InstanceDelegate', ('name',)),
    0x50: ('UndefinedVariable', ()),
    0x51: ('InterfaceContext', ('expr',)),
    0x52: ('InterfaceCast', ('obj', 'expr')),
    0x53: ('EndOfScript', ()),
    0x54: ('DynArrayAdd', ('expr', 'expr', 'expr')),
    0x55: ('DynArrayAddItem', ('expr', 'u16', 'expr', 'expr')),
    0x56: ('DynArrayRemoveItem', ('expr', 'u16', 'expr', 'expr')),
    0x57: ('DynArrayInsertItem', ('expr', 'u16', 'expr', 'expr', 'expr')),
    0x58: ('DynArrayIterator', ('expr', 'expr', 'u8', 'expr', 'off16')),
    0x59: ('DynArraySort', ('expr', 'u16', 'expr', 'expr')),
    0x5A: ('FilterEditorOnly', ('u16', 'expr')),
}

OPERAND_FILE_SIZE = {'u8': 1, 'cast': 1, 'u16': 2, 'off16': 2, 'i32': 4, 'f32': 4,
                     'obj': OBJECT_REF_FILE_SIZE, 'name': NAME_FILE_SIZE}

OPERAND_MEMORY_SIZE = {'u8': 1, 'cast': 1, 'u16': 2, 'off16': 2, 'i32': 4, 'f32': 4,
                       'obj': OBJECT_REF_MEMORY_SIZE, 'name': NAME_MEMORY_SIZE}

CASTS = {
    0x36: 'InterfaceToObject',
    0x37: 'InterfaceToString',
    0x38: 'InterfaceToBool',
    0x39: 'RotatorToVector',
    0x3A: 'ByteToInt',
    0x3B: 'ByteToBool',
    0x3C: 'ByteToFloat',
    0x3D: 'IntToByte',
    0x3E: 'IntToBool',
    0x3F: 'IntToFloat',
    0x40: 'BoolToByte',
    0x41: 'BoolToInt',
    0x42: 'BoolToFloat',
    0x43: 'FloatToByte',
    0x44: 'FloatToInt',
    0x45: 'FloatToBool',
    0x46: 'ObjectToInterface',
    0x47: 'ObjectToBool',
    0x48: 'NameToBool',
    0x49: 'StringToByte',
    0x4A: 'StringToInt',
    0x4B: 'StringToBool',
    0x4C: 'StringToFloat',
    0x4D: 'StringToVector',
    0x4E: 'StringToRotator',
    0x4F: 'VectorToBool',
    0x50: 'VectorToRotator',
    0x51: 'RotatorToBool',
    0x52: 'ByteToString',
    0x53: 'IntToString',
    0x54: 'BoolToString',
    0x55: 'FloatToString',
    0x56: 'ObjectToString',
    0x57: 'NameToString',
    0x58: 'VectorToString',
    0x59: 'RotatorToString',
    0x5A: 'DelegateToString',
    0x60: 'StringToName',
}

CAST_TYPE_NAMES = {
    0x37: 'string', 0x38: 'bool', 0x39: 'vector', 0x3A: 'int', 0x3B: 'bool',
    0x3C: 'float', 0x3D: 'byte', 0x3E: 'bool', 0x3F: 'float', 0x40: 'byte',
    0x41: 'int', 0x42: 'float', 0x43: 'byte', 0x44: 'int', 0x45: 'bool',
    0x47: 'bool', 0x48: 'bool', 0x49: 'byte', 0x4A: 'int', 0x4B: 'bool',
    0x4C: 'float', 0x4D: 'vector', 0x4E: 'rotator', 0x4F: 'bool', 0x50: 'rotator',
    0x51: 'bool', 0x52: 'string', 0x53: 'string', 0x54: 'string', 0x55: 'string',
    0x56: 'string', 0x57: 'string', 0x58: 'string', 0x59: 'string', 0x5A: 'string',
    0x60: 'name',
}

DEBUG_INFO = {
    0x00: 'Let', 0x01: 'SimpleIf', 0x02: 'Switch', 0x03: 'While', 0x04: 'Assert',
    0x10: 'Return', 0x11: 'ReturnNothing',
    0x20: 'NewStack', 0x21: 'NewStackLatent', 0x22: 'NewStackLabel',
    0x30: 'PrevStack', 0x31: 'PrevStackLatent', 0x32: 'PrevStackLabel', 0x33: 'PrevStackState',
    0x40: 'EFP', 0x41: 'EFPOper', 0x42: 'EFPIter',
    0x50: 'ForInit', 0x51: 'ForEval', 0x52: 'ForInc',
    0x60: 'BreakLoop', 0x61: 'BreakFor', 0x62: 'BreakForEach', 0x63: 'BreakSwitch',
    0x70: 'ContinueLoop', 0x71: 'ContinueForeach', 0x72: 'ContinueFor',
    0xFF: 'Unset',
}

NATIVES = {
    0x070: ('$', 'Concat_StrStr', 40, 'operator'),
    0x071: ('GotoState', 'GotoState', 0, 'function'),
    0x072: ('==', 'EqualEqual_ObjectObject', 24, 'operator'),
    0x073: ('<', 'Less_StrStr', 24, 'operator'),
    0x074: ('>', 'Greater_StrStr', 24, 'operator'),
    0x075: ('Enable', 'Enable', 0, 'function'),
    0x076: ('Disable', 'Disable', 0, 'function'),
    0x077: ('!=', 'NotEqual_ObjectObject', 26, 'operator'),
    0x078: ('<=', 'LessEqual_StrStr', 24, 'operator'),
    0x079: ('>=', 'GreaterEqual_StrStr', 24, 'operator'),
    0x07A: ('==', 'EqualEqual_StrStr', 24, 'operator'),
    0x07B: ('!=', 'NotEqual_StrStr', 26, 'operator'),
    0x07C: ('~=', 'ComplementEqual_StrStr', 24, 'operator'),
    0x07D: ('Len', 'Len', 0, 'function'),
    0x07E: ('InStr', 'InStr', 0, 'function'),
    0x07F: ('Mid', 'Mid', 0, 'function'),
    0x080: ('Left', 'Left', 0, 'function'),
    0x081: ('!', 'Not_PreBool', 0, 'preoperator'),
    0x082: ('&&', 'AndAnd_BoolBool', 30, 'operator'),
    0x083: ('^^', 'XorXor_BoolBool', 30, 'operator'),
    0x084: ('||', 'OrOr_BoolBool', 32, 'operator'),
    0x085: ('*=', 'MultiplyEqual_ByteByte', 34, 'operator'),
    0x086: ('/=', 'DivideEqual_ByteByte', 34, 'operator'),
    0x087: ('+=', 'AddEqual_ByteByte', 34, 'operator'),
    0x088: ('-=', 'SubtractEqual_ByteByte', 34, 'operator'),
    0x089: ('++', 'AddAdd_PreByte', 0, 'preoperator'),
    0x08A: ('--', 'SubtractSubtract_PreByte', 0, 'preoperator'),
    0x08B: ('++', 'AddAdd_Byte', 0, 'operator'),
    0x08C: ('--', 'SubtractSubtract_Byte', 0, 'operator'),
    0x08D: ('~', 'Complement_PreInt', 0, 'preoperator'),
    0x08E: ('==', 'EqualEqual_RotatorRotator', 24, 'operator'),
    0x08F: ('-', 'Subtract_PreInt', 0, 'preoperator'),
    0x090: ('*', 'Multiply_IntInt', 16, 'operator'),
    0x091: ('/', 'Divide_IntInt', 16, 'operator'),
    0x092: ('+', 'Add_IntInt', 20, 'operator'),
    0x093: ('-', 'Subtract_IntInt', 20, 'operator'),
    0x094: ('<<', 'LessLess_IntInt', 22, 'operator'),
    0x095: ('>>', 'GreaterGreater_IntInt', 22, 'operator'),
    0x096: ('<', 'Less_IntInt', 24, 'operator'),
    0x097: ('>', 'Greater_IntInt', 24, 'operator'),
    0x098: ('<=', 'LessEqual_IntInt', 24, 'operator'),
    0x099: ('>=', 'GreaterEqual_IntInt', 24, 'operator'),
    0x09A: ('==', 'EqualEqual_IntInt', 24, 'operator'),
    0x09B: ('!=', 'NotEqual_IntInt', 26, 'operator'),
    0x09C: ('&', 'And_IntInt', 28, 'operator'),
    0x09D: ('^', 'Xor_IntInt', 28, 'operator'),
    0x09E: ('|', 'Or_IntInt', 28, 'operator'),
    0x09F: ('*=', 'MultiplyEqual_IntFloat', 34, 'operator'),
    0x0A0: ('/=', 'DivideEqual_IntFloat', 34, 'operator'),
    0x0A1: ('+=', 'AddEqual_IntInt', 34, 'operator'),
    0x0A2: ('-=', 'SubtractEqual_IntInt', 34, 'operator'),
    0x0A3: ('++', 'AddAdd_PreInt', 0, 'preoperator'),
    0x0A4: ('--', 'SubtractSubtract_PreInt', 0, 'preoperator'),
    0x0A5: ('++', 'AddAdd_Int', 0, 'operator'),
    0x0A6: ('--', 'SubtractSubtract_Int', 0, 'operator'),
    0x0A7: ('Rand', 'Rand', 0, 'function'),
    0x0A8: ('@', 'At_StrStr', 40, 'operator'),
    0x0A9: ('-', 'Subtract_PreFloat', 0, 'preoperator'),
    0x0AA: ('**', 'MultiplyMultiply_FloatFloat', 12, 'operator'),
    0x0AB: ('*', 'Multiply_FloatFloat', 16, 'operator'),
    0x0AC: ('/', 'Divide_FloatFloat', 16, 'operator'),
    0x0AD: ('%', 'Percent_FloatFloat', 18, 'operator'),
    0x0AE: ('+', 'Add_FloatFloat', 20, 'operator'),
    0x0AF: ('-', 'Subtract_FloatFloat', 20, 'operator'),
    0x0B0: ('<', 'Less_FloatFloat', 24, 'operator'),
    0x0B1: ('>', 'Greater_FloatFloat', 24, 'operator'),
    0x0B2: ('<=', 'LessEqual_FloatFloat', 24, 'operator'),
    0x0B3: ('>=', 'GreaterEqual_FloatFloat', 24, 'operator'),
    0x0B4: ('==', 'EqualEqual_FloatFloat', 24, 'operator'),
    0x0B5: ('!=', 'NotEqual_FloatFloat', 26, 'operator'),
    0x0B6: ('*=', 'MultiplyEqual_FloatFloat', 34, 'operator'),
    0x0B7: ('/=', 'DivideEqual_FloatFloat', 34, 'operator'),
    0x0B8: ('+=', 'AddEqual_FloatFloat', 34, 'operator'),
    0x0B9: ('-=', 'SubtractEqual_FloatFloat', 34, 'operator'),
    0x0BA: ('Abs', 'Abs', 0, 'function'),
    0x0BB: ('Sin', 'Sin', 0, 'function'),
    0x0BC: ('Cos', 'Cos', 0, 'function'),
    0x0BD: ('Tan', 'Tan', 0, 'function'),
    0x0BE: ('Atan', 'Atan', 0, 'function'),
    0x0BF: ('Exp', 'Exp', 0, 'function'),
    0x0C0: ('Loge', 'Loge', 0, 'function'),
    0x0C1: ('Sqrt', 'Sqrt', 0, 'function'),
    0x0C2: ('Square', 'Square', 0, 'function'),
    0x0C3: ('FRand', 'FRand', 0, 'function'),
    0x0C4: ('>>>', 'GreaterGreaterGreater_IntInt', 22, 'operator'),
    0x0C5: ('IsA', 'IsA', 0, 'function'),
    0x0C6: ('*=', 'MultiplyEqual_ByteFloat', 34, 'operator'),
    0x0C7: ('Round', 'Round', 0, 'function'),
    0x0C9: ('Repl', 'Repl', 0, 'function'),
    0x0CB: ('!=', 'NotEqual_RotatorRotator', 26, 'operator'),
    0x0D2: ('~=', 'ComplementEqual_FloatFloat', 24, 'operator'),
    0x0D3: ('-', 'Subtract_PreVector', 0, 'preoperator'),
    0x0D4: ('*', 'Multiply_VectorFloat', 16, 'operator'),
    0x0D5: ('*', 'Multiply_FloatVector', 16, 'operator'),
    0x0D6: ('/', 'Divide_VectorFloat', 16, 'operator'),
    0x0D7: ('+', 'Add_VectorVector', 20, 'operator'),
    0x0D8: ('-', 'Subtract_VectorVector', 20, 'operator'),
    0x0D9: ('==', 'EqualEqual_VectorVector', 24, 'operator'),
    0x0DA: ('!=', 'NotEqual_VectorVector', 26, 'operator'),
    0x0DB: ('Dot', 'Dot_VectorVector', 16, 'operator'),
    0x0DC: ('Cross', 'Cross_VectorVector', 16, 'operator'),
    0x0DD: ('*=', 'MultiplyEqual_VectorFloat', 34, 'operator'),
    0x0DE: ('/=', 'DivideEqual_VectorFloat', 34, 'operator'),
    0x0DF: ('+=', 'AddEqual_VectorVector', 34, 'operator'),
    0x0E0: ('-=', 'SubtractEqual_VectorVector', 34, 'operator'),
    0x0E1: ('VSize', 'VSize', 0, 'function'),
    0x0E2: ('Normal', 'Normal', 0, 'function'),
    0x0E4: ('VSizeSq', 'VSizeSq', 0, 'function'),
    0x0E5: ('GetAxes', 'GetAxes', 0, 'function'),
    0x0E6: ('GetUnAxes', 'GetUnAxes', 0, 'function'),
    0x0E7: ('LogInternal', 'LogInternal', 0, 'function'),
    0x0E8: ('WarnInternal', 'WarnInternal', 0, 'function'),
    0x0EA: ('Right', 'Right', 0, 'function'),
    0x0EB: ('Caps', 'Caps', 0, 'function'),
    0x0EC: ('Chr', 'Chr', 0, 'function'),
    0x0ED: ('Asc', 'Asc', 0, 'function'),
    0x0EE: ('Locs', 'Locs', 0, 'function'),
    0x0F2: ('==', 'EqualEqual_BoolBool', 24, 'operator'),
    0x0F3: ('!=', 'NotEqual_BoolBool', 26, 'operator'),
    0x0F4: ('FMin', 'FMin', 0, 'function'),
    0x0F5: ('FMax', 'FMax', 0, 'function'),
    0x0F6: ('FClamp', 'FClamp', 0, 'function'),
    0x0F7: ('Lerp', 'Lerp', 0, 'function'),
    0x0F9: ('Min', 'Min', 0, 'function'),
    0x0FA: ('Max', 'Max', 0, 'function'),
    0x0FB: ('Clamp', 'Clamp', 0, 'function'),
    0x0FC: ('VRand', 'VRand', 0, 'function'),
    0x0FD: ('%', 'Percent_IntInt', 18, 'operator'),
    0x0FE: ('==', 'EqualEqual_NameName', 24, 'operator'),
    0x0FF: ('!=', 'NotEqual_NameName', 26, 'operator'),
    0x100: ('Sleep', 'Sleep', 0, 'function'),
    0x102: ('ClassIsChildOf', 'ClassIsChildOf', 0, 'function'),
    0x105: ('FinishAnim', 'FinishAnim', 0, 'function'),
    0x106: ('SetCollision', 'SetCollision', 0, 'function'),
    0x10A: ('Move', 'Move', 0, 'function'),
    0x10B: ('SetLocation', 'SetLocation', 0, 'function'),
    0x10E: ('+', 'Add_QuatQuat', 16, 'operator'),
    0x10F: ('-', 'Subtract_QuatQuat', 16, 'operator'),
    0x110: ('SetOwner', 'SetOwner', 0, 'function'),
    0x113: ('<<', 'LessLess_VectorRotator', 22, 'operator'),
    0x114: ('>>', 'GreaterGreater_VectorRotator', 22, 'operator'),
    0x115: ('Trace', 'Trace', 0, 'function'),
    0x117: ('Destroy', 'Destroy', 0, 'function'),
    0x118: ('SetTimer', 'SetTimer', 0, 'function'),
    0x119: ('IsInState', 'IsInState', 0, 'function'),
    0x11B: ('SetCollisionSize', 'SetCollisionSize', 0, 'function'),
    0x11C: ('GetStateName', 'GetStateName', 0, 'function'),
    0x11F: ('*', 'Multiply_RotatorFloat', 16, 'operator'),
    0x120: ('*', 'Multiply_FloatRotator', 16, 'operator'),
    0x121: ('/', 'Divide_RotatorFloat', 16, 'operator'),
    0x122: ('*=', 'MultiplyEqual_RotatorFloat', 34, 'operator'),
    0x123: ('/=', 'DivideEqual_RotatorFloat', 34, 'operator'),
    0x128: ('*', 'Multiply_VectorVector', 16, 'operator'),
    0x129: ('*=', 'MultiplyEqual_VectorVector', 34, 'operator'),
    0x12A: ('SetBase', 'SetBase', 0, 'function'),
    0x12B: ('SetRotation', 'SetRotation', 0, 'function'),
    0x12C: ('MirrorVectorByNormal', 'MirrorVectorByNormal', 0, 'function'),
    0x130: ('AllActors', 'AllActors', 0, 'iterator'),
    0x131: ('ChildActors', 'ChildActors', 0, 'iterator'),
    0x132: ('BasedActors', 'BasedActors', 0, 'iterator'),
    0x133: ('TouchingActors', 'TouchingActors', 0, 'iterator'),
    0x135: ('TraceActors', 'TraceActors', 0, 'iterator'),
    0x137: ('VisibleActors', 'VisibleActors', 0, 'iterator'),
    0x138: ('VisibleCollidingActors', 'VisibleCollidingActors', 0, 'iterator'),
    0x139: ('DynamicActors', 'DynamicActors', 0, 'iterator'),
    0x13C: ('+', 'Add_RotatorRotator', 20, 'operator'),
    0x13D: ('-', 'Subtract_RotatorRotator', 20, 'operator'),
    0x13E: ('+=', 'AddEqual_RotatorRotator', 34, 'operator'),
    0x13F: ('-=', 'SubtractEqual_RotatorRotator', 34, 'operator'),
    0x140: ('RotRand', 'RotRand', 0, 'function'),
    0x141: ('CollidingActors', 'CollidingActors', 0, 'iterator'),
    0x142: ('$=', 'ConcatEqual_StrStr', 44, 'operator'),
    0x143: ('@=', 'AtEqual_StrStr', 44, 'operator'),
    0x144: ('-=', 'SubtractEqual_StrStr', 45, 'operator'),
    0x1F4: ('MoveTo', 'MoveTo', 0, 'function'),
    0x1F6: ('MoveToward', 'MoveToward', 0, 'function'),
    0x1FC: ('FinishRotation', 'FinishRotation', 0, 'function'),
    0x200: ('MakeNoise', 'MakeNoise', 0, 'function'),
    0x202: ('LineOfSightTo', 'LineOfSightTo', 0, 'function'),
    0x205: ('FindPathToward', 'FindPathToward', 0, 'function'),
    0x206: ('FindPathTo', 'FindPathTo', 0, 'function'),
    0x208: ('ActorReachable', 'ActorReachable', 0, 'function'),
    0x209: ('PointReachable', 'PointReachable', 0, 'function'),
    0x20C: ('FindStairRotation', 'FindStairRotation', 0, 'function'),
    0x20D: ('FindRandomDest', 'FindRandomDest', 0, 'function'),
    0x20E: ('PickWallAdjust', 'PickWallAdjust', 0, 'function'),
    0x20F: ('WaitForLanding', 'WaitForLanding', 0, 'function'),
    0x213: ('PickTarget', 'PickTarget', 0, 'function'),
    0x214: ('PlayerCanSeeMe', 'PlayerCanSeeMe', 0, 'function'),
    0x215: ('CanSee', 'CanSee', 0, 'function'),
    0x218: ('SaveConfig', 'SaveConfig', 0, 'function'),
    0x219: ('CanSeeByPoints', 'CanSeeByPoints', 0, 'function'),
    0x222: ('UpdateURL', 'UpdateURL', 0, 'function'),
    0x223: ('GetURLMap', 'GetURLMap', 0, 'function'),
    0x224: ('FastTrace', 'FastTrace', 0, 'function'),
    0x5DC: ('ProjectOnTo', 'ProjectOnTo', 0, 'function'),
    0x5DD: ('IsZero', 'IsZero', 0, 'function'),
    0xF81: ('MoveSmooth', 'MoveSmooth', 0, 'function'),
    0xF82: ('SetPhysics', 'SetPhysics', 0, 'function'),
    0xF83: ('AutonomousPhysics', 'AutonomousPhysics', 0, 'function'),
}

NATIVE_NAME = {index: entry[0] for index, entry in NATIVES.items()}


def decode_native(first_byte, second_byte=0):
    if first_byte >= FIRST_NATIVE:
        return first_byte, 1
    return ((first_byte - EXTENDED_NATIVE) << 8) | second_byte, 2


def native_call_bytes(index):
    if index >= FIRST_NATIVE and index < 0x100:
        return bytes((index,))
    return bytes((EXTENDED_NATIVE + (index >> 8), index & 0xFF))
