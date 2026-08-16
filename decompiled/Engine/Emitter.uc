class Emitter extends Actor
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var bool bIsActive;
};

var() const export editconst editinline ParticleSystemComponent ParticleSystemComponent;
var() const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;
var bool bDestroyOnSystemFinish;
var() bool bPostUpdateTickGroup;
var bool bFirstTick;
var repnotify bool bCurrentlyActive;
var(StopMotion) float AdjustStopMotionSpeed;

replication
{
    if (bNoDelete)
        bCurrentlyActive;
}

simulated function HideSelf()
{
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    bCurrentlyActive = Record.bIsActive;
    if (bCurrentlyActive)
    {
        ParticleSystemComponent.ActivateSystem();
    }
    else
    {
        ParticleSystemComponent.DeactivateSystem();
    }
    ForceNetRelevant();
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bIsActive = bCurrentlyActive;
}

function bool ShouldSaveForCheckpoint()
{
    return bNoDelete && RemoteRole != 0;
}

simulated function OnSetParticleSysParam(SeqAct_SetParticleSysParam Action)
{
    local int Idx, ParamIdx;
    
    if (ParticleSystemComponent != none && Action.InstanceParameters.Length > 0)
    {
        for (Idx = 0; Idx < Action.InstanceParameters.Length; Idx++)
        {
            if (Action.InstanceParameters[Idx].ParamType != 0)
            {
                ParamIdx = ParticleSystemComponent.InstanceParameters.Find('Name', Action.InstanceParameters[Idx].Name);
                if (ParamIdx == -1)
                {
                    ParamIdx = ParticleSystemComponent.InstanceParameters.Length;
                    ParticleSystemComponent.InstanceParameters.Length = ParamIdx + 1;
                }
                ParticleSystemComponent.InstanceParameters[ParamIdx] = Action.InstanceParameters[Idx];
                if (Action.bOverrideScalar)
                {
                    ParticleSystemComponent.InstanceParameters[ParamIdx].Scalar = Action.ScalarValue;
                }
            }
        }
    }
}

simulated function SetActorParameter(name ParameterName, Actor Param)
{
    if (ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetActorParameter(ParameterName, Param);
    }
    else
    {
        LogInternal("Warning: Attempting to set a parameter on " $ string(self) $ " when the PSC does not exist");
    }
}

simulated function SetExtColorParameter(name ParameterName, byte Red, byte Green, byte Blue, byte Alpha)
{
    local Color C;
    
    if (ParticleSystemComponent != none)
    {
        C.R = Red;
        C.G = Green;
        C.B = Blue;
        C.A = Alpha;
        ParticleSystemComponent.SetColorParameter(ParameterName, C);
    }
    else
    {
        LogInternal("Warning: Attempting to set a parameter on " $ string(self) $ " when the PSC does not exist");
    }
}

simulated function SetColorParameter(name ParameterName, Color Param)
{
    if (ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetColorParameter(ParameterName, Param);
    }
    else
    {
        LogInternal("Warning: Attempting to set a parameter on " $ string(self) $ " when the PSC does not exist");
    }
}

simulated function SetVectorParameter(name ParameterName, Vector Param)
{
    if (ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetVectorParameter(ParameterName, Param);
    }
    else
    {
        LogInternal("Warning: Attempting to set a parameter on " $ string(self) $ " when the PSC does not exist");
    }
}

simulated function SetFloatParameter(name ParameterName, float Param)
{
    if (ParticleSystemComponent != none)
    {
        ParticleSystemComponent.SetFloatParameter(ParameterName, Param);
    }
    else
    {
        LogInternal("Warning: Attempting to set a parameter on " $ string(self) $ " when the PSC does not exist");
    }
}

simulated function ShutDown()
{
    ShutDown();
    bCurrentlyActive = false;
}

function OnParticleEventGenerator(SeqAct_ParticleEventGenerator Action)
{
}

function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        ParticleSystemComponent.ActivateSystem();
        bCurrentlyActive = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        ParticleSystemComponent.DeactivateSystem();
        bCurrentlyActive = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (ParticleSystemComponent.bSuppressSpawning || !bCurrentlyActive)
        {
            ParticleSystemComponent.ActivateSystem();
            bCurrentlyActive = true;
        }
        else
        {
            ParticleSystemComponent.DeactivateSystem();
            bCurrentlyActive = false;
        }
    }
    ParticleSystemComponent.LastRenderTime = WorldInfo.TimeSeconds;
    ForceNetRelevant();
    if (RemoteRole != 0)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'Emitter.bCurrentlyActive', bCurrentlyActive == default.bCurrentlyActive);
    }
}

simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    if (bDestroyOnSystemFinish)
    {
        LifeSpan = 0.0001;
    }
    bCurrentlyActive = false;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bCurrentlyActive')
    {
        ParticleSystemComponent.SetActive(bCurrentlyActive);
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (WorldInfo.NetMode == 1 && RemoteRole == 0 || bNetTemporary)
    {
        LifeSpan = 0.2;
    }
    if (ParticleSystemComponent != none)
    {
        ParticleSystemComponent.__OnSystemFinished__Delegate = OnParticleSystemFinished;
        bCurrentlyActive = ParticleSystemComponent.bAutoActivate;
    }
}

native event SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish)
{
    NewTemplate;
    bDestroyOnFinish;
}

defaultproperties
{
    ParticleSystemComponent="Default__Emitter.ParticleSystemComponent0"
    AdjustStopMotionSpeed=2.0
    bNoDelete=True
    bHardAttach=True
    bGameRelevant=True
    bEdShouldSnap=True
    Components(0)="Default__Emitter.Sprite"
    Components(1)="Default__Emitter.ParticleSystemComponent0"
    Components(2)="Default__Emitter.ArrowComponent0"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_ParticleEvent"
}
