class GameProjectile extends Projectile
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    CylinderComponent="Default__GameProjectile.CollisionCylinder"
    Components(0)="Default__GameProjectile.Sprite"
    Components(1)="Default__GameProjectile.CollisionCylinder"
    CollisionComponent="Default__GameProjectile.CollisionCylinder"
}
