class AliceItemPickupFactory extends AlicePickupFactory
    abstract
    native
    placeable
    config(Weapon)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

var(Pickup) SoundCue PickupSound;
var(Pickup) SoundCue FlyingSound;
var(Pickup) export editinline StaticMeshComponent StaticMesh;
var(Pickup) float Speed;
var(Pickup) float PickupRadius;
var(Pickup) Rotator IdleRotation;
var(Pickup) float DelayTimeAfterDrop;
var const localized string PickupMessage;
var float RespawnTime;
var float flyTime;
var bool bFlyingToAlice;
var bool bPlayingFlySound;
var bool bEnablePick;

function LineTrail(float DeltaTime)
{
    local Vector Aliceloc, Dir;
    
    flyTime += DeltaTime;
    Aliceloc = WorldInfo.GetLocalPlayerPawn().Location;
    Dir = Aliceloc - Location;
    Dir = Normal(Dir);
    if (VSize(Aliceloc - Location) < float(50))
    {
        GiveTo(WorldInfo.GetLocalPlayerPawn());
        return;
    }
    Move(Speed * flyTime * Dir);
}

function float BotDesireability(Pawn P, Controller C)
{
    return 0.0;
}

function float GetRespawnTime()
{
    return RespawnTime;
}

function SetRespawn()
{
    if (WorldInfo.Game.ShouldRespawn(self))
    {
        StartSleeping();
    }
    else
    {
        GotoState('Disabled');
    }
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    flyTime = 0.0;
    PickupItemRotationRate = IdleRotation;
    Landed(HitNormal, FloorActor);
}

function SpawnCopyFor(Pawn Recipient)
{
    Recipient.PlaySound(PickupSound);
    Recipient.MakeNoise(0.2);
    if (PlayerController(Recipient.Controller) != none)
    {
        PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass, , , , Class);
    }
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.PickupMessage;
}

function DelayTimeOver()
{
    bEnablePick = true;
}

simulated function InitializePickup()
{
    PickupMesh = StaticMesh;
    InitPickupMeshEffects();
    if (DelayTimeAfterDrop > float(0))
    {
        SetTimer(DelayTimeAfterDrop, false, 'DelayTimeOver');
    }
    else
    {
        DelayTimeOver();
    }
}

defaultproperties
{
    Speed=500.0
    PickupRadius=50000.0
    DelayTimeAfterDrop=0.8
    RespawnTime=30.0
    BaseMesh="Default__AliceItemPickupFactory.BaseMeshComp"
    LightEnvironment="Default__AliceItemPickupFactory.PickupLightEnvironment"
    PickUpWaveForm="Default__AliceItemPickupFactory.ForceFeedbackWaveformPickUp"
    InventoryType="AlicePickupInventory"
    CylinderComponent="Default__AliceItemPickupFactory.CollisionCylinder"
    Components(0)="Default__AliceItemPickupFactory.CollisionCylinder"
    Components(1)="Default__AliceItemPickupFactory.PathRenderer"
    Components(2)="Default__AliceItemPickupFactory.PickupLightEnvironment"
    Components(3)="Default__AliceItemPickupFactory.BaseMeshComp"
    CollisionComponent="Default__AliceItemPickupFactory.CollisionCylinder"
}
