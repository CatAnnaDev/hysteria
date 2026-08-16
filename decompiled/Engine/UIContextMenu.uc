class UIContextMenu extends UIList
    native
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object,List);

enum EContextMenuItemType
{
    CMIT_Normal,
    CMIT_Submenu,
    CMIT_Separator,
    CMIT_Check,
    CMIT_Radio,
};

struct native transient ContextMenuItem
{
    var const transient UIContextMenu OwnerMenu;
    var const native transient Pointer ParentItem;
    var EContextMenuItemType ItemType;
    var string ItemText;
    var int ItemId;
};

var const transient UIObject InvokingWidget;
var const transient array<ContextMenuItem> MenuItems;
var const transient bool bResolvePosition;

event int FindMenuItemIndex(UIObject Widget, string ItemToFind)
{
    local int Result;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    Result = -1;
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                Result = SceneDS.FindCollectionValueIndex(WidgetDSTag, ItemToFind);
            }
        }
    }
    return Result;
}

event bool GetMenuItem(UIObject Widget, int IndexToGet, out string out_MenuItem)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                bResult = SceneDS.GetCollectionValue(WidgetDSTag, IndexToGet, out_MenuItem);
            }
        }
    }
    return bResult;
}

event bool GetAllMenuItems(UIObject Widget, out array<string> out_MenuItems)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                bResult = SceneDS.GetCollectionValueArray(WidgetDSTag, out_MenuItems);
            }
        }
    }
    return bResult;
}

event bool RemoveMenuItemAtIndex(UIObject Widget, int IndexToRemove)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                if (SceneDS.RemoveCollectionValueByIndex(WidgetDSTag, IndexToRemove))
                {
                    RefreshSubscriberValue();
                    bResult = true;
                }
            }
        }
    }
    return bResult;
}

event bool RemoveMenuItem(UIObject Widget, string ItemToRemove)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                if (SceneDS.RemoveCollectionValue(WidgetDSTag, ItemToRemove))
                {
                    RefreshSubscriberValue();
                    bResult = true;
                }
            }
        }
    }
    return bResult;
}

event bool ClearMenuItems(UIObject Widget)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                if (SceneDS.ClearCollectionValueArray(WidgetDSTag))
                {
                    RefreshSubscriberValue();
                    bResult = true;
                }
            }
        }
    }
    return bResult;
}

event bool InsertMenuItem(UIObject Widget, string Item, optional int InsertIndex = -1, optional bool bAllowDuplicates)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                if (SceneDS.InsertCollectionValue(WidgetDSTag, Item, InsertIndex, , bAllowDuplicates))
                {
                    RefreshSubscriberValue();
                    bResult = true;
                }
            }
        }
    }
    return bResult;
}

event bool SetMenuItems(UIObject Widget, array<string> NewMenuItems, optional bool bClearExisting = true, optional int InsertIndex = -1)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local name WidgetDSTag;
    
    if (Widget != none && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != none)
            {
                WidgetDSTag = name(ConvertWidgetIDToString(Widget));
                if (SceneDS.SetCollectionValueArray(WidgetDSTag, NewMenuItems, bClearExisting, InsertIndex))
                {
                    RefreshSubscriberValue();
                    bResult = true;
                }
            }
        }
    }
    return bResult;
}

native final function bool Close(optional int PlayerIndex = GetBestPlayerIndex())
{
    PlayerIndex;
}

native final function bool Open(optional int PlayerIndex = GetBestPlayerIndex())
{
    PlayerIndex;
}

native final function bool IsActiveContextMenu()
{
}

defaultproperties
{
    ColumnAutoSizeMode="CELLAUTOSIZE_AdjustList"
    RowAutoSizeMode="CELLAUTOSIZE_AdjustList"
    WrapType="LISTWRAP_Jump"
    bEnableVerticalScrollbar=False
    bInitializeScrollbars=False
    bSingleClickSubmission=True
    bUpdateItemUnderCursor=True
    VerticalScrollbar="Default__UIContextMenu.VertScrollbarTemplate"
    CellDataComponent="Default__UIContextMenu.ContextMenuDataComponent"
    bEnableActiveCursorUpdates=True
    Position=(Value[2]=16.0,Value[3]=100.0,ScaleType="EVALPOS_PixelViewport",ScaleType[1]="EVALPOS_PixelViewport",ScaleType[2]="EVALPOS_PixelOwner",ScaleType[3]="EVALPOS_PixelOwner")
    bHidden=True
    Children(0)="Default__UIContextMenu.VertScrollbarTemplate"
    EventProvider="Default__UIContextMenu.WidgetEventComponent"
}
