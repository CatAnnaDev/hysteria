class UIDataStore_StringAliasMap extends UIDataStore_StringBase
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Object,UIRoot);

struct native UIMenuInputMap
{
    var name FieldName;
    var name Set;
    var string MappedText;
};

var config array<UIMenuInputMap> MenuInputMapArray;
var const native transient Map_Mirror MenuInputSets;
var const transient int PlayerIndex;

native function int GetStringWithFieldName(string FieldName, out string MappedString)
{
    FieldName;
    MappedString;
}

native final function int FindMappingWithFieldName(optional string FieldName = "", optional string SetName = "")
{
    FieldName;
    SetName;
}

native final function LocalPlayer GetPlayerOwner()
{
}

defaultproperties
{
    PlayerIndex=-1
    Tag="StringAliasMap"
}
