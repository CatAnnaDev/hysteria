class ASM_HobbyHorseCMANL extends ASM_WeaponCMABase
    notplaceable;

var() AnimationParaConfig AnimCfg_AnimationMove;

simulated function Inner_StartPlayComboAnimation()
{
    PawnOwner.PlayConfigAnim(AnimCfg_AnimationMove);
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
    PawnOwner.StopConfigAnim(AnimCfg_AnimationMove, BlendOutTime);
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
        PCOwner.StartMaintainMovement(0.6);
    }
    else
    {
        RMMInAction = 3;
        bDisableMovement = true;
    }
    SpecialMoveStarted(bForced, PrevMove);
}

defaultproperties
{
    AnimCfg_AnimationMove=(AnimationNames=("AliceW_WP2_Run_Attack_NL"),BlendNodeIndex="EABLIdx_Slot_HalfBody_Upper_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bStopAllConfigAnim=True
}
