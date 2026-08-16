class ASM_EyeStaffRA_Fire extends ASM_WeaponRABase
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;
var() AnimationParaConfig AnimCfg_Animation_Lower;

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    if (EyeStaff(PawnOwner.Weapon).IsFiring())
    {
        EyeStaff(PawnOwner.Weapon).HandleFinishedFiring();
    }
    EyeStaff(PawnOwner.Weapon).NotifyFireSpecialMoveFinished(PrevMove);
    PawnOwner.StopAllConfigAnim(0.05);
    AliceGameWeaponBase(PawnOwner.Weapon).StopWeaponSlotAnim(0.1);
    SpecialMoveEnded(PrevMove, NextMove);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (PCOwner.bTargetingModeActive || PCOwner.bFirstPersonViewActive)
    {
        if (!EyeStaff(PawnOwner.Weapon).bOverHeat && !EyeStaff(PawnOwner.Weapon).bInFullRefillTime)
        {
            AnimCfg_Animation.AnimationNames[0] = 'ADD_AliceW_WP3_Fire';
            AnimCfg_Animation.BlendNodeIndex = 3;
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'ADD_AliceW_WP3_NoAmmo';
            AnimCfg_Animation.BlendNodeIndex = 3;
        }
    }
    else if (!EyeStaff(PawnOwner.Weapon).bOverHeat && !EyeStaff(PawnOwner.Weapon).bInFullRefillTime)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Fire';
        AnimCfg_Animation.BlendNodeIndex = 1;
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_NoAmmo';
        AnimCfg_Animation.BlendNodeIndex = 1;
    }
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    if (!EyeStaff(PawnOwner.Weapon).bOverHeat && !EyeStaff(PawnOwner.Weapon).bInFullRefillTime)
    {
        AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP3_Fire', , true);
    }
    else
    {
        AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP3_NoAmmo', , true);
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("ADD_AliceW_WP3_Fire"),BlendNodeIndex="EABLIdx_Slot_Combat_Upper_Additive",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Animation_Lower=(AnimationNames=("ADD_Pose_Combat_WP3_Fire_LB"),BlendNodeIndex="EABLIdx_Slot_Combat_Lower_Additive",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bStopAtLedges=True
    bCanRepeat=True
}
