class AlicePlayer_CombatMovementState extends AlicePlayer_MovementStateBase
    notplaceable;

state Walking
{
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        Pawn.RecoverEndurance(DeltaTime);
        if (PawnSpeedSize2D == float(0))
        {
            SetPlayerBasicMovementState(0);
            GotoState('Idle');
        }
    }
    
    Stop;
}

auto state Idle
{
    event Update(float DeltaTime)
    {
        Update(DeltaTime);
        Pawn.RecoverEndurance(DeltaTime);
        if (PawnSpeedSize2D > float(0))
        {
            SetPlayerBasicMovementState(1);
            GotoState('Walking');
        }
        else
        {
            SetPlayerBasicMovementState(0);
        }
    }
    
    Stop;
}

defaultproperties
{
    ControllerLandMovementState="PlayerLockOnTarget"
}
