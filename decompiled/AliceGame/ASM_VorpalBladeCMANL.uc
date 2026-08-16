class ASM_VorpalBladeCMANL extends ASM_WeaponCMABase
    notplaceable;

var() AnimationParaConfig AnimCfg_AnimationRandom1;
var() AnimationParaConfig AnimCfg_AnimationRandom2;
var int playingIndex;

simulated function Inner_StartPlayComboAnimation()
{
    if (playingIndex == 1)
    {
        playingIndex = 0;
    }
    else
    {
        playingIndex = 1;
    }
    if (playingIndex == 0)
    {
        PawnOwner.PlayConfigAnim(AnimCfg_AnimationRandom1);
    }
    else
    {
        PawnOwner.PlayConfigAnim(AnimCfg_AnimationRandom2);
    }
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (PawnOwner.Weapon != none && PawnOwner.Weapon.IsFiring())
    {
        PawnOwner.Weapon.NotifyFireSpecialMoveFinished(PawnOwner.SpecialMove);
    }
    AnimCfg_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    if (playingIndex == 0)
    {
        PawnOwner.StopConfigAnim(AnimCfg_AnimationRandom1, BlendOutTime);
    }
    else
    {
        PawnOwner.StopConfigAnim(AnimCfg_AnimationRandom2, BlendOutTime);
    }
    if (PCOwner.IsMaintainingMovement())
    {
        PCOwner.StopMaintainMovement();
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    if (PawnOwner.BasicMovementState == 2)
    {
        RMMInAction = 2;
        bDisableMovement = false;
        bCanRepeat = true;
        PCOwner.StartMaintainMovement(0.6);
    }
    else
    {
        RMMInAction = 3;
        bDisableMovement = true;
        bCanRepeat = false;
    }
    SpecialMoveStarted(bForced, PrevMove);
}

function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
    if (NewMove == 31)
    {
        return true;
    }
    return CanOverrideMoveWith(NewMove);
}

defaultproperties
{
    AnimCfg_AnimationRandom1=(AnimationNames=("AliceW_WP1_Mele_Attack_NL_1"),BlendNodeIndex="EABLIdx_Slot_HalfBody_Upper_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_AnimationRandom2=(AnimationNames=("AliceW_WP1_Mele_Attack_NL_2"),BlendNodeIndex="EABLIdx_Slot_HalfBody_Upper_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    playingIndex=1
    bDisableMovement=False
    RMMInAction="RMM_Ignore"
}
