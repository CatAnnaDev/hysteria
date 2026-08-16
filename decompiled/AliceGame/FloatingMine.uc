class FloatingMine extends InterpActor
    placeable
    hidecategories(Navigation);

var() float ExplosionRadius;
var() float ExplosionLifeTime;
var() ParticleSystem ExplosionParticle;
var() SoundCue ExplosionSound;
var() Turret2DManager Turret2D_Manager;
var Emitter ExploseParticleEmitter;
var bool bActived;
var array<Actor> ActorList;

function PlayMineExplodeEffect()
{
    if (ExplosionParticle != none)
    {
        ExploseParticleEmitter = Spawn(class'Engine.EmitterSpawnable');
        if (ExploseParticleEmitter != none)
        {
            ExploseParticleEmitter.SetLocation(Location);
            ExploseParticleEmitter.SetTemplate(ExplosionParticle, true);
        }
    }
    if (ExplosionSound != none)
    {
        PlaySound(ExplosionSound);
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (bActived)
    {
        return;
    }
    if (Action.InputLinks[0].bHasImpulse)
    {
        Explode();
    }
}

function Explode()
{
    PlayMineExplodeEffect();
    bActived = true;
    LifeSpan = ExplosionLifeTime;
    SetHidden(true);
}

event Tick(float DeltaTime)
{
    local Actor Other;
    local Alice2DTurret turret;
    
    if (!bActived)
    {
        return;
    }
    foreach VisibleActors(class'Engine.Actor', Other, ExplosionRadius, Location)
    {
        if (BounceVolume(Other) != none || Alice2DTurret(Other) != none)
        {
            break;
        }
        if (ActorList.Find(Other) == -1)
        {
            if (FloatingMine(Other) != none)
            {
                FloatingMine(Other).Explode();
                continue;
            }
            Turret2D_Manager.TriggerEventClass(class'Engine.SeqEvent_TakeDamage', Other, -1);
            ActorList.AddItem(Other);
        }
    }
    foreach VisibleActors(class'Alice2DTurret', turret)
    {
        if (VSize(turret.Location - Location) > ExplosionRadius)
        {
            break;
        }
        if (ActorList.Find(turret) == -1 && turret.bCanBeDestroyed)
        {
            Turret2D_Manager.TriggerEventClass(class'Engine.SeqEvent_TakeDamage', turret, -1);
            ActorList.AddItem(turret);
            turret.bKilled = true;
        }
    }
}

defaultproperties
{
    ExplosionRadius=300.0
    ExplosionLifeTime=2.0
    StaticMeshComponent="Default__FloatingMine.StaticMeshComponent0"
    LightEnvironment="Default__FloatingMine.MyLightEnvironment"
    bNoDelete=False
    Components(0)="Default__FloatingMine.MyLightEnvironment"
    Components(1)="Default__FloatingMine.StaticMeshComponent0"
    CollisionComponent="Default__FloatingMine.StaticMeshComponent0"
}
