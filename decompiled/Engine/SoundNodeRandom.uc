class SoundNodeRandom extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var() editfixedsize array<float> Weights;
var() bool bRandomizeWithoutReplacement;
var transient array<bool> HasBeenUsed;
var transient int NumRandomUsed;

defaultproperties
{
    bRandomizeWithoutReplacement=True
}
