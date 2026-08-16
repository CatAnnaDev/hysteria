class Vehicle extends Pawn
    abstract
    native
    nativereplication
    placeable
    config(Game)
    hidecategories(Navigation);

var repnotify Pawn Driver;
var repnotify bool bDriving;
var bool bDriverIsVisible;
var bool bAttachDriver;
var bool bTurnInPlace;
var bool bSeparateTurretFocus;
var bool bFollowLookDir;
var bool bHasHandbrake;
var bool bScriptedRise;
var bool bDuckObstacles;
var bool bAvoidReversing;
var bool bRetryPathfindingWithDriver;
var() bool bIgnoreStallZ;
var bool bDoExtraNetRelevancyTraces;
var() array<Vector> ExitPositions;
var float ExitRadius;
var Vector ExitOffset;
var() float Steering;
var() float Throttle;
var() float Rise;
var Vector TargetLocationAdjustment;
var float DriverDamageMult;
var() float MomentumMult;
var class<DamageType> CrushedDamageType;
var float MinCrushSpeed;
var float ForceCrushPenetration;
var byte StuckCount;
var float ThrottleTime;
var float StuckTime;
var float OldSteering;
var float OnlySteeringStartTime;
var float OldThrottle;
var const float AIMoveCheckTime;
var float VehicleMovingTime;
var float TurnTime;

replication
{
    if (bNetDirty && bNetOwner || Driver == none || !Driver.bHidden && Role == 3)
        Driver;
    if (bNetDirty && Role == 3)
        bDriving;
}

simulated function ZeroMovementVariables()
{
    ZeroMovementVariables();
    Steering = 0.0;
    Rise = 0.0;
    Throttle = 0.0;
}

function NotifyDriverTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bDriving')
    {
        DrivingStatusChanged();
    }
    else if (VarName == 'Driver')
    {
        if (PlayerReplicationInfo != none && Driver != none)
        {
            Driver.NotifyTeamChanged();
        }
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated function DrivingStatusChanged()
{
    if (!bDriving)
    {
        Throttle = 0.0;
        Steering = 0.0;
        Rise = 0.0;
    }
}

function HandleDeadVehicleDriver()
{
}

simulated function SetDriving(bool B)
{
    if (bDriving != B)
    {
        bDriving = B;
        DrivingStatusChanged();
    }
}

simulated event Vector GetEntryLocation()
{
    return Location;
}

function CrushedBy(Pawn OtherPawn)
{
}

function PancakeOther(Pawn Other)
{
    Other.TakeDamage(10000, GetCollisionDamageInstigator(), Other.Location, Velocity * Other.Mass, CrushedDamageType);
}

event bool EncroachingOn(Actor Other)
{
    local Pawn P;
    local Vector PushVelocity, CheckExtent;
    local bool bSlowEncroach, bDeepEncroach;
    
    P = Pawn(Other);
    if (P == none)
    {
        return false;
    }
    bSlowEncroach = VSize(Velocity) < MinCrushSpeed;
    if (bSlowEncroach)
    {
        CheckExtent.X = P.CylinderComponent.CollisionRadius - ForceCrushPenetration;
        CheckExtent.Y = CheckExtent.X;
        CheckExtent.Z = P.CylinderComponent.CollisionHeight - ForceCrushPenetration;
        bDeepEncroach = PointCheckComponent(CollisionComponent, P.Location, CheckExtent);
    }
    if (Other == Instigator && !bDeepEncroach || Vehicle(Other) != none || Other.Role != 3 || !Other.bCollideActors && !Other.bBlockActors || bSlowEncroach && !bDeepEncroach)
    {
        if (P.Velocity Dot (Location - P.Location) > float(0))
        {
            PushVelocity = Normal(P.Location - Location) * float(200);
            PushVelocity.Z = 100.0;
            P.AddVelocity(PushVelocity, Location, CrushedDamageType);
        }
        return false;
    }
    if (P.Base == self)
    {
        RanInto(P);
        if (P.Base != none)
        {
            P.JumpOffPawn();
        }
        if (P.Base == none)
        {
            return false;
        }
    }
    PancakeOther(P);
    return false;
}

function Controller GetCollisionDamageInstigator()
{
    if (Controller != none)
    {
        return Controller;
    }
    else
    {
        return Instigator != none ? Instigator.Controller : none;
    }
}

event EncroachedBy(Actor Other)
{
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    if (RequestedBy != none && RequestedBy.PlayerCamera != none && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
    {
        return 'Fixed';
    }
    return 'ThirdPerson';
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
}

function DriverDied(class<DamageType> DamageType)
{
    local Controller C;
    local PlayerReplicationInfo RealPRI;
    
    if (Driver == none)
    {
        return;
    }
    WorldInfo.Game.DiscardInventory(Driver);
    C = Controller;
    Driver.StopDriving(self);
    Driver.Controller = C;
    Driver.DrivenVehicle = self;
    if (Controller == none)
    {
        return;
    }
    if (PlayerController(Controller) != none)
    {
        Controller.SetLocation(Location);
        PlayerController(Controller).SetViewTarget(Driver);
        PlayerController(Controller).ClientSetViewTarget(Driver);
    }
    Controller.UnPossess();
    if (Controller == C)
    {
        Controller = none;
    }
    C.Pawn = Driver;
    RealPRI = Driver.PlayerReplicationInfo;
    if (RealPRI == none)
    {
        Driver.PlayerReplicationInfo = C.PlayerReplicationInfo;
    }
    WorldInfo.Game.DriverLeftVehicle(self, Driver);
    Driver.PlayerReplicationInfo = RealPRI;
    DriverLeft();
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    if (Died(Killer, DamageType, HitLocation))
    {
        SetDriving(false);
        return true;
    }
    else
    {
        return false;
    }
}

function ThrowActiveWeapon()
{
}

function AdjustDriverDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
    if (InGodMode())
    {
        Damage = 0;
    }
    else if (!DamageType.default.default.bIgnoreDriverDamageMult)
    {
        Damage *= DriverDamageMult;
    }
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    bForceNetUpdate = true;
    if (DamageType != none)
    {
        Damage *= DamageType.static.VehicleDamageScalingFor(self);
        Momentum *= DamageType.default.default.VehicleMomentumScaling * MomentumMult;
    }
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

function Controller SetKillInstigator(Controller InstigatedBy, class<DamageType> DamageType)
{
    return InstigatedBy;
}

function UnPossessed()
{
    NetPriority = default.NetPriority;
    bForceNetUpdate = true;
    NetUpdateFrequency = 8.0;
    UnPossessed();
}

function bool TryExitPos(Pawn ExitingDriver, Vector ExitPos, bool bMustFindGround)
{
    local Vector Slice, HitLocation, HitNormal, StartLocation, NewActorPos;
    local Actor HitActor;
    
    Slice = ExitingDriver.GetCollisionRadius() * vect(1.0, 1.0, 0.0);
    Slice.Z = 2.0;
    StartLocation = GetTargetLocation();
    if (Trace(HitLocation, HitNormal, ExitPos, StartLocation, false, Slice) != none)
    {
        return false;
    }
    HitActor = Trace(HitLocation, HitNormal, ExitPos - ExitingDriver.GetCollisionHeight() * vect(0.0, 0.0, 5.0), ExitPos, true, Slice);
    if (HitActor == none)
    {
        if (bMustFindGround)
        {
            return false;
        }
        HitLocation = ExitPos;
    }
    NewActorPos = HitLocation + (ExitingDriver.GetCollisionHeight() + ExitingDriver.MaxStepHeight) * vect(0.0, 0.0, 1.0);
    if (PointCheckComponent(Mesh, NewActorPos, ExitingDriver.GetCollisionExtent()))
    {
        return false;
    }
    return ExitingDriver.SetLocation(NewActorPos);
}

function bool FindAutoExit(Pawn ExitingDriver)
{
    local Vector FacingDir, CrossProduct;
    local float PlaceDist;
    
    FacingDir = vector(Rotation);
    CrossProduct = Normal(FacingDir Cross vect(0.0, 0.0, 1.0));
    if (ExitRadius == float(0))
    {
        ExitRadius = GetCollisionRadius() + ExitingDriver.VehicleCheckRadius;
    }
    PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();
    return TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset + PlaceDist * CrossProduct, false) || TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset - PlaceDist * CrossProduct, false) || TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset - PlaceDist * FacingDir, false) || TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset + PlaceDist * FacingDir, false);
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    local int I;
    local Vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;
    
    if (ExitingDriver == none)
    {
        ExitingDriver = Driver;
    }
    if (ExitingDriver == none)
    {
        return false;
    }
    Extent = ExitingDriver.GetCollisionRadius() * vect(1.0, 1.0, 0.0);
    Extent.Z = ExitingDriver.GetCollisionHeight();
    ZOffset = Extent.Z * vect(0.0, 0.0, 1.0);
    if (ExitPositions.Length > 0)
    {
        for (I = 0; I < ExitPositions.Length; I++)
        {
            if (ExitPositions[0].Z != float(0))
            {
                ZOffset = vect(0.0, 0.0, 1.0) * ExitPositions[0].Z;
            }
            else
            {
                ZOffset = ExitingDriver.CylinderComponent.default.CollisionHeight * vect(0.0, 0.0, 2.0);
            }
            tryPlace = Location + (ExitPositions[I] - ZOffset >> Rotation) + ZOffset;
            if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
            {
                continue;
            }
            if (!ExitingDriver.SetLocation(tryPlace))
            {
                continue;
            }
            return true;
        }
    }
    else
    {
        return FindAutoExit(ExitingDriver);
    }
    return false;
}

function DriverLeft()
{
    Driver = none;
    SetDriving(false);
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    Throttle = InForward;
    Steering = InStrafe;
    Rise = InUp;
}

event bool DriverLeave(bool bForceLeave)
{
    local Controller C;
    local PlayerController PC;
    local Rotator ExitRotation;
    
    if (Role < 3)
    {
        WarnInternal("DriverLeave() called on client");
        ScriptTrace();
        return false;
    }
    if (!bForceLeave && !WorldInfo.Game.CanLeaveVehicle(self, Driver))
    {
        return false;
    }
    if (Controller == none)
    {
        return false;
    }
    if (Driver != none)
    {
        Driver.SetHardAttach(false);
        Driver.bCollideWorld = true;
        Driver.SetCollision(true, true);
        if (!PlaceExitingDriver())
        {
            if (!bForceLeave)
            {
                Driver.SetHardAttach(true);
                Driver.bCollideWorld = false;
                Driver.SetCollision(false, false);
                return false;
            }
            else
            {
                Driver.SetLocation(GetTargetLocation());
            }
        }
    }
    ExitRotation = GetExitRotation(Controller);
    SetDriving(false);
    C = Controller;
    if (C.RouteGoal == self)
    {
        C.RouteGoal = none;
    }
    if (C.MoveTarget == self)
    {
        C.MoveTarget = none;
    }
    Controller.UnPossess();
    if (Driver != none && Driver.Health > 0)
    {
        Driver.SetRotation(ExitRotation);
        Driver.SetOwner(C);
        C.Possess(Driver, true);
        PC = PlayerController(C);
        if (PC != none)
        {
            PC.ClientSetViewTarget(Driver);
        }
        Driver.StopDriving(self);
    }
    if (C == Controller)
    {
        Controller = none;
    }
    WorldInfo.Game.DriverLeftVehicle(self, Driver);
    DriverLeft();
    return true;
}

function Rotator GetExitRotation(Controller C)
{
    local Rotator Rot;
    
    Rot.Yaw = Controller.Rotation.Yaw;
    return Rot;
}

event bool ContinueOnFoot()
{
    if (AIController(Controller) != none)
    {
        return DriverLeave(false);
    }
    else
    {
        return false;
    }
}

simulated function DetachDriver(Pawn P)
{
}

simulated function AttachDriver(Pawn P)
{
    if (!bAttachDriver)
    {
        return;
    }
    P.SetCollision(false, false);
    P.bCollideWorld = false;
    P.SetBase(none);
    P.SetHardAttach(true);
    P.SetPhysics(0);
    if (P.Mesh != none && Mesh != none)
    {
        P.Mesh.SetShadowParent(Mesh);
    }
    if (!bDriverIsVisible)
    {
        P.SetHidden(true);
        P.SetLocation(Location);
    }
    P.SetBase(self);
    P.SetPhysics(0);
}

function EntryAnnouncement(Controller C)
{
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    PossessedBy(C, bVehicleTransition);
    EntryAnnouncement(C);
    NetPriority = 3.0;
    NetUpdateFrequency = 100.0;
    ThrottleTime = WorldInfo.TimeSeconds;
    OnlySteeringStartTime = WorldInfo.TimeSeconds;
}

function bool DriverEnter(Pawn P)
{
    local Controller C;
    
    C = P.Controller;
    Driver = P;
    Driver.StartDriving(self);
    if (Driver.Health <= 0)
    {
        Driver = none;
        return false;
    }
    SetDriving(true);
    C.UnPossess();
    Driver.SetOwner(self);
    C.Possess(self, true);
    if (PlayerController(C) != none)
    {
        PlayerController(C).GotoState(LandMovementState);
    }
    WorldInfo.Game.DriverEnteredVehicle(self, P);
    return true;
}

function bool TryToDrive(Pawn P)
{
    if (!CanEnterVehicle(P))
    {
        return false;
    }
    return DriverEnter(P);
}

function bool AnySeatAvailable()
{
    return Driver == none;
}

function bool CanEnterVehicle(Pawn P)
{
    return !bDeleteMe && AnySeatAvailable() && !bAttachDriver || !P.bIsCrouched && P.DrivenVehicle == none && P.Controller != none && P.Controller.bIsPlayer && !P.IsA('Vehicle') && Health > 0;
}

simulated function Destroyed_HandleDriver()
{
    local Pawn OldDriver;
    
    Driver.LastRenderTime = LastRenderTime;
    if (Role == 3)
    {
        OldDriver = Driver;
        Driver = none;
        OldDriver.DrivenVehicle = none;
        OldDriver.Destroy();
    }
    else if (Driver.DrivenVehicle == self)
    {
        Driver.StopDriving(self);
    }
}

simulated event Destroyed()
{
    if (Driver != none)
    {
        Destroyed_HandleDriver();
    }
    Destroyed();
}

function bool CheatFly()
{
    return false;
}

function bool CheatGhost()
{
    return false;
}

function bool CheatWalk()
{
    return false;
}

event PostBeginPlay()
{
    PostBeginPlay();
    if (!bDeleteMe)
    {
        AddDefaultInventory();
    }
}

simulated function SetBaseEyeheight()
{
    BaseEyeHeight = default.BaseEyeHeight;
    EyeHeight = BaseEyeHeight;
}

function PlayerChangedTeam()
{
    if (Driver != none)
    {
        Driver.KilledBy(Driver);
    }
    else
    {
        PlayerChangedTeam();
    }
}

function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, Vector HitLocation, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    if (EventInstigator != none && Driver != none && bAttachDriver && !Driver.bCollideActors && !Driver.bBlockActors)
    {
        Driver.TakeRadiusDamage(EventInstigator, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation, false, DamageCauser, DamageFalloffExponent);
    }
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    if (Role == 3)
    {
        TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
        if (Health > 0)
        {
            DriverRadiusDamage(BaseDamage, DamageRadius, InstigatedBy, DamageType, Momentum, HurtOrigin, DamageCauser);
        }
    }
}

native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc)
{
    RequestedBy;
    bRequestAlternateLoc;
}

native function float GetMaxRiseForce()
{
}

function Suicide()
{
    if (Driver != none)
    {
        Driver.KilledBy(Driver);
    }
    else
    {
        KilledBy(self);
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string DriverText;
    
    DisplayDebug(HUD, out_YL, out_YPos);
    HUD.Canvas.SetDrawColor(255, 255, 255);
    HUD.Canvas.DrawText("Steering " $ string(Steering) $ " throttle " $ string(Throttle) $ " rise " $ string(Rise));
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
    HUD.Canvas.SetDrawColor(255, 0, 0);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
    if (Driver == none)
    {
        DriverText = "NO DRIVER";
    }
    else
    {
        DriverText = "Driver Mesh " $ string(Driver.Mesh) $ " hidden " $ string(Driver.bHidden);
    }
    HUD.Canvas.DrawText(DriverText);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
}

simulated function NotifyTeamChanged()
{
    if (PlayerReplicationInfo != none && Driver != none)
    {
        Driver.NotifyTeamChanged();
    }
}

defaultproperties
{
    bAttachDriver=True
    bRetryPathfindingWithDriver=True
    bDoExtraNetRelevancyTraces=True
    MomentumMult=1.0
    CrushedDamageType="DmgType_Crushed"
    MinCrushSpeed=20.0
    ForceCrushPenetration=10.0
    TurnTime=2.0
    bCanBeBaseForPawns=True
    bDontPossess=True
    bPathfindsAsVehicle=True
    LandMovementState="PlayerDriving"
    CylinderComponent="Default__Vehicle.CollisionCylinder"
    Components(0)="Default__Vehicle.CollisionCylinder"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Vehicle.CollisionCylinder"
}
