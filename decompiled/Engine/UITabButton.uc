class UITabButton extends UILabelButton
    native
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var() editconst editinline UITabPage TabPage;
var delegate<IsActivationAllowed> __IsActivationAllowed__Delegate;

function OnStateChanged(UIScreenObject Sender, int PlayerIndex, UIState NewlyActiveState, optional UIState PreviouslyActiveState)
{
    local int StateIndex;
    
    if (Sender == self && UIState_Focused(NewlyActiveState) != none)
    {
        while (IsTargeted(PlayerIndex, StateIndex))
        {
            if (!DeactivateState(StateStack[StateIndex], PlayerIndex))
            {
                LogInternal("(" $ string(Name) $ ") UITabButton::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Unable to deactivate targeted state at index" @ string(StateIndex) $ ":" @ string(StateStack[StateIndex]));
                break;
            }
        }
    }
}

function UITabPage GetTabPage()
{
    return TabPage;
}

native final function bool IsTargeted(optional int PlayerIndex = GetBestPlayerIndex(), optional out int StateIndex)
{
    PlayerIndex;
    StateIndex;
}

native final function bool CanActivateButton(int PlayerIndex)
{
    PlayerIndex;
}

event RemovedFromParent(UIScreenObject WidgetOwner)
{
    RemovedFromParent(WidgetOwner);
    __OnClicked__Delegate = None;
}

event RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    RemovedChild(WidgetOwner, OldChild, ExclusionSet);
    if (WidgetOwner == self && OldChild == TabPage)
    {
        TabPage = none;
    }
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    local UITabPage ChildPage;
    
    AddedChild(WidgetOwner, NewChild);
    if (WidgetOwner == self)
    {
        ChildPage = UITabPage(NewChild);
        if (ChildPage != none)
        {
            if (TabPage != none && TabPage != ChildPage)
            {
                LogInternal(GetWidgetPathName() @ "received new tab page but has existing tab page.  Removing existing page from Children array:" @ TabPage.GetWidgetPathName());
                RemoveChild(TabPage);
            }
            TabPage = ChildPage;
            ChildPage.TabIndex = 0;
        }
    }
}

delegate bool IsActivationAllowed(UITabButton Sender, int PlayerIndex)
{
}

defaultproperties
{
    StringRenderComponent="Default__UITabButton.LabelStringRenderer"
    BackgroundImageComponent="Default__UITabButton.BackgroundImageTemplate"
    PrivateFlags=931
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    DefaultStates(4)="UIState_Pressed"
    DefaultStates(5)="UIState_TargetedTab"
    EventProvider="Default__UITabButton.WidgetEventComponent"
    __NotifyActiveStateChanged__Delegate="None"
}
