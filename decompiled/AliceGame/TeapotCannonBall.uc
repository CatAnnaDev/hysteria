class TeapotCannonBall extends KActorSpawnable
    notplaceable
    config(Weapon);

var float BlastDelayTime;
var bool bPendingExplode;

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, out const CollisionImpactData RigidCollisionData, int ContactIndex)
{
    if (!bPendingExplode && OtherComponent.Owner.IsA('AliceGameKynapsePawn'))
    {
        bPendingExplode = true;
        OnExplodeTimer();
    }
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    if (Other.IsA('GameBreakableActor') || Other.IsA('AliceGameKynapsePawn'))
    {
        OnExplodeTimer();
    }
}

simulated event Destroyed()
{
    if (Owner != none)
    {
        Owner.LifeSpan = 0.1;
    }
    Destroyed();
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    if (Role == 3)
    {
        MakeNoise(1.0);
    }
    StaticMeshComponent.SetHidden(true);
    LifeSpan = 0.1;
}

simulated function OnExplodeTimer()
{
    local Vector HitNormal;
    
    HitNormal.X = 0.0;
    HitNormal.Y = 0.0;
    HitNormal.Z = 1.0;
    Explode(Location, HitNormal);
}

simulated function StartDelayTimer()
{
    SetTimer(BlastDelayTime, false, 'OnExplodeTimer');
}

function Init(float BlastDelay)
{
    BlastDelayTime = BlastDelay;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

defaultproperties
{
    StaticMeshComponent="Default__TeapotCannonBall.StaticMeshComponent0"
    LightEnvironment="Default__TeapotCannonBall.MyLightEnvironment"
    bCollideWorld=True
    bCallRigidBodyWakeEvents=True
    Components(0)="Default__TeapotCannonBall.MyLightEnvironment"
    Components(1)="Default__TeapotCannonBall.StaticMeshComponent0"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__TeapotCannonBall.StaticMeshComponent0"
}
