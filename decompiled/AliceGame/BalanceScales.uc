class BalanceScales extends NavigationPoint
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() BalancePlatform PlatformA;
var() BalancePlatform PlatformB;
var() float MaxDepth;
var() float ActivatedSpeed;
var() float InactivatedSpeed;
var() export editinline AudioComponent ActivatedAudio;
var() SoundCue MoveStopSoundCue;
var() export editinline StaticMeshComponent BalanceMesh;
var float ActivationTime;
var bool bMoveStart;

function notifyMoveStart()
{
    if (ActivatedAudio != none && !ActivatedAudio.IsPlaying())
    {
        ActivatedAudio.Play();
    }
    bMoveStart = true;
}

function notifyMoveStop()
{
    if (bMoveStart)
    {
        PlaySound(MoveStopSoundCue);
    }
    bMoveStart = false;
    if (ActivatedAudio != none)
    {
        ActivatedAudio.Stop();
    }
}

function bool IsShouldDelay()
{
    if (PlatformA.IsAliceBaseOnPlatform() || PlatformB.IsAliceBaseOnPlatform())
    {
        return true;
    }
    return false;
}

function bool IsWeightEqual()
{
    return PlatformA.PlatformWeight == PlatformB.PlatformWeight;
}

function MakeBalance()
{
    local float TorqueA, TorqueB, DeltaLayer;
    
    TorqueA = PlatformA.GetTorque();
    TorqueB = PlatformB.GetTorque();
    if (TorqueA > TorqueB)
    {
        DeltaLayer = (TorqueA - TorqueB) / float(2);
        PlatformA.Down(DeltaLayer);
        PlatformB.Raise(DeltaLayer);
    }
    else if (TorqueA < TorqueB)
    {
        DeltaLayer = (TorqueB - TorqueA) / float(2);
        PlatformB.Down(DeltaLayer);
        PlatformA.Raise(DeltaLayer);
    }
}

function PlatformWeightChanged(BalancePlatform platform, int NewWeight)
{
    if (platform != none)
    {
        SetTimer(ActivationTime, false, 'MakeBalance');
    }
}

function InitPlatformData(BalancePlatform BP)
{
    BP.SetOwner(self);
    BP.LayerHeight = 2.0 * MaxDepth;
    BP.ActivatedSpeed = ActivatedSpeed;
    BP.InactivatedSpeed = InactivatedSpeed;
}

function ResetPlatformData()
{
    if (PlatformA != none)
    {
        InitPlatformData(PlatformA);
        PlatformA.bRotateOwner = true;
    }
    if (PlatformB != none)
    {
        InitPlatformData(PlatformB);
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    ResetPlatformData();
}

defaultproperties
{
    MaxDepth=128.0
    ActivatedSpeed=1.0
    InactivatedSpeed=2.0
    ActivatedAudio="Default__BalanceScales.ActivedSound"
    BalanceMesh="Default__BalanceScales.StaticMeshComponent0"
    ActivationTime=1.0
    bNeverUseStrafing=True
    bForceNoStrafing=True
    bSpecialMove=True
    bNoAutoConnect=True
    ExtraCost=400
    CylinderComponent="Default__BalanceScales.CollisionCylinder"
    GoodSprite="Default__BalanceScales.Sprite"
    BadSprite="Default__BalanceScales.Sprite2"
    bStatic=False
    bHidden=True
    Components(0)="Default__BalanceScales.Sprite"
    Components(1)="Default__BalanceScales.Sprite2"
    Components(2)="Default__BalanceScales.Arrow"
    Components(3)="Default__BalanceScales.CollisionCylinder"
    Components(4)="Default__BalanceScales.PathRenderer"
    Components(5)="Default__BalanceScales.StaticMeshComponent0"
    Components(6)="Default__BalanceScales.ActivedSound"
    CollisionComponent="Default__BalanceScales.CollisionCylinder"
}
