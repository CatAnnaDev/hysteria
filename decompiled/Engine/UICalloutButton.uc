class UICalloutButton extends UILabelButton
    native
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var const config string DefaultMarkupStringTemplate;
var const config name CalloutDataStoreTag;
var(Data) const editconst name InputAliasTag;
var(Appearance) const EUIAlignment IconAlignment;
var transient bool bSupportsButtonRepeat;
var const config bool bPlayErrorSoundWhenDisabled;

function UIEvent_CalloutButtonInputProxy GetCalloutInputProxy(optional bool bCreateIfNecessary)
{
    local UICalloutButtonPanel PanelOwner;
    local UIEvent_CalloutButtonInputProxy InputProxy;
    
    PanelOwner = GetPanelOwner();
    if (PanelOwner != none)
    {
        InputProxy = PanelOwner.GetCalloutInputProxy(bCreateIfNecessary);
    }
    return InputProxy;
}

protected function bool VerifyDefaultMarkupString()
{
    local bool bResult;
    
    if (InStr(DefaultMarkupStringTemplate, "`InputAliasTag`") != -1)
    {
        bResult = true;
    }
    return bResult;
}

function UICalloutButtonPanel GetPanelOwner()
{
    return UICalloutButtonPanel(GetOwner());
}

event RemovedFromParent(UIScreenObject WidgetOwner)
{
    local UIEvent_CalloutButtonInputProxy InputProxy;
    
    RemovedFromParent(WidgetOwner);
    InputProxy = GetCalloutInputProxy();
    UnsubscribeFromInputProxy(InputProxy);
}

event PostInitialize()
{
    local string CurrentMarkup;
    local UIEvent_CalloutButtonInputProxy InputProxy;
    
    PostInitialize();
    CurrentMarkup = GenerateCompleteCaptionMarkup();
    if (CurrentMarkup != "" && CurrentMarkup != CaptionDataSource.MarkupString)
    {
        SetDataStoreBinding(CurrentMarkup);
    }
    InputProxy = GetCalloutInputProxy(true);
    SubscribeToInputProxy(InputProxy);
}

event string GenerateCompleteCaptionMarkup(optional name InputAlias)
{
    local string IconMarkup, CurrentMarkup, NewMarkup, CalloutMarkupString;
    
    CurrentMarkup = GetDataStoreBinding();
    CalloutMarkupString = GetCalloutMarkupString();
    if (CurrentMarkup != "" && InStr(CurrentMarkup, "<Color:/>") == -1)
    {
        CalloutMarkupString = Repl(Repl(CalloutMarkupString, "<Color:R=1,B=1,G=1>", ""), "<Color:/>", "");
    }
    if (InputAliasTag != 'None')
    {
        if (CurrentMarkup != "")
        {
            CurrentMarkup = Repl(CurrentMarkup, "`InputAliasTag`", string(InputAliasTag));
        }
        switch (IconAlignment)
        {
            case 0:
                IconMarkup = GetCalloutMarkupString(InputAlias);
                NewMarkup = IconMarkup $ Repl(CurrentMarkup, CalloutMarkupString, "");
                break;
            case 1:
                break;
            case 2:
                IconMarkup = GetCalloutMarkupString(InputAlias);
                NewMarkup = Repl(CurrentMarkup, CalloutMarkupString, "") $ IconMarkup;
                break;
            case 3:
                if (InputAlias != 'None' && InStr(CurrentMarkup, string(InputAliasTag)) != -1)
                {
                    NewMarkup = Repl(CurrentMarkup, string(InputAliasTag), string(InputAlias));
                }
                break;
            default:
        }
    }
    else if (InputAlias != 'None' && CurrentMarkup != "" && InStr(CurrentMarkup, "`InputAliasTag`") != -1)
    {
        NewMarkup = Repl(CurrentMarkup, "`InputAliasTag`", string(InputAlias));
    }
    else
    {
        NewMarkup = GetCalloutMarkupString(InputAlias);
    }
    return NewMarkup;
}

event string GetCalloutMarkupString(optional name AlternateInputAlias)
{
    local string Result;
    
    if (InputAliasTag != 'None' || AlternateInputAlias != 'None')
    {
        Result = "<Color:R=1,B=1,G=1>" $ Repl(VerifyDefaultMarkupString() ? DefaultMarkupStringTemplate : "<" $ string(GetCalloutDataStoreName()) $ ":`InputAliasTag`>", "`InputAliasTag`", string(AlternateInputAlias == 'None' ? InputAliasTag : AlternateInputAlias)) $ "<Color:/>";
    }
    return Result;
}

event name GetCalloutDataStoreName()
{
    return CalloutDataStoreTag != 'None' ? CalloutDataStoreTag : 'ButtonCallouts';
}

event bool SetInputAlias(name NewInputAlias)
{
    local bool bResult;
    local string CurrentMarkup, NewMarkup;
    
    if (NewInputAlias != 'None')
    {
        CurrentMarkup = GetDataStoreBinding();
        NewMarkup = GenerateCompleteCaptionMarkup(NewInputAlias);
        if (NewMarkup != "")
        {
            SetDataStoreBinding(NewMarkup, 100 - 1);
            if (CaptionDataSource.MarkupString == NewMarkup)
            {
                SetInputTag(NewInputAlias);
                bResult = true;
            }
            else
            {
                SetDataStoreBinding(CurrentMarkup, 100 - 1);
            }
        }
    }
    return bResult;
}

native function bool OnReceivedInputKey(out const InputEventParameters EventParms)
{
    EventParms;
}

native final function bool UnsubscribeFromInputProxy(UIEvent_CalloutButtonInputProxy InputProxy, optional bool bUpdateProxyOutputLinks = true, optional int PlayerIndex = -1)
{
    InputProxy;
    bUpdateProxyOutputLinks;
    PlayerIndex;
}

native final function bool SubscribeToInputProxy(UIEvent_CalloutButtonInputProxy InputProxy, optional bool bUpdateProxyOutputLinks = true, optional int PlayerIndex = -1)
{
    InputProxy;
    bUpdateProxyOutputLinks;
    PlayerIndex;
}

native protected final function SetInputTag(name NewInputAlias)
{
    NewInputAlias;
}

native final function UIDataStore_InputAlias GetCalloutDataStore(optional LocalPlayer AlternatePlayer)
{
    AlternatePlayer;
}

defaultproperties
{
    DefaultMarkupStringTemplate="<ButtonCallouts:`InputAliasTag`>"
    StringRenderComponent="Default__UICalloutButton.LabelStringRenderer"
    BackgroundImageComponent="Default__UICalloutButton.BackgroundImageTemplate"
    DockTargets=(bLockWidthWhenDocked=True)
    PrivateFlags=640
    bNeverFocus=True
    bOverrideInputOrder=True
    EventProvider="Default__UICalloutButton.WidgetEventComponent"
    __OnRawInputKey__Delegate="None"
}
