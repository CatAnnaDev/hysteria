class PrefabSequence extends Sequence
    native
    notplaceable
    hidecategories(Object);

var PrefabInstance OwnerPrefab;

native final function PrefabInstance GetOwnerPrefab()
{
}

native final function SetOwnerPrefab(PrefabInstance InOwner)
{
    InOwner;
}

defaultproperties
{
    ObjName="PrefabSequence"
    bDeletable=False
}
