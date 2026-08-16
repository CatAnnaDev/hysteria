class FluidSurfaceActor extends Actor
    native
    placeable
    hidecategories(Navigation)
    autoexpandcategories(FluidSurfaceActor,FluidSurfaceComponent);

var() const export editconst editinline FluidSurfaceComponent FluidComponent;
var() ParticleSystem ProjectileEntryEffect;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Touch(Other, OtherComp, HitLocation, HitNormal);
    Other.ApplyFluidSurfaceImpact(self, HitLocation);
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    FluidComponent.ApplyForce(HitLocation, FluidComponent.ForceImpact, FluidComponent.TestRippleRadius, true);
}

defaultproperties
{
    FluidComponent="Default__FluidSurfaceActor.NewFluidComponent"
    bNoDelete=True
    bMovable=False
    bCollideActors=True
    bProjTarget=True
    Components(0)="Default__FluidSurfaceActor.NewFluidComponent"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
}
