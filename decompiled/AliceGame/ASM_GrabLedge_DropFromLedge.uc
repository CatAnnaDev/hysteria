class ASM_GrabLedge_DropFromLedge extends ASM_GrabLedge_JumpToAnotherLedge
    notplaceable;

event Landed()
{
    GetAnimationsForLanding();
    PlayLand();
}

function GetAnimationsForLanding()
{
    if (PawnOwner.Physics != 9)
    {
        AnimCfg_Landing.AnimationNames[0] = 'Alice_Jump_Land';
    }
    else
    {
        AnimCfg_Landing.AnimationNames[0] = 'Alice_Ledge_Start_JumpUp';
    }
}

function GetAnimationForLedge()
{
    if (PawnOwner.OnLedge != none)
    {
        switch (PawnOwner.OnLedge.VolumeType)
        {
            case 0:
            case 1:
                AnimCfg_JumpStart.AnimationNames[0] = 'Alice_Ledge_DropOff';
                AnimCfg_Jumping.AnimationNames[0] = 'Alice_Jump_Fall';
                GetAnimationsForLanding();
                AnimCfg_JumpStart.RootBoneTransitionOption[0] = 1;
                AnimCfg_JumpStart.RootBoneTransitionOption[2] = 1;
                break;
            default:
        }
    }
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    if (AlicePawn(PawnOwner) != none)
    {
        AlicePawn(PawnOwner).EnableAirControl(true);
    }
}

defaultproperties
{
}
