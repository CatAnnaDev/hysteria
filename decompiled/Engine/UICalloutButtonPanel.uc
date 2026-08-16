class UICalloutButtonPanel extends UIContainer
    native
    placeable
    perobjectconfig
    config(UI)
    hidecategories(Object,UIRoot,Object);

enum ECalloutButtonLayoutType
{
    CBLT_None,
    CBLT_DockLeft,
    CBLT_DockRight,
    CBLT_Centered,
    CBLT_Justified,
};

var(ZDebug) duplicatetransient editconst editinline UICalloutButton ButtonTemplate;
var(ZDebug) transient editconst editinline array<UICalloutButton> CalloutButtons;
var(Appearance) EUIOrientation ButtonBarOrientation;
var(Appearance) ECalloutButtonLayoutType ButtonLayout;
var(Appearance) UIScreenValue_Extent ButtonPadding[2];
var const native transient map<int, int> ButtonInputKeyMappings;
var config array<name> CalloutButtonAliases;
var transient bool bGeneratingInitialButtons;
var(Interaction) bool bSupportsButtonRepeat;
var(ZDebug) transient bool bRefreshButtonDocking;

function OnButtonVisibilityChanged(UIScreenObject SourceWidget, bool bIsVisible)
{
    local UICalloutButton ButtonSender;
    
    ButtonSender = UICalloutButton(SourceWidget);
    if (ButtonSender != none)
    {
        RequestButtonDockingUpdate();
    }
}

function InitializeInputProxy()
{
    local UIEvent_CalloutButtonInputProxy InputProxy;
    local int ButtonIdx;
    
    InputProxy = GetCalloutInputProxy(true);
    if (InputProxy != none)
    {
        for (ButtonIdx = 0; ButtonIdx < CalloutButtons.Length; ButtonIdx++)
        {
            if (CalloutButtons[ButtonIdx] != none)
            {
                CalloutButtons[ButtonIdx].SubscribeToInputProxy(InputProxy);
            }
        }
    }
}

function ConfigureChildButton(UICalloutButton ChildButton)
{
    if (ChildButton != none && ChildButton.Outer == self)
    {
        RequestButtonDockingUpdate();
        ChildButton.bSupportsButtonRepeat = bSupportsButtonRepeat;
        ChildButton.__NotifyVisibilityChanged__Delegate = OnButtonVisibilityChanged;
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") UICalloutButtonPanel::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "NULL ChildButton specified.");
    }
}

event RemovedFromParent(UIScreenObject WidgetOwner)
{
    local UISequence ProxyParentSequence;
    local UIEvent_CalloutButtonInputProxy InputProxy;
    local int ButtonIdx;
    
    RemovedFromParent(WidgetOwner);
    InputProxy = GetCalloutInputProxy(false);
    if (InputProxy != none)
    {
        for (ButtonIdx = 0; ButtonIdx < CalloutButtons.Length; ButtonIdx++)
        {
            if (CalloutButtons[ButtonIdx] != none)
            {
                CalloutButtons[ButtonIdx].UnsubscribeFromInputProxy(InputProxy);
            }
        }
        ProxyParentSequence = UISequence(InputProxy.ParentSequence);
        if (ProxyParentSequence != none)
        {
            ProxyParentSequence.RemoveSequenceObject(InputProxy);
        }
    }
}

event PostInitialize()
{
    PostInitialize();
    bGeneratingInitialButtons = true;
    PopulateCalloutButtonArray();
    bGeneratingInitialButtons = false;
    RequestButtonDockingUpdate();
    InitializeInputProxy();
}

event bool CanButtonAcceptFocus(name InputAliasTag, optional int PlayerIndex = GetBestPlayerIndex())
{
    local bool bResult;
    local UICalloutButton TargetButton;
    
    TargetButton = FindButton(InputAliasTag);
    if (TargetButton != none)
    {
        bResult = TargetButton.CanAcceptFocus(PlayerIndex);
    }
    return bResult;
}

event bool ContainsButton(name ButtonInputAlias)
{
    local UICalloutButton TargetButton;
    
    TargetButton = FindButton(ButtonInputAlias);
    return TargetButton != none;
}

event int FindButtonIndex(name ButtonInputAlias)
{
    local int ButtonIdx, Result;
    
    Result = -1;
    for (ButtonIdx = 0; ButtonIdx < CalloutButtons.Length; ButtonIdx++)
    {
        if (CalloutButtons[ButtonIdx] != none && CalloutButtons[ButtonIdx].InputAliasTag == ButtonInputAlias && CalloutButtons[ButtonIdx].Outer == self)
        {
            Result = ButtonIdx;
            break;
        }
    }
    return Result;
}

event UICalloutButton FindButton(name ButtonInputAlias)
{
    local int ButtonIdx;
    local UICalloutButton Result;
    
    ButtonIdx = FindButtonIndex(ButtonInputAlias);
    if (ButtonIdx >= 0 && ButtonIdx < CalloutButtons.Length)
    {
        Result = CalloutButtons[ButtonIdx];
    }
    return Result;
}

event bool EnableButton(name ButtonInputAlias, optional int PlayerIndex = GetBestPlayerIndex(), optional bool bEnableButton = true, optional bool bUpdateButtonVisibility = true)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != none)
    {
        if (TargetButton.SetEnabled(bEnableButton, PlayerIndex))
        {
            bResult = true;
            if (bUpdateButtonVisibility || bEnableButton)
            {
                TargetButton.SetVisibility(bEnableButton);
            }
        }
    }
    return bResult;
}

event bool ShowButton(name ButtonInputAlias, optional bool bShowButton = true)
{
    local UICalloutButton TargetButton;
    local bool bResult, bVisible;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != none)
    {
        bVisible = TargetButton.IsVisible();
        TargetButton.SetVisibility(bShowButton);
        bResult = bVisible != bShowButton && bShowButton == TargetButton.IsVisible();
    }
    return bResult;
}

event bool SetButtonCallback(name ButtonInputAlias, delegate<OnClicked> NewClickHandler)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != none)
    {
        TargetButton.__OnClicked__Delegate = NewClickHandler;
        bResult = true;
    }
    return bResult;
}

event bool SetButtonInputAlias(name ButtonInputAlias, coerce name NewButtonInputAlias)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != none)
    {
        if (!ContainsButton(NewButtonInputAlias) && TargetButton.SetInputAlias(NewButtonInputAlias))
        {
            RequestSceneUpdate(true, false);
            bResult = true;
        }
    }
    return bResult;
}

event bool SetButtonCaption(name ButtonInputAlias, string NewButtonCaption)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != none)
    {
        TargetButton.SetDataStoreBinding(NewButtonCaption);
        RequestButtonDockingUpdate();
        bResult = true;
    }
    return bResult;
}

event bool RemoveAllButtons()
{
    RemoveChildren(CalloutButtons);
    return CalloutButtons.Length == 0;
}

event bool RemoveButtonByAlias(name ButtonInputAlias)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != none)
    {
        bResult = RemoveChild(TargetButton);
    }
    return bResult;
}

event bool RemoveButton(UICalloutButton ButtonToRemove)
{
    local bool bResult;
    
    if (ButtonToRemove != none && ContainsButton(ButtonToRemove.InputAliasTag))
    {
        bResult = RemoveChild(ButtonToRemove);
    }
    return bResult;
}

event int InsertButton(UICalloutButton NewButton)
{
    local int Result, InsertIndex;
    
    Result = -1;
    if (NewButton != none && NewButton.InputAliasTag != 'None')
    {
        if (ContainsButton(NewButton.InputAliasTag))
        {
            LogInternal("(" $ string(Name) $ ") UICalloutButtonPanel::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Already contains a button with the tag '" $ string(NewButton.InputAliasTag) $ "'");
        }
        else
        {
            InsertIndex = FindBestInsertionIndex(NewButton, true);
            Result = InsertChild(NewButton, InsertIndex);
        }
    }
    else if (NewButton == none)
    {
        LogInternal("(" $ string(Name) $ ") UICalloutButtonPanel::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "NewButton is NULL!");
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") UICalloutButtonPanel::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "You must set the InputAliasTag for " $ string(NewButton) $ " before it can be added to the list.");
    }
    return Result;
}

native final function RequestButtonDockingUpdate(optional bool bImmediately)
{
    bImmediately;
}

native function int FindBestInsertionIndex(UICalloutButton ButtonToInsert, optional bool bSearchChildrenArray)
{
    ButtonToInsert;
    bSearchChildrenArray;
}

native final function UIEvent_CalloutButtonInputProxy GetCalloutInputProxy(optional bool bCreateIfNecessary)
{
    bCreateIfNecessary;
}

native function UICalloutButton CreateCalloutButton(name ButtonInputAlias, optional name ButtonName, optional bool bInsertChild = true)
{
    ButtonInputAlias;
    ButtonName;
    bInsertChild;
}

native final function GetAvailableCalloutButtonAliases(out array<name> AvailableAliases, optional LocalPlayer PlayerOwner)
{
    AvailableAliases;
    PlayerOwner;
}

event RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    local UICalloutButton ChildButton;
    
    RemovedChild(WidgetOwner, OldChild, ExclusionSet);
    ChildButton = UICalloutButton(OldChild);
    if (ChildButton != none)
    {
        ChildButton.__NotifyVisibilityChanged__Delegate = None;
        CalloutButtons.RemoveItem(ChildButton);
        SynchronizeInputAliases();
    }
    RequestButtonDockingUpdate();
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    local UICalloutButton ChildButton;
    local int InsertIndex;
    
    AddedChild(WidgetOwner, NewChild);
    ChildButton = UICalloutButton(NewChild);
    if (ChildButton != none && WidgetOwner == self)
    {
        ChildButton.bSupportsButtonRepeat = bSupportsButtonRepeat;
        ChildButton.__NotifyVisibilityChanged__Delegate = OnButtonVisibilityChanged;
        if (!bGeneratingInitialButtons)
        {
            if (CalloutButtons.Find(ChildButton) == -1)
            {
                InsertIndex = FindBestInsertionIndex(ChildButton, false);
                if (InsertIndex == -1)
                {
                    InsertIndex = CalloutButtons.Length;
                }
                CalloutButtons.InsertItem(InsertIndex, ChildButton);
            }
            ConfigureChildButton(ChildButton);
            SynchronizeInputAliases();
        }
    }
}

event SynchronizeInputAliases()
{
    local int AliasIdx;
    
    CalloutButtonAliases.Length = CalloutButtons.Length;
    for (AliasIdx = 0; AliasIdx < CalloutButtons.Length; AliasIdx++)
    {
        CalloutButtonAliases[AliasIdx] = CalloutButtons[AliasIdx].InputAliasTag;
    }
}

function PopulateCalloutButtonArray()
{
    local int ButtonIdx, AliasIdx;
    local UICalloutButton ChildButton;
    local array<UICalloutButton> TempArray;
    local bool bCreateButton;
    
    for (ButtonIdx = 0; ButtonIdx < Children.Length; ButtonIdx++)
    {
        ChildButton = UICalloutButton(Children[ButtonIdx]);
        if (ChildButton != none)
        {
            ChildButton.bSupportsButtonRepeat = bSupportsButtonRepeat;
            ChildButton.__NotifyVisibilityChanged__Delegate = OnButtonVisibilityChanged;
            TempArray[TempArray.Length] = ChildButton;
        }
    }
    CalloutButtons.Length = 0;
    for (AliasIdx = 0; AliasIdx < CalloutButtonAliases.Length; AliasIdx++)
    {
        bCreateButton = true;
        for (ButtonIdx = 0; ButtonIdx < TempArray.Length; ButtonIdx++)
        {
            ChildButton = TempArray[ButtonIdx];
            if (ChildButton.InputAliasTag == CalloutButtonAliases[AliasIdx])
            {
                bCreateButton = false;
                TempArray.Remove(ButtonIdx, 1);
                CalloutButtons[CalloutButtons.Length] = ChildButton;
                break;
            }
        }
        if (bCreateButton)
        {
            ChildButton = CreateCalloutButton(CalloutButtonAliases[AliasIdx], CalloutButtonAliases[AliasIdx]);
        }
    }
    for (ButtonIdx = 0; ButtonIdx < TempArray.Length; ButtonIdx++)
    {
        CalloutButtons[CalloutButtons.Length] = TempArray[ButtonIdx];
    }
}

defaultproperties
{
    ButtonTemplate="Default__UICalloutButtonPanel.CalloutButtonTemplate"
    ButtonLayout="CBLT_DockRight"
    ButtonPadding[1]=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Vertical")
    PrimaryStyle=(DefaultStyleTag="DefaultImageStyle",RequiredStyleClass="UIStyle_Image")
    DockTargets=(bLockWidthWhenDocked=True,bLockHeightWhenDocked=True)
    PrivateFlags=1024
    Position=(Value[1]=0.95,Value[3]=0.05)
    bNeverFocus=True
    EventProvider="Default__UICalloutButtonPanel.WidgetEventComponent"
}
