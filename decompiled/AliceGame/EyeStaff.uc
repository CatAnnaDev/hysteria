class EyeStaff extends WeaponForAliceRange
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

struct native EyeStaffLevelDataPackage
{
    var() float RegenDelayTime;
    var() float RegenRate;
    var() int InitAmmoCount;
    var() int MaxAmmo;
    var() int OverHeatTime;
    var() float ChargeTime;
    var() float FullRefillTime;
    var() array<int> ShotCost;
    var() array<float> FireInterval;
    var() export AliceExplosionLightTemplate MuzzleLightTemplate;
};

var const byte NORMAL_FIRE;
var const byte CHARGED_FIRE;
var() name MuzzleLightSocket;
var export AliceExplosionLightTemplate MuzzleLightTemplate;
var() Emitter MuzzleParticleActor;
var() array<EyeStaffLevelDataPackage> EyeStaffLevelData;
var() float ParticleFireInterval;
var() array<name> FireSocketArray;
var() SoundCue TriggerOnSound;
var() SoundCue WindDownSound;
var() SoundCue WindUpSound;
var() SoundCue GrindSound;
var(DLC) export AliceExplosionLightTemplate DLCMuzzleLightTemplate;
var export editinline AudioComponent GrindAudioComp;
var export editinline AudioComponent WindUpAudioComp;
var(PoisonParticle) float Radius;
var(PoisonParticle) float DamageInterval;
var(PoisonParticle) float SmokeDamage;
var(PoisonParticle) float Lifetime;
var(PoisonParticle) ParticleSystem PoisonSmokeParticle;
var(Weapon) float DoubleTapsTime;
var(Weapon) float DoubleTapsFireTime;
var(Weapon) float WindUpDelay;
var(DLC) float DLCModMaxAmmo_Percent;
var int ProjIndex;

function ResetWeaponAfterChangeLevel()
{
    bFinishCharge = true;
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

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    local Rotator R;
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Instigator.Controller);
    if (Instigator != none)
    {
        R = Instigator.GetAdjustedAimFor(self, StartFireLoc);
    }
    if (APC != none && APC.IsInState('FirstPersonView'))
    {
        return R;
    }
    else
    {
        return AddSpread(R);
    }
}

function PlayGrindSound(bool bPlay)
{
    if (bPlay)
    {
        if (!HasAmmo(CurrentFireMode))
        {
            return;
        }
        GrindAudioComp.FadeIn(FireInterval[0], 1.0);
    }
    else
    {
        GrindAudioComp.FadeOut(0.05, 0.0);
    }
}

function PlayWindDownSound()
{
    if (!HasAmmo(CurrentFireMode) || bOverHeat || bInFullRefillTime || !bReleasedFireButton)
    {
        return;
    }
    if (IsInState('NormalFireState') && WindDownSound != none)
    {
        Instigator.PlaySound(WindDownSound, true);
    }
}

function PlayWindUpSound(bool bPlay)
{
    if (bPlay)
    {
        if (!HasAmmo(CurrentFireMode))
        {
            return;
        }
        WindUpAudioComp.Stop();
        WindUpAudioComp.Play();
    }
    else
    {
        WindUpAudioComp.FadeOut(0.05, 0.0);
    }
}

function PlayTriggerOnSound()
{
    if (!HasAmmo(CurrentFireMode))
    {
        return;
    }
    if (TriggerOnSound != none)
    {
        Instigator.PlaySound(TriggerOnSound, true);
    }
}

simulated function WeaponEmpty()
{
    HandleFinishedFiring();
    GotoState('WeaponOverHeatState');
}

function OnOverHeatTimeOver()
{
    bOverHeat = false;
    bInFullRefillTime = true;
}

simulated function ReleaseFireButton()
{
    if (!bSwitchWeaponFire)
    {
        bReleasedFireButton = true;
    }
    else
    {
        bReleasedFireButtonWhilePendingFire = true;
    }
}

function DoubleTapsFire()
{
    local PepperGrinderAlternateProjectile Proj;
    local AlicePawn pAlice;
    local float MODAliceAttackInc, currentMultiplier;
    
    currentMultiplier = 1.0;
    MODAliceAttackInc = 1.0;
    pAlice = AlicePawn(Instigator);
    if (pAlice != none)
    {
        MODAliceAttackInc = 1.0 + pAlice.AttackInc_Percent;
    }
    CurrentFireMode = CHARGED_FIRE;
    ConsumeAmmo(CurrentFireMode);
    PlayChargedFiringSound();
    Proj = PepperGrinderAlternateProjectile(ProjectileFire());
    if (Proj != none)
    {
        Proj.InitConfigData(Radius, DamageInterval, SmokeDamage, Lifetime, PoisonSmokeParticle);
        Proj.Damage *= MODAliceAttackInc;
        currentMultiplier = AliceGameInfo(WorldInfo.Game).AliceWeaponDamageMultiplier[AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty()];
        Proj.Damage *= currentMultiplier;
    }
    PlayWindDownSound();
    NotifyWeaponFired(CurrentFireMode);
    AlicePawn(Instigator).TriggerContextEventClass(2, 0);
    HandleFinishedFiring();
    if (!bReleasedFireButton)
    {
        GotoState('NormalFireState');
        CurrentFireMode = NORMAL_FIRE;
        StartFire(NORMAL_FIRE);
    }
    else
    {
        GotoState('Active');
    }
}

function NormalFire()
{
    local PepperGrinderPrimaryProjectile Proj;
    local AlicePawn pAlice;
    local float MODAliceAttackInc, currentMultiplier;
    local Vector ImpactLoc;
    local Rotator ImpactRot;
    
    if (MuzzleParticleActor == none)
    {
        MuzzleParticleActor = Spawn(class'Engine.EmitterSpawnable', , , GetMuzzleLoc(), rot(0, 0, 0));
        MuzzleParticleActor.SetTemplate(WeaponLevelData[0].WLDP_Particle_Muzzle);
    }
    currentMultiplier = 1.0;
    MODAliceAttackInc = 1.0;
    pAlice = AlicePawn(Instigator);
    if (pAlice != none)
    {
        MODAliceAttackInc = 1.0 + pAlice.AttackInc_Percent;
    }
    if (!bReleasedFireButton && !NormalMuzzleParticle.bIsActive)
    {
        AlicePawn(Instigator).TriggerContextEventClass(1, 0);
    }
    MuzzleParticleActor.SetLocation(GetMuzzleLoc());
    Mesh.GetSocketWorldLocationAndRotation(WeaponMuzzleSocket, ImpactLoc, ImpactRot);
    MuzzleParticleActor.SetRotation(ImpactRot);
    MuzzleParticleActor.ParticleSystemComponent.SetActive(true);
    ConsumeAmmo(CurrentFireMode);
    PlayFiringSound();
    Proj = PepperGrinderPrimaryProjectile(ProjectileFire());
    if (Proj != none)
    {
        Proj.Damage *= MODAliceAttackInc;
        currentMultiplier = AliceGameInfo(WorldInfo.Game).AliceWeaponDamageMultiplier[AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty()];
        Proj.Damage *= currentMultiplier;
    }
    NotifyWeaponFired(CurrentFireMode);
}

simulated function FireAmmunition()
{
    NotifyLockTargetAttackHappen(WeaponTypeEnum);
    if (CurrentFireMode == CHARGED_FIRE)
    {
    }
    else
    {
        NormalFire();
    }
}

simulated event CauseMuzzleFlashLight()
{
    local Vector MuzzleLoc;
    local AliceExplosionLight Light;
    
    MuzzleLoc = GetMuzzleLightLoc();
    Light = AliceGameEmitterPool(WorldInfo.MyEmitterPool).SpawnTemplateExplosionLight(MuzzleLightTemplate, MuzzleLoc);
    Light.ResetLight();
}

simulated function Vector GetMuzzleLightLoc()
{
    local Vector OutLocation;
    
    if (GetWeaponMesh() != none && GetWeaponMesh().GetSocketWorldLocationAndRotation(MuzzleLightSocket, OutLocation))
    {
        return OutLocation;
    }
    else
    {
        return GetMuzzleLoc();
    }
}

simulated function ChangeDLCData()
{
    ChangeDLCData();
    if (GetDLCWeaponFlag() == 1)
    {
        MaxAmmoCount = int(float(MaxAmmoCount) * (1.0 + DLCModMaxAmmo_Percent));
        MuzzleLightTemplate = DLCMuzzleLightTemplate;
        if (MuzzleParticleActor != none)
        {
            MuzzleParticleActor.SetTemplate(DLCPackage.WLDP_Particle_Muzzle);
            MuzzleParticleActor.ParticleSystemComponent.SetActive(false);
        }
    }
}

simulated function int GetDLCWeaponFlag()
{
    if (AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_Enable())
    {
        return 1;
    }
    return 0;
}

simulated function ChangeLevelData(int Level)
{
    ChangeLevelData(Level);
    if (Level <= EyeStaffLevelData.Length)
    {
        AmmoCount = EyeStaffLevelData[Level - 1].InitAmmoCount;
        MaxAmmoCount = EyeStaffLevelData[Level - 1].MaxAmmo;
        RegenDelayTime = EyeStaffLevelData[Level - 1].RegenDelayTime;
        RegenRate = EyeStaffLevelData[Level - 1].RegenRate;
        OverHeatTime = float(EyeStaffLevelData[Level - 1].OverHeatTime);
        ChargeTime = EyeStaffLevelData[Level - 1].ChargeTime;
        ShotCost = EyeStaffLevelData[Level - 1].ShotCost;
        FireInterval = EyeStaffLevelData[Level - 1].FireInterval;
        FullRefillTime = EyeStaffLevelData[Level - 1].FullRefillTime;
        MuzzleLightTemplate = EyeStaffLevelData[Level - 1].MuzzleLightTemplate;
        if (MuzzleParticleActor != none)
        {
            MuzzleParticleActor.SetTemplate(WeaponLevelData[Level - 1].WLDP_Particle_Muzzle);
            MuzzleParticleActor.ParticleSystemComponent.SetActive(false);
        }
    }
}

simulated function HandleFinishedFiring()
{
    PlayGrindSound(false);
    bInvalidFire = false;
    ClearAllFireTimers();
    StopAllParticlesAndSounds();
    if (MuzzleParticleActor != none)
    {
        MuzzleParticleActor.ParticleSystemComponent.SetActive(false);
    }
    StopFire(NORMAL_FIRE);
    StopFire(CHARGED_FIRE);
    FlushParticleComponent.DeactivateSystem();
    FlushParticleComponent.SetActive(false);
    ChargeParticleComponent.DeactivateSystem();
    ChargeParticleComponent.SetActive(false);
    if (IsTimerActive('DoubleTapsFire'))
    {
        ClearTimer('DoubleTapsFire');
        GotoState('Active');
    }
}

simulated function NotifyFireSpecialMoveFinished(byte SpMove)
{
    if (bReleasedFireButton || !(int(SpMove) == 24))
    {
        StopWeaponSlotAnim(0.1);
        HandleFinishedFiring();
    }
    else
    {
        CurrentFireMode = NORMAL_FIRE;
        PressFireButton();
        TimeWeaponFiring(CurrentFireMode);
    }
    if (int(SpMove) == 22)
    {
        PlayWindDownSound();
    }
    NotifyFireSpecialMoveFinished(SpMove);
}

simulated event bool IsFiring()
{
    if (IsFiring())
    {
        return true;
    }
    return false;
}

simulated function PressFireButton()
{
    bReleasedFireButton = false;
    if (bSwitchWeaponFire)
    {
        bSwitchWeaponFire = false;
        if (bReleasedFireButtonWhilePendingFire)
        {
            bReleasedFireButtonWhilePendingFire = false;
            SetTimer(0.1, false, 'ReleaseFireButton');
        }
    }
    PlayTriggerOnSound();
    PressFireButton();
}

function bool CanFire()
{
    if (!bInFullRefillTime)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function forceUpdateAmmoUI()
{
    AliceGameInfo(WorldInfo.Game).forceUpdateEyestaffAmmo();
}

function UpdateAmmoUI()
{
    AliceGameInfo(WorldInfo.Game).UpdateEyestaffAmmo(MagicValue, float(MaxAmmoCount));
}

function bool AllowSwitchOtherWeapon()
{
    if (IsFiring())
    {
        return false;
    }
    return true;
}

simulated function StartFire(byte FireModeNum)
{
    if (CanFire())
    {
        StartFire(FireModeNum);
        bInvalidFire = true;
    }
    else
    {
        bInvalidFire = false;
    }
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    MagicValue = float(AmmoCount);
    UpdateAmmoUI();
    GrindAudioComp.SoundCue = GrindSound;
    WindUpAudioComp.SoundCue = WindUpSound;
}

native simulated function ResetProjectileInitPara(AliceGameProjectile Projectile)
{
    Projectile;
}

state WeaponOverHeatState extends RangeFireBaseState
{
    simulated function bool TryPutDown()
    {
        PutDownWeapon();
        return true;
    }
    
    simulated function ReleaseFireButton()
    {
        ReleaseFireButton();
        EndCurrentSpecialMove();
    }
    
    simulated function PressFireButton()
    {
        PressFireButton();
        AlicePawn(Instigator).StopAllConfigAnim(0.05);
        AlicePawn(Instigator).DoSpecialMove(23, true);
    }
    
    event Tick(float DeltaTime)
    {
        Tick(DeltaTime);
        if (bOverHeat && !bReleasedFireButton && !AlicePawn(Instigator).IsDoingSpecialMove(23))
        {
            AlicePawn(Instigator).DoSpecialMove(23, true);
        }
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        if (!bReleasedFireButton)
        {
            AlicePawn(Instigator).StopAllConfigAnim(0.05);
        }
        MagicValue = 0.0;
        UpdateAmmoUI();
        if (!bInFullRefillTime && !bOverHeat)
        {
            bOverHeat = true;
            SetTimer(OverHeatTime, false, 'OnOverHeatTimeOver');
        }
    }
    
    Stop;
}

state NormalFireState extends RangeFireBaseState
{
    simulated function bool TryPutDown()
    {
        PutDownWeapon();
        return true;
    }
    
    function MiniFireTimeOver()
    {
        if (bReleasedFireButton)
        {
            if (AlicePawn(Instigator).IsDoingRangeBlendSpecialMove())
            {
                AlicePawn(Instigator).DoSpecialMove(26, true);
            }
            GotoState('Active');
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
            Global.FireAmmunition();
        }
        else
        {
            GotoState('Active');
        }
    }
    
    simulated function ReleaseFireButton()
    {
        ReleaseFireButton();
        if (!IsTimerActive('MiniFireTimeOver'))
        {
            AlicePawn(Instigator).DoSpecialMove(26, true);
            GotoState('Active');
        }
    }
    
    simulated event EndState(name PreviousStateName)
    {
        ClearTimer('MiniFireTimeOver');
        ClearTimer('RefireCheckTimer');
        if (!AlicePawn(Instigator).IsDoingSpecialMove(26))
        {
            EndCurrentSpecialMove();
        }
        HandleFinishedFiring();
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        AlicePawn(Instigator).ClearTimer('DelayAttachWeapon');
        if (PreviousStateName != 'WindUpState')
        {
            AlicePawn(Instigator).StopAllConfigAnim(0.05);
            PlayGrindSound(true);
            PlayWindUpSound(true);
            PlayFireSpecialMove();
        }
        SetTimer(0.5, false, 'MiniFireTimeOver');
        SetTimer(FireInterval[0], true, 'RefireCheckTimer');
    }
    
    Stop;
}

simulated state Active
{
    simulated event BeginState(name PreStateName)
    {
        BeginState(PreStateName);
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.changeRangedWeapon(0);
    }
    
    Stop;
}

state WindUpState extends RangeFireBaseState
{
    function WindUpTimer()
    {
        GotoState('NormalFireState');
    }
    
    simulated function ReleaseFireButton()
    {
        ReleaseFireButton();
        AlicePawn(Instigator).DoSpecialMove(26, true);
        GotoState('Active');
    }
    
    simulated event EndState(name PreviousStateName)
    {
        ClearTimer('WindUpTimer');
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        AlicePawn(Instigator).StopAllConfigAnim(0.05);
        PlayGrindSound(true);
        PlayWindUpSound(true);
        PlayFireSpecialMove();
        SetTimer(WindUpDelay, false, 'WindUpTimer');
    }
    
    Stop;
}

state AliceWeaponRangeFire
{
    simulated function ReleaseFireButton()
    {
        ReleaseFireButton();
        if (IsTimerActive('TapCheckTimer'))
        {
            if (!IsTargetingModeActive())
            {
                ClearTimer('TapCheckTimer');
                GotoState('NormalFireState');
            }
        }
    }
    
    simulated function TapCheckTimer()
    {
        if (WindUpDelay > 0.0)
        {
            GotoState('WindUpState');
        }
        else
        {
            GotoState('NormalFireState');
        }
    }
    
    simulated function TimeWeaponFiring(byte FireModeNum)
    {
        if (WindUpDelay > 0.0)
        {
            GotoState('WindUpState');
        }
        else
        {
            GotoState('NormalFireState');
        }
    }
    
    simulated event EndState(name PreviousStateName)
    {
        EndState(PreviousStateName);
        ClearTimer('TapCheckTimer');
    }
    
    Stop;
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
            SetTimer(0.2, false, 'PressFireButton');
        }
    }
    
    Stop;
}

defaultproperties
{
    CHARGED_FIRE=1
    MuzzleLightTemplate=(TimeShift=(),HighDetailFrameTime=0.15,bCheckFrameRate=False,CastShadows=False)
    ParticleFireInterval=0.5
    FireSocketArray(0)="Weapon_Muzzle1"
    FireSocketArray(1)="Weapon_Muzzle2"
    FireSocketArray(2)="Weapon_Muzzle3"
    TriggerOnSound="SFX_PepperGrinder.sfx_pepperg_triggeron_Cue"
    WindDownSound="SFX_PepperGrinder.sfx_pepperg_off_Cue"
    WindUpSound="SFX_PepperGrinder.sfx_pepperg_windup_Cue"
    GrindSound="SFX_PepperGrinder.sfx_pepperg_grind_Cue"
    DLCMuzzleLightTemplate=(TimeShift=(),HighDetailFrameTime=0.15,bCheckFrameRate=False,CastShadows=False)
    GrindAudioComp="Default__EyeStaff.AudioComponent0"
    WindUpAudioComp="Default__EyeStaff.AudioComponent1"
    Radius=100.0
    DamageInterval=1.0
    SmokeDamage=10.0
    Lifetime=10.0
    DoubleTapsTime=0.1
    DoubleTapsFireTime=0.3
    WindUpDelay=1.0
    DLCModMaxAmmo_Percent=0.25
    NormalMuzzleParticle="Default__EyeStaff.ParticleSystemComponentMuzzleFlash1"
    WeaponRangeAnimation(0)=76
    WeaponRangeAnimation(1)=66
    WeaponRangeAnimation(2)=0
    WeaponMuzzleSocket="Weapon_Muzzle1"
    OverHeatTime=5.0
    RegenRate=1.0
    TapTime=0.05
    ChargeTime=0.5
    WeaponTypeEnum="EAWT_EyeStaff"
    WeaponLevelData(0)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp3",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="PepperGrinderPrimaryProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    WeaponLevelData(1)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp3",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="PepperGrinderPrimaryProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    WeaponLevelData(2)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp3",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="PepperGrinderPrimaryProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    WeaponLevelData(3)=(WLDP_SkeletalMesh="CH_Alice.SK_Wp3",WLDP_Particle_Trail="GFX_Weapons.hatterstaff.HF_M_Trail_L4",WLDP_WeaponEffect=(),WLDP_Particle_Muzzle="GFX_Weapons.hatterstaff.HF_R_Muzzle_L4",AttachedLoopingParticleArray=(),WLDP_RangeFireSoundCue=("SFX_Combat.Flail_Range_Fire_02_Cue","SFX_Combat.Flail_Range_Fire_01_Cue"),WLDP_ChargedRangeFireSoundCue=(),WLDP_Project1="PepperGrinderPrimaryProjectile",WLDP_RunningNoLockMeleeDamage=0,WLDP_SwitchMeleeDamage=0,ProjectilePackage=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[1]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ProjectilePackage[2]=(PorjectTileLightEffect="None",AccelRate=0.0,Speed=0.0,MaxSpeed=0.0,Damage=0.0,DamageRadius=0.0,MinShotDist=0.0,MaxShotDist=0.0,CheckRadius=0.0,RadiusDamageTime=0.0,RagdollImpulseScale=0.0,KnockBackID=0),ComboArray=())
    FlushParticleComponent="Default__EyeStaff.ParticleSystemComponent0"
    ChargeParticleComponent="Default__EyeStaff.ParticleSystemComponent1"
    AudioChargeComp="Default__EyeStaff.ChargeSound"
    AudioChargeCompleteSound="Default__EyeStaff.CCS"
    AmmoCount=10
    WeaponFireWaveForm="Default__EyeStaff.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__EyeStaff.ForceFeedbackWaveformShooting2"
    WeaponFireSnd(0)="SFX_Combat.VorpalBlade_Range_Cue"
    MuzzleFlashPSCTemplate="GFX_Weapons.VorpalBlade.VB_R_Muzzle_L4"
    RangeAttackSocket="Weapon_Muzzle1"
    SelfCollisionPhysicsAsset(0)="CH_Alice_Graphic.PhysicsAsset.SK_Wp3_Physics"
    MeleeAttackActorList="Default__EyeStaff.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__EyeStaff.RadiusAttackActorinfo"
    FiringStatesArray(0)="AliceWeaponRangeFire"
    WeaponFireTypes(0)=250
    WeaponFireTypes(1)=30
    WeaponProjectiles(0)="PepperGrinderPrimaryProjectile"
    WeaponProjectiles(1)="PepperGrinderAlternateProjectile"
    FireInterval(0)=0.5
    Spread(0)=0.0
    InstantHitDamage(0)=5.0
    InstantHitMomentum(0)=0.0
    InstantHitDamageTypes(0)="DmgType_EyeStaff_RangeProjectile"
    WeaponRange=22000.0
    WeaponMeleeRange=300.0
    Mesh="Default__EyeStaff.WeaponMesh"
    Components(0)="Default__EyeStaff.ChargeSound"
    Components(1)="Default__EyeStaff.CCS"
    Components(2)="Default__EyeStaff.ParticleSystemComponentMuzzleFlash1"
    Components(3)="Default__EyeStaff.WeaponMesh"
    Components(4)="Default__EyeStaff.AudioComponent0"
    Components(5)="Default__EyeStaff.AudioComponent1"
}
