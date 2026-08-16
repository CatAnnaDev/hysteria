class AliceStuckManager extends Object
    notplaceable
    within AlicePlayerController;

var float stuckBeginTime;
var float stuckDuration;
var float lastJumpOffTime;
var float stuckThreshold;
var float validBaseChangedTime;
var bool bIsStucking;
var bool bLastIsStucking;

function doStuckJump()
{
    local float OldVelocityZ;
    
    Outer.MyAlicePawn.PendingVelocity = Outer.MyAlicePawn.Velocity;
    OldVelocityZ = Outer.MyAlicePawn.Velocity.Z;
    Outer.MyAlicePawn.PendingVelocity.Z = Sqrt(4.0 * Outer.MyAlicePawn.JumpZ * Abs(Outer.MyAlicePawn.GetGravityZ()));
    Outer.MyAlicePawn.Velocity = vect(0.0, 0.0, 0.0);
    Outer.MyAlicePawn.bIsDoubleJumping = true;
    if (!Outer.MyAlicePawn.DoSpecialMove(3, true))
    {
        Outer.MyAlicePawn.Velocity = Outer.MyAlicePawn.PendingVelocity;
        Outer.MyAlicePawn.Velocity.Z = OldVelocityZ;
        Outer.MyAlicePawn.PendingVelocity = vect(0.0, 0.0, 0.0);
    }
}

function nonStuckNotify()
{
}

function stuckNotify()
{
    doStuckJump();
    clearStuckFlag();
}

function float getCurrentTime()
{
    return Outer.WorldInfo.TimeSeconds;
}

function bool isFirstJumpOff()
{
    return lastJumpOffTime < float(0);
}

function clearStuckFlag()
{
    bIsStucking = false;
}

function bool isStucking()
{
    return bIsStucking;
}

function updateStuckDuration()
{
    stuckDuration = getCurrentTime() - stuckBeginTime;
}

function updateStuckBeginTime()
{
    if (isFirstJumpOff())
    {
        stuckBeginTime = getCurrentTime();
    }
    else if (validBaseChangedTime > lastJumpOffTime)
    {
        stuckBeginTime = getCurrentTime();
    }
}

function detectStuck()
{
    bIsStucking = stuckDuration > stuckThreshold;
    if (!bLastIsStucking && bIsStucking)
    {
        stuckNotify();
    }
    else if (bLastIsStucking && !bIsStucking)
    {
        nonStuckNotify();
    }
    bLastIsStucking = bIsStucking;
}

function onBaseChange(bool bChanged)
{
    if (bChanged)
    {
        validBaseChangedTime = getCurrentTime();
        clearStuckFlag();
    }
}

function onJumpOffPawn()
{
    updateStuckBeginTime();
    updateStuckDuration();
    detectStuck();
    lastJumpOffTime = getCurrentTime();
}

defaultproperties
{
    stuckBeginTime=-1.0
    lastJumpOffTime=-1.0
    stuckThreshold=0.1
}
