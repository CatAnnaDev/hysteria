class ASM_MeleeComboCommon extends ASM_WeaponCMABase
    notplaceable;

enum MeleeComboSM_State
{
    eMCSS_none,
    eMCSS_RushBeforeSwitch_anim,
    eMCSS_ComboAttack_anim,
    eMCSS_Transient_anim,
};

var() AnimationParaConfig AnimCfg_Animation;
var float PlayRate;
var float TransientPlayRate;
var bool WithTransientSM;
var bool IsSwitchAttack;
var bool NeedPlayRushAnimation;
var name AnimTransientName;
var name SwitchWeaponAnimationName;
var name RushBeforeSwitchAnimationName;
var name WeaponAnimationName;
var MeleeComboSM_State ComboState;
var float PresetBlendOutTime;

function ResetDefaultSpeicalMoveParam()
{
    IsSwitchAttack = false;
    NeedPlayRushAnimation = false;
    PlayRate = 1.0;
    WithTransientSM = false;
    PresetBlendOutTime = 0.1;
    ComboState = 0;
    AnimCfg_Animation.PlayRate = 1.0;
    AnimCfg_Animation.BlendInTime = 0.1;
    AnimCfg_Animation.BlendOutTime = 0.1;
}

function ResetWeaponState()
{
    local WeaponForAlice Weapon;
    
    Weapon = WeaponForAlice(PawnOwner.Weapon);
    if (Weapon != none)
    {
        Weapon.SendDeactiveMeleeAttackMessage();
        Weapon.NotifyMeleeAttackTraceParticleChange(false);
    }
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (ComboState == 1)
    {
        PlayComboAttackAnimation();
    }
    else if (ComboState == 2)
    {
        if (WithTransientSM && AnimTransientName != 'None')
        {
            PlayComboTransientAnimation();
        }
        else
        {
            if (PawnOwner.Weapon != none && PawnOwner.Weapon.IsFiring())
            {
                PawnOwner.Weapon.NotifyFireSpecialMoveFinished(PawnOwner.SpecialMove);
            }
            PawnOwner.EndSpecialMove();
        }
        if (WeaponAnimationName != 'None')
        {
            AliceGameWeaponBase(PawnOwner.Weapon).StopWeaponSlotAnim(0.1);
        }
    }
    else
    {
        if (PawnOwner.Weapon != none && PawnOwner.Weapon.IsFiring())
        {
            PawnOwner.Weapon.NotifyFireSpecialMoveFinished(PawnOwner.SpecialMove);
        }
        PawnOwner.EndSpecialMove();
    }
}

simulated function PlayComboTransientAnimation()
{
    AnimCfg_Animation.AnimationNames[0] = AnimTransientName;
    if (TransientPlayRate == float(0))
    {
        AnimCfg_Animation.PlayRate = 1.0;
    }
    else
    {
        AnimCfg_Animation.PlayRate = TransientPlayRate;
    }
    AnimCfg_Animation.BlendInTime = 0.1;
    AnimCfg_Animation.BlendOutTime = PresetBlendOutTime;
    AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
    AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
    AnimCfg_Animation.RootBoneTransitionOption[2] = 1;
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    ComboState = 3;
}

simulated function PlayComboAttackAnimation()
{
    if (IsSwitchAttack)
    {
        AnimCfg_Animation.AnimationNames[0] = SwitchWeaponAnimationName;
    }
    AnimCfg_Animation.PlayRate = PlayRate;
    PresetBlendOutTime = AnimCfg_Animation.BlendOutTime;
    AnimCfg_Animation.BlendInTime /= PlayRate;
    if (WithTransientSM)
    {
        AnimCfg_Animation.BlendOutTime = -1.0;
    }
    else
    {
        AnimCfg_Animation.BlendOutTime /= PlayRate;
    }
    AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
    AnimCfg_Animation.RootBoneTransitionOption[1] = 2;
    AnimCfg_Animation.RootBoneTransitionOption[2] = 1;
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    if (WeaponAnimationName != 'None')
    {
        AliceGameWeaponBase(PawnOwner.Weapon).PlayWeaponSlotAnim(WeaponAnimationName, PlayRate, false);
    }
    ComboState = 2;
}

simulated function PlayRushBeforeSwitchAttackAnimation()
{
    AnimCfg_Animation.AnimationNames[0] = RushBeforeSwitchAnimationName;
    AnimCfg_Animation.PlayRate = 1.0;
    AnimCfg_Animation.BlendInTime = 0.1;
    AnimCfg_Animation.BlendOutTime = PresetBlendOutTime;
    AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
    AnimCfg_Animation.RootBoneTransitionOption[1] = 2;
    AnimCfg_Animation.RootBoneTransitionOption[2] = 1;
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    ComboState = 1;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    ResetWeaponState();
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    if (!PCOwner.bTargetingModeActive && !PCOwner.bFirstPersonViewActive)
    {
        AlicePawn(PawnOwner).SetTimerToHideWeapon();
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (IsSwitchAttack && NeedPlayRushAnimation && RushBeforeSwitchAnimationName != 'None')
    {
        PlayRushBeforeSwitchAttackAnimation();
    }
    else
    {
        PlayComboAttackAnimation();
    }
    if (!PCOwner.bTargetingModeActive && !PCOwner.bFirstPersonViewActive)
    {
        AlicePawn(PawnOwner).ClearTimerToHideWeapon();
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_WP1_Mele_Attack_1"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    PlayRate=1.0
    TransientPlayRate=1.0
    AnimTransientName="NAME_None"
    WeaponAnimationName="NAME_None"
}
