class Alice2DTurretMine extends Alice2DTurret
    placeable
    hidecategories(Navigation);

var() float ExplosionRadius;
var() float ExplosionLifeTime;
var() ParticleSystem ExplosionParticle;
var() SoundCue ExplosionSound;
var Emitter ExploseParticleEmitter;
var Turret2DManager Man;

function PlayMineExplodeEffect(Actor Other, Vector Loc, Rotator Rot)
{
    local AliceTurretMineExplode MineExplode;
    
    if (ExplosionParticle != none)
    {
        ExploseParticleEmitter = Other.Spawn(class'Engine.EmitterSpawnable', Other, , Other.Location);
        if (ExploseParticleEmitter != none)
        {
            ExploseParticleEmitter.SetLocation(Other.Location);
            ExploseParticleEmitter.SetTemplate(ExplosionParticle, true);
        }
    }
    if (ExplosionSound != none)
    {
        PlaySound(ExplosionSound);
    }
    MineExplode = Spawn(class'AliceTurretMineExplode', , , Loc, Rot);
    if (MineExplode != none)
    {
        MineExplode.ExplosionRadius = ExplosionRadius;
        MineExplode.LifeSpan = ExplosionLifeTime;
        MineExplode.MyOwner = Man;
        MineExplode.MyTurretMine = self;
    }
}

function Fire(Turret2DManager Turret2DMan)
{
    local TurretMine bomb;
    
    Man = Turret2DMan;
    bomb = Spawn(class'TurretMine', self, , Location, Rotation);
    if (bomb != none)
    {
        Turret2DMan.NumberOfProj++;
        bomb.SetMyOwner(Turret2DMan, self);
        bomb.Init(vector(Rotation), Turret2DMan.projSpeed);
        bomb.SetStaticMesh(ProjectileMesh);
        bomb.TurretMine = self;
        bomb.ProjectileTrailParticle = ProjectileTrailParticle;
        PlayFireEffect();
    }
}

defaultproperties
{
    ExplosionRadius=300.0
    ExplosionLifeTime=2.0
    StaticMeshComponent="Default__Alice2DTurretMine.StaticMeshComponent0"
    LightEnvironment="Default__Alice2DTurretMine.MyLightEnvironment"
    Components(0)="Default__Alice2DTurretMine.MyLightEnvironment"
    Components(1)="Default__Alice2DTurretMine.StaticMeshComponent0"
    CollisionComponent="Default__Alice2DTurretMine.StaticMeshComponent0"
}
