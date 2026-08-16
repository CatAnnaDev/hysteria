class PepperGrinderAlternateProjectile extends AliceProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var bool bOnFloor;
var ParticleSystem ProjEffectOnLandTemplate;
var float Radius;
var float Duration;
var float DamageInterval;
var float SmokeDamage;
var float Lifetime;
var ParticleSystem PoisonSmokeParticle;
var config float KnockBackScale;
var config float KnockBackTotalTime;

function DecalData GetDecalData()
{
    local DecalData Decal;
    
    Decal.bIsValid = true;
    switch (GetWeaponLevel())
    {
        case 1:
            Decal.DecalMaterial = MaterialInstanceTimeVarying'GFX_Blood.Decal.BloodSplatter01_Mat_MITV';
            break;
        case 2:
            Decal.DecalMaterial = MaterialInstanceTimeVarying'GFX_Weapons.ImpactDecals.RockShootImpact_INST_TV';
            break;
        case 3:
            Decal.DecalMaterial = MaterialInstanceTimeVarying'GFX_Blood.Decal.BloodSplatter01_Mat_MITV';
            break;
        case 4:
            Decal.DecalMaterial = MaterialInstanceTimeVarying'GFX_Blood.Decal.BloodSplatter01_Mat_MITV';
            break;
        default:
            Decal.DecalMaterial = MaterialInstanceTimeVarying'GFX_Blood.Decal.BloodSplatter01_Mat_MITV';
            break;
    }
    Decal.Width = 300.0;
    Decal.Height = 300.0;
    Decal.WidthSK = 0.0;
    Decal.HeightSK = 0.0;
    Decal.Thickness = 100.0;
    Decal.bRandomizeRotation = true;
    Decal.RandomScalingRange.X = 1.0;
    Decal.RandomScalingRange.Y = 1.0;
    Decal.LifeSpan = 8.0;
    Decal.BlendRange.X = 89.5;
    Decal.BlendRange.Y = 180.0;
    Decal.RandomRadiusOffset = 0.0;
    return Decal;
}

function SpawnDecalOnGround(Vector HitLoc)
{
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent, TraceDir;
    local TraceHitInfo HitInfo;
    local DecalData Decal;
    local MaterialInstanceTimeVarying MITV_Decal;
    
    TraceStart = HitLoc;
    TraceDest = TraceStart + vect(0.0, 0.0, -100.0);
    TraceDir = vect(0.0, 0.0, -1.0);
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, HitInfo, 1);
    if (out_HitNormal.X == float(0) && out_HitNormal.Y == float(0) && out_HitNormal.Z == float(0))
    {
        return;
    }
    if (TraceDir Dot out_HitNormal > -0.087)
    {
        return;
    }
    if (TraceActor != none)
    {
        Decal = GetDecalData();
        if (Decal.bIsValid && Decal.Width != float(0) && Decal.Height != float(0))
        {
            if (Decal.DecalMaterial != none)
            {
                if (MaterialInstanceTimeVarying(Decal.DecalMaterial) != none)
                {
                    MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                    MITV_Decal.SetParent(Decal.DecalMaterial);
                    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, out_HitLocation, rotator(-out_HitNormal), Decal.Width, Decal.Height, Decal.Thickness, false, Decal.bRandomizeRotation ? FRand() * 360.0 : 0.0, HitInfo.HitComponent, true, true, HitInfo.BoneName, , , Decal.LifeSpan, , , Decal.BlendRange);
                    MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                }
                else
                {
                    WorldInfo.MyDecalManager.SpawnDecal(Decal.DecalMaterial, out_HitLocation, rotator(-out_HitNormal), Decal.Width, Decal.Height, Decal.Thickness, true, Decal.bRandomizeRotation ? FRand() * 360.0 : 0.0, HitInfo.HitComponent, true, true, HitInfo.BoneName, , , Decal.LifeSpan, , , Decal.BlendRange);
                }
            }
        }
    }
}

function SpawnCauseDamageActor(Vector Loc, Rotator Rot)
{
    local CauseNPCDamageActor CDA;
    
    Loc.Z += float(10);
    CDA = Spawn(class'CauseNPCDamageActor', , , Loc, Rot);
    if (CDA != none)
    {
        CDA.InitConfigData(Radius, DamageInterval, SmokeDamage, Lifetime, PoisonSmokeParticle, GetWeaponLevel());
        CDA.StartCauseDamage();
    }
    SpawnDecalOnGround(Loc);
}

simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor TargetActor = none)
{
    if (TargetActor != none)
    {
        SpawnCauseDamageActor(TargetActor.Location, TargetActor.Rotation);
    }
    Destroy();
}

simulated singular event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    if (!bOnFloor && Wall.bStatic)
    {
        bOnFloor = true;
        SpawnCauseDamageActor(Location, Rotation);
        setHitNormal(HitNormal);
        Destroy();
    }
    else
    {
        HitWall(HitNormal, Wall, WallComp);
    }
}

function InitConfigData(float DmgRadius, float interval, float dmg, float Time, ParticleSystem PoisonParticle)
{
    Radius = DmgRadius;
    DamageInterval = interval;
    SmokeDamage = dmg;
    Lifetime = Time;
    PoisonSmokeParticle = PoisonParticle;
}

simulated function int GetDLCWeaponFlag()
{
    if (AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_UnLock() && AliceGameInfo(WorldInfo.Game).GetIsDLC_ES_Enable())
    {
        return 1;
    }
    return 0;
}

defaultproperties
{
    AliceProjectileWeaponType=1
    bCheckProjectileLight=True
    bNoRadiusDamageWhenHitPawn=True
    ProjFlightEffectTemplate="GFX_Weapons.VorpalBlade.VB_R_Bullet_L4"
    ProjFlightEffects="Default__PepperGrinderAlternateProjectile.Particle"
    ProjTrace="Default__PepperGrinderAlternateProjectile.ProjectileTrace"
    RangeAttackActorList="Default__PepperGrinderAlternateProjectile.RangeAttackActorinfo"
    MomentumTransfer=1.0
    MyDamageType="DmgType_EyeStaff_RangeProjectile"
    CylinderComponent="Default__PepperGrinderAlternateProjectile.CollisionCylinder"
    Components(0)="Default__PepperGrinderAlternateProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__PepperGrinderAlternateProjectile.CollisionCylinder"
}
