class TeapotCannon extends WeaponForAliceRange
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

struct TeapotCannonLevelDataPackage
{
    var() float RegenRate;
    var() float RegenDelayTimePerAmmo;
    var() int InitAmmoCount;
    var() int MaxAmmo;
    var() int OverHeatTime;
    var() float ChargeTime;
    var() float FullRefillTime;
    var() float DamageValueCore;
    var() float DamageValueSplash;
    var() float NormalCoreRadius;
    var() float NormalSplashRadius;
    var() float ChargedCoreRadius;
    var() float ChargedSplashRadius;
    var() export AliceExplosionLightTemplate RadiusAttackLightTemplate;
    var() ParticleSystem ChargedProjectileParticle;
    var() ParticleSystem ChargedImpactParticle;
};

var const byte NORMAL_FIRE;
var const byte CHARGED_FIRE;
var() EDamageStrengthType DamageStrengthCore;
var() EDamageStrengthType DamageStrengthSplash;
var export AliceExplosionLightTemplate RadiusAttackLightTemplate;
var() PhysicalMaterial ExplodePhysMaterial;
var() PhysicalMaterial ChargedExplodePhysMaterial;
var() array<TeapotCannonLevelDataPackage> TeapotCannonLevelData;
var() float ParticleFireInterval;
var() float BlastDelay;
var() float FireDelayTime;
var(TeapotCannonSound) SoundCue NormalFireSound;
var(TeapotCannonSound) SoundCue ChargedFireSound;
var(TeapotCannonSound) SoundCue FullyChargedSound;
var(TeapotCannonSound) SoundCue FirstPressTriggerSound;
var(TeapotCannonSound) SoundCue BeginChargeSound;
var(TeapotCannonSound) SoundCue LoopChargeSound;
var export editinline AudioComponent LoopChargeAudio;
var export editinline AudioComponent BeginChargeAudio;
var export editinline AudioComponent FirstPressTriggerAudio;
var float DamageValueCore;
var float DamageValueSplash;
var float NormalCoreRadius;
var float NormalSplashRadius;
var float ChargedCoreRadius;
var float ChargedSplashRadius;
var float ChargeFinishedTime;
var transient ParticleSystem ChargedProjFlightParticle;
var transient ParticleSystem ChargedProjImpactParticle;
var bool bModAttackDamage;
var(DLC) float MODAttackDamage_Percent;
var(DLC) ParticleSystem DLCChargedProjectileParticle;
var(DLC) ParticleSystem DLCChargedImpactParticle;

function ResetWeaponAfterChangeLevel()
{
    bFinishCharge = false;
    bOverHeat = false;
    bInFullRefillTime = false;
    MagicValue = 1.0;
    UpdateAmmoUI();
    MagicValue = float(MaxAmmoCount);
    UpdateAmmoUI();
    if (IsTimerActive('OnOverHeatTimeOver'))
    {
        ClearTimer('OnOverHeatTimeOver');
    }
    if (IsInState('WeaponOverHeatState'))
    {
        GotoState('Active');
    }
}

function PlayChangeWeaponSound()
{
}

function ScriptSetProjectileInitPara(AliceGameProjectile Proj)
{
    local TeapotCannonProjectile tempProj;
    
    tempProj = TeapotCannonProjectile(Proj);
    if (tempProj != none)
    {
        tempProj.RadiusAttackLightTemplate = RadiusAttackLightTemplate;
        if (CurrentFireMode == 1)
        {
            tempProj.ProjFlightEffectTemplate = ChargedProjFlightParticle;
            tempProj.ChargedImpactParticle = ChargedProjImpactParticle;
        }
        else
        {
            tempProj.ChargedImpactParticle = none;
        }
    }
}

function OnOverHeatTimeOver()
{
    bOverHeat = false;
    bInFullRefillTime = true;
}

simulated function WeaponEmpty()
{
    HandleFinishedFiring();
    GotoState('WeaponOverHeatState');
}

function RefillAmmoFinished()
{
    PlayWeaponSlotAnim('WP4_NoAmmo_C', , false);
}

function ChargedFire()
{
    local TeapotCannonProjectile Proj;
    local AlicePawn pAlice;
    local float MODAliceAttackInc, currentMultiplier;
    
    currentMultiplier = 1.0;
    MODAliceAttackInc = 1.0;
    pAlice = AlicePawn(Instigator);
    if (pAlice != none)
    {
        MODAliceAttackInc = 1.0 + pAlice.AttackInc_Percent;
    }
    PlayChargedFiringSound();
    Proj = TeapotCannonProjectile(ProjectileFire());
    if (Proj != none)
    {
        Proj.DamageCoreValue = DamageValueCore;
        Proj.DamageSplashValue = DamageValueSplash;
        Proj.DamageCoreStrength = DamageStrengthCore;
        Proj.DamageSplashStrength = DamageStrengthSplash;
        Proj.DamageCoreRadius = ChargedCoreRadius;
        Proj.DamageSplashRadius = ChargedSplashRadius;
        Proj.DamageRadius = ChargedSplashRadius;
        Proj.bChargedProjectile = true;
        if (bModAttackDamage)
        {
            Proj.Damage = Proj.Damage * (1.0 + MODAttackDamage_Percent);
            Proj.DamageCoreValue = Proj.DamageCoreValue * (1.0 + MODAttackDamage_Percent);
            Proj.DamageSplashValue = Proj.DamageSplashValue * (1.0 + MODAttackDamage_Percent);
        }
        Proj.Damage *= MODAliceAttackInc;
        Proj.DamageCoreValue *= MODAliceAttackInc;
        Proj.DamageSplashValue *= MODAliceAttackInc;
        currentMultiplier = AliceGameInfo(WorldInfo.Game).AliceWeaponDamageMultiplier[AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty()];
        Proj.Damage *= currentMultiplier;
        Proj.DamageCoreValue *= currentMultiplier;
        Proj.DamageSplashValue *= currentMultiplier;
        Proj.ExplodePhysMaterial = ChargedExplodePhysMaterial;
    }
    if (FireInterval.Length >= 2)
    {
        SetTimer(FireInterval[1], false, 'CoolingTimer');
    }
}

function NormalFire()
{
    local TeapotCannonProjectile Proj;
    local AlicePawn pAlice;
    local float MODAliceAttackInc, currentMultiplier;
    
    currentMultiplier = 1.0;
    MODAliceAttackInc = 1.0;
    pAlice = AlicePawn(Instigator);
    if (pAlice != none)
    {
        MODAliceAttackInc = 1.0 + pAlice.AttackInc_Percent;
    }
    PlayFiringSound();
    Proj = TeapotCannonProjectile(ProjectileFire());
    if (Proj != none)
    {
        Proj.DamageCoreValue = DamageValueCore;
        Proj.DamageSplashValue = DamageValueSplash;
        Proj.DamageCoreStrength = DamageStrengthCore;
        Proj.DamageSplashStrength = DamageStrengthSplash;
        Proj.DamageCoreRadius = NormalCoreRadius;
        Proj.DamageSplashRadius = NormalSplashRadius;
        Proj.DamageRadius = NormalSplashRadius;
        Proj.bChargedProjectile = false;
        if (bModAttackDamage)
        {
            Proj.Damage = Proj.Damage * (1.0 + MODAttackDamage_Percent);
            Proj.DamageCoreValue = Proj.DamageCoreValue * (1.0 + MODAttackDamage_Percent);
            Proj.DamageSplashValue = Proj.DamageSplashValue * (1.0 + MODAttackDamage_Percent);
        }
        Proj.Damage *= MODAliceAttackInc;
        Proj.DamageCoreValue *= MODAliceAttackInc;
        Proj.DamageSplashValue *= MODAliceAttackInc;
        currentMultiplier = AliceGameInfo(WorldInfo.Game).AliceWeaponDamageMultiplier[AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty()];
        Proj.Damage *= currentMultiplier;
        Proj.DamageCoreValue *= currentMultiplier;
        Proj.DamageSplashValue *= currentMultiplier;
        Proj.ExplodePhysMaterial = ExplodePhysMaterial;
    }
    if (FireInterval.Length >= 1)
    {
        SetTimer(FireInterval[0], false, 'CoolingTimer');
    }
}

function StartChargedFire()
{
    CurrentFireMode = CHARGED_FIRE;
    ClearTimer('RefireCheckTimer');
    PlayFireSpecialMove();
    Global.FireAmmunition();
    if (ChargedFireSound != none)
    {
        PlaySound(ChargedFireSound);
    }
    if (LoopChargeAudio != none)
    {
        LoopChargeAudio.Stop();
    }
}

function StartNormalFire()
{
    if (!bSwitchWeaponFire && IsWeaponHidden() || IsWeaponFadeToHide())
    {
        return;
    }
    if (HasAnyAmmo())
    {
        bSwitchWeaponFire = false;
        CurrentFireMode = NORMAL_FIRE;
        ChargeParticleComponent.KillParticlesForced();
        ClearTimer('RefireCheckTimer');
        AlicePawn(Instigator).LeaveSprintState();
        NormalMuzzleParticle.SetActive(true);
        Global.FireAmmunition();
        if (NormalFireSound != none)
        {
            PlaySound(NormalFireSound);
        }
        if (LoopChargeAudio != none)
        {
            LoopChargeAudio.Stop();
        }
    }
}

simulated function FireAmmunition()
{
    NotifyLockTargetAttackHappen(WeaponTypeEnum);
    ConsumeAmmo(CurrentFireMode);
    if (CurrentFireMode == CHARGED_FIRE)
    {
        ChargedFire();
    }
    else
    {
        NormalFire();
    }
    NotifyWeaponFired(CurrentFireMode);
    HandleFinishedFiring();
    StopFire(CurrentFireMode);
}

function StopCharging()
{
    if (!bFinishCharge)
    {
        bInvalidFire = false;
        HandleFinishedFiring();
        StopFire(CurrentFireMode);
    }
}

simulated function ChangeDLCData()
{
    ChangeDLCData();
    if (GetDLCWeaponFlag() == 1)
    {
        bModAttackDamage = true;
        if (DLCChargedProjectileParticle != none)
        {
            ChargedProjFlightParticle = DLCChargedProjectileParticle;
        }
        if (DLCChargedImpactParticle != none)
        {
            ChargedProjImpactParticle = DLCChargedImpactParticle;
        }
    }
}

simulated function ChangeLevelData(int Level)
{
    ChangeLevelData(Level);
    if (Level <= TeapotCannonLevelData.Length)
    {
        AmmoCount = TeapotCannonLevelData[Level - 1].InitAmmoCount;
        MaxAmmoCount = TeapotCannonLevelData[Level - 1].MaxAmmo;
        RegenRate = TeapotCannonLevelData[Level - 1].RegenRate;
        RegenDelayTime = TeapotCannonLevelData[Level - 1].RegenDelayTimePerAmmo;
        OverHeatTime = float(TeapotCannonLevelData[Level - 1].OverHeatTime);
        ChargeTime = TeapotCannonLevelData[Level - 1].ChargeTime;
        FullRefillTime = TeapotCannonLevelData[Level - 1].FullRefillTime;
        if (Level != 5)
        {
            DamageValueCore = TeapotCannonLevelData[Level - 1].DamageValueCore;
            DamageValueSplash = TeapotCannonLevelData[Level - 1].DamageValueSplash;
        }
        NormalCoreRadius = TeapotCannonLevelData[Level - 1].NormalCoreRadius;
        NormalSplashRadius = TeapotCannonLevelData[Level - 1].NormalSplashRadius;
        ChargedCoreRadius = TeapotCannonLevelData[Level - 1].ChargedCoreRadius;
        ChargedSplashRadius = TeapotCannonLevelData[Level - 1].ChargedSplashRadius;
        RadiusAttackLightTemplate = TeapotCannonLevelData[Level - 1].RadiusAttackLightTemplate;
        NormalMuzzleParticle.SetTemplate(WeaponLevelData[Level - 1].WLDP_Particle_Muzzle);
        ChargedProjFlightParticle = TeapotCannonLevelData[Level - 1].ChargedProjectileParticle;
        ChargedProjImpactParticle = TeapotCannonLevelData[Level - 1].ChargedImpactParticle;
    }
}

simulated function int GetDLCWeaponFlag()
{
    if (AliceGameInfo(WorldInfo.Game).GetIsDLC_TC_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_TC_Enable())
    {
        return 1;
    }
    return 0;
}

simulated function HandleFinishedFiring()
{
    bInvalidFire = false;
    ClearTimer('CheckFireInteruptTimer');
    ClearTimer('ChargeCheckTimer');
    ClearTimer('RefireCheckTimer');
    ClearTimer('TapCheckTimer');
    HandleFinishedFiring();
}

simulated function PressFireButton()
{
    if (bSwitchWeaponFire)
    {
        bSwitchWeaponFire = false;
        if (bReleasedFireButtonWhilePendingFire)
        {
            bReleasedFireButtonWhilePendingFire = false;
            SetTimer(0.1, false, 'ReleaseFireButton');
        }
    }
    if (IsInState('WeaponPuttingDown') || IsInState('WeaponEquipping'))
    {
        return;
    }
    StartFire(0);
    bReleasedFireButton = false;
}

simulated function ReleaseFireButton()
{
    if (!bSwitchWeaponFire)
    {
        if (!bReleasedFireButton && bInvalidFire && HasAnyAmmo())
        {
            bReleasedFireButton = true;
            StopAllParticlesAndSounds();
            if (bFinishCharge && HasAmmo(CHARGED_FIRE, ShotCost[int(CHARGED_FIRE)]))
            {
                StartChargedFire();
            }
            else
            {
                ClearTimer('TapCheckTimer');
                EndCurrentSpecialMove();
                PlayFireSpecialMove();
                if (FireDelayTime > float(0))
                {
                    SetTimer(FireDelayTime, false, 'StartNormalFire');
                }
                else
                {
                    StartNormalFire();
                }
            }
        }
        bReleasedFireButton = true;
    }
    else
    {
        bReleasedFireButtonWhilePendingFire = true;
    }
}

function bool IsCharging()
{
    if (bFinishCharge || AliceGamePawn(Instigator).IsDoingSpecialMove(21))
    {
        return true;
    }
    else
    {
        return false;
    }
}

final function StopChargingEffect()
{
}

final function StartChargingEffect()
{
}

function bool CanFire()
{
    if (IsTimerActive('FireDelayTime'))
    {
        return false;
    }
    if (AlicePawn(Instigator).IsDoingSpecialMove(20))
    {
        return false;
    }
    if (bInFullRefillTime)
    {
        return false;
    }
    if (IsTimerActive('CoolingTimer'))
    {
        return false;
    }
    return true;
}

function CoolingTimer()
{
}

function forceUpdateAmmoUI()
{
    AliceGameInfo(WorldInfo.Game).forceUpdateTeapotCannonAmmo();
}

function UpdateAmmoUI()
{
    AliceGameInfo(WorldInfo.Game).UpdateTeapotCannonAmmo(MagicValue, float(MaxAmmoCount));
}

function UpdateAmmo(float DeltaTime)
{
    local int oldAmmoCount;
    
    oldAmmoCount = AmmoCount;
    if (bInFullRefillTime)
    {
        MagicValue += DeltaTime * RegenRate;
        AmmoCount = int(MagicValue);
        if (AmmoCount > 0)
        {
            SetTimer(RegenDelayTime, false, 'OnRegenDelayOver');
            bInFullRefillTime = false;
            RefillAmmoFinished();
            if (AlicePawn(Instigator).Weapon == self)
            {
                GotoState('Active');
            }
            if (!bReleasedFireButton)
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
        else if (AmmoCount > oldAmmoCount)
        {
            SetTimer(RegenDelayTime, false, 'OnRegenDelayOver');
        }
    }
}

simulated function StartFire(byte FireModeNum)
{
    if (CanFire())
    {
        StartFire(FireModeNum);
        bInvalidFire = true;
        if (int(FireModeNum) == 0)
        {
            StartFire(FireModeNum);
            if (!HasAmmo(FireModeNum) && NoAmmoSound != none)
            {
                Instigator.PlaySound(NoAmmoSound, true);
            }
        }
    }
    else
    {
        bInvalidFire = false;
    }
}

simulated function PostBeginPlay()
{
    bModAttackDamage = false;
    PostBeginPlay();
    MagicValue = float(AmmoCount);
    UpdateAmmoUI();
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        local AlicePawn pPawn;
        local AlicePlayerController APC;
        
        WeaponEquipped();
        UpdateAmmoUI();
        NormalMuzzleParticle.KillParticlesForced();
        pPawn = AlicePawn(Instigator);
        if (pPawn == none)
        {
            return;
        }
        pPawn.DelayWeaponFadeIn();
        APC = AlicePlayerController(pPawn.Controller);
        if (APC == none)
        {
            return;
        }
        if (IsInState('Inactive'))
        {
            GotoState('Active');
        }
        if (APC.bSwitchWeaponOnly)
        {
            APC.bSwitchWeaponOnly = false;
        }
        else if (!APC.bEnterFPSByRSPress)
        {
            bSwitchWeaponFire = true;
            SetTimer(0.15, false, 'PressFireButton');
        }
    }
    
    Stop;
}

simulated state WeaponPuttingDown
{
    simulated event EndState(name NextStateName)
    {
        EndState(NextStateName);
        ClearTimer('CoolingTimer');
    }
    
    Stop;
}

state AliceWeaponRangeFire
{
    simulated function ChargeCheckTimer()
    {
        if (!IsTimerActive('RefireCheckTimer'))
        {
            EndCharge();
            Mesh.AttachComponentToSocket(ChargeParticleComponent, ChargeCompleteSocket);
            ChargeParticleComponent.SetTemplate(ChargeFinishPSCTemplate);
            ChargeParticleComponent.SetActive(true);
        }
    }
    
    simulated function CheckFireInteruptTimer()
    {
    }
    
    simulated event EndCharge()
    {
        bFinishCharge = true;
        AlicePawn(Instigator).EndSpecialMove(21);
        ChargeFinishedTime = WorldInfo.TimeSeconds;
        if (FullyChargedSound != none)
        {
            PlaySound(FullyChargedSound);
        }
        if (LoopChargeAudio == none)
        {
            if (LoopChargeSound != none)
            {
                LoopChargeAudio = CreateAudioComponent(LoopChargeSound);
            }
        }
        if (LoopChargeAudio != none)
        {
            LoopChargeAudio.Play();
        }
    }
    
    simulated event BeginCharge()
    {
        AlicePawn(Instigator).StopAllConfigAnim(0.05);
        PlayChargeSpecialMove();
        if (BeginChargeAudio == none)
        {
            if (BeginChargeSound != none)
            {
                BeginChargeAudio = CreateAudioComponent(BeginChargeSound);
                BeginChargeAudio.Play();
            }
        }
        else
        {
            BeginChargeAudio.Play();
        }
        if (FirstPressTriggerAudio == none)
        {
            if (FirstPressTriggerSound != none)
            {
                FirstPressTriggerAudio = CreateAudioComponent(FirstPressTriggerSound);
                FirstPressTriggerAudio.Play();
            }
        }
        else
        {
            FirstPressTriggerAudio.Play();
        }
    }
    
    simulated function TimeWeaponFiring(byte FireModeNum)
    {
        ClearTimer('TapCheckTimer');
        SetTimer(TapTime, false, 'TapCheckTimer');
    }
    
    simulated event EndState(name NextStateName)
    {
        EndState(NextStateName);
        if (BeginChargeAudio != none)
        {
            BeginChargeAudio.Stop();
        }
        if (FirstPressTriggerAudio != none)
        {
            FirstPressTriggerAudio.Stop();
        }
        if (LoopChargeAudio != none && bFinishCharge)
        {
            LoopChargeAudio.Stop();
        }
        StopFire(CurrentFireMode);
        bFinishCharge = false;
        StopWeaponSlotAnim(0.1);
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        bFinishCharge = false;
    }
    
    simulated function ReleaseFireButton()
    {
        Global.ReleaseFireButton();
        bReleasedFireButton = true;
    }
    
    simulated function PressFireButton()
    {
        Global.PressFireButton();
        bReleasedFireButton = false;
    }
    
    Stop;
}

state WeaponOverHeatState extends RangeFireBaseState
{
    function PlayNoAmmoIdleAnimation()
    {
        PlayWeaponSlotAnim('WP4_NoAmmo_B', , true, 0.2);
    }
    
    simulated function bool TryPutDown()
    {
        PutDownWeapon();
        return true;
    }
    
    simulated function ReleaseFireButton()
    {
        ReleaseFireButton();
        if (IsTimerActive('OnOverHeatTimeOver'))
        {
        }
    }
    
    simulated function PressFireButton()
    {
        PressFireButton();
        if (NoAmmoSound != none)
        {
            Instigator.PlaySound(NoAmmoSound, true);
        }
    }
    
    simulated function NotifyFireSpecialMoveFinished(byte SpMove)
    {
        if (int(SpMove) == 20 && !HasAmmo(0))
        {
            PlayWeaponSlotAnim('WP4_NoAmmo_A', , false);
            SetTimer(0.2, false, 'PlayNoAmmoIdleAnimation');
        }
        NotifyFireSpecialMoveFinished(SpMove);
    }
    
    simulated event EndState(name NextStateName)
    {
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        if (!bInFullRefillTime && !bOverHeat)
        {
            bOverHeat = true;
            ClearAllPendingFire();
            SetTimer(OverHeatTime, false, 'OnOverHeatTimeOver');
        }
        UpdateAmmoUI();
    }
    
    Stop;
}

simulated state Active
{
    simulated event EndState(name NextStateName)
    {
    }
    
    simulated event BeginState(name PreStateName)
    {
        BeginState(PreStateName);
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.changeRangedWeapon(1);
    }
    
    Stop;
}

state Inactive
{
    simulated function ReleaseFireButton()
    {
        bReleasedFireButton = true;
    }
    
    Stop;
}

defaultproperties
{
    CHARGED_FIRE=1
    RadiusAttackLightTemplate=(TimeShift=(),HighDetailFrameTime=0.15,bCheckFrameRate=False,CastShadows=False)
    ParticleFireInterval=0.5
    BlastDelay=1.0
    FireDelayTime=0.15
    NormalFireSound="SFX_TC.sfx_teacannon_fire01_Cue"
    ChargedFireSound="SFX_TC.sfx_teacannon_fire_charged01_Cue"
    FullyChargedSound="SFX_TC.sfx_teacannon_charged_tell_Cue"
    FirstPressTriggerSound="SFX_TC.sfx_teacannon_charge_a01_Cue"
    BeginChargeSound="SFX_TC.sfx_teacannon_charge_b01_Cue"
    LoopChargeSound="SFX_TC.sfx_teacannon_charged_loop_Cue"
    DamageValueCore=500.0
    DamageValueSplash=1000.0
    MODAttackDamage_Percent=0.25
    NormalMuzzleParticle="Default__TeapotCannon.ParticleSystemComponentMuzzleFlash1"
    WeaponRangeAnimation(0)=122
    WeaponRangeAnimation(1)=66
    WeaponMuzzleSocket="Weapon_Muzzle1"
    OverHeatTime=5.0
    RegenRate=1.0
    TapTime=0.05
    ChargeTime=0.5
    WeaponTypeEnum="EAWT_TeapotCannon"
    WeaponLevelData(0)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp4",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="TeapotCannonProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    WeaponLevelData(1)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp4",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="TeapotCannonProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    WeaponLevelData(2)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp4",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="TeapotCannonProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    WeaponLevelData(3)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp4",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="TeapotCannonProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    FlushParticleComponent="Default__TeapotCannon.ParticleSystemComponent0"
    ChargeParticleComponent="Default__TeapotCannon.ParticleSystemComponent1"
    NoAmmoSound="SFX_TC.sfx_teacannon_no_ammo_Cue"
    AudioChargeComp="Default__TeapotCannon.ChargeSound"
    AudioChargeCompleteSound="Default__TeapotCannon.CCS"
    AmmoCount=10
    WeaponFireWaveForm="Default__TeapotCannon.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__TeapotCannon.ForceFeedbackWaveformShooting2"
    ManuallyCurveType="EProjManualCurve_Type3"
    WeaponFireSnd(0)="SFX_Combat.VorpalBlade_Range_Cue"
    MuzzleFlashPSCTemplate="GFX_Weapons.VorpalBlade.VB_R_Muzzle_L4"
    MuzzleFlashLightClass="AliceBoomshotLight"
    RangeAttackSocket="RangeFireLoc"
    SelfCollisionPhysicsAsset(0)="CH_Alice_Graphic.PhysicsAsset.SK_Wp3_Physics"
    MeleeAttackActorList="Default__TeapotCannon.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__TeapotCannon.RadiusAttackActorinfo"
    FiringStatesArray(0)="AliceWeaponRangeFire"
    WeaponFireTypes(0)=250
    WeaponFireTypes(1)=30
    WeaponProjectiles(0)="TeapotCannonProjectile"
    WeaponProjectiles(1)="TeapotCannonProjectile"
    FireInterval(0)=0.5
    FireInterval(1)=0.5
    Spread(0)=0.0
    InstantHitDamage(0)=5.0
    InstantHitMomentum(0)=0.0
    InstantHitDamageTypes(0)="DmgType_TeapotCannon_RangeProjectile"
    WeaponRange=22000.0
    WeaponMeleeRange=300.0
    Mesh="Default__TeapotCannon.WeaponMesh"
    Components(0)="Default__TeapotCannon.ChargeSound"
    Components(1)="Default__TeapotCannon.CCS"
    Components(2)="Default__TeapotCannon.ParticleSystemComponentMuzzleFlash1"
    Components(3)="Default__TeapotCannon.WeaponMesh"
}
