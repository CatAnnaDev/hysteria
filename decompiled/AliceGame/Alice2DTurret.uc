class Alice2DTurret extends InterpActor
    placeable
    hidecategories(Navigation);

var() StaticMesh ProjectileMesh;
var() ParticleSystem FireParticle;
var() ParticleSystem ProjectileTrailParticle;
var() SoundCue FireSound;
var Emitter FireParticleEmitter;
var bool bKilled;
var() bool bCanBeDestroyed;

function PlayFireEffect()
{
    if (FireParticle != none)
    {
        FireParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location, Rotation);
        if (FireParticleEmitter != none)
        {
            FireParticleEmitter.SetBase(self);
            FireParticleEmitter.SetLocation(Location);
            FireParticleEmitter.SetTemplate(FireParticle, true);
            FireParticle.WarmupTime = 0.5;
        }
    }
    if (FireSound != none)
    {
        PlaySound(FireSound);
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[1].bHasImpulse)
    {
        bKilled = true;
    }
}

event Tick(float DeltaTime)
{
    if (bKilled)
    {
        return;
    }
    if (FireParticle != none)
    {
        if (FireParticleEmitter != none)
        {
            FireParticleEmitter.SetLocation(Location);
        }
    }
}

function Fire(Turret2DManager Turret2DMan)
{
    local TurretBomb bomb;
    
    if (bKilled)
    {
        return;
    }
    bomb = Spawn(class'TurretBomb', self, , Location, Rotation);
    if (bomb != none)
    {
        Turret2DMan.NumberOfProj++;
        bomb.SetMyOwner(Turret2DMan, self);
        bomb.Init(vector(Rotation), Turret2DMan.projSpeed);
        bomb.SetStaticMesh(ProjectileMesh);
        bomb.ProjectileTrailParticle = ProjectileTrailParticle;
        PlayFireEffect();
    }
}

defaultproperties
{
    bCanBeDestroyed=True
    StaticMeshComponent="Default__Alice2DTurret.StaticMeshComponent0"
    LightEnvironment="Default__Alice2DTurret.MyLightEnvironment"
    Components(0)="Default__Alice2DTurret.MyLightEnvironment"
    Components(1)="Default__Alice2DTurret.StaticMeshComponent0"
    CollisionComponent="Default__Alice2DTurret.StaticMeshComponent0"
}
