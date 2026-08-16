class WeaponForAliceMelee extends WeaponForAlice
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

enum WeaponComboAttackState
{
    WCAS_NONE_PROCESSING,
    WCAS_1_PROCESSING,
    WCAS_2_PROCESSING,
    WCAS_3_PROCESSING,
    WCAS_4_PROCESSING,
    WCAS_5_PROCESSING,
    WCAS_6_PROCESSING,
};

var WeaponComboAttackState CurrentComboState;
var const ESpecialMove MeleeAttackCommonSpecialMove;
var const ESpecialMove WeaponMeleeAnimation_NoLock;
var bool bCanAcceptNextComboState;
var bool FlagAllowCancleTransient;
var(SlideToTargetOnMelee) bool EnableSlideBackOnMelee;
var(SlideToTargetOnMelee) bool EnableSlideOnMelee;
var bool FireButton_In_Pressed;
var bool bIsInTransientSM;
var int MeleeDamage[6];
var int MeleeRadiusDamage[6];
var int NoLockOnMeleeDamage[6];
var int NoLockOnMeleeRadiusDamage[6];
var int SwitchMeleeDamage;
var int ComboMaxIndex;
var array<MeleeComboInfo> WeaponMeleeComboInfo;

simulated function bool IsMeleeWeaponInComboProcess(int Index)
{
    return int(CurrentComboState) == Index;
}

function ReSetAllFlag()
{
    ReSetAllFlag();
    FlagComboBlendingStart = false;
    FlagHasComboInputBeforeBlendingStart = false;
    FlagComboInputAcceptFinish = false;
    FlagComboInputAcceptStart = false;
}

simulated function ForceEndFire()
{
    CurrentComboState = 0;
    ReSetAllFlag();
    ForceEndFire();
}

simulated function CleanInfoWhenBreak()
{
    MeleeAttackEnded();
    StopParticleTrail();
    ForceEndFire();
}

function DataSwitchForHysteria()
{
}

function ChangeWeaponLevelData(int Level)
{
    local int Index;
    
    ChangeWeaponLevelData(Level);
    if (Level - 1 >= WeaponLevelData.Length)
    {
    }
    else
    {
        if (Level != 5)
        {
            WeaponMeleeComboInfo = WeaponLevelData[Level - 1].ComboArray;
            ComboMaxIndex = WeaponMeleeComboInfo.Length;
            for (Index = 0; Index < ComboMaxIndex; Index++)
            {
                MeleeDamage[Index] = WeaponMeleeComboInfo[Index].Damage;
                MeleeRadiusDamage[Index] = WeaponMeleeComboInfo[Index].RadiusDamage;
            }
            SwitchMeleeDamage = WeaponLevelData[Level - 1].WLDP_SwitchMeleeDamage;
        }
        else
        {
            DataSwitchForHysteria();
        }
        CurrentComboState = 0;
    }
}

simulated function WeaponSetHidden(bool Set, optional bool bForce = false)
{
    if (Set == true)
    {
        FlushParticleComponent.SetTemplate(DisAppearPSCTemplate);
        FlushParticleComponent.SetActive(true);
    }
    else
    {
        FlushParticleComponent.SetTemplate(AppearPSCTemplate);
        FlushParticleComponent.SetActive(true);
    }
    Mesh.SetHidden(Set);
}

simulated function NotifyFireSpecialMoveFinished(byte SpMove)
{
    local AlicePawn pPawn;
    
    pPawn = AlicePawn(Instigator);
    if (CurrentComboState == 3)
    {
        pPawn.TriggerContextEventClass(3, 0);
    }
    AliceGameInfo(WorldInfo.Game).Achievement29 = 0;
    if (CurrentComboState != 0)
    {
        CurrentComboState = 0;
    }
    MeleeAttackEnded();
}

simulated function ComboInputAcceptStart()
{
    FlagComboInputAcceptStart = true;
    FlagComboInputAcceptFinish = false;
}

simulated function ComboInputAcceptFinish()
{
    FlagComboInputAcceptFinish = true;
    FlagComboInputAcceptStart = false;
    if (CurrentComboState == 1)
    {
        AlicePawn(Instigator).TriggerContextEventClass(14, 0);
    }
}

simulated function NotifyComboBlendingStart()
{
    FlagComboBlendingStart = true;
    if (FlagHasComboInputBeforeBlendingStart == true && Instigator.Physics == 1)
    {
        if (IsInState('Inactive'))
        {
            GotoState('Active');
        }
        StartFire(1);
        ReSetAllFlag();
    }
}

simulated function MeleeAttackEnded(optional bool bResetState = true)
{
    SendDeactiveMeleeAttackMessage();
    ClearPendingFire(int(CurrentFireMode));
    if (bResetState)
    {
        GotoState('Active');
    }
}

simulated event NotifyMeleeAttackTraceParticleChange(bool bActive)
{
    FlushParticleComponent.SetActive(false);
}

simulated function bool CanPerformNextAction()
{
    if (CurrentComboState != 0)
    {
        return false;
    }
    if (FlagComboInputAcceptStart == false || FlagComboInputAcceptFinish == true)
    {
        return false;
    }
    if (FlagComboBlendingStart == false)
    {
        FlagHasComboInputBeforeBlendingStart = true;
        return false;
    }
    return true;
}

function bool UpdateMeleeComboInputState()
{
    if (FlagComboFromOtherWeapon == true && IsInState('Active'))
    {
        return true;
    }
    if (FlagComboInputAcceptFinish == true && FlagAllowCancleTransient == true)
    {
        NotifyFireSpecialMoveFinished(0);
        return true;
    }
    if (bIsSlideToTarget)
    {
        return false;
    }
    if (int(CurrentComboState) == ComboMaxIndex)
    {
        return false;
    }
    if (FlagComboInputAcceptStart == false || FlagComboInputAcceptFinish == true)
    {
        return false;
    }
    if (FlagComboBlendingStart == false)
    {
        FlagHasComboInputBeforeBlendingStart = true;
        return false;
    }
    return true;
}

simulated function PreSlideToTarget(Vector DeltaPos, ESpecialMove SM_Slide)
{
    local AlicePawn pPawn;
    
    pPawn = AlicePawn(Instigator);
    if (CurrentComboState == 0 && pPawn != none)
    {
        bIsSlideToTarget = true;
        pPawn.bSlidingToTarget = true;
        pPawn.DoSpecialMove(SM_Slide, true);
        SetPawnSlideToTargetParameters(DeltaPos, PawnSlideToTargetDuration);
        SetTimer(PawnSlideToTargetDuration, false, 'PostSlideToTarget');
    }
}

simulated function PostSlideToTarget()
{
}

function SetSwitchMoveParam(AlicePawn aPawn)
{
    local ASM_MeleeComboCommon SpecialMoveInstance;
    local AlicePawn pPawn;
    local AlicePlayerController APC;
    local Vector vOffset;
    
    aPawn.VerifySMHasBeenInstanced(MeleeAttackCommonSpecialMove);
    SpecialMoveInstance = ASM_MeleeComboCommon(aPawn.SpecialMoves[int(MeleeAttackCommonSpecialMove)]);
    SpecialMoveInstance.bCanRepeat = true;
    if (SpecialMoveInstance != none)
    {
        SpecialMoveInstance.ResetDefaultSpeicalMoveParam();
        SpecialMoveInstance.IsSwitchAttack = true;
        SpecialMoveInstance.NeedPlayRushAnimation = false;
        if (MinSwitchJudgeDist > float(0) && MaxSwitchJudgeDist > float(0))
        {
            pPawn = AlicePawn(Instigator);
            APC = AlicePlayerController(pPawn.Controller);
            if (APC != none && APC.TargetingActor != none)
            {
                if (Pawn(APC.TargetingActor) != none)
                {
                    vOffset = APC.TargetingActor.Location - pPawn.Location;
                    if (VSizeSq2D(vOffset) > MinSwitchJudgeDist * MinSwitchJudgeDist && VSizeSq2D(vOffset) < MaxSwitchJudgeDist * MaxSwitchJudgeDist)
                    {
                        SpecialMoveInstance.NeedPlayRushAnimation = true;
                    }
                }
            }
        }
        SpecialMoveInstance.RushBeforeSwitchAnimationName = RushBeforeSwitchComboAnimationName;
        SpecialMoveInstance.SwitchWeaponAnimationName = SwitchWeaponAnimationName;
    }
}

function SetSpecialMoveParam(AlicePawn aPawn, WeaponComboAttackState TheCurrentState)
{
    local ASM_MeleeComboCommon SpecialMoveInstance;
    
    aPawn.VerifySMHasBeenInstanced(MeleeAttackCommonSpecialMove);
    SpecialMoveInstance = ASM_MeleeComboCommon(aPawn.SpecialMoves[int(MeleeAttackCommonSpecialMove)]);
    SpecialMoveInstance.bCanRepeat = true;
    if (SpecialMoveInstance != none)
    {
        SpecialMoveInstance.ResetDefaultSpeicalMoveParam();
        SpecialMoveInstance.AnimCfg_Animation.AnimationNames[0] = WeaponMeleeComboInfo[int(TheCurrentState)].AnimationName;
        SpecialMoveInstance.AnimTransientName = WeaponMeleeComboInfo[int(TheCurrentState)].AnimationTransientName;
        SpecialMoveInstance.WeaponAnimationName = WeaponMeleeComboInfo[int(TheCurrentState)].WeaponAnimationName;
        SpecialMoveInstance.PlayRate = WeaponMeleeComboInfo[int(TheCurrentState)].PlayRate;
        SpecialMoveInstance.WithTransientSM = true;
        SpecialMoveInstance.TransientPlayRate = WeaponMeleeComboInfo[int(TheCurrentState)].TransientPlayRate;
        SpecialMoveInstance.AnimCfg_Animation.BlendInTime = WeaponMeleeComboInfo[int(TheCurrentState)].BlendInTime;
        SpecialMoveInstance.AnimCfg_Animation.BlendOutTime = WeaponMeleeComboInfo[int(TheCurrentState)].BlendOutTime;
        FlagAllowCancleTransient = WeaponMeleeComboInfo[int(TheCurrentState)].CanBreakTransient;
    }
}

simulated event bool IsFiring()
{
    return false;
}

function bool AllowSwitchOtherWeapon()
{
    if (IsFiring() && !FlagComboBlendingStart)
    {
        return false;
    }
    return true;
}

simulated function PressFireButton()
{
    local AlicePawn pPawn;
    
    pPawn = AlicePawn(Instigator);
    if (IsInState('WeaponPuttingDown') || IsInState('WeaponEquipping'))
    {
        return;
    }
    if (pPawn != none)
    {
        pPawn.ClearDelayAttachWeapon();
        StartFire(1);
    }
}

simulated function ResetWeaponInput()
{
    FireButton_In_Pressed = false;
}

simulated function ReleaseFireButton()
{
}

simulated function StartFire(byte FireModeNum)
{
    if (int(FireModeNum) == 1)
    {
        if (CurrentComboState == 0 && !bIsSlideToTarget)
        {
            StartFire(FireModeNum);
            return;
        }
        else if (UpdateMeleeComboInputState())
        {
            StartFire(FireModeNum);
            return;
        }
    }
}

function UpdateAchievement29()
{
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        local AlicePlayerController APC;
        
        if (bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        GotoState('Active');
        APC = AlicePlayerController(AlicePawn(Instigator).Controller);
        if (APC != none && APC.bTargetingModeActive && Instigator.PrevWeapon != none || !APC.bTargetingModeActive)
        {
            if (APC.bSwitchWeaponOnly)
            {
                APC.bSwitchWeaponOnly = false;
                AlicePawn(Instigator).DelayWeaponFadeIn();
            }
            else
            {
                APC.MeleeFire();
                ReleaseFireButton();
            }
        }
    }
    
    Stop;
}

state AliceWeaponMeleeFire
{
    simulated function bool ShouldSlideToTargetWhenFire(out Vector DeltaPos, out ESpecialMove SM_Slide)
    {
        return false;
    }
    
    simulated function FirstMeleeAttackStarted()
    {
        local AlicePawn pPawn;
        
        pPawn = AlicePawn(Instigator);
        NotifyMeleeAttackTraceParticleChange(false);
        if (CurrentComboState == 0)
        {
            NotifyLockTargetAttackHappen(WeaponTypeEnum);
            SetSpecialMoveParam(pPawn, CurrentComboState);
            pPawn.DoSpecialMove(MeleeAttackCommonSpecialMove, true);
            CurrentComboState = byte(int(CurrentComboState) + 1);
            ReSetAllFlag();
            bIsSlideToTarget = false;
            pPawn.bSlidingToTarget = false;
        }
        else if (FlagComboFromOtherWeapon)
        {
            UpdateAchievement29();
            SetSwitchMoveParam(pPawn);
            pPawn.DoSpecialMove(MeleeAttackCommonSpecialMove, true);
            FlagComboFromOtherWeapon = false;
            ReSetAllFlag();
        }
    }
    
    simulated function BeginFire(byte FireModeNum)
    {
        local AlicePawn pPawn;
        local Vector DeltaPos;
        local ESpecialMove SM_Slide;
        
        if (!bDeleteMe && Instigator != none)
        {
            pPawn = AlicePawn(Instigator);
            if (ShouldSlideToTargetWhenFire(DeltaPos, SM_Slide))
            {
                PreSlideToTarget(DeltaPos, SM_Slide);
            }
            else if (int(CurrentComboState) <= ComboMaxIndex - 1)
            {
                Global.BeginFire(FireModeNum);
                NotifyMeleeAttackTraceParticleChange(false);
                NotifyLockTargetAttackHappen(WeaponTypeEnum);
                SetSpecialMoveParam(pPawn, CurrentComboState);
                pPawn.DoSpecialMove(MeleeAttackCommonSpecialMove, true);
                CurrentComboState = byte(int(CurrentComboState) + 1);
                ReSetAllFlag();
            }
        }
    }
    
    simulated event EndState(name NextStateName)
    {
        bIsSlideToTarget = false;
        FireButton_In_Pressed = false;
        ReSetAllFlag();
        if (NextStateName == 'WeaponPuttingDown')
        {
            MeleeAttackEnded(false);
        }
        else
        {
            MeleeAttackEnded();
        }
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        local AlicePawn pPawn;
        local Vector DeltaPos;
        local ESpecialMove SM_Slide;
        
        pPawn = AlicePawn(Instigator);
        if (int(CurrentFireMode) == 1)
        {
            if (pPawn != none)
            {
                if (ShouldSlideToTargetWhenFire(DeltaPos, SM_Slide))
                {
                    PreSlideToTarget(DeltaPos, SM_Slide);
                }
                else
                {
                    FirstMeleeAttackStarted();
                }
                ReSetAllFlag();
            }
        }
    }
    
    simulated function bool TryPutDown()
    {
        PutDownWeapon();
        return true;
    }
    
    simulated event bool IsFiring()
    {
        return true;
    }
    
    Stop;
}

defaultproperties
{
    MeleeAttackCommonSpecialMove="SM_MeleeComboCommon"
    FlushParticleComponent="Default__WeaponForAliceMelee.ParticleSystemComponent0"
    ChargeParticleComponent="Default__WeaponForAliceMelee.ParticleSystemComponent1"
    AudioChargeComp="Default__WeaponForAliceMelee.ChargeSound"
    AudioChargeCompleteSound="Default__WeaponForAliceMelee.CCS"
    PawnSlideToTargetDuration=-1.0
    WeaponFireWaveForm="Default__WeaponForAliceMelee.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__WeaponForAliceMelee.ForceFeedbackWaveformShooting2"
    MeleeAttackActorList="Default__WeaponForAliceMelee.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__WeaponForAliceMelee.RadiusAttackActorinfo"
    Mesh="Default__WeaponForAliceMelee.WeaponMesh"
    Components(0)="Default__WeaponForAliceMelee.ChargeSound"
    Components(1)="Default__WeaponForAliceMelee.CCS"
}
