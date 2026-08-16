class ParticleModuleTypeDataTrail extends ParticleModuleTypeDataBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Trail) bool RenderGeometry;
var(Trail) bool RenderLines;
var(Trail) bool RenderTessellation;
var(Trail) bool Tapered;
var(Trail) bool SpawnByDistance;
var(Trail) int TessellationFactor;
var(Trail) RawDistributionFloat Tension;
var(Trail) Vector SpawnDistance;

defaultproperties
{
    RenderGeometry=True
    TessellationFactor=1
    Tension=(Distribution="Default__ParticleModuleTypeDataTrail.DistributionTension",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    SpawnDistance=(X=5.0,Y=5.0,Z=5.0)
}
