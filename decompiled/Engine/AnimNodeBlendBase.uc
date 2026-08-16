class AnimNodeBlendBase extends AnimNode
    abstract
    native
    notplaceable
    hidecategories(Object,Object,Object);

struct native AnimBlendChild
{
    var() name Name;
    var export editinline AnimNode Anim;
    var float Weight;
    var const float TotalWeight;
    var const transient float BlendWeight;
    var const transient int bHasRootMotion;
    var const transient BoneAtom RootMotion;
    var bool bMirrorSkeleton;
    var bool bIsAdditive;
    var editoronly int DrawY;
};

var export editfixedsize editinline array<AnimBlendChild> Children;
var bool bFixNumChildren;
var transient bool bIsPrefetched;
var() AlphaBlendType BlendType;

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

defaultproperties
{
}
