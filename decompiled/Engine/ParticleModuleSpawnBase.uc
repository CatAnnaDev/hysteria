class ParticleModuleSpawnBase extends ParticleModule
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var(Spawn) bool bProcessSpawnRate;
var(Burst) bool bProcessBurstList;

defaultproperties
{
    bProcessSpawnRate=True
    bProcessBurstList=True
}
