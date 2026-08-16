class ASM_TeapotCannonRA_Charge extends ASM_WeaponRABase
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    PawnOwner.StopConfigAnim(AnimCfg_Animation, AnimCfg_Animation.BlendOutTime);
    PawnOwner.StopAllConfigAnim(BlendOutTime);
    AliceGameWeaponBase(PawnOwner.Weapon).StopWeaponSlotAnim(0.1);
    AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP4_Charged', , true);
    AlicePawn(PawnOwner).bAllowFacingTargetInSpeicalMove = false;
    SpecialMoveEnded(PrevMove, NextMove);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (PCOwner.bTargetingModeActive || PCOwner.bFirstPersonViewActive)
    {
        AnimCfg_Animation.AnimationNames[0] = 'ADD_AliceW_WP4_Attack_Charging_UB';
        AnimCfg_Animation.BlendNodeIndex = 3;
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Charge';
        AnimCfg_Animation.BlendNodeIndex = 1;
    }
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP4_Charging', , true);
    AlicePawn(PawnOwner).bAllowFacingTargetInSpeicalMove = true;
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("ADD_AliceW_WP4_Attack_Charging_UB"),BlendNodeIndex="EABLIdx_Slot_Combat_Upper_Additive",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
}
