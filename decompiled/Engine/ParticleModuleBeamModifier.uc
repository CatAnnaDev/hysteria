class ParticleModuleBeamModifier extends ParticleModuleBeamBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum BeamModifierType
{
    PEB2MT_Source,
    PEB2MT_Target,
};

struct native BeamModifierOptions
{
    var() bool bModify;
    var() bool bScale;
    var() bool bLock;
};

var(Modifier) BeamModifierType ModifierType;
var(Position) BeamModifierOptions PositionOptions;
var(Position) RawDistributionVector Position;
var(Tangent) BeamModifierOptions TangentOptions;
var(Tangent) RawDistributionVector Tangent;
var(Tangent) bool bAbsoluteTangent;
var(Strength) BeamModifierOptions StrengthOptions;
var(Strength) RawDistributionFloat Strength;

defaultproperties
{
    Position=(Distribution="Default__ParticleModuleBeamModifier.DistributionPosition",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Tangent=(Distribution="Default__ParticleModuleBeamModifier.DistributionTangent",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
    Strength=(Distribution="Default__ParticleModuleBeamModifier.DistributionStrength",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0)
}
