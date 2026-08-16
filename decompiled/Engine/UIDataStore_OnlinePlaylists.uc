class UIDataStore_OnlinePlaylists extends UIDataStore
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider);

const UNRANKEDPROVIDERTAG = "PlaylistsUnranked";
const RANKEDPROVIDERTAG = "PlaylistsRanked";

var const native noexport Pointer VfTable_IUIListElementProvider;
var config string ProviderClassName;
var transient class<UIResourceDataProvider> ProviderClass;
var const array<UIResourceDataProvider> RankedDataProviders;
var const array<UIResourceDataProvider> UnRankedDataProviders;

static function OnlinePlaylistProvider GetOnlinePlaylistProvider(name ProviderTag, int PlaylistId, optional out int ProviderIndex)
{
    local UIDataStore_OnlinePlaylists PlaylistDS;
    local UIProviderScriptFieldValue Value;
    local UIResourceDataProvider PlaylistProvider;
    
    ProviderIndex = -1;
    PlaylistDS = UIDataStore_OnlinePlaylists(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlinePlaylists'.default.default.Tag));
    if (PlaylistDS != none)
    {
        Value.PropertyTag = 'PlaylistId';
        Value.PropertyType = 0;
        Value.StringValue = string(PlaylistId);
        ProviderIndex = PlaylistDS.FindProviderIndexByFieldValue(ProviderTag, 'PlaylistId', Value);
        if (ProviderIndex != -1)
        {
            PlaylistDS.GetPlaylistProvider(ProviderTag, ProviderIndex, PlaylistProvider);
        }
    }
    return OnlinePlaylistProvider(PlaylistProvider);
}

native final function bool GetPlaylistProvider(name ProviderTag, int ProviderIndex, out UIResourceDataProvider out_Provider)
{
    ProviderTag;
    ProviderIndex;
    out_Provider;
}

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

defaultproperties
{
    Tag="OnlinePlaylists"
}
