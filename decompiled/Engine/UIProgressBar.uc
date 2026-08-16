class UIProgressBar extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Components) const export editinline noclear UIComp_DrawImage BackgroundImageComponent;
var(Components) const export editinline noclear UIComp_DrawImage FillImageComponent;
var(Components) const export editinline noclear UIComp_DrawImage OverlayImageComponent;
var(Appearance) bool bDrawOverlay;
var(Data) editconst UIDataStoreBinding DataSource;
var(Data) UIRangeData ProgressBarValue;
var(Appearance) EUIOrientation ProgressBarOrientation;

final function SetOverlayImage(Surface NewImage)
{
    if (OverlayImageComponent != none)
    {
        OverlayImageComponent.SetImage(NewImage);
    }
}

final function SetFillImage(Surface NewImage)
{
    if (FillImageComponent != none)
    {
        FillImageComponent.SetImage(NewImage);
    }
}

final function SetBackgroundImage(Surface NewImage)
{
    if (BackgroundImageComponent != none)
    {
        BackgroundImageComponent.SetImage(NewImage);
    }
}

native final function float GetValue(optional bool bPercentageValue)
{
    bPercentageValue;
}

native final function bool SetValue(coerce float NewValue, optional bool bPercentageValue)
{
    NewValue;
    bPercentageValue;
}

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

defaultproperties
{
    BackgroundImageComponent="Default__UIProgressBar.ProgressBarBackgroundImageTemplate"
    FillImageComponent="Default__UIProgressBar.ProgressBarFillImageTemplate"
    OverlayImageComponent="Default__UIProgressBar.ProgressBarOverlayImageTemplate"
    DataSource=(Subscriber="None",RequiredFieldType="DATATYPE_RangeProperty",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    ProgressBarValue=(CurrentValue=33.0,MinValue=0.0,MaxValue=100.0,NudgeValue=1.0,bIntRange=False)
    PrimaryStyle=(DefaultStyleTag="DefaultSliderStyle",RequiredStyleClass="UIStyle_Image")
    bSupportsPrimaryStyle=False
    Position=(Value[3]=32.0,ScaleType[3]="EVALPOS_PixelOwner")
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    DefaultStates(4)="UIState_Pressed"
    EventProvider="Default__UIProgressBar.WidgetEventComponent"
}
