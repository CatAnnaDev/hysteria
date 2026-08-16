class AlicePlayer_HangMovementState extends AlicePlayer_MovementStateBase
    notplaceable;

state Walking
{
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        Pawn.CostEndurance(DeltaTime, 1);
        if (PawnAccelSize == float(0))
        {
            SetPlayerBasicMovementState(0);
            GotoState('Idle');
        }
    }
    
    Begin:
    Stop;
}

auto state Idle
{
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        Pawn.CostEndurance(DeltaTime, 1);
        if (PawnAccelSize > float(0))
        {
            SetPlayerBasicMovementState(1);
            GotoState('Walking');
        }
        else
        {
            SetPlayerBasicMovementState(0);
        }
    }
    
    Begin:
    Stop;
}

defaultproperties
{
    ControllerLandMovementState="PlayerClimbing"
}
