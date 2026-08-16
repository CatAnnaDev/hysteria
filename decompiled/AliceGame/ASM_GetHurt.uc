class ASM_GetHurt extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function GetAnimation()
{
    local int WeaponType;
    local bool bLeftDir;
    
    if (AlicePawn(PawnOwner).bInGiantMode)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceGiant_Damage_Lgt';
        return;
    }
    WeaponType = AlicePawn(PawnOwner).GetCurrentWeaponType();
    bLeftDir = (Rand(2) == 1 ? true : false);
    if (WeaponType == 1)
    {
        if (PawnOwner.CurrentDmgStrength == 2)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP1_Mele_Damg_Lft_Lt' : 'AliceW_WP1_Mele_Damg_Rgt_Lt');
        }
        else if (PawnOwner.CurrentDmgStrength == 4)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP1_Mele_Damg_Hy_1' : 'AliceW_WP1_Mele_Damg_Hy_2');
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP1_Damage_Heavy_KnockBack';
        }
    }
    else if (WeaponType == 4)
    {
        if (PawnOwner.CurrentDmgStrength == 2)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP4_Damage_Lft' : 'AliceW_WP4_Damage_Rgt');
        }
        else if (PawnOwner.CurrentDmgStrength == 4)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP4_Mele_Damg_Hy_1' : 'AliceW_WP4_Mele_Damg_Hy_2');
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Damage_Heavy_KnockBack';
        }
    }
    else if (WeaponType == 2)
    {
        if (PawnOwner.CurrentDmgStrength == 2)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP2_Damage_Lft' : 'AliceW_WP2_Damage_Rgt');
        }
        else if (PawnOwner.CurrentDmgStrength == 4)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP2_Mele_Damg_Hy_1' : 'AliceW_WP2_Mele_Damg_Hy_2');
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP2_Damage_Heavy_KnockBack';
        }
    }
    else if (WeaponType == 3)
    {
        if (PawnOwner.CurrentDmgStrength == 2)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP3_Rage_Damg_Lft_Hy' : 'AliceW_WP3_Rage_Damg_Rgt_Hy');
        }
        else if (PawnOwner.CurrentDmgStrength == 4)
        {
            AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_WP3_Rage_Damg_Hy_1' : 'AliceW_WP3_Rage_Damg_Hy_2');
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Damage_Heavy_KnockBack';
        }
    }
    else if (PawnOwner.CurrentDmgStrength == 2)
    {
        AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_Damg_Bk_1' : 'AliceW_Damg_Bk_2');
    }
    else if (PawnOwner.CurrentDmgStrength == 4)
    {
        AnimCfg_Animation.AnimationNames[0] = (bLeftDir ? 'AliceW_Damg_Hy_1' : 'AliceW_Damg_Hy_2');
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_Damage_Heavy_KnockBack';
    }
}

function bool CanChainMove(ESpecialMove NextMove)
{
    if (NextMove == 13 || NextMove == 37)
    {
        return true;
    }
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    WeaponForAlice(PawnOwner.Weapon).ClearAllFireTimers();
    GetAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_WP1_Mele_Damg_Bk_Lt"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.15,BlendOutTime=0.25,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=True,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
    bStopAtLedges=True
    bStopAllConfigAnim=True
    bForceGod=True
}
