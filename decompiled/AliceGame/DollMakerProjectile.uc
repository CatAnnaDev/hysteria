class DollMakerProjectile extends NpcProjectile
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var bool bOnFloor;
var ParticleSystem ProjEffectOnLandTemplate;
var config float Radius;
var config float Duration;
var config float PainInterval;
var config float KnockBackScale;
var config float KnockBackTotalTime;
var config float SpikyDamage;

function SpawnCauseDamageActor(Vector Loc, Rotator Rot)
{
    local CauseDamageActor CDA;
    
    Loc.Z += float(10);
    CDA = Spawn(class'CauseDamageActor', , , Loc, Rot);
    if (CDA != none)
    {
        CDA.Radius = Radius;
        CDA.Duration = Duration;
        CDA.PainInterval = PainInterval;
        CDA.KnockBackScale = KnockBackScale;
        CDA.KnockBackTotalTime = KnockBackTotalTime;
        CDA.SpikyDamage = SpikyDamage;
        CDA.LifeSpan = Duration;
        CDA.SetPhysics(2);
    }
}

simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor TargetActor = none)
{
    if (TargetActor != none)
    {
        SpawnCauseDamageActor(TargetActor.Location, TargetActor.Rotation);
    }
    Explode(HitLocation, HitNormal, TargetActor);
}

simulated singular event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    if (!bOnFloor && Wall.bStatic)
    {
        bOnFloor = true;
        SpawnCauseDamageActor(Location, Rotation);
    }
    else
    {
        HitWall(HitNormal, Wall, WallComp);
    }
}

defaultproperties
{
    bCheckProjectileLight=True
    bWaitForEffects=True
    ProjFlightEffectTemplate="GFX_Eyepot.TeaStreamer_Texture_NoDirection"
    ProjFlightEffects="Default__DollMakerProjectile.Particle"
    ProjTrace="Default__DollMakerProjectile.ProjectileTrace"
    RangeAttackActorList="Default__DollMakerProjectile.RangeAttackActorinfo"
    bRotationFollowsVelocity=True
    MyDamageType="DmgType_DollMaker"
    CylinderComponent="Default__DollMakerProjectile.CollisionCylinder"
    Components(0)="Default__DollMakerProjectile.CollisionCylinder"
    DrawScale=1.2
    LifeSpan=3.0
    CollisionComponent="Default__DollMakerProjectile.CollisionCylinder"
}
