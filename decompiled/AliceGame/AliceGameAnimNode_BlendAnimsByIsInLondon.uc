class AliceGameAnimNode_BlendAnimsByIsInLondon extends AnimNodeSequenceBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

var transient AlicePawn PawnOwner;
var bool bInLondon;

defaultproperties
{
    Anims(0)=(AnimName="London",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=1.0)
    Anims(1)=(AnimName="Wonderland",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
}
