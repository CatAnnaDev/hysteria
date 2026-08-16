class ApexStaticDestructibleComponent extends ApexStaticComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var(Physics) float SleepEnergyThreshold;
var(Physics) float SleepDamping;
var native Pointer ApexDestructibleActor;
var native Pointer ApexDestructiblePreview;
var native bool bIsThumbnailComponent;

defaultproperties
{
    SleepEnergyThreshold=1250.0
    SleepDamping=0.2
    ReplacementPrimitive="None"
    bUsePrecomputedShadows=False
}
