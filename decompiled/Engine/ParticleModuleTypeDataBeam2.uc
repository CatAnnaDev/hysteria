class ParticleModuleTypeDataBeam2 extends ParticleModuleTypeDataBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum EBeamTaperMethod
{
    PEBTM_None,
    PEBTM_Full,
    PEBTM_Partial,
};

enum EBeam2Method
{
    PEB2M_Distance,
    PEB2M_Target,
    PEB2M_Branch,
};

struct BeamTargetData
{
    var() name TargetName;
    var() float TargetPercentage;
};

var(Beam) EBeam2Method BeamMethod;
var(Taper) EBeamTaperMethod TaperMethod;
var(Beam) int TextureTile;
var(Beam) float TextureTileDistance;
var(Beam) int Sheets;
var(Beam) int MaxBeamCount;
var(Beam) float Speed;
var(Beam) int InterpolationPoints;
var(Beam) bool bAlwaysOn;
var(Rendering) bool RenderGeometry;
var(Rendering) bool RenderDirectLine;
var(Rendering) bool RenderLines;
var(Rendering) bool RenderTessellation;
var(Beam) int UpVectorStepSize;
var(Branching) name BranchParentName;
var(Distance) RawDistributionFloat Distance;
var(Taper) RawDistributionFloat TaperFactor;
var(Taper) RawDistributionFloat TaperScale;

defaultproperties
{
    BeamMethod="PEB2M_Target"
    TextureTile=1
    Sheets=1
    Speed=10.0
    RenderGeometry=True
    Distance=(Distribution="Default__ParticleModuleTypeDataBeam2.DistributionDistance",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000c8410000c8410000c8410000c841,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    TaperFactor=(Distribution="Default__ParticleModuleTypeDataBeam2.DistributionTaperFactor",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    TaperScale=(Distribution="Default__ParticleModuleTypeDataBeam2.DistributionTaperScale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
}
