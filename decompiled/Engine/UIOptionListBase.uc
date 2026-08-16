class UIOptionListBase extends UIObject
    abstract
    native
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

const UIKEY_MoveCursorRight = 'UIKEY_MoveCursorRight';
const UIKEY_MoveCursorLeft = 'UIKEY_MoveCursorLeft';

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var UIStyleReference DecrementStyle;
var UIStyleReference IncrementStyle;
var const UIOptionListButton DecrementButton;
var const UIOptionListButton IncrementButton;
var const class<UIOptionListButton> OptionListButtonClass;
var(Appearance) UIScreenValue_Extent ButtonSpacing;
var(Components) const export editinline UIComp_DrawImage BackgroundImageComponent;
var(Components) const export editinline noclear UIComp_DrawString StringRenderComponent;
var(Sound) name IncrementCue;
var(Sound) name DecrementCue;
var(Appearance) bool bWrapOptions;
var(Data) UIDataStoreBinding DataSource;
var delegate<CreateCustomDecrementButton> __CreateCustomDecrementButton__Delegate;
var delegate<CreateCustomIncrementButton> __CreateCustomIncrementButton__Delegate;

function OnStateChanged(UIScreenObject Sender, int PlayerIndex, UIState NewlyActiveState, optional UIState PreviouslyActiveState)
{
    if (Sender == self && UIState_Enabled(NewlyActiveState) != none && UIState_Focused(PreviouslyActiveState) != none)
    {
        if (IncrementButton != none)
        {
            IncrementButton.DeactivateStateByClass(class'UIState_Pressed', PlayerIndex);
            IncrementButton.UpdateButtonState(PlayerIndex);
        }
        if (DecrementButton != none)
        {
            DecrementButton.DeactivateStateByClass(class'UIState_Pressed', PlayerIndex);
            DecrementButton.UpdateButtonState(PlayerIndex);
        }
    }
}

function bool OnButtonClicked(UIScreenObject Sender, int PlayerIndex)
{
    if (IsFocused(PlayerIndex) || SetFocus(none))
    {
        if (Sender == DecrementButton)
        {
            OnMoveSelectionLeft(PlayerIndex);
        }
        else
        {
            OnMoveSelectionRight(PlayerIndex);
        }
        return true;
    }
    return false;
}

function InitializeInternalControls()
{
    if (DecrementButton != none)
    {
        if (DecrementButton.BackgroundImageComponent != none)
        {
            DecrementButton.BackgroundImageComponent.StyleResolverTag = 'DecrementStyle';
        }
        DecrementButton.SetDockTarget(1, self, 1);
        DecrementButton.SetDockTarget(3, self, 3);
        DecrementButton.SetDockTarget(0, self, 0);
        DecrementButton.__OnClicked__Delegate = OnButtonClicked;
    }
    if (IncrementButton != none)
    {
        if (IncrementButton.BackgroundImageComponent != none)
        {
            IncrementButton.BackgroundImageComponent.StyleResolverTag = 'IncrementStyle';
        }
        IncrementButton.SetDockTarget(1, self, 1);
        IncrementButton.SetDockTarget(3, self, 3);
        IncrementButton.SetDockTarget(2, self, 2);
        IncrementButton.__OnClicked__Delegate = OnButtonClicked;
    }
}

event Initialized()
{
    Initialized();
    InitializeInternalControls();
}

function Created(UIObject CreatedWidget, UIScreenObject CreatorContainer)
{
    if (CreatedWidget == self)
    {
        InitializeInternalControls();
    }
}

native function OnMoveSelectionRight(int PlayerIndex)
{
    PlayerIndex;
}

native function OnMoveSelectionLeft(int PlayerIndex)
{
    PlayerIndex;
}

native function bool HasNextValue()
{
}

native function bool HasPrevValue()
{
}

native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1)
{
    out_BoundDataStores;
    BindingIndex;
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

delegate UIOptionListButton CreateCustomIncrementButton(UIOptionListBase ButtonOwner)
{
}

delegate UIOptionListButton CreateCustomDecrementButton(UIOptionListBase ButtonOwner)
{
}

defaultproperties
{
    DecrementStyle=(DefaultStyleTag="DefaultIncrementButtonStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    IncrementStyle=(DefaultStyleTag="DefaultDecrementButtonStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    DecrementButton="Default__UIOptionListBase.DecrementButtonTemplate"
    IncrementButton="Default__UIOptionListBase.IncrementButtonTemplate"
    OptionListButtonClass="UIOptionListButton"
    BackgroundImageComponent="Default__UIOptionListBase.BackgroundImageTemplate"
    StringRenderComponent="Default__UIOptionListBase.LabelStringRenderer"
    IncrementCue="SliderIncrement"
    DecrementCue="SliderDecrement"
    DataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Collection",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    PrivateFlags=1024
    bSupportsPrimaryStyle=False
    __OnCreate__Delegate="None"
    Position=(Value[2]=256.0,Value[3]=32.0,ScaleType[2]="EVALPOS_PixelOwner",ScaleType[3]="EVALPOS_PixelOwner")
    Children(0)="Default__UIOptionListBase.DecrementButtonTemplate"
    Children(1)="Default__UIOptionListBase.IncrementButtonTemplate"
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    DefaultStates(4)="UIState_Pressed"
    EventProvider="Default__UIOptionListBase.WidgetEventComponent"
    __NotifyActiveStateChanged__Delegate="None"
}
