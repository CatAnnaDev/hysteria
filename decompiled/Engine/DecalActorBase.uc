class DecalActorBase extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var() const export editconst editinline DecalComponent Decal;

defaultproperties
{
    Decal="Default__DecalActorBase.NewDecalComponent"
    bStatic=True
    bMovable=False
    Components(0)="Default__DecalActorBase.NewDecalComponent"
    Components(1)="Default__DecalActorBase.Sprite"
    Components(2)="Default__DecalActorBase.ArrowComponent0"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
}
