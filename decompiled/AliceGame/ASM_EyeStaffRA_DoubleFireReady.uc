class ASM_EyeStaffRA_DoubleFireReady extends ASM_WeaponRABase
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;
var() AnimationParaConfig AnimCfg_Animation_Lower;

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    PawnOwner.StopConfigAnim(AnimCfg_Animation, AnimCfg_Animation.BlendOutTime);
    AliceGameWeaponBase(PawnOwner.Weapon).StopWeaponSlotAnim(AnimCfg_Animation.BlendOutTime);
    SpecialMoveEnded(PrevMove, NextMove);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (PCOwner.bTargetingModeActive)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Attack_Alt_A_UB';
        AnimCfg_Animation.BlendNodeIndex = 1;
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Attack_Alt_A';
        AnimCfg_Animation.BlendNodeIndex = 1;
    }
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP3_Attack_Alt_A', , false);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("ADD_AliceW_WP3_Fire"),BlendNodeIndex="EABLIdx_Slot_Combat_Upper_Additive",AnimType=0,BlendInTime=0.1,BlendOutTime=0.4,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Animation_Lower=(AnimationNames=("ADD_Pose_Combat_WP3_Fire_LB"),BlendNodeIndex="EABLIdx_Slot_Combat_Lower_Additive",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
}
