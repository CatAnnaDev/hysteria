class NpcProjectile extends AliceGameProjectile
    abstract
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var config int bNPCProjectileHitNPC;
var config int DamageForNPCs;

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
    local AlicePawn TargetAlice;
    local SkeletalMeshComponent ShieldMeshComponent;
    local Rotator HitRotator;
    local Vector HitDirX, HitDirY, HitDirZ;
    local array<int> DecalBuffer;
    local bool bHitSpinningUmbrella;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    bHitSpinningUmbrella = false;
    if (TargetActor != none && TargetActor.IsA('AlicePawn'))
    {
        TargetAlice = AlicePawn(TargetActor);
        bHitSpinningUmbrella = ShieldResult.bSpinningShield;
        ShieldMeshComponent = TargetAlice.Mesh;
        if (ShieldMeshComponent != none)
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
    if (ImpactEffectRandomRadius > 0.0)
    {
        GetAxes(HitRotator, HitDirX, HitDirY, HitDirZ);
        HitLocation += HitDirY * ImpactEffectRandomRadius * (FRand() - 0.5);
        HitLocation += HitDirZ * ImpactEffectRandomRadius * (FRand() - 0.5);
    }
    WorldInfo.LogPhysMatInfo("FXInfoProjectile", string(Name), string(PM.Name));
    if (bHitSpinningUmbrella)
    {
        class'AlicePhysicalMaterialProperty'.static.DetermineProjectileDecalDataForHitSpinningUmbrella(PM, self.Class, outPM, FXIndex, GetWeaponLevel(), DecalBuffer);
    }
    else
    {
        class'AlicePhysicalMaterialProperty'.static.DetermineProjectileDecalData(PM, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
    }
    foreach DecalBuffer(I)
    {
        DecalData = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.GetProjectileDecalDataForHitSpinningUmbrella(outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance) : class'AlicePhysicalMaterialProperty'.static.GetProjectileDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance));
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
    ExplosionPS = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticleForHitSpinningUmbrella(PM, self.Class) : class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag));
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
    PSFromProjectile = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticleFromProjForHitSpinningUmbrella(PM, self.Class, WeaponLevel) : class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticleFromProj(PM, self.Class, WeaponLevel, InDLCWeaponFlag, OutDLCMatFlag));
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
    ExplosionCue = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSoundForHitSpinningUmbrella(PM, self.Class) : class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag));
    PlaySound(ExplosionCue);
    CueFromProjectile = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSoundFromProjForHitSpinningUmbrella(PM, self.Class, WeaponLevel) : class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSoundFromProj(PM, self.Class, WeaponLevel, InDLCWeaponFlag, OutDLCMatFlag));
    PlaySound(CueFromProjectile);
}

function bool IsReflectByAliceWeapon()
{
    return bool(bReboundableNPCProjectile) && ProjTrace.bInRebounding;
}

function InitFromWeaponLevelData(Weapon InWeapon)
{
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
    DamageForNPCs=-1
    ProjFlightEffects="Default__NpcProjectile.Particle"
    RangeAttackActorList="Default__NpcProjectile.RangeAttackActorinfo"
    CylinderComponent="Default__NpcProjectile.CollisionCylinder"
    Components(0)="Default__NpcProjectile.CollisionCylinder"
    CollisionComponent="Default__NpcProjectile.CollisionCylinder"
}
