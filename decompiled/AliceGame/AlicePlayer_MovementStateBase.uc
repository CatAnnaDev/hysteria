class AlicePlayer_MovementStateBase extends Object
    native
    notplaceable;

var transient AlicePlayerInput Input;
var transient AlicePlayerController Controller;
var transient AlicePawn Pawn;
var name ControllerLandMovementState;
var name NextState;
var name PrevState;
var Vector PawnPosition;
var Vector oldPawnPosition;
var Vector RealPawnSpeed;
var Vector RealPawnSpeed2D;
var Vector ContainerSpeed;
var Vector LedgePosition;
var Vector oldLedgePosition;
var Vector PawnSpeed;
var Vector PawnSpeed2D;
var Vector oldPawnSpeed;
var Vector PawnAccel;
var Vector oldPawnAccel;
var Vector PawnAccel2D;
var Vector PawnFacing;
var float PawnSpeedSize;
var float PawnSpeedSize2D;
var float PawnAccelSize;
var float PawnAccelSize2D;
var float AngularSpeedOfAngleBtwAccelAndSpeed;
var float SpeedThresholdWalkNRun;
var float AccelVariation;
var float AccelAngleVariation;
var float Speed2DVariation;
var float AngleBetweenAccelAndSpeed;
var float InputSize;

function CalculateMovementParameters(float DeltaTime)
{
    local float oldAngle, oldSpeedSize2D, oldSize;
    
    if (Controller != none)
    {
        Pawn = AlicePawn(Controller.Pawn);
        Input = AlicePlayerInput(Controller.PlayerInput);
    }
    if (Pawn == none || Input == none)
    {
        return;
    }
    oldPawnPosition = PawnPosition;
    PawnPosition = Pawn.Location;
    RealPawnSpeed = (PawnPosition - oldPawnPosition) / DeltaTime;
    if (Pawn.Base != none)
    {
        ContainerSpeed = Pawn.Base.Velocity;
    }
    else if (Pawn.OnLedge != none)
    {
        oldLedgePosition = LedgePosition;
        LedgePosition = Pawn.OnLedge.Location;
        ContainerSpeed = (LedgePosition - oldLedgePosition) / DeltaTime;
    }
    else
    {
        ContainerSpeed = vect(0.0, 0.0, 0.0);
    }
    RealPawnSpeed -= ContainerSpeed;
    RealPawnSpeed2D = RealPawnSpeed;
    RealPawnSpeed2D.Z = 0.0;
    oldPawnSpeed = PawnSpeed;
    PawnSpeed = Pawn.Velocity;
    PawnSpeed2D = Pawn.Velocity;
    PawnSpeed2D.Z = 0.0;
    oldPawnAccel = PawnAccel;
    PawnAccel = Input.InputVector;
    PawnAccel2D = Input.InputVector;
    PawnAccel2D.Z = 0.0;
    PawnFacing = vector(Pawn.Rotation);
    oldSpeedSize2D = PawnSpeedSize2D;
    PawnSpeedSize = VSize(PawnSpeed);
    PawnSpeedSize2D = VSize(PawnSpeed2D);
    PawnAccelSize = VSize(PawnAccel);
    oldSize = PawnAccelSize2D;
    PawnAccelSize2D = VSize(PawnAccel2D);
    oldAngle = AngleBetweenAccelAndSpeed;
    AngleBetweenAccelAndSpeed = Controller.CalcAngleBetweenVectors(PawnSpeed2D, PawnAccel2D);
    AngularSpeedOfAngleBtwAccelAndSpeed = (AngleBetweenAccelAndSpeed - oldAngle) / DeltaTime;
    SpeedThresholdWalkNRun = Pawn.MaxWalkingSpeed + (Pawn.MaxRunningSpeed - Pawn.MaxWalkingSpeed) / float(2);
    AccelAngleVariation = Controller.CalcAngleBetweenVectors(PawnAccel, oldPawnAccel);
    AccelVariation = PawnAccelSize2D - oldSize;
    InputSize = PawnAccelSize2D;
    Speed2DVariation = PawnSpeedSize2D - oldSpeedSize2D;
}

event RevertToIdle(float DeltaTime)
{
    if (!IsInState('Idle'))
    {
        GotoState('Idle');
        SetPlayerBasicMovementState(0);
    }
}

event Update(float DeltaTime)
{
}

function SetPlayerBasicMovementState(EMovementState inState)
{
    if (Pawn != none)
    {
        Pawn.BasicMovementState = inState;
    }
}

state Braking
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
    }
    
    event Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
    }
    
    Stop;
}

state Starting
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
    }
    
    event Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
    }
    
    Stop;
}

state Sprint
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
    }
    
    event Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
    }
    
    Stop;
}

state Running
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
    }
    
    event Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
    }
    
    Stop;
}

state Walking
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
    }
    
    event Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
    }
    
    Stop;
}

state Rotating
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
    }
    
    event Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
    }
    
    Stop;
}

auto state Idle
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
    }
    
    event Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
    }
    
    Stop;
}

defaultproperties
{
    ControllerLandMovementState="PlayerWalking"
    NextState="Idle"
    PrevState="Idle"
}
