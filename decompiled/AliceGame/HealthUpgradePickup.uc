class HealthUpgradePickup extends AliceItemPickupFactory
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bPickedSaveInPdata;
};

var() const localized string UITextToDisplay;
var() StaticMesh PickedStaticMesh;
var transient string initMostOutName;
var transient string initActorFName;
var bool bPickUped;
var bool bPickedSaveInPdata;
var bool bShowTips;

event UpdateAfterAcceptPersistentDate()
{
    if (bPickedSaveInPdata)
    {
        StaticMesh.SetStaticMesh(PickedStaticMesh);
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    bPickedSaveInPdata = Record.bPickedSaveInPdata;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    InitializePickup();
    GotoState('Pickup');
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bPickedSaveInPdata = bPickedSaveInPdata;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
}

function ActivePickup()
{
    bFlyingToAlice = true;
    SetPhysics(4);
    SetCollision(true, false);
}

event Tick(float DeltaTime)
{
    if (!bPickUped)
    {
        if (VSize(WorldInfo.GetLocalPlayerPawn().Location - Location) < PickupRadius)
        {
            if (!bShowTips)
            {
                AlicePlayerController(AlicePawn(WorldInfo.GetLocalPlayerPawn()).Controller).ShowContextActionUIHint(0, UITextToDisplay);
                bShowTips = true;
                AlicePawn(WorldInfo.GetLocalPlayerPawn()).bInPickRadius = true;
            }
        }
        else if (bShowTips)
        {
            AlicePlayerController(AlicePawn(WorldInfo.GetLocalPlayerPawn()).Controller).ShowContextActionUIHint(-1, UITextToDisplay);
            bShowTips = false;
            AlicePawn(WorldInfo.GetLocalPlayerPawn()).bInPickRadius = false;
        }
    }
    if (bFlyingToAlice && !bPickUped)
    {
        if (Physics != 4)
        {
            SetPhysics(4);
        }
        LineTrail(DeltaTime);
    }
}

function GiveTo(Pawn P)
{
    local int CurrentPickUpCount;
    
    CurrentPickUpCount = 1;
    bPickUped = true;
    bShowTips = false;
    AlicePawn(WorldInfo.GetLocalPlayerPawn()).bInPickRadius = false;
    if (!bPickedSaveInPdata)
    {
        AliceGameInfo(WorldInfo.Game).HealthUpgradePickupCount++;
        CurrentPickUpCount = AliceGameInfo(WorldInfo.Game).HealthUpgradePickupCount % 4;
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showHealthyUpgrade(CurrentPickUpCount);
        if (CurrentPickUpCount == 0)
        {
            AlicePawn(WorldInfo.GetLocalPlayerPawn()).HealthMax += 8;
            ConsoleCommand("trophy unlock=" @ string(20));
            if (AlicePawn(WorldInfo.GetLocalPlayerPawn()).HPMaxClamp > 0)
            {
                AlicePawn(WorldInfo.GetLocalPlayerPawn()).HealthMax = AlicePawn(WorldInfo.GetLocalPlayerPawn()).HPMaxClamp;
            }
            AlicePawn(WorldInfo.GetLocalPlayerPawn()).Health = AlicePawn(WorldInfo.GetLocalPlayerPawn()).HealthMax;
        }
    }
    AlicePlayerController(AlicePawn(WorldInfo.GetLocalPlayerPawn()).Controller).ShowContextActionUIHint(-1, UITextToDisplay);
    bPickedSaveInPdata = true;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
    StaticMesh.SetHidden(true);
    SetCollision(false, false);
    PickupItemRotationRate.Pitch = 0;
    PickupItemRotationRate.Roll = 0;
    PickupItemRotationRate.Yaw = 0;
    GiveTo(P);
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    SetCollision(false, false);
    Landed(HitNormal, FloorActor);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SetCollision(false, false);
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
}

state Disabled
{
    simulated event BeginState(name PreviousStateName)
    {
        SetCollision(false, false);
    }
    
    Stop;
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

defaultproperties
{
    StaticMesh="Default__HealthUpgradePickup.HealthUpgradePickupMeshComponent"
    PickupRadius=200.0
    bRotatingPickup=True
    PickupItemRotationRate=(Pitch=0,Yaw=32768,Roll=0)
    BaseMesh="Default__HealthUpgradePickup.BaseMeshComp"
    LightEnvironment="Default__HealthUpgradePickup.PickupLightEnvironment"
    PickUpWaveForm="Default__HealthUpgradePickup.ForceFeedbackWaveformPickUp"
    MaxDesireability=0.2
    bNotBased=True
    bShouldSaveForCheckpoint=True
    CylinderComponent="Default__HealthUpgradePickup.CollisionCylinder"
    bMovable=True
    Components(0)="Default__HealthUpgradePickup.CollisionCylinder"
    Components(1)="Default__HealthUpgradePickup.PathRenderer"
    Components(2)="Default__HealthUpgradePickup.PickupLightEnvironment"
    Components(3)="Default__HealthUpgradePickup.BaseMeshComp"
    Components(4)="Default__HealthUpgradePickup.HealthUpgradePickupMeshComponent"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__HealthUpgradePickup.CollisionCylinder"
}
