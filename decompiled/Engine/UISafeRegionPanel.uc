class UISafeRegionPanel extends UIContainer
    native
    placeable
    config(Game)
    hidecategories(Object,UIRoot,Object);

enum ESafeRegionType
{
    ESRT_FullRegion,
    ESRT_TextSafeRegion,
};

var(SafeRegion) ESafeRegionType RegionType;
var(SafeRegion) config editinline float RegionPercentages[2];
var(SafeRegion) bool bForce4x3AspectRatio;
var(SafeRegion) bool bUseFullRegionIn4x3;
var(SafeRegion) bool bPrimarySafeRegion;

defaultproperties
{
    RegionPercentages=0.9
    RegionPercentages[1]=0.8
    bPrimarySafeRegion=True
    EventProvider="Default__UISafeRegionPanel.WidgetEventComponent"
}
