class ASM_Disarm extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    if (!PCOwner.bTargetingModeActive)
    {
        AlicePawn(PawnOwner).FadeOutWeapon();
    }
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    GetAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    SpecialMoveStarted(bForced, PrevMove);
}

function GetAnimation()
{
    local int WeaponType;
    
    WeaponType = AlicePawn(PawnOwner).GetCurrentWeaponType();
    if (WeaponType == 1)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP1_Disarm_UB';
    }
    else if (WeaponType == 2)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP2_Disarm_UB';
    }
    else if (WeaponType == 3)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Disarm_UB';
    }
    else if (WeaponType == 4)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Disarm_UB';
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_WP1_Disarm_UB"),BlendNodeIndex="EABLIdx_Slot_HalfBody_Upper_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
}
