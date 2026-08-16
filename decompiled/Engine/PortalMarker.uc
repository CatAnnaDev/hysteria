class PortalMarker extends NavigationPoint
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

var PortalTeleporter MyPortal;

native function bool CanTeleport(Actor A)
{
    A;
}

defaultproperties
{
    CylinderComponent="Default__PortalMarker.CollisionCylinder"
    GoodSprite="Default__PortalMarker.Sprite"
    BadSprite="Default__PortalMarker.Sprite2"
    bCollideWhenPlacing=False
    bHiddenEd=True
    Components(0)="Default__PortalMarker.Sprite"
    Components(1)="Default__PortalMarker.Sprite2"
    Components(2)="Default__PortalMarker.Arrow"
    Components(3)="Default__PortalMarker.CollisionCylinder"
    Components(4)="Default__PortalMarker.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__PortalMarker.CollisionCylinder"
}
