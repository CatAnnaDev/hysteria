class AnimationCompressionAlgorithm_RemoveTrivialKeys extends AnimationCompressionAlgorithm
    native
    notplaceable
    hidecategories(Object);

var() float MaxPosDiff;
var() float MaxAngleDiff;

defaultproperties
{
    MaxPosDiff=0.0001
    MaxAngleDiff=0.0003
    Description="Remove Trivial Keys"
}
