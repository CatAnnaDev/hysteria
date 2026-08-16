class ASM_Combat_Dodge extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;
var() AnimationParaConfig AnimCfg_Start;
var() AnimationParaConfig AnimCfg_End;

function bool CanChainMove(ESpecialMove NextMove)
{
    if (NextMove == 3)
    {
        return true;
    }
    return false;
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (PawnOwner.CurrentDodgeStatus == 2)
    {
        PlayDodge();
    }
    else if (PawnOwner.CurrentDodgeStatus == 3)
    {
        if (PawnOwner.Physics == 2 || PawnOwner.Physics == 17)
        {
            PawnOwner.DoSpecialMove(3, true);
        }
        else
        {
            PlayEnd();
        }
    }
    else if (PawnOwner.CurrentDodgeStatus == 4)
    {
        PawnOwner.EndSpecialMove();
    }
}

function StopEnd()
{
    PawnOwner.StopConfigAnim(AnimCfg_End, BlendOutTime);
}

function PlayEnd()
{
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.CurrentDodgeStatus = 4;
    GetEndAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_End);
}

function StopDodge()
{
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
}

function PlayDodge()
{
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.CurrentDodgeStatus = 3;
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

function StopStart()
{
    PawnOwner.StopConfigAnim(AnimCfg_Start, BlendOutTime);
}

function PlayStart()
{
    AlicePawn(PawnOwner).FadeOutWeapon();
    PawnOwner.CurrentDodgeStatus = 2;
    PawnOwner.PlayConfigAnim(AnimCfg_Start);
}

function StopCurrentMoveType()
{
    switch (PawnOwner.CurrentDodgeStatus)
    {
        case 2:
            StopStart();
            break;
        case 3:
            StopDodge();
            break;
        case 4:
            StopEnd();
            break;
        default:
    }
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.bCanBeDamaged = true;
    StopCurrentMoveType();
    PCOwner.PendingDodge = 0;
    AlicePawn(PawnOwner).FadeInWeapon();
    if (!PCOwner.bTargetingModeActive && !PCOwner.bFirstPersonViewActive)
    {
        AlicePawn(PawnOwner).SetTimerToHideWeapon();
    }
    if (EyeStaff(PawnOwner.Weapon) != none && !EyeStaff(PawnOwner.Weapon).bReleasedFireButton)
    {
        PCOwner.EyeStaffFirePress();
    }
    if (AliceCheatManager(PCOwner.CheatManager).bHoldWatchBeforeDodge)
    {
        PCOwner.TryRestoreWatch();
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    if (AlicePawn(PawnOwner) != none)
    {
        AlicePawn(PawnOwner).StopWeaponParticleTrail();
        WeaponForAlice(PawnOwner.Weapon).CleanInfoWhenBreak();
        AlicePlayerController(PawnOwner.Controller).ResetInputFlags();
    }
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimation();
    PlayStart();
    AliceCheatManager(PCOwner.CheatManager).bHoldWatchBeforeDodge = AlicePawn(PawnOwner).bHoldingWatch;
}

function GetEndAnimation()
{
    local int WeaponType;
    
    WeaponType = AlicePawn(PawnOwner).GetCurrentWeaponType();
    if (PawnOwner.DodgeDir == 2)
    {
        if (WeaponType == 4 || WeaponType == 3)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP3_Dodge_Bk_C';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP2_Dodge_Bk_C';
        }
        else
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP1_Dodge_Bk_C';
        }
    }
    else if (PawnOwner.DodgeDir == 3)
    {
        if (WeaponType == 4 || WeaponType == 3)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP3_Dodge_Lft_C';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP2_Dodge_Lft_C';
        }
        else
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP1_Dodge_Lft_C';
        }
    }
    else if (PawnOwner.DodgeDir == 4)
    {
        if (WeaponType == 4 || WeaponType == 3)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP3_Dodge_Rgt_C';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP2_Dodge_Rgt_C';
        }
        else
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP1_Dodge_Rgt_C';
        }
    }
    else if (PawnOwner.DodgeDir == 1)
    {
        if (WeaponType == 4 || WeaponType == 3)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP3_Dodge_Fwd_C';
        }
        else if (WeaponType == 2)
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP2_Dodge_Fwd_C';
        }
        else
        {
            AnimCfg_End.AnimationNames[0] = 'AliceW_WP1_Dodge_Fwd_C';
        }
    }
}

function GetAnimation()
{
    if (PawnOwner.DodgeDir == 2)
    {
        AnimCfg_Start.AnimationNames[0] = 'AliceW_WP1_Dodge_Bk_A';
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP1_Dodge_Bk_B';
    }
    else if (PawnOwner.DodgeDir == 3)
    {
        AnimCfg_Start.AnimationNames[0] = 'AliceW_WP1_Dodge_Lft_A';
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP1_Dodge_Lft_B';
    }
    else if (PawnOwner.DodgeDir == 4)
    {
        AnimCfg_Start.AnimationNames[0] = 'AliceW_WP1_Dodge_Rgt_A';
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP1_Dodge_Rgt_B';
    }
    else if (PawnOwner.DodgeDir == 1)
    {
        AnimCfg_Start.AnimationNames[0] = 'AliceW_WP1_Dodge_Fwd_A';
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_WP1_Dodge_Fwd_B';
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_WP1_Dodge_Bk_B"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=-1.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Start=(AnimationNames=("AliceW_WP1_Dodge_Bk_A"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=-1.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_End=(AnimationNames=("AliceW_WP1_Dodge_Bk_C"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=-1.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
    bStopAtLedges=True
    bCanRepeat=True
    UseCustomRMM=True
    RMMInAction="RMM_Accel"
}
