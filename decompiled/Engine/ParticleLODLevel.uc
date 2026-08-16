class ParticleLODLevel extends Object
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var const int Level;
var bool bEnabled;
var bool ConvertedModules;
var export editinline ParticleModuleRequired RequiredModule;
var export editinline array<ParticleModule> Modules;
var export ParticleModule TypeDataModule;
var export ParticleModuleSpawn SpawnModule;
var export ParticleModuleEventGenerator EventGenerator;
var native array<ParticleModuleSpawnBase> SpawningModules;
var native array<ParticleModule> SpawnModules;
var native array<ParticleModule> UpdateModules;
var native array<ParticleModuleOrbit> OrbitModules;
var native array<ParticleModuleEventReceiverBase> EventReceiverModules;
var int PeakActiveParticles;

defaultproperties
{
    bEnabled=True
    ConvertedModules=True
}
