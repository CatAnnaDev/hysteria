class KynapseEntityDefinitionPassive extends KynapseEntityDefinition
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display);

var() const string EntityClassName;
var() const KynapseProfileDefinition Profile;

defaultproperties
{
    EntityClassName="CUnrealEntity"
}
