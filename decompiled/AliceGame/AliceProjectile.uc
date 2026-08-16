class AliceProjectile extends AliceGameProjectile
    abstract
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var() int AliceProjectileWeaponType;
var bool bAliceProjectileRadiusHitAlice;

function PlayLineCheckShieldExplosionEffect(Vector HitLocation, Vector HitNormal, out PhysicalMaterial InPM, ShieldTestResult ShieldResult, optional Actor TargetActor = none)
{
    local MaterialInstanceTimeVarying MITV_Decal;
    local Emitter ImpactEmitter;
    local DecalData DecalData;
    local ParticleSystem ExplosionPS, PSFromProjectile;
    local SoundCue ExplosionCue, CueFromProjectile;
    local PhysicalMaterial PM, outPM;
    local int bProjectOnSurface, FXIndex, I;
    local float ProjectionDistance;
    local Rotator HitRotator;
    local Vector HitDirX, HitDirY, HitDirZ;
    local array<int> DecalBuffer;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    PM = InPM;
    if (PM == none)
    {
        return;
    }
    WorldInfo.LogPhysMatInfo("FXInfoProjectile", string(Name), string(PM.Name));
    if (ImpactEffectRandomRadius > 0.0)
    {
        GetAxes(HitRotator, HitDirX, HitDirY, HitDirZ);
        HitLocation += HitDirY * ImpactEffectRandomRadius * (FRand() - 0.5);
        HitLocation += HitDirZ * ImpactEffectRandomRadius * (FRand() - 0.5);
    }
    class'AlicePhysicalMaterialProperty'.static.DetermineProjectileDecalData(PM, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
    foreach DecalBuffer(I)
    {
        DecalData = class'AlicePhysicalMaterialProperty'.static.GetProjectileDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance);
        if (DecalData.bIsValid && DecalData.Width != float(0) && DecalData.Height != float(0))
        {
            if (DecalData.DecalMaterial != none && Pawn(ImpactedActor) == none)
            {
                if (MaterialInstanceTimeVarying(DecalData.DecalMaterial) != none)
                {
                    MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                    MITV_Decal.SetParent(DecalData.DecalMaterial);
                    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, rotator(-HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, false, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                    MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                    continue;
                }
                WorldInfo.MyDecalManager.SpawnDecal(DecalData.DecalMaterial, HitLocation, rotator(-HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, true, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
            }
        }
    }
    ExplosionPS = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    if (ExplosionPS != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , HitLocation, HitRotator);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(HitLocation);
            ImpactEmitter.SetRotation(HitRotator);
            ImpactEmitter.SetTemplate(ExplosionPS, true);
        }
    }
    PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticleFromProj(PM, self.Class, WeaponLevel, InDLCWeaponFlag, OutDLCMatFlag);
    if (PSFromProjectile != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , HitLocation, HitRotator);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(HitLocation);
            ImpactEmitter.SetRotation(HitRotator);
            ImpactEmitter.SetTemplate(PSFromProjectile, true);
        }
    }
    ExplosionCue = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(ExplosionCue);
    CueFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSoundFromProj(PM, self.Class, WeaponLevel, InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(CueFromProjectile);
}

function PlayShieldExplosionEffect(Vector HitLocation, Vector HitNormal, ShieldTestResult ShieldResult, ShapeCollisionResult CollisionResult, optional Actor TargetActor = none)
{
    local MaterialInstanceTimeVarying MITV_Decal;
    local Emitter ImpactEmitter;
    local DecalData DecalData;
    local ParticleSystem ExplosionPS, PSFromProjectile;
    local SoundCue ExplosionCue, CueFromProjectile;
    local PhysicalMaterial PM, outPM;
    local int bProjectOnSurface, FXIndex, I;
    local float ProjectionDistance;
    local AliceGameKynapsePawn TargetNPC;
    local SkeletalMeshComponent ShieldMeshComponent;
    local Rotator HitRotator;
    local Vector HitDirX, HitDirY, HitDirZ;
    local array<int> DecalBuffer;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    if (TargetActor != none && TargetActor.IsA('AliceGameKynapsePawn'))
    {
        TargetNPC = AliceGameKynapsePawn(TargetActor);
        ShieldMeshComponent = TargetNPC.NPCAttachmentComponentsArray[TargetNPC.ShieldComponentsArray[ShieldResult.ShieldIndex].ComponentIndex].CurrentAttachmentMeshComponent;
        if (TargetNPC != none && ShieldResult.ShieldIndex >= 0 && ShieldResult.ShieldIndex < TargetNPC.ShieldComponentsArray.Length)
        {
            if (CollisionResult.HitBodySetUp != none)
            {
                PM = CollisionResult.HitBodySetUp.PhysMaterial;
            }
        }
        if (CollisionResult.EffectSocketIndex == -1 || !ShieldMeshComponent.GetSocketWorldLocationAndRotation(CollisionResult.HitBodySetUp.EffectSocketNameArray[CollisionResult.EffectSocketIndex], HitLocation, HitRotator))
        {
            HitLocation = ShieldMeshComponent.GetBoneLocation(CollisionResult.HitBodySetUp.BoneName);
            HitRotator = rot(0, 0, 1);
        }
    }
    if (PM == none)
    {
        return;
    }
    WorldInfo.LogPhysMatInfo("FXInfoProjectile", string(Name), string(PM.Name));
    if (ImpactEffectRandomRadius > 0.0)
    {
        GetAxes(HitRotator, HitDirX, HitDirY, HitDirZ);
        HitLocation += HitDirY * ImpactEffectRandomRadius * (FRand() - 0.5);
        HitLocation += HitDirZ * ImpactEffectRandomRadius * (FRand() - 0.5);
    }
    class'AlicePhysicalMaterialProperty'.static.DetermineProjectileDecalData(PM, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
    foreach DecalBuffer(I)
    {
        DecalData = class'AlicePhysicalMaterialProperty'.static.GetProjectileDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance);
        if (DecalData.bIsValid && DecalData.Width != float(0) && DecalData.Height != float(0))
        {
            if (DecalData.DecalMaterial != none && Pawn(ImpactedActor) == none)
            {
                if (MaterialInstanceTimeVarying(DecalData.DecalMaterial) != none)
                {
                    MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                    MITV_Decal.SetParent(DecalData.DecalMaterial);
                    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, rotator(-HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, false, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                    MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                    continue;
                }
                WorldInfo.MyDecalManager.SpawnDecal(DecalData.DecalMaterial, HitLocation, rotator(-HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, true, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
            }
        }
    }
    ExplosionPS = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    if (ExplosionPS != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , HitLocation, HitRotator);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(HitLocation);
            ImpactEmitter.SetRotation(HitRotator);
            ImpactEmitter.SetTemplate(ExplosionPS, true);
        }
    }
    PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticleFromProj(PM, self.Class, WeaponLevel, InDLCWeaponFlag, OutDLCMatFlag);
    if (PSFromProjectile != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , HitLocation, HitRotator);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(HitLocation);
            ImpactEmitter.SetRotation(HitRotator);
            ImpactEmitter.SetTemplate(PSFromProjectile, true);
        }
    }
    ExplosionCue = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(ExplosionCue);
    CueFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSoundFromProj(PM, self.Class, WeaponLevel, InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(CueFromProjectile);
}

simulated event PlayRangeAttackEffectOnAttachedActor(AliceGameNPCAttachedActor TargetAttachedActor, ShapeCollisionResult TestResult, Vector HurtOrigin, Vector HitNormal)
{
    PlayExplosionEffect(HurtOrigin, HitNormal, TestResult, TargetAttachedActor);
}

function InitFromWeaponLevelData(Weapon InWeapon)
{
    local WeaponForAlice AliceWeapon;
    local ProjectileLevelDataPackage LevelDataPackage;
    
    AliceWeapon = WeaponForAlice(InWeapon);
    if (AliceWeapon != none)
    {
        LevelDataPackage = AliceWeapon.CurrentProjectilePackage;
        ProjFlightEffectTemplate = LevelDataPackage.PorjectTileLightEffect;
        AccelRate = LevelDataPackage.AccelRate;
        Speed = LevelDataPackage.Speed;
        MaxSpeed = LevelDataPackage.MaxSpeed;
        Damage = LevelDataPackage.Damage;
        DamageRadius = LevelDataPackage.DamageRadius;
        MinShotDist = LevelDataPackage.MinShotDist;
        MaxShotDist = LevelDataPackage.MaxShotDist;
        CheckRadius = LevelDataPackage.CheckRadius;
        RadiusDamageTime = LevelDataPackage.RadiusDamageTime;
        RagdollImpulseScale = LevelDataPackage.RagdollImpulseScale;
        KnockBackID = LevelDataPackage.KnockBackID;
    }
}

native function GetLineCheckRadiusShieldDamageEffect(Pawn TargetPawn, out ShieldTestResult ShieldTestResult, out Vector HitLoc, out Vector HitNormal, out PhysicalMaterial PhysMaterial)
{
    TargetPawn;
    ShieldTestResult;
    HitLoc;
    HitNormal;
    PhysMaterial;
}

native function GetRadiusShieldDamageEffect(Pawn TargetPawn, out ShieldTestResult ShieldTestResult, out ShapeCollisionResult ColisionTestResult, bool bExplosionDamage)
{
    TargetPawn;
    ShieldTestResult;
    ColisionTestResult;
    bExplosionDamage;
}

native function bool CanShieldBlockRadiusDamage(Actor TargetPawn, bool bExplosionDamage, out ShieldTestResult ShieldTestResult)
{
    TargetPawn;
    bExplosionDamage;
    ShieldTestResult;
}

defaultproperties
{
    AliceProjectileWeaponType=-1
    ProjFlightEffects="Default__AliceProjectile.Particle"
    RangeAttackActorList="Default__AliceProjectile.RangeAttackActorinfo"
    CylinderComponent="Default__AliceProjectile.CollisionCylinder"
    Components(0)="Default__AliceProjectile.CollisionCylinder"
    CollisionComponent="Default__AliceProjectile.CollisionCylinder"
}
