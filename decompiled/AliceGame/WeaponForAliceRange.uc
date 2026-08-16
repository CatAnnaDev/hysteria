class WeaponForAliceRange extends WeaponForAlice
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var export editinline ParticleSystemComponent NormalMuzzleParticle;
var const array<ESpecialMove> WeaponRangeAnimation;
var float RangeIntervalTime;
var(Weapon) float AttackTimeTap;
var(RangeWeapon) name WeaponMuzzleSocket;
var bool bReleasedFireButton;
var bool bFinishCharge;
var bool bOverHeat;
var bool bInFullRefillTime;
var bool bInvalidFire;
var transient bool bSwitchWeaponFire;
var transient bool bReleasedFireButtonWhilePendingFire;
var float OverHeatTime;
var float RegenDelayTime;
var float RegenRate;
var float FullRefillTime;
var float MagicValue;

function ClearOverHeatTimeOver()
{
    ClearTimer('OnOverHeatTimeOver');
}

function ResetAliceWeapon()
{
    bOverHeat = false;
    bInFullRefillTime = false;
    ClearTimer('OnOverHeatTimeOver');
    ClearAllFireTimers();
    GotoState('Inactive');
    MagicValue = float(MaxAmmoCount);
    if (AlicePawn(Instigator).Weapon == self)
    {
        UpdateAmmoUI();
    }
}

function OnOverHeatTimeOver()
{
}

simulated event bool AdjustFireSocketRotation(out Rotator SocketRotation, Vector TargetLocation)
{
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

simulated event Vector GetMuzzleLoc()
{
    local Vector OutLocation;
    
    if (Mesh != none)
    {
        Mesh.GetSocketWorldLocationAndRotation(WeaponMuzzleSocket, OutLocation);
        return OutLocation;
    }
    else
    {
        return GetMuzzleLoc();
    }
}

simulated function SkeletalMeshComponent GetMuzzleSocketMesh()
{
    if (Instigator != none)
    {
        return Instigator.Mesh;
    }
    return none;
}

simulated function AttachOwnerData()
{
    Mesh.AttachComponentToSocket(FlushParticleComponent, ChargeCompleteSocket);
    Mesh.AttachComponentToSocket(ChargeParticleComponent, ChargeSocket);
    Mesh.AttachComponentToSocket(NormalMuzzleParticle, WeaponMuzzleSocket);
}

function StopSounds()
{
    if (AudioChargeComp != none)
    {
        AudioChargeComp.Stop();
    }
    if (AudioChargeCompleteSound != none)
    {
        AudioChargeCompleteSound.Stop();
    }
}

simulated function PlayChargedFiringSound()
{
    local int soundIndex;
    
    if (WeaponChargedFireSnd.Length != 0)
    {
        soundIndex = Rand(WeaponChargedFireSnd.Length);
        if (WeaponChargedFireSnd[soundIndex] != none)
        {
            MakeNoise(1.0);
            WeaponPlaySound(WeaponChargedFireSnd[soundIndex]);
        }
    }
}

simulated function PlayFiringSound()
{
    local int soundIndex;
    
    if (WeaponFireSnd.Length != 0)
    {
        soundIndex = Rand(WeaponFireSnd.Length);
        if (WeaponFireSnd[soundIndex] != none)
        {
            MakeNoise(1.0);
            WeaponPlaySound(WeaponFireSnd[soundIndex]);
        }
    }
}

function StopAllParticlesAndSounds()
{
    AudioChargeComp.Stop();
    AudioChargeCompleteSound.Stop();
    NormalMuzzleParticle.DeactivateSystem();
    ChargeParticleComponent.DeactivateSystem();
}

function ChangeWeaponLevelData(int Level)
{
    ChangeWeaponLevelData(Level);
    if (Level - 1 >= WeaponLevelData.Length)
    {
    }
    else
    {
        WeaponFireSnd = WeaponLevelData[Level - 1].WLDP_RangeFireSoundCue;
        WeaponChargedFireSnd = WeaponLevelData[Level - 1].WLDP_ChargedRangeFireSoundCue;
    }
}

simulated function ClearAllFireTimers()
{
    ClearTimer('SingleRechargeTimer');
    ClearTimer('ChargeCheckTimer');
    ClearTimer('RefireCheckTimer');
    ClearTimer('CheckFireInteruptTimer');
    ClearTimer('TapCheckTimer');
}

simulated function CheckFireInteruptTimer()
{
}

simulated function ChargeCheckTimer()
{
}

simulated function TapCheckTimer()
{
}

simulated function Projectile ProjectileFire()
{
    local AliceGameProjectile tempProj;
    
    tempProj = AliceGameProjectile(ProjectileFire());
    if (tempProj != none)
    {
        tempProj.WeaponLevel = GetWeaponLevel();
        tempProj.WeaponOwner = self;
        if (bSuperDamage)
        {
            tempProj.Damage = 9000000.0;
        }
    }
    return tempProj;
}

simulated function TimeWeaponFiring(byte FireModeNum)
{
    if (!IsTimerActive('TapCheckTimer'))
    {
        SetTimer(FireInterval[0], true, 'RefireCheckTimer');
        SetTimer(TapTime, false, 'TapCheckTimer');
    }
}

simulated function EndCurrentSpecialMove(optional bool bStopAllAnim = true)
{
    if (AlicePawn(Instigator).IsDoingRangeBlendSpecialMove())
    {
        AlicePawn(Instigator).DoSpecialMove(0);
        if (bStopAllAnim)
        {
            AlicePawn(Instigator).StopAllConfigAnim(0.2);
        }
    }
}

simulated function PlayChargeCompleteSpecialMove(optional bool bForceMove = true)
{
    AlicePawn(Instigator).DoSpecialMove(WeaponRangeAnimation[2], bForceMove);
}

simulated function PlayChargeSpecialMove(optional bool bForceMove = true)
{
    AlicePawn(Instigator).DoSpecialMove(WeaponRangeAnimation[1], bForceMove);
}

simulated function PlayFireSpecialMove(optional bool bForceMove = true)
{
    AlicePawn(Instigator).DoSpecialMove(WeaponRangeAnimation[0], bForceMove);
}

simulated function PlayDefaultRangeAttackSpecialMove()
{
    AlicePawn(Instigator).DoSpecialMove(WeaponRangeAnimation[0], true);
}

simulated function ForceEndFire()
{
    ForceEndFire();
    EndCurrentSpecialMove();
    bInUse = false;
}

simulated function NotifyFireSpecialMoveFinished(byte SpMove)
{
    local AlicePawn pPawn;
    local AlicePlayerController APC;
    
    pPawn = AlicePawn(Instigator);
    if (pPawn == none)
    {
        return;
    }
    APC = AlicePlayerController(pPawn.Controller);
    if (APC == none)
    {
        return;
    }
}

function bool IsTargetingModeActive()
{
    return AlicePlayerController(Instigator.Controller).bTargetingModeActive;
}

simulated function ReleaseFireButton()
{
    if (IsTimerActive('CheckFireInteruptTimer'))
    {
        bReleasedFireButton = true;
    }
}

simulated function PressFireButton()
{
    if (IsInState('WeaponPuttingDown') || IsInState('WeaponEquipping'))
    {
        return;
    }
    StartFire(0);
}

simulated function StartFire(byte FireModeNum)
{
    if (int(FireModeNum) == 0)
    {
        if (!HasAmmo(FireModeNum) && NoAmmoSound != none)
        {
            Instigator.PlaySound(NoAmmoSound, true);
        }
        else
        {
            StartFire(FireModeNum);
        }
        return;
    }
}

function UpdateAmmoUI()
{
}

function UpdateAmmo(float DeltaTime)
{
    if (bInFullRefillTime)
    {
        MagicValue += DeltaTime * float(MaxAmmoCount) / FullRefillTime;
        AmmoCount = int(MagicValue);
        if (AmmoMaxed(0))
        {
            bInFullRefillTime = false;
            RefillAmmoFinished();
            if (AlicePawn(Instigator).Weapon == self)
            {
                GotoState('Active');
            }
            if (!bReleasedFireButton && !AlicePawn(Instigator).bInShield && !AlicePawn(Instigator).bHoldingWatch && !AlicePlayerController(Instigator.Controller).bCinematicMode)
            {
                EndCurrentSpecialMove();
                AlicePawn(Instigator).FadeInWeapon();
                PressFireButton();
            }
        }
    }
    else if (!IsTimerActive('OnRegenDelayOver'))
    {
        MagicValue += DeltaTime * RegenRate;
        AmmoCount = int(MagicValue);
        if (AmmoMaxed(0))
        {
            RefillAmmoFinished();
        }
    }
}

function RefillAmmoFinished()
{
}

function ConsumeAmmo(byte FireModeNum)
{
    ConsumeAmmo(FireModeNum);
    MagicValue = float(AmmoCount);
    ClearTimer('OnRegenDelayOver');
    SetTimer(RegenDelayTime, false, 'OnRegenDelayOver');
}

function OnRegenDelayOver()
{
}

event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    if (AmmoMaxed(0))
    {
        MagicValue = float(MaxAmmoCount);
    }
    else if (!bOverHeat)
    {
        UpdateAmmo(DeltaTime);
        UpdateAmmoUI();
    }
}

simulated function NotifyComboBlendingStart()
{
    FlagComboBlendingStart = true;
    if (FlagHasComboInputBeforeBlendingStart == true)
    {
        if (IsInState('Inactive'))
        {
            GotoState('Active');
        }
        StartFire(1);
        ReSetAllFlag();
    }
}

function ReSetAllFlag()
{
    ReSetAllFlag();
    FlagComboBlendingStart = false;
    FlagHasComboInputBeforeBlendingStart = false;
    FlagComboInputAcceptFinish = false;
    FlagComboInputAcceptStart = false;
}

simulated function ComboInputAcceptFinish()
{
    FlagComboInputAcceptFinish = true;
    FlagComboInputAcceptStart = false;
}

simulated function ComboInputAcceptStart()
{
    FlagComboInputAcceptStart = true;
    FlagComboInputAcceptFinish = false;
}

simulated function bool CanPerformNextAction()
{
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

simulated function PostBeginPlay()
{
    RangeIntervalTime = FireInterval[0];
    PostBeginPlay();
}

state AliceWeaponRangeFire extends RangeFireBaseState
{
    simulated function FireAmmunition()
    {
        PlayDefaultRangeAttackSpecialMove();
        FireAmmunition();
    }
    
    simulated event EndState(name NextStateName)
    {
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('CheckFireInteruptTimer');
        ClearTimer('ChargeCheckTimer');
        ClearTimer('RefireCheckTimer');
        ClearTimer('TapCheckTimer');
        NotifyWeaponFinishedFiring(CurrentFireMode);
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        if (FlagComboFromOtherWeapon == true)
        {
            EndCurrentSpecialMove();
            FlagComboFromOtherWeapon = false;
        }
        TimeWeaponFiring(CurrentFireMode);
    }
    
    simulated function ChargeCheckTimer()
    {
        if (!IsTimerActive('RefireCheckTimer'))
        {
            if (ShouldRefire())
            {
                EndCharge();
                ClearTimer('CheckFireInteruptTimer');
                Mesh.AttachComponentToSocket(ChargeParticleComponent, ChargeCompleteSocket);
                ChargeParticleComponent.SetTemplate(ChargeFinishPSCTemplate);
                ChargeParticleComponent.SetActive(true);
                if (AudioChargeComp != none)
                {
                    AudioChargeComp.Stop();
                }
                if (AudioChargeCompleteSound != none)
                {
                    AudioChargeCompleteSound.Play();
                }
                SetTimer(RangeIntervalTime, true, 'RefireCheckTimer');
            }
            else
            {
                HandleFinishedFiring();
            }
        }
    }
    
    simulated function TapCheckTimer()
    {
        if (!IsTimerActive('ChargeCheckTimer'))
        {
            if (ShouldRefire())
            {
                if (ChargeTime > float(0))
                {
                    SetTimer(ChargeTime, false, 'ChargeCheckTimer');
                    Mesh.AttachComponentToSocket(ChargeParticleComponent, ChargeSocket);
                    ChargeParticleComponent.SetTemplate(ChargePSCTemplate);
                    ChargeParticleComponent.ActivateSystem();
                    ChargeParticleComponent.SetActive(true);
                    BeginCharge();
                    if (AudioChargeComp != none)
                    {
                        AudioChargeComp.Play();
                    }
                }
                else
                {
                    SetTimer(RangeIntervalTime, true, 'RefireCheckTimer');
                }
            }
            else
            {
                HandleFinishedFiring();
            }
        }
    }
    
    simulated function SingleRechargeTimer()
    {
        ClearTimer('SingleRechargeTimer');
    }
    
    simulated event EndCharge()
    {
    }
    
    simulated event BeginCharge()
    {
    }
    
    simulated function CheckFireInteruptTimer()
    {
        if (!ShouldRefire() && !IsTimerActive('SingleRechargeTimer'))
        {
            SetTimer(AttackTimeTap, true, 'SingleRechargeTimer');
            FireAmmunition();
            HandleFinishedFiring();
        }
    }
    
    simulated function RefireCheckTimer()
    {
        if (bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        if (ShouldRefire())
        {
            FireAmmunition();
            return;
        }
        HandleFinishedFiring();
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

state RangeFireBaseState
{
    simulated function ReleaseFireButton()
    {
        bReleasedFireButton = true;
    }
    
    simulated function PressFireButton()
    {
        bReleasedFireButton = false;
    }
    
    Stop;
}

defaultproperties
{
    NormalMuzzleParticle="Default__WeaponForAliceRange.ParticleSystemComponentMuzzleFlash1"
    WeaponRangeAnimation(0)=94
    ChargeCompleteSocket="ChargeSocket"
    ChargeSocket="ChargeSocket"
    FlushParticleComponent="Default__WeaponForAliceRange.ParticleSystemComponent0"
    ChargeParticleComponent="Default__WeaponForAliceRange.ParticleSystemComponent1"
    NoAmmoSound="SFX_Combat.Flail_No_Ammo_Cue"
    AudioChargeComp="Default__WeaponForAliceRange.ChargeSound"
    AudioChargeCompleteSound="Default__WeaponForAliceRange.CCS"
    WeaponFireWaveForm="Default__WeaponForAliceRange.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__WeaponForAliceRange.ForceFeedbackWaveformShooting2"
    MeleeAttackActorList="Default__WeaponForAliceRange.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__WeaponForAliceRange.RadiusAttackActorinfo"
    Mesh="Default__WeaponForAliceRange.WeaponMesh"
    Components(0)="Default__WeaponForAliceRange.ChargeSound"
    Components(1)="Default__WeaponForAliceRange.CCS"
    Components(2)="Default__WeaponForAliceRange.ParticleSystemComponentMuzzleFlash1"
}
