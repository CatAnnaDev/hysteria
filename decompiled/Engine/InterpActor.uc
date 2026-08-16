class InterpActor extends DynamicSMActor
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var ECollisionType CollisionType;
    var bool bHidden;
    var bool bIsShutdown;
    var bool bNeedsPositionReplication;
};

var bool bShouldSaveForCheckpoint;
var bool bMonitorMover;
var bool bMonitorZVelocity;
var() bool bDestroyProjectilesOnEncroach;
var() bool bContinueOnEncroachPhysicsObject;
var() bool bStopOnEncroach;
var() bool bShouldShadowParentAllAttachedActors;
var bool bIsLift;
var() bool bCanBeHitByAliceProjectile;
var bool bSonarActive;
var bool bSonarActor;
var NavigationPoint MyMarker;
var float MaxZVelocity;
var float StayOpenTime;
var() SoundCue OpenSound;
var() SoundCue OpeningAmbientSound;
var() SoundCue OpenedSound;
var() SoundCue CloseSound;
var() SoundCue ClosingAmbientSound;
var() SoundCue ClosedSound;
var export editinline AudioComponent AmbientSoundComponent;

function updateSonarMat(float DeltaTime)
{
}

event Tick(float DeltaTime)
{
    updateSonarMat(DeltaTime);
}

function setSonarActor(bool bIsSonar)
{
    bSonarActor = bIsSonar;
}

function setMatLocalize()
{
    local int ElementIndex;
    local float fLang;
    local string sLang;
    local MaterialInstanceConstant MatInst;
    
    if (StaticMeshComponent == none)
    {
        return;
    }
    fLang = 0.0;
    sLang = GetLanguage();
    if (sLang == "INT")
    {
        fLang = 0.0;
    }
    else if (sLang == "DEU")
    {
        fLang = 1.0;
    }
    else if (sLang == "FRA")
    {
        fLang = 2.0;
    }
    else if (sLang == "ESN")
    {
        fLang = 3.0;
    }
    else if (sLang == "ITA")
    {
        fLang = 4.0;
    }
    else if (sLang == "JPN")
    {
        fLang = 0.0;
    }
    for (ElementIndex = 0; ElementIndex < StaticMeshComponent.GetNumElements(); ElementIndex++)
    {
        MatInst = MaterialInstanceConstant(StaticMeshComponent.GetMaterial(ElementIndex));
        if (MatInst != none)
        {
            MatInst.SetScalarParameterValue('Language', fLang);
        }
    }
}

simulated event Destroyed()
{
    Destroyed();
    if (bSonarActor)
    {
        WorldInfo.GetLocalPlayerPawn().Controller.RemoveSonarDetectedActor(self);
    }
}

function CreateAndSetSonarMat()
{
    local int ElementIndex;
    local MaterialInstanceConstant MatInst, newInstance;
    
    if (StaticMeshComponent == none)
    {
        return;
    }
    for (ElementIndex = 0; ElementIndex < StaticMeshComponent.GetNumElements(); ElementIndex++)
    {
        MatInst = MaterialInstanceConstant(StaticMeshComponent.GetMaterial(ElementIndex));
        if (MatInst != none && MatInst.bSonarMaterial)
        {
            newInstance = new(self) class'MaterialInstanceConstant';
            newInstance.SetParent(MatInst.Parent);
            newInstance.initSonarParam(MatInst);
            StaticMeshComponent.SetMaterial(ElementIndex, newInstance);
            setSonarActor(true);
            WorldInfo.GetLocalPlayerPawn().Controller.AddSonarDetectedActor(self);
        }
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    local Actor OldBase;
    local SkeletalMeshComponent OldBaseComp;
    local name OldBaseBoneName;
    local array<Actor> OldAttached;
    local array<Vector> OldLocations;
    local int I;
    
    if (Record.bIsShutdown)
    {
        ShutDown();
    }
    else
    {
        OldAttached = Attached;
        while (I < OldAttached.Length)
        {
            if (OldAttached[I] != none && OldAttached[I].bJustTeleported)
            {
                OldLocations[I] = OldAttached[I].Location;
                I++;
                continue;
            }
            OldAttached.Remove(I, 1);
        }
        OldBase = Base;
        OldBaseComp = BaseSkelComponent;
        OldBaseBoneName = BaseBoneName;
        SetLocation(Record.Location);
        SetRotation(Record.Rotation);
        SetBase(OldBase, , OldBaseComp, OldBaseBoneName);
        for (I = 0; I < OldAttached.Length; I++)
        {
            if (OldAttached[I] != none)
            {
                OldAttached[I].SetLocation(OldLocations[I]);
                OldAttached[I].SetBase(self);
            }
        }
        if (Record.CollisionType != ReplicatedCollisionType)
        {
            SetCollisionType(Record.CollisionType);
            ForceNetRelevant();
        }
        if (Record.bHidden != bHidden)
        {
            SetHidden(Record.bHidden);
            SetForcedInitialReplicatedProperty(BoolProperty'Actor.bHidden', bHidden == default.bHidden);
            ForceNetRelevant();
        }
        if (Record.bNeedsPositionReplication)
        {
            bUpdateSimulatedPosition = true;
            bReplicateMovement = true;
            ForceNetRelevant();
        }
    }
    bShouldSaveForCheckpoint = true;
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Location = Location;
    Record.Rotation = Rotation;
    Record.bHidden = bHidden;
    Record.CollisionType = ReplicatedCollisionType;
    Record.bNeedsPositionReplication = RemoteRole == 1 && bUpdateSimulatedPosition;
    Record.bIsShutdown = Physics == 0 && bHidden;
    LogInternal(" AliceCheckPoint Debug Info: save InterpActor name " @ string(self));
}

function bool ShouldSaveForCheckpoint()
{
    return bShouldSaveForCheckpoint || RemoteRole == 1;
}

simulated function ShutDown()
{
    ShutDown();
    bShouldSaveForCheckpoint = true;
}

simulated event InterpolationChanged(SeqAct_Interp InterpAction)
{
    PlayMovingSound(InterpAction.bReversePlayback);
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    local DoorMarker DoorNav;
    local Controller C;
    local SoundCue StoppedSound;
    
    if (AmbientSoundComponent != none)
    {
        AmbientSoundComponent.Stop();
    }
    StoppedSound = (InterpAction.bReversePlayback ? ClosedSound : OpenedSound);
    if (StoppedSound != none)
    {
        PlaySound(StoppedSound, true);
    }
    DoorNav = DoorMarker(MyMarker);
    if (InterpAction.bReversePlayback)
    {
        if (Attached.Length > 0)
        {
            SetTimer(StayOpenTime, false, 'Restart');
        }
        if (DoorNav != none)
        {
            DoorNav.MoverClosed();
        }
    }
    else
    {
        SetTimer(StayOpenTime, false, 'FinishedOpen');
        if (DoorNav != none)
        {
            DoorNav.MoverOpened();
        }
    }
    if (bMonitorMover)
    {
        foreach WorldInfo.AllControllers(class'Controller', C)
        {
            if (C.PendingMover == self)
            {
                C.MoverFinished();
            }
        }
    }
    if (InterpAction.bNoResetOnRewind && InterpAction.bRewindOnPlay)
    {
        ForceNetRelevant();
        bUpdateSimulatedPosition = true;
        bReplicateMovement = true;
    }
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    ClearTimer('Restart');
    ClearTimer('FinishedOpen');
    PlayMovingSound(InterpAction.bReversePlayback);
    bShouldSaveForCheckpoint = true;
}

simulated function PlayMovingSound(bool bClosing)
{
    local SoundCue SoundToPlay, AmbientToPlay;
    
    if (bClosing)
    {
        SoundToPlay = CloseSound;
        AmbientToPlay = OpeningAmbientSound;
    }
    else
    {
        SoundToPlay = OpenSound;
        AmbientToPlay = ClosingAmbientSound;
    }
    if (SoundToPlay != none)
    {
        PlaySound(SoundToPlay, true);
    }
    if (AmbientToPlay != none)
    {
        AmbientSoundComponent.Stop();
        AmbientSoundComponent.SoundCue = AmbientToPlay;
        AmbientSoundComponent.Play();
    }
}

function FinishedOpen()
{
    local int I;
    local SeqEvent_Mover MoverEvent;
    
    for (I = 0; I < GeneratedEvents.Length; I++)
    {
        MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
        if (MoverEvent != none)
        {
            MoverEvent.NotifyFinishedOpen();
        }
    }
}

function Restart()
{
    local Actor A;
    
    foreach BasedActors(class'Actor', A)
    {
        Attach(A);
    }
}

event Detach(Actor Other)
{
    local int I;
    local SeqEvent_Mover MoverEvent;
    
    for (I = 0; I < GeneratedEvents.Length; I++)
    {
        MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
        if (MoverEvent != none)
        {
            MoverEvent.NotifyDetached(Other);
        }
    }
}

event Attach(Actor Other)
{
    local int I;
    local SeqEvent_Mover MoverEvent;
    
    if (!IsTimerActive('FinishedOpen'))
    {
        for (I = 0; I < GeneratedEvents.Length; I++)
        {
            MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
            if (MoverEvent != none)
            {
                MoverEvent.NotifyAttached(Other);
            }
        }
    }
}

event RanInto(Actor Other)
{
    local int I;
    local SeqEvent_Mover MoverEvent;
    
    if (bDestroyProjectilesOnEncroach && Other.IsA('Projectile'))
    {
        Projectile(Other).Explode(Other.Location, -Normal(Velocity));
    }
    else if (Other.bDestroyedByInterpActor)
    {
        Other.Destroy();
    }
    else if (bIsLift)
    {
        return;
    }
    else
    {
        for (I = 0; I < GeneratedEvents.Length; I++)
        {
            MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
            if (MoverEvent != none)
            {
                MoverEvent.NotifyEncroachingOn(Other);
            }
        }
    }
}

event bool EncroachingOn(Actor Other)
{
    local int I;
    local SeqEvent_Mover MoverEvent;
    local Pawn P;
    local Vector Height, HitLocation, HitNormal;
    local bool bLandingPawn;
    
    if (bContinueOnEncroachPhysicsObject && Other.Physics == 10)
    {
        return false;
    }
    if (Other.bDestroyedByInterpActor)
    {
        Other.Destroy();
        return false;
    }
    if (Other.Base == self || Normal(Velocity) Dot Normal(Other.Location - Location) >= 0.0)
    {
        P = Pawn(Other);
        if (P != none)
        {
            if (P.Physics == 2 && Velocity.Z > 0.0)
            {
                Height = P.GetCollisionHeight() * vect(0.0, 0.0, 1.0);
                if (TraceComponent(HitLocation, HitNormal, StaticMeshComponent, P.Location - Height, P.Location + Height, P.GetCollisionExtent()))
                {
                    if (P.Location.Z < Location.Z)
                    {
                        P.SetLocation(HitLocation + Height);
                    }
                    bLandingPawn = true;
                }
            }
            else if (P.Base != self && P.Controller != none && P.Controller.PendingMover != none && P.Controller.PendingMover == self)
            {
                P.Controller.UnderLift(LiftCenter(MyMarker));
            }
            else if (P.isInEncroachState())
            {
                P.tryResolveEncroach();
            }
        }
        else if (bDestroyProjectilesOnEncroach && Other.IsA('Projectile'))
        {
            Projectile(Other).Explode(Other.Location, -Normal(Velocity));
            return false;
        }
        if (!bLandingPawn)
        {
            for (I = 0; I < GeneratedEvents.Length; I++)
            {
                MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
                if (MoverEvent != none)
                {
                    MoverEvent.NotifyEncroachingOn(Other);
                }
            }
            return bStopOnEncroach;
        }
    }
    return false;
}

native simulated function SetShadowParentOnAllAttachedComponents()
{
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (bShouldShadowParentAllAttachedActors)
    {
        SetShadowParentOnAllAttachedComponents();
    }
    if (OpeningAmbientSound != none || ClosingAmbientSound != none)
    {
        AmbientSoundComponent = new(self) class'AudioComponent';
        AttachComponent(AmbientSoundComponent);
    }
    if (Base != none && bHardAttach || BaseSkelComponent != none && BaseBoneName != 'None')
    {
        bShouldSaveForCheckpoint = false;
    }
    CreateAndSetSonarMat();
    setMatLocalize();
}

defaultproperties
{
    bShouldSaveForCheckpoint=True
    bDestroyProjectilesOnEncroach=True
    bContinueOnEncroachPhysicsObject=True
    bShouldShadowParentAllAttachedActors=True
    bSonarActive=True
    StaticMeshComponent="Default__InterpActor.StaticMeshComponent0"
    LightEnvironment="Default__InterpActor.MyLightEnvironment"
    bNoDelete=True
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    bBlocksTeleport=True
    Components(0)="Default__InterpActor.MyLightEnvironment"
    Components(1)="Default__InterpActor.StaticMeshComponent0"
    Physics="PHYS_Interpolating"
    RemoteRole="ROLE_None"
    NetUpdateFrequency=1.0
    NetPriority=2.7
    TickFrequencyAtEndDistance=0.1
    TickFrequencyDecreaseDistanceStart=4000.0
    TickFrequencyDecreaseDistanceEnd=8000.0
    CollisionComponent="Default__InterpActor.StaticMeshComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_Mover"
}
