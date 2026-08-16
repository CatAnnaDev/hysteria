class UINavigationList extends UIList
    native
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object);

function string GetScenePathAtIndex(int DesiredIndex)
{
    local string ScenePath, ProviderAccessTag, MarkupString;
    local int pos, SelectedItem;
    local UIDataStore_GameResource GameResourceDS;
    local UIProviderScriptFieldValue ScenePathValue;
    
    if (DesiredIndex >= 0 && DesiredIndex < GetItemCount())
    {
        SelectedItem = Items[DesiredIndex];
        if (SelectedItem != -1)
        {
            MarkupString = string(DataSource.DataStoreField);
            pos = InStr(MarkupString, ".");
            if (pos != -1)
            {
                ProviderAccessTag = Left(string(DataSource.DataStoreField), pos);
                MarkupString = Mid(MarkupString, pos + 1) $ ";" $ string(SelectedItem) $ ".DestinationScenePath";
                GameResourceDS = GetGameResourceDataStore();
                if (GameResourceDS.GetProviderFieldValue(name(ProviderAccessTag), name(MarkupString), -1, ScenePathValue))
                {
                    ScenePath = ScenePathValue.StringValue;
                }
            }
        }
    }
    return ScenePath;
}

function string GetItemTagAtIndex(int DesiredIndex)
{
    local string ItemTag, ProviderAccessTag, MarkupString;
    local int pos, SelectedItem;
    local UIDataStore_GameResource GameResourceDS;
    local UIProviderScriptFieldValue ScenePathValue;
    
    if (DesiredIndex >= 0 && DesiredIndex < GetItemCount())
    {
        SelectedItem = Items[DesiredIndex];
        if (SelectedItem != -1)
        {
            MarkupString = string(DataSource.DataStoreField);
            pos = InStr(MarkupString, ".");
            if (pos != -1)
            {
                ProviderAccessTag = Left(string(DataSource.DataStoreField), pos);
                MarkupString = Mid(MarkupString, pos + 1) $ ";" $ string(SelectedItem) $ ".ItemTag";
                GameResourceDS = GetGameResourceDataStore();
                if (GameResourceDS.GetProviderFieldValue(name(ProviderAccessTag), name(MarkupString), -1, ScenePathValue))
                {
                    ItemTag = ScenePathValue.StringValue;
                }
            }
        }
    }
    return ItemTag;
}

function string GetSelectedItemTag()
{
    return GetItemTagAtIndex(Index);
}

function string GetSelectedScenePath()
{
    return GetScenePathAtIndex(Index);
}

static final function UIDataStore_GameResource GetGameResourceDataStore()
{
    return UIDataStore_GameResource(StaticResolveDataStore(class'UIDataStore_GameResource'.default.default.Tag));
}

defaultproperties
{
    VerticalScrollbar="Default__UINavigationList.VertScrollbarTemplate"
    CellDataComponent="Default__UINavigationList.ListPresentationComponent"
    Position=(Value[2]=300.0,Value[3]=400.0,ScaleType[2]="EVALPOS_PixelOwner",ScaleType[3]="EVALPOS_PixelOwner")
    Children(0)="Default__UINavigationList.VertScrollbarTemplate"
    EventProvider="Default__UINavigationList.WidgetEventComponent"
}
