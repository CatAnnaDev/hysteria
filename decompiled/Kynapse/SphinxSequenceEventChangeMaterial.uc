class SphinxSequenceEventChangeMaterial extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const array<int> MatID;
var() const array<MaterialInstance> ChangeMaterial;
var() const array<MaterialInstance> ChangeLockOnHighlightMaterial;
var() const array<MaterialInstance> ChangeDeathMaterial;
var() const array<name> TimeVaryParamName;
var() const bool UseDuplicate;
var() const int ComponentID;

defaultproperties
{
    SequenceType="e_SphinxSequenceET_ChangeMaterial"
}
