class ASM_GrabLedge_ClimbOverLedge extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    ResetPawnOwnerLedgeClimbing();
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
}

function ResetPawnOwnerLedgeClimbing()
{
    if (PawnOwner.OnLedge.VolumeType == 1)
    {
        PawnOwner.LeaningFactor = 0.0;
        PawnOwner.LedgeBalancingDirection = 0;
        PawnOwner.ClimbEdge(PawnOwner.OnLedge);
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

function GetAnimation()
{
    if (PawnOwner.OnLedge.VolumeType == 1)
    {
        if (!PawnOwner.bStandOnBalanceBeam)
        {
            AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
            AnimCfg_Animation.RootBoneTransitionOption[2] = 2;
            AnimCfg_Animation.RootBoneRotationOption[2] = 2;
            if (PawnOwner.bClimbOnLeftSideOfBalanceBeam)
            {
                AnimCfg_Animation.AnimationNames[0] = 'Alice_BB_ClimbOn_Lft';
            }
            else
            {
                AnimCfg_Animation.AnimationNames[0] = 'Alice_BB_ClimbOn_Rgt';
            }
        }
    }
    else
    {
        AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
        AnimCfg_Animation.RootBoneTransitionOption[2] = 2;
        AnimCfg_Animation.RootBoneRotationOption[2] = 0;
        AnimCfg_Animation.AnimationNames[0] = 'Alice_Ledge_ClimbOver';
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("Alice_Ledge_ClimbOver"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    GravityScale=0.0
    bDisableMovement=True
    bDisableCollision=True
}
