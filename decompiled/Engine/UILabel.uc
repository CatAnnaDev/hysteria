class UILabel extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStoreSubscriber,UIStringRenderer);

var const native noexport Pointer VfTable_IUIDataStoreSubscriber;
var const native noexport Pointer VfTable_IUIStringRenderer;
var(Data) UIDataStoreBinding DataSource;
var(Components) const export editinline noclear UIComp_DrawString StringRenderComponent;
var(Components) const export editinline UIComp_DrawImage LabelBackground;

final function IgnoreMarkup(bool bShouldIgnoreMarkup)
{
    StringRenderComponent.bIgnoreMarkup = bShouldIgnoreMarkup;
}

function string GetValue()
{
    return StringRenderComponent.GetValue();
}

final function SetArrayValue(array<string> ValueArray)
{
    local string Str;
    
    JoinArray(ValueArray, Str, "\n", false);
    SetValue(Str);
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

native final function SetTextAlignment(EUIAlignment Horizontal, EUIAlignment Vertical)
{
    Horizontal;
    Vertical;
}

native final function SetValue(string NewText)
{
    NewText;
}

defaultproperties
{
    DataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="Initial Label Text",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    StringRenderComponent="Default__UILabel.LabelStringRenderer"
    PrimaryStyle=(RequiredStyleClass="UIStyle_Combo")
    bSupportsPrimaryStyle=False
    Position=(Value[2]=100.0,Value[3]=40.0,ScaleType[2]="EVALPOS_PixelOwner",ScaleType[3]="EVALPOS_PixelOwner")
    EventProvider="Default__UILabel.WidgetEventComponent"
}
