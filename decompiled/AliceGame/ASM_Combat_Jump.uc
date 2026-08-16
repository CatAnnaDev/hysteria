class ASM_Combat_Jump extends ASM_JumpStart
    notplaceable;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
}

function GetAnimations()
{
    local int WeaponType;
    
    WeaponType = AlicePawn(PawnOwner).GetCurrentWeaponType();
    if (!PawnOwner.bCanLunge)
    {
        PreLandTime = 0.1;
        if (WeaponType == 1)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Up';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Down';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Land';
        }
        else if (WeaponType == 4)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Up';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Down';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Land';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Up';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Down';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Land';
        }
        else if (WeaponType == 3)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Up';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Down';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP1_Mele_Jump_Land';
        }
        AnimCfg_JumpStart.RootBoneTransitionOption[0] = 1;
        AnimCfg_Landing.RootBoneTransitionOption[0] = 2;
    }
    else
    {
        PreLandTime = 0.5;
        if (WeaponType == 1)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP1_Lunge_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP1_Lunge_Jump_Up';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP1_Lunge_Jump_Down';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP1_Lunge_Jump_Land';
        }
        else if (WeaponType == 4)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP2_Lunge_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP2_Lunge_Jump_Rise';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP2_Lunge_Jump_Fall';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP2_Lunge_Jump_Land';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP3_Lunge_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP3_Lunge_Jump_Up';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP3_Lunge_Jump_Down';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP3_Lunge_Jump_Land';
        }
        else if (WeaponType == 3)
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_WP4_Lunge_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_WP4_Lunge_Jump_Up';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_WP4_Lunge_Jump_Down';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_WP4_Lunge_Jump_Land';
        }
        AnimCfg_JumpStart.RootBoneTransitionOption[0] = 1;
        AnimCfg_Landing.RootBoneTransitionOption[0] = 1;
    }
    AnimCfg_JumpStart.BlendInTime = 0.15;
    AnimCfg_Landing.BlendOutTime = 0.25;
}

defaultproperties
{
    AnimCfg_JumpStart=(AnimationNames=("AliceW_WP1_Mele_Jump_Start"))
    AnimCfg_JumpRising=(AnimationNames=("AliceW_WP1_Mele_Jump_Up"))
    AnimCfg_Jumping=(AnimationNames=("AliceW_WP1_Mele_Jump_Down"))
    AnimCfg_Landing=(AnimationNames=("AliceW_WP1_Mele_Jump_Land"))
    bDisableMovement=True
    bDisableAirControl=True
    bCanRepeat=False
}
