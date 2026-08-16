class UIEditBox extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Data) UIDataStoreBinding DataSource;
var(Components) const export editinline noclear UIComp_DrawStringEditbox StringRenderComponent;
var(Components) const export editinline UIComp_DrawImage BackgroundImageComponent;
var(Data) const localized string InitialValue;
var(Data) bool bReadOnly;
var(Data) bool bPasswordMode;
var(Data) int MaxCharacters;
var(Data) EEditBoxCharacterSet CharacterSet;
var delegate<OnSubmitText> __OnSubmitText__Delegate;

final function IgnoreMarkup(bool bShouldIgnoreMarkup)
{
    StringRenderComponent.bIgnoreMarkup = bShouldIgnoreMarkup;
}

function SetReadOnly(bool bShouldBeReadOnly)
{
    bReadOnly = bShouldBeReadOnly;
    if (EventProvider != none)
    {
        if (bReadOnly)
        {
            EventProvider.DisabledEventAliases.AddItem('Consume');
        }
        else
        {
            EventProvider.DisabledEventAliases.RemoveItem('Consume');
        }
    }
}

final function bool IsReadOnly()
{
    return bReadOnly;
}

event Initialized()
{
    Initialized();
    if (EventProvider != none)
    {
        if (bReadOnly)
        {
            EventProvider.DisabledEventAliases.AddItem('Consume');
        }
        else
        {
            EventProvider.DisabledEventAliases.RemoveItem('Consume');
        }
    }
}

native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1)
{
    out_BoundDataStores;
    BindingIndex;
}

native final function ClearBoundDataStores()
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

native function int CalculateCaretPositionFromCursorLocation(optional int PlayerIndex = GetBestPlayerIndex())
{
    PlayerIndex;
}

native final function string GetValue(optional bool bReturnUserText = true)
{
    bReturnUserText;
}

native final function SetValue(string NewText, optional int PlayerIndex = GetBestPlayerIndex(), optional bool bSkipNotification)
{
    NewText;
    PlayerIndex;
    bSkipNotification;
}

final function SetBackgroundImage(Surface NewImage)
{
    if (BackgroundImageComponent != none)
    {
        BackgroundImageComponent.SetImage(NewImage);
    }
}

delegate bool OnSubmitText(UIEditBox Sender, int PlayerIndex)
{
}

defaultproperties
{
    DataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    StringRenderComponent="Default__UIEditBox.EditboxStringRenderer"
    BackgroundImageComponent="Default__UIEditBox.EditboxBackgroundTemplate"
    InitialValue="Initial Editbox Value"
    PrimaryStyle=(DefaultStyleTag="DefaultEditboxStyle",RequiredStyleClass="UIStyle_Combo")
    bSupportsPrimaryStyle=False
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    DefaultStates(4)="UIState_Pressed"
    EventProvider="Default__UIEditBox.WidgetEventComponent"
}
