class ASM_GiantStomp extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceGiant_Stomp_All"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.2,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
}
