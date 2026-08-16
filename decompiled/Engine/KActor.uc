class KActor extends DynamicSMActor
    native
    nativereplication
    placeable;

var() bool bDamageAppliesImpulse;
var() repnotify bool bWakeOnLevelStart;
var bool bCurrentSlide;
var bool bSlideActive;
var(StayUprightSpring) bool bEnableStayUprightSpring;
var() bool bLimitMaxPhysicsVelocity;
var transient bool bNeedsRBStateReplication;
var bool bDisableClientSidePawnInteractions;
var export editinline ParticleSystemComponent ImpactEffectComponent;
var export editinline AudioComponent ImpactSoundComponent;
var export editinline AudioComponent ImpactSoundComponent2;
var float LastImpactTime;
var PhysEffectInfo ImpactEffectInfo;
var export editinline ParticleSystemComponent SlideEffectComponent;
var export editinline AudioComponent SlideSoundComponent;
var float LastSlideTime;
var PhysEffectInfo SlideEffectInfo;
var(StayUprightSpring) float StayUprightTorqueFactor;
var(StayUprightSpring) float StayUprightMaxTorque;
var() float MaxPhysicsVelocity;
var const native repretry RigidBodyState RBState;
var const native float AngErrorAccumulator;
var repnotify Vector ReplicatedDrawScale3D;
var transient Vector InitialLocation;
var transient Rotator InitialRotation;

replication
{
    if (bNetInitial && Role == 3)
        bWakeOnLevelStart, ReplicatedDrawScale3D;
    if (!bNeedsRBStateReplication && Role == 3)
        RBState;
}

simulated function Reset()
{
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    if (!bWakeOnLevelStart)
    {
        StaticMeshComponent.PutRigidBodyToSleep();
    }
    else
    {
        StaticMeshComponent.WakeRigidBody();
    }
    ResolveRBState();
    bForceNetUpdate = true;
    Reset();
}

simulated function OnTeleport(SeqAct_Teleport inAction)
{
    local array<Object> objVars;
    local int Idx;
    local Actor destActor;
    
    inAction.GetObjectVars(objVars, "Destination");
    for (Idx = 0; Idx < objVars.Length && destActor == none; Idx++)
    {
        destActor = Actor(objVars[Idx]);
    }
    if (destActor != none)
    {
        StaticMeshComponent.SetRBPosition(destActor.Location);
        StaticMeshComponent.SetRBRotation(destActor.Rotation);
        PlayTeleportEffect(false, true);
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        StaticMeshComponent.WakeRigidBody();
    }
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    local int Idx;
    local SeqEvent_TakeDamage DmgEvt;
    
    for (Idx = 0; Idx < GeneratedEvents.Length; Idx++)
    {
        DmgEvt = SeqEvent_TakeDamage(GeneratedEvents[Idx]);
        if (DmgEvt != none)
        {
            DmgEvt.HandleDamage(self, InstigatedBy, DamageType, int(BaseDamage));
        }
    }
    if (bDamageAppliesImpulse && DamageType.default.default.RadialDamageImpulse > float(0) && Role == 3)
    {
        CollisionComponent.AddRadialImpulse(HurtOrigin, DamageRadius, DamageType.default.default.RadialDamageImpulse, 1, DamageType.default.default.bRadialDamageVelChange);
    }
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (bDamageAppliesImpulse && DamageType.default.default.KDamageImpulse > float(0))
    {
        if (VSize(Momentum) < 0.001)
        {
            LogInternal("Zero momentum to KActor.TakeDamage");
            return;
        }
        ApplyImpulse(Momentum, DamageType.default.default.KDamageImpulse, HitLocation, HitInfo, DamageType);
    }
}

event ApplyImpulse(Vector ImpulseDir, float ImpulseMag, Vector HitLocation, optional TraceHitInfo HitInfo, optional class<DamageType> DamageType)
{
    local Vector AppliedImpulse;
    
    AppliedImpulse = Normal(ImpulseDir) * ImpulseMag;
    if (HitInfo.HitComponent != none)
    {
        HitInfo.HitComponent.AddImpulse(AppliedImpulse, HitLocation, HitInfo.BoneName);
    }
    else
    {
        CollisionComponent.AddImpulse(AppliedImpulse, HitLocation);
    }
}

simulated event ReplicatedEvent(name VarName)
{
    local Vector NewDrawScale3D;
    
    if (VarName == 'bWakeOnLevelStart')
    {
        if (bWakeOnLevelStart)
        {
            StaticMeshComponent.WakeRigidBody();
        }
    }
    else if (VarName == 'ReplicatedDrawScale3D')
    {
        NewDrawScale3D = ReplicatedDrawScale3D / 1000.0;
        SetDrawScale3D(NewDrawScale3D);
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated event SpawnedByKismet()
{
    if (StaticMeshComponent.bNotifyRigidBodyCollision)
    {
        SetPhysicalCollisionProperties();
    }
    InitialLocation = Location;
    InitialRotation = Rotation;
}

simulated function SetPhysicalCollisionProperties()
{
    local PhysicalMaterial PhysMat;
    
    PhysMat = GetKActorPhysMaterial();
    ImpactEffectInfo = PhysMat.FindPhysEffectInfo(0);
    SlideEffectInfo = PhysMat.FindPhysEffectInfo(1);
    if (ImpactEffectInfo.Effect != none)
    {
        ImpactEffectComponent = new(self) class'ParticleSystemComponent';
        AttachComponent(ImpactEffectComponent);
        ImpactEffectComponent.bAutoActivate = false;
        ImpactEffectComponent.SetTemplate(ImpactEffectInfo.Effect);
    }
    if (ImpactEffectInfo.Sound != none)
    {
        ImpactSoundComponent = new(self) class'AudioComponent';
        AttachComponent(ImpactSoundComponent);
        ImpactSoundComponent.SoundCue = ImpactEffectInfo.Sound;
        ImpactSoundComponent2 = new(self) class'AudioComponent';
        AttachComponent(ImpactSoundComponent2);
        ImpactSoundComponent2.SoundCue = ImpactEffectInfo.Sound;
    }
    if (SlideEffectInfo.Effect != none)
    {
        SlideEffectComponent = new(self) class'ParticleSystemComponent';
        AttachComponent(SlideEffectComponent);
        SlideEffectComponent.bAutoActivate = false;
        SlideEffectComponent.SetTemplate(SlideEffectInfo.Effect);
    }
    if (SlideEffectInfo.Sound != none)
    {
        SlideSoundComponent = new(self) class'AudioComponent';
        AttachComponent(SlideSoundComponent);
        SlideSoundComponent.SoundCue = SlideEffectInfo.Sound;
    }
}

simulated event Destroyed()
{
    if (ImpactEffectInfo.Sound != none)
    {
        if (ImpactSoundComponent != none)
        {
            ImpactSoundComponent.bAutoDestroy = true;
        }
        if (ImpactSoundComponent2 != none)
        {
            ImpactSoundComponent2.bAutoDestroy = true;
        }
    }
    if (SlideEffectInfo.Sound != none)
    {
        SlideSoundComponent.bAutoDestroy = true;
    }
    Destroyed();
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    ShutDown();
    FellOutOfWorld(dmgType);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (bWakeOnLevelStart && StaticMeshComponent != none)
    {
        StaticMeshComponent.WakeRigidBody();
    }
    else
    {
        bNeedsRBStateReplication = !bNoDelete;
    }
    ReplicatedDrawScale3D = DrawScale3D * 1000.0;
    if (StaticMeshComponent != none && StaticMeshComponent.bNotifyRigidBodyCollision)
    {
        SetPhysicalCollisionProperties();
    }
    InitialLocation = Location;
    InitialRotation = Rotation;
    if (bDisableClientSidePawnInteractions && Role != 3 && StaticMeshComponent != none)
    {
        StaticMeshComponent.SetRBCollidesWithChannel(2, false);
    }
}

native final function ResolveRBState()
{
}

native final function PhysicalMaterial GetKActorPhysMaterial()
{
}

defaultproperties
{
    bDamageAppliesImpulse=True
    bNeedsRBStateReplication=True
    bDisableClientSidePawnInteractions=True
    StayUprightTorqueFactor=1000.0
    StayUprightMaxTorque=1500.0
    MaxPhysicsVelocity=350.0
    ReplicatedDrawScale3D=(X=1000.0,Y=1000.0,Z=1000.0)
    StaticMeshComponent="Default__KActor.StaticMeshComponent0"
    LightEnvironment="Default__KActor.MyLightEnvironment"
    bPawnCanBaseOn=False
    bSafeBaseIfAsleep=True
    bNoDelete=True
    bAlwaysRelevant=True
    bUpdateSimulatedPosition=True
    bNetInitialRotation=True
    bBlocksNavigation=True
    bCollideActors=True
    bBlockActors=True
    bProjTarget=True
    bBlocksTeleport=True
    bNoEncroachCheck=True
    Components(0)="Default__KActor.MyLightEnvironment"
    Components(1)="Default__KActor.StaticMeshComponent0"
    Physics="PHYS_RigidBody"
    TickGroup="TG_PostAsyncWork"
    CollisionComponent="Default__KActor.StaticMeshComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_RigidBodyCollision"
}
