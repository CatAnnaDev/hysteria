class Projectile extends Actor
    abstract
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var config float Speed;
var config float MaxSpeed;
var bool bSwitchToZeroCollision;
var bool bBlockedByInstigator;
var bool bBegunPlay;
var bool bRotationFollowsVelocity;
var bool bNotBlockedByShield;
var Actor ZeroCollider;
var export editinline PrimitiveComponent ZeroColliderComponent;
var config float Damage;
var config float DamageRadius;
var float MomentumTransfer;
var class<DamageType> MyDamageType;
var SoundCue SpawnSound;
var SoundCue ImpactSound;
var Controller InstigatorController;
var Actor ImpactedActor;
var float NetCullDistanceSquared;
var export editinline CylinderComponent CylinderComponent;
var Projectile NextProjectile;

simulated function ApplyFluidSurfaceImpact(FluidSurfaceActor Fluid, Vector HitLocation)
{
    ApplyFluidSurfaceImpact(Fluid, HitLocation);
    if (CanSplash())
    {
        if (WorldInfo.NetMode != 1 && Instigator != none && Instigator.IsPlayerPawn() && Instigator.IsLocallyControlled())
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(Fluid.ProjectileEntryEffect, HitLocation, rotator(vect(0.0, 0.0, 1.0)), self);
        }
    }
}

static simulated function float GetRange()
{
    if (default.LifeSpan == 0.0)
    {
        return 15000.0;
    }
    else
    {
        return default.MaxSpeed * default.LifeSpan;
    }
}

static simulated function float StaticGetTimeToLocation(Vector TargetLoc, Vector StartLoc, Controller RequestedBy)
{
    return VSize(TargetLoc - StartLoc) / default.Speed;
}

simulated function float GetTimeToLocation(Vector TargetLoc)
{
    return VSize(TargetLoc - Location) / Speed;
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    Explode(Location, vect(0.0, 0.0, 1.0));
}

function bool IsStationary()
{
    return false;
}

final simulated function RandSpin(float spinRate)
{
    RotationRate.Yaw = int(spinRate * float(2) * FRand() - spinRate);
    RotationRate.Pitch = int(spinRate * float(2) * FRand() - spinRate);
    RotationRate.Roll = int(spinRate * float(2) * FRand() - spinRate);
}

simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor TargetActor = none)
{
    if (Damage > float(0) && DamageRadius > float(0))
    {
        if (Role == 3)
        {
            MakeNoise(1.0);
        }
        ProjectileHurtRadius(HitLocation, HitNormal);
    }
    Destroy();
}

simulated event EncroachedBy(Actor Other)
{
    HitWall(Normal(Location - Other.Location), Other, none);
}

simulated singular event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local KActorFromStatic NewKActor;
    local StaticMeshComponent HitStaticMesh;
    
    HitWall(HitNormal, Wall, WallComp);
    if (Wall.bWorldGeometry)
    {
        HitStaticMesh = StaticMeshComponent(WallComp);
        if (HitStaticMesh != none && HitStaticMesh.CanBecomeDynamic())
        {
            NewKActor = class'KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
            if (NewKActor != none)
            {
                Wall = NewKActor;
            }
        }
    }
    ImpactedActor = Wall;
    if (!Wall.bStatic && DamageRadius == float(0))
    {
        Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType, , self);
    }
    Explode(Location, HitNormal, Pawn(Wall));
    ImpactedActor = none;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if (InRebound() || Other != Instigator)
    {
        Explode(HitLocation, HitNormal, Other);
    }
}

simulated singular event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (Other == none || Other.bDeleteMe)
    {
        return;
    }
    if (Other.StopsProjectile(self) && Role == 3 || bBegunPlay && bBlockedByInstigator || Other != Instigator)
    {
        ImpactedActor = Other;
        ProcessTouch(Other, HitLocation, HitNormal);
        ImpactedActor = none;
    }
}

simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = Instigator != none ? Instigator.Controller : none, optional bool bDoFullDamage)
{
    local bool bCausedDamage, bResult;
    
    if (bHurtEntry)
    {
        return false;
    }
    bCausedDamage = false;
    if (InstigatedByController == none)
    {
        InstigatedByController = InstigatorController;
    }
    if (ImpactedActor != none && ImpactedActor != self)
    {
        ImpactedActor.TakeRadiusDamage(InstigatedByController, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, true, self);
        bCausedDamage = ImpactedActor.bProjTarget;
    }
    bResult = HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController, bDoFullDamage);
    return bResult || bCausedDamage;
}

simulated function bool ProjectileHurtRadius(Vector HurtOrigin, Vector HitNormal)
{
    local Vector AltOrigin, TraceHitLocation, TraceHitNormal;
    local Actor TraceHitActor;
    
    if (bHurtEntry)
    {
        return false;
    }
    AltOrigin = HurtOrigin;
    if (ImpactedActor != none && ImpactedActor.bWorldGeometry)
    {
        AltOrigin = HurtOrigin + 2.0 * class'Pawn'.default.default.MaxStepHeight * HitNormal;
        TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, AltOrigin, HurtOrigin, false, , , 1);
        if (TraceHitActor == none)
        {
            AltOrigin = HurtOrigin + class'Pawn'.default.default.MaxStepHeight * HitNormal;
        }
        else
        {
            AltOrigin = HurtOrigin + 0.5 * (TraceHitLocation - HurtOrigin);
        }
    }
    return HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, AltOrigin);
}

function Reset()
{
    Destroy();
}

simulated function bool CanSplash()
{
    return bBegunPlay;
}

native simulated function byte GetTeamNum()
{
}

function InitFromWeaponLevelData(Weapon InWeapon)
{
}

function Init(Vector Direction)
{
    SetRotation(rotator(Direction));
    Velocity = Speed * Direction;
}

simulated function Destroyed()
{
    local Projectile CurrentProj;
    
    Destroyed();
    CurrentProj = WorldInfo.ProjectileList;
    if (CurrentProj == self)
    {
        WorldInfo.ProjectileList = NextProjectile;
    }
    else
    {
        while (CurrentProj != none)
        {
            if (CurrentProj.NextProjectile == self)
            {
                CurrentProj.NextProjectile = NextProjectile;
                break;
            }
            CurrentProj = CurrentProj.NextProjectile;
        }
    }
}

simulated event PostBeginPlay()
{
    bBegunPlay = true;
    NextProjectile = WorldInfo.ProjectileList;
    WorldInfo.ProjectileList = self;
}

event PreBeginPlay()
{
    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;
    }
    PreBeginPlay();
    if (!bDeleteMe && InstigatorController != none && InstigatorController.ShotTarget != none && InstigatorController.ShotTarget.Controller != none)
    {
        InstigatorController.ShotTarget.Controller.ReceiveProjectileWarning(self);
    }
}

event bool EncroachingOn(Actor Other)
{
    if (Brush(Other) != none)
    {
        return true;
    }
    return false;
}

simulated function bool InRebound()
{
    return false;
}

defaultproperties
{
    bBlockedByInstigator=True
    MyDamageType="DamageType"
    NetCullDistanceSquared=400000000.0
    CylinderComponent="Default__Projectile.CollisionCylinder"
    bNetTemporary=True
    bReplicateInstigator=True
    bGameRelevant=True
    bCanBeDamaged=True
    bCollideActors=True
    bCollideWorld=True
    Components(0)="Default__Projectile.Sprite"
    Components(1)="Default__Projectile.CollisionCylinder"
    Physics="PHYS_Projectile"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    NetPriority=2.5
    LifeSpan=14.0
    CollisionComponent="Default__Projectile.CollisionCylinder"
}
