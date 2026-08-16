class AliceEmitterPool extends EmitterPool
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

struct native AttachedExplosionLight
{
    var export editinline AliceExplosionLight Light;
    var Actor Base;
    var Vector RelativeLocation;
};

var array<AttachedExplosionLight> RelativeExplosionLights;

function AliceExplosionLight SpawnExplosionLight(class<AliceExplosionLight> LightClass, Vector SpawnLocation, optional Actor AttachToActor)
{
    local AliceExplosionLight Light;
    local int I;
    
    if (AttachToActor != none && AttachToActor.bStatic || !AttachToActor.bMovable)
    {
        AttachToActor = none;
    }
    Light = new(self) LightClass;
    Light.SetTranslation(SpawnLocation);
    Light.__OnLightFinished__Delegate = OnExplosionLightFinished;
    AttachComponent(Light);
    if (AttachToActor != none)
    {
        I = RelativeExplosionLights.Length;
        RelativeExplosionLights.Length = I + 1;
        RelativeExplosionLights[I].Light = Light;
        RelativeExplosionLights[I].Base = AttachToActor;
        RelativeExplosionLights[I].RelativeLocation = SpawnLocation - AttachToActor.Location;
    }
    return Light;
}

function OnExplosionLightFinished(AliceExplosionLight Light)
{
    local int I;
    
    DetachComponent(Light);
    I = RelativeExplosionLights.Find('Light', Light);
    if (I != -1)
    {
        RelativeExplosionLights.Remove(I, 1);
    }
}

function ParticleSystemComponent SpawnEmitter(ParticleSystem EmitterTemplate, Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor AttachToActor, optional bool bInheritScaleFromBase)
{
    local PlayerController PC;
    local int LODLevel;
    local ParticleSystemComponent PSC;
    
    if (EmitterTemplate == none)
    {
        return none;
    }
    PSC = SpawnEmitter(EmitterTemplate, SpawnLocation, SpawnRotation, AttachToActor, bInheritScaleFromBase);
    if (WorldInfo.bDropDetail)
    {
        LODLevel = 1;
    }
    else if (EmitterTemplate.LODDistances.Length > 1)
    {
        LODLevel = 1;
        foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            if (PC.ViewTarget != none && VSize(PC.ViewTarget.Location - SpawnLocation) * PC.LODDistanceFactor < EmitterTemplate.LODDistances[1] && vector(PC.Rotation) Dot (SpawnLocation - PC.ViewTarget.Location) >= 0.0)
            {
                LODLevel = 0;
                break;
            }
        }
    }
    PSC.SetLODLevel(LODLevel);
    PSC.SetDepthPriorityGroup(1);
    return PSC;
}

defaultproperties
{
    PSCTemplate="Default__AliceEmitterPool.ParticleSystemComponent0"
    MaxActiveEffects=200
    SMC_MIC_ReductionTime=2.0
    IdealStaticMeshComponents=200
    IdealMaterialInstanceConstants=200
}
