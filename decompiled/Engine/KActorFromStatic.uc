class KActorFromStatic extends KActor
    native
    notplaceable
    transient;

var Actor MyStaticMeshActor;
var float MaxImpulseSpeed;

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    local int Idx;
    local SeqEvent_TakeDamage DmgEvt;
    
    for (Idx = 0; Idx < GeneratedEvents.Length; Idx++)
    {
        DmgEvt = SeqEvent_TakeDamage(GeneratedEvents[Idx]);
        if (DmgEvt != none)
        {
            DmgEvt.HandleDamage(self, InstigatedBy, DamageType, int(BaseDamage));
        }
    }
    if (bDamageAppliesImpulse && DamageType.default.default.RadialDamageImpulse > float(0) && Role == 3)
    {
        ApplyImpulse(Location - HurtOrigin, DamageType.default.default.RadialDamageImpulse, Location, , DamageType);
    }
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    local Vector HitDir;
    local float ImpulseMag;
    
    HitDir = Location - Other.Location;
    HitDir.Z = FMax(HitDir.Z, 0.0);
    HitDir = Normal(HitDir);
    ImpulseMag = FMax(0.5 * Pawn(Other).GroundSpeed, (Other.Velocity - Velocity) Dot HitDir);
    ApplyImpulse(HitDir, ImpulseMag, Location);
}

event ApplyImpulse(Vector ImpulseDir, float ImpulseMag, Vector HitLocation, optional TraceHitInfo HitInfo, optional class<DamageType> DamageType)
{
    local float BodyMass;
    
    BodyMass = StaticMeshComponent.BodyInstance.GetBodyMass();
    if (BodyMass > 0.0 && DamageType == none || !DamageType.default.default.bRadialDamageVelChange)
    {
        if (BodyMass < 1.0)
        {
            BodyMass = Sqrt(BodyMass);
        }
        ImpulseMag = FMin(ImpulseMag / BodyMass, MaxImpulseSpeed);
    }
    CollisionComponent.AddImpulse(Normal(ImpulseDir) * ImpulseMag, HitLocation, , true);
}

native static function KActorFromStatic MakeDynamic(StaticMeshComponent MovableMesh)
{
    MovableMesh;
}

native static function MakeStatic()
{
}

function BecomeStatic()
{
    if (StaticMeshComponent.RigidBodyIsAwake())
    {
        WarnInternal(string(self) $ " SHOULDN'T BE AWAKE");
        return;
    }
    MakeStatic();
    Destroy();
}

event OnWakeRBPhysics()
{
    ClearTimer('BecomeStatic');
}

event OnSleepRBPhysics()
{
    SetTimer(3.0, false, 'BecomeStatic');
}

defaultproperties
{
    MaxImpulseSpeed=900.0
    StaticMeshComponent="None"
    LightEnvironment="None"
    bNoDelete=False
    bCallRigidBodyWakeEvents=True
    CollisionComponent="None"
}
