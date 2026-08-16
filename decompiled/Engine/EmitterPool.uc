class EmitterPool extends Actor
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

struct native EmitterBaseInfo
{
    var export editinline ParticleSystemComponent PSC;
    var Actor Base;
    var Vector RelativeLocation;
    var Rotator RelativeRotation;
    var bool bInheritBaseScale;
};

var export editinline ParticleSystemComponent PSCTemplate;
var const export editinline array<ParticleSystemComponent> PoolComponents;
var export editinline array<ParticleSystemComponent> ActiveComponents;
var int MaxActiveEffects;
var globalconfig bool bLogPoolOverflow;
var globalconfig bool bLogPoolOverflowList;
var array<EmitterBaseInfo> RelativePSCs;
var float SMC_MIC_ReductionTime;
var transient float SMC_MIC_CurrentReductionTime;
var int IdealStaticMeshComponents;
var int IdealMaterialInstanceConstants;
var const export editinline array<StaticMeshComponent> FreeSMComponents;
var const array<MaterialInstanceConstant> FreeMatInstConsts;

function ParticleSystemComponent SpawnEmitterCustomLifetime(ParticleSystem EmitterTemplate)
{
    return GetPooledComponent(EmitterTemplate);
}

function ParticleSystemComponent SpawnEmitterMeshAttachment(ParticleSystem EmitterTemplate, SkeletalMeshComponent Mesh, name AttachPointName, optional bool bAttachToSocket, optional Vector RelativeLoc, optional Rotator RelativeRot)
{
    local ParticleSystemComponent Result;
    
    Result = GetPooledComponent(EmitterTemplate);
    Result.SetAbsolute(false, false);
    Result.__OnSystemFinished__Delegate = OnParticleSystemFinished;
    if (bAttachToSocket)
    {
        Mesh.AttachComponentToSocket(Result, AttachPointName);
    }
    else
    {
        Mesh.AttachComponent(Result, AttachPointName, RelativeLoc, RelativeRot);
    }
    return Result;
}

function ParticleSystemComponent SpawnEmitter(ParticleSystem EmitterTemplate, Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor AttachToActor, optional bool bInheritScaleFromBase)
{
    local int I;
    local ParticleSystemComponent Result;
    
    if (EmitterTemplate != none)
    {
        if (AttachToActor != none && AttachToActor.bStatic || !AttachToActor.bMovable)
        {
            AttachToActor = none;
        }
        Result = GetPooledComponent(EmitterTemplate);
        if (AttachToActor != none)
        {
            I = RelativePSCs.Length;
            RelativePSCs.Length = I + 1;
            RelativePSCs[I].PSC = Result;
            RelativePSCs[I].Base = AttachToActor;
            RelativePSCs[I].RelativeLocation = SpawnLocation - AttachToActor.Location;
            RelativePSCs[I].RelativeRotation = SpawnRotation - AttachToActor.Rotation;
            RelativePSCs[I].bInheritBaseScale = bInheritScaleFromBase;
            if (bInheritScaleFromBase)
            {
                RelativePSCs[I].PSC.SetScale(0.0);
            }
        }
        Result.SetTranslation(SpawnLocation);
        Result.SetRotation(SpawnRotation);
        AttachComponent(Result);
        Result.__OnSystemFinished__Delegate = OnParticleSystemFinished;
        return Result;
    }
    else
    {
        WarnInternal("No EmitterTemplate!");
        ScriptTrace();
        return none;
    }
}

native protected final function ParticleSystemComponent GetPooledComponent(ParticleSystem EmitterTemplate)
{
    EmitterTemplate;
}

native protected final function MaterialInstanceConstant GetFreeMatInstConsts(optional bool bCreateNewObject = true)
{
    bCreateNewObject;
}

native protected final function FreeMaterialInstanceConstants(StaticMeshComponent SMC)
{
    SMC;
}

native protected final function StaticMeshComponent GetFreeStaticMeshComponent(optional bool bCreateNewObject = true)
{
    bCreateNewObject;
}

native protected final function FreeStaticMeshComponents(ParticleSystemComponent PSC)
{
    PSC;
}

native protected final function ReturnToPool(ParticleSystemComponent PSC)
{
    PSC;
}

native final function ClearPoolComponents()
{
}

function OnParticleSystemFinished(ParticleSystemComponent PSC)
{
    local int I;
    
    I = ActiveComponents.Find(PSC);
    if (I != -1)
    {
        ActiveComponents.Remove(I, 1);
        I = RelativePSCs.Find('PSC', PSC);
        if (I != -1)
        {
            RelativePSCs.Remove(I, 1);
        }
        ReturnToPool(PSC);
    }
}

defaultproperties
{
    PSCTemplate="Default__EmitterPool.ParticleSystemComponent0"
    SMC_MIC_ReductionTime=2.5
    IdealStaticMeshComponents=250
    IdealMaterialInstanceConstants=250
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
}
