class ASM_DeflectSpin extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

event EndSpinning()
{
    PawnOwner.EndSpecialMove();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    AlicePawn(PawnOwner).bIsDeflectSpinning = false;
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    AlicePawn(PawnOwner).bAllowFacingTargetInSpeicalMove = false;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    AlicePawn(PawnOwner).bIsDeflectSpinning = true;
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AlicePawn(PawnOwner).UmbrellaInstance.PlayWeaponSlotAnim('Umb_Spin', , true);
    AlicePawn(PawnOwner).bAllowFacingTargetInSpeicalMove = true;
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_StauePose_Spin"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.15,BlendOutTime=0.15,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
}
