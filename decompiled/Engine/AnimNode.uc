class AnimNode extends AnimObject
    abstract
    native
    notplaceable
    hidecategories(Object,Object);

enum ESliderType
{
    ST_1D,
    ST_2D,
};

struct CurveKey
{
    var name CurveName;
    var float Weight;
};

struct BoneTransform
{
};

var const transient bool bRelevant;
var const transient bool bJustBecameRelevant;
var() bool bSkipTickWhenZeroWeight;
var() bool bTickDuringPausedAnims;
var const transient int NodeTickTag;
var const transient int NodeCachedAtomsTag;
var const float NodeTotalWeight;
var const transient float TotalWeightAccumulator;
var transient array<AnimNodeBlendBase> ParentNodes;
var() name NodeName;
var transient array<BoneAtom> CachedBoneAtoms;
var transient byte CachedNumDesiredBones;
var transient BoneAtom CachedRootMotionDelta;
var transient int bCachedHasRootMotion;
var transient array<CurveKey> CachedCurveKeys;
var const transient int SearchTag;
var(Morph) transient editconst editoronly array<CurveKey> LastUpdatedAnimMorphKeys;

native function ReplayAnim()
{
}

native function StopAnim()
{
}

native function PlayAnim(optional bool bLoop = false, optional float Rate = 1.0, optional float StartTime = 0.0)
{
    bLoop;
    Rate;
    StartTime;
}

native final function AnimNode FindAnimNode(name InNodeName)
{
    InNodeName;
}

event OnCeaseRelevant()
{
}

event OnBecomeRelevant()
{
}

event OnInit()
{
}

defaultproperties
{
}
