class ASM_TeapotCannonRA_Fire extends ASM_WeaponRABase
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    if (TeapotCannon(PawnOwner.Weapon).IsFiring())
    {
        TeapotCannon(PawnOwner.Weapon).HandleFinishedFiring();
    }
    PawnOwner.Weapon.NotifyFireSpecialMoveFinished(PrevMove);
    AliceGameWeaponBase(PawnOwner.Weapon).StopWeaponSlotAnim(0.1);
    SpecialMoveEnded(PrevMove, NextMove);
    AlicePawn(PawnOwner).bDoingTeapotCannonFireSpecialMove = false;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    local TeapotCannon teapot;
    
    SpecialMoveStarted(bForced, PrevMove);
    teapot = TeapotCannon(PawnOwner.Weapon);
    if (PCOwner.bTargetingModeActive || PCOwner.bFirstPersonViewActive)
    {
        if (teapot != none && teapot.bFinishCharge)
        {
            if (teapot.HasAmmo(teapot.CHARGED_FIRE, teapot.ShotCost[int(teapot.CHARGED_FIRE)]))
            {
                AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Attack_Charged_Fire';
                AnimCfg_Animation.BlendNodeIndex = 0;
                AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
                AnimCfg_Animation.RootBoneTransitionOption[1] = 2;
            }
            else
            {
                AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Fire_2';
                AnimCfg_Animation.BlendNodeIndex = 0;
                AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
                AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
            }
            bDisableMovement = true;
        }
        else if (PrevMove == 37)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Fire_2';
            AnimCfg_Animation.BlendNodeIndex = 0;
            AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
            AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
            bDisableMovement = true;
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'ADD_AliceW_WP4_Fire';
            AnimCfg_Animation.BlendNodeIndex = 3;
            AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
            AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
            bDisableMovement = false;
        }
    }
    else if (teapot != none && teapot.bFinishCharge)
    {
        if (teapot.HasAmmo(teapot.CHARGED_FIRE, teapot.ShotCost[int(teapot.CHARGED_FIRE)]))
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Attack_Charged_Fire';
            AnimCfg_Animation.BlendNodeIndex = 0;
            AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
            AnimCfg_Animation.RootBoneTransitionOption[1] = 2;
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Fire_2';
            AnimCfg_Animation.BlendNodeIndex = 0;
            AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
            AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
        }
        bDisableMovement = true;
    }
    else if (PrevMove == 37)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Fire_2';
        AnimCfg_Animation.BlendNodeIndex = 0;
        AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
        AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
        bDisableMovement = true;
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Fire';
        AnimCfg_Animation.BlendNodeIndex = 1;
        AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
        AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
        bDisableMovement = false;
    }
    if (teapot != none && teapot.bFinishCharge)
    {
        AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP4_Fire_NoDelay', , false);
    }
    else
    {
        AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim('WP4_Fire', , false);
    }
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AlicePawn(PawnOwner).bDoingTeapotCannonFireSpecialMove = true;
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("ADD_AliceW_WP4_Fire"),BlendNodeIndex="EABLIdx_Slot_Combat_Upper_Additive",AnimType=0,BlendInTime=0.1,BlendOutTime=0.2,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    RMMInAction="RMM_Accel"
}
