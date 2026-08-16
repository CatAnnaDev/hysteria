class UIComboBox extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

const COMBO_CAPTION_DATABINDING_INDEX = 1;
const INDEX_CHANGED_NOTIFY_MASK = 0x2;
const TEXT_CHANGED_NOTIFY_MASK = 0x1;

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var const class<UIEditBox> ComboEditboxClass;
var const class<UIToggleButton> ComboButtonClass;
var const class<UIList> ComboListClass;
var(Controls) const editinline noclear UIEditBox ComboEditbox;
var(Controls) const editinline noclear UIToggleButton ComboButton;
var(Controls) const editinline noclear UIList ComboList;
var(Components) const export editinline UIComp_DrawCaption CaptionRenderComponent;
var(Components) const export editinline UIComp_DrawImage BackgroundRenderComponent;
var(Data) const editconst UIDataStoreBinding CaptionDataSource;
var(Sound) name OpenList;
var(Sound) name DecrementCue;
var(Appearance) bool bDockListToButton;
var delegate<CreateCustomComboEditbox> __CreateCustomComboEditbox__Delegate;
var delegate<CreateCustomComboButton> __CreateCustomComboButton__Delegate;
var delegate<CreateCustomComboList> __CreateCustomComboList__Delegate;

function ListItemSelected(UIList Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
    if (ComboEditbox != none)
    {
        SetEditboxText(Sender.GetElementValue(Sender.Index), PlayerIndex, true, true);
        HideList();
        ComboEditbox.SetFocus(none, PlayerIndex);
        NotifyValueChanged(PlayerIndex, 2);
    }
}

function SelectedItemChanged(UIObject Sender, int PlayerIndex)
{
    local string SelectedItemText;
    
    if (ComboEditbox != none && Sender == ComboList && ComboList != none && ComboList.IsHidden())
    {
        SelectedItemText = ComboList.GetElementValue(ComboList.Index);
        SetEditboxText(SelectedItemText, PlayerIndex, true, true);
        NotifyValueChanged(PlayerIndex, 2);
    }
}

function EditboxTextChanged(UIObject Sender, int PlayerIndex)
{
    NotifyValueChanged(PlayerIndex, 1);
}

function bool ShowListClickHandler(UIScreenObject EventObject, int PlayerIndex)
{
    local bool bResult;
    
    if (ComboList != none)
    {
        ShowList(PlayerIndex);
        UIObject(EventObject).__OnClicked__Delegate = None;
        bResult = true;
    }
    return bResult;
}

function ButtonPressed(UIScreenObject EventObject, int PlayerIndex)
{
    if (ComboList != none && ComboList.IsHidden())
    {
        ComboButton.__OnClicked__Delegate = ShowListClickHandler;
    }
}

function EditboxPressed(UIScreenObject EventObject, int PlayerIndex)
{
    if (ComboList != none && ComboList.IsHidden() && ComboEditbox.IsReadOnly())
    {
        ComboEditbox.__OnClicked__Delegate = ShowListClickHandler;
    }
}

function SetListDocking(bool bDockToButton)
{
    if (bDockListToButton != bDockToButton)
    {
        bDockListToButton = bDockToButton;
        if (ComboList != none)
        {
            if (bDockListToButton && ComboButton != none)
            {
                ComboList.SetDockTarget(2, ComboButton, 0);
            }
            else
            {
                ComboList.SetDockTarget(2, self, 2);
            }
            ComboList.RequestFormattingUpdate();
        }
    }
}

final function bool IsListDockedToButton()
{
    return bDockListToButton;
}

function SetEditboxText(string NewText, int PlayerIndex, optional bool bListItemsOnly, optional bool bSkipNotification)
{
    if (ComboEditbox != none)
    {
        if ((bListItemsOnly || ComboEditbox.IsReadOnly()) && ComboList != none)
        {
        }
        ComboEditbox.SetValue(NewText, PlayerIndex, bSkipNotification);
    }
}

event HideList(optional int PlayerIndex = GetBestPlayerIndex())
{
    if (ComboList != none)
    {
        ComboButton.SetValue(false, PlayerIndex);
        ComboList.SetVisibility(false);
    }
}

event ShowList(optional int PlayerIndex = GetBestPlayerIndex())
{
    if (ComboList != none)
    {
        ComboList.SetVisibility(true);
        ComboButton.SetValue(true, PlayerIndex);
        ComboList.SetFocus(none, PlayerIndex);
        ComboList.SetTopIndex(ComboList.Index);
    }
}

event SetVisibility(bool bIsVisible)
{
    SetVisibility(bIsVisible);
    HideList();
}

event PostInitialize()
{
    PostInitialize();
    if (ComboButton != none)
    {
        ComboButton.__OnPressed__Delegate = ButtonPressed;
        ComboButton.__OnClicked__Delegate = None;
    }
    if (ComboList != none)
    {
        ComboList.__OnValueChanged__Delegate = SelectedItemChanged;
        ComboList.__OnSubmitSelection__Delegate = ListItemSelected;
    }
    if (ComboEditbox != none)
    {
        ComboEditbox.__OnValueChanged__Delegate = EditboxTextChanged;
        ComboEditbox.__OnPressed__Delegate = EditboxPressed;
        if (ComboEditbox.IsReadOnly())
        {
            ComboEditbox.__OnClicked__Delegate = None;
        }
    }
    ConditionalPropagateEnabledState(GetBestPlayerIndex());
}

native function SetupChildStyles()
{
}

native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1)
{
    out_BoundDataStores;
    BindingIndex;
}

native function ClearBoundDataStores()
{
}

native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores)
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

delegate UIList CreateCustomComboList(UIComboBox ListOwner)
{
}

delegate UIToggleButton CreateCustomComboButton(UIComboBox ButtonOwner)
{
}

delegate UIEditBox CreateCustomComboEditbox(UIComboBox EditboxOwner)
{
}

defaultproperties
{
    ComboEditboxClass="UIEditBox"
    ComboButtonClass="UIToggleButton"
    ComboListClass="UIList"
    CaptionDataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    PrivateFlags=1024
    bSupportsPrimaryStyle=False
    Position=(Value[2]=256.0,Value[3]=32.0,ScaleType[2]="EVALPOS_PixelOwner",ScaleType[3]="EVALPOS_PixelOwner")
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Active"
    DefaultStates(3)="UIState_Focused"
    DefaultStates(4)="UIState_Pressed"
    EventProvider="Default__UIComboBox.WidgetEventComponent"
}
