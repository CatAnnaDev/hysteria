class UIScrollbarButton extends UIButton
    native
    notplaceable
    config(UI)
    within UIScrollbar
    hidecategories(Object,UIRoot,Object);

defaultproperties
{
    BackgroundImageComponent="Default__UIScrollbarButton.BackgroundImageTemplate"
    DockTargets=(bLockWidthWhenDocked=True,bLockHeightWhenDocked=True)
    PrivateFlags=47
    EventProvider="Default__UIScrollbarButton.WidgetEventComponent"
}
