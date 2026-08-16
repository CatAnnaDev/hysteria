class KynapseWorldServiceEntityManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseWorldServiceEntityManager);

var() const array<KynapseFilter> declaredFilters;
var() const array<KynapseProfileDefinition> Profiles;

defaultproperties
{
    time_aperiodicTasksList(0)=(taskName="CEntityInfoManager::Update",Priority=1.0,tpf=0.5,maxCall=1)
    serviceName="EntityInfoManager"
    ClassName="CEntityInfoManager"
}
