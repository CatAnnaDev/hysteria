class ASM_ShieldBreakingDash extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    PCOwner.HoldActionDone();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_WP1_Mele_ShieldBreak_B"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.25,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
    UseCustomRMM=True
    RMMInAction="RMM_Accel"
}
