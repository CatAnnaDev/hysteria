class UISlider extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStorePublisher);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Components) const export editinline noclear UIComp_DrawImage BackgroundImageComponent;
var(Components) const export editinline noclear UIComp_DrawImage SliderBarImageComponent;
var(Components) const export editinline noclear UIComp_DrawImage MarkerImageComponent;
var(Data) editconst UIDataStoreBinding DataSource;
var(Components) const export editinline UIComp_DrawStringSlider CaptionRenderComponent;
var(Data) UIRangeData SliderValue;
var(Appearance) bool bRenderCaption;
var(Appearance) EUIOrientation SliderOrientation;
var(Appearance) UIScreenValue_Extent BarSize;
var(Appearance) UIScreenValue_Extent MarkerHeight;
var(Appearance) UIScreenValue_Extent MarkerWidth;
var(Sound) name IncrementCue;
var(Sound) name DecrementCue;

final function OnStateChanged(UIScreenObject Sender, int PlayerIndex, UIState NewlyActiveState, optional UIState PreviouslyActiveState)
{
    if (Sender == self)
    {
        if (UIState_Pressed(NewlyActiveState) != none)
        {
            SetMouseCaptureOverride(true);
        }
        else if (UIState_Pressed(PreviouslyActiveState) != none)
        {
            SetMouseCaptureOverride(false);
        }
    }
}

final function SetMarkerImage(Surface NewImage)
{
    if (MarkerImageComponent != none)
    {
        BackgroundImageComponent.SetImage(NewImage);
    }
}

final function SetBarImage(Surface NewImage)
{
    if (SliderBarImageComponent != none)
    {
        SliderBarImageComponent.SetImage(NewImage);
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
    BackgroundImageComponent="Default__UISlider.SliderBackgroundImageTemplate"
    SliderBarImageComponent="Default__UISlider.SliderBarImageTemplate"
    MarkerImageComponent="Default__UISlider.SliderMarkerImageTemplate"
    DataSource=(Subscriber="None",RequiredFieldType="DATATYPE_RangeProperty",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    SliderValue=(CurrentValue=0.0,MinValue=0.0,MaxValue=100.0,NudgeValue=1.0,bIntRange=False)
    bRenderCaption=True
    BarSize=(Value=32.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal")
    MarkerHeight=(Value=16.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Vertical")
    MarkerWidth=(Value=16.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal")
    IncrementCue="SliderIncrement"
    DecrementCue="SliderDecrement"
    PrimaryStyle=(DefaultStyleTag="DefaultSliderStyle",RequiredStyleClass="UIStyle_Image")
    bSupportsPrimaryStyle=False
    Position=(Value[3]=32.0,ScaleType[3]="EVALPOS_PixelOwner")
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    DefaultStates(4)="UIState_Pressed"
    EventProvider="Default__UISlider.WidgetEventComponent"
    __NotifyActiveStateChanged__Delegate="None"
}
