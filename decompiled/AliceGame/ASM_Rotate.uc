class ASM_Rotate extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimation();
    if (AlicePawn(PawnOwner).IsPawnInAStance(1))
    {
        AlicePawn(PawnOwner).SetPawnStance(0);
    }
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

function GetAnimation()
{
    local int WeaponType;
    
    if (AlicePawn(PawnOwner).IsInShadowMode())
    {
        AnimCfg_Animation.PlayRate = 2.0;
    }
    else
    {
        AnimCfg_Animation.PlayRate = 1.0;
    }
    WeaponType = AlicePawn(PawnOwner).GetCurrentWeaponType();
    if (AlicePawn(PawnOwner).IsPawnInAStance(2))
    {
        if (PawnOwner.AngleToRotate > float(0))
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_Attached_Idle_Turn_Right_Short';
            PawnOwner.RootRotationFactor = PawnOwner.AngleToRotate / 3.1415927 * float(2);
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_Attached_Idle_Turn_Left_Short';
            PawnOwner.RootRotationFactor = -PawnOwner.AngleToRotate / 3.1415927 * float(2);
        }
    }
    else if (PawnOwner.AngleToRotate > float(0))
    {
        if (WeaponType == 1)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceL_Idle_Turn_Right_Short';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP2_Idle_Turn_Right_Short';
        }
        else if (WeaponType == 3)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Idle_Turn_Right_Short';
        }
        else if (WeaponType == 4)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Idle_Turn_Right_Short';
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceL_Idle_Turn_Right_Short';
        }
        PawnOwner.RootRotationFactor = PawnOwner.AngleToRotate / 3.1415927 * float(2);
    }
    else
    {
        if (WeaponType == 1)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceL_Idle_Turn_Left_Short';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP2_Idle_Turn_Left_Short';
        }
        else if (WeaponType == 3)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP3_Idle_Turn_Left_Short';
        }
        else if (WeaponType == 4)
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP4_Idle_Turn_Left_Short';
        }
        else
        {
            AnimCfg_Animation.AnimationNames[0] = 'AliceL_Idle_Turn_Left_Short';
        }
        PawnOwner.RootRotationFactor = -PawnOwner.AngleToRotate / 3.1415927 * float(2);
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceL_Idle_TurnRight"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Discard",RootBoneRotationOption[1]="RRO_Discard",RootBoneRotationOption[2]="RRO_Extract",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableLook=True
    bStopAllConfigAnim=True
    UseCustomRRM=True
    RRMInAction="RMRM_RotateActor"
}
