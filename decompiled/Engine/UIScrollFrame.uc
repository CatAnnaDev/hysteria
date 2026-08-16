class UIScrollFrame extends UIContainer
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var(Components) const export editinline UIComp_DrawImage StaticBackgroundImage;
var const UIScrollbar ScrollbarHorizontal;
var const UIScrollbar ScrollbarVertical;
var(ZDebug) transient editconst editinline UIScreenValue_Extent HorizontalClientRegion;
var(ZDebug) transient editconst editinline UIScreenValue_Extent VerticalClientRegion;
var transient Vector2D ClientRegionPosition;
var transient float FrameBounds[4];
var const transient bool bRefreshScrollbars;
var const transient bool bRecalculateClientRegion;

private final event ScrollZoneClicked(UIScrollbar Sender, float PositionPerc, int PlayerIndex)
{
    local float MarkerPosition, TargetValue, VisibleRegionPosition[4], VisibleRegionSize;
    
    if (Sender != none && Sender == ScrollbarVertical || Sender == ScrollbarHorizontal)
    {
        TargetValue = -1.0;
        GetClipRegion(VisibleRegionPosition[0], VisibleRegionPosition[1], VisibleRegionPosition[2], VisibleRegionPosition[3]);
        VisibleRegionSize = (Sender.ScrollbarOrientation == 0 ? VisibleRegionPosition[2] - VisibleRegionPosition[0] : VisibleRegionPosition[3] - VisibleRegionPosition[1]);
        MarkerPosition = Sender.GetMarkerPosPercent();
        if (PositionPerc > MarkerPosition)
        {
            TargetValue = GetClientRegionPosition(Sender.ScrollbarOrientation) - VisibleRegionSize;
        }
        else if (PositionPerc < MarkerPosition)
        {
            TargetValue = GetClientRegionPosition(Sender.ScrollbarOrientation) + VisibleRegionSize;
        }
        if (TargetValue != float(-1))
        {
            SetClientRegionPosition(Sender.ScrollbarOrientation, TargetValue);
        }
    }
}

final function OnChildRepositioned(UIScreenObject Sender)
{
    if (Sender != none && Sender != ScrollbarVertical && Sender != ScrollbarHorizontal)
    {
        ReapplyFormatting(GetScene().bResolvingScenePositions);
    }
}

event RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    RemovedChild(WidgetOwner, OldChild, ExclusionSet);
    if (OldChild != none && OldChild.__NotifyPositionChanged__Delegate == OnChildRepositioned)
    {
        OldChild.__NotifyPositionChanged__Delegate = None;
    }
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    AddedChild(WidgetOwner, NewChild);
    if (NewChild != none && NewChild != ScrollbarVertical && NewChild != ScrollbarHorizontal)
    {
        NewChild.__NotifyPositionChanged__Delegate = OnChildRepositioned;
    }
}

native final function float GetVisibleRegionPercentage(EUIOrientation Orientation)
{
    Orientation;
}

native function GetClipRegion(out float MinX, out float MinY, out float MaxX, out float MaxY)
{
    MinX;
    MinY;
    MaxX;
    MaxY;
}

native final function Vector2D GetClientRegionSizeVector()
{
}

native final function Vector2D GetClientRegionPositionVector()
{
}

native final function float GetClientRegionSize(EUIOrientation Orientation)
{
    Orientation;
}

native final function float GetClientRegionPosition(EUIOrientation Orientation)
{
    Orientation;
}

native final function bool SetClientRegionPositionVector(Vector2D NewPosition)
{
    NewPosition;
}

native final function bool SetClientRegionPosition(EUIOrientation Orientation, float NewPosition)
{
    Orientation;
    NewPosition;
}

native final function bool ScrollRegion(UIScrollbar Sender, float PositionChange, optional bool bPositionMaxed)
{
    Sender;
    PositionChange;
    bPositionMaxed;
}

native final function ReapplyFormatting(optional bool bImmediately)
{
    bImmediately;
}

native final function RefreshScrollbars(optional bool bImmediately)
{
    bImmediately;
}

defaultproperties
{
    ScrollbarHorizontal="Default__UIScrollFrame.HorzScrollbarTemplate"
    ScrollbarVertical="Default__UIScrollFrame.VertScrollbarTemplate"
    VerticalClientRegion=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Vertical")
    bRefreshScrollbars=True
    bRecalculateClientRegion=True
    PrimaryStyle=(DefaultStyleTag="DefaultImageStyle",RequiredStyleClass="UIStyle_Image")
    bSupportsPrimaryStyle=False
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    EventProvider="Default__UIScrollFrame.WidgetEventComponent"
}
