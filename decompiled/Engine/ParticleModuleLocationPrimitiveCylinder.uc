class ParticleModuleLocationPrimitiveCylinder extends ParticleModuleLocationPrimitiveBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object,Object);

enum CylinderHeightAxis
{
    PMLPC_HEIGHTAXIS_X,
    PMLPC_HEIGHTAXIS_Y,
    PMLPC_HEIGHTAXIS_Z,
};

var(Location) bool RadialVelocity;
var bool bFirstSpawn;
var(Location) RawDistributionFloat StartRadius;
var(Location) RawDistributionFloat StartHeight;
var(Location) CylinderHeightAxis HeightAxis;
var(Location) int DivisionNum;
var int OldDivisionNum;
var array<byte> DivisionArray;
var(Location) int DivisionRandomRange;

defaultproperties
{
    RadialVelocity=True
    bFirstSpawn=True
    StartRadius=(Distribution="Default__ParticleModuleLocationPrimitiveCylinder.DistributionStartRadius",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    StartHeight=(Distribution="Default__ParticleModuleLocationPrimitiveCylinder.DistributionStartHeight",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00004842000048420000484200004842,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    HeightAxis="PMLPC_HEIGHTAXIS_Z"
    VelocityScale=(Distribution="Default__ParticleModuleLocationPrimitiveCylinder.DistributionVelocityScale")
    StartLocation=(Distribution="Default__ParticleModuleLocationPrimitiveCylinder.DistributionStartLocation")
    bSupported3DDrawMode=True
}
