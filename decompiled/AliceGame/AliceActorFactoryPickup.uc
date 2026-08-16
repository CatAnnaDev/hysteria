class AliceActorFactoryPickup extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object)
    autoexpandcategories(Factory);

var() editinline class<Weapon> WeaponClass;

defaultproperties
{
    NewActorClass="AliceDroppedPickup"
    bPlaceable=False
}
