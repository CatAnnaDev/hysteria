class UIDataStore_OnlineGameSearch extends UIDataStore_Remote
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

struct native GameSearchCfg
{
    var class<OnlineGameSearch> GameSearchClass;
    var class<OnlineGameSettings> DefaultGameSettingsClass;
    var class<UIDataProvider_Settings> SearchResultsProviderClass;
    var UIDataProvider_Settings DesiredSettingsProvider;
    var array<UIDataProvider_Settings> SearchResults;
    var OnlineGameSearch Search;
    var name SearchName;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const name SearchResultsName;
var OnlineSubsystem OnlineSub;
var OnlineGameInterface GameInterface;
var const array<GameSearchCfg> GameSearchCfgList;
var int SelectedIndex;
var int ActiveSearchIndex;

function ClearAllSearchResults()
{
    local int OriginalActiveIndex, GameTypeIndex;
    
    OriginalActiveIndex = ActiveSearchIndex;
    if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        for (GameTypeIndex = 0; GameTypeIndex < GameSearchCfgList.Length; GameTypeIndex++)
        {
            ActiveSearchIndex = GameTypeIndex;
            if (GameInterface.FreeSearchResults(GameSearchCfgList[GameTypeIndex].Search))
            {
                BuildSearchResults();
                continue;
            }
            WarnInternal(string(Name) $ ".ClearAllSearchResults: Failed to free search results for" @ string(GameSearchCfgList[GameTypeIndex].SearchName) @ "(" $ string(GameTypeIndex) $ ") - search is still in progress");
        }
    }
    ActiveSearchIndex = OriginalActiveIndex;
}

event MoveToPrevious(optional bool bInvalidateExistingSearchResults = true)
{
    SelectedIndex = Max(SelectedIndex - 1, 0);
    if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
    {
        RefreshSubscribers(SearchResultsName, true, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
    }
}

event MoveToNext(optional bool bInvalidateExistingSearchResults = true)
{
    SelectedIndex = Min(SelectedIndex + 1, GameSearchCfgList.Length - 1);
    if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
    {
        RefreshSubscribers(SearchResultsName, true, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
    }
}

event SetCurrentByName(name SearchName, optional bool bInvalidateExistingSearchResults = true)
{
    local int Index;
    
    Index = FindSearchConfigurationIndex(SearchName);
    if (Index != -1)
    {
        SelectedIndex = Index;
        if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
        {
            RefreshSubscribers(SearchResultsName, true, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
        }
    }
    else
    {
        LogInternal("Invalid name (" $ string(SearchName) $ ") specified to SetCurrentByName() on " $ string(self));
    }
}

event SetCurrentByIndex(int NewIndex, optional bool bInvalidateExistingSearchResults = true)
{
    if (NewIndex >= 0 && NewIndex < GameSearchCfgList.Length)
    {
        SelectedIndex = NewIndex;
        if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
        {
            RefreshSubscribers(SearchResultsName, true, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
        }
    }
    else
    {
        LogInternal("Invalid index (" $ string(NewIndex) $ ") specified to SetCurrentByIndex() on " $ string(self));
    }
}

function int FindSearchConfigurationIndex(name SearchTag)
{
    local int Index;
    
    for (Index = 0; Index < GameSearchCfgList.Length; Index++)
    {
        if (GameSearchCfgList[Index].SearchName == SearchTag)
        {
            return Index;
        }
    }
    return -1;
}

event OnlineGameSearch GetActiveGameSearch()
{
    if (ActiveSearchIndex >= 0 && ActiveSearchIndex < GameSearchCfgList.Length)
    {
        return GameSearchCfgList[ActiveSearchIndex].Search;
    }
    return none;
}

event OnlineGameSearch GetCurrentGameSearch()
{
    if (SelectedIndex >= 0 && SelectedIndex < GameSearchCfgList.Length)
    {
        return GameSearchCfgList[SelectedIndex].Search;
    }
    return none;
}

native function BuildSearchResults()
{
}

event bool ShowHostGamercard(byte ControllerIndex, int ListIndex)
{
    local OnlinePlayerInterfaceEx PlayerExt;
    local OnlineGameSettings Game;
    
    if (ListIndex >= 0 && ListIndex < GameSearchCfgList[SelectedIndex].Search.Results.Length)
    {
        if (OnlineSub != none)
        {
            PlayerExt = OnlineSub.PlayerInterfaceEx;
            if (NotEqual_InterfaceInterface(PlayerExt, OnlinePlayerInterfaceEx(none)))
            {
                Game = GameSearchCfgList[SelectedIndex].Search.Results[ListIndex].GameSettings;
                return PlayerExt.ShowGamerCardUI(ControllerIndex, Game.OwningPlayerId);
            }
            else
            {
                WarnInternal("OnlineSubsystem does not support the extended player interface. Can't show gamercard");
            }
        }
        else
        {
            WarnInternal("No OnlineSubsystem present. Can't show gamercard");
        }
    }
    else
    {
        WarnInternal("Invalid index (" $ string(ListIndex) $ ") specified for online game to show the gamercard of");
    }
}

event bool GetSearchResultFromIndex(int ListIndex, out OnlineGameSearchResult Result)
{
    if (ListIndex >= 0 && ListIndex < GameSearchCfgList[SelectedIndex].Search.Results.Length)
    {
        Result = GameSearchCfgList[SelectedIndex].Search.Results[ListIndex];
        return true;
    }
    return false;
}

function OnSearchComplete(bool bWasSuccessful)
{
    if (bWasSuccessful == true)
    {
        BuildSearchResults();
        NotifyPropertyChanged(SearchResultsName);
        RefreshSubscribers(SearchResultsName, false, GameSearchCfgList[ActiveSearchIndex].DesiredSettingsProvider);
    }
    else
    {
        LogInternal("Failed to search for online games");
    }
}

protected function bool OverrideQuerySubmission(byte ControllerId, OnlineGameSearch Search)
{
    return false;
}

event bool SubmitGameSearch(byte ControllerIndex, optional bool bInvalidateExistingSearchResults = true)
{
    if (OnlineSub != none)
    {
        if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            if (bInvalidateExistingSearchResults || ActiveSearchIndex == SelectedIndex)
            {
                InvalidateCurrentSearchResults();
            }
            if (ActiveSearchIndex == -1 || !GameSearchCfgList[ActiveSearchIndex].Search.bIsSearchInProgress)
            {
                ActiveSearchIndex = SelectedIndex;
            }
            if (OverrideQuerySubmission(ControllerIndex, GameSearchCfgList[ActiveSearchIndex].Search))
            {
                return true;
            }
            InvalidateCurrentSearchResults();
            return GameInterface.FindOnlineGames(ControllerIndex, GameSearchCfgList[ActiveSearchIndex].Search);
        }
        else
        {
            WarnInternal("OnlineSubsystem does not support the game interface. Can't search for games");
        }
    }
    else
    {
        WarnInternal("No OnlineSubsystem present. Can't search for games");
    }
    return false;
}

function bool InvalidateCurrentSearchResults()
{
    local OnlineGameSearch ActiveSearch;
    local bool bResult;
    
    ActiveSearch = GetActiveGameSearch();
    if (ActiveSearch != none)
    {
        if (GameInterface.FreeSearchResults(ActiveSearch))
        {
            BuildSearchResults();
            RefreshSubscribers(SearchResultsName, true, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
            bResult = true;
        }
    }
    return bResult;
}

event Init()
{
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        if (NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
        }
    }
}

defaultproperties
{
    SearchResultsName="SearchResults"
    ActiveSearchIndex=-1
    Tag="OnlineGameSearch"
    WriteAccessType="ACCESS_WriteAll"
}
