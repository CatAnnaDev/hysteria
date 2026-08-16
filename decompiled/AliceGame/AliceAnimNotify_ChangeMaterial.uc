class AliceAnimNotify_ChangeMaterial extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native MaterialInfo
{
    var() int MatID;
    var() MaterialInstance NewMat;
};

var() array<MaterialInfo> NewMaterials;
var() bool UseDuplicate;
var() int ComponentID;

defaultproperties
{
}
