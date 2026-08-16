class AliceGameEmitterPool extends EmitterPool
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

var array<AttachedExplosionLight> RelativeExplosionLights;
var export editinline array<AliceExplosionLight> PoolExplosionLights;
var export editinline array<AliceExplosionLight> ActiveExplosionLights;

function AliceExplosionLight SpawnTemplateExplosionLight(AliceExplosionLightTemplate Template, Vector SpawnLocation, optional Actor AttachToActor)
{
    local AliceExplosionLight Light;
    local int I;
    
    if (AttachToActor != none && AttachToActor.bStatic || !AttachToActor.bMovable)
    {
        AttachToActor = none;
    }
    Light = new(self) class'AliceExplosionLight';
    Light.SetTemplate(Template);
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

defaultproperties
{
    PSCTemplate="Default__AliceGameEmitterPool.ParticleSystemComponent0"
    MaxActiveEffects=200
    SMC_MIC_ReductionTime=2.0
    IdealStaticMeshComponents=200
    IdealMaterialInstanceConstants=200
}
