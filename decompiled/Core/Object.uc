class Object
    abstract
    native
    noexport
    notplaceable;

const InvAspectRatio16x9 = 0.56249;
const InvAspectRatio5x4 = 0.8;
const InvAspectRatio4x3 = 0.75;
const AspectRatio16x9 = 1.77778;
const AspectRatio5x4 = 1.25;
const AspectRatio4x3 = 1.33333;
const INDEX_NONE = -1;
const RadToUnrRot = 10430.3783504704527;
const UnrRotToRad = 0.00009587379924285;
const DegToRad = 0.017453292519943296;
const RadToDeg = 57.295779513082321600;
const Pi = 3.1415926535897932;
const MaxInt = 0x7fffffff;

enum EDebugBreakType
{
    DEBUGGER_NativeOnly,
    DEBUGGER_ScriptOnly,
    DEBUGGER_Both,
};

enum EAutomatedRunResult
{
    ARR_Unknown,
    ARR_OOM,
    ARR_Passed,
};

enum ETickingGroup
{
    TG_PreAsyncWork,
    TG_DuringAsyncWork,
    TG_PostAsyncWork,
    TG_PostUpdateWork,
};

enum EInterpMethodType
{
    IMT_UseFixedTangentEvalAndNewAutoTangents,
    IMT_UseFixedTangentEval,
    IMT_UseBrokenTangentEval,
};

enum EInterpCurveMode
{
    CIM_Linear,
    CIM_CurveAuto,
    CIM_Constant,
    CIM_CurveUser,
    CIM_CurveBreak,
    CIM_CurveAutoClamped,
};

enum EInputEvent
{
    IE_Pressed,
    IE_Released,
    IE_Repeat,
    IE_DoubleClick,
    IE_Axis,
};

enum EAxis
{
    AXIS_NONE,
    AXIS_X,
    AXIS_Y,
    AXIS_BLANK,
    AXIS_Z,
};

enum AlphaBlendType
{
    ABT_Linear,
    ABT_Cubic,
    ABT_Sinusoidal,
    ABT_EaseInOutExponent2,
    ABT_EaseInOutExponent3,
    ABT_EaseInOutExponent4,
    ABT_EaseInOutExponent5,
};

struct BoneAtom
{
    var Quat Rotation;
    var Vector Translation;
    var float Scale;
};

struct OctreeElementId
{
    var const native Pointer Node;
    var const native int ElementIndex;
};

struct RenderCommandFence
{
    var const native int NumPendingFences;
};

struct RawDistribution
{
    var byte Type;
    var byte Op;
    var byte LookupTableNumElements;
    var byte LookupTableChunkSize;
    var array<float> LookupTable;
    var float LookupTableTimeScale;
    var float LookupTableStartTime;
};

struct InterpCurveLinearColor
{
    var() array<InterpCurvePointLinearColor> Points;
    var EInterpMethodType InterpMethod;
};

struct InterpCurvePointLinearColor
{
    var() float InVal;
    var() LinearColor OutVal;
    var() LinearColor ArriveTangent;
    var() LinearColor LeaveTangent;
    var() EInterpCurveMode InterpMode;
};

struct InterpCurveQuat
{
    var() array<InterpCurvePointQuat> Points;
    var EInterpMethodType InterpMethod;
};

struct InterpCurvePointQuat
{
    var() float InVal;
    var() Quat OutVal;
    var() Quat ArriveTangent;
    var() Quat LeaveTangent;
    var() EInterpCurveMode InterpMode;
};

struct InterpCurveTwoVectors
{
    var() array<InterpCurvePointTwoVectors> Points;
    var EInterpMethodType InterpMethod;
};

struct InterpCurvePointTwoVectors
{
    var() float InVal;
    var() TwoVectors OutVal;
    var() TwoVectors ArriveTangent;
    var() TwoVectors LeaveTangent;
    var() EInterpCurveMode InterpMode;
};

struct InterpCurveVector
{
    var() array<InterpCurvePointVector> Points;
    var EInterpMethodType InterpMethod;
};

struct InterpCurvePointVector
{
    var() float InVal;
    var() Vector OutVal;
    var() Vector ArriveTangent;
    var() Vector LeaveTangent;
    var() EInterpCurveMode InterpMode;
};

struct InterpCurveVector2D
{
    var() array<InterpCurvePointVector2D> Points;
    var EInterpMethodType InterpMethod;
};

struct InterpCurvePointVector2D
{
    var() float InVal;
    var() Vector2D OutVal;
    var() Vector2D ArriveTangent;
    var() Vector2D LeaveTangent;
    var() EInterpCurveMode InterpMode;
};

struct InterpCurveFloat
{
    var() array<InterpCurvePointFloat> Points;
    var EInterpMethodType InterpMethod;
};

struct InterpCurvePointFloat
{
    var() float InVal;
    var() float OutVal;
    var() float ArriveTangent;
    var() float LeaveTangent;
    var() EInterpCurveMode InterpMode;
};

struct Cylinder
{
    var float Radius;
    var float Height;
};

struct immutable Matrix
{
    var() Plane XPlane;
    var() Plane YPlane;
    var() Plane ZPlane;
    var() Plane WPlane;
};

struct AlignedBoxSphereBounds
{
    var Vector Origin;
    var float SphereRadius;
    var Vector BoxExtent;
};

struct BoxSphereBounds
{
    var Vector Origin;
    var Vector BoxExtent;
    var float SphereRadius;
};

struct immutable Box
{
    var() Vector Min;
    var() Vector Max;
    var byte IsValid;
};

struct immutable LinearColor
{
    var() float R;
    var() float G;
    var() float B;
    var() float A;
};

struct immutable Color
{
    var() byte B;
    var() byte G;
    var() byte R;
    var() byte A;
};

struct TAlphaBlend
{
    var const float AlphaIn;
    var const float AlphaOut;
    var() float AlphaTarget;
    var() float BlendTime;
    var const float BlendTimeToGo;
    var() AlphaBlendType BlendType;
};

struct TPOV
{
    var() Vector Location;
    var() Rotator Rotation;
    var() float FOV;
};

struct SHVectorRGB
{
    var() SHVector R;
    var() SHVector G;
    var() SHVector B;
};

struct SHVector
{
    var() float V[9];
    var float Padding[3];
};

struct immutable IntPoint
{
    var() int X;
    var() int Y;
};

struct immutable Quat
{
    var() float X;
    var() float Y;
    var() float Z;
    var() float W;
};

struct immutable Rotator
{
    var() int Pitch;
    var() int Yaw;
    var() int Roll;
};

struct immutable Plane extends Vector
{
    var() float W;
};

struct immutable TwoVectors
{
    var() Vector v1;
    var() Vector v2;
};

struct immutable Vector2D
{
    var() float X;
    var() float Y;
};

struct immutable Vector4
{
    var() float X;
    var() float Y;
    var() float Z;
    var() float W;
};

struct immutable Vector
{
    var() float X;
    var() float Y;
    var() float Z;
};

struct immutable Guid
{
    var int A;
    var int B;
    var int C;
    var int D;
};

struct Array_Mirror
{
    var const native Pointer Data;
    var const native int ArrayNum;
    var const native int ArrayMax;
};

struct IndirectArray_Mirror
{
    var const native Pointer Data;
    var const native int ArrayNum;
    var const native int ArrayMax;
};

struct FColorVertexBuffer_Mirror
{
    var const native Pointer VfTable;
    var const native Pointer VertexData;
    var const int Data;
    var const int Stride;
    var const int NumVertices;
};

struct RenderCommandFence_Mirror
{
    var const native transient int NumPendingFences;
};

struct UntypedBulkData_Mirror
{
    var const native Pointer VfTable;
    var const native int BulkDataFlags;
    var const native int ElementCount;
    var const native int BulkDataOffsetInFile;
    var const native int BulkDataSizeOnDisk;
    var const native int SavedBulkDataFlags;
    var const native int SavedElementCount;
    var const native int SavedBulkDataOffsetInFile;
    var const native int SavedBulkDataSizeOnDisk;
    var const native Pointer BulkData;
    var const native int LockStatus;
    var const native Pointer AttachedAr;
    var const native int bShouldFreeOnEmpty;
};

struct MultiMap_Mirror
{
    var const native Set_Mirror Pairs;
};

struct Map_Mirror
{
    var const native Set_Mirror Pairs;
};

struct Set_Mirror
{
    var const native SparseArray_Mirror Elements;
    var const native Pointer Hash;
    var const native int InlineHash;
    var const native int HashSize;
};

struct SparseArray_Mirror
{
    var const native array<int> Elements;
    var const native BitArray_Mirror AllocationFlags;
    var const native int FirstFreeIndex;
    var const native int NumFreeIndices;
};

struct BitArray_Mirror
{
    var const native Pointer IndirectData;
    var const native int InlineData[4];
    var const native int NumBits;
    var const native int MaxBits;
};

struct ThreadSafeCounter
{
    var const native int Value;
};

struct Double
{
    var const native int A;
    var const native int B;
};

struct QWord
{
    var const native int A;
    var const native int B;
};

struct Pointer
{
    var const native int Dummy;
};

var const native noexport editconst Pointer VfTableObject;
var const native noexport editconst int ObjectInternalInteger;
var const native editconst QWord ObjectFlags;
var const native editconst Pointer HashNext;
var const native editconst Pointer HashOuterNext;
var const native editconst Pointer StateFrame;
var const native noexport editconst Object Linker;
var const native noexport editconst Pointer LinkerIndex;
var const native noexport editconst int NetIndex;
var const native editconst Object Outer;
var() const native editconst name Name;
var const native editconst class<Object> Class;
var() const native editconst Object ObjectArchetype;

native final function int GetBuildChangelistNumber()
{
}

native final function int GetEngineVersion()
{
}

native final function GetSystemTime(out int Year, out int Month, out int DayOfWeek, out int Day, out int Hour, out int Min, out int Sec, out int MSec)
{
    Year;
    Month;
    DayOfWeek;
    Day;
    Hour;
    Min;
    Sec;
    MSec;
}

native final function string TimeStamp()
{
}

native final function Vector TransformVectorByRotation(Rotator SourceRotation, Vector SourceVector, optional bool bInverse)
{
    SourceRotation;
    SourceVector;
    bInverse;
}

final function name GetPackageName()
{
    local Object O;
    
    O = self;
    while (O.Outer != none)
    {
        O = O.Outer;
    }
    return O.Name;
}

native final function bool IsPendingKill()
{
}

final simulated function float ByteToFloat(byte inputByte, optional bool bSigned)
{
    if (bSigned)
    {
        return float(inputByte) / 128.0 - 1.0;
    }
    else
    {
        return float(inputByte) / 255.0;
    }
}

final simulated function byte FloatToByte(float inputFloat, optional bool bSigned)
{
    if (bSigned)
    {
        if (inputFloat > 0.98)
        {
            return 255;
        }
        else if (inputFloat < -0.98)
        {
            return 0;
        }
        else
        {
            return byte((inputFloat + 1.0) * 128.0);
        }
    }
    else if (inputFloat > 0.9961)
    {
        return 255;
    }
    else if (inputFloat < 0.004)
    {
        return 0;
    }
    else
    {
        return byte(inputFloat * 255.0);
    }
}

static final simulated function float UnwindHeading(float A)
{
    while (A > 3.1415927)
    {
        A -= 3.1415927 * 2.0;
    }
    while (A < -3.1415927)
    {
        A += 3.1415927 * 2.0;
    }
    return A;
}

static final simulated function float FindDeltaAngle(float A1, float A2)
{
    local float Delta;
    
    Delta = A2 - A1;
    if (Delta > 3.1415927)
    {
        Delta = Delta - 3.1415927 * 2.0;
    }
    else if (Delta < -3.1415927)
    {
        Delta = Delta + 3.1415927 * 2.0;
    }
    return Delta;
}

static final simulated function float GetHeadingAngle(Vector Dir)
{
    local float Angle;
    
    Angle = Acos(FClamp(Dir.X, -1.0, 1.0));
    if (Dir.Y < 0.0)
    {
        Angle *= -1.0;
    }
    return Angle;
}

static final simulated function GetAngularDegreesFromRadians(out Vector2D OutFOV)
{
    OutFOV.X = OutFOV.X * 57.29578;
    OutFOV.Y = OutFOV.Y * 57.29578;
}

native static final function GetAngularFromDotDist(out Vector2D OutAngDist, Vector2D DotDist)
{
    OutAngDist;
    DotDist;
}

native static final function bool GetAngularDistance(out Vector2D OutAngularDist, Vector Direction, Vector AxisX, Vector AxisY, Vector AxisZ)
{
    OutAngularDist;
    Direction;
    AxisX;
    AxisY;
    AxisZ;
}

native static final function bool GetDotDistance(out Vector2D OutDotDist, Vector Direction, Vector AxisX, Vector AxisY, Vector AxisZ)
{
    OutDotDist;
    Direction;
    AxisX;
    AxisY;
    AxisZ;
}

native static final function Vector PointProjectToPlane(Vector Point, Vector A, Vector B, Vector C)
{
    Point;
    A;
    B;
    C;
}

final simulated function float PointDistToPlane(Vector Point, Rotator Orientation, Vector Origin, optional out Vector out_ClosestPoint)
{
    local Vector AxisX, AxisY, AxisZ, PointNoZ, OriginNoZ;
    local float fPointZ, fProjDistToAxis;
    
    GetAxes(Orientation, AxisX, AxisY, AxisZ);
    fPointZ = Point Dot AxisZ;
    PointNoZ = Point - fPointZ * AxisZ;
    OriginNoZ = Origin - Origin Dot AxisZ * AxisZ;
    fProjDistToAxis = (PointNoZ - OriginNoZ) Dot AxisX;
    out_ClosestPoint = OriginNoZ + fProjDistToAxis * AxisX + fPointZ * AxisZ;
    return VSize(out_ClosestPoint - Point);
}

native final function float PointDistToSegment(Vector Point, Vector StartPoint, Vector EndPoint, optional out Vector OutClosestPoint)
{
    Point;
    StartPoint;
    EndPoint;
    OutClosestPoint;
}

native final function float PointDistToLine(Vector Point, Vector Line, Vector Origin, optional out Vector OutClosestPoint)
{
    Point;
    Line;
    Origin;
    OutClosestPoint;
}

native static final function bool GetPerObjectConfigSections(class<Object> SearchClass, out array<string> out_SectionNames, optional Object ObjectOuter, optional int MaxResults = 1024)
{
    SearchClass;
    out_SectionNames;
    ObjectOuter;
    MaxResults;
}

native static final function StaticSaveConfig()
{
}

native(536) final function SaveConfig()
{
}

native static final function Object FindObject(string ObjectName, class<Object> ObjectClass)
{
    ObjectName;
    ObjectClass;
}

native static final function Object DynamicLoadObject(string ObjectName, class<Object> ObjectClass, optional bool MayFail)
{
    ObjectName;
    ObjectClass;
    MayFail;
}

native static final function name GetEnum(Object E, coerce int I)
{
    E;
    I;
}

native(118) final function Disable(name ProbeFunc)
{
    ProbeFunc;
}

native(117) final function Enable(name ProbeFunc)
{
    ProbeFunc;
}

event ContinuedState()
{
}

event PausedState()
{
}

event PoppedState()
{
}

event PushedState()
{
}

event EndState(name NextStateName)
{
}

event BeginState(name PreviousStateName)
{
}

native final function DumpStateStack()
{
}

native final function PopState(optional bool bPopAll)
{
    bPopAll;
}

native final function PushState(name NewState, optional name NewLabel)
{
    NewState;
    NewLabel;
}

native(284) final function name GetStateName()
{
}

native final function bool IsChildState(name TestState, name TestParentState)
{
    TestState;
    TestParentState;
}

native(281) final function bool IsInState(name TestState, optional bool bTestStateStack)
{
    TestState;
    bTestStateStack;
}

native(113) final function GotoState(optional name NewState, optional name Label, optional bool bForceEvents, optional bool bKeepStack)
{
    NewState;
    Label;
    bForceEvents;
    bKeepStack;
}

native static final function bool IsUTracing()
{
}

native static final function SetUTracing(bool bShouldUTrace)
{
    bShouldUTrace;
}

native static final function name GetFuncName()
{
}

native static final function DebugBreak(optional int UserFlags, optional EDebugBreakType DebuggerType = 0)
{
    UserFlags;
    DebuggerType;
}

native static final function ScriptTrace()
{
}

static final function string ParseLocalizedPropertyPath(string PathName)
{
    local array<string> Pieces;
    
    ParseStringIntoArray(PathName, Pieces, ".", false);
    if (Pieces.Length >= 3)
    {
        return Localize(Pieces[1], Pieces[2], Pieces[0]);
    }
    else
    {
        return "";
    }
}

native static function string Localize(string SectionName, string KeyName, string PackageName)
{
    SectionName;
    KeyName;
    PackageName;
}

native(232) static final function WarnInternal(coerce string S)
{
    S;
}

native(231) static final function LogInternal(coerce string S, optional name Tag)
{
    S;
    Tag;
}

static final operator(20) LinearColor -(LinearColor A, LinearColor B)
{
    A.R -= B.R;
    A.G -= B.G;
    A.B -= B.B;
    return A;
}

static final operator(16) LinearColor *(LinearColor LC, float Mult)
{
    LC.R *= Mult;
    LC.G *= Mult;
    LC.B *= Mult;
    return LC;
}

static final function LinearColor ColorToLinearColor(Color OldColor)
{
    return MakeLinearColor(float(OldColor.R) / 255.0, float(OldColor.G) / 255.0, float(OldColor.B) / 255.0, float(OldColor.A) / 255.0);
}

static final function LinearColor MakeLinearColor(float R, float G, float B, float A)
{
    local LinearColor LC;
    
    LC.R = R;
    LC.G = G;
    LC.B = B;
    LC.A = A;
    return LC;
}

static final function Color LerpColor(Color A, Color B, float Alpha)
{
    local Vector FloatA, FloatB, FloatResult;
    local float AlphaA, AlphaB, FloatResultAlpha;
    local Color Result;
    
    FloatA.X = float(A.R);
    FloatA.Y = float(A.G);
    FloatA.Z = float(A.B);
    AlphaA = float(A.A);
    FloatB.X = float(B.R);
    FloatB.Y = float(B.G);
    FloatB.Z = float(B.B);
    AlphaB = float(B.A);
    FloatResult = FloatA + (FloatB - FloatA) * FClamp(Alpha, 0.0, 1.0);
    FloatResultAlpha = AlphaA + (AlphaB - AlphaA) * FClamp(Alpha, 0.0, 1.0);
    Result.R = byte(FloatResult.X);
    Result.G = byte(FloatResult.Y);
    Result.B = byte(FloatResult.Z);
    Result.A = byte(FloatResultAlpha);
    return Result;
}

static final function Color MakeColor(byte R, byte G, byte B, optional byte A)
{
    local Color C;
    
    C.R = R;
    C.G = G;
    C.B = B;
    C.A = A;
    return C;
}

static final operator(20) Color +(Color A, Color B)
{
    A.R += B.R;
    A.G += B.G;
    A.B += B.B;
    return A;
}

static final operator(16) Color *(Color A, float B)
{
    A.R *= B;
    A.G *= B;
    A.B *= B;
    return A;
}

static final operator(16) Color *(float A, Color B)
{
    B.R *= A;
    B.G *= A;
    B.B *= A;
    return B;
}

static final operator(20) Color -(Color A, Color B)
{
    A.R -= B.R;
    A.G -= B.G;
    A.B -= B.B;
    return A;
}

native final function Vector2D EvalInterpCurveVector2D(InterpCurveVector2D Vector2DCurve, float InVal)
{
    Vector2DCurve;
    InVal;
}

native final function Vector EvalInterpCurveVector(InterpCurveVector VectorCurve, float InVal)
{
    VectorCurve;
    InVal;
}

native final function float EvalInterpCurveFloat(InterpCurveFloat FloatCurve, float InVal)
{
    FloatCurve;
    InVal;
}

static final function Vector2D vect2d(float InX, float InY)
{
    local Vector2D NewVect2d;
    
    NewVect2d.X = InX;
    NewVect2d.Y = InY;
    return NewVect2d;
}

native static final simulated function float GetMappedRangeValue(Vector2D InputRange, Vector2D OutputRange, float Value)
{
    InputRange;
    OutputRange;
    Value;
}

static final simulated function float GetRangePctByValue(Vector2D Range, float Value)
{
    return Range.Y == Range.X ? Range.X : (Value - Range.X) / (Range.Y - Range.X);
}

static final simulated function float GetRangeValueByPct(Vector2D Range, float Pct)
{
    return Range.X + (Range.Y - Range.X) * Pct;
}

native static final operator(16) Vector2D -(Vector2D A, Vector2D B)
{
    A;
    B;
}

native static final operator(16) Vector2D +(Vector2D A, Vector2D B)
{
    A;
    B;
}

native(271) static final operator(16) Quat -(Quat A, Quat B)
{
    A;
    B;
}

native(270) static final operator(16) Quat +(Quat A, Quat B)
{
    A;
    B;
}

native static final function Quat QuatSlerp(Quat A, Quat B, float Alpha, optional bool bShortestPath)
{
    A;
    B;
    Alpha;
    bShortestPath;
}

native static final function Rotator QuatToRotator(Quat A)
{
    A;
}

native static final function Quat QuatFromRotator(Rotator A)
{
    A;
}

native static final function Quat QuatFromAxisAndAngle(Vector Axis, float Angle)
{
    Axis;
    Angle;
}

native static final function Quat QuatFindBetween(Vector A, Vector B)
{
    A;
    B;
}

native static final function Vector QuatRotateVector(Quat A, Vector B)
{
    A;
    B;
}

native static final function Quat QuatInvert(Quat A)
{
    A;
}

native static final function float QuatDot(Quat A, Quat B)
{
    A;
    B;
}

native static final function Quat QuatProduct(Quat A, Quat B)
{
    A;
    B;
}

native static final function Vector MatrixGetAxis(Matrix TM, EAxis Axis)
{
    TM;
    Axis;
}

native static final function Vector MatrixGetOrigin(Matrix TM)
{
    TM;
}

native static final function Rotator MatrixGetRotator(Matrix TM)
{
    TM;
}

native static final function Matrix MakeRotationMatrix(Rotator Rotation)
{
    Rotation;
}

native static final function Matrix MakeRotationTranslationMatrix(Vector Translation, Rotator Rotation)
{
    Translation;
    Rotation;
}

native static final function Vector InverseTransformNormal(Matrix TM, Vector A)
{
    TM;
    A;
}

native static final function Vector TransformNormal(Matrix TM, Vector A)
{
    TM;
    A;
}

native static final function Vector InverseTransformVector(Matrix TM, Vector A)
{
    TM;
    A;
}

native static final function Vector TransformVector(Matrix TM, Vector A)
{
    TM;
    A;
}

native static final operator(34) Matrix *(Matrix A, Matrix B)
{
    A;
    B;
}

native(255) static final operator(26) bool !=(name A, name B)
{
    A;
    B;
}

native(254) static final operator(24) bool ==(name A, name B)
{
    A;
    B;
}

native(197) final function bool IsA(name ClassName)
{
    ClassName;
}

native(258) static final function bool ClassIsChildOf(class<Object> TestClass, class<Object> ParentClass)
{
    TestClass;
    ParentClass;
}

native static final operator(26) bool !=(Interface A, Interface B)
{
    A;
    B;
}

native static final operator(24) bool ==(Interface A, Interface B)
{
    A;
    B;
}

native(119) static final operator(26) bool !=(Object A, Object B)
{
    A;
    B;
}

native(114) static final operator(24) bool ==(Object A, Object B)
{
    A;
    B;
}

native static final function string PathName(Object CheckObject)
{
    CheckObject;
}

static final function array<string> SplitString(string Source, optional string Delimiter = ",", optional bool bCullEmpty)
{
    local array<string> Result;
    
    ParseStringIntoArray(Source, Result, Delimiter, bCullEmpty);
    return Result;
}

native static final function ParseStringIntoArray(string BaseString, out array<string> Pieces, string delim, bool bCullEmpty)
{
    BaseString;
    Pieces;
    delim;
    bCullEmpty;
}

static final function JoinArray(array<string> StringArray, out string out_Result, optional string delim = ",", optional bool bIgnoreBlanks = true)
{
    local int I;
    
    out_Result = "";
    for (I = 0; I < StringArray.Length; I++)
    {
        if (StringArray[I] != "" || !bIgnoreBlanks)
        {
            if (out_Result != "" || !bIgnoreBlanks && I > 0)
            {
                out_Result $= delim;
            }
            out_Result $= StringArray[I];
        }
    }
}

static final function string GetRightMost(coerce string Text)
{
    local int Idx;
    
    Idx = InStr(Text, "_");
    while (Idx != -1)
    {
        Text = Mid(Text, Idx + 1, Len(Text));
        Idx = InStr(Text, "_");
    }
    return Text;
}

static final function string Split(coerce string Text, coerce string SplitStr, optional bool bOmitSplitStr)
{
    local int pos;
    
    pos = InStr(Text, SplitStr);
    if (pos != -1)
    {
        if (bOmitSplitStr)
        {
            return Mid(Text, pos + Len(SplitStr));
        }
        return Mid(Text, pos);
    }
    else
    {
        return Text;
    }
}

native(201) static final function string Repl(coerce string Src, coerce string Match, coerce string With, optional bool bCaseSensitive)
{
    Src;
    Match;
    With;
    bCaseSensitive;
}

native(237) static final function int Asc(string S)
{
    S;
}

native(236) static final function string Chr(int I)
{
    I;
}

native(238) static final function string Locs(coerce string S)
{
    S;
}

native(235) static final function string Caps(coerce string S)
{
    S;
}

native(234) static final function string Right(coerce string S, int I)
{
    S;
    I;
}

native(128) static final function string Left(coerce string S, int I)
{
    S;
    I;
}

native(127) static final function string Mid(coerce string S, int I, optional int J)
{
    S;
    I;
    J;
}

native(126) static final function int InStr(coerce string S, coerce string T, optional bool bSearchFromRight, optional bool bIgnoreCase, optional int StartPos)
{
    S;
    T;
    bSearchFromRight;
    bIgnoreCase;
    StartPos;
}

native(125) static final function int Len(coerce string S)
{
    S;
}

native(324) static final operator(45) string -=(out string A, coerce string B)
{
    A;
    B;
}

native(323) static final operator(44) string @=(out string A, coerce string B)
{
    A;
    B;
}

native(322) static final operator(44) string $=(out string A, coerce string B)
{
    A;
    B;
}

native(124) static final operator(24) bool ~=(string A, string B)
{
    A;
    B;
}

native(123) static final operator(26) bool !=(string A, string B)
{
    A;
    B;
}

native(122) static final operator(24) bool ==(string A, string B)
{
    A;
    B;
}

native(121) static final operator(24) bool >=(string A, string B)
{
    A;
    B;
}

native(120) static final operator(24) bool <=(string A, string B)
{
    A;
    B;
}

native(116) static final operator(24) bool >(string A, string B)
{
    A;
    B;
}

native(115) static final operator(24) bool <(string A, string B)
{
    A;
    B;
}

native(168) static final operator(40) string @(coerce string A, coerce string B)
{
    A;
    B;
}

native(112) static final operator(40) string $(coerce string A, coerce string B)
{
    A;
    B;
}

static final function Rotator MakeRotator(int Pitch, int Yaw, int Roll)
{
    local Rotator R;
    
    R.Pitch = Pitch;
    R.Yaw = Yaw;
    R.Roll = Roll;
    return R;
}

static final simulated function bool SClampRotAxis(float DeltaTime, int ViewAxis, out int out_DeltaViewAxis, int MaxLimit, int MinLimit, float InterpolationSpeed)
{
    local bool bClamped;
    
    out_DeltaViewAxis = NormalizeRotAxis(out_DeltaViewAxis);
    ViewAxis = NormalizeRotAxis(ViewAxis);
    if (ViewAxis <= MaxLimit && ViewAxis + out_DeltaViewAxis >= MaxLimit)
    {
        out_DeltaViewAxis = MaxLimit - ViewAxis;
        bClamped = true;
    }
    else if (ViewAxis > MaxLimit)
    {
        if (out_DeltaViewAxis > 0)
        {
            out_DeltaViewAxis = 0;
        }
        if (ViewAxis + out_DeltaViewAxis > MaxLimit)
        {
            out_DeltaViewAxis = int(FInterpTo(float(ViewAxis), float(MaxLimit), DeltaTime, InterpolationSpeed) - float(ViewAxis) - float(1));
        }
    }
    else if (ViewAxis >= MinLimit && ViewAxis + out_DeltaViewAxis <= MinLimit)
    {
        out_DeltaViewAxis = MinLimit - ViewAxis;
        bClamped = true;
    }
    else if (ViewAxis < MinLimit)
    {
        if (out_DeltaViewAxis < 0)
        {
            out_DeltaViewAxis = 0;
        }
        if (ViewAxis + out_DeltaViewAxis < MinLimit)
        {
            out_DeltaViewAxis += int(FInterpTo(float(ViewAxis), float(MinLimit), DeltaTime, InterpolationSpeed) - float(ViewAxis) + float(1));
        }
    }
    return bClamped;
}

static final simulated function int ClampRotAxisFromRange(int Current, int Min, int Max)
{
    local int Delta, Center;
    
    Delta = NormalizeRotAxis(Max - Min) / 2;
    Center = NormalizeRotAxis(Max + Min) / 2;
    return ClampRotAxisFromBase(Current, Center, Delta);
}

static final simulated function int ClampRotAxisFromBase(int Current, int Center, int MaxDelta)
{
    local int DeltaFromCenter;
    
    DeltaFromCenter = NormalizeRotAxis(Current - Center);
    if (DeltaFromCenter > MaxDelta)
    {
        Current = Center + MaxDelta;
    }
    else if (DeltaFromCenter < -MaxDelta)
    {
        Current = Center - MaxDelta;
    }
    return Current;
}

static final simulated function ClampRotAxis(int ViewAxis, out int out_DeltaViewAxis, int MaxLimit, int MinLimit)
{
    local int DesiredViewAxis;
    
    ViewAxis = NormalizeRotAxis(ViewAxis);
    DesiredViewAxis = ViewAxis + out_DeltaViewAxis;
    if (DesiredViewAxis > MaxLimit)
    {
        DesiredViewAxis = MaxLimit;
    }
    if (DesiredViewAxis < MinLimit)
    {
        DesiredViewAxis = MinLimit;
    }
    out_DeltaViewAxis = DesiredViewAxis - ViewAxis;
}

static final function float RSize(Rotator R)
{
    local int PitchNorm, YawNorm, RollNorm;
    
    PitchNorm = NormalizeRotAxis(R.Pitch);
    YawNorm = NormalizeRotAxis(R.Yaw);
    RollNorm = NormalizeRotAxis(R.Roll);
    return Sqrt(float(PitchNorm * PitchNorm + YawNorm * YawNorm + RollNorm * RollNorm));
}

native static final function float RDiff(Rotator A, Rotator B)
{
    A;
    B;
}

native static final function int NormalizeRotAxis(int Angle)
{
    Angle;
}

native static final function Rotator RInterpTo(Rotator Current, Rotator Target, float DeltaTime, float InterpSpeed, optional bool bConstantInterpSpeed)
{
    Current;
    Target;
    DeltaTime;
    InterpSpeed;
    bConstantInterpSpeed;
}

native static final function Rotator RTransform(Rotator R, Rotator RBasis)
{
    R;
    RBasis;
}

native static final function Rotator RSmerp(Rotator A, Rotator B, float Alpha, optional bool bShortestPath)
{
    A;
    B;
    Alpha;
    bShortestPath;
}

native static final function Rotator RLerp(Rotator A, Rotator B, float Alpha, optional bool bShortestPath)
{
    A;
    B;
    Alpha;
    bShortestPath;
}

native static final function Rotator Normalize(Rotator Rot)
{
    Rot;
}

native static final function Rotator OrthoRotation(Vector X, Vector Y, Vector Z)
{
    X;
    Y;
    Z;
}

native(320) static final function Rotator RotRand(optional bool bRoll)
{
    bRoll;
}

native(230) static final function GetUnAxes(Rotator A, out Vector X, out Vector Y, out Vector Z)
{
    A;
    X;
    Y;
    Z;
}

native(229) static final function GetAxes(Rotator A, out Vector X, out Vector Y, out Vector Z)
{
    A;
    X;
    Y;
    Z;
}

native static final operator(24) bool ClockwiseFrom(int A, int B)
{
    A;
    B;
}

native(319) static final operator(34) Rotator -=(out Rotator A, Rotator B)
{
    A;
    B;
}

native(318) static final operator(34) Rotator +=(out Rotator A, Rotator B)
{
    A;
    B;
}

native(317) static final operator(20) Rotator -(Rotator A, Rotator B)
{
    A;
    B;
}

native(316) static final operator(20) Rotator +(Rotator A, Rotator B)
{
    A;
    B;
}

native(291) static final operator(34) Rotator /=(out Rotator A, float B)
{
    A;
    B;
}

native(290) static final operator(34) Rotator *=(out Rotator A, float B)
{
    A;
    B;
}

native(289) static final operator(16) Rotator /(Rotator A, float B)
{
    A;
    B;
}

native(288) static final operator(16) Rotator *(float A, Rotator B)
{
    A;
    B;
}

native(287) static final operator(16) Rotator *(Rotator A, float B)
{
    A;
    B;
}

native(203) static final operator(26) bool !=(Rotator A, Rotator B)
{
    A;
    B;
}

native(142) static final operator(24) bool ==(Rotator A, Rotator B)
{
    A;
    B;
}

final simulated function bool InCylinder(Vector Origin, Rotator Dir, float Width, Vector A, optional bool bIgnoreZ)
{
    local Vector B, VDir;
    
    if (bIgnoreZ)
    {
        Origin.Z = 0.0;
        Dir.Pitch = 0;
        A.Z = 0.0;
    }
    VDir = vector(Dir);
    B = (A - Origin) Dot VDir * VDir + Origin;
    if (VSizeSq(B - A) <= Width * Width)
    {
        return true;
    }
    return false;
}

final simulated function float NoZDot(Vector A, Vector B)
{
    A.Z = B.Z;
    A = Normal(A);
    B = Normal(B);
    return A Dot B;
}

native static final function Vector ClampLength(Vector V, float MaxLength)
{
    V;
    MaxLength;
}

native static final function Vector VInterpTo(Vector Current, Vector Target, float DeltaTime, float InterpSpeed)
{
    Current;
    Target;
    DeltaTime;
    InterpSpeed;
}

native(1501) static final function bool IsZero(Vector A)
{
    A;
}

native(1500) static final function Vector ProjectOnTo(Vector X, Vector Y)
{
    X;
    Y;
}

native(300) static final function Vector MirrorVectorByNormal(Vector InVect, Vector InNormal)
{
    InVect;
    InNormal;
}

native static final function Vector VRandCone2(Vector Dir, float HorizontalConeHalfAngleRadians, float VerticalConeHalfAngleRadians)
{
    Dir;
    HorizontalConeHalfAngleRadians;
    VerticalConeHalfAngleRadians;
}

native static final function Vector VRandCone(Vector Dir, float ConeHalfAngleRadians)
{
    Dir;
    ConeHalfAngleRadians;
}

native(252) static final function Vector VRand()
{
}

native static final function Vector VSmerp(Vector A, Vector B, float Alpha)
{
    A;
    B;
    Alpha;
}

native static final function Vector VLerp(Vector A, Vector B, float Alpha)
{
    A;
    B;
    Alpha;
}

native(226) static final function Vector Normal(Vector A)
{
    A;
}

native static final function float VSizeSq2D(Vector A)
{
    A;
}

native(228) static final function float VSizeSq(Vector A)
{
    A;
}

native static final function float VSize2D(Vector A)
{
    A;
}

native(225) static final function float VSize(Vector A)
{
    A;
}

native(224) static final operator(34) Vector -=(out Vector A, Vector B)
{
    A;
    B;
}

native(223) static final operator(34) Vector +=(out Vector A, Vector B)
{
    A;
    B;
}

native(222) static final operator(34) Vector /=(out Vector A, float B)
{
    A;
    B;
}

native(297) static final operator(34) Vector *=(out Vector A, Vector B)
{
    A;
    B;
}

native(221) static final operator(34) Vector *=(out Vector A, float B)
{
    A;
    B;
}

native(220) static final operator(16) Vector Cross(Vector A, Vector B)
{
    A;
    B;
}

native(219) static final operator(16) float Dot(Vector A, Vector B)
{
    A;
    B;
}

native(218) static final operator(26) bool !=(Vector A, Vector B)
{
    A;
    B;
}

native(217) static final operator(24) bool ==(Vector A, Vector B)
{
    A;
    B;
}

native(276) static final operator(22) Vector >>(Vector A, Rotator B)
{
    A;
    B;
}

native(275) static final operator(22) Vector <<(Vector A, Rotator B)
{
    A;
    B;
}

native(216) static final operator(20) Vector -(Vector A, Vector B)
{
    A;
    B;
}

native(215) static final operator(20) Vector +(Vector A, Vector B)
{
    A;
    B;
}

native(214) static final operator(16) Vector /(Vector A, float B)
{
    A;
    B;
}

native(296) static final operator(16) Vector *(Vector A, Vector B)
{
    A;
    B;
}

native(213) static final operator(16) Vector *(float A, Vector B)
{
    A;
    B;
}

native(212) static final operator(16) Vector *(Vector A, float B)
{
    A;
    B;
}

native(211) static final preoperator Vector -(Vector A)
{
    A;
}

native static final function float FInterpConstantTo(float Current, float Target, float DeltaTime, float InterpSpeed)
{
    Current;
    Target;
    DeltaTime;
    InterpSpeed;
}

native static final function float FInterpTo(float Current, float Target, float DeltaTime, float InterpSpeed)
{
    Current;
    Target;
    DeltaTime;
    InterpSpeed;
}

static final simulated function float FPctByRange(float Value, float InMin, float InMax)
{
    return (Value - InMin) / (InMax - InMin);
}

static final simulated function float RandRange(float InMin, float InMax)
{
    return InMin + (InMax - InMin) * FRand();
}

native static final function float FInterpEaseInOut(float A, float B, float Alpha, float Exp)
{
    A;
    B;
    Alpha;
    Exp;
}

static final function float FInterpEaseOut(float A, float B, float Alpha, float Exp)
{
    return Lerp(A, B, Alpha ** (float(1) / Exp));
}

static final function float FInterpEaseIn(float A, float B, float Alpha, float Exp)
{
    return Lerp(A, B, Alpha ** Exp);
}

native static final function float FCubicInterp(float P0, float T0, float P1, float T1, float A)
{
    P0;
    T0;
    P1;
    T1;
    A;
}

native static final function int FCeil(float A)
{
    A;
}

native static final function int FFloor(float A)
{
    A;
}

native(199) static final function int Round(float A)
{
    A;
}

native(247) static final function float Lerp(float A, float B, float Alpha)
{
    A;
    B;
    Alpha;
}

native(246) static final function float FClamp(float V, float A, float B)
{
    V;
    A;
    B;
}

native(245) static final function float FMax(float A, float B)
{
    A;
    B;
}

native(244) static final function float FMin(float A, float B)
{
    A;
    B;
}

native(195) static final function float FRand()
{
}

native(194) static final function float Square(float A)
{
    A;
}

native(193) static final function float Sqrt(float A)
{
    A;
}

native(192) static final function float Loge(float A)
{
    A;
}

native(191) static final function float Exp(float A)
{
    A;
}

native static final function float Atan2(float A, float B)
{
    A;
    B;
}

native(190) static final function float Atan(float A)
{
    A;
}

native(189) static final function float Tan(float A)
{
    A;
}

native static final function float Acos(float A)
{
    A;
}

native(188) static final function float Cos(float A)
{
    A;
}

native static final function float Asin(float A)
{
    A;
}

native(187) static final function float Sin(float A)
{
    A;
}

native(186) static final function float Abs(float A)
{
    A;
}

native(185) static final operator(34) float -=(out float A, float B)
{
    A;
    B;
}

native(184) static final operator(34) float +=(out float A, float B)
{
    A;
    B;
}

native(183) static final operator(34) float /=(out float A, float B)
{
    A;
    B;
}

native(182) static final operator(34) float *=(out float A, float B)
{
    A;
    B;
}

native(181) static final operator(26) bool !=(float A, float B)
{
    A;
    B;
}

native(210) static final operator(24) bool ~=(float A, float B)
{
    A;
    B;
}

native(180) static final operator(24) bool ==(float A, float B)
{
    A;
    B;
}

native(179) static final operator(24) bool >=(float A, float B)
{
    A;
    B;
}

native(178) static final operator(24) bool <=(float A, float B)
{
    A;
    B;
}

native(177) static final operator(24) bool >(float A, float B)
{
    A;
    B;
}

native(176) static final operator(24) bool <(float A, float B)
{
    A;
    B;
}

native(175) static final operator(20) float -(float A, float B)
{
    A;
    B;
}

native(174) static final operator(20) float +(float A, float B)
{
    A;
    B;
}

native(173) static final operator(18) float %(float A, float B)
{
    A;
    B;
}

native(172) static final operator(16) float /(float A, float B)
{
    A;
    B;
}

native(171) static final operator(16) float *(float A, float B)
{
    A;
    B;
}

native(170) static final operator(12) float **(float Base, float Exp)
{
    Base;
    Exp;
}

native(169) static final preoperator float -(float A)
{
    A;
}

native static final function string ToHex(int A)
{
    A;
}

native(251) static final function int Clamp(int V, int A, int B)
{
    V;
    A;
    B;
}

native(250) static final function int Max(int A, int B)
{
    A;
    B;
}

native(249) static final function int Min(int A, int B)
{
    A;
    B;
}

native(167) static final function int Rand(int Max)
{
    Max;
}

native(166) static final operator(0) int --(out int A)
{
    A;
}

native(165) static final operator(0) int ++(out int A)
{
    A;
}

native(164) static final preoperator int --(out int A)
{
    A;
}

native(163) static final preoperator int ++(out int A)
{
    A;
}

native(162) static final operator(34) int -=(out int A, int B)
{
    A;
    B;
}

native(161) static final operator(34) int +=(out int A, int B)
{
    A;
    B;
}

native(160) static final operator(34) int /=(out int A, float B)
{
    A;
    B;
}

native(159) static final operator(34) int *=(out int A, float B)
{
    A;
    B;
}

native(158) static final operator(28) int |(int A, int B)
{
    A;
    B;
}

native(157) static final operator(28) int ^(int A, int B)
{
    A;
    B;
}

native(156) static final operator(28) int &(int A, int B)
{
    A;
    B;
}

native(155) static final operator(26) bool !=(int A, int B)
{
    A;
    B;
}

native(154) static final operator(24) bool ==(int A, int B)
{
    A;
    B;
}

native(153) static final operator(24) bool >=(int A, int B)
{
    A;
    B;
}

native(152) static final operator(24) bool <=(int A, int B)
{
    A;
    B;
}

native(151) static final operator(24) bool >(int A, int B)
{
    A;
    B;
}

native(150) static final operator(24) bool <(int A, int B)
{
    A;
    B;
}

native(196) static final operator(22) int >>>(int A, int B)
{
    A;
    B;
}

native(149) static final operator(22) int >>(int A, int B)
{
    A;
    B;
}

native(148) static final operator(22) int <<(int A, int B)
{
    A;
    B;
}

native(147) static final operator(20) int -(int A, int B)
{
    A;
    B;
}

native(146) static final operator(20) int +(int A, int B)
{
    A;
    B;
}

native(253) static final operator(18) int %(int A, int B)
{
    A;
    B;
}

native(145) static final operator(16) int /(int A, int B)
{
    A;
    B;
}

native(144) static final operator(16) int *(int A, int B)
{
    A;
    B;
}

native(143) static final preoperator int -(int A)
{
    A;
}

native(141) static final preoperator int ~(int A)
{
    A;
}

native(140) static final operator(0) byte --(out byte A)
{
    A;
}

native(139) static final operator(0) byte ++(out byte A)
{
    A;
}

native(138) static final preoperator byte --(out byte A)
{
    A;
}

native(137) static final preoperator byte ++(out byte A)
{
    A;
}

native(136) static final operator(34) byte -=(out byte A, byte B)
{
    A;
    B;
}

native(135) static final operator(34) byte +=(out byte A, byte B)
{
    A;
    B;
}

native(134) static final operator(34) byte /=(out byte A, byte B)
{
    A;
    B;
}

native(198) static final operator(34) byte *=(out byte A, float B)
{
    A;
    B;
}

native(133) static final operator(34) byte *=(out byte A, byte B)
{
    A;
    B;
}

native(132) static final operator(32) bool ||(bool A, skip bool B)
{
    A;
    B;
}

native(131) static final operator(30) bool ^^(bool A, bool B)
{
    A;
    B;
}

native(130) static final operator(30) bool &&(bool A, skip bool B)
{
    A;
    B;
}

native(243) static final operator(26) bool !=(bool A, bool B)
{
    A;
    B;
}

native(242) static final operator(24) bool ==(bool A, bool B)
{
    A;
    B;
}

native(129) static final preoperator bool !(bool A)
{
    A;
}

defaultproperties
{
}
