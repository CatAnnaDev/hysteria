class TurretBomb extends DynamicSMActor
    notplaceable
    hidecategories(Navigation);

var Turret2DManager MyOwner;
var Alice2DTurret My2DTurret;
var float flySpeed;
var bool bInited;
var Emitter TrailParticleEmitter;
var() ParticleSystem ProjectileTrailParticle;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (!AlicePlayerCamera(MyOwner.MyPC.PlayerCamera).CanSeeEx(Location))
    {
        return;
    }
    if (MyOwner.CheckActorType(Other))
    {
        if (BounceVolume(Other) != none)
        {
            LifeSpan = 0.02;
        }
        else
        {
            if (Alice2DTurret(Other) != none && Alice2DTurret(Other) != My2DTurret)
            {
                Alice2DTurret(Other).bKilled = true;
            }
            MyOwner.TriggerEventClass(class'Engine.SeqEvent_TakeDamage', Other, -1);
        }
    }
}

simulated event Destroyed()
{
    MyOwner.NumberOfProj--;
    TrailParticleEmitter.LifeSpan = 2.0;
    TrailParticleEmitter.ParticleSystemComponent.DeactivateSystem();
    TrailParticleEmitter.bCurrentlyActive = false;
    Destroyed();
}

function PlayTrailParticle()
{
    if (ProjectileTrailParticle != none)
    {
        if (TrailParticleEmitter == none)
        {
            TrailParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
            if (TrailParticleEmitter != none)
            {
                TrailParticleEmitter.SetTemplate(ProjectileTrailParticle, true);
            }
        }
        else
        {
            TrailParticleEmitter.SetLocation(Location);
        }
    }
}

event Tick(float DeltaTime)
{
    local Vector dis;
    
    if (!bInited)
    {
        return;
    }
    dis = flySpeed * vector(Rotation) * DeltaTime * 30.0;
    SetLocation(Location + dis);
    PlayTrailParticle();
}

function Init(Vector Dir, float Speed)
{
    SetRotation(rotator(Dir));
    Velocity = Speed * Dir;
    flySpeed = Speed;
    LifeSpan = MyOwner.ProjLifeTime;
    bInited = true;
}

function SetMyOwner(Turret2DManager Man, Alice2DTurret turret)
{
    MyOwner = Man;
    My2DTurret = turret;
}

defaultproperties
{
    StaticMeshComponent="Default__TurretBomb.StaticMeshComponent0"
    LightEnvironment="Default__TurretBomb.MyLightEnvironment"
    bCollideActors=True
    Components(0)="Default__TurretBomb.MyLightEnvironment"
    Components(1)="Default__TurretBomb.StaticMeshComponent0"
    CollisionType="COLLIDE_TouchAll"
    CollisionComponent="Default__TurretBomb.StaticMeshComponent0"
}
