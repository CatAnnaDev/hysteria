class ParticleModuleBeamTarget extends ParticleModuleBeamBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Target) Beam2SourceTargetMethod TargetMethod;
var(Target) Beam2SourceTargetTangentMethod TargetTangentMethod;
var(Target) name TargetName;
var(Target) RawDistributionVector Target;
var(Target) bool bTargetAbsolute;
var(Target) bool bLockTarget;
var(Target) bool bLockTargetTangent;
var(Target) bool bLockTargetStength;
var(Target) RawDistributionVector TargetTangent;
var(Target) RawDistributionFloat TargetStrength;
var(Target) float LockRadius;

defaultproperties
{
    Target=(Distribution="Default__ParticleModuleBeamTarget.DistributionTarget",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000484200004842000048420000484200004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    TargetTangent=(Distribution="Default__ParticleModuleBeamTarget.DistributionTargetTangent",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 000000000000803f0000803f00000000000000000000803f0000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    TargetStrength=(Distribution="Default__ParticleModuleBeamTarget.DistributionTargetStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000c8410000c8410000c8410000c841,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    LockRadius=10.0
}
