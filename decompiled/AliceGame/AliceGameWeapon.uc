class AliceGameWeapon extends AliceGameWeaponBase
    abstract
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

const RANGE_FIRE_MODE = 0;
const MELEE_FIRE_MODE = 1;

enum EProjManualCurveType
{
    EProjManualCurve_None,
    EProjManualCurve_Type1,
    EProjManualCurve_Type2,
    EProjManualCurve_Type3,
};

struct native ProjectileLevelDataPackage
{
    var() ParticleSystem PorjectTileLightEffect;
    var() float AccelRate;
    var() float Speed;
    var() float MaxSpeed;
    var() float Damage;
    var() float DamageRadius;
    var() float MinShotDist;
    var() float MaxShotDist;
    var() float CheckRadius;
    var() float RadiusDamageTime;
    var() float RagdollImpulseScale;
    var() int KnockBackID;
};

var int AmmoCount;
var int MaxAmmoCount;
var(Weapon) array<int> ShotCost;
var array<CameraAnim> FireCameraAnim;
var ForceFeedbackWaveform WeaponFireWaveForm[2];
var array<name> EffectSockets;
var byte InventoryGroup;
var EProjManualCurveType ManuallyCurveType;
var float GroupWeight;
var float InventoryWeight;
var(Animations) array<name> WeaponFireAnim;
var(Animations) array<name> ArmFireAnim;
var(Animations) AnimSet ArmsAnimSet;
var(Animations) name WeaponPutDownAnim;
var(Animations) name ArmsPutDownAnim;
var(Animations) name WeaponEquipAnim;
var(Animations) name ArmsEquipAnim;
var(Animations) array<name> WeaponIdleAnims;
var(Animations) array<name> ArmIdleAnims;
var(Sounds) array<SoundCue> WeaponFireSnd;
var(Sounds) array<SoundCue> WeaponChargedFireSnd;
var(Sounds) SoundCue WeaponPutDownSnd;
var(Sounds) SoundCue WeaponEquipSnd;
var name MuzzleFlashSocket;
var export editinline AliceParticleSystemComponent MuzzleFlashPSC;
var ParticleSystem MuzzleFlashPSCTemplate;
var Color MuzzleFlashColor;
var bool bMuzzleFlashPSCLoops;
var bool bMuzzleFlashAttached;
var bool bUseReferenceFireSocket;
var bool bAlignMuzzleLocDir;
var export editinline AliceExplosionLight MuzzleFlashLight;
var class<AliceExplosionLight> MuzzleFlashLightClass;
var(AliceGameWeaponBase) float MuzzleFlashDuration;
var(Weapon) name RangeAttackSocket;
var(Weapon) array<name> RangeAttackSocketArray;
var int CurrentRangeAttackSocketIndex;
var int ReferenceFireSocketLocationSpace;
var int ReferenceFireSocketRotationSpace;
var float MRTransitionTime;
var float RMTransitionTime;
var float WeaponEquipTime;
var float ProjectFileAngleCurveStartValue;

simulated event NotifyMeleeAttackTraceParticleChange(bool bActive)
{
}

simulated function AttachOwnerData()
{
}

simulated function EWeaponHand GetHand()
{
    local AlicePlayerController PC;
    
    if (Instigator != none)
    {
        PC = AlicePlayerController(Instigator.Controller);
        if (PC != none)
        {
            return PC.WeaponHand;
        }
    }
    return 0;
}

simulated function DetachMuzzleFlash()
{
    local SkeletalMeshComponent SKMesh;
    
    bMuzzleFlashAttached = false;
    SKMesh = GetMuzzleSocketMesh();
    if (SKMesh != none)
    {
        if (MuzzleFlashPSC != none)
        {
            SKMesh.DetachComponent(MuzzleFlashPSC);
        }
    }
}

simulated function AttachMuzzleFlash()
{
    local SkeletalMeshComponent MuzzleMesh;
    
    bMuzzleFlashAttached = true;
    MuzzleMesh = GetMuzzleSocketMesh();
    if (MuzzleMesh != none)
    {
        if (MuzzleFlashPSCTemplate != none)
        {
            MuzzleFlashPSC = new(Outer) class'AliceParticleSystemComponent';
            MuzzleFlashPSC.bAutoActivate = false;
            MuzzleFlashPSC.SetDepthPriorityGroup(2);
            MuzzleFlashPSC.SetFOV(AliceSkeletalMeshComponent(MuzzleMesh).FOV);
            MuzzleMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
        }
    }
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
    PSC.SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
    PSC.SetVectorParameter('MFlashScale', vect(0.5, 0.5, 0.5));
}

simulated event StopMuzzleFlash()
{
    ClearTimer('MuzzleFlashTimer');
    MuzzleFlashTimer();
    if (MuzzleFlashPSC != none)
    {
        MuzzleFlashPSC.DeactivateSystem();
    }
}

simulated event CauseMuzzleFlash()
{
    local AlicePawn P;
    local ParticleSystem MuzzleTemplate;
    local SkeletalMeshComponent MuzzleMesh;
    
    if (WorldInfo.NetMode != 3)
    {
        P = AlicePawn(Instigator);
        if (P == none)
        {
            return;
        }
    }
    CauseMuzzleFlashLight();
    if (GetHand() != 3)
    {
        if (!bMuzzleFlashAttached)
        {
            AttachMuzzleFlash();
        }
        if (MuzzleFlashPSC != none)
        {
            if (!bMuzzleFlashPSCLoops || !MuzzleFlashPSC.bIsActive || MuzzleFlashPSC.bWasDeactivated)
            {
                if (MuzzleFlashPSCTemplate != none)
                {
                    MuzzleTemplate = MuzzleFlashPSCTemplate;
                }
                if (MuzzleTemplate != MuzzleFlashPSC.Template)
                {
                    MuzzleFlashPSC.SetTemplate(MuzzleTemplate);
                }
                SetMuzzleFlashParams(MuzzleFlashPSC);
                MuzzleFlashPSC.ActivateSystem();
                MuzzleMesh = GetMuzzleSocketMesh();
                if (MuzzleMesh != none)
                {
                    MuzzleMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
                }
            }
        }
        SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
    }
}

simulated event CauseMuzzleFlashLight()
{
    if (WorldInfo.bDropDetail)
    {
        return;
    }
    if (MuzzleFlashLight != none)
    {
        MuzzleFlashLight.ResetLight();
    }
    else if (MuzzleFlashLightClass != none)
    {
        MuzzleFlashLight = new(Outer) MuzzleFlashLightClass;
        GetMuzzleSocketMesh().AttachComponentToSocket(MuzzleFlashLight, MuzzleFlashSocket);
    }
}

simulated event MuzzleFlashTimer()
{
    if (MuzzleFlashPSC != none && !bMuzzleFlashPSCLoops)
    {
        MuzzleFlashPSC.DeactivateSystem();
    }
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    if (int(FireModeNum) < WeaponFireAnim.Length && WeaponFireAnim[int(FireModeNum)] != 'None')
    {
        PlayWeaponAnimation(WeaponFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum));
    }
    if (int(FireModeNum) < ArmFireAnim.Length && ArmFireAnim[int(FireModeNum)] != 'None' && ArmsAnimSet != none)
    {
        PlayArmAnimation(ArmFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum));
    }
    CauseMuzzleFlash();
    ShakeView();
}

simulated function PlayArmAnimation(name Sequence, float fDesiredDuration, optional bool OffHand, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    if (Mesh != none && Mesh.bAttached)
    {
        PlayWeaponAnimation(Sequence, fDesiredDuration, bLoop, SkelMesh);
    }
}

simulated function ShakeView()
{
    local AlicePlayerController PC;
    
    PC = AlicePlayerController(Instigator.Controller);
    if (PC != none && LocalPlayer(PC.Player) != none && int(CurrentFireMode) < FireCameraAnim.Length && FireCameraAnim[int(CurrentFireMode)] != none)
    {
        PC.PlayCameraAnim(FireCameraAnim[int(CurrentFireMode)], true, 1.0);
    }
    if (PC != none && LocalPlayer(PC.Player) != none)
    {
        AlicePlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(WeaponFireWaveForm[int(CurrentFireMode)]);
    }
}

simulated function Loaded(optional bool bUseWeaponMax)
{
    if (bUseWeaponMax)
    {
        AmmoCount = MaxAmmoCount;
    }
    else
    {
        AmmoCount = 999;
    }
}

simulated function bool NeedAmmo()
{
    return AmmoCount < default.AmmoCount;
}

simulated function float DesireAmmo(bool bDetour)
{
    return 1.0 - float(AmmoCount) / float(MaxAmmoCount);
}

simulated function bool HasAnyAmmo()
{
    return AmmoCount > 0 || ShotCost[0] == 0 && ShotCost[1] == 0;
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    if (Amount == 0)
    {
        return AmmoCount >= ShotCost[int(FireModeNum)];
    }
    else
    {
        return AmmoCount >= Amount;
    }
}

simulated function bool AmmoMaxed(int Mode)
{
    return AmmoCount >= MaxAmmoCount;
}

simulated function int GetAmmoCount()
{
    return AmmoCount;
}

function int AddAmmo(int Amount)
{
    AmmoCount = Clamp(AmmoCount + Amount, 0, MaxAmmoCount);
    if (AmmoCount <= 0 && AliceInventoryManager(InvManager) == none || AliceInventoryManager(InvManager).bInfiniteAmmo)
    {
        AmmoCount = MaxAmmoCount;
    }
    return AmmoCount;
}

function ConsumeAmmo(byte FireModeNum)
{
    AddAmmo(-ShotCost[int(FireModeNum)]);
}

simulated function CalcInventoryWeight()
{
    InventoryWeight = float((int(InventoryGroup) + int(1)) * 1000) + GroupWeight * float(100);
    if (Priority < float(0))
    {
        Priority = InventoryWeight;
    }
}

simulated function PlayChargedFiringSound()
{
    if (WeaponChargedFireSnd.Length != 0)
    {
        if (WeaponChargedFireSnd[0] != none)
        {
            MakeNoise(1.0);
            WeaponPlaySound(WeaponChargedFireSnd[0]);
        }
    }
}

simulated function PlayFiringSound()
{
    if (int(CurrentFireMode) < WeaponFireSnd.Length)
    {
        if (WeaponFireSnd[int(CurrentFireMode)] != none)
        {
            MakeNoise(1.0);
            WeaponPlaySound(WeaponFireSnd[int(CurrentFireMode)]);
        }
    }
}

function ScriptSetProjectileInitPara(AliceGameProjectile Proj)
{
}

simulated function Projectile ProjectileFire()
{
    local AliceGameProjectile tempProj;
    
    tempProj = AliceGameProjectile(ProjectileFire());
    ResetProjectileInitPara(tempProj);
    ScriptSetProjectileInitPara(tempProj);
    tempProj.SpawnFlightEffects();
    if (tempProj.RadiusDamageValue <= float(0))
    {
        tempProj.RadiusDamageValue = tempProj.Damage;
    }
    return tempProj;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    CalcInventoryWeight();
}

simulated function AttachWeaponToAlice(optional name SocketName)
{
    local AlicePawn ap;
    
    ap = AlicePawn(Instigator);
    AttachComponent(Mesh);
    ap.Mesh.AttachComponentToSocket(Mesh, SocketName);
    Mesh.SetLightEnvironment(ap.Mesh.LightEnvironment);
    Mesh.SetShadowParent(ap.Mesh);
    ap.FadeOutWeapon(false);
}

simulated function StartFire(byte FireModeNum)
{
    if (Instigator == none || !Instigator.bNoWeaponFiring)
    {
        BeginFire(FireModeNum);
    }
}

event PreResetProjectileInitPara(AliceGameProjectile Projectile)
{
}

native simulated function ResetProjectileInitPara(AliceGameProjectile Projectile)
{
    Projectile;
}

defaultproperties
{
    WeaponFireWaveForm="Default__AliceGameWeapon.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__AliceGameWeapon.ForceFeedbackWaveformShooting2"
    EffectSockets(0)="MuzzleFlashSocket"
    EffectSockets(1)="MuzzleFlashSocket"
    WeaponFireAnim(0)="WeaponFire"
    WeaponFireAnim(1)="WeaponFire"
    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashDuration=0.33
    RangeAttackSocket="TeaStreamer"
    MRTransitionTime=0.2
    RMTransitionTime=0.2
    WeaponEquipTime=0.25
    MeleeAttackActorList="Default__AliceGameWeapon.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__AliceGameWeapon.RadiusAttackActorinfo"
    DroppedPickupClass="AliceDroppedPickup"
}
