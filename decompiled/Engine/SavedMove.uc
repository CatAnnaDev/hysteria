class SavedMove extends Object
    native
    notplaceable;

var SavedMove NextMove;
var float TimeStamp;
var float Delta;
var bool bRun;
var bool bDuck;
var bool bPressedJump;
var bool bDoubleJump;
var bool bPreciseDestination;
var bool bForceRMVelocity;
var bool bForceMaxAccel;
var bool bRootMotionFromInterpCurve;
var EDoubleClickDir DoubleClickMove;
var EPhysics SavedPhysics;
var ERootMotionMode RootMotionMode;
var Vector StartLocation;
var Vector StartRelativeLocation;
var Vector StartVelocity;
var Vector StartFloor;
var Vector SavedLocation;
var Vector SavedVelocity;
var Vector SavedRelativeLocation;
var Vector RMVelocity;
var Vector Acceleration;
var Rotator Rotation;
var Actor StartBase;
var Actor EndBase;
var float CustomTimeDilation;
var float AccelDotThreshold;
var float RootMotionInterpCurrentTime;
var Vector RootMotionInterpCurveLastValue;

function string GetDebugString()
{
    local string Str;
    
    Str = string(self) @ "Delta:'" $ string(Delta) $ "'" @ "SavedPhysics:'" $ string(SavedPhysics) $ "'" @ "StartLocation:'" $ string(StartLocation) $ "'" @ "StartVelocity:'" $ string(StartVelocity) $ "'" @ "SavedLocation:'" $ string(SavedLocation) $ "'" @ "SavedVelocity:'" $ string(SavedVelocity) $ "'" @ "RMVelocity:'" $ string(RMVelocity) $ "'" @ "Acceleration:'" $ string(Acceleration) $ "'" @ "bRootMotionFromInterpCurve:'" $ string(bRootMotionFromInterpCurve) $ "'" @ "RootMotionInterpCurrentTime:'" $ string(RootMotionInterpCurrentTime) $ "'";
    return Str;
}

static function EDoubleClickDir SetFlags(byte Flags, PlayerController PC)
{
    if ((int(Flags) & int(8)) != 0)
    {
        PC.bRun = 1;
    }
    else
    {
        PC.bRun = 0;
    }
    if ((int(Flags) & int(16)) != 0)
    {
        PC.bDuck = 1;
    }
    else
    {
        PC.bDuck = 0;
    }
    PC.bPreciseDestination = (int(Flags) & int(128)) != 0;
    PC.bDoubleJump = (int(Flags) & int(64)) != 0;
    PC.bPressedJump = (int(Flags) & int(32)) != 0;
    switch (int(Flags) & int(7))
    {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 4;
            break;
        default:
    }
    return 0;
}

function byte CompressedFlags()
{
    local byte Result;
    
    Result = DoubleClickMove;
    if (bRun)
    {
        Result += 8;
    }
    if (bDuck)
    {
        Result += 16;
    }
    if (bPressedJump)
    {
        Result += 32;
    }
    if (bDoubleJump)
    {
        Result += 64;
    }
    if (bPreciseDestination)
    {
        Result += 128;
    }
    return Result;
}

function ResetMoveFor(Pawn P)
{
    if (P != none)
    {
        SavedLocation = P.Location;
        SavedVelocity = P.Velocity;
        EndBase = P.Base;
        if (EndBase != none && !EndBase.bWorldGeometry)
        {
            SavedRelativeLocation = P.Location - EndBase.Location;
        }
        P.bForceRMVelocity = false;
    }
}

function PrepMoveFor(Pawn P)
{
    if (P != none)
    {
        P.bForceRMVelocity = bForceRMVelocity;
        P.bForceMaxAccel = bForceMaxAccel;
        P.bRootMotionFromInterpCurve = bRootMotionFromInterpCurve;
        if (P.bRootMotionFromInterpCurve)
        {
            P.Mesh.RootMotionMode = RootMotionMode;
            P.RootMotionInterpCurveLastValue = RootMotionInterpCurveLastValue;
            P.SetRootMotionInterpCurrentTime(RootMotionInterpCurrentTime, Delta, true);
        }
    }
}

function SetMoveFor(PlayerController P, float DeltaTime, Vector newAccel, EDoubleClickDir InDoubleClick)
{
    Delta = DeltaTime;
    if (VSize(newAccel) > float(26214))
    {
        newAccel = float(26214) * Normal(newAccel);
    }
    if (P.Pawn != none)
    {
        SetInitialPosition(P.Pawn);
    }
    Acceleration = newAccel;
    DoubleClickMove = InDoubleClick;
    bRun = P.bRun > 0;
    bDuck = P.bDuck > 0;
    bPressedJump = P.bPressedJump;
    bDoubleJump = P.bDoubleJump;
    bPreciseDestination = P.bPreciseDestination;
    bForceRMVelocity = P.bPreciseDestination || P.Pawn != none && P.Pawn.Mesh != none && !P.Pawn.bRootMotionFromInterpCurve && P.Pawn.Mesh.RootMotionMode == 3 || P.Pawn.Mesh.RootMotionMode == 1;
    bForceMaxAccel = P.Pawn != none && P.Pawn.bForceMaxAccel;
    TimeStamp = P.WorldInfo.TimeSeconds;
}

function bool CanCombineWith(SavedMove NewMove, Pawn inPawn, float MaxDelta)
{
    if (inPawn == none)
    {
        return false;
    }
    if (bRootMotionFromInterpCurve)
    {
        return false;
    }
    if (NewMove.Acceleration == vect(0.0, 0.0, 0.0))
    {
        return Acceleration == vect(0.0, 0.0, 0.0) && StartVelocity == vect(0.0, 0.0, 0.0) && NewMove.StartVelocity == vect(0.0, 0.0, 0.0) && SavedPhysics == inPawn.Physics && !bPressedJump && !NewMove.bPressedJump && bRun == NewMove.bRun && bDuck == NewMove.bDuck && bPreciseDestination == NewMove.bPreciseDestination && bDoubleJump == NewMove.bDoubleJump && DoubleClickMove == 0 || DoubleClickMove == 5 && NewMove.DoubleClickMove == DoubleClickMove && !bForceRMVelocity && !NewMove.bForceRMVelocity && CustomTimeDilation == NewMove.CustomTimeDilation;
    }
    else
    {
        return inPawn != none && NewMove.Delta + Delta < MaxDelta && SavedPhysics == inPawn.Physics && !bPressedJump && !NewMove.bPressedJump && bRun == NewMove.bRun && bDuck == NewMove.bDuck && bDoubleJump == NewMove.bDoubleJump && bPreciseDestination == NewMove.bPreciseDestination && DoubleClickMove == 0 || DoubleClickMove == 5 && NewMove.DoubleClickMove == DoubleClickMove && Normal(Acceleration) Dot Normal(NewMove.Acceleration) > 0.99 && !bForceRMVelocity && !NewMove.bForceRMVelocity && CustomTimeDilation == NewMove.CustomTimeDilation;
    }
}

function SetInitialPosition(Pawn P)
{
    SavedPhysics = P.Physics;
    StartLocation = P.Location;
    StartVelocity = P.Velocity;
    StartBase = P.Base;
    StartFloor = P.Floor;
    CustomTimeDilation = P.CustomTimeDilation;
    if (StartBase != none && !StartBase.bWorldGeometry)
    {
        StartRelativeLocation = P.Location - StartBase.Location;
    }
    bRootMotionFromInterpCurve = P.bRootMotionFromInterpCurve;
    if (bRootMotionFromInterpCurve)
    {
        RootMotionInterpCurrentTime = P.RootMotionInterpCurrentTime;
        RootMotionInterpCurveLastValue = P.RootMotionInterpCurveLastValue;
        RootMotionMode = P.Mesh.RootMotionMode;
    }
}

function Vector GetStartLocation()
{
    if (StartBase != none && !StartBase.bWorldGeometry)
    {
        return StartBase.Location + StartRelativeLocation;
    }
    return StartLocation;
}

function bool IsImportantMove(Vector CompareAccel)
{
    local Vector AccelNorm;
    
    if (bPressedJump || bDoubleJump || DoubleClickMove != 0 && DoubleClickMove != 5 && DoubleClickMove != 6)
    {
        return true;
    }
    if (bRootMotionFromInterpCurve)
    {
        return true;
    }
    AccelNorm = Normal(Acceleration);
    return CompareAccel != AccelNorm && CompareAccel Dot AccelNorm < AccelDotThreshold;
}

function PostUpdate(PlayerController P)
{
    bDoubleJump = P.bDoubleJump || bDoubleJump;
    if (P.Pawn != none)
    {
        RMVelocity = P.Pawn.RMVelocity;
        SavedLocation = P.Pawn.Location;
        SavedVelocity = P.Pawn.Velocity;
        EndBase = P.Pawn.Base;
        if (EndBase != none && !EndBase.bWorldGeometry)
        {
            SavedRelativeLocation = P.Pawn.Location - EndBase.Location;
        }
    }
    Rotation = P.Rotation;
}

function Clear()
{
    TimeStamp = 0.0;
    Delta = 0.0;
    DoubleClickMove = 0;
    Acceleration = vect(0.0, 0.0, 0.0);
    StartVelocity = vect(0.0, 0.0, 0.0);
    bRun = false;
    bDuck = false;
    bPressedJump = false;
    bDoubleJump = false;
    bPreciseDestination = false;
    bForceRMVelocity = false;
    CustomTimeDilation = 1.0;
}

defaultproperties
{
    AccelDotThreshold=0.9
}
