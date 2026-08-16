class UITabPage extends UIContainer
    native
    placeable
    hidedropdown
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStoreSubscriber);

const TABPAGE_DESCRIPTION_DATABINDING_INDEX = 1;
const TABPAGE_CAPTION_DATABINDING_INDEX = 0;

var const native noexport Pointer VfTable_IUIDataStoreSubscriber;
var const class<UITabButton> ButtonClass;
var UITabButton TabButton;
var(Data) UIDataStoreBinding ButtonCaption;
var(Data) UIDataStoreBinding ButtonToolTip;
var(Data) UIDataStoreBinding PageDescription;

function bool IsActivePage()
{
    local UITabControl TCOwner;
    
    TCOwner = GetOwnerTabControl();
    return TCOwner != none && TCOwner.ActivePage == self;
}

function SetTabCaption(string NewButtonMarkup)
{
    TabButton.SetDataStoreBinding(NewButtonMarkup);
}

function bool IsFocusInitializationRequired(int PlayerIndex)
{
    local UIScene SceneOwner;
    local bool bResult;
    
    if (Children.Length > 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != none && !IsEditor() && SceneOwner.bPerformedInitialUpdate)
        {
            bResult = Clamp(PlayerIndex, 0, 4) >= FocusPropagation.Length || FocusPropagation[PlayerIndex].FirstFocusTarget == none;
        }
    }
    return bResult;
}

function bool CanActivatePage(int PlayerIndex)
{
    local bool bResult;
    
    if (TabButton != none)
    {
        if (TabButton.CanActivateButton(PlayerIndex))
        {
            bResult = true;
        }
    }
    else
    {
        LogInternal("NULL TabButton for" @ GetWidgetPathName() @ "in CanActivatePage()");
    }
    return bResult;
}

function AddedToTabControl(UITabControl TabControl)
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

function UITabButton GetTabButton(optional UITabControl TabControl = none)
{
    if (TabControl != none && TabButton == none)
    {
        LinkToTabButton(CreateTabButton(TabControl), TabControl);
    }
    return TabButton;
}

native final function UITabControl GetOwnerTabControl()
{
}

event RemovedFromParent(UIScreenObject WidgetOwner)
{
    RemovedFromParent(WidgetOwner);
    if (WidgetOwner == TabButton)
    {
        TabButton = none;
    }
}

event bool LinkToTabButton(UITabButton NewButton, UITabControl TabControl)
{
    local bool bResult;
    local UIObject CurrentOwner;
    local UITabControl CurrentTabControl;
    
    if (NewButton != none)
    {
        CurrentOwner = GetOwner();
        if (CurrentOwner != none)
        {
            CurrentTabControl = GetOwnerTabControl();
            if (CurrentTabControl != TabControl)
            {
                if (CurrentTabControl != none)
                {
                    CurrentTabControl.RemovePage(self, GetBestPlayerIndex());
                }
                else
                {
                    CurrentOwner.RemoveChild(self);
                }
            }
            else if (CurrentOwner == NewButton && CurrentOwner.ContainsChild(self, false) && TabButton == NewButton && NewButton.GetDataStoreBinding() == ButtonCaption.MarkupString)
            {
                bResult = true;
            }
        }
        if (!bResult && NewButton.InsertChild(self) != -1 || NewButton.ContainsChild(self, false))
        {
            TabButton = NewButton;
            NewButton.SetDataStoreBinding(ButtonCaption.MarkupString);
            bResult = true;
        }
    }
    return bResult;
}

protected static event UITabButton CreateTabButton(UITabControl TabControl)
{
    local UITabButton NewTabButton;
    
    if (TabControl != none)
    {
        assert(default.ButtonClass != none);
        NewTabButton = UITabButton(TabControl.CreateWidget(TabControl, default.ButtonClass));
    }
    return NewTabButton;
}

event bool ActivatePage(int PlayerIndex, bool bActivate, optional bool bTakeFocus = true)
{
    local bool bResult;
    
    bResult = true;
    if (bActivate)
    {
        if (CanActivatePage(PlayerIndex))
        {
            SetVisibility(true);
            if (bTakeFocus)
            {
                if (TabButton != none && TabButton.IsTargeted())
                {
                    TabButton.DeactivateStateByClass(class'UIState_TargetedTab', PlayerIndex);
                }
                if (IsFocusInitializationRequired(PlayerIndex))
                {
                    RebuildNavigationLinks();
                }
                if (SetFocus(none, PlayerIndex))
                {
                }
                else
                {
                    SetVisibility(false);
                    bResult = false;
                }
            }
            else if (TabButton != none && !TabButton.IsTargeted())
            {
                TabButton.ActivateStateByClass(class'UIState_TargetedTab', PlayerIndex);
            }
        }
        else
        {
            bResult = false;
        }
    }
    else
    {
        if (TabButton != none && TabButton.IsTargeted())
        {
            TabButton.DeactivateStateByClass(class'UIState_TargetedTab', PlayerIndex);
        }
        SetVisibility(false);
    }
    return bResult;
}

defaultproperties
{
    ButtonClass="UITabButton"
    ButtonToolTip=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=100,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    PageDescription=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    PrivateFlags=640
    EventProvider="Default__UITabPage.WidgetEventComponent"
}
