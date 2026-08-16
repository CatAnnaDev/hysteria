class AnimNodeSequenceBlendBase extends AnimNodeSequence
    abstract
    native
    notplaceable
    hidecategories(Object,Object,Object);

struct native AnimBlendInfo
{
    var() name AnimName;
    var AnimInfo AnimInfo;
    var transient float Weight;
};

struct native AnimInfo
{
    var const name AnimSeqName;
    var const transient AnimSequence AnimSeq;
    var const transient int AnimLinkupIndex;
};

var(Animations) export editfixedsize editinline array<AnimBlendInfo> Anims;

defaultproperties
{
    Anims(0)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=1.0)
    Anims(1)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
}
