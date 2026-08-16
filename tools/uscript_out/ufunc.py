import struct, sys, os
sys.path.insert(0, '/Users/anna/RustroverProjects/hysteria/tools')
from upk import decompress_package

def ri(b,o): return struct.unpack_from('<i',b,o)[0]
def ru(b,o): return struct.unpack_from('<I',b,o)[0]

class P:
    def __init__(self, path):
        self.b = decompress_package(path)
        b=self.b
        o=0x0c
        flen=ri(b,o); o+=4+(flen if flen>0 else 0)
        o+=4
        self.name_count=ri(b,o); self.name_off=ri(b,o+4)
        self.export_count=ri(b,o+8); self.export_off=ri(b,o+12)
        self.import_count=ri(b,o+16); self.import_off=ri(b,o+20)
        self.names=[]; self.imports=[]; self.exports=[]
        self._names(); self._imports(); self._exports()
    def _fstr(self,o):
        n=ri(self.b,o)
        if n==0: return "",o+4
        if n<0: return self.b[o+4:o+4-n*2].decode('utf-16le','replace').rstrip('\0'),o+4-n*2
        return self.b[o+4:o+4+n].decode('latin1','replace').rstrip('\0'),o+4+n
    def _names(self):
        o=self.name_off
        for _ in range(self.name_count):
            s,o=self._fstr(o); o+=8; self.names.append(s)
    def nm(self,i): return self.names[i] if 0<=i<len(self.names) else "?%d"%i
    def _fname(self,o):
        idx=ri(self.b,o); num=ri(self.b,o+4)
        return self.nm(idx)+("_%d"%(num-1) if num>0 else ""), o+8
    def _imports(self):
        o=self.import_off
        for _ in range(self.import_count):
            pkg,o=self._fname(o); cls,o=self._fname(o)
            outer=ri(self.b,o); o+=4
            name,o=self._fname(o)
            self.imports.append({'name':name,'cls':cls,'outer':outer,'pkg':pkg})
    def _exports(self):
        o=self.export_off
        for _ in range(self.export_count):
            ci=ri(self.b,o); si=ri(self.b,o+4); oi=ri(self.b,o+8); o+=12
            name,o=self._fname(o)
            arch=ri(self.b,o); o+=4
            flags=struct.unpack_from('<Q',self.b,o)[0]; o+=8
            ssize=ri(self.b,o); soff=ri(self.b,o+4); o+=8
            eflags=ri(self.b,o); o+=4
            nc=ri(self.b,o); o+=4+nc*4
            o+=16+4
            self.exports.append({'ci':ci,'si':si,'oi':oi,'name':name,'size':ssize,'off':soff,'flags':flags})
    def ref_name(self,i):
        if i==0: return None
        if i<0:
            j=-i-1
            return self.imports[j]['name'] if 0<=j<len(self.imports) else "?imp%d"%j
        j=i-1
        return self.exports[j]['name'] if 0<=j<len(self.exports) else "?exp%d"%j
    def ref_outer(self,i):
        if i==0: return 0
        if i<0:
            j=-i-1
            return self.imports[j]['outer'] if 0<=j<len(self.imports) else 0
        j=i-1
        return self.exports[j]['oi'] if 0<=j<len(self.exports) else 0
    def path(self,i):
        parts=[]; seen=0
        while i!=0 and seen<12:
            parts.append(self.ref_name(i)); i=self.ref_outer(i); seen+=1
        return ".".join(reversed(parts))
    def class_of(self,e):
        c=self.ref_name(e['ci'])
        return c if c else "Class"

FUNC = {
 0x00000001:'Final',0x00000002:'Defined',0x00000004:'Iterator',0x00000008:'Latent',
 0x00000010:'PreOperator',0x00000020:'Singular',0x00000040:'Net',0x00000080:'NetReliable',
 0x00000100:'Simulated',0x00000200:'Exec',0x00000400:'Native',0x00000800:'Event',
 0x00001000:'Operator',0x00002000:'Static',0x00004000:'HasOptionalParms',0x00008000:'Const',
 0x00020000:'Public',0x00040000:'Private',0x00080000:'Protected',0x00100000:'Delegate',
 0x00200000:'NetServer',0x00400000:'HasOutParms',0x00800000:'HasDefaults',0x01000000:'NetClient',
 0x02000000:'DLLImport',
}
ACCESS = 0x00020000|0x00040000|0x00080000

def _valid(fl):
    if fl & 0xFC010000: return False
    acc = ((fl>>17)&1)+((fl>>18)&1)+((fl>>19)&1)
    return acc==1

def func_info(p,e):
    b=p.b; end=e['off']+e['size']
    fn_idx=ri(b,end-8); fn_num=ri(b,end-4)
    friendly=p.nm(fn_idx)+("_%d"%(fn_num-1) if fn_num>0 else "")
    for back in (12,14):
        if end-back-3 < e['off']: continue
        fl=ru(b,end-back)
        if not _valid(fl): continue
        if back==14 and not (fl & 0x40): continue
        if back==12 and (fl & 0x40): continue
        inat=struct.unpack_from('<H',b,end-back-3)[0]
        return friendly,fl,inat,end-back-3
    return friendly,None,None,None
def flagstr(fl):
    return "|".join(v for k,v in sorted(FUNC.items()) if fl&k) or "0"
