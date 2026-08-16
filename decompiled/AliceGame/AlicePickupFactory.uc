class AlicePickupFactory extends PickupFactory
    abstract
    native
    nativereplication
    placeable
    config(Weapon)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

var bool bRotatingPickup;
var repnotify bool bPulseBase;
var bool bFloatingPickup;
var(floating) bool bRandomStart;
var repnotify bool bIsDisabled;
var bool bUpdatingPickup;
var bool bDoVisibilityFadeIn;
var repnotify bool bIsRespawning;
var bool bHasLocationSpeech;
var config Rotator PickupItemRotationRate;
var Controller TeamOwner[4];
var transient export editinline StaticMeshComponent BaseMesh;
var MaterialInstanceConstant BaseMaterialInstance;
var LinearColor BaseBrightEmissive;
var LinearColor BaseDimEmissive;
var float BasePulseRate;
var float BasePulseTime;
var float PulseThreshold;
var LinearColor BaseTargetEmissive;
var LinearColor BaseEmissive;
var name BaseMaterialParamName;
var float BobTimer;
var float BobOffset;
var float BobSpeed;
var float BobBaseOffset;
var SoundCue RespawnSound;
var export editinline AudioComponent PickupReadySound;
var(Pickup) export editinline DynamicLightEnvironmentComponent LightEnvironment;
var Vector PivotTranslation;
var name PickupStatName;
var name VisibilityParamName;
var MaterialInstanceConstant MIC_Visibility;
var MaterialInstanceConstant MIC_VisibilitySecondMaterial;
var export editinline ParticleSystemComponent Glow;
var name GlowEmissiveParam;
var array<SoundNodeWave> LocationSpeech;
var float LastSeekNotificationTime;
var ForceFeedbackWaveform PickUpWaveForm;

replication
{
    if (bNetDirty && Role == 3)
        bPulseBase, bIsRespawning;
    if (bNetInitial && Role == 3)
        bIsDisabled;
}

function PickedUpBy(Pawn P)
{
    local PlayerController PC;
    
    PickedUpBy(P);
    PC = PlayerController(P.Controller);
    if (PC != none)
    {
        PC.ClientPlayForceFeedbackWaveform(PickUpWaveForm);
    }
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    if (bIsDisabled)
    {
        GotoState('Disabled');
    }
    else
    {
        SetInitialState();
    }
}

simulated function SetPickupHidden()
{
    if (PickupReadySound != none)
    {
        PickupReadySound.Stop();
    }
    if (Glow != none)
    {
        Glow.SetFloatParameter('LightStrength', 0.0);
    }
    SetPickupHidden();
}

simulated function SetPickupVisible()
{
    if (PickupReadySound != none)
    {
        PickupReadySound.Play();
    }
    if (Glow != none)
    {
        Glow.SetFloatParameter('LightStrength', 1.0);
    }
    SetPickupVisible();
}

simulated event InitPickupMeshEffects()
{
    if (PickupMesh != none)
    {
        PickupMesh.SetLightEnvironment(LightEnvironment);
        if (bDoVisibilityFadeIn && MeshComponent(PickupMesh) != none)
        {
            MIC_Visibility = MeshComponent(PickupMesh).CreateAndSetMaterialInstanceConstant(0);
            MIC_Visibility.SetScalarParameterValue(VisibilityParamName, bIsSuperItem ? 1.0 : 0.0);
        }
        BobBaseOffset = PickupMesh.Translation.Y;
        if (bRandomStart)
        {
            BobTimer = 1000.0 * FRand();
        }
    }
}

function name GetPickupStatName()
{
    if (default.PickupStatName != 'None')
    {
        return default.PickupStatName;
    }
    return 'INVALID_PICKUPSTAT';
}

simulated function SetPickupMesh()
{
    SetPickupMesh();
    InitPickupMeshEffects();
}

simulated function StartPulse(LinearColor TargetEmissive)
{
    if (WorldInfo.NetMode != 1 && BaseMesh != none && BaseMaterialParamName != 'None')
    {
        BaseTargetEmissive = TargetEmissive;
        if (BasePulseTime <= 0.0)
        {
            BasePulseTime = BasePulseRate;
        }
        else
        {
            BasePulseTime = BasePulseRate - BasePulseTime;
        }
    }
}

simulated function bool StopsProjectile(Projectile P)
{
    local Actor HitActor;
    local Vector HitNormal, HitLocation;
    
    if (P.CylinderComponent.CollisionRadius > float(0) || P.CylinderComponent.CollisionHeight > float(0))
    {
        HitActor = Trace(HitLocation, HitNormal, P.Location, P.Location - float(100) * Normal(P.Velocity), true, vect(0.0, 0.0, 0.0));
        if (HitActor != self)
        {
            return false;
        }
    }
    return bProjTarget || bBlockActors;
}

simulated function RespawnEffect()
{
    bIsRespawning = true;
    PlaySound(RespawnSound, true);
    if (PickupMesh != none)
    {
        PickupMesh.SetHidden(false);
    }
}

simulated function ReplicatedEvent(name VarName)
{
    if (VarName == 'bIsDisabled')
    {
        Global.SetInitialState();
    }
    else
    {
        if (VarName == 'bPickupHidden' && bPickupHidden)
        {
            SetResOut();
        }
        if (VarName == 'bPulseBase' || VarName == 'bPickupHidden')
        {
            StartPulse(bPickupHidden && !bPulseBase ? BaseDimEmissive : BaseBrightEmissive);
        }
        if (VarName == 'bIsRespawning')
        {
            if (bIsRespawning)
            {
                RespawnEffect();
            }
        }
        ReplicatedEvent(VarName);
    }
}

simulated function ShutDown()
{
    DisablePickup();
}

simulated function DisablePickup()
{
    bIsDisabled = true;
    GotoState('Disabled');
}

simulated function SetResOut()
{
    if (bDoVisibilityFadeIn && MIC_Visibility != none)
    {
        MIC_Visibility.SetScalarParameterValue(VisibilityParamName, 1.0);
    }
}

simulated function PostBeginPlay()
{
    if (bIsDisabled)
    {
        return;
    }
    PostBeginPlay();
    bUpdatingPickup = WorldInfo.NetMode != 1 && bRotatingPickup || bFloatingPickup;
    if (Glow != none)
    {
        Glow.SetFloatParameter('LightStrength', 0.0);
        Glow.SetActive(true);
    }
    if (WorldInfo.NetMode != 1 && BaseMesh != none && BaseMaterialParamName != 'None')
    {
        BaseMaterialInstance = BaseMesh.CreateAndSetMaterialInstanceConstant(0);
        BaseTargetEmissive = (bPickupHidden ? BaseDimEmissive : BaseBrightEmissive);
        BaseEmissive = BaseTargetEmissive;
        BaseMaterialInstance.SetVectorParameterValue(BaseMaterialParamName, BaseEmissive);
    }
    if (!bIsSuperItem && PickupReadySound != none)
    {
        PickupReadySound.Play();
    }
    if (WorldInfo.bUseConsoleInput)
    {
        SetCollisionSize(1.5 * CylinderComponent.CollisionRadius, CylinderComponent.CollisionHeight);
    }
}

state Disabled
{
    function float BotDesireability(Pawn P, Controller C)
    {
        return 0.0;
    }
    
    Stop;
}

state Sleeping
{
    function PulseThresholdMet()
    {
        bPulseBase = true;
        StartPulse(BaseBrightEmissive);
    }
    
    function EndState(name NextStateName)
    {
        EndState(NextStateName);
        ClearTimer('PulseThresholdMet');
    }
    
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        bPulseBase = false;
        StartPulse(BaseDimEmissive);
        SetTimer(GetRespawnTime() - PulseThreshold, false, 'PulseThresholdMet');
    }
    
    Stop;
}

auto state Pickup
{
    simulated function EndState(name NextStateName)
    {
        EndState(NextStateName);
        bIsRespawning = false;
        SetResOut();
    }
    
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        bPulseBase = false;
        StartPulse(BaseBrightEmissive);
    }
    
    Stop;
}

defaultproperties
{
    bDoVisibilityFadeIn=True
    BaseMesh="Default__AlicePickupFactory.BaseMeshComp"
    BaseBrightEmissive=(R=0.0,G=0.0,B=0.0,A=1.0)
    BaseDimEmissive=(R=0.0,G=0.0,B=0.0,A=1.0)
    BasePulseRate=0.5
    PulseThreshold=5.0
    BaseTargetEmissive=(R=0.0,G=0.0,B=0.0,A=1.0)
    BaseEmissive=(R=0.0,G=0.0,B=0.0,A=1.0)
    BaseMaterialParamName="BaseEmissiveControl"
    LightEnvironment="Default__AlicePickupFactory.PickupLightEnvironment"
    VisibilityParamName="ResIn"
    GlowEmissiveParam="LightStrength"
    PickUpWaveForm="Default__AlicePickupFactory.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__AlicePickupFactory.CollisionCylinder"
    GoodSprite="None"
    BadSprite="None"
    bNoDelete=False
    bMovable=False
    Components(0)="Default__AlicePickupFactory.CollisionCylinder"
    Components(1)="Default__AlicePickupFactory.PathRenderer"
    Components(2)="Default__AlicePickupFactory.PickupLightEnvironment"
    Components(3)="Default__AlicePickupFactory.BaseMeshComp"
    TickGroup="TG_PreAsyncWork"
    CollisionComponent="Default__AlicePickupFactory.CollisionCylinder"
}
