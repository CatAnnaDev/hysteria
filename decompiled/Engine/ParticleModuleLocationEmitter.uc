class ParticleModuleLocationEmitter extends ParticleModuleLocationBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum ELocationEmitterSelectionMethod
{
    ELESM_Random,
    ELESM_Sequential,
};

var(Location) export noclear name EmitterName;
var(Location) ELocationEmitterSelectionMethod SelectionMethod;
var(Location) bool InheritSourceVelocity;
var(Location) bool bInheritSourceRotation;
var(Location) float InheritSourceVelocityScale;
var(Location) float InheritSourceRotationScale;

defaultproperties
{
    InheritSourceVelocityScale=1.0
    InheritSourceRotationScale=1.0
    bSpawnModule=True
}
