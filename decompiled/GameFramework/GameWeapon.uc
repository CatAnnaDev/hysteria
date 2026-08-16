class GameWeapon extends Weapon
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    Mesh="Default__GameWeapon.WeaponMesh"
    CollisionType="COLLIDE_CustomDefault"
}
