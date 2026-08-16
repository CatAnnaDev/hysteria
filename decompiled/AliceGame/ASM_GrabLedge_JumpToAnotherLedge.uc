class ASM_GrabLedge_JumpToAnotherLedge extends ASM_JumpStart
    native
    notplaceable;

var transient LedgeVolume StartLedge;

function GetAnimations()
{
    if (PawnOwner.OnLedge != none)
    {
        switch (PawnOwner.OnLedge.VolumeType)
        {
            case 0:
                if (PawnOwner.LedgeJumpDir == 1)
                {
                    AnimCfg_JumpStart.AnimationNames[0] = 'Alice_Ledge_JumpUp_D';
                    AnimCfg_Jumping.AnimationNames[0] = 'Alice_Ledge_JumpUp_C';
                    AnimCfg_Landing.AnimationNames[0] = 'Alice_Ledge_JumpUp_F';
                    AnimCfg_JumpStart.RootBoneTransitionOption[0] = 2;
                    AnimCfg_Landing.RootBoneTransitionOption[0] = 2;
                    AnimCfg_JumpStart.RootBoneTransitionOption[2] = 2;
                    AnimCfg_Landing.RootBoneTransitionOption[2] = 2;
                    AnimCfg_JumpStart.BlendOutTime = 0.1;
                    AnimCfg_JumpStart.BlendInTime = 0.1;
                    AnimCfg_Jumping.BlendInTime = 0.1;
                    AnimCfg_Landing.BlendInTime = 0.1;
                }
                else if (PawnOwner.LedgeJumpDir == 2)
                {
                    AnimCfg_JumpStart.AnimationNames[0] = 'Alice_Ledge_JumpLeft_D';
                    AnimCfg_Jumping.AnimationNames[0] = 'Alice_Ledge_JumpLeft_C';
                    AnimCfg_Landing.AnimationNames[0] = 'Alice_Ledge_JumpLeft_F';
                    AnimCfg_JumpStart.RootBoneTransitionOption[1] = 2;
                    AnimCfg_Landing.RootBoneTransitionOption[1] = 2;
                    AnimCfg_JumpStart.RootBoneTransitionOption[2] = 2;
                    AnimCfg_Landing.RootBoneTransitionOption[2] = 1;
                }
                else if (PawnOwner.LedgeJumpDir == 3)
                {
                    AnimCfg_JumpStart.AnimationNames[0] = 'Alice_Ledge_JumpRight_D';
                    AnimCfg_Jumping.AnimationNames[0] = 'Alice_Ledge_JumpRight_C';
                    AnimCfg_Landing.AnimationNames[0] = 'Alice_Ledge_JumpRight_F';
                    AnimCfg_JumpStart.RootBoneTransitionOption[1] = 2;
                    AnimCfg_Landing.RootBoneTransitionOption[1] = 2;
                    AnimCfg_JumpStart.RootBoneTransitionOption[2] = 2;
                    AnimCfg_Landing.RootBoneTransitionOption[2] = 1;
                }
                break;
            default:
        }
    }
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (PawnOwner.CurrentJumpStatus == 1)
    {
        PlayFall();
    }
    else if (PawnOwner.CurrentJumpStatus == 4)
    {
        PawnOwner.EndSpecialMove();
    }
}

function PlayFall()
{
    PawnOwner.Velocity = PawnOwner.PendingVelocity;
    GravityScale = 1.0;
    PlayFall();
}

function PlayJump()
{
    StartLedge = PawnOwner.OnLedge;
    PlayJump();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimations();
    PlayJump();
}

defaultproperties
{
    AnimCfg_JumpStart=(AnimationNames=("Alice_Jump_Start"))
    AnimCfg_Jumping=(AnimationNames=("Alice_Jump_Fall"))
    AnimCfg_Landing=(AnimationNames=("Alice_Jump_Land"))
    PreLandTime=0.15
    GravityScale=0.0
    bDisableMovement=True
}
