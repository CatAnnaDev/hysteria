class AnimNodeAimOffset extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

enum EAimID
{
    EAID_LeftUp,
    EAID_LeftDown,
    EAID_RightUp,
    EAID_RightDown,
    EAID_ZeroUp,
    EAID_ZeroDown,
    EAID_ZeroLeft,
    EAID_ZeroRight,
    EAID_CellLU,
    EAID_CellCU,
    EAID_CellRU,
    EAID_CellLC,
    EAID_CellCC,
    EAID_CellRC,
    EAID_CellLD,
    EAID_CellCD,
    EAID_CellRD,
};

enum EAnimAimDir
{
    ANIMAIM_LEFTUP,
    ANIMAIM_CENTERUP,
    ANIMAIM_RIGHTUP,
    ANIMAIM_LEFTCENTER,
    ANIMAIM_CENTERCENTER,
    ANIMAIM_RIGHTCENTER,
    ANIMAIM_LEFTDOWN,
    ANIMAIM_CENTERDOWN,
    ANIMAIM_RIGHTDOWN,
};

struct native immutable AimOffsetProfile
{
    var() const editconst name ProfileName;
    var() Vector2D HorizontalRange;
    var() Vector2D VerticalRange;
    var array<AimComponent> AimComponents;
    var() name AnimName_LU;
    var() name AnimName_LC;
    var() name AnimName_LD;
    var() name AnimName_CU;
    var() name AnimName_CC;
    var() name AnimName_CD;
    var() name AnimName_RU;
    var() name AnimName_RC;
    var() name AnimName_RD;
};

struct native immutable AimComponent
{
    var() name BoneName;
    var() AimTransform LU;
    var() AimTransform LC;
    var() AimTransform LD;
    var() AimTransform CU;
    var() AimTransform CC;
    var() AimTransform CD;
    var() AimTransform RU;
    var() AimTransform RC;
    var() AimTransform RD;
};

struct native immutable AimTransform
{
    var() Quat Quaternion;
    var() Vector Translation;
};

var() Vector2D Aim;
var() Vector2D AngleOffset;
var() bool bForceAimDir;
var() bool bBakeFromAnimations;
var() bool bPassThroughWhenNotRendered;
var(Editor) bool bSynchronizeNodesInEditor;
var() int PassThroughAtOrAboveLOD;
var() EAnimAimDir ForcedAimDir;
var transient array<byte> RequiredBones;
var transient array<byte> AimCpntBoneIndex;
var transient array<byte> AimCpntIndexLUT;
var transient AnimNodeAimOffset TemplateNode;
var() editfixedsize array<AimOffsetProfile> Profiles;
var() const editconst int CurrentProfileIndex;

native function SetActiveProfileByIndex(int ProfileIndex)
{
    ProfileIndex;
}

native function SetActiveProfileByName(name ProfileName)
{
    ProfileName;
}

defaultproperties
{
    bSynchronizeNodesInEditor=True
    PassThroughAtOrAboveLOD=1000
    ForcedAimDir="ANIMAIM_CENTERCENTER"
    Children(0)=(Name="Input",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
    bSkipTickWhenZeroWeight=True
}
