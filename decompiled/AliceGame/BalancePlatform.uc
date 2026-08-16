class BalancePlatform extends InterpActor
    placeable
    hidecategories(Navigation);

var int PlatformWeight;
var int DesireHeight;
var float Height;
var float Layer;
var float LayerHeight;
var bool bRotateOwner;
var bool bAliceOn;
var bool bAliceShrink;
var bool bOldCinematicMode;
var bool bCinematicMode;
var bool bLastTickMove;
var Vector OriginLocation;
var float ActivatedSpeed;
var float InactivatedSpeed;
var float fLastZ;
var MaterialInstanceConstant LightMIC;

function bool IsAliceAbovePlatform()
{
    local Vector HitLocation, HitNormal, TraceEnd, TraceStart, Extent;
    local Actor HitActor;
    
    if (CollisionComponent != none)
    {
        Extent = CollisionComponent.Bounds.BoxExtent;
        Extent.X += float(10);
        Extent.Y += float(10);
        Extent.Z = 1.0;
    }
    TraceStart = Location;
    TraceEnd = TraceStart + vect(0.0, 0.0, 100.0);
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, , Extent);
    if (AlicePawn(HitActor) != none)
    {
        return true;
    }
    return false;
}

function bool IsAliceBaseOnPlatform()
{
    return bAliceOn;
}

function float GetBasedActorsWeight(Actor hasBasedActor)
{
    local float weightValue;
    local Actor A;
    
    bAliceOn = false;
    bAliceShrink = false;
    foreach hasBasedActor.BasedActors(class'Engine.Actor', A)
    {
        weightValue += GetBasedActorsWeight(A);
        if (AlicePawn(A) != none)
        {
            weightValue += float(1);
            bAliceOn = true;
            if (AlicePawn(A).bShrinkingModeActive)
            {
                bAliceShrink = true;
            }
            continue;
        }
        if (AliceClonePawn(A) != none)
        {
            weightValue += float(1);
            continue;
        }
        if (DynamicSMActor(A) != none && !A.bHidden)
        {
            weightValue += DynamicSMActor(A).Weight;
        }
    }
    if (weightValue > float(1))
    {
        weightValue = 1.0;
    }
    return weightValue;
}

function CheckPlatformBalance()
{
    PlatformWeightChanged(self, 0);
}

function PlatformWeightChanged(BalancePlatform platform, int ChangedWeight)
{
    BalanceScales(Owner).PlatformWeightChanged(platform, PlatformWeight);
}

function float GetTorque()
{
    Layer = Height / LayerHeight;
    return Layer + float(PlatformWeight);
}

function Down(float DeltaLayer)
{
    DesireHeight = int(Height - DeltaLayer * LayerHeight);
    ClearTimer('DowningTimer');
    ClearTimer('RaisingTimer');
    SetTimer(0.01, true, 'DowningTimer');
}

function Raise(float DeltaLayer)
{
    DesireHeight = int(Height + DeltaLayer * LayerHeight);
    ClearTimer('DowningTimer');
    ClearTimer('RaisingTimer');
    SetTimer(0.01, true, 'RaisingTimer');
}

function DowningTimer()
{
    local Vector Loc;
    local Rotator OldRotation;
    
    if (BalanceScales(Owner).IsWeightEqual())
    {
        Loc.Z = -InactivatedSpeed;
        Height -= InactivatedSpeed;
    }
    else
    {
        Loc.Z = -ActivatedSpeed;
        Height -= ActivatedSpeed;
    }
    MoveSmooth(Loc);
    if (bRotateOwner)
    {
        OldRotation = Owner.Rotation;
        Owner.SetRotation(OldRotation);
    }
    if (Height <= float(DesireHeight))
    {
        ForceRestoreOriginLocation();
        ClearTimer('DowningTimer');
    }
}

function RaisingTimer()
{
    local Vector Loc;
    local Rotator OldRotation;
    
    if (BalanceScales(Owner).IsWeightEqual())
    {
        Loc.Z = InactivatedSpeed;
        Height += InactivatedSpeed;
    }
    else
    {
        Loc.Z = ActivatedSpeed;
        Height += ActivatedSpeed;
    }
    MoveSmooth(Loc);
    if (bRotateOwner)
    {
        OldRotation = Owner.Rotation;
        Owner.SetRotation(OldRotation);
    }
    if (Height >= float(DesireHeight))
    {
        ForceRestoreOriginLocation();
        ClearTimer('RaisingTimer');
    }
}

function ForceRestoreOriginLocation()
{
    if (PlatformWeight == 0 && BalanceScales(Owner).IsWeightEqual())
    {
    }
}

function checkRealMoving()
{
    if (bLastTickMove && Location.Z == fLastZ)
    {
        BalanceScales(Owner).notifyMoveStop();
        ActiveEffect(false);
    }
    else if (!bLastTickMove && Location.Z != fLastZ)
    {
        BalanceScales(Owner).notifyMoveStart();
        ActiveEffect(true);
    }
    bLastTickMove = Location.Z != fLastZ;
    fLastZ = Location.Z;
}

function ActiveEffect(bool On)
{
    if (On)
    {
        LightMIC.SetScalarParameterValue('EmissiveSwitch', 1.0);
    }
    else
    {
        LightMIC.SetScalarParameterValue('EmissiveSwitch', 0.0);
    }
}

function CheckBalanceProc()
{
    local float currentWeight;
    
    currentWeight = GetBasedActorsWeight(self);
    if (IsAliceAbovePlatform() && !IsAliceBaseOnPlatform())
    {
        currentWeight += float(1);
    }
    if (currentWeight > float(1))
    {
        currentWeight = 1.0;
    }
    if (currentWeight != float(PlatformWeight))
    {
        PlatformWeight = int(currentWeight);
        CheckPlatformBalance();
    }
    checkRealMoving();
}

function bool ShouldSaveForCheckpoint()
{
    return false;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SetTimer(0.1, true, 'CheckBalanceProc');
    OriginLocation = Location;
    fLastZ = Location.Z;
    bLastTickMove = false;
    if (LightMIC == none)
    {
        LightMIC = new(none) class'Engine.MaterialInstanceConstant';
        if (LightMIC != none)
        {
            LightMIC.SetParent(StaticMeshComponent.GetMaterial(0));
            StaticMeshComponent.SetMaterial(0, LightMIC);
        }
    }
}

defaultproperties
{
    LayerHeight=100.0
    StaticMeshComponent="Default__BalancePlatform.StaticMeshComponent0"
    LightEnvironment="Default__BalancePlatform.MyLightEnvironment"
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    Components(0)="Default__BalancePlatform.MyLightEnvironment"
    Components(1)="Default__BalancePlatform.StaticMeshComponent0"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__BalancePlatform.StaticMeshComponent0"
}
