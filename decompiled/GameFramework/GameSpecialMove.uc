class GameSpecialMove extends Object
    abstract
    native
    notplaceable
    config(Pawn);

var GamePawn PawnOwner;
var name Handle;
var transient float LastCanDoSpecialMoveTime;
var bool bLastCanDoSpecialMove;
var const bool bReachPreciseDestination;
var const bool bReachedPreciseDestination;
var const bool bReachPreciseRotation;
var const bool bReachedPreciseRotation;
var bool bForcePrecisePosition;
var const Vector PreciseDestination;
var const Actor PreciseDestBase;
var const Vector PreciseDestRelOffset;
var const float PreciseRotationInterpolationTime;
var const Rotator PreciseRotation;

native final function Vector RelativeToWorldOffset(Rotator InRotation, Vector RelativeSpaceOffset)
{
    InRotation;
    RelativeSpaceOffset;
}

native final function Vector WorldToRelativeOffset(Rotator InRotation, Vector WorldSpaceOffset)
{
    InRotation;
    WorldSpaceOffset;
}

native final function ForcePawnRotation(Pawn P, Rotator NewRotation)
{
    P;
    NewRotation;
}

function bool MessageEvent(name EventName, Object Sender)
{
    LogInternal(string(PawnOwner.WorldInfo.TimeSeconds) @ string(PawnOwner) @ string(Class) @ string(GetFuncName()) @ "Received unhandled event!" @ string(EventName) @ "from:" @ string(Sender));
    ScriptTrace();
    return false;
}

native final function ResetFacePreciseRotation()
{
}

event ReachedPrecisePosition()
{
}

native final function SetFacePreciseRotation(Rotator RotationToFace, float InterpolationTime)
{
    RotationToFace;
    InterpolationTime;
}

native final function SetReachPreciseDestination(Vector DestinationToReach, optional bool bCancel)
{
    DestinationToReach;
    bCancel;
}

function bool ShouldReplicate()
{
    return true;
}

function SpecialMoveFlagsUpdated()
{
}

function Tick(float DeltaTime)
{
}

function SpecialMoveEnded(name PrevMove, name NextMove)
{
}

function SpecialMoveStarted(bool bForced, name PrevMove)
{
}

protected function bool InternalCanDoSpecialMove()
{
    return true;
}

final function bool CanDoSpecialMove(optional bool bForceCheck)
{
    if (PawnOwner != none)
    {
        if (bForceCheck || PawnOwner.WorldInfo.TimeSeconds != LastCanDoSpecialMoveTime)
        {
            bLastCanDoSpecialMove = InternalCanDoSpecialMove();
            LastCanDoSpecialMoveTime = PawnOwner.WorldInfo.TimeSeconds;
        }
        return bLastCanDoSpecialMove;
    }
    return false;
}

function bool CanOverrideSpecialMove(name InMove)
{
    return false;
}

function bool CanOverrideMoveWith(name NewMove)
{
    return false;
}

function bool CanChainMove(name NextMove)
{
    return false;
}

function ExtractSpecialMoveFlags(int Flags)
{
}

function InitSpecialMoveFlags(out int out_Flags)
{
}

function InitSpecialMove(GamePawn inPawn, name InHandle)
{
    PawnOwner = inPawn;
    Handle = InHandle;
}

defaultproperties
{
}
