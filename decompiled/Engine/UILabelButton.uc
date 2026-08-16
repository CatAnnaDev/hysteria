class UILabelButton extends UIButton
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Data) UIDataStoreBinding CaptionDataSource;
var(Components) const export editinline noclear UIComp_DrawString StringRenderComponent;

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

native final function SetTextAlignment(EUIAlignment Horizontal, EUIAlignment Vertical)
{
    Horizontal;
    Vertical;
}

final event string GetCaption()
{
    return StringRenderComponent.GetValue();
}

native function SetCaption(string NewText)
{
    NewText;
}

defaultproperties
{
    CaptionDataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="Button Text",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    StringRenderComponent="Default__UILabelButton.LabelStringRenderer"
    BackgroundImageComponent="Default__UILabelButton.BackgroundImageTemplate"
    PrimaryStyle=(DefaultStyleTag="DefaultLabelButtonStyle",RequiredStyleClass="UIStyle_Combo")
    bSupportsFocusHint=True
    EventProvider="Default__UILabelButton.WidgetEventComponent"
}
