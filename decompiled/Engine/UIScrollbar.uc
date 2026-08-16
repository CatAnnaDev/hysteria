class UIScrollbar extends UIObject
    native
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object,Object,UIScreenObject,UIObject,Focus,Presentation,Splitscreen,States);

var(Components) const export editinline noclear UIComp_DrawImage BackgroundImageComponent;
var const UIScrollbarButton IncrementButton;
var const UIScrollbarButton DecrementButton;
var const UIScrollbarMarkerButton MarkerButton;
var UIStyleReference IncrementStyle;
var UIStyleReference DecrementStyle;
var UIStyleReference MarkerStyle;
var transient float NudgeValue;
var(Interaction) float NudgeMultiplier;
var transient float NudgePercent;
var transient float MarkerPosPercent;
var transient float MarkerSizePercent;
var(Appearance) UIScreenValue_Extent BarWidth;
var(Appearance) UIScreenValue_Extent MinimumMarkerSize;
var(Appearance) UIScreenValue_Extent ButtonsExtent;
var(Appearance) EUIOrientation ScrollbarOrientation;
var(Appearance) bool bAddCornerPadding;
var transient bool bInitializeMarker;
var transient UIScreenValue_Position MousePosition;
var transient float MousePositionDelta;
var delegate<OnScrollActivity> __OnScrollActivity__Delegate;
var delegate<OnClickedScrollZone> __OnClickedScrollZone__Delegate;

final function float GetMarkerSizePercent()
{
    return MarkerSizePercent;
}

final function float GetMarkerPosPercent()
{
    return MarkerPosPercent;
}

final function float GetNudgePercent()
{
    return NudgePercent;
}

final function float GetNudgeValue()
{
    return NudgeValue;
}

event PostInitialize()
{
    PostInitialize();
    ConditionalPropagateEnabledState(GetBestPlayerIndex());
}

event Initialized()
{
    Initialized();
    IncrementButton.__OnPressed__Delegate = ScrollIncrement;
    IncrementButton.__OnPressRepeat__Delegate = ScrollIncrement;
    DecrementButton.__OnPressed__Delegate = ScrollDecrement;
    DecrementButton.__OnPressRepeat__Delegate = ScrollDecrement;
    MarkerButton.__OnPressed__Delegate = DragScrollBegin;
    MarkerButton.__OnPressRelease__Delegate = DragScrollEnd;
    MarkerButton.__OnButtonDragged__Delegate = DragScroll;
}

native final function DragScroll(UIScrollbarMarkerButton Sender, int PlayerIndex)
{
    Sender;
    PlayerIndex;
}

native final function DragScrollEnd(UIScreenObject Sender, int PlayerIndex)
{
    Sender;
    PlayerIndex;
}

native final function DragScrollBegin(UIScreenObject Sender, int PlayerIndex)
{
    Sender;
    PlayerIndex;
}

native final function ScrollDecrement(UIScreenObject Sender, int PlayerIndex)
{
    Sender;
    PlayerIndex;
}

native final function ScrollIncrement(UIScreenObject Sender, int PlayerIndex)
{
    Sender;
    PlayerIndex;
}

native final function EnableCornerPadding(bool FlagValue)
{
    FlagValue;
}

native final function SetNudgeSizePixels(float NudgePixels)
{
    NudgePixels;
}

native final function SetNudgeSizePercent(float NudgePercentage)
{
    NudgePercentage;
}

native final function SetMarkerPosition(float PositionPercentage)
{
    PositionPercentage;
}

native final function SetMarkerSize(float SizePercentage)
{
    SizePercentage;
}

native final function float GetScrollZoneWidth()
{
}

native final function float GetScrollZoneExtent(optional out float ScrollZoneStart)
{
    ScrollZoneStart;
}

native final function float GetMarkerButtonPosition()
{
}

delegate OnClickedScrollZone(UIScrollbar Sender, float PositionPerc, int PlayerIndex)
{
}

delegate bool OnScrollActivity(UIScrollbar Sender, float PositionChange, optional bool bPositionMaxed = false)
{
}

defaultproperties
{
    BackgroundImageComponent="Default__UIScrollbar.ScrollBarBackgroundImageTemplate"
    IncrementStyle=(DefaultStyleTag="DefaultScrollbarIncrement",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    DecrementStyle=(DefaultStyleTag="DefaultScrollbarDecrement",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    MarkerStyle=(DefaultStyleTag="DefaultScrollBarStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    NudgeValue=1.0
    NudgeMultiplier=1.0
    MarkerSizePercent=1.0
    BarWidth=(Value=16.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal")
    MinimumMarkerSize=(Value=12.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Vertical")
    ButtonsExtent=(Value=16.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Vertical")
    ScrollbarOrientation="UIORIENT_Vertical"
    bAddCornerPadding=True
    bInitializeMarker=True
    MousePosition=(Value=0.0,Value[1]=0.0,ScaleType="EVALPOS_PixelOwner",ScaleType[1]="EVALPOS_PixelOwner")
    PrimaryStyle=(DefaultStyleTag="DefaultScrollZoneStyle",RequiredStyleClass="UIStyle_Image")
    PrivateFlags=1044
    bSupportsPrimaryStyle=False
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Pressed"
    DefaultStates(4)="UIState_Active"
    EventProvider="Default__UIScrollbar.WidgetEventComponent"
}
