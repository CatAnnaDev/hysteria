class ReplicationInfo extends Info
    abstract
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

defaultproperties
{
    bAlwaysRelevant=True
    RemoteRole="ROLE_SimulatedProxy"
}
