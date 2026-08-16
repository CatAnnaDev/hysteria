class UICheckbox extends UIButton
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Sound) name CheckedCue;
var(Sound) name UncheckedCue;
var(Data) UIDataStoreBinding ValueDataSource;
var(Components) const export editinline noclear UIComp_DrawImage CheckedImageComponent;
var(Value) bool bIsChecked;

native function SetValue(bool bShouldBeChecked, optional int PlayerIndex = -1)
{
    bShouldBeChecked;
    PlayerIndex;
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

final function bool IsChecked()
{
    return bIsChecked;
}

final function SetCheckImage(Surface NewImage)
{
    if (CheckedImageComponent != none)
    {
        CheckedImageComponent.SetImage(NewImage);
    }
}

defaultproperties
{
    CheckedCue="CheckboxChecked"
    UncheckedCue="CheckboxUnchecked"
    ValueDataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    CheckedImageComponent="Default__UICheckbox.CheckedImageTemplate"
    BackgroundImageComponent="Default__UICheckbox.BackgroundImageTemplate"
    ClickedCue="None"
    EventProvider="Default__UICheckbox.WidgetEventComponent"
}
