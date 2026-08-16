import struct
def ri(b,o): return struct.unpack_from('<i',b,o)[0]

class Dis:
    def __init__(self,p): self.p=p
    def name(self,s,o): return self.p.nm(ri(s,o))+("_%d"%(ri(s,o+4)-1) if ri(s,o+4)>0 else ""),o+8
    def objr(self,s,o):
        v=ri(s,o); return (self.p.ref_name(v) or 'None'),o+4
    def path(self,s,o):
        v=ri(s,o); return (self.p.path(v) if v else 'None'),o+4
    def expr(self,s,o,out,d=0):
        op=s[o]; o+=1; ind='  '*d
        def em(t): out.append(ind+t)
        if op in (0x00,0x01,0x02,0x03,0x48,0x29,0x3A,0x0E,0x20):
            n,o=self.path(s,o); em({0x00:'Local',0x01:'Inst',0x02:'Default',0x03:'StateVar',0x48:'LocalOut',0x29:'NativeParm',0x3A:'ReturnNothing',0x0E:'EatReturnValue',0x20:'ObjConst'}[op]+' '+n); return o
        if op==0x04: em('Return'); return self.expr(s,o,out,d+1)
        if op==0x05:
            sz=s[o]; o+=1; em('Switch size=%d'%sz); return self.expr(s,o,out,d+1)
        if op==0x06: em('Jump %d'%struct.unpack_from('<H',s,o)[0]); return o+2
        if op==0x07: em('JumpIfNot %d'%struct.unpack_from('<H',s,o)[0]); o+=2; return self.expr(s,o,out,d+1)
        if op==0x08: em('Stop'); return o
        if op==0x09: em('Assert'); o+=3; return self.expr(s,o,out,d+1)
        if op==0x0A:
            w=struct.unpack_from('<H',s,o)[0]; o+=2; em('Case %d'%w)
            return o if w==0xFFFF else self.expr(s,o,out,d+1)
        if op==0x0B: em('Nothing'); return o
        if op==0x0C:
            em('LabelTable')
            while True:
                n,o=self.name(s,o); o+=4
                if n=='None': break
            return o
        if op==0x0D: em('GotoLabel'); return self.expr(s,o,out,d+1)
        if op in (0x0F,0x14,0x44,0x10,0x1A,0x39,0x40,0x46,0x54):
            em({0x0F:'Let',0x14:'LetBool',0x44:'LetDelegate',0x10:'DynArrayElem',0x1A:'ArrayElem',0x39:'DynArrayInsert',0x40:'DynArrayRemove',0x46:'DynArrayFind',0x54:'DynArrayAdd'}[op])
            o=self.expr(s,o,out,d+1); o=self.expr(s,o,out,d+1)
            if op in (0x39,0x40): o=self.expr(s,o,out,d+1)
            return o
        if op==0x11:
            em('New')
            for _ in range(4): o=self.expr(s,o,out,d+1)
            return o
        if op in (0x12,0x19):
            em('ClassContext' if op==0x12 else 'Context')
            o=self.expr(s,o,out,d+1); o+=2
            n,o=self.path(s,o); o+=1
            out.append('  '*(d+1)+'-> field '+n)
            return self.expr(s,o,out,d+1)
        if op in (0x13,0x2E,0x52):
            n,o=self.objr(s,o); em({0x13:'MetaCast',0x2E:'DynamicCast',0x52:'InterfaceCast'}[op]+' '+n)
            return self.expr(s,o,out,d+1)
        if op==0x15: em('EndParmValue'); return o
        if op==0x16: em('EndFunctionParms'); return o
        if op==0x17: em('Self'); return o
        if op==0x18: em('Skip'); o+=2; return self.expr(s,o,out,d+1)
        if op in (0x1B,0x37):
            n,o=self.name(s,o); em(('VirtualFunction ' if op==0x1B else 'GlobalFunction ')+n)
            while s[o]!=0x16: o=self.expr(s,o,out,d+1)
            out.append('  '*(d+1)+'EndFunctionParms'); return o+1
        if op==0x1C:
            n,o=self.path(s,o); em('FinalFunction '+n)
            while s[o]!=0x16: o=self.expr(s,o,out,d+1)
            out.append('  '*(d+1)+'EndFunctionParms'); return o+1
        if op==0x42:
            o+=1; n,o=self.path(s,o); n2,o=self.name(s,o); em('DelegateFunction %s %s'%(n,n2))
            while s[o]!=0x16: o=self.expr(s,o,out,d+1)
            out.append('  '*(d+1)+'EndFunctionParms'); return o+1
        if op==0x1D: em('Int %d'%ri(s,o)); return o+4
        if op==0x1E: em('Float %g'%struct.unpack_from('<f',s,o)[0]); return o+4
        if op==0x1F:
            e=s.index(b'\0',o); em('Str "%s"'%s[o:e].decode('latin1')); return e+1
        if op==0x34:
            e=o
            while s[e]!=0 or s[e+1]!=0: e+=2
            em('UStr "%s"'%s[o:e].decode('utf-16le','replace')); return e+2
        if op==0x21: n,o=self.name(s,o); em("Name '%s'"%n); return o
        if op==0x22: em('RotConst'); return o+12
        if op==0x23: em('VecConst'); return o+12
        if op==0x24: em('Byte %d'%s[o]); return o+1
        if op==0x2C: em('IntConstByte %d'%s[o]); return o+1
        if op==0x25: em('IntZero'); return o
        if op==0x26: em('IntOne'); return o
        if op==0x27: em('True'); return o
        if op==0x28: em('False'); return o
        if op==0x2A: em('NoObject'); return o
        if op==0x2D: em('BoolVar'); return self.expr(s,o,out,d+1)
        if op==0x2F: em('Iterator'); o=self.expr(s,o,out,d+1); return o+2
        if op==0x30: em('IteratorPop'); return o
        if op==0x31: em('IteratorNext'); return o
        if op in (0x32,0x33):
            n,o=self.objr(s,o); em('StructCmp '+n)
            o=self.expr(s,o,out,d+1); return self.expr(s,o,out,d+1)
        if op==0x35:
            n,o=self.path(s,o); n2,o=self.objr(s,o); o+=2
            em('StructMember %s (of %s)'%(n,n2)); return self.expr(s,o,out,d+1)
        if op==0x36: em('DynArrayLength'); return self.expr(s,o,out,d+1)
        if op==0x38: em('Cast %d'%s[o]); o+=1; return self.expr(s,o,out,d+1)
        if op in (0x3B,0x3C,0x3D,0x3E,0x3F): em('DelegateCmp/Empty %02x'%op); return o
        if op==0x41: em('DebugInfo'); return o+16
        if op==0x43:
            n,o=self.name(s,o); n2,o=self.objr(s,o); em('DelegateProperty %s %s'%(n,n2)); return o
        if op==0x45:
            em('Conditional'); o=self.expr(s,o,out,d+1); o+=2
            o=self.expr(s,o,out,d+1); o+=2; return self.expr(s,o,out,d+1)
        if op==0x47:
            em('DynArrayFindStruct')
            for _ in range(3): o=self.expr(s,o,out,d+1)
            return o
        if op==0x49: em('DefaultParmValue'); o+=2; return self.expr(s,o,out,d+1)
        if op==0x4A: em('EmptyParmValue'); return o
        if op==0x4B: n,o=self.name(s,o); em('InstanceDelegate '+n); return o
        if op==0x51: em('InterfaceContext'); return self.expr(s,o,out,d+1)
        if op==0x53: em('EndOfScript'); return o
        if op in (0x55,0x56,0x57):
            em('DynArray%sItem'%{0x55:'Add',0x56:'Remove',0x57:'Insert'}[op])
            o=self.expr(s,o,out,d+1); o+=2; o=self.expr(s,o,out,d+1)
            if op==0x57: o=self.expr(s,o,out,d+1)
            return o+1
        if op==0x58:
            em('DynArrayIterator'); o=self.expr(s,o,out,d+1); o=self.expr(s,o,out,d+1)
            o+=2; o=self.expr(s,o,out,d+1); return o+2
        if op==0x59:
            em('DynArraySort'); o=self.expr(s,o,out,d+1); o+=2; return self.expr(s,o,out,d+1)
        if 0x60<=op<=0x6F:
            idx=((op-0x60)<<8)|s[o]; o+=1; em('Native%d'%idx)
            while s[o]!=0x16: o=self.expr(s,o,out,d+1)
            out.append('  '*(d+1)+'EndFunctionParms'); return o+1
        if op>=0x70:
            em('Native%d'%op)
            while s[o]!=0x16: o=self.expr(s,o,out,d+1)
            out.append('  '*(d+1)+'EndFunctionParms'); return o+1
        raise ValueError('op %02X at %d'%(op,o-1))
    def run(self,s):
        out=[]; o=0
        while o<len(s): o=self.expr(s,o,out,0)
        if o!=len(s): raise ValueError('overrun %d != %d'%(o,len(s)))
        return out
