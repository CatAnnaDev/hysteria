class AliceGameProjectile extends Projectile
    abstract
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var bool bSuppressSounds;
var bool bImportantAmbientSound;
var bool bCheckProjectileLight;
var bool bSuppressExplosionFX;
var bool bWaitForEffects;
var bool bShuttingDown;
var bool bAdvanceExplosionEffect;
var bool bWideCheck;
var bool bInExplodeDamage;
var bool bNoRadiusDamageWhenHitPawn;
var bool bForceTraceGround;
var bool bInBallMoving;
var bool bBallRadiusExplodeOnly;
var transient bool bAITouch;
var bool bPersistentProjectile;
var bool bNeedRangeAttackWhenExplode;
var() SoundCue AmbientSound;
var() SoundCue ExplosionSound;
var export editinline ParticleSystemComponent ProjEffects;
var() ParticleSystem ProjFlightEffectTemplate;
var export editinline ParticleSystemComponent ProjFlightEffects;
var float MaxEffectDistance;
var config float AccelRate;
var float TossZ;
var class<PointLightComponent> ProjectileLightClass;
var export editinline PointLightComponent ProjectileLight;
var class<AliceExplosionLight> ExplosionLightClass;
var float MaxExplosionLightDistance;
var MaterialInterface ExplosionDecal;
var float DecalWidth;
var float DecalHeight;
var name DecalDissolveParamName;
var float DurationOfDecal;
var float CustomGravityScaling;
var float TerminalVelocity;
var float Buoyancy;
var config float CheckRadius;
var config float CameraEffectRadius;
var config int RadiusAttackMaxTriggerCount;
var config float RadiusAttackRetrigerTime;
var float GlobalCheckRadiusTweak;
var EImpactTypeExplosion ImpactTypeExplosionID;
var transient EProjManualCurveType ManuallyCurveType;
var config EDamageStrengthType DamageStrength;
var config float MinShotDist;
var config float MaxShotDist;
var config float RefVel;
var int WeaponClass;
var int WeaponLevel;
var AliceGameWeaponBase WeaponOwner;
var KnockBackParameters KnockBackParameter;
var() class<EmitterCameraLensEffectBase> CameraExplosionEffectClass;
var transient float ProjectFileAngleCurveStartValue;
var transient Vector FlightFront;
var transient Vector DisturbAcc;
var transient float DisturbTime;
var config float RadiusDamageTime;
var config float RagdollImpulseScale;
var config int KnockBackID;
var config float ImpactEffectRandomRadius;
var config float RadiusDamageValue;
var transient Vector LastLocation;
var transient float RadiusDamageLeftTime;
var int StrikBackHitCount;
var export editinline AliceGameProjectileTrace ProjTrace;
var export editinline AttackActorInfo RangeAttackActorList;
var export editinline AudioComponent AmbientSoundComponent;
var config int bReboundableNPCProjectile;
var config float AngleToleranceXY;
var config float AngleToleranceZ;
var config float GroundTraceGapForWalkingPawn;
var config float GroundTraceGapForFlyingPawn;
var class<ProjectileRigidBallBase> RigidBallClass;
var ProjectileRigidBallBase RigidBall;
var config float BallBlastDelayTime;
var config float BallImpulseValue;
var Vector m_HitNormal;
var config int bBallSelfRotating;
var config Rotator BallSelfRotaionRate;

static simulated function float GetRange()
{
    local float AccelTime;
    
    if (default.LifeSpan == 0.0)
    {
        return 15000.0;
    }
    else if (default.AccelRate == 0.0)
    {
        return default.Speed * default.LifeSpan;
    }
    else
    {
        AccelTime = (default.MaxSpeed - default.Speed) / default.AccelRate;
        if (AccelTime < default.LifeSpan)
        {
            return 0.5 * default.AccelRate * AccelTime * AccelTime + default.Speed * AccelTime + default.MaxSpeed * (default.LifeSpan - AccelTime);
        }
        else
        {
            return 0.5 * default.AccelRate * default.LifeSpan * default.LifeSpan + default.Speed * default.LifeSpan;
        }
    }
}

simulated function float GetTimeToLocation(Vector TargetLoc)
{
    return CalculateTravelTime(VSize(TargetLoc - Location), Speed, MaxSpeed, AccelRate);
}

static simulated function float StaticGetTimeToLocation(Vector TargetLoc, Vector StartLoc, Controller RequestedBy)
{
    return CalculateTravelTime(VSize(TargetLoc - StartLoc), default.Speed, default.MaxSpeed, default.AccelRate);
}

static final function float CalculateTravelTime(float Dist, float MoveSpeed, float MaxMoveSpeed, float AccelMag)
{
    local float ProjTime, AccelTime, AccelDist;
    
    if (AccelMag == 0.0)
    {
        return Dist / MoveSpeed;
    }
    else
    {
        ProjTime = (-MoveSpeed + Sqrt(Square(MoveSpeed) - 2.0 * AccelMag * -Dist)) / AccelMag;
        AccelTime = (MaxMoveSpeed - MoveSpeed) / AccelMag;
        if (ProjTime > AccelTime)
        {
            AccelDist = MoveSpeed * AccelTime + 0.5 * AccelMag * Square(AccelTime);
            ProjTime = AccelTime + (Dist - AccelDist) / MaxMoveSpeed;
        }
        return ProjTime;
    }
}

event TornOff()
{
    ShutDown();
    TornOff();
}

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance)
{
    local PlayerController PC;
    
    if (WorldInfo.NetMode != 1 && SpawnLocation == Location)
    {
        foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            if (PC.ViewTarget != none && VSize(PC.ViewTarget.Location - Location) < 256.0)
            {
                return true;
            }
        }
    }
    return EffectIsRelevant(SpawnLocation, bForceDedicated, CullDistance);
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    HitWall(HitNormal, FloorActor, none);
}

simulated function Destroyed()
{
    if (RigidBall != none)
    {
        RigidBall.LifeSpan = 0.01;
        RigidBall = none;
    }
    if (WorldInfo.NetMode != 1 && !bSuppressExplosionFX)
    {
        SpawnExplosionEffects(Location, getHitNormal());
    }
    if (AmbientSoundComponent != none)
    {
        AmbientSoundComponent.Stop();
    }
    if (ProjEffects != none)
    {
        DetachComponent(ProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
        ProjEffects = none;
    }
    Destroyed();
    RangeAttackActorList.Reset();
    if (ProjTrace != none)
    {
        ProjTrace.TargetEnemyActor = none;
        ProjTrace = none;
    }
}

function Vector getHitNormal()
{
    return m_HitNormal;
}

function setHitNormal(Vector vHitNormal)
{
    m_HitNormal = vHitNormal;
}

simulated function bool ShouldSpawnExplosionLight(Vector HitLocation, Vector HitNormal)
{
    local PlayerController P;
    local float Dist;
    
    foreach LocalPlayerControllers(class'Engine.PlayerController', P)
    {
        Dist = VSize(P.ViewTarget.Location - Location);
        if (P.Pawn == Instigator || Dist < ExplosionLightClass.default.default.Radius || Dist < MaxExplosionLightDistance && vector(P.Rotation) Dot (Location - P.ViewTarget.Location) > float(0))
        {
            return true;
        }
    }
    return false;
}

function PlayLineCheckShieldExplosionEffect(Vector HitLocation, Vector HitNormal, out PhysicalMaterial InPM, ShieldTestResult ShieldResult, optional Actor TargetActor = none)
{
}

function PlayShieldExplosionEffect(Vector HitLocation, Vector HitNormal, ShieldTestResult ShieldResult, ShapeCollisionResult CollisionResult, optional Actor TargetActor = none)
{
}

function PlayLineCheckExplosionEffect(Vector HitLocation, Vector HitNormal, PhysicalMaterial InPM, optional Actor TargetActor = none)
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

function PlayExplosionEffect(Vector HitLocation, Vector HitNormal, ShapeCollisionResult TestResult, optional Actor TargetActor = none)
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
    local AliceGameNPCAttachedActor AttachedActor;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    if (TargetActor != none && TargetActor.IsA('AliceGamePawn'))
    {
        if (TestResult.EffectSocketIndex == -1 || !AliceGamePawn(TargetActor).Mesh.GetSocketWorldLocationAndRotation(TestResult.HitBodySetUp.EffectSocketNameArray[TestResult.EffectSocketIndex], HitLocation, HitRotator))
        {
            HitLocation = AliceGamePawn(TargetActor).Mesh.GetBoneLocation(TestResult.HitBodySetUp.BoneName);
            HitRotator = rot(0, 0, 1);
        }
        PM = TestResult.HitBodySetUp.PhysMaterial;
    }
    if (TargetActor != none && TargetActor.IsA('AliceGameNPCAttachedActor'))
    {
        AttachedActor = AliceGameNPCAttachedActor(TargetActor);
        if (TestResult.EffectSocketIndex == -1 || !AttachedActor.SkeletalMeshComponent.GetSocketWorldLocationAndRotation(TestResult.HitBodySetUp.EffectSocketNameArray[TestResult.EffectSocketIndex], HitLocation, HitRotator))
        {
            HitLocation = AttachedActor.SkeletalMeshComponent.GetBoneLocation(TestResult.HitBodySetUp.BoneName);
            HitRotator = rot(0, 0, 1);
        }
        PM = TestResult.HitBodySetUp.PhysMaterial;
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

function SpawnExplosionDecal(Vector HitLocation, Vector HitNormal, optional Actor TargetActor = none)
{
    local TraceHitInfo HitInfo;
    local MaterialInstanceTimeVarying MITV_Decal;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;
    local Emitter ImpactEmitter;
    local DecalData DecalData;
    local ParticleSystem ExplosionPS, PSFromProjectile;
    local SoundCue ExplosionCue, CueFromProjectile;
    local PhysicalMaterial PM, outPM;
    local Actor TraceActor;
    local int bProjectOnSurface, I, FXIndex;
    local float ProjectionDistance;
    local AliceGamePawn AGPawn;
    local Rotator HitRotator;
    local Vector HitDirX, HitDirY, HitDirZ;
    local array<int> DecalBuffer;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    out_HitLocation = HitLocation;
    out_HitNormal = HitNormal;
    AGPawn = AliceGamePawn(TargetActor);
    if (AGPawn != none && bForceTraceGround)
    {
        TraceStart = HitLocation;
        TraceDest = HitLocation;
        if (AGPawn.Physics == 4 || AGPawn.Physics == 2)
        {
            TraceDest.Z = AGPawn.GetBottomHeight() - GroundTraceGapForFlyingPawn;
        }
        else
        {
            TraceDest.Z = AGPawn.GetBottomHeight() - GroundTraceGapForWalkingPawn;
        }
        TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo);
        PM = GetPhysicalMaterial(TraceActor, HitInfo, out_HitLocation);
        if (PM == none)
        {
            PM = GetExplodePhysMaterial();
            out_HitLocation = HitLocation;
            out_HitNormal = HitNormal;
        }
    }
    else if (PM == none)
    {
        TraceStart = HitLocation + HitNormal * 30.0;
        TraceDest = HitLocation + HitNormal * -30.0;
        TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo);
        PM = GetPhysicalMaterial(TraceActor, HitInfo, out_HitLocation);
    }
    if (PM == none)
    {
        return;
    }
    if (TeapotCannonProjectile(self) != none)
    {
        PM = TeapotCannonProjectile(self).ExplodePhysMaterial;
    }
    HitRotator = rotator(out_HitNormal);
    if (ImpactEffectRandomRadius > 0.0)
    {
        GetAxes(HitRotator, HitDirX, HitDirY, HitDirZ);
        out_HitLocation += HitDirY * ImpactEffectRandomRadius * (FRand() - 0.5);
        out_HitLocation += HitDirZ * ImpactEffectRandomRadius * (FRand() - 0.5);
    }
    WorldInfo.LogPhysMatInfo("FXInfoProjectile", string(Name), string(PM.Name));
    class'AlicePhysicalMaterialProperty'.static.DetermineProjectileDecalData(PM, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
    foreach DecalBuffer(I)
    {
        DecalData = class'AlicePhysicalMaterialProperty'.static.GetProjectileDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance);
        if (DecalData.bIsValid && DecalData.Width != float(0) && DecalData.Height != float(0))
        {
            if (DecalData.DecalMaterial != none)
            {
                if (MaterialInstanceTimeVarying(DecalData.DecalMaterial) != none)
                {
                    MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                    MITV_Decal.SetParent(DecalData.DecalMaterial);
                    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, out_HitLocation, rotator(-out_HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, false, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                    MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                    continue;
                }
                WorldInfo.MyDecalManager.SpawnDecal(DecalData.DecalMaterial, out_HitLocation, rotator(-out_HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, true, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
            }
        }
    }
    if (ImpactEffectRandomRadius > 0.0)
    {
        GetAxes(HitRotator, HitDirX, HitDirY, HitDirZ);
        HitLocation += HitDirY * ImpactEffectRandomRadius * (FRand() - 0.5);
        HitLocation += HitDirZ * ImpactEffectRandomRadius * (FRand() - 0.5);
    }
    ExplosionPS = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    if (ExplosionPS != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , HitLocation);
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
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , out_HitLocation);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(out_HitLocation);
            ImpactEmitter.SetRotation(HitRotator);
            ImpactEmitter.SetTemplate(PSFromProjectile, true);
        }
    }
    ExplosionCue = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(ExplosionCue);
    CueFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineProjectileSoundFromProj(PM, self.Class, WeaponLevel, InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(CueFromProjectile);
}

function PhysicalMaterial GetExplodePhysMaterial()
{
    return none;
}

function PhysicalMaterial GetPhysMatFromTerrain(Terrain TerrainActor, Vector Loc)
{
    local int I, LayerIndex;
    local float MaxAlpha;
    local Material t_Material;
    local array<float> LayerAlphaArray;
    
    if (TerrainActor.Layers.Length == 0)
    {
        return none;
    }
    LayerIndex = 0;
    LayerAlphaArray.Length = 0;
    TerrainActor.GetLayerAlpha(Loc, LayerAlphaArray);
    MaxAlpha = 0.0;
    for (I = 0; I < LayerAlphaArray.Length; I++)
    {
        if (LayerAlphaArray[I] > MaxAlpha)
        {
            MaxAlpha = LayerAlphaArray[I];
            LayerIndex = I;
        }
    }
    if (TerrainActor.Layers[LayerIndex].Setup != none && TerrainActor.Layers[LayerIndex].Setup.Materials.Length > 0 && TerrainActor.Layers[LayerIndex].Setup.Materials[0].Material != none && TerrainActor.Layers[LayerIndex].Setup.Materials[0].Material.Material != none)
    {
        t_Material = Material(TerrainActor.Layers[LayerIndex].Setup.Materials[0].Material.Material);
        if (t_Material != none)
        {
            return t_Material.PhysMaterial;
        }
        else
        {
            return none;
        }
    }
    else
    {
        return none;
    }
}

function PhysicalMaterial GetPhysicalMaterial(Actor TraceActor, TraceHitInfo HitInfo, Vector Loc)
{
    if (TraceActor.IsA('Terrain'))
    {
        return GetPhysMatFromTerrain(Terrain(TraceActor), Loc);
    }
    else if (TraceActor.IsA('InterpActor'))
    {
        return class'AlicePhysicalMaterialProperty'.static.GetPhysMatFromInterpActor(InterpActor(TraceActor));
    }
    else if (HitInfo.PhysMaterial != none)
    {
        return HitInfo.PhysMaterial;
    }
    else
    {
        return none;
    }
}

function ParticleSystem AltinatePSFromProjectile()
{
    return none;
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal, optional Actor TargetActor)
{
    if (WorldInfo.NetMode != 1)
    {
        if (Pawn(TargetActor) == none && AliceGameNPCAttachedActor(TargetActor) == none || bForceTraceGround)
        {
            SpawnExplosionDecal(HitLocation, HitNormal, TargetActor);
        }
        if (ExplosionSound != none && !bSuppressSounds)
        {
            PlaySound(ExplosionSound, true);
        }
        bSuppressExplosionFX = true;
    }
}

simulated function SplashDecalOnNPC(Pawn TargetPawn)
{
    local AliceGameKynapsePawn AGPawn;
    local name SocketName;
    local int bProjectOnSurface, I, FXIndex;
    local PhysicalMaterial outPM;
    local float ProjectionDistance;
    local DecalData DecalData;
    local Vector ImpactLoc;
    local Rotator ImpactRot;
    local array<int> DecalBuffer;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    AGPawn = AliceGameKynapsePawn(TargetPawn);
    if (AGPawn != none && AGPawn.PhysMaterial != none)
    {
        SocketName = AGPawn.PhysicalMaterialSocket;
        class'AlicePhysicalMaterialProperty'.static.DetermineProjectileDecalData(AGPawn.PhysMaterial, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
        foreach DecalBuffer(I)
        {
            DecalData = class'AlicePhysicalMaterialProperty'.static.GetProjectileDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance);
            if (DecalData.bIsValid)
            {
                AGPawn.Mesh.GetSocketWorldLocationAndRotation(SocketName, ImpactLoc, ImpactRot);
                if (DecalData.DecalMaterial != none)
                {
                    AGPawn.LeaveDecalOnPawn(ImpactLoc, ImpactRot, none, 'None', DecalData);
                    if (bool(bProjectOnSurface))
                    {
                        AGPawn.LeaveDecal360AroundPawn(DecalData, ProjectionDistance);
                    }
                }
            }
        }
    }
}

simulated event PlayRangeAttackEffect(Pawn TargetPawn, ShapeCollisionResult TestResult, Vector HurtOrigin, Vector HitNormal, bool bExplodeDamage)
{
    local PhysicalMaterial PhysMat;
    local Vector HitLoc, HitDir;
    
    TargetPawn.SetDamageEffect(self);
    if (!bExplodeDamage && TargetPawn.IsLineCheckPhysMatResult())
    {
        GetLineCheckRadiusDamageEffect(TargetPawn, HitLoc, HitDir, PhysMat);
        PlayLineCheckExplosionEffect(HitLoc, HitDir, PhysMat, TargetPawn);
    }
    else
    {
        GetRadiusDamageEffect(TargetPawn, TestResult, false);
        PlayExplosionEffect(HurtOrigin, HitNormal, TestResult, TargetPawn);
    }
    SplashDecalOnNPC(TargetPawn);
}

simulated event PlayShieldRangeAttackEffect(Pawn TargetPawn, ShieldTestResult ShieldResult, Vector HurtOrigin, Vector HitNormal, bool bExplodeDamage)
{
    local ShapeCollisionResult CollisionResult;
    local PhysicalMaterial PhysMat;
    local Vector HitLoc, HitDir;
    
    TargetPawn.SetDamageEffect(self);
    if (!bExplodeDamage && TargetPawn.IsLineCheckPhysMatResult())
    {
        GetLineCheckRadiusShieldDamageEffect(TargetPawn, ShieldResult, HitLoc, HitDir, PhysMat);
        PlayLineCheckShieldExplosionEffect(HitLoc, HitDir, PhysMat, ShieldResult, TargetPawn);
    }
    else
    {
        GetRadiusShieldDamageEffect(TargetPawn, ShieldResult, CollisionResult, false);
        PlayShieldExplosionEffect(HurtOrigin, HitNormal, ShieldResult, CollisionResult, TargetPawn);
    }
    SplashDecalOnNPC(TargetPawn);
}

simulated function ShutDown()
{
    local Vector HitLocation, HitNormal;
    
    bShuttingDown = true;
    HitNormal = Normal(Velocity * float(-1));
    Trace(HitLocation, HitNormal, Location + HitNormal * float(-32), Location + HitNormal * float(32), true, vect(0.0, 0.0, 0.0));
    SetPhysics(0);
    Velocity += -Velocity;
    Acceleration += -Acceleration;
    if (ProjEffects != none)
    {
        ProjEffects.DeactivateSystem();
    }
    ProjFlightEffects.DeactivateSystem();
    if (AmbientSoundComponent != none)
    {
        AmbientSoundComponent.Stop();
    }
    HideProjectile();
    SetCollision(false, false);
    if (RigidBall != none)
    {
        RigidBall.OnProjShutDown();
    }
    if (bWaitForEffects)
    {
        if (bNetTemporary)
        {
            if (WorldInfo.NetMode == 1)
            {
                Destroy();
            }
            else
            {
                RemoteRole = 0;
                if (!bPersistentProjectile)
                {
                    LifeSpan = FMax(LifeSpan, 2.0);
                    LifeSpan = FMax(LifeSpan, RadiusDamageLeftTime + 2.0);
                }
            }
        }
        else
        {
            bTearOff = true;
            if (WorldInfo.NetMode == 1)
            {
                LifeSpan = 0.15;
            }
            else
            {
                LifeSpan = FMax(LifeSpan, 2.0);
                LifeSpan = FMax(LifeSpan, RadiusDamageLeftTime + 2.0);
            }
        }
    }
    else
    {
        Destroy();
    }
}

simulated function HideProjectile()
{
    local MeshComponent ComponentIt;
    
    foreach ComponentList(class'Engine.MeshComponent', ComponentIt)
    {
        ComponentIt.SetHidden(true);
    }
}

simulated event TriggerRadiusDamageCameraShake()
{
}

simulated event TriggerRadiusDamageLight()
{
}

simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor TargetActor = none)
{
    if (bInExplodeDamage)
    {
        return;
    }
    if (Damage > float(0) && DamageRadius > float(0))
    {
        if (Role == 3)
        {
            MakeNoise(1.0);
        }
    }
    SpawnExplosionEffects(HitLocation, HitNormal, TargetActor);
    bInExplodeDamage = true;
    ShutDown();
    if (bNoRadiusDamageWhenHitPawn && Pawn(TargetActor) != none)
    {
        RadiusDamageLeftTime = -1.0;
    }
    else
    {
        RadiusDamageLeftTime = RadiusDamageTime;
    }
    TriggerRadiusDamageLight();
    TriggerRadiusDamageCameraShake();
}

simulated event CreateProjectileLight()
{
    if (WorldInfo.bDropDetail)
    {
        return;
    }
    ProjectileLight = new(self) ProjectileLightClass;
    AttachComponent(ProjectileLight);
}

event Actor GetHomingTarget(AliceGameProjectile Seeker, Controller InstigatedBy)
{
    return self;
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    out_CamLoc = Location + CylinderComponent.CollisionHeight * vect(0.0, 0.0, 1.0);
    return true;
}

function Init(Vector Direction)
{
    SetRotation(rotator(Direction));
    Velocity = Speed * Direction;
    Velocity.Z += TossZ;
    Acceleration = AccelRate * Normal(Velocity);
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    if (Role < 3 && AccelRate != 0.0)
    {
        GotoState('WaitingForVelocity');
    }
    else
    {
        GotoState(InitialState != 'None' ? InitialState : 'Auto');
    }
}

simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    if (PSC == ProjEffects)
    {
        if (bWaitForEffects)
        {
            if (bShuttingDown)
            {
                LifeSpan = 0.01;
            }
            else
            {
                bWaitForEffects = false;
            }
        }
        DetachComponent(ProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
        ProjEffects = none;
    }
}

simulated function SpawnFlightEffects()
{
    ProjFlightEffects.SetTemplate(ProjFlightEffectTemplate);
    ProjFlightEffects.SetAbsolute(false, false, false);
    ProjFlightEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
    ProjFlightEffects.__OnSystemFinished__Delegate = MyOnParticleSystemFinished;
    ProjFlightEffects.bUpdateComponentInTick = true;
    AttachComponent(ProjFlightEffects);
}

function int GetWeaponLevel()
{
    return WeaponLevel;
}

simulated function bool InRebound()
{
    return ProjTrace != none && ProjTrace.bInRebounding;
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    if (RigidBall != none)
    {
        RigidBall.OnProjHitWall(Wall);
    }
    else
    {
        if (GameBreakableActor(Wall) != none)
        {
            return;
        }
        if (AimSwitchActorBase(Wall) != none)
        {
            return;
        }
        if (NoseActorBase(Wall) != none)
        {
            return;
        }
        if (PepperGrinderPrimaryProjectile(self) != none)
        {
            bNeedRangeAttackWhenExplode = true;
        }
        HitWall(HitNormal, Wall, WallComp);
    }
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    if (RigidBall != none)
    {
        RigidBall.OnProjBump(Other);
    }
    else
    {
        Bump(Other, OtherComp, HitNormal);
    }
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (!bAITouch)
    {
        if (NoseActorBase(Other) != none || GameBreakableActor(Other) != none || AimSwitchActorBase(Other) != none || KrakenEye(Other) != none || InterpActor(Other) != none || AliceGamePawn(Other) != none || AliceGameNPCAttachedActor(Other) != none)
        {
            return;
        }
    }
    if (RigidBall != none)
    {
        if (!(Other.IsA('AlicePawn') || Other.IsA('AliceClonePawn')))
        {
            RigidBall.OnProjTouch(Other);
        }
        else
        {
            Touch(Other, OtherComp, HitLocation, HitNormal);
            RigidBall.ExplodeDirectly(false);
        }
    }
    else
    {
        Touch(Other, OtherComp, HitLocation, HitNormal);
    }
}

function OnRigidBallExplode(Vector HitLocation, Vector HitNormal)
{
    Explode(HitLocation, HitNormal, RigidBall.TargetActor);
    RadiusAttackPawnCollisionCheck();
}

simulated function PostBeginPlay()
{
    if (!bWideCheck)
    {
        CheckRadius *= GlobalCheckRadiusTweak;
    }
    bWideCheck = bWideCheck || CheckRadius > float(0) && Instigator != none && AlicePlayerController(Instigator.Controller) != none && AlicePlayerController(Instigator.Controller).AimingHelp(false);
    PostBeginPlay();
    RangeAttackActorList.Reset();
    if (bDeleteMe || bShuttingDown)
    {
        return;
    }
    if (AmbientSound != none && WorldInfo.NetMode != 1 && !bSuppressSounds)
    {
        AmbientSoundComponent = new(self) class'Engine.AudioComponent';
        if (AmbientSoundComponent != none)
        {
            AttachComponent(AmbientSoundComponent);
            AmbientSoundComponent.Stop();
            AmbientSoundComponent.SoundCue = AmbientSound;
            AmbientSoundComponent.Play();
        }
    }
    if (RigidBallClass != none)
    {
        RigidBall = Spawn(RigidBallClass, self, 'None', Location, Rotation, none, true);
        if (RigidBall != none)
        {
            RigidBall.InitParam(self);
            RigidBall.SetPhysics(4);
        }
        bInBallMoving = false;
    }
    bAITouch = false;
}

simulated function int GetDLCWeaponFlag()
{
    return 0;
}

native simulated function bool ShouldTriggerKnockback(Pawn TargetPawn)
{
    TargetPawn;
}

native function GetLineCheckRadiusShieldDamageEffect(Pawn TargetPawn, out ShieldTestResult ShieldTestResult, out Vector HitLoc, out Vector HitNormal, out PhysicalMaterial PhysMaterial)
{
    TargetPawn;
    ShieldTestResult;
    HitLoc;
    HitNormal;
    PhysMaterial;
}

native final function GetLineCheckRadiusDamageEffect(Pawn TargetPawn, out Vector HitLoc, out Vector HitNormal, out PhysicalMaterial PhysMaterial)
{
    TargetPawn;
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

native final function GetRadiusDamageEffect(Pawn TargetPawn, out ShapeCollisionResult TestResult, bool bExplosionDamage)
{
    TargetPawn;
    TestResult;
    bExplosionDamage;
}

native function bool CanShieldBlockRadiusDamage(Actor TargetPawn, bool bExplosionDamage, out ShieldTestResult ShieldTestResult)
{
    TargetPawn;
    bExplosionDamage;
    ShieldTestResult;
}

native function RunPhysicsSimulationTilEnd(float ProjectileLifeSpan, optional float SimFixedTimeStep = 0.05)
{
    ProjectileLifeSpan;
    SimFixedTimeStep;
}

native function RadiusAttackPawnCollisionCheck()
{
}

native function float GetTerminalVelocity()
{
}

state WaitingForVelocity
{
    simulated function Tick(float DeltaTime)
    {
        if (!IsZero(Velocity))
        {
            Acceleration = AccelRate * Normal(Velocity);
            GotoState(InitialState != 'None' ? InitialState : 'Auto');
        }
    }
    
    Stop;
}

defaultproperties
{
    bWideCheck=True
    ProjFlightEffects="Default__AliceGameProjectile.Particle"
    MaxEffectDistance=10000.0
    DecalWidth=30.0
    DecalHeight=30.0
    CustomGravityScaling=1.0
    RadiusAttackMaxTriggerCount=1
    RadiusAttackRetrigerTime=0.1
    GlobalCheckRadiusTweak=0.5
    ImpactTypeExplosionID="ITE_Boomshot"
    DamageStrength="EDSTR_Light"
    KnockBackParameter=(KnockBackScale=0.0,KnockBackTotalTime=-1.0,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    RadiusDamageTime=0.01
    KnockBackID=1
    StrikBackHitCount=1
    RangeAttackActorList="Default__AliceGameProjectile.RangeAttackActorinfo"
    bSwitchToZeroCollision=True
    CylinderComponent="Default__AliceGameProjectile.CollisionCylinder"
    bCollideActors=False
    bCollideComplex=True
    Components(0)="Default__AliceGameProjectile.CollisionCylinder"
    CollisionComponent="Default__AliceGameProjectile.CollisionCylinder"
}
