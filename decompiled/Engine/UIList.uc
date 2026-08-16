class UIList extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

const ResizeBufferPixels = 5;

enum EListWrapBehavior
{
    LISTWRAP_None,
    LISTWRAP_Smooth,
    LISTWRAP_Jump,
};

enum ECellLinkType
{
    LINKED_None,
    LINKED_Rows,
    LINKED_Columns,
};

enum ECellAutoSizeMode
{
    CELLAUTOSIZE_None,
    CELLAUTOSIZE_Uniform,
    CELLAUTOSIZE_Constrain,
    CELLAUTOSIZE_AdjustList,
};

struct native transient CellHitDetectionInfo
{
    var int HitColumn;
    var int HitRow;
    var int ResizeColumn;
    var int ResizeRow;
};

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Appearance) UIScreenValue_Extent RowHeight;
var(Appearance) UIScreenValue_Extent MinColumnSize;
var(Appearance) UIScreenValue_Extent ColumnWidth;
var(Appearance) UIScreenValue_Extent HeaderCellPadding;
var(Appearance) UIScreenValue_Extent HeaderElementSpacing;
var(Appearance) UIScreenValue_Extent CellSpacing;
var(Appearance) UIScreenValue_Extent CellPadding;
var transient int Index;
var transient int TopIndex;
var(Appearance) transient duplicatetransient editconst int MaxVisibleItems;
var(Appearance) int ColumnCount;
var(Appearance) int RowCount;
var(Appearance) ECellAutoSizeMode ColumnAutoSizeMode;
var(Appearance) ECellAutoSizeMode RowAutoSizeMode;
var(Appearance) ECellLinkType CellLinkType;
var(Appearance) EListWrapBehavior WrapType;
var(Appearance) bool bEnableMultiSelect;
var(Controls) bool bEnableVerticalScrollbar;
var transient bool bInitializeScrollbars;
var(Interaction) bool bAllowDisabledItemSelection;
var(Interaction) bool bSingleClickSubmission;
var(Appearance) bool bUpdateItemUnderCursor;
var(Appearance) bool bHoverStateOverridesSelected;
var(Appearance) bool bForceFullPageDisplay;
var(Interaction) bool bAllowColumnResizing;
var(ZDebug) transient bool bDisplayDataBindings;
var const transient bool bSortingList;
var UIScrollbar VerticalScrollbar;
var UIStyleReference GlobalCellStyle[4];
var UIStyleReference ColumnHeaderStyle;
var UIStyleReference ColumnHeaderBackgroundStyle[3];
var UIStyleReference ItemOverlayStyle[4];
var const transient int ResizeColumn;
var transient int SetIndexMutex;
var transient int ValueChangeNotificationMutex;
var(Data) UIDataStoreBinding DataSource;
var const transient UIListElementProvider DataProvider;
var const transient array<int> Items;
var transient array<int> SelectedItems;
var(Components) export editinline UIComp_DrawImage BackgroundImageComponent;
var(Components) export editinline UIComp_ListElementSorter SortComponent;
var(Components) export editinline UIComp_ListPresenterBase CellDataComponent;
var(Sound) name SubmitDataSuccessCue;
var(Sound) name SubmitDataFailedCue;
var(Sound) name DecrementIndexCue;
var(Sound) name IncrementIndexCue;
var(Sound) name SortAscendingCue;
var(Sound) name SortDescendingCue;
var delegate<OnSubmitSelection> __OnSubmitSelection__Delegate;
var delegate<OnListElementsSorted> __OnListElementsSorted__Delegate;
var delegate<ShouldDisableElement> __ShouldDisableElement__Delegate;
var delegate<OnOverrideListElementState> __OnOverrideListElementState__Delegate;

final function OnStateChanged(UIScreenObject Sender, int PlayerIndex, UIState NewlyActiveState, optional UIState PreviouslyActiveState)
{
    if (Sender == self)
    {
        if (UIState_Pressed(NewlyActiveState) != none)
        {
            SetMouseCaptureOverride(true);
        }
        else if (UIState_Pressed(PreviouslyActiveState) != none)
        {
            SetMouseCaptureOverride(false);
        }
    }
}

function ClickedScrollZone(UIScrollbar Sender, float PositionPerc, int PlayerIndex)
{
    local int MouseX, MouseY;
    local float MarkerPosition;
    local bool bDecrement;
    local int NewTopItem;
    
    if (GetCursorPosition(MouseX, MouseY))
    {
        MarkerPosition = Sender.GetMarkerButtonPosition();
        bDecrement = (Sender.ScrollbarOrientation == 1 ? float(MouseY) < MarkerPosition : float(MouseX) < MarkerPosition);
        NewTopItem = (bDecrement ? TopIndex - MaxVisibleItems : TopIndex + MaxVisibleItems);
        SetTopIndex(NewTopItem, true);
    }
}

final function bool ShouldRenderColumnHeaders()
{
    if (CellDataComponent != none)
    {
        return CellDataComponent.ShouldRenderColumnHeaders();
    }
    return false;
}

final function EnableColumnHeaderRendering(optional bool bShouldRenderColHeaders = true)
{
    if (CellDataComponent != none)
    {
        CellDataComponent.EnableColumnHeaderRendering(bShouldRenderColHeaders);
    }
}

final event bool IsValueChangeNotificationEnabled()
{
    return ValueChangeNotificationMutex == 0;
}

final event DisableValueChangeNotification()
{
    ValueChangeNotificationMutex++;
}

final event EnableValueChangeNotification()
{
    if (--ValueChangeNotificationMutex < 0)
    {
        ScriptTrace();
        WarnInternal("EnableValueChangeNotification called too many times on (" $ string(WidgetTag) $ ")" @ string(Class.Name) $ "'" $ PathName(self) $ "'; resetting value back to 0.");
        ValueChangeNotificationMutex = 0;
    }
}

final event bool IsSetIndexEnabled()
{
    return SetIndexMutex == 0;
}

final event DisableSetIndex()
{
    SetIndexMutex++;
}

final event EnableSetIndex()
{
    if (--SetIndexMutex < 0)
    {
        ScriptTrace();
        WarnInternal("EnableSetIndex called too many times on (" $ string(WidgetTag) $ ")" @ string(Class.Name) $ "'" $ PathName(self) $ "'; resetting value back to 0.");
        SetIndexMutex = 0;
    }
}

final event DecrementAllMutexes(optional bool bDispatchUpdates)
{
    EnableValueChangeNotification();
    EnableSetIndex();
    if (bDispatchUpdates)
    {
        SetIndex(Index, true);
        if (AllMutexesDisabled())
        {
            RequestFormattingUpdate();
            RequestSceneUpdate(false, true);
        }
    }
}

final event IncrementAllMutexes()
{
    DisableValueChangeNotification();
    DisableSetIndex();
}

final event bool AllMutexesDisabled()
{
    return IsSetIndexEnabled() && IsValueChangeNotificationEnabled();
}

event PostInitialize()
{
    PostInitialize();
    ConditionalPropagateEnabledState(GetBestPlayerIndex());
}

event Initialized()
{
    Initialized();
    SetActiveCursorUpdate(bUpdateItemUnderCursor);
    if (VerticalScrollbar != none)
    {
        VerticalScrollbar.__OnScrollActivity__Delegate = ScrollVertical;
        VerticalScrollbar.__OnClickedScrollZone__Delegate = ClickedScrollZone;
    }
}

native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1)
{
    out_BoundDataStores;
    BindingIndex;
}

native final function bool IsElementAutoSizingEnabled()
{
}

native final function ClearBoundDataStores()
{
}

native final function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores)
{
    out_BoundDataStores;
}

native final function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex)
{
    SourceDataStore;
    bValuesInvalidated;
    PropertyTag;
    SourceProvider;
    ArrayIndex;
}

native final function bool RefreshSubscriberValue(optional int BindingIndex = -1)
{
    BindingIndex;
}

native final function string GetDataStoreBinding(optional int BindingIndex = -1)
{
    BindingIndex;
}

native final function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1)
{
    MarkupText;
    BindingIndex;
}

native final function bool IsHotTrackingEnabled()
{
}

native final function SetHotTracking(bool bShouldUpdateItemUnderCursor)
{
    bShouldUpdateItemUnderCursor;
}

native final function bool CanSelectElement(int ElementIndex)
{
    ElementIndex;
}

native final function bool IsElementSelected(int ElementIndex)
{
    ElementIndex;
}

native final function bool IsElementEnabled(int ElementIndex)
{
    ElementIndex;
}

native final function bool SetTopIndex(int NewTopIndex, optional bool bClampValue = true)
{
    NewTopIndex;
    bClampValue;
}

native final function bool NavigateIndex(bool bIncrementIndex, bool bFullPage, bool bHorizontalNavigation)
{
    bIncrementIndex;
    bFullPage;
    bHorizontalNavigation;
}

native final function bool SetIndex(int NewIndex, optional bool bClampValue = true, optional bool bSkipNotification = false)
{
    NewIndex;
    bClampValue;
    bSkipNotification;
}

native final function int FindItemIndex(string ItemValue, optional int CellIndex = -1)
{
    ItemValue;
    CellIndex;
}

native final function EUIListElementState GetElementCellState(int ElementIndex)
{
    ElementIndex;
}

native final function bool SetElementCellState(int ElementIndex, EUIListElementState NewElementState)
{
    ElementIndex;
    NewElementState;
}

native final function string GetElementValue(int ElementIndex, optional int CellIndex = -1)
{
    ElementIndex;
    CellIndex;
}

native final function int GetCurrentItem()
{
}

native final function array<int> GetSelectedItems()
{
}

native function int GetResizeColumn(optional out CellHitDetectionInfo ClickedCell)
{
    ClickedCell;
}

native function int CalculateIndexFromCursorLocation(optional bool bRequireValidIndex = true)
{
    bRequireValidIndex;
}

native final function Vector2D GetClientRegion()
{
}

native function float GetRowHeight(optional int RowIndex = -1, optional bool bColHeader, optional bool bReturnUnformattedValue)
{
    RowIndex;
    bColHeader;
    bReturnUnformattedValue;
}

native final function float GetColumnWidth(optional int ColumnIndex = -1, optional bool bColHeader, optional bool bReturnUnformattedValue)
{
    ColumnIndex;
    bColHeader;
    bReturnUnformattedValue;
}

native final function SetRowCount(int NewRowCount)
{
    NewRowCount;
}

native final function SetColumnCount(int NewColumnCount)
{
    NewColumnCount;
}

native final function int GetTotalColumnCount()
{
}

native final function int GetTotalRowCount()
{
}

native final function int GetMaxNumVisibleColumns()
{
}

native final function int GetMaxNumVisibleRows()
{
}

native function int GetMaxVisibleElementCount()
{
}

native function int GetItemCount()
{
}

native function int RemoveElement(int ElementToRemove)
{
    ElementToRemove;
}

native final function bool ScrollVertical(UIScrollbar Sender, float PositionChange, optional bool bPositionMaxed = false)
{
    Sender;
    PositionChange;
    bPositionMaxed;
}

delegate EUIListElementState OnOverrideListElementState(UIList Sender, int ElementIndex, EUIListElementState CurrentState, EUIListElementState NewElementState)
{
}

delegate bool ShouldDisableElement(UIList Sender, int ElementIndex)
{
}

delegate OnListElementsSorted(UIList Sender)
{
}

delegate OnSubmitSelection(UIList Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
}

defaultproperties
{
    RowHeight=(Value=16.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal")
    MinColumnSize=(Value=0.5,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal")
    ColumnWidth=(Value=100.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal")
    Index=-1
    TopIndex=-1
    ColumnCount=1
    RowCount=4
    ColumnAutoSizeMode="CELLAUTOSIZE_Uniform"
    RowAutoSizeMode="CELLAUTOSIZE_Constrain"
    CellLinkType="LINKED_Columns"
    bEnableVerticalScrollbar=True
    bInitializeScrollbars=True
    bForceFullPageDisplay=True
    bAllowColumnResizing=True
    VerticalScrollbar="Default__UIList.VertScrollbarTemplate"
    GlobalCellStyle=(DefaultStyleTag="DefaultCellStyleNormal",RequiredStyleClass="UIStyle_Combo",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    GlobalCellStyle[1]=(DefaultStyleTag="DefaultCellStyleActive",RequiredStyleClass="UIStyle_Combo",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    GlobalCellStyle[2]=(DefaultStyleTag="DefaultCellStyleSelected",RequiredStyleClass="UIStyle_Combo",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    GlobalCellStyle[3]=(DefaultStyleTag="DefaultCellStyleHover",RequiredStyleClass="UIStyle_Combo",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ColumnHeaderStyle=(DefaultStyleTag="DefaultColumnHeaderStyle",RequiredStyleClass="UIStyle_Combo",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ColumnHeaderBackgroundStyle=(DefaultStyleTag="None",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ColumnHeaderBackgroundStyle[1]=(DefaultStyleTag="None",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ColumnHeaderBackgroundStyle[2]=(DefaultStyleTag="None",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ItemOverlayStyle=(DefaultStyleTag="ListItemBackgroundNormalStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ItemOverlayStyle[1]=(DefaultStyleTag="ListItemBackgroundActiveStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ItemOverlayStyle[2]=(DefaultStyleTag="ListItemBackgroundSelectedStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ItemOverlayStyle[3]=(DefaultStyleTag="ListItemBackgroundHoverStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    ResizeColumn=-1
    DataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Collection",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    CellDataComponent="Default__UIList.ListPresentationComponent"
    SubmitDataSuccessCue="ListSubmit"
    SubmitDataFailedCue="GenericError"
    DecrementIndexCue="ListUp"
    IncrementIndexCue="ListDown"
    SortAscendingCue="SortAscending"
    SortDescendingCue="SortDescending"
    PrimaryStyle=(DefaultStyleTag="DefaultListStyle",RequiredStyleClass="UIStyle_Combo")
    PrivateFlags=1024
    bSupportsPrimaryStyle=False
    DebugBoundsColor=(B=255,G=255,R=255,A=255)
    bSupportsFocusHint=True
    Children(0)="Default__UIList.VertScrollbarTemplate"
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    DefaultStates(4)="UIState_Pressed"
    EventProvider="Default__UIList.WidgetEventComponent"
    __NotifyActiveStateChanged__Delegate="None"
}
