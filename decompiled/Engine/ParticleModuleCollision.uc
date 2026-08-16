class ParticleModuleCollision extends ParticleModuleCollisionBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

var(Collision) RawDistributionVector DampingFactor;
var(Collision) RawDistributionVector DampingFactorRotation;
var(Collision) RawDistributionFloat MaxCollisions;
var(Collision) EParticleCollisionComplete CollisionCompletionOption;
var(Collision) bool bApplyPhysics;
var(Collision) bool bPawnsDoNotDecrementCount;
var(Collision) bool bOnlyVerticalNormalsDecrementCount;
var(Performance) bool bDropDetail;
var(Collision) RawDistributionFloat ParticleMass;
var(Collision) float DirScalar;
var(Collision) float VerticalFudgeFactor;
var(Collision) RawDistributionFloat DelayAmount;

defaultproperties
{
    DampingFactor=(Distribution="Default__ParticleModuleCollision.DistributionDampingFactor",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    DampingFactorRotation=(Distribution="Default__ParticleModuleCollision.DistributionDampingFactorRotation",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    MaxCollisions=(Distribution="Default__ParticleModuleCollision.DistributionMaxCollisions",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bPawnsDoNotDecrementCount=True
    bDropDetail=True
    ParticleMass=(Distribution="Default__ParticleModuleCollision.DistributionParticleMass",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] cdcccc3dcdcccc3dcdcccc3dcdcccc3d,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    DirScalar=3.5
    VerticalFudgeFactor=0.1
    DelayAmount=(Distribution="Default__ParticleModuleCollision.DistributionDelayAmount",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    bSpawnModule=True
    bUpdateModule=True
    LODDuplicate=False
}
