class ASM_GrabLedgeWhenJump extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function GetAnimationForLedge()
{
    if (PawnOwner.OnLedge != none)
    {
        AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
        AnimCfg_Animation.BlendInTime = 0.1;
        AnimCfg_Animation.BlendOutTime = 0.1;
        switch (PawnOwner.OnLedge.VolumeType)
        {
            case 0:
                AnimCfg_Animation.AnimationNames[0] = 'Alice_Ledge_Start_JumpUp';
                break;
            case 1:
                AnimCfg_Animation.AnimationNames[0] = 'Alice_HB_Start';
                break;
            case 2:
                AnimCfg_Animation.AnimationNames[0] = 'AliceL_Ladder_Jump_Off';
                break;
            default:
        }
    }
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimationForLedge();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("Alice_HB_Start"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
}
