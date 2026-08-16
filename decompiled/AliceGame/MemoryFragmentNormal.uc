class MemoryFragmentNormal extends AliceItemPickupFactory
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

enum EMemoryFragmentType
{
    MF_Bumby,
    MF_DR,
    MF_Family,
    MF_Lawyer,
    MF_Nanny,
    MF_Pris,
    MF_Queen,
};

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bPickUpedPdata;
    var bool bPickupHidden;
};

var config float CollisionRadius;
var config float CollisionHeight;
var(Pickup) export editinline ParticleSystemComponent IdleParticle;
var(Pickup) export editinline ParticleSystemComponent PickupParticle;
var(Pickup) StaticMesh PickedStaticMesh;
var AlicePawn ap;
var transient string initMostOutName;
var transient string initActorFName;
var bool bPickUped;
var bool bPickUpedPdata;
var bool bInitHideSet;
var(Pickup) bool bMustInteract;
var bool bInRadius;
var(MemroyFragment) string BinkName;
var(MemroyFragment) EMemoryFragmentType MemoryFragmentType;
var(MemroyFragment) string MemoryName;

event UpdateAfterAcceptPersistentDate()
{
    if (bInitHideSet)
    {
        SetHidden(true);
    }
    else if (bPickUpedPdata)
    {
        IdleParticle.SetActive(false);
        IdleParticle.SetHidden(true);
        SetCollision(false, false);
        SetPickupVisible();
        InitializePickup();
        if (bPickUpedPdata)
        {
            if (PickedStaticMesh != none)
            {
                StaticMesh.SetStaticMesh(PickedStaticMesh);
            }
        }
        GotoState('Pickup');
    }
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    if (Action.InputLinks[1].bHasImpulse)
    {
        bPickupHidden = false;
        if (bPickUpedPdata)
        {
            IdleParticle.SetActive(false);
            IdleParticle.SetHidden(true);
            if (PickedStaticMesh != none)
            {
                StaticMesh.SetStaticMesh(PickedStaticMesh);
            }
        }
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
    }
    OnToggleHidden(Action);
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    bPickUpedPdata = Record.bPickUpedPdata;
    bPickupHidden = Record.bPickupHidden;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    InitializePickup();
    if (!bPickupHidden)
    {
        SetPickupVisible();
    }
    if (bPickUpedPdata)
    {
        IdleParticle.SetActive(false);
        IdleParticle.SetHidden(true);
        if (PickedStaticMesh != none)
        {
            StaticMesh.SetStaticMesh(PickedStaticMesh);
        }
    }
    GotoState('Pickup');
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bPickUpedPdata = bPickUpedPdata;
    Record.bPickupHidden = bPickupHidden;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
}

event Tick(float DeltaTime)
{
    if (bFlyingToAlice && !bPickUped)
    {
        if (Physics != 4)
        {
            SetPhysics(4);
        }
        LineTrail(DeltaTime);
    }
}

function ActivePickup()
{
    if (bMustInteract)
    {
        bMustInteract = false;
        bFlyingToAlice = true;
        SetPhysics(4);
        SetCollision(true, false);
    }
}

event ShowPressButtonUI(bool bShow)
{
    local MemoryFragmentNormal pickitem;
    
    if (!bShow)
    {
        foreach AllActors(class'MemoryFragmentNormal', pickitem)
        {
            if (pickitem.bMustInteract && VSize(WorldInfo.GetLocalPlayerPawn().Location - pickitem.Location) < pickitem.PickupRadius)
            {
                return;
            }
        }
        AlicePawn(WorldInfo.GetLocalPlayerPawn()).bInPickRadius = false;
    }
    else
    {
        AlicePawn(WorldInfo.GetLocalPlayerPawn()).bInPickRadius = true;
    }
    AliceGameInfo(WorldInfo.Game).ShowPickTips(bShow);
}

simulated function SetPickupHidden()
{
    local bool backupbPickupHidden;
    
    IdleParticle.DeactivateSystem();
    IdleParticle.SetHidden(true);
    ShowPressButtonUI(false);
    backupbPickupHidden = bPickupHidden;
    SetPickupHidden();
    bPickupHidden = backupbPickupHidden;
    HackHiddenMesh();
}

simulated function SetPickupVisible()
{
    local bool backupbPickupHidden;
    
    if (!bPickUpedPdata)
    {
        IdleParticle.SetActive(true);
        IdleParticle.SetHidden(false);
    }
    SetCollision(true, true);
    backupbPickupHidden = bPickupHidden;
    SetPickupVisible();
    bPickupHidden = backupbPickupHidden;
}

function saveToPersistentData(Pawn P)
{
    if (AlicePawn(P) == none || AlicePlayerController(P.Controller) == none)
    {
        return;
    }
    AlicePlayerController(P.Controller).setMemoryFragment(BinkName);
}

function GiveTo(Pawn P)
{
    if (!bPickUpedPdata)
    {
        PickupParticle.SetActive(true);
    }
    bPickUped = true;
    bPickUpedPdata = true;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
    GiveTo(P);
    saveToPersistentData(P);
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    if (bMustInteract)
    {
        SetCollision(false, false);
    }
    Landed(HitNormal, FloorActor);
}

function PlayMemorySound()
{
    PlayBinkFile(BinkName);
}

function SpawnCopyFor(Pawn Recipient)
{
    if (AliceInventoryManager(Recipient.InvManager) != none)
    {
        AliceInventoryManager(Recipient.InvManager).AddMemoryFragment(self);
    }
    Recipient.PlaySound(PickupSound);
    Recipient.MakeNoise(0.2);
    if (PlayerController(Recipient.Controller) != none)
    {
        PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass, , , , Class);
    }
    SetTimer(0.3, false, 'PlayMemorySound');
}

native function PlayBinkFile(string Filename)
{
    Filename;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'TransformedClass')
    {
        if (bPickupHidden)
        {
            SetPickupHidden();
        }
        else
        {
            SetPickupVisible();
        }
        InitPickupMeshEffects();
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SetCollisionSize(CollisionRadius, CollisionHeight);
    if (bMustInteract)
    {
        SetCollision(false, false);
    }
    bInitHideSet = bHidden;
    bPickupHidden = bHidden;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
}

native function HackHiddenMesh()
{
}

state PickedState
{
    event BeginState(name PreviousStateName)
    {
        SetPhysics(0);
    }
    
    function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
    }
    
    Stop;
}

auto state Pickup
{
    function float DetourWeight(Pawn P, float PathWeight)
    {
        return 0.0;
    }
    
    function bool ValidTouch(Pawn Other)
    {
        if (bMustInteract || !ValidTouch(Other))
        {
            return false;
        }
        if (!bPickUpedPdata)
        {
            PickupParticle.SetActive(true);
        }
        bPickUped = true;
        bPickUpedPdata = true;
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
        return true;
    }
    
    Stop;
}

defaultproperties
{
    CollisionRadius=20.0
    CollisionHeight=20.0
    IdleParticle="Default__MemoryFragmentNormal.GlowEffect"
    PickupParticle="Default__MemoryFragmentNormal.PickupEffect"
    bMustInteract=True
    StaticMesh="Default__MemoryFragmentNormal.AmmoMeshComp"
    PickupRadius=200.0
    bRotatingPickup=True
    PickupItemRotationRate=(Pitch=0,Yaw=32768,Roll=0)
    BaseMesh="Default__MemoryFragmentNormal.BaseMeshComp"
    LightEnvironment="Default__MemoryFragmentNormal.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragmentNormal.ForceFeedbackWaveformPickUp"
    MaxDesireability=0.2
    bNotBased=True
    bShouldSaveForCheckpoint=True
    CylinderComponent="Default__MemoryFragmentNormal.CollisionCylinder"
    bMovable=True
    Components(0)="Default__MemoryFragmentNormal.CollisionCylinder"
    Components(1)="Default__MemoryFragmentNormal.PathRenderer"
    Components(2)="Default__MemoryFragmentNormal.PickupLightEnvironment"
    Components(3)="Default__MemoryFragmentNormal.BaseMeshComp"
    Components(4)="Default__MemoryFragmentNormal.AmmoMeshComp"
    Components(5)="Default__MemoryFragmentNormal.GlowEffect"
    Components(6)="Default__MemoryFragmentNormal.PickupEffect"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__MemoryFragmentNormal.CollisionCylinder"
}
