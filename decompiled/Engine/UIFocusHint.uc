class UIFocusHint extends UILabel
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object);

event RemovedFromParent(UIScreenObject WidgetOwner)
{
    RemovedFromParent(WidgetOwner);
    ClearDockTargets();
}

defaultproperties
{
    StringRenderComponent="Default__UIFocusHint.LabelStringRenderer"
    DockTargets=(bLockWidthWhenDocked=True)
    EventProvider="Default__UIFocusHint.WidgetEventComponent"
}
