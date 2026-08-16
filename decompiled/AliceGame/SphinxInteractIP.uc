class SphinxInteractIP extends SphinxInterstingPoint
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

event PostBeginPlay()
{
    PostBeginPlay();
}

defaultproperties
{
    IPAmbientSound="Default__SphinxInteractIP.AmbientSound"
    CylinderComponent="Default__SphinxInteractIP.CollisionCylinder"
    GoodSprite="Default__SphinxInteractIP.Sprite"
    BadSprite="Default__SphinxInteractIP.Sprite2"
    Components(0)="Default__SphinxInteractIP.Sprite"
    Components(1)="Default__SphinxInteractIP.Sprite2"
    Components(2)="Default__SphinxInteractIP.Arrow"
    Components(3)="Default__SphinxInteractIP.CollisionCylinder"
    Components(4)="Default__SphinxInteractIP.PathRenderer"
    Components(5)="Default__SphinxInteractIP.AmbientSound"
    CollisionComponent="Default__SphinxInteractIP.CollisionCylinder"
}
