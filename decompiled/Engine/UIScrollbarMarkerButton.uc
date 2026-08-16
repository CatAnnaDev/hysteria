class UIScrollbarMarkerButton extends UIScrollbarButton
    native
    notplaceable
    config(UI)
    within UIScrollbar
    hidecategories(Object,UIRoot,Object);

var delegate<OnButtonDragged> __OnButtonDragged__Delegate;

delegate OnButtonDragged(UIScrollbarMarkerButton Sender, int PlayerIndex)
{
}

defaultproperties
{
    BackgroundImageComponent="Default__UIScrollbarMarkerButton.BackgroundImageTemplate"
    EventProvider="Default__UIScrollbarMarkerButton.WidgetEventComponent"
}
