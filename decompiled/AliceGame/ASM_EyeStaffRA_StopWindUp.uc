class ASM_EyeStaffRA_StopWindUp extends ASM_WeaponRABase
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;
var() AnimationParaConfig AnimCfg_Animation_Lower;

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    if (NextMove == 3)
    {
        PawnOwner.StopAllConfigAnim(0.1);
    }
    PawnOwner.StopConfigAnim(AnimCfg_Animation, AnimCfg_Animation.BlendOutTime);
    AliceGameWeaponBase(PawnOwner.Weapon).StopWeaponSlotAnim(AnimCfg_Animation.BlendOutTime);
    SpecialMoveEnded(PrevMove, NextMove);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (PCOwner.bTargetingModeActive || PCOwner.IsFirstPersonViewActivated())
    {
        AnimCfg_Animation.AnimationNames[0] = 'ADD_AliceW_WP3_Release';
        AnimCfg_Animation.BlendNodeIndex = 3;
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Release';
        AnimCfg_Animation.BlendNodeIndex = 1;
    }
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP3_Release', , false);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_WP3_Release"),BlendNodeIndex="EABLIdx_Slot_Combat_Upper_Additive",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Animation_Lower=(AnimationNames=(),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
}
