class ProjectileRigidBallBase extends KActorSpawnable
    native
    notplaceable
    config(Weapon);

var float BlastDelayTime;
var float ImpulseValue;
var DecalActorMovable DecalActorM;
var MaterialInstanceTimeVarying MITV_Decal;
var ParticleSystem ExplodeParticle;
var SoundCue ExplodeSound;
var bool bForceOnGround;
var transient bool bExploded;
var AliceGameProjectile ProjOwner;
var Actor TargetActor;
var int bSelfRotating;
var Rotator SelfRotationRate;

simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    DestroyBall();
}

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, out const CollisionImpactData RigidCollisionData, int ContactIndex)
{
    if (ShouldTriggerCollisionEvent(OtherComponent.Owner))
    {
        if (!bForceOnGround && OtherComponent.Owner.IsA('AlicePawn') || OtherComponent.Owner.IsA('AliceClonePawn'))
        {
            ExplodeDirectly(true);
            TargetActor = OtherComponent.Owner;
        }
        else
        {
            WakeBall(true);
        }
    }
    else
    {
        WakeBall(true);
    }
}

function DestroyBall()
{
    LifeSpan = 0.01;
    if (ProjOwner != none)
    {
        ProjOwner.LifeSpan = 0.01;
    }
    ProjOwner.RigidBall = none;
}

simulated function Explode(bool bNeedExplodeProj, Vector HitLocation, Vector HitNormal)
{
    if (Role == 3)
    {
        MakeNoise(1.0);
    }
    if (ProjOwner != none && bNeedExplodeProj)
    {
        ProjOwner.OnRigidBallExplode(HitLocation, HitNormal);
    }
    StaticMeshComponent.SetHidden(true);
    StaticMeshComponent.PutRigidBodyToSleep();
}

simulated function OnExplodeTimer()
{
    local ParticleSystemComponent PSC;
    
    ExplodeDirectly(true);
    if (ExplodeSound != none)
    {
        PlaySound(ExplodeSound);
    }
    if (ExplodeParticle != none)
    {
        PSC = WorldInfo.MyEmitterPool.SpawnEmitter(ExplodeParticle, Location, rot(0, 0, 1));
        PSC.__OnSystemFinished__Delegate = OnParticleSystemFinished;
    }
}

simulated function ExplodeDirectly(bool bNeedExplodeProj)
{
    local Vector HitNormal;
    
    HitNormal = vect(0.0, 0.0, 1.0);
    if (!bExploded)
    {
        Explode(bNeedExplodeProj, Location, HitNormal);
        bExploded = true;
    }
    ClearTimer('OnExplodeTimer');
}

simulated function OnProjHitWall(Actor Wall)
{
    if (ShouldTriggerCollisionEvent(Wall))
    {
        if (!bForceOnGround && Wall.IsA('AlicePawn') || Wall.IsA('AliceClonePawn') || !Wall.bStatic)
        {
            ExplodeDirectly(true);
        }
        else
        {
            WakeBall(true);
            if (ProjOwner != none)
            {
                ProjOwner.RangeAttackActorList.Reset();
            }
        }
    }
    else
    {
        WakeBall(true);
    }
}

simulated function OnProjBump(Actor Other)
{
    if (ShouldTriggerCollisionEvent(Other))
    {
        if (!bForceOnGround && Other.IsA('AlicePawn') || Other.IsA('AliceClonePawn'))
        {
            ExplodeDirectly(true);
        }
        else
        {
            WakeBall(true);
        }
    }
    else
    {
        WakeBall(true);
    }
}

simulated function OnProjShutDown()
{
    if (!ProjOwner.bInExplodeDamage)
    {
        WakeBall(false);
    }
}

simulated function OnProjTouch(Actor Other)
{
    if (ShouldTriggerCollisionEvent(Other))
    {
        if (!bForceOnGround && Other.IsA('AlicePawn') || Other.IsA('AliceClonePawn'))
        {
            ExplodeDirectly(false);
        }
        else
        {
            WakeBall(true);
        }
    }
    else
    {
        WakeBall(true);
    }
}

function WakeBall(bool bEnableBounce)
{
    if (ProjOwner != none && !ProjOwner.bInBallMoving)
    {
        ProjOwner.bInBallMoving = true;
        if (bEnableBounce)
        {
            SetPhysics(10);
            StaticMeshComponent.WakeRigidBody();
            ApplyImpulse(-Normal(ProjOwner.Velocity), ImpulseValue, ProjOwner.Location);
            StartDelayTimer();
        }
        else
        {
            ExplodeDirectly(true);
        }
    }
}

simulated function StartDelayTimer()
{
    SetTimer(BlastDelayTime, false, 'OnExplodeTimer');
}

function InitParam(AliceGameProjectile Proj)
{
    if (Proj != none)
    {
        BlastDelayTime = Proj.BallBlastDelayTime;
        ImpulseValue = Proj.BallImpulseValue;
        ProjOwner = Proj;
        TargetActor = none;
        bSelfRotating = Proj.bBallSelfRotating;
        SelfRotationRate = Proj.BallSelfRotaionRate;
    }
    bExploded = false;
}

function bool ShouldTriggerCollisionEvent(Actor CollisionCauser)
{
    return true;
}

defaultproperties
{
    StaticMeshComponent="Default__ProjectileRigidBallBase.StaticMeshComponent0"
    LightEnvironment="Default__ProjectileRigidBallBase.MyLightEnvironment"
    bCollideActors=False
    bCollideWorld=True
    bCollideComplex=True
    Components(0)="Default__ProjectileRigidBallBase.MyLightEnvironment"
    Components(1)="Default__ProjectileRigidBallBase.StaticMeshComponent0"
    CollisionComponent="Default__ProjectileRigidBallBase.StaticMeshComponent0"
}
