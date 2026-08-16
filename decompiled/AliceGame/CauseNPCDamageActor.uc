class CauseNPCDamageActor extends Actor
    placeable
    hidecategories(Navigation);

var bool bPainCausing;
var export editinline ParticleSystemComponent PoisonSmokeParticle;
var float Radius;
var float DamageInterval;
var float SmokeDamage;
var float KnockBackScale;
var float KnockBackTotalTime;
var int WeaponLevel;

simulated function Destroyed()
{
    ClearTimer('TickRadiusDamage');
    Destroyed();
}

function IntervalRadiusDamage()
{
    local AliceGameKynapsePawn OneNPC;
    
    foreach AllActors(class'AliceGameKynapsePawn', OneNPC)
    {
        if (VSize2D(OneNPC.Location - Location) < Radius)
        {
            OneNPC.TakeDamage(int(SmokeDamage), none, Location, vect(0.0, 0.0, 0.0), class'Engine.DamageType', , self);
            OneNPC.PlayPhysMatEffectInDamageZone(WeaponLevel);
        }
    }
}

function StartCauseDamage()
{
    SetPhysics(4);
    SetTimer(DamageInterval, true, 'IntervalRadiusDamage');
}

function InitConfigData(float DmgRadius, float interval, float dmg, float Time, ParticleSystem PoisonParticle, int iWeaponLevel)
{
    Radius = DmgRadius;
    DamageInterval = interval;
    SmokeDamage = dmg;
    LifeSpan = Time;
    WeaponLevel = iWeaponLevel;
    if (PoisonParticle != none)
    {
        PoisonSmokeParticle.SetTemplate(PoisonParticle);
    }
}

defaultproperties
{
    bPainCausing=True
    PoisonSmokeParticle="Default__CauseNPCDamageActor.ParticleEffectComp"
    bCollideWorld=True
    Components(0)="Default__CauseNPCDamageActor.Sprite"
    Components(1)="Default__CauseNPCDamageActor.ParticleEffectComp"
    Components(2)="Default__CauseNPCDamageActor.CollisionCylinder"
    CollisionType="COLLIDE_TouchAll"
    CollisionComponent="Default__CauseNPCDamageActor.CollisionCylinder"
}
