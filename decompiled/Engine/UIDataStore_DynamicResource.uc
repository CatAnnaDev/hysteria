class UIDataStore_DynamicResource extends UIDataStore
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider);

struct native DynamicResourceProviderDefinition
{
    var config name ProviderTag;
    var config string ProviderClassName;
    var transient class<UIResourceCombinationProvider> ProviderClass;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var transient UIDataProvider_OnlineProfileSettings ProfileProvider;
var transient UIDataStore_GameResource GameResourceDataStore;
var config array<DynamicResourceProviderDefinition> ResourceProviderDefinitions;
var const native transient MultiMap_Mirror ResourceProviders;

event Unregistered(LocalPlayer PlayerOwner)
{
    local int TypeIndex, ProviderIndex;
    local array<UIResourceCombinationProvider> ProviderInstances;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Unregistered(PlayerOwner);
    if (ProfileProvider.Player == PlayerOwner || ProfileProvider.Player == none)
    {
        ProfileProvider = none;
    }
    GameResourceDataStore = none;
    for (TypeIndex = 0; TypeIndex < ResourceProviderDefinitions.Length; TypeIndex++)
    {
        if (GetResourceProviders(ResourceProviderDefinitions[TypeIndex].ProviderTag, ProviderInstances))
        {
            for (ProviderIndex = 0; ProviderIndex < ProviderInstances.Length; ProviderIndex++)
            {
                ProviderInstances[ProviderIndex].ClearProviderReferences();
            }
        }
    }
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
    }
}

event Registered(LocalPlayer PlayerOwner)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local UIDataStore_OnlinePlayerData PlayerProfileDS;
    
    Registered(PlayerOwner);
    PlayerProfileDS = UIDataStore_OnlinePlayerData(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlinePlayerData'.default.default.Tag, none, PlayerOwner));
    if (PlayerProfileDS != none)
    {
        ProfileProvider = PlayerProfileDS.ProfileProvider;
    }
    GameResourceDataStore = UIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_GameResource'.default.default.Tag, none, PlayerOwner));
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
    }
}

native final function OnLoginChange(byte LocalUserNum)
{
    LocalUserNum;
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

native final function bool GetResourceProviders(name ProviderTag, out array<UIResourceCombinationProvider> out_Providers)
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
    Tag="DynamicGameResource"
}
