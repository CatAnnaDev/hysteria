class ParticleModuleEventGenerator extends ParticleModuleEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

struct native ParticleEvent_GenerateInfo
{
    var() EParticleEventType Type;
    var() int Frequency;
    var() int LowFreq;
    var() int ParticleFrequency;
    var() bool FirstTimeOnly;
    var() bool LastTimeOnly;
    var() bool UseReflectedImpactVector;
    var() name CustomName;
    var() editinline array<ParticleModuleEventSendToGame> ParticleModuleEventsToSendToGame;
};

var(Events) export noclear array<ParticleEvent_GenerateInfo> Events;

defaultproperties
{
    bSpawnModule=True
    bUpdateModule=True
}
