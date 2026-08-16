class UIImage extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Data) UIDataStoreBinding ImageDataSource;
var(Components) const export editinline noclear UIComp_DrawImage ImageComponent;

native final function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1)
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

final function SetValue(Surface NewImage)
{
    ImageComponent.SetImage(NewImage);
}

defaultproperties
{
    ImageDataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    ImageComponent="Default__UIImage.ImageComponentTemplate"
    PrimaryStyle=(DefaultStyleTag="DefaultImageStyle",RequiredStyleClass="UIStyle_Image")
    bSupportsPrimaryStyle=False
    Position=(Value[2]=50.0,Value[3]=50.0,ScaleType[2]="EVALPOS_PixelOwner",ScaleType[3]="EVALPOS_PixelOwner")
    EventProvider="Default__UIImage.WidgetEventComponent"
}
