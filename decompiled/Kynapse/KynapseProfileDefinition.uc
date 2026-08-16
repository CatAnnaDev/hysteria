class KynapseProfileDefinition extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

struct native EntityInfoUse
{
    var() const KynapseEntityInfoDefinition entityInfo;
    var() const array<KynapseProfileDefinition> computeWith;
    var() const array<KynapseProfileDefinition> searchIn;
    var() const array<KynapseFilter> filters;
};

var() const int profileMaxCount;
var() const export editinline array<EntityInfoUse> EntityInfos;

defaultproperties
{
    profileMaxCount=15
}
