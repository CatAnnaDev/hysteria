class AliceGameAnimNode_BlendAnimsByDir extends AnimNodeSequenceBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object);

var() bool bAddRotationRate;
var() float BlendSpeed;
var float DirAngle;
var Vector MoveDir;
var transient int LastYaw;
var transient float YawRotationRate;
var transient AliceGamePawn PawnOwner;

defaultproperties
{
    BlendSpeed=10.0
    Anims(0)=(AnimName="Forward",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=1.0)
    Anims(1)=(AnimName="Backward",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(2)=(AnimName="Left",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(3)=(AnimName="Right",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
}
