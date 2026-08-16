class SoundNodeLooping extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var(Looping) bool bLoopIndefinitely;
var(Looping) float LoopCountMin;
var(Looping) float LoopCountMax;
var deprecated RawDistributionFloat LoopCount;

defaultproperties
{
    bLoopIndefinitely=True
    LoopCountMin=1000000.0
    LoopCountMax=1000000.0
}
