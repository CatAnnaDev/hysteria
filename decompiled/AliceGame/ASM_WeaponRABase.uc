class ASM_WeaponRABase extends AliceSpecialMove
    notplaceable;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    if (!PCOwner.bTargetingModeActive && !PCOwner.bFirstPersonViewActive)
    {
        AlicePawn(PawnOwner).SetTimerToHideWeapon();
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (!PCOwner.bTargetingModeActive && !PCOwner.bFirstPersonViewActive)
    {
        AlicePawn(PawnOwner).ClearTimerToHideWeapon();
    }
}

function bool CanChainMove(ESpecialMove NextMove)
{
    if (NextMove == 37)
    {
        return true;
    }
    return false;
}

defaultproperties
{
}
