class SVehicle extends Vehicle
    abstract
    native
    nativereplication
    placeable
    config(Game)
    hidecategories(Navigation);

struct native VehicleState
{
    var RigidBodyState RBState;
    var byte ServerBrake;
    var byte ServerGas;
    var byte ServerSteering;
    var byte ServerRise;
    var bool bServerHandbrake;
    var int ServerView;
};

var() const export editinline noclear SVehicleSimBase SimObj;
var() export editinline array<SVehicleWheel> Wheels;
var() Vector COMOffset;
var() Vector InertiaTensorMultiplier;
var(UprightConstraint) bool bStayUpright;
var bool bUseSuspensionAxis;
var bool bUpdateWheelShapes;
var const bool bVehicleOnGround;
var const bool bVehicleOnWater;
var const bool bIsInverted;
var const bool bChassisTouchingGround;
var const bool bWasChassisTouchingGroundLastTick;
var bool bCanFlip;
var bool bFlipRight;
var bool bIsUprighting;
var bool bOutputHandbrake;
var bool bHoldingDownHandbrake;
var(UprightConstraint) float StayUprightRollResistAngle;
var(UprightConstraint) float StayUprightPitchResistAngle;
var(UprightConstraint) float StayUprightStiffness;
var(UprightConstraint) float StayUprightDamping;
var export editinline RB_StayUprightSetup StayUprightConstraintSetup;
var export editinline RB_ConstraintInstance StayUprightConstraintInstance;
var float HeavySuspensionShiftPercent;
var() repretry float MaxSpeed;
var() float MaxAngularVelocity;
var const float TimeOffGround;
var(Uprighting) float UprightLiftStrength;
var(Uprighting) float UprightTorqueStrength;
var(Uprighting) float UprightTime;
var float UprightStartTime;
var(Sounds) const export editconst editinline AudioComponent EngineSound;
var(Sounds) const export editconst editinline AudioComponent SquealSound;
var(Sounds) SoundCue CollisionSound;
var(Sounds) SoundCue EnterVehicleSound;
var(Sounds) SoundCue ExitVehicleSound;
var(Sounds) float CollisionIntervalSecs;
var(Sounds) const float SquealThreshold;
var(Sounds) const float SquealLatThreshold;
var(Sounds) const float LatAngleVolumeMult;
var(Sounds) const float EngineStartOffsetSecs;
var(Sounds) const float EngineStopOffsetSecs;
var float LastCollisionSoundTime;
var float OutputBrake;
var float OutputGas;
var float OutputSteering;
var float OutputRise;
var float ForwardVel;
var int NumPoweredWheels;
var() Vector BaseOffset;
var() float CamDist;
var int DriverViewPitch;
var int DriverViewYaw;
var const native repretry VehicleState VState;
var const native float AngErrorAccumulator;
var float RadialImpulseScaling;

replication
{
    if (Physics == 10)
        MaxSpeed, VState;
}

simulated function SetAllWheelParticleSystem(ParticleSystem NewSystem)
{
    local int I;
    
    for (I = 0; I < Wheels.Length; I++)
    {
        if (Wheels[I].WheelParticleComp != none)
        {
            Wheels[I].WheelParticleComp.SetTemplate(NewSystem);
        }
    }
}

simulated function GetSVehicleDebug(out array<string> DebugInfo)
{
    DebugInfo[DebugInfo.Length] = "----Vehicle----: ";
    DebugInfo[DebugInfo.Length] = "Speed: " $ string(VSize(Velocity)) $ " Unreal -- " $ string(VSize(Velocity) * 0.0426125) $ " MPH";
    if (Wheels.Length > 0)
    {
        DebugInfo[DebugInfo.Length] = "MotorTorque: " $ string(Wheels[0].MotorTorque);
    }
    DebugInfo[DebugInfo.Length] = "Throttle: " $ string(OutputGas);
    DebugInfo[DebugInfo.Length] = "Brake: " $ string(OutputBrake);
}

simulated function float HermiteEval(float Slip)
{
    local float LatExtremumSlip, LatExtremumValue, LatAsymptoteSlip, LatAsymptoteValue, SlipSquared, SlipCubed, C0, C1, C3;
    
    LatExtremumSlip = SimObj.WheelLatExtremumSlip;
    LatExtremumValue = SimObj.WheelLatExtremumValue;
    LatAsymptoteSlip = SimObj.WheelLatAsymptoteSlip;
    LatAsymptoteValue = SimObj.WheelLatAsymptoteValue;
    if (Slip < LatExtremumSlip)
    {
        Slip /= LatExtremumSlip;
        SlipSquared = Slip * Slip;
        SlipCubed = SlipSquared * Slip;
        C3 = -2.0 * SlipCubed + 3.0 * SlipSquared;
        C1 = SlipCubed - 2.0 * SlipSquared + Slip;
        return (C1 + C3) * LatExtremumValue;
    }
    else if (Slip > LatAsymptoteSlip)
    {
        return LatAsymptoteValue;
    }
    else
    {
        Slip /= LatAsymptoteSlip - LatExtremumSlip;
        Slip -= LatExtremumSlip;
        SlipSquared = Slip * Slip;
        SlipCubed = SlipSquared * Slip;
        C3 = -2.0 * SlipCubed + 3.0 * SlipSquared;
        C0 = 2.0 * SlipCubed - 3.0 * SlipSquared + 1.0;
        return C0 * LatExtremumValue + C3 * LatAsymptoteValue;
    }
}

simulated function DisplayWheelsDebug(HUD HUD, float YL)
{
    local int I, J;
    local Vector WorldLoc, ScreenLoc, X, Y, Z;
    local Color SaveColor;
    local float LastForceValue, GraphScale, ForceValue;
    local Vector ForceValueLoc;
    
    if (SimObj == none)
    {
        return;
    }
    GraphScale = 100.0;
    SaveColor = HUD.Canvas.DrawColor;
    for (I = 0; I < Wheels.Length; I++)
    {
        GetAxes(Rotation, X, Y, Z);
        WorldLoc = Location + (Wheels[I].WheelPosition >> Rotation);
        ScreenLoc = HUD.Canvas.Project(WorldLoc);
        if (ScreenLoc.X >= float(0) && ScreenLoc.X < HUD.Canvas.ClipX && ScreenLoc.Y >= float(0) && ScreenLoc.Y < HUD.Canvas.ClipY)
        {
            HUD.Canvas.DrawColor = MakeColor(255, 255, 255, 255);
            HUD.Draw2DLine(int(ScreenLoc.X), int(ScreenLoc.Y), int(ScreenLoc.X + GraphScale), int(ScreenLoc.Y), MakeColor(0, 0, 255, 255));
            HUD.Canvas.SetPos(ScreenLoc.X + GraphScale, ScreenLoc.Y);
            HUD.Canvas.DrawText(string(3.1415927 * 0.5));
            HUD.Draw2DLine(int(ScreenLoc.X), int(ScreenLoc.Y), int(ScreenLoc.X), int(ScreenLoc.Y - GraphScale), MakeColor(0, 0, 255, 255));
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y - GraphScale);
            HUD.Canvas.DrawText(string(SimObj.WheelLatExtremumValue));
            LastForceValue = 0.0;
            for (J = 0; float(J) <= GraphScale; J++)
            {
                ForceValue = HermiteEval(float(J) * (3.1415927 * 0.5 / GraphScale));
                ForceValue = ForceValue / SimObj.WheelLatExtremumValue * GraphScale;
                HUD.Draw2DLine(int(ScreenLoc.X + float(J - 1)), int(ScreenLoc.Y - LastForceValue), int(ScreenLoc.X + float(J)), int(ScreenLoc.Y - ForceValue), MakeColor(0, 255, 0, 255));
                LastForceValue = ForceValue;
            }
            ForceValue = HermiteEval(Abs(Wheels[I].LatSlipAngle));
            ForceValueLoc.X = ScreenLoc.X + Abs(Wheels[I].LatSlipAngle) / (3.1415927 * 0.5) * GraphScale;
            ForceValueLoc.Y = ScreenLoc.Y - ForceValue / SimObj.WheelLatExtremumValue * GraphScale;
            HUD.Draw2DLine(int(ForceValueLoc.X - float(5)), int(ForceValueLoc.Y), int(ForceValueLoc.X + float(5)), int(ForceValueLoc.Y), MakeColor(255, 0, 0, 255));
            HUD.Draw2DLine(int(ForceValueLoc.X), int(ForceValueLoc.Y - float(5)), int(ForceValueLoc.X), int(ForceValueLoc.Y + float(5)), MakeColor(255, 0, 0, 255));
            HUD.Canvas.SetPos(ScreenLoc.X, ForceValueLoc.Y);
            HUD.Canvas.DrawText(string(ForceValue));
            HUD.Canvas.SetPos(ForceValueLoc.X, ScreenLoc.Y + YL);
            HUD.Canvas.DrawText(string(Wheels[I].LatSlipAngle));
        }
    }
    HUD.Canvas.DrawColor = SaveColor;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local array<string> DebugInfo;
    local int I;
    
    DisplayDebug(HUD, out_YL, out_YPos);
    GetSVehicleDebug(DebugInfo);
    HUD.Canvas.SetDrawColor(0, 255, 0);
    for (I = 0; I < DebugInfo.Length; I++)
    {
        HUD.Canvas.DrawText("  " @ DebugInfo[I]);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0, out_YPos);
    }
}

function PostTeleport(Teleporter OutTeleporter)
{
    Mesh.SetRBPosition(Location);
}

simulated event SuspensionHeavyShift(float Delta)
{
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, out const CollisionImpactData RigidCollisionData, int ContactIndex)
{
    if (CollisionSound != none && WorldInfo.TimeSeconds - LastCollisionSoundTime > CollisionIntervalSecs)
    {
        PlaySound(CollisionSound, true);
        LastCollisionSoundTime = WorldInfo.TimeSeconds;
    }
}

simulated function DrivingStatusChanged()
{
    bUpdateWheelShapes = true;
    if (bDriving)
    {
        VehiclePlayEnterSound();
    }
    else if (Health > 0)
    {
        VehiclePlayExitSound();
    }
}

simulated function VehiclePlayExitSound()
{
    if (ExitVehicleSound != none)
    {
        PlaySound(ExitVehicleSound);
    }
    StopEngineSoundTimed();
}

simulated function VehiclePlayEnterSound()
{
    if (EnterVehicleSound != none)
    {
        PlaySound(EnterVehicleSound);
    }
    StartEngineSoundTimed();
}

simulated function StopEngineSoundTimed()
{
    if (EngineStopOffsetSecs > 0.0)
    {
        ClearTimer('StartEngineSound');
        SetTimer(EngineStopOffsetSecs, false, 'StopEngineSound');
    }
    else
    {
        StopEngineSound();
    }
}

simulated function StopEngineSound()
{
    if (EngineSound != none)
    {
        EngineSound.Stop();
    }
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
}

simulated function StartEngineSoundTimed()
{
    if (EngineStartOffsetSecs > 0.0)
    {
        ClearTimer('StopEngineSound');
        SetTimer(EngineStartOffsetSecs, false, 'StartEngineSound');
    }
    else
    {
        StartEngineSound();
    }
}

simulated function StartEngineSound()
{
    if (EngineSound != none)
    {
        EngineSound.Play();
    }
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
}

native simulated function bool HasWheelsOnGround()
{
}

function bool TryToDrive(Pawn P)
{
    if (bIsInverted && !bVehicleOnGround && VSize(Velocity) <= 0.1)
    {
        if (bCanFlip)
        {
            bIsUprighting = true;
            UprightStartTime = WorldInfo.TimeSeconds;
        }
        return false;
    }
    return TryToDrive(P);
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    return 'Default';
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector pos, HitLocation, HitNormal;
    
    GetActorEyesViewPoint(out_CamLoc, out_CamRot);
    out_CamLoc += BaseOffset;
    pos = out_CamLoc - vector(out_CamRot) * CamDist;
    if (Trace(HitLocation, HitNormal, pos, out_CamLoc, false, vect(0.0, 0.0, 0.0)) != none)
    {
        out_CamLoc = HitLocation + HitNormal * float(2);
    }
    else
    {
        out_CamLoc = pos;
    }
    return true;
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    if (Died(Killer, DamageType, HitLocation))
    {
        bDriving = false;
        AddVelocity(TearOffMomentum, HitLocation, DamageType);
        return true;
    }
    return false;
}

function AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    if (!IsZero(NewVelocity))
    {
        NewVelocity = RadialImpulseScaling * MomentumMult * DamageType.default.default.VehicleMomentumScaling * DamageType.default.default.KDamageImpulse * Normal(NewVelocity);
        if (!bIgnoreForces && !IsZero(NewVelocity))
        {
            if (Location.Z > WorldInfo.StallZ)
            {
                NewVelocity.Z = FMin(NewVelocity.Z, 0.0);
            }
            if (InGodMode())
            {
                NewVelocity *= 0.25;
            }
            Mesh.AddImpulse(NewVelocity, HitLocation);
        }
    }
    RadialImpulseScaling = 1.0;
}

native function InitVehicleRagdoll(SkeletalMesh RagdollMesh, PhysicsAsset RagdollPhysAsset, Vector ActorMove, bool bClearAnimTree)
{
    RagdollMesh;
    RagdollPhysAsset;
    ActorMove;
    bClearAnimTree;
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    local Vector HitLocation, Dir, NewDir;
    local float Dist, DamageScale;
    local TraceHitInfo HitInfo;
    
    if (Role < 3)
    {
        return;
    }
    HitLocation = Location;
    Dir = Location - HurtOrigin;
    CheckHitInfo(HitInfo, Mesh, Dir, HitLocation);
    NewDir = HitLocation - HurtOrigin;
    Dist = VSize(NewDir);
    if (bFullDamage)
    {
        DamageScale = 1.0;
    }
    else if (Dist > DamageRadius)
    {
        return;
    }
    else
    {
        DamageScale = FMax(0.0, 1.0 - Dist / DamageRadius);
        DamageScale = DamageScale ** DamageFalloffExponent;
    }
    RadialImpulseScaling = DamageScale;
    TakeDamage(int(BaseDamage * DamageScale), InstigatedBy, HitLocation, DamageScale * Momentum * Normal(Dir), DamageType, HitInfo, DamageCauser);
    RadialImpulseScaling = 1.0;
    if (Health > 0)
    {
        DriverRadiusDamage(BaseDamage, DamageRadius, InstigatedBy, DamageType, Momentum, HurtOrigin, DamageCauser);
    }
}

simulated function StopVehicleSounds()
{
    if (EngineSound != none)
    {
        EngineSound.Stop();
    }
    if (SquealSound != none)
    {
        SquealSound.Stop();
    }
}

simulated function TurnOff()
{
    TurnOff();
    StopVehicleSounds();
}

simulated event Destroyed()
{
    Destroyed();
    StopVehicleSounds();
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local int WheelIndex;
    local SVehicleWheel Wheel;
    
    PostInitAnimTree(SkelComp);
    if (SkelComp == Mesh)
    {
        for (WheelIndex = 0; WheelIndex < Wheels.Length; WheelIndex++)
        {
            Wheel = Wheels[WheelIndex];
            Wheel.WheelControl = SkelControlWheel(Mesh.FindSkelControl(Wheel.SkelControlName));
        }
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (EngineSound != none)
    {
        EngineSound.bShouldRemainActiveIfDropped = true;
    }
    if (CollisionSound != none && CollisionIntervalSecs <= 0.0)
    {
        CollisionIntervalSecs = CollisionSound.GetCueDuration() / WorldInfo.TimeDilation;
    }
}

native final function SetWheelCollision(int WheelNum, bool bCollision)
{
    WheelNum;
    bCollision;
}

native function bool IsSleeping()
{
}

native function AddTorque(Vector Torque)
{
    Torque;
}

native function AddImpulse(Vector Impulse)
{
    Impulse;
}

native function AddForce(Vector Force)
{
    Force;
}

defaultproperties
{
    InertiaTensorMultiplier=(X=1.0,Y=1.0,Z=1.0)
    bCanFlip=True
    StayUprightConstraintSetup="Default__SVehicle.MyStayUprightSetup"
    StayUprightConstraintInstance="Default__SVehicle.MyStayUprightConstraintInstance"
    HeavySuspensionShiftPercent=0.5
    MaxSpeed=2500.0
    MaxAngularVelocity=75000.0
    UprightLiftStrength=225.0
    UprightTorqueStrength=50.0
    UprightTime=1.5
    SquealThreshold=250.0
    SquealLatThreshold=250.0
    LatAngleVolumeMult=1.0
    EngineStartOffsetSecs=2.0
    EngineStopOffsetSecs=1.0
    BaseOffset=(X=0.0,Y=0.0,Z=128.0)
    CamDist=512.0
    RadialImpulseScaling=1.0
    Mesh="Default__SVehicle.SVehicleMesh"
    CylinderComponent="Default__SVehicle.CollisionCylinder"
    bNetInitialRotation=True
    bBlocksTeleport=True
    bEdShouldSnap=True
    Components(0)="Default__SVehicle.CollisionCylinder"
    Components(1)="Default__SVehicle.SVehicleMesh"
    Physics="PHYS_RigidBody"
    TickGroup="TG_PostAsyncWork"
    CollisionComponent="Default__SVehicle.SVehicleMesh"
}
