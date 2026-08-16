class AliceHoverVolume extends DynamicPhysicsVolume
    placeable
    hidecategories(Navigation,Object,Display);

var float SteamVentForwardSpeed;
var float SteamVentStrafeSpeed;
var() float SteamVentRotationSpeed;
var float SteamVentUpSpeed;
var float SteamVentTopZoneHeight;
var float SteamVent2ndZoneHeight;
var float ForceFloatDuration;
var float SteamVentUpAccel;
var float DelayCameraTimeWhenLeave;
var float HoverDuration;
var float PawnEnterZSpeed;
var float AccumHoverDelay;
var float HoverDelayTime;
var() float HoverAmplitude;
var() float HoverCycleTime;
var() Vector Force;
var() Vector PerturbAmplitude;
var() float Damping;

function ApplyWind(Actor Actor)
{
    local HairComponent HairComponent;
    local ClothComponent ClothComponent;
    
    foreach Actor.AllOwnedComponents(class'Engine.HairComponent', HairComponent)
    {
        HairComponent.Force += Force;
        HairComponent.Damping += Damping;
        HairComponent.PerturbAmplitude += PerturbAmplitude;
    }
    foreach Actor.AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        ClothComponent.Force += Force;
        ClothComponent.Damping += Damping;
        ClothComponent.PerturbAmplitude += PerturbAmplitude;
    }
}

function Update(float DeltaTime, AlicePlayerController APC)
{
    HoverDuration += DeltaTime;
}

function float GetHoverZSpeed(AlicePawn Pawn, float DeltaTime)
{
    local float ZSpeed, Angle, Diff, NewZSpeed;
    
    AccumHoverDelay += DeltaTime;
    if (PawnEnterZSpeed < float(200))
    {
        Angle = 2.0 * 3.1415927 * HoverDuration / HoverCycleTime;
        ZSpeed = HoverAmplitude * Sin(Angle);
    }
    else
    {
        if (AccumHoverDelay < HoverDelayTime)
        {
            Diff = -PawnEnterZSpeed;
            NewZSpeed = PawnEnterZSpeed + Diff * (AccumHoverDelay / HoverDelayTime);
            return NewZSpeed;
        }
        Angle = 2.0 * 3.1415927 * (HoverDuration - HoverDelayTime) / HoverCycleTime;
        ZSpeed = HoverAmplitude * Sin(Angle) * float(-1);
    }
    return ZSpeed;
}

function Vector GetAdjustVelocity(AlicePawn Pawn, float DeltaTime)
{
    local Vector NewVelocity;
    
    NewVelocity = Pawn.Velocity;
    NewVelocity.Z = GetHoverZSpeed(Pawn, DeltaTime);
    return NewVelocity;
}

function Vector GetAccel(AlicePawn Pawn)
{
    return Pawn.Acceleration;
}

simulated event PawnLeavingVolume(Pawn P)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(P.Controller);
    if (APC != none)
    {
        if (!APC.IsInState('PlayerFloat'))
        {
            APC.GotoState('PlayerWalking');
            APC.MyAlicePawn.SetPhysics(2);
        }
        APC.MyAlicePawn.SkirtComponent.RadialForceMagnitude = 0.0;
        if (APC.SteamVentVolume != none)
        {
            APC.bDelayCameraInSteam = true;
            APC.SetTimer(DelayCameraTimeWhenLeave, false, 'ResetDelayCameraTime');
            APC.SteamVentVolume = none;
        }
        APC.MyAlicePawn.bJustLeaveHover = true;
        if (!APC.MyAlicePawn.IsDoingSpecialMove(64))
        {
            APC.MyAlicePawn.bAfterHoverJump = false;
        }
    }
}

function TestHeight(AlicePlayerController APC)
{
    local Vector vStart, vEnd;
    local float MinHeight, MaxHeight;
    
    APC.GetVolumeGeometryInfo(self, MinHeight, MaxHeight);
    vStart = Location;
    vStart.Z = MaxHeight;
    vEnd = vStart;
    vEnd.Z += float(200);
    APC.DrawDebugLine(vStart, vEnd, 255, 0, 0, true);
    vStart.Z = MinHeight;
    vEnd.Z = vStart.Z + float(200);
    APC.DrawDebugLine(vStart, vEnd, 0, 255, 0, true);
}

function bool IsEnterFromBottom(AlicePlayerController APC)
{
    local float MinHeight, MaxHeight;
    local bool bResult;
    
    APC.GetVolumeGeometryInfo(self, MinHeight, MaxHeight);
    bResult = APC.Pawn.Velocity.Z > float(100) && APC.Pawn.Location.Z < MinHeight + APC.MyAlicePawn.CylinderComponent.CollisionHeight * 0.5;
    return bResult;
}

simulated event PawnEnteredVolume(Pawn P)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(P.Controller);
    if (APC != none && IsEnterFromBottom(APC))
    {
        HoverDuration = 0.0;
        AccumHoverDelay = 0.0;
        APC.SteamVentVolume = self;
        APC.MyAlicePawn.SetPhysics(20);
        APC.MyAlicePawn.TriggerDressPhysic(true, 1.0);
        APC.GotoState('PlayerSteamVent');
        PawnEnterZSpeed = APC.MyAlicePawn.Velocity.Z;
        APC.MyAlicePawn.bFloatAfterHover = false;
        APC.MyAlicePawn.bIsJumping = false;
        APC.MyAlicePawn.bAfterHoverJump = false;
        APC.MyAlicePawn.bJustLeaveSteam = false;
        APC.CycleFloatManager.Init();
        LogInternal("======== Enter Hover VelocityZ: " $ string(PawnEnterZSpeed) $ "========");
    }
}

defaultproperties
{
    SteamVentForwardSpeed=500.0
    SteamVentStrafeSpeed=500.0
    SteamVentRotationSpeed=400.0
    SteamVentUpSpeed=1000.0
    SteamVentTopZoneHeight=99999.0
    SteamVent2ndZoneHeight=300.0
    ForceFloatDuration=1.5
    SteamVentUpAccel=350.0
    DelayCameraTimeWhenLeave=1.0
    HoverDelayTime=1.0
    HoverAmplitude=300.0
    HoverCycleTime=3.0
    Force=(X=0.0,Y=0.0,Z=2000.0)
    PerturbAmplitude=(X=500.0,Y=500.0,Z=1500.0)
    ZoneVelocity=(X=0.0,Y=0.0,Z=30.0)
    BrushComponent="Default__AliceHoverVolume.BrushComponent0"
    Components(0)="Default__AliceHoverVolume.BrushComponent0"
    CollisionComponent="Default__AliceHoverVolume.BrushComponent0"
}
