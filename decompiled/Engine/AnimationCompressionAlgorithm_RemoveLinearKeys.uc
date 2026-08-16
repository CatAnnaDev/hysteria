class AnimationCompressionAlgorithm_RemoveLinearKeys extends AnimationCompressionAlgorithm
    native
    notplaceable
    hidecategories(Object);

var() float MaxPosDiff;
var() float MaxAngleDiff;
var() float MaxEffectorDiff;
var() float MinEffectorDiff;
var() float ParentKeyScale;
var() bool bRetarget;

defaultproperties
{
    MaxPosDiff=0.1
    MaxAngleDiff=0.025
    MaxEffectorDiff=0.01
    MinEffectorDiff=0.02
    ParentKeyScale=2.0
    bRetarget=True
    Description="Remove Linear Keys"
    bNeedsSkeleton=True
}
