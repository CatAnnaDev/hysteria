class CrowdAgentBase extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation)
    implements(Interface_NavigationHandle);

var const native noexport Pointer VfTable_IInterface_NavigationHandle;

event NotifyPathChanged()
{
}

defaultproperties
{
    CollisionType="COLLIDE_CustomDefault"
}
