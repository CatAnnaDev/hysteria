class AlicePlayer_StandMovementState extends AlicePlayer_MovementStateBase
    notplaceable;

var bool bPossibleTurningWhileRunning;
var bool bTurningWhileRunning;

state Braking
{
    event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        Pawn.DoSpecialMove(1, false);
    }
    
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        if (!Pawn.IsDoingSpecialMove(1))
        {
            Pawn.bIsBraking = false;
            SetPlayerBasicMovementState(0);
            GotoState('Idle');
        }
    }
    
    Stop;
}

state Sprint
{
    event EndState(name NextStateName)
    {
        Pawn.bIsSprinting = false;
        Pawn.bSprintRTHold = false;
    }
    
    event BeginState(name PreviousStateName)
    {
        Pawn.bIsSprinting = true;
        Pawn.Velocity = Normal(vector(Pawn.Rotation)) * Pawn.SprintSpeed;
    }
    
    function Update(float DeltaTime)
    {
        Update(DeltaTime);
        if (!Pawn.bSprintRTHold)
        {
            SetPlayerBasicMovementState(2);
            GotoState('Running');
            return;
        }
        else if (AlicePlayerController(Pawn.Controller).ShouldCancelSprint())
        {
            SetPlayerBasicMovementState(1);
            GotoState('Walking');
            return;
        }
        if (VSize(RealPawnSpeed) >= Pawn.SprintOffSpeed && Pawn.bSprintRTHold)
        {
            Pawn.GroundSpeed = Pawn.SprintSpeed;
        }
        else
        {
            SetPlayerBasicMovementState(2);
            GotoState('Running');
        }
    }
    
    Stop;
}

state TurningWhileRunning
{
    function Update(float DeltaTime)
    {
        CalculateMovementParameters(DeltaTime);
        if (Abs(Controller.AngleBetweenInputAndPlayer) < 3.1415927 * 0.125)
        {
            Pawn.bTurningWhileRunning = false;
            bPossibleTurningWhileRunning = false;
            bTurningWhileRunning = false;
            GotoState('Running');
        }
    }
    
    Stop;
}

state Running
{
    event EndState(name NextStateName)
    {
        Pawn.SetAliceAbilityCamera(Pawn.RunCamera, true);
    }
    
    event BeginState(name PreviousStateName)
    {
        if (!AlicePlayerController(Pawn.Controller).bShrinkingModeActive)
        {
            Pawn.SetAliceAbilityCamera(Pawn.RunCamera);
        }
    }
    
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        if (Pawn.bCanSprint && Pawn.bSprintRTHold)
        {
            if (!AlicePlayerController(Pawn.Controller).ShouldCancelSprint() && VSize(RealPawnSpeed) >= Pawn.SprintOffSpeed)
            {
                SetPlayerBasicMovementState(3);
                GotoState('Sprint');
                return;
            }
        }
        Pawn.CostEndurance(DeltaTime, 0);
        if (bPossibleTurningWhileRunning)
        {
            if (VSize(PawnAccel) > float(0))
            {
                bTurningWhileRunning = true;
            }
            else
            {
                bPossibleTurningWhileRunning = false;
            }
        }
        if (bTurningWhileRunning)
        {
            Pawn.bTurningWhileRunning = true;
            GotoState('TurningWhileRunning');
            return;
        }
        if (Abs(AccelAngleVariation) > 3.1415927 * float(2) / float(3) || VSize(oldPawnAccel) != float(0) && VSize(PawnAccel) == float(0))
        {
            bPossibleTurningWhileRunning = true;
        }
        else if (PawnSpeedSize2D > float(0) && PawnSpeedSize2D <= SpeedThresholdWalkNRun && Abs(Controller.AngleBetweenInputAndPlayer) < Controller.AngleThresholdToCancelAccel)
        {
            SetPlayerBasicMovementState(1);
            GotoState('Walking');
        }
        else if (PawnSpeedSize2D == float(0))
        {
            SetPlayerBasicMovementState(0);
            GotoState('Idle');
        }
    }
    
    Stop;
}

state Walking
{
    event EndState(name NextStateName)
    {
        Pawn.SetAliceAbilityCamera(Pawn.WalkCamera, true);
    }
    
    event BeginState(name PreviousStateName)
    {
        if (!AlicePlayerController(Pawn.Controller).bShrinkingModeActive)
        {
            Pawn.SetAliceAbilityCamera(Pawn.WalkCamera);
        }
    }
    
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        Pawn.RecoverEndurance(DeltaTime);
        if (PawnSpeedSize2D == float(0))
        {
            SetPlayerBasicMovementState(0);
            GotoState('Idle');
        }
        else if (PawnSpeedSize2D > SpeedThresholdWalkNRun && Abs(Controller.AngleBetweenInputAndPlayer) < Controller.AngleThresholdToCancelAccel)
        {
            SetPlayerBasicMovementState(2);
            GotoState('Running');
        }
    }
    
    Stop;
}

state Rotating
{
    event EndState(name NextStateName)
    {
        EndState(NextStateName);
        Pawn.bIsTurning = false;
        Pawn.AngleToRotate = 0.0;
    }
    
    event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        if (!Pawn.IsPawnInAStance(2))
        {
            Controller.RecoverToDefaultStatus(false, false, false);
        }
        Controller.PawnDirWhenRotateStarts = vector(Pawn.Rotation);
        Pawn.DoSpecialMove(2, true);
    }
    
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        Pawn.RecoverEndurance(DeltaTime);
        if (Pawn.IsDoingSpecialMove(2))
        {
            return;
        }
        EndRotating();
    }
    
    function EndRotating()
    {
        if (InputSize > float(0))
        {
            SetPlayerBasicMovementState(2);
            GotoState('Running');
        }
        else
        {
            SetPlayerBasicMovementState(0);
            GotoState('Idle');
        }
    }
    
    Stop;
}

auto state Idle
{
    event EndState(name NextStateName)
    {
        Pawn.SetAliceAbilityCamera(Pawn.IdleCamera, true);
    }
    
    event BeginState(name PreviousStateName)
    {
        if (Pawn != none && Pawn.Controller != none && !AlicePlayerController(Pawn.Controller).bShrinkingModeActive)
        {
            Pawn.SetAliceAbilityCamera(Pawn.IdleCamera, false, false);
        }
    }
    
    event Update(float DeltaTime)
    {
        local Rotator NewRot;
        
        Update(DeltaTime);
        Pawn.RecoverEndurance(DeltaTime);
        if (PawnSpeedSize2D == float(0))
        {
            if (Abs(Controller.AngleBetweenInputAndPlayer) > float(0))
            {
                Pawn.AngleToRotate = 0.0;
                NewRot = rotator(AlicePlayerInput(Controller.PlayerInput).InputVector);
                Pawn.SetRotation(NewRot);
            }
        }
        else if (PawnSpeedSize2D > float(0) && PawnSpeedSize2D <= SpeedThresholdWalkNRun && Abs(Controller.AngleBetweenInputAndPlayer) < Controller.AngleThresholdToCancelAccel)
        {
            SetPlayerBasicMovementState(1);
            GotoState('Walking');
        }
        else if (PawnSpeedSize2D > SpeedThresholdWalkNRun && Abs(Controller.AngleBetweenInputAndPlayer) < Controller.AngleThresholdToCancelAccel)
        {
            SetPlayerBasicMovementState(2);
            GotoState('Running');
        }
    }
    
    Stop;
}

defaultproperties
{
}
