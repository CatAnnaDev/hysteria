class ASM_WeaponCMABase extends AliceSpecialMove
    native
    notplaceable;

enum ASM_WeaponCMA_STATE
{
    ASM_WS_Ready,
    ASM_WS_Rotate,
    ASM_WS_PlayingAnim,
};

var Vector InputVector;
var ASM_WeaponCMA_STATE CMA_state;
var float RotatorBlendingTimer;
var float RotatorTimerOut;

function PostSpecialMove()
{
    PostSpecialMove();
    PCOwner = AlicePlayerController(PawnOwner.Controller);
    if (PCOwner != none)
    {
        PCOwner.PostMeleeAttack();
    }
}

function PreSpecialMove()
{
    PCOwner = AlicePlayerController(PawnOwner.Controller);
    if (PCOwner != none)
    {
        PCOwner.PreMeleeAttack();
    }
}

function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
    if (NewMove == 37 || NewMove > 12 && NewMove < 17 || NewMove > 19 && NewMove < 29)
    {
        return true;
    }
    return false;
}

function bool CanChainMove(ESpecialMove NextMove)
{
    if (NextMove == 37)
    {
        return true;
    }
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    CMA_state = 0;
    SpecialMoveEnded(PrevMove, NextMove);
}

event SetInputVector()
{
    InputVector = AlicePlayerInput(AlicePlayerController(PawnOwner.Controller).PlayerInput).InputVectorCombo;
}

event StartPlayComboAnimation()
{
    Inner_StartPlayComboAnimation();
}

simulated function Inner_StartPlayComboAnimation()
{
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    CMA_state = 0;
    SpecialMoveStarted(bForced, PrevMove);
}

defaultproperties
{
    RotatorBlendingTimer=0.1
    bDisableMovement=True
    bStopAtLedges=True
    UseCustomRMM=True
    RMMInAction="RMM_Accel"
}
