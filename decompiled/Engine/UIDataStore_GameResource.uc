class UIDataStore_GameResource extends UIDataStore
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider);

struct native GameResourceDataProvider
{
    var config name ProviderTag;
    var config string ProviderClassName;
    var config bool bExpandProviders;
    var transient class<UIResourceDataProvider> ProviderClass;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var config array<GameResourceDataProvider> ElementProviderTypes;
var const native transient MultiMap_Mirror ListElementProviders;

native final function int FindProviderIndexByFieldValue(name ProviderTag, name SearchField, out const UIProviderScriptFieldValue ValueToSearchFor)
{
    ProviderTag;
    SearchField;
    ValueToSearchFor;
}

native final function bool GetProviderFieldValue(name ProviderTag, name SearchField, int ProviderIndex, out UIProviderScriptFieldValue out_FieldValue)
{
    ProviderTag;
    SearchField;
    ProviderIndex;
    out_FieldValue;
}

native final function bool GetResourceProviderFields(name ProviderTag, out array<name> ProviderFieldTags)
{
    ProviderTag;
    ProviderFieldTags;
}

native final function bool GetResourceProviders(name ProviderTag, out array<UIResourceDataProvider> out_Providers)
{
    ProviderTag;
    out_Providers;
}

native function int GetProviderCount(name ProviderTag)
{
    ProviderTag;
}

native final function name GenerateProviderAccessTag(int ProviderIndex, int InstanceIndex)
{
    ProviderIndex;
    InstanceIndex;
}

native final function int FindProviderTypeIndex(name ProviderTag)
{
    ProviderTag;
}

defaultproperties
{
    ElementProviderTypes(0)=(ProviderTag="GameTypes",ProviderClassName="Engine.UIGameInfoSummary",bExpandProviders=False,ProviderClass="None")
    Tag="GameResources"
}
