class GFxValue extends Object
    native
    notplaceable
    within GFxMovie;

struct native ASColorTransform
{
    var() LinearColor Multiply;
    var() LinearColor Add;
};

struct native ASDisplayInfo
{
    var() float X;
    var() float Y;
    var() float Z;
    var() float Rotation;
    var() float XRotation;
    var() float YRotation;
    var() float XScale;
    var() float YScale;
    var() float ZScale;
    var() float Alpha;
    var() bool Visible;
    var() bool hasX;
    var() bool hasY;
    var() bool hasZ;
    var() bool hasRotation;
    var() bool hasXRotation;
    var() bool hasYRotation;
    var() bool hasXScale;
    var() bool hasYScale;
    var() bool hasZScale;
    var() bool hasAlpha;
    var() bool hasVisible;
};

var const native int Value[12];

native protected final function ActionScriptSetFunctionOn(GFxValue Target, string member)
{
    Target;
    member;
}

native protected final function ActionScriptSetFunction(string member)
{
    member;
}

native protected final function array<GFxValue> ActionScriptArray(string Path)
{
    Path;
}

native protected final function GFxValue ActionScriptObject(string Path)
{
    Path;
}

native protected final function string ActionScriptString(string method)
{
    method;
}

native protected final function float ActionScriptFloat(string method)
{
    method;
}

native protected final function int ActionScriptInt(string method)
{
    method;
}

native protected final function ActionScriptVoid(string method)
{
    method;
}

native final function SetElementMemberString(int Index, string member, string S)
{
    Index;
    member;
    S;
}

native final function SetElementMemberNumber(int Index, string member, float F)
{
    Index;
    member;
    F;
}

native final function SetElementMemberBool(int Index, string member, bool B)
{
    Index;
    member;
    B;
}

native final function SetElementMemberObject(int Index, string member, GFxValue val)
{
    Index;
    member;
    val;
}

native final function SetElementMember(int Index, string member, ASValue Arg)
{
    Index;
    member;
    Arg;
}

native final function string GetElementMemberString(int Index, string member)
{
    Index;
    member;
}

native final function float GetElementMemberNumber(int Index, string member)
{
    Index;
    member;
}

native final function bool GetElementMemberBool(int Index, string member)
{
    Index;
    member;
}

native final function GFxValue GetElementMemberObject(int Index, string member, optional class<GFxValue> Type = class'GFxValue')
{
    Index;
    member;
    Type;
}

native final function ASValue GetElementMember(int Index, string member)
{
    Index;
    member;
}

native final function SetElementColorTransform(int Index, ASColorTransform cxform)
{
    Index;
    cxform;
}

native final function SetElementPosition(int Index, float X, float Y)
{
    Index;
    X;
    Y;
}

native final function SetElementVisible(int Index, bool Visible)
{
    Index;
    Visible;
}

native final function SetElementDisplayMatrix(int Index, Matrix M)
{
    Index;
    M;
}

native final function SetElementDisplayInfo(int Index, ASDisplayInfo D)
{
    Index;
    D;
}

native final function SetElementString(int Index, string S)
{
    Index;
    S;
}

native final function SetElementNumber(int Index, float F)
{
    Index;
    F;
}

native final function SetElementBool(int Index, bool B)
{
    Index;
    B;
}

native final function SetElementObject(int Index, GFxValue val)
{
    Index;
    val;
}

native final function SetElement(int Index, ASValue Arg)
{
    Index;
    Arg;
}

native final function Matrix GetElementDisplayMatrix(int Index)
{
    Index;
}

native final function ASDisplayInfo GetElementDisplayInfo(int Index)
{
    Index;
}

native final function string GetElementString(int Index)
{
    Index;
}

native final function float GetElementNumber(int Index)
{
    Index;
}

native final function bool GetElementBool(int Index)
{
    Index;
}

native final function GFxValue GetElementObject(int Index, optional class<GFxValue> Type = class'GFxValue')
{
    Index;
    Type;
}

native final function ASValue GetElement(int Index)
{
    Index;
}

native final function SetText(coerce string Text)
{
    Text;
}

native final function string GetText()
{
}

native final function GFxValue AttachMovie(string symbolname, string instancename, optional int Depth = -1, optional class<GFxValue> Type = class'GFxValue')
{
    symbolname;
    instancename;
    Depth;
    Type;
}

native final function GFxValue CreateEmptyMovieClip(string instancename, optional int Depth = -1, optional class<GFxValue> Type = class'GFxValue')
{
    instancename;
    Depth;
    Type;
}

native final function GotoAndStopI(int frame)
{
    frame;
}

native final function GotoAndStop(string frame)
{
    frame;
}

native final function GotoAndPlayI(int frame)
{
    frame;
}

native final function GotoAndPlay(string frame)
{
    frame;
}

native final function SetColorTransform(ASColorTransform cxform)
{
    cxform;
}

native final function SetPosition(float X, float Y)
{
    X;
    Y;
}

native final function SetVisible(bool Visible)
{
    Visible;
}

native final function SetDisplayMatrix3D(Matrix M)
{
    M;
}

native final function SetDisplayMatrix(Matrix M)
{
    M;
}

native final function SetDisplayInfo(ASDisplayInfo D)
{
    D;
}

native final function bool GetPosition(out float X, out float Y)
{
    X;
    Y;
}

native final function ASColorTransform GetColorTransform()
{
}

native final function Matrix GetDisplayMatrix()
{
}

native final function ASDisplayInfo GetDisplayInfo()
{
}

native final function SetString(string member, string S)
{
    member;
    S;
}

native final function SetNumber(string member, float F)
{
    member;
    F;
}

native final function SetBool(string member, bool B)
{
    member;
    B;
}

native final function SetFunction(string member, Object context, name fname)
{
    member;
    context;
    fname;
}

native final function SetObject(string member, GFxValue val)
{
    member;
    val;
}

native final function Set(string member, ASValue Arg)
{
    member;
    Arg;
}

native final function string GetString(string member)
{
    member;
}

native final function float GetNumber(string member)
{
    member;
}

native final function bool GetBool(string member)
{
    member;
}

native final function GFxValue GetObject(string member, optional class<GFxValue> Type = class'GFxValue')
{
    member;
    Type;
}

native final function ASValue Get(string member)
{
    member;
}

native final function ASValue Invoke(string member, array<ASValue> args)
{
    member;
    args;
}

defaultproperties
{
}
