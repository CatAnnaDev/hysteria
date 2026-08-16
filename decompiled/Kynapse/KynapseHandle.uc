class KynapseHandle extends ActorComponent
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

var() KynapseEntityDefinition KEntityDefinition;
var transient array<Pointer> kynapseEntityArray;
var transient array<Pointer> kynapseEntityHandleArray;
var transient bool creationDone;
var transient bool entityAddedToWorld;

native final function RegisterToProfile(coerce string ProfileName)
{
    ProfileName;
}

native final function AddKynapseEntity()
{
}

native final function InitKynapseEntity()
{
}

defaultproperties
{
}
